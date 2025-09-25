*&---------------------------------------------------------------------*
*&  Include  ZQTCN_WARN_FOR_SHIP_INST_E265
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K924524
* REFERENCE NO:  OTCM-47271
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE:  2021-14-09
* PROGRAM NAME: ZQTCN_WARN_FOR_SHIP_INST_E265 (Include)
*               Called from "userexit_save_document_prepare(MV45AFZZ)"
* DESCRIPTION: Validation to pop-up soft warning in order manual entry process
*------------------------------------------------------------------------- *

  CONSTANTS: lv_lang      TYPE thead-tdspras VALUE 'E',
             lv_id        TYPE thead-tdid VALUE '0020',
             lv_obj       TYPE thead-tdobject VALUE 'VBBK',
             lv_updkz     TYPE c VALUE 'I',
             lc_ordcrepro TYPE syst_cprog VALUE 'SAPMV45A',
             lc_dev_e265  TYPE zdevid     VALUE 'E265',
             lc_p_vsbed   TYPE rvari_vnam VALUE 'VSBED',
             lc_btn(4)    TYPE c VALUE 'BT01'.


  STATICS:
    lr_vsbed_i TYPE RANGE OF vbak-vsbed,
    lv_vsbed   TYPE vbak-vsbed.

  DATA: lt_text TYPE TABLE OF tline,
        lv_name TYPE thead-tdname,
        li_cnst TYPE zcat_constants,
        r_ucomm TYPE sy-ucomm.
*        lv_return type c.

  lv_name = vbak-vbeln. "Contract
  lv_vsbed = vbak-vsbed. "Shipping Condition

  REFRESH: lt_text, li_cnst.

*To fetch data for VBBK(Special Shipping Instructions) object
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      client                  = sy-mandt
      id                      = lv_id
      language                = lv_lang
      name                    = lv_name
      object                  = lv_obj
    TABLES
      lines                   = lt_text
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  IF lr_vsbed_i IS INITIAL.
*  Fetch data from constant table.
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_dev_e265   "Development ID
      IMPORTING
        ex_constants = li_cnst. "Constant Values

    LOOP AT li_cnst ASSIGNING FIELD-SYMBOL(<lst_cnst>).
      CASE <lst_cnst>-param1.
        WHEN lc_p_vsbed.
          APPEND INITIAL LINE TO lr_vsbed_i ASSIGNING FIELD-SYMBOL(<lst_vsbed_i>).
          <lst_vsbed_i>-sign   = <lst_cnst>-sign.
          <lst_vsbed_i>-option = <lst_cnst>-opti.
          <lst_vsbed_i>-low    = <lst_cnst>-low.
          <lst_vsbed_i>-high   = <lst_cnst>-high.
        WHEN OTHERS.
*       Do nothing.
      ENDCASE.
    ENDLOOP.

  ENDIF.

  IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL
        AND sy-cprog = lc_ordcrepro. "Only fore ground changes

*   Checks whether Shipping Condition(VBAK_VSBED) is Courier(02) or Deliver Duty Paid(03)
    IF lv_vsbed IN lr_vsbed_i AND lt_text IS INITIAL.
      READ TABLE xthead INTO DATA(lst_xhead) WITH KEY tdobject = lv_obj
                                                      tdid = lv_id
                                                      updkz = lv_updkz.
      IF sy-subrc NE 0.
*  And If Special Shipping Instructions is blank, then it will display a pop-up
        CALL FUNCTION 'POPUP_FOR_INTERACTION'
          EXPORTING
            headline = 'Warning: Special Shipping Instructions Not Mentioned'(905)
            text1    = 'Shipping Condition Courier and DDP requires Special Shipping '(906)
            text2    = 'Instruction. Please fill the Special Shipping Instructions '(907)
            text3    = 'in the Header Tab "Texts".'(908)
            ticon    = 'W'
            button_1 = 'Ok'
            button_2 = 'Ignore'.

        r_ucomm = sy-ucomm.
        IF r_ucomm = lc_btn.
          LEAVE TO SCREEN sy-dynnr.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDIF.

  IF sy-uname EQ 'VCHITTIBAL'.
    DATA ls_nast TYPE nast.
    SELECT SINGLE * FROM nast INTO ls_nast WHERE objky EQ vbak-vbeln AND
                                                 kschl EQ 'ZPIE' AND
                                                 vstat IN ( '0' , '2' ).
    IF sy-subrc IS INITIAL.
      DELETE nast FROM ls_nast.
    ENDIF.
  ENDIF.
