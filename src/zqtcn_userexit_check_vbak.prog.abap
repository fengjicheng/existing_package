*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_CHECK_VBAK (Include)
*               Called from "USEREXIT_CHECK_VBAK(MV45AFZB)"
* PROGRAM DESCRIPTION: This Userexit can be used to add additional
*                      logic for checking the header for completeness
*                      and consistency.
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/21/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K902972
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MV_FLDS_KUNNR_VBAK_VBAP (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the sales document item workaerea VBAP
* DEVELOPER: Aratrika Banerjee(ARABANERJE)
* CREATION DATE:   10/17/2016
* OBJECT ID: E124
* TRANSPORT NUMBER(S):  ED2K903037
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MV_FLDS_KUNNR_VBAK_VBAP (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the sales document item workaerea VBAP
* DEVELOPER:
* CREATION DATE:
* OBJECT ID: E104
* TRANSPORT NUMBER(S):
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K919368
* REFERENCE NO    : Passing Sales to Party values like Customer group,
*                   Price List and shipping Condition to Sales Tab
* DEVELOPER       : VDPATABALL
* DATE            : 09/04/2020
* OBJECT ID       : OTCM-26188/E075
*------------------------------------------------------------------- *
CONSTANTS:
  lc_wricef_id_e124 TYPE zdevid   VALUE 'E124',  " Development ID
  lc_ser_num_1_e124 TYPE zsno     VALUE '001'.   " Serial Number

DATA:
  lv_actv_flag_e124 TYPE zactive_flag.           " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e124
    im_ser_num     = lc_ser_num_1_e124
  IMPORTING
    ex_active_flag = lv_actv_flag_e124.

IF lv_actv_flag_e124 EQ abap_true.
  INCLUDE zqtcn_mv_flds_kunnr_vbak_vbap IF FOUND. " Include ZQTCN_MV_FLDS_KUNNR_VBAK_VBAP
ENDIF.


* Data declaration
*& Constants
CONSTANTS:
  lc_wricef_id_e114 TYPE zdevid   VALUE 'E114',  " Development ID
  lc_ser_num_1_e114 TYPE zsno     VALUE '001'.   " Serial Number

DATA:
  lv_actv_flag_e114 TYPE zactive_flag .          " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e114
    im_ser_num     = lc_ser_num_1_e114
  IMPORTING
    ex_active_flag = lv_actv_flag_e114.

IF lv_actv_flag_e114 EQ abap_true.
  INCLUDE zqtcn_set_vol_year_product IF FOUND.
ENDIF.

* Begin of ADD:ERP-5265:WROY:19-Dec-2017:ED2K909954
CONSTANTS:
  lc_wricef_id_e095 TYPE zdevid   VALUE 'E095',  " Development ID
  lc_ser_num_4_e095 TYPE zsno     VALUE '004'.   " Serial Number

DATA:
* Begin of ADD:ERP-6121:WROY:23-Jan-2018:ED2K910449
  lv_var_key_e095   TYPE zvar_key,               " Variable Key
* End   of ADD:ERP-6121:WROY:23-Jan-2018:ED2K910449
  lv_actv_flag_e095 TYPE zactive_flag.           " Active / Inactive Flag

* Begin of ADD:ERP-6121:WROY:23-Jan-2018:ED2K910449
lv_var_key_e095 = vbak-vbtyp.                  " Variable Key = SD Document Category
* End   of ADD:ERP-6121:WROY:23-Jan-2018:ED2K910449
* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e095
    im_ser_num     = lc_ser_num_4_e095
*   Begin of ADD:ERP-6121:WROY:23-Jan-2018:ED2K910449
    im_var_key     = lv_var_key_e095
*   End   of ADD:ERP-6121:WROY:23-Jan-2018:ED2K910449
  IMPORTING
    ex_active_flag = lv_actv_flag_e095.

IF lv_actv_flag_e095 EQ abap_true.
  INCLUDE zqtcn_incompletion_check_e095 IF FOUND. " Include ZQTCN_INCOMPLETION_CHECK_E095
ENDIF.
* End   of ADD:ERP-5265:WROY:19-Dec-2017:ED2K909954

*CONSTANTS:
*  lc_wricef_id_e104 TYPE zdevid   VALUE 'E104', " Development ID
*  lc_ser_num_1_e104 TYPE zsno     VALUE '001'.  " Serial Number
*
*DATA:
*  lv_actv_flag_e104 TYPE zactive_flag.          " Active / Inactive Flag

* To check enhancement is active or not
*CALL FUNCTION 'ZCA_ENH_CONTROL'
*  EXPORTING
*    im_wricef_id   = lc_wricef_id_e104
*    im_ser_num     = lc_ser_num_1_e104
*  IMPORTING
*    ex_active_flag = lv_actv_flag_e104.
*
*IF lv_actv_flag_e104 EQ abap_true.
**  INCLUDE zqtcn_aut_rejct_vbap IF FOUND. " Include zqtcn_aut_rejct_vbap
*ENDIF.
*---Begin of Change VDPATABALL OTCM-26188 09/04/2020 passing Sold party values like customer group, Price List values to Sales Tab
* Data declaration
*& Constants
CONSTANTS:lc_wricef_id_e075 TYPE zdevid   VALUE 'E075',  " Development ID
          lc_ser_num_1_e075 TYPE zsno     VALUE '015'.   " Serial Number

DATA: lv_actv_flag_e075 TYPE zactive_flag .          " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e075
    im_ser_num     = lc_ser_num_1_e075
  IMPORTING
    ex_active_flag = lv_actv_flag_e075.

IF lv_actv_flag_e075 EQ abap_true.
  INCLUDE zqtcn_wls_vbkd_tofill_kuagv IF FOUND.
ENDIF.
*---End of Change VDPATABALL OTCM-26188 09/04/2020 passing Sold party values like customer group, Price List values to Sales Tab
