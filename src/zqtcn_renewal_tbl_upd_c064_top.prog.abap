*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTC_RENEWAL_TBL_UPD_C064_TOP(Global Declaration)
* PROGRAM DESCRIPTION: Update renewal Plan table to update Status
* obtained from E096
* DEVELOPER: Aratrika Banerjee
* CREATION DATE:   2017-04-07
* OBJECT ID : C064
* TRANSPORT NUMBER(S):  ED2K905240
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*

TYPES : BEGIN OF ty_upload_file,
          vbeln    TYPE vbeln_va,      " Sales Document
          posnr	   TYPE posnr_va,      " Sales Document Item
          activity TYPE zactivity_sub, " E095: Activity
        END OF ty_upload_file,

        tt_upload_file TYPE STANDARD TABLE OF ty_upload_file
                       INITIAL SIZE 0.


DATA : i_upload_file TYPE tt_upload_file,                          "Upload file
       i_output_file TYPE TABLE OF zqtc_renwl_plan INITIAL SIZE 0. " E095: Renewal Plan Table

CONSTANTS : c_field  TYPE dynfnam VALUE 'P_FILE',                             " Field name: for Local file
            c_rucomm TYPE syucomm VALUE 'RUCOMM',                             "Function Code
            c_onli   TYPE syucomm VALUE 'ONLI',                               " Function Code
            c_tab    TYPE char1 VALUE cl_abap_char_utilities=>horizontal_tab. " Tab of type CHAR1
