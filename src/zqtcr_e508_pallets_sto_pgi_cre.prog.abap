*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCR_PALLETS_STO_PGI_CREATE
* PROGRAM DESCRIPTION:Pallets return order STO, Picking,PGI creation
* DEVELOPER: Abhishek Ghosh(AGHOSH)
* CREATION DATE:   2022-05-06
* OBJECT ID: E508
* TRANSPORT NUMBER(S) ED2K927180
*-------------------------------------------------------------------*
REPORT zqtcr_e508_pallets_sto_pgi_cre.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
*Data declaration
INCLUDE zqtcr_e508_pallets_sto_pgi_top.
*Selection Screen
INCLUDE zqtcr_e508_pallets_sto_pgi_sel.
*Forms & Subroutines
INCLUDE zqtcr_e508_pallets_sto_pgi_sub.


*--------------------------------------------------------------------*
*   START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

*Fetch constant data from table ZCACONSTANT
  PERFORM f_get_constants.

*Authorization Check for STO &PGI
  PERFORM f_auth_check.

*STO creation based on Return Order
  IF rad1 EQ abap_true.

    PERFORM f_create_sto.
    PERFORM f_display_sto_data.

*Pallet Report
  ELSEIF rad2 EQ abap_true .
    PERFORM f_get_pallet_rpt.
    IF i_final[] IS NOT INITIAL.
      PERFORM f_build_fieldcatalog.
      PERFORM f_display_alv.
    ENDIF.

*Picking and PGI for STO
  ELSEIF rad3 EQ abap_true.
    PERFORM f_get_pgi_data.
    PERFORM f_create_pgi.
    PERFORM f_display_pgi_data.
  ENDIF.
