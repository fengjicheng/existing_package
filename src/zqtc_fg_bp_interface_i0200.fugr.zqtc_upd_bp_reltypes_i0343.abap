FUNCTION zqtc_upd_bp_reltypes_i0343.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IT_RELATIONSHIPS) TYPE  FSBP_BAPI_RELATIONS_TTY
*"     VALUE(IM_IDOC_NUM) TYPE  EDI_DOCNUM OPTIONAL
*"     VALUE(IM_VBELN) TYPE  VBELN OPTIONAL
*"----------------------------------------------------------------------

* Local data declarations
  DATA: li_data   TYPE burs_ei_extern_t, " Complex External Interface of Relationships (Tab.)
        lst_data  TYPE burs_ei_extern,   " Complex External Interface of a Relationship
        li_return TYPE bapiretm.

* Build the relationships table (li_data) to be updated
  LOOP AT it_relationships ASSIGNING FIELD-SYMBOL(<lst_relations>).
    lst_data-header-object_instance-partner1-bpartner = <lst_relations>-partner1.
    lst_data-header-object_instance-partner2-bpartner = <lst_relations>-partner2.
    lst_data-header-object_instance-relat_category = <lst_relations>-relationshipcategory.
    lst_data-central_data-main-data-date_from = <lst_relations>-validfromdate.
    IF <lst_relations>-relationshiptype = c_m.
      lst_data-central_data-main-data-date_to_new = <lst_relations>-validuntildate.
      lst_data-central_data-main-datax-date_to_new = abap_true.
    ELSE.
      lst_data-header-object_instance-date_to = <lst_relations>-validuntildate.
    ENDIF.
    lst_data-header-object_task = c_m.
    lst_data-central_data-main-datax-date_from = abap_true.
    APPEND lst_data TO li_data.
    CLEAR lst_data.
  ENDLOOP.

  IF li_data[] IS NOT INITIAL.
* Function call to update the student member Reletionship Category
* that is sent via Inbound Renewal
    CALL FUNCTION 'BUPA_INBOUND_REL_SAVE'
      EXPORTING
        data   = li_data
      IMPORTING
        return = li_return.
    IF sy-subrc <> 0.
      " Nothing to do
    ENDIF.
  ENDIF.


ENDFUNCTION.
