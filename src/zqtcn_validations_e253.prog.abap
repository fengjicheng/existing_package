*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_VALIDATIONS_E253 (Include Program)
* PROGRAM DESCRIPTION: Check whether Enhacement is active or not
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   07/15/2020
* WRICEF ID: E253
* TRANSPORT NUMBER(S): ED2K918906
* REFERENCE NO: ERPM-20026
*----------------------------------------------------------------------*

  DATA : lv_var_key_e253   TYPE zvar_key,                           " variable key
         lv_actv_flag_e253 TYPE zactive_flag.                       " Active / Inactive Flag

  CONSTANTS : lc_wricef_id_e253 TYPE zdevid VALUE 'E253',           " WRICEF ID
              lc_ser_num_e253   TYPE zsno   VALUE '001',            " Serial No
              lc_vd51           TYPE sy-tcode VALUE 'VD51',
              lc_vd52           TYPE sy-tcode VALUE 'VD52',
              lc_var_key_e253   TYPE zvar_key VALUE 'VD51_VD52'.

  " Check whether T-code is equal to Customer info record actions
  IF sy-tcode = lc_vd51 OR sy-tcode = lc_vd52.
    lv_var_key_e253 = lc_var_key_e253.
  ENDIF.

  " Check whether enhancement is active
  CALL FUNCTION 'ZCA_ENH_CONTROL'                   " Function Module for Enhancement status check
    EXPORTING
      im_wricef_id   = lc_wricef_id_e253
      im_ser_num     = lc_ser_num_e253
      im_var_key     = lv_var_key_e253
    IMPORTING
      ex_active_flag = lv_actv_flag_e253.

  IF lv_actv_flag_e253 EQ abap_true.                " E253 Enhancement is active,then apply the additional logic to validate the data
    INCLUDE zqtcn_validations_sub_e253 IF FOUND.    " Subroutine for addtional logic to validate the data
  ENDIF.
