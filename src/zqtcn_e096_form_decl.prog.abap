*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_E096_FORM_DECL
* PROGRAM DESCRIPTION:Include for populating auto renewal plan table
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2017-01-04
* OBJECT ID:E096
* TRANSPORT NUMBER(S) ED2K903901
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K905851
* REFERENCE NO:  ERP-1888
* DEVELOPER:     Kamalendu Chakraborty
* DATE:  2017-05-03
* DESCRIPTION: Passing Sales office and pricing group
*              BOC KCHAKRABOR ERP-1888 2017-05-03
*              EOC KCHAKRABOR ERP-1888 2017-05-03
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906293
* REFERENCE NO:  ERP-2232
* DEVELOPER: Anirban Saha
* DATE:  2017-05-24
* DESCRIPTION: Copy Customer PO while creating Grace Subscription Order
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906293
* REFERENCE NO:  ERP-2233
* DEVELOPER: Writtick Roy
* DATE:  2017-05-25
* DESCRIPTION: Copy several fields while creating Grace Subscription
* Order refering to the Original Subscription Order
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906489
* REFERENCE NO:  CR# 546
* DEVELOPER: Writtick Roy
* DATE:  2017-06-03
* DESCRIPTION: Populate Contract Start / End Date for Quotations
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907327
* REFERENCE NO: Defect 3068
* DEVELOPER: Anirban Saha
* DATE:  2017-07-17
* DESCRIPTION: ZQT document could not determine the sales rep
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907327
* REFERENCE NO:  ERP 3301
* DEVELOPER: ANIRBAN SAHA
* DATE:  2017-07-25
* DESCRIPTION: Remove status change checkbox from selection screen
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907507
* REFERENCE NO:  ERP 3528
* DEVELOPER: ANIRBAN SAHA
* DATE:  2017-07-26
* DESCRIPTION: Implement material determination while creating
*              quotation (ZSQT) from the Order (ZSUB)
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907539
* REFERENCE NO:  ERP 3335
* DEVELOPER: ANIRBAN SAHA
* DATE:  2017-07-26
* DESCRIPTION: Reprice renewal order after it got created
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907608
* REFERENCE NO:  ERP 3682
* DEVELOPER: ANIRBAN SAHA
* DATE:  2017-07-28
* DESCRIPTION: Populate Customer condition group 5 for gracing doc
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908625
* REFERENCE NO:  ERP 4443
* DEVELOPER: ANIRBAN SAHA
* DATE:  2017-09-20
* DESCRIPTION: Removing REF_1 field while creating Quote from SUB
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908670
* REFERENCE NO:  ERP 4122
* DEVELOPER: ANIRBAN SAHA
* DATE:  2017-09-22
* DESCRIPTION: Include material no field into the report
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908670
* REFERENCE NO:  ERP 4443
* DEVELOPER: ANIRBAN SAHA
* DATE:  2017-09-28
* DESCRIPTION: Remove reference no from quote while creating ZSQT
*              from ZSUB order
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908670
* REFERENCE NO:  ERP 4718
* DEVELOPER: ANIRBAN SAHA
* DATE:  2017-09-29
* DESCRIPTION: ZREW order should have a new contract start date
*             (ZSUB contract start date + 1 )
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908816
* REFERENCE NO:  ERP 4753
* DEVELOPER: ANIRBAN SAHA
* DATE:  2017-10-04
* DESCRIPTION: Modify item no for material detemination cases
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908890
* REFERENCE NO:  ERP 4669
* DEVELOPER: ANIRBAN SAHA
* DATE:  2017-10-09
* DESCRIPTION: Update reason for rejection with lapse code while lapsing
*              an order
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909739
* REFERENCE NO:  ERP 5538
* DEVELOPER: Writtick Roy
* DATE:  2017-12-06
* DESCRIPTION: Fix Ref Doc Category population logic while creating
*              Quotation
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910161
* REFERENCE NO:  ERP 5717
* DEVELOPER: Writtick Roy
* DATE:  2018-01-08
* DESCRIPTION: Copy Currency while creating Renewal Sub / Quote with
*              reference to a Subscription
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910239
* REFERENCE NO:  ERP 5850
* DEVELOPER: Writtick Roy
* DATE:  2018-01-10
* DESCRIPTION: Copy Customer PO while creating Renewal Sub / Quote with
*              reference to a Subscription
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910241, ED2K910272
* REFERENCE NO:  ERP 5828
* DEVELOPER: Writtick Roy
* DATE:  2018-01-10
* DESCRIPTION: Do not populate Item Category for Grace Subscriptions
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910345
* REFERENCE NO:  ERP 5997
* DEVELOPER: Writtick Roy
* DATE:  2018-01-17
* DESCRIPTION: PO Number is getting truncated
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910611
* REFERENCE NO:  ERP 6283
* DEVELOPER: Writtick Roy
* DATE:  2018-01-31
* DESCRIPTION: Populate “Action” and “Action date” fields in Renewal
*              and Grace Subscription Orders
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
* REVISION NO: ED2K910691
* REFERENCE NO:  ERP 6508
* DEVELOPER: Writtick Roy
* DATE:  2018-02-06
* DESCRIPTION: 1. Consider Header Level Contract Data
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911135
* REFERENCE NO:  ERP 7331
* DEVELOPER: Writtick Roy
* DATE:  2018-03-30
* DESCRIPTION: 1. Fix the issue with wrong Message when there is no
*                 Promo Code to be applied
*------------------------------------------------------------------- *
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K907603
* REFERENCE NO:  INC0197849
* DEVELOPER: Monalisa Dutta
* DATE:  2018-06-05
* DESCRIPTION: Copying subscription type from subscription to quotation
*------------------------------------------------------------------- *
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
* REVISION NO: ED2K912802, ED2K913164
* REFERENCE NO:  ERP-6343
* DEVELOPER: Writtick Roy (WROY) / Niraj Gadre (NGADRE)
* DATE:  2018-08-01
* DESCRIPTION:  Add the logic to create the single quotation / reminders
*for sub. orders with Consolidate = 'X' in renewal profile
*------------------------------------------------------------------- *
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K908356
* REFERENCE NO:  INC0209907
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-10-04
* DESCRIPTION: Copy PO Number from Individual Documents
*------------------------------------------------------------------- *
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K908393
* REFERENCE NO: INC0202201
* DEVELOPER:    Geeta Kintali
* DATE:         2018-08-27
* DESCRIPTION:  To determine the requested delivery date, Valid From
*               and Valid TO fields based on the contract end date
*               of the line item 000010 and updated the logic to
*               capture order number in job log
*----------------------------------------------------------------------*
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K913145, ED2K913310
* REFERENCE NO:  ERP-6344
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-08-20
* DESCRIPTION: Populate fields required for Product Substitution
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
* REVISION NO: ED2K914462
* REFERENCE NO:  CR# 7825
* DEVELOPER: PRABHU
* DATE:  2019-02-13
* DESCRIPTION: Map payment terms fields ZSUB->ZREW
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K909890 / ED1K909909
* REFERENCE NO: INC0234283
* DEVELOPER: Himanshu Patel (HIPATEL)
* DATE:  03/27/2019
* DESCRIPTION: Override Currency in Renw. Order
*           -  Currency field added on the selection screen and
*              display for only authorized user
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914491
* REFERENCE NO:  CR# 7873
* DEVELOPER: PRABHU
* DATE:  2019-02-21
* DESCRIPTION: Map payment Method ZSUB->ZREW
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED1K909923 / ED1K910179
* REFERENCE NO:  INC0241861
* DEVELOPER: NPALLA
* DATE:  2019-05-13
* DESCRIPTION: Capture Vendor Partner Details (freight forwrading addres
*              Quotations, Subscriptions, Grace Subscriptions
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915200
* REFERENCE NO: DM# 1923
* DEVELOPER: Kiran Kumar Ravuri (KKR)
* DATE:  2019-06-06
* DESCRIPTION: Addition of Check/Un-check functionality
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915501
* REFERENCE NO: DM# 1916
* DEVELOPER: Prabhu(PTUFARAM)
* DATE:  2019-07-12
* DESCRIPTION: Addition of Exclusion reason 2 and comments functionality
*------------------------------------------------------------------- *
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915501
* REFERENCE NO: DM# 1916
* DEVELOPER: Prabhu(PTUFARAM)
* DATE:  2019-07-12
* DESCRIPTION: Addition of Exclusion reason 2 and comments functionality
*------------------------------------------------------------------- *
* REVISION NO:   ED1K910931 /
* REFERENCE NO:  INC0246088
* DEVELOPER: BTIRUVATHU
* DATE:  2019-06-12
* DESCRIPTION: Quote - Contract Start and End Dates didn't Synchronous
*              with the Subscription type
*              For some subscription orders, the contract data in VEDA
*              has only header record and existing logic is checking
*              the record with posnr = 10.
*                                                                      *
*&---------------------------------------------------------------------*
* DEVELOPER: Lahiru Wathudura(lwathdura)
* CREATION DATE:  07/09/2020
* WRICEF ID: E096
* TRANSPORT NUMBER(S): ED2K918829
* REFERENCE NO: ERPM-16504
* Change : Additional Business Data fields are mapped(Customer Purchase order No)
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K919624
* REFERENCE NO: ERPM - 16414
* DEVELOPER: AMOHAMMED
* DATE:  09/25/2020
* DESCRIPTION: Filling Sales Group from reference contract to new renewal contract
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K919736
* REFERENCE NO: ERPM - 15045
* DEVELOPER: Prabhu
* DATE:  09/25/2020
* DESCRIPTION: Filling future renewal quote, in case of remainders R1,R2..etc
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K919919
* REFERENCE NO: ERPM - 21151
* DEVELOPER: AMOHAMMED
* DATE:  10/14/2020
* DESCRIPTION: Eliminate the rejected line items
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K912661
* REFERENCE NO: INC0338748
* DEVELOPER: BTIRUVATHU
* DATE:  FEB 6th 2021
* DESCRIPTION: Quotes not starting with correct start date
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K922409
* REFERENCE NO:  OTCM-40816 Renewal Quote Plant Change
* DEVELOPER: PRABHU (PTUFARAM)
* DATE:  March 9 2021
* DESCRIPTION: System should detrmine the Plan from Master data instead of
*                 Reference document
*----------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO   : ED2K924248
* REFERENCE NO  : OTCM-37069
* DEVELOPER     : VDPATABALL
* DATE          :  08/04/2021
* DESCRIPTION   : MultiYear Contract Renewal:
*                 If original contract is multiyear or single year
*student member contract (Condition group 2=05), renewal contract should
*renew for only one year. Other than Student members any multiyear contract
*should renew as multiyear contract.
*-------------------------------------------------------------------*

*&      Form  F_F4
*&---------------------------------------------------------------------*
*       Custom F4 help for sales order in the selection screen
*----------------------------------------------------------------------*
FORM f_f4  CHANGING p_vbeln.

  DATA: li_return TYPE ddshretval OCCURS 0 WITH HEADER LINE. " Interface Structure Search Help <-> Help System
  CONSTANTS: lc_auart1 TYPE auart VALUE 'ZSUB', " Sales Document Type
             lc_auart2 TYPE auart VALUE 'ZSUB'. " Sales Document Type

  SELECT vbeln FROM vbak INTO TABLE i_vbeln WHERE auart = lc_auart1 OR auart = lc_auart2.

  IF sy-subrc = 0.
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'VBELN_VA'
        dynpprog        = sy-repid
        dynpnr          = '1000'
        dynprofield     = 'S_vbeln'
        value_org       = 'S'
      TABLES
        value_tab       = i_vbeln
        return_tab      = li_return[]
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.

    IF NOT li_return[] IS INITIAL.
      READ TABLE li_return INDEX 1.
      IF sy-subrc = 0.
        p_vbeln = li_return-fieldval.
      ENDIF. " IF sy-subrc = 0
    ENDIF. " IF NOT li_return[] IS INITIAL
  ENDIF. " IF sy-subrc = 0
  CLEAR: li_return[].
  REFRESH: i_vbeln.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_ORDER
*&---------------------------------------------------------------------*
*       Validate Order number
*----------------------------------------------------------------------*

FORM f_order .
  IF s_vbeln[] IS NOT INITIAL  .
    SELECT vbeln " Sales order
      FROM vbak  " Sales Document: Header Data
      UP TO 1 ROWS
      INTO v_vblen
      WHERE
      vbeln IN s_vbeln.
    ENDSELECT.
    IF sy-subrc <> 0.
      MESSAGE e014(61) . "WITH text-001.

    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF s_vbeln[] IS NOT INITIAL

ENDFORM.

*Begin of Del-Anirban-07.25.2017-ED2K907327-Defect 3301
**&---------------------------------------------------------------------*
**&      Form  F_CHECK
**&---------------------------------------------------------------------*
**       Validate if both the checkboxes are checked or not
**----------------------------------------------------------------------*
*FORM f_check .
*  IF p_clear = abap_true AND p_status = abap_true.
*    MESSAGE e000(zqtc_r2) WITH text-001.
*  ENDIF.
*ENDFORM.
*End of Del-Anirban-07.25.2017-ED2K907327-Defect 3301

*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA
*&---------------------------------------------------------------------*
*       Fetch Data releted to orders
*----------------------------------------------------------------------*
*  -->  fp_i_final        :Final Table
*  -->  fp_i_item         : Items
*  -->  fp_i_partner      : Partner Details
*  -->  fp_i_textheaders  : Text Headers
*  -->  fp_i_textlines    : Text lines
*  -->  fp_i_header       : Headers
*  -->  fp_i_contract     : Contracts
*  -->  fp_i_docflow      : Docflow
*  -->  fp_i_veda         : Contract
*  -->  fp_i_nast         : Nast table
*----------------------------------------------------------------------*
FORM f_fetch_data CHANGING fp_i_final       TYPE tt_final
                           fp_i_item        TYPE tt_item
                           fp_i_partner     TYPE tt_partner
                           fp_i_business    TYPE tt_business
                           fp_i_textheaders TYPE tt_textheaders
                           fp_i_textlines   TYPE tt_textlines
                           fp_i_header      TYPE tt_header
                           fp_i_contract    TYPE tt_contract
                           fp_i_docflow     TYPE tt_docflow
                           fp_i_ext_vbap    TYPE tt_ext_vbap " Added by MODUTTA on 5th-Jun-2018:INC0197849:TR# ED1K907603
                           fp_i_veda        TYPE tt_veda
                           fp_i_nast        TYPE tt_nast.
  DATA:
    lr_final     TYPE REF TO ty_renwl_plan, " Renwl Plan type
    lr_bapi_view TYPE REF TO order_view,    " View for Mass Selection of Sales Orders
    lr_sales     TYPE REF TO sales_key,     " Sales order
    li_nast      TYPE tt_nast,              " Internal table
    lr_nast      TYPE REF TO ty_nast,       " reference variable
*   BOC by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
    li_ext_out   TYPE bapiparex_t,
*   EOC by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
    li_sales     TYPE STANDARD TABLE OF sales_key INITIAL SIZE 0. " Internal table
  CONSTANTS lc_appl_area TYPE sna_kappl VALUE 'V1'. " Sales area

  CREATE DATA: lr_bapi_view,
               lr_sales.
  LOOP AT fp_i_final REFERENCE INTO lr_final.
    lr_sales->vbeln = lr_final->vbeln.
    APPEND lr_sales->* TO li_sales.
    CLEAR lr_sales->*.
  ENDLOOP. " LOOP AT fp_i_final REFERENCE INTO lr_final
  SORT li_sales BY vbeln.
  DELETE ADJACENT DUPLICATES FROM li_sales.
  lr_bapi_view->header = abap_true.
  lr_bapi_view->item = abap_true.
  lr_bapi_view->business = abap_true.
  lr_bapi_view->partner = abap_true.
  lr_bapi_view->text = abap_true.
  lr_bapi_view->contract = abap_true.
  lr_bapi_view->flow = abap_true.
*& Call function module to fecth order details
  CALL FUNCTION 'BAPISDORDER_GETDETAILEDLIST'
    EXPORTING
      i_bapi_view           = lr_bapi_view->*
    TABLES
      sales_documents       = li_sales
      order_headers_out     = fp_i_header
      order_items_out       = fp_i_item
      order_business_out    = fp_i_business
      order_partners_out    = fp_i_partner
      order_contracts_out   = fp_i_contract
      order_textheaders_out = fp_i_textheaders
      order_textlines_out   = fp_i_textlines
      order_flows_out       = fp_i_docflow
      extensionout          = li_ext_out. "Added by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
  IF fp_i_docflow IS NOT INITIAL.
    SELECT v~vbeln,   " Sales Document
           v~angdt,   " Quotation/Inquiry is valid from
           v~bnddt,   " Date until which bid/quotation is binding (valid-to date)
           v~vbtyp,   " SD document category
           v~auart,   " Sales Document Type
           f~vbelv,   " Preceding sales and distribution document
           f~posnn,   " Subsequent item of an SD document
           d~vbegdat, " Contract start date
           d~venddat  " Contract end date
      FROM vbak AS v INNER JOIN vbfa AS f
      ON v~vbeln = f~vbeln
      LEFT OUTER JOIN veda AS d ON v~vbeln = d~vbeln AND
                                   f~posnn = d~vposn
      FOR ALL ENTRIES IN @fp_i_docflow
      WHERE
      v~vbeln = @fp_i_docflow-subssddoc AND
      f~posnn = @fp_i_docflow-subsitdoc
               INTO CORRESPONDING FIELDS OF TABLE @fp_i_veda.

    CREATE DATA lr_nast.
    LOOP AT fp_i_docflow REFERENCE INTO DATA(lr_i_docflow).
      MOVE lr_i_docflow->subssddoc TO lr_nast->objky.
      APPEND lr_nast->* TO li_nast.
      CLEAR lr_nast->*.
    ENDLOOP. " LOOP AT fp_i_docflow REFERENCE INTO DATA(lr_i_docflow)
    IF li_nast IS NOT INITIAL.
*& Fetch data from nast table
      SELECT  n~kappl, " Application for message conditions
              n~objky, " Object key
              n~kschl, " Message type
              n~spras, " Message language
              n~parnr, " Message partner
              n~parvw, " Partner function (for example SH for ship-to party)
              n~erdat, " Date on which status record was created
              n~eruhr, " Time at which status record was created
              n~adrnr, " Address number
              n~nacha, " Message transmission medium
              n~anzal, " Number of messages (original + copies)
              n~vsztp  " Dispatch time
        FROM nast AS n
        INTO TABLE @fp_i_nast
        FOR ALL ENTRIES IN @li_nast
        WHERE kappl = @lc_appl_area AND
        n~objky = @li_nast-objky.
      IF sy-subrc IS NOT INITIAL.
*        no actions
      ENDIF. " IF sy-subrc IS NOT INITIAL
    ENDIF. " IF li_nast IS NOT INITIAL
  ENDIF. " IF fp_i_docflow IS NOT INITIAL

* BOC by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
  LOOP AT li_ext_out ASSIGNING FIELD-SYMBOL(<lst_ext_out>).
    CASE <lst_ext_out>-structure.
      WHEN c_bape_vbap.
        APPEND INITIAL LINE TO fp_i_ext_vbap ASSIGNING FIELD-SYMBOL(<lst_ext_vbap>).
        <lst_ext_vbap> = <lst_ext_out>-valuepart1.

      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP. " LOOP AT li_ext_out ASSIGNING FIELD-SYMBOL(<lst_ext_out>)
  SORT fp_i_ext_vbap BY vbeln posnr.
* EOC by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
* Begin of ADD:ERP-6343:WROY:28-AUG-2018:ED2K913164
  SORT fp_i_docflow  BY precsddoc preditdoc doccategor subssddoc subsitdoc.
* End   of ADD:ERP-6343:WROY:28-AUG-2018:ED2K913164
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_QUOATATION
*&---------------------------------------------------------------------*
*       Create Quotation with reference to subscription
*----------------------------------------------------------------------*
*      -->FP_I_HEADER   Header
*      -->FP_I_ITEM     Items
*      -->FP_I_PARTNER  Partner details
*      -->FP_I_TEXTHEADERS  text header
*      -->FP_I_TEXTLINES  text items
*      -->FP_I_contract  Contract data
*      -->FP_CONST       Constant table
*----------------------------------------------------------------------*
FORM f_create_quoatation  USING    fp_i_header TYPE tt_header
                                   fp_i_item TYPE tt_item
                                   fp_i_business TYPE tt_business
                                   fp_i_ext_vbap TYPE tt_ext_vbap      " Added by MODUTTA on 5th-Jun-2018:INC0197849:TR# ED1K907603
                                   fp_i_partner TYPE tt_partner
                                   fp_i_textheaders TYPE tt_textheaders
                                   fp_i_textlines TYPE tt_textlines
                                   fp_i_contract TYPE tt_contract
                                   fp_const TYPE tt_const
                                   fp_test TYPE char1                  " Test of type CHAR1
                           CHANGING fp_v_salesord TYPE bapivbeln-vbeln " Sales Document
                                    fp_v_act_status   TYPE zact_status " Activity Status
                                    fp_message TYPE char120            " Message of type CHAR120
                                    fp_i_return TYPE  tt_return.

  DATA: lr_header             TYPE REF TO bapisdhd1,                            " Reference for header data
        lr_i_partner          TYPE REF TO bapisdpart,                           "Reference for partner
        lr_i_header           TYPE REF TO  bapisdhd,                            " Reference for bapi header
        li_partner            TYPE STANDARD TABLE OF bapiparnr INITIAL SIZE 0,  " Internal table for partner details
        li_business           TYPE STANDARD TABLE OF bapisdbusi INITIAL SIZE 0, " BAPI Structure of VBKD with English Field Names
        li_return             TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0,   " reference variable for return
*       Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
        lr_sales_contract_in  TYPE  REF TO bapictr ,                            " contract data
        li_sales_contract_in  TYPE STANDARD TABLE OF bapictr ,                  " Internal  table for cond
        lr_sales_contract_inx TYPE REF TO  bapictrx ,                           " Communication fields: SD Contract Data Checkbox
        li_sales_contract_inx TYPE  STANDARD TABLE OF bapictrx INITIAL SIZE 0 , " Communication fields: SD Contract Data Checkbox
*       End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
        lr_const              TYPE REF TO ty_const,                             " reference for consatnt table
        lr_partner            TYPE REF TO bapiparnr,                            " refrence for partner
        li_item               TYPE STANDARD TABLE OF bapisditm INITIAL SIZE 0,  " Items
        lr_item               TYPE REF TO bapisditm,                            " reference variable for Item
        lr_business           TYPE REF TO bapisdbusi,                           " VBKD data
        li_itemx              TYPE STANDARD TABLE OF bapisditmx INITIAL SIZE 0, " reference for itemx
        lr_contract           TYPE REF TO bapisdcntr,                           " BAPI Structure of VEDA
        lr_return             TYPE REF TO bapiret2,                             " BAPI return
        lst_bapisdls          TYPE bapisdls,                                    " SD Checkbox for the Logic Switch
        li_order_schedules_in TYPE STANDARD TABLE OF bapischdl INITIAL SIZE 0,  " Communication Fields for Maintaining SD Doc. Schedule Lines
        lr_order_schedules_in TYPE REF TO bapischdl,                            "  class
        lr_itemx              TYPE REF TO bapisditmx,                           " reference for itemx
        lr_i_item             TYPE REF TO bapisdit,                             " reference for itemx
        lr_i_business         TYPE REF TO bapisdbusi,                           "  class
        lr_headerx            TYPE REF TO bapisdhd1x,                           "  class
*       BOC by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
        lr_ext_vbap           TYPE REF TO bape_vbap,                           " Vbap class
        lst_bape_vbap         TYPE bape_vbap,                                  " BAPI Interface for Customer Enhancements to Table VBAK
        lst_bape_vbapx        TYPE bape_vbapx,                                 " BAPI Interface for Customer Enhancements to Table VBAK
        lst_extensionin       TYPE bapiparex,                                  " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        li_extensionin        TYPE STANDARD TABLE OF bapiparex INITIAL SIZE 0, " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        lst_extensioninx      TYPE bapiparex,                                  " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        li_extensioninx       TYPE STANDARD TABLE OF bapiparex INITIAL SIZE 0. " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
*       EOC by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603

*Begin of Add-Anirban-07.25.2017-ED2K907507-Defect 3528
  DATA : lv_smatn TYPE smatn. " Substitute material
*End of Add-Anirban-07.25.2017-ED2K907507-Defect 3528

  CONSTANTS: lc_quotation TYPE vbtyp VALUE 'B',              " quotation type
             lc_contract  TYPE vbtyp VALUE 'G',              " contract
             lc_b         TYPE knprs VALUE 'B',              " Copy manual pricing elements and redetermine the others
             lc_insert    TYPE char1 VALUE 'I',              " iNSERT
             lc_posnr_low TYPE vbap-posnr    VALUE '000000', " Sales Document Item
             lc_posnr_10  TYPE vbap-posnr    VALUE '000010', " ++ by GKINTALI:ED1K908393:INC0202201:2018/08/27
             lc_days      TYPE t5a4a-dlydy VALUE '00',       " Days
             lc_month     TYPE t5a4a-dlymo  VALUE '00',      " Month
             lc_year      TYPE t5a4a-dlyyr  VALUE '01',      " Year
             lc_devid     TYPE zdevid VALUE 'E096',          "Development ID
             lc_param1    TYPE rvari_vnam VALUE 'CQ',        "Parameter1
*Begin of Add-Anirban-07.25.2017-ED2K907507-Defect 3528
             lc_kappl     TYPE kappl VALUE 'V',    " Application
             lc_kschl     TYPE kschd VALUE 'Z001'. " Material determination type
*End of Add-Anirban-07.25.2017-ED2K907507-Defect 3528
*---BOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
  DATA:lst_auart     TYPE fssc_dp_s_rg_auart.                        " Workarea for auart
  CONSTANTS:lc_devid_e107   TYPE zdevid       VALUE 'E107', "Development ID
            lc_auart        TYPE rvari_vnam   VALUE 'AUART_CHECK',
            lc_kdkg2        TYPE rvari_vnam   VALUE 'KDKG2',
            lc_period       TYPE vlauf_veda   VALUE '001',                  "Validity period of contract
            lc_categry      TYPE vlauk_veda   VALUE '02',               "Validity period category of contract
            lc_sno_e096_003 TYPE zsno         VALUE '003',  "Serial Number
            lc_key_003_e096 TYPE zvar_key     VALUE 'MULTIYEAR', "Var Key
            lc_devid_e096   TYPE zdevid       VALUE 'E096'.

  DATA:lv_venddat         TYPE vndat_veda,
       lst_veda_kopf      TYPE veda,
       lr_kdkg2           TYPE RANGE OF kdkg2,                                     "Contract Data
       lst_kdkg2          TYPE rjksd_mstav_range,
       lst_veda_pos       TYPE veda,
       lv_active_003_e096 TYPE zactive_flag. " Active / Inactive Flag



  IF ir_auart[] IS INITIAL
    OR ir_auart_ck[] IS INITIAL
    OR lr_kdkg2[] IS INITIAL.
* Get data from constant table
    SELECT devid,                       "Development ID
           param1,                      "ABAP: Name of Variant Variable
           param2,                      "ABAP: Name of Variant Variable
           sign ,                       "ABAP: ID: I/E (include/exclude values)
           opti ,                       "ABAP: Selection option (EQ/BT/CP/...)
           low  ,                       "Lower Value of Selection Condition
           high                        "Upper Value of Selection Condition
      FROM zcaconstant                 "Wiley Application Constant Table
      INTO TABLE @DATA(li_consts)
      WHERE devid    = @lc_devid_e107
*        AND param1   = @lc_auart
        AND activate = @abap_true. "Only active record
    IF sy-subrc IS INITIAL.
      SORT li_consts BY devid param1.
    ENDIF.

    LOOP AT li_consts INTO DATA(lst_consts).
      CASE lst_consts-param1.
        WHEN lc_auart.
          IF lst_consts-param2 = 'AUART' .
            lst_auart-sign   = lst_consts-sign.
            lst_auart-option = lst_consts-opti.
            lst_auart-low    = lst_consts-low.
            lst_auart-high   = lst_consts-high.
            APPEND lst_auart TO ir_auart_ck.
            CLEAR: lst_auart,
                   lst_consts.
          ELSE.
            lst_auart-sign   = lst_consts-sign.
            lst_auart-option = lst_consts-opti.
            lst_auart-low    = lst_consts-low.
            lst_auart-high   = lst_consts-high.
            APPEND lst_auart TO ir_auart.
            CLEAR: lst_auart,
                   lst_consts.
          ENDIF.
        WHEN lc_kdkg2.
          lst_kdkg2-sign   = lst_consts-sign.
          lst_kdkg2-option = lst_consts-opti.
          lst_kdkg2-low    = lst_consts-low.
          lst_kdkg2-high   = lst_consts-high.
          APPEND lst_kdkg2 TO lr_kdkg2.
          CLEAR: lst_kdkg2,
                 lst_consts.
      ENDCASE.
    ENDLOOP. " LOOP AT li_const INTO lst_const
  ENDIF.
*---EOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
  CREATE DATA: lr_header,
               lr_headerx,
               lr_partner,
               lr_i_partner,
*              Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
               lr_sales_contract_inx,
               lr_sales_contract_in,
*              End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
               lr_item,
               lr_itemx.

  READ TABLE fp_i_header REFERENCE INTO lr_i_header INDEX 1.
  IF sy-subrc = 0.
    lr_header->sd_doc_cat = lc_quotation.
    READ TABLE fp_const REFERENCE INTO lr_const WITH KEY devid  = lc_devid
                                                         param1 = lc_param1.
    IF sy-subrc = 0.
      lr_header->doc_type = lr_const->low. " 'ZSQT'.
    ENDIF. " IF sy-subrc = 0
    lr_header->sales_org = lr_i_header->sales_org.
*              BOC KCHAKRABOR ERP-1888 2017-05-03
    lr_header->sales_off = lr_i_header->sales_off.
*              EOC KCHAKRABOR ERP-1888 2017-05-03
    lr_header->distr_chan = lr_i_header->distr_chan.
    lr_header->division = lr_i_header->division.
    lr_header->ref_doc = lr_i_header->doc_number. "low.
*Begin of Del-Anirban-09.28.2017-ED2K908670-Defect 4443
*    lr_header->ref_doc_l = lr_i_header->doc_number. " ZSUB Reference no in ZSQT quote
*End of Del-Anirban-09.28.2017-ED2K908670-Defect 4443
    lr_header->refdoc_cat = lc_contract. "'G'.
    lr_header->refdoctype = lc_contract. "'G'.
*Begin of Del-Anirban-09.20.2017-ED2K908625-Defect 4443
*    lr_header->ref_1 = lr_i_header->doc_number.
*End of Del-Anirban-09.20.2017-ED2K908625-Defect 4443
*   Begin of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    lr_header->currency  = lr_i_header->currency.
*   End   of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    lr_header->refobjtype = 'VBAK'.
    lr_header->refobjkey = lr_i_header->doc_number.
    lr_header->po_method = lr_i_header->po_method.
*              BOC KCHAKRABOR ERP-1888 2017-05-03

    READ TABLE fp_i_business REFERENCE INTO lr_i_business WITH KEY sd_doc     =   lr_i_header->doc_number
                                                                   itm_number =   lc_posnr_low.
    IF sy-subrc = 0.
      lr_header->price_grp  =  lr_i_business->price_grp.
*     Begin of ADD:ERP-5850:WROY:10-Jan-2018:ED2K910239
      lr_header->purch_no_c	 = lr_i_business->purch_no_c. "Customer purchase order number
      lr_headerx->purch_no_c = abap_true. "Customer purchase order number
*     End   of ADD:ERP-5850:WROY:10-Jan-2018:ED2K910239
    ENDIF. " IF sy-subrc = 0
*              EOC KCHAKRABOR ERP-1888 2017-05-03
* BOC - GKINTALI/NPALLA - INC0202201/E096 - 2018/08/27 - ED1K908289/ED2K912739
*    READ TABLE fp_i_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_header->doc_number.
* As per the incident: INC0202201, it is suggested to consider contract start and end dates of VEDA POSNR=000010
* only to determine requested delviery date and Valid From and Valid To dates and hence the logic is modified
* to read from the line item 0010.
* BOC - BTIRUVATHU - INC0246088  - 2019/06/12 - ED1K910931
*    READ TABLE fp_i_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_header->doc_number
*                                                                 itm_number = lc_posnr_10.
* EOC - GKINTALI/NPALLA - INC0202201/E096 - 2018/08/27 - ED1K908289/ED2K912739
* Internal table fp_i_contract is filled in the form f_process_data and will have
* only two entries. i.e Header and Subsequent Line item
* Calculation of the Contract dates will take priority of line item first and Header
* second and hence the internal f_process_data table is looped... If it has only header
* then contract dates would be calculated based on header and If it has item then contract dates
* would be calculated based on item.
    LOOP AT fp_i_contract REFERENCE INTO lr_contract.
    ENDLOOP.
    IF sy-subrc = 0.
* EOC - BTIRUVATHU - INC0246088  - 2018/06/12 - ED1K910931
      lr_header->qt_valid_f = lr_contract->contenddat + 1.
      lr_header->price_date = lr_header->qt_valid_f.

      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
        EXPORTING
          date      = lr_header->qt_valid_f
          days      = lc_days
          months    = lc_month
          years     = lc_year
        IMPORTING
          calc_date = lr_header->qt_valid_t.
      lr_header->qt_valid_t = lr_header->qt_valid_t - 1.
*     Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
      lr_sales_contract_inx->updateflag = lc_insert.
      lr_sales_contract_in->con_st_dat = lr_contract->contenddat + 1.
      lr_sales_contract_inx->con_st_dat = abap_true.

*Begin of Add-Anirban-10.09.2017-ED2K908905-Defect 4773
      lr_header->req_date_h = lr_sales_contract_in->con_st_dat.
      lr_headerx->req_date_h = abap_true.
*End of Add-Anirban-10.09.2017-ED2K908905-Defect 4773


      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
        EXPORTING
          date      = lr_sales_contract_in->con_st_dat
          days      = lc_days
          months    = lc_month
          years     = lc_year
        IMPORTING
          calc_date = lr_sales_contract_in->con_en_dat.
      lr_sales_contract_in->con_en_dat = lr_sales_contract_in->con_en_dat - 1.
      lr_sales_contract_inx->con_en_dat = abap_true.
      APPEND lr_sales_contract_in->* TO li_sales_contract_in.
      CLEAR lr_sales_contract_in->*.
      APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
      CLEAR lr_sales_contract_inx->*.
*     End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
    ENDIF. " IF sy-subrc = 0
    SELECT SINGLE taxk1 " Alternative tax classification
      FROM vbak         " Sales Document: Header Data
      INTO lr_header->alttax_cls
      WHERE vbeln = lr_header->ref_doc.

    SELECT SINGLE inco1 inco2
      FROM vbkd " Sales Document: Business Data
      INTO (lr_header->incoterms1, lr_header->incoterms2)
      WHERE vbeln = lr_header->ref_doc
      AND posnr = '00000'.
    lr_headerx->refdoc_cat = abap_true.
    lr_headerx->doc_type = abap_true.
    lr_headerx->sales_org = abap_true.
    lr_headerx->distr_chan = abap_true.
    lr_headerx->division = abap_true.
    lr_headerx->ref_doc = abap_true.
    lr_headerx->ref_1 = abap_true.
*   Begin of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    lr_headerx->currency  = abap_true.
*   End   of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    lr_headerx->updateflag = lc_insert.
    LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE customer IS NOT INITIAL AND itm_number = lc_posnr_low.

      lr_partner->partn_role = lr_i_partner->partn_role.
      lr_partner->partn_numb = lr_i_partner->customer.
      lr_partner->itm_number = lr_i_partner->itm_number.
      APPEND lr_partner->* TO li_partner.
      CLEAR lr_partner->*.
    ENDLOOP. " LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE customer IS NOT INITIAL AND itm_number = lc_posnr_low
    CREATE DATA lr_order_schedules_in.
    LOOP AT fp_i_item REFERENCE INTO lr_i_item.
*Begin of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
      IF lr_i_item->hg_lv_item NE lc_posnr_low.
        lr_item->itm_number = lr_i_item->hg_lv_item.
        lr_i_item->hg_lv_item = lc_posnr_low.
        lr_item->ref_1 = abap_true.
      ELSE. " ELSE -> IF lr_i_item->hg_lv_item NE lc_posnr_low
*End of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
        lr_item->itm_number = lr_i_item->itm_number.
*Begin of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
      ENDIF. " IF lr_i_item->hg_lv_item NE lc_posnr_low
*EOD ADD ANI

*      lr_item->price_grp  = lr_i_item->prc_group1.
*Begin of Del-Anirban-10.04.2017-ED2K908816-Defect 4753
*      lr_itemx->itm_number = lr_i_item->itm_number.
*End of Del-Anirban-10.04.2017-ED2K908816-Defect 4753
*Begin of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
      lr_itemx->itm_number = lr_item->itm_number.
*End of Add-Anirban-10.04.2017-ED2K908816-Defect 4753

*Begin of Del-Anirban-10.04.2017-ED2K908816-Defect 4753
*      lr_order_schedules_in->itm_number = lr_i_item->itm_number.
*End of Del-Anirban-10.04.2017-ED2K908816-Defect 4753
*Begin of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
      lr_order_schedules_in->itm_number = lr_item->itm_number.
*End of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
      lr_order_schedules_in->sched_line = '0001'.
      lr_order_schedules_in->req_qty = lr_i_item->target_qty.

*Begin of Del-Anirban-07.25.2017-ED2K907507-Defect 3528
*      lr_item->material =  lr_i_item->material.
*End of Del-Anirban-07.25.2017-ED2K907507-Defect 3528
*Begin of Add-Anirban-07.25.2017-ED2K907507-Defect 3528
*     Begin of DEL:ERP-6344:WROY:20-AUG-2018:ED2K913145
*     SELECT SINGLE smatn FROM kondd AS b INNER JOIN kotd001 AS a
*       ON a~knumh = b~knumh
*       WHERE a~kappl = @lc_kappl
*       AND a~matwa   = @lr_i_item->material
*       AND a~kschl   = @lc_kschl
*       AND ( datab LE @sy-datum AND datbi GE @sy-datum )
*       INTO @lv_smatn.
*     IF sy-subrc = 0.
*       lr_item->material = lv_smatn.
*     ELSE. " ELSE -> IF sy-subrc = 0
*     End   of DEL:ERP-6344:WROY:20-AUG-2018:ED2K913145
      lr_item->material = lr_i_item->material.
*     Begin of DEL:ERP-6344:WROY:20-AUG-2018:ED2K913145
*     ENDIF. " IF sy-subrc = 0
*     End   of DEL:ERP-6344:WROY:20-AUG-2018:ED2K913145
*End of Add-Anirban-07.25.2017-ED2K907507-Defect 3528

*     Begin of ADD:ERP-6343:WROY:20-AUG-2018:ED2K913145
      lr_item->cust_mat35 = lr_i_item->cust_mat35.
*     End   of ADD:ERP-6343:WROY:20-AUG-2018:ED2K913145
      lr_item->target_qty =  lr_i_item->target_qty .
      lr_item->target_qu = lr_i_item->target_qu.
*--*BOC OTCM-40816 ED2K922409 Prabhu 3/9/2021
*      lr_item->plant = lr_i_item->plant.
*--*EOC OTCM-40816 ED2K922409 Prabhu 3/9/2021
      lr_item->refobjkey = lr_header->ref_doc.
      lr_item->refobjtype =  'VBAK'.


      READ TABLE fp_i_business REFERENCE INTO lr_i_business WITH KEY itm_number = lr_i_item->itm_number.
      IF sy-subrc = 0.
        lr_item->po_method = lr_i_business->po_method.
*Begin of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
        IF lr_item->ref_1 = abap_true.
          CLEAR lr_item->ref_1.
        ELSE. " ELSE -> IF lr_item->ref_1 = abap_true
*End of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
          lr_item->ref_1 = lr_i_business->ref_1.
*Begin of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
        ENDIF. " IF lr_item->ref_1 = abap_true
*End of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
*              BOC KCHAKRABOR ERP-1888 2017-05-03
        lr_item->price_grp = lr_i_business->price_grp.
*              EOC KCHAKRABOR ERP-1888 2017-05-03
*       Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
        lr_item->cust_group = lr_i_business->cust_group. "Customer Group
*       End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
*       Begin of ADD:ERP-6344:WROY:20-AUG-2018:ED2K913145
        lr_item->cstcndgrp1 = lr_i_business->custcongr1.
        lr_item->cstcndgrp2 = lr_i_business->custcongr2.
        lr_item->cstcndgrp3 = lr_i_business->custcongr3.
        lr_item->cstcndgrp4 = lr_i_business->custcongr4.
        lr_item->cstcndgrp5 = lr_i_business->custcongr5.
*       End   of ADD:ERP-6344:WROY:20-AUG-2018:ED2K913145
**** Begin of adding by Lahiru on 07/09/2020 for ERPM-16504 with ED2K918829 ****
        lr_item->purch_no_c = lr_i_business->purch_no_c.      " Customer purchase order no
        "lr_itemx->purch_no_c = abap_true.
      ELSE.
        " Read Header level data if not found line item data
        READ TABLE fp_i_business REFERENCE INTO lr_i_business WITH KEY itm_number = lc_posnr_low.
        IF sy-subrc = 0.
          lr_item->purch_no_c = lr_i_business->purch_no_c.      " Customer purchase order no
        ENDIF.
**** End of adding by Lahiru on 07/09/2020 ERPM-16504 with ED2K918829 ****
      ENDIF. " IF sy-subrc = 0
*Begin of Del-Anirban-07.10.2017-ED2K907327-Defect 3068
*      READ TABLE fp_i_partner REFERENCE INTO lr_i_partner WITH KEY itm_number =    lr_i_item->itm_number.
*      IF sy-subrc = 0.
*        lr_partner->partn_role = lr_i_partner->partn_role.
*        lr_partner->partn_numb = lr_i_partner->customer.
*        lr_partner->itm_number = lr_i_partner->itm_number.
*        APPEND lr_partner->* TO li_partner.
*        CLEAR lr_partner->*.
*      ENDIF.
*End of Del-Anirban-07.10.2017-ED2K907327-Defect 3068

*Begin of Add-Anirban-07.10.2017-ED2K907327-Defect 3068
      LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE itm_number = lr_i_item->itm_number
                                                       OR itm_number = lc_posnr_low .
        lr_partner->partn_role = lr_i_partner->partn_role.
        IF NOT lr_i_partner->customer IS INITIAL.
          lr_partner->partn_numb = lr_i_partner->customer.
*Begin of Add-NPALLA-05.13.2019-ED1K909923-INC0241861
        ELSEIF NOT lr_i_partner->vendor_no IS INITIAL.
          lr_partner->partn_numb = lr_i_partner->vendor_no.
*End of Add-NPALLA-05.13.2019-ED1K909923-INC0241861
        ELSEIF NOT lr_i_partner->person_no IS INITIAL..
          lr_partner->partn_numb = lr_i_partner->person_no.
        ENDIF. " IF NOT lr_i_partner->customer IS INITIAL
        lr_partner->itm_number = lr_i_partner->itm_number.
        APPEND lr_partner->* TO li_partner.
        CLEAR lr_partner->*.
      ENDLOOP. " LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE itm_number = lr_i_item->itm_number
      SORT li_partner BY partn_role partn_numb.
      DELETE ADJACENT DUPLICATES FROM li_partner COMPARING partn_role partn_numb.
*End of Add-Anirban-07.10.2017-ED2K907327-Defect 3068


      IF NOT lr_i_item->ref_doc IS INITIAL.
        lr_item->ref_doc  =   lr_i_item->ref_doc.
      ENDIF. " IF NOT lr_i_item->ref_doc IS INITIAL
      lr_item->hg_lv_item = lr_i_item->hg_lv_item.
      IF NOT lr_i_item->itm_number IS INITIAL.
        lr_item->ref_doc_it = lr_i_item->itm_number.
      ENDIF. " IF NOT lr_i_item->itm_number IS INITIAL
*     Begin of DEL:ERP-5538:WROY:06-Dec-2017:ED2K909739
*     IF lr_i_item->doc_cat_sd IS NOT INITIAL.
*       lr_item->ref_doc_ca = lr_i_item->doc_cat_sd.
*     ELSE.
*       lr_item->ref_doc_ca = lc_contract.
*
*     ENDIF.
*     End   of DEL:ERP-5538:WROY:06-Dec-2017:ED2K909739
      lr_item->ref_doc_ca = lr_header->refdoc_cat.
*     Begin of ADD:ERP-5538:WROY:06-Dec-2017:ED2K909739
*     End   of ADD:ERP-5538:WROY:06-Dec-2017:ED2K909739
      lr_item->ref_doc = lr_header->ref_doc.
*     Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
      READ TABLE fp_i_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_item->doc_number
                                                                   itm_number = lr_i_item->itm_number.
      IF sy-subrc = 0.
        lr_sales_contract_inx->updateflag = lc_insert.
*Begin of Del-Anirban-10.04.2017-ED2K908816-Defect 4753
*        lr_sales_contract_in->itm_number = lr_i_item->itm_number.
*        lr_sales_contract_inx->itm_number = lr_i_item->itm_number.
*End of Del-Anirban-10.04.2017-ED2K908816-Defect 4753
*Begin of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
        lr_sales_contract_in->itm_number = lr_item->itm_number.
        lr_sales_contract_inx->itm_number = lr_item->itm_number.
*End of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
*---BOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
        lr_sales_contract_in->con_en_rul   = lr_contract->contendrul.
        FREE:lv_active_003_e096.
*----Below Enhancement Control - Active - new code and Deactive - old code will execute
        CALL FUNCTION 'ZCA_ENH_CONTROL'
          EXPORTING
            im_wricef_id   = lc_devid_e096
            im_ser_num     = lc_sno_e096_003
            im_var_key     = lc_key_003_e096
          IMPORTING
            ex_active_flag = lv_active_003_e096.
        IF lv_active_003_e096 = abap_true.
          IF lr_header->doc_type IN ir_auart.

            SELECT SINGLE auart FROM vbak INTO @DATA(lv_auart_ref) WHERE vbeln = @lr_item->refobjkey.
            FREE:lst_veda_kopf,lst_veda_pos,lv_venddat.
            lst_veda_kopf-vbegdat = lr_sales_contract_in->con_st_dat = lr_contract->contenddat + 1.
            lst_veda_kopf-vlaufz  = lr_sales_contract_in->val_per    = lr_contract->val_per.
            lst_veda_kopf-vlauez  = lr_sales_contract_in->val_per_un = lr_contract->valperunit.
            lst_veda_kopf-vlaufk  = lr_sales_contract_in->val_per_ca = lr_contract->valpercat.
            lst_veda_kopf-vendreg = lr_sales_contract_in->con_en_rul = lr_contract->contendrul.
            IF lv_auart_ref IN ir_auart_ck[].
              IF lr_header->doc_type IN ir_auart[].
                IF lr_item->cstcndgrp2 IN lr_kdkg2.
                  lst_veda_kopf-vlaufz = lr_sales_contract_in->val_per    = lc_period ."'001'.
                  lst_veda_kopf-vlaufk = lr_sales_contract_in->val_per_ca = lc_categry."'02'.
                ENDIF.
              ENDIF.
            ENDIF.
            MOVE-CORRESPONDING lst_veda_kopf TO lst_veda_pos.
            CALL FUNCTION 'SD_VEDA_GET_DATE'
              EXPORTING
                i_regel                    = lst_veda_pos-vendreg    "Date rule
                i_veda_kopf                = lst_veda_kopf          "Acceptance date
                i_veda_pos                 = lst_veda_pos           "Contract Start Date
              IMPORTING
                e_datum                    = lv_venddat             "Target date
              EXCEPTIONS
                basedate_and_cal_not_found = 1
                basedate_is_initial        = 2
                basedate_not_found         = 3
                cal_error                  = 4
                rule_not_found             = 5
                timeframe_not_found        = 6
                wrong_month_rule           = 7
                OTHERS                     = 8.
            IF sy-subrc EQ 0.
              lr_sales_contract_in->con_en_dat   = lv_venddat.                    "Contract End Date
            ENDIF.
            lr_sales_contract_inx->con_st_dat  = abap_true.
            lr_sales_contract_inx->con_en_dat  =  abap_true.
            lr_sales_contract_inx->con_en_rul  =  abap_true.
*          lr_sales_contract_inx->con_st_rul  =  abap_true.
            lr_sales_contract_inx->val_per     =  abap_true.
            lr_sales_contract_inx->val_per_un  =  abap_true.
            lr_sales_contract_inx->val_per_ca  =  abap_true.
            lr_item->price_date = lr_sales_contract_in->con_st_dat.
            lr_itemx->price_date = abap_true.
            lr_header->price_date = lst_veda_kopf-vbegdat.
          ELSE.
*---EOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
            lr_sales_contract_in->con_st_dat = lr_contract->contenddat + 1.
            lr_sales_contract_inx->con_st_dat = abap_true.
            lr_header->price_date = lr_sales_contract_in->con_st_dat.

            CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
              EXPORTING
                date      = lr_sales_contract_in->con_st_dat
                days      = lc_days
                months    = lc_month
                years     = lc_year
              IMPORTING
                calc_date = lr_sales_contract_in->con_en_dat.
            lr_sales_contract_in->con_en_dat = lr_sales_contract_in->con_en_dat - 1.
            lr_sales_contract_inx->con_en_dat = abap_true.
*----BOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
          ENDIF.
        ELSE." IF lv_active_003_e096 = abap_true.
          lr_sales_contract_in->con_st_dat = lr_contract->contenddat + 1.
          lr_sales_contract_inx->con_st_dat = abap_true.
          lr_header->price_date = lr_sales_contract_in->con_st_dat.

          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              date      = lr_sales_contract_in->con_st_dat
              days      = lc_days
              months    = lc_month
              years     = lc_year
            IMPORTING
              calc_date = lr_sales_contract_in->con_en_dat.
          lr_sales_contract_in->con_en_dat = lr_sales_contract_in->con_en_dat - 1.
          lr_sales_contract_inx->con_en_dat = abap_true.
        ENDIF. " IF lv_active_003_e096 = abap_true.
*----EOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
        APPEND lr_sales_contract_in->* TO li_sales_contract_in.
        CLEAR lr_sales_contract_in->*.
        APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
        CLEAR lr_sales_contract_inx->*.
      ENDIF. " IF sy-subrc = 0
*     End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489

*     BOC by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
      READ TABLE fp_i_ext_vbap REFERENCE INTO lr_ext_vbap WITH KEY vbeln = lr_i_item->doc_number
                                                                   posnr = lr_i_item->itm_number.
      IF sy-subrc = 0.
        lst_bape_vbap-vbeln         = lr_ext_vbap->vbeln.
        lst_bape_vbap-posnr         = lr_ext_vbap->posnr.
        lst_bape_vbap-zzsubtyp      = lr_ext_vbap->zzsubtyp.
        lst_extensionin-structure   = c_bape_vbap .
        lst_extensionin-valuepart1  = lst_bape_vbap.
        APPEND lst_extensionin TO li_extensionin.
        CLEAR  lst_extensionin.

        lst_bape_vbapx-vbeln        = lr_ext_vbap->vbeln.
        lst_bape_vbapx-posnr        = lr_ext_vbap->posnr.
        lst_bape_vbapx-zzsubtyp     = abap_true.
        lst_extensionin-structure  = c_bape_vbapx .
        lst_extensionin-valuepart1 = lst_bape_vbapx.
        APPEND lst_extensionin TO li_extensionin.
        CLEAR  lst_extensionin.
      ENDIF. " IF sy-subrc = 0
*     EOC by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603

      APPEND lr_item->* TO li_item.
      CLEAR lr_item->*.
      APPEND lr_order_schedules_in->* TO li_order_schedules_in.
      CLEAR  lr_order_schedules_in->*.
    ENDLOOP. " LOOP AT fp_i_item REFERENCE INTO lr_i_item
    lst_bapisdls-pricing = lc_b.

* BOC - GKINTALI - INC0202201 - 2018/08/27 - ED1K908393
* To update the order number in the message log for tracking purpose.
    IF sy-batch = abap_true.
      MESSAGE s006(zqtc_r2) WITH lr_header->ref_doc. " Order being processed : & .
    ENDIF. " IF sy-batch = abap_true
* EOC - GKINTALI - INC0202201 - 2018/08/27 - ED1K908393

* BOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739
*    v_msgv1 = lr_header->ref_doc.
*    PERFORM add_message_log USING 'S' 'ZQTC_R2' '006'
*                                  v_msgv1 space space space.
* EOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739

    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        sales_header_in       = lr_header->*
        int_number_assignment = abap_true
        logic_switch          = lst_bapisdls
        testrun               = fp_test
      IMPORTING
        salesdocument_ex      = fp_v_salesord
      TABLES
        return                = li_return
        sales_items_in        = li_item
        sales_partners        = li_partner
        sales_schedules_in    = li_order_schedules_in
*       Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
        sales_contract_in     = li_sales_contract_in
        sales_contract_inx    = li_sales_contract_inx
*       End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
*       BOC by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
        extensionin           = li_extensionin
        extensionex           = li_extensioninx
*       EOC by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
        textheaders_ex        = fp_i_textheaders
        textlines_ex          = fp_i_textlines.
*   BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
    LOOP AT li_return INTO st_return. "+ED2K912739
      PERFORM add_message_log USING st_return-type st_return-id st_return-number "+ED2K912739
                                    st_return-message_v1 st_return-message_v2    "+ED2K912739
                                    st_return-message_v3 st_return-message_v4.   "+ED2K912739
      CLEAR st_return.
    ENDLOOP. " LOOP AT li_return INTO st_return
*   EOC - NPALLA - E096 - 2018/08/27 - ED2K912739
    READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = 'E'.
    IF sy-subrc <> 0.
      IF  fp_test EQ space .
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
        fp_v_act_status = abap_true.
        CONCATENATE 'Quotation'(a10) fp_v_salesord 'created'(a11) INTO fp_message
        SEPARATED BY space.
      ELSE. " ELSE -> IF fp_test EQ space
*       Begin of ADD:SAP's Recommendations:WROY:01-Mar-2018:ED2K911135
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*       End   of ADD:SAP's Recommendations:WROY:01-Mar-2018:ED2K911135
        CONCATENATE 'Quotation'(a10) fp_v_salesord 'can be created'(x11) INTO fp_message
        SEPARATED BY space.
      ENDIF. " IF fp_test EQ space

    ELSE. " ELSE -> IF sy-subrc <> 0
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      APPEND LINES OF li_return TO fp_i_return.
      LOOP AT li_return REFERENCE INTO  lr_return WHERE type = 'E'.
        IF sy-tabix = 1.
          CONCATENATE 'Quotation failed'(a13) fp_message INTO fp_message.
        ELSE. " ELSE -> IF sy-tabix = 1
          CONCATENATE fp_message lr_return->message INTO fp_message SEPARATED BY space.
        ENDIF. " IF sy-tabix = 1

      ENDLOOP. " LOOP AT li_return REFERENCE INTO lr_return WHERE type = 'E'

    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_TRIGGER_OUTPUT_TYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  fp_i_constx : Constant table        text
*  -->  fp_i_partner: Partner table        text
* -->   fp_i_notif_prof: Notification profile
* <--  fp_lr_final : reference variable for renewal plan
*----------------------------------------------------------------------*
FORM f_trigger_output_type  USING
                                  fp_i_constx TYPE tt_const
                                  fp_i_partner TYPE  tt_partner
                                  fp_i_notif_prof TYPE tt_notif_p_det
                                  fp_nast TYPE tt_nast
                       CHANGING fp_lr_final TYPE ty_renwl_plan.

  DATA:
    li_vbfa     TYPE STANDARD TABLE OF vbfa INITIAL SIZE 0, " Sales Document Flow
    lv_reminder TYPE znotif_rem,                            " Notification/Reminder
*   Begin of ADD:ERP-7331:WROY:30-Mar-2018:ED2K911135
    lv_msg_text TYPE char100, " Message Text
*   End   of ADD:ERP-7331:WROY:30-Mar-2018:ED2K911135
    lr_partner  TYPE REF TO bapisdpart, " BAPI Structure of VBPA with English Field Names
    lr_vbfa     TYPE REF TO vbfa,       " reference variable Sales Document Flow
    lv_objkey   TYPE char30,            " Object key for nast
    lr_nast     TYPE REF TO nast,       "  class
    lw_t685b    TYPE t685b.             " Condition Types: Additional Data for Sending Output

  CONSTANTS: lc_v1            TYPE sna_kappl VALUE 'V1', " Application area
             lc_01            TYPE na_anzal VALUE '01',  " Number of message
*             lc_02            TYPE na_anzal VALUE '02',    " Dispatch time
             lc_proc_suc      TYPE na_vstat VALUE '0',     " sucessfully processed
             lc_quotation     TYPE vbfa-vbtyp_v VALUE 'B', " quotation
             lc_contract      TYPE vbfa-vbtyp_n VALUE 'G', " contract
             lc_ship_to_party TYPE parvw VALUE 'WE',       " ship-to-party
             lc_bill_to_party TYPE parvw VALUE 'RE',       " Bill-to-party
             lc_int           TYPE ad_comm VALUE 'INT',    " email
             lc_let           TYPE ad_comm VALUE 'LET'.    " print

  CALL FUNCTION 'READ_VBFA'
    EXPORTING
      i_vbelv         = fp_lr_final-vbeln
      i_posnv         = fp_lr_final-posnr
      i_vbtyp_v       = lc_contract
      i_vbtyp_n       = lc_quotation
    TABLES
      e_vbfa          = li_vbfa
    EXCEPTIONS
      no_record_found = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* No need to handle exceprtion
*--*BOC ERPM-15045 Prabhu 9/30/2020 ED2K919736
*--*If Quote is not found in VBFA then look for future Renewal ZSQT
*--*Which is created without reference
    CALL FUNCTION 'ZQTC_GET_FUTURE_REN_QUOTE_E095'
      EXPORTING
        im_vbeln = fp_lr_final-vbeln
        im_posnr = fp_lr_final-posnr
      TABLES
        ex_vbfa  = li_vbfa.
*--*EOC ERPM-15045 Prabhu 9/30/2020 ED2K919736
  ENDIF. " IF sy-subrc <> 0
*& Update Promo code in the Quotation
*  IF fp_lr_final-promo_code IS NOT INITIAL .
  PERFORM f_update_promo_code USING li_vbfa
                                    fp_i_notif_prof
                                    fp_lr_final .

*  ENDIF.

  CREATE DATA lr_nast.
  CLEAR lv_objkey.
  READ TABLE li_vbfa REFERENCE INTO lr_vbfa INDEX 1.
  IF sy-subrc = 0.
    lv_objkey  = lr_vbfa->vbeln. "object key. Po, shipment etc
  ENDIF. " IF sy-subrc = 0

  DATA : lv_comm   TYPE ad_comm,    " Communication Method (Key) (Business Address Services)
         lv_promo  TYPE zpromo,     " Promo code
         lv_adrnr  TYPE adrnr,      " Address
         lv_param2 TYPE rvari_vnam. " ABAP: Name of Variant Variable
  CLEAR: lv_comm, lv_promo, lv_adrnr, lv_param2.

*& If Output already triggered , then re triggered the same output
*Begin of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*  READ TABLE fp_nast REFERENCE INTO DATA(lr_i_nast) WITH TABLE KEY objkey COMPONENTS objky = lv_objkey.
*  IF sy-subrc = 0.
*    MOVE:lr_i_nast->parnr TO lr_nast->parnr,
*         lr_i_nast->parvw TO lr_nast->parvw,
*         lr_i_nast->objky TO lr_nast->objky,
*         sy-mandt         TO lr_nast->mandt,
*         lr_i_nast->kappl TO lr_nast->kappl,
*         lr_i_nast->kschl TO lr_nast->kschl,
*         lr_i_nast->spras TO lr_nast->spras,
*         sy-datum         TO lr_nast->erdat,
*         sy-uzeit         TO lr_nast->eruhr,
*         lr_i_nast->nacha TO lr_nast->nacha,
*         lc_01            TO lr_nast->anzal,
**         lr_i_nast->vsztp TO lr_nast->vsztp,
*         lc_01            TO lr_nast->vsztp,
*         fp_lr_final-eadat TO lr_nast->vsdat,
*         '000001'         TO lr_nast->vsura,
*         '235959'         TO lr_nast->vsurb,
*         lc_proc_suc      TO lr_nast->vstat.
*End of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
  IF lv_objkey IS NOT INITIAL.
*-----Get partner profile
*    lr_nast->parvw  = lc_ship_to_party. "WE           "partner function              "commneted as part of RITM0075120, rkumar2
    lr_nast->parvw  = lc_bill_to_party. "RE           "partner function              " added as part of RITM0075120, rkumar2
*-----Get partner # based on partner profile
*    READ TABLE fp_i_partner REFERENCE INTO lr_partner  WITH KEY partn_role = lc_ship_to_party." commneted as part of RITM0075120, rkumar2
    READ TABLE fp_i_partner REFERENCE INTO lr_partner  WITH KEY partn_role = lc_bill_to_party." added as part of RITM0075120, rkumar2
    IF sy-subrc = 0.
      lr_nast->parnr  = lr_partner->customer. "'0040126506'."message partner
*-----Get address # for the customer to get the to get the default communication method
      SELECT SINGLE adrnr FROM kna1 INTO lv_adrnr WHERE kunnr = lr_nast->parnr.
      IF sy-subrc = 0.
*-----Get communication method
        SELECT SINGLE deflt_comm FROM adrc INTO lv_comm WHERE addrnumber = lv_adrnr.
*-----if INT (email) = communication method 5 / LET (print) = communication method 1
        IF sy-subrc = 0.
* BOC comment by PBANDLAPAL on 26-Feb-2018 : ED2K911071
*          IF lv_comm = lc_int.
*            lr_nast->nacha = 5.
*          ELSEIF lv_comm = lc_let.
*            lr_nast->nacha = 1.
*          ENDIF.
* EOC comment by PBANDLAPAL on 26-Feb-2018 : ED2K911071
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF sy-subrc = 0

    ENDIF. " IF sy-subrc = 0

    lr_nast->mandt  = sy-mandt.
    lr_nast->kappl  = lc_v1. "Application area
    READ TABLE li_vbfa REFERENCE INTO lr_vbfa INDEX 1.
    IF sy-subrc = 0.
      lr_nast->objky  = lr_vbfa->vbeln. "object key. Po, shipment etc
      SELECT SINGLE zzpromo INTO lv_promo FROM vbak WHERE vbeln = lr_nast->objky.
    ENDIF. " IF sy-subrc = 0

    CLEAR lv_reminder.
    lv_reminder =  fp_lr_final-activity.
    READ TABLE fp_i_notif_prof ASSIGNING FIELD-SYMBOL(<lst_notif_prof>) WITH KEY renwl_prof = fp_lr_final-renwl_prof
                                                                                 notif_rem  = lv_reminder.
    IF sy-subrc = 0.
*Commented by MODUTTA on 05/12/2017 for JIRA Defcet# ERP1865
**-----Get combincation of promo and default communication method to get the o/p code
*      CONCATENATE lv_promo+0(5) lv_comm INTO lv_param2 SEPARATED BY c_sep.
*
*      READ TABLE fp_i_constx ASSIGNING FIELD-SYMBOL(<lst_constx_e095>) WITH KEY param1 = <lst_notif_prof>-notif_prof
*                                                                                param2 = lv_param2.
*      IF sy-subrc = 0.
*        lr_nast->kschl  = <lst_constx_e095>-low. "'ZOA2'.       "output type to be processed
*      ENDIF.
*    ENDIF.
*End of comment by MODUTTA

*<<<<<<<<<<<<<<<<<<BOC by MODUTTA on 05/12/2017 for Defect# ERp 1865>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*To get records from ZQTC_NOTIF_OUTPT table
      IF lv_promo IS NOT INITIAL.
        DATA(lv_promo_flag) = abap_true.
      ENDIF. " IF lv_promo IS NOT INITIAL

      SELECT SINGLE output_type " Output Type
        FROM zqtc_notif_outpt   " E095: Notification Output Type Table
        INTO @DATA(lv_output_type)
        WHERE notif_prof = @<lst_notif_prof>-notif_prof
        AND   promo = @lv_promo_flag
        AND   comm_method = @lv_comm.
      IF sy-subrc EQ 0.
        lr_nast->kschl  = lv_output_type.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc = 0
*<<<<<<<<<<<<<<<<<<EOC by MODUTTA on 05/12/2017 for Defect# ERp 1865>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

*-----Get data from config
    SELECT SINGLE * FROM t685b INTO lw_t685b WHERE kschl = lr_nast->kschl
                                             AND   kappl = lc_v1.
    IF sy-subrc = 0.
      lr_nast->spras = sy-langu. "language
      lr_nast->tcode = lw_t685b-strategy. "Comm strategy
* BOI by PBANDLAPAL on 26-Feb-2018 : ED2K911071
      lr_nast->nacha = lw_t685b-nacha. "Message transmission medium
* EOI by PBANDLAPAL on 26-Feb-2018 : ED2K911071
    ENDIF. " IF sy-subrc = 0
    lr_nast->spras  = sy-langu. "language
    lr_nast->erdat  = sy-datum. "current date
    lr_nast->eruhr  = sy-uzeit. "current time
    lr_nast->usnam  = sy-uname. "User name
    lr_nast->ldest  = 'LP01'. "Print destination

*    lr_nast->nacha  = 1.                 "message transmission medium
    lr_nast->anzal  = lc_01. "number of messages
*    lr_nast->vsztp  = sy-uzeit.         "Dispatch time
    lr_nast->vstat  = lc_proc_suc. "processing status

    lr_nast->vsdat  = fp_lr_final-eadat. "Requested date for sending message
    lr_nast->vsura  = '000001'. "Requested time for sending message (from)
    lr_nast->vsurb  = '235959'. "Requested time for sending message (to)
    lr_nast->vsztp  = lc_01. "Dispatch time

  ENDIF. " IF lv_objkey IS NOT INITIAL
  IF p_test EQ space AND lv_objkey IS NOT INITIAL AND  lr_nast->nacha IS NOT INITIAL AND lr_nast->kschl IS NOT INITIAL.
    CALL FUNCTION 'RV_MESSAGE_UPDATE_SINGLE'
      EXPORTING
        msg_nast = lr_nast->*.
    COMMIT WORK AND WAIT.
    IF fp_lr_final-act_status <> abap_true .
      fp_lr_final-act_status = abap_true.
    ENDIF. " IF fp_lr_final-act_status <> abap_true
*   Begin of ADD:ERP-7331:WROY:30-Mar-2018:ED2K911135
    CONCATENATE 'Output Type'(t35) lr_nast->kschl 'is added'(t37) INTO lv_msg_text SEPARATED BY space.
    IF fp_lr_final-message IS INITIAL.
      fp_lr_final-message = lv_msg_text.
    ELSE. " ELSE -> IF fp_lr_final-message IS INITIAL
      CONCATENATE lv_msg_text fp_lr_final-message INTO fp_lr_final-message SEPARATED BY '/'.
    ENDIF. " IF fp_lr_final-message IS INITIAL
*   End   of ADD:ERP-7331:WROY:30-Mar-2018:ED2K911135
  ELSEIF lv_objkey IS INITIAL .
    CONCATENATE 'Quotation not found'(t32)  fp_lr_final-message INTO fp_lr_final-message.
  ELSEIF lr_nast->nacha IS INITIAL.
*-----display massage when no communication method is found
    CONCATENATE 'Default comm startegy missing in customer master'(t33)  fp_lr_final-message INTO fp_lr_final-message.
  ELSEIF lr_nast->kschl IS INITIAL.
*-----display massage when no communication method is found
    CONCATENATE 'Maintain entry in the notification profile output type table'(t34)  fp_lr_final-message INTO fp_lr_final-message SEPARATED BY '/'.
* Begin of ADD:ERP-7331:WROY:30-Mar-2018:ED2K911135
  ELSEIF p_test IS NOT INITIAL.
    CONCATENATE 'Output Type'(t35) lr_nast->kschl 'can be added'(t36) INTO lv_msg_text SEPARATED BY space.
    IF fp_lr_final-message IS INITIAL.
      fp_lr_final-message = lv_msg_text.
    ELSE. " ELSE -> IF fp_lr_final-message IS INITIAL
      CONCATENATE lv_msg_text fp_lr_final-message INTO fp_lr_final-message SEPARATED BY '/'.
    ENDIF. " IF fp_lr_final-message IS INITIAL
* End   of ADD:ERP-7331:WROY:30-Mar-2018:ED2K911135
  ENDIF. " IF p_test EQ space AND lv_objkey IS NOT INITIAL AND lr_nast->nacha IS NOT INITIAL AND lr_nast->kschl IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_ACTIVITY
*&---------------------------------------------------------------------*
*       Populate Activity
*----------------------------------------------------------------------*
*  <--  fp_i_activity : Activity Table
*  <--  fp_i_lis      : Value Request Manager
*----------------------------------------------------------------------*
FORM f_fetch_activity  CHANGING fp_i_activity TYPE tt_activity
                                fp_i_list TYPE vrm_values.
  DATA: lr_list     TYPE REF TO  vrm_value,  " Value Request Manager
        lv_text     TYPE char80,             " Text field
        lr_activity TYPE REF TO ty_activity. " Reference Variable
  CONSTANTS: lc_all      TYPE char3 VALUE 'ALL',       " ALL Activity
             lc_activity TYPE  vrm_id VALUE 'P_ACTIV'. " Activity Parameter
  CREATE DATA lr_list.
  SELECT activity      " E095: Activity
        spras          " Language Key
        activity_d     " Description
   FROM zqtct_activity " E095: Activity Text Table
   INTO TABLE fp_i_activity
   WHERE
   spras = sy-langu.
  IF sy-subrc = 0.
    LOOP AT fp_i_activity REFERENCE INTO lr_activity.
      lr_list->key = lr_activity->activity.
      CONCATENATE lr_activity->activity
                  lr_activity->activity_d INTO lv_text SEPARATED BY space.
      lr_list->text = lv_text.
      APPEND lr_list->* TO fp_i_list.
      CLEAR lr_list->*.

    ENDLOOP. " LOOP AT fp_i_activity REFERENCE INTO lr_activity
*& Populate ALL Activty type
    lr_list->key = lc_all.
    lr_list->text = 'All Activity'(t01).
    APPEND lr_list->* TO fp_i_list.
    CLEAR lr_list->*.
  ENDIF. " IF sy-subrc = 0
*& Set values for drop down list
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = lc_activity
      values          = fp_i_list
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
*& do nothing
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_PROF
*&---------------------------------------------------------------------*
*      Fetch renewal Prfole details
*----------------------------------------------------------------------*
*      <--fP_I_RENWL_PROF  : Renewakl Profile
*      <--FP_I_LIST_RENWL  : VRM values
*----------------------------------------------------------------------*
FORM f_fetch_prof  CHANGING fp_i_renwl_prof TYPE tt_renwl_prof
                            fp_i_list_renwl TYPE vrm_values.
  DATA: lv_text       TYPE char80,               " Text
        lr_list       TYPE REF TO  vrm_value,    " VRM value
        lr_renwl_prof TYPE REF TO ty_renwl_prof. " Reference variable
  CONSTANTS: lc_all     TYPE char3 VALUE 'ALL',     " ALL activity
             lc_profile TYPE vrm_id VALUE 'P_PROF'. " VRM ID
  CREATE DATA lr_list.
  SELECT renwl_prof        " Renewal Profile
          spras            " Language Key
          renwl_prof_d     " Description
     FROM zqtct_renwl_prof " E095: Renewal Profile Table
     INTO TABLE fp_i_renwl_prof
     WHERE
     spras = sy-langu.
  IF sy-subrc = 0.
    LOOP AT fp_i_renwl_prof REFERENCE INTO lr_renwl_prof.
      lr_list->key = lr_renwl_prof->renwl_prof.
      CONCATENATE lr_renwl_prof->renwl_prof
                  lr_renwl_prof->renwl_prof_d INTO lv_text SEPARATED BY space.
      lr_list->text = lv_text.
      APPEND lr_list->* TO fp_i_list_renwl.
      CLEAR lr_list->*.

    ENDLOOP. " LOOP AT fp_i_renwl_prof REFERENCE INTO lr_renwl_prof
    lr_list->key = lc_all.
    lr_list->text = 'All profile'(t02).
    APPEND lr_list->* TO fp_i_list_renwl.
    CLEAR lr_list->*.
  ENDIF. " IF sy-subrc = 0
*& call function module Value Request Manager
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = lc_profile "'P_PROF'
      values          = fp_i_list_renwl
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
*& do nothing
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_RENWAL_DETER
*&---------------------------------------------------------------------*
*      Fetch activity and renewal profile
*----------------------------------------------------------------------*
*      -->FP_P_ACTIV  : ACTIVITY
*      -->FP_P_PROF   " Renewal Profile
*      <--FP_I_RENWL_PLAN  :final table
*      <--fp_rewal_plan    : Renwal Plan tanble
*----------------------------------------------------------------------*
FORM f_fetch_renwal_deter  USING    fp_p_activ TYPE zactivity_sub " E095: Activity
                                    fp_p_prof  TYPE zrenwl_prof   " Renewal Profile
                           CHANGING fp_i_renwl_plan TYPE tt_final
                                    fp_rewal_plan   TYPE tt_renwl_plan.
  TYPES: BEGIN OF lty_activity,
           sign(1)   TYPE c,             " Sign(1) of type Character
           option(2) TYPE c,             " Option(2) of type Character
           low       TYPE zactivity_sub, " E095: Activity
           high      TYPE zactivity_sub, " E095: Activity
         END OF lty_activity,

         BEGIN OF lty_renwl_prof,
           sign(1)   TYPE c,             " Sign(1) of type Character
           option(2) TYPE c,             " Option(2) of type Character
           low       TYPE zrenwl_prof,   " Renewal Profile
           high      TYPE zrenwl_prof,   " Renewal Profile
         END OF lty_renwl_prof.

  DATA: li_renwl_plan  TYPE STANDARD TABLE OF zqtc_renwl_plan INITIAL SIZE 0 " Internal table
        WITH NON-UNIQUE SORTED KEY sort_key COMPONENTS vbeln posnr  ,

        lir_activ      TYPE RANGE OF  zactivity_sub INITIAL SIZE 0,          " Range table
        lr_activ       TYPE REF TO lty_activity,                             " Reference table for activity
        lir_renwl_prof TYPE RANGE OF  zrenwl_prof INITIAL SIZE 0,            " Range table
        lr_renwl_prof  TYPE REF TO lty_renwl_prof,                           " Reference table
        lr_final       TYPE REF TO ty_renwl_plan,                            " Reference table for final
        lr_renwl_plan  TYPE REF TO zqtc_renwl_plan.                          " Renwl_plan class

  CONSTANTS: lc_all     TYPE char3 VALUE 'ALL', " ALL
             lc_*       TYPE char1 VALUE '*',   " * of type CHAR1
             lc_include TYPE char1 VALUE 'I',   " Insert
             lc_pattern TYPE char2 VALUE 'CP',  " Compare
             lc_equal   TYPE char2 VALUE 'EQ',  " Equal of type CHAR2
             lc_abort   TYPE char1 VALUE 'A',   " Message Type: Abort
             lc_error   TYPE char1 VALUE 'E'.   " Message Type: Error

  CREATE DATA: lr_activ,
               lr_renwl_plan,
               lr_renwl_prof.

  lr_activ->sign = lc_include.
  lr_renwl_prof->sign = lc_include.
  IF fp_p_activ = lc_all.
    lr_activ->option = lc_pattern.
    lr_activ->low = lc_*.
  ELSE. " ELSE -> IF fp_p_activ = lc_all
    lr_activ->option = lc_equal.
    lr_activ->low = fp_p_activ.

  ENDIF. " IF fp_p_activ = lc_all
  APPEND lr_activ->* TO lir_activ.

  IF fp_p_prof = lc_all.
    lr_renwl_prof->option = lc_pattern.
    lr_renwl_prof->low = lc_*.
  ELSE. " ELSE -> IF fp_p_prof = lc_all
    lr_renwl_prof->option = lc_equal.
    lr_renwl_prof->low = fp_p_prof.
  ENDIF. " IF fp_p_prof = lc_all

  APPEND lr_renwl_prof->* TO lir_renwl_prof.

*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
  IF sy-batch EQ abap_false.
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*** BOC: DM-1923  KKRAVURI20190606  ED2K915200
    IF p_chck = abap_true.
      SELECT zqtc_renwl_plan~mandt " Client
       zqtc_renwl_plan~vbeln " Sales Document
       zqtc_renwl_plan~posnr " Item
       activity " E095: Activity
       zqtc_renwl_plan~matnr " Material no
       eadat      " Activity Date
       renwl_prof " Renewal Profile
       promo_code " Promo code
       act_status " Activity Status
       ren_status " Renewal Status
       excl_resn " Exclusion reason
       excl_date " Exclusion date
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
       excl_resn2 "Exclusion reason 2
       excl_date2 "Exclusion reason date 2
       other_cmnts " Other comments
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
       aenam " Name of Person Who Changed Object
       zqtc_renwl_plan~aedat " Changed On
       aezet " Time last change was made
       zqtc_renwl_plan~log_type    " Message Type
       zqtc_renwl_plan~lognumber   " Log Number
       zqtc_renwl_plan~test_run    " Test Run
       zqtc_renwl_plan~review_stat " Review Status
       zqtc_renwl_plan~comments    " Review Comments
       zqtc_renwl_plan~jobname     " Job Name
       zqtc_renwl_plan~job_date    " Job date
       zqtc_renwl_plan~job_time    " Job time
       FROM zqtc_renwl_plan " E095: Renewal Plan Table
       INNER JOIN vbak ON vbak~vbeln EQ zqtc_renwl_plan~vbeln
       INNER JOIN vbap ON vbap~vbeln EQ zqtc_renwl_plan~vbeln
                      AND vbap~posnr EQ zqtc_renwl_plan~posnr
       INTO TABLE li_renwl_plan
       WHERE zqtc_renwl_plan~vbeln IN s_vbeln
       AND activity IN lir_activ
       AND renwl_prof IN lir_renwl_prof
       AND ren_status = abap_false
       AND vbap~matnr IN s_matnr
       AND vbap~mvgr5 IN s_mvgr5
       AND eadat IN s_eadat
       AND vkorg IN s_vkorg
* Begin by AMOHAMMED on 10/14/2020 TR # ED2K919919
* Eliminate the rejected line items
       AND vbap~abgru EQ space.
* End by AMOHAMMED on 10/14/2020 TR # ED2K919919
    ELSE. " ELSE -> IF p_chck = abap_true.
*** EOC: DM-1923  KKRAVURI20190606  ED2K915200
*   Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*   SELECT mandt   " Client
*          vbeln          " Sales Document
*   End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*   Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
      SELECT zqtc_renwl_plan~mandt " Client
             zqtc_renwl_plan~vbeln " Sales Document
*   End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of DEL:ERP-6347:WROY:19-JUN-2018:ED2K912349
*          posnr          " Item
*          End   of DEL:ERP-6347:WROY:19-JUN-2018:ED2K912349
*          Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             zqtc_renwl_plan~posnr " Item
*          End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             activity " E095: Activity
*Begin of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
*          Begin of DEL:ERP-6347:WROY:19-JUN-2018:ED2K912349
*          matnr          " Material no
*          End   of DEL:ERP-6347:WROY:19-JUN-2018:ED2K912349
*          Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             zqtc_renwl_plan~matnr " Material no
*          End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*End of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
             eadat      " Activity Date
             renwl_prof " Renewal Profile
             promo_code " Promo code
             act_status " Activity Status
             ren_status " Renewal Status
*          Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             excl_resn " Exclusion reason
             excl_date " Exclusion date
*          End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
             excl_resn2 "Exclusion reason 2
             excl_date2 " Exclusion reason date 2
             other_cmnts " Other comments
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
             aenam " Name of Person Who Changed Object
*          Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          aedat          " Changed On
*          End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
             zqtc_renwl_plan~aedat " Changed On
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
             aezet " Time last change was made
*          BOC - NPALLA - E096 - 2018/08/31 - ED2K912739
             zqtc_renwl_plan~log_type    " Message Type
             zqtc_renwl_plan~lognumber   " Log Number
             zqtc_renwl_plan~test_run    " Test Run
             zqtc_renwl_plan~review_stat " Review Status
             zqtc_renwl_plan~comments    " Review Comments
*          EOC - NPALLA - E096 - 2018/08/31 - ED2K912739
*** Begin of: KKRAVURI  KKR20180911  CR# 6295
             zqtc_renwl_plan~jobname
             zqtc_renwl_plan~job_date
             zqtc_renwl_plan~job_time
*** End of: KKRAVURI  KKR20180911  CR# 6295
             FROM zqtc_renwl_plan " E095: Renewal Plan Table
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
             INNER JOIN vbak ON vbak~vbeln EQ zqtc_renwl_plan~vbeln
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             INNER JOIN vbap ON vbap~vbeln EQ zqtc_renwl_plan~vbeln
                            AND vbap~posnr EQ zqtc_renwl_plan~posnr
*          End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             INTO TABLE li_renwl_plan
*          Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          WHERE vbeln IN s_vbeln
*          End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
             WHERE zqtc_renwl_plan~vbeln IN s_vbeln
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
             AND activity IN lir_activ
             AND renwl_prof IN lir_renwl_prof
*          Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             AND vbap~matnr IN s_matnr
             AND vbap~mvgr5 IN s_mvgr5
*          End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
             AND eadat IN s_eadat
             AND vkorg IN s_vkorg
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
* Begin by AMOHAMMED on 10/14/2020 TR # ED2K919919
* Eliminate the rejected line items
       AND vbap~abgru EQ space.
* End by AMOHAMMED on 10/14/2020 TR # ED2K919919
*          Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          ORDER BY PRIMARY KEY.
*          End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
    ENDIF. " IF p_chck = abap_true.
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
  ELSE. " ELSE -> IF sy-batch EQ abap_false
*** BOC: DM-1923  KKRAVURI20190606  ED2K915200
    IF p_chck = abap_true.
      SELECT zqtc_renwl_plan~mandt " Client
             zqtc_renwl_plan~vbeln " Sales Document
             zqtc_renwl_plan~posnr " Item
             activity " E095: Activity
             zqtc_renwl_plan~matnr " Material no
             eadat      " Activity Date
             renwl_prof " Renewal Profile
             promo_code " Promo code
             act_status " Activity Status
             ren_status " Renewal Status
             excl_resn " Exclusion_reason
             excl_date " Exclusion date
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
             excl_resn2 " Exclusion reason 2
             excl_date2 " Exclusion reason date 2
             other_cmnts " Other comments
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
             aenam " Name of Person Who Changed Object
             zqtc_renwl_plan~aedat " Changed On
             aezet " Time last change was made
             zqtc_renwl_plan~log_type    " Message Type
             zqtc_renwl_plan~lognumber   " Log Number
             zqtc_renwl_plan~test_run    " Test Run
             zqtc_renwl_plan~review_stat " Review Status
             zqtc_renwl_plan~comments    " Review Comments
             FROM zqtc_renwl_plan " E095: Renewal Plan Table
             INNER JOIN vbak ON vbak~vbeln EQ zqtc_renwl_plan~vbeln
             INNER JOIN vbap ON vbap~vbeln EQ zqtc_renwl_plan~vbeln
                            AND vbap~posnr EQ zqtc_renwl_plan~posnr
             INTO TABLE li_renwl_plan
             WHERE zqtc_renwl_plan~vbeln IN s_vbeln
             AND activity IN lir_activ
             AND renwl_prof IN lir_renwl_prof
             AND ren_status = abap_false
             AND vbap~matnr IN s_matnr
             AND vbap~mvgr5 IN s_mvgr5
             AND eadat IN s_eadat
             AND vkorg IN s_vkorg
             AND act_status NE abap_true
* Begin by AMOHAMMED on 10/14/2020 TR # ED2K919919
* Eliminate the rejected line items
       AND vbap~abgru EQ space.
* End by AMOHAMMED on 10/14/2020 TR # ED2K919919
    ELSE. " ELSE -> IF p_chck = abap_true.
*** EOC: DM-1923  KKRAVURI20190606  ED2K915200
*   Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*   SELECT mandt   " Client
*          vbeln          " Sales Document
*   End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*   Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
      SELECT zqtc_renwl_plan~mandt " Client
             zqtc_renwl_plan~vbeln " Sales Document
*   End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of DEL:ERP-6347:WROY:19-JUN-2018:ED2K912349
*          posnr          " Item
*          End   of DEL:ERP-6347:WROY:19-JUN-2018:ED2K912349
*          Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             zqtc_renwl_plan~posnr " Item
*          End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             activity " E095: Activity
*Begin of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
*          Begin of DEL:ERP-6347:WROY:19-JUN-2018:ED2K912349
*          matnr          " Material no
*          End   of DEL:ERP-6347:WROY:19-JUN-2018:ED2K912349
*          Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             zqtc_renwl_plan~matnr " Material no
*          End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*End of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
             eadat      " Activity Date
             renwl_prof " Renewal Profile
             promo_code " Promo code
             act_status " Activity Status
             ren_status " Renewal Status
*          Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             excl_resn " Exclusion_reason
             excl_date " Exclusion date
*          End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
             excl_resn2  " Exclusion reason 2
             excl_date2  " Exclusion reason date 2
             other_cmnts " Other comments
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
             aenam " Name of Person Who Changed Object
*          Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          aedat          " Changed On
*          End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
             zqtc_renwl_plan~aedat " Changed On
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
             aezet " Time last change was made
*          BOC - NPALLA - E096 - 2018/08/31 - ED2K912739
             zqtc_renwl_plan~log_type    " Message Type
             zqtc_renwl_plan~lognumber   " Log Number
             zqtc_renwl_plan~test_run    " Test Run
             zqtc_renwl_plan~review_stat " Review Status
             zqtc_renwl_plan~comments    " Review Comments
*          EOC - NPALLA - E096 - 2018/08/31 - ED2K912739
             FROM zqtc_renwl_plan " E095: Renewal Plan Table
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
             INNER JOIN vbak ON vbak~vbeln EQ zqtc_renwl_plan~vbeln
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             INNER JOIN vbap ON vbap~vbeln EQ zqtc_renwl_plan~vbeln
                            AND vbap~posnr EQ zqtc_renwl_plan~posnr
*          End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             INTO TABLE li_renwl_plan
*          Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          WHERE vbeln IN s_vbeln
*          End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
             WHERE zqtc_renwl_plan~vbeln IN s_vbeln
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
             AND activity IN lir_activ
             AND renwl_prof IN lir_renwl_prof
*          Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             AND vbap~matnr IN s_matnr
             AND vbap~mvgr5 IN s_mvgr5
*          End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*          Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          AND eadat LE s_eadat-low
*          End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
             AND eadat IN s_eadat
             AND vkorg IN s_vkorg
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
             AND act_status NE abap_true
* Begin by AMOHAMMED on 10/14/2020 TR # ED2K919919
* Eliminate the rejected line items
       AND vbap~abgru EQ space.
* End by AMOHAMMED on 10/14/2020 TR # ED2K919919
*          Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          ORDER BY PRIMARY KEY.
*          End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
    ENDIF. " IF p_chck = abap_true.
  ENDIF. " IF sy-batch EQ abap_false

  IF NOT li_renwl_plan IS INITIAL.
    "Delete records where activity date ios initial.
*** Begin of: KKRAVURI  KKR20180912  CR# 6295
    IF sy-batch = abap_true.
      DELETE li_renwl_plan WHERE log_type = lc_error AND review_stat = abap_false.
      DELETE li_renwl_plan WHERE log_type = lc_abort AND review_stat = abap_false.
    ENDIF.
*** End of: KKRAVURI  KKR20180912  CR# 6295

    DELETE li_renwl_plan WHERE eadat IS INITIAL.
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*   Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
    SORT li_renwl_plan BY vbeln posnr activity.
*   End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691

*   Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*   Consider only Excluded Items
    IF p_excld IS NOT INITIAL.
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
*--*Consider exclusion reason 2 for the output to filter selection screen values
      DATA(li_renwl_plan_tmp) = li_renwl_plan.
      DELETE li_renwl_plan_tmp WHERE excl_resn2 IS INITIAL.
      DELETE li_renwl_plan WHERE excl_resn IS INITIAL.
      APPEND LINES OF li_renwl_plan_tmp TO li_renwl_plan.
*     Filter for specific Exclusion Reason
      IF s_excld[] IS NOT INITIAL.
        DATA(li_renwl_tmp) = li_renwl_plan.
        DELETE li_renwl_tmp WHERE  excl_resn2 NOT IN s_excld[].
        DELETE li_renwl_plan WHERE  excl_resn NOT IN s_excld[].
        APPEND LINES OF li_renwl_tmp TO li_renwl_plan.
      ENDIF. " IF s_excld[] IS NOT INITIAL
      SORT li_renwl_plan BY  mandt vbeln posnr activity.
      DELETE ADJACENT DUPLICATES FROM li_renwl_plan  COMPARING mandt vbeln posnr activity.
    ENDIF. " IF p_excld IS NOT INITIAL
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
*   Filter based on Customer condition group 2
    IF s_kdkg2[] IS NOT INITIAL AND
       li_renwl_plan IS NOT INITIAL.
*     Fetch Sales Document: Business Data
      SELECT vbeln, "Sales and Distribution Document Number
             posnr, "Item number of the SD document
             kdkg2  "Customer condition group 2
        FROM vbkd   " Sales Document: Business Data
        INTO TABLE @DATA(li_vbkd)
         FOR ALL ENTRIES IN @li_renwl_plan
       WHERE vbeln   EQ @li_renwl_plan-vbeln
         AND ( posnr EQ @li_renwl_plan-posnr
          OR   posnr EQ @c_posnr_low )
       ORDER BY PRIMARY KEY.
      IF sy-subrc NE 0.
        CLEAR: li_vbkd.
      ENDIF. " IF sy-subrc NE 0
    ENDIF. " IF s_kdkg2[] IS NOT INITIAL AND

*   Exclusion Reasons for Renewal Plan Entries (Texts)
    SELECT excl_resn       "Exclusion Reason
           excl_resn_d     "Exclusion Reason Description
      FROM zqtct_excl_resn " E095: Exclusion Reasons for Renewal Plan Entries (Texts)
      INTO TABLE i_excl_resn
     WHERE spras EQ sy-langu.
    IF sy-subrc EQ 0.
      SORT i_excl_resn BY excl_resn.
    ENDIF. " IF sy-subrc EQ 0
*   End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*Begin of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*  IF sy-subrc = 0.
*End of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
    CREATE DATA lr_final.

    LOOP AT li_renwl_plan REFERENCE INTO lr_renwl_plan.
*     Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*     Filter based on Customer condition group 2
      IF s_kdkg2[] IS NOT INITIAL.
*       Check for specific Line Item
        READ TABLE li_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd>)
             WITH KEY vbeln = lr_renwl_plan->vbeln
                      posnr = lr_renwl_plan->posnr
             BINARY SEARCH.
        IF sy-subrc NE 0.
*         Check for Header
          READ TABLE li_vbkd ASSIGNING <lst_vbkd>
             WITH KEY vbeln = lr_renwl_plan->vbeln
                      posnr = c_posnr_low
             BINARY SEARCH.
        ENDIF. " IF sy-subrc NE 0
        IF sy-subrc EQ 0.
          IF <lst_vbkd>-kdkg2 NOT IN s_kdkg2. "Validate Customer condition group 2
            CLEAR: lr_renwl_plan->vbeln,
                   lr_renwl_plan->posnr.
            CONTINUE.
          ENDIF. " IF <lst_vbkd>-kdkg2 NOT IN s_kdkg2
        ELSE. " ELSE -> IF sy-subrc EQ 0
          CLEAR: lr_renwl_plan->vbeln,
                 lr_renwl_plan->posnr.
          CONTINUE.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF s_kdkg2[] IS NOT INITIAL
*     End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
      MOVE-CORRESPONDING lr_renwl_plan->* TO lr_final->*.
*     Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
      READ TABLE i_excl_resn ASSIGNING FIELD-SYMBOL(<lst_excl_resn>)
           WITH KEY excl_resn = lr_final->excl_resn
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lr_final->excl_resn_d = <lst_excl_resn>-excl_resn_d.
      ENDIF. " IF sy-subrc EQ 0
*     End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
*--* Add description for Exclusion reason 2
      READ TABLE i_excl_resn ASSIGNING FIELD-SYMBOL(<lst_excl_resn2>)
            WITH KEY excl_resn = lr_final->excl_resn2.
      IF sy-subrc EQ 0.
        lr_final->excl_resn_d2 = <lst_excl_resn2>-excl_resn_d.
      ENDIF.
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
      APPEND lr_final->* TO fp_i_renwl_plan.
      CLEAR lr_final->*.
    ENDLOOP. " LOOP AT li_renwl_plan REFERENCE INTO lr_renwl_plan
*   Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
    DELETE li_renwl_plan WHERE vbeln IS INITIAL
                           AND posnr IS INITIAL.
*   End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349

    IF li_renwl_plan IS NOT INITIAL.
      fp_rewal_plan = li_renwl_plan.
    ENDIF. " IF li_renwl_plan IS NOT INITIAL
  ENDIF. " IF NOT li_renwl_plan IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CATALOG
*&---------------------------------------------------------------------*
*       Populate field catalog
*----------------------------------------------------------------------*
*  <--  fp_i_fca       Field Ctalog
*----------------------------------------------------------------------*
FORM f_popul_field_catalog CHANGING fp_i_fcat TYPE slis_t_fieldcat_alv.
*   Populate the field catalog
  DATA : lv_col_pos TYPE sycucol. " Col_pos of type Integers

*Constant for hold for alv tablename
  CONSTANTS: lc_tabname         TYPE slis_tabname VALUE 'I_FINAL', "Tablename for Alv Display
* Constent for hold the alv field catelog
             lc_fld_vbeln       TYPE slis_fieldname VALUE 'VBELN',
             lc_fld_activity    TYPE slis_fieldname VALUE 'ACTIVITY',
*Begin of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
             lc_fld_matnr       TYPE slis_fieldname VALUE 'MATNR',
*End of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
             lc_fld_posnr       TYPE slis_fieldname VALUE 'POSNR',
             lc_fld_eadat       TYPE slis_fieldname VALUE 'EADAT',
             lc_fld_renwl_prof  TYPE slis_fieldname VALUE 'RENWL_PROF',
             lc_fld_promo_code  TYPE slis_fieldname VALUE 'PROMO_CODE',
             lc_fld_act_status  TYPE slis_fieldname VALUE 'ACT_STATUS',
             lc_fld_ren_status  TYPE slis_fieldname VALUE 'REN_STATUS',
*            Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
             lc_fld_excl_resn   TYPE slis_fieldname VALUE 'EXCL_RESN_D',
             lc_fld_excl_date   TYPE slis_fieldname VALUE 'EXCL_DATE',
*            End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
             lc_fld_excl_resn2  TYPE slis_fieldname VALUE 'EXCL_RESN_D2',
             lc_fld_excl_date2  TYPE slis_fieldname VALUE 'EXCL_DATE2',
             lc_fld_other_cmnts TYPE slis_fieldname VALUE 'OTHER_CMNTS',
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
             lc_fld_aedat       TYPE slis_fieldname VALUE 'AEDAT',
             lc_fld_aezet       TYPE slis_fieldname VALUE 'AEZET',
             lc_fld_aenam       TYPE slis_fieldname VALUE 'AENAM',
             lc_fld_msg         TYPE slis_fieldname VALUE 'MESSAGE',
*            BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
             lc_log_type        TYPE slis_fieldname VALUE 'LOG_TYPE',
             lc_log_type_desc   TYPE slis_fieldname VALUE 'LOG_TYPE_DESC',
             lc_lognumber       TYPE slis_fieldname VALUE 'LOGNUMBER',
             lc_test_run        TYPE slis_fieldname VALUE 'TEST_RUN',
             lc_review_stat     TYPE slis_fieldname VALUE 'REVIEW_STAT',
             lc_comments        TYPE slis_fieldname VALUE 'COMMENTS',
*            EOC - NPALLA - E096 - 2018/08/27 - ED2K912739
*** Begin of: KKRAVURI  KKR20180911  CR# 6295
             lc_jobname         TYPE slis_fieldname VALUE 'JOBNAME',
             lc_job_date        TYPE slis_fieldname VALUE 'JOB_DATE',
             lc_job_time        TYPE slis_fieldname VALUE 'JOB_TIME'.
*** End of: KKRAVURI  KKR20180911  CR# 6295

  lv_col_pos         = 0 .
* Populate field catalog

* Invoice Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_vbeln  lc_tabname   lv_col_pos  'Sales Document'(014)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_posnr  lc_tabname   lv_col_pos  'Document Item'(016)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_activity  lc_tabname   lv_col_pos  'Activity'(015)
                       CHANGING fp_i_fcat.
*Begin of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_matnr  lc_tabname   lv_col_pos  'Material No'(026)
                       CHANGING fp_i_fcat.
*End of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_eadat  lc_tabname   lv_col_pos  'Activity Date'(017)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_renwl_prof  lc_tabname   lv_col_pos  'Renewal Profile'(018)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_promo_code  lc_tabname   lv_col_pos  'Promo code'(019)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_act_status  lc_tabname   lv_col_pos  'Activity Status'(020)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_ren_status  lc_tabname   lv_col_pos  'Renewal Status'(021)
                       CHANGING fp_i_fcat.
* Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_excl_resn   lc_tabname   lv_col_pos  'Exclusion Reason 1'(007)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_excl_date   lc_tabname   lv_col_pos  'Exclusion Date 1'(008)
                       CHANGING fp_i_fcat.
* End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_excl_resn2   lc_tabname   lv_col_pos  'Exclusion Reason 2'(041)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_excl_date2   lc_tabname   lv_col_pos  'Exclusion Date 2'(042)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_other_cmnts   lc_tabname   lv_col_pos  'Other Comments'(043)
                       CHANGING fp_i_fcat.
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_aenam  lc_tabname   lv_col_pos  'Who Changed Object'(022)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_aedat lc_tabname   lv_col_pos  'Changed On'(023)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_aezet lc_tabname   lv_col_pos  'Time last change was made'(024)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_msg lc_tabname   lv_col_pos  'Message'(025)
                       CHANGING fp_i_fcat.
* BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_log_type lc_tabname   lv_col_pos  'Log Type'(027)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_log_type_desc lc_tabname   lv_col_pos  'Log Type Desc'(028)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_lognumber lc_tabname   lv_col_pos  'Log Number'(029)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_test_run lc_tabname   lv_col_pos  'Test Run'(030)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_review_stat lc_tabname   lv_col_pos  'Review Status'(031)
                       CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_comments lc_tabname   lv_col_pos  'Comments'(032)
                       CHANGING fp_i_fcat.
* EOC - NPALLA - E096 - 2018/08/27 - ED2K912739

*** Begin of: KKRAVURI KKR20180911 CR# 6295
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_jobname lc_tabname lv_col_pos  'Job Name'(033)
                               CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_job_date lc_tabname lv_col_pos  'Job Date'(034)
                               CHANGING fp_i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_job_time lc_tabname lv_col_pos  'Job Time'(035)
                               CHANGING fp_i_fcat.
*** End of: KKRAVURI KKR20180911 CR# 6295

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*       Display ALV
*----------------------------------------------------------------------*
*      -->FP_I_FCAT  Field catalogiue
*      -->FP_I_FINAL Output table
*----------------------------------------------------------------------*
FORM f_display_alv  USING    fp_i_fcat TYPE slis_t_fieldcat_alv
                             fp_i_final TYPE tt_final.
  CONSTANTS : lc_pf_status   TYPE slis_formname  VALUE 'F_SET_PF_STATUS',
              lc_user_comm   TYPE slis_formname  VALUE 'F_USER_COMMAND',
              lc_top_of_page TYPE slis_formname  VALUE 'F_TOP_OF_PAGE',
              lc_box_sel     TYPE slis_fieldname VALUE 'SEL'.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Displaying Results'(002).

  DATA: lst_layout   TYPE slis_layout_alv.

* BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
  LOOP AT fp_i_final ASSIGNING FIELD-SYMBOL(<lst_fp_i_final>).
    IF <lst_fp_i_final>-lognumber IS NOT INITIAL.
      SHIFT <lst_fp_i_final>-lognumber LEFT DELETING LEADING '0'.
    ENDIF.
    PERFORM f_get_msg_icon  USING <lst_fp_i_final>-log_type
                            CHANGING <lst_fp_i_final>-log_type_desc.
  ENDLOOP. " LOOP AT fp_i_final ASSIGNING FIELD-SYMBOL(<lst_fp_i_final>)
* EOC - NPALLA - E096 - 2018/08/27 - ED2K912739

  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.
  lst_layout-box_fieldname      = lc_box_sel.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = lc_pf_status
      i_callback_user_command  = lc_user_comm
      i_callback_top_of_page   = lc_top_of_page
      is_layout                = lst_layout
      it_fieldcat              = fp_i_fcat
      i_save                   = abap_true
    TABLES
      t_outtab                 = fp_i_final
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_set_pf_status
*&---------------------------------------------------------------------*
*       Set the PF Status for ALV
*----------------------------------------------------------------------*
FORM f_set_pf_status USING li_extab TYPE slis_t_extab.      "#EC CALLED

* Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
  CONSTANTS:
    lc_exclude  TYPE syst_ucomm     VALUE '&EXCLUDE', " ABAP System Field: PAI-Triggering Function Code
    lc_include  TYPE syst_ucomm     VALUE '&INCLUDE', " ABAP System Field: PAI-Triggering Function Code
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
    lc_exclude2 TYPE syst_ucomm   VALUE '&EXCLUDE2',
    lc_include2 TYPE syst_ucomm   VALUE '&INCLUDE2',
    lc_mass     TYPE syst_ucomm   VALUE '&MASS',
    lc_incl     TYPE syst_ucomm VALUE '&INCL',
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
*** BOC: DM-1923  KKRAVURI20190606  ED2K915200
    lc_process  TYPE syst_ucomm     VALUE '&PROCESS',
    lc_check    TYPE syst_ucomm     VALUE '&CHCK',
    lc_uncheck  TYPE syst_ucomm     VALUE '&UNCHCK',
    lc_save     TYPE syst_ucomm     VALUE '&SAVE'.
*** EOC: DM-1923  KKRAVURI20190606  ED2K915200

  IF p_test IS NOT INITIAL.
    APPEND INITIAL LINE TO li_extab ASSIGNING FIELD-SYMBOL(<lst_extab>).
    <lst_extab>-fcode = lc_exclude.

    APPEND INITIAL LINE TO li_extab ASSIGNING <lst_extab>.
    <lst_extab>-fcode = lc_include.
  ENDIF. " IF p_test IS NOT INITIAL

*** BOC: DM-1923  KKRAVURI20190606  ED2K915200
  IF p_chck = abap_true.
* If Check/Un-check checkbox is checked, then disappear the Process, Include, Exclude buttons
    APPEND INITIAL LINE TO li_extab ASSIGNING FIELD-SYMBOL(<lst_extab1>).
    <lst_extab1>-fcode = lc_exclude.

    APPEND INITIAL LINE TO li_extab ASSIGNING <lst_extab1>.
    <lst_extab1>-fcode = lc_include.

    APPEND INITIAL LINE TO li_extab ASSIGNING <lst_extab1>.
    <lst_extab1>-fcode = lc_process.
  ELSE.
* If Check/Un-check checkbox is not checked, then disappear the Check, Un-check, Save buttons
    APPEND INITIAL LINE TO li_extab ASSIGNING FIELD-SYMBOL(<lst_extab2>).
    <lst_extab2>-fcode = lc_check.

    APPEND INITIAL LINE TO li_extab ASSIGNING <lst_extab2>.
    <lst_extab2>-fcode = lc_uncheck.

    APPEND INITIAL LINE TO li_extab ASSIGNING <lst_extab2>.
    <lst_extab2>-fcode = lc_save.
  ENDIF.
*** EOC: DM-1923  KKRAVURI20190606  ED2K915200
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
*--*Exclude below menu buttons when "Perform exclusion/inclusion" un checked
  IF p_ex_in IS INITIAL.
    APPEND INITIAL LINE TO li_extab ASSIGNING <lst_extab1>.
    <lst_extab1>-fcode = lc_exclude.
    APPEND INITIAL LINE TO li_extab ASSIGNING <lst_extab1>.
    <lst_extab1>-fcode = lc_include.
    APPEND INITIAL LINE TO li_extab ASSIGNING <lst_extab1>.
    <lst_extab1>-fcode = lc_exclude2.
    APPEND INITIAL LINE TO li_extab ASSIGNING <lst_extab1>.
    <lst_extab1>-fcode = lc_include2.
    APPEND INITIAL LINE TO li_extab ASSIGNING <lst_extab1>.
    <lst_extab1>-fcode = lc_mass.
    IF p_excld IS INITIAL.
      APPEND INITIAL LINE TO li_extab ASSIGNING <lst_extab1>.
      <lst_extab1>-fcode = lc_incl.
    ENDIF.
  ELSE.
    APPEND INITIAL LINE TO li_extab ASSIGNING <lst_extab1>.
    <lst_extab1>-fcode = lc_process.
    APPEND INITIAL LINE TO li_extab ASSIGNING <lst_extab1>.
    <lst_extab1>-fcode = lc_incl.
  ENDIF.
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
  SET PF-STATUS 'ZSTANDARD'EXCLUDING li_extab.
* End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
* Begin of DEL:ERP-6347:WROY:19-JUN-2018:ED2K912349
* DESCRIBE TABLE li_extab. "Avoid Extended Check Warning
* SET PF-STATUS 'ZSTANDARD'.
* End   of DEL:ERP-6347:WROY:19-JUN-2018:ED2K912349

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT_HOTSPOT
*&---------------------------------------------------------------------*
*       Build hotspot
*----------------------------------------------------------------------*
*      -->fp_field  field name
*      -->fp_tabname  Table name
*      -->fp_col_pos  column position
*      <--FP_I_FCAT  Field catalogue
*----------------------------------------------------------------------*
FORM f_build_fcat_hotspot USING  fp_field    TYPE slis_fieldname
                                 fp_tabname  TYPE slis_tabname
                                 fp_col_pos  TYPE sycucol " Col_pos of type Integers
                                 fp_text     TYPE char50  " Text of type CHAR50
                        CHANGING fp_i_fcat   TYPE slis_t_fieldcat_alv.

  DATA:
    lst_fcat TYPE slis_fieldcat_alv.

  CONSTANTS:
    lc_outputlen   TYPE outputlen  VALUE '30',
    lc_vbeln       TYPE char5      VALUE 'VBELN',
    lc_posnr       TYPE char5      VALUE 'POSNR',
    lc_matnr       TYPE char5      VALUE 'MATNR',
    lc_lognumber   TYPE char9      VALUE 'LOGNUMBER',
    lc_test_run    TYPE char8      VALUE 'TEST_RUN',
    lc_review_stat TYPE char11     VALUE 'REVIEW_STAT',
    lc_activity    TYPE char8      VALUE 'ACTIVITY',
    lc_log_type    TYPE char8      VALUE 'LOG_TYPE', " Output Length
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
    lc_other_cmnts TYPE char12   VALUE 'OTHER_CMNTS'.
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
  lst_fcat-lowercase   = abap_true.
* BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
*  lst_fcat-key         = abap_true.
  IF fp_field = lc_vbeln OR
     fp_field = lc_posnr OR
     fp_field = lc_activity.
    lst_fcat-key  = abap_true.
  ENDIF. " IF fp_field = 'VBELN' OR
* EOC - NPALLA - E096 - 2018/08/27 - ED2K912739
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
*--*
  IF fp_field = lc_other_cmnts.
    lst_fcat-outputlen   = '200'.
  ENDIF.
* BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
*  lst_fcat-hotspot     = abap_true.
  IF fp_field = lc_vbeln OR fp_field = lc_matnr OR fp_field = lc_lognumber
     OR fp_field = lc_other_cmnts.
    lst_fcat-hotspot     = abap_true.
  ENDIF. " IF fp_field = 'VBELN' OR fp_field = 'MATNR' OR fp_field = 'LOGNUMBER'
  IF fp_field = lc_test_run OR fp_field = lc_review_stat.
    lst_fcat-checkbox = abap_true.
  ENDIF. " IF fp_field = 'TEST_RUN' OR fp_field = 'REVIEW_STAT'
  IF fp_field = lc_log_type.
    lst_fcat-no_out = abap_true.
  ENDIF. " IF fp_field = 'LOG_TYPE'
* EOC - NPALLA - E096 - 2018/08/27 - ED2K912739
  lst_fcat-seltext_m   = fp_text.
  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_top_of_page.
*ALV Header declarations
  DATA: li_header  TYPE slis_t_listheader,
        lst_header TYPE slis_listheader.

* Constant
  CONSTANTS :     lc_typ_h TYPE char1 VALUE 'H'. " Typ_h of type CHAR1
* TITLE
  lst_header-typ = lc_typ_h . "'H'
  lst_header-info = 'Auto Renewal Plan'(w05).
  APPEND lst_header TO li_header.
  CLEAR lst_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_header.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form F_USER_COMMAND
*&---------------------------------------------------------------------*
*      USING fp_ucomm          " ABAP System Field: PAI-Triggering Function Code
*            fp_lst_selfield   .
*----------------------------------------------------------------------*
FORM f_user_command USING fp_ucomm TYPE syst_ucomm            " ABAP System Field: PAI-Triggering Function Code
                          fp_lst_selfield TYPE slis_selfield. "#EC CALLED
  CONSTANTS:
    lc_process  TYPE syst_ucomm     VALUE '&PROCESS', " ABAP System Field: PAI-Triggering Function Code
    lc_rfresh   TYPE syst_ucomm     VALUE '&REFRESH', " ABAP System Field: PAI-Triggering Function Code
* Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
    lc_exclude  TYPE syst_ucomm     VALUE '&EXCLUDE', " ABAP System Field: PAI-Triggering Function Code
    lc_include  TYPE syst_ucomm     VALUE '&INCLUDE', " ABAP System Field: PAI-Triggering Function Code
* End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
    lc_exclude2 TYPE syst_ucomm     VALUE '&EXCLUDE2', " ABAP System Field: PAI-Triggering Function Code
    lc_include2 TYPE syst_ucomm     VALUE '&INCLUDE2', " ABAP System Field: PAI-Triggering Function Code
    lc_mass     TYPE syst_ucomm     VALUE '&MASS',     " ABAP System Field: PAI-Triggering Function Code
    lc_incl     TYPE syst_ucomm     VALUE '&INCL',     " ABAP System Field: PAI-Triggering Function Code
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
* BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
*    lc_save    TYPE syst_ucomm     VALUE '&DATA_SAVE', " ABAP System Field: PAI-Triggering Function Code
    lc_hotspot  TYPE syst_ucomm     VALUE '&IC1',       " ABAP System Field: PAI-Triggering Function Code
* EOC - NPALLA - E096 - 2018/08/27 - ED2K912739
*** BOC: DM-1923  KKRAVURI20190606  ED2K915200
    lc_check    TYPE syst_ucomm     VALUE '&CHCK',
    lc_uncheck  TYPE syst_ucomm     VALUE '&UNCHCK',
    lc_save     TYPE syst_ucomm     VALUE '&SAVE'.
*** EOC: DM-1923  KKRAVURI20190606  ED2K915200

  CASE fp_ucomm.
    WHEN lc_process.
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
*--*Pop up to confirm the operation
      PERFORM f_popup_process.
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
      PERFORM f_process_data USING sy-batch
                                   i_item
                                   i_business
                                   i_partner
                                   i_textheaders
                                   i_textlines
                                   i_header
                                   i_contr_data
                                   i_const
                                   i_notif_p_det
                                   i_renwl_plan
                                   i_ext_vbap " Added by MODUTTA on 5th-Jun-2018:INC0197849:TR# ED1K907603
                                   i_veda
                                   i_nast
                                   i_docflow
                                   p_test
                         CHANGING  i_final.
      fp_lst_selfield-refresh = abap_true.

    WHEN lc_rfresh.
      fp_lst_selfield-refresh = abap_true.

*   Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
    WHEN lc_exclude.
      PERFORM f_populate_excl_reason CHANGING i_final.
      fp_lst_selfield-refresh = abap_true.

    WHEN lc_include.
      PERFORM f_remove_excl_reason CHANGING i_final.
      fp_lst_selfield-refresh = abap_true.
*   End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
*--* Add the functionality for newly added buttons
    WHEN lc_exclude2.
      PERFORM f_populate_excl_reason_2 CHANGING i_final.
      fp_lst_selfield-refresh = abap_true.
    WHEN lc_include2.
      PERFORM f_remove_excl_reason_2 CHANGING i_final.
      fp_lst_selfield-refresh = abap_true.
    WHEN lc_incl.
      PERFORM f_remove_excl_reason_1_2 CHANGING i_final.
      fp_lst_selfield-refresh = abap_true.
    WHEN lc_mass.
      PERFORM f_mass_comments_update USING fp_ucomm fp_lst_selfield CHANGING i_final.
      fp_lst_selfield-refresh = abap_true.
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
*   BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
    WHEN lc_hotspot.
      PERFORM f_process_hotspot USING fp_lst_selfield.
*    WHEN lc_save.
*      PERFORM f_save_alvdata USING fp_lst_selfield.
*      fp_lst_selfield-refresh = abap_true.
*   EOC - NPALLA - E096 - 2018/08/27 - ED2K912739
*** BOC: DM-1923  KKRAVURI20190606  ED2K915200
    WHEN lc_check.
      PERFORM f_check_data CHANGING i_final.
      fp_lst_selfield-refresh = abap_true.
    WHEN lc_uncheck.
      PERFORM f_uncheck_data CHANGING i_final.
      fp_lst_selfield-refresh = abap_true.
    WHEN lc_save.
      PERFORM f_save_data CHANGING i_final.
      fp_lst_selfield-refresh = abap_true.
*** EOC: DM-1923  KKRAVURI20190606  ED2K915200

    WHEN OTHERS.
      " Nothing to do
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_DATA
*&---------------------------------------------------------------------*
*       This Form is for processing all the activity
*----------------------------------------------------------------------*
*     -->fp_batch          : Indicate program running in backgrnd
*      -->FP_I_ITEM         : Order Item
*      -->P_I_PARTNER       : Partner informations
*      -->FP_I_TEXTHEADERS  : Header text
*      -->FP_I_TEXTLINES    : Item text lines
*      -->FP_I_HEADER       : Order Header
*     -->fp_i_contract      : Contract data
*     -->fp_i_const         : Constant table
*     -->fp_p_test          : Indicator for test run
*     <--FP_I_FINAL         : Final table entry
*----------------------------------------------------------------------*
FORM f_process_data  USING fp_batch         TYPE syst_batch  " ABAP System Field: Background Processing Active
                           fp_i_item        TYPE tt_item
                           fp_i_business    TYPE tt_business
                           fp_i_partner     TYPE tt_partner
                           fp_i_textheaders TYPE tt_textheaders
                           fp_i_textlines   TYPE tt_textlines
                           fp_i_header      TYPE tt_header
                           fp_i_contract    TYPE tt_contract
                           fp_i_const       TYPE tt_const
                           fp_i_notif_prof  TYPE tt_notif_p_det
                           fp_i_renwal      TYPE tt_renwl_plan
                           fp_i_ext_vbap    TYPE tt_ext_vbap "Added by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
                           fp_i_veda        TYPE tt_veda
                           fp_i_nast        TYPE tt_nast
                           fp_i_docflow     TYPE tt_docflow
                           fp_p_test        TYPE char1       " P_test of type CHAR1
  CHANGING fp_i_final     TYPE tt_final.

  DATA: lr_i_headr           TYPE REF TO bapisdhd,        " BAPI Structure of VBAK with English Field Names
        lr_veda              TYPE REF TO ty_vbak_header,  " contract data reference variable
        li_renewal_plan      TYPE tt_renwl_plan,          " Renwal Plan table
        lr_renewal_plan      TYPE REF TO zqtc_renwl_plan, " Reference varibale for Plan table
        lr_final             TYPE REF TO ty_renwl_plan,   " Reference variable for final table
        lr_i_notif_prof      TYPE REF TO ty_notif_p_det,  " Reference variable for notification determination
        lr_item              TYPE REF TO bapisdit,        " Structure of VBAP with English Field Names
        lr_business          TYPE REF TO bapisdbusi,      " VBKD Structure
        lr_ext_vbap          TYPE REF TO bape_vbap,       " "Added by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
        li_header            TYPE tt_header,              " Internal table for header
        li_partner           TYPE tt_partner,             " Internal table for partner
        li_contract          TYPE tt_contract,            " BAPI Structure of VEDA with English Field Names
        lr_contract          TYPE REF TO bapisdcntr,      " BAPI Structure of VEDA with English Field Names
        lr_partner           TYPE REF TO bapisdpart,      " Reference for partner
        li_textheaders       TYPE tt_textheaders,         " Text headers
        lr_textheaders       TYPE REF TO bapisdtehd,      " BAPI Structure of THEAD with English Field Names
        li_textlines         TYPE tt_textlines,           " Text lines
        lr_textlines         TYPE REF TO bapitextli,      " Text lines reference
        lr_const             TYPE REF TO ty_const,        " Reference variable for constant
        lv_act_status        TYPE zact_status,            " Activity status
        lv_reminder          TYPE znotif_rem,             " Notification reminder
        lv_doc_type          TYPE vbak-auart,             " Order type
        li_item_temp         TYPE tt_item,                " Internal table for item
        li_hd_temp           TYPE tt_header,              " Internal table for header temorary
        lv_actvity           TYPE char1,                  " flag
        lst_item_temp        TYPE LINE OF tt_item,        " Work Area
        lst_hd_temp          TYPE LINE OF tt_header,      " Header
        li_item              TYPE tt_item,                " Item
        li_business          TYPE tt_business,            " VBKD data
        li_ext_vbap          TYPE tt_ext_vbap,            "Added by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
        lv_lapsed            TYPE char1,                  " FLAG lapsed
        lv_flag              TYPE char1,                  " Flag of type CHAR1
        lr_docflow           TYPE REF TO bapisdflow,      " BAPI Structure of VBFA
        li_final             TYPE tt_final,
*Begin of ADD:ERP-6343:NGADRE:01-AUG-2018:ED2K912802
        lv_notif_act         TYPE char01,              " Notif_act of type CHAR01
        li_consolidate_data  TYPE tt_consolidate_data, " internal table for consolidation
        lst_consolidate_data TYPE ty_consolidate_data. " workaera for consolidation
*End of ADD:ERP-6343:NGADRE:01-AUG-2018:ED2K912802
*BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
  DATA: lv_job_name     TYPE btcjob,
        lv_date         TYPE sy-datum,
        lv_time         TYPE sy-uzeit,
        lv_jobid        TYPE btcjobcnt,
        lv_msg_str      TYPE char120,  " KKRAVURI
        lv_msg_flag     TYPE abap_bool VALUE abap_false, " KKRAVURI
        ls_renewal_plan TYPE zqtc_renwl_plan.
*EOC - NPALLA - E096 - 2018/08/27 - ED2K912739

  CONSTANTS: lc_posnr_low TYPE vbap-posnr    VALUE '000000', " To indicate Header
             lc_reminder  TYPE char1         VALUE 'R',      " First letter of Reminder activity
             lc_devid     TYPE zdevid        VALUE 'E096',   " Development ID
             lc_param1    TYPE rvari_vnam    VALUE 'GR',     " Parameter1
             lc_param2    TYPE rvari_vnam    VALUE 'CS',     " Parameter1
             lc_cs        TYPE zactivity_sub VALUE 'CS',     " create Subscription
             lc_gr        TYPE zactivity_sub VALUE 'GR',     " create grace Subscription
             lc_cq        TYPE zactivity_sub VALUE 'CQ',     " create Quotation
             lc_contract  TYPE char1          VALUE 'G',     " Contract of type CHAR1
             lc_quotation TYPE char1         VALUE 'B',      " Quotation of type CHAR1
             lc_lp        TYPE zactivity_sub VALUE 'LP',     " Lapse Subscription
             lc_ship_to   TYPE parvw         VALUE 'WE',     " partner function Ship to
             lc_bill_to   TYPE parvw         VALUE 'RE',     " partner function bill to
*Begin of insert by <HIPATEL> <INC0234283> <ED1K909890> <03/27/2019>
             lc_process   TYPE syst_ucomm    VALUE '&PROCESS'. " ABAP System Field: PAI-Triggering Function Code
*End of insert by <HIPATEL> <INC0234283> <ED1K909890> <03/27/2019>
  li_final = i_final.
  IF fp_batch = abap_false.
* keep those entry which are selected while excuting online  .
    DELETE li_final WHERE sel <> abap_true.
  ENDIF. " IF fp_batch = abap_false

  IF sy-batch = abap_true.
    CALL FUNCTION 'GET_JOB_RUNTIME_INFO'
      IMPORTING
        jobcount        = lv_jobid
        jobname         = lv_job_name
      EXCEPTIONS
        no_runtime_info = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
*   Implement suitable error handling here
    ENDIF. " IF sy-subrc <> 0
  ENDIF.

*Begin of Del-Anirban-07.20.2017-ED2K907327-Defect 3301
*  IF p_clear EQ abap_false.
*End of Del-Anirban-07.20.2017-ED2K907327-Defect 3301

*Begin of Del-Anirban-07.25.2017-ED2K907327-Defect 3301
**Begin of Add-Anirban-07.20.2017-ED2K907327-Defect 3301
*  IF p_clear EQ abap_false AND p_status EQ abap_false.
**End of Add-Anirban-07.20.2017-ED2K907327-Defect 3301
*End of Del-Anirban-07.25.2017-ED2K907327-Defect 3301

*Begin of Add-Anirban-07.25.2017-ED2K907327-Defect 3301
  IF p_clear EQ abap_false.
*End of Add-Anirban-07.25.2017-ED2K907327-Defect 3301
    LOOP AT fp_i_header REFERENCE INTO lr_i_headr.
*Begin of insert by <HIPATEL> <INC0234283> <ED1K909890> <03/27/2019>
*Override Currency in Renw. Order from the Selection Screen
      IF p_curr EQ abap_true AND sy-ucomm EQ lc_process.
        lr_i_headr->currency   = p_waers.
        lr_i_headr->curren_iso = p_waers.
      ENDIF.
*End of insert by <HIPATEL> <INC0234283> <ED1K909890> <03/27/2019>
      CLEAR li_partner.
      READ TABLE li_final
      ASSIGNING FIELD-SYMBOL(<lst_fp_i_final>)
      WITH TABLE KEY primary_key
      COMPONENTS vbeln = lr_i_headr->doc_number.
      " activity = DU.
      "activity = abap_true.
      IF sy-subrc = 0.
*& Populate partner date
        CLEAR li_partner.
        LOOP AT fp_i_partner REFERENCE INTO lr_partner
        WHERE sd_doc = lr_i_headr->doc_number
        AND itm_number = lc_posnr_low.

          APPEND lr_partner->* TO li_partner.
*          CLEAR lr_partner->*.

        ENDLOOP. " LOOP AT fp_i_partner REFERENCE INTO lr_partner
*& Populate VBKD data
        CLEAR: li_business. " lr_business.
        READ TABLE fp_i_business
        REFERENCE INTO lr_business
        WITH KEY sd_doc = lr_i_headr->doc_number
                 itm_number = lc_posnr_low.
        IF sy-subrc = 0.
          APPEND lr_business->* TO li_business.
        ENDIF. " IF sy-subrc = 0

*       Begin of ADD:ERP-6508:WROY:06-Feb-2018:ED2K910691
        CLEAR li_contract.
        READ TABLE fp_i_contract
        REFERENCE INTO lr_contract
        WITH KEY doc_number = lr_i_headr->doc_number
                              itm_number = lc_posnr_low.
        IF sy-subrc = 0.
          APPEND lr_contract->* TO li_contract.
        ENDIF. " IF sy-subrc = 0
*       End   of ADD:ERP-6508:WROY:06-Feb-2018:ED2K910691

        CLEAR li_textheaders.
        CLEAR li_textlines.
        LOOP AT fp_i_textheaders REFERENCE INTO lr_textheaders WHERE sd_doc = lr_i_headr->doc_number.

          LOOP AT fp_i_textlines  REFERENCE INTO lr_textlines WHERE text_name = lr_textheaders->text_name.
            APPEND lr_textlines->* TO li_textlines.
          ENDLOOP. " LOOP AT fp_i_textlines REFERENCE INTO lr_textlines WHERE text_name = lr_textheaders->text_name

          APPEND lr_textheaders->* TO li_textheaders.
*          CLEAR lr_textheaders->*.
        ENDLOOP. " LOOP AT fp_i_textheaders REFERENCE INTO lr_textheaders WHERE sd_doc = lr_i_headr->doc_number

        CLEAR li_header.
        APPEND lr_i_headr->* TO li_header.
        CREATE DATA lr_renewal_plan.

        CLEAR lr_final.
        LOOP AT li_final ASSIGNING FIELD-SYMBOL(<lst_fp_i_final_e095>)
        USING KEY activity WHERE vbeln = lr_i_headr->doc_number
                           AND activity <> space.
          " AND     activity = space.
* BOC - CR# 6295 KKRAVURI 2018/08/27  ED2K912739
          v_1st_var = <lst_fp_i_final_e095>-vbeln. "+ED2K912739
* EOC - CR# 6295 KKRAVURI 2018/08/27  ED2K912739
*         Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
          IF <lst_fp_i_final_e095>-excl_resn IS NOT INITIAL " Exclusion_reason
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
*--*Consider exclusion reason 2 to avoid the process
            OR <lst_fp_i_final_e095>-excl_resn2 IS NOT INITIAL.
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
            READ TABLE fp_i_final ASSIGNING FIELD-SYMBOL(<lst_i_final_excl>)
                  WITH TABLE KEY  vbeln_key
            COMPONENTS vbeln    = <lst_fp_i_final_e095>-vbeln
                       posnr    = <lst_fp_i_final_e095>-posnr
                       activity = <lst_fp_i_final_e095>-activity.
            IF sy-subrc EQ 0.
              <lst_i_final_excl>-message = 'Excluded activities are not considered'(003).
*** Begin of: CR# 6295  KKR20180914  ED2K912739
              lv_msg_str = text-003.
              PERFORM add_pgm_message_log USING lv_msg_str
                                                c_msg_typ_e
                                                c_msg_num_0.
              IF i_bal_msg[] IS NOT INITIAL.
                PERFORM f_create_log USING  v_1st_var
                                            i_bal_msg
                                   CHANGING v_lognumber.

                IF <lst_fp_i_final_e095>-lognumber IS NOT INITIAL AND
                   v_lognumber IS NOT INITIAL.
                  PERFORM f_add_previous_log_msg  USING <lst_fp_i_final_e095>-lognumber
                                                        v_log_handle.
                ENDIF.

                PERFORM f_maintain_log USING v_log_handle
                                             i_bal_msg
                                    CHANGING i_log_handle.

                PERFORM f_save_log USING i_log_handle.

                <lst_fp_i_final_e095>-log_type  = <lst_i_final_excl>-log_type  = v_log_type.  " Log Type E/W/S/I
                <lst_fp_i_final_e095>-lognumber = <lst_i_final_excl>-lognumber = v_lognumber. " Log Number (SLG1)
                <lst_fp_i_final_e095>-test_run  = <lst_i_final_excl>-test_run  = p_test.      " Test Run
                PERFORM f_get_msg_icon  USING    <lst_fp_i_final_e095>-log_type
                                        CHANGING <lst_fp_i_final_e095>-log_type_desc.

                <lst_i_final_excl>-log_type_desc = <lst_fp_i_final_e095>-log_type_desc. " Log Type Desc
                IF <lst_i_final_excl>-lognumber IS NOT INITIAL.
                  SHIFT <lst_i_final_excl>-lognumber LEFT DELETING LEADING '0'.
                ENDIF.

                IF sy-batch = abap_true.
                  GET TIME.
                  lv_date = sy-datum.
                  lv_time = sy-uzeit.
                  <lst_fp_i_final_e095>-jobname = <lst_i_final_excl>-jobname = lv_job_name.
                  <lst_fp_i_final_e095>-job_date = <lst_i_final_excl>-job_date = lv_date.
                  <lst_fp_i_final_e095>-job_time = <lst_i_final_excl>-job_time = lv_time.
                ENDIF.

                MOVE-CORRESPONDING <lst_fp_i_final_e095> TO ls_renewal_plan.
                APPEND ls_renewal_plan TO li_renewal_plan.
                CLEAR ls_renewal_plan.

***             Update the Renewal Plan Table
                CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL'
                  TABLES
                    t_renwl_plan = li_renewal_plan.

                CLEAR: v_log_type, lv_msg_str, v_lognumber,
                       v_log_handle, i_bal_msg[], i_log_handle[], li_renewal_plan[].
              ENDIF. " IF i_bal_msg[] IS NOT INITIAL
*** End of: CR# 6295  KKR20180914  ED2K912739
            ENDIF. " IF sy-subrc EQ 0
            CONTINUE.
          ENDIF. " IF <lst_fp_i_final_e095>-excl_resn IS NOT INITIAL
*         End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349

*Begin of ADD:ERP-6343:NGADRE:01-AUG-2018:ED2K912802
**add the logic to check if consolidation flag set for Renewal profile if so then
**consider that document line item for consolidation
          CLEAR: lv_reminder,
                 lv_notif_act.

          lv_reminder = <lst_fp_i_final_e095>-activity.
          READ TABLE fp_i_notif_prof TRANSPORTING NO FIELDS
           WITH KEY renwl_prof = <lst_fp_i_final_e095>-renwl_prof
                    notif_rem = lv_reminder.
          IF sy-subrc = 0.
            lv_notif_act = abap_true.
          ENDIF. " IF sy-subrc = 0

          IF  ( <lst_fp_i_final_e095>-consolidate EQ abap_true
        AND ( <lst_fp_i_final_e095>-activity EQ lc_cq
         OR   <lst_fp_i_final_e095>-activity+0(1) EQ lc_reminder
         OR    lv_notif_act EQ abap_true ) ).

            IF  ( sy-batch = abap_true AND <lst_fp_i_final>-eadat IN s_eadat )
            OR ( <lst_fp_i_final>-sel = abap_true ).

              lst_consolidate_data-vkorg = lr_i_headr->sales_org.
              lst_consolidate_data-waers = lr_i_headr->currency.
              lst_consolidate_data-division = lr_i_headr->division.
              lst_consolidate_data-po_method = lr_i_headr->po_method.
              lst_consolidate_data-distr_chan = lr_i_headr->distr_chan.
              lst_consolidate_data-sales_off = lr_i_headr->sales_off.
              lst_consolidate_data-renwl_profile = <lst_fp_i_final_e095>-renwl_prof.
              lst_consolidate_data-vbeln = <lst_fp_i_final_e095>-vbeln.
              lst_consolidate_data-posnr =  <lst_fp_i_final_e095>-posnr.
              lst_consolidate_data-activity = <lst_fp_i_final_e095>-activity.
              lst_consolidate_data-renwl_date    = <lst_fp_i_final_e095>-eadat.
              lst_consolidate_data-act_status = <lst_fp_i_final_e095>-act_status.
*             Begin of ADD:ERP-6343:WROY:28-AUG-2018:ED2K913164
              READ TABLE fp_i_docflow ASSIGNING FIELD-SYMBOL(<lst_docflow>)
                   WITH KEY precsddoc  = <lst_fp_i_final_e095>-vbeln
                            preditdoc  = <lst_fp_i_final_e095>-posnr
                            doccategor = lc_quotation
                   BINARY SEARCH.
              IF sy-subrc EQ 0.
                lst_consolidate_data-renwl_quote = <lst_docflow>-subssddoc.
              ENDIF. " IF sy-subrc EQ 0
*             End   of ADD:ERP-6343:WROY:28-AUG-2018:ED2K913164

*Get line item material
              READ TABLE fp_i_item ASSIGNING FIELD-SYMBOL(<lst_i_item>)
                                              WITH KEY  doc_number = <lst_fp_i_final_e095>-vbeln
                                                        itm_number = <lst_fp_i_final_e095>-posnr.
              IF sy-subrc EQ 0.

                lst_consolidate_data-material = <lst_i_item>-material.

              ENDIF. " IF sy-subrc EQ 0

*get contract end date
              READ TABLE fp_i_contract ASSIGNING FIELD-SYMBOL(<lst_i_contract>)
                                               WITH KEY doc_number = lst_consolidate_data-vbeln
                                                        itm_number = lst_consolidate_data-posnr.
              IF sy-subrc NE 0.
                READ TABLE fp_i_contract ASSIGNING <lst_i_contract>
                                               WITH KEY doc_number = lst_consolidate_data-vbeln
                                                        itm_number = lc_posnr_low.
              ENDIF. " IF sy-subrc NE 0
              IF sy-subrc EQ 0.

                lst_consolidate_data-conteddt = <lst_i_contract>-contenddat.

              ENDIF. " IF sy-subrc EQ 0

**get Ship to partner
              READ TABLE fp_i_partner ASSIGNING FIELD-SYMBOL(<lst_i_partner>)
                                          WITH KEY sd_doc = lst_consolidate_data-vbeln
                                                   itm_number = lst_consolidate_data-posnr
                                                   partn_role = lc_ship_to. "WE
              IF sy-subrc NE 0.

                READ TABLE fp_i_partner ASSIGNING <lst_i_partner>
                               WITH KEY sd_doc = lst_consolidate_data-vbeln
                                        itm_number = lc_posnr_low
                                        partn_role = lc_ship_to. "  of type
              ENDIF. " IF sy-subrc NE 0
              IF sy-subrc EQ 0
             AND <lst_i_partner> IS ASSIGNED.
                lst_consolidate_data-ship_to = <lst_i_partner>-customer.
              ENDIF. " IF sy-subrc EQ 0

              IF <lst_i_partner> IS ASSIGNED.
                UNASSIGN <lst_i_partner>.
              ENDIF. " IF <lst_i_partner> IS ASSIGNED

**get Bill to partner
              READ TABLE fp_i_partner ASSIGNING <lst_i_partner>
                                          WITH KEY sd_doc = lst_consolidate_data-vbeln
                                                   itm_number = lst_consolidate_data-posnr
                                                   partn_role = lc_bill_to. "  RE
              IF sy-subrc NE 0.

                READ TABLE fp_i_partner ASSIGNING <lst_i_partner>
                               WITH KEY sd_doc = lst_consolidate_data-vbeln
                                        itm_number = lc_posnr_low
                                        partn_role = lc_bill_to. "  of type
              ENDIF. " IF sy-subrc NE 0
              IF sy-subrc EQ 0
             AND <lst_i_partner> IS ASSIGNED.
                lst_consolidate_data-bill_to = <lst_i_partner>-customer.
              ENDIF. " IF sy-subrc EQ 0

              APPEND lst_consolidate_data TO li_consolidate_data.
              CLEAR: lst_consolidate_data.

              CONTINUE.
            ENDIF. " IF ( sy-batch = abap_true AND <lst_fp_i_final>-eadat IN s_eadat )
          ENDIF. " IF ( <lst_fp_i_final_e095>-consolidate EQ abap_true
*End of ADD:ERP-6343:NGADRE:01-AUG-2018:ED2K912802

          CLEAR lv_actvity.
          lv_actvity = <lst_fp_i_final>-act_status.
          LOOP AT fp_i_partner REFERENCE INTO lr_partner WHERE sd_doc = lr_i_headr->doc_number
                                                               AND itm_number = <lst_fp_i_final_e095>-posnr.
            APPEND lr_partner->* TO li_partner.
*            CLEAR lr_partner->*.
          ENDLOOP. " LOOP AT fp_i_partner REFERENCE INTO lr_partner WHERE sd_doc = lr_i_headr->doc_number
*& Populate Item details.
          CLEAR li_item.
          CLEAR lr_item.
          READ TABLE fp_i_item
          REFERENCE INTO lr_item
          WITH KEY doc_number = lr_i_headr->doc_number
                   itm_number = <lst_fp_i_final_e095>-posnr.
          IF sy-subrc = 0.
            APPEND lr_item->* TO li_item.
*            CLEAR lr_item->*.
          ENDIF. " IF sy-subrc = 0

*         BOC by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
*         Populate BAPI extension
          CLEAR li_ext_vbap.
          CLEAR lr_ext_vbap.
          READ TABLE fp_i_ext_vbap
          REFERENCE INTO lr_ext_vbap
          WITH KEY vbeln = lr_i_headr->doc_number
                   posnr = <lst_fp_i_final_e095>-posnr
          BINARY SEARCH.
          IF sy-subrc EQ 0.
            APPEND lr_ext_vbap->* TO li_ext_vbap.
          ENDIF. " IF sy-subrc EQ 0
*         EOC by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603

          READ TABLE fp_i_business
          REFERENCE INTO lr_business
          WITH KEY sd_doc = lr_i_headr->doc_number
                   itm_number = <lst_fp_i_final_e095>-posnr.
          IF sy-subrc = 0.
            APPEND lr_business->* TO li_business.
          ENDIF. " IF sy-subrc = 0

*         Begin of DEL:ERP-6508:WROY:06-Feb-2018:ED2K910691
*         CLEAR li_contract.
*         End   of DEL:ERP-6508:WROY:06-Feb-2018:ED2K910691
* BOC - BTIRUVATHU - INC0246088- 2019/09/06 - ED1K910931
* As VEDA table may or may not contain line item 10, hence,
* looping the internal table fp_i_contract to get the line
* item.
          READ TABLE fp_i_contract
          REFERENCE INTO lr_contract
          WITH KEY doc_number = lr_i_headr->doc_number
                                itm_number = <lst_fp_i_final_e095>-posnr.
          IF sy-subrc = 0.
            APPEND lr_contract->* TO li_contract.
            CLEAR lr_contract->*.
**         Begin of DEL:ERP-6508:WROY:06-Feb-2018:ED2K910691
**         ELSE.
**           READ TABLE fp_i_contract
**           REFERENCE INTO lr_contract
**           WITH KEY doc_number = lr_i_headr->doc_number
**                                 itm_number = lc_posnr_low.
**           IF sy-subrc = 0.
**             APPEND lr_contract->* TO li_contract.
***             CLEAR lr_contract->*.
**           ENDIF.
**         End   of DEL:ERP-6508:WROY:06-Feb-2018:ED2K910691
          ELSE.
            LOOP AT fp_i_contract REFERENCE INTO lr_contract
* BOC - BTIRUVATHU - INC0338748 - 2021/2/6 - ED1K912661
*              WHERE itm_number GT lc_posnr_low.
              WHERE doc_number EQ lr_i_headr->doc_number
                AND itm_number GT lc_posnr_low.
* EOC - BTIRUVATHU - INC0338748 - 2021/2/6 - ED1K912661
              APPEND lr_contract->* TO li_contract.
              EXIT.
            ENDLOOP.
          ENDIF. " IF sy-subrc = 0
* EOC - BTIRUVATHU - INC0246088- 2019/09/06 - ED1K910931
          CLEAR lv_act_status.
          lv_act_status = <lst_fp_i_final_e095>-act_status.
*& Create Subscription Order: Task 1
          IF  <lst_fp_i_final_e095>-activity = lc_cs AND
              <lst_fp_i_final_e095>-act_status = space.
*Begin of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*            IF  ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat = sy-datum ) OR
*                ( <lst_fp_i_final_e095>-sel = abap_true ).
*End of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*           Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*           IF  ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat LE s_eadat-low ) OR
*           End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*           Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
            IF  ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat IN s_eadat ) OR
*           End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
                ( <lst_fp_i_final_e095>-sel = abap_true ).
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887

              PERFORM f_create_subscription USING li_header
                                                  li_item
                                                  li_partner
                                                  li_textheaders
                                                  li_textlines
                                                  li_contract
                                                  li_business
                                                  fp_i_const
                                                  fp_p_test
                                         CHANGING v_sales_ord
                                                  <lst_fp_i_final_e095>-act_status
                                                  <lst_fp_i_final_e095>-message
                                                  <lst_fp_i_final_e095>-ren_status
                                                  i_return.
            ENDIF. " IF ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat IN s_eadat ) OR
          ENDIF. " IF <lst_fp_i_final_e095>-activity = lc_cs AND
*& create quotation: Task 2
          IF  <lst_fp_i_final>-activity = lc_cq AND
             <lst_fp_i_final>-act_status = space.

*Begin of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*            IF  ( sy-batch = abap_true AND <lst_fp_i_final>-eadat = sy-datum ) OR
*                ( <lst_fp_i_final>-sel = abap_true ).
*End of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*           Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*           IF  ( sy-batch = abap_true AND <lst_fp_i_final>-eadat LE s_eadat-low ) OR
*           End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*           Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
            IF  ( sy-batch = abap_true AND <lst_fp_i_final>-eadat IN s_eadat ) OR
*           End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
                ( <lst_fp_i_final>-sel = abap_true ).
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887

              PERFORM f_create_quoatation USING li_header
                                                li_item
                                                li_business
                                                li_ext_vbap " Added by MODUTTA on 5th-Jun-2018:INC0197849:TR# ED1K907603
                                                li_partner
                                                li_textheaders
                                                li_textlines
                                                li_contract
                                                fp_i_const
                                                fp_p_test
                                         CHANGING v_sales_ord
                                                  <lst_fp_i_final_e095>-act_status
                                                  <lst_fp_i_final_e095>-message
                                                  i_return.
            ENDIF. " IF ( sy-batch = abap_true AND <lst_fp_i_final>-eadat IN s_eadat ) OR

          ENDIF. " IF <lst_fp_i_final>-activity = lc_cq AND
*& create GRACE SUBSCRIPTION: Task 3
          IF  <lst_fp_i_final_e095>-activity = lc_gr.
            IF <lst_fp_i_final_e095>-act_status = abap_false AND <lst_fp_i_final_e095>-ren_status = abap_false.

*Begin of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*              IF  ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat = sy-datum ) OR
*                  ( <lst_fp_i_final_e095>-sel = abap_true ).
*End of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*             Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*             IF  ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat LE s_eadat-low ) OR
*             End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*             Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
              IF  ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat IN s_eadat ) OR
*             End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
                  ( <lst_fp_i_final_e095>-sel = abap_true ).
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
                PERFORM f_create_grace_subs USING li_header
                                                  li_item
*                                                 Begin of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
                                                  li_business
*                                                 End   of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
                                                  li_partner
                                                  li_textheaders
                                                  li_textlines
                                                  li_contract
                                                  fp_i_const
                                                  <lst_fp_i_final_e095>-renwl_prof
                                           CHANGING v_sales_ord
                                                    <lst_fp_i_final_e095>-act_status
                                                    <lst_fp_i_final_e095>-message
                                                    i_return.


              ENDIF. " IF ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat IN s_eadat ) OR

            ENDIF. " IF <lst_fp_i_final_e095>-act_status = abap_false AND <lst_fp_i_final_e095>-ren_status = abap_false
          ENDIF. " IF <lst_fp_i_final_e095>-activity = lc_gr
          IF  <lst_fp_i_final_e095>-act_status = abap_false.
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*           Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*           IF  ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat LE s_eadat-low ) OR
*           End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*           Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
            IF  ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat IN s_eadat ) OR
*           End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
                ( <lst_fp_i_final_e095>-sel = abap_true ).
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
              IF ( <lst_fp_i_final_e095>-activity+0(1) = lc_reminder ).

                PERFORM f_trigger_output_type USING fp_i_const
                                                    li_partner
                                                    fp_i_notif_prof
                                                    fp_i_nast
                                          CHANGING  <lst_fp_i_final_e095>.

              ELSE. " ELSE -> IF ( <lst_fp_i_final_e095>-activity+0(1) = lc_reminder )
                CLEAR lv_reminder.
                lv_reminder = <lst_fp_i_final_e095>-activity.
                READ TABLE fp_i_notif_prof REFERENCE INTO lr_i_notif_prof
                 WITH KEY renwl_prof = <lst_fp_i_final_e095>-renwl_prof
                          notif_rem = lv_reminder.
                IF sy-subrc = 0.
                  PERFORM f_trigger_output_type USING
                                                      fp_i_const
                                                      li_partner
                                                      fp_i_notif_prof
                                                      fp_i_nast
                                            CHANGING  <lst_fp_i_final_e095>.
                ENDIF. " IF sy-subrc = 0
              ENDIF. " IF ( <lst_fp_i_final_e095>-activity+0(1) = lc_reminder )
*Begin of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
            ENDIF. " IF ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat IN s_eadat ) OR
*End of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
          ENDIF. " IF <lst_fp_i_final_e095>-act_status = abap_false
*& lAPSE subscription
          CLEAR: lv_flag,
                 lv_lapsed.
          lv_flag = abap_true.
          IF ( <lst_fp_i_final_e095>-activity = lc_lp ) AND
            <lst_fp_i_final_e095>-act_status = abap_false.
*           Begin of DEL:CR# 546:WROY:03-JUN-2017:ED2K906489
*           PERFORM f_lapase_order USING li_item
*                                        li_header
*                                        lv_flag
*                                  CHANGING <lst_fp_i_final_e095>
*                                           i_return
*                                           lv_lapsed.
*           End   of DEL:CR# 546:WROY:03-JUN-2017:ED2K906489
*           Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
            lv_lapsed = abap_true.
*           End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
            IF lv_lapsed = abap_true.
*& Also Lapse the Quotation created
              LOOP AT fp_i_docflow REFERENCE INTO lr_docflow WHERE precsddoc = <lst_fp_i_final_e095>-vbeln AND
                                                                   preditdoc = <lst_fp_i_final_e095>-posnr AND
                                                                   doccategor = lc_quotation.
                PERFORM f_lapse_quotation USING lr_docflow->subssddoc
                                          CHANGING <lst_fp_i_final_e095>-message
*Begin of Add-Anirban-07.25.2017-ED2K907327-Defect 3479
                                                   <lst_fp_i_final_e095>-act_status
*End of Add-Anirban-07.25.2017-ED2K907327-Defect 3479
                                                  i_return.

              ENDLOOP. " LOOP AT fp_i_docflow REFERENCE INTO lr_docflow WHERE precsddoc = <lst_fp_i_final_e095>-vbeln AND
            ENDIF. " IF lv_lapsed = abap_true


*& cancellation procedure for grace subscription
*& If renewal status is checked and grace subscription exist
*& and current date is more than the grace subscription expiry date
            IF lv_lapsed = abap_true.
*             Begin of DEL:CR# 546:WROY:03-JUN-2017:ED2K906489
*              READ TABLE fp_i_const
*              REFERENCE INTO lr_const WITH KEY devid  = lc_devid
*                                               param1 = lc_param1.
*              IF sy-subrc = 0.
*                lv_doc_type = lr_const->low. " 'ZGRC'.
*                READ TABLE fp_i_final
*                REFERENCE INTO DATA(lr_i_final)
*                WITH TABLE KEY vbeln_key
*                COMPONENTS vbeln = <lst_fp_i_final_e095>-vbeln
*                           posnr = <lst_fp_i_final_e095>-posnr
*                           activity = lc_gr.
*                IF sy-subrc = 0 .
*                  IF lr_i_final->act_status = abap_true.
*                    CLEAR: lst_hd_temp,
*                           lst_item_temp,
*                            li_hd_temp,
*                           li_item_temp.
** Populate Contract items and header
*                    LOOP AT fp_i_veda REFERENCE INTO lr_veda WHERE vbelv = <lst_fp_i_final_e095>-vbeln
*                                                                  AND       auart = lv_doc_type.
*
*                      IF lr_veda->venddat GT sy-datum AND lr_veda->posnn = lc_posnr_low .
**                      IF lr_veda->posnn = lc_posnr_low.
*                        lst_hd_temp-doc_number =   lr_veda->vbeln.
*                        APPEND lst_hd_temp TO li_hd_temp.
*                      ELSEIF lr_veda->posnn <> lc_posnr_low.
*                        lst_item_temp-doc_number = lr_veda->vbeln.
*                        lst_item_temp-itm_number = lr_veda->posnn.
*                        APPEND lst_item_temp TO  li_item_temp.
*                        CLEAR lst_item_temp.
*                      ENDIF.
*
*
**                    ENDIF.
*                    ENDLOOP.
**& Lapse a Subscription
*                    CLEAR lv_flag.
*                    PERFORM f_lapase_order USING li_item_temp
*                                                 li_hd_temp
*                                                 lv_flag
*                                           CHANGING <lst_fp_i_final_e095>
*                                                    i_return
*                                                    lv_lapsed.
*
*
*                  ENDIF.
*
*                ENDIF.
*
*              ENDIF.
*             End   of DEL:CR# 546:WROY:03-JUN-2017:ED2K906489
*&   Lapse Renwal subscription
              READ TABLE fp_i_const
              REFERENCE INTO lr_const WITH KEY devid  = lc_devid
                                               param1 = lc_param2.
              IF sy-subrc = 0.
                lv_doc_type = lr_const->low. " 'ZREW'.
                READ TABLE fp_i_final
                REFERENCE INTO DATA(lr_i_final)
                WITH TABLE KEY vbeln_key
                COMPONENTS vbeln = <lst_fp_i_final_e095>-vbeln
                           posnr = <lst_fp_i_final_e095>-posnr
                           activity = lc_cs.
                IF sy-subrc = 0 .
                  IF lr_i_final->act_status = abap_true.
                    CLEAR: lst_hd_temp,
                           lst_item_temp,
                            li_hd_temp,
                           li_item_temp.
* Populate Contract items and header
                    LOOP AT fp_i_veda REFERENCE INTO lr_veda WHERE vbelv = <lst_fp_i_final_e095>-vbeln
                                                                  AND       auart = lv_doc_type.

                      IF lr_veda->venddat GT sy-datum AND lr_veda->posnn = lc_posnr_low .
*                      IF lr_veda->posnn = lc_posnr_low.
                        lst_hd_temp-doc_number =   lr_veda->vbeln.
                        APPEND lst_hd_temp TO li_hd_temp.
                      ELSEIF lr_veda->posnn <> lc_posnr_low.
                        lst_item_temp-doc_number = lr_veda->vbeln.
                        lst_item_temp-itm_number = lr_veda->posnn.
                        APPEND lst_item_temp TO  li_item_temp.
                        CLEAR lst_item_temp.
                      ENDIF. " IF lr_veda->venddat GT sy-datum AND lr_veda->posnn = lc_posnr_low


*                    ENDIF.
                    ENDLOOP. " LOOP AT fp_i_veda REFERENCE INTO lr_veda WHERE vbelv = <lst_fp_i_final_e095>-vbeln
*& Lapse a renwal  Subscription
                    CLEAR lv_flag.
                    PERFORM f_lapase_order USING li_item_temp
                                                 li_hd_temp
                                                 lv_flag
                                           CHANGING <lst_fp_i_final_e095>
                                                    i_return
                                                    lv_lapsed.


                  ENDIF. " IF lr_i_final->act_status = abap_true

                ENDIF. " IF sy-subrc = 0

              ENDIF. " IF sy-subrc = 0
            ENDIF. " IF lv_lapsed = abap_true
          ENDIF. " IF ( <lst_fp_i_final_e095>-activity = lc_lp ) AND

*& If any activity successfully performed up date the custom table
          IF ( ( <lst_fp_i_final_e095>-act_status = abap_true AND
                  lv_act_status <> <lst_fp_i_final_e095>-act_status ) OR  " OR Condition is added as part of CR# 6295
                  p_test = abap_true ). " Before CR# 6295 changes, no OR p_test = abap_true condition.

            IF lv_act_status <> abap_true. " This IF condition is Added as part of CR# 6295

              MOVE: <lst_fp_i_final_e095>-vbeln TO lr_renewal_plan->vbeln,
                    <lst_fp_i_final_e095>-posnr TO lr_renewal_plan->posnr,
                    <lst_fp_i_final_e095>-renwl_prof TO lr_renewal_plan->renwl_prof,
                    <lst_fp_i_final_e095>-activity TO lr_renewal_plan->activity,
*Begin of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
                    <lst_fp_i_final_e095>-matnr TO lr_renewal_plan->matnr,
*End of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
                    <lst_fp_i_final_e095>-act_status TO lr_renewal_plan->act_status,
                    <lst_fp_i_final_e095>-promo_code TO lr_renewal_plan->promo_code,
                    <lst_fp_i_final_e095>-eadat TO lr_renewal_plan->eadat,
                    <lst_fp_i_final_e095>-ren_status TO lr_renewal_plan->ren_status.
              <lst_fp_i_final_e095>-aedat = lr_renewal_plan->aedat = sy-datum.
              <lst_fp_i_final_e095>-aezet =  lr_renewal_plan->aezet = sy-uzeit.
              <lst_fp_i_final_e095>-aenam = lr_renewal_plan->aenam = sy-uname.

* BOC - CR# 6295 KKRAVURI 2018/09/10  ED2K912739

              IF <lst_fp_i_final_e095>-message IS NOT INITIAL.
                lv_msg_str = <lst_fp_i_final_e095>-message.
                lv_msg_flag = abap_true.
                PERFORM add_pgm_message_log USING lv_msg_str
                                                  c_msg_typ_i
                                                  c_msg_num_0.
              ENDIF.

              PERFORM f_create_log USING    v_1st_var
                                            i_bal_msg
                                   CHANGING v_lognumber.
*** Begin of: KKRAVURI KKR20180912 CR# 6295
              IF <lst_fp_i_final_e095>-lognumber IS NOT INITIAL AND
                v_lognumber IS NOT INITIAL.
                PERFORM f_add_previous_log_msg  USING <lst_fp_i_final_e095>-lognumber
                                                      v_log_handle.
              ENDIF.

              IF v_log_type IS NOT INITIAL.
                <lst_fp_i_final_e095>-log_type  = lr_renewal_plan->log_type  = v_log_type.  " Log Type E/W/S/I
              ENDIF.
              IF v_lognumber IS NOT INITIAL.
                <lst_fp_i_final_e095>-lognumber = lr_renewal_plan->lognumber = v_lognumber. " Log Number (SLG1)
              ENDIF.
              <lst_fp_i_final_e095>-test_run    = lr_renewal_plan->test_run  = fp_p_test.   " Test Run

              IF <lst_fp_i_final_e095>-lognumber IS NOT INITIAL.
                PERFORM f_get_msg_icon  USING    <lst_fp_i_final_e095>-log_type
                                        CHANGING <lst_fp_i_final_e095>-log_type_desc.
              ENDIF.

              MOVE: <lst_fp_i_final_e095>-review_stat TO lr_renewal_plan->review_stat, " Not Reviewed
                    <lst_fp_i_final_e095>-comments    TO lr_renewal_plan->comments.    " No Review Comments

*** Begin of: KKRAVURI KKR20180911 CR# 6295
              IF sy-batch = abap_true.
                GET TIME.
                lv_date = sy-datum.
                lv_time = sy-uzeit.

                <lst_fp_i_final_e095>-jobname = lr_renewal_plan->jobname = lv_job_name.
                <lst_fp_i_final_e095>-job_date = lr_renewal_plan->job_date = lv_date.
                <lst_fp_i_final_e095>-job_time = lr_renewal_plan->job_time = lv_time.
              ENDIF.
*** End of: KKRAVURI KKR20180911 CR# 6295

* EOC - CR# 6295 KKRAVURI 2018/09/10  ED2K912739

              APPEND lr_renewal_plan->* TO li_renewal_plan.
              CLEAR  lr_renewal_plan->*.

*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*           BOC - NPALLA - E096 - 2018/08/31 - ED2K912739
*            COMMIT WORK AND WAIT.          " -ED2K912739
              IF fp_p_test = abap_false.      " +ED2K912739
                COMMIT WORK AND WAIT.         " +ED2K912739
              ENDIF. " IF fp_p_test = abap_false
*           EOC - NPALLA - E096 - 2018/08/31 - ED2K912739
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
            ELSEIF lv_act_status    = abap_true.
              CONCATENATE 'Activity already Preformed'(x01) <lst_fp_i_final_e095>-message INTO <lst_fp_i_final_e095>-message.
              CLEAR lv_act_status.
            ENDIF. " IF ( ( <lst_fp_i_final_e095>-act_status = abap_true ) AND
          ENDIF.
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*& Update ACTIVITY status and message
          READ TABLE fp_i_final ASSIGNING FIELD-SYMBOL(<lst_i_final>) WITH TABLE KEY  vbeln_key COMPONENTS vbeln = <lst_fp_i_final_e095>-vbeln
                                                                                                 posnr = <lst_fp_i_final_e095>-posnr
                                                                                                 activity = <lst_fp_i_final_e095>-activity.
          IF sy-subrc = 0.

            MOVE: <lst_fp_i_final_e095>-message TO <lst_i_final>-message,
                  <lst_fp_i_final_e095>-act_status TO <lst_i_final>-act_status,
                  <lst_fp_i_final_e095>-aedat TO <lst_i_final>-aedat,
                  <lst_fp_i_final_e095>-aenam TO <lst_i_final>-aenam,
                  <lst_fp_i_final_e095>-aezet TO <lst_i_final>-aezet.
*           BOC - NPALLA - E096 - 2018/08/31 - ED2K912739
            MOVE: <lst_fp_i_final_e095>-log_type      TO <lst_i_final>-log_type,      " Log Type E/W/S/I
                  <lst_fp_i_final_e095>-lognumber     TO <lst_i_final>-lognumber,     " Log Number (SLG1)
                  <lst_fp_i_final_e095>-test_run      TO <lst_i_final>-test_run,      " Test Run
                  <lst_fp_i_final_e095>-log_type_desc TO <lst_i_final>-log_type_desc, " Log Type Desc
                  <lst_fp_i_final_e095>-review_stat   TO <lst_i_final>-review_stat,   " Review Status
                  <lst_fp_i_final_e095>-comments      TO <lst_i_final>-comments,      " Review Comments
                  <lst_fp_i_final_e095>-jobname       TO <lst_i_final>-jobname,
                  <lst_fp_i_final_e095>-job_date      TO <lst_i_final>-job_date,
                  <lst_fp_i_final_e095>-job_time      TO <lst_i_final>-job_time.
            IF <lst_i_final>-lognumber IS NOT INITIAL.
              SHIFT <lst_i_final>-lognumber LEFT DELETING LEADING '0'.
            ENDIF.
            IF <lst_i_final>-message IS NOT INITIAL.
              IF lv_msg_flag = abap_false.
                PERFORM add_pgm_message_log USING <lst_i_final>-message
                                                  c_msg_typ_i
                                                  c_msg_num_6. "+ED2K912739
              ENDIF.
            ENDIF. " IF <lst_i_final>-message IS NOT INITIAL
            " Update BAPI Messages to Application Log
            IF i_bal_msg[] IS NOT INITIAL.
              PERFORM f_maintain_log USING v_log_handle
                                           i_bal_msg
                                  CHANGING i_log_handle.
              CLEAR: v_log_handle, v_lognumber, i_bal_msg[], lv_msg_flag.
            ENDIF. " IF i_bal_msg IS NOT INITIAL

            " Save the Messages to Application Log
            IF i_log_handle[] IS NOT INITIAL.
              PERFORM f_save_log USING i_log_handle.
              CLEAR: i_log_handle[], v_log_type.
            ENDIF.
*       EOC - NPALLA - E096 - 2018/08/31 - ED2K912739

          ENDIF. " IF sy-subrc = 0
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
        ENDLOOP. " LOOP AT li_final ASSIGNING FIELD-SYMBOL(<lst_fp_i_final_e095>)

      ENDIF. " IF sy-subrc = 0
    ENDLOOP. " LOOP AT fp_i_header REFERENCE INTO lr_i_headr

*Begin of ADD:ERP-6343:NGADRE:01-AUG-2018:ED2K912802
*execute the create quotation activity and Send reminder activity for all the consolidated lines
    IF li_consolidate_data IS NOT INITIAL.

      SORT li_consolidate_data BY  ship_to       " Ship to Party
                                   bill_to       " Bill to party
                                   vkorg         " sales organisation
                                   division      " division
                                   distr_chan    " distr. channel
                                   sales_off     " sales office
                                   po_method     " po type
                                   waers         " Currency
                                   conteddt      " contract end date
                                   activity      "activity
                                   renwl_profile " Renewal profile
*                                  Begin of ADD:ERP-6343:WROY:28-AUG-2018:ED2K913164
                                   renwl_quote " Renewal Quote
*                                  End   of ADD:ERP-6343:WROY:28-AUG-2018:ED2K913164
                                   renwl_date. " Renewal Date

* process all consolidated line items and create quotation / send reminder
* for selected entries.
      PERFORM f_process_consolidate_data USING  li_consolidate_data
                                                lv_job_name           " Added by KKRAVURI for CR# 6295
                                                fp_i_item
                                                fp_i_business
                                                fp_i_partner
                                                fp_i_textheaders
                                                fp_i_textlines
                                                fp_i_header
                                                fp_i_contract
                                                fp_i_notif_prof
                                                fp_i_renwal
                                                fp_i_ext_vbap
                                                fp_i_veda
                                                fp_i_nast
                                                fp_i_const
                                                li_final
                                                fp_p_test
                                       CHANGING fp_i_final
                                                li_renewal_plan.


    ENDIF. " IF li_consolidate_data IS NOT INITIAL

*End of ADD:ERP-6343:NGADRE:01-AUG-2018:ED2K912802

*Begin of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
**& Update ACTIVITY status and message
*    IF li_final IS NOT INITIAL.
*      LOOP AT li_final ASSIGNING FIELD-SYMBOL(<lst_li_final>) .
*        READ TABLE fp_i_final ASSIGNING FIELD-SYMBOL(<lst_i_final>) WITH TABLE KEY  vbeln_key COMPONENTS vbeln = <lst_li_final>-vbeln
*                                                                                                         posnr = <lst_li_final>-posnr
*                                                                                                         activity = <lst_li_final>-activity.
*        IF sy-subrc = 0.
*
*          MOVE: <lst_li_final>-message TO <lst_i_final>-message,
*                <lst_li_final>-act_status TO <lst_i_final>-act_status,
*                <lst_li_final>-aedat TO <lst_i_final>-aedat,
*                <lst_li_final>-aenam TO <lst_i_final>-aenam,
*                <lst_li_final>-aezet TO <lst_i_final>-aezet.
*        ENDIF.
*
*      ENDLOOP.
*    ENDIF.
*End of Del-Anirban-06.26.2017-ED2K906915-Defect 2887

  ELSEIF p_clear = abap_true AND fp_p_test IS INITIAL.
* Delete entry
    PERFORM f_delete_entry USING fp_i_renwal
                           CHANGING fp_i_final.
  ENDIF. " IF p_clear EQ abap_false

**Begin of Add-Anirban-07.20.2017-ED2K907327-Defect 3301
*  ELSEIF p_status = abap_true AND fp_p_test IS INITIAL.
** Remove status
*    PERFORM f_change_status USING fp_i_renwal
*                           CHANGING fp_i_final.
*
*  ENDIF.
**End of Add-Anirban-07.20.2017-ED2K907327-Defect 3301


*&      om table to reflect the data changes
** BOC - NPALLA - E096 - 2018/08/31 - ED2K912739
* Update the Renewals Table in both Test Mode and Actual Run mode.
*  IF li_renewal_plan IS NOT INITIAL AND fp_p_test IS INITIAL.
  IF ( li_renewal_plan IS NOT INITIAL ).
** EOC - NPALLA - E096 - 2018/08/31 - ED2K912739
    CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL'
      TABLES
        t_renwl_plan = li_renewal_plan.
    COMMIT WORK AND WAIT.
  ENDIF. " IF ( li_renewal_plan IS NOT INITIAL )
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_SUBSCRIPTION
*&---------------------------------------------------------------------*
*       Create Subscription Order
*----------------------------------------------------------------------*
*      -->FP_I_HEADER  Header
*      -->FP_I_ITEM    Item
*      -->FP_I_PARTNER  Partner
*      -->FP_I_TEXTHEADERS  text headers
*      -->FP_I_TEXTLINES  text lines
*      -->FP_I_CONTRACT  Contract
*      <--P_V_SALES_ORD  Sales Order
*      <--FP_I_RETURN  Return table
*----------------------------------------------------------------------*
FORM f_create_subscription  USING    fp_i_header TYPE tt_header
                                   fp_i_item TYPE tt_item
                                   fp_i_partner TYPE tt_partner
                                   fp_i_textheaders TYPE tt_textheaders
                                   fp_i_textlines TYPE tt_textlines
                                   fp_i_contract TYPE tt_contract
                                   fp_i_business TYPE tt_business
                                   fp_const TYPE tt_const
                                   fp_test TYPE char1                  " Test of type CHAR1
                           CHANGING fp_v_salesord TYPE bapivbeln-vbeln " Sales Document
                                    fp_v_act_status   TYPE zact_status " Activity Status
                                    fp_message TYPE char120            " Message of type CHAR120
                                    fp_renwal TYPE  zren_status        " Renewal Status
                                    fp_i_return TYPE  tt_return.

  DATA: lr_header             TYPE REF TO bapisdhd1,                            " Communication Fields: Sales and Distribution Document Header
        lr_const              TYPE REF TO ty_const,                             " Type for Constant
        lr_i_partner          TYPE REF TO bapisdpart,                           " Partner
        lr_i_header           TYPE REF TO  bapisdhd,                            " Header
        li_partner            TYPE STANDARD TABLE OF bapiparnr INITIAL SIZE 0,  " Communications Fields: SD Document Partner: WWW
        li_return             TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0,   " BAPI Return
        lr_partner            TYPE REF TO bapiparnr,                            " Reference variable
        li_item               TYPE STANDARD TABLE OF bapisditm INITIAL SIZE 0,  " Communication Fields: Sales and Distribution Document Item
        lr_item               TYPE REF TO bapisditm,                            "  class
        li_itemx              TYPE STANDARD TABLE OF bapisditmx INITIAL SIZE 0, " Communication Fields: Sales and Distribution Document Item
        lr_i_business         TYPE REF TO bapisdbusi,                           "  class
        lr_sales_contract_in  TYPE  REF TO bapictr ,                            " contract data
        li_sales_contract_in  TYPE STANDARD TABLE OF bapictr ,                  " Internal  table for cond
        lr_sales_contract_inx TYPE REF TO  bapictrx ,                           " Communication fields: SD Contract Data Checkbox
        li_sales_contract_inx TYPE  STANDARD TABLE OF bapictrx INITIAL SIZE 0 , " Communication fields: SD Contract Data Checkbox
        lr_contract           TYPE REF TO bapisdcntr,                           " BAPI Structure of VEDA with English Field Names
        lr_return             TYPE REF TO bapiret2,                             " BAPI Structure of VEDA with English Field Names
        lr_itemx              TYPE REF TO bapisditmx,                           " Communication Fields: Sales and Distribution Document Item
        lr_i_item             TYPE REF TO bapisdit,                             " Structure of VBAP with English Field Names
        lr_headerx            TYPE REF TO bapisdhd1x,                           " Checkbox Fields for Sales and Distribution Document Header
        lv_days               TYPE t5a4a-dlydy,                                 " Days
        lv_year               TYPE t5a4a-dlyyr.                                 " Year
  CONSTANTS:
    lc_contract  TYPE vbtyp VALUE 'G',         " Contract
    lc_error     TYPE bapiret2-type VALUE 'E', " Error
    lc_insert    TYPE updkz_d VALUE 'I',       " Insert
    lc_days      TYPE t5a4a-dlydy VALUE '00',  " Days
    lc_month     TYPE t5a4a-dlymo  VALUE '00', " Month
    lc_year      TYPE t5a4a-dlyyr  VALUE '00', " Year
    lc_devid     TYPE zdevid VALUE 'E096',     "Development ID
    lc_param1    TYPE rvari_vnam VALUE 'CS',   "Parameter1
*Begin of Add-Anirban-09.29.2017-ED2K908670-Defect 4718
    lc_posnr_low TYPE vbap-posnr    VALUE '000000'. " Sales Document Item
*End of Add-Anirban-09.29.2017-ED2K908670-Defect 4718
*---BOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
  DATA:lst_auart     TYPE fssc_dp_s_rg_auart.                        " Workarea for auart
  CONSTANTS:lc_devid_e107   TYPE zdevid       VALUE 'E107', "Development ID
            lc_auart        TYPE rvari_vnam   VALUE 'AUART_CHECK',
            lc_kdkg2        TYPE rvari_vnam   VALUE 'KDKG2',
            lc_period       TYPE vlauf_veda   VALUE '001',                  "Validity period of contract
            lc_categry      TYPE vlauk_veda   VALUE '02',
            lc_sno_e096_003 TYPE zsno         VALUE '003',  "Serial Number
            lc_key_003_e096 TYPE zvar_key     VALUE 'MULTIYEAR', "Var Key
            lc_devid_e096   TYPE zdevid       VALUE 'E096'.

  DATA:lv_venddat         TYPE vndat_veda,
       lst_veda_kopf      TYPE veda,
       lr_kdkg2           TYPE RANGE OF kdkg2,                                     "Contract Data
       lst_kdkg2          TYPE rjksd_mstav_range,                                     "Contract Data
       lst_veda_pos       TYPE veda,                                      "Contract Data
       lv_active_003_e096 TYPE zactive_flag. " Active / Inactive Flag

  IF ir_auart[] IS INITIAL
      OR ir_auart_ck[] IS INITIAL
      OR lr_kdkg2[] IS INITIAL.
* Get data from constant table
    SELECT devid,                       "Development ID
           param1,                      "ABAP: Name of Variant Variable
           param2,                      "ABAP: Name of Variant Variable
           sign ,                       "ABAP: ID: I/E (include/exclude values)
           opti ,                       "ABAP: Selection option (EQ/BT/CP/...)
           low  ,                       "Lower Value of Selection Condition
           high                        "Upper Value of Selection Condition
      FROM zcaconstant                 "Wiley Application Constant Table
      INTO TABLE @DATA(li_consts)
      WHERE devid    = @lc_devid_e107
*        AND param1   = @lc_auart
        AND activate = @abap_true. "Only active record
    IF sy-subrc IS INITIAL.
      SORT li_consts BY devid param1.
    ENDIF.

    LOOP AT li_consts INTO DATA(lst_consts).
      CASE lst_consts-param1.
        WHEN lc_auart.
          IF lst_consts-param2 = 'AUART' .
            lst_auart-sign   = lst_consts-sign.
            lst_auart-option = lst_consts-opti.
            lst_auart-low    = lst_consts-low.
            lst_auart-high   = lst_consts-high.
            APPEND lst_auart TO ir_auart_ck.
            CLEAR: lst_auart,
                   lst_consts.
          ELSE.
            lst_auart-sign   = lst_consts-sign.
            lst_auart-option = lst_consts-opti.
            lst_auart-low    = lst_consts-low.
            lst_auart-high   = lst_consts-high.
            APPEND lst_auart TO ir_auart.
            CLEAR: lst_auart,
                   lst_consts.
          ENDIF.
        WHEN lc_kdkg2.
          lst_kdkg2-sign   = lst_consts-sign.
          lst_kdkg2-option = lst_consts-opti.
          lst_kdkg2-low    = lst_consts-low.
          lst_kdkg2-high   = lst_consts-high.
          APPEND lst_kdkg2 TO lr_kdkg2.
          CLEAR: lst_kdkg2,
                 lst_consts.
      ENDCASE.
    ENDLOOP. " LOOP AT li_const INTO lst_const
  ENDIF.

*---EOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years

  CREATE DATA: lr_header,
               lr_headerx,
               lr_partner,
               lr_i_partner,
               lr_item,
               lr_itemx,
               lr_sales_contract_in,
               lr_sales_contract_inx.
  READ TABLE fp_i_header REFERENCE INTO lr_i_header INDEX 1.
  IF sy-subrc = 0.


    lr_header->sd_doc_cat = lc_contract.
    READ TABLE fp_const REFERENCE INTO lr_const WITH KEY devid  = lc_devid
                                                         param1 = lc_param1.
    IF sy-subrc = 0.
      lr_header->doc_type = lr_const->low. " 'ZREW'.
    ENDIF. " IF sy-subrc = 0

    lr_header->sales_org = lr_i_header->sales_org.
    lr_header->distr_chan = lr_i_header->distr_chan.
    lr_header->division = lr_i_header->division.
*   Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
    lr_header->sales_off = lr_i_header->sales_off.
    lr_header->po_method = lr_i_header->po_method.
*   End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
* Begin by AMOHAMMED on 09/25/2020 TR # ED2K919624
    lr_header->sales_grp = lr_i_header->sales_grp.
* End by AMOHAMMED on 09/25/2020 TR # ED2K919624
    lr_header->ref_doc = lr_i_header->doc_number. "low.
    lr_header->ref_doc_l = lr_i_header->doc_number.
    lr_header->refdoc_cat = lc_contract. "'G'.
    lr_header->refdoctype = lc_contract. "'G'.
    lr_header->ref_1 = lr_i_header->doc_number.
*   Begin of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    lr_header->currency = lr_i_header->currency.
*   End   of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    lr_headerx->refdoc_cat = abap_true.
    lr_headerx->doc_type = abap_true.
    lr_headerx->sales_org = abap_true.
    lr_headerx->distr_chan = abap_true.
    lr_headerx->division = abap_true.
*   Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
    lr_headerx->sales_off = abap_true.
    lr_headerx->po_method = abap_true.
*   End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
* Begin by AMOHAMMED on 09/25/2020 TR # ED2K919624
    lr_headerx->sales_grp = abap_true.
* End by AMOHAMMED on 09/25/2020 TR # ED2K919624
    lr_headerx->ref_doc = abap_true.
    lr_headerx->ref_1 = abap_true.
*   Begin of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    lr_headerx->currency = abap_true.
*   End   of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    lr_headerx->updateflag = lc_insert.

*   Begin of ADD:ERP-5850:WROY:10-Jan-2018:ED2K910239
    READ TABLE fp_i_business REFERENCE INTO lr_i_business WITH KEY sd_doc     = lr_i_header->doc_number
                                                                   itm_number = lc_posnr_low.
    IF sy-subrc EQ 0.
      lr_header->purch_no_c	 = lr_i_business->purch_no_c. "Customer purchase order number
      lr_headerx->purch_no_c = abap_true. "Customer purchase order number
*         Begin of ADD:ERP-7825:PRABHU:13-Feb-2019:ED2K913145
      lr_header->pmnttrms = lr_i_business->pmnttrms. "Payment terms
      lr_headerx->pmnttrms = abap_true. "Payment terms
*         End of ADD:ERP-7825:PRABHU:13-Feb-2019:ED2K913145
*       Begin of Add:ERP-7873:PRABHU:21-FEb-2019:ED2K914490
      lr_header->pymt_meth = lr_i_business->paymethode.
      lr_headerx->pymt_meth = abap_true.
*       End of Add:ERP-7873:PRABHU:21-FEb-2019:ED2K914490
    ENDIF. " IF sy-subrc EQ 0
*   End   of ADD:ERP-5850:WROY:10-Jan-2018:ED2K910239
*   Begin of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
    READ TABLE fp_i_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_header->doc_number
                                                                 itm_number = lc_posnr_low.
    IF sy-subrc = 0.
      lr_sales_contract_in->itm_number  = lc_posnr_low.
      lr_sales_contract_inx->itm_number = lc_posnr_low.
      lr_sales_contract_inx->updateflag = lc_insert.
      lr_sales_contract_in->con_en_act  = lr_contract->contendact. "Action at end of contract
      lr_sales_contract_inx->con_en_act = abap_true. "Action at end of contract

      CLEAR lv_year.
      MOVE 1 TO lv_year.
      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
        EXPORTING
          date      = lr_contract->actiondate           "Date for action
          days      = lc_days
          months    = lc_month
          years     = lv_year
        IMPORTING
          calc_date = lr_sales_contract_in->action_dat. "Date for action
      lr_sales_contract_inx->action_dat = abap_true.
      APPEND lr_sales_contract_in->* TO li_sales_contract_in.
      CLEAR lr_sales_contract_in->*.
      APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
      CLEAR lr_sales_contract_inx->*.
    ENDIF. " IF sy-subrc = 0
*   End   of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
    "READ TABLE fp_i_business REFERENCE INTO lr_i_business WITH KEY itm_number =    lr_i_item->itm_number.
    "IF sy-subrc = 0.
    "lr_header->payment_methods = lr_i_business->paymethode.
    "lr_headerx->payment_methods = abap_true.
    "ELSE.
    "READ TABLE fp_i_business REFERENCE INTO lr_i_business WITH KEY itm_number = '0000'.
    "IF sy-subrc = 0.
    "lr_header->payment_methods = lr_i_business->paymethode.
    "lr_headerx->payment_methods = abap_true.
    "ENDIF.
    "ENDIF.

    LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE customer IS NOT INITIAL.
      lr_partner->partn_role = lr_i_partner->partn_role.
      lr_partner->partn_numb = lr_i_partner->customer.
      lr_partner->itm_number = lr_i_partner->itm_number.
      APPEND lr_partner->* TO li_partner.
      CLEAR lr_partner->*.
    ENDLOOP. " LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE customer IS NOT INITIAL
    LOOP AT fp_i_item REFERENCE INTO lr_i_item.
      lr_item->itm_number = lr_i_item->itm_number.
      lr_itemx->itm_number = lr_i_item->itm_number.
      lr_item->item_categ =  lr_i_item->item_categ.
* Customer purchase order type
      READ TABLE fp_i_business REFERENCE INTO lr_i_business WITH KEY itm_number =    lr_i_item->itm_number.
      IF sy-subrc = 0.
        lr_header->pymt_meth = lr_i_business->paymethode.
        lr_headerx->pymt_meth = abap_true.
        lr_item->po_method = lr_i_business->po_method.
        lr_itemx->po_method = abap_true.
        lr_item->ref_1 = lr_i_business->ref_1.
        lr_itemx->ref_1 = abap_true.
*       Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
        lr_item->cust_group  = lr_i_business->cust_group. "Customer Group
        lr_itemx->cust_group = abap_true. "Customer Group
        lr_item->price_grp   = lr_i_business->price_grp. "Price Group (Customer)
        lr_itemx->price_grp  = abap_true. "Price Group (Customer)
*       End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
*       Begin of ADD:ERP-6344:WROY:20-AUG-2018:ED2K913145
        lr_item->cstcndgrp1  = lr_i_business->custcongr1.
        lr_itemx->cstcndgrp1 = abap_true.
        lr_item->cstcndgrp2  = lr_i_business->custcongr2.
        lr_itemx->cstcndgrp2 = abap_true.
        lr_item->cstcndgrp3  = lr_i_business->custcongr3.
        lr_itemx->cstcndgrp3 = abap_true.
        lr_item->cstcndgrp4  = lr_i_business->custcongr4.
        lr_itemx->cstcndgrp4 = abap_true.
        lr_item->cstcndgrp5  = lr_i_business->custcongr5.
        lr_itemx->cstcndgrp5 = abap_true.
*       End   of ADD:ERP-6344:WROY:20-AUG-2018:ED2K913145
*         Begin of ADD:ERP-7825:PRABHU:13-Feb-2019:ED2K913145
        lr_item->pmnttrms = lr_i_business->pmnttrms. "Payment terms
        lr_itemx->pmnttrms = abap_true. "Payment terms
*         End of ADD:ERP-7825:PRABHU:13-Feb-2019:ED2K913145
**** Begin of adding by Lahiru on 07/09/2020 for ERPM-16504 with ED2K918829 ****
        lr_item->purch_no_c = lr_i_business->purch_no_c.      " Customer purchase order no
        lr_itemx->purch_no_c = abap_true.
**** End of adding by Lahiru on 07/09/2020 ERPM-16504 with ED2K918829 ****
      ELSE. " ELSE -> IF sy-subrc = 0
        READ TABLE fp_i_business REFERENCE INTO lr_i_business WITH KEY itm_number = '0000'.
        IF sy-subrc = 0.
          lr_header->pymt_meth = lr_i_business->paymethode.
          lr_headerx->pymt_meth = abap_true.
          lr_item->po_method = lr_i_business->po_method.
          lr_itemx->po_method = abap_true.
          lr_item->ref_1 = lr_i_business->ref_1.
          lr_itemx->ref_1 = abap_true.
*         Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
          lr_item->cust_group  = lr_i_business->cust_group. "Customer Group
          lr_itemx->cust_group = abap_true. "Customer Group
          lr_item->price_grp   = lr_i_business->price_grp. "Price Group (Customer)
          lr_itemx->price_grp  = abap_true. "Price Group (Customer)
*         End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
*         Begin of ADD:ERP-6344:WROY:20-AUG-2018:ED2K913145
          lr_item->cstcndgrp1  = lr_i_business->custcongr1.
          lr_itemx->cstcndgrp1 = abap_true.
          lr_item->cstcndgrp2  = lr_i_business->custcongr2.
          lr_itemx->cstcndgrp2 = abap_true.
          lr_item->cstcndgrp3  = lr_i_business->custcongr3.
          lr_itemx->cstcndgrp3 = abap_true.
          lr_item->cstcndgrp4  = lr_i_business->custcongr4.
          lr_itemx->cstcndgrp4 = abap_true.
          lr_item->cstcndgrp5  = lr_i_business->custcongr5.
          lr_itemx->cstcndgrp5 = abap_true.
*         End   of ADD:ERP-6344:WROY:20-AUG-2018:ED2K913145
*         Begin of ADD:ERP-7825:PRABHU:13-Feb-2019:ED2K913145
          lr_item->pmnttrms = lr_i_business->pmnttrms. "Payment terms
          lr_itemx->pmnttrms = abap_true. "Payment terms
*         End of ADD:ERP-7825:PRABHU:13-Feb-2019:ED2K913145
**** Begin of adding by Lahiru on 07/09/2020 for ERPM-16504 with ED2K918829 ****
          lr_item->purch_no_c = lr_i_business->purch_no_c.      " Customer purchase order no
          lr_itemx->purch_no_c = abap_true.
**** End of adding by Lahiru on 07/09/2020 ERPM-16504 with ED2K918829 ****
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF sy-subrc = 0

*Begin of Add-NPALLA-05.15.2019-ED1K910179-INC0241861
      LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE itm_number = lr_i_item->itm_number
                                                       OR itm_number = lc_posnr_low .
        lr_partner->partn_role = lr_i_partner->partn_role.
        IF NOT lr_i_partner->customer IS INITIAL.
          lr_partner->partn_numb = lr_i_partner->customer.
        ELSEIF NOT lr_i_partner->vendor_no IS INITIAL.
          lr_partner->partn_numb = lr_i_partner->vendor_no.
        ELSEIF NOT lr_i_partner->person_no IS INITIAL..
          lr_partner->partn_numb = lr_i_partner->person_no.
        ENDIF. " IF NOT lr_i_partner->customer IS INITIAL
        lr_partner->itm_number = lr_i_partner->itm_number.
        APPEND lr_partner->* TO li_partner.
        CLEAR lr_partner->*.
      ENDLOOP. " LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE itm_number = lr_i_item->itm_number
      SORT li_partner BY partn_role partn_numb.
      DELETE ADJACENT DUPLICATES FROM li_partner COMPARING partn_role partn_numb.
*End of Add-NPALLA-05.15.2019-ED1K910179-INC0241861

      READ TABLE fp_i_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_item->doc_number
                                                                    itm_number = lr_i_item->itm_number.
      IF sy-subrc = 0.
        lr_sales_contract_in->itm_number = lr_i_item->itm_number.
        lr_sales_contract_inx->itm_number = lr_i_item->itm_number.
        lr_sales_contract_inx->updateflag = lc_insert.
*---BOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years

        lr_sales_contract_in->con_en_rul   = lr_contract->contendrul.
*----Below Enhancement Control - Active - new code and Deactive - old code will execute
        FREE:lv_active_003_e096.
        CALL FUNCTION 'ZCA_ENH_CONTROL'
          EXPORTING
            im_wricef_id   = lc_devid_e096
            im_ser_num     = lc_sno_e096_003
            im_var_key     = lc_key_003_e096
          IMPORTING
            ex_active_flag = lv_active_003_e096.
        IF lv_active_003_e096 = abap_true.
          IF lr_header->doc_type IN ir_auart.
            SELECT SINGLE auart FROM vbak INTO @DATA(lv_auart_ref) WHERE vbeln = @lr_header->ref_doc.
            IF lv_auart_ref IN ir_auart_ck[].
              FREE:lst_veda_kopf,lst_veda_pos,lv_venddat.
              lst_veda_kopf-vbegdat = lr_sales_contract_in->con_st_dat = lr_contract->contenddat + 1.
              lst_veda_kopf-vlaufz  = lr_sales_contract_in->val_per    = lr_contract->val_per.
              lst_veda_kopf-vlauez  = lr_sales_contract_in->val_per_un = lr_contract->valperunit.
              lst_veda_kopf-vlaufk  = lr_sales_contract_in->val_per_ca = lr_contract->valpercat.
              lst_veda_kopf-vendreg = lr_sales_contract_in->con_en_rul = lr_contract->contendrul.

              IF lr_header->doc_type IN ir_auart[].
                IF lr_item->cstcndgrp2 IN lr_kdkg2[].
                  lst_veda_kopf-vlaufz = lr_sales_contract_in->val_per    = lc_period ."'001'.
                  lst_veda_kopf-vlaufk = lr_sales_contract_in->val_per_ca = lc_categry."'02'.
                ENDIF.
              ENDIF.


              MOVE-CORRESPONDING lst_veda_kopf TO lst_veda_pos.
              CALL FUNCTION 'SD_VEDA_GET_DATE'
                EXPORTING
                  i_regel                    = lst_veda_pos-vendreg    "Date rule
                  i_veda_kopf                = lst_veda_kopf          "Acceptance date
                  i_veda_pos                 = lst_veda_pos           "Contract Start Date
                IMPORTING
                  e_datum                    = lv_venddat             "Target date
                EXCEPTIONS
                  basedate_and_cal_not_found = 1
                  basedate_is_initial        = 2
                  basedate_not_found         = 3
                  cal_error                  = 4
                  rule_not_found             = 5
                  timeframe_not_found        = 6
                  wrong_month_rule           = 7
                  OTHERS                     = 8.
              IF sy-subrc EQ 0.
                lr_sales_contract_in->con_en_dat   = lv_venddat.                    "Contract End Date
              ENDIF.
              lr_sales_contract_inx->con_st_dat  = abap_true.
              lr_sales_contract_inx->con_en_dat  =  abap_true.
              lr_sales_contract_inx->con_en_rul  =  abap_true.
*          lr_sales_contract_inx->con_st_rul  =  abap_true.
              lr_sales_contract_inx->val_per     =  abap_true.
              lr_sales_contract_inx->val_per_un  =  abap_true.
              lr_sales_contract_inx->val_per_ca  =  abap_true.
              lr_item->price_date = lr_sales_contract_in->con_st_dat.
              lr_itemx->price_date = abap_true.

              lr_header->price_date = lr_sales_contract_in->con_st_dat.
*Begin of Add-Anirban-07.26.2017-ED2K907606-Defect 3335
              lr_headerx->price_date = abap_true.
              lr_headerx->sd_doc_cat = abap_true.
              lr_headerx->ref_doc_l = abap_true.
              APPEND lr_sales_contract_in->* TO li_sales_contract_in.
              CLEAR lr_sales_contract_in->*.
              APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
              CLEAR lr_sales_contract_inx->*.
            ENDIF.
*End of Add-Anirban-07.26.2017-ED2K907606-Defect 3335
          ELSE.
*---EOC VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
            lr_sales_contract_in->con_st_dat = lr_contract->contenddat.
            CLEAR lv_days.
            MOVE 1 TO lv_days.
            CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
              EXPORTING
                date      = lr_sales_contract_in->con_st_dat
                days      = lv_days
                months    = lc_month
                years     = lc_year
              IMPORTING
                calc_date = lr_sales_contract_in->con_st_dat.

            lr_sales_contract_inx->con_st_dat = abap_true.

            lr_header->price_date = lr_sales_contract_in->con_st_dat.
*Begin of Add-Anirban-07.26.2017-ED2K907606-Defect 3335
            lr_headerx->price_date = abap_true.
            lr_headerx->sd_doc_cat = abap_true.
            lr_headerx->ref_doc_l = abap_true.
*End of Add-Anirban-07.26.2017-ED2K907606-Defect 3335

            CLEAR lv_year.
            MOVE 1 TO lv_year.
            CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
              EXPORTING
                date      = lr_sales_contract_in->con_st_dat
                days      = lc_days
                months    = lc_month
                years     = lv_year
              IMPORTING
                calc_date = lr_sales_contract_in->con_en_dat.
            lr_sales_contract_in->con_en_dat = lr_sales_contract_in->con_en_dat - 1.
            lr_sales_contract_inx->con_en_dat = abap_true.
            APPEND lr_sales_contract_in->* TO li_sales_contract_in.
            CLEAR lr_sales_contract_in->*.
            APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
            CLEAR lr_sales_contract_inx->*.
*----BOC of VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years
          ENDIF. " IF lr_header->doc_type IN ir_auart.
        ELSE. "IF lv_active_003_e096 = abap_true.
          lr_sales_contract_in->con_st_dat = lr_contract->contenddat.
          CLEAR lv_days.
          MOVE 1 TO lv_days.
          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              date      = lr_sales_contract_in->con_st_dat
              days      = lv_days
              months    = lc_month
              years     = lc_year
            IMPORTING
              calc_date = lr_sales_contract_in->con_st_dat.

          lr_sales_contract_inx->con_st_dat = abap_true.

          lr_header->price_date = lr_sales_contract_in->con_st_dat.
          lr_headerx->price_date = abap_true.
          lr_headerx->sd_doc_cat = abap_true.
          lr_headerx->ref_doc_l = abap_true.

          CLEAR lv_year.
          MOVE 1 TO lv_year.
          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              date      = lr_sales_contract_in->con_st_dat
              days      = lc_days
              months    = lc_month
              years     = lv_year
            IMPORTING
              calc_date = lr_sales_contract_in->con_en_dat.
          lr_sales_contract_in->con_en_dat = lr_sales_contract_in->con_en_dat - 1.
          lr_sales_contract_inx->con_en_dat = abap_true.
          APPEND lr_sales_contract_in->* TO li_sales_contract_in.
          CLEAR lr_sales_contract_in->*.
          APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
          CLEAR lr_sales_contract_inx->*.
        ENDIF.  "IF lv_active_003_e096 = abap_true.
*----EOC of VDPATABALL 08/04/2021 OTCM-37069 multi-year contracts to renew as multiple years

*Begin of Del-Anirban-09.29.2017-ED2K908670-Defect 4718
*      ENDIF.
*End of Del-Anirban-09.29.2017-ED2K908670-Defect 4718

*Begin of Add-Anirban-09.29.2017-ED2K908670-Defect 4718
      ELSE. " ELSE -> IF sy-subrc = 0
        READ TABLE fp_i_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_item->doc_number
                                                                             itm_number = lc_posnr_low.
        IF sy-subrc = 0.
*         Begin of DEL:ERP-6283:WROY:31-Jan-2018:ED2K910611
*         lr_sales_contract_in->itm_number = lc_posnr_low.
*         lr_sales_contract_inx->itm_number = lc_posnr_low.
*         End   of DEL:ERP-6283:WROY:31-Jan-2018:ED2K910611
*         Begin of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
          lr_sales_contract_in->itm_number = lr_i_item->itm_number.
          lr_sales_contract_inx->itm_number = lr_i_item->itm_number.
*         End   of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
          lr_sales_contract_inx->updateflag = lc_insert.
          lr_sales_contract_in->con_st_dat = lr_contract->contenddat.
          CLEAR lv_days.
          MOVE 1 TO lv_days.
          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              date      = lr_sales_contract_in->con_st_dat
              days      = lv_days
              months    = lc_month
              years     = lc_year
            IMPORTING
              calc_date = lr_sales_contract_in->con_st_dat.

          lr_sales_contract_inx->con_st_dat = abap_true.

          lr_header->price_date = lr_sales_contract_in->con_st_dat.
          lr_headerx->price_date = abap_true.
          lr_headerx->sd_doc_cat = abap_true.
          lr_headerx->ref_doc_l = abap_true.

          CLEAR lv_year.
          MOVE 1 TO lv_year.
          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              date      = lr_sales_contract_in->con_st_dat
              days      = lc_days
              months    = lc_month
              years     = lv_year
            IMPORTING
              calc_date = lr_sales_contract_in->con_en_dat.
          lr_sales_contract_in->con_en_dat = lr_sales_contract_in->con_en_dat - 1.
          lr_sales_contract_inx->con_en_dat = abap_true.
          APPEND lr_sales_contract_in->* TO li_sales_contract_in.
          CLEAR lr_sales_contract_in->*.
          APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
          CLEAR lr_sales_contract_inx->*.
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF sy-subrc = 0
*End of Add-Anirban-09.29.2017-ED2K908670-Defect 4718

      lr_itemx->updateflag = lc_insert.
      lr_item->material =  lr_i_item->material.
      lr_itemx->material = abap_true.
*     Begin of ADD:ERP-6343:WROY:28-AUG-2018:ED2K913164
      lr_item->cust_mat35 = lr_i_item->cust_mat35.
      lr_itemx->cust_mat35 = abap_true.
*     End   of ADD:ERP-6343:WROY:28-AUG-2018:ED2K913164
      lr_item->target_qty =  lr_i_item->target_qty .
      lr_item->target_qu = lr_i_item->target_qu.
*--*BOC OTCM-40816 ED2K922409 Prabhu 3/9/2021
*      lr_item->plant = lr_i_item->plant.
*--*EOC OTCM-40816 ED2K922409 Prabhu 3/9/2021
      lr_itemx->target_qty = abap_true.
      IF NOT lr_i_item->ref_doc IS INITIAL.
        lr_item->ref_doc  =   lr_i_item->ref_doc.
        lr_itemx->ref_doc = abap_true.
      ENDIF. " IF NOT lr_i_item->ref_doc IS INITIAL
      IF NOT lr_i_item->posnr_vor IS INITIAL.
        lr_item->ref_doc_it = lr_i_item->posnr_vor.
        lr_itemx->ref_doc_it = abap_true.
      ENDIF. " IF NOT lr_i_item->posnr_vor IS INITIAL
      IF lr_i_item->doc_cat_sd IS NOT INITIAL.
        lr_item->ref_doc_ca = lr_i_item->doc_cat_sd.
        lr_itemx->ref_doc_ca = abap_true.
      ENDIF. " IF lr_i_item->doc_cat_sd IS NOT INITIAL
      lr_item->ref_doc = lr_header->ref_doc.
      lr_item->ref_doc_it = lr_i_item->itm_number.
      lr_item->ref_doc_ca = lc_contract.

      APPEND lr_item->* TO li_item.
      CLEAR lr_item->*.
      APPEND lr_itemx->* TO li_itemx.
      CLEAR lr_itemx->*.
    ENDLOOP. " LOOP AT fp_i_item REFERENCE INTO lr_i_item

* BOC - GKINTALI - INC0202201 - 2018/08/27 - ED1K908393
* To update the order number in the message log for tracking purpose.
    IF sy-batch = abap_true.
      MESSAGE s006(zqtc_r2) WITH lr_header->ref_doc. " Order being processed : & .
    ENDIF. " IF sy-batch = abap_true
* EOC - GKINTALI - INC0202201 - 2018/08/27 - ED1K908393

* BOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739
*    IF v_1st_var IS INITIAL. "+ED2K912739
*      v_1st_var = lr_header->ref_doc. "+ED2K912739
*    ENDIF. " IF v_1st_var IS INITIAL
*    v_msgv1 = lr_header->ref_doc. "+ED2K912739
*    PERFORM add_message_log USING 'S' 'ZQTC_R2' '006'        "+ED2K912739
*                                  v_msgv1 space space space. "+ED2K912739
* EOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739

    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        sales_header_in       = lr_header->*
        sales_header_inx      = lr_headerx->*
        int_number_assignment = abap_true
        testrun               = fp_test
      IMPORTING
        salesdocument_ex      = fp_v_salesord
      TABLES
        return                = li_return
        sales_items_in        = li_item
        sales_items_inx       = li_itemx
        sales_partners        = li_partner
        sales_contract_in     = li_sales_contract_in
        sales_contract_inx    = li_sales_contract_inx
        textheaders_ex        = fp_i_textheaders
        textlines_ex          = fp_i_textlines.
*   BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
    LOOP AT li_return INTO st_return. "+ED2K912739
      PERFORM add_message_log USING st_return-type st_return-id st_return-number "+ED2K912739
                                    st_return-message_v1 st_return-message_v2    "+ED2K912739
                                    st_return-message_v3 st_return-message_v4.   "+ED2K912739
      CLEAR st_return.
    ENDLOOP. " LOOP AT li_return INTO st_return
*   EOC - NPALLA - E096 - 2018/08/27 - ED2K912739
    READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = lc_error.
    IF sy-subrc <> 0.
      IF fp_test = space.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
        fp_v_act_status = abap_true.
        fp_renwal = abap_true.
        CONCATENATE 'Renewal Subscription'(a07) fp_v_salesord text-a08 INTO
        fp_message SEPARATED BY space.

      ELSE. " ELSE -> IF fp_test = space
*       Begin of ADD:SAP's Recommendations:WROY:01-Mar-2018:ED2K911135
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*       End   of ADD:SAP's Recommendations:WROY:01-Mar-2018:ED2K911135
        "CONCATENATE 'Renewal Subscription can be applied'(x13) fp_v_salesord text-a08 INTO
        "fp_message.
        CONCATENATE 'Renewal Subscription can be generated'(x13) ' ' INTO
        fp_message.
      ENDIF. " IF fp_test = space

    ELSE. " ELSE -> IF sy-subrc <> 0
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      APPEND LINES OF li_return TO fp_i_return.
      MOVE 'Renewal Subscription failed with error'(a09) TO fp_message.
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_GRACE_SUBS
*&---------------------------------------------------------------------*
*       Create Grace Subscription
*----------------------------------------------------------------------*
*      -->FP_I_HEADER  Header
*      -->FP_I_ITEM    Items
*      -->FP_I_PARTNER  Partner
*      -->FP_I_TEXTHEADERS  text Header
*      -->FP_I_TEXTLINES  Text lines
*      -->FP_I_CONTRACT  Contract
*      <--FP_V_SALES_ORD Sales Order
*      <--FP_I_RETURN  BAPI return
*----------------------------------------------------------------------*
FORM f_create_grace_subs  USING    fp_i_header TYPE tt_header
                                   fp_i_item TYPE tt_item
*                                  Begin of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
                                   fp_i_business TYPE tt_business
*                                  End   of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
                                   fp_i_partner TYPE tt_partner
                                   fp_i_textheaders TYPE tt_textheaders
                                   fp_i_textlines TYPE tt_textlines
                                   fp_i_contract TYPE tt_contract
                                   fp_const TYPE tt_const
                                   fp_renwl_prof TYPE zrenwl_prof      " Renewal Profile
                           CHANGING fp_v_salesord TYPE bapivbeln-vbeln " Sales Document
                                    fp_v_act_status   TYPE zact_status " Activity Status

                                    fp_message TYPE char120            " Message of type CHAR120
                                    fp_i_return TYPE  tt_return.
  TYPES:
*   Begin of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910272
    BEGIN OF lty_tvcpa,
      auarn TYPE auart_nach, " Copying control: Target sales document type
      auarv TYPE auart_von,  " Copying control: Reference document type
      pstyv TYPE pstyv_von,  " Reference item category
      pstyn TYPE pstyv_nach, " Default item category
    END OF lty_tvcpa,
    ltt_tvcpa TYPE STANDARD TABLE OF lty_tvcpa INITIAL SIZE 0,
*   End   of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910272
    BEGIN OF lty_renwl_p_det,
      renwl_prof   TYPE zrenwl_prof,   " Renewal Profile
      quote_time   TYPE zquote_tim,    " Quote Timing
      notif_prof   TYPE znotif_prof,   " Notification Profile
      grace_start  TYPE zgrace_start,  " Grace Start Timing
      grace_period TYPE zgrace_period, " Grace Period
      auto_renew   TYPE zauto_renew,   " Auto Renew Timing
      lapse        TYPE zlapse,        " Lapse
    END OF   lty_renwl_p_det,
    ltt_renwl_p_det TYPE STANDARD TABLE OF lty_renwl_p_det
         INITIAL SIZE 0.
* Begin of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910272
  STATICS: li_tvcpa TYPE ltt_tvcpa.
* End   of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910272
  DATA   li_renwl_plan TYPE ltt_renwl_p_det.
  DATA: lr_header             TYPE REF TO bapisdhd1,                            "  Order type
        lr_const              TYPE REF TO ty_const,                             " Constant  table
        lr_i_partner          TYPE REF TO bapisdpart,                           " Partner
        lr_notif_prof         TYPE REF TO lty_renwl_p_det,                      " Renwl plan determination
        lr_i_header           TYPE REF TO  bapisdhd,                            " Order header
        li_partner            TYPE STANDARD TABLE OF bapiparnr INITIAL SIZE 0,  " Partner details
        lr_sales_contract_in  TYPE  REF TO bapictr ,                            " contract data
        li_sales_contract_in  TYPE STANDARD TABLE OF bapictr ,                  " Internal  table for cond
        lr_sales_contract_inx TYPE REF TO  bapictrx ,                           " Communication fields: SD Contract Data Checkbox
        li_sales_contract_inx TYPE  STANDARD TABLE OF bapictrx INITIAL SIZE 0 , " Communication fields: SD Contract Data Checkbox
        li_return             TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0,   " Bapi return
        lr_partner            TYPE REF TO bapiparnr,                            " reference variable
        li_item               TYPE STANDARD TABLE OF bapisditm INITIAL SIZE 0,  " Item details
        lr_item               TYPE REF TO bapisditm,                            " reference variables
        li_itemx              TYPE STANDARD TABLE OF bapisditmx INITIAL SIZE 0, " Itemx parameter
*       Begin of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
        lr_i_business         TYPE REF TO bapisdbusi, "  class
*       End   of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
        lr_contract           TYPE REF TO bapisdcntr, " contrat details
        lr_return             TYPE REF TO bapiret2,   " Return table
        lr_itemx              TYPE REF TO bapisditmx, "  class
        lst_bapisdls          TYPE bapisdls,          " SD Checkbox for the Logic Switch
        lr_i_item             TYPE REF TO bapisdit,   " Reference variable
        lv_days               TYPE t5a4a-dlydy,       " No days
*       Begin of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
        lv_year               TYPE t5a4a-dlyyr, " Year
*       End   of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
        lv_tabix              TYPE i,                 " Index
        lr_headerx            TYPE REF TO bapisdhd1x. " Headerx reference variable
  CONSTANTS:
    lc_contract  TYPE vbtyp VALUE 'G',           " contract
    lc_posnr_low TYPE vbap-vbeln VALUE '000000', " Posner low
    lc_devid     TYPE zdevid VALUE 'E096',       "Development ID
    lc_param1    TYPE rvari_vnam VALUE 'GR',     "Parameter1
    lc_insert    TYPE char1 VALUE 'I',           " Insert data
*   Begin of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
    lc_days      TYPE t5a4a-dlydy  VALUE '00', " Days
*   End   of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
    lc_month     TYPE t5a4a-dlymo  VALUE '00', " Month
    lc_year      TYPE t5a4a-dlyyr  VALUE '00', " Year
    lc_g         TYPE knprs VALUE 'G'.         " Copy prices  and determine the taxes
  CREATE DATA: lr_header,
                lr_headerx,
                lr_partner,
                lr_i_partner,
                lr_sales_contract_in,
                lr_sales_contract_inx,
                lr_item,
                lr_itemx.
  SELECT renwl_prof              " Renewal Profile
  quote_time                     " Quote Timing
  notif_prof                     " Notification Profile
  grace_start                    " Grace Start Timing
  grace_period                   " Grace Period
  auto_renew                     " Auto Renew Timing
  lapse                          " Lapse
    FROM zqtc_renwl_p_det        " E095: Renewal Profile Details Table
    INTO TABLE li_renwl_plan
    WHERE
    renwl_prof = fp_renwl_prof . "renwl_prof  .
  IF sy-subrc = 0.
    READ TABLE fp_i_header REFERENCE INTO lr_i_header INDEX 1.
    IF sy-subrc = 0.


      lr_header->sd_doc_cat = lc_contract.
      READ TABLE fp_const REFERENCE INTO lr_const WITH KEY devid  = lc_devid
                                                           param1 = lc_param1.
      IF sy-subrc = 0.
        lr_header->doc_type = lr_const->low. " 'ZREW'.
      ENDIF. " IF sy-subrc = 0
      lr_header->sales_org = lr_i_header->sales_org.
      lr_header->distr_chan = lr_i_header->distr_chan.
      lr_header->division = lr_i_header->division.
*     Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
      lr_header->sales_off = lr_i_header->sales_off.
*     End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
      lr_header->ref_doc = lr_i_header->doc_number. "low.
      lr_header->ref_doc_l = lr_i_header->doc_number.
*     Begin of ADD:ERP-2232:ANISAHA:24-MAY-2017:ED2K906293
      lr_header->purch_no_c = lr_i_header->purch_no. "Purchase order #
*     End   of ADD:ERP-2232:ANISAHA:24-MAY-2017:ED2K906293
*     Begin of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
      lr_header->purch_date = lr_i_header->purch_date. "Customer purchase order date
      lr_header->po_method  = lr_i_header->po_method. "Customer purchase order type
      lr_header->ref_1      = lr_i_header->ref_1. "Your Reference
*     End   of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
      lr_header->refdoc_cat = lc_contract. "'G'.
      lr_header->refdoctype = lc_contract. "'G'.
      lr_header->ref_1 = lr_i_header->doc_number.
      lr_headerx->refdoc_cat = abap_true.
      lr_headerx->doc_type = abap_true.
      lr_headerx->sales_org = abap_true.
      lr_headerx->distr_chan = abap_true.
      lr_headerx->division = abap_true.
*     Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
      lr_headerx->sales_off = abap_true.
*     End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
      lr_headerx->ref_doc = abap_true.
      lr_headerx->ref_1 = abap_true.
*     Begin of ADD:ERP-2232:ANISAHA:24-MAY-2017:ED2K906293
      lr_headerx->purch_no_c = abap_true.
*     End   of ADD:ERP-2232:ANISAHA:24-MAY-2017:ED2K906293
*     Begin of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
      lr_headerx->purch_date = abap_true. "Customer purchase order date
      lr_headerx->po_method  = abap_true. "Customer purchase order type
      lr_headerx->ref_1      = abap_true. "Your Reference

*     Begin of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910272
      IF li_tvcpa[] IS INITIAL.
        SELECT auarn "Copying control: Target sales document type
               auarv "Copying control: Reference document type
               pstyv "Reference item category
               pstyn "Default item category
          FROM tvcpa " Sales Documents: Copying Control
          INTO TABLE li_tvcpa
         WHERE auarn EQ lr_header->doc_type
           AND fkarv EQ space
           AND ettyv EQ space.
        IF sy-subrc EQ 0.
          SORT li_tvcpa BY auarv pstyv.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF li_tvcpa[] IS INITIAL
*     End   of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910272

      READ TABLE fp_i_business REFERENCE INTO lr_i_business WITH KEY itm_number = lc_posnr_low.
      IF sy-subrc = 0.
        lr_header->ref_1_s    = lr_i_business->ref_1_s. "Ship-to party's Your Reference
        lr_headerx->ref_1_s   = abap_true. "Ship-to party's Your Reference
*       Begin of ADD:ERP-5997:WROY:17-Jan-2018:ED2K910345
        lr_header->purch_no_c = lr_i_business->purch_no_c. "Purchase order #
*       End   of ADD:ERP-5997:WROY:17-Jan-2018:ED2K910345
      ENDIF. " IF sy-subrc = 0
*     End   of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
*     Begin of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
      READ TABLE fp_i_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_header->doc_number
                                                                   itm_number = lc_posnr_low.
      IF sy-subrc = 0.
        lr_sales_contract_in->itm_number  = lc_posnr_low.
        lr_sales_contract_inx->itm_number = lc_posnr_low.
        lr_sales_contract_inx->updateflag = lc_insert.
        lr_sales_contract_in->con_en_act  = lr_contract->contendact. "Action at end of contract
        lr_sales_contract_inx->con_en_act = abap_true. "Action at end of contract

        CLEAR lv_year.
        MOVE 1 TO lv_year.
        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            date      = lr_contract->actiondate           "Date for action
            days      = lc_days
            months    = lc_month
            years     = lv_year
          IMPORTING
            calc_date = lr_sales_contract_in->action_dat. "Date for action
        lr_sales_contract_inx->action_dat = abap_true.
        APPEND lr_sales_contract_in->* TO li_sales_contract_in.
        CLEAR lr_sales_contract_in->*.
        APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
        CLEAR lr_sales_contract_inx->*.
      ENDIF. " IF sy-subrc = 0
*     End   of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
      lr_headerx->updateflag = lc_insert.
      LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE customer IS NOT INITIAL.
        lr_partner->partn_role = lr_i_partner->partn_role.
        lr_partner->partn_numb = lr_i_partner->customer.
        lr_partner->itm_number = lr_i_partner->itm_number.
        APPEND lr_partner->* TO li_partner.
        CLEAR lr_partner->*.
      ENDLOOP. " LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE customer IS NOT INITIAL
      CLEAR lv_tabix.
      LOOP AT fp_i_item REFERENCE INTO lr_i_item.
        lv_tabix = lv_tabix + 1.
        lr_item->itm_number = lr_i_item->itm_number.
        lr_itemx->itm_number = lr_i_item->itm_number.
*       Begin of DEL:ERP-5828:WROY:10-Jan-2018:ED2K910241
*       lr_item->item_categ =  lr_header->doc_type.
*       End   of DEL:ERP-5828:WROY:10-Jan-2018:ED2K910241
*       Begin of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910241
        READ TABLE li_tvcpa ASSIGNING FIELD-SYMBOL(<lst_tvcpa>)
             WITH KEY auarv = lr_i_header->doc_type
                      pstyv = lr_i_item->item_categ
             BINARY SEARCH.
        IF sy-subrc EQ 0 AND
           <lst_tvcpa>-pstyn IS NOT INITIAL..
          lr_item->item_categ = <lst_tvcpa>-pstyn.
        ELSE. " ELSE -> IF sy-subrc EQ 0 AND
          lr_item->item_categ = lr_i_item->item_categ.
        ENDIF. " IF sy-subrc EQ 0 AND
        lr_itemx->item_categ = abap_true.
*       End   of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910241

*Begin of Add-NPALLA-05.15.2019-ED1K910179-INC0241861
        LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE itm_number = lr_i_item->itm_number
                                                         OR itm_number = lc_posnr_low .
          lr_partner->partn_role = lr_i_partner->partn_role.
          IF NOT lr_i_partner->customer IS INITIAL.
            lr_partner->partn_numb = lr_i_partner->customer.
          ELSEIF NOT lr_i_partner->vendor_no IS INITIAL.
            lr_partner->partn_numb = lr_i_partner->vendor_no.
          ELSEIF NOT lr_i_partner->person_no IS INITIAL..
            lr_partner->partn_numb = lr_i_partner->person_no.
          ENDIF. " IF NOT lr_i_partner->customer IS INITIAL
          lr_partner->itm_number = lr_i_partner->itm_number.
          APPEND lr_partner->* TO li_partner.
          CLEAR lr_partner->*.
        ENDLOOP. " LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE itm_number = lr_i_item->itm_number
        SORT li_partner BY partn_role partn_numb.
        DELETE ADJACENT DUPLICATES FROM li_partner COMPARING partn_role partn_numb.
*End of Add-NPALLA-05.15.2019-ED1K910179-INC0241861

*       Begin of DEL:ERP-6283:WROY:31-Jan-2018:ED2K910611
*       READ TABLE fp_i_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_item->doc_number.
*       End   of DEL:ERP-6283:WROY:31-Jan-2018:ED2K910611
*       Begin of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
        READ TABLE fp_i_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_item->doc_number
                                                                     itm_number = lr_i_item->itm_number.
        IF sy-subrc NE 0.
          READ TABLE fp_i_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_item->doc_number
                                                                       itm_number = lc_posnr_low.
        ENDIF. " IF sy-subrc NE 0
*       End   of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
        IF sy-subrc = 0.
          lr_sales_contract_in->itm_number = lr_i_item->itm_number.
          lr_sales_contract_inx->itm_number = lr_i_item->itm_number.
          lr_sales_contract_inx->updateflag = lc_insert.
          lr_sales_contract_in->con_st_dat = lr_contract->contenddat.
          CLEAR lv_days.
          MOVE 1 TO lv_days.
          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              date      = lr_sales_contract_in->con_st_dat
              days      = lv_days
              months    = lc_month
              years     = lc_year
            IMPORTING
              calc_date = lr_sales_contract_in->con_st_dat.
          lr_sales_contract_inx->con_st_dat = abap_true.
          lr_header->price_date = lr_sales_contract_in->con_st_dat.

*Begin of Add-Anirban-07.26.2017-ED2K907560-Defect 3335
          lr_headerx->price_date = abap_true.
          lr_headerx->sd_doc_cat = abap_true.
          lr_headerx->ref_doc_l = abap_true.
*End of Add-Anirban-07.26.2017-ED2K907560-Defect 3335

          CLEAR lv_days.
          READ TABLE li_renwl_plan REFERENCE INTO lr_notif_prof WITH KEY    renwl_prof = fp_renwl_prof.
          IF sy-subrc = 0.
            MOVE lr_notif_prof->grace_period TO lv_days.
          ENDIF. " IF sy-subrc = 0
          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              date      = lr_sales_contract_in->con_st_dat
              days      = lv_days
              months    = lc_month
              years     = lc_year
            IMPORTING
              calc_date = lr_sales_contract_in->con_en_dat.
          lr_sales_contract_inx->con_en_dat = abap_true.
          APPEND lr_sales_contract_in->* TO li_sales_contract_in.
*& Change the date for contract header
          IF lv_tabix = 1.
            lr_sales_contract_in->itm_number = lc_posnr_low.
            APPEND lr_sales_contract_in->* TO li_sales_contract_in.
            lr_sales_contract_inx->itm_number = lc_posnr_low.
            APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
          ENDIF. " IF lv_tabix = 1
          CLEAR lr_sales_contract_in->*.
          APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
          CLEAR lr_sales_contract_inx->*.

        ENDIF. " IF sy-subrc = 0
        lr_itemx->updateflag = lc_insert.
        lr_item->material =  lr_i_item->material.
        lr_itemx->material = abap_true.
        lr_item->target_qty =  lr_i_item->target_qty .
        lr_item->target_qu = lr_i_item->target_qu.
*--*BOC OTCM-40816 ED2K922409 Prabhu 3/9/2021
*        lr_item->plant = lr_i_item->plant.
*--*EOC OTCM-40816 ED2K922409 Prabhu 3/9/2021
        lr_itemx->target_qty = abap_true.
        lr_itemx->target_qu = abap_true.
        IF NOT lr_i_item->ref_doc IS INITIAL.
          lr_item->ref_doc  =   lr_i_item->ref_doc.
          lr_itemx->ref_doc = abap_true.
        ENDIF. " IF NOT lr_i_item->ref_doc IS INITIAL
        IF NOT lr_i_item->posnr_vor IS INITIAL.
          lr_item->ref_doc_it = lr_i_item->posnr_vor.
          lr_itemx->ref_doc_it = abap_true.
        ENDIF. " IF NOT lr_i_item->posnr_vor IS INITIAL
        IF lr_i_item->doc_cat_sd IS NOT INITIAL.
          lr_item->ref_doc_ca = lr_i_item->doc_cat_sd.
          lr_itemx->ref_doc_ca = abap_true.
        ENDIF. " IF lr_i_item->doc_cat_sd IS NOT INITIAL
        lr_item->ref_doc = lr_header->ref_doc.
        lr_item->ref_doc_it = lr_i_item->itm_number.
        lr_item->ref_doc_ca = lc_contract.

*       Begin of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
        READ TABLE fp_i_business REFERENCE INTO lr_i_business WITH KEY itm_number = lr_i_item->itm_number.
        IF sy-subrc = 0.
          lr_item->purch_no_c  = lr_i_business->purch_no_c. "Purchase order #
          lr_item->purch_date  = lr_i_business->purch_date. "Customer purchase order date
          lr_item->po_method   = lr_i_business->po_method. "Customer purchase order type
          lr_item->price_grp   = lr_i_business->price_grp. "Price group (customer)
          lr_item->ref_1       = lr_i_business->ref_1. "Your Reference
          lr_item->ref_1_s     = lr_i_business->ref_1_s. "Ship-to party's Your Reference
          lr_item->cust_group  = lr_i_business->cust_group. "Customer Group

*Begin of Add-Anirban-07.28.2017-ED2K907608-Defect 3682
          lr_item->cstcndgrp5 =  lr_i_business->custcongr5. "Customer condition group 5
          IF lr_item->cstcndgrp5 IS INITIAL.
            READ TABLE fp_i_business REFERENCE INTO lr_i_business WITH KEY itm_number = lc_posnr_low.
            IF sy-subrc = 0.
              lr_item->cstcndgrp5 =  lr_i_business->custcongr5. "Customer condition group 5
            ENDIF. " IF sy-subrc = 0
          ENDIF. " IF lr_item->cstcndgrp5 IS INITIAL
          lr_itemx->cstcndgrp5 = abap_true. "Customer condition group 5
*End of Add-Anirban-07.28.2017-ED2K907608-Defect 3682

*lc_posnr_low TYPE vbap-posnr    VALUE '000000',
          lr_itemx->purch_no_c = abap_true. "Purchase order #
          lr_itemx->purch_date = abap_true. "Customer purchase order date
          lr_itemx->po_method  = abap_true. "Customer purchase order type
          lr_itemx->price_grp  = abap_true. "Price group (customer)
          lr_itemx->ref_1      = abap_true. "Your Reference
          lr_itemx->ref_1_s    = abap_true. "Ship-to party's Your Reference
          lr_itemx->cust_group = abap_true. "Customer Group
        ENDIF. " IF sy-subrc = 0
*       End   of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
        APPEND lr_item->* TO li_item.
        CLEAR lr_item->*.
        APPEND lr_itemx->* TO li_itemx.
        CLEAR lr_itemx->*.
      ENDLOOP. " LOOP AT fp_i_item REFERENCE INTO lr_i_item


* BOC - GKINTALI - INC0202201 - 2018/08/27 - ED1K908393
* To update the order number in the message log for tracking purpose.
      IF sy-batch = abap_true.
        MESSAGE s006(zqtc_r2) WITH lr_header->ref_doc. " Order being processed : & .
      ENDIF. " IF sy-batch = abap_true
* EOC - GKINTALI - INC0202201 - 2018/08/27 - ED1K908393

* BOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739
*      IF v_1st_var IS INITIAL. "+ED2K912739
*        v_1st_var = lr_header->ref_doc. "+ED2K912739
*      ENDIF. " IF v_1st_var IS INITIAL
*      v_msgv1 = lr_header->ref_doc. "+ED2K912739
*      PERFORM add_message_log USING 'S' 'ZQTC_R2' '006'        "+ED2K912739
*                                    v_msgv1 space space space. "+ED2K912739
* EOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739

*      lst_bapisdls-pricing = lc_g.
      CLEAR li_return.
      CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
        EXPORTING
          sales_header_in       = lr_header->*
          int_number_assignment = abap_true
          testrun               = p_test
*         logic_switch          = lst_bapisdls
        IMPORTING
          salesdocument_ex      = fp_v_salesord
        TABLES
          return                = li_return
          sales_items_in        = li_item
          sales_items_inx       = li_itemx
          sales_partners        = li_partner
          sales_contract_in     = li_sales_contract_in
          sales_contract_inx    = li_sales_contract_inx
          textheaders_ex        = fp_i_textheaders
          textlines_ex          = fp_i_textlines.
*     BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
      LOOP AT li_return INTO st_return. "+ED2K912739
        PERFORM add_message_log USING st_return-type st_return-id st_return-number "+ED2K912739
                                      st_return-message_v1 st_return-message_v2    "+ED2K912739
                                      st_return-message_v3 st_return-message_v4.   "+ED2K912739
        CLEAR st_return.
      ENDLOOP. " LOOP AT li_return INTO st_return
*     EOC - NPALLA - E096 - 2018/08/27 - ED2K912739
      READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = 'E'.
      IF sy-subrc <> 0.
        IF p_test = space.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_true.
          fp_v_act_status = abap_true.
          CONCATENATE   'Grace Subscription'(a04) fp_v_salesord text-a08 INTO fp_message.
        ELSE. " ELSE -> IF p_test = space
*         Begin of ADD:SAP's Recommendations:WROY:01-Mar-2018:ED2K911135
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*         End   of ADD:SAP's Recommendations:WROY:01-Mar-2018:ED2K911135
          CONCATENATE  'Grace Subscription'(a04) fp_v_salesord text-x23 INTO fp_message.
        ENDIF. " IF p_test = space


      ELSE. " ELSE -> IF sy-subrc <> 0
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        APPEND LINES OF li_return TO fp_i_return.
        MOVE lr_return->message TO fp_message.
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF sy-subrc = 0

  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_CONSTANT_TABLE
*&---------------------------------------------------------------------*
*       Fetch data from constant table ZCACONSTANT
*----------------------------------------------------------------------*
*      <--FP_I_CONST  Constant table
*----------------------------------------------------------------------*
FORM f_fetch_constant_table  CHANGING fp_i_const TYPE tt_const.
**  Local Constants declaration
  CONSTANTS:
    lc_devid  TYPE zdevid     VALUE 'E096', "Development ID
    lc_param1 TYPE rvari_vnam VALUE 'EXP_DAYS',
    lc_sno    TYPE tvarv_numb VALUE '0001'.

*& Get data from constant table
  SELECT devid                         "Development ID
         param1                        "ABAP: Name of Variant Variable
         param2                        "ABAP: Name of Variant Variable
         srno                          "Current selection number
         sign                          "ABAP: ID: I/E (include/exclude values)
         opti                          "ABAP: Selection option (EQ/BT/CP/...)
         low                           "Lower Value of Selection Condition
         high                          "Upper Value of Selection Condition
         activate                      "Activation indicator for constant
         FROM zcaconstant              " Wiley Application Constant Table
         INTO TABLE fp_i_const
         WHERE devid    = lc_devid
           AND activate = abap_true
         ORDER BY devid param1 param2. "Only active record
  IF sy-subrc <> 0.
*& do nothing
  ELSE.
    READ TABLE fp_i_const INTO DATA(lst_const) WITH KEY param1 = lc_param1
                                                        srno = lc_sno.
    IF sy-subrc = 0.
      v_exp_days = lst_const-low.
    ENDIF.
  ENDIF. " IF sy-subrc <> 0


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_NOTIF_PROF
*&---------------------------------------------------------------------*
*       Fetch data from notification retermination table
*----------------------------------------------------------------------*
*      -->P_I_FINAL       : Final table
*      <--P_I_NOTIF_P_DET :Notification determination
*----------------------------------------------------------------------*
FORM f_fetch_notif_prof  USING    fp_i_final TYPE tt_final
                         CHANGING fp_i_notif_p_det TYPE tt_notif_p_det.
  TYPES:
    BEGIN OF lty_renwl_p_det,
      renwl_prof   TYPE zrenwl_prof,   " Renewal Profile
      quote_time   TYPE zquote_tim,    " Quote Timing
      notif_prof   TYPE znotif_prof,   " Notification Profile
      grace_start  TYPE zgrace_start,  " Grace Start Timing
      grace_period TYPE zgrace_period, " Grace Period
      auto_renew   TYPE zauto_renew,   " Auto Renew Timing
      lapse        TYPE zlapse,        " Lapse
*     Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
      consolidate  TYPE zconsolidate, " Consolidated Renewals
*     End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
    END OF   lty_renwl_p_det,
    ltt_renwl_p_det TYPE STANDARD TABLE OF lty_renwl_p_det
          INITIAL SIZE 0.
  DATA: li_final      TYPE tt_final,
        li_renwl_plan TYPE ltt_renwl_p_det.
  li_final = fp_i_final.
  SORT li_final BY renwl_prof.
  DELETE ADJACENT DUPLICATES FROM li_final COMPARING renwl_prof.
  IF li_final IS NOT INITIAL.
    SELECT renwl_prof " Renewal Profile
    quote_time        " Quote Timing
    notif_prof        " Notification Profile
    grace_start       " Grace Start Timing
    grace_period      " Grace Period
    auto_renew        " Auto Renew Timing
    lapse             " Lapse
*   Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
    consolidate " Consolidated Renewals
*   End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
      FROM zqtc_renwl_p_det " E095: Renewal Profile Details Table
      INTO TABLE li_renwl_plan
      FOR ALL ENTRIES IN li_final
      WHERE
      renwl_prof = li_final-renwl_prof.
    IF sy-subrc = 0.
      SORT li_renwl_plan BY notif_prof.
      DELETE ADJACENT DUPLICATES FROM li_renwl_plan COMPARING notif_prof.
      IF li_renwl_plan IS NOT INITIAL.
        SELECT                 notif_prof     " Notification Profile
                               notif_rem      " Notification/Reminder
                               rem_in_days    " Notification Reminder (in Days)
                               promo_code     " Promo code
                        FROM zqtc_notif_p_det " E095: Notification Profile Details Table
                        INTO  TABLE fp_i_notif_p_det
                        FOR ALL ENTRIES IN li_renwl_plan
                        WHERE
                        notif_prof = li_renwl_plan-notif_prof.
        IF sy-subrc = 0.
          LOOP AT fp_i_notif_p_det ASSIGNING FIELD-SYMBOL(<lst_notif_e095>).
            READ TABLE li_renwl_plan ASSIGNING FIELD-SYMBOL(<lst_renwl_plan>) WITH KEY notif_prof = <lst_notif_e095>-notif_prof
            BINARY SEARCH.
            IF sy-subrc = 0.
              <lst_notif_e095>-renwl_prof = <lst_renwl_plan>-renwl_prof.
            ENDIF. " IF sy-subrc = 0

          ENDLOOP. " LOOP AT fp_i_notif_p_det ASSIGNING FIELD-SYMBOL(<lst_notif_e095>)

        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF li_renwl_plan IS NOT INITIAL

    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF li_final IS NOT INITIAL

* Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
  SORT li_renwl_plan BY renwl_prof.
  LOOP AT fp_i_final ASSIGNING FIELD-SYMBOL(<lst_final>).
    READ TABLE li_renwl_plan ASSIGNING <lst_renwl_plan>
         WITH KEY renwl_prof = <lst_final>-renwl_prof
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      <lst_final>-notif_prof  = <lst_renwl_plan>-notif_prof. " Notification Profile
      <lst_final>-consolidate = <lst_renwl_plan>-consolidate. " Consolidated Renewals
    ENDIF. " IF sy-subrc EQ 0
  ENDLOOP. " LOOP AT fp_i_final ASSIGNING FIELD-SYMBOL(<lst_final>)
* End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_PROMO_CODE
*&---------------------------------------------------------------------*
*       Update Promo code
*----------------------------------------------------------------------*
*      -->FP_I_VBFA  Document flow
*      -->FP_lI_NOTIF_PROF  Notification determination
*      -->FP_lr_FINAL    final
*----------------------------------------------------------------------*
FORM f_update_promo_code  USING    fp_li_vbfa TYPE tt_vbfa
                                   fp_li_notif_prof TYPE  tt_notif_p_det
                                   fp_lr_final TYPE  ty_renwl_plan.

  DATA: lr_vbfa         TYPE REF TO vbfa,                   "  class
        lst_header_inx  TYPE bapisdh1x,                     " Checkbox List: SD Order Header
        li_return       TYPE TABLE OF bapiret2,             " Return Messages
        lr_return       TYPE REF TO bapiret2,               " BAPI Return Messages
        lv_char         TYPE c LENGTH 240,                  " Char of type Character
        lst_bape_vbak   TYPE bape_vbak,                     " BAPI Interface for Customer Enhancements to Table VBAK
        lst_bape_vbakx  TYPE bape_vbakx,                    " BAPI Checkbox for Customer Enhancments to Table VBAK
        lst_bape_vbap   TYPE bape_vbap,                     " BAPI Interface for Customer Enhancements to Table VBAP
        lst_bape_vbapx  TYPE bape_vbapx,                    " BAPI Checkbox for Customer Enhancments to Table VBAP
        lst_item_in     TYPE  bapisditm,                    " Communication Fields: Sales and Distribution Document Item
        li_item_in      TYPE STANDARD TABLE OF bapisditm,   " Communication Fields: Sales and Distribution Document Item
        lst_item_inx    TYPE  bapisditmx,                   " Communication Fields: Sales and Distribution Document Item
        li_item_inx     TYPE STANDARD TABLE OF bapisditmx,  " Communication Fields: Sales and Distribution Document Item
        lst_extensionin TYPE  bapiparex,                    " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        lv_reminder     TYPE znotif_rem,                    " Notification/Reminder
        li_extensionin  TYPE   STANDARD TABLE OF bapiparex. " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut

  CONSTANTS:lc_bape_vbap  TYPE te_struc VALUE 'BAPE_VBAP',  " constant table name  for extension
            lc_bape_vbapx TYPE te_struc VALUE 'BAPE_VBAPX', " constant table name for Extension
            lc_bape_vbak  TYPE te_struc VALUE 'BAPE_VBAK',  " constant table name  for extension
            lc_bape_vbakx TYPE te_struc VALUE 'BAPE_VBAKX', " constant table name for Extension
            lc_update     TYPE char1            VALUE 'U',  " Update
            lc_error      TYPE bapi_mtype       VALUE 'E',  " error
            lc_abend      TYPE bapi_mtype       VALUE 'A',  " Abbend
            lc_success    TYPE bapi_mtype       VALUE 'S'.  " suceess

  READ TABLE fp_li_vbfa REFERENCE INTO lr_vbfa INDEX 1.
  IF lr_vbfa IS BOUND.

    lst_header_inx-updateflag = lc_update.
    SELECT SINGLE  zzpromo " Promo code
          FROM vbak        " Sales Document: Header Data
          INTO @DATA(lv_promo)
          WHERE
          vbeln = @lr_vbfa->vbeln.

*    lst_item_in-itm_number =  lr_vbfa->posnn.
*    APPEND lst_item_in TO li_item_in.
*    CLEAR lst_item_in.
*   Populate the itemx table
*    lst_item_inx-itm_number = lr_vbfa->posnn.
*    lst_item_inx-updateflag = lc_update.
*    APPEND lst_item_inx TO li_item_inx.
*    CLEAR lst_item_inx.
*   Populate the extension table
*   Populate the value
*    lst_extensionin-structure      = lc_bape_vbap.
*    lst_bape_vbap-vbeln            = lr_vbfa->vbeln.
*    lst_bape_vbap-posnr            = lr_vbfa->posnn.
    IF fp_lr_final-promo_code <> lv_promo.

      lst_extensionin-structure      = lc_bape_vbak.
      lst_bape_vbak-vbeln            = lr_vbfa->vbeln.
*    lst_bape_vbap-posnr            = lr_vbfa->posnn.
*    IF fp_lr_final-promo_code IS NOT INITIAL.
      lst_bape_vbak-zzpromo       =    fp_lr_final-promo_code.
*    ELSE.
*      CLEAR lv_reminder.
*      lv_reminder = fp_lr_final-activity.
*      READ TABLE fp_li_notif_prof ASSIGNING FIELD-SYMBOL(<lst_notif_prof>) WITH KEY renwl_prof = fp_lr_final-renwl_prof
*                                                                                    notif_rem  =  lv_reminder.
*      IF sy-subrc = 0.
**      lst_bape_vbap-zzpromo       =    <lst_notif_prof>-promo_code.
*        lst_bape_vbak-zzpromo       =    <lst_notif_prof>-promo_code.
*      ENDIF.
*    ENDIF.
*    CALL METHOD cl_abap_container_utilities=>fill_container_c
*      EXPORTING
*        im_value     = lst_bape_vbap
*      IMPORTING
*        ex_container = lst_extensionin-valuepart1.
      CALL METHOD cl_abap_container_utilities=>fill_container_c
        EXPORTING
          im_value     = lst_bape_vbak
        IMPORTING
          ex_container = lst_extensionin-valuepart1.
      APPEND lst_extensionin TO li_extensionin.
      CLEAR lst_extensionin.
*   Populate the Check box
*    lst_extensionin-structure       = lc_bape_vbapx.
*    lst_bape_vbapx-vbeln            = lr_vbfa->vbeln.
*    lst_bape_vbapx-posnr            = lr_vbfa->posnn.
*    lst_bape_vbapx-zzpromo           = abap_true.
*    Syntax check is hidden since this a stardard syntax error with no possible way to avoid
      lst_extensionin-structure       = lc_bape_vbakx.
      lst_bape_vbakx-vbeln            = lr_vbfa->vbeln.
      lst_bape_vbakx-zzpromo         = abap_true.
      CALL METHOD cl_abap_container_utilities=>fill_container_c
        EXPORTING
          im_value     = lst_bape_vbakx
        IMPORTING
          ex_container = lst_extensionin-valuepart1.

      APPEND lst_extensionin TO li_extensionin.
      CLEAR  lst_extensionin.
*    Syntax check is hidden since this a stardard syntax error with no possible way to avoid
*    CALL METHOD cl_abap_container_utilities=>fill_container_c
*      EXPORTING
*        im_value     = lst_bape_vbapx
*      IMPORTING
*        ex_container = lst_extensionin-valuepart1.
*
*    APPEND lst_extensionin TO li_extensionin.
*    CLEAR  lst_extensionin.
*   Begin of ADD:ERP-7331:WROY:30-Mar-2018:ED2K911135
    ELSEIF fp_lr_final-promo_code IS INITIAL.
      RETURN.
*   End   of ADD:ERP-7331:WROY:30-Mar-2018:ED2K911135
    ENDIF. " IF fp_lr_final-promo_code <> lv_promo

* BOC - GKINTALI - INC0202201 - 2018/08/27 - ED1K908393
* To update the order number in the message log for tracking purpose.
    IF sy-batch = abap_true.
      MESSAGE s006(zqtc_r2) WITH lr_vbfa->vbeln. " Order being processed : & .
    ENDIF. " IF sy-batch = abap_true
* EOC - GKINTALI - INC0202201 - 2018/08/27 - ED1K908393

* BOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739
*    IF v_1st_var IS INITIAL. "+ED2K912739
*      v_1st_var = lr_vbfa->vbeln. "+ED2K912739
*    ENDIF. " IF v_1st_var IS INITIAL
*    v_msgv1 = lr_vbfa->vbeln. "+ED2K912739
*    PERFORM add_message_log USING 'S' 'ZQTC_R2' '006'        "+ED2K912739
*                                  v_msgv1 space space space. "+ED2K912739
* EOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739

    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument    = lr_vbfa->vbeln
        order_header_inx = lst_header_inx
        simulation       = p_test
      TABLES
        return           = li_return
*       order_item_in    = li_item_in
*       order_item_inx   = li_item_inx
        extensionin      = li_extensionin.
*   BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
    LOOP AT li_return INTO st_return. "+ED2K912739
      PERFORM add_message_log USING st_return-type st_return-id st_return-number "+ED2K912739
                                    st_return-message_v1 st_return-message_v2    "+ED2K912739
                                    st_return-message_v3 st_return-message_v4.   "+ED2K912739
      CLEAR st_return. "+ED2K912739
    ENDLOOP. " LOOP AT li_return INTO st_return
*   EOC - NPALLA - E096 - 2018/08/27 - ED2K912739
    LOOP AT li_return REFERENCE INTO lr_return  WHERE type = lc_error
                                                   OR type = lc_abend. " Or of type
    ENDLOOP. " LOOP AT li_return REFERENCE INTO lr_return WHERE type = lc_error
*& If no Error / Abend happens
    IF sy-subrc <> 0.
      IF p_test = space.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
      ENDIF. " IF p_test = space

      READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = lc_success.
      IF sy-subrc = 0.
        IF p_test = space.
          IF fp_lr_final-promo_code IS INITIAL AND lv_promo IS NOT INITIAL.
            CONCATENATE 'Previous Promo code'(a23) lv_promo 'has been removed'(a24)  INTO fp_lr_final-message
            SEPARATED BY space.
          ELSEIF fp_lr_final-promo_code  IS NOT INITIAL.
            CONCATENATE 'Promocode Successfully applied for'(a01) lr_vbfa->vbeln INTO fp_lr_final-message.
          ENDIF. " IF fp_lr_final-promo_code IS INITIAL AND lv_promo IS NOT INITIAL

        ELSE. " ELSE -> IF p_test = space
          CONCATENATE 'Promocode can be applied for'(x07) lr_vbfa->vbeln INTO fp_lr_final-message.
        ENDIF. " IF p_test = space

      ENDIF. " IF sy-subrc = 0
    ELSE. " ELSE -> IF sy-subrc <> 0
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      CONCATENATE 'Promocode not applied for'(a02) lr_vbfa->vbeln INTO fp_lr_final-message.
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF lr_vbfa IS BOUND
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LAPASE_ORDER
*&---------------------------------------------------------------------*
*      Lapse an order
*----------------------------------------------------------------------*
*      -->FP_LI_ITEM   Line Items
*      <--FP_LR_FINAL  final table
*      <--FP_I_RETURN  Return
*----------------------------------------------------------------------*
FORM f_lapase_order  USING    fp_li_item  TYPE tt_item
                              fp_li_header TYPE tt_header
                              fp_flag     TYPE char1   " Flag of type CHAR1
                     CHANGING fp_lr_final TYPE  ty_renwl_plan
                              fp_i_return TYPE tt_return
                              fp_lv_lapsed TYPE char1. " Lv_lapsed of type CHAR1
  DATA: li_return             TYPE TABLE OF bapiret2,            " Return Parameter
        li_item_in            TYPE STANDARD TABLE OF bapisditm,  " Communication Fields: Sales and Distribution Document Item
        lst_item_in           TYPE  bapisditm,                   " Communication Fields: Sales and Distribution Document Item
        lst_item_inx          TYPE  bapisditmx,                  " Communication Fields: Sales and Distribution Document Item
        li_item_inx           TYPE STANDARD TABLE OF bapisditmx, " Communication Fields: Sales and Distribution Document Item
        lr_return             TYPE REF TO bapiret2,              " reference variable for Return Parameter
        lr_sales_contract_in  TYPE  REF TO bapictr ,             " contract data
        li_sales_contract_in  TYPE STANDARD TABLE OF bapictr ,   " Internal  table for cond
        lr_sales_contract_inx TYPE REF TO  bapictrx ,            " Communication fields: SD Contract Data Checkbox
        li_sales_contract_inx TYPE  STANDARD TABLE OF bapictrx , " Communication fields: SD Contract Data Checkbox
        lst_header_inx        TYPE bapisdhd1x.                   " Checkbox Fields for Sales and Distribution Document Header
  CONSTANTS: lc_update(1) TYPE c VALUE 'U',               " Update
             lc_posnr_low TYPE vbap-posnr VALUE '000000', " Item 0
             lc_lapse     TYPE veda-vkuesch VALUE '0001', " Cancellation procedure
             lc_error     TYPE char1 VALUE 'E',           " Error
             lc_abend     TYPE  char1 VALUE 'A',          " Abend
             lc_success   TYPE char1 VALUE 'S'.           " success

  LOOP AT fp_li_item ASSIGNING FIELD-SYMBOL(<lst_li_item>) .
    READ TABLE fp_li_header ASSIGNING FIELD-SYMBOL(<lst_li_header>) WITH KEY doc_number =   <lst_li_item>-doc_number  .
    IF sy-subrc = 0.
      IF <lst_li_item>-itm_number <> lc_posnr_low.
        lst_item_in-itm_number = <lst_li_item>-itm_number.
        APPEND lst_item_in TO li_item_in.
        CLEAR lst_item_in.
*   Populate the itemx table
        lst_item_inx-itm_number = <lst_li_item>-itm_number.
        lst_item_inx-updateflag = lc_update.
        APPEND lst_item_inx TO li_item_inx.
        CLEAR lst_item_inx.
      ENDIF. " IF <lst_li_item>-itm_number <> lc_posnr_low
      CREATE DATA lr_sales_contract_in.
      lr_sales_contract_in->itm_number = <lst_li_item>-itm_number. " Iteme number
      lr_sales_contract_in->canc_proc = lc_lapse. " Cancellation Procedure
      lr_sales_contract_in->con_en_dat = sy-datum. " Contract end date
*      lr_sales_contract_in->cancdocdat = sy-datum . "fp_lr_finaladat.,,
      APPEND lr_sales_contract_in->* TO li_sales_contract_in.
      CLEAR lr_sales_contract_in->*.
      CREATE DATA lr_sales_contract_inx.
      lr_sales_contract_inx->itm_number =  <lst_li_item>-itm_number. " Iteme number
      lr_sales_contract_inx->updateflag = lc_update.
      lr_sales_contract_inx->canc_proc = abap_true. " Cancellation Procedure
      lr_sales_contract_inx->con_en_dat = abap_true.
*      lr_sales_contract_inx->cancdocdat = abap_true.
      APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
      CLEAR lr_sales_contract_inx->*.
*& If flag is 'X' , then it's header of the renwal subcription
      IF sy-tabix = 1 AND fp_flag = space.

*& LAPSING THE HEADER ALSO
        lr_sales_contract_in->itm_number = lc_posnr_low. " Iteme number
        lr_sales_contract_in->canc_proc = lc_lapse. " Cancellation Procedure
        lr_sales_contract_in->con_en_dat = sy-datum. " Contract end date
*        lr_sales_contract_in->cancdocdat = sy-datum.
        lr_sales_contract_in->con_en_dat = sy-datum.
        APPEND lr_sales_contract_in->* TO li_sales_contract_in.
        CLEAR lr_sales_contract_in->*.
        lr_sales_contract_inx->itm_number =  lc_posnr_low. " Iteme number
        lr_sales_contract_inx->updateflag = lc_update.
        lr_sales_contract_inx->canc_proc = abap_true. " Cancellation Procedure
*        lr_sales_contract_inx->cancdocdat = abap_true.
        lr_sales_contract_inx->con_en_dat = abap_true.
        APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
        CLEAR lr_sales_contract_inx->*.

      ENDIF. " IF sy-tabix = 1 AND fp_flag = space
    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT fp_li_item ASSIGNING FIELD-SYMBOL(<lst_li_item>)

* BOC - GKINTALI - INC0202201 - 2018/08/27 - ED1K908393
* To update the order number in the message log for tracking purpose.
  IF sy-batch = abap_true.
    MESSAGE s221(zqtc_r2) WITH <lst_li_header>-doc_number. " Order being lapsed : & .
  ENDIF. " IF sy-batch = abap_true
* EOC - GKINTALI - INC0202201 - 2018/08/27 - ED1K908393

* BOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739
*  IF v_1st_var IS INITIAL. "+ED2K912739
*    v_1st_var = <lst_li_header>-doc_number. "+ED2K912739
*  ENDIF. " IF v_1st_var IS INITIAL
*  v_msgv1 = <lst_li_header>-doc_number. "+ED2K912739
*  PERFORM add_message_log USING 'S' 'ZQTC_R2' '221'        "+ED2K912739
*                                v_msgv1 space space space. "+ED2K912739
* EOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739

  IF li_sales_contract_in IS NOT INITIAL.
    lst_header_inx-updateflag = lc_update.
    CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
      EXPORTING
        salesdocument      = <lst_li_header>-doc_number
        order_header_inx   = lst_header_inx
        simulation         = p_test
*       business_object    = 'BUS2034'
      TABLES
        return             = li_return
        item_in            = li_item_in
        item_inx           = li_item_inx
        sales_contract_in  = li_sales_contract_in
        sales_contract_inx = li_sales_contract_inx.
*   BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
    LOOP AT li_return INTO st_return. "+ED2K912739
      PERFORM add_message_log USING st_return-type st_return-id st_return-number "+ED2K912739
                                    st_return-message_v1 st_return-message_v2    "+ED2K912739
                                    st_return-message_v3 st_return-message_v4.   "+ED2K912739
      CLEAR st_return. "+ED2K912739
    ENDLOOP. " LOOP AT li_return INTO st_return
*   EOC - NPALLA - E096 - 2018/08/27 - ED2K912739
    LOOP AT li_return REFERENCE INTO lr_return  WHERE type = lc_error
                                               OR type = lc_abend. " Or of type

      APPEND lr_return->* TO fp_i_return.
      MOVE lr_return->message TO fp_lr_final-message.
    ENDLOOP. " LOOP AT li_return REFERENCE INTO lr_return WHERE type = lc_error
*& If no Error / Abend happens
    IF sy-subrc <> 0.
      fp_lv_lapsed = abap_true.
      IF p_test = space.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = space.
*     Begin of ADD:SAP's Recommendations:WROY:01-Mar-2018:ED2K911135
      ELSE. " ELSE -> IF p_test = space
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*     End   of ADD:SAP's Recommendations:WROY:01-Mar-2018:ED2K911135
      ENDIF. " IF p_test = space

      READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = lc_success.
      IF sy-subrc = 0.
        IF p_test = space.
          fp_lr_final-act_status = abap_true.
          CONCATENATE 'Subsc. Order'(y01) <lst_li_header>-doc_number 'has been lapsed'(y02) fp_lr_final-message
                  INTO fp_lr_final-message SEPARATED BY space.
        ELSE. " ELSE -> IF p_test = space
          CONCATENATE 'Subsc. Order'(y01) <lst_li_header>-doc_number 'can be lapsed'(y05) fp_lr_final-message
                  INTO fp_lr_final-message SEPARATED BY space.
        ENDIF. " IF p_test = space
      ENDIF. " IF sy-subrc = 0

    ELSE. " ELSE -> IF sy-subrc <> 0
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.


    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF li_sales_contract_in IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETE_ENTRY
*&---------------------------------------------------------------------*
*     Delete data from table
*----------------------------------------------------------------------*
*      -->fp_renwal     :   Renewal Plan table
*      -->P_FP_I_FINAL  : final table
*----------------------------------------------------------------------*
FORM f_delete_entry  USING    fp_renwal TYPE tt_renwl_plan
                    CHANGING fp_i_final TYPE tt_final.

*& Enque Table ZQTC_RENWL_PLAN
  CALL FUNCTION 'ENQUEUE_EZQTC_AUTO_RENEW'
    EXPORTING
      mode_zqtc_renwl_plan = abap_true
      mandt                = sy-mandt
    EXCEPTIONS
      foreign_lock         = 1
      system_failure       = 2
      OTHERS               = 3.
  IF sy-subrc <> 0.
* No Need to throw error message
  ELSE. " ELSE -> IF sy-subrc <> 0
    DELETE zqtc_renwl_plan FROM TABLE fp_renwal.
    IF sy-subrc = 0.

      CALL FUNCTION 'DEQUEUE_EZQTC_AUTO_RENEW'
        EXPORTING
          mode_zqtc_renwl_plan = abap_true
          mandt                = sy-mandt.
      LOOP AT fp_i_final ASSIGNING FIELD-SYMBOL(<lst_i_final>).

        READ TABLE fp_renwal ASSIGNING FIELD-SYMBOL(<lst_renewal_e095>) WITH KEY vbeln  = <lst_i_final>-vbeln
                                                                                posnr = <lst_i_final>-posnr
                                                                                .
        IF sy-subrc = 0.
          <lst_i_final>-message = 'Entry Removed'(a03).
        ENDIF. " IF sy-subrc = 0

      ENDLOOP. " LOOP AT fp_i_final ASSIGNING FIELD-SYMBOL(<lst_i_final>)
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF sy-subrc <> 0
ENDFORM.

**Begin of Add-Anirban-07.20.2017-ED2K907327-Defect 3301
**&---------------------------------------------------------------------*
**&      Form  F_DELETE_ENTRY
**&---------------------------------------------------------------------*
**     Delete data from table
**----------------------------------------------------------------------*
**      -->fp_renwal     :   Renewal Plan table
**      -->P_FP_I_FINAL  : final table
**----------------------------------------------------------------------*
*FORM f_change_status  USING    fp_renwal TYPE tt_renwl_plan
*                    CHANGING fp_i_final TYPE tt_final.
*  DATA : lt_renewal  TYPE tt_renwl_plan,
*         lst_renewal TYPE zqtc_renwl_plan.
*
*  lt_renewal[] = fp_renwal[].
**& Enque Table ZQTC_RENWL_PLAN
*  CALL FUNCTION 'ENQUEUE_EZQTC_AUTO_RENEW'
*    EXPORTING
*      mode_zqtc_renwl_plan = abap_true
*      mandt                = sy-mandt
*    EXCEPTIONS
*      foreign_lock         = 1
*      system_failure       = 2
*      OTHERS               = 3.
*  IF sy-subrc <> 0.
** No Need to throw error message
*  ELSE.
*    DELETE lt_renewal WHERE act_status EQ abap_false.
*    IF NOT lt_renewal IS INITIAL.
*      LOOP AT lt_renewal INTO lst_renewal.
*        lst_renewal-act_status = abap_false.
*        MODIFY lt_renewal FROM lst_renewal.
*      ENDLOOP.
*      MODIFY zqtc_renwl_plan FROM TABLE lt_renewal.
*
*      IF sy-subrc = 0.
*        CALL FUNCTION 'DEQUEUE_EZQTC_AUTO_RENEW'
*          EXPORTING
*            mode_zqtc_renwl_plan = abap_true
*            mandt                = sy-mandt.
*        LOOP AT fp_i_final ASSIGNING FIELD-SYMBOL(<lst_i_final>).
*
*          READ TABLE lt_renewal ASSIGNING FIELD-SYMBOL(<lst_renewal_e095>) WITH KEY vbeln  = <lst_i_final>-vbeln
*                                                                                   posnr = <lst_i_final>-posnr
*                                                                                   activity = <lst_i_final>-activity.
*          IF sy-subrc = 0.
*            <lst_i_final>-act_status = space.
*            <lst_i_final>-message = 'Activity status changed'(a25).
*          ENDIF.
*        ENDLOOP.
*      ENDIF.
*    ENDIF.
*  ENDIF.
*ENDFORM.
**End of Add-Anirban-07.20.2017-ED2K907327-Defect 3301


*&---------------------------------------------------------------------*
*&      Form  F_LAPSE_QUOTATION
*&---------------------------------------------------------------------*
*      lAPSE THE QUOTATION
*----------------------------------------------------------------------*
*      -->P_LR_DOCFLOW_>SUBSSDDOC  text
*      <--P_<LST_FP_I_FINAL_E095>_MESSAGE  text
*      <--P_I_RETURN  text
*----------------------------------------------------------------------*
FORM f_lapse_quotation  USING    fp_subssddoc TYPE vbak-vbeln " Sales Document
                        CHANGING fp_message TYPE char120      " Message of type CHAR120
                                 fp_status  TYPE char1        " Status of type CHAR1
                                 fp_i_return TYPE  tt_return.
* Begin of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
  TYPES : BEGIN OF lty_vbap,
            vbeln TYPE vbeln_va, " Sales Document
            posnr TYPE posnr_va, " Sales Document Item
          END   OF lty_vbap.
* End   of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890

  DATA: li_return             TYPE TABLE OF bapiret2, " Return Messages
        lr_return             TYPE REF TO bapiret2,   " BAPI Return Messages
*       Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
        lr_sales_contract_in  TYPE  REF TO bapictr ,                            " contract data
        li_sales_contract_in  TYPE STANDARD TABLE OF bapictr ,                  " Internal  table for cond
        lr_sales_contract_inx TYPE REF TO  bapictrx ,                           " Communication fields: SD Contract Data Checkbox
        li_sales_contract_inx TYPE  STANDARD TABLE OF bapictrx INITIAL SIZE 0 , " Communication fields: SD Contract Data Checkbox
        lr_header             TYPE REF TO bapisdhd1,                            " Communication Fields: Sales and Distribution Document Header
        lr_headerx            TYPE REF TO bapisdhd1x,                           " Checkbox Fields for Sales and Distribution Document Header
*       End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
*       Begin of DEL:CR# 546:WROY:03-JUN-2017:ED2K906489
*       lr_header             TYPE REF TO bapisdh1, " Communication Fields: Sales and Distribution Document Header
*       lr_headerx            TYPE REF TO  bapisdh1x. " Checkbox Fields for Sales and Distribution Document Header
*       End   of DEL:CR# 546:WROY:03-JUN-2017:ED2K906489

* Begin of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
        li_vbap               TYPE STANDARD TABLE OF lty_vbap,
        lst_vbap              TYPE lty_vbap,
        li_item               TYPE STANDARD TABLE OF bapisditm,  " Communication Fields: Sales and Distribution Document Item
        lr_item               TYPE REF TO bapisditm,             "  class
        li_itemx              TYPE STANDARD TABLE OF bapisditmx, " Communication Fields: Sales and Distribution Document Item
        lr_itemx              TYPE REF TO bapisditmx.            "  class
* End   of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
  CONSTANTS: lc_update  TYPE updkz_d VALUE 'U',          " Update
             lc_error   TYPE bapi_mtype       VALUE 'E', " error
             lc_abend   TYPE bapi_mtype       VALUE 'A', " Abbend
             lc_success TYPE bapi_mtype       VALUE 'S', " suceess
* Begin of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
             lc_lp_code TYPE rvari_vnam       VALUE 'LP_CODE'. "Lapse code
* End   of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
  CREATE DATA: lr_header,
               lr_headerx,
* Begin of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
               lr_item,
               lr_itemx.
* End   of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890

* Begin of DEL:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
** Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
*               lr_sales_contract_inx,
*               lr_sales_contract_in.
** End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489

*  lr_header->qt_valid_t = sy-datum.
*  lr_headerx->qt_valid_t = abap_true.
* End   of DEL:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890

  lr_headerx->updateflag = lc_update.

* Begin of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
  CLEAR : li_vbap, lst_vbap.
  READ TABLE i_const REFERENCE INTO DATA(lst_const) WITH KEY param1 = lc_lp_code.
  IF sy-subrc = 0.
    SELECT vbeln posnr FROM vbap INTO TABLE li_vbap WHERE vbeln = fp_subssddoc.
*                                                  AND   uepos = '000000'.
    IF sy-subrc = 0.
      LOOP AT li_vbap INTO lst_vbap.
* Update contract cancellation reason code
        lr_item->itm_number = lst_vbap-posnr.
        lr_itemx->itm_number = lst_vbap-posnr.
        lr_item->reason_rej = lst_const->low.
        lr_itemx->reason_rej = abap_true.
        lr_itemx->updateflag = lc_update.

        APPEND lr_item->* TO li_item.
        CLEAR lr_item->*.
        APPEND lr_itemx->* TO li_itemx.
        CLEAR lr_itemx->*.
      ENDLOOP. " LOOP AT li_vbap INTO lst_vbap

    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF sy-subrc = 0
* End   of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890

* Begin of DEL:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
** Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
*  lr_sales_contract_inx->updateflag = lc_update.

*  lr_sales_contract_in->con_en_dat = sy-datum.
*  lr_sales_contract_inx->con_en_dat = abap_true.

*  APPEND lr_sales_contract_in->* TO li_sales_contract_in.
*  CLEAR lr_sales_contract_in->*.
*  APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
*  CLEAR lr_sales_contract_inx->*.
* End of DEL:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890

* BOC - GKINTALI - INC0202201 - 2018/08/27 - ED1K908393
* To update the order number in the message log for tracking purpose.
  IF sy-batch = abap_true.
    MESSAGE s250(zqtc_r2) WITH fp_subssddoc. " Quotation being lapsed : & .
  ENDIF. " IF sy-batch = abap_true
* EOC - GKINTALI - INC0202201 - 2018/08/27 - ED1K908393

* BOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739
*  IF v_1st_var IS INITIAL. "+ED2K912739
*    v_1st_var = fp_subssddoc. "+ED2K912739
*  ENDIF. " IF v_1st_var IS INITIAL
*  v_msgv1 = fp_subssddoc. "+ED2K912739
*  PERFORM add_message_log USING 'S' 'ZQTC_R2' '250'        "+ED2K912739
*                                v_msgv1 space space space. "+ED2K912739
* EOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739

  CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
    EXPORTING
      salesdocument    = fp_subssddoc
      order_header_in  = lr_header->*
      order_header_inx = lr_headerx->*
      simulation       = p_test
*     business_object  = 'BUS2034'
    TABLES
* Begin of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
      item_in          = li_item
      item_inx         = li_itemx
* End   of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
      return           = li_return.
* Begin of DEL:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
*      sales_contract_in  = li_sales_contract_in
*      sales_contract_inx = li_sales_contract_inx.
* End   of DEL:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
* End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
* Begin of DEL:CR# 546:WROY:03-JUN-2017:ED2K906489
* CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
*   EXPORTING
*     salesdocument    = fp_subssddoc
*     order_header_inx = lr_headerx->*
*     order_header_in  = lr_header->*
*     simulation       = p_test
*   TABLES
*     return           = li_return.
* End   of DEL:CR# 546:WROY:03-JUN-2017:ED2K906489
* BOC - NPALLA - E096 - 2018/08/31 - ED2K912739
  LOOP AT li_return INTO st_return. "+ED2K912739
    PERFORM add_message_log USING st_return-type st_return-id st_return-number "+ED2K912739
                                  st_return-message_v1 st_return-message_v2    "+ED2K912739
                                  st_return-message_v3 st_return-message_v4.   "+ED2K912739
    CLEAR st_return.
  ENDLOOP. " LOOP AT li_return INTO st_return
* EOC - NPALLA - E096 - 2018/08/31 - ED2K912739
  LOOP AT li_return REFERENCE INTO lr_return  WHERE type = lc_error
                                                 OR type = lc_abend. " Or of type
  ENDLOOP. " LOOP AT li_return REFERENCE INTO lr_return WHERE type = lc_error
*& If no Error / Abend happens
  IF sy-subrc <> 0.
    IF p_test = space.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = space.
*   Begin of ADD:SAP's Recommendations:WROY:01-Mar-2018:ED2K911135
    ELSE. " ELSE -> IF p_test = space
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*   End   of ADD:SAP's Recommendations:WROY:01-Mar-2018:ED2K911135
    ENDIF. " IF p_test = space
    READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = lc_success.
    IF sy-subrc = 0.
      IF p_test EQ space.
        IF fp_message IS INITIAL.
          CONCATENATE 'Quotation'(x03) fp_subssddoc 'Lapsed'(x04) INTO fp_message SEPARATED BY space.
*Begin of Add-Anirban-07.25.2017-ED2K907327-Defect 3479
          fp_status = abap_true.
*End of Add-Anirban-07.25.2017-ED2K907327-Defect 3479
        ELSE. " ELSE -> IF fp_message IS INITIAL
          CONCATENATE 'Quotation'(x03) fp_subssddoc 'Lapsed'(x04) INTO fp_message SEPARATED BY space.
        ENDIF. " IF fp_message IS INITIAL
      ELSE. " ELSE -> IF p_test EQ space
        IF fp_message IS INITIAL.
          CONCATENATE 'Quotation'(x03) fp_subssddoc 'can be Lapsed'(x08) INTO fp_message SEPARATED BY space.
        ELSE. " ELSE -> IF fp_message IS INITIAL
          CONCATENATE 'Quotation'(x03) fp_subssddoc 'can be Lapsed'(x08) INTO fp_message SEPARATED BY space.
        ENDIF. " IF fp_message IS INITIAL
      ENDIF. " IF p_test EQ space
    ENDIF. " IF sy-subrc = 0
  ELSE. " ELSE -> IF sy-subrc <> 0
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    IF fp_message IS INITIAL..
      CONCATENATE 'Quotation not Lapsed'(x02) fp_subssddoc INTO fp_message SEPARATED BY space.
    ELSE. " ELSE -> IF fp_message IS INITIAL
      CONCATENATE fp_message 'Quotation not Lapsed'(x02) fp_subssddoc INTO fp_message SEPARATED BY space.
    ENDIF. " IF fp_message IS INITIAL

  ENDIF. " IF sy-subrc <> 0

ENDFORM.
* Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_SALES_ORG
*&---------------------------------------------------------------------*
*       Validate Sales Org
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_sales_org .

  IF s_vkorg[] IS INITIAL.
    RETURN.
  ENDIF. " IF s_vkorg[] IS INITIAL

* Organizational Unit: Sales Organizations
  SELECT vkorg " Sales Organization
    FROM tvko  " Organizational Unit: Sales Organizations
   UP TO 1 ROWS
    INTO @DATA(lv_vkorg)
   WHERE vkorg IN @s_vkorg.
  ENDSELECT.
  IF sy-subrc NE 0.
*   Message: Invalid Sales Organization Number!
    MESSAGE e012(zqtc_r2). " Invalid Sales Organization Number!
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
* End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
* Begin of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_EXCL_REASON
*&---------------------------------------------------------------------*
*       Populate Exclusion Reason
*----------------------------------------------------------------------*
*      -->P_P_TEST  text
*      <--P_I_FINAL  text
*----------------------------------------------------------------------*
FORM f_populate_excl_reason  CHANGING fp_i_final TYPE tt_final .

  DATA:
    li_fld_detl TYPE ty_sval.

  CONSTANTS:
*   Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
    lc_act_cq   TYPE zactivity_sub VALUE 'CQ', " Activity: Create Quotation
*   End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
    lc_tab_name TYPE tabname   VALUE 'ZQTC_RENWL_PLAN', " Table Name
    lc_fld_name TYPE fieldname VALUE 'EXCL_RESN'.       " Field Name
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
*--*Popup to confirm the operation
  PERFORM f_popup_exclusion.
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
  DATA(li_final) = fp_i_final.
  DELETE li_final WHERE sel IS INITIAL.
  IF li_final IS INITIAL.
*   Message: No record to be processed
    MESSAGE i020(zrar_messages). " No record to be processed
    RETURN.
  ENDIF. " IF li_final IS INITIAL

* Take Input for Exclusion Reason
  APPEND INITIAL LINE TO li_fld_detl ASSIGNING FIELD-SYMBOL(<lst_fld_detl>).
  <lst_fld_detl>-tabname   = lc_tab_name.
  <lst_fld_detl>-fieldname = lc_fld_name.

* Dialog box for the display and request of values
  CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
      popup_title     = 'Enter Exclusion Reason'(005)
    TABLES
      fields          = li_fld_detl
    EXCEPTIONS
      error_in_fields = 1
      OTHERS          = 2.
  IF sy-subrc NE 0.
*   Nothing to do
  ENDIF. " IF sy-subrc NE 0
  READ TABLE li_fld_detl ASSIGNING <lst_fld_detl> INDEX 1.
  IF sy-subrc NE 0 OR
     <lst_fld_detl>-value IS INITIAL.
*   Message: No "Exclusion Reason" was entered!
    MESSAGE i500(zqtc_r2). " No "Exclusion Reason" was entered!
    RETURN.
  ENDIF. " IF sy-subrc NE 0 OR

  SORT li_final BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM li_final
         COMPARING vbeln posnr.
* Fetch details from Renewal Plan Table
* All fields (SELECT *) are fetched, since the entries have to be updated
* The table is being accessed again, to ensure that all Activities of an
* Order Item is excluded, even though User has not selected all of those
  SELECT *
    FROM zqtc_renwl_plan " E095: Renewal Plan Table
    INTO TABLE @DATA(li_renewal_plan)
     FOR ALL ENTRIES IN @li_final
   WHERE vbeln      EQ @li_final-vbeln
     AND posnr      EQ @li_final-posnr
*  Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
   ORDER BY PRIMARY KEY.
*  End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
*  Begin of DEL:ERP-6343:WROY:26-JUL-2018:ED2K912802
*    AND act_status EQ @abap_false.
*  End   of DEL:ERP-6343:WROY:26-JUL-2018:ED2K912802
  IF sy-subrc EQ 0.
*   Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
    DATA(li_renewal_plan_cq) = li_renewal_plan[].
*   Identify the records where CQ (Create Quotation) activity was completed
    DELETE li_renewal_plan_cq WHERE activity   NE lc_act_cq
                                 OR act_status NE abap_true
                                 OR ren_status NE space.

    DELETE li_renewal_plan WHERE act_status EQ abap_true.
*   End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
    LOOP AT li_renewal_plan ASSIGNING FIELD-SYMBOL(<lst_renewal_plan>).
*     Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
*     Identify the records where CQ (Create Quotation) activity was completed
      READ TABLE li_renewal_plan_cq TRANSPORTING NO FIELDS
           WITH KEY vbeln    = <lst_renewal_plan>-vbeln
                    posnr    = <lst_renewal_plan>-posnr
           BINARY SEARCH.
      IF sy-subrc EQ 0.
*       Verify if the Renewal Profile is applicable for Consolidation
        READ TABLE fp_i_final ASSIGNING FIELD-SYMBOL(<lst_final>)
              WITH TABLE KEY order_key
        COMPONENTS vbeln    = <lst_renewal_plan>-vbeln
                   posnr    = <lst_renewal_plan>-posnr.
        IF sy-subrc EQ 0 AND
           <lst_final>-consolidate EQ abap_true.
*         Update the corresponding Activity that Exclusion is not possible
          READ TABLE fp_i_final ASSIGNING <lst_final>
                WITH TABLE KEY vbeln_key
          COMPONENTS vbeln    = <lst_renewal_plan>-vbeln
                     posnr    = <lst_renewal_plan>-posnr
                     activity = <lst_renewal_plan>-activity.
          IF sy-subrc EQ 0.
            <lst_final>-message = 'Exclusion not possible - Applicable for Consolidation'(009). "Message
          ENDIF. " IF sy-subrc EQ 0
          CLEAR: <lst_renewal_plan>-mandt.
          CONTINUE.
        ENDIF. " IF sy-subrc EQ 0 AND
      ENDIF. " IF sy-subrc EQ 0
*     End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802

      <lst_renewal_plan>-excl_resn = <lst_fld_detl>-value. "Exclusion Reason
      <lst_renewal_plan>-excl_date = sy-datum. "Exclusion Date
      <lst_renewal_plan>-aedat     = sy-datum. "Changed On
      <lst_renewal_plan>-aezet     = sy-uzeit. "Changed At
      <lst_renewal_plan>-aenam     = sy-uname. "Changed By

      READ TABLE fp_i_final ASSIGNING <lst_final>
            WITH TABLE KEY vbeln_key
      COMPONENTS vbeln    = <lst_renewal_plan>-vbeln
                 posnr    = <lst_renewal_plan>-posnr
                 activity = <lst_renewal_plan>-activity.
      IF sy-subrc EQ 0.
        <lst_final>-excl_resn = <lst_fld_detl>-value. "Exclusion Reason
        <lst_final>-excl_date = sy-datum. "Exclusion Date
        READ TABLE i_excl_resn ASSIGNING FIELD-SYMBOL(<lst_excl_resn>)
             WITH KEY excl_resn = <lst_final>-excl_resn
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          <lst_final>-excl_resn_d = <lst_excl_resn>-excl_resn_d. "Exclusion Reason Text
        ENDIF. " IF sy-subrc EQ 0
        <lst_final>-aedat   = <lst_renewal_plan>-aedat. "Changed On
        <lst_final>-aezet   = <lst_renewal_plan>-aezet. "Changed At
        <lst_final>-aenam   = <lst_renewal_plan>-aenam. "Changed By
        <lst_final>-message = 'Exclusion Reason is populated'(006). "Message
      ENDIF. " IF sy-subrc EQ 0
    ENDLOOP. " LOOP AT li_renewal_plan ASSIGNING FIELD-SYMBOL(<lst_renewal_plan>)
*   Begin of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802
*   Remove the entries, those can not be excluded
    DELETE li_renewal_plan WHERE mandt IS INITIAL.
*   End   of ADD:ERP-6343:WROY:26-JUL-2018:ED2K912802

*   Update Renewal Plan Table
    CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL'
      TABLES
        t_renwl_plan = li_renewal_plan.
    COMMIT WORK AND WAIT.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_REMOVE_EXCL_REASON
*&---------------------------------------------------------------------*
*       Remove Exclusion Reason
*----------------------------------------------------------------------*
*      <--FP_I_FINAL  Final table
*----------------------------------------------------------------------*
FORM f_remove_excl_reason  CHANGING fp_i_final TYPE tt_final.

  PERFORM f_popup_inclusion.

  DATA(li_final) = fp_i_final.
  DELETE li_final WHERE sel       IS INITIAL
                     OR excl_resn IS INITIAL.
  IF li_final IS INITIAL.
*   Message: No record to be processed
    MESSAGE i020(zrar_messages). " No record to be processed
    RETURN.
  ENDIF. " IF li_final IS INITIAL

  SORT li_final BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM li_final
         COMPARING vbeln posnr.
* Fetch details from Renewal Plan Table
* All fields (SELECT *) are fetched, since the entries have to be updated
* The table is being accessed again, to ensure that all Activities of an
* Order Item is included, even though User has not selected all of those
  SELECT *
    FROM zqtc_renwl_plan " E095: Renewal Plan Table
    INTO TABLE @DATA(li_renewal_plan)
     FOR ALL ENTRIES IN @li_final
   WHERE vbeln      EQ @li_final-vbeln
     AND posnr      EQ @li_final-posnr
     AND act_status EQ @abap_false.
  IF sy-subrc EQ 0.
    LOOP AT li_renewal_plan ASSIGNING FIELD-SYMBOL(<lst_renewal_plan>).
      CLEAR: <lst_renewal_plan>-excl_resn, "Exclusion Reason
             <lst_renewal_plan>-excl_date. "Exclusion date
      <lst_renewal_plan>-aedat = sy-datum. "Changed On
      <lst_renewal_plan>-aezet = sy-uzeit. "Changed At
      <lst_renewal_plan>-aenam = sy-uname. "Changed By

      READ TABLE fp_i_final ASSIGNING FIELD-SYMBOL(<lst_final>)
            WITH TABLE KEY vbeln_key
      COMPONENTS vbeln    = <lst_renewal_plan>-vbeln
                 posnr    = <lst_renewal_plan>-posnr
                 activity = <lst_renewal_plan>-activity.
      IF sy-subrc EQ 0.
        CLEAR: <lst_final>-excl_resn,   "Exclusion Reason
               <lst_final>-excl_date,   "Exclusion Date
               <lst_final>-excl_resn_d. "Exclusion Reason Text
        <lst_final>-aedat   = <lst_renewal_plan>-aedat. "Changed On
        <lst_final>-aezet   = <lst_renewal_plan>-aezet. "Changed At
        <lst_final>-aenam   = <lst_renewal_plan>-aenam. "Changed By
        <lst_final>-message = 'Exclusion Reason is removed'(004). "Message
      ENDIF. " IF sy-subrc EQ 0
    ENDLOOP. " LOOP AT li_renewal_plan ASSIGNING FIELD-SYMBOL(<lst_renewal_plan>)

*   Update Renewal Plan Table
    CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL'
      TABLES
        t_renwl_plan = li_renewal_plan.
    COMMIT WORK AND WAIT.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MODIFY_SEL_SCREEN
*&---------------------------------------------------------------------*
*       Modify Selection SCreen
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_modify_sel_screen.
*Begin of insert by <HIPATEL> <INC0234283> <ED1K909890> <03/27/2019>
*New transaction code for authorized user
  CONSTANTS: lc_tcode TYPE tcode VALUE 'ZQTC_AUTO_RENEWAL_02'.
*End of insert by <HIPATEL> <INC0234283> <ED1K909890> <03/27/2019>

  LOOP AT SCREEN.
    IF p_excld IS INITIAL AND  "Only Excluded Items
       screen-group1 EQ 'EXC'. "Exclusion Reason
      screen-active = '0'.
      MODIFY SCREEN.
    ENDIF. " IF p_excld IS INITIAL AND
*Begin of insert by <HIPATEL> <INC0234283> <ED1K909890> <03/27/2019>
    IF sy-tcode NE lc_tcode AND screen-group1 EQ 'CUR'.
      screen-active = '0'.
      MODIFY SCREEN.
    ENDIF.
*End of insert by <HIPATEL> <INC0234283> <ED1K909890> <03/27/2019>
*** BOC: DM-1923  KKRAVURI20190606  ED2K915200
    IF ( p_test = abap_true OR p_clear = abap_true ) AND
        screen-group1 EQ 'CHK' . "Exclusion Reason
      screen-input = '0'.
*      screen-invisible = '1'.
      p_chck = abap_false.
      MODIFY SCREEN.
    ENDIF. " IF p_excld IS INITIAL AND
*** EOC: DM-1923  KKRAVURI20190606  ED2K915200
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
    IF p_ex_in IS NOT INITIAL AND "Perform exclude/Include
*--*Disable rest of the check boxes
       ( screen-group1 EQ 'EXD' OR screen-group1 EQ 'TES'
       OR screen-group1 EQ 'CLR' OR screen-group1 EQ 'CHK').
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
    IF  p_excld IS NOT INITIAL  AND  "Only Excluded Items / test option.
*--*Disable rest of the check boxes
      ( screen-group1 EQ 'EXI' OR screen-group1 EQ 'CLR'
        OR screen-group1 EQ 'TES' OR screen-group1 EQ 'CHK'). "Perform exclude/Include
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.

    IF p_chck IS NOT INITIAL AND ( screen-group1 EQ 'EXI' OR screen-group1 EQ 'EXD'
                                   OR screen-group1 EQ 'TES' OR screen-group1 EQ 'CLR').
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.

    IF p_test IS NOT INITIAL AND  "Test
*--*Disable rest of the check boxes
      ( screen-group1 EQ 'EXI' OR screen-group1 EQ 'EXD'
                                    OR screen-group1 EQ 'CLR' OR screen-group1 EQ 'CHK').
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
    IF p_clear IS NOT INITIAL AND "Clear
*--*Disable rest of the check boxes
      ( screen-group1 EQ 'EXI' OR screen-group1 EQ 'EXD'
                                   OR screen-group1 EQ 'TES' OR screen-group1 EQ 'CHK').
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
  ENDLOOP. " LOOP AT SCREEN


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MATERIAL_NO
*&---------------------------------------------------------------------*
*       Validate Material Number
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_material_no .

  IF s_matnr[] IS INITIAL.
    RETURN.
  ENDIF. " IF s_matnr[] IS INITIAL
* Validate Material Number from General Material Data
  SELECT matnr " Material Number
    FROM mara  " General Material Data
    UP TO 1 ROWS
    INTO @DATA(lv_matnr)
   WHERE matnr IN @s_matnr.
  ENDSELECT.
  IF sy-subrc NE 0.
    CLEAR: lv_matnr.
*   Message: Please enter a valid material
    MESSAGE e213(cocm). " Please enter a valid material
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MAT_GRP_5
*&---------------------------------------------------------------------*
*       Validate Material Group 5
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_mat_grp_5 .

  IF s_mvgr5[] IS INITIAL.
    RETURN.
  ENDIF. " IF s_mvgr5[] IS INITIAL
* Validate Material group 5 from Material Pricing Group 5 data
  SELECT mvgr5 " Material group 5
    FROM tvm5  " Material Pricing Group 5
   UP TO 1 ROWS
    INTO @DATA(lv_mvgr5)
   WHERE mvgr5 IN @s_mvgr5.
  ENDSELECT.
  IF sy-subrc NE 0.
    CLEAR: lv_mvgr5.
*   Message: Please enter a valid Material Group 5.
    MESSAGE e501(zqtc_r2). " Please enter a valid Material Group 5.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_CUST_COND_GRP_2
*&---------------------------------------------------------------------*
*       Validate Customer condition group 2
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_cust_cond_grp_2 .

  IF s_kdkg2[] IS INITIAL.
    RETURN.
  ENDIF. " IF s_kdkg2[] IS INITIAL
* Validate Customer condition group 2 from Customer Condition Groups
  SELECT kdkgr " Customer Attribute for Condition Groups
    FROM tvkgg " Customer Condition Groups (Customer Master)
   UP TO 1 ROWS
    INTO @DATA(lv_kdkgr)
   WHERE kdkgr IN @s_kdkg2.
  ENDSELECT.
  IF sy-subrc NE 0.
    CLEAR: lv_kdkgr.
*   Message: Please enter a valid Customer Condition Group 2.
    MESSAGE e502(zqtc_r2). " Please enter a valid Customer Condition Group 2.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
* End   of ADD:ERP-6347:WROY:19-JUN-2018:ED2K912349
*Begin of ADD:ERP-6343:NGADRE:01-AUG-2018:ED2K912802
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_CONSOLIDATE_DATA
*&---------------------------------------------------------------------*
*       Process the Sub. Line for consolidation
*----------------------------------------------------------------------*
*      -->FP_LI_CONSOLIDATE_DATA  Consolidated line data
*      -->FP_I_ITEM  Line item data
*      -->FP_I_BUSINESS  Business data
*      -->FP_I_PARTNER  partner details
*      -->FP_I_TEXTHEADERS  Header text information
*      -->FP_I_TEXTLINES  Item text information
*      -->FP_I_HEADER  header details
*      -->FP_I_CONTRACT  Contract details
*      -->FP_I_NOTIF_PROF  Notification Profile
*      -->FP_I_RENWAL  Renewal table
*      -->FP_I_EXT_VBAP  Custom Field i Sub. order
*      -->FP_I_VEDA  VEDA data
*      -->FP_I_NAST  Nast table entries
*      -->FP_I_DOCFLOW  Document flow data
*      -->FP_P_TEST  Test Run Flag
*      <--FP_I_FINAL  Final table
*      <--FP_LI_RENEWAL_PLAN  Renewal plan data
*----------------------------------------------------------------------*
FORM f_process_consolidate_data  USING    fp_li_consolidate_data TYPE tt_consolidate_data
                                          fp_v_jobname     TYPE btcjob
                                          fp_i_item        TYPE tt_item
                                          fp_i_business    TYPE tt_business
                                          fp_i_partner     TYPE tt_partner
                                          fp_i_textheaders TYPE tt_textheaders
                                          fp_i_textlines   TYPE tt_textlines
                                          fp_i_header      TYPE tt_header
                                          fp_i_contract    TYPE tt_contract
                                          fp_i_notif_prof  TYPE tt_notif_p_det
                                          fp_i_renwal      TYPE tt_renwl_plan
                                          fp_i_ext_vbap    TYPE tt_ext_vbap
                                          fp_i_veda        TYPE tt_veda
                                          fp_i_nast        TYPE tt_nast
                                          fp_i_const       TYPE tt_const
                                          fp_li_final      TYPE tt_final
                                          fp_p_test        TYPE char1 " P_test of type CHAR1
                                 CHANGING fp_i_final       TYPE tt_final
                                          li_renewal_plan  TYPE tt_renwl_plan.

**local constant declaration
  CONSTANTS : lc_cq        TYPE zactivity_sub VALUE 'CQ',     " create Quotation
              lc_posnr_low TYPE vbap-posnr    VALUE '000000', " To indicate Header
              lc_reminder  TYPE char1         VALUE 'R',      " First letter of Reminder activity
              lc_kappl     TYPE kappl         VALUE 'V',      " Application
              lc_kschl     TYPE kschd         VALUE 'Z001'.   " Material determination type

**local data declarations
  DATA : lr_consolidate_data TYPE REF TO ty_consolidate_data, " Consolidate_data class
         li_consolidate_temp TYPE tt_consolidate_data,
         lr_i_headr          TYPE REF TO bapisdhd,            " BAPI Structure of VBAK with English Field Names
         lr_renewal_plan     TYPE REF TO zqtc_renwl_plan,     " Reference varibale for Plan table
         lr_final            TYPE REF TO ty_renwl_plan,       " Reference variable for final table
         lr_i_notif_prof     TYPE REF TO ty_notif_p_det,      " Reference variable for notification determination
         lr_item             TYPE REF TO bapisdit,            " Structure of VBAP with English Field Names
         lr_business         TYPE REF TO bapisdbusi,          " VBKD Structure
         lr_ext_vbap         TYPE REF TO bape_vbap,           " "Added by MODUTTA:5th-Jun-18:INC0197849:TR# ED1K907603
         li_header           TYPE tt_header,                  " Internal table for header
         li_partner          TYPE tt_partner,                 " Internal table for partner
         li_contract         TYPE tt_contract,                " BAPI Structure of VEDA with English Field Names
         lr_contract         TYPE REF TO bapisdcntr,          " BAPI Structure of VEDA with English Field Names
         lr_partner          TYPE REF TO bapisdpart,          " Reference for partner
         li_textheaders      TYPE tt_textheaders,             " Text headers
         lr_textheaders      TYPE REF TO bapisdtehd,          " BAPI Structure of THEAD with English Field Names
         li_textlines        TYPE tt_textlines,               " Text lines
         lr_textlines        TYPE REF TO bapitextli,          " Text lines reference
         li_business         TYPE tt_business,                " VBKD data
         li_ext_vbap         TYPE tt_ext_vbap,
         li_item             TYPE tt_item,                    " Item
         lv_act_status       TYPE char01,                     " Act_status of type CHAR01
         lv_message          TYPE char120,                    " Message of type CHAR120
         lv_message_final    TYPE char120,                    " Message_final of type CHAR120
         lv_msg_flag         TYPE abap_bool VALUE abap_false,
         li_sub_mat          TYPE tt_sub_mat.

**fetch substitute material from KONDD table
  IF fp_li_consolidate_data IS NOT INITIAL.

    li_consolidate_temp = fp_li_consolidate_data.

    SORT li_consolidate_temp BY material.
    DELETE ADJACENT DUPLICATES FROM li_consolidate_temp
             COMPARING material.

    SELECT a~matwa,
           b~smatn " Substitute material
      FROM kondd AS b INNER JOIN kotd001 AS a
         ON a~knumh = b~knumh
         FOR ALL ENTRIES IN @li_consolidate_temp
         WHERE a~kappl = @lc_kappl
         AND a~matwa   = @li_consolidate_temp-material
         AND a~kschl   = @lc_kschl
         AND ( datab LE @sy-datum AND datbi GE @sy-datum )
         INTO TABLE @li_sub_mat.

    IF sy-subrc EQ 0.

      SORT li_sub_mat BY matwa.

    ENDIF. " IF sy-subrc EQ 0

  ENDIF. " IF fp_li_consolidate_data IS NOT INITIAL

  CREATE DATA lr_renewal_plan.

  CLEAR li_consolidate_temp[].

**loop at all the sub. order line item details and at end of each Renewal date
**create the Quotation or Reminder as per Activity value
  LOOP AT fp_li_consolidate_data REFERENCE INTO lr_consolidate_data.

    APPEND lr_consolidate_data->* TO li_consolidate_temp.

    IF lr_consolidate_data->act_status EQ space.

      IF lr_consolidate_data->activity EQ lc_cq.

*Header details
        READ TABLE fp_i_header REFERENCE INTO lr_i_headr
                                  WITH KEY doc_number = lr_consolidate_data->vbeln.
        IF sy-subrc EQ 0.
          APPEND lr_i_headr->* TO li_header.
        ENDIF. " IF sy-subrc EQ 0


*& Populate VBKD data

        READ TABLE fp_i_business
        REFERENCE INTO lr_business
        WITH KEY sd_doc = lr_i_headr->doc_number
                 itm_number = lc_posnr_low.
        IF sy-subrc = 0.
          APPEND lr_business->* TO li_business.
        ENDIF. " IF sy-subrc = 0


        READ TABLE fp_i_contract
        REFERENCE INTO lr_contract
        WITH KEY doc_number = lr_i_headr->doc_number
                              itm_number = lc_posnr_low.
        IF sy-subrc = 0.
          APPEND lr_contract->* TO li_contract.
        ENDIF. " IF sy-subrc = 0


        LOOP AT fp_i_textheaders REFERENCE INTO lr_textheaders WHERE sd_doc = lr_i_headr->doc_number.

          LOOP AT fp_i_textlines  REFERENCE INTO lr_textlines WHERE text_name = lr_textheaders->text_name.
            APPEND lr_textlines->* TO li_textlines.
          ENDLOOP. " LOOP AT fp_i_textlines REFERENCE INTO lr_textlines WHERE text_name = lr_textheaders->text_name

          APPEND lr_textheaders->* TO li_textheaders  .

        ENDLOOP. " LOOP AT fp_i_textheaders REFERENCE INTO lr_textheaders WHERE sd_doc = lr_i_headr->doc_number

*item details
        LOOP AT fp_i_partner REFERENCE INTO lr_partner
                                WHERE sd_doc = lr_consolidate_data->vbeln
                                  AND ( itm_number = lr_consolidate_data->posnr
                                   OR itm_number = lc_posnr_low ).

          APPEND lr_partner->* TO li_partner.

        ENDLOOP. " LOOP AT fp_i_partner REFERENCE INTO lr_partner
*& Populate Item details.
        CLEAR lr_item.
        READ TABLE fp_i_item
        REFERENCE INTO lr_item
        WITH KEY doc_number = lr_consolidate_data->vbeln
                 itm_number = lr_consolidate_data->posnr.
        IF sy-subrc = 0.
          APPEND lr_item->* TO li_item.

        ENDIF. " IF sy-subrc = 0

*         Populate BAPI extension
        CLEAR lr_ext_vbap.
        READ TABLE fp_i_ext_vbap
        REFERENCE INTO lr_ext_vbap
        WITH KEY vbeln = lr_consolidate_data->vbeln
                 posnr = lr_consolidate_data->posnr
        BINARY SEARCH.
        IF sy-subrc EQ 0.
          APPEND lr_ext_vbap->* TO li_ext_vbap.
        ENDIF. " IF sy-subrc EQ 0

        READ TABLE fp_i_business
        REFERENCE INTO lr_business
        WITH KEY sd_doc = lr_consolidate_data->vbeln
                 itm_number = lr_consolidate_data->posnr.
        IF sy-subrc = 0.
          APPEND lr_business->* TO li_business.
        ENDIF. " IF sy-subrc = 0

        READ TABLE fp_i_contract
        REFERENCE INTO lr_contract
        WITH KEY doc_number = lr_consolidate_data->vbeln
                 itm_number = lr_consolidate_data->posnr.
        IF sy-subrc = 0.
          APPEND lr_contract->* TO li_contract.
*
        ENDIF. " IF sy-subrc = 0


      ELSE. " ELSE -> IF lr_consolidate_data->activity EQ lc_cq

*Header details
        READ TABLE fp_i_header REFERENCE INTO lr_i_headr
                                  WITH KEY doc_number = lr_consolidate_data->vbeln.
        IF sy-subrc EQ 0.
          APPEND lr_i_headr->* TO li_header.
        ENDIF. " IF sy-subrc EQ 0

        CLEAR li_partner.

        LOOP AT fp_i_partner REFERENCE INTO lr_partner
                  WHERE sd_doc = lr_consolidate_data->vbeln
                    AND itm_number = lc_posnr_low.

          APPEND lr_partner->* TO li_partner.

        ENDLOOP. " LOOP AT fp_i_partner REFERENCE INTO lr_partner

        LOOP AT fp_i_partner REFERENCE INTO lr_partner
                             WHERE sd_doc = lr_consolidate_data->vbeln
                                   AND itm_number = lr_consolidate_data->posnr.
          APPEND lr_partner->* TO li_partner.

        ENDLOOP. " LOOP AT fp_i_partner REFERENCE INTO lr_partner

      ENDIF. " IF lr_consolidate_data->activity EQ lc_cq

    ENDIF. " IF lr_consolidate_data->act_status EQ space

    AT END OF renwl_date.

      READ TABLE li_consolidate_temp ASSIGNING FIELD-SYMBOL(<lst_consolidate_temp>)
                                         INDEX 1.
      IF sy-subrc EQ 0.

        IF <lst_consolidate_temp>-activity EQ lc_cq.
**call the perform create quotation and update the final table and Profile table.

          PERFORM f_create_quoatation_con_data USING  li_consolidate_temp
                                                      li_header
                                                      li_item
                                                      li_business
                                                      li_ext_vbap
                                                      li_partner
                                                      li_textheaders
                                                      li_textlines
                                                      li_contract
                                                      fp_i_const
                                                      li_sub_mat
                                                      fp_p_test
                                             CHANGING v_sales_ord
                                                      lv_act_status
                                                      lv_message
                                                      i_return.


**send the Reminder notification for consolidated data
        ELSE . " ELSE -> IF <lst_consolidate_temp>-activity EQ lc_cq

          READ TABLE fp_li_final ASSIGNING FIELD-SYMBOL(<lst_final_temp>)
                                             WITH KEY vbeln = <lst_consolidate_temp>-vbeln
                                                      posnr = <lst_consolidate_temp>-posnr
                                                      activity = <lst_consolidate_temp>-activity.
          IF sy-subrc EQ 0
         AND <lst_final_temp> IS ASSIGNED.

**Trigger the Notification
            PERFORM f_trigger_output_type USING fp_i_const
                                                li_partner
                                                fp_i_notif_prof
                                                fp_i_nast
                                       CHANGING <lst_final_temp>.

            lv_act_status = <lst_final_temp>-act_status.
            lv_message   = <lst_final_temp>-message.

          ENDIF. " IF sy-subrc EQ 0


        ENDIF. " IF <lst_consolidate_temp>-activity EQ lc_cq

** check the status of quotation creation or reminder notifications. Update the status in
** ALV final table and Renewal Plan table with Date / time and changed by
        LOOP AT li_consolidate_temp ASSIGNING <lst_consolidate_temp>.

          READ TABLE fp_li_final ASSIGNING FIELD-SYMBOL(<lst_fp_i_final_e095>)
                                                     WITH KEY vbeln = <lst_consolidate_temp>-vbeln
                                                              posnr = <lst_consolidate_temp>-posnr
                                                              activity = <lst_consolidate_temp>-activity.
          IF sy-subrc EQ 0.


            CLEAR lv_message_final.
* BOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739
            v_1st_var = <lst_consolidate_temp>-vbeln.
* EOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739

            IF ( ( lv_act_status EQ abap_true AND
                   lv_act_status NE <lst_consolidate_temp>-act_status ) OR " OR Condition is added as part of CR# 6295
                   p_test = abap_true ). " Before CR# 6295 changes, no OR p_test = abap_true condition.

              " Below IF condition is added as part of CR# 6295 changes
              " Before CR# 6295 changes, no IF condition
              IF <lst_consolidate_temp>-act_status <> abap_true.

                lv_message_final = lv_message.
*** BOC: CR# 6295  KKR20180918
                IF lv_message_final IS NOT INITIAL.
                  lv_msg_flag = abap_true.
                  PERFORM add_pgm_message_log USING lv_message_final
                                                    c_msg_typ_i
                                                    c_msg_num_0.
                ENDIF.
*** EOC: CR# 6295  KKR20180918
                <lst_fp_i_final_e095>-act_status = lv_act_status.

                MOVE:   <lst_fp_i_final_e095>-vbeln TO lr_renewal_plan->vbeln,
                        <lst_fp_i_final_e095>-posnr TO lr_renewal_plan->posnr,
                        <lst_fp_i_final_e095>-renwl_prof TO lr_renewal_plan->renwl_prof,
                        <lst_fp_i_final_e095>-activity TO lr_renewal_plan->activity,
                        <lst_fp_i_final_e095>-matnr TO lr_renewal_plan->matnr,
                        lv_act_status TO lr_renewal_plan->act_status,
                        <lst_fp_i_final_e095>-promo_code TO lr_renewal_plan->promo_code,
                        <lst_fp_i_final_e095>-eadat TO lr_renewal_plan->eadat,
                        <lst_fp_i_final_e095>-ren_status TO lr_renewal_plan->ren_status.
                <lst_fp_i_final_e095>-aedat = lr_renewal_plan->aedat = sy-datum.
                <lst_fp_i_final_e095>-aezet =  lr_renewal_plan->aezet = sy-uzeit.
                <lst_fp_i_final_e095>-aenam = lr_renewal_plan->aenam = sy-uname.

*** Begin of: KKRAVURI KKR20180912 CR# 6295
                PERFORM f_create_log  USING v_1st_var
                                            i_bal_msg
                                   CHANGING v_lognumber.

                IF <lst_fp_i_final_e095>-lognumber IS NOT INITIAL AND
                    v_lognumber IS NOT INITIAL.
                  PERFORM f_add_previous_log_msg  USING <lst_fp_i_final_e095>-lognumber
                                                        v_log_handle.
                ENDIF.

                IF v_log_type IS NOT INITIAL.
                  <lst_fp_i_final_e095>-log_type  = lr_renewal_plan->log_type  = v_log_type.  " Log Type E/W/S/I
                ENDIF.
                IF v_lognumber IS NOT INITIAL.
                  <lst_fp_i_final_e095>-lognumber = lr_renewal_plan->lognumber = v_lognumber. " Log Number (SLG1)
                ENDIF.

                <lst_fp_i_final_e095>-test_run = lr_renewal_plan->test_run  = p_test.         " Test Run

                IF <lst_fp_i_final_e095>-lognumber IS NOT INITIAL.
                  PERFORM f_get_msg_icon  USING    <lst_fp_i_final_e095>-log_type
                                          CHANGING <lst_fp_i_final_e095>-log_type_desc.
                ENDIF.

                MOVE: <lst_fp_i_final_e095>-review_stat TO lr_renewal_plan->review_stat, " Not Reviewed
                      <lst_fp_i_final_e095>-comments    TO lr_renewal_plan->comments.    " No Review Comments

                IF sy-batch = abap_true.
                  GET TIME.
                  DATA(lv_date) = sy-datum.
                  DATA(lv_time) = sy-uzeit.

                  <lst_fp_i_final_e095>-jobname  = lr_renewal_plan->jobname = fp_v_jobname.
                  <lst_fp_i_final_e095>-job_date = lr_renewal_plan->job_date = lv_date.
                  <lst_fp_i_final_e095>-job_time = lr_renewal_plan->job_time = lv_time.
                ENDIF.
*** End of: KKRAVURI KKR20180912 CR# 6295
                APPEND lr_renewal_plan->* TO li_renewal_plan.
                CLEAR  lr_renewal_plan->*.

*              BOC - NPALLA - E096 - 2018/08/31 - ED2K912739
*              COMMIT WORK AND WAIT.         " -ED2K912739
                IF fp_p_test = abap_false.   " +ED2K912739
                  COMMIT WORK AND WAIT.      " +ED2K912739
                ENDIF. " IF fp_p_test = abap_false
*              EOC - NPALLA - E096 - 2018/08/31 - ED2K912739

              ELSEIF <lst_consolidate_temp>-act_status EQ abap_true.

                CONCATENATE 'Activity already Preformed'(x01) lv_message_final INTO lv_message_final.

              ELSE. " ELSE -> IF ( ( lv_act_status EQ abap_true ) AND

                lv_message_final = lv_message.

              ENDIF. " IF <lst_consolidate_temp>-act_status <> abap_true

            ENDIF. " IF ( ( lv_act_status EQ abap_true ) AND

          ENDIF. " IF sy-subrc EQ 0

**Update ALV output table with Details
          READ TABLE fp_i_final ASSIGNING FIELD-SYMBOL(<lst_i_final>)
                                  WITH TABLE KEY  vbeln_key COMPONENTS vbeln = <lst_consolidate_temp>-vbeln
                                                                       posnr = <lst_consolidate_temp>-posnr
                                                                       activity = <lst_consolidate_temp>-activity.
          IF sy-subrc = 0.

            MOVE: lv_message_final TO <lst_i_final>-message,
                  <lst_fp_i_final_e095>-act_status TO <lst_i_final>-act_status,
                  <lst_fp_i_final_e095>-aedat TO <lst_i_final>-aedat,
                  <lst_fp_i_final_e095>-aenam TO <lst_i_final>-aenam,
                  <lst_fp_i_final_e095>-aezet TO <lst_i_final>-aezet.
*           BOC - NPALLA - E096 - 2018/08/31 - ED2K912739
            MOVE: <lst_fp_i_final_e095>-log_type      TO <lst_i_final>-log_type,      " Log Type E/W/S/I
                  <lst_fp_i_final_e095>-lognumber     TO <lst_i_final>-lognumber,     " Log Number (SLG1)
                  <lst_fp_i_final_e095>-test_run      TO <lst_i_final>-test_run,      " Test Run
                  <lst_fp_i_final_e095>-log_type_desc TO <lst_i_final>-log_type_desc, " Log Type Desc
                  <lst_fp_i_final_e095>-review_stat   TO <lst_i_final>-review_stat,   " Not Reviewed
                  <lst_fp_i_final_e095>-comments      TO <lst_i_final>-comments,      " No Review Comments
                  <lst_fp_i_final_e095>-jobname       TO <lst_i_final>-jobname,
                  <lst_fp_i_final_e095>-job_date      TO <lst_i_final>-job_date,
                  <lst_fp_i_final_e095>-job_time      TO <lst_i_final>-job_time.
            IF <lst_i_final>-lognumber IS NOT INITIAL.
              SHIFT <lst_i_final>-lognumber LEFT DELETING LEADING '0'.
            ENDIF.
            IF <lst_i_final>-message IS NOT INITIAL.
              IF lv_msg_flag = abap_false.
                PERFORM add_pgm_message_log USING <lst_i_final>-message
                                                  c_msg_typ_i
                                                  c_msg_num_6.
              ENDIF.
            ENDIF. " IF <lst_i_final>-message IS NOT INITIAL
            " Update BAPI Messages to Application Log
            IF i_bal_msg[] IS NOT INITIAL.
              PERFORM f_maintain_log  USING v_log_handle
                                            i_bal_msg
                                   CHANGING i_log_handle.
              CLEAR: i_bal_msg[], v_log_handle, lv_msg_flag.
            ENDIF. " IF i_bal_msg IS NOT INITIAL

            " Save the Messages to Application Log
            IF i_log_handle[] IS NOT INITIAL.
              PERFORM f_save_log USING i_log_handle.
              CLEAR: i_log_handle[], v_1st_var.
            ENDIF.
*       EOC - NPALLA - E096 - 2018/08/31 - ED2K912739

          ENDIF. " IF sy-subrc = 0

        ENDLOOP. " LOOP AT li_consolidate_temp ASSIGNING <lst_consolidate_temp>

**clear all the local internal table for next processing
        CLEAR : li_header[],
                li_partner[],
                li_business[],
                li_contract[],
                li_ext_vbap[],
                li_textheaders[],
                li_textlines[],
                li_item[],
                li_consolidate_temp[],
                lv_act_status,
                lv_message,
                v_log_type, v_lognumber.

      ENDIF. " IF sy-subrc EQ 0

    ENDAT.

  ENDLOOP. " LOOP AT fp_li_consolidate_data REFERENCE INTO lr_consolidate_data

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_QUOATATION_CON_DATA
*&---------------------------------------------------------------------*
*       Create Quotation with reference to subscription
*----------------------------------------------------------------------*
*      -->FP_I_HEADER   Header
*      -->FP_I_ITEM     Items
*      -->FP_I_PARTNER  Partner details
*      -->FP_I_TEXTHEADERS  text header
*      -->FP_I_TEXTLINES  text items
*      -->FP_I_contract  Contract data
*      -->FP_CONST       Constant table
*----------------------------------------------------------------------*
FORM f_create_quoatation_con_data  USING  fp_li_consolidate_temp TYPE tt_consolidate_data
                                          fp_li_header TYPE tt_header
                                          fp_li_item TYPE tt_item
                                          fp_li_business TYPE tt_business
                                          fp_li_ext_vbap TYPE tt_ext_vbap
                                          fp_li_partner TYPE tt_partner
                                          fp_li_textheaders TYPE tt_textheaders
                                          fp_li_textlines TYPE tt_textlines
                                          fp_li_contract TYPE tt_contract
                                          fp_const TYPE tt_const
                                          fp_li_sub_mat TYPE tt_sub_mat
                                          fp_test TYPE char1                 " Test of type CHAR1
                                 CHANGING fp_v_salesord TYPE bapivbeln-vbeln " Sales Document
                                          fp_v_act_status   TYPE zact_status " Activity Status
                                          fp_message TYPE char120            " Message of type CHAR120
                                          fp_i_return TYPE  tt_return.

  DATA: lr_header             TYPE REF TO bapisdhd1,                            " Reference for header data
        lr_i_partner          TYPE REF TO bapisdpart,                           "Reference for partner
        lr_i_header           TYPE REF TO  bapisdhd,                            " Reference for bapi header
        li_partner            TYPE STANDARD TABLE OF bapiparnr INITIAL SIZE 0,  " Internal table for partner details
        li_business           TYPE STANDARD TABLE OF bapisdbusi INITIAL SIZE 0, " BAPI Structure of VBKD with English Field Names
        li_return             TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0,   " reference variable for return
        lr_sales_contract_in  TYPE  REF TO bapictr ,                            " contract data
        li_sales_contract_in  TYPE STANDARD TABLE OF bapictr ,                  " Internal  table for cond
        lr_sales_contract_inx TYPE REF TO  bapictrx ,                           " Communication fields: SD Contract Data Checkbox
        li_sales_contract_inx TYPE  STANDARD TABLE OF bapictrx INITIAL SIZE 0 , " Communication fields: SD Contract Data Checkbox
        lr_const              TYPE REF TO ty_const,                             " reference for consatnt table
        lr_partner            TYPE REF TO bapiparnr,                            " refrence for partner
        li_item               TYPE STANDARD TABLE OF bapisditm INITIAL SIZE 0,  " Items
        lr_item               TYPE REF TO bapisditm,                            " reference variable for Item
        lr_business           TYPE REF TO bapisdbusi,                           " VBKD data
        li_itemx              TYPE STANDARD TABLE OF bapisditmx INITIAL SIZE 0, " reference for itemx
        lr_contract           TYPE REF TO bapisdcntr,                           " BAPI Structure of VEDA
        lr_return             TYPE REF TO bapiret2,                             " BAPI return
        lst_bapisdls          TYPE bapisdls,                                    " SD Checkbox for the Logic Switch
        li_order_schedules_in TYPE STANDARD TABLE OF bapischdl INITIAL SIZE 0,  " Communication Fields for Maintaining SD Doc. Schedule Lines
        lr_order_schedules_in TYPE REF TO bapischdl,                            "  class
        lr_itemx              TYPE REF TO bapisditmx,                           " reference for itemx
        lr_i_item             TYPE REF TO bapisdit,                             " reference for itemx
        lr_i_business         TYPE REF TO bapisdbusi,                           "  class
        lr_headerx            TYPE REF TO bapisdhd1x,                           "  class
        lr_ext_vbap           TYPE REF TO bape_vbap,                            " Vbap class
        lr_sub_mat            TYPE REF TO ty_sub_mat,                           " Sub_mat class
        lst_bape_vbap         TYPE bape_vbap,                                   " BAPI Interface for Customer Enhancements to Table VBAK
        lst_bape_vbapx        TYPE bape_vbapx,                                  " BAPI Interface for Customer Enhancements to Table VBAK
        lst_extensionin       TYPE bapiparex,                                   " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        li_extensionin        TYPE STANDARD TABLE OF bapiparex INITIAL SIZE 0,  " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        lst_extensioninx      TYPE bapiparex,                                   " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        li_extensioninx       TYPE STANDARD TABLE OF bapiparex INITIAL SIZE 0,  " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
        lv_item_no            TYPE posnr_va,                                    " Sales Document Item
        lr_textheaders        TYPE REF TO bapisdtehd,                           " BAPI Structure of THEAD with English Field Names
        lr_textlines          TYPE REF TO bapitextli,                           " Text lines
        li_textlines          TYPE tt_textlines,                                " Text lines
        li_textheaders        TYPE tt_textheaders,                              " Text header.
* BOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739
        lv_ref_doc            TYPE char50,
        lv_item_num           TYPE char50.
* EOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739

  CONSTANTS: lc_quotation TYPE vbtyp VALUE 'B',              " quotation type
             lc_contract  TYPE vbtyp VALUE 'G',              " contract
             lc_b         TYPE knprs VALUE 'B',              " Copy manual pricing elements and redetermine the others
             lc_insert    TYPE char1 VALUE 'I',              " iNSERT
             lc_posnr_low TYPE vbap-posnr    VALUE '000000', " Sales Document Item
             lc_days      TYPE t5a4a-dlydy VALUE '00',       " Days
             lc_month     TYPE t5a4a-dlymo  VALUE '00',      " Month
             lc_year      TYPE t5a4a-dlyyr  VALUE '01',      " Year
             lc_devid     TYPE zdevid VALUE 'E096',          "Development ID
             lc_param1    TYPE rvari_vnam VALUE 'CQ',        "Parameter1

             lc_kappl     TYPE kappl VALUE 'V',              " Application
             lc_kschl     TYPE kschd VALUE 'Z001'.           " Material determination type

  CREATE DATA: lr_header,
               lr_headerx,
               lr_partner,
               lr_i_partner,
               lr_sales_contract_inx,
               lr_sales_contract_in,
               lr_item,
               lr_itemx.

  READ TABLE fp_li_header REFERENCE INTO lr_i_header INDEX 1.
  IF sy-subrc = 0.
    lr_header->sd_doc_cat = lc_quotation.
    READ TABLE fp_const REFERENCE INTO lr_const WITH KEY devid  = lc_devid
                                                         param1 = lc_param1.
    IF sy-subrc = 0.
      lr_header->doc_type = lr_const->low. " 'ZSQT'.
    ENDIF. " IF sy-subrc = 0
    lr_header->sales_org = lr_i_header->sales_org.
    lr_header->sales_off = lr_i_header->sales_off.
    lr_header->distr_chan = lr_i_header->distr_chan.
    lr_header->division = lr_i_header->division.
    lr_header->refdoc_cat = lc_contract. "'G'.
    lr_header->refdoctype = lc_contract. "'G'.
    lr_header->currency  = lr_i_header->currency.
    lr_header->po_method = lr_i_header->po_method.
    lr_header->alttax_cls = lr_i_header->alt_tax_cl.


    READ TABLE fp_li_business REFERENCE INTO lr_i_business WITH KEY sd_doc    = lr_i_header->doc_number
                                                                   itm_number = lc_posnr_low.
    IF sy-subrc = 0.
      lr_header->price_grp  =  lr_i_business->price_grp.
      lr_header->incoterms1 = lr_i_business->incoterms1.
      lr_header->incoterms2 = lr_i_business->incoterms2.
      lr_headerx->incoterms1 = abap_true.
      lr_headerx->incoterms2 = abap_true.
    ENDIF. " IF sy-subrc = 0

    READ TABLE fp_li_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_header->doc_number.
    IF sy-subrc = 0.
      lr_header->qt_valid_f = lr_contract->contenddat + 1.
      lr_header->price_date = lr_header->qt_valid_f.

      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
        EXPORTING
          date      = lr_header->qt_valid_f
          days      = lc_days
          months    = lc_month
          years     = lc_year
        IMPORTING
          calc_date = lr_header->qt_valid_t.
      lr_header->qt_valid_t = lr_header->qt_valid_t - 1.

      lr_sales_contract_inx->updateflag = lc_insert.
      lr_sales_contract_in->con_st_dat = lr_contract->contenddat + 1.
      lr_sales_contract_inx->con_st_dat = abap_true.

      lr_header->req_date_h = lr_sales_contract_in->con_st_dat.
      lr_headerx->req_date_h = abap_true.



      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
        EXPORTING
          date      = lr_sales_contract_in->con_st_dat
          days      = lc_days
          months    = lc_month
          years     = lc_year
        IMPORTING
          calc_date = lr_sales_contract_in->con_en_dat.
      lr_sales_contract_in->con_en_dat = lr_sales_contract_in->con_en_dat - 1.
      lr_sales_contract_inx->con_en_dat = abap_true.
      APPEND lr_sales_contract_in->* TO li_sales_contract_in.
      CLEAR lr_sales_contract_in->*.
      APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
      CLEAR lr_sales_contract_inx->*.

    ENDIF. " IF sy-subrc = 0

    lr_headerx->doc_type = abap_true.
    lr_headerx->sales_org = abap_true.
    lr_headerx->distr_chan = abap_true.
    lr_headerx->division = abap_true.
    lr_headerx->currency  = abap_true.
    lr_headerx->updateflag = lc_insert.

    CREATE DATA lr_order_schedules_in.



    LOOP AT fp_li_item REFERENCE INTO lr_i_item.

      IF lr_i_item->hg_lv_item NE lc_posnr_low.
        lr_i_item->hg_lv_item = lc_posnr_low.
        lr_item->ref_1 = abap_true.
      ENDIF. " IF lr_i_item->hg_lv_item NE lc_posnr_low


      lv_item_no = lv_item_no + 10.

      lr_itemx->itm_number = lv_item_no.
      lr_item->itm_number = lv_item_no.

      lr_order_schedules_in->itm_number = lv_item_no.

      lr_order_schedules_in->sched_line = '0001'.
      lr_order_schedules_in->req_qty = lr_i_item->target_qty.

*     Begin of DEL:ERP-6344:WROY:20-AUG-2018:ED2K913145
*     READ TABLE fp_li_sub_mat REFERENCE INTO lr_sub_mat
*                         WITH KEY matwa = lr_i_item->material
*                         BINARY SEARCH.
*
*     IF sy-subrc = 0.
*       lr_item->material = lr_sub_mat->matwa.
*     ELSE. " ELSE -> IF sy-subrc = 0
*     End   of DEL:ERP-6344:WROY:20-AUG-2018:ED2K913145
      lr_item->material = lr_i_item->material.
*     Begin of DEL:ERP-6344:WROY:20-AUG-2018:ED2K913145
*     ENDIF. " IF sy-subrc = 0
*     End   of DEL:ERP-6344:WROY:20-AUG-2018:ED2K913145

*     Begin of ADD:ERP-6343:WROY:28-AUG-2018:ED2K913164
      lr_item->cust_mat35 = lr_i_item->cust_mat35.
*     End   of ADD:ERP-6343:WROY:28-AUG-2018:ED2K913164
      lr_item->target_qty =  lr_i_item->target_qty .
      lr_item->target_qu = lr_i_item->target_qu.
*--*BOC OTCM-40816 ED2K922409 Prabhu 3/9/2021
*      lr_item->plant = lr_i_item->plant.
*--*EOC OTCM-40816 ED2K922409 Prabhu 3/9/2021


      READ TABLE fp_li_header ASSIGNING FIELD-SYMBOL(<lst_i_header>)
                                           WITH KEY doc_number = lr_i_item->doc_number.
      IF sy-subrc EQ 0.

        lr_item->refobjkey = <lst_i_header>-doc_number.
        lr_item->refobjtype =  'VBAK'.
        lr_item->ref_doc_ca = lr_header->refdoc_cat.
        lr_item->ref_doc = <lst_i_header>-doc_number.
        lr_item->ref_doc_it = lr_i_item->itm_number.
      ENDIF. " IF sy-subrc EQ 0

*     Begin of DEL:INC0209907:WROY:04-AUG-2018:ED1K908356
*     READ TABLE fp_li_business REFERENCE INTO lr_i_business WITH KEY sd_doc =   lr_i_header->doc_number
*                                                                     itm_number =   lc_posnr_low.
*     IF sy-subrc = 0.
*       lr_item->purch_no_c = lr_i_business->purch_no_c.
*     ENDIF. " IF sy-subrc = 0
*     End   of DEL:INC0209907:WROY:04-AUG-2018:ED1K908356

      READ TABLE fp_li_business REFERENCE INTO lr_i_business
                          WITH KEY  sd_doc  = lr_i_item->doc_number
                                    itm_number = lr_i_item->itm_number.
*     Begin of ADD:INC0209907:WROY:04-AUG-2018:ED1K908356
      IF sy-subrc <> 0.
        READ TABLE fp_li_business REFERENCE INTO lr_i_business
                            WITH KEY  sd_doc  = lr_i_item->doc_number
                                      itm_number = lc_posnr_low.
      ENDIF. " IF sy-subrc <> 0
*     End   of ADD:INC0209907:WROY:04-AUG-2018:ED1K908356
      IF sy-subrc = 0.
        lr_item->po_method = lr_i_business->po_method.
*       Begin of ADD:INC0209907:WROY:04-AUG-2018:ED1K908356
        lr_item->purch_no_c = lr_i_business->purch_no_c.
*       End   of ADD:INC0209907:WROY:04-AUG-2018:ED1K908356

        IF lr_item->ref_1 = abap_true.
          CLEAR lr_item->ref_1.
        ELSE. " ELSE -> IF lr_item->ref_1 = abap_true
          lr_item->ref_1 = lr_i_business->ref_1.
        ENDIF. " IF lr_item->ref_1 = abap_true

        lr_item->price_grp = lr_i_business->price_grp.
        lr_item->cust_group = lr_i_business->cust_group. "Customer Group
*       Begin of ADD:ERP-6344:WROY:20-AUG-2018:ED2K913145
        lr_item->cstcndgrp1 = lr_i_business->custcongr1.
        lr_item->cstcndgrp2 = lr_i_business->custcongr2.
        lr_item->cstcndgrp3 = lr_i_business->custcongr3.
        lr_item->cstcndgrp4 = lr_i_business->custcongr4.
        lr_item->cstcndgrp5 = lr_i_business->custcongr5.
*       End   of ADD:ERP-6344:WROY:20-AUG-2018:ED2K913145

      ENDIF. " IF sy-subrc = 0

      LOOP AT fp_li_partner REFERENCE INTO lr_i_partner WHERE  sd_doc = lr_i_item->doc_number
                                                        AND (  itm_number = lr_i_item->itm_number
                                                       OR itm_number = lc_posnr_low ).
        lr_partner->partn_role = lr_i_partner->partn_role.
        IF NOT lr_i_partner->customer IS INITIAL.
          lr_partner->partn_numb = lr_i_partner->customer.
*Begin of Add-NPALLA-05.13.2019-ED1K909923-INC0241861
        ELSEIF NOT lr_i_partner->vendor_no IS INITIAL.
          lr_partner->partn_numb = lr_i_partner->vendor_no.
*End of Add-NPALLA-05.13.2019-ED1K909923-INC0241861
        ELSEIF NOT lr_i_partner->person_no IS INITIAL..
          lr_partner->partn_numb = lr_i_partner->person_no.
        ENDIF. " IF NOT lr_i_partner->customer IS INITIAL
        IF lr_i_partner->itm_number EQ lc_posnr_low.
          lr_partner->itm_number = lr_i_partner->itm_number.
        ELSE. " ELSE -> IF lr_i_partner->itm_number EQ lc_posnr_low
          lr_partner->itm_number = lv_item_no.
        ENDIF. " IF lr_i_partner->itm_number EQ lc_posnr_low
        APPEND lr_partner->* TO li_partner.
        CLEAR lr_partner->*.
      ENDLOOP. " LOOP AT fp_li_partner REFERENCE INTO lr_i_partner WHERE sd_doc = lr_i_item->doc_number

      SORT li_partner BY  itm_number partn_role partn_numb.
      DELETE ADJACENT DUPLICATES FROM li_partner COMPARING itm_number partn_role partn_numb.

*        lr_item->hg_lv_item = lr_i_item->hg_lv_item.

      READ TABLE fp_li_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_item->doc_number
                                                                   itm_number = lr_i_item->itm_number.
      IF sy-subrc = 0.
        lr_sales_contract_inx->updateflag = lc_insert.
        lr_sales_contract_in->itm_number = lv_item_no.
        lr_sales_contract_inx->itm_number = lv_item_no.

        lr_sales_contract_in->con_st_dat = lr_contract->contenddat + 1.
        lr_sales_contract_inx->con_st_dat = abap_true.
        lr_header->price_date = lr_sales_contract_in->con_st_dat.

        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            date      = lr_sales_contract_in->con_st_dat
            days      = lc_days
            months    = lc_month
            years     = lc_year
          IMPORTING
            calc_date = lr_sales_contract_in->con_en_dat.
        lr_sales_contract_in->con_en_dat = lr_sales_contract_in->con_en_dat - 1.
        lr_sales_contract_inx->con_en_dat = abap_true.
        APPEND lr_sales_contract_in->* TO li_sales_contract_in.
        CLEAR lr_sales_contract_in->*.
        APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
        CLEAR lr_sales_contract_inx->*.
      ENDIF. " IF sy-subrc = 0

**copy item text for each line item
      LOOP AT fp_li_textheaders REFERENCE INTO lr_textheaders WHERE sd_doc = lr_i_item->doc_number
                                                              AND itm_number = lr_i_item->itm_number.

        LOOP AT fp_li_textlines  REFERENCE INTO lr_textlines WHERE text_name = lr_textheaders->text_name.

          CONCATENATE lr_textheaders->sd_doc lv_item_no INTO lr_textlines->text_name.
          APPEND lr_textlines->* TO li_textlines.
        ENDLOOP. " LOOP AT fp_li_textlines REFERENCE INTO lr_textlines WHERE text_name = lr_textheaders->text_name

        lr_textheaders->itm_number = lv_item_no.

        APPEND lr_textheaders->* TO li_textheaders  .
*          CLEAR lr_textheaders->*.
      ENDLOOP. " LOOP AT fp_li_textheaders REFERENCE INTO lr_textheaders WHERE sd_doc = lr_i_item->doc_number


      READ TABLE fp_li_ext_vbap REFERENCE INTO lr_ext_vbap WITH KEY vbeln = lr_i_item->doc_number
                                                                   posnr = lr_i_item->itm_number.
      IF sy-subrc = 0.
        lst_bape_vbap-vbeln         = lr_ext_vbap->vbeln.
        lst_bape_vbap-posnr         = lv_item_no.
        lst_bape_vbap-zzsubtyp      = lr_ext_vbap->zzsubtyp.
        lst_extensionin-structure   = c_bape_vbap .
        lst_extensionin-valuepart1  = lst_bape_vbap.
        APPEND lst_extensionin TO li_extensionin.
        CLEAR  lst_extensionin.

        lst_bape_vbapx-vbeln        = lr_ext_vbap->vbeln.
        lst_bape_vbapx-posnr        = lv_item_no.
        lst_bape_vbapx-zzsubtyp     = abap_true.
        lst_extensionin-structure  = c_bape_vbapx .
        lst_extensionin-valuepart1 = lst_bape_vbapx.
        APPEND lst_extensionin TO li_extensionin.
        CLEAR  lst_extensionin.
      ENDIF. " IF sy-subrc = 0


      APPEND lr_item->* TO li_item.
      CLEAR lr_item->*.
      APPEND lr_order_schedules_in->* TO li_order_schedules_in.
      CLEAR  lr_order_schedules_in->*.
    ENDLOOP. " LOOP AT fp_li_item REFERENCE INTO lr_i_item

    lst_bapisdls-pricing = lc_b.

* BOC - GKINTALI - INC0202201 - 2018/08/27 - ED1K908393
* To update the order number in the message log for tracking purpose.
    IF sy-batch = abap_true.
      MESSAGE s006(zqtc_r2) WITH lr_header->ref_doc. " Order being processed : & .
    ENDIF. " IF sy-batch = abap_true
* EOC - GKINTALI - INC0202201 - 2018/08/27 - ED1K908393

* BOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739
*    IF v_1st_var IS INITIAL. "+ED2K912739
*      v_1st_var = lr_header->ref_doc. "+ED2K912739
*    ENDIF. " IF v_1st_var IS INITIAL
*    v_msgv1 = lr_header->ref_doc. "+ED2K912739
*    PERFORM add_message_log USING 'S' 'ZQTC_R2' '006'        " +ED2K912739
*                                  v_msgv1 space space space. " +ED2K912739
* EOC - CR# 6295 KKRAVURI 2018/09/14  ED2K912739

    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        sales_header_in       = lr_header->*
        int_number_assignment = abap_true
        logic_switch          = lst_bapisdls
        testrun               = fp_test
      IMPORTING
        salesdocument_ex      = fp_v_salesord
      TABLES
        return                = li_return
        sales_items_in        = li_item
        sales_partners        = li_partner
        sales_schedules_in    = li_order_schedules_in
        sales_contract_in     = li_sales_contract_in
        sales_contract_inx    = li_sales_contract_inx
        extensionin           = li_extensionin
        extensionex           = li_extensioninx
        textheaders_ex        = li_textheaders
        textlines_ex          = li_textlines.
*   BOC - NPALLA - E096 - 2018/08/27 - ED2K912739
*** Begin of: CR# 6295 KKRAVURI 2018/09/14  ED2K912739
    LOOP AT li_return INTO st_return WHERE type = c_msg_typ_e.
      READ TABLE li_item INTO DATA(lis_item) INDEX st_return-row.
      IF sy-subrc = 0.
        lv_ref_doc = lis_item-ref_doc.
        lv_item_num = lis_item-itm_number.
        PERFORM add_message_log USING c_msg_typ_e c_zqtc_r2 c_msg_num_308
                                      lv_ref_doc lv_item_num
                                      space space.
      ELSE.
        DATA(lis_item_1) = li_item[ 1 ].
        lv_ref_doc = lis_item_1-ref_doc.
        lv_item_num = lis_item_1-itm_number.
        PERFORM add_message_log USING c_msg_typ_e c_zqtc_r2 c_msg_num_308
                                      lv_ref_doc lv_item_num
                                      space space.
      ENDIF.
      CLEAR: st_return, lis_item, lis_item_1.
    ENDLOOP.
*** End of: CR# 6295 KKRAVURI 2018/09/14  ED2K912739
    LOOP AT li_return INTO st_return. "+ED2K912739
      PERFORM add_message_log USING st_return-type st_return-id st_return-number "+ED2K912739
                                    st_return-message_v1 st_return-message_v2    "+ED2K912739
                                    st_return-message_v3 st_return-message_v4.   "+ED2K912739
      CLEAR st_return. "+ED2K912739
    ENDLOOP. " LOOP AT li_return INTO st_return
*   EOC - NPALLA - E096 - 2018/08/27 - ED2K912739
    READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = 'E'.
    IF sy-subrc <> 0.
      IF  fp_test EQ space .
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
        fp_v_act_status = abap_true.
        CONCATENATE 'Quotation'(a10) fp_v_salesord 'created'(a11) INTO fp_message
        SEPARATED BY space.
      ELSE. " ELSE -> IF fp_test EQ space
*       Begin of ADD:SAP's Recommendations:WROY:01-Mar-2018:ED2K911135
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*       End   of ADD:SAP's Recommendations:WROY:01-Mar-2018:ED2K911135
        CONCATENATE 'Quotation'(a10) fp_v_salesord 'can be created'(x11) INTO fp_message
        SEPARATED BY space.
      ENDIF. " IF fp_test EQ space

    ELSE. " ELSE -> IF sy-subrc <> 0
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      APPEND LINES OF li_return TO fp_i_return.
      LOOP AT li_return REFERENCE INTO  lr_return WHERE type = 'E'.
        IF sy-tabix = 1.
          CONCATENATE 'Quotation failed'(a13) fp_message INTO fp_message.
        ELSE. " ELSE -> IF sy-tabix = 1
          CONCATENATE fp_message lr_return->message INTO fp_message SEPARATED BY space.
        ENDIF. " IF sy-tabix = 1

      ENDLOOP. " LOOP AT li_return REFERENCE INTO lr_return WHERE type = 'E'

    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc = 0
ENDFORM.
*End of ADD:ERP-6343:NGADRE:01-AUG-2018:ED2K912802

*&---------------------------------------------------------------------*
*&      Form  ADD_MESSAGE_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM add_message_log  USING  fp_msgty TYPE msgty  " Message Type
                             fp_msgid TYPE msgid  " Message identification
                             fp_msgno TYPE numc3  " msgno
                             fp_msgv1 TYPE msgv1  " Message variable 01
                             fp_msgv2 TYPE msgv2  " Message variable 02
                             fp_msgv3 TYPE msgv3  " Message variable 03
                             fp_msgv4 TYPE msgv4. " Message variable 04

  CASE fp_msgty.
    WHEN c_msg_typ_a OR c_msg_typ_e.
      v_log_type = fp_msgty.
    WHEN c_msg_typ_w.
      IF v_log_type <> c_msg_typ_e AND v_log_type <> c_msg_typ_a.
        v_log_type = fp_msgty.
      ENDIF.
    WHEN OTHERS.
      IF v_log_type IS INITIAL.
        v_log_type = fp_msgty.
      ENDIF.
  ENDCASE.

* Log Type E/A/W/S/I
*  IF v_log_type IS INITIAL.
*    v_log_type = fp_msgty.
*  ELSE. " ELSE -> IF v_log_type IS INITIAL
*    CASE v_log_type.
*      WHEN 'A'.
*      WHEN 'E'.
*        IF fp_msgty = 'E' OR
*           fp_msgty = 'A'.
*          v_log_type = fp_msgty.
*        ENDIF. " IF fp_msgty = 'E' OR
*      WHEN 'W'.
*        IF fp_msgty = 'E' OR
*           fp_msgty = 'A' OR
*           fp_msgty = 'W'.
*          v_log_type = fp_msgty.
*        ENDIF. " IF fp_msgty = 'E' OR
*      WHEN 'S' OR 'I'.
*        IF fp_msgty = 'E' OR
*           fp_msgty = 'A' OR
*           fp_msgty = 'W' OR
*           fp_msgty = 'S'.
*          v_log_type = fp_msgty.
*        ENDIF. " IF fp_msgty = 'E' OR
*      WHEN OTHERS.
*        v_log_type = fp_msgty.
*    ENDCASE.
*  ENDIF. " IF v_log_type IS INITIAL

* Messages
  st_bal_msg-msgty  = fp_msgty.
  st_bal_msg-msgid  = fp_msgid.
  st_bal_msg-msgno  = fp_msgno.
  st_bal_msg-msgv1  = fp_msgv1.
  st_bal_msg-msgv2  = fp_msgv2.
  st_bal_msg-msgv3  = fp_msgv3.
  st_bal_msg-msgv4  = fp_msgv4.

  APPEND st_bal_msg TO i_bal_msg.
  CLEAR st_bal_msg.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_CREATE_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_create_log  USING    fp_1st_var   TYPE char50    " Create_log using fp_1st of type CHAR50
                            fp_i_bal_msg TYPE bal_t_msg " Log Messages
                   CHANGING fp_lognumber TYPE balognr.  " log number.

  CONSTANTS: lc_object TYPE balobj_d    VALUE 'ZQTC',   " Application Log: Object Name (Application Code)
             lc_subobj TYPE balsubobj   VALUE 'ZSMR_RENEWALS'.

  DATA : lst_log         TYPE bal_s_log,          " Application Log: Log header data
         li_log_handle   TYPE bal_t_logh,         " Application Log: Log Handle Table
         li_log_numbers  TYPE bal_t_lgnm,
         lv_exp_date     TYPE aldate_del,
         lst_log_numbers TYPE bal_s_lgnm,         " Application Log: Newly assigned LOGNUMBER
         lv_job_id       TYPE tbtcm-jobcount,     " Job ID
         lv_jobname      TYPE tbtcm-jobname.      " Background job name

* Check for Log Messages
  CHECK fp_i_bal_msg[] IS NOT INITIAL.

  IF sy-batch = abap_true.
    CALL FUNCTION 'GET_JOB_RUNTIME_INFO'
      IMPORTING
        jobcount        = lv_job_id
        jobname         = lv_jobname
      EXCEPTIONS
        no_runtime_info = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
*     Nothing to do
    ENDIF. " IF sy-subrc <> 0
  ELSE. " ELSE -> IF sy-batch = abap_true
    lv_jobname = sy-repid.
    CLEAR lv_job_id.
  ENDIF. " IF sy-batch = abap_true

* define some header data of this log
* External Number
  CONDENSE: lv_jobname, fp_1st_var.
  CONCATENATE lv_jobname
              lv_job_id
              sy-datum
              fp_1st_var
              v_log_type
         INTO lst_log-extnumber
         SEPARATED BY '/'.

  IF v_exp_days IS INITIAL.
    v_exp_days = '090'.                   " Default Log Expiry days to 90
  ENDIF.
  lv_exp_date = sy-datum + v_exp_days.    " Logs Expiry Date: 90 days

  lst_log-object     = lc_object.
  lst_log-subobject  = lc_subobj.
  lst_log-aldate     = sy-datum.
  lst_log-altime     = sy-uzeit.
  lst_log-aluser     = sy-uname.
  lst_log-alprog     = sy-repid.
  lst_log-aldate_del = lv_exp_date.
  lst_log-del_before = abap_true.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = lst_log
    IMPORTING
      e_log_handle            = v_log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
*   Nothing to do
  ENDIF. " IF sy-subrc <> 0

  APPEND v_log_handle TO li_log_handle.

* Save logs in the database - To get the Log Number.
  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_t_log_handle   = li_log_handle  " Application Log: Log Handle
    IMPORTING
      e_new_lognumbers = li_log_numbers
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc NE 0.
*   Nothing to do
  ENDIF. " IF sy-subrc NE 0

  IF li_log_numbers[] IS NOT INITIAL.
    v_lognumber = li_log_numbers[ 1 ]-lognumber.
    REFRESH li_log_numbers.
  ENDIF. " IF sy-subrc = 0

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_MAINTAIN_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_maintain_log  USING    fp_log_handle   TYPE balloghndl  " Application Log: Log Handle
                              fp_bal_msg      TYPE bal_t_msg   " Log Messages
                     CHANGING fp_i_log_handle TYPE bal_t_logh. " Application Log: Log Handle Table

* Add Messages to SLG1 Log
  LOOP AT fp_bal_msg INTO st_bal_msg.
    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle     = fp_log_handle
        i_s_msg          = st_bal_msg
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
*     Nothing to do
    ENDIF. " IF sy-subrc <> 0
  ENDLOOP. " LOOP AT fp_bal_msg INTO st_bal_msg

* Capture the Log Guid to save the Log into database
  APPEND fp_log_handle TO fp_i_log_handle.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_HOTSPOT
*&---------------------------------------------------------------------*
*      --> FP_LST_SELFIELD TYPE slis_selfield
*----------------------------------------------------------------------*
FORM f_process_hotspot  USING fp_lst_selfield TYPE slis_selfield.

  DATA: lv_table TYPE slis_tabname,
        lv_index TYPE slis_selfield-tabindex,
        lv_field TYPE slis_selfield-fieldname,
        lv_ucomm TYPE syst_ucomm.

  lv_table = fp_lst_selfield-tabname.
  lv_index = fp_lst_selfield-tabindex.
  lv_field = fp_lst_selfield-fieldname. " sel_tab_field Field Name

  CASE fp_lst_selfield-fieldname.
    WHEN 'VBELN'.
      READ TABLE i_final INTO st_final INDEX lv_index.
      IF sy-subrc = 0.
*        SET PARAMETER ID 'AUN' FIELD st_final-vbeln.
        SET PARAMETER ID 'KTN' FIELD st_final-vbeln.
        CALL TRANSACTION 'VA43' AND SKIP FIRST SCREEN.
      ENDIF. " IF sy-subrc = 0
    WHEN 'MATNR'.
      READ TABLE i_final INTO st_final INDEX lv_index.
      IF sy-subrc = 0.
        SET PARAMETER ID 'MAT' FIELD st_final-matnr.
        CALL TRANSACTION 'JP26' AND SKIP FIRST SCREEN.
      ENDIF. " IF sy-subrc = 0
    WHEN 'LOGNUMBER'.
      PERFORM f_display_log_popup USING lv_index.
*--*BOC Prabhu DM1916 ED2K915501 7/12/2019
    WHEN 'OTHER_CMNTS'.
      PERFORM f_mass_comments_update USING lv_ucomm fp_lst_selfield CHANGING i_final.
      fp_lst_selfield-refresh = abap_true.
*--*EOC Prabhu DM1916 ED2K915501 7/12/2019
    WHEN OTHERS.
  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_LOG_POPUP
*&---------------------------------------------------------------------*
*       --> fp_index TYPE i
*----------------------------------------------------------------------*
FORM f_display_log_popup  USING  fp_index TYPE i. " Display_log_popup using of type Integers

  TYPES: BEGIN OF ty_msg,
           msg_stat TYPE zmsg_icon_desc, " Message Icon and Description
           text     TYPE char200,        " Text of type CHAR200
         END OF ty_msg.

  DATA: li_log_handle     TYPE bal_t_logh, " Application Log: Log Handle Table
        lst_msg           TYPE bal_s_msg,  " Application Log: Message Data
        lv_msg_log_handle TYPE balmsghndl, " Application Log: Message handle
        lflg_exit         TYPE xchar,      " Exit Flag
        li_msg_out        TYPE STANDARD TABLE OF ty_msg,
        lst_msg_out       TYPE ty_msg,
        lv_lognumber      TYPE balognr,
        lv_log_handle     TYPE balloghndl.

  CONSTANTS:
    lc_comment_by   TYPE string VALUE 'Comment By:'.

  READ TABLE i_final INTO st_final INDEX fp_index.
  IF sy-subrc = 0.
    lv_lognumber = st_final-lognumber.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_lognumber
      IMPORTING
        output = lv_lognumber.
    CLEAR st_final.
  ENDIF. " IF sy-subrc = 0

* Get Log Handle.
  SELECT SINGLE log_handle " Application Log: Log Handle
    FROM balhdr            " Application log: Header table
    INTO lv_log_handle
    WHERE lognumber = lv_lognumber.
  IF sy-subrc <> 0.
    MESSAGE i000(zqtc_r2) WITH 'Select a Valid Log Number'. " & & & &
    EXIT.
  ELSE.
    CLEAR lv_lognumber.
  ENDIF. " IF sy-subrc <> 0

* Application Log: Database: Load Logs
  APPEND lv_log_handle TO li_log_handle.

  CALL FUNCTION 'BAL_DB_LOAD'
    EXPORTING
      i_t_log_handle     = li_log_handle
    EXCEPTIONS
      no_logs_specified  = 1
      log_not_found      = 2
      log_already_loaded = 3
      OTHERS             = 4.
  IF sy-subrc <> 0.
    MESSAGE i000(zqtc_r2) WITH 'Enter a Valid Log Handle'. " & & & &
    EXIT.
  ELSE.
    CLEAR li_log_handle[].
  ENDIF. " IF sy-subrc <> 0

* Get All the Log Messages for the given Log Handle.
  WHILE lflg_exit IS INITIAL.

    lv_msg_log_handle-log_handle = lv_log_handle.
    lv_msg_log_handle-msgnumber  = lv_msg_log_handle-msgnumber + 1 .

    CALL FUNCTION 'BAL_LOG_MSG_READ'
      EXPORTING
        i_s_msg_handle = lv_msg_log_handle
      IMPORTING
        e_s_msg        = lst_msg
      EXCEPTIONS
        log_not_found  = 1
        msg_not_found  = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      lflg_exit = abap_true.
    ENDIF. " IF sy-subrc <> 0

    IF lflg_exit IS INITIAL.
      MESSAGE ID lst_msg-msgid TYPE lst_msg-msgty NUMBER lst_msg-msgno
              INTO DATA(lv_msg_text)
              WITH lst_msg-msgv1 lst_msg-msgv2 lst_msg-msgv3 lst_msg-msgv4.
      PERFORM f_get_msg_icon USING lst_msg-msgty
                             CHANGING lst_msg_out-msg_stat.
      IF lst_msg-msgv1 CS lc_comment_by.
        CONCATENATE lst_msg-msgv1 lst_msg-msgv2 lst_msg-msgv3 lst_msg-msgv4
                    INTO lv_msg_text.
      ENDIF.
      lst_msg_out-text = lv_msg_text.
      APPEND lst_msg_out TO li_msg_out.
      CLEAR: lst_msg_out, lst_msg, lv_msg_text.
    ENDIF. " IF lflg_exit IS INITIAL

  ENDWHILE.
  CLEAR lv_log_handle.

  PERFORM f_popup_log_window USING li_msg_out.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_POPUP_WINDOW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_popup_log_window  USING    fp_i_msg TYPE STANDARD TABLE.

  DATA: lo_alv TYPE REF TO cl_salv_table. " Basis Class for Simple Tables
  DATA: lr_functions TYPE REF TO cl_salv_functions_list. " Generic and User-Defined Functions in List-Type Tables
  DATA: lv_start_column TYPE i, " Start_column of type Integers
        lv_end_column   TYPE i, " End_column of type Integers
        lv_start_line   TYPE i, " Start_line of type Integers
        lv_end_line     TYPE i. " End_line of type Integers

  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = fp_i_msg[] ).
    CATCH cx_salv_msg.
  ENDTRY.

  lr_functions = lo_alv->get_functions( ).
  lr_functions->set_all( 'X' ).

  lv_start_column  = 1.
  lv_end_column    = 100.
  lv_start_line    = 1.
  lv_end_line      = 20.

  IF lo_alv IS BOUND.
    lo_alv->set_screen_popup(
      start_column = lv_start_column
      end_column  = lv_end_column
      start_line  = lv_start_line
      end_line    = lv_end_line ).
*   Display ALV
    lo_alv->display( ).
  ENDIF. " IF lo_alv IS BOUND

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_ALVDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*FORM f_save_alvdata  USING    fp_lst_selfield  TYPE slis_selfield.
*
*  DATA: lst_renwl_plan TYPE zqtc_renwl_plan, " E095: Renewal Plan Table
*        li_renwl_plan  TYPE STANDARD TABLE OF zqtc_renwl_plan. " E095: Renewal Plan Table
*
*  LOOP AT i_final INTO st_final WHERE review_stat = abap_true.
*    PERFORM f_add_comment_msg USING st_final-lognumber
*                                    st_final-comments.
*    MOVE-CORRESPONDING st_final TO lst_renwl_plan.
*    APPEND lst_renwl_plan TO li_renwl_plan.
*    CLEAR lst_renwl_plan.
*  ENDLOOP. " LOOP AT i_final INTO st_final WHERE review_stat = abap_true
*
*  IF li_renwl_plan[] IS NOT INITIAL.
*    MODIFY zqtc_renwl_plan FROM TABLE li_renwl_plan.
*    COMMIT WORK AND WAIT.
*    MESSAGE i000(zqtc_r2) WITH 'Data successfully updated in ZQTC_RENWL_PLAN'.
*  ELSE. " ELSE -> IF li_renwl_plan[] IS NOT INITIAL
*    MESSAGE i000(zqtc_r2) WITH 'No Data to be updated in ZQTC_RENWL_PLAN'.
*  ENDIF. " IF li_renwl_plan[] IS NOT INITIAL
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_DATA
*&---------------------------------------------------------------------*
*       Check Review Status
*----------------------------------------------------------------------*
*      <--P_I_FINAL  Final table
*----------------------------------------------------------------------*
FORM f_check_data  CHANGING fp_i_final TYPE tt_final.

  LOOP AT fp_i_final ASSIGNING FIELD-SYMBOL(<lfs_final>) WHERE sel = abap_true.
    <lfs_final>-act_status = abap_true.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UNCHECK_DATA
*&---------------------------------------------------------------------*
*       Un-check Review Status
*----------------------------------------------------------------------*
*      <--P_I_FINAL  Final table
*----------------------------------------------------------------------*
FORM f_uncheck_data  CHANGING fp_i_final TYPE tt_final.

  LOOP AT fp_i_final ASSIGNING FIELD-SYMBOL(<lfs_final>) WHERE sel = abap_true.
    <lfs_final>-act_status = abap_false.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_DATA
*&---------------------------------------------------------------------*
*       Check Review Status
*----------------------------------------------------------------------*
*      <--P_I_FINAL  Final table
*----------------------------------------------------------------------*
FORM f_save_data  CHANGING fp_i_final TYPE tt_final.

  DATA:
    lv_sel           TYPE abap_bool VALUE abap_false,
    lv_vbeln         TYPE char50,
    lv_msg_str       TYPE char120,
    lst_renewal_plan TYPE zqtc_renwl_plan,
    li_renewal_plan  TYPE tt_renwl_plan.

  LOOP AT fp_i_final ASSIGNING FIELD-SYMBOL(<lfs_final>) WHERE sel = abap_true.
    lv_sel = abap_true.
    lv_vbeln = <lfs_final>-vbeln.
    <lfs_final>-message = 'Check/Un-check activity saved'(036).
    lv_msg_str = 'Check/Un-check activity performed'(039).
    " Perform to build the Log message
    PERFORM add_pgm_message_log USING lv_msg_str
                                      c_msg_typ_i
                                      c_msg_num_0.
    IF i_bal_msg[] IS NOT INITIAL.
      " Perform to create the Application Log
      PERFORM f_create_log  USING lv_vbeln
                                  i_bal_msg
                         CHANGING v_lognumber.
      IF <lfs_final>-lognumber IS NOT INITIAL AND
         v_lognumber IS NOT INITIAL.
        " Perform to add the previous Lognumber to current Application Log
        PERFORM f_add_previous_log_msg  USING <lfs_final>-lognumber
                                              v_log_handle.
      ENDIF.
      " Perform to add the messages to Application Log
      PERFORM f_maintain_log  USING v_log_handle
                                    i_bal_msg
                           CHANGING i_log_handle.
      " Perform to Save the Application Log
      PERFORM f_save_log  USING i_log_handle.

      IF v_lognumber IS NOT INITIAL.
        SHIFT v_lognumber LEFT DELETING LEADING '0'.
      ENDIF.
      <lfs_final>-log_type  = v_log_type.  " Log Type E/W/S/I
      <lfs_final>-lognumber = v_lognumber. " Log Number (SLG1)
      " Perform to get the Log_Type description
      PERFORM f_get_msg_icon  USING <lfs_final>-log_type
                           CHANGING <lfs_final>-log_type_desc.

    ENDIF.  " IF i_bal_msg[] IS NOT INITIAL.

    GET TIME.
    <lfs_final>-aenam = sy-uname.
    <lfs_final>-aedat = sy-datum.
    <lfs_final>-aezet = sy-uzeit.

    MOVE-CORRESPONDING <lfs_final> TO lst_renewal_plan.
    APPEND lst_renewal_plan TO li_renewal_plan.
*   Update Renewal Plan Table
    CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL'
      TABLES
        t_renwl_plan = li_renewal_plan.

    CLEAR: lv_vbeln, lst_renewal_plan, li_renewal_plan[],
           v_log_type, lv_msg_str, v_lognumber, v_log_handle, i_bal_msg[], i_log_handle[].
  ENDLOOP.

  IF lv_sel = abap_false.
    MESSAGE 'Please select atleast one Sales document for Save'(040) TYPE 'I'.
    EXIT.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MSG_ICON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_get_msg_icon  USING    fp_msg_msgty     TYPE symsgty         " Message Type
                     CHANGING fp_msg_stat_desc TYPE zmsg_icon_desc. " Message Icon and Description

  DATA : lv_icon_fld TYPE icon_d, "Icon
         lv_msg_type TYPE char11.

  CLEAR: fp_msg_stat_desc.

  CASE fp_msg_msgty.
    WHEN 'A'.
      lv_icon_fld = '@8N@'.
      lv_msg_type = 'Abort'.
    WHEN 'E'.
      lv_icon_fld = '@5C@'. "Red/Error
      lv_msg_type = 'Error'.
    WHEN 'W'.
      lv_icon_fld = '@5D@'. "Yellow/Warning
      lv_msg_type = 'Warning'.
    WHEN 'S'.
      lv_icon_fld = '@5B@'. "Green/Success
      lv_msg_type = 'Success'.
    WHEN 'I'.
      lv_icon_fld = '@5B@'. "Green/Success
      lv_msg_type = 'Information'.
    WHEN OTHERS.
  ENDCASE.

  CONCATENATE lv_icon_fld lv_msg_type INTO fp_msg_stat_desc SEPARATED BY space.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SAVE_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_save_log  USING fp_i_log_handle TYPE bal_t_logh. " Application Log: Log Handle

* Save logs in the database
  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_t_log_handle   = fp_i_log_handle "Application Log: Log Handle
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc NE 0.
*   Nothing to do
  ELSE.
* Clear the Log from Buffer
    DATA(lv_log_handle) = fp_i_log_handle[ 1 ].
    CALL FUNCTION 'BAL_LOG_REFRESH'
      EXPORTING
        i_log_handle  = lv_log_handle
      EXCEPTIONS
        log_not_found = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
*     Nothing to do
    ENDIF.
  ENDIF. " IF sy-subrc NE 0


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ADD_PGM_MESSAGE_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM add_pgm_message_log  USING fp_final_message TYPE char120 " Message
                                fp_msg_type TYPE symsgty      " Message Type
                                fp_msg_num  TYPE symsgno.

  DATA: lv_length TYPE i. " Length of type Integers

  CLEAR: v_msgv1,
         v_msgv2,
         v_msgv3,
         v_msgv4.

  lv_length = strlen( fp_final_message ).

  IF lv_length LE 50.
    v_msgv1 = fp_final_message.
  ELSEIF lv_length GT 50 AND lv_length LE 100.
    v_msgv1 = fp_final_message+0(50).
    v_msgv2 = fp_final_message+50(50).
  ELSEIF lv_length GT 100 AND lv_length LE 120.
    v_msgv1 = fp_final_message+0(50).
    v_msgv2 = fp_final_message+50(50).
    v_msgv3 = fp_final_message+100(20).
  ENDIF. " IF lv_length LE 50

  PERFORM add_message_log USING fp_msg_type c_zqtc_r2 fp_msg_num
                                v_msgv1 v_msgv2 v_msgv3 v_msgv4.
  CLEAR: v_msgv1, v_msgv2, v_msgv3, v_msgv4.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADD_COMMENT_MSG
*&---------------------------------------------------------------------*
FORM f_add_previous_log_msg  USING VALUE(fp_v_log_number) TYPE balognr
                                   VALUE(fp_v_log_handle) TYPE balloghndl.

  DATA:
    lv_txtmsg  TYPE text255.

* Appending leading zeros
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = fp_v_log_number
    IMPORTING
      output = fp_v_log_number.

* build free text
  CONCATENATE 'Previous Log Number#' fp_v_log_number INTO lv_txtmsg
                                     SEPARATED BY space.

* Add free text to log
  CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
    EXPORTING
      i_log_handle     = fp_v_log_handle
      i_msgty          = 'I'
      i_probclass      = ''
      i_text           = lv_txtmsg
    EXCEPTIONS
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
*      Nothing to do
  ELSE.
    CLEAR lv_txtmsg.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_CURRENCY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_currency .
  IF p_waers IS INITIAL.
    RETURN.
  ENDIF. " IF s_mvgr5[] IS INITIAL
* Validate Currency from Currency Codes
  SELECT waers " Currency
    FROM tcurc  " Currency Codes
   UP TO 1 ROWS
    INTO @DATA(lv_waers)
   WHERE waers EQ @p_waers.
  ENDSELECT.
  IF sy-subrc NE 0.
    CLEAR: lv_waers.
    MESSAGE e116(vh) WITH p_waers. " Currency does not exist
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_EXCL_REASON_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_FINAL  text
*----------------------------------------------------------------------*
FORM f_populate_excl_reason_2  CHANGING fp_i_final TYPE tt_final.
  DATA:li_fld_detl TYPE ty_sval.
  CONSTANTS:
    lc_act_cq   TYPE zactivity_sub VALUE 'CQ', " Activity: Create Quotation
    lc_tab_name TYPE tabname   VALUE 'ZQTC_RENWL_PLAN', " Table Name
    lc_fld_name TYPE fieldname VALUE 'EXCL_RESN2'.       " Field Name
*--*Confirm the operatioin
  PERFORM f_popup_exclusion.

  DATA(li_final) = fp_i_final.
  DELETE li_final WHERE sel IS INITIAL.
  IF li_final IS INITIAL.
*   Message: No record to be processed
    MESSAGE i020(zrar_messages). " No record to be processed
    RETURN.
  ENDIF. " IF li_final IS INITIAL

* Take Input for Exclusion Reason
  APPEND INITIAL LINE TO li_fld_detl ASSIGNING FIELD-SYMBOL(<lst_fld_detl>).
  <lst_fld_detl>-tabname   = lc_tab_name.
  <lst_fld_detl>-fieldname = lc_fld_name.

* Dialog box for the display and request of values
  CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
      popup_title     = 'Enter Exclusion Reason'(005)
    TABLES
      fields          = li_fld_detl
    EXCEPTIONS
      error_in_fields = 1
      OTHERS          = 2.
  IF sy-subrc NE 0.
*   Nothing to do
  ENDIF. " IF sy-subrc NE 0
  READ TABLE li_fld_detl ASSIGNING <lst_fld_detl> INDEX 1.
  IF sy-subrc NE 0 OR
     <lst_fld_detl>-value IS INITIAL.
*   Message: No "Exclusion Reason" was entered!
    MESSAGE i500(zqtc_r2). " No "Exclusion Reason" was entered!
    RETURN.
  ENDIF. " IF sy-subrc NE 0 OR

  SORT li_final BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM li_final
         COMPARING vbeln posnr.
* Fetch details from Renewal Plan Table
* All fields (SELECT *) are fetched, since the entries have to be updated
* The table is being accessed again, to ensure that all Activities of an
* Order Item is excluded, even though User has not selected all of those
  SELECT *
    FROM zqtc_renwl_plan " E095: Renewal Plan Table
    INTO TABLE @DATA(li_renewal_plan)
     FOR ALL ENTRIES IN @li_final
   WHERE vbeln      EQ @li_final-vbeln
     AND posnr      EQ @li_final-posnr
   ORDER BY PRIMARY KEY.
  IF sy-subrc EQ 0.
    DATA(li_renewal_plan_cq) = li_renewal_plan[].
*   Identify the records where CQ (Create Quotation) activity was completed
    DELETE li_renewal_plan_cq WHERE activity   NE lc_act_cq
                                 OR act_status NE abap_true
                                 OR ren_status NE space.
    DELETE li_renewal_plan WHERE act_status EQ abap_true.
    LOOP AT li_renewal_plan ASSIGNING FIELD-SYMBOL(<lst_renewal_plan>).
*     Identify the records where CQ (Create Quotation) activity was completed
      READ TABLE li_renewal_plan_cq TRANSPORTING NO FIELDS
           WITH KEY vbeln    = <lst_renewal_plan>-vbeln
                    posnr    = <lst_renewal_plan>-posnr
           BINARY SEARCH.
      IF sy-subrc EQ 0.
*       Verify if the Renewal Profile is applicable for Consolidation
        READ TABLE fp_i_final ASSIGNING FIELD-SYMBOL(<lst_final>)
              WITH TABLE KEY order_key
        COMPONENTS vbeln    = <lst_renewal_plan>-vbeln
                   posnr    = <lst_renewal_plan>-posnr.
        IF sy-subrc EQ 0 AND
           <lst_final>-consolidate EQ abap_true.
*         Update the corresponding Activity that Exclusion is not possible
          READ TABLE fp_i_final ASSIGNING <lst_final>
                WITH TABLE KEY vbeln_key
          COMPONENTS vbeln    = <lst_renewal_plan>-vbeln
                     posnr    = <lst_renewal_plan>-posnr
                     activity = <lst_renewal_plan>-activity.
          IF sy-subrc EQ 0.
            <lst_final>-message = 'Exclusion not possible - Applicable for Consolidation'(009). "Message
          ENDIF. " IF sy-subrc EQ 0
          CLEAR: <lst_renewal_plan>-mandt.
          CONTINUE.
        ENDIF. " IF sy-subrc EQ 0 AND
      ENDIF. " IF sy-subrc EQ 0

      <lst_renewal_plan>-excl_resn2 = <lst_fld_detl>-value. "Exclusion Reason
      <lst_renewal_plan>-excl_date2 = sy-datum. "Exclusion Date
      <lst_renewal_plan>-aedat     = sy-datum. "Changed On
      <lst_renewal_plan>-aezet     = sy-uzeit. "Changed At
      <lst_renewal_plan>-aenam     = sy-uname. "Changed By
*--*Populate excusion reason 2 and date 2 on ALV grid
      READ TABLE fp_i_final ASSIGNING <lst_final>
            WITH TABLE KEY vbeln_key
      COMPONENTS vbeln    = <lst_renewal_plan>-vbeln
                 posnr    = <lst_renewal_plan>-posnr
                 activity = <lst_renewal_plan>-activity.
      IF sy-subrc EQ 0.
        <lst_final>-excl_resn2 = <lst_fld_detl>-value. "Exclusion Reason
        <lst_final>-excl_date2 = sy-datum. "Exclusion Date
        READ TABLE i_excl_resn ASSIGNING FIELD-SYMBOL(<lst_excl_resn>)
             WITH KEY excl_resn = <lst_final>-excl_resn2.
        IF sy-subrc EQ 0.
          <lst_final>-excl_resn_d2 = <lst_excl_resn>-excl_resn_d. "Exclusion Reason Text
        ENDIF. " IF sy-subrc EQ 0
        <lst_final>-aedat   = <lst_renewal_plan>-aedat. "Changed On
        <lst_final>-aezet   = <lst_renewal_plan>-aezet. "Changed At
        <lst_final>-aenam   = <lst_renewal_plan>-aenam. "Changed By
        <lst_final>-message = 'Exclusion Reason is populated'(006). "Message
      ENDIF. " IF sy-subrc EQ 0
    ENDLOOP. " LOOP AT li_renewal_plan ASSIGNING FIELD-SYMBOL(<lst_renewal_plan>)
*   Remove the entries, those can not be excluded
    DELETE li_renewal_plan WHERE mandt IS INITIAL.

*   Update Renewal Plan Table
    CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL'
      TABLES
        t_renwl_plan = li_renewal_plan.
    COMMIT WORK AND WAIT.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_REMOVE_EXCL_REASON_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_FINAL  text
*----------------------------------------------------------------------*
FORM f_remove_excl_reason_2  CHANGING fp_i_final TYPE tt_final.

  PERFORM f_popup_inclusion.

  DATA(li_final) = fp_i_final.
  DELETE li_final WHERE sel       IS INITIAL
                     OR excl_resn2 IS INITIAL.
  IF li_final IS INITIAL.
*   Message: No record to be processed
    MESSAGE i020(zrar_messages). " No record to be processed
    RETURN.
  ENDIF. " IF li_final IS INITIAL

  SORT li_final BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM li_final
         COMPARING vbeln posnr.
* Fetch details from Renewal Plan Table
* All fields (SELECT *) are fetched, since the entries have to be updated
* The table is being accessed again, to ensure that all Activities of an
* Order Item is included, even though User has not selected all of those
  SELECT *
    FROM zqtc_renwl_plan " E095: Renewal Plan Table
    INTO TABLE @DATA(li_renewal_plan)
     FOR ALL ENTRIES IN @li_final
   WHERE vbeln      EQ @li_final-vbeln
     AND posnr      EQ @li_final-posnr
     AND act_status EQ @abap_false.
  IF sy-subrc EQ 0.
    LOOP AT li_renewal_plan ASSIGNING FIELD-SYMBOL(<lst_renewal_plan>).
      CLEAR: <lst_renewal_plan>-excl_resn2, "Exclusion Reason
             <lst_renewal_plan>-excl_date2. "Exclusion date
      <lst_renewal_plan>-aedat = sy-datum. "Changed On
      <lst_renewal_plan>-aezet = sy-uzeit. "Changed At
      <lst_renewal_plan>-aenam = sy-uname. "Changed By

      READ TABLE fp_i_final ASSIGNING FIELD-SYMBOL(<lst_final>)
            WITH TABLE KEY vbeln_key
      COMPONENTS vbeln    = <lst_renewal_plan>-vbeln
                 posnr    = <lst_renewal_plan>-posnr
                 activity = <lst_renewal_plan>-activity.
      IF sy-subrc EQ 0.
        CLEAR: <lst_final>-excl_resn2,   "Exclusion Reason
               <lst_final>-excl_date2,   "Exclusion Date
               <lst_final>-excl_resn_d2. "Exclusion Reason Text
        <lst_final>-aedat   = <lst_renewal_plan>-aedat. "Changed On
        <lst_final>-aezet   = <lst_renewal_plan>-aezet. "Changed At
        <lst_final>-aenam   = <lst_renewal_plan>-aenam. "Changed By
*        IF <lst_final>-excl_resn IS INITIAL.
        <lst_final>-message = 'Exclusion Reason 2 is removed'(011). "Message
*        ENDIF.
      ENDIF. " IF sy-subrc EQ 0
    ENDLOOP. " LOOP AT li_renewal_plan ASSIGNING FIELD-SYMBOL(<lst_renewal_plan>)

*   Update Renewal Plan Table
    CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL'
      TABLES
        t_renwl_plan = li_renewal_plan.
    COMMIT WORK AND WAIT.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MASS_COMMENTS_UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_FINAL  text
*----------------------------------------------------------------------*
FORM f_mass_comments_update  USING fp_ucomm TYPE syst_ucomm fp_lst_selfield TYPE slis_selfield
                             CHANGING fp_i_final TYPE tt_final.
  CONSTANTS:  lc_mass     TYPE syst_ucomm     VALUE '&MASS'.     " ABAP System Field: PAI-Triggering Function Code
  TYPES : BEGIN OF lty_text,
            text TYPE zqtc_renwl_plan-other_cmnts,
          END OF lty_text.
  DATA : li_text  TYPE STANDARD TABLE OF lty_text,
         lst_text TYPE lty_text.

  DATA(li_final) = fp_i_final.
  DELETE li_final WHERE sel IS INITIAL.
  IF li_final IS INITIAL AND fp_ucomm = lc_mass.
*   Message: No record to be processed
    MESSAGE i020(zrar_messages). " No record to be processed
    RETURN.
  ENDIF. " IF li_final IS INITIAL
*--* When MASS update is being selected
  IF fp_ucomm = lc_mass.
    LOOP AT fp_i_final ASSIGNING FIELD-SYMBOL(<lst_final>) WHERE sel IS NOT INITIAL.
      lst_text-text = <lst_final>-other_cmnts.
      APPEND lst_text TO li_text.
      CLEAR lst_text.
    ENDLOOP.
    IF li_text IS NOT INITIAL.
      DELETE ADJACENT DUPLICATES FROM li_text.
      DESCRIBE TABLE li_text LINES DATA(lv_lines).
      IF lv_lines GT 1.
        MESSAGE i021(zrar_messages).
        RETURN.
      ELSE.
        READ TABLE li_text INTO lst_text INDEX 1.
        v_message = lst_text.
      ENDIF.
    ENDIF.
  ELSE. "When hotspot being selected for Other comments
    READ TABLE fp_i_final ASSIGNING FIELD-SYMBOL(<lst_final_single>) INDEX fp_lst_selfield-tabindex.
    IF sy-subrc EQ 0.
      v_message = <lst_final_single>-other_cmnts.
      CLEAR : li_final[].
      APPEND <lst_final_single> TO li_final.
    ENDIF.
  ENDIF.
*--*New screen as Pop up for adding or removing the comments
  CALL SCREEN 100 STARTING AT 10 01
                      ENDING AT 100 05.
* Fetch details from Renewal Plan Table
* All fields (SELECT *) are fetched, since the entries have to be updated
* The table is being accessed again, to ensure that all Activities of an
* Order Item is included, even though User has not selected all of those
  IF li_final IS NOT INITIAL AND v_return = abap_true.
*--*Update added comments to ALV output
    IF fp_ucomm = lc_mass.
      LOOP AT fp_i_final ASSIGNING FIELD-SYMBOL(<lst_final_update>) WHERE sel IS NOT INITIAL.
        <lst_final_update>-other_cmnts = v_message.
      ENDLOOP.
    ELSE.
      READ TABLE fp_i_final ASSIGNING FIELD-SYMBOL(<lst_final_update2>) INDEX fp_lst_selfield-tabindex.
      IF sy-subrc EQ 0.
        <lst_final_update2>-other_cmnts = v_message.
      ENDIF.
    ENDIF.
*--*Update comments to database table
    SELECT *
      FROM zqtc_renwl_plan " E095: Renewal Plan Table
      INTO TABLE @DATA(li_renewal_plan)
       FOR ALL ENTRIES IN @li_final
     WHERE vbeln      EQ @li_final-vbeln
       AND posnr      EQ @li_final-posnr
       AND activity   EQ @li_final-activity
       AND act_status EQ @abap_false.
    IF sy-subrc EQ 0.
      LOOP AT li_renewal_plan ASSIGNING FIELD-SYMBOL(<lst_renewal_plan>).
        <lst_renewal_plan>-other_cmnts = v_message. "Other comments
        <lst_renewal_plan>-aedat = sy-datum. "Changed On
        <lst_renewal_plan>-aezet = sy-uzeit. "Changed At
        <lst_renewal_plan>-aenam = sy-uname. "Changed By
      ENDLOOP.
    ENDIF.
**   Update Renewal Plan Table
    CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL'
      TABLES
        t_renwl_plan = li_renewal_plan.
    COMMIT WORK AND WAIT.
  ENDIF.
*  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUP_EXCLUSION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_popup_exclusion .
  DATA  : lv_answer.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      text_question         = text-044
      text_button_1         = 'Yes'(046)
      text_button_2         = 'No'(047)
      default_button        = '1'
      display_cancel_button = abap_true
    IMPORTING
      answer                = lv_answer
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    CASE lv_answer.
      WHEN '2'.
        LEAVE SCREEN.
      WHEN 'A'.
        LEAVE SCREEN.
      WHEN OTHERS.
*            Donothing
    ENDCASE.
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUP_INCLUSION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_popup_inclusion .
  DATA  : lv_answer.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      text_question         = text-045
      text_button_1         = 'Yes'(046)
      text_button_2         = 'No'(047)
      default_button        = '1'
      display_cancel_button = abap_true
    IMPORTING
      answer                = lv_answer
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    CASE lv_answer.
      WHEN '2'.
        LEAVE SCREEN.
      WHEN 'A'.
        LEAVE SCREEN.
      WHEN OTHERS.
*            Donothing
    ENDCASE.
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUP_PROCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_popup_process .
  DATA  : lv_answer.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      text_question         = text-048
      text_button_1         = 'Yes'(046)
      text_button_2         = 'No'(047)
      default_button        = '1'
      display_cancel_button = abap_true
    IMPORTING
      answer                = lv_answer
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    CASE lv_answer.
      WHEN '2'.
        LEAVE SCREEN.
      WHEN 'A'.
        LEAVE SCREEN.
      WHEN OTHERS.
*            Donothing
    ENDCASE.
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_REMOVE_EXCL_REASON_1_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_FINAL  text
*----------------------------------------------------------------------*
FORM f_remove_excl_reason_1_2  CHANGING fp_i_final TYPE tt_final.

  PERFORM f_popup_inclusion.

  DATA(li_final) = fp_i_final.
  DELETE li_final WHERE sel IS INITIAL.
  IF li_final IS INITIAL.
*   Message: No record to be processed
    MESSAGE i020(zrar_messages). " No record to be processed
    RETURN.
  ENDIF. " IF li_final IS INITIAL

  SORT li_final BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM li_final
         COMPARING vbeln posnr.
* Fetch details from Renewal Plan Table
* All fields (SELECT *) are fetched, since the entries have to be updated
* The table is being accessed again, to ensure that all Activities of an
* Order Item is included, even though User has not selected all of those
  SELECT *
    FROM zqtc_renwl_plan " E095: Renewal Plan Table
    INTO TABLE @DATA(li_renewal_plan)
     FOR ALL ENTRIES IN @li_final
   WHERE vbeln      EQ @li_final-vbeln
     AND posnr      EQ @li_final-posnr
     AND act_status EQ @abap_false.
  IF sy-subrc EQ 0.
    LOOP AT li_renewal_plan ASSIGNING FIELD-SYMBOL(<lst_renewal_plan>).
      CLEAR: <lst_renewal_plan>-excl_resn, "Exclusion Reason
             <lst_renewal_plan>-excl_date,  "Exclusion date
             <lst_renewal_plan>-excl_resn2, "Exclusion Reason
             <lst_renewal_plan>-excl_date2. "Exclusion date
      <lst_renewal_plan>-aedat = sy-datum. "Changed On
      <lst_renewal_plan>-aezet = sy-uzeit. "Changed At
      <lst_renewal_plan>-aenam = sy-uname. "Changed By

      LOOP AT fp_i_final ASSIGNING FIELD-SYMBOL(<lst_final>)
                WHERE   vbeln    = <lst_renewal_plan>-vbeln
                AND      posnr    = <lst_renewal_plan>-posnr
                AND      activity = <lst_renewal_plan>-activity.
        CLEAR: <lst_final>-excl_resn,  "Exclusion Reason
               <lst_final>-excl_resn2,   "Exclusion Reason
               <lst_final>-excl_date,   "Exclusion Date
               <lst_final>-excl_date2,   "Exclusion Date
               <lst_final>-excl_resn_d, "Exclusion Reason Text
               <lst_final>-excl_resn_d2. "Exclusion Reason Text
        <lst_final>-aedat   = <lst_renewal_plan>-aedat. "Changed On
        <lst_final>-aezet   = <lst_renewal_plan>-aezet. "Changed At
        <lst_final>-aenam   = <lst_renewal_plan>-aenam. "Changed By
        <lst_final>-message = 'Exclusion Reason is removed'(004). "Message
      ENDLOOP.
    ENDLOOP. " LOOP AT li_renewal_plan ASSIGNING FIELD-SYMBOL(<lst_renewal_plan>)

*   Update Renewal Plan Table
    CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL'
      TABLES
        t_renwl_plan = li_renewal_plan.
    COMMIT WORK AND WAIT.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  DATA: i_line_length      TYPE i VALUE 254,
        o_editor_container TYPE REF TO cl_gui_custom_container,
        o_text_editor      TYPE REF TO cl_gui_textedit,
        i_text             TYPE string.

  SET PF-STATUS 'ZPOPUP'.
*  SET TITLEBAR 'xxx'.
  IF o_editor_container IS INITIAL.
    CREATE OBJECT o_editor_container
      EXPORTING
        container_name              = 'CONTAINER'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.

    CREATE OBJECT o_text_editor
      EXPORTING
        parent                     = o_editor_container
        wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position
        wordwrap_position          = i_line_length
        wordwrap_to_linebreak_mode = cl_gui_textedit=>true.
*----hide the toolbar and as well as status bar for the text editor control.
    CALL METHOD o_text_editor->set_toolbar_mode
      EXPORTING
        toolbar_mode = cl_gui_textedit=>false.

    CALL METHOD o_text_editor->set_statusbar_mode
      EXPORTING
        statusbar_mode = cl_gui_textedit=>false.
  ENDIF.
  CALL METHOD o_text_editor->set_textstream
    EXPORTING
      text                   = v_message "i_text
    EXCEPTIONS
      error_cntl_call_method = 1
      not_supported_by_gui   = 2
      OTHERS                 = 3.

*    CALL METHOD cl_gui_cfw=>flush
*      EXCEPTIONS
*        cntl_system_error = 1
*        cntl_error        = 2
*        OTHERS            = 3.
*  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'OK'.
      PERFORM f_update_text.
    WHEN 'DELETE'.
      PERFORM f_delete_text.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_text .
  DATA:lv_true TYPE i,
       lv_len  TYPE i.
  CLEAR : v_message,v_return.
  CALL METHOD o_text_editor->get_textstream
    EXPORTING
      only_when_modified     = cl_gui_textedit=>false
    IMPORTING
      text                   = v_message
      is_modified            = lv_true
    EXCEPTIONS
      error_cntl_call_method = 1
      not_supported_by_gui   = 2
      OTHERS                 = 3.
  CALL METHOD cl_gui_cfw=>flush
    EXCEPTIONS
      cntl_system_error = 1
      cntl_error        = 2
      OTHERS            = 3.
*  IF NOT o_text_editor IS INITIAL.
*    CALL METHOD o_text_editor->free.
*  ENDIF.
*  IF o_editor_container IS NOT INITIAL.
*    CALL METHOD o_editor_container->free.
*  ENDIF.
  lv_len = strlen( v_message ).
  IF lv_len GT 200.
    MESSAGE i022(zrar_messages).
    LEAVE LIST-PROCESSING.
  ELSE.
    v_return = abap_true.
    LEAVE TO SCREEN 0.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETE_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_delete_text .
  DATA  : lv_answer.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      text_question         = text-049
      text_button_1         = 'Yes'(046)
      text_button_2         = 'No'(047)
      default_button        = '1'
      display_cancel_button = abap_true
    IMPORTING
      answer                = lv_answer
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    CASE lv_answer.
      WHEN '1'.
        CLEAR : v_message.
        LEAVE SCREEN.
      WHEN '2'.
        LEAVE SCREEN.
      WHEN 'A'.
        LEAVE SCREEN.
      WHEN OTHERS.
*            Donothing
    ENDCASE.
  ENDIF. " IF sy-subrc
ENDFORM.
