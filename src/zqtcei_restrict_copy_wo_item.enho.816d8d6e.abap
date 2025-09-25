"Name: \PR:SAPFV45C\EX:VORLAGE_KOPIEREN_21\EI
ENHANCEMENT 0 ZQTCEI_RESTRICT_COPY_WO_ITEM.
*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCEI_RESTRICT_COPY_WO_ITEM
* PROGRAM DESCRIPTION: Restrict creation of multiple Quotations
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 12/15/2017
* OBJECT ID: E070
* TRANSPORT NUMBER(S): ED2K909901
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :
* REFERENCE NO :
* DEVELOPER :
* DATE :
* DESCRIPTION :
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_e070 TYPE zdevid VALUE 'E070', " Development ID
    lc_ser_num_e070_7 TYPE zsno   VALUE '007'.  " Serial Number

  DATA:
    lv_var_key_e070   TYPE zvar_key,            " Variable Key
    lv_actv_flag_e070 TYPE zactive_flag.        " Active / Inactive Flag

  lv_var_key_e070 = vbak-vbtyp.                 " Variable Key (SD document category)
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e070
      im_ser_num     = lc_ser_num_e070_7
      im_var_key     = lv_var_key_e070
    IMPORTING
      ex_active_flag = lv_actv_flag_e070.

  IF lv_actv_flag_e070 EQ abap_true.
    INCLUDE zqtcn_restrict_copy_wo_item IF FOUND.
  ENDIF.
ENDENHANCEMENT.
