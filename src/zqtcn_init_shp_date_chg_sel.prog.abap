*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTCE_INIT_SHP_DATE_CHG
* PROGRAM DESCRIPTION: Include for selection screen parameters and
* select options
* DEVELOPER: Writtick Roy/Monalisa Dutta
* CREATION DATE:   2017-01-11
* OBJECT ID: E147
* TRANSPORT NUMBER(S):ED2K904056(W)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: <Transport No>
* Reference No:  <DER or TPR or SCR>
* Developer:
* Date:  YYYY-MM-DD
* Description:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INIT_SHP_DATE_CHG_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
SELECT-OPTIONS:
  s_mtyp_i  FOR mara-mtart  OBLIGATORY, "Material Type
  s_stat_i  FOR mara-mstae. "Material Issue Status

SELECTION-SCREEN SKIP 1.
PARAMETERS:
  p_ts_upd TYPE char1 AS CHECKBOX.                         "Update TimeStamp Even If Error
SELECTION-SCREEN END OF BLOCK b1.
