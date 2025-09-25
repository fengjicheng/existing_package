*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_SUBRENEWAL_R053
* PROGRAM DESCRIPTION: To view all the list of the new subscription/Renewal
*                      order based on specific selection criteria
* DEVELOPER: Mounika Nallapaneni
* CREATION DATE:   2017-06-02
* OBJECT ID: R053
* TRANSPORT NUMBER(S): ED2K906467
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K909671
* REFERENCE NO:  ERP 5402
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-11-30
* DESCRIPTION: Commented the code that was made to check on the PO number.
*-----------------------------------------------------------------------
* REVISION NO: ED2K909489
* REFERENCE NO:  ERP-5530
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-12-14
* DESCRIPTION: To improve the performance of the program and as part
*              of this made the dates as mandatory parameters.
*-------------------------------------------------------------------
* REVISION NO: ED2K913224
* REFERENCE NO:  ERP-6311
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-08-28
* DESCRIPTION: Added new fields in Selection Screen and Report O/P
*-------------------------------------------------------------------
* REVISION NO: ED2K913419
* REFERENCE NO:  ERP-7727
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-09-21
* DESCRIPTION: Added new fields in Selection Screen and Report O/P
*-------------------------------------------------------------------
* REVISION NO:   ED2K915473
* REFERENCE NO:  DM-1995
* DEVELOPER:     Abdul Khadir (AKHADIR)
* DATE:          2019-06-26
* DESCRIPTION:   Added new field AUGRU-Order Reason in
*                Selection Screen and Report O/P
* Imp Notes:     The is a change done to the CDS view
*                ZQTC_SALES_001 and captured in Transport
*                ED2K915477 which need to be moved simultaneously
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION NO:   ED2K920475
* REFERENCE NO:  OTCM-25936
* DEVELOPER:     Prabhu (PTUFARAM)
* DATE:          11/25/2020
* DESCRIPTION:   1.Added new fields Media Start Issue
*                Media End Issue.
*                2.Issue sent, Issue Duw logic has been changed
* Imp Notes:     Performance Improvement
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*& Report  ZQTCR_SUBRENEWAL_R053
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_subrenewal_r053_old.
*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE ZQTCR_SUBRENEWAL_R053_TOP_OLD.
*INCLUDE zqtcr_subrenewal_r053_top IF FOUND.

*Include for Selection Screen
INCLUDE ZQTCR_SUBRENEWAL_R053_SEL_OLD.
*INCLUDE zqtcr_subrenewal_r053_sel IF FOUND.

*Include for Subroutines
INCLUDE ZQTCR_SUBRENEWAL_R053_SUB_OLD.
*INCLUDE zqtcr_subrenewal_r053_sub IF FOUND.

*----------------------------------------------------------------------*
*                             INITIALIZATION                                *
*----------------------------------------------------------------------*
INITIALIZATION.
*To set Default values.
  PERFORM f_set_default_values.

*  To get constants from zcaconstant
  PERFORM f_get_constants.

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN                         *
*----------------------------------------------------------------------*

AT SELECTION-SCREEN .
*  IF s_partne IS NOT INITIAL.
*    IF cb_parfn IS INITIAL.
*      MESSAGE e205(zqtc_r2). " Please select checkbox society related information.
*    ENDIF. " IF cb_parfn IS INITIAL
*  ENDIF. " IF s_partne IS NOT INITIAL

  IF NOT p_cstat IS INITIAL AND p_cstaf IS INITIAL.
    MESSAGE e209(zqtc_r2). "Contract start date 'From' can not be blank
  ENDIF. " IF NOT p_cstat IS INITIAL AND p_cstaf IS INITIAL
  IF NOT p_cendt IS INITIAL AND p_cendf IS INITIAL.
    MESSAGE e210(zqtc_r2). "Contract end date 'From' can not be blank
  ENDIF. " IF NOT p_cendt IS INITIAL AND p_cendf IS INITIAL


*----------------------------------------------------------------------*
*                AT SELECTION SCREEN ON                          *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON s_saldoc.
  IF s_saldoc[] IS NOT INITIAL.
* Validate Document number
    PERFORM f_validate_vbeln.
  ENDIF. " IF s_saldoc[] IS NOT INITIAL

AT SELECTION-SCREEN ON s_doctyp.
  IF s_doctyp[] IS NOT INITIAL.
* Validate Document type
    PERFORM f_validate_auart.
  ENDIF. " IF s_doctyp[] IS NOT INITIAL

AT SELECTION-SCREEN ON s_kunnr.
  IF s_kunnr[] IS NOT INITIAL.
* Validate Sold to Party
    PERFORM f_validate_kunnr.
  ENDIF. " IF s_kunnr[] IS NOT INITIAL

* Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
AT SELECTION-SCREEN ON s_land1.
  IF s_land1[] IS NOT INITIAL.
* Validate Country Key
    PERFORM f_validate_country USING s_land1[].
  ENDIF. " IF s_land1[] IS NOT INITIAL

AT SELECTION-SCREEN ON s_waerk.
  IF s_waerk[] IS NOT INITIAL.
* Validate Currency Key
    PERFORM f_validate_currency USING s_waerk[].
  ENDIF. " IF s_waerk[] IS NOT INITIAL
* End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224

AT SELECTION-SCREEN ON s_matnum.
  IF s_matnum[] IS NOT INITIAL.
* Validate material number
    PERFORM f_validate_matnr.
  ENDIF. " IF s_matnum[] IS NOT INITIAL

AT SELECTION-SCREEN ON s_ponum.
  IF s_ponum[] IS NOT INITIAL.
* Validate purchase order number
    PERFORM f_validate_bsark.
  ENDIF. " IF s_ponum[] IS NOT INITIAL

AT SELECTION-SCREEN ON s_partne.
  IF s_partne[] IS NOT INITIAL.
* Validate Partner
    PERFORM f_validate_partner.
  ENDIF. " IF s_partne[] IS NOT INITIAL


AT SELECTION-SCREEN ON s_vkorg.
  IF s_vkorg IS NOT INITIAL.
* Validate sales organisation
    PERFORM f_validate_vkorg.
  ENDIF. " IF s_vkorg IS NOT INITIAL

AT SELECTION-SCREEN ON s_vkbur.
  IF s_vkbur IS NOT INITIAL.
* Validate sales office
    PERFORM f_validate_vkbur.
  ENDIF. " IF s_vkbur IS NOT INITIAL

* BOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473
AT SELECTION-SCREEN ON s_augru.
  IF s_augru IS NOT INITIAL.
* Validate Order reason
    PERFORM f_validate_augru.
  ENDIF. " IF s_augru IS NOT INITIAL
* EOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473

* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
AT SELECTION-SCREEN ON s_shpto.
  IF s_shpto IS NOT INITIAL.
*   Validate Ship To Party
    PERFORM f_validate_ship_to_party.
  ENDIF. " IF s_shpto IS NOT INITIAL

AT SELECTION-SCREEN ON s_kdkg2.
  IF s_kdkg2 IS NOT INITIAL.
*   Validate Customer Condition Group 2
    PERFORM f_validate_cust_cond_grp_2.
  ENDIF. " IF s_kdkg2 IS NOT INITIAL

AT SELECTION-SCREEN ON s_mvgr5.
  IF s_mvgr5 IS NOT INITIAL.
*   Validate Material Group 5
    PERFORM f_validate_mat_grp_5.
  ENDIF. " IF s_mvgr5 IS NOT INITIAL

AT SELECTION-SCREEN ON p_alv_vr.
* Validate ALV Variant
  PERFORM f_validate_alv_variant.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_alv_vr.
* F4 Help for ALV Variants
  PERFORM f_f4_alv_variant.
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
*----------------------------------------------------------------------*
*              Start-of-selection                                       *
*----------------------------------------------------------------------*
START-OF-SELECTION.

*Fetch data from Vbak
  PERFORM f_get_vbak.

*Fetch data from Vbkd
  PERFORM f_get_vbkd.

*Fetch data from mara
  PERFORM f_get_mara.

*Fetch data from get_zqtc_renwl_plan
  PERFORM f_get_zqtc_renwl_plan.

* BOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*Fetch data from veda
*  PERFORM f_get_veda.
* EOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489

*Fetch data from Vbpa
  PERFORM f_get_vbpa.

*Fetch data from adrc
  PERFORM f_get_adrc.

*Fetch texts
  PERFORM f_get_text.

*Fetch volume/issues
* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
  PERFORM f_get_jksesched.
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
* Begin of DEL:ERP-7727:WROY:21-SEP-2018:ED2K913419
* PERFORM f_get_jptmg0.
* End   of DEL:ERP-7727:WROY:21-SEP-2018:ED2K913419

*Fetch subscription types
  PERFORM f_subs_type.

* Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*Fetch Society Acronym
  PERFORM f_soc_acronym.

*Fetch Payment Card details
  PERFORM f_payment_card.

*Fetch Payment Details
  PERFORM f_payment_details.
* End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224


*----------------------------------------------------------------------*
*              End-of-selection                                       *
*----------------------------------------------------------------------
END-OF-SELECTION.
*To populate final table
  PERFORM f_populate_final.

*To display ALV
  IF i_final IS NOT INITIAL.
    PERFORM f_alv_output.
  ELSE. " ELSE -> IF i_final IS NOT INITIAL
    MESSAGE  s204(zqtc_r2) DISPLAY LIKE 'E'. " Data not found.
    LEAVE LIST-PROCESSING .
  ENDIF. " IF i_final IS NOT INITIAL
