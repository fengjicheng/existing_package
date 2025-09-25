"Name: \PR:SAPFV45P\EX:VBAP_BEARBEITEN_ENDE_17\EI
ENHANCEMENT 0 ZQTCEI_BOM_HDR_REPRICING.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_BOM_HDR_REPRICING (Enhancement Implementation)
* PROGRAM DESCRIPTION: Header Level Re-pricing if Price / Quantity of
*                      BOM Header changes
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   03/07/2018
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K911216
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_BOM_HDR_REPRICING (Enhancement Implementation)
* PROGRAM DESCRIPTION: In Batch Mode Header Level Re-pricing to be
*                      done for Last BOM Header.
* DEVELOPER:  Nikhilesh Palla (NPALLA)
* CREATION DATE:   21-Dec-2019 / 21-Jan-2021
* OBJECT ID: E075-INC0270978
* TRANSPORT NUMBER(S): ED1K911417 / ED2K921414
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_e075 TYPE zdevid   VALUE 'E075',  " Development ID
    lc_ser_num_9_e075 TYPE zsno     VALUE '009',   " Serial Number
    lc_var_key_9_new  TYPE zvar_key VALUE 'NEW'.   "++ED1K911417

  DATA:
    lv_actv_flag_e075 TYPE zactive_flag,           " Active / Inactive Flag
    lv_actv_flag_e075_new TYPE zactive_flag.       " Active / Inactive Flag "++ED1K911417

*   To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e075
      im_ser_num     = lc_ser_num_9_e075
    IMPORTING
      ex_active_flag = lv_actv_flag_e075.

  IF lv_actv_flag_e075 EQ abap_true.
*   Begin of Change:E075-INC0270978:NPALLA:21-Dec-2019:ED1K911417
*    INCLUDE zqtcn_bom_hdr_repricing IF FOUND.  "--ED1K911417
*   To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e075
        im_ser_num     = lc_ser_num_9_e075
        im_var_key     = lc_var_key_9_new
      IMPORTING
        ex_active_flag = lv_actv_flag_e075_new.

    IF lv_actv_flag_e075_new EQ abap_true.
      INCLUDE zqtcn_bom_hdr_repricing_new IF FOUND.
    ELSE.
      INCLUDE zqtcn_bom_hdr_repricing IF FOUND.
    ENDIF.
*   End of Change:E075-INC0270978:NPALLA:21-Dec-2019:ED1K911417
  ENDIF.
ENDENHANCEMENT.
