--Maria Colgan - Oracle Product Manager

/*Scanario 1 - Sales Report is suddenly slow*/
--1. first find the query in question
--2. query has join with one equality predicate and access predicate as below
select p.prod_name,
sum(quantity_sold)
from sales s, products p 
where s.prod_id = p.prod_id   --equality predicate
and s.time_id = '3-Nov-2022'  --access predicate 
group by p.prod_name;

--3. find number of rows in each joining table
select count(1) from sales;
select count(1) from products;
 
--Explain plan shows actual join used is Nested Loop and Expected join is Hash

--Check Rows in Explain Plan will show if any Cardinality Misestimate

--Check if joining tables are paritioned
select table_name,partitioned
from user_tables
where table_name in ('SALES','PRODUCTS');

--Where clause has Time_ID access predicate, check if table has stale stats
declare 
rv RAW(32);
dt DATE;
Begin
select high_value into rv
from user_tab_col_statistics
where table_name = 'SALES'
and column_name = '3-Nov-2022' --same from where clause

dbms_stats.convert_raw_value(rv,dt);
dbms_output.put_line(to_char(dt,'DD-MMM-YYYY'));
END;
/

--here its showing 31-Aug-2022

--Optimizer checks if where clause access predicate matches, 
--if not then it prorates the row cardinality based on differences between where clause access predicate and actual stats
--If further the difference between stat and where clause predicate then cardinality misestimate

--Problem found out is Out of Range Error - Optimizer refreshes Stats where 10% of table data is changed 

--Solution is Change Staleness Threshold for the table in question, this will recover the cardinality misestimate
begin
dbms_stats.set_table_prefs('SH','SALES','STALE_PERCENT','1');
dbms_stats.gather_table_stats('SH','SALES');
end; 
/

--alternate solution is if table is paritioned, then copy stats across partitions
begin
dbms_stats.copy_table_stats('SH','SALES','SALES_10_2021','SALES_11_2021'));
end;
/

/*Scenario 2 Index not used*/
--Check out sql statement in question
select s.comment
from sales s
where s.prod_id = 141
and s.cust_id < 8938;

--Check table data
select count(*) from sales; --bulky table millions of rows

--Check table partitions
select table_name,partitioned
from user_tables
where table_name = 'SALES';

--Check table statistics if Stale Stats = NO

select table_name, stale_stats
from user_tab_statistics
where table_name = 'SALES';

--Check what indexes if Stale Stats = NO
select index_name, stale_stats
from user_ind_statistics
where table_name = 'SALES';

--Check Indexes Leaf Blocks, Size
select index_name,leaf_blocks,blevel
from user_indexes
where table_name = 'SALES';
--if there are high number of leaf_blocks, blevel, optimizer will go for lower no. of leaf blocks for faster operation
--There are 2 indexes on this table 
PROD_CUST_IND (Prod_ID,Cust_ID)
PROD_CUST_COM_IND (Prod_ID,Comment,Cust_ID) --Order of columns in indexes has lot of impact on how Optimizer choose the access method

--Formuala for Cost of INDEX RANGE SCAN
--blevel+(cardinality/number of rows)*lead_blocks --find this for both indexes


--Check Explain Plan Access and Filter Predicate
select s.comment
from sales s
where s.prod_id = 141 
and s.cust_id < 8938;

--Access Predicate is s.prod_id = 141 and s.cust_id < 8938
--Filter Predicate is s.cust_id < 8938
--CUST_ID is there in both Access and Predicate
--Since CUST_ID is also used for FILTER, so ACCES Predicate is more of only on PROD_ID

--ACCESS is WHERE CLAUSE Predicate is for Data Retrieval
--FILTER is WHERE CLAUSE Predicate is Data Retrieval and then FILTER (Requires Additional Process on CPU to Retrieve and then Filter)

--Solution is create additional Index for leading edge columns
create index PROD_CUST_COM_IND2 on SALES(prod_id,cust_id,comment); --this is how optimizer will choose faster access plan 


/*Cardinality estimate is Miscalculated*/

Formula for Cardinality is = Total No. of Rows/NDV of Columns (Number of Distinct Values)

--1. Find Stale Statistics
--2. Check Data Skews - Gather Histograms as part of STATS Gather (Distribution of NDVs across all number of rows)
--3. Multiple WHERE clause predicates eg. where state = 'NY' and country = 'USA' if where clause predicates are corelated, optimizer cost redeces
     --However to inform optimizer about this corelation, use Extended Statistics via DBMS_STATS Package
--4. FUNCTION used in WHERE clause eg. WHERE UPPER(NAME) = 'XYZ' create function based index 
    --(11g onwards - you can use Extended Statistics via DBMS_STATS Package and Mark function based index 'INVISIBLE' )
 	 