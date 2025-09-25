*&---------------------------------------------------------------------*
*&  Include           ZQTC_CREDIT_REP_GROUP_DETERMIN
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_CREDIT_REP_GROUP_DETERMIN (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit is used to update credit rep group
* (VBAK-SBGRP) by gathering payer information and Company code
* DEVELOPER: Randheer Kumar
* CREATION DATE:  March 26th, 2018
* OBJECT ID:       ERP-6968
* TRANSPORT NUMBER(S): ED2K911611
*----------------------------------------------------------------------*
DATA: lv_busab TYPE busab.

IF vbak-sbgrp IS INITIAL.
  "credit group is not identified yet
  IF vbak-knkli IS NOT INITIAL AND vbak-bukrs_vf IS NOT INITIAL.
    SELECT SINGLE busab
           FROM knb1
           INTO lv_busab
           WHERE kunnr = vbak-knkli
             AND bukrs = vbak-bukrs_vf.
    IF sy-subrc IS INITIAL AND lv_busab IS NOT INITIAL.
      vbak-sbgrp = lv_busab.
    ENDIF.
  ELSE.
    "Cant determine without customer credit account information and company code
  ENDIF.

ELSE.
  "looks like credit control group is already deretmined.. no need of re-determination
ENDIF.
