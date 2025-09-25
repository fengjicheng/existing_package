*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BP_UPDATE_FROM_FILE_TOP
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ys_bp,
         kunnr TYPE kna1-kunnr,
       END OF ys_bp,
       BEGIN OF ty_exceldata,
         kunnr     TYPE kna1-kunnr,
         certdate  TYPE char10,
         cerreason TYPE char20,
         expirdate TYPE char10,
         taxid     TYPE char50,
         name1     TYPE char50,
         state     TYPE char20,
       END OF ty_exceldata,
       BEGIN OF ty_exceldata1,
         kunnr     TYPE char20,
         certdate  TYPE char10,
         cerreason TYPE char20,
         expirdate TYPE char10,
         taxid     TYPE char50,
         name1     TYPE char50,
         state     TYPE char20,
       END OF ty_exceldata1,
       BEGIN OF ty_updatestatus,
         kunnr     TYPE char20,
         certdate  TYPE char10,
         cerreason TYPE char20,
         expirdate TYPE char10,
         taxid     TYPE char50,
         name1     TYPE char50,
         state     TYPE char20,
         status    TYPE char20,
         details   TYPE char1024,
       END OF ty_updatestatus.

DATA:v_path_in  TYPE filepath-pathintern VALUE 'Z_E230_UPLOAD_IN',
     v_path_prc TYPE filepath-pathintern VALUE 'Z_E230_UPLOAD_PRC',
     v_path_err TYPE filepath-pathintern VALUE 'Z_E230_UPLOAD_ERR'.

DATA : lst_filename TYPE string,
       v_file_path  TYPE string,
       v_path_fname TYPE localfile,
       v_file       TYPE localfile,
       v_filename   TYPE localfile,
       v_deletefile TYPE localfile,
       v_file_mask  TYPE epsfilnam,
       v_dir        TYPE epsdirnam,
       v_sourcepath TYPE  sapb-sappfad,
       v_targetpath TYPE  sapb-sappfad,
       lv_data      TYPE string,
       lst_tab_data TYPE string,
       lst_bp       TYPE zsqtc_bp_input_i0368,
       i_return     TYPE ztqtc_bp_output_i0368,
       i_string     TYPE STANDARD TABLE OF string,
       i_bp         TYPE STANDARD TABLE OF zsqtc_bp_input_i0368,
       i_dir_list   TYPE STANDARD TABLE OF epsfili,
       i_exceldata  TYPE STANDARD TABLE OF alsmex_tabline,
       i_data       TYPE STANDARD TABLE OF ty_exceldata,
       i_taxdata    TYPE STANDARD TABLE OF ty_exceldata1,
       i_taxprocess TYPE STANDARD TABLE OF ty_exceldata,
       i_updateknvi TYPE STANDARD TABLE OF fknvi,
       i_updateknvi_temp TYPE STANDARD TABLE OF fknvi,
       i_updatestatus TYPE STANDARD TABLE OF ty_updatestatus,
       i_finaldisplay TYPE STANDARD TABLE OF ty_updatestatus,
       wa_updatestatus TYPE ty_updatestatus,
       wa_updateknvi TYPE knvi,
       wa_process   TYPE ty_exceldata,
       wa_data      TYPE ty_exceldata1.
DATA: lv_str_t  TYPE string,
      lv_length TYPE i,
      lv_ofst   TYPE i,
      lv_cnt    TYPE i.
DATA: send_request   type ref to cl_bcs,
      document       type ref to cl_document_bcs,
      recipient      type ref to if_recipient_bcs,
      bcs_exception  type ref to cx_bcs,
      main_text      type bcsy_text,
      binary_content type solix_tab,
      size           type so_obj_len,
      sent_to_all    type os_boolean,
      gv_string      type string.

DATA: v_send_request   TYPE REF TO cl_bcs VALUE IS INITIAL,
      v_document       TYPE REF TO cl_document_bcs VALUE IS INITIAL,  "document object
      v_sender         TYPE REF TO if_sender_bcs VALUE IS INITIAL,    "sender
      v_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL, "recipient
      v_attsubject     TYPE sood-objdes,
      i_binary_content TYPE solix_tab,
      cx_bcs_exception TYPE REF TO cx_bcs,
      v_msg_text       TYPE string.
DATA: gv_jobname TYPE btcjob,
      gv_user    TYPE sy-uname,
      gv_number  TYPE tbtcjob-jobcount,       "Job number
      gi_params  TYPE TABLE OF rsparamsl_255, "Selection table parameter
      gst_params TYPE rsparamsl_255,          "Selection table parameter
      gv_batchuser TYPE char20.
DATA: gv_filepath TYPE localfile,
      gv_filename TYPE localfile,
      gv_alv  TYPE REF TO cl_salv_table,
      gv_func TYPE REF TO cl_salv_functions.
FIELD-SYMBOLS: <fs> TYPE  zsqtc_bp_input_i0368.
DATA:ls_file_name      TYPE epsf-epsfilnam,
     ls_dir_name       TYPE epsf-epsdirnam,
     ls_file_path      TYPE epsf-epspath,
     ev_long_file_path TYPE eps2path,
     lv_flag           TYPE char1.


CONSTANTS:c_delimiter TYPE char1    VALUE ',',
          c_ten       TYPE i        VALUE '10',
          c_x         TYPE char1    VALUE 'X',
          c_score     TYPE char1    VALUE '_',
          c_e         TYPE char1    VALUE 'E',
          c_i         TYPE char1    VALUE 'I',
          c_s         TYPE char1    VALUE 'S',
          c_p         TYPE char1    VALUE 'P',
          c_eq        TYPE char2    VALUE 'EQ',
          c_devid     TYPE zdevid   VALUE 'E230',
          c_email     TYPE char5    VALUE 'EMAIL',
          c_user      TYPE char4    VALUE 'USER',
          c_file      TYPE char4    VALUE 'FILE',
          c_pfile     TYPE char6    VALUE 'P_FILE',
          c_sfile     TYPE char7    VALUE 'S_EMAIL',
          c_tab       TYPE c        VALUE cl_bcs_convert=>gc_tab,
          c_crlf      TYPE c        VALUE cl_bcs_convert=>gc_crlf,
          c_pipe      TYPE char1    VALUE '|',        " Tab of type Character
          c_comma     TYPE char1    VALUE ',',
          c_col_1     TYPE num4     VALUE 0001,     " Four-digit number
          c_col_2     TYPE num4     VALUE 0002,     " Four-digit number
          c_col_3     TYPE num4     VALUE 0003,     " Four-digit number
          c_col_4     TYPE num4     VALUE 0004,     " Four-digit number
          c_col_5     TYPE num4     VALUE 0005,     " Four-digit number
          c_col_6     TYPE num4     VALUE 0006,     " Four-digit number
          c_col_7     TYPE num4     VALUE 0007.     " Four-digit number
