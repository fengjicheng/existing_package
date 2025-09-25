*&---------------------------------------------------------------------*
*&  Include           LZQTC_FG_RELORD_RECLASSF01
*&---------------------------------------------------------------------*



FORM f_retrieve_customizing.

  CONSTANTS : lc_trtyp   TYPE rvari_vnam VALUE 'TRANTYP',
              lc_postcat TYPE rvari_vnam VALUE 'POST_CAT'.

  SELECT * FROM zcaconstant
    INTO TABLE i_customizing
      WHERE devid = c_ricefid_e228_1 AND
            activate = abap_true.
  IF sy-subrc EQ 0.
    v_trtyp = i_customizing[ param1 = lc_trtyp ]-low.
    v_postcat = i_customizing[ param1 = lc_postcat ]-low.
  ENDIF.

ENDFORM.
