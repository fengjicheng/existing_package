*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CSS_RAR_REL_DEL_BLK
*&---------------------------------------------------------------------*
DATA:
  lv_xvbep      TYPE char30 VALUE '(SAPFV45P)XVBEP[]',          "Sales Document: Schedule Line Data
  lv_css_rar_db TYPE flag.                                      "Flag: CSS RAR Relevant

DATA:
  lir_del_blk   TYPE RANGE OF lifsp_ep INITIAL SIZE 0,          "Range: Schedule line blocked for delivery
  li_const_vals TYPE zcat_constants.                            "Constant Values

FIELD-SYMBOLS:
  <li_xvbep>    TYPE va_vbepvb_t.

CONSTANTS:
  lc_devid_e158 TYPE zdevid      VALUE 'E158',                  "Development ID
  lc_param_db   TYPE rvari_vnam  VALUE 'DELIVERY_BLOCK',        "ABAP: Name of Variant Variable
  lc_param_rar  TYPE rvari_vnam  VALUE 'CSS_RAR_REL'.           "ABAP: Name of Variant Variable

* Get data from constant table
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e158
  IMPORTING
    ex_constants = li_const_vals.
LOOP AT li_const_vals ASSIGNING FIELD-SYMBOL(<lst_const_val>).
  CASE <lst_const_val>-param1.
    WHEN lc_param_db.                                           "ABAP: Name of Variant Variable (DELIVERY_BLOCK)
      CASE <lst_const_val>-param2.
        WHEN lc_param_rar.                                      "ABAP: Name of Variant Variable (CSS_RAR_REL)
          APPEND INITIAL LINE TO lir_del_blk ASSIGNING FIELD-SYMBOL(<lst_del_blk>).
          <lst_del_blk>-sign   = <lst_const_val>-sign.
          <lst_del_blk>-option = <lst_const_val>-opti.
          <lst_del_blk>-low    = <lst_const_val>-low.
          <lst_del_blk>-high   = <lst_const_val>-high.

        WHEN OTHERS.
*         Nothing to do
      ENDCASE.

    WHEN OTHERS.
*     Nothing to do
  ENDCASE.
ENDLOOP.

ASSIGN (lv_xvbep) TO <li_xvbep>.
IF sy-subrc EQ 0.
* Check if there is any CSS RAR Relevant Schedule Line Delivery Block
  LOOP AT <li_xvbep> ASSIGNING FIELD-SYMBOL(<lst_xvbep>)
       WHERE lifsp IN lir_del_blk.                              "Schedule line blocked for delivery
    lv_css_rar_db = abap_true.
  ENDLOOP.

  IF lv_css_rar_db IS NOT INITIAL.
    RETURN.
  ENDIF.
ENDIF.
