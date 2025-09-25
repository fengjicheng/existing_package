*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BOM_PRICING_01 (Include)
*               Called from "Routine 902 (RV64A902)"
* PROGRAM DESCRIPTION: Calculate Price for BOM Components
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   20-MAY-2017
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K905792
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906514
* REFERENCE NO: CR#549
* DEVELOPER: Writtick Roy (WROY)
* DATE:  05-JUN-2017
* DESCRIPTION: Calculate Price for Database BOM Components
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907135
* REFERENCE NO: CR#564
* DEVELOPER: Writtick Roy (WROY)
* DATE:  06-JUL-2017
* DESCRIPTION: Consider Institutional Price for prorating
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907469
* REFERENCE NO: ERP-3496
* DEVELOPER: Writtick Roy (WROY)
* DATE:  24-JUL-2017
* DESCRIPTION: Check if the Document is being created wrt another one
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908379
* REFERENCE NO: CR#651
* DEVELOPER: Writtick Roy (WROY)
* DATE:  06-SEP-2017
* DESCRIPTION: BOM Allocation when there is no component price
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909134, ED2K909735
* REFERENCE NO: Performance Issues
* DEVELOPER: Writtick Roy (WROY)
* DATE:  16-NOV-2017
* DESCRIPTION: Modify logic to avoid repricing
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908513
* REFERENCE NO: CR#607
* DEVELOPER: Writtick Roy (WROY)
* DATE:  31-OCT-2017
* DESCRIPTION: Database BOM - Use different field for Percentage
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911494
* REFERENCE NO: ERP-7056
* DEVELOPER: Writtick Roy (WROY)
* DATE:  20-Mar-2018
* DESCRIPTION: Additional logic to identify the Last BOM Component
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911494
* REFERENCE NO: ERP-7151
* DEVELOPER: Writtick Roy (WROY)
* DATE:  20-Mar-2018
* DESCRIPTION: Re-trigger allocation logic if BOM Header Price changes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914105
* REFERENCE NO: CR#7816
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 28-Dec-2018
* DESCRIPTION: Corrections in Pricing routine for Doc Type: 'ZSBP'
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K911323
* REFERENCE NO: INC0269098
* DEVELOPER: Randheer Kumar (RKUMAR2)
* DATE:  14-Nov-2019
* DESCRIPTION: Contract to quote creation failed with multiple BOM's
*Reason: Static structure 'LST_PRICES' is not refreshed during multiple
*        quotes creation against single contract.Data doesn't refresh
*        with change in the bom.
*        Fix is applied to refresh the static variables during such cases
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K917154
* REFERENCE NO: ERPM-9191
* DEVELOPER: Goplakrishna K(GKAMMILI)
* DATE:  26-Dec-2019
* DESCRIPTION: During contract creation BOM last item price is not
*              properly caliculating
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K911736
* REFERENCE NO: ERPM-9191/INC0269098 / ERP-7816
* DEVELOPER: NPOLINA
* DATE:  30-Mar-2020
* DESCRIPTION: During Mass order creation BOM last item price is not
*              properly caliculating since prev order details not
*              getting cleared from LI_TKOMP
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K913453
* REFERENCE NO: INC0391209
* DEVELOPER: ARGADEELA
* DATE:  09-20-2021
* DESCRIPTION: Fixed the issue of Renewal note with Incorrect pricing of BOM items
*              when Early Bird Renewal promo code used
*----------------------------------------------------------------------*
INCLUDE zqtcn_arithmetic_operators IF FOUND.

TYPES:
  BEGIN OF lty_const,
    devid    TYPE zdevid,                                       "Development ID
    param1   TYPE rvari_vnam,                                   "Parameter1
    param2   TYPE rvari_vnam,                                   "Parameter2
    srno     TYPE tvarv_numb,                                   "Serial Number
    sign     TYPE tvarv_sign,                                   "Sign
    opti     TYPE tvarv_opti,                                   "Option
    low      TYPE salv_de_selopt_low,                           "Low
    high     TYPE salv_de_selopt_high,                          "High
    activate TYPE zconstactive,                                 "Active/Inactive Indicator
  END OF lty_const,
  ltt_consts TYPE STANDARD TABLE OF lty_const  INITIAL SIZE 0,

* Begin of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
  BEGIN OF lty_inst_p,
    pltyp    TYPE pltyp,                                        "Price List Type
    matnr    TYPE matnr,                                        "Material Number
    inst_prc TYPE kbetr_kond,                                   "Rate (condition amount or percentage) where no scale exists
  END OF lty_inst_p,
  ltt_inst_p TYPE STANDARD TABLE OF lty_inst_p INITIAL SIZE 0,
* End   of ADD:CR#564:WROY:06-JUL-2017:ED2K907135

* Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
  BEGIN OF lty_mat_dt,
    matnr    TYPE matnr,                                        "Material Number
    publtype TYPE ismpubltype,                                  "Publication Type
  END OF lty_mat_dt,
  ltt_mat_dt TYPE STANDARD TABLE OF lty_mat_dt INITIAL SIZE 0,
* End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379

* Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
  BEGIN OF lty_prices,
    hl_items TYPE uepos,                                        "Higher-level item in bill of material structures
    itm_prc  TYPE kbetr,                                        "Total Item Price
    prc_eli  TYPE kzwi3,                                        "Price Excluding Last BOM Item
    last_bi  TYPE posnr_va,                                     "Last BOM Item
    no_comp  TYPE i,                                            "Number of BOM Components
    no_prc   TYPE flag,                                         "Flag: No Price Maintained
*   Begin of ADD:ERP-7056:WROY:20-Mar-2018:ED2K911494
    last_cmp TYPE sdstpox,                                      "Last BOM Component
*   End   of ADD:ERP-7056:WROY:20-Mar-2018:ED2K911494
*   Begin of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
    bom_h_pr TYPE kzwi3,                                        "BOM Header Price
*   End   of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
*   Begin of ADD:ERPM-9191:GKAMMILI: ED2K917154
    last_itm TYPE posnr_va,                                     "Document Last Item
*   End of ADD:ERPM-9191:GKAMMILI: ED2K917154
    vbeln   TYPE vbeln,                       "ED1K911736  NPOLINA ERPM-9191
    vkorg   type vkorg,
  END OF lty_prices,
  ltt_bom_it TYPE STANDARD TABLE OF sdstpox    INITIAL SIZE 0.
* End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134

DATA:
* Begin of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
  lv_prc_typ TYPE salv_de_selopt_low,                           "Pricing Type
* End   of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
* Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
  lv_bom_itm TYPE char30 VALUE '(SAPFV45S)XSTB[]',              "BOM Items / Components
* End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
  lv_xvbap_f TYPE char40 VALUE '(SAPMV45A)XVBAP[]',             "Sales Document: Item Data
  lv_xkomv_f TYPE char40 VALUE '(SAPMV45A)XKOMV[]',             "Pricing Communications-Condition Record
*** BOC: CR#7816  KKRAVURI20181228  ED2K914105
  lv_vbak    TYPE string VALUE '(SAPMV45A)VBAK',
*** EOC: CR#7816  KKRAVURI20181228  ED2K914105
*Begin of Add by ARGADEELA INC0391209:ED1K913453:09/20/2021
  lv_tkomp_f  TYPE string VALUE '(SAPMV45A)TKOMP[]'.
*End of Add by ARGADEELA INC0391209:ED1K913453:09/20/2021

DATA:
* Begin of DEL:Performance:WROY:16-Nov-2017:ED2K909134
* li_const   TYPE ltt_consts,                                   "Internal table for Constant Table
* Begin of DEL:Performance:WROY:16-Nov-2017:ED2K909134
* Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
  li_const    TYPE zcat_constants,                               "Internal table for Constant Table
* End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
  lir_dc_inv  TYPE saco_vbtyp_ranges_tab,                        "SD document category
* Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
  lir_pb_typ  TYPE rjksd_publtype_range_tab,                     "Range Table for Publication Type
* End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
  lir_db_bom  TYPE rjksd_pstyv_range_tab,                        "Range Table for Item Category
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
* Begin of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
  li_prc_sel  TYPE ltt_inst_p,                                   "Institutional Price
* End   of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
* Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
  li_mat_sel  TYPE ltt_mat_dt,                                   "Material Details
* End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
* Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
  li_bom_itm  TYPE ltt_bom_it,
* End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
* Begin of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
  li_tkomp    TYPE  va_komp_t,                                   "Communication Item for Pricing
* End   of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
  li_xvbap_f  TYPE va_vbapvb_t,                                  "Sales Document: Item Data
  li_xvbap_b  TYPE va_vbapvb_t,                                  "Sales Document: Item Data (BOM)
  li_xkomv_f  TYPE va_komv_t,                                    "Pricing Communications-Condition Record
*** BOC: CR#7816  KKRAVURI20181228  ED2K914105
  lir_doc_typ TYPE RANGE OF auart,
*** EOC: CR#7816  KKRAVURI20181228  ED2K914105
*   Begin of ADD:ERPM-9191:GKAMMILI: ED2K917154
  lir_multi_bom TYPE RANGE OF auart,
  lir_xvbap_f    TYPE vbapvb,
*   End of ADD:ERPM-9191:GKAMMILI: ED2K917154
*Begin of Add by ARGADEELA INC0391209:ED1K913453:09/20/2021
  li_tkomp_f  TYPE va_komp_t.
*End of Add by ARGADEELA INC0391209:ED1K913453:09/20/2021
* Begin of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
STATICS:
  li_inst_p  TYPE ltt_inst_p,                                   "Institutional Price
* End   of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
* Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
  li_mat_det TYPE ltt_mat_dt,                                   "Material Details
* End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
* Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
  lst_prices TYPE lty_prices.
* End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134

* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
DATA:
  lst_stpo_k TYPE rmxms_stpo_tkey,                              "Technical Key Fields - BOM Item
  lst_stpo_d TYPE stpo.                                         "BOM Item
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514

DATA:
  lv_itm_prc  TYPE kbetr,                                        "Total Item Price
  lv_cnd_typ  TYPE kschl,                                        "Condition Type
* Begin of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
  lv_cst_grp  TYPE kdgrp,                                        "Customer Group
* End   of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
* Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
  lv_no_prc   TYPE flag,                                         "Flag: No Price Maintained
  lv_last_bi  TYPE posnr_va,                                     "Last BOM Item
  lv_no_comp  TYPE i,                                            "Number of BOM Components
  lv_prc_eli  TYPE kzwi3,                                        "Price Excluding Last BOM Item
  lv_prc_prv  TYPE kzwi3,                                        "Price of the Previous Item
* End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
* Begin of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
  lv_bom_hpr  TYPE kzwi3,                                        "BOM Header Price
* End   of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
* Begin of ADD:CR#607:WROY:04-Jan-2018:ED2K910112
  lv_zzalloc  TYPE rai_percentage_kk,                            "Percentage Allocation
* End   of ADD:CR#607:WROY:04-Jan-2018:ED2K910112
* Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
  lv_lst_cmp  TYPE flag,                                         "Indicator: Last BOM Component
  lv_lst_idx  TYPE i,                                            "Index of last Line
* End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
  lv_alloc_r  TYPE p DECIMALS 6,                                 "Allocated Ratio
*** BOC: CR#7816  KKRAVURI20181228  ED2K914105
  lst_vbak    TYPE vbak,
  lv_doc_type TYPE auart.
*** EOC: CR#7816  KKRAVURI20181228  ED2K914105

CONSTANTS:
  lc_param_b   TYPE rvari_vnam  VALUE 'BOM_ITEMS',                "ABAP: Name of Variant Variable
  lc_param_c   TYPE rvari_vnam  VALUE 'COND_TYPE',                "ABAP: Name of Variant Variable
  lc_param_d   TYPE rvari_vnam  VALUE 'DOC_CATEGORY',             "ABAP: Name of Variant Variable
* Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
  lc_param_t   TYPE rvari_vnam  VALUE 'PUBLICATION_TYPE',         "ABAP: Name of Variant Variable
* End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
  lc_param_i   TYPE rvari_vnam  VALUE 'INVOICE',                  "ABAP: Name of Variant Variable
* Begin of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
  lc_param_p   TYPE rvari_vnam  VALUE 'PRICING_TYPE',             "ABAP: Name of Variant Variable
* End   of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
* Begin of ADD:CR#564:WROY:05-JUN-2017:ED2K906514
  lc_param_m   TYPE rvari_vnam  VALUE 'DB_BOM_HDR_ITM_CAT',       "ABAP: Name of Variant Variable
* End   of ADD:CR#564:WROY:05-JUN-2017:ED2K906514
* Begin of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
  lc_param_g   TYPE rvari_vnam  VALUE 'CUST_GROUP',               "ABAP: Name of Variant Variable
* End   of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
  lc_del_ind   TYPE updkz       VALUE 'D',                        "Update Indicator: Delete
  lc_devid     TYPE zdevid      VALUE 'E075',                     "Development ID
*** BOC: CR#7816  KKRAVURI20181228  ED2K914105
  lc_p1_doctyp TYPE rvari_vnam  VALUE 'DOCUMENT_TYPE',
  lc_p2_auart  TYPE rvari_vnam  VALUE 'AUART',
*** EOC: CR#7816  KKRAVURI20181228  ED2K914105
*   Begin of ADD:ERPM-9191:GKAMMILI: ED2K917154
  lc_multi_bom TYPE rvari_vnam  VALUE 'MULTI_BOM'.
*   End of ADD:ERPM-9191:GKAMMILI: ED2K917154
* Get data from constant table
* Begin of DEL:Performance:WROY:16-Nov-2017:ED2K909134
*SELECT devid                                                   "Development ID
*       param1                                                  "ABAP: Name of Variant Variable
*       param2                                                  "ABAP: Name of Variant Variable
*       srno                                                    "Current selection number
*       sign                                                    "ABAP: ID: I/E (include/exclude values)
*       opti                                                    "ABAP: Selection option (EQ/BT/CP/...)
*       low                                                     "Lower Value of Selection Condition
*       high                                                    "Upper Value of Selection Condition
*       activate                                                "Activation indicator for constant
*  FROM zcaconstant                                             "Wiley Application Constant Table
*  INTO TABLE li_const
* WHERE devid    EQ lc_devid                                    "Development ID
*   AND activate EQ abap_true.                                  "Only active record
*IF sy-subrc IS INITIAL.
*  SORT li_const BY devid param1 param2 srno.
* End   of DEL:Performance:WROY:16-Nov-2017:ED2K909134
* Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid
  IMPORTING
    ex_constants = li_const.
IF li_const[] IS NOT INITIAL.
* End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
  LOOP AT li_const ASSIGNING FIELD-SYMBOL(<lst_const>).
    CASE <lst_const>-param1.
      WHEN lc_param_b.                                          "ABAP: Name of Variant Variable (BOM_ITEMS)
        CASE <lst_const>-param2.
          WHEN lc_param_c.                                      "Condition Type: List Price (COND_TYPE)
            lv_cnd_typ = <lst_const>-low.

*         Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
          WHEN lc_param_m.                                      "Item Category: Database BOM
            APPEND INITIAL LINE TO lir_db_bom ASSIGNING FIELD-SYMBOL(<lst_db_bom>).
            <lst_db_bom>-sign   = <lst_const>-sign.
            <lst_db_bom>-option = <lst_const>-opti.
            <lst_db_bom>-low    = <lst_const>-low.
            <lst_db_bom>-high   = <lst_const>-high.
*         End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514

*         Begin of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
          WHEN lc_param_g.                                      "Customer Group (CUST_GROUP)
            lv_cst_grp = <lst_const>-low.
*         End   of ADD:CR#564:WROY:06-JUL-2017:ED2K907135

*         Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
          WHEN lc_param_t.                                      "Publication Type (PUBLICATION_TYPE)
            APPEND INITIAL LINE TO lir_pb_typ ASSIGNING FIELD-SYMBOL(<lst_pb_typ>).
            <lst_pb_typ>-sign   = <lst_const>-sign.
            <lst_pb_typ>-option = <lst_const>-opti.
            <lst_pb_typ>-low    = <lst_const>-low.
            <lst_pb_typ>-high   = <lst_const>-high.
*         End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379

          WHEN OTHERS.
*           Nothing to do
        ENDCASE.

      WHEN lc_param_d.                                          "SD document category (DOC_CATEGORY)
        CASE <lst_const>-param2.
          WHEN lc_param_i.                                      "Invoice (INVOICE)
            APPEND INITIAL LINE TO lir_dc_inv ASSIGNING FIELD-SYMBOL(<lst_dc_inv>).
            <lst_dc_inv>-sign   = <lst_const>-sign.
            <lst_dc_inv>-option = <lst_const>-opti.
            <lst_dc_inv>-low    = <lst_const>-low.
            <lst_dc_inv>-high   = <lst_const>-high.

          WHEN OTHERS.
*           Nothing to do
        ENDCASE.

*     Begin of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
      WHEN lc_param_p.                                          "Pricing Type (PRICING_TYPE)
        lv_prc_typ = <lst_const>-low.
*     End   of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469

*** BOC: CR#7816  KKRAVURI20181228  ED2K914105
      WHEN lc_p1_doctyp.
        APPEND INITIAL LINE TO lir_doc_typ ASSIGNING FIELD-SYMBOL(<lst_doc_typ>).
        <lst_doc_typ>-sign   = <lst_const>-sign.
        <lst_doc_typ>-option = <lst_const>-opti.
        <lst_doc_typ>-low    = <lst_const>-low.
        <lst_doc_typ>-high   = <lst_const>-high.
*** EOC: CR#7816  KKRAVURI20181228  ED2K914105
*   Begin of ADD:ERPM-9191:GKAMMILI: ED2K917154
      WHEN  lc_multi_bom.
        APPEND INITIAL LINE TO lir_multi_bom ASSIGNING FIELD-SYMBOL(<lst_multi_bom>).
        <lst_multi_bom>-sign   = <lst_const>-sign.
        <lst_multi_bom>-option = <lst_const>-opti.
        <lst_multi_bom>-low    = <lst_const>-low.
        <lst_multi_bom>-high   = <lst_const>-high.
*   End of ADD:ERPM-9191:GKAMMILI: ED2K917154
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF. " IF sy-subrc IS INITIAL

* For Billing Document, Copy the price from old / reference value
* Begin of DEL:ERP-3496:WROY:24-JUL-2017:ED2K907469
*IF komk-vbtyp IN lir_dc_inv.
* End   of DEL:ERP-3496:WROY:24-JUL-2017:ED2K907469
* Begin of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
IF preisfindungsart NA lv_prc_typ.
* End   of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
* Begin of DEL:ERP-2435:WROY:27-JUN-2017:ED2K906957
* xkwert = ywert.
* End   of DEL:ERP-2435:WROY:27-JUN-2017:ED2K906957
* Begin of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
  IF xkwert IS INITIAL.
    xkwert = ywert.
  ENDIF.
* End   of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
  RETURN.
ENDIF.

* Sales Document: Item Data
ASSIGN (lv_xvbap_f) TO FIELD-SYMBOL(<li_xvbap>).
IF sy-subrc EQ 0.
  li_xvbap_f = <li_xvbap>.
  DELETE li_xvbap_f WHERE updkz EQ lc_del_ind.
ENDIF.

*** BOC: CR#7816  KKRAVURI20181228  ED2K914105
* Sales Document: Header Data
ASSIGN (lv_vbak) TO FIELD-SYMBOL(<ls_vbak_f>).
IF sy-subrc EQ 0.
  lst_vbak = <ls_vbak_f>.
  lv_doc_type = lst_vbak-auart.
ENDIF.
*** EOC: CR#7816  KKRAVURI20181228  ED2K914105

* Pricing Communications-Condition Record
ASSIGN (lv_xkomv_f) TO FIELD-SYMBOL(<li_xkomv>).
IF sy-subrc EQ 0.
  li_xkomv_f = <li_xkomv>.
ENDIF.
*Begin of Add by ARGADEELA INC0391209:ED1K913453:09/20/2021
ASSIGN (lv_tkomp_f) TO FIELD-SYMBOL(<li_tkomp>).
IF sy-subrc EQ 0.
  li_tkomp_f = <li_tkomp>.
ENDIF.
*End of Add by ARGADEELA INC0391209:ED1K913453:09/20/2021
IF li_xvbap_f IS NOT INITIAL AND                                "Sales Document: Item Data
   li_xkomv_f IS NOT INITIAL.                                   "Pricing Communications-Condition Record
* Get Sales Document: Item Data details
  READ TABLE li_xvbap_f ASSIGNING FIELD-SYMBOL(<lst_xvbap_l>)
       WITH KEY posnr = xkomv-kposn.
  IF sy-subrc EQ 0 AND
     <lst_xvbap_l>-uepos IS NOT INITIAL.                        "Check for BOM Line Item (Component)
*   Begin of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
*   Retrieve Global Attributes during Complete Pricing
*   [The Internal Table TKOMP will be populated from Fumc Module PRICING_COMPLETE]
*Begin of Change by ARGADEELA INC0391209:ED1K913453:09/20/2021
* The below FM 'ZQTC_PRICING_COMPLETE_GET' is commented as TKOMP will be accessed with (SAPMV45A)TKOMP[]
*    CALL FUNCTION 'ZQTC_PRICING_COMPLETE_GET'  " Commented by ARGADEELA
*      EXPORTING
*        im_refresh = abap_true                                  "Refresh / Clear Global Attributes
*      IMPORTING
*        ex_tkomp   = li_tkomp.                                  "Communication Item for Pricing
*   Determine BOM Header Price
    IF li_tkomp_f[] IS NOT INITIAL.
      li_tkomp[] = li_tkomp_f.
    ENDIF.
*End of Chagne by ARGADEELA INC0391209:ED1K913453:09/20/2021
    CLEAR: lv_bom_hpr.
***BOC INC0269098 / ERP-7816 ED1K911692 RKUMAR2
    "In cretain cases like VA25, multiple BOM scenarios is fetching old values from TOMP.
    "This is cleared off by checking BOM headers.
    IF li_tkomp[] IS NOT INITIAL AND
       <LST_XVBAP_L> IS ASSIGNED and
      <LST_XVBAP_L>-UEPOS is NOT INITIAL.
      "GEt the BOM header material from the processing document
       READ TABLE li_xvbap_f INTO lir_xvbap_f WITH KEY posnr = <lst_xvbap_l>-uepos.
       IF sy-subrc IS INITIAL.
         "Get header material from tkomp
         READ TABLE li_tkomp ASSIGNING FIELD-SYMBOL(<lst_tkomp_l>)
              WITH KEY kposn = <lst_xvbap_l>-uepos.
         IF sy-subrc EQ 0.
         "chck if the BOM header matches with buffer fetched from TOMP
         IF lir_xvbap_f-matnr ne <LST_TKOMP_L>-MATNR
              OR lst_vbak-vbeln  NE lst_prices-vbeln     "NPOLINA ED1K911736 ERPM-9191
*              OR lst_vbak-vkorg NE lst_prices-vkorg     "ED1K911776
              OR ( lst_vbak-vbeln IS INITIAL AND  lst_prices-vbeln IS INITIAL ). "NPOLINA ED1K911776 ERPM-9191
           "clear the data fetched from buffer if it doesn't match
            FREE: "li_tkomp, " Commented by ARGADEELA INC0391209:ED1K913453:09/20/2021
                  lv_bom_hpr,
                  lir_xvbap_f.
         ENDIF.
         ENDIF.
       ENDIF.
    ENDIF.
***EOC INC0269098 / ERP-7816 ED1K911692 RKUMAR2
    IF li_tkomp IS NOT INITIAL.
      READ TABLE li_tkomp ASSIGNING FIELD-SYMBOL(<lst_tkomp_h>)
           WITH KEY kposn = <lst_xvbap_l>-uepos.
      IF sy-subrc EQ 0.
        lv_bom_hpr = <lst_tkomp_h>-kzwi3.
      ENDIF.
    ELSE.
*** BOC: CR#7816  KKRAVURI20181228  ED2K914105
* Below READ statement is commented to fix BOM pricing issues in Doc Type: 'ZSBP'
*      READ TABLE li_xvbap_f ASSIGNING FIELD-SYMBOL(<lst_xvbap_h>)
*             WITH KEY posnr = <lst_xvbap_l>-uepos.
*      IF sy-subrc EQ 0.
*        lv_bom_hpr = <lst_xvbap_h>-kzwi3.
*      ENDIF.
      IF lir_doc_typ[] IS NOT INITIAL AND
         lv_doc_type IN lir_doc_typ[].
        READ TABLE li_xkomv_f ASSIGNING FIELD-SYMBOL(<lst_xkomv_f>)
             WITH KEY kposn = <lst_xvbap_l>-uepos
                      kschl = lv_cnd_typ.
        IF sy-subrc = 0.
          lv_bom_hpr = <lst_xkomv_f>-kwert.
        ENDIF.
      ELSE.
        READ TABLE li_xvbap_f ASSIGNING FIELD-SYMBOL(<lst_xvbap_h>)
             WITH KEY posnr = <lst_xvbap_l>-uepos.
        IF sy-subrc EQ 0.
          lv_bom_hpr = <lst_xvbap_h>-kzwi3.
        ENDIF.
      ENDIF.
*** EOC: CR#7816  KKRAVURI20181228  ED2K914105
    ENDIF.

*   End   of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
*   Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134

    IF lst_prices-hl_items IS INITIAL.
      lst_prices-hl_items = <lst_xvbap_l>-uepos.
*     Begin of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
      lst_prices-bom_h_pr = lv_bom_hpr.
*     End   of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494

    ELSEIF lst_prices-hl_items NE <lst_xvbap_l>-uepos.
      CLEAR: lst_prices.
      lst_prices-hl_items = <lst_xvbap_l>-uepos.
*   Begin of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
      lst_prices-bom_h_pr = lv_bom_hpr.

    ELSEIF lst_prices-bom_h_pr NE lv_bom_hpr.
      CLEAR: lst_prices.
      lst_prices-hl_items = <lst_xvbap_l>-uepos.
      lst_prices-bom_h_pr = lv_bom_hpr.
*   End   of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
*   Begin of ADD:ERPM-9191:GKAMMILI: ED2K917154
*    Clearing the static structure lst_prices for every new order
    ELSEIF lst_prices-last_itm GE <lst_xvbap_l>-posnr.
      " AND lv_doc_type IN lir_multi_bom.
      CLEAR lst_prices.
      lst_prices-hl_items = <lst_xvbap_l>-uepos.
      lst_prices-bom_h_pr = lv_bom_hpr.
*   End of ADD:ERPM-9191:GKAMMILI: ED2K917154
*   Begin of Comment:ERPM-9191:GKAMMILI: ED2K917154
**   Begin of INC0269098 change, RKUMAR2: ED1K911323
*    ELSEIF <lst_xvbap_l>-matnr NE lst_prices-last_cmp-idnrk.
*      "Check if there's any change in the BOM header, pricing data must reset
*
*      IF <lst_xvbap_l>-uepos IS NOT INITIAL.
*        "get respective BOM header
*        READ TABLE li_xvbap_f INTO DATA(lv_mat1) WITH KEY posnr = <lst_xvbap_l>-uepos.
*        IF sy-subrc IS NOT INITIAL.
*          "not sure if such situation can happen. Fix must be applied accordingly.
*        ENDIF.
*      ENDIF.
*
*      IF lst_prices-last_cmp-idnrk IS NOT INITIAL.
*        "first check if the pricing is carried for same product or BOM line of not
*        READ TABLE li_xvbap_f INTO DATA(lv_mat2) WITH KEY matnr = lst_prices-last_cmp-idnrk.
*        IF sy-subrc IS INITIAL.
*          "get respective BOM header
*          READ TABLE li_xvbap_f INTO DATA(lv_mat3) WITH KEY posnr = lv_mat2-uepos.
*          IF sy-subrc IS INITIAL.
*            "check if bom header matches for both the products
*            IF lv_mat1-matnr EQ lv_mat3-matnr.
*              "this should be case where the same BOM is processed and nothing to refresh
*            ELSE.
*              "should be change in the document or BOM, clear the buffer
*              CLEAR: lst_prices.
*              lst_prices-hl_items = <lst_xvbap_l>-uepos.
*              lst_prices-bom_h_pr = lv_bom_hpr.
*            ENDIF.
*          ELSE.
*            "not sure if it can occur, need to validate the scenario
*          ENDIF.
*        ELSE.
*          "should be change in the document or BOM, clear the buffer
*          CLEAR: lst_prices.
*          lst_prices-hl_items = <lst_xvbap_l>-uepos.
*          lst_prices-bom_h_pr = lv_bom_hpr.
*        ENDIF.
*      ENDIF.
*      CLEAR: lv_mat1, lv_mat2, lv_mat3.
**   End of INC0269098 change, RKUMAR2: ED1K911323
*   End of Comment:ERPM-9191:GKAMMILI: ED2K917154
    ENDIF.
*   Begin of ADD:ERPM-9191:GKAMMILI: ED2K917154
    lst_prices-last_itm = <lst_xvbap_l>-posnr.
*   End of ADD:ERPM-9191:GKAMMILI: ED2K917154
    lst_prices-vbeln = lst_vbak-vbeln.                "NPOLINA   ED1K911736 ERPM-9191
*    lst_prices-vkorg = lst_vbak-vkorg.                "NPOLINA   ED1K911776 ERPM-9191
*   Fetch BOM Component Details from ABAP Stack
    ASSIGN (lv_bom_itm) TO FIELD-SYMBOL(<li_bom_itm>).
    IF sy-subrc EQ 0.
      li_bom_itm = <li_bom_itm>.
*     Identify the details of last BOM Component
      lv_lst_idx = lines( li_bom_itm ).
      READ TABLE li_bom_itm INTO DATA(lst_last_bom_cmp) INDEX lv_lst_idx.
      IF sy-subrc EQ 0.
        IF lst_last_bom_cmp-stlty EQ <lst_xvbap_l>-stlty AND    "BOM category
           lst_last_bom_cmp-stlnr EQ <lst_xvbap_l>-stlnr AND    "Bill of material
           lst_last_bom_cmp-stlkn EQ <lst_xvbap_l>-stlkn AND    "BOM item node number
           lst_last_bom_cmp-stpoz EQ <lst_xvbap_l>-stpoz.       "Internal counter
*         Determine the Last BOM Item: In order to avoid the Rounding issue,
*         the Amount of the very last BOM Item has to be adjusted
          lv_lst_cmp = abap_true.
        ENDIF.
      ENDIF.
    ENDIF.
*   End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134

*   Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
*   Get the details of the BOM Header
    READ TABLE li_xvbap_f ASSIGNING <lst_xvbap_h>
         WITH KEY posnr = <lst_xvbap_l>-uepos.
    IF sy-subrc EQ 0 AND
       <lst_xvbap_h>-pstyv IN lir_db_bom.                       "Item Category: Database BOM
*     Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
      READ TABLE li_bom_itm ASSIGNING FIELD-SYMBOL(<lst_bom_itm>)
           WITH KEY stlty = <lst_xvbap_l>-stlty                 "BOM category
                    stlnr = <lst_xvbap_l>-stlnr                 "Bill of material
                    stlkn = <lst_xvbap_l>-stlkn                 "BOM item node number
                    stpoz = <lst_xvbap_l>-stpoz.                "Internal counter
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING <lst_bom_itm> TO lst_stpo_d.
      ELSE.
*     End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
        MOVE-CORRESPONDING <lst_xvbap_l> TO lst_stpo_k.         "Technical Key Fields - BOM Item
*       Fetch BOM Item Details
        CALL FUNCTION 'ZQTC_STPO_SINGLE_READ'
          EXPORTING
            im_st_stpo_key    = lst_stpo_k                      "Technical Key Fields - BOM Item
          IMPORTING
            ex_st_stpo_det    = lst_stpo_d                      "BOM Item Details
*           Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
            ex_last_bom_comp  = lv_lst_cmp                      "Indicator: Last BOM Component
*           End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
          EXCEPTIONS
            exc_invalid_input = 1
            OTHERS            = 2.
        IF sy-subrc EQ 0.
*     Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
*         Nothing to do
        ENDIF.
      ENDIF.
      IF lst_stpo_d IS NOT INITIAL.
        IF lv_lst_cmp IS INITIAL.                               "Indicator: Last BOM Component
*     End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
*         Begin of ADD:CR#607:WROY:04-Jan-2018:ED2K910112
          TRY.
              lv_zzalloc = lst_stpo_d-zzalloc.                  "Percentage Allocation
            CATCH cx_root.
              CLEAR: lv_zzalloc.
          ENDTRY.
*         End   of ADD:CR#607:WROY:04-Jan-2018:ED2K910112
*         Calculate Allocated Amount
          CALL FUNCTION 'ZQTC_ARITHMETIC_OPERATIONS'
            EXPORTING
*             Begin of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
              im_v_operand1  = lst_prices-bom_h_pr              "BOM Header Price
*             End   of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
*             Begin of DEL:ERP-7151:WROY:20-Mar-2018:ED2K911494
*             im_v_operand1  = <lst_xvbap_h>-kzwi3              "BOM Header Price
*             End   of DEL:ERP-7151:WROY:20-Mar-2018:ED2K911494
*             Begin of DEL:CR#607:WROY:31-Oct-2017:ED2K908513
*             im_v_operand2  = lst_stpo_d-ausch                 "Component scrap in percent
*             End   of DEL:CR#607:WROY:31-Oct-2017:ED2K908513
*             Begin of ADD:CR#607:WROY:31-Oct-2017:ED2K908513
              im_v_operand2  = lv_zzalloc                       "Percentage Allocation
*             End   of ADD:CR#607:WROY:31-Oct-2017:ED2K908513
              im_v_operation = c_opr_prc                        "Operand: Percentage
            IMPORTING
              ex_v_result    = xkwert.                          "Current Line Item Value
*       Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
          lst_prices-prc_eli = lst_prices-prc_eli + xkwert.     "Price Excluding Last BOM Item
        ELSE.
          lv_prc_eli = lst_prices-prc_eli.                      "Total Price Excluding Last Item
*         Current Line Item Value = BOM Header Price - Total Price Excluding Last Item
*         Begin of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
          xkwert = lst_prices-bom_h_pr - lv_prc_eli.            "Current Line Item Value
*         End   of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
*         Begin of DEL:ERP-7151:WROY:20-Mar-2018:ED2K911494
*         xkwert = <lst_xvbap_h>-kzwi3 - lv_prc_eli.            "Current Line Item Value
*         End   of DEL:ERP-7151:WROY:20-Mar-2018:ED2K911494
          CLEAR: lst_prices-prc_eli.
        ENDIF.
*       End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
      ENDIF.
      RETURN.
    ENDIF.
*   End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514

*   Get the Price of the BOM Component
*   Begin of DEL:ERP-3496:WROY:24-JUL-2017:ED2K907469
*   READ TABLE li_xkomv_f ASSIGNING FIELD-SYMBOL(<lst_xkomv_l>)
*        WITH KEY kposn = <lst_xvbap_l>-posnr
*                 kschl = lv_cnd_typ.
*   IF sy-subrc EQ 0.
*   End   of DEL:ERP-3496:WROY:24-JUL-2017:ED2K907469
*   Begin of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
    IF li_xvbap_f[] IS NOT INITIAL.
*   End   of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
*     Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
      IF lst_prices-itm_prc IS INITIAL.                         "Total Item Price
        IF li_bom_itm[] IS INITIAL.
*     End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
*         Identify the BOM Line Items (Components) using Higher-level item in BOM structure
          li_xvbap_b[] = li_xvbap_f[].
          DELETE li_xvbap_b WHERE uepos NE <lst_xvbap_l>-uepos.

*         Begin of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
          LOOP AT li_xvbap_b ASSIGNING FIELD-SYMBOL(<lst_xvbap_s>).
            READ TABLE li_inst_p TRANSPORTING NO FIELDS
                 WITH KEY pltyp = komk-pltyp
                          matnr = <lst_xvbap_s>-matnr
                 BINARY SEARCH.
            IF sy-subrc NE 0.
              APPEND INITIAL LINE TO li_prc_sel ASSIGNING FIELD-SYMBOL(<lst_prc_sel>).
              <lst_prc_sel>-pltyp = komk-pltyp.
              <lst_prc_sel>-matnr = <lst_xvbap_s>-matnr.
            ENDIF.

*           Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
            READ TABLE li_mat_det TRANSPORTING NO FIELDS
                 WITH KEY matnr = <lst_xvbap_s>-matnr
                 BINARY SEARCH.
            IF sy-subrc NE 0.
              APPEND INITIAL LINE TO li_mat_sel ASSIGNING FIELD-SYMBOL(<lst_mat_sel>).
              <lst_mat_sel>-matnr = <lst_xvbap_s>-matnr.
            ENDIF.
*           End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
          ENDLOOP.
*     Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
        ELSE.
          LOOP AT li_bom_itm ASSIGNING <lst_bom_itm>.
            READ TABLE li_inst_p TRANSPORTING NO FIELDS
                 WITH KEY pltyp = komk-pltyp
                          matnr = <lst_bom_itm>-idnrk
                 BINARY SEARCH.
            IF sy-subrc NE 0.
              APPEND INITIAL LINE TO li_prc_sel ASSIGNING <lst_prc_sel>.
              <lst_prc_sel>-pltyp = komk-pltyp.
              <lst_prc_sel>-matnr = <lst_bom_itm>-idnrk.
            ENDIF.

            READ TABLE li_mat_det TRANSPORTING NO FIELDS
                 WITH KEY matnr = <lst_bom_itm>-idnrk
                 BINARY SEARCH.
            IF sy-subrc NE 0.
              APPEND INITIAL LINE TO li_mat_sel ASSIGNING <lst_mat_sel>.
              <lst_mat_sel>-matnr = <lst_bom_itm>-idnrk.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
*     End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134

      IF li_prc_sel IS NOT INITIAL.
        SELECT a~pltyp                                          "Price List Type
               a~matnr                                          "Material Number
               k~kbetr                                          "Rate (condition amount or percentage) where no scale exists
          FROM a913 AS a INNER JOIN
               konp AS k
            ON a~knumh EQ k~knumh
     APPENDING TABLE li_inst_p
           FOR ALL ENTRIES IN li_prc_sel
         WHERE a~kappl EQ kappl_vertrieb
           AND a~kschl EQ lv_cnd_typ
           AND a~pltyp EQ li_prc_sel-pltyp
           AND a~kdgrp EQ lv_cst_grp
           AND a~matnr EQ li_prc_sel-matnr
           AND a~kfrst EQ space
           AND a~datbi GE komk-prsdt
           AND a~datab LE komk-prsdt.
        IF sy-subrc EQ 0.
          SORT li_inst_p BY pltyp matnr.
        ENDIF.
      ENDIF.
*     End   of ADD:CR#564:WROY:06-JUL-2017:ED2K907135

*     Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
      IF li_mat_sel IS NOT INITIAL.
        SELECT matnr                                            "Material Number
               ismpubltype                                      "Publication Type
          FROM mara
     APPENDING TABLE li_mat_det
           FOR ALL ENTRIES IN li_mat_sel
         WHERE matnr EQ li_mat_sel-matnr.
        IF sy-subrc EQ 0.
          SORT li_mat_det BY matnr.
        ENDIF.
      ENDIF.
*     End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379

      CLEAR: lv_itm_prc,
*            Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
             lv_no_prc,
             lv_last_bi,
             lv_prc_eli,
             lv_prc_prv.
*            End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
*     Go through all BOM Line Items (Components)
*     Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
      IF lst_prices-itm_prc IS INITIAL.                         "Total Item Price
        IF li_bom_itm[] IS INITIAL.
*     End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
          LOOP AT li_xvbap_b ASSIGNING FIELD-SYMBOL(<lst_xvbap_b>).
*           Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
*           Exclude Publication Types: Opt-In (OI), Controlled Circulation (CC)
            READ TABLE li_mat_det ASSIGNING FIELD-SYMBOL(<lst_mat_det>)
                 WITH KEY matnr = <lst_xvbap_b>-matnr
                 BINARY SEARCH.
            IF sy-subrc EQ 0 AND
               <lst_mat_det>-publtype NOT IN lir_pb_typ.
              CONTINUE.
            ENDIF.

*           In case of missing Price, the BOM Header Price has to be pro-rated
*           equally
            lv_no_comp = lv_no_comp + 1.                        "Number of BOM Components
*           Determine the Last BOM Item: In order to avoid the Rounding issue,
*           the Amount of the very last BOM Item has to be adjusted
            lv_last_bi = <lst_xvbap_b>-posnr.                   "Last BOM Item
            lv_prc_eli = lv_prc_eli + lv_prc_prv.               "Total Price Excluding Last Item
            lv_prc_prv = <lst_xvbap_b>-kzwi3.                   "Previous Item Price
*           End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379

*           Identify Condition Type value of the BOM Line Item (Component)
*           Begin of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
            READ TABLE li_inst_p ASSIGNING FIELD-SYMBOL(<lst_inst_p>)
                 WITH KEY pltyp = komk-pltyp
                          matnr = <lst_xvbap_b>-matnr
                 BINARY SEARCH.
            IF sy-subrc EQ 0 AND
*              Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
               <lst_inst_p>-inst_prc IS NOT INITIAL.
*              End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
*             Sum up Condition Type values of all the BOM Line Items (Components)
              lv_itm_prc = lv_itm_prc + <lst_inst_p>-inst_prc.
*           Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
            ELSE.
*             In case of missing Price, the BOM Header Price has to be
*             pro-rated equally
              lv_no_prc  = abap_true.                           "Flag: No Price Maintained
*           End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
            ENDIF.
*           End   of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
*           Begin of DEL:CR#564:WROY:06-JUL-2017:ED2K907135
*           READ TABLE li_xkomv_f ASSIGNING FIELD-SYMBOL(<lst_xkomv_f>)
*                WITH KEY kposn = <lst_xvbap_b>-posnr
*                         kschl = lv_cnd_typ.
*           IF sy-subrc EQ 0.
**            Sum up Condition Type values of all the BOM Line Items (Components)
*             lv_itm_prc = lv_itm_prc + <lst_xkomv_f>-kbetr.
*           ENDIF.
*           End   of DEL:CR#564:WROY:06-JUL-2017:ED2K907135
          ENDLOOP.
*     Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
          lst_prices-last_bi = lv_last_bi.
        ELSE.
          LOOP AT li_bom_itm ASSIGNING <lst_bom_itm>.
*           Exclude Publication Types: Opt-In (OI), Controlled Circulation (CC)
            READ TABLE li_mat_det ASSIGNING <lst_mat_det>
                 WITH KEY matnr = <lst_bom_itm>-idnrk
                 BINARY SEARCH.
            IF sy-subrc EQ 0 AND
               <lst_mat_det>-publtype NOT IN lir_pb_typ.
              CONTINUE.
            ENDIF.

*           Begin of ADD:ERP-7056:WROY:20-Mar-2018:ED2K911494
*           Determine the Last BOM Item: In order to avoid the Rounding issue,
*           the Amount of the very last BOM Item has to be adjusted
            MOVE-CORRESPONDING <lst_bom_itm> TO lst_last_bom_cmp.
*           End   of ADD:ERP-7056:WROY:20-Mar-2018:ED2K911494
*           In case of missing Price, the BOM Header Price has to be pro-rated
*           equally
            lv_no_comp = lv_no_comp + 1.                        "Number of BOM Components

*           Identify Condition Type value of the BOM Line Item (Component)
            READ TABLE li_inst_p ASSIGNING <lst_inst_p>
                 WITH KEY pltyp = komk-pltyp
                          matnr = <lst_bom_itm>-idnrk
                 BINARY SEARCH.
            IF sy-subrc EQ 0 AND
               <lst_inst_p>-inst_prc IS NOT INITIAL.
*             Sum up Condition Type values of all the BOM Line Items (Components)
              lv_itm_prc = lv_itm_prc + <lst_inst_p>-inst_prc.
            ELSE.
*             In case of missing Price, the BOM Header Price has to be
*             pro-rated equally
              lv_no_prc  = abap_true.                           "Flag: No Price Maintained
            ENDIF.
          ENDLOOP.
*         Begin of ADD:ERP-7056:WROY:20-Mar-2018:ED2K911494
          MOVE-CORRESPONDING lst_last_bom_cmp TO lst_prices-last_cmp.
*         End   of ADD:ERP-7056:WROY:20-Mar-2018:ED2K911494
        ENDIF.
*       Transfer Values from LOCAL variables to STATIC variables
        lst_prices-itm_prc = lv_itm_prc.                        "Total Item Price
        lst_prices-no_comp = lv_no_comp.                        "Number of BOM Components
        lst_prices-no_prc  = lv_no_prc.                         "Flag: No Price Maintained
      ENDIF.

*     Transfer Values from STATIC variables to LOCAL variables
      IF lv_lst_cmp IS INITIAL AND
         <lst_xvbap_l>-posnr EQ lst_prices-last_bi.
        lv_lst_cmp = abap_true.                                 "Indicator: Last BOM Component
      ENDIF.
*     Begin of ADD:ERP-7056:WROY:20-Mar-2018:ED2K911494
      IF lv_lst_cmp IS INITIAL AND
         <lst_xvbap_l>-stlty EQ lst_prices-last_cmp-stlty AND
         <lst_xvbap_l>-stlnr EQ lst_prices-last_cmp-stlnr AND
         <lst_xvbap_l>-stlkn EQ lst_prices-last_cmp-stlkn AND
         <lst_xvbap_l>-stpoz EQ lst_prices-last_cmp-stpoz.
        lv_lst_cmp = abap_true.                                 "Indicator: Last BOM Component
      ENDIF.
*     End   of ADD:ERP-7056:WROY:20-Mar-2018:ED2K911494
      lv_itm_prc = lst_prices-itm_prc.                          "Total Item Price
      lv_no_comp = lst_prices-no_comp.                          "Number of BOM Components
      lv_no_prc  = lst_prices-no_prc.                           "Flag: No Price Maintained
*     End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134

*     Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
*     Exclude Publication Types: Opt-In (OI), Controlled Circulation (CC)
      READ TABLE li_mat_det ASSIGNING <lst_mat_det>
           WITH KEY matnr = <lst_xvbap_l>-matnr
           BINARY SEARCH.
      IF sy-subrc EQ 0 AND
         <lst_mat_det>-publtype NOT IN lir_pb_typ.
        xkwert = 0.
      ELSE.
*     End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
        IF lv_itm_prc IS NOT INITIAL OR                         "Total Item Price
*          Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
           lv_no_prc  IS NOT INITIAL.                           "Flag: No Price Maintained
*          End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
*         Begin of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
          READ TABLE li_inst_p ASSIGNING <lst_inst_p>
               WITH KEY pltyp = komk-pltyp
                        matnr = <lst_xvbap_l>-matnr
               BINARY SEARCH.
          IF sy-subrc EQ 0.
            DATA(lv_inst_prc) = <lst_inst_p>-inst_prc.
          ENDIF.
*         End   of ADD:CR#564:WROY:06-JUL-2017:ED2K907135

*         Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
          IF lv_no_prc  IS INITIAL.                             "Flag: No Price Maintained
*         End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
*           Calculate Allocated Ratio
            CALL FUNCTION 'ZQTC_ARITHMETIC_OPERATIONS'
              EXPORTING
*               Begin of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
                im_v_operand1  = lv_inst_prc                    "Current Line Item Price
*               End   of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
*               Begin of DEL:CR#564:WROY:06-JUL-2017:ED2K907135
*               im_v_operand1  = <lst_xkomv_l>-kbetr            "Current Line Item Price
*               End   of DEL:CR#564:WROY:06-JUL-2017:ED2K907135
                im_v_operand2  = lv_itm_prc                     "Total Item Price
                im_v_operation = c_opr_div                      "Operand: Division
              IMPORTING
                ex_v_result    = lv_alloc_r.                    "Allocated Ratio
*         Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
          ENDIF.
*         End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
        ENDIF.

*       Get the Price of the BOM Header
        READ TABLE li_xvbap_f ASSIGNING <lst_xvbap_h>
             WITH KEY posnr = <lst_xvbap_l>-uepos.
        IF sy-subrc EQ 0.
*         Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
*         Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
          IF lv_lst_cmp IS INITIAL.
*         End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
*         Begin of DEL:Performance:WROY:16-Nov-2017:ED2K909134
*         IF <lst_xvbap_l>-posnr NE lv_last_bi.
*         End   of DEL:Performance:WROY:16-Nov-2017:ED2K909134
            IF lv_no_prc  IS INITIAL.                           "Flag: No Price Maintained
*         End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
*             Calculate Allocated Amount
              CALL FUNCTION 'ZQTC_ARITHMETIC_OPERATIONS'
                EXPORTING
*                 Begin of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
                  im_v_operand1  = lst_prices-bom_h_pr          "BOM Header Price
*                 End   of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
*                 Begin of DEL:ERP-7151:WROY:20-Mar-2018:ED2K911494
*                 im_v_operand1  = <lst_xvbap_h>-kzwi3          "BOM Header Price
*                 End   of DEL:ERP-7151:WROY:20-Mar-2018:ED2K911494
                  im_v_operand2  = lv_alloc_r                   "Allocated Ratio
                  im_v_operation = c_opr_mul                    "Operand: Multiplication
                IMPORTING
                  ex_v_result    = xkwert.                      "Current Line Item Value
*         Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
            ELSE.
*             Calculate Allocated Amount
              CALL FUNCTION 'ZQTC_ARITHMETIC_OPERATIONS'
                EXPORTING
*                 Begin of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
                  im_v_operand1  = lst_prices-bom_h_pr          "BOM Header Price
*                 End   of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
*                 Begin of DEL:ERP-7151:WROY:20-Mar-2018:ED2K911494
*                 im_v_operand1  = <lst_xvbap_h>-kzwi3          "BOM Header Price
*                 End   of DEL:ERP-7151:WROY:20-Mar-2018:ED2K911494
                  im_v_operand2  = lv_no_comp                   "Number of Components
                  im_v_operation = c_opr_div                    "Operand: Division
                IMPORTING
                  ex_v_result    = xkwert.                      "Current Line Item Value
            ENDIF.
*           Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
            lst_prices-prc_eli = lst_prices-prc_eli + xkwert.   "Price Excluding Last BOM Item
*           End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
          ELSE.
*           Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
            lv_prc_eli = lst_prices-prc_eli.                    "Total Price Excluding Last Item
*           End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
*           Current Line Item Value = BOM Header Price - Total Price Excluding Last Item
*           Begin of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
            xkwert = lst_prices-bom_h_pr - lv_prc_eli.          "Current Line Item Value
*           End   of ADD:ERP-7151:WROY:20-Mar-2018:ED2K911494
*           Begin of DEL:ERP-7151:WROY:20-Mar-2018:ED2K911494
*           xkwert = <lst_xvbap_h>-kzwi3 - lv_prc_eli.          "Current Line Item Value
*           End   of DEL:ERP-7151:WROY:20-Mar-2018:ED2K911494
            CLEAR: lst_prices-prc_eli.
          ENDIF.
*         End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
        ENDIF.
*     Begin of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
      ENDIF.
*     End   of ADD:CR#651:WROY:06-SEP-2017:ED2K908379
    ENDIF.
* Begin of ADD:Performance:WROY:16-Nov-2017:ED2K909134
  ELSE.
    CLEAR: lst_prices.
* End   of ADD:Performance:WROY:16-Nov-2017:ED2K909134
  ENDIF.
ENDIF.
