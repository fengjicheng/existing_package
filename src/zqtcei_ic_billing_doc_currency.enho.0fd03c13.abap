"Name: \PR:SAPLV60A\EX:VBRK_VBRP_DATENTRANSPORT_01\EI
ENHANCEMENT 0 ZQTCEI_IC_BILLING_DOC_CURRENCY.
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCEI_IC_BILLING_DOC_CURRENCY [Enh Imp]
* PROGRAM DESCRIPTION: Create IC Billing in Document Currency
* DEVELOPER(S):        Writtick Roy
* CREATION DATE:       09/18/2017
* OBJECT ID:           E160
* TRANSPORT NUMBER(S): ED2K908588
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_e160 TYPE zdevid VALUE 'E160',    "Constant value for WRICEF (E160)
    lc_ser_num_e160_3 TYPE zsno   VALUE '003'.     "Serial Number (003)

  DATA:
    lv_var_key_e160   TYPE zvar_key,               "Variable Key
    lv_actv_flag_e160 TYPE zactive_flag.           "Active / Inactive flag

* Check if enhancement needs to be triggered
  lv_var_key_e160 = vbrk-vbtyp.                    "Variable Key = SD document category
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e160           "Constant value for WRICEF (E160)
      im_ser_num     = lc_ser_num_e160_3           "Serial Number (003)
      im_var_key     = lv_var_key_e160             "Variable Key
    IMPORTING
      ex_active_flag = lv_actv_flag_e160.          "Active / Inactive flag
  IF lv_actv_flag_e160 = abap_true.
    INCLUDE zrtrn_ic_billing_doc_currency IF FOUND.
  ENDIF.
ENDENHANCEMENT.
