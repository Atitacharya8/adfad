ALTER PLUGGABLE DATABASE orclpdb OPEN;
--or
sqlplus sys/oracle@orclpdb as sysdba;
select status from v$instance;
STATUS
------------
MOUNTED
SQL> startup

^
|OPEN => DBF
|MOUNTED => CONTROLFILE,REDOLOGFILE
|NOMOUNT => ORACLE => PFILE

--from orcl session 
ALTER SESSION SET CONTAINER = orclpdb;

--from orcl session
CREATE <PUBLIC> DATABASE LINK dblk_to_orclpdb
  CONNECT TO hr IDENTIFIED BY oracle USING '(DESCRIPTION
    =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)
    (HOST = localhost)
    (PORT = 1521)))
    (CONNECT_DATA =(SERVER = DEDICATED)
    (SERVICE_NAME = orclpdb)))';
    
select * from dual@dblk_to_orclpdb;

select count(*) from hr.employees@dblk_to_orclpdb;
select * from dict;
