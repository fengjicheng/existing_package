*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_FG_BP_INTERFACE_AGUTOP
* PROGRAM DESCRIPTION: Create BP with Comapny Code data,Sales Data,
*                      Collection & Credit management data
* DEVELOPER: Prabhu
* CREATION DATE: 09/07/2019
* OBJECT ID: I0368
* TRANSPORT NUMBER(S): ED2K916061
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K917990
* REFERENCE NO: ERPM-10797
* DEVELOPER:    Prabhu
* DATE:         4/15/2020
* DESCRIPTION:  Skip Postal code validation for Ireland country
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K918028
* REFERENCE NO: ERPM-3369
* DEVELOPER:    Prabhu
* DATE:         4/21/2020
* DESCRIPTION:  Update BP address when Indicator is COA(Change of address)
*&---------------------------------------------------------------------*
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
FUNCTION-POOL zqtc_fg_bp_interface.     "MESSAGE-ID ..

* INCLUDE LZQTC_FG_BP_INTERFACE_AGUD...      " Local class definition
TYPES:BEGIN OF ty_partner,
        partner      TYPE  bu_partner,               " Business Partner Number
        partner_guid TYPE	 bu_partner_guid,          " Business Partner GUID
        xdele        TYPE  bu_xdele,                 " Business Partner Archive status
      END OF ty_partner,

*** Changes to fine tune SLG Logs
      BEGIN OF ty_log_info,
        identifier  TYPE char10,
        hier_level  TYPE i,
        msgtype     TYPE symsgty,
        message     TYPE char255,
        header_flag TYPE abap_bool,
        nodetype    TYPE char1,
      END OF ty_log_info,

      BEGIN OF ty_partner_id,
        partner  TYPE  bu_partner,                   " Business Partner Number
        type     TYPE  bu_id_type,
        idnumber TYPE  bu_id_number,                 " Identification Number
        katr4    TYPE  katr4,
      END OF ty_partner_id,
      BEGIN OF ty_partner_detail,
        identificationcategory TYPE  bu_id_category, " BP Identification Category
        identificationnumber   TYPE  bu_id_number,   " Identification Number
      END OF ty_partner_detail,

      BEGIN OF lty_syst_no,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE syst_msgno,
        high   TYPE syst_msgno,
      END OF lty_syst_no,
      BEGIN OF lty_syst_id,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE syst_msgid,
        high   TYPE syst_msgid,
      END OF lty_syst_id,
      BEGIN OF lty_ext_id_type,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE syst_msgid,
        high   TYPE syst_msgid,
      END OF lty_ext_id_type,
      BEGIN OF lty_bu_group,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE bu_group,
        high   TYPE bu_group,
      END OF lty_bu_group,
      BEGIN OF lty_bu_type,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE bu_type,
        high   TYPE bu_type,
      END OF lty_bu_type,
      BEGIN OF lty_rltyp,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE bu_partnerrole,
        high   TYPE bu_partnerrole,
      END OF lty_rltyp,
      BEGIN OF lty_bptaxnum,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE bptaxnum,
        high   TYPE bptaxnum,
      END OF lty_bptaxnum,
      BEGIN OF lty_taxtype,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE taxtype,
        high   TYPE taxtype,
      END OF lty_taxtype,
      BEGIN OF lty_katr6,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE katr6,
        high   TYPE katr6,
      END OF lty_katr6,
      BEGIN OF lty_dzterm,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE dzterm,
        high   TYPE dzterm,
      END OF lty_dzterm,
      BEGIN OF lty_xzver,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE xzver,
        high   TYPE xzver,
      END OF lty_xzver,
      BEGIN OF lty_mahna,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE mahna,
        high   TYPE mahna,
      END OF lty_mahna,
      BEGIN OF lty_xausz,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE xausz,
        high   TYPE xausz,
      END OF lty_xausz,
      BEGIN OF lty_kdgrp,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE kdgrp,
        high   TYPE kdgrp,
      END OF lty_kdgrp,
      BEGIN OF lty_kalks,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE kalks,
        high   TYPE kalks,
      END OF lty_kalks,
      BEGIN OF lty_versg,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE versg,
        high   TYPE versg,
      END OF lty_versg,
      BEGIN OF lty_ktgrd,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE ktgrd,
        high   TYPE ktgrd,
      END OF lty_ktgrd,
      BEGIN OF lty_title,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE ad_titletx,
        high   TYPE ad_titletx,
      END OF lty_title,

      BEGIN OF lty_taxkd,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE takld,
        high   TYPE takld,
      END OF lty_taxkd,
      BEGIN OF lty_kvgr1,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE kvgr1,
        high   TYPE kvgr1,
      END OF lty_kvgr1,
      BEGIN OF lty_coll_profile,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE udm_coll_profile,
        high   TYPE udm_coll_profile,
      END OF   lty_coll_profile,
      BEGIN OF lty_credit_group,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE ukm_cred_group,
        high   TYPE ukm_cred_group,
      END OF lty_credit_group,
      BEGIN OF lty_coll_seg,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE bdm_coll_segment,
        high   TYPE bdm_coll_segment,
      END OF lty_coll_seg,
      BEGIN OF lty_sort_key,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE dzuawa,
        high   TYPE dzuawa,
      END OF lty_sort_key,
      BEGIN OF lty_fte,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE bu_type,
        high   TYPE zzfte,
      END OF lty_fte,
      ltt_msgno      TYPE STANDARD TABLE OF lty_syst_no INITIAL SIZE 0,
      ltt_msgid      TYPE STANDARD TABLE OF lty_syst_id INITIAL SIZE 0,
      ltt_ext_id_typ TYPE STANDARD TABLE OF lty_ext_id_type INITIAL SIZE 0,
      BEGIN OF gty_ext_id_data,       "for external ID infromation
        seq_id      TYPE numc4,
        id_category TYPE  bu_id_type,
        id_number   TYPE  bu_id_number,
        bp_number   TYPE bu_partner,
      END OF gty_ext_id_data.
TYPES: BEGIN OF ty_constant,
         devid    TYPE zdevid,              " Development ID
         param1   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         param2   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         srno     TYPE tvarv_numb,          " ABAP: Current selection number
         sign     TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti     TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low      TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high     TYPE salv_de_selopt_high, " Upper Value of Selection Condition
         activate TYPE zconstactive,      "Activation indicator for constant
       END OF ty_constant,
       tt_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0
                WITH NON-UNIQUE SORTED KEY variable COMPONENTS param1.
TYPES : BEGIN OF ty_create,
          gen_data       TYPE c,
          comp_data      TYPE c,
          sales_data     TYPE c,
          relation       TYPE c,
          assign_bp      TYPE c,
          close_previous TYPE c,
          credit         TYPE c,
          collection     TYPE c,
        END OF ty_create,
        BEGIN OF ty_sales_ref,
          id               TYPE numc5,
          country_name     TYPE	landx,
          country_iso_code TYPE intca3,
          country_sap      TYPE land1,
          currency_code    TYPE	waers,
          compaany_code	   TYPE bukrs,
          price_list       TYPE pltyp,
        END OF ty_sales_ref,
        BEGIN OF ty_t001,
          bukrs TYPE bukrs, "Comp code
          kkber TYPE kkber, "Credit control area
        END OF ty_t001,
        BEGIN OF ty_ukm_kkber2,
          kkber	       TYPE kkber,
          credit_sgmnt TYPE   ukm_pi_credit_sgmnt,
        END OF ty_ukm_kkber2,
        BEGIN OF ty_def_credit,
          credit_group TYPE	ukm_cred_group,
          land1	       TYPE land1_gp,
          credit_sgmnt TYPE ukm_credit_sgmnt,
          vkorg	       TYPE vkorg,
          vtweg	       TYPE vtweg,
          spart	       TYPE spart,
          risk_class   TYPE   ukm_risk_class,
          check_rule   TYPE ukm_check_rule,
          credit_limit TYPE	ukm_credit_limit,
        END OF ty_def_credit,
        BEGIN OF ty_coll,
          coll_segment    TYPE bdm_coll_segment,
          credit_group    TYPE  ukm_cred_group,
          land1           TYPE  land1,
          regio           TYPE regio,
          vkorg           TYPE  vkorg,
          vtweg	          TYPE vtweg,
          spart	          TYPE spart,
          busab	          TYPE busab,
          coll_group      TYPE udm_coll_group,
          coll_specialist	TYPE bdm_coll_specialist,
          coll_supervisor	TYPE zcoll_supervisor,
        END OF ty_coll,
        BEGIN OF ty_cust_grp,
          tier1                  TYPE char40,
          tier2                  TYPE char40,
          tier3                  TYPE char40,
          cust_group_sap         TYPE char5,
          description            TYPE char100,
          cust_credit_group	     TYPE  ukm_cred_group,
          cust_credit_group_text TYPE ukm_cred_group_txt,
        END OF ty_cust_grp,
        BEGIN OF ty_risk_check,
          cust_credit_group	TYPE ukm_cred_group,
          country	          TYPE land1,
          credit_segment    TYPE  ukm_credit_sgmnt,
          risk_class        TYPE  ukm_risk_class,
          credit_chk_rule	  TYPE ukm_check_rule,
        END OF ty_risk_check,
        BEGIN OF ty_t005,
          land1  TYPE land1,
          intca3 TYPE intca3,
        END OF ty_t005,
        BEGIN OF ty_tsad3t,
          langu      TYPE spras,
          title      TYPE ad_title,
          title_medi TYPE ad_titletx,
        END OF ty_tsad3t,
        BEGIN OF ty_bsid,
          bukrs TYPE bukrs,
          kunnr TYPE kunnr,
          cpudt TYPE cpudt,
        END OF ty_bsid,
        BEGIN OF ty_but000,
          partner TYPE bu_partner,
          crdat   TYPE bu_crdat,
        END OF ty_but000,
**** Begin of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
        BEGIN OF ty_knvv,
          kunnr TYPE kunnr,
          vkorg TYPE  vkorg,
          vtweg TYPE vtweg,
          spart TYPE spart,
        END OF ty_knvv,
**** End of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
        BEGIN OF ty_kna1,
          kunnr TYPE kunnr,
          aufsd TYPE aufsd,
        END OF ty_kna1.
*====================================================================*
* Table types
*====================================================================*
TYPES:tty_partner_id  TYPE STANDARD TABLE OF ty_partner_id
                                    INITIAL SIZE 0,
      tty_partner     TYPE STANDARD TABLE OF ty_partner
                                    INITIAL SIZE 0,
      tty_partner_det TYPE STANDARD TABLE OF ty_partner_detail
                                    INITIAL SIZE 0,
      tty_edidd       TYPE STANDARD TABLE OF edi_dd " Data record for the interface to the EDI subsystem
                                    INITIAL SIZE 0,  " Data record for the interface to the EDI subsystem
      tty_trtab       TYPE STANDARD TABLE OF trtab
                                    INITIAL SIZE 0,
      tty_log_info    TYPE STANDARD TABLE OF ty_log_info
                                    INITIAL SIZE 0.
*====================================================================*
*  Global Internal table & Structures
*====================================================================*
DATA: i_cust_input         TYPE ztqtc_customer_date_inputs,
      i_relationship_data  TYPE burs_ei_extern_t,
      i_comp_data          TYPE cmds_ei_company_t,
      i_sales_data         TYPE cmds_ei_sales_t,
      i_coll_return        TYPE bapiretct,
      i_address_data       TYPE bus_ei_bupa_address_t,
      i_crdt_seg           TYPE ztqtc_credit_seg_data,
      i_coll_seg           TYPE ztqtc_collection_seg_data,
      i_but000             TYPE tty_partner,
      i_but0id             TYPE tty_partner_id,
      i_relat_but0id       TYPE tty_partner_id,
      i_partner_det        TYPE tty_partner_det,
      i_return_relat       TYPE bapiretm,
      lr_msgno             TYPE ltt_msgno,
      lst_msgno            TYPE lty_syst_no,
      lr_ext_id_typ        TYPE ltt_ext_id_typ,
      lr_msgid             TYPE ltt_msgid,
      lst_msgid            TYPE lty_syst_id,
      lst_ext_id_typ       TYPE lty_syst_id,
      i_return             TYPE STANDARD TABLE OF bapiret2 " Return Parameter
                                INITIAL SIZE 0,         "Return Parameter
      i_log_info           TYPE tty_log_info,     " Itab: Application Log table
      lst_zqtc_ext_ident   TYPE zqtc_ext_ident,
      lt_zqtc_ext_ident    TYPE TABLE OF zqtc_ext_ident,
      li_constant          TYPE tt_constant,
      i_input              TYPE ztqtc_bp_input_i0368,
      i_output             TYPE ztqtc_bp_output_i0368,
      st_input             TYPE zsqtc_bp_input_i0368,
      st_country           TYPE shp_land1_range,
      i_country            TYPE STANDARD TABLE OF shp_land1_range,
      st_output            TYPE zsqtc_bp_output_i0368,
      i_out_ret            TYPE ztqtc_bp_output_i0368,
      i_bp_input           TYPE ztqtc_customer_date_inputs,
      i_bp_return          TYPE ztqtc_customer_date_outputs,
      st_bp_input          TYPE zstqtc_customer_date_input,
      st_create            TYPE ty_create,
      i_sale_ref           TYPE STANDARD TABLE OF ty_sales_ref,
      i_risk_check         TYPE STANDARD TABLE OF ty_risk_check,
      i_cust_grp           TYPE STANDARD TABLE OF ty_cust_grp,
      i_coll               TYPE STANDARD TABLE OF ty_coll,
      i_credit             TYPE STANDARD TABLE OF zrtr_def_credit,
      i_t001               TYPE STANDARD TABLE OF ty_t001,
      i_t001cm             TYPE STANDARD TABLE OF ty_t001,
      i_t005               TYPE STANDARD TABLE OF ty_t005,
      i_tsad3t             TYPE STANDARD TABLE OF ty_tsad3t,
      st_tsad3t            TYPE ty_tsad3t,
      st_t005              TYPE ty_t005,
      st_t001              TYPE ty_t001,
      st_t001cm            TYPE ty_t001,
      i_ukm_kkber2         TYPE STANDARD TABLE OF ty_ukm_kkber2,
      st_ukm_kkber2        TYPE ty_ukm_kkber2,
      i_def_credit         TYPE STANDARD TABLE OF ty_def_credit,
      st_def_credit        TYPE ty_def_credit,
      gs_ext_id            TYPE          gty_ext_id_data,
      gt_ext_id_input      TYPE TABLE OF gty_ext_id_data,
      gt_ext_id_seq        TYPE TABLE OF gty_ext_id_data, "External ID infromation in DB
      gv_message           TYPE          char200,
      gv_return_msg        TYPE          bapiretc,
      gv_id_err            TYPE          xfeld,          "error flag, duplicate external ID error check/ payload error/data inconcistency
      gv_guid              TYPE          idoccarkey,
      gv_support_mode      TYPE          char1,
      gv_relationships_err TYPE          abap_bool,
      gt_sales_data        TYPE cmds_ei_sales_t,
      lv_result(1)         TYPE c,
      lv_status,
      i_file               TYPE STANDARD TABLE OF zsqtc_bp_update,
      i_search_result      TYPE STANDARD TABLE OF bus020_search_result,
      i_staging            TYPE STANDARD TABLE OF ze225_staging,
      i_bsid               TYPE STANDARD TABLE OF ty_bsid,
      i_but_bp             TYPE STANDARD TABLE OF ty_but000,
**** Begin of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
      i_bp_search_rpa      TYPE ztqtc_bpsearch,                     " Table type for RPA BP Search export parameter
      i_knvv               TYPE STANDARD TABLE OF ty_knvv,          " Itab for Customer master Sales data
      i_kna1               TYPE STANDARD TABLE OF ty_kna1,          " Itab for Customer master general data
**** End of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
*====================================================================*
*  Global Structure
*====================================================================*
      st_cust_input        TYPE zstqtc_customer_date_input,    "I0200: Customer Data (Gen, Comp Code, Sales Area, Crdt/Coll)
      st_crdt_coll_data    TYPE zstqtc_credit_collection_data, "I0200: Customer master data distribution - Credit/Collection
      st_data_key          TYPE zstqtc_bp_identification_key,  "I0200: Customer master data distribution - Credit/Collection
      st_person            TYPE bus_ei_struc_central_person,   "Ext. Interface: Structure CENTRAL_PERSON
      st_org               TYPE bus_ei_struc_central_organ,    "Ext. Interface: Structure CENTRAL_ORGANIZATION
      st_error             TYPE cvis_message,                  "Error Indicator and System Messages
      st_relat             TYPE burs_ei_extern,                "Complex External Interface of a Relationship
      st_partner_det       TYPE ty_partner_detail,
      st_master_data       TYPE cmds_ei_main,                  " Ext. Interface: Total Customer Data
      st_add_general_data  TYPE cmds_ei_central_data,          "Additional General data
      st_log_info          TYPE ty_log_info,
      st_bp_rules          TYPE zqtc_bp_rules,
      st_staging           TYPE ze225_staging,
      st_search_result     TYPE bus020_search_result,
      st_file              TYPE zsqtc_bp_update,
      st_bsid              TYPE ty_bsid,
      st_but_bp            TYPE ty_but000,
      st_bp_coa            TYPE bus_partner_guid,
      st_kna1              TYPE ty_kna1,
*====================================================================*
*  Global Variable
*====================================================================*
      v_partner            TYPE bu_partner,         " Business Partner Number
      v_dummy              TYPE abap_bool,
      v_error              TYPE c,
      v_cust_string(110)   TYPE c,
      v_validation_success TYPE abap_bool VALUE 'X',
      v_log_handle         TYPE balloghndl,         " Application Log: Log Handle
      v_index              TYPE sy-index,           " ABAP System Field: Loop Index
      v_object_inst        TYPE bus_ei_object_task, " External Interface: Change Indicator Object
      v_partner_exists     TYPE xfeld,              " Checkbox
      v_source             TYPE tpm_source_name,    " ADD: ERP-7006 KKR20181001  ED2K913240
      v_bp                 TYPE bu_partner,         " Business Partner Number
      v_actv_flag_i0200    TYPE zactive_flag,
      v_validity_year      TYPE numc2,
      v_bp_country         TYPE land1,
      v_society            TYPE bu_partner,
      v_indirect           TYPE c,
**** Begin of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
      v_invalid_email      TYPE char01,
      v_bp_non             TYPE bu_partner,         " Business Partner Number
      v_sales_block        TYPE char1.
**** End of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****

DATA : lsr_comm_type      TYPE rn2range_comm_type,
       lsr_bu_group       TYPE lty_bu_group,
       lsr_bu_type        TYPE lty_bu_type,
       lsr_spras          TYPE ehs00_spras_range,
       lsr_rel_type       TYPE lty_rltyp,
       lir_rel_type       TYPE STANDARD TABLE OF lty_rltyp,
       lsr_bptaxnum       TYPE lty_bptaxnum,
       lsr_taxtype        TYPE lty_taxtype,
       lsr_katr6          TYPE lty_katr6,
       lsr_akont          TYPE rpfifr_akont_struct,
       lsr_zterm          TYPE lty_dzterm,
       lsr_xzver          TYPE lty_xzver,
       lsr_mahna          TYPE lty_mahna,
       lsr_xausz          TYPE lty_xausz,
       lsr_end_date       TYPE bapireprequest_dates,
       lsr_vtweg          TYPE edm_vtweg_range,
       lsr_spart          TYPE edm_spart_range,
       lsr_kdgrp          TYPE lty_kdgrp,
       lsr_kalks          TYPE lty_kalks,
       lsr_vrseg          TYPE lty_versg,
       lsr_lprio          TYPE rjvsd_lprio_range,
       lsr_vsbed          TYPE shp_vsbed_range,
       lsr_inco1          TYPE shp_inco1_range,
       lsr_inco2          TYPE shp_inco2_range,
       lsr_ktgrd          TYPE lty_ktgrd,
       lsr_taxkd          TYPE lty_taxkd,
       lsr_tatyp          TYPE kschl_ran,
       lsr_parvw          TYPE shp_parvw_range,
       lsr_title          TYPE lty_title,
       i_title            TYPE STANDARD TABLE OF lty_title,
       lir_parvw          TYPE STANDARD TABLE OF shp_parvw_range,
       lsr_sort_key       TYPE lty_sort_key,
       lsr_fte            TYPE lty_fte,
       lir_fte            TYPE STANDARD TABLE OF lty_fte,
       lsr_agu            TYPE bapi_rangeskunnr,
       lsr_kvgr1          TYPE lty_kvgr1,
       lsr_coll_profile   TYPE lty_coll_profile,
       lsr_credit_group   TYPE lty_credit_group,
       lsr_ktokd          TYPE /hoag/abs_rg_ktokd,
       lsr_coll_seg       TYPE  lty_coll_seg,
       lir_coll_seg       TYPE STANDARD TABLE OF lty_coll_seg,
       lir_ctry_comp      TYPE RANGE OF salv_de_selopt_low,
       lir_ctry_e184      TYPE RANGE OF salv_de_selopt_low,
       lir_country        TYPE RANGE OF salv_de_selopt_low,
       r_rel_categories   TYPE RANGE OF bu_reltyp,
       lsr_sales_org_ship TYPE bapidlv_range_vkorg,
       lir_sales_org_ship TYPE STANDARD TABLE OF bapidlv_range_vkorg,
*--*BOC ERPM-10797 ED2K917990 Prabhu 4/15/2020
       lir_ctry_postal    TYPE STANDARD TABLE OF shp_land1_range,
       lsr_ctry_postal    TYPE shp_land1_range.
*--*EOC ERPM-10797 ED2K917990 Prabhu 4/15/2020
*====================================================================*
*  Global Constants
*====================================================================*
CONSTANTS: c_bal_obj                 TYPE balobj_d           VALUE 'ZQTC',     "Application Log: Object Name
           c_bal_sub                 TYPE balsubobj          VALUE 'ZBP_CUST', "Application Log: Subobject
           c_land_br                 TYPE land1              VALUE 'BR',       "Country: Brazil
           c_katr4_loc               TYPE katr4              VALUE 'L',        "Cust Attr 4: Location
           c_u                       TYPE bus_ei_object_task VALUE 'U',        "External Interface: Change Indicator Object
           c_m                       TYPE bus_ei_object_task VALUE 'M',        "External Interface: Change Indicator Object
           c_s                       TYPE bus_ei_object_task VALUE 'S',        "External Interface: Change Indicator Object
           c_bp                      TYPE char2              VALUE 'BP',       " Business Parttner
           c_i                       TYPE bus_ei_object_task VALUE 'I',        "External Interface: Change Indicator Object
           c_eq                      TYPE char2 VALUE 'EQ',
           c_e                       TYPE c VALUE 'E',
           c_msgty_info              TYPE symsgty            VALUE 'I',        "Message Type - (I)nformation
           c_msgty_err               TYPE symsgty            VALUE 'E',        "Message Type - (E)rror
           c_msgid_f2                TYPE symsgid            VALUE 'F2',       "Message Class - F2
           c_msgno_042               TYPE symsgno            VALUE '042',      "Message Number - 042
           c_msgid_mc                TYPE symsgid            VALUE 'MC',       "Message Class - MC
           c_msgno_601               TYPE symsgno            VALUE '601',      "Message Number - 601
           c_msgid_zrtr              TYPE symsgid            VALUE 'ZRTR_R1B', "Message Class - ZRTR_R1B
           c_msgno_000               TYPE symsgno            VALUE '000',      "Message Number - 000
           c_msgno_026               TYPE symsgno            VALUE '026',      "Message Number - 025
           c_dup_id_chk              TYPE rvari_vnam         VALUE 'DUPLICATE_ID_CHK',
           c_ext_id_typ              TYPE rvari_vnam         VALUE 'LEGACY_ID_TYPE',
           c_req_source_cdm          TYPE tpm_source_name    VALUE 'CDM',
           c_req_source_eep          TYPE tpm_source_name    VALUE 'EEP',
           c_req_source_pdmicrosites TYPE tpm_source_name    VALUE 'PDMicroSites',
           c_req_source_sfdc         TYPE tpm_source_name    VALUE 'SFDC',
           c_req_source_vchcrm       TYPE tpm_source_name    VALUE 'VCHCRM',
           c_req_source_whe          TYPE tpm_source_name    VALUE 'WHE',
           c_req_source_wolppv       TYPE tpm_source_name    VALUE 'WOLPPV',
           c_id_ecid                 TYPE bu_id_type         VALUE 'ZECID',
           c_reltype                 TYPE bu_id_type         VALUE 'ZRLCT', " Identification Type: Valid Relationship Category.
           c_nodetype_h              TYPE char1              VALUE 'H',
           c_nodetype_i              TYPE char1              VALUE 'I',
           c_us                      TYPE land1              VALUE 'US',
           c_input_data              TYPE char10             VALUE '1INPUT_DATA',
           c_gen_data                TYPE char10             VALUE '2GEN_DATA',
           c_comp_sales              TYPE char10             VALUE '3COMP_SALES',
           c_cred_coll               TYPE char10             VALUE '4CRED_COLL',
           c_relations               TYPE char10             VALUE '5RELATIONS',
           c_commtyp_int             TYPE ad_comm            VALUE 'INT',
           c_commtyp_let             TYPE ad_comm            VALUE 'LET',
           c_zsfci                   TYPE but0id-type  VALUE 'ZSFCI',
           c_zcaaid                  TYPE but0id-type VALUE 'ZCAAID',
           c_zecid                   TYPE but0id-type VALUE 'ZECID',
           c_i0200                   TYPE zdevid      VALUE 'I0200',
           c_lock_msgno              TYPE rvari_vnam VALUE 'LOCK_MSGNR',
           c_support_mod             TYPE rvari_vnam VALUE 'SUPPORT_MODE',
           c_lock_msgid              TYPE rvari_vnam VALUE 'LOCK_MSGID',
           c_expiry                  TYPE rvari_vnam  VALUE 'EXPIRY_DATE',
           c_appl                    TYPE expiry_date VALUE 'APPL_LOG',
           c_bukrs                   TYPE bukrs VALUE '1001',
           c_vkorg                   TYPE vkorg VALUE '1001',
           c_vtweg                   TYPE vtweg VALUE '00',
           c_spart                   TYPE spart VALUE '00',
*           c_agu                     TYPE kunnr VALUE '1002549179',
           c_member                  TYPE bu_reltyp VALUE 'MEMBER',
           c_student                 TYPE bu_reltyp VALUE 'STUDEN',
           c_zir001                  TYPE bu_reltyp VALUE 'ZIR001',
           c_zir002                  TYPE bu_reltyp VALUE 'ZIR002',
           c_ism000                  TYPE bu_role VALUE 'ISM000',
           c_title_dot               TYPE c VALUE '.',
           c_zmemid                  TYPE bu_reltyp VALUE 'ZMEMID',
           c_relcat_zpr008           TYPE bu_reltyp          VALUE 'ZPR008',
           c_0101                    TYPE char4              VALUE '0101',
           c_1231                    TYPE char4              VALUE '1231',
           c_block                   TYPE char2 VALUE 'BL', "block
           c_in                      TYPE land1 VALUE 'IN',
           c_au                      TYPE land1 VALUE 'AU',
           c_new_country             TYPE land1 VALUE 'NU',
           c_ar_but                  TYPE char2 VALUE 'BU', "
           c_b1                      TYPE char2 VALUE 'B1',
           c_b2                      TYPE char2 VALUE 'B2',
           c_b3                      TYPE char2 VALUE 'B3',
           c_b4                      TYPE char2 VALUE 'B4',
           c_e1                      TYPE char2 VALUE 'E1',
           c_ad                      TYPE char2 VALUE 'AD',
           c_id                      TYPE char2 VALUE 'ID',
           c_in_file                 TYPE char2 VALUE 'IF', "India FIle
           c_au_file                 TYPE char2 VALUE 'AF', "AU file
           c_new_country_file        TYPE char2 VALUE 'NF', "AU file
           c_sp                      TYPE parvw VALUE 'SP',
           c_we                      TYPE   parvw VALUE 'WE',
           c_sh                      TYPE parvw VALUE 'SH',
           c_h                       TYPE c VALUE 'H',
           c_err_file_soc            TYPE char2 VALUE 'FS', "File SOLDTO
           c_err_indirect_item       TYPE char2 VALUE 'II',
           c_item                    TYPE posnr VALUE '000010',
           c_coa                     TYPE char10 VALUE 'COA',
           c_new                     TYPE char10 VALUE 'NEW',
**** Begin of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
           c_msgty_succ              TYPE symsgty  VALUE 'S',                 " Message Type - (S)Succesfull
           c_source_rpa              TYPE tpm_source_name VALUE 'RPA'.        " Input Source maintain as a RPA
**** End of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****

*====================================================================*
*  Global Field symbol
*====================================================================*
FIELD-SYMBOLS: <st_cust_input>        TYPE zstqtc_customer_date_input,  "I0200: Customer Data (Gen, Comp Code, Sales Area, Crdt/Coll)
               <st_gen_data>          TYPE zstqtc_general_data,         "Complex External Interface of a Business Partner
               <st_comp_code_data>    TYPE zstqtc_comp_code_data,       "I0200: Customer master data distribution - Company Code
               <st_sales_data>        TYPE zstqtc_sales_data,           "I0200: Customer master data distribution - Sales Data
               <st_relationship_data> TYPE zstqtc_relationship_data,    " I0200: Customer master data distribution - Relationships
               <st_but0id>            TYPE ty_partner_id,
               <st_return>            TYPE zstqtc_customer_date_output, "I0200: Customer Data (Customer / BP Number, Messages)
**** Begin of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
               <st_bp_search_rpa>     TYPE zstqtc_bpsearch,             " BP Search result structure for Export parameter
               <gfs_knvv>             TYPE ty_knvv.                     " RPA Sales area data validation
**** End of change by Lahiru on 07/22/2020 for ERPM-22299 with ED2K918959 ****
