*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MV_FLDS_VBAK_VBAP (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the sales document header workaerea VBAK and
*                       also in VBAP
* DEVELOPER: Aratrika Banerjee(ARABANERJE)
* CREATION DATE:   10/17/2016
* OBJECT ID: E124
* TRANSPORT NUMBER(S):  ED2K903037
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MV_FLDS_VBAK_VBAP
*&---------------------------------------------------------------------*

*Assign the values to the field in the Delivery Document Header.
  likp-zzwhs      = vbak-zzwhs.
