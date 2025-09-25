*&---------------------------------------------------------------------*
*&  Include           ZQTCR_INDIRECT_SOC_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_all .
  FREE:i_output[].
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV_GRID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_alv_grid .
  DATA: lr_err_message TYPE REF TO cx_salv_msg,
        " ALV: General Error Class with Message
        lv_text        TYPE string.
  " ALV: General Error Class with Message
  IF i_output[] IS NOT INITIAL.
    TRY.
        cl_salv_table=>factory(
        IMPORTING
          r_salv_table = r_alv_table
        CHANGING
          t_table      = i_output ).
        r_alv_columns = r_alv_table->get_columns( ).

        PERFORM f_build_layout. "       Build layout for ALV
        PERFORM f_build_catlog. "       Build Catalog for ALV
        PERFORM f_build_toobar.
        "       Make available Toolbar Function for ALV
        PERFORM f_report_heading. "     Report Heading for ALV

      CATCH cx_salv_msg INTO lr_err_message.
*   Add error processing
        lv_text = lr_err_message->get_text( ).
        MESSAGE lv_text TYPE c_msgty_i.
    ENDTRY.

    PERFORM f_publish_alv. "       Display ALV Grid.
  ELSE.
    WRITE:/ 'No record to Display'(002).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_layout .
  DATA: lr_layout TYPE REF TO cl_salv_layout. " Settings for Layout
  DATA: lc_layout_key      TYPE salv_s_layout_key. " Layout Key

  lr_layout            = r_alv_table->get_layout( ).
  lc_layout_key-report = sy-repid.

  lr_layout->set_key( lc_layout_key ).
  lr_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_CATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_catlog .
  DATA: lr_err_notfound TYPE REF TO cx_salv_not_found,
        " ALV: General Error Class (Checked During Syntax Check)
        lv_text         TYPE string.

  CONSTANTS : lc_bp      TYPE name_feld  VALUE 'ZZPARTNER', "Sales Document
              lc_name    TYPE name_feld  VALUE 'NAME1',
              lc_scode   TYPE name_feld  VALUE 'SOCCODE',
              lc_matnr   TYPE name_feld  VALUE 'MATNR',
              lc_maktx   TYPE name_feld  VALUE 'MAKTX',
              lc_memcode TYPE name_feld VALUE 'MEMCODE',
              lc_len_20  TYPE lvc_outlen VALUE '20'.

  TRY.
      r_single_column = r_alv_columns->get_column( lc_bp ).
      r_single_column->set_short_text('Soc BP').
      r_single_column->set_medium_text('Soc BP').
      r_single_column->set_long_text( text-s10 ).
      r_single_column->set_output_length( 10 ).


      r_single_column = r_alv_columns->get_column( lc_name ).
      r_single_column->set_short_text('Soc Name').
      r_single_column->set_medium_text('Soc Name').
      r_single_column->set_long_text(     text-s13  ).
      r_single_column->set_output_length( lc_len_20 ).

      r_single_column = r_alv_columns->get_column( lc_scode ).
      r_single_column->set_short_text('Soc Code').
      r_single_column->set_medium_text('Soc Code').
      r_single_column->set_long_text(     text-s16  ).
      r_single_column->set_output_length( lc_len_20 ).

      r_single_column = r_alv_columns->get_column( lc_matnr ).
      r_single_column->set_short_text('Material').
      r_single_column->set_medium_text('Material').
      r_single_column->set_long_text('Material').
      r_single_column->set_output_length( lc_len_20 ).


      r_single_column = r_alv_columns->get_column( 'MAKTX' ).
      r_single_column->set_short_text('Mat Des').
      r_single_column->set_medium_text('Material Descr').
      r_single_column->set_long_text('Material Description').
      r_single_column->set_output_length( lc_len_20 ).

      r_single_column = r_alv_columns->get_column( lc_memcode ).
      r_single_column->set_short_text('MemTypCode').
      r_single_column->set_medium_text('Mem Type Code').
      r_single_column->set_long_text(     text-s20  ).
      r_single_column->set_output_length( lc_len_20 ).

      r_single_column = r_alv_columns->get_column( 'MEMDESCR' ).
      r_single_column->set_short_text('Type Desc').
      r_single_column->set_medium_text('Type Desc').
      r_single_column->set_long_text('Membership Type Desc').
      r_single_column->set_output_length( lc_len_20 ).

      r_single_column = r_alv_columns->get_column( 'MEMPRICE' ).
      r_single_column->set_short_text('Price').
      r_single_column->set_medium_text('Price').
      r_single_column->set_long_text('Membership Price').
      r_single_column->set_output_length( lc_len_20 ).

      r_single_column = r_alv_columns->get_column( 'MEMDISC' ).
      r_single_column->set_short_text('Mem Disc' ).
      r_single_column->set_medium_text('Mem Disc').
      r_single_column->set_long_text('Membership Disc').
      r_single_column->set_output_length( lc_len_20 ).

      r_single_column = r_alv_columns->get_column( 'AMOUNT' ).
      r_single_column->set_short_text('Disc Amt').
      r_single_column->set_medium_text('Disc Amt').
      r_single_column->set_long_text('Discount Amt').
      r_single_column->set_output_length( lc_len_20 ).

      r_single_column = r_alv_columns->get_column( 'NETPR' ).
      r_single_column->set_short_text('Net Price').
      r_single_column->set_medium_text('Net Price').
      r_single_column->set_long_text(     text-s30  ).
      r_single_column->set_output_length( lc_len_20 ).

      r_single_column = r_alv_columns->get_column( 'DATAB' ).
      r_single_column->set_short_text('Start Date').
      r_single_column->set_medium_text('Start Date').
      r_single_column->set_long_text('Pricing Start Date').
      r_single_column->set_output_length( lc_len_20 ).

      r_single_column = r_alv_columns->get_column( 'DATBI' ).
      r_single_column->set_short_text('PrEnd Date').
      r_single_column->set_medium_text('PrEnd Date').
      r_single_column->set_long_text('Pricing Validity End Date').
      r_single_column->set_output_length( lc_len_20 ).

      r_single_column = r_alv_columns->get_column( 'KONWA' ).
      r_single_column->set_short_text('Currency').
      r_single_column->set_medium_text('Currency').
      r_single_column->set_long_text(     text-s36  ).
      r_single_column->set_output_length( lc_len_20 ).

      r_single_column = r_alv_columns->get_column( 'PLTYP' ).
      r_single_column->set_short_text('Price List').
      r_single_column->set_medium_text('Price List').
      r_single_column->set_long_text(     text-s38  ).
      r_single_column->set_output_length( lc_len_20 ).

      r_single_column = r_alv_columns->get_column( 'PTEXT' ).
      r_single_column->set_short_text('PrLst Desc').
      r_single_column->set_medium_text('PrLst Desc').
      r_single_column->set_long_text('Price List Descripiton').
      r_single_column->set_output_length( lc_len_20 ).

    CATCH cx_salv_not_found INTO lr_err_notfound.
*   Add error processing
      lv_text = lr_err_notfound->get_text( ).
      MESSAGE lv_text TYPE c_msgty_i.
  ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_TOOBAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_toobar .
  DATA: lr_toolbar_functions TYPE REF TO cl_salv_functions_list.
  " Generic and User-Defined Functions in List-Type Tables

  lr_toolbar_functions = r_alv_table->get_functions( ).
  lr_toolbar_functions->set_all( ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_REPORT_HEADING
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_report_heading .
  DATA: lr_report_settings TYPE REF TO cl_salv_display_settings.
  " Appearance of the ALV Output

  lr_report_settings = r_alv_table->get_display_settings( ).
  lr_report_settings->set_striped_pattern( if_salv_c_bool_sap=>true ).
  lr_report_settings->set_list_header('InDirect Society Member Price Report ').
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PUBLISH_ALV
*&---------------------------------------------------------------------*
*       Display ALV Grid.
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_publish_alv .
  r_alv_table->display( ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SCREEN_HANDLING
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_screen_handling .
  LOOP AT SCREEN.
    IF screen-name = 'RB_R2'.
      screen-invisible = 1.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_N_PROCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_n_process .



ENDFORM.
