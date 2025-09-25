*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_JKSE01_SUPPRESS_ALV (Include)
* PROGRAM DESCRIPTION: Some of the Subroutines of JKSE01 is being called
*                      Custom Program which is being executed in B/G.
*                      During B/G execution, the standard logic tries to
*                      display ALV, that results in ABAP Dump.
*                      Solution: If the corresponding Variable for ALV
*                      is not yet instantiated, skip later steps
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 02-JUN-2017
* OBJECT ID: C075 (ERP-2572)
* TRANSPORT NUMBER(S): ED2K906452
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
IF maintenance IS INITIAL OR
   maintenance IS NOT BOUND.
  RETURN.
ENDIF.
