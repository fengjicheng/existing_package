*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_PRODUC_SUBSTITUTION (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_KOMPD(MV45AFZA)"
* PROGRAM DESCRIPTION: This include will perform product substition
*                      for a specific scenario where substituted material
*                      is a component ofthe parent material
* DEVELOPER: ANIRBAN SAHA
* CREATION DATE:   09/17/2017
* OBJECT ID: E096 / Defect 3528
* TRANSPORT NUMBER(S):  ED2K907576
*----------------------------------------------------------------------*

IF NOT vbap-uepos IS INITIAL.
  CLEAR: komkd, kompd, tvak-kalsu.
ENDIF.
