*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_E096_TOP_INDCLUDE
* PROGRAM DESCRIPTION:Include for Data Declaration
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2017-01-04
* OBJECT ID:E095
* TRANSPORT NUMBER(S) ED2K903901
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907327
* REFERENCE NO:  ERP 3301
* DEVELOPER: ANIRBAN SAHA
* DATE:  2017-07-25
* DESCRIPTION: Remove status change checkbox from selection screen
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910691
* REFERENCE NO:  ERP 6242
* DEVELOPER: Writtick Roy
* DATE:  2018-02-05
* DESCRIPTION: 1. Make Activity Date as a Range
*              2. Add new Selection Criteria based on Sales Org
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912349
* REFERENCE NO:  ERP-6347
* DEVELOPER: Writtick Roy
* DATE:  2018-06-19
* DESCRIPTION:  Add Exclude and Include Options (Exclusion Reason/Date)
*------------------------------------------------------------------- *
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912802
* REFERENCE NO:  ERP-6343
* DEVELOPER: Writtick Roy (WROY) / Niraj Gadre (NGADRE)
* DATE:  2018-08-01
* DESCRIPTION:  Add the logic to create the single quotation / reminders
*for sub. orders with Consolidate = 'X' in renewal profile
*------------------------------------------------------------------- *
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912739
* REFERENCE NO:  CR# 6295
* DEVELOPER: Kiran Kumar Ravuri (KKR)
* DATE:  2018-09-10
* DESCRIPTION: Maintain th Logs for each record process
*------------------------------------------------------------------- *
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915501
* REFERENCE NO: DM# 1916
* DEVELOPER: Prabhu(PTUFARAM)
* DATE:  2019-07-12
* DESCRIPTION: Addition of Exclusion reason 2 and comments functionality
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
TYPE-POOLS: vrm. " Use type group VRM for list
TYPES: BEGIN OF ty_activity,
         activity   TYPE zactivity_sub, " E095: Activity
         spras      TYPE sy-langu,      " Language
         activity_d TYPE desc40,        " Description
       END OF ty_activity,
       BEGIN OF ty_renwl_prof,
         renwl_prof   TYPE zrenwl_prof, " Renewal Profile
         spras        TYPE spras,       " lANGUAGE KEY
         renwl_prof_d TYPE desc40,      " Description
       END OF ty_renwl_prof,
       BEGIN OF ty_notif_p_det,
         notif_prof  TYPE znotif_prof,  " Notification Profile
         notif_rem   TYPE znotif_rem,   " Notification/Reminder
         rem_in_days TYPE zrem_in_days, " Notification Reminder (in Days)
         promo_code  TYPE zpromo,       " Promo code
         renwl_prof  TYPE zrenwl_prof,  " Renewal Profile
       END OF ty_notif_p_det,
*      Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
       BEGIN OF ty_excl_resn,
         excl_resn   TYPE zexcl_resn, " Exclusion Reason
         excl_resn_d TYPE desc40,     " Description
       END OF ty_excl_resn,
*      End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
       BEGIN OF ty_vbak_header,
         vbeln   TYPE vbak-vbeln,   " Sales Order
         angdt   TYPE vbak-angdt,   " Quotation start date
         bnddt   TYPE vbak-bnddt,   " Date until which bid/quotation is binding (valid-to date)
         vbtyp   TYPE vbak-vbtyp,   " SD document category
         auart   TYPE vbak-auart,   " Order type
         vbegdat TYPE veda-vbegdat, " Contract start date
         venddat TYPE veda-venddat, " CONTRACT  end date
         vbelv   TYPE vbfa-vbelv,   " Preceding sales and distribution document
         posnn   TYPE vbfa-posnn,   " Subsequent item of an SD document
       END OF ty_vbak_header,
       BEGIN OF ty_renwl_plan.
TYPES:         sel     TYPE char1. " Field for selection
               INCLUDE TYPE zqtc_renwl_plan. " Include structure
               TYPES: message TYPE char120. " Types: message of type CHAR120
* Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
TYPES: excl_resn_d TYPE desc40. " Exclusion_reason description
* End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
TYPES : excl_resn_d2 TYPE desc40. " Exclusion_reason description
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
* Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
TYPES: notif_prof  TYPE znotif_prof,  " Notification Profile
       consolidate TYPE zconsolidate. " Consolidated Renewals
* End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
* BOC ED2K912739
TYPES: log_type_desc TYPE zmsg_icon_desc.
* EOC ED2K912739
TYPES:END OF ty_renwl_plan.
TYPES:BEGIN OF ty_nast,
        kappl TYPE sna_kappl,  " Application for message conditions
        objky TYPE na_objkey,  " Object key
        kschl TYPE sna_kschl,  " Message type
        spras TYPE na_spras,   " Message language
        parnr TYPE na_parnr,   " Message partner
        parvw TYPE sna_parvw,  " Partner function (for example SH for ship-to party)
        erdat TYPE na_erdat,   " Date on which status record was created
        eruhr TYPE na_eruhr,   " Time at which status record was created
        adrnr TYPE ad_addrnum, " Address number
        nacha TYPE na_nacha,   " Message transmission medium
        anzal TYPE na_anzal,   " Number of messages (original + copies)
        vsztp TYPE na_vsztp,   " Dispatch time
        vsdat TYPE na_vsdat,   " Requested date for sending message
        vsura TYPE na_vsura,   " Requested time for sending message (from)
        vsurb TYPE na_vsurb,   " Requested time for sending message (to)
      END OF ty_nast.
TYPES :
**----Structures
  BEGIN OF ty_const,
    devid    TYPE zdevid,              "Development ID
    param1   TYPE rvari_vnam,          "Parameter1
    param2   TYPE rvari_vnam,          "Parameter2
    srno     TYPE tvarv_numb,          "Serial Number
    sign     TYPE tvarv_sign,          "Sign
    opti     TYPE tvarv_opti,          "Option
    low      TYPE salv_de_selopt_low,  "Low
    high     TYPE salv_de_selopt_high, "High
    activate TYPE zconstactive,        "Active/Inactive Indicator
  END OF ty_const.

TYPES :
**----Structures
  BEGIN OF ty_vbeln,
    vbeln TYPE vbeln_va, " Sales Document
  END   OF ty_vbeln,

*Begin of ADD:ERP-6343:NGADRE:01-AUG-2018:ED2K912802
**Structure for consolidation logic
  BEGIN OF ty_consolidate_data,
    ship_to       TYPE kunnr,         " Customer Number
    bill_to       TYPE kunnr,         " Customer Number
    vkorg         TYPE vkorg,         " Sales Organization
    distr_chan    TYPE vtweg,         " Distribution Channel
    division      TYPE spart,         " Division
    sales_off     TYPE vkbur,         " Sales Office
    po_method     TYPE bsark,         " Customer purchase order type
    waers         TYPE waers,         " Currency Key
    conteddt      TYPE vndat_veda,    " Contract end date
    activity      TYPE zactivity_sub, " activity
    renwl_profile TYPE zrenwl_prof,   " Renewal Profile
*   Begin of ADD:ERP-6343:WROY:28-AUG-2018:ED2K913164
    renwl_quote   TYPE vbeln_va,      " Renewal Quote
*   End   of ADD:ERP-6343:WROY:28-AUG-2018:ED2K913164
    renwl_date    TYPE erdat,         " Date on Which Record Was Created
    vbeln         TYPE vbeln_va,      " Sales Document
    posnr         TYPE posnr_va,      " Sales Document Item
    act_status    TYPE char01,        " Status of type CHAR01
    material      TYPE matnr,         " Material Number
  END OF ty_consolidate_data,

  BEGIN OF ty_sub_mat,
    matwa TYPE matwa,                 " Material entered
    smatn TYPE smatn,                 " Substitute material
  END OF ty_sub_mat.
*Begin of ADD:ERP-6343:NGADRE:01-AUG-2018:ED2K912802

*& Local type declaration
TYPES: tt_item             TYPE STANDARD TABLE OF bapisdit INITIAL SIZE 0,        " Structure of VBAP with English Field Names
       tt_vbfa             TYPE STANDARD TABLE OF vbfa INITIAL SIZE 0,            " Sales Document Flow
       tt_partner          TYPE STANDARD TABLE OF bapisdpart INITIAL SIZE 0,      " BAPI Structure of VBPA with English Field Names
       tt_business         TYPE STANDARD TABLE OF bapisdbusi INITIAL SIZE 0,      " BAPI Structure of VBKD
       tt_textheaders      TYPE STANDARD TABLE OF bapisdtehd INITIAL SIZE 0,      " BAPI Structure of THEAD with English Field Names
       tt_textlines        TYPE STANDARD TABLE OF bapitextli INITIAL SIZE 0,      " BAPI Structure for STX_LINES Structure
       tt_return           TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0,        " Return Parameter
       tt_header           TYPE STANDARD TABLE OF bapisdhd INITIAL SIZE 0,        " BAPI Structure of VBAK with English Field Names
       tt_docflow          TYPE STANDARD TABLE OF bapisdflow INITIAL SIZE 0,      " BAPI Structure of VBFA with English Field Names
       tt_ext_vbap         TYPE STANDARD TABLE OF bape_vbap INITIAL SIZE 0,       " Added by MODUTTA on 5th-Jun-2018:INC0197849:TR# ED1K907603
       tt_ext_vbapx        TYPE STANDARD TABLE OF bape_vbapx INITIAL SIZE 0,      " Added by MODUTTA on 5th-Jun-2018:INC0197849:TR# ED1K907603
       tt_activity         TYPE STANDARD TABLE OF ty_activity INITIAL SIZE 0,     " Table type for activity
       tt_renwl_prof       TYPE STANDARD TABLE OF ty_renwl_prof INITIAL SIZE 0,   " type for renewal profile
       tt_renwl_plan       TYPE STANDARD TABLE OF zqtc_renwl_plan INITIAL SIZE 0, " type for renewal plan table
*      Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
       tt_excl_resn        TYPE STANDARD TABLE OF ty_excl_resn INITIAL SIZE 0, " type for Exclusion reason table
*      End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
       tt_nast             TYPE STANDARD TABLE OF ty_nast INITIAL SIZE 0
       WITH NON-UNIQUE SORTED KEY objkey COMPONENTS objky,
       tt_final            TYPE STANDARD TABLE OF ty_renwl_plan INITIAL SIZE 0 " final table
       WITH NON-UNIQUE  KEY primary_key COMPONENTS vbeln                       " Primary key
       WITH NON-UNIQUE SORTED KEY vbeln_key COMPONENTS vbeln posnr activity    " Seconadry key
*      Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
       WITH NON-UNIQUE SORTED KEY order_key COMPONENTS vbeln posnr " Seconadry key
*      End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
       WITH NON-UNIQUE SORTED KEY activity COMPONENTS vbeln activity,
       tt_veda             TYPE SORTED TABLE OF  ty_vbak_header INITIAL SIZE 0
        WITH UNIQUE KEY vbeln auart posnn vbelv,
       tt_contract         TYPE STANDARD TABLE OF bapisdcntr INITIAL SIZE 0,     " BAPI Structure of VEDA with English Field Names
       tt_notif_p_det      TYPE STANDARD TABLE OF ty_notif_p_det INITIAL SIZE 0, " Notificatio prfile
       tt_const            TYPE STANDARD TABLE OF ty_const INITIAL SIZE 0,       " constant table
*Begin of ADD:ERP-6343:NGADRE:01-AUG-2018:ED2K912802
       tt_consolidate_data TYPE STANDARD TABLE OF ty_consolidate_data INITIAL SIZE 0,
       tt_sub_mat          TYPE STANDARD TABLE OF ty_sub_mat INITIAL SIZE 0.
*End of ADD:ERP-6343:NGADRE:01-AUG-2018:ED2K912802


*& Local variable declaration
DATA: v_vblen       TYPE vbak-vbeln, " Global variable for sales order
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
      v_eadat       TYPE zqtc_renwl_plan-eadat, "Activity Date
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*     Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
      v_vkorg       TYPE vbak-vkorg, " Sales Org
*     End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
*     Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
      v_matnr       TYPE vbap-matnr,                " Material Number
      v_mvgr5       TYPE vbap-mvgr5,                " Material group 5
      v_kdkg2       TYPE vbkd-kdkg2,                " Customer condition group 2
      v_excl_resn   TYPE zqtc_renwl_plan-excl_resn, " Exclusion reason
      v_message     TYPE string,
      v_return      TYPE c,
*     End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
      i_fcat        TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0,
      i_notif_p_det TYPE tt_notif_p_det, " Internal table for notifcation profile
      i_const       TYPE tt_const,       " Internal table for constant
      i_final       TYPE tt_final,       " Final internal table
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
      i_final1      TYPE tt_final, " Final internal table
      st_final      TYPE ty_renwl_plan,
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
      i_activity    TYPE tt_activity,   " Internal table for activity
      i_renwl_plan  TYPE tt_renwl_plan, " Renewal Plan table
      i_renwl_prof  TYPE tt_renwl_prof, " Renewal profile
*     Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
      i_excl_resn   TYPE tt_excl_resn, " Exclusion reason table
*     End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
      i_veda        TYPE tt_veda,         " Contract
      i_header      TYPE tt_header,       " Header table
      i_docflow     TYPE tt_docflow,      " Document flow table
      i_ext_vbap    TYPE tt_ext_vbap,     " Added by MODUTTA on 5th-Jun-2018:INC0197849:TR# ED1K907603
      v_sales_ord   TYPE bapivbeln-vbeln, " Sales order for storing newly created order
      i_return      TYPE tt_return,       " return table
      i_item        TYPE tt_item,         " Item
      i_nast        TYPE tt_nast,         " NAST table
      i_contr_data  TYPE tt_contract,     " Contract table
      i_partner     TYPE tt_partner,      " Partner details
      i_business    TYPE tt_business,     " Order Partners for Document Numbers
      i_textheaders TYPE tt_textheaders,  " Text headewr
      i_textlines   TYPE tt_textlines,    " text lines
      i_list_act    TYPE vrm_values,      " Activity code
      i_list_renwl  TYPE vrm_values,      " renewal plan details
      i_vbeln       TYPE STANDARD TABLE OF ty_vbeln,
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
      v_nor         TYPE i. " Nor of type Integers
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
DATA:ir_auart    TYPE fssc_dp_t_rg_auart,      "Internal table for auart "+++VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
     ir_auart_ck TYPE fssc_dp_t_rg_auart.
CONSTANTS : c_v1          TYPE kappl VALUE 'V1', " Application
*           Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
            c_posnr_low   TYPE posnr VALUE '000000', " Item 0
*           End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*           BOC by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
            c_bape_vbap   TYPE te_struc VALUE 'BAPE_VBAP',  " Structure name of  BAPI table extension
            c_bape_vbapx  TYPE te_struc VALUE 'BAPE_VBAPX', " Structure name of  BAPI table extension
*           EOC by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
            c_sep         TYPE char1 VALUE '/', " Sep of type CHAR1
*** Begin of: CR# 6295  KKRAVURI 20180914  ED2K912739
            c_msg_typ_e   TYPE char1   VALUE 'E',
            c_msg_typ_a   TYPE char1   VALUE 'A',
            c_msg_typ_s   TYPE char1   VALUE 'S',
            c_msg_typ_w   TYPE char1   VALUE 'W',
            c_msg_typ_i   TYPE char1   VALUE 'I',
            c_msg_num_6   TYPE symsgno VALUE '006',
            c_msg_num_0   TYPE symsgno VALUE '000',
            c_msg_num_308 TYPE symsgno VALUE '308',
            c_zqtc_r2     TYPE symsgid VALUE 'ZQTC_R2'.
*** End of: CR# 6295  KKRAVURI 20180914  ED2K912739


* BOC: CR# 6295 ED2K912739
TYPE-POOLS slis.

DATA: st_bal_msg   TYPE bal_s_msg,  " Application Log: Message Data Structure
      i_bal_msg    TYPE bal_t_msg,  " Application Log: Message Data Table
      i_log_handle TYPE bal_t_logh, " Application Log: Log Handle Table
      st_return    TYPE bapiret2,   " Return Message
      v_1st_var    TYPE char50,     " First Document
      v_log_handle TYPE balloghndl, " Application Log: Log Handle
      v_lognumber  TYPE balognr,    " Application log: log number
      v_log_type   TYPE symsgty,    " Message Type
      v_exp_days   TYPE numc3,      " Expiry days
      v_msgv1      TYPE msgv1,      " Message variable 01
      v_msgv2      TYPE msgv2,      " Message variable 02
      v_msgv3      TYPE msgv3,      " Message variable 03
      v_msgv4      TYPE msgv4.      " Message variable 04
* EOC: CR# 6295 ED2K912739
