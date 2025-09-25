*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_FG_BP_INTERFACE_I0200TOP
* PROGRAM DESCRIPTION: Create BP with Comapny Code data,Sales Data,
*                      Collection & Credit management data
* DEVELOPER: Cheenangshuk Das (CHDAS)
* CREATION DATE: 09/26/2016
* OBJECT ID: I0200
* TRANSPORT NUMBER(S): ED1K903988
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K909466
* REFERENCE NO:  ERP-5137
* DEVELOPER:     Writtick Roy (WROY)
* DATE:          15-Nov-2017
* DESCRIPTION:
* 1. Additional logic to check if the Dummy Customer is already locked
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
* REFERENCE NO:  ERP - 7751
* DEVELOPER:     Kiran Kumar Ravuri
* DATE:          27-Sep-2018
* DESCRIPTION:   BP Relationships Validation
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914481
* REFERENCE NO: CR#7463
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 15-Feb-2019
* DESCRIPTION: Update Relationship category (Student Membership) with
* 3 Years validity and add Full Membership (ZPR008)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED2K924504
* REFERENCE NO: FMM5986,FMM8
* DEVELOPER:MIMMADISET
* DATE: 09/09/2021
* DESCRIPTION:This TLINE companycode will be considered as primary company
* code for deriving the Credit/Collection/Dunning fields later in E191 program
* using path IM_DATA->GENERAL_DATA->ADD_GEN_DATA->TEXT->TEXTS-->DATA-->TLINE
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K926822
* REFERENCE NO: OTCM-26907
* DEVELOPER: BTIRUVATHU
* DATE: 11-April-2022
* DESCRIPTION: For all Source Systems default communication method
*             'INT' when email is available and to 'LET' for others
*----------------------------------------------------------------------*

FUNCTION-POOL zqtc_fg_bp_interface_i0200. "MESSAGE-ID ..
* INCLUDE LZQTC_FG_BP_CREATE_I0200D...       " Local class definition
*====================================================================*
* Structures
*====================================================================*
TYPES:BEGIN OF ty_partner,
        partner      TYPE  bu_partner,               " Business Partner Number
        partner_guid TYPE	 bu_partner_guid,          " Business Partner GUID
        xdele        TYPE  bu_xdele,                 " Business Partner Archive status
      END OF ty_partner,

*** Begin of: ERP-7751 KKR20180927  ED2K913240
*** Changes to fine tune SLG Logs
      BEGIN OF ty_log_info,
        identifier  TYPE char10,
        hier_level  TYPE i,
        msgtype     TYPE symsgty,
        message     TYPE char255,
        header_flag TYPE abap_bool,
        nodetype    TYPE char1,
      END OF ty_log_info,
*** End of: ERP-7751 KKR20180927  ED2K913240

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
*     Begin of ADD:ERP-7078 :Siva Guda:03-April-2018:ED2K911684
      BEGIN OF lty_syst_no,
        sign   TYPE tvarv_sign,                                  " Sign
        option TYPE tvarv_opti,                                  " Option
        low    TYPE syst_msgno,                                  " MMessage No
        high   TYPE syst_msgno,                                  " Message No
      END OF lty_syst_no,
      BEGIN OF lty_syst_id,
        sign   TYPE tvarv_sign,                                  " Sign
        option TYPE tvarv_opti,                                  " Option
        low    TYPE syst_msgid,                                  " Message ID
        high   TYPE syst_msgid,                                  " MEssage ID
      END OF lty_syst_id,
      BEGIN OF lty_ext_id_type,
        sign   TYPE tvarv_sign,                                  " Sign
        option TYPE tvarv_opti,                                  " Option
        low    TYPE syst_msgid,                                  " Message ID
        high   TYPE syst_msgid,                                  " MEssage ID
      END OF lty_ext_id_type,
      ltt_msgno      TYPE STANDARD TABLE OF lty_syst_no INITIAL SIZE 0,
      ltt_msgid      TYPE STANDARD TABLE OF lty_syst_id INITIAL SIZE 0,
      ltt_source_sys TYPE STANDARD TABLE OF lty_syst_id INITIAL SIZE 0,     "ED2K926822
      ltt_ext_id_typ TYPE STANDARD TABLE OF lty_ext_id_type INITIAL SIZE 0, "ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715
*     End of ADD:ERP-7078 :Siva Guda:03-April-2018:ED2K911684
* Begin of ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715
      BEGIN OF gty_ext_id_data,       "for external ID infromation "added for ERP-6309 RK20180706
        seq_id      TYPE numc4,
        id_category TYPE  bu_id_type,
        id_number   TYPE  bu_id_number,
        bp_number   TYPE bu_partner,
      END OF gty_ext_id_data.
* End of ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715
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
*** Begin of: ERP-7751 KKR20180927  ED2K913240
      tty_trtab       TYPE STANDARD TABLE OF trtab
                                    INITIAL SIZE 0,
*** Changes to fine tune SLG Logs
      tty_log_info    TYPE STANDARD TABLE OF ty_log_info
                                    INITIAL SIZE 0.
*** End of: ERP-7751 KKR20180927  ED2K913240
*====================================================================*
*  Global Internal table
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
*     Begin of ADD:ERP-7078 :Siva Guda:03-April-2018:ED2K911684
      lr_msgno             TYPE ltt_msgno,
      lst_msgno            TYPE lty_syst_no,
      lst_source_sys       TYPE lty_syst_id,    "ED2K926822
      lr_source_sys        TYPE ltt_source_sys, "ED2K926822
      lr_ext_id_typ        TYPE ltt_ext_id_typ, "ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715
      lr_msgid             TYPE ltt_msgid,
      lst_msgid            TYPE lty_syst_id,
      lst_ext_id_typ       TYPE lty_syst_id,    "ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715
*     End of ADD:ERP-7078 :Siva Guda:03-April-2018:ED2K911684
      i_return             TYPE STANDARD TABLE OF bapiret2 " Return Parameter
                                INITIAL SIZE 0,         "Return Parameter
*** Begin of: ERP-7751 KKR20180927  ED2K913240
* Changes to fine tune SLG Logs
      i_log_info           TYPE tty_log_info,     " Itab: Application Log table
*** End of: ERP-7751 KKR20180927  ED2K913240
*** BOC: CR#7463  KKRAVURI20190215  ED2K914481
      r_rel_categories     TYPE RANGE OF bu_reltyp,
*** EOC: CR#7463  KKRAVURI20190215  ED2K914481
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
*** Begin of: ERP-7751 KKR20180927  ED2K913240
* Changes to fine tune SLG Logs
      st_log_info          TYPE ty_log_info,
*** End of: ERP-7751 KKR20180927  ED2K913240
*====================================================================*
*  Global Variable
*====================================================================*
      v_partner            TYPE bu_partner,         " Business Partner Number
      v_dummy              TYPE abap_bool,
      v_validation_success TYPE abap_bool VALUE 'X',
      v_log_handle         TYPE balloghndl,         " Application Log: Log Handle
      v_index              TYPE sy-index,           " ABAP System Field: Loop Index
      v_object_inst        TYPE bus_ei_object_task, " External Interface: Change Indicator Object
      v_partner_exists     TYPE xfeld,              " Checkbox
      v_source             TYPE tpm_source_name,    " ADD: ERP-7006 KKR20181001  ED2K913240
*** BOC: CR#7825  KKR20190123  ED2K914283
      v_actv_flag_i0200    TYPE zactive_flag,
*** EOC: CR#7825  KKR20190123  ED2K914283
      v_actv_flag_i0200_2  TYPE zactive_flag,
*** BOC: CR#7463  KKRAVURI20190215  ED2K914481
      v_validity_year      TYPE numc2,
*** EOC: CR#7463  KKRAVURI20190215  ED2K914481
      v_actv_mko_i0200     TYPE zactive_flag.    "ADD:FMM5986:FMM8:MIMMADISET:09/09/2021: ED2K924504
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
*           BOC by DTIRUKOOVA on 29-Mar-2018 for CR-7078 :ED2K911678
           c_bp                      TYPE char2              VALUE 'BP',       " Business Parttner
*           BOC by DTIRUKOOVA on 29-Mar-2018 for CR-7078 :ED2K911678
           c_i                       TYPE bus_ei_object_task VALUE 'I',        "External Interface: Change Indicator Object
           c_msgty_info              TYPE symsgty            VALUE 'I',        "Message Type - (I)nformation
           c_msgty_err               TYPE symsgty            VALUE 'E',        "Message Type - (E)rror
*           Begin of ADD:ERP-5137:WROY:15-Nov-2017:ED2K909466
           c_msgid_f2                TYPE symsgid            VALUE 'F2',       "Message Class - F2
           c_msgno_042               TYPE symsgno            VALUE '042',      "Message Number - 042
           c_msgid_mc                TYPE symsgid            VALUE 'MC',       "Message Class - MC
           c_msgno_601               TYPE symsgno            VALUE '601',      "Message Number - 601
*           End   of ADD:ERP-5137:WROY:15-Nov-2017:ED2K909466
           c_msgid_zrtr              TYPE symsgid            VALUE 'ZRTR_R1B', "Message Class - ZRTR_R1B
           c_msgno_000               TYPE symsgno            VALUE '000',      "Message Number - 000
           c_msgno_026               TYPE symsgno            VALUE '026',      "Message Number - 025
*           Begin of ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715
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
*           End of ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715
*** Begin of: ERP-7751 KKR20180927  ED2K913240
           c_reltype                 TYPE bu_id_type         VALUE 'ZRLCT', " Identification Type: Valid Relationship Category.
           c_nodetype_h              TYPE char1              VALUE 'H',
           c_nodetype_i              TYPE char1              VALUE 'I',
           c_input_data              TYPE char10             VALUE '1INPUT_DATA',
           c_gen_data                TYPE char10             VALUE '2GEN_DATA',
           c_comp_sales              TYPE char10             VALUE '3COMP_SALES',
           c_cred_coll               TYPE char10             VALUE '4CRED_COLL',
           c_relations               TYPE char10             VALUE '5RELATIONS',
*** End of: ERP-7751 KKR20180927  ED2K913240
*** Begin of: ERP-7006 KKR20181001  ED2K913240
           c_commtyp_int             TYPE ad_comm            VALUE 'INT',
           c_commtyp_let             TYPE ad_comm            VALUE 'LET',
*** End of: ERP-7006 KKR20181001  ED2K913240
*** BOC: CR#7463  KKRAVURI20190215  ED2K914481
           c_relcat_zpr008           TYPE bu_reltyp          VALUE 'ZPR008',
           c_0101                    TYPE char4              VALUE '0101',
           c_1231                    TYPE char4              VALUE '1231'.
*** EOC: CR#7463  KKRAVURI20190215  ED2K914481
*====================================================================*
*  Global Field symbol
*====================================================================*
FIELD-SYMBOLS: <st_cust_input>        TYPE zstqtc_customer_date_input,  "I0200: Customer Data (Gen, Comp Code, Sales Area, Crdt/Coll)
               <st_gen_data>          TYPE zstqtc_general_data,         "Complex External Interface of a Business Partner
               <st_comp_code_data>    TYPE zstqtc_comp_code_data,       "I0200: Customer master data distribution - Company Code
               <st_sales_data>        TYPE zstqtc_sales_data,           "I0200: Customer master data distribution - Sales Data
               <st_relationship_data> TYPE zstqtc_relationship_data,    " I0200: Customer master data distribution - Relationships
               <st_but0id>            TYPE ty_partner_id,
               <st_return>            TYPE zstqtc_customer_date_output. "I0200: Customer Data (Customer / BP Number, Messages)
* BOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471
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

DATA : lst_zqtc_ext_ident TYPE zqtc_ext_ident,
       lt_zqtc_ext_ident  TYPE TABLE OF zqtc_ext_ident,
       li_constant        TYPE tt_constant.


CONSTANTS : c_zsfci       TYPE but0id-type  VALUE 'ZSFCI',
            c_zcaaid      TYPE but0id-type VALUE 'ZCAAID',
            c_zecid       TYPE but0id-type VALUE 'ZECID',
            c_i0200       TYPE zdevid      VALUE 'I0200',
            c_lock_msgno  TYPE rvari_vnam VALUE 'LOCK_MSGNR',
            c_support_mod TYPE rvari_vnam VALUE 'SUPPORT_MODE',
            c_lock_msgid  TYPE rvari_vnam VALUE 'LOCK_MSGID',
            c_expiry      TYPE rvari_vnam  VALUE 'EXPIRY_DATE',
            c_appl        TYPE expiry_date VALUE 'APPL_LOG',
            c_source_comm TYPE rvari_vnam  VALUE 'SOURCE_COMM'.    "ED2K926822

DATA : lv_result(1)  TYPE c.
DATA lv_status.
* EOC by DTIRUKOOVA on 20-Mar-2018 for CR-7078 :ED2K911471

* Begin of ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715
DATA: gs_ext_id            TYPE          gty_ext_id_data,
      gt_ext_id_input      TYPE TABLE OF gty_ext_id_data,
      gt_ext_id_seq        TYPE TABLE OF gty_ext_id_data, "External ID infromation in DB "ERP-6309 RK20180706
      gv_message           TYPE          char200,
      gv_return_msg        TYPE          bapiretc,
      gv_id_err            TYPE          xfeld,          "error flag, duplicate external ID error check/ payload error/data inconcistency
      gv_guid              TYPE          idoccarkey,
      gv_support_mode      TYPE          char1,
* End of ADD:ERP-6309:RKUMAR2:20-July-2018: ED2K912715
      gv_relationships_err TYPE          abap_bool.      " ADD: ERP-7751 KKR20180927  ED2K913240
