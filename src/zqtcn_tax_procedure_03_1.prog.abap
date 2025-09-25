*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_TAX_PROCEDURE_03_1 (INCLUDE Program)
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
  lv_sd_ar_process TYPE flag,                                   "Flag: SD/AR Process
  lv_tax_procedure TYPE kalsm_d.                                "Tax Procedure

* OneSource Tax Integration - SD/AR Process
CALL FUNCTION 'ZQTC_CHECK_SD_AR_PROCESS'
  IMPORTING
    ex_sd_ar_process = lv_sd_ar_process.                        "Flag: SD/AR Process
IF lv_sd_ar_process EQ abap_true.
* OneSource Tax Integration - Tax Procedure Determination
  CALL FUNCTION 'ZQTC_TAX_PROCEDURE_DET'
    EXPORTING
      im_land1 = t005-land1                                     "Country Key
    CHANGING
      ch_kalsm = lv_tax_procedure.                              "Tax Procedure
  IF lv_tax_procedure NE t005-kalsm.
    t005-kalsm = lv_tax_procedure.                              "Tax Procedure

*   Logic copied from standard Func Module: CHECK_JURISDICTION_ACTIVE
*   Description of Tax Jurisdiction Code Structure
    CLEAR ttxd.
    SELECT SINGLE * FROM ttxd WHERE kalsm = t005-kalsm.
    IF sy-subrc NE 0.
      e_isactive = space.
      e_external = space.
      e_xtxit    = space.
      CLEAR: e_rfcdest, e_rfcdest_ud.                     "added by RKUMAR2 SPS upgrade adjustment -ED1K910524
    ELSE.
      e_isactive = abap_true.
      IF ttxd-xextn NE space.
        e_external = abap_true.
      ELSE.
        e_external = space.
      ENDIF.
      e_xtxit = ttxd-xtxit.
      e_rfcdest    = ttxd-rfcdest.                        "added by RKUMAR2 SPS upgrade adjustment -ED1K910524
      e_rfcdest_ud = ttxd-rfcdest_ud.                     "added by RKUMAR2 SPS upgrade adjustment - ED1K910524
    ENDIF.
*    save_external = e_external.                         "commented  by RKUMAR2 SPS upgrade adjustment - ED1K910524
*    save_xtxit    = e_xtxit.                            "commented  by RKUMAR2 SPS upgrade adjustment - ED1K910524
    save_isactive = e_isactive.
    save_ttxd = ttxd.                                    "added by RKUMAR2 SPS upgrade adjustment - ED1K910524
    save_ttxd-xextn = e_external.                        "added by RKUMAR2 SPS upgrade adjustment - ED1K910524
  ENDIF.
ENDIF.
