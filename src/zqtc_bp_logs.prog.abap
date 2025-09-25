*&---------------------------------------------------------------------*
*& Report ZQTC_SLGD_PROGRAM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zqtc_bp_logs.

TABLES:but000,balhdr,knb1,knvv.

TYPES: BEGIN OF ty_sales_area,
         vkorg  TYPE vkorg,
         vtweg  TYPE vtweg,
         spart  TYPE spart,
         chk(1),
       END OF ty_sales_area.

DATA: li_fieldcat    TYPE slis_t_fieldcat_alv,
      lst_fieldcat   TYPE slis_fieldcat_alv,
      lst_selfield   TYPE slis_selfield,
      li_sales_area  TYPE TABLE OF ty_sales_area,
      li_selected_sa TYPE TABLE OF ty_sales_area,
      lst_restrict   TYPE sscr_restrict,
      lst_optlist    TYPE sscr_opt_list,
      lst_ass        TYPE sscr_ass.

DATA:v_sales_area TYPE char15.

CONSTANTS:lc_name    TYPE rsrest_opl VALUE 'OBJECTKEY1', " Name of an options list for SELECT-OPTIONS restrictions
          lc_flag    TYPE flag VALUE 'X',                " General Flag,
          lc_kind    TYPE rsscr_kind VALUE 'S',         " ABAP: Type of selection
          lc_sg_main TYPE raldb_sign VALUE 'I',          " SIGN field in creation of SELECT-OPTIONS tables
          lc_sg_addy TYPE raldb_sign VALUE space,        " SIGN field in creation of SELECT-OPTIONS tables
          lc_op_main TYPE rsrest_opl VALUE 'OBJECTKEY1'. " Name of an options list for SELECT-OPTIONS restrictions

SELECTION-SCREEN BEGIN OF BLOCK gen WITH FRAME TITLE TEXT-gen.
SELECT-OPTIONS: so_bp FOR but000-partner NO INTERVALS,
                so_user FOR balhdr-aluser NO INTERVALS.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (31) TEXT-001 FOR FIELD pa_df.
PARAMETERS pa_df TYPE baldate.
PARAMETERS pa_tf TYPE baltime.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (31) TEXT-002 FOR FIELD pa_dt.
PARAMETERS pa_dt TYPE baldate.
PARAMETERS pa_tt TYPE baltime.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK gen.

SELECTION-SCREEN BEGIN OF BLOCK sad WITH FRAME TITLE TEXT-sad.
SELECT-OPTIONS:so_sa FOR v_sales_area NO INTERVALS NO-EXTENSION MODIF ID m1.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 30(45) TEXT-003.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK sad.

SELECTION-SCREEN BEGIN OF BLOCK fid WITH FRAME TITLE TEXT-fid.
SELECT-OPTIONS  so_bukrs FOR knb1-bukrs NO INTERVALS.
SELECTION-SCREEN END OF BLOCK fid.


INITIALIZATION.
  CLEAR: lst_optlist , lst_ass.
* Restricting the KURST selection to only EQ.
  lst_optlist-name = lc_name.
  lst_optlist-options-eq = lc_flag.
  APPEND lst_optlist TO lst_restrict-opt_list_tab.

  lst_ass-kind = lc_kind.
  lst_ass-name = 'SO_SA'.
  lst_ass-sg_main = lc_sg_main.
  lst_ass-sg_addy = lc_sg_addy.
  lst_ass-op_main = lc_op_main.
  APPEND lst_ass TO lst_restrict-ass_tab.

  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING
      restriction            = lst_restrict
    EXCEPTIONS
      too_late               = 1
      repeated               = 2
      selopt_without_options = 3
      selopt_without_signs   = 4
      invalid_sign           = 5
      empty_option_list      = 6
      invalid_kind           = 7
      repeated_kind_a        = 8
      OTHERS                 = 9.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

** Fetch Sales Area
  SELECT vkorg,
         vtweg,
         spart FROM tvta INTO TABLE @li_sales_area.

  IF sy-subrc IS INITIAL.

  ENDIF.

AT SELECTION-SCREEN OUTPUT.
*  LOOP AT SCREEN.
*    IF screen-group1 = 'M1'.
**      screen-input = 0.
*      MODIFY SCREEN.
*    ENDIF.
*  ENDLOOP.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_sa-low.
  IF li_selected_sa[] IS INITIAL.
    li_selected_sa = li_sales_area.
  ENDIF.

  CLEAR: li_fieldcat[].
  lst_fieldcat-fieldname = 'VKORG'.
  lst_fieldcat-outputlen = 10.
  lst_fieldcat-seltext_s = 'S.Org'.
  lst_fieldcat-tabname = 'LI_SELECTED_SA'.
  lst_fieldcat-col_pos = 1.
  APPEND lst_fieldcat TO li_fieldcat.
  CLEAR lst_fieldcat.

  lst_fieldcat-fieldname = 'VTWEG'.
  lst_fieldcat-outputlen = 10.
  lst_fieldcat-seltext_s = 'Dis.Ch'.
  lst_fieldcat-tabname = 'LI_SELECTED_SA'.
  lst_fieldcat-col_pos = 2.
  APPEND lst_fieldcat TO li_fieldcat.
  CLEAR lst_fieldcat.

  lst_fieldcat-fieldname = 'SPART'.
  lst_fieldcat-outputlen = 10.
  lst_fieldcat-seltext_s = 'Div'.
  lst_fieldcat-tabname = 'LI_SELECTED_SA'.
  lst_fieldcat-col_pos = 3.
  APPEND lst_fieldcat TO li_fieldcat.
  CLEAR lst_fieldcat.

  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title                 = 'Select Sales Area'
*     i_selection             = 'X'
      i_zebra                 = 'X'
      i_screen_start_column   = 55
      i_screen_start_line     = 6
      i_screen_end_column     = 90
      i_screen_end_line       = 50
      i_checkbox_fieldname    = 'CHK'
      i_tabname               = 'LI_SELECTED_SA'
      i_scroll_to_sel_line    = 'X'
      it_fieldcat             = li_fieldcat
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_COMMAND'
    IMPORTING
      es_selfield             = lst_selfield
    TABLES
      t_outtab                = li_selected_sa
    EXCEPTIONS
      program_error           = 1.

  CLEAR so_sa[].
*  DATA:lst_sa LIKE LINE OF so_sa.
*  LOOP AT li_selected_sa INTO DATA(lst_sales_area) WHERE chk EQ abap_true.
*    so_sa-sign = 'I'.
*    so_sa-option = 'EQ'.
*    so_sa-low = |{ lst_sales_area-vkorg }| & |/| & |{ lst_sales_area-vtweg }| & |/| & |{ lst_sales_area-spart }|.
**    APPEND lst_sa TO so_sa.
*    APPEND so_sa.
**    IF sy-tabix EQ 1.
**      so_sa = lst_sa.
**    ENDIF.
**    CLEAR lst_sa.
*  ENDLOOP.

  READ TABLE li_selected_sa INTO DATA(lst_sales_area) WITH KEY chk = abap_true.
  IF sy-subrc IS INITIAL.
    so_sa-sign = 'I'.
    so_sa-option = 'EQ'.
    so_sa-low = |{ lst_sales_area-vkorg }| & |/| & |{ lst_sales_area-vtweg }| & |/| & |{ lst_sales_area-spart }|.
    APPEND so_sa.
  ENDIF.

AT SELECTION-SCREEN.

START-OF-SELECTION.
