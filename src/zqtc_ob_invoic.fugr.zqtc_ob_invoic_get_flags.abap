*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTC_OB_INVOIC_GET_FLAGS
* PROGRAM DESCRIPTION: Flags to control Segment data population
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       01/25/2018
* OBJECT ID:           I0245
* TRANSPORT NUMBER(S): ED2K910501
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
FUNCTION zqtc_ob_invoic_get_flags.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EX_E1EDP05) TYPE  FLAG
*"----------------------------------------------------------------------

  ex_e1edp05 = v_e1edp05.                   "Flag: IDOC Segment - E1EDP05

ENDFUNCTION.
