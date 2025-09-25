FUNCTION zqtc_idoc_input_debmas_bp.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUT_METHOD) LIKE  BDWFAP_PAR-INPUTMETHD
*"     VALUE(MASS_PROCESSING) LIKE  BDWFAP_PAR-MASS_PROC
*"     VALUE(PI_XD99_USED) TYPE  CHAR1 DEFAULT SPACE
*"     VALUE(PI_KNVK_SPECIAL) TYPE  CHAR1 DEFAULT SPACE
*"  EXPORTING
*"     VALUE(WORKFLOW_RESULT) LIKE  BDWFAP_PAR-RESULT
*"     VALUE(APPLICATION_VARIABLE) LIKE  BDWFAP_PAR-APPL_VAR
*"     VALUE(IN_UPDATE_TASK) LIKE  BDWFAP_PAR-UPDATETASK
*"     VALUE(CALL_TRANSACTION_DONE) LIKE  BDWFAP_PAR-CALLTRANS
*"  TABLES
*"      IDOC_CONTRL STRUCTURE  EDIDC
*"      IDOC_DATA STRUCTURE  EDIDD
*"      IDOC_STATUS STRUCTURE  BDIDOCSTAT
*"      RETURN_VARIABLES STRUCTURE  BDWFRETVAR
*"      SERIALIZATION_INFO STRUCTURE  BDI_SER
*"  EXCEPTIONS
*"      WRONG_FUNCTION_CALLED
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_IDOC_INPUT_DEBMAS_BP (FM)
* PROGRAM DESCRIPTION: Create BP with Comapny Code data,Sales Data,
*                      Collection & Credit management data using IDOCs
*                      (Inbound Process Code)
* DEVELOPER: Venkata D Rao P (VDPATABALL)
* CREATION DATE: 10/24/2019
* OBJECT ID:      I0200.3
* TRANSPORT NUMBER(S):ED2K916411
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO   : ED2K918405
* REFERENCE NO  : ERPM-11501/ERPM-22990/I0383
* DEVELOPER     : VDPATABALL
* DATE          : 06/08/2020
* DESCRIPTION   : Updating the General data to BP
* Updating the general data to respective customer accounting group
* Updating mutiple Email IDs to Contact person (CP)
*&---------------------------------------------------------------------*

*----Local internal tables --------
  DATA : li_addresses   TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-address-addresses,
         lst_addresses  LIKE LINE OF li_addresses,
         li_phone       TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-communication-phone-phone,
         lst_phone      LIKE LINE OF li_phone,
*         li_smtp        TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-communication-smtp-smtp,
         li_fax         TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-communication-fax-fax,
         lst_smtp       LIKE LINE OF i_smtp,
         lst_fax        LIKE LINE OF li_fax,
         li_role        TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-role-roles,
         lst_role       LIKE LINE OF li_role,
         li_comp_codes  TYPE zstqtc_customer_date_input-comp_code_data-comp_codes,
         lst_comp_codes LIKE LINE OF li_comp_codes,
         li_sales       TYPE zstqtc_customer_date_input-sales_data-sales_datas,
         lst_sales      LIKE LINE OF li_sales,
         li_credit      TYPE zstqtc_customer_date_input-crdt_coll_data-credit_data-credit_segment,
         li_time        TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-common-time_dependent_data-common_data,
         li_id          TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-ident_number-ident_numbers,
         lst_id         LIKE LINE OF li_id,
         li_coll        TYPE zstqtc_customer_date_input-crdt_coll_data-collection_data-coll_segment,
         lst_coll       LIKE LINE OF li_coll,
         li_dunning     TYPE cmds_ei_dunning_t,
         lst_dunning    LIKE LINE OF li_dunning,
         lst_time       LIKE LINE OF li_time,
         li_bp_input    TYPE ztqtc_customer_date_inputs,
         li_bp_output   TYPE ztqtc_customer_date_outputs,
         lst_bp_input   TYPE zstqtc_customer_date_input,
         li_sales_tax   TYPE zstqtc_customer_date_input-general_data-add_gen_data-tax_ind-tax_ind,
         lst_sales_tax  LIKE LINE OF li_sales_tax,
         lst_credit     LIKE LINE OF li_credit.

*---local segment workarea-------
  DATA:lst_e1kna1m          TYPE e1kna1m,
       lst_z1qtc_e1bpadsmtp TYPE z1qtc_e1bpadsmtp,
       lst_z1qtc_e1bpadtel  TYPE z1qtc_e1bpadtel,
       lst_z1qtc_e1bpadfax  TYPE z1qtc_e1bpadfax,
       lst_z1qtc_bu_general TYPE z1qtc_bu_general,
       lst_e1knb1m          TYPE e1knb1m,
       lst_e1knvvm          TYPE e1knvvm,
       lst_e1knvim          TYPE e1knvim,
       lst_e1knkkm          TYPE e1knkkm,
       lst_z1qtc_e1bpad1vl1 TYPE z1qtc_e1bpad1vl1,
       lst_z1qtc_e1bpad1vl  TYPE z1qtc_e1bpad1vl,
       lst_z1qtc_bu_ident   TYPE z1qtc_bu_ident,
       lst_e1knb5m          TYPE e1knb5m,
       lst_idoc_status      TYPE bdidocstat,
       lv_idocnum           TYPE edi_docnum,
       lv_knvp_cnt          TYPE char5.


  IF idoc_data[] IS NOT  INITIAL.
*---Free internal tables
    FREE:li_addresses, li_fax,        li_credit,   lst_dunning,   lst_credit,          lst_e1knb1m,
         lst_addresses,lst_smtp,      li_time,     lst_time,      lst_e1kna1m,         lst_e1knvvm,
         li_phone,     lst_fax,       li_id,       li_bp_input,   lst_z1qtc_e1bpadsmtp,sr_risk_cls,
         lst_phone,    li_role,       lst_id,      li_bp_output,  lst_z1qtc_e1bpadtel, lst_e1knvim,
         i_smtp,       lst_role,      li_coll,     lst_bp_input,  lst_z1qtc_e1bpadfax, lst_e1knkkm,
         li_sales,     li_comp_codes, lst_coll,    li_sales_tax,  lst_z1qtc_bu_general,lst_z1qtc_e1bpad1vl,
         lst_sales,    lst_comp_codes,li_dunning,  lst_sales_tax, lst_z1qtc_e1bpad1vl1,lst_z1qtc_bu_ident,
         lst_e1knb5m,  lv_idocnum,    i_constants, ir_bp_roles,   lst_idoc_status,     i_collect_ret,
         sr_coll_seg,  sr_coll_group, sr_coll_spl, sr_check_rule, sr_credit_grp,       iv_email_error,
         sr_coll_profile.

*---constant table entries for i0200.3
    PERFORM f_get_constants.

*----segment data mapping.

*-----Begin of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
    READ TABLE idoc_data ASSIGNING FIELD-SYMBOL(<fs_idoc>) WITH KEY segnam = c_e1kna1m.

    IF  sy-subrc = 0.
      lst_e1kna1m = <fs_idoc>-sdata.
*---External Business Partner
      IF lst_e1kna1m-kunnr IS NOT INITIAL.

        READ TABLE idoc_contrl INTO DATA(lst_idoc_control) INDEX 1.
*--check the WLS Control record
        IF  lst_idoc_control-mesfct IN ir_mesfct
          AND lst_idoc_control-mescod IS INITIAL.

*---Identify the Sold-to, Ship-to and Payer based on the accounting group
          IF lst_e1kna1m-ktokd IS NOT INITIAL.
            IF lst_e1kna1m-ktokd  = c_soldto.
              DATA(lv_bpfn) = c_ag.   "Sold-to party
            ELSEIF lst_e1kna1m-ktokd  = c_shipto.
              DATA(lv_id_flag) = abap_true.
              lv_bpfn = c_we.         "Ship-to party
            ELSEIF lst_e1kna1m-ktokd  = c_payer.
              FREE:lv_id_flag.
              lv_id_flag = abap_true.
              lv_bpfn = c_rg.         "Payer
            ENDIF.
            CLEAR lst_e1kna1m-ktokd.
          ENDIF.

*---check the corressponding partner functions
          PERFORM f_conversion_existing_kunnr USING lst_e1kna1m-kunnr.
          DATA(lv_kunnr) = lst_e1kna1m-kunnr.
*---check the Partner functions
          SELECT *
            FROM knvp
            INTO TABLE @DATA(li_knvp)
            WHERE kunnr = @lst_e1kna1m-kunnr
              AND vkorg IN @ir_vkorg.
          DATA(li_knvp_t) = li_knvp.
          DELETE  li_knvp WHERE parvw NE lv_bpfn.
          FREE:lv_knvp_cnt .
          DESCRIBE TABLE li_knvp LINES lv_knvp_cnt.
          CONDENSE lv_knvp_cnt .
          IF lv_knvp_cnt  EQ '1'.
            READ TABLE li_knvp INTO DATA(lst_knvp) WITH KEY kunnr = lst_e1kna1m-kunnr
                                                            parvw = lv_bpfn.
            IF sy-subrc = 0.
              DATA(lv_wls_bp) = lst_knvp-kunn2.
              lst_e1kna1m-kunnr = lst_knvp-kunn2.
              <fs_idoc>-sdata = lst_e1kna1m .
            ENDIF.

*---Check the Partner Identification for WLS
            IF lv_id_flag = abap_true.
              PERFORM f_conversion_existing_kunnr USING lst_e1kna1m-kunnr.
              SELECT SINGLE * FROM but0id INTO @DATA(lst_butid) WHERE partner = @lst_e1kna1m-kunnr AND type = @c_wls_id."'ZWGPID'.
              IF sy-subrc NE 0.
                lst_id-data_key-identificationnumber = lv_kunnr.
                lst_bp_input-general_data-gen_data-header-object_instance-identificationnumber = lv_kunnr." Identifcation Number
                lst_id-data_key-identificationcategory = c_wls_id. "Identfication Type
                lst_bp_input-general_data-gen_data-header-object_instance-identificationcategory = c_wls_id. "Identfication Type
                IF lst_id IS NOT INITIAL.
                  APPEND lst_id TO li_id.
                  CLEAR lst_id.
                ENDIF.
              ENDIF.
            ENDIF.
          ELSE.
*----failig the IDOC due to  multiple partner function found.
            lst_idoc_status-docnum = lst_idoc_control-docnum.
            lst_idoc_status-status  = c_51.
            lst_idoc_status-msgty   = c_e.
            lst_idoc_status-msgv1   = text-002.
            CONCATENATE lv_bpfn '-' lv_knvp_cnt
                        INTO lst_idoc_status-msgv2 SEPARATED BY space.
            lst_idoc_status-uname   = sy-uname.
            lst_idoc_status-repid   = sy-repid.
            APPEND lst_idoc_status TO idoc_status.
            CLEAR: lst_idoc_status.
            RETURN.
          ENDIF. "IF lv_knvp_lines EQ '1'.
        ELSE.
          PERFORM f_conversion_existing_kunnr USING lst_e1kna1m-kunnr.
          lv_wls_bp = lst_e1kna1m-kunnr.
        ENDIF.

        IF lv_wls_bp IS NOT INITIAL.
          lst_bp_input-general_data-gen_data-header-object_instance-bpartner = lv_wls_bp.
          SELECT SINGLE partner, type FROM but000 INTO @DATA(lv_bp_exist) WHERE partner = @lv_wls_bp.
          lst_bp_input-general_data-gen_data-central_data-common-data-bp_control-category = lv_bp_exist-type.
        ENDIF.
        FREE:lv_id_flag,lv_wls_bp,lv_kunnr.
      ENDIF.
    ENDIF.

    READ TABLE idoc_data INTO DATA(lst_idoc) WITH KEY segnam = c_z1qtc_bu_general.
    IF sy-subrc = 0.
      lst_z1qtc_bu_general = lst_idoc-sdata.
*---bp type or bp category
      IF lst_z1qtc_bu_general-type IS NOT INITIAL .
        lst_bp_input-general_data-gen_data-central_data-common-data-bp_control-category = lst_z1qtc_bu_general-type.
      ENDIF.
    ENDIF.
    CLEAR lst_idoc.
*-----End of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS

    LOOP AT idoc_data INTO lst_idoc.
      CASE lst_idoc-segnam.
*====================================================================*
*  General Data Mapping
*====================================================================*
        WHEN c_z1qtc_bu_general.
          lst_z1qtc_bu_general = lst_idoc-sdata.
*---BP type or BP Category
          IF lst_z1qtc_bu_general-type IS NOT INITIAL .
            lst_bp_input-general_data-gen_data-central_data-common-data-bp_control-category = lst_z1qtc_bu_general-type.
          ENDIF.
*-----Sex of BP
          IF lst_z1qtc_bu_general-sex IS NOT INITIAL.
            lst_bp_input-general_data-gen_data-central_data-common-data-bp_person-sex  = lst_z1qtc_bu_general-sex.
            lst_bp_input-general_data-gen_data-central_data-common-datax-bp_person-sex = abap_true.
          ENDIF.
*-----Date of Birth of Business Partner
          IF lst_z1qtc_bu_general-birthdate IS NOT INITIAL.
            lst_bp_input-general_data-gen_data-central_data-common-data-bp_person-birthdate  = lst_z1qtc_bu_general-birthdate.
            lst_bp_input-general_data-gen_data-central_data-common-datax-bp_person-birthdate = abap_true.
          ENDIF.
        WHEN c_e1kna1m.
          lst_e1kna1m = lst_idoc-sdata.
*---External Business Partner
          IF lst_e1kna1m-kunnr IS NOT INITIAL.
            lst_bp_input-general_data-gen_data-header-object_instance-bpartner = lst_e1kna1m-kunnr.
*-----Begin of comment VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
**            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
**              EXPORTING
**                input  = lst_e1kna1m-kunnr                                       " Business Partner Number (External)
**              IMPORTING
**                output = lst_e1kna1m-kunnr.
**            SELECT SINGLE partner FROM but000 INTO @DATA(lv_bp_exist) WHERE partner = @lst_e1kna1m-kunnr.
*-----End of comment VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
            IF lv_bp_exist IS NOT INITIAL.
              lst_bp_input-data_key-partner = lst_e1kna1m-kunnr.
            ENDIF.
          ENDIF.
*----First Name
          IF lst_bp_input-general_data-gen_data-central_data-common-data-bp_control-category = c_person. " ++ VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
            IF lst_e1kna1m-name1 IS NOT INITIAL.
              lst_bp_input-general_data-gen_data-central_data-common-data-bp_person-firstname = lst_e1kna1m-name1.
              lst_bp_input-general_data-gen_data-central_data-common-datax-bp_person-firstname = abap_true.
            ENDIF.
*----Last Name
            IF lst_e1kna1m-name2 IS NOT INITIAL.
              lst_bp_input-general_data-gen_data-central_data-common-data-bp_person-lastname = lst_e1kna1m-name2.
              lst_bp_input-general_data-gen_data-central_data-common-datax-bp_person-lastname = abap_true.
            ENDIF.
            IF lst_e1kna1m-name2 = '.'.
              lst_bp_input-general_data-gen_data-central_data-common-data-bp_person-lastname = ' '.
              lst_bp_input-general_data-gen_data-central_data-common-datax-bp_person-lastname = abap_true.
            ENDIF.
*-----Begin of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
          ELSEIF lst_bp_input-general_data-gen_data-central_data-common-data-bp_control-category = c_org.
            IF lst_e1kna1m-name1 IS NOT INITIAL.
              lst_bp_input-general_data-gen_data-central_data-common-data-bp_organization-name1   = lst_e1kna1m-name1.
              lst_bp_input-general_data-gen_data-central_data-common-datax-bp_organization-name1  = abap_true.
            ENDIF.
            IF lst_e1kna1m-name2 IS NOT INITIAL.
              lst_bp_input-general_data-gen_data-central_data-common-data-bp_organization-name2   = lst_e1kna1m-name2.
              lst_bp_input-general_data-gen_data-central_data-common-datax-bp_organization-name2  = abap_true.
            ENDIF.
            IF lst_e1kna1m-name2 = '.'.
              lst_bp_input-general_data-gen_data-central_data-common-data-bp_organization-name2  = abap_false.
              lst_bp_input-general_data-gen_data-central_data-common-datax-bp_organization-name2  = abap_true.
            ENDIF.
          ELSEIF lst_bp_input-general_data-gen_data-central_data-common-data-bp_control-category = c_grp.
            IF lst_e1kna1m-name1 IS NOT INITIAL.
              lst_bp_input-general_data-gen_data-central_data-common-data-bp_group-namegroup1   = lst_e1kna1m-name1.
              lst_bp_input-general_data-gen_data-central_data-common-datax-bp_group-namegroup1  = abap_true.
            ENDIF.
            IF lst_e1kna1m-name2 IS NOT INITIAL.
              lst_bp_input-general_data-gen_data-central_data-common-data-bp_group-namegroup2   = lst_e1kna1m-name2.
              lst_bp_input-general_data-gen_data-central_data-common-datax-bp_group-namegroup2  = abap_true.
            ENDIF.
            IF lst_e1kna1m-name2 = '.'.
              lst_bp_input-general_data-gen_data-central_data-common-data-bp_group-namegroup2   = abap_false.
              lst_bp_input-general_data-gen_data-central_data-common-datax-bp_group-namegroup2  = abap_true.
            ENDIF.
          ENDIF.
*-----End of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
*-----Country Name
          IF lst_e1kna1m-land1 IS NOT INITIAL.
            lst_addresses-data-postal-data-country  = lst_e1kna1m-land1.
            lst_addresses-data-postal-datax-country = abap_true.
          ENDIF.
*----Postal Code
          IF lst_e1kna1m-pstlz IS NOT INITIAL.
            lst_addresses-data-postal-data-postl_cod1 = lst_e1kna1m-pstlz.
            lst_addresses-data-postal-datax-postl_cod1 = abap_true.
          ENDIF.
*----Region (State, Province, County)
          IF lst_e1kna1m-regio IS NOT INITIAL.
            lst_addresses-data-postal-data-region = lst_e1kna1m-regio.
            lst_addresses-data-postal-datax-region = abap_true.
          ENDIF.
*----City Name
          IF lst_e1kna1m-ort01 IS NOT INITIAL.
            lst_addresses-data-postal-data-city = lst_e1kna1m-ort01.
            lst_addresses-data-postal-datax-city = abap_true.
          ENDIF.
*---Languagei
          IF lst_e1kna1m-spras_iso IS NOT INITIAL.
            lst_bp_input-general_data-gen_data-central_data-common-data-bp_person-correspondlanguage = lst_e1kna1m-spras_iso.
            lst_bp_input-general_data-gen_data-central_data-common-datax-bp_person-correspondlanguage = abap_true.
          ENDIF.
*----Address
          IF lst_e1kna1m-stras IS NOT INITIAL.
            lst_addresses-data-postal-data-street = lst_e1kna1m-stras.
            lst_addresses-data-postal-datax-street = abap_true.
          ENDIF.
*----Sold to Party(BU Group)
          IF lst_e1kna1m-ktokd IS NOT INITIAL.
            lst_bp_input-general_data-gen_data-central_data-common-data-bp_control-grouping = lst_e1kna1m-ktokd.
          ENDIF.
          IF lst_e1kna1m-ktokd IS NOT INITIAL.
            lst_bp_input-general_data-add_gen_data-central-data-ktokd = lst_e1kna1m-ktokd.
            lst_bp_input-general_data-add_gen_data-central-datax-ktokd = abap_true.
          ENDIF.

        WHEN c_z1qtc_e1bpadsmtp.
          lst_z1qtc_e1bpadsmtp = lst_idoc-sdata.

*----Email ID mapping
          CLEAR : lst_smtp.
          IF lst_z1qtc_e1bpadsmtp-e_mail IS NOT INITIAL.
            lst_smtp-contact-data-e_mail = lst_z1qtc_e1bpadsmtp-e_mail.
            lst_smtp-contact-datax-e_mail = abap_true.
          ENDIF.
          IF lst_z1qtc_e1bpadsmtp-email_srch IS NOT INITIAL.
            lst_smtp-contact-data-email_srch = lst_z1qtc_e1bpadsmtp-email_srch.
            lst_smtp-contact-datax-email_srch = abap_true.
          ENDIF.
          IF lst_smtp IS NOT INITIAL.
            APPEND lst_smtp TO i_smtp.
*-----Begin of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
            IF  lst_idoc_control-mesfct NOT IN ir_mesfct.
              IF lv_bp_exist IS NOT INITIAL.
                lst_addresses-data-communication-smtp-current_state = c_c.  "BP Update
              ENDIF.
*-----End of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
              lst_addresses-data-communication-smtp-smtp = i_smtp[].
              CLEAR : lst_smtp.
            ENDIF.
          ENDIF.

        WHEN c_z1qtc_e1bpadtel.
          lst_z1qtc_e1bpadtel = lst_idoc-sdata.
*---Telephone and Mobile number mapping
          IF lst_z1qtc_e1bpadtel-telephone IS NOT INITIAL.
            lst_phone-contact-data-telephone = lst_z1qtc_e1bpadtel-telephone.
            lst_phone-contact-datax-telephone = abap_true.
          ENDIF.
*---Tekephone Extension
          IF lst_z1qtc_e1bpadtel-extension IS NOT INITIAL.
            lst_phone-contact-data-extension  = lst_z1qtc_e1bpadtel-extension.
            lst_phone-contact-datax-extension  = abap_true.
          ENDIF.
          IF lst_z1qtc_e1bpadtel-tel_no IS NOT INITIAL.
            lst_phone-contact-data-tel_no  = lst_z1qtc_e1bpadtel-tel_no.
            lst_phone-contact-datax-tel_no  = abap_true.
          ENDIF.
*----Mobile Number
          IF lst_z1qtc_e1bpadtel-caller_no IS NOT INITIAL.
            lst_phone-contact-data-caller_no  = lst_z1qtc_e1bpadtel-caller_no.
            lst_phone-contact-datax-caller_no  = abap_true.
          ENDIF.
*-----Begin of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
          IF lst_z1qtc_e1bpadtel-r_3_user IS NOT INITIAL.
            lst_phone-contact-data-r_3_user  = lst_z1qtc_e1bpadtel-r_3_user.
            lst_phone-contact-datax-r_3_user  = abap_true.
          ENDIF.
*-----End of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
          IF lst_phone IS NOT INITIAL.
            APPEND lst_phone TO li_phone.
*-----Begin of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
            IF lv_bp_exist IS NOT INITIAL.
              lst_addresses-data-communication-phone-current_state = c_c.  "BP Update
            ENDIF.
*-----End of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
            lst_addresses-data-communication-phone-phone = li_phone[].
            CLEAR lst_phone.
          ENDIF.

        WHEN c_z1qtc_e1bpadfax.
*----Fax and extension Mapping
          lst_z1qtc_e1bpadfax = lst_idoc-sdata.
          IF lst_z1qtc_e1bpadfax-fax IS NOT INITIAL.
            lst_fax-contact-data-fax = lst_z1qtc_e1bpadfax-fax.
            lst_fax-contact-datax-fax = abap_true.
          ENDIF.
          IF lst_z1qtc_e1bpadfax-extension IS NOT INITIAL.
            lst_fax-contact-data-extension = lst_z1qtc_e1bpadfax-extension.
            lst_fax-contact-datax-extension = abap_true.
          ENDIF.
          IF lst_fax IS NOT INITIAL.
            APPEND lst_fax TO li_fax.
*-----Begin of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
            IF lv_bp_exist IS NOT INITIAL.
              lst_addresses-data-communication-fax-current_state = c_c.  "BP Update
            ENDIF.
*-----End of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
            lst_addresses-data-communication-fax-fax = li_fax[].
            CLEAR lst_fax.
          ENDIF.

        WHEN c_z1qtc_e1bpad1vl.
          lst_z1qtc_e1bpad1vl = lst_idoc-sdata.
*----Title
          IF lst_z1qtc_e1bpad1vl-title IS NOT INITIAL.
            lst_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-title_key  = lst_z1qtc_e1bpad1vl-title.
            lst_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-title_key = abap_true.
          ENDIF.
*----Search Term1
          IF lst_z1qtc_e1bpad1vl-sort1 IS NOT INITIAL.
            lst_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-searchterm1 = lst_z1qtc_e1bpad1vl-sort1.
            lst_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-searchterm1 = abap_true.
          ENDIF.
*----Search Term2
          IF lst_z1qtc_e1bpad1vl-sort2 IS NOT INITIAL.
            lst_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-searchterm2 = lst_z1qtc_e1bpad1vl-sort2.
            lst_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-searchterm2 = abap_true.
          ENDIF.
*----C O Name
          IF lst_z1qtc_e1bpad1vl-c_o_name IS NOT INITIAL.
            lst_addresses-data-postal-data-c_o_name  = lst_z1qtc_e1bpad1vl-c_o_name.
            lst_addresses-data-postal-datax-c_o_name = abap_true.
          ENDIF.
*------Valid from date
          IF lst_z1qtc_e1bpad1vl-from_date IS NOT INITIAL.
            lst_time-valid_from   = lst_z1qtc_e1bpad1vl-from_date.
            lst_time-valid_from_x = abap_true.
            APPEND lst_time TO li_time.
            FREE lst_time.
          ELSE.
            lst_time-valid_from   = sy-datum.
            lst_time-valid_from_x = abap_true.
            APPEND lst_time TO li_time.
            FREE lst_time.
          ENDIF.
*-----Begin of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
          READ TABLE idoc_contrl INTO lst_idoc_control INDEX 1.
*--check the WLS Control record
          IF  lst_idoc_control-mesfct IN ir_mesfct
            AND lst_idoc_control-mescod IS INITIAL.
*----Street 4
            lst_addresses-data-postal-data-str_suppl3  = lst_z1qtc_e1bpad1vl-str_suppl3.
            lst_addresses-data-postal-datax-str_suppl3 = abap_true.
*---Street 2
            lst_addresses-data-postal-data-str_suppl1  = lst_z1qtc_e1bpad1vl-str_suppl1.
            lst_addresses-data-postal-datax-str_suppl1 = abap_true.
*---Street 3
            lst_addresses-data-postal-data-str_suppl2  = lst_z1qtc_e1bpad1vl-str_suppl2.
            lst_addresses-data-postal-datax-str_suppl2 = abap_true.
          ELSE.
*----street 4
            IF lst_z1qtc_e1bpad1vl-str_suppl3 IS NOT INITIAL.
              lst_addresses-data-postal-data-str_suppl3  = lst_z1qtc_e1bpad1vl-str_suppl3.
              lst_addresses-data-postal-datax-str_suppl3 = abap_true.
            ENDIF.
*-----Begin of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS

*---Street 2
            IF lst_z1qtc_e1bpad1vl-str_suppl1 IS NOT INITIAL.
              lst_addresses-data-postal-data-str_suppl1  = lst_z1qtc_e1bpad1vl-str_suppl1.
              lst_addresses-data-postal-datax-str_suppl1 = abap_true.
            ENDIF.
*---Street 3
            IF lst_z1qtc_e1bpad1vl-str_suppl2 IS NOT INITIAL.
              lst_addresses-data-postal-data-str_suppl2  = lst_z1qtc_e1bpad1vl-str_suppl2.
              lst_addresses-data-postal-datax-str_suppl2 = abap_true.
            ENDIF.
          ENDIF.
*-----End of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS

*----Roles
          LOOP AT ir_bp_roles INTO DATA(lst_bp_roles).   "#EC CI_NESTED
            lst_role-data_key           = lst_bp_roles-low.
            lst_role-data-rolecategory  = lst_bp_roles-low.
            lst_role-data-valid_from    = lst_z1qtc_e1bpad1vl-from_date.
            lst_role-data-valid_to      = lst_z1qtc_e1bpad1vl-to_date.
            lst_role-datax-valid_from   = abap_true.
            lst_role-datax-valid_to     = abap_true.
            APPEND lst_role TO li_role.
            FREE:lst_role.
          ENDLOOP.
        WHEN c_z1qtc_e1bpad1vl1.
          lst_z1qtc_e1bpad1vl1 = lst_idoc-sdata.
*----Default Communication Type
          IF lst_z1qtc_e1bpad1vl1-comm_type IS NOT INITIAL.
            lst_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-comm_type = lst_z1qtc_e1bpad1vl1-comm_type.
            lst_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-comm_type = abap_true.
          ENDIF.

        WHEN c_e1knkkm.
*"----------------------------------------------------------------------
*--*Collection Profile data mapping
*"----------------------------------------------------------------------
          lst_e1knkkm = lst_idoc-sdata.
          IF lst_e1knkkm-kkber IS NOT INITIAL.
            lst_credit-credit_sgmnt = lst_e1knkkm-kkber.
            lst_credit-credit_limit = lst_e1knkkm-klimk.
            CONDENSE lst_credit-credit_limit.
            APPEND lst_credit TO li_credit.
            CLEAR lst_credit.
          ENDIF.

          IF sr_risk_cls-low IS NOT INITIAL.
            lst_bp_input-crdt_coll_data-credit_data-credit_profile-risk_class = sr_risk_cls-low.
          ENDIF.
          IF sr_check_rule-low IS NOT INITIAL.
            lst_bp_input-crdt_coll_data-credit_data-credit_profile-check_rule = sr_check_rule-low.
          ENDIF.
          IF sr_credit_grp-low IS NOT INITIAL.
            lst_bp_input-crdt_coll_data-credit_data-credit_profile-credit_group = sr_credit_grp-low.
          ENDIF.

          IF li_credit IS NOT INITIAL.
            lst_bp_input-crdt_coll_data-credit_data-credit_segment = li_credit[].
            CLEAR : li_credit.
          ENDIF.

        WHEN c_z1qtc_bu_ident.
*----Identfication number mapping
          lst_z1qtc_bu_ident = lst_idoc-sdata.
          IF lst_z1qtc_bu_ident-idnumber IS NOT INITIAL.
            lst_id-data_key-identificationnumber = lst_z1qtc_bu_ident-idnumber. " Identifcation Number
            lst_bp_input-general_data-gen_data-header-object_instance-identificationnumber = lst_z1qtc_bu_ident-idnumber.  " Identifcation Number
            IF lv_bp_exist IS NOT INITIAL.
              lst_bp_input-data_key-id_number = lst_z1qtc_bu_ident-idnumber.  " Identifcation Number
            ENDIF.
          ENDIF.

          IF lst_z1qtc_bu_ident-idnumber IS NOT INITIAL.
            lst_id-data_key-identificationcategory = lst_z1qtc_bu_ident-type. "Identfication Type
            lst_bp_input-general_data-gen_data-header-object_instance-identificationcategory = lst_z1qtc_bu_ident-type. "Identfication Type
            IF lv_bp_exist IS NOT INITIAL.
              lst_bp_input-data_key-id_category = lst_z1qtc_bu_ident-type. "Identfication Type
            ENDIF.
          ENDIF.
          IF lst_z1qtc_bu_ident-identrydate IS NOT INITIAL.
            lst_id-data-identrydate = lst_z1qtc_bu_ident-identrydate. " Identifcation Entry Date
          ENDIF.
          IF lst_z1qtc_bu_ident-idvalidfromdate IS NOT INITIAL.
            lst_id-data-idvalidfromdate = lst_z1qtc_bu_ident-idvalidfromdate. " Identifcation From Date
          ENDIF.
          IF lst_z1qtc_bu_ident-idvalidtodate IS NOT INITIAL.
            lst_id-data-idvalidtodate = lst_z1qtc_bu_ident-idvalidtodate. " Identifcation to Date
          ENDIF.
          IF lst_z1qtc_bu_ident-institute IS NOT INITIAL.
            lst_id-data-idinstitute = lst_z1qtc_bu_ident-institute. "Responsible Institution for ID
          ENDIF.
          IF lst_id IS NOT INITIAL.
            APPEND lst_id TO li_id.
            CLEAR lst_id.
          ENDIF.

*====================================================================*
*  Company Code data Mapping
*====================================================================*
        WHEN c_e1knb1m.
          lst_e1knb1m = lst_idoc-sdata.
          IF lst_e1knb1m-bukrs IS NOT INITIAL.
            lst_comp_codes-data_key-bukrs = lst_e1knb1m-bukrs.
          ENDIF.

          IF lst_e1knb1m-akont IS NOT INITIAL.
            lst_comp_codes-data-akont = lst_e1knb1m-akont.
            lst_comp_codes-datax-akont = abap_true.
          ENDIF.

          IF lst_e1knb1m-zuawa IS NOT INITIAL.
            lst_comp_codes-data-zuawa = lst_e1knb1m-zuawa .
            lst_comp_codes-datax-zuawa  = abap_true.
          ENDIF.

          IF lst_e1knb1m-zterm IS NOT INITIAL.
            lst_comp_codes-data-zterm = lst_e1knb1m-zterm.
            lst_comp_codes-datax-zterm = abap_true.
          ENDIF.

          IF lst_e1knb1m-xzver IS NOT INITIAL.
            lst_comp_codes-data-xzver =  lst_e1knb1m-xzver.
            lst_comp_codes-datax-xzver = abap_true.
          ENDIF.

          IF lst_e1knb1m-xausz IS NOT INITIAL.
            lst_comp_codes-data-xausz =  lst_e1knb1m-xausz .
            lst_comp_codes-datax-xausz = abap_true.
          ENDIF.

          IF lst_e1knb1m-busab IS NOT INITIAL.
            lst_comp_codes-data-busab =  lst_e1knb1m-busab.
            lst_comp_codes-datax-busab = abap_true.
          ENDIF.

*====================================================================*
*  FI Dunning data mapping
*====================================================================*
        WHEN c_e1knb5m.
          lst_e1knb5m = lst_idoc-sdata.
          IF lst_e1knb5m-mahna IS NOT INITIAL.
            lst_dunning-data-mahna = lst_e1knb5m-mahna.
            lst_dunning-datax-mahna = abap_true.
            APPEND lst_dunning TO li_dunning.
            CLEAR : lst_dunning.
            IF li_dunning[] IS NOT INITIAL.
              lst_comp_codes-dunning-dunning[] = li_dunning[].
              FREE: li_dunning[].
            ENDIF.
          ENDIF.
          IF lst_comp_codes IS NOT INITIAL.
            APPEND lst_comp_codes TO li_comp_codes.
            FREE:lst_comp_codes.
          ENDIF.
*====================================================================*
*  Sales & distribition Extension mapping
*====================================================================*
        WHEN c_e1knvvm.
          lst_e1knvvm = lst_idoc-sdata.
          IF lst_e1knvvm-vkorg IS NOT INITIAL.
            lst_sales-data_key-vkorg = lst_e1knvvm-vkorg.
            lst_sales-data_key-vtweg = lst_e1knvvm-vtweg.
            lst_sales-data_key-spart = lst_e1knvvm-spart.
          ENDIF.

          IF lst_e1knvvm-kdgrp IS NOT INITIAL.
            lst_sales-data-kdgrp = lst_e1knvvm-kdgrp.
            lst_sales-datax-kdgrp = abap_true.
          ENDIF.

          IF lst_e1knvvm-kalks IS NOT INITIAL.
            lst_sales-data-kalks = lst_e1knvvm-kalks.
            lst_sales-datax-kalks = abap_true.
          ENDIF.

          IF lst_e1knvvm-versg IS NOT INITIAL.
            lst_sales-data-versg = lst_e1knvvm-versg.
            lst_sales-datax-versg = abap_true.
          ENDIF.

          IF lst_e1knvvm-lprio IS NOT INITIAL.
            lst_sales-data-lprio = lst_e1knvvm-lprio.
            lst_sales-datax-lprio = abap_true.
          ENDIF.

          IF lst_e1knvvm-vsbed IS NOT INITIAL.
            lst_sales-data-vsbed = lst_e1knvvm-vsbed.
            lst_sales-datax-vsbed = abap_true.
          ENDIF.

          IF lst_e1knvvm-inco1 IS NOT INITIAL.
            lst_sales-data-inco1 = lst_e1knvvm-inco1.
            lst_sales-datax-inco1 = abap_true.
          ENDIF.

          IF lst_e1knvvm-inco2 IS NOT INITIAL.
            lst_sales-data-inco2 = lst_e1knvvm-inco2.
            lst_sales-datax-inco2 = abap_true.
          ENDIF.

          IF lst_e1knvvm-zterm IS NOT INITIAL.
            lst_sales-data-zterm = lst_e1knvvm-zterm.
            lst_sales-datax-zterm = abap_true.
          ENDIF.

          IF lst_e1knvvm-ktgrd IS NOT INITIAL.
            lst_sales-data-ktgrd = lst_e1knvvm-ktgrd.
            lst_sales-datax-ktgrd = abap_true.
          ENDIF.

          IF lst_e1knvvm-kkber IS NOT INITIAL.
            lst_sales-data-kkber = lst_e1knvvm-kkber.
            lst_sales-datax-kkber = abap_true.
          ENDIF.

          IF lst_e1knvvm-pltyp IS NOT INITIAL.
            lst_sales-data-pltyp = lst_e1knvvm-pltyp.
            lst_sales-datax-pltyp = abap_true.
          ENDIF.

          IF lst_e1knvvm-vwerk IS NOT INITIAL.
            lst_sales-data-vwerk = lst_e1knvvm-vwerk.
            lst_sales-datax-vwerk = abap_true.
          ENDIF.

          IF lst_e1knvvm-waers IS NOT INITIAL.
            lst_sales-data-waers = lst_e1knvvm-waers.
            lst_sales-datax-waers = abap_true.
          ENDIF.

          IF lst_e1knvvm-vkbur IS NOT INITIAL.
            lst_sales-data-vkbur = lst_e1knvvm-vkbur.
            lst_sales-datax-vkbur = abap_true.
          ENDIF.

          IF lst_e1knvvm-bzirk IS NOT INITIAL.
            lst_sales-data-bzirk = lst_e1knvvm-bzirk.
            lst_sales-datax-bzirk = abap_true.
          ENDIF.
          IF lst_sales IS NOT INITIAL.
            APPEND lst_sales TO li_sales.
            CLEAR : lst_sales.
          ENDIF.

        WHEN c_e1knvim.
          lst_e1knvim = lst_idoc-sdata.
*"----------------------------------------------------------------------
*--*S&D Sales tax Info
*"---------------------------------------------------------------------
          IF lst_e1knvim-tatyp IS NOT INITIAL.
            lst_sales_tax-data_key-tatyp = lst_e1knvim-tatyp.
          ENDIF.
          IF lst_e1knvim-aland IS NOT INITIAL..
            lst_sales_tax-data_key-aland = lst_e1knvim-aland.
          ENDIF.
          IF lst_e1knvim-taxkd IS NOT INITIAL.
            lst_sales_tax-data-taxkd = lst_e1knvim-taxkd .
            lst_sales_tax-datax-taxkd = abap_true.
            APPEND lst_sales_tax TO li_sales_tax.
            CLEAR lst_sales_tax.
            IF li_sales_tax[] IS NOT INITIAL.
              lst_bp_input-general_data-add_gen_data-tax_ind-tax_ind[] = li_sales_tax[].
              FREE : li_sales_tax[].
            ENDIF.
          ENDIF.
      ENDCASE.
      lv_idocnum = lst_idoc-docnum.
    ENDLOOP.
*"----------------------------------------------------------------------
*--*Collection Profile data mapping
*"----------------------------------------------------------------------

    IF sr_coll_profile-low IS NOT INITIAL.
      lst_bp_input-crdt_coll_data-collection_data-coll_profile-coll_profile = sr_coll_profile-low.
    ENDIF.
    IF sr_coll_seg-low IS NOT INITIAL.
      lst_coll-coll_segment = sr_coll_seg-low.
    ENDIF.
    IF sr_coll_group-low IS NOT INITIAL.
      lst_coll-coll_group = sr_coll_group-low.
    ENDIF.
    IF sr_coll_spl-low IS NOT INITIAL.
      lst_coll-coll_specialist = sr_coll_spl-low.
    ENDIF.
    IF lst_coll IS NOT INITIAL.
      APPEND lst_coll TO li_coll.
      CLEAR lst_coll.
      lst_bp_input-crdt_coll_data-collection_data-coll_segment[] = li_coll[].
      CLEAR : li_coll[].
    ENDIF.

    IF li_role IS NOT INITIAL.
      lst_bp_input-general_data-gen_data-central_data-role-roles[] = li_role[].
      FREE: li_role[],
      lst_role.
    ENDIF.

    IF lst_addresses IS NOT INITIAL.
      APPEND lst_addresses TO li_addresses.
      FREE : lst_addresses.
      lst_bp_input-general_data-gen_data-central_data-address-addresses[] = li_addresses[].
    ENDIF.

*-----Begin of change VDPATABALL 06/26/2020 ERPM-22990  BP Update for WLS
    IF lst_idoc_control-mesfct IN ir_mesfct AND lst_idoc_control-mescod IS INITIAL.
      IF i_smtp[] IS NOT INITIAL
        AND lst_z1qtc_e1bpadsmtp IS NOT INITIAL.
        READ TABLE li_knvp_t INTO lst_knvp WITH KEY parvw = c_ap.
        IF sy-subrc = 0.
          PERFORM f_contact_email_upd USING lst_z1qtc_e1bpadsmtp
                                            lst_knvp.
          FREE:i_smtp[],li_knvp_t.
        ENDIF.
      ENDIF.
    ENDIF.
*-----End of change VDPATABALL 06/26/2020 ERPM-22990  BP Update for WLS

    IF i_smtp[] IS NOT INITIAL.
      lst_bp_input-general_data-gen_data-central_data-communication-smtp-smtp[] = i_smtp[].
      lst_addresses-data-communication-smtp-smtp = i_smtp[].
      FREE i_smtp[].
    ENDIF.
    IF li_phone[] IS NOT INITIAL.
      lst_bp_input-general_data-gen_data-central_data-communication-phone-phone[] = li_phone[].
      lst_addresses-data-communication-phone-phone = li_phone[].
      FREE : li_phone[].
    ENDIF.
    IF li_fax[] IS NOT INITIAL.
      lst_bp_input-general_data-gen_data-central_data-communication-fax-fax[] = li_fax[].
      lst_addresses-data-communication-fax-fax = li_fax[].
      FREE : li_fax[].
    ENDIF.
*----passing identification details to general data
    IF li_id[] IS NOT INITIAL.
      lst_bp_input-general_data-gen_data-central_data-ident_number-ident_numbers[] = li_id[].
      FREE: li_id[].
    ENDIF.
    IF li_time[] IS NOT INITIAL.
      lst_bp_input-general_data-gen_data-central_data-common-time_dependent_data-common_data[] = li_time[].
      FREE : li_time[].
    ENDIF.
    IF li_comp_codes[] IS NOT INITIAL.
      lst_bp_input-comp_code_data-comp_codes[] = li_comp_codes[].
      FREE:li_comp_codes[].
    ENDIF.
    IF li_sales[] IS NOT INITIAL.
      lst_bp_input-sales_data-sales_datas[]    = li_sales[].
      FREE:li_sales[].
    ENDIF.

    FREE: lv_bp_exist.
    IF lst_bp_input IS NOT INITIAL.
      APPEND lst_bp_input TO li_bp_input.
      CLEAR lst_bp_input.
    ENDIF.

*--calling BP creation RFC interface
    CALL FUNCTION 'ZQTC_CUSTOMER_IB_INTERFACE'
      EXPORTING
        im_data   = li_bp_input
      IMPORTING
        ex_return = li_bp_output.

****---status record updation from the return messages
    IF li_bp_output IS NOT INITIAL.
      LOOP AT li_bp_output INTO DATA(lst_output).
        APPEND LINES OF lst_output-messages TO i_collect_ret.
      ENDLOOP.
      READ TABLE i_collect_ret INTO DATA(lst_collect_ret) WITH KEY type = c_e.
      IF sy-subrc = 0.
        CLEAR lst_idoc_status.
        lst_idoc_status-docnum = lv_idocnum.
        lst_idoc_status-status = c_51.
        lst_idoc_status-msgty = lst_collect_ret-type.
        lst_idoc_status-msgid = lst_collect_ret-id.
        lst_idoc_status-msgno = lst_collect_ret-number.
        lst_idoc_status-msgv1 = lst_collect_ret-message.
        lst_idoc_status-msgv2 = lst_collect_ret-message_v1.
        lst_idoc_status-msgv3 = lst_collect_ret-message_v2.
        lst_idoc_status-msgv4 = lst_collect_ret-message_v3.
        lst_idoc_status-uname = sy-uname.
        lst_idoc_status-repid = sy-repid.
        APPEND lst_idoc_status TO idoc_status.
        CLEAR: lst_idoc_status,
        lst_collect_ret.
      ELSE.
        CLEAR: lst_idoc_status,lst_collect_ret.
        READ TABLE i_collect_ret INTO lst_collect_ret WITH KEY type = c_s.
        IF sy-subrc  = 0
          AND iv_email_error = abap_false. "++VDPATABALL 06/26/2020 ERPM-22990
          CLEAR lst_idoc_status.
          lst_idoc_status-docnum = lv_idocnum.
          lst_idoc_status-status = c_53.
          lst_idoc_status-msgty = lst_collect_ret-type.
          lst_idoc_status-msgid = lst_collect_ret-id.
          lst_idoc_status-msgno = lst_collect_ret-number.
          lst_idoc_status-msgv1 = lst_collect_ret-message.
          lst_idoc_status-msgv2 = lst_collect_ret-message_v1.
          lst_idoc_status-msgv3 = lst_collect_ret-message_v2.
          lst_idoc_status-msgv4 = lst_collect_ret-message_v3.
          lst_idoc_status-uname = sy-uname.
          lst_idoc_status-repid = sy-repid.
          APPEND lst_idoc_status TO idoc_status.
          CLEAR: lst_idoc_status,
          lst_collect_ret.
        ENDIF.
      ENDIF.
    ENDIF.
*-----Begin of change VDPATABALL 06/26/2020 ERPM-22990  BP Update for WLS
*---For Mutiple Email Id Status
    IF iv_email_error = abap_true.
      lst_idoc_status-docnum  = lv_idocnum.
      lst_idoc_status-status  = c_51.
      lst_idoc_status-msgty   = c_e.
      lst_idoc_status-msgv1   = 'Email Updation failed for contact person'(001).
      lst_idoc_status-msgv2   = iv_cont.
      lst_idoc_status-uname   = sy-uname.
      lst_idoc_status-repid   = sy-repid.
      APPEND lst_idoc_status TO idoc_status.
      CLEAR: lst_idoc_status.
    ENDIF.
*-----End of change VDPATABALL 06/26/2020 ERPM-22990  BP Update for WLS
  ENDIF.
ENDFUNCTION.
