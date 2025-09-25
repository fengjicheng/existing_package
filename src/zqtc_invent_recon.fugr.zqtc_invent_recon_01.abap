FUNCTION ZQTC_INVENT_RECON_01.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------
DATA: lv_menge    TYPE bstmg, " Purchase Order Quantity
        lv_menge_gr TYPE bstmg. " Purchase Order Quantity

  LOOP AT i_mara INTO lst_mara.
    lst_final-matnr = lst_mara-matnr.

    LOOP AT i_ekpo INTO lst_ekpo WHERE matnr = lst_mara-matnr.

      lst_final-ebeln = lst_ekpo-ebeln.
      lst_final-ebelp = lst_ekpo-ebelp.
      lst_final-meins = lst_ekpo-meins.
      lst_final-netwr = lst_ekpo-netwr.
      lv_menge = lv_menge + lst_ekpo-menge .

      LOOP AT i_ekbe_gr INTO lst_ekbe_gr WHERE ebeln = lst_ekpo-ebeln
                                        AND ebelp = lst_ekpo-ebelp.
        IF lst_ekbe_gr-bwart ='101'.
          lv_menge_gr = lv_menge_gr + lst_ekbe_gr-menge.
        ELSE. " ELSE -> IF lst_ekbe-bwart ='101'
          lv_menge_gr = lv_menge_gr - lst_ekbe_gr-menge.
        ENDIF. " IF lst_ekbe-bwart ='101'
      ENDLOOP. " LOOP AT i_ekbe INTO lst_ekbe WHERE ebeln = lst_ekpo-ebeln

    ENDLOOP. " LOOP AT i_ekpo INTO lst_ekpo WHERE matnr = lst_mara-matnr

    lst_final-menge = lv_menge.
    lst_final-menge_gr = lv_menge_gr.
    APPEND  lst_final TO i_final.
    CLEAR: lv_menge,
           lv_menge_gr.
  ENDLOOP. " LOOP AT i_mara INTO lst_mara




ENDFUNCTION.
