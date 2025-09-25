*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MANAGE_DISCOUNTS_01 (Include)
*               Called from "USEREXIT_PRICING_PREPARE_TKOMP(MV45AFZZ)"
* PROGRAM DESCRIPTION: Replace Pricing Reference Material
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   10-NOV-2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K903315
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906514
* REFERENCE NO: CR#549
* DEVELOPER: Writtick Roy (WROY)
* DATE:  05-JUN-2017
* DESCRIPTION: Re-determine Relationship Data if Pricing Date is changed
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K906690
* REFERENCE NO: ERP-2718
* DEVELOPER: Writtick Roy (WROY)
* DATE:  13-JUN-2017
* DESCRIPTION: Use the Original Relationship Category; it was getting
*              overwritten through CR#549 logic.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K908023
* REFERENCE NO: CR#637
* DEVELOPER: Writtick Roy (WROY)
* DATE:  17-AUG-2017
* DESCRIPTION: Added logic for Condition Type ZLPS
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910130
* REFERENCE NO: SAP's Recommendations
* DEVELOPER: Writtick Roy (WROY)
* DATE:  08-JAN-2018
* DESCRIPTION: Avoid multiple calls for Pricing fields determination
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914105
* REFERENCE NO: CR#7816
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 28-Dec-2018
* DESCRIPTION: Corrections in Pricing routine for Doc Type: 'ZSBP'
*----------------------------------------------------------------------*
* Internal Table Declaration
DATA:
  li_const   TYPE zcat_constants,                          "Internal table for Constant Table
  lir_jrnl_i TYPE fip_t_mtart_range.                       "Range: Material Type

DATA:
  lst_gen_md TYPE mara,                                    "General Material Data
* Begin of ADD:SAP's Recommendations:WROY:08-JAN-2018:ED2K910130
  lst_pr_rel TYPE ty_pr_rel,                               "Business Partner 2 or Society number / BP Relationship Category (Buffer)
* End   of ADD:SAP's Recommendations:WROY:08-JAN-2018:ED2K910130
  lst_veda_k TYPE veda.                                    "Contract Data

DATA:
  lv_pf_semp TYPE parvw,                                   "Partner Function: Sales Emp
* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
  lv_pr_date TYPE flag,                                    "Flag: Change in Pricing Date
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
* Begin of ADD:SAP's Recommendations:WROY:08-JAN-2018:ED2K910130
  lv_re_calc TYPE flag,                                    "Flag: Re-calculate Pricing Feilds
  lv_vpr_cat TYPE char30 VALUE '(SAPLV45W)*VEDA-VLAUFK',   "ABAP Stack: Validity period category of contract
  lv_vlaufk  TYPE vlauk_veda,                              "Validity period category of contract
* End   of ADD:SAP's Recommendations:WROY:08-JAN-2018:ED2K910130
  lv_pr_zlpr TYPE zzpartner2,                              "Business Partner 2 or Society number
  lv_rt_zlpr TYPE bu_reltyp,                               "Business Partner Relationship Category
* Begin of ADD:CR#637:WROY:17-AUG-2017:ED2K908023
  lv_pr_zlps TYPE zzpartner2,                              "Business Partner 2 or Society number
  lv_rt_zlps TYPE bu_reltyp,                               "Business Partner Relationship Category
* End   of ADD:CR#637:WROY:17-AUG-2017:ED2K908023
* Begin of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
  lv_rt_orgn TYPE bu_reltyp,                               "Business Partner Relationship Category
* End   of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
  lv_pr_zsd1 TYPE zzpartner2,                              "Business Partner 2 or Society number
  lv_rt_zsd1 TYPE bu_reltyp,                               "Business Partner Relationship Category
  lv_pr_zsd2 TYPE zzpartner2,                              "Business Partner 2 or Society number
  lv_rt_zsd2 TYPE bu_reltyp,                               "Business Partner Relationship Category
  lv_pr_znd1 TYPE zzpartner2,                              "Business Partner 2 or Society number
  lv_rt_znd1 TYPE bu_reltyp,                               "Business Partner Relationship Category
  lv_pr_zmys TYPE zzpartner2,                              "Business Partner 2 or Society number
  lv_rt_zmys TYPE bu_reltyp.                               "Business Partner Relationship Category

*** BOC: CR#7816  KKRAVURI20181226  ED2K914105
STATICS:
  s_prsdt    TYPE prsdt VALUE '99990101'.
*** EOC: CR#7816  KKRAVURI20181226  ED2K914105

CONSTANTS:
  lc_id_e075 TYPE zdevid         VALUE 'E075',             "Development ID
  lc_param_m TYPE rvari_vnam     VALUE 'JRNL_ISSUE',       "ABAP: Name of Variant Variable
  lc_param_e TYPE rvari_vnam     VALUE 'PF_SALES_EMP',     "ABAP: Name of Variant Variable
  lc_ct_zlpr TYPE kscha          VALUE 'ZLPR',             "Condition Type: ZLPR
* Begin of ADD:CR#637:WROY:17-AUG-2017:ED2K908023
  lc_ct_zlps TYPE kscha          VALUE 'ZLPS',             "Condition Type: ZLPS
* End   of ADD:CR#637:WROY:17-AUG-2017:ED2K908023
  lc_ct_zsd1 TYPE kscha          VALUE 'ZSD1',             "Condition Type: ZSD1
  lc_ct_zsd2 TYPE kscha          VALUE 'ZSD2',             "Condition Type: ZSD2
  lc_ct_znd1 TYPE kscha          VALUE 'ZND1',             "Condition Type: ZND1
  lc_ct_zmys TYPE kscha          VALUE 'ZMYS',             "Condition Type: ZMYS
  lc_level_3 TYPE ismhierarchlvl VALUE '3'.                "Hierarchy Level (Issue)

* Get data from constant table
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_id_e075
  IMPORTING
    ex_constants = li_const.

LOOP AT li_const ASSIGNING FIELD-SYMBOL(<lst_const>).
  CASE <lst_const>-param1.
    WHEN lc_param_m.                                     "Material Type
      APPEND INITIAL LINE TO lir_jrnl_i ASSIGNING FIELD-SYMBOL(<lst_jrnl_i>).
      <lst_jrnl_i>-sign   = <lst_const>-sign.
      <lst_jrnl_i>-option = <lst_const>-opti.
      <lst_jrnl_i>-low    = <lst_const>-low.
      <lst_jrnl_i>-high   = <lst_const>-high.

    WHEN lc_param_e.                                     "Partner Func: Sales Employee
      lv_pf_semp          = <lst_const>-low.

    WHEN OTHERS.
*     Nothing to do
  ENDCASE.
ENDLOOP.

* Check if the Material is an Issue (Level-3)
CALL FUNCTION 'MARA_SINGLE_READ'
  EXPORTING
    matnr             = tkomp-matnr                        "Material Number
  IMPORTING
    wmara             = lst_gen_md                         "General Material Data
  EXCEPTIONS
    lock_on_material  = 1
    lock_system_error = 2
    wrong_call        = 3
    not_found         = 4
    OTHERS            = 5.
IF sy-subrc EQ 0.
  tkomp-rep_matnr = tkomp-matnr.                           "Material Number
  IF lst_gen_md-ismhierarchlevl EQ lc_level_3 AND          "Check for Level-3
     lst_gen_md-mtart           IN lir_jrnl_i AND          "Material type - Journal Issue
     lst_gen_md-ismrefmdprod    IS NOT INITIAL.
    tkomp-pmatn = lst_gen_md-ismrefmdprod.                 "Pricing Reference Material (Product/Level-2)
    tkomp-matnr = lst_gen_md-ismrefmdprod.                 "Pricing Reference Material (Product/Level-2)

*   Get details of Level-2 Product
    CLEAR: lst_gen_md.
    CALL FUNCTION 'MARA_SINGLE_READ'
      EXPORTING
        matnr             = tkomp-matnr                    "Material Number
      IMPORTING
        wmara             = lst_gen_md                     "General Material Data
      EXCEPTIONS
        lock_on_material  = 1
        lock_system_error = 2
        wrong_call        = 3
        not_found         = 4
        OTHERS            = 5.
    IF sy-subrc NE 0.
      CLEAR: lst_gen_md.
    ENDIF.
  ENDIF.

  IF tkomp-extwg IS INITIAL.
    tkomp-extwg = lst_gen_md-extwg.                        "External Material Group
  ENDIF.

  IF tkomp-mtart IS INITIAL.
    tkomp-mtart = lst_gen_md-mtart.                        "Material Type
  ENDIF.

  IF tkomp-ismmediatype IS INITIAL.
    tkomp-ismmediatype = lst_gen_md-ismmediatype.          "Media Type
  ENDIF.

  IF tkomp-zzismpubltype IS INITIAL.
    tkomp-zzismpubltype = lst_gen_md-ismpubltype.          "Publication Type
  ENDIF.
ENDIF.

IF tkomp-zzpromo IS INITIAL.
  tkomp-zzpromo  = vbap-zzpromo.                           "Promo Code
*  tkomp-knuma_pi = vbap-zzpromo.                          "Promo Code
ENDIF.

IF tkomp-zzpstyv IS INITIAL.
  tkomp-zzpstyv = vbap-pstyv.                              "Sales document item category
ENDIF.

* Check for Partner Function 'ZD' (Discount Allowed)
READ TABLE xvbpa ASSIGNING FIELD-SYMBOL(<lst_xvbpa>)
     WITH KEY vbeln = vbap-vbeln                           "Sales and Distribution Document Number
              posnr = vbap-posnr                           "Item number of the SD document
              parvw = lv_pf_semp.                          "Partner Function
IF sy-subrc NE 0.
  READ TABLE xvbpa ASSIGNING <lst_xvbpa>
       WITH KEY vbeln = vbap-vbeln                         "Sales and Distribution Document Number
                posnr = posnr_low                          "Item number of the SD document (Header -000000)
                parvw = lv_pf_semp.                        "Partner Function
ENDIF.
IF sy-subrc EQ 0.
  tkomp-pernr = <lst_xvbpa>-pernr.                         "Sales Employee
ENDIF.

IF tkomp-zzvlaufk IS INITIAL.
* Fetch Contract Data
  CLEAR: lst_veda_k.
  CALL FUNCTION 'SD_VEDA_GET_DATA'
    IMPORTING
      es_veda = lst_veda_k.                                "Contract Data
  IF lst_veda_k IS NOT INITIAL.
    tkomp-zzvlaufk = lst_veda_k-vlaufk.                    "Validity period category of contract
  ENDIF.
ENDIF.

* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
IF vbkd-prsdt NE *vbkd-prsdt.
  lv_pr_date = abap_true.                                  "Flag: Change in Pricing Date
ENDIF.
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514

*** BOC: CR#7816  KKRAVURI20181226  ED2K914105
* Below coding is required when the 'Pricing date' is determined after
* the items are entered. This scenario is relevant to Doc Type: 'ZSBP'
IF vbkd-prsdt IS INITIAL.
  s_prsdt = vbkd-prsdt.
ENDIF.
*** EOC: CR#7816  KKRAVURI20181226  ED2K914105


* Begin of ADD:SAP's Recommendations:WROY:08-JAN-2018:ED2K910130
* Validity period category of contract (Old Value) - from ABAP Stack
ASSIGN (lv_vpr_cat) TO FIELD-SYMBOL(<lv_vlaufk>).
IF sy-subrc EQ 0.
  lv_vlaufk = <lv_vlaufk>.
ENDIF.

CLEAR lv_re_calc.
READ TABLE i_prt_rel ASSIGNING FIELD-SYMBOL(<lst_pr_rel>)
     WITH KEY posnr = vbap-posnr
     BINARY SEARCH.
IF sy-subrc NE 0.                                          "Entry doesn't exist
  lv_re_calc = abap_true.                                  "Re-calculate Pricing Fields
*** BOC: CR#7816  KKRAVURI20181226  ED2K914105
ELSEIF sy-subrc = 0 AND s_prsdt IS INITIAL AND             "Entry exists, but 'Pricing date' is determined after                                                          "the items are entered
       <lst_pr_rel>-pr_zlpr IS INITIAL AND
       <lst_pr_rel>-rt_zlpr IS INITIAL.
  lv_pr_date = abap_true.                                  "Flag: Change in Pricing Date
  lv_re_calc = abap_true.
*** EOC: CR#7816  KKRAVURI20181226  ED2K914105
ELSE.
  IF vbkd-prsdt     NE *vbkd-prsdt OR                      "Pricing Date is changed
     vbkd-kdgrp     NE *vbkd-kdgrp OR                      "Customer Group is changed
     vbkd-pltyp     NE *vbkd-pltyp OR                      "Price List Type is changed
     vbap-matnr     NE *vbap-matnr OR                      "Material Number is changed
     tkomp-zzvlaufk NE lv_vlaufk   OR                      "Validity period category of contract is changed
     rv02p-agupd    EQ abap_true   OR                      "Sold-To Party is changed
     rv02p-weupd    EQ abap_true.                          "Ship-To Party is changed
    lv_re_calc = abap_true.                                "Re-calculate Pricing Fields
  ENDIF.
ENDIF.

IF lv_re_calc IS INITIAL.                                  "Use Existing Values
  lv_pr_zlpr = <lst_pr_rel>-pr_zlpr.                       "Business Partner 2 or Society number
  lv_rt_zlpr = <lst_pr_rel>-rt_zlpr.                       "Business Partner Relationship Category
  lv_pr_zlps = <lst_pr_rel>-pr_zlps.                       "Business Partner 2 or Society number
  lv_rt_zlps = <lst_pr_rel>-rt_zlps.                       "Business Partner Relationship Category
  lv_pr_zsd1 = <lst_pr_rel>-pr_zsd1.                       "Business Partner 2 or Society number
  lv_rt_zsd1 = <lst_pr_rel>-rt_zsd1.                       "Business Partner Relationship Category
  lv_pr_zsd2 = <lst_pr_rel>-pr_zsd2.                       "Business Partner 2 or Society number
  lv_rt_zsd2 = <lst_pr_rel>-rt_zsd2.                       "Business Partner Relationship Category
  lv_pr_znd1 = <lst_pr_rel>-pr_znd1.                       "Business Partner 2 or Society number
  lv_rt_znd1 = <lst_pr_rel>-rt_znd1.                       "Business Partner Relationship Category
  lv_pr_zmys = <lst_pr_rel>-pr_zmys.                       "Business Partner 2 or Society number
  lv_rt_zmys = <lst_pr_rel>-rt_zmys.                       "Business Partner Relationship Category
  lv_rt_orgn = <lst_pr_rel>-rt_orgn.                       "Business Partner Relationship Category
ELSE.                                                      "Re-calculate Pricing Fields
* End   of ADD:SAP's Recommendations:WROY:08-JAN-2018:ED2K910130
* Manage Discounts - Soceity Details (ZLPR)
  CALL FUNCTION 'ZQTC_MANAGE_DISC_SOCEITY_DET'
    EXPORTING
      im_tkomk              = tkomk                        "Communication Header for Pricing
      im_tkomp              = tkomp                        "Communication Item for Pricing
      im_kschl              = lc_ct_zlpr                   "Condition Type: ZLPR
*   Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
      im_prc_date           = lv_pr_date                   "Flag: Change in Pricing Date
*   End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
    IMPORTING
      ex_zzpartner2         = lv_pr_zlpr                   "Business Partner 2 or Society number
      ex_zzreltyp           = lv_rt_zlpr                   "Business Partner Relationship Category
*   Begin of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
      ex_zzreltyp_o         = lv_rt_orgn                   "Business Partner Relationship Category
*   End   of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
    EXCEPTIONS
      exc_no_soceity        = 1
      exc_invalid_cond_type = 2
      OTHERS                = 3.
  IF sy-subrc NE 0.
    CLEAR: lv_pr_zlpr,
           lv_rt_zlpr.
  ENDIF.
* Begin of ADD:CR#637:WROY:17-AUG-2017:ED2K908023
* Manage Discounts - Soceity Details (ZLPS)
  CALL FUNCTION 'ZQTC_MANAGE_DISC_SOCEITY_DET'
    EXPORTING
      im_tkomk              = tkomk                        "Communication Header for Pricing
      im_tkomp              = tkomp                        "Communication Item for Pricing
      im_kschl              = lc_ct_zlps                   "Condition Type: ZLPS
      im_prc_date           = lv_pr_date                   "Flag: Change in Pricing Date
    IMPORTING
      ex_zzpartner2         = lv_pr_zlps                   "Business Partner 2 or Society number
      ex_zzreltyp           = lv_rt_zlps                   "Business Partner Relationship Category
    EXCEPTIONS
      exc_no_soceity        = 1
      exc_invalid_cond_type = 2
      OTHERS                = 3.
  IF sy-subrc NE 0.
    CLEAR: lv_pr_zlps,
           lv_rt_zlps.
  ENDIF.
* End   of ADD:CR#637:WROY:17-AUG-2017:ED2K908023
* Manage Discounts - Soceity Details (ZSD1)
  CALL FUNCTION 'ZQTC_MANAGE_DISC_SOCEITY_DET'
    EXPORTING
      im_tkomk              = tkomk                        "Communication Header for Pricing
      im_tkomp              = tkomp                        "Communication Item for Pricing
      im_kschl              = lc_ct_zsd1                   "Condition Type: ZSD1
    IMPORTING
      ex_zzpartner2         = lv_pr_zsd1                   "Business Partner 2 or Society number
      ex_zzreltyp           = lv_rt_zsd1                   "Business Partner Relationship Category
    EXCEPTIONS
      exc_no_soceity        = 1
      exc_invalid_cond_type = 2
      OTHERS                = 3.
  IF sy-subrc NE 0.
    CLEAR: lv_pr_zsd1,
           lv_rt_zsd1.
  ENDIF.
* Manage Discounts - Soceity Details (ZSD2)
  CALL FUNCTION 'ZQTC_MANAGE_DISC_SOCEITY_DET'
    EXPORTING
      im_tkomk              = tkomk                        "Communication Header for Pricing
      im_tkomp              = tkomp                        "Communication Item for Pricing
      im_kschl              = lc_ct_zsd2                   "Condition Type: ZSD2
    IMPORTING
      ex_zzpartner2         = lv_pr_zsd2                   "Business Partner 2 or Society number
      ex_zzreltyp           = lv_rt_zsd2                   "Business Partner Relationship Category
    EXCEPTIONS
      exc_no_soceity        = 1
      exc_invalid_cond_type = 2
      OTHERS                = 3.
  IF sy-subrc NE 0.
    CLEAR: lv_pr_zsd2,
           lv_rt_zsd2.
  ENDIF.
* Manage Discounts - Soceity Details (ZND1)
  CALL FUNCTION 'ZQTC_MANAGE_DISC_SOCEITY_DET'
    EXPORTING
      im_tkomk              = tkomk                        "Communication Header for Pricing
      im_tkomp              = tkomp                        "Communication Item for Pricing
      im_kschl              = lc_ct_znd1                   "Condition Type: ZND1
    IMPORTING
      ex_zzpartner2         = lv_pr_znd1                   "Business Partner 2 or Society number
      ex_zzreltyp           = lv_rt_znd1                   "Business Partner Relationship Category
    EXCEPTIONS
      exc_no_soceity        = 1
      exc_invalid_cond_type = 2
      OTHERS                = 3.
  IF sy-subrc NE 0.
    CLEAR: lv_pr_znd1,
           lv_rt_znd1.
  ENDIF.
* Manage Discounts - Soceity Details (ZMYS)
  CALL FUNCTION 'ZQTC_MANAGE_DISC_SOCEITY_DET'
    EXPORTING
      im_tkomk              = tkomk                        "Communication Header for Pricing
      im_tkomp              = tkomp                        "Communication Item for Pricing
      im_kschl              = lc_ct_zmys                   "Condition Type: ZMYS
    IMPORTING
      ex_zzpartner2         = lv_pr_zmys                   "Business Partner 2 or Society number
      ex_zzreltyp           = lv_rt_zmys                   "Business Partner Relationship Category
    EXCEPTIONS
      exc_no_soceity        = 1
      exc_invalid_cond_type = 2
      OTHERS                = 3.
  IF sy-subrc NE 0.
    CLEAR: lv_pr_zmys,
           lv_rt_zmys.
  ENDIF.
* Begin of ADD:SAP's Recommendations:WROY:08-JAN-2018:ED2K910130
ENDIF. " IF lv_re_calc IS INITIAL.

IF lv_re_calc IS NOT INITIAL.                              "Re-calculate Pricing Fields
  IF <lst_pr_rel> IS ASSIGNED.
    <lst_pr_rel>-pr_zlpr = lv_pr_zlpr.                     "Business Partner 2 or Society number
    <lst_pr_rel>-rt_zlpr = lv_rt_zlpr.                     "Business Partner Relationship Category
    <lst_pr_rel>-pr_zlps = lv_pr_zlps.                     "Business Partner 2 or Society number
    <lst_pr_rel>-rt_zlps = lv_rt_zlps.                     "Business Partner Relationship Category
    <lst_pr_rel>-pr_zsd1 = lv_pr_zsd1.                     "Business Partner 2 or Society number
    <lst_pr_rel>-rt_zsd1 = lv_rt_zsd1.                     "Business Partner Relationship Category
    <lst_pr_rel>-pr_zsd2 = lv_pr_zsd2.                     "Business Partner 2 or Society number
    <lst_pr_rel>-rt_zsd2 = lv_rt_zsd2.                     "Business Partner Relationship Category
    <lst_pr_rel>-pr_znd1 = lv_pr_znd1.                     "Business Partner 2 or Society number
    <lst_pr_rel>-rt_znd1 = lv_rt_znd1.                     "Business Partner Relationship Category
    <lst_pr_rel>-pr_zmys = lv_pr_zmys.                     "Business Partner 2 or Society number
    <lst_pr_rel>-rt_zmys = lv_rt_zmys.                     "Business Partner Relationship Category
    <lst_pr_rel>-rt_orgn = lv_rt_orgn.                     "Business Partner Relationship Category
  ELSE.
    lst_pr_rel-posnr     = vbap-posnr.                     "Sales Document Item
    lst_pr_rel-pr_zlpr   = lv_pr_zlpr.                     "Business Partner 2 or Society number
    lst_pr_rel-rt_zlpr   = lv_rt_zlpr.                     "Business Partner Relationship Category
    lst_pr_rel-pr_zlps   = lv_pr_zlps.                     "Business Partner 2 or Society number
    lst_pr_rel-rt_zlps   = lv_rt_zlps.                     "Business Partner Relationship Category
    lst_pr_rel-pr_zsd1   = lv_pr_zsd1.                     "Business Partner 2 or Society number
    lst_pr_rel-rt_zsd1   = lv_rt_zsd1.                     "Business Partner Relationship Category
    lst_pr_rel-pr_zsd2   = lv_pr_zsd2.                     "Business Partner 2 or Society number
    lst_pr_rel-rt_zsd2   = lv_rt_zsd2.                     "Business Partner Relationship Category
    lst_pr_rel-pr_znd1   = lv_pr_znd1.                     "Business Partner 2 or Society number
    lst_pr_rel-rt_znd1   = lv_rt_znd1.                     "Business Partner Relationship Category
    lst_pr_rel-pr_zmys   = lv_pr_zmys.                     "Business Partner 2 or Society number
    lst_pr_rel-rt_zmys   = lv_rt_zmys.                     "Business Partner Relationship Category
    lst_pr_rel-rt_orgn   = lv_rt_orgn.                     "Business Partner Relationship Category
    INSERT lst_pr_rel INTO TABLE i_prt_rel.
    CLEAR: lst_pr_rel.
  ENDIF.
ENDIF.
* End   of ADD:SAP's Recommendations:WROY:08-JAN-2018:ED2K910130

READ TABLE tkomk ASSIGNING FIELD-SYMBOL(<lst_tkomk>)
     WITH KEY tkomk-key_uc.
IF sy-subrc EQ 0.
  <lst_tkomk>-zzpartner2     = lv_pr_zlpr.                 "Business Partner 2 or Society number (ZLPR)
  <lst_tkomk>-zzreltyp       = lv_rt_zlpr.                 "Business Partner Relationship Category (ZLPR)
* Begin of ADD:CR#637:WROY:17-AUG-2017:ED2K908023
  <lst_tkomk>-zzpartner2_lps = lv_pr_zlps.                 "Business Partner 2 or Society number (ZLPS)
  <lst_tkomk>-zzreltyp_lps   = lv_rt_zlps.                 "Business Partner Relationship Category (ZLPS)
* End   of ADD:CR#637:WROY:17-AUG-2017:ED2K908023
  <lst_tkomk>-zzpartner2_sd1 = lv_pr_zsd1.                 "Business Partner 2 or Society number (ZSD1)
  <lst_tkomk>-zzreltyp_sd1   = lv_rt_zsd1.                 "Business Partner Relationship Category (ZSD1)
  <lst_tkomk>-zzpartner2_sd2 = lv_pr_zsd2.                 "Business Partner 2 or Society number (ZSD2)
  <lst_tkomk>-zzreltyp_sd2   = lv_rt_zsd2.                 "Business Partner Relationship Category (ZSD2)
  <lst_tkomk>-zzpartner2_nd1 = lv_pr_znd1.                 "Business Partner 2 or Society number (ZND1)
  <lst_tkomk>-zzreltyp_nd1   = lv_rt_znd1.                 "Business Partner Relationship Category (ZND1)
  <lst_tkomk>-zzpartner2_mys = lv_pr_zmys.                 "Business Partner 2 or Society number (ZMYS)
  <lst_tkomk>-zzreltyp_mys   = lv_rt_zmys.                 "Business Partner Relationship Category (ZMYS)
ENDIF.

tkomk-zzpartner2             = lv_pr_zlpr.                 "Business Partner 2 or Society number (ZLPR)
tkomk-zzreltyp               = lv_rt_zlpr.                 "Business Partner Relationship Category (ZLPR)
* Begin of ADD:CR#637:WROY:17-AUG-2017:ED2K908023
tkomk-zzpartner2_lps         = lv_pr_zlps.                 "Business Partner 2 or Society number (ZLPS)
tkomk-zzreltyp_lps           = lv_rt_zlps.                 "Business Partner Relationship Category (ZLPS)
* End   of ADD:CR#637:WROY:17-AUG-2017:ED2K908023
tkomk-zzpartner2_sd1         = lv_pr_zsd1.                 "Business Partner 2 or Society number (ZSD1)
tkomk-zzreltyp_sd1           = lv_rt_zsd1.                 "Business Partner Relationship Category (ZSD1)
tkomk-zzpartner2_sd2         = lv_pr_zsd2.                 "Business Partner 2 or Society number (ZSD2)
tkomk-zzreltyp_sd2           = lv_rt_zsd2.                 "Business Partner Relationship Category (ZSD2)
tkomk-zzpartner2_nd1         = lv_pr_znd1.                 "Business Partner 2 or Society number (ZND1)
tkomk-zzreltyp_nd1           = lv_rt_znd1.                 "Business Partner Relationship Category (ZND1)
tkomk-zzpartner2_mys         = lv_pr_zmys.                 "Business Partner 2 or Society number (ZMYS)
tkomk-zzreltyp_mys           = lv_rt_zmys.                 "Business Partner Relationship Category (ZMYS)
