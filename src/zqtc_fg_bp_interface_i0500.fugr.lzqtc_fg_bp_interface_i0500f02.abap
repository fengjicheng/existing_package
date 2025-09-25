*----------------------------------------------------------------------*
***INCLUDE LZQTC_FG_BP_INTERFACE_I0500F02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CALL_BP_UPDATE_FM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_call_bp_update_fm CHANGING ex_return  TYPE ztqtc_customer_date_outputs.
*--calling BP creation RFC interface
  CALL FUNCTION 'ZQTC_CUSTOMER_IB_INTERFACE'
    EXPORTING
      im_data   = i_bp_input
      im_source = gv_source
      im_guid   = gv_guid
    IMPORTING
      ex_return = i_bp_return.
  APPEND LINES OF i_bp_return[] TO ex_return[].
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INPUT_BP_VALIDATIONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_input_bp_validations CHANGING ex_return  TYPE ztqtc_customer_date_outputs.
  CONSTANTS:lc_zdevch TYPE  bu_id_category VALUE 'ZDEVCH'.

  DATA : lv_cat          TYPE bapibus1006_identification_key-identificationcategory,
         lv_id           TYPE bapibus1006_identification_key-identificationnumber,
         li_partner      TYPE STANDARD TABLE OF bus_partner_guid,
         lst_partner     TYPE bus_partner_guid,
         li_return       TYPE STANDARD TABLE OF bapiret2,
         li_return_id    TYPE STANDARD TABLE OF bapiret2,
         lst_id          TYPE bapibus1006_identification,
         lv_zdevch_found TYPE c.

  REFRESH:li_return[],li_return_id[],li_partner[].
  CLEAR:lv_cat,lv_id,lst_partner,lst_id.

  IF st_bp_input-data_key-id_category IS NOT INITIAL
     AND st_bp_input-data_key-id_number IS NOT INITIAL.
    IF st_bp_input-data_key-id_number+0(1) = 'I'.
      gv_cat_flag = c_person.         "If ECID starts with I, it will be 1 (Individual)
    ELSEIF st_bp_input-data_key-id_number+0(1) = 'O'.
      gv_cat_flag = c_org.            "If ECID starts with O, it will be 2 (Org)
    ENDIF.
  ENDIF.
*"----------------------------------------------------------------------
*--*Check BP by ID number of the input file
*"----------------------------------------------------------------------
*  CLEAR lv_zmemid_found.
  lv_cat = lc_zdevch."st_bp_input-data_key-id_category.
  lv_id = st_bp_input-data_key-id_number.
  IF lv_id IS NOT INITIAL.
    CALL FUNCTION 'BUPA_PARTNER_GET_BY_IDNUMBER'
      EXPORTING
        iv_identificationcategory = lv_cat
        iv_identificationnumber   = lv_id
      TABLES
        t_partner_guid            = li_partner
        et_return                 = li_return.
    DESCRIBE TABLE li_partner LINES DATA(lv_lines).

*"----------------------------------------------------------------------
*--* if multiple BP's found raise an expection
*"----------------------------------------------------------------------
    IF lv_lines GE 1
      AND st_bp_input-data_key-partner IS INITIAL. "VMAMILLA|5/11/2022.
      gv_error = abap_true.
      gv_message = text-001.
      PERFORM f_log_error USING gv_message
                                'BP issue:'
                       CHANGING  ex_return.
*"----------------------------------------------------------------------
*--*If Unique BP found then required validations
*"----------------------------------------------------------------------
***  elsieIF li_partner IS NOT INITIAL AND lv_lines = 1.
***    CLEAR : lst_partner.
***    READ TABLE li_partner INTO lst_partner INDEX 1.
***    IF sy-subrc EQ 0.
***      gv_bp = lst_partner-partner.
***    ENDIF.
***    lv_zdevch_found = abap_true.v
    ELSE.
*"----------------------------------------------------------------------
*--*BP search with address parameters - Criteria 1
*"----------------------------------------------------------------------
*    PERFORM f_bp_search TABLES li_partner.
    ENDIF.

***  IF st_bp_input-general_data-gen_data-central_data-common-data-bp_organization-name1 IS INITIAL
***  AND gv_cat_flag = c_org.
***    gv_error = abap_true.
***    gv_message = 'Name 1 is mandatory for organization'.
***    PERFORM f_log_error USING gv_message
***                              'BP issue:'
***                     CHANGING  ex_return.
***  ENDIF.
****
*"----------------------------------------------------------------------
*--*Decide Operations to be peroformed
*"----------------------------------------------------------------------
*    IF st_bp_input-data_key-partner IS INITIAL. "VMAMILLA|5/11/2022
    IF st_bp_input-data_key-partner IS NOT INITIAL."VMAMILLA|5/11/2022
      st_create-gen_data = c_u.
      st_create-sales_data = c_u.
    ELSEIF li_partner IS INITIAL AND gv_error IS INITIAL.
      st_create-gen_data = c_i.
    ENDIF.
    IF st_create-gen_data = c_i.
      st_create-comp_data = abap_true.
      st_create-sales_data = abap_true.
      st_create-assign_bp = abap_true.
      st_create-relation = abap_true.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_ADD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_V_LOG_HANDLE  TYPE BALLOGHNDL
*      -->FP_LV_MSGV1      TYPE ANY
*      -->FP_LV_MSGV2      TYPE ANY
*      -->FP_LV_MSGV1      TYPE ANY
*----------------------------------------------------------------------*
FORM f_log_add  USING    fp_v_log_handle TYPE balloghndl " Application Log: Log Handle
                         fp_v_msgty      TYPE symsgty    " Message Type
                         fp_v_msgv1      TYPE any
                         fp_v_msgv2      TYPE any
                         fp_v_msgv3      TYPE any
                         fp_identifier   TYPE char10
                         fp_nodetype     TYPE char1.

*====================================================================*
* Local Structure( Work-Area)
*====================================================================*
  DATA:lst_message  TYPE bal_s_msg. "Application Log: Message Data
  DATA : lv_fval      TYPE int4,
         lv_ofset     TYPE int4,
         lv_mesg(100) TYPE c.
*====================================================================*
* Prepare the message
*====================================================================*
  lst_message-msgty  = fp_v_msgty. "Message Type
  lst_message-msgid  = c_msgid_zrtr. "Message Class - ZRTR_R1B
  lst_message-msgno  = c_msgno_000. "Message Number - 000
  lst_message-msgv1  = fp_v_msgv1. "Message Variable 1
  lst_message-msgv2  = fp_v_msgv2. "Message Variable 2
*  lst_message-msgv3  = fp_v_msgv3. "Message Variable 3
  IF fp_v_msgv3 IS NOT INITIAL.
* Split the mesg text into two variables if mesg length is more 50 chars
    lv_mesg = fp_v_msgv3.
    lv_fval = strlen( lv_mesg ).
    lst_message-msgv3  = lv_mesg+0(50).
    IF lv_fval GT 50.
      lv_ofset = lv_fval - 50.
      lst_message-msgv4  = lv_mesg+50(lv_ofset).
    ENDIF.

  ENDIF.
*====================================================================*
* Application Log: Log: Message: Add
*====================================================================*
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = fp_v_log_handle "Application Log: Log Handle
      i_s_msg          = lst_message     "Message
    EXCEPTIONS
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      OTHERS           = 4.
  IF sy-subrc NE 0.
*   Nothing to do
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_INPUT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_input_data .
  DATA:lt_text       TYPE STANDARD TABLE OF sotr_txt,
       li_sales      TYPE zstqtc_customer_date_input-sales_data-sales_datas,
       lst_sales     LIKE LINE OF li_sales,
       li_adr        TYPE bus_ei_bupa_address_t,
       li_phone      TYPE bus_ei_bupa_telephone_t,
       li_fax        TYPE bus_ei_bupa_fax_t,
       li_comp_codes TYPE zstqtc_customer_date_input-comp_code_data-comp_codes.
*"----------------------------------------------------------------------
*-----*General data mapping to BP structures
*"---------------------------------------------------------------------
*BOC VMAMILLAPA 5/11/2022
*  Def Id category ZDEVCH
  st_bp_input-data_key-id_category = gv_id_cat.
*  Search term 1
  IF st_bp_input-general_data-gen_data-central_data-common-data-bp_person-firstname IS NOT INITIAL.
    st_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-searchterm1
             =  st_bp_input-general_data-gen_data-central_data-common-data-bp_person-firstname.
  ELSEIF st_bp_input-general_data-gen_data-central_data-common-data-bp_organization-name1 IS NOT INITIAL.
    st_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-searchterm1
            =  st_bp_input-general_data-gen_data-central_data-common-data-bp_organization-name1.
  ENDIF.
* Search term 2
  li_adr =  st_bp_input-general_data-gen_data-central_data-address-addresses.
  LOOP AT li_adr INTO DATA(ls_adr) WHERE data-postal-data-postl_cod1 IS NOT INITIAL.
    st_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-searchterm2
    = ls_adr-data-postal-data-postl_cod1.
  ENDLOOP.
* Prefix phone number with country code
  li_phone = st_bp_input-general_data-gen_data-central_data-communication-phone-phone.
  li_fax = st_bp_input-general_data-gen_data-central_data-communication-fax-fax.
  LOOP AT li_phone ASSIGNING FIELD-SYMBOL(<lfs_phone>) WHERE contact-data-telephone IS NOT INITIAL.
    <lfs_phone>-contact-data-telephone = |{ gv_tf_prefix }| && |{ <lfs_phone>-contact-data-telephone }|.
  ENDLOOP.

  LOOP AT li_fax ASSIGNING FIELD-SYMBOL(<lfs_fax>) WHERE contact-data-fax IS NOT INITIAL.
    <lfs_fax>-contact-data-fax = |{ gv_tf_prefix }| && |{ <lfs_fax>-contact-data-fax }| .
  ENDLOOP.
  st_bp_input-general_data-gen_data-central_data-communication-phone-phone = li_phone.
  st_bp_input-general_data-gen_data-central_data-communication-fax-fax = li_fax.
*EOC VMAMILLAPA 5/11/2022
  IF st_create-gen_data = c_i.
    st_bp_input-general_data-gen_data-central_data-common-data-bp_control-category = gv_cat_flag.
*--* KATR6
    IF gv_zca_katr6 IS NOT INITIAL.
      st_bp_input-general_data-add_gen_data-central-data-katr6  =  gv_zca_katr6.
      st_bp_input-general_data-add_gen_data-central-datax-katr6 =  abap_true.
    ENDIF.
*----*Begin of the logic Name 1,2,3,4 of organization
****      DATA(lv_longtext) = st_bp_input-general_data-gen_data-central_data-common-data-bp_organization-name1
****       && st_bp_input-general_data-gen_data-central_data-common-data-bp_organization-name2
****       && st_bp_input-general_data-gen_data-central_data-common-data-bp_organization-name3
****       && st_bp_input-general_data-gen_data-central_data-common-data-bp_organization-name4.
****      IF lv_longtext IS NOT INITIAL.
****        CALL FUNCTION 'SOTR_SERV_STRING_TO_TABLE'
****          EXPORTING
****            text        = lv_longtext
****            line_length = '35'
****            langu       = sy-langu
****          TABLES
****            text_tab    = lt_text.
****        IF lt_text IS NOT INITIAL.
****          st_bp_input-general_data-gen_data-central_data-common-data-bp_organization-name1 = VALUE #( lt_text[ 1 ] OPTIONAL ).
****          st_bp_input-general_data-gen_data-central_data-common-data-bp_organization-name2 = VALUE #( lt_text[ 2 ] OPTIONAL ).
****          st_bp_input-general_data-gen_data-central_data-common-data-bp_organization-name3 = VALUE #( lt_text[ 3 ] OPTIONAL ).
****          st_bp_input-general_data-gen_data-central_data-common-data-bp_organization-name4 = VALUE #( lt_text[ 4 ] OPTIONAL ).
****        ENDIF.
****      ENDIF.
****      CLEAR:lv_longtext,lt_text[].
*----*End of the logic Name 1,2,3,4 of organization
*"----------------------------------------------------------------------
*---Begin of logic BP Roles - defaults
*"----------------------------------------------------------------------
    LOOP AT lir_rel_type INTO lsr_rel_type.
      lst_role-data_key          = lsr_rel_type-sap_value.
      lst_role-data-rolecategory = lsr_rel_type-sap_value.
      lst_role-data-valid_from   = sy-datum.
      lst_role-data-valid_to     = gv_zca_valid.
      lst_role-datax-valid_from  = abap_true.
      lst_role-datax-valid_to    = abap_true.
      APPEND lst_role TO li_role.
      CLEAR lst_role.
    ENDLOOP.
    IF li_role[] IS NOT INITIAL.
      st_bp_input-general_data-gen_data-central_data-role-roles[] = li_role[].
      CLEAR: li_role[].
    ENDIF.
*--End of logic BP Roles - defaults
    st_bp_input-general_data-gen_data-central_data-common-data-bp_control-grouping = c_bp_group.
    "----------------------------------------------------------------------
*---*Company code extension data mapping
*"----------------------------------------------------------------------
    IF st_create-comp_data IS NOT INITIAL AND gv_zca_bukrs IS NOT INITIAL.
      IF st_bp_input-comp_code_data-comp_codes[] IS INITIAL.
        PERFORM f_map_company_code CHANGING li_comp_codes.
        IF li_comp_codes[] IS NOT INITIAL.
          APPEND LINES OF li_comp_codes[] TO st_bp_input-comp_code_data-comp_codes[].
          CLEAR : li_comp_codes[].
        ENDIF.
      ENDIF.
    ENDIF.
*---*End Company code extension data mapping
    "----------------------------------------------------------------------
*---Begin of Sales & distribition Extension mapping
*"----------------------------------------------------------------------
    IF st_create-sales_data IS NOT INITIAL AND lsr_zca_val-vkorg IS NOT INITIAL.
      IF st_bp_input-sales_data-sales_datas[] IS INITIAL.
        PERFORM f_map_sales_data CHANGING li_sales.
        IF li_sales[] IS NOT INITIAL.
          st_bp_input-sales_data-sales_datas[] = li_sales[].
          CLEAR : li_sales[].
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
*---End of Sales & distribition Extension mapping
  IF st_bp_input IS NOT INITIAL.
    APPEND st_bp_input TO i_bp_input.
    CLEAR st_bp_input.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_SALES_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LI_SALES  text
*----------------------------------------------------------------------*
FORM f_map_sales_data  CHANGING fp_li_sales TYPE zstqtc_customer_date_input-sales_data-sales_datas.
  CONSTANTS:lc_hypen TYPE char01 VALUE '-',
            lc_knvv  TYPE rvari_vnam VALUE 'KNVV'.


  DATA:lst_sales  TYPE cmds_ei_sales_data,
       lst_salesx TYPE cmds_ei_sales_datax,
       ls_sal_det LIKE LINE OF fp_li_sales.

  ls_sal_det-data_key-vkorg = lsr_zca_val-vkorg.
  ls_sal_det-data_key-spart = lsr_zca_val-spart.
  ls_sal_det-data_key-vtweg = lsr_zca_val-vtweg.

  LOOP AT i_constant INTO DATA(lst_const) WHERE param1 CS lc_knvv.
    IF lst_const-param1 CA lc_hypen.
      SPLIT lst_const-param1 AT lc_hypen INTO DATA(lv_tab) DATA(lv_field).
    ELSE.
      CLEAR lv_field.
      CONTINUE.
    ENDIF.
    TRY.
        ASSIGN COMPONENT lv_field OF STRUCTURE lst_sales TO FIELD-SYMBOL(<lst_knvv_val>).
        IF <lst_knvv_val> IS ASSIGNED.
          ASSIGN COMPONENT lv_field OF STRUCTURE lst_salesx TO FIELD-SYMBOL(<lst_knvv_valx>).
          IF lst_const-legacy_value IS NOT INITIAL. "1 Person 2 org
            IF gv_country = lst_const-legacy_value.
              <lst_knvv_val> = lst_const-sap_value.
              IF <lst_knvv_valx> IS ASSIGNED.
                <lst_knvv_valx>  = abap_true.
              ENDIF.
            ELSEIF gv_cat_flag = lst_const-legacy_value.
              <lst_knvv_val> = lst_const-sap_value.
              IF <lst_knvv_valx> IS ASSIGNED.
                <lst_knvv_valx>  = abap_true.
              ENDIF.
            ENDIF.
          ELSE.
            <lst_knvv_val> = lst_const-sap_value.
            IF <lst_knvv_valx> IS ASSIGNED.
              <lst_knvv_valx>  = abap_true.
            ENDIF.
          ENDIF.
        ENDIF.
      CATCH cx_sy_assign_cast_error.
    ENDTRY.
    IF <lst_knvv_val> IS ASSIGNED.
      UNASSIGN <lst_knvv_val>.
    ENDIF.
    IF <lst_knvv_valx> IS ASSIGNED.
      UNASSIGN <lst_knvv_valx>.
    ENDIF.
    CLEAR lv_field.
  ENDLOOP.
  IF lst_sales IS NOT INITIAL.
    ls_sal_det-data = lst_sales.
    ls_sal_det-datax = lst_salesx.
    APPEND ls_sal_det TO fp_li_sales.
    CLEAR : lst_sales,lst_salesx,ls_sal_det.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_COMPANY_CODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LI_COMP_CODE  text
*----------------------------------------------------------------------*
FORM f_map_company_code  CHANGING f_li_comp_codes TYPE zstqtc_customer_date_input-comp_code_data-comp_codes.
*  Locat Constants.
  DATA:lc_comp_code TYPE rvari_vnam VALUE 'COMP_CODE'.
*  Locat Structures & Variables
  DATA:lst_comp_codes LIKE LINE OF f_li_comp_codes,
       ls_comp_data   TYPE cmds_ei_company_data,
       ls_comp_datax  TYPE cmds_ei_company_data.

  IF st_create-comp_data IS NOT INITIAL.
    lst_comp_codes-data_key-bukrs = gv_zca_bukrs.
    LOOP AT i_constant INTO DATA(lst_const) WHERE param2 EQ lc_comp_code.
      DATA(lv_field) = lst_const-param1.
      TRY.
          ASSIGN COMPONENT lv_field OF STRUCTURE ls_comp_data TO FIELD-SYMBOL(<lst_comp_val>).
          IF <lst_comp_val> IS ASSIGNED.
            ASSIGN COMPONENT lv_field OF STRUCTURE ls_comp_datax TO FIELD-SYMBOL(<lst_comp_valx>).
            IF lst_const-legacy_value IS NOT INITIAL. "1 Person 2 org
              IF gv_cat_flag = lst_const-legacy_value.
                <lst_comp_val> = lst_const-sap_value.
                IF <lst_comp_valx> IS ASSIGNED.
                  <lst_comp_valx>  = abap_true.
                ENDIF.
              ENDIF.
            ELSE.
              <lst_comp_val> = lst_const-sap_value.
              IF <lst_comp_valx> IS ASSIGNED.
                <lst_comp_valx>  = abap_true.
              ENDIF.
            ENDIF.
          ENDIF.
        CATCH cx_sy_assign_cast_error.
      ENDTRY.
      IF <lst_comp_val> IS ASSIGNED.
        UNASSIGN <lst_comp_val>.
      ENDIF.
      IF <lst_comp_valx> IS ASSIGNED.
        UNASSIGN <lst_comp_valx>.
      ENDIF.
      CLEAR lv_field.
    ENDLOOP.

    "----------------------------------------------------------------------
*---FI Dunning data mapping
*"----------------------------------------------------------------------
*--*Dunning
*    IF lsr_mahna-low IS NOT INITIAL.
*      lst_dunning-data-mahna = lsr_mahna-low.
*      lst_dunning-datax-mahna = abap_true.
*      APPEND lst_dunning TO li_dunning.
*      CLEAR : lst_dunning.
*      lst_comp_codes-dunning-dunning[] = li_dunning[].
*      CLEAR : li_dunning[].
*    ENDIF.
    IF ls_comp_data IS NOT INITIAL.
      lst_comp_codes-data = ls_comp_data.
      lst_comp_codes-datax = ls_comp_datax.
      APPEND lst_comp_codes TO f_li_comp_codes.
      CLEAR : ls_comp_data,ls_comp_datax.
    ENDIF.
    CLEAR lst_comp_codes.
  ENDIF.
ENDFORM.
