"Name: \PR:SAPMV60A\FO:CUST_ITEM_ACTIVATE\SE:BEGIN\EI
ENHANCEMENT 0 ZQTCEI_ADD_CUSTOM_FIELDS.
*-------------------------------------------------------------------*
* ENHANCEMENT NAME:ZQTCEI_ADD_CUSTOM_FIELDS
* PROGRAM DESCRIPTION:Custom Copy control.
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-10-02
* OBJECT ID:E070
* TRANSPORT NUMBER(S):ED2K903028
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
  CONSTANTS:
    lc_wricef_id_e070 TYPE zdevid  VALUE 'E070', " Development ID
    lc_ser_num_1_e070 TYPE zsno    VALUE '001'.  " Serial Number

  DATA:
    lv_actv_flag_e070 TYPE zactive_flag .        " Active / Inactive Flag

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e070
      im_ser_num     = lc_ser_num_1_e070
    IMPORTING
      ex_active_flag = lv_actv_flag_e070.
  IF lv_actv_flag_e070 EQ abap_true.
    INCLUDE zqtcn_biilling_cust_field_add IF FOUND.
  ENDIF. " IF lv_actv_flag EQ abap_true
ENDENHANCEMENT.
