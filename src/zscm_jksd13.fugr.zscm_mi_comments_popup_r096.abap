FUNCTION zscm_mi_comments_popup_r096.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_START_COLUMN) TYPE  I DEFAULT 10
*"     VALUE(IM_START_ROW) TYPE  I DEFAULT 10
*"     VALUE(IM_MEDIA_ISSUE) TYPE  MATNR
*"     VALUE(IM_PLANT) TYPE  WERKS_D
*"  EXPORTING
*"     VALUE(E_LOGNUMBER) TYPE  BALOGNR
*"----------------------------------------------------------------------
* REVISION HISTORY---------------------------------------------------*
* REVISION NO: ED2K919143
* REFERENCE NO: ERPM-837 (R096)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 21-AUG-2020
* DESCRIPTION: LITHO Report Comments Pop-Up
*--------------------------------------------------------------------*

  " Assign Material, Plant
  gv_matnr = im_media_issue.
  gv_plant = im_plant.

  " Call popup screen
  CALL SCREEN 9001 STARTING AT im_start_column im_start_row.

  " Pass Log Number
  e_lognumber = gv_lognumber.

  " Clear the Global variables
  CLEAR: gv_lognumber, gv_matnr, gv_plant,
         jksdmaterialstatus.


ENDFUNCTION.
