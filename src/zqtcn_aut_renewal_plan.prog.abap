*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_AUT_RENEWAL_PLAN
* PROGRAM DESCRIPTION:Include for populating auto renewal plan table
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2017-01-04
* OBJECT ID:E095
* TRANSPORT NUMBER(S) ED2K903783
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907190
* REFERENCE NO:  CR 585
* DEVELOPER: Anirban Saha
* DATE:  2017-06-28
* DESCRIPTION: Considering Material no while determining renewal profile
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907222
* REFERENCE NO: Defect 3096
* DEVELOPER: Anirban Saha
* DATE:  2017-07-17
* DESCRIPTION: Introducing multiple payment types for Direct debit
*              in constant table
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907222
* REFERENCE NO: Defect 3055
* DEVELOPER: Anirban Saha
* DATE:  2017-07-19
* DESCRIPTION: Introduce Payment type (VCH Scenario) as Direct Debit
*              while determining Renewal Profile.
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907222
* REFERENCE NO: Defect 3432
* DEVELOPER: Anirban Saha
* DATE:  2017-07-20
* DESCRIPTION: Cancelling line items in Sub should show 'Cancelled'
*              in Plan table
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907698
* REFERENCE NO: Defect 3055
* DEVELOPER: Anirban Saha
* DATE:  2017-08-02
* DESCRIPTION: Plan table was not getting updated while creating ZSUB
*              order without opening a new session.
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908108
* REFERENCE NO: Defect 4122
* DEVELOPER: Anirban Saha
* DATE:  2017-08-22
* DESCRIPTION: Include Opt In product in the renewal plan table
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K909016
* REFERENCE NO: CR 650
* DEVELOPER: Anirban Saha
* DATE:  2017-10-16
* DESCRIPTION: VCH Renewal profile determination
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K909175
* REFERENCE NO: ERP-4841
* DEVELOPER: Writtick Roy
* DATE:  2017-10-25
* DESCRIPTION: Opt-In Item to be added only after Validity ends
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K909462
* REFERENCE NO: ERP-5132
* DEVELOPER: Writtick Roy
* DATE:  2017-11-14
* DESCRIPTION: Check for Valid Material (Journal Media Product)
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K910013
* REFERENCE NO: ERP-5703
* DEVELOPER: Writtick Roy
* DATE:  2017-12-20
* DESCRIPTION: Consider Notification activities for Non FTP agaent
*              (PO Type 0315)
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K910013
* REFERENCE NO: ERP-5265
* DEVELOPER: Writtick Roy
* DATE:  2017-12-20
* DESCRIPTION: Consider existing SO / Contract lines, if missing in
*              Renewal Plan table
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K910701
* REFERENCE NO: ERP-6495
* DEVELOPER: Writtick Roy
* DATE:  2018-02-05
* DESCRIPTION: Consider BOM Headers in order to identify Material
*              Substitution (even if it is not changed)
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K910725
* REFERENCE NO: ERP-6058
* DEVELOPER: Writtick Roy
* DATE:  2018-02-07
* DESCRIPTION: New Logic to map Payment Pethod to Payment Key
*------------------------------------------------------------------- *
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K912187, ED2K912558
* REFERENCE NO: ERP-6117
* DEVELOPER: Monalisa Dutta
* DATE:  2018-05-30
* DESCRIPTION: Additional criteria to determine ZQTC_RENEWAL
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K907645, ED1K907740
* REFERENCE NO: INC0198259
* DEVELOPER: Writtick Roy
* DATE:  2018-06-07
* DESCRIPTION: Consider both Doc Types - ZSUB & ZREW for cancellation
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K912338
* REFERENCE NO: ERP-6347
* DEVELOPER: Writtick Roy
* DATE:  2018-06-18
* DESCRIPTION: Additional field for Exclusion Reason
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K912338, ED2K912558
* REFERENCE NO: ERP-6293
* DEVELOPER: Writtick Roy
* DATE:  2018-06-25
* DESCRIPTION: Redetermine Renewal Profile
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K907955
* REFERENCE NO: INC0202834
* DEVELOPER: Writtick Roy
* DATE:  2018-07-12
* DESCRIPTION: Fix calculation of Auto Renewal and Lapse Date
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K912771
* REFERENCE NO: ERP-6343
* DEVELOPER: Writtick Roy
* DATE:  2018-07-26
* DESCRIPTION: Do not consider the Line Item, if CQ (Create Quotation)
*              activity is already Completed and the assigned Renewal
*              Profile is applicable for Consolidation
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913197
* REFERENCE NO: ERP-7707
* DEVELOPER: Writtick Roy
* DATE:  2018-08-23
* DESCRIPTION: Do not consider the Opt-In record, if Product
*              Substitution is not maintained
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K910215
* REFERENCE NO: INC0239319
* DEVELOPER: Nikhilesh Palla (NPALLA)
* DATE:  2018-05-27
* DESCRIPTION: Renewal Plan redetermining after the subscription is
*              already renewed. Fix to not change Renwal Plan after
*              renewal subscription is created.
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ERPM-15045
* REFERENCE NO: ED2K919935
* DEVELOPER:    PTUFARAM (Prabhu)
* DATE:         10/20/2020
* DESCRIPTION: VBFA flow breaks when ZSQT is created without reference,
*              to fill the same, used BNAME and fetching reference contract
*              to update Renewal table.
*----------------------------------------------------------------------*
*& Trigger logic for contract
TYPES:
  BEGIN OF lty_renwl_p_det,
    renwl_prof   TYPE zrenwl_prof,   " Renewal Profile
    quote_time   TYPE zquote_tim,    " Quote Timing
    notif_prof   TYPE znotif_prof,   " Notification Profile
    grace_start  TYPE zgrace_start,  " Grace Start Timing
    grace_period TYPE zgrace_period, " Grace Period
    auto_renew   TYPE zauto_renew,   " Auto Renew Timing
    lapse        TYPE zlapse,        " Lapse
*   Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912771
    consolidate  TYPE zconsolidate,  " Consolidated Renewals
*   End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912771
  END OF   lty_renwl_p_det,
  BEGIN OF lty_notif_p_det,
    notif_prof  TYPE znotif_prof,  " Notification Profile
    notif_rem   TYPE znotif_rem,   " Notification/Reminder
    rem_in_days TYPE zrem_in_days, " Notification Reminder (in Days)
    promo_code  TYPE zpromo,       " Promo code
  END OF lty_notif_p_det,
  BEGIN OF lty_ren_subs,
    vbelv TYPE vbeln_von,          " Preceding sales and distribution document
    posnv TYPE posnr_von,          " Preceding item of an SD document
    vbeln TYPE vbeln_nach,         " Subsequent sales and distribution document
    posnn TYPE posnr_nach,         " Subsequent item of an SD document
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
    matnr TYPE matnr, " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
  END OF lty_ren_subs,

*Begin of ADD:ERP-4841:WROY:25-Oct-2017:ED2K909175
  BEGIN OF lty_mat_subs,
    kdgrp TYPE kdgrp,   " Customer group
    matwa TYPE matwa,   " Material entered
    smatn TYPE smatn,   " Substitute material
    datbi TYPE kodatbi, " Validity end date of the condition record
    datab TYPE kodatab, " Validity start date of the condition record
  END   OF lty_mat_subs,
*End   of ADD:ERP-4841:WROY:25-Oct-2017:ED2K909175

*Begin of ADD:ERP-5132:WROY:14-Nov-2017:ED2K909462
  BEGIN OF lty_mat_det,
    matnr TYPE matnr, " Material Number
    mtart TYPE mtart, " Material Type
  END OF lty_mat_det,
*End   of ADD:ERP-5132:WROY:14-Nov-2017:ED2K909462

  BEGIN OF ty_constant,
    devid  TYPE zdevid,              " Development ID
    param1 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
    param2 TYPE rvari_vnam,          " ABAP: Name of Variant Variable
    srno   TYPE tvarv_numb,          " ABAP: Current selection number
    sign   TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
    opti   TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
    low    TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
    high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
  END OF ty_constant.

TYPES:          ltt_renwl_p_det TYPE STANDARD TABLE OF lty_renwl_p_det
                INITIAL SIZE 0 WITH NON-UNIQUE SORTED KEY renwl_prof  COMPONENTS renwl_prof notif_prof
                  WITH NON-UNIQUE SORTED KEY renwl_pro COMPONENTS renwl_prof,
                ltt_renwl_plan  TYPE STANDARD TABLE OF zqtc_renwl_plan INITIAL SIZE 0, " Table Type for Renewal Plan
                ltt_ren_subs    TYPE STANDARD TABLE OF lty_ren_subs    INITIAL SIZE 0, " Table Type for Renewal Subs Orders
*Begin of ADD:ERP-4841:WROY:25-Oct-2017:ED2K909175
                ltt_mat_subs    TYPE STANDARD TABLE OF lty_mat_subs    INITIAL SIZE 0, " Table Type for Material Substitution
*End   of ADD:ERP-4841:WROY:25-Oct-2017:ED2K909175
*Begin of ADD:ERP-5132:WROY:14-Nov-2017:ED2K909462
                ltt_mat_det     TYPE STANDARD TABLE OF lty_mat_det     INITIAL SIZE 0, " Table Type for Material Details
*End   of ADD:ERP-5132:WROY:14-Nov-2017:ED2K909462
                ltt_notif_p_det TYPE STANDARD TABLE OF lty_notif_p_det " Table type for Notification Profile
                       INITIAL SIZE 0 WITH NON-UNIQUE SORTED KEY notif_prof COMPONENTS notif_prof
                .
DATA: lr_rp_deter      TYPE REF TO zqtc_rp_deter,                    " Ref Variable for E095: Renewal Profile Determination Table
      lr_rp_deter_t    TYPE REF TO ty_rp_deter,                      " Ref variable
      lr_renwl_p_det   TYPE REF TO lty_renwl_p_det,                  " Ref variable for renewal Plan deter
      lr_renwl_plan    TYPE REF TO zqtc_renwl_plan,                  " Ref variable for E095: Renewal Plan Table
      li_renwl_plan_t  TYPE TABLE OF zqtc_renwl_plan INITIAL SIZE 0, " Ref variable for E095: Renewal Plan Table
      li_notif_p_det_t TYPE ltt_notif_p_det,                         " Temp. Table for Notification profile
      li_notif_p_det   TYPE ltt_notif_p_det,                         " Internal table for Notification Profile
      li_renwl_plan    TYPE ltt_renwl_plan,                          " Internal Table for Renewal Plan
      li_ren_subs      TYPE ltt_ren_subs,                            " Internal Table for Renewal Subs orders
      lr_notif_p_det   TYPE REF TO lty_notif_p_det,                  " Reference Variable
*Begin of ADD:ERP-4841:WROY:25-Oct-2017:ED2K909175
      li_mat_subs      TYPE ltt_mat_subs, " Internal Table for Material Substitutions
      lv_mat_subs      TYPE flag,         " General Flag
      lv_ren_start_dt  TYPE sydatum,      " Renewal Start Date
*End   of ADD:ERP-4841:WROY:25-Oct-2017:ED2K909175
*Begin of ADD:ERP-5132:WROY:14-Nov-2017:ED2K909462
      li_mat_det       TYPE ltt_mat_det,      " Internal Table for Material Details
      lr_mat_type_jrnl TYPE md_range_t_mtart, " Range Table for Material Type
*End   of ADD:ERP-5132:WROY:14-Nov-2017:ED2K909462
      li_renwl_det_t   TYPE tt_rp_deter,
      li_xvbap         TYPE va_vbapvb_t,
      li_xvbap_k       TYPE va_vbapvb_t,
      li_xvbfa         TYPE TABLE OF vbfavb INITIAL SIZE 0, " Reference Structure for XVBFA/YVBFA
      lst_xvbap_e095   TYPE vbapvb,                         " Work Area
      lv_subrc         TYPE sy-subrc,                       " Variable
      lv_scenario      TYPE sy-subrc,                       " ABAP System Field: Return Code of ABAP Statements
      lv_days          TYPE t5a4a-dlydy,                    " Variable for days
      li_renwl_p_det   TYPE ltt_renwl_p_det,
      li_constant      TYPE STANDARD TABLE OF ty_constant,
*     Begin of DEL:ERP-6293:WROY:25-JUN-2018:ED2K912338
*     Begin of ADD:ERP-5265:WROY:20-Dec-2017:ED2K910013
*     li_ren_plan_ex   TYPE tdt_sw_vbap_key,
*     End   of ADD:ERP-5265:WROY:20-Dec-2017:ED2K910013
*     End   of DEL:ERP-6293:WROY:25-JUN-2018:ED2K912338
*     Begin of ADD:ERP-6293:WROY:25-JUN-2018:ED2K912338
      li_ren_plan_ex   TYPE ltt_renwl_plan,
*     End   of ADD:ERP-6293:WROY:25-JUN-2018:ED2K912338
*Begin of DEL:ERP-6058:WROY:07-Feb-2018:ED2K910725
**Begin of Add-Anirban-07.07.2017-ED2K907222-Defect 3096
*     lir_zlsch_range  TYPE STANDARD TABLE OF izlsch,
*     lst_zlsch_range  TYPE izlsch,
**End of Add-Anirban-07.07.2017-ED2K907222-Defect 3096
*End   of DEL:ERP-6058:WROY:07-Feb-2018:ED2K910725
*Begin of ADD:ERP-6058:WROY:07-Feb-2018:ED2K910725
      li_pay_key_typ   TYPE STANDARD TABLE OF zqtc_pay_key_typ INITIAL SIZE 0, " E095: Map Payment Method to Payment Type
*End   of ADD:ERP-6058:WROY:07-Feb-2018:ED2K910725
*Begin of Add-Anirban-08.22.2017-ED2K908108-Defect 4002
      lir_pstyv_range  TYPE STANDARD TABLE OF /spe/pstyv_range, " Structure for Ranges Table for item category
      lst_pstyv_range  TYPE /spe/pstyv_range,                   " Structure for Ranges Table for item category
*End of Add-Anirban-
      lir_auart_range  TYPE fip_t_auart_range,
      lst_auart_range  TYPE fip_s_auart_range,        " Range: Sales Document Type
      lst_constant     TYPE ty_constant,
      lst_xvbfa_z      TYPE vbfavb,                   " Reference Structure for XVBFA/YVBFA
      li_veda          TYPE STANDARD TABLE OF vedavb. " Reference Structure XVEDA/YVEDA

CONSTANTS: lc_contract TYPE vbak-vbtyp    VALUE 'G',  " Contract
           lc_quot     TYPE vbak-vbtyp    VALUE 'B',  " Quotation
           lc_cr_quote TYPE zactivity_sub VALUE 'CQ', " Create Quotation Activity
           lc_cr_subs  TYPE zactivity_sub VALUE 'CS', " Create Subscription activity
           lc_gr_subs  TYPE zactivity_sub VALUE 'GR', " Grace Subscription
           lc_gr_per   TYPE zactivity_sub VALUE 'GP', " Grace Subscription Period
*          Begin of DEL:ERP-6058:WROY:07-Feb-2018:ED2K910725
*          lc_cash_ord TYPE zpay_type     VALUE 'C',  " Cash with Order
*          lc_firm_inv TYPE zpay_type     VALUE 'F',  " Firm Invoice
*          End   of DEL:ERP-6058:WROY:07-Feb-2018:ED2K910725
           lc_canc_ord TYPE zren_status   VALUE 'C', " Renewal Status: Cancelled
*          Begin of ADD:ERP-6293:WROY:25-JUN-2018:ED2K912338
           lc_not_nded TYPE zren_status   VALUE 'N', " Renewal Status: Not Needed - Profile Changed
*          End   of ADD:ERP-6293:WROY:25-JUN-2018:ED2K912338
           lc_lapse    TYPE zactivity_sub VALUE 'LP', " Lapse Subscription
           lc_create   TYPE t180-trtyp     VALUE 'H', " Create
*Begin of Del-Anirban-07.07.2017-ED2K907222-Defect 3096
*           lc_patment  TYPE t042z-zlsch   VALUE 'J',  " Payment Method
*End of Del-Anirban-07.07.2017-ED2K907222-Defect 3096
           lc_month    TYPE t5a4a-dlymo  VALUE '00',  " Month
           lc_year     TYPE t5a4a-dlyyr  VALUE '00',  " Year
           lc_lvel_doc TYPE vbfa-stufe   VALUE '00',  " Level of docflow
           lc_devid    TYPE zdevid VALUE 'E095',      " Development ID
           lc_srno     TYPE tvarv_numb VALUE '0002',  " ABAP: Current selection number
           lc_auart    TYPE rvari_vnam VALUE 'AUART', " ABAP: Name of Variant Variable
*Begin of Add-Anirban-07.07.2017-ED2K907222-Defect 3096
           lc_zlsch    TYPE rvari_vnam VALUE 'ZLSCH', "Payment method
*End of Add-Anirban-07.07.2017-ED2K907222-Defect 3096
*Begin of Add-Anirban-08.22.2017-ED2K908108-Defect 4002
           lc_pstyv    TYPE rvari_vnam VALUE 'PSTYV', "Item Category
*End of Add-Anirban-08.22.2017-ED2K908108-Defect 4002
*Begin of ADD:ERP-5132:WROY:14-Nov-2017:ED2K909462
           lc_mtart_j  TYPE rvari_vnam VALUE 'MTART_JRNL', "Material Type: Journal Media Product
*End   of ADD:ERP-5132:WROY:14-Nov-2017:ED2K909462
*Begin of ADD:ERP-4841:WROY:25-Oct-2017:ED2K909175
           lc_app_sls  TYPE kappl      VALUE 'V',    "Application: Sales
           lc_mdt_z001 TYPE kschd      VALUE 'Z001', "Material determination type: Z001
*End   of ADD:ERP-4841:WROY:25-Oct-2017:ED2K909175
           lc_sign     TYPE ddsign VALUE 'I',                 "Sign
           lc_option   TYPE ddoption VALUE 'EQ',              "Option
           lc_veda     TYPE char40 VALUE '(SAPLV45W)XVEDA[]', " Veda of type CHAR40
*        BOC by MODUTTA:JIRA# 6117:30-May-18:ED2K912187
           lc_rolng_yr TYPE zsubs_type VALUE 'R', " Rolling Year
           lc_clndr_yr TYPE zsubs_type VALUE 'C', " Calendar Year
           lc_sold_to  TYPE parvw VALUE 'AG',     " Partner Function
           lc_ship_to  TYPE parvw VALUE 'WE'.     " Partner Function
*        EOC by MODUTTA:JIRA# 6117:30-May-18:ED2K912187

*Begin of Add-Anirban-08.02.2017-ED2K907698-Defect 3055
CLEAR : i_rp_deter.
*End of Add-Anirban-08.02.2017-ED2K907698-Defect 3055

FIELD-SYMBOLS: <lfs_veda> TYPE any.

*& Trigger Only for COntract
IF vbak-vbtyp = lc_contract.
  SELECT  devid      " Development ID
          param1     " ABAP: Name of Variant Variable
          param2     " ABAP: Name of Variant Variable
          srno       " ABAP: Current selection number
          sign       " ABAP: ID: I/E (include/exclude values)
          opti       " ABAP: Selection option (EQ/BT/CP/...)
          low        " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE li_constant
    WHERE devid = lc_devid.
  IF sy-subrc EQ 0.
    SORT li_constant BY param1.
    LOOP AT li_constant INTO lst_constant.
      IF lst_constant-param1 = lc_auart.
        lst_auart_range-sign = lst_constant-sign.
        lst_auart_range-option = lst_constant-opti.
        lst_auart_range-low = lst_constant-low.
        APPEND lst_auart_range TO lir_auart_range.
        CLEAR: lst_auart_range,lst_constant.
      ENDIF. " IF lst_constant-param1 = lc_auart
*Begin of DEL:ERP-6058:WROY:07-Feb-2018:ED2K910725
**Begin of Add-Anirban-07.07.2017-ED2K907222-Defect 3096
*     IF lst_constant-param1 = lc_zlsch.
*       lst_zlsch_range-sign = lst_constant-sign.
*       lst_zlsch_range-option = lst_constant-opti.
*       lst_zlsch_range-low = lst_constant-low.
*       lst_zlsch_range-high = lst_constant-high.
*       APPEND lst_zlsch_range TO lir_zlsch_range.
*       CLEAR: lst_zlsch_range,lst_constant.
*     ENDIF.
**End of Add-Anirban-07.07.2017-ED2K907222-Defect 3096
*End   of DEL:ERP-6058:WROY:07-Feb-2018:ED2K910725

*Begin of Add-Anirban-08.22.2017-ED2K908108-Defect 4002
      IF lst_constant-param1 = lc_pstyv.
        lst_pstyv_range-sign = lst_constant-sign.
        lst_pstyv_range-option = lst_constant-opti.
        lst_pstyv_range-low = lst_constant-low.
        lst_pstyv_range-high = lst_constant-high.
        APPEND lst_pstyv_range TO lir_pstyv_range.
        CLEAR: lst_pstyv_range,lst_constant.
      ENDIF. " IF lst_constant-param1 = lc_pstyv
*End of Add-Anirban-08.22.2017-ED2K908108-Defect 4002

*Begin of ADD:ERP-5132:WROY:14-Nov-2017:ED2K909462
      IF lst_constant-param1 = lc_mtart_j.
        APPEND INITIAL LINE TO lr_mat_type_jrnl ASSIGNING FIELD-SYMBOL(<lst_mat_type>). " Range Table for Material Type
        <lst_mat_type>-sign   = lst_constant-sign.
        <lst_mat_type>-option = lst_constant-opti.
        <lst_mat_type>-low    = lst_constant-low.
        <lst_mat_type>-high   = lst_constant-high.
      ENDIF. " IF lst_constant-param1 = lc_mtart_j
*End   of ADD:ERP-5132:WROY:14-Nov-2017:ED2K909462
    ENDLOOP. " LOOP AT li_constant INTO lst_constant

  ENDIF. " IF sy-subrc EQ 0

  IF vbak-auart IN lir_auart_range. "If document type is ZSUB or ZREW
    ASSIGN (lc_veda) TO <lfs_veda>.
    IF <lfs_veda> IS ASSIGNED.
*        Get values of table VEDA
      li_veda[] = <lfs_veda>.
    ENDIF. " IF <lfs_veda> IS ASSIGNED
    CREATE DATA: lr_rp_deter,
                 lr_notif_p_det,
                 lr_renwl_p_det,
                 lr_renwl_plan.
    IF i_rp_deter IS INITIAL.
*     Begin of ADD:ERP-6058:WROY:07-Feb-2018:ED2K910725
*     Mapping between Payment Method to Payment Type
*     [Only 3 fields are there in the table and 2 are going to be used]
      SELECT *
        FROM zqtc_pay_key_typ " E095: Map Payment Method to Payment Type
        INTO TABLE li_pay_key_typ.
      IF sy-subrc EQ 0.
        SORT li_pay_key_typ BY zlsch.
      ENDIF. " IF sy-subrc EQ 0
*     End   of ADD:ERP-6058:WROY:07-Feb-2018:ED2K910725

      SELECT kdgrp " Customer group
      konda        " Price group (customer)
      pay_type     " Payment Type
*     BOC by MODUTTA:JIRA# 6117:30-May-18:ED2K912187
      sold_to_country
      ship_to_country
      license_grp
      sales_office
      subs_type
*    EOC by MODUTTA:JIRA# 6117:30-May-18:ED2K912187
      kdkg2 " Customer condition group 2
      mvgr5 " Material group 5
      bsark " Customer purchase order type
      vkorg " Sales Organization
      werks " Plant
*Begin of Add-Anirban-06.28.2017-ED2K907190-CR 585
      matnr " Matnr
*End of Add-Anirban-06.28.2017-ED2K907190-CR 585
*Begin of Add-Anirban-10.16.2017-ED2K909016-CR 650
      zzaction " Action
*End of Add-Anirban-10.16.2017-ED2K909016-CR 650
      renwl_prof " renewal profile
      FROM zqtc_rp_deter
      INTO TABLE i_rp_deter.
      IF sy-subrc = 0.
        li_renwl_det_t = i_rp_deter.
        SORT li_renwl_det_t BY renwl_prof.
        DELETE ADJACENT DUPLICATES FROM li_renwl_det_t COMPARING renwl_prof.

        SELECT renwl_prof " Renewal Profile
        quote_time        " Quote Timing
        notif_prof        " Notification Profile
        grace_start       " Grace Start Timing
        grace_period      " Grace Period
        auto_renew        " Auto Renew Timing
         lapse            " Lapse
*       Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912771
        consolidate " Consolidated Renewals
*       End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912771
          FROM zqtc_renwl_p_det " E095: Renewal Profile Details Table
          INTO TABLE li_renwl_p_det
          FOR ALL ENTRIES IN li_renwl_det_t
          WHERE
          renwl_prof = li_renwl_det_t-renwl_prof
*       Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912771
        ORDER BY PRIMARY KEY.
*       End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912771
        IF sy-subrc = 0.

          LOOP AT li_renwl_p_det REFERENCE INTO lr_renwl_p_det WHERE notif_prof IS NOT INITIAL .
            lr_notif_p_det->notif_prof = lr_renwl_p_det->notif_prof.
            APPEND lr_notif_p_det->* TO li_notif_p_det_t.
            CLEAR: lr_notif_p_det->*.
          ENDLOOP. " LOOP AT li_renwl_p_det REFERENCE INTO lr_renwl_p_det WHERE notif_prof IS NOT INITIAL

          DELETE ADJACENT DUPLICATES FROM li_notif_p_det_t COMPARING notif_prof.
          SELECT   notif_prof     " Notification Profile
                   notif_rem      " Notification/Reminder
                   rem_in_days    " Notification Reminder (in Days)
                   promo_code     " Promo code
            FROM zqtc_notif_p_det " E095: Notification Profile Details Table
            INTO TABLE li_notif_p_det
            FOR ALL ENTRIES IN li_notif_p_det_t
            WHERE
            notif_prof = li_notif_p_det_t-notif_prof.
          IF sy-subrc = 0.
*& DO nothing
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF sy-subrc = 0
        lr_rp_deter->vkorg = vbak-vkorg.

*        BOC by MODUTTA:JIRA# 6117:30-May-18:ED2K912187
        lr_rp_deter->sales_office = vbak-vkbur. "Sales office
        IF vbak-zzlicgrp IS NOT INITIAL. "License group
          lr_rp_deter->license_grp = abap_true.
        ENDIF. " IF vbak-zzlicgrp IS NOT INITIAL
*        EOC by MODUTTA:JIRA# 6117:30-May-18:ED2K912187

        li_xvbap[] = xvbap[].
        DELETE li_xvbap WHERE updkz NE updkz_new. " Only consider newly created lines
*       Begin of ADD:ERP-5265:WROY:20-Dec-2017:ED2K910013
*       Consider existinging entries (changed and unchanged)
        DATA(li_xvbap_ren) = xvbap[].
        DELETE li_xvbap_ren WHERE updkz NE updkz_update
                              AND updkz NE updkz_old.
        IF li_xvbap_ren[] IS NOT INITIAL.
*         Fetch Renewal Plan details
*         Begin of ADD:ERP-6293:WROY:25-JUN-2018:ED2K912338
*         Need all the fields to refer at a later stage to modify field values
          SELECT *
            FROM zqtc_renwl_plan " E095: Renewal Plan Table
            INTO TABLE li_ren_plan_ex
             FOR ALL ENTRIES IN li_xvbap_ren
           WHERE vbeln EQ li_xvbap_ren-vbeln
             AND posnr EQ li_xvbap_ren-posnr.
          IF sy-subrc EQ 0.
*           Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912771
            SORT li_ren_plan_ex BY vbeln posnr activity act_status ren_status.
*           End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912771
*           Begin of DEL:ERP-6343:WROY:26-JUL-2018:ED2K912771
*           SORT li_ren_plan_ex BY vbeln posnr activity.
*           End   of DEL:ERP-6343:WROY:26-JUL-2018:ED2K912771
          ENDIF. " IF sy-subrc EQ 0
*         Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912771
*         Do not consider the Line Item, if CQ (Create Quotation) activity is
*         already Completed and the assigned Renewal Profile is applicable for
*         Consolidation
          LOOP AT li_xvbap_ren ASSIGNING FIELD-SYMBOL(<lst_xvbap_ren>).
*           Check if CQ (Create Quotation) Activity is already completed
            READ TABLE li_ren_plan_ex ASSIGNING FIELD-SYMBOL(<lst_ren_plan_ex>)
                 WITH KEY vbeln      = <lst_xvbap_ren>-vbeln
                          posnr      = <lst_xvbap_ren>-posnr
                          activity   = lc_cr_quote
                          act_status = abap_true
                          ren_status = space
                 BINARY SEARCH.
            IF sy-subrc NE 0.
              APPEND <lst_xvbap_ren> TO li_xvbap.
            ELSE. " ELSE -> IF sy-subrc NE 0
*             Check if the Renewal Profile is applicable for Consolidation
              READ TABLE li_renwl_p_det ASSIGNING FIELD-SYMBOL(<lst_renwl_p_det>)
                   WITH KEY renwl_prof = <lst_ren_plan_ex>-renwl_prof
                   BINARY SEARCH.
              IF sy-subrc EQ 0 AND
                 <lst_renwl_p_det>-consolidate EQ abap_false.
                APPEND <lst_xvbap_ren> TO li_xvbap.
              ENDIF. " IF sy-subrc EQ 0 AND
            ENDIF. " IF sy-subrc NE 0
          ENDLOOP. " LOOP AT li_xvbap_ren ASSIGNING FIELD-SYMBOL(<lst_xvbap_ren>)
*         End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912771
*         Begin of DEL:ERP-6343:WROY:26-JUL-2018:ED2K912771
**        Redetermine Renewal Profiles for all Line Items
*         APPEND LINES OF li_xvbap_ren TO li_xvbap.
*         End   of DEL:ERP-6343:WROY:26-JUL-2018:ED2K912771
*         End   of ADD:ERP-6293:WROY:25-JUN-2018:ED2K912338
*         Begin of DEL:ERP-6293:WROY:25-JUN-2018:ED2K912338
*         SELECT vbeln           " Sales Document
*                posnr           " Sales Document Item
*           FROM zqtc_renwl_plan " E095: Renewal Plan Table
*           INTO TABLE li_ren_plan_ex
*            FOR ALL ENTRIES IN li_xvbap_ren
*          WHERE vbeln EQ li_xvbap_ren-vbeln
*            AND posnr EQ li_xvbap_ren-posnr.
*         IF sy-subrc EQ 0.
*           SORT li_ren_plan_ex BY vbeln posnr.
*
*           LOOP AT li_xvbap_ren ASSIGNING FIELD-SYMBOL(<lst_xvbap_ren>).
**            Check if the entry exists in Renewal Plan table
*             READ TABLE li_ren_plan_ex TRANSPORTING NO FIELDS
*                  WITH KEY vbeln = <lst_xvbap_ren>-vbeln " Sales Document
*                           posnr = <lst_xvbap_ren>-posnr " Sales Document Item
*                  BINARY SEARCH.
*             IF sy-subrc NE 0.
**              Consider entry if missing from Renewal Plan table
*               APPEND <lst_xvbap_ren> TO li_xvbap.
*             ENDIF. " IF sy-subrc NE 0
*           ENDLOOP. " LOOP AT li_xvbap_ren ASSIGNING FIELD-SYMBOL(<lst_xvbap_ren>)
*         ELSE. " ELSE -> IF sy-subrc EQ 0
**          Consider entries if missing from Renewal Plan table
*           APPEND LINES OF li_xvbap_ren TO li_xvbap.
*         ENDIF. " IF sy-subrc EQ 0
*         End   of DEL:ERP-6293:WROY:25-JUN-2018:ED2K912338
        ENDIF. " IF li_xvbap_ren[] IS NOT INITIAL
*       End   of ADD:ERP-5265:WROY:20-Dec-2017:ED2K910013
*Begin of Del-Anirban-08.22.2017-ED2K908108-Defect 4002
*        DELETE li_xvbap WHERE uepos IS NOT INITIAL.                         " Delete BOM Components
*End of Del-Anirban-08.22.2017-ED2K908108-Defect 4002
*Begin of Add-Anirban-08.22.2017-ED2K908108-Defect 4002
        DELETE li_xvbap WHERE uepos IS NOT INITIAL AND pstyv NOT IN lir_pstyv_range.
*End of Add-Anirban-08.22.2017-ED2K908108-Defect 4002

        IF li_xvbap IS NOT INITIAL.
*Begin of ADD:ERP-4841:WROY:25-Oct-2017:ED2K909175
*Begin of ADD:ERP-6495:WROY:05-Feb-2018:ED2K910701
          DATA(li_xvbap_hl) = xvbap[].
          DELETE li_xvbap_hl WHERE uepos IS NOT INITIAL.
*End   of ADD:ERP-6495:WROY:05-Feb-2018:ED2K910701
          SELECT kdgrp        " Customer group
                 matwa        " Material entered
                 smatn        " Substitute material
                 datbi        " Validity end date of the condition record
                 datab        " Validity start date of the condition record
            FROM kondd        " Material Substitution - Data Division
           INNER JOIN kotd503 " Cust.group/MatEntered
              ON kotd503~knumh EQ kondd~knumh
            INTO TABLE li_mat_subs
*Begin of DEL:ERP-6495:WROY:05-Feb-2018:ED2K910701
*            FOR ALL ENTRIES IN li_xvbap
*          WHERE smatn EQ li_xvbap-matnr
*End   of DEL:ERP-6495:WROY:05-Feb-2018:ED2K910701
*Begin of ADD:ERP-6495:WROY:05-Feb-2018:ED2K910701
             FOR ALL ENTRIES IN li_xvbap_hl
           WHERE smatn EQ li_xvbap_hl-matnr
*End   of ADD:ERP-6495:WROY:05-Feb-2018:ED2K910701
             AND kappl EQ lc_app_sls
             AND kschl EQ lc_mdt_z001.
          IF sy-subrc EQ 0.
            SORT li_mat_subs BY kdgrp smatn.
          ENDIF. " IF sy-subrc EQ 0
*End   of ADD:ERP-4841:WROY:25-Oct-2017:ED2K909175
*Begin of ADD:ERP-5132:WROY:14-Nov-2017:ED2K909462
*         Fetch General Material Data
          SELECT matnr " Material Number
                 mtart " Material Type
            FROM mara  " General Material Data
            INTO TABLE li_mat_det
             FOR ALL ENTRIES IN li_xvbap
           WHERE matnr EQ li_xvbap-matnr
             AND mtart IN lr_mat_type_jrnl.
          IF sy-subrc EQ 0.
            SORT li_mat_det BY matnr.
          ENDIF. " IF sy-subrc EQ 0
*End   of ADD:ERP-5132:WROY:14-Nov-2017:ED2K909462
        ENDIF. " IF li_xvbap IS NOT INITIAL

        LOOP AT li_xvbap INTO lst_xvbap_e095 .
*Begin of ADD:ERP-5132:WROY:14-Nov-2017:ED2K909462
*         Check for Valid Material (Journal Media Product)
          READ TABLE li_mat_det TRANSPORTING NO FIELDS
               WITH KEY matnr = lst_xvbap_e095-matnr
               BINARY SEARCH.
          IF sy-subrc NE 0.
            CONTINUE.
          ENDIF. " IF sy-subrc NE 0
*End   of ADD:ERP-5132:WROY:14-Nov-2017:ED2K909462
*Begin of ADD:ERP-5265:WROY:20-Dec-2017:ED2K910013
*         Don't consider the line, if it is incomplete
          READ TABLE xvbuv TRANSPORTING NO FIELDS
               WITH KEY vbeln = lst_xvbap_e095-vbeln
                        posnr = lst_xvbap_e095-posnr
               BINARY SEARCH.
          IF sy-subrc EQ 0.
            CONTINUE.
          ENDIF. " IF sy-subrc EQ 0
*End   of ADD:ERP-5265:WROY:20-Dec-2017:ED2K910013

*        BOC by MODUTTA:JIRA# 6117:30-May-18:ED2K912187
          READ TABLE xvbpa ASSIGNING FIELD-SYMBOL(<lst_xvbpa_e095>) WITH KEY
                                                            vbeln = lst_xvbap_e095-vbeln
                                                            posnr = lst_xvbap_e095-posnr
                                                            parvw = lc_ship_to.
          IF sy-subrc NE 0.
            READ TABLE xvbpa ASSIGNING <lst_xvbpa_e095> WITH KEY
                                                        vbeln = lst_xvbap_e095-vbeln
                                                        posnr = posnr_low "Header
                                                        parvw = lc_ship_to.
          ENDIF. " IF sy-subrc NE 0
          IF sy-subrc EQ 0.
            lr_rp_deter->ship_to_country = <lst_xvbpa_e095>-land1. "Ship To Country
          ENDIF. " IF sy-subrc EQ 0

          READ TABLE xvbpa ASSIGNING <lst_xvbpa_e095> WITH KEY
                                                      vbeln = lst_xvbap_e095-vbeln
                                                      posnr = posnr_low "Header
                                                      parvw = lc_sold_to.
          IF sy-subrc EQ 0.
            lr_rp_deter->sold_to_country = <lst_xvbpa_e095>-land1.
          ENDIF. " IF sy-subrc EQ 0
*        EOC by MODUTTA:JIRA# 6117:30-May-18:ED2K912187

          READ TABLE xvbkd ASSIGNING FIELD-SYMBOL(<lst_xvbkd_e095>) WITH KEY
                                                                    posnr = lst_xvbap_e095-posnr. "posnr_low.
          IF sy-subrc = 0.
            lr_rp_deter->kdgrp = <lst_xvbkd_e095>-kdgrp.
            lr_rp_deter->konda = <lst_xvbkd_e095>-konda.
            lr_rp_deter->kdkg2 = <lst_xvbkd_e095>-kdkg2.
            READ TABLE li_pay_key_typ ASSIGNING FIELD-SYMBOL(<lst_pay_key_typ>)
                WITH KEY zlsch = <lst_xvbkd_e095>-zlsch
                BINARY SEARCH.
            IF sy-subrc NE 0.
              READ TABLE li_pay_key_typ ASSIGNING <lst_pay_key_typ>
                   WITH KEY zlsch = space
                   BINARY SEARCH.
            ENDIF. " IF sy-subrc NE 0
            IF sy-subrc EQ 0.
              lr_rp_deter->pay_type = <lst_pay_key_typ>-zpay_type.
            ENDIF. " IF sy-subrc EQ 0
*& Purchase Order type
            IF <lst_xvbkd_e095>-bsark IS NOT INITIAL.
              lr_rp_deter->bsark = <lst_xvbkd_e095>-bsark.
            ELSE. " ELSE -> IF <lst_xvbkd_e095>-bsark IS NOT INITIAL
              lr_rp_deter->bsark = vbak-bsark.

            ENDIF. " IF <lst_xvbkd_e095>-bsark IS NOT INITIAL
          ELSE. " ELSE -> IF sy-subrc = 0
*& No search criteria used as there would very few entry, would not hamper performance
            READ TABLE xvbkd ASSIGNING <lst_xvbkd_e095> WITH KEY  posnr = posnr_low.
            IF sy-subrc = 0.
              lr_rp_deter->kdgrp = <lst_xvbkd_e095>-kdgrp. "" Customer Group
              lr_rp_deter->konda = <lst_xvbkd_e095>-konda. "Price group (customer)
              lr_rp_deter->kdkg2 = <lst_xvbkd_e095>-kdkg2. " Customer condition group 2

              READ TABLE li_pay_key_typ ASSIGNING <lst_pay_key_typ>
                     WITH KEY zlsch = <lst_xvbkd_e095>-zlsch
                     BINARY SEARCH.
              IF sy-subrc NE 0.
                READ TABLE li_pay_key_typ ASSIGNING <lst_pay_key_typ>
                     WITH KEY zlsch = space
                     BINARY SEARCH.
              ENDIF. " IF sy-subrc NE 0
              IF sy-subrc EQ 0.
                lr_rp_deter->pay_type = <lst_pay_key_typ>-zpay_type.
              ENDIF. " IF sy-subrc EQ 0
*End   of ADD:ERP-6058:WROY:07-Feb-2018:ED2K910725
*& Purchase Order type
              IF <lst_xvbkd_e095>-bsark IS NOT INITIAL.
                lr_rp_deter->bsark = <lst_xvbkd_e095>-bsark.
              ELSE. " ELSE -> IF <lst_xvbkd_e095>-bsark IS NOT INITIAL
                lr_rp_deter->bsark = vbak-bsark.

              ENDIF. " IF <lst_xvbkd_e095>-bsark IS NOT INITIAL
            ENDIF. " IF sy-subrc = 0
          ENDIF. " IF sy-subrc = 0
*Begin of Add-Anirban-06.28.2017-ED2K907190-CR 585
          lr_rp_deter->matnr = lst_xvbap_e095-matnr.
*End of Add-Anirban-06.28.2017-ED2K907190-CR 585
          lr_rp_deter->werks = lst_xvbap_e095-werks. " Plant
          lr_rp_deter->mvgr5 = lst_xvbap_e095-mvgr5. " Material Group 5

*        BOC by MODUTTA:JIRA# 6117:30-May-18:ED2K912187
*         lr_rp_deter->subs_type = lst_xvbap_e095-zzsubtyp. "Subscription Type
          CASE lst_xvbap_e095-zzsubtyp. "Subscription Type
            WHEN space.
              lr_rp_deter->subs_type = lc_rolng_yr. "Rolling Year
            WHEN OTHERS.
              lr_rp_deter->subs_type = lc_clndr_yr. "Calendar Year
          ENDCASE.
*        EOC by MODUTTA:JIRA# 6117:30-May-18:ED2K912187

*Begin of ADD:ERP-4841:WROY:25-Oct-2017:ED2K909175
          IF lst_xvbap_e095-pstyv IN lir_pstyv_range AND
             lst_xvbap_e095-uepos IS NOT INITIAL.
*Begin of DEL:ERP-6495:WROY:05-Feb-2018:ED2K910701
*           READ TABLE li_xvbap ASSIGNING FIELD-SYMBOL(<lst_xvbap_hl>)
*End   of DEL:ERP-6495:WROY:05-Feb-2018:ED2K910701
*Begin of ADD:ERP-6495:WROY:05-Feb-2018:ED2K910701
            READ TABLE li_xvbap_hl ASSIGNING FIELD-SYMBOL(<lst_xvbap_hl>)
*End   of ADD:ERP-6495:WROY:05-Feb-2018:ED2K910701
                 WITH KEY posnr = lst_xvbap_e095-uepos
                 BINARY SEARCH.
            IF sy-subrc EQ 0.
              READ TABLE li_mat_subs TRANSPORTING NO FIELDS
                   WITH KEY kdgrp = lr_rp_deter->kdgrp
                            smatn = <lst_xvbap_hl>-matnr
                   BINARY SEARCH.
              IF sy-subrc EQ 0.
                DATA(lv_tabix_mat_subs) = sy-tabix.
*               Identify the Contract Start Date (VEDA-VBEGDAT)
                READ TABLE li_veda ASSIGNING FIELD-SYMBOL(<lst_veda_mat_subs>)
                     WITH KEY vposn = lst_xvbap_e095-uepos. " Specific Line Item Number
                IF sy-subrc NE 0.
                  READ TABLE li_veda ASSIGNING <lst_veda_mat_subs>
                       WITH KEY vposn = posnr_low. " Header Line Item Number (000000)
                ENDIF. " IF sy-subrc NE 0

                CLEAR: lv_mat_subs,
                       lv_ren_start_dt.
                LOOP AT li_mat_subs ASSIGNING FIELD-SYMBOL(<lst_mat_subs>) FROM lv_tabix_mat_subs.
                  IF <lst_mat_subs>-kdgrp NE lr_rp_deter->kdgrp OR
                     <lst_mat_subs>-smatn NE <lst_xvbap_hl>-matnr.
                    EXIT.
                  ENDIF. " IF <lst_mat_subs>-kdgrp NE lr_rp_deter->kdgrp OR
                  lv_ren_start_dt = <lst_veda_mat_subs>-venddat + 1. " Contract Start Date of the Renewal
*                 Check if Valid Susbstitution Exists on Contract Start Date of the Renewal
                  IF <lst_mat_subs>-datbi GE lv_ren_start_dt AND " Validity end date of the condition record
                     <lst_mat_subs>-datab LE lv_ren_start_dt.    " Validity start date of the condition record
                    lv_mat_subs = abap_true.
                    EXIT.
                  ENDIF. " IF <lst_mat_subs>-datbi GE lv_ren_start_dt AND
                ENDLOOP. " LOOP AT li_mat_subs ASSIGNING FIELD-SYMBOL(<lst_mat_subs>) FROM lv_tabix_mat_subs
*               No need to consider Opt-In Item, if Substitution is Valid
                IF lv_mat_subs IS NOT INITIAL.
                  CLEAR lr_renwl_plan->*.
                  CONTINUE.
                ENDIF. " IF lv_mat_subs IS NOT INITIAL
*             Begin of ADD:ERP-7707:WROY:23-AUG-2018:ED2K913197
              ELSE.
                CLEAR lr_renwl_plan->*.
                CONTINUE.
*             End   of ADD:ERP-7707:WROY:23-AUG-2018:ED2K913197
              ENDIF. " IF sy-subrc EQ 0
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF lst_xvbap_e095-pstyv IN lir_pstyv_range AND
*End   of ADD:ERP-4841:WROY:25-Oct-2017:ED2K909175
          CREATE DATA lr_rp_deter_t.
*Begin of Add-Anirban-10.16.2017-ED2K909016-CR 650
          CONSTANTS: lc_hdr_vposn TYPE posnr_va VALUE '00000',    " Sales Document Item
                     lc_action    TYPE rvari_vnam VALUE 'ACTION'. " ABAP: Name of Variant Variable
          READ TABLE li_veda INTO DATA(lst_veda1) WITH KEY vposn   = lc_hdr_vposn.
          IF sy-subrc = 0.
            IF NOT lst_veda1-vaktsch IS INITIAL.
*Begin of DEL:ERP-6058:WROY:07-Feb-2018:ED2K910725
*             READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY zzaction = lst_veda1-vaktsch.
*End   of DEL:ERP-6058:WROY:07-Feb-2018:ED2K910725
*Begin of ADD:ERP-6058:WROY:07-Feb-2018:ED2K910725

*        Commented by MODUTTA:JIRA# 6117:30-May-18:ED2K912187
*              READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY zzaction = lst_veda1-vaktsch
*                                                                          pay_type = lr_rp_deter->pay_type. " Payment type
*        End of Comment by MODUTTA:JIRA# 6117:30-May-18:ED2K912187
*        BOC by MODUTTA:JIRA# 6117:30-May-18:ED2K912187
              READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY zzaction = lst_veda1-vaktsch
                                                                          pay_type = lr_rp_deter->pay_type " Payment type
                                                                          sold_to_country = lr_rp_deter->sold_to_country
                                                                          ship_to_country = lr_rp_deter->ship_to_country.
              IF sy-subrc NE 0.
                READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY zzaction = lst_veda1-vaktsch
                                                                            pay_type = lr_rp_deter->pay_type " Payment type
                                                                            sold_to_country = lr_rp_deter->sold_to_country
                                                                            ship_to_country = space.
              ENDIF. " IF sy-subrc NE 0
              IF sy-subrc NE 0.
                READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY zzaction = lst_veda1-vaktsch
                                                                            pay_type = lr_rp_deter->pay_type " Payment type
                                                                            sold_to_country = space
                                                                            ship_to_country = lr_rp_deter->ship_to_country.
              ENDIF. " IF sy-subrc NE 0
              IF sy-subrc NE 0.
                READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY zzaction = lst_veda1-vaktsch
                                                                            pay_type = lr_rp_deter->pay_type " Payment type
                                                                            sold_to_country = space
                                                                            ship_to_country = space.
              ENDIF. " IF sy-subrc NE 0
              IF sy-subrc NE 0.
                READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY zzaction = lst_veda1-vaktsch
                                                                            pay_type = space " Payment type
                                                                            sold_to_country = lr_rp_deter->sold_to_country
                                                                            ship_to_country = lr_rp_deter->ship_to_country.
              ENDIF. " IF sy-subrc NE 0
              IF sy-subrc NE 0.
                READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY zzaction = lst_veda1-vaktsch
                                                                            pay_type = space
                                                                            sold_to_country = lr_rp_deter->sold_to_country
                                                                            ship_to_country = space.
              ENDIF. " IF sy-subrc NE 0
              IF sy-subrc NE 0.
                READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY zzaction = lst_veda1-vaktsch
                                                                            pay_type = space " Payment type
                                                                            sold_to_country = space
                                                                            ship_to_country = lr_rp_deter->ship_to_country.
              ENDIF. " IF sy-subrc NE 0
              IF sy-subrc NE 0.
                READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY zzaction = lst_veda1-vaktsch
                                                                            pay_type = space " Payment type
                                                                            sold_to_country = space
                                                                            ship_to_country = space.
              ENDIF. " IF sy-subrc NE 0
*        EOC by MODUTTA:JIRA# 6117:30-May-18:ED2K912187
*End   of ADD:ERP-6058:WROY:07-Feb-2018:ED2K910725
              IF sy-subrc = 0.
                lv_scenario = 1.
              ENDIF. " IF sy-subrc = 0
            ENDIF. " IF NOT lst_veda1-vaktsch IS INITIAL
            CLEAR : lst_veda1, lst_constant.
          ENDIF. " IF sy-subrc = 0

          IF lv_scenario NE 1.
            CLEAR lr_rp_deter_t->*.
            IF lr_rp_deter->bsark IS NOT INITIAL.
*             BOC by MODUTTA:JIRA# 6117:30-May-18:ED2K912187
              READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY bsark = lr_rp_deter->bsark " PO type
                                                                          matnr = lr_rp_deter->matnr " Material no
                                                                          subs_type = lr_rp_deter->subs_type.
              IF sy-subrc NE 0.
                READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY bsark = lr_rp_deter->bsark " PO type
                                                                            matnr = lr_rp_deter->matnr " Material no
                                                                            subs_type = space.
              ENDIF. " IF sy-subrc NE 0
              IF sy-subrc NE 0.
                READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY bsark = lr_rp_deter->bsark " PO type
                                                                            matnr = space
                                                                            subs_type = lr_rp_deter->subs_type.
              ENDIF. " IF sy-subrc NE 0
              IF sy-subrc NE 0.
                READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY bsark = lr_rp_deter->bsark " PO type
                                                                            matnr = space
                                                                            subs_type = space.
                IF sy-subrc <> 0.
                  lv_subrc = 1.
                ELSE. " ELSE -> IF sy-subrc <> 0
                  lv_scenario = 2.
                ENDIF. " IF sy-subrc <> 0
              ENDIF. " IF sy-subrc NE 0
            ELSE. " ELSE -> IF lr_rp_deter->bsark IS NOT INITIAL
              lv_subrc = 1.
            ENDIF. " IF lr_rp_deter->bsark IS NOT INITIAL

            IF lv_subrc = 1.
              READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY kdgrp = space
                                                                          konda = space
                                                                          pay_type = space
                                                                          sold_to_country = space
                                                                          ship_to_country = space
                                                                          license_grp = lr_rp_deter->license_grp
                                                                          sales_office = lr_rp_deter->sales_office
                                                                          subs_type = space
                                                                          kdkg2 = space
                                                                          mvgr5 = space
                                                                          bsark = space
                                                                          vkorg = space
                                                                          werks = space
                                                                          matnr = space
                                                                          zzaction = space.

              IF sy-subrc NE 0.
                READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY kdgrp = space
                                                                          konda = space
                                                                          pay_type = space
                                                                          sold_to_country = space
                                                                          ship_to_country = space
                                                                          license_grp = lr_rp_deter->license_grp
                                                                          sales_office = space
                                                                          subs_type = space
                                                                          kdkg2 = space
                                                                          mvgr5 = space
                                                                          bsark = space
                                                                          vkorg = space
                                                                          werks = space
                                                                          matnr = space
                                                                          zzaction = space.
              ENDIF. " IF sy-subrc NE 0
              IF sy-subrc EQ 0.
                lv_scenario = 3.
              ENDIF. " IF sy-subrc EQ 0

*           EOC by MODUTTA:JIRA# 6117:30-May-18:ED2K912187
              IF lv_scenario NE 3.
                READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY vkorg = lr_rp_deter->vkorg " Sales Org
                                                                            werks = lr_rp_deter->werks " Plant
                                                                            matnr = lr_rp_deter->matnr " Material no
                                                                            subs_type = lr_rp_deter->subs_type.
                IF sy-subrc <> 0.
                  READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY vkorg = lr_rp_deter->vkorg    " Sales Org
                                                                                 werks = lr_rp_deter->werks " Plant
                                                                                 matnr = lr_rp_deter->matnr " Material no
                                                                                 subs_type = space.
                ENDIF. " IF sy-subrc <> 0
                IF sy-subrc NE 0.
                  READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY vkorg = lr_rp_deter->vkorg " Sales Org
                                                                              werks = lr_rp_deter->werks " Plant
                                                                              matnr = space
                                                                              subs_type = lr_rp_deter->subs_type.
                ENDIF. " IF sy-subrc NE 0
                IF sy-subrc NE 0.
                  READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY vkorg = lr_rp_deter->vkorg               " Sales Org
                                                                                            werks = lr_rp_deter->werks " Plant
                                                                                            matnr = space
                                                                                            subs_type = space.
                ENDIF. " IF sy-subrc NE 0
                IF sy-subrc EQ 0.
                  lv_scenario = 4.
                ENDIF. " IF sy-subrc EQ 0

                IF lv_scenario NE 4.
                  CLEAR lr_rp_deter_t->*.
                  READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY kdgrp = lr_rp_deter->kdgrp       " Customer Group
                                                                              konda = lr_rp_deter->konda       "Price group (customer)
                                                                              kdkg2 = lr_rp_deter->kdkg2       " Customer condition group 2
                                                                              pay_type = lr_rp_deter->pay_type " Payment type
                                                                              mvgr5 = lr_rp_deter->mvgr5       " Material Group 5
                                                                              matnr = lr_rp_deter->matnr       " Material no
                                                                              subs_type = lr_rp_deter->subs_type.
                  IF sy-subrc NE 0.
                    READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY kdgrp = lr_rp_deter->kdgrp      " Customer Group
                                                                               konda = lr_rp_deter->konda       "Price group (customer)
                                                                               kdkg2 = lr_rp_deter->kdkg2       " Customer condition group 2
                                                                               pay_type = lr_rp_deter->pay_type " Payment type
                                                                               mvgr5 = lr_rp_deter->mvgr5       " Material Group 5
                                                                               matnr = lr_rp_deter->matnr       " Material no
                                                                               subs_type = space.
                  ENDIF. " IF sy-subrc NE 0
                  IF sy-subrc NE 0.
                    READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY kdgrp = lr_rp_deter->kdgrp       " Customer Group
                                                                                konda = lr_rp_deter->konda       "Price group (customer)
                                                                                kdkg2 = lr_rp_deter->kdkg2       " Customer condition group 2
                                                                                pay_type = lr_rp_deter->pay_type " Payment type
                                                                                mvgr5 = lr_rp_deter->mvgr5       " Material Group 5
                                                                                matnr = space
                                                                                subs_type = lr_rp_deter->subs_type.
                  ENDIF. " IF sy-subrc NE 0
                  IF sy-subrc NE 0.
                    READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY kdgrp = lr_rp_deter->kdgrp       " Customer Group
                                                                                konda = lr_rp_deter->konda       "Price group (customer)
                                                                                kdkg2 = lr_rp_deter->kdkg2       " Customer condition group 2
                                                                                pay_type = lr_rp_deter->pay_type " Payment type
                                                                                mvgr5 = lr_rp_deter->mvgr5       " Material Group 5
                                                                                matnr = space
                                                                                subs_type = space.
                  ENDIF. " IF sy-subrc NE 0
                  IF sy-subrc NE 0.
                    READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY kdgrp = lr_rp_deter->kdgrp         " Customer Group
                                                                                  konda = lr_rp_deter->konda       " Price group (customer)
                                                                                  kdkg2 = space                    " Customer condition group 2
                                                                                  pay_type = lr_rp_deter->pay_type " Payment type
                                                                                  mvgr5 = lr_rp_deter->mvgr5       " Material Group 5
                                                                                  matnr = lr_rp_deter->matnr       " Material no
                                                                                  subs_type = lr_rp_deter->subs_type.
                  ENDIF. " IF sy-subrc NE 0
                  IF sy-subrc NE 0.
                    READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY kdgrp = lr_rp_deter->kdgrp       " Customer Group
                                                                                konda = lr_rp_deter->konda       " Price group (customer)
                                                                                kdkg2 = space                    " Customer condition group 2
                                                                                pay_type = lr_rp_deter->pay_type " Payment type
                                                                                mvgr5 = lr_rp_deter->mvgr5       " Material Group 5
                                                                                matnr = lr_rp_deter->matnr       " Material no
                                                                                subs_type = space.
                  ENDIF. " IF sy-subrc NE 0
                  IF sy-subrc NE 0.
                    READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY kdgrp = lr_rp_deter->kdgrp       " Customer Group
                                                                                konda = lr_rp_deter->konda       " Price group (customer)
                                                                                kdkg2 = space                    " Customer condition group 2
                                                                                pay_type = lr_rp_deter->pay_type " Payment type
                                                                                mvgr5 = lr_rp_deter->mvgr5       " Material Group 5
                                                                                matnr = space
                                                                                subs_type = lr_rp_deter->subs_type.
                  ENDIF. " IF sy-subrc NE 0
                  IF sy-subrc NE 0.
                    READ TABLE i_rp_deter REFERENCE INTO lr_rp_deter_t WITH KEY kdgrp = lr_rp_deter->kdgrp            " Customer Group
                                                                                     konda = lr_rp_deter->konda       " Price group (customer)
                                                                                     kdkg2 = space                    " Customer condition group 2
                                                                                     pay_type = lr_rp_deter->pay_type " Payment type
                                                                                     mvgr5 = lr_rp_deter->mvgr5       " Material Group 5
                                                                                     matnr = space
                                                                                     subs_type = space.
                  ENDIF. " IF sy-subrc NE 0
                ENDIF. " IF lv_scenario NE 4
              ENDIF. " IF lv_scenario NE 3
            ENDIF. " IF lv_subrc = 1
          ENDIF. " IF lv_scenario NE 1

          IF lr_rp_deter_t->renwl_prof IS NOT INITIAL.
*& for    Account Managed Scenario      no notification reminder required
*           Begin of DEL:ERP-5703:WROY:20-Dec-2017:ED2K910013
*           IF lv_scenario <> 2.
*           End   of DEL:ERP-5703:WROY:20-Dec-2017:ED2K910013
            CLEAR lr_renwl_plan->*.
*& Populate Notification Reminder Activity
            LOOP AT li_notif_p_det REFERENCE INTO lr_notif_p_det .
              lr_renwl_plan->vbeln = vbak-vbeln. " Order Number
              lr_renwl_plan->posnr = lst_xvbap_e095-posnr. " item
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
              lr_renwl_plan->matnr = lst_xvbap_e095-matnr. " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
              lr_renwl_plan->activity = lr_notif_p_det->notif_rem. " Notification Reminder
              READ TABLE li_renwl_p_det ASSIGNING <lst_renwl_p_det>
                 WITH TABLE KEY renwl_prof COMPONENTS renwl_prof = lr_rp_deter_t->renwl_prof
                                                      notif_prof = lr_notif_p_det->notif_prof
                         .
              IF sy-subrc = 0.
                lr_renwl_plan->renwl_prof = <lst_renwl_p_det>-renwl_prof. " Renewal  Profile
                READ TABLE li_veda INTO DATA(lst_veda) WITH KEY vbeln = vbak-vbeln
                                                                vposn = lst_xvbap_e095-posnr.

                IF sy-subrc EQ 0.
                  lr_renwl_plan->eadat  = lst_veda-venddat + lr_notif_p_det->rem_in_days.
                ELSE. " ELSE -> IF sy-subrc EQ 0
                  READ TABLE li_veda INTO lst_veda WITH KEY vbeln = vbak-vbeln
                                                                  vposn = posnr_low.
                  IF sy-subrc = 0.
                    lr_renwl_plan->eadat  = lst_veda-venddat + lr_notif_p_det->rem_in_days.

                  ENDIF. " IF sy-subrc = 0
                ENDIF. " IF sy-subrc EQ 0
                lr_renwl_plan->aedat = sy-datum.
                lr_renwl_plan->aenam = sy-uname.
                lr_renwl_plan->aezet = sy-uzeit.
                lr_renwl_plan->promo_code = lr_notif_p_det->promo_code.
                APPEND lr_renwl_plan->* TO li_renwl_plan.
                CLEAR lr_renwl_plan->*.

              ENDIF. " IF sy-subrc = 0
            ENDLOOP. " LOOP AT li_notif_p_det REFERENCE INTO lr_notif_p_det
*           Begin of DEL:ERP-5703:WROY:20-Dec-2017:ED2K910013
*           ENDIF.
*           End   of DEL:ERP-5703:WROY:20-Dec-2017:ED2K910013
            LOOP AT li_renwl_p_det REFERENCE INTO lr_renwl_p_det USING KEY renwl_pro WHERE renwl_prof = lr_rp_deter_t->renwl_prof .
              CLEAR lr_renwl_plan->*.
*& Populate Quotation Create Activity
              IF lr_renwl_p_det->quote_time IS NOT INITIAL.
                lr_renwl_plan->renwl_prof =  lr_renwl_p_det->renwl_prof. " renewal Profile
                lr_renwl_plan->vbeln = vbak-vbeln. " Sales Order
                lr_renwl_plan->posnr = lst_xvbap_e095-posnr. " Item
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
                lr_renwl_plan->matnr = lst_xvbap_e095-matnr. " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122

                lr_renwl_plan->activity = lc_cr_quote. " Quotation Create
                CLEAR lst_veda.
                READ TABLE li_veda INTO lst_veda WITH KEY  vbeln = vbak-vbeln
                                                           vposn = lst_xvbap_e095-posnr.
                IF sy-subrc EQ 0.
                  lr_renwl_plan->eadat = lst_veda-venddat + lr_renwl_p_det->quote_time. " quotation Create Time
                ELSE. " ELSE -> IF sy-subrc EQ 0
                  READ TABLE li_veda INTO lst_veda WITH KEY vbeln = vbak-vbeln
                                                             vposn = posnr_low.
                  IF sy-subrc = 0.
                    lr_renwl_plan->eadat  = lst_veda-venddat + lr_renwl_p_det->quote_time.

                  ENDIF. " IF sy-subrc = 0

                ENDIF. " IF sy-subrc EQ 0
                lr_renwl_plan->aedat = sy-datum. " System Date
                lr_renwl_plan->aezet = sy-uzeit. " system Time
                lr_renwl_plan->aenam = sy-uname. " User Name
                APPEND lr_renwl_plan->* TO li_renwl_plan.
                CLEAR lr_renwl_plan->*.
              ENDIF. " IF lr_renwl_p_det->quote_time IS NOT INITIAL
*& Populate Grace Subscription Activity Details
              IF lr_renwl_p_det->grace_period IS NOT INITIAL .
                lr_renwl_plan->renwl_prof =  lr_renwl_p_det->renwl_prof.
                lr_renwl_plan->vbeln = vbak-vbeln.
                lr_renwl_plan->posnr = lst_xvbap_e095-posnr.
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
                lr_renwl_plan->matnr = lst_xvbap_e095-matnr. " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122

                lr_renwl_plan->activity = lc_gr_subs.
*& If grace start days given then add the days to subscription expiry date
                IF lr_renwl_p_det->grace_start IS NOT INITIAL.

                  CLEAR: lst_veda, lv_days.
                  "ADD lr_renwl_p_det->grace_start TO lv_days.
                  READ TABLE li_veda INTO lst_veda WITH KEY vbeln = vbak-vbeln
                                                            vposn = lst_xvbap_e095-posnr.
                  IF sy-subrc EQ 0.
                    lr_renwl_plan->eadat = lst_veda-venddat + lr_renwl_p_det->grace_start.
                  ELSE. " ELSE -> IF sy-subrc EQ 0
                    READ TABLE li_veda INTO lst_veda WITH KEY vbeln = vbak-vbeln
                                                              vposn = posnr_low.

                    IF sy-subrc = 0.
                      lr_renwl_plan->eadat = lst_veda-venddat + lr_renwl_p_det->grace_start.
                    ENDIF. " IF sy-subrc = 0
                  ENDIF. " IF sy-subrc EQ 0
*& ADD Days to a date
*                CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*                  EXPORTING
*                    date      = veda-venddat
*                    days      = lv_days
*                    months    = lc_month
*                    years     = lc_year
*                  IMPORTING
*                    calc_date = lr_renwl_plan->eadat.
                ELSE. " ELSE -> IF lr_renwl_p_det->grace_start IS NOT INITIAL
*& Otherwise it would be the very next day
                  CLEAR:lst_veda, lv_days.
                  READ TABLE li_veda INTO lst_veda WITH KEY vbeln = vbak-vbeln
                                                            vposn = lst_xvbap_e095-posnr.
                  IF sy-subrc EQ 0.
                    DATA(lv_date) = lst_veda-venddat.
                  ELSE. " ELSE -> IF sy-subrc EQ 0
                    READ TABLE li_veda INTO lst_veda WITH KEY vbeln = vbak-vbeln
                                                               vposn = posnr_low.
                    IF sy-subrc = 0.
                      lv_date  = lst_veda-venddat .

                    ENDIF. " IF sy-subrc = 0
                  ENDIF. " IF sy-subrc EQ 0
                  ADD 1 TO lv_days.
                  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
                    EXPORTING
                      date      = lv_date "xveda-venddat
                      days      = lv_days
                      months    = lc_month
                      years     = lc_year
                    IMPORTING
                      calc_date = lr_renwl_plan->eadat.
*& The FM has no exception , hence sy-subrc not used
                ENDIF. " IF lr_renwl_p_det->grace_start IS NOT INITIAL

                lr_renwl_plan->aedat = sy-datum. " System Date
                lr_renwl_plan->aezet = sy-uzeit. " System Time
                lr_renwl_plan->aenam = sy-uname. " User Name
                APPEND lr_renwl_plan->* TO li_renwl_plan.
                CLEAR lr_renwl_plan->*.
              ENDIF. " IF lr_renwl_p_det->grace_period IS NOT INITIAL

              IF lv_scenario = 1 . " VCH Scenario
                lr_renwl_plan->renwl_prof =  lr_renwl_p_det->renwl_prof. " Renewal Profile
                lr_renwl_plan->posnr = lst_xvbap_e095-posnr. " Item
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
                lr_renwl_plan->matnr = lst_xvbap_e095-matnr. " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122

                lr_renwl_plan->vbeln = vbak-vbeln. " Subscription Number
                lr_renwl_plan->activity = lc_cr_subs. " Create Subscription
*&If Autorenewal is zero, then  it would be the very next day
                IF lr_renwl_p_det->auto_renew EQ 0.

                  CLEAR: lv_days,lst_veda,lv_date.
                  READ TABLE li_veda INTO lst_veda WITH KEY vbeln = vbak-vbeln
                                                            vposn = lst_xvbap_e095-posnr.
                  IF sy-subrc EQ 0.
                    lv_date = lst_veda-venddat.
                  ELSE. " ELSE -> IF sy-subrc EQ 0
                    READ TABLE li_veda INTO lst_veda WITH KEY vbeln = vbak-vbeln
                                                               vposn = posnr_low.
                    IF sy-subrc = 0.
                      lv_date  = lst_veda-venddat .

                    ENDIF. " IF sy-subrc = 0
                  ENDIF. " IF sy-subrc EQ 0

                  ADD 1 TO lv_days.
                  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
                    EXPORTING
                      date      = lv_date "xveda-venddat
                      days      = lv_days
                      months    = lc_month
                      years     = lc_year
                    IMPORTING
                      calc_date = lr_renwl_plan->eadat.
*& The FM has no exception , hence sy-subrc not used
                  lr_renwl_plan->eadat = lv_date + 1. "xveda-venddat + 1.

*                ELSEIF  lr_renwl_p_det->auto_renew GT 0 . "Commented by MODUTTA for JIRA Defect# 1865
                ELSE. " ELSE -> IF lr_renwl_p_det->auto_renew EQ 0

                  CLEAR: lv_days,lst_veda,lv_date.
                  READ TABLE li_veda INTO lst_veda WITH KEY vbeln = vbak-vbeln
                                                            vposn = lst_xvbap_e095-posnr.
                  IF sy-subrc EQ 0.
                    lv_date = lst_veda-venddat.
                  ELSE. " ELSE -> IF sy-subrc EQ 0
                    READ TABLE li_veda INTO lst_veda WITH KEY vbeln = vbak-vbeln
                                                               vposn = posnr_low.
                    IF sy-subrc = 0.
                      lv_date  = lst_veda-venddat .

                    ENDIF. " IF sy-subrc = 0
                  ENDIF. " IF sy-subrc EQ 0
*                 Begin of ADD:INC0202834:WROY:12-JUL-2018:ED1K907955
                  lr_renwl_plan->eadat = lv_date + lr_renwl_p_det->auto_renew.
*                 End   of ADD:INC0202834:WROY:12-JUL-2018:ED1K907955
*                 Begin of DEL:INC0202834:WROY:12-JUL-2018:ED1K907955
*                 ADD lr_renwl_p_det->auto_renew TO lv_days.
**& ADD Days to a date
*                 CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*                   EXPORTING
*                     date      = lv_date "xveda-venddat
*                     days      = lv_days
*                     months    = lc_month
*                     years     = lc_year
*                   IMPORTING
*                     calc_date = lr_renwl_plan->eadat.
**& The FM has no exception , hence sy-subrc not used
*                 End   of DEL:INC0202834:WROY:12-JUL-2018:ED1K907955
                ENDIF. " IF lr_renwl_p_det->auto_renew EQ 0
                lr_renwl_plan->aedat = sy-datum.
                lr_renwl_plan->aezet = sy-uzeit.
                lr_renwl_plan->aenam = sy-uname.
                APPEND lr_renwl_plan->* TO li_renwl_plan.
                CLEAR lr_renwl_plan->*.

              ENDIF. " IF lv_scenario = 1
*& Populate Lapse Activity details
              IF lr_renwl_p_det->lapse IS NOT INITIAL.
                lr_renwl_plan->vbeln = vbak-vbeln. " Order
                lr_renwl_plan->posnr = lst_xvbap_e095-posnr. " Items
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
                lr_renwl_plan->matnr = lst_xvbap_e095-matnr. " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122

                lr_renwl_plan->activity = lc_lapse. " Lapse Activity
                lr_renwl_plan->renwl_prof =  lr_renwl_p_det->renwl_prof. " renewal Profile
                CLEAR: lv_days,lv_date,lst_veda.
                READ TABLE li_veda INTO lst_veda WITH KEY vbeln = vbak-vbeln
                                                          vposn = lst_xvbap_e095-posnr.
                IF sy-subrc EQ 0.
                  lv_date = lst_veda-venddat.
                ELSE. " ELSE -> IF sy-subrc EQ 0
                  READ TABLE li_veda INTO lst_veda WITH KEY vbeln = vbak-vbeln
                                                             vposn = posnr_low.
                  IF sy-subrc = 0.
                    lv_date  = lst_veda-venddat .

                  ENDIF. " IF sy-subrc = 0
                ENDIF. " IF sy-subrc EQ 0
*               Begin of ADD:INC0202834:WROY:12-JUL-2018:ED1K907955
                lr_renwl_plan->eadat = lv_date + lr_renwl_p_det->lapse.
*               End   of ADD:INC0202834:WROY:12-JUL-2018:ED1K907955
*               Begin of DEL:INC0202834:WROY:12-JUL-2018:ED1K907955
*               ADD lr_renwl_p_det->lapse TO lv_days.
**& ADD Days to a date
*               CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*                 EXPORTING
*                   date      = lv_date "xveda-venddat
*                   days      = lv_days
*                   months    = lc_month
*                   years     = lc_year
*                 IMPORTING
*                   calc_date = lr_renwl_plan->eadat.
**& The FM has no exception , hence ys-subrc not used
*               End   of DEL:INC0202834:WROY:12-JUL-2018:ED1K907955
                lr_renwl_plan->aedat = sy-datum.
                lr_renwl_plan->aezet = sy-uzeit.
                lr_renwl_plan->aenam = sy-uname.
                APPEND lr_renwl_plan->* TO li_renwl_plan.
                CLEAR lr_renwl_plan->*.

              ENDIF. " IF lr_renwl_p_det->lapse IS NOT INITIAL
            ENDLOOP. " LOOP AT li_renwl_p_det REFERENCE INTO lr_renwl_p_det USING KEY renwl_pro WHERE renwl_prof = lr_rp_deter_t->renwl_prof
          ENDIF. " IF lr_rp_deter_t->renwl_prof IS NOT INITIAL
        ENDLOOP. " LOOP AT li_xvbap INTO lst_xvbap_e095

        li_xvbap[] = xvbap[].
        DELETE li_xvbap WHERE updkz NE updkz_update  " Only consider updated lines
                          AND updkz NE updkz_delete. " Only consider deleted lines
*Begin of Del-Anirban-08.22.2017-ED2K908108-Defect 4002
*        DELETE li_xvbap WHERE uepos IS NOT INITIAL.                         " Delete BOM Components
*End of Del-Anirban-08.22.2017-ED2K908108-Defect 4002
*Begin of Add-Anirban-08.22.2017-ED2K908108-Defect 4002
        DELETE li_xvbap WHERE uepos IS NOT INITIAL AND pstyv NOT IN lir_pstyv_range. " Delete BOM Components
*End of Add-Anirban-08.22.2017-ED2K908108-Defect 4002

        CLEAR lr_renwl_plan->*.
        LOOP AT li_xvbap INTO DATA(lst_xvbap_tmp).
          IF lst_xvbap_tmp-abgru IS NOT INITIAL AND lst_xvbap_tmp-updkz EQ updkz_update.
            lr_renwl_plan->vbeln = vbak-vbeln.
            lr_renwl_plan->posnr = lst_xvbap_tmp-posnr.
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
            lr_renwl_plan->matnr = lst_xvbap_tmp-matnr. " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
*           Begin of ADD:INC0198259:WROY:07-June-2018:ED1K907645
            lr_renwl_plan->ren_status = lc_canc_ord.
*           End   of ADD:INC0198259:WROY:07-June-2018:ED1K907645

            APPEND lr_renwl_plan->* TO li_renwl_plan_t.
            CLEAR  lr_renwl_plan->*.
          ELSEIF   lst_xvbap_tmp-updkz EQ updkz_delete.
            lr_renwl_plan->vbeln = vbak-vbeln.
            lr_renwl_plan->posnr = lst_xvbap_tmp-posnr.
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
            lr_renwl_plan->matnr = lst_xvbap_tmp-matnr. " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
*           Begin of ADD:INC0198259:WROY:07-June-2018:ED1K907645
            lr_renwl_plan->ren_status = lc_canc_ord.
*           End   of ADD:INC0198259:WROY:07-June-2018:ED1K907645

            APPEND lr_renwl_plan->* TO li_renwl_plan_t.
            CLEAR  lr_renwl_plan->*.
          ELSE. " ELSE -> IF lst_xvbap_tmp-abgru IS NOT INITIAL AND lst_xvbap_tmp-updkz EQ updkz_update
*           READ TABLE xveda INTO DATA(lst_xveda) WITH KEY vbeln = vbak-vbeln
            READ TABLE li_veda INTO DATA(lst_xveda) WITH KEY vbeln = vbak-vbeln
                                                           vposn = lst_xvbap_tmp-posnr.
            IF sy-subrc <> 0 .
*             READ TABLE xveda INTO lst_xveda WITH KEY vbeln = vbak-vbeln
              READ TABLE li_veda INTO lst_xveda WITH KEY vbeln = vbak-vbeln
                                                       vposn = posnr_low.
              IF sy-subrc <> 0.
                IF xveda-vposn = lst_xvbap_tmp-posnr.
                  lst_xveda-vkuegru =  xveda-vkuegru.
                ENDIF. " IF xveda-vposn = lst_xvbap_tmp-posnr
              ENDIF. " IF sy-subrc <> 0
            ENDIF. " IF sy-subrc <> 0

            IF lst_xveda-vkuegru IS NOT INITIAL.
              lr_renwl_plan->vbeln = vbak-vbeln.
              lr_renwl_plan->posnr = lst_xvbap_tmp-posnr.
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
              lr_renwl_plan->matnr = lst_xvbap_tmp-matnr. " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
*             Begin of ADD:INC0198259:WROY:07-June-2018:ED1K907645
              lr_renwl_plan->ren_status = lc_canc_ord.
*             End   of ADD:INC0198259:WROY:07-June-2018:ED1K907645

              APPEND lr_renwl_plan->* TO li_renwl_plan_t.
              CLEAR  lr_renwl_plan->*.
            ENDIF. " IF lst_xveda-vkuegru IS NOT INITIAL
            CLEAR lst_xveda.
          ENDIF. " IF lst_xvbap_tmp-abgru IS NOT INITIAL AND lst_xvbap_tmp-updkz EQ updkz_update
        ENDLOOP. " LOOP AT li_xvbap INTO DATA(lst_xvbap_tmp)

*& create renwal ( ZREW )
*       Begin of DEL:INC0198259:WROY:07-June-2018:ED1K907645
*       READ TABLE li_constant REFERENCE INTO DATA(lrf_constant) WITH KEY devid = lc_devid
*                                                                         srno  = lc_srno.
*       IF sy-subrc = 0.
*         DATA(lv_auart) = lrf_constant->low.
*
*       ENDIF. " IF sy-subrc = 0
*       IF vbak-auart = lv_auart.
*       End   of DEL:INC0198259:WROY:07-June-2018:ED1K907645
*       Begin of ADD:INC0198259:WROY:07-June-2018:ED1K907645
        IF vbak-auart IN lir_auart_range.
*       End   of ADD:INC0198259:WROY:07-June-2018:ED1K907645
          li_xvbap_k[] = xvbap[].
*Begin of Del-Anirban-08.22.2017-ED2K908108-Defect 4002
*        DELETE li_xvbap_k WHERE uepos IS NOT INITIAL.                         " Delete BOM Components
*End of Del-Anirban-08.22.2017-ED2K908108-Defect 4002
*Begin of Add-Anirban-08.22.2017-ED2K908108-Defect 4002
          DELETE li_xvbap_k WHERE uepos IS NOT INITIAL AND pstyv NOT IN lir_pstyv_range. " Delete BOM Components
*End of Add-Anirban-08.22.2017-ED2K908108-Defect 4002

          DELETE li_xvbap_k WHERE updkz NE updkz_new.

          LOOP AT li_xvbap_k  INTO DATA(lst_xvbap_k)  .
            READ TABLE xvbfa  INTO DATA(lst_xvbfa_k) WITH KEY vbelv = lst_xvbap_k-vgbel
                                                               posnv = lst_xvbap_k-vgpos.
            IF sy-subrc = 0.
              lr_renwl_plan->vbeln = lst_xvbfa_k-vbelv.
              lr_renwl_plan->posnr = lst_xvbfa_k-posnv.
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
              lr_renwl_plan->matnr = lst_xvbap_k-matnr. " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122

              APPEND lr_renwl_plan->* TO li_renwl_plan_t.
              CLEAR  lr_renwl_plan->*.
            ENDIF. " IF sy-subrc = 0
          ENDLOOP. " LOOP AT li_xvbap_k INTO DATA(lst_xvbap_k)
        ENDIF. " IF vbak-auart IN lir_auart_range

        IF NOT li_renwl_plan_t IS INITIAL.
*       Determine if any Renewal Subscription Order is already created
          SELECT vbelv "Preceding sales and distribution document
                 posnv "Preceding item of an SD document
                 vbeln "Subsequent sales and distribution document
                 posnn "Subsequent item of an SD document
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
                matnr " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122

            FROM vbfa
            INTO TABLE li_ren_subs
             FOR ALL ENTRIES IN li_renwl_plan_t
           WHERE ( vbelv   = li_renwl_plan_t-vbeln
             AND posnv   = li_renwl_plan_t-posnr )  OR
             ( vbeln = li_renwl_plan_t-vbeln AND
               posnn  = li_renwl_plan_t-posnr )
             AND vbtyp_n IN ( lc_contract, lc_quot )
             AND stufe = lc_lvel_doc. " One step up
*--*BOC ERPM-15045 Prabhu 10/15/2020 TR ED2K919935
*------------------------------------------------------------------------------------*
* ERPM-15045 Get Reference Contract number for ZSQT which is created without reference*
*-------------------------------------------------------------------------------------*
          IF sy-subrc NE 0.
            DATA : li_vbfa     TYPE STANDARD TABLE OF vbfa,
                   lst_ren_sub TYPE lty_ren_subs.
            CALL FUNCTION 'ZQTC_GET_CONTRACT_FUTURE_E095'
              TABLES
                t_renew = li_renwl_plan_t
                t_vbfa  = li_vbfa.
            IF li_vbfa IS NOT INITIAL.
              LOOP AT li_vbfa INTO DATA(lst_vbfa).
                lst_ren_sub-vbelv = lst_vbfa-vbelv.
                lst_ren_sub-posnv = lst_vbfa-posnv.
                lst_ren_sub-vbeln = lst_vbfa-vbeln.
                lst_ren_sub-posnn = lst_vbfa-posnn.
                lst_ren_sub-matnr = lst_vbfa-matnr.
                APPEND lst_ren_sub TO li_ren_subs.
                CLEAR lst_ren_sub.
              ENDLOOP.
              sy-subrc = 0.
            ENDIF.
          ENDIF.
*--*EOC ERPM-15045 Prabhu 10/15/2020 TR ED2K919935
          IF sy-subrc EQ 0.

            LOOP AT li_ren_subs ASSIGNING FIELD-SYMBOL(<lst_ren_subs>).
              READ TABLE xvbfa INTO lst_xvbfa_k WITH KEY  vbelv =  <lst_ren_subs>-vbeln
                                                          posnv =  <lst_ren_subs>-posnn.
              IF sy-subrc = 0.
                lr_renwl_plan->vbeln = <lst_ren_subs>-vbelv.
                lr_renwl_plan->posnr = <lst_ren_subs>-posnv.
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
                lr_renwl_plan->matnr = <lst_ren_subs>-matnr. " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122

                APPEND lr_renwl_plan->* TO li_renwl_plan_t.
                CLEAR  lr_renwl_plan->*.

              ELSE. " ELSE -> IF sy-subrc = 0

                lr_renwl_plan->vbeln = <lst_ren_subs>-vbeln.
                lr_renwl_plan->posnr = <lst_ren_subs>-posnn.
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
                lr_renwl_plan->matnr = <lst_ren_subs>-matnr. " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
                APPEND lr_renwl_plan->* TO li_renwl_plan_t.
                CLEAR  lr_renwl_plan->*.
              ENDIF. " IF sy-subrc = 0
            ENDLOOP. " LOOP AT li_ren_subs ASSIGNING FIELD-SYMBOL(<lst_ren_subs>)

          ENDIF. " IF sy-subrc EQ 0

*& Need to select all the fields
          SELECT mandt    " Client
                 vbeln    " Sales Document
                 posnr    " Sales Document Item
                 activity " E095: Activity
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
                 matnr " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
                 eadat      " Activity Date
                 renwl_prof " Renewal Profile
                 promo_code " Promo code
                 act_status " Activity Status
                 ren_status " Renewal Status
*                Begin of ADD:ERP-6347:WROY:18-JUN-2018:ED2K912338
                 excl_resn " Exclusion reason
                 excl_date " Exclusion date
*                End   of ADD:ERP-6347:WROY:18-JUN-2018:ED2K912338
*---Begin of change RKUMAR2    DM1916 15/Aug/2019
                 excl_resn2 "Exclusion Reason
                 excl_date2 "Exclusion Date
                 other_cmnts "Review Comments
*---End of change RKUMAR2    DM1916 15/Aug/2019
                 aenam " Name of Person Who Changed Object
                 aedat " Changed On
                 aezet
*                BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
                 log_type     " Message Type
                 lognumber    " Application log: log number
                 test_run     " Test Run
                 review_stat  " Review Status
                 comments     " Review Comments
*                EOC - NPALLA - E096 - 2018/08/27 - ED2K912739
            FROM zqtc_renwl_plan
           APPENDING  TABLE li_renwl_plan
             FOR ALL ENTRIES IN li_renwl_plan_t
           WHERE vbeln EQ li_renwl_plan_t-vbeln
             AND posnr EQ li_renwl_plan_t-posnr.
          IF sy-subrc = 0.
            CLEAR lst_xvbap_k.
            LOOP AT li_renwl_plan ASSIGNING FIELD-SYMBOL(<lfs_renwl_plan_d>).
*                Commented by MODUTTA on 05/11/2017 for Defect# ERP1865
*                READ TABLE li_ren_subs ASSIGNING <lst_ren_subs>   WITH KEY vbelv =   <lfs_renwl_plan_d>-vbeln
*                                                                           posnv =   <lfs_renwl_plan_d>-posnr.
              READ TABLE li_ren_subs ASSIGNING <lst_ren_subs>   WITH KEY vbeln =   <lfs_renwl_plan_d>-vbeln
                                                                         posnn =   <lfs_renwl_plan_d>-posnr.
              IF sy-subrc = 0 .
                READ TABLE xvbfa INTO lst_xvbfa_k WITH KEY  vbelv =  <lst_ren_subs>-vbeln
                                                            posnv =  <lst_ren_subs>-posnn.
                IF sy-subrc = 0 .
                  <lfs_renwl_plan_d>-act_status = abap_true.
                  <lfs_renwl_plan_d>-ren_status = abap_true.
                  <lfs_renwl_plan_d>-aedat      = sy-datum. " System Date
                  <lfs_renwl_plan_d>-aezet      = sy-uzeit. " System Time
                  <lfs_renwl_plan_d>-aenam      = sy-uname. " User Name
                ELSE. " ELSE -> IF sy-subrc = 0
                  READ TABLE li_renwl_plan_t INTO DATA(lst_renwl_plan_d) WITH KEY vbeln = <lfs_renwl_plan_d>-vbeln
                                                                                  posnr = <lfs_renwl_plan_d>-posnr.
                  IF sy-subrc = 0 .
                    <lfs_renwl_plan_d>-act_status = abap_true.
                    <lfs_renwl_plan_d>-ren_status = lc_canc_ord.
                    <lfs_renwl_plan_d>-aedat      = sy-datum. " System Date
                    <lfs_renwl_plan_d>-aezet      = sy-uzeit. " System Time
                    <lfs_renwl_plan_d>-aenam      = sy-uname. " User Name
                  ENDIF. " IF sy-subrc = 0
                ENDIF. " IF sy-subrc = 0
              ELSE. " ELSE -> IF sy-subrc = 0
                READ TABLE li_renwl_plan_t INTO lst_renwl_plan_d WITH KEY vbeln = <lfs_renwl_plan_d>-vbeln
                                                                          posnr = <lfs_renwl_plan_d>-posnr.
                IF sy-subrc = 0 .
                  <lfs_renwl_plan_d>-act_status = abap_true.
*Begin of delete:Defect #2488:ANISAHA:06.02.2017: ED2K906489
*                  <lfs_renwl_plan_d>-ren_status = lc_canc_ord.
*End of delete:Defect #2488:ANISAHA:06.02.2017: ED2K906489

*Begin of Del-Anirban-07.13.2017-ED2K907223-Defect 3432
**Begin of add:Defect #2488:ANISAHA:06.02.2017: ED2K906489
*                  <lfs_renwl_plan_d>-ren_status = abap_true.
**End of add:Defect #2488:ANISAHA:06.02.2017: ED2K906489
*End of Del-Anirban-07.13.2017-ED2K907223-Defect 3432

*                 Begin of DEL:INC0198259:WROY:07-June-2018:ED1K907645
**Begin of Add-Anirban-07.13.2017-ED2K907223-Defect 3432
*                  <lfs_renwl_plan_d>-ren_status = abap_true . "lc_canc_ord.
**End of Add-Anirban-07.13.2017-ED2K907223-Defect 3432
*                 End   of DEL:INC0198259:WROY:07-June-2018:ED1K907645
*                 Begin of ADD:INC0198259:WROY:07-June-2018:ED1K907645
                  IF lst_renwl_plan_d-ren_status IS INITIAL.
                    <lfs_renwl_plan_d>-ren_status = abap_true.
                  ELSE. " ELSE -> IF lst_renwl_plan_d-ren_status IS INITIAL
                    <lfs_renwl_plan_d>-ren_status = lst_renwl_plan_d-ren_status.
                  ENDIF. " IF lst_renwl_plan_d-ren_status IS INITIAL
*                 End   of ADD:INC0198259:WROY:07-June-2018:ED1K907645

                  <lfs_renwl_plan_d>-aedat      = sy-datum. " System Date
                  <lfs_renwl_plan_d>-aezet      = sy-uzeit. " System Time
                  <lfs_renwl_plan_d>-aenam      = sy-uname. " User Name
                ENDIF. " IF sy-subrc = 0
              ENDIF. " IF sy-subrc = 0
            ENDLOOP. " LOOP AT li_renwl_plan ASSIGNING FIELD-SYMBOL(<lfs_renwl_plan_d>)
          ENDIF. " IF sy-subrc = 0
        ENDIF. " IF NOT li_renwl_plan_t IS INITIAL
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF i_rp_deter IS INITIAL
  ENDIF. " IF vbak-auart IN lir_auart_range

ELSEIF     vbak-vbtyp = lc_quot. " Else if check for document type check

  li_xvbap[] = xvbap[].
*Begin of Del-Anirban-08.22.2017-ED2K908108-Defect 4002
*        DELETE li_xvbap WHERE uepos IS NOT INITIAL.                         " Delete BOM Components
*End of Del-Anirban-08.22.2017-ED2K908108-Defect 4002
*Begin of Add-Anirban-08.22.2017-ED2K908108-Defect 4002
  DELETE li_xvbap WHERE uepos IS NOT INITIAL AND pstyv NOT IN lir_pstyv_range. " Delete BOM Components
*End of Add-Anirban-08.22.2017-ED2K908108-Defect 4002

  DELETE li_xvbap WHERE updkz NE updkz_update  " Only consider updated lines
                    AND updkz NE updkz_delete. " Only consider deleted lines

  LOOP AT li_xvbap INTO DATA(lst_xvbap_t) .
    READ TABLE xvbfa INTO DATA(lst_xvbfa_t) WITH KEY vbeln = vbak-vbeln
                                                     posnn = lst_xvbap_t-posnr.
    IF sy-subrc = 0.
      IF lst_xvbap_t-abgru IS NOT INITIAL AND lst_xvbap_t-updkz = updkz_update .
        lst_xvbfa_t-vbelv = lst_xvbfa_t-vbelv.
        lst_xvbfa_t-posnv = lst_xvbfa_t-posnv.
        APPEND lst_xvbfa_t TO li_xvbfa.
        CLEAR lst_xvbfa_t.
      ELSEIF   lst_xvbap_t-updkz = updkz_delete.
        lst_xvbfa_t-vbelv = lst_xvbfa_t-vbelv.
        lst_xvbfa_t-posnv = lst_xvbfa_t-posnv.
        APPEND lst_xvbfa_t TO li_xvbfa.
        CLEAR lst_xvbfa_t.
      ENDIF. " IF lst_xvbap_t-abgru IS NOT INITIAL AND lst_xvbap_t-updkz = updkz_update
    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT li_xvbap INTO DATA(lst_xvbap_t)
*& While Quotation creation with ref to subscription order we need to update the Activity
*& status as complete ( abap_true) in renwal plan table
  li_xvbap_k[] = xvbap[].
*Begin of Del-Anirban-08.22.2017-ED2K908108-Defect 4002
*        DELETE li_xvbap_k WHERE uepos IS NOT INITIAL.                         " Delete BOM Components
*End of Del-Anirban-08.22.2017-ED2K908108-Defect 4002
*Begin of Add-Anirban-08.22.2017-ED2K908108-Defect 4002
  DELETE li_xvbap_k WHERE uepos IS NOT INITIAL AND pstyv NOT IN lir_pstyv_range. " Delete BOM Components
*End of Add-Anirban-08.22.2017-ED2K908108-Defect 4002
  DELETE li_xvbap_k WHERE updkz NE updkz_new.

  LOOP AT li_xvbap_k REFERENCE INTO DATA(lr_xvbap_k)  .
    READ TABLE xvbfa REFERENCE INTO DATA(lr_xvbfa_t) WITH KEY vbelv = lr_xvbap_k->vgbel
                                                              posnv = lr_xvbap_k->vgpos.
    IF sy-subrc = 0.
      lst_xvbfa_t-vbelv = lr_xvbfa_t->vbelv.
      lst_xvbfa_t-posnv = lr_xvbfa_t->posnv.
      APPEND lst_xvbfa_t TO li_xvbfa.
      CLEAR lst_xvbfa_t.
    ENDIF. " IF sy-subrc = 0

  ENDLOOP. " LOOP AT li_xvbap_k REFERENCE INTO DATA(lr_xvbap_k)

  IF li_xvbfa[] IS NOT INITIAL.
*& Need to select all the fields
    SELECT mandt    " Client
           vbeln    " Sales Document
           posnr    " Sales Document Item
           activity " E095: Activity
*Begin of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
           matnr " Material no
*End of Add-Anirban-09.21.2017-ED2K908463-Defect 4122
           eadat      " Activity Date
           renwl_prof " Renewal Profile
           promo_code " Promo code
           act_status " Activity Status
           ren_status " Renewal Status
*          Begin of ADD:ERP-6347:WROY:18-JUN-2018:ED2K912338
           excl_resn " Exclusion reason
           excl_date " Exclusion date
*          End   of ADD:ERP-6347:WROY:18-JUN-2018:ED2K912338
*   Begin of change RKUMAR2    DM1916 15/Aug/2019
           excl_resn2 "Exclusion Reason
           excl_date2 "Exclusion Date
           other_cmnts "Review Comments
*   End of change RKUMAR2    DM1916 15/Aug/2019
           aenam " Name of Person Who Changed Object
           aedat " Changed On
           aezet
*          BOC
           log_type     " Message Type
           lognumber    " Application log: log number
           test_run     " Test Run
           review_stat  " Review Status
           comments     " Review Comments
*          EOC
      FROM zqtc_renwl_plan
      INTO TABLE li_renwl_plan
       FOR ALL ENTRIES IN li_xvbfa
     WHERE vbeln EQ li_xvbfa-vbelv
       AND posnr EQ li_xvbfa-posnv.
    IF sy-subrc = 0.
      LOOP AT li_renwl_plan ASSIGNING FIELD-SYMBOL(<lfs_renwl_plan>).
*& Quotation update / Delete scenario
        READ TABLE li_xvbap INTO lst_xvbap_t WITH KEY vbeln = <lfs_renwl_plan>-vbeln
                                                      posnr = <lfs_renwl_plan>-posnr.
        IF sy-subrc = 0.
          <lfs_renwl_plan>-act_status = abap_true.
          <lfs_renwl_plan>-ren_status = lc_canc_ord.
          <lfs_renwl_plan>-aezet      = sy-uzeit. " System Time
          <lfs_renwl_plan>-aenam      = sy-uname. " User Name
        ENDIF. " IF sy-subrc = 0
*& Quptation create scenario
        READ TABLE li_xvbap_k REFERENCE INTO lr_xvbap_k WITH KEY vgbel =   <lfs_renwl_plan>-vbeln
                                                                 vgpos  =  <lfs_renwl_plan>-posnr  .
        IF sy-subrc = 0 AND <lfs_renwl_plan>-activity = lc_cr_quote.
          <lfs_renwl_plan>-act_status = abap_true.
          <lfs_renwl_plan>-aedat  = sy-datum.
          <lfs_renwl_plan>-aezet      = sy-uzeit. " System Time
          <lfs_renwl_plan>-aenam      = sy-uname. " User Name

        ENDIF. " IF sy-subrc = 0 AND <lfs_renwl_plan>-activity = lc_cr_quote

      ENDLOOP. " LOOP AT li_renwl_plan ASSIGNING FIELD-SYMBOL(<lfs_renwl_plan>)
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF li_xvbfa[] IS NOT INITIAL
  DELETE li_renwl_plan WHERE act_status NE abap_true.
ENDIF. " IF vbak-vbtyp = lc_contract

*& Update Renewal Plan Table
IF NOT li_renwl_plan[] IS INITIAL.
* Begin of ADD:ERP-6293:WROY:25-JUN-2018:ED2K912338
* Begin of ADD:INC0239319:NPALLA:27-May-2018:ED1K910215
  DATA: lst_renewal_plan_ren_chk TYPE zqtc_renwl_plan.
  DATA: lv_flg_del_ren_plan      TYPE char1.
  CONSTANTS: lc_renewed TYPE zren_status    VALUE 'X'.  " Renewed
* End of ADD:INC0239319:NPALLA:27-May-2018:ED1K910215
* Do not modify the already Executed / Excluded Activities
  LOOP AT li_renwl_plan ASSIGNING <lfs_renwl_plan>.
* Begin of ADD:INC0239319:NPALLA:27-May-2018:ED1K910215
    AT NEW posnr.
      CLEAR: lv_flg_del_ren_plan.
      SELECT SINGLE * FROM zqtc_renwl_plan
        INTO lst_renewal_plan_ren_chk
        WHERE vbeln    = <lfs_renwl_plan>-vbeln    " Sales Document
          AND posnr    = <lfs_renwl_plan>-posnr    " Sales Document Item
          AND ren_status = lc_renewed.
      IF sy-subrc = 0.
        lv_flg_del_ren_plan = abap_true.
      ENDIF.
    ENDAT.
    IF lv_flg_del_ren_plan = abap_true.
      CLEAR: <lfs_renwl_plan>-vbeln,
             <lfs_renwl_plan>-posnr.
      CONTINUE.
    ENDIF.
* End of ADD:INC0239319:NPALLA:27-May-2018:ED1K910215

    READ TABLE li_ren_plan_ex ASSIGNING <lst_ren_plan_ex>
         WITH KEY vbeln    = <lfs_renwl_plan>-vbeln    " Sales Document
                  posnr    = <lfs_renwl_plan>-posnr    " Sales Document Item
                  activity = <lfs_renwl_plan>-activity " Acitivity
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      IF <lst_ren_plan_ex>-act_status IS NOT INITIAL OR
         <lst_ren_plan_ex>-excl_resn  IS NOT INITIAL.
        CLEAR: <lfs_renwl_plan>-vbeln,
               <lfs_renwl_plan>-posnr.
      ENDIF. " IF <lst_ren_plan_ex>-act_status IS NOT INITIAL OR
      CLEAR: <lst_ren_plan_ex>-mandt.
    ENDIF. " IF sy-subrc EQ 0
  ENDLOOP. " LOOP AT li_renwl_plan ASSIGNING <lfs_renwl_plan>
  DELETE li_renwl_plan  WHERE vbeln IS INITIAL
                          AND posnr IS INITIAL.

* Modify / Cancel the entries those are not needed anymore
  DELETE li_ren_plan_ex WHERE mandt      IS INITIAL
                           OR act_status IS NOT INITIAL
                           OR excl_resn  IS NOT INITIAL.
  LOOP AT li_ren_plan_ex ASSIGNING <lst_ren_plan_ex>.
    <lst_ren_plan_ex>-act_status = abap_true.
    <lst_ren_plan_ex>-ren_status = lc_not_nded.
    <lst_ren_plan_ex>-aedat      = sy-datum. " System Date
    <lst_ren_plan_ex>-aezet      = sy-uzeit. " System Time
    <lst_ren_plan_ex>-aenam      = sy-uname. " User Name
    APPEND <lst_ren_plan_ex> TO li_renwl_plan.
  ENDLOOP. " LOOP AT li_ren_plan_ex ASSIGNING <lst_ren_plan_ex>
* End   of ADD:ERP-6293:WROY:25-JUN-2018:ED2K912338
  CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL' IN UPDATE TASK
    TABLES
      t_renwl_plan = li_renwl_plan.
ENDIF. " IF NOT li_renwl_plan[] IS INITIAL
