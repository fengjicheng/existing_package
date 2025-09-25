*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CHG_ORDER_ITEM_TEXT_TOP
*&---------------------------------------------------------------------*
*- Excal Upload
TYPES : BEGIN OF ty_excel_file,
          vbeln TYPE vbak-vbeln,              "Sales Document Number
          posnr TYPE vbap-posnr,              "Sales Document Item
          eal   TYPE char100,                 "EAL Number
        END OF ty_excel_file,
        tt_excel_file TYPE STANDARD TABLE OF ty_excel_file,
*- Sales Document Item data
        BEGIN OF ty_vbap,
          vbeln TYPE vbak-vbeln,              "Sales Document Numnber
          posnr TYPE vbap-posnr,              "Sales Document Item
        END OF ty_vbap,
*- Report Output
        BEGIN OF ty_alv_disp_screen,
          vbeln          TYPE vbak-vbeln,     "Sales Document Number
          posnr          TYPE vbap-posnr,     "Sales Document Item
          old_eal        TYPE char100,        "OLD EAL
          new_eal        TYPE char100,        "NEW EAL
          status         TYPE char10,         "Status
          status_message TYPE char100,        "Status Message
        END OF ty_alv_disp_screen,
        BEGIN OF ty_mail,
          sign TYPE  tvarv_sign,                      "ABAP: ID: I/E (include/exclude values)
          opti TYPE  tvarv_opti,                      "ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE salv_de_selopt_low,               "Lower Value of Selection Condition
          high TYPE salv_de_selopt_high,              "Upper Value of Selection Condition
        END OF ty_mail,
        tt_mail TYPE STANDARD TABLE OF ty_mail.

DATA:li_vbap            TYPE TABLE OF ty_vbap,        "Sales Document Item Data
     li_tline           TYPE STANDARD TABLE OF tline, "SAPscript: Text Lines
     li_alv_disp_screen TYPE STANDARD TABLE OF ty_alv_disp_screen,
     li_excel_file      TYPE STANDARD TABLE OF ty_excel_file,
     li_excel_file_tmp  TYPE STANDARD TABLE OF ty_excel_file,
     li_mail            TYPE STANDARD TABLE OF ty_mail,
     li_fcat_out        TYPE slis_t_fieldcat_alv,
     i_message          TYPE STANDARD TABLE OF solisti1,              "Itab to hold message for email
     i_attach           TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, "Itab to hold attachment for email
     i_attach_success   TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, "Itab to hold attachment for email
     i_attach_error     TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, "Itab to hold attachment for email
     i_packing_list     LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,    "Itab to hold packing list for email
     i_receivers        LIKE somlreci1 OCCURS 0 WITH HEADER LINE,     "Itab to hold mail receipents
     i_attachment       LIKE solisti1 OCCURS 0 WITH HEADER LINE,      "Itab to hold attachmnt for email
     st_header          TYPE thead,                   "SAPscript: Text Header
     st_tline           TYPE tline,                   "SAPscript: Text Lines
     st_alv_disp_screen TYPE ty_alv_disp_screen,
     st_excel_file      TYPE ty_excel_file,
     st_fcat_out        TYPE slis_fieldcat_alv, " ALV specific tables and structures
     st_layout          TYPE slis_layout_alv,
     st_imessage        TYPE solisti1,
     g_lines(20)        TYPE i,
     g_path_fname       TYPE string,
     g_path_fname_n     TYPE string,    "File path
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
           c_extn       TYPE char4      VALUE '.txt', " Extn of type CHAR4
           con_tab      TYPE c          VALUE cl_abap_char_utilities=>horizontal_tab,
           con_cret     TYPE c          VALUE cl_abap_char_utilities=>cr_lf,
           c_separator  TYPE c          VALUE ',',
           c_u          TYPE char1      VALUE 'U',
           c_int        TYPE char3      VALUE 'INT',
           c_raw        TYPE char3      VALUE 'RAW',
           c_csv        TYPE char5      VALUE 'CSV',
           c_saprpt     TYPE char6      VALUE 'SAPRPT',
           c_s          TYPE char1      VALUE 'S',
           c_e          TYPE char1      VALUE 'E',
           c_i          TYPE char1      VALUE 'I'.
