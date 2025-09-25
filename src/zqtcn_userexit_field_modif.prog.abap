*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_FIELD_MODIF (Include)
*               Called from "USEREXIT_FIELD_MODIFICATION (MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the sales dokument header workaerea VBAK
* DEVELOPER: Lucky Kodwani (LKODWANI)
* CREATION DATE:   11/08/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K902972
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906642
* REFERENCE NO:  E161
* DEVELOPER:  Writtick Roy (WROY)
* DATE:  2017-06-23
* DESCRIPTION: Order Reasons by Document Type
* Change Tag :
* Begin of ADD:E161:WROY:23-JUN-2017:ED2K906642
* End   of ADD:E161:WROY:23-JUN-2017:ED2K906642
*-----------------------------------------------------------------------*
***********E0112
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911531
* REFERENCE NO:  E075
* DEVELOPER:  Agudurkhad
* DATE:  2018-03-25
* DESCRIPTION: Disable item qty and item category for converted Orders
* Change Tag :
* Begin of ADD:E075:Agudurkhad:2018-03-25:ED2K911531
* End   of ADD:E075:Agudurkhad:2018-03-25:ED2K911531
*-----------------------------------------------------------------------*
* Developer : Siva Guda (SGUDA)
* CHANGE DESCRIPTION : To exclude enhancements selectively for any
*                      specific user
* CREATION DATE:  09-10-2018
* OBJECT ID:  E181
* TRANSPORT NUMBER(S):ED2K912979
*----------------------------------------------------------------------*
CONSTANTS:
  lc_wricef_id_e112 TYPE zdevid   VALUE 'E112', " Development ID
  lc_ser_num_1_e112 TYPE zsno     VALUE '001'.
" Serial Number

*DATA:
STATICS:
  lv_actv_flag_e112 TYPE zactive_flag.
   " Active / Inactive Flag

* Begin of ADD:SAP's Recommendations:WROY:06-NOV-2017:ED2K909331
IF lv_actv_flag_e112 IS INITIAL.
* End   of ADD:SAP's Recommendations:WROY:06-NOV-2017:ED2K909331
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e112
      im_ser_num     = lc_ser_num_1_e112
    IMPORTING
      ex_active_flag = lv_actv_flag_e112.
* Begin of ADD:SAP's Recommendations:WROY:06-NOV-2017:ED2K909331
  IF lv_actv_flag_e112 IS INITIAL.
    lv_actv_flag_e112 = abap_undefined.
  ENDIF.
ENDIF.
* End   of ADD:SAP's Recommendations:WROY:06-NOV-2017:ED2K909331
IF lv_actv_flag_e112 EQ abap_true.
  INCLUDE zqtcn_non_edit_ihrez IF FOUND. " Include zqtcn_aut_rejct_vbak
ENDIF. " IF lv_actv_flag_e112 EQ abap_true

* Begin of ADD:E161:WROY:23-JUN-2017:ED2K906642
CONSTANTS:
  lc_wricef_id_e161 TYPE zdevid VALUE 'E161',       "Constant value for WRICEF (E161)
  lc_ser_num_e161   TYPE zsno   VALUE '001'.        "Serial Number (001)

*DATA:
STATICS:
  lv_actv_flag_e161 TYPE zactive_flag.              "Active / Inactive flag

* Begin of ADD:SAP's Recommendations:WROY:06-NOV-2017:ED2K909331
IF lv_actv_flag_e161 IS INITIAL.
* End   of ADD:SAP's Recommendations:WROY:06-NOV-2017:ED2K909331
* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e161            "Constant value for WRICEF (E161)
      im_ser_num     = lc_ser_num_e161              "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_e161.           "Active / Inactive flag
* Begin of ADD:SAP's Recommendations:WROY:06-NOV-2017:ED2K909331
  IF lv_actv_flag_e161 IS INITIAL.
    lv_actv_flag_e161 = abap_undefined.
  ENDIF.
ENDIF.
* End   of ADD:SAP's Recommendations:WROY:06-NOV-2017:ED2K909331
** Begin of ADD: OTCM-77858 Disable contract start and end dates in VA42POC
*CONSTANTS:lc_wricef_id_e386  TYPE zdevid   VALUE 'E386', " Development ID
*          lc_ser_num_1_e386  TYPE zsno     VALUE '001'.  " Serial Number
*STATICS:lv_actv_flag_e386 TYPE zactive_flag.
*CLEAR:lv_actv_flag_e386.
*IF lv_actv_flag_e386 IS INITIAL.
** To check enhancement is active or not
*  CALL FUNCTION 'ZCA_ENH_CONTROL'
*    EXPORTING
*      im_wricef_id   = lc_wricef_id_e386
*      im_ser_num     = lc_ser_num_1_e386
*    IMPORTING
*      ex_active_flag = lv_actv_flag_e386.
*  IF lv_actv_flag_e386 EQ abap_true.
*    INCLUDE zqtcn_non_edit_contract_dates.
*  ENDIF.
*ENDIF.
** End of ADD: OTCM-77858 Disable contract start and end dates in VA42POC

IF lv_actv_flag_e161 = abap_true.
  INCLUDE zqtcn_ord_res_by_doc_typ_01 IF FOUND.
ENDIF. "IF lv_actv_flag_E161 = abap_true
* End   of ADD:E161:WROY:23-JUN-2017:ED2K906642

* Begin of ADD:E075:Agudurkhad:2018-03-25:ED2K911531

CONSTANTS:
  lc_wricef_id_e075  TYPE zdevid   VALUE 'E075', " Development ID
  lc_ser_num_10_e075 TYPE zsno     VALUE '010'. " Serial Number
*  lc_var_key_1_e075 TYPE  zvar_key  VALUE 'ALLOW_PRICE_OVERRIDE'.

STATICS:
  lv_actv_flag_e075 TYPE zactive_flag. " Active / Inactive Flag


IF lv_actv_flag_e075 IS INITIAL.

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e075            "Constant value for WRICEF (E075)
      im_ser_num     = lc_ser_num_10_e075              "Serial Number (010)
    IMPORTING
      ex_active_flag = lv_actv_flag_e075.           "Active / Inactive flag

  IF lv_actv_flag_e075 IS INITIAL.
    lv_actv_flag_e075 = abap_undefined.
  ENDIF.
ENDIF.

IF lv_actv_flag_e075 = abap_true.
  INCLUDE zqtcn_ord_disable_qty_item_cat IF FOUND.
ENDIF.
* End of ADD:E075:Agudurkhad:2018-03-25:ED2K911531
* Begin of ADD:E181:SGUDA:10-SEP-2018:ED2K912979
**Local variable and constant declaration
*CONSTANTS:
*  lc_wricef_id_e181 TYPE zdevid VALUE 'E181',      "Constant value for WRICEF (E181)
*  lc_ser_num_e181_1 TYPE zsno   VALUE '001'.       "Serial Number (001)
*DATA:
*  lv_actv_flag_e181 TYPE zactive_flag.             "Active / Inactive flag "ADD:E181:SGUDA:10-SEP-2018:ED2K912979
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e181             "Constant value for WRICEF (E181)
    im_ser_num     = lc_ser_num_e181_1             "Serial Number (001)
  IMPORTING
    ex_active_flag = lv_actv_flag_e181.            "Active / Inactive flag
IF lv_actv_flag_e181 = abap_true.
  INCLUDE zqtc_enh_exlude_e181_get IF  FOUND.
ENDIF.
* End of ADD:E181:SGUDA:10-SEP-2018:ED2K912979

**Begin of POC-Vishnu
data:lt_vrm_values TYPE vrm_values,
     lst_vrm_values TYPE LINE OF vrm_values.
refresh lt_vrm_values[].
  IF vbak-auart = 'ZCOP'.

lst_vrm_values-key = '08'.
lst_vrm_values-text = 'Member'.
append lst_vrm_values to lt_vrm_values.
CLEAR lst_vrm_values.

lst_vrm_values-key = '41'.
lst_vrm_values-text = 'CHIEF_EDITOR'.
append lst_vrm_values to lt_vrm_values.
CLEAR lst_vrm_values.

lst_vrm_values-key = '42'.
lst_vrm_values-text = 'EDITORIAL_BOARD'.
append lst_vrm_values to lt_vrm_values.
CLEAR lst_vrm_values.

*     Value Request Manager: Set new Values for Valueset
      CALL FUNCTION 'VRM_SET_VALUES'
        EXPORTING
          id              = 'VBKD-KDKG4'                            "Name of Value Set
          values          = lt_vrm_values                           "Value table
        EXCEPTIONS
          id_illegal_name = 1
          OTHERS          = 2.
      IF sy-subrc EQ 0.
*       Nothing to do
      ENDIF.

  ENDIF.
**End of POC-Vishnu
