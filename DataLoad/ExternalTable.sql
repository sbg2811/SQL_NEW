--External Table Load, data remains in external file, can be accessed through oracle server
--steps
--1. Create Directory and grant the permission 
create or replace directory DIR_EXTERNAL as 'C:\LoadData';
grant read, write on directory DIR_EXTERNAL to SYS;
--2.connect as sys as sysdba --execute this in sql plus
drop table T_ExtTabLoad;

create table T_ExtTabLoad
(
StudentName varchar2(20),
Subject varchar2(20),
Country varchar2(20)
)
ORGANIZATION EXTERNAL
(
TYPE ORACLE_LOADER
DEFAULT DIRECTORY DIR_EXTERNAL
ACCESS PARAMETERS (
RECORDS DELIMITED BY NEWLINE
FIELDS TERMINATED BY ','
)
LOCATION ('Students.txt')
);

select * from T_ExtTabLoad;

--try inserting data from here, check if students.txt is updated in local directory
insert into t_exttabload values('studentP','subjectP','countryT'); --throws error action not supported
delete from t_exttabload where studentname;
