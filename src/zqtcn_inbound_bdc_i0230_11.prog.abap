*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INBOUND_BDC_I0230_11
*&---------------------------------------------------------------------*
CONSTANTS: lc_ag11_1       TYPE parvw VALUE 'AG',  " Partner Function
           lc_we11_1       TYPE parvw VALUE 'WE',  " Partner Function
           lc_idoc_dat     TYPE char30     VALUE '(SAPLVEDA)IDOC_DATA[]',
           lc_e1edka1_11_1 TYPE edilsegtyp VALUE 'E1EDKA1'.
DATA: lst_e1edka1_11_1 TYPE e1edka1,
      lst_e1edka1_11_2 TYPE e1edka1.

FIELD-SYMBOLS : <li_idoc_rec_dat> TYPE edidd_tt.

CASE segment-segnam.

  WHEN lc_e1edka1_11_1.
    lst_e1edka1_11_1 = segment-sdata.                        " IDoc: Document Header Partner Information

    IF lst_e1edka1_11_1-parvw = lc_ag11_1.
      SELECT SINGLE name1 FROM kna1 INTO @DATA(lv_name1)
        WHERE kunnr = @lst_e1edka1_11_1-partn.
      IF sy-subrc EQ 0.
        lst_e1edka1_11_1-name1 = lv_name1.
        segment-sdata = lst_e1edka1_11_1.
        ASSIGN (lc_idoc_dat) TO <li_idoc_rec_dat>.
        IF sy-subrc = 0 AND <li_idoc_rec_dat> IS ASSIGNED.
          READ TABLE <li_idoc_rec_dat> ASSIGNING FIELD-SYMBOL(<lfs_idat>) WITH KEY
                                         segnam = lc_e1edka1_11_1
                                         sdata+0(2) = lc_ag11_1.
          IF sy-subrc EQ 0.
            lst_e1edka1_11_2 = <lfs_idat>-sdata.
            lst_e1edka1_11_2-name1 = lv_name1.
            <lfs_idat>-sdata = lst_e1edka1_11_2.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
ENDCASE.
