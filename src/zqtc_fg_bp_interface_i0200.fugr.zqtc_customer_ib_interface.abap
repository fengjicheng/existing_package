*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_CUSTOMER_IB_INTERFACE
* PROGRAM DESCRIPTION: Create BP with Comapny Code data,Sales Data,
*                      Collection & Credit management data
* DEVELOPER: Cheenangshuk Das (CHDAS)
* CREATION DATE: 09/26/2016
* OBJECT ID: I0200
* TRANSPORT NUMBER(S): ED1K903988
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K907286
* REFERENCE NO:  ERP-3117
* DEVELOPER:     Writtick Roy (WROY)
* DATE:          14-Jul-2017
* DESCRIPTION:
* 1. Provide option for multiple dummy Customers (if one is locked, use
*    the other)
* 2. RFC should not send blank response - Status messages should always
*    be populated
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K909065
* REFERENCE NO:  CR#697
* DEVELOPER:     Writtick Roy (WROY)
* DATE:          20-Oct-2017
* DESCRIPTION:
* 1. Update Valid-To Date of BP Relationships
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K911506
* REFERENCE NO:  ERP-7078, ERP-6095, ERP-7136
* DEVELOPER:     Siva Guda
* DATE:          21-March-2018
* DESCRIPTION:
* 1) Created a custom table ZQTC_EXT_IDENT
* 2) Update the logic accordingly
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K911678
* REFERENCE NO:  ERP-7078
* DEVELOPER:     Dinakar T/SIVA GUDA
* DATE:          29-March-2018
* DESCRIPTION: Process the request even if SoldTo is locked.
"change error to warning
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K912715
* REFERENCE NO:  ERP - 6309
* DEVELOPER:     Randheer
* DATE:          20-July-2018
* DESCRIPTION:   Changes in BP
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K913240
* REFERENCE NO:  ERP-7751
* DEVELOPER:     Kiran Kumar Ravuri (KKRAVURI/KKR)
* DATE:          27-Sep-2018
* DESCRIPTION:   BP Relationships Validation & SLG Logs fine tune
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K914283
* REFERENCE NO:  ERP-7825
* DEVELOPER:     Kiran Kumar Ravuri (KKRAVURI/KKR)
* DATE:          23-Jan-2019
* DESCRIPTION:   Ignore Language update while updating the BP
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K921317
* REFERENCE NO: FMM406
* DEVELOPER:MIMMADISET
* DATE: 01/19/2021
* DESCRIPTION:Validation for KNA1-KATR9 field
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED2K924504
* REFERENCE NO: FMM5986,FMM8
* DEVELOPER:MIMMADISET
* DATE: 09/09/2021
* DESCRIPTION: Removed the TR ED2K921317 changes,Added the
* TLINE companycode will be considered as primary company
* code for deriving the Credit/Collection/Dunning fields later in E191 program
* using path IM_DATA->GENERAL_DATA->ADD_GEN_DATA->TEXT->TEXTS-->DATA-->TLINE
*----------------------------------------------------------------------*
FUNCTION zqtc_customer_ib_interface.
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
  DATA: lv_seq_id         TYPE numc4, " Count parameters
        li_ex_return      TYPE ztqtc_customer_date_outputs,
        lv_actv_flag_e165 TYPE zactive_flag,  " ADD:ERP-7751:KKRAVURI:04-OCT-2018:ED2K913526
* Begin of ADD:ERP-3117:WROY:14-JUL-2017:ED2K907286
        lst_ex_retrn      TYPE zstqtc_customer_date_output.
* End   of ADD:ERP-3117:WROY:14-JUL-2017:ED2K907286

* Local constants
  CONSTANTS:
    lc_wricef_id_e165  TYPE zdevid    VALUE 'E165',              " Development ID
    lc_sno_e165_003    TYPE zsno      VALUE '003',               " Serial Number
    lc_var_key_e165    TYPE zvar_key  VALUE 'RELTYP_VALIDATION', " Variable Key
*** BOC: CR#7825  KKR20190123  ED2K914283
    lc_wricef_id_i0200 TYPE zdevid    VALUE 'I0200',             " Development ID
    lc_sno_i0200_001   TYPE zsno      VALUE '001',               " Serial Number
    lc_var_key_i0200   TYPE zvar_key  VALUE 'IGNORE_LANGU',      " Variable Key
*** EOC: CR#7825  KKR20190123  ED2K914283
*--*BOC ERPM-2276 Prabhu 11/12/2019
    lc_sno_i0200_002   TYPE zsno      VALUE '002',               " Serial Number
    lc_var_key_i0200_2 TYPE zvar_key  VALUE 'ERPM-2276',      " Variable Key
*--*EOC ERPM-2276 Prabhu 11/12/2019
**Begin of ADD:FMM5986:FMM8:MIMMADISET:09/09/2021: ED2K924504
    lc_katr9           TYPE zvar_key       VALUE 'KATR9',    " Attribute 9 in KNA1 field
    lc_sno3_i0200      TYPE zsno           VALUE '003'.       " Serial Number: 003
**End of ADD:FMM5986:FMM8:MIMMADISET:09/09/2021: ED2K924504
* BOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
*Fetch CONSTANTS from ZCONSTANT table
  PERFORM f_get_constant CHANGING li_constant.
* EOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471

*** BOC: CR#7751 KKRAVURI20181004  ED2K913526
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e165
      im_ser_num     = lc_sno_e165_003
      im_var_key     = lc_var_key_e165
    IMPORTING
      ex_active_flag = lv_actv_flag_e165.
*** EOC: CR#7751 KKRAVURI20181004  ED2K913526
*** BOC: CR#7825  KKR20190123  ED2K914283
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0200
      im_ser_num     = lc_sno_i0200_001
      im_var_key     = lc_var_key_i0200
    IMPORTING
      ex_active_flag = v_actv_flag_i0200.
*** EOC: CR#7825  KKR20190123  ED2K914283
*--*BOC ERPM-2276 Prabhu 11/12/2019
* To check enhancement is active or not
  CLEAR  : v_actv_flag_i0200_2.
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0200
      im_ser_num     = lc_sno_i0200_002
      im_var_key     = lc_var_key_i0200_2
    IMPORTING
      ex_active_flag = v_actv_flag_i0200_2.
*--*EOC ERPM-2276 Prabhu 11/12/2019
**Begin of ADD:FMM5986:FMM8:MIMMADISET:09/09/2021: ED2K924504
* To check enhancement is active or not for MKO changes
  CLEAR: v_actv_mko_i0200.
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0200        " Development ID: I0200
      im_ser_num     = lc_sno3_i0200             " Serial Number3: I0200
      im_var_key     = lc_katr9
    IMPORTING
      ex_active_flag = v_actv_mko_i0200.         " Active / Inactive Flag
*End of ADD:FMM5986:FMM8:MIMMADISET:09/09/2021: ED2K924504
  IF gv_support_mode IS NOT INITIAL.
    DO.
      BREAK-POINT.
    ENDDO.
  ENDIF.

  PERFORM f_initialize_global_vars.

  CLEAR i_cust_input.
  i_cust_input[] = im_data[].
  gv_guid        = im_guid. "ADD:ERP-6309:RKUMAR2:20-JULY-2017:ED2K912715

* Begin of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
  LOOP AT i_cust_input ASSIGNING <st_cust_input>.
    FREE gv_id_err.  "ADD:ERP-6309:RKUMAR2:20-JULY-2017:ED2K912715  "empty the flags before proceesng request.
*   Convert Business Partner Number from External to Internal Format
    IF <st_cust_input>-data_key-partner IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <st_cust_input>-data_key-partner                                       " Business Partner Number (External)
        IMPORTING
          output = <st_cust_input>-data_key-partner.                                      " Business Partner Number (Internal)
    ENDIF.
    IF <st_cust_input>-general_data-gen_data-header-object_instance-bpartner IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <st_cust_input>-general_data-gen_data-header-object_instance-bpartner  " Business Partner Number (External)
        IMPORTING
          output = <st_cust_input>-general_data-gen_data-header-object_instance-bpartner. " Business Partner Number (Internal)
    ENDIF.
  ENDLOOP.
* End   of ADD:CR#697:WROY:20-Oct-2017:ED2K909065

  PERFORM f_fetch_guid   USING    i_cust_input
                         CHANGING i_but000.
  PERFORM f_fetch_but0id USING    i_cust_input
                         CHANGING i_but000
                                  i_but0id.

  LOOP AT i_cust_input ASSIGNING <st_cust_input>.

    CLEAR lv_seq_id.
    lv_seq_id = <st_cust_input>-seq_id.

    v_index = v_index + 1.
    CLEAR st_cust_input.
    st_cust_input = <st_cust_input>.

    IF <st_gen_data> IS ASSIGNED.
      UNASSIGN <st_gen_data>.
    ENDIF. " IF <st_gen_data> IS ASSIGNED
*--------------------------------------------------------------------*
*   Check if the Partner number reference
*  (Partner Type & Partner Id number) is already existing in Sap
*--------------------------------------------------------------------*
* Begin of ADD:ERP-6309:RKUMAR2:20-JULY-2017:ED2K912715 RK20180819
    IF <st_cust_input>-data_key-partner IS NOT INITIAL.
      PERFORM f_validate_bp_status TABLES i_but000
                                   USING <st_cust_input>-data_key-partner
                                   CHANGING  ex_return.
    ENDIF.

    IF gv_id_err IS NOT INITIAL.
      "no use to process further
      CONTINUE.
    ENDIF.

    "source specific checks
    CASE im_source.
      WHEN c_req_source_cdm.
        PERFORM f_cdm_checks CHANGING <st_cust_input>
                                      i_but0id
                                      ex_return.
      WHEN OTHERS.
    ENDCASE.
*    IF  <st_cust_input>-data_key-id_category IS NOT INITIAL AND     "commented for for ERP-6309 RK20180819
*           <st_cust_input>-data_key-id_number   IS NOT INITIAL.
*      READ TABLE i_but0id
*      ASSIGNING <st_but0id>
*      WITH KEY type     = <st_cust_input>-data_key-id_category " With key of type
*               idnumber = <st_cust_input>-data_key-id_number
*               katr4    = <st_cust_input>-general_data-add_gen_data-central-data-katr4
*      BINARY SEARCH.
*      IF  sy-subrc    IS INITIAL
*      AND <st_but0id> IS ASSIGNED.
*        <st_cust_input>-data_key-partner = <st_but0id>-partner.
*        v_object_inst = c_u. "Update Indicator
*      ELSE. " ELSE -> IF sy-subrc IS INITIAL
*        v_object_inst = c_i. "Insert Indictor
*      ENDIF. " IF sy-subrc IS INITIAL
*    ENDIF. " IF <st_cust_input>-data_key-id_category IS NOT INITIAL AND

    IF gv_id_err IS NOT INITIAL.
      "no use to process further
      CONTINUE.
    ENDIF.
    "end of addition for ERP-6309 RK20180819

    IF <st_cust_input>-data_key-partner IS INITIAL.
      TRY.
          CALL METHOD cl_system_uuid=>if_system_uuid_static~create_uuid_c32
            RECEIVING
              uuid = <st_cust_input>-general_data-gen_data-header-object_instance-bpartnerguid.
        CATCH cx_uuid_error .
      ENDTRY.
      v_object_inst = c_i. "Insert Indictor
    ELSE. " ELSE -> IF <st_cust_input>-data_key-partner IS INITIAL
      v_object_inst = c_u. "Update Indicator
      PERFORM f_get_guid  USING    <st_cust_input>-data_key-partner
                          CHANGING <st_cust_input>-general_data-gen_data-header-object_instance-bpartnerguid.

    ENDIF. " IF <st_cust_input>-data_key-partner IS INITIAL

*   Get General data
    ASSIGN <st_cust_input>-general_data TO <st_gen_data>.

    IF <st_gen_data> IS ASSIGNED.
      <st_gen_data>-gen_data-header-object_task = v_object_inst.
      IF v_object_inst = c_u. "Update Indicator.
        CLEAR: <st_gen_data>-gen_data-central_data-role.
      ENDIF. " IF v_object_inst = c_u

*====================================================================*
*    Get Company Code details & Sales Data details for Customer Data
*====================================================================*
      ASSIGN <st_cust_input>-comp_code_data TO <st_comp_code_data>.
      ASSIGN <st_cust_input>-sales_data     TO <st_sales_data>.

      CLEAR: st_add_general_data,
             i_comp_data,
             i_sales_data.
      IF <st_comp_code_data> IS ASSIGNED.
        i_comp_data[]  = <st_comp_code_data>-comp_codes[].
      ENDIF. " IF <st_comp_code_data> IS ASSIGNED
      IF <st_sales_data> IS ASSIGNED.
        i_sales_data[] = <st_sales_data>-sales_datas[].
      ENDIF. " IF <st_sales_data> IS ASSIGNED
      st_add_general_data =  <st_gen_data>-add_gen_data.

*====================================================================*
*           Update Credit / Collection Segment to Customers
*====================================================================*
      CLEAR: st_crdt_coll_data,
             st_data_key.

      IF <st_cust_input>-crdt_coll_data IS NOT INITIAL.
        st_crdt_coll_data = <st_cust_input>-crdt_coll_data.
      ENDIF. " IF <st_cust_input>-crdt_coll_data IS NOT INITIAL

      CLEAR:i_crdt_seg,
            i_coll_seg.

      i_crdt_seg     = st_crdt_coll_data-credit_data-credit_segment[].
      i_coll_seg     = st_crdt_coll_data-collection_data-coll_segment[].

*====================================================================*
*    Get the partner Details for Relationship Data
*====================================================================*
      ASSIGN <st_cust_input>-relationship_data TO <st_relationship_data>.

      IF <st_relationship_data> IS ASSIGNED.
        CLEAR i_relationship_data.
        i_relationship_data[] = <st_relationship_data>-relationships[].

      ENDIF. " IF <st_relationship_data> IS ASSIGNED

      CLEAR st_relat.
      LOOP AT i_relationship_data INTO st_relat.
        IF st_relat-header-object_instance-partner2-bpartner IS INITIAL.
          st_partner_det-identificationcategory = st_relat-header-object_instance-partner2-identificationcategory.
          st_partner_det-identificationnumber   = st_relat-header-object_instance-partner2-identificationnumber.

          APPEND st_partner_det TO i_partner_det.
          CLEAR  st_partner_det.
        ENDIF. " IF st_relat-header-object_instance-partner2-bpartner IS INITIAL
      ENDLOOP. " LOOP AT i_relationship_data INTO st_relat

      SORT i_partner_det BY identificationcategory
                            identificationnumber.

      DELETE ADJACENT DUPLICATES FROM i_partner_det
      COMPARING identificationcategory
                identificationnumber.

      IF i_partner_det IS NOT INITIAL.
        CLEAR i_relat_but0id.
        SELECT partner         " Business Partner Number
               type            " Identification Type
               idnumber        " Identification Number
               FROM but0id     " BP: ID Numbers
               INNER JOIN kna1 " General Data in Customer Master
               ON kna1~kunnr EQ but0id~partner
               INTO TABLE i_relat_but0id
               FOR ALL ENTRIES IN i_partner_det
               WHERE type      EQ i_partner_det-identificationcategory
               AND   idnumber  EQ i_partner_det-identificationnumber
               AND   katr4     EQ c_katr4_loc.
        IF sy-subrc IS INITIAL.
          SORT i_relat_but0id
          BY   type
               idnumber.


        ENDIF. " IF sy-subrc IS INITIAL
      ENDIF. " IF i_partner_det IS NOT INITIAL
*====================================================================*
* Create the Application Log
*====================================================================*
      PERFORM f_log_create USING    im_guid
                                    st_cust_input
* BOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
                                    li_constant
* EOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
                           CHANGING v_log_handle.
*====================================================================*
*    Update message
*====================================================================*
      IF v_object_inst IS INITIAL.
        PERFORM f_populate_message_log USING    v_log_handle
                                                st_cust_input
                                       CHANGING ex_return.
        CONTINUE.
      ENDIF. " IF v_object_inst IS INITIAL
*====================================================================*
*  Validate Credit /Sales /Company Code data using Dummy Customer
*====================================================================*
      CLEAR: v_dummy.
      v_dummy = abap_true.
*     Begin of ADD:ERP-3117:WROY:14-JUL-2017:ED2K907286
      CLEAR: li_ex_return.
*     End   of ADD:ERP-3117:WROY:14-JUL-2017:ED2K907286
      PERFORM f_data_validation USING     v_log_handle
                                          st_add_general_data
                                          i_comp_data
                                          i_sales_data
                                          i_crdt_seg
                                          i_coll_seg
                                          st_data_key
                                          st_crdt_coll_data
                                          v_dummy
                                CHANGING  v_validation_success
                                          li_ex_return.
*** Begin of: CR#7751 KKR20180928  ED2K913240
      " source specific checks
      CASE im_source.
*       Begin of: CR#7006 KKR20181001  ED2K913240
        WHEN c_req_source_sfdc.
          v_source = c_req_source_sfdc.
*       End of:   CR#7006 KKR20181001  ED2K913240
        WHEN c_req_source_cdm.
          v_source = c_req_source_cdm.
          " Trigger Relationships validation
          IF lv_actv_flag_e165 EQ abap_true.
            PERFORM f_validate_relationship_data  USING st_cust_input
                                                        i_relationship_data
                                                        i_partner_det
                                                        i_relat_but0id
                                               CHANGING ex_return.
          ENDIF.

        WHEN c_req_source_pdmicrosites.
          v_source = c_req_source_pdmicrosites.
          " Trigger Relationships validation
          IF lv_actv_flag_e165 EQ abap_true.
            PERFORM f_validate_relationship_data  USING st_cust_input
                                                        i_relationship_data
                                                        i_partner_det
                                                        i_relat_but0id
                                               CHANGING ex_return.
          ENDIF.

        WHEN OTHERS.
          v_source = im_source.

      ENDCASE.

      IF gv_relationships_err = abap_true.
        CLEAR gv_relationships_err.
        CONTINUE.
      ENDIF.
*** End of: CR#7751 KKR20180928  ED2K913240

*====================================================================*
*  Create Customer from General Data
*====================================================================*
      IF v_validation_success EQ abap_true.

        CLEAR: v_dummy.
        v_dummy = abap_false.
* BOC by DTIRUKOOVA on 29-Mar-2018 for CR-7078 :ED2K911678
*        CLEAR: lv_result.
*        PERFORM f_bp_lock USING <st_cust_input>-data_key-partner
*                                v_log_handle
*                          CHANGING lv_result
*                                   ex_return.
*        IF lv_result EQ abap_false AND <st_cust_input>-data_key-partner IS NOT INITIAL.
*          PERFORM f_log_save USING v_log_handle.
*         RETURN.
*        ENDIF.
* EOC by DTIRUKOOVA on 29-Mar-2018 for CR-7078 :ED2K911678
        CLEAR v_partner.
        PERFORM f_cust_crt_gen_data CHANGING v_partner.

*====================================================================*
*  Update Customer Details to Exporting Parameter & Application Log
*====================================================================*
        PERFORM  f_pop_partner_info  USING    v_partner
                                              lv_seq_id
                                              <st_gen_data>-gen_data-header-object_instance-identificationnumber
                                              v_log_handle
                                              i_return
                                              v_object_inst
                                     CHANGING st_master_data
                                              ex_return.

        IF v_partner IS NOT INITIAL.
*====================================================================*
*    Check if the Partner has been reflected in KNA1 table
*====================================================================*
          PERFORM f_chk_kna1 USING    v_partner
                             CHANGING v_partner_exists.

          IF v_partner_exists EQ abap_true.

*====================================================================*
*    Create Input Application Log
*====================================================================*
            CLEAR: i_address_data,
                   st_person,
                   st_org.

            i_address_data = <st_gen_data>-gen_data-central_data-address-addresses[].
            st_person      = <st_gen_data>-gen_data-central_data-common-data-bp_person.
            st_org         = <st_gen_data>-gen_data-central_data-common-data-bp_organization.

            PERFORM f_create_app_log_for_input USING im_guid
                                                     im_source
                                                     i_address_data
                                                     st_cust_input
                                                     st_person
                                                     st_org
                                               CHANGING
                                                     v_log_handle.

*====================================================================*
*    Company Codes & Sales data Update
*====================================================================*
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

*====================================================================*
*    Update Credit / Collection Segment Input in Application Log
*====================================================================*
            IF <st_cust_input>-data_key IS NOT INITIAL.
              st_data_key             = <st_cust_input>-data_key.
              st_data_key-partner     = v_partner.
            ELSE. " ELSE -> IF <st_cust_input>-data_key IS NOT INITIAL
              st_data_key-partner     = v_partner.
              st_data_key-id_category = <st_gen_data>-gen_data-header-object_instance-identificationcategory.
              st_data_key-id_number   = <st_gen_data>-gen_data-header-object_instance-identificationnumber.
            ENDIF. " IF <st_cust_input>-data_key IS NOT INITIAL

            PERFORM f_upd_crdt_coll_data   USING v_log_handle
                                                 v_partner
                                                 i_crdt_seg
                                                 i_coll_seg
                                                 st_data_key
                                                 st_crdt_coll_data
                                                 v_dummy
                                        CHANGING i_coll_return
                                                 ex_return.
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



          ENDIF. " IF v_partner_exists EQ abap_true
        ENDIF. " IF v_partner IS NOT INITIAL
*     Begin of ADD:ERP-3117:WROY:14-JUL-2017:ED2K907286
      ELSE.
        lst_ex_retrn-seq_id = lv_seq_id.
        MODIFY li_ex_return FROM lst_ex_retrn TRANSPORTING seq_id
         WHERE seq_id IS INITIAL.
        APPEND LINES OF li_ex_return TO ex_return.
*     End   of ADD:ERP-3117:WROY:14-JUL-2017:ED2K907286
      ENDIF. " IF v_validation_success EQ abap_true

* BOC by DTIRUKOOVA on 29-Mar-2018 for CR-7078 :ED2K911678
*      IF lv_result EQ abap_true.
*        PERFORM f_bp_ublock USING <st_cust_input>-data_key-partner
*                                  v_log_handle
*                            CHANGING ex_return.
*      ENDIF.
*      CLEAR lv_result.
* EOC by DTIRUKOOVA on 29-Mar-2018 for CR-7078 :ED2K911678
*====================================================================*
*   Returning
*====================================================================*
*====================================================================*
*   Update the Message Body in the Application Log
*====================================================================*
*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
      PERFORM f_log_info_add USING v_log_handle
                                   i_log_info.
*** End of: CR#7751 KKR20180928  ED2K913240

*** Save the Application Log
      PERFORM f_log_save USING v_log_handle.

      CLEAR: i_log_info[], v_log_handle, v_source.
    ENDIF. " IF <st_gen_data> IS ASSIGNED
  ENDLOOP. " LOOP AT i_cust_input ASSIGNING <st_cust_input>

  CLEAR: v_index, lv_actv_flag_e165.

ENDFUNCTION.
