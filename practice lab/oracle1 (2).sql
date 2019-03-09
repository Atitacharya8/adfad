--Login in orcl then orclpdb open
ALTER PLUGGABLE DATABASE orclpdb OPEN;
--or
C:\Users\Dell>sqlplus sys/oracle@orclpdb as sysdba
SQL> select status from v$instance;
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

-- Login to SYS
-- Create Database
-- To find the location
SELECT DISTINCT 
     SUBSTR(b.file_name,1,INSTR(b.file_name,'\',-1)) file_name
FROM (
      SELECT 
           a.file_name 
      FROM dba_data_files a
     ) b;
'
/*
FILE_NAME
----------------------------------------
D:\APP\DELL\VIRTUAL\ORADATA\ORCL\ORCLPDB\
*/

-- To verify the user 
SELECT Count(*) verification FROM dba_users WHERE username ='U_1';
/*
VERIFICATION
------------ 
           0
*/

-- To verify the normal tablespace
SELECT Count(*) verification FROM dba_data_files WHERE tablespace_name = 'U_1';
/*
VERIFICATION
------------ 
           0
*/

-- To verify the temprory tablespace
SELECT Count(*) verification FROM dba_temp_files WHERE tablespace_name = 'U_T_1';
/*
VERIFICATION
------------ 
           0
*/

-- To verify the user's permission on tablespace                               
SELECT Count(*) verification FROM dba_ts_quotas WHERE username ='U_1';
/*
VERIFICATION
------------ 
           0
*/

CREATE TABLESPACE u_1
DATAFILE 'D:\APP\DELL\VIRTUAL\ORADATA\ORCL\ORCLPDB\u_1.dbf'
SIZE 500M
AUTOEXTEND ON NEXT 1M MAXSIZE UNLIMITED
SEGMENT SPACE MANAGEMENT auto;

-- To verify the normal tablespace
SELECT * FROM dba_data_files WHERE tablespace_name = 'U_1';
/*
FILE_NAME                                       FILE_ID TABLESPACE_NAME     BYTES BLOCKS STATUS    RELATIVE_FNO AUTOEXTENSIBLE    MAXBYTES MAXBLOCKS INCREMENT_BY USER_BYTES USER_BLOCKS ONLINE_STATUS
----------------------------------------------- ------- --------------- --------- ------ --------- ------------ -------------- ----------- --------- ------------ ---------- ----------- -------------
D:\APP\DELL\VIRTUAL\ORADATA\ORCL\ORCLPDB\u_1.dbf     138 U_1             524288000  64000 AVAILABLE          138 YES            34359721984   4194302          128  523239424       63872 ONLINE       
*/

CREATE TEMPORARY TABLESPACE u_t_1
TEMPFILE 'D:\APP\DELL\VIRTUAL\ORADATA\ORCL\ORCLPDB\u_t_1.dbf'
SIZE 10M
AUTOEXTEND ON;

-- To verify the temprory tablespace
SELECT * FROM dba_temp_files WHERE tablespace_name = 'U_T_1';
/*
FILE_NAME                                         FILE_ID TABLESPACE_NAME    BYTES BLOCKS STATUS RELATIVE_FNO AUTOEXTENSIBLE    MAXBYTES MAXBLOCKS INCREMENT_BY USER_BYTES USER_BLOCKS
------------------------------------------------- ------- --------------- -------- ------ ------ ------------ -------------- ----------- --------- ------------ ---------- -----------
D:\APP\DELL\VIRTUAL\ORADATA\ORCL\ORCLPDB\u_t_1.dbf      29 U_T_1           10485760   1280 ONLINE            1 YES            34359721984   4194302            1    9437184        1152
*/

CREATE USER u_1 IDENTIFIED BY oracle
DEFAULT TABLESPACE u_1
TEMPORARY TABLESPACE u_t_1
QUOTA UNLIMITED ON u_1;

-- To verify the user 
SELECT * FROM dba_users WHERE username ='U_1';
/*
USERNAME USER_ID PASSWORD ACCOUNT_STATUS LOCK_DATE EXPIRY_DATE         DEFAULT_TABLESPACE TEMPORARY_TABLESPACE CREATED             PROFILE INITIAL_RSRC_CONSUMER_GROUP EXTERNAL_NAME PASSWORD_VERSIONS EDITIONS_ENABLED AUTHENTICATION_TYPE
-------- ------- -------- -------------- --------- ------------------- ------------------ -------------------- ------------------- ------- --------------------------- ------------- ----------------- ---------------- -------------------
U_1          186          OPEN                     08.01.2019 22:03:13 U_1                U_T_1                12.07.2018 22:03:13 DEFAULT DEFAULT_CONSUMER_GROUP                    10G 11G           N                PASSWORD           
*/

-- To verify the user's permission on tablespace                               
SELECT * FROM dba_ts_quotas WHERE username ='U_1';
/*
TABLESPACE_NAME USERNAME BYTES MAX_BYTES BLOCKS MAX_BLOCKS DROPPED
--------------- -------- ----- --------- ------ ---------- -------
U_1             U_1          0        -1      0         -1 NO     
*/

-- To provide defalut roll to user
GRANT CONNECT,RESOURCE TO u_1;

-- Grant all privileges
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
/

SELECT Count(*) privilege FROM USER_SYS_PRIVS WHERE ADMIN_OPTION ='NO';
/*
PRIVILEGE
---------
      202
*/

-- Grant SYS/ADMIN privileges
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

-- Login user
SELECT Count(*) privilege FROM USER_SYS_PRIVS WHERE ADMIN_OPTION ='NO';
/*
PRIVILEGE
---------
        0
*/

-- Login user
SELECT Count(*) privilege FROM USER_SYS_PRIVS WHERE ADMIN_OPTION ='YES';
/*
PRIVILEGE
---------
      202
*/

-- Login to SYS
-- To drop Oracle User/Database
DROP USER u_1 CASCADE;
ALTER TABLESPACE u_1 OFFLINE;
DROP TABLESPACE u_t_1 INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE u_1 INCLUDING CONTENTS AND DATAFILES;

-- To verify the user 
SELECT Count(*) verification FROM dba_users WHERE username ='U_1';
/*
VERIFICATION
------------ 
           0
*/

-- To verify the normal tablespace
SELECT Count(*) verification FROM dba_data_files WHERE tablespace_name = 'U_1';
/*
VERIFICATION
------------ 
           0
*/

-- To verify the temprory tablespace
SELECT Count(*) verification FROM dba_temp_files WHERE tablespace_name = 'U_T_1';
/*
VERIFICATION
------------ 
           0
*/

-- To verify the user's permission on tablespace
SELECT Count(*) verification FROM dba_ts_quotas WHERE username ='U_1';
/*
VERIFICATION
------------ 
           0
*/


-- Alise and Contatination operatore Example
SELECT
     -- Column levl alise in select
     a.table_name                                        AS  table_name_1,
     a.table_name                                            table_name_2,
     a.table_name                                            "Table_Name_3",
     a.table_name                                            "SELECT",
     a.table_name                                            " ",
     -- Table level alise in select                      
     c.table_name                                            table_name,
     -- Query level alise in select                                
     (SELECT MAX(d.last_change) FROM user_constraints d)     select_query_alise,
     '1'||a.table_name||'Contination operator'               contination_operator
FROM -- Table level alise
     user_tables a JOIN (
                         SELECT 
                              b.table_name 
                         FROM user_tab_cols b
                        ) c
                        -- subquery level alise
ON   a.table_name=c.table_name;

-- Using With clause
WITH with_table
AS
  (
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL UNION ALL
   SELECT 1 col_1, 'a' col_2, sysdate col_3 FROM DUAL
  )
SELECT
     col_1,
     col_2,
     col_3
FROM 
     with_table
WHERE
     1 = 1;

-- Normal table structure 
CREATE TABLE normal_structure
(
 col_1 NUMBER
);     
   
-- Using no logging mechanism
CREATE TABLE using_nologing
(
 col_1 NUMBER
) NOLOGGING;

-- Destination table structure as per as source table
-- With all the data
CREATE TABLE employees_bk AS SELECT * FROM employees;

SELECT
     'CREATE TABLE '||a.table_name||' AS SELECT * FROM '||a.table_name||' ;' " "
FROM 
     user_tables a ;

-- Only source structure
CREATE TABLE employees_bk AS SELECT * FROM employees WHERE ROWNUM < 1;
CREATE TABLE employees_bk AS SELECT * FROM employees WHERE 1=2;

-- Using compressed data
CREATE TABLE employees_bk COMPRESS AS SELECT * FROM hr.employees;
-- Using compressed nologing parallel

CREATE TABLE employees_bk PARALLEL COMPRESS NOLOGGING TABLESPACE table_sapace_name AS SELECT * FROM hr.employees;

-- Table column data type change and create structure as per as client required 
CREATE TABLE client_request
(
 col_1,
 col_2,
 col_3
)
AS
SELECT 1111111 col_1, 'aaaaaaa' col_2, sysdate col_3 FROM dual;

-- Virtual Columns in Oracle Database 11g Release 1
/*
When queried, virtual columns appear to be normal table columns, but their values are derived rather than being stored on disc. 
The syntax for defining a virtual column is listed below.

column_name [datatype] [GENERATED ALWAYS] AS (expression) [VIRTUAL]
If the datatype is omitted, it is determined based on the result of the expression. The GENERATED ALWAYS and VIRTUAL keywords 
are provided for clarity only.

The script below creates and populates an virtula_table table with two levels of commission. It includes two virtual columns 
to display the commission-based salary. The first uses the most abbreviated syntax while the second uses the most verbose form.
*/

CREATE TABLE virtula_table
(
  id          NUMBER,
  first_name  VARCHAR2(10),
  last_name   VARCHAR2(10),
  salary      NUMBER(9,2),
  comm1       NUMBER(3),
  comm2       NUMBER(3),
  salary1     AS (ROUND(salary*(1+comm1/100),2)),
  salary2     NUMBER GENERATED ALWAYS AS (ROUND(salary*(1+comm2/100),2)) VIRTUAL,
  CONSTRAINT virtula_table_pk PRIMARY KEY (id)
);

INSERT INTO virtula_table
(
 id, first_name, last_name, salary, comm1, comm2
)
VALUES
(
 1, 'JOHN', 'DOE', 100, 5, 10
);

INSERT INTO virtula_table
(
 id, first_name, last_name, salary, comm1, comm2
)
VALUES
(
 2, 'JAYNE', 'DOE', 200, 10, 20
);
COMMIT;

SELECT * FROM virtula_table;
/*
ID FIRST_NAME LAST_NAME SALARY COMM1 COMM2 SALARY1 SALARY2
-- ---------- --------- ------ ----- ----- ------- -------
 1 JOHN       DOE          100     5    10     105     110
 2 JAYNE      DOE          200    10    20     220     240
*/


-- External Table 
-- Create a Directories where we place the *.* files that are needed to load in oracle table
CREATE OR REPLACE DIRECTORY DIR_NAME AS 'D:\APP\DELL\VIRTUAL\ORADATA\ORCL\ORCLPDB\';
GRANT READ,WRITE ON DIRECTORY DIR_NAME TO PUBLIC;

-- To Verify the directory
SELECT * FROM DBA_DIRECTORIES WHERE DIRECTORY_NAME = 'DIR_NAME';

/*
OWNER DIRECTORY_NAME DIRECTORY_PATH
----- -------------- ----------------------------------------                          
SYS   DIR_NAME       D:\APP\DELL\VIRTUAL\ORADATA\ORCL\ORCLPDB\
*/

-- Connect user (as you wish to create external table) 
-- 1. Comma Delimited
DROP TABLE ZZZ_COMMA_1 PURGE;
CREATE TABLE ZZZ_COMMA_1
(
  COL_1     VARCHAR2(255),
  COL_2     VARCHAR2(255)
)
ORGANIZATION EXTERNAL
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY DIR_NAME
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    SKIP 0
    READSIZE 1048576
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"' LDRTRIM
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION ('COMMA.csv')
) REJECT LIMIT UNLIMITED;

-- Verification Script
SELECT * FROM ZZZ_COMMA_1;

-- 2. Pipe Delimited
DROP TABLE ZZZ_PIPE_1 PURGE;
CREATE TABLE ZZZ_PIPE_1
(
  COL_1            VARCHAR2(10)  NULL,
  COL_2            VARCHAR2(10)  NULL
)
ORGANIZATION external
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY DIR_NAME
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    READSIZE 1048576
    FIELDS TERMINATED BY '|' 
    OPTIONALLY ENCLOSED BY '"' LDRTRIM
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION ('PIPE.txt')
)
REJECT LIMIT UNLIMITED;

-- Verification Script
SELECT * FROM ZZZ_PIPE_1;
  
-- 3. Tab Delimited
DROP TABLE ZZZ_TAB_1 PURGE;
CREATE TABLE ZZZ_TAB_1
(
    COL_1          VARCHAR2(20),
    COL_2          VARCHAR2(20)
)
ORGANIZATION external
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY DIR_NAME
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    SKIP 0
    READSIZE 1048576
    FIELDS TERMINATED BY '\t'
    OPTIONALLY ENCLOSED BY '"' LDRTRIM
    MISSING FIELD VALUES ARE NULL
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION ('TAB.txt')
)
REJECT LIMIT UNLIMITED;

-- Verification Script
SELECT * FROM ZZZ_TAB_1;

-- 4. Size Delimited
DROP TABLE ZZZ_SIZE_1 PURGE;
CREATE TABLE ZZZ_SIZE_1
(
  COL_1        char(5),
  COL_2        char(5),
  COL_3        char(5)
)
ORGANIZATION external
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY DIR_NAME
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE
    SKIP 1
    FIELDS
    (
      COL_1     position(1:5)   char(5),
      COL_2     position(6:11)  char(5),
      COL_3     position(12:17) char(5)
    )

  )
  LOCATION ('SIZE.txt')
)
REJECT LIMIT UNLIMITED;

-- Verification Script
SELECT * FROM ZZZ_SIZE_1;

-- 5. New line Delimited
DROP TABLE ZZZ_NEWLINE_1 PURGE;
CREATE TABLE ZZZ_NEWLINE_1
(
  COL_1 VARCHAR2(4000)
)
ORGANIZATION external
(
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY DIR_NAME
  ACCESS PARAMETERS
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    SKIP 0
    READSIZE 1048576
    FIELDS TERMINATED BY '\n' LDRTRIM
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION ('NEWLINE.txt')
)
REJECT LIMIT UNLIMITED;

-- Verification Script
SELECT * FROM ZZZ_NEWLINE_1;

CREATE OR REPLACE DIRECTORY LOG_DIRECTORY_NAME AS 'D:\APP\DELL\VIRTUAL\ORADATA\ORCL\ORCLPDB\logfile\';
GRANT READ,WRITE ON DIRECTORY LOG_DIRECTORY_NAME TO PUBLIC;

CREATE OR REPLACE DIRECTORY BAD_DIRECTORY_NAME AS 'D:\APP\DELL\VIRTUAL\ORADATA\ORCL\ORCLPDB\badfile\';
GRANT READ,WRITE ON DIRECTORY BAD_DIRECTORY_NAME TO PUBLIC;

DROP TABLE zzz_comma_1 PURGE;
CREATE TABLE zzz_comma_1
(
  col_1      VARCHAR2(255),
  col_2      VARCHAR2(255)
)
ORGANIZATION EXTERNAL             --defination of external table.
(
  TYPE ORACLE_LOADER              --type of oracle loader to load the data from csv in external table.
  DEFAULT DIRECTORY DIR_NAME      --defined directory.
  ACCESS PARAMETERS               -- defined parameters.
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    SKIP 0
    logfile LOG_DIRECTORY_NAME :'Log_File.Log'
    badfile BAD_DIRECTORY_NAME :'Bad_File.bad'
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"' LDRTRIM
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION('COMMA.csv')
)REJECT LIMIT UNLIMITED;

DROP TABLE gtb_table_name_transactional PURGE;
-- Global Temporary Table transaction specific
CREATE GLOBAL TEMPORARY TABLE gtb_table_name_transactional
( 
 col_1 NUMBER,
 col_2 VARCHAR2(10)
) 
ON COMMIT DELETE ROWS;

INSERT INTO gtb_table_name_transactional
SELECT 1 col_1, 'DATA1' col_2 FROM DUAL UNION ALL
SELECT 2 col_1, 'DATA2' col_2 FROM DUAL UNION ALL
SELECT 3 col_1, 'DATA3' col_2 FROM DUAL UNION ALL
SELECT 5 col_1, 'DATA4' col_2 FROM DUAL;

SELECT * FROM gtb_table_name_transactional;
/*
COL_1 COL_2
----- -----
    1 DATA1
    2 DATA2
    3 DATA3
    5 DATA4
*/
COMMIT;

SELECT Count(*) data FROM gtb_table_name_transactional;
/*
DATA
----
   0
*/

-- Global Temporary Table session specific
DROP TABLE gtb_table_name_session PURGE;
CREATE GLOBAL TEMPORARY TABLE gtb_table_name_session
(  
 col_1 NUMBER,
 col_2 VARCHAR2(10)
) 
ON COMMIT PRESERVE ROWS;

INSERT INTO gtb_table_name_session
SELECT 1 col_1, 'DATA1' col_2 FROM DUAL UNION ALL
SELECT 2 col_1, 'DATA2' col_2 FROM DUAL UNION ALL
SELECT 3 col_1, 'DATA3' col_2 FROM DUAL UNION ALL
SELECT 5 col_1, 'DATA4' col_2 FROM DUAL;

SELECT * FROM gtb_table_name_session;
/*
COL_1 COL_2
----- -----
    1 DATA1
    2 DATA2
    3 DATA3
    5 DATA4
*/
COMMIT;

-- Re-Login with the current session 
SELECT Count(*) data FROM gtb_table_name_session;
/*
DATA
----
   0
*/

DROP TABLE gtb_table_name_session_emp PURGE;
CREATE GLOBAL TEMPORARY TABLE gtb_table_name_session_emp
ON COMMIT PRESERVE ROWS
AS
SELECT * FROM user_tables;

SELECT Count(*) data FROM gtb_table_name_session_emp;
COMMIT;

-- Re-Login with the current session 
SELECT Count(*) data FROM gtb_table_name_session;
/*
DATA
----
   0
*/

--Anonomus BLOCK : An anonymous block is an unnamed sequence of actions. Since they are unnamed, 
--anonymous blocks cannot be referenced by other program units.

-- Simplest Anonymous Block
BEGIN
    <valid statement>;
END;
/

-- Examples to diplay nothing
BEGIN
    NULL;
END;
/

-- The classic “Print PL/SQL” block contains an executable section that calls the dbms_output.put_line procedure to display text on the screen:
BEGIN
    dbms_output.put_line ('Print PL/SQL');
END;
/

-- Anonymous Block With Error Exception Handler
BEGIN
    <valid statement>;
EXCEPTION
    <exception handler>;
END;
/

-- Examples to diplay nothing with exception handeling
BEGIN
    NULL;
EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

-- Nested Anonymous Blocks With Exception Handlers
BEGIN
    <valid statement>;
    BEGIN
        <valid statement>;
    EXCEPTION
        <exception handler>;
    END;
EXCEPTION
    <exception handler>;
END;
/

-- Nested Anonymous Blocks With Exception Handlers to display nothing
BEGIN
    NULL;
    BEGIN
        NULL;
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;
EXCEPTION WHEN OTHERS THEN
    NULL;
END;
/

-- Nested Anonymous Blocks WITH Variable Declaration
DECLARE
     <variable name> <data type><(LENGTH PRECISION)>;
BEGIN
     <valid statement>;
END;
/

-- To display the output as in upper case
DECLARE
    l_message      VARCHAR2(1);
BEGIN
    l_message  :=  'a';
    dbms_output.put_line(l_message);
END;
/

--Anonymous block has not defined under a name.
DECLARE
    (decleration statememt)
-- Main block
BEGIN
    --1st block
    BEGIN
        (executation statement)
    (EXCEPTION handling)
    END; -- End of 1st block
    
    --2nd block
    BEGIN
        (executation statement)
    (EXCEPTION handling)
    END; -- End of 2nd block

END;
/ -- End of Main block

DECLARE
    l_message      VARCHAR2(100);
BEGIN
    dbms_output.put_line('Block 1');
    BEGIN
        l_message  :=  To_number('abc');
        dbms_output.put_line(l_message);
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('Block 2');
    END;

    BEGIN
        l_message  :=  To_char('abc');
        dbms_output.put_line(l_message);
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('Block 3');
    END;
EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line('Block 4');
END;
/

-- Overwrite Case
DECLARE
    l_message      VARCHAR2(100) := 'a' ;
BEGIN
    dbms_output.put_line(l_message);
    l_message := 'b'; 
    dbms_output.put_line(l_message);
END;
/

/*
a
b
*/

DECLARE
    l_message      VARCHAR2(100) := 'a' ; -- Public Variable Declaration
BEGIN
    dbms_output.put_line(l_message);
    DECLARE 
       l_message VARCHAR2(100) := 'b'; -- Private Variable Declaration
    BEGIN
        dbms_output.put_line(l_message);
    END;
    
    dbms_output.put_line(l_message);
END;
/

/*
a                             
b                             
a                               
*/

/*
UTL_FILE: Reading and Writing Server-side Files
UTL_FILE is a package that has been welcomed warmly by PL/SQL developers. It allows PL/SQL programs to both read from and write to any 
operating system files that are accessible from the server on which your database instance is running. File l_i/O was a feature long 
desired IN PL/SQL. You can now read IN files and interact with the operating system a little more easily than has been possible IN the 
past. You can load data from files directly into database tables while applying the full power and flexibility of PL/SQL programming. 
You can generate reports directly from within PL/SQL without worrying about the maximum buffer restrictions of DBMS_OUTPUT

Getting Started with UTL_FILE :
The UTL_FILE package is created when the Oracle database is installed. The utlfile.sql script (found IN the built-IN packages source code 
directory) contains the source code FOR this package's specification. This script is called by catproc.sql , which is normally run 
immediately after database creation. The script creates the public synonym UTL_FILE FOR the package and grants EXECUTE privilege on the 
package to public. All Oracle users can reference and make use of this package.

UTL_FILE Programs Description Use IN PL\SQL :

FCLOSE         : Closes the specified files
FCLOSE_ALL     : Closes all open files
FFLUSH         : Flushes all the data from the UTL_FILE buffer
FOPEN          : Opens the specified file
GET_LINE       : Gets the next line from the file
IS_OPEN        : Returns TRUE if the file is already open
NEW_LINE       : Inserts a newline mark IN the file at the END of the current line
PUT            : Puts text into the buffer
PUT_LINE       : Puts a line of text into the file
PUTF           : Puts formatted text into the buffer
FCOPY          : Copies a contiguous portion of a file to a newly created file
FGETATTR       : Reads and returns the attributes of a disk file
FGETPOS        : Returns the current relative offset position within a file, IN bytes
FOPEN_NCHAR    : Open a file FOR multibyte characters
                 Note: since NCHAR contains mutibyte character, 
                 it is recommended that the max_linesize be less than 6400.
FREMOVE        : Delete An Operating System File
FRENAME        : Rename An Operating System File
FSEEK          : Adjusts the file pointer forward or backward within the file by the number of bytes specified 
GETLINE        : Read a Line from a file
GETLINE_NCHAR  : Read a line from a file containing multi-byte characters
GET_RAW        : Reads a RAW string value from a file and adjusts the file pointer ahead by the number of bytes read
PUT_NCHAR      : Writes a Unicode string to a file
PUT_RAW        : Accepts as input a RAW data value and writes the value to the output buffer
PUT_LINE_NCHAR : Writes a Unicode line to a file
PUTF_NCHAR     : Writes a Unicode string to a file

Open Modes :    
A    : Append Text / add new to the existing
R    : Read Text
W    : Write Text / overwrite /create new file
RB  : read binary data
WB  : write binary data

UTL_FILE exceptions :
The package specification of UTL_FILE defines seven exceptions. The cause behind a UTL_FILE exception can often be difficult to understand. 
Here are the explanations Oracle provides FOR each of the exceptions:

INVALID_PATH         : The file location or the filename is invalid. Perhaps the directory is not listed as a utl_file_dir parameter IN the 
                       INIT.ORA file (or doesn't exist as all), or you are trying to read a file and it does not exist.
INVALID_MODE         : The value you provided FOR the open_mode parameter IN utl_file.fopen was invalid. It must be 'A' ,'R' ,'W' , 'RB' 'WB'
INVALID_FILEHANDLE   : The file handle you passed to a UTL_FILE program was invalid. You must call utl_file.fopen to obtain a valid file 
                       handle.
INVALID_OPERATION    : UTL_FILE could not open or operate on the file as requested. FOR example, if you try to write to a read-only file, 
                       you will raise this exception.
READ_ERROR           : The operating system returned an error when you tried to read from the file. (This does not occur very often.)
WRITE_ERROR          : The operating system returned an error when you tried to write to the file. (This does not occur very often.)
INTERNAL_ERROR       : Something went wrong and the PL/SQL runtime engine couldn't assign blame to any of the previous exceptions. 
                       Better call Oracle Support!
NO_DATA_FOUND        : Raised when you read past the END of the file with utl_file.get_line.
VALUE_ERROR          : Raised when you try to read or write lines IN the file which are too long. The current implementation of 
                       UTL_FILE limits the size of a line read by utl_file.get_line to 1022 bytes.
INVALID_MAXLINESIZE  : Raised when you try to open a file with a maximum linesize outside of the valid range (between 1 through 999999999).
Note                 : IN the following descriptions of the UTL_FILE programs, l_i list the exceptions that can be raised by each individual 
                       program.

*/

-- CREATE A DIRECTORY and Grant on DIRECTORY
CREATE DIRECTORY DIR_NAME AS 'D:\Oracle_Class_With_Projects\Delimited\';

-- GRANT TO DIRECTORY' --
GRANT READ, WRITE ON DIRECTORY DIR_NAME TO PUBLIC;

DECLARE
     l_inhandler utl_file.file_type;
     l_newLine   VARCHAR2(250);
BEGIN
     l_inhandler := utl_file.fopen('DIR_NAME','PIPE.txt','R');
     utl_file.get_line(l_inhandler,l_newLine);
     dbms_output.put_line(l_newLine);
     utl_file.fclose(l_inhandler);
END;
/

DECLARE
    l_inhandler utl_file.file_type;
    l_newLine   VARCHAR2(250);
BEGIN
    l_inhandler := utl_file.fopen('DIR_NAME', 'PIPE.txt', 'R');
    LOOP
       BEGIN
           utl_file.get_line(l_inhandler, l_newLine);
           dbms_output.put_line(l_newLine);
       EXCEPTION WHEN OTHERS THEN
           EXIT;
       END;
    END LOOP;
    utl_file.fclose(l_inhandler);
END;
/

DECLARE
     l_inhandler utl_file.file_type;
     l_newLine   VARCHAR2(250) := 'ASDF';
BEGIN
     l_inhandler := utl_file.fopen('DIR_NAME','PIPE.txt','A');
     utl_file.put_line(l_inhandler,l_newLine);
     dbms_output.put_line(l_newLine);
     utl_file.fclose(l_inhandler);
END;
/

DECLARE
     l_inhandler utl_file.file_type;
     l_newLine   VARCHAR2(250) := 'ASDF';
BEGIN
     l_inhandler := utl_file.fopen('DIR_NAME','PIPE.txt','A');
     FOR l_i IN 1 .. 10
     LOOP
        utl_file.put_line(l_inhandler,l_newLine);
     END LOOP;
     dbms_output.put_line(l_newLine);
     utl_file.fclose(l_inhandler);
END;
/

DECLARE
     l_inhandler utl_file.file_type;
     l_newLine   VARCHAR2(250) := 'ASDF';
BEGIN
     l_inhandler := utl_file.fopen('DIR_NAME','PIPE.txt','A');
     utl_file.put_line(l_inhandler,l_newLine||' \n');
     dbms_output.put_line(l_newLine);
     utl_file.fclose(l_inhandler);
END;
/

DECLARE
    l_inhandler  utl_file.file_type;
    l_outhandle  VARCHAR2(250) := 'ASDF'; 
BEGIN
    l_inhandler := utl_file.fopen('DIR_NAME', 'PIPE.txt', 'W');
    utl_file.put_line(l_inhandler,l_outhandle);
    utl_file.fclose(l_inhandler);
END;
/

DECLARE
    l_inhandler   utl_file.file_type;
    l_outhandle   VARCHAR2(250) := 'ASDF'; 
BEGIN
    l_inhandler := utl_file.fopen('DIR_NAME', 'PIPE.txt', 'W');
    FOR l_i IN 1 .. 10
    LOOP
       utl_file.put_line(l_inhandler,l_outhandle);
    END LOOP;
    utl_file.fclose(l_inhandler);
END;
/

DECLARE
    l_inhandler  utl_file.file_type;
    l_outhandle  utl_file.file_type; 
BEGIN
    l_inhandler := utl_file.fopen('DIR_NAME', 'SIZE.txt', 'R');
    l_outhandle := utl_file.fopen('DIR_NAME', 'TAB.txt', 'W');

    IF utl_file.is_open(l_inhandler) THEN
       utl_file.fcopy('DIR_NAME', 'SIZE.txt', 'DIR_NAME', 'TAB.txt');
       utl_file.fclose(l_inhandler);
       dbms_output.put_line('Closed l_inhandler');
    END IF;
    
    utl_file.fclose_all;
    dbms_output.put_line('Closed l_inhandler,l_outhandle');

END;
/


DECLARE
    l_inhandler utl_file.file_type;
    l_outhandle VARCHAR2(200) := '';
BEGIN
    l_inhandler := utl_file.fopen('DIR_NAME','PIPE.txt','W');
    FOR l_i IN (SELECT 
                     table_name||'  =  '||owner AS tablename_with_owner 
                FROM 
                     all_tab_cols 
                ORDER BY owner)
    LOOP
        l_outhandle := l_i.tablename_with_owner;
        utl_file.put_line(l_inhandler,l_outhandle);
    END LOOP;
    utl_file.fclose(l_inhandler);
EXCEPTION WHEN NO_DATA_FOUND THEN
    utl_file.fclose(l_inhandler);
END;
/

DECLARE
    l_ex    BOOLEAN;
    l_flen  NUMBER;
    l_bsize NUMBER; 
BEGIN
    utl_file.fgetattr('DIR_NAME', 'PIPE.txt', l_ex, l_flen, l_bsize);
    
    IF l_ex THEN
      dbms_output.put_line('File Exists');
    ELSE
      dbms_output.put_line('File Does Not Exist');
    END IF;
    dbms_output.put_line('File Length: ' || TO_CHAR(l_flen));
    dbms_output.put_line('Block Size: ' || TO_CHAR(l_bsize));
END;
/

BEGIN
    utl_file.fremove('DIR_NAME', 'PIPE.txt');
END;
/

BEGIN
    utl_file.frename('DIR_NAME','TAB.txt','DIR_NAME','TAB1111.txt',TRUE);
END;
/

DECLARE
    l_infile   utl_file.file_type;
    l_outfile  utl_file.file_type;
    l_newLine  VARCHAR2(4000);
    l_i        PLS_INTEGER;
    l_j        PLS_INTEGER := 0;
    l_seekflag BOOLEAN := TRUE;
BEGIN
    -- open a file to read
    l_infile := utl_file.fopen('DIR_NAME', 'SIZE.txt','r');
    -- open a file to write
    l_outfile := utl_file.fopen('DIR_NAME', 'TAB.txt', 'w');
    
    -- if the file to read was successfully opened
    IF utl_file.is_open(l_infile) THEN
      -- LOOP through each line IN the file
      LOOP
         BEGIN
             utl_file.get_line(l_infile, l_newLine);
             
             l_i := utl_file.fgetpos(l_infile);
             dbms_output.put_line(TO_CHAR(l_i));
             
             utl_file.put_line(l_outfile, l_newLine, FALSE);
             utl_file.fflush(l_outfile);
             
             IF l_seekflag = TRUE THEN
                utl_file.fseek(l_infile, NULL, -30);
                l_seekflag := FALSE;
             END IF;
         EXCEPTION WHEN NO_DATA_FOUND THEN
             EXIT;
         END;
      END LOOP;
      COMMIT;
    END IF;
    utl_file.fclose(l_infile);
    utl_file.fclose(l_outfile);
EXCEPTION WHEN OTHERS THEN
    raise_application_error(-20099, 'Unknown UTL_FILE Error');
END;
/

DECLARE
    l_inhandler utl_file.file_type;
    l_outhandle VARCHAR2(32767);
BEGIN
    l_inhandler := utl_file.fopen('DIR_NAME','test.txt','W');
    l_outhandle := 'employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id';
    utl_file.put_line(l_inhandler,l_outhandle);
    FOR l_i IN (SELECT * FROM hr.employees ORDER BY 1)
    LOOP
        utl_file.put_line(l_inhandler,l_i.employee_id||',  '||l_i.first_name||',  '||l_i.last_name||',  '||l_i.email||',  '||l_i.phone_number||',  '||l_i.hire_date||',  '        ||l_i.job_id||',  '||l_i.salary||',  '||l_i.commission_pct||',  '||l_i.manager_id||',  '||l_i.department_id);
    END LOOP;
EXCEPTION WHEN NO_DATA_FOUND THEN
    utl_file.fclose(l_inhandler);
END;
/
