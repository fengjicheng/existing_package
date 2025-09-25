*----------------------------------------------------------------------*
* PROGRAM NAME: ZRTRN_CPY_CNTRL_E144_01 (Include Program)
* PROGRAM DESCRIPTION: Default Billing Item Number for Down Payments
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   11/21/2017
* OBJECT ID: E144
* TRANSPORT NUMBER(S): ED2K909525
*----------------------------------------------------------------------*
CONSTANTS:
  lc_dev_e144  TYPE zdevid     VALUE 'E144',               "Development ID
  lc_p_bil_typ TYPE rvari_vnam VALUE 'BILL_TYPE',          "Parameter: Billing Type
  lc_p_dwn_pmt TYPE rvari_vnam VALUE 'DOWN_PAYMENT',       "Parameter: Down Payment
  lc_p_itm_num TYPE rvari_vnam VALUE 'ITEM_NUMBER'.        "Parameter: Item Number

DATA:
  li_constants TYPE zcat_constants.                        "Constant Values

DATA:
  lv_fld_posnr TYPE char30     VALUE '(SAPLV60B)POSNR'.    "Billing item

FIELD-SYMBOLS:
  <lv_item_no> TYPE posnr_vf.                              "Billing item

IF r_bil_typ_dp IS INITIAL OR                              "Range: Billing Type - Down Payment
   v_def_itm_no IS INITIAL.                                "Billing Item: Default Value
* Fetch Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_dev_e144                           "Development ID
    IMPORTING
      ex_constants = li_constants.                         "Constant Values
  LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
      WHEN lc_p_bil_typ.                                   "Parameter: Billing Type
        CASE <lst_constant>-param2.
          WHEN lc_p_dwn_pmt.                               "Parameter: Down Payment
*           Populate Range: Billing Type - Down Payment
            APPEND INITIAL LINE TO r_bil_typ_dp ASSIGNING FIELD-SYMBOL(<lst_bil_typ>).
            <lst_bil_typ>-sign   = <lst_constant>-sign.
            <lst_bil_typ>-option = <lst_constant>-opti.
            <lst_bil_typ>-low    = <lst_constant>-low.
            <lst_bil_typ>-high   = <lst_constant>-high.

          WHEN OTHERS.
*           Nothing to do
        ENDCASE.

      WHEN lc_p_itm_num.                                   "Parameter: Item Number
        v_def_itm_no = <lst_constant>-low.                 "Billing Item: Default Value

      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF.

* Check Billing Type: Down Payment
IF vbrk-fkart IN r_bil_typ_dp.
  ASSIGN (lv_fld_posnr) TO <lv_item_no>.
  IF sy-subrc EQ 0.
    <lv_item_no> = v_def_itm_no.                           "Billing Item: Default Value (500000)
  ENDIF.
ENDIF.
