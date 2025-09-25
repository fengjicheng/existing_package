*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_DB_BOM_ZERO_ALLOC_01 (Include)
*               Called from "Routine 904 (RV64A904)"
* PROGRAM DESCRIPTION: Provide 100.00% Discount for DB BOM Component
*                      with 0.00% Allocation
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   10-DEC-2017
* OBJECT ID: E162 - CR#607
* TRANSPORT NUMBER(S): ED2K908513, ED2K910112
*----------------------------------------------------------------------*
TYPES:
  ltt_bom_it TYPE STANDARD TABLE OF sdstpox    INITIAL SIZE 0.  "SD Bill of Material Item (Extended for List Displays)

DATA:
  lv_prc_typ TYPE salv_de_selopt_low,                           "Pricing Type
  lv_zzalloc TYPE rai_percentage_kk,                            "Percentage Allocation
  lv_bom_itm TYPE char30 VALUE '(SAPFV45S)XSTB[]',              "BOM Items / Components
  lv_xvbap_f TYPE char40 VALUE '(SAPMV45A)XVBAP[]',             "Sales Document: Item Data
  lv_xkomv_f TYPE char40 VALUE '(SAPMV45A)XKOMV[]'.             "Pricing Communications-Condition Record

DATA:
  li_const   TYPE zcat_constants,                               "Internal table for Constant Table
  lir_db_bom TYPE rjksd_pstyv_range_tab,                        "Range Table for Item Category
  li_bom_itm TYPE ltt_bom_it,                                   "SD Bill of Material Item (Extended for List Displays)
  li_xvbap_f TYPE va_vbapvb_t,                                  "Sales Document: Item Data
  li_xvbap_b TYPE va_vbapvb_t,                                  "Sales Document: Item Data (BOM)
  li_xkomv_f TYPE va_komv_t.                                    "Pricing Communications-Condition Record

DATA:
  lst_stpo_k TYPE rmxms_stpo_tkey,                              "Technical Key Fields - BOM Item
  lst_stpo_d TYPE stpo.                                         "BOM Item

CONSTANTS:
  lc_param_b TYPE rvari_vnam  VALUE 'BOM_ITEMS',                "ABAP: Name of Variant Variable
  lc_param_p TYPE rvari_vnam  VALUE 'PRICING_TYPE',             "ABAP: Name of Variant Variable
  lc_param_m TYPE rvari_vnam  VALUE 'DB_BOM_HDR_ITM_CAT',       "ABAP: Name of Variant Variable
  lc_del_ind TYPE updkz       VALUE 'D',                        "Update Indicator: Delete
  lc_devid   TYPE zdevid      VALUE 'E075'.                     "Development ID

* Get data from constant table
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid
  IMPORTING
    ex_constants = li_const.
IF li_const[] IS NOT INITIAL.
  LOOP AT li_const ASSIGNING FIELD-SYMBOL(<lst_const>).
    CASE <lst_const>-param1.
      WHEN lc_param_b.                                          "ABAP: Name of Variant Variable (BOM_ITEMS)
        CASE <lst_const>-param2.
          WHEN lc_param_m.                                      "Item Category: Database BOM
            APPEND INITIAL LINE TO lir_db_bom ASSIGNING FIELD-SYMBOL(<lst_db_bom>).
            <lst_db_bom>-sign   = <lst_const>-sign.
            <lst_db_bom>-option = <lst_const>-opti.
            <lst_db_bom>-low    = <lst_const>-low.
            <lst_db_bom>-high   = <lst_const>-high.

          WHEN OTHERS.
*           Nothing to do
        ENDCASE.

      WHEN lc_param_p.                                          "Pricing Type (PRICING_TYPE)
        lv_prc_typ = <lst_const>-low.

      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF. " IF sy-subrc IS INITIAL

IF preisfindungsart NA lv_prc_typ.
  IF xkwert IS INITIAL.
    xkwert = ywert.
  ENDIF.
  RETURN.
ENDIF.

* Sales Document: Item Data
ASSIGN (lv_xvbap_f) TO FIELD-SYMBOL(<li_xvbap>).
IF sy-subrc EQ 0.
  li_xvbap_f = <li_xvbap>.
  DELETE li_xvbap_f WHERE updkz EQ lc_del_ind.
ENDIF.
* Pricing Communications-Condition Record
ASSIGN (lv_xkomv_f) TO FIELD-SYMBOL(<li_xkomv>).
IF sy-subrc EQ 0.
  li_xkomv_f = <li_xkomv>.
ENDIF.

IF li_xvbap_f IS NOT INITIAL AND                                "Sales Document: Item Data
   li_xkomv_f IS NOT INITIAL.                                   "Pricing Communications-Condition Record
* Get Sales Document: Item Data details
  READ TABLE li_xvbap_f ASSIGNING FIELD-SYMBOL(<lst_xvbap_l>)
       WITH KEY posnr = xkomv-kposn.
  IF sy-subrc EQ 0 AND
     <lst_xvbap_l>-uepos IS NOT INITIAL.                        "Check for BOM Line Item (Component)
*   Get the details of the BOM Header
    READ TABLE li_xvbap_f ASSIGNING FIELD-SYMBOL(<lst_xvbap_h>)
         WITH KEY posnr = <lst_xvbap_l>-uepos.
    IF sy-subrc EQ 0 AND
       <lst_xvbap_h>-pstyv IN lir_db_bom.                       "Item Category: Database BOM
*     Fetch BOM Component Details from ABAP Stack
      ASSIGN (lv_bom_itm) TO FIELD-SYMBOL(<li_bom_itm>).
      IF sy-subrc EQ 0.
        li_bom_itm = <li_bom_itm>.
      ENDIF.

      READ TABLE li_bom_itm ASSIGNING FIELD-SYMBOL(<lst_bom_itm>)
           WITH KEY stlty = <lst_xvbap_l>-stlty                 "BOM category
                    stlnr = <lst_xvbap_l>-stlnr                 "Bill of material
                    stlkn = <lst_xvbap_l>-stlkn                 "BOM item node number
                    stpoz = <lst_xvbap_l>-stpoz.                "Internal counter
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING <lst_bom_itm> TO lst_stpo_d.
      ELSE.
        MOVE-CORRESPONDING <lst_xvbap_l> TO lst_stpo_k.         "Technical Key Fields - BOM Item
*       Fetch BOM Item Details
        CALL FUNCTION 'ZQTC_STPO_SINGLE_READ'
          EXPORTING
            im_st_stpo_key    = lst_stpo_k                      "Technical Key Fields - BOM Item
          IMPORTING
            ex_st_stpo_det    = lst_stpo_d                      "BOM Item Details
          EXCEPTIONS
            exc_invalid_input = 1
            OTHERS            = 2.
        IF sy-subrc EQ 0.
          TRY.
              lv_zzalloc = lst_stpo_d-zzalloc.
            CATCH cx_root.
              CLEAR: lv_zzalloc.
          ENDTRY.
        ENDIF.
      ENDIF.
      IF lst_stpo_d IS NOT INITIAL AND
         lv_zzalloc IS INITIAL.                                 "Percentage Allocation
        xkwert      = komp-kzwi1 * -1.                          "100% Discount [Condition value]
        xkomv-kbetr = '1000.00-'.                               "100% Discount [Rate (condition amount or percentage)]
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
