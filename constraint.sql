DROP TABLE tbl_con purge;
CREATE TABLE tbl_con
  (
    department_id VARCHAR2(10) NOT NULL,
    email         VARCHAR2(200) CONSTRAINT uk_email UNIQUE,
    dept_id       NUMBER CONSTRAINT fk_dept_id REFERENCES tbl_con1(dept_id),
    salary        NUMBER CONSTRAINT ck_sal CHECK(salary>1000)
  );
  
CREATE TABLE tbl_con1
  (
    dept_id         NUMBER CONSTRAINT pk_tbl_con1_dept_id PRIMARY KEY,
    department_name VARCHAR2(200) CONSTRAINT nn_dpname NOT NULL
  );
set SERVEROUTPUT ON;
begin 
 for i in 1..10
 loop 
   begin 
       execute immediate 'insert  into tbl_con1(dept_id,department_name) values(sq_tbl_con1.nextval,'''||i||'_management'')';
   end;
  end loop;
end;
/
  
  select sq_tbl_con1.nextval from dual;
drop sequence sq_tbl_con1;
create sequence sq_tbl_con1;
select * from tbl_con1;


alter table tbl_con1 
disable constraint fk_dept_id cascade;
truncate table tbl_con1
  
rollback;