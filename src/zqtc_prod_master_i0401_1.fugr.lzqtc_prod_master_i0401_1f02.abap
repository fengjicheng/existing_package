*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_PROD_MASTER_I0401_1F02 (Include for PAI forms)
*               For Functional Group ZQTC_PROD_MASTER_I0401_1"
* PROGRAM DESCRIPTION: Add Custom fields to Product Master
*                      orders
* DEVELOPER: TDIMANTHA
* CREATION DATE: 03/02/2022
* OBJECT ID: I0401.1
* TRANSPORT NUMBER(S): ED2K925933
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SET_UUID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_set_uuid .

DATA: lv_uuid TYPE mara-zzstep_uuid.
  lv_uuid = mara-zzstep_uuid.
DATA(lv_maxh) = mara-maxh."VMAMILLAPA|15-Jul-2022
  CALL FUNCTION 'MARA_GET_SUB'
    IMPORTING
      wmara = mara
      xmara = *mara
      ymara = lmara.

  mara-zzstep_uuid = lv_uuid.
  mara-maxh = lv_maxh."VMAMILLAPA|15-Jul-2022

  CALL FUNCTION 'MARA_SET_SUB'
    EXPORTING
      wmara = mara.

ENDFORM.
