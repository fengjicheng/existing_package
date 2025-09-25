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
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
TYPE-POOLS: vrm. " Use type group VRM for list
TYPES: BEGIN OF ty_activity,
         activity   TYPE zactivity_sub,  " E095: Activity
         spras      TYPE sy-langu,       " Language
         activity_d TYPE desc40,         " Description
       END OF ty_activity,
       BEGIN OF ty_renwl_prof,
         renwl_prof   TYPE zrenwl_prof, " Renewal Profile
         spras        TYPE spras,       " lANGUAGE KEY
         renwl_prof_d TYPE desc40,     " Description
       END OF ty_renwl_prof,
       BEGIN OF ty_notif_p_det,
         notif_prof  TYPE znotif_prof, " Notification Profile
         notif_rem   TYPE znotif_rem,   " Notification/Reminder
         rem_in_days TYPE zrem_in_days, " Notification Reminder (in Days)
         promo_code  TYPE zpromo,       " Promo code
         renwl_prof  TYPE zrenwl_prof,  " Renewal Profile
       END OF ty_notif_p_det,
       BEGIN OF ty_vbak_header,
         vbeln   TYPE vbak-vbeln, " Sales Order
         angdt   TYPE vbak-angdt, " Quotation start date
         bnddt   TYPE vbak-bnddt, " Date until which bid/quotation is binding (valid-to date)
         vbtyp   TYPE vbak-vbtyp, " SD document category
         auart   TYPE vbak-auart,  " Order type
         vbegdat TYPE veda-vbegdat, " Contract start date
         venddat TYPE veda-venddat, " CONTRACT  end date
         vbelv   TYPE vbfa-vbelv,  " Preceding sales and distribution document
         posnn   TYPE vbfa-posnn,  " Subsequent item of an SD document
       END OF ty_vbak_header,
       BEGIN OF ty_renwl_plan.
TYPES:         sel TYPE char1.       " Field for selection
        INCLUDE TYPE zqtc_renwl_plan." Include structure
TYPES: message TYPE char120.
TYPES:END OF ty_renwl_plan.
TYPES:BEGIN OF ty_nast,
        kappl TYPE sna_kappl,   " Application for message conditions
        objky TYPE na_objkey,   " Object key
        kschl TYPE sna_kschl,   " Message type
        spras TYPE na_spras,    " Message language
        parnr TYPE na_parnr,    " Message partner
        parvw TYPE sna_parvw,   " Partner function (for example SH for ship-to party)
        erdat TYPE na_erdat,    " Date on which status record was created
        eruhr TYPE na_eruhr,    " Time at which status record was created
        adrnr TYPE ad_addrnum,  " Address number
        nacha TYPE na_nacha,    " Message transmission medium
        anzal TYPE na_anzal,    " Number of messages (original + copies)
        vsztp TYPE na_vsztp,    " Dispatch time
        vsdat TYPE na_vsdat,    " Requested date for sending message
        vsura TYPE na_vsura,    " Requested time for sending message (from)
        vsurb TYPE na_vsurb,    " Requested time for sending message (to)
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
    vbeln TYPE vbeln_va,
  END   OF ty_vbeln.

*& Local type declaration
TYPES: tt_item        TYPE STANDARD TABLE OF bapisdit INITIAL SIZE 0,       " Structure of VBAP with English Field Names
       tt_vbfa        TYPE STANDARD TABLE OF vbfa INITIAL SIZE 0,           " Sales Document Flow
       tt_partner     TYPE STANDARD TABLE OF bapisdpart INITIAL SIZE 0,     " BAPI Structure of VBPA with English Field Names
       tt_business    TYPE STANDARD TABLE OF bapisdbusi INITIAL SIZE 0,     " BAPI Structure of VBKD
       tt_textheaders TYPE STANDARD TABLE OF bapisdtehd INITIAL SIZE 0,     " BAPI Structure of THEAD with English Field Names
       tt_textlines   TYPE STANDARD TABLE OF bapitextli INITIAL SIZE 0,     " BAPI Structure for STX_LINES Structure
       tt_return      TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0,       " Return Parameter
       tt_header      TYPE STANDARD TABLE OF bapisdhd INITIAL SIZE 0,       " BAPI Structure of VBAK with English Field Names
       tt_docflow     TYPE STANDARD TABLE OF bapisdflow INITIAL SIZE 0,     " BAPI Structure of VBFA with English Field Names
       tt_activity    TYPE STANDARD TABLE OF ty_activity INITIAL SIZE 0,    " Table type for activity
       tt_renwl_prof  TYPE STANDARD TABLE OF ty_renwl_prof INITIAL SIZE 0,  " type for renewal profile
       tt_renwl_plan  TYPE STANDARD TABLE OF zqtc_renwl_plan INITIAL SIZE 0, " type for renewal plan table
       tt_nast        TYPE STANDARD TABLE OF ty_nast INITIAL SIZE 0
       WITH NON-UNIQUE SORTED KEY objkey COMPONENTS objky,
       tt_final       TYPE STANDARD TABLE OF ty_renwl_plan INITIAL SIZE 0    " final table
       WITH NON-UNIQUE  KEY primary_key COMPONENTS vbeln                     " Primary key
       WITH           NON-UNIQUE SORTED KEY vbeln_key COMPONENTS vbeln posnr activity " Seconadry key
       WITH NON-UNIQUE SORTED KEY activity COMPONENTS vbeln activity,
       tt_veda        TYPE SORTED TABLE OF  ty_vbak_header INITIAL SIZE 0
        WITH UNIQUE KEY vbeln auart posnn vbelv,
       tt_contract    TYPE STANDARD TABLE OF bapisdcntr INITIAL SIZE 0,       " BAPI Structure of VEDA with English Field Names
       tt_notif_p_det TYPE STANDARD TABLE OF ty_notif_p_det INITIAL SIZE 0,   " Notificatio prfile
       tt_const       TYPE STANDARD TABLE OF ty_const INITIAL SIZE 0.         " constant table


*& Local variable declaration
DATA: v_vblen       TYPE vbak-vbeln,       " Global variable for sales order
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
      v_eadat       TYPE zqtc_renwl_plan-eadat, "Activity Date
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*     Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
      v_vkorg       TYPE vbak-vkorg,      " Sales Org
*     End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
      i_fcat        TYPE STANDARD TABLE OF slis_fieldcat_alv INITIAL SIZE 0,
      i_notif_p_det TYPE tt_notif_p_det,  " Internal table for notifcation profile
      i_const       TYPE tt_const,        " Internal table for constant
      i_final       TYPE tt_final,        " Final internal table
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
      i_final1      TYPE tt_final,        " Final internal table
      st_final      TYPE ty_renwl_plan,
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
      i_activity    TYPE tt_activity,     " Internal table for activity
      i_renwl_plan  TYPE tt_renwl_plan,   " Renewal Plan table
      i_renwl_prof  TYPE tt_renwl_prof,   " Renewal profile
      i_veda        TYPE tt_veda,         " Contract
      i_header      TYPE tt_header,       " Header table
      i_docflow     TYPE tt_docflow,      " Document flow table
      v_sales_ord   TYPE bapivbeln-vbeln, " Sales order for storing newly created order
      i_return      TYPE tt_return,        " return table
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
      v_nor         TYPE i.
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887

CONSTANTS : c_v1  TYPE kappl VALUE 'V1',
            c_sep TYPE char1 VALUE '/'.
