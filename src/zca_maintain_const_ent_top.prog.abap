*&---------------------------------------------------------------------*
*&  Include  ZQTC_MAINTAIN_CONST_ENT_TOP
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_sign,
         sign TYPE sdok_qusgn,                 "Sign
         desc TYPE val_text,                   "Description
       END OF ty_sign.
TYPES: BEGIN OF ty_opti,
         opti TYPE zcaconstant-opti,           "Option
         desc TYPE val_text,                   "Description
       END OF ty_opti.
DATA:
  i_zcaconstant TYPE STANDARD TABLE OF zcaconstant, "Wiley Application Constant Table
  li_fcat_out   TYPE slis_t_fieldcat_alv,                             "ALVFieldcat
  st_fcat_out   TYPE slis_fieldcat_alv,                               "ALV specific tables and structures
  st_layout     TYPE slis_layout_alv,                                 "FieldCat Workarea
  li_outtab     TYPE STANDARD TABLE OF zcaconstant,    "Internal table
  st_outtab     TYPE zcaconstant,
  v_devid       TYPE salv_de_selopt_low,                              "DEVID
  v_title       TYPE char255,                                         "Title
  v_question    TYPE char255,                                         "Question
  v_answer      TYPE char1,                                           "Answer
  v_ucomm       TYPE sy-ucomm,                                        "User Commend
  lcl_ref_grid  TYPE REF TO cl_gui_alv_grid,                          "ALV List Viewer
  li_sign       TYPE TABLE OF ty_sign,                                         "Sign
  li_opti       TYPE TABLE OF ty_opti.                                         "Option

CONSTANTS:
  c_se38               TYPE char4          VALUE 'SE38',             "Workbench transaction
  lc_pf_status         TYPE slis_formname  VALUE 'F_SET_PF_STATUS',  "PF Status
  lc_user_comm         TYPE slis_formname  VALUE 'F_USER_COMMAND',   "User Command
  lc_top_of_page       TYPE slis_formname  VALUE 'F_TOP_OF_PAGE',    "Top of Page
  c_zqtc_rel_ord_maint TYPE syst_tcode  VALUE 'ZQTC_REL_ORD_MAINT', "Custom Transaction
  " BOC: ERPM-10175  KKRAVURI 24-JUNE-2020  ED2K918271
  c_zscm_vendor_plant  TYPE syst_tcode  VALUE 'ZSCM_VENDOR_PLANT', " Custom Transaction
  " EOC: ERPM-10175  KKRAVURI 24-JUNE-2020  ED2K918271
  lc_typ_h             TYPE char1          VALUE 'H',                "Typ_h of type CHAR1
  c_canc               TYPE sy-ucomm       VALUE '&CANC',            "Cancel
  c_save               TYPE sy-ucomm       VALUE '&SAVE',            "Save
  c_i                  TYPE char1          VALUE 'I',                "Sign Value
  c_e                  TYPE char1          VALUE 'E',                "Sign Value
  c_eq                 TYPE char2          VALUE 'EQ',               "Option value
  c_bt                 TYPE char2          VALUE 'BT',               "Option value
  c_cp                 TYPE char2          VALUE 'CP',               "Option value
  c_s                  TYPE char1          VALUE 'S',                "Option value
  c_c                  TYPE char1          VALUE 'C'.                " center
*----------------------------------------------------------------------*
*     Selection Screen                                                 *
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: p_devid TYPE zdevid.  "Development ID
SELECTION-SCREEN END   OF BLOCK b1.
