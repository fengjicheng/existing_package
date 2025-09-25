*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_SALES_ORDER_UPDATE
* PROGRAM DESCRIPTION: This program implemented for to  update Sales order
*                      data with header and item
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE: 08/01/2018
* OBJECT ID: WRICEF - C102
* TRANSPORT NUMBER(S):  ED2K912851
*----------------------------------------------------------------------*
REPORT zqtc_ord_chg_new_fields_c102 NO STANDARD PAGE HEADING  MESSAGE-ID zqtc_r2.

*** INCLUDES-------------------------------------------------------------*
*- For Declaration
INCLUDE zqtc_sales_ord_chg_new_fld_top IF FOUND.
*- For Selection screen
INCLUDE zqtc_sales_ord_chg_new_fld_sel IF FOUND.
*- For subroutines
INCLUDE zqtc_sales_ord_chg_new_fld_sub IF FOUND.
*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.
  PERFORM f_initialization.
  PERFORM f_dynamic.
*====================================================================*
* A T  S E L E C T I O N  S C R E E N  O U T P U T
*====================================================================*
AT SELECTION-SCREEN OUTPUT.
  PERFORM f_dynamic.
*====================================================================*
* A T  S E L E C T I O N  S C R E E N  V A L U E  R E Q U E ST
*====================================================================*
*====================================================================*
* A T  S E L E C T I O N  S C R E E N  V A L U E  R E Q U E ST
*====================================================================*

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_f4_file_name   CHANGING p_file . "File Path                     ##PERF_GLOBAL_PAR_OK

START-OF-SELECTION.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = text-002. "Place the file in Application server
  PERFORM f_upload_data_from_excel.
  PERFORM f_place_file_in_app.
  PERFORM batch_job.
  PERFORM f_bapi_update_with_new_value USING p_user
                                             p_job
                                       CHANGING i_excel_file
                                                i_mail .
