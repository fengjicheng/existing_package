*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_PRC_PREP_TKOMK (Include)
*               Called from "USEREXIT_PRICING_PREPARE_TKOMK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move additional
*                      fields into the communication table which is
*                      used for pricing: TKOMK for header fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/21/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K903817
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MANAGE_DISCOUNTS_01
* PROGRAM DESCRIPTION: Replace Pricing Customer Group, Price List
* DEVELOPER: Writtick Roy(WROY)
* CREATION DATE: 10-NOV-2016
* OBJECT ID: E075
* TRANSPORT NUMBER(S)ED2K903315
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K927219
* REFERENCE NO:EAM-8813 / E507
* DEVELOPER: Vamsi Mamillapalli(VMAMILLAPA)
* DATE:  2022-05-10
* DESCRIPTION:Adding SPDNR to pricing structure TKOMK
*----------------------------------------------------------------------*
CONSTANTS:
  lc_wricef_id_e075 TYPE zdevid   VALUE 'E075',  " Development ID
  lc_ser_num_1_e075 TYPE zsno     VALUE '001',   " Serial Number
* BOC VMAMILLAPA EAM-8813 10-May-2022 ED2K927219
  lc_wricef_id_e507 TYPE zdevid   VALUE 'E507',  " Development ID
  lc_ser_num_2_e507 TYPE zsno     VALUE '002'.   " Serial Number
* EOC VMAMILLAPA EAM-8813 10-May-2022 ED2K927219
DATA:
  lv_actv_flag_e075 TYPE zactive_flag,           " Active / Inactive Flag
  lv_actv_flag_e507 TYPE zactive_flag.           " Active / Inactive Flag
*      "VMAMILLAPA EAM-8813 10-May-2022 ED2K927219
* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e075
    im_ser_num     = lc_ser_num_1_e075
  IMPORTING
    ex_active_flag = lv_actv_flag_e075.

IF lv_actv_flag_e075 EQ abap_true.
  INCLUDE zqtcn_manage_discounts_03 IF FOUND.
ENDIF.
* BOC VMAMILLAPA EAM-8813 10-May-2022 ED2K927219
* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e507
    im_ser_num     = lc_ser_num_2_e507
  IMPORTING
    ex_active_flag = lv_actv_flag_e507.

IF lv_actv_flag_e507 EQ abap_true.
  INCLUDE zqtcn_update_tkomk_fields IF FOUND.
ENDIF.
* EOC VMAMILLAPA EAM-8813 10-May-2022 ED2K927219

*POC for GOLD/SILVER Plan
*Begin of change
MOVE vbak-bstzd TO tkomk-zzbstzd.
*End of change

*--*Profiles
tkomk-zzkvgr2 = vbak-kvgr2.
tkomk-zzkvgr3 = vbak-kvgr3.
