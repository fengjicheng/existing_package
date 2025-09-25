*&---------------------------------------------------------------------*
*& Report  ZQTC_SALES_ORDER_UPDATE
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_SALES_ORDER_UPDATE
* PROGRAM DESCRIPTION: This program implemented for to  update Sales order
*                      data with header and item
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE: 06/25/2018
* OBJECT ID: INC0193784
* TRANSPORT NUMBER(S):  ED2K912413
*----------------------------------------------------------------------*
REPORT zqtc_sales_order_update NO STANDARD PAGE HEADING  MESSAGE-ID zqtc_r2.
TYPE-POOLS: kcde.
*** INCLUDES-------------------------------------------------------------*
*- For Declaration
INCLUDE zqtc_sales_order_update_top IF FOUND.
*- For Selection screen
INCLUDE zqtc_sales_order_update_sel IF FOUND.
*- For subroutines
INCLUDE zqtc_sales_order_update_sub IF FOUND.
*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.
*--*The Below Subroutine is used to alter Customer PO input
  PERFORM f_po_dynamics.
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
  IF rb_input EQ c_x.
    PERFORM f_get_data.
    IF i_alv_disp_screen[] IS NOT INITIAL.
      PERFORM f_alv_disp.
    ELSE.
      MESSAGE i000(zqtc_r2) WITH text-005. "'No Entries for given data'
    ENDIF.
  ELSEIF rb_file EQ c_x.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        text = text-006. "Reading data from file
    PERFORM f_place_file_in_app.
    PERFORM batch_job.
    i_mail[] = p_mail[].
    PERFORM f_bapi_update_with_new_value USING     p_recon
                                                   p_ind
                                                   p_user
                                                   p_job
                                         CHANGING  i_excel_file
                                                   i_mail.
  ENDIF.
