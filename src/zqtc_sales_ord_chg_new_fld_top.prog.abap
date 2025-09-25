*&---------------------------------------------------------------------*
*&  Include  ZQTC_SALES_ORD_CHG_NEW_FLD_TOP
*&---------------------------------------------------------------------*
TYPES : BEGIN OF ty_excel_file,
          ind(1)    TYPE c,           " Indicator for Header or Item data
          so        TYPE vbak-vbeln,  " Sales Order Number
          item      TYPE vbap-posnr,  " Sales Item
          lyear     TYPE vbak-zzlicyr, " License Year
          dtype     TYPE vbap-zzdealtyp, "PQ Deal type
          ctype     TYPE vbap-zzclustyp, "Cluster type
          leg_mq_no TYPE vbak-bname,  " Leg MQ Number
        END OF ty_excel_file,
        tt_excel_file TYPE STANDARD TABLE OF ty_excel_file,
        BEGIN OF ty_alv_disp,
          ind(1)         TYPE c,           " Indicator for Header or Item data
          so             TYPE vbak-vbeln,  " Sales Order Number
          item           TYPE vbap-posnr,  " Sales Item
          lyear          TYPE vbak-zzlicyr, " License Year
          dtype          TYPE vbap-zzdealtyp, "PQ Deal type
          ctype          TYPE vbap-zzclustyp, "Cluster type
          status         TYPE char10,      " Status
          status_message TYPE char100,     " Status Message
        END OF ty_alv_disp,
        BEGIN OF ty_txt_file,
          field TYPE string,
        END OF ty_txt_file,
        BEGIN OF ty_vbap,
          vbeln TYPE vbap-vbeln,
          posnr TYPE vbap-posnr,
          matnr TYPE vbap-matnr,
        END OF ty_vbap,
        BEGIN OF ty_mail,
          sign TYPE  tvarv_sign,                      "ABAP: ID: I/E (include/exclude values)
          opti TYPE  tvarv_opti,                      "ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE salv_de_selopt_low,               "Lower Value of Selection Condition
          high TYPE salv_de_selopt_high,              "Upper Value of Selection Condition
        END OF ty_mail,
        tt_mail TYPE STANDARD TABLE OF ty_mail.

DATA :
*-    Internal Tables
  i_excel_file   TYPE STANDARD TABLE OF ty_excel_file,
  i_excel_file_t TYPE STANDARD TABLE OF ty_excel_file,
  i_txt_file     TYPE STANDARD TABLE OF ty_txt_file,
  i_alv_disp     TYPE STANDARD TABLE OF ty_alv_disp,
  i_fcat_out     TYPE slis_t_fieldcat_alv,
  i_vbap         TYPE STANDARD TABLE OF ty_vbap,
  i_mail         TYPE STANDARD TABLE OF ty_mail,
  i_message      TYPE STANDARD TABLE OF solisti1,              "Itab to hold message for email
  i_attach       TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, "Itab to hold attachment for email
  i_packing_list LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,    "Itab to hold packing list for email
  i_receivers    LIKE somlreci1 OCCURS 0 WITH HEADER LINE,     "Itab to hold mail receipents
  i_attachment   LIKE solisti1 OCCURS 0 WITH HEADER LINE,      "Itab to hold attachmnt for email
*-   Work Area
  st_excel_file  TYPE ty_excel_file,
  st_alv_disp    TYPE ty_alv_disp,
  st_fcat_out    TYPE slis_fieldcat_alv, " ALV specific tables and structures
  st_layout      TYPE slis_layout_alv,
  st_txt_file    TYPE ty_txt_file,
  st_bapi_header TYPE bapisdhd1,   "structure to hold header
  st_vbap        TYPE ty_vbap,
  st_imessage    TYPE solisti1,
*- Varibles
  gv_lines       TYPE i,
  g_path_fname   TYPE string,
  v_path_fname   TYPE string,    "File path
  lv_filename    TYPE string,
  g_user         TYPE syst_uname,
  g_job          TYPE tbtcjob-jobname.

*====================================================================*
* G L O B A L   C O N S T A N T S
*====================================================================*

CONSTANTS: c_underscore      TYPE char1      VALUE '_',    " Underscore of type CHAR1
           c_x               TYPE char1      VALUE 'X',      " X of type CHAR1
           c_u               TYPE char1      VALUE 'U',
           c_h               TYPE char1      VALUE 'H',
           c_i               TYPE char1      VALUE 'I',
           c_s               TYPE char1      VALUE 'S',
           c_int             TYPE char3      VALUE 'INT',
           c_raw             TYPE char3      VALUE 'RAW',
           c_csv             TYPE char5      VALUE 'CSV',
           c_saprpt          TYPE char6      VALUE 'SAPRPT',
           c_0               TYPE vbap-posnr VALUE '000000',
           c_e               TYPE char1      VALUE 'E',
           c_a               TYPE char1      VALUE 'A',
           c_file(8)         TYPE c          VALUE 'P_A_FILE',
           c_inf(12)         TYPE c          VALUE  '/intf/zapp/',
           c_c102(8)         TYPE c          VALUE '/C102/in/',
           c_ord_upd_new(12) TYPE c          VALUE 'ZORD_UPD_NEW',
           c_bus2034         TYPE bapiusw01-objtype VALUE 'BUS2034',
           c_extn            TYPE char4      VALUE '.txt', " Extn of type CHAR4
           con_tab           TYPE c          VALUE cl_abap_char_utilities=>horizontal_tab,
           con_cret          TYPE c          VALUE cl_abap_char_utilities=>cr_lf.
