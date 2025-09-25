*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ENABLE_PROD_SUBS (Include Program)
* PROGRAM DESCRIPTION: Enable Product Susbstitution even when the Doc
*                      is being created with reference to another Doc
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 26-JUL-2018
* OBJECT ID: I0343 (ERP-6355/ERP-6344)
* TRANSPORT NUMBER(S): ED2K912804
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
IF tvsu-suerg   EQ space AND                          "Item will be replaced
   konddp_tab[] IS NOT INITIAL.                       "Product Substitution exists
* Remove "Copying control: Target sales document type", so that SAP
* logic allows the Product to be substituted
  CLEAR: tvcpa-auarn.
ENDIF. " IF tvsu-suerg EQ space AND
