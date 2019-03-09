CREATE OR REPLACE PROCEDURE sp_insert_img_any
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
END sp_insert_img_any;
/

EXEC sp_insert_img_any('tab.txt','tab','E:\app\Atit\delimited\');