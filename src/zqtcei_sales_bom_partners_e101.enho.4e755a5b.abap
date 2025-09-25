"Name: \PR:SAPLV45A\EX:SD_SALES_ITEM_MAINTAIN_16\EI
ENHANCEMENT 0 ZQTCEI_SALES_BOM_PARTNERS_E101.
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_SALES_BOM_PARTNERS_E101 [Enhancement]
* PROGRAM DESCRIPTION: Copy Partner Detail from BOM Header to Components
* DEVELOPER(S):        Writtick Roy
* CREATION DATE:       08/24/2017
* OBJECT ID:           E134
* TRANSPORT NUMBER(S): ED2K908155
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
    lc_wricef_id_e101 TYPE zdevid   VALUE 'E101',  " Development ID
    lc_ser_num_1_e101 TYPE zsno     VALUE '001'.   " Serial Number
  DATA:
    lv_actv_flag_e101 TYPE zactive_flag.           " Active / Inactive Flag
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e101
      im_ser_num     = lc_ser_num_1_e101
    IMPORTING
      ex_active_flag = lv_actv_flag_e101.

  IF lv_actv_flag_e101 EQ abap_true.
    INCLUDE zqtcn_sales_bom_partners_e101 IF FOUND.
  ENDIF.
ENDENHANCEMENT.
