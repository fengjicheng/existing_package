*&---------------------------------------------------------------------*
*& Report  ZQTCR_SORD_CANC_DETAILS
*&---------------------------------------------------------------------*
REPORT zqtcr_sord_canc_details.

PARAMETERS p_vbeln TYPE vbeln_va OBLIGATORY.
DATA:lst_vbak     TYPE vbak.

SELECT SINGLE * FROM vbak INTO lst_vbak WHERE vbeln = p_vbeln.
SELECT * FROM vbap  INTO TABLE @DATA(li_vbap) WHERE vbeln = @p_vbeln.
SORT li_vbap BY posnr.
SELECT * FROM vbep  INTO TABLE @DATA(li_vbep) WHERE vbeln = @p_vbeln.
SELECT * FROM vbuv  INTO TABLE @DATA(li_vbuv) WHERE vbeln = @p_vbeln.
SELECT * FROM veda  INTO TABLE @DATA(li_veda) WHERE vbeln = @p_vbeln.

TYPES: BEGIN OF ty_op,
         fieldname TYPE fieldname,
         fieldval  TYPE char30,
         fielddesc TYPE char65,
       END OF ty_op.

DATA:lst_op TYPE ty_op,
     li_op  TYPE STANDARD TABLE OF ty_op.

DATA:
  o_popup_alv  TYPE REF TO cl_salv_table,
  lo_functions TYPE REF TO cl_salv_functions_list.

TYPES : BEGIN OF ty_output,
          posnr      TYPE posnr_va,
          matnr      TYPE matnr,
          frm_vch    TYPE char1,
          eal        TYPE char1,
          frm_ftp    TYPE char1,
          canc       TYPE char1,
          rej        TYPE char1,
          block      TYPE char1,
          incomplete TYPE char1,
          ac_sus     TYPE char1,
          abgru      TYPE abgru,
        END OF ty_output.

DATA : lt_output  TYPE STANDARD TABLE OF ty_output,
       lst_output TYPE ty_output,
       lt_field   TYPE STANDARD TABLE OF slis_fieldcat_alv,
       ls_field   TYPE slis_fieldcat_alv.

CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.

    METHODS: on_link_click   FOR EVENT link_click OF
                cl_salv_events_table
      IMPORTING row column,
      disp_alv IMPORTING fieldname TYPE fieldname .
ENDCLASS.                    "lcl_handle_events DEFINITION
*---------------------
* class implimentation
*---------------------
CLASS lcl_handle_events IMPLEMENTATION.
  METHOD disp_alv.
    DATA:lst_op TYPE ty_op.
    TYPES:BEGIN OF ty_item_op,
            posnr TYPE posnr,
            matnr TYPE matnr,
            value TYPE char10,
            descr TYPE char65,
          END OF ty_item_op.

    DATA:
      o_salv_rej   TYPE REF TO cl_salv_table,
      lo_funct_rej TYPE REF TO cl_salv_functions_list,
      li_item_op   TYPE STANDARD TABLE OF ty_item_op,
      lst_item_op  TYPE ty_item_op.
    CASE fieldname.
      WHEN 'REJECTED'.
        LOOP AT lt_output ASSIGNING FIELD-SYMBOL(<lfs_output>) WHERE rej IS NOT INITIAL AND posnr IS NOT INITIAL.
          lst_item_op-posnr = <lfs_output>-posnr.
          lst_item_op-matnr = <lfs_output>-matnr.

          lst_item_op-value = <lfs_output>-abgru.
          SELECT SINGLE bezei INTO @DATA(lv_desc) FROM tvagt WHERE abgru = @<lfs_output>-abgru AND spras = @sy-langu.
          IF sy-subrc IS INITIAL.
            lst_item_op-descr = lv_desc.
          ENDIF.


          APPEND lst_item_op TO li_item_op.
          CLEAR:lst_item_op.
        ENDLOOP.
      WHEN 'BLOCKED'.
        LOOP AT lt_output ASSIGNING <lfs_output> WHERE block IS NOT INITIAL AND posnr IS NOT INITIAL.
          lst_item_op-posnr = <lfs_output>-posnr.
          lst_item_op-matnr = <lfs_output>-matnr.

          lst_item_op-value = VALUE #( li_vbep[ posnr = <lfs_output>-posnr ]-lifsp DEFAULT space ).
          CLEAR:lv_desc.
          IF lst_item_op-value IS NOT INITIAL.
            SELECT SINGLE vtext INTO @lv_desc FROM tvlst WHERE lifsp = @lst_item_op-value AND spras = @sy-langu.
            IF sy-subrc IS INITIAL.
              lst_item_op-descr = lv_desc.
            ENDIF.
          ELSE.
            lst_item_op-value = VALUE #( li_vbap[ posnr = <lfs_output>-posnr ]-faksp DEFAULT space ) .
            CLEAR:lv_desc.
            SELECT SINGLE vtext INTO @lv_desc FROM tvfst WHERE faksp = @lst_item_op-value AND spras = @sy-langu.
            IF sy-subrc IS INITIAL.
              lst_item_op-descr = lv_desc.
            ENDIF.
          ENDIF.
          APPEND lst_item_op TO li_item_op.
          CLEAR:lst_item_op.
        ENDLOOP.
      WHEN 'CANCELLED'.
        LOOP AT lt_output ASSIGNING <lfs_output> WHERE canc IS NOT INITIAL AND posnr IS NOT INITIAL.
          lst_item_op-posnr = <lfs_output>-posnr.
          lst_item_op-matnr = <lfs_output>-matnr.

          lst_item_op-value = VALUE #( li_veda[ vposn = <lfs_output>-posnr ]-vkuegru  DEFAULT space ).
          CLEAR:lv_desc.
          IF lst_item_op-value IS NOT INITIAL.
            SELECT SINGLE bezei INTO @lv_desc FROM tvkgt WHERE kuegru = @lst_item_op-value AND spras = @sy-langu.
            IF sy-subrc IS INITIAL.
              lst_item_op-descr = lv_desc.
            ENDIF.

          ENDIF.
          APPEND lst_item_op TO li_item_op.
          CLEAR:lst_item_op.
        ENDLOOP.
      WHEN 'INCOMPLETE'.
        LOOP AT lt_output ASSIGNING <lfs_output> WHERE incomplete IS NOT INITIAL AND posnr IS NOT INITIAL.
          lst_item_op-posnr = <lfs_output>-posnr.
          lst_item_op-matnr = <lfs_output>-matnr.
          APPEND lst_item_op TO li_item_op.
          CLEAR:lst_item_op.
        ENDLOOP.
      WHEN 'SUSPENSION'.
        LOOP AT lt_output ASSIGNING <lfs_output> WHERE ac_sus IS NOT INITIAL AND posnr IS NOT INITIAL.
          lst_item_op-posnr = <lfs_output>-posnr.
          lst_item_op-matnr = <lfs_output>-matnr.
          APPEND lst_item_op TO li_item_op.
          CLEAR:lst_item_op.
        ENDLOOP.
    ENDCASE.
    cl_salv_table=>factory(
       IMPORTING
         r_salv_table   = o_salv_rej
      CHANGING
        t_table        =  li_item_op ).

    lo_funct_rej = o_salv_rej->get_functions( ).
    lo_funct_rej->set_default( 'X' ).

    DATA(lr_disp) =  o_salv_rej->get_display_settings( ).
    lr_disp->set_list_header( 'Cancellation/Block Details' ).
    lr_disp->set_fit_column_to_table_size( ).
    lr_disp->set_striped_pattern( abap_true ).

    DATA: lo_columns_rej TYPE REF TO cl_salv_columns_table,
          lo_column_rej  TYPE REF TO cl_salv_column_table.

    lo_columns_rej = o_salv_rej->get_columns( ).
    lo_column_rej ?= lo_columns_rej->get_column( 'POSNR' ).
    lo_column_rej->set_long_text( 'Item' ).

    lo_columns_rej = o_salv_rej->get_columns( ).
    lo_column_rej ?= lo_columns_rej->get_column( 'MATNR' ).
    lo_column_rej->set_long_text( 'Material' ).

    lo_columns_rej = o_salv_rej->get_columns( ).
    lo_column_rej ?= lo_columns_rej->get_column( 'VALUE' ).
    CASE fieldname.
      WHEN 'REJECTED'.
        lo_column_rej->set_long_text( 'Reason for Rejection' ).
      WHEN 'BLOCKED'.
        lo_column_rej->set_long_text( 'Shipping/Billing Block' ).
      WHEN 'CANCELLED'.
        lo_column_rej->set_long_text( 'Reason for Cancellation' ).
      WHEN OTHERS.
        lo_column_rej->set_visible( if_salv_c_bool_sap=>false ).
    ENDCASE.

    lo_columns_rej = o_salv_rej->get_columns( ).
    lo_column_rej ?= lo_columns_rej->get_column( 'DESCR' ).
    lo_column_rej->set_long_text( 'Description' ).
    IF fieldname = 'SUSPENSION' OR fieldname = 'INCOMPLETE'.
      lo_column_rej->set_visible( if_salv_c_bool_sap=>false ).
    ENDIF.

    o_salv_rej->set_screen_popup(
     start_column = 10
     end_column   = 100
     start_line   = 3
     end_line     = 20 ).

    o_salv_rej->display( ).
  ENDMETHOD.
  METHOD on_link_click.
    READ TABLE li_op INTO lst_op INDEX row.
    CHECK sy-subrc = 0.

    CASE column.
      WHEN 'FIELDVAL'.
        CASE lst_op-fieldname.
          WHEN 'REJECTED LINE ITEMS'.
            me->disp_alv( EXPORTING fieldname = 'REJECTED' ).
          WHEN 'BLOCKED LINE ITEMS'.
            me->disp_alv( EXPORTING fieldname = 'BLOCKED' ).
          WHEN 'CANCELLED LINE ITEMS'.
            me->disp_alv( EXPORTING fieldname = 'CANCELLED' ).
          WHEN 'INCOMPLETE LINE ITEMS'.
            me->disp_alv( EXPORTING fieldname = 'INCOMPLETE' ).
          WHEN 'ACTIVE SUSPENSION LINE ITEMS'.
            me->disp_alv( EXPORTING fieldname = 'SUSPENSION' ).
          WHEN OTHERS.
        ENDCASE.
    ENDCASE.
  ENDMETHOD.                    "on_link_click
ENDCLASS.                    "lcl_handle_events IMPLEMENTATION

START-OF-SELECTION.
  IF lst_vbak-vkbur = '0080'.
    IF lst_vbak-vkgrp = 'FRM'.
      lst_output-frm_vch = abap_true.
    ENDIF.
  ELSEIF lst_vbak-vkbur = '0050'.
    lst_output-eal = abap_true.
  ENDIF.
  IF lst_vbak-bsark EQ '0160'.
    lst_output-frm_ftp = abap_true.
  ENDIF.
  IF lst_vbak-lifsk IS NOT INITIAL OR
    lst_vbak-faksk IS NOT INITIAL.
    lst_output-block = abap_true.
  ENDIF.
  IF line_exists( li_vbuv[ posnr = '000000'] ).
    lst_output-incomplete = abap_true.
  ENDIF.

  IF lst_vbak-augru IS NOT INITIAL.
    lst_output-rej = abap_true.
  ENDIF.
  APPEND lst_output TO lt_output.
  CLEAR:lst_output.
  IF li_vbap IS NOT INITIAL.
    TYPES:BEGIN OF ty_jkshed,
            vbeln     TYPE vbeln,
            posnr     TYPE posnr,
            interrupt TYPE jinterrupt,
          END OF ty_jkshed.
    DATA:li_jkshed TYPE STANDARD TABLE OF ty_jkshed.
    SELECT vbeln posnr interrupt INTO TABLE li_jkshed
      FROM jksesched
      FOR ALL ENTRIES IN li_vbap
      WHERE vbeln = li_vbap-vbeln AND
      posnr = li_vbap-posnr.
  ENDIF.
  LOOP AT li_vbap ASSIGNING FIELD-SYMBOL(<lfs_vbap>).
    lst_output-posnr = <lfs_vbap>-posnr.
    lst_output-matnr = <lfs_vbap>-matnr.
    lst_output-abgru = <lfs_vbap>-abgru.
    IF line_exists( li_vbep[ posnr = <lfs_vbap>-posnr ] ).
      IF  li_vbep[ posnr = <lfs_vbap>-posnr ]-lifsp IS NOT INITIAL.
        lst_output-block = abap_true.
      ENDIF.
    ENDIF.
    IF <lfs_vbap>-faksp IS NOT INITIAL.
      lst_output-block = abap_true.
    ENDIF.
    IF <lfs_vbap>-abgru IS NOT INITIAL.
      lst_output-rej = abap_true.
    ENDIF.
    IF <lfs_vbap>-faksp IS NOT INITIAL.
      lst_output-block = abap_true.
    ENDIF.
    IF line_exists( li_veda[ vposn = <lfs_vbap>-posnr ] ).
      IF li_veda[ vposn = <lfs_vbap>-posnr ]-vkuegru IS NOT INITIAL.
        lst_output-canc = abap_true.
      ENDIF.
    ENDIF.
    IF line_exists( li_vbuv[ posnr = <lfs_vbap>-posnr ] ).
      lst_output-incomplete = abap_true.
    ENDIF.
    lst_output-posnr = <lfs_vbap>-posnr.
    IF line_exists( li_jkshed[ posnr = <lfs_vbap>-posnr ] ).
      lst_output-ac_sus = abap_true.
    ENDIF.
    APPEND lst_output TO lt_output.
    CLEAR:lst_output.
  ENDLOOP.


  lst_output = lt_output[ 1 ].
  lst_op-fieldname = 'FRM VCH'.
  lst_op-fieldval  =  lst_output-frm_vch.
  APPEND lst_op TO li_op.
  CLEAR:lst_op.

  lst_op-fieldname = 'EAL'.
  lst_op-fieldval  =  lst_output-eal.
  APPEND lst_op TO li_op.
  CLEAR:lst_op.

  lst_op-fieldname = 'FRM FTP'.
  lst_op-fieldval  =  lst_output-frm_ftp.
  APPEND lst_op TO li_op.
  CLEAR:lst_op.

  lst_op-fieldname = 'CANCELLED'.
  lst_op-fieldval  =  lst_output-canc.

  lst_op-fielddesc  = VALUE #( li_veda[ vposn = '000000' ]-vkuegru  DEFAULT space ).
  IF lst_op-fielddesc IS NOT INITIAL.
    SELECT SINGLE bezei INTO @DATA(lv_fielddesc) FROM tvkgt WHERE spras = @sy-langu AND kuegru = @lst_op-fielddesc.
    IF sy-subrc IS INITIAL.
      lst_op-fielddesc =  |{ lst_op-fielddesc }| && | - | && |{ lv_fielddesc }|.
    ENDIF.

  ENDIF.
  APPEND lst_op TO li_op.
  CLEAR:lst_op.

  lst_op-fieldname = 'REJECTED'.
  lst_op-fieldval  =  lst_output-rej.
  CLEAR:lv_fielddesc.
  IF lst_vbak-augru IS NOT INITIAL.
    SELECT SINGLE bezei INTO @lv_fielddesc FROM tvaut WHERE spras = @sy-langu AND augru = @lst_vbak-augru.
    IF sy-subrc IS INITIAL.
      lst_op-fielddesc =  |{ lst_vbak-augru }| && | - | && |{ lv_fielddesc }|.
    ENDIF.
  ENDIF.
  APPEND lst_op TO li_op.
  CLEAR:lst_op.

  lst_op-fieldname = 'BLOCKED'.
  lst_op-fieldval  =  lst_output-block.
  CLEAR:lv_fielddesc.
  IF lst_vbak-lifsk IS NOT INITIAL.
    lst_op-fielddesc =  lst_vbak-lifsk.

    SELECT SINGLE vtext INTO @lv_fielddesc FROM tvlst WHERE spras = @sy-langu AND lifsp = @lst_vbak-lifsk .
    IF sy-subrc IS INITIAL.
      lst_op-fielddesc =  |{ lst_vbak-lifsk }| && | - | && |{ lv_fielddesc }|.
    ENDIF.
  ELSEIF lst_vbak-faksk IS NOT INITIAL.
    SELECT SINGLE vtext INTO @lv_fielddesc FROM tvfst WHERE spras = @sy-langu AND faksp = @lst_vbak-faksk.
    IF sy-subrc IS INITIAL.
      lst_op-fielddesc =  |{ lst_vbak-faksk }| && | - | && |{ lv_fielddesc }|.
    ENDIF.
  ENDIF.
  APPEND lst_op TO li_op.
  CLEAR:lst_op.

  lst_op-fieldname = 'INCOMPLETE'.
  lst_op-fieldval  =  lst_output-incomplete.
  APPEND lst_op TO li_op.
  CLEAR:lst_op.

  DATA:li_tmp_op  TYPE STANDARD TABLE OF ty_output, " WITH NON-UNIQUE SORTED KEY posnr COMPONENTS posnr,
       li_tmp_op2 TYPE STANDARD TABLE OF ty_output . "WITH NON-UNIQUE SORTED KEY posnr COMPONENTS posnr.

  li_tmp_op = lt_output.
  DELETE li_tmp_op WHERE posnr = '000000'.
  li_tmp_op2 = li_tmp_op.
  DELETE li_tmp_op2 WHERE rej IS INITIAL.
*li_tmp_op2 =  FILTER #( li_tmp_op USING KEY posnr WHERE rej = 'X' ).

  lst_op-fieldname = 'REJECTED LINE ITEMS'.
  lst_op-fieldval  =  lines( li_tmp_op2 ).
  APPEND lst_op TO li_op.
  CLEAR:lst_op.

  CLEAR:li_tmp_op2.
  li_tmp_op2 = li_tmp_op.
  DELETE li_tmp_op2 WHERE block IS INITIAL.

  lst_op-fieldname = 'BLOCKED LINE ITEMS'.
  lst_op-fieldval  =  lines( li_tmp_op2 ).
  APPEND lst_op TO li_op.
  CLEAR:lst_op.

  CLEAR:li_tmp_op2.
  li_tmp_op2 = li_tmp_op.
  DELETE li_tmp_op2 WHERE canc IS INITIAL.

  lst_op-fieldname = 'CANCELLED LINE ITEMS'.
  lst_op-fieldval  =  lines( li_tmp_op2 ).
  APPEND lst_op TO li_op.
  CLEAR:lst_op.

  CLEAR:li_tmp_op2.
  li_tmp_op2 = li_tmp_op.
  DELETE li_tmp_op2 WHERE incomplete IS INITIAL.

  lst_op-fieldname = 'INCOMPLETE LINE ITEMS'.
  lst_op-fieldval  =  lines( li_tmp_op2 ).
  APPEND lst_op TO li_op.
  CLEAR:lst_op.

  CLEAR:li_tmp_op2.
  li_tmp_op2 = li_tmp_op.
  DELETE li_tmp_op2 WHERE ac_sus IS INITIAL.

  lst_op-fieldname = 'ACTIVE SUSPENSION LINE ITEMS'.
  lst_op-fieldval  =  lines( li_tmp_op2 ).
  APPEND lst_op TO li_op.
  CLEAR:lst_op.

  DATA:
    o_salv   TYPE REF TO cl_salv_table,
    lo_funct TYPE REF TO cl_salv_functions_list.

  cl_salv_table=>factory(
     IMPORTING
       r_salv_table   = o_salv
    CHANGING
      t_table        =  li_op ).

  lo_funct = o_salv->get_functions( ).
  lo_funct->set_default( 'X' ).

  DATA(lr_disp) =  o_salv->get_display_settings( ).
  lr_disp->set_list_header( 'Cancellation/Block Details' ).
  lr_disp->set_fit_column_to_table_size( ).
  lr_disp->set_striped_pattern( abap_true ).

  DATA: lo_columns1 TYPE REF TO cl_salv_columns_table,
        lo_column1  TYPE REF TO cl_salv_column_table.


  lo_columns1 = o_salv->get_columns( ).
  lo_column1 ?= lo_columns1->get_column( 'FIELDNAME' ).
  lo_column1->set_long_text( 'Field' ).
*lo_column1->set_output_length('8').

  lo_columns1 = o_salv->get_columns( ).
  lo_column1 ?= lo_columns1->get_column( 'FIELDVAL' ).
  lo_column1->set_long_text( 'Value' ).
  lo_column1->set_cell_type( if_salv_c_cell_type=>hotspot ).
*   Set the HotSpot for Column
  TRY.
      CALL METHOD lo_column1->set_cell_type
        EXPORTING
          value = if_salv_c_cell_type=>hotspot.
      .
    CATCH cx_salv_data_error .
  ENDTRY.
*lo_column1->set_output_length('20').

  lo_columns1 = o_salv->get_columns( ).
  lo_column1 ?= lo_columns1->get_column( 'FIELDDESC' ).
  lo_column1->set_long_text( 'Description' ).
*lo_column1->set_output_length('65').
*-- events
  "events
  DATA: event_handler TYPE REF TO lcl_handle_events.
  DATA(gr_events) = o_salv->get_event( ).
  CREATE OBJECT event_handler.
  SET HANDLER event_handler->on_link_click FOR gr_events.
  o_salv->display( ).


***&---------------------------------------------------------------------*
***& Dynamic Internal table logic
***&---------------------------------------------------------------------*
**DATA:
**     o_popup_alv  TYPE REF TO cl_salv_table,
**     lo_functions TYPE REF TO cl_salv_functions_list.
**
**TYPES : BEGIN OF ty_output,
**          posnr      TYPE posnr,
**          frm_vch    TYPE char1,
**          eal        TYPE char1,
**          frm_ftp    TYPE char1,
**          canc       TYPE char1,
**          rej        TYPE char1,
**          block      TYPE char1,
**          incomplete TYPE char1,
**          ac_sus     TYPE char1,
**        END OF ty_output.
**
**DATA : lt_output TYPE STANDARD TABLE OF ty_output,
**       lst_output TYPE ty_output,
**       lt_field  TYPE STANDARD TABLE OF slis_fieldcat_alv,
**       ls_field  TYPE slis_fieldcat_alv.
**
**
**
**IF lst_vbak-vkbur = '0080'.
**  IF lst_vbak-vkgrp = 'FRM'.
**    lst_output-frm_vch = abap_true.
**  ENDIF.
**ELSEIF lst_vbak-vkbur = '0050'.
**  lst_output-eal = abap_true.
**ENDIF.
**IF lst_vbak-bsark EQ '0160'.
**  lst_output-frm_ftp = abap_true.
**ENDIF.
**IF lst_vbak-faksk IS NOT INITIAL.
**  lst_output-block = abap_true.
**ENDIF.
**IF line_exists( li_vbuv[ posnr = '000000'] ).
**  lst_output-incomplete = abap_true.
**ENDIF.
**APPEND lst_output TO lt_output.
**CLEAR:lst_output.
**IF li_vbap IS NOT INITIAL.
**  TYPES:BEGIN OF ty_jkshed,
**          vbeln     TYPE vbeln,
**          posnr     TYPE posnr,
**          interrupt TYPE jinterrupt,
**        END OF ty_jkshed.
**  DATA:li_jkshed TYPE STANDARD TABLE OF ty_jkshed.
**  SELECT vbeln posnr interrupt INTO TABLE li_jkshed
**    FROM jksesched
**    FOR ALL ENTRIES IN li_vbap
**    WHERE vbeln = li_vbap-vbeln AND
**    posnr = li_vbap-posnr.
**ENDIF.
**LOOP AT li_vbap ASSIGNING FIELD-SYMBOL(<lfs_vbap>).
**  IF line_exists( li_vbep[ posnr = <lfs_vbap>-posnr ] ).
**    IF  li_vbep[ posnr = <lfs_vbap>-posnr ]-lifsp IS NOT INITIAL.
**      lst_output-block = abap_true.
**    ENDIF.
**  ENDIF.
**  IF <lfs_vbap>-faksp IS NOT INITIAL.
**    lst_output-block = abap_true.
**  ENDIF.
**  IF <lfs_vbap>-abgru IS NOT INITIAL.
**    lst_output-rej = abap_true.
**  ENDIF.
**  IF <lfs_vbap>-faksp IS NOT INITIAL.
**    lst_output-block = abap_true.
**  ENDIF.
**  IF line_exists( li_veda[ vposn = <lfs_vbap>-posnr ] ).
**    IF li_veda[ vposn = <lfs_vbap>-posnr ]-vkuegru IS NOT INITIAL.
**      lst_output-canc = abap_true.
**    ENDIF.
**  ENDIF.
**  IF line_exists( li_vbuv[ posnr = <lfs_vbap>-posnr ] ).
**    lst_output-incomplete = abap_true.
**  ENDIF.
**  lst_output-posnr = <lfs_vbap>-posnr.
**  IF line_exists( li_jkshed[ posnr = <lfs_vbap>-posnr ] ).
**    lst_output-ac_sus = abap_true.
**  ENDIF.
**  APPEND lst_output TO lt_output.
**  CLEAR:lst_output.
**ENDLOOP.
***    LOOP AT li_vbap ASSIGNING FIELD-SYMBOL(<lfs_vbap>).
***      IF line_exists( xvbep[ posnr = <lfs_vbap>-posnr ] ).
***        lst_output-lifsp = xvbep[ posnr = <lfs_vbap>-posnr ]-lifsp.
***      ENDIF.
***      lst_output-posnr = <lfs_vbap>-posnr.
****
***      lst_output-faksp = <lfs_vbap>-faksp.
***      lst_output-abgru = <lfs_vbap>-abgru.
***      lst_output-lifsk = lst_vbak-lifsk.
***      lst_output-faksk = lst_vbak-faksk.
***      lst_output-vkorg = lst_vbak-vkorg.
***      lst_output-vtweg = lst_vbak-vtweg.
***      lst_output-spart = lst_vbak-spart.
***      lst_output-vkbur = lst_vbak-vkbur.
***      lst_output-bsark = lst_vbak-bsark.
***      APPEND lst_output TO lt_output.
***    ENDLOOP.
**
***----------------------------
*** Get the data based on the field you clicked
***       select * from vbap into corresponding fields of table lt_vbap where vbeln = rs_selfield-value.
**
**DATA lt_fcat1 TYPE TABLE OF lvc_s_fcat. " For temporary field catalog
**DATA ls_fcat1 TYPE lvc_s_fcat.
**
**DATA lv_lines TYPE char2.
**DATA lv_index TYPE char2.
**
**DESCRIBE TABLE li_vbap LINES lv_lines.
**
**TYPES:BEGIN OF ty_dynst,
**        fname TYPE char10,
**      END OF ty_dynst.
**
***      data lt_dynst type table of ty_dynst.
**DATA ls_dynst TYPE ty_dynst.
**
**FIELD-SYMBOLS:<t_dyntable>  TYPE INDEX TABLE,
**              <fs_dyntable> TYPE any.
**
**ls_fcat1-fieldname = 'FIELD'.
**APPEND ls_fcat1 TO lt_fcat1.
**CLEAR ls_fcat1.
**
**ls_fcat1-fieldname = 'HEADER'.
**APPEND ls_fcat1 TO lt_fcat1.
**CLEAR ls_fcat1.
**
*** Build temporary field catalog to create dynamic internal table
**
**LOOP AT li_vbap ASSIGNING FIELD-SYMBOL(<lfs_li_vbap_2>).
**  lv_index = sy-index.
**  ls_fcat1-fieldname = <lfs_li_vbap_2>-posnr .
**
**  APPEND ls_fcat1 TO lt_fcat1.
**  CLEAR ls_dynst.
**  CLEAR lv_index.
**
**ENDLOOP.
**
**DATA:t_newtable  TYPE REF TO data.
**DATA: t_newline  TYPE REF TO data.
**DATA lv_tabix    TYPE sy-tabix.
**FIELD-SYMBOLS   <fs_test> TYPE any.
*** Create Dynamic internal table
**CALL METHOD cl_alv_table_create=>create_dynamic_table     "Here creates the internal table dynamcally
**  EXPORTING
**    it_fieldcatalog = lt_fcat1
**  IMPORTING
**    ep_table        = t_newtable.
**
*** Assign the field symbol with dynmica internal table
**ASSIGN t_newtable->* TO <t_dyntable>.
**
***Create dynamic work area and assign to FS
**
**CREATE DATA t_newline LIKE LINE OF <t_dyntable>.
**ASSIGN t_newline->* TO <fs_dyntable>.
**DATA:lv_counter TYPE i.
**DO 2 TIMES.
**
**  lv_counter = lv_counter + 1.
**  CASE lv_counter.
**    WHEN 1.
*** MOve the internal table data to field symbol
**      LOOP AT lt_output INTO lst_output.
**        ASSIGN COMPONENT 1  OF STRUCTURE <fs_dyntable> TO <fs_test>.
**        MOVE 'FRM FTP' TO <fs_test>.
**        DATA(lv_line) = line_index( lt_fcat1[ fieldname = lst_output-posnr ] ) .
**        IF lv_line IS NOT INITIAL .
**          ASSIGN COMPONENT lv_line OF STRUCTURE <fs_dyntable> TO <fs_test>.
**          MOVE lst_output-frm_ftp TO <fs_test>.
**        ENDIF.
**      ENDLOOP.
**    WHEN 2.
*** MOve the internal table data to field symbol
**      LOOP AT lt_output INTO lst_output.
**        ASSIGN COMPONENT 1  OF STRUCTURE <fs_dyntable> TO <fs_test>.
**        MOVE 'Rejected' TO <fs_test>.
**        lv_line = line_index( lt_fcat1[ fieldname = lst_output-posnr ] ) .
**        IF lv_line IS NOT INITIAL .
**          ASSIGN COMPONENT lv_line OF STRUCTURE <fs_dyntable> TO <fs_test>.
**          MOVE lst_output-rej TO <fs_test>.
**        ENDIF.
**      ENDLOOP.
**    WHEN 3.
**    WHEN OTHERS.
**  ENDCASE.
**  APPEND <fs_dyntable> TO <t_dyntable>.
**ENDDO.
**
*** Move the fieldsymbol data to standar internal table as REUSE_ALV_GRID_DISPLAY FM only allows standard field symbol type as OUTPUT
**FIELD-SYMBOLS <fs_stdtab> TYPE STANDARD TABLE.
**ASSIGN t_newtable->* TO <fs_stdtab>.
**<fs_stdtab>[] = <t_dyntable>[].
**
*** building new field catalog
**
**DATA lt_fieldcat TYPE TABLE OF slis_fieldcat_alv.
**DATA ls_fieldcat TYPE  slis_fieldcat_alv.
**
**LOOP AT lt_fcat1 INTO ls_fcat1.
**  ls_fieldcat-seltext_l = ls_fcat1-fieldname.
**  MOVE ls_fcat1-fieldname TO ls_fieldcat-fieldname.
**
**  APPEND ls_fieldcat TO lt_fieldcat.
**ENDLOOP.
**
***----------------------------
**cl_salv_table=>factory(
**   IMPORTING
**     r_salv_table   = o_popup_alv
**  CHANGING
**    t_table        =  <fs_stdtab> ).
**
**lo_functions = o_popup_alv->get_functions( ).
**lo_functions->set_default( 'X' ).
***
**
**DATA(lr_display) =  o_popup_alv->get_display_settings( ).
**lr_display->set_list_header( 'Cancellation/Block Details' ).
**
**DATA: lo_columns TYPE REF TO cl_salv_columns_table,
**      lo_column  TYPE REF TO cl_salv_column.
**
**TRY.
**    LOOP AT li_vbap ASSIGNING <lfs_vbap>.
**      lo_columns = o_popup_alv->get_columns( ).
**      DATA:lv_fieldname TYPE fieldname.
**      lv_fieldname = <lfs_vbap>-posnr.
**      lo_column = lo_columns->get_column( lv_fieldname ).
**      DATA:lv_text TYPE scrtext_l.
**      DATA(lv_posnr) = <lfs_vbap>-posnr.
**      SHIFT lv_posnr LEFT DELETING LEADING '0'.
**      lv_text = |Item| && |{ lv_posnr }|.
**      lo_column->set_long_text( lv_text ).
**      lo_column->set_output_length('7').
**    ENDLOOP.
**
**    lo_columns = o_popup_alv->get_columns( ).
**    lo_column = lo_columns->get_column( 'FIELD' ).
**    lo_column->set_long_text( 'Field' ).
**    lo_column->set_output_length('8').
**
**    lo_columns = o_popup_alv->get_columns( ).
**    lo_column = lo_columns->get_column( 'HEADER' ).
**    lo_column->set_long_text( 'Header' ).
**    lo_column->set_output_length('8').
**
**    lo_columns = o_popup_alv->get_columns( ).
**    lo_column = lo_columns->get_column( 'POSNR' ).
**    lo_column->set_long_text( 'Item' ).
**    lo_column->set_output_length('5').
**
***repeat above code for all the columns
**    lo_columns = o_popup_alv->get_columns( ).
**    lo_column = lo_columns->get_column( 'FRM_VCH' ).
**    lo_column->set_long_text( 'FRM VCH' ).
**    lo_column->set_output_length('8').
**
**    lo_columns = o_popup_alv->get_columns( ).
**    lo_column = lo_columns->get_column( 'FRM_FTP' ).
**    lo_column->set_long_text( 'FRM FTP' ).
**    lo_column->set_output_length('8').
**
**    lo_columns = o_popup_alv->get_columns( ).
**    lo_column = lo_columns->get_column( 'EAL' ).
**    lo_column->set_long_text( 'EAL' ).
**    lo_column->set_output_length('4').
**
**    lo_columns = o_popup_alv->get_columns( ).
**    lo_column = lo_columns->get_column( 'REJ' ).
**    lo_column->set_long_text( 'Rejected' ).
**    lo_column->set_output_length('10').
**
**    lo_columns = o_popup_alv->get_columns( ).
**    lo_column = lo_columns->get_column( 'CANC' ).
**    lo_column->set_long_text( 'Cancelled' ).
**    lo_column->set_output_length('10').
**
**    lo_columns = o_popup_alv->get_columns( ).
**    lo_column = lo_columns->get_column( 'BLOCK' ).
**    lo_column->set_long_text( 'Blocked' ).
**    lo_column->set_output_length('8').
**
**    lo_columns = o_popup_alv->get_columns( ).
**    lo_column = lo_columns->get_column( 'AC_SUS' ).
**    lo_column->set_long_text( 'Active Suspension' ).
**    lo_column->set_output_length('15').
**
**    lo_columns = o_popup_alv->get_columns( ).
**    lo_column = lo_columns->get_column( 'INCOMPLETE' ).
**    lo_column->set_long_text( 'Incomplete' ).
**    lo_column->set_output_length('10').
**  CATCH cx_salv_not_found.                              "#EC NO_HANDLER
**
**ENDTRY.
**
*** ALV as Popup
**o_popup_alv->set_screen_popup(
**  start_column = 10
**  end_column   = 100
**  start_line   = 3
**  end_line     = 20 ).
**
*** Display
**o_popup_alv->display( ).
***    ENDIF.
