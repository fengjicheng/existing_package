*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_PRC_PRP_TKOMP_B (Include)
*               Called from "USEREXIT_PRICING_PREPARE_TKOMP(RV60AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move additional
*                      fields into the communication table which is
*                      used for pricing: TKOMP for item fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   07/17/2017
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K907319
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MANAGE_DISCOUNTS_04
* PROGRAM DESCRIPTION: Populate Item Category
* DEVELOPER: Writtick Roy(WROY)
* CREATION DATE: 17-JUL-2017
* OBJECT ID: E075
* TRANSPORT NUMBER(S)ED2K907319
*----------------------------------------------------------------------*
* REVISION HISTORY ----------------------------------------------------*
* REVISION NO: ED2K913994
* REFERENCE NO: CR#7816
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 06-DEC-2018
* DESCRIPTION: Populate 'Business Partner-2 or Society number' and
* 'Relationship Category' for communication structure 'KOMK'
*----------------------------------------------------------------------*

CONSTANTS:
  lc_wricef_id_e075  TYPE zdevid   VALUE 'E075',  " Development ID
  lc_ser_num_1_e075  TYPE zsno     VALUE '001',   " Serial Number
*** BOC: CR#7816  KKRAVURI20181206  ED2K913994
  lc_ser_num_13_e075 TYPE zsno     VALUE '013',   " Serial Number_13
  lc_var_key_13      TYPE zvar_key VALUE 'VF01'. " Variable Key_13
*** EOC: CR#7816  KKRAVURI20181206  ED2K913994

DATA:
  lv_actv_flag_e075    TYPE zactive_flag, " Active / Inactive Flag
  lv_actv_flag_e075_13 TYPE zactive_flag. " Active/Inactive Flag   CR#7816  KKRAVURI20181206  ED2K913994


* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e075
    im_ser_num     = lc_ser_num_1_e075
  IMPORTING
    ex_active_flag = lv_actv_flag_e075.

IF lv_actv_flag_e075 EQ abap_true.
  INCLUDE zqtcn_manage_discounts_04 IF FOUND.
ENDIF. " IF lv_actv_flag_e075 EQ abap_true

*** BOC: CR#7816  KKRAVURI20181206  ED2K913994
* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e075
    im_ser_num     = lc_ser_num_13_e075
    im_var_key     = lc_var_key_13
  IMPORTING
    ex_active_flag = lv_actv_flag_e075_13.

IF lv_actv_flag_e075_13 EQ abap_true.
  INCLUDE zqtcn_manage_discounts_05 IF FOUND.
ENDIF. " IF lv_actv_flag_e075_13 EQ abap_true
*** EOC: CR#7816  KKRAVURI20181206  ED2K913994
