*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_TAX_PROCEDURE_03_2 (INCLUDE Program)
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
  lv_sd_ar_process TYPE flag,    "Flag: SD/AR Process
  lv_tax_procedure TYPE kalsm_d. "Tax Procedure

* OneSource Tax Integration - SD/AR Process
CALL FUNCTION 'ZQTC_CHECK_SD_AR_PROCESS'
  IMPORTING
    ex_sd_ar_process = lv_sd_ar_process. "Flag: SD/AR Process
IF lv_sd_ar_process EQ abap_true.
* OneSource Tax Integration - Tax Procedure Determination
  CALL FUNCTION 'ZQTC_TAX_PROCEDURE_DET'
    EXPORTING
      im_land1 = t005-land1        "Country Key
    CHANGING
      ch_kalsm = lv_tax_procedure. "Tax Procedure
  IF lv_tax_procedure NE t005-kalsm.
    t005-kalsm = schema = kalsm = lv_tax_procedure. "Tax Procedure

*   Logic copied from standard Func Module: FIND_TAX_SPREADSHEET
*   Description of Tax Jurisdiction Code Structure
    CLEAR ttxd.
    SELECT SINGLE * FROM ttxd WHERE kalsm = t005-kalsm.
    IF sy-subrc = 0.
      e_ttxd = ttxd. "2067930
      j = ttxd-leng1 + ttxd-leng2 + ttxd-leng3 + ttxd-leng4.
      i = ttxd-leng1.
      k = j - i.
      ASSIGN *ttxj-txjcd(i) TO <f3>.
      IF k > 0.
        ASSIGN *ttxj-txjcd+i(k) TO <r3>.
      ELSE. " ELSE -> IF k > 0
        ASSIGN cnull(1) TO <r3>.
      ENDIF. " IF k > 0
      CLEAR txctl.
      txctl-xtxit = ttxd-xtxit.
    ELSE. " ELSE -> IF sy-subrc = 0
      CLEAR e_ttxd. "2067930
      txctl-xmwsn = t001-xmwsn.
      txctl-xskfn = t001-xskfn.
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF lv_tax_procedure NE t005-kalsm
ENDIF. " IF lv_sd_ar_process EQ abap_true
