*----------------------------------------------------------------------*
* PROGRAM NAME:LZQTC_SD_VIEWTOP
* PROGRAM DESCRIPTION:Include for Data Declaration
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-12-10
* OBJECT ID:E099
* TRANSPORT NUMBER(S)ED2K903485
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907652
* REFERENCE NO:  JIRA# 3709
* DEVELOPER: Monalisa Dutta
* DATE:  2017-08-01
* DESCRIPTION: addition of new partner function in header and checking
* vendor for the new partner function
*------------------------------------------------------------------- *
FUNCTION-POOL zqtc_sd_view. "MESSAGE-ID ..
*& Type POOL: Value Request Manager
TYPE-POOLS:vrm.

DATA: v_po_number    TYPE vbkd-bstkd,  " Customer purchase order number
      v_vbeln        TYPE vbak-vbeln,  " Sales Order
      v_flag         TYPE char1,       " Flag
      v_save_flag    TYPE char1,       " Save Falg
      v_radio_1      TYPE char1,       " Radio button
      v_radio_2      TYPE char1,       " Radio button
      v_head_cond    TYPE char1,       " Radio button varibale for header condition
      v_item_cond    TYPE char1,       " Radio button variable for Item condition
      v_line_length  TYPE i VALUE 254, " LENGTH
      v_partner      TYPE kunnr,       " Partner
      v_hd_partner   TYPE char1,       " Radio button for Item Partner change
      v_itm_partner  TYPE char1,       " Radio Button for Header Partner Change
      v_appliction   TYPE string,      " Application Id
      v_user_command TYPE sy-ucomm,    " User command
      v_billing_date TYPE fkdat.       "++VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45

************************************************************************
*.... Table Type declalation ........................................................*
************************************************************************
TYPES:BEGIN OF ty_rstext,
        tdid  TYPE tdid,                      " Text ID
        langu TYPE sy-langu,                  " ABAP System Field: Language Key of Text Environment
      END OF ty_rstext,
      BEGIN OF ty_const,
        devid       TYPE zdevid,              "Development ID
        param1      TYPE rvari_vnam,          "Parameter1
        param2      TYPE rvari_vnam,          "Parameter2
        srno        TYPE tvarv_numb,          "Serial Number
        sign        TYPE tvarv_sign,          "Sign
        opti        TYPE tvarv_opti,          "Option
        low         TYPE salv_de_selopt_low,  "Low
        high        TYPE salv_de_selopt_high, "High
        activate    TYPE zconstactive,        "Active/Inactive Indicator
        description TYPE zconstdesc,          " Description of constant
      END OF ty_const,
      BEGIN OF ty_item,
        vblen     TYPE vbak-vbeln,            " Sales Document
        posnr     TYPE vbap-posnr,            " Sales Document Item
        kschl     TYPE char30,                " Kschl of type CHAR30
        vtext     TYPE vtxtk,                 " Name
        price(16) TYPE p DECIMALS 2,          " Price(16) of type Packed Number
        waerk     TYPE vbak-waerk,            " SD Document Currency
      END  OF ty_item,
      BEGIN OF ty_konv,
        knumv TYPE knumv,                     " Number of the document condition
        kposn TYPE kposn,                     " Condition item number
        stunr TYPE stunr,                     " Step number
        zaehk TYPE dzaehk,                    " consition Counter
        kappl TYPE kappl,                     " Application
        kschl TYPE kschl,                     " Condition type
        kdatu TYPE kdatu,                     " Condition pricing date
        krech TYPE krech,                     " Condition type
        kbetr TYPE kbetr,                     " Price
        waers TYPE waers,                     " currency

      END OF ty_konv,
      BEGIN OF ty_partner,
        vbeln    TYPE vbak-vbeln,             " Sales Document
        posnr    TYPE vbap-posnr,             " Sales Document Item
        part_fun TYPE char30,                 " Fun of type CHAR30
        partner  TYPE kna1-kunnr,             " Customer Number
      END OF ty_partner,
      BEGIN OF ty_promo_code,
        vbeln   TYPE vbak-vbeln,              " Order
        posnr   TYPE vbap-posnr,              " Items
        zzpromo TYPE kona-knuma,              " Promo code
      END OF ty_promo_code,
      BEGIN OF ty_promo,
        vbeln   TYPE vbak-vbeln,              " Order No    " PBOSE
        posnr   TYPE vbap-posnr,              " Item No
        promo_o TYPE kona-knuma,              " Agreement (various conditions grouped together)
        promo_n TYPE kona-knuma,              " Agreement (various conditions grouped together)
      END OF ty_promo,
      BEGIN OF ty_vbpa,
        vbeln TYPE vbap-vbeln,                " Sales and Distribution Document Number
        posnr TYPE vbap-posnr ,               " Item no
        parvw TYPE parvw,                     " Partner Function
        kunnr TYPE kunnr,                     " Customer Number
        lifnr TYPE lifnr,                     "Vendor "Added by MODUTTA for JIRA#3709 on 01/08/2017
      END OF ty_vbpa,

*     Begin of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
      BEGIN OF ty_lifsk,
        vbeln TYPE vbeln,      " Sales Document
        lifsk TYPE char70,     " Delivery block (document header)
      END OF ty_lifsk,

      BEGIN OF ty_faksk,
        vbeln TYPE vbeln,      " Sales Document
        faksk TYPE char70,     " Billing block in SD document
      END OF ty_faksk,

      BEGIN OF ty_zzlicgrp,
        vbeln TYPE vbeln,      " Sales Document
        lifsk TYPE char70,     " Delivery block (document header)
      END OF ty_zzlicgrp,

      BEGIN OF ty_kdkg2,
        vbeln TYPE vbkd-vbeln, " Sales and Distribution Document Number
        posnr TYPE vbkd-posnr, " Item number of the SD document
        kdkg2 TYPE char70,     " Customer condition group 2
      END OF ty_kdkg2,

*    End of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
      BEGIN OF ty_cancel,
        vbeln   TYPE vbap-vbeln,  " Sales and Distribution Document Number
        posnr   TYPE vbap-posnr , " Item no
        vkuesch TYPE char70,      " Description
        vkuegru TYPE char70,      " Description
        vbedkue TYPE vbedk_veda,  " Cancel Date
        veindat TYPE vedat_veda,  " Date on which cancellation request was received
        vwundat TYPE vwdat_veda,  " Requested cancellation date
      END OF ty_cancel,
      BEGIN OF ty_tvkst,
        spras   TYPE spras,       " Language
        vkuesch TYPE vkues_veda,  " Assignment cancellation procedure/cancellation rule
        vbezei  TYPE bezei40,     " Description
      END OF ty_tvkst,
*& Sales Documents: Reasons for Cancellation: Texts
      BEGIN OF ty_tvkgt,
        spras  TYPE spras,      " Language
        kuegru TYPE vkgru_veda, " Reason for Cancellation of Contract
        bezei  TYPE bezei40,    " Reason text
      END OF ty_tvkgt,
      BEGIN OF ty_tvagt,
        spras TYPE spras,       " Language
        abgru TYPE abgru_va,    " Reason for rejection of quotations and sales orders
        bezei TYPE bezei40,     " Reason text
      END OF ty_tvagt,

      BEGIN OF ty_vbkd,
        vbeln TYPE vbkd-vbeln,  " Order
        posnr TYPE vbkd-posnr,  " Item
        bstkd TYPE vbkd-bstkd,  " PO number
      END OF ty_vbkd,
*& type condition for pricing condition
*---Begin of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
      BEGIN OF ty_vbkd1,
        vbeln TYPE vbeln,
        posnr TYPE posnr,
        fkdat TYPE fkdat,
      END OF ty_vbkd1,
*---End of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45

      BEGIN OF ty_vbak,
        vbeln TYPE vbak-vbeln, " Sales Order
        knumv TYPE vbak-knumv, " Number of the document condition
        kalsm TYPE kalsmasd,   " Pricing procedure
      END OF ty_vbak,
*& type declaration Pricing Procedure: Data
      BEGIN OF ty_t683s,
        kvewe TYPE kvewe,   " Usage of the condition table
        kappl TYPE kappl,   " Application
        kalsm TYPE kalsm_d, " Procedure (Pricing, Output Control, Acct. Det., Costing,...)
        stunr TYPE stunr,   " Step number
        zaehk TYPE dzaehk,  " Condition counter
        kschl TYPE kschl,   " Condition Type
      END OF ty_t683s,
      BEGIN OF ty_t685a,
        kappl TYPE kappl,   " Application
        kschl TYPE kscha,   " Constion tyoe
        krech TYPE krech,   " Calculation type for condition
        kkopf TYPE kkopf,   " Condition applies to header
      END OF ty_t685a.
TYPES:BEGIN OF ty_veda,
        vbeln   TYPE vbeln_va, " Sales Document
        vposn   TYPE posnr_va, " Sales Document Item
*** BOC BY SAYANDAS for ERP-5288 on 20-NOV-2017
        vbegdat TYPE vbdat_veda, " Contract start date
*** EOC BY SAYANDAS for ERP-5288 on 20-NOV-2017
        vkuesch TYPE vkues_veda,   " Assignment cancellation procedure/cancellation rule
        veindat TYPE vedat_veda,   " Date on which cancellation request was received
        vwundat TYPE vwdat_veda,   " Requested cancellation date
        vkuegru TYPE vkgru_veda,   " Reason for Cancellation of Contract
        vbedkue TYPE veda-vbedkue, " Date of cancellation document from contract partner
      END OF ty_veda,

      BEGIN OF ty_tvfs,
        faksp TYPE faksp,          " Block
      END OF ty_tvfs.

*& Table Type Declaration
TYPES : tt_t_item     TYPE STANDARD TABLE OF ty_item INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY vblen COMPONENTS vblen ,                        " Item
        tt_veda       TYPE STANDARD TABLE OF ty_veda INITIAL SIZE 0
              WITH NON-UNIQUE SORTED KEY veda COMPONENTS vbeln vposn,
        tt_t_konv     TYPE STANDARD TABLE OF ty_konv INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY cond_key COMPONENTS knumv kposn kschl,
        tt_vbak       TYPE STANDARD TABLE OF ty_vbak INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY vbeln COMPONENTS vbeln,
        tt_t685a      TYPE STANDARD TABLE OF ty_t685a INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY kschl COMPONENTS kschl,
        tt_tvagt      TYPE STANDARD TABLE OF ty_tvagt INITIAL SIZE 0,              " Table type for Rejection reason
        tt_tvkgt      TYPE STANDARD TABLE OF ty_tvkgt INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY kuegru COMPONENTS spras kuegru,                 " Cancellation reason
        tt_tvkst      TYPE STANDARD TABLE OF ty_tvkst INITIAL SIZE 0               " Cancellation Procedures for Agreements; Texts
        WITH NON-UNIQUE SORTED KEY vkuesch COMPONENTS spras vkuesch,
        tt_promo_code TYPE STANDARD TABLE OF ty_promo_code
        WITH NON-UNIQUE SORTED KEY promo_code COMPONENTS vbeln posnr,              " Inter nal table for Promo code
        tt_t_cancel   TYPE STANDARD TABLE OF ty_cancel INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY cancel_key COMPONENTS vbeln posnr,
        tt_t_vbfs     TYPE  STANDARD TABLE OF vbfs INITIAL SIZE 0,                 " Error Log for Collective Processing
        tt_t_const    TYPE STANDARD TABLE OF ty_const INITIAL SIZE 0,              " Tale type constant
        tt_t_vbpa     TYPE STANDARD TABLE OF ty_vbpa INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY part_func COMPONENTS vbeln posnr parvw,         " Table type partner function
        tt_promo      TYPE STANDARD TABLE OF ty_promo INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY promo COMPONENTS promo_n,                       " vbeln posnr,                     " Table type for Promo code
        tt_vbkd       TYPE STANDARD TABLE OF ty_vbkd INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY bstkd COMPONENTS vbeln ,                        " Sales Document: Business Data
        tt_t683s      TYPE STANDARD TABLE OF ty_t683s INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY kalsm COMPONENTS kalsm kschl,
        tt_lifsk      TYPE STANDARD TABLE OF ty_lifsk INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY lifsk COMPONENTS vbeln,
        tt_faksk      TYPE STANDARD TABLE OF ty_faksk INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY faksk COMPONENTS vbeln,
        tt_zzlicgrp   TYPE STANDARD TABLE OF ty_zzlicgrp INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY zzlicgrp COMPONENTS vbeln,
        tt_kdkg2      TYPE STANDARD TABLE OF ty_kdkg2 INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY kdkg2 COMPONENTS vbeln posnr,
        tt_t_partner  TYPE STANDARD TABLE OF ty_partner INITIAL SIZE 0
                       WITH NON-UNIQUE SORTED KEY partner COMPONENTS vbeln posnr , " Table type for Partner
        tt_tvfs       TYPE STANDARD TABLE OF ty_tvfs INITIAL SIZE 0,
*---Begin of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
        tt_vbkd1      TYPE STANDARD TABLE OF ty_vbkd1 INITIAL SIZE 0
        WITH NON-UNIQUE SORTED KEY fkdat COMPONENTS vbeln .
*---End of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45

*& Global Internal table / Work area
DATA: i_xvbfs           TYPE TABLE OF vbfs, " Error Log for Collective Processing
      i_promo           TYPE tt_promo,      " Internal table for promo code
      i_cancel          TYPE tt_t_cancel,   " Internal table for Cancel Order
      i_tvagt           TYPE tt_tvagt,      " Internal table for Rejection reason
      i_tvkgt           TYPE tt_tvkgt     , " Cancellation reason
      i_tvkst           TYPE tt_tvkst    ,  " cancellation Procedure
      i_messages        TYPE tdt_sdoc_msg,  " Message
      i_sel_rows        TYPE salv_t_row,    " Selection rows
      i_const           TYPE tt_t_const,    "Constant internal table
      i_vbkd            TYPE tt_vbkd,       " Sales Document: Business Data
      i_vbkd1           TYPE tt_vbkd1,       " ++ VDPATABALL 10/20/2020 OTCM-29460  Billing Date Button
      i_partner         TYPE tt_t_partner,  " Patrner details
      i_item            TYPE tt_t_item,     " Items
      i_excl_func       TYPE ui_functions,  " declaration for toolbar function
      i_cond            TYPE vrm_values,    " Value Request Manager: condition type
      i_list            TYPE vrm_values,    " Value Request Manager:
      i_t685a           TYPE tt_t685a,
      i_fielcat_par     TYPE lvc_t_fcat,    " field Catalogue for Partner
      i_fielcat_pro     TYPE lvc_t_fcat,    " Field Catalogue for Promo Code
      i_fielcat_can     TYPE lvc_t_fcat,    " Field Catalogue for Cancel Order
*     Begin of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
      v_licn_grp        TYPE vbak-zzlicgrp, " License Group
      i_cancel_final    TYPE tt_t_cancel,
      i_partner_final   TYPE tt_t_partner,
      i_item_final      TYPE tt_t_item,
      i_promo_final     TYPE tt_promo,
      i_lifsk           TYPE tt_lifsk,
      i_lifsk_final     TYPE tt_lifsk,
      i_faksk           TYPE tt_faksk,
      i_faksk_final     TYPE tt_faksk,
      i_kdkg2           TYPE tt_kdkg2,
      i_kdkg2_final     TYPE tt_kdkg2,
      i_zzlicgrp        TYPE tt_zzlicgrp,
      i_fieldcat_dlvblk TYPE lvc_t_fcat,    " field Catalogue for delivery Block
      i_fieldcat_cstgrp TYPE lvc_t_fcat,    " field Catalogue for delivery Block
      i_fieldcat_bilblk TYPE lvc_t_fcat,    " field Catalogue for billing Block
      i_bill            TYPE vrm_values,    " Value Request Manager: billing block
*     End of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
      i_fielcat_con     TYPE lvc_t_fcat, " Field Catalogue for Price Update
      i_layout_par      TYPE lvc_s_layo, " Layout for Partner
      i_tvfs            TYPE tt_tvfs,
*& Work area
      st_lifsk          TYPE ty_lifsk,
      st_sel_row        TYPE i, " Sel_row of type Integers
      st_rstext1        TYPE ty_rstext.
*& Reference Variable declaration
DATA:r_result              TYPE REF TO data,                          "  class
     r_editor_cont         TYPE REF TO cl_gui_custom_container,       " Container for Custom Controls in the Screen Area
     r_text_edit           TYPE REF TO cl_gui_textedit,               " SAP TextEdit Control
     r_sdoc_select_adapter TYPE REF TO cl_sdoc_select_report_adapter, " SDOC select report adapter
     r_result_table_type   TYPE REF TO cl_abap_tabledescr,            " Runtime Type Services
     r_cont_cust           TYPE REF TO cl_gui_custom_container,       " Custom container ref variable for partner
     r_cont_promo          TYPE REF TO cl_gui_custom_container,       " Custom Container ref variable for Procmo code
     r_cont_cancel         TYPE REF TO cl_gui_custom_container,       " Custom Container ref variable for Cancel Order
     r_promo_docking       TYPE REF TO cl_gui_docking_container,      "Docking Container for promo code
     r_cont_editalvgd      TYPE REF TO cl_gui_alv_grid,               " ALV List Viewer
     r_docking_condition   TYPE REF TO cl_gui_docking_container,      "Docking Container for Prcing condition update
     r_docking             TYPE REF TO cl_gui_docking_container,      "Docking Container
     r_docking_can         TYPE REF TO cl_gui_docking_container,      "Docking Container for Cancel Order
*    Begin of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
     r_bill_blk            TYPE REF TO cl_gui_custom_container,  " Container for Custom Controls in the Screen Area
     r_delv_blk            TYPE REF TO cl_gui_custom_container,  " Container for Custom Controls in the Screen Area
     r_cust_grp            TYPE REF TO cl_gui_custom_container,  " Container for Custom Controls in the Screen Area
     r_licn_grp            TYPE REF TO cl_gui_custom_container,  " Container for Custom Controls in the Screen Area
     r_docking_bill        TYPE REF TO cl_gui_docking_container, " Docking Control Container
     r_docking_delv        TYPE REF TO cl_gui_docking_container, " Docking Control Container
     r_docking_cust        TYPE REF TO cl_gui_docking_container, " Docking Control Container
     r_docking_licg        TYPE REF TO cl_gui_docking_container, " Docking Control Container
     r_bill_editalvgd      TYPE REF TO cl_gui_alv_grid,          " ALV List Viewer
     r_delv_editalvgd      TYPE REF TO cl_gui_alv_grid,          " ALV List Viewer
     r_cust_editalvgd      TYPE REF TO cl_gui_alv_grid,          " ALV List Viewer
     r_licn_editalvgd      TYPE REF TO cl_gui_alv_grid,          " ALV List Viewer
     r_bill_grid           TYPE REF TO cl_gui_alv_grid,          " ALV grid for billing Block
     r_delv_grid           TYPE REF TO cl_gui_alv_grid,          " ALV grid for delivery Block
     r_cust_grid           TYPE REF TO cl_gui_alv_grid,          " ALV grid for customer group
     r_licg_grid           TYPE REF TO cl_gui_alv_grid,          " ALV grid for delivery Block
*    End of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
     r_cond_grid           TYPE REF TO cl_gui_alv_grid, " ALV grid for Cancel Order
     r_can_grid            TYPE REF TO cl_gui_alv_grid, " ALV grid for Cancel Order
     r_promo_grid          TYPE REF TO cl_gui_alv_grid, " ALV grid for Promo code
     r_grid                TYPE REF TO cl_gui_alv_grid. " reference Variable fcore ALV grid for Partner
*& Field symbols
FIELD-SYMBOLS: <i_result> TYPE STANDARD TABLE, " result table
               <v_vstkd>  TYPE vbkd-bstkd,     " Customer purchase order number
               <v_vbeln>  TYPE vbak-vbeln,     " Order Number
               <v_posnr>  TYPE vbap-posnr.     " Item
************************************************************************
*.... Constants ........................................................*
************************************************************************
CONSTANTS: c_name        TYPE salv_de_function VALUE 'MCHANPO',      " MASS Change for PO Number function code
           c_text        TYPE salv_de_function VALUE 'MCHANPOTXT',   " MASS Change for PO text function code
           c_partner     TYPE salv_de_function VALUE 'MCHANPOFUN',   " MASS Change for Partner number function code
           c_mchanpocond TYPE salv_de_function VALUE 'MCHANPOCON',   " Pricing Condition
           c_promocode   TYPE salv_de_function VALUE 'MCHANPOPRO',   " Promo code
           c_part_cont   TYPE char30           VALUE 'PARTNER_CONT', " Custom container name for Partner change
           c_cancel_cont TYPE char30           VALUE 'CANCEL_CONT',  " Custom container name for Oreder Cancel
           c_promo_cont  TYPE char30           VALUE 'PROMO_CONT',   " Custom container name for Promo code
           c_mchapocan   TYPE char30           VALUE 'MCHANPOCAN',   " Mchapocan of type CHAR30
*          Begin of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
           c_bill_cont   TYPE char30           VALUE 'BILLING_BLOCK', " Bill_cont of type CHAR30
           c_delv_cont   TYPE char30           VALUE 'CDELV_BLOCK',   "
           c_memb_cont   TYPE char30           VALUE 'CMEM_CAT',      " Memb_cont of type CHAR30
           c_licn_cont   TYPE char30           VALUE 'CLIC_GRP',      " Licn_cont of type CHAR30
           c_mchanbb     TYPE salv_de_function VALUE 'MCHANBB',       " ALV Function
           c_mchandb     TYPE salv_de_function VALUE 'MCHANDB',       " ALV Function
           c_mchanmemcat TYPE salv_de_function VALUE 'MCHANMEMCAT',   " ALV Function
           c_mchanliccat TYPE salv_de_function VALUE 'MCHANLICCAT',   " ALV Function
           c_mbilling    TYPE salv_de_function VALUE 'MBILLING',     "++VDPATABALL 10/20/2020 OTCM-29460  Billing Date Button
           c_lifsk       TYPE lvc_fname        VALUE 'LIFSK',         " ALV control: Field name of internal table field
           c_faksk       TYPE lvc_fname        VALUE 'FAKSK',         " ALV control: Field name of internal table field
           c_kdkg2       TYPE lvc_fname        VALUE 'KDKG2',         " ALV control: Field name of internal table field
           c_licgrp      TYPE lvc_fname        VALUE 'ZZLICGRP',      " ALV control: Field name of internal table field
*          End of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
           c_kschl       TYPE lvc_fname        VALUE 'KSCHL',     " ALV control: Field name of internal table field
           c_part_fun    TYPE char10           VALUE 'PART_FUN',  " Part_fun of type CHAR10
           c_price(05)   TYPE c                VALUE 'PRICE',     " Price(05) of type Character
           c_veda        TYPE lvc_rtname       VALUE 'VEDA',      " ALV control: Reference table name for internal table field
           c_promo_n     TYPE lvc_fname        VALUE 'PROMO_N',   " ALV control: Field name of internal table field
           c_vkuesch     TYPE lvc_fname        VALUE 'VKUESCH',   " Field Name for Cancel Procedure
           c_vkuegru     TYPE lvc_fname        VALUE 'VKUEGRU',   " Field name Reason for Cancellation of Contract
           c_vwundat     TYPE lvc_fname        VALUE 'VWUNDAT',   " Requested cancellation date
           c_veindat     TYPE lvc_fname        VALUE 'VEINDAT',   " Date  on which cancellation request was received
           c_can_date    TYPE lvc_fname        VALUE 'VBEDKUE',   " Cancellation date
           c_abbr        TYPE sy-ucomm         VALUE 'ABBR',      " ABAP System Field: PAI-Triggering Function Code
           c_update      TYPE char1            VALUE 'U',         " Update of type CHAR1
           c_sich        TYPE sy-ucomm         VALUE 'SICH',      " ABAP System Field: PAI-Triggering Function Code
           c_i_partner   TYPE lvc_tname        VALUE 'I_PARTNER', " LVC tab name
           c_i_promo     TYPE lvc_tname        VALUE 'I_PROMO',   " Table for Promo code
           c_i_cancel    TYPE lvc_tname        VALUE 'I_CANCEL',  " LVC tab name
           c_i_item      TYPE lvc_tname        VALUE 'I_ITEM',    " LVC tab name
           c_error       TYPE bapi_mtype       VALUE 'E',         " Message type: S Success, E Error, W Warning, I Info, A Abort
           c_abend       TYPE bapi_mtype       VALUE 'A',         " Message type: S Success, E Error, W Warning, I Info, A Abort
           c_success     TYPE bapi_mtype       VALUE 'S',         " Message type: S Success, E Error, W Warning, I Info, A Abort
           c_a           TYPE krech            VALUE 'A',         " Calculation type for condition
           c_i           TYPE krech            VALUE 'I',         " Calculation type for condition
           c_h           TYPE krech             VALUE 'H',        " Calculation type for condition
           c_mess_id     TYPE symsgid           VALUE 'ZQTC_R2',  " Message Class
           c_msgno       TYPE symsgno           VALUE '117',      " Message Number
           c_9001        TYPE sy-dynnr          VALUE '9001',     " Scren Number : 9001
           c_9002        TYPE sy-dynnr          VALUE '9002',     " Scren Number : 9002
           c_9003        TYPE sy-dynnr          VALUE '9003',     " Scren Number : 9003
           c_9004        TYPE sy-dynnr          VALUE '9004',     " ABAP System Field: Current Dynpro Number
           c_9005        TYPE sy-dynnr          VALUE '9005',     " ABAP System Field: Current Dynpro Number
           c_9006        TYPE sy-dynnr          VALUE '9006',     " Screen Number : 9006
           c_9007        TYPE sy-dynnr          VALUE '9007',     " ABAP System Field: Current Dynpro Number
           c_9008        TYPE sy-dynnr          VALUE '9008',     " ABAP System Field: Current Dynpro Number
           c_9009        TYPE sy-dynnr          VALUE '9009',     " ABAP System Field: Current Dynpro Number
*          Begin of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
           c_i_lifsk     TYPE lvc_tname        VALUE 'I_LIFSK',    " LVC tab name
           c_i_faksk     TYPE lvc_tname        VALUE 'I_FAKSK',    " LVC tab name
           c_i_kdkg2     TYPE lvc_tname        VALUE 'I_KDKG2',    " LVC tab name
           c_i_licgrp    TYPE lvc_tname        VALUE 'I_ZZLICGRP', " LVC tab name
           c_9013        TYPE sy-dynnr          VALUE '9013',      " ABAP System Field: Current Dynpro Number
           c_9012        TYPE sy-dynnr          VALUE '9012',      " ABAP System Field: Current Dynpro Number
           c_9011        TYPE sy-dynnr          VALUE '9011',      " ABAP System Field: Current Dynpro Number
           c_9010        TYPE sy-dynnr          VALUE '9010',      " ABAP System Field: Current Dynpro Number
           c_9014        TYPE sy-dynnr          VALUE '9014'.      "++VDPATABALL 10/20/2020 OTCM-29460  Billing Date Button
*          End of Change: PBOSE: 05-07-2017: CR#543: ED2K907030
**************************************************************
* LOCAL CLASS Definition for data changed in fieldcatalog ALV
**************************************************************
CLASS lcl_event_receiver DEFINITION FINAL. " Event_receiver class
  PUBLIC SECTION.
    METHODS meth_handle_data_changed
                FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING er_data_changed.
  PRIVATE SECTION.
    DATA lv_error_in_data TYPE c . " Error_in_data of type Character
    METHODS: meth_check_price IMPORTING im_good_kbetr      TYPE lvc_s_modi                           " ALV control: Modified cells for application
                                        im_pr_data_changed TYPE REF TO cl_alv_changed_data_protocol, " Message Log for Data Entry
      meth_check_promo IMPORTING im_good_promo      TYPE lvc_s_modi                                  " ALV control: Modified cells for application
                                 im_pr_data_changed TYPE REF TO cl_alv_changed_data_protocol.        " Message Log for Data Entry

ENDCLASS. "lcl_event_receiver DEFINITION
DATA r_event_receiver TYPE REF TO lcl_event_receiver. " Event_receiver class
* INCLUDE LZQTC_SD_VIEWD...                  " Local class definition
