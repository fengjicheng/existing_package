*----------------------------------------------------------------------*
***INCLUDE ZQTCN_BP_RULES_F01.
*----------------------------------------------------------------------*
CLASS lcl_bp_rules IMPLEMENTATION.
  METHOD meth_get_data.
* Declarations to store field names of Internal Table
    DATA: lo_tabledescr_ref TYPE REF TO cl_abap_tabledescr,
          lo_descr_ref      TYPE REF TO cl_abap_structdescr.
* Fetch a record from table
    SELECT *
      FROM zqtc_bp_rules
      INTO TABLE gt_bp_rules
      WHERE source EQ p_source.
    IF sy-subrc EQ 0.
      REFRESH gt_final.
* Store all the fields of Internal table into l_descr_ref-> components internal table
      lo_tabledescr_ref ?= cl_abap_typedescr=>describe_by_data( gt_bp_rules ).
      lo_descr_ref ?= lo_tabledescr_ref->get_table_line_type( ).
      IF lo_descr_ref->components IS NOT INITIAL.
* Fetch the fields short description with data elements
        SELECT fieldname, ddtext
          FROM dd03m
          INTO TABLE @DATA(lt_dd03m)
          FOR ALL ENTRIES IN @lo_descr_ref->components
          WHERE tabname EQ 'ZQTC_BP_RULES'
          AND ( fieldname EQ @lo_descr_ref->components-name
          AND fieldname NOT IN ( 'MANDT', 'SOURCE', 'UPDATED_ON', 'UPDATED_TIME', 'UPDATED_BY' ) )
          AND ddlanguage EQ 'E'.
        IF sy-subrc EQ 0.
          SORT lt_dd03m BY fieldname.
        ENDIF.
* Fetch the fields short descriptions without data elements
        SELECT fieldname, ddtext
          FROM dd03t
          INTO TABLE @DATA(lt_dd03t)
          FOR ALL ENTRIES IN @lo_descr_ref->components
          WHERE tabname EQ 'ZQTC_BP_RULES'
            AND ddlanguage EQ 'E'
            AND fieldname EQ @lo_descr_ref->components-name.
        IF sy-subrc EQ 0.
          SORT lt_dd03t BY fieldname.
* Fill the final internal table with field descriptions
          LOOP AT lo_descr_ref->components
            ASSIGNING FIELD-SYMBOL(<lv_comp>).
            READ TABLE lt_dd03m ASSIGNING FIELD-SYMBOL(<lw_dd03m>)
              WITH KEY fieldname = <lv_comp>-name BINARY SEARCH.
            IF sy-subrc EQ 0.
              gw_final-field_name = <lv_comp>-name.
              gw_final-rule_type  = <lw_dd03m>-ddtext.
              APPEND gw_final TO gt_final.
            ELSE.
              READ TABLE lt_dd03t ASSIGNING FIELD-SYMBOL(<lw_dd03t>)
                WITH KEY fieldname = <lv_comp>-name BINARY SEARCH.
              IF sy-subrc EQ 0.
                gw_final-field_name = <lv_comp>-name.
                gw_final-rule_type  = <lw_dd03t>-ddtext.
                APPEND gw_final TO gt_final.
              ENDIF.
            ENDIF.
            CLEAR gw_final.
          ENDLOOP.
        ENDIF.
        FREE : lt_dd03m, lt_dd03t.
* Fill the final internal table with status from GT_BP_RULES internal table
        IF gt_final IS NOT INITIAL.
          READ TABLE gt_bp_rules INTO gw_bp_rules INDEX 1.
          IF sy-subrc EQ 0.
            LOOP AT gt_final ASSIGNING FIELD-SYMBOL(<gw_final>).
              ASSIGN COMPONENT <gw_final>-field_name
                  OF STRUCTURE gw_bp_rules
              TO FIELD-SYMBOL(<lv_status>).
              IF sy-subrc EQ 0.
                <gw_final>-status = <lv_status>.
              ENDIF.
            ENDLOOP.
            CLEAR gw_bp_rules.
          ENDIF.
        ENDIF.
      ENDIF.
    ELSE.
* Display No records found message when no records found
      MESSAGE 'No records found'(006) TYPE c_i.
      LEAVE SCREEN.
    ENDIF.
  ENDMETHOD.
  METHOD meth_generate_output.
    PERFORM f_prepar_catalog.  " Prepare fielfcatalog
    PERFORM f_prepar_layout.   " Prepare layout
    PERFORM f_display_table. " Display the final table
  ENDMETHOD.
ENDCLASS.
