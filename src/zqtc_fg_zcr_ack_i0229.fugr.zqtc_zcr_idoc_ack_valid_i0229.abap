FUNCTION zqtc_zcr_idoc_ack_valid_i0229.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_VBAK) TYPE  VBAK OPTIONAL
*"  EXPORTING
*"     VALUE(EX_SUBRC) TYPE  SY-SUBRC
*"     VALUE(EX_CR) TYPE  C
*"     VALUE(EX_CONST) TYPE  ZCAT_CONSTANTS
*"----------------------------------------------------------------------

*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_ZCR_IDOC_ACK_VALID_I0229(FM)
* PROGRAM DESCRIPTION: Restrict O/P Type ZCR based on conditions
* DEVELOPER          : Prabhu
* CREATION DATE      : 2019-06-07
* OBJECT ID          : I0229 (ERP-7664)
* TRANSPORT NUMBER(S): ED2K915222
*----------------------------------------------------------------------*
  DATA:
    lir_sales_offc TYPE rjksd_vkbur_range_tab,                     "Range: Sales Office
    lir_potype     TYPE tdt_rg_bsark,                              "Range : PO type
    lir_doc_type   TYPE rjksd_auart_range_tab,                     "Range Doc type
    li_const       TYPE zcat_constants.                            "Itab for constant table entries

  CONSTANTS : lc_devid     TYPE zdevid VALUE 'I0229',
              lc_doc_type  TYPE rvari_vnam VALUE 'DOC_TYPE',
              lc_po_type   TYPE rvari_vnam VALUE 'PO_TYPE',
              lc_sales_ofc TYPE rvari_vnam VALUE 'SALES_OFC',
              lc_param_b   TYPE rvari_vnam VALUE 'CR'.
*--*Get Constant values
  IF li_const IS INITIAL.
    CALL FUNCTION 'ZQTC_GET_ZCACONSTANT_ENT'
      EXPORTING
        im_devid         = lc_devid
      IMPORTING
        ex_t_zcacons_ent = li_const.
  ENDIF.
*--*Build internal tables with constant values
  IF li_const[] IS NOT INITIAL.
    LOOP AT li_const ASSIGNING FIELD-SYMBOL(<lst_const>).
      CASE <lst_const>-param1.
        WHEN lc_doc_type.
          CASE <lst_const>-param2.
            WHEN lc_param_b.
              APPEND INITIAL LINE TO lir_doc_type ASSIGNING FIELD-SYMBOL(<lst_doc_type>).
              <lst_doc_type>-sign   = <lst_const>-sign.
              <lst_doc_type>-option = <lst_const>-opti.
              <lst_doc_type>-low    = <lst_const>-low.
              <lst_doc_type>-high   = <lst_const>-high.
            WHEN OTHERS.
          ENDCASE.
        WHEN lc_sales_ofc.
          CASE <lst_const>-param2..
            WHEN lc_param_b.
              APPEND INITIAL LINE TO lir_sales_offc ASSIGNING FIELD-SYMBOL(<lst_sales_offc>).
              <lst_sales_offc>-sign   = <lst_const>-sign.
              <lst_sales_offc>-option = <lst_const>-opti.
              <lst_sales_offc>-low    = <lst_const>-low.
              <lst_sales_offc>-high   = <lst_const>-high.
            WHEN OTHERS.
          ENDCASE.
        WHEN lc_po_type.
          CASE <lst_const>-param2.
            WHEN lc_param_b..
              APPEND INITIAL LINE TO lir_potype ASSIGNING FIELD-SYMBOL(<lst_potype>).
              <lst_potype>-sign   = <lst_const>-sign.
              <lst_potype>-option = <lst_const>-opti.
              <lst_potype>-low    = <lst_const>-low.
              <lst_potype>-high   = <lst_const>-high.
            WHEN OTHERS.
          ENDCASE.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDIF.
  ex_const[] = li_const[].
*--*Check sales office and PO type
  IF im_vbak-auart IN lir_doc_type AND
      im_vbak-vkbur IN lir_sales_offc  AND
      im_vbak-bsark IN  lir_potype.
    ex_subrc = 0.
    ex_cr = abap_true.
  ELSE.
    ex_subrc = 4.
  ENDIF.
ENDFUNCTION.
