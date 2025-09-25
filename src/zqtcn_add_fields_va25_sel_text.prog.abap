*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ADD_FIELDS_VA25_SEL_TEXT
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ADD_FIELDS_VA25_SEL_TEXT (Include Program)
* PROGRAM DESCRIPTION: Add new fields in VA25
* DEVELOPER: Pavan Bandlapalli (PBANDLAPAL) / Mounika Nallapaneni(NMOUNIKA)
* CREATION DATE:   06/28/2017
* OBJECT ID: R054
* TRANSPORT NUMBER(S): ED2K906855
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------
* PROGRAM NAME: ZZQTCN_ADD_FIELDS_VA25_SEL_TEXT
* PROGRAM DESCRIPTION: Selection Screen Validation
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   06/08/2020
* WRICEF ID: R054
* TRANSPORT NUMBER(S):  ED2K918395
* REFERENCE NO: ERPM-14773 SAUDAT-LOW
*----------------------------------------------------------------------*
*----------------------------------------------------------------------
* PROGRAM NAME: ZZQTCN_ADD_FIELDS_VA25_SEL_TEXT
* PROGRAM DESCRIPTION: Selection Screen Validation
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   06/11/2020
* WRICEF ID: R054
* TRANSPORT NUMBER(S):  ED2K918457
* REFERENCE NO: ERPM-14773
* Change : Revert all the changes done with ED2K918395
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ADD_FIELDS_VA25_SEL_TEXT
* PROGRAM DESCRIPTION: Selection Screen Validation
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   07/09/2020
* WRICEF ID: R054
* TRANSPORT NUMBER(S):  ED2K918842
* REFERENCE NO: ERPM-21199
* Change : Document date mandatory removing and validity period make a mandatory
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO : ED2K924869
* REFERENCE NO: OTCM-54011
* WRICEF ID   : R054
* DEVELOPER   : VDPATABALL
* DATE        : 10/29/2021
* DESCRIPTION : Indian Agent Changes for Unrenewed Quotation list
*---------------------------------------------------------------------*
DATA:
  lv_field_txt TYPE scrfstxg.                                   "Text of a screen element

FIELD-SYMBOLS:
  <lv_fld_val> TYPE any.                                        "Field Value

* To change the selection screen fields to populate the texts.
LOOP AT SCREEN.
  IF sy-tcode EQ zclqtc_badi_sdoc_wrapper_mass=>c_tran_codes-tcode_va25.
*   Make Selection Screen Fields as Mandatory
    IF screen-name EQ zclqtc_badi_sdoc_wrapper_mass=>c_mandatory_field-sel_scrn_fld_auart OR "Contract Type
       screen-name EQ zclqtc_badi_sdoc_wrapper_mass=>c_mandatory_field-sel_scrn_fld_vkorg OR "Sales organization
**** Begin of Change by Lahiru on 07/09/2020 for ERPM-21199 with ED2K918842 ****
       "screen-name EQ zclqtc_badi_sdoc_wrapper_mass=>c_mandatory_field-sel_scrn_fld_audat.   "Document Date
      screen-name EQ zclqtc_badi_sdoc_wrapper_mass=>c_mandatory_field-sel_scrn_fld_itmvalid.  " Item Validity period
**** End of Change by Lahiru on 07/09/2020 for ERPM-21199 with ED2K918842 ****
      screen-required = zclqtc_badi_sdoc_wrapper_mass=>c_sel_scrn_property-active.
      MODIFY SCREEN.
    ENDIF.
*----BOC VDPATABALL 10/29/2021 ED2K924869 OTC-49605
*---If UnRenewed check box is true then we are hide the two radio buttons(Open Quotation and All Quotations)

    IF ch_unren = abap_true.
      pvball = abap_false.
      pvboff = abap_true.
      MODIFY SCREEN.
      IF screen-name CS 'BS02037_BLOCK_1000' OR screen-name CS 'PVBOFF' OR screen-name CS 'PVBALL'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
*----EOC VDPATABALL 10/29/2021 ED2K924869 OTC-49605
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
      IF sy-subrc EQ 0.
*       Maintain Text of screen element
        <lv_fld_val> = lv_field_txt.
        UNASSIGN: <lv_fld_val>.
      ENDIF.
    ENDIF.
  ENDIF.
ENDLOOP.
