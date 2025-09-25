*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_SALES_ORDER_UPDATE
* PROGRAM DESCRIPTION: Update Partner Email IDs in Sales Documents
* DEVELOPER: Nageswar (NPOLINA)
* CREATION DATE: 06/25/2018
* OBJECT ID: E208/INC0236477
* TRANSPORT NUMBER(S):  ED2K915303
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
* TRANSPORT NUMBER(S):
*------------------------------------------------------------------- *
REPORT zqtcr_sales_partner_update NO STANDARD PAGE HEADING
                                   MESSAGE-ID zqtc_r2.

*- For Declaration
INCLUDE zqtcr_sales_partner_top IF FOUND.

*- For Selection screen
INCLUDE zqtcr_sales_partner_sel IF FOUND.

*- For subroutines
INCLUDE zqtcr_sales_partner_sub IF FOUND.

*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.

  sscrfields-functxt_01 = 'Download Template'(055).

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
  IF i_const IS INITIAL.
    SELECT devid                      "Development ID
            param1                     "ABAP: Name of Variant Variable
            param2                     "ABAP: Name of Variant Variable
            srno                       "Current selection number
            sign                       "ABAP: ID: I/E (include/exclude values)
            opti                       "ABAP: Selection option (EQ/BT/CP/...)
            low                        "Lower Value of Selection Condition
            high                       "Upper Value of Selection Condition
            activate                   "Activation indicator for constant
            FROM zcaconstant           " Wiley Application Constant Table
            INTO TABLE i_const
            WHERE devid    = c_devid
            AND   activate = c_x. "Only active record
    IF sy-subrc EQ 0.
      SORT i_const BY devid param1.
*--*App server FIle path
      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_path>) WITH KEY devid = c_devid
                                                param1 = c_path
                                                BINARY SEARCH.
      IF sy-subrc EQ 0.
        v_path = <lst_path>-low.
      ENDIF.

*--*Row limit
      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_limit>) WITH KEY devid = c_devid
                                                param1 = c_limit
                                                BINARY SEARCH.
      IF sy-subrc EQ 0.
        v_line_lmt = <lst_limit>-low.
      ENDIF.

    ENDIF.
  ENDIF.

  IF  p_a_file IS NOT INITIAL.  " If application server path is found
    PERFORM f_read_from_app_orders.
  ELSE. " ELSE -> IF p_a_file IS NOT INITIAL
    PERFORM f_convert_ord_excel  USING    p_file     "File path
                                          CHANGING i_final[]. "Input Data (table)
  ENDIF. " IF p_a_file IS NOT INITIAL

*====================================================================*
* E N D - O F - S E L E C T I O N
*====================================================================*
END-OF-SELECTION.
  IF p_a_file IS INITIAL.      " If application server path is NOT found
    PERFORM f_display_ord_alv.
  ELSE. " ELSE -> IF p_a_file IS INITIAL
    PERFORM f_order_update .
  ENDIF. " IF p_a_file IS INITIAL
