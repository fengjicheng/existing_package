*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_RESTRICT_REPRINT_GR
* PROGRAM DESCRIPTION: Goods Receipt for Reprint Purchase Order
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   2017-10-06
* OBJECT ID: E143 (CR 658, 657, 656)
* TRANSPORT NUMBER(S) ED2K908861
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*

DATA:
  lv_gr_item  TYPE char30     VALUE '(SAPMM07M)XMSEG'.               "Material Document (GR): Item

DATA:
  li_constant TYPE zcat_constants,                                   "Constant Values
  lir_acc_cat TYPE fip_t_knttp_range,                                "Range: Account Assignment Category
  lir_mv_type TYPE fip_t_bwart_range.                                "Range: Movement type (inventory management)

DATA:
  lst_po_item TYPE ekpo_key.                                         "Purchasing Document Items: Key Fields

FIELD-SYMBOLS:
  <lst_gd_rc> TYPE mseg.                                             "Material Document (GR): Item

CONSTANTS:
  lc_dev_e143 TYPE zdevid     VALUE 'E143',                          "Development ID: E143
  lc_prm_aac  TYPE rvari_vnam VALUE 'ACCOUNT_CAT',                   "Parameter: Account Assignment Category
  lc_prm_mvt  TYPE rvari_vnam VALUE 'MOVEMENT_TYPE',                 "Parameter: Movement Type
  lc_prm_rpr  TYPE rvari_vnam VALUE 'REPRINT'.                       "Parameter: Re-Print

* Get Constant Values
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_dev_e143                                       "Development ID: E143
  IMPORTING
    ex_constants = li_constant.                                      "Constant Values
LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lst_constant>).
  CASE <lst_constant>-param1.
    WHEN lc_prm_aac.                                                 "Parameter: Account Assignment Categories
      CASE <lst_constant>-param2.
        WHEN lc_prm_rpr.                                             "Parameter: Reprint
          APPEND INITIAL LINE TO lir_acc_cat ASSIGNING FIELD-SYMBOL(<lst_acc_cat>).
          <lst_acc_cat>-sign   = <lst_constant>-sign.                "ABAP: ID: I/E (include/exclude values)
          <lst_acc_cat>-option = <lst_constant>-opti.                "ABAP: Selection option (EQ/BT/CP/...)
          <lst_acc_cat>-low    = <lst_constant>-low.                 "Lower Value of Selection Condition
          <lst_acc_cat>-high   = <lst_constant>-high.                "Upper Value of Selection Condition
        WHEN OTHERS.
*         Nothing to do
      ENDCASE.

    WHEN lc_prm_mvt.                                                 "Parameter: Movement Types
      CASE <lst_constant>-param2.
        WHEN lc_prm_rpr.                                             "Parameter: Reprint
          APPEND INITIAL LINE TO lir_mv_type ASSIGNING FIELD-SYMBOL(<lst_mv_type>).
          <lst_mv_type>-sign   = <lst_constant>-sign.                "ABAP: ID: I/E (include/exclude values)
          <lst_mv_type>-option = <lst_constant>-opti.                "ABAP: Selection option (EQ/BT/CP/...)
          <lst_mv_type>-low    = <lst_constant>-low.                 "Lower Value of Selection Condition
          <lst_mv_type>-high   = <lst_constant>-high.                "Upper Value of Selection Condition
        WHEN OTHERS.
*         Nothing to do
      ENDCASE.

    WHEN OTHERS.
*     Nothing to do
  ENDCASE.
ENDLOOP.

* Get Material Document (GR): Item
ASSIGN (lv_gr_item) TO <lst_gd_rc>.
IF sy-subrc EQ 0.
  IF <lst_gd_rc>-bwart IN lir_mv_type AND                            "Filter based on Movement Type
     <lst_gd_rc>-ebeln IS NOT INITIAL.                               "Filter for PO Line only
*   Fetch Purchasing Document Item
    SELECT SINGLE ebeln                                              "Purchasing Document Number
                  ebelp                                              "Item Number of Purchasing Document
      FROM ekpo
      INTO lst_po_item
     WHERE ebeln EQ <lst_gd_rc>-ebeln                                "Purchasing Document Number
       AND ebelp EQ <lst_gd_rc>-ebelp                                "Item Number of Purchasing Document
       AND knttp IN lir_acc_cat.                                     "Account Assignment Category
    IF sy-subrc NE 0.
      CLEAR: lst_po_item.
    ENDIF.
  ENDIF.
ENDIF.

IF lst_po_item IS INITIAL.
  sy-subrc = 4.
ELSE.
  sy-subrc = 0.
ENDIF.
