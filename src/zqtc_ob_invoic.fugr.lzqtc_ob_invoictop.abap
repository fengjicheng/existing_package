*----------------------------------------------------------------------*
* PROGRAM NAME:        LZQTC_OB_INVOICTOP
* PROGRAM DESCRIPTION: Flags to control Segment data population
*                      (Global Data Declarations)
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
FUNCTION-POOL zqtc_ob_invoic.               "MESSAGE-ID ..

*INCLUDE LZQTC_OB_INVOICD...                "Local class definition

DATA:
  v_e1edp05 TYPE flag.                      "Flag: IDOC Segment - E1EDP05
