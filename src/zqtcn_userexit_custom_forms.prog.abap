*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_USEREXIT_CUSTOM_FORMS
* PROGRAM DESCRIPTION: Rejection rule for Sales order
* DEVELOPER: Srabanti Bose (SRBOSE)
* CREATION DATE:   2017-06-22
* OBJECT ID:E104 (CR 449)
* TRANSPORT NUMBER(S)ED2K906852
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908447
* REFERENCE NO: E106 - CR#591
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2017-09-10
* DESCRIPTION: Determine Volume Year Product
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*       FORM ZZ_LINE_ITEM_SUBTOTALS                                    *
*----------------------------------------------------------------------*
*       Line Item Pricing - Subtotals                                  *
*----------------------------------------------------------------------*
FORM zz_line_item_subtotals USING fp_kposn TYPE kposn
                                  fp_worke TYPE kwert
                                  fp_workg TYPE kwert.

  READ TABLE i_sub_tot INTO DATA(lst_sub_tot)
       WITH KEY kposn = fp_kposn
       BINARY SEARCH.
  IF sy-subrc NE 0.
    lst_sub_tot-kposn = fp_kposn.    " Condition item number
    lst_sub_tot-worke = fp_worke.    " Condition Value - Subtotal E
    lst_sub_tot-workg = fp_workg.    " Condition Value - Subtotal G
    INSERT lst_sub_tot INTO TABLE i_sub_tot.
    CLEAR: lst_sub_tot.
  ELSE.
    lst_sub_tot-worke = fp_worke.    " Condition Value - Subtotal E
    lst_sub_tot-workg = fp_workg.    " Condition Value - Subtotal G
    MODIFY i_sub_tot FROM lst_sub_tot INDEX sy-tabix.
    CLEAR: lst_sub_tot.
  ENDIF.

ENDFORM.

*Begin of ADD:CR#591:WROY:10-SEP-2017:ED2K908447
*----------------------------------------------------------------------*
*       FORM ZZ_DETERMINE_VOLUME_YEAR                                  *
*----------------------------------------------------------------------*
*       Determine Volume Year Product                                  *
*----------------------------------------------------------------------*
FORM zz_determine_volume_year USING    fp_i_vbtyp    TYPE vbtyp      "SD DOcument Category
                                       fp_i_pstyv    TYPE pstyv      "Item Category
                                       fp_i_product  TYPE matnr      "Media Product
                                       fp_i_start_dt TYPE vbdat_veda "Contract start date
                                       fp_i_end_dt   TYPE vndat_veda "Contract end date
                              CHANGING fp_c_zzvyp    TYPE zvyp.      "Volume Year of Product

  CONSTANTS:
    lc_devid_e106 TYPE zdevid     VALUE 'E106',                      "Development ID: E106
    lc_sno_e106_3 TYPE zsno       VALUE '003',                       "Serial Number: 003
    lc_prm_vyp    TYPE rvari_vnam VALUE 'VOL_YR_PROD',               "Parameter: Volume Year of Product
    lc_prm_pstyv  TYPE rvari_vnam VALUE 'ITEM_CATEGOTY',             "Parameter: Item Category
    lc_prm_vbtyp  TYPE rvari_vnam VALUE 'DOC_CATEGOTY'.              "Parameter: Document Category

  DATA:
    li_constants  TYPE zcat_constants,                               "Constant Values
    lr_item_cats  TYPE rjksd_pstyv_range_tab,                        "Range: Item Categories
    lr_doc_cats   TYPE saco_vbtyp_ranges_tab,                        "Range: Document Categories
    li_med_issues TYPE rjksenip_tab.                                 "Shipping Schedules

  DATA:
    lst_mat_detls TYPE mara.                                         "Material Master Details

  DATA:
    lv_actv_e106  TYPE zactive_flag .                                "Active / Inactive Flag

  CLEAR: fp_c_zzvyp.
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_devid_e106                                 "Development ID: E106
      im_ser_num     = lc_sno_e106_3                                 "Serial Number: 003
    IMPORTING
      ex_active_flag = lv_actv_e106.                                 "Active / Inactive Flag
  IF lv_actv_e106 NE abap_true.                                      "Enhancement is not Active
    RETURN.
  ENDIF.

* Get Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_e106                                   "Development ID: E106
    IMPORTING
      ex_constants = li_constants.                                   "Constant Values
  LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
      WHEN lc_prm_vyp.
        CASE <lst_constant>-param2.
          WHEN lc_prm_pstyv.                                         "Parameter: Item Categories
            APPEND INITIAL LINE TO lr_item_cats ASSIGNING FIELD-SYMBOL(<lst_item_cat>).
            <lst_item_cat>-sign   = <lst_constant>-sign.
            <lst_item_cat>-option = <lst_constant>-opti.
            <lst_item_cat>-low    = <lst_constant>-low.
            <lst_item_cat>-high   = <lst_constant>-high.
          WHEN lc_prm_vbtyp.                                         "Parameter: Document Categories
            APPEND INITIAL LINE TO lr_doc_cats  ASSIGNING FIELD-SYMBOL(<lst_doc_cat>).
            <lst_doc_cat>-sign    = <lst_constant>-sign.
            <lst_doc_cat>-option  = <lst_constant>-opti.
            <lst_doc_cat>-low     = <lst_constant>-low.
            <lst_doc_cat>-high    = <lst_constant>-high.
          WHEN OTHERS.
*           Nothing to do
        ENDCASE.
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.

  IF fp_i_vbtyp IN lr_doc_cats  AND                                  "Document Category
     fp_i_pstyv IN lr_item_cats.                                     "Item Category
*   Fetch the Shipping Schedules
    CALL FUNCTION 'ISM_SE_SELECT_JKSENIP'
      EXPORTING
        in_product  = fp_i_product                                   "Media Product
      IMPORTING
        out_nip_tab = li_med_issues.                                 "Shipping Schedules
    IF li_med_issues IS NOT INITIAL.
*     Filter entries based on Dlivery Date within the Contract Start / End Date
      DELETE li_med_issues WHERE shipping_date LT fp_i_start_dt
                              OR shipping_date GT fp_i_end_dt.
*     Identify the very first Media Issue based on Delivery Date
      SORT li_med_issues BY shipping_date.
      READ TABLE li_med_issues ASSIGNING FIELD-SYMBOL(<lst_med_issue>) INDEX 1.
      IF sy-subrc EQ 0.
*       Fetch Material Master Details
        CALL FUNCTION 'MARA_SINGLE_READ'
          EXPORTING
            matnr             = <lst_med_issue>-issue                "Media Issue
          IMPORTING
            wmara             = lst_mat_detls                        "Material Master Details
          EXCEPTIONS
            lock_on_material  = 1
            lock_system_error = 2
            wrong_call        = 3
            not_found         = 4
            OTHERS            = 5.
        IF sy-subrc EQ 0.
*         Volume Year Product = Media issue year number
          fp_c_zzvyp = lst_mat_detls-ismyearnr.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*End   of ADD:CR#591:WROY:10-SEP-2017:ED2K908447
