select * from products_s; --contains product details prod_id and prod_name, rows 5
select * from COLORS; --contains color details color_id, color_name rows 3
select * from prod_sizes; --contains sizeid size rows 3
select * from transactions;

drop table products_s;
create table products_s (
prod_id number,
prod_name varchar(10)
);
insert all
into products_s VALUES (1, 'A')
into products_s VALUES (2, 'B')
into products_s VALUES (3, 'C')
into products_s VALUES (4, 'D')
into products_s VALUES (5, 'E')
select 1 from dual;

create table colors (
color_id number,
color varchar(50)
);
insert all 
into colors values (1,'Blue')
into colors values (2,'Green')
into colors values (3,'Orange')
select 1 from dual;

create table prod_sizes
(
size_id number,
prod_size varchar(10)
);
insert all 
into prod_sizes values (1,'M')
into prod_sizes values (2,'L')
into prod_sizes values (3,'XL')
select 1 from dual;

create table prod_transactions
(
order_id number,
prod_name varchar2(20),
prod_color varchar2(10),
prod_size varchar2(10),
amount number
);

insert all 
into prod_transactions values (1,'A','Blue','L',300)
into prod_transactions values (2,'B','Blue','XL',150)
into prod_transactions values (3,'B','Green','L',250)
into prod_transactions values (4,'C','Blue','L',250)
into prod_transactions values (5,'E','Green','L',270)
into prod_transactions values (6,'D','Orange','L',200)
into prod_transactions values (7,'D','Green','M',250)
select 1 from dual;
commit;

--Use Case Create Master Data
select prod_name,prod_size,prod_color,sum(amount) amt
from prod_transactions
group by prod_name,prod_size,prod_color;

--Show All the products name,size,color combonations along with amount from transaction

with products_master_data as
(select p.prod_name,s.prod_size,c.color
from products_s p, PROD_SIZES s, COLORS c) --45 rows(products_s 5 * prod_size 3* prod_colors 3 = 45 rows)
,sales as
(select prod_name,prod_size,prod_color,sum(amount) as total_amt
from prod_transactions
group by prod_name,prod_size,prod_color)
select md.prod_name,md.prod_size,md.color,s.total_amt
from
products_master_data md 
left join sales s
on md.prod_name = s.prod_name
and md.prod_size = s.prod_size
and md.color = s.prod_color;
