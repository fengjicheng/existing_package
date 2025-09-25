*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCC_CREATE_QUOTATION_C064
* PROGRAM DESCRIPTION: Get the data from input pipe dilimited file,
* Create quotation for the subs order present in input feed file and
* update table ZQTC_RENWL_PLAN.
* All the global varible has been declared here.
* DEVELOPER: Lucky Kodwani(LKODWANI)
* CREATION DATE:   2017-07-03
* DER NUMBER: C064/CR_344
* TRANSPORT NUMBER(S): ED2K907090
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CREATE_QUOTATN_C064_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  S T R U C T U R E S                                                *
*&---------------------------------------------------------------------*
TYPES : BEGIN OF ty_upload_file,
          vbeln       TYPE vbeln,       " Sales and Distribution Document Number
          posnr       TYPE posnr,       " Item number of the SD document
          forwd       TYPE kunnr,       " Customer Number
          forwd_fun   TYPE parvw,       " Partner Function
          sold_to     TYPE kunnr,       " Customer Number
          sold_to_fun TYPE parvw,       " Partner Function
          ship_to     TYPE kunnr,       " Customer Number
          ship_to_fun TYPE parvw,       " Partner Function
          waerk       TYPE waerk,       " SD Document Currency
        END OF ty_upload_file,

*        BEGIN OF ty_upload_char,
*          vbeln       TYPE char10,      " Sales and Distribution Document Number
*          forwd       TYPE char10,      " Customer Number
*          forwd_fun   TYPE char2,       " Partner Function
*          sold_to     TYPE char10,      " Customer Number
*          sold_to_fun TYPE char2,       " Partner Function
*          ship_to     TYPE char10,      " Customer Number
*          ship_to_fun TYPE char2,       " Partner Function
*          waerk       TYPE char3,       " SD Document Currency
*        END OF ty_upload_char,

        BEGIN OF ty_final,
          sel,
          vbeln       TYPE vbeln,       " Sales and Distribution Document Number
          posnr       TYPE posnr,       " Item number of the SD document
          forwd       TYPE kunnr,       " Customer Number
          forwd_fun   TYPE parvw,       " Partner Function
          sold_to     TYPE kunnr,       " Customer Number
          sold_to_fun TYPE parvw,       " Partner Function
          ship_to     TYPE kunnr,       " Customer Number
          ship_to_fun TYPE parvw,       " Partner Function
          waerk       TYPE waerk,       " SD Document Currency
          act_status  TYPE zact_status, " Activity Status
          message     TYPE char120,     " Message of type CHAR120
        END OF ty_final,

*&---------------------------------------------------------------------*
*& T A B L E  T Y P E S
*&---------------------------------------------------------------------*
*        tt_sales       TYPE STANDARD TABLE OF sales_key  INITIAL SIZE 0,       " Structure for Mass Accesses to SD Documents
        tt_item        TYPE STANDARD TABLE OF bapisdit   INITIAL SIZE 0,       " Structure of VBAP with English Field Names
        tt_partner     TYPE STANDARD TABLE OF bapisdpart INITIAL SIZE 0,       " BAPI Structure of VBPA with English Field Names
        tt_partner_f   TYPE STANDARD TABLE OF bapiparnr INITIAL SIZE 0,        " BAPI Structure of VBPA with English Field Names
        tt_header      TYPE STANDARD TABLE OF bapisdhd   INITIAL SIZE 0,       " BAPI Structure of VBAK with English Field Names
        tt_business    TYPE STANDARD TABLE OF bapisdbusi INITIAL SIZE 0,       " BAPI Structure of VBKD
        tt_textheaders TYPE STANDARD TABLE OF bapisdtehd INITIAL SIZE 0,       " BAPI Structure of THEAD with English Field Names
        tt_textlines   TYPE STANDARD TABLE OF bapitextli INITIAL SIZE 0,       " BAPI Structure for STX_LINES Structure
        tt_contract    TYPE STANDARD TABLE OF bapisdcntr INITIAL SIZE 0,       " BAPI Structure of VEDA with English Field Names
        tt_return      TYPE STANDARD TABLE OF bapiret2   INITIAL SIZE 0,       " Return Parameter
*        tt_docflow     TYPE STANDARD TABLE OF bapisdflow INITIAL SIZE 0,       " BAPI Structure of VBFA with English Field Names
        tt_renwl_plan  TYPE STANDARD TABLE OF zqtc_renwl_plan  INITIAL SIZE 0, " E095: Renewal Plan Table
        tt_final       TYPE STANDARD TABLE OF ty_final         INITIAL SIZE 0,
*        tt_upload_char TYPE STANDARD TABLE OF ty_upload_char   INITIAL SIZE 0,
        tt_upload_file TYPE STANDARD TABLE OF ty_upload_file   INITIAL SIZE 0.

*&---------------------------------------------------------------------*
*& I N T E R N A L  T A B L E
*&---------------------------------------------------------------------*
DATA:   i_upload_file TYPE tt_upload_file,
        i_renwl_tmp   TYPE tt_renwl_plan,
        i_final       TYPE tt_final,
        i_fcat        TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0.

*&---------------------------------------------------------------------*
*& G L O B A L  V A R I A B L E
*&---------------------------------------------------------------------*
DATA :  v_active TYPE zqtc_activity-activity. " E095: Activity

*&---------------------------------------------------------------------*
*&  C O N S T A N T S
*&---------------------------------------------------------------------*

CONSTANTS:      c_field    TYPE dynfnam VALUE 'P_FILE',                                 " Field name: for Local file
                c_rucomm   TYPE syucomm VALUE 'RUCOMM',                                 " Function Code
                c_onli     TYPE syucomm VALUE 'ONLI',                                   " Function Code
*                c_e        TYPE symsgty VALUE 'E',                                      " Message Type
*                c_a        TYPE symsgty VALUE 'A',                                      " Message Type
                c_con_tab  TYPE char1   VALUE '|'.                                 " Con_tab of type Character
*                c_con_tab2 TYPE char1   VALUE cl_abap_char_utilities=>vertical_tab, " Con_tab of type Character
*                c_s        TYPE bapi_mtype VALUE 'S',                                   " Message type: S Success, E Error, W Warning, I Info, A Abort
*                c_i        TYPE bapi_mtype VALUE 'I'.                                   " Message type: S Success, E Error, W Warning, I Info, A Abort
