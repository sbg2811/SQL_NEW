/*Index
Column Data along with Rowid saved in Index Segement

Btree
used where cardinality is high eg, account_no, emp_id, passport_number etc 
cardinality is uniqueness of record with compared to other records
scans done are 
range, 
unique, 
full scan select sum(column) if column is indexed then only index data full scan will happen, 
fast full scan select empid,sum(salary) if both empid and salary are indexed then fast full scan on both index

Bitmap - 
used where cardinality is low, eg. Results(P/F/NA), Sex(F/M/Others), Flag(1/0)
scans are bitmap (full scan/fast full scan)
Not recommended if DML operations on Bitmap index are high since it locks all the rows if bitmap column in 
where condition

Function Based 
Query being used more often having function based where condition on particular columns
create functioned based index select empid from emp where upper(emp) = 'XYZ'; 
Function based index are useful only when same functions are used in where conditions
If function based index is created, instead of full scan, it uses indexes by range

Reverse Key Index
Its Btree index only, but reverse the key before saving as index
Used to solve the problem of contention of leaf blocks
Eliminates the ability to run index range scan in query instead goes for full scan
eg - Student table having marks column if majority of stduendts have marks between 70 and 90
then index ranges eg 0-30,30-60,60-90 (this will have more of data that other partitions)
in that grades, eg 75,80,82,87,79 will b reversed like 57,08,28,97 etc so that its distributed accross
however disadvantage is index range scan is skipped in this case

Composite Index

*/

select * from all_indexes where table_name = 'EMP';
select * from user_indexes where table_name = 'EMP';
select * from user_ind_statistics where table_name = 'EMP';
select * from user_ind_expressions where table_name = 'EMP'; --function based indexes details will be shown here

alter index student_id_idx monitoring usage;
select * from students where student_id = 101; -- this query execution shows usage below

select * from dba_object_usage;

alter index student_id_idx nomonitoring usage;


create table students
(student_id number,
student_name varchar2(50),
age number,
gender varchar2(2),
registration_date date,
fee_paid number,
student_marks number
);

insert all 
into students values(101,'Ram',40,'M','20-JAN-1999',10000,100)
into students values(102,'Sita',30,'F','3-JUN-1999',12000,90)
into students values(103,'Lucky',35,'M','20-MAR-1999',1000,80)
into students values(104,'Leena',22,'F','30-JAN-1999',10000,70)
into students values(105,'Bharat',40,'M','20-FEB-1999',13000,95)
select 1 from dual;

commit;

create index student_id_idx on students(student_id); --btree
create bitmap index student_gender_idx on students(gender); --bitmap
create index student_name_fn_idx on students(upper(student_name)); --function based index
create index student_marks_idx on students(student_marks) reverse; --reverse key index
create index student_composite_idx on emp_n (age,deptid); --composite index
