*&---------------------------------------------------------------------*
*&  Include           ZRTR_BP_INIT_LOAD_EXT_C121_F01
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:          ZRTR_BP_INIT_LOAD_EXTEND_C121_F01(INCLUDE)
* PROGRAM DESCRIPTION:   Program to transfer Business partners
*                        from file and this program is copy of
*                        ZRTR_BP_INIT_LOAD_EXTEND
* DEVELOPER:             Vishnuvardhan Reddy(VCHITTIBAL)
* CREATION DATE:         04/29/2022
* OBJECT ID:             C121
* TRANSPORT NUMBER(S):   ED2K927116
*----------------------------------------------------------------------*
FORM get_filename CHANGING p_filename.

  CALL FUNCTION 'WS_FILENAME_GET'
    EXPORTING
      def_filename     = space
      def_path         = p_filename
*     MASK             = ' '
      mode             = 'O'
      title            = 'Please select the file'
    IMPORTING
      filename         = p_filename
*     RC               =
    EXCEPTIONS
      inv_winsys       = 1
      no_batch         = 2
      selection_cancel = 3
      selection_error  = 4
      OTHERS           = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM get_data_from_file.
  DATA: ls_data          TYPE  alsmex_tabline,
        ls_bp_data       TYPE ty_bp_details,
        lv_row           TYPE  kcd_ex_row_n,
        ls_role          TYPE bus_ei_bupa_roles,
        lv_no_of_records TYPE i.

  FIELD-SYMBOLS:<fs_value> TYPE char50.

  IF sy-batch = space.
    DATA:li_type       TYPE truxs_t_text_data.
    FREE:gt_bp_data.

*--foreground file fetching into internal table
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = abap_true
        i_tab_raw_data       = li_type
        i_filename           = p_file
      TABLES
        i_tab_converted_data = gt_bp_data
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    DESCRIBE TABLE gt_bp_data LINES lv_no_of_records.

    SELECT *
       FROM zcainteg_mapping
       INTO TABLE gt_const
       WHERE devid = c_devid
       AND activate = c_x.

    IF sy-subrc EQ 0.
      SORT gt_const BY param1.
    ENDIF..
    READ TABLE  gt_const INTO DATA(ls_const) WITH KEY param1 = c_param1.

    IF lv_no_of_records IS NOT INITIAL AND ls_const-sap_value IS NOT INITIAL.

      IF lv_no_of_records > ls_const-sap_value.
        CLEAR ls_const .
        READ TABLE  gt_const INTO ls_const WITH KEY param1 = c_param2.
        IF sy-subrc = 0.
          PERFORM submit_program_in_background USING ls_const-sap_value.
        ENDIF.
      ENDIF.
    ENDIF.

  ELSE.
    CLEAR gt_bp_data.
    OPEN DATASET p_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    DO.
      READ DATASET p_file INTO ls_bp_data.
      IF sy-subrc = 0.
        APPEND ls_bp_data TO gt_bp_data.
        CLEAR ls_bp_data .
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.
  ENDIF.


ENDFORM.

FORM create_bp USING ls_bp_data TYPE ty_bp_details.
  DATA: i_data       TYPE zstqtc_customer_date_input,
        i_data_table TYPE ztqtc_customer_date_inputs.
  DATA: lv_msg_string TYPE string.
  DATA: ls_msg TYPE ty_msg.
  DATA: lv_msg_type	 TYPE	bapi_mtype.

  DATA: lt_indent     TYPE bus_ei_bupa_identification_t,
        ls_indent     TYPE bus_ei_bupa_identification,
        lt_address    TYPE bus_ei_bupa_address_t,
        ls_address    TYPE bus_ei_bupa_address,
        lt_phone      TYPE bus_ei_bupa_telephone_t,
        ls_phone      TYPE bus_ei_bupa_telephone,
        lt_fax        TYPE bus_ei_bupa_fax_t,
        ls_fax        TYPE bus_ei_bupa_fax,
        lt_stmp       TYPE bus_ei_bupa_smtp_t,
        ls_stmp       TYPE bus_ei_bupa_smtp,
        lt_compcode   TYPE cmds_ei_company_t,
        ls_compcode   TYPE cmds_ei_company,
        lt_sales      TYPE cmds_ei_sales_t,
        ls_sales      TYPE cmds_ei_sales,
        ls_credit_seg TYPE z1rtr_bp_credit_seg_data,
        lt_credit_seg TYPE ztqtc_credit_seg_data,
        lt_coll_seg   TYPE ztqtc_collection_seg_data,
        ls_coll_seg   TYPE z1rtr_bp_coll_seg_data,
        i_output      TYPE ztqtc_customer_date_outputs,
        ls_output     TYPE zstqtc_customer_date_output,
        ls_message    TYPE bapiretc,
        lt_dunning    TYPE cmds_ei_dunning_t,
        ls_dunning    TYPE cmds_ei_dunning,
        lt_functions  TYPE  cmds_ei_functions_t,
        ls_functions  TYPE  cmds_ei_functions,
        lt_tax        TYPE cmds_ei_tax_ind_t,
        ls_tax        TYPE cmds_ei_tax_ind.

  DATA:         lt_role                 TYPE  bus_ei_bupa_roles_t.
  DATA: ls_role TYPE bus_ei_bupa_roles.



  CLEAR: ls_indent, lt_indent, lt_address, lt_address, lt_phone, ls_phone,
          lt_fax, ls_fax,lt_stmp,ls_stmp ,lt_compcode, ls_compcode,
          lt_sales, ls_sales, ls_credit_seg, lt_credit_seg, lt_coll_seg,
          ls_coll_seg, i_output, lt_dunning, ls_dunning, ls_role, lt_role ,ls_tax, lt_tax .


  IF  ls_bp_data-partner NE space.
    i_data-data_key-partner =  ls_bp_data-partner.
  ENDIF.
  IF ls_bp_data-category NE space.
    i_data-general_data-gen_data-central_data-common-data-bp_control-category = ls_bp_data-category.
  ENDIF.

  IF ls_bp_data-grouping NE space.
    i_data-general_data-gen_data-central_data-common-data-bp_control-grouping = ls_bp_data-grouping .
  ENDIF.

  IF ls_bp_data-searchterm1 NE space.
    i_data-general_data-gen_data-central_data-common-data-bp_centraldata-searchterm1 = ls_bp_data-searchterm1.
    i_data-general_data-gen_data-central_data-common-datax-bp_centraldata-searchterm1 =  c_x.
  ENDIF.

  IF ls_bp_data-searchterm2 NE space.
    i_data-general_data-gen_data-central_data-common-data-bp_centraldata-searchterm2 = ls_bp_data-searchterm2.
    i_data-general_data-gen_data-central_data-common-datax-bp_centraldata-searchterm2 = c_x.
  ENDIF.

  IF ls_bp_data-category = 2.
    IF ls_bp_data-name_org1 NE space.
      i_data-general_data-gen_data-central_data-common-data-bp_organization-name1 = ls_bp_data-name_org1.
      i_data-general_data-gen_data-central_data-common-datax-bp_organization-name1 = c_x.
    ENDIF.
    IF ls_bp_data-name_org2 NE space.
      i_data-general_data-gen_data-central_data-common-data-bp_organization-name2 = ls_bp_data-name_org2.
      i_data-general_data-gen_data-central_data-common-datax-bp_organization-name2 = c_x.
    ENDIF.
  ENDIF.

  IF ls_bp_data-category = 1.
    IF ls_bp_data-firstname NE space.
      i_data-general_data-gen_data-central_data-common-data-bp_person-firstname = ls_bp_data-firstname.
      i_data-general_data-gen_data-central_data-common-datax-bp_person-firstname = c_x.
    ENDIF.
    IF ls_bp_data-lastname NE space.
      i_data-general_data-gen_data-central_data-common-data-bp_person-lastname = ls_bp_data-lastname.
      i_data-general_data-gen_data-central_data-common-datax-bp_person-lastname = c_x.
    ENDIF.
  ENDIF.

  IF ls_bp_data-langu  NE space.
    i_data-general_data-gen_data-central_data-common-data-bp_person-correspondlanguage = ls_bp_data-langu .
    i_data-general_data-gen_data-central_data-common-datax-bp_person-correspondlanguage = c_x.
  ENDIF.


  ls_role-data-rolecategory =  'FLCU00'.
  APPEND ls_role TO lt_role.
  CLEAR ls_role.

  IF ls_bp_data-vkorg NE space.
    ls_role-data-rolecategory = 'ISM000'.
    APPEND ls_role TO lt_role.
    CLEAR ls_role.
  ENDIF.

  IF ls_bp_data-coll_segment NE space.
    ls_role-data-rolecategory =  'UDM000'.
    APPEND ls_role TO lt_role.
    CLEAR ls_role.
  ENDIF.

  IF ls_bp_data-credit_sgmnt  NE space.
    ls_role-data-rolecategory = 'UKM000'.
    APPEND ls_role TO lt_role.
    CLEAR ls_role.
  ENDIF.


  IF NOT lt_role[] IS INITIAL.
    i_data-general_data-gen_data-central_data-role-roles = lt_role.
  ENDIF.

  IF ls_bp_data-identificationcategory NE space AND ls_bp_data-identificationnumber NE space.
    ls_indent-data_key-identificationcategory = ls_bp_data-identificationcategory.
    ls_indent-data_key-identificationnumber = ls_bp_data-identificationnumber.
    IF ls_bp_data-entry_date IS NOT INITIAL.
      ls_indent-data-identrydate = ls_bp_data-entry_date.
    ENDIF.
    IF ls_bp_data-idvalidfromdate IS NOT INITIAL.
      ls_indent-data-idvalidfromdate = ls_bp_data-idvalidfromdate.
    ENDIF.
    IF ls_bp_data-idvalidtodate IS NOT INITIAL.
      ls_indent-data-idvalidtodate = ls_bp_data-idvalidtodate.
    ENDIF.
    APPEND ls_indent TO lt_indent.
    CLEAR ls_indent.
  ENDIF.


  IF ls_bp_data-identificationcategory2 NE space AND ls_bp_data-identificationnumber2 NE space.
    ls_indent-data_key-identificationcategory = ls_bp_data-identificationcategory2.
    ls_indent-data_key-identificationnumber = ls_bp_data-identificationnumber2.
    IF ls_bp_data-entry_date2 IS NOT INITIAL.
      ls_indent-data-identrydate = ls_bp_data-entry_date2.
    ENDIF.
    IF ls_bp_data-idvalidfromdate2 IS NOT INITIAL.
      ls_indent-data-idvalidfromdate = ls_bp_data-idvalidfromdate2.
    ENDIF.
    IF ls_bp_data-idvalidtodate2 IS NOT INITIAL.
      ls_indent-data-idvalidtodate = ls_bp_data-idvalidtodate2.
    ENDIF.
    APPEND ls_indent TO lt_indent.
    CLEAR ls_indent.
  ENDIF.

  IF ls_bp_data-identificationcategory3 NE space AND ls_bp_data-identificationnumber3 NE space.
    ls_indent-data_key-identificationcategory = ls_bp_data-identificationcategory3.
    ls_indent-data_key-identificationnumber = ls_bp_data-identificationnumber3.
    IF ls_bp_data-entry_date3 IS NOT INITIAL.
      ls_indent-data-identrydate = ls_bp_data-entry_date3.
    ENDIF.
    IF ls_bp_data-idvalidfromdate3 IS NOT INITIAL.
      ls_indent-data-idvalidfromdate = ls_bp_data-idvalidfromdate3.
    ENDIF.
    IF ls_bp_data-idvalidtodate3 IS NOT INITIAL.
      ls_indent-data-idvalidtodate = ls_bp_data-idvalidtodate3.
    ENDIF.
    APPEND ls_indent TO lt_indent.
    CLEAR ls_indent.
  ENDIF.
*----Begin of change VDPATABALL- C105 - WLS additional fields-ERPM-11885 05/28/2020
  IF ls_bp_data-identificationcategory4 NE space AND ls_bp_data-identificationnumber4 NE space.
    ls_indent-data_key-identificationcategory = ls_bp_data-identificationcategory4.
    ls_indent-data_key-identificationnumber = ls_bp_data-identificationnumber4.
    IF ls_bp_data-entry_date4 IS NOT INITIAL.
      ls_indent-data-identrydate = ls_bp_data-entry_date4.
    ENDIF.
    IF ls_bp_data-idvalidfromdate4 IS NOT INITIAL.
      ls_indent-data-idvalidfromdate = ls_bp_data-idvalidfromdate4.
    ENDIF.
    IF ls_bp_data-idvalidtodate4 IS NOT INITIAL.
      ls_indent-data-idvalidtodate = ls_bp_data-idvalidtodate4.
    ENDIF.
    APPEND ls_indent TO lt_indent.
    CLEAR ls_indent.
  ENDIF.

  IF NOT lt_indent[] IS INITIAL.
    i_data-general_data-gen_data-central_data-ident_number-ident_numbers =  lt_indent.
  ENDIF.
*Address

  ls_address-task = 'S'.   "Standard

  IF ls_bp_data-city NE space.
    ls_address-data-postal-data-city = ls_bp_data-city.
    ls_address-data-postal-datax-city = 'X'.
  ENDIF.
  IF ls_bp_data-name_co NE space.
    ls_address-data-postal-data-c_o_name = ls_bp_data-name_co.
    ls_address-data-postal-datax-c_o_name = 'X'.
  ENDIF.

  IF ls_bp_data-postl_cod1 NE space.
    ls_address-data-postal-data-postl_cod1 = ls_bp_data-postl_cod1.
    ls_address-data-postal-datax-postl_cod1 = 'X'.
  ENDIF.

  IF  ls_bp_data-region NE space.
    ls_address-data-postal-data-region =   ls_bp_data-region.
    ls_address-data-postal-datax-region =  'X'.
  ENDIF.

  IF ls_bp_data-street NE space.
    ls_address-data-postal-data-street = ls_bp_data-street .
    ls_address-data-postal-datax-street = 'X'.
  ENDIF.

  IF ls_bp_data-street2 NE space.
    ls_address-data-postal-data-str_suppl1 = ls_bp_data-street2 .
    ls_address-data-postal-datax-str_suppl1 = 'X'.
  ENDIF.
  IF ls_bp_data-street3 NE space.
    ls_address-data-postal-data-str_suppl2 = ls_bp_data-street3 .
    ls_address-data-postal-datax-str_suppl2 = abap_true.
  ENDIF.
  IF ls_bp_data-street4 NE space.
    ls_address-data-postal-data-str_suppl3 = ls_bp_data-street4 .
    ls_address-data-postal-datax-str_suppl3 = abap_true.
  ENDIF.
  IF ls_bp_data-street5 NE space.
    ls_address-data-postal-data-location = ls_bp_data-street5.
    ls_address-data-postal-datax-str_suppl1 = abap_true.
  ENDIF.
  IF ls_bp_data-country  NE space.
    ls_address-data-postal-data-country = ls_bp_data-country.
    ls_address-data-postal-datax-country  = 'X'.
  ENDIF.

  IF ls_bp_data-langu NE space.
    ls_address-data-postal-data-langu = ls_bp_data-langu .
    ls_address-data-postal-datax-langu = 'X'.
  ENDIF.

  IF ls_bp_data-comm_type NE space.
    ls_address-data-postal-data-comm_type = ls_bp_data-comm_type.
    ls_address-data-postal-datax-comm_type = 'X'.
  ENDIF.

  IF ls_bp_data-telephone NE space.
    ls_address-data-communication-phone-current_state = 'X'.
    ls_phone-contact-task = 'M'.
    ls_phone-contact-data-telephone = ls_bp_data-telephone.
    ls_phone-contact-datax-telephone =  'X'.
    IF ls_bp_data-extension NE space.
      ls_phone-contact-data-extension = ls_bp_data-extension.
      ls_phone-contact-datax-extension =  'X'.
    ENDIF.
    APPEND ls_phone TO lt_phone.
    CLEAR ls_phone.
  ENDIF.

*Mobile
  IF ls_bp_data-mob_number NE space.
    ls_address-data-communication-phone-current_state = 'X'.
    ls_phone-contact-task = 'M'.
    ls_phone-contact-data-telephone = ls_bp_data-mob_number.
    ls_phone-contact-data-r_3_user  = 3.
    ls_phone-contact-datax-telephone =  'X'.
    ls_phone-contact-datax-r_3_user  = 'X'.
    APPEND ls_phone TO lt_phone.
    CLEAR ls_phone.
  ENDIF.



  IF ls_bp_data-fax NE space.
    ls_address-data-communication-fax-current_state = 'X'.
    ls_fax-contact-task = 'M'.
    ls_fax-contact-data-fax = ls_bp_data-fax.
    ls_fax-contact-datax-fax = 'X'.
    IF ls_bp_data-f_extension NE space.
      ls_fax-contact-data-extension = ls_bp_data-f_extension.
      ls_fax-contact-datax-extension =  'X'.
    ENDIF.
    APPEND ls_fax TO lt_fax.
    CLEAR ls_fax.
  ENDIF.

  IF ls_bp_data-e_mail NE space.
    ls_address-data-communication-smtp-current_state = 'X'.
    ls_stmp-contact-task = 'M'.
    ls_stmp-contact-data-e_mail = ls_bp_data-e_mail.
    ls_stmp-contact-datax-e_mail = 'X'.
    APPEND ls_stmp TO lt_stmp.
    CLEAR ls_stmp.
  ENDIF.

  IF NOT lt_phone[] IS INITIAL.
    ls_address-data-communication-phone-phone = lt_phone.
  ENDIF.
  IF NOT lt_fax[] IS INITIAL.
    ls_address-data-communication-fax-fax     = lt_fax.
  ENDIF.
  IF NOT lt_stmp[] IS INITIAL.
    ls_address-data-communication-smtp-smtp   = lt_stmp.
  ENDIF.

  APPEND ls_address TO lt_address.
  CLEAR ls_address.


  IF  lt_address[] IS NOT INITIAL.
    i_data-general_data-gen_data-central_data-address-addresses = lt_address.
  ENDIF.

  IF ls_bp_data-bukrs NE space.
    ls_compcode-task = 'M'.
    ls_compcode-data_key-bukrs = ls_bp_data-bukrs.
  ENDIF.

  IF ls_bp_data-akont NE space.
    ls_compcode-data-akont = ls_bp_data-akont.  "Recon account
    ls_compcode-datax-akont = 'X'.
  ENDIF.


  IF ls_bp_data-zuawa NE space.
    ls_compcode-data-zuawa = ls_bp_data-zuawa.  "Sort Key
    ls_compcode-datax-zuawa = 'X'.
  ENDIF.


  IF ls_bp_data-zterm NE space.
    ls_compcode-data-zterm = ls_bp_data-zterm.
    ls_compcode-datax-zterm = 'X'.
  ENDIF.
  IF ls_bp_data-busab NE space.
    ls_compcode-data-busab = ls_bp_data-busab.
    ls_compcode-datax-busab = 'X'.
  ENDIF.
  IF ls_bp_data-xausz NE space.
    ls_compcode-data-xausz = ls_bp_data-xausz.
    ls_compcode-datax-xausz = 'X'.
  ENDIF.
  IF ls_bp_data-xzver NE space.
    ls_compcode-data-xzver  = ls_bp_data-xzver.
    ls_compcode-datax-xzver  = 'X'.
  ENDIF.

  IF ls_bp_data-mahna NE space.
    ls_dunning-data-mahna = ls_bp_data-mahna .
    ls_dunning-datax-mahna = 'X'.

    APPEND ls_dunning TO lt_dunning.
    CLEAR ls_dunning.
    ls_compcode-dunning-dunning  = lt_dunning.
  ENDIF.

  APPEND ls_compcode TO lt_compcode.
  CLEAR ls_compcode.

*Sales area
  IF ls_bp_data-vkorg NE space.
    ls_sales-data_key-vkorg = ls_bp_data-vkorg.
  ENDIF.

  IF ls_bp_data-vtweg NE space.
    ls_sales-data_key-vtweg = ls_bp_data-vtweg.
  ENDIF.

  IF ls_bp_data-spart NE space.
    ls_sales-data_key-spart =  ls_bp_data-spart .
  ENDIF.

  IF ls_bp_data-sales_off NE space.
    ls_sales-data-vkbur = ls_bp_data-sales_off.
  ENDIF.

  IF ls_bp_data-versg NE space.
    ls_sales-data-versg = ls_bp_data-versg.
  ENDIF.

  IF ls_bp_data-kalks NE space.
    ls_sales-data-kalks = ls_bp_data-kalks.
  ENDIF.
  IF ls_bp_data-kdgrp NE space.
    ls_sales-data-kdgrp = ls_bp_data-kdgrp.
  ENDIF.

  IF ls_bp_data-vwerk  NE space.
    ls_sales-data-vwerk = ls_bp_data-vwerk.
  ENDIF.

  IF ls_bp_data-pltyp NE space.
    ls_sales-data-pltyp = ls_bp_data-pltyp .
  ENDIF.

  IF ls_bp_data-inco1 NE space.
    ls_sales-data-inco1 = ls_bp_data-inco1.
  ENDIF.
  IF ls_bp_data-inco1 NE space.
    ls_sales-data-inco2 = ls_bp_data-inco2.
  ENDIF.
  IF ls_bp_data-lprio NE space.
    ls_sales-data-lprio = ls_bp_data-lprio.
  ENDIF.
  IF ls_bp_data-vsbed NE space.
    ls_sales-data-vsbed =  ls_bp_data-vsbed .
  ENDIF.

  IF ls_bp_data-waers NE space.
    ls_sales-data-waers = ls_bp_data-waers.
  ENDIF.

  IF ls_bp_data-ktgrd NE space.
    ls_sales-data-ktgrd = ls_bp_data-ktgrd.
  ENDIF.
  IF ls_bp_data-konda NE space.
    ls_sales-data-konda = ls_bp_data-konda.
  ENDIF.

  IF ls_bp_data-s_zterm NE space.
    ls_sales-data-zterm = ls_bp_data-s_zterm.
  ENDIF.
  IF ls_bp_data-kvgr1 NE space.
    ls_sales-data-kvgr1 = ls_bp_data-kvgr1 .
  ENDIF.

  IF ls_bp_data-kkber NE space.
    ls_sales-data-kkber = ls_bp_data-kkber.
  ENDIF.

  IF ls_bp_data-zzfte NE space.
    ls_sales-data-zzfte = ls_bp_data-zzfte.
  ENDIF.

*Partner functions

  IF ls_bp_data-partner_fn1 NE space AND  ls_bp_data-part_no1   NE space.

    CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
      EXPORTING
        input  = ls_bp_data-partner_fn1
      IMPORTING
        output = ls_bp_data-partner_fn1.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_bp_data-part_no1
      IMPORTING
        output = ls_bp_data-part_no1.


    ls_functions-task = 'M'.
    ls_functions-data_key-parvw =  ls_bp_data-partner_fn1.
    ls_functions-data-partner = ls_bp_data-part_no1 .
    ls_functions-datax-partner = 'X'.
    APPEND ls_functions TO lt_functions.
    CLEAR ls_functions.
  ENDIF.

  IF ls_bp_data-partner_fn2 NE space AND  ls_bp_data-part_no2   NE space.
    CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
      EXPORTING
        input  = ls_bp_data-partner_fn2
      IMPORTING
        output = ls_bp_data-partner_fn2.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_bp_data-part_no2
      IMPORTING
        output = ls_bp_data-part_no2.



    ls_functions-task = 'M'.
    ls_functions-data_key-parvw =  ls_bp_data-partner_fn2.
    ls_functions-data-partner = ls_bp_data-part_no2 .
    ls_functions-datax-partner = 'X'.
    APPEND ls_functions TO lt_functions.
    CLEAR ls_functions.
  ENDIF.

  IF ls_bp_data-partner_fn3 NE space AND  ls_bp_data-part_no3   NE space.

    CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
      EXPORTING
        input  = ls_bp_data-partner_fn3
      IMPORTING
        output = ls_bp_data-partner_fn3.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_bp_data-part_no3
      IMPORTING
        output = ls_bp_data-part_no3.

    ls_functions-task = 'M'.
    ls_functions-data_key-parvw =  ls_bp_data-partner_fn3.
    ls_functions-data-partner = ls_bp_data-part_no3.
    ls_functions-datax-partner = 'X'.
    APPEND ls_functions TO lt_functions.
    CLEAR ls_functions.
  ENDIF.
  IF ls_bp_data-partner_fn4 NE space AND  ls_bp_data-part_no4   NE space.

    CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
      EXPORTING
        input  = ls_bp_data-partner_fn4
      IMPORTING
        output = ls_bp_data-partner_fn4.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_bp_data-part_no4
      IMPORTING
        output = ls_bp_data-part_no4.

    ls_functions-task = 'M'.
    ls_functions-data_key-parvw =  ls_bp_data-partner_fn4.
    ls_functions-data-partner = ls_bp_data-part_no4.
    ls_functions-datax-partner = 'X'.
    APPEND ls_functions TO lt_functions.
    CLEAR ls_functions.
  ENDIF.
  IF ls_bp_data-partner_fn5 NE space AND  ls_bp_data-part_no5   NE space.

    CALL FUNCTION 'CONVERSION_EXIT_PARVW_INPUT'
      EXPORTING
        input  = ls_bp_data-partner_fn5
      IMPORTING
        output = ls_bp_data-partner_fn5.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_bp_data-part_no5
      IMPORTING
        output = ls_bp_data-part_no5.

    ls_functions-task = 'M'.
    ls_functions-data_key-parvw =  ls_bp_data-partner_fn5.
    ls_functions-data-partner = ls_bp_data-part_no5.
    ls_functions-datax-partner = 'X'.
    APPEND ls_functions TO lt_functions.
    CLEAR ls_functions.
  ENDIF.
  ls_sales-functions-functions = lt_functions.
  APPEND ls_sales TO lt_sales.
  CLEAR ls_sales.

*Credit segment
  IF ls_bp_data-credit_sgmnt NE space.
    ls_credit_seg-credit_sgmnt = ls_bp_data-credit_sgmnt.

    IF ls_bp_data-credit_limit NE space.
      ls_credit_seg-credit_limit = ls_bp_data-credit_limit.
    ENDIF.
    APPEND ls_credit_seg TO lt_credit_seg.
    CLEAR ls_credit_seg.
  ENDIF.


*Collection seg
  IF ls_bp_data-coll_segment  NE space.
    ls_coll_seg-coll_segment = ls_bp_data-coll_segment .
    IF ls_bp_data-coll_group NE space.
      ls_coll_seg-coll_group = ls_bp_data-coll_group .
    ENDIF.
    IF ls_bp_data-coll_specialist  NE space.
      ls_coll_seg-coll_specialist = ls_bp_data-coll_specialist.
    ENDIF.
    APPEND ls_coll_seg TO lt_coll_seg.
    CLEAR ls_coll_seg.

  ENDIF.

  IF NOT lt_compcode[] IS INITIAL.
    i_data-comp_code_data-comp_codes = lt_compcode.
  ENDIF.

  IF NOT   lt_sales[] IS INITIAL.
    i_data-sales_data-sales_datas    = lt_sales.
  ENDIF.

  IF ls_bp_data-risk_class NE space.
    i_data-crdt_coll_data-credit_data-credit_profile-risk_class = ls_bp_data-risk_class.
  ENDIF.
  IF ls_bp_data-check_rule NE space.
    i_data-crdt_coll_data-credit_data-credit_profile-check_rule = ls_bp_data-check_rule.
  ENDIF.
  IF ls_bp_data-credit_group NE space.
    i_data-crdt_coll_data-credit_data-credit_profile-credit_group = ls_bp_data-credit_group.
  ENDIF.
  IF ls_bp_data-taxkd IS NOT INITIAL.
    ls_tax-task = 'M'.
    ls_tax-data_key-aland = ls_bp_data-country.
    ls_tax-data-taxkd =  ls_bp_data-taxkd.
    ls_tax-datax-taxkd =  'X'.
    APPEND ls_tax TO lt_tax.
    i_data-general_data-add_gen_data-tax_ind-tax_ind = lt_tax.
  ENDIF.

  IF NOT lt_credit_seg[] IS INITIAL.
    i_data-crdt_coll_data-credit_data-credit_segment = lt_credit_seg.
  ENDIF.

  IF ls_bp_data-coll_profile NE space.
    i_data-crdt_coll_data-collection_data-coll_profile-coll_profile = ls_bp_data-coll_profile.
  ENDIF.
  IF NOT lt_coll_seg[] IS INITIAL.
    i_data-crdt_coll_data-collection_data-coll_segment = lt_coll_seg.
  ENDIF.

  APPEND i_data TO i_data_table.
  CLEAR i_data.


  CALL FUNCTION 'ZQTC_CUSTOMER_IB_INTERFACE_LH'
    EXPORTING
      im_data   = i_data_table
    IMPORTING
      ex_return = i_output.

  COMMIT WORK AND WAIT.

  IF sy-batch EQ space.
    LOOP AT i_output INTO ls_output .

      LOOP AT ls_output-messages INTO ls_message.
        IF ls_message-type = 'S'.
          CONCATENATE ls_bp_data-status ls_message-message INTO ls_bp_data-status.
          SHIFT ls_bp_data-status  LEFT DELETING LEADING space.
        ELSEIF ls_message-type = 'E'.
          CONCATENATE ls_bp_data-status   ls_message-message INTO ls_bp_data-status SEPARATED BY space.
          SHIFT ls_bp_data-status  LEFT DELETING LEADING space.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDIF.

  IF sy-batch <> space.
    LOOP AT i_output INTO ls_output.

      LOOP AT ls_output-messages INTO ls_message.
        IF lv_msg_type IS INITIAL.
          lv_msg_type = ls_message-type.
          CASE lv_msg_type.
            WHEN 'S'.
              gv_success = gv_success + 1.
            WHEN OTHERS.
              gv_errors = gv_errors + 1.
          ENDCASE.
        ENDIF.
        CONCATENATE  lv_msg_string ls_message-message INTO lv_msg_string SEPARATED BY '|'.
        SHIFT lv_msg_string  LEFT DELETING LEADING space.
      ENDLOOP.
    ENDLOOP.

    CONCATENATE lv_msg_type '|' ls_bp_data-identificationcategory '|' ls_bp_data-identificationnumber '|' lv_msg_string
                INTO lv_msg_string SEPARATED BY space.

    ls_msg-message = lv_msg_string.
    APPEND ls_msg TO gt_message.
    CLEAR ls_msg.

  ENDIF.

ENDFORM.

FORM handle_user_command USING i_ucomm TYPE salv_de_function.


  DATA: lt_rows   TYPE salv_t_row,
        lt_column TYPE salv_t_column,
        ls_cell   TYPE salv_s_cell.
  DATA: ls_row TYPE int4.
  DATA: lr_columns TYPE REF TO cl_salv_columns.


  FIELD-SYMBOLS: <fs_bp_data>  TYPE ty_bp_details.


  CALL METHOD gr_selections->get_selected_rows
    RECEIVING
      value = lt_rows.

  LOOP AT lt_rows INTO ls_row.

    READ TABLE gt_bp_data ASSIGNING <fs_bp_data> INDEX ls_row.
    IF <fs_bp_data>  IS  ASSIGNED.
      PERFORM create_bp USING <fs_bp_data>.
    ENDIF.
  ENDLOOP.

  lr_columns = gr_table->get_columns( ).
  lr_columns->set_optimize( c_true ).

  gr_table->refresh( ).



ENDFORM.                    " handle_user_command

FORM display_data.

  DATA: lr_events TYPE REF TO cl_salv_events_table.

  DATA: lr_columns TYPE REF TO cl_salv_columns,
        lr_column  TYPE REF TO cl_salv_column_table.

  TRY.
      CALL METHOD cl_salv_table=>factory
*  EXPORTING
*    list_display   = IF_SALV_C_BOOL_SAP=>FALSE
*    r_container    =
*    container_name =
        IMPORTING
          r_salv_table = gr_table
        CHANGING
          t_table      = gt_bp_data.
    CATCH cx_salv_msg .
  ENDTRY.


  gr_table->set_screen_status(
      pfstatus      =  'ZSALV_STANDARD'
      report        =  sy-repid
      set_functions = gr_table->c_functions_all ).

  lr_columns = gr_table->get_columns( ).
  lr_columns->set_optimize( c_true ).

  gr_selections = gr_table->get_selections( ).

  gr_selections->set_selection_mode( gr_selections->multiple ).



  TRY.
      lr_column ?= lr_columns->get_column( 'SOURCE_FIELD' ).
      lr_column->set_short_text( 'Business'(001) ).
      lr_column->set_medium_text( 'Business'(002) ).
      lr_column->set_long_text( 'Business Type'(003) ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'PARTNER' ).
      lr_column->set_short_text( 'BP Number'(010) ).
      lr_column->set_medium_text( 'BP Number'(011) ).
      lr_column->set_long_text( 'Business Partner Number'(012) ).
    CATCH cx_salv_not_found.
  ENDTRY.


  TRY.
      lr_column ?= lr_columns->get_column( 'CATEGORY' ).
      lr_column->set_short_text( 'BP Cat'(013) ).
      lr_column->set_medium_text( 'BP category'(014) ).
      lr_column->set_long_text( 'Business partner category'(015) ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'GROUPING' ).
      lr_column->set_short_text( 'BP Group'(016) ).
      lr_column->set_medium_text( 'BP Group'(017) ).
      lr_column->set_long_text( 'Business Partner Grouping'(018) ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'EXT_ID' ).
      lr_column->set_short_text( 'Ext Id'(025) ).
      lr_column->set_medium_text( 'Ext Id'(035) ).
      lr_column->set_long_text( 'External Id'(045) ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'MOB_NUMBER' ).
      lr_column->set_short_text( 'Mobile'(055) ).
      lr_column->set_medium_text( 'Mobile'(056) ).
      lr_column->set_long_text( 'Mobile Phone'(057) ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'CREDIT_SGMNT' ).
      lr_column->set_short_text( 'Crdt Seg'(511) ).
      lr_column->set_medium_text( 'Crdt Seg'(512) ).
      lr_column->set_long_text( 'Credit Segment'(513) ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'CREDIT_LIMIT' ).
      lr_column->set_short_text( 'Crdt limit'(514) ).
      lr_column->set_medium_text( 'Crdt limit'(515) ).
      lr_column->set_long_text( 'Credit limit'(516) ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'RISK_CLASS' ).
      lr_column->set_short_text( 'Risk Class'(517) ).
      lr_column->set_medium_text( 'Risk Class'(518) ).
      lr_column->set_long_text( 'Risk Class'(519) ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'CHECK_RULE' ).
      lr_column->set_short_text( 'Check rule'(520) ).
      lr_column->set_medium_text( 'Check rule'(521) ).
      lr_column->set_long_text( 'Check rule'(522) ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'CREDIT_GROUP' ).
      lr_column->set_short_text( 'Credit Grp'(523) ).
      lr_column->set_medium_text( 'Credit Grp'(524) ).
      lr_column->set_long_text( 'Credit Grp'(525) ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'COLL_SEGMENT' ).
      lr_column->set_short_text( 'Coll Seg'(526) ).
      lr_column->set_medium_text( 'Coll Seg'(527) ).
      lr_column->set_long_text( 'Collection Segment'(528) ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'COLL_GROUP' ).
      lr_column->set_short_text( 'Coll Grp'(529) ).
      lr_column->set_medium_text( 'Coll Grp'(530) ).
      lr_column->set_long_text( 'Collection Group'(531) ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'COLL_SPECIALIST' ).
      lr_column->set_short_text( 'Coll Spec'(532) ).
      lr_column->set_medium_text( 'Coll Spec'(533) ).
      lr_column->set_long_text( 'Collection specialist'(534) ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'COLL_PROFILE' ).
      lr_column->set_short_text( 'Coll Prof'(535) ).
      lr_column->set_medium_text( 'Coll Prof'(536) ).
      lr_column->set_long_text( 'Collection Profile'(537) ).
    CATCH cx_salv_not_found.
  ENDTRY.

  TRY.
      lr_column ?= lr_columns->get_column( 'TAXKD' ).
      lr_column->set_short_text( 'Tax Cl'(545) ).
      lr_column->set_medium_text( 'Tax Class'(546) ).
      lr_column->set_long_text( 'Tax Classification'(547) ).
    CATCH cx_salv_not_found.
  ENDTRY.


  TRY.
      lr_column ?= lr_columns->get_column( 'STATUS' ).
      lr_column->set_short_text( 'Status'(538) ).
      lr_column->set_medium_text( 'Status'(539) ).
      lr_column->set_long_text( 'Status'(540) ).
    CATCH cx_salv_not_found.
  ENDTRY.

*  TRY.
*      lr_column ?= lr_columns->get_column( 'STATUS' ).
*      lr_column->set_technical( if_salv_c_bool_sap=>true ).
*    CATCH cx_salv_not_found.                            "#EC NO_HANDLER
*  ENDTRY.
*

  lr_events = gr_table->get_event( ).
  CREATE OBJECT gr_events.
  SET HANDLER gr_events->on_user_command FOR lr_events.

  gr_table->display( ).

ENDFORM.

FORM bp_create.
  DESCRIBE TABLE gt_bp_data LINES DATA(lv_no_of_lines).
  MESSAGE i000(tb) WITH 'No of BPs: ' lv_no_of_lines ' Processed'.
  LOOP AT gt_bp_data INTO DATA(ls_bp_data).
    PERFORM create_bp USING ls_bp_data.
  ENDLOOP.
ENDFORM.


FORM submit_program_in_background USING p_file TYPE char80.
  DATA: lv_jobname TYPE btcjob,
        lv_number  TYPE tbtcjob-jobcount,      "Job number
        li_params  TYPE TABLE OF rsparamsl_255, "Selection table parameter
        lst_params TYPE rsparamsl_255.         "Selection table parameter

  CONSTANTS: c_parameter_p TYPE rsscr_kind VALUE 'P', "ABAP:Type of selection
             c_sign_i      TYPE tvarv_sign VALUE 'I', "ABAP: ID: I/E (include/exclude values)
             c_option_eq   TYPE tvarv_opti VALUE 'EQ'. "ABAP: Selection option (EQ/BT/CP/...).
  DATA: ls_bp_data TYPE ty_bp_details.
  DATA: lv_file TYPE string.
  DATA tsl TYPE timestampl.
  DATA ts TYPE char21.
  GET TIME STAMP FIELD tsl.
  ts =  tsl.
  SHIFT ts LEFT DELETING LEADING '*'.

  CONCATENATE p_file 'BP_lOAD' ts INTO lv_file.
  CONDENSE  lv_file NO-GAPS.
  CLOSE DATASET lv_file.
  OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    LOOP AT gt_bp_data INTO ls_bp_data.
      TRANSFER ls_bp_data TO lv_file.
    ENDLOOP.
  ENDIF.
  CLOSE DATASET lv_file.


  lst_params-selname = 'P_FILE'.       "Seletion screen field name of the corresponding program.
  lst_params-kind    = c_parameter_p.  "P-Parameter,S-Select-options
  lst_params-sign    = c_sign_i.       "I-in
  lst_params-option  = c_option_eq.    "EQ,BT,CP
  lst_params-low     = lv_file.  "Selection Option Low,Parameter value
  APPEND lst_params TO li_params.
  CLEAR lst_params.

  CONCATENATE 'ZCREATE_BP' sy-datum sy-uzeit INTO lv_jobname.
  CONDENSE lv_jobname NO-GAPS.
  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_jobname
    IMPORTING
      jobcount         = lv_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc = 0.

    SUBMIT zrtr_bp_init_load_extend WITH SELECTION-TABLE li_params
                    VIA JOB lv_jobname NUMBER lv_number "Job number
                    AND RETURN.
    IF sy-subrc = 0.
*       Closing the Job
      CALL FUNCTION 'JOB_CLOSE'
        EXPORTING
          jobcount             = lv_number   "Job number
          jobname              = lv_jobname  "Job name
          strtimmed            = abap_true   "Start immediately
        EXCEPTIONS
          cant_start_immediate = 1
          invalid_startdate    = 2
          jobname_missing      = 3
          job_close_failed     = 4
          job_nosteps          = 5
          job_notex            = 6
          lock_failed          = 7
          OTHERS               = 8.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    ENDIF.
  ENDIF.
  MESSAGE s000(tb) WITH 'Job Submitted' lv_number  lv_jobname.
  LEAVE LIST-PROCESSING.
ENDFORM.

FORM log_message.

  DATA: lv_file TYPE string.
  DATA tsl TYPE timestampl.
  DATA ts TYPE char21.


  MESSAGE i000(tb) WITH 'No Success: ' gv_success.
  MESSAGE i000(tb) WITH 'No Errors: ' gv_errors.

  SELECT *
         FROM zcainteg_mapping
         INTO TABLE gt_const
         WHERE devid = c_devid
        AND activate = c_x.

  IF sy-subrc EQ 0.
    SORT gt_const BY param1.
  ENDIF.

  GET TIME STAMP FIELD tsl.
  ts =  tsl.
  SHIFT ts LEFT DELETING LEADING '*'.
  READ TABLE  gt_const INTO DATA(ls_const) WITH KEY param1 = c_param2.
  CONCATENATE ls_const-sap_value 'BP_ERR_LOG' ts INTO lv_file.
  CONDENSE  lv_file NO-GAPS.
  CLOSE DATASET lv_file.
  OPEN DATASET lv_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    LOOP AT gt_message INTO DATA(ls_msg).
      TRANSFER ls_msg-message TO lv_file.
    ENDLOOP.
  ENDIF.
  CLOSE DATASET lv_file.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_validate_file  USING   fp_file TYPE localfile. " Local file for upload/download

** Local Variables
  DATA : lv_file_char  TYPE localfile,  " Local file for upload/download
         lv_ferr_flg   TYPE xfld,
         lv_check_file TYPE c.

  IF fp_file IS NOT INITIAL. "AND p_a_file IS INITIAL.
* Reverse the string
    CALL FUNCTION 'STRING_REVERSE'
      EXPORTING
        string    = fp_file
        lang      = sy-langu
      IMPORTING
        rstring   = lv_file_char
      EXCEPTIONS
        too_small = 1
        OTHERS    = 2.
    IF sy-subrc IS INITIAL.
      IF lv_file_char+0(3) NE 'slx'  AND
         lv_file_char+0(3) NE 'SLX'  AND
         lv_file_char+0(4) NE 'xslx' AND
         lv_file_char+0(4) NE 'XSLX'.
        MESSAGE text-e01 TYPE c_e.
      ENDIF. " IF lv_file_char+0(3) NE 'slx' AND
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF fp_file IS NOT INITIAL AND p_a_file IS INITIAL.

ENDFORM.
