"Name: \PR:RJKSDWORKLIST\FO:ISSUE_FILTERUNG\SE:BEGIN\EI
ENHANCEMENT 0 ZSCM_FILTER_MEDIA_ISSUES_R096.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916492
* REFERENCE NO: ERPM# 837 (R096)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-25
* DESCRIPTION: Enhancement to Filter the Media Issue from lt_marc
*-----------------------------------------------------------------------*
* Local Types
  TYPES: BEGIN OF ty_mi_plant,
           matnr TYPE matnr,
           werks TYPE werks_d,
           loggr TYPE loggr,
           ISMPURCHASEDATE TYPE ISMPURCHASE_DATE_PL,
         END OF ty_mi_plant.

* Local Data
  DATA: li_mat_plant TYPE STANDARD TABLE OF ty_mi_plant INITIAL SIZE 0,
        lv_mtyp      TYPE loggr,
        li_fcat      TYPE LVC_T_FCAT,
        lst_marc     type jksdmarcstat.

* Local Constants
  CONSTANTS:
    lc_digital TYPE loggr VALUE '0001',
    lc_print   TYPE loggr VALUE '0002'.

" Check whether the Enhancement is active ot not
** BOC OTCM-45466 ED2K924372 TDIMANTHA 08/25/2021
  CHECK v_aflag_r096 = abap_true.
*  IF v_aflag_r096 = abap_true OR v_aflag_r096_002 = abap_true.
** EOC OTCM-45466 ED2K924372 TDIMANTHA 08/25/2021

* Set the Filter Value
  IF lv_filt = c_zd.
    lv_mtyp = lc_digital.
  ELSEIF lv_filt = c_zl.
    lv_mtyp = lc_print.
  ENDIF.

  " Check whether Filter Value is initial or not
  IF lv_mtyp IS NOT INITIAL AND
     sy-tcode = 'ZSCM_JKSD13_01' OR
* BOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
** BOI OTCM-45466 ED2K925437 TDIMANTHA 01/04/2022
*     sy-tcode = 'ZSCM_JKSD13_01_NEW'.
** EOI OTCM-45466 ED2K925437 TDIMANTHA 01/04/2022
* EOC OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
* BOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
    sy-tcode = 'ZSCM_JKSD13_01_OLD'.
* EOI OTCM-45466 ED2K925572 TDIMANTHA 01/27/2022
     SELECT matnr, werks, loggr, ismpurchasedate FROM marc INTO TABLE @li_mat_plant
            FOR ALL ENTRIES IN @lt_marc
            WHERE matnr = @lt_marc-matnr AND
                  werks = @lt_marc-werks AND
                  loggr = @lv_mtyp.
     IF sy-subrc = 0 AND li_mat_plant[] IS NOT INITIAL.
      SORT li_mat_plant by matnr werks.
      LOOP AT lt_marc INTO lst_marc.
        READ TABLE li_mat_plant WITH KEY matnr = lst_marc-matnr
                                         werks = lst_marc-werks
                                         BINARY SEARCH TRANSPORTING NO FIELDS.
        IF SY-SUBRC <> 0.
          DELETE lt_marc.
        ENDIF.
        CLEAR lst_marc.
      ENDLOOP.
      REFRESH li_mat_plant.
    ENDIF.
  ENDIF. " IF lv_filt IS NOT INITIAL AND sy-tcode = 'ZSCM_JKSD13_01.
** BOC OTCM-45466 ED2K924372 TDIMANTHA 08/25/2021
*  ENDIF. " IF v_aflag_r096 = abap_true OR v_aflag_r096_002 = abap_true
** EOC OTCM-45466 ED2K924372 TDIMANTHA 08/25/2021

ENDENHANCEMENT.
