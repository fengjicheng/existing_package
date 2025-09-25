*&---------------------------------------------------------------------*
*&  Include           FZQTC_DEATILREPORT_ONN
*&---------------------------------------------------------------------*

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

ENDMODULE.

FORM f_build_fieldcat_podetail.

  CLEAR : st_fieldcat_podetail,i_fieldcat_podetail[].

  PERFORM f_build_fcat_podetail USING : 'MATERIAL' 'I_VIEW_PODETAIL' 'Material',
                                        'ACT_PUBLICATION_DATE' 'I_VIEW_PODETAIL' 'Act. Goods Arrival Date',
                                        'PO_TYPE' 'I_VIEW_PODETAIL' 'PO Type',
                                        'TRACKING_NO' 'I_VIEW_PODETAIL' 'TrackingNo',
                                        'PO_QTY' 'I_VIEW_PODETAIL' 'PO Quantity',
                                        'PO_NUMBER' 'I_VIEW_PODETAIL' 'Purch.Doc.',
                                        'ITEM' 'I_VIEW_PODETAIL' 'Item',
                                        'COMPANY_CODE' 'I_VIEW_PODETAIL' 'Co Cd',
                                        'CREATED_DATE' 'I_VIEW_PODETAIL' 'Created Date',
                                        'DOCUMENT_DATE' 'I_VIEW_PODETAIL' 'Document Date',
                                        'VENDOR' 'I_VIEW_PODETAIL' 'Vendor',
                                        'PLANT' 'I_VIEW_PODETAIL' 'Plnt',
                                        'ACCOUNT_ASSIGNMENT' 'I_VIEW_PODETAIL' 'Account Assignment',
                                        'CREATED_BY' 'I_VIEW_PODETAIL' 'Created By',
                                        'DELETION_INDICATOR' 'I_VIEW_PODETAIL' 'Deletion Indicator'.

ENDFORM.

FORM f_build_fcat_podetail USING fp_field TYPE any
                            fp_tab TYPE any
                            fp_text TYPE any.

  st_fieldcat_podetail-fieldname = fp_field.
  st_fieldcat_podetail-tabname   = fp_tab.
  st_fieldcat_podetail-coltext   = fp_text.

  APPEND st_fieldcat_podetail TO i_fieldcat_podetail.
  CLEAR st_fieldcat_podetail.

ENDFORM.

MODULE po_detail_data OUTPUT.

  IF v_detail_cc_podetail IS NOT BOUND.

    CREATE OBJECT v_detail_cc_podetail
      EXPORTING
        container_name              = v_detail_con_podetail
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
  ENDIF.

  CHECK v_detail_cc_podetail IS BOUND.

  CREATE OBJECT v_detail_grid
    EXPORTING
      i_parent          = v_detail_cc_podetail
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.

  CHECK v_detail_grid IS BOUND.

  CALL METHOD v_detail_grid->set_table_for_first_display
    EXPORTING
      i_save                        = 'A'
      i_default                     = 'X'    " Default Display Variant
      is_layout                     = st_layout
    CHANGING
      it_outtab                     = i_view_podetail
      it_fieldcatalog               = i_fieldcat_podetail
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.

ENDMODULE.

FORM f_build_fieldcat_biosdetail .

  CLEAR : st_fieldcat_biosdetail,i_fieldcat_biosdetail[].

  PERFORM f_build_fcat_biosdetail USING : 'MEDIA_ISSUE' 'I_VIEW_BIOSDETAIL' 'Material',
                                          'ADUSTMENT_TYPE' 'I_VIEW_BIOSDETAIL' 'Adjustment Type',
                                          'BIOS_QUANTITY' 'I_VIEW_BIOSDETAIL' 'BIOS Qty',
                                          'ACT_PUBLICATION_DATE' 'I_VIEW_BIOSDETAIL' 'Act. Goods Arrival Date'.

ENDFORM.

FORM f_build_fcat_biosdetail USING fp_field TYPE any
                            fp_tab TYPE any
                            fp_text TYPE any.

  st_fieldcat_biosdetail-fieldname = fp_field.
  st_fieldcat_biosdetail-tabname   = fp_tab.
  st_fieldcat_biosdetail-coltext   = fp_text.

  APPEND st_fieldcat_biosdetail TO i_fieldcat_biosdetail.
  CLEAR st_fieldcat_biosdetail.

ENDFORM.

MODULE bios_detail_data OUTPUT.

  IF v_detail_cc_biosdetail IS NOT BOUND.

    CREATE OBJECT v_detail_cc_biosdetail
      EXPORTING
        container_name              = v_detail_con_biosdetail
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
  ENDIF.

  CHECK v_detail_cc_biosdetail IS BOUND.

  CREATE OBJECT v_detail_grid
    EXPORTING
      i_parent          = v_detail_cc_biosdetail
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.

  CHECK v_detail_grid IS BOUND.

  CALL METHOD v_detail_grid->set_table_for_first_display
    EXPORTING
      i_save                        = 'A'
      i_default                     = 'X'    " Default Display Variant
      is_layout                     = st_layout
    CHANGING
      it_outtab                     = i_view_biosdetail
      it_fieldcatalog               = i_fieldcat_biosdetail
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.

ENDMODULE.

FORM f_build_fieldcat_jdrdetail.

  CLEAR : st_fieldcat_jdrdetail,i_fieldcat_jdrdetail[].

  PERFORM f_build_fcat_jdrdetail USING : 'MEDIA_ISSUE' 'I_VIEW_JDRDETAIL' 'Material',
                                         'JDR_QUANTITY' 'I_VIEW_JDRDETAIL' 'JDR Qty',
                                         'ACT_PUBLICATION_DATE' 'I_VIEW_JDRDETAIL' 'Act. Gds. Arvl Dt'.

ENDFORM.

FORM f_build_fcat_jdrdetail USING fp_field TYPE any
                            fp_tab TYPE any
                            fp_text TYPE any.

  st_fieldcat_jdrdetail-fieldname = fp_field.
  st_fieldcat_jdrdetail-tabname   = fp_tab.
  st_fieldcat_jdrdetail-coltext   = fp_text.

  APPEND st_fieldcat_jdrdetail TO i_fieldcat_jdrdetail.
  CLEAR st_fieldcat_jdrdetail.

ENDFORM.

MODULE jdr_detail_data OUTPUT.

  IF v_detail_cc_jdrdetail IS NOT BOUND.

    CREATE OBJECT v_detail_cc_jdrdetail
      EXPORTING
        container_name              = v_detail_con_jdrdetail
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
  ENDIF.

  CHECK v_detail_cc_jdrdetail IS BOUND.

  CREATE OBJECT v_detail_grid
    EXPORTING
      i_parent          = v_detail_cc_jdrdetail
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.

  CHECK v_detail_grid IS BOUND.

  CALL METHOD v_detail_grid->set_table_for_first_display
    EXPORTING
      i_save                        = 'A'
      i_default                     = 'X'    " Default Display Variant
      is_layout                     = st_layout
    CHANGING
      it_outtab                     = i_view_jdrdetail
      it_fieldcatalog               = i_fieldcat_jdrdetail
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.

ENDMODULE.

FORM f_build_fieldcat_salesdetail.

  CLEAR : st_fieldcat_salesdetail,i_fieldcat_salesdetail[].

  PERFORM f_build_fcat_salesdetail USING : 'MEDIA_ISSUE' 'I_VIEW_SALESDETAIL' 'Material',
                                           'DOCUMENT_TYPE' 'I_VIEW_SALESDETAIL' 'Sales Doc Type',
                                           'DOCUMENT_TYPE_DESC' 'I_VIEW_SALESDETAIL' 'SaTy',
                                           'ITEM_CATEGORY' 'I_VIEW_SALESDETAIL' 'ItCa',
                                           'TARGET_QTY' 'I_VIEW_SALESDETAIL' 'Order Quantity',
                                           'DOCUMENT_NUMBER' 'I_VIEW_SALESDETAIL' 'Sales Doc.',
                                           'ACT_PUB_DATE' 'I_VIEW_SALESDETAIL' 'Act. Gd. Arrval Dat',
                                           'ITEM' 'I_VIEW_SALESDETAIL' 'Item',
                                           'SU' 'I_VIEW_SALESDETAIL' 'SU',
                                           'REFERENCE_DOCUMENT' 'I_VIEW_SALESDETAIL' 'Ref.doc.',
                                           'REFERENCE_DOCUMENT_TYPE' 'I_VIEW_SALESDETAIL' 'Preceding Doc Category',
                                           'SUBS_SALES_ORDER' 'I_VIEW_SALESDETAIL' 'Subs/Sales Order',
                                           'REFITM' 'I_VIEW_SALESDETAIL' 'RefItm',
                                           'CONDITION_GROUP_4' 'I_VIEW_SALESDETAIL' 'CGr4',
                                           'FREE_NOT_FREE' 'I_VIEW_SALESDETAIL' 'CGr4 Generic Desc',
                                           'CREATED_DATE' 'I_VIEW_SALESDETAIL' 'Created on',
                                           'CREATED_BY' 'I_VIEW_SALESDETAIL' 'Created By',
                                           'SALES_ORGANIZATION' 'I_VIEW_SALESDETAIL' 'Sales Org',
                                           'MATERIAL_GRP_5' 'I_VIEW_SALESDETAIL' 'Material Group 5',
                                           'REJECTION_REASON' 'I_VIEW_SALESDETAIL' 'Reason for Rejection',
                                           'SCHEDULE_LINE_TYPE' 'I_VIEW_SALESDETAIL' 'Schedule Line Type'.

ENDFORM.

FORM f_build_fcat_salesdetail USING fp_field TYPE any
                            fp_tab TYPE any
                            fp_text TYPE any.

  st_fieldcat_salesdetail-fieldname = fp_field.
  st_fieldcat_salesdetail-tabname   = fp_tab.
  st_fieldcat_salesdetail-coltext   = fp_text.

  APPEND st_fieldcat_salesdetail TO i_fieldcat_salesdetail.
  CLEAR st_fieldcat_salesdetail.

ENDFORM.

MODULE sales_detail_data OUTPUT.

  IF v_detail_cc_salesdetail IS NOT BOUND.

    CREATE OBJECT v_detail_cc_salesdetail
      EXPORTING
        container_name              = v_detail_con_salesdetail
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
  ENDIF.

  CHECK v_detail_cc_salesdetail IS BOUND.

  CREATE OBJECT v_detail_grid
    EXPORTING
      i_parent          = v_detail_cc_salesdetail
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.

  CHECK v_detail_grid IS BOUND.

  CALL METHOD v_detail_grid->set_table_for_first_display
    EXPORTING
      i_save                        = 'A'
      i_default                     = 'X'    " Default Display Variant
      is_layout                     = st_layout
    CHANGING
      it_outtab                     = i_view_salesdetail
      it_fieldcatalog               = i_fieldcat_salesdetail
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.

ENDMODULE.

FORM f_build_fieldcat_sohdetail .

  CLEAR : st_fieldcat_sohdetail,i_fieldcat_sohdetail.

  PERFORM f_build_fcat_sohdetail USING : 'MEDIA_ISSUE' 'I_VIEW_SOHDETAIL' 'Material',
                                         'SOH_QTY' 'I_VIEW_SOHDETAIL' 'SOH Qty',
                                         'ACT_PUBLICATION_DATE' 'I_VIEW_SOHDETAIL' 'Act. Gds. Arvl Dt'.


ENDFORM.

FORM f_build_fcat_sohdetail USING fp_field TYPE any
                            fp_tab TYPE any
                            fp_text TYPE any.

  st_fieldcat_sohdetail-fieldname = fp_field.
  st_fieldcat_sohdetail-tabname   = fp_tab.
  st_fieldcat_sohdetail-coltext   = fp_text.

  APPEND st_fieldcat_sohdetail TO i_fieldcat_sohdetail.
  CLEAR st_fieldcat_sohdetail.

ENDFORM.

MODULE soh_detail_data OUTPUT.

  IF v_detail_cc_sohdetail IS NOT BOUND.

    CREATE OBJECT v_detail_cc_sohdetail
      EXPORTING
        container_name              = v_detail_con_sohdetail
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
  ENDIF.

  CHECK v_detail_cc_salesdetail IS BOUND.

  CREATE OBJECT v_detail_grid
    EXPORTING
      i_parent          = v_detail_cc_sohdetail
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.

  CHECK v_detail_grid IS BOUND.

  CALL METHOD v_detail_grid->set_table_for_first_display
    EXPORTING
      i_save                        = 'A'
      i_default                     = 'X'    " Default Display Variant
      is_layout                     = st_layout
    CHANGING
      it_outtab                     = i_view_sohdetail
      it_fieldcatalog               = i_fieldcat_sohdetail
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.

ENDMODULE.
