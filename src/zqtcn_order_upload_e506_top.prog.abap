*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ORDER_UPLOAD_E506_TOP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_ORDER_UPLOAD_E506_TOP (INCLUDE)
* PROGRAM DESCRIPTION: To upload Mass Sales orders & Credit/Debit Memos
* REFERENCE NO: EAM-1155
* DEVELOPER: Vishnuvardhan Reddy(VCHITTIBAL)
* CREATION DATE:   19/April/2022
* OBJECT ID:    E506
* TRANSPORT NUMBER(S):ED2K926870
*----------------------------------------------------------------------*
*====================================================================*
* T A B L E S
*====================================================================*
TABLES: sscrfields. "Screenfields

*====================================================================*
* S T R U C T U R E
*====================================================================*
TYPES:BEGIN OF ty_zcaconstant,
        devid  TYPE zdevid,                                       "Development ID
        param1 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
        param2 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
        srno   TYPE tvarv_numb,                                   "ABAP: Current selection number
        sign   TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
        opti   TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
        low    TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
        high   TYPE salv_de_selopt_high,                          "Upper Value of Selection Condition
      END OF ty_zcaconstant.

* Ranges for Row Texts
TYPES: BEGIN OF ty_row_txt,
         sign TYPE tvarv_sign,         " ABAP: ID: I/E (include/exclude values)
         opti TYPE tvarv_opti,         " ABAP: Selection option (EQ/BT/CP/...)
         low  TYPE salv_de_selopt_low, " Text
         high TYPE salv_de_selopt_high, " Text
       END OF ty_row_txt.

* Customer
TYPES: BEGIN OF ty_customer,
         kunnr TYPE kunnr,
       END OF ty_customer.

TYPES: tt_customer TYPE STANDARD TABLE OF ty_customer.

*Vendor
TYPES: BEGIN OF ty_vendor,
         lifnr TYPE lifnr,
       END OF ty_vendor.
TYPES: tt_vendor TYPE STANDARD TABLE OF ty_vendor.

* Get Sales Organization (TVKO)
TYPES: BEGIN OF ty_vkorg,
         vkorg TYPE vkorg,
       END OF  ty_vkorg.

* Get Distribution Channel (TVTW)
TYPES: BEGIN OF ty_vtweg,
         vtweg TYPE vtweg,
       END OF  ty_vtweg.

* Get Division (TSPA)
TYPES: BEGIN OF ty_spart,
         spart TYPE spart,
       END OF  ty_spart.

* Get Sales Document Type (TVAK)
TYPES: BEGIN OF ty_auart,
         auart TYPE auart,
       END OF  ty_auart.

* Get PO Type (T176)
TYPES: BEGIN OF ty_bsark,
         bsark TYPE bsark,
       END OF  ty_bsark.

* Get Material (MARA)
TYPES: BEGIN OF ty_matnr,
         matnr TYPE matnr,
       END OF  ty_matnr.
TYPES: tt_matnr TYPE STANDARD TABLE OF ty_matnr.

* Get Material for Sales Area
TYPES: BEGIN OF ty_mvke,
         matnr TYPE matnr,
         vkorg TYPE vkorg,
         vtweg TYPE vtweg,
         dwerk TYPE dwerk,
       END OF ty_mvke.

TYPES: tt_mvke        TYPE STANDARD TABLE OF ty_mvke,
       tt_regular_ord TYPE STANDARD TABLE OF zstqtc_reg_ord,
       tt_crdrme_crt  TYPE STANDARD TABLE OF zstqtc_cr_dr_memo.

*====================================================================*
*  I N T E R N A L  T A B L E
*====================================================================*
DATA: i_const          TYPE TABLE OF ty_zcaconstant,                     " Constant Table
      i_regular_ord    TYPE TABLE OF zstqtc_reg_ord,                     " Order Input Table
      i_reg_ord_out    TYPE TABLE OF zstqtc_reg_ord_out,                 " Order Output Table
      i_crdrme_crt     TYPE TABLE OF zstqtc_cr_dr_memo,                  " Credit/Debit Memo Input Table
      i_crdrme_out     TYPE TABLE OF zstqtc_cr_dr_memo_out,              " Credit/Debit Memo oUTPUT
      i_attach_success TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, " Itab to hold attachment for email
      i_attach_error   TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, " Itab to hold attachment for email
      i_attach_total   TYPE STANDARD TABLE OF solisti1 WITH HEADER LINE, " Itab to hold attachment for email
      ir_row_txt       TYPE STANDARD TABLE OF ty_row_txt,                " Range table for text
      st_loghandle     TYPE bal_t_logh,                                  " Application Log Handle
      i_lognum         TYPE bal_t_lgnm,                                  " Application Log Number
      i_e506_stage     TYPE STANDARD TABLE OF zqtc_stagng_e506,          " Staging Table
      i_customer       TYPE STANDARD TABLE OF ty_customer,               " Customer
      i_vendor         TYPE STANDARD TABLE OF ty_vendor,                 " Vendor
      i_vkorg          TYPE STANDARD TABLE OF ty_vkorg,                  " Sales Organization
      i_vtweg          TYPE STANDARD TABLE OF ty_vtweg,                  " Distribution Channel
      i_spart          TYPE STANDARD TABLE OF ty_spart,                  " Division
      i_auart          TYPE STANDARD TABLE OF ty_auart,                  " Sales Document Type
      i_bsark          TYPE STANDARD TABLE OF ty_bsark,                  " Po Type
      i_matnr          TYPE STANDARD TABLE OF ty_matnr,                  " Material
      i_mvke           TYPE STANDARD TABLE OF ty_mvke,                   " Material Sales Details
      i_return         TYPE STANDARD TABLE OF bapiret2,                  " Bapi Return Messages
      i_message        TYPE STANDARD TABLE OF solisti1,                  " Itab to hold message for emai
      i_packing_list   LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,        " Itab to hold packing list for email
      i_receivers      LIKE somlreci1 OCCURS 0 WITH HEADER LINE,         " Itab to hold mail receipents
      i_attachment     LIKE solisti1 OCCURS 0 WITH HEADER LINE,          " Itab to hold attachmnt for email
      st_imessage      TYPE solisti1.                                    " Messages

*====================================================================*
* S T R U C T U R E S
*====================================================================*
DATA: st_msg        TYPE bal_s_msg,                                   " Messages
      st_log        TYPE bal_s_log,                                   " Application Log
      st_log_handle TYPE balloghndl,                                  " Application Log Handle
      st_lognum     TYPE bal_s_lgnm,                                  " Application Log Number
      st_e506_stage TYPE zqtc_stagng_e506.                            " Staging Table

*====================================================================*
* V A R I A B L E S
*====================================================================*
DATA: v_line_lmt      TYPE sytabix,           " For input file count,
      v_lines         TYPE sytabix,           " Internal table count
      v_oid           TYPE numc10,            " File Identification Number
      v_error_file    TYPE char1,             " Check Error File
      v_path_fname    TYPE localfile,         " Local file for upload/download
      v_job_name      TYPE tbtcjob-jobname,   " Background job name
      v_e506          TYPE salv_de_selopt_low, "Application Server Logical Path
      v_email         TYPE ad_smtpadr,        " Mail Address
      v_a_output_path TYPE localfile,         " Application Server Path
      v_auart         TYPE auart.             " Sales Document Type

*====================================================================*
* C O N S T A N T S
*====================================================================*
CONSTANTS :c_e506       TYPE zdevid   VALUE 'E506',            "Development ID
           c_zq         TYPE inri-nrrangenr VALUE 'ZQ',        "Number Range No
           c_zqtc_uplid TYPE inri-object    VALUE 'ZQTC_UPLID', "Number Range object
           c_quantity   TYPE inri-quantity  VALUE '1',         "Quantity
           c_i          TYPE char1    VALUE 'I',       "Information
           c_e          TYPE char1    VALUE 'E',        "Error
           c_s          TYPE char1    VALUE 'S',        "Success
           c_w          TYPE char1    VALUE 'W',        "Warning
           c_f1         TYPE char2    VALUE 'F1',       "Processing Status "File Validation Error
           c_ag         TYPE parvw    VALUE 'AG',       "Sold to party
           c_we         TYPE parvw    VALUE 'WE',       "Ship to party
           c_re         TYPE parvw    VALUE 'RE',       "Bill to party
           c_rg         TYPE parvw    VALUE 'RG',       "Payer
           c_cr         TYPE parvw    VALUE 'CR',       "Forwarding Agent
           c_ve         TYPE parvw    VALUE 'VE',       "Sales Rep
           c_format     TYPE tdformat VALUE '*',        " Tag column
           con_tab      TYPE c        VALUE cl_abap_char_utilities=>horizontal_tab,
           con_cret     TYPE c        VALUE cl_abap_char_utilities=>cr_lf,
           c_saprpt     TYPE char6    VALUE 'SAPRPT',
           c_xls        TYPE so_obj_tp VALUE  'XLS',    "Excel
           c_raw        TYPE char3      VALUE 'RAW',    "Mail Attachment type
           c_underscore TYPE char1      VALUE '_',      "Underscore of type CHAR1
           c_int        TYPE char3      VALUE 'INT',    "Int
           c_u          TYPE char1      VALUE 'U',       "U of Type CHAR1
           c_rb_so_ct   TYPE rvari_vnam   VALUE 'RB_SO_CT', "Regular Order Radio Button
           c_rb_cd_ct   TYPE rvari_vnam   VALUE 'RB_CD_CT', "Credit/Debit Memo Radio Button
           c_1          TYPE i VALUE 1,
           c_2          TYPE i VALUE 2,
           c_3          TYPE i VALUE 3,
           c_4          TYPE i VALUE 4,
           c_5          TYPE i VALUE 5,
           c_6          TYPE i VALUE 6,
           c_7          TYPE i VALUE 7,
           c_8          TYPE i VALUE 8,
           c_9          TYPE i VALUE 9,
           c_10         TYPE i VALUE 10,
           c_11         TYPE i VALUE 11,
           c_12         TYPE i VALUE 12,
           c_13         TYPE i VALUE 13,
           c_14         TYPE i VALUE 14,
           c_15         TYPE i VALUE 15,
           c_16         TYPE i VALUE 16,
           c_17         TYPE i VALUE 17,
           c_18         TYPE i VALUE 18,
           c_19         TYPE i VALUE 19,
           c_20         TYPE i VALUE 20,
           c_21         TYPE i VALUE 21,
           c_22         TYPE i VALUE 22,
           c_23         TYPE i VALUE 23,
           c_24         TYPE i VALUE 24,
           c_25         TYPE i VALUE 25,
           c_255        TYPE i VALUE 255.
