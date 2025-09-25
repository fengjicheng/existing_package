*----------------------------------------------------------------------*
***INCLUDE LZQTC_FG_BP_INTERFACE_AGUF03.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:LZQTC_FG_BP_INTERFACE_AGUF03 (INCLUDE)
* PROGRAM DESCRIPTION: Create BP with Comapny Code data,Sales Data,
*                      Collection & Credit management data
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE: 12/10/2019
* OBJECT ID:     E225/ERPM-2334
* TRANSPORT NUMBER(S):ED2K916061
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918959
* REFERENCE NO: ERPM-22299
* DEVELOPER:  Lahiru Wathudura(LWATHUDURA)
* WRICEF ID : E225/I0387
* DATE: 07/22/2020
* DESCRIPTION:  Extend the BP search functionality considering
*               the Input source as RPA and IF source is RPA avoid the BP Creation
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K921898
* REFERENCE NO: OTCM-38772
* DEVELOPER: Prabhu(PTUFARAM)
* WRICEF ID : E225
* DATE: 02/16/2021
* DESCRIPTION:  Additioon of SG BP validation*
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_GLOBAL_V3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_global_v3 .

  CLEAR : i_staging,i_file,st_staging,st_bp_rules,v_source,v_bp,v_error,
          i_search_result,i_bsid,st_bsid,i_but_bp,st_but_bp,li_constant,
          li_constant,i_sale_ref,i_t001,i_ukm_kkber2,i_def_credit,i_risk_check,i_cust_grp,
          i_coll,i_tsad3t,i_out_ret,i_t001cm,st_t001cm,lir_parvw,lir_fte,lir_ctry_comp,
          lir_ctry_e184,lir_rel_type,i_t005,v_indirect.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_BP_RULES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_bp_rules.
*--*Get BP rules
  IF st_bp_rules IS INITIAL.
    SELECT SINGLE * FROM zqtc_bp_rules INTO st_bp_rules WHERE source = v_source.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_GLOBAL_V4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_global_v4 .
  CLEAR : i_search_result,v_error,st_create,i_bp_input,i_bp_return,v_cust_string,
          v_bp,v_bp_country,v_society.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_BP_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IM_SOURCE  text
*----------------------------------------------------------------------*
FORM f_get_bp_constants  USING fp_source TYPE tpm_source_name
                               fp_dev_id  TYPE zdevid.
*  Local constant declaration
  CONSTANTS: lc_dev_id_e184      TYPE zdevid VALUE 'E184',
             lc_comm_method      TYPE rvari_vnam VALUE 'COMM_METHOD',
             lc_bu_group         TYPE rvari_vnam VALUE 'BU_GROUP',
             lc_bu_cat           TYPE rvari_vnam VALUE 'BU_CAT',
             lc_bp_role          TYPE rvari_vnam VALUE 'BP_ROLE',
             lc_tax_num          TYPE rvari_vnam VALUE 'TAX_NUM',
             lc_tax_id_type      TYPE rvari_vnam VALUE 'TAX_ID_TYPE',
             lc_bu_id_type       TYPE rvari_vnam VALUE 'BU_ID_TYPE',
             lc_cust_attr6       TYPE rvari_vnam VALUE 'CUST_ATTR6',
             lc_recon_account    TYPE rvari_vnam VALUE 'RECON_ACCOUNT',
             lc_payment_terms    TYPE rvari_vnam VALUE 'PAYMENT_TERMS',
             lc_cust_pay_hist    TYPE rvari_vnam VALUE 'CUST_PAY_HIST',
             lc_dunning_proc     TYPE rvari_vnam VALUE 'DUNNING_PROC',
             lc_bank_statment    TYPE rvari_vnam VALUE 'BANK_STATEMENT',
             lc_valid_end        TYPE rvari_vnam VALUE 'VALID_END',
             lc_vtweg            TYPE rvari_vnam VALUE 'VTWEG',
             lc_spart            TYPE rvari_vnam VALUE 'SPART',
             lc_cust_grp         TYPE rvari_vnam VALUE 'CUST_GRP',
             lc_prcing_proc      TYPE rvari_vnam VALUE 'PRICING_PROC',
             lc_cust_stat_grp    TYPE rvari_vnam VALUE 'CUST_STAT_GRP',
             lc_del_priority     TYPE rvari_vnam VALUE 'DEL_PRIORITY',
             lc_shipping_cond    TYPE rvari_vnam VALUE 'SHIPPING_COND',
             lc_inco1            TYPE rvari_vnam VALUE 'INCO1',
             lc_inco2            TYPE rvari_vnam VALUE 'INCO2',
             lc_account_ass      TYPE rvari_vnam VALUE 'ACCOUNT_ASS_GRP',
             lc_tax_classi       TYPE rvari_vnam VALUE 'TAX_CLASSI',
             lc_parvw            TYPE rvari_vnam VALUE 'PARVW',
             lc_spras            TYPE rvari_vnam VALUE 'SPRAS',
             lc_cust_grp1        TYPE rvari_vnam VALUE 'CUST_GRP1',
             lc_coll_profile     TYPE rvari_vnam VALUE 'COLL_PROFILE',
             lc_credit_grp       TYPE  rvari_vnam VALUE  'CREDIT_GROUP',
             lc_agu              TYPE rvari_vnam VALUE 'AGU',
             lc_ktokd            TYPE rvari_vnam VALUE 'CUST_ACCT_GRP',
             lc_tatyp            TYPE rvari_vnam VALUE 'TAX_CAT',
             lc_agu_cust         TYPE rvari_vnam VALUE 'AGU_CUST',
             lc_coll_seg         TYPE rvari_vnam VALUE 'COLL_SEGMENT',
             lc_fte              TYPE rvari_vnam VALUE 'FTE',
             lc_sort_key         TYPE rvari_vnam VALUE 'SORT_KEY',
             lc_comp_code_e184   TYPE rvari_vnam VALUE 'COMP_CODE',
             lc_country_e184     TYPE rvari_vnam VALUE 'COUNTRY',
             lc_country          TYPE rvari_vnam VALUE 'COUNTRY',
             lc_society          TYPE rvari_vnam VALUE 'SOCIETY',
             lc_sales_org_shipto TYPE rvari_vnam VALUE 'SALES_ORG_SHIPTO'.
  DATA:      lst_zcaconstant TYPE ty_constant.
  CLEAR : lsr_comm_type,lsr_bu_group,lsr_bu_type,lsr_rel_type,lsr_bptaxnum,lsr_taxtype,
          lsr_katr6,lsr_akont,lsr_zterm,lsr_xzver,lsr_mahna,lsr_end_date,lsr_vtweg,
          lsr_spart,lsr_kdgrp,lsr_kalks,lsr_vrseg,lsr_lprio,lsr_vsbed,lsr_inco1,lsr_inco2,
          lsr_kvgr1,lsr_spras,lsr_coll_profile,lsr_tatyp,lsr_agu,lir_coll_seg,lsr_sort_key.
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
          INTO TABLE @li_constant  WHERE ( devid = @fp_dev_id OR devid = @lc_dev_id_e184 )
                                    AND  activate = @abap_true.
  IF sy-subrc EQ 0.
    SORT li_constant BY param1.
    "Get data from zcaconstant table
    LOOP AT li_constant INTO lst_zcaconstant.
*      IF lst_zcaconstant-param2 = lc_agu.
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
          IF lst_zcaconstant-param2 = lc_society.
            lsr_parvw-sign = lst_zcaconstant-sign.
            lsr_parvw-option = lst_zcaconstant-opti.
            lsr_parvw-low = lst_zcaconstant-low.
            lsr_parvw-high = lst_zcaconstant-high.
            APPEND lsr_parvw TO lir_parvw.
            CLEAR : lsr_parvw.
          ENDIF.
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
        WHEN lc_country.
          IF lst_zcaconstant-param2 = lc_society.
            APPEND INITIAL LINE TO lir_country ASSIGNING FIELD-SYMBOL(<lsf_country>).
            <lsf_country>-sign = lst_zcaconstant-sign.
            <lsf_country>-option = lst_zcaconstant-opti.
            <lsf_country>-low = lst_zcaconstant-low.
            <lsf_country>-high = lst_zcaconstant-high.
          ENDIF.
*--*Append E184 entries
        WHEN lc_comp_code_e184.
          IF lst_zcaconstant-param2 = lc_country_e184.
            APPEND INITIAL LINE TO lir_ctry_comp ASSIGNING FIELD-SYMBOL(<lsf_comp_code>).
            <lsf_comp_code>-sign   = lst_zcaconstant-sign.
            <lsf_comp_code>-option = lst_zcaconstant-opti.
            <lsf_comp_code>-low    = lst_zcaconstant-low.
            <lsf_comp_code>-high   = lst_zcaconstant-high.
            APPEND INITIAL LINE TO lir_ctry_e184 ASSIGNING FIELD-SYMBOL(<lsf_ctry>).
            <lsf_ctry>-sign   = lst_zcaconstant-sign.
            <lsf_ctry>-option = lst_zcaconstant-opti.
            <lsf_ctry>-low    = lst_zcaconstant-high.
          ENDIF.
        WHEN lc_sales_org_shipto.
          lsr_sales_org_ship-sign = lst_zcaconstant-sign.
          lsr_sales_org_ship-option = lst_zcaconstant-opti.
          lsr_sales_org_ship-salesorg_low = lst_zcaconstant-low.
          lsr_sales_org_ship-salesorg_high = lst_zcaconstant-high.
          APPEND lsr_sales_org_ship TO lir_sales_org_ship.
          CLEAR lsr_sales_org_ship.
        WHEN OTHERS.
      ENDCASE.
*      ENDIF.
    ENDLOOP.
  ENDIF.
*&---------------------------------------------------------------------*
*&     BP rules - CR7463 I0200 required constants
*&---------------------------------------------------------------------*
  IF st_bp_rules-map7_cr7463 = abap_true.
    PERFORM f_get_constants_i0200.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEARCH_BP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_SEARCH_RESULT  text
*      -->P_ST_FILE_NAME_F  text
*      -->P_ST_FILE_NAME_L  text
*      -->P_ST_FILE_MPTP_ADDR  text
*      -->P_ST_FILE_STREET  text
*----------------------------------------------------------------------*
FORM f_search_bp  TABLES   fp_i_search_result STRUCTURE bus020_search_result
                  USING    fp_name_f TYPE bu_namep_f
                           fp_name_l TYPE bu_namep_l
                           fp_email TYPE ad_smtpadr
                           fp_street TYPE ad_street.
  DATA : li_return   TYPE STANDARD TABLE OF bapiret2,
         lv_email    TYPE ad_smtpadr,
         lst_address TYPE bupa_addr_search,
         lv_name1    TYPE bu_mcname1,
         lv_name2    TYPE bu_mcname2.
*--*First search Email + First name + Last name +Street
  lv_email = fp_email.
  lst_address-street = fp_street.
  lv_name1 = fp_name_l.
  lv_name2 = fp_name_f.
  CALL FUNCTION 'BUPA_SEARCH_2'
    EXPORTING
      iv_email         = lv_email
      is_address       = lst_address
      iv_mc_name1      = lv_name1
      iv_mc_name2      = lv_name2
      iv_req_mask      = abap_true
    TABLES
      et_search_result = fp_i_search_result
      et_return        = li_return.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_ROLE_SINGLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_SEARCH_RESULT_PARTNER  text
*----------------------------------------------------------------------*
FORM f_bp_role_single  USING fp_partner TYPE bu_partner.
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
    st_create-gen_data = c_i.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_BLOCKS_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_BP  text
*      <--P_V_ERROR  text
*----------------------------------------------------------------------*
FORM f_bp_blocks_check  USING    fp_partner TYPE bu_partner
                                 fp_vkorg TYPE vkorg
                                 fp_vtweg TYPE vtweg
                                 fp_spart TYPE spart
                        CHANGING fp_v_error TYPE c.
  TYPES : BEGIN OF lty_knvv_flags,
            kunnr TYPE kunnr,
            aufsd TYPE aufsd,
          END OF lty_knvv_flags.
  DATA : lst_knvv TYPE  lty_knvv_flags,
         lv_kunnr TYPE kunnr.
  CLEAR : lst_knvv.
  SELECT SINGLE kunnr,aufsd FROM knvv INTO @lst_knvv  WHERE kunnr = @fp_partner
                                                 AND vkorg = @fp_vkorg
                                                 AND vtweg = @fp_vtweg
                                                 AND spart = @fp_spart.
  IF sy-subrc EQ 0 AND lst_knvv-aufsd IS NOT INITIAL.
    fp_v_error = abap_true.
  ELSE.
    SELECT SINGLE partner FROM but000 INTO @lv_kunnr WHERE partner = @fp_partner
                                                     AND ( xdele EQ @abap_true
                                                     OR xblck EQ @abap_true ).
    IF sy-subrc EQ 0.
      fp_v_error = abap_true.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_COMPANY_CODE_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_FILE_VKORG  text
*      -->P_V_BP  text
*----------------------------------------------------------------------*
FORM f_bp_company_code_check  USING    fp_vkorg TYPE vkorg
                                       fp_partner TYPE bu_partner.
  DATA : lv_kunnr TYPE kunnr.
*--*Check company code extension
  SELECT SINGLE kunnr FROM knb1 INTO @lv_kunnr WHERE  kunnr = @fp_partner
                                               AND  bukrs = @fp_vkorg.
  IF sy-subrc NE 0.
    st_create-comp_data = abap_true.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_COMPANY_CODE_IND_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_FILE_VKORG  text
*      -->P_ST_FILE_COUNTRY  text
*      -->P_V_BP  text
*      <--P_V_ERROR  text
*----------------------------------------------------------------------*
FORM f_bp_compcode_sales_ind_au_chk  USING fp_v_partner TYPE bu_partner
                                           fp_st_file TYPE zsqtc_bp_update
                                  CHANGING fp_v_error TYPE c
                                           fp_err_type TYPE char2.
  DATA : lv_shipto_check TYPE c.
*--*Exclude Check for Shipto of Society
  IF st_bp_rules-check16_shipto_au_in = abap_true." AND v_bp IS NOT INITIAL.
    PERFORM f_check_shipto_salesorg  USING fp_st_file
                                     CHANGING lv_shipto_check.
  ENDIF.
  IF lv_shipto_check IS INITIAL.
*--*BOC OTCM-38772 By Prabhu on 2/19/2021 ED2K921898
    IF fp_v_partner IS NOT INITIAL.
      "Get BP Country when BP present in file
      CLEAR v_bp_country.
      SELECT SINGLE land1 FROM kna1 INTO @v_bp_country WHERE kunnr = @fp_v_partner.
    ENDIF.
*--*Check file country is listed in E184 constants
    IF fp_st_file-country IN lir_ctry_e184 OR
       ( v_bp_country IS NOT INITIAL AND v_bp_country IN lir_ctry_e184 ).
*--*Check sales org and country combination maintained inE184 constants
      IF fp_st_file-country IS INITIAL.
       fp_st_file-country = v_bp_country.
      ENDIF.
*--*EOC OTCM-38772 By Prabhu on 2/19/2021 ED2K921898
      READ TABLE lir_ctry_comp INTO DATA(lsr_cntry_e184) WITH KEY  low = fp_st_file-vkorg
                                                                   high = fp_st_file-country.
      IF sy-subrc NE 0.
        fp_v_error = abap_true.
        IF fp_st_file-country = c_au.
          IF fp_v_partner IS NOT INITIAL.
            fp_err_type = c_au.
          ELSE.
            fp_err_type = c_au_file. "file validation
          ENDIF.
        ENDIF.
        IF fp_st_file-country = c_in.
          IF fp_v_partner IS NOT INITIAL.
            fp_err_type = c_in.
          ELSE.
            fp_err_type = c_in_file. " file validation
          ENDIF.
        ENDIF.
*--* BOC OTCM-38772 By Prabhu on 2/14/2021 ED2K921898
*--* Add validation for other new countries - Future addition
        IF fp_err_type IS INITIAL.
          IF fp_v_partner IS NOT INITIAL.
            fp_err_type = c_new_country .
          ELSE.
            fp_err_type = c_new_country_file. " file validation
          ENDIF.
        ENDIF.
*--*EOC OTCM-38772 By Prabhu on 2/14/2021 ED2K921898
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_SALES_AREA_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_FILE_VKORG  text
*      -->P_ST_FILE_VTWEG  text
*      -->P_ST_FILE_SPART  text
*      -->P_V_BP  text
*----------------------------------------------------------------------*
FORM f_bp_sales_area_check  USING    fp_vkorg TYPE vkorg
                                     fp_vtweg TYPE vtweg
                                     fp_spart TYPE spart
                                     fp_partner TYPE bu_partner.
  DATA : lv_kunnr TYPE kunnr.
*--* Check sales area extension
  SELECT SINGLE kunnr FROM knvv INTO @lv_kunnr WHERE kunnr = @fp_partner
                                                AND vkorg = @fp_vkorg
                                                AND vtweg = @fp_vtweg
                                                AND spart = @fp_spart.
*--*When sales area get extended, extend credit and collection data
  IF sy-subrc NE 0.
    IF st_bp_rules-map1_sales_data_map IS NOT INITIAL.
      st_create-sales_data = abap_true.
    ENDIF.
    IF st_bp_rules-map3_credit_data_map IS NOT INITIAL.
      st_create-credit = abap_true.
    ENDIF.
    IF st_bp_rules-map4_coll_data_map IS NOT INITIAL.
      st_create-collection = abap_true.
    ENDIF.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_BP_ROLE_MULTIPLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_SEARCH_RESULT  text
*      <--P_V_ERROR  text
*----------------------------------------------------------------------*
FORM f_bp_role_multiple  TABLES   fp_i_search_result STRUCTURE bus020_search_result
                         USING    fp_vkorg TYPE vkorg
                                  fp_vtweg TYPE vtweg
                                  fp_spart TYPE spart
                         CHANGING fp_v_error TYPE c.
  DATA : li_return         TYPE STANDARD TABLE OF bapiret2,
         lst_return        TYPE bapiret2,
         lst_search_result TYPE bus020_search_result,
         li_roles          TYPE STANDARD TABLE OF bapibus1006_roles,
         lst_roles         TYPE bapibus1006_roles,
         lst_result_tmp    TYPE bus020_search_result,
         li_result_tmp     TYPE STANDARD TABLE OF bus020_search_result,
         lv_error          TYPE c,
         lv_status         TYPE  zprcstat.
*--*Check each BP sales role
  LOOP AT fp_i_search_result INTO lst_search_result.
    CLEAR : lv_error.
    CALL FUNCTION 'BAPI_BUPA_ROLES_GET'
      EXPORTING
        businesspartner      = lst_search_result-partner
      TABLES
        businesspartnerroles = li_roles
        return               = li_return.
    READ TABLE li_roles INTO lst_roles WITH KEY partnerrole = c_ism000.
    IF sy-subrc EQ 0.
*--*If sales role exist check sales block
      PERFORM f_bp_blocks_check USING lst_search_result-partner fp_vkorg fp_vtweg fp_spart
                                CHANGING lv_error..
*--*If there is no block then proceed further processing
      IF lv_error IS INITIAL .
        lst_result_tmp = lst_search_result.
        APPEND lst_result_tmp TO li_result_tmp.
        CLEAR lst_result_tmp.
      ELSE.
*--*If sales block exist throw an error
        fp_v_error = lv_error.
        CONCATENATE v_cust_string lst_search_result-partner INTO v_cust_string SEPARATED BY space.
      ENDIF.
    ENDIF.
  ENDLOOP.
*--*Filter BP after sales role and salesblocks check
  fp_i_search_result[] = li_result_tmp[].

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_ARDATA_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_SEARCH_RESULT  text
*----------------------------------------------------------------------*
FORM f_bp_ardata_check  TABLES  fp_i_search_result STRUCTURE bus020_search_result
                                fp_i_file STRUCTURE zsqtc_bp_update
                        USING fp_vkorg TYPE vkorg
                              fp_lv_index TYPE sy-tabix
                        CHANGING fp_v_error TYPE c
                                 fp_v_bp TYPE bu_partner.
  DATA: lv_bp_stat  TYPE zprcstat,
        lv_err_type TYPE char2.
  CLEAR : i_bsid,i_but_bp.
  IF fp_i_search_result[] IS NOT INITIAL.
*--*Get AR clear Items
    SELECT bukrs,
           kunnr,
           cpudt FROM bsad INTO TABLE @i_bsid
                    FOR ALL ENTRIES IN @fp_i_search_result WHERE bukrs = @fp_vkorg
                                                          AND kunnr = @fp_i_search_result-partner.
    IF sy-subrc NE 0.
*--*Get AR data Open Items
      SELECT bukrs,
             kunnr,
             cpudt FROM bsid INTO TABLE @i_bsid
                   FOR ALL ENTRIES IN @fp_i_search_result WHERE bukrs = @fp_vkorg
                                                         AND kunnr = @fp_i_search_result-partner.
    ENDIF.
    IF sy-subrc EQ 0.
*--* Consider latest BP when multiple BPs exist
      SORT i_bsid BY cpudt DESCENDING.
      READ TABLE i_bsid INTO st_bsid INDEX 1.
      IF sy-subrc EQ 0.
        fp_v_bp = st_bsid-kunnr.
      ENDIF.
    ENDIF.
*--*If there is no BP found with AR data look into BP master data
    IF fp_v_bp IS INITIAL.
      SELECT partner,
             crdat FROM but000 INTO TABLE @i_but_bp
                               FOR ALL ENTRIES IN @fp_i_search_result
                               WHERE partner = @fp_i_search_result-partner.
      IF sy-subrc EQ 0.
*--*Get oldest BP
        SORT i_but_bp BY crdat ASCENDING.
        READ TABLE i_but_bp INTO st_but_bp INDEX 1.
        IF sy-subrc EQ 0.
*--*Check if multiple BPs created on same date
          READ TABLE i_but_bp INTO DATA(lst_but_bp) INDEX 2.
          IF sy-subrc EQ 0 AND st_but_bp-crdat  = lst_but_bp-crdat.
            fp_v_error = abap_true.
*--*If multiple BP exists on same date throw an error
            CONCATENATE st_but_bp-partner lst_but_bp-partner INTO v_cust_string SEPARATED BY space.
          ELSE.
            fp_v_bp = st_but_bp-partner.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
*"----------------------------------------------------------------------
*----SLG Log update and Staging table update
*"----------------------------------------------------------------------
    IF fp_v_error IS NOT INITIAL.
      lv_err_type =  c_ar_but.
      PERFORM f_log_messages USING st_file lv_bp_stat fp_v_error lv_err_type.
*--*Modify out going table with message type and BP
      PERFORM f_update_input_file TABLES fp_i_file USING st_file fp_lv_index fp_v_bp fp_v_error.
*--* Single BP Found from BUT000 table
    ELSEIF fp_v_bp IS NOT INITIAL.
*"----------------------------------------------------------------------
*"----------------------------------------------------------------------
*-----BP Rules - Sales, Company code and Relationship Extensions
*"----------------------------------------------------------------------
      PERFORM f_bp_rules_comp_sales USING st_bp_rules fp_v_bp st_file
                                                 CHANGING fp_v_error.
*"---------------------------------------------------------------------
      IF fp_v_error IS NOT INITIAL.
*--*Modify out going table with message type and BP
        PERFORM f_update_input_file TABLES fp_i_file USING st_file fp_lv_index fp_v_bp fp_v_error.

      ELSE.
*"----------------------------------------------------------------------
*----Right BP found in ARDATA SLG Log update and Staging table update
*"----------------------------------------------------------------------
        lv_bp_stat = c_b4. "Inprogress BP Identified
        PERFORM f_log_messages USING st_file lv_bp_stat fp_v_error lv_err_type.
*--*Modify out going table with message type and BP
        PERFORM f_update_input_file TABLES fp_i_file USING st_file fp_lv_index fp_v_bp fp_v_error.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_RELATIONSHIP_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_BP  text
*      -->P_ST_FILE_PARTNER2  text
*      -->P_ST_FILE_RELTYP  text
*----------------------------------------------------------------------*
FORM f_relationship_check  USING    fp_partner TYPE bu_partner
                                    fp_partner2 TYPE bu_partner
                                    fp_st_file_reltyp TYPE bu_reltyp
                                    CHANGING fp_st_file TYPE zsqtc_bp_update.
  DATA : li_relation TYPE STANDARD TABLE OF bapibus1006_relations,
         li_return   TYPE STANDARD TABLE OF bapiret2,
         lv_year(4)  TYPE c,
         lv_lines    TYPE i.
  CLEAR : li_relation.
  CALL FUNCTION 'BUPA_RELATIONSHIPS_GET'
    EXPORTING
      iv_partner       = fp_partner
*     iv_relationship_category = fp_st_file_reltyp
      iv_req_mask      = 'X'
    TABLES
      et_relationships = li_relation
      et_return        = li_return.
  IF fp_partner IS NOT INITIAL.
    CLEAR : st_create-relation.
    PERFORM f_update_relations TABLES li_relation USING fp_partner fp_st_file.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_BP_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_FILE  text
*----------------------------------------------------------------------*
FORM f_map_bp_data  USING  fp_st_file TYPE zsqtc_bp_update.
  DATA : li_addresses       TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-address-addresses,
         lst_addresses      LIKE LINE OF li_addresses,
         li_phone           TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-communication-phone-phone,
         lst_phone          LIKE LINE OF li_phone,
         li_smtp            TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-communication-smtp-smtp,
         lst_smtp           LIKE LINE OF li_smtp,
         li_tax             TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-taxnumber-taxnumbers,
         lst_tax            LIKE LINE OF li_tax,
         li_relation        TYPE zstqtc_customer_date_input-relationship_data-relationships,
         lst_relation       LIKE LINE OF li_relation,
         li_role            TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-role-roles,
         lst_role           LIKE LINE OF li_role,
         li_comp_codes      TYPE zstqtc_customer_date_input-comp_code_data-comp_codes,
         lst_comp_codes     LIKE LINE OF li_comp_codes,
         li_dunning         TYPE cmds_ei_dunning_t,
         lst_dunning        LIKE LINE OF li_dunning,
         li_sales           TYPE zstqtc_customer_date_input-sales_data-sales_datas,
         lst_sales          LIKE LINE OF li_sales,
         li_functions       TYPE cmds_ei_functions_t,
         lst_functions      LIKE LINE OF li_functions,
         li_sales_tax       TYPE zstqtc_customer_date_input-general_data-add_gen_data-tax_ind-tax_ind,
         lst_sales_tax      LIKE LINE OF li_sales_tax,
         li_coll            TYPE zstqtc_customer_date_input-crdt_coll_data-collection_data-coll_segment,
         lst_coll           LIKE LINE OF li_coll,
         li_credit          TYPE zstqtc_customer_date_input-crdt_coll_data-credit_data-credit_segment,
         lst_credit         LIKE LINE OF li_credit,
         li_time            TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-common-time_dependent_data-common_data,
         lst_time           LIKE LINE OF li_time,
         li_id              TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-ident_number-ident_numbers,
         lst_id             LIKE LINE OF li_id,
         lv_date            TYPE sy-datum,
         lst_tsad3t         LIKE LINE OF i_tsad3t,
         lst_def_credit     LIKE LINE OF i_def_credit,
         lst_risk_check     LIKE LINE OF i_risk_check,
         lst_coll_prof      LIKE LINE OF i_coll,
         lst_coll_1001      LIKE LINE OF i_coll,
         lv_functions_built TYPE c.


  CLEAR : li_addresses,lst_addresses,li_phone,lst_phone,li_smtp,lst_smtp,li_tax,lst_tax,
          lst_relation,li_relation,li_role,lst_role,li_comp_codes,lst_comp_codes,
          li_dunning,lst_dunning,li_sales,lst_sales,li_functions,lst_functions,li_sales_tax,
          lst_sales_tax,li_coll,lst_coll,li_credit,lst_credit,li_time,lst_time,li_id,
          lst_id,lv_date,lst_tsad3t,lst_def_credit,lst_risk_check,lst_coll_1001,lst_coll_prof,
          lv_functions_built.
*"----------------------------------------------------------------------
*---Read Custom tables data.
*"----------------------------------------------------------------------
  SORT i_t005 BY land1.
  READ TABLE i_t005 INTO DATA(lst_t005) WITH KEY land1 = fp_st_file-country
                                                       BINARY SEARCH.
*--*Credit management
  READ TABLE i_sale_ref INTO DATA(lst_comp_sales) WITH KEY country_iso_code = lst_t005-intca3
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
                                                    regio = fp_st_file-region
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
                                                     regio = fp_st_file-region.
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
*  IF fp_st_file-title IS NOT INITIAL.
*    READ TABLE i_tsad3t INTO lst_tsad3t WITH KEY langu = sy-langu
*                                                      title_medi = fp_st_file-title
*                                                      BINARY SEARCH.
*    IF sy-subrc NE 0.
*      CONCATENATE fp_st_file-title c_title_dot INTO fp_st_file-title.
*      READ TABLE i_tsad3t INTO lst_tsad3t WITH KEY langu = sy-langu
*                                                        title_medi = fp_st_file-title
*                                                        BINARY SEARCH.
*    ENDIF.
*  ENDIF.
*"----------------------------------------------------------------------
*-----*General data mapping to BP structures
*"----------------------------------------------------------------------
  IF st_create-gen_data IS NOT INITIAL.
    IF st_file-bu_title IS NOT INITIAL.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-title_key = st_file-bu_title.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-title_key = abap_true.
    ELSE.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-title_key = lst_tsad3t-title.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-title_key = abap_true.
    ENDIF.
    IF fp_st_file-name_f IS NOT INITIAL.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_person-firstname = fp_st_file-name_f.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_person-firstname = abap_true.
    ENDIF.
    IF fp_st_file-name_l IS NOT INITIAL.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_person-lastname = fp_st_file-name_l.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_person-lastname = abap_true.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-searchterm1 = fp_st_file-name_l.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-searchterm1 = abap_true.
    ENDIF.

    IF fp_st_file-street IS NOT INITIAL.
      lst_addresses-data-postal-data-street = fp_st_file-street.
      lst_addresses-data-postal-datax-street = abap_true.
    ENDIF.
    IF fp_st_file-str_suppl1 IS NOT INITIAL.
      lst_addresses-data-postal-data-str_suppl1 = fp_st_file-str_suppl1.
      lst_addresses-data-postal-datax-str_suppl1 = abap_true.
    ENDIF.
    IF fp_st_file-str_suppl2 IS NOT INITIAL.
      lst_addresses-data-postal-data-str_suppl2 = fp_st_file-str_suppl2.
      lst_addresses-data-postal-datax-str_suppl2 = abap_true..
    ENDIF.
    IF fp_st_file-str_suppl3 IS NOT INITIAL.
      lst_addresses-data-postal-data-str_suppl3 = fp_st_file-str_suppl3.
      lst_addresses-data-postal-datax-str_suppl3 = abap_true.
    ENDIF.
    IF fp_st_file-location IS NOT INITIAL.
      lst_addresses-data-postal-data-location = fp_st_file-location.
      lst_addresses-data-postal-datax-location = abap_true.
    ENDIF.
    IF fp_st_file-city1 IS NOT INITIAL.
      lst_addresses-data-postal-data-city = fp_st_file-city1.
      lst_addresses-data-postal-datax-city = abap_true..
    ENDIF.
    IF fp_st_file-post_code1 IS NOT INITIAL.
      lst_addresses-data-postal-data-postl_cod1 = fp_st_file-post_code1.
      lst_addresses-data-postal-datax-postl_cod1 = abap_true.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_centraldata-searchterm2 = fp_st_file-post_code1.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_centraldata-searchterm2 = abap_true.
    ENDIF.
    IF fp_st_file-region IS NOT INITIAL.
      lst_addresses-data-postal-data-region = fp_st_file-region.
      lst_addresses-data-postal-datax-region = abap_true.
    ENDIF.
    IF fp_st_file-country IS NOT INITIAL.
      lst_addresses-data-postal-data-country = fp_st_file-country.
      lst_addresses-data-postal-datax-country = abap_true.
    ENDIF.
    IF fp_st_file-spras IS NOT INITIAL..
      st_bp_input-general_data-gen_data-central_data-common-data-bp_person-correspondlanguage = fp_st_file-spras."lsr_spras-low.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_person-correspondlanguage = abap_true.
    ELSE.
      st_bp_input-general_data-gen_data-central_data-common-data-bp_person-correspondlanguage = lsr_spras-low.
      st_bp_input-general_data-gen_data-central_data-common-datax-bp_person-correspondlanguage = abap_true.
    ENDIF.
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
    IF fp_st_file-deflt_comm IS NOT INITIAL.
      lst_addresses-data-postal-data-comm_type = fp_st_file-deflt_comm.
      lst_addresses-data-postal-datax-comm_type = abap_true.
    ENDIF.
    IF fp_st_file-smtp_addr IS NOT INITIAL.
      lst_smtp-contact-data-e_mail = fp_st_file-smtp_addr.
      lst_smtp-contact-datax-e_mail = abap_true.
      APPEND lst_smtp TO li_smtp.
      CLEAR : lst_smtp.
*      st_bp_input-general_data-gen_data-central_data-communication-smtp-smtp[] = li_smtp[].
      lst_addresses-data-communication-smtp-smtp = li_smtp[].
      CLEAR li_smtp[].
    ENDIF.
    IF fp_st_file-tel_number IS NOT INITIAL.
      lst_phone-contact-data-telephone = fp_st_file-tel_number.
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

  "----------------------------------------------------------------------
*---Business Partner ID data mapping
*"----------------------------------------------------------------------
  IF v_bp IS NOT INITIAL.
    st_bp_input-general_data-gen_data-header-object_instance-bpartner = v_bp.
  ENDIF.
*  lst_id-data_key-identificationnumber = fp_st_file-id_number..
*  lst_id-data_key-identificationcategory = c_zmemid.
*  lst_id-data-identrydate = sy-datum.
*  APPEND lst_id TO li_id.
*  CLEAR lst_id.
*  IF li_id IS NOT INITIAL.
*    st_bp_input-general_data-gen_data-central_data-ident_number-ident_numbers[] = li_id[].
*    CLEAR: li_id.
*  ENDIF.
*  st_bp_input-general_data-gen_data-header-object_instance-identificationcategory = c_zmemid.
*  st_bp_input-general_data-gen_data-header-object_instance-identificationnumber = fp_st_file-id_number.
*  lst_time-valid_from = sy-datum.
*  lst_time-valid_from_x = abap_true.
*  APPEND lst_time TO li_time.
*  CLEAR lst_time.
*  st_bp_input-general_data-gen_data-central_data-common-time_dependent_data-common_data[] = li_time[].
*  CLEAR : li_time[].
*--* KATR6
  IF fp_st_file-katr6 IS NOT INITIAL.
    st_bp_input-general_data-add_gen_data-central-data-katr6 =  fp_st_file-katr6.
    st_bp_input-general_data-add_gen_data-central-datax-katr6 =  abap_true.
  ELSE.
    st_bp_input-general_data-add_gen_data-central-data-katr6 =  lsr_katr6-low.
    st_bp_input-general_data-add_gen_data-central-datax-katr6 =  abap_true.
  ENDIF.
  "----------------------------------------------------------------------
*---*Company code extension data mapping
*"----------------------------------------------------------------------
  IF st_create-comp_data IS NOT INITIAL.
    IF fp_st_file-vkorg IS NOT INITIAL.
      lst_comp_codes-data_key-bukrs = fp_st_file-vkorg.
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
      IF st_bp_rules-check14_ctry_nonus = abap_true.
        IF lst_comp_codes-data_key-bukrs NE c_vkorg.
          lst_comp_codes-data_key-bukrs = c_vkorg.
          lst_comp_codes-data-busab = lst_coll_1001-busab.
          APPEND lst_comp_codes TO li_comp_codes.
        ENDIF.
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
    IF fp_st_file-vkorg IS NOT INITIAL.
      lst_sales-data_key-vkorg = fp_st_file-vkorg.
    ENDIF.
    IF lsr_vtweg-low IS NOT INITIAL.
      lst_sales-data_key-vtweg = lsr_vtweg-low.
    ENDIF.
    IF lsr_spart-low IS NOT INITIAL.
      lst_sales-data_key-spart = lsr_spart-low.
    ENDIF.
    IF fp_st_file-vkbur IS NOT INITIAL.
      lst_sales-data-vkbur = fp_st_file-vkbur.
      lst_sales-datax-vkbur = abap_true.
    ENDIF.
    IF fp_st_file-kdgrp IS NOT INITIAL.
      lst_sales-data-kdgrp = fp_st_file-kdgrp.
      lst_sales-datax-kdgrp = abap_true.
    ELSE.
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
    IF fp_st_file-waerk IS NOT INITIAL.
      lst_sales-data-waers = fp_st_file-waerk.
      lst_sales-datax-waers = abap_true.
    ELSE.
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
    IF st_bp_rules-map8_society_partner = abap_true AND v_indirect = abap_true.
      IF v_bp_country IS INITIAL .
        v_bp_country = fp_st_file-country.
      ENDIF.
      IF v_bp_country IN lir_country.
        PERFORM f_build_partner_functions  TABLES li_functions
                                           USING fp_st_file
                                                 fp_st_file-vkorg
                                                 v_bp.

        lst_sales-functions-functions[] = li_functions[].
        lst_sales-task = c_m.
        CLEAR : li_functions[].
        lv_functions_built = abap_true.
      ENDIF.
    ENDIF.
    IF lst_sales IS NOT INITIAL.
      APPEND lst_sales TO li_sales.
*--*Default Sales area
      IF st_bp_rules-check14_ctry_nonus = abap_true.
        IF lst_sales-data_key-vkorg NE c_vkorg.
          lst_sales-data_key-vkorg = c_vkorg.
          lst_sales-data-kkber = lst_t001cm_1001-kkber.
          lst_sales-datax-kkber = abap_true.
**--*Partners modification for 1001
          IF lv_functions_built = abap_true.
            CLEAR :lst_sales-functions-functions[].
            PERFORM f_build_partner_functions  TABLES li_functions
                                               USING  fp_st_file
                                                      c_vkorg
                                                      v_bp.
            lst_sales-task = c_m.
            lst_sales-functions-functions[] = li_functions[].
            CLEAR : li_functions[].
          ENDIF.
          APPEND lst_sales TO li_sales.
        ENDIF.
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
  IF st_create-collection IS NOT INITIAL.
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
  ENDIF.
  "----------------------------------------------------------------------
*--*Credit segment Data mapping
*"----------------------------------------------------------------------
  IF st_create-credit IS NOT INITIAL.
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
  ENDIF.
  "----------------------------------------------------------------------
*--*BP Relationship data mapping
*"----------------------------------------------------------------------
*  st_bp_input-data_key-id_number = fp_st_file-id_number.
*  TRANSLATE fp_st_file-reltyp TO UPPER CASE.
*  IF fp_st_file-reltyp = c_student.
*    lst_relation-header-object_instance-relat_category = c_zir002.
*    lv_date+0(4) = sy-datum+0(4).
*    lv_date+4(2) = 12.
*    lv_date+6(2) = 31.
*  ELSE.
*    lst_relation-header-object_instance-date_to = lv_date.
*    lst_relation-header-object_instance-relat_category = c_zir001.
*    lst_relation-header-object_instance-date_to = lsr_end_date-low.
*  ENDIF.
*  IF v_bp IS NOT INITIAL.
*    lst_relation-header-object_instance-partner1-bpartner = v_bp.
*  ENDIF.
*  IF lsr_agu-low IS NOT INITIAL.
*    lst_relation-header-object_instance-partner2-bpartner = lsr_agu-low.
*  ENDIF.
*st_bp_input = fp_st_file-REL_DATE_FROM.
*  IF fp_st_file-reltyp IS NOT INITIAL.
*    lst_relation-header-object_instance-relat_category = fp_st_file-reltyp.
*  ENDIF.
*  IF fp_st_file-datfrom IS NOT INITIAL.
*    lst_relation-header-object_instance-date_from = fp_st_file-datfrom.
*  ELSE.
*    lst_relation-header-object_instance-date_from = sy-datum.
*  ENDIF.
  IF st_create-relation IS NOT INITIAL.
    CASE v_source.
      WHEN 'SOCIETY'.
        IF v_bp IS NOT INITIAL.
          lst_relation-header-object_instance-partner1-bpartner = v_bp.
        ENDIF.
        IF fp_st_file-reltyp IS NOT INITIAL.
          lst_relation-header-object_instance-relat_category = fp_st_file-reltyp.
        ENDIF.
        IF fp_st_file-datfrom IS NOT INITIAL.
          lst_relation-central_data-main-data-date_from = fp_st_file-datfrom.
        ENDIF.
        IF fp_st_file-dateto IS NOT INITIAL.
          lst_relation-header-object_instance-date_to = fp_st_file-dateto.
        ELSE.
          lst_relation-header-object_instance-date_to = lsr_end_date-low.
        ENDIF.
        IF fp_st_file-partner2 IS NOT INITIAL.
          lst_relation-header-object_instance-partner2-bpartner = fp_st_file-partner2.
        ENDIF.
        IF st_bp_rules-map7_cr7463 = abap_true AND v_bp IS INITIAL.
          PERFORM f_add_cr7463_logic TABLES li_relation
                                     USING st_file
                                     CHANGING lst_relation.
        ENDIF.
        INSERT lst_relation INTO li_relation INDEX 1.
        CLEAR : lst_relation.
        st_bp_input-relationship_data-relationships[] = li_relation[].
        CLEAR : li_relation[].

    ENDCASE.
  ENDIF.
  IF st_bp_input IS NOT INITIAL.
    APPEND st_bp_input TO i_bp_input.
    CLEAR st_bp_input.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_FILE  text
*----------------------------------------------------------------------*
FORM f_file_address_validations  CHANGING  fp_st_file TYPE zsqtc_bp_update
                                           fp_v_error TYPE c.
  DATA : lv_len      TYPE i,
         lv_err_type TYPE char2,
         lv_bp_stat  TYPE zprcstat.
  CONSTANTS : lc_jpn TYPE land1 VALUE 'JPN'.
**"----------------------------------------------------------------------
**-----Validate Email address
**"----------------------------------------------------------------------
  IF fp_st_file-smtp_addr IS INITIAL.
    fp_v_error = abap_true.
  ENDIF.
*"----------------------------------------------------------------------
*-----BP Id number check
*"----------------------------------------------------------------------
  IF fp_st_file-id_number IS INITIAL.
    fp_v_error = abap_true.
  ENDIF.
*"----------------------------------------------------------------------
*-----Required address details
*"----------------------------------------------------------------------
  IF fp_st_file-street IS INITIAL OR fp_st_file-city1 IS INITIAL OR
    fp_st_file-post_code1 IS INITIAL OR fp_st_file-country IS INITIAL .
    fp_v_error = abap_true.
  ENDIF.
**"----------------------------------------------------------------------
**-----Relationship type
**"----------------------------------------------------------------------
*  IF fp_st_file-reltyp IS INITIAL.
*    fp_v_error = abap_true.
*  ENDIF.
  IF fp_st_file-country = lc_jpn.
    lv_len = strlen( fp_st_file-post_code1 ).
    IF lv_len EQ 7.
      fp_st_file-post_code1+7(1) = fp_st_file-post_code1+6(1).
      fp_st_file-post_code1+6(1) = fp_st_file-post_code1+5(1).
      fp_st_file-post_code1+5(1) = fp_st_file-post_code1+4(1).
      fp_st_file-post_code1+3(1) = '-'.
    ENDIF.
  ENDIF.
  IF fp_v_error IS NOT INITIAL.
    lv_err_type = c_ad.
    lv_bp_stat = c_e1.
    PERFORM f_log_messages USING st_file lv_bp_stat fp_v_error lv_err_type.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_TABLES_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_FILE  text
*----------------------------------------------------------------------*
FORM f_get_tables_data  TABLES   fp_i_file STRUCTURE zsqtc_bp_update.

  IF fp_i_file[] IS NOT INITIAL.
*"----------------------------------------------------------------------
*-----T005 (Countries ) - File contains ISO country name, Get SAP Country
*"----------------------------------------------------------------------
    SELECT land1, intca3 FROM t005 INTO TABLE @i_t005
                          FOR ALL ENTRIES IN @fp_i_file WHERE land1 = @fp_i_file-country.
    IF sy-subrc EQ 0 AND i_t005 IS NOT INITIAL..
      SORT i_t005 BY intca3.

      SELECT id,
             country_name,
             country_iso_code,
             country_sap,
             currency_code,
             compaany_code,
             price_list
                 FROM zqtc_sal_ara_ref INTO TABLE @i_sale_ref
                           FOR ALL ENTRIES IN @i_t005
                           WHERE country_iso_code = @i_t005-intca3.
    ENDIF.
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
                                      WHERE credit_group = @lsr_credit_group-low.
      IF sy-subrc EQ 0.
        SORT i_coll BY coll_segment credit_group land1 regio vkorg vtweg spart.
      ENDIF.
    ENDIF.
  ENDIF.
*"----------------------------------------------------------------------------
*-----tsad3t(Titles (Texts)) - File contains Title description - Get Title codes
*"-----------------------------------------------------------------------------
*  IF i_title IS NOT INITIAL.
*    SELECT langu,
*           title,
*           title_medi INTO TABLE @i_tsad3t FROM  tsad3t
*                           WHERE langu = @sy-langu
*                           AND title_medi IN @i_title.
*    IF sy-subrc EQ 0.
*      SORT  i_tsad3t  BY langu title_medi.
*    ENDIF.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_MAIN_SEARCH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_FILE  text
*----------------------------------------------------------------------*
FORM f_bp_main_search  USING st_file TYPE zsqtc_bp_update
                             st_bp_rules TYPE zqtc_bp_rules.
  DATA : lv_street TYPE ad_street,
         lv_email  TYPE ad_smtpadr.
**"----------------------------------------------------------------------
*-----BP Search 1
*"----------------------------------------------------------------------
  IF st_bp_rules-check3_addr_search1  = abap_true.
    PERFORM f_search_bp TABLES i_search_result
                        USING  st_file-name_f st_file-name_l st_file-smtp_addr st_file-street.
  ENDIF.
*"----------------------------------------------------------------------
*-----BP Search 2
*"----------------------------------------------------------------------
  IF i_search_result IS INITIAL.
    IF st_bp_rules-check4_addr_search2 = abap_true.
*--* Remove street from the search
      PERFORM f_search_bp TABLES i_search_result
                          USING  st_file-name_f st_file-name_l st_file-smtp_addr lv_street.
    ENDIF.
*"----------------------------------------------------------------------
*-----BP Search 3
*"----------------------------------------------------------------------
    IF i_search_result IS INITIAL.
      IF st_bp_rules-check5_addr_search3 = abap_true.
*--*Removing Email from  search
        PERFORM f_search_bp TABLES i_search_result
                            USING  st_file-name_f st_file-name_l lv_email st_file-street.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_RULES_COMP_SALES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_BP  text
*      -->P_ST_FILE  text
*      <--P_V_ERROR  text
*----------------------------------------------------------------------*
FORM f_bp_rules_comp_sales  USING    st_bp_rules TYPE zqtc_bp_rules
                                     v_bp TYPE bu_partner
                                     st_file TYPE zsqtc_bp_update
                            CHANGING v_error TYPE c.
  DATA : lv_err_type TYPE char2,
         lv_bp_stat  TYPE  zprcstat.
*"----------------------------------------------------------------------
*-Society BP mentioned in relationship data is different from Sold To Party
*"----------------------------------------------------------------------
  IF st_bp_rules-check17_file_bp_soldto = abap_true.
    PERFORM f_bp_soldto_check USING st_file
                              CHANGING v_error lv_err_type lv_bp_stat.
*"----------------------------------------------------------------------
*----SLG Log update and Staging table update
*"----------------------------------------------------------------------
    IF v_error IS NOT INITIAL.
      PERFORM f_log_messages USING st_file lv_bp_stat v_error lv_err_type.
      EXIT.
    ENDIF.
  ENDIF.
*"----------------------------------------------------------------------
*-----BP Sales Blocks check
*"----------------------------------------------------------------------
  IF st_bp_rules-check7_sales_block = abap_true.
    PERFORM f_bp_blocks_check USING v_bp st_file-vkorg
                                         st_file-vtweg
                                         st_file-spart
                              CHANGING v_error.
*"----------------------------------------------------------------------
*----SLG Log update and Staging table update
*"----------------------------------------------------------------------
    IF v_error IS NOT INITIAL.
      lv_err_type = c_block.
      PERFORM f_log_messages USING st_file lv_bp_stat v_error lv_err_type.
      EXIT.
    ENDIF.
  ENDIF.
*"----------------------------------------------------------------------
*-----BP Company code extension check
*"----------------------------------------------------------------------
  IF st_bp_rules-check9_comp_code = abap_true.
    PERFORM f_bp_company_code_check USING st_file-vkorg v_bp.
  ENDIF.
*"----------------------------------------------------------------------
*-----BP Company code extension for country IN/AUS check
*"----------------------------------------------------------------------
  IF st_bp_rules-check12_ctry_in = abap_true OR
      st_bp_rules-check13_ctry_au = abap_true.


    PERFORM f_bp_compcode_sales_ind_au_chk USING v_bp st_file
                                             CHANGING v_error
                                                      lv_err_type.
*"----------------------------------------------------------------------
*----SLG Log update and Staging table update
*"----------------------------------------------------------------------
    IF v_error IS NOT INITIAL.
      PERFORM f_log_messages USING st_file lv_bp_stat v_error lv_err_type.
      EXIT.
    ENDIF.
  ENDIF.
*"----------------------------------------------------------------------
*"----------------------------------------------------------------------
*-----BP Sales area extension check
*"----------------------------------------------------------------------
  IF st_bp_rules-check10_sales_area = abap_true.
    PERFORM f_bp_sales_area_check  USING st_file-vkorg st_file-vtweg st_file-spart v_bp.
  ENDIF.
*"----------------------------------------------------------------------
*-----BP Relationship add
*"----------------------------------------------------------------------
  IF st_bp_rules-check11_bp_relation = abap_true.
    PERFORM f_relationship_check USING v_bp st_file-partner2 st_file-reltyp
                                 CHANGING st_file.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_MESSAGES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_FILE  text
*      -->P_LV_STATUS  text
*----------------------------------------------------------------------*
FORM f_log_messages  USING    fp_st_file TYPE zsqtc_bp_update
                              fp_lv_status TYPE  zprcstat
                              fp_v_error TYPE c
                              fp_lv_err_type TYPE char2.
  DATA:lv_bp_stat TYPE zprcstat.
*--*Get the status to update staging table
  IF fp_lv_status IS INITIAL.
    PERFORM f_get_status USING fp_v_error CHANGING lv_bp_stat.
  ELSE.
    lv_bp_stat = fp_lv_status.
  ENDIF.
  IF fp_v_error IS NOT INITIAL.
    fp_st_file-msgty = c_e.
  ENDIF.
*--*SLG Log add and Update
  PERFORM f_log_msg_add USING st_file lv_bp_stat fp_v_error fp_lv_err_type.
*--*Staging table update
  PERFORM f_staging_update USING st_file lv_bp_stat fp_v_error.
  CLEAR : fp_lv_status.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_FILE  text
*      -->P_LV_MSGV1  text
*      -->P_V_ERROR  text
*----------------------------------------------------------------------*
FORM f_log_msg_add  USING    fp_st_file TYPE zsqtc_bp_update
                             fp_lv_status TYPE  zprcstat
                             fp_v_error TYPE c
                             fp_err_type TYPE char2.
  DATA:lst_msg       TYPE bal_s_msg,
       lv_log_handle TYPE balloghndl,
       lv_msgv1      TYPE msgv1,
       lv_msgv2      TYPE msgv2,
       lv_msgv3      TYPE msgv3,
       lv_msgv4      TYPE msgv4,
       li_log_handle TYPE bal_t_logh.
  APPEND fp_st_file-log_handle TO li_log_handle.
  lv_log_handle = fp_st_file-log_handle.
  lst_msg-msgid    = 'ZQTC_R2'.
  lst_msg-msgno    = '000'.
*  lst_msg-detlevel = c_i.
  IF fp_v_error IS NOT INITIAL.
    lst_msg-msgty    = c_e.
  ELSE.
    lst_msg-msgty    = c_i.
  ENDIF.
  CASE fp_lv_status.
    WHEN c_b1."Inprogress BP
      lst_msg-msgv1 = text-l01.
    WHEN c_b2."Inprogress-BP Creation
      lst_msg-msgv1 = text-l02.
    WHEN c_b3."Inprogress BP Changed/Updated
      CONCATENATE text-l03 v_bp INTO lst_msg-msgv1 SEPARATED BY space.
    WHEN c_b4."Inprogress BP Identified
      CONCATENATE text-l04 v_bp INTO lst_msg-msgv1 SEPARATED BY space.
    WHEN c_e1.
      CASE fp_err_type.
        WHEN c_block. "Sales block error
          CONCATENATE text-b01 v_cust_string INTO lst_msg-msgv1 SEPARATED BY space.
          lst_msg-msgv2 = text-b02.
          lst_msg-msgv3 = text-b03.
          lst_msg-msgv4 = text-b04.
        WHEN c_in. "if sales org is other than 1001 and country IN throw an error
          CONCATENATE text-b10 v_bp text-b06 INTO lst_msg-msgv1 SEPARATED BY space.
          lst_msg-msgv2 = text-b11.
          lst_msg-msgv3 = text-b12.
*          lst_msg-msgv4 = text-b13.
        WHEN c_au. "If sales org is other than 1001/8001 and country AU throw an error
          CONCATENATE text-b05 v_bp text-b06 INTO lst_msg-msgv1 SEPARATED BY space.
          lst_msg-msgv2 = text-b07.
          lst_msg-msgv3 = text-b08.
*          lst_msg-msgv4 = text-b09.
*--* BOC OTCM-38772 By Prabhu on 2/14/2021 ED2K921898
        WHEN c_new_country."If sales org is other than 1001/8001 and country new country of E184 ex: SG, throw an error
          CONCATENATE text-b05 v_bp text-b06 INTO lst_msg-msgv1 SEPARATED BY space.
          IF fp_st_file-country IS NOT INITIAL.
            CONCATENATE text-c01 fp_st_file-country INTO lst_msg-msgv2 SEPARATED BY space.
          ELSE.
            CONCATENATE text-c01 v_bp_country INTO lst_msg-msgv2 SEPARATED BY space.
          ENDIF.
          lst_msg-msgv3 = text-c02.
*--* EOC OTCM-38772 By Prabhu on 2/14/2021 ED2K921898
        WHEN c_ar_but. "AR data, for BUT000master data check, multiple BP found on same date
          CONCATENATE text-b14 v_cust_string INTO lst_msg-msgv1 SEPARATED BY space.
          lst_msg-msgv2 = text-b15.
          lst_msg-msgv3 = text-b16.
          lst_msg-msgv4 = text-b17.
        WHEN c_ad. "File address incompletion error
          lst_msg-msgv1 = text-b23.
        WHEN c_id. "Multiple BP  found against a single Member ID
          lst_msg-msgv1 = text-b24.
        WHEN c_in_file.
          lst_msg-msgv1 = text-b19.
          lst_msg-msgv2 = text-b20.
          CONCATENATE text-b25 fp_st_file-country fp_st_file-vkorg INTO lst_msg-msgv3 SEPARATED BY space.
        WHEN c_au_file.
          lst_msg-msgv1 = text-b21.
          lst_msg-msgv2 = text-b22.
          CONCATENATE text-b25 fp_st_file-country fp_st_file-vkorg  INTO lst_msg-msgv3 SEPARATED BY space.
*--* BOC OTCM-38772 By Prabhu on 2/14/2021 ED2K921898
        WHEN c_new_country_file."If sales org is other than 1001/8001 and country new country of E184 ex: SG, throw an error
          CONCATENATE text-c03 fp_st_file-country text-c04 INTO lst_msg-msgv1 SEPARATED BY space.
          lst_msg-msgv2 = text-c05.
          CONCATENATE text-b25 fp_st_file-country fp_st_file-vkorg  INTO lst_msg-msgv3 SEPARATED BY space.
*--* EOC OTCM-38772 By Prabhu on 2/14/2021 ED2K921898
        WHEN c_err_file_soc.
          CONCATENATE text-b26 fp_st_file-partner2 text-b27 INTO lst_msg-msgv1.
          lst_msg-msgv2 = text-b28.
          lst_msg-msgv3 = text-b29.
        WHEN c_err_indirect_item.
          CONCATENATE text-b30 fp_st_file-posnr INTO lst_msg-msgv1 SEPARATED BY space.
          lst_msg-msgv2 = text-b31.
          lst_msg-msgv3 = text-b32.
          lst_msg-msgv4 = text-b33.
        WHEN OTHERS.
      ENDCASE.
    WHEN OTHERS.
  ENDCASE.
  CALL FUNCTION 'BAL_DB_LOAD'
    EXPORTING
      i_t_log_handle     = li_log_handle
    EXCEPTIONS
      no_logs_specified  = 1
      log_not_found      = 2
      log_already_loaded = 3
      OTHERS             = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  CLEAR : li_log_handle.
* add this message to the log
  fp_st_file-msgv1 = lst_msg-msgv1.
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle  = lv_log_handle  " Application Log: Log Handle
      i_s_msg       = lst_msg
    EXCEPTIONS
      log_not_found = 0
      OTHERS        = 1.
  IF sy-subrc <> 0.
*   Nothing to do
  ELSE.
    PERFORM f_log_update USING fp_st_file.
  ENDIF.
  CLEAR : lst_msg, lv_log_handle.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_FILE  text
*----------------------------------------------------------------------*
FORM f_log_update  USING  fp_st_file TYPE zsqtc_bp_update.
  DATA : li_log_handle  TYPE bal_t_logh,
         lst_log_handle LIKE LINE OF li_log_handle,
         li_lognum      TYPE bal_t_lgnm.
  lst_log_handle = fp_st_file-log_handle.
  APPEND lst_log_handle TO li_log_handle.
  CLEAR lst_log_handle.
  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_client         = sy-mandt
*     i_in_update_task = ' '
      i_save_all       = abap_true
      i_t_log_handle   = li_log_handle
    IMPORTING
      e_new_lognumbers = li_lognum
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_STAGING_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_FILE  text
*      -->P_LV_STATUS  text
*      -->P_V_ERROR  text
*----------------------------------------------------------------------*
FORM f_staging_update  USING    fp_st_file TYPE zsqtc_bp_update
                                fp_lv_status TYPE zprcstat
                                fp_v_error TYPE c.
  DATA : lst_staging TYPE ze225_staging.
  CLEAR: st_staging.
*--*Update staging table.
  READ TABLE i_staging INTO st_staging WITH KEY zuid_upld = fp_st_file-zoid
                                                zoid =  fp_st_file-identifier.
*                                                zitem = fp_st_file-posnr
*                                                BINARY SEARCH.
  IF sy-subrc EQ 0.
    lst_staging = st_staging.
    lst_staging-zprcstat = fp_lv_status.
    lst_staging-zbp = v_bp.
    lst_staging-zcrttim = sy-uzeit.
    lst_staging-zitem = fp_st_file-posnr.
    MODIFY ze225_staging FROM lst_staging.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_ERROR  text
*      <--P_LV_STATUS  text
*----------------------------------------------------------------------*
FORM f_get_status  USING    fp_v_error TYPE c
                   CHANGING fp_lv_status TYPE zprcstat.
  IF fp_v_error IS INITIAL.
    fp_lv_status = c_b1. "Inprogress BP
  ELSE.
    fp_lv_status = c_e1. "BP Error
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_STATUS_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LV_STATUS  text
*----------------------------------------------------------------------*
FORM f_get_status_2  CHANGING fp_lv_status TYPE zprcstat.
  IF v_bp IS INITIAL.
    fp_lv_status = c_b2. "Inprogress BP Creation
  ELSE.
    fp_lv_status = c_b3. "Inprogress BP Changed/Updated
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS_I0200
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants_i0200 .
  DATA : lc_devid          TYPE zdevid VALUE 'I0200',
         li_constant_i0200 TYPE tt_constant.
  CONSTANTS : lc_param1_rel_cat  TYPE rvari_vnam VALUE 'REL_CATEGORY',
              lc_param2_valid_yr TYPE rvari_vnam VALUE 'VALIDITY_YEAR',
              lc_param2_stu_mem  TYPE rvari_vnam VALUE 'STUDENT_MEMBER'.
  CLEAR : li_constant_i0200,v_validity_year,r_rel_categories.
  SELECT devid,      " Development ID
          param1,     " ABAP: Name of Variant Variable
          param2,     " ABAP: Name of Variant Variable
          srno,       " ABAP: Current selection number
          sign,       " ABAP: ID: I/E (include/exclude values)
          opti,       " ABAP: Selection option (EQ/BT/CP/...)
          low,        " Lower Value of Selection Condition
          high,       " Upper Value of Selection Condition
          activate    "
     FROM zcaconstant " Wiley Application Constant Table
     INTO TABLE @li_constant_i0200
     WHERE devid = @lc_devid AND
           activate = @abap_true AND
           param1 = @lc_param1_rel_cat.
  LOOP AT li_constant_i0200 INTO DATA(lst_zcaconstant_i0200).
*      CASE lst_zcaconstant_i0200-param1.
*        WHEN lc_param1_rel_cat.
    IF lst_zcaconstant_i0200-param2 = lc_param2_valid_yr.
      v_validity_year = lst_zcaconstant_i0200-low.
    ELSEIF lst_zcaconstant_i0200-param2 = lc_param2_stu_mem.
      APPEND INITIAL LINE TO r_rel_categories ASSIGNING FIELD-SYMBOL(<lst_rel_cat>).
      <lst_rel_cat>-sign   = lst_zcaconstant_i0200-sign.
      <lst_rel_cat>-option = lst_zcaconstant_i0200-opti.
      <lst_rel_cat>-low    = lst_zcaconstant_i0200-low.
    ENDIF.
*       ENDCASE.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADD_CR7463_LOGIC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_RELATION  text
*----------------------------------------------------------------------*
FORM f_add_cr7463_logic  TABLES   fp_li_relation TYPE burs_ei_extern_t
                         USING fp_st_file TYPE zsqtc_bp_update
                         CHANGING fp_lst_relation TYPE burs_ei_extern.

  DATA : li_data_temp  TYPE burs_ei_extern_t,
         lst_data_temp TYPE burs_ei_extern,
         lv_year(4)    TYPE n,
         lv_datet_c    TYPE char8,
         lv_datef_c    TYPE char8.

  SORT r_rel_categories BY low.
  READ TABLE r_rel_categories TRANSPORTING NO FIELDS
                              WITH KEY low = fp_st_file-reltyp
                              BINARY SEARCH.
  IF sy-subrc = 0.
    " If Reletionship Category is Student Member, then
    " a) Update the Student Member Rel. cat. with three years validity
    " b) Add the Full Membership (ZPR008) Rel. Cat.

    " a) Update the Student Member Rel. cat. with three years validity
    fp_lst_relation-central_data-main-data-date_from+4(4) = c_0101.   " Validity_From date
    lv_year = fp_lst_relation-central_data-main-data-date_from(4).
    lv_year = lv_year + v_validity_year.
    CONCATENATE lv_year c_1231 INTO lv_datet_c.
    fp_lst_relation-header-object_instance-date_to = lv_datet_c.      " Validity_To date

    " b) Add the Full Membership (ZPR008) Rel. Cat.
    lv_year = lv_year + 1.
    CONCATENATE lv_year c_0101 INTO lv_datef_c.
*
    lst_data_temp-header-object_instance-partner2-bpartner = fp_st_file-partner2.
    lst_data_temp-header-object_instance-relat_category = c_relcat_zpr008.       " Full membership (ZPR008)
    lst_data_temp-central_data-main-data-date_from = lv_datef_c.                " Full membership Validity_From date
    lst_data_temp-header-object_instance-date_to = cl_bus_time=>gc_end_of_days. " Full membership Validity_To date
    lst_data_temp-header-object_task = c_m.
    lst_data_temp-central_data-main-datax-date_from = abap_true.

    APPEND lst_data_temp TO li_data_temp.
    CLEAR lst_data_temp.
    APPEND LINES OF li_data_temp TO fp_li_relation.
    CLEAR : li_data_temp[].
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MEMBER_ID_SEARCH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_FILE_MEMBER_ID  text
*      <--P_V_ERROR  text
*----------------------------------------------------------------------*
FORM f_member_id_search  USING    fp_st_file_member_id TYPE bu_id_number
                         CHANGING fp_v_error.
  DATA : lv_cat      TYPE bapibus1006_identification_key-identificationcategory VALUE 'ZMEMID',
         lv_id       TYPE bapibus1006_identification_key-identificationnumber,
         li_partner  TYPE STANDARD TABLE OF bus_partner_guid,
         lst_partner TYPE bus_partner_guid,
         li_return   TYPE STANDARD TABLE OF bapiret2,
         lv_lines    TYPE i,
         lv_err_type TYPE char2,
         lv_bp_stat  TYPE zprcstat.
  lv_id = fp_st_file_member_id.
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
    ENDIF.
  ELSEIF lv_lines GT 1.
    fp_v_error = abap_true.
  ENDIF.
  IF fp_v_error IS NOT INITIAL.
    lv_err_type = c_id.
    lv_bp_stat = c_e1.
    PERFORM f_log_messages USING st_file lv_bp_stat fp_v_error lv_err_type.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAP_CREATION_FLAGS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_map_creation_flags .
  st_create-gen_data = c_i.
  IF st_bp_rules-map2_comp_data_map = abap_true.
    st_create-comp_data = abap_true.
  ENDIF.
  IF st_bp_rules-map1_sales_data_map = abap_true.
    st_create-sales_data = abap_true.
  ENDIF.
  IF st_bp_rules-map5_maintain_rel = abap_true.
    st_create-relation = abap_true.
  ENDIF.
  IF st_bp_rules-map3_credit_data_map = abap_true.
    st_create-credit = abap_true.
  ENDIF.
  IF st_bp_rules-map4_coll_data_map = abap_true.
    st_create-collection = abap_true.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_BAPI_RETURN_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_INDEX  text
*      <--P_ST_FILE  text
*----------------------------------------------------------------------*
FORM f_update_bapi_return_log  CHANGING fp_st_file TYPE zsqtc_bp_update.
  DATA : li_messages TYPE bapiretct,
         lst_partner TYPE zstqtc_customer_details,
         lv_bp_stat  TYPE zprcstat.
  CLEAR : li_messages.

*--*Append BAPI reurn messages
  LOOP AT i_bp_return INTO DATA(lst_bp_return).
    APPEND LINES OF lst_bp_return-messages TO  li_messages.
    CLEAR lst_bp_return-messages[].
    lst_partner = lst_bp_return-partner_info.
  ENDLOOP.
  IF lst_partner-partner IS NOT INITIAL.
    fp_st_file-customer = lst_partner-partner.
    v_bp = lst_partner-partner.
  ELSE.
    v_bp = v_partner.
    fp_st_file-customer = v_partner.
  ENDIF.
*--*BAPI return messages
  IF li_messages IS NOT INITIAL.
    READ TABLE li_messages INTO DATA(lst_messages) WITH KEY type = c_e.
    IF sy-subrc EQ 0.
      fp_st_file-msgv1 = lst_messages-message.
      fp_st_file-msgty = lst_messages-type.
      lv_bp_stat = c_e1. "Inprogress BP Error
      v_error = abap_true.
    ELSE.
      fp_st_file-msgty = c_s.
      lv_bp_stat = c_b2. "Inprogress BP created
    ENDIF.
  ENDIF.
*--*Update staging table with BAPI return
  PERFORM f_staging_update USING st_file lv_bp_stat v_error.
  IF li_messages IS NOT INITIAL.
*--*Update Log with BAPI return
    PERFORM f_log_msg_add_bapi TABLES li_messages
                               USING fp_st_file lv_bp_stat v_error.
  ELSE.
    fp_st_file-msgty = c_s.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_MSG_ADD_BAPI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_MESSAGES  text
*      -->P_FP_ST_FILE  text
*      -->P_LV_BP_STAT  text
*      -->P_V_ERROR  text
*----------------------------------------------------------------------*
FORM f_log_msg_add_bapi  TABLES   fp_li_messages STRUCTURE bapiretc
                         USING    fp_st_file TYPE zsqtc_bp_update
                                  fp_lv_bp_stat TYPE zprcstat
                                  fp_v_error TYPE c.
  DATA:lst_msg       TYPE bal_s_msg,
       lv_log_handle TYPE balloghndl,
       lv_msgv1      TYPE msgv1,
       lv_msgv2      TYPE msgv2,
       lv_msgv3      TYPE msgv3,
       lv_msgv4      TYPE msgv4,
       li_log_handle TYPE bal_t_logh,
       lv_strlen     TYPE i.
  APPEND fp_st_file-log_handle TO li_log_handle.
  lv_log_handle = fp_st_file-log_handle.
  lst_msg-msgid    = 'ZQTC_R2'.
  lst_msg-msgno    = '000'.
  lst_msg-detlevel = c_i.
  IF fp_v_error IS INITIAL.
    lst_msg-msgty = c_i.
  ELSE.
    lst_msg-msgty = c_e.
  ENDIF.
  LOOP AT fp_li_messages INTO DATA(lst_messages).
    CASE sy-tabix.
      WHEN 1.
        lst_msg-msgv1 = lst_messages-message.
      WHEN 2.
        lst_msg-msgv2 = lst_messages-message.
        lv_strlen = strlen( lst_messages-message ).
        IF lv_strlen GT 50.
          lst_msg-msgv3 = lst_messages-message+50(50).
        ENDIF.
      WHEN 3.
        IF  lv_strlen LE 50.
          lst_msg-msgv3 = lst_messages-message.
        ELSE.
          lst_msg-msgv4 = lst_messages-message.
        ENDIF.
      WHEN 4.
        IF lst_msg-msgv4 IS INITIAL.
          lst_msg-msgv4 = lst_messages-message.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.
  CALL FUNCTION 'BAL_DB_LOAD'
    EXPORTING
      i_t_log_handle     = li_log_handle
    EXCEPTIONS
      no_logs_specified  = 1
      log_not_found      = 2
      log_already_loaded = 3
      OTHERS             = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  CLEAR : li_log_handle.
* add this message to the log
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle  = lv_log_handle  " Application Log: Log Handle
      i_s_msg       = lst_msg
    EXCEPTIONS
      log_not_found = 0
      OTHERS        = 1.
  IF sy-subrc <> 0.
*   Nothing to do
  ELSE.
    PERFORM f_log_update USING st_file.
  ENDIF.

  CLEAR : lst_msg, lv_log_handle.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_INPUT_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_FILE  text
*      -->P_ST_FILE  text
*      -->P_LV_INDEX  text
*      -->P_V_BP  text
*----------------------------------------------------------------------*
FORM f_update_input_file  TABLES   fp_i_file STRUCTURE zsqtc_bp_update
                          USING    fp_st_file TYPE zsqtc_bp_update
                                   fp_lv_index TYPE sy-tabix
                                   fp_v_bp TYPE kunnr
                                   fp_v_error TYPE c.
  fp_st_file-customer = fp_v_bp.
  IF fp_v_error IS NOT INITIAL.
    fp_st_file-msgty = c_e.
  ENDIF.
  IF fp_st_file-msgty IS INITIAL.
    fp_st_file-msgty = c_s.
  ENDIF.
  MODIFY fp_i_file FROM fp_st_file INDEX fp_lv_index TRANSPORTING customer msgty msgv1.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_RELATIONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_ST_FILE  text
*----------------------------------------------------------------------*
FORM f_update_relations TABLES fp_li_relation STRUCTURE bapibus1006_relations
                        USING  fp_partner TYPE bu_partner
                               fp_st_file TYPE zsqtc_bp_update.
  DATA  : lv_year(4) TYPE c,
          li_data    TYPE burs_ei_extern_t, " Complex External Interface of Relationships (Tab.)
          lst_data   TYPE burs_ei_extern,   " Complex External Interface of a Relationship
          li_return  TYPE bapiretm,
          lv_datef_c TYPE char8,
          lv_datet_c TYPE char8,
          lv_db      TYPE c.
  CLEAR : li_data,lv_db.
  SORT  fp_li_relation BY partner2 relationshipcategory.
* Build the relationships table (li_data) to be updated
  LOOP AT fp_li_relation ASSIGNING FIELD-SYMBOL(<lst_relations>)
                                    WHERE partner2 = fp_st_file-partner2.
    IF <lst_relations>-relationshipcategory = fp_st_file-reltyp.
*--*Valid record exist with file relationship
      IF <lst_relations>-validuntildate LE sy-datum.
*--*Record expired, Renew
        lv_year = sy-datum+0(4).
        CONCATENATE lv_year c_0101 INTO <lst_relations>-validfromdate.
        lst_data-header-object_instance-partner1-bpartner = <lst_relations>-partner1.
        lst_data-header-object_instance-partner2-bpartner = <lst_relations>-partner2.
        lst_data-header-object_instance-relat_category = <lst_relations>-relationshipcategory.
        lst_data-central_data-main-data-date_from = <lst_relations>-validfromdate.
        lst_data-central_data-main-data-date_to_new = lsr_end_date-low.
        lst_data-central_data-main-datax-date_to_new = abap_true.
        lst_data-header-object_task = c_m.
        lst_data-header-object_instance-date_to = <lst_relations>-validuntildate.
        lst_data-central_data-main-datax-date_from = abap_true.
        APPEND lst_data TO li_data.
        CLEAR lst_data.
        lv_db = abap_true.
      ENDIF.
    ELSE.
*--*IF Other relationships exists close them
*--*ZPR008 is taken care below in the next step, hence not considered here
      IF <lst_relations>-relationshipcategory NE c_relcat_zpr008.
        lst_data-header-object_instance-partner1-bpartner = <lst_relations>-partner1.
        lst_data-header-object_instance-partner2-bpartner = <lst_relations>-partner2.
        lst_data-header-object_instance-relat_category = <lst_relations>-relationshipcategory.
        lst_data-central_data-main-data-date_from = <lst_relations>-validfromdate.
        lst_data-central_data-main-data-date_to_new = sy-datum - 1.
        lst_data-central_data-main-datax-date_to_new = abap_true.
        lst_data-header-object_task = c_m.
        lst_data-header-object_instance-date_to = <lst_relations>-validuntildate.
        lst_data-central_data-main-datax-date_from = abap_true.
        APPEND lst_data TO li_data.
        CLEAR lst_data.
      ENDIF.
    ENDIF.
  ENDLOOP.
*--*check if there is no relatinship category of file in existing BP
  READ TABLE fp_li_relation INTO DATA(lst_relations2) WITH KEY
                                                 partner2 = fp_st_file-partner2
                                                 relationshipcategory = fp_st_file-reltyp
                                                 BINARY SEARCH.

  IF sy-subrc NE 0. "Create new one
    lv_year = sy-datum+0(4).
    CONCATENATE lv_year c_0101 INTO lst_data-central_data-main-data-date_from.
    lst_data-header-object_instance-partner1-bpartner = fp_partner.
    lst_data-header-object_instance-partner2-bpartner = fp_st_file-partner2.
    lst_data-header-object_instance-relat_category = fp_st_file-reltyp.
    lst_data-header-object_instance-date_to = lsr_end_date-low.
*    lst_data-central_data-main-data-date_to_new = lsr_end_date-low.
*    lst_data-central_data-main-datax-date_to_new = abap_true.
    lst_data-header-object_task = c_m.
    lst_data-central_data-main-datax-date_from = abap_true.
    APPEND lst_data TO li_data.
    CLEAR lst_data.
  ENDIF.
*--*CR7463 Logic
  IF st_bp_rules-map7_cr7463 = abap_true.
    SORT r_rel_categories BY low.
    READ TABLE r_rel_categories TRANSPORTING NO FIELDS
                                WITH KEY low = fp_st_file-reltyp
                                BINARY SEARCH.
    IF sy-subrc = 0.
      lv_year = sy-datum+0(4).
      lv_year = lv_year + v_validity_year.
      CONCATENATE lv_year c_1231 INTO lv_datet_c.
      lv_year = lv_year + 1.
      CONCATENATE lv_year c_0101 INTO lv_datef_c.
*--*Check If ZPR008 already exist
      READ TABLE fp_li_relation ASSIGNING FIELD-SYMBOL(<lst_relations3>) WITH KEY
                                                partner2 = fp_st_file-partner2
                                                relationshipcategory = c_relcat_zpr008
                                                BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_data-central_data-main-data-date_from = lv_datef_c.                " Full membership Validity_From date
        lst_data-header-object_instance-date_to = <lst_relations3>-validuntildate.
        lst_data-central_data-main-data-date_to_new = cl_bus_time=>gc_end_of_days. " Full membership Validity_To date
        lst_data-central_data-main-datax-date_to_new = abap_true.
        lst_data-central_data-main-data-date_from = lv_datef_c.
        lst_data-central_data-main-datax-date_from = abap_true.
      ELSE.
        lst_data-central_data-main-data-date_from = lv_datef_c.                " Full membership Validity_From date
        lst_data-header-object_instance-date_to = cl_bus_time=>gc_end_of_days. " Full membership Validity_To date
      ENDIF.

      lst_data-header-object_instance-partner1-bpartner = fp_partner.
      lst_data-header-object_instance-partner2-bpartner = fp_st_file-partner2.
      lst_data-header-object_instance-relat_category = c_relcat_zpr008.       " Full membership (ZPR008)

      lst_data-header-object_task = c_m.
      lst_data-central_data-main-datax-date_from = abap_true.
      APPEND lst_data TO li_data.
      CLEAR lst_data.
*--*Modify the Member corresponding to ZPR008
      READ TABLE li_data ASSIGNING FIELD-SYMBOL(<lst_data>)
                         WITH KEY header-object_instance-relat_category = fp_st_file-reltyp.
      IF sy-subrc EQ 0.
*--*Record exist at datbase level
        IF lv_db = abap_true.
          lv_year = sy-datum+0(4).
          <lst_data>-central_data-main-data-date_to_new = lv_datet_c.
          <lst_data>-central_data-main-datax-date_to_new = abap_true.
          CONCATENATE lv_year c_0101 INTO <lst_data>-central_data-main-data-date_from.
          <lst_data>-central_data-main-datax-date_from = abap_true.
        ELSE."Record updated as new above,not exist in database
          <lst_data>-header-object_instance-date_to = lv_datet_c.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
  IF li_data[] IS NOT INITIAL.
* Function call to update the student member Reletionship Category
* that is sent via Inbound Renewal
    CALL FUNCTION 'BUPA_INBOUND_REL_SAVE'
      EXPORTING
        data   = li_data
      IMPORTING
        return = li_return.
    IF li_return IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
      CLEAR li_return.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALL_BP_CREATE_FM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_call_bp_create_fm .
  CALL FUNCTION 'ZQTC_CUSTOMER_IB_INTERFACE_AGU'
    EXPORTING
      im_data   = i_bp_input
      im_source = v_source
*     IM_GUID   =
    IMPORTING
      ex_return = i_bp_return.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_ERROR_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_error_file .
  LOOP AT i_file INTO st_file.
    st_file-msgv1 = text-010.
    st_file-msgty = c_e.
    MODIFY i_file FROM st_file INDEX sy-tabix TRANSPORTING msgv1 msgty.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILE_EXTEND_RELATIONSHIP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_FILE  text
*----------------------------------------------------------------------*
FORM f_file_bp_exist  USING  fp_st_file TYPE zsqtc_bp_update
                             fp_v_bp TYPE bu_partner
                             fp_log_updated TYPE c
                      CHANGING fp_v_error TYPE c.
  DATA : lv_bp_stat  TYPE zprcstat,
         lv_err_type TYPE char2.
*"----------------------------------------------------------------------
*----SLG Log update and Staging table update
*"----------------------------------------------------------------------
  IF fp_log_updated IS INITIAL.
    lv_bp_stat = c_b4. "Inprogress BP Identified
    PERFORM f_log_messages USING fp_st_file lv_bp_stat fp_v_error lv_err_type.
    PERFORM f_bp_rules_comp_sales USING st_bp_rules fp_v_bp fp_st_file
                                                  CHANGING fp_v_error.
  ENDIF.
  IF st_bp_rules-map8_society_partner = abap_true AND v_indirect = abap_true.
    PERFORM f_get_bp_country USING fp_st_file
                                  fp_v_bp.
    IF st_create IS INITIAL AND fp_v_error IS INITIAL AND v_society IS NOT INITIAL.
      PERFORM f_update_partners USING fp_st_file
                                      fp_v_bp
                                CHANGING fp_v_error.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_SHIPTO_SALESORG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LV_SHIPTO_CHECK  text
*----------------------------------------------------------------------*
FORM f_check_shipto_salesorg  USING fp_st_file TYPE zsqtc_bp_update
                              CHANGING fp_lv_shipto_check TYPE c.
  IF fp_st_file-vkorg IN lir_sales_org_ship." AND ( fp_st_file-parvw = c_we OR fp_st_file-parvw = c_sh ).
    fp_lv_shipto_check = abap_true.
  ENDIF.
  IF fp_lv_shipto_check IS INITIAL." AND ( fp_st_file-parvw = c_we OR fp_st_file-parvw = c_sh ).
    READ TABLE lir_sales_org_ship INTO lsr_sales_org_ship WITH KEY salesorg_low = '*'.
    IF sy-subrc EQ 0.
      fp_lv_shipto_check = abap_true.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_SOLDTO_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_FILE  text
*      <--P_V_ERROR  text
*----------------------------------------------------------------------*
FORM f_bp_soldto_check  USING    fp_st_file TYPE zsqtc_bp_update
                        CHANGING fp_v_error TYPE c
                                 fp_lv_err_type TYPE char2
                                 fp_lv_bp_stat  TYPE zprcstat.
*--*Header level, clearing indirect society flag
  IF fp_st_file-head_item = c_h.
    CLEAR : v_indirect.
  ENDIF.
  IF fp_st_file-partner2 IS NOT INITIAL.
*--*Get header info, sold to party and sales area
    READ TABLE i_file INTO DATA(lst_file) WITH KEY identifier = st_file-identifier
                                                   head_item = c_h.
    IF sy-subrc EQ 0.
*--*Get KNMT customer info record using header sold To and sales area
      PERFORM f_get_knmt_record USING fp_st_file lst_file-customer
                                      lst_file-vkorg lst_file-vtweg
                                    CHANGING fp_lv_err_type.
*--*if BP is indirect and Sold-to doesn't match with Society
      IF v_indirect = abap_true AND lst_file-customer NE fp_st_file-partner2.
        fp_v_error = abap_true.
        fp_lv_err_type =  c_err_file_soc.
*--*If First item BP is indirect and subsequent item is not
      ELSEIF v_indirect = abap_true AND fp_lv_err_type IS NOT INITIAL.
        fp_v_error = abap_true.
      ENDIF.
    ENDIF.
    IF fp_v_error = abap_true.
      fp_lv_bp_stat  = c_e1.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_BP_COUNTRY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_V_BP  text
*----------------------------------------------------------------------*
FORM f_get_bp_country  USING  fp_st_file TYPE zsqtc_bp_update
                              fp_v_bp TYPE bu_partner.
  CLEAR: v_bp_country.
  SELECT SINGLE land1 FROM kna1 INTO @v_bp_country WHERE kunnr = @fp_v_bp.
  IF sy-subrc EQ 0 AND v_bp_country IN lir_country.
    v_society = fp_st_file-partner2.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_PARTNER_FUNCTIONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_FUNCTIONS  text
*      -->P_FP_ST_FILE_CUSTOMR  text
*      -->P_FP_ST_FILE_PARTNER2  text
*----------------------------------------------------------------------*
FORM f_build_partner_functions  TABLES   fp_li_functions "STRUCTURE CMDS_EI_FUNCTIONS
                                USING    fp_st_file TYPE zsqtc_bp_update
                                         fp_vkorg TYPE vkorg
                                         fp_v_bp TYPE bu_partner.
  DATA : lst_functions TYPE cmds_ei_functions, "LIKE LINE OF fp_li_functions,
         lv_ktokd      TYPE ktokd,
         li_parvw      TYPE cmds_parvw_t,
         lst_parvw     LIKE LINE OF li_parvw.

  lv_ktokd = lsr_ktokd-low.
  IF fp_st_file-customer IS NOT INITIAL.
    CALL METHOD cmd_ei_api=>get_ktokd
      EXPORTING
        iv_kunnr = fp_st_file-customer
      IMPORTING
        ev_ktokd = lv_ktokd.
  ENDIF.
  IF lv_ktokd IS NOT INITIAL.
*   Get all mandatory partner functions
    CALL METHOD cmd_ei_api_check=>get_mand_partner_functions
      EXPORTING
        iv_ktokd = lv_ktokd
      IMPORTING
        et_parvw = li_parvw.
  ENDIF. " IF lv_ktokd IS NOT INITIAL
  LOOP AT li_parvw INTO lst_parvw.
    lst_functions-data_key-parvw = lst_parvw-parvw.
*    IF fp_st_file-vkorg = fp_vkorg.
    IF lst_parvw-parvw IN lir_parvw AND fp_st_file-vkorg = fp_vkorg.
      lst_functions-data-partner   = fp_st_file-partner2.
*      lst_functions-datax-partner   = abap_true.
    ELSE.
      lst_functions-data-partner   = fp_v_bp.
*      lst_functions-datax-partner = abap_true.
    ENDIF.
*    ENDIF.
    lst_functions-task = c_m.
    APPEND lst_functions TO fp_li_functions.
    CLEAR : lst_functions.
  ENDLOOP.
  v_society = fp_st_file-partner2.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_PARTNERS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_ST_FILE  text
*      -->P_FP_V_BP  text
*      <--P_FP_V_ERROR  text
*----------------------------------------------------------------------*
FORM f_update_partners  USING    fp_st_file TYPE zsqtc_bp_update
                                 fp_v_bp  TYPE bu_partner
                        CHANGING fp_v_error TYPE c.
  DATA : lv_dummy        TYPE abap_bool,
         lst_master_data TYPE cmds_ei_main,
         lst_return      TYPE bapiret2,       " Return Parameter
         lst_error       TYPE cvis_message,
         li_functions    TYPE cmds_ei_functions_t,
         lst_functions   LIKE LINE OF li_functions,
         lst_sales       TYPE cmds_ei_sales,
         li_sales        TYPE cmds_ei_sales_t,
         li_customers    TYPE cmds_ei_extern_t,
         lst_customers   LIKE LINE OF li_customers.
  FREE : lv_dummy,lst_master_data,lst_return,lst_error,lst_sales,li_sales,li_customers,lst_customers.

  PERFORM f_build_partner_functions  TABLES li_functions
                                     USING fp_st_file fp_st_file-vkorg fp_v_bp.
  LOOP AT li_functions ASSIGNING FIELD-SYMBOL(<lfs_function>).
    <lfs_function>-datax-partner = abap_true.
  ENDLOOP.
  lst_sales-functions-functions[] = li_functions[].
  lst_sales-task = c_m.
  lst_sales-data_key-vkorg = fp_st_file-vkorg.
  lst_sales-data_key-vtweg = fp_st_file-vtweg.
  lst_sales-data_key-spart = fp_st_file-spart.
  APPEND lst_sales TO li_sales.
  CLEAR : li_functions[].
  lst_customers-header-object_task = c_m.
  lst_customers-header-object_instance-kunnr = fp_v_bp.
  lst_customers-sales_data-sales[] = li_sales[].
  APPEND  lst_customers TO li_customers.
  CLEAR : lst_customers.

  lst_master_data-customers[] = li_customers[].
  CLEAR : li_customers.
  cmd_ei_api=>maintain(
    EXPORTING
      iv_test_run    = lv_dummy
      is_master_data = lst_master_data
    IMPORTING
      es_error       = lst_error
         ).
  IF lst_error-is_error EQ abap_true.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
      IMPORTING
        return = lst_return.
    fp_v_error = abap_true.
  ELSE. " ELSE -> IF fp_lst_error-is_error EQ abap_true
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait   = abap_true
      IMPORTING
        return = lst_return.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_KNMT_RECORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_ST_FILE  text
*----------------------------------------------------------------------*
FORM f_get_knmt_record  USING  fp_st_file TYPE zsqtc_bp_update
                               fp_soldto TYPE kunnr
                               fp_vkorg TYPE vkorg
                               fp_vtweg TYPE vtweg
                       CHANGING fp_lv_err_type TYPE char2..
  DATA : lv_sortl TYPE sortl.
  CLEAR : lv_sortl.
  SELECT SINGLE
         sortl FROM knmt INTO @lv_sortl WHERE vkorg = @fp_vkorg
                                        AND  vtweg = @fp_vtweg
                                        AND  kunnr = @fp_soldto
                                        AND  matnr = @fp_st_file-matnr.
*--*Material is Indirect society
  IF sy-subrc EQ 0 AND lv_sortl = c_in AND fp_st_file-posnr = c_item.
    v_indirect = abap_true.
*--*First item marked as Indirect but subsequent item not
  ELSEIF sy-subrc NE 0 AND lv_sortl NE c_in AND v_indirect = abap_true.
    fp_lv_err_type = c_err_indirect_item.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BP_RPA_SOURCE_RESULT
*&      Created by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bp_rpa_source_result USING fp_v_source TYPE tpm_source_name
                                  fp_msgnumber TYPE string
                                  fp_msgv1 TYPE bapi_msg
                                  fp_msgty TYPE msgty
                                  fp_partner TYPE bus020_search_result-partner.

  DATA : lv_salesarea TYPE char10,
         lv_kunnr     TYPE kunnr,
         lv_msgno     TYPE zstqtc_bpsearch-msg_number,
         lv_msgv1     TYPE bapi_msg.

  CONSTANTS : lc_sperator         TYPE char01 VALUE '/',      " Sales area separator
              lc_source_separator TYPE char01 VALUE '_'.

  CLEAR : lv_salesarea , lv_msgno.

  CONDENSE fp_v_source NO-GAPS.      " Remove all space and gaps
  " Genarate the message number with combining " 'Source' '_' 'Msg Number'"
  CONCATENATE fp_v_source lc_source_separator fp_msgnumber INTO lv_msgno.
  CASE fp_msgnumber.
    WHEN text-m02.             " BP Not found
      APPEND INITIAL LINE TO i_bp_search_rpa ASSIGNING <st_bp_search_rpa>.
      <st_bp_search_rpa>-msg_number = lv_msgno.
      <st_bp_search_rpa>-msg_text = fp_msgv1.
      <st_bp_search_rpa>-msg_type = fp_msgty.
    WHEN text-m01.         " BP found
      DESCRIBE TABLE i_search_result LINES DATA(lv_record).
      IF lv_record GT 1.  " Multiple BP's found without Sales area data
        CLEAR : lv_msgv1.
        APPEND INITIAL LINE TO i_bp_search_rpa ASSIGNING <st_bp_search_rpa>.
        <st_bp_search_rpa>-msg_number = lv_msgno.
        CONCATENATE fp_partner fp_msgv1 INTO lv_msgv1.
        <st_bp_search_rpa>-msg_text = lv_msgv1.
        <st_bp_search_rpa>-msg_type = fp_msgty.
      ELSE.     " Found single BP
        READ TABLE i_search_result INTO st_search_result INDEX 1.
        APPEND INITIAL LINE TO i_bp_search_rpa ASSIGNING <st_bp_search_rpa>.
        <st_bp_search_rpa>-msg_number = lv_msgno.
        CONCATENATE st_search_result-partner fp_msgv1 INTO fp_msgv1 .
        <st_bp_search_rpa>-msg_text = fp_msgv1.
        <st_bp_search_rpa>-msg_type = fp_msgty.
      ENDIF.
    WHEN text-m03.         " Multiple BP and Multiple sales areas
      " Build the sales are combining Sales org/stribution channel/Division
      LOOP AT i_knvv ASSIGNING <gfs_knvv> WHERE kunnr = fp_partner.
        CLEAR : lv_msgv1.
        APPEND INITIAL LINE TO i_bp_search_rpa ASSIGNING <st_bp_search_rpa>.
        <st_bp_search_rpa>-msg_number = lv_msgno.
        CONCATENATE <gfs_knvv>-vkorg lc_sperator <gfs_knvv>-vtweg
                    lc_sperator <gfs_knvv>-spart INTO lv_salesarea.
        " Build RPA return messege text for multiple BP found.
        CONCATENATE lv_salesarea text-018 INTO lv_msgv1.
        <st_bp_search_rpa>-msg_text = lv_msgv1.
        <st_bp_search_rpa>-msg_type = fp_msgty.
      ENDLOOP.
    WHEN text-m05.         " Generic messegae
      APPEND INITIAL LINE TO i_bp_search_rpa ASSIGNING <st_bp_search_rpa>.
      IF v_sales_block = abap_true.
        <st_bp_search_rpa>-msg_number = lv_msgno.
        <st_bp_search_rpa>-msg_text = fp_msgv1.
        <st_bp_search_rpa>-msg_type = fp_msgty.
      ELSE.
        <st_bp_search_rpa>-msg_number = lv_msgno.
        <st_bp_search_rpa>-msg_text = fp_msgv1.
      ENDIF.
    WHEN text-m06.         " BP found but No sales areas in SAP
      APPEND INITIAL LINE TO i_bp_search_rpa ASSIGNING <st_bp_search_rpa>.
      <st_bp_search_rpa>-msg_number = lv_msgno.
      <st_bp_search_rpa>-msg_text = fp_msgv1.
      <st_bp_search_rpa>-msg_type = fp_msgty.
    WHEN text-m04.         " Invalid email address
      APPEND INITIAL LINE TO i_bp_search_rpa ASSIGNING <st_bp_search_rpa>.
      <st_bp_search_rpa>-msg_number = lv_msgno.
      <st_bp_search_rpa>-msg_text = fp_msgv1.
      <st_bp_search_rpa>-msg_type = fp_msgty.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_RPA_BP_SALES_AREA
*&      Created by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_SEARCH_RESULT  text
*----------------------------------------------------------------------*
FORM f_rpa_bp_sales_area  TABLES fp_i_kna1 STRUCTURE st_kna1.

  DATA : li_return  TYPE STANDARD TABLE OF bapiret2,
         lst_return TYPE bapiret2,
         li_roles   TYPE STANDARD TABLE OF bapibus1006_roles,
         lst_roles  TYPE bapibus1006_roles.

  FIELD-SYMBOLS : <lfs_bus020_search_result> TYPE ty_kna1.

  REFRESH i_knvv[].

  SORT fp_i_kna1 BY kunnr.
  DELETE ADJACENT DUPLICATES FROM fp_i_kna1 COMPARING kunnr.
*--*Check each BP sales role
  LOOP AT fp_i_kna1 ASSIGNING <lfs_bus020_search_result>.
    CALL FUNCTION 'BAPI_BUPA_ROLES_GET'
      EXPORTING
        businesspartner      = <lfs_bus020_search_result>-kunnr
      TABLES
        businesspartnerroles = li_roles
        return               = li_return.
**--*If sales role exist check sales block
    READ TABLE li_roles INTO lst_roles WITH KEY partnerrole = c_ism000.
    IF sy-subrc EQ 0.
*  Fetch Sales area data for Sales non-block customers
      SELECT kunnr,vkorg,vtweg,spart
        FROM knvv APPENDING TABLE @i_knvv
        WHERE kunnr = @<lfs_bus020_search_result>-kunnr AND
              aufsd = @space.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_EMAIL
*&      Created by Lahiru on 07/24/2020 for ERPM-22299 with ED2K918959
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_FILE  text
*----------------------------------------------------------------------*
FORM f_validate_email  USING fp_st_file TYPE zsqtc_bp_update
                       CHANGING v_invalid_email TYPE char01.

  DATA : lst_address TYPE sx_address.

  CONSTANTS : lc_type TYPE sx_address-type VALUE 'INT'.

  IF fp_st_file-smtp_addr IS NOT INITIAL.

    lst_address-address = fp_st_file-smtp_addr.
    lst_address-type = lc_type.

    CALL FUNCTION 'SX_INTERNET_ADDRESS_TO_NORMAL'
      EXPORTING
        address_unstruct    = lst_address
        complete_address    = abap_true
      EXCEPTIONS
        error_address_type  = 1
        error_address       = 2
        error_group_address = 3
        OTHERS              = 4.
    IF sy-subrc <> 0.
      v_invalid_email = abap_true.
    ENDIF.

  ENDIF.

ENDFORM.

FORM f_validate_search_result.

  CASE v_source.
    WHEN c_source_rpa.      " Input source is equal to RPA
      IF st_bp_rules IS NOT INITIAL.              " BP rule is found
        IF i_search_result IS NOT INITIAL.        " BP is Found for given search result
          IF v_bp IS INITIAL.                     " Multiple BP code found in the BP master for the Same date, then return the lowest BP
            REFRESH i_search_result[].
            DATA(i_but_bp_tmp) = i_but_bp[].      " BP master data assign to temp table
            SORT i_but_bp_tmp BY partner.
            LOOP AT i_but_bp_tmp ASSIGNING FIELD-SYMBOL(<lfs_but_bp_tmp>).
              IF sy-tabix NE 1.       " Keep the lowest record in the Itab
                DELETE i_but_bp_tmp INDEX sy-tabix.
              ENDIF.
            ENDLOOP.
            MOVE-CORRESPONDING i_but_bp_tmp TO i_search_result.
          ELSE.                       " Delete Non relevant BP's, found after most accurate BP
            DELETE i_search_result WHERE partner NE v_bp.
          ENDIF.
          " Check whether BP completely block for the sales
          PERFORM f_rpa_bp_overall_sales_block TABLES i_search_result.
          IF i_kna1 IS INITIAL.     " Check SAP is blocked the all the sales area
            " Displaying all sales areas blocked and return error messege to generate the BP
            v_sales_block = abap_true.
            PERFORM f_bp_rpa_source_result USING v_source text-m05 text-022 c_msgty_err v_bp_non.
            CLEAR v_sales_block.
          ELSE.
            PERFORM f_rpa_bp_sales_area TABLES i_kna1.
            IF i_knvv IS NOT INITIAL.         " Check SAP is having the specific non blocked Sales area data
              " Displaying multiple messages with handling single & multiple records
              LOOP AT i_kna1 INTO st_kna1.
                PERFORM f_bp_rpa_source_result USING v_source text-m01 text-017 c_msgty_succ st_kna1-kunnr.     " BP Found
                PERFORM f_bp_rpa_source_result USING v_source text-m03 text-018 c_msgty_info st_kna1-kunnr.     " having Sales area
              ENDLOOP.
            ELSE.
              " Displaying multiple messages with handling single & multiple records
              LOOP AT i_kna1 INTO st_kna1.
                PERFORM f_bp_rpa_source_result USING v_source text-m01 text-017 c_msgty_succ st_kna1-kunnr.     " BP Found
                PERFORM f_bp_rpa_source_result USING v_source text-m06 text-020 c_msgty_info st_kna1-kunnr.     " No Sales area in SAP
              ENDLOOP.
            ENDIF.
          ENDIF.
        ELSE.         " BP is not found
          PERFORM f_bp_rpa_source_result USING v_source text-m02 text-016 c_msgty_info v_bp.
        ENDIF.
      ELSE.           " BP rule is not found
        PERFORM f_bp_rpa_source_result USING v_source text-m05 text-010 c_msgty_info v_bp.
      ENDIF.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_RPA_BP_OVERALL_SALES_BLOCK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_SEARCH_RESULT  text
*----------------------------------------------------------------------*
FORM f_rpa_bp_overall_sales_block  TABLES fp_i_search_result STRUCTURE bus020_search_result.

  DATA : li_return  TYPE STANDARD TABLE OF bapiret2,
         lst_return TYPE bapiret2,
         li_roles   TYPE STANDARD TABLE OF bapibus1006_roles,
         lst_roles  TYPE bapibus1006_roles.

  FIELD-SYMBOLS : <lfs_bus020_search_result> TYPE bus020_search_result.

  REFRESH i_kna1[].

  IF i_search_result IS NOT INITIAL.
    SORT fp_i_search_result BY partner.
    DELETE ADJACENT DUPLICATES FROM fp_i_search_result COMPARING partner.
*--*Check each BP sales role
    LOOP AT fp_i_search_result ASSIGNING <lfs_bus020_search_result>.
      CALL FUNCTION 'BAPI_BUPA_ROLES_GET'
        EXPORTING
          businesspartner      = <lfs_bus020_search_result>-partner
        TABLES
          businesspartnerroles = li_roles
          return               = li_return.
**--*If sales role exist check sales block
      READ TABLE li_roles INTO lst_roles WITH KEY partnerrole = c_ism000.
      IF sy-subrc EQ 0.
** Fecth Customer overall sales block
        SELECT kunnr,aufsd
          FROM kna1 APPENDING TABLE @i_kna1
          WHERE kunnr = @<lfs_bus020_search_result>-partner AND
                aufsd = @space.
      ENDIF.
    ENDLOOP.
    SORT i_kna1 BY kunnr.
  ENDIF.

ENDFORM.
