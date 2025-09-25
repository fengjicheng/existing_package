*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTC_OB_INVOIC_SET_FLAGS
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
FUNCTION zqtc_ob_invoic_set_flags.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_E1EDP05) TYPE  FLAG OPTIONAL
*"----------------------------------------------------------------------

  v_e1edp05 = im_e1edp05.                   "Flag: IDOC Segment - E1EDP05

ENDFUNCTION.
