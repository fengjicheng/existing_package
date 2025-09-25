*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_TAX_PROCEDURE_01 (INCLUDE Program)
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
* Read t005 (Countries)
  IF t005-land1 NE t001-land1.
    CLEAR t005.
    t005-land1 = t001-land1.
    SELECT SINGLE * FROM t005 WHERE land1 = t001-land1.
  ENDIF.

* OneSource Tax Integration - Tax Procedure Determination
  CALL FUNCTION 'ZQTC_TAX_PROCEDURE_DET'
    EXPORTING
      im_land1 = t005-land1                                     "Country Key
    CHANGING
      ch_kalsm = t005-kalsm.                                    "Tax Procedure
