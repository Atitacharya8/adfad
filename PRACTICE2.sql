CREATE OR REPLACE DIRECTORY DIR_NAME AS 'E:\app\Atit\delimited\';
GRANT READ,WRITE ON DIRECTORY DIR_NAME TO PUBLIC;


set serveroutput on;
DECLARE
    file_loc     BFILE;
    file_exist   BOOLEAN := FALSE;
BEGIN
    file_loc   := BFILENAME('DIR_NAME', 'c.png');
    file_exist := DBMS_LOB.FILEEXISTS(file_loc) = 1;

    IF file_exist THEN
       DBMS_OUTPUT.PUT_LINE('c.png file exists');
       DBMS_OUTPUT.PUT_LINE('opening then file');
    DBMS_LOB.FILEOPEN(file_loc);
       DBMS_OUTPUT.PUT_LINE('closing file');
    DBMS_LOB.FILECLOSE(file_loc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('file does not exist');
    END IF;
END;
/

CREATE TABLE blobs
(
  id        varchar2(255),
  blob_col  blob
);

select * from blobs;

select dbms_lob.getlength(blob_col) from blobs;
truncate table blobs;
CREATE OR REPLACE PROCEDURE sp_insert_img
AS
    l_f_lob bfile;
    l_b_lob BLOB;
BEGIN
    INSERT INTO blobs VALUES ( 'MY_Image', empty_blob() )
    RETURN blob_col INTO l_b_lob;

    l_f_lob := bfilename( 'DIR_NAME', 'c.png' );
    dbms_lob.fileopen(l_f_lob, dbms_lob.file_readonly);
    dbms_lob.loadfromfile( l_b_lob, l_f_lob, dbms_lob.getlength(l_f_lob) );
    dbms_lob.fileclose(l_f_lob);
    COMMIT;
END sp_insert_img;
/

exec sp_insert_img;

select * from blobs;

commit;
select segment_name , bytes from SYS.DBA_SEGMENTS where segment_name ='BLOBS';
CREATE OR REPLACE PROCEDURE sp_fetch_image
as
     l_t_blob         BLOB;
     l_t_len          NUMBER;
     l_t_file_name    VARCHAR2(32767);
     l_t_output       utl_file.file_type;
     l_t_totalsize    NUMBER;
     l_t_l_position   NUMBER := 1;
     l_l_t_chucklen   NUMBER := 4096;
     l_t_chuck        RAW(4096);
     l_t_remain       NUMBER;
BEGIN
     SELECT 
          dbms_lob.getlength (blob_col), 
          'c.png' 
          INTO l_t_totalsize, l_t_file_name 
     FROM 
          blobs 
     WHERE 
          id = 'MY_Image';
     l_t_remain := l_t_totalsize;
     l_t_output := utl_file.fopen ('DIR_NAME', l_t_file_name, 'wb', 32760);
     
     SELECT 
          blob_col INTO l_t_blob 
     FROM 
          blobs 
     WHERE 
          id = 'MY_Image';
          
     WHILE l_t_l_position < l_t_totalsize
     LOOP
         dbms_lob.read (l_t_blob, l_l_t_chucklen, l_t_l_position, l_t_chuck);
         utl_file.put_raw (l_t_output, l_t_chuck);
         utl_file.fflush (l_t_output);
         l_t_l_position := l_t_l_position + l_l_t_chucklen;
         l_t_remain := l_t_remain - l_l_t_chucklen;

         IF l_t_remain < 4096 THEN
            l_l_t_chucklen := l_t_remain;
         END IF;

     END LOOP;
END sp_fetch_image;
/

EXEC sp_fetch_image;
