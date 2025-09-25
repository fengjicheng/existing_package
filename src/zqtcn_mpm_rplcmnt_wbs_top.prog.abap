*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTCN_MPM_RPLCMNT_WBS_TOP
* PROGRAM DESCRIPTION:  Include for Global declaration of variables,constants
*                       and Internal tables
* DEVELOPER:            Aratrika Banerjee(ARABANERJE)
* CREATION DATE:        17-Jan-2017
* OBJECT ID:            C079
* TRANSPORT NUMBER(S):  ED2K904151
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MPM_RPLCMNT_WBS_TOP
*&---------------------------------------------------------------------*
TABLES : prps, " WBS (Work Breakdown Structure) Element Master Data
         mara, " General Material Data
         proj. " Project definition

TYPES : BEGIN OF ty_zzmpm_range,
          sign   TYPE tvarv-sign,      " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv-opti,      " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE zzmpmissu,       " ABAP/4: Selection value (LOW or HIGH value, external format)
          high   TYPE zzmpmissu,       " ABAP/4: Selection value (LOW or HIGH value, external format)
        END OF ty_zzmpm_range,

        BEGIN OF ty_final_data,
          posid     TYPE ps_pspid,     " WBS Element
          zzmpm     TYPE zzmpmissu,    " MPM Issue
          zzmpm_new TYPE zzmpmissu,    " MPM Issue
          identcode TYPE ismidentcode, " Identification Code
          status    TYPE char1,        "Status: '1' = red/error, '3' = green/success
          message   TYPE bapi_msg,     " Message of type CHAR100
        END OF  ty_final_data,

        BEGIN OF ty_mtart_range,
          sign   TYPE tvarv-sign, " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv-opti, " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE mtart,  " ABAP/4: Selection value (LOW or HIGH value, external format)
          high   TYPE mtart,  " ABAP/4: Selection value (LOW or HIGH value, external format)
        END OF ty_mtart_range,

        tt_final_data   TYPE STANDARD TABLE OF ty_final_data,

        tty_zzmpm_range TYPE STANDARD TABLE OF ty_zzmpm_range,

        tty_mtart_range TYPE STANDARD TABLE OF ty_mtart_range.


CONSTANTS : c_sign_incld TYPE ddsign   VALUE 'I',         "Sign: (I)nclude
            c_opti_equal TYPE ddoption VALUE 'EQ',        "Option: (EQ)ual
            c_msgty_info TYPE symsgty  VALUE 'I',         "Message Type: Information
            c_status_suc TYPE char1    VALUE '3',         "Status: Green/Success
            c_status_err TYPE char1    VALUE '1',         "Status: Red/Error
            c_jrnl       TYPE ismidcodetype VALUE 'JRNL', " Type of Identification Code
            c_mtart_zgl3 TYPE char4    VALUE 'ZGL3',      " Mtart_zgl3 of type CHAR4
            c_mtart_zjl3 TYPE char4    VALUE 'ZJL3',      " Mtart_zjl3 of type CHAR4
            c_mtart_zjid TYPE char4    VALUE 'ZJID',      " Mtart_zjid of type CHAR4
            c_mtart_zjip TYPE char4    VALUE 'ZJIP'.      " Mtart_zjip of type CHAR4
