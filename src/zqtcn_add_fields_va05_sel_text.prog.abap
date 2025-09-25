*&------------------------------------------  ---------------------------*
*&  Include           ZQTCN_ADD_FIELDS_VA05_SEL_TEXT
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ADD_FIELDS_VA05_SEL_TEXT (Include Program)
* PROGRAM DESCRIPTION: Add new fields in VA05
* DEVELOPER: Pavan Bandlapalli (PBANDLAPAL) / Sayantan Das (SAYANDAS)
* CREATION DATE:   06/28/2017
* OBJECT ID: R052
* TRANSPORT NUMBER(S): ED2K906705
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:
  lv_field_txt TYPE scrfstxg.                                   "Text of a screen element

FIELD-SYMBOLS:
  <lv_fld_val> TYPE any.                                        "Field Value

LOOP AT SCREEN.
    IF sy-tcode EQ zclqtc_badi_sdoc_wrapper_mass=>c_tran_codes-tcode_va05.
*   Make Selection Screen Fields as Mandatory
    IF screen-name EQ zclqtc_badi_sdoc_wrapper_mass=>c_mandatory_field-sel_scrn_fld_auart OR "Contract Type
       screen-name EQ zclqtc_badi_sdoc_wrapper_mass=>c_mandatory_field-sel_scrn_fld_vkorg OR "Sales organization
       screen-name EQ zclqtc_badi_sdoc_wrapper_mass=>c_mandatory_field-sel_scrn_fld_audat.   "Document Date
      screen-required = zclqtc_badi_sdoc_wrapper_mass=>c_sel_scrn_property-active.
      MODIFY SCREEN.
    ENDIF.
  ENDIF.

  IF screen-name CS zclqtc_badi_sdoc_wrapper_mass=>c_sel_scrn_field-sel_scrn_text OR
     screen-name CS zclqtc_badi_sdoc_wrapper_mass=>c_sel_scrn_field-sel_scrn_block.
    CLEAR: lv_field_txt.
*   Get Selection Screen Texts
    CALL METHOD zclqtc_badi_sdoc_wrapper_mass=>meth_get_sel_screen_text
      EXPORTING
        im_application_id = gv_application_id                   "Application ID
        im_fld_name       = screen-name                         "Selection Screen field
      IMPORTING
        ex_fld_text       = lv_field_txt.                       "Text of a screen element
    IF lv_field_txt IS NOT INITIAL.
      ASSIGN (screen-name) TO <lv_fld_val>.
      IF Sy-subrc EQ 0.
*       Maintain Text of screen element
        <lv_fld_val> = lv_field_txt.
        UNASSIGN: <lv_fld_val>.
      ENDIF.
    ENDIF.
  ENDIF.
ENDLOOP.
