"Name: \PR:SAPLJYCIC_SEARCH\FO:FIELD_CONTEXT_MENU\SE:END\EI
ENHANCEMENT 0 ZQTCEI_ENH_ADDING_BP_FIORI.
*----Adding BP to FIORI link
  DATA : lst_bp TYPE zqtc_claims_bp.
    IF rjycic_search-gpnr IS NOT INITIAL.

      lst_bp-bp     = rjycic_search-gpnr.
      lst_bp-created_user = sy-uname.
      lst_bp-creted_date = sy-datum.
      lst_bp-time = sy-uzeit.

      MODIFY zqtc_claims_bp FROM lst_bp.
      CLEAR : lst_bp.
    ENDIF.

*     DATA : lst_block TYPE zqtc_block_order.
*    IF rjycic_search-gpnr IS NOT INITIAL AND 1 = 2.
*
*      lst_block-bp     = rjycic_search-gpnr.
*      lst_block-bname = sy-uname.
*      lst_block-erdat = sy-datum.
*      lst_block-ertim = sy-uzeit.
*
*      MODIFY zqtc_claims_bp FROM lst_block.
*      CLEAR : lst_block.
*    ENDIF.
ENDENHANCEMENT.
