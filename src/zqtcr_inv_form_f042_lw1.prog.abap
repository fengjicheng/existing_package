*& Thread: styles
*& <a class="jive_macro jive_macro_thread" href="" __jive_macro_name="thread" modifiedtitle="true" __default_attr="830498"></a>
*& Thread: push button at item level in alv grid
*& <a class="jive_macro jive_macro_thread" href="" __jive_macro_name="thread" modifiedtitle="true" __default_attr="876412"></a>
*&---------------------------------------------------------------------*
*& The report generates style values and shows their effect in ALV grid.
*& In addition, it demonstrates how to define buttons at cell level.
*&---------------------------------------------------------------------*


REPORT  ZQTCR_INV_FORM_F042_LW1.


TYPE-POOLS: abap.


TYPES: BEGIN OF ty_s_outtab.
INCLUDE TYPE knb1.
TYPES: celltab TYPE lvc_t_styl. " cell style
TYPES: END OF ty_s_outtab.
TYPES: ty_t_outtab TYPE STANDARD TABLE OF ty_s_outtab
WITH DEFAULT KEY.



TYPES: BEGIN OF ty_s_outtab2.
INCLUDE TYPE lvc_s_styl.
TYPES: celltab TYPE lvc_t_styl. " cell style
TYPES: END OF ty_s_outtab2.
TYPES: ty_t_outtab2 TYPE STANDARD TABLE OF ty_s_outtab2
WITH DEFAULT KEY.

DATA:
gs_layout TYPE lvc_s_layo,
gs_variant TYPE disvariant,
gt_fcat TYPE lvc_t_fcat.

DATA:
gt_outtab TYPE ty_t_outtab,
gt_outtab2  TYPE ty_t_outtab2.


*----------------------------------------------------------------------*
*       CLASS lcl_eventhandler DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_eventhandler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      handle_button_click
        FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING
          es_col_id
          es_row_no
          sender.

ENDCLASS.                    "lcl_eventhandler DEFINITION



*----------------------------------------------------------------------*
*       CLASS lcl_eventhandler IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_eventhandler IMPLEMENTATION.

  METHOD handle_button_click.
    " define local data
    DATA: ls_outtab2    TYPE ty_s_outtab2,
          ld_msg        type bapi_msg.

    READ TABLE gt_outtab2 INTO ls_outtab2 INDEX es_row_no-row_id.
    IF ( syst-subrc = 0 ).
      write ls_outtab2-maxlen to ld_msg no-zero.
      CONDENSE ld_msg NO-GAPS.
      concatenate 'MAXLEN =' ld_msg into ld_msg
        SEPARATED BY space.
      MESSAGE ld_msg TYPE 'I'.
    ENDIF.
  ENDMETHOD.                    "handle_button_click

ENDCLASS.                    "lcl_eventhandler IMPLEMENTATION


PARAMETERS:
  p_rows    TYPE i DEFAULT 200.


START-OF-SELECTION.

  SELECT * FROM knb1 UP TO 100 ROWS
  INTO CORRESPONDING FIELDS OF TABLE gt_outtab
  WHERE bukrs = '1000'.

  PERFORM set_layout_and_variant.
**  PERFORM set_cell_style.

**  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
**    EXPORTING
**      i_structure_name = 'KNB1'
**      i_grid_title     = 'Cell Styles'
**      is_layout_lvc    = gs_layout
**      i_save           = 'A'
**      is_variant       = gs_variant
**    TABLES
**      t_outtab         = gt_outtab
**    EXCEPTIONS
**      program_error    = 1
**      OTHERS           = 2.
**  IF sy-subrc = 0.
**  ENDIF.


  PERFORM fill_outtab2.
**  PERFORM fill_fieldcatalog_2.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_structure_name = 'LVC_S_STYL'
      i_grid_title     = 'Cell Styles'
      is_layout_lvc    = gs_layout
      i_save           = 'A'
      is_variant       = gs_variant
*      IT_FIELDCAT_LVC  = gt_fcat
    TABLES
      t_outtab         = gt_outtab2
    EXCEPTIONS
      program_error    = 1
      OTHERS           = 2.
  IF sy-subrc = 0.
  ENDIF.

END-OF-SELECTION.


*&---------------------------------------------------------------------
*& Form SET_LAYOUT_AND_VARIANT
*&---------------------------------------------------------------------

FORM set_layout_and_variant .

  CLEAR: gs_layout,
  gs_variant.

  gs_layout-cwidth_opt = abap_true.
  gs_layout-stylefname = 'CELLTAB'.

  gs_variant-report = syst-repid.
  gs_variant-handle = 'STYL'.

ENDFORM. " SET_LAYOUT_AND_VARIANT


*&---------------------------------------------------------------------*
*&      Form  set_cell_style
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM set_cell_style .

* define local data
  CONSTANTS:
  lc_style_bold TYPE int4 VALUE '00000121',
  lc_style_red TYPE int4 VALUE '00000087',
  lc_style_cursive TYPE int4 VALUE '00008700',
  lc_style_underline_faint TYPE int4 VALUE '00008787',
  lc_style_underline TYPE int4 VALUE '00008707',
  lc_style_underline_red TYPE int4 VALUE '00008007'.

  DATA:
  ls_outtab TYPE ty_s_outtab,
  ls_style TYPE lvc_s_styl,
  lt_celltab TYPE lvc_t_styl.


  CLEAR: ls_style.
  ls_style-fieldname = 'BUKRS'.
  ls_style-style = '00000011'.    " make contents invisible
  INSERT ls_style INTO TABLE lt_celltab.

**  CLEAR: ls_style.
**  ls_style-fieldname = 'BUKRS'.
**  ls_style-style = lc_style_bold.
**  INSERT ls_style INTO TABLE lt_celltab.
***
**  CLEAR: ls_style.
**  ls_style-fieldname = 'KUNNR'.
**  ls_style-style = lc_style_red.
**  INSERT ls_style INTO TABLE lt_celltab.
***
**  CLEAR: ls_style.
**  ls_style-fieldname = 'ERDAT'.
**  ls_style-style = lc_style_cursive.
**  INSERT ls_style INTO TABLE lt_celltab.
***
**  CLEAR: ls_style.
**  ls_style-fieldname = 'ERNAM'.
**  ls_style-style = lc_style_underline.
**  INSERT ls_style INTO TABLE lt_celltab.




  ls_outtab-celltab = lt_celltab.
  MODIFY gt_outtab FROM ls_outtab
  TRANSPORTING celltab
  WHERE ( bukrs = '1000' ).

ENDFORM. " SET_CELL_STYLE
*&---------------------------------------------------------------------*
*&      Form  FILL_OUTTAB2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_outtab2 .
* define local data
  DATA: ls_outtab2  TYPE ty_s_outtab2,
        ld_num8(8)  TYPE n,
        ld_rest     TYPE i,
        ld_idx      TYPE i,
        ld_fname    TYPE fieldname,
        ld_perc     TYPE i,
        ld_text(50) TYPE c.

  DATA:
  ls_style TYPE lvc_s_styl,
  lt_celltab TYPE lvc_t_styl.

  FIELD-SYMBOLS: <ld_style>  TYPE lvc_style.

  ld_num8 = 0.


  DO p_rows TIMES.
    WRITE syst-index TO ld_text NO-ZERO.
    CONDENSE ld_text NO-GAPS.
    ld_perc = ( syst-index * 100 ) / p_rows.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = ld_perc
        text       = ld_text.


    CLEAR: ls_style,
       ls_outtab2.
    REFRESH: lt_celltab.


    ls_outtab2-maxlen = syst-index.
    " NOTE: Display every 7th MAXLEN cell as button
    ld_rest = ls_outtab2-maxlen MOD 7.
    IF ( ld_rest = 0 ).
      ls_style-style = cl_gui_alv_grid=>mc_style_button.
      ls_style-fieldname = 'MAXLEN'.
      INSERT ls_style INTO TABLE lt_celltab.
    ENDIF.


    MOVE ld_num8 TO ls_outtab2-style.
    ls_style-style = ls_outtab2-style.

    INSERT ls_style INTO TABLE lt_celltab.
    ls_outtab2-celltab = lt_celltab.

    APPEND ls_outtab2 TO gt_outtab2.

    ADD 1 TO ld_num8.
  ENDDO.




ENDFORM.                    " FILL_OUTTAB2
*&---------------------------------------------------------------------*
*&      Form  FILL_FIELDCATALOG_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_fieldcatalog_2 .
* define local data
  DATA: ls_fcat TYPE lvc_s_fcat,
        lt_fcat TYPE lvc_t_fcat.

  DATA: ld_fname  TYPE fieldname.


  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     I_BUFFER_ACTIVE              =
      i_structure_name             = 'LVC_S_STYL'
*     I_CLIENT_NEVER_DISPLAY       = 'X'
*     I_BYPASSING_BUFFER           =
*     I_INTERNAL_TABNAME           =
    CHANGING
      ct_fieldcat                  = lt_fcat
    EXCEPTIONS
      inconsistent_interface       = 1
      program_error                = 2
      OTHERS                       = 3.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  DELETE lt_fcat WHERE ( fieldname NE 'STYLE' ).

  READ TABLE lt_fcat INTO ls_fcat INDEX 1.

  DO 16 TIMES.
    ls_fcat-fieldname = 'STYLE'.
    ls_fcat-col_pos = syst-index.

    WRITE syst-index TO ld_fname NO-ZERO.
    CONDENSE ld_fname NO-GAPS.
    CONCATENATE ls_fcat-fieldname ld_fname INTO ls_fcat-fieldname.

    APPEND ls_fcat TO gt_fcat.
  ENDDO.

ENDFORM.
