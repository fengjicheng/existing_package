*&---------------------------------------------------------------------*
*&  Include  ZQTCN_MAT_STA_POTYPE_CHK_I0297
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------
* PROGRAM NAME        : ZQTCN_MAT_STA_POTYPE_CHK_I0297
* PROGRAM DESCRIPTION : To check the PO Types for material status check
* DEVELOPER           : PBANDLAPAL(Pavan Bandlapalli)
* CREATION DATE       : 15-Aug-2017
* OBJECT ID           : I0297 ( CR#632 )
* TRANSPORT NUMBER(S) : ED2K907834
* DESCRIPTION:  To allow the obsolete/discontinued materials to post the
*               idoc with out any error. we are converting the error to
*               information so that the idoc gets posted.
*----------------------------------------------------------------------
*----------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-----------------------------------------------------------------------*
CONSTANTS: lc_param1_potypmts    TYPE rvari_vnam VALUE 'POTYPE_MAT_STAT'.

DATA:
  r_zca_bsark_i0297  TYPE efg_tab_ranges,       " Range for PO Type
  lst_zcaconst_i0297 TYPE zcast_constant,
  li_zcaconst_i0297  TYPE zcat_constants.

CLEAR li_zcaconst_i0297.

CALL FUNCTION 'ZQTC_GET_ZCACONSTANT_ENT'
  EXPORTING
    im_devid         = lc_wricef_id_i0297   "lc_zdevid_i0297
  IMPORTING
    ex_t_zcacons_ent = li_zcaconst_i0297.

CLEAR r_zca_bsark_i0297.

LOOP AT li_zcaconst_i0297 INTO lst_zcaconst_i0297 WHERE param1 EQ lc_param1_potypmts.
  APPEND INITIAL LINE TO r_zca_bsark_i0297 ASSIGNING FIELD-SYMBOL(<fst_zca_bsark_i0297>).
  <fst_zca_bsark_i0297>-sign   = lst_zcaconst_i0297-sign.
  <fst_zca_bsark_i0297>-option = lst_zcaconst_i0297-opti.
  <fst_zca_bsark_i0297>-low    = lst_zcaconst_i0297-low.
  <fst_zca_bsark_i0297>-high   = lst_zcaconst_i0297-high.
ENDLOOP.

IF da_diakz IS INITIAL AND
   vbkd-bsark IN r_zca_bsark_i0297.
  da_diakz = chara.
ENDIF.
