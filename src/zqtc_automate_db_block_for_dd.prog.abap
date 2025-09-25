*&---------------------------------------------------------------------*
*& Report  ZQTC_AUTOMATE_DB_BLOCK_FOR_DD
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtc_automate_db_block_for_dd.

DATA: lst_erdat TYPE tds_rg_erdat,
      lt_const  TYPE  zcat_constants,
      lr_auart  TYPE TABLE OF tds_rg_auart,
      lr_vkorg  TYPE TABLE OF range_vkorg,
      lr_zlsch  TYPE TABLE OF trty_rng_zlsch.

SELECTION-SCREEN: BEGIN OF BLOCK b1.
SELECT-OPTIONS: s_erdat FOR sy-datum.
SELECTION-SCREEN: END OF BLOCK b1.

AT SELECTION-SCREEN OUTPUT.
  lst_erdat-sign = 'I'.
  lst_erdat-option = 'BT'.
  lst_erdat-low = sy-datum - 7 .
  lst_erdat-high = sy-datum.
  APPEND lst_erdat TO s_erdat.

  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = 'ZADBDD'
    IMPORTING
      ex_constants = lt_const.
  LOOP AT lt_const ASSIGNING FIELD-SYMBOL(<lfs_const>).
    CASE <lfs_const>-param1.
      WHEN 'AUART'.
        APPEND INITIAL LINE TO lr_auart ASSIGNING FIELD-SYMBOL(<lfs_auart_i>).
        <lfs_auart_i>-sign = <lfs_const>-sign.
        <lfs_auart_i>-option = <lfs_const>-opti.
        <lfs_auart_i>-low = <lfs_const>-low.
        <lfs_auart_i>-high = <lfs_const>-high.
      WHEN 'VKORG'.
        APPEND INITIAL LINE TO lr_vkorg ASSIGNING FIELD-SYMBOL(<lfs_vkorg_i>).
        <lfs_vkorg_i>-sign = <lfs_const>-sign.
        <lfs_vkorg_i>-option = <lfs_const>-opti.
        <lfs_vkorg_i>-low = <lfs_const>-low.
        <lfs_vkorg_i>-high = <lfs_const>-high.
      WHEN 'ZLSCH'.
        APPEND INITIAL LINE TO lr_zlsch ASSIGNING FIELD-SYMBOL(<lfs_zlsch_i>).
        <lfs_zlsch_i>-sign = <lfs_const>-sign.
        <lfs_zlsch_i>-option = <lfs_const>-opti.
        <lfs_zlsch_i>-low = <lfs_const>-low.
        <lfs_zlsch_i>-high = <lfs_const>-high.
      WHEN OTHERS.
        "Do nothing.
    ENDCASE.
    CLEAR: <lfs_const>.
  ENDLOOP.

START-OF-SELECTION.

  SELECT vbeln, auart, vkorg, lifsk, erdat
    FROM vbak
    INTO TABLE @DATA(li_vbak)
    WHERE erdat IN @s_erdat AND
          vkorg IN @lr_vkorg AND
          auart IN @lr_auart.

  IF li_vbak IS NOT INITIAL.
    SELECT vbeln, zlsch
       FROM vbkd
       INTO TABLE @DATA(li_vbkd)
       FOR ALL ENTRIES IN @li_vbak
       WHERE vbeln EQ @li_vbak-vbeln AND zlsch IN @lr_zlsch.
    IF sy-subrc EQ 0.
      "Need to update lifsk to ZX.
    ENDIF.
*------- Checking for Payment whether successfull or not-----*
    SELECT vbeln, vbelv, vbtyp_n FROM vbfa INTO TABLE @DATA(li_vbfa)
           FOR ALL ENTRIES IN @li_vbak
           WHERE vbelv = @li_vbak-vbeln AND
                 vbtyp_n = 'M'.
*    IF li_vbfa IS NOT INITIAL.
      IF sy-subrc EQ 0.
      SELECT belnr_clr, belnr , bukrs, agzei FROM bse_clr
             INTO TABLE @DATA(li_bseclr)
             FOR ALL ENTRIES IN @li_vbfa
             WHERE belnr = @li_vbfa-vbeln AND
                   bukrs = '3310' AND
                   agzei = '1'.
      IF sy-subrc = 0.
        SELECT stblg, tcode, bukrs FROM bkpf
              INTO TABLE @DATA(li_bkpf)
              FOR ALL ENTRIES IN @li_bseclr
              WHERE stblg = @li_bseclr-belnr_clr AND
                    tcode = 'FB08' AND bukrs = '3310'.
        IF sy-subrc = 0.
          "Need to update LIFSK from ZX TO 66.
        ELSE.
          " Leave LIFSK as it is.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
