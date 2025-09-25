*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_CUSTOMER_IB_INTERFACE
* PROGRAM DESCRIPTION: Create BP with Comapny Code data,Sales Data,
*                      Collection & Credit management data
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE: 09/07/2019
* OBJECT ID: I0368
* TRANSPORT NUMBER(S):ED2K916061
* Note : This FM is copied from ZQTC_CUSTOMER_IB_INTERFACE_LH and modifed
*--* for the AGU requirment, Signature & comments have been kept as it is..
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*&---------------------------------------------------------------------*
FUNCTION zqtc_customer_ib_interface_agu.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_DATA) TYPE  ZTQTC_CUSTOMER_DATE_INPUTS
*"     VALUE(IM_SOURCE) TYPE  TPM_SOURCE_NAME OPTIONAL
*"     VALUE(IM_GUID) TYPE  IDOCCARKEY OPTIONAL
*"  EXPORTING
*"     VALUE(EX_RETURN) TYPE  ZTQTC_CUSTOMER_DATE_OUTPUTS
*"----------------------------------------------------------------------

*====================================================================*
* Local data
*====================================================================*
  DATA: li_ex_return TYPE ztqtc_customer_date_outputs,
        lst_ex_retrn TYPE zstqtc_customer_date_output.
*
  PERFORM f_initialize_global_vars.
  i_cust_input[] = im_data[].
  IF v_bp IS NOT INITIAL.
    v_partner = v_bp.
  ENDIF.
  v_source = im_source.
**--BOC-E225-BP rules addition 12/18/2019
  PERFORM f_get_bp_rules.
**--EOC E225 -Bp rules addition 12/18/2019
  LOOP AT i_cust_input ASSIGNING <st_cust_input>.
    st_cust_input = <st_cust_input>.
*--------------------------------------------------------------------*
*   General data* - Step 1
*--------------------------------------------------------------------*
*   Get General data
    v_index = v_index + 1.
    ASSIGN <st_cust_input>-general_data TO <st_gen_data>.
    IF st_create-gen_data IS NOT INITIAL.
      IF <st_gen_data> IS ASSIGNED.
        v_object_inst = st_create-gen_data.
        <st_gen_data>-gen_data-header-object_task = v_object_inst.

        IF v_object_inst = c_u. "Update Indicator.
          CLEAR: <st_gen_data>-gen_data-central_data-role.
        ENDIF. " IF v_object_inst = c_u
        st_add_general_data =  <st_gen_data>-add_gen_data.
*====================================================================*
*  Create Customer from General Data
*====================================================================*
        PERFORM f_cust_crt_gen_data CHANGING v_partner
                                             ex_return.

      ENDIF.
    ENDIF.
*====================================================================*
*    Get Company Code details & Sales Data details for Customer Data - Step 2
*====================================================================*
    IF v_partner IS NOT INITIAL.
      IF st_create-comp_data IS NOT INITIAL OR st_create-sales_data IS NOT INITIAL. .
        ASSIGN <st_cust_input>-comp_code_data TO <st_comp_code_data>.
        ASSIGN <st_cust_input>-sales_data     TO <st_sales_data>.

        CLEAR: i_comp_data,i_sales_data.
        IF <st_comp_code_data> IS ASSIGNED.
          i_comp_data[]  = <st_comp_code_data>-comp_codes[].
        ENDIF. " IF <st_comp_code_data> IS ASSIGNED
        IF <st_sales_data> IS ASSIGNED.
          i_sales_data[] = <st_sales_data>-sales_datas[].
          gt_sales_data[] = i_sales_data[].
        ENDIF. " IF <st_sales_data> IS ASSIGNED
*====================================================================*
*    Company Codes & Sales data Update
*====================================================================*
        i_sales_data[] = gt_sales_data[].
        IF i_sales_data[] IS NOT INITIAL.
          PERFORM f_upd_comp_sales_det USING v_log_handle
                                             v_partner
                                             st_add_general_data
                                             i_comp_data
                                             i_sales_data
                                             v_dummy
                                       CHANGING
                                             st_error
                                             st_master_data
                                             ex_return.
        ENDIF.
      ENDIF.
      IF v_partner IS NOT INITIAL.
*====================================================================*
*     Update Credit / Collection Segment to Customers - Step 3
*====================================================================*
        CLEAR: st_crdt_coll_data,st_data_key.

        IF <st_cust_input>-crdt_coll_data IS NOT INITIAL.
          st_crdt_coll_data = <st_cust_input>-crdt_coll_data.
        ENDIF. " IF <st_cust_input>-crdt_coll_data IS NOT INITIAL

        CLEAR:i_crdt_seg,i_coll_seg.

        i_crdt_seg     = st_crdt_coll_data-credit_data-credit_segment[].
        i_coll_seg     = st_crdt_coll_data-collection_data-coll_segment[].

*====================================================================*
*    Check if the Partner has been reflected in KNA1 table
*====================================================================*
        PERFORM f_chk_kna1 USING    v_partner
                           CHANGING v_partner_exists.

        IF v_partner_exists EQ abap_true AND <st_gen_data> IS ASSIGNED..
          CLEAR: i_address_data,st_person,st_org.

          i_address_data = <st_gen_data>-gen_data-central_data-address-addresses[].
          st_person      = <st_gen_data>-gen_data-central_data-common-data-bp_person.
          st_org         = <st_gen_data>-gen_data-central_data-common-data-bp_organization.

*====================================================================*
*    Update Credit / Collection Segment
*====================================================================*
          IF <st_cust_input>-data_key IS NOT INITIAL.
            st_data_key             = <st_cust_input>-data_key.
            st_data_key-partner     = v_partner.
          ELSE. " ELSE -> IF <st_cust_input>-data_key IS NOT INITIAL
            st_data_key-partner     = v_partner.
            st_data_key-id_category = <st_gen_data>-gen_data-header-object_instance-identificationcategory.
            st_data_key-id_number   = <st_gen_data>-gen_data-header-object_instance-identificationnumber.
          ENDIF. " IF <st_cust_input>-data_key IS NOT INITIAL
          IF i_crdt_seg[] IS NOT INITIAL OR i_coll_seg[] IS NOT INITIAL.
            PERFORM f_upd_crdt_coll_data   USING v_log_handle
                                                 v_partner
                                                 i_crdt_seg
                                                 i_coll_seg
                                                 st_data_key
                                                 st_crdt_coll_data
                                                 v_dummy
                                        CHANGING i_coll_return
                                                 ex_return.
          ELSE.
            PERFORM f_build_crd_coll_log.
          ENDIF.
*====================================================================*
*    Get the partner Details for Relationship Data  - Step 4
*====================================================================*
          IF st_create-relation = abap_true.
            ASSIGN <st_cust_input>-relationship_data TO <st_relationship_data>.

            IF <st_relationship_data> IS ASSIGNED.
              CLEAR i_relationship_data.
              i_relationship_data[] = <st_relationship_data>-relationships[].

            ENDIF. " IF <st_relationship_data> IS ASSIGNED
*====================================================================*
*  Update the Relationship data to Application Log- Input/Update/output
*====================================================================*
            PERFORM f_upd_relat_status         USING   v_log_handle
                                                       v_partner
                                                       i_relationship_data
                                                       i_partner_det
                                                       i_relat_but0id
                                                       v_dummy
                                            CHANGING   ex_return.

          ENDIF. "IF st_create-relation = abap_true.
        ENDIF. " IF v_partner_exists EQ abap_true
      ENDIF. " IF v_partner IS NOT INITIAL
    ENDIF.
*====================================================================*
*   Returning
*====================================================================*
  ENDLOOP. " LOOP AT i_cust_input ASSIGNING <st_cust_input>

ENDFUNCTION.
