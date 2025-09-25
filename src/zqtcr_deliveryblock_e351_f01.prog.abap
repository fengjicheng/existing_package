*&---------------------------------------------------------------------*
*&  Include           ZQTCR_DELIVERYBLOCK_E351_F01
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_DELIVERYBLOCK_SALES_E351                         *
* PROGRAM DESCRIPTION: The functionality of the program is to confirm  *
*       if the payment confirmation has been successfully received from*
*       bank or not. If there is some issue with the payment clearance *
*       then for the ZSUB/ZREW order, the delivery block will be       *
*       updated to 66-Return Direct Debit from DD -Direct Debits Order.*
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 02/09/2022                                          *
* OBJECT ID      : E351                                                *
* TRANSPORT NUMBER(S):  ED2K925720                                     *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_INVOICES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_invoice_apply_block .

  DATA : lst_order_headerx   TYPE bapisdh1x,
         lst_order_header_in TYPE bapisdh1,
         li_return           TYPE STANDARD TABLE OF bapiret2,
         lv_startdate        TYPE sy-datum,
         lv_days             TYPE t5a4a-dlydy.
  "Here checking the last run date, as per the last run date fetching Invoices
  IF v_lastrundate IS INITIAL.
    CLEAR v_datediff.
    v_datediff = 1.
  ELSEIF v_lastrundate IS NOT INITIAL.
    CLEAR: v_date1,
           v_date2,
           v_time.
    v_date1 = v_lastrundate.
    v_date2 = sy-datum.
    v_time = '000001'.
    CALL FUNCTION 'SD_DATETIME_DIFFERENCE'
      EXPORTING
        date1            = v_date1 "Current date
        time1            = v_time
        date2            = v_date2 "Invoice creation date
        time2            = v_time
      IMPORTING
        datediff         = v_datediff
*       TIMEDIFF         =
*       EARLIEST         =
      EXCEPTIONS
        invalid_datetime = 1
        OTHERS           = 2.
    IF   sy-subrc = 0
    AND  v_datediff EQ 0.
       v_datediff = 1.
    ENDIF.
  ENDIF.
  DATA(lv_enddate) = s_date-high.
  lv_days = v_checkdays.
  lv_days = lv_days + v_datediff.
  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = lv_enddate
      days      = lv_days
      months    = '00'
      signum    = '-'
      years     = '00'
    IMPORTING
      calc_date = lv_startdate.
  IF  sy-subrc IS INITIAL
  AND lv_startdate IS NOT INITIAL.
    "Do Nothing
  ENDIF.
  "This is to fetch Invoices from current date to last 8 days.
  SELECT a~vbeln AS invoice,a~vbtyp,a~erdat,
         b~vgbel,b~vgtyp,
         c~vbeln AS document,c~auart,c~lifsk,
         d~zlsch
    INTO TABLE @DATA(li_invoice)
    FROM vbrk AS a
    INNER JOIN vbrp AS b ON a~vbeln = b~vbeln
    INNER JOIN vbak AS c ON b~vgbel = c~vbeln
    INNER JOIN vbkd AS d ON d~vbeln = c~vbeln
    WHERE ( a~erdat GE @lv_startdate
      AND a~erdat  LE @lv_enddate )
      AND a~vbeln IN @s_invice "Invoices from Selection screen
      AND a~vbtyp IN @ir_vbtyp "SD Document Category
      AND c~auart IN @ir_auart "Document Type
      AND d~zlsch IN @ir_zlsch. "Payment Method

  IF  sy-subrc IS INITIAL
  AND li_invoice IS NOT INITIAL.
    SORT li_invoice
      BY invoice.
    DELETE ADJACENT DUPLICATES FROM li_invoice
    COMPARING ALL FIELDS.
    "Checking the Invoice Accounting Documents are cleared are not.
    SELECT a~bukrs_clr, a~belnr_clr,a~bukrs AS companycode,a~belnr,
           a~agzei,b~bukrs,b~tcode,b~stblg
      INTO TABLE @DATA(li_account)
      FROM bse_clr AS a
      INNER JOIN bkpf AS b ON b~stblg = a~belnr_clr
       FOR ALL ENTRIES IN @li_invoice
     WHERE a~belnr EQ @li_invoice-invoice
       AND a~bukrs IN @ir_bukrs
       AND a~agzei IN @ir_agzei
       AND b~tcode IN @ir_tcode
       AND b~bukrs IN @ir_bukrs.
    IF  sy-subrc IS INITIAL
    AND li_account IS NOT INITIAL.
      SORT li_account
        BY belnr.
    ENDIF.
    LOOP AT li_invoice
      ASSIGNING FIELD-SYMBOL(<lfs_invoice>).
      "Checking date difference first whether less than or equal to 7 dates or 8 days.
      CLEAR: v_date1,
             v_date2,
             v_time.
      v_date1 = sy-datum.
      v_date2 = <lfs_invoice>-erdat.
      v_time = '000001'.
      CALL FUNCTION 'SD_DATETIME_DIFFERENCE'
        EXPORTING
          date1            = v_date1 "Current date
          time1            = v_time
          date2            = v_date2 "Invoice creation date
          time2            = v_time
        IMPORTING
          datediff         = v_datediff
*         TIMEDIFF         =
*         EARLIEST         =
        EXCEPTIONS
          invalid_datetime = 1
          OTHERS           = 2.
      IF sy-subrc = 0.
        "Do Nothing
      ENDIF.
      READ TABLE li_account
        ASSIGNING FIELD-SYMBOL(<lfs_account>)
        WITH KEY belnr = <lfs_invoice>-invoice
        BINARY SEARCH.
      IF sy-subrc IS INITIAL
      AND <lfs_account> IS ASSIGNED.
        IF v_datediff LE 8
        AND <lfs_invoice>-lifsk EQ v_lifsk.
          "Apply Delivery Block Logic
          CLEAR lst_order_headerx.
          REFRESH li_return.
          lst_order_header_in-dlv_block = v_ddupdate.
          lst_order_headerx-updateflag = c_update.
          lst_order_headerx-dlv_block = abap_true.
          CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
            EXPORTING
              salesdocument    = <lfs_invoice>-document
              order_header_in  = lst_order_header_in
              order_header_inx = lst_order_headerx
            TABLES
              return           = li_return.
          IF li_return IS NOT INITIAL.
            SORT li_return BY type ASCENDING.
            READ TABLE li_return ASSIGNING FIELD-SYMBOL(<lfs_return>)
                                 WITH KEY type = 'E'
                                 BINARY SEARCH.
            IF sy-subrc EQ 0.
              CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                EXPORTING
                  msgid                     = <lfs_return>-id
                  msgnr                     = <lfs_return>-number
                  msgv1                     = <lfs_return>-message_v1
                  msgv2                     = <lfs_return>-message_v2
                  msgv3                     = <lfs_return>-message_v3
                  msgv4                     = <lfs_return>-message_v4
               IMPORTING
                  message_text_output       = <lfs_return>-message.
              IF sy-subrc IS INITIAL.
                st_display-invoice    = <lfs_invoice>-invoice.
                st_display-invcreate  = <lfs_invoice>-erdat.
                st_display-document   = <lfs_invoice>-document.
                st_display-doctype    = <lfs_invoice>-auart.
                st_display-devblock   = <lfs_invoice>-lifsk.
                st_display-paymethod  = <lfs_invoice>-zlsch.
                st_display-status     = <lfs_return>-message.
                APPEND st_display TO i_display.
                CLEAR st_display.
              ENDIF.
            ELSE.
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = abap_true.
              CLEAR st_display.
              st_display-invoice    = <lfs_invoice>-invoice.
              st_display-invcreate  = <lfs_invoice>-erdat.
              st_display-document   = <lfs_invoice>-document.
              st_display-doctype    = <lfs_invoice>-auart.
              st_display-devblock   = v_ddupdate.
              st_display-paymethod  = <lfs_invoice>-zlsch.
              st_display-status     = 'Delivery Block Updated Successfully'.
              APPEND st_display TO i_display.
              CLEAR st_display.
            ENDIF.
          ENDIF.
        ENDIF.
      ELSEIF sy-subrc IS NOT INITIAL
      AND <lfs_account> IS NOT ASSIGNED.
        IF v_datediff GE 8
        AND <lfs_invoice>-lifsk EQ v_lifsk.
          "Apply Delivery Block Logic
          CLEAR lst_order_headerx.
          REFRESH li_return.
          lst_order_header_in-dlv_block = space.
          lst_order_headerx-updateflag = c_update.
          lst_order_headerx-dlv_block = abap_true.
          CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
            EXPORTING
              salesdocument    = <lfs_invoice>-document
              order_header_in  = lst_order_header_in
              order_header_inx = lst_order_headerx
            TABLES
              return           = li_return.
          IF li_return IS NOT INITIAL.
            SORT li_return BY type ASCENDING.
            UNASSIGN <lfs_return>.
            READ TABLE li_return ASSIGNING <lfs_return>
                                 WITH KEY type = 'E'
                                 BINARY SEARCH.
            IF sy-subrc EQ 0.
              CALL FUNCTION 'MESSAGE_TEXT_BUILD'
                EXPORTING
                  msgid                     = <lfs_return>-id
                  msgnr                     = <lfs_return>-number
                  msgv1                     = <lfs_return>-message_v1
                  msgv2                     = <lfs_return>-message_v2
                  msgv3                     = <lfs_return>-message_v3
                  msgv4                     = <lfs_return>-message_v4
               IMPORTING
                  message_text_output       = <lfs_return>-message.
              IF sy-subrc IS INITIAL.
                st_display-invoice    = <lfs_invoice>-invoice.
                st_display-invcreate  = <lfs_invoice>-erdat.
                st_display-document   = <lfs_invoice>-document.
                st_display-doctype    = <lfs_invoice>-auart.
                st_display-devblock   = <lfs_invoice>-lifsk.
                st_display-paymethod  = <lfs_invoice>-zlsch.
                st_display-status     = <lfs_return>-message.
                APPEND st_display TO i_display.
                CLEAR st_display.
              ENDIF.
            ELSE.
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = abap_true.
              CLEAR st_display.
              st_display-invoice    = <lfs_invoice>-invoice.
              st_display-invcreate  = <lfs_invoice>-erdat.
              st_display-document   = <lfs_invoice>-document.
              st_display-doctype    = <lfs_invoice>-auart.
              st_display-devblock   = space.
              st_display-paymethod  = <lfs_invoice>-zlsch.
              st_display-status     = 'Delivery Block Removed Successfully'.
              APPEND st_display TO i_display.
              CLEAR st_display.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
      UNASSIGN :<lfs_account>.
    ENDLOOP.
  ENDIF.
*Update ZCAINTERFACE table
  CLEAR st_zcainterface.
  MOVE: c_devid     TO st_zcainterface-devid,
        c_runtime   TO st_zcainterface-param1,
        sy-datum    TO st_zcainterface-lrdat,
        sy-uzeit    TO st_zcainterface-lrtime.
  MODIFY zcainterface
    FROM st_zcainterface.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_CONSTANT_ENTRIES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_constant_entries .
  "Fetching Entries from Constant Table
  SELECT devid,
         param1,
         param2,
         srno,
         sign,
         opti,
         low,
         high,
         activate,
         description,
         aenam,
         aedat
    FROM zcaconstant
    INTO TABLE @DATA(li_constant)
   WHERE devid    EQ @c_devid
     AND activate EQ @abap_true.
  IF  sy-subrc     IS INITIAL
  AND li_constant  IS NOT INITIAL.
    LOOP AT li_constant
      INTO DATA(lst_constant).
      CASE: lst_constant-param1.
        WHEN: c_agzei.
          v_agzei-sign    = lst_constant-sign.
          v_agzei-option  = lst_constant-opti.
          v_agzei-low     = lst_constant-low.
          APPEND v_agzei TO ir_agzei.
          CLEAR  v_agzei.
        WHEN: c_auart.
          v_auart-sign    = lst_constant-sign.
          v_auart-option  = lst_constant-opti.
          v_auart-low     = lst_constant-low.
          APPEND v_auart TO ir_auart.
          CLEAR  v_auart.
        WHEN: c_bukrs.
          v_bukrs-sign    = lst_constant-sign.
          v_bukrs-option  = lst_constant-opti.
          v_bukrs-low     = lst_constant-low.
          APPEND v_bukrs TO ir_bukrs.
          CLEAR  v_bukrs.
        WHEN: c_tcode.
          v_tcode-sign    = lst_constant-sign.
          v_tcode-option  = lst_constant-opti.
          v_tcode-low     = lst_constant-low.
          APPEND v_tcode TO ir_tcode.
          CLEAR  v_tcode.
        WHEN: c_vbtyp.
          v_vbtyp-sign    = lst_constant-sign.
          v_vbtyp-option  = lst_constant-opti.
          v_vbtyp-low     = lst_constant-low.
          APPEND v_vbtyp TO ir_vbtyp.
          CLEAR  v_vbtyp.
        WHEN: c_vkorg.
          v_vkorg-sign    = lst_constant-sign.
          v_vkorg-option  = lst_constant-opti.
          v_vkorg-low     = lst_constant-low.
          APPEND v_vkorg TO ir_vkorg.
          CLEAR  v_vkorg.
        WHEN: c_zlsch.
          v_zlsch-sign    = lst_constant-sign.
          v_zlsch-option  = lst_constant-opti.
          v_zlsch-low     = lst_constant-low.
          APPEND v_zlsch TO ir_zlsch.
          CLEAR  v_zlsch.
        WHEN: c_checkdays.
          CLEAR v_checkdays.
          v_checkdays     = lst_constant-low.
        WHEN: c_lifsk.
          v_lifsk = lst_constant-low.
        WHEN: c_ddupdate.
          v_ddupdate = lst_constant-low.
        WHEN: OTHERS.
          "Do Nothing.
      ENDCASE.
    ENDLOOP.
  ENDIF.
  "Fetch Last run date
  CLEAR v_lastrundate.
  SELECT SINGLE
         lrdat
    FROM zcainterface
    INTO @DATA(lv_date)
   WHERE devid = @c_devid.
  IF  sy-subrc IS INITIAL
  AND lv_date  IS NOT INITIAL.
    v_lastrundate = lv_date.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELIVERY_BLOCK_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_delivery_block_display .
  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = v_alv
        CHANGING
          t_table      = i_display.

    CATCH cx_salv_msg .
  ENDTRY.
  "To hide the column while in display
  v_func = v_alv->get_functions( ).

  DATA(ls_cols) = v_alv->get_columns( ).

  ls_cols->set_optimize( 'X' ).

  TRY.
      DATA(ls_col1) = ls_cols->get_column( 'INVOICE' ).
      DATA(ls_col2) = ls_cols->get_column( 'INVCREATE') .
      DATA(ls_col3) = ls_cols->get_column( 'DOCUMENT').
      DATA(ls_col4) = ls_cols->get_column( 'DOCTYPE').
      DATA(ls_col5) = ls_cols->get_column( 'DEVBLOCK').
      DATA(ls_col6) = ls_cols->get_column( 'PAYMETHOD' ).
      DATA(ls_col7) = ls_cols->get_column( 'STATUS').
    CATCH cx_salv_not_found.
  ENDTRY.
**************************************************
  ls_col1->set_long_text('INVOICE').
  ls_col1->set_medium_text('INVOICE NUMBER').
  ls_col1->set_short_text('INVOICE').
*************************************************
*************************************************
  ls_col2->set_long_text('INVOICE CREATE DATE').
  ls_col2->set_medium_text('INVOICE DATE').
  ls_col2->set_short_text('INV DATE').
*************************************************
*************************************************
  ls_col3->set_long_text('SALES DOCUMENT').
  ls_col3->set_medium_text('SALES DOCUMENT').
  ls_col3->set_short_text('DOCUMENT').
*************************************************
*************************************************
  ls_col4->set_long_text('SALES DOCUMENT TYPE').
  ls_col4->set_medium_text('SALES DOCUMENT TYPE').
  ls_col4->set_short_text('DOC TYPE').
*************************************************
*************************************************
  ls_col5->set_long_text('SALES DOC DELIVERY BLOCK').
  ls_col5->set_medium_text('DELIVERY BLOCK').
  ls_col5->set_short_text('DELVBLOCK').
*************************************************
*************************************************
  ls_col6->set_long_text('PAYMENT METHOD').
  ls_col6->set_medium_text('PAYMENT METHOD').
  ls_col6->set_short_text('PAYMETHOD').
***********************************************
*************************************************
  ls_col7->set_long_text('DELIVERY BLOCK UPDATE STATUS').
  ls_col7->set_medium_text('DD BLOCK STATUS').
  ls_col7->set_short_text('STATUS').
*************************************************

*************************************************
  "To display the toolbar
  CALL METHOD v_func->set_all
    EXPORTING
      value = if_salv_c_bool_sap=>true.

  v_alv->display( ).
ENDFORM.
