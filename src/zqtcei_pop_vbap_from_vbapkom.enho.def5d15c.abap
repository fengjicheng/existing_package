"Name: \PR:SAPFV45P\EX:VBAP_FUELLEN_VBAPKOM_13\EI
ENHANCEMENT 0 ZQTCEI_POP_VBAP_FROM_VBAPKOM.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_POP_VBAP_FROM_VBAPKOM (Enhancement)
* PROGRAM DESCRIPTION: Populate VBAP fields from VBAPKOM
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   10/13/2018
* OBJECT ID:       E131 (INC0205683)
* TRANSPORT NUMBER(S): ED1K908183
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_e131 TYPE zdevid VALUE 'E131',  "Constant value for WRICEF (E131)
    lc_ser_num_e131_3 TYPE zsno   VALUE '003'.   "Serial Number (003)

  DATA:
    lv_actv_flag_e131 TYPE zactive_flag.         "Active / Inactive flag

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e131  "Constant value for WRICEF (E131)
      im_ser_num     = lc_ser_num_e131_3  "Serial Number (003)
    IMPORTING
      ex_active_flag = lv_actv_flag_e131. "Active / Inactive flag

  IF lv_actv_flag_e131 = abap_true.
    INCLUDE zqtcn_pop_vbap_from_vbapkom IF FOUND.
  ENDIF.
ENDENHANCEMENT.
