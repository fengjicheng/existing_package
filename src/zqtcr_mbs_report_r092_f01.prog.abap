*----------------------------------------------------------------------*
***INCLUDE ZQTCR_MBS_REPORT_R092_F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_VENDOR_RANGE_RESTRICT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_vendor_range_restrict .
  DATA: lw_selopt   TYPE sscr_ass,
        lw_opt_list TYPE sscr_opt_list,
        lt_restrict TYPE sscr_restrict.
  CONSTANTS : lc_eq       TYPE char2    VALUE 'EQ',          " Equal
              lc_x        TYPE char1    VALUE 'X',           " Checked
              lc_s        TYPE char1    VALUE 'S',           " Success
              lc_so_vendr TYPE char8    VALUE 'SO_VENDR',    " Grade
              lc_i        TYPE char1    VALUE 'I',           " Inclusive / Informative
              lc_blank    TYPE char1    VALUE ' '.           " Blank
  CLEAR lw_opt_list.
  lw_opt_list-name          = lc_eq.
  lw_opt_list-options-eq    = lc_x.
  APPEND lw_opt_list TO lt_restrict-opt_list_tab.

  CLEAR lw_selopt.
  lw_selopt-kind            = lc_s.
  lw_selopt-name            = lc_so_vendr.
  lw_selopt-sg_main         = lc_i.
  lw_selopt-sg_addy         = lc_blank.
  lw_selopt-op_main         = lc_eq.
  lw_selopt-op_addy         = lc_eq.
  APPEND lw_selopt  TO lt_restrict-ass_tab.
  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING
      restriction            = lt_restrict
    EXCEPTIONS
      too_late               = 1
      repeated               = 2
      selopt_without_options = 3
      selopt_without_signs   = 4
      invalid_sign           = 5
      empty_option_list      = 6
      invalid_kind           = 7
      repeated_kind_a        = 8
      OTHERS                 = 9.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INIT_PO_TYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_init_po_type .
  CONSTANTS:lc_potype TYPE rvari_vnam VALUE 'POTYPE'.
  SELECT devid,                                                  "Development ID
         param1,                                                  "ABAP: Name of Variant Variable
         param2,                                                  "ABAP: Name of Variant Variable
         srno,                                                    "ABAP: Current selection number
         sign,                                                    "ABAP: ID: I/E (include/exclude values)
         opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
         low,                                                    "Lower Value of Selection Condition
         high,                                                    "Upper Value of Selection Condition
         activate                                               "Activation indicator for constant
    FROM zcaconstant
    INTO TABLE @DATA(lt_zcaconstant)
    WHERE devid    EQ @c_devid
      AND activate EQ @c_x.
  IF sy-subrc EQ 0.
    LOOP AT lt_zcaconstant ASSIGNING FIELD-SYMBOL(<fs_con>).
      CASE <fs_con>-param1.
        WHEN lc_potype.
          s_potyp-sign   = <fs_con>-sign.
          s_potyp-option = <fs_con>-opti.
          s_potyp-low    = <fs_con>-low.
          s_potyp-high   = <fs_con>-high.
          APPEND s_potyp.
      ENDCASE.
    ENDLOOP.
  ENDIF.
ENDFORM.
