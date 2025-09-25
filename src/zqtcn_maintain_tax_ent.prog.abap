*&---------------------------------------------------------------------*
*&  Include  ZQTC_MAINTAIN_TAX_TOP
*&---------------------------------------------------------------------*
DATA:i_taxcal      TYPE STANDARD TABLE OF zqtc_taxcal,
     i_outtab      TYPE STANDARD TABLE OF zqtc_taxcal,
     st_outtab     TYPE zqtc_taxcal,
     v_vkorg       TYPE vkorg,
     li_fcat_out   TYPE slis_t_fieldcat_alv,                             "ALVFieldcat
     st_fcat_out   TYPE slis_fieldcat_alv,                               "ALV specific tables and structures
     st_layout     TYPE slis_layout_alv,                                 "FieldCat Workarea
     v_title       TYPE char255,                                         "Title
     v_question    TYPE char255,                                         "Question
     v_answer      TYPE char1,                                           "Answer
     v_ucomm       TYPE sy-ucomm,                                        "User Commend
     lcl_ref_grid  TYPE REF TO cl_gui_alv_grid.                 "ALV List Viewer ##NEEDED.

CONSTANTS:
  lc_pf_status         TYPE slis_formname  VALUE 'F_SET_PF_STATUS',  "PF Status
  lc_user_comm         TYPE slis_formname  VALUE 'F_USER_COMMAND',   "User Command
  lc_top_of_page       TYPE slis_formname  VALUE 'F_TOP_OF_PAGE',    "Top of Page
  lc_typ_h             TYPE char1          VALUE 'H',                "Typ_h of type CHAR1
  c_canc               TYPE sy-ucomm       VALUE '&CANC',            "Cancel
  c_save1              TYPE sy-ucomm       VALUE '&DATA_SAVE'.       "Save
*----------------------------------------------------------------------*
*     Selection Screen                                                 *
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: p_vkorg TYPE vkorg OBLIGATORY.  "Development ID
SELECTION-SCREEN END   OF BLOCK b1.
