*----------------------------------------------------------------------*
* PROGRAM NAME: ZRTRN_RESTRICT_OUTPUT_I0229
* PROGRAM DESCRIPTION: Restrict O/P Type based on Material Group 3
* DEVELOPER: Writtick Roy
* CREATION DATE:   2017-03-12
* OBJECT ID: I0229
* TRANSPORT NUMBER(S): ED2K902781
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906206
* REFERENCE NO: CR# 517
* DEVELOPER: Writtick Roy
* DATE:  2017-05-18
* DESCRIPTION: Don't trigger O/P Type if only Acceptance Date is changed
*----------------------------------------------------------------------*
DATA:
  lv_fname_xvbap TYPE char40 VALUE '(SAPMV45A)XVBAP[]',         "Sales Document: Item Data
* Begin of ADD:CR#517:WROY:18-MAY-2017:ED2K906206
  lv_fname_xveda TYPE char40 VALUE '(SAPLV45W)XVEDA[]',         "Sales Document: Contract Data
  lv_fname_yveda TYPE char40 VALUE '(SAPLV45W)YVEDA[]'.         "Sales Document: Contract Data
* End   of ADD:CR#517:WROY:18-MAY-2017:ED2K906206

FIELD-SYMBOLS:
  <li_ord_lines> TYPE va_vbapvb_t,                              "Sales Document: Item Data
* Begin of ADD:CR#517:WROY:18-MAY-2017:ED2K906206
  <li_xcontract> TYPE ztrar_vedavb,                             "Sales Document: Item Data
  <li_ycontract> TYPE ztrar_vedavb.                             "Sales Document: Item Data
* End   of ADD:CR#517:WROY:18-MAY-2017:ED2K906206

DATA:
  lv_fulfillment TYPE flag,                                     "Flag: Fulfillment relevant
* Begin of ADD:CR#517:WROY:18-MAY-2017:ED2K906206
  lv_agr_ac_date TYPE flag.                                     "Flag: Agreement acceptance date
* End   of ADD:CR#517:WROY:18-MAY-2017:ED2K906206

DATA:
  lr_mat_group_3 TYPE efg_tab_ranges.                           "Range: Material Group 3

CONSTANTS:
  lc_devid_i0229 TYPE zdevid      VALUE 'I0229',                "Development ID: I0229
  lc_param_mvgr3 TYPE rvari_vnam  VALUE 'MAT_GRP_3',            "Name of Variant Variable: Material Group 3
* Begin of ADD:CR#517:WROY:18-MAY-2017:ED2K906206
  lc_posnr_hdr   TYPE posnr_va    VALUE '000000'.               "Sales Document Item (Header)
* End   of ADD:CR#517:WROY:18-MAY-2017:ED2K906206

* Get Cnonstant values
SELECT param1,                                                  "ABAP: Name of Variant Variable
       param2,                                                  "ABAP: Name of Variant Variable
       srno,                                                    "Current selection number
       sign,                                                    "ABAP: ID: I/E (include/exclude values)
       opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
       low,                                                     "Lower Value of Selection Condition
       high                                                     "Upper Value of Selection Condition
  FROM zcaconstant
  INTO TABLE @DATA(li_const_values)
 WHERE devid    EQ @lc_devid_i0229                              "Development ID
   AND activate EQ @abap_true.                                  "Only active record
IF sy-subrc IS INITIAL.
  LOOP AT li_const_values ASSIGNING FIELD-SYMBOL(<lst_const_value>).
    CASE <lst_const_value>-param1.
      WHEN lc_param_mvgr3.                                      "Material Group 3 (MAT_GRP_3)
        APPEND INITIAL LINE TO lr_mat_group_3 ASSIGNING FIELD-SYMBOL(<lst_mat_grp_3>).
        <lst_mat_grp_3>-sign   = <lst_const_value>-sign.
        <lst_mat_grp_3>-option = <lst_const_value>-opti.
        <lst_mat_grp_3>-low    = <lst_const_value>-low.
        <lst_mat_grp_3>-high   = <lst_const_value>-high.

      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF. " IF sy-subrc IS INITIAL

* Begin of ADD:CR#517:WROY:18-MAY-2017:ED2K906206
* Retrieve Sales Document: Contract Data
ASSIGN (lv_fname_xveda) TO <li_xcontract>.
IF sy-subrc EQ 0.
  ASSIGN (lv_fname_yveda) TO <li_ycontract>.
  IF sy-subrc EQ 0 AND <li_ycontract> IS NOT INITIAL.
    LOOP AT <li_ycontract> INTO DATA(lst_ycontract).
      READ TABLE <li_xcontract> INTO DATA(lst_xcontract)
           WITH KEY vbeln = lst_ycontract-vbeln
                    vposn = lst_ycontract-vposn.
      IF sy-subrc EQ 0.
        lst_xcontract-updkz   = lst_ycontract-updkz.            "Update indicator
        lst_xcontract-vabndat = lst_ycontract-vabndat.          "Agreement acceptance date
*       Check if Agreement acceptance date is the only field changed
        IF lst_ycontract EQ lst_xcontract.
          lv_agr_ac_date = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

* Fetch Contract Data (Header)
  READ TABLE <li_xcontract> INTO DATA(lst_xcontract_hdr)
       WITH KEY vbeln = komkbv1-vbeln
                vposn = lc_posnr_hdr.
  IF sy-subrc EQ 0 AND
     lst_xcontract_hdr-updkz NE wavi_ta_type_insert.            "Not an Insert / Initial creation

    LOOP AT <li_xcontract> INTO lst_xcontract.
      IF lst_xcontract-vbeln EQ komkbv1-vbeln AND
         lst_xcontract-vposn NE lc_posnr_hdr  AND               "Not the Header Line - this is for specific Line item
         lst_xcontract-updkz EQ wavi_ta_type_insert.            "Insert / Newly being added

        lst_xcontract-updkz   = lst_xcontract_hdr-updkz.        "Update indicator
        lst_xcontract-vabndat = lst_xcontract_hdr-vabndat.      "Agreement acceptance date
        lst_xcontract-vposn   = lst_xcontract_hdr-vposn.        "Sales Document Item
*       Check if Agreement acceptance date is the only field changed
        IF lst_xcontract_hdr EQ lst_xcontract.
          lv_agr_ac_date = abap_true.
        ENDIF.

      ENDIF.
    ENDLOOP.
  ENDIF.
ENDIF.

IF lv_agr_ac_date IS NOT INITIAL.                               "Agreement acceptance date is the only field changed
  sy-subrc = 4.
ELSE.
* End   of ADD:CR#517:WROY:18-MAY-2017:ED2K906206
* Retrieve Sales Document: Item Data
  ASSIGN (lv_fname_xvbap) TO <li_ord_lines>.
  IF sy-subrc EQ 0.
* Check Material Group 3 of all the Line Items
    LOOP AT <li_ord_lines> ASSIGNING FIELD-SYMBOL(<lst_ord_line>).
      IF <lst_ord_line>-mvgr3 IN lr_mat_group_3.                "Material Group 3
        lv_fulfillment = abap_true.                             "Flag: Fulfillment relevant
      ENDIF.
    ENDLOOP.
  ENDIF.
  IF lv_fulfillment EQ abap_true.                               "Fulfillment relevant
    sy-subrc = 0.
  ELSE.                                                         "Not relevant for Fulfillment
    sy-subrc = 4.
  ENDIF.
* Begin of ADD:CR#517:WROY:18-MAY-2017:ED2K906206
ENDIF.
* End   of ADD:CR#517:WROY:18-MAY-2017:ED2K906206
