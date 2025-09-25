*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_UPD_CUST_COND_GRP5_01 (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBKD(MV45AFZZ)"
* PROGRAM DESCRIPTION: Populate Legacy subscription type (Customer
*                      Condition Group 5) for YBP/OASIS Contracts
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 06/13/2018
* OBJECT ID: I0233 (ERP-6425)
* TRANSPORT NUMBER(S): ED2K912297
*----------------------------------------------------------------------*

TYPES:
* Legacy Subscription Type
  BEGIN OF lty_leg_sb_typ,
    pstyv TYPE pstyv,                                           "Item Category
    kdkg5 TYPE kdkg5,                                           "Customer Condition Group 5
  END OF lty_leg_sb_typ,
  ltt_lg_sb_typ TYPE STANDARD TABLE OF lty_leg_sb_typ INITIAL SIZE 0.

DATA:
  li_cnst_i0233 TYPE zcat_constants.                            "Wiley Application Constant Table

CONSTANTS:
  lc_dev_i0233  TYPE zdevid     VALUE 'I0233',                  "Development ID
  lc_p_cust_po  TYPE rvari_vnam VALUE 'CUST_PO_TYPE',           "Parameter: Customer Purchase Order Type
  lc_p_item_cat TYPE rvari_vnam VALUE 'ITEM_CATEGORY',          "Parameter: Item Category
  lc_p_cnd_grp5 TYPE rvari_vnam VALUE 'CUST_COND_GRP5'.         "Parameter: Customer Condition Group 5

STATICS:
  lr_cst_po_typ TYPE tdt_rg_bsark,                              "Range: Customer Purchase Order Type
  li_leg_sb_typ TYPE ltt_lg_sb_typ.                             "Legacy Subscription Type

IF t180-trtyp  NE chara AND                                     "Not in "Display" mode
   vbap-posnr  IS NOT INITIAL.                                  "Line Item Details

  IF lr_cst_po_typ IS INITIAL AND                               "Range: Customer Purchase Order Type
     li_leg_sb_typ IS INITIAL.                                  "Legacy Subscription Type

*   Fetch Constant Values
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_dev_i0233                             "Development ID
      IMPORTING
        ex_constants = li_cnst_i0233.                           "Constant Values
    LOOP AT li_cnst_i0233 ASSIGNING FIELD-SYMBOL(<lst_cnst_i0233>).
      CASE <lst_cnst_i0233>-param1.
        WHEN lc_p_cust_po.                                      "Parameter: Customer Purchase Order Type
          APPEND INITIAL LINE TO lr_cst_po_typ ASSIGNING FIELD-SYMBOL(<lst_cst_po_typ>).
          <lst_cst_po_typ>-sign   = <lst_cnst_i0233>-sign.
          <lst_cst_po_typ>-option = <lst_cnst_i0233>-opti.
          <lst_cst_po_typ>-low    = <lst_cnst_i0233>-low.
          <lst_cst_po_typ>-high   = <lst_cnst_i0233>-high.

        WHEN lc_p_item_cat.                                     "Parameter: Item Category

          CASE <lst_cnst_i0233>-param2.
            WHEN lc_p_cnd_grp5.                                 "Parameter: Customer Condition Group 5
              APPEND INITIAL LINE TO li_leg_sb_typ ASSIGNING FIELD-SYMBOL(<lst_leg_sb_typ>).
              <lst_leg_sb_typ>-pstyv = <lst_cnst_i0233>-low.    "Item Category
              <lst_leg_sb_typ>-kdkg5 = <lst_cnst_i0233>-high.   "Customer Condition Group 5
            WHEN OTHERS.
*             Do nothing.
          ENDCASE.

        WHEN OTHERS.
*         Do nothing.
      ENDCASE.
    ENDLOOP. " LOOP AT li_cnst_i0233 ASSIGNING FIELD-SYMBOL(<lst_cnst_i0233>).

    SORT li_leg_sb_typ BY pstyv.
  ENDIF. " IF lr_cst_po_typ IS INITIAL

  IF vbak-bsark IN lr_cst_po_typ.                               "Customer Purchase Order Type
*   Determine Legacy Subscription Type (Customer Condition Group 5)
    READ TABLE li_leg_sb_typ ASSIGNING <lst_leg_sb_typ>
         WITH KEY pstyv = vbap-pstyv                            "Item Category
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      vbkd-kdkg5 = <lst_leg_sb_typ>-kdkg5.                      "Customer Condition Group 5
    ENDIF.
  ENDIF.
ENDIF.
