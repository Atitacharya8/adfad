select * from dict where table_name LIKE 'USER_TABLES';
SELECT
     'CREATE TABLE '||a.table_name||' AS SELECT * FROM  hr.'||a.table_name||' ;' " "
FROM 
     user_tables a ;