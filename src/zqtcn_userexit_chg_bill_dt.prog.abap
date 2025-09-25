*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BILL_PLAN_BILLING_DATE (Include)
*               Called from "EXIT_SAPLV60F_001 (ZX60FU01)"
* PROGRAM DESCRIPTION: Update the Billing Date in Billing Plan
* DEVELOPER: Anirban Saha (ANISAHA)
* CREATION DATE:   08/22/2017
* OBJECT ID: E164
* TRANSPORT NUMBER(S): ED2K907158
*----------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO  : ED2K913451
* REFERENCE NO : CR7593/E164
* DEVELOPER    : Nageswara Polina (NPOLINA)
* DATE         : 2018-10-01
* DESCRIPTION  : Invoice ZF5 can not be created when material is UBCM
*-------------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO  : ED2K913989
* REFERENCE NO : CR7848/E164
* DEVELOPER    : Kiran Jagana(kjagana)
* DATE         : 2018-12-05
* DESCRIPTION  : ZSBP sales document type to be excluded from E107 and E164,
*while creating contract.
*-------------------------------------------------------------------------*
* Local Data declaration
  DATA:
    lv_actv_flag_e164  TYPE zactive_flag, "Active/Inactive Flag
    lv_actv_flag_e164_6  TYPE zactive_flag. "Active/Inactive Flag   "CR7593

* Local constant Declaration
  CONSTANTS:
    lc_wricef_id_e164 TYPE zdevid   VALUE 'E164',  "Development ID
    lc_sno_e164_003   TYPE zsno     VALUE '003',   "Serial Number
    lc_ser_num_e164_6 TYPE zsno     VALUE '006',   "For CR7593 NPOLINA
    lc_sno_e164_009   TYPE zsno     VALUE '009'.   "For CR7848 KJAGANA
    STATICS lv_flag_type TYPE char1 ."For CR7848 KJAGANA
*  * BOC by KJAGANA ERP7848 TR:   ED2K913989
* To check enhancement is active or not
    CLEAR :lv_flag_type.
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e164
        im_ser_num     = lc_sno_e164_009
      IMPORTING
        ex_active_flag = lv_actv_flag_e164.

    IF lv_actv_flag_e164 EQ abap_true.
      INCLUDE ZQTC_CONTRACT_TYPE_E164 IF FOUND.
      ELSE.
      lv_flag_type = abap_true.
    ENDIF.
    IF lv_flag_type eq abap_true.
*  * EOC by KJAGANA ERP7848 TR:   ED2K913989

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e164
      im_ser_num     = lc_sno_e164_003
    IMPORTING
      ex_active_flag = lv_actv_flag_e164.

  IF lv_actv_flag_e164 EQ abap_true.
    INCLUDE zqtcn_bill_plan_billing_date1 IF FOUND.
  ENDIF.

* SOC by NPOLINA CR7593 ED2K913451 20181001
IF t180-trtyp EQ 'H'.
* Check if enhancement needs to be triggered
  CLEAR : lv_actv_flag_e164_6.
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e164              "Constant value for WRICEF (E164)
      im_ser_num     = lc_ser_num_e164_6              "Serial Number (007)
    IMPORTING
      ex_active_flag = lv_actv_flag_e164_6.             "Active / Inactive flag
  IF lv_actv_flag_e164_6 EQ abap_true.
    INCLUDE zqtcn_restrict_publish_type IF FOUND.
  ENDIF.
ENDIF.
* EOC by NPOLINA CR7593 ED2K913451 20181001
ENDIF. "lv_flag eq abap_true by KJAGANA ERP7848 TR:   ED2K913989
