*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PARTNERS_UPDATE_TOP
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_upload_file,
         order     TYPE vbeln,          " Sales and Distribution Document Number
         part_func TYPE parvw,          " Partner Function
         cust_no   TYPE kunnr,          " Customer Number
       END OF ty_upload_file,

       tt_upload_file TYPE STANDARD TABLE OF ty_upload_file
                 INITIAL SIZE 0,

       BEGIN OF ty_alv_display,
         status  TYPE char6,            " Status of type CHAR4
         order   TYPE vbeln,            " Sales and Distribution Document Number
         cust_no TYPE kunnr,            " Customer Number
         message TYPE bapi_msg,         " Message Text
       END OF ty_alv_display,

       tt_alv_display TYPE STANDARD TABLE OF ty_alv_display
                      INITIAL SIZE 0,

       BEGIN OF ty_mail,
         sign TYPE  tvarv_sign,         "ABAP: ID: I/E (include/exclude values)
         opti TYPE  tvarv_opti,         "ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE salv_de_selopt_low,  "Lower Value of Selection Condition
         high TYPE salv_de_selopt_high, "Upper Value of Selection Condition
       END OF ty_mail,
       tt_mail TYPE STANDARD TABLE OF ty_mail.

DATA: i_upload_file      TYPE tt_upload_file,
      i_excel_file       TYPE tt_upload_file,
      v_path_fname       TYPE localfile,       " Local file for upload/download
      v_email            TYPE adr6-smtp_addr,  " E-Mail Address
      v_job_name         TYPE tbtcjob-jobname, " Background job name
      i_alv_display      TYPE tt_alv_display,
      i_alv_display_mail TYPE tt_alv_display,
      i_mail             TYPE tt_mail,
      i_fcat_out         TYPE slis_t_fieldcat_alv,
      i_message          TYPE STANDARD TABLE OF solisti1,
      i_attach           TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE. "Itab to hold attachment for email

CONSTANTS:c_field      TYPE dynfnam VALUE 'P_P_FILE'. " Field name
