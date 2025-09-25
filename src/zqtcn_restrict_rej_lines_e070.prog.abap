*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_RESTRICT_REJ_LINES(Include Program)
* PROGRAM DESCRIPTION: Restrict copying rejected lines to subsequent
* Document
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* CREATION DATE: 15-June-2021
* OBJECT ID: E070
* TRANSPORT NUMBER(S): ED2K923770
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_RESTRICT_REJ_LINES
*&---------------------------------------------------------------------*
*Restrict Copying Rejected lines to subsequent document
IF vbap-abgru NE space.
  bp_subrc = 1.
ENDIF.
