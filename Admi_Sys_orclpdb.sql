alter user hr identified by oracle account unlock;

alter session set container=orclpdb;
create database link dblk_to_orclpdb
  oracle to hr identified by oracle using '( DESCRIPTION
  =(address_list =(address=(protocol=tcp)
  (host=localhost)
  (port=1521))
  (connect_data=(server=dedicated)
  (service_name=orclpdb)))';
  
  select * from dba_data_files;
  select * from dba_temp_files;
  select * from _data_files;
  grant dba to hr;
  select count (*) from dict;
  