--View                                        ComplexView                               Materilzed View
--Single Table View                           Multiple Table Join View
--No Group Functions allowed                  Group functions allowed
--Doesn't contain DISTINCT/PSEUDOCOLUMNs      Can contain Distinct/PSEUDOCOLUMNs
--DMLs allowed in View                        DMLs not allowed
--Only query is saved                                                                  --Query and Data is saved
--Actual Data comes from Base table                                                    --Based on MV Refresh, Data comes from view
--Slower since access base table                                                       --Faster
                                                                                       --Dynamic views are executed at run time
                                                                                       --REFRESH FAST, COMPLETE, FORCE
                                                
create or replace view emp_vw as
select * from employee where SALARY > 10000;

create or replace view emp_vw2 as
select * from employee where MAX(SALARY) = 10000; --throws exception no group functions allowed

create or replace view emp_vw3 as
select distinct emp_id from employee; --throws exception no group functions allowed

select * from emp_vw; --simple view

select * from user_views where view_name = 'EMP_VW'; --view type null
--Check text which view defination, * replaced as all existing base table columns are in Text
--any additonal columns added to base table will not be shown in view
--any column dropped, throw exception when accessing view

select * from user_tab_columns where table_name = 'EMP_VW'; --what column of base table are part of view
select * from user_dependencies where NAME = 'EMP_VW';

create table employee_bkp as select * from employee;

drop table employee;

select * from emp_vw; --base table dropped and dql on view will throw ORA-04063 Excetion (view defining query to nonexistent table)

create table employee as select * from employee_bkp;

select * from employee where salary = 11000; --base table has only 1 record with salary 11000 which is defination of view

update employee
set salary = 3000
where salary = 11000;

select * from emp_vw; --even without commit, view not showing the record

rollback;

update emp_vw
set SALARY = 3000
where salary = 11000;

select * from employee where salary = 11000;
select * from emp_vw;

drop MATERIALIZED VIEW emp_mv;

create MATERIALIZED VIEW emp_mv
build immediate
refresh force --fast option base table should have PK, MV log should be created for base table
on demand
as
select * from emp;

select * from emp_mv;

select * from all_constraints where table_name = 'EMP'; --no constraints

--u can not alter mv columns, it has to be dropped

alter table EMP add constraint emp_id_pk3 PRIMARY KEY(emp_id) DEFERRABLE novalidate;
