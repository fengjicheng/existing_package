*&---------------------------------------------------------------------*
*&  Include           ZQTCN_UPDATE_TKOMK_FIELDS
*&---------------------------------------------------------------------*
* REVISION NO : ED2K927026
* REFERENCE NO: EAM-8813 / E507
* DEVELOPER   : Vamsi Mamillapalli(VMAMILLAPA)
* DATE        : 2022-05-10
* DESCRIPTION : Adding SPDNR to pricing structure TKOMK
*----------------------------------------------------------------------*
CONSTANTS: lc_devid_507 TYPE zdevid VALUE 'E507',
           lc_vkorg     TYPE rvari_vnam VALUE 'VKORG',
           lc_vtweg     TYPE rvari_vnam VALUE 'VTWEG',
           lc_spart     TYPE rvari_vnam VALUE 'SPART',
           lc_parvw     TYPE rvari_vnam VALUE 'PARVW'.

DATA: li_const_507 TYPE ztca_caconstants,
      lv_parvw_507 TYPE parvw.

SELECT *
  FROM zcaconstant
  INTO TABLE li_const_507
  WHERE devid = lc_devid_507.
IF sy-subrc IS INITIAL.
  IF line_exists( li_const_507[ param1 = lc_vkorg low = vbak-vkorg ] ) AND
    line_exists( li_const_507[ param1 = lc_vtweg low = vbak-vtweg ] ) AND
    line_exists( li_const_507[ param1 = lc_spart low = vbak-spart ] ).
    IF line_exists( li_const_507[ param1 = lc_parvw ] ) .
      lv_parvw_507 = li_const_507[ param1 = lc_parvw ]-low.
      IF line_exists( xvbpa[ parvw = lv_parvw_507 ] ).
        tkomk-spdnr = xvbpa[ parvw = lv_parvw_507 ]-lifnr.
      ENDIF.
    ENDIF.

  ENDIF.
ENDIF.
