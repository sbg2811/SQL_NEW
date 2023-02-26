--Multiset Union
--Multiset Union All
--Multiset Union Distinct
--Multiset Intersect
--Multiset Intersect All
--Multiset Intersect Distinct
--Multiset Except (similar to Minus)
--Multiset Except All
--Multiset Except Distinct

SET SERVEROUTPUT ON
DECLARE
TYPE v_number IS TABLE OF NUMBER;
v_num1 v_number := v_number(1,2,3,4,5,6);
v_num2 v_number := v_number(7,8,9);
v_num3 v_number;
BEGIN
v_num3 := v_num1 multiset union v_num2;
for i in 1..v_num3.count loop
 dbms_output.put_line(v_num3(i));
end loop;
END;
/

SET SERVEROUTPUT ON
DECLARE
TYPE v_number IS TABLE OF NUMBER;
v_num1 v_number := v_number(1,2,3,4,5,6);
v_num2 v_number := v_number(1,2,9);
v_num3 v_number;
BEGIN
v_num3 := v_num1 multiset union all v_num2;
for i in 1..v_num3.count loop
 dbms_output.put_line(v_num3(i));
end loop;
END;
/

SET SERVEROUTPUT ON
DECLARE
TYPE v_number IS TABLE OF NUMBER;
v_num1 v_number := v_number(1,2,3,4,5,6);
v_num2 v_number := v_number(1,2);
v_num3 v_number;
BEGIN
v_num3 := v_num1 multiset intersect v_num2;
for i in 1..v_num3.count loop
 dbms_output.put_line(v_num3(i));
end loop;
END;
/

SET SERVEROUTPUT ON
DECLARE
TYPE v_number IS TABLE OF NUMBER;
v_num1 v_number := v_number(1,2,3,4,5,6);
v_num2 v_number := v_number(1,2);
v_num3 v_number;
BEGIN
v_num3 := v_num1 multiset except v_num2; --similar to MINUS
for i in 1..v_num3.count loop
 dbms_output.put_line(v_num3(i));
end loop;
END;
/
