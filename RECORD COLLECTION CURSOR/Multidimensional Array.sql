SET SERVEROUTPUT ON
DECLARE
    TYPE matrix_elem_type IS  VARRAY ( 3 ) OF NUMBER;
    TYPE matrix_type IS       VARRAY ( 3 ) OF matrix_elem_type;
    lv_matrix1       matrix_type := matrix_type(NULL,NULL,NULL);
    lv_matrix2       matrix_type := matrix_type(NULL,NULL,NULL);
    lv_matrix3_total matrix_type := matrix_type(NULL,NULL,NULL);
    lv_matrix_elem   matrix_elem_type := matrix_elem_type(NULL,NULL,NULL);
    -- Local Procedure to print the array
    procedure print_array(pin_array matrix_type,pin_desc varchar2) as
    begin
    dbms_output.put_line('Printing the '||pin_desc||' ....');
    for i in pin_array.first..pin_array.last loop
        for j in pin_array(i).first..pin_array(i).last loop
           dbms_output.put(pin_array(i)(j)||'   ');
        end loop;
        dbms_output.put_line('');
    end loop;
    end;
BEGIN
    -- Assing First Array
    lv_matrix_elem := matrix_elem_type(1,2,3);
    lv_matrix1(1) := lv_matrix_elem;
    lv_matrix_elem := matrix_elem_type(4,5,6);
    lv_matrix1(2) := lv_matrix_elem;
    lv_matrix_elem := matrix_elem_type(7,8,9);
    lv_matrix1(3) := lv_matrix_elem;
    
    -- Printing the first array
    print_array(lv_matrix1,'First Array');
    
    -- Assing Second Array
    lv_matrix_elem := matrix_elem_type(11,12,13);
    lv_matrix2(1) := lv_matrix_elem;
    lv_matrix_elem := matrix_elem_type(14,15,16);
    lv_matrix2(2) := lv_matrix_elem;
    lv_matrix_elem := matrix_elem_type(17,18,19);
    lv_matrix2(3) := lv_matrix_elem;
    
    -- Printing the Second array
    print_array(lv_matrix2,'Second Array');    
    
    -- Add Array1+Array2
    
    for i in lv_matrix1.first..lv_matrix1.last loop
        for j in lv_matrix1(i).first..lv_matrix1(i).last loop
        lv_matrix_elem(j) := lv_matrix1(i)(j) + lv_matrix2(i)(j);
        end loop;
        lv_matrix3_total(i) := lv_matrix_elem;
    end loop;
    
    --Print Total Array
    print_array(lv_matrix3_total,'Total Array');    
END;
