/*#### SEQUENCE Parameters
START WITH
INCREMENT BY
MINVALUE
MAXVALUE
CYCLE NOCACHE
*/

DROP SEQUENCE empid_seq;

create sequence empid_seq
START WITH 50
INCREMENT BY 10
MAXVALUE 100
CYCLE NOCACHE;

SELECT empid_seq.NEXTVAL FROM DUAL; --Default Min Value is 1,After Maxvalue is reached, sequence will restart from 1

create sequence empid2_seq
START WITH 50
INCREMENT BY 10
MINVALUE 50
MAXVALUE 100
CYCLE NOCACHE;

SELECT empid2_seq.NEXTVAL FROM DUAL; --After Maxvalue is reached, sequence will restart from 50
