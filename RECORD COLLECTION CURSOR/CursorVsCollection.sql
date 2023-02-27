--When to use Cursor, When to Collection
--Collection													                        Cursor	 
--Has index and data.Collection data is stored in memory			sqltext stored in memory, data is in basetable							
--Using Index, data can be accessed multiple times 					  Open cursor loads data through fetch loop opertion, 
--during entire program execution									            once closed, reopen the cursor in program execution to access data again
--Calling program entire collection data is loaded					  Calling program has to loop through cursor data

--collection
set serveroutput on
declare
	type v_varchar_list is table of varchar2(30); --collection declaration
	lv_varchar_list v_varchar_list := v_varchar_list(); 
begin
	select emp_name
		bulk collect into lv_varchar_list
	from employee;
	
	for i in lv_varchar_list.first..lv_varchar_list.last 
		loop
			dbms_output.put_line('emp_name ('||i||')= '||lv_varchar_list(i));
		end loop;
	dbms_output.put_line('Third Emp Name is  '||lv_varchar_list(i)); --collection data based on index can be accessed anytime		
end;
/

--Cursor for same operation as above
set serveroutput on
declare
	lv_emp_name varchar2(100);
	cursor lv_empname_curs is 
		select emp_name from employee;
begin
	open lv_empname_curs;
		loop
			fetch lv_empname_curs into lv_emp_name
			exit when lv_emp_name%notfound;
			dbms_output.put_line('emp_name ' || lv_emp_name);
		end loop;
	close lv_empname_curs;
end;
/

--Another example collection vs cursor
--1.create collection type
create or replace type typ_emp_name is table of varchar2(50);

--2.create procedure to assign collection data
create or replace procedure p_get_empnames(v_deptname IN varchar2,c_empname OUT TYP_EMP_NAME) AS
	pc_empname TYP_EMP_NAME := TYP_EMP_NAME(); --initialize
begin
	select emp_name 
	bulk collect into pc_empname
	from employee
	where dept_name = v_deptname;
	
	c_empname := pc_empname;
end;
 
--3.Block to invoke procedure in step 2
set serveroutput on
declare 
	lv_get_empname typ_emp_name:=typ_emp_name();
begin
	p_get_empnames('Admin',lv_get_empname);
  for i in lv_get_empname.first..lv_get_empname.last 
  loop
    dbms_output.put_line('emp_name ('||i||')= '||lv_get_empname(i));
  end loop;
end;

--1.create procedure cursor
create or replace procedure pc_get_empnames(v_deptname IN varchar2,c_empname OUT sys_refcursor) AS
begin
	open c_empname for
  select emp_name 
	from employee
	where dept_name = v_deptname;
end;
 
--2.Block to invoke procedure in step 1 above line 71
set serveroutput on
declare 
	c_empname sys_refcursor;
  v_empname varchar2(20);
begin
	pc_get_empnames('Admin',c_empname);
  loop 
    fetch c_empname into v_empname;
    exit when c_empname%notfound; 
    dbms_output.put_line('emp_name '||v_empname);
  end loop;
--end loop;
end;
/

