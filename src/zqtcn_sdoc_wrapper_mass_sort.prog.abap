*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SDOC_WRAPPER_MASS_SORT
*&---------------------------------------------------------------------*
  DATA : lo_table      TYPE REF TO cl_abap_tabledescr,
         lo_struc      TYPE REF TO cl_abap_structdescr,
         li_components TYPE abap_component_tab,
         ls_component  TYPE abap_componentdescr,
         li_otab       TYPE abap_sortorder_tab,
         ls_otab       TYPE abap_sortorder.

  FREE:ls_otab,li_otab,li_components,ls_component .
  lo_table ?= cl_abap_typedescr=>describe_by_data( ct_result ). "get the dynamic table
  lo_struc ?= lo_table->get_table_line_type( ).  " get the dynamic table - struture fields

  li_components = lo_struc->get_components( ). " fields components
  LOOP AT li_components INTO ls_component .
    CLEAR ls_otab .
    IF   ls_component-name = 'VBELN'     " selected fields for sorting
      OR ls_component-name = 'POSNR'.
      ls_otab-name       = ls_component-name .
      APPEND ls_otab TO li_otab .
    ENDIF.
  ENDLOOP.
  IF li_otab IS NOT INITIAL.
    SORT ct_result BY (li_otab) .  " sort the selecte fields
  ENDIF.
