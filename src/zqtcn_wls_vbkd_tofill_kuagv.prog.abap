*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_VBKD_TOFILL_KUAGV
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_WLS_VBKD_TOFILL_KUAGV
* PROGRAM DESCRIPTION : Passing Sold to Party values like Customer group,
*                       Price List to Sales Tab(VBKD)
* DEVELOPER           : VDPATABALL
* CREATION DATE       : 09/04/2020
* OBJECT ID           : OTCM-26188/E075
* TRANSPORT NUMBER(S) : ED2K919368
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
DATA:lst_vkorg_range TYPE fip_s_vkorg_range,
     lir_vkorg_range TYPE fip_t_vkorg_range,
     lst_spart_range TYPE fip_s_spart_range,
     lst_vtweg_range TYPE fip_s_vtweg_range,
     lir_vtweg_range TYPE fip_t_vtweg_range,
     lir_spart_range TYPE fip_t_spart_range,
     li_constant     TYPE zcat_constants.

CONSTANTS:lc_dev_e075 TYPE zdevid      VALUE 'E075',
          lc_auart    TYPE rvari_vnam  VALUE 'AUART',                    "Parameter: Order Type
          lc_vkorg    TYPE rvari_vnam  VALUE 'VKORG',                    "Parameter: Sale Org
          lc_spart    TYPE rvari_vnam  VALUE 'SPART',                    "Parameter: Division
          lc_vtweg    TYPE rvari_vnam  VALUE 'VTWEG',                    "Parameter: Distribution channnel
          lc_create   TYPE char1       VALUE 'H'.

IF t180-trtyp = lc_create .  "Create Scenario only

  FREE:lst_vkorg_range,
       lir_vkorg_range,
       lst_spart_range,
       lst_vtweg_range,
       lir_vtweg_range,
       lir_spart_range,
       li_constant.

*--check the t Code type.

* Fetch Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_dev_e075                           "Development ID
    IMPORTING
      ex_constants = li_constant.                         "Constant Values


  LOOP AT li_constant INTO DATA(lst_constants).
    CASE lst_constants-param1.
      WHEN lc_vkorg.
        lst_vkorg_range-sign     = lst_constants-sign.
        lst_vkorg_range-option   = lst_constants-opti.
        lst_vkorg_range-low      = lst_constants-low.
        APPEND lst_vkorg_range TO lir_vkorg_range.
        CLEAR: lst_vkorg_range.
      WHEN lc_spart.
        lst_spart_range-sign     = lst_constants-sign.
        lst_spart_range-option   = lst_constants-opti.
        lst_spart_range-low      = lst_constants-low.
        APPEND lst_spart_range TO lir_spart_range.
        CLEAR: lst_spart_range.
      WHEN lc_vtweg.
        lst_vtweg_range-sign     = lst_constants-sign.
        lst_vtweg_range-option   = lst_constants-opti.
        lst_vtweg_range-low      = lst_constants-low.
        APPEND lst_vtweg_range TO lir_vtweg_range.
        CLEAR: lst_vtweg_range.
    ENDCASE.
  ENDLOOP.

*--check Sales Org,Division and Distribution
  IF vbak-vkorg IN lir_vkorg_range
    AND vbak-spart IN lir_spart_range
    AND vbak-vtweg IN lir_vtweg_range.
*----Moving Price List and Customer Group values to VBKD
    IF kuagv-pltyp NE kuwev-pltyp.
      vbkd-pltyp = kuagv-pltyp.  "Price list
    ENDIF.
    IF kuagv-kdgrp NE kuwev-kdgrp.
      vbkd-kdgrp = kuagv-kdgrp.  "Cutsomer Group
    ENDIF.
  ENDIF.
ENDIF.
