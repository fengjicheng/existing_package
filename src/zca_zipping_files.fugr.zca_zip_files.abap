FUNCTION zca_zip_files.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_FILENAME) TYPE  FILE_NAME OPTIONAL
*"     VALUE(IM_PATH) TYPE  PATHEXTERN
*"     VALUE(IM_PATTERN) TYPE  CHAR20 OPTIONAL
*"     VALUE(IM_ZIPFILENAME) TYPE  STRING OPTIONAL
*"  EXPORTING
*"     VALUE(EX_RETURN) TYPE  SYST_SUBRC
*"----------------------------------------------------------------------

  DATA: v_times           TYPE i.
  DATA: v_file            TYPE string.
  DATA: v_zip_content     TYPE xstring .
  DATA: v_content         TYPE xstring.
  DATA: go_zip            TYPE REF TO cl_abap_zip. "ZIP file
  DATA: v_filename        TYPE string.
  DATA: v_file_length     TYPE i.
  DATA: i_data  TYPE TABLE OF x255,
        st_data LIKE LINE OF i_data.

**Constants
  CONSTANTS: c_zip_ext   TYPE string VALUE '.zip',
             c_separator TYPE c      VALUE '/',
             c_pattern   TYPE char10 VALUE 'REMINDER*'.

  DATA:  unixcommand(300) TYPE c,
         files            TYPE STANDARD TABLE OF localfile,
         wa_file          TYPE localfile.

***Set attachment
* Create ZIP file
  CREATE OBJECT go_zip.

  IF im_path IS NOT INITIAL AND im_filename IS INITIAL.
    IF im_pattern IS INITIAL.
      MESSAGE i000(zrtr_r2) WITH 'Please provide a pattern to filter the files' ` ` 'to be zipped in the given path: ' im_path
      DISPLAY LIKE 'E'.
    ENDIF.
* If there is no file name provided, then read all the files with the given pattern
* Get all files under the working directory: IM_PATH
    CONCATENATE 'ls' im_path INTO unixcommand  SEPARATED BY space.

*   Call unix command
    CALL 'SYSTEM' ID 'COMMAND' FIELD  unixcommand
                   ID 'TAB'    FIELD  files[].
*    DELETE files WHERE table_line NP im_pattern.
    DELETE files WHERE table_line NP c_pattern.

* Add files to the ZIP file
    DESCRIBE TABLE files LINES v_times.
    DO v_times TIMES.
* Read the data as a string
      CLEAR v_content .
      READ TABLE files  INTO wa_file INDEX sy-index.
      v_filename = wa_file.

      CONCATENATE im_path c_separator v_filename INTO v_file.

      OPEN DATASET v_file FOR INPUT IN BINARY MODE.
      IF sy-subrc = 0.
        READ DATASET v_file INTO v_content .
        CLOSE DATASET v_file.

        go_zip->add( name = v_filename content = v_content ).
      ELSE.
        MESSAGE i000(zrtr_r2) WITH 'Unable to open file "' v_filename '" Path:' im_path.
      ENDIF.
    ENDDO.

  ELSE.
*  If the file path and file name is provided, then ZIP only the given file.
    IF im_path IS NOT INITIAL AND im_filename IS NOT INITIAL.

      v_filename = im_filename.
      CONCATENATE im_path c_separator v_filename INTO v_file.

      OPEN DATASET v_file FOR INPUT IN BINARY MODE.
      IF sy-subrc = 0.
        READ DATASET v_file INTO v_content .
        CLOSE DATASET v_file.

        go_zip->add( name = v_filename content = v_content ).
      ELSE.
        MESSAGE i000(zrtr_r2) WITH 'Unable to open file "' v_filename '" Path:' im_path.
      ENDIF.
    ENDIF.
  ENDIF. " IF im_path IS NOT INITIAL AND IM_FILENAME IS INITIAL.

  v_zip_content   = go_zip->save( ).

* Conver the xstring content to binary
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer        = v_zip_content
    IMPORTING
      output_length = v_file_length
    TABLES
      binary_tab    = i_data.

* Create ZIP file
  CONCATENATE im_path c_separator im_zipfilename c_zip_ext INTO v_file.

  OPEN DATASET v_file FOR OUTPUT IN BINARY MODE.
  LOOP AT i_data INTO st_data.
    TRANSFER st_data TO v_file.
  ENDLOOP.
  CLOSE DATASET v_file.
  ex_return = sy-subrc.
  IF sy-batch = abap_false.
* give a success message in foreground run
    MESSAGE i000(zrtr_r2) WITH 'Files sucessfully zipped under: "' v_file.
  ENDIF.
ENDFUNCTION.
