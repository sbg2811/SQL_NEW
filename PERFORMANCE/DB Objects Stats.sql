--user object privilages
select * from TABLE_PRIVILEGES p where p.table_name = 'EMP';
select * from SYS.all_tab_privs where type = 'table' and table_name = '';

--find column present in tables
select * from all_tab_columns a where a.column_name like '%emp_name%' and owner like '%HR%';

--
select * from user_arguments where argument_name like '' order by position;

--Memory Issues related  user_object_size
select * from user_object_size;

--subprogram properties/information like parallel stored procedure/namespace etc
select * from user_procedures;

--Information stored procedure as whole, any sys/dbms_ package being used
select * from user_dependencies;

--metadata 
select dbms_metadata.get_ddl('TABLE','EMP',USER) from DUAL;