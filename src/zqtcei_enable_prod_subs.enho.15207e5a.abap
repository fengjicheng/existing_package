"Name: \PR:SAPFV45P\EX:MATERIALFINDUNG_11\EI
ENHANCEMENT 0 ZQTCEI_ENABLE_PROD_SUBS.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_ENABLE_PROD_SUBS (Enhancement Implementation)
* PROGRAM DESCRIPTION: Enable Product Susbstitution even when the Doc
*                      is being created with reference to another Doc
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 26-JUL-2018
* OBJECT ID: I0343 (ERP-6355/ERP-6344)
* TRANSPORT NUMBER(S): ED2K912804
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
* Local variable and constant declaration
  CONSTANTS:
    lc_wricef_id_i0343 TYPE zdevid VALUE 'I0343',     "Constant value for WRICEF (I0343)
    lc_ser_num_I0343_4 TYPE zsno   VALUE '004'.       "Serial Number (004)

  DATA:
    lv_actv_flag_I0343 TYPE zactive_flag.             "Active / Inactive flag

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_I0343             "Constant value for WRICEF (E106)
      im_ser_num     = lc_ser_num_I0343_4             "Serial Number (004)
    IMPORTING
      ex_active_flag = lv_actv_flag_I0343.            "Active / Inactive flag

  IF lv_actv_flag_I0343 EQ abap_true.
    INCLUDE zqtcn_enable_prod_subs IF FOUND.
  ENDIF.
ENDENHANCEMENT.
