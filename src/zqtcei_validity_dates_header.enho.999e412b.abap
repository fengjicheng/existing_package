"Name: \PR:SAPLJKSESAPMV45A\FO:REDUCE_TO_CONTRACT_VALIDITY\SE:BEGIN\EI
ENHANCEMENT 0 ZQTCEI_VALIDITY_DATES_HEADER.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_VALIDITY_DATES_HEADER (Implicit Enhancement)
* PROGRAM DESCRIPTION: Ignore Header Contract Validity Dates; only Item
*                      level Contract Validity Dates will be considered
*                      for determining Media Issues
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 10/10/2017
* OBJECT ID: E166
* TRANSPORT NUMBER(S): ED2K908494
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_e166 TYPE zdevid VALUE 'E166',  "Constant value for WRICEF (E166)
    lc_ser_num_e166_1 TYPE zsno   VALUE '001'.   "Serial Number (001)

  DATA:
    lv_actv_flag_e166 TYPE zactive_flag.         "Active / Inactive flag

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e166         "Constant value for WRICEF (I0229)
      im_ser_num     = lc_ser_num_e166_1         "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_e166.        "Active / Inactive flag
  IF lv_actv_flag_e166 = abap_true.
    INCLUDE zqtcn_validity_dates_header_02 IF FOUND.
  ENDIF.
ENDENHANCEMENT.
