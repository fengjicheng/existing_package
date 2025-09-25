"Name: \PR:RBDSEDEB\EX:RBDSEDEB_02\EI
ENHANCEMENT 0 ZQTCEI_DEBMAS_OUTB_EXTEN_02.
* The purpose of this enhancement is to check in an Include if the
* Reference Message type is same as the custom message type. If it
* fails an error message is displayed.

 DATA : lv_active_stat TYPE zactive_flag. " Active / Inactive flag

*====================================================================*
* Local Constants
*====================================================================*
  CONSTANTS : lc_wricefid_i0202 TYPE zdevid VALUE 'I0202', " Constant value for WRICEF (I0202)
              lc_ser_num_002    TYPE zsno   VALUE '002'.   " Serial Number (001)

CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0202
    im_ser_num     = lc_ser_num_002
  IMPORTING
    ex_active_flag = lv_active_stat.

IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true.
* Include to implement logic for invoice interface.
  INCLUDE zqtcn_rbdsedeb_f4_enhan_01 IF FOUND.
ENDIF. " IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true


ENDENHANCEMENT.
