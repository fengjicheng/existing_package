*-------------------------------------------------------------------
***INCLUDE LCTALF10 .
*-------------------------------------------------------------------

*eject
*---------------------------------------------------------------------*
*       FORM CHK_DECIMALPOINT                                         *
*---------------------------------------------------------------------*
*                                                                     *
*       get representation of decimalpoint                            *
*                                                                     *
*---------------------------------------------------------------------*
*  <--  DECIMALPOINT                   representation of decimalpoint *
*  <--  DATEFORMAT                     format for date                *
*---------------------------------------------------------------------*
FORM chk_decimalpoint USING decimalpoint LIKE sy-batch
                            dateformat   LIKE cabn-atsch.

*....... check if read is necessary ...................................*

  CHECK decimalpoint IS INITIAL.

*....... read user account ............................................*

  CALL FUNCTION 'CLSE_SELECT_USR01'
    EXPORTING
      username     = sy-uname
    IMPORTING
      date_format  = dateformat
      decimal_sign = decimalpoint.

ENDFORM.                    "CHK_DECIMALPOINT

*eject
*&---------------------------------------------------------------------*
*&      Form  FILL_TABLES
*&---------------------------------------------------------------------*
*                                                                      *
*       fill internal tables with data distributed via ALE             *
*                                                                      *
*----------------------------------------------------------------------*
*  -->  IDOC_DATA                       distributed data for charact.
*  <--  F_ERROR                         error flag
*----------------------------------------------------------------------*
FORM fill_tables USING VALUE(idoc_data) STRUCTURE edidd
                       f_error          LIKE rctmv-mark.

  DATA:
    output_text(80)       TYPE c.           "text for progress indicator

  DATA: lv_iso_org            LIKE cabn-msehi,              "1145836
        lv_iso_new            LIKE cabn-msehi,
        lv_unit_sap           LIKE cabn-msehi,
        lv_atfor              LIKE cabn-atfor,
        ls_all_attributes     LIKE chardata,
        lt_descriptions       LIKE cha_descr  OCCURS 0,
        lt_allowed_values     LIKE chvals     OCCURS 0,
        lt_value_descriptions LIKE cha_vdescr OCCURS 0,
        lt_restrict_usage     LIKE cha_cl_typ OCCURS 0,
        lt_reference_to_table LIKE cha_reftab OCCURS 0.     "1145836

  DATA:  lv_key_date           LIKE aenr-datuv.             "1268222

*........ init ........................................................*

  CLEAR: f_error.

*........ fill tables depending on segment name (SEGNUM) ..............*

  CASE idoc_data-segnam.
*----------------------------------------------------------------------*
    WHEN c_segnam_cabn.           "characteristic master data

*........ move condensed data to structure ............................*

      e1cabnm = idoc_data-sdata.

*........ copy data to api-structure ..................................*

      charact_data-charact        = e1cabnm-atnam.
      charact_data-datatype       = e1cabnm-atfor.
      charact_data-udef_class     = e1cabnm-class.
      charact_data-charnumber     = e1cabnm-anzst.
      charact_data-decplaces      = e1cabnm-anzdz.
      charact_data-casesens       = e1cabnm-atkle.
      charact_data-displ_exp      = e1cabnm-atdex.
      charact_data-exponent       = e1cabnm-atdim.
      charact_data-template       = e1cabnm-atsch.
      charact_data-neg_vals       = e1cabnm-atvor.
      charact_data-status         = e1cabnm-atmst.
      charact_data-group          = e1cabnm-atkla.
      charact_data-no_display     = e1cabnm-atvie.
      charact_data-entry_req      = e1cabnm-aterf.
      charact_data-interv         = e1cabnm-atint.
      charact_data-unformated     = e1cabnm-atfod.
      charact_data-prop_templ     = e1cabnm-atvsc.
      charact_data-displ_vals     = e1cabnm-atwrd.
      charact_data-addit_vals     = e1cabnm-atson.
      charact_data-check_table    = e1cabnm-check_table.
      charact_data-function       = e1cabnm-function.
      charact_data-plant          = e1cabnm-plant.
      charact_data-selection_set  = e1cabnm-selection_set.
      charact_data-adt_class      = e1cabnm-adt_class.
      charact_data-adt_class_type = e1cabnm-adt_klart.
      charact_data-aggregating    = e1cabnm-aggregating.
      charact_data-balancing      = e1cabnm-balancing.
      charact_data-input_req_conf = e1cabnm-input_req_conf.

*........ flag 'value assignment' .....................................*

      IF e1cabnm-atein EQ c_mark.
        IF e1cabnm-atgla EQ c_mark.
          charact_data-valassignm = 'R'.        "restrictable
        ELSE.
          charact_data-valassignm = 'S'.        "single value
        ENDIF.
      ELSE.
        IF e1cabnm-atgla EQ c_mark.
          charact_data-valassignm = 'N'.        "multiple value restr.
        ELSE.
          charact_data-valassignm = 'M'.        "multiple value
        ENDIF.
      ENDIF.

*....... input allowed ................................................*

      IF e1cabnm-attab     IS INITIAL AND
         e1cabnm-ref_table IS INITIAL.
        charact_data-no_entry = e1cabnm-atinp.
      ELSEIF e1cabnm-atglo IS INITIAL.
        charact_data-no_entry = c_mark.
      ELSE.
        CLEAR: charact_data-no_entry.
      ENDIF.

*........ authority group .............................................*
      charact_data-authority_group = e1cabnm-authority_group.

*........ check if characteristic is to be deleted ....................*

      IF e1cabnm-msgfn = c_delete.
        charact_data-fldelete = c_mark.
      ELSE.
        CLEAR: charact_data-fldelete.
      ENDIF.

*........ copy IDoc data to structure CABN ............................*

      MOVE-CORRESPONDING e1cabnm TO cabn.

*........ set mask for DATE and TIME ...................................

      IF cabn-atfor EQ 'DATE'.
        cabn-atsch = dateformat.
      ELSEIF cabn-atfor EQ 'TIME'.
        cabn-atsch = 'HH:MM:SS'.
      ENDIF.

*........ get external unit ...........................................*

* Begin of 1145836

*     If ISOCODE is defined in source system, ISOCODE is sent by IDOC.
*     We need to check whether char already exists in target system.
*     If so, we do not want to change unit, unless ISOCODE is different
*     in source and target.
*     If unit should be changed, CAMA_CHARACT_MAINTAIN will decide,
*     whether this change is possible or not...

      IF NOT e1cabnm-msehi IS INITIAL.

        CALL FUNCTION 'CARD_CHARACTERISTIC_READ'
          EXPORTING
            characteristic               = e1cabnm-atnam
            with_values                  = ' '
            with_value_descriptions      = ' '
          IMPORTING
            all_attributes               = ls_all_attributes
          TABLES
            descriptions                 = lt_descriptions
            allowed_values               = lt_allowed_values
            value_descriptions           = lt_value_descriptions
            restrict_usage_in_class_type = lt_restrict_usage
            reference_to_table           = lt_reference_to_table
          EXCEPTIONS
            error                        = 1
            OTHERS                       = 2.
        IF sy-subrc = 0 AND
           NOT ls_all_attributes-unit IS INITIAL.

          CALL FUNCTION 'CONVERSION_EXIT_LUNIT_INPUT'
            EXPORTING
              input          = ls_all_attributes-unit
            IMPORTING
              output         = lv_unit_sap
            EXCEPTIONS
              unit_not_found = 1
              OTHERS         = 2.
          IF NOT sy-subrc IS INITIAL.
            lv_unit_sap = ls_all_attributes-unit.
          ENDIF.
          lv_atfor    = ls_all_attributes-datatype.

          PERFORM unit_of_measure_sap_to_iso USING    lv_unit_sap
                                                      lv_atfor
                                             CHANGING lv_iso_org.

          PERFORM unit_of_measure_sap_to_iso USING    e1cabnm-msehi
                                                      e1cabnm-atfor
                                             CHANGING lv_iso_new.

        ELSE.                      "Char doesn't exist or no unit...
          lv_iso_org = 'none'.     "We don't want the next IF to
          lv_iso_new = '????'.     "be fulfilled...
        ENDIF.

        IF lv_iso_org = lv_iso_new.

          charact_data-unit = ls_all_attributes-unit.

          cabn-msehi = lv_unit_sap.                         "1243946

        ELSE.
          IF e1cabnm-atfor NE 'CURR'.
            PERFORM unit_of_measure_iso_to_sap USING    e1cabnm-msehi
                                                        e1cabnm-atfor
                                               CHANGING cabn-msehi.

            CALL FUNCTION 'CONVERSION_EXIT_LUNIT_OUTPUT'
              EXPORTING
                input          = cabn-msehi
              IMPORTING
                output         = charact_data-unit
              EXCEPTIONS
                unit_not_found = 1
                OTHERS         = 2.
            IF NOT sy-subrc IS INITIAL.
              charact_data-unit = cabn-msehi.
            ENDIF.
          ELSE.
            PERFORM unit_of_measure_iso_to_sap USING    e1cabnm-msehi
                                                        e1cabnm-atfor
                                               CHANGING cabn-msehi.
            charact_data-unit = cabn-msehi.
          ENDIF.
        ENDIF.
      ENDIF.
* End of 1145836

*........ insert into table ...........................................*

      APPEND charact_data.

*........ display object in progress indicator ........................*

      IF sy-batch NE c_mark.
        CLEAR output_text.
        output_text = 'Verarbeitung Merkmal'(001).
        CONCATENATE output_text charact_data-charact
                    INTO output_text SEPARATED BY space.
        CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
          EXPORTING
            text = output_text.
      ENDIF.
*----------------------------------------------------------------------*
    WHEN c_segnam_cabnt.          "characteristic texts

*........ move condensed data to structure ............................*

      e1cabtm = idoc_data-sdata.

*........ copy data to api-structure ..................................*

      charact_description-charact      = e1cabnm-atnam.
      charact_description-chdescr      = e1cabtm-atbez.
      charact_description-heading1     = e1cabtm-atue1.
      charact_description-heading2     = e1cabtm-atue2.
      charact_description-language     = e1cabtm-spras.
      charact_description-language_iso = e1cabtm-spras_iso.
      CLEAR charact_description-fldelete.

*........ insert into table ...........................................*

      APPEND charact_description.
*----------------------------------------------------------------------*
    WHEN c_segnam_cabnz.          "ref. tables

*........ move condensed data to structure ............................*

      e1cabzm = idoc_data-sdata.

*........ copy data to api-structure ..................................*

      charact_object-charact   = e1cabnm-atnam.
      IF e1cabzm-ref_table IS INITIAL.
        charact_object-ref_table = e1cabzm-attab.
        charact_object-ref_field = e1cabzm-atfel.
      ELSE.
        charact_object-ref_table = e1cabzm-ref_table.
        charact_object-ref_field = e1cabzm-ref_field.
      ENDIF.

      CLEAR charact_object-fldelete.

*........ insert into table ...........................................*

      APPEND charact_object.
*----------------------------------------------------------------------*
    WHEN c_segnam_cawn.           "characteristic values

*........ move condensed data to structure ............................*

      e1cawnm = idoc_data-sdata.

*........ copy IDoc data to structure CAWN ............................*

      MOVE-CORRESPONDING e1cawnm TO cawn.

*........ copy data to api-structure ..................................*

      charact_value-charact    = e1cabnm-atnam.
      charact_value-value      = e1cawnm-atwrt.
      charact_value-default    = e1cawnm-atstd.
      charact_value-document   = e1cawnm-doknr.
      charact_value-doc_type   = e1cawnm-dokar.
      charact_value-doc_part   = e1cawnm-doktl.
      charact_value-doc_vers   = e1cawnm-dokvr.
      charact_value-value_high = e1cawnm-value_high.
      CLEAR:
        charact_value-value_bef,
        charact_value-fldelete.

*........ get external view for datatype ne 'CHAR' ....................*
      cabn-atfor = 'CHAR'. "SGUDA
      IF cabn-atfor NE format_char.
        PERFORM unit_of_measure_iso_to_sap USING    e1cawnm-atawe
                                                    e1cabnm-atfor
                                           CHANGING cawn-atawe.
        PERFORM unit_of_measure_iso_to_sap USING    e1cawnm-ataw1
                                                    e1cabnm-atfor
                                           CHANGING cawn-ataw1.

        CALL FUNCTION 'CTCV_PREPARE_VALUES_TO_DISPLAY'
          EXPORTING
            decimalpoint         = decimalpoint
            structure_cabn       = cabn
            structure_cawn       = cawn
            string_with_baseunit = 'YES'
          IMPORTING
            string               = charact_value-value
          EXCEPTIONS
            overflow             = 1
            OTHERS               = 2.
        IF NOT sy-subrc IS INITIAL.
*         clear sy-subrc.                                      "1616485
          EXIT.                                             "1616485
        ENDIF.
      ENDIF.

*........ insert into table ...........................................*

      APPEND charact_value.
*----------------------------------------------------------------------*
    WHEN c_segnam_cawnt.          "characteristic values texts

*........ move condensed data to structure ............................*

      e1cawtm = idoc_data-sdata.

*........ copy data to api-structure ..................................*

      charact_value_description-charact      = e1cabnm-atnam.
      charact_value_description-value        = e1cawnm-atwrt.
      charact_value_description-valdescr     = e1cawtm-atwtb.
      charact_value_description-language     = e1cawtm-spras.
      charact_value_description-language_iso = e1cawtm-spras_iso.
      CLEAR: charact_value_description-fldelete.

*........ insert into table ...........................................*

      APPEND charact_value_description.
*----------------------------------------------------------------------*
    WHEN c_segnam_cukb1.         "dep basic data of value
      CLEAR t_e1cukb1.
      MOVE-CORRESPONDING charact_value TO t_e1cukb1.

*........ move condensed data to structure ............................*

      e1cukb1 = idoc_data-sdata.
      MOVE-CORRESPONDING e1cukb1 TO t_e1cukb1.

*........ insert into table ...........................................*

      APPEND t_e1cukb1.
*----------------------------------------------------------------------*
    WHEN c_segnam_cukb2.         "dep description of value
      CLEAR t_e1cukb2.
      MOVE-CORRESPONDING t_e1cukb1 TO t_e1cukb2.

*........ move condensed data to structure ............................*

      e1cukb2 = idoc_data-sdata.
      MOVE-CORRESPONDING e1cukb2 TO t_e1cukb2.

*........ insert into table ...........................................*

      APPEND t_e1cukb2.
*----------------------------------------------------------------------*
    WHEN c_segnam_cukbm.         "dep basic data of characteristic
      CLEAR t_e1cukbm.
      MOVE-CORRESPONDING charact_data TO t_e1cukbm.

*........ move condensed data to structure ............................*

      e1cukbm = idoc_data-sdata.
      MOVE-CORRESPONDING e1cukbm TO t_e1cukbm.

*........ insert into table ...........................................*

      APPEND t_e1cukbm.
*----------------------------------------------------------------------*
    WHEN c_segnam_cukbt.         "dep description of characteristic
      CLEAR t_e1cukbt.
      MOVE-CORRESPONDING t_e1cukbm TO t_e1cukbt.

*........ move condensed data to structure ............................*

      e1cukbt = idoc_data-sdata.
      MOVE-CORRESPONDING e1cukbt TO t_e1cukbt.

*........ insert into table ...........................................*

      APPEND t_e1cukbt.
*----------------------------------------------------------------------*
    WHEN c_segnam_cukn1.         "dep source of value
      CLEAR t_e1cukn1.
      MOVE-CORRESPONDING t_e1cukb1 TO t_e1cukn1.

*........ move condensed data to structure ............................*

      e1cukn1 = idoc_data-sdata.
      MOVE-CORRESPONDING e1cukn1 TO t_e1cukn1.

*........ insert into table ...........................................*

      APPEND t_e1cukn1.
*----------------------------------------------------------------------*
    WHEN c_segnam_cuknm.         "dep source of characteristic
      CLEAR t_e1cuknm.
      MOVE-CORRESPONDING t_e1cukbm TO t_e1cuknm.

*........ move condensed data to structure ............................*

      e1cuknm = idoc_data-sdata.
      MOVE-CORRESPONDING e1cuknm TO t_e1cuknm.

*........ insert into table ...........................................*

      APPEND t_e1cuknm.
*----------------------------------------------------------------------*
    WHEN c_segnam_cutx1.         "dep docu of value
      CLEAR t_e1cutx1.
      MOVE-CORRESPONDING t_e1cukb1 TO t_e1cutx1.

*........ move condensed data to structure ............................*

      e1cutx1 = idoc_data-sdata.
      MOVE-CORRESPONDING e1cutx1 TO t_e1cutx1.

*........ insert into table ...........................................*

      APPEND t_e1cutx1.
*----------------------------------------------------------------------*
    WHEN c_segnam_cutxm.         "dep docu of characteristic
      CLEAR t_e1cutxm.
      MOVE-CORRESPONDING t_e1cukbm TO t_e1cutxm.

*........ move condensed data to structure ............................*

      e1cutxm = idoc_data-sdata.
      MOVE-CORRESPONDING e1cutxm TO t_e1cutxm.

*........ insert into table ...........................................*

      APPEND t_e1cutxm.
*----------------------------------------------------------------------*
    WHEN c_segnam_date.          "changenumber and keydate

*........ move condensed data to structure ............................*

      e1datem = idoc_data-sdata.

* Begin of 1268222
      IF NOT e1datem-aennr IS INITIAL.
        CALL FUNCTION 'CC_CHANGE_NUMBER_READ'
          EXPORTING
            eaennr          = e1datem-aennr
          IMPORTING
            adatuv          = lv_key_date
          EXCEPTIONS
            no_record_found = 1
            OTHERS          = 2.
        IF sy-subrc = 0.                                    "2395833
          e1datem-key_date = lv_key_date.                   "2395833
        ENDIF.                                              "2395833
      ENDIF.
* End of 1268222

*....... check if change via ALE is allowed ............................

      PERFORM chk_change_allowed USING charact_data-charact
                                       e1datem-key_date
                                       f_error.
*----------------------------------------------------------------------*
    WHEN c_segnam_tcme.           "restrictions

*........ move condensed data to structure ............................*

      e1tcmem = idoc_data-sdata.

*........ copy data to api-structure ..................................*

      charact_classtype-charact    = e1cabnm-atnam.
      charact_classtype-class_type = e1tcmem-klart.
      CLEAR: charact_classtype-fldelete.

*........ insert into table ...........................................*

      APPEND charact_classtype.
*----------------------------------------------------------------------*
    WHEN c_segnam_textl.         "long texts characteristic
      CLEAR t_e1textl.
      t_e1textl-charact = e1cabnm-atnam.

*........ move condensed data to structure ............................*

      e1textl = idoc_data-sdata.
      MOVE-CORRESPONDING e1textl TO t_e1textl.

*........ insert into table ...........................................*

      APPEND t_e1textl.
*----------------------------------------------------------------------*
    WHEN c_segnam_txtl1.         "long texts value
      CLEAR t_e1textl.
      t_e1txtl1-charact = e1cabnm-atnam.
** charact_value-value containes the last, relevant value in the
** external format. Internal format can't be used here.
      t_e1txtl1-value   = charact_value-value.

*........ move condensed data to structure ............................*

      e1txtl1 = idoc_data-sdata.
      MOVE-CORRESPONDING e1txtl1 TO t_e1txtl1.
*........ insert into table ...........................................*

      APPEND t_e1txtl1.

  ENDCASE.

ENDFORM.                    " FILL_TABLES

*eject
*&---------------------------------------------------------------------*
*&      Form  FIX_ORDER_OF_VALUES
*&---------------------------------------------------------------------*
*
*       fix order of values
*
*----------------------------------------------------------------------*
FORM fix_order_of_values.

  DATA:
    tabix LIKE sy-tabix,                    "buffer for SY-TABIX
    value LIKE charact_value.               "buffer for value

  DATA:       lv_opt(1) TYPE c VALUE 'X'.                   "1585835

*........ read all values and note following value .....................

  LOOP AT charact_value
    WHERE fldelete EQ space.

    IF charact_value-value IS INITIAL.                      "1585835
      CLEAR lv_opt.                                         "1585835
    ENDIF.                                                  "1585835

*........ read next value without delete flag ..........................

    tabix = sy-tabix.
    DO.
      ADD 1 TO tabix.

      READ TABLE charact_value INTO value INDEX tabix.
      IF NOT sy-subrc IS INITIAL.
        CLEAR value.
        EXIT.
      ELSEIF value-fldelete IS INITIAL.
        EXIT.
      ENDIF.
    ENDDO.

*........ note following value .........................................

    charact_value-value_bef = value-value.
    MODIFY charact_value.

  ENDLOOP.

* table CHARACT_VALUE has to be rearranged to improve           v 896513
* the performance when the characteristic is updated
  DATA:
    l_line        TYPE i,
    lt_value_temp LIKE char_vals OCCURS 30 WITH HEADER LINE,
    lt_value_del  LIKE char_vals OCCURS 30 WITH HEADER LINE.

  IF lv_opt IS INITIAL.                                     "1585835
    EXPORT 'X' TO MEMORY ID 'SAPLCTMV keep_sequence'.       "1585835
    EXIT.                                                   "1585835
  ENDIF.                                                    "1585835

  DELETE FROM MEMORY ID 'SAPLCTMV keep_sequence'.           "1585835

  DESCRIBE TABLE charact_value LINES l_line.

  WHILE l_line > 0.
    READ TABLE charact_value INDEX l_line INTO value.
    IF value-fldelete IS INITIAL.
      APPEND value TO lt_value_temp.
    ELSE.
      APPEND value TO lt_value_del.
    ENDIF.
    l_line = l_line - 1.
  ENDWHILE.

  CLEAR charact_value[].
  APPEND LINES OF lt_value_temp TO charact_value.
  APPEND LINES OF lt_value_del  TO charact_value.
  CLEAR lt_value_temp[].
  CLEAR lt_value_del[].                                     "^ 896513

ENDFORM.                    " FIX_ORDER_OF_VALUES

*&---------------------------------------------------------------------*
*&      Form  INIT_EFFECTIVITY
*&---------------------------------------------------------------------*
*
*       init function modules for effectivity
*
*----------------------------------------------------------------------*
*  -->  CHANGE_NO              change number
*  -->  KEY_DATE               key date for changing
*----------------------------------------------------------------------*
FORM init_effectivity USING change_no LIKE ccin-aennr
                            key_date  LIKE sy-datum.

  DATA:
    l_ecn_effectivity LIKE csdata-xfeld.    "flag for parameter effect.

  CHECK NOT change_no IS INITIAL.

*........ clear old selections .........................................

  CALL FUNCTION 'CLEF_REFRESH_AENNR_BUFFER'.

*........ get type of effectivity ......................................

  CALL FUNCTION 'CCCN_ECN_WITH_EFFECTIVITY'
    EXPORTING
      eaennr          = change_no
    IMPORTING
      flg_effectivity = l_ecn_effectivity
    EXCEPTIONS
      no_record_found = 1
      OTHERS          = 2.
  IF NOT sy-subrc IS INITIAL.
    CLEAR sy-subrc.
  ENDIF.

*........ init for parameter effectivity ...............................

  CHECK NOT l_ecn_effectivity IS INITIAL.
  CALL FUNCTION 'CLEF_ECM_PROCESSOR_INIT'
    EXPORTING
      key_date            = key_date
      i_aennr             = change_no
      i_batch             = c_mark
      i_maintain_flag     = c_mark
    EXCEPTIONS
      ecm_init_error      = 1
      exit_from_dynpro    = 2
      no_maintenance_data = 3
      OTHERS              = 4.

  CASE sy-subrc.
    WHEN 0.
    WHEN 3.
      MESSAGE e169(cl).
    WHEN OTHERS.
      MESSAGE e167(cl).
  ENDCASE.

ENDFORM.                    " INIT_EFFECTIVITY

*eject
*&---------------------------------------------------------------------*
*&      Form  INIT_TABLES
*&---------------------------------------------------------------------*
*                                                                      *
*       prepare internal tables for maintaining characteristics        *
*                                                                      *
*----------------------------------------------------------------------*
FORM init_tables.

*........ init headers ................................................*

  CLEAR:
    charact_data,
    charact_description,
    charact_classtype,
    charact_object,
    charact_value,
    charact_value_description.

*........ refresh tables ..............................................*

  REFRESH:
    charact_data,
    charact_description,
    charact_classtype,
    charact_object,
    charact_value,
    charact_value_description,
    t_e1cukb1,
    t_e1cukb2,
    t_e1cukbm,
    t_e1cukbt,
    t_e1cukn1,
    t_e1cuknm,
    t_e1cutx1,
    t_e1cutxm.

  CALL FUNCTION 'CTUT_REFRESH_BUFFER'
    EXCEPTIONS
      OTHERS = 1.
  IF NOT sy-subrc IS INITIAL.
    CLEAR sy-subrc.
  ENDIF.


ENDFORM.                    " INIT_TABLES

*eject
*&---------------------------------------------------------------------*
*&      Form  MARK_ENTRIES_TO_DELETE
*&---------------------------------------------------------------------*
*                                                                      *
*       get entries from db which are to be deleted                    *
*       compare all valid entries with the new entries                 *
*       distributed via ALE and set delete-flags for those             *
*       entries which are to delete                                    *
*                                                                      *
*----------------------------------------------------------------------*
*  -->  KEY_DATE                        key_date for change            *
*  -->  CHANGE_NO                       change number                  *
*----------------------------------------------------------------------*
FORM mark_entries_to_delete USING VALUE(key_date)  LIKE sy-datum
                                  VALUE(change_no) LIKE cabn-aennr.

  DATA:
    atinn    LIKE cabn-atinn.            "internal ID for characteristic

  DATA: lt_charact_value_temp LIKE char_vals                "1358547
                              OCCURS 30 WITH HEADER LINE.   "1358547

*........ get internal number for characteristic ......................*

  CALL FUNCTION 'CTUT_FEATURE_CHECK'
    EXPORTING
      change_number        = change_no
      feature_neutral_name = cabn-atnam
      key_date             = key_date
    IMPORTING
      feature_id           = atinn
    EXCEPTIONS
      OTHERS               = 1.

*........ if characteristic doesn't exist: nothing to delete ..........*

  CHECK sy-subrc EQ 0.

*-------- characteristic texts ----------------------------------------*

  CALL FUNCTION 'CTUT_CHARACT_GET_TEXTS'
    EXPORTING
      change_number  = change_no
      characteristic = atinn
      key_date       = key_date
    TABLES
      charact_texts  = cabnt_i
    EXCEPTIONS
      not_found      = 1
      OTHERS         = 2.
  IF NOT sy-subrc IS INITIAL.
    CLEAR sy-subrc.
  ENDIF.

  LOOP AT cabnt_i.

*........ Check if language is still used .............................*

    LOOP AT charact_description
      WHERE charact EQ cabn-atnam
      AND   language EQ cabnt_i-spras.
      EXIT.
    ENDLOOP.

*........ language not found: insert language with delete flag ........*

    IF sy-subrc NE 0.
      CLEAR charact_description.
      charact_description-charact = cabn-atnam.
      charact_description-language = cabnt_i-spras.
      charact_description-fldelete = c_mark.
      WRITE cabnt_i-spras TO charact_description-language_iso.

      APPEND charact_description.
    ENDIF.
  ENDLOOP.      " at cabnt_i

*-------- characteristic values ---------------------------------------*

  CALL FUNCTION 'CTUT_GET_VALUES'
    EXPORTING
      change_number  = change_no
      characteristic = atinn
      key_date       = key_date
    TABLES
      value_tab      = cawn_i
    EXCEPTIONS
      not_found      = 1
      OTHERS         = 2.
  IF NOT sy-subrc IS INITIAL.
    CLEAR sy-subrc.
  ENDIF.

*........ get external representation for datatype ne 'CHAR' ..........*

  IF cabn-atfor NE format_char.
    LOOP AT cawn_i.
      CALL FUNCTION 'CTCV_PREPARE_VALUES_TO_DISPLAY'
        EXPORTING
          decimalpoint         = decimalpoint
          structure_cabn       = cabn
          structure_cawn       = cawn_i
          string_with_baseunit = 'YES'
        IMPORTING
          string               = cawn_i-atwrt
        EXCEPTIONS
          overflow             = 1
          OTHERS               = 2.
      IF NOT sy-subrc IS INITIAL.
        CLEAR sy-subrc.
      ENDIF.

      MODIFY cawn_i.
    ENDLOOP.
  ENDIF.

*........ check if all the values are actually used ...................*

  lt_charact_value_temp[] = charact_value[].                "1358547
  SORT lt_charact_value_temp BY charact value.              "1358547

  LOOP AT cawn_i.
    READ TABLE lt_charact_value_temp                        "1358547
       WITH KEY charact = cabn-atnam                        "1358547
                value   = cawn_i-atwrt                      "1358547
       BINARY SEARCH.                                       "1358547

*........ value not found: insert value with delete flag...............*

    IF sy-subrc NE 0.
      CLEAR charact_value.                                  "1358547
      charact_value-charact  = cabn-atnam.
      charact_value-value    = cawn_i-atwrt.
      charact_value-fldelete = c_mark.

      APPEND charact_value.
    ENDIF.
  ENDLOOP.

*-------- characteristic values texts ---------------------------------*

  CALL FUNCTION 'CTUT_GET_TEXT_OF_VALUES'
    EXPORTING
      change_number  = change_no
      characteristic = atinn
      key_date       = key_date
    TABLES
      value_texts    = cawnt_i
    EXCEPTIONS
      not_found      = 1
      OTHERS         = 2.
  IF NOT sy-subrc IS INITIAL.
    CLEAR sy-subrc.
  ENDIF.
  "Begin 1329321
  SORT charact_value_description BY charact value language.
  SORT cawn_i BY atinn atzhl.

  LOOP AT cawnt_i.

    READ TABLE cawn_i
      WITH KEY atinn = cawnt_i-atinn
               atzhl = cawnt_i-atzhl
      BINARY SEARCH.

    IF sy-subrc IS INITIAL.
      READ TABLE charact_value_description
        WITH KEY charact  = cabn-atnam
                 value    = cawn_i-atwrt
                 language = cawnt_i-spras
        BINARY SEARCH.

      IF sy-subrc NE 0.
        CLEAR charact_value_description.
        charact_value_description-charact  = cabn-atnam.
        charact_value_description-value    = cawn_i-atwrt.
        charact_value_description-language = cawnt_i-spras.
        charact_value_description-fldelete = c_mark.
        WRITE cawnt_i-spras TO charact_value_description-language_iso.

        INSERT charact_value_description INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDLOOP.
  "End 1329321
*-------- restrictions ------------------------------------------------*

  SELECT * FROM tcme INTO TABLE tcme_i
    WHERE atinn EQ atinn.

*........ check if all restrictions are used furthermore ..............*

  LOOP AT tcme_i.
    LOOP AT charact_classtype
      WHERE charact EQ cabn-atnam
      AND   class_type EQ tcme_i-klart.
      EXIT.
    ENDLOOP.

*........ if restriction isn't used furthermore: insert entry with del *

    IF sy-subrc NE 0.
      charact_classtype-charact    = cabn-atnam.
      charact_classtype-class_type = tcme_i-klart.
      charact_classtype-fldelete   = c_mark.

      APPEND charact_classtype.
    ENDIF.
  ENDLOOP.

*-------- table references --------------------------------------------*

  SELECT * FROM cabnz INTO TABLE cabnz_i
    WHERE atinn EQ atinn.

*........ check if all references are used furthermore ................*

  LOOP AT cabnz_i.
    LOOP AT charact_object
      WHERE charact EQ cabn-atnam
      AND   ref_table EQ cabnz_i-attab
      AND   ref_field EQ cabnz_i-atfel.
      EXIT.
    ENDLOOP.

*........ if reference isn't used furthermore: insert entry with del fl.

    IF sy-subrc NE 0.
      charact_object-charact   = cabn-atnam.
      charact_object-ref_table = cabnz_i-attab.
      charact_object-ref_field = cabnz_i-atfel.
      charact_object-fldelete  = c_mark.

      APPEND charact_object.
    ENDIF.
  ENDLOOP.

ENDFORM.                    "MARK_ENTRIES_TO_DELETE

*eject
*&---------------------------------------------------------------------*
*&      Form  SAVE_CHARACTERISTIC
*&---------------------------------------------------------------------*
*                                                                      *
*       save characteristic by using an API                            *
*                                                                      *
*----------------------------------------------------------------------*
*  -->  CHANGE_NUMBER                    change number                 *
*  -->  KEY_DATE                         key_date for change           *
*  <--  IDOC_STATUS                      status of IDoc                *
*----------------------------------------------------------------------*
FORM save_characteristic USING VALUE(change_number) LIKE cabn-aennr
                               VALUE(key_date)      LIKE sy-datum
                               idoc_status STRUCTURE bdidocstat.

  DATA:
    f_chr_ok LIKE sy-batch,             "flag for charact o. k.
    f_error  LIKE sy-batch,             "flag for error
    f_warn   LIKE sy-batch,             "flag for warning (charact)
    f_warn1  LIKE sy-batch,             "flag for warning (charact)
    f_warn2  LIKE sy-batch,             "flag for warning (value)
    l_date   LIKE clbasd-val_from.      "date, external

  DATA lv_subrc TYPE sysubrc.

  CLEAR:
    f_warn,
    idoc_status.

  "* Begin of code by Sguda
  " Data Declarations for existing classification data purpose
  DATA: li_cabn   TYPE TABLE OF cabn,
        lst_cabn  TYPE cabn,
        li_cawn   TYPE TABLE OF cawn,
        lst_cawn  TYPE cawn,
        li_cawnt  TYPE TABLE OF cawnt,
        lst_cawnt TYPE cawnt.

  CLEAR : lst_cabn ,lst_cawn,lst_cawn .
  REFRESH : li_cabn , li_cawn  , li_cawnt.
  FREE : li_cabn , li_cawn  , li_cawnt.
  "* End of of code by Sguda
*....... init .........................................................*


  WRITE key_date TO l_date.
  CALL FUNCTION 'CUKD_API_INIT'.
  CALL FUNCTION 'CTMV_CHARACT_INIT'.

*........ insert informations to delete table entries .................*

*  PERFORM mark_entries_to_delete USING key_date
*                                       change_number.

  "* Begin of code by Sguda
  IF charact_data[] IS NOT INITIAL.
    " Fetching exsting data of characterstics .
    SELECT * FROM cabn
    INTO TABLE li_cabn
    FOR ALL ENTRIES IN charact_data
    WHERE atnam = charact_data-charact.

    IF li_cabn[] IS NOT INITIAL.
      "fetching exsting data of characterstics values
     select * from cawn
     into table li_cawn
     for all entries in  li_cabn
     where atinn = li_cabn-atinn.

      IF li_cawn[] IS NOT INITIAL.
        " Fetching exsting data of characterstics values description.
        SELECT * FROM cawnt
          INTO TABLE li_cawnt
          FOR ALL ENTRIES IN li_cawn
          WHERE atinn = li_cawn-atinn.
      ENDIF.

    ENDIF.
*
    IF li_cabn[] IS NOT INITIAL.

      SORT : charact_data[] BY charact , li_cabn[] BY atnam.
      " inserting new  characterstics values data type info into exsting values .
      LOOP AT charact_data INTO DATA(lst_charact_data).
        READ TABLE li_cabn INTO lst_cabn WITH KEY atnam = lst_charact_data-charact BINARY SEARCH.
        IF sy-subrc EQ 0.
          lst_charact_data-datatype = lst_cabn-atfor.
          lst_charact_data-charnumber = lst_cabn-anzst.
          MODIFY charact_data FROM lst_charact_data TRANSPORTING datatype charnumber WHERE charact = lst_cabn-atnam.
          CLEAR:lst_charact_data,lst_cabn.
        ENDIF.
      ENDLOOP.
      " inserting new  characterstics values into exsting values .
      IF li_cawn[] IS NOT INITIAL.
        SORT : li_cawn BY atinn , charact_value BY charact value .
        LOOP AT li_cawn INTO lst_cawn.
          READ TABLE charact_value INTO DATA(lst_charact_value) WITH KEY charact = lst_cawn-atinn
                                                                         value = lst_cawn-atwrt.
          IF sy-subrc NE 0.
            lst_charact_value-charact = lst_cawn-atinn.
            lst_charact_value-value_bef = lst_cawn-atwrt.
            lst_charact_value-value = lst_cawn-atwrt.
            APPEND lst_charact_value TO charact_value.
            CLEAR:lst_charact_value,lst_cawn.
          ENDIF.
        ENDLOOP.

        " inserting new  characterstics values description into exsting values .
        IF li_cawnt IS NOT INITIAL .

          SORT : li_cawnt BY atinn , charact_value_description BY charact language valdescr .

          LOOP AT li_cawnt INTO lst_cawnt.
            READ TABLE charact_value_description INTO DATA(lst_charact_value_description) WITH KEY charact = lst_cawnt-atinn
                                                                                                   language = lst_cawnt-spras
                                                                                                   valdescr    = lst_cawnt-atwtb.
            IF sy-subrc NE 0.
              lst_charact_value_description-charact = lst_cawnt-atinn.
              lst_charact_value_description-language = lst_cawnt-spras.
              lst_charact_value_description-valdescr = lst_cawnt-atwtb.
              APPEND lst_charact_value_description TO charact_value_description.
              CLEAR:lst_charact_value_description,lst_cawnt.
            ENDIF.
          ENDLOOP.
        ENDIF. " end cond for li_cawnt
      ENDIF. " cond end for  li_cawn
    ENDIF. "" cond end for  li_cabn
  ENDIF.   " " end cond for charact_data
  "* Begin of code by Sguda

*........ maintain characteristic via api..............................*

  CALL FUNCTION 'CAMA_CHARACT_MAINTAIN'
    EXPORTING
      change_no                 = change_number
      date                      = l_date
      comm_wait                 = 'X'                   "  1854522
    TABLES
      charact_data              = charact_data
      charact_description       = charact_description
      charact_classtype         = charact_classtype
      charact_object            = charact_object
      charact_value             = charact_value
      charact_value_description = charact_value_description
    EXCEPTIONS
      error                     = 1
      warning                   = 2
      OTHERS                    = 3.

  IF sy-subrc IS INITIAL.
*........ maintain additional characteristic data via enhancement......*
    CALL BADI lr_badi_idoc_processing->post_idoc_data
      EXPORTING
        iv_change_number          = change_number
        iv_date                   = l_date
        it_char_data              = charact_data[]
        it_char_description       = charact_description[]
        it_char_classtype         = charact_classtype[]
        it_char_object            = charact_object[]
        it_char_value             = charact_value[]
        it_char_value_description = charact_value_description[]
      IMPORTING
        ev_error                  = lv_subrc.

    sy-subrc  =  lv_subrc.
  ENDIF.

*........ write error message in case of error ........................*

  IF sy-subrc IS INITIAL.
    f_chr_ok = c_mark.
  ELSEIF sy-subrc EQ 1 OR
         sy-subrc GT 2.

    CALL FUNCTION 'CALO_MSG_APPEND_DB_LOG'
      IMPORTING                                             "1148223
        lognumber               = idoc_status-appl_log   "1148223
      EXCEPTIONS
        log_object_not_found    = 01
        log_subobject_not_found = 02
        log_internal_error      = 03.
    IF NOT sy-subrc IS INITIAL.
      CLEAR sy-subrc.
    ENDIF.

*....... IDoc not o. k. ...............................................*

    idoc_status-status = c_idoc_nok.
    idoc_status-msgid  = 'C1'.
    idoc_status-msgty  = 'E'.
    idoc_status-msgno  = '149'.
    EXIT.
  ELSEIF sy-subrc EQ 2.
    f_warn   = c_mark.
    f_chr_ok = c_mark.
  ENDIF.

*........ save charact data ............................................
** If everything is OK the charact is saved no matter if the long texts
** or the dependencies will cause errors.
** This saving clears the buffers in CTMV, CTUT, and CLSE as well;
** otherwise changings on the long texts would restore the old state
** of the charact and loose all the changes.
  CALL FUNCTION 'CAMA_CHARACT_SAVE'
    EXPORTING                                               "1268222
      comm_wait = 'X'                            "1268222
    EXCEPTIONS
      OTHERS    = 1.
  IF NOT sy-subrc IS INITIAL.
    CLEAR sy-subrc.
  ENDIF.


*........ save longtexts ...............................................
  PERFORM save_texts USING e1cabnm-atnam
                           change_number
                           key_date.

*........ delete existing dependencies .................................

  CALL FUNCTION 'CTMV_CHARACT_DELETE_ALL_ALLOC'
    EXPORTING
      change_number = change_number
      charact       = e1cabnm-atnam        "#EC DOM_EQUAL
      key_date      = key_date
    EXCEPTIONS
      error         = 1
      OTHERS        = 2.

*........ write error message in case of error ........................*

  IF NOT sy-subrc IS INITIAL.

    CALL FUNCTION 'CALO_MSG_APPEND_DB_LOG'
      IMPORTING                                             "1148223
        lognumber               = idoc_status-appl_log   "1148223
      EXCEPTIONS
        log_object_not_found    = 01
        log_subobject_not_found = 02
        log_internal_error      = 03.
    IF NOT sy-subrc IS INITIAL.
      CLEAR sy-subrc.
    ENDIF.

*....... IDoc not o. k. ...............................................*

    idoc_status-status = c_idoc_nok.
    idoc_status-msgid  = 'C1'.
    idoc_status-msgty  = 'E'.
    idoc_status-msgno  = '149'.
    EXIT.
  ENDIF.

*........ Add dependencies to characteristic ...........................

  PERFORM save_deps_charact USING e1cabnm-atnam
                                  change_number
                                  key_date
                                  f_error
                                  f_warn1.

*........ Add dependencies to value ....................................

  IF f_error IS INITIAL.
    PERFORM save_deps_value USING e1cabnm-atnam
                                  change_number
                                  key_date
                                  f_error
                                  f_warn2.
  ENDIF.

*........ write error message in case of error ........................*

  IF NOT f_error IS INITIAL.

    CALL FUNCTION 'CALO_MSG_APPEND_DB_LOG'
      IMPORTING                                              "1148223
        lognumber               = idoc_status-appl_log   "1148223
      EXCEPTIONS
        log_object_not_found    = 01
        log_subobject_not_found = 02
        log_internal_error      = 03.
    IF NOT sy-subrc IS INITIAL.
      CLEAR sy-subrc.
    ENDIF.

*....... IDoc not o. k. ...............................................*

    idoc_status-status = c_idoc_nok.
    idoc_status-msgid  = 'C1'.
    idoc_status-msgty  = 'E'.
    idoc_status-msgno  = '149'.

*........ save characteristic if error only within dependencies ........

    IF f_chr_ok EQ c_mark.
      CALL FUNCTION 'CAMA_CHARACT_SAVE'
        EXCEPTIONS
          OTHERS = 1.
      IF NOT sy-subrc IS INITIAL.
        CLEAR sy-subrc.
      ENDIF.
    ENDIF.

  ELSE.

*........ save characteristic ..........................................

    CALL FUNCTION 'CAMA_CHARACT_SAVE'
      EXCEPTIONS
        OTHERS = 1.
    IF NOT sy-subrc IS INITIAL.
      CLEAR sy-subrc.
    ENDIF.

*........ IDoc o. k. ..................................................*

    IF f_warn  IS INITIAL. "AND
*      F_WARN1 IS INITIAL AND
*      F_WARN2 IS INITIAL.
      idoc_status-status = c_idoc_ok.

*........ IDoc not o. k. ...............................................

    ELSE.

*........ write log to db ..............................................


      CALL FUNCTION 'CALO_MSG_APPEND_DB_LOG'
        IMPORTING                                           "1148223
          lognumber               = idoc_status-appl_log "1148223
        EXCEPTIONS
          log_object_not_found    = 01
          log_subobject_not_found = 02
          log_internal_error      = 03.
      IF NOT sy-subrc IS INITIAL.
        CLEAR sy-subrc.
      ENDIF.

*........ set IDoc status not o. k. ....................................

      idoc_status-status = c_idoc_nok.
      idoc_status-msgid  = 'C1'.
      idoc_status-msgty  = 'E'.
      idoc_status-msgno  = '149'.

    ENDIF.
  ENDIF.

ENDFORM.                    " SAVE_CHARACTERISTIC

*eject
*&---------------------------------------------------------------------*
*&      Form  UNIT_OF_MEASURE_ISO_TO_SAP
*&---------------------------------------------------------------------*
*
*       converts a unit of measure in ISO to the internal
*       SAP format
*
*----------------------------------------------------------------------*
*  -->  UNIT_ISO                    unit in ISO
*  -->  DATATYPE                    datatype of characteristic
*  <--  UNIT_SAP                    internal SAP unit
*----------------------------------------------------------------------*
FORM unit_of_measure_iso_to_sap
              USING    VALUE(unit_iso) LIKE cabn-msehi
                       datatype        LIKE cabn-atfor
              CHANGING unit_sap        LIKE cabn-msehi.

  DATA:
    curr_sap LIKE tcurc-waers,
    curr_iso LIKE tcurc-isocd,
    iso_code LIKE t006-isocode.

*....... continue if UNIT_ISO not empty ...............................*

  CHECK NOT unit_iso IS INITIAL.

*....... check datatype for type of conversion ........................*

  CASE datatype.
    WHEN 'CURR'.
      curr_iso = unit_iso.
      CLEAR: unit_sap.
      CALL FUNCTION 'CURRENCY_CODE_ISO_TO_SAP'
        EXPORTING
          iso_code  = curr_iso
        IMPORTING
          sap_code  = curr_sap
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF sy-subrc IS INITIAL.
        unit_sap = curr_sap.
      ELSE.
        unit_sap = unit_iso.
      ENDIF.
    WHEN OTHERS.

*....... convert ISO to SAP ...........................................*

      iso_code = unit_iso.
      CLEAR: unit_sap.
      CALL FUNCTION 'UNIT_OF_MEASURE_ISO_TO_SAP'
        EXPORTING
          iso_code  = iso_code
        IMPORTING
          sap_code  = unit_sap
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF NOT sy-subrc IS INITIAL.
        unit_sap = unit_iso.
      ENDIF.

  ENDCASE.  " at DATATYPE

ENDFORM.                    " UNIT_OF_MEASURE_ISO_TO_SAP

*eject
*&---------------------------------------------------------------------*
*&      Form  UNIT_OF_MEASURE_SAP_TO_ISO
*&---------------------------------------------------------------------*
*
*       converts a unit of measure in internal
*       SAP format to ISO
*
*----------------------------------------------------------------------*
*  -->  UNIT_SAP                    internal SAP unit
*  -->  DATATYPE                    datatype of characteristic
*  <--  UNIT_ISO                    unit in ISO
*----------------------------------------------------------------------*
FORM unit_of_measure_sap_to_iso USING    unit_sap LIKE cabn-msehi
                                         datatype LIKE cabn-atfor
                                CHANGING unit_iso LIKE cabn-msehi.

  DATA:
    curr_sap LIKE tcurc-waers,
    curr_iso LIKE tcurc-isocd,
    iso_code LIKE t006-isocode.

*....... continue if UNIT_SAP not empty ...............................*

  CHECK NOT unit_sap IS INITIAL.

*....... check datatype for type of conversion ........................*

  CASE datatype.
    WHEN 'CURR'.
      curr_sap = unit_sap.
      CLEAR: unit_iso.
      CALL FUNCTION 'CURRENCY_CODE_SAP_TO_ISO'
        EXPORTING
          sap_code  = curr_sap
        IMPORTING
          iso_code  = curr_iso
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF sy-subrc IS INITIAL.
        unit_iso = curr_iso.
      ELSE.
        unit_iso = unit_sap.
      ENDIF.
    WHEN OTHERS.
      CLEAR: unit_iso.
      CALL FUNCTION 'UNIT_OF_MEASURE_SAP_TO_ISO'
        EXPORTING
          sap_code    = unit_sap
        IMPORTING
          iso_code    = iso_code
        EXCEPTIONS
          not_found   = 1
          no_iso_code = 2
          OTHERS      = 3.
      IF sy-subrc IS INITIAL.
        unit_iso = iso_code.
      ELSE.
        unit_iso = unit_sap.
      ENDIF.

  ENDCASE.  " at DATATYPE

ENDFORM.                    " UNIT_OF_MEASURE_SAP_TO_ISO
