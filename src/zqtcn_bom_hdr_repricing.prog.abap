*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BOM_HDR_REPRICING (Include)
* PROGRAM DESCRIPTION: Re-trigger Pricing
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   07-FEB-2018
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K911216
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
CONSTANTS:
  lc_prc_type_c  TYPE knprs      VALUE 'C'.           " Pricing Type: C

*  Header Level Pricing
IF vbkd-posnr IS NOT INITIAL AND
   vbap-posnr IS NOT INITIAL.
* BOM Header
  IF vbap-uepos IS INITIAL AND
     vbap-stlnr IS NOT INITIAL.
*   Change in Amount / Quantity
    IF vbap-kzwi3  NE *vbap-kzwi3 OR
       vbap-kwmeng NE *vbap-kwmeng.
*     Call the standard Subroutine for Repricing at the Header level
      PERFORM preisfindung_gesamt IN PROGRAM sapmv45a IF FOUND
        USING lc_prc_type_c.                              "Pricing Type: C
    ENDIF.
  ENDIF.
ENDIF.
