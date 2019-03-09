-- Load image
CREATE DIRECTORY DIR_NAME AS 'E:\app\Atit\delimited\';
GRANT READ,WRITE ON DIRECTORY DIR_NAME TO PUBLIC;
'
DECLARE
    file_loc     BFILE;
    file_exist   BOOLEAN := FALSE;
BEGIN
    file_loc   := BFILENAME('DIR_NAME', 'chap1.txt');
    file_exist := DBMS_LOB.FILEEXISTS(file_loc) = 1;

    IF file_exist THEN
       DBMS_OUTPUT.PUT_LINE('chap1.txt file exists');
       DBMS_OUTPUT.PUT_LINE('opening then file');
    DBMS_LOB.FILEOPEN(file_loc);
       DBMS_OUTPUT.PUT_LINE('closing file');
    DBMS_LOB.FILECLOSE(file_loc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('file does not exist');
    END IF;
END;
/

-- Create table with blob data type==> Binary Large Object
CREATE TABLE blobs
(
  id        varchar2(255),
  blob_col  blob
);

-- To Create Procedure(subprograms) Insert_Image to Load the *.* into oracle table
CREATE OR REPLACE PROCEDURE sp_insert_img
AS
    l_f_lob bfile;
    l_b_lob BLOB;
BEGIN
    INSERT INTO blobs VALUES ( 'MY_Image', empty_blob() )
    RETURN blob_col INTO l_b_lob;

    l_f_lob := bfilename( 'DIR_NAME', 'sonu.jpg' );
    dbms_lob.fileopen(l_f_lob, dbms_lob.file_readonly);
    dbms_lob.loadfromfile( l_b_lob, l_f_lob, dbms_lob.getlength(l_f_lob) );
    dbms_lob.fileclose(l_f_lob);
    COMMIT;
END sp_insert_img;
/

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

-- Execute the Insert_Img Procedure
EXEC sp_insert_img;

-- Verification Script
SELECT * FROM  blobs;

-- To Get the *.* File from Oracle Table
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
          'sonu.jpg',
          blob_col,		  
          INTO l_t_totalsize, l_t_file_name,l_t_blob 
     FROM 
          blobs 
     WHERE 
          id = 'MY_Image';
     l_t_remain := l_t_totalsize;
     l_t_output := utl_file.fopen ('DIR_NAME', l_t_file_name, 'wb', 32760);
          
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

-- Create table with bfile data type
CREATE TABLE graphics_table 
(
  bfile_id      NUMBER,
  bfile_desc    VARCHAR2(30),
  bl_file_loc   bfile,
  bfile_type    VARCHAR2(4)
)
  storage (INITIAL 1M NEXT 1M PCTINCREASE 0
);

-- Insert *.* into oracle table --
INSERT INTO graphics_table
VALUES(1,'My brother photo',bfilename('DIR_NAME','sonu.jpg'),'jpeg');

commit;

SELECT * FROM graphics_table;
-- Create a Procedure To Get the *.* File from Oracle Table
CREATE OR REPLACE PROCEDURE sp_displaybfile
AS
  l_file_loc      bfile;
  l_buffer        RAW(1024);
  l_amount        BINARY_INTEGER := 1024;
  l_position      INTEGER        := 1;
  l_t_file_name   VARCHAR2(100);
  l_t_output      utl_file.file_type;

BEGIN
   SELECT 
        bl_file_loc INTO l_file_loc
   FROM 
        graphics_table;
        
   l_t_output := utl_file.fopen ('DIR_NAME', '02.jpg', 'wb', 32760);

   dbms_lob.open (l_file_loc, dbms_lob.LOB_READONLY);
   LOOP
      dbms_lob.read (l_file_loc, l_amount, l_position, l_buffer);
      utl_file.put_raw (l_t_output, l_buffer);
      utl_file.fflush (l_t_output);
      l_position := l_position + l_amount;
   END LOOP;

   dbms_lob.close (l_file_loc);
EXCEPTION WHEN NO_DATA_FOUND THEN
   NULL;
END sp_displaybfile;
/

-- Execute the sp_displaybfile Procedure
EXEC sp_displaybfile;


CREATE OR REPLACE PROCEDURE sp_insert_img_any
(
 p_id       VARCHAR2,
 p_filename VARCHAR2
)
AS
    l_f_lob bfile;
    l_b_lob BLOB;
BEGIN
    INSERT INTO blobs VALUES ( p_id, empty_blob() )
    RETURN blob_col INTO l_b_lob;
    
    l_f_lob := bfilename( 'DIR_NAME', p_filename );
    dbms_lob.fileopen(l_f_lob, dbms_lob.file_readonly);
    dbms_lob.loadfromfile( l_b_lob, l_f_lob, dbms_lob.getlength(l_f_lob) );
    dbms_lob.fileclose(l_f_lob);
    COMMIT;
END sp_insert_img_any;
/
EXEC sp_insert_img_any('tab.txt','tab');
EXEC sp_fetch_image_any('tab.txt','tab');

SELECT * FROM blobs;

SELECT segment_name,bytes/(1024) FROM dba_segments WHERE segment_name ='BLOBS';
COMMIT;

SELECT 892/64 FROM dual;
TRUNCATE TABLE blobs;

CREATE OR REPLACE PROCEDURE sp_fetch_image_any
(
 p_filename VARCHAR2,
 p_id       VARCHAR2
)
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
          p_filename 
          INTO l_t_totalsize, l_t_file_name 
     FROM 
          blobs 
     WHERE 
          id = p_id;
     l_t_remain := l_t_totalsize;
     l_t_output := utl_file.fopen ('DIR_NAME', l_t_file_name, 'wb', 32760);
     
     SELECT 
          blob_col INTO l_t_blob 
     FROM 
          blobs 
     WHERE 
          id = p_id;
          
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
END sp_fetch_image_any;
/

EXEC sp_fetch_image_any('tab.txt','tab');

CREATE OR REPLACE PROCEDURE sp_insert_img_any_dir
(
 p_id       VARCHAR2,
 p_filename VARCHAR2,
 p_dir_name VARCHAR2
)
AS
    l_f_lob bfile;
    l_b_lob BLOB;
BEGIN
    BEGIN
	    EXECUTE IMMEDIATE 'CREATE OR REPLACE DIRECTORY DIR_NAME AS '''||p_dir_name||''' ';
        EXECUTE IMMEDIATE 'GRANT READ,WRITE ON DIRECTORY DIR_NAME TO PUBLIC';
	EXCEPTION WHEN OTHERS THEN
	    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    END;

    INSERT INTO blobs VALUES ( p_id, empty_blob() )
    RETURN blob_col INTO l_b_lob;
    
    l_f_lob := bfilename( 'DIR_NAME', p_filename );
    dbms_lob.fileopen(l_f_lob, dbms_lob.file_readonly);
    dbms_lob.loadfromfile( l_b_lob, l_f_lob, dbms_lob.getlength(l_f_lob) );
    dbms_lob.fileclose(l_f_lob);
    COMMIT;
END sp_insert_img_any_dir;
/

