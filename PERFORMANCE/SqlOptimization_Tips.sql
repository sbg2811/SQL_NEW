----#Given below are few ways Performance of query can be imporved#

----#1. REGEXP_LIKE instead of LIKE clause
select * from products
where lower(item_name) LIKE '%samsung%'
OR where lower(item_name) LIKE '%iphone%'
OR where lower(item_name) LIKE '%moto%'
OR where lower(item_name) LIKE '%nokia%'; 

select * from phones
where REGEXP_LIKE(lower(item_name),'samsung|iphone|moto|nokia');

/*---------------------------------------------------------------------------------------------------------------------------------*/
----#2 REGEXP_EXTRACT instead of CASE WHEN LIKE
select 
case  
  when concat(' ',item_name,' ') like '%samsung%' then 'Samsung'
  when concat(' ',item_name,' ') like '%iphone%' then 'Iphone'
  when concat(' ',item_name,' ') like '%nokia%' then 'Nokia'....
end as Brand
from products;
  
select 
regexp_extract(item_name,'(samsung|iphone|nokia)')
as brankd
from products;
/*---------------------------------------------------------------------------------------------------------------------------------*/
----#3 Convert long list of IN clause into a temporary table (use SPLIT clause)
/*---------------------------------------------------------------------------------------------------------------------------------*/
----#4 Order of joining table should always be from Largest to Smallest table
select 
*
from 
  large_table
  join
  small_table
on small_table.columnname = large_table.columnname;
/*---------------------------------------------------------------------------------------------------------------------------------*/
----#5 Equijoin where clause conditions if has function move it to table query (table2 date is split in 3 columns year, month, day)
select *
from table1 t1
join table2 t2
on t1.date = CONCAT(t2.year,'-',t2.month,'-',t2.day);

select *
from table1 t1
join 
(select *, CONCAT(t2.year,'-',t2.month,'-',t2.day) as newdt
from table2 t2) newt2
where t1.date = newt2.newdt
/*---------------------------------------------------------------------------------------------------------------------------------*/
---#6 Always GROUP BY columns with larget number of unique entities/values
select
  main_category,
  sub_category,
  itemid,
  sum(price)
from products
  group by main_category,sub_category,item_id;
  
--instead write as below
select
  main_category,
  sub_category,
  itemid,
  sum(price)
from products
  group by item_id,sub_category,main_category;
/*---------------------------------------------------------------------------------------------------------------------------------*/

----#7 Avoid Subqueries in WHERE Clause
select
  sum(price)
from table1
  where itemid in (select itemid from table2);
  
--instead write as below
with t2 as (select itemid from table2)
select sum(price)
  from table1 t1
join t2
on t1.itemid = t2.itemid;

/*---------------------------------------------------------------------------------------------------------------------------------*/

----#8 Use MAX instead of RANK
select *
from
  (select
      user_id,
      rank() over(order by prdate desc) as rank
      from table1
  )
where rank = 1;

--instead write simply as below
select user_id, max(prdate) 
from table1
group by 1;


/*---------------------------------------------------------------------------------------------------------------------------------*/

----# Other Tips
--Use approx_distinct() instead of distinct() for very large datasets
--Use approc_percentile(metric, 0.5) for median
--Avoid UINIO where possible
--Use WITH clause instead of nested subqueries
