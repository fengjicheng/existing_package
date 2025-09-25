*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_NEW_PRC_VBAP (Include)
*               Called from "USEREXIT_NEW_PRICING_VBAP(MV45AFZB)"
* PROGRAM DESCRIPTION: This userexit can be used to perform new pricing,
*                      dependant on the change of datafields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   12/20/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K903817
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K903817
* REFERENCE NO:  E075
* DEVELOPER:  Writtick Roy (WROY)
* DATE:  2016-12-20
* DESCRIPTION:
* Change Tag :
* BOC by WROY on 20-Dec-2016 TR#ED2K903817
* EOC by WROY on 20-Dec-2016 TR#ED2K903817
*-----------------------------------------------------------------------*
* BOC by WROY on 20-Dec-2016 TR#ED2K903817
CONSTANTS:
  lc_wricef_id_e075 TYPE zdevid   VALUE 'E075',  " Development ID
  lc_ser_num_4_e075 TYPE zsno     VALUE '004'.   " Serial Number

DATA:
  lv_actv_flag_e075 TYPE zactive_flag.           " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e075
    im_ser_num     = lc_ser_num_4_e075
  IMPORTING
    ex_active_flag = lv_actv_flag_e075.

IF lv_actv_flag_e075 EQ abap_true.
  INCLUDE zqtcn_manage_discounts_02 IF FOUND.
ENDIF.
* EOC by WROY on 20-Dec-2016 TR#ED2K903817
