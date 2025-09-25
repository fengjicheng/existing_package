*&---------------------------------------------------------------------*
*&  Include           ZQTCN_VALUE_HELP_LAYOUT_VA05
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_VALUE_HELP_LAYOUT(Include)
* PROGRAM DESCRIPTION:Include for F4 Help on ZQTC_VA05 selection screen
* DEVELOPER: NPOLINA
* CREATION DATE:   2019-08-13
* OBJECT ID: DM7836
* TRANSPORT NUMBER(S) ED2K915777
*-------------------------------------------------------------------*

DATA : lst_variant     TYPE disvariant,
       lst_variant_imp TYPE disvariant,
       lv_exit         TYPE c,
       lv_save         TYPE c VALUE 'A'.
*--*Get F4 Help to listout available layouts
lst_variant-report = sy-repid.
CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
  EXPORTING
    is_variant    = lst_variant
    i_save        = lv_save
  IMPORTING
    e_exit        = lv_exit
    es_variant    = lst_variant_imp
  EXCEPTIONS
    not_found     = 1
    program_error = 2
    OTHERS        = 3.
IF sy-subrc <> 0.
  MESSAGE 'No values found' TYPE 'I'.
ELSE.
*--*Populate selected Layout
  IF lv_exit IS INITIAL.
    p_layout = lst_variant_imp-variant.
  ENDIF.
ENDIF.
