FUNCTION ZQTC_SET_MESCOD_IPS_I0379.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_MESCOD) TYPE  EDI_MESCOD OPTIONAL
*"--------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:  ZQTC_SET_MESCOD_IPS_I0379
* PROGRAM DESCRIPTION: Function module to set the Message Code global
*                      variable
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE:   2020-02-08
* OBJECT ID:I0379 (ERPM-11517)
* TRANSPORT NUMBER(S): ED2K917673
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*
  CLEAR v1_mescod.

  v1_mescod = im_mescod.


ENDFUNCTION.
