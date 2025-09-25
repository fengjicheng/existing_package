*----------------------------------------------------------------------*
***INCLUDE ZQTCN_BP_RULES_O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_table .
* create container
  CREATE OBJECT o_custom_container
    EXPORTING
      container_name              = o_container
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc <> 0.
    MESSAGE 'Error Container'(007) TYPE c_i.
  ENDIF.
* create alv grid
  CREATE OBJECT o_grid
    EXPORTING
      i_parent          = o_custom_container
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE 'Error Grid'(008) TYPE c_i.
  ENDIF.

* Display table
  PERFORM f_first_display.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PREPAR_CATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_prepar_catalog .
  CONSTANTS : lc_60 TYPE i VALUE 60,           " Output Length
              lc_6  TYPE i VALUE 6.
* Set field catalog for two fields
  REFRESH gt_fieldcat.
  gw_fieldcat-col_pos   = 1.
  gw_fieldcat-fieldname = 'RULE_TYPE'.
  gw_fieldcat-tabname   = 'GT_FINAL'.
  gw_fieldcat-scrtext_l = 'Rule Type'(004).
  gw_fieldcat-outputlen = lc_60.
  APPEND gw_fieldcat TO gt_fieldcat.
  CLEAR gw_fieldcat.
  gw_fieldcat-col_pos   = 2.
  gw_fieldcat-fieldname = 'STATUS'.
  gw_fieldcat-tabname   = 'GT_FINAL'.
  gw_fieldcat-scrtext_l = 'Status'(005).
  gw_fieldcat-ref_table = 'TPALOG'.
  gw_fieldcat-ref_field = 'ALLCLI'.
  gw_fieldcat-outputlen = lc_6.
  APPEND gw_fieldcat TO gt_fieldcat.
  CLEAR gw_fieldcat.
* Make the Status field Editable only in Maintain mode
  IF rb_main EQ abap_true.
    LOOP AT gt_fieldcat INTO gw_fieldcat.
      CASE gw_fieldcat-fieldname.
        WHEN 'STATUS'.
          gw_fieldcat-edit = 'X'.
          MODIFY gt_fieldcat FROM gw_fieldcat.
          CLEAR gw_fieldcat.
      ENDCASE.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PREPAR_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_prepar_layout .
  gw_layout-zebra      = 'X'.   " Zebra strips
  IF rb_disp IS NOT INITIAL.
    CLEAR gw_layout-no_toolbar. " Display toolbar in display mode
  ELSE.
    gw_layout-no_toolbar = 'X'. " No toolbar in maintain mode
    gw_layout-no_rowmark = 'X'. " Disable row selection
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FIRST_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_first_display .
* Display the table
  CALL METHOD o_grid->set_table_for_first_display
    EXPORTING
      i_save                        = 'A'
      i_default                     = abap_true
      is_layout                     = gw_layout
    CHANGING
      it_fieldcatalog               = gt_fieldcat[]
      it_outtab                     = gt_final
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_2000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_2000 OUTPUT.
  IF rb_disp IS NOT INITIAL.
    SET PF-STATUS 'STATUS_2000' EXCLUDING 'SAV'. " Set the PF-Status
  ELSE.
    SET PF-STATUS 'STATUS_2000'.               " Set the PF-Status
  ENDIF.
  SET TITLEBAR 'ZBP_RULE'.                   " Set the Title bar
  PERFORM f_modif_screen.                    " Modify the screen elemnts
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  LIST_SOURCES  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE list_sources INPUT.
  PERFORM f_f4_source.  " F4 Help for source input field
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  F_F4_SOURCE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_f4_source .
  TYPES : BEGIN OF lty_value,
            name TYPE tpm_source_name,
          END OF lty_value.
  DATA : lt_value_tab  TYPE TABLE OF lty_value,
         lw_value      TYPE lty_value,
         lt_field_tab  TYPE TABLE OF dfies,
         lw_field      TYPE dfies,
         lt_return_tab TYPE TABLE OF ddshretval,
         lw_return     TYPE ddshretval.
  CLEAR : lw_value, lw_field, lw_return.
  REFRESH : lt_value_tab,
            lt_field_tab,
            lt_return_tab.
* Fetch all the source names in the table
  SELECT source
  FROM zqtc_bp_rules
  INTO TABLE @DATA(lt_bp_rules).
  IF sy-subrc EQ 0.
    lw_field-fieldname = 'SOURCE'.
    lw_field-tabname = 'ZQTC_BP_RULES'.
    APPEND lw_field TO lt_field_tab.
    SORT lt_bp_rules BY source ASCENDING.
* Preparing F4 help list
    LOOP AT lt_bp_rules INTO DATA(lw_bp_rules).
      lw_value-name = lw_bp_rules-source.
      APPEND lw_value TO lt_value_tab.
      CLEAR : lw_value, lw_bp_rules.
    ENDLOOP.
* Generating F4 help list
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = lw_field-fieldname
      TABLES
        value_tab       = lt_value_tab
        field_tab       = lt_field_tab
        return_tab      = lt_return_tab
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc = 0.
      READ TABLE lt_return_tab INTO lw_return INDEX 1.
* Storing the selected value into input field
      p_source = lw_return-fieldval.
      PERFORM f_free_container.              " Container Destructor
      LOOP AT SCREEN.
        IF screen-name = 'DETAILS'.
          screen-active = 0.        " Hide the Details box
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.
