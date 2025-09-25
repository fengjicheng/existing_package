*----------------------------------------------------------------------*
*PROGRAM NAME: ZSCMN_C044_MAT_CONS_UPLOAD_TOP
*PROGRAM DESCRIPTION: Load 3 years of consumption history for active
*                     materials
* DEVELOPER: Shivani Upadhyaya/Cheenangshuk Das
* CREATION DATE:   2016-07-18
* DER NUMBER:
* TRANSPORT NUMBER(S): ED2K902573
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZSCMI_C044_MAT_CONS_UPLOAD_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  S T R U C T U R E S                                                *
*&---------------------------------------------------------------------*
TYPES : BEGIN OF ty_upload_file,
          perkz TYPE perkz,                " Period Indicator
          matnr TYPE  matnr,               " Material Number
          werks TYPE  werks_d,             " Plant
          ertag TYPE  ertag,               " First day of the period to which the values refer
          vbwrt TYPE  char18,              " Consumption value
          kovbw TYPE  char18,              " Corrected consumption value
          kzexi TYPE  xfeld,               " Checkbox
          antei TYPE  char8,               " Ratio of the corrected value to the original value (CV:OV)
        END OF ty_upload_file,

        BEGIN OF ty_upload_char,
          perkz TYPE  char1,               " Period Indicator
          matnr TYPE  char18,              " Material Number
          werks TYPE  char4,               " Plant
          ertag TYPE  char8,               " First day of the period to which the values refer
          vbwrt TYPE  char18,              " Consumption value
          kovbw TYPE  char18,              " Corrected consumption value
          kzexi TYPE  char1,               " Checkbox
          antei TYPE  char8,               " Ratio of the corrected value to the original value (CV:OV)
        END OF ty_upload_char,

        BEGIN OF ty_alv_disp,
          traffic TYPE char4,              " Traffic of type CHAR4
          matnr   TYPE  matnr,             " Material Number
          vkorg   TYPE  vkorg,             " Sales Organization
          vtweg   TYPE  vtweg,             " Distribution Channel
          werks   TYPE  werks_d,           " Plant
          lgort   TYPE  lgort_d,           " Storage Location
          lgnum   TYPE  lgnum,             " Warehouse Number / Warehouse Complex
          lgtyp   TYPE  lgtyp,             " Storage Type
          bwkey   TYPE  bwkey,             " Valuation Area
          bwtar   TYPE  bwtar_d,           " Valuation Type
          mykey   TYPE  mykey,             " LIFO valuation level
          tbnam   TYPE  tbnam,             " Table name
          btwrk   TYPE  w_werks,           " Retail plant
          message TYPE string,
        END OF ty_alv_disp,

        BEGIN OF ty_download_file,
          matnr   TYPE matnr,              " Material Number
          werks   TYPE werks_d,            " Plant
          message TYPE string,
        END OF ty_download_file,

        BEGIN OF ty_constant,
          devid  TYPE zdevid,              " Development ID
          param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
          param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
          srno   TYPE tvarv_numb,          " ABAP: Current selection number
          sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
          opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
          high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
        END OF ty_constant,
*&---------------------------------------------------------------------*
*& T A B L E  T Y P E S
*&---------------------------------------------------------------------*
        tty_upload_file    TYPE STANDARD TABLE OF ty_upload_file   INITIAL SIZE 0,
        tty_download_file  TYPE STANDARD TABLE OF ty_download_file INITIAL SIZE 0,
        tty_amveg          TYPE STANDARD TABLE OF mveg_ueb         INITIAL SIZE 0, " Data Transfer: Consumption Incl. Administration
        tty_amveu          TYPE STANDARD TABLE OF mveu_ueb         INITIAL SIZE 0, " Data Transfer: Unplanned Consumption Incl. Administration
        tty_merrdat        TYPE STANDARD TABLE OF merrdat_f        INITIAL SIZE 0, " DI: Structure for Returning Error Messages (Retail)
        tty_alv_disp       TYPE STANDARD TABLE OF ty_alv_disp      INITIAL SIZE 0,
        tty_upload_char    TYPE STANDARD TABLE OF ty_upload_char   INITIAL SIZE 0,
        tty_constant       TYPE STANDARD TABLE OF ty_constant      INITIAL SIZE 0.
*&---------------------------------------------------------------------*
*& I N T E R N A L  T A B L E
*&---------------------------------------------------------------------*
DATA:   i_upload_file      TYPE tty_upload_file,
        i_download_file    TYPE tty_download_file,
        i_alv_disp         TYPE tty_alv_disp,
        i_amerrdat_f       TYPE tty_merrdat, " DI: Structure for Returning Error Messages (Retail)
        i_fcat             TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0,
        i_constant         TYPE STANDARD TABLE OF ty_constant       INITIAL SIZE 0,
*&--------------------------------------------------------------------*
*& V A R I A B L E
*&--------------------------------------------------------------------*
        v_total_lines_read TYPE i,
        v_error_lines      TYPE i,
        v_success_lines    TYPE i,
        v_download_chk     TYPE abap_bool.
*&---------------------------------------------------------------------*
*&  C O N S T A N T S
*&---------------------------------------------------------------------*
CONSTANTS:      c_field    TYPE dynfnam VALUE 'P_FILE',                               " Field name: for Local file
                c_rucomm   TYPE syucomm VALUE 'RUCOMM',                               " Function Code
                c_onli     TYPE syucomm VALUE 'ONLI',                                 " Function Code
                c_e        TYPE symsgty VALUE 'E',                                    " Message Type
                c_a        TYPE symsgty VALUE 'A',                                    " Message Type
                c_con_tab  TYPE c       VALUE cl_abap_char_utilities=>horizontal_tab, " Con_tab of type Character
                c_con_tab2  TYPE c       VALUE cl_abap_char_utilities=>vertical_tab, " Con_tab of type Character
                c_s        TYPE bapi_mtype VALUE 'S',                                 " Message type: S Success, E Error, W Warning, I Info, A Abort
                c_i        TYPE bapi_mtype VALUE 'I'.                                 " Message type: S Success, E Error, W Warning, I Info, A Abort
