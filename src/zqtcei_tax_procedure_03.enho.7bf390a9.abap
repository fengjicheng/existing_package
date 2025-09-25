"Name: \PR:SAPLTAX1\FO:BUKRS_LESEN\SE:END\EI
ENHANCEMENT 0 ZQTCEI_TAX_PROCEDURE_03.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_TAX_PROCEDURE_03 (Implicit Enhancement)
* PROGRAM DESCRIPTION: Sabrix Tax Integration
* Determine Tax Procedure for SD / AR scenario
* [Wiley has specific requirement to use different Tax Procedures for
* AP and AR/SD scenarios, so that AP uses SAP's Tax configurations;
* whereas AR/SD uses Sabrix (OneSource) for Tax calculations]
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   02/01/2017
* OBJECT ID: E038
* TRANSPORT NUMBER(S):  ED2K904223
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
  DATA:
    lv_act_f_e038 TYPE zactive_flag.                            "Active / Inactive Flag

  CONSTANTS:
    lc_devid_e038 TYPE zdevid   VALUE 'E038',                   "Development ID: E038
    lc_sno_e038_1 TYPE zsno     VALUE '001'.                    "Serial Number: 001

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_devid_e038                            "Development ID
      im_ser_num     = lc_sno_e038_1                            "Serial Number
    IMPORTING
      ex_active_flag = lv_act_f_e038.                           "Active / Inactive Flag
  IF lv_act_f_e038 EQ abap_true.                                "If Enhancement is not Active
    INCLUDE zqtcn_tax_procedure_03_3 IF FOUND.
  ENDIF.
ENDENHANCEMENT.
