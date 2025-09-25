*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTR_AR_MANDATE_XML_GEN_I0377
* PROGRAM DESCRIPTION: This report used to generate the XML file
* into AL11 directory. (XML file contains SEPA_Mandate info)
* DEVELOPER:           Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE:       18/11/2019
* OBJECT ID:           I0377
* TRANSPORT NUMBER(S): ED2K916852
*----------------------------------------------------------------------*
* REVISION HISTORY:
* REVISION NO:  <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:         MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include  ZRTR_AR_MANDATE_XML_GEN_TOP
*&---------------------------------------------------------------------*

* Types
TYPES: BEGIN OF ty_sepa_mandt,
         mndid            TYPE sepa_mndid,        " Mandate Id
         mvers            TYPE sepa_mvers,        " Version of Mandate
         status           TYPE sepa_status,       " Mandate Status
         erdat            TYPE sepa_erdat,        " Date on Which the Current Mandate Version was Created
         ertim            TYPE sepa_ertim,        " Time at Which the Current Mandate Version was Created
         origin_rec_crdid TYPE sepa_crdid_origin, " SEPA Mandate: Original Creditor ID of Mandate
         ori_erdat        TYPE sepa_ori_erdat,    " Date on Which Original Mandate Created
         ori_ertim        TYPE sepa_ori_ertim,    " Time when Original Mandate Was Created
       END OF ty_sepa_mandt,
       tt_sepa_mandt TYPE STANDARD TABLE OF ty_sepa_mandt INITIAL SIZE 0,  " Table Type: ty_sepa_mandt
       BEGIN OF ty_stg_mandt,
         mandt       TYPE mandt,                   " Client
         mndid       TYPE	sepa_mndid,              " Mandate ID
         zzdate_c	   TYPE sepa_ori_erdat,          " Mandate original creation Date
         zzver       TYPE zvers,                   " Mandate version
         anwnd       TYPE sepa_anwnd,              " Application Id
         rec_crdid   TYPE sepa_crdid,              " Creditor Identification Number
         zzdate      TYPE	sepa_erdat,              " Date on Which the Current Mandate Version was Created
         zztime      TYPE	sepa_ertim,              " Time at Which the Current Mandate Version was Created
         status      TYPE sepa_status,             " SEPA: Mandate Status
         zzmodif     TYPE zmodif_flg,              " Modification flag(Create, change,delete)
         zzdate_file TYPE	zdate_f,                 " File creation date
         zztime_file TYPE	ztime_f,                 " File creation time
         zzuname     TYPE zuname,                  " User name
       END OF ty_stg_mandt,
       tt_stg_mandt TYPE STANDARD TABLE OF ty_stg_mandt INITIAL SIZE 0, " Table Type: ty_stg_mandt
       BEGIN OF ty_constant,
         devid  TYPE  zdevid,                      " Development Id
         param1 TYPE  rvari_vnam,                  " Parameter-1
         param2 TYPE  rvari_vnam,                  " Parameter-2
         srno   TYPE  tvarv_numb,                  " Serial number
         sign   TYPE  tvarv_sign,                  " Sign
         opti   TYPE  tvarv_opti,                  " Option
         low    TYPE  salv_de_selopt_low,          " Low
         high   TYPE  salv_de_selopt_high,         " High
       END OF ty_constant,
       tt_constant TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0.  " Table Type: tt_constant

* Data declarations
DATA:
  v_mndid             TYPE sepa_mndid,                 " Mandate Id
  v_crdid             TYPE sepa_crdid_origin,          " Creditor Id
  v_credt             TYPE sepa_ori_erdat,             " Creation Date
  v_fcdate            TYPE zdate_f,                    " File Creation Date
  v_fctime            TYPE ztime_f,                    " File Creation Time
  v_date              TYPE zdate_f VALUE '00000000',   " Creation date with initial value
  v_time              TYPE ztime_f VALUE '000000',     " Creation time with initial value
  v_fn_pattern        TYPE string,                     " File Name Pattern-1
  i_cstmrdrctdbtinitn TYPE zcstmrdrctdbtinitn_tt,      " Itab: XML Structure
  i_sepa_mandt        TYPE tt_sepa_mandt,              " Itab: SEPA_MANDATE
  i_stg_mandt         TYPE tt_stg_mandt,               " Itab: Staging Mandate
  st_stg_mandt        TYPE ty_stg_mandt,               " Stru: Staging Mandate
  i_constant          TYPE tt_constant.                " Itab: Constant entries

* Constants
CONSTANTS:
  c_paym                  TYPE char1           VALUE 'U',         " Payment method
  c_rankord               TYPE fibl_042a_order VALUE '00001',     " Rank order
  c_space                 TYPE char1           VALUE abap_false,  " Space
  c_modid_s               TYPE zmodif_flg      VALUE 'S',         " Modification Id: S
  c_sign_i                TYPE char1   VALUE 'I',                 " Sign: I
  c_opt_ne                TYPE char2   VALUE 'NE',                " Option: NE
  c_opt_ge                TYPE char2   VALUE 'GE',                " Option: GE
  c_01                    TYPE char2   VALUE '01',                " Constant: 01
  c_collan                TYPE char1   VALUE ':',                 " Collan
  c_iphen                 TYPE char1   VALUE '-',                 " Iphen
  c_uscore                TYPE char1   VALUE '_',                 " Underscore
  c_t                     TYPE char1   VALUE 'T',                 " Constant: T
  c_mtyp_i                TYPE symsgty VALUE 'I',                 " Message Type: I
  c_mtyp_e                TYPE symsgty VALUE 'E',                 " Message Type: E
  c_mtyp_s                TYPE symsgty VALUE 'S',                 " Message Type: S
  c_modid_c               TYPE zmodif_flg VALUE 'C',              " Modification Id: C
  c_modid_u               TYPE zmodif_flg VALUE 'U',              " Modification Id: U
  c_modid_d               TYPE zmodif_flg VALUE 'D',              " Modification Id: D
  c_devid_i0377           TYPE zdevid     VALUE 'I0377',          " Developement Id
  c_fn_pattern_p1         TYPE rvari_vnam VALUE 'FILE_NAME_PATTERN', " Constant Table Param1
  c_account_id_p1         TYPE rvari_vnam VALUE 'ACCOUNT_ID',     " Constant Table Param1
  c_payment_p1            TYPE rvari_vnam VALUE 'PAYMENT',        " Constant Table Param1
  c_grphdr_p1             TYPE rvari_vnam VALUE 'GRPHDR',         " Constant Table Param1
  c_pmtinf_p1             TYPE rvari_vnam VALUE 'PMTINF',         " Constant Table Param1
  c_drctdbttxinf_p1       TYPE rvari_vnam VALUE 'DRCTDBTTXINF',   " Constant Table Param1
  c_special_char_p1       TYPE rvari_vnam VALUE 'SPECIAL_CHAR',   " Constant Table Param1
  c_ctrlsum_p2            TYPE rvari_vnam VALUE 'CTRLSUM',        " Constant Table Param2
  c_schmenm_cd_p2         TYPE rvari_vnam VALUE 'SCHMENM_CD',     " Constant Table Param2
  c_pmtmtd_p2             TYPE rvari_vnam VALUE 'PMTMTD',         " Constant Table Param2
  c_othr_id_p2            TYPE rvari_vnam VALUE 'OTHR_ID',        " Constant Table Param2
  c_schmenm_prtry_p2      TYPE rvari_vnam VALUE 'SCHMENM_PRTRY',  " Constant Table Param2
  c_pmttpinf_instrprty_p2 TYPE rvari_vnam VALUE 'PMTTPINF_INSTRPRTY', " Constant Table Param2
  c_svclvl_cd_p2          TYPE rvari_vnam VALUE 'SVCLVL_CD',      " Constant Table Param2
  c_cd_uk0n_p2            TYPE rvari_vnam VALUE 'CD_UK0N',        " Constant Table Param2
  c_cd_uk0s_p2            TYPE rvari_vnam VALUE 'CD_UK0S',        " Constant Table Param2
  c_cd_uk0c_p2            TYPE rvari_vnam VALUE 'CD_UK0C',        " Constant Table Param2
  c_instdamt_p2           TYPE rvari_vnam VALUE 'INSTDAMT',       " Constant Table Param2
  c_chrgbr_p2             TYPE rvari_vnam VALUE 'CHRGBR',         " Constant Table Param2
  c_amdmntind_p2          TYPE rvari_vnam VALUE 'AMDMNTIND'.      " Constant Table Param2
