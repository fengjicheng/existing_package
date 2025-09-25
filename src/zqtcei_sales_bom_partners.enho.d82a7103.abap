"Name: \PR:SAPMV45A\EX:FCODE_BEARBEITEN_10\EI
ENHANCEMENT 0 ZQTCEI_SALES_BOM_PARTNERS.
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCEI_SALES_BOM_PARTNERS [Called from
*                      FCODE_BEARBEITEN (MV45AF0F_FCODE_BEARBEITEN)]
* PROGRAM DESCRIPTION: Copy Partner Detail from BOM Header to Components
* DEVELOPER(S):        Writtick Roy
* CREATION DATE:       08/04/2017
* OBJECT ID:           E134
* TRANSPORT NUMBER(S): ED2K907442
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912332
* REFERENCE NO:  E075
* DEVELOPER: RKUMAR2 (rkumar2)
* DATE:  11-MAY-2018
* DESCRIPTION: Stop loading 'Bill Plan' and 'Payment Cards' tab for
*              converted orders
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_e134 TYPE zdevid VALUE 'E134',         "Development ID
    lc_ser_num_e134_2 TYPE zsno   VALUE '002',          "Serial Number
    lc_wricef_id_e075 TYPE zdevid VALUE 'E075',         "Development ID "added by rkumar2
    lc_ser_num_e075_12 TYPE zsno   VALUE '012'.          "Serial Number "added by rkumar2


  DATA:
    lv_actv_flag_e234 TYPE zactive_flag,           "Active / Inactive Flag,
    lv_actv_flag_e075 TYPE zactive_flag,           " Active / Inactive Flag "added by rkumar2
    lv_varkey TYPE zvar_key.                       "added by rkumar2


* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e134
      im_ser_num     = lc_ser_num_e134_2
    IMPORTING
      ex_active_flag = lv_actv_flag_e234.

  IF lv_actv_flag_e234 EQ abap_true.
    INCLUDE zqtcn_sales_bom_partners IF FOUND.
  ENDIF. " IF lv_actv_flag EQ abap_true

"E075 check
lv_varkey = sy-tcode.
* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e075
    im_ser_num     = lc_ser_num_e075_12
    IM_VAR_KEY     = lv_varkey
  IMPORTING
    ex_active_flag = lv_actv_flag_e075.
IF lv_actv_flag_e075 EQ abap_true.
      INCLUDE zqtcn_screens_control IF FOUND.
ENDIF."activation check

ENDENHANCEMENT.
