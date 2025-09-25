*----------------------------------------------------------------------*
***INCLUDE LZQTC_TAXCALI01.
*----------------------------------------------------------------------*
* PROGRAM DESCRIPTION : Include for ZQTC_TAXCAL SM30 validations       *
* DEVELOPER           : VMAMILLAPA (Vamsi Mamillapalli)                *
* CREATION DATE       : 2022-04-28                                     *
* OBJECT ID           : I0502.1/EAM-3116                               *
* TRANSPORT NUMBER(S) : ED2K926349                                     *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  CHECK_DATES  INPUT
*&---------------------------------------------------------------------*
*      Validation for dates
*----------------------------------------------------------------------*
MODULE check_dates INPUT.
  IF zqtc_taxcal-datab GE zqtc_taxcal-datbi .
    MESSAGE e266(zqtc_r2)."Validity from date should be less than validity to date.
  ENDIF.

ENDMODULE.
