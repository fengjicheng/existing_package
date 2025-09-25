*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCR_WLS_ORDER_UPLOAD_E250 (Main Program)
* PROGRAM DESCRIPTION : Create  contracts for WLS Project
* DEVELOPER           : VDPATABALL
* CREATION DATE       : 06/26/2020
* OBJECT ID           : E250
* TRANSPORT NUMBER(S) : ED2K918622
*----------------------------------------------------------------------*

REPORT zqtcr_e205_order_upload NO STANDARD PAGE HEADING
                                   MESSAGE-ID zqtc_r2.

INCLUDE ZQTCN_WLS_ORDER_E250_TOP.

INCLUDE ZQTCN_WLS_ORDER_E250_SEL.

INCLUDE ZQTCN_WLS_ORDER_E250_SUB.

*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.

  sscrfields-functxt_01 = 'Download Template'(055).
  PERFORM f_get_zcaconstants.

*====================================================================*
* A T  S E L E C T I O N  S C R E E N  V A L U E  R E Q U E ST
*====================================================================*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_f4_file_name   CHANGING p_file . "File Path

AT SELECTION-SCREEN.
  PERFORM f_get_file_template.

*====================================================================*
* S T A R T - O F - S E L E C T I O N
*====================================================================*
START-OF-SELECTION.

  IF  p_a_file IS NOT INITIAL.  " If application server path is found
    PERFORM f_read_from_app_srvr.
  ELSE. " ELSE -> IF p_a_file IS NOT INITIAL
    PERFORM f_convert_new_ord_excel  USING    p_file     "File path
                                          CHANGING i_final_ord[]. "Input Data (table)
  ENDIF. " IF p_a_file IS NOT INITIAL


*====================================================================*
* E N D - O F - S E L E C T I O N
*====================================================================*
END-OF-SELECTION.
  IF p_a_file IS INITIAL.      " If application server path is NOT found
    PERFORM f_display_new_data_ord_alv.
  ELSE. " ELSE -> IF p_a_file IS INITIAL
    PERFORM f_contract_createfromdata .
  ENDIF. " IF p_a_file IS INITIAL
