"Name: \PR:SAPLV61A\EX:PRICING_COMPLETE_03\EI
ENHANCEMENT 0 ZQTCEI_PRICING_COMPLETE_01.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_PRICING_COMPLETE_01 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Store Global Attributes during Complete Pricing
*                      [Internal Table TKOMP will be needed for the
*                      logic BOM Price Allocation (specifically when
*                      Promo Code is applied)]
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   20-MAR-2018
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K911494
*----------------------------------------------------------------------*
    CONSTANTS:
      lc_wricef_id_e075 TYPE zdevid   VALUE 'E075',  " Development ID
      lc_ser_num_5_e075 TYPE zsno     VALUE '005'.   " Serial Number

    DATA:
      lv_actv_flag_e075 TYPE zactive_flag.           " Active / Inactive Flag

*   To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e075
        im_ser_num     = lc_ser_num_5_e075
      IMPORTING
        ex_active_flag = lv_actv_flag_e075.

    IF lv_actv_flag_e075 EQ abap_true.
      INCLUDE zqtcn_pricing_complete_01 IF FOUND.
    ENDIF.
ENDENHANCEMENT.
