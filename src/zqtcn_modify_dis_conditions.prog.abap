*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MODIFY_DIS_CONDITIONS
*&---------------------------------------------------------------------*
IF vbak-auart = 'ZCR' AND sy-tcode = 'VA02'.

*  IF line_exists( xkomv[ kposn = vbap-posnr  kschl = 'ZPQA'] ) ."AND
*     line_exists( xkomv[ kposn = vbap-posnr kschl = 'PN00' kinak = 'X'] ).
    LOOP AT xkomv ASSIGNING FIELD-SYMBOL(<lfs_xkomv>) WHERE ( koaid = 'A' OR KOAID = 'B' ).
*      IF <lfs_xkomv>-kawrt NE vbap-kzwi1.
*        <lfs_xkomv>-kawrt = vbap-kzwi1.
        <lfs_xkomv>-updkz = 'U'.
        <lfs_xkomv>-ksteu = 'C'.
*        <lfs_xkomv>-kwert = ( vbap-kzwi1 * <lfs_xkomv>-kbetr ) / 1000.
*        <lfs_xkomv>-kwert =  <lfs_xkomv>-kwert / 100 .
**        <lfs_xkomv>-kbetr = ( <lfs_xkomv>-kwert / vbap-zmeng ) * 10 .
*      ENDIF.
    ENDLOOP.
*  ENDIF.


ENDIF.
