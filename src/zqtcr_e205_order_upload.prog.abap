*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_E205_ORDER_UPLOAD (Main Program)
* PROGRAM DESCRIPTION: Create  contracts for Knewton
* DEVELOPER: Nageswara (NPOLINA)
* CREATION DATE:   05/28/2019
* OBJECT ID:       E205
* TRANSPORT NUMBER(S): ED2K915128
*----------------------------------------------------------------------*

REPORT zqtcr_e205_order_upload NO STANDARD PAGE HEADING
                                   MESSAGE-ID zqtc_r2.

INCLUDE zqtcn_e205_order_top.


INCLUDE zqtcn_e205_order_sel.


INCLUDE zqtcn_e205_order_sub.

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
* SOC by   NPOLINA ED2K915113 27/May/2019 e205 code moved from 'after ZCACONSTANT selection'
  IF  p_a_file IS NOT INITIAL.  " If application server path is found
    PERFORM f_read_from_app_srvr.
  ELSE. " ELSE -> IF p_a_file IS NOT INITIAL
    PERFORM f_convert_new_ord_excel  USING    p_file     "File path
                                          CHANGING i_final_ord[]. "Input Data (table)
  ENDIF. " IF p_a_file IS NOT INITIAL
* EOC by   NPOLINA ED2K915113 27/May/2019 e205
*  IF i_const IS INITIAL .
*    SELECT devid                      "Development ID
*            param1                     "ABAP: Name of Variant Variable
*            param2                     "ABAP: Name of Variant Variable
*            srno                       "Current selection number
*            sign                       "ABAP: ID: I/E (include/exclude values)
*            opti                       "ABAP: Selection option (EQ/BT/CP/...)
*            low                        "Lower Value of Selection Condition
*            high                       "Upper Value of Selection Condition
*            activate                   "Activation indicator for constant
*            FROM zcaconstant           " Wiley Application Constant Table
*            INTO TABLE i_const
*            WHERE devid    = c_devid
*            AND   activate = c_x. "Only active record
*    IF sy-subrc EQ 0.
*      SORT i_const BY devid param1.
**--*App server FIle path
*      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e205_path>) WITH KEY devid = c_devid " NPOLINA 27/May/2019 ED2K915113
*                                                param1 = c_path
*                                                BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        v_e205_path = <lst_e205_path>-low.
*      ENDIF.
*
**--*Sales Org
**      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e205_sorg>) WITH KEY devid = c_devid " NPOLINA 27/May/2019 ED2K915113
*      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e205_sorg>) WITH KEY devid = c_devid " NPOLINA 27/May/2019 ED2K915113
*                                                param1 = c_sorg
*                                                BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        v_e205_sorg = <lst_e205_sorg>-low.
*      ENDIF.
*
**--*Sales DIst Channel
**      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e205_dist>) WITH KEY devid = c_devid " NPOLINA 27/May/2019 ED2K915113
*      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e205_dist>) WITH KEY devid = c_devid " NPOLINA 27/May/2019 ED2K915113
*                                                param1 = c_dist
*                                                BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        v_e205_dist = <lst_e205_dist>-low.
*      ENDIF.
*
**--*Pricing Condition Type
**      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e205_cond>) WITH KEY devid = c_devid " NPOLINA 27/May/2019 ED2K915113
*      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e205_cond>) WITH KEY devid = c_devid " NPOLINA 27/May/2019 ED2K915113
*                                                param1 = c_cond
*                                                BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        v_e205_cond = <lst_e205_cond>-low.
*      ENDIF.
*
**--*Row limit
**      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e205_limit>) WITH KEY devid = c_devid " NPOLINA 27/May/2019 ED2K915113
*      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e205_limit>) WITH KEY devid = c_devid " NPOLINA 27/May/2019 ED2K915113
*                                                param1 = c_limit
*                                                BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        v_line_lmt = <lst_e205_limit>-low.
*      ENDIF.
*
**--*Item : Discount Text TDID
**      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e205_tdid>) WITH KEY devid = c_devid " NPOLINA 27/May/2019 ED2K915113
*      READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lst_e205_tdid>) WITH KEY devid = c_devid " NPOLINA 27/May/2019 ED2K915113
*                                                param1 = c_tdid
*                                                BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        v_tdid = <lst_e205_tdid>-low.
*      ENDIF.
*
*    ENDIF.
*  ENDIF.

*====================================================================*
* E N D - O F - S E L E C T I O N
*====================================================================*
END-OF-SELECTION.
  IF p_a_file IS INITIAL.      " If application server path is NOT found
    PERFORM f_display_new_data_ord_alv.
  ELSE. " ELSE -> IF p_a_file IS INITIAL
    PERFORM f_contract_createfromdata .
  ENDIF. " IF p_a_file IS INITIAL
