*&---------------------------------------------------------------------*
*&  Include  ZQTC_MAINTAIN_CONST_ENT_TOP
*&---------------------------------------------------------------------*

* Local Types
TYPES: BEGIN OF ty_litho_tm.
        INCLUDE TYPE zscm_litho_tm.
        TYPES: sel TYPE char1.
TYPES: END OF ty_litho_tm.

* Tables declaration
TABLES: zscm_litho_tm, mara.

* Global data declaration
DATA:
  i_litho_tm  TYPE STANDARD TABLE OF ty_litho_tm INITIAL SIZE 0,
  st_litho_tm TYPE zscm_litho_tm,
  gr_alv_grid TYPE REF TO cl_gui_alv_grid,
  i_fcat_out  TYPE slis_t_fieldcat_alv,                        " ALV Fieldcat
  v_answer    TYPE char1,                                      " Answer
  ok_code     TYPE syst_ucomm,                                 " User Commend
  v_sub_9051  TYPE syst_dynnr VALUE '9051'.


CONSTANTS:
  c_se38         TYPE char4          VALUE 'SE38',             " Workbench transaction
  lc_pf_status   TYPE slis_formname  VALUE 'F_SET_PF_STATUS',  " PF Status
  lc_user_comm   TYPE slis_formname  VALUE 'F_USER_COMMAND',   " User Command
  lc_top_of_page TYPE slis_formname  VALUE 'F_TOP_OF_PAGE',    " Top of Page
  lc_typ_h       TYPE char1          VALUE 'H',                " Typ_h of type CHAR1
  c_canc         TYPE sy-ucomm       VALUE 'CX_CANC',          " Cancel
  c_save         TYPE sy-ucomm       VALUE 'CX_SAVE',          " Save
  c_c            TYPE char1          VALUE 'C',                " center
  c_astrick      TYPE char1          VALUE '*',
  c_tmty         TYPE char4      VALUE 'TMTY',
  c_opt_list     TYPE rsrest_opl VALUE 'OPT_LIST',
  c_s            TYPE rsscr_kind VALUE 'S',
  c_matnr        TYPE blockname  VALUE 'S_MATNR',
  c_inc          TYPE c          VALUE 'I'.
