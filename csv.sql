-- External Table 
-- Create a Directories where we place the *.* files that are needed to load in oracle table
CREATE OR REPLACE DIRECTORY DIR_NAME AS 'E:\app\Atit\delimited\';
GRANT READ,WRITE ON DIRECTORY DIR_NAME TO PUBLIC;

-- To Verify the directory
SELECT * FROM DBA_DIRECTORIES WHERE DIRECTORY_NAME = 'DIR_NAME';


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
    READSIZE 65
    FIELDS TERMINATED BY '|'
    OPTIONALLY ENCLOSED BY '"' LDRTRIM
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION ('comma.txt')
  ) REJECT LIMIT UNLIMITED;
  
  select * from ZZZ_COMMA_1;
  
  drop table pipe purge; 
  create table pipe 
  as 
  select 
  cast(COL_1 as char(17)) c1,
  cast(COL_2 as char(20)) c2
   from
   ZZZ_COMMA_1;
   SELECT * FROM  pipe;
  
   insert into ZZZ_COMMA_1
  (COL_1,COL_2)
  VALUES
  (1,2);
   
  
  
  
  CREATE TABLE ZZZ_COMMA_1
(
  COL_1     VARCHAR2(255),
  COL_2     VARCHAR2(255),
  COL_3     VARCHAR2(255),
  COL_4     VARCHAR2(255),
  COL_5     VARCHAR2(255),
  COL_6    VARCHAR2(255),
  COL_7    VARCHAR2(255),
  COL_8    VARCHAR2(255)
  
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
  LOCATION ('student.csv')
) REJECT LIMIT UNLIMITED;

DROP TABLE ZZZ_TAB_2 PURGE;
CREATE TABLE ZZZ_TAB_2
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
select * from ZZZ_TAB_2;

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
  LOCATION ('newline.txt')
)
REJECT LIMIT UNLIMITED;

-- Verification Script
SELECT * FROM ZZZ_NEWLINE_1;

DROP TABLE ZZZ_SIZE_1 PURGE;
CREATE TABLE ZZZ_SIZE_1
(
  COL_1        char(6),
  COL_2        char(6),
  COL_3        char(6)
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
      COL_1     position(1:5)   char(6),
      COL_2     position(6:11)  char(6),
      COL_3     position(12:17) char(6)
    )

  )
  LOCATION ('SIZE.txt')
)
REJECT LIMIT UNLIMITED;

-- Verification Script
SELECT * FROM ZZZ_SIZE_1;

CREATE OR REPLACE DIRECTORY LOG_DIRECTORY_NAME AS 'E:\app\Atit\delimited\';
GRANT READ,WRITE ON DIRECTORY LOG_DIRECTORY_NAME TO PUBLIC;

CREATE OR REPLACE DIRECTORY BAD_DIRECTORY_NAME AS 'E:\app\Atit\delimited\';
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
    logfile LOG_DIRECTORY_NAME :'a.log'
    badfile BAD_DIRECTORY_NAME :'b.bad'
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"' LDRTRIM
    REJECT ROWS WITH ALL NULL FIELDS
  )
  LOCATION('student.csv')
)REJECT LIMIT UNLIMITED;
select * from zzz_comma_1; 




drop table test5 purge;
create table test5(c1 varchar2(4000));
set serveroutput on;
declare 
    l_m varchar2(32768) := 'hh';
begin
   dbms_output.put_line(l_m);
end;
/


explain plan for select * from test5 where 1=1;

select * from table(dbms_xplan.display);
Plan hash value: 2786681674

delete from ZZZ_COMMA_1;

select * from ZZZ_COMMA_1;
drop directory DIR_NAME;

CREATE OR REPLACE DIRECTORY DIR_NAME AS 'E:\app\Atit\delimited\';
GRANT READ,WRITE ON DIRECTORY DIR_NAME TO PUBLIC;

select * from user_tables;



CREATE OR REPLACE DIRECTORY LOG_DIRECTORY_NAME AS 'E:\app\Atit\delimited\LOG_FILE\';
GRANT READ,WRITE ON DIRECTORY LOG_DIRECTORY_NAME TO PUBLIC;
'
CREATE OR REPLACE DIRECTORY BAD_DIRECTORY_NAME AS 'E:\app\Atit\delimited\BAD_FILE\';
GRANT READ,WRITE ON DIRECTORY BAD_DIRECTORY_NAME TO PUBLIC;
'
DROP TABLE ZZZ_COMMA_1 PURGE;
CREATE TABLE ZZZ_COMMA_1
(
 COL_1     VARCHAR2(255),
  COL_2     VARCHAR2(255),
  COL_3     VARCHAR2(255),
  COL_4     VARCHAR2(255),
  COL_5     VARCHAR2(255),
  COL_6    VARCHAR2(255),
  COL_7    VARCHAR2(255),
  COL_8    VARCHAR2(255)
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
  LOCATION('student.csv')
)REJECT LIMIT UNLIMITED;
select * from ZZZ_COMMA_1;


set serveroutput on;
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

begin 
  for i in 1..10
     loop 
         begin 
           dbms_output.put_line('atit');
           exception when others then
          null;
          end;
      end loop;
end;
/



declare
   l_message char(20);
begin
   l_message := To_number('Atit');
   dbms_output.put_line('it is a number');
  exception when others then
   dbms_output.put_line('it is a character');
end;
/
set serveroutput on;  
declare 
     --l_v1 u_1.COUNTRIES.REGION_ID%type;
     l_v1 number;
begin
     select REGION_ID into l_v1 from COUNTRIES where rownum <2;
     DBMS_OUTPUT.PUT_line(l_v1);
end;
/

DECLARE
     l_inhandler utl_file.file_type;
     l_newLine   VARCHAR2(250);
BEGIN
     l_inhandler := utl_file.fopen('DIR_NAME','comma.txt','R');
     utl_file.get_line(l_inhandler,l_newLine);
     dbms_output.put_line(l_newLine);
     utl_file.fclose(l_inhandler);
END;
/

DECLARE
    l_inhandler utl_file.file_type;
    l_newLine   VARCHAR2(250);
BEGIN
    l_inhandler := utl_file.fopen('DIR_NAME', 'COMMA.txt', 'R');
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
   l_inhandler := utl_file.fopen('DIR_NAME','COMMA.txt','W');
   FOR I IN 1..10
   LOOP
     utl_file.put_line(l_inhandler,l_newLine);
     dbms_output.put_line(l_newLine);
     END LOOP;
     utl_file.fclose(l_inhandler);
    
END;
/

BEGIN 
  FOR  i in reverse 1..10
   loop
     begin 
     dbms_output.put_line('atit');
     end;
  end loop;
end;
/

DECLARE
    l_inhandler  utl_file.file_type;
    l_outhandle  utl_file.file_type; 
BEGIN
    l_inhandler := utl_file.fopen('DIR_NAME', 'SIZE.txt', 'R');
    l_outhandle := utl_file.fopen('DIR_NAME', 'TAB1.txt', 'W');

    IF utl_file.is_open(l_inhandler) THEN
       utl_file.fcopy('DIR_NAME', 'SIZE.txt', 'DIR_NAME', 'TAB1.txt');
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
    FOR i IN (SELECT 
                     table_name||'  =  '||owner AS tablename_with_owner 
                FROM 
                     all_tab_cols 
                ORDER BY owner)
    LOOP
        l_outhandle := i.tablename_with_owner;
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
    utl_file.frename('DIR_NAME','TAB.txt','DIR_NAME','pipe2.txt',TRUE);
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
    l_outfile := utl_file.fopen('DIR_NAME', 'tab1.txt', 'w');
    
    -- if the file to read was successfully opened
    IF utl_file.is_open(l_infile) THEN
      -- LOOP through each line IN the file
      --for i in 1..4
      LOOP
         BEGIN
             utl_file.get_line(l_infile, l_newLine);
             
             l_i := utl_file.fgetpos(l_infile);
             dbms_output.put_line(TO_CHAR(l_i));
             --utl_file.fflush(l_outfile);
             utl_file.put_line(l_outfile, l_newLine);
             utl_file.fflush(l_outfile);
             
             --utl_file.fflush(l_infile);             
             /*IF l_seekflag = TRUE THEN
                utl_file.fseek(l_infile, NULL, -30);
                l_seekflag := FALSE;
             END IF;*/
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


DECLARE
     l_a utl_file.file_type;
     l_b   VARCHAR2(250);
BEGIN
     l_a := utl_file.fopen('DIR_NAME','PIPE.txt','W');
     utl_file.get_line(l_a,l_b);
     dbms_output.put_line(l_b);
     utl_file.fclose(l_a);
END;
/

set serveroutput on;
DECLARE
    l_a utl_file.file_type;
    l_b VARCHAR2(200) := '';
BEGIN
    l_a := utl_file.fopen('DIR_NAME','PIPE.txt','W');
    FOR i IN (SELECT 
                     table_name||'  =  '||owner AS tablename_with_owner 
                FROM 
                     all_tab_cols 
                ORDER BY owner)
    LOOP
        l_b := i.tablename_with_owner;
        utl_file.put_line(l_a,l_b);
    END LOOP;
    utl_file.fclose(l_a);
EXCEPTION WHEN NO_DATA_FOUND THEN
    utl_file.fclose(l_a);
END;
/



DECLARE
     l_inhandler utl_file.file_type;
     l_newLine   VARCHAR2(250) := 'ASDF';
BEGIN
     l_inhandler := utl_file.fopen('DIR_NAME','comma.txt','A');
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

set serveroutput on;
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


select count(*) from dba_tables;


  
  
