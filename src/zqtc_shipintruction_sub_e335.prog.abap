*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_SHIPINTRUCTION_SUB_E335 (Display Shipping instruction
*                           detail)
* REVISION NO: ED2K919561                                              *
* REFERENCE NO: OTCM-10487                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  09/28/2020                                                    *
* DESCRIPTION: Add new fields to V_RA report
*----------------------------------------------------------------------*

DATA : li_lines      TYPE STANDARD TABLE OF tline,     "Lines of text read
       li_ship_intro TYPE TABLE OF txw_note,
       lv_name       TYPE thead-tdname.

CONSTANTS : lc_id     TYPE thead-tdid VALUE '0020',
            lc_object TYPE thead-tdobject VALUE 'VBBK'.

REFRESH : li_lines[] , li_ship_intro[].

CLEAR lv_name.
lv_name = postab-vbeln.

CALL FUNCTION 'READ_TEXT'
  EXPORTING
    id                      = lc_id
    language                = sy-langu
    name                    = lv_name
    object                  = lc_object
  TABLES
    lines                   = li_lines
  EXCEPTIONS
    id                      = 1
    language                = 2
    name                    = 3
    not_found               = 4
    object                  = 5
    reference_check         = 6
    wrong_access_to_archive = 7
    OTHERS                  = 8.
IF sy-subrc EQ 0.
  LOOP AT li_lines INTO DATA(lst_lines).
    APPEND INITIAL LINE TO li_ship_intro ASSIGNING FIELD-SYMBOL(<lfs_ship_intro>).
    <lfs_ship_intro>-line = lst_lines-tdline.
  ENDLOOP.
ENDIF.

" Order history breakdown display with popup
CALL FUNCTION 'TXW_TEXTNOTE_EDIT'
  EXPORTING
    edit_mode = space         " disable the editable mode
  TABLES
    t_txwnote = li_ship_intro.
