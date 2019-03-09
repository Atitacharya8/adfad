--Syntax:
SELECT
     *|{[DISTINCT] COLUMN|expression [alise],...}
FROM
    TABLE
[WHERE
   conditions];

--WHERE :restricts the query to rows that meet a condition
--CONDITION :is composed of column names,expressions,constants,and a comparisoin operator


--For NUMBER Gives the rows of employees table whose department_id column value is 30.
--We can USE following comparision operator
--Comparison Conditions
/*
     =    Equal to
     >    Greater than
     >=   Greater than or equal to
     <    Less than
     <=   Less than or equal to
     <>, !=, ^=   Not equal to
*/


--Syntax:
{ expr
     { = | != | ^= | <> | > | < | >= | <= }
     { ANY | SOME | ALL }
     ({ expression_list | subquery })
| expr
  [, expr ]...
  { = | != | ^= | <> }
  { ANY | SOME | ALL }
  ({ expression_list
     [, expression_list ]...
   | subquery
   }
  )
};


SELECT
     last_name,
     department_id,
     salary,
     job_id
FROM
     employees
WHERE
     department_id = 30;

--For String
--For the String we should take in consideration that the case of the string.
SELECT
     last_name,
     department_id,
     salary,
     job_id
FROM
     employees
WHERE
     last_name = 'Khoo';

--gives the rows whose column SALARY has value less than or equal to 10000.
SELECT
     last_name,
     department_id,
     salary,
     job_id
FROM
     employees
WHERE
     salary <= 10000;

--Gives rows where salary is greater and equal to 10000.
SELECT
     last_name,
     department_id,
     salary,
     job_id
FROM
     employees
WHERE
     salary >= 10000;


--Gives the rows whose department_id is not equals to 90. for not equal to we can use (<> , ^= , != )
SELECT
     last_name,
     department_id,
     salary,
     job_id
FROM
     employees
WHERE
    department_id != 90;

--*****************************************************************************************************************************************************
                                   ----------- OTHER COMPARISON CONDITIONS ----------------
--*****************************************************************************************************************************************************
---BETWEEN ...AND...
--Display range  between two comparision values along with those two comparision values (behaves as <= and >=).
--We should specify the lower limit first and then the upper limit.

SELECT
     last_name,
     department_id,
     salary,
     job_id
FROM
     employees
WHERE
     salary BETWEEN 6000 AND 10000;

SELECT * FROM employees WHERE ROWNUM BETWEEN 1 AND 10;


---------NOT BETWEEN...AND... ------------
--Display all the values except the range and two comparision parameters.
SELECT
     last_name,
     department_id,
     salary,
     job_id
FROM
     employees
WHERE
     salary NOT BETWEEN 6000 AND 10000;


------- IN and MULTIPLE IN ----------
-----IN
-- Use the IN membership condition to test for values in a list.
--If we use the Upper form of the in_condition condition(with a single expression to the left of the operator),then
--we must use the upper form of expression_list.
--The Oracle IN condition is used to help reduce the need to use multiple OR conditions in a SELECT, INSERT, UPDATE, or DELETE statement.

--syntax:
exper IN (value1,value2,value3,...)

--Simple use of IN using OR Operator.
SELECT
     first_name,
     email,
     job_id,
     salary
FROM
     employees
WHERE
    job_id = 'SH_CLERK'
OR
    job_id = 'AD_ASST'
OR
    job_id = 'MK_REP';

--Using IN

SELECT
     first_name,
     email,
     job_id,
     salary
FROM
     employees
WHERE
    job_id IN ('SH_CLERK','AD_ASST','MK_REP');

--EG with number
SELECT
     first_name,
     email,
     job_id,
     salary
FROM
     employees
WHERE
    salary IN (2600,5000,11000);


--Using Upper function.
SELECT
     first_name,
     email,
     job_id,
     salary
FROM
     employees
WHERE
    Upper(first_name) IN ('BRITNEY','VANCE','KEVIN');

--NOT IN
--Display the rows except the matching conditions of IN Operator.
SELECT
     first_name,
     email,
     job_id,
     salary
FROM
     employees
WHERE
    job_id NOT IN ('SH_CLERK','AD_ASST','MK_REP');


----MULTIPLE IN ---
--If we use lower form of this condition(with multiple expressions to the left of the operator),
--then we must use the lower form of expression_list,and the expressions in each expression_list
--must match in number and datatype the expressions to the left of the operator.

--Simple MULTIPLE IN using OR and AND Operator.
SELECT
     first_name,
     email,
     job_id,
     salary
FROM
     employees
WHERE
    job_id = 'SH_CLERK' AND email = 'DOCONNEL' AND salary = 2600
OR
    job_id = 'AD_ASST'  AND email = 'JWHALEN'  AND salary = 4400
OR
    job_id = 'MK_MAN'   AND email = 'MHARTSTE' AND salary = 13000;

--Multiple IN
--COMMA between the expression denotes OR and the COMMA within the expression denotes AND.
SELECT
     first_name,
     email,
     job_id,
     salary
FROM
     employees
WHERE
     (Lower(job_id),Lower(email),salary) IN (('sh_clerk','doconnel',2600),('ad_asst','jwhalen',4400),('mk_man','mhartste',13000));


----- LIKE and  MULTIPLE LIKE ------
--We can combine the pattern matching character.
-- % denotes 0 to n charachter and _ denotes 1 character.
--We can use the ESCAPE identifier to find the actual % and _ .

--Display all the rows of the first_name column of employees table wherever in first_name character b is present.
SELECT
     first_name
FROM
     employees
WHERE
     Upper(first_name) LIKE Upper('%b%');

--Using NOT
SELECT
     first_name
FROM
     employees
WHERE
     Upper(first_name)NOT LIKE Upper('%b%');


--Display all the rows where in job_id finds the values with _ .
SELECT
     first_name,
     job_id
FROM
     employees
WHERE
    job_id LIKE '%/_%' ESCAPE '/' ;

--Displays the values which starts with J and can be any character after that.
SELECT
     first_name,
     job_id
FROM
     employees
WHERE
     first_name LIKE 'J%';

--Displays the values which last character is n  and can be any character before that.
SELECT
     first_name,
     job_id
FROM
     employees
WHERE
     first_name LIKE '%n';


----MULTIPLE LIKE  ------
--We can use MULTIPLE LIKE by 4 ways
--1.SIMPLY USING OR Operator
--2.CREATING TABLE
--3.CREATING DATATYPE
--4.USING REGULAR EXPRESSION

--Creating test_like table to test the multiple LIKE conditions
DROP TABLE test_like;

CREATE TABLE test_like
AS
SELECT employee_id,first_name FROM employees UNION
SELECT employee_id,job_id FROM employees;

SELECT * FROM test_like;

--1.SIMPLY USING OR Operator
SELECT
     first_name
FROM
     test_like
WHERE
     Upper(first_name) LIKE 'IT/_%' ESCAPE '/'
OR
     Upper(first_name) LIKE  Upper('__a%')
OR
     Upper(first_name) LIKE Upper('%cc%');



--2.CREATING TABLE for MULTIPLE LIKE Conditions.
--Create supplementary table storing pattern of character need to search.
DROP TABLE test_like1;

CREATE TABLE test_like1
(
 c1    VARCHAR2(20)
);

INSERT INTO test_like1
SELECT 'IT/_%'  c1  FROM dual UNION ALL
SELECT '__a%'   c1 FROM dual UNION ALL
SELECT '%cc%'   c1 FROM dual UNION ALL
SELECT '%D/_A%' c1 FROM dual;

SELECT * FROM test_like1;

--Query to fetch data using MULTIPLE LIKE using next table
SELECT
     t.first_name
FROM
     test_like t
WHERE
     t.first_name IN (SELECT
                            t.first_name
                      FROM
                            test_like1 t1
                      WHERE
                           Upper(t.first_name) LIKE Upper(t1.c1) ESCAPE '/');



--3.CREATING DATATYPE
--MULTIPLE LIKE USING USER DEFINED DATA TYPE.

--Creating TYPE we get table of one column whose name is COLUMN_VALUE.
CREATE OR REPLACE TYPE type_like AS TABLE OF VARCHAR2(4000);
/

SELECT * FROM TABLE(type_like());

SELECT
     employee_id,
     first_name
FROM
     test_like t
WHERE
     Upper(t.first_name) IN (SELECT
                                   Upper(t.first_name)
                             FROM
                                  TABLE(type_like('IT/_%','__a%','%cc%','%D/_A%')) b
                             WHERE
                                  Upper(t.first_name) LIKE Upper(b.column_value) ESCAPE '/');


---MULTIPLE LIKE USING REGULAR EXPRESSION.
-- ^ denotes the starting character.
-- $ denotes the last character.
-- . denotes 1 character.
-- | denotes OR Operator.
-- We dont need to define ESCAPE '/' because in regular expression it is auto detect.

SELECT
     employee_id,
     first_name
FROM
     test_like t
WHERE
     regexp_like(Upper(first_name),'(^IT/_PROG$|..A|CC|D/_A)');


--NULL Conditions: NULL Condition include the IS NULL condition and the IS NOT NULL Condition.
--Null value is unavailable,unassigned,unknown or inapplicable

--Display all the NULL values in the commission_pct column.
SELECT
     employee_id,
     first_name,
     commission_pct
FROM
     employees
WHERE
     commission_pct IS NULL;

--Display all the  values in the commission_pct column except the NULL.
SELECT
     employee_id,
     first_name,
     commission_pct
FROM
     employees
WHERE
     commission_pct IS NOT NULL;


--***********************
--doc.oracle.com
--***********************
--Compares a value to every value in a list or returned by a query. Must be preceded by =, !=, >, <, <=, >=. Can be followed by any expression or subquery that returns one or more values.
--Evaluates to TRUE if the query returns no rows.

--When we use SOME AND ANY comparision condition then the query compare each value in the list individually.

SELECT * FROM employees
  WHERE salary >=
  SOME ( 1400, 3000);

SELECT * FROM employees
  WHERE salary >=
  ANY ( 1400, 3000);

SELECT * FROM employees
  WHERE salary = ANY
  (SELECT salary
   FROM employees
  WHERE department_id = 30);


--When we use ALL comparision condition the query compares all the values in combine form
SELECT * FROM employees
  WHERE salary >=
  ALL ( 1400, 3000);


------LOGICAL CONDITIONS ------
--A logical condition combines the result of two component condition to produce
--a single result based on them or inverts the result of a single condition
--A row is returned if the overall result of the condition is true

--AND
--OR
--NOT

--AND :- Returns TRUE if both component conditions are true.
SELECT
     employee_id,
     last_name,
     job_id,
     salary
FROM
     employees
WHERE
    salary >= 10000
AND
    job_id LIKE '%AD/_%' ESCAPE '/';

--OR :- Returns TRUE if either component conditions are true.
SELECT
     employee_id,
     last_name,
     job_id,
     salary
FROM
     employees
WHERE
    salary >= 10000
OR
    job_id LIKE '%AD/_%' ESCAPE '/';

--NOT :- Returns TRUE if the following condition is false.
--Examples in COMPARISON CONDITIONS .

SELECT
     first_name,
     salary,
     job_id
FROM
     employees
WHERE
    salary IN (2600,5000,10000,13000);


SELECT
     first_name,
     salary,
     job_id
FROM
     employees
WHERE
    salary NOT IN (2600,5000,10000,13000);



--Rules of Precedence
-- 1  Arithmetic Operator
-- 2  Concatenation Operator
-- 3  Comparison Condition
-- 4  IS [NOT] NULL , LIKE , [NOT] IN
-- 5  [NOT] BETWEEN
-- 6  NOT Logical Condition
-- 7  AND Logical Condition
-- 8  OR  Logical Condition

--Override rules of precedence by using parentheses.


------ORDER BY ------------
--ORDER BY helps in sorting data in the table.It is the last clause of the SELECT statement We can ORDER BY by 3 ways
--1.BY column_name
--2.BY aliase name
--3.BY Position
--There are two types of sorting ascending and descending .Ascending is default and can be use as ASC
--FOR descending sorting we use DESC.

--sorting Ascending
SELECT
     first_name,
     last_name,
     salary,
     job_id
FROM
     employees
ORDER BY
     first_name ASC;

--Sorting Descending
SELECT
     first_name,
     last_name,
     salary,
     job_id
FROM
     employees
ORDER BY
     first_name DESC;

--Sorting by Column name
SELECT
     first_name,
     last_name,
     salary,
     job_id
FROM
     employees
ORDER BY
     first_name ASC;

--Sorting by Aliase
SELECT
     first_name,
     last_name,
     salary sal,
     job_id
FROM
     employees
ORDER BY
     sal DESC;

--Sorting by Position
--Gives the position of the column by the COLUMN_ID column of the EMPLOYEES table.
SELECT * FROM all_tab_cols WHERE table_name = 'EMPLOYEES';

--While fetching the certain column from the table the position of the fetch column is considered.(watched in memory)
SELECT
     first_name,
     last_name,
     salary,
     job_id
FROM
     employees
ORDER BY
     3 desc;

SELECT * FROM employees ORDER BY 3;

--Sorting by Multiple Column
--Arrange salary in descending with respect to the ascending salary.
SELECT
     first_name,
     last_name,
     department_id,
     salary,
     job_id
FROM
     employees
ORDER BY
     department_id ,salary DESC;



--sorting
--while sorting NULL values are displayed last for ascending sequence and displayed first for descending sequence.
SELECT
     first_name,
     salary,
     job_id,
     commission_pct
FROM
     employees
ORDER BY
     commission_pct;

SELECT
     first_name,
     salary,
     job_id,
     commission_pct
FROM
     employees
ORDER BY
     commission_pct DESC;


--Here sorting by three columns department_id, first_name sorts in ASCENDING and salary sorts in DESCENDING.
SELECT

     first_name,
     department_id,
     salary,
     job_id
FROM
     employees
ORDER BY
     department_id,first_name,salary desc;


SELECT
     first_name,
     department_id,
     salary,
     job_id
FROM
     employees
ORDER BY
     JOB_ID, department_id DESC;

-- SORTING by using salary with its alise.
SELECT
     first_name,
     salary AS sal,
     job_id,
     department_id
FROM
     employees
ORDER BY
     sal DESC;
	 
--Two Types of SQL Functions
--1.   ---> Single-row functions  --->

--These functions operate on single rows only and return one result per row.There are different types of single-row functions.
--Features of single-row functions includes:
--.Acting on each row returned in the query,
--.Returning one result per row
--.Possibly returning a data value of a different type than that referenced
--.Possibly expecting one or more arguments
--.Can be used in SELECT, WHERE, and ORDER BY clause;can be nested.

--Syntax:  function_name[(arg1,arg2,...)]
--function_name : is the name of the function,
--arg1,arg2 : is any argement to be used by the function.This can be represented by a column name or expression.


--2.   --->
       ---> Multiple-row functions --->
       --->
--Functions can manipulate group of rows to give one result per group of rows.These functions are known as group functions.


--CASE-MANIPULATION FUNCTION
--Lower(column|expression) : Converts alpha character values to lowercase
SELECT
     first_name,
     Lower(job_id)
FROM
     employees;

--Upper(column|expression) : Converts alpha character values to uppercase.
SELECT
     Upper(first_name),
     job_id
FROM
     employees;

--InitCap(column|expression) : Converts alpha character values to uppercase for the first letter of each word,all other letters in lowercase.
SELECT
     first_name,
     InitCap(job_id)
FROM
     employees;

------CHARACTER MANIPULATION FUNCTION----------
--CONCAT(column|expression,column|expression) : Join only two column or expressions.It is not so fisible because concatination operator used in replace of concat function
--which can concat number of data.
SELECT
     Concat(first_name,last_name)
FROM
     employees;

--Use multiple concat function
SELECT
     Concat(Concat(first_name,last_name),Concat(job_id,salary)) "Concat fn"
FROM
     employees;
--this concat function can be replaced by concatination operator as follows
SELECT
     first_name||last_name||job_id||salary "Concat OP"
FROM
     employees;

--LENGTH(column|expression) : Display the number of character in the expression or in column.
SELECT
     Length(first_name)
FROM
     employees;

--We can do arithmetic calculation after the length()function
SELECT
     Length(first_name) +2
FROM
     employees;

--REPLACE(text,search_string,replacement_string)
--Searchs a text expression for a character string and ,if found,replaces it with a specified replacement string.
SELECT
     REPLACE('devesh','S','O')
FROM
      dual;
--Can replace the character in given string no mater how many are there.
SELECT
     REPLACE('black and blue','bl','O')
FROM
      dual;

SELECT
     REPLACE(first_name,'a','OOOO')
FROM
     employees;

SELECT
     REPLACE(job_id,'_','@')
FROM
     employees;

--Cannot replace NULL because NULL is unavailable ,unknown or inapplicable values.
SELECT
     REPLACE(commission_pct,NULL,'@')
FROM
     employees;


--LPAD(column |expression ,n,'string'):Pads the character value right-justified to a width of n character.
--Add the * to the left part of the values to make total width 10.
SELECT
     LPad(salary,10,'*')
FROM
     employees;
--display only 3 character does not matter what is the range of the datatype is declare.
SELECT
     LPad(salary,3,'*')
FROM
     employees;

--RPAD(column |expression ,n,'string'):Pads the character valu left-justified to a width of n character.
--Add the * to the right part of the values to make total width 10.
SELECT
     RPad(salary,10,'*')
FROM
     employees;

--display only 3 character does not matter what is the range of the datatype is declare.
SELECT
     RPad(salary,3,'*')
FROM
     employees;

--TRIM(leading |trailing|both,trim_character FROM trim_source):Trim Only one character
--Enables you to trim heading or triling character(or both) from a character string.If trim_character
--or trim_source is a character literal,you must enclose in single quotes.

SELECT
     Trim('H' FROM 'HhellohA')
FROM
     dual;

--To trim from the header side.
SELECT
     Trim(leading 'H' FROM 'HhellohAH')
FROM
     dual;

--To trim from the tail side.
SELECT
     Trim(trailing 'H' FROM 'HhellohAH')
FROM
     dual;


SELECT
     Trim('H' FROM 'HHHHHHH')
FROM
     dual;

--LTrim(trim_source,trim_character):Trim more than 1 character at a time.
--Trim the character from the Left side of the trim_source.
SELECT
     LTrim('HhellohA','H')
FROM
     dual;

SELECT
     LTrim('HhellohA','Hhe')
FROM
     dual;

--RTrim(trim_source,trim_character):Trim more than 1 character at a time.
--Trim the character from the Right side of the trim_source.

SELECT
     RTrim('HhellohA','A')
FROM
     dual;

SELECT
     RTrim('HhellohA','Aho')
FROM
     dual;


--SUBSTR(column|expression,m,n):  Extracts a string of determined length
--m :- starting position  if +ve start from heading and if -ve then start from the tail.
--n :- number of character from the starting position.If not defined then takes all the characters till the end of string. cannot be -ve.
--If defined nore than the length of string then also display till the end.
--Starts from the second position and takes five character.
SELECT
     SubStr('deveshkumarshrivastav',2,5)
FROM
    dual;


SELECT
     SubStr('deveshkumarshrivastav',-2,3)
FROM
    dual;

--INSTR(COLUMN|expression,m,n) : Finds numeric position of a named character.
--m :- character whose position needs to be displayed.
--n :- defines the starting position if not given or + then start from the heading
--else if -ve then start from the tail but counting of position will be from the heading.
SELECT
     InStr('deveshkumarshrivastav','a')
FROM
     dual;
	 
SELECT
     InStr('deveshkumarshrivastav','a',1,2)
FROM
     dual;

SELECT
     InStr('deveshkumarshrivastav','a',1,3)
FROM
     dual;
	 
SELECT
     InStr('deveshkumarshrivastav','a',-1)
FROM
     dual;

--We can do arithmetic calculation on the instr function.
SELECT
     InStr('deveshkumarshrivastav','a',-1) + 5
FROM
     dual;


---EXISTS AND NOT EXISTS
--If a subquery returns any rows at all,EXISTS subquery is TRUE ,and NOT EXISTS subquery is FALSE.
-- Traditionally, an EXISTS subquery starts with SELECT *, but it could begin with SELECT 5 or SELECT column1 or anything at all.
--If the subquery(inner query) returns the rows the fetch data will be displayed in outer query
SELECT
     first_name,
     salary
FROM
     employees
WHERE EXISTS (SELECT * FROM dual);


SELECT
     first_name,
     salary
FROM
     employees
WHERE EXISTS (SELECT emp_id FROM employees);

--NOT EXISTS
SELECT
     first_name,
     salary
FROM
     employees
WHERE NOT EXISTS (SELECT first_name,salary FROM employees);


SELECT
     e.DEPARTMENT_ID
FROM
     employees e
WHERE
    EXISTS (SELECT d.DEPARTMENT_ID FROM departments d WHERE e.DEPARTMENT_ID != d.DEPARTMENT_ID);

SELECT
     e.DEPARTMENT_ID
FROM
     employees e
WHERE
    NOT EXISTS (SELECT 1 FROM departments d WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID);


------MULTIPLE EQUALS TO ----------
DROP TABLE TABLE_NAME;
CREATE TABLE TABLE_NAME
(
 C1,
 C2,
 C3
)
AS
(SELECT 1 C1, 'A' C2, 'A' C3 FROM DUAL UNION ALL
 SELECT 2 C1, 'B' C2, 'B' C3 FROM DUAL UNION ALL
 SELECT 3 C1, 'C' C2, 'C' C3 FROM DUAL) ;

SELECT * FROM TABLE_NAME;


-- Multiple EQUAL TO
-- MULTIPLE EQUAL TO IS USED ONLY IN SUB-QUERY.
UPDATE TABLE_NAME
SET
   (C2,C3)=(SELECT 'X' C2, 'Y' C3 FROM DUAL) ;


ROLLBACK;

SELECT * FROM TABLE_NAME;

INSERT INTO table_name(c1,c2,c3)SELECT 4 c1 ,'P' c2 ,'Q' c3 FROM dual;

DELETE FROM table_name
WHERE
    (c2,c3) =  (SELECT 'B' c2, 'B' c3 FROM dual);

ROLLBACK;

SELECT * FROM TABLE_NAME;


----EXTRA QUESTIONS---

SELECT InStr('01_ABC_22012016.txt','_',-1)+1 FROM dual;

SELECT InStr('01_ABC_22012016.txt','.',-1) FROM dual;

SELECT SubStr('01_ABC_22012016.txt',InStr('01_ABC_22012016.txt','_',-1)+1 , InStr('01_ABC_22012016.txt','.',-1)-2-InStr('01_ABC_22012016.txt','_',-1)+1 ) FROM dual;



InStr(COLUMN|expression,character_to_find,starting_position,no_of_occurance);

SELECT
     InStr('ababababcbaba','b',1,4)
FROM
     dual;

SELECT
     InStr('deveshkumarshrivastav','a',1,2)
FROM
     dual;


------- NUMBER FUNCTIONS ------
-----ROUND(column|expression,n)
--Rounds the column,expression,or value to n decimal places,or,if n is omited,no decimal plcaes.
--(If n is negative,numbers to left of the decimal point are rounded.)

SELECT
     Round(49.925,0),
     Round(49.925,1),
     Round(49.952,1),
     Round(49.925,2),
     Round(49.925,3),
     Round(49.925,-1),
     Round(49.925,-2),
     Round(54.925,-2),
     Round(576.576,-2)
FROM dual;

----TRUNC(column|expression,n)
--TRUNC :  The TRUNC function truncate the colum,expression,or value to n decimal places,or,if n is ommited,then n defaults to zero
--n can be negative to truncate (make zero) n digits left of the decimal point.
SELECT
      Trunc(54.78),
      Trunc(54.78,0),
      Trunc(54.7877,1),
      Trunc(54.7834,2),
      Trunc(54.7823,-1),
      Trunc(5394.7823,-2)
FROM
      dual;

--MOD : Returns the remainder of m divided by n.
--Syntax: MOD(m,n)

SELECT
     last_name,
     salary,
     'divided by 1000 and reminder :=',
     Mod(salary,1000)
FROM
     employees;

--******************************************************************************
--        WORKING WITH DATES
--******************************************************************************

--Arithmetic Operation
--Add 1 day on the sysdate
SELECT
     SYSDATE +1
FROM
     dual;

--Subtract 1 day from the sysdate
SELECT
     SYSDATE - 1
FROM
     dual;

--Dates minus Date
--Gives number of days
SELECT
     To_Date('02-jan-2016') - To_Date('02-sep-2015')
FROM
     dual;

--We get difference of date in days and hour, minute,and second in their independent form
SELECT
    TO_TIMESTAMP('02.05.2016 10:10:09','DD.MM.YYYY HH24:MI:SS') - TO_TIMESTAMP('01.02.2016 05:05:01','DD.MM.YYYY HH24:MI:SS') "DateDiff"
FROM
    dual;
--DATE FUNCTIONS
--Months_Between
--Add_Months
--Next_Day
--Last_Day
--Round
--Trunc

--MONTHS_BETWEEN
--Fetch the months between two dates
SELECT
     Trunc(Months_Between(SYSDATE ,hire_date),0) "Months Between"
FROM
    employees;
--We can do arithmetical operations on the output of the months_between function.
SELECT
     Trunc(Months_Between(SYSDATE ,hire_date),0) + 1 "Months Between"
FROM
    employees;

--ADD_MONTHS
--Add the number of months on the given date.
SELECT
     Add_Months(SYSDATE ,2)
FROM
     dual;

SELECT
     Add_Months(To_Date('02-jan-2016') ,2)
FROM
     dual;

--NEXT_DAY
--Fetch when the given day will occur in the next date
SELECT
     Next_Day(SYSDATE , 'sunday')
FROM
     dual;

--LAST_DAY
--Fetch the last day of the month
SELECT
     Last_Day(sysdate)
FROM
     dual;

SELECT
     Last_Day(To_Date('03-oct-2016'))
FROM
     dual;

--ROUND
--Gives the round date
--Before WEDNESDAY(11:59:59 AM) round function round the date to SUNDAY(starting date of the week) and after WEDNESDAY(12:00:01 PM) round to next SUNDAY(starting date of next week)
SELECT
     Round(SYSDATE,'DAY')
FROM
     dual;

--If round before half of the month  gives the starting date of the month after half of the month gives starting date of next month.
SELECT
     Round(SYSDATE,'MONTH')
FROM
     dual;

--If before 6 months it gives starting date of the year and after 6 months it gives starting date of next year.
SELECT
     Round(SYSDATE,'YEAR')
FROM
     dual;

--TRUNC
--Gives the starting date of the week
SELECT
     Trunc(SYSDATE , 'DAY')
FROM
     dual;

SELECT
     Trunc(To_Date('25-jul-95') , 'DAY')
FROM
     dual;


--Gives the starting date of the month.
SELECT
     Trunc(SYSDATE , 'MONTH')
FROM
     dual;

SELECT
     Trunc(To_Date('25-jul-95') , 'MONTH')
FROM
     dual;

--Gives the starting date of the year.
SELECT
     Trunc(SYSDATE , 'YEAR')
FROM
     dual;

SELECT
     Trunc(To_Date('25-jul-95') , 'YEAR')
FROM
     dual;

SELECT
     To_Char(SYSDATE ,'DDSPTH "of"  MONTH.YYYYSP am')
FROM
     dual;

--Explicit Data-Type Conversion
--To_Char(number|date,[fmt],nlsparams)
--TO_CHAR FUNCTION WITH DATES
--To_Char(date,'format_model')
SELECT
     last_name,
     salary,
     To_Char(hire_date,'fmdd-month-year') "HIRE DATE",
     job_id
FROM
     employees
WHERE
     department_id = 50;

--FM removes the unwanted space in the given date.
SELECT
     To_Char(To_Date('   02-  jan-  2016'),'DAY.MONTH.YEAR') "DATE WITH SPACE",
     To_Char(To_Date('   02-  jan-  2016'),'FMDAY.MONTH.YEAR pm bc') "DATE WITHOUT SPACE"
FROM
     DUAL;

SELECT
     To_Char(SYSDATE,'DD-MONTH-YY'),
     To_Char(SYSDATE,'FMDD-MONTH-YY')
FROM
     DUAL;


--FX : The fx modifier specifies exact matching for the character argument and date format model of a TO_DATE function
SELECT
     last_name,
     hire_date
FROM
     employees
WHERE
     hire_date = To_Date('13 jan ,2008','dd-mon-yy ');
--If we use fx modifier on the same date format given above it gives error.
-- ORA-01861: literal does not match format string
SELECT
     last_name,
     hire_date
FROM
     employees
WHERE
     hire_date = To_Date('13 jan ,2008','fxdd-mon-yy ');

--Element of the Date Format Model
--YYYY
--YY
--YEAR
--MM
--MONTH
--MON
--DY
--DAY
--DD
--And many more.

--sample format elements fo Valid DATE Formats
--AD|BC,AM|PM
SELECT
     To_Char(To_Date('   02-  jan-  2016'),'DAY.MONTH.YEAR') "DATE WITH SPACE",
     To_Char(To_Date('   02-  jan-  2016'),'FMDAY.MONTH.YEAR pm bc') "DATE WITHOUT SPACE"
FROM
     DUAL;

--Specifying Suffixes to Influence Number display
--TH : Ordinal number(eg.DDTH for 4TH)
--SP : Spelled-out number (eg.DDSP for FOUR)
--SPTH OR THSP : Spelled -out ordinal numbers(eg.DDSPTH for FOURTH)
SELECT
     To_Char(SYSDATE ,'DDTH "OF" MONTH YEAR'),
     To_Char(SYSDATE ,'DDSPTH "OF" MONTH  YYYYSP')
FROM
     DUAL;

--Date Formate Elements : Time Formats
SELECT
     To_Char(SYSDATE ,'DD-MONTH-YEAR HH:MI:SS AM'),
     To_Char(SYSDATE ,'fmDD/MONTH/YEAR HH24:MI:SSSS A.M.')
FROM
     DUAL;

------******* Using the TO_CHAR Function with Number *********----
--TO_CHAR(number,'format_model')
--Number Format Elements
--L also gives $ because its not set on nls local currency format.
SELECT
     last_name,
     job_id,
     To_Char(salary , 'L99,999.00') "Local Currency",
     To_Char(salary , '$99,999.00') "Dollar",
     To_Char(salary , '$00,000.00') "Dollar"
FROM
     employees;

--TO_DATE : To_Date function is used to  the data on the table and for the comparision condition.
--We should To_Date function to assign to the dummy table (virtual table)
SELECT
     To_Char('09-feb-2016','day-month-year')
FROM
     dual;
--ORA-01722: invalid number

--Able to assign after using To_Date function.
SELECT
     To_Char(To_Date('09-feb-2016'),'fmday-month-year')
FROM
     dual;

-------****** RR DATE FORMAT *******-----------
--DD-MON-RR
--If two digits of the current year is 0-49 then if the specified two-digit year is 0-49
--the return date is in the current century and if the specified two-digit year is 50-99
--then the return date is in the century before the current one.


--If two digits of the current year is 50-99 then if the specified two-digit year is 0-49
--the return value is in the century after the current one and if the specified two-digit year is 50-99
--then the return date is in the current century.
--CC display the century
--EG:the current year is between 0-49(16)
SELECT
     To_Char(To_Date('02-jan-23') , 'dd-mon-rr cc')
FROM
     dual;
--02-jan-23 21

SELECT
     To_Char(To_Date('02-jan-57') , 'dd-mon-rr cc')
FROM
     dual;
--02-jan-57 20

--EG:set your system date so that it lies between 50-99(i set it 2055)
SELECT
     To_Char(To_Date('02-jan-23') , 'dd-mon-rr cc')
FROM
     dual;
--02-jan-23 22

SELECT
     To_Char(To_Date('02-jan-57') , 'dd-mon-rr cc')
FROM
     dual;
--02-jan-57 21

----------****** Nesting Functions ******-------------
--General Functions
--NVL(expr1,expr2)
--When expr1 is NULL the function gives expr2 and if expr1 NOT NULL then gives expr1.
SELECT
     Nvl(commission_pct,111)
FROM
     employees;

--NVL2(expr1,expr2,expr3)
--If expr1 is NULL gives expr3 and if expr1 is NOT NULL then gives expr2 both null gives expr3.
SELECT
     commission_pct,
     manager_id,
     Nvl2(commission_pct,manager_id,111)
FROM
     employees;

--NULLIF (expr1,expr2)
--If expr1 and expr2 is equal then returns NULL ELSE expr1
SELECT
     Length(first_name),
     Length(last_name),
     NULLIF(Length(first_name),Length(last_name))
FROM
     employees;

--COALESCE(expr1,expr2,expr3,...,exprn)
--If expr1 is NULL gives expr2 if expr2 is also NULL then gives expr3 if expr3 is also NULL gives expr4 and so on untill gives NOT NULL value
SELECT
     commission_pct,
     manager_id,
     employee_id,
     COALESCE(commission_pct,manager_id,employee_id)
FROM
     employees;

--Combine query.
SELECT
     commission_pct,
     manager_id,
     employee_id,
     Length(first_name),
     Length(last_name),
     Nvl(commission_pct,111) "nvl",
     Nvl2(commission_pct,manager_id,111) "nvl2",
     NULLIF(Length(first_name),Length(last_name)) "nullif",
     COALESCE(commission_pct,manager_id,employee_id) "coalesce"
FROM
     employees;


------******** CONDITIONAL EXPRESSIONS ********-------
----CASE EXPRESSIONS

--Case Expression let us use IF...THEN...ELSE logic in SQL statements without having to invoke procedures.
CASE {simple_case_expression
     |searched_case_expression
     }
     [else_clause]
     END

--simple_case_expression
expr WHEN comparison_expr THEN return_expr
     [WHEN comparison_expr THEN return_expr]...

--searched_case_expression
WHEN condition THEN return_expr
[WHEN condition THEN return_expr]


--else_condition
ELSE  else_expr;


--EG: Simple CASE Expression
SELECT
     e.salary,
     CASE salary WHEN  10000 THEN 'Highest Salary'
                 WHEN  5000 THEN 'Lowest Salary'
     ELSE 'Medium Salary' END "Salary Grade"
FROM
     employees e;

--EG: Searched CASE Expression
SELECT
     e.salary,
     CASE
          WHEN e.salary > 10000 THEN 'Highest Salary'
          WHEN e.salary < 5000 THEN 'Lowest Salary'
     ELSE 'Medium Salary' END "Salary Range"
FROM
     employees e;

/*
Write an anonymous block to fetch a columns based on flaging
if 1 then
'EMPLOYEE_ID, FIRST_NAME, LAST_NAME'
if 2 then
'EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY'
else
'COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID'
FROM hr.employees
hint:use CASE expression
*/

DECLARE
    vblflag    NUMBER := 1 ;
    vblsql     VARCHAR2(32767);
    vbl1       NUMBER;
BEGIN
     vblsql := 'SELECT
                    CASE
                       WHEN '||vblflag||' = 1 THEN (SELECT employee_id FROM employees WHERE ROWNUM = 1)
                       WHEN '||vblflag||' = 2 THEN (SELECT salary FROM employees WHERE ROWNUM = 1)
                       ELSE manager_id END AS "emp"
               FROM
                    employees where rownum = 1';

     EXECUTE IMMEDIATE (vblsql) INTO vbl1;
     Dbms_Output.Put_Line(vbl1);
END;
/

DECLARE
     vblflag   NUMBER := 1;
     vbl1      VARCHAR2(100);
     vbl2      VARCHAR2(100);
     vblelse   VARCHAR2(100);
     vblsql    VARCHAR2(32767);
BEGIN
     vbl1    := 'EMPLOYEE_ID||'' , ''||FIRST_NAME||'' , ''||LAST_NAME';
     vbl2    := 'EMAIL||'' ,''||PHONE_NUMBER||'' ,''||HIRE_DATE||'' ,''||JOB_ID||'' ,''||SALARY';
     vblelse := 'COMMISSION_PCT||'' ,''||MANAGER_ID||'' ,''||DEPARTMENT_ID';

     vblsql := 'SELECT
                    CASE
                       WHEN '||vblflag||' = 1 THEN '||vbl1||'
                       WHEN '||vblflag||' = 2 THEN '||vbl2||'
                    ELSE
                       '||vblelse||'
                    END                                  columns
                FROM
                    hr.employees';
     Dbms_Output.Put_Line(vblsql);
END;
/
DECLARE
    vblsql   VARCHAR2(32767);
    vblsql1  VARCHAR2(200);
    vblsql2  NUMBER;
    vblsql3  NUMBER;
BEGIN
    vblsql := 'SELECT employee_id||department_id||'' ''||manager_id FROM employees where rownum = 1';
    EXECUTE IMMEDIATE (vblsql) INTO vblsql1;
    Dbms_Output.Put_Line(vblsql1);

END;
/
--Creating Table using the CASE EXPRESSION
DECLARE
    vblflag   NUMBER := 1;
    vblsql    VARCHAR2(32767);
    vbl1      VARCHAR2(200);
    vbl2      VARCHAR2(200);
    vbl3      VARCHAR2(200);
BEGIN
    vbl1 := 'c1   VARCHAR2(20)';
    vbl2 := 'c2   NUMBER(5)';
    vbl3 := 'c3   DATE';

    vblsql := 'CREATE TABLE t_flag
              (
                '||CASE WHEN vblflag = 1 THEN vbl1
                        WHEN vblflag = 2 THEN vbl2
                   ELSE vbl3 END||'
              );';
    Dbms_Output.Put_Line(vblsql);
END;
/

--
DECLARE
    vblflag   NUMBER := 1;
    vbl       VARCHAR(32767);
    vblsql    VARCHAR2(32767);
    vbl1      VARCHAR2(200);
    vbl2      VARCHAR2(200);
    vbl3      VARCHAR2(200);
BEGIN
    vbl :=  CASE WHEN vblflag = 1 THEN 'c1   VARCHAR2(20), c2  VARCHAR2(50)'
                 WHEN vblflag = 2 THEN 'c1   NUMBER(5)  ,  c2 NUMBER(10)'
            ELSE 'c1   DATE, c2  DATE'
            END;

    vblsql := 'CREATE TABLE t_flag
              (
                '||CASE WHEN vblflag = 1 THEN vbl
                        WHEN vblflag = 2 THEN vbl
                   ELSE vbl END||'
              );';
    Dbms_Output.Put_Line(vblsql);
END;
/


DECLARE
    vblflag   NUMBER := 1;
    vbl       VARCHAR(32767);
    vblsql    VARCHAR2(32767);
    vbl1      VARCHAR2(200);
    vbl2      VARCHAR2(200);
    vbl3      VARCHAR2(200);
BEGIN
    vbl :=  CASE
               WHEN vblflag = 1 THEN 'c1   VARCHAR2(20), c2  VARCHAR2(50)'
               WHEN vblflag = 2 THEN 'c1   NUMBER(5)  ,  c2 NUMBER(10)'
            ELSE
               'c1   DATE, c2  DATE'
            END;

    vblsql := 'CREATE TABLE t_flag
              (
                '|| vbl||'
              );';
    Dbms_Output.Put_Line(vblsql);
END;
/

DECLARE
    vblflag             NUMBER := 1;
    vblcolumn           VARCHAR(32767);
    vblcreatetable      VARCHAR2(32767);
    vblinsert           VARCHAR2(32767);
BEGIN
    vblcolumn := CASE WHEN vblflag = 1 THEN 'c1   VARCHAR2(20), c2  VARCHAR2(50)'
                      WHEN vblflag = 2 THEN 'c1   NUMBER(5)  ,  c2 NUMBER(10)'
                 ELSE 'c1   DATE, c2  DATE' END;

    vblcreatetable := 'CREATE TABLE t_flag
                       (
                        '|| vbl||'
                       );';

    Dbms_Output.Put_Line(vblcreatetable);

    vblinsert := 'INSERT INTO t_flag(c1,c2)
                  '||CASE
                        WHEN vblflag = 1 THEN ('SELECT ''devesh'' c1, ''Pantha'' c2 FROM dual')
                        WHEN vblflag = 2 THEN ('SELECT 1  c1, 2 c2 FROM dual')
                     ELSE
                        ('SELECT SYSDATE c1, SYSDATE +1 c2 FROM dual')
                     END||';';

    Dbms_Output.Put_Line(vblinsert);
END;
/

CREATE TABLE t_flag
(
  c1   VARCHAR2(20), c2  VARCHAR2(50)
);
INSERT INTO t_flag(c1,c2)
                  SELECT 'devesh' c1, 'Pantha' c2 FROM dual;

SELECT * FROM t_flag;

---using IF - THEN - ELSE

DECLARE
    vblflag   NUMBER ;
    vbl       VARCHAR(32767);
    vblsql    VARCHAR2(32767);
    vbl1      VARCHAR2(200);
    vbl2      VARCHAR2(200);
    vbl3      VARCHAR2(200);
BEGIN
    IF (vblflag = 1) THEN
        vbl := 'c1   VARCHAR2(20), c2  VARCHAR2(50)';
    ELSIF (vblflag = 2) THEN
        vbl :='c1   number(1), c2  number(1)';
    ELSE
       vbl :='c1   DATE, c2  DATE';
    END IF ;

    vblsql := 'CREATE TABLE t_flag
              (
                '||CASE
                      WHEN vblflag = 1 THEN vbl
                      WHEN vblflag = 2 THEN vbl
                   ELSE
                      vbl
                   END||'
              );';
    Dbms_Output.Put_Line(vblsql);
END;
/


DECLARE
    vblflag   NUMBER;
    vbl       VARCHAR(32767);
    vblsql    VARCHAR2(32767);
    vbl1      VARCHAR2(200);
    vbl2      VARCHAR2(200);
    vbl3      VARCHAR2(200);
BEGIN
    IF (vblflag = 1) THEN
        vbl := 'c1   VARCHAR2(20), c2  VARCHAR2(50)';
    ELSIF (vblflag = 2) THEN
        vbl :='c1   number(1), c2  number(1)';
    ELSE
       vbl :='c1   DATE, c2  DATE';
    END IF ;

    vblsql := 'CREATE TABLE t_flag
              (
                '||vbl||'
              );';
    Dbms_Output.Put_Line(vblsql);
END;
/

--We cannot use IF - THEN - ELSE in query.

DECLARE
    vblflag   NUMBER := 1;
    vbl       VARCHAR(32767);
    vblsql    VARCHAR2(32767);
    vbl1      VARCHAR2(200);
    vbl2      VARCHAR2(200);
    vbl3      VARCHAR2(200);
BEGIN
    vblsql := 'CREATE TABLE t_flag
              (
                '||IF (vblflag = 1) THEN
                      'c1   VARCHAR2(20), c2  VARCHAR2(50)'

                   END IF;||'
              );';
    Dbms_Output.Put_Line(vblsql);
END;
/

----DECODE FUNCTIONS
--The DECODE function decodes an expression in a way similar to the IF-THEN-ELSE login used in various language.
--Syntax:
Decode (expr,search,result
[,search,result]...
[,default]
);


SELECT
     last_name,job_id,salary,
     Decode( job_id,'IT_PROG' , salary + 1
                   ,'ST_CLERK', salary + 2
                   ,'SA_REP'  , salary + 3
                   ,salary
           )"SAL"
FROM
     employees;


DECLARE
    vblflag   NUMBER := 1;
    vblsql    VARCHAR2(32767);
    vbl1      VARCHAR2(200);
    vbl2      VARCHAR2(200);
    vbl3      VARCHAR2(200);
    vbloutput VARCHAR2(100);
BEGIN
    vbl1 := 'c1   VARCHAR2(20)';
    vbl2 := 'c2   NUMBER(5)';
    vbl3 := 'c3   DATE';

    SELECT
         Decode( vblflag,1,vbl1,2,vbl2,vbl3) INTO vbloutput
    FROM
         dual;
    vblsql := 'CREATE TABLE t_flag
              (
                '||vbloutput||'
              );';
    Dbms_Output.Put_Line(vbloutput);
    Dbms_Output.Put_Line(vblsql);
END;
/


--Subsitute variable & --takes input form many times AND && takes single input.
--Aggregate Function Ignores the null values.
--AVG
--COUNT
--MAX
--MIN
--STDDEV
--SUM
--VARIANCE

--***NOTE : AVG,SUM,VARIANCE and STDDEV functions can be used only with numeric data types.
-- COUNT,MAX,MIN can be used with STRING and DATE too.

--AVG([DISTINCT|ALL]N):AVERAGE VALUE OF N,IGNORING NULL VALUES.
SELECT
     Avg(DISTINCT department_id)
FROM
     employees;

SELECT
     Avg(salary),
     department_id
FROM
     employees
GROUP BY
     department_id,salary ;

--COUNT({*|[DISTINCT|ALL]EXPR}): Number of rows,where expr evaluates to something other than null(count all selected rows using *,including duplicates and rows with nulls)
SELECT
     Count(employee_id)
FROM
     employees;

--MAX([DISTINCT|ALL]EXPR):Maximum value of expr,ignoring null values
SELECT
     Max(salary)
FROM
     employees;

--MIN([DISTINCT|ALL]EXPR):Minimum value of expr,ignoring null values
SELECT
     Min(salary)
FROM
     employees;

--STDDEV([DISTINCT|ALL]X):Standard deviation of n,ignoring null values
SELECT
     StdDev(salary)
FROM
     employees;

--VARIANCE([DISTINCT|ALL]n): Variance of n, ignoring null values
SELECT
     Variance(salary)
FROM
     employees;

--SUM([DISTINCT|ALL]n) : Sum values of n ignoring all null values.
SELECT
     Sum(salary)
FROM
     employees
WHERE
     department_id = 90;

SELECT
     Sum(salary)
FROM
     employees;

--GROUP FUNCTIONS SYNTAX
SELECT
     [COLUMN,] group_function(COLUMN),...
FROM
     TABLE
[WHERE
     condition]
[GROUP BY
     group_by_expression]
[HAVING
     group_condition]
[ORDER BY
     COLUMN];

--group_by_expression : Specifies columns whose values determine the basis for grouping rows.
--group_condition :Restrict the groups of rows returned to those groups fro which the specified condition is true.

--We cannot use WHERE clause in GROUP BY Function to restrict groups.
--We use the HAVING clause to restrict groups.
SELECT
     department_id,
     JOB_ID,
     Max(salary)
FROM
     employees
GROUP BY
     department_id,JOB_ID
HAVING
     Max(salary) > 10000;


SELECT
     department_id,
     JOB_ID,
     Max(salary)
FROM
     employees
GROUP BY
     department_id,JOB_ID
HAVING
     Max(salary) > 10000
ORDER BY
     Max(salary);

--EG1:
SELECT
     employee_id,
     first_name,
     last_name,
     department_id,
     salary
FROM
     employees
WHERE
    department_id IN  (
                      SELECT
                           department_id
                      FROM
                           employees
                      GROUP BY
                           department_id
                      HAVING
                           Count(department_id) =1
                     );

--EG2:
SELECT
     department_id,
     Count(department_id)
FROM
     employees
GROUP BY
     department_id
HAVING
     Count(department_id) =1;

----NESTING GROUP FUNCTION
SELECT
     Max(Avg(salary))
FROM
     employees
GROUP BY
      department_id;


--EG3:
SELECT
     employee_id,
     first_name,
     last_name,
     department_id,
     salary
FROM
     employees
WHERE
    department_id IN  (
                      SELECT
                           department_id
                      FROM
                           employees
                      GROUP BY
                           department_id
                      HAVING
                           Count(department_id) =1
                     );


SELECT * FROM job_history;

SELECT * FROM jobs;

SELECT
     e.first_name,
     e.last_name,
     e.job_id,
     j.job_id,
     j.min_salary,
     j.max_salary

FROM
     employees e JOIN jobs j
ON
     ( e.job_id = j.job_id AND e.salary BETWEEN j.min_salary AND j.max_salary);

--The combination of outer query and inner query is known as SUBQUERY
--Syntax:
SELECT
     select_list
FROM
     table_name
WHERE
     expr OPERATOR (SELECT
                         select_list
                    FROM
                         table_name
                   );
--The subquery (inner query ) executes once before the main query.
--The result of the subquery is used by the main query(outer query).
SELECT
     employee_id,
     first_name,
     last_name,
     department_id,
     salary
FROM
     employees
WHERE
    Nvl(department_id,0) IN  (
                       SELECT
                            Nvl(department_id,0)
                       FROM
                            employees
                       WHERE
                           department_id IS null
                      );



SELECT * FROM employees;

SELECT * FROM departments;

SELECT * FROM locations;

SELECT * FROM job_history;

SELECT * FROM jobs;

---EG Subquery
SELECT
     first_name,
     last_name,
     salary,
     department_id
FROM
     employees
WHERE
     department_id in (
                       SELECT
                            department_id
                       FROM
                           departments
                       WHERE
                           department_id IN (
                                             SELECT
                                                   department_id
                                             FROM
                                                   job_history
                                             WHERE
                                                  job_id IN (
                                                             SELECT
                                                                  job_id
                                                             FROM
                                                                  jobs
                                                             )
                                            )
                      );
--SINGLE ROW SUBQUERY
--Operator : = , <= , >= , < , >, <> , != , =^
SELECT
     last_name,
     salary,
     job_id
FROM
     employees
WHERE
    salary = (SELECT
                   salary
              FROM
                   employees
              WHERE
                   last_name = 'Austin');


--The HAVING Clause with Subqueries
--The Oracle Server executes subqueries first.
--The Oracle Server returns results into the HAVING clause of the main query.

SELECT
     department_id,
	   Min(salary)
FROM
     employees
GROUP BY
     department_id
HAVING
     Min(salary) > (SELECT
                         Min(salary)
                    FROM
                         employees
                    WHERE
                         department_id = 50
                    );





--Multiple Row Subquery
-- IN , ANY , ALL
---IN : Equal to any member in the list.
SELECT
     last_name,
     salary,
     job_id
FROM
     employees
WHERE
     salary IN (5000,8000,10000,11000)
ORDER BY
     salary;


SELECT
     last_name,
     salary,
     department_id
FROM
     employees
WHERE
    department_id IN (SELECT
                           department_id
                      FROM
                           employees
                      WHERE
                           job_id = 'IT_PROG'
                      );

--ANY: Compare value to each value returned by the subquery.
-- <ANY means less than the maximum
-- >ANY means less than the minimum

SELECT
     last_name,
     salary,
     job_id
FROM
     employees
WHERE
     salary < ANY (SELECT salary FROM employees WHERE job_id = 'ST_MAN');

SELECT
     last_name,
     salary,
     job_id
FROM
     employees
WHERE
     salary > ANY (SELECT salary FROM employees WHERE job_id = 'ST_MAN');



--ALL : Compare value to every value returned by the subquery
-- <ALL means less than the maximum.
-- >ALL means more than the minimum.
SELECT
     last_name,
     salary,
     job_id
FROM
     employees
WHERE
     salary > ALL (SELECT salary FROM employees WHERE job_id = 'ST_MAN');

SELECT
     last_name,
     salary,
     job_id
FROM
     employees
WHERE
     salary < ALL (SELECT salary FROM employees WHERE job_id = 'ST_MAN');

--To fetch ALTERNATE records FROM a table. (EVEN NUMBERED)
SELECT 
     *
FROM 
     employees
WHERE 
     ROWID IN (
		       SELECT 
                    CASE 
                       WHEN MOD(ROWNUM, 2) = 0 THEN ROWID 
                    ELSE 
                       NULL 
                    END data
		       FROM 
                    employees
		      );

--To SELECT ALTERNATE records FROM a table. (ODD NUMBERED)
SELECT 
     *
FROM 
     employees
WHERE 
     ROWID IN (
		       SELECT 
                    CASE 
                       WHEN MOD(ROWNUM, 2) = 0 THEN NULL 
                    ELSE 
                       ROWID 
                    END data
		       FROM 
                    employees
		          );

--Find the 3rd MAX salary in the employees table.
SELECT DISTINCT
     salary 
FROM 
     employees e1 
WHERE 
     3 = (
          SELECT 
               COUNT(DISTINCT salary) 
          FROM 
               employees e2 
          WHERE 
               e1.salary <= e2.salary
         );

SELECT DISTINCT
     salary 
FROM 
     (
      SELECT 
           salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) salaryrank 
      FROM 
           employees
     ) 
WHERE 
     salaryrank = 3;

--Find the 3rd MIN salary in the employees table.
SELECT DISTINCT
     salary 
FROM 
     employees e1 
WHERE 
     3 = (
          SELECT 
               COUNT(DISTINCT salary) 
          FROM 
               employees e2 
          WHERE 
               e1.salary >= e2.salary
         );

SELECT DISTINCT
     salary 
FROM 
     (
      SELECT 
           salary,
           DENSE_RANK() OVER (ORDER BY salary ASC) salaryrank 
      FROM 
           employees
     ) 
WHERE 
     salaryrank = 3;

--SELECT FIRST n records FROM a table.
SELECT 
     * 
FROM 
     employees 
WHERE 
     ROWNUM <= &n;

--SELECT LAST n records FROM a table
SELECT * FROM employees 
MINUS 
SELECT 
     * 
FROM 
     employees 
WHERE 
     ROWNUM <= (
                SELECT 
                     COUNT(*) - &n 
                FROM 
                     employees
               );

--List dept no., Dept name for all the departments in which there are no employeesloyees in the department.
SELECT 
     * 
FROM 
     departments 
WHERE 
     department_id NOT IN (
                           SELECT 
                                NVL(department_id,0) department_id 
                           FROM 
                                employees
                          );    
SELECT 
     * 
FROM 
     departments a 
WHERE NOT EXISTS (
                  SELECT 
                       * 
                  FROM 
                       employees b 
                  WHERE 
                       a.department_id = b.department_id
                 );                                                                 
SELECT 
     b.department_id,
     b.department_name 
FROM 
     employees a, departments b 
WHERE 
     a.department_id(+) = b.department_id 
AND 
     employee_id IS NULL;

--How to get 3 Max salaryaries ?
SELECT DISTINCT
     salary 
FROM 
     employees e1 
WHERE 
     3 >= (
          SELECT 
               COUNT(DISTINCT salary) 
          FROM 
               employees e2 
          WHERE 
               e1.salary <= e2.salary
         )
ORDER BY e1.salary DESC;

--How to get 3 Min salaryaries ?
SELECT DISTINCT
     salary 
FROM 
     employees e1 
WHERE 
     3 >= (
          SELECT 
               COUNT(DISTINCT salary) 
          FROM 
               employees e2 
          WHERE 
               e1.salary >= e2.salary
         )
ORDER BY e1.salary ASC;

--How to get nth max salaryaries ?
SELECT DISTINCT 
     salary 
FROM 
     employees a 
WHERE &n = (
            SELECT 
                 COUNT(DISTINCT salary) 
            FROM 
                 employees b 
            WHERE 
                 a.salary >= b.salary
           );

--SELECT DISTINCT RECORDS FROM employees table.
SELECT 
     * 
FROM 
     employees a 
WHERE  
     ROWID = (
              SELECT 
                   MAX(ROWID) 
              FROM 
                   employees b 
              WHERE  
                   a.employee_id=b.employee_id
             );

--How to delete duplicate rows in a table?
DELETE FROM employees a 
WHERE 
    ROWID != (
              SELECT 
                   MAX(ROWID) 
              FROM 
                   employees b 
              WHERE  
                   a.employee_id=b.employee_id
             );

DELETE FROM employees a 
WHERE 
    ROWID > ANY (
                 SELECT 
                      ROWID 
                 FROM 
                      employees b 
                 WHERE  
                      a.employee_id=b.employee_id
                );

--COUNT of number of employeesloyees in  department  wise.
SELECT 
     COUNT(employee_id), 
     b.department_id, 
     department_name 
FROM 
     employees a, departments b  
WHERE 
     a.department_id(+)=b.department_id  
GROUP BY 
     b.department_id,department_name;

--Suppose there is annual salary information provided by employees table. How to fetch monthly salary of each and every employeesloyee?
SELECT 
     first_name,
     salary/12 as monthlysalary 
FROM 
     employees;

--SELECT all record FROM employees table WHERE department_id =10 or 40.
SELECT 
     * 
FROM 
     employees 
WHERE 
     department_id=30 OR department_id=10;

--SELECT all record FROM employees table WHERE department_id=30 and salary>1500.
SELECT 
     * 
FROM 
     employees 
WHERE 
     department_id=30 AND salary>1500;

--SELECT  all record  FROM employees WHERE job not in salaryESMAN  or CLERK.
SELECT 
     * 
FROM 
     employees 
WHERE 
     job_id NOT IN ('salaryESMAN','CLERK');

--SELECT all record FROM employees WHERE first_name in 'BLAKE','SCOTT','KING'and'FORD'.
SELECT 
     * 
FROM 
     employees 
WHERE 
     first_name IN ('JONES','BLAKE','SCOTT','KING','FORD');

--SELECT all records WHERE first_name starts with ‘S’ and its lenth is 6 char.
SELECT 
     * 
FROM 
     employees 
WHERE 
     first_name like'S____';

--SELECT all records WHERE first_name may be any no of  character but it should end with ‘R’.
SELECT 
     * 
FROM 
     employees 
WHERE 
     first_name LIKE '%R';

--COUNT  MGR and their salary in employees table.
SELECT 
     COUNT(manager_id),
     COUNT(salary) 
FROM 
     employees;

--In employees table add comm+salary as total salary  .
SELECT 
     first_name,
     (salary+NVL(commission_pct,0)) AS totalsalary 
FROM 
     employees;

--SELECT  any salary <3000 FROM employees table. 
SELECT 
     * 
FROM 
     employees 
WHERE 
     salary > ANY (
                   SELECT 
                        salary 
                   FROM 
                        employees 
                   WHERE salary<3000
                  );

--SELECT  all salary <3000 FROM employees table. 
SELECT 
     * 
FROM 
     employees  
WHERE 
     salary > ALL (
                   SELECT 
                        salary 
                   FROM 
                        employees 
                   WHERE 
                        salary < 3000
                  );

--SELECT all the employeesloyee  group by department_id and salary in descending order.
SELECT 
     first_name,
     department_id,
     salary 
FROM 
     employees 
ORDER BY 
     department_id,salary DESC;

--How can I create an employeesty table employees1 with same structure as employees?
CREATE TABLE employees1 
AS 
SELECT * FROM employees WHERE 1=2;

--How to retrive record WHERE salary between 1000 to 2000?
SELECT 
     * 
FROM 
     employees 
WHERE 
     salary >= 1000 AND salary < 2000;

--SELECT all records WHERE dept no of both employees and dept table matches.
SELECT 
     * 
FROM 
     employees e
WHERE 
     EXISTS ( 
             SELECT 
                  * 
             FROM 
                  departments d
             WHERE 
                  e.department_id=d.department_id
            );

--If there are two tables employees1 and employees2, and both have common record. How can I fetch all the recods but common records only once?
(SELECT * FROM employees) 
 UNION 
(SELECT * FROM employees1);

--How to fetch only common records FROM two tables employees and employees1?
(SELECT * FROM employees) 
 INTERSECT 
(SELECT * FROM employees1);

--How can I retrive all records of employees1 those should not present in employees2?
(SELECT * FROM employees) 
 MINUS 
(SELECT * FROM employees1);

--COUNT the totalsa  department_id wise WHERE more than 2 employeesloyees exist.
SELECT  
     department_id, 
     SUM(salary) AS totalsalary
FROM 
     employees
GROUP BY 
     department_id
HAVING COUNT(employee_id) > 2;

-- To Generate Token from Oracle
SELECT 
     Dbms_Random.string('U',10) string_a,
     Dbms_Random.string('L',10) string_l,
     Dbms_Random.string('P',10) string_p,
     Dbms_Random.string('X',10) string_x
FROM dual;

As a database developer, writing SQL queries, PLSQL code is part of daily life. Having a good knowledge on SQL is really important. Here i am posting some practical examples on SQL queries.

To solve these interview questions on SQL queries you have to create the products, sales tables in your oracle database. The "Create Table", "Insert" statements are provided below.


CREATE TABLE PRODUCTS
(
  PRODUCT_ID     INTEGER,
  PRODUCT_NAME   VARCHAR2(30)
);
CREATE TABLE SALES
(
  SALE_ID        INTEGER,
  PRODUCT_ID     INTEGER,
  YEAR           INTEGER,
  Quantity       INTEGER,
  PRICE          INTEGER
);       

INSERT INTO PRODUCTS VALUES ( 100, 'Nokia');
INSERT INTO PRODUCTS VALUES ( 200, 'IPhone');
INSERT INTO PRODUCTS VALUES ( 300, 'Samsung');
INSERT INTO PRODUCTS VALUES ( 400, 'LG');

INSERT INTO SALES VALUES ( 1, 100, 2010, 25, 5000);
INSERT INTO SALES VALUES ( 2, 100, 2011, 16, 5000);
INSERT INTO SALES VALUES ( 3, 100, 2012, 8,  5000);
INSERT INTO SALES VALUES ( 4, 200, 2010, 10, 9000);
INSERT INTO SALES VALUES ( 5, 200, 2011, 15, 9000);
INSERT INTO SALES VALUES ( 6, 200, 2012, 20, 9000);
INSERT INTO SALES VALUES ( 7, 300, 2010, 20, 7000);
INSERT INTO SALES VALUES ( 8, 300, 2011, 18, 7000);
INSERT INTO SALES VALUES ( 9, 300, 2012, 20, 7000);
COMMIT;

The products table contains the below data.


SELECT * FROM PRODUCTS;

PRODUCT_ID PRODUCT_NAME
-----------------------
100        Nokia
200        IPhone
300        Samsung

The sales table contains the following data.


SELECT * FROM SALES;

SALE_ID PRODUCT_ID YEAR QUANTITY PRICE
--------------------------------------
1       100        2010   25     5000
2       100        2011   16     5000
3       100        2012   8      5000
4       200        2010   10     9000
5       200        2011   15     9000
6       200        2012   20     9000
7       300        2010   20     7000
8       300        2011   18     7000
9       300        2012   20     7000

Here Quantity is the number of products sold in each year. Price is the sale price of each product.

I hope you have created the tables in your oracle database. Now try to solve the below SQL queries.

1. Write a SQL query to find the products which have continuous increase in sales every year?

Solution:

Here “Iphone” is the only product whose sales are increasing every year.

STEP1: First we will get the previous year sales for each product. The SQL query to do this is


SELECT 
     P.PRODUCT_NAME, 
     S.YEAR, 
     S.QUANTITY, 
     LEAD(S.QUANTITY,1,0) OVER (PARTITION BY P.PRODUCT_ID ORDER BY S.YEAR DESC) QUAN_PREV_YEAR
FROM   
     PRODUCTS P, SALES S
WHERE  
     P.PRODUCT_ID = S.PRODUCT_ID;


PRODUCT_NAME YEAR QUANTITY QUAN_PREV_YEAR
-----------------------------------------
Nokia        2012    8         16
Nokia        2011    16        25
Nokia        2010    25        0
IPhone       2012    20        15
IPhone       2011    15        10
IPhone       2010    10        0
Samsung      2012    20        18
Samsung      2011    18        20
Samsung      2010    20        0

Here the lead analytic function will get the quantity of a product in its previous year. 

STEP2: We will find the difference between the quantities of a product with its previous year’s quantity. If this difference is greater than or equal to zero for all the rows, then the product is a constantly increasing in sales. The final query to get the required result is


SELECT 
     PRODUCT_NAME
FROM
    (
     SELECT 
          P.PRODUCT_NAME, 
          S.QUANTITY - LEAD(S.QUANTITY,1,0) OVER (PARTITION BY P.PRODUCT_ID ORDER BY S.YEAR DESC) QUAN_DIFF
     FROM   
          PRODUCTS P, SALES S
     WHERE  
          P.PRODUCT_ID = S.PRODUCT_ID
    )A
GROUP BY 
    PRODUCT_NAME
HAVING MIN(QUAN_DIFF) >= 0;

PRODUCT_NAME
------------
IPhone


2. Write a SQL query to find the products which does not have sales at all?

Solution:

“LG” is the only product which does not have sales at all. This can be achieved in three ways.

Method1: Using left outer join.


SELECT 
     P.PRODUCT_NAME
FROM   
     PRODUCTS P LEFT OUTER JOIN SALES S
ON   
    (P.PRODUCT_ID = S.PRODUCT_ID);
WHERE  
     S.QUANTITY IS NULL

PRODUCT_NAME
------------
LG

Method2: Using the NOT IN operator.


SELECT 
     P.PRODUCT_NAME
FROM   
     PRODUCTS P
WHERE  
     P.PRODUCT_ID NOT IN (
                          SELECT DISTINCT 
                               PRODUCT_ID 
                          FROM 
                               SALES
                         );

PRODUCT_NAME
------------
LG

Method3: Using the NOT EXISTS operator.


SELECT 
     P.PRODUCT_NAME
FROM   
     PRODUCTS P
WHERE  
     NOT EXISTS (
                 SELECT 
                      1 
                 FROM 
                      SALES S 
                 WHERE 
                      S.PRODUCT_ID = P.PRODUCT_ID
                );

PRODUCT_NAME
------------
LG


3. Write a SQL query to find the products whose sales decreased in 2012 compared to 2011?

Solution:

Here Nokia is the only product whose sales decreased in year 2012 when compared with the sales in the year 2011. The SQL query to get the required output is


SELECT 
     P.PRODUCT_NAME
FROM   
     PRODUCTS P, SALES S_2012, SALES S_2011
WHERE  
     P.PRODUCT_ID = S_2012.PRODUCT_ID
AND    
     S_2012.YEAR = 2012
AND    
     S_2011.YEAR = 2011
AND    
     S_2012.PRODUCT_ID = S_2011.PRODUCT_ID
AND    
     S_2012.QUANTITY < S_2011.QUANTITY;

PRODUCT_NAME
------------
Nokia

4. Write a query to select the top product sold in each year? 

Solution:

Nokia is the top product sold in the year 2010. Similarly, Samsung in 2011 and IPhone, Samsung in 2012. The query for this is 


SELECT 
     PRODUCT_NAME,
     YEAR
FROM
    (
     SELECT 
          P.PRODUCT_NAME,
          S.YEAR,
          RANK() OVER (PARTITION BY S.YEAR ORDER BY S.QUANTITY DESC) RNK
     FROM   
          PRODUCTS P, SALES S
     WHERE  
          P.PRODUCT_ID = S.PRODUCT_ID
    ) A
WHERE 
    RNK = 1;

PRODUCT_NAME YEAR
--------------------
Nokia        2010
Samsung      2011
IPhone       2012
Samsung      2012

5. Write a query to find the total sales of each product.? 

Solution:

This is a simple query. You just need to group by the data on PRODUCT_NAME and then find the sum of sales. 


SELECT 
     P.PRODUCT_NAME,
     NVL( SUM( S.QUANTITY*S.PRICE ), 0) TOTAL_SALES
FROM 
     PRODUCTS P LEFT OUTER JOIN SALES S
ON     
    (P.PRODUCT_ID = S.PRODUCT_ID)
GROUP BY 
     P.PRODUCT_NAME;

PRODUCT_NAME TOTAL_SALES
---------------------------
LG            0
IPhone        405000
Samsung       406000
Nokia         245000
SQL Queries Interview Questions - Oracle Part 2
This is continuation to my previous post, SQL Queries Interview Questions - Oracle Part 1 , Where i have used PRODUCTS and SALES tables as an example. Here also i am using the same tables. So, just take a look at the tables by going through that link and it will be easy for you to understand the questions mentioned here.

Solve the below examples by writing SQL queries.

1. Write a query to find the products whose quantity sold in a year should be greater than the average quantity of the product sold across all the years?

Solution:

This can be solved with the help of correlated query. The SQL query for this is


SELECT 
     P.PRODUCT_NAME,
     S.YEAR,
     S.QUANTITY
FROM   
     PRODUCTS P, SALES S
WHERE  
     P.PRODUCT_ID = S.PRODUCT_ID
AND    
     S.QUANTITY > (
                   SELECT 
                        AVG(QUANTITY) 
                   FROM 
                        SALES S1 
                   WHERE S1.PRODUCT_ID = S.PRODUCT_ID
                  );

PRODUCT_NAME YEAR QUANTITY
--------------------------
Nokia        2010    25
IPhone       2012    20
Samsung      2012    20
Samsung      2010    20

2. Write a query to compare the products sales of "IPhone" and "Samsung" in each year? The output should look like as


YEAR IPHONE_QUANT SAM_QUANT IPHONE_PRICE SAM_PRICE
---------------------------------------------------
2010   10           20       9000         7000
2011   15           18       9000         7000
2012   20           20       9000         7000

Solution:

By using self-join SQL query we can get the required result. The required SQL query is


SELECT 
     S_I.YEAR,
     S_I.QUANTITY IPHONE_QUANT,
     S_S.QUANTITY SAM_QUANT,
     S_I.PRICE    IPHONE_PRICE,
     S_S.PRICE    SAM_PRICE
FROM   
     PRODUCTS P_I, SALES S_I, PRODUCTS P_S, SALES S_S
WHERE  
     P_I.PRODUCT_ID = S_I.PRODUCT_ID
AND    
     P_S.PRODUCT_ID = S_S.PRODUCT_ID
AND    
     P_I.PRODUCT_NAME = 'IPhone'
AND    
     P_S.PRODUCT_NAME = 'Samsung'
AND    
     S_I.YEAR = S_S.YEAR

3. Write a query to find the ratios of the sales of a product? 

Solution:

The ratio of a product is calculated as the total sales price in a particular year divide by the total sales price across all years. Oracle provides RATIO_TO_REPORT analytical function for finding the ratios. The SQL query is 


SELECT 
     P.PRODUCT_NAME,
     S.YEAR,
     RATIO_TO_REPORT(S.QUANTITY*S.PRICE) OVER(PARTITION BY P.PRODUCT_NAME ) SALES_RATIO
FROM   
     PRODUCTS P, SALES S
WHERE 
    (P.PRODUCT_ID = S.PRODUCT_ID);

PRODUCT_NAME YEAR      RATIO
-----------------------------
IPhone       2011   0.333333333
IPhone       2012   0.444444444
IPhone       2010   0.222222222
Nokia        2012   0.163265306
Nokia        2011   0.326530612
Nokia        2010   0.510204082
Samsung      2010   0.344827586
Samsung      2012   0.344827586
Samsung      2011   0.310344828

4. In the SALES table quantity of each product is stored in rows for every year. Now write a query to transpose the quantity for each product and display it in columns? The output should look like as 


PRODUCT_NAME QUAN_2010 QUAN_2011 QUAN_2012
------------------------------------------
IPhone       10        15        20
Samsung      20        18        20
Nokia        25        16        8

Solution:

Oracle 11g provides a pivot function to transpose the row data into column data. The SQL query for this is 


SELECT 
     * 
FROM
    (
     SELECT 
          P.PRODUCT_NAME,
          S.QUANTITY,
          S.YEAR
     FROM   
          PRODUCTS P, SALES S
     WHERE 
         (P.PRODUCT_ID = S.PRODUCT_ID)
    )A
    PIVOT 
    ( MAX(QUANTITY) AS QUAN FOR (YEAR) IN (2010,2011,2012));

If you are not running oracle 11g database, then use the below query for transposing the row data into column data. 


SELECT 
     P.PRODUCT_NAME,
     MAX(DECODE(S.YEAR,2010, S.QUANTITY)) QUAN_2010,
     MAX(DECODE(S.YEAR,2011, S.QUANTITY)) QUAN_2011,
     MAX(DECODE(S.YEAR,2012, S.QUANTITY)) QUAN_2012
FROM   
     PRODUCTS P, SALES S
WHERE 
    (P.PRODUCT_ID = S.PRODUCT_ID)
GROUP BY 
     P.PRODUCT_NAME;

5. Write a query to find the number of products sold in each year?

Solution:

To get this result we have to group by on year and the find the count. The SQL query for this question is

SELECT 
     YEAR,
     COUNT(1) NUM_PRODUCTS
FROM  
     SALES
GROUP BY 
     YEAR;

YEAR  NUM_PRODUCTS
------------------
2010      3
2011      3
2012      3
SQL Queries Interview Questions - Oracle Part 3
Here I am providing Oracle SQL Query Interview Questions. If you find any bugs in the queries, Please do comment. So, that i will rectify them.

1. Write a query to generate sequence numbers from 1 to the specified number N?

Solution:


SELECT 
     LEVEL 
FROM 
     DUAL 
CONNECT BY LEVEL <= &N;

2. Write a query to display only friday dates from Jan, 2000 to till now?

Solution:


SELECT  
     C_DATE,
     TO_CHAR(C_DATE,'DY') 
FROM 
    (
     SELECT 
          TO_DATE('01-JAN-2000','DD-MON-YYYY')+LEVEL-1 C_DATE 
     FROM   
          DUAL 
     CONNECT BY LEVEL <= (SYSDATE - TO_DATE('01-JAN-2000','DD-MON-YYYY')+1) 
    )
WHERE 
    TO_CHAR(C_DATE,'DY') = 'FRI'; 

3. Write a query to duplicate each row based on the value in the repeat column? The input table data looks like as below


Products, Repeat
----------------
A,         3
B,         5
C,         2

Now in the output data, the product A should be repeated 3 times, B should be repeated 5 times and C should be repeated 2 times. The output will look like as below


Products, Repeat
----------------
A,        3
A,        3
A,        3
B,        5
B,        5
B,        5
B,        5
B,        5
C,        2
C,        2

Solution:


SELECT 
     PRODUCTS,
     REPEAT 
FROM  
     T, ( 
         SELECT 
              LEVEL L 
         FROM 
              DUAL 
         CONNECT BY LEVEL <= (
                              SELECT 
                                   MAX(REPEAT) 
                              FROM 
                                   T
                             ) 
        ) A 
WHERE 
     T.REPEAT >= A.L 
ORDER BY 
     T.PRODUCTS;

4. Write a query to display each letter of the word "SMILE" in a separate row?


S
M
I
L
E

Solution:


SELECT 
     SUBSTR('SMILE',LEVEL,1) A 
FROM   
     DUAL 
CONNECT BY LEVEL <= LENGTH('SMILE');

5. Convert the string "SMILE" to Ascii values?  The output should look like as 83,77,73,76,69. Where 83 is the ascii value of S and so on.
The ASCII function will give ascii value for only one character. If you pass a string to the ascii function, it will give the ascii value of first letter in the string. Here i am providing two solutions to get the ascii values of string.

Solution1:


SELECT 
     SUBSTR(DUMP('SMILE'),15) 
FROM 
     DUAL;

Solution2:


SELECT 
     WM_CONCAT(A) 
FROM 
    (
     SELECT 
          ASCII(SUBSTR('SMILE',LEVEL,1)) A 
     FROM  
          DUAL 
     CONNECT BY LEVEL <= LENGTH('SMILE') 
    );
    
SQL Queries Interview Questions - Oracle Part 4
1. Consider the following friends table as the source


Name, Friend_Name
-----------------
sam,   ram
sam,   vamsi
vamsi, ram
vamsi, jhon
ram,   vijay
ram,   anand

Here ram and vamsi are friends of sam; ram and jhon are friends of vamsi and so on. Now write a query to find friends of friends of sam. For sam; ram,jhon,vijay and anand are friends of friends. The output should look as


Name, Friend_of_Firend
----------------------
sam,    ram
sam,    jhon
sam,    vijay
sam,    anand

Solution:


SELECT  
     f1.name,
     f2.friend_name as friend_of_friend
FROM  
     friends f1, friends f2
WHERE   
     f1.name = 'sam'
AND     
     f1.friend_name = f2.name;

2. This is an extension to the problem 1. In the output, you can see ram is displayed as friends of friends. This is because, ram is mutual friend of sam and vamsi. Now extend the above query to exclude mutual friends. The outuput should look as


Name, Friend_of_Friend
----------------------
sam,    jhon
sam,    vijay
sam,    anand

Solution:


SELECT  
     f1.name,
     f2.friend_name as friend_of_friend
FROM    
     friends f1, friends f2
WHERE   
     f1.name = 'sam'
AND     
     f1.friend_name = f2.name
AND     
     NOT EXISTS (
                 SELECT 
                      1 
                 FROM 
                      friends f3 
                 WHERE 
                      f3.name = f1.name 
                 AND   
                      f3.friend_name = f2.friend_name
                );

3. Write a query to get the top 5 products based on the quantity sold without using the row_number analytical function? The source data looks as


Products, quantity_sold, year
-----------------------------
A,         200,          2009
B,         155,          2009
C,         455,          2009
D,         620,          2009
E,         135,          2009
F,         390,          2009
G,         999,          2010
H,         810,          2010
I,         910,          2010
J,         109,          2010
L,         260,          2010
M,         580,          2010

Solution:


SELECT  
     products,
     quantity_sold,
     year
FROM
    (
     SELECT  
          products,
          quantity_sold, 
          year,
          rownum r
     FROM    
          t
     ORDER BY 
          quantity_sold DESC
    ) A
WHERE 
    r <= 5;

4. This is an extension to the problem 3. Write a query to produce the same output using row_number analytical function?

Solution:


SELECT  
     products,
     quantity_sold,
     year
FROM
    (
     SELECT 
          products,
          quantity_sold,
          year,
          ROW_NUMBER() OVER(ORDER BY quantity_sold DESC) r
     FROM 
          t
    ) A
WHERE 
    r <= 5;

5. This is an extension to the problem 3. write a query to get the top 5 products in each year based on the quantity sold?

Solution:


SELECT  
     products,
     quantity_sold,
     year
FROM
    (
     SELECT 
          products,
          quantity_sold,
          year,
          ROW_NUMBER() OVER(PARTITION BY year ORDER BY quantity_sold DESC) r
     FROM   
          t
    ) A
WHERE 
    r <= 5;
    
SQL Query Interview Questions - Part 5
Write SQL queries for the below interview questions:

1. Load the below products table into the target table.
CREATE TABLE PRODUCTS
(
  PRODUCT_ID     INTEGER,
  PRODUCT_NAME   VARCHAR2(30)
);

INSERT INTO PRODUCTS VALUES ( 100, 'Nokia');
INSERT INTO PRODUCTS VALUES ( 200, 'IPhone');
INSERT INTO PRODUCTS VALUES ( 300, 'Samsung');
INSERT INTO PRODUCTS VALUES ( 400, 'LG');
INSERT INTO PRODUCTS VALUES ( 500, 'BlackBerry');
INSERT INTO PRODUCTS VALUES ( 600, 'Motorola');
COMMIT;

SELECT * FROM PRODUCTS;

PRODUCT_ID PRODUCT_NAME
-----------------------
100        Nokia
200        IPhone
300        Samsung
400        LG
500        BlackBerry
600        Motorola

The requirements for loading the target table are:
•    Select only 2 products randomly.
•    Do not select the products which are already loaded in the target table with in the last 30 days.
•    Target table should always contain the products loaded in 30 days. It should not contain the products which are loaded prior to 30 days.
Solution:
First we will create a target table. The target table will have an additional column INSERT_DATE to know when a product is loaded into the target table. The target 
table structure is
CREATE TABLE TGT_PRODUCTS
(
  PRODUCT_ID     INTEGER,
  PRODUCT_NAME   VARCHAR2(30),
  INSERT_DATE    DATE
);

The next step is to pick 5 products randomly and then load into target table. While selecting check whether the products are there in the 
INSERT INTO TGT_PRODUCTS
SELECT  
     PRODUCT_ID,
     PRODUCT_NAME,
     SYSDATE INSERT_DATE
FROM
    (
     SELECT  
          PRODUCT_ID,
          PRODUCT_NAME
     FROM 
          PRODUCTS S
     WHERE   
          NOT EXISTS ( 
                      SELECT 
                           1
                      FROM   
                           TGT_PRODUCTS T
                      WHERE  
                           T.PRODUCT_ID = S.PRODUCT_ID
                     )
     ORDER BY 
          DBMS_RANDOM.VALUE --Random number generator in oracle.
    ) A
WHERE 
    ROWNUM <= 2;

The last step is to delete the products from the table which are loaded 30 days back. 
DELETE FROM TGT_PRODUCTS
WHERE  INSERT_DATE < SYSDATE - 30;

2. Load the below CONTENTS table into the target table. 
CREATE TABLE CONTENTS
(
  CONTENT_ID   INTEGER,
  CONTENT_TYPE VARCHAR2(30)
);

INSERT INTO CONTENTS VALUES (1,'MOVIE');
INSERT INTO CONTENTS VALUES (2,'MOVIE');
INSERT INTO CONTENTS VALUES (3,'AUDIO');
INSERT INTO CONTENTS VALUES (4,'AUDIO');
INSERT INTO CONTENTS VALUES (5,'MAGAZINE');
INSERT INTO CONTENTS VALUES (6,'MAGAZINE');
COMMIT;

SELECT * FROM CONTENTS;

CONTENT_ID CONTENT_TYPE
-----------------------
1          MOVIE
2          MOVIE
3          AUDIO
4          AUDIO
5          MAGAZINE
6          MAGAZINE

The requirements to load the target table are: 
•    Load only one content type at a time into the target table.
•    The target table should always contain only one contain type.
•    The loading of content types should follow round-robin style. First MOVIE, second AUDIO, Third MAGAZINE and again fourth Movie.

Solution: 
First we will create a lookup table where we mention the priorities for the content types. The lookup table “Create Statement” and data is shown below. 
CREATE TABLE CONTENTS_LKP
(
  CONTENT_TYPE VARCHAR2(30),
  PRIORITY     INTEGER,
  LOAD_FLAG  INTEGER
);

INSERT INTO CONTENTS_LKP VALUES('MOVIE',1,1);
INSERT INTO CONTENTS_LKP VALUES('AUDIO',2,0);
INSERT INTO CONTENTS_LKP VALUES('MAGAZINE',3,0);
COMMIT;

SELECT * FROM CONTENTS_LKP;

CONTENT_TYPE PRIORITY LOAD_FLAG
---------------------------------
MOVIE         1          1
AUDIO         2          0
MAGAZINE      3          0

Here if LOAD_FLAG is 1, then it indicates which content type needs to be loaded into the target table. Only one content type will have LOAD_FLAG as 1. The other content types will have LOAD_FLAG as 0. The target table structure is same as the source table structure. 
The second step is to truncate the target table before loading the data 
TRUNCATE TABLE TGT_CONTENTS;

The third step is to choose the appropriate content type from the lookup table to load the source data into the target table. 
INSERT INTO TGT_CONTENTS
SELECT  
     CONTENT_ID,
     CONTENT_TYPE 
FROM 
     CONTENTS
WHERE 
     CONTENT_TYPE = (
                     SELECT 
                          CONTENT_TYPE 
                     FROM 
                          CONTENTS_LKP 
                     WHERE 
                          LOAD_FLAG = 1
                    );

The last step is to update the LOAD_FLAG of the Lookup table. 
UPDATE CONTENTS_LKP
SET 
   LOAD_FLAG = 0
WHERE 
   LOAD_FLAG = 1;

UPDATE CONTENTS_LKP
SET 
  LOAD_FLAG = 1
WHERE 
  PRIORITY = (
              SELECT 
                   DECODE (PRIORITY,(SELECT MAX(PRIORITY) FROM CONTENTS_LKP) ,1 , PRIORITY+1)
              FROM   
                   CONTENTS_LKP
              WHERE  
                   CONTENT_TYPE = (SELECT DISTINCT CONTENT_TYPE FROM TGT_CONTENTS)
             );

----------------------
DROP TABLE emp purge;
CREATE TABLE emp
AS
SELECT 1 eid,'a' eadd FROM dual UNION ALL
SELECT 2 eid,'b' eadd FROM dual UNION ALL
SELECT 3 eid,'c' eadd FROM dual UNION ALL
SELECT 4 eid,'d' eadd FROM dual UNION ALL
SELECT 5 eid,'e' eadd FROM dual ;

ALTER TABLE emp MODIFY eadd VARCHAR2(10);

DROP TABLE emphist purge;
CREATE TABLE emphist
AS
SELECT 1 eid,'a'  eadd, SYSDATE     udate FROM dual UNION ALL
SELECT 1 eid,'a1' eadd, SYSDATE + 1 udate FROM dual UNION ALL
SELECT 2 eid,'b'  eadd, SYSDATE     udate FROM dual UNION ALL
SELECT 2 eid,'b1' eadd, sysdate + 1 udate FROM dual UNION ALL
SELECT 3 eid,'c'  eadd, SYSDATE     udate FROM dual ;

SELECT * FROM emp;
/*
EID EADD
--- ----
  1 a   
  2 b   
  3 c   
  4 d   
  5 e   
*/
SELECT * FROM emphist;
/*
EID EADD UDATE
--- ---- -------------------              
  1 a    20.01.2017 12:44:34
  1 a1   21.01.2017 12:44:34
  2 b    20.01.2017 12:44:34
  2 b1   21.01.2017 12:44:34
  3 c    20.01.2017 12:44:34
*/

-- You have to update the employee letest address
UPDATE emp a
SET
   a.eadd = (
             SELECT 
                  MAX(b.eadd) 
             FROM 
                  emphist b 
             WHERE 
                  a.eid = b.eid 
             AND 
                  b.udate = (
                             SELECT 
                                  MAX(c.udate) 
                             FROM 
                                  emphist c 
                             WHERE 
                                  c.eid = b.eid
                            )
            )
WHERE 
   EXISTS (
           SELECT 
                b.eadd 
           FROM 
                emphist b 
           WHERE 
                a.eid = b.eid
          );

ROLLBACK; 

SELECT * FROM emp;
/*
EID EADD
--- ----
  1 a1  
  2 b1  
  3 c   
  4 d   
  5 e   
*/

DROP TABLE esalary purge;
CREATE TABLE esalary
(
 did,
 sal
)
AS 
SELECT department_id,salary FROM employees WHERE ROWNUM <= 10 ORDER BY 1;

--You have to fetch sum of salary department wise
SELECT * FROM esalary;
/*
DID   SAL
--- -----
 10  4400
 20  6000
 20 13000
 40  6500
 50  2600
 50  2600
 70 10000
 90 24000
110  8300
110 12008
*/

SELECT 
     did,
     SUM(sal) dsal
FROM 
     esalary 
GROUP BY 
     did 
ORDER BY 
     did;

/*
DID  DSAL
--- -----
 10  4400
 20 19000
 40  6500
 50  5200
 70 10000
 90 24000
110 20308
*/