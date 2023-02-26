--find long running query -- blocking_session_status as WAIT
SELECT s.sid, s.schemaname, s.username, s.osuser, s.program, 
s.module, s.blocking_session,s.BLOCKING_SESSION_STATUS, s.logon_time||''||to_char(s.logon_time,'hh24:mi:ss') as logon_time,
t.sql_id,t.piece
from
v$sqltext t, v$session s
where t.address = s.sql_address
and t.hash_value = s.sql_hash_value
and s.username = 'SYS'
order by t.sql_id, t.piece;

--find long running query from v$sql
select elapsed_time/1000000 elapsed_seconds, cpu_time/1000000 cpu_seconds
  ,user_io_wait_time/1000000 user_io_wait_seconds, buffer_gets
  ,executions, v$sql.*
from v$sql
where lower(sql_text) like lower('%DECODE(RAWTOHEX(sql_address)%');

--find query running/status of various operations that run for longer than 6 seconds (in absolute time) from 
select * from V$SESSION_LONGOPS;

--find query text from v$sqltext
select * from v$sqltext_with_newlines where sql_id = 'bx2bcpa6dbjw6';

--kill sqlid
SELECT 'alter system kill session '''|| SID || ',' || SERIAL# || ''' immediate ;'
FROM v$session
WHERE sql_id = 'bx2bcpa6dbjw6';

--Explain Plan
explain plan for select 'Test Execution' from dual; 
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

--explain plan for query;

select plan_table_output from table (dbms_xplan.display());

set auto trace on

--execute the query
