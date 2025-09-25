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
* REFERENCE NO  : ERPM-11501/I0200.3
* DEVELOPER     : VDPATABALL
* DATE          : 06/08/2020
* DESCRIPTION   : Updating the General data to BP
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*&---------------------------------------------------------------------*
FUNCTION-POOL zqtc_bp.                      "MESSAGE-ID ..

* INCLUDE LZQTC_BPD...                       " Local class definition
TYPES:BEGIN OF ty_roles,
        sign TYPE char1,
        opti TYPE char2,
        low  TYPE bu_role,
        high TYPE bu_role,
      END OF ty_roles,

      BEGIN OF ty_coll_profile,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE udm_coll_profile,
        high   TYPE udm_coll_profile,
      END OF   ty_coll_profile,

      BEGIN OF ty_coll_group,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE char10,
        high   TYPE char10,
      END OF ty_coll_group,

      BEGIN OF ty_coll_seg,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE bdm_coll_segment,
        high   TYPE bdm_coll_segment,
      END OF ty_coll_seg,

      BEGIN OF ty_coll_spl,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE char12,
        high   TYPE char12,
      END OF ty_coll_spl,

      BEGIN OF ty_risk_cls,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE ukm_risk_class,
        high   TYPE ukm_risk_class,
      END OF  ty_risk_cls,

      BEGIN OF ty_check_rule,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE ukm_check_rule,
        high   TYPE ukm_check_rule,
      END OF ty_check_rule,

      BEGIN OF ty_credit_grp,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE ukm_cred_group,
        high   TYPE ukm_cred_group,
      END OF ty_credit_grp,
*----Begin of change VDPATABALL 06/19/2020 I10 WLS - messgae function
      BEGIN OF ty_mesfct,
        sign   TYPE tvarv_sign,
        option TYPE tvarv_opti,
        low    TYPE edi_mesfct,
        high   TYPE edi_mesfct,
      END OF ty_mesfct.
*----End of change VDPATABALL 06/19/2020 I10 WLS - messgae function
TYPES: BEGIN OF ty_constant,
         devid  TYPE zdevid,              " Development ID
         param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
         srno   TYPE tvarv_numb,          " ABAP: Current selection number
         sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
         opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
         high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
       END OF ty_constant.

DATA: i_collect_ret   TYPE STANDARD TABLE OF bapiretc,
      i_constants     TYPE STANDARD TABLE OF  ty_constant,
      ir_bp_roles     TYPE STANDARD TABLE OF ty_roles,
      ir_mesfct       TYPE STANDARD TABLE OF ty_mesfct, "++VDPATABALL 06/19/2020 ERPM-22990  I10 WLS - messgae function
      ir_vkorg        TYPE STANDARD TABLE OF fkkr_vkorg,"++VDPATABALL 06/19/2020 ERPM-22990  I10 WLS - messgae function
      i_smtp          TYPE zstqtc_customer_date_input-general_data-gen_data-central_data-communication-smtp-smtp,
      sr_coll_profile TYPE ty_coll_profile,
      sr_coll_group   TYPE ty_coll_group,
      sr_coll_seg     TYPE ty_coll_seg,
      sr_coll_spl     TYPE ty_coll_spl,
      sr_credit_grp   TYPE ty_credit_grp,
      sr_check_rule   TYPE ty_check_rule,
      sr_risk_cls     TYPE ty_risk_cls,
      i_bdcdata       TYPE TABLE OF bdcdata , "BDCDATA
      i_bdcmsg        TYPE TABLE OF bdcmsgcoll, "BDC message table
      iv_email_error  TYPE char1,   "++VDPATABALL 06/26/2020 ERPM-22990  BP Update for WLS
      iv_cont         TYPE kunnr,   "++VDPATABALL 06/26/2020 ERPM-22990  BP Update for WLS
      sr_mesfct       TYPE ty_mesfct, "++VDPATABALL 06/19/2020 I10 ERPM-22990 WLS - messgae function
      sr_vkorg        TYPE fkkr_vkorg. "++VDPATABALL 06/19/2020 I10 ERPM-22990 WLS - messgae function

*====================================================================*
*  Global Constants
*====================================================================*
CONSTANTS: c_devid            TYPE zdevid     VALUE 'I0200.3',
           c_bp_role          TYPE rvari_vnam VALUE 'PARTNER_ROLE',
           c_coll_seg         TYPE rvari_vnam VALUE 'COLL_SEGMENT',
           c_coll_profile     TYPE rvari_vnam VALUE 'COLL_PROFILE',
           c_coll_grp         TYPE rvari_vnam VALUE 'COLL_GROUP',
           c_check_rule       TYPE rvari_vnam VALUE 'CHECK_RULE',
           c_credit_grp       TYPE rvari_vnam VALUE 'CREDIT_GROUP',
           c_risk_cls         TYPE rvari_vnam VALUE 'RISK_CLASS',
           c_coll_specialist  TYPE rvari_vnam VALUE 'COLL_SPECIALIST',
           c_vkorg            TYPE rvari_vnam VALUE 'VKORG',
           c_s                TYPE char1      VALUE 'S',
           c_e                TYPE char1      VALUE 'E',
           c_51               TYPE char2      VALUE '51',
           c_53               TYPE char2      VALUE '53',
           c_e1kna1m          TYPE edilsegtyp VALUE 'E1KNA1M',
           c_z1qtc_e1bpadsmtp TYPE edilsegtyp VALUE 'Z1QTC_E1BPADSMTP',
           c_z1qtc_e1bpadtel  TYPE edilsegtyp VALUE 'Z1QTC_E1BPADTEL',
           c_z1qtc_e1bpadfax  TYPE edilsegtyp VALUE 'Z1QTC_E1BPADFAX',
           c_z1qtc_bu_general TYPE edilsegtyp VALUE 'Z1QTC_BU_GENERAL',
           c_e1knb1m          TYPE edilsegtyp VALUE 'E1KNB1M',
           c_e1knvvm          TYPE edilsegtyp VALUE 'E1KNVVM',
           c_e1knvim          TYPE edilsegtyp VALUE 'E1KNVIM',
           c_e1knkkm          TYPE edilsegtyp VALUE 'E1KNKKM',
           c_z1qtc_e1bpad1vl1 TYPE edilsegtyp VALUE 'Z1QTC_E1BPAD1VL1',
           c_z1qtc_e1bpad1vl  TYPE edilsegtyp VALUE 'Z1QTC_E1BPAD1VL',
           c_z1qtc_bu_ident   TYPE edilsegtyp VALUE 'Z1QTC_BU_IDENT',
           c_e1knb5m          TYPE edilsegtyp VALUE 'E1KNB5M',
*---Begin of change VDPATABALL 06/08/2020 ERPM-11501/ERPM-22990 BP Update for WLS
           c_mesfct           TYPE rvari_vnam VALUE 'MESFCT',
           c_wls_id           TYPE bu_id_type VALUE 'ZWGPID',
           c_soldto           TYPE ktokd      VALUE '0001',
           c_shipto           TYPE ktokd      VALUE '0002',
           c_payer            TYPE ktokd      VALUE '0003',
           c_ag               TYPE parvw      VALUE 'AG',
           c_ap               TYPE parvw      VALUE 'AP',
           c_we               TYPE parvw      VALUE 'WE',
           c_rg               TYPE parvw      VALUE 'RG',
           c_c                TYPE char1      VALUE 'C',
           c_person           TYPE char1      VALUE '1',
           c_org              TYPE char1      VALUE '2',
           c_grp              TYPE char1      VALUE '3'.
*---End of change VDPATABALL 06/08/2020 ERPM-11501 BP Update for WLS
