*----------------------------------------------------------------------*
* PROGRAM NAME: FZQTC_DEATILREPORT_EXTEND_ONN (Detail report PBO Module)
* PROGRAM DESCRIPTION: Entire logic of detail report PBO Module
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   09/12/2019
* WRICEF ID:       R090
* TRANSPORT NUMBER(S):  ED2K916156

* REVISION HISTORY-----------------------------------------------------*
* Transport NO: ED2K916403
* REFERENCE NO: ERPM-1825
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  10/08/2019
* DESCRIPTION:

* REVISION HISTORY-----------------------------------------------------*
* Transport NO: ED2K916403
* REFERENCE NO: ERPM-5295
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  11/20/2019
* DESCRIPTION:
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*

MODULE status_3000 OUTPUT.
  SET PF-STATUS 'STATUS3000'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.

MODULE build_fieldcatalog OUTPUT.

  PERFORM f_build_fieldcat_podetail.        " PO detail field catalog
  PERFORM f_build_fieldcat_biosdetail.      " BIOS detail field catalog
  PERFORM f_build_fieldcat_jdrdetail.       " JDR detail field catalog
  PERFORM f_build_fieldcat_salesdetail.     " Sales detail field catalog
  PERFORM f_build_fieldcat_sohdetail.       " SOH detail field catalog
*** Begin of changes for  ED2K916403 ***
  PERFORM f_build_fieldcat_isohdetail.      " Initial SOH detail field catalog
  PERFORM f_build_fieldcat_jrrdetail.       " JRR detail field catalog
  PERFORM f_build_fieldcat_prdisdetail.     " Printer dispatch detail field catalog
*** End of changes for  ED2K916403 ***

ENDMODULE.

FORM f_build_fieldcat_podetail.

  CLEAR : st_fieldcat_podetail,i_fieldcat_podetail[].

  PERFORM f_build_fcat_podetail USING : 'MATERIAL' 'I_VIEW_PODETAIL' text-006 '18' '18',
                                        'ACT_PUBLICATION_DATE' 'I_VIEW_PODETAIL' text-007 '' '',
                                        'PO_TYPE' 'I_VIEW_PODETAIL' text-008 '4' '7',
                                        'TRACKING_NO' 'I_VIEW_PODETAIL' text-009 '10' '10',
                                        'PO_QTY' 'I_VIEW_PODETAIL' text-010 '' '',
                                        'PO_NUMBER' 'I_VIEW_PODETAIL' text-011 '10' '10',
                                        'ITEM' 'I_VIEW_PODETAIL' text-012 '5' '4',
                                        'COMPANY_CODE' 'I_VIEW_PODETAIL' text-013 '4' '',
                                        'CREATED_DATE' 'I_VIEW_PODETAIL' text-014 '' '',
                                        'DOCUMENT_DATE' 'I_VIEW_PODETAIL' text-015 '' '',
                                        'VENDOR' 'I_VIEW_PODETAIL' text-016 '10' '',
                                        'PLANT' 'I_VIEW_PODETAIL' text-017 '4' '',
                                        'ACCOUNT_ASSIGNMENT' 'I_VIEW_PODETAIL' text-018 '1' '',
                                        'CREATED_BY' 'I_VIEW_PODETAIL' text-019 '' '',
                                        'DELETION_INDICATOR' 'I_VIEW_PODETAIL' text-020 '1' ''.

ENDFORM.

FORM f_build_fcat_podetail USING fp_field TYPE any  " Field Name
                            fp_tab TYPE any         " Itab Name
                            fp_text TYPE any        " Display Text
                            fp_ddout TYPE any       " ALV filtering box length
                            fp_outlen TYPE any.      " Output length in ALV grid

  st_fieldcat_podetail-fieldname = fp_field.
  st_fieldcat_podetail-tabname   = fp_tab.
  st_fieldcat_podetail-coltext   = fp_text.
  st_fieldcat_podetail-lowercase  = abap_true.
  st_fieldcat_podetail-dd_outlen = fp_ddout.
  st_fieldcat_podetail-outputlen = fp_outlen.
  st_fieldcat_podetail-decimals_o = text-100.

  APPEND st_fieldcat_podetail TO i_fieldcat_podetail.
  CLEAR st_fieldcat_podetail.

ENDFORM.

MODULE po_detail_data OUTPUT.

  IF v_detail_cc_podetail IS NOT BOUND.

    CREATE OBJECT v_detail_cc_podetail        " Create object for PO detail custom container
      EXPORTING
        container_name              = v_detail_con_podetail
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

  CHECK v_detail_cc_podetail IS BOUND.

  CREATE OBJECT v_detail_grid                   " Create object for Grid
    EXPORTING
      i_parent          = v_detail_cc_podetail
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK v_detail_grid IS BOUND.

  CALL METHOD v_detail_grid->set_table_for_first_display          " Display data to output
    EXPORTING
      i_save                        = 'A'
      i_default                     = c_x    " Default Display Variant
      is_layout                     = st_layout
    CHANGING
      it_outtab                     = i_view_podetail
      it_fieldcatalog               = i_fieldcat_podetail
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMODULE.

FORM f_build_fieldcat_biosdetail .

  CLEAR : st_fieldcat_biosdetail,i_fieldcat_biosdetail[].

  PERFORM f_build_fcat_biosdetail USING : 'MEDIA_ISSUE' 'I_VIEW_BIOSDETAIL' text-006 '18' '18',
                                          'ADUSTMENT_TYPE' 'I_VIEW_BIOSDETAIL' text-021 '30' '15',
                                          'BIOS_QUANTITY' 'I_VIEW_BIOSDETAIL' text-022 '' '',
                                          'ACT_PUBLICATION_DATE' 'I_VIEW_BIOSDETAIL' text-007 '' ''.

ENDFORM.

FORM f_build_fcat_biosdetail USING fp_field TYPE any    " Field Name
                            fp_tab TYPE any             " Itab Name
                            fp_text TYPE any            " Display Text
                            fp_ddout TYPE any           " ALV filtering box length
                            fp_outlen TYPE any.         " Output length in ALV grid

  st_fieldcat_biosdetail-fieldname = fp_field.
  st_fieldcat_biosdetail-tabname   = fp_tab.
  st_fieldcat_biosdetail-coltext   = fp_text.
  st_fieldcat_biosdetail-lowercase = abap_true.
  st_fieldcat_biosdetail-dd_outlen = fp_ddout.
  st_fieldcat_biosdetail-outputlen = fp_outlen.
  st_fieldcat_biosdetail-decimals_o = text-100.

  APPEND st_fieldcat_biosdetail TO i_fieldcat_biosdetail.
  CLEAR st_fieldcat_biosdetail.

ENDFORM.

MODULE bios_detail_data OUTPUT.

  IF v_detail_cc_biosdetail IS NOT BOUND.

    CREATE OBJECT v_detail_cc_biosdetail              " Create object for BIOS detail custom container
      EXPORTING
        container_name              = v_detail_con_biosdetail
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

  CHECK v_detail_cc_biosdetail IS BOUND.

  CREATE OBJECT v_detail_grid                         " Create object for Grid
    EXPORTING
      i_parent          = v_detail_cc_biosdetail
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK v_detail_grid IS BOUND.

  CALL METHOD v_detail_grid->set_table_for_first_display          " Display data to output
    EXPORTING
      i_save                        = 'A'
      i_default                     = c_x    " Default Display Variant
      is_layout                     = st_layout
    CHANGING
      it_outtab                     = i_view_biosdetail
      it_fieldcatalog               = i_fieldcat_biosdetail
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMODULE.

FORM f_build_fieldcat_jdrdetail.

  CLEAR : st_fieldcat_jdrdetail,i_fieldcat_jdrdetail[].

  PERFORM f_build_fcat_jdrdetail USING : 'MEDIA_ISSUE' 'I_VIEW_JDRDETAIL' text-006 '18' '18',
                                         'ADUSTMENT_TYPE' 'I_VIEW_JDRDETAIL' text-021 '30' '15',            " Add "ADUSTMENT_TYPE" with ED2K916403
                                         'JDR_QUANTITY' 'I_VIEW_JDRDETAIL' text-023 '' '',
                                         'ACT_PUBLICATION_DATE' 'I_VIEW_JDRDETAIL' text-024 '' ''.

ENDFORM.

FORM f_build_fcat_jdrdetail USING fp_field TYPE any   " Field Name
                            fp_tab TYPE any           " Itab Name
                            fp_text TYPE any          " Display Text
                            fp_ddout TYPE any         " ALV filtering box length
                            fp_outlen TYPE any.       " Output length in ALV grid

  st_fieldcat_jdrdetail-fieldname = fp_field.
  st_fieldcat_jdrdetail-tabname   = fp_tab.
  st_fieldcat_jdrdetail-coltext   = fp_text.
  st_fieldcat_jdrdetail-lowercase = abap_true.
  st_fieldcat_jdrdetail-dd_outlen = fp_ddout.
  st_fieldcat_jdrdetail-outputlen = fp_outlen.
  st_fieldcat_jdrdetail-decimals_o = text-100.

  APPEND st_fieldcat_jdrdetail TO i_fieldcat_jdrdetail.
  CLEAR st_fieldcat_jdrdetail.

ENDFORM.

MODULE jdr_detail_data OUTPUT.

  IF v_detail_cc_jdrdetail IS NOT BOUND.

    CREATE OBJECT v_detail_cc_jdrdetail                   " Create object for JDR detail custom container
      EXPORTING
        container_name              = v_detail_con_jdrdetail
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

  CHECK v_detail_cc_jdrdetail IS BOUND.

  CREATE OBJECT v_detail_grid                           " Create object for Grid
    EXPORTING
      i_parent          = v_detail_cc_jdrdetail
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK v_detail_grid IS BOUND.

  CALL METHOD v_detail_grid->set_table_for_first_display          " Display data to output
    EXPORTING
      i_save                        = 'A'
      i_default                     = c_x    " Default Display Variant
      is_layout                     = st_layout
    CHANGING
      it_outtab                     = i_view_jdrdetail
      it_fieldcatalog               = i_fieldcat_jdrdetail
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMODULE.

FORM f_build_fieldcat_salesdetail.

  CLEAR : st_fieldcat_salesdetail,i_fieldcat_salesdetail[].

  PERFORM f_build_fcat_salesdetail USING : 'MEDIA_ISSUE' 'I_VIEW_SALESDETAIL' text-006 '18' '18',
                                           'DOCUMENT_TYPE' 'I_VIEW_SALESDETAIL' text-025 '4' '4',
                                           'DOCUMENT_TYPE_DESC' 'I_VIEW_SALESDETAIL' text-026 '40' '25',
                                           'ITEM_CATEGORY' 'I_VIEW_SALESDETAIL' text-027 '4' '4',
                                           'TARGET_QTY' 'I_VIEW_SALESDETAIL' text-028 '' '',
                                           'DOCUMENT_NUMBER' 'I_VIEW_SALESDETAIL' text-029 '10' '10',
                                           'ACT_PUB_DATE' 'I_VIEW_SALESDETAIL' text-030 '' '',
                                           'ITEM' 'I_VIEW_SALESDETAIL' text-031 '6' '6',
                                           'SU' 'I_VIEW_SALESDETAIL' text-032 '3' '3',
                                           'REFERENCE_DOCUMENT' 'I_VIEW_SALESDETAIL' text-033 '10' '10',
                                           'REFERENCE_DOCUMENT_TYPE' 'I_VIEW_SALESDETAIL' text-034 '1' '10',
                                           'SUBS_SALES_ORDER' 'I_VIEW_SALESDETAIL' text-035 '40' '25',
                                           'REFITM' 'I_VIEW_SALESDETAIL' text-036 '6' '6',
                                           'CONDITION_GROUP_4' 'I_VIEW_SALESDETAIL' text-037 '2' '10',
                                           'FREE_NOT_FREE' 'I_VIEW_SALESDETAIL' text-038 '40' '20',
                                           'CREATED_DATE' 'I_VIEW_SALESDETAIL' text-039 '' '',
                                           'CREATED_BY' 'I_VIEW_SALESDETAIL' text-040 '' '',
                                           'SALES_ORGANIZATION' 'I_VIEW_SALESDETAIL' text-041 '4' '4',
                                           'MATERIAL_GRP_5' 'I_VIEW_SALESDETAIL' text-042 '3' '5',
                                           'REJECTION_REASON' 'I_VIEW_SALESDETAIL' text-043 '2' '10',
                                           'SCHEDULE_LINE_TYPE' 'I_VIEW_SALESDETAIL' text-044 '2' '10'.

ENDFORM.

FORM f_build_fcat_salesdetail USING fp_field TYPE any       " Field Name
                            fp_tab TYPE any                 " Itab Name
                            fp_text TYPE any                " Display Text
                            fp_ddout TYPE any               " ALV filtering box length
                            fp_outlen TYPE any.             " Output length in ALV grid

  st_fieldcat_salesdetail-fieldname = fp_field.
  st_fieldcat_salesdetail-tabname   = fp_tab.
  st_fieldcat_salesdetail-coltext   = fp_text.
  st_fieldcat_salesdetail-lowercase = abap_true.
  st_fieldcat_salesdetail-dd_outlen = fp_ddout.
  st_fieldcat_salesdetail-outputlen = fp_outlen.
  st_fieldcat_salesdetail-decimals_o = text-100.

  APPEND st_fieldcat_salesdetail TO i_fieldcat_salesdetail.
  CLEAR st_fieldcat_salesdetail.

ENDFORM.

MODULE sales_detail_data OUTPUT.

  IF v_detail_cc_salesdetail IS NOT BOUND.

    CREATE OBJECT v_detail_cc_salesdetail                         " Create object for Sales detail custom container
      EXPORTING
        container_name              = v_detail_con_salesdetail
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

  CHECK v_detail_cc_salesdetail IS BOUND.

  CREATE OBJECT v_detail_grid                                     " Create object for Grid
    EXPORTING
      i_parent          = v_detail_cc_salesdetail
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK v_detail_grid IS BOUND.

  CALL METHOD v_detail_grid->set_table_for_first_display          " Display data to output
    EXPORTING
      i_save                        = 'A'
      i_default                     = c_x    " Default Display Variant
      is_layout                     = st_layout
    CHANGING
      it_outtab                     = i_view_salesdetail
      it_fieldcatalog               = i_fieldcat_salesdetail
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMODULE.

FORM f_build_fieldcat_sohdetail .

  CLEAR : st_fieldcat_sohdetail,i_fieldcat_sohdetail.

  PERFORM f_build_fcat_sohdetail USING : 'MEDIA_ISSUE' 'I_VIEW_SOHDETAIL' text-006 '18' '18',
                                         'SOH_QTY' 'I_VIEW_SOHDETAIL' text-045 '' '',
                                         'ACT_PUBLICATION_DATE' 'I_VIEW_SOHDETAIL' text-046 '' ''.

ENDFORM.

FORM f_build_fcat_sohdetail USING fp_field TYPE any     " Field Name
                            fp_tab TYPE any             " Itab Name
                            fp_text TYPE any            " Display Text
                            fp_ddout TYPE any           " ALV filtering box length
                            fp_outlen TYPE any.         " Output length in ALV grid

  st_fieldcat_sohdetail-fieldname = fp_field.
  st_fieldcat_sohdetail-tabname   = fp_tab.
  st_fieldcat_sohdetail-coltext   = fp_text.
  st_fieldcat_sohdetail-lowercase = abap_true.
  st_fieldcat_sohdetail-dd_outlen = fp_ddout.
  st_fieldcat_sohdetail-outputlen = fp_outlen.
  st_fieldcat_sohdetail-decimals_o = text-100.

  APPEND st_fieldcat_sohdetail TO i_fieldcat_sohdetail.
  CLEAR st_fieldcat_sohdetail.

ENDFORM.

MODULE soh_detail_data OUTPUT.

  IF v_detail_cc_sohdetail IS NOT BOUND.

    CREATE OBJECT v_detail_cc_sohdetail                       " Create object for SOH detail custom container
      EXPORTING
        container_name              = v_detail_con_sohdetail
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

  CHECK v_detail_cc_sohdetail IS BOUND.

  CREATE OBJECT v_detail_grid                                 " Create object for Grid
    EXPORTING
      i_parent          = v_detail_cc_sohdetail
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK v_detail_grid IS BOUND.

  CALL METHOD v_detail_grid->set_table_for_first_display        " Display data to output
    EXPORTING
      i_save                        = 'A'
      i_default                     = c_x    " Default Display Variant
      is_layout                     = st_layout
    CHANGING
      it_outtab                     = i_view_sohdetail
      it_fieldcatalog               = i_fieldcat_sohdetail
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMODULE.

" Begin of changes for ED2K916403

FORM f_build_fieldcat_isohdetail .

  CLEAR : st_fieldcat_isohdetail,i_fieldcat_isohdetail.

  PERFORM f_build_fcat_isohdetail USING : 'MEDIA_ISSUE' 'I_VIEW_ISOHDETAIL' text-006 '18' '18',
                                          'INITAL_SOH_QUANTITY' 'I_VIEW_ISOHDETAIL' text-086 '' '',
                                          'ACT_PUBLICATION_DATE' 'I_VIEW_ISOHDETAIL' text-046 '' ''.
ENDFORM.

FORM f_build_fcat_isohdetail USING fp_field TYPE any     " Field Name
                             fp_tab TYPE any             " Itab Name
                             fp_text TYPE any            " Display Text
                             fp_ddout TYPE any           " ALV filtering box length
                             fp_outlen TYPE any.         " Output length in ALV grid

  st_fieldcat_isohdetail-fieldname = fp_field.
  st_fieldcat_isohdetail-tabname   = fp_tab.
  st_fieldcat_isohdetail-coltext   = fp_text.
  st_fieldcat_isohdetail-lowercase = abap_true.
  st_fieldcat_isohdetail-dd_outlen = fp_ddout.
  st_fieldcat_isohdetail-outputlen = fp_outlen.
  st_fieldcat_isohdetail-decimals_o = text-100.

  APPEND st_fieldcat_isohdetail TO i_fieldcat_isohdetail.
  CLEAR st_fieldcat_isohdetail.

ENDFORM.

MODULE isoh_detail_data OUTPUT.

  IF v_detail_cc_isohdetail IS NOT BOUND.

    CREATE OBJECT v_detail_cc_isohdetail                       " Create object for Initial SOH detail custom container
      EXPORTING
        container_name              = v_detail_con_isohdetail
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

  CHECK v_detail_cc_isohdetail IS BOUND.

  CREATE OBJECT v_detail_grid                                 " Create object for Grid
    EXPORTING
      i_parent          = v_detail_cc_isohdetail
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK v_detail_grid IS BOUND.

  CALL METHOD v_detail_grid->set_table_for_first_display        " Display data to output
    EXPORTING
      i_save                        = 'A'
      i_default                     = c_x    " Default Display Variant
      is_layout                     = st_layout
    CHANGING
      it_outtab                     = i_view_isohdetail
      it_fieldcatalog               = i_fieldcat_isohdetail
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMODULE.

FORM f_build_fieldcat_jrrdetail .

  CLEAR : st_fieldcat_jrrdetail,i_fieldcat_jrrdetail.

  PERFORM f_build_fcat_jrrdetail USING :  'MEDIA_ISSUE' 'I_VIEW_JRRDETAIL' text-006 '18' '18',
                                          'ADUSTMENT_TYPE' 'I_VIEW_JRRDETAIL' text-021 '30' '15',   " Added with ED2K916608
                                          'JRR_QUANTITY' 'I_VIEW_JRRDETAIL' text-088 '' '',
                                          'ORDERED_PRINT_RUN' 'I_VIEW_JRRDETAIL' text-099 '' '',    " Added with ED2K916608
                                          'ACT_PUBLICATION_DATE' 'I_VIEW_JRRDETAIL' text-046 '' ''.

ENDFORM.

FORM f_build_fcat_jrrdetail USING fp_field TYPE any     " Field Name
                             fp_tab TYPE any            " Itab Name
                             fp_text TYPE any           " Display Text
                             fp_ddout TYPE any          " ALV filtering box length
                             fp_outlen TYPE any.        " Output length in ALV grid

  st_fieldcat_jrrdetail-fieldname = fp_field.
  st_fieldcat_jrrdetail-tabname   = fp_tab.
  st_fieldcat_jrrdetail-coltext   = fp_text.
  st_fieldcat_jrrdetail-lowercase = abap_true.
  st_fieldcat_jrrdetail-dd_outlen = fp_ddout.
  st_fieldcat_jrrdetail-outputlen = fp_outlen.
  st_fieldcat_jrrdetail-decimals_o = text-100.

  APPEND st_fieldcat_jrrdetail TO i_fieldcat_jrrdetail.
  CLEAR st_fieldcat_jrrdetail.

ENDFORM.

MODULE jrr_detail_data OUTPUT.

  IF v_detail_cc_jrrdetail IS NOT BOUND.

    CREATE OBJECT v_detail_cc_jrrdetail                       " Create object for JRR detail custom container
      EXPORTING
        container_name              = v_detail_con_jrrdetail
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

  CHECK v_detail_cc_jrrdetail IS BOUND.

  CREATE OBJECT v_detail_grid                                 " Create object for Grid
    EXPORTING
      i_parent          = v_detail_cc_jrrdetail
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK v_detail_grid IS BOUND.

  CALL METHOD v_detail_grid->set_table_for_first_display        " Display data to output
    EXPORTING
      i_save                        = 'A'
      i_default                     = c_x    " Default Display Variant
      is_layout                     = st_layout
    CHANGING
      it_outtab                     = i_view_jrrdetail
      it_fieldcatalog               = i_fieldcat_jrrdetail
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMODULE.

" End of changes for ED2K916403

FORM f_build_fieldcat_prdisdetail .

  CLEAR : st_fieldcat_prdisdetail,i_fieldcat_prdisdetail.

  PERFORM f_build_fcat_prdispatch USING :  'MEDIA_ISSUE' 'I_VIEW_PRINTEDIS' text-006 '18' '18',
                                           'ACT_PUB_DATE' 'I_VIEW_PRINTEDIS' text-101 '' '',
                                           'PO_QTY' 'I_VIEW_PRINTEDIS' text-102 '' '',
                                           'JRR_QTY' 'I_VIEW_PRINTEDIS' text-103 '' '',    " Added with ED2K916608
                                           'PO_DISPATCH' 'I_VIEW_PRINTEDIS' text-104 '' ''.
ENDFORM.

FORM f_build_fcat_prdispatch USING fp_field TYPE any      " Field Name
                                   fp_tab TYPE any        " Itab Name
                                   fp_text TYPE any       " Display Text
                                   fp_ddout TYPE any      " ALV filtering box length
                                   fp_outlen TYPE any.    " Output length in ALV grid

  st_fieldcat_prdisdetail-fieldname = fp_field.
  st_fieldcat_prdisdetail-tabname   = fp_tab.
  st_fieldcat_prdisdetail-coltext   = fp_text.
  st_fieldcat_prdisdetail-lowercase = abap_true.
  st_fieldcat_prdisdetail-dd_outlen = fp_ddout.
  st_fieldcat_prdisdetail-outputlen = fp_outlen.
  st_fieldcat_prdisdetail-decimals_o = text-100.

  APPEND st_fieldcat_prdisdetail TO i_fieldcat_prdisdetail.
  CLEAR st_fieldcat_prdisdetail.

ENDFORM.

MODULE prdispath_data OUTPUT.

  IF v_detail_cc_prdispatch IS NOT BOUND.

    CREATE OBJECT v_detail_cc_prdispatch                       " Create object for JRR detail custom container
      EXPORTING
        container_name              = v_detail_con_prdispatch
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

  CHECK v_detail_cc_prdispatch IS BOUND.

  CREATE OBJECT v_detail_grid                                 " Create object for Grid
    EXPORTING
      i_parent          = v_detail_cc_prdispatch
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK v_detail_grid IS BOUND.

  CALL METHOD v_detail_grid->set_table_for_first_display        " Display data to output
    EXPORTING
      i_save                        = 'A'
      i_default                     = c_x    " Default Display Variant
      is_layout                     = st_layout
    CHANGING
      it_outtab                     = i_view_printedis
      it_fieldcatalog               = i_fieldcat_prdisdetail
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMODULE.
