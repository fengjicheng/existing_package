FUNCTION zqtc_release_block.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_VBELN) TYPE  VBELN
*"     VALUE(IM_POSNR) TYPE  POSNR
*"     REFERENCE(IM_LIFSK) TYPE  LIFSK OPTIONAL
*"     REFERENCE(IM_FAKSK) TYPE  FAKSK OPTIONAL
*"     REFERENCE(IM_CMGST) TYPE  CMGST OPTIONAL
*"  CHANGING
*"     REFERENCE(MSGTY) TYPE  MSGTY OPTIONAL
*"     REFERENCE(MESSAGE) TYPE  MSGV1 OPTIONAL
*"----------------------------------------------------------------------

  DATA: lst_bapisdh1x TYPE bapisdh1x.
  DATA: lst_bapisdh1 TYPE bapisdh1,
        lv_vbeln     TYPE vbeln.
  DATA:lt_return TYPE TABLE OF bapiret2.

* Header
  IF im_lifsk = abap_true.
    lst_bapisdh1-dlv_block = abap_false.   " Delivery block* header X
    lst_bapisdh1x-dlv_block = abap_true.   " Delivery block
  ENDIF.

  IF im_faksk = abap_true.
    lst_bapisdh1-bill_block = abap_false.
    lst_bapisdh1x-bill_block = abap_true.
  ENDIF.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = im_vbeln
    IMPORTING
      output = lv_vbeln.

  lst_bapisdh1x-updateflag = 'U'.
  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument    = lv_vbeln
      order_header_in  = lst_bapisdh1
      order_header_inx = lst_bapisdh1x
    TABLES
      return           = lt_return.

  LOOP AT lt_return INTO DATA(lst_return) WHERE type = 'E' OR type = 'A'.
    msgty = 'E'.
    message = lst_return-message.
    EXIT.
  ENDLOOP.

  IF msgty IS INITIAL.
    COMMIT WORK.
* Successfully updated
    IF im_lifsk = abap_true.
      message = 'Delivery block released successfully'.

    ELSEIF im_faksk = abap_true.
      message = 'Billing block released successfully'.
    ENDIF.

    msgty = 'S'.
    SELECT vbeln,posnr FROM vbap INTO TABLE @DATA(li_vbap)
      WHERE vbeln = @im_vbeln.
    IF sy-subrc EQ 0.

*      UPDATE vbak SET lifsk = ''
*        WHERE vbeln = im_vbeln.
*
*      COMMIT WORK.

      LOOP AT li_vbap INTO DATA(lst_vbap).
        IF im_lifsk = abap_true.
          UPDATE vbap SET abgru = ''
          WHERE vbeln = lst_vbap-vbeln
            AND posnr = lst_vbap-posnr.
        ELSEIF im_faksk = abap_true.
          UPDATE vbap SET faksp = ''
       WHERE vbeln = lst_vbap-vbeln
         AND posnr = lst_vbap-posnr.
        ENDIF.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFUNCTION.
