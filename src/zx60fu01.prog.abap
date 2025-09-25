*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BILL_PLAN_BILLING_DATE (Include)
*               Called from "EXIT_SAPLV60F_001 (ZX60FU01)"
* PROGRAM DESCRIPTION: Update the Billing Date in Billing Plan
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   07/09/2017
* OBJECT ID: E164
* TRANSPORT NUMBER(S): ED2K907158
*----------------------------------------------------------------------*
* PROGRAM NAME: zqtc_contract_type_e164_date (Include)
*               Called from "EXIT_SAPLV60F_001 (ZX60FU01)"
* PROGRAM DESCRIPTION: Update the Billing Date in Billing Plan
* DEVELOPER: KJAGANA(kiran jagana)
* CREATION DATE:   18/12/2018
* OBJECT ID: E164
* TRANSPORT NUMBER(S): ED2K914076
*----------------------------------------------------------------------*
* Local Data declaration
  DATA:
    lv_actv_flag_e164 TYPE zactive_flag .        "Active / Inactive Flag

* Local constant Declaration
  CONSTANTS:
    lc_wricef_id_e164 TYPE zdevid  VALUE 'E164', "Development ID
    lc_sno_e164_003   TYPE zsno    VALUE '003'.  "Serial Number

*  * BOC by KJAGANA ERP7848 TR:  ED2K914076
  CONSTANTS:lc_sno_e164_009   TYPE zsno    VALUE '009'.  "Serial Number
  STATICS lv_flag_type TYPE char1 .
* To check enhancement is active or not
  CLEAR :lv_flag_type.
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e164
      im_ser_num     = lc_sno_e164_009
    IMPORTING
      ex_active_flag = lv_actv_flag_e164.

  IF lv_actv_flag_e164 EQ abap_true.
    INCLUDE zqtc_contract_type_e164_date IF FOUND.
  ELSE.
    lv_flag_type = abap_true.
  ENDIF.
  IF lv_flag_type EQ abap_true.
*  * EOC by KJAGANA ERP7848 TR: ED2K914076
*   To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e164
        im_ser_num     = lc_sno_e164_003
      IMPORTING
        ex_active_flag = lv_actv_flag_e164.

    IF lv_actv_flag_e164 EQ abap_true.
      INCLUDE zqtcn_bill_plan_billing_date IF FOUND.
    ENDIF.
  ENDIF. "lv_flag eq abap_true by KJAGANA ERP7848 TR: ED2K914076
