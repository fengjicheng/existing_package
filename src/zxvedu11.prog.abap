*&---------------------------------------------------------------------*
*&  Include           ZXVEDU11
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU11(Include Program for Methods)
* PROGRAM DESCRIPTION:
* Update Bill-to Email ID to “AR Internal Notes’ along with existing text in header text.
* Check the text with reference to object VBBK ID:0005 in idoc
* if exist append the bill to email id to the text.
* else read existing text with reference to Object: KNVV, ID:0005 and BP number
* and append the bill to email id to the text.
* DEVELOPER: mimmadiset(Murali)
* CREATION DATE:   07/12/2021
* OBJECT ID:  E263/OTCM-45037
* TRANSPORT NUMBER(S):ED2K924060
*----------------------------------------------------------------------*
*BOC by Murali on 07/10/2021 for OTCM-45037 with  ED2K924060*.
CONSTANTS: lc_wricef_id_e263 TYPE zdevid VALUE 'E263',  " Constant value for WRICEF (E263)
           lc_ser_num_e263   TYPE zsno   VALUE '003'.   " Serial Number (003)

DATA: lv_var_key_e263   TYPE zvar_key,     " Variable Key
      lv_actv_flag_e263 TYPE zactive_flag. " Active / Inactive flag

* Populate Variable Key
READ TABLE dedidc INTO DATA(ls_edidc) INDEX 1.
IF sy-subrc = 0.
  lv_var_key_e263 = ls_edidc-mescod.           " Message variant Z12

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e263    " Constant value for WRICEF (E263)
      im_ser_num     = lc_ser_num_e263      " Serial Number (001)
      im_var_key     = lv_var_key_e263      " Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_e263.   " Active / Inactive flag

  IF lv_actv_flag_e263 = abap_true.
    INCLUDE zqtcn_ord_bdc_text_e263_3 IF FOUND.
  ENDIF.
ENDIF.
*EOC by Murali on 07/10/2021 for OTCM-45037 with  ED2K924060*
