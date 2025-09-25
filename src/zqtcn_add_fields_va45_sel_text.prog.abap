*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ADD_FIELDS_VA45_SEL_TEXT (Include Program)
* PROGRAM DESCRIPTION: Add new fields in VA45
* DEVELOPER: Writtick Roy (WROY) / Sayantan Das (SAYANDAS)
* CREATION DATE:   05/30/2017
* OBJECT ID: R050
* TRANSPORT NUMBER(S): ED2K906227
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910841 / ED2K916019
* REFERENCE NO: INC0248483
* DEVELOPER: Bharani
* DATE:  7/19/2019
* DESCRIPTION:  Report does not show all billing docs
*               As per the FS, report has to show all the records
*               for M, O, P Document category of subsequent docs   ED2K918455
*               As the Preceding Document catetory has been added in
*               the selection screen, we are populating the values,
*               M, O, P as default values.
*----------------------------------------------------------------------
* PROGRAM NAME: ZZQTCN_ADD_FIELDS_VA45_SEL_TEXT
* PROGRAM DESCRIPTION: Selection Screen Validation
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   05/19/2020
* WRICEF ID: R050
* TRANSPORT NUMBER(S):  ED2K918229
* REFERENCE NO: ERPM-14773SAUDAT-LOW
*----------------------------------------------------------------------*
*----------------------------------------------------------------------
* PROGRAM NAME: ZZQTCN_ADD_FIELDS_VA45_SEL_TEXT
* PROGRAM DESCRIPTION: Selection Screen Validation
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   05/19/2020
* WRICEF ID: R050
* TRANSPORT NUMBER(S):  ED2K918455
* REFERENCE NO: ERPM-14773
* Change : Revert all the changes done with ED2K918229
*----------------------------------------------------------------------*
* PROGRAM NAME: ZZQTCN_ADD_FIELDS_VA45_SEL_TEXT
* PROGRAM DESCRIPTION: Selection Screen Validation
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   07/09/2020
* WRICEF ID: R050
* TRANSPORT NUMBER(S):  ED2K918827
* REFERENCE NO: ERPM-21199
* Change : Document date mandatory removing and validity period make a mandatory
*----------------------------------------------------------------------*
DATA:
  lv_field_txt TYPE scrfstxg. "Text of a screen element

FIELD-SYMBOLS:
  <lv_fld_val> TYPE any. "Field Value

CONSTANTS:
  lc_modif_md1 TYPE char3 VALUE 'MD1',
* BOC BY SAYANDAS on 02-JAN-2018 for ERP-5688
  lc_modif_md2 TYPE char3 VALUE 'MD2'.
* EOC BY SAYANDAS on 02-JAN-2018 for ERP-5688

LOOP AT SCREEN.
  IF sy-tcode EQ zclqtc_badi_sdoc_wrapper_mass=>c_tran_codes-tcode_va45.
*   Make Selection Screen Fields as Mandatory
    IF screen-name EQ zclqtc_badi_sdoc_wrapper_mass=>c_mandatory_field-sel_scrn_fld_auart OR "Contract Type
       screen-name EQ zclqtc_badi_sdoc_wrapper_mass=>c_mandatory_field-sel_scrn_fld_vkorg OR "Sales organization
**** Begin of Change by Lahiru on 07/09/2020 for ERPM-21199 with ED2K918827 ****
       "screen-name EQ zclqtc_badi_sdoc_wrapper_mass=>c_mandatory_field-sel_scrn_fld_audat.   "Document Date
      screen-name EQ zclqtc_badi_sdoc_wrapper_mass=>c_mandatory_field-sel_scrn_fld_itmvalid.     " Item Validity period
**** End of Change by Lahiru on 07/09/2020 for ERPM-21199 with ED2K918827 ****
      screen-required = zclqtc_badi_sdoc_wrapper_mass=>c_sel_scrn_property-active.
      MODIFY SCREEN.
    ENDIF. " IF screen-name EQ zclqtc_badi_sdoc_wrapper_mass=>c_mandatory_field-sel_scrn_fld_auart OR

*   Make Selection Screen Fields invisible for Report transaction
    IF screen-group1 EQ lc_modif_md1.
      screen-active = zclqtc_badi_sdoc_wrapper_mass=>c_sel_scrn_property-inactive.
      MODIFY SCREEN.
    ENDIF.
* BOC BY SAYANDAS on 02-JAN-2018 for ERP-5688
  ELSE.
*   Make Billing related Selection Screen Fields invisible for Standard transaction
    IF screen-group1 EQ lc_modif_md2.
      screen-active = zclqtc_badi_sdoc_wrapper_mass=>c_sel_scrn_property-inactive.
      MODIFY SCREEN.
    ENDIF.
* EOC BY SAYANDAS on 02-JAN-2018 for ERP-5688
  ENDIF. " IF sy-tcode EQ zclqtc_badi_sdoc_wrapper_mass=>c_tran_codes-tcode_va45

* Maintain Selection Screen Texts
  IF screen-name CS zclqtc_badi_sdoc_wrapper_mass=>c_sel_scrn_field-sel_scrn_text OR
     screen-name CS zclqtc_badi_sdoc_wrapper_mass=>c_sel_scrn_field-sel_scrn_block.
    CLEAR: lv_field_txt.
*   Get Selection Screen Texts
    CALL METHOD zclqtc_badi_sdoc_wrapper_mass=>meth_get_sel_screen_text
      EXPORTING
        im_application_id = gv_application_id "Application ID
        im_fld_name       = screen-name       "Selection Screen field
      IMPORTING
        ex_fld_text       = lv_field_txt.     "Text of a screen element
    IF lv_field_txt IS NOT INITIAL.
      ASSIGN (screen-name) TO <lv_fld_val>.
      IF sy-subrc EQ 0.
*       Maintain Text of screen element
        <lv_fld_val> = lv_field_txt.
        UNASSIGN: <lv_fld_val>.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF lv_field_txt IS NOT INITIAL
  ENDIF. " IF screen-name CS zclqtc_badi_sdoc_wrapper_mass=>c_sel_scrn_field-sel_scrn_text OR
ENDLOOP. " LOOP AT SCREEN
IF sy-tcode EQ zclqtc_badi_sdoc_wrapper_mass=>c_tran_codes-tcode_va45.
* Upload values of Document category of subsequent document as default
  IF s_vbty_n[] IS INITIAL.
* For Invoice (M)
    s_vbty_n-low = 'M'.
    s_vbty_n-option = 'EQ'.
    s_vbty_n-sign = 'I'.
    APPEND s_vbty_n.

* For Credit memo (O)
    s_vbty_n-low = 'O'.
    s_vbty_n-option = 'EQ'.
    s_vbty_n-sign = 'I'.
    APPEND s_vbty_n.

* For Debit Memo (P)
    s_vbty_n-low = 'P'.
    s_vbty_n-option = 'EQ'.
    s_vbty_n-sign = 'I'.
    APPEND s_vbty_n.
  ENDIF.
ENDIF.
