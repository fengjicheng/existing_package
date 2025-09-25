*----------------------------------------------------------------------*
* PROGRAM NAME:LZQTC_FG_BP_INTERFACE_AGUF01
* PROGRAM DESCRIPTION: Create BP with Comapny Code data,Sales Data,
*                      Collection & Credit management data
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE: 09/16/2019
* OBJECT ID: I0368
* TRANSPORT NUMBER(S):ED2K916061
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K924618
* REFERENCE NO: FMM5986,FMM8
* DEVELOPER:MIMMADISET
* DATE: 09/27/2021
* DESCRIPTION:Reading the companycode internal table first entry and
* it will be considered as primary company
* code for deriving the Credit/Collection/Dunning fields later in E191 program
*----------------------------------------------------------------------*
**&--------------------------------------------------------------------*
**&      Form  F_CUST_CRT_GEN_DATA
**&--------------------------------------------------------------------*
**       <--FP_V_PARTNER TYPE BU_PARTNER
**---------------------------------------------------------------------*
FORM f_cust_crt_gen_data CHANGING fp_v_partner TYPE bu_partner
                                  fp_ex_return TYPE ztqtc_customer_date_outputs. " Business Partner Number

  DATA:
*====================================================================*
*  Local Structure
*====================================================================*
    lst_bp_struct       TYPE bus_ei_extern, " Complex External Interface of a Business Partner
    lst_return_rollback TYPE bapiret2,      " Return Parameter
    lst_commit_return   TYPE bapiret2,      " Return Parameter
    ltt_but0id          TYPE TABLE OF but0id,       "Begin of addition for ERP-7078
    llst_bu0id          TYPE but0id,
    lst_return          LIKE LINE OF i_return,
    li_messages         TYPE bapiretct,
    lv_bu_partner       TYPE bu_partner,
    lv_number           TYPE but0id-idnumber,
    lv_id_matched       TYPE char1,
    lv_rollback         TYPE char1,
    lst_ex_ret          LIKE LINE OF  fp_ex_return,
    lst_zcaconstant     TYPE ty_constant,          "End of addition for ERP-7078
*====================================================================*
*  Local Variable
*====================================================================*
    lv_txreg            TYPE j_1btxreg,  " Tax Region
    lv_status           TYPE c LENGTH 1, " Status of type Character
    li_smtp             TYPE bus_ei_bupa_smtp_t,
    lv_langu            TYPE spras,
    lv_actv_i0200       TYPE zactive_flag,    "ADD:FMM5986:FMM8:MIMMADISET:09/27/2021:ed2k924618
    ltt_comp_data       TYPE cmds_ei_company_t. "ADD:FMM5986:FMM8:MIMMADISET:09/27/2021:ed2k924618
*====================================================================*
*  Local Constant
*====================================================================*
  CONSTANTS: lc_a           TYPE bapi_mtype VALUE 'A',   " Message type: S Success, E Error, W Warning, I Info, A Abort
             lc_e           TYPE bapi_mtype VALUE 'E',   " Message type: S Success, E Error, W Warning, I Info, A Abort
             lc_s           TYPE bapi_mtype VALUE 'S',   " Message type: S Success, E Error, W Warning, I Info, A Abort
             lc_w           TYPE bapi_mtype VALUE 'W',   " Message type: S Success, E Error, W Warning, I Info, A Abort.
             lc_msgid_r1    TYPE symsgid    VALUE 'R1',  " Message Class: R1
             lc_msgno_086   TYPE symsgno    VALUE '086', " Message No: 086
**begin of add:fmm5986:fmm8:mimmadiset:09/27/2021: ed2k924618
             lc_devid_i0200 TYPE zdevid         VALUE 'I0200',    " Development ID: I0200
             lc_katr9       TYPE zvar_key       VALUE 'KATR9',    " Attribute 9 in KNA1 field
             lc_tech1       TYPE bu_id_category VALUE 'TECH1',     "BP Identification Category
             lc_sno4_i0200  TYPE zsno           VALUE '004'.       " Serial Number: 004
**End of:FMM5986:FMM8:MIMMADISET:09/27/2021:ed2k924618
*====================================================================*
* Local Field-symbols
*====================================================================*
  FIELD-SYMBOLS: <lst_gen_data>       TYPE bus_ei_extern,              " Complex External Interface of a Business Partner
                 <lst_add_gen_data>   TYPE cmds_ei_central_data,       " External Interface: Central Data
                 <lst_sepa_mandate>   TYPE bus_ei_bupa_sepa_mandate,   " External Interface: Structure Type for Sepa Mandate
                 <lst_ident_data>     TYPE bus_ei_bupa_identification, " External Interface: Data for Creating an ID Number
                 <lst_address>        TYPE bus_ei_bupa_address,        " External Interface: Data for Creating an Address
                 <lst_comp_code_data> TYPE zstqtc_comp_code_data.      " add:fmm5986:fmm8:mimmadiset:09/27/2021: ed2k924618

  DATA(li_ident_num) = <st_gen_data>-gen_data-central_data-ident_number-ident_numbers.
*--------------------------------------------------------------------*
*Populate the Structure and create the BP customer                   *
*--------------------------------------------------------------------*
  CLEAR: lv_status, i_return.
  IF <lst_gen_data> IS ASSIGNED.
    UNASSIGN <lst_gen_data>.
  ENDIF. " IF <lst_gen_data> IS ASSIGNED

  ASSIGN <st_gen_data>-gen_data TO <lst_gen_data>.
  IF <lst_gen_data> IS ASSIGNED.
    LOOP AT <lst_gen_data>-central_data-ident_number-ident_numbers ASSIGNING <lst_ident_data>.
      IF <lst_ident_data>-task IS INITIAL.
        <lst_ident_data>-task = c_m.
      ENDIF. " IF <lst_ident_data>-task IS INITIAL
* Translate to upper case as BUT0ID validation will be done on upper case
      TRANSLATE <lst_ident_data>-data_key-identificationnumber TO UPPER CASE. " ED2K911597
      IF <lst_ident_data>-data_key-identificationcategory = c_reltype.
        DELETE <lst_gen_data>-central_data-ident_number-ident_numbers INDEX sy-tabix.
      ENDIF.
    ENDLOOP. " LOOP AT <lst_gen_data>-central_data-ident_number-ident_numbers ASSIGNING <lst_ident_data>
**Begin of ADD:FMM5986:FMM8:MIMMADISET:09/27/2021:ED2K924618
* To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_devid_i0200            " Development ID: I0200
        im_ser_num     = lc_sno4_i0200             " Serial Number4: I0200
        im_var_key     = lc_katr9
      IMPORTING
        ex_active_flag = lv_actv_i0200.            " Active / Inactive Flag
    IF lv_actv_i0200 EQ abap_true.
      IF v_object_inst = c_i AND fp_v_partner IS INITIAL.
        IF <lst_comp_code_data> IS ASSIGNED.
          UNASSIGN <lst_comp_code_data>.
        ENDIF. " IF <lst_comp_code_data> IS ASSIGNED
        ASSIGN <st_cust_input>-comp_code_data TO <lst_comp_code_data>.
        IF <lst_comp_code_data> IS ASSIGNED.
          REFRESH:ltt_comp_data.
          ltt_comp_data[]  = <lst_comp_code_data>-comp_codes[].
** Read the source company code first entry
          READ TABLE ltt_comp_data INTO DATA(ls_comp) INDEX 1.
          IF sy-subrc = 0 AND ls_comp-data_key-bukrs IS NOT INITIAL.
            APPEND INITIAL LINE TO <lst_gen_data>-central_data-ident_number-ident_numbers ASSIGNING <lst_ident_data>.
            IF <lst_ident_data> IS ASSIGNED.
              <lst_ident_data>-data_key-identificationcategory = lc_tech1.    "IDtype
              <lst_ident_data>-data_key-identificationnumber = ls_comp-data_key-bukrs.  "bukrs would be considered as primary company code in SAP
            ENDIF."IF <lst_ident_data> IS ASSIGNED.
          ENDIF.
        ENDIF."IF <lst_comp_code_data> IS ASSIGNED.
      ENDIF."IF v_object_inst = c_i AND fp_v_partner IS INITIAL.
    ENDIF."IF lv_actv_i0200 EQ abap_true.
**End of ADD:FMM5986:FMM8:MIMMADISET:09/27/2021:ED2K924618
    LOOP AT <lst_gen_data>-central_data-address-addresses ASSIGNING <lst_address>.
      <lst_address>-task = c_s.
**--BOC E225 -Bp rules addition 12/18/2019
      IF st_bp_rules-check15_comm_method = abap_true.
        IF <st_cust_input>-data_key-partner IS INITIAL.
          li_smtp = <lst_address>-data-communication-smtp-smtp.
          IF li_smtp[] IS NOT INITIAL.
            LOOP AT li_smtp INTO DATA(list_smtp).
              IF list_smtp-contact-data-e_mail IS NOT INITIAL.
                <lst_address>-data-postal-data-comm_type = c_commtyp_int.
                <lst_address>-data-postal-datax-comm_type = abap_true.
              ELSE.
                <lst_address>-data-postal-data-comm_type = c_commtyp_let.
                <lst_address>-data-postal-datax-comm_type = abap_true.
              ENDIF.
              CLEAR list_smtp.
            ENDLOOP.
          ENDIF. " IF li_smtp[] IS NOT INITIAL
        ENDIF. " IF <st_cust_input>-data_key-partner IS INITIAL AND
      ENDIF.
**--EOC E225 -Bp rules addition 12/18/2019
*     Country: Brazil specific logic
      IF <lst_address>-data-postal-data-country EQ c_land_br AND
         <lst_address>-data-postal-data-region  IS NOT INITIAL.
*       Determine Tax Region
        SELECT txreg                                           "Tax Region
          FROM j_1btregx                                       " Tax region
         UP TO 1 ROWS
          INTO lv_txreg
         WHERE land1 EQ <lst_address>-data-postal-data-country "Country Key
           AND bland EQ <lst_address>-data-postal-data-region. "Region (State, Province, County)
        ENDSELECT.
        IF sy-subrc EQ 0.
          <lst_address>-data-postal-data-taxjurcode  = lv_txreg. "Tax Jurisdiction
          <lst_address>-data-postal-datax-taxjurcode = abap_true. "Tax Jurisdiction
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF <lst_address>-data-postal-data-country EQ c_land_br AND
    ENDLOOP. " LOOP AT <lst_gen_data>-central_data-address-addresses ASSIGNING <lst_address>

    IF st_cust_input-data_key-partner IS NOT INITIAL.
      lv_langu = <lst_gen_data>-central_data-common-data-bp_person-correspondlanguage.
      IF lv_langu IS NOT INITIAL.
        <lst_gen_data>-central_data-common-data-bp_person-correspondlanguage = abap_false.
        <lst_gen_data>-central_data-common-datax-bp_person-correspondlanguage = abap_false.
        CLEAR lv_langu.
      ENDIF.

*      lv_langu = <lst_gen_data>-central_data-common-data-bp_centraldata-partnerlanguage.
*      IF lv_langu IS NOT INITIAL.
*        <lst_gen_data>-central_data-common-data-bp_centraldata-partnerlanguage = abap_false.
*        <lst_gen_data>-central_data-common-datax-bp_centraldata-partnerlanguage = abap_false.
*        CLEAR lv_langu.
*      ENDIF.
    ENDIF.

    lst_bp_struct = <lst_gen_data>.

    CLEAR: i_return,lv_status,lv_bu_partner.
    CALL FUNCTION 'BUPA_INBOUND_MAP_MAIN'
      EXPORTING
        iv_x_save   = abap_true
      IMPORTING
        status      = lv_status
      TABLES
        et_return   = i_return
      CHANGING
        c_bp_struct = lst_bp_struct.

    IF NOT i_return[] IS INITIAL.
      LOOP AT i_return INTO lst_return WHERE type   = lc_e
                                       AND   id    IN lr_msgid
                                       AND   number IN  lr_msgno.
        lv_bu_partner = lst_return-message_v1.
        PERFORM f_update_gen_data_msg USING    v_log_handle
                                           i_return
                                  CHANGING li_messages.
        lst_ex_ret-messages = li_messages[].
        APPEND lst_ex_ret TO fp_ex_return.
        CLEAR : lst_ex_ret.
        EXIT.
      ENDLOOP.

*       Specifically check if the BP Is still locked
      READ TABLE i_return TRANSPORTING NO FIELDS
           WITH KEY type   = lc_e " With key of type
                    id     = lc_msgid_r1
                    number = lc_msgno_086.
      IF sy-subrc EQ 0.
        WAIT UP TO 1 SECONDS.
*          CONTINUE.
      ENDIF. " IF sy-subrc EQ 0

      fp_v_partner = lst_bp_struct-header-object_instance-bpartner.

      IF lv_status EQ lc_s.
*- Checking Partner  Number
        IF fp_v_partner IS NOT INITIAL.
          LOOP AT li_ident_num INTO DATA(lst_ident_num).
*-            Partner Number
            lst_zqtc_ext_ident-partner =  fp_v_partner.
*-            Category
            lst_zqtc_ext_ident-type =  lst_ident_num-data_key-identificationcategory.
*-            Identification Number
            lst_zqtc_ext_ident-idnumber = lst_ident_num-data_key-identificationnumber.
*-            Needs to populate External ID for ZSFCI and ZCAAID
            lst_zqtc_ext_ident-ext_idnumber = lst_ident_num-data_key-identificationnumber.
            TRANSLATE lst_zqtc_ext_ident-idnumber TO UPPER CASE.
            APPEND lst_zqtc_ext_ident TO lt_zqtc_ext_ident.
            CLEAR : lst_zqtc_ext_ident.
          ENDLOOP.
          PERFORM f_update_gen_data_msg USING    v_log_handle
                                             i_return
                                    CHANGING li_messages.
          lst_ex_ret-messages = li_messages[].
          APPEND lst_ex_ret TO fp_ex_return.
          CLEAR : lst_ex_ret.
*- Checking Table Entries
          IF lt_zqtc_ext_ident[] IS NOT INITIAL.
*- Modifying Custom table by using update function module froom the update mode
            CALL FUNCTION 'ZQTC_UPDATE_EXTERNAL_ID_BP' IN UPDATE TASK
              TABLES
                t_ext_ident = lt_zqtc_ext_ident.

          ENDIF. " IF lt_zqtc_ext_ident IS NOT INITIAL
        ENDIF. " IF fp_v_partner IS NOT INITIAL

*         Bapi traction Commit
        CLEAR lst_commit_return.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait   = abap_true
          IMPORTING
            return = lst_commit_return.

      ELSEIF lv_status EQ lc_a AND lv_bu_partner IS NOT INITIAL.
        PERFORM f_update_gen_data_msg USING  v_log_handle
                                          i_return
                                 CHANGING li_messages.

*- Get Business partner data
        CLEAR ltt_but0id[].
        SELECT * FROM but0id INTO TABLE ltt_but0id
                             WHERE partner = lv_bu_partner.
        IF sy-subrc IS INITIAL AND ltt_but0id[] IS NOT INITIAL.
          "SoldTo exists
*- Checking Sold-to
          CLEAR: llst_bu0id, lv_id_matched .
*                LOOP AT ltt_but0id INTO  llst_bu0id WHERE ( type = c_zsfci OR type = c_zecid ).

          READ TABLE ltt_but0id INTO  llst_bu0id WITH KEY type = c_zsfci.
          IF sy-subrc IS INITIAL.
*- Checking Ship-to
            "SoldTo and ShipTo must have same SFDC ID
            READ TABLE li_ident_num INTO DATA(lstt_ident_num) WITH KEY data_key-identificationcategory = llst_bu0id-type.
            IF sy-subrc EQ 0.
              "Yes SFDC ID exists
              CLEAR  lv_number.
              lv_number = lstt_ident_num-data_key-identificationnumber.
              TRANSLATE lv_number TO UPPER CASE.
              IF lv_number = llst_bu0id-idnumber.

                "SFDC ID matched with SoldTo SFDC ID
                PERFORM ztable_map TABLES li_ident_num
                                          lt_zqtc_ext_ident
                                    USING "lstt_ident_num
                                         lv_bu_partner.

                lst_return-type = lc_w.
                MODIFY i_return FROM lst_return TRANSPORTING type WHERE  type   = lc_e
                                                                  AND    id     IN lr_msgid
                                                                  AND    number IN  lr_msgno.
              ELSE.
                "SFDC ID didn't match, look for ECID
                CLEAR: lv_id_matched.
                PERFORM ext_id_check TABLES ltt_but0id
                                            li_ident_num
                                     USING c_zecid
                                     CHANGING lv_id_matched.

                IF lv_id_matched EQ abap_true.
                  PERFORM ztable_map TABLES li_ident_num
                                            lt_zqtc_ext_ident
                                      USING "lstt_ident_num
                                           lv_bu_partner.
                  lst_return-type = lc_w.
                  MODIFY i_return FROM lst_return TRANSPORTING type WHERE  type   = lc_e
                                                                    AND    id    IN lr_msgid
                                                                    AND    number IN  lr_msgno.
                ELSE.
                  "even ECID # doesn't match.. unable to find the relationships with the lock
                  "roll back the activity
                  lv_rollback = abap_true.

                ENDIF.
              ENDIF.
            ELSE.
*-          "SoldTo have SFDC ID and shipTo doesn't have..
              "its not possbile to happen.. skip it

              "roll back the activity
              lv_rollback = abap_true.

            ENDIF.
            FREE: lstt_ident_num.
          ELSE.
            "SoldTo BP Doesn't have SFDC ID.. look for ECID
            CLEAR lv_id_matched.
            PERFORM ext_id_check TABLES ltt_but0id
                                        li_ident_num
                                 USING c_zecid
                                 CHANGING lv_id_matched.

            IF lv_id_matched EQ abap_true.
              PERFORM ztable_map TABLES li_ident_num
                                        lt_zqtc_ext_ident
                                  USING "lstt_ident_num  "-data_key-identificationcategory
                                       lv_bu_partner.
              lst_return-type = lc_w.
              MODIFY i_return FROM lst_return TRANSPORTING type WHERE  type   = lc_e
                                                                AND    id    IN lr_msgid
                                                                AND    number IN  lr_msgno.
            ELSE.
              "SoldTo doesn't have SFDC ID and ECID of both the ID's doesn't match
              "unable to find the relation between BP's

              "roll back the activity
              lv_rollback = abap_true.
            ENDIF.
            "roll back the activity
            lv_rollback = abap_true.
          ENDIF.

*- Checking Table Entries
          IF lt_zqtc_ext_ident[] IS NOT INITIAL AND lv_rollback IS INITIAL.
*- Modifying Custom table by using update function module froom the update mode
            CALL FUNCTION 'ZQTC_UPDATE_EXTERNAL_ID_BP' IN UPDATE TASK
              TABLES
                t_ext_ident = lt_zqtc_ext_ident.

*         Bapi traction Commit
            CLEAR lst_commit_return.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait   = abap_true
              IMPORTING
                return = lst_commit_return.
          ELSE.
*-          "something went wrong, Z-table must be updated with ID's
            lv_rollback = abap_true.
          ENDIF.
        ELSE.
*-        "wrong message variable is read in DB. or BP doesn't have Identifier data. Please validate
          lv_rollback = abap_true.
        ENDIF.
      ELSE. " ELSE -> IF lv_status EQ lc_s
*         Bapi transaction Rollback
        CLEAR fp_v_partner.

        CLEAR lst_return_rollback.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
          IMPORTING
            return = lst_return_rollback.
      ENDIF. " IF lv_status EQ lc_s
    ENDIF. " IF NOT i_return[] IS INITIAL
  ENDIF. " IF <lst_gen_data> IS ASSIGNED
  IF lv_bu_partner IS NOT INITIAL.
    "error case with BP locking issue
    IF lv_rollback EQ abap_true.
*         Bapi transaction Rollback
      CLEAR fp_v_partner.
      CLEAR lst_return_rollback.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
        IMPORTING
          return = lst_return_rollback.
    ELSE.
      "complete the dependent comit work

    ENDIF.
  ELSE.
    "regular execution without any locking issue.. move fwd with out any additional logic
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPD_CUST_COM_SALES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_I_COMP_DATA   TYPE CMDS_EI_COMPANY_T
*      -->FP_I_SALES_DATA  TYPE CMDS_EI_SALE_T
*----------------------------------------------------------------------*
FORM f_upd_cust_com_sales  USING    fp_v_partner       TYPE bu_partner               " Business Partner Number
                                    fp_st_add_general_data TYPE cmds_ei_central_data " External Interface: Central Data
                                    fp_i_comp_data     TYPE cmds_ei_company_t
                                    fp_i_sales_data    TYPE cmds_ei_sales_t
                                    fp_v_dummy         TYPE abap_bool
                           CHANGING fp_lst_error       TYPE cvis_message             " Ext. Interface: Total Customer Data.
                                    fp_lst_master_data TYPE cmds_ei_main.            " Error Indicator and System Messages
*====================================================================*
*       Local internal Table
*====================================================================*
  DATA: li_extern  TYPE cmds_ei_extern_t,
        li_dunning TYPE cmds_ei_dunning_t,
        li_parvw   TYPE cmds_parvw_t,
*====================================================================*
*       Local Work-area
*====================================================================*
        lst_extern TYPE cmds_ei_extern, " Complex External Interface for Customers
        lst_return TYPE bapiret2,       " Return Parameter
        lv_ktokd   TYPE ktokd,          " Customer Account Group
        lv_kunnr   TYPE kunnr.          " Customer Number

  DATA: ls_tax_ind TYPE cmds_ei_cmd_tax_ind.
*====================================================================*
*       Local Field-Symbol
*====================================================================*
  FIELD-SYMBOLS: <lst_customers>  TYPE cmds_ei_extern,  " Complex External Interface for Customers
                 <lst_comp_data>  TYPE cmds_ei_company, " Ext. Interface: Company Code Data
                 <lst_dunning>    TYPE cmds_ei_dunning, " Ext. Interface: Dunning Data
                 <lst_sales_data> TYPE cmds_ei_sales.   " Ext. Interface: Sales Data
  CLEAR lv_kunnr.
  lv_kunnr = fp_v_partner.
*====================================================================*
* Populate the CMD_EI_API -Master data
*====================================================================*
  LOOP AT fp_i_comp_data ASSIGNING <lst_comp_data>.
    IF <lst_comp_data> IS ASSIGNED.
      <lst_comp_data>-task = c_m.
      li_dunning = <lst_comp_data>-dunning-dunning[].
      IF li_dunning[] IS NOT INITIAL.
        LOOP AT  li_dunning ASSIGNING <lst_dunning>.
          <lst_dunning>-task = c_m.
        ENDLOOP. " LOOP AT li_dunning ASSIGNING <lst_dunning>

        <lst_comp_data>-dunning-dunning[] = li_dunning[].
      ENDIF. " IF li_dunning[] IS NOT INITIAL
    ENDIF. " IF <lst_comp_data> IS ASSIGNED
  ENDLOOP. " LOOP AT fp_i_comp_data ASSIGNING <lst_comp_data>
* No need to make changes, if already extended
  DELETE fp_i_comp_data WHERE task IS INITIAL.
* Fetch Customer Account Group
  CLEAR: lv_ktokd.
  CALL METHOD cmd_ei_api=>get_ktokd
    EXPORTING
      iv_kunnr = lv_kunnr
    IMPORTING
      ev_ktokd = lv_ktokd.
  IF lv_ktokd IS NOT INITIAL.
*   Get all mandatory partner functions
    CALL METHOD cmd_ei_api_check=>get_mand_partner_functions
      EXPORTING
        iv_ktokd = lv_ktokd
      IMPORTING
        et_parvw = li_parvw.
  ENDIF. " IF lv_ktokd IS NOT INITIAL
*--*BOC E225 - Partners modification for Society IN and AU
  IF st_bp_rules-map8_society_partner IS NOT INITIAL AND v_society IS NOT INITIAL
         AND v_indirect IS NOT INITIAL.
    IF st_create-gen_data IS NOT INITIAL. "for rest of the cases BP available at E225 FM level
      LOOP AT fp_i_sales_data ASSIGNING <lst_sales_data>.
        IF <lst_sales_data> IS ASSIGNED.
          <lst_sales_data>-task = c_m.
          LOOP AT  <lst_sales_data>-functions-functions
                    ASSIGNING FIELD-SYMBOL(<lst_function_pf>).
            <lst_function_pf>-task  = c_m.
            IF <lst_function_pf>-data-partner  IS INITIAL.
              <lst_function_pf>-data-partner   = lv_kunnr.
            ENDIF.
          ENDLOOP.
        ENDIF. " IF <lst_sales_data> IS ASSIGNED
      ENDLOOP.
    ENDIF.
  ELSE.
*--*EOC E225 - Partners modification
    LOOP AT fp_i_sales_data ASSIGNING <lst_sales_data>.
      IF <lst_sales_data> IS ASSIGNED.
        <lst_sales_data>-task = c_m.
      ENDIF. " IF <lst_sales_data> IS ASSIGNED
*    CLEAR: <lst_sales_data>-functions-functions[].
      LOOP AT li_parvw ASSIGNING FIELD-SYMBOL(<lst_parvw>).
        APPEND INITIAL LINE TO <lst_sales_data>-functions-functions
               ASSIGNING FIELD-SYMBOL(<lst_function>).
        <lst_function>-task           = c_m. "External Interface: Change Indicator for Partner Roles
        <lst_function>-data_key-parvw = <lst_parvw>-parvw. "Partner Function
        <lst_function>-data-partner   = lv_kunnr. "Number of an SD business partner
      ENDLOOP. " LOOP AT li_parvw ASSIGNING FIELD-SYMBOL(<lst_parvw>)
    ENDLOOP. " LOOP AT fp_i_sales_data ASSIGNING <lst_sales_data>
  ENDIF.
* No need to make changes, if already extended
  DELETE fp_i_sales_data WHERE task IS INITIAL.
* End   of ADD:ERP-2958:WROY:28-JUN-2017:ED2K907000

  READ TABLE fp_lst_master_data-customers ASSIGNING <lst_customers> INDEX v_index.
  IF sy-subrc NE 0.
    APPEND INITIAL LINE TO fp_lst_master_data-customers ASSIGNING <lst_customers>.
  ENDIF. " IF sy-subrc NE 0
  IF <lst_customers> IS ASSIGNED.
    <lst_customers>-header-object_instance-kunnr = lv_kunnr.
    <lst_customers>-header-object_task           = c_m.
    <lst_customers>-company_data-company[]       = fp_i_comp_data[].
    <lst_customers>-sales_data-sales[]           = fp_i_sales_data[].

  ENDIF. " IF <lst_customers> IS ASSIGNED

  <lst_customers>-central_data-central = fp_st_add_general_data-central.

  ls_tax_ind = fp_st_add_general_data-tax_ind.
  PERFORM f_det_tax_ind USING ls_tax_ind
                        CHANGING <lst_customers>.

*====================================================================*
* Update Comapany data & Sales data
*====================================================================*
  cmd_ei_api=>maintain(
    EXPORTING
      iv_test_run    = fp_v_dummy
      is_master_data = fp_lst_master_data
    IMPORTING
      es_error       = fp_lst_error
         ).
  IF fp_lst_error-is_error EQ abap_true.
    CLEAR lst_return.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
      IMPORTING
        return = lst_return.
  ELSE. " ELSE -> IF fp_lst_error-is_error EQ abap_true
    CLEAR lst_return.
    IF fp_v_dummy EQ abap_false.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait   = abap_true
        IMPORTING
          return = lst_return.
    ELSE. " ELSE -> IF fp_v_dummy EQ abap_false
      CLEAR lst_return.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
        IMPORTING
          return = lst_return.
    ENDIF. " IF fp_v_dummy EQ abap_false
  ENDIF. " IF fp_lst_error-is_error EQ abap_true
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHK_KNA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_V_PARTNER        TYPE BU_PARTNER
*      -->FP_V_PARTNER_EXIST  TYPE XFELD
*----------------------------------------------------------------------*
FORM f_chk_kna1  USING    fp_v_partner       TYPE bu_partner " Business Partner Number
                 CHANGING fp_v_partner_exist TYPE xfeld.     " Checkbox
*====================================================================*
*  Local Variable
*====================================================================*
  DATA: lv_kunnr         TYPE kunnr. " Customer Number
  DATA: lv_kunnr_partner TYPE kunnr. " Customer Number

  CLEAR: lv_kunnr,
         lv_kunnr_partner.

  lv_kunnr = fp_v_partner.

*  DO 10 TIMES.
*--Check if the Partner has been reflected--*
*--in the KNA1 table------------------------*
  SELECT SINGLE  kunnr     " Customer Number
                 FROM kna1 " General Data in Customer Master
                 INTO lv_kunnr_partner
                 WHERE kunnr EQ lv_kunnr.
  IF sy-subrc IS INITIAL.
    CLEAR fp_v_partner_exist.
    fp_v_partner_exist = abap_true.
    EXIT.
  ELSE. " ELSE -> IF sy-subrc IS INITIAL
*--   Wait time for for the partner to get reflected as Customer in database.
*      WAIT UP TO 1 SECONDS.
    fp_v_partner_exist = abap_false.
  ENDIF. " IF sy-subrc IS INITIAL
*  ENDDO.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_APP_LOG_FOR_INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_IM_GUID         TYPE GUID_32
*      -->FP_IM_SOURCE       TYPE TPM_SOURCE_NAME
*      -->FP_IM_DATA         TYPE ZSTQTC_CUSTOMER_DATE_INPUT
*      <--FP_LV_LOG_HANDLE   TYPE BALLOGHNDL
*----------------------------------------------------------------------*
FORM f_create_app_log_for_input  USING fp_im_guid       TYPE idoccarkey                  " GUID in 'CHAR' Format in Uppercase
                                       fp_im_source     TYPE tpm_source_name             " Origin
                                       fp_im_address    TYPE bus_ei_bupa_address_t
                                       fp_im_data       TYPE zstqtc_customer_date_input  " I0200: Customer Data (Gen, Comp Code, Sales Area, Crdt/Coll)
                                       fp_st_person     TYPE bus_ei_struc_central_person " Ext. Interface: Structure CENTRAL_PERSON
                                       fp_st_org        TYPE bus_ei_struc_central_organ  " Ext. Interface: Structure CENTRAL_ORGANIZATION
                                CHANGING
                                       fp_lv_log_handle TYPE balloghndl.                 " Application Log: Log Handle
*====================================================================*
*  Local Variable
*====================================================================*
  DATA: lst_address TYPE bus_ei_bupa_address, " External Interface: Data for Creating an Address
        lv_name     TYPE char200.             " Name of type CHAR100
*====================================================================*
*  Local Constant
*====================================================================*
  CONSTANTS: lc_separator TYPE char1 VALUE '/'. " Separator of type CHAR1
*====================================================================*
*   Add message to Application Log - SOURCE SYSTEM/ORIGIN
*====================================================================*
*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
  PERFORM f_log_info  USING fp_lv_log_handle
                            c_msgty_info               " Message Type - (I)nformation
                            'Input-'(l01)
                            'Source System / Origin:'(l02)
                            fp_im_source
                            c_gen_data
                            c_nodetype_i.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*  PERFORM f_log_add    USING fp_lv_log_handle
*                             c_msgty_info "Message Type - (I)nformation
*                             'Input-'(l01)
*                             'Source System / Origin:'(l02)
*                             fp_im_source.
*====================================================================*
*   Add message to Application Log - Name
*====================================================================*
  IF fp_st_person IS NOT INITIAL.

    CONCATENATE fp_st_person-firstname
                fp_st_person-lastname
                INTO lv_name
                SEPARATED BY space.

  ELSEIF fp_st_org IS NOT INITIAL.

    CONCATENATE fp_st_org-name1
                fp_st_org-name2
                fp_st_org-name3
                fp_st_org-name4
                INTO
                lv_name
                SEPARATED BY lc_separator.
  ENDIF. " IF fp_st_person IS NOT INITIAL

*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
  PERFORM f_log_info  USING fp_lv_log_handle
                            c_msgty_info               " Message Type - (I)nformation
                            'Input-'(l01)
                            'Name:'(l17)
                            lv_name
                            c_gen_data
                            c_nodetype_i.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*  PERFORM f_log_add    USING fp_lv_log_handle
*                             c_msgty_info "Message Type - (I)nformation
*                             'Input-'(l01)
*                             'Name:'(l17)
*                             lv_name.
*====================================================================*
*   Add message to Application Log - ADDRESS DATA
*====================================================================*
  CLEAR  lst_address.
  LOOP AT fp_im_address INTO lst_address.
*--------------------------------------------------------------------*
* Street
*--------------------------------------------------------------------*
*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    PERFORM f_log_info  USING fp_lv_log_handle
                              c_msgty_info               " Message Type - (I)nformation
                              'Input-'(l01)
                              'Street:'(l03)
                              lst_address-data-postal-data-street
                              c_gen_data
                              c_nodetype_i.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_lv_log_handle
*                               c_msgty_info "Message Type - (I)nformation
*                               'Input-'(l01)
*                               'Street:'(l03)
*                               lst_address-data-postal-data-street.
*--------------------------------------------------------------------*
*City
*--------------------------------------------------------------------*
*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    PERFORM f_log_info  USING fp_lv_log_handle
                              c_msgty_info               " Message Type - (I)nformation
                              'Input-'(l01)
                              'City:'(l04)
                              lst_address-data-postal-data-city
                              c_gen_data
                              c_nodetype_i.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_lv_log_handle
*                               c_msgty_info "Message Type - (I)nformation
*                                'Input-'(l01)
*                                'City:'(l04)
*                                lst_address-data-postal-data-city.
*--------------------------------------------------------------------*
* Region
*--------------------------------------------------------------------*
*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    PERFORM f_log_info  USING fp_lv_log_handle
                              c_msgty_info               " Message Type - (I)nformation
                              'Input-'(l01)
                              'Region:'(l05)
                              lst_address-data-postal-data-region
                              c_gen_data
                              c_nodetype_i.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_lv_log_handle
*                               c_msgty_info "Message Type - (I)nformation
*                               'Input-'(l01)
*                               'Region:'(l05)
*                               lst_address-data-postal-data-region.
*--------------------------------------------------------------------*
* Postal Code
*--------------------------------------------------------------------*
*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    PERFORM f_log_info  USING fp_lv_log_handle
                              c_msgty_info               " Message Type - (I)nformation
                              'Input-'(l01)
                              'Postal Code:'(l06)
                              lst_address-data-postal-data-postl_cod1
                              c_gen_data
                              c_nodetype_i.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_lv_log_handle
*                               c_msgty_info "Message Type - (I)nformation
*                               'Input-'(l01)
*                               'Postal Code: '(l06)
*                               lst_address-data-postal-data-postl_cod1.
*--------------------------------------------------------------------*
* Country
*--------------------------------------------------------------------*
*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    PERFORM f_log_info  USING fp_lv_log_handle
                              c_msgty_info               " Message Type - (I)nformation
                              'Input-'(l01)
                              'Country: '(l07)
                              lst_address-data-postal-data-country
                              c_gen_data
                              c_nodetype_i.
** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_lv_log_handle
*                               c_msgty_info "Message Type - (I)nformation
*                               'Input-'(l01)
*                               'Country: '(l07)
*                               lst_address-data-postal-data-country.

  ENDLOOP. " LOOP AT fp_im_address INTO lst_address

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_CREATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_IM_GUID        TYPE GUID_32
*      -->FP_IM_DATA        TYPE ZSTQTC_CUSTOMER_DATE_INPUT
*      <--FP_LV_LOG_HANDLE  TYPE BALLOGHNDL
*----------------------------------------------------------------------*
FORM f_log_create  USING    fp_im_guid       TYPE idoccarkey                 " GUID in 'CHAR' Format in Uppercase
                            fp_im_data       TYPE zstqtc_customer_date_input " I0200: Customer Data (Gen, Comp Code, Sales Area, Crdt/Coll)
* BOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
                            fp_li_constant   TYPE tt_constant
* EOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
                   CHANGING fp_lv_log_handle TYPE balloghndl.                " Application Log: Log Handle
*====================================================================*
* Local Structure
*====================================================================*
  DATA: lst_log      TYPE bal_s_log, " Application Log: Log header data
        lv_extnumber TYPE char100,   " Extnumber of type CHAR100
* BOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
        lv_days      TYPE i,
        lv_date      TYPE aldate_del.
* EOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
*====================================================================*
* Local Constants
*====================================================================*
  CONSTANTS: lc_slash  TYPE c1 VALUE '/'. " Select time frame in units of day

  CLEAR lv_extnumber.
* Create extnumber
  CONCATENATE fp_im_guid
              fp_im_data-seq_id
              fp_im_data-data_key-partner
              fp_im_data-data_key-id_number+0(13)
              INTO
              lv_extnumber
              SEPARATED BY lc_slash.

  CONDENSE lv_extnumber NO-GAPS.
* BOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
* Get Expiry date and update in header data
  READ TABLE fp_li_constant INTO DATA(lst_constant)
                         WITH KEY param1 = c_expiry
                                  param2 = c_appl.
  IF sy-subrc EQ 0.
    lv_days = lst_constant-low.
    lv_date = sy-datum + lv_days.
  ENDIF.
  lst_log-aldate_del = lv_date.
* EOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
*====================================================================*
* Define some header data of this log
*====================================================================*
  lst_log-extnumber  = lv_extnumber. "Application Log: External ID
  lst_log-object     = c_bal_obj. "Application Log: Object Name (ZRTR)
  lst_log-subobject  = c_bal_sub. "Application Log: Subobject (ZCUST_LKUP)
  lst_log-aldate     = sy-datum. "Application log: Date
  lst_log-altime     = sy-uzeit. "Application log: Time
  lst_log-aluser     = sy-uname. "Application log: User name
  lst_log-alprog     = sy-repid. "Application log: Program name

*====================================================================*
* Application Log: Log: Create with Header Data
*====================================================================*
  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = lst_log          "Log header data
    IMPORTING
      e_log_handle            = fp_lv_log_handle "Application Log: Log Handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc NE 0.
    CLEAR: fp_lv_log_handle.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_APP_LOG_FOR_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_V_LOG_HANDLE  TYPE BALLOGHNDL
*      -->FP_I_COLL_RET    TYPE BAPIRETCT
*      <--FP_EX_RETURN     TYPE BAPIRETCT
*----------------------------------------------------------------------*
FORM f_create_app_log_for_output  USING    fp_v_log_handle TYPE balloghndl " Application Log: Log Handle
                                           fp_i_coll_ret   TYPE bapiretct
                                  CHANGING fp_ex_return    TYPE ztqtc_customer_date_outputs.

*====================================================================*
*  Local Work-Area
*====================================================================*
  DATA: lst_coll_ret  TYPE bapiretc, " Return Parameter for Complex Data Type
        lst_coll_ret2 TYPE bapiretc, " Return Parameter for Complex Data Type
*====================================================================*
*  Local Variable
*====================================================================*
        lv_message    TYPE string.
*====================================================================*
*  Local Field-symbols
*====================================================================*
  FIELD-SYMBOLS:<lst_ex_ret> TYPE zstqtc_customer_date_output. " I0200: Customer Data (Customer / BP Number, Messages)
*====================================================================*
*Add message to Appl Log - Messages of Credit?Collection Segment
*====================================================================*
  CLEAR lst_coll_ret.
  LOOP AT fp_i_coll_ret INTO lst_coll_ret.

    CLEAR:lv_message,
          lst_coll_ret2.

    lst_coll_ret2 = lst_coll_ret.

    MESSAGE ID lst_coll_ret-id
    TYPE       lst_coll_ret-type
    NUMBER     lst_coll_ret-number
    INTO       lv_message
    WITH       lst_coll_ret-message_v1
               lst_coll_ret-message_v2
               lst_coll_ret-message_v3
               lst_coll_ret-message_v4.
    lst_coll_ret2-message_v4 = '011'.
*--------------------------------------------------------------------*
*    Update message
*--------------------------------------------------------------------*
*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
*    IF v_dummy = abap_true.
*      PERFORM f_log_info  USING fp_v_log_handle
*                                lst_coll_ret-type        " Message Type
*                                'Input-'(L01)
*                                'Credit Segment/Collective Segment:'(l16)
*                                lv_message
*                                c_input_data
*                                c_nodetype_i.
*    ELSE.
*      PERFORM f_log_info  USING fp_v_log_handle
*                                lst_coll_ret-type        " Message Type
*                                'Output-'(I02)
*                                'Credit Segment/Collective Segment:'(l16)
*                                lv_message
*                                c_cred_coll
*                                c_nodetype_i.
*    ENDIF.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_v_log_handle
*                               lst_coll_ret-type
*                               'Output-'(I02)
*                               'Credit Segment/Collective Segment :  '(l16)
*                               lv_message.
*--------------------------------------------------------------------*
*    Update Exporting Parameter
*--------------------------------------------------------------------*
    READ TABLE fp_ex_return ASSIGNING <lst_ex_ret> INDEX v_index.
    IF sy-subrc NE 0.
      APPEND INITIAL LINE TO fp_ex_return ASSIGNING <lst_ex_ret>.
    ENDIF. " IF sy-subrc NE 0
    IF <lst_ex_ret> IS ASSIGNED.
      APPEND lst_coll_ret2 TO <lst_ex_ret>-messages.
      CLEAR  lst_coll_ret2.
    ENDIF. " IF <lst_ex_ret> IS ASSIGNED


  ENDLOOP. " LOOP AT fp_i_coll_ret INTO lst_coll_ret

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_SAVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_V_LOG_HANDLE  TYPE BALLOGHNDL
*----------------------------------------------------------------------*
FORM f_log_save  USING    fp_v_log_handle TYPE balloghndl. " Application Log: Log Handle

*====================================================================*
* Local Internal Table
*====================================================================*
  DATA li_log_handle TYPE bal_t_logh. "Application Log: Log Handle Table

*====================================================================*
* Add the Application Log: Log Handle
*====================================================================*
  APPEND fp_v_log_handle TO  li_log_handle.

*====================================================================*
* Application Log: Database: Save logs
*====================================================================*
  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_t_log_handle   = li_log_handle "Application Log: Log Handle
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc NE 0.
*   Nothing to do
  ELSE.
    CLEAR: li_log_handle, fp_v_log_handle.
  ENDIF. " IF sy-subrc NE 0

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
                         fp_v_msgv3      TYPE any.

*====================================================================*
* Local Structure( Work-Area)
*====================================================================*
  DATA:lst_message  TYPE bal_s_msg. "Application Log: Message Data
* BOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
  DATA : lv_fval      TYPE int4,
         lv_ofset     TYPE int4,
         lv_mesg(100) TYPE c.
* EOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
*====================================================================*
* Prepare the message
*====================================================================*
  lst_message-msgty  = fp_v_msgty. "Message Type
  lst_message-msgid  = c_msgid_zrtr. "Message Class - ZRTR_R1B
  lst_message-msgno  = c_msgno_000. "Message Number - 000
  lst_message-msgv1  = fp_v_msgv1. "Message Variable 1
  lst_message-msgv2  = fp_v_msgv2. "Message Variable 2
* BOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
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
* EOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
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
*&      Form  F_FETCH_BUT0ID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_IM_DATA  TYPE ZTQTC_CUSTOMER_DATE_INPUTS
*      <--FP_I_BUT0ID TYPE TTY_PARTNER_ID
*----------------------------------------------------------------------*
FORM f_fetch_but0id  USING    fp_im_data  TYPE ztqtc_customer_date_inputs
                     CHANGING fp_i_but000 TYPE tty_partner
                              fp_i_but0id TYPE tty_partner_id.


  IF fp_i_but0id[] IS INITIAL.
    SELECT a~partner            " Business Partner Number
           a~type               " Business partner category
           a~idnumber           " Identification Number
           b~katr4              " Attribute 4
           FROM but0id     AS a " BP: ID Numbers
           INNER JOIN kna1 AS b
           ON ( a~partner EQ b~kunnr )
           INTO TABLE fp_i_but0id
           FOR ALL ENTRIES IN fp_im_data
           WHERE ( type     EQ fp_im_data-data_key-id_category
           AND     idnumber EQ fp_im_data-data_key-id_number
           AND     katr4    EQ fp_im_data-general_data-add_gen_data-central-data-katr4 ).
    IF sy-subrc IS INITIAL.
      SORT fp_i_but0id BY type
                          idnumber.

      SELECT partner      " Business Partner Number
             partner_guid " Business Partner GUID
             xdele        " Business Partner Archive flag
             FROM but000  " BP: General data I
             APPENDING TABLE fp_i_but000
             FOR ALL ENTRIES IN fp_i_but0id
             WHERE partner EQ fp_i_but0id-partner.
      IF sy-subrc IS INITIAL.
        SORT fp_i_but000 BY partner.
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF fp_i_but0id[] IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPD_CRDT_COLL_SEG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_ST_DATA_KEY       TYPE zstqtc_bp_identification_key
*      -->FP_ST_CRDT_COLL_DATA TYPE zstqtc_credit_collection_data
*      <--FP_EX_RETURN         TYPE bapiretct
*----------------------------------------------------------------------*
FORM f_upd_crdt_coll_seg  USING    fp_st_data_key       TYPE zstqtc_bp_identification_key  " I0200: Details to Identify Business Partner
                                   fp_st_crdt_coll_data TYPE zstqtc_credit_collection_data " I0200: Customer master data distribution - Credit/Collection
                                   fp_v_dummy           TYPE abap_bool
                          CHANGING fp_ex_return         TYPE bapiretct.

  DATA: lv_flag TYPE flag. " General Flag

  lv_flag = fp_v_dummy.

  CALL FUNCTION 'ZQTC_BP_CREDIT_COLLECTION_LH'
    EXPORTING
      im_data_key       = fp_st_data_key
      im_crdt_coll_data = st_crdt_coll_data
      im_update_task    = lv_flag
      im_allow_change   = abap_true
    IMPORTING
      ex_return         = fp_ex_return.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_GEN_DATA_MSG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_V_LOG_HANDLE  TYPE balloghndl
*      <--FP_I_RETURN      TYPE bapiret2_t
*----------------------------------------------------------------------*
FORM f_update_gen_data_msg  USING    fp_v_log_handle TYPE balloghndl " Application Log: Log Handle
                                     fp_i_return     TYPE bapiret2_t
                            CHANGING fp_li_messages  TYPE bapiretct.

*====================================================================*
*  Local Work-Area
*====================================================================*
  DATA:lst_return  TYPE bapiret2, " Return Parameter
       lst_message TYPE bapiretc, " Return Parameter for Complex Data Type
*====================================================================*
*  Local Variable
*====================================================================*
       lv_message  TYPE string.
*====================================================================*
*Add message to Application Log - Messages of General Data processing
*====================================================================*
  CLEAR lst_return.
  LOOP AT i_return INTO lst_return.

    CLEAR lv_message.

    MESSAGE ID lst_return-id
    TYPE       lst_return-type
    NUMBER     lst_return-number
    INTO       lv_message
    WITH       lst_return-message_v1
               lst_return-message_v2
               lst_return-message_v3
               lst_return-message_v4.
*--------------------------------------------------------------------*
*    Update message
*--------------------------------------------------------------------*
*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
*    IF v_dummy = abap_true.
*      PERFORM f_log_info  USING fp_v_log_handle
*                                lst_return-type  " Message Type
*                                'Input-'(L01)
*                                'General Data Message:'(l08)
*                                lv_message
*                                c_gen_data
*                                c_nodetype_i.
*    ELSE.
*      PERFORM f_log_info  USING fp_v_log_handle
*                                lst_return-type  " Message Type
*                                'Output-'(I02)
*                                'General Data Message:'(l08)
*                                lv_message
*                                c_gen_data
*                                c_nodetype_i.
*    ENDIF.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_v_log_handle
*                               lst_return-type
*                               'Output-'(I02)
*                               'General Data Message: '(l08)
*                               lv_message.
*====================================================================*
*Add message to Exprting table
*====================================================================*
    CLEAR lst_message.
    lst_message-type          = lst_return-type.
    lst_message-id            = lst_return-id.
    lst_message-number        = lst_return-number.
    lst_message-message       = lv_message.
    lst_message-log_no        = lst_return-log_no.
    lst_message-log_msg_no    = lst_return-log_msg_no.
    lst_message-message_v1    = lst_return-message_v1.
    lst_message-message_v2    = lst_return-message_v2.
    lst_message-message_v3    = lst_return-message_v3.
    lst_message-message_v4    = '008'
    . "lst_return-message_v4.
    lst_message-system        = lst_return-system.

    APPEND lst_message TO fp_li_messages.
    CLEAR  lst_message.
  ENDLOOP. " LOOP AT i_return INTO lst_return



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPD_COMP_SALES_INPUT_IN_APP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_V_LOG_HANDLE  text
*      <--FP_I_COMP_DATA  text
*      <--FP_I_SALES_SATA  text
*----------------------------------------------------------------------*
FORM f_upd_comp_sales_input_in_app  USING    fp_v_log_handle TYPE balloghndl " Application Log: Log Handle
                                    CHANGING fp_i_comp_data  TYPE cmds_ei_company_t
                                             fp_i_sales_data TYPE cmds_ei_sales_t.
*====================================================================*
* Local Work-area
*====================================================================*
  DATA:lst_company TYPE cmds_ei_company, " Ext. Interface: Company Code Data
       lst_sales   TYPE cmds_ei_sales.   " Ext. Interface: Sales Data
*====================================================================*
*Add Company Data to Application Log
*====================================================================*
  CLEAR lst_company.
  LOOP AT fp_i_comp_data INTO lst_company.
*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    IF v_dummy = abap_true.
      PERFORM f_log_info  USING fp_v_log_handle
                          c_msgty_info " Message Type - (I)nformation
                          'Input-'(l01)
                          'Company Code:'(l09)
                          lst_company-data_key-bukrs
                          c_input_data
                          c_nodetype_i.
    ELSE.
      PERFORM f_log_info  USING fp_v_log_handle
                                c_msgty_info " Message Type - (I)nformation
                                'Input-'(l01)
                                'Company Code:'(l09)
                                lst_company-data_key-bukrs
                                c_comp_sales
                                c_nodetype_i.
    ENDIF.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_v_log_handle
*                               c_msgty_info "Message Type - (I)nformation
*                               'Input-'(l01)
*                               'Company Code: '(l09)
*                               lst_company-data_key-bukrs.
  ENDLOOP. " LOOP AT fp_i_comp_data INTO lst_company
*====================================================================*
*Add Sales Data to Application Log
*====================================================================*
  CLEAR lst_sales.
  LOOP AT fp_i_sales_data INTO lst_sales.
*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    IF v_dummy = abap_true.
      PERFORM f_log_info  USING fp_v_log_handle
                                c_msgty_info       " Message Type - (I)nformation
                                'Input-'(l01)
                                'Sales Organization:'(l10)
                                lst_sales-data_key-vkorg
                                c_input_data
                                c_nodetype_i.
    ELSE.
      PERFORM f_log_info  USING fp_v_log_handle
                                c_msgty_info       " Message Type - (I)nformation
                                'Input-'(l01)
                                'Sales Organization:'(l10)
                                lst_sales-data_key-vkorg
                                c_comp_sales
                                c_nodetype_i.
    ENDIF.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_v_log_handle
*                               c_msgty_info "Message Type - (I)nformation
*                               'Input-'(l01)
*                               'Sales Organization: '(l10)
*                               lst_sales-data_key-vkorg.

*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    IF v_dummy = abap_true.
      PERFORM f_log_info  USING fp_v_log_handle
                                c_msgty_info       " Message Type - (I)nformation
                                'Input-'(l01)
                                'Distribution Channel:'(l11)
                                lst_sales-data_key-vtweg
                                c_input_data
                                c_nodetype_i.
    ELSE.
      PERFORM f_log_info  USING fp_v_log_handle
                                c_msgty_info       " Message Type - (I)nformation
                                'Input-'(l01)
                                'Distribution Channel:'(l11)
                                lst_sales-data_key-vtweg
                                c_comp_sales
                                c_nodetype_i.
    ENDIF.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_v_log_handle
*                               c_msgty_info "Message Type - (I)nformation
*                               'Input-'(l01)
*                               'Distribution Channel: '(l11)
*                               lst_sales-data_key-vtweg.

*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    IF v_dummy = abap_true.
      PERFORM f_log_info  USING fp_v_log_handle
                                c_msgty_info       " Message Type - (I)nformation
                                'Input-'(l01)
                                'Division:'(l12)
                                lst_sales-data_key-spart
                                c_input_data
                                c_nodetype_i.
    ELSE.
      PERFORM f_log_info  USING fp_v_log_handle
                                c_msgty_info       " Message Type - (I)nformation
                                'Input-'(l01)
                                'Division:'(l12)
                                lst_sales-data_key-spart
                                c_comp_sales
                                c_nodetype_i.
    ENDIF.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_v_log_handle
*                               c_msgty_info "Message Type - (I)nformation
*                               'Input-'(l01)
*                               'Division: '(l12)
*                               lst_sales-data_key-spart.

  ENDLOOP. " LOOP AT fp_i_sales_data INTO lst_sales


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPD_CUST_COMP_SALES_RET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_V_LOG_HANDLE  TYPE BALLOGHNDL
*      -->FP_ST_ERROR      TYPE CVIS_MESSAGE
*      <--FP_EX_RETURN     TYPE ZTQTC_CUSTOMER_DATE_OUTPUTS
*----------------------------------------------------------------------*
FORM f_upd_cust_comp_sales_ret  USING    fp_v_log_handle TYPE balloghndl   " Application Log: Log Handle
                                         fp_st_error     TYPE cvis_message " Error Indicator and System Messages
                               CHANGING  fp_ex_return    TYPE ztqtc_customer_date_outputs.
*====================================================================*
* Local Work-area
*====================================================================*
  DATA:lst_return      TYPE bapiret2, " Return Parameter
       lst_message     TYPE bapiretc, " Return Parameter for Complex Data Type
       lv_warning_flag TYPE c,
*====================================================================*
* Local Variable
*====================================================================*
       lv_message      TYPE string.
*====================================================================*
* Local Field-Symbols
*====================================================================*
  FIELD-SYMBOLS:<lst_ex_ret> TYPE zstqtc_customer_date_output. " I0200: Customer Data (Customer / BP Number, Messages)
*====================================================================*
*  Local Constant
*====================================================================*
  CONSTANTS: lc_s    TYPE bapi_mtype VALUE 'S', " Message type: S Success, E Error, W Warning, I Info, A Abort
             lc_w    TYPE bapi_mtype VALUE 'W', " Message type: S Success, E Error, W Warning, I Info, A Abort
             lc_a    TYPE bapi_mtype VALUE 'A', " Message type: S Success, E Error, W Warning, I Info, A Abort
             lc_dash TYPE char1      VALUE '-'. " Dash of type CHAR1
  CLEAR lst_return.

  IF fp_st_error-messages[] IS NOT INITIAL.
    LOOP AT fp_st_error-messages INTO lst_return.
      CLEAR lv_message.

      MESSAGE ID lst_return-id
      TYPE       lst_return-type
      NUMBER     lst_return-number
      INTO       lv_message
      WITH       lst_return-message_v1
                 lst_return-message_v2
                 lst_return-message_v3
                 lst_return-message_v4.
*--------------------------------------------------------------------*
*    Update message
*--------------------------------------------------------------------*
*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
*      IF v_dummy = abap_true.
*        PERFORM f_log_info  USING fp_v_log_handle
*                                  lst_return-type    " Message Type
*                                  'Input-'(L01)
*                                  'Company Code/Sales Area Message:'(l13)
*                                  lv_message
*                                  c_input_data
*                                  c_nodetype_i.
*      ELSE.
*        PERFORM f_log_info  USING fp_v_log_handle
*                                  lst_return-type    " Message Type
*                                  'Output-'(I02)
*                                  'Company Code/Sales Area Message:'(l13)
*                                  lv_message
*                                  c_comp_sales
*                                  c_nodetype_i.
*      ENDIF.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*      PERFORM f_log_add    USING fp_v_log_handle
*                                 lst_return-type
*                                 'Output-'(I02)
*                                 'Company Code/Sales Area Message:'(l13)
*                                 lv_message.
*--------------------------------------------------------------------*
*    Update Exporting parameter
*--------------------------------------------------------------------*
      READ TABLE fp_ex_return ASSIGNING <lst_ex_ret> INDEX v_index.
      IF sy-subrc NE 0.
        APPEND INITIAL LINE TO fp_ex_return ASSIGNING <lst_ex_ret>.
      ENDIF. " IF sy-subrc NE 0
      IF <lst_ex_ret> IS ASSIGNED.
        CLEAR lst_message.
        lst_message-type          = lst_return-type.
        lst_message-id            = lst_return-id.
        lst_message-number        = lst_return-number.
        lst_message-message       = lst_return-message.
        lst_message-log_no        = lst_return-log_no.
        lst_message-log_msg_no    = lst_return-log_msg_no.
        lst_message-message_v1    = lst_return-message_v1.
        lst_message-message_v2    = lst_return-message_v2.
        lst_message-message_v3    = lst_return-message_v3.
        lst_message-message_v4    = '009'."lst_return-message_v4.
        lst_message-system        = lst_return-system.
        IF lst_message-type = c_e OR lst_message-type = c_s OR lst_message-type = lc_a.
          lv_warning_flag = abap_true.
        ENDIF.
        APPEND lst_message TO <lst_ex_ret>-messages.
        CLEAR  lst_message.

      ENDIF. " IF <lst_ex_ret> IS ASSIGNED
    ENDLOOP. " LOOP AT fp_st_error-messages INTO lst_return
  ELSE. " ELSE -> IF fp_st_error-messages[] IS NOT INITIAL
*   For success case -system doesnot any value hence we insert
*   another message.
    " Partner & has been extended to Company Codes successfully!

    CLEAR lv_message.
    CALL FUNCTION 'FORMAT_MESSAGE'
      EXPORTING
        id   = c_msgid_zrtr
        lang = sy-langu
        no   = c_msgno_026
        v1   = v_partner
      IMPORTING
        msg  = lv_message.

*--------------------------------------------------------------------*
*    Update message
*--------------------------------------------------------------------*
*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
*    IF v_dummy = abap_true.
*      PERFORM f_log_info  USING fp_v_log_handle
*                                c_msgty_info     " Message Type - (I)nformation
*                                'Input-'(L01)
*                                'Company Code/Sales Area Message:'(l13)
*                                lv_message
*                                c_input_data
*                                c_nodetype_i.
*    ELSE.
*      PERFORM f_log_info  USING fp_v_log_handle
*                                c_msgty_info     " Message Type - (I)nformation
*                                'Output-'(I02)
*                                'Company Code/Sales Area Message:'(l13)
*                                lv_message
*                                c_comp_sales
*                                c_nodetype_i.
*    ENDIF.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_v_log_handle
*                               c_msgty_info "Message Type - (I)nformation
*                               'Output-'(I02)
*                               'Company Code/Sales Area Message:'(l13)
*                               lv_message.
*--------------------------------------------------------------------*
*    Update Exporting parameter
*--------------------------------------------------------------------*
    READ TABLE fp_ex_return ASSIGNING <lst_ex_ret> INDEX v_index.
    IF <lst_ex_ret> IS ASSIGNED.
      CLEAR lst_message.
      lst_message-type          = lc_s.
      lst_message-id            = c_msgid_zrtr.
      lst_message-number        = c_msgno_026.
      lst_message-message       = lv_message.
      lst_message-message_v4 = '009'.
      CONCATENATE sy-sysid
                  sy-mandt
                  INTO
                  lst_message-system
                  SEPARATED BY lc_dash.

      APPEND lst_message TO <lst_ex_ret>-messages.
      CLEAR  lst_message.

    ENDIF. " IF <lst_ex_ret> IS ASSIGNED
  ENDIF . " IF fp_st_error-messages[] IS NOT INITIAL
*--*Build success message when ther is only warning
  IF fp_st_error-messages[] IS NOT INITIAL AND lv_warning_flag IS INITIAL.
    CLEAR lv_message.
    CALL FUNCTION 'FORMAT_MESSAGE'
      EXPORTING
        id   = c_msgid_zrtr
        lang = sy-langu
        no   = c_msgno_026
        v1   = v_partner
      IMPORTING
        msg  = lv_message.
    READ TABLE fp_ex_return ASSIGNING <lst_ex_ret> INDEX v_index.
    IF <lst_ex_ret> IS ASSIGNED.
      CLEAR lst_message.
      lst_message-type          = lc_s.
      lst_message-id            = c_msgid_zrtr.
      lst_message-number        = c_msgno_026.
      lst_message-message       = lv_message.
      lst_message-message_v4 = '009'.
      CONCATENATE sy-sysid
                  sy-mandt
                  INTO
                  lst_message-system
                  SEPARATED BY lc_dash.

      APPEND lst_message TO <lst_ex_ret>-messages.
      CLEAR  lst_message.

    ENDIF. " IF <lst_ex_ret> IS ASSIGNED
  ENDIF.
  CLEAR : lv_warning_flag.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPD_LOG_CRDT_COLL_INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_I_CRDT_SEG  text
*      -->FP_I_COLL_SEG  text
*----------------------------------------------------------------------*
FORM f_upd_log_crdt_coll_input  USING  fp_v_log_handle TYPE balloghndl " Application Log: Log Handle
                                       fp_i_crdt_seg   TYPE ztqtc_credit_seg_data
                                       fp_i_coll_seg   TYPE ztqtc_collection_seg_data.
*====================================================================*
* Local Structure
*====================================================================*
  DATA: lst_crdt_seg TYPE z1rtr_bp_credit_seg_data, " C030: BP Credit Management Data (Credit Segment)
        lst_coll_seg TYPE z1rtr_bp_coll_seg_data.   " C030: BP Collection Management Data (Collection Segment)
*====================================================================*
*    Credit Segment
*====================================================================*
  CLEAR lst_crdt_seg.
  LOOP AT fp_i_crdt_seg INTO lst_crdt_seg.

*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    IF v_dummy = abap_true.
      PERFORM f_log_info  USING fp_v_log_handle
                                c_msgty_info          " Message Type - (I)nformation
                                'Input-'(l01)
                                'Credit Segment:'(l14)
                                lst_crdt_seg-credit_sgmnt
                                c_input_data
                                c_nodetype_i.
    ELSE.
      PERFORM f_log_info  USING fp_v_log_handle
                                c_msgty_info          " Message Type - (I)nformation
                                'Input-'(l01)
                                'Credit Segment:'(l14)
                                lst_crdt_seg-credit_sgmnt
                                c_cred_coll
                                c_nodetype_i.
    ENDIF.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_v_log_handle
*                               c_msgty_info " Message Type - (I)nformation
*                               'Input-'(l01)
*                               'Credit Segment : '(l14)
*                               lst_crdt_seg-credit_sgmnt.

  ENDLOOP. " LOOP AT fp_i_crdt_seg INTO lst_crdt_seg
*====================================================================*
*    Collection Segment
*====================================================================*
  CLEAR lst_coll_seg.
  LOOP AT fp_i_coll_seg INTO lst_coll_seg.

*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    IF v_dummy = abap_true.
      PERFORM f_log_info  USING fp_v_log_handle
                                c_msgty_info     " Message Type - (I)nformation
                                'Input-'(l01)
                                'Collection Segment:'(l15)
                                lst_coll_seg-coll_segment
                                c_input_data
                                c_nodetype_i.
    ELSE.
      PERFORM f_log_info  USING fp_v_log_handle
                                c_msgty_info     " Message Type - (I)nformation
                                'Input-'(l01)
                                'Collection Segment:'(l15)
                                lst_coll_seg-coll_segment
                                c_cred_coll
                                c_nodetype_i.
    ENDIF.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_v_log_handle
*                               c_msgty_info " Message Type - (I)nformation
*                               'Input-'(l01)
*                               'Collection Segment: '(l15)
*                               lst_coll_seg-coll_segment.

  ENDLOOP. " LOOP AT fp_i_coll_seg INTO lst_coll_seg

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POP_PARTNER_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_PARTNER  text
*----------------------------------------------------------------------*
FORM f_pop_partner_info  USING    fp_v_partner       TYPE bu_partner         " Business Partner Number
*                                  fp_v_seq_id        TYPE numc4              " Count parameters
                                  fp_id_number       TYPE bu_id_number       " Identification Number
                                  fp_v_log_handle    TYPE balloghndl         " Application Log: Log Handle
                                  fp_i_return        TYPE bapiret2_t
                                  fp_v_object_inst   TYPE bus_ei_object_task " External Interface: Change Indicator Object
                         CHANGING fp_lst_master_data TYPE cmds_ei_main       " Ext. Interface: Total Custom
                                  fp_ex_return       TYPE ztqtc_customer_date_outputs.

*====================================================================*
* Local Internal Table
*====================================================================*
  DATA:li_phone    TYPE cvis_ei_phone_t,
       li_fax      TYPE cvis_ei_fax_t,
       li_messages TYPE bapiretct,
*====================================================================*
* Local Work-area
*====================================================================*
       lst_extern  TYPE cmds_ei_extern. " Complex External InterfaceZTQTC_CUSTOMER_DATE_OUTPUTS                         for Customers
*====================================================================*
* Local Field Symbols
*====================================================================*
  FIELD-SYMBOLS : <lst_extern> TYPE cmds_ei_extern,              " Complex External Interface for Customers
                  <lst_phone>  TYPE cvis_ei_phone_str,           " Ext. Interface: Telephone Numbers
                  <lst_fax>    TYPE cvis_ei_fax_str,             " Ext. Interface: Fax Numbers
                  <lst_ex_ret> TYPE zstqtc_customer_date_output. " I0200: Customer Data (Customer / BP Number, Messages)

**** Begin of: CR#7751 KKR20180928  ED2K913240
**   Changes to fine tune SLG LOGs
*  PERFORM f_log_info  USING fp_v_log_handle
*                            c_msgty_info " Message Type - (I)nformation
*                            'General Data Updation Log:'(LG2)
*                            space
*                            space
*                            c_gen_data
*                            c_nodetype_h.
**** End of: CR#7751 KKR20180928  ED2K913240

  CLEAR: lst_extern.
  lst_extern-header-object_instance-kunnr = fp_v_partner.
  lst_extern-header-object_task           = c_m.
  APPEND lst_extern TO fp_lst_master_data-customers.

  cmd_ei_api_extract=>get_data( EXPORTING is_master_data = fp_lst_master_data
                                IMPORTING es_master_data = fp_lst_master_data ).

  READ TABLE fp_lst_master_data-customers ASSIGNING <lst_extern> INDEX 1.
  IF <lst_extern> IS NOT INITIAL.

    APPEND INITIAL LINE TO fp_ex_return ASSIGNING <lst_ex_ret>.
    IF <lst_ex_ret> IS ASSIGNED.
      <lst_ex_ret>-partner_info-partner      = fp_v_partner.
      <lst_ex_ret>-partner_info-cdm_ecid     = fp_id_number.
      <lst_ex_ret>-partner_info-name1        = <lst_extern>-central_data-address-postal-data-name.
      <lst_ex_ret>-partner_info-name2        = <lst_extern>-central_data-address-postal-data-name_2.
      <lst_ex_ret>-partner_info-name3        = <lst_extern>-central_data-address-postal-data-name_3.
      <lst_ex_ret>-partner_info-name4        = <lst_extern>-central_data-address-postal-data-name_4.
      <lst_ex_ret>-partner_info-city1        = <lst_extern>-central_data-address-postal-data-city.
      <lst_ex_ret>-partner_info-city2        = <lst_extern>-central_data-address-postal-data-district.
      <lst_ex_ret>-partner_info-post_code1   = <lst_extern>-central_data-address-postal-data-postl_cod1.
      <lst_ex_ret>-partner_info-post_code2   = <lst_extern>-central_data-address-postal-data-postl_cod2.
      <lst_ex_ret>-partner_info-street       = <lst_extern>-central_data-address-postal-data-street.
      <lst_ex_ret>-partner_info-str_suppl1   = <lst_extern>-central_data-address-postal-data-str_suppl1.
      <lst_ex_ret>-partner_info-str_suppl2   = <lst_extern>-central_data-address-postal-data-str_suppl2.
      <lst_ex_ret>-partner_info-str_suppl3   = <lst_extern>-central_data-address-postal-data-str_suppl3.
      <lst_ex_ret>-partner_info-house_num1   = <lst_extern>-central_data-address-postal-data-house_no.
      <lst_ex_ret>-partner_info-country      = <lst_extern>-central_data-address-postal-data-country.
      <lst_ex_ret>-partner_info-region       = <lst_extern>-central_data-address-postal-data-region.
      <lst_ex_ret>-partner_info-po_box       = <lst_extern>-central_data-address-postal-data-po_box.
      <lst_ex_ret>-partner_info-po_box_loc   = <lst_extern>-central_data-address-postal-data-po_box_cit.
      <lst_ex_ret>-partner_info-po_box_reg   = <lst_extern>-central_data-address-postal-data-po_box_reg.
      <lst_ex_ret>-partner_info-po_box_cty   = <lst_extern>-central_data-address-postal-data-pobox_ctry.
      <lst_ex_ret>-partner_info-upd_ind      = fp_v_object_inst.

      li_phone[] = <lst_extern>-central_data-address-communication-phone-phone[].
      li_fax[]   = <lst_extern>-central_data-address-communication-fax-fax[].

      READ TABLE li_phone ASSIGNING <lst_phone> INDEX 1.
      IF sy-subrc IS INITIAL AND <lst_phone> IS ASSIGNED.
        <lst_ex_ret>-partner_info-tel_number = <lst_phone>-contact-data-telephone.
        <lst_ex_ret>-partner_info-tel_extens = <lst_phone>-contact-data-extension.
      ENDIF. " IF sy-subrc IS INITIAL AND <lst_phone> IS ASSIGNED
*      READ TABLE li_fax ASSIGNING <lst_fax> INDEX 1.
*      IF sy-subrc IS INITIAL AND <lst_fax> IS ASSIGNED.
*
*        <lst_ex_ret>-partner_info-fax_number = <lst_fax>-contact-data-fax.
*        <lst_ex_ret>-partner_info-fax_extens = <lst_fax>-contact-data-extension.
*
*      ENDIF. " IF sy-subrc IS INITIAL AND <lst_fax> IS ASSIGNED

      PERFORM f_update_gen_data_msg USING    fp_v_log_handle
                                             fp_i_return
                                    CHANGING li_messages.

      <lst_ex_ret>-messages = li_messages[].

    ENDIF. " IF <lst_ex_ret> IS ASSIGNED
  ENDIF. " IF <lst_extern> IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPD_COMP_SALES_DET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_V_LOG_HANDLE  text
*      -->FP_V_PARTNER  text
*      -->FP_ST_ADD_GENERAL_DATA  text
*      -->FP_I_COMP_DATA  text
*      -->FP_I_SALES_DATA  text
*      <--FP_ST_ERROR  text
*      <--FP_ST_MASTER_DATA  text
*      <--FP_EX_RETURN  text
*----------------------------------------------------------------------*
FORM f_upd_comp_sales_det  USING    fp_v_log_handle    TYPE balloghndl               " Application Log: Log Handle
                                    fp_v_partner       TYPE bu_partner               " Business Partner Number
                                    fp_st_add_general_data TYPE cmds_ei_central_data " External Interface: Central Data
                                    fp_i_comp_data     TYPE cmds_ei_company_t
                                    fp_i_sales_data    TYPE cmds_ei_sales_t
                                    fp_v_dummy         TYPE abap_bool
                           CHANGING fp_st_error        TYPE cvis_message             " Error Indicator and System Messages
                                    fp_st_master_data  TYPE cmds_ei_main             " Ext. Interface: Total Customer Data
                                    fp_ex_return       TYPE ztqtc_customer_date_outputs.
*====================================================================*
*    Update Company Codes & Sales data to Application Log(input)
*====================================================================*
*  PERFORM f_upd_comp_sales_input_in_app  USING    fp_v_log_handle
*                                         CHANGING fp_i_comp_data
*                                                  fp_i_sales_data.
*====================================================================*
*    Update Company Codes & Sales data to Customers
*====================================================================*
  PERFORM f_upd_cust_com_sales USING fp_v_partner
                                     fp_st_add_general_data
                                     fp_i_comp_data
                                     fp_i_sales_data
                                     fp_v_dummy
                               CHANGING
                                     fp_st_error
                                     fp_st_master_data.
*====================================================================*
*  Update Company Codes & Sales data Processing returns to Application
*  log & Exporting parameters
*====================================================================*
  PERFORM f_upd_cust_comp_sales_ret  USING    fp_v_log_handle
                                              fp_st_error
                                     CHANGING fp_ex_return.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPD_CRDT_COLL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_LOG_HANDLE  text
*      -->P_I_CRDT_SEG  text
*      -->P_I_COLL_SEG  text
*      -->P_ST_DATA_KEY  text
*      -->P_ST_CRDT_COLL_DATA  text
*      <--FP_COLL_RETURN
*      <--FP_EX_RETURN  text
*----------------------------------------------------------------------*
FORM f_upd_crdt_coll_data  USING    fp_v_log_handle      TYPE balloghndl                    " Application Log: Log Handle
                                    fp_v_partner         TYPE bu_partner                    " Business Partner Number
                                    fp_i_crdt_seg        TYPE ztqtc_credit_seg_data
                                    fp_i_coll_seg        TYPE ztqtc_collection_seg_data
                                    fp_st_data_key       TYPE zstqtc_bp_identification_key  " I0200: Details to Identify Business Partner
                                    fp_st_crdt_coll_data TYPE zstqtc_credit_collection_data " I0200: Customer master data distribution - Credit/Collection
                                    fp_v_dummy           TYPE abap_bool
                           CHANGING fp_i_coll_return     TYPE bapiretct
                                    fp_ex_return         TYPE ztqtc_customer_date_outputs.
**Begin of ADD:FMM5986:FMM8:MIMMADISET:09/27/2021:ED2K924618
  DATA:lv_actv_i0200 TYPE zactive_flag.
  CONSTANTS:lc_devid_i0200 TYPE zdevid         VALUE 'I0200',    " Development ID: I0200
            lc_katr9       TYPE zvar_key       VALUE 'KATR9',    " Attribute 9 in KNA1 field
            lc_tech1       TYPE bu_id_category VALUE 'TECH1',     "BP Identification Category
            lc_sno4_i0200  TYPE zsno           VALUE '004'.       " Serial Number: 004
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_devid_i0200            " Development ID: I0200
      im_ser_num     = lc_sno4_i0200             " Serial Number4: I0200
      im_var_key     = lc_katr9
    IMPORTING
      ex_active_flag = lv_actv_i0200.            " Active / Inactive Flag
  IF lv_actv_i0200 EQ abap_true.
    IF v_object_inst = c_u AND fp_v_partner IS NOT INITIAL
       AND st_crdt_coll_data-credit_data-credit_profile IS NOT INITIAL.
*-- get Credit Master Data for Partner
      SELECT SINGLE check_rule,
             risk_class,
             credit_group
        FROM ukmbp_cms
        INTO @DATA(ls_ukmbp_cms)
        WHERE partner = @fp_v_partner.
      IF sy-subrc = 0.
** Update Credit profile with primary company code details
** Overwrite the Risk class,check rule and credit_group if already exist in BP
        IF ls_ukmbp_cms-risk_class IS NOT INITIAL.
          st_crdt_coll_data-credit_data-credit_profile-risk_class = ls_ukmbp_cms-risk_class.
        ENDIF.
        IF ls_ukmbp_cms-check_rule IS NOT INITIAL.
          st_crdt_coll_data-credit_data-credit_profile-check_rule = ls_ukmbp_cms-check_rule.
        ENDIF.
        IF ls_ukmbp_cms-credit_group IS NOT INITIAL.
          st_crdt_coll_data-credit_data-credit_profile-credit_group = ls_ukmbp_cms-credit_group.
        ENDIF.
        CLEAR:ls_ukmbp_cms.
      ENDIF."IF sy-subrc = 0.
    ENDIF."IF v_object_inst = c_u AND fp_v_partner IS NOT INITIAL
  ENDIF."IF lv_actv_i0200 EQ abap_true.
**====================================================================*
*    Update Credit & Collective Segment data to BP
*====================================================================*
  PERFORM f_upd_crdt_coll_seg  USING    fp_st_data_key
                                        fp_st_crdt_coll_data
                                        fp_v_dummy
                               CHANGING fp_i_coll_return.
*====================================================================*
*  Update Credit / Collection Segment Processing returns to Application
*  Log & Exporting Parameter
*====================================================================*
  PERFORM f_create_app_log_for_output USING    fp_v_log_handle
                                               fp_i_coll_return
                                      CHANGING fp_ex_return.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DATA_VALIDATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_V_LOG_HANDLE  text
*      -->FP_ST_ADD_GENERAL_DATA  text
*      -->FP_I_COMP_DATA  text
*      -->FP_I_SALES_DATA  text
*      -->FP_I_CRDT_SEG  text
*      -->FP_I_COLL_SEG  text
*      -->FP_ST_DATA_KEY  text
*      -->FP_ST_CRDT_COLL_DATA  text
*      <--FP_V_PARTNER  text
*      <--FP_V_VALIDATION_SUCCESS  text
*      <--FP_EX_RETURN  text
*----------------------------------------------------------------------*
FORM f_data_validation  USING    fp_v_log_handle           TYPE balloghndl                    " Application Log: Log Handle
                                 fp_st_add_general_data    TYPE cmds_ei_central_data          " External Interface: Central Data
                                 fp_i_comp_data            TYPE cmds_ei_company_t
                                 fp_i_sales_data           TYPE cmds_ei_sales_t
                                 fp_i_crdt_seg             TYPE ztqtc_credit_seg_data
                                 fp_i_coll_seg             TYPE ztqtc_collection_seg_data
                                 fp_st_data_key            TYPE zstqtc_bp_identification_key  " I0200: Details to Identify Business Partner
                                 fp_st_crdt_coll_data      TYPE zstqtc_credit_collection_data " I0200: Customer master data distribution - Credit/Collection
                                 fp_v_dummy                TYPE abap_bool
                        CHANGING fp_v_validation_success   TYPE abap_bool
                                 fp_ex_return              TYPE ztqtc_customer_date_outputs.

*====================================================================*
*    Local Structure
*====================================================================*
  TYPES : BEGIN OF lty_const,
            devid	 TYPE zdevid,              " Development ID
            param1 TYPE	rvari_vnam,          " ABAP: Name of Variant Variable
            param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
            srno   TYPE tvarv_numb,          " ABAP: Current selection number
            sign   TYPE	tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
            opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
            low	   TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
            high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
          END OF lty_const.

*====================================================================*
*    Local Internal Table / Work-area / Variable
*====================================================================*
  DATA: li_return       TYPE zstqtc_customer_date_output, " I0200: Customer Data (Customer / BP Number, Messages)
        li_messages     TYPE bapiretct,
        lst_mess        TYPE bapiretc,                    " Return Parameter for Complex Data Type
        lst_const       TYPE lty_const,
        lst_master_data TYPE cmds_ei_main,                " Ext. Interface: Total Customer Data
*           Begin of ADD:ERP-3117:WROY:14-JUL-2017:ED2K907286
        lv_lock_arg     TYPE eqegraarg,                   " Argument String (=Key Fields) of Lock Entry
        li_enqueue_list TYPE wlf_seqg3_tab,               " List of the chosen lock entries
*           End   of ADD:ERP-3117:WROY:14-JUL-2017:ED2K907286
        lv_partner      TYPE bu_partner.                  " Business Partner Number

*====================================================================*
*    Local Constant
*====================================================================*
  CONSTANTS: lc_devid  TYPE zdevid     VALUE 'I0200',   " Development ID
             lc_param1 TYPE rvari_vnam VALUE 'PARTNER', " ABAP: Name of Variant Variable
             lc_param2 TYPE rvari_vnam VALUE 'DUMMY',   " ABAP: Name of Variant Variable
*            Begin of ADD:ERP-3117:WROY:14-JUL-2017:ED2K907286
             lc_but000 TYPE eqegraname VALUE 'BUT000',  " Elementary Lock of Lock Entry (Table Name - BUT000)
             lc_kna1   TYPE eqegraname VALUE 'KNA1',    " Elementary Lock of Lock Entry (Table Name - KNA1)
*            End   of ADD:ERP-3117:WROY:14-JUL-2017:ED2K907286
             lc_type_e TYPE bapi_mtype VALUE 'E',       " Message type: S Success, E Error, W Warning, I Info, A Abort
             lc_srno   TYPE tvarv_numb VALUE '01'.      " ABAP: Current selection number
*====================================================================*
*    Local Field-Symbol
*====================================================================*
  FIELD-SYMBOLS: <lst_return>  TYPE zstqtc_customer_date_output. " I0200: Customer Data (Customer / BP Number, Messages)


*====================================================================*
*    Get Dummy Customer maintained in ZCACONSTANT
*====================================================================*
* Begin of DEL:ERP-3117:WROY:14-JUL-2017:ED2K907286
*  SELECT SINGLE low               " Lower Value of Selection Condition
*                FROM zcaconstant " Wiley Application Constant Table
*                INTO  lv_partner
*                WHERE devid    EQ lc_devid
*                AND   param1   EQ lc_param1
*                AND   param2   EQ lc_param2
*                AND   srno     EQ lc_srno
*                AND   activate EQ abap_true.
*  IF sy-subrc IS INITIAL.
**No Actions
*  ENDIF. " IF sy-subrc IS INITIAL
* End   of DEL:ERP-3117:WROY:14-JUL-2017:ED2K907286

*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
  PERFORM f_log_info  USING fp_v_log_handle
                            c_msgty_info "Message Type - (I)nformation
                            'Input Data Pre Validation Log:'(LG1)
                            space
                            space
                            c_input_data
                            c_nodetype_h.
*** End of: CR#7751 KKR20180928  ED2K913240

* Begin of ADD:ERP-3117:WROY:14-JUL-2017:ED2K907286
  SELECT low
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE @DATA(li_partners)
   WHERE devid    EQ @lc_devid
     AND param1   EQ @lc_param1
     AND param2   EQ @lc_param2
     AND activate EQ @abap_true.
  IF sy-subrc EQ 0.
    LOOP AT li_partners ASSIGNING FIELD-SYMBOL(<lv_partner>).
*     Begin of ADD:ERP-5137:WROY:15-Nov-2017:ED2K909466
      CLEAR: fp_ex_return.
*     End   of ADD:ERP-5137:WROY:15-Nov-2017:ED2K909466
*     Prepare the Argument String (=Key Fields) of Lock Entry
      CONCATENATE sy-mandt      " Client
                  <lv_partner>  " Business Partner / Customer Number
             INTO lv_lock_arg.  " Argument String (=Key Fields) of Lock Entry
      CONDENSE lv_lock_arg.

*     Read lock entries from lock table (Business Partner: BUT000)
      CLEAR: li_enqueue_list.
      CALL FUNCTION 'ENQUEUE_READ'
        EXPORTING
          gname                 = lc_but000          " Granularity name (-> table name)
          garg                  = lv_lock_arg        " Granularity value(->values of key fields)
          guname                = space              " User name
        TABLES
          enq                   = li_enqueue_list    " List of the chosen lock entries
        EXCEPTIONS
          communication_failure = 1
          system_failure        = 2
          OTHERS                = 3.
      IF sy-subrc EQ 0 AND
         li_enqueue_list IS NOT INITIAL.
        CONTINUE.
      ENDIF.
*     Read lock entries from lock table (Customer Number: KNA1)
      CLEAR: li_enqueue_list.
      CALL FUNCTION 'ENQUEUE_READ'
        EXPORTING
          gname                 = lc_kna1            " Granularity name (-> table name)
          garg                  = lv_lock_arg        " Granularity value(->values of key fields)
          guname                = space              " User name
        TABLES
          enq                   = li_enqueue_list    " List of the chosen lock entries
        EXCEPTIONS
          communication_failure = 1
          system_failure        = 2
          OTHERS                = 3.
      IF sy-subrc EQ 0 AND
         li_enqueue_list IS NOT INITIAL.
        CONTINUE.
      ENDIF.
*     Business Partner / Customer Number which is not yet locked
      lv_partner = <lv_partner>.
* Begin of DEL:ERP-5137:WROY:15-Nov-2017:ED2K909466
*      EXIT.
*    ENDLOOP.
*  ENDIF.
*  IF lv_partner IS INITIAL.
*    CLEAR fp_v_validation_success.
*    RETURN.
*  ENDIF.
* End   of DEL:ERP-5137:WROY:15-Nov-2017:ED2K909466
* End   of ADD:ERP-3117:WROY:14-JUL-2017:ED2K907286

*====================================================================*
*    Company Codes & Sales data Update
*====================================================================*
      PERFORM f_upd_comp_sales_det USING fp_v_log_handle
                                         lv_partner
                                         fp_st_add_general_data
                                         fp_i_comp_data
                                         fp_i_sales_data
                                         fp_v_dummy
                                   CHANGING
                                         st_error
                                         lst_master_data
                                         fp_ex_return.
* Begin of ADD:ERP-5137:WROY:15-Nov-2017:ED2K909466
      CLEAR: li_messages.
      READ TABLE fp_ex_return ASSIGNING <lst_return> INDEX 1.
      IF sy-subrc EQ 0.
        li_messages[] = <lst_return>-messages[].
      ENDIF.
*     Message: Account &1 is currently blocked by user &2
      READ TABLE li_messages TRANSPORTING NO FIELDS
           WITH KEY id     = c_msgid_f2
                    number = c_msgno_042.
      IF sy-subrc EQ 0.
        CLEAR: lv_partner.
        CONTINUE.
      ENDIF.
*     Message: Object requested is currently locked by user &1
      READ TABLE li_messages TRANSPORTING NO FIELDS
           WITH KEY id     = c_msgid_mc
                    number = c_msgno_601.
      IF sy-subrc EQ 0.
        CLEAR: lv_partner.
        CONTINUE.
      ENDIF.
      EXIT.
    ENDLOOP.
  ENDIF.
  IF lv_partner IS INITIAL.
    CLEAR fp_v_validation_success.
    RETURN.
  ENDIF.
* End   of ADD:ERP-5137:WROY:15-Nov-2017:ED2K909466

*====================================================================*
*    Update Credit / Collection Segment Input in Application Log
*====================================================================*
  st_data_key-partner     = lv_partner.

  PERFORM f_upd_crdt_coll_data USING fp_v_log_handle
                                     lv_partner
                                     fp_i_crdt_seg
                                     fp_i_coll_seg
                                     fp_st_data_key
                                     fp_st_crdt_coll_data
                                     fp_v_dummy
                               CHANGING
                                     i_coll_return
                                     fp_ex_return.
*--------------------------------------------------------------------*
* Check if there is error or not
*--------------------------------------------------------------------*
  fp_v_validation_success = abap_true.
  LOOP AT fp_ex_return ASSIGNING <lst_return>.
    CLEAR:li_messages.
    li_messages[] = <lst_return>-messages[].

    READ TABLE li_messages
    INTO lst_mess
    TRANSPORTING NO FIELDS
    WITH KEY type = lc_type_e. " With key of type
    IF sy-subrc IS INITIAL.
      CLEAR fp_v_validation_success.
      EXIT.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDLOOP. " LOOP AT fp_ex_return ASSIGNING <lst_return>
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZE_GLOBAL_VARS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_initialize_global_vars.

  CLEAR:
    i_cust_input,
    i_comp_data,
    i_sales_data,
    i_coll_return,
    i_address_data,
    i_crdt_seg,
    i_coll_seg,
    i_but0id,
    i_return,
    st_cust_input,
    st_crdt_coll_data,
    st_data_key,
    st_person,
    st_org,
    st_error,
    st_master_data,
    v_partner,
    v_dummy,
    v_validation_success,
    v_log_handle,
    v_index,
    v_object_inst,
    v_partner_exists.


  FREE: gv_id_err,
        i_but000,
        i_but0id.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_CORE_IDS
*&---------------------------------------------------------------------*
*       Check against CORE IDs
*----------------------------------------------------------------------*
*      -->FP_I_IDENT_NUMBS  ID Numbers
*      <--FP_V_OBJECT_INST  Object Instance
*----------------------------------------------------------------------*
FORM f_check_core_ids  CHANGING fp_i_ident_numbs TYPE bus_ei_bupa_identification_t
                                fp_v_object_inst TYPE bus_ei_object_task. " External Interface: Change Indicator Object

  DATA:
    li_but0id TYPE tty_partner_id.

  FIELD-SYMBOLS:
    <lst_id_num> TYPE bus_ei_bupa_identification, " External Interface: Data for Creating an ID Number
    <lst_but0id> TYPE ty_partner_id.

  IF fp_i_ident_numbs[] IS NOT INITIAL.
*   Fetch BP: ID Numbers
    SELECT partner  " Business Partner Number
           type     " Business partner category
           idnumber " Identification Number
      FROM but0id   " BP: ID Numbers
      INTO TABLE li_but0id
       FOR ALL ENTRIES IN fp_i_ident_numbs
     WHERE type     EQ fp_i_ident_numbs-data_key-identificationcategory
       AND idnumber EQ fp_i_ident_numbs-data_key-identificationnumber.
    IF sy-subrc IS INITIAL.
      SORT li_but0id BY type idnumber partner.

      IF fp_v_object_inst = c_i. "Insert Indictor
        CLEAR: fp_v_object_inst.
      ELSE. " ELSE -> IF fp_v_object_inst = c_i
        LOOP AT fp_i_ident_numbs ASSIGNING <lst_id_num>.
          READ TABLE li_but0id ASSIGNING <lst_but0id>
               WITH KEY type     = <lst_id_num>-data_key-identificationcategory " With key of type
                        idnumber = <lst_id_num>-data_key-identificationnumber
               BINARY SEARCH.
          IF sy-subrc EQ 0.
*           Different BP IDs
            IF <lst_but0id>-partner NE <st_cust_input>-data_key-partner.
              CLEAR: fp_v_object_inst.
              EXIT.
            ENDIF. " IF <lst_but0id>-partner NE <st_cust_input>-data_key-partner
*           Since it is existing one, just update it
            <lst_id_num>-task = c_u.
          ENDIF. " IF sy-subrc EQ 0
        ENDLOOP. " LOOP AT fp_i_ident_numbs ASSIGNING <lst_id_num>
      ENDIF. " IF fp_v_object_inst = c_i
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF fp_i_ident_numbs[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_MESSAGE_LOG
*&---------------------------------------------------------------------*
*       Add Messages to Log
*----------------------------------------------------------------------*
*      -->FP_V_LOG_HANDLE  text
*      -->FP_ST_CUST_INPUT text
*      <--FP_EX_RETURN     text
*----------------------------------------------------------------------*
FORM f_populate_message_log  USING    fp_v_log_handle  TYPE balloghndl                 " Application Log: Log Handle
                                      fp_st_cust_input TYPE zstqtc_customer_date_input " I0200: Customer Data (Gen, Comp Code, Sales Area, Crdt/Coll)
                             CHANGING fp_ex_return     TYPE ztqtc_customer_date_outputs.

  FIELD-SYMBOLS:
    <lst_ex_ret>  TYPE zstqtc_customer_date_output, " I0200: Customer Data (Customer / BP Number, Messages)
    <lst_message> TYPE bapiretc.                    " Return Parameter for Complex Data Type

  PERFORM f_log_add    USING fp_v_log_handle
                             c_msgty_err
                             'Output-'(I02)
                             'General Data Message:'(l08)
                             'New ECID for existing CORE ID(s)'(l18).

  APPEND INITIAL LINE TO fp_ex_return ASSIGNING <lst_ex_ret>.
  IF <lst_ex_ret> IS ASSIGNED.
    <lst_ex_ret>-seq_id                    = fp_st_cust_input-seq_id.
    <lst_ex_ret>-partner_info-cdm_ecid     = fp_st_cust_input-data_key-id_number.

    APPEND INITIAL LINE TO <lst_ex_ret>-messages ASSIGNING <lst_message>.
    <lst_message>-type          = c_msgty_err.
    <lst_message>-id            = c_msgid_zrtr.
    <lst_message>-number        = c_msgno_000.
    <lst_message>-message       = 'New ECID for existing CORE ID(s)'(l18).
    <lst_message>-message_v1    = 'New ECID for existing CORE ID(s)'(l18).
  ENDIF. " IF <lst_ex_ret> IS ASSIGNED

  PERFORM f_log_save USING fp_v_log_handle.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPD_RELAT_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_V_LOG_HANGLE  text
*      -->FP_V_PARTNER  text
*      -->FP_I_RELATIONSHIP_DATA  text
*      -->FP_V_DUMMY  text
*      <--FP_EX_RETURN  text
*----------------------------------------------------------------------*
FORM f_upd_relat_status         USING    fp_v_log_handle         TYPE balloghndl " Application Log: Log Handle
                                         fp_v_partner            TYPE bu_partner " Business Partner Number
                                         fp_i_relationship_data  TYPE burs_ei_extern_t
                                         fp_i_partner_det        TYPE tty_partner_det
                                         fp_i_relat_but0id       TYPE tty_partner_id
                                         fp_v_dummy              TYPE abap_bool
                                CHANGING fp_ex_return            TYPE ztqtc_customer_date_outputs.

*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
*  PERFORM f_log_info  USING v_log_handle
*                            c_msgty_info     "  Message Type - (I)nformation
*                            'Relationships Data Updation Log:'(LG4)
*                            space
*                            space
*                            c_relations
*                            c_nodetype_h.
*** End of: CR#7751 KKR20180928  ED2K913240
*====================================================================*
*    Update Relationship data Input to Application log
*====================================================================*
*  PERFORM f_upd_log_relat_data_input  USING  fp_v_log_handle
*                                             fp_v_partner
*                                             fp_i_relationship_data.
*====================================================================*
*    Update Relationship data Update
*====================================================================*
  PERFORM f_update_relationship_data  USING fp_v_partner
                                            fp_i_relationship_data
                                            fp_i_partner_det
                                            fp_i_relat_but0id.
*====================================================================*
*    Update Relationship data output to Application log
*====================================================================*
  PERFORM f_upd_log_relat_data_output  USING fp_v_log_handle
                                             fp_v_partner
                                             i_return_relat
* Begin of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
                                    CHANGING fp_ex_return.
* End   of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPD_LOG_RELAT_DATA_INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_V_LOG_HANDLE  text
*      -->P_FP_I_RELATIONSHIP_DATA  text
*----------------------------------------------------------------------*
FORM f_upd_log_relat_data_input  USING    fp_v_log_handle        TYPE balloghndl " Application Log: Log Handle
                                          fp_v_partner           TYPE bu_partner " Business Partner Number
                                          fp_i_relationship_data TYPE burs_ei_extern_t.

  DATA: lst_relat_data TYPE burs_ei_extern. " Complex External Interface of a Relationship

  CLEAR lst_relat_data.
  LOOP AT fp_i_relationship_data INTO lst_relat_data.

*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    PERFORM f_log_info  USING fp_v_log_handle
                              c_msgty_info       " Message Type - (I)nformation
                              'Input-'(l01)
                              'Partner1:'(004)
                              fp_v_partner
                              c_relations
                              c_nodetype_i.

    PERFORM f_log_info  USING fp_v_log_handle
                              c_msgty_info       " Message Type - (I)nformation
                              'Input-'(l01)
                              'Partner2:'(l17)
                              lst_relat_data-header-object_instance-partner2-bpartner
                              c_relations
                              c_nodetype_i.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_v_log_handle
*                               c_msgty_info " Message Type - (I)nformation
*                              'Input-'(l01)
*                              'Partner2 '(l17)
*                               lst_relat_data-header-object_instance-partner2-bpartner.

*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    PERFORM f_log_info  USING fp_v_log_handle
                              c_msgty_info       " Message Type - (I)nformation
                              'Input-'(l01)
                              'Identification Category:'(l18)
                              lst_relat_data-header-object_instance-partner2-identificationcategory
                              c_relations
                              c_nodetype_i.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_v_log_handle
*                               c_msgty_info "Message Type - (I)nformation
*                              'Input-'(l01)
*                              'Identification Category '(l18)
*                               lst_relat_data-header-object_instance-partner2-identificationcategory.

*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    PERFORM f_log_info  USING fp_v_log_handle
                              c_msgty_info       " Message Type - (I)nformation
                              'Input-'(l01)
                              'Indentification Number:'(l19)
                              lst_relat_data-header-object_instance-partner2-identificationnumber
                              c_relations
                              c_nodetype_i.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_v_log_handle
*                               c_msgty_info "Message Type - (I)nformation
*                              'Input-'(l01)
*                              'Indentification Number'(l19)
*                               lst_relat_data-header-object_instance-partner2-identificationnumber.

*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
    PERFORM f_log_info  USING fp_v_log_handle
                              c_msgty_info      " Message Type - (I)nformation
                              'Input-'(l01)
                              'Relationship Category:'(l20)
                              lst_relat_data-header-object_instance-relat_category
                              c_relations
                              c_nodetype_i.
*** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_v_log_handle
*                               c_msgty_info " Message Type - (I)nformation
*                              'Input-'(l01)
*                              'Relationship Category'(l20)
*                               lst_relat_data-header-object_instance-relat_category.

  ENDLOOP. " LOOP AT fp_i_relationship_data INTO lst_relat_data
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_RELATIONSHIP_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_V_PARTNER  text
*      -->FP_I_RELATIONSHIP_DATA  text
*      -->FP_I_PARTNER_DET  text
*      -->FP_I_RELAT_BUT0ID  text
*----------------------------------------------------------------------*
FORM f_update_relationship_data  USING   fp_v_partner           TYPE bu_partner " Business Partner Number
                                         fp_i_relationship_data TYPE burs_ei_extern_t
                                         fp_i_partner_det       TYPE tty_partner_det
                                         fp_i_relat_but0id      TYPE tty_partner_id.

  DATA: li_data        TYPE burs_ei_extern_t,
        lst_return     TYPE bapireti,       " Return Parameter with Object Index and Key
        lst_partner_id TYPE ty_partner_id,
        lst_obj_msg    TYPE bapiretc,       " Return Parameter for Complex Data Type
        lst_data       TYPE burs_ei_extern, " Complex External Interface of a Relationship
        lst_relat_data TYPE burs_ei_extern, " Complex External Interface of a Relationship
*        Begin of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
        lst_header     TYPE burs_ei_header,
        li_return_2    TYPE bapirettab,
*        End   of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
        li_return      TYPE bapiretm.

  SORT fp_i_relat_but0id BY type idnumber.

  LOOP AT fp_i_relationship_data INTO lst_relat_data.
    IF lst_relat_data-header-object_instance-partner2-bpartner IS NOT INITIAL.

      lst_data-header-object_instance-partner1-bpartner               = fp_v_partner.
      lst_data-header-object_instance-partner1-bpartnerguid           = lst_relat_data-header-object_instance-partner1-bpartnerguid.
      lst_data-header-object_instance-partner1-identificationcategory = lst_relat_data-header-object_instance-partner1-identificationcategory.
      lst_data-header-object_instance-partner1-identificationnumber   = lst_relat_data-header-object_instance-partner1-identificationnumber.

*     lst_data-header-object_instance-partner2-bpartner               = lst_relat_data-header-object_instance-partner2-bpartner.
*     Convert to Internal Foemat (add leading Zeros)
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lst_relat_data-header-object_instance-partner2-bpartner
        IMPORTING
          output = lst_data-header-object_instance-partner2-bpartner.
      lst_data-header-object_instance-partner2-bpartnerguid           = lst_relat_data-header-object_instance-partner2-bpartnerguid.
      lst_data-header-object_instance-partner2-identificationcategory = lst_relat_data-header-object_instance-partner2-identificationcategory.
      lst_data-header-object_instance-partner2-identificationnumber   = lst_relat_data-header-object_instance-partner2-identificationnumber.

      lst_data-header-object_instance-relat_category                  = lst_relat_data-header-object_instance-relat_category.
      lst_data-header-object_instance-date_to                         = lst_relat_data-header-object_instance-date_to.
      lst_data-header-object_instance-difftypevalue                   = lst_relat_data-header-object_instance-difftypevalue.
      lst_data-header-object_task                                     = c_m.

      lst_data-central_data-main-data-date_from                       = lst_relat_data-central_data-main-data-date_from.
      lst_data-central_data-main-data-relation_kind                   = lst_relat_data-central_data-main-data-relation_kind.
      lst_data-central_data-main-data-defaultrelationship             = lst_relat_data-central_data-main-data-defaultrelationship.
      lst_data-central_data-main-data-date_to_new                     = lst_relat_data-central_data-main-data-date_to_new.
*     Begin of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
*     Analyze header
      lst_header = lst_data-header.
      CLEAR: li_return_2,
             lst_header-object_instance-date_to.
      PERFORM analyze_header_rel IN PROGRAM saplbupa_interface_service IF FOUND
       TABLES li_return_2
     CHANGING lst_header.
      IF lst_header-object_task = c_i. "Insert Indictor
        CLEAR: lst_data-central_data-main-data-date_to_new.
      ELSE.
        IF lst_data-central_data-main-data-date_to_new IS INITIAL.
          lst_data-central_data-main-data-date_to_new                 = lst_data-header-object_instance-date_to.
        ENDIF.
        CLEAR: lst_data-header-object_instance-date_to.
      ENDIF.
*     End   of ADD:CR#697:WROY:20-Oct-2017:ED2K909065

      IF lst_data-central_data-main-data-date_from IS NOT INITIAL.
        lst_data-central_data-main-datax-date_from                    = abap_true.
      ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-date_from IS NOT INITIAL
        lst_data-central_data-main-datax-date_from                    = abap_false.
      ENDIF. " IF lst_relat_data-central_data-main-data-date_from IS NOT INITIAL

      IF lst_data-central_data-main-data-relation_kind IS NOT INITIAL.
        lst_data-central_data-main-datax-relation_kind                = abap_true.
      ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-relation_kind IS NOT INITIAL
        lst_data-central_data-main-datax-relation_kind                = abap_false.
      ENDIF. " IF lst_relat_data-central_data-main-data-relation_kind IS NOT INITIAL

      IF lst_data-central_data-main-data-defaultrelationship IS NOT INITIAL.
        lst_data-central_data-main-datax-defaultrelationship          = abap_true.
      ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-defaultrelationship IS NOT INITIAL
        lst_data-central_data-main-datax-defaultrelationship          = abap_false.
      ENDIF. " IF lst_relat_data-central_data-main-data-defaultrelationship IS NOT INITIAL

      IF lst_data-central_data-main-data-date_to_new IS NOT INITIAL.
        lst_data-central_data-main-datax-date_to_new                  = abap_true.
      ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-date_to_new IS NOT INITIAL
        lst_data-central_data-main-datax-date_to_new                  = abap_false.
      ENDIF. " IF lst_relat_data-central_data-main-data-date_to_new IS NOT INITIAL

      lst_data-central_data-main-task                                 = c_m.

      APPEND lst_data TO li_data.
      CLEAR  lst_data.

    ELSE. " ELSE -> IF lst_relat_data-header-object_instance-partner2-bpartner IS NOT INITIAL

      CLEAR lst_partner_id.

      READ TABLE  fp_i_relat_but0id
      INTO lst_partner_id
      WITH KEY type     = lst_relat_data-header-object_instance-partner2-identificationcategory " With key of type
               idnumber = lst_relat_data-header-object_instance-partner2-identificationnumber
      BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        lst_data-header-object_instance-partner1-bpartner               = fp_v_partner.
        lst_data-header-object_instance-partner1-bpartnerguid           = lst_relat_data-header-object_instance-partner1-bpartnerguid.
        lst_data-header-object_instance-partner1-identificationcategory = lst_relat_data-header-object_instance-partner1-identificationcategory.
        lst_data-header-object_instance-partner1-identificationnumber   = lst_relat_data-header-object_instance-partner1-identificationnumber.

        lst_data-header-object_instance-partner2-bpartner               = lst_partner_id-partner.
        lst_data-header-object_instance-partner2-bpartnerguid           = lst_relat_data-header-object_instance-partner2-bpartnerguid.
        lst_data-header-object_instance-partner2-identificationcategory = lst_partner_id-type.
        lst_data-header-object_instance-partner2-identificationnumber   = lst_partner_id-idnumber.

        lst_data-header-object_instance-relat_category                  = lst_relat_data-header-object_instance-relat_category.
        lst_data-header-object_instance-date_to                         = lst_relat_data-header-object_instance-date_to.
        lst_data-header-object_instance-difftypevalue                   = lst_relat_data-header-object_instance-difftypevalue.
        lst_data-header-object_task                                     = c_m.

        lst_data-central_data-main-data-date_from                       = lst_relat_data-central_data-main-data-date_from.
        lst_data-central_data-main-data-relation_kind                   = lst_relat_data-central_data-main-data-relation_kind.
        lst_data-central_data-main-data-defaultrelationship             = lst_relat_data-central_data-main-data-defaultrelationship.
        lst_data-central_data-main-data-date_to_new                     = lst_relat_data-central_data-main-data-date_to_new.
*       Begin of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
*       Analyze header
        lst_header = lst_data-header.
        CLEAR: li_return_2,
               lst_header-object_instance-date_to.
        PERFORM analyze_header_rel IN PROGRAM saplbupa_interface_service IF FOUND
         TABLES li_return_2
       CHANGING lst_header.
        IF lst_header-object_task = c_i. "Insert Indictor
          CLEAR: lst_data-central_data-main-data-date_to_new.
        ELSE.
          IF lst_data-central_data-main-data-date_to_new IS INITIAL.
            lst_data-central_data-main-data-date_to_new                 = lst_data-header-object_instance-date_to.
          ENDIF.
          CLEAR: lst_data-header-object_instance-date_to.
        ENDIF.
*       End   of ADD:CR#697:WROY:20-Oct-2017:ED2K909065

        IF lst_data-central_data-main-data-date_from IS NOT INITIAL.
          lst_data-central_data-main-datax-date_from                    = abap_true.
        ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-date_from IS NOT INITIAL
          lst_data-central_data-main-datax-date_from                    = abap_false.
        ENDIF. " IF lst_relat_data-central_data-main-data-date_from IS NOT INITIAL

        IF lst_data-central_data-main-data-relation_kind IS NOT INITIAL.
          lst_data-central_data-main-datax-relation_kind                = abap_true.
        ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-relation_kind IS NOT INITIAL
          lst_data-central_data-main-datax-relation_kind                = abap_false.
        ENDIF. " IF lst_relat_data-central_data-main-data-relation_kind IS NOT INITIAL

        IF lst_data-central_data-main-data-defaultrelationship IS NOT INITIAL.
          lst_data-central_data-main-datax-defaultrelationship          = abap_true.
        ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-defaultrelationship IS NOT INITIAL
          lst_data-central_data-main-datax-defaultrelationship          = abap_false.
        ENDIF. " IF lst_relat_data-central_data-main-data-defaultrelationship IS NOT INITIAL

        IF lst_data-central_data-main-data-date_to_new IS NOT INITIAL.
          lst_data-central_data-main-datax-date_to_new                  = abap_true.
        ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-date_to_new IS NOT INITIAL
          lst_data-central_data-main-datax-date_to_new                  = abap_false.
        ENDIF. " IF lst_relat_data-central_data-main-data-date_to_new IS NOT INITIAL

        lst_data-central_data-main-task                                 = c_m.

        APPEND lst_data TO li_data.
        CLEAR  lst_data.

      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF lst_relat_data-header-object_instance-partner2-bpartner IS NOT INITIAL
  ENDLOOP. " LOOP AT fp_i_relationship_data INTO lst_relat_data

  IF li_data[] IS NOT INITIAL. " IF Condition is added for CR# 7751 changes
    CALL FUNCTION 'BUPA_INBOUND_REL_SAVE'
      EXPORTING
        data   = li_data
      IMPORTING
        return = li_return.

    IF li_return IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

*   Begin of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
      APPEND INITIAL LINE TO li_return ASSIGNING FIELD-SYMBOL(<lst_return>).
      APPEND INITIAL LINE TO <lst_return>-object_msg ASSIGNING FIELD-SYMBOL(<lst_obj_msg>).
      MESSAGE s455(c5) INTO <lst_obj_msg>-message.                             " Message Text
      <lst_obj_msg>-type   = sy-msgty.                                         " Message type: S Success, E Error, W Warning, I Info, A Abort
      <lst_obj_msg>-id     = sy-msgid.                                         " Message Class
      <lst_obj_msg>-number = sy-msgno.                                         " Message Number
      <lst_obj_msg>-message_v4 =  '010'.
*   End   of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
    ELSE.
      LOOP AT li_return ASSIGNING FIELD-SYMBOL(<lst_return1>)..
        LOOP AT <lst_return1>-object_msg ASSIGNING FIELD-SYMBOL(<lst_obj_msg1>).
          <lst_obj_msg1>-message_v4 =  '010'.
        ENDLOOP.
      ENDLOOP.
    ENDIF.
    APPEND LINES OF li_return TO i_return_relat.
    CLEAR li_return[].
  ENDIF. " IF li_data[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPD_LOG_RELAT_DATA_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_V_LOG_HANDLE  text
*      -->P_FP_V_PARTNER  text
*      -->P_I_RETURN_RELAT  text
*----------------------------------------------------------------------*
FORM f_upd_log_relat_data_output  USING    fp_v_log_handle    TYPE balloghndl " Application Log: Log Handle
                                           fp_v_partner       TYPE bu_partner " Business Partner Number
                                           fp_i_return_relat  TYPE bapiretm
* Begin of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
                                  CHANGING fp_ex_return       TYPE ztqtc_customer_date_outputs.
* End   of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
  DATA: lst_bapireti TYPE bapireti, " Return Parameter with Object Index and Key
        lst_bapiretc TYPE bapiretc, " Return Parameter for Complex Data Type
        li_bapiretct TYPE bapiretct, " ADD:ERP-7751:KKRAVURI:27-Sep-2018: ED2K913240
        lv_msg       TYPE bapi_msg,  " ADD:ERP-7751:KKRAVURI:27-Sep-2018: ED2K913240
        ls_trtab     TYPE trtab,     " ADD:ERP-7751:KKRAVURI:27-Sep-2018: ED2K913240
        lv_length    TYPE int2,      " ADD:ERP-7751:KKRAVURI:27-Sep-2018: ED2K913240
        lv_msgv1     TYPE msgv1,     " ADD:ERP-7751:KKRAVURI:27-Sep-2018: ED2K913240
        lv_msgv2     TYPE msgv2.     " ADD:ERP-7751:KKRAVURI:27-Sep-2018: ED2K913240

* Begin of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
  FIELD-SYMBOLS:<lst_ex_ret> TYPE zstqtc_customer_date_output. " I0200: Customer Data (Customer / BP Number, Messages)
* End   of ADD:CR#697:WROY:20-Oct-2017:ED2K909065

  CLEAR lst_bapireti.
  LOOP AT fp_i_return_relat INTO lst_bapireti.

*** Begin of: ERP-7751 KKR20180927  ED2K913240
** This piece of code is added to fine tune the SLG logs of Relationships data
*    li_bapiretct = lst_bapireti-object_msg.
*    READ TABLE li_bapiretct INTO DATA(list_bapiretct) INDEX 1.
*    lv_msg = list_bapiretct-message.
*    lst_bapireti-message_v4 = '010'.
*** End of: ERP-7751 KKR20180927  ED2K913240
*--------------------------------------------------------------------*
*    Update message
*--------------------------------------------------------------------*
*** Begin of: CR#7751 KKR20180928  ED2K913240
*   Changes to fine tune SLG LOGs
*    PERFORM f_log_info  USING fp_v_log_handle
*                              c_msgty_info     " Message Type - (I)nformation
*                              'Output-'(I02)
*                              lv_msg
*                              space
*                              c_relations
*                              c_nodetype_i.
**** End of: CR#7751 KKR20180928  ED2K913240
*** Below PERFORM is Commented for fine tune SLG LOGs on 20180928
*    PERFORM f_log_add    USING fp_v_log_handle
*                               c_msgty_info
*                               'Output-'(I02)
*                               lv_msg          " ADD:ERP-7751:KKRAVURI:27-Sep-2018: ED2K913240
*                               space.          " ADD:ERP-7751:KKRAVURI:27-Sep-2018: ED2K913240

*   Begin of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
*--------------------------------------------------------------------*
*   Update Exporting Parameter
*--------------------------------------------------------------------*
    READ TABLE fp_ex_return ASSIGNING <lst_ex_ret> INDEX v_index.
    IF sy-subrc NE 0.
      APPEND INITIAL LINE TO fp_ex_return ASSIGNING <lst_ex_ret>.
    ENDIF. " IF sy-subrc NE 0
    IF <lst_ex_ret> IS ASSIGNED.
      APPEND LINES OF lst_bapireti-object_msg TO <lst_ex_ret>-messages.
    ENDIF. " IF <lst_ex_ret> IS ASSIGNED
*   End   of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
  ENDLOOP. " LOOP AT fp_i_return_relat INTO lst_bapireti

*** Begin of: CR#7751 KKR20180927  ED2K913240
*  IF i_trtab[] IS NOT INITIAL.
*
*    REFRESH li_bapiretct.
*    LOOP AT i_trtab INTO ls_trtab.
**--------------------------------------------------------------------*
**    Update message
**--------------------------------------------------------------------*
*      lv_length = strlen( ls_trtab-line ).
*      IF lv_length LE 50.
*        lv_msgv1 = ls_trtab-line.
*      ELSEIF lv_length GT 50 AND lv_length LE 100.
*        lv_length = lv_length - 50.
*        lv_msgv1 = ls_trtab-line+0(50).
*        lv_msgv2 = ls_trtab-line+50(lv_length).
*      ENDIF.
*
*      PERFORM f_log_info  USING fp_v_log_handle
*                                c_msgty_info     " Message Type - (I)nformation
*                                'Output-'(I02)
*                                lv_msgv1
*                                lv_msgv2
*                                c_relations
*                                c_nodetype_i.
*
*      lst_bapiretc-type = c_msgty_info.
*      lst_bapiretc-message = ls_trtab-line.
*      APPEND lst_bapiretc TO li_bapiretct.
*      CLEAR: ls_trtab, lst_bapiretc, lv_msgv1, lv_msgv2.
*    ENDLOOP.
*
*    READ TABLE fp_ex_return ASSIGNING <lst_ex_ret> INDEX v_index.
*    IF sy-subrc NE 0.
*      APPEND INITIAL LINE TO fp_ex_return ASSIGNING <lst_ex_ret>.
*    ENDIF. " IF sy-subrc NE 0
*    IF <lst_ex_ret> IS ASSIGNED.
*      APPEND LINES OF li_bapiretct TO <lst_ex_ret>-messages.
*    ENDIF. " IF <lst_ex_ret> IS ASSIGNED
*
*    CLEAR i_trtab[].
*  ENDIF. " IF i_trtab[] IS NOT INITIAL.
*** End of: CR#7751 KKR20180927  ED2K913240

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DET_TAX_IND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--FP_LST_CUSTOMERS  text
*----------------------------------------------------------------------*
FORM f_det_tax_ind USING fp_ls_tax_ind   TYPE cmds_ei_cmd_tax_ind
                   CHANGING fp_lst_customers TYPE cmds_ei_extern. " Complex External Interface for Customers


  DATA: lt_tax_ind  TYPE  cmds_ei_tax_ind_t.
  DATA: ls_tax_ind  TYPE  cmds_ei_tax_ind.

  lt_tax_ind  = fp_ls_tax_ind-tax_ind.

  CONSTANTS:
    lc_dev_c059 TYPE zdevid     VALUE 'C059',    " Development ID
    lc_tax_cat  TYPE rvari_vnam VALUE 'TAX_CAT', " ABAP: Name of Variant Variable
    lc_taxkd_0  TYPE takld      VALUE '0'.       " Tax classification for customer

  IF fp_lst_customers-sales_data-sales[] IS NOT INITIAL.
*   Fetch Details from Wiley Application Constant Table
    SELECT low,                   "Lower Value of Selection Condition
           high                   "Upper Value of Selection Condition
      FROM zcaconstant            " Wiley Application Constant Table
      INTO TABLE @DATA(li_tax_cat)
     WHERE devid  EQ @lc_dev_c059 "Development ID
       AND param1 EQ @lc_tax_cat. "ABAP: Name of Variant Variable
    IF sy-subrc EQ 0.
      SORT li_tax_cat BY low.
    ENDIF. " IF sy-subrc EQ 0

*   Fetch Org.Unit: Allowed Plants per Sales Organization
    SELECT b~land1, "Country Key
           c~lfdnr, "Sequence for each country
           c~tatyp, "Tax category
           a~vkorg, "Sales Organization
           a~vtweg  "Distribution Channel
      FROM tvkwz AS a
     INNER JOIN t001w AS b ON a~werks EQ b~werks
     INNER JOIN tstl  AS c ON b~land1 EQ c~talnd
      INTO TABLE @DATA(li_tax_ind)
       FOR ALL ENTRIES IN @fp_lst_customers-sales_data-sales
     WHERE a~vkorg EQ @fp_lst_customers-sales_data-sales-data_key-vkorg
       AND a~vtweg EQ @fp_lst_customers-sales_data-sales-data_key-vtweg.
    IF sy-subrc EQ 0.
*     Nothing to do
    ENDIF. " IF sy-subrc EQ 0
*   Fetch Organizational Unit: Sales Organizations
    SELECT b~country, "Country Key
           c~lfdnr,   "Sequence for each country
           c~tatyp,   "Tax category
           a~vkorg    "Sales Organization
      FROM tvko AS a
     INNER JOIN adrc AS b ON a~adrnr   EQ b~addrnumber
     INNER JOIN tstl AS c ON b~country EQ c~talnd
  APPENDING TABLE @li_tax_ind
       FOR ALL ENTRIES IN @fp_lst_customers-sales_data-sales
     WHERE a~vkorg EQ @fp_lst_customers-sales_data-sales-data_key-vkorg.
    IF sy-subrc EQ 0.
*     Nothing to do
    ENDIF. " IF sy-subrc EQ 0

    IF li_tax_ind[] IS NOT INITIAL.
      SORT li_tax_ind BY land1 tatyp.
      DELETE ADJACENT DUPLICATES FROM li_tax_ind
               COMPARING land1 tatyp.

      LOOP AT li_tax_ind ASSIGNING FIELD-SYMBOL(<lst_tax_ind>).
        APPEND INITIAL LINE TO fp_lst_customers-central_data-tax_ind-tax_ind ASSIGNING FIELD-SYMBOL(<lst_cd_tax_ind>).
        <lst_cd_tax_ind>-task          = c_m.
        <lst_cd_tax_ind>-data_key-aland = <lst_tax_ind>-land1.
        <lst_cd_tax_ind>-data_key-tatyp = <lst_tax_ind>-tatyp.

        READ TABLE li_tax_cat ASSIGNING FIELD-SYMBOL(<lst_tax_cat>)
             WITH KEY low = <lst_tax_ind>-tatyp
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          <lst_cd_tax_ind>-data-taxkd = <lst_tax_cat>-high.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          <lst_cd_tax_ind>-data-taxkd = lc_taxkd_0.
        ENDIF. " IF sy-subrc EQ 0
        <lst_cd_tax_ind>-datax-taxkd  = abap_true.

      ENDLOOP. " LOOP AT li_tax_ind ASSIGNING FIELD-SYMBOL(<lst_tax_ind>)

      LOOP AT fp_lst_customers-central_data-tax_ind-tax_ind ASSIGNING FIELD-SYMBOL(<lst_cd_tax_ind1>).
        IF NOT lt_tax_ind[] IS INITIAL.
          READ TABLE lt_tax_ind INTO ls_tax_ind INDEX 1.
          IF sy-subrc = 0.
            <lst_cd_tax_ind1>-data-taxkd = ls_tax_ind-data-taxkd.
          ENDIF.
        ENDIF.
      ENDLOOP.

    ENDIF. " IF li_tax_ind[] IS NOT INITIAL
  ENDIF. " IF fp_lst_customers-sales_data-sales[] IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_GUID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_<ST_CUST_INPUT>_GENERAL_DATA_G  text
*----------------------------------------------------------------------*
FORM f_get_guid   USING    fp_v_partner          TYPE bu_partner   " Business Partner Number
                  CHANGING fp_st_cust_input_guid TYPE sysuuid_c32. " 16 Byte UUID in 32 Characters (Hexadecimal Encoded)

  READ TABLE i_but000 INTO DATA(lst_but000) WITH KEY partner = fp_v_partner BINARY SEARCH.
  IF sy-subrc IS INITIAL.
    fp_st_cust_input_guid = lst_but000-partner_guid.
  ELSE. " ELSE -> IF sy-subrc IS INITIAL
    TRY.
        CALL METHOD cl_system_uuid=>if_system_uuid_static~create_uuid_c32
          RECEIVING
            uuid = fp_st_cust_input_guid.
      CATCH cx_uuid_error .
    ENDTRY.
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_GUID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_CUST_INPUT  text
*      <--P_I_BUT000  text
*----------------------------------------------------------------------*
FORM f_fetch_guid  USING    fp_i_cust_input TYPE ztqtc_customer_date_inputs
                   CHANGING fp_i_but000     TYPE tty_partner.

  SELECT partner      " Business Partner Number
         partner_guid " Business Partner GUID
         xdele        " BP Archive flag
         FROM but000  " BP: General data I
         INTO TABLE fp_i_but000
         FOR ALL ENTRIES IN fp_i_cust_input
         WHERE partner EQ fp_i_cust_input-data_key-partner.
  IF sy-subrc IS INITIAL.
    SORT fp_i_but000 BY partner.
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
* BOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LI_CONSTANT  text
*----------------------------------------------------------------------*
FORM f_get_constant  CHANGING fp_li_constant TYPE tt_constant.
*  Local constant declaration
  CONSTANTS:  lc_devid  TYPE zdevid VALUE 'I0200'.     " Development ID
  DATA:       lst_zcaconstant TYPE ty_constant. "ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715
*Fetch data from ZCACONSTANT
  SELECT  devid,      " Development ID
          param1,     " ABAP: Name of Variant Variable
          param2,     " ABAP: Name of Variant Variable
          srno,       " ABAP: Current selection number
          sign,       " ABAP: ID: I/E (include/exclude values)
          opti,       " ABAP: Selection option (EQ/BT/CP/...)
          low,        " Lower Value of Selection Condition
          high,       " Upper Value of Selection Condition
          activate    "
  FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE @fp_li_constant
    WHERE devid = @lc_devid
    AND   activate = @abap_true.
  IF sy-subrc EQ 0.
    SORT fp_li_constant BY param1.
* Begin of ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715
*     Begin of ADD:ERP-7078 :Siva Guda:03-April-2018:ED2K911684
    "Get data from zcaconstant table
    LOOP AT li_constant INTO lst_zcaconstant.
      CASE lst_zcaconstant-param1.
        WHEN c_lock_msgno.
          lst_msgno-sign = lst_zcaconstant-sign.
          lst_msgno-option = lst_zcaconstant-opti.
          lst_msgno-low = lst_zcaconstant-low.
          lst_msgno-high = lst_zcaconstant-high.
          APPEND lst_msgno TO lr_msgno.
          CLEAR lst_msgno.
        WHEN c_lock_msgid.
          lst_msgid-sign = lst_zcaconstant-sign.
          lst_msgid-option = lst_zcaconstant-opti.
          lst_msgid-low = lst_zcaconstant-low.
          lst_msgid-high = lst_zcaconstant-high.
          APPEND lst_msgid TO lr_msgid.
          CLEAR lst_msgid.
        WHEN c_dup_id_chk.   "added for ERP-6309 RK20180706
          lst_ext_id_typ-sign = lst_zcaconstant-sign.
          lst_ext_id_typ-option = lst_zcaconstant-opti.
          lst_ext_id_typ-low = lst_zcaconstant-low.
          lst_ext_id_typ-high = lst_zcaconstant-high.
          APPEND lst_ext_id_typ TO lr_ext_id_typ.
          CLEAR lst_ext_id_typ.
        WHEN c_support_mod.
          IF lst_zcaconstant-low IS NOT INITIAL.
            gv_support_mode = abap_true.
          ENDIF.
        WHEN OTHERS.
          "not required in this case
      ENDCASE.
    ENDLOOP.
*     End of ADD:ERP-7078 :Siva Guda:03-April-2018:ED2K911684
* End of ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
* EOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
*&---------------------------------------------------------------------*
*&      Form  F_BP_LOCK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<ST_CUST_INPUT>_DATA_KEY_PARTN  text
*      <--P_LV_RESULT  text
*----------------------------------------------------------------------*
FORM f_bp_lock  USING    fp_partner TYPE bu_partner            " BP
                         fp_v_log_handle    TYPE balloghndl    " Application Log: Log Handle
                CHANGING fp_lv_result TYPE char1
                         fp_ex_return TYPE ztqtc_customer_date_outputs.
*
*  DATA: lr_return    TYPE TABLE OF bapiret2.
*  FIELD-SYMBOLS:
*    <lst_ex_ret>  TYPE zstqtc_customer_date_output, "(Customer / BP Number, Messages)
*    <lst_message> TYPE bapiretc.
*
*  IF fp_partner IS NOT INITIAL.
** Lock BP before making any changes
*    CALL FUNCTION 'BUPA_ENQUEUE'
*      EXPORTING
*        iv_partner      = fp_partner
*      TABLES
*        et_return       = lr_return
*      EXCEPTIONS
*        blocked_partner = 1
*        OTHERS          = 2.
*    READ TABLE lr_return INTO DATA(lst_return) WITH KEY type = c_msgty_err."'E'.
*    IF sy-subrc EQ 0.
** populate error message and set flag
*      fp_lv_result = abap_false.
*      LOOP AT lr_return INTO lst_return WHERE type = c_msgty_err."'E'.
**   Add error message to Application Log - SOURCE SYSTEM/ORIGIN
*        PERFORM f_log_add    USING fp_v_log_handle
*                                   lst_return-type "Message Type - (I)nformation
*                                   lst_return-message_v2
*                                   lst_return-message_v3
*                                   lst_return-message.
** Update Return parameter
*        APPEND INITIAL LINE TO fp_ex_return ASSIGNING <lst_ex_ret>.
*        IF <lst_ex_ret> IS ASSIGNED.
*          <lst_ex_ret>-partner_info-partner     = fp_partner.
*
*          APPEND INITIAL LINE TO <lst_ex_ret>-messages ASSIGNING <lst_message>.
*          <lst_message>-type          = c_msgty_err.
*          <lst_message>-id            = c_msgid_zrtr.
*          <lst_message>-number        = c_msgno_000.
*          <lst_message>-message       = lst_return-message.
*          <lst_message>-message_v1    = lst_return-message_v1.
*        ENDIF. " IF <lst_ex_ret> IS ASSIGNED
*        CLEAR lst_return.
*      ENDLOOP.
*    ELSE.
** Set flag as BP locked for further processing
*      fp_lv_result = abap_true.
**   Add BP lock message to Application Log - SOURCE SYSTEM/ORIGIN
*      PERFORM f_log_add    USING fp_v_log_handle
*                                 c_s "'S' "Message Type - (I)nformation
*                                 c_bp
*                                 fp_partner
*                                 'is locked'(002).
*    ENDIF.
*
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_UBLOCK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<ST_CUST_INPUT>_DATA_KEY_PARTN  text
*----------------------------------------------------------------------*
FORM f_bp_ublock  USING   fp_partner      TYPE bu_partner     " BP
                          fp_v_log_handle TYPE balloghndl    " Application Log: Log Handle
                 CHANGING fp_ex_return    TYPE ztqtc_customer_date_outputs.

*  FIELD-SYMBOLS:
*    <lst_ex_ret>  TYPE zstqtc_customer_date_output, "(Customer / BP Number, Messages)
*    <lst_message> TYPE bapiretc.
*  DATA : lr_return   TYPE TABLE OF bapiret2.
*
** Unlock BP after chagnes are completed
*  IF fp_partner IS NOT INITIAL.
*    CALL FUNCTION 'BUPA_DEQUEUE'
*      EXPORTING
*        iv_partner = fp_partner
*      TABLES
*        et_return  = lr_return.
*    READ TABLE lr_return INTO DATA(lst_return) WITH KEY type = c_msgty_err."'E'.
*    IF sy-subrc EQ 0.
** populate error message
*      LOOP AT lr_return INTO lst_return WHERE type = c_msgty_err."'E'.
** Add error message to Application Log
*        PERFORM f_log_add    USING fp_v_log_handle
*                                   lst_return-type "Message Type - (I)nformation
*                                   lst_return-message_v1
*                                   lst_return-message_v2
*                                   lst_return-message.
** Update Return parameter
*        APPEND INITIAL LINE TO fp_ex_return ASSIGNING <lst_ex_ret>.
*        IF <lst_ex_ret> IS ASSIGNED.
*          <lst_ex_ret>-partner_info-partner     = fp_partner.
*
*          APPEND INITIAL LINE TO <lst_ex_ret>-messages ASSIGNING <lst_message>.
*          <lst_message>-type          = c_msgty_err.
*          <lst_message>-id            = c_msgid_zrtr.
*          <lst_message>-number        = c_msgno_000.
*          <lst_message>-message       = lst_return-message.
*          <lst_message>-message_v1    = lst_return-message_v1.
*        ENDIF. " IF <lst_ex_ret> IS ASSIGNED
*        CLEAR lst_return.
*      ENDLOOP.
*    ELSE.
** Set flag as BP locked for further processing
**   Add BP lock message to Application Log - SOURCE SYSTEM/ORIGIN
*      PERFORM f_log_add    USING fp_v_log_handle
*                                 c_s "'S' "Message Type - (I)nformation
*                                 c_bp "'BP'
*                                 fp_partner
*                                 'is unlocked'(003).
*    ENDIF.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ZTABLE_MAP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_IDENT_NUM  text
*      -->P_LT_ZQTC_EXT_IDENT  text
*      -->P_LSTT_IDENT_NUM  text
*      -->P_LV_BU_PARTNER  text
*----------------------------------------------------------------------*
FORM ztable_map  TABLES   li_ident_num TYPE bus_ei_bupa_identification_t
                          lt_zqtc_ext_ident STRUCTURE zqtc_ext_ident
                 USING    "lstt_ident_num TYPE bus_ei_bupa_identification
                          lv_bu_partner TYPE bu_partner.

  LOOP AT li_ident_num INTO DATA(lstmp_ident_num).
    " WHERE data_key-identificationcategory =  lstt_ident_num-data_key-identificationcategory
    " AND data_key-identificationnumber = lstt_ident_num-data_key-identificationnumber.
*-                     Partner Number
    lst_zqtc_ext_ident-partner =  lv_bu_partner."fp_v_partner.
*-                     Category
    lst_zqtc_ext_ident-type =  lstmp_ident_num-data_key-identificationcategory.
*-                      Identification Number
    lst_zqtc_ext_ident-idnumber = lstmp_ident_num-data_key-identificationnumber.
*-                      Needs to populate External ID for ZSFCI and ZCAAID
    lst_zqtc_ext_ident-ext_idnumber = lstmp_ident_num-data_key-identificationnumber.
    TRANSLATE lst_zqtc_ext_ident-idnumber TO UPPER CASE.
    APPEND lst_zqtc_ext_ident TO lt_zqtc_ext_ident.
    CLEAR : lst_zqtc_ext_ident,lstmp_ident_num.",lstt_ident_num.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EXT_ID_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LTT_BUT0ID  text
*      -->P_LI_IDENT_NUM  text
*      -->P_C_ZECID  text
*      <--P_LV_ID_MATCHED  text
*----------------------------------------------------------------------*
FORM ext_id_check  TABLES   ltt_but0id STRUCTURE but0id
                            li_ident_num TYPE bus_ei_bupa_identification_t
                   USING    c_id
                   CHANGING lv_id_matched.
  DATA: llst_bu0id TYPE but0id,
        lv_number  TYPE but0id-idnumber.

  READ TABLE ltt_but0id INTO  llst_bu0id WITH KEY type = c_id.
  IF sy-subrc IS INITIAL.

    "SoldTo and ShipTo must have same ECID atleast
    READ TABLE li_ident_num INTO DATA(lstt_ident_num2) WITH KEY data_key-identificationcategory = llst_bu0id-type.
    IF sy-subrc IS INITIAL.
      "ECID exists
      CLEAR  lv_number.
      lv_number = lstt_ident_num2-data_key-identificationnumber.
      TRANSLATE lv_number TO UPPER CASE.
      IF lv_number = llst_bu0id-idnumber.
        lv_id_matched = abap_true.
      ELSE.
        lv_id_matched = abap_false.
      ENDIF.

    ELSE.
      "ShipTo Identity data missing
    ENDIF.

  ELSE.
    "SoldTo Identity data missing
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_ERROR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_log_error USING    fp_message TYPE char200
                          fp_issue   TYPE syst_msgv
                 CHANGING  ex_return TYPE ztqtc_customer_date_outputs.

  "update the error log
  PERFORM f_log_create USING   gv_guid
                               st_cust_input
                               li_constant
                      CHANGING v_log_handle.


  CLEAR: gv_return_msg.

  PERFORM f_log_add    USING v_log_handle
                             c_msgty_err "Message Type - (e)rror
                             fp_issue
                             gs_ext_id-id_category
                             fp_message.

  PERFORM f_log_save USING v_log_handle.


  "update the response to requestor
*  gv_return_msg-message    = fp_issue.
  CONCATENATE fp_issue fp_message INTO gv_return_msg-message SEPARATED BY space.
*  gv_return_msg-message    = fp_message.

  PERFORM f_populate_return    USING    st_cust_input
                                        gv_return_msg
                                 CHANGING ex_return.
  CLEAR: gv_message, gv_return_msg.
ENDFORM.
* End of ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715
* Begin of ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_RESPONSE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_CUST_INPUT  text
*      -->P_GV_RETURN_MSG  text
*      <--P_EX_RETURN  text
*----------------------------------------------------------------------*
FORM f_populate_response USING    fp_st_cust_input TYPE zstqtc_customer_date_input " I0200: Customer Data (Gen, Comp Code, Sales Area, Crdt/Coll)
                                   fp_return_msg      TYPE bapiretc
                          CHANGING fp_ex_return     TYPE ztqtc_customer_date_outputs.
  FIELD-SYMBOLS:
    <lst_ex_ret>  TYPE zstqtc_customer_date_output, " I0200: Customer Data (Customer / BP Number, Messages)
    <lst_message> TYPE bapiretc.                    " Return Parameter for Complex Data Type

  APPEND INITIAL LINE TO fp_ex_return ASSIGNING <lst_ex_ret>.
  IF <lst_ex_ret> IS ASSIGNED.
    <lst_ex_ret>-seq_id                    = fp_st_cust_input-seq_id.
    <lst_ex_ret>-partner_info-cdm_ecid     = fp_st_cust_input-data_key-id_number.

    APPEND INITIAL LINE TO <lst_ex_ret>-messages ASSIGNING <lst_message>.
    <lst_message>-type          = c_msgty_err.
    <lst_message>-id            = c_msgid_zrtr.
    <lst_message>-number        = c_msgno_000.
    <lst_message>-message       = 'New ECID for existing CORE ID(s)'(l22).
    <lst_message>-message_v1    = 'New ECID for existing CORE ID(s)'(l22).
  ENDIF. " IF <lst_ex_ret> IS ASSIGNED

ENDFORM.
* End of ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715

*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_BP_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<ST_CUST_INPUT>_DATA_KEY_PARTN  text
*      <--P_EX_RETURN  text
*----------------------------------------------------------------------*
FORM f_validate_bp_status  TABLES   i_but000   TYPE tty_partner
                           USING    fp_partner TYPE bu_partner
                           CHANGING ex_return  TYPE ztqtc_customer_date_outputs.
  DATA: ls_but000 TYPE ty_partner,
        lv_issue  TYPE syst_msgv.
  READ TABLE i_but000 INTO ls_but000
                      WITH KEY partner = fp_partner
                      BINARY SEARCH.
  IF sy-subrc IS INITIAL.
    IF ls_but000-xdele IS INITIAL.
      "check add future checks if required
    ELSE.
      "error, BP is marked for Archive.. shouldn't process further
      gv_id_err =  abap_true.

      CONCATENATE '- Partner number'  fp_partner
                            'marked for archive in SAP.'  INTO gv_message SEPARATED BY space.
      lv_issue  =  'BP issue:'.
*      PERFORM f_log_error USING gv_message
*                                lv_issue
*                          CHANGING  ex_return.
    ENDIF.
  ELSE.
    "error, BP# passed doesn't exist in SAP
    gv_id_err =  abap_true.

    CONCATENATE '- Partner number'  fp_partner
                          'does not exist in SAP.'  INTO gv_message SEPARATED BY space.
    lv_issue  =  'BP issue:'.
*    PERFORM f_log_error USING gv_message
*                              lv_issue
*                        CHANGING  ex_return.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CDM_CHECKS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_<ST_CUST_INPUT>  text
*      <--P_I_BUT0ID  text
*      <--P_EX_RETURN  text
*----------------------------------------------------------------------*
FORM f_cdm_checks  CHANGING fp_cust_input TYPE zstqtc_customer_date_input
                            fp_i_but0id   TYPE tty_partner_id
                            ex_return     TYPE ztqtc_customer_date_outputs.

  IF fp_cust_input-data_key-partner IS NOT INITIAL. "Update situation
*check for the CDM ID's replacement with latest ID (if required only)
    PERFORM f_correct_ecid_data CHANGING fp_cust_input
                                         i_but0id
                                         ex_return.
  ELSE.
    "since its non update case (creation of customer)- take all the ID's information
    "add suitable logic if anything else is required for non-update case
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CORRECT_ECID_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_FP_CUST_INPUT  text
*      <--P_I_BUT0ID  text
*      <--P_EX_RETURN  text
*----------------------------------------------------------------------*
FORM f_correct_ecid_data  CHANGING fp_cust_input TYPE zstqtc_customer_date_input
                                   fp_i_but0id   TYPE tty_partner_id
                                   ex_return     TYPE ztqtc_customer_date_outputs.

  CONSTANTS : lc_ecid TYPE bu_id_type VALUE 'ZECID',
              lc_d    TYPE bus_ei_identification_task VALUE 'D'.
  DATA: ls_ext_id_input1 TYPE bus_ei_bupa_identification,
        ls_butoid        TYPE ty_partner_id,
        lv_issue         TYPE syst_msgv.


  IF fp_cust_input-data_key-id_category EQ lc_ecid.
    READ TABLE fp_i_but0id INTO ls_butoid
                           WITH KEY partner = fp_cust_input-data_key-partner
                                       type = lc_ecid.
    IF sy-subrc IS INITIAL.
      "check if ECID matches
      IF ls_butoid-idnumber EQ fp_cust_input-data_key-id_number.
        "ECID matches.. all set to go

      ELSE.
        "IF ECID doesn't match.. then update the request
        ls_ext_id_input1-task = lc_d.
        ls_ext_id_input1-data_key-identificationcategory  = lc_ecid.
        ls_ext_id_input1-data_key-identificationnumber = ls_butoid-idnumber.
        APPEND ls_ext_id_input1 TO fp_cust_input-general_data-gen_data-central_data-ident_number-ident_numbers.
      ENDIF.

    ELSE.

      "make a re-select for safety check
      SELECT SINGLE idnumber
               FROM but0id
               INTO @DATA(lv_ecid)
               WHERE partner  = @fp_cust_input-data_key-partner
                 AND type     = @lc_ecid.
      IF sy-subrc IS INITIAL.
        " ECID exists
        IF lv_ecid EQ fp_cust_input-data_key-id_number.
          " ECID matches.. all set to go
        ELSE.
          "IF ECID doesn't match.. then update the request
          ls_ext_id_input1-task = lc_d.
          ls_ext_id_input1-data_key-identificationcategory  = lc_ecid.
          ls_ext_id_input1-data_key-identificationnumber = lv_ecid.
          APPEND ls_ext_id_input1 TO fp_cust_input-general_data-gen_data-central_data-ident_number-ident_numbers.
        ENDIF.
      ELSE.
        "ECID doesn't exist for the BP.. go ahead and accept
      ENDIF.

    ENDIF.
  ELSE.
    "payload must pass this partner type as 'ZECID'.
    "if it doesn't match.. alarm with error message and look for the reason in the process change
    gv_id_err = abap_true.

    CONCATENATE 'ECID' 'is not passed at right position' INTO gv_message SEPARATED BY space.
    lv_issue = 'Payload ECID issue in request:'.
    PERFORM f_log_error USING gv_message
                              lv_issue
                     CHANGING ex_return.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_RETURN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_CUST_INPUT  text
*      -->P_GV_RETURN_MSG  text
*      <--P_EX_RETURN  text
*----------------------------------------------------------------------*
FORM f_populate_return  USING fp_st_cust_input TYPE zstqtc_customer_date_input
                              fp_return_msg    TYPE bapiretc
                     CHANGING fp_ex_return     TYPE ztqtc_customer_date_outputs.

  FIELD-SYMBOLS:
    <lst_ex_ret>  TYPE zstqtc_customer_date_output, " I0200: Customer Data (Customer / BP Number, Messages)
    <lst_message> TYPE bapiretc.                    " Return Parameter for Complex Data Type

  APPEND INITIAL LINE TO fp_ex_return ASSIGNING <lst_ex_ret>.
  IF <lst_ex_ret> IS ASSIGNED.
    <lst_ex_ret>-seq_id                    = fp_st_cust_input-seq_id.
    <lst_ex_ret>-partner_info-cdm_ecid     = fp_st_cust_input-data_key-id_number.

    APPEND INITIAL LINE TO <lst_ex_ret>-messages ASSIGNING <lst_message>.
    <lst_message>-type          = c_msgty_err.
    <lst_message>-id            = c_msgid_zrtr.
    <lst_message>-number        = c_msgno_000.
    <lst_message>-message       = fp_return_msg-message.

  ENDIF. " IF <lst_ex_ret> IS ASSIGNED
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_RELATIONSHIP_DATA
*&---------------------------------------------------------------------*
*      --> FP_ST_CUST_INPUT  TYPE zstqtc_customer_date_input
*      --> FP_I_RELATIONSHIP_DATA  TYPE burs_ei_extern_t
*      --> FP_I_PARTNER_DET  TYPE tty_partner_det
*      --> FP_I_RELAT_BUT0ID TYPE tty_partner_id
*      <-- FP_I_TRTAB        TYPE tty_trtab
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM f_validate_relationship_data  USING  fp_st_cust_input       TYPE zstqtc_customer_date_input
                                          fp_i_relationship_data TYPE burs_ei_extern_t
                                          fp_i_partner_det       TYPE tty_partner_det
                                          fp_i_relat_but0id      TYPE tty_partner_id
                                CHANGING  fp_ex_return           TYPE ztqtc_customer_date_outputs.

  DATA: lv_partner         TYPE bu_partner,
        li_identifications TYPE bus_ei_bupa_identification_t,
        li_rel_data        TYPE burs_ei_extern_t,
        li_trtab           TYPE STANDARD TABLE OF trtab INITIAL SIZE 0,
        lst_bapiretc       TYPE bapiretc,
        li_bapiretct       TYPE bapiretct.

  FIELD-SYMBOLS <lst_ex_ret> TYPE zstqtc_customer_date_output.

  IF fp_st_cust_input-data_key-partner IS NOT INITIAL.
    lv_partner = fp_st_cust_input-data_key-partner.
  ENDIF.

* get the BP identifications from payload data
  li_identifications = st_cust_input-general_data-gen_data-central_data-ident_number-ident_numbers.
  IF li_identifications[] IS NOT INITIAL.
    LOOP AT li_identifications INTO DATA(list_identifications).
      IF list_identifications-data_key-identificationcategory <> c_reltype.
* delete the identifications which are not ZRLCT
        DELETE li_identifications INDEX sy-tabix.
      ENDIF.
      CLEAR list_identifications.
    ENDLOOP.
  ENDIF.

* get the Relationships from payload data
  PERFORM f_get_relationship_data  USING lv_partner
                                         fp_i_relationship_data
                                         fp_i_partner_det
                                         fp_i_relat_but0id
                                CHANGING li_rel_data.

  IF li_rel_data[] IS NOT INITIAL.
* Trigger BP Relationships validation
    PERFORM f_validate_bp_relationships  USING lv_partner
                                               li_identifications
                                      CHANGING li_trtab
                                               li_rel_data.
    IF li_trtab[] IS NOT INITIAL.
      gv_relationships_err = abap_true.

* Update Header message
      PERFORM f_log_info  USING v_log_handle
                                c_msgty_info     "  Message Type - (I)nformation
                                'Found Invalid Relationship(s):'(LG6)
                                space
                                space
                                c_relations
                                c_nodetype_h.

* Update Relationship data Input to Application log
      PERFORM f_upd_log_relat_data_input  USING v_log_handle
                                                lv_partner
                                                fp_i_relationship_data.
      LOOP AT li_trtab INTO DATA(list_trtab).
        gv_return_msg-message = list_trtab-line.
        lst_bapiretc-type = c_msgty_err.
        lst_bapiretc-message = list_trtab-line.
        APPEND lst_bapiretc TO li_bapiretct.

* Update Log Information
        PERFORM f_log_info  USING v_log_handle
                                  c_msgty_err     "  Message Type - (E)Error
                                  list_trtab-line
                                  space
                                  space
                                  c_relations
                                  c_nodetype_i.

        CLEAR: list_trtab, lst_bapiretc.
      ENDLOOP.

* Update the BAPI return table log
      READ TABLE fp_ex_return ASSIGNING <lst_ex_ret> INDEX v_index.
      IF sy-subrc NE 0.
        APPEND INITIAL LINE TO fp_ex_return ASSIGNING <lst_ex_ret>.
      ENDIF. " IF sy-subrc NE 0
      IF <lst_ex_ret> IS ASSIGNED.
        APPEND LINES OF li_bapiretct TO <lst_ex_ret>-messages.
      ENDIF. " IF <lst_ex_ret> IS ASSIGNED

* Add the log messages to Application Log
      PERFORM f_log_info_add USING v_log_handle
                                   i_log_info.

* Save the Application Log
      PERFORM f_log_save USING v_log_handle.

      CLEAR: v_log_handle, i_log_info[].
    ENDIF. " IF i_trtab[] IS NOT INITIAL
  ENDIF.  " IF i_rel_data[] IS NOT INITIAL


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_RELATIONSHIP_DATA
*&---------------------------------------------------------------------*
*      --> FP_V_PARTNER  TYPE bu_partner
*      --> FP_I_RELATIONSHIP_DATA  TYPE burs_ei_extern_t
*      --> FP_I_PARTNER_DET        TYPE tty_partner_det
*      --> FP_I_RELAT_BUT0ID       TYPE tty_partner_id
*      <-- FP_I_REL_DATA           TYPE burs_ei_extern_t
*----------------------------------------------------------------------*
FORM f_get_relationship_data  USING  fp_v_partner           TYPE bu_partner
                                     fp_i_relationship_data TYPE burs_ei_extern_t
                                     fp_i_partner_det       TYPE tty_partner_det
                                     fp_i_relat_but0id      TYPE tty_partner_id
                            CHANGING fp_i_rel_data          TYPE burs_ei_extern_t.

  DATA: lst_return     TYPE bapireti,       " Return Parameter with Object Index and Key
        lst_partner_id TYPE ty_partner_id,
        lst_obj_msg    TYPE bapiretc,       " Return Parameter for Complex Data Type
        lst_data       TYPE burs_ei_extern, " Complex External Interface of a Relationship
        lst_relat_data TYPE burs_ei_extern, " Complex External Interface of a Relationship
*        Begin of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
        lst_header     TYPE burs_ei_header,
        li_return_2    TYPE bapirettab,
*        End   of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
        li_return      TYPE bapiretm.

  SORT fp_i_relat_but0id BY type idnumber.

  LOOP AT fp_i_relationship_data INTO lst_relat_data.
    IF lst_relat_data-header-object_instance-partner2-bpartner IS NOT INITIAL.

      lst_data-header-object_instance-partner1-bpartner               = fp_v_partner.
      lst_data-header-object_instance-partner1-bpartnerguid           = lst_relat_data-header-object_instance-partner1-bpartnerguid.
      lst_data-header-object_instance-partner1-identificationcategory = lst_relat_data-header-object_instance-partner1-identificationcategory.
      lst_data-header-object_instance-partner1-identificationnumber   = lst_relat_data-header-object_instance-partner1-identificationnumber.

*     lst_data-header-object_instance-partner2-bpartner               = lst_relat_data-header-object_instance-partner2-bpartner.
*     Convert to Internal Foemat (add leading Zeros)
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lst_relat_data-header-object_instance-partner2-bpartner
        IMPORTING
          output = lst_data-header-object_instance-partner2-bpartner.
      lst_data-header-object_instance-partner2-bpartnerguid           = lst_relat_data-header-object_instance-partner2-bpartnerguid.
      lst_data-header-object_instance-partner2-identificationcategory = lst_relat_data-header-object_instance-partner2-identificationcategory.
      lst_data-header-object_instance-partner2-identificationnumber   = lst_relat_data-header-object_instance-partner2-identificationnumber.

      lst_data-header-object_instance-relat_category                  = lst_relat_data-header-object_instance-relat_category.
      lst_data-header-object_instance-date_to                         = lst_relat_data-header-object_instance-date_to.
      lst_data-header-object_instance-difftypevalue                   = lst_relat_data-header-object_instance-difftypevalue.
      lst_data-header-object_task                                     = c_m.

      lst_data-central_data-main-data-date_from                       = lst_relat_data-central_data-main-data-date_from.
      lst_data-central_data-main-data-relation_kind                   = lst_relat_data-central_data-main-data-relation_kind.
      lst_data-central_data-main-data-defaultrelationship             = lst_relat_data-central_data-main-data-defaultrelationship.
      lst_data-central_data-main-data-date_to_new                     = lst_relat_data-central_data-main-data-date_to_new.
*     Begin of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
*     Analyze header
      lst_header = lst_data-header.
      CLEAR: li_return_2,
             lst_header-object_instance-date_to.
      PERFORM analyze_header_rel IN PROGRAM saplbupa_interface_service IF FOUND
       TABLES li_return_2
     CHANGING lst_header.
      IF lst_header-object_task = c_i. "Insert Indictor
        CLEAR: lst_data-central_data-main-data-date_to_new.
      ELSE.
        IF lst_data-central_data-main-data-date_to_new IS INITIAL.
          lst_data-central_data-main-data-date_to_new                 = lst_data-header-object_instance-date_to.
        ENDIF.
        CLEAR: lst_data-header-object_instance-date_to.
      ENDIF.
*     End   of ADD:CR#697:WROY:20-Oct-2017:ED2K909065

      IF lst_data-central_data-main-data-date_from IS NOT INITIAL.
        lst_data-central_data-main-datax-date_from                    = abap_true.
      ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-date_from IS NOT INITIAL
        lst_data-central_data-main-datax-date_from                    = abap_false.
      ENDIF. " IF lst_relat_data-central_data-main-data-date_from IS NOT INITIAL

      IF lst_data-central_data-main-data-relation_kind IS NOT INITIAL.
        lst_data-central_data-main-datax-relation_kind                = abap_true.
      ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-relation_kind IS NOT INITIAL
        lst_data-central_data-main-datax-relation_kind                = abap_false.
      ENDIF. " IF lst_relat_data-central_data-main-data-relation_kind IS NOT INITIAL

      IF lst_data-central_data-main-data-defaultrelationship IS NOT INITIAL.
        lst_data-central_data-main-datax-defaultrelationship          = abap_true.
      ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-defaultrelationship IS NOT INITIAL
        lst_data-central_data-main-datax-defaultrelationship          = abap_false.
      ENDIF. " IF lst_relat_data-central_data-main-data-defaultrelationship IS NOT INITIAL

      IF lst_data-central_data-main-data-date_to_new IS NOT INITIAL.
        lst_data-central_data-main-datax-date_to_new                  = abap_true.
      ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-date_to_new IS NOT INITIAL
        lst_data-central_data-main-datax-date_to_new                  = abap_false.
      ENDIF. " IF lst_relat_data-central_data-main-data-date_to_new IS NOT INITIAL

      lst_data-central_data-main-task                                 = c_m.

      APPEND lst_data TO fp_i_rel_data.
      CLEAR  lst_data.

    ELSE. " ELSE -> IF lst_relat_data-header-object_instance-partner2-bpartner IS NOT INITIAL

      CLEAR lst_partner_id.

      READ TABLE  fp_i_relat_but0id
      INTO lst_partner_id
      WITH KEY type     = lst_relat_data-header-object_instance-partner2-identificationcategory " With key of type
               idnumber = lst_relat_data-header-object_instance-partner2-identificationnumber
      BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        lst_data-header-object_instance-partner1-bpartner               = fp_v_partner.
        lst_data-header-object_instance-partner1-bpartnerguid           = lst_relat_data-header-object_instance-partner1-bpartnerguid.
        lst_data-header-object_instance-partner1-identificationcategory = lst_relat_data-header-object_instance-partner1-identificationcategory.
        lst_data-header-object_instance-partner1-identificationnumber   = lst_relat_data-header-object_instance-partner1-identificationnumber.

        lst_data-header-object_instance-partner2-bpartner               = lst_partner_id-partner.
        lst_data-header-object_instance-partner2-bpartnerguid           = lst_relat_data-header-object_instance-partner2-bpartnerguid.
        lst_data-header-object_instance-partner2-identificationcategory = lst_partner_id-type.
        lst_data-header-object_instance-partner2-identificationnumber   = lst_partner_id-idnumber.

        lst_data-header-object_instance-relat_category                  = lst_relat_data-header-object_instance-relat_category.
        lst_data-header-object_instance-date_to                         = lst_relat_data-header-object_instance-date_to.
        lst_data-header-object_instance-difftypevalue                   = lst_relat_data-header-object_instance-difftypevalue.
        lst_data-header-object_task                                     = c_m.

        lst_data-central_data-main-data-date_from                       = lst_relat_data-central_data-main-data-date_from.
        lst_data-central_data-main-data-relation_kind                   = lst_relat_data-central_data-main-data-relation_kind.
        lst_data-central_data-main-data-defaultrelationship             = lst_relat_data-central_data-main-data-defaultrelationship.
        lst_data-central_data-main-data-date_to_new                     = lst_relat_data-central_data-main-data-date_to_new.
*       Begin of ADD:CR#697:WROY:20-Oct-2017:ED2K909065
*       Analyze header
        lst_header = lst_data-header.
        CLEAR: li_return_2,
               lst_header-object_instance-date_to.
        PERFORM analyze_header_rel IN PROGRAM saplbupa_interface_service IF FOUND
         TABLES li_return_2
       CHANGING lst_header.
        IF lst_header-object_task = c_i. "Insert Indictor
          CLEAR: lst_data-central_data-main-data-date_to_new.
        ELSE.
          IF lst_data-central_data-main-data-date_to_new IS INITIAL.
            lst_data-central_data-main-data-date_to_new                 = lst_data-header-object_instance-date_to.
          ENDIF.
          CLEAR: lst_data-header-object_instance-date_to.
        ENDIF.
*       End   of ADD:CR#697:WROY:20-Oct-2017:ED2K909065

        IF lst_data-central_data-main-data-date_from IS NOT INITIAL.
          lst_data-central_data-main-datax-date_from                    = abap_true.
        ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-date_from IS NOT INITIAL
          lst_data-central_data-main-datax-date_from                    = abap_false.
        ENDIF. " IF lst_relat_data-central_data-main-data-date_from IS NOT INITIAL

        IF lst_data-central_data-main-data-relation_kind IS NOT INITIAL.
          lst_data-central_data-main-datax-relation_kind                = abap_true.
        ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-relation_kind IS NOT INITIAL
          lst_data-central_data-main-datax-relation_kind                = abap_false.
        ENDIF. " IF lst_relat_data-central_data-main-data-relation_kind IS NOT INITIAL

        IF lst_data-central_data-main-data-defaultrelationship IS NOT INITIAL.
          lst_data-central_data-main-datax-defaultrelationship          = abap_true.
        ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-defaultrelationship IS NOT INITIAL
          lst_data-central_data-main-datax-defaultrelationship          = abap_false.
        ENDIF. " IF lst_relat_data-central_data-main-data-defaultrelationship IS NOT INITIAL

        IF lst_data-central_data-main-data-date_to_new IS NOT INITIAL.
          lst_data-central_data-main-datax-date_to_new                  = abap_true.
        ELSE. " ELSE -> IF lst_relat_data-central_data-main-data-date_to_new IS NOT INITIAL
          lst_data-central_data-main-datax-date_to_new                  = abap_false.
        ENDIF. " IF lst_relat_data-central_data-main-data-date_to_new IS NOT INITIAL

        lst_data-central_data-main-task                                 = c_m.

        APPEND lst_data TO fp_i_rel_data.
        CLEAR  lst_data.

      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF lst_relat_data-header-object_instance-partner2-bpartner IS NOT INITIAL
  ENDLOOP. " LOOP AT fp_i_relationship_data INTO lst_relat_data

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_BP_RELATIONSHIPS
*&---------------------------------------------------------------------*
*      --> FP_V_PARTNER         TYPE bu_partner
*      --> FP_I_IDENTIFICATIONS TYPE bus_ei_bupa_identification_t
*      <-- I_TRTAB            TYPE tty_trtab
*      <-- FP_I_RELATIONSHIPS TYPE burs_ei_extern_t
*----------------------------------------------------------------------*
FORM f_validate_bp_relationships USING    fp_v_partner         TYPE bu_partner
                                          fp_i_identifications TYPE bus_ei_bupa_identification_t
                                 CHANGING fp_i_trtab         TYPE tty_trtab
                                          fp_i_relationships TYPE burs_ei_extern_t.

  TYPES: BEGIN OF lty_but0id,
           partner  TYPE bu_partner,
           type     TYPE char7,
           idnumber TYPE bu_id_number,
         END OF lty_but0id.

  DATA: li_but0id    TYPE STANDARD TABLE OF but0id INITIAL SIZE 0,      " Itab: BP Identifications
        li_but0id_p2 TYPE STANDARD TABLE OF but0id INITIAL SIZE 0,      " Itab: BP Identifications
        ls_but0id    TYPE but0id,
*        li_but0id     TYPE STANDARD TABLE OF lty_but0id INITIAL SIZE 0,  " Itab: BP Identifications
*        ls_but0id     TYPE lty_but0id,                                   " Struc: BP Identifications
        ls_trtab     TYPE trtab,                                        " Log table structure
        lv_bp_entry  TYPE bu_partner,
        lv_sytabix   TYPE syst_tabix,
        lv_msg       TYPE string.

  CONSTANTS:
    lc_f TYPE char1      VALUE 'F',
    lc_t TYPE char1      VALUE 'T'.

  IF fp_v_partner IS NOT INITIAL.
    " FM call to fetch the BP Identifications of main BP
    CALL FUNCTION 'BUP_BUT0ID_SELECT_WITH_PARTNER'
      EXPORTING
        iv_partner = fp_v_partner
*       I_VALDT_SEL = SY-DATLO
      TABLES
        et_but0id  = li_but0id
      EXCEPTIONS
        not_found  = 1
        not_valid  = 2
        OTHERS     = 3.
    IF sy-subrc <> 0.
      " Nothing to do
    ELSE.
      IF li_but0id[] IS NOT INITIAL.
        DELETE li_but0id WHERE type <> c_reltype.
      ENDIF.
    ENDIF.
  ENDIF.
  IF fp_i_identifications[] IS NOT INITIAL.
    LOOP AT fp_i_identifications INTO DATA(list_identifications).
      ls_but0id-type = list_identifications-data_key-identificationcategory.
      ls_but0id-idnumber = list_identifications-data_key-identificationnumber.
      APPEND ls_but0id TO li_but0id.
      CLEAR: ls_but0id, list_identifications.
    ENDLOOP.
  ENDIF.

  LOOP AT li_but0id INTO DATA(list_but0id).
    DATA(liv_length) = strlen( list_but0id-idnumber ).
    IF liv_length = 7.
      SHIFT list_but0id-idnumber BY 1 PLACES LEFT.
      MODIFY li_but0id FROM list_but0id INDEX sy-tabix
                       TRANSPORTING idnumber.
    ENDIF.
    CLEAR list_but0id.
  ENDLOOP.

  LOOP AT fp_i_relationships INTO DATA(list_relationships).
    lv_sytabix = sy-tabix.

    IF fp_v_partner IS NOT INITIAL.
      IF fp_v_partner = list_relationships-header-object_instance-partner1.
        lv_bp_entry = list_relationships-header-object_instance-partner2.
      ELSE.
        lv_bp_entry = list_relationships-header-object_instance-partner1.
      ENDIF.
    ELSE.
      lv_bp_entry = list_relationships-header-object_instance-partner2.
    ENDIF.

* FM Call to fetch the Identifications of the entered BP
    CALL FUNCTION 'BUP_BUT0ID_SELECT_WITH_PARTNER'
      EXPORTING
        iv_partner = lv_bp_entry
      TABLES
        et_but0id  = li_but0id_p2
      EXCEPTIONS
        not_found  = 1
        not_valid  = 2
        OTHERS     = 3.
    IF sy-subrc <> 0.
*       Nothing to do
    ELSE.
      IF li_but0id_p2[] IS NOT INITIAL.
        DELETE li_but0id_p2 WHERE type <> c_reltype.
      ENDIF.
    ENDIF.

* Check for BP Identifications
    IF li_but0id[] IS NOT INITIAL.

      SORT li_but0id BY type.
* If corresponding Identifications are not found for the current BP,
* no need to trigger the validation logic for BP relationships
      READ TABLE li_but0id WITH KEY type = c_reltype
                           TRANSPORTING NO FIELDS BINARY SEARCH.
      IF sy-subrc = 0.
        " Since Valid Relationship Category (ZRLCT) found under Identification tab for a BP,
        " proceed with the BP relationships validation Logic
        SORT li_but0id BY type idnumber.

        READ TABLE li_but0id WITH KEY type = c_reltype
                                      idnumber = list_relationships-header-object_instance-relat_category
                             TRANSPORTING NO FIELDS BINARY SEARCH.
        IF sy-subrc <> 0.
*          DELETE fp_i_relationships INDEX lv_sytabix.
          MESSAGE i311(zqtc_r2) WITH lv_bp_entry list_relationships-header-object_instance-relat_category
                  INTO ls_trtab-line.
          APPEND ls_trtab TO fp_i_trtab.
          CLEAR ls_trtab.
        ENDIF.

      ENDIF. " IF sy-subrc = 0

    ENDIF. " IF li_but0id[] IS NOT INITIAL OR

*** Checking the ZRLCT relation ships of the entered BP
    IF li_but0id_p2[] IS NOT INITIAL.

      LOOP AT li_but0id_p2 INTO DATA(list_but0id_p2).
        DATA(liv_len) = strlen( list_but0id_p2-idnumber ).
        IF liv_len = 7.
          SHIFT list_but0id_p2-idnumber BY 1 PLACES LEFT.
          MODIFY li_but0id_p2 FROM list_but0id_p2 INDEX sy-tabix
                              TRANSPORTING idnumber.
        ENDIF.
        CLEAR list_but0id_p2.
      ENDLOOP.
      SORT li_but0id_p2 BY type idnumber.
      READ TABLE li_but0id_p2 WITH KEY type = c_reltype
                                       idnumber = list_relationships-header-object_instance-relat_category
                              TRANSPORTING NO FIELDS BINARY SEARCH.
      IF sy-subrc <> 0.
*        DELETE fp_i_relationships INDEX lv_sytabix.
        MESSAGE i311(zqtc_r2) WITH lv_bp_entry list_relationships-header-object_instance-relat_category
                INTO ls_trtab-line.
        APPEND ls_trtab TO fp_i_trtab.
        CLEAR ls_trtab.
      ENDIF.

    ENDIF. " IF li_but0id_p2[] IS NOT INITIAL

    CLEAR: li_but0id_p2[], list_relationships, lv_bp_entry, lv_sytabix.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADD_MSG_WITH_LEVEL
*&---------------------------------------------------------------------*
*      -->FP_V_LOG_HANDLE TYPE BALLOGHNDL
*      -->FP_ST_LOG_INFO  TYPE TY_LOG_INFO
*----------------------------------------------------------------------*
FORM f_add_msg_with_level USING VALUE(fp_v_log_handle) TYPE balloghndl
                                VALUE(fp_st_log_info)  TYPE ty_log_info.

  DATA:
    lst_msg    TYPE bal_s_msg,
    lv_msg_len TYPE int4.

  lst_msg-msgty    = fp_st_log_info-msgtype.
  lst_msg-msgid    = c_msgid_zrtr.
  lst_msg-msgno    = c_msgno_000.
  lst_msg-detlevel = fp_st_log_info-hier_level.

  lv_msg_len = strlen( fp_st_log_info-message ).

  IF lv_msg_len LE 50.
    lst_msg-msgv1 = fp_st_log_info-message.
  ELSEIF lv_msg_len GT 50 AND lv_msg_len LE 100.
    lv_msg_len = lv_msg_len - 50.
    lst_msg-msgv1 = fp_st_log_info-message+0(50).
    lst_msg-msgv2 = fp_st_log_info-message+50(lv_msg_len).
  ELSEIF lv_msg_len GT 100 AND lv_msg_len LE 150.
    lv_msg_len = lv_msg_len - 100.
    lst_msg-msgv1 = fp_st_log_info-message+0(50).
    lst_msg-msgv2 = fp_st_log_info-message+50(50).
    lst_msg-msgv3 = fp_st_log_info-message+100(lv_msg_len).
  ELSEIF lv_msg_len GT 150 AND lv_msg_len LE 200.
    lv_msg_len = lv_msg_len - 150.
    lst_msg-msgv1 = fp_st_log_info-message+0(50).
    lst_msg-msgv2 = fp_st_log_info-message+50(50).
    lst_msg-msgv3 = fp_st_log_info-message+100(50).
    lst_msg-msgv4 = fp_st_log_info-message+150(lv_msg_len).
  ENDIF. " IF lv_msg_len LE 50

* add this message to the log
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle  = fp_v_log_handle  " Application Log: Log Handle
      i_s_msg       = lst_msg
    EXCEPTIONS
      log_not_found = 0
      OTHERS        = 1.
  IF sy-subrc <> 0.
*   Nothing to do
  ELSE.
    CLEAR lst_msg.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_INFO
*----------------------------------------------------------------------*
*      --> FP_V_LOG_HANDLE TYPE BALLOGHNDL
*      --> FP_V_MSGTY      TYPE SYMSGTY
*      --> FP_V_MSGV1      TYPE ANY
*      --> FP_V_MSGV2      TYPE ANY
*      --> FP_V_MSGV1      TYPE ANY
*      --> FP_NODETYPE     TYPE CHAR1
*----------------------------------------------------------------------*
FORM f_log_info  USING fp_v_log_handle TYPE balloghndl " Application Log: Log Handle
                       fp_v_msgty      TYPE symsgty    " Message Type
                       fp_v_msgv1      TYPE any
                       fp_v_msgv2      TYPE any
                       fp_v_msgv3      TYPE any
                       fp_identifier   TYPE char10
                       fp_nodetype     TYPE char1.

  DATA lv_msg TYPE char255.

  CONCATENATE fp_v_msgv1 fp_v_msgv2 INTO lv_msg SEPARATED BY space.
  CONCATENATE lv_msg fp_v_msgv3 INTO lv_msg SEPARATED BY space.

  st_log_info-msgtype = fp_v_msgty.
  st_log_info-message = lv_msg.
  st_log_info-nodetype = fp_nodetype.
  st_log_info-identifier = fp_identifier.
  IF fp_nodetype = c_nodetype_h.
    st_log_info-hier_level = 1.
    st_log_info-header_flag = abap_true.
  ELSEIF fp_nodetype = c_nodetype_i.
    st_log_info-hier_level = 2.
    st_log_info-header_flag = abap_false.
  ENDIF.
  APPEND st_log_info TO i_log_info.
  CLEAR st_log_info.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_INFO_ADD
*&---------------------------------------------------------------------*
*      --> FP_V_LOG_HANDLE    TYPE balloghndl
*      --> FP_I_LOG_INFO_ADD  TYPE tty_log_info
*----------------------------------------------------------------------*
FORM f_log_info_add  USING VALUE(fp_v_log_handle) TYPE balloghndl    " Application Log: Log Handle
                           VALUE(fp_i_log_info)   TYPE tty_log_info. " Application Log: Messages

  IF fp_i_log_info[] IS NOT INITIAL.
*    SORT fp_i_log_info BY identifier hier_level.
    LOOP AT fp_i_log_info INTO DATA(lst_log_info).
      PERFORM f_add_msg_with_level USING fp_v_log_handle
                                         lst_log_info.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_CRD_COLL_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_crd_coll_log .
  IF st_create-gen_data NE c_u.
    MOVE-CORRESPONDING st_input TO st_output.
    st_output-message = text-008.
    st_output-msg_type = c_i.
    st_output-bp = v_partner.
    st_output-msg_number = text-e11.
    APPEND st_output TO i_out_ret.
    CLEAR st_output.
  ENDIF.
ENDFORM.
