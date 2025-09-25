class ZCL_GUI_ALV_GRID_MERGE definition
  public
  inheriting from CL_GUI_ALV_GRID
  final
  create public .

public section.

  methods METH_SET_MERGE_HORIZ
    importing
      !I_ROW type I
    changing
      !CH_TAB_COL_MERGE type LVC_T_CO01 .
  methods METH_SET_MERGE_VERT
    importing
      !I_ROW type I
    changing
      !CH_TAB_COL_MERGE type LVC_T_CO01 .
  methods METH_DISPLAY .
  methods METH_SET_CELL_STYLE
    importing
      !I_ROW type I optional
      !I_COL type I
      !I_STYLE type LVC_S_STYL-STYLE .
  methods METH_SET_FIXED_COL_ROW
    importing
      !I_ROW type I
      !I_COL type I .
  methods METH_INIT_CELL_STYLES .
  PROTECTED SECTION.
*"* protected components of class ZCL_GUI_ALV_GRID_MERGE
*"* do not include other source files here!!!
  PRIVATE SECTION.
*"* private components of class ZCL_GUI_ALV_GRID_MERGE
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_GUI_ALV_GRID_MERGE IMPLEMENTATION.


METHOD meth_display.

  DATA : lv_stable TYPE lvc_s_stbl,
         lv_soft   TYPE c.

**** Prepare refresh
*  lv_stable-row = 'X'.
*  lv_stable-col = 'X'.
*  lv_soft       = 'X'.
*
**** Refresh table because Z_SET_CELL_STYLE adds style-values
**** Refresh initializes mt_data
*  CALL METHOD refresh_table_display
*    EXPORTING
*      is_stable      = lv_stable
*      i_soft_refresh = lv_soft
*    EXCEPTIONS
*      OTHERS         = 1.

* Jetzt noch  #bertragen der ge#nderten Daten
  CALL METHOD me->set_data_table
    CHANGING
      data_table = mt_data[].

  CALL METHOD set_auto_redraw
    EXPORTING
      enable = 1.

ENDMETHOD.


METHOD meth_init_cell_styles.

  FIELD-SYMBOLS <lfs_data> TYPE lvc_s_data.
* Nur Spalte setze komplette Spalte
  LOOP AT mt_data ASSIGNING <lfs_data>.
    <lfs_data>-style = 0.
  ENDLOOP.

ENDMETHOD.


METHOD meth_set_cell_style.

  FIELD-SYMBOLS <lfs_data> TYPE lvc_s_data.
  IF i_row IS INITIAL.
    IF i_col IS INITIAL.
* Beides leer -> nichts zu tun.
      EXIT.
    ELSE.
* Nur Spalte setze komplette Spalte
      LOOP AT mt_data ASSIGNING <lfs_data>
             WHERE col_pos = i_col.
        <lfs_data>-style  = <lfs_data>-style + i_style.
        <lfs_data>-style2 = <lfs_data>-style2 + i_style.
      ENDLOOP.
    ENDIF.
  ELSE.
    IF i_col IS INITIAL.
* Nur Zeile eingegeben -> komplette Zeile setzen
      LOOP AT mt_data ASSIGNING <lfs_data>
             WHERE row_pos = i_row.
        <lfs_data>-style  = <lfs_data>-style + i_style.
        <lfs_data>-style2 = <lfs_data>-style2 + i_style.
      ENDLOOP.
    ELSE.
      READ TABLE mt_data ASSIGNING <lfs_data>
          WITH KEY row_pos = i_row
                   col_pos = i_col.
      IF sy-subrc EQ 0.
        <lfs_data>-style  = <lfs_data>-style + i_style.
        <lfs_data>-style2 = <lfs_data>-style2 + i_style.
      ELSE.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD meth_set_fixed_col_row.

  me->set_fixed_cols( i_col ).
  me->set_fixed_rows( i_row ).

ENDMETHOD.


METHOD meth_set_merge_horiz.

* ROW - Zeile deren Spalten zusammengef#hrt werden sollen
* tab_col_merge - Spalten, die zusammengef#hrt werden sollen
  FIELD-SYMBOLS <lfs_cols> TYPE lvc_s_co01.
  FIELD-SYMBOLS <lfs_data> TYPE lvc_s_data.
  DATA outputlen TYPE i.
  SORT ch_tab_col_merge.
* Die Spalten, die zusammengef#hrt werden sollen
  LOOP AT ch_tab_col_merge ASSIGNING <lfs_cols>.
* ein paar Pr#fungen
    IF <lfs_cols>-col_id    LE 0.                CONTINUE. ENDIF.
    IF <lfs_cols>-outputlen LE <lfs_cols>-col_id. CONTINUE. ENDIF.
    outputlen = <lfs_cols>-outputlen - <lfs_cols>-col_id.
    LOOP AT mt_data ASSIGNING <lfs_data>
         WHERE row_pos = i_row  AND
               ( col_pos BETWEEN <lfs_cols>-col_id AND
                                 <lfs_cols>-outputlen ).
* Setze wie weit soll gemerged werden Von Spalte in L#nge
* und zwar wird bei der 1 Spalte angefangen
      IF <lfs_data>-col_pos = <lfs_cols>-col_id.
        <lfs_data>-mergehoriz = outputlen.
* bei allen anderen, die zusammangeh#ren
* muss der Wert raus, da er aus der 1. Spalte kommt
* und das mergekennzeichen muss auch weg !
      ELSE.
        CLEAR <lfs_data>-mergehoriz.
        CLEAR <lfs_data>-value.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

ENDMETHOD.


METHOD meth_set_merge_vert.

* ROW - Zeile deren Spalten zusammengef#hrt werden sollen
* tab_col_merge - Spalten, die zusammengef#hrt werden sollen
  FIELD-SYMBOLS <lfs_cols> TYPE lvc_s_co01.
  FIELD-SYMBOLS <lfs_data> TYPE lvc_s_data.
  DATA outputlen TYPE i.
  SORT ch_tab_col_merge.

* Die Spalten, die zusammengef#hrt werden sollen
  LOOP AT ch_tab_col_merge ASSIGNING <lfs_cols>.

* ein paar Pr#fungen

    IF <lfs_cols>-col_id    LE 0.                CONTINUE. ENDIF.
    IF <lfs_cols>-outputlen LE <lfs_cols>-col_id. CONTINUE. ENDIF.
    outputlen = <lfs_cols>-outputlen - <lfs_cols>-col_id.
    LOOP AT mt_data ASSIGNING <lfs_data>
         WHERE row_pos = i_row  AND
               ( col_pos BETWEEN <lfs_cols>-col_id AND
                                 <lfs_cols>-outputlen ).

* Setze wie weit soll gemerged werden Von Spalte in L#nge
* und zwar wird bei der 1 Spalte angefangen

      IF <lfs_data>-col_pos = <lfs_cols>-col_id.
        <lfs_data>-mergevert = outputlen.
* bei allen anderen, die zusammangeh#ren
* muss der Wert raus, da er aus der 1. Spalte kommt
* und das mergekennzeichen muss auch weg !
      ELSE.
        CLEAR <lfs_data>-mergevert.
*        CLEAR <lfs_data>-value.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

ENDMETHOD.
ENDCLASS.
