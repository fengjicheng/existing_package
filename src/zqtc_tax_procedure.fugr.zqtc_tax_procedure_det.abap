*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_TAX_PROCEDURE_DET (Function Module)
* PROGRAM DESCRIPTION: Sabrix Tax Integration
* Determine Tax Procedure for the Country
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
FUNCTION zqtc_tax_procedure_det.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_LAND1) TYPE  LAND1
*"  CHANGING
*"     REFERENCE(CH_KALSM) TYPE  KALSM_D
*"----------------------------------------------------------------------

  DATA lst_const_val TYPE ty_caconst.
  IF i_caconst IS INITIAL.
*   Fetch details from Wiley Application Constant Table
    SELECT devid                    " Development ID
           param1                   " ABAP: Name of Variant Variable
           param2                   " ABAP: Name of Variant Variable
           low                      " Lower Value of Selection Condition
      FROM zcaconstant              " Wiley Application Constant Table
      INTO TABLE i_caconst
     WHERE devid    EQ c_devid_e038 "Development ID
       AND activate EQ abap_true.   "Activation indicator for constant
    IF sy-subrc EQ 0.
      SORT i_caconst BY devid param1 param2.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF i_caconst IS INITIAL

  CLEAR lst_const_val.
* Check for Specific Country
  READ TABLE i_caconst  INTO lst_const_val
       WITH KEY devid  = c_devid_e038 "Development ID
                param1 = c_tax_proc   "Name of Variant Variable: TAX_PROCEDURE
                param2 = im_land1     "Name of Variant Variable: Specific Country
       BINARY SEARCH.
  IF sy-subrc NE 0.
*   Check for Generic Country
    READ TABLE i_caconst INTO lst_const_val
         WITH KEY devid  = c_devid_e038 "Development ID
                  param1 = c_tax_proc   "Name of Variant Variable: TAX_PROCEDURE
                  param2 = space        "Name of Variant Variable: Generic Country
         BINARY SEARCH.
  ENDIF. " IF sy-subrc NE 0
  IF sy-subrc EQ 0.
    ch_kalsm = lst_const_val-low. "Tax Procedure
  ENDIF. " IF sy-subrc EQ 0

ENDFUNCTION.
