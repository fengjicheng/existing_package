*----------------------------------------------------------------------*
***INCLUDE LZQTC_ORDER_TOKENF01.
*----------------------------------------------------------------------*
FORM f_on_save.
  DATA:lv_date TYPE sy-datum.
    IF zqtc_order_token-ernam IS INITIAL .
      zqtc_order_token-ernam = sy-uname.
      zqtc_order_token-erdat = sy-datum.
      zqtc_order_token-ertim = sy-uzeit.

*    ELSE.
*      zqtc_order_token-aenam = sy-uname.
*      zqtc_order_token-aedat = sy-datum.
*      zqtc_order_token-uptim = sy-uzeit.
    ENDIF.

*Local data declarations
  DATA: lv_tot_index TYPE sy-tabix,
        lv_ext_index TYPE sy-tabix,
        lv_len       TYPE i.


*Local constants
  CONSTANTS: lc_new_entry TYPE char1 VALUE 'N',
             lc_upd_entry TYPE char1 VALUE 'U'.
lv_len = strlen( zqtc_order_token ).

*loop over the table contents
  LOOP AT total ASSIGNING FIELD-SYMBOL(<lfs_record>).
    lv_tot_index = sy-tabix.

    IF  <lfs_record>+lv_len(1) = lc_upd_entry.      " New or updated entry
      READ TABLE extract WITH KEY <vim_xtotal_key>.
      IF sy-subrc = 0.
        lv_ext_index = sy-tabix.
*
        <lfs_record>+65(12) = sy-uname.
        <lfs_record>+77(8)  = sy-datum.
        <lfs_record>+85(6)  = sy-uzeit.
*
**       Modify total table
        MODIFY total FROM <lfs_record> INDEX lv_tot_index.
*
        extract = <lfs_record>.
        MODIFY extract INDEX lv_ext_index.
*
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM f_create_change.
  DATA:lv_date TYPE sy-datum.

    IF zqtc_order_token-ernam IS INITIAL .
      zqtc_order_token-ernam = sy-uname.
      zqtc_order_token-erdat = sy-datum.
      zqtc_order_token-ertim = sy-uzeit.

*    ELSE.
*      zqtc_order_token-aenam = sy-uname.
*      zqtc_order_token-aedat = sy-datum.
*      zqtc_order_token-uptim = sy-uzeit.
    ENDIF.
*  ENDLOOP.
ENDFORM.
