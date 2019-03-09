SELECT DISTINCT 
     SUBSTR(b.file_name,1,INSTR(b.file_name,'\',-1)) file_name
FROM (
      SELECT 
           a.file_name 
      FROM dba_data_files a
     ) b;
     
SELECT Count(*) verification FROM dba_users WHERE username ='U_1';

SELECT Count(*) verification FROM dba_data_files WHERE tablespace_name = 'U_1';

SELECT Count(*) verification FROM dba_temp_files WHERE tablespace_name = 'U_T_1';

SELECT Count(*) verification FROM dba_ts_quotas WHERE username ='U_1';

create tablespace u_1
datafile 'E:\APP\ATIT\VIRTUAL\ORADATA\ORCL\ORCLPDB\u_1.dbf'
size 500M
autoextend on next 1M maxsize unlimited
segment space management auto;


select * from dba_data_files where tablespace_name ='U_1';

CREATE TEMPORARY TABLESPACE u_t_1
TEMPFILE 'E:\APP\ATIT\VIRTUAL\ORADATA\ORCL\ORCLPDB\u_t_1.dbf'
SIZE 10M
AUTOEXTEND ON;


-- To verify the temprory tablespace
SELECT * FROM dba_temp_files WHERE tablespace_name = 'U_T_1';

CREATE USER u_1 IDENTIFIED BY oracle
DEFAULT TABLESPACE u_1
TEMPORARY TABLESPACE u_t_1
QUOTA UNLIMITED ON u_1;

SELECT * FROM dba_users WHERE username ='U_1';

GRANT CONNECT,RESOURCE TO u_1;

BEGIN
  FOR i IN (SELECT * FROM dba_sys_privs)
  LOOP
     BEGIN
         EXECUTE IMMEDIATE 'GRANT '||i.privilege||' TO u_1';
         Dbms_Output.Put_Line('GRANT '||i.privilege||' TO u_1');
     EXCEPTION WHEN OTHERS THEN 
         NULL;
     END;
  END LOOP;
END;


set serveroutput on;

BEGIN
  FOR i IN (SELECT * FROM dba_sys_privs WHERE ADMIN_OPTION = 'YES')
  LOOP
     BEGIN
         EXECUTE IMMEDIATE 'GRANT '||i.privilege||' TO u_1 WITH ADMIN OPTION';
         Dbms_Output.Put_Line('GRANT '||i.privilege||' TO u_1 WITH ADMIN OPTION');
     EXCEPTION WHEN OTHERS THEN 
         NULL;
     END;
  END LOOP;
END;
/








     
