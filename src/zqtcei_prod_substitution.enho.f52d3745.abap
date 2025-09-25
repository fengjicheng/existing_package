"Name: \PR:SAPMV13D\FO:TCTRL_FAST_ENTRY_REINSTATE\SE:END\EI
ENHANCEMENT 0 ZQTCEI_PROD_SUBSTITUTION.
*----------------------------------------------------------------------
* PROGRAM NAME        : ZQTCEI_PROD_SUBSTITUTION
* PROGRAM DESCRIPTION : Populate Proposed Reason Based on The Product.
* DEVELOPER           : VDPATABALL
* CREATION DATE       : 22-Apr-2022
* OBJECT ID           : C119
* TRANSPORT NUMBER(S) : ED2K926955.
* DESCRIPTION         : The Proposed Reason - Header Field is to be obtained
*                       from tables based on the product substituted.
*----------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------
* REVISION NO         : ED2K926956
* REFERENCE NO        :
* DEVELOPER           : SVISHWANAT
* DATE                : 25-Apr-2022
* DESCRIPTION         : Populate Proposed Reason w.r.t Product.
*-----------------------------------------------------------------------*
************* Start of Enhancement for C119 *******************
*** This enhancement is for C119 and this is to Fill Proposed Reason - Header.
  CONSTANTS:
    lc_wricef_id_C119 TYPE zdevid   VALUE 'C119',             "Constant value for WRICEF (C119)
    lc_var_key_C119   TYPE zvar_key VALUE 'PROPOSED_REASON',  "Variable Key
    lc_ser_num_C119   TYPE zsno     VALUE '001'.              "Serial Number (001)

  DATA:
    lv_actv_flag_C119 TYPE zactive_flag. "Active / Inactive flag

*BREAK svishwanat.
* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_C119  "Constant value for WRICEF (C119)
      im_ser_num     = lc_ser_num_C119    "Serial Number (001)
      im_var_key     = lc_var_key_C119    "Variable Key (PROPOSED_REASON)
    IMPORTING
      ex_active_flag = lv_actv_flag_C119. "Active / Inactive flag

  IF lv_actv_flag_C119 = abap_true.
    INCLUDE zqtcn_Prod_subs_C119 IF FOUND.
  ENDIF. " IF lv_actv_flag_C119 = abap_true
************* End of Enhancement for C119 *******************
ENDENHANCEMENT.
