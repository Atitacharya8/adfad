grant dba to hr;
begin
   for i in (select * from dba_sys_privs)
   loop 
       grant i.privilegeto hr
set serveroutput on;       
BEGIN
  FOR i IN (SELECT * FROM dba_sys_privs)
  LOOP
     BEGIN
         --EXECUTE IMMEDIATE 'GRANT '||i.privilege||' TO hr';
         Dbms_Output.Put_Line('GRANT '||i.privilege||' TO hr');
     EXCEPTION WHEN OTHERS THEN 
         NULL;
     END;
  END LOOP;
END;
/