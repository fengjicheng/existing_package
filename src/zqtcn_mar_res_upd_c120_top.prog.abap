*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MAR_RES_UPD_C120_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_MARKET_REST_UPD_C120
*&*--------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_MARKET_REST_UPD_C120
*& PROGRAM DESCRIPTION:   Market Restriction Conversion Global Declarations
*& DEVELOPER:             SVISHWANAT
*& CREATION DATE:         03/28/2022
*& OBJECT ID:             C120 / EAM-8340
*& TRANSPORT NUMBER(S):   ED2K926336.
*&--------------------------------------------------------------------*
TYPES:BEGIN OF ity_file,
        kschl    TYPE kschl,
        matnr    TYPE matnr,        " Material
        land1    TYPE lland,        " Country
        fromdate TYPE char8,        " kodatab,
        todate   TYPE char8,        " kodatbi,
        type     TYPE bapi_mtype,   " Msg Type
        message  TYPE bapi_msg,     " Message Description
      END OF ity_file,
      BEGIN OF ity_data,
        kschl    TYPE kschl,
        matnr    TYPE matnr,
        land1    TYPE lland,
        fromdate TYPE kodatab,
        todate   TYPE kodatbi,
      END OF ity_data,
      BEGIN OF ity_mara,
        matnr TYPE matnr,
      END OF ity_mara,
      BEGIN OF ity_t005,
        land1 TYPE land1,
      END OF ity_t005,
      BEGIN OF ity_t685,
        kschl TYPE kschg,
      END OF ity_t685.

DATA: i_file_data  TYPE STANDARD TABLE OF ity_file,
      i_file_temp  TYPE STANDARD TABLE OF ity_file,
      i_file_tot   TYPE STANDARD TABLE OF ity_file,
      i_sucess_rec TYPE STANDARD TABLE OF ity_file,
      i_error_rec  TYPE STANDARD TABLE OF ity_file,
      i_kotg501    TYPE STANDARD TABLE OF kotg501,
      i_mara       TYPE STANDARD TABLE OF ity_mara,
      i_t005       TYPE STANDARD TABLE OF ity_t005,
      i_t685       TYPE STANDARD TABLE OF ity_t685,
      v_head       TYPE string,
      v_rows       TYPE char05,
      v_err_flag   TYPE boolean,
      i_bdcdata    TYPE STANDARD TABLE OF bdcdata,
      i_bdcmsgcoll TYPE STANDARD TABLE OF bdcmsgcoll.

TYPES:tyt_bdcmsgcoll TYPE STANDARD TABLE OF bdcmsgcoll.

DATA:ir_table      TYPE REF TO cl_salv_table,
     ir_selections TYPE REF TO cl_salv_selections.
DATA: i_const      TYPE STANDARD TABLE OF zcaconstant,
      v_total_proc TYPE char05,
      v_success    TYPE char05,
      v_error      TYPE char05,
      v_file_path  TYPE string.
DATA:v_path_in  TYPE filepath-pathintern VALUE 'Z_C113_WLS_PRODUCT_IN',
     v_path_prc TYPE filepath-pathintern VALUE 'Z_C113_WLS_PRODUCT_PRC',
     v_path_err TYPE filepath-pathintern VALUE 'Z_C113_WLS_PRODUCT_ERR'.

CONSTANTS: c_field  TYPE dynfnam     VALUE 'P_FILE',          "Field name
           c_e      TYPE char1       VALUE 'E',
           c_x      TYPE char1       VALUE 'X',
           c_s      TYPE char1       VALUE 'S',
           c_true   TYPE sap_bool    VALUE 'X',
           c_devid  TYPE zdevid      VALUE 'C120',
           c_langu  TYPE char1       VALUE 'E',
           c_param1 TYPE rvari_vnam  VALUE 'NO_OF_RECORDS'.
