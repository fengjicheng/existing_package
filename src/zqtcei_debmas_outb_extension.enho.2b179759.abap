"Name: \PR:RBDSEDEB\EX:RBDSEDEB_01\EI
ENHANCEMENT 0 ZQTCEI_DEBMAS_OUTB_EXTENSION.
**********************************************************************
* The purpose of this enhancement is to get the entry of ZCACONSTANT
* in an include and fill it in Output structure(MESTYP_LIST)
* so that it gets displayed in the F4 help of field Output Type in transaction BD12.
*====================================================================*
* Data Declaration
*====================================================================*
  DATA : lv_active_stat TYPE zactive_flag. " Active / Inactive flag
*====================================================================*
* Local Constants
*====================================================================*
  CONSTANTS : lc_wricefid_i0202 TYPE zdevid VALUE 'I0202', " Constant value for WRICEF (I0202)
              lc_ser_num_001    TYPE zsno   VALUE '001'.   " Serial Number (001)

CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0202
    im_ser_num     = lc_ser_num_001
  IMPORTING
    ex_active_flag = lv_active_stat.

IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true.
* Include to implement logic for invoice interface.
  INCLUDE zqtcn_rbdsedeb_f4_enhancement IF FOUND.
ENDIF. " IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true

ENDENHANCEMENT.
