*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MANAGE_DISCOUNTS_05 (Include)
*               Called from "USEREXIT_PRICING_PREPARE_TKOMP(RV60AFZZ)"
* PROGRAM DESCRIPTION: Populate 'Business Partner-2 or Society number'
* and 'Relationship Category'
* DEVELOPER: Kiran Kumar (KKRAVURI)
* CREATION DATE: 06-DEC-2018
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K913994
*----------------------------------------------------------------------*

* Local Types
TYPES:
  BEGIN OF ty_constant,
    param1 TYPE rvari_vnam,
    param2 TYPE rvari_vnam,
    srno   TYPE tvarv_numb,
    sign   TYPE tvarv_sign,
    opti   TYPE tvarv_opti,
    low    TYPE salv_de_selopt_low,
    high   TYPE salv_de_selopt_high,
  END OF ty_constant,
  tt_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
  BEGIN OF ty_pr_rel,
    vbeln   TYPE vbeln,
    posnr   TYPE posnr_va,     " Sales Document Item
    pr_zlpr TYPE zzpartner2,   " Business Partner 2 or Society number
    rt_zlpr TYPE bu_reltyp,    " Business Partner Relationship Category
    rt_orgn TYPE bu_reltyp,    " Business Partner Relationship Category
  END   OF ty_pr_rel,
  tt_pr_rel TYPE SORTED TABLE OF ty_pr_rel INITIAL SIZE 0
            WITH UNIQUE KEY vbeln posnr.

* Local Data declarations
DATA:
  lv_re_calc_flag TYPE flag,
  lv_pr_zlpr      TYPE zzpartner2,                              " Business Partner 2 or Society number
  lv_rt_zlpr      TYPE bu_reltyp,                               " Business Partner Relationship Categor
  lv_rt_orgn      TYPE bu_reltyp,                               " Business Partner Relationship Category
  lv_pr_date_flag TYPE flag,
  lst_pr_rel      TYPE ty_pr_rel,
  lri_param1      TYPE RANGE OF rvari_vnam,                     " Range Table: Param1
  lrs_param1      LIKE LINE OF lri_param1,
  lri_param2      TYPE RANGE OF rvari_vnam,                     " Range Table: Param2
  lrs_param2      LIKE LINE OF lri_param2,
  lri_bill_typ    TYPE RANGE OF salv_de_selopt_low.

* Local Constants
CONSTANTS:
  lc_ct_zlpr         TYPE kscha      VALUE 'ZLPR',              " Condition Type: ZLPR
  lc_devid           TYPE zdevid     VALUE 'E075',
  lc_param1_bill_typ TYPE rvari_vnam VALUE 'BILLING_TYPE',
  lc_param2_fkart    TYPE rvari_vnam VALUE 'FKART'.

* Static Variables
STATICS:
  i_prt_rel  TYPE tt_pr_rel,
  i_constant TYPE tt_constant.

IF i_constant[] IS INITIAL.
  lrs_param1-sign   = 'I'.
  lrs_param1-option = 'EQ'.
  lrs_param1-low    = lc_param1_bill_typ.
  APPEND lrs_param1 TO lri_param1.
  CLEAR lrs_param1.

  lrs_param2-sign   = 'I'.
  lrs_param2-option = 'EQ'.
  lrs_param2-low    = lc_param2_fkart.
  APPEND lrs_param2 TO lri_param2.
  CLEAR lrs_param2.

  SELECT param1, param2, srno, sign, opti, low, high FROM zcaconstant
         INTO TABLE @i_constant WHERE devid = @lc_devid AND
                                      param1 IN @lri_param1 AND
                                      param2 IN @lri_param2 AND
                                      activate = @abap_true.
  CLEAR: lri_param1[], lri_param2[].
ENDIF. " IF i_constant[] IS INITIAL

LOOP AT i_constant INTO DATA(lst_constant).
  CASE lst_constant-param1.
    WHEN lc_param1_bill_typ.
      IF lst_constant-param2 = lc_param2_fkart.
        APPEND INITIAL LINE TO lri_bill_typ ASSIGNING FIELD-SYMBOL(<lif_bill_typ>).
        <lif_bill_typ>-sign   = lst_constant-sign.
        <lif_bill_typ>-option = lst_constant-opti.
        <lif_bill_typ>-low    = lst_constant-low.
      ENDIF.

    WHEN OTHERS.
      " No need of OTHERS here
  ENDCASE.
  CLEAR lst_constant.
ENDLOOP.

IF lri_bill_typ[] IS NOT INITIAL AND
   vbrk-fkart IN lri_bill_typ[].

  READ TABLE i_prt_rel ASSIGNING FIELD-SYMBOL(<lst_pr_rel>)
       WITH KEY vbeln = vbrp-vbeln posnr = vbrp-posnr
       BINARY SEARCH.
  IF sy-subrc NE 0.                                          " Entry doesn't exist
    lv_re_calc_flag = abap_true.                             " Re-calculate Pricing Fields
  ENDIF.

  IF lv_re_calc_flag IS INITIAL.                             " Use Existing Values
    lv_pr_zlpr = <lst_pr_rel>-pr_zlpr.                       " Business Partner 2 or Society number
    lv_rt_zlpr = <lst_pr_rel>-rt_zlpr.                       " Business Partner Relationship Category
  ELSE.                                                      " Re-calculate Pricing Fields
* Manage Discounts - Soceity Details (ZLPR)
    CALL FUNCTION 'ZQTC_MANAGE_DISC_SOCEITY_DET'
      EXPORTING
        im_tkomk              = tkomk                        " Communication Header for Pricing
        im_tkomp              = tkomp                        " Communication Item for Pricing
        im_kschl              = lc_ct_zlpr                   " Condition Type: ZLPR
        im_prc_date           = lv_pr_date_flag              " Flag: Change in Pricing Date
      IMPORTING
        ex_zzpartner2         = lv_pr_zlpr                   " Business Partner 2 or Society number
        ex_zzreltyp           = lv_rt_zlpr                   " Business Partner Relationship Category
        ex_zzreltyp_o         = lv_rt_orgn                   " Business Partner Relationship Category
      EXCEPTIONS
        exc_no_soceity        = 1
        exc_invalid_cond_type = 2
        OTHERS                = 3.
    IF sy-subrc NE 0.
      CLEAR: lv_pr_zlpr, lv_rt_zlpr, lv_rt_orgn.
    ENDIF.
  ENDIF. " IF lv_re_calc_flag IS INITIAL

  IF lv_re_calc_flag IS NOT INITIAL.                         " Re-calculate Pricing Fields
    IF <lst_pr_rel> IS ASSIGNED.
      <lst_pr_rel>-pr_zlpr = lv_pr_zlpr.                     " Business Partner 2 or Society number
      <lst_pr_rel>-rt_zlpr = lv_rt_zlpr.                     " Business Partner Relationship Category
      <lst_pr_rel>-rt_orgn = lv_rt_orgn.                     " Business Partner Relationship Category
    ELSE.
      lst_pr_rel-vbeln     = vbrp-vbeln.                     " Sales Document Number
      lst_pr_rel-posnr     = vbrp-posnr.                     " Sales Document Item
      lst_pr_rel-pr_zlpr   = lv_pr_zlpr.                     " Business Partner 2 or Society number
      lst_pr_rel-rt_zlpr   = lv_rt_zlpr.                     " Business Partner Relationship Category
      lst_pr_rel-rt_orgn   = lv_rt_orgn.                     " Business Partner Relationship Category
      INSERT lst_pr_rel INTO TABLE i_prt_rel.
      CLEAR lst_pr_rel.
    ENDIF.
    CLEAR lv_re_calc_flag.
  ENDIF.

  READ TABLE tkomk ASSIGNING FIELD-SYMBOL(<lst_tkomk>)
       WITH KEY tkomk-key_uc.
  IF sy-subrc EQ 0.
    <lst_tkomk>-zzpartner2 = lv_pr_zlpr.                 " Business Partner 2 or Society number (ZLPR)
    <lst_tkomk>-zzreltyp   = lv_rt_zlpr.                 " Business Partner Relationship Category (ZLPR)
  ENDIF.

  tkomk-zzpartner2 = lv_pr_zlpr.                         " Business Partner 2 or Society number (ZLPR)
  tkomk-zzreltyp   = lv_rt_zlpr.                         " Business Partner Relationship Category (ZLPR)

ENDIF. " IF lri_bill_typ[] IS NOT INITIAL AND
