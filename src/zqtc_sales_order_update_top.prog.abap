*&---------------------------------------------------------------------*
*&  Include           ZQTC_SALES_ORDER_UPDATE_TOP
*&---------------------------------------------------------------------*
TABLES :adr6.
TYPES : BEGIN OF ty_excel_file,
          leg_ref   TYPE vbkd-ihrez,  " Leg Ref Number
          filed2    TYPE char10,
          filed3    TYPE char20,
          field4    TYPE char10,
          field5    TYPE char10,
          field6    TYPE char10,
          field7    TYPE char20,
          field8    TYPE char10,
          field9    TYPE char10,
          leg_mq_no TYPE vbak-bname,  " Leg MQ Number
        END OF ty_excel_file,
        tt_excel_file TYPE STANDARD TABLE OF ty_excel_file,
        BEGIN OF ty_alv_disp_file,
          leg_ref        TYPE vbkd-ihrez,  " Leg Ref Number
          leg_mq_no      TYPE vbak-bname,  " Leg MQ Number
          sap_cont_no    TYPE vbak-vbeln,  " Sales Order Number
          sap_mq_no      TYPE vbak-bname,  " SAP MQ number
          status         TYPE char10,      " Status
          status_message TYPE char100,     " Status Message
        END OF ty_alv_disp_file,
        BEGIN OF ty_txt_file,
          field TYPE string,
        END OF ty_txt_file,
        BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          erdat TYPE vbak-erdat,
          bname TYPE vbak-bname,
        END OF ty_vbak,
        BEGIN OF ty_vbkd,
          vbeln TYPE vbkd-vbeln,
          posnr TYPE vbkd-posnr,
          ihrez TYPE vbkd-ihrez,
        END OF ty_vbkd,
        BEGIN OF ty_alv_disp_screen,
          leg_ref     TYPE vbkd-ihrez,  " Leg Ref Number
          leg_mq_no   TYPE vbak-bname,  " Leg MQ Number
          sap_cont_no TYPE vbak-vbeln,  " Sales Order Number
          sap_mq_no   TYPE vbak-bname,  " SAP MQ number
        END OF ty_alv_disp_screen,
        BEGIN OF ty_mail,
          sign TYPE  tvarv_sign,                      "ABAP: ID: I/E (include/exclude values)
          opti TYPE  tvarv_opti,                      "ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE salv_de_selopt_low,               "Lower Value of Selection Condition
          high TYPE salv_de_selopt_high,              "Upper Value of Selection Condition
        END OF ty_mail,
        tt_mail TYPE STANDARD TABLE OF ty_mail.
DATA :
*-    Internal Tables
  i_excel_file       TYPE STANDARD TABLE OF ty_excel_file,
  i_txt_file         TYPE STANDARD TABLE OF ty_txt_file,
  i_alv_disp_file    TYPE STANDARD TABLE OF ty_alv_disp_file,
  i_alv_disp_file_t  TYPE STANDARD TABLE OF ty_alv_disp_file,
  i_alv_disp_file_m  TYPE STANDARD TABLE OF ty_alv_disp_file,
  i_alv_disp_screen  TYPE STANDARD TABLE OF ty_alv_disp_screen,
  i_fcat_out         TYPE slis_t_fieldcat_alv,
  i_vbak             TYPE STANDARD TABLE OF ty_vbak,
  i_vbkd             TYPE STANDARD TABLE OF ty_vbkd,
  i_message          TYPE STANDARD TABLE OF solisti1,              "Itab to hold message for email
  i_attach           TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, "Itab to hold attachment for email
  i_attach_success   TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, "Itab to hold attachment for email
  i_attach_error     TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, "Itab to hold attachment for email
  i_packing_list     LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,    "Itab to hold packing list for email
  i_receivers        LIKE somlreci1 OCCURS 0 WITH HEADER LINE,     "Itab to hold mail receipents
  i_attachment       LIKE solisti1 OCCURS 0 WITH HEADER LINE,      "Itab to hold attachmnt for email
  i_mail             TYPE STANDARD TABLE OF ty_mail,
*-   Work Area
  st_excel_file      TYPE ty_excel_file,
  st_alv_disp_file   TYPE ty_alv_disp_file,
  st_alv_disp_screen TYPE ty_alv_disp_screen,
  st_fcat_out        TYPE slis_fieldcat_alv, " ALV specific tables and structures
  st_layout          TYPE slis_layout_alv,
  st_txt_file        TYPE ty_txt_file,
  st_vbak            TYPE ty_vbak,
  st_vbkd            TYPE ty_vbkd,
  st_imessage        TYPE solisti1,
*- Varibles
  gv_lines           TYPE i,
  g_path_fname       TYPE string,
  g_job_name         TYPE tbtcjob-jobname.  " Job Name
PARAMETERS :p_job TYPE tbtcjob-jobname NO-DISPLAY.


*====================================================================*
* G L O B A L   C O N S T A N T S
*====================================================================*

CONSTANTS: c_underscore TYPE char1      VALUE '_',    " Underscore of type CHAR1
           c_x          TYPE char1      VALUE 'X',      " X of type CHAR1
           c_m1         TYPE char3      VALUE 'M1',
           c_m2         TYPE char3      VALUE 'M2',
           c_m3         TYPE char3      VALUE 'M3',
           c_m4         TYPE char3      VALUE 'M4',
           c_m5         TYPE char3      VALUE 'M5',
           c_m6         TYPE char3      VALUE 'M6',
           c_m7         TYPE char3      VALUE 'M7',
           c_m8         TYPE char3      VALUE 'M8',
           c_m9         TYPE char3      VALUE 'M9',
           c_m10        TYPE char3      VALUE 'M10',
           c_m11        TYPE char3      VALUE 'M11',
           c_m12        TYPE char3      VALUE 'M12',
           c_u          TYPE char1      VALUE 'U',
           c_int        TYPE char3      VALUE 'INT',
           c_raw        TYPE char3      VALUE 'RAW',
           c_csv        TYPE char5      VALUE 'CSV',
           c_saprpt     TYPE char6      VALUE 'SAPRPT',
           c_0          TYPE vbap-posnr VALUE '000000',
           c_s          TYPE char1      VALUE 'S',
           c_e          TYPE char1      VALUE 'E',
           c_i          TYPE char1      VALUE 'I',
           c_extn       TYPE char4      VALUE '.txt', " Extn of type CHAR4
           con_tab      TYPE c          VALUE cl_abap_char_utilities=>horizontal_tab,
           con_cret     TYPE c          VALUE cl_abap_char_utilities=>cr_lf,
           c_separator  TYPE c          VALUE ','.
