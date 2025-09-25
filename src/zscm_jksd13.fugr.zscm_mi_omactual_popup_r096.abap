FUNCTION ZSCM_MI_OMACTUAL_POPUP_R096.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_START_COLUMN) TYPE  I DEFAULT 10
*"     VALUE(IM_START_ROW) TYPE  I DEFAULT 10
*"     VALUE(IM_MEDIA_PRODUCT) TYPE  ISMREFMDPROD
*"     VALUE(IM_MEDIA_ISSUE) TYPE  MATNR
*"     VALUE(IM_PUB_DATE) TYPE  ISMPUBLDATE
*"     VALUE(IM_PLANT) TYPE  WERKS_D
*"     REFERENCE(IM_ADJUSTMENT) TYPE  CHAR13
*"     REFERENCE(IM_OMACTUAL) TYPE  NUMC13
*"  EXPORTING
*"     VALUE(E_OMACTUAL) TYPE  NUMC13
*"----------------------------------------------------------------------
* REVISION HISTORY---------------------------------------------------*
* REVISION NO: ED2K921719
* REFERENCE NO: OTCM-30221 (R096)
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE: 11-FEB-2021
* DESCRIPTION: LITHO Report OM Actual Pop-Up
*--------------------------------------------------------------------*
* REVISION HISTORY---------------------------------------------------*
* REVISION NO: ED2K923103
* REFERENCE NO: OTCM-30221 (R096)
* DEVELOPER: Thilina Dimantha (TDIMANTHA)
* DATE: 23-APR-2021
* DESCRIPTION: Fixing Refresh Issue
*--------------------------------------------------------------------*

  " Assign Material, Plant, Pub date, Product
  gv_matnr = im_media_issue.
  gv_plant = im_plant.
  gv_pubdate = im_pub_date.
  gv_product = im_media_product.
  gv_adjustment = im_adjustment.
*BOI ED2K923103 TDIMANTHA 23.04.2021
  gv_omactual = im_omactual.
*EOI ED2K923103 TDIMANTHA 23.04.2021

  " Call popup screen
  CALL SCREEN 9003 STARTING AT im_start_column im_start_row.

  " Pass Log Number
  e_omactual = gv_omactual.

  " Clear the Global variables
  CLEAR: gv_omactual, gv_matnr, gv_plant, gv_pubdate, gv_product,
         zscm_worklistlog.


ENDFUNCTION.
