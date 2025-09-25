*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_CHECK_VBAP (Include)
*               Called from "USEREXIT_CHECK_VBAP(MV45AFZB)"
* PROGRAM DESCRIPTION: This Userexit can be used to add additional
*                      logic for checking the position for completeness
*                      and consistency.
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   04/17/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K905432
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USAGE_IND_MAT_GRP4 (Include)
*               Called from "USEREXIT_CHECK_VBAP(MV45AFZB)"
* PROGRAM DESCRIPTION: Map Material Group 4 from Usage Indicator for
*                      CSS Orders
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   04/17/2016
* OBJECT ID: E038
* TRANSPORT NUMBER(S):  ED2K905432
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906687
* REFERENCE NO:  CR 503
* DEVELOPER:   APATNAIK
* DATE:  2017-06-13
* DESCRIPTION: In order to trigger a down payment request or proforma
*              for CSS, a CSR must change the item category on the order
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K905792
* REFERENCE NO:  E075
* DEVELOPER:   Writtick Roy (WROY)
* DATE:  2017-08-08
* DESCRIPTION: Recalculate Price for BOM
*----------------------------------------------------------------------*
* Local Data declaration
  DATA:
    lv_actv_flag_e038 TYPE zactive_flag ,        "Active / Inactive Flag
*Begin of CHANGE:CR#503:APATNAIK:13-JUNE-2017:ED2K906687
    lv_actv_flag_e060 TYPE zactive_flag .        "Active / Inactive Flag
*End of CHANGE:CR#503:APATNAIK:13-JUNE-2017:ED2K906687

*Local constant Declaration
  CONSTANTS:
    lc_wricef_id_e038 TYPE zdevid  VALUE 'E038', "Development ID
    lc_sno_e038_002   TYPE zsno    VALUE '001',  "Serial Number
*Begin of CHANGE:CR#503:APATNAIK:13-JUNE-2017:ED2K906687
    lc_wricef_id_e060 TYPE zdevid  VALUE 'E060', "Development ID
    lc_sno_e060_002   TYPE zsno    VALUE '001'.  "Serial Number
*End of CHANGE:CR#503:APATNAIK:13-JUNE-2017:ED2K906687


* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e038
      im_ser_num     = lc_sno_e038_002
    IMPORTING
      ex_active_flag = lv_actv_flag_e038.

  IF lv_actv_flag_e038 EQ abap_true.
    INCLUDE zqtcn_usage_ind_mat_grp4 IF FOUND.
  ENDIF.

*Begin of CHANGE:CR#503:APATNAIK:13-JUNE-2017:ED2K906687
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e060
      im_ser_num     = lc_sno_e060_002
    IMPORTING
      ex_active_flag = lv_actv_flag_e060.

  IF lv_actv_flag_e060 EQ abap_true.
    INCLUDE zqtcn_item_rest IF FOUND.
  ENDIF.

*End of CHANGE:CR#503:APATNAIK:13-JUNE-2017:ED2K906687

* Begin of ADD:E075:WROY:08-AUG-2017:ED2K907469
  CONSTANTS:
    lc_wricef_id_e075 TYPE zdevid   VALUE 'E075',  " Development ID
    lc_ser_num_7_e075 TYPE zsno     VALUE '007'.   " Serial Number

  DATA:
    lv_actv_flag_e075 TYPE zactive_flag.           " Active / Inactive Flag

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e075
      im_ser_num     = lc_ser_num_7_e075
    IMPORTING
      ex_active_flag = lv_actv_flag_e075.

  IF lv_actv_flag_e075 EQ abap_true.
    INCLUDE zqtcn_bom_pricing_04 IF FOUND.
  ENDIF.
* End   of ADD:E075:WROY:08-AUG-2017:ED2K907469
