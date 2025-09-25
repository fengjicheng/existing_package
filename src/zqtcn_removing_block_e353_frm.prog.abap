*&---------------------------------------------------------------------*
*&  Include           ZQTCN_DELIVERYBLOCK_MANUAL_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_DELIVERYBLOCK_MANUAL                             *
* PROGRAM DESCRIPTION: The orders which are Blocked Manually after 3   *
*                     or more dunning letters sent to customers using  *
*                     T-code ZQTC_UNPAID_ORDERS, for these blocked     *
*                     orders, once the customer paid fully system      *
*                     should remove the block automatically without    *
*                     manual intervention                              *
* DEVELOPER      : VDPATABALL                                          *
* CREATION DATE  : 03/10/2022                                          *
* OBJECT ID      : OTCM-57357 / E353                                                    *
* TRANSPORT NUMBER(S):ED2K926054                                       *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_BLOCK_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_block_data .

  DATA:lst_final TYPE ty_final.

*---Get the Contract orders
  SELECT vbak~vbeln,
         vbak~erdat,
         vbak~vkorg,
         vbak~kunnr,
         vbak~lifsk
    FROM vbak
    INNER JOIN vbap ON vbap~vbeln = vbak~vbeln
    INNER JOIN vbkd ON vbkd~vbeln = vbak~vbeln
    INTO TABLE @DATA(li_vbak)
    WHERE vbak~vbeln IN @s_vbeln
      AND vbak~erdat IN @s_erdat
      AND vbak~vkorg IN @s_vkorg
      AND vbak~vtweg IN @s_vtweg
      AND vbak~spart IN @s_spart
      AND vbak~auart IN @s_auart
      AND vbak~vkbur IN @s_vkbur
      AND vbap~pstyv IN @s_pstyv
      AND vbkd~bsark IN @s_bsark
      AND vbak~kunnr IN @s_kunnr
      AND vbak~lifsk IN @s_lifsk.

*---get the Invoice numbers
  IF sy-subrc = 0 AND li_vbak IS NOT INITIAL.
    SELECT vbelv,
           vbeln
      FROM vbfa
      INTO TABLE @DATA(li_vbfa)
      FOR ALL ENTRIES IN @li_vbak
      WHERE vbelv = @li_vbak-vbeln
        AND vbtyp_n = @c_m.
    IF li_vbfa IS NOT INITIAL.
      SELECT belnr,
             augbl
        FROM bseg
        INTO TABLE @DATA(li_bseg)
        FOR ALL ENTRIES IN @li_vbfa
        WHERE belnr = @li_vbfa-vbeln
          AND koart = @c_d
          AND bschl = '01'.
    ENDIF.
  ENDIF.

*----Processing Logic
  SORT li_bseg BY belnr.
  FREE:lst_final,i_final.
  LOOP AT li_vbfa INTO DATA(lst_vbfa).
    READ TABLE li_bseg INTO DATA(lst_bseg) WITH KEY belnr = lst_vbfa-vbeln BINARY SEARCH.
    IF sy-subrc = 0.
      lst_final-vbelv = lst_vbfa-vbelv. "sales and distribution document
      lst_final-vbeln = lst_vbfa-vbeln. "Invoice Number
      lst_final-augbl = lst_bseg-augbl. "Document Number of the Clearing Document
      APPEND lst_final TO i_final.
      CLEAR lst_final.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_RELEASE_BLOCK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_check_release_block .

  DATA: lst_bapisdh1x TYPE bapisdh1x,
        lst_bapisdh1  TYPE bapisdh1,
        lv_vbeln      TYPE vbeln,
        lt_return     TYPE TABLE OF bapiret2.

  LOOP AT i_final ASSIGNING FIELD-SYMBOL(<lst_final>).

    FREE:lst_bapisdh1,
         lst_bapisdh1x,
         lv_vbeln,
         lt_return.

    IF <lst_final>-augbl IS NOT INITIAL.
      lv_vbeln = <lst_final>-vbelv.
*---BAPI Header
      lst_bapisdh1-dlv_block   = space.     "Delivery Reason
      lst_bapisdh1x-dlv_block  = abap_true. "Active Flag
      lst_bapisdh1x-updateflag = c_u.       "Update Action

*--Conversion exit
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_vbeln
        IMPORTING
          output = lv_vbeln.

*---Calling BAPI to Update delivery block
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'    "Update the delivery reason for existing Contarct
        EXPORTING
          salesdocument    = lv_vbeln
          order_header_in  = lst_bapisdh1
          order_header_inx = lst_bapisdh1x
        TABLES
          return           = lt_return.
*----Checking the return messages
      READ TABLE lt_return INTO DATA(lst_return) WITH  KEY type = c_e.
      IF sy-subrc = 0.
        <lst_final>-type = lst_return-type.
        <lst_final>-msg  = lst_return-message.
      ELSE.
        READ TABLE lt_return INTO lst_return WITH  KEY type = c_a.
        IF sy-subrc = 0.
          <lst_final>-type = lst_return-type.
          <lst_final>-msg  = lst_return-message.
        ELSE.
          READ TABLE lt_return INTO lst_return WITH  KEY type = c_s.
          IF sy-subrc = 0.
            <lst_final>-type = lst_return-type.
            CONCATENATE text-004
                        <lst_final>-vbelv
                        INTO <lst_final>-msg SEPARATED BY space.
*--commiting delivery reason
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = abap_true.
          ENDIF. "READ TABLE lt_return INTO DATA(lst_return) WITH  KEY type = 'S'.
        ENDIF. "READ TABLE lt_return INTO DATA(lst_return) WITH  KEY type = 'A'.
      ENDIF. "READ TABLE lt_return INTO DATA(lst_return) WITH  KEY type = 'E'.
    ELSE.  " IF <lst_final>-augbl IS NOT INITIAL.
      <lst_final>-type = c_i.
      CONCATENATE text-003
                  <lst_final>-vbeln
                  INTO <lst_final>-msg SEPARATED BY space.
    ENDIF. " IF <lst_final>-augbl IS NOT INITIAL.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_output .

  DATA : lo_columns   TYPE REF TO cl_salv_columns_table,
         lo_column    TYPE REF TO cl_salv_column_table,
         lo_functions TYPE REF TO cl_salv_functions,
         lo_layout    TYPE REF TO cl_salv_layout,
         lo_table     TYPE REF TO cl_salv_table,
         lv_key       TYPE salv_s_layout_key.

  IF i_final IS NOT INITIAL.
    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = lo_table
          CHANGING
            t_table      = i_final.
      CATCH cx_salv_msg .
    ENDTRY.
    lo_columns = lo_table->get_columns( ).
    lo_column ?= lo_columns->get_column( 'AUGBL' ).
    lo_column->set_output_length('15').
    lo_column ?= lo_columns->get_column( 'TYPE' ).
    lo_column->set_output_length('10').
    lo_column ?= lo_columns->get_column( 'MSG' ).
    lo_column->set_output_length('50').
    lo_functions = lo_table->get_functions( ).
    lo_functions->set_all( ).
    lo_layout =  lo_table->get_layout( ).
    lv_key-report = sy-repid.
    lo_layout->set_key( lv_key ).
    lo_layout->set_save_restriction( cl_salv_layout=>restrict_none ).
    CALL METHOD lo_table->display.
  ELSE.
    MESSAGE text-002 TYPE c_i.
  ENDIF.
ENDFORM.
