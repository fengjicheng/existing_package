"Name: \PR:SAPFV45C\EX:FV45CF0V_VORLAGE_KOPIEREN_32\EI
ENHANCEMENT 0 ZQTCEI_MODIFY_SALES_AREA.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_MODIFY_SALES_AREA (Enhancement Implementation)
* PROGRAM DESCRIPTION: Populate Sales Area from IDOC instead of getting
*                      the values from the Reference Document (Quote)
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 28-June-2018
* OBJECT ID: I0341
* TRANSPORT NUMBER(S): ED2K912446
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_i0341 TYPE zdevid VALUE 'I0341',     "Constant value for WRICEF (I0341)
    lc_ser_num_i0341_3 TYPE zsno   VALUE '003'.       "Serial Number (003)

  DATA:
    lv_actv_flag_i0341 TYPE zactive_flag.             "Active / Inactive flag

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0341             "Constant value for WRICEF (I0341)
      im_ser_num     = lc_ser_num_i0341_3             "Serial Number (003)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0341.            "Active / Inactive flag

  IF lv_actv_flag_i0341 = abap_true.
    INCLUDE zqtcn_modify_sales_area_01 IF FOUND.
  ENDIF.
ENDENHANCEMENT.
