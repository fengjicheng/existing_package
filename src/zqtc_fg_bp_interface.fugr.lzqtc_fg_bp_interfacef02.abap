*----------------------------------------------------------------------*
***INCLUDE LZQTC_FG_BP_INTERFACE_AGUF02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants .
*  Local constant declaration
  CONSTANTS: lc_devid         TYPE zdevid VALUE 'I0368',     " Development ID
             lc_comm_method   TYPE rvari_vnam VALUE 'COMM_METHOD',
             lc_bu_group      TYPE rvari_vnam VALUE 'BU_GROUP',
             lc_bu_cat        TYPE rvari_vnam VALUE 'BU_CAT',
             lc_bp_role       TYPE rvari_vnam VALUE 'BP_ROLE',
             lc_tax_num       TYPE rvari_vnam VALUE 'TAX_NUM',
             lc_tax_id_type   TYPE rvari_vnam VALUE 'TAX_ID_TYPE',
             lc_bu_id_type    TYPE rvari_vnam VALUE 'BU_ID_TYPE',
             lc_cust_attr6    TYPE rvari_vnam VALUE 'CUST_ATTR6',
             lc_recon_account TYPE rvari_vnam VALUE 'RECON_ACCOUNT',
             lc_payment_terms TYPE rvari_vnam VALUE 'PAYMENT_TERMS',
             lc_cust_pay_hist TYPE rvari_vnam VALUE 'CUST_PAY_HIST',
             lc_dunning_proc  TYPE rvari_vnam VALUE 'DUNNING_PROC',
             lc_bank_statment TYPE rvari_vnam VALUE 'BANK_STATEMENT',
             lc_valid_end     TYPE rvari_vnam VALUE 'VALID_END',
             lc_vtweg         TYPE rvari_vnam VALUE 'VTWEG',
             lc_spart         TYPE rvari_vnam VALUE 'SPART',
             lc_cust_grp      TYPE rvari_vnam VALUE 'CUST_GRP',
             lc_prcing_proc   TYPE rvari_vnam VALUE 'PRICING_PROC',
             lc_cust_stat_grp TYPE rvari_vnam VALUE 'CUST_STAT_GRP',
             lc_del_priority  TYPE rvari_vnam VALUE 'DEL_PRIORITY',
             lc_shipping_cond TYPE rvari_vnam VALUE 'SHIPPING_COND',
             lc_inco1         TYPE rvari_vnam VALUE 'INCO1',
             lc_inco2         TYPE rvari_vnam VALUE 'INCO2',
             lc_account_ass   TYPE rvari_vnam VALUE 'ACCOUNT_ASS_GRP',
             lc_tax_classi    TYPE rvari_vnam VALUE 'TAX_CLASSI',
             lc_parvw         TYPE rvari_vnam VALUE 'PARVW',
             lc_spras         TYPE rvari_vnam VALUE 'SPRAS',
             lc_cust_grp1     TYPE rvari_vnam VALUE 'CUST_GRP1',
             lc_coll_profile  TYPE rvari_vnam VALUE 'COLL_PROFILE',
             lc_credit_grp    TYPE  rvari_vnam VALUE  'CREDIT_GROUP',
             lc_agu           TYPE rvari_vnam VALUE 'AGU',
             lc_ktokd         TYPE rvari_vnam VALUE 'CUST_ACCT_GRP',
             lc_tatyp         TYPE rvari_vnam VALUE 'TAX_CAT',
             lc_agu_cust      TYPE rvari_vnam VALUE 'AGU_CUST',
             lc_coll_seg      TYPE rvari_vnam VALUE 'COLL_SEGMENT',
             lc_fte           TYPE rvari_vnam VALUE 'FTE',
             lc_sort_key      TYPE rvari_vnam VALUE 'SORT_KEY',
             lc_ctry_postal   TYPE rvari_vnam VALUE 'COUNTRY_POSTAL_CODE_SKIP'.
  DATA:      lst_zcaconstant TYPE ty_constant.
*--*Fetch data from ZCACONSTANT
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
          INTO TABLE @li_constant  WHERE devid = @lc_devid
                                    AND  activate = @abap_true.
  IF sy-subrc EQ 0.
    SORT li_constant BY param1.
    "Get data from zcaconstant table
    LOOP AT li_constant INTO lst_zcaconstant.
      IF lst_zcaconstant-param2 = lc_agu.
        CASE lst_zcaconstant-param1.
*--*Communication type
          WHEN lc_comm_method.
            lsr_comm_type-sign = lst_zcaconstant-sign.
            lsr_comm_type-option = lst_zcaconstant-opti.
            lsr_comm_type-low = lst_zcaconstant-low.
            lsr_comm_type-high = lst_zcaconstant-high.
*--*BU Group / Type
          WHEN lc_bu_group.
            lsr_bu_group-sign = lst_zcaconstant-sign.
            lsr_bu_group-option = lst_zcaconstant-opti.
            lsr_bu_group-low = lst_zcaconstant-low.
            lsr_bu_group-high = lst_zcaconstant-high.
*--*BU Category
          WHEN lc_bu_cat.
            lsr_bu_type-sign = lst_zcaconstant-sign.
            lsr_bu_type-option = lst_zcaconstant-opti.
            lsr_bu_type-low = lst_zcaconstant-low.
            lsr_bu_type-high = lst_zcaconstant-high.
*--*BP role
          WHEN lc_bp_role.
            lsr_rel_type-sign = lst_zcaconstant-sign.
            lsr_rel_type-option = lst_zcaconstant-opti.
            lsr_rel_type-low = lst_zcaconstant-low.
            lsr_rel_type-high = lst_zcaconstant-high.
            APPEND lsr_rel_type TO lir_rel_type.
            CLEAR lsr_rel_type.
*--*Tax number
          WHEN lc_tax_num.
            lsr_bptaxnum-sign = lst_zcaconstant-sign.
            lsr_bptaxnum-option = lst_zcaconstant-opti.
            lsr_bptaxnum-low = lst_zcaconstant-low.
            lsr_bptaxnum-high = lst_zcaconstant-high.
*--*Tax Id type
          WHEN lc_tax_id_type.
            lsr_taxtype-sign = lst_zcaconstant-sign.
            lsr_taxtype-option = lst_zcaconstant-opti.
            lsr_taxtype-low = lst_zcaconstant-low.
            lsr_taxtype-high = lst_zcaconstant-high.
*--*Customer Attribute 6
          WHEN lc_cust_attr6.
            lsr_katr6-sign = lst_zcaconstant-sign.
            lsr_katr6-option = lst_zcaconstant-opti.
            lsr_katr6-low = lst_zcaconstant-low.
            lsr_katr6-high = lst_zcaconstant-high.
*--*Reconcellation Account
          WHEN lc_recon_account.
            lsr_akont-sign = lst_zcaconstant-sign.
            lsr_akont-option = lst_zcaconstant-opti.
            lsr_akont-low = lst_zcaconstant-low.
            lsr_akont-high = lst_zcaconstant-high.
*--*Payment terms
          WHEN lc_payment_terms.
            lsr_zterm-sign = lst_zcaconstant-sign.
            lsr_zterm-option = lst_zcaconstant-opti.
            lsr_zterm-low = lst_zcaconstant-low.
            lsr_zterm-high = lst_zcaconstant-high.
*--*Payment history
          WHEN lc_cust_pay_hist.
            lsr_xzver-sign = lst_zcaconstant-sign.
            lsr_xzver-option = lst_zcaconstant-opti.
            lsr_xzver-low = lst_zcaconstant-low.
            lsr_xzver-high = lst_zcaconstant-high.
*--*Dunning Procedure
          WHEN lc_dunning_proc.
            lsr_mahna-sign = lst_zcaconstant-sign.
            lsr_mahna-option = lst_zcaconstant-opti.
            lsr_mahna-low = lst_zcaconstant-low.
            lsr_mahna-high = lst_zcaconstant-high.
*--*Bank statment
          WHEN lc_bank_statment.
            lsr_xausz-sign = lst_zcaconstant-sign.
            lsr_xausz-option = lst_zcaconstant-opti.
            lsr_xausz-low = lst_zcaconstant-low.
            lsr_xausz-high = lst_zcaconstant-high.
*--*Valididty End date
          WHEN lc_valid_end .
            lsr_end_date-sign = lst_zcaconstant-sign.
            lsr_end_date-opt = lst_zcaconstant-opti.
            lsr_end_date-low = lst_zcaconstant-low.
            lsr_end_date-high = lst_zcaconstant-high.
*--*Distribution channel
          WHEN lc_vtweg.
            lsr_vtweg-sign = lst_zcaconstant-sign.
            lsr_vtweg-option = lst_zcaconstant-opti.
            lsr_vtweg-low = lst_zcaconstant-low.
            lsr_vtweg-high = lst_zcaconstant-high.
*--*Division
          WHEN lc_spart.
            lsr_spart-sign = lst_zcaconstant-sign.
            lsr_spart-option = lst_zcaconstant-opti.
            lsr_spart-low = lst_zcaconstant-low.
            lsr_spart-high = lst_zcaconstant-high.
*--*Customer Group
          WHEN lc_cust_grp.
            lsr_kdgrp-sign = lst_zcaconstant-sign.
            lsr_kdgrp-option = lst_zcaconstant-opti.
            lsr_kdgrp-low = lst_zcaconstant-low.
            lsr_kdgrp-high = lst_zcaconstant-high.
*--*Pricing procedure
          WHEN lc_prcing_proc.
            lsr_kalks-sign = lst_zcaconstant-sign.
            lsr_kalks-option = lst_zcaconstant-opti.
            lsr_kalks-low = lst_zcaconstant-low.
            lsr_kalks-high = lst_zcaconstant-high.
*--*Customer statistics group
          WHEN lc_cust_stat_grp.
            lsr_vrseg-sign = lst_zcaconstant-sign.
            lsr_vrseg-option = lst_zcaconstant-opti.
            lsr_vrseg-low = lst_zcaconstant-low.
            lsr_vrseg-high = lst_zcaconstant-high.
*--*Delivery priority
          WHEN lc_del_priority.
            lsr_lprio-sign = lst_zcaconstant-sign.
            lsr_lprio-option = lst_zcaconstant-opti.
            lsr_lprio-low = lst_zcaconstant-low.
            lsr_lprio-high = lst_zcaconstant-high.
*--*Shipping conditions
          WHEN lc_shipping_cond.
            lsr_vsbed-sign = lst_zcaconstant-sign.
            lsr_vsbed-option = lst_zcaconstant-opti.
            lsr_vsbed-low = lst_zcaconstant-low.
            lsr_vsbed-high = lst_zcaconstant-high.
*--*Inco terms 1
          WHEN lc_inco1.
            lsr_inco1-sign = lst_zcaconstant-sign.
            lsr_inco1-option = lst_zcaconstant-opti.
            lsr_inco1-low = lst_zcaconstant-low.
            lsr_inco1-high = lst_zcaconstant-high.
*--* Inco terms 2
          WHEN lc_inco2 .
            lsr_inco2-sign = lst_zcaconstant-sign.
            lsr_inco2-option = lst_zcaconstant-opti.
            lsr_inco2-low = lst_zcaconstant-low.
            lsr_inco2-high = lst_zcaconstant-high.
*--*Account assignment group
          WHEN lc_account_ass.
            lsr_ktgrd-sign = lst_zcaconstant-sign.
            lsr_ktgrd-option = lst_zcaconstant-opti.
            lsr_ktgrd-low = lst_zcaconstant-low.
            lsr_ktgrd-high = lst_zcaconstant-high.
*--*Tax classification
          WHEN lc_tax_classi.
            lsr_taxkd-sign = lst_zcaconstant-sign.
            lsr_taxkd-option = lst_zcaconstant-opti.
            lsr_taxkd-low = lst_zcaconstant-low.
            lsr_taxkd-high = lst_zcaconstant-high.
*--*Partner functions
          WHEN lc_parvw.
            lsr_parvw-sign = lst_zcaconstant-sign.
            lsr_parvw-option = lst_zcaconstant-opti.
            lsr_parvw-low = lst_zcaconstant-low.
            lsr_parvw-high = lst_zcaconstant-high.
            APPEND lsr_parvw TO lir_parvw.
            CLEAR : lsr_parvw.
*--*Customer group1
          WHEN lc_cust_grp1.
            lsr_kvgr1-sign = lst_zcaconstant-sign.
            lsr_kvgr1-option = lst_zcaconstant-opti.
            lsr_kvgr1-low = lst_zcaconstant-low.
            lsr_kvgr1-high = lst_zcaconstant-high.
*--*Language
          WHEN lc_spras.
            lsr_spras-sign = lst_zcaconstant-sign.
            lsr_spras-option = lst_zcaconstant-opti.
            lsr_spras-low = lst_zcaconstant-low.
            lsr_spras-high = lst_zcaconstant-high.
*--*Collection profile
          WHEN lc_coll_profile.
            lsr_coll_profile-sign = lst_zcaconstant-sign.
            lsr_coll_profile-option = lst_zcaconstant-opti.
            lsr_coll_profile-low = lst_zcaconstant-low.
            lsr_coll_profile-high = lst_zcaconstant-high.
*--*Customer Credit group
          WHEN lc_credit_grp.
            lsr_credit_group-sign = lst_zcaconstant-sign.
            lsr_credit_group-option = lst_zcaconstant-opti.
            lsr_credit_group-low = lst_zcaconstant-low.
            lsr_credit_group-high = lst_zcaconstant-high.
*--*Customer Account group
          WHEN lc_ktokd.
            lsr_ktokd-sign = lst_zcaconstant-sign.
            lsr_ktokd-option = lst_zcaconstant-opti.
            lsr_ktokd-low = lst_zcaconstant-low.
            lsr_ktokd-high = lst_zcaconstant-high.
*--*Tax condition type
          WHEN lc_tatyp.
            lsr_tatyp-sign = lst_zcaconstant-sign.
            lsr_tatyp-option = lst_zcaconstant-opti.
            lsr_tatyp-low = lst_zcaconstant-low.
            lsr_tatyp-high = lst_zcaconstant-high.
*--* AGU customer
          WHEN lc_agu_cust.
            lsr_agu-sign = lst_zcaconstant-sign.
            lsr_agu-option = lst_zcaconstant-opti.
            lsr_agu-low = lst_zcaconstant-low.
            lsr_agu-high = lst_zcaconstant-high.
*--*Collection
          WHEN lc_coll_seg.
            lsr_coll_seg-sign = lst_zcaconstant-sign.
            lsr_coll_seg-option = lst_zcaconstant-opti.
            lsr_coll_seg-low = lst_zcaconstant-low.
            lsr_coll_seg-high = lst_zcaconstant-high.
            APPEND lsr_coll_seg TO lir_coll_seg.
            CLEAR lsr_coll_seg.
*--*Sort Key
          WHEN lc_sort_key.
            lsr_sort_key-sign = lst_zcaconstant-sign.
            lsr_sort_key-option = lst_zcaconstant-opti.
            lsr_sort_key-low = lst_zcaconstant-low.
            lsr_sort_key-high = lst_zcaconstant-high.
*--*No of  FTE
          WHEN lc_fte.
            lsr_fte-sign = lst_zcaconstant-sign.
            lsr_fte-option = lst_zcaconstant-opti.
            lsr_fte-low = lst_zcaconstant-low.
            lsr_fte-high = lst_zcaconstant-high.
            APPEND lsr_fte TO lir_fte.
            CLEAR lsr_fte.
*--*BOC ERPM-10797 ED2K917990 Prabhu 4/15/2020
          WHEN lc_ctry_postal.
            lsr_ctry_postal-sign = lst_zcaconstant-sign.
            lsr_ctry_postal-option = lst_zcaconstant-opti.
            lsr_ctry_postal-low = lst_zcaconstant-low.
            lsr_ctry_postal-high = lst_zcaconstant-high.
            APPEND lsr_ctry_postal TO lir_ctry_postal.
            CLEAR lsr_ctry_postal.
*--*EOC ERPM-10797 ED2K917990 Prabhu 4/15/2020
          WHEN OTHERS.
        ENDCASE.
      ENDIF.
    ENDLOOP.
  ENDIF.
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
  DATA : li_addresses   TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-address-addresses,
         lst_addresses  LIKE LINE OF li_addresses,
         li_phone       TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-communication-phone-phone,
         lst_phone      LIKE LINE OF li_phone,
         li_smtp        TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-communication-smtp-smtp,
         lst_smtp       LIKE LINE OF li_smtp,
         li_tax         TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-taxnumber-taxnumbers,
         lst_tax        LIKE LINE OF li_tax,
         li_relation    TYPE zstqtc_customer_date_input-relationship_data-relationships,
         lst_relation   LIKE LINE OF li_relation,
         li_role        TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-role-roles,
         lst_role       LIKE LINE OF li_role,
         li_comp_codes  TYPE zstqtc_customer_date_input-comp_code_data-comp_codes,
         lst_comp_codes LIKE LINE OF li_comp_codes,
         li_dunning     TYPE cmds_ei_dunning_t,
         lst_dunning    LIKE LINE OF li_dunning,
         li_sales       TYPE zstqtc_customer_date_input-sales_data-sales_datas,
         lst_sales      LIKE LINE OF li_sales,
         li_functions   TYPE cmds_ei_functions_t,
         lst_functions  LIKE LINE OF li_functions,
         li_sales_tax   TYPE zstqtc_customer_date_input-general_data-add_gen_data-tax_ind-tax_ind,
         lst_sales_tax  LIKE LINE OF li_sales_tax,
         li_coll        TYPE zstqtc_customer_date_input-crdt_coll_data-collection_data-coll_segment,
         lst_coll       LIKE LINE OF li_coll,
         li_credit      TYPE zstqtc_customer_date_input-crdt_coll_data-credit_data-credit_segment,
         lst_credit     LIKE LINE OF li_credit,
         li_time        TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-common-time_dependent_data-common_data,
         lst_time       LIKE LINE OF li_time,
         li_id          TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-ident_number-ident_numbers,
         lst_id         LIKE LINE OF li_id,
         lv_date        TYPE sy-datum,
         lst_tsad3t     LIKE LINE OF i_tsad3t,
         lst_def_credit LIKE LINE OF i_def_credit,
         lst_risk_check LIKE LINE OF i_risk_check,
         lst_coll_prof  LIKE LINE OF i_coll,
         lst_coll_1001  LIKE LINE OF i_coll.

  CLEAR : li_addresses,lst_addresses,li_phone,lst_phone,li_smtp,lst_smtp,li_tax,lst_tax,
          lst_relation,li_relation,li_role,lst_role,li_comp_codes,lst_comp_codes,
          li_dunning,lst_dunning,li_sales,lst_sales,li_functions,lst_functions,li_sales_tax,
          lst_sales_tax,li_coll,lst_coll,li_credit,lst_credit,li_time,lst_time,li_id,
          lst_id,lv_date,lst_tsad3t,lst_def_credit,lst_risk_check,lst_coll_1001,lst_coll_prof.
*"----------------------------------------------------------------------
*---Read Custom tables data.
*"----------------------------------------------------------------------
  READ TABLE i_t005 INTO DATA(lst_t005) WITH KEY intca3 = st_input-country
                                                       BINARY SEARCH.
*--*Credit management
  READ TABLE i_sale_ref INTO DATA(lst_comp_sales) WITH KEY country_iso_code = st_input-country
                                                        BINARY SEARCH.
  IF sy-subrc EQ 0.
    READ TABLE i_t001 INTO DATA(lst_t001) WITH KEY bukrs = lst_comp_sales-compaany_code
                                                         BINARY SEARCH .
    IF sy-subrc EQ 0.
      READ TABLE i_ukm_kkber2 INTO DATA(lst_ukm_kkber2) WITH KEY kkber = lst_t001-kkber
                                                          BINARY SEARCH.
      IF sy-subrc EQ 0.
        READ TABLE i_def_credit INTO lst_def_credit WITH KEY credit_group = lsr_credit_group-low
                                                                   land1  = lst_t005-land1
                                                                   credit_sgmnt = lst_ukm_kkber2-credit_sgmnt
                                                                   BINARY SEARCH.
        IF sy-subrc NE 0.
          READ TABLE i_def_credit INTO lst_def_credit WITH KEY credit_group = lsr_credit_group-low
                                                                     credit_sgmnt = lst_ukm_kkber2-credit_sgmnt.
        ENDIF.
        READ TABLE i_risk_check INTO lst_risk_check WITH KEY cust_credit_group = lsr_credit_group-low
                                                             country = lst_t005-land1
                                                             credit_segment = lst_ukm_kkber2-credit_sgmnt
                                                             BINARY SEARCH.
        IF sy-subrc NE 0.
          READ TABLE i_risk_check INTO lst_risk_check WITH KEY cust_credit_group = lsr_credit_group-low
                                                                  credit_segment = lst_ukm_kkber2-credit_sgmnt.
        ENDIF.

      ENDIF.
    ENDIF.
*--*read credit control area
    READ TABLE i_t001cm INTO DATA(lst_t001cm) WITH KEY bukrs = lst_comp_sales-compaany_code
                                                       BINARY SEARCH .
    IF lst_comp_sales-compaany_code NE c_bukrs.
      READ TABLE i_t001cm INTO DATA(lst_t001cm_1001) WITH KEY bukrs = c_bukrs
                                                        BINARY SEARCH .
    ENDIF.
  ENDIF.
*--*Collection Management
  READ TABLE lir_coll_seg INTO lsr_coll_seg WITH KEY low = lst_comp_sales-compaany_code.
  IF sy-subrc EQ 0.
    READ TABLE i_coll INTO lst_coll_prof WITH KEY   coll_segment = lsr_coll_seg-high
                                                    credit_group = lsr_credit_group-low
                                                    land1 = lst_t005-land1
                                                    regio = st_input-region
                                                    vkorg = lst_comp_sales-compaany_code
                                                    vtweg = lsr_vtweg-low
                                                    spart = lsr_spart-low
                                                    BINARY SEARCH.
    IF sy-subrc NE 0.
      READ TABLE i_coll INTO lst_coll_prof WITH KEY coll_segment = lsr_coll_seg-high
                                                    credit_group = lsr_credit_group-low
                                                    land1 = lst_t005-land1
                                                    vkorg = lst_comp_sales-compaany_code
                                                    vtweg = lsr_vtweg-low
                                                    spart = lsr_spart-low.
      IF sy-subrc NE 0.
        READ TABLE i_coll INTO lst_coll_prof WITH KEY coll_segment = lsr_coll_seg-high
                                                     credit_group = lsr_credit_group-low
                                                     land1 = lst_t005-land1
                                                     regio = st_input-region.
        IF sy-subrc NE 0.
          READ TABLE i_coll INTO lst_coll_prof WITH KEY coll_segment = lsr_coll_seg-high
                                                        credit_group = lsr_credit_group-low
                                                        land1 = lst_t005-land1.
          IF sy-subrc NE 0.
            READ TABLE i_coll INTO lst_coll_prof WITH KEY coll_segment = lsr_coll_seg-high
                                                          credit_group = lsr_credit_group-low.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
*==* Different info required for 1001
  IF lst_comp_sales-compaany_code NE c_vkorg.
    READ TABLE lir_coll_seg INTO lsr_coll_seg WITH KEY low = c_vkorg.
    IF sy-subrc EQ 0.
      READ TABLE i_coll INTO lst_coll_1001 WITH KEY   coll_segment = lsr_coll_seg-high
                                                      credit_group = lsr_credit_group-low
                                                      land1 = c_us
                                                      vkorg = c_vkorg
                                                      vtweg = lsr_vtweg-low
                                                      spart = lsr_spart-low.
      IF sy-subrc NE 0.
        READ TABLE i_coll INTO lst_coll_1001 WITH KEY  coll_segment = lsr_coll_seg-high
                                                       credit_group = lsr_credit_group-low
                                                       land1 = c_us.
        IF sy-subrc NE 0.
          READ TABLE i_coll INTO lst_coll_1001 WITH KEY coll_segment = lsr_coll_seg-high
                                                        credit_group = lsr_credit_group-low.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
  READ TABLE i_cust_grp INTO DATA(lst_cust_grp) WITH KEY cust_credit_group = lst_risk_check-cust_credit_group
                                                           BINARY SEARCH.

*--* Title conversion
  IF st_input-title IS NOT INITIAL.
    READ TABLE i_tsad3t INTO lst_tsad3t WITH KEY langu = sy-langu
                                                      title_medi = st_input-title
                                                      BINARY SEARCH.
    IF sy-subrc NE 0.
      CONCATENATE st_input-title c_title_dot INTO st_input-title.
      READ TABLE i_tsad3t INTO lst_tsad3t WITH KEY langu = sy-langu
                                                        title_medi = st_input-title
                                                        BINARY SEARCH.
    ENDIF.
  ENDIF.
*"----------------------------------------------------------------------
*-----*General data mapping to BP structures
*"----------------------------------------------------------------------
  IF st_create-gen_data IS NOT INITIAL.
    IF lst_tsad3t-title IS NOT INITIAL.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-title_key = lst_tsad3t-title.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-title_key = abap_true.
    ENDIF.
    IF st_input-firstname IS NOT INITIAL.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_person-firstname = st_input-firstname.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_person-firstname = abap_true.
    ENDIF.
    IF st_input-lastname IS NOT INITIAL.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_person-lastname = st_input-lastname.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_person-lastname = abap_true.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-searchterm1 = st_input-lastname.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-searchterm1 = abap_true.
    ENDIF.
*    IF lsr_spras-low IS NOT INITIAL.
*      st_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-partnerlanguage = lsr_spras-low.
*      st_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-partnerlanguage = abap_true.
*    ENDIF.
    IF st_input-street IS NOT INITIAL.
      lst_addresses-data-postal-data-street = st_input-street.
      lst_addresses-data-postal-datax-street = abap_true.
    ENDIF.
    IF st_input-dept IS NOT INITIAL.
      lst_addresses-data-postal-data-str_suppl1 = st_input-dept.
      lst_addresses-data-postal-datax-str_suppl1 = abap_true.
    ENDIF.
    IF st_input-org IS NOT INITIAL.
      lst_addresses-data-postal-data-str_suppl2 = st_input-org.
      lst_addresses-data-postal-datax-str_suppl2 = abap_true..
    ENDIF.
    IF st_input-street_line2 IS NOT INITIAL.
      lst_addresses-data-postal-data-str_suppl3 = st_input-street_line2.
      lst_addresses-data-postal-datax-str_suppl3 = abap_true.
    ENDIF.
    IF st_input-street_line3 IS NOT INITIAL.
      lst_addresses-data-postal-data-location = st_input-street_line3.
      lst_addresses-data-postal-datax-location = abap_true.
    ENDIF.
    IF st_input-city IS NOT INITIAL.
      lst_addresses-data-postal-data-city = st_input-city.
      lst_addresses-data-postal-datax-city = abap_true..
    ENDIF.
    IF st_input-postl_cod1 IS NOT INITIAL.
      lst_addresses-data-postal-data-postl_cod1 = st_input-postl_cod1.
      lst_addresses-data-postal-datax-postl_cod1 = abap_true.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-searchterm2 = st_input-postl_cod1.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-searchterm2 = abap_true.
    ENDIF.
    IF st_input-region IS NOT INITIAL.
      lst_addresses-data-postal-data-region = st_input-region.
      lst_addresses-data-postal-datax-region = abap_true.
    ENDIF.
    IF lst_t005-land1 IS NOT INITIAL.
      lst_addresses-data-postal-data-country = lst_t005-land1.
      lst_addresses-data-postal-datax-country = abap_true.
    ENDIF.
    IF lsr_spras-low IS NOT INITIAL..
      st_bp_input-general_data-gen_data-central_data-common-data-bp_person-correspondlanguage = lsr_spras-low.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_person-correspondlanguage = abap_true.
    ENDIF.
*    IF lsr_comm_type-low IS NOT INITIAL.
*      lst_addresses-data-postal-data-comm_type = lsr_comm_type-low.
*      lst_addresses-data-postal-datax-comm_type =  abap_true.
*    ENDIF.
    IF lsr_end_date-low IS NOT INITIAL.
      lst_addresses-data-postal-data-validtodate = lsr_end_date-low.
      lst_addresses-data-postal-datax-validtodate = abap_true.
      lst_addresses-data-postal-data-validfromdate = sy-datum.
      lst_addresses-data-postal-datax-validfromdate = abap_true.
    ENDIF.
    IF lsr_ktokd-low IS NOT INITIAL.
      st_bp_input-general_data-add_gen_data-central-data-ktokd = lsr_ktokd-low.
      st_bp_input-general_data-add_gen_data-central-datax-ktokd = abap_true.
    ENDIF.
    IF st_input-e_mail IS NOT INITIAL.
      lst_smtp-contact-data-e_mail = st_input-e_mail.
      lst_smtp-contact-datax-e_mail = abap_true.
      APPEND lst_smtp TO li_smtp.
      CLEAR : lst_smtp.
*      st_bp_input-general_data-gen_data-central_data-communication-smtp-smtp[] = li_smtp[].
      lst_addresses-data-communication-smtp-smtp = li_smtp[].
      CLEAR li_smtp[].
    ENDIF.
    IF st_input-telephone IS NOT INITIAL.
      lst_phone-contact-data-telephone = st_input-telephone.
      lst_phone-contact-datax-telephone = abap_true.
      APPEND lst_phone TO li_phone.
      CLEAR lst_phone.
*      st_bp_input-general_data-gen_data-central_data-communication-phone-phone[] = li_phone[].
      lst_addresses-data-communication-phone-phone = li_phone[].
      CLEAR : li_phone[].
    ENDIF.
    IF lst_addresses IS NOT INITIAL.
      APPEND lst_addresses TO li_addresses.
      CLEAR : lst_addresses.
      st_bp_input-general_data-gen_data-central_data-address-addresses[] = li_addresses[].
      CLEAR : li_addresses[].
    ENDIF.


*    IF lsr_comm_type-low IS NOT INITIAL.
*      st_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-comm_type = lsr_comm_type-low."dafualt
*      st_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-comm_type = abap_true.
*    ENDIF.

    IF lsr_bu_group-low IS NOT INITIAL.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_control-grouping = lsr_bu_group-low. "default
    ENDIF.
    IF lsr_bu_type-low IS NOT INITIAL.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_control-category = lsr_bu_type-low. "default
    ENDIF.
  ENDIF.
  "----------------------------------------------------------------------
*---BP Roles - defaults
*"----------------------------------------------------------------------
  LOOP AT lir_rel_type INTO lsr_rel_type.
    lst_role-data_key      =  lsr_rel_type-low.
    lst_role-data-rolecategory = lsr_rel_type-low.
    lst_role-data-valid_from = sy-datum.
    lst_role-data-valid_to = lsr_end_date-low.
    lst_role-datax-valid_from = abap_true.
    lst_role-datax-valid_to = abap_true.
    APPEND lst_role TO li_role.
    CLEAR lst_role.
  ENDLOOP.
  IF li_role IS NOT INITIAL.
    st_bp_input-general_data-gen_data-central_data-role-roles[] = li_role[].
    CLEAR: li_role[].
  ENDIF.

*--*Tax info
*    IF st_input-taxnumber IS NOT INITIAL.
*      lst_tax-data_key-taxnumber = st_input-taxnumber.
*    ELSE.
*      lst_tax-data_key-taxnumber = lsr_bptaxnum-low.
*    ENDIF.
*    IF st_input-taxtype IS NOT INITIAL.
*      lst_tax-data_key-taxtype = st_input-taxtype.
*    ELSE.
*      lst_tax-data_key-taxtype = lsr_taxtype-low.
*    ENDIF.
*    APPEND lst_tax TO li_tax.
*    CLEAR lst_tax.
*    st_bp_input-general_data-gen_data-central_data-taxnumber-taxnumbers[] = li_tax[].
*    CLEAR : li_tax[].
  "----------------------------------------------------------------------
*---Business Partner ID data mapping
*"----------------------------------------------------------------------
  IF v_bp IS NOT INITIAL.
    st_bp_input-general_data-gen_data-header-object_instance-bpartner = v_bp.
  ENDIF.
  lst_id-data_key-identificationnumber = st_input-id_number..
  lst_id-data_key-identificationcategory = c_zmemid.
  lst_id-data-identrydate = sy-datum.
  APPEND lst_id TO li_id.
  CLEAR lst_id.
  IF li_id IS NOT INITIAL.
    st_bp_input-general_data-gen_data-central_data-ident_number-ident_numbers[] = li_id[].
    CLEAR: li_id.
  ENDIF.
  st_bp_input-general_data-gen_data-header-object_instance-identificationcategory = c_zmemid.
  st_bp_input-general_data-gen_data-header-object_instance-identificationnumber = st_input-id_number.
  lst_time-valid_from = sy-datum.
  lst_time-valid_from_x = abap_true.
  APPEND lst_time TO li_time.
  CLEAR lst_time.
  st_bp_input-general_data-gen_data-central_data-common-time_dependent_data-common_data[] = li_time[].
  CLEAR : li_time[].
*--* KATR6
  IF lsr_katr6-low IS NOT INITIAL.
    st_bp_input-general_data-add_gen_data-central-data-katr6 =  lsr_katr6-low.
    st_bp_input-general_data-add_gen_data-central-datax-katr6 =  abap_true.
  ENDIF.
  "----------------------------------------------------------------------
*---*Company code extension data mapping
*"----------------------------------------------------------------------
  IF st_create-comp_data IS NOT INITIAL.
    IF lst_comp_sales-compaany_code IS NOT INITIAL.
      lst_comp_codes-data_key-bukrs = lst_comp_sales-compaany_code.
    ENDIF.
    IF lsr_akont-low IS NOT INITIAL.
      lst_comp_codes-data-akont = lsr_akont-low.
      lst_comp_codes-datax-akont = abap_true.
    ENDIF.
    IF lsr_zterm-low IS NOT INITIAL.
      lst_comp_codes-data-zterm = lsr_zterm-low.
      lst_comp_codes-datax-zterm = abap_true.
    ENDIF.
    IF lsr_xzver-low IS NOT INITIAL.
      lst_comp_codes-data-xzver = lsr_xzver-low.
      lst_comp_codes-datax-xzver = abap_true.
    ENDIF.
    IF lsr_xausz-low IS NOT INITIAL.
      lst_comp_codes-data-xausz = lsr_xausz-low .
      lst_comp_codes-datax-xausz = abap_true.
    ENDIF.
    IF lst_coll_prof-busab IS NOT INITIAL.
      lst_comp_codes-data-busab = lst_coll_prof-busab.
      lst_comp_codes-datax-busab = abap_true.
    ENDIF.
    IF lsr_sort_key-low IS NOT INITIAL.
      lst_comp_codes-data-zuawa = lsr_sort_key-low.
      lst_comp_codes-datax-zuawa = abap_true.
    ENDIF.
    "----------------------------------------------------------------------
*---FI Dunning data mapping
*"----------------------------------------------------------------------
*--*Dunning
    IF lsr_mahna-low IS NOT INITIAL.
      lst_dunning-data-mahna = lsr_mahna-low.
      lst_dunning-datax-mahna = abap_true.
      APPEND lst_dunning TO li_dunning.
      CLEAR : lst_dunning.
      lst_comp_codes-dunning-dunning[] = li_dunning[].
      CLEAR : li_dunning[].
    ENDIF.
    IF lst_comp_codes IS NOT INITIAL.
      APPEND lst_comp_codes TO li_comp_codes.
*--*Extend company code to 1001 default
      IF lst_comp_sales-compaany_code NE c_vkorg.
        lst_comp_codes-data_key-bukrs = c_vkorg.
        lst_comp_codes-data-busab = lst_coll_1001-busab.
        APPEND lst_comp_codes TO li_comp_codes.
      ENDIF.
      CLEAR lst_comp_codes.
      st_bp_input-comp_code_data-comp_codes[] = li_comp_codes[].
      CLEAR : li_comp_codes[].
    ENDIF.
  ENDIF.
  "----------------------------------------------------------------------
*---Sales & distribition Extension mapping
*"----------------------------------------------------------------------
  IF st_create-sales_data IS NOT INITIAL.
    IF lst_comp_sales-compaany_code IS NOT INITIAL.
      lst_sales-data_key-vkorg = lst_comp_sales-compaany_code.
    ENDIF.
    IF lsr_vtweg-low IS NOT INITIAL.
      lst_sales-data_key-vtweg = lsr_vtweg-low.
    ENDIF.
    IF lsr_spart-low IS NOT INITIAL.
      lst_sales-data_key-spart = lsr_spart-low.
    ENDIF.
    IF lsr_kdgrp-low IS NOT INITIAL.
      lst_sales-data-kdgrp = lsr_kdgrp-low.
      lst_sales-datax-kdgrp = abap_true.
    ENDIF.
    IF lsr_kalks-low IS NOT INITIAL.
      lst_sales-data-kalks = lsr_kalks-low.
      lst_sales-datax-kalks = abap_true.
    ENDIF.
    IF lsr_vrseg-low IS NOT INITIAL.
      lst_sales-data-versg = lsr_vrseg-low.
      lst_sales-datax-versg = abap_true.
    ENDIF.
    IF lsr_lprio-low IS NOT INITIAL.
      lst_sales-data-lprio = lsr_lprio-low.
      lst_sales-datax-lprio = abap_true.
    ENDIF.
    IF lsr_vsbed-low IS NOT INITIAL.
      lst_sales-data-vsbed = lsr_vsbed-low.
      lst_sales-datax-vsbed = abap_true.
    ENDIF.
    IF lsr_inco1-low IS NOT INITIAL.
      lst_sales-data-inco1 = lsr_inco1-low.
      lst_sales-datax-inco1 = abap_true.
    ENDIF.
    IF lsr_inco2-low IS NOT INITIAL.
      lst_sales-data-inco2 = lsr_inco2-low.
      lst_sales-datax-inco2 = abap_true.
    ENDIF.
    IF lsr_zterm-low IS NOT INITIAL.
      lst_sales-data-zterm = lsr_zterm-low.
      lst_sales-datax-zterm = abap_true.
    ENDIF.
    IF lsr_ktgrd-low IS NOT INITIAL..
      lst_sales-data-ktgrd = lsr_ktgrd-low.
      lst_sales-datax-ktgrd = abap_true.
    ENDIF.
    IF lsr_kvgr1-low IS NOT INITIAL.
      lst_sales-data-kvgr1 = lsr_kvgr1-low.
      lst_sales-datax-kvgr1 = abap_true.
    ENDIF.
    IF lst_comp_sales-currency_code IS NOT INITIAL .
      lst_sales-data-waers = lst_comp_sales-currency_code.
      lst_sales-datax-waers = abap_true.
    ENDIF.
    IF lst_comp_sales-price_list IS NOT INITIAL.
      lst_sales-data-pltyp = lst_comp_sales-price_list.
      lst_sales-datax-pltyp = abap_true.
    ENDIF.
    IF lst_t001cm-kkber IS NOT INITIAL.
      lst_sales-data-kkber = lst_t001cm-kkber.
      lst_sales-datax-kkber = abap_true.
    ENDIF.
*--*Populate  FTE based on Partner type
    READ TABLE lir_fte INTO lsr_fte WITH KEY low = lsr_bu_type-low.
    IF sy-subrc EQ 0.
      lst_sales-data-zzfte = lsr_fte-high.
      lst_sales-datax-zzfte = abap_true.
    ENDIF.
*--*Partner functions
*    LOOP AT lir_parvw INTO lsr_parvw..
*      lst_functions-data_key-parvw = lsr_parvw-low.
*      APPEND lst_functions TO li_functions.
*      CLEAR : lst_functions.
*    ENDLOOP.
*
*    lst_sales-functions-functions[] = li_functions[].
*    CLEAR : li_functions[].
    IF lst_sales IS NOT INITIAL.
      APPEND lst_sales TO li_sales.
*--*Default Sales area
      IF lst_sales-data_key-vkorg NE c_vkorg.
        lst_sales-data_key-vkorg = c_vkorg.
        lst_sales-data-kkber = lst_t001cm_1001-kkber.
        lst_sales-datax-kkber = abap_true.
        APPEND lst_sales TO li_sales.
      ENDIF.
      CLEAR : lst_sales.
      st_bp_input-sales_data-sales_datas[] = li_sales[].
      CLEAR : li_sales[].
    ENDIF.
    "----------------------------------------------------------------------
*--*S&D Sales tax Info
*"---------------------------------------------------------------------
    IF lsr_tatyp-low IS NOT INITIAL.
      lst_sales_tax-data_key-tatyp = lsr_tatyp-low.
    ENDIF.
    IF lst_t005-land1 IS NOT INITIAL..
      lst_sales_tax-data_key-aland = lst_t005-land1.
    ENDIF.
    IF lsr_taxkd-low IS NOT INITIAL.
      lst_sales_tax-data-taxkd = lsr_taxkd-low.
      lst_sales_tax-datax-taxkd = abap_true.
      APPEND lst_sales_tax TO li_sales_tax.
      CLEAR lst_sales_tax.
      st_bp_input-general_data-add_gen_data-tax_ind-tax_ind[] = li_sales_tax[].
      CLEAR : li_sales_tax[].
    ENDIF.
  ENDIF.
  "----------------------------------------------------------------------
*--*Collection Profile data mapping
*"----------------------------------------------------------------------
  IF lsr_coll_profile-low IS NOT INITIAL.
    st_bp_input-crdt_coll_data-collection_data-coll_profile-coll_profile = lsr_coll_profile-low.
  ENDIF.
  IF lst_coll_prof-coll_segment IS NOT INITIAL.
    lst_coll-coll_segment = lst_coll_prof-coll_segment.
  ENDIF.
  IF lst_coll_prof-coll_group IS NOT INITIAL.
    lst_coll-coll_group = lst_coll_prof-coll_group.
  ENDIF.
  IF lst_coll_prof-coll_specialist IS NOT INITIAL.
    lst_coll-coll_specialist = lst_coll_prof-coll_specialist.
  ENDIF.
  IF lst_coll IS NOT INITIAL.
    APPEND lst_coll TO li_coll.
    CLEAR lst_coll.
    st_bp_input-crdt_coll_data-collection_data-coll_segment[] = li_coll[].
    CLEAR : li_coll[].
  ENDIF.
  "----------------------------------------------------------------------
*--*Credit segment Data mapping
*"----------------------------------------------------------------------
  IF lst_def_credit-risk_class IS NOT INITIAL.
    st_bp_input-crdt_coll_data-credit_data-credit_profile-risk_class = lst_def_credit-risk_class.
  ENDIF.
  IF lst_def_credit-check_rule IS NOT INITIAL.
    st_bp_input-crdt_coll_data-credit_data-credit_profile-check_rule = lst_def_credit-check_rule.
  ENDIF.
  IF lsr_credit_group-low IS NOT INITIAL.
    st_bp_input-crdt_coll_data-credit_data-credit_profile-credit_group = lsr_credit_group-low.
  ENDIF.
  IF lst_def_credit-credit_limit IS NOT INITIAL.
    lst_credit-credit_sgmnt = lst_def_credit-credit_sgmnt.
    lst_credit-credit_limit = lst_def_credit-credit_limit.
    CONDENSE lst_credit-credit_limit.
    APPEND lst_credit TO li_credit.
    CLEAR lst_credit.
  ENDIF.
  IF li_credit IS NOT INITIAL.
    st_bp_input-crdt_coll_data-credit_data-credit_segment = li_credit[].
    CLEAR : li_credit.
  ENDIF.
  "----------------------------------------------------------------------
*--*BP Relationship data mapping
*"----------------------------------------------------------------------
  st_bp_input-data_key-id_number = st_input-id_number.
  TRANSLATE st_input-reltyp TO UPPER CASE.
  IF st_input-reltyp = c_student.
    lst_relation-header-object_instance-relat_category = c_zir002.
    lv_date+0(4) = sy-datum+0(4).
    lv_date+4(2) = 12.
    lv_date+6(2) = 31.
  ELSE.
    lst_relation-header-object_instance-date_to = lv_date.
    lst_relation-header-object_instance-relat_category = c_zir001.
    lst_relation-header-object_instance-date_to = lsr_end_date-low.
  ENDIF.
  IF v_bp IS NOT INITIAL.
    lst_relation-header-object_instance-partner1-bpartner = v_bp.
  ENDIF.
  IF lsr_agu-low IS NOT INITIAL.
    lst_relation-header-object_instance-partner2-bpartner = lsr_agu-low.
  ENDIF.
*st_bp_input = st_input-REL_DATE_FROM.

  APPEND lst_relation TO li_relation.
  CLEAR : lst_relation.
  st_bp_input-relationship_data-relationships[] = li_relation[].
  CLEAR : li_relation[].
  IF st_bp_input IS NOT INITIAL.
    APPEND st_bp_input TO i_bp_input.
    CLEAR st_bp_input.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALL_BP_UPDATE_FM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_call_bp_update_fm .
  v_source = 'AGU'.
  CALL FUNCTION 'ZQTC_CUSTOMER_IB_INTERFACE_AGU'
    EXPORTING
      im_data   = i_bp_input
      im_source = v_source
    IMPORTING
      ex_return = i_bp_return.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_OUTPUT_RETURN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_output_return .
  DATA : li_messages TYPE bapiretct.
  CLEAR : li_messages.

*--*Append BAPI reurn messages
  LOOP AT i_bp_return INTO DATA(lst_bp_return).
    APPEND LINES OF lst_bp_return-messages TO  li_messages.
    CLEAR lst_bp_return-messages[].
  ENDLOOP.
  IF li_messages IS NOT INITIAL.
    MOVE-CORRESPONDING st_input TO st_output.
    IF v_partner IS NOT INITIAL.
      st_output-bp = v_partner.
    ENDIF.
    LOOP AT li_messages INTO DATA(lst_messages).
      st_output-message = lst_messages-message.
      st_output-msg_type = lst_messages-type.
      CASE lst_messages-message_v4.
        WHEN '008'.
*--*BOC ERPM-3369 ED2K918028 Prabhu 5/5/2020
          IF st_input-indicator = c_new.
            st_output-msg_number = text-e08.
          ELSEIF st_input-indicator = c_coa.
            st_output-msg_number = text-e16.
          ENDIF.
        WHEN '009'.
          st_output-msg_number = text-e09.
          IF st_input-indicator = c_coa.
            CONTINUE.
          ENDIF.
        WHEN '010'.
          st_output-msg_number = text-e10.
          IF st_input-indicator = c_coa.
            CONTINUE.
          ENDIF.
        WHEN '011'.
          st_output-msg_number = text-e11.
          IF st_input-indicator = c_coa.
            CONTINUE.
*--*EOC ERPM-3369 ED2K918028 Prabhu 5/5/2020
          ENDIF.
        WHEN OTHERS.
      ENDCASE.
      APPEND st_output TO i_output.
      CLEAR : st_output-msg_number.
    ENDLOOP.
    CLEAR : st_output,i_bp_return[].
  ENDIF.
*--*Append validation messages
  APPEND LINES OF i_out_ret TO i_output.
  CLEAR : i_out_ret.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INPUT_VALIDATIONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_input_bp_validations .

  DATA : lv_cat          TYPE bapibus1006_identification_key-identificationcategory VALUE 'ZMEMID',
         lv_id           TYPE bapibus1006_identification_key-identificationnumber,
         li_partner      TYPE STANDARD TABLE OF bus_partner_guid,
         lst_partner     TYPE bus_partner_guid,
         li_return       TYPE STANDARD TABLE OF bapiret2,
         li_return_id    TYPE STANDARD TABLE OF bapiret2,
         lst_id          TYPE bapibus1006_identification,
         lv_lines        TYPE i,
         lv_zmemid_found TYPE c.
*"----------------------------------------------------------------------
*--*Check BP by ID number of the input file
*"----------------------------------------------------------------------
  CLEAR lv_zmemid_found.
  lv_id = st_input-id_number.
  CALL FUNCTION 'BUPA_PARTNER_GET_BY_IDNUMBER'
    EXPORTING
      iv_identificationcategory = lv_cat
      iv_identificationnumber   = lv_id
    TABLES
      t_partner_guid            = li_partner
      et_return                 = li_return.
  DESCRIBE TABLE li_partner LINES lv_lines.
*"----------------------------------------------------------------------
*--*If Unique BP found then required validations
*"----------------------------------------------------------------------
  IF li_partner IS NOT INITIAL AND lv_lines = 1.
    CLEAR : lst_partner.
    READ TABLE li_partner INTO lst_partner INDEX 1.
    IF sy-subrc EQ 0.
      v_bp = lst_partner-partner.
*--*Get Partner and look for additional extenstions
      PERFORM f_find_partner USING lst_partner-partner.
    ENDIF.
    lv_zmemid_found = abap_true.
*"----------------------------------------------------------------------
*--* if multiple BP's found raise an expection
*"----------------------------------------------------------------------
  ELSEIF lv_lines GT 1.
    st_output-msg_type = c_e.
    st_output-msg_number = text-e07.
    st_output-message = text-007.
    MOVE-CORRESPONDING st_input TO st_output.
    APPEND st_output TO i_out_ret.
    CLEAR : st_output.
    v_error = abap_true.
  ELSE.
*"----------------------------------------------------------------------
*--*BP search with address parameters - Criteria 1
*"----------------------------------------------------------------------
    PERFORM f_bp_search TABLES li_partner.
  ENDIF.
*"----------------------------------------------------------------------
*--*Decide Operations to be peroformed
*"----------------------------------------------------------------------
  IF li_partner IS INITIAL AND v_error IS INITIAL.
    st_create-gen_data = c_i.
  ENDIF.
  IF st_create-gen_data = c_i.
    st_create-comp_data = abap_true.
    st_create-sales_data = abap_true.
    st_create-assign_bp = abap_true.
    st_create-relation = abap_true.
  ENDIF.
*--*
  IF v_error IS NOT INITIAL.
    APPEND LINES OF i_out_ret TO i_output.
    CLEAR i_out_ret.
  ENDIF.
*--*If there is no ZMEMID partner, insert it instead of update
  IF lv_zmemid_found IS INITIAL AND v_error IS INITIAL AND st_create-gen_data NE c_i.
    CLEAR : li_return_id.
    lst_id-identrydate = sy-datum.
    CALL FUNCTION 'BUPA_IDENTIFICATION_ADD'
      EXPORTING
        iv_partner                = v_bp
*       IV_PARTNER_GUID           =
        iv_identificationcategory = c_zmemid
        iv_identificationnumber   = st_input-id_number
        is_identification         = lst_id
      TABLES
        et_return                 = li_return_id.
    IF li_return_id IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
      MOVE-CORRESPONDING st_input TO st_output.
      st_output-message = text-009.
      st_output-msg_type = c_i.
      st_output-bp = v_bp.
*--*BOC ERPM-3369 ED2K918028 Prabhu 5/5/2020
*      st_output-msg_number = text-e08.
      st_output-msg_number = text-e12.
*--*EOC ERPM-3369 ED2K918028 Prabhu 5/5/2020
      APPEND st_output TO i_out_ret.
      CLEAR st_output.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_SEARCH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bp_search TABLES fp_li_partner STRUCTURE  bus_partner_guid.
  DATA : lv_email    TYPE ad_smtpadr,
         lst_address TYPE bupa_addr_search,
         lv_name1    TYPE bu_mcname1,
         lv_name2    TYPE bu_mcname2,
         li_result   TYPE STANDARD TABLE OF bus020_search_result,
         lst_result  TYPE bus020_search_result,
         lst_partner LIKE LINE OF fp_li_partner,
         li_return   TYPE STANDARD TABLE OF bapiret2,
         lst_return  TYPE bapiret2,
         lv_lines    TYPE i.
*--*First search Email + First name + Last name +Street
  lv_email = st_input-e_mail.
  lst_address-street =  st_input-street.
  lv_name1 = st_input-lastname.
  lv_name2 = st_input-firstname.
  CALL FUNCTION 'BUPA_SEARCH_2'
    EXPORTING
*     IV_TELEPHONE     =
      iv_email         = lv_email
      is_address       = lst_address
      iv_mc_name1      = lv_name1
      iv_mc_name2      = lv_name2
*     IV_VALID_DATE    = SY-DATLO
      iv_req_mask      = abap_true
    TABLES
      et_search_result = li_result
      et_return        = li_return.
*--*Search Result
  DESCRIBE TABLE li_result LINES lv_lines.
*--*If single BP found
  IF lv_lines = 1.
    CLEAR : lst_result.
    READ TABLE li_result INTO lst_result INDEX 1.
*--*Check Partner roles
    IF sy-subrc EQ 0.
      v_bp = lst_result-partner.
      PERFORM f_check_bp_roles_single USING lst_result-partner.
      lst_partner-partner = lst_result-partner.
      APPEND lst_partner TO fp_li_partner.
      CLEAR: lst_partner.
    ENDIF.
  ELSEIF lv_lines GT 1.
    LOOP AT li_result INTO lst_result.
*--*Check one by one BP roles
      PERFORM f_check_bp_roles_multiple USING lst_result-partner.
      IF st_create IS NOT INITIAL.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF st_create-gen_data NE c_i.
      v_bp = lst_result-partner.
      lst_partner-partner = lst_result-partner.
      APPEND lst_partner TO fp_li_partner.
      CLEAR: lst_partner.
    ENDIF.
  ELSE.
*"----------------------------------------------------------------------
*--*BP search with address parameters - Criteria 2
*"----------------------------------------------------------------------
    PERFORM f_bp_search_2 TABLES fp_li_partner.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FIND_PARTNER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_PARTNER_PARTNER  text
*----------------------------------------------------------------------*
FORM f_find_partner  USING    fp_partner TYPE kunnr.
  DATA : lv_relnr    TYPE bu_relnr,
         lv_kunnr    TYPE kunnr,
         li_relation TYPE STANDARD TABLE OF bapibus1006_relations,
         li_return   TYPE STANDARD TABLE OF bapiret2,
         lv_lines    TYPE i.
*--*Check company code extension
  SELECT SINGLE kunnr FROM knb1 INTO @lv_kunnr WHERE  kunnr = @fp_partner
                                                    AND  bukrs = @c_bukrs.
  IF sy-subrc NE 0.
    st_create-comp_data = abap_true.
  ENDIF.
*--* Check sales area extension
  SELECT SINGLE kunnr FROM knvv INTO @lv_kunnr WHERE kunnr = @fp_partner
                                                AND vkorg = @c_vkorg
                                                AND vtweg = @c_vtweg
                                                AND spart = @c_spart.
  IF sy-subrc NE 0.
    st_create-sales_data = abap_true.
  ENDIF.
*--*Get Relation ships
  CALL FUNCTION 'BUPA_RELATIONSHIPS_GET'
    EXPORTING
      iv_partner       = fp_partner
      iv_req_mask      = 'X'
    TABLES
      et_relationships = li_relation
      et_return        = li_return.
*--*Check if BP is assigned to AGU
  READ TABLE li_relation INTO DATA(lst_relation) WITH KEY partner1 = fp_partner
                                                          partner2 = lsr_agu-low
                                                          relationshipcategory = c_zir001.

  IF sy-subrc NE 0.
*--* Assign BP
    st_create-relation = abap_true.
*--*Close previous relation ship
    READ TABLE li_relation INTO DATA(lst_relation2) WITH KEY  partner1 = fp_partner
                                                              partner2 = lsr_agu-low.
    IF sy-subrc EQ 0.
      st_create-close_previous = abap_true.
    ENDIF.
  ENDIF.
*--*If Above conditions are not met then Update General data
  IF st_create-comp_data IS INITIAL AND st_create-sales_data IS INITIAL AND st_create-relation IS INITIAL.
    st_create-gen_data = c_u.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_BP_ROLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_RESULT_PARTNER  text
*----------------------------------------------------------------------*
FORM f_check_bp_roles_single  USING    fp_partner TYPE bu_partner.
  DATA : li_return  TYPE STANDARD TABLE OF bapiret2,
         lst_return TYPE bapiret2,
         li_roles   TYPE STANDARD TABLE OF bapibus1006_roles,
         lst_roles  TYPE bapibus1006_roles.
  CALL FUNCTION 'BAPI_BUPA_ROLES_GET'
    EXPORTING
      businesspartner      = fp_partner
    TABLES
      businesspartnerroles = li_roles
      return               = li_return.
  READ TABLE li_roles INTO lst_roles WITH KEY partnerrole = c_ism000.
  IF sy-subrc NE 0.
*--*Create general data
    st_create-gen_data = c_u.
  ELSE.
*--*Check Company code , Sales & BP relation ships
    PERFORM f_find_partner USING fp_partner.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_BP_ROLES_MULTIPLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_RESULT_PARTNER  text
*----------------------------------------------------------------------*
FORM f_check_bp_roles_multiple  USING    fp_partner TYPE bu_partner.
  DATA : li_return  TYPE STANDARD TABLE OF bapiret2,
         lst_return TYPE bapiret2,
         li_roles   TYPE STANDARD TABLE OF bapibus1006_roles,
         lst_roles  TYPE bapibus1006_roles.
  CALL FUNCTION 'BAPI_BUPA_ROLES_GET'
    EXPORTING
      businesspartner      = fp_partner
    TABLES
      businesspartnerroles = li_roles
      return               = li_return.
  READ TABLE li_roles INTO lst_roles WITH KEY partnerrole = c_ism000.
*--*If Existing BP doesn't match with sales role then continue the search
  IF sy-subrc NE 0.
*--*Create New BP
    st_create-gen_data = c_i.
    EXIT.
  ELSE.
*--*Check BP relationships to AGU
    PERFORM f_find_bp_relationships USING fp_partner.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_SEARCH_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bp_search_2 TABLES fp_li_partner STRUCTURE  bus_partner_guid..
  DATA : lv_email    TYPE ad_smtpadr,
         lst_partner LIKE LINE OF fp_li_partner,
         lv_name1    TYPE bu_mcname1,
         lv_name2    TYPE bu_mcname2,
         li_result   TYPE STANDARD TABLE OF bus020_search_result,
         lst_result  TYPE bus020_search_result,
         li_return   TYPE STANDARD TABLE OF bapiret2,
         lst_return  TYPE bapiret2,
         lv_lines    TYPE i.
  lv_email = st_input-e_mail.
  lv_name1 = st_input-lastname.
  lv_name2 = st_input-firstname.
  CALL FUNCTION 'BUPA_SEARCH_2'
    EXPORTING
*     IV_TELEPHONE     =
      iv_email         = lv_email
*     is_address       = lst_address
      iv_mc_name1      = lv_name1
      iv_mc_name2      = lv_name2
*     IV_VALID_DATE    = SY-DATLO
      iv_req_mask      = abap_true
    TABLES
      et_search_result = li_result
      et_return        = li_return.
*--*Get result
  DESCRIBE TABLE li_result LINES lv_lines.
  IF lv_lines = 1.
*--*If Unique BP found
    READ TABLE li_result INTO lst_result INDEX 1.
    IF sy-subrc EQ 0.
*--*Check BP roles
      PERFORM f_check_bp_roles_single USING lst_result-partner.
      lst_partner-partner = lst_result-partner.
      APPEND lst_partner TO fp_li_partner.
      CLEAR: lst_partner.
      v_bp = lst_result-partner.
    ENDIF.
  ELSEIF lv_lines GT 1.
*--*Process Multiple BP
    LOOP AT li_result INTO lst_result.
*--*Check BP roles
      PERFORM f_check_bp_roles_multiple USING lst_result-partner.
      IF st_create IS NOT INITIAL.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF st_create-gen_data NE c_i.
      v_bp = lst_result-partner.
      lst_partner-partner = lst_result-partner.
      APPEND lst_partner TO fp_li_partner.
      CLEAR: lst_partner.
    ENDIF.
*--*BP Search criteria 3
  ELSE.
*BOC ERPM-2181 11/8/2019
    PERFORM f_bp_search_3 TABLES fp_li_partner.
*EOC ERPM-2181 11/8/2019
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FIND_BP_RELATIONSHIPS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_PARTNER  text
*----------------------------------------------------------------------*
FORM f_find_bp_relationships  USING fp_partner TYPE bu_partner.
  DATA : li_relation TYPE STANDARD TABLE OF bapibus1006_relations,
         li_return   TYPE STANDARD TABLE OF bapiret2,
         lv_lines    TYPE i.
  CALL FUNCTION 'BUPA_RELATIONSHIPS_GET'
    EXPORTING
      iv_partner       = fp_partner
*     IV_RELATIONSHIP_CATEGORY       =
      iv_req_mask      = 'X'
    TABLES
      et_relationships = li_relation
      et_return        = li_return.
  IF li_relation IS NOT INITIAL.
*--*Consider only sales relationships
    DELETE li_relation WHERE relationshipcategory NE c_zir001.
    DESCRIBE TABLE li_relation LINES lv_lines.
*--*IF it is more than 2 sales relationships
    IF lv_lines GT 1.
*--*Message.
      st_output-msg_type = c_e.
      st_output-msg_number = text-e06.
      st_output-message = text-006.
      MOVE-CORRESPONDING st_input TO st_output.
      APPEND st_output TO i_out_ret.
      CLEAR : st_output.
      v_error = abap_true.
    ELSEIF lv_lines EQ 1.
*--*Check with AGU relation ship
*      READ TABLE li_relation INTO DATA(lst_relation) WITH KEY partner2 = c_agu.
*      IF sy-subrc EQ 0.
*--* Assign BP
      st_create-assign_bp = abap_true.
*--*Partner extension to company code sales and BP assignment
      PERFORM f_find_partner USING fp_partner.
    ENDIF.
  ELSE.
*--*Maintain relationship
    PERFORM f_find_partner USING fp_partner.
*    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CUSTOM_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_custom_tables_data .

  IF i_country IS NOT INITIAL.
*"----------------------------------------------------------------------
*-----T005 (Countries ) - File contains ISO country name, Get SAP Country
*"----------------------------------------------------------------------
    SELECT land1, intca3 FROM t005 INTO TABLE @i_t005 WHERE intca3 IN @i_country.
    IF sy-subrc EQ 0.
      SORT i_t005 BY intca3.
    ENDIF.
    SELECT id,
           country_name,
           country_iso_code,
           country_sap,
           currency_code,
           compaany_code,
           price_list
               FROM zqtc_sal_ara_ref INTO TABLE @i_sale_ref
                         WHERE country_iso_code IN @i_country.
    IF sy-subrc EQ 0 AND i_sale_ref IS NOT INITIAL.
*"----------------------------------------------------------------------
*-----T001 & T001CM(Company codes) - Get Credit control Area
*"----------------------------------------------------------------------
      SELECT bukrs,
             kkber INTO TABLE @i_t001cm FROM t001cm
                              FOR ALL ENTRIES IN @i_sale_ref
                             WHERE bukrs = @i_sale_ref-compaany_code OR bukrs = @c_bukrs.
      IF sy-subrc EQ 0.
        SORT i_t001cm BY bukrs.
      ENDIF.
      SELECT bukrs,
             kkber INTO TABLE @i_t001 FROM t001
                               FOR ALL ENTRIES IN @i_sale_ref
                              WHERE bukrs = @i_sale_ref-compaany_code.
      IF sy-subrc EQ 0 AND i_t001 IS NOT INITIAL.
*"----------------------------------------------------------------------
*-----ukm_kkber2sgm (Assignment of Credit Control Area to Credit Segment)
*"----------------------------------------------------------------------
        SELECT kkber,
              credit_sgmnt FROM ukm_kkber2sgm INTO TABLE @i_ukm_kkber2
                                        FOR ALL ENTRIES IN  @i_t001
                                         WHERE kkber = @i_t001-kkber.
        IF sy-subrc EQ 0 AND i_ukm_kkber2 IS NOT INITIAL.
*"----------------------------------------------------------------------
*-----zrtr_def_credit (Default Credit Master Fields)
*"----------------------------------------------------------------------
          SELECT credit_group,
                 land1,
                 credit_sgmnt,
                 vkorg,
                 vtweg,
                 spart,
                 risk_class,
                 check_rule,
                 credit_limit
                  FROM zrtr_def_credit INTO TABLE @i_def_credit
                              FOR ALL ENTRIES IN @i_ukm_kkber2
                               WHERE credit_group = @lsr_credit_group-low
                                 AND credit_sgmnt = @i_ukm_kkber2-credit_sgmnt.
          IF sy-subrc EQ 0.
            SORT i_def_credit BY credit_group land1 credit_sgmnt.
          ENDIF.
          SORT i_ukm_kkber2 BY kkber.
        ENDIF.
        SORT i_t001 BY bukrs.
      ENDIF.
      SORT i_sale_ref BY country_iso_code.
    ENDIF.
*"----------------------------------------------------------------------
*-----zqtc_rsk_chk_rul (Risk Class Check Rule)
*"----------------------------------------------------------------------
*If i_t005 IS NOT INITIAL.
    IF lsr_credit_group-low IS NOT INITIAL.
      SELECT cust_credit_group,
             country,
             credit_segment,
             risk_class,
             credit_chk_rule
                        FROM zqtc_rsk_chk_rul INTO TABLE @i_risk_check
*                                   FOR ALL ENTRIES IN i_t005
                                     WHERE cust_credit_group = @lsr_credit_group-low.
*                                    AND  country =  @i_t005-land1.

      IF sy-subrc EQ 0." AND i_risk_check IS NOT INITIAL.
        SORT i_risk_check BY cust_credit_group country credit_segment.
      ENDIF.
*"----------------------------------------------------------------------
*-----zqtc_cust_cr_grp(New Customer and Credit Group Details)
*"----------------------------------------------------------------------
      SELECT tier1,
             tier2 ,
            tier3,
            cust_group_sap,
            description,
            cust_credit_group,
            cust_credit_group_text FROM zqtc_cust_cr_grp INTO TABLE @i_cust_grp
*                                FOR ALL ENTRIES IN @i_risk_check
                                 WHERE  cust_credit_group = @lsr_credit_group-low.
      IF sy-subrc EQ 0.
        SORT i_cust_grp BY cust_credit_group.
      ENDIF.

*"----------------------------------------------------------------------
*-----zrtr_coll_assign(Auto-populate the Collection Segment details)
*"----------------------------------------------------------------------
      SELECT coll_segment	,
             credit_group,
             land1,
             regio,
             vkorg,
             vtweg,
             spart,
             busab,
             coll_group,
             coll_specialist,
             coll_supervisor   FROM zrtr_coll_assign INTO TABLE @i_coll
*                               FOR ALL ENTRIES IN i_t005
*                                      WHERE land1 =  @i_t005-land1.
                                      WHERE credit_group = @lsr_credit_group-low.
      IF sy-subrc EQ 0.
        SORT i_coll BY coll_segment credit_group land1 regio vkorg vtweg spart.
      ENDIF.
    ENDIF.
  ENDIF.
*"----------------------------------------------------------------------------
*-----tsad3t(Titles (Texts)) - File contains Title description - Get Title codes
*"-----------------------------------------------------------------------------
  IF i_title IS NOT INITIAL.
    SELECT langu,
           title,
           title_medi INTO TABLE @i_tsad3t FROM  tsad3t
                           WHERE langu = @sy-langu
                           AND title_medi IN @i_title.
    IF sy-subrc EQ 0.
      SORT  i_tsad3t  BY langu title_medi.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_GLOBAL_V
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_global_v .
  CLEAR : st_input, st_output, st_bp_input, st_create, i_bp_input[], i_country[], i_title[],
          li_constant,i_sale_ref,i_t001,i_ukm_kkber2,i_def_credit,i_risk_check,i_cust_grp,
          i_coll,i_tsad3t,i_out_ret,i_t001cm,st_t001cm,lir_ctry_postal,lir_fte,lir_coll_seg.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_BP_ROLES_MULTIPLE_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_RESULT_PARTNER  text
*----------------------------------------------------------------------*
FORM f_check_bp_roles_multiple_2  USING   fp_partner TYPE bu_partner.
  DATA : li_return  TYPE STANDARD TABLE OF bapiret2,
         lst_return TYPE bapiret2,
         li_roles   TYPE STANDARD TABLE OF bapibus1006_roles,
         lst_roles  TYPE bapibus1006_roles.

  CALL FUNCTION 'BAPI_BUPA_ROLES_GET'
    EXPORTING
      businesspartner      = fp_partner
    TABLES
      businesspartnerroles = li_roles
      return               = li_return.
  READ TABLE li_roles INTO lst_roles WITH KEY partnerrole = c_ism000.
*--*If Existing BP doesn't match with sales role then continue the search
  IF sy-subrc NE 0.
    st_create-gen_data = c_i.
  ELSE.
*--*Check BP relationships to AGU
    PERFORM f_find_bp_relationships USING fp_partner.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILE_DATA_VALIDATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_file_data_validation .
  DATA : li_input_tmp LIKE i_input,
         lv_len       TYPE i,
         lv_error     TYPE c.
  CONSTANTS : lc_jpn TYPE land1 VALUE 'JPN'.
  LOOP AT i_input INTO DATA(lst_input).
*--*BOC ERPM-3369 ED2K918028 Prabhu 5/5/2020
    CLEAR : lv_error.
*"----------------------------------------------------------------------
*-----Makesure Indicator is available in the file
*"----------------------------------------------------------------------
    IF lst_input-indicator IS INITIAL.
      st_output-msg_type = c_e.
      st_output-msg_number = text-e15.
      st_output-message = text-015.
      MOVE-CORRESPONDING lst_input TO st_output.
      APPEND st_output TO i_out_ret.
      CLEAR : st_output.
      CONTINUE.
    ENDIF.
*"----------------------------------------------------------------------
*-----Validate Email address
*"----------------------------------------------------------------------
    CASE lst_input-indicator.
      WHEN c_new.
        PERFORM f_email_validation USING lst_input
                                   CHANGING lv_error.

        IF lv_error = abap_true.
          CONTINUE.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
*"----------------------------------------------------------------------
*-----BP Id number check
*"----------------------------------------------------------------------
    CASE lst_input-indicator.
      WHEN c_new OR c_coa.

        PERFORM f_memberid_validation USING lst_input
                                      CHANGING lv_error.
        IF lv_error = abap_true.
          CONTINUE.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
*"----------------------------------------------------------------------
*-----Required address details
*"----------------------------------------------------------------------
*--*BOC ERPM-10797 ED2K917990 Prabhu 4/15/2020
    CASE lst_input-indicator.
      WHEN c_new OR c_coa.
        PERFORM f_address_validation USING lst_input
                                     CHANGING lv_error.
        IF lv_error = abap_true.
          CONTINUE.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
*--*EOC ERPM-10797 ED2K917990 Prabhu 4/15/2020
*"----------------------------------------------------------------------
*-----Relationship type
*"----------------------------------------------------------------------
    CASE lst_input-indicator.
      WHEN c_new.
        PERFORM f_reltyp_validation USING lst_input
                                     CHANGING lv_error.
        IF lv_error = abap_true.
          CONTINUE.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
*--*EOC ERPM-3369 ED2K918028 Prabhu 5/5/2020
*"----------------------------------------------------------------------
*----Postal code update for Japan
*"----------------------------------------------------------------------
    IF lst_input-country = lc_jpn.
      lv_len = strlen( lst_input-postl_cod1 ).
      IF lv_len EQ 7.
        lst_input-postl_cod1+7(1) = lst_input-postl_cod1+6(1).
        lst_input-postl_cod1+6(1) = lst_input-postl_cod1+5(1).
        lst_input-postl_cod1+5(1) = lst_input-postl_cod1+4(1).
        lst_input-postl_cod1+3(1) = '-'.
      ENDIF.
    ENDIF.

    APPEND lst_input TO li_input_tmp.
*"----------------------------------------------------------------------
*-----Build country and title Range tables
*"----------------------------------------------------------------------
    st_country-low = lst_input-country.
    st_country-option = c_eq.
    st_country-sign = c_i.
    APPEND st_country TO i_country.
    lsr_title-low = lst_input-title.
    lsr_title-option = c_eq.
    lsr_title-sign = c_i.
    APPEND lsr_title TO i_title.
    CONCATENATE lsr_title-low c_title_dot INTO lsr_title-low.
    APPEND lsr_title TO i_title.
    CLEAR : st_country,lsr_title,lst_input.
  ENDLOOP.
  IF i_country IS NOT INITIAL.
    SORT i_country BY low.
    DELETE ADJACENT DUPLICATES FROM i_country COMPARING low.
  ENDIF.
  IF i_title IS NOT INITIAL.
    SORT i_title BY low.
    DELETE ADJACENT DUPLICATES FROM i_title COMPARING low.
    DELETE i_title WHERE low IS INITIAL.
  ENDIF.
*"----------------------------------------------------------------------
*----Filter Error records and keep valid
*"----------------------------------------------------------------------
  i_input[] = li_input_tmp[].
*--*Append error records
  APPEND LINES OF i_out_ret TO i_output.
  CLEAR : i_out_ret.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_GLOBAL_V_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_global_v_2 .
  CLEAR : i_bp_input,st_create, st_bp_input,v_bp, v_error,st_bp_coa.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_SEARCH_3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_LI_PARTNER  text
*----------------------------------------------------------------------*
FORM f_bp_search_3 TABLES fp_li_partner STRUCTURE  bus_partner_guid.
  DATA : lst_partner LIKE LINE OF fp_li_partner,
         lv_name1    TYPE bu_mcname1,
         lv_name2    TYPE bu_mcname2,
         li_result   TYPE STANDARD TABLE OF bus020_search_result,
         lst_address TYPE bupa_addr_search,
         lst_result  TYPE bus020_search_result,
         li_return   TYPE STANDARD TABLE OF bapiret2,
         lst_return  TYPE bapiret2,
         lv_lines    TYPE i.
*--*First search Email + First name + Last name +Street
  lst_address-street =  st_input-street.
  lv_name1 = st_input-lastname.
  lv_name2 = st_input-firstname.
  CALL FUNCTION 'BUPA_SEARCH_2'
    EXPORTING
*     IV_TELEPHONE     =
*     iv_email         = lv_email
      is_address       = lst_address
      iv_mc_name1      = lv_name1
      iv_mc_name2      = lv_name2
*     IV_VALID_DATE    = SY-DATLO
      iv_req_mask      = abap_true
    TABLES
      et_search_result = li_result
      et_return        = li_return.
*--*Search Result
  DESCRIBE TABLE li_result LINES lv_lines.
*--*If single BP found
  IF lv_lines = 1.
    CLEAR : lst_result.
    READ TABLE li_result INTO lst_result INDEX 1.
*--*Check Partner roles
    IF sy-subrc EQ 0.
      v_bp = lst_result-partner.
      PERFORM f_check_bp_roles_single USING lst_result-partner.
      lst_partner-partner = lst_result-partner.
      APPEND lst_partner TO fp_li_partner.
      CLEAR: lst_partner.
    ENDIF.
  ELSEIF lv_lines GT 1.
    LOOP AT li_result INTO lst_result.
*--*Check one by one BP roles
      PERFORM f_check_bp_roles_multiple USING lst_result-partner.
      IF st_create IS NOT INITIAL.
        EXIT.
      ENDIF.
    ENDLOOP.
*--*If valid partner exists update it
    IF st_create-gen_data NE c_i.
      v_bp = lst_result-partner.
      lst_partner-partner = lst_result-partner.
      APPEND lst_partner TO fp_li_partner.
      CLEAR: lst_partner.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_EMAIL_VALIDATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_INPUT  text
*      <--P_LV_ERROR  text
*----------------------------------------------------------------------*
FORM f_email_validation  USING    fp_lst_input TYPE zsqtc_bp_input_i0368
                         CHANGING fp_lv_error TYPE c.
  IF fp_lst_input-e_mail IS INITIAL.
    st_output-msg_type = c_e.
    st_output-msg_number = text-e01.
    st_output-message = text-001.
    MOVE-CORRESPONDING fp_lst_input TO st_output.
    APPEND st_output TO i_out_ret.
    CLEAR : st_output.
    fp_lv_error = abap_true.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MEMBERID_VALIDATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_INPUT  text
*      <--P_LV_ERROR  text
*----------------------------------------------------------------------*
FORM f_memberid_validation  USING   fp_lst_input TYPE zsqtc_bp_input_i0368
                            CHANGING fp_lv_error TYPE c.
  IF fp_lst_input-id_number IS INITIAL.
    st_output-msg_type = c_e.
    st_output-msg_number = text-e02.
    st_output-message = text-002.
    MOVE-CORRESPONDING fp_lst_input TO st_output.
    APPEND st_output TO i_out_ret.
    CLEAR : st_output.
    fp_lv_error = abap_true.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADDRESS_VALIDATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_INPUT  text
*      <--P_LV_ERROR  text
*----------------------------------------------------------------------*
FORM f_address_validation  USING    fp_lst_input TYPE zsqtc_bp_input_i0368
                           CHANGING fp_lv_error TYPE c.
  IF fp_lst_input-street IS INITIAL OR fp_lst_input-city IS INITIAL OR
*     lst_input-postl_cod1 IS INITIAL OR lst_input-country IS INITIAL .
       fp_lst_input-country IS INITIAL .
    st_output-msg_type = c_e.
    st_output-msg_number = text-e03.
    st_output-message = text-003.
    MOVE-CORRESPONDING fp_lst_input TO st_output.
    APPEND st_output TO i_out_ret.
    CLEAR : st_output.
    fp_lv_error =  abap_true.
  ENDIF.
*--*Postal code validation skip for certain countries maintained in Constant table
  IF fp_lst_input-postl_cod1 IS INITIAL.
    IF fp_lst_input-country IN lir_ctry_postal.
*       DO nothing - no validation required
    ELSE.
      st_output-msg_type = c_e.
      st_output-msg_number = text-e03.
      st_output-message = text-003.
      MOVE-CORRESPONDING fp_lst_input TO st_output.
      APPEND st_output TO i_out_ret.
      CLEAR : st_output.
      fp_lv_error =  abap_true.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_RELTYP_VALIDATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_INPUT  text
*      <--P_LV_ERROR  text
*----------------------------------------------------------------------*
FORM f_reltyp_validation  USING    fp_lst_input TYPE zsqtc_bp_input_i0368
                          CHANGING fp_lv_error TYPE c.
  IF fp_lst_input-reltyp IS INITIAL.
    st_output-msg_type = c_e.
    st_output-msg_number = text-e04.
    st_output-message = text-004.
    MOVE-CORRESPONDING fp_lst_input TO st_output.
    APPEND st_output TO i_out_ret.
    CLEAR : st_output.
    fp_lv_error =  abap_true.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_COA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_INPUT  text
*----------------------------------------------------------------------*
FORM f_bp_coa  USING  fp_st_input TYPE zsqtc_bp_input_i0368.

  DATA : lv_error TYPE c.
*--* Validate Member ID, find relavent BP
  PERFORM f_check_memberid USING fp_st_input
                           CHANGING lv_error.
  IF lv_error IS INITIAL.
*--* Map COA filed to BAPI
    PERFORM f_map_coa_fileds USING fp_st_input.
*--*Use only update
    st_create-gen_data = c_u.
*--*Call FM to update address
    PERFORM f_call_bp_update_fm.
  ENDIF.
*--*Capture return messages
  PERFORM f_map_output_return.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_MEMBERID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_ST_INPUT  text
*----------------------------------------------------------------------*
FORM f_check_memberid  USING   fp_st_input TYPE zsqtc_bp_input_i0368
                       CHANGING fp_lv_error TYPE c.
  DATA : lv_id      TYPE bu_id_number,
         lv_cat     TYPE bu_id_category VALUE 'ZMEMID',
         li_partner TYPE STANDARD TABLE OF bus_partner_guid,
         li_return  TYPE STANDARD TABLE OF bapiret2,
         lv_lines   TYPE i.
*--*Get BP by it's member ID
  lv_id = fp_st_input-id_number.
  CALL FUNCTION 'BUPA_PARTNER_GET_BY_IDNUMBER'
    EXPORTING
      iv_identificationcategory = lv_cat
      iv_identificationnumber   = lv_id
    TABLES
      t_partner_guid            = li_partner
      et_return                 = li_return.
  DESCRIBE TABLE li_partner LINES lv_lines.
  CASE lv_lines.
*--*Consider the BP when number of lines eq 1
    WHEN 1.
      READ TABLE li_partner INTO st_bp_coa INDEX 1.
      IF sy-subrc EQ 0.
        v_bp = st_bp_coa-partner.
      ENDIF.
    WHEN 0.
*--*Error if there is no BP for input value
      st_output-msg_type = c_e.
      st_output-msg_number = text-e13.
      st_output-message = text-013.
      MOVE-CORRESPONDING fp_st_input TO st_output.
      APPEND st_output TO i_out_ret.
      CLEAR : st_output.
      fp_lv_error = abap_true.
    WHEN OTHERS.
*--*Error if multiple BP found
      LOOP AT li_partner INTO DATA(lst_partner).
        CONCATENATE st_output-message lst_partner-partner INTO st_output-message SEPARATED BY space.
      ENDLOOP.
      st_output-msg_type = c_e.
      st_output-msg_number = text-e14.
      CONCATENATE text-014 st_output-message INTO st_output-message SEPARATED BY space.
      MOVE-CORRESPONDING fp_st_input TO st_output.
      APPEND st_output TO i_out_ret.
      CLEAR : st_output.
      fp_lv_error = abap_true.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_COA_FILEDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_ST_INPUT  text
*----------------------------------------------------------------------*
FORM f_map_coa_fileds  USING  fp_st_input TYPE zsqtc_bp_input_i0368.
  DATA : lst_tsad3t    LIKE LINE OF i_tsad3t,
         li_addresses  TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-address-addresses,
         lst_addresses LIKE LINE OF li_addresses,
         li_phone      TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-communication-phone-phone,
         lst_phone     LIKE LINE OF li_phone,
         li_tel        TYPE STANDARD TABLE OF bapiadtel.
  st_bp_input-general_data-gen_data-header-object_instance-bpartner = v_bp.
  st_bp_input-general_data-gen_data-header-object_instance-bpartnerguid = st_bp_coa-partner_guid.
*--* Title conversion
  IF fp_st_input-title IS NOT INITIAL.
    READ TABLE i_tsad3t INTO lst_tsad3t WITH KEY langu = sy-langu
                                                      title_medi = fp_st_input-title
                                                      BINARY SEARCH.
    IF sy-subrc NE 0.
      CONCATENATE fp_st_input-title c_title_dot INTO fp_st_input-title.
      READ TABLE i_tsad3t INTO lst_tsad3t WITH KEY langu = sy-langu
                                                        title_medi = fp_st_input-title
                                                        BINARY SEARCH.
    ENDIF.
    IF lst_tsad3t-title IS NOT INITIAL.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-title_key = lst_tsad3t-title.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-title_key = abap_true.
    ENDIF.
  ENDIF.

  IF fp_st_input-street IS NOT INITIAL.
    lst_addresses-data-postal-data-street = fp_st_input-street.
    lst_addresses-data-postal-datax-street = abap_true.
  ENDIF.
  IF fp_st_input-dept IS NOT INITIAL.
    lst_addresses-data-postal-data-str_suppl1 = fp_st_input-dept.
    lst_addresses-data-postal-datax-str_suppl1 = abap_true.
  ENDIF.
  IF fp_st_input-org IS NOT INITIAL.
    lst_addresses-data-postal-data-str_suppl2 = fp_st_input-org.
    lst_addresses-data-postal-datax-str_suppl2 = abap_true..
  ENDIF.
  IF fp_st_input-street_line2 IS NOT INITIAL.
    lst_addresses-data-postal-data-str_suppl3 = fp_st_input-street_line2.
    lst_addresses-data-postal-datax-str_suppl3 = abap_true.
  ENDIF.
  IF fp_st_input-street_line3 IS NOT INITIAL.
    lst_addresses-data-postal-data-location = fp_st_input-street_line3.
    lst_addresses-data-postal-datax-location = abap_true.
  ENDIF.
  IF fp_st_input-city IS NOT INITIAL.
    lst_addresses-data-postal-data-city = fp_st_input-city.
    lst_addresses-data-postal-datax-city = abap_true..
  ENDIF.
  IF fp_st_input-postl_cod1 IS NOT INITIAL.
    lst_addresses-data-postal-data-postl_cod1 = fp_st_input-postl_cod1.
    lst_addresses-data-postal-datax-postl_cod1 = abap_true.
    st_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-searchterm2 = fp_st_input-postl_cod1.
    st_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-searchterm2 = abap_true.
  ENDIF.
  IF fp_st_input-region IS NOT INITIAL.
    lst_addresses-data-postal-data-region = fp_st_input-region.
    lst_addresses-data-postal-datax-region = abap_true.
  ENDIF.
  IF  fp_st_input-country IS NOT INITIAL.
    READ TABLE i_t005 INTO DATA(lst_t005) WITH KEY intca3 = fp_st_input-country
                                                         BINARY SEARCH.
    IF lst_t005-land1 IS NOT INITIAL.
      lst_addresses-data-postal-data-country = lst_t005-land1.
      lst_addresses-data-postal-datax-country = abap_true.
    ENDIF.
  ENDIF.
  IF fp_st_input-telephone IS NOT INITIAL.
    CALL FUNCTION 'BAPI_BUPA_ADDRESS_GETDETAIL'
      EXPORTING
        businesspartner = v_bp
      TABLES
        bapiadtel       = li_tel.

    lst_phone-contact-task = c_m.
    lst_phone-contact-data-telephone = fp_st_input-telephone.
    lst_phone-contact-datax-telephone = abap_true.
    READ TABLE li_tel INTO DATA(lst_tel) INDEX 1.
    IF sy-subrc EQ 0 AND lst_tel-telephone  IS NOT INITIAL.
      lst_phone-contact-datax-updateflag = c_u.
    ELSE.
      lst_phone-contact-datax-updateflag = c_i.
    ENDIF.
    APPEND lst_phone TO li_phone.
    CLEAR lst_phone.
    lst_addresses-data-communication-phone-phone = li_phone[].
    CLEAR : li_phone[].
  ENDIF.
  IF lst_addresses IS NOT INITIAL.
    APPEND lst_addresses TO li_addresses.
    CLEAR : lst_addresses.
    st_bp_input-general_data-gen_data-central_data-address-addresses[] = li_addresses[].
    APPEND st_bp_input TO i_bp_input.
    CLEAR : st_bp_input.
    CLEAR : li_addresses[].
  ENDIF.

ENDFORM.
