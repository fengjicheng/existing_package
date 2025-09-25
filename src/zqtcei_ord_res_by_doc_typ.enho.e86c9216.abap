"Name: \PR:SAPMV45A\FO:SP_TAGGING\SE:BEGIN\EI
ENHANCEMENT 0 ZQTCEI_ORD_RES_BY_DOC_TYP.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_ORD_RES_BY_DOC_TYP (Implicit Enhancement)
* PROGRAM DESCRIPTION: Order Reasons by Document Type
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   06/23/2017
* OBJECT ID: E161
* TRANSPORT NUMBER(S): ED2K906642
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_e161 TYPE zdevid VALUE 'E161',       "Constant value for WRICEF (E161)
    lc_ser_num_e161   TYPE zsno   VALUE '001'.        "Serial Number (001)

  DATA:
    lv_actv_flag_e161 TYPE zactive_flag.              "Active / Inactive flag

*   Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e161              "Constant value for WRICEF (E161)
      im_ser_num     = lc_ser_num_e161                "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_e161.             "Active / Inactive flag

  IF lv_actv_flag_e161 = abap_true.
    INCLUDE zqtcn_ord_res_by_doc_typ_01 IF FOUND.
  ENDIF. "IF lv_actv_flag_E161 = abap_true
ENDENHANCEMENT.
