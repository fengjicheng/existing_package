*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_REDET_RENEWAL_PROF_TOP
* PROGRAM DESCRIPTION: Include contains Global data declarations
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-21
* OBJECT ID:E095 (CR# ERP-6293)
* TRANSPORT NUMBER(S): ED2K912365
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K912771
* REFERENCE NO: ERP-6343
* DEVELOPER: Writtick Roy
* DATE:  07-AUG-2018
* DESCRIPTION: Do not consider the Line Item, if CQ (Create Quotation)
*              activity is already Completed and the assigned Renewal
*              Profile is applicable for Consolidation
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*

TYPES: BEGIN OF ty_hdr_itm_data,
         vbeln     TYPE vbeln_va,            " Sales and Distribution Document Number
         posnr     TYPE posnr_va,            " Item number of the SD document
         matnr     TYPE matnr,               " Material Number
         pstyv     TYPE pstyv,               " Sales document item category
         uepos     TYPE uepos,               " Higher-level item in bill of material structures
         werks     TYPE werks_d,             " Plant
         mvgr5     TYPE mvgr5,               " Material group 5
         subs_type TYPE zsubtyp,
         vkorg     TYPE vkorg,               " Sales Organization
         bsark_ak  TYPE bsark,               " Customer purchase order type
         vkbur     TYPE vkbur,               " Sales Office
         zzlicgrp  TYPE zlicgrp, "
       END OF ty_hdr_itm_data,

       BEGIN OF ty_vbpa_data,
         vbeln TYPE vbeln_va,                " Sales and Distribution Document Number
         posnr TYPE posnr_va,                " Item number of the SD document
         parvw TYPE parvw,                   " Partner Function
         kunnr TYPE kunnr,                   " Customer Number
         land1 TYPE land1,                   " Country Key
       END OF ty_vbpa_data,

       BEGIN OF ty_veda_data,
         vbeln   TYPE vbeln_va,              " Sales Document
         vposn   TYPE posnr_va,              " Sales Document Item
         vaktsch TYPE vasch_veda,            " Action at end of contract
         venddat TYPE vndat_veda,            " Contract end date
       END OF ty_veda_data,

       BEGIN OF ty_vbkd_data,
         vbeln    TYPE vbeln_va,             " Sales Document
         posnr    TYPE posnr_va,             " Sales Document Item
         konda    TYPE konda,                " Price group (customer)
         kdgrp    TYPE kdgrp,                " Customer group
         pay_type TYPE schzw_bseg,
         bsark    TYPE bsark,                " Customer purchase order type
         kdkg2    TYPE kdkg2,                " Customer condition group 2
       END OF ty_vbkd_data,

       BEGIN OF ty_mat_det,
         matnr TYPE matnr,                   " Material Number
         mtart TYPE mtart,                   " Material Type
       END OF ty_mat_det,

       BEGIN OF ty_constant,
         devid  TYPE zdevid,                 " Development ID
         param1 TYPE rvari_vnam,             " ABAP: Name of Variant Variable
         param2 TYPE rvari_vnam,             " ABAP: Name of Variant Variable
         srno   TYPE tvarv_numb,             " ABAP: Current selection number
         sign   TYPE tvarv_sign,             " ABAP: ID: I/E (include/exclude values)
         opti   TYPE tvarv_opti,             " ABAP: Selection option (EQ/BT/CP/...)
         low    TYPE salv_de_selopt_low,     " Lower Value of Selection Condition
         high   TYPE salv_de_selopt_high,    " Upper Value of Selection Condition
       END OF ty_constant,

       BEGIN OF ty_renewal_det,
         kdgrp           TYPE kdgrp,         " Customer group
         konda           TYPE konda,         " Price group (customer)
         pay_type        TYPE zpay_type,
         sold_to_country TYPE land1,         " Country Key
         ship_to_country TYPE land1,         " Country Key
         license_grp     TYPE  zlicense_grp, " Licence Group(Y/N)
         sales_office    TYPE  vkbur,        " Sales Office
         subs_type       TYPE zsubs_type,    " Subscription Type
         kdkg2           TYPE kdkg2,         " Customer condition group 2
         mvgr5           TYPE mvgr5,         " Material group 5
         bsark           TYPE bsark,         " Customer purchase order type
         vkorg           TYPE vkorg,         " Sales Organization
         werks           TYPE werks_d,       " Plant
         matnr           TYPE matnr,         " Material Number
         zzaction        TYPE vasch_veda,    " Action at end of contract
         renwl_prof      TYPE zrenwl_prof,   " Renewal Profile
       END OF ty_renewal_det,

       BEGIN OF ty_renwl_p_det,
         renwl_prof   TYPE zrenwl_prof,      " Renewal Profile
         quote_time   TYPE zquote_tim,       " Quote Timing
         notif_prof   TYPE znotif_prof,      " Notification Profile
         grace_start  TYPE zgrace_start,     " Grace Start Timing
         grace_period TYPE zgrace_period,    " Grace Period
         auto_renew   TYPE zauto_renew,      " Auto Renew Timing
         lapse        TYPE zlapse,           " Lapse
*        Begin of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771
         consolidate  TYPE zconsolidate,  " Consolidated Renewals
*        End   of ADD:ERP-6343:WROY:07-AUG-2018:ED2K912771
       END OF   ty_renwl_p_det,

       BEGIN OF ty_notif_p_det,
         notif_prof  TYPE znotif_prof,       " Notification Profile
         notif_rem   TYPE znotif_rem,        " Notification/Reminder
         rem_in_days TYPE zrem_in_days,      " Notification Reminder (in Days)
         promo_code  TYPE zpromo,            " Promo code
       END OF ty_notif_p_det,


       BEGIN OF ty_final,
         sel             TYPE char1,         " Field for selection
         vbeln           TYPE vbeln_va,      " Sales and Distribution Document Number
         posnr           TYPE posnr_va,      " Item number of the SD document
         sold_to         TYPE kunnr,         " Partner Function
         ship_to         TYPE kunnr,         " Partner Function
         kdgrp           TYPE kdgrp,         " Customer group
         konda           TYPE konda,         " Price group (customer)
         pay_type        TYPE zpay_type,
         sold_to_country TYPE land1,         " Country Key
         ship_to_country TYPE land1,         " Country Key
         license_grp     TYPE zlicense_grp,  " Licence Group(Y/N)
         sales_office    TYPE  vkbur,        " Sales Office
         subs_type       TYPE zsubs_type,    " Suabscription Type
         kdkg2           TYPE kdkg2,         " Customer condition group 2
         mvgr5           TYPE mvgr5,         " Material group 5
         bsark           TYPE bsark,         " Customer purchase order type
         vkorg           TYPE vkorg,         " Sales Organization
         werks           TYPE werks_d,       " Plant
         matnr           TYPE matnr,         " Material Number
         zzaction        TYPE vasch_veda,    " Action at end of contract
         renwl_prof      TYPE zrenwl_prof,   " Renewal Profile
         renwl_prof_new  TYPE zrenwl_prof,   " Renewal Profile
         message         TYPE char120,       " Message of type CHAR120
       END OF ty_final.


TYPES : tt_final        TYPE STANDARD TABLE OF ty_final INITIAL SIZE 0,
        tt_constant     TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
        tt_hdr_itm_data TYPE STANDARD TABLE OF ty_hdr_itm_data INITIAL SIZE 0,
        tt_vbpa_data    TYPE STANDARD TABLE OF ty_vbpa_data INITIAL SIZE   0,
        tt_renewal_plan TYPE STANDARD TABLE OF zqtc_renwl_plan INITIAL SIZE 0,  " E095: Renewal Plan Table
        tt_renewal_det  TYPE STANDARD TABLE OF ty_renewal_det INITIAL SIZE 0,
        tt_pay_key_typ  TYPE STANDARD TABLE OF zqtc_pay_key_typ INITIAL SIZE 0, " E095: Map Payment Method to Payment Type
        tt_veda_data    TYPE STANDARD TABLE OF ty_veda_data INITIAL SIZE 0,
        tt_renwl_p_det  TYPE STANDARD TABLE OF ty_renwl_p_det INITIAL SIZE 0,
        tt_notif_p_det  TYPE STANDARD TABLE OF ty_notif_p_det INITIAL SIZE  0,
        tt_vbkd_data    TYPE STANDARD TABLE OF ty_vbkd_data INITIAL SIZE 0,
        tt_mat_det      TYPE STANDARD TABLE OF ty_mat_det   INITIAL SIZE 0.     " Table Type for Material Details


CONSTANTS :     c_sold_to   TYPE parvw VALUE 'AG',     " Partner Function
                c_ship_to   TYPE parvw VALUE 'WE',     " Partner Function
                c_rolng_yr  TYPE zsubs_type VALUE 'R', " Rolling Year
                c_clndr_yr  TYPE zsubs_type VALUE 'C', " Calendar Year
                c_posnr_low TYPE posnr VALUE '000000'. " Item number of the SD document

DATA : v_vbeln           TYPE vbak-vbeln,                " Global variable for sales order
       v_erdat           TYPE vbak-erdat,                "Activity Date
       v_vkorg           TYPE vbak-vkorg,                " Sales Org
       v_kdgrp           TYPE vbkd-kdgrp,                " Customer group
       v_konda           TYPE vbkd-konda,                " Price group (customer)
       v_pay_type        TYPE vbkd-zlsch,
       v_sold_to_country TYPE vbpa-land1,                " Country Key
       v_ship_to_country TYPE vbpa-land1,                " Country Key
       v_license_grp     TYPE zqtc_rp_deter-license_grp, " Licence Group(Y/N)
       v_sales_office    TYPE vbak-vkbur,                " Sales Office
       v_subs_type       TYPE vbap-zzsubtyp,
       v_kdkg2           TYPE vbkd-kdkg2,                " Customer condition group 2
       v_mvgr5           TYPE vbap-mvgr5,                " Material group 5
       v_bsark           TYPE vbak-bsark,                " Customer purchase order type
       v_werks           TYPE vbap-werks,                " Plant (Own or External)
       v_matnr           TYPE vbap-matnr,                " Material Number
       v_zzaction        TYPE veda-vaktsch,              " Action at end of contract
       v_renwl_prof      TYPE zqtc_rp_deter-renwl_prof,  " Renewal Profile
       v_sold_to_cust    TYPE vbpa-kunnr,                " Customer Number
       v_ship_to_cust    TYPE vbpa-kunnr,                " Customer Number
       v_auart           TYPE vbak-auart,                " Sales Document Type
       i_fcat            TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0,
       i_final           TYPE tt_final,
       i_constant        TYPE tt_constant,
       i_hdr_itm_data    TYPE tt_hdr_itm_data,
       i_vbpa_data       TYPE tt_vbpa_data,
       i_renewal_plan    TYPE tt_renewal_plan,           " E095: Renewal Plan Table
       i_renewal_det     TYPE tt_renewal_det,
       i_pay_key_typ     TYPE tt_pay_key_typ,
       i_veda_data       TYPE tt_veda_data,
       i_renwl_p_det     TYPE tt_renwl_p_det,
       i_notif_p_det     TYPE tt_notif_p_det,
       i_vbkd_data       TYPE tt_vbkd_data,
       i_mat_det         TYPE tt_mat_det.
