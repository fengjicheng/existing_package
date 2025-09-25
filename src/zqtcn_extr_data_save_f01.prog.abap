*&---------------------------------------------------------------------*
*&  Include           ZQTCN_EXTR_DATA_SAVE_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_EXTR_DATA_SAVE
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:        ZQTCR_EXTR_DATA_SAVE
*& PROGRAM DESCRIPTION: Program to update Custom table from extractor data
*& DEVELOPER:           Krishna & Rajkumar Madavoina
*& CREATION DATE:       04/20/2021
*& OBJECT ID:
*& TRANSPORT NUMBER(S): ED2K923107
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* MODIFICATION:
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_fetch_data .
"To fetch the data from STXH & STXL tables for VBBK & VBBP tables
  gr_tdobj_vbbp = VALUE #( sign = gc_i
                     option = gc_eq
                      ( low = gc_vbbp ) ).

  gr_tdobj_vbbk = VALUE #( sign = gc_i
                     option = gc_eq
                      ( low = gc_vbbk )  ).
"To fetch the data from STXH & STXL tables for VBBK & VBBP tables with IDs
" 0012, 0017, 0019, 0020, 0043 and 0050
  gr_tdid_vbbp = VALUE #( sign = gc_i
                     option = gc_eq
                     ( low = gc_12 )
                     ( low = gc_17 )
                     ( low = gc_19 )
                     ( low = gc_20 )
                     ( low = gc_43 )
                     ( low = gc_50 ) ).

  gr_tdid_vbbk = VALUE #( sign = gc_i
                     option = gc_eq
                     ( low = gc_04 ) ).
*"Fetching the data frm STXH table for VBBP and VBBK tables
*  SELECT tdobject,                "#EC CI_NO_TRANSFORM
*         tdname,
*         tdid,
*         tdspras,
*         tdfuser,
*         tdfdate,
*         tdluser,
*         tdldate
*    FROM stxh
*    INTO TABLE @DATA(lt_stxh)
*    WHERE ( ( tdobject IN @gr_tdobj_vbbp
*      AND tdid IN @gr_tdid_vbbp )
*       OR ( tdobject IN @gr_tdobj_vbbk
*      AND tdid IN @gr_tdid_vbbk ) )
*      AND ( ( tdldate IN @s_date
*       OR tdfdate IN @s_date ) ).
*
*  IF  sy-subrc IS INITIAL
*  AND lt_stxh  IS NOT INITIAL.
** Inner Join the STXH & STXL tables to get the data
*    SELECT b~tdobject,b~tdname,b~tdid,b~tdspras,a~tdfuser,a~tdfdate,a~tdluser,a~tdldate    "#EC CI_NO_TRANSFORM
*      FROM stxh AS a INNER JOIN
*           stxl AS b
*      ON a~tdobject = b~tdobject
*      AND a~tdname = b~tdname
*      AND a~tdid = b~tdid
*      AND a~tdspras = b~tdspras
*      INTO TABLE @DATA(lt_data)
*      FOR ALL ENTRIES IN @lt_stxh[]
*      WHERE b~tdobject = @lt_stxh-tdobject
*        AND b~tdname = @lt_stxh-tdname
*        AND b~tdid = @lt_stxh-tdid
*        AND b~tdspras = @lt_stxh-tdspras.         "#EC CI_SUBRC
*  ENDIF.


   SELECT b~tdobject,b~tdname,b~tdid,b~tdspras,a~tdfuser,a~tdfdate,a~tdluser,a~tdldate    "#EC CI_NO_TRANSFORM
     FROM stxh AS a INNER JOIN
          stxl AS b
     ON a~tdobject = b~tdobject
     AND a~tdname = b~tdname
     AND a~tdid = b~tdid
     AND a~tdspras = b~tdspras
     INTO TABLE @DATA(lt_data)
   WHERE ( ( b~tdobject IN @gr_tdobj_vbbp
     AND b~tdid IN @gr_tdid_vbbp )
      OR ( b~tdobject IN @gr_tdobj_vbbk
     AND b~tdid IN @gr_tdid_vbbk ) )
     AND ( ( a~tdldate IN @s_date
     OR a~tdfdate IN @s_date ) ).

  IF lt_data[] IS INITIAL.
    MESSAGE text-003 TYPE gc_e.
  ELSE.
    gt_fin[] = lt_data[].
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_process_data .

  TYPES: BEGIN OF lty_order,
           vbeln TYPE vbeln,
           posnr TYPE posnr,
         END OF lty_order.

  DATA: lt_order TYPE SORTED TABLE OF lty_order WITH UNIQUE KEY vbeln posnr,
        lv_txt   TYPE zqtc_txt_ext-zvalue,
        lv_text  TYPE zqtc_txt_ext-zvalue.
*   Fetching document type based on order number
  IF  gt_fin[] IS NOT INITIAL.

    SELECT vbeln,auart                        "#EC CI_NO_TRANSFORM
      FROM vbak
      INTO TABLE @DATA(lt_auart)
      FOR ALL ENTRIES IN @gt_fin[]
      WHERE vbeln = @gt_fin-tdname+0(10).

    IF  sy-subrc IS INITIAL
    AND lt_auart IS NOT INITIAL.

      SORT lt_auart
        BY vbeln.

    ENDIF.

  ENDIF.

  LOOP AT gt_fin ASSIGNING FIELD-SYMBOL(<ls_fin>).
    IF NOT line_exists( gt_data[ tdobject = <ls_fin>-tdobject
                                 tdname = <ls_fin>-tdname
                                 tdid   = <ls_fin>-tdid
                                 tdspras = <ls_fin>-tdspras
                                 ] ).

*   Fetching extractor text value
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = <ls_fin>-tdid
          language                = 'E'
          name                    = <ls_fin>-tdname
          object                  = <ls_fin>-tdobject
        IMPORTING
          header                  = gd_head
        TABLES
          lines                   = gt_line
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.

      CLEAR: lv_text, lv_txt.
      IF sy-subrc = 0.
* Implement suitable error handling here
        LOOP AT gt_line INTO DATA(ls_line).     "#EC CI_NESTED
          IF ls_line-tdline NE ''.
            lv_text =  ls_line-tdline.
            IF lv_txt IS INITIAL.
              lv_txt = lv_text.
            ELSE.
*              lv_txt = |{ lv_txt }| & | ; | & | { lv_text }|.
              CONCATENATE lv_txt
                          lv_text
                     INTO lv_txt
                SEPARATED BY ';'.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.

      gv_vbeln = <ls_fin>-tdname+0(10).
      gv_posnr = <ls_fin>-tdname+11(6).

*   Fetching document type based on order number
     CLEAR gv_auart.

     READ TABLE lt_auart
       INTO DATA(wa_auart)
       WITH KEY vbeln = gv_vbeln
       BINARY SEARCH.

     IF  sy-subrc IS INITIAL
     AND wa_auart IS NOT INITIAL.

       MOVE:wa_auart-auart TO gv_auart.

     ENDIF.

"Inserting the values into final internal table gt_data
     INSERT VALUE #( tdobject = <ls_fin>-tdobject
                      tdname = <ls_fin>-tdname
                      tdid = <ls_fin>-tdid
                      tdspras = <ls_fin>-tdspras
                      tdfuser = <ls_fin>-tdfuser
                      tdfdate = <ls_fin>-tdfdate
                      tdluser = <ls_fin>-tdluser
                      tdldate = <ls_fin>-tdldate
                      dltdate = sy-datum
                      vbeln   = gv_vbeln
                      posnr   = gv_posnr
                      zvalue  = lv_txt
                      auart   = gv_auart
                       ) INTO TABLE gt_data.

    ENDIF.
  ENDLOOP.

*   Updating custom table based on internal table

  MODIFY zqtc_txt_ext FROM TABLE gt_data[].

*Update ZCAINTERFACE table

  MOVE: gc_devid    TO gv_zcainterface-devid,
        gc_runtime  TO gv_zcainterface-param1,
        sy-datum    TO gv_zcainterface-lrdat,
        sy-uzeit    TO gv_zcainterface-lrtime.

  MODIFY zcainterface
    FROM gv_zcainterface.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_display_data .
  DATA: gv_alv  TYPE REF TO cl_salv_table,
        gv_func TYPE REF TO cl_salv_functions.
  DATA: ls_key TYPE salv_s_layout_key.

  IF sy-batch IS INITIAL.
  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gv_alv
        CHANGING
          t_table      = gt_data.

    CATCH cx_salv_msg .
  ENDTRY.

**... §3.2 include own functions by setting own status
*  gv_alv->set_screen_status(
*    pfstatus      =  'STANDARD'
*    report        =  sy-repid
*    set_functions = gv_alv->c_functions_all ).

  "To hide the column while in display
  gv_func = gv_alv->get_functions( ).

  DATA(lr_layout) = gv_alv->get_layout( ).
  ls_key-report = sy-repid.
  lr_layout->set_key( ls_key ).
  lr_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).

  DATA(ls_cols) = gv_alv->get_columns( ).

  ls_cols->set_optimize( 'X' ).

  TRY.
      DATA(ls_col1) = ls_cols->get_column( 'TDOBJECT' ).
      DATA(ls_col2) = ls_cols->get_column( 'TDNAME' ).
      DATA(ls_col3) = ls_cols->get_column( 'TDID' ).
      DATA(ls_col4) = ls_cols->get_column( 'TDSPRAS' ).
      DATA(ls_col5) = ls_cols->get_column( 'TDFUSER' ).
      DATA(ls_col6) = ls_cols->get_column( 'TDFDATE' ).
      DATA(ls_col7) = ls_cols->get_column( 'TDLUSER' ).
      DATA(ls_col8) = ls_cols->get_column( 'TDLDATE' ).
      DATA(ls_col9) = ls_cols->get_column( 'DLTDATE' ).
      DATA(ls_col10) = ls_cols->get_column( 'ZVALUE' ).
      DATA(ls_col11) = ls_cols->get_column( 'VBELN' ).
      DATA(ls_col12) = ls_cols->get_column( 'POSNR' ).
      DATA(ls_col13) = ls_cols->get_column( 'AUART' ).
    CATCH cx_salv_not_found.
  ENDTRY.
**************************************************
  ls_col1->set_long_text('APPLICATION OBJECT').
  ls_col1->set_medium_text('APPLICATION OBJECT').
  ls_col1->set_short_text('APP OBJ').
*************************************************
*************************************************
  ls_col2->set_long_text('NAME').
  ls_col2->set_medium_text('NAME').
  ls_col2->set_short_text('NAME').
*************************************************
*************************************************
  ls_col3->set_long_text('TEXT ID').
  ls_col3->set_medium_text('TEXT ID').
  ls_col3->set_short_text('TEXT ID').
*************************************************
*************************************************
  ls_col4->set_long_text('LANGUAGE KEY').
  ls_col4->set_medium_text('LANGUAGE KEY').
  ls_col4->set_short_text('LANG KEY').
*************************************************
*************************************************
  ls_col5->set_long_text('CREATED BY').
  ls_col5->set_medium_text('CREATED BY').
  ls_col5->set_short_text('CREATE BY').
*************************************************
*************************************************
  ls_col6->set_long_text('DATE CREATED').
  ls_col6->set_medium_text('DATE CREATED').
  ls_col6->set_short_text('DT CREATE').
*************************************************
*************************************************
  ls_col7->set_long_text('LAST CHANGED BY').
  ls_col7->set_medium_text('LAST CHANGED BY').
  ls_col7->set_short_text('LAST CNG').
*************************************************
*************************************************
  ls_col8->set_long_text('CHANGE ON DATE').
  ls_col8->set_medium_text('CHANGE ON DATE').
  ls_col8->set_short_text('CHANGE DT').
*************************************************
*************************************************
  ls_col9->set_long_text('DELTA DATE').
  ls_col9->set_medium_text('DELTA DATE').
  ls_col9->set_short_text('DELTA DT').
*************************************************
*************************************************
  ls_col10->set_long_text('TEXT VALUE').
  ls_col10->set_medium_text('TEXT VALUE').
  ls_col10->set_short_text('TXT VALUE').
*************************************************
*************************************************
  ls_col11->set_long_text('SALES DOCUMENT').
  ls_col11->set_medium_text('SALES DOCUMENT').
  ls_col11->set_short_text('SO NO').
*************************************************
*************************************************
  ls_col12->set_long_text('SALES DOCUMENT ITEM').
  ls_col12->set_medium_text('SALES DOCUMENT ITEM').
  ls_col12->set_short_text('SO ITEM').
*************************************************
*************************************************
  ls_col13->set_long_text('DOCUMENT TYPE').
  ls_col13->set_medium_text('DOCUMENT TYPE').
  ls_col13->set_short_text('DOC TYPE').
*************************************************
*************************************************

*... §7 selections
  DATA: lr_selections TYPE REF TO cl_salv_selections,
        lt_rows       TYPE salv_t_row,
        lt_column     TYPE salv_t_column,
        ls_cell       TYPE salv_s_cell.

  lr_selections = gv_alv->get_selections( ).

*... §7.1 set selection mode
  lr_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

  "To display the toolbar
  CALL METHOD gv_func->set_all
    EXPORTING
      value = if_salv_c_bool_sap=>true.

  gv_alv->display( ).

  ELSEIF sy-batch IS NOT INITIAL.

    WRITE: text-004.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_LAYOUT
*&---------------------------------------------------------------------*
FORM f_save_layout .
  DATA: lv_restrict TYPE salv_de_layout_restriction,
        lv_layout   TYPE disvariant-variant.
  DATA: ls_layout TYPE salv_s_layout_info,
        ls_key    TYPE salv_s_layout_key.

  ls_key-report = sy-repid.

  ls_layout = cl_salv_layout_service=>f4_layouts(
  s_key    = ls_key
  restrict = lv_restrict ).

  lv_layout = ls_layout-layout.
*  p_layout = lv_layout.

ENDFORM.
