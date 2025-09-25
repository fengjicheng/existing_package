*------------------------------------------------------------------- *
* PROGRAM NAME: LZQTC_CIC_BP_SERACHI01
* PROGRAM DESCRIPTION: Module for entry / exit
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2017-07-01
* OBJECT ID: E157
* TRANSPORT NUMBER(S): ED2K906716(W),ED2K907051(C)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
***INCLUDE LZQTC_CIC_BP_SERACHI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       Module for entry and exit
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE v_user_command.
    WHEN 'ABBR'.
      CLEAR: v_bp_search.
      SET SCREEN 0.
      LEAVE SCREEN.

    WHEN 'SICH'.
      IF v_bp_search IS NOT INITIAL.
*  If reference number is not initial
        IF v_bp_search-ihrez IS NOT INITIAL.
**Search from VBKD
          SELECT vbeln " Sales and Distribution Document Number
            FROM vbkd  " Sales Document: Business Data
            UP TO 1 ROWS
            INTO @DATA(lv_vbeln)
            WHERE ihrez = @v_bp_search-ihrez.
          ENDSELECT.
          IF sy-subrc NE 0.
            v_partner_error = abap_true.
          ELSE. " ELSE -> IF sy-subrc NE 0
            SELECT SINGLE kunnr " Sold-to party
              FROM vbak         " Sales Document: Header Data
              INTO @DATA(lv_kunnr)
              WHERE vbeln = @lv_vbeln.
            IF sy-subrc EQ 0.
              v_bp_search-partner = lv_kunnr.
            ELSEIF lv_kunnr IS INITIAL.
              v_partner_error = abap_true.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF sy-subrc NE 0
        ENDIF. " IF v_bp_search-ihrez IS NOT INITIAL

* If identification number/ecore legacy number is not initial then serach BP using this
        IF v_bp_search-idnumber IS NOT INITIAL.
          SELECT sign,
                 opti,
                 low,
                 high        " Upper Value of Selection Condition
            FROM zcaconstant " Wiley Application Constant Table
            INTO TABLE @DATA(li_constant)
            WHERE devid = @c_devid
            AND   param1 = @c_type.
          IF sy-subrc EQ 0.
            SELECT partner
              FROM but0id " BP: ID Numbers
              UP TO 1 ROWS
              INTO @DATA(lv_but_p)
              WHERE type IN @li_constant
              AND   idnumber = @v_bp_search-idnumber.
             ENDSELECT.
            IF sy-subrc NE 0.
              v_partner_error = abap_true.
            ELSE. " ELSE -> IF sy-subrc NE 0
              v_bp_search-partner = lv_but_p.
            ENDIF. " IF sy-subrc NE 0
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF v_bp_search-idnumber IS NOT INITIAL
* If VAT number is not initial serach BP from this
        IF v_bp_search-taxnum IS NOT INITIAL.
          SELECT partner
            FROM dfkkbptaxnum " Tax Numbers for Business Partner
            UP TO 1 ROWS
            INTO @DATA(lv_tax_p)
            WHERE taxnum = @v_bp_search-taxnum.
          ENDSELECT.
          IF sy-subrc NE 0.
            v_partner_error = abap_true.
          ELSE. " ELSE -> IF sy-subrc NE 0
            v_bp_search-partner = lv_tax_p.
          ENDIF. " IF sy-subrc NE 0
        ENDIF. " IF v_bp_search-taxnum IS NOT INITIAL

        IF lv_but_p IS NOT INITIAL
          AND lv_tax_p IS NOT INITIAL
          AND lv_but_p NE lv_tax_p.
          v_partner_error = abap_true.
        ENDIF. " IF lv_but_p IS NOT INITIAL
        SET SCREEN 0.
        LEAVE SCREEN.
      ENDIF. " IF v_bp_search IS NOT INITIAL
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
