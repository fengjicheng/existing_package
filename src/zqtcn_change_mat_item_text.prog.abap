*&---------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_CHANGE_MAT_ITEM_TEXT
* PROGRAM DESCRIPTION: This program implemented for journal title field in JP25 transaction
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE: 12/19/2018
* OBJECT ID: ?
* TRANSPORT NUMBER(S): ED1K909186
*----------------------------------------------------------------------*
REPORT zqtcn_change_mat_item_text NO STANDARD PAGE HEADING  MESSAGE-ID zqtc_r2.
*** INCLUDES-------------------------------------------------------------*
*- For Declaration
INCLUDE zqtcn_chg_mat_item_text_top IF FOUND.
*- For Selection screen
INCLUDE zqtcn_chg_mat_item_text_sel IF FOUND.
*- For subroutines
INCLUDE zqtcn_chg_mat_item_text_sub IF FOUND.
*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.
*--*The Below Subroutine is used to alter Customer PO input
  PERFORM f_sel_dynamics.
*--*Below Subroutine is used to initialize selection screen varaibles
*--*And refresh global varaibles
  PERFORM f_initialization.
*====================================================================*
* A T  S E L E C T I O N  S C R E E N  O U T P U T
*====================================================================*
AT SELECTION-SCREEN OUTPUT.
*-* The below Subroutine is used to change selection screen dynamics.
  PERFORM f_screen_dynamics.
*====================================================================*
* A T  S E L E C T I O N  S C R E E N  V A L U E  R E Q U E ST
*====================================================================*

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_f4_file_name   CHANGING p_file . "File Path

START-OF-SELECTION.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = text-006. "Reading data from file
  IF rb_input = c_x.
    PERFORM f_get_mat_text.
  ELSEIF rb_file = c_x.
    PERFORM f_file_read_from_excel.
    DESCRIBE TABLE li_excel_file LINES g_lines.
    IF g_lines LE 10.
      PERFORM f_get_data.
      PERFORM f_sales_ord_text_upd.
      IF  li_alv_disp_screen[] IS NOT INITIAL.
        PERFORM f_alv_report.
      ENDIF.
    ELSE.
      PERFORM f_place_file_in_app.
      PERFORM batch_job.
    ENDIF.
  ENDIF.
