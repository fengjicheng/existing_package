*&---------------------------------------------------------------------*
*&  Include           ZQTCR_KIARA_INTEGRATE_EMAILTOP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_KIARA_INTEGRATE_EMAIL                            *
* PROGRAM DESCRIPTION: This program will trigger an Email when update  *
*                      from KIARA to Acceptance Date in Sales          *
*                      document fails                                  *
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 06/05/2021                                          *
* OBJECT ID      :                                                     *
* TRANSPORT NUMBER(S): ED2K923295                                      *
*----------------------------------------------------------------------*

TABLES: balhdr,balm,vbap.

TYPES: BEGIN OF ty_final,
         lognumber TYPE balm-lognumber,
         msgid     TYPE balm-msgid,
         msgv4     TYPE balm-msgv4,
         msgv1     TYPE balm-msgv1,
         msgv2     TYPE balm-msgv2,
         msgv3     TYPE balm-msgv3,
         vbeln     TYPE vbap-vbeln,
         posnr     TYPE vbap-posnr,
       END OF ty_final.

CONSTANTS: gc_bt      TYPE c LENGTH 2 VALUE 'BT',
           gc_i       TYPE c LENGTH 1 VALUE 'I',
           gc_e       TYPE c LENGTH 1 VALUE 'E',
           gc_u       TYPE c LENGTH 1 VALUE 'U',
           gc_0       TYPE i          VALUE '0',
           gc_6       TYPE i          VALUE '6',
           gc_10      TYPE i          VALUE '10',
           gc_13      TYPE i          VALUE '13',
           gc_raw     TYPE so_obj_tp  VALUE 'RAW',
           gc_xls     TYPE so_obj_tp  VALUE 'XLS',
           gc_msgno   TYPE c LENGTH 5 VALUE 'MSGNO',
           gc_001     TYPE c LENGTH 3 VALUE '001',
           gc_002     TYPE c LENGTH 3 VALUE '002',
           gc_email   TYPE c LENGTH 5 VALUE 'EMAIL',
           gc_object  TYPE balobj_d    VALUE 'ZQTC',      " Application Log: Object Name (Application Code)
           gc_subobj  TYPE balsubobj   VALUE 'ZUPD_ACCEPTANCE'," Application Log: Sub Object
*Start of changes MRAJKUMAR
*           gc_devid   TYPE zdevid      VALUE 'I0369',
           gc_devid   TYPE zdevid      VALUE 'I0396',
*End of changes MRAJKUMAR
           gc_qtcr2   TYPE balm-msgid  VALUE 'ZQTC_R2',
           gc_number3 TYPE balm-msgnumber VALUE '000006',
           gc_hortab  TYPE c         VALUE cl_abap_char_utilities=>horizontal_tab,
           gc_crlf    TYPE c         VALUE cl_abap_char_utilities=>cr_lf.

DATA: gv_lognumber     TYPE balognr,
      gv_external_num  TYPE balnrext,
      gv_numberof_logs TYPE syst_tabix,
      gv_fromdate      TYPE balhdr-aldate,
      gv_todate        TYPE balhdr-aldate,
      gv_number1       TYPE balm-msgno,
      gv_number2       TYPE balm-msgno,
      gv_docdata       TYPE sodocchgi1,
      gv_message       TYPE solisti1,
      gv_packlist      TYPE sopcklsti1,
      gv_lines         TYPE sy-tabix,
      gv_file_name     TYPE char100,
      gv_vbeln         TYPE vbap-vbeln,
      gv_posnr         TYPE vbap-posnr,
      gv_messagev1v2   TYPE char100.

DATA: i_header_data    TYPE STANDARD TABLE OF BALHDR INITIAL SIZE 0,
      i_messages       TYPE STANDARD TABLE OF BALM INITIAL SIZE 0,
      i_final          TYPE STANDARD TABLE OF ty_final,
      i_packing_list   TYPE sopcklsti1 OCCURS 0 WITH HEADER LINE,
      i_receivers      TYPE somlreci1 OCCURS 0 WITH HEADER LINE,
      i_attachment     TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE,
      i_message        TYPE STANDARD TABLE OF solisti1,
      st_final         TYPE ty_final.
