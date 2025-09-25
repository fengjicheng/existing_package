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
* REVISION NO:  ED2K910734
* REFERENCE NO: Defect 6242
* DEVELOPER: SGUDA
* DATE:  02/06/2018
* DESCRIPTION: Defect 6242 : To improve the performance by using custom
*                            function module ZQTC_SDORDER_GETDETAILEDLIST
*                            insted of BAPISDORDER_GETDETAILEDLIST
*&---------------------------------------------------------------------*
*&      Form  F_F4
*&---------------------------------------------------------------------*
*       Custom F4 help for sales order in the selection screen
*----------------------------------------------------------------------*
FORM F_F4  CHANGING P_VBELN.

  DATA: LI_RETURN TYPE DDSHRETVAL OCCURS 0 WITH HEADER LINE.
  CONSTANTS: LC_AUART1 TYPE AUART VALUE 'ZSUB',
             LC_AUART2 TYPE AUART VALUE 'ZSUB'.

  SELECT VBELN FROM VBAK INTO TABLE I_VBELN WHERE AUART = LC_AUART1 OR AUART = LC_AUART2 .

  IF SY-SUBRC = 0.
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        RETFIELD        = 'VBELN_VA'
        DYNPPROG        = SY-REPID
        DYNPNR          = '1000'
        DYNPROFIELD     = 'S_vbeln'
        VALUE_ORG       = 'S'
      TABLES
        VALUE_TAB       = I_VBELN
        RETURN_TAB      = LI_RETURN[]
      EXCEPTIONS
        PARAMETER_ERROR = 1
        NO_VALUES_FOUND = 2
        OTHERS          = 3.

    IF NOT LI_RETURN[] IS INITIAL.
      READ TABLE LI_RETURN INDEX 1.
      IF SY-SUBRC = 0.
        P_VBELN = LI_RETURN-FIELDVAL.
      ENDIF.
    ENDIF.
  ENDIF.
  CLEAR: LI_RETURN[].
  REFRESH: I_VBELN.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_ORDER
*&---------------------------------------------------------------------*
*       Validate Order number
*----------------------------------------------------------------------*

FORM F_ORDER .
  IF S_VBELN[] IS NOT INITIAL  .
    SELECT VBELN " Sales order
      FROM VBAK " Sales Document: Header Data
      UP TO 1 ROWS
      INTO V_VBLEN
      WHERE
      VBELN IN S_VBELN.
    ENDSELECT.
    IF SY-SUBRC <> 0.
      MESSAGE E014(61) . "WITH text-001.

    ENDIF.

  ENDIF.

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
FORM F_FETCH_DATA CHANGING FP_I_FINAL       TYPE TT_FINAL
                           FP_I_ITEM        TYPE TT_ITEM
                           FP_I_PARTNER     TYPE TT_PARTNER
                           FP_I_BUSINESS    TYPE TT_BUSINESS
                           FP_I_TEXTHEADERS TYPE TT_TEXTHEADERS
                           FP_I_TEXTLINES   TYPE TT_TEXTLINES
                           FP_I_HEADER      TYPE TT_HEADER
                           FP_I_CONTRACT    TYPE TT_CONTRACT
                           FP_I_DOCFLOW     TYPE TT_DOCFLOW
                           FP_I_VEDA        TYPE TT_VEDA
                           FP_I_NAST        TYPE TT_NAST.
  DATA:
    LR_FINAL     TYPE REF TO TY_RENWL_PLAN,  " Renwl Plan type
    LR_BAPI_VIEW TYPE REF TO ORDER_VIEW,  " View for Mass Selection of Sales Orders
    LR_SO_VIEW   TYPE ZQTC_SO_VIEW,
    LR_SALES     TYPE REF TO ZQTC_SO_RANGE,       " Sales order
    LI_NAST      TYPE TT_NAST,                " Internal table
    LR_NAST      TYPE REF TO TY_NAST,         " reference variable
    LI_SALES     TYPE STANDARD TABLE OF ZQTC_SO_RANGE INITIAL SIZE 0. " Internal table
  CONSTANTS: LC_APPL_AREA TYPE SNA_KAPPL VALUE 'V1', " Sales area
*   Begin ADD:Defect 6242:SGUDA:06-FEB-2018:ED2K910734
             LC_X         TYPE CHAR1 VALUE 'X',
             LC_I         TYPE CHAR1 VALUE 'I',
             LC_EQ        TYPE CHAR2 VALUE 'EQ'.
*   End ADD:Defect 6242:SGUDA:06-FEB-2018:ED2K910734

  CREATE DATA: LR_BAPI_VIEW,
               LR_SALES.
  LOOP AT FP_I_FINAL REFERENCE INTO LR_FINAL.
    LR_SALES->SIGN = LC_I.
    LR_SALES->OPTION = LC_EQ.
    LR_SALES->VBELN_LOW = LR_FINAL->VBELN.
    APPEND LR_SALES->* TO  LI_SALES.
    CLEAR LR_SALES->*.
  ENDLOOP.
  SORT LI_SALES BY VBELN_LOW.
  DELETE ADJACENT DUPLICATES FROM LI_SALES COMPARING VBELN_LOW.
*   Begin ADD:Defect 6242:SGUDA:06-FEB-2018:ED2K910734
  LR_SO_VIEW-HEADER   = LC_X.
  LR_SO_VIEW-ITEM     = LC_X.
  LR_SO_VIEW-PARTNER  = LC_X.
  LR_SO_VIEW-BUSINESS = LC_X.
  LR_SO_VIEW-CONTRACT = LC_X.
*  LR_SO_VIEW-TEXTHEAD = LC_X.
*  LR_SO_VIEW-TEXTLINE = LC_X.
  LR_SO_VIEW-SDFLOW   = LC_X.
*  LR_SO_VIEW->HEADER = ABAP_TRUE.
*  LR_BAPI_VIEW->HEADER = ABAP_TRUE.
*  LR_BAPI_VIEW->ITEM = ABAP_TRUE.
*  LR_BAPI_VIEW->BUSINESS = ABAP_TRUE.
*  LR_BAPI_VIEW->PARTNER = ABAP_TRUE.
*  LR_BAPI_VIEW->TEXT = ABAP_TRUE.
*  LR_BAPI_VIEW->CONTRACT = ABAP_TRUE.
*  LR_BAPI_VIEW->FLOW = ABAP_TRUE.
*& Call function module to fecth order details
*  CALL FUNCTION 'BAPISDORDER_GETDETAILEDLIST'
*    EXPORTING
*      i_bapi_view           = lr_bapi_view->*
*    TABLES
*      sales_documents       = li_sales
*      order_headers_out     = fp_i_header
*      order_items_out       = fp_i_item
*      order_business_out    = fp_i_business
*      order_partners_out    = fp_i_partner
*      order_contracts_out   = fp_i_contract
*      order_textheaders_out = fp_i_textheaders
*      order_textlines_out   = fp_i_textlines
*      order_flows_out       = fp_i_docflow.
  CALL FUNCTION 'ZQTC_SDORDER_GETDETAILEDLIST'
    EXPORTING
      IM_SO_VIEW              = LR_SO_VIEW
      IM_KEY_REF              = LC_X
    TABLES
      T_SALES_DOCUMENTS       = LI_SALES
      T_ORDER_HEADERS_OUT     = FP_I_HEADER
      T_ORDER_ITEMS_OUT       = FP_I_ITEM
      T_ORDER_PARTNERS_OUT    = FP_I_PARTNER
      T_ORDER_CONTRACTS_OUT   = FP_I_CONTRACT
      T_ORDER_BUSINESS_OUT    = FP_I_BUSINESS
*      T_ORDER_TEXTHEADERS_OUT = FP_I_TEXTHEADERS
*      T_ORDER_TEXTLINES_OUT   = FP_I_TEXTLINES
      T_ORDER_FLOWS_OUT       = FP_I_DOCFLOW.
*      T_NAST                  =.
*   End   ADD:Defect 6242:SGUDA:06-FEB-2018:ED2K910734
  IF FP_I_DOCFLOW IS NOT INITIAL.
    SELECT V~VBELN,   " Sales Document
           V~ANGDT,   " Quotation/Inquiry is valid from
           V~BNDDT,   " Date until which bid/quotation is binding (valid-to date)
           V~VBTYP,   " SD document category
           V~AUART,   " Sales Document Type
           F~VBELV,   " Preceding sales and distribution document
           F~POSNN,   " Subsequent item of an SD document
           D~VBEGDAT, " Contract start date
           D~VENDDAT  " Contract end date
      FROM VBAK AS V INNER JOIN VBFA AS F
      ON V~VBELN = F~VBELN
      LEFT OUTER JOIN VEDA AS D ON V~VBELN = D~VBELN AND
                                   F~POSNN = D~VPOSN
      FOR ALL ENTRIES IN @FP_I_DOCFLOW
      WHERE
      V~VBELN = @FP_I_DOCFLOW-SUBSSDDOC AND
      F~POSNN = @FP_I_DOCFLOW-SUBSITDOC
               INTO CORRESPONDING FIELDS OF TABLE @FP_I_VEDA

.
    CREATE DATA LR_NAST.
    LOOP AT FP_I_DOCFLOW REFERENCE INTO DATA(LR_I_DOCFLOW).
      MOVE LR_I_DOCFLOW->SUBSSDDOC TO LR_NAST->OBJKY.
      APPEND LR_NAST->* TO LI_NAST.
      CLEAR LR_NAST->*.
    ENDLOOP.
    IF LI_NAST IS NOT INITIAL.
*& Fetch data from nast table
      SELECT  N~KAPPL,     " Application for message conditions
              N~OBJKY,     " Object key
              N~KSCHL,     " Message type
              N~SPRAS,     " Message language
              N~PARNR,     " Message partner
              N~PARVW,     " Partner function (for example SH for ship-to party)
              N~ERDAT,     " Date on which status record was created
              N~ERUHR,     " Time at which status record was created
              N~ADRNR,     " Address number
              N~NACHA,     " Message transmission medium
              N~ANZAL,     " Number of messages (original + copies)
              N~VSZTP
        FROM NAST AS N
        INTO TABLE @FP_I_NAST
        FOR ALL ENTRIES IN @LI_NAST
        WHERE KAPPL = @LC_APPL_AREA AND
        N~OBJKY = @LI_NAST-OBJKY.
      IF SY-SUBRC IS NOT INITIAL.
*        no actions
      ENDIF.
    ENDIF.
  ENDIF.


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
FORM F_CREATE_QUOATATION  USING    FP_I_HEADER TYPE TT_HEADER
                                   FP_I_ITEM TYPE TT_ITEM
                                   FP_I_BUSINESS TYPE TT_BUSINESS
                                   FP_I_PARTNER TYPE TT_PARTNER
                                   FP_I_TEXTHEADERS TYPE TT_TEXTHEADERS
                                   FP_I_TEXTLINES TYPE TT_TEXTLINES
                                   FP_I_CONTRACT TYPE TT_CONTRACT
                                   FP_CONST TYPE TT_CONST
                                   FP_TEST TYPE CHAR1
                           CHANGING FP_V_SALESORD TYPE BAPIVBELN-VBELN
                                    FP_V_ACT_STATUS   TYPE ZACT_STATUS
                                    FP_MESSAGE TYPE CHAR120
                                    FP_I_RETURN TYPE  TT_RETURN.

  DATA: LR_HEADER             TYPE REF TO BAPISDHD1, " Reference for header data
        LR_I_PARTNER          TYPE REF TO BAPISDPART, "Reference for partner
        LR_I_HEADER           TYPE REF TO  BAPISDHD, " Reference for bapi header
        LI_PARTNER            TYPE STANDARD TABLE OF BAPIPARNR INITIAL SIZE 0, " Internal table for partner details
        LI_BUSINESS           TYPE STANDARD TABLE OF BAPISDBUSI INITIAL SIZE 0,
        LI_RETURN             TYPE STANDARD TABLE OF BAPIRET2 INITIAL SIZE 0,  " reference variable for return
*       Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
        LR_SALES_CONTRACT_IN  TYPE  REF TO BAPICTR ,                     " contract data
        LI_SALES_CONTRACT_IN  TYPE STANDARD TABLE OF BAPICTR ,           " Internal  table for cond
        LR_SALES_CONTRACT_INX TYPE REF TO  BAPICTRX ,                    " Communication fields: SD Contract Data Checkbox
        LI_SALES_CONTRACT_INX TYPE  STANDARD TABLE OF BAPICTRX INITIAL SIZE 0 , " Communication fields: SD Contract Data Checkbox
*       End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
        LR_CONST              TYPE REF TO TY_CONST,                            " reference for consatnt table
        LR_PARTNER            TYPE REF TO BAPIPARNR,                           " refrence for partner
        LI_ITEM               TYPE STANDARD TABLE OF BAPISDITM INITIAL SIZE 0, " Items
        LR_ITEM               TYPE REF TO BAPISDITM,                            " reference variable for Item
        LR_BUSINESS           TYPE REF TO BAPISDBUSI,                          " VBKD data
        LI_ITEMX              TYPE STANDARD TABLE OF BAPISDITMX INITIAL SIZE 0, " reference for itemx
        LR_CONTRACT           TYPE REF TO BAPISDCNTR,                           " BAPI Structure of VEDA
        LR_RETURN             TYPE REF TO BAPIRET2,                             " BAPI return
        LST_BAPISDLS          TYPE BAPISDLS,
        LI_ORDER_SCHEDULES_IN TYPE STANDARD TABLE OF BAPISCHDL INITIAL SIZE 0,
        LR_ORDER_SCHEDULES_IN TYPE REF TO BAPISCHDL,
        LR_ITEMX              TYPE REF TO BAPISDITMX,                           " reference for itemx
        LR_I_ITEM             TYPE REF TO BAPISDIT,                             " reference for itemx
        LR_I_BUSINESS         TYPE REF TO BAPISDBUSI,
        LR_HEADERX            TYPE REF TO BAPISDHD1X.

*Begin of Add-Anirban-07.25.2017-ED2K907507-Defect 3528
  DATA : LV_SMATN TYPE SMATN.
*End of Add-Anirban-07.25.2017-ED2K907507-Defect 3528

  CONSTANTS: LC_QUOTATION TYPE VBTYP VALUE 'B', " quotation type
             LC_CONTRACT  TYPE VBTYP VALUE 'G', " contract
             LC_B         TYPE KNPRS VALUE 'B', " Copy manual pricing elements and redetermine the others
             LC_INSERT    TYPE CHAR1 VALUE 'I', " iNSERT
             LC_POSNR_LOW TYPE VBAP-POSNR    VALUE '000000',
             LC_DAYS      TYPE T5A4A-DLYDY VALUE '00',        " Days
             LC_MONTH     TYPE T5A4A-DLYMO  VALUE '00',       " Month
             LC_YEAR      TYPE T5A4A-DLYYR  VALUE '01',       " Year
             LC_DEVID     TYPE ZDEVID VALUE 'E096',              "Development ID
             LC_PARAM1    TYPE RVARI_VNAM VALUE 'CQ',          "Parameter1
*Begin of Add-Anirban-07.25.2017-ED2K907507-Defect 3528
             LC_KAPPL     TYPE KAPPL VALUE 'V',
             LC_KSCHL     TYPE KSCHD VALUE 'Z001'.
*End of Add-Anirban-07.25.2017-ED2K907507-Defect 3528
  CREATE DATA: LR_HEADER,
               LR_HEADERX,
               LR_PARTNER,
               LR_I_PARTNER,
*              Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
               LR_SALES_CONTRACT_INX,
               LR_SALES_CONTRACT_IN,
*              End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
               LR_ITEM,
               LR_ITEMX.

  READ TABLE FP_I_HEADER REFERENCE INTO LR_I_HEADER INDEX 1.
  IF SY-SUBRC = 0.
    LR_HEADER->SD_DOC_CAT = LC_QUOTATION.
    READ TABLE FP_CONST REFERENCE INTO LR_CONST WITH KEY DEVID  = LC_DEVID
                                                         PARAM1 = LC_PARAM1.
    IF SY-SUBRC = 0.
      LR_HEADER->DOC_TYPE = LR_CONST->LOW. " 'ZSQT'.
    ENDIF.
    LR_HEADER->SALES_ORG = LR_I_HEADER->SALES_ORG.
*              BOC KCHAKRABOR ERP-1888 2017-05-03
    LR_HEADER->SALES_OFF = LR_I_HEADER->SALES_OFF.
*              EOC KCHAKRABOR ERP-1888 2017-05-03
    LR_HEADER->DISTR_CHAN = LR_I_HEADER->DISTR_CHAN.
    LR_HEADER->DIVISION = LR_I_HEADER->DIVISION.
    LR_HEADER->REF_DOC = LR_I_HEADER->DOC_NUMBER. "low.
*Begin of Del-Anirban-09.28.2017-ED2K908670-Defect 4443
*    lr_header->ref_doc_l = lr_i_header->doc_number. " ZSUB Reference no in ZSQT quote
*End of Del-Anirban-09.28.2017-ED2K908670-Defect 4443
    LR_HEADER->REFDOC_CAT = LC_CONTRACT. "'G'.
    LR_HEADER->REFDOCTYPE = LC_CONTRACT. "'G'.
*Begin of Del-Anirban-09.20.2017-ED2K908625-Defect 4443
*    lr_header->ref_1 = lr_i_header->doc_number.
*End of Del-Anirban-09.20.2017-ED2K908625-Defect 4443
*   Begin of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    LR_HEADER->CURRENCY  = LR_I_HEADER->CURRENCY.
*   End   of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    LR_HEADER->REFOBJTYPE = 'VBAK'.
    LR_HEADER->REFOBJKEY = LR_I_HEADER->DOC_NUMBER.
    LR_HEADER->PO_METHOD = LR_I_HEADER->PO_METHOD.
*              BOC KCHAKRABOR ERP-1888 2017-05-03

    READ TABLE FP_I_BUSINESS REFERENCE INTO LR_I_BUSINESS WITH KEY SD_DOC     =   LR_I_HEADER->DOC_NUMBER
                                                                   ITM_NUMBER =   LC_POSNR_LOW.
    IF SY-SUBRC = 0.
      LR_HEADER->PRICE_GRP  =  LR_I_BUSINESS->PRICE_GRP.
*     Begin of ADD:ERP-5850:WROY:10-Jan-2018:ED2K910239
      LR_HEADER->PURCH_NO_C	 = LR_I_BUSINESS->PURCH_NO_C. "Customer purchase order number
      LR_HEADERX->PURCH_NO_C = ABAP_TRUE.                 "Customer purchase order number
*     End   of ADD:ERP-5850:WROY:10-Jan-2018:ED2K910239
    ENDIF.
*              EOC KCHAKRABOR ERP-1888 2017-05-03
    READ TABLE FP_I_CONTRACT REFERENCE INTO LR_CONTRACT WITH KEY DOC_NUMBER = LR_I_HEADER->DOC_NUMBER.
    IF SY-SUBRC = 0.
      LR_HEADER->QT_VALID_F = LR_CONTRACT->CONTENDDAT + 1.
      LR_HEADER->PRICE_DATE = LR_HEADER->QT_VALID_F.

      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
        EXPORTING
          DATE      = LR_HEADER->QT_VALID_F
          DAYS      = LC_DAYS
          MONTHS    = LC_MONTH
          YEARS     = LC_YEAR
        IMPORTING
          CALC_DATE = LR_HEADER->QT_VALID_T.
      LR_HEADER->QT_VALID_T = LR_HEADER->QT_VALID_T - 1.
*     Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
      LR_SALES_CONTRACT_INX->UPDATEFLAG = LC_INSERT.
      LR_SALES_CONTRACT_IN->CON_ST_DAT = LR_CONTRACT->CONTENDDAT + 1.
      LR_SALES_CONTRACT_INX->CON_ST_DAT = ABAP_TRUE.

*Begin of Add-Anirban-10.09.2017-ED2K908905-Defect 4773
      LR_HEADER->REQ_DATE_H = LR_SALES_CONTRACT_IN->CON_ST_DAT.
      LR_HEADERX->REQ_DATE_H = ABAP_TRUE.
*End of Add-Anirban-10.09.2017-ED2K908905-Defect 4773


      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
        EXPORTING
          DATE      = LR_SALES_CONTRACT_IN->CON_ST_DAT
          DAYS      = LC_DAYS
          MONTHS    = LC_MONTH
          YEARS     = LC_YEAR
        IMPORTING
          CALC_DATE = LR_SALES_CONTRACT_IN->CON_EN_DAT.
      LR_SALES_CONTRACT_IN->CON_EN_DAT = LR_SALES_CONTRACT_IN->CON_EN_DAT - 1.
      LR_SALES_CONTRACT_INX->CON_EN_DAT = ABAP_TRUE.
      APPEND LR_SALES_CONTRACT_IN->* TO LI_SALES_CONTRACT_IN.
      CLEAR LR_SALES_CONTRACT_IN->*.
      APPEND LR_SALES_CONTRACT_INX->* TO LI_SALES_CONTRACT_INX.
      CLEAR LR_SALES_CONTRACT_INX->*.
*     End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
    ENDIF.
    SELECT SINGLE TAXK1
      FROM VBAK
      INTO LR_HEADER->ALTTAX_CLS
      WHERE VBELN = LR_HEADER->REF_DOC.

    SELECT SINGLE INCO1 INCO2
      FROM VBKD
      INTO (LR_HEADER->INCOTERMS1, LR_HEADER->INCOTERMS2)
      WHERE VBELN = LR_HEADER->REF_DOC
      AND POSNR = '00000'.
    LR_HEADERX->REFDOC_CAT = ABAP_TRUE.
    LR_HEADERX->DOC_TYPE = ABAP_TRUE.
    LR_HEADERX->SALES_ORG = ABAP_TRUE.
    LR_HEADERX->DISTR_CHAN = ABAP_TRUE.
    LR_HEADERX->DIVISION = ABAP_TRUE.
    LR_HEADERX->REF_DOC = ABAP_TRUE.
    LR_HEADERX->REF_1 = ABAP_TRUE.
*   Begin of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    LR_HEADERX->CURRENCY  = ABAP_TRUE.
*   End   of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    LR_HEADERX->UPDATEFLAG = LC_INSERT.
    LOOP AT FP_I_PARTNER REFERENCE INTO LR_I_PARTNER WHERE CUSTOMER IS NOT INITIAL AND ITM_NUMBER = LC_POSNR_LOW.

      LR_PARTNER->PARTN_ROLE = LR_I_PARTNER->PARTN_ROLE.
      LR_PARTNER->PARTN_NUMB = LR_I_PARTNER->CUSTOMER.
      LR_PARTNER->ITM_NUMBER = LR_I_PARTNER->ITM_NUMBER.
      APPEND LR_PARTNER->* TO LI_PARTNER.
      CLEAR LR_PARTNER->*.
    ENDLOOP.
    CREATE DATA LR_ORDER_SCHEDULES_IN.
    LOOP AT FP_I_ITEM REFERENCE INTO LR_I_ITEM.
*Begin of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
      IF LR_I_ITEM->HG_LV_ITEM NE LC_POSNR_LOW.
        LR_ITEM->ITM_NUMBER = LR_I_ITEM->HG_LV_ITEM.
        LR_I_ITEM->HG_LV_ITEM = LC_POSNR_LOW.
        LR_ITEM->REF_1 = ABAP_TRUE.
      ELSE.
*End of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
        LR_ITEM->ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
*Begin of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
      ENDIF.
*EOD ADD ANI

*      lr_item->price_grp  = lr_i_item->prc_group1.
*Begin of Del-Anirban-10.04.2017-ED2K908816-Defect 4753
*      lr_itemx->itm_number = lr_i_item->itm_number.
*End of Del-Anirban-10.04.2017-ED2K908816-Defect 4753
*Begin of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
      LR_ITEMX->ITM_NUMBER = LR_ITEM->ITM_NUMBER.
*End of Add-Anirban-10.04.2017-ED2K908816-Defect 4753

*Begin of Del-Anirban-10.04.2017-ED2K908816-Defect 4753
*      lr_order_schedules_in->itm_number = lr_i_item->itm_number.
*End of Del-Anirban-10.04.2017-ED2K908816-Defect 4753
*Begin of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
      LR_ORDER_SCHEDULES_IN->ITM_NUMBER = LR_ITEM->ITM_NUMBER.
*End of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
      LR_ORDER_SCHEDULES_IN->SCHED_LINE = '0001'.
      LR_ORDER_SCHEDULES_IN->REQ_QTY = LR_I_ITEM->TARGET_QTY.

*Begin of Del-Anirban-07.25.2017-ED2K907507-Defect 3528
*      lr_item->material =  lr_i_item->material.
*End of Del-Anirban-07.25.2017-ED2K907507-Defect 3528
*Begin of Add-Anirban-07.25.2017-ED2K907507-Defect 3528
      SELECT SINGLE SMATN FROM KONDD AS B INNER JOIN KOTD001 AS A
        ON A~KNUMH = B~KNUMH
        WHERE A~KAPPL = @LC_KAPPL
        AND A~MATWA   = @LR_I_ITEM->MATERIAL
        AND A~KSCHL   = @LC_KSCHL
        AND ( DATAB LE @SY-DATUM AND DATBI GE @SY-DATUM )
        INTO @LV_SMATN.
      IF SY-SUBRC = 0.
        LR_ITEM->MATERIAL = LV_SMATN.
      ELSE.
        LR_ITEM->MATERIAL = LR_I_ITEM->MATERIAL.
      ENDIF.
*End of Add-Anirban-07.25.2017-ED2K907507-Defect 3528

      LR_ITEM->TARGET_QTY =  LR_I_ITEM->TARGET_QTY .
      LR_ITEM->TARGET_QU = LR_I_ITEM->TARGET_QU.
      LR_ITEM->PLANT = LR_I_ITEM->PLANT.
      LR_ITEM->REFOBJKEY = LR_HEADER->REF_DOC.
      LR_ITEM->REFOBJTYPE =  'VBAK'.


      READ TABLE FP_I_BUSINESS REFERENCE INTO LR_I_BUSINESS WITH KEY ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
      IF SY-SUBRC = 0.
        LR_ITEM->PO_METHOD = LR_I_BUSINESS->PO_METHOD.
*Begin of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
        IF LR_ITEM->REF_1 = ABAP_TRUE.
          CLEAR LR_ITEM->REF_1.
        ELSE.
*End of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
          LR_ITEM->REF_1 = LR_I_BUSINESS->REF_1.
*Begin of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
        ENDIF.
*End of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
*              BOC KCHAKRABOR ERP-1888 2017-05-03
        LR_ITEM->PRICE_GRP = LR_I_BUSINESS->PRICE_GRP.
*              EOC KCHAKRABOR ERP-1888 2017-05-03
*       Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
        LR_ITEM->CUST_GROUP = LR_I_BUSINESS->CUST_GROUP. "Customer Group
*       End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
      ENDIF.
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
      LOOP AT FP_I_PARTNER REFERENCE INTO LR_I_PARTNER WHERE ITM_NUMBER = LR_I_ITEM->ITM_NUMBER
                                                       OR ITM_NUMBER = LC_POSNR_LOW .
        LR_PARTNER->PARTN_ROLE = LR_I_PARTNER->PARTN_ROLE.
        IF NOT LR_I_PARTNER->CUSTOMER IS INITIAL.
          LR_PARTNER->PARTN_NUMB = LR_I_PARTNER->CUSTOMER.
        ELSEIF NOT LR_I_PARTNER->PERSON_NO IS INITIAL..
          LR_PARTNER->PARTN_NUMB = LR_I_PARTNER->PERSON_NO.
        ENDIF.
        LR_PARTNER->ITM_NUMBER = LR_I_PARTNER->ITM_NUMBER.
        APPEND LR_PARTNER->* TO LI_PARTNER.
        CLEAR LR_PARTNER->*.
      ENDLOOP.
      SORT LI_PARTNER BY PARTN_ROLE PARTN_NUMB.
      DELETE ADJACENT DUPLICATES FROM LI_PARTNER COMPARING PARTN_ROLE PARTN_NUMB.
*End of Add-Anirban-07.10.2017-ED2K907327-Defect 3068


      IF NOT LR_I_ITEM->REF_DOC IS INITIAL.
        LR_ITEM->REF_DOC  =   LR_I_ITEM->REF_DOC.
      ENDIF.
      LR_ITEM->HG_LV_ITEM = LR_I_ITEM->HG_LV_ITEM.
      IF NOT LR_I_ITEM->ITM_NUMBER IS INITIAL.
        LR_ITEM->REF_DOC_IT = LR_I_ITEM->ITM_NUMBER.
      ENDIF.
*     Begin of DEL:ERP-5538:WROY:06-Dec-2017:ED2K909739
*     IF lr_i_item->doc_cat_sd IS NOT INITIAL.
*       lr_item->ref_doc_ca = lr_i_item->doc_cat_sd.
*     ELSE.
*       lr_item->ref_doc_ca = lc_contract.
*
*     ENDIF.
*     End   of DEL:ERP-5538:WROY:06-Dec-2017:ED2K909739
      LR_ITEM->REF_DOC_CA = LR_HEADER->REFDOC_CAT.
*     Begin of ADD:ERP-5538:WROY:06-Dec-2017:ED2K909739
*     End   of ADD:ERP-5538:WROY:06-Dec-2017:ED2K909739
      LR_ITEM->REF_DOC = LR_HEADER->REF_DOC.
*     Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
      READ TABLE FP_I_CONTRACT REFERENCE INTO LR_CONTRACT WITH KEY DOC_NUMBER = LR_I_ITEM->DOC_NUMBER
                                                                   ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
      IF SY-SUBRC = 0.
        LR_SALES_CONTRACT_INX->UPDATEFLAG = LC_INSERT.
*Begin of Del-Anirban-10.04.2017-ED2K908816-Defect 4753
*        lr_sales_contract_in->itm_number = lr_i_item->itm_number.
*        lr_sales_contract_inx->itm_number = lr_i_item->itm_number.
*End of Del-Anirban-10.04.2017-ED2K908816-Defect 4753
*Begin of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
        LR_SALES_CONTRACT_IN->ITM_NUMBER = LR_ITEM->ITM_NUMBER.
        LR_SALES_CONTRACT_INX->ITM_NUMBER = LR_ITEM->ITM_NUMBER.
*End of Add-Anirban-10.04.2017-ED2K908816-Defect 4753
        LR_SALES_CONTRACT_IN->CON_ST_DAT = LR_CONTRACT->CONTENDDAT + 1.
        LR_SALES_CONTRACT_INX->CON_ST_DAT = ABAP_TRUE.
        LR_HEADER->PRICE_DATE = LR_SALES_CONTRACT_IN->CON_ST_DAT.

        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            DATE      = LR_SALES_CONTRACT_IN->CON_ST_DAT
            DAYS      = LC_DAYS
            MONTHS    = LC_MONTH
            YEARS     = LC_YEAR
          IMPORTING
            CALC_DATE = LR_SALES_CONTRACT_IN->CON_EN_DAT.
        LR_SALES_CONTRACT_IN->CON_EN_DAT = LR_SALES_CONTRACT_IN->CON_EN_DAT - 1.
        LR_SALES_CONTRACT_INX->CON_EN_DAT = ABAP_TRUE.
        APPEND LR_SALES_CONTRACT_IN->* TO LI_SALES_CONTRACT_IN.
        CLEAR LR_SALES_CONTRACT_IN->*.
        APPEND LR_SALES_CONTRACT_INX->* TO LI_SALES_CONTRACT_INX.
        CLEAR LR_SALES_CONTRACT_INX->*.
      ENDIF.
*     End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489

      APPEND LR_ITEM->* TO LI_ITEM.
      CLEAR LR_ITEM->*.
      APPEND LR_ORDER_SCHEDULES_IN->* TO LI_ORDER_SCHEDULES_IN.
      CLEAR  LR_ORDER_SCHEDULES_IN->*.
    ENDLOOP.
    LST_BAPISDLS-PRICING = LC_B.

    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        SALES_HEADER_IN       = LR_HEADER->*
        INT_NUMBER_ASSIGNMENT = ABAP_TRUE
        LOGIC_SWITCH          = LST_BAPISDLS
        TESTRUN               = FP_TEST
      IMPORTING
        SALESDOCUMENT_EX      = FP_V_SALESORD
      TABLES
        RETURN                = LI_RETURN
        SALES_ITEMS_IN        = LI_ITEM
        SALES_PARTNERS        = LI_PARTNER
        SALES_SCHEDULES_IN    = LI_ORDER_SCHEDULES_IN
*       Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
        SALES_CONTRACT_IN     = LI_SALES_CONTRACT_IN
        SALES_CONTRACT_INX    = LI_SALES_CONTRACT_INX
*       End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
        TEXTHEADERS_EX        = FP_I_TEXTHEADERS
        TEXTLINES_EX          = FP_I_TEXTLINES.
    READ TABLE LI_RETURN REFERENCE INTO LR_RETURN WITH KEY TYPE = 'E'.
    IF SY-SUBRC <> 0.
      IF  FP_TEST EQ SPACE .
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            WAIT = ABAP_TRUE.
        FP_V_ACT_STATUS = ABAP_TRUE.
        CONCATENATE 'Quotation'(a10) FP_V_SALESORD 'created'(a11) INTO FP_MESSAGE
        SEPARATED BY SPACE.
      ELSE.
        CONCATENATE 'Quotation'(a10) FP_V_SALESORD 'can be created'(x11) INTO FP_MESSAGE
        SEPARATED BY SPACE.
      ENDIF.

    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      APPEND LINES OF LI_RETURN TO FP_I_RETURN.
      LOOP AT LI_RETURN REFERENCE INTO  LR_RETURN WHERE TYPE = 'E'.
        IF SY-TABIX = 1.
          CONCATENATE 'Quotation failed'(a13) FP_MESSAGE INTO FP_MESSAGE.
        ELSE.
          CONCATENATE FP_MESSAGE LR_RETURN->MESSAGE INTO FP_MESSAGE SEPARATED BY SPACE.
        ENDIF.

      ENDLOOP.

    ENDIF.
  ENDIF.
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
FORM F_TRIGGER_OUTPUT_TYPE  USING
                                  FP_I_CONSTX TYPE TT_CONST
                                  FP_I_PARTNER TYPE  TT_PARTNER
                                  FP_I_NOTIF_PROF TYPE TT_NOTIF_P_DET
                                  FP_NAST TYPE TT_NAST
                       CHANGING FP_LR_FINAL TYPE TY_RENWL_PLAN
  .
  DATA:
    LI_VBFA     TYPE STANDARD TABLE OF VBFA INITIAL SIZE 0, " Sales Document Flow
    LV_REMINDER TYPE ZNOTIF_REM,                            " Notification/Reminder
    LR_PARTNER  TYPE REF TO BAPISDPART,                     " BAPI Structure of VBPA with English Field Names
    LR_VBFA     TYPE REF TO VBFA,                           " reference variable Sales Document Flow
    LV_OBJKEY   TYPE CHAR30,                                " Object key for nast
    LR_NAST     TYPE REF TO NAST,
    LW_T685B    TYPE T685B.

  CONSTANTS: LC_V1            TYPE SNA_KAPPL VALUE 'V1',   " Application area
             LC_01            TYPE NA_ANZAL VALUE '01',    " Number of message
*             lc_02            TYPE na_anzal VALUE '02',    " Dispatch time
             LC_PROC_SUC      TYPE NA_VSTAT VALUE '0',     " sucessfully processed
             LC_QUOTATION     TYPE VBFA-VBTYP_V VALUE 'B', " quotation
             LC_CONTRACT      TYPE VBFA-VBTYP_N VALUE 'G', " contract
             LC_SHIP_TO_PARTY TYPE PARVW VALUE 'WE',       " ship-to-party
             LC_INT           TYPE AD_COMM VALUE 'INT',    " email
             LC_LET           TYPE AD_COMM VALUE 'LET'.    " print

  CALL FUNCTION 'READ_VBFA'
    EXPORTING
      I_VBELV         = FP_LR_FINAL-VBELN
      I_POSNV         = FP_LR_FINAL-POSNR
      I_VBTYP_V       = LC_CONTRACT
      I_VBTYP_N       = LC_QUOTATION
    TABLES
      E_VBFA          = LI_VBFA
    EXCEPTIONS
      NO_RECORD_FOUND = 1
      OTHERS          = 2.
  IF SY-SUBRC <> 0.
* No need to handle exceprtion
  ENDIF.
*& Update Promo code in the Quotation
*  IF fp_lr_final-promo_code IS NOT INITIAL .
  PERFORM F_UPDATE_PROMO_CODE USING LI_VBFA
                                    FP_I_NOTIF_PROF
                                    FP_LR_FINAL .

*  ENDIF.

  CREATE DATA LR_NAST.
  CLEAR LV_OBJKEY.
  READ TABLE LI_VBFA REFERENCE INTO LR_VBFA INDEX 1.
  IF SY-SUBRC = 0.
    LV_OBJKEY  = LR_VBFA->VBELN."object key. Po, shipment etc
  ENDIF.

  DATA : LV_COMM   TYPE AD_COMM,
         LV_PROMO  TYPE ZPROMO,
         LV_ADRNR  TYPE ADRNR,
         LV_PARAM2 TYPE RVARI_VNAM.
  CLEAR: LV_COMM, LV_PROMO, LV_ADRNR, LV_PARAM2.

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
  IF LV_OBJKEY IS NOT INITIAL.
*-----Get partner profile
    LR_NAST->PARVW  = LC_SHIP_TO_PARTY. "WE           "partner function
*-----Get partner # based on partner profile
    READ TABLE FP_I_PARTNER REFERENCE INTO LR_PARTNER  WITH KEY PARTN_ROLE = LC_SHIP_TO_PARTY.
    IF SY-SUBRC = 0.
      LR_NAST->PARNR  = LR_PARTNER->CUSTOMER. "'0040126506'."message partner
*-----Get address # for the customer to get the to get the default communication method
      SELECT SINGLE ADRNR FROM KNA1 INTO LV_ADRNR WHERE KUNNR = LR_NAST->PARNR.
      IF SY-SUBRC = 0.
*-----Get communication method
        SELECT SINGLE DEFLT_COMM FROM ADRC INTO LV_COMM WHERE ADDRNUMBER = LV_ADRNR.
*-----if INT (email) = communication method 5 / LET (print) = communication method 1
        IF SY-SUBRC = 0.
          IF LV_COMM = LC_INT.
            LR_NAST->NACHA = 5.
          ELSEIF LV_COMM = LC_LET.
            LR_NAST->NACHA = 1.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    LR_NAST->MANDT  = SY-MANDT.
    LR_NAST->KAPPL  = LC_V1."Application area
    READ TABLE LI_VBFA REFERENCE INTO LR_VBFA INDEX 1.
    IF SY-SUBRC = 0.
      LR_NAST->OBJKY  = LR_VBFA->VBELN."object key. Po, shipment etc
      SELECT SINGLE ZZPROMO INTO LV_PROMO FROM VBAK WHERE VBELN = LR_NAST->OBJKY.
    ENDIF.

    CLEAR LV_REMINDER.
    LV_REMINDER =  FP_LR_FINAL-ACTIVITY.
    READ TABLE FP_I_NOTIF_PROF ASSIGNING FIELD-SYMBOL(<LST_NOTIF_PROF>) WITH KEY RENWL_PROF = FP_LR_FINAL-RENWL_PROF
                                                                                 NOTIF_REM  = LV_REMINDER.
    IF SY-SUBRC = 0.
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
      IF LV_PROMO IS NOT INITIAL.
        DATA(LV_PROMO_FLAG) = ABAP_TRUE.
      ENDIF.

      SELECT SINGLE OUTPUT_TYPE
        FROM ZQTC_NOTIF_OUTPT
        INTO @DATA(LV_OUTPUT_TYPE)
        WHERE NOTIF_PROF = @<LST_NOTIF_PROF>-NOTIF_PROF
        AND   PROMO = @LV_PROMO_FLAG
        AND   COMM_METHOD = @LV_COMM.
      IF SY-SUBRC EQ 0.
        LR_NAST->KSCHL  = LV_OUTPUT_TYPE.
      ENDIF.
    ENDIF.
*<<<<<<<<<<<<<<<<<<EOC by MODUTTA on 05/12/2017 for Defect# ERp 1865>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

*-----Get data from config
    SELECT SINGLE * FROM T685B INTO LW_T685B WHERE KSCHL = LR_NAST->KSCHL
                                             AND   KAPPL = LC_V1.
    IF SY-SUBRC = 0.
      LR_NAST->SPRAS = SY-LANGU.          "language
      LR_NAST->TCODE = LW_T685B-STRATEGY. "Comm strategy
    ENDIF.
    LR_NAST->SPRAS  = SY-LANGU.          "language
    LR_NAST->ERDAT  = SY-DATUM.          "current date
    LR_NAST->ERUHR  = SY-UZEIT.          "current time
    LR_NAST->USNAM  = SY-UNAME.          "User name
    LR_NAST->LDEST  = 'LP01'.            "Print destination

*    lr_nast->nacha  = 1.                 "message transmission medium
    LR_NAST->ANZAL  = LC_01.             "number of messages
*    lr_nast->vsztp  = sy-uzeit.         "Dispatch time
    LR_NAST->VSTAT  = LC_PROC_SUC.       "processing status

    LR_NAST->VSDAT  = FP_LR_FINAL-EADAT. "Requested date for sending message
    LR_NAST->VSURA  = '000001'.          "Requested time for sending message (from)
    LR_NAST->VSURB  = '235959'.          "Requested time for sending message (to)
    LR_NAST->VSZTP  = LC_01.             "Dispatch time

  ENDIF.
  IF P_TEST EQ SPACE AND LV_OBJKEY IS NOT INITIAL AND  LR_NAST->NACHA IS NOT INITIAL AND LR_NAST->KSCHL IS NOT INITIAL.
    CALL FUNCTION 'RV_MESSAGE_UPDATE_SINGLE'
      EXPORTING
        MSG_NAST = LR_NAST->*.
    COMMIT WORK AND WAIT.
    IF FP_LR_FINAL-ACT_STATUS <> ABAP_TRUE .
      FP_LR_FINAL-ACT_STATUS = ABAP_TRUE.
    ENDIF.
  ELSEIF LV_OBJKEY IS INITIAL .
    CONCATENATE 'Quotation not found'(t32)  FP_LR_FINAL-MESSAGE INTO FP_LR_FINAL-MESSAGE.
  ELSEIF LR_NAST->NACHA IS INITIAL.
*-----display massage when no communication method is found
    CONCATENATE 'Default comm startegy missing in customer master'(t33)  FP_LR_FINAL-MESSAGE INTO FP_LR_FINAL-MESSAGE.
  ELSEIF LR_NAST->KSCHL IS INITIAL.
*-----display massage when no communication method is found
    CONCATENATE 'Maintain entry in the notification profile output type table'(t34)  FP_LR_FINAL-MESSAGE INTO FP_LR_FINAL-MESSAGE SEPARATED BY '/'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_ACTIVITY
*&---------------------------------------------------------------------*
*       Populate Activity
*----------------------------------------------------------------------*
*  <--  fp_i_activity : Activity Table
*  <--  fp_i_lis      : Value Request Manager
*----------------------------------------------------------------------*
FORM F_FETCH_ACTIVITY  CHANGING FP_I_ACTIVITY TYPE TT_ACTIVITY
                                FP_I_LIST TYPE VRM_VALUES.
  DATA: LR_LIST     TYPE REF TO  VRM_VALUE,            " Value Request Manager
        LV_TEXT     TYPE CHAR80,                       " Text field
        LR_ACTIVITY TYPE REF TO TY_ACTIVITY.           " Reference Variable
  CONSTANTS: LC_ALL      TYPE CHAR3 VALUE 'ALL',       " ALL Activity
             LC_ACTIVITY TYPE  VRM_ID VALUE 'P_ACTIV'. " Activity Parameter
  CREATE DATA LR_LIST.
  SELECT ACTIVITY                     " E095: Activity
        SPRAS                         " Language Key
        ACTIVITY_D                    " Description
   FROM ZQTCT_ACTIVITY                " E095: Activity Text Table
   INTO TABLE FP_I_ACTIVITY
   WHERE
   SPRAS = SY-LANGU.
  IF SY-SUBRC = 0.
    LOOP AT FP_I_ACTIVITY REFERENCE INTO LR_ACTIVITY.
      LR_LIST->KEY = LR_ACTIVITY->ACTIVITY.
      CONCATENATE LR_ACTIVITY->ACTIVITY
                  LR_ACTIVITY->ACTIVITY_D INTO LV_TEXT SEPARATED BY SPACE.
      LR_LIST->TEXT = LV_TEXT.
      APPEND LR_LIST->* TO FP_I_LIST.
      CLEAR LR_LIST->*.

    ENDLOOP.
*& Populate ALL Activty type
    LR_LIST->KEY = LC_ALL.
    LR_LIST->TEXT = 'All Activity'(t01).
    APPEND LR_LIST->* TO FP_I_LIST.
    CLEAR LR_LIST->*.
  ENDIF.
*& Set values for drop down list
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID              = LC_ACTIVITY
      VALUES          = FP_I_LIST
    EXCEPTIONS
      ID_ILLEGAL_NAME = 1
      OTHERS          = 2.
  IF SY-SUBRC <> 0.
*& do nothing
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_PROF
*&---------------------------------------------------------------------*
*      Fetch renewal Prfole details
*----------------------------------------------------------------------*
*      <--fP_I_RENWL_PROF  : Renewakl Profile
*      <--FP_I_LIST_RENWL  : VRM values
*----------------------------------------------------------------------*
FORM F_FETCH_PROF  CHANGING FP_I_RENWL_PROF TYPE TT_RENWL_PROF
                            FP_I_LIST_RENWL TYPE VRM_VALUES.
  DATA:       LV_TEXT       TYPE CHAR80,                      " Text
              LR_LIST       TYPE REF TO  VRM_VALUE,           " VRM value
              LR_RENWL_PROF TYPE REF TO TY_RENWL_PROF.        " Reference variable
  CONSTANTS: LC_ALL     TYPE CHAR3 VALUE 'ALL',               " ALL activity
             LC_PROFILE TYPE VRM_ID VALUE 'P_PROF'.           " VRM ID
  CREATE DATA LR_LIST.
  SELECT RENWL_PROF        " Renewal Profile
          SPRAS            " Language Key
          RENWL_PROF_D     " Description
     FROM ZQTCT_RENWL_PROF " E095: Renewal Profile Table
     INTO TABLE FP_I_RENWL_PROF
     WHERE
     SPRAS = SY-LANGU.
  IF SY-SUBRC = 0.
    LOOP AT FP_I_RENWL_PROF REFERENCE INTO LR_RENWL_PROF.
      LR_LIST->KEY = LR_RENWL_PROF->RENWL_PROF.
      CONCATENATE LR_RENWL_PROF->RENWL_PROF
                  LR_RENWL_PROF->RENWL_PROF_D INTO LV_TEXT SEPARATED BY SPACE.
      LR_LIST->TEXT = LV_TEXT.
      APPEND LR_LIST->* TO FP_I_LIST_RENWL.
      CLEAR LR_LIST->*.

    ENDLOOP.
    LR_LIST->KEY = LC_ALL.
    LR_LIST->TEXT = 'All profile'(t02).
    APPEND LR_LIST->* TO FP_I_LIST_RENWL.
    CLEAR LR_LIST->*.
  ENDIF.
*& call function module Value Request Manager
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID              = LC_PROFILE "'P_PROF'
      VALUES          = FP_I_LIST_RENWL
    EXCEPTIONS
      ID_ILLEGAL_NAME = 1
      OTHERS          = 2.
  IF SY-SUBRC <> 0.
*& do nothing
  ENDIF.
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
FORM F_FETCH_RENWAL_DETER  USING    FP_P_ACTIV TYPE ZACTIVITY_SUB
                                    FP_P_PROF  TYPE ZRENWL_PROF
                           CHANGING FP_I_RENWL_PLAN TYPE TT_FINAL
                                    FP_REWAL_PLAN   TYPE TT_RENWL_PLAN .
  TYPES: BEGIN OF LTY_ACTIVITY,
           SIGN(1)   TYPE C,
           OPTION(2) TYPE C,
           LOW       TYPE ZACTIVITY_SUB,
           HIGH      TYPE ZACTIVITY_SUB,
         END OF LTY_ACTIVITY,

         BEGIN OF LTY_RENWL_PROF,
           SIGN(1)   TYPE C,
           OPTION(2) TYPE C,
           LOW       TYPE ZRENWL_PROF,
           HIGH      TYPE ZRENWL_PROF,
         END OF LTY_RENWL_PROF.

  DATA: LI_RENWL_PLAN  TYPE STANDARD TABLE OF ZQTC_RENWL_PLAN INITIAL SIZE 0 " Internal table
        WITH NON-UNIQUE SORTED KEY SORT_KEY COMPONENTS VBELN POSNR  ,

        LIR_ACTIV      TYPE RANGE OF  ZACTIVITY_SUB INITIAL SIZE 0,          " Range table
        LR_ACTIV       TYPE REF TO LTY_ACTIVITY,                             " Reference table for activity
        LIR_RENWL_PROF TYPE RANGE OF  ZRENWL_PROF INITIAL SIZE 0,             " Range table
        LR_RENWL_PROF  TYPE REF TO LTY_RENWL_PROF,                            " Reference table
        LR_FINAL       TYPE REF TO TY_RENWL_PLAN,                             " Reference table for final
        LR_RENWL_PLAN  TYPE REF TO ZQTC_RENWL_PLAN.

  CONSTANTS: LC_ALL     TYPE CHAR3 VALUE 'ALL',                                " ALL
             LC_*       TYPE CHAR1 VALUE '*',
             LC_INCLUDE TYPE CHAR1 VALUE 'I',                                 " Insert
             LC_PATTERN TYPE CHAR2 VALUE 'CP',                                " Compare
             LC_EQUAL   TYPE CHAR2 VALUE 'EQ'.

  CREATE DATA: LR_ACTIV,
               LR_RENWL_PLAN,
               LR_RENWL_PROF.

  LR_ACTIV->SIGN = LC_INCLUDE.
  LR_RENWL_PROF->SIGN = LC_INCLUDE.
  IF FP_P_ACTIV = LC_ALL.
    LR_ACTIV->OPTION = LC_PATTERN.
    LR_ACTIV->LOW = LC_*.
  ELSE.
    LR_ACTIV->OPTION = LC_EQUAL.
    LR_ACTIV->LOW = FP_P_ACTIV.

  ENDIF.
  APPEND LR_ACTIV->* TO LIR_ACTIV.

  IF FP_P_PROF = LC_ALL.
    LR_RENWL_PROF->OPTION = LC_PATTERN.
    LR_RENWL_PROF->LOW = LC_*.
  ELSE.
    LR_RENWL_PROF->OPTION = LC_EQUAL.
    LR_RENWL_PROF->LOW = FP_P_PROF.
  ENDIF.

  APPEND LR_RENWL_PROF->* TO LIR_RENWL_PROF.

*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
  IF SY-BATCH EQ ABAP_FALSE.
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*   Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*   SELECT mandt   " Client
*          vbeln          " Sales Document
*   End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*   Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
    SELECT ZQTC_RENWL_PLAN~MANDT   " Client
           ZQTC_RENWL_PLAN~VBELN   " Sales Document
*   End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           POSNR          " Item
           ACTIVITY       " E095: Activity
*Begin of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
           MATNR          " Material no
*End of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
           EADAT          " Activity Date
           RENWL_PROF     " Renewal Profile
           PROMO_CODE     " Promo code
           ACT_STATUS     " Activity Status
           REN_STATUS     " Renewal Status
           AENAM          " Name of Person Who Changed Object
*          Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          aedat          " Changed On
*          End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           ZQTC_RENWL_PLAN~AEDAT          " Changed On
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           AEZET          " Time last change was made
           FROM ZQTC_RENWL_PLAN " E095: Renewal Plan Table
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           INNER JOIN VBAK ON VBAK~VBELN EQ ZQTC_RENWL_PLAN~VBELN
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           INTO TABLE LI_RENWL_PLAN
*          Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          WHERE vbeln IN s_vbeln
*          End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           WHERE ZQTC_RENWL_PLAN~VBELN IN S_VBELN
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           AND ACTIVITY IN LIR_ACTIV
           AND RENWL_PROF IN LIR_RENWL_PROF
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           AND EADAT IN S_EADAT
           AND VKORG IN S_VKORG.
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          ORDER BY PRIMARY KEY.
*          End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
  ELSE.
*   Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*   SELECT mandt   " Client
*          vbeln          " Sales Document
*   End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*   Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
    SELECT ZQTC_RENWL_PLAN~MANDT   " Client
           ZQTC_RENWL_PLAN~VBELN   " Sales Document
*   End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           POSNR          " Item
           ACTIVITY       " E095: Activity
*Begin of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
           MATNR          " Material no
*End of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
           EADAT          " Activity Date
           RENWL_PROF     " Renewal Profile
           PROMO_CODE     " Promo code
           ACT_STATUS     " Activity Status
           REN_STATUS     " Renewal Status
           AENAM          " Name of Person Who Changed Object
*          Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          aedat          " Changed On
*          End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           ZQTC_RENWL_PLAN~AEDAT          " Changed On
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           AEZET          " Time last change was made
           FROM ZQTC_RENWL_PLAN " E095: Renewal Plan Table
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           INNER JOIN VBAK ON VBAK~VBELN EQ ZQTC_RENWL_PLAN~VBELN
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           INTO TABLE LI_RENWL_PLAN
*          Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          WHERE vbeln IN s_vbeln
*          End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           WHERE ZQTC_RENWL_PLAN~VBELN IN S_VBELN
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           AND ACTIVITY IN LIR_ACTIV
           AND RENWL_PROF IN LIR_RENWL_PROF
*          Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          AND eadat LE s_eadat-low
*          End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           AND EADAT IN S_EADAT
           AND VKORG IN S_VKORG
*          End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
           AND ACT_STATUS NE ABAP_TRUE.
*          Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*          ORDER BY PRIMARY KEY.
*          End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
  ENDIF.

  IF NOT LI_RENWL_PLAN IS INITIAL.
    "Delete records where activity date ios initial.
    DELETE LI_RENWL_PLAN WHERE EADAT IS INITIAL.
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*   Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
    SORT LI_RENWL_PLAN BY VBELN POSNR ACTIVITY.
*   End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
*Begin of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*  IF sy-subrc = 0.
*End of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
    CREATE DATA LR_FINAL.

    LOOP AT LI_RENWL_PLAN REFERENCE INTO LR_RENWL_PLAN.
      MOVE-CORRESPONDING LR_RENWL_PLAN->* TO LR_FINAL->*.
      APPEND LR_FINAL->* TO FP_I_RENWL_PLAN.
      CLEAR LR_FINAL->*.
    ENDLOOP.

    IF LI_RENWL_PLAN IS NOT INITIAL .
      FP_REWAL_PLAN = LI_RENWL_PLAN.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CATALOG
*&---------------------------------------------------------------------*
*       Populate field catalog
*----------------------------------------------------------------------*
*  <--  fp_i_fca       Field Ctalog
*----------------------------------------------------------------------*
FORM F_POPUL_FIELD_CATALOG CHANGING FP_I_FCAT TYPE SLIS_T_FIELDCAT_ALV.
*   Populate the field catalog
  DATA : LV_COL_POS TYPE SYCUCOL. " Col_pos of type Integers

*Constant for hold for alv tablename
  CONSTANTS: LC_TABNAME        TYPE SLIS_TABNAME VALUE 'I_FINAL', "Tablename for Alv Display
* Constent for hold the alv field catelog
             LC_FLD_VBELN      TYPE SLIS_FIELDNAME VALUE 'VBELN',
             LC_FLD_ACTIVITY   TYPE SLIS_FIELDNAME VALUE 'ACTIVITY',
*Begin of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
             LC_FLD_MATNR      TYPE SLIS_FIELDNAME VALUE 'MATNR',
*End of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
             LC_FLD_POSNR      TYPE SLIS_FIELDNAME VALUE 'POSNR',
             LC_FLD_EADAT      TYPE SLIS_FIELDNAME VALUE 'EADAT',
             LC_FLD_RENWL_PROF TYPE SLIS_FIELDNAME VALUE 'RENWL_PROF',
             LC_FLD_PROMO_CODE TYPE SLIS_FIELDNAME VALUE 'PROMO_CODE',
             LC_FLD_ACT_STATUS TYPE SLIS_FIELDNAME VALUE 'ACT_STATUS',
             LC_FLD_REN_STATUS TYPE SLIS_FIELDNAME VALUE 'REN_STATUS',
             LC_FLD_AEDAT      TYPE SLIS_FIELDNAME VALUE 'AEDAT',
             LC_FLD_AEZET      TYPE SLIS_FIELDNAME VALUE 'AEZET',
             LC_FLD_AENAM      TYPE SLIS_FIELDNAME VALUE 'AENAM',
             LC_FLD_MSG        TYPE SLIS_FIELDNAME VALUE 'MESSAGE'.
  LV_COL_POS         = 0 .
* Populate field catalog

* Invoice Number
  LV_COL_POS = LV_COL_POS + 1.
  PERFORM F_BUILD_FCAT_HOTSPOT USING LC_FLD_VBELN  LC_TABNAME   LV_COL_POS  'Sales Document'(014)
                       CHANGING FP_I_FCAT.
  LV_COL_POS = LV_COL_POS + 1.
  PERFORM F_BUILD_FCAT_HOTSPOT USING LC_FLD_POSNR  LC_TABNAME   LV_COL_POS  'Document Item'(016)
                       CHANGING FP_I_FCAT.
  LV_COL_POS = LV_COL_POS + 1.
  PERFORM F_BUILD_FCAT_HOTSPOT USING LC_FLD_ACTIVITY  LC_TABNAME   LV_COL_POS  'Activity'(015)
                       CHANGING FP_I_FCAT.
*Begin of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
  LV_COL_POS = LV_COL_POS + 1.
  PERFORM F_BUILD_FCAT_HOTSPOT USING LC_FLD_MATNR  LC_TABNAME   LV_COL_POS  'Material No'(026)
                       CHANGING FP_I_FCAT.
*End of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
  LV_COL_POS = LV_COL_POS + 1.
  PERFORM F_BUILD_FCAT_HOTSPOT USING LC_FLD_EADAT  LC_TABNAME   LV_COL_POS  'Activity Date'(017)
                       CHANGING FP_I_FCAT.
  LV_COL_POS = LV_COL_POS + 1.
  PERFORM F_BUILD_FCAT_HOTSPOT USING LC_FLD_RENWL_PROF  LC_TABNAME   LV_COL_POS  'Renewal Profile'(018)
                       CHANGING FP_I_FCAT.
  LV_COL_POS = LV_COL_POS + 1.
  PERFORM F_BUILD_FCAT_HOTSPOT USING LC_FLD_PROMO_CODE  LC_TABNAME   LV_COL_POS  'Promo code'(019)
                       CHANGING FP_I_FCAT.
  LV_COL_POS = LV_COL_POS + 1.
  PERFORM F_BUILD_FCAT_HOTSPOT USING LC_FLD_ACT_STATUS  LC_TABNAME   LV_COL_POS  'Activity Status'(020)
                       CHANGING FP_I_FCAT.
  LV_COL_POS = LV_COL_POS + 1.
  PERFORM F_BUILD_FCAT_HOTSPOT USING LC_FLD_REN_STATUS  LC_TABNAME   LV_COL_POS  'Renewal Status'(021)
                       CHANGING FP_I_FCAT.
  LV_COL_POS = LV_COL_POS + 1.
  PERFORM F_BUILD_FCAT_HOTSPOT USING LC_FLD_AENAM  LC_TABNAME   LV_COL_POS  'Who Changed Object'(022)
                       CHANGING FP_I_FCAT.
  LV_COL_POS = LV_COL_POS + 1.
  PERFORM F_BUILD_FCAT_HOTSPOT USING LC_FLD_AEDAT LC_TABNAME   LV_COL_POS  'Changed On'(023)
                       CHANGING FP_I_FCAT.
  LV_COL_POS = LV_COL_POS + 1.
  PERFORM F_BUILD_FCAT_HOTSPOT USING LC_FLD_AEZET LC_TABNAME   LV_COL_POS  'Time last change was made'(024)
                       CHANGING FP_I_FCAT.
  LV_COL_POS = LV_COL_POS + 1.
  PERFORM F_BUILD_FCAT_HOTSPOT USING LC_FLD_MSG LC_TABNAME   LV_COL_POS  'Message'(025)
                       CHANGING FP_I_FCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*       Display ALV
*----------------------------------------------------------------------*
*      -->FP_I_FCAT  Field catalogiue
*      -->FP_I_FINAL Output table
*----------------------------------------------------------------------*
FORM F_DISPLAY_ALV  USING    FP_I_FCAT TYPE SLIS_T_FIELDCAT_ALV
                             FP_I_FINAL TYPE TT_FINAL.
  CONSTANTS : LC_PF_STATUS   TYPE SLIS_FORMNAME  VALUE 'F_SET_PF_STATUS',
              LC_USER_COMM   TYPE SLIS_FORMNAME  VALUE 'F_USER_COMMAND',
              LC_TOP_OF_PAGE TYPE SLIS_FORMNAME  VALUE 'F_TOP_OF_PAGE',
              LC_BOX_SEL     TYPE SLIS_FIELDNAME VALUE 'SEL'.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      TEXT = 'Displaying Results'(002).

  DATA: LST_LAYOUT   TYPE SLIS_LAYOUT_ALV.

  LST_LAYOUT-COLWIDTH_OPTIMIZE  = ABAP_TRUE.
  LST_LAYOUT-ZEBRA              = ABAP_TRUE.
  LST_LAYOUT-BOX_FIELDNAME      = LC_BOX_SEL.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM       = SY-REPID
      I_CALLBACK_PF_STATUS_SET = LC_PF_STATUS
      I_CALLBACK_USER_COMMAND  = LC_USER_COMM
      I_CALLBACK_TOP_OF_PAGE   = LC_TOP_OF_PAGE
      IS_LAYOUT                = LST_LAYOUT
      IT_FIELDCAT              = FP_I_FCAT
      I_SAVE                   = ABAP_TRUE
    TABLES
      T_OUTTAB                 = FP_I_FINAL
    EXCEPTIONS
      PROGRAM_ERROR            = 1
      OTHERS                   = 2.
  IF SY-SUBRC <> 0.
    MESSAGE I066(ZQTC_R2). " ALV display of table failed
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_set_pf_status
*&---------------------------------------------------------------------*
*       Set the PF Status for ALV
*----------------------------------------------------------------------*
FORM F_SET_PF_STATUS USING LI_EXTAB TYPE SLIS_T_EXTAB.      "#EC CALLED

  DESCRIBE TABLE LI_EXTAB. "Avoid Extended Check Warning
  SET PF-STATUS 'ZSTANDARD'.

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
FORM F_BUILD_FCAT_HOTSPOT USING FP_FIELD    TYPE SLIS_FIELDNAME
                                 FP_TABNAME  TYPE SLIS_TABNAME
                                 FP_COL_POS  TYPE SYCUCOL " Col_pos of type Integers
                                 FP_TEXT     TYPE CHAR50  " Text of type CHAR50
                        CHANGING FP_I_FCAT   TYPE SLIS_T_FIELDCAT_ALV.
  DATA: LST_FCAT   TYPE SLIS_FIELDCAT_ALV.
  CONSTANTS : LC_OUTPUTLEN TYPE OUTPUTLEN  VALUE '30'. " Output Length

  LST_FCAT-LOWERCASE   = ABAP_TRUE.
  LST_FCAT-KEY         = ABAP_TRUE.
  LST_FCAT-OUTPUTLEN   = LC_OUTPUTLEN.
  LST_FCAT-FIELDNAME   = FP_FIELD.
  LST_FCAT-TABNAME     = FP_TABNAME.
  LST_FCAT-COL_POS     = FP_COL_POS.
  LST_FCAT-HOTSPOT     = ABAP_TRUE.
  LST_FCAT-SELTEXT_M   = FP_TEXT.
  APPEND LST_FCAT TO FP_I_FCAT.
  CLEAR LST_FCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM F_TOP_OF_PAGE.
*ALV Header declarations
  DATA: LI_HEADER  TYPE SLIS_T_LISTHEADER,
        LST_HEADER TYPE SLIS_LISTHEADER.

* Constant
  CONSTANTS :     LC_TYP_H TYPE CHAR1 VALUE 'H'. " Typ_h of type CHAR1
* TITLE
  LST_HEADER-TYP = LC_TYP_H . "'H'
  LST_HEADER-INFO = 'Auto Renewal Plan'(w05).
  APPEND LST_HEADER TO LI_HEADER.
  CLEAR LST_HEADER.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = LI_HEADER.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form F_USER_COMMAND
*&---------------------------------------------------------------------*
*      USING fp_ucomm          " ABAP System Field: PAI-Triggering Function Code
*            fp_lst_selfield   .
*----------------------------------------------------------------------*
FORM F_USER_COMMAND USING FP_UCOMM TYPE SYST_UCOMM " ABAP System Field: PAI-Triggering Function Code
                          FP_LST_SELFIELD TYPE SLIS_SELFIELD. "#EC CALLED
  CONSTANTS:              LC_PROCESS TYPE SYST_UCOMM     VALUE '&PROCESS',  " ABAP System Field: PAI-Triggering Function Code
                          LC_RFRESH  TYPE SYST_UCOMM     VALUE '&REFRESH'.

  CASE FP_UCOMM.
    WHEN LC_PROCESS.
      PERFORM F_PROCESS_DATA USING SY-BATCH
                                   I_ITEM
                                   I_BUSINESS
                                   I_PARTNER
                                   I_TEXTHEADERS
                                   I_TEXTLINES
                                   I_HEADER
                                   I_CONTR_DATA
                                   I_CONST
                                   I_NOTIF_P_DET
                                   I_RENWL_PLAN
                                   I_VEDA
                                   I_NAST
                                   I_DOCFLOW
                                   P_TEST
                         CHANGING   I_FINAL.
      FP_LST_SELFIELD-REFRESH = ABAP_TRUE.

    WHEN LC_RFRESH.
      FP_LST_SELFIELD-REFRESH = ABAP_TRUE.
    WHEN OTHERS.
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
FORM F_PROCESS_DATA  USING FP_BATCH         TYPE SYST_BATCH
                           FP_I_ITEM        TYPE TT_ITEM
                           FP_I_BUSINESS    TYPE TT_BUSINESS
                           FP_I_PARTNER     TYPE TT_PARTNER
                           FP_I_TEXTHEADERS TYPE TT_TEXTHEADERS
                           FP_I_TEXTLINES   TYPE TT_TEXTLINES
                           FP_I_HEADER      TYPE TT_HEADER
                           FP_I_CONTRACT    TYPE TT_CONTRACT
                           FP_I_CONST       TYPE TT_CONST
                           FP_I_NOTIF_PROF  TYPE TT_NOTIF_P_DET
                           FP_I_RENWAL      TYPE TT_RENWL_PLAN
                           FP_I_VEDA        TYPE TT_VEDA
                           FP_I_NAST        TYPE TT_NAST
                           FP_I_DOCFLOW     TYPE TT_DOCFLOW
                           FP_P_TEST        TYPE CHAR1
  CHANGING FP_I_FINAL     TYPE TT_FINAL.

  DATA: LR_I_HEADR      TYPE REF TO BAPISDHD,         " BAPI Structure of VBAK with English Field Names
        LR_VEDA         TYPE REF TO TY_VBAK_HEADER,   " contract data reference variable
        LI_RENEWAL_PLAN TYPE TT_RENWL_PLAN,           " Renwal Plan table
        LR_RENEWAL_PLAN TYPE REF TO ZQTC_RENWL_PLAN,  " Reference varibale for Plan table
        LR_FINAL        TYPE REF TO TY_RENWL_PLAN,    " Reference variable for final table
        LR_I_NOTIF_PROF TYPE REF TO TY_NOTIF_P_DET,   " Reference variable for notification determination
        LR_ITEM         TYPE REF TO BAPISDIT,          " Structure of VBAP with English Field Names
        LR_BUSINESS     TYPE REF TO BAPISDBUSI,        " VBKD Structure
        LI_HEADER       TYPE TT_HEADER,                " Internal table for header
        LI_PARTNER      TYPE TT_PARTNER,               " Internal table for partner
        LI_CONTRACT     TYPE TT_CONTRACT,                " BAPI Structure of VEDA with English Field Names
        LR_CONTRACT     TYPE REF TO BAPISDCNTR,          " BAPI Structure of VEDA with English Field Names
        LR_PARTNER      TYPE REF TO BAPISDPART,          " Reference for partner
        LI_TEXTHEADERS  TYPE TT_TEXTHEADERS,             " Text headers
        LR_TEXTHEADERS  TYPE REF TO BAPISDTEHD,          " BAPI Structure of THEAD with English Field Names
        LI_TEXTLINES    TYPE TT_TEXTLINES,               " Text lines
        LR_TEXTLINES    TYPE REF TO BAPITEXTLI,          " Text lines reference
        LR_CONST        TYPE REF TO TY_CONST,            " Reference variable for constant
        LV_ACT_STATUS   TYPE ZACT_STATUS,                " Activity status
        LV_REMINDER     TYPE ZNOTIF_REM,                 " Notification reminder
        LV_DOC_TYPE     TYPE VBAK-AUART,                 " Order type
        LI_ITEM_TEMP    TYPE TT_ITEM,                    " Internal table for item
        LI_HD_TEMP      TYPE TT_HEADER,                  " Internal table for header temorary
        LV_ACTVITY      TYPE CHAR1,                      " flag
        LST_ITEM_TEMP   TYPE LINE OF TT_ITEM,            " Work Area
        LST_HD_TEMP     TYPE LINE OF TT_HEADER,          " Header
        LI_ITEM         TYPE TT_ITEM,                    " Item
        LI_BUSINESS     TYPE TT_BUSINESS,                " VBKD data
        LV_LAPSED       TYPE CHAR1,                      " FLAG lapsed
        LV_FLAG         TYPE CHAR1,
        LR_DOCFLOW      TYPE REF TO BAPISDFLOW,          " BAPI Structure of VBFA
        LI_FINAL        TYPE TT_FINAL.

  CONSTANTS: LC_POSNR_LOW TYPE VBAP-POSNR    VALUE '000000', " To indicate Header
             LC_REMINDER  TYPE CHAR1         VALUE 'R',      " First letter of Reminder activity
             LC_DEVID     TYPE ZDEVID        VALUE 'E096',   " Development ID
             LC_PARAM1    TYPE RVARI_VNAM    VALUE 'GR',     " Parameter1
             LC_PARAM2    TYPE RVARI_VNAM    VALUE 'CS',     " Parameter1
             LC_CS        TYPE ZACTIVITY_SUB VALUE 'CS',     " create Subscription
             LC_GR        TYPE ZACTIVITY_SUB VALUE 'GR',     " create grace Subscription
             LC_CQ        TYPE ZACTIVITY_SUB VALUE 'CQ',     " create Quotation
             LC_CONTRACT  TYPE CHAR1          VALUE 'G',
             LC_QUOTATION TYPE CHAR1         VALUE 'B',
             LC_LP        TYPE ZACTIVITY_SUB VALUE 'LP'.     " Lapse Subscription
  LI_FINAL = I_FINAL.
  IF FP_BATCH = ABAP_FALSE.
* keep those entry which are selected while excuting online  .
    DELETE LI_FINAL WHERE SEL <> ABAP_TRUE.

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
  IF P_CLEAR EQ ABAP_FALSE.
*End of Add-Anirban-07.25.2017-ED2K907327-Defect 3301
    LOOP AT FP_I_HEADER REFERENCE INTO LR_I_HEADR.
      CLEAR LI_PARTNER.
      READ TABLE LI_FINAL
      ASSIGNING FIELD-SYMBOL(<LST_FP_I_FINAL>)
      WITH TABLE KEY PRIMARY_KEY
      COMPONENTS VBELN = LR_I_HEADR->DOC_NUMBER.
      " activity = DU.
      "activity = abap_true.
      IF SY-SUBRC = 0.
*& Populate partner date
        CLEAR LI_PARTNER.
        LOOP AT FP_I_PARTNER REFERENCE INTO LR_PARTNER
        WHERE SD_DOC = LR_I_HEADR->DOC_NUMBER
        AND ITM_NUMBER = LC_POSNR_LOW.

          APPEND LR_PARTNER->* TO LI_PARTNER.
*          CLEAR lr_partner->*.

        ENDLOOP.
*& Populate VBKD data
        CLEAR: LI_BUSINESS. " lr_business.
        READ TABLE FP_I_BUSINESS
        REFERENCE INTO LR_BUSINESS
        WITH KEY SD_DOC = LR_I_HEADR->DOC_NUMBER
                 ITM_NUMBER = LC_POSNR_LOW.
        IF SY-SUBRC = 0.
          APPEND LR_BUSINESS->* TO LI_BUSINESS.
        ENDIF.

*       Begin of ADD:ERP-6508:WROY:06-Feb-2018:ED2K910691
        CLEAR LI_CONTRACT.
        READ TABLE FP_I_CONTRACT
        REFERENCE INTO LR_CONTRACT
        WITH KEY DOC_NUMBER = LR_I_HEADR->DOC_NUMBER
                              ITM_NUMBER = LC_POSNR_LOW.
        IF SY-SUBRC = 0.
          APPEND LR_CONTRACT->* TO LI_CONTRACT.
        ENDIF.
*       End   of ADD:ERP-6508:WROY:06-Feb-2018:ED2K910691

        CLEAR LI_TEXTHEADERS.
        CLEAR LI_TEXTLINES.
        LOOP AT FP_I_TEXTHEADERS REFERENCE INTO LR_TEXTHEADERS WHERE SD_DOC = LR_I_HEADR->DOC_NUMBER.

          LOOP AT FP_I_TEXTLINES  REFERENCE INTO LR_TEXTLINES WHERE TEXT_NAME = LR_TEXTHEADERS->TEXT_NAME.
            APPEND LR_TEXTLINES->* TO LI_TEXTLINES.
          ENDLOOP.

          APPEND LR_TEXTHEADERS->* TO LI_TEXTHEADERS  .
*          CLEAR lr_textheaders->*.
        ENDLOOP.

        CLEAR LI_HEADER.
        APPEND LR_I_HEADR->* TO LI_HEADER.
        CREATE DATA LR_RENEWAL_PLAN.

        CLEAR LR_FINAL.
        LOOP AT LI_FINAL ASSIGNING FIELD-SYMBOL(<LST_FP_I_FINAL_E095>)
        USING KEY ACTIVITY WHERE VBELN = LR_I_HEADR->DOC_NUMBER
                           AND ACTIVITY <> SPACE.
          " AND     activity = space.

          CLEAR LV_ACTVITY.
          LV_ACTVITY = <LST_FP_I_FINAL>-ACT_STATUS.
          LOOP AT FP_I_PARTNER REFERENCE INTO LR_PARTNER WHERE SD_DOC = LR_I_HEADR->DOC_NUMBER
                                                               AND ITM_NUMBER = <LST_FP_I_FINAL_E095>-POSNR.
            APPEND LR_PARTNER->* TO LI_PARTNER.
*            CLEAR lr_partner->*.
          ENDLOOP.
*& Populate Item details.
          CLEAR LI_ITEM.
          CLEAR LR_ITEM.
          READ TABLE FP_I_ITEM
          REFERENCE INTO LR_ITEM
          WITH KEY DOC_NUMBER = LR_I_HEADR->DOC_NUMBER
                   ITM_NUMBER = <LST_FP_I_FINAL_E095>-POSNR.
          IF SY-SUBRC = 0.

            APPEND LR_ITEM->* TO LI_ITEM.
*            CLEAR lr_item->*.

          ENDIF.


          READ TABLE FP_I_BUSINESS
          REFERENCE INTO LR_BUSINESS
          WITH KEY SD_DOC = LR_I_HEADR->DOC_NUMBER
                   ITM_NUMBER = <LST_FP_I_FINAL_E095>-POSNR.
          IF SY-SUBRC = 0.
            APPEND LR_BUSINESS->* TO LI_BUSINESS.
          ENDIF.

*         Begin of DEL:ERP-6508:WROY:06-Feb-2018:ED2K910691
*         CLEAR li_contract.
*         End   of DEL:ERP-6508:WROY:06-Feb-2018:ED2K910691
          READ TABLE FP_I_CONTRACT
          REFERENCE INTO LR_CONTRACT
          WITH KEY DOC_NUMBER = LR_I_HEADR->DOC_NUMBER
                                ITM_NUMBER = <LST_FP_I_FINAL_E095>-POSNR.
          IF SY-SUBRC = 0.
            APPEND LR_CONTRACT->* TO LI_CONTRACT.
*            CLEAR lr_contract->*.
*         Begin of DEL:ERP-6508:WROY:06-Feb-2018:ED2K910691
*         ELSE.
*           READ TABLE fp_i_contract
*           REFERENCE INTO lr_contract
*           WITH KEY doc_number = lr_i_headr->doc_number
*                                 itm_number = lc_posnr_low.
*           IF sy-subrc = 0.
*             APPEND lr_contract->* TO li_contract.
**             CLEAR lr_contract->*.
*           ENDIF.
*         End   of DEL:ERP-6508:WROY:06-Feb-2018:ED2K910691
          ENDIF.
          CLEAR LV_ACT_STATUS.
          LV_ACT_STATUS = <LST_FP_I_FINAL_E095>-ACT_STATUS.
*& Create Subscription Order: Task 1
          IF  <LST_FP_I_FINAL_E095>-ACTIVITY = LC_CS AND
              <LST_FP_I_FINAL_E095>-ACT_STATUS = SPACE.
*Begin of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*            IF  ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat = sy-datum ) OR
*                ( <lst_fp_i_final_e095>-sel = abap_true ).
*End of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*           Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*           IF  ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat LE s_eadat-low ) OR
*           End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*           Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
            IF  ( SY-BATCH = ABAP_TRUE AND <LST_FP_I_FINAL_E095>-EADAT IN S_EADAT ) OR
*           End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
                ( <LST_FP_I_FINAL_E095>-SEL = ABAP_TRUE ).
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887

              PERFORM F_CREATE_SUBSCRIPTION USING LI_HEADER
                                                LI_ITEM
                                                LI_PARTNER
                                                LI_TEXTHEADERS
                                                LI_TEXTLINES
                                                LI_CONTRACT
                                                LI_BUSINESS
                                               FP_I_CONST
                                               FP_P_TEST
                                         CHANGING V_SALES_ORD
                                               <LST_FP_I_FINAL_E095>-ACT_STATUS
                                               <LST_FP_I_FINAL_E095>-MESSAGE
                                               <LST_FP_I_FINAL_E095>-REN_STATUS
                                                I_RETURN.
            ENDIF.
          ENDIF.
*& create quotation: Task 2
          IF  <LST_FP_I_FINAL>-ACTIVITY = LC_CQ AND
             <LST_FP_I_FINAL>-ACT_STATUS = SPACE .

*Begin of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*            IF  ( sy-batch = abap_true AND <lst_fp_i_final>-eadat = sy-datum ) OR
*                ( <lst_fp_i_final>-sel = abap_true ).
*End of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*           Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*           IF  ( sy-batch = abap_true AND <lst_fp_i_final>-eadat LE s_eadat-low ) OR
*           End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*           Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
            IF  ( SY-BATCH = ABAP_TRUE AND <LST_FP_I_FINAL>-EADAT IN S_EADAT ) OR
*           End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
                ( <LST_FP_I_FINAL>-SEL = ABAP_TRUE ).
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887

              PERFORM F_CREATE_QUOATATION USING LI_HEADER
                                                LI_ITEM
                                                LI_BUSINESS
                                                LI_PARTNER
                                                LI_TEXTHEADERS
                                                LI_TEXTLINES
                                                LI_CONTRACT
                                                FP_I_CONST
                                                FP_P_TEST
                                         CHANGING V_SALES_ORD
                                                  <LST_FP_I_FINAL_E095>-ACT_STATUS
                                                 <LST_FP_I_FINAL_E095>-MESSAGE
                                                  I_RETURN.
            ENDIF.

          ENDIF.
*& create GRACE SUBSCRIPTION: Task 3
          IF  <LST_FP_I_FINAL_E095>-ACTIVITY = LC_GR  .
            IF <LST_FP_I_FINAL_E095>-ACT_STATUS = ABAP_FALSE AND <LST_FP_I_FINAL_E095>-REN_STATUS = ABAP_FALSE.

*Begin of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*              IF  ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat = sy-datum ) OR
*                  ( <lst_fp_i_final_e095>-sel = abap_true ).
*End of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*             Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*             IF  ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat LE s_eadat-low ) OR
*             End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*             Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
              IF  ( SY-BATCH = ABAP_TRUE AND <LST_FP_I_FINAL_E095>-EADAT IN S_EADAT ) OR
*             End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
                  ( <LST_FP_I_FINAL_E095>-SEL = ABAP_TRUE ).
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
                PERFORM F_CREATE_GRACE_SUBS USING LI_HEADER
                                                  LI_ITEM
*                                                 Begin of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
                                                  LI_BUSINESS
*                                                 End   of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
                                                  LI_PARTNER
                                                  LI_TEXTHEADERS
                                                  LI_TEXTLINES
                                                  LI_CONTRACT
                                                  FP_I_CONST
                                                  <LST_FP_I_FINAL_E095>-RENWL_PROF
                                           CHANGING V_SALES_ORD
                                                  <LST_FP_I_FINAL_E095>-ACT_STATUS
                                                 <LST_FP_I_FINAL_E095>-MESSAGE
                                                    I_RETURN.


              ENDIF.

            ENDIF.
          ENDIF.
          IF  <LST_FP_I_FINAL_E095>-ACT_STATUS = ABAP_FALSE .
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*           Begin of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*           IF  ( sy-batch = abap_true AND <lst_fp_i_final_e095>-eadat LE s_eadat-low ) OR
*           End   of DEL:ERP-6242:WROY:05-Feb-2018:ED2K910691
*           Begin of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
            IF  ( SY-BATCH = ABAP_TRUE AND <LST_FP_I_FINAL_E095>-EADAT IN S_EADAT ) OR
*           End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
                ( <LST_FP_I_FINAL_E095>-SEL = ABAP_TRUE ).
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
              IF ( <LST_FP_I_FINAL_E095>-ACTIVITY+0(1) = LC_REMINDER ).



                PERFORM F_TRIGGER_OUTPUT_TYPE USING
                                                    FP_I_CONST
                                                    LI_PARTNER
                                                    FP_I_NOTIF_PROF
                                                    FP_I_NAST
                                          CHANGING          <LST_FP_I_FINAL_E095>.

              ELSE.
                CLEAR LV_REMINDER.
                LV_REMINDER = <LST_FP_I_FINAL_E095>-ACTIVITY.
                READ TABLE FP_I_NOTIF_PROF REFERENCE INTO LR_I_NOTIF_PROF
                 WITH KEY RENWL_PROF = <LST_FP_I_FINAL_E095>-RENWL_PROF
                          NOTIF_REM = LV_REMINDER.
                IF SY-SUBRC = 0.
                  PERFORM F_TRIGGER_OUTPUT_TYPE USING
                                                      FP_I_CONST
                                                      LI_PARTNER
                                                      FP_I_NOTIF_PROF
                                                      FP_I_NAST
                                            CHANGING  <LST_FP_I_FINAL_E095>.
                ENDIF.
              ENDIF.
*Begin of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
            ENDIF.
*End of Del-Anirban-06.26.2017-ED2K906915-Defect 2887
          ENDIF.
*& lAPSE subscription
          CLEAR: LV_FLAG,
                 LV_LAPSED.
          LV_FLAG = ABAP_TRUE.
          IF ( <LST_FP_I_FINAL_E095>-ACTIVITY = LC_LP ) AND
            <LST_FP_I_FINAL_E095>-ACT_STATUS = ABAP_FALSE.
*           Begin of DEL:CR# 546:WROY:03-JUN-2017:ED2K906489
*           PERFORM f_lapase_order USING li_item
*                                        li_header
*                                        lv_flag
*                                  CHANGING <lst_fp_i_final_e095>
*                                           i_return
*                                           lv_lapsed.
*           End   of DEL:CR# 546:WROY:03-JUN-2017:ED2K906489
*           Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
            LV_LAPSED = ABAP_TRUE.
*           End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
            IF LV_LAPSED = ABAP_TRUE..
*& Also Lapse the Quotation created
              LOOP AT FP_I_DOCFLOW REFERENCE INTO LR_DOCFLOW WHERE PRECSDDOC = <LST_FP_I_FINAL_E095>-VBELN AND
                                                                   PREDITDOC = <LST_FP_I_FINAL_E095>-POSNR AND
                                                                   DOCCATEGOR = LC_QUOTATION.
                PERFORM F_LAPSE_QUOTATION USING LR_DOCFLOW->SUBSSDDOC
                                          CHANGING <LST_FP_I_FINAL_E095>-MESSAGE
*Begin of Add-Anirban-07.25.2017-ED2K907327-Defect 3479
                                                   <LST_FP_I_FINAL_E095>-ACT_STATUS
*End of Add-Anirban-07.25.2017-ED2K907327-Defect 3479
                                                  I_RETURN.

              ENDLOOP.
            ENDIF.


*& cancellation procedure for grace subscription
*& If renewal status is checked and grace subscription exist
*& and current date is more than the grace subscription expiry date
            IF LV_LAPSED = ABAP_TRUE.
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
              READ TABLE FP_I_CONST
              REFERENCE INTO LR_CONST WITH KEY DEVID  = LC_DEVID
                                               PARAM1 = LC_PARAM2.
              IF SY-SUBRC = 0.
                LV_DOC_TYPE = LR_CONST->LOW. " 'ZREW'.
                READ TABLE FP_I_FINAL
                REFERENCE INTO DATA(LR_I_FINAL)
                WITH TABLE KEY VBELN_KEY
                COMPONENTS VBELN = <LST_FP_I_FINAL_E095>-VBELN
                           POSNR = <LST_FP_I_FINAL_E095>-POSNR
                           ACTIVITY = LC_CS.
                IF SY-SUBRC = 0 .
                  IF LR_I_FINAL->ACT_STATUS = ABAP_TRUE.
                    CLEAR: LST_HD_TEMP,
                           LST_ITEM_TEMP,
                            LI_HD_TEMP,
                           LI_ITEM_TEMP.
* Populate Contract items and header
                    LOOP AT FP_I_VEDA REFERENCE INTO LR_VEDA WHERE VBELV = <LST_FP_I_FINAL_E095>-VBELN
                                                                  AND       AUART = LV_DOC_TYPE.

                      IF LR_VEDA->VENDDAT GT SY-DATUM AND LR_VEDA->POSNN = LC_POSNR_LOW .
*                      IF lr_veda->posnn = lc_posnr_low.
                        LST_HD_TEMP-DOC_NUMBER =   LR_VEDA->VBELN.
                        APPEND LST_HD_TEMP TO LI_HD_TEMP.
                      ELSEIF LR_VEDA->POSNN <> LC_POSNR_LOW.
                        LST_ITEM_TEMP-DOC_NUMBER = LR_VEDA->VBELN.
                        LST_ITEM_TEMP-ITM_NUMBER = LR_VEDA->POSNN.
                        APPEND LST_ITEM_TEMP TO  LI_ITEM_TEMP.
                        CLEAR LST_ITEM_TEMP.
                      ENDIF.


*                    ENDIF.
                    ENDLOOP.
*& Lapse a renwal  Subscription
                    CLEAR LV_FLAG.
                    PERFORM F_LAPASE_ORDER USING LI_ITEM_TEMP
                                                 LI_HD_TEMP
                                                 LV_FLAG
                                           CHANGING <LST_FP_I_FINAL_E095>
                                                    I_RETURN
                                                    LV_LAPSED.


                  ENDIF.

                ENDIF.

              ENDIF.
            ENDIF.
          ENDIF.
*& If any activity successfully performed up date the custom table
          IF ( <LST_FP_I_FINAL_E095>-ACT_STATUS = ABAP_TRUE ) AND
             ( LV_ACT_STATUS <> <LST_FP_I_FINAL_E095>-ACT_STATUS ).
            MOVE: <LST_FP_I_FINAL_E095>-VBELN TO LR_RENEWAL_PLAN->VBELN,
                  <LST_FP_I_FINAL_E095>-POSNR TO LR_RENEWAL_PLAN->POSNR,
                  <LST_FP_I_FINAL_E095>-RENWL_PROF TO LR_RENEWAL_PLAN->RENWL_PROF,
                  <LST_FP_I_FINAL_E095>-ACTIVITY TO LR_RENEWAL_PLAN->ACTIVITY,
*Begin of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
                  <LST_FP_I_FINAL_E095>-MATNR TO LR_RENEWAL_PLAN->MATNR,
*End of Add-Anirban-09.21.2017-ED2K908670-Defect 4122
                  <LST_FP_I_FINAL_E095>-ACT_STATUS TO LR_RENEWAL_PLAN->ACT_STATUS,
                  <LST_FP_I_FINAL_E095>-PROMO_CODE TO LR_RENEWAL_PLAN->PROMO_CODE,
                  <LST_FP_I_FINAL_E095>-EADAT TO LR_RENEWAL_PLAN->EADAT,
                  <LST_FP_I_FINAL_E095>-REN_STATUS TO LR_RENEWAL_PLAN->REN_STATUS.
            <LST_FP_I_FINAL_E095>-AEDAT = LR_RENEWAL_PLAN->AEDAT = SY-DATUM.
            <LST_FP_I_FINAL_E095>-AEZET =  LR_RENEWAL_PLAN->AEZET = SY-UZEIT.
            <LST_FP_I_FINAL_E095>-AENAM = LR_RENEWAL_PLAN->AENAM = SY-UNAME.
            APPEND LR_RENEWAL_PLAN->* TO LI_RENEWAL_PLAN.
            CLEAR  LR_RENEWAL_PLAN->*.
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
            COMMIT WORK AND WAIT.
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
          ELSEIF LV_ACT_STATUS    = ABAP_TRUE.
            CONCATENATE 'Activity already Preformed'(x01) <LST_FP_I_FINAL_E095>-MESSAGE INTO <LST_FP_I_FINAL_E095>-MESSAGE.
          ENDIF.
*Begin of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
*& Update ACTIVITY status and message
          READ TABLE FP_I_FINAL ASSIGNING FIELD-SYMBOL(<LST_I_FINAL>) WITH TABLE KEY  VBELN_KEY COMPONENTS VBELN = <LST_FP_I_FINAL_E095>-VBELN
                                                                                                 POSNR = <LST_FP_I_FINAL_E095>-POSNR
                                                                                                 ACTIVITY = <LST_FP_I_FINAL_E095>-ACTIVITY.
          IF SY-SUBRC = 0.

            MOVE: <LST_FP_I_FINAL_E095>-MESSAGE TO <LST_I_FINAL>-MESSAGE,
                  <LST_FP_I_FINAL_E095>-ACT_STATUS TO <LST_I_FINAL>-ACT_STATUS,
                  <LST_FP_I_FINAL_E095>-AEDAT TO <LST_I_FINAL>-AEDAT,
                  <LST_FP_I_FINAL_E095>-AENAM TO <LST_I_FINAL>-AENAM,
                  <LST_FP_I_FINAL_E095>-AEZET TO <LST_I_FINAL>-AEZET.
          ENDIF.
*End of Add-Anirban-06.26.2017-ED2K906915-Defect 2887
        ENDLOOP.
      ENDIF.
    ENDLOOP.

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

  ELSEIF P_CLEAR = ABAP_TRUE AND FP_P_TEST IS INITIAL.
* Delete entry
    PERFORM F_DELETE_ENTRY USING FP_I_RENWAL
                           CHANGING FP_I_FINAL.
  ENDIF.

**Begin of Add-Anirban-07.20.2017-ED2K907327-Defect 3301
*  ELSEIF p_status = abap_true AND fp_p_test IS INITIAL.
** Remove status
*    PERFORM f_change_status USING fp_i_renwal
*                           CHANGING fp_i_final.
*
*  ENDIF.
**End of Add-Anirban-07.20.2017-ED2K907327-Defect 3301

*&      om table to reflect the data changes
  IF LI_RENEWAL_PLAN IS NOT INITIAL AND FP_P_TEST IS INITIAL.
    CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL'
      TABLES
        T_RENWL_PLAN = LI_RENEWAL_PLAN.
    COMMIT WORK AND WAIT.
  ENDIF.
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
FORM F_CREATE_SUBSCRIPTION  USING    FP_I_HEADER TYPE TT_HEADER
                                   FP_I_ITEM TYPE TT_ITEM
                                   FP_I_PARTNER TYPE TT_PARTNER
                                   FP_I_TEXTHEADERS TYPE TT_TEXTHEADERS
                                   FP_I_TEXTLINES TYPE TT_TEXTLINES
                                   FP_I_CONTRACT TYPE TT_CONTRACT
                                   FP_I_BUSINESS TYPE TT_BUSINESS
                                   FP_CONST TYPE TT_CONST
                                   FP_TEST TYPE CHAR1
                           CHANGING FP_V_SALESORD TYPE BAPIVBELN-VBELN
                                    FP_V_ACT_STATUS   TYPE ZACT_STATUS
                                    FP_MESSAGE TYPE CHAR120
                                    FP_RENWAL TYPE  ZREN_STATUS
                                    FP_I_RETURN TYPE  TT_RETURN.

  DATA: LR_HEADER             TYPE REF TO BAPISDHD1,  " Communication Fields: Sales and Distribution Document Header
        LR_CONST              TYPE REF TO TY_CONST,   " Type for Constant
        LR_I_PARTNER          TYPE REF TO BAPISDPART, " Partner
        LR_I_HEADER           TYPE REF TO  BAPISDHD,  " Header
        LI_PARTNER            TYPE STANDARD TABLE OF BAPIPARNR INITIAL SIZE 0, " Communications Fields: SD Document Partner: WWW
        LI_RETURN             TYPE STANDARD TABLE OF BAPIRET2 INITIAL SIZE 0,  " BAPI Return
        LR_PARTNER            TYPE REF TO BAPIPARNR,                           " Reference variable
        LI_ITEM               TYPE STANDARD TABLE OF BAPISDITM INITIAL SIZE 0,
        LR_ITEM               TYPE REF TO BAPISDITM,
        LI_ITEMX              TYPE STANDARD TABLE OF BAPISDITMX INITIAL SIZE 0,
        LR_I_BUSINESS         TYPE REF TO BAPISDBUSI,
        LR_SALES_CONTRACT_IN  TYPE  REF TO BAPICTR ,                     " contract data
        LI_SALES_CONTRACT_IN  TYPE STANDARD TABLE OF BAPICTR ,           " Internal  table for cond
        LR_SALES_CONTRACT_INX TYPE REF TO  BAPICTRX ,                    " Communication fields: SD Contract Data Checkbox
        LI_SALES_CONTRACT_INX TYPE  STANDARD TABLE OF BAPICTRX INITIAL SIZE 0 ,         " Communication fields: SD Contract Data Checkbox
        LR_CONTRACT           TYPE REF TO BAPISDCNTR, " BAPI Structure of VEDA with English Field Names
        LR_RETURN             TYPE REF TO BAPIRET2,   " BAPI Structure of VEDA with English Field Names
        LR_ITEMX              TYPE REF TO BAPISDITMX, " Communication Fields: Sales and Distribution Document Item
        LR_I_ITEM             TYPE REF TO BAPISDIT,   " Structure of VBAP with English Field Names
        LR_HEADERX            TYPE REF TO BAPISDHD1X, " Checkbox Fields for Sales and Distribution Document Header
        LV_DAYS               TYPE T5A4A-DLYDY,       " Days
        LV_YEAR               TYPE T5A4A-DLYYR.       " Year
  CONSTANTS:
    LC_CONTRACT  TYPE VBTYP VALUE 'G',               " Contract
    LC_ERROR     TYPE BAPIRET2-TYPE VALUE 'E',       " Error
    LC_INSERT    TYPE UPDKZ_D VALUE 'I',             " Insert
    LC_DAYS      TYPE T5A4A-DLYDY VALUE '00',        " Days
    LC_MONTH     TYPE T5A4A-DLYMO  VALUE '00',       " Month
    LC_YEAR      TYPE T5A4A-DLYYR  VALUE '00',       " Year
    LC_DEVID     TYPE ZDEVID VALUE 'E096',           "Development ID
    LC_PARAM1    TYPE RVARI_VNAM VALUE 'CS',         "Parameter1
*Begin of Add-Anirban-09.29.2017-ED2K908670-Defect 4718
    LC_POSNR_LOW TYPE VBAP-POSNR    VALUE '000000'.
*End of Add-Anirban-09.29.2017-ED2K908670-Defect 4718

  CREATE DATA: LR_HEADER,
               LR_HEADERX,
               LR_PARTNER,
               LR_I_PARTNER,
               LR_ITEM,
               LR_ITEMX,
               LR_SALES_CONTRACT_IN,
               LR_SALES_CONTRACT_INX.
  READ TABLE FP_I_HEADER REFERENCE INTO LR_I_HEADER INDEX 1.
  IF SY-SUBRC = 0.


    LR_HEADER->SD_DOC_CAT = LC_CONTRACT.
    READ TABLE FP_CONST REFERENCE INTO LR_CONST WITH KEY DEVID  = LC_DEVID
                                                         PARAM1 = LC_PARAM1.
    IF SY-SUBRC = 0.
      LR_HEADER->DOC_TYPE = LR_CONST->LOW. " 'ZREW'.
    ENDIF.

    LR_HEADER->SALES_ORG = LR_I_HEADER->SALES_ORG.
    LR_HEADER->DISTR_CHAN = LR_I_HEADER->DISTR_CHAN.
    LR_HEADER->DIVISION = LR_I_HEADER->DIVISION.
*   Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
    LR_HEADER->SALES_OFF = LR_I_HEADER->SALES_OFF.
    LR_HEADER->PO_METHOD = LR_I_HEADER->PO_METHOD.
*   End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
    LR_HEADER->REF_DOC = LR_I_HEADER->DOC_NUMBER. "low.
    LR_HEADER->REF_DOC_L = LR_I_HEADER->DOC_NUMBER.
    LR_HEADER->REFDOC_CAT = LC_CONTRACT. "'G'.
    LR_HEADER->REFDOCTYPE = LC_CONTRACT. "'G'.
    LR_HEADER->REF_1 = LR_I_HEADER->DOC_NUMBER.
*   Begin of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    LR_HEADER->CURRENCY = LR_I_HEADER->CURRENCY.
*   End   of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    LR_HEADERX->REFDOC_CAT = ABAP_TRUE.
    LR_HEADERX->DOC_TYPE = ABAP_TRUE.
    LR_HEADERX->SALES_ORG = ABAP_TRUE.
    LR_HEADERX->DISTR_CHAN = ABAP_TRUE.
    LR_HEADERX->DIVISION = ABAP_TRUE.
*   Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
    LR_HEADERX->SALES_OFF = ABAP_TRUE.
    LR_HEADERX->PO_METHOD = ABAP_TRUE.
*   End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
    LR_HEADERX->REF_DOC = ABAP_TRUE.
    LR_HEADERX->REF_1 = ABAP_TRUE.
*   Begin of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    LR_HEADERX->CURRENCY = ABAP_TRUE.
*   End   of ADD:ERP-5717:WROY:08-Jan-2018:ED2K910161
    LR_HEADERX->UPDATEFLAG = LC_INSERT.

*   Begin of ADD:ERP-5850:WROY:10-Jan-2018:ED2K910239
    READ TABLE FP_I_BUSINESS REFERENCE INTO LR_I_BUSINESS WITH KEY SD_DOC     = LR_I_HEADER->DOC_NUMBER
                                                                   ITM_NUMBER = LC_POSNR_LOW.
    IF SY-SUBRC EQ 0.
      LR_HEADER->PURCH_NO_C	 = LR_I_BUSINESS->PURCH_NO_C. "Customer purchase order number
      LR_HEADERX->PURCH_NO_C = ABAP_TRUE.                 "Customer purchase order number
    ENDIF.
*   End   of ADD:ERP-5850:WROY:10-Jan-2018:ED2K910239
*   Begin of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
    READ TABLE FP_I_CONTRACT REFERENCE INTO LR_CONTRACT WITH KEY DOC_NUMBER = LR_I_HEADER->DOC_NUMBER
                                                                 ITM_NUMBER = LC_POSNR_LOW.
    IF SY-SUBRC = 0.
      LR_SALES_CONTRACT_IN->ITM_NUMBER  = LC_POSNR_LOW.
      LR_SALES_CONTRACT_INX->ITM_NUMBER = LC_POSNR_LOW.
      LR_SALES_CONTRACT_INX->UPDATEFLAG = LC_INSERT.
      LR_SALES_CONTRACT_IN->CON_EN_ACT  = LR_CONTRACT->CONTENDACT. "Action at end of contract
      LR_SALES_CONTRACT_INX->CON_EN_ACT = ABAP_TRUE.               "Action at end of contract

      CLEAR LV_YEAR.
      MOVE 1 TO LV_YEAR.
      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
        EXPORTING
          DATE      = LR_CONTRACT->ACTIONDATE                      "Date for action
          DAYS      = LC_DAYS
          MONTHS    = LC_MONTH
          YEARS     = LV_YEAR
        IMPORTING
          CALC_DATE = LR_SALES_CONTRACT_IN->ACTION_DAT.            "Date for action
      LR_SALES_CONTRACT_INX->ACTION_DAT = ABAP_TRUE.
      APPEND LR_SALES_CONTRACT_IN->* TO LI_SALES_CONTRACT_IN.
      CLEAR LR_SALES_CONTRACT_IN->*.
      APPEND LR_SALES_CONTRACT_INX->* TO LI_SALES_CONTRACT_INX.
      CLEAR LR_SALES_CONTRACT_INX->*.
    ENDIF.
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

    LOOP AT FP_I_PARTNER REFERENCE INTO LR_I_PARTNER WHERE CUSTOMER IS NOT INITIAL.
      LR_PARTNER->PARTN_ROLE = LR_I_PARTNER->PARTN_ROLE.
      LR_PARTNER->PARTN_NUMB = LR_I_PARTNER->CUSTOMER.
      LR_PARTNER->ITM_NUMBER = LR_I_PARTNER->ITM_NUMBER.
      APPEND LR_PARTNER->* TO LI_PARTNER.
      CLEAR LR_PARTNER->*.
    ENDLOOP.
    LOOP AT FP_I_ITEM REFERENCE INTO LR_I_ITEM.
      LR_ITEM->ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
      LR_ITEMX->ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
      LR_ITEM->ITEM_CATEG =  LR_I_ITEM->ITEM_CATEG.
* Customer purchase order type
      READ TABLE FP_I_BUSINESS REFERENCE INTO LR_I_BUSINESS WITH KEY ITM_NUMBER =    LR_I_ITEM->ITM_NUMBER.
      IF SY-SUBRC = 0.
        LR_HEADER->PYMT_METH = LR_I_BUSINESS->PAYMETHODE.
        LR_HEADERX->PYMT_METH = ABAP_TRUE.
        LR_ITEM->PO_METHOD = LR_I_BUSINESS->PO_METHOD.
        LR_ITEMX->PO_METHOD = ABAP_TRUE.
        LR_ITEM->REF_1 = LR_I_BUSINESS->REF_1.
        LR_ITEMX->REF_1 = ABAP_TRUE.
*       Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
        LR_ITEM->CUST_GROUP  = LR_I_BUSINESS->CUST_GROUP. "Customer Group
        LR_ITEMX->CUST_GROUP = ABAP_TRUE.                 "Customer Group
        LR_ITEM->PRICE_GRP   = LR_I_BUSINESS->PRICE_GRP.  "Price Group (Customer)
        LR_ITEMX->PRICE_GRP  = ABAP_TRUE.                 "Price Group (Customer)
*       End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
      ELSE.
        READ TABLE FP_I_BUSINESS REFERENCE INTO LR_I_BUSINESS WITH KEY ITM_NUMBER = '0000'.
        IF SY-SUBRC = 0.
          LR_HEADER->PYMT_METH = LR_I_BUSINESS->PAYMETHODE.
          LR_HEADERX->PYMT_METH = ABAP_TRUE.
          LR_ITEM->PO_METHOD = LR_I_BUSINESS->PO_METHOD.
          LR_ITEMX->PO_METHOD = ABAP_TRUE.
          LR_ITEM->REF_1 = LR_I_BUSINESS->REF_1.
          LR_ITEMX->REF_1 = ABAP_TRUE.
*         Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
          LR_ITEM->CUST_GROUP  = LR_I_BUSINESS->CUST_GROUP. "Customer Group
          LR_ITEMX->CUST_GROUP = ABAP_TRUE.                 "Customer Group
          LR_ITEM->PRICE_GRP   = LR_I_BUSINESS->PRICE_GRP.  "Price Group (Customer)
          LR_ITEMX->PRICE_GRP  = ABAP_TRUE.                 "Price Group (Customer)
*         End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
        ENDIF.
      ENDIF.

      READ TABLE FP_I_CONTRACT REFERENCE INTO LR_CONTRACT WITH KEY DOC_NUMBER = LR_I_ITEM->DOC_NUMBER
                                                                    ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
      IF SY-SUBRC = 0.
        LR_SALES_CONTRACT_IN->ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
        LR_SALES_CONTRACT_INX->ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
        LR_SALES_CONTRACT_INX->UPDATEFLAG = LC_INSERT.
        LR_SALES_CONTRACT_IN->CON_ST_DAT = LR_CONTRACT->CONTENDDAT.
        CLEAR LV_DAYS.
        MOVE 1 TO LV_DAYS.
        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            DATE      = LR_SALES_CONTRACT_IN->CON_ST_DAT
            DAYS      = LV_DAYS
            MONTHS    = LC_MONTH
            YEARS     = LC_YEAR
          IMPORTING
            CALC_DATE = LR_SALES_CONTRACT_IN->CON_ST_DAT.

        LR_SALES_CONTRACT_INX->CON_ST_DAT = ABAP_TRUE.

        LR_HEADER->PRICE_DATE = LR_SALES_CONTRACT_IN->CON_ST_DAT.
*Begin of Add-Anirban-07.26.2017-ED2K907606-Defect 3335
        LR_HEADERX->PRICE_DATE = ABAP_TRUE.
        LR_HEADERX->SD_DOC_CAT = ABAP_TRUE.
        LR_HEADERX->REF_DOC_L = ABAP_TRUE.
*End of Add-Anirban-07.26.2017-ED2K907606-Defect 3335

        CLEAR LV_YEAR.
        MOVE 1 TO LV_YEAR.
        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            DATE      = LR_SALES_CONTRACT_IN->CON_ST_DAT
            DAYS      = LC_DAYS
            MONTHS    = LC_MONTH
            YEARS     = LV_YEAR
          IMPORTING
            CALC_DATE = LR_SALES_CONTRACT_IN->CON_EN_DAT.
        LR_SALES_CONTRACT_IN->CON_EN_DAT = LR_SALES_CONTRACT_IN->CON_EN_DAT - 1.
        LR_SALES_CONTRACT_INX->CON_EN_DAT = ABAP_TRUE.
        APPEND LR_SALES_CONTRACT_IN->* TO LI_SALES_CONTRACT_IN.
        CLEAR LR_SALES_CONTRACT_IN->*.
        APPEND LR_SALES_CONTRACT_INX->* TO LI_SALES_CONTRACT_INX.
        CLEAR LR_SALES_CONTRACT_INX->*.

*Begin of Del-Anirban-09.29.2017-ED2K908670-Defect 4718
*      ENDIF.
*End of Del-Anirban-09.29.2017-ED2K908670-Defect 4718

*Begin of Add-Anirban-09.29.2017-ED2K908670-Defect 4718
      ELSE.
        READ TABLE FP_I_CONTRACT REFERENCE INTO LR_CONTRACT WITH KEY DOC_NUMBER = LR_I_ITEM->DOC_NUMBER
                                                                             ITM_NUMBER = LC_POSNR_LOW.
        IF SY-SUBRC = 0.
*         Begin of DEL:ERP-6283:WROY:31-Jan-2018:ED2K910611
*         lr_sales_contract_in->itm_number = lc_posnr_low.
*         lr_sales_contract_inx->itm_number = lc_posnr_low.
*         End   of DEL:ERP-6283:WROY:31-Jan-2018:ED2K910611
*         Begin of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
          LR_SALES_CONTRACT_IN->ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
          LR_SALES_CONTRACT_INX->ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
*         End   of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
          LR_SALES_CONTRACT_INX->UPDATEFLAG = LC_INSERT.
          LR_SALES_CONTRACT_IN->CON_ST_DAT = LR_CONTRACT->CONTENDDAT.
          CLEAR LV_DAYS.
          MOVE 1 TO LV_DAYS.
          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              DATE      = LR_SALES_CONTRACT_IN->CON_ST_DAT
              DAYS      = LV_DAYS
              MONTHS    = LC_MONTH
              YEARS     = LC_YEAR
            IMPORTING
              CALC_DATE = LR_SALES_CONTRACT_IN->CON_ST_DAT.

          LR_SALES_CONTRACT_INX->CON_ST_DAT = ABAP_TRUE.

          LR_HEADER->PRICE_DATE = LR_SALES_CONTRACT_IN->CON_ST_DAT.
          LR_HEADERX->PRICE_DATE = ABAP_TRUE.
          LR_HEADERX->SD_DOC_CAT = ABAP_TRUE.
          LR_HEADERX->REF_DOC_L = ABAP_TRUE.

          CLEAR LV_YEAR.
          MOVE 1 TO LV_YEAR.
          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              DATE      = LR_SALES_CONTRACT_IN->CON_ST_DAT
              DAYS      = LC_DAYS
              MONTHS    = LC_MONTH
              YEARS     = LV_YEAR
            IMPORTING
              CALC_DATE = LR_SALES_CONTRACT_IN->CON_EN_DAT.
          LR_SALES_CONTRACT_IN->CON_EN_DAT = LR_SALES_CONTRACT_IN->CON_EN_DAT - 1.
          LR_SALES_CONTRACT_INX->CON_EN_DAT = ABAP_TRUE.
          APPEND LR_SALES_CONTRACT_IN->* TO LI_SALES_CONTRACT_IN.
          CLEAR LR_SALES_CONTRACT_IN->*.
          APPEND LR_SALES_CONTRACT_INX->* TO LI_SALES_CONTRACT_INX.
          CLEAR LR_SALES_CONTRACT_INX->*.
        ENDIF.
      ENDIF.
*End of Add-Anirban-09.29.2017-ED2K908670-Defect 4718

      LR_ITEMX->UPDATEFLAG = LC_INSERT.
      LR_ITEM->MATERIAL =  LR_I_ITEM->MATERIAL.
      LR_ITEMX->MATERIAL = ABAP_TRUE.
      LR_ITEM->TARGET_QTY =  LR_I_ITEM->TARGET_QTY .
      LR_ITEM->TARGET_QU = LR_I_ITEM->TARGET_QU.
      LR_ITEM->PLANT = LR_I_ITEM->PLANT.
      LR_ITEMX->TARGET_QTY = ABAP_TRUE.
      IF NOT LR_I_ITEM->REF_DOC IS INITIAL.
        LR_ITEM->REF_DOC  =   LR_I_ITEM->REF_DOC.
        LR_ITEMX->REF_DOC = ABAP_TRUE.
      ENDIF.
      IF NOT LR_I_ITEM->POSNR_VOR IS INITIAL.
        LR_ITEM->REF_DOC_IT = LR_I_ITEM->POSNR_VOR.
        LR_ITEMX->REF_DOC_IT = ABAP_TRUE.
      ENDIF.
      IF LR_I_ITEM->DOC_CAT_SD IS NOT INITIAL.
        LR_ITEM->REF_DOC_CA = LR_I_ITEM->DOC_CAT_SD.
        LR_ITEMX->REF_DOC_CA = ABAP_TRUE.
      ENDIF.
      LR_ITEM->REF_DOC = LR_HEADER->REF_DOC.
      LR_ITEM->REF_DOC_IT = LR_I_ITEM->ITM_NUMBER.
      LR_ITEM->REF_DOC_CA = LC_CONTRACT.

      APPEND LR_ITEM->* TO LI_ITEM.
      CLEAR LR_ITEM->*.
      APPEND LR_ITEMX->* TO LI_ITEMX.
      CLEAR LR_ITEMX->*.
    ENDLOOP.

    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        SALES_HEADER_IN       = LR_HEADER->*
        SALES_HEADER_INX      = LR_HEADERX->*
        INT_NUMBER_ASSIGNMENT = ABAP_TRUE
        TESTRUN               = FP_TEST
      IMPORTING
        SALESDOCUMENT_EX      = FP_V_SALESORD
      TABLES
        RETURN                = LI_RETURN
        SALES_ITEMS_IN        = LI_ITEM
        SALES_ITEMS_INX       = LI_ITEMX
        SALES_PARTNERS        = LI_PARTNER
        SALES_CONTRACT_IN     = LI_SALES_CONTRACT_IN
        SALES_CONTRACT_INX    = LI_SALES_CONTRACT_INX
        TEXTHEADERS_EX        = FP_I_TEXTHEADERS
        TEXTLINES_EX          = FP_I_TEXTLINES.
    READ TABLE LI_RETURN REFERENCE INTO LR_RETURN WITH KEY TYPE = LC_ERROR.
    IF SY-SUBRC <> 0.
      IF FP_TEST = SPACE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            WAIT = ABAP_TRUE.
        FP_V_ACT_STATUS = ABAP_TRUE.
        FP_RENWAL = ABAP_TRUE.
        CONCATENATE 'Renewal Subscription'(a07) FP_V_SALESORD TEXT-A08 INTO
        FP_MESSAGE SEPARATED BY SPACE.

      ELSE.
        "CONCATENATE 'Renewal Subscription can be applied'(x13) fp_v_salesord text-a08 INTO
        "fp_message.
        CONCATENATE 'Renewal Subscription can be generated'(x13) ' ' INTO
        FP_MESSAGE.
      ENDIF.

    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      APPEND LINES OF LI_RETURN TO FP_I_RETURN.
      MOVE 'Renewal Subscription failed with error'(a09) TO FP_MESSAGE.
    ENDIF.
  ENDIF.

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
FORM F_CREATE_GRACE_SUBS  USING    FP_I_HEADER TYPE TT_HEADER
                                   FP_I_ITEM TYPE TT_ITEM
*                                  Begin of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
                                   FP_I_BUSINESS TYPE TT_BUSINESS
*                                  End   of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
                                   FP_I_PARTNER TYPE TT_PARTNER
                                   FP_I_TEXTHEADERS TYPE TT_TEXTHEADERS
                                   FP_I_TEXTLINES TYPE TT_TEXTLINES
                                   FP_I_CONTRACT TYPE TT_CONTRACT
                                   FP_CONST TYPE TT_CONST
                                   FP_RENWL_PROF TYPE ZRENWL_PROF
                           CHANGING FP_V_SALESORD TYPE BAPIVBELN-VBELN
                                    FP_V_ACT_STATUS   TYPE ZACT_STATUS

                                    FP_MESSAGE TYPE CHAR120
                                    FP_I_RETURN TYPE  TT_RETURN.
  TYPES:
*   Begin of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910272
    BEGIN OF LTY_TVCPA,
      AUARN TYPE AUART_NACH,           " Copying control: Target sales document type
      AUARV TYPE AUART_VON,            " Copying control: Reference document type
      PSTYV TYPE PSTYV_VON,            " Reference item category
      PSTYN TYPE PSTYV_NACH,           " Default item category
    END OF LTY_TVCPA,
    LTT_TVCPA TYPE STANDARD TABLE OF LTY_TVCPA INITIAL SIZE 0,
*   End   of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910272
    BEGIN OF LTY_RENWL_P_DET,
      RENWL_PROF   TYPE ZRENWL_PROF,   " Renewal Profile
      QUOTE_TIME   TYPE ZQUOTE_TIM,    " Quote Timing
      NOTIF_PROF   TYPE ZNOTIF_PROF,   " Notification Profile
      GRACE_START  TYPE ZGRACE_START,  " Grace Start Timing
      GRACE_PERIOD TYPE ZGRACE_PERIOD, " Grace Period
      AUTO_RENEW   TYPE ZAUTO_RENEW,   " Auto Renew Timing
      LAPSE        TYPE ZLAPSE,        " Lapse
    END OF   LTY_RENWL_P_DET,
    LTT_RENWL_P_DET TYPE STANDARD TABLE OF LTY_RENWL_P_DET
         INITIAL SIZE 0.
* Begin of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910272
  STATICS: LI_TVCPA TYPE LTT_TVCPA.
* End   of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910272
  DATA   LI_RENWL_PLAN TYPE LTT_RENWL_P_DET.
  DATA: LR_HEADER             TYPE REF TO BAPISDHD1, "  Order type
        LR_CONST              TYPE REF TO TY_CONST,  " Constant  table
        LR_I_PARTNER          TYPE REF TO BAPISDPART, " Partner
        LR_NOTIF_PROF         TYPE REF TO LTY_RENWL_P_DET, " Renwl plan determination
        LR_I_HEADER           TYPE REF TO  BAPISDHD, " Order header
        LI_PARTNER            TYPE STANDARD TABLE OF BAPIPARNR INITIAL SIZE 0, " Partner details
        LR_SALES_CONTRACT_IN  TYPE  REF TO BAPICTR ,                     " contract data
        LI_SALES_CONTRACT_IN  TYPE STANDARD TABLE OF BAPICTR ,           " Internal  table for cond
        LR_SALES_CONTRACT_INX TYPE REF TO  BAPICTRX ,                    " Communication fields: SD Contract Data Checkbox
        LI_SALES_CONTRACT_INX TYPE  STANDARD TABLE OF BAPICTRX INITIAL SIZE 0 ,         " Communication fields: SD Contract Data Checkbox
        LI_RETURN             TYPE STANDARD TABLE OF BAPIRET2 INITIAL SIZE 0, " Bapi return
        LR_PARTNER            TYPE REF TO BAPIPARNR, " reference variable
        LI_ITEM               TYPE STANDARD TABLE OF BAPISDITM INITIAL SIZE 0, " Item details
        LR_ITEM               TYPE REF TO BAPISDITM, " reference variables
        LI_ITEMX              TYPE STANDARD TABLE OF BAPISDITMX INITIAL SIZE 0, " Itemx parameter
*       Begin of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
        LR_I_BUSINESS         TYPE REF TO BAPISDBUSI,
*       End   of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
        LR_CONTRACT           TYPE REF TO BAPISDCNTR, " contrat details
        LR_RETURN             TYPE REF TO BAPIRET2, " Return table
        LR_ITEMX              TYPE REF TO BAPISDITMX,
        LST_BAPISDLS          TYPE BAPISDLS,
        LR_I_ITEM             TYPE REF TO BAPISDIT, " Reference variable
        LV_DAYS               TYPE T5A4A-DLYDY, " No days
*       Begin of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
        LV_YEAR               TYPE T5A4A-DLYYR,       " Year
*       End   of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
        LV_TABIX              TYPE I, " Index
        LR_HEADERX            TYPE REF TO BAPISDHD1X. " Headerx reference variable
  CONSTANTS:
    LC_CONTRACT  TYPE VBTYP VALUE 'G',             " contract
    LC_POSNR_LOW TYPE VBAP-VBELN VALUE '000000',   " Posner low
    LC_DEVID     TYPE ZDEVID VALUE 'E096',              "Development ID
    LC_PARAM1    TYPE RVARI_VNAM VALUE 'GR',         "Parameter1
    LC_INSERT    TYPE CHAR1 VALUE 'I',          " Insert data
*   Begin of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
    LC_DAYS      TYPE T5A4A-DLYDY  VALUE '00',       " Days
*   End   of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
    LC_MONTH     TYPE T5A4A-DLYMO  VALUE '00',       " Month
    LC_YEAR      TYPE T5A4A-DLYYR  VALUE '00',       " Year
    LC_G         TYPE KNPRS VALUE 'G'. " Copy prices  and determine the taxes
  CREATE DATA: LR_HEADER,
                LR_HEADERX,
                LR_PARTNER,
                LR_I_PARTNER,
                LR_SALES_CONTRACT_IN,
                LR_SALES_CONTRACT_INX,
                LR_ITEM,
                LR_ITEMX.
  SELECT RENWL_PROF
  QUOTE_TIME
  NOTIF_PROF
  GRACE_START
  GRACE_PERIOD
  AUTO_RENEW
  LAPSE
    FROM ZQTC_RENWL_P_DET
    INTO TABLE LI_RENWL_PLAN
    WHERE
    RENWL_PROF = FP_RENWL_PROF ."renwl_prof  .
  IF SY-SUBRC = 0.
    READ TABLE FP_I_HEADER REFERENCE INTO LR_I_HEADER INDEX 1.
    IF SY-SUBRC = 0.


      LR_HEADER->SD_DOC_CAT = LC_CONTRACT.
      READ TABLE FP_CONST REFERENCE INTO LR_CONST WITH KEY DEVID  = LC_DEVID
                                                           PARAM1 = LC_PARAM1.
      IF SY-SUBRC = 0.
        LR_HEADER->DOC_TYPE = LR_CONST->LOW. " 'ZREW'.
      ENDIF.
      LR_HEADER->SALES_ORG = LR_I_HEADER->SALES_ORG.
      LR_HEADER->DISTR_CHAN = LR_I_HEADER->DISTR_CHAN.
      LR_HEADER->DIVISION = LR_I_HEADER->DIVISION.
*     Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
      LR_HEADER->SALES_OFF = LR_I_HEADER->SALES_OFF.
*     End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
      LR_HEADER->REF_DOC = LR_I_HEADER->DOC_NUMBER. "low.
      LR_HEADER->REF_DOC_L = LR_I_HEADER->DOC_NUMBER.
*     Begin of ADD:ERP-2232:ANISAHA:24-MAY-2017:ED2K906293
      LR_HEADER->PURCH_NO_C = LR_I_HEADER->PURCH_NO. "Purchase order #
*     End   of ADD:ERP-2232:ANISAHA:24-MAY-2017:ED2K906293
*     Begin of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
      LR_HEADER->PURCH_DATE = LR_I_HEADER->PURCH_DATE. "Customer purchase order date
      LR_HEADER->PO_METHOD  = LR_I_HEADER->PO_METHOD.  "Customer purchase order type
      LR_HEADER->REF_1      = LR_I_HEADER->REF_1.      "Your Reference
*     End   of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
      LR_HEADER->REFDOC_CAT = LC_CONTRACT. "'G'.
      LR_HEADER->REFDOCTYPE = LC_CONTRACT. "'G'.
      LR_HEADER->REF_1 = LR_I_HEADER->DOC_NUMBER.
      LR_HEADERX->REFDOC_CAT = ABAP_TRUE.
      LR_HEADERX->DOC_TYPE = ABAP_TRUE.
      LR_HEADERX->SALES_ORG = ABAP_TRUE.
      LR_HEADERX->DISTR_CHAN = ABAP_TRUE.
      LR_HEADERX->DIVISION = ABAP_TRUE.
*     Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
      LR_HEADERX->SALES_OFF = ABAP_TRUE.
*     End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
      LR_HEADERX->REF_DOC = ABAP_TRUE.
      LR_HEADERX->REF_1 = ABAP_TRUE.
*     Begin of ADD:ERP-2232:ANISAHA:24-MAY-2017:ED2K906293
      LR_HEADERX->PURCH_NO_C = ABAP_TRUE.
*     End   of ADD:ERP-2232:ANISAHA:24-MAY-2017:ED2K906293
*     Begin of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
      LR_HEADERX->PURCH_DATE = ABAP_TRUE.  "Customer purchase order date
      LR_HEADERX->PO_METHOD  = ABAP_TRUE.  "Customer purchase order type
      LR_HEADERX->REF_1      = ABAP_TRUE.  "Your Reference

*     Begin of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910272
      IF LI_TVCPA[] IS INITIAL.
        SELECT AUARN  "Copying control: Target sales document type
               AUARV  "Copying control: Reference document type
               PSTYV  "Reference item category
               PSTYN  "Default item category
          FROM TVCPA
          INTO TABLE LI_TVCPA
         WHERE AUARN EQ LR_HEADER->DOC_TYPE
           AND FKARV EQ SPACE
           AND ETTYV EQ SPACE.
        IF SY-SUBRC EQ 0.
          SORT LI_TVCPA BY AUARV PSTYV.
        ENDIF.
      ENDIF.
*     End   of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910272

      READ TABLE FP_I_BUSINESS REFERENCE INTO LR_I_BUSINESS WITH KEY ITM_NUMBER = LC_POSNR_LOW.
      IF SY-SUBRC = 0.
        LR_HEADER->REF_1_S    = LR_I_BUSINESS->REF_1_S.    "Ship-to party's Your Reference
        LR_HEADERX->REF_1_S   = ABAP_TRUE.                 "Ship-to party's Your Reference
*       Begin of ADD:ERP-5997:WROY:17-Jan-2018:ED2K910345
        LR_HEADER->PURCH_NO_C = LR_I_BUSINESS->PURCH_NO_C. "Purchase order #
*       End   of ADD:ERP-5997:WROY:17-Jan-2018:ED2K910345
      ENDIF.
*     End   of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
*     Begin of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
      READ TABLE FP_I_CONTRACT REFERENCE INTO LR_CONTRACT WITH KEY DOC_NUMBER = LR_I_HEADER->DOC_NUMBER
                                                                   ITM_NUMBER = LC_POSNR_LOW.
      IF SY-SUBRC = 0.
        LR_SALES_CONTRACT_IN->ITM_NUMBER  = LC_POSNR_LOW.
        LR_SALES_CONTRACT_INX->ITM_NUMBER = LC_POSNR_LOW.
        LR_SALES_CONTRACT_INX->UPDATEFLAG = LC_INSERT.
        LR_SALES_CONTRACT_IN->CON_EN_ACT  = LR_CONTRACT->CONTENDACT. "Action at end of contract
        LR_SALES_CONTRACT_INX->CON_EN_ACT = ABAP_TRUE.               "Action at end of contract

        CLEAR LV_YEAR.
        MOVE 1 TO LV_YEAR.
        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            DATE      = LR_CONTRACT->ACTIONDATE                      "Date for action
            DAYS      = LC_DAYS
            MONTHS    = LC_MONTH
            YEARS     = LV_YEAR
          IMPORTING
            CALC_DATE = LR_SALES_CONTRACT_IN->ACTION_DAT.            "Date for action
        LR_SALES_CONTRACT_INX->ACTION_DAT = ABAP_TRUE.
        APPEND LR_SALES_CONTRACT_IN->* TO LI_SALES_CONTRACT_IN.
        CLEAR LR_SALES_CONTRACT_IN->*.
        APPEND LR_SALES_CONTRACT_INX->* TO LI_SALES_CONTRACT_INX.
        CLEAR LR_SALES_CONTRACT_INX->*.
      ENDIF.
*     End   of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
      LR_HEADERX->UPDATEFLAG = LC_INSERT.
      LOOP AT FP_I_PARTNER REFERENCE INTO LR_I_PARTNER WHERE CUSTOMER IS NOT INITIAL.
        LR_PARTNER->PARTN_ROLE = LR_I_PARTNER->PARTN_ROLE.
        LR_PARTNER->PARTN_NUMB = LR_I_PARTNER->CUSTOMER.
        LR_PARTNER->ITM_NUMBER = LR_I_PARTNER->ITM_NUMBER.
        APPEND LR_PARTNER->* TO LI_PARTNER.
        CLEAR LR_PARTNER->*.
      ENDLOOP.
      CLEAR LV_TABIX.
      LOOP AT FP_I_ITEM REFERENCE INTO LR_I_ITEM.
        LV_TABIX = LV_TABIX + 1.
        LR_ITEM->ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
        LR_ITEMX->ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
*       Begin of DEL:ERP-5828:WROY:10-Jan-2018:ED2K910241
*       lr_item->item_categ =  lr_header->doc_type.
*       End   of DEL:ERP-5828:WROY:10-Jan-2018:ED2K910241
*       Begin of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910241
        READ TABLE LI_TVCPA ASSIGNING FIELD-SYMBOL(<LST_TVCPA>)
             WITH KEY AUARV = LR_I_HEADER->DOC_TYPE
                      PSTYV = LR_I_ITEM->ITEM_CATEG
             BINARY SEARCH.
        IF SY-SUBRC EQ 0 AND
           <LST_TVCPA>-PSTYN IS NOT INITIAL..
          LR_ITEM->ITEM_CATEG = <LST_TVCPA>-PSTYN.
        ELSE.
          LR_ITEM->ITEM_CATEG = LR_I_ITEM->ITEM_CATEG.
        ENDIF.
        LR_ITEMX->ITEM_CATEG = ABAP_TRUE.
*       End   of ADD:ERP-5828:WROY:10-Jan-2018:ED2K910241
*       Begin of DEL:ERP-6283:WROY:31-Jan-2018:ED2K910611
*       READ TABLE fp_i_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_item->doc_number.
*       End   of DEL:ERP-6283:WROY:31-Jan-2018:ED2K910611
*       Begin of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
        READ TABLE FP_I_CONTRACT REFERENCE INTO LR_CONTRACT WITH KEY DOC_NUMBER = LR_I_ITEM->DOC_NUMBER
                                                                     ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
        IF SY-SUBRC NE 0.
          READ TABLE FP_I_CONTRACT REFERENCE INTO LR_CONTRACT WITH KEY DOC_NUMBER = LR_I_ITEM->DOC_NUMBER
                                                                       ITM_NUMBER = LC_POSNR_LOW.
        ENDIF.
*       End   of ADD:ERP-6283:WROY:31-Jan-2018:ED2K910611
        IF SY-SUBRC = 0.
          LR_SALES_CONTRACT_IN->ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
          LR_SALES_CONTRACT_INX->ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
          LR_SALES_CONTRACT_INX->UPDATEFLAG = LC_INSERT.
          LR_SALES_CONTRACT_IN->CON_ST_DAT = LR_CONTRACT->CONTENDDAT.
          CLEAR LV_DAYS.
          MOVE 1 TO LV_DAYS.
          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              DATE      = LR_SALES_CONTRACT_IN->CON_ST_DAT
              DAYS      = LV_DAYS
              MONTHS    = LC_MONTH
              YEARS     = LC_YEAR
            IMPORTING
              CALC_DATE = LR_SALES_CONTRACT_IN->CON_ST_DAT.
          LR_SALES_CONTRACT_INX->CON_ST_DAT = ABAP_TRUE.
          LR_HEADER->PRICE_DATE = LR_SALES_CONTRACT_IN->CON_ST_DAT.

*Begin of Add-Anirban-07.26.2017-ED2K907560-Defect 3335
          LR_HEADERX->PRICE_DATE = ABAP_TRUE.
          LR_HEADERX->SD_DOC_CAT = ABAP_TRUE.
          LR_HEADERX->REF_DOC_L = ABAP_TRUE.
*End of Add-Anirban-07.26.2017-ED2K907560-Defect 3335

          CLEAR LV_DAYS.
          READ TABLE LI_RENWL_PLAN REFERENCE INTO LR_NOTIF_PROF WITH KEY    RENWL_PROF = FP_RENWL_PROF.
          IF SY-SUBRC = 0.
            MOVE LR_NOTIF_PROF->GRACE_PERIOD TO LV_DAYS.
          ENDIF.
          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              DATE      = LR_SALES_CONTRACT_IN->CON_ST_DAT
              DAYS      = LV_DAYS
              MONTHS    = LC_MONTH
              YEARS     = LC_YEAR
            IMPORTING
              CALC_DATE = LR_SALES_CONTRACT_IN->CON_EN_DAT.
          LR_SALES_CONTRACT_INX->CON_EN_DAT = ABAP_TRUE.
          APPEND LR_SALES_CONTRACT_IN->* TO LI_SALES_CONTRACT_IN.
*& Change the date for contract header
          IF LV_TABIX = 1.
            LR_SALES_CONTRACT_IN->ITM_NUMBER = LC_POSNR_LOW.
            APPEND LR_SALES_CONTRACT_IN->* TO LI_SALES_CONTRACT_IN.
            LR_SALES_CONTRACT_INX->ITM_NUMBER = LC_POSNR_LOW.
            APPEND LR_SALES_CONTRACT_INX->* TO LI_SALES_CONTRACT_INX.
          ENDIF.
          CLEAR LR_SALES_CONTRACT_IN->*.
          APPEND LR_SALES_CONTRACT_INX->* TO LI_SALES_CONTRACT_INX.
          CLEAR LR_SALES_CONTRACT_INX->*.

        ENDIF.
        LR_ITEMX->UPDATEFLAG = LC_INSERT.
        LR_ITEM->MATERIAL =  LR_I_ITEM->MATERIAL.
        LR_ITEMX->MATERIAL = ABAP_TRUE.
        LR_ITEM->TARGET_QTY =  LR_I_ITEM->TARGET_QTY .
        LR_ITEM->TARGET_QU = LR_I_ITEM->TARGET_QU.
        LR_ITEM->PLANT = LR_I_ITEM->PLANT.
        LR_ITEMX->TARGET_QTY = ABAP_TRUE.
        LR_ITEMX->TARGET_QU = ABAP_TRUE.
        IF NOT LR_I_ITEM->REF_DOC IS INITIAL.
          LR_ITEM->REF_DOC  =   LR_I_ITEM->REF_DOC.
          LR_ITEMX->REF_DOC = ABAP_TRUE.
        ENDIF.
        IF NOT LR_I_ITEM->POSNR_VOR IS INITIAL.
          LR_ITEM->REF_DOC_IT = LR_I_ITEM->POSNR_VOR.
          LR_ITEMX->REF_DOC_IT = ABAP_TRUE.
        ENDIF.
        IF LR_I_ITEM->DOC_CAT_SD IS NOT INITIAL.
          LR_ITEM->REF_DOC_CA = LR_I_ITEM->DOC_CAT_SD.
          LR_ITEMX->REF_DOC_CA = ABAP_TRUE.
        ENDIF.
        LR_ITEM->REF_DOC = LR_HEADER->REF_DOC.
        LR_ITEM->REF_DOC_IT = LR_I_ITEM->ITM_NUMBER.
        LR_ITEM->REF_DOC_CA = LC_CONTRACT.

*       Begin of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
        READ TABLE FP_I_BUSINESS REFERENCE INTO LR_I_BUSINESS WITH KEY ITM_NUMBER = LR_I_ITEM->ITM_NUMBER.
        IF SY-SUBRC = 0.
          LR_ITEM->PURCH_NO_C  = LR_I_BUSINESS->PURCH_NO_C. "Purchase order #
          LR_ITEM->PURCH_DATE  = LR_I_BUSINESS->PURCH_DATE. "Customer purchase order date
          LR_ITEM->PO_METHOD   = LR_I_BUSINESS->PO_METHOD.  "Customer purchase order type
          LR_ITEM->PRICE_GRP   = LR_I_BUSINESS->PRICE_GRP.  "Price group (customer)
          LR_ITEM->REF_1       = LR_I_BUSINESS->REF_1.      "Your Reference
          LR_ITEM->REF_1_S     = LR_I_BUSINESS->REF_1_S.    "Ship-to party's Your Reference
          LR_ITEM->CUST_GROUP  = LR_I_BUSINESS->CUST_GROUP. "Customer Group

*Begin of Add-Anirban-07.28.2017-ED2K907608-Defect 3682
          LR_ITEM->CSTCNDGRP5 =  LR_I_BUSINESS->CUSTCONGR5.  "Customer condition group 5
          IF LR_ITEM->CSTCNDGRP5 IS INITIAL.
            READ TABLE FP_I_BUSINESS REFERENCE INTO LR_I_BUSINESS WITH KEY ITM_NUMBER = LC_POSNR_LOW.
            IF SY-SUBRC = 0.
              LR_ITEM->CSTCNDGRP5 =  LR_I_BUSINESS->CUSTCONGR5.  "Customer condition group 5
            ENDIF.
          ENDIF.
          LR_ITEMX->CSTCNDGRP5 = ABAP_TRUE.                 "Customer condition group 5
*End of Add-Anirban-07.28.2017-ED2K907608-Defect 3682

*lc_posnr_low TYPE vbap-posnr    VALUE '000000',
          LR_ITEMX->PURCH_NO_C = ABAP_TRUE.                 "Purchase order #
          LR_ITEMX->PURCH_DATE = ABAP_TRUE.                 "Customer purchase order date
          LR_ITEMX->PO_METHOD  = ABAP_TRUE.                 "Customer purchase order type
          LR_ITEMX->PRICE_GRP  = ABAP_TRUE.                 "Price group (customer)
          LR_ITEMX->REF_1      = ABAP_TRUE.                 "Your Reference
          LR_ITEMX->REF_1_S    = ABAP_TRUE.                 "Ship-to party's Your Reference
          LR_ITEMX->CUST_GROUP = ABAP_TRUE.                 "Customer Group
        ENDIF.
*       End   of ADD:ERP-2233:WROY:25-MAY-2017:ED2K906293
        APPEND LR_ITEM->* TO LI_ITEM.
        CLEAR LR_ITEM->*.
        APPEND LR_ITEMX->* TO LI_ITEMX.
        CLEAR LR_ITEMX->*.
      ENDLOOP.



*      lst_bapisdls-pricing = lc_g.
      CLEAR LI_RETURN.
      CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
        EXPORTING
          SALES_HEADER_IN       = LR_HEADER->*
          INT_NUMBER_ASSIGNMENT = ABAP_TRUE
          TESTRUN               = P_TEST
*         logic_switch          = lst_bapisdls
        IMPORTING
          SALESDOCUMENT_EX      = FP_V_SALESORD
        TABLES
          RETURN                = LI_RETURN
          SALES_ITEMS_IN        = LI_ITEM
          SALES_ITEMS_INX       = LI_ITEMX
          SALES_PARTNERS        = LI_PARTNER
          SALES_CONTRACT_IN     = LI_SALES_CONTRACT_IN
          SALES_CONTRACT_INX    = LI_SALES_CONTRACT_INX
          TEXTHEADERS_EX        = FP_I_TEXTHEADERS
          TEXTLINES_EX          = FP_I_TEXTLINES.
      READ TABLE LI_RETURN REFERENCE INTO LR_RETURN WITH KEY TYPE = 'E'.
      IF SY-SUBRC <> 0.
        IF P_TEST = SPACE .
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              WAIT = ABAP_TRUE.
          FP_V_ACT_STATUS = ABAP_TRUE.
          CONCATENATE   'Grace Subscription'(a04) FP_V_SALESORD TEXT-A08 INTO FP_MESSAGE.
        ELSE.
          CONCATENATE  'Grace Subscription'(a04) FP_V_SALESORD TEXT-X23 INTO FP_MESSAGE.
        ENDIF.


      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        APPEND LINES OF LI_RETURN TO FP_I_RETURN.
        MOVE LR_RETURN->MESSAGE TO FP_MESSAGE.
      ENDIF.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_CONSTANT_TABLE
*&---------------------------------------------------------------------*
*       Fetch data from constant table ZCACONSTANT
*----------------------------------------------------------------------*
*      <--FP_I_CONST  Constant table
*----------------------------------------------------------------------*
FORM F_FETCH_CONSTANT_TABLE  CHANGING FP_I_CONST TYPE TT_CONST.
**  Local Constants declaration
  CONSTANTS:
            LC_DEVID TYPE ZDEVID     VALUE 'E096'. "Development ID
*& Get data from constant table
  SELECT DEVID                         "Development ID
         PARAM1                        "ABAP: Name of Variant Variable
         PARAM2                        "ABAP: Name of Variant Variable
         SRNO                          "Current selection number
         SIGN                          "ABAP: ID: I/E (include/exclude values)
         OPTI                          "ABAP: Selection option (EQ/BT/CP/...)
         LOW                           "Lower Value of Selection Condition
         HIGH                          "Upper Value of Selection Condition
         ACTIVATE                      "Activation indicator for constant
         FROM ZCACONSTANT              " Wiley Application Constant Table
         INTO TABLE FP_I_CONST
         WHERE DEVID    = LC_DEVID
           AND ACTIVATE = ABAP_TRUE
         ORDER BY DEVID PARAM1 PARAM2. "Only active record
  IF SY-SUBRC <> 0.
*& do nothing
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_NOTIF_PROF
*&---------------------------------------------------------------------*
*       Fetch data from notification retermination table
*----------------------------------------------------------------------*
*      -->P_I_FINAL       : Final table
*      <--P_I_NOTIF_P_DET :Notification determination
*----------------------------------------------------------------------*
FORM F_FETCH_NOTIF_PROF  USING    FP_I_FINAL TYPE TT_FINAL
                         CHANGING FP_I_NOTIF_P_DET TYPE TT_NOTIF_P_DET.
  TYPES:
    BEGIN OF LTY_RENWL_P_DET,
      RENWL_PROF   TYPE ZRENWL_PROF,   " Renewal Profile
      QUOTE_TIME   TYPE ZQUOTE_TIM,    " Quote Timing
      NOTIF_PROF   TYPE ZNOTIF_PROF,   " Notification Profile
      GRACE_START  TYPE ZGRACE_START,  " Grace Start Timing
      GRACE_PERIOD TYPE ZGRACE_PERIOD, " Grace Period
      AUTO_RENEW   TYPE ZAUTO_RENEW,   " Auto Renew Timing
      LAPSE        TYPE ZLAPSE,        " Lapse
    END OF   LTY_RENWL_P_DET,
    LTT_RENWL_P_DET TYPE STANDARD TABLE OF LTY_RENWL_P_DET
          INITIAL SIZE 0.
  DATA: LI_FINAL      TYPE TT_FINAL,
        LI_RENWL_PLAN TYPE LTT_RENWL_P_DET.
  LI_FINAL = FP_I_FINAL.
  SORT LI_FINAL BY RENWL_PROF.
  DELETE ADJACENT DUPLICATES FROM LI_FINAL COMPARING RENWL_PROF.
  IF LI_FINAL IS NOT INITIAL.
    SELECT RENWL_PROF  " Renewal Profile
    QUOTE_TIME         " Quote Timing
    NOTIF_PROF         " Notification Profile
    GRACE_START        " Grace Start Timing
    GRACE_PERIOD       " Grace Period
    AUTO_RENEW         " Auto Renew Timing
     LAPSE " Lapse
      FROM ZQTC_RENWL_P_DET  " E095: Renewal Profile Details Table
      INTO TABLE LI_RENWL_PLAN

      FOR ALL ENTRIES IN LI_FINAL

      WHERE
      RENWL_PROF = LI_FINAL-RENWL_PROF
.
    IF SY-SUBRC = 0.
      SORT LI_RENWL_PLAN BY NOTIF_PROF.
      DELETE ADJACENT DUPLICATES FROM LI_RENWL_PLAN COMPARING NOTIF_PROF.
      IF LI_RENWL_PLAN IS NOT INITIAL.
        SELECT                 NOTIF_PROF          " Notification Profile
                               NOTIF_REM           " Notification/Reminder
                               REM_IN_DAYS         " Notification Reminder (in Days)
                               PROMO_CODE          " Promo code
                        FROM ZQTC_NOTIF_P_DET
                        INTO  TABLE FP_I_NOTIF_P_DET
                        FOR ALL ENTRIES IN LI_RENWL_PLAN
                        WHERE
                        NOTIF_PROF = LI_RENWL_PLAN-NOTIF_PROF.
        IF SY-SUBRC = 0.
          LOOP AT FP_I_NOTIF_P_DET ASSIGNING FIELD-SYMBOL(<LST_NOTIF_E095>).
            READ TABLE LI_RENWL_PLAN ASSIGNING FIELD-SYMBOL(<LST_RENWL_PLAN>) WITH KEY NOTIF_PROF = <LST_NOTIF_E095>-NOTIF_PROF
            BINARY SEARCH.
            IF SY-SUBRC = 0.
              <LST_NOTIF_E095>-RENWL_PROF = <LST_RENWL_PLAN>-RENWL_PROF.
            ENDIF.

          ENDLOOP.

        ENDIF.
      ENDIF.

    ENDIF.
  ENDIF.



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
FORM F_UPDATE_PROMO_CODE  USING    FP_LI_VBFA TYPE TT_VBFA
                                   FP_LI_NOTIF_PROF TYPE  TT_NOTIF_P_DET
                                   FP_LR_FINAL TYPE  TY_RENWL_PLAN.

  DATA:       LR_VBFA         TYPE REF TO VBFA,
              LST_HEADER_INX  TYPE BAPISDH1X,
              LI_RETURN       TYPE TABLE OF BAPIRET2,           " Return Messages
              LR_RETURN       TYPE REF TO BAPIRET2,             " BAPI Return Messages
              LV_CHAR         TYPE C LENGTH 240,
              LST_BAPE_VBAK   TYPE BAPE_VBAK,
              LST_BAPE_VBAKX  TYPE BAPE_VBAKX,
              LST_BAPE_VBAP   TYPE BAPE_VBAP,                   " BAPI Interface for Customer Enhancements to Table VBAP
              LST_BAPE_VBAPX  TYPE BAPE_VBAPX,                  " BAPI Checkbox for Customer Enhancments to Table VBAP
              LST_ITEM_IN     TYPE  BAPISDITM,                  " Communication Fields: Sales and Distribution Document Item
              LI_ITEM_IN      TYPE STANDARD TABLE OF BAPISDITM, " Communication Fields: Sales and Distribution Document Item
              LST_ITEM_INX    TYPE  BAPISDITMX,                 " Communication Fields: Sales and Distribution Document Item
              LI_ITEM_INX     TYPE STANDARD TABLE OF BAPISDITMX,
              LST_EXTENSIONIN TYPE  BAPIPAREX,
              LV_REMINDER     TYPE ZNOTIF_REM,
              LI_EXTENSIONIN  TYPE   STANDARD TABLE OF BAPIPAREX.

  CONSTANTS:LC_BAPE_VBAP  TYPE TE_STRUC VALUE 'BAPE_VBAP',  " constant table name  for extension
            LC_BAPE_VBAPX TYPE TE_STRUC VALUE 'BAPE_VBAPX', " constant table name for Extension
            LC_BAPE_VBAK  TYPE TE_STRUC VALUE 'BAPE_VBAK',  " constant table name  for extension
            LC_BAPE_VBAKX TYPE TE_STRUC VALUE 'BAPE_VBAKX', " constant table name for Extension
            LC_UPDATE     TYPE CHAR1            VALUE 'U',  " Update
            LC_ERROR      TYPE BAPI_MTYPE       VALUE 'E',  " error
            LC_ABEND      TYPE BAPI_MTYPE       VALUE 'A',  " Abbend
            LC_SUCCESS    TYPE BAPI_MTYPE       VALUE 'S'.  " suceess

  READ TABLE FP_LI_VBFA REFERENCE INTO LR_VBFA INDEX 1.
  IF LR_VBFA IS BOUND.

    LST_HEADER_INX-UPDATEFLAG = LC_UPDATE.
    SELECT SINGLE  ZZPROMO
          FROM VBAK  " Sales Document: Header Data
          INTO @DATA(LV_PROMO)
          WHERE
          VBELN = @LR_VBFA->VBELN.

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
    IF FP_LR_FINAL-PROMO_CODE <> LV_PROMO.


      LST_EXTENSIONIN-STRUCTURE      = LC_BAPE_VBAK.
      LST_BAPE_VBAK-VBELN            = LR_VBFA->VBELN.
*    lst_bape_vbap-posnr            = lr_vbfa->posnn.
*    IF fp_lr_final-promo_code IS NOT INITIAL.
      LST_BAPE_VBAK-ZZPROMO       =    FP_LR_FINAL-PROMO_CODE.
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
      CALL METHOD CL_ABAP_CONTAINER_UTILITIES=>FILL_CONTAINER_C
        EXPORTING
          IM_VALUE     = LST_BAPE_VBAK
        IMPORTING
          EX_CONTAINER = LST_EXTENSIONIN-VALUEPART1.
      APPEND LST_EXTENSIONIN TO LI_EXTENSIONIN.
      CLEAR LST_EXTENSIONIN.
*   Populate the Check box
*    lst_extensionin-structure       = lc_bape_vbapx.
*    lst_bape_vbapx-vbeln            = lr_vbfa->vbeln.
*    lst_bape_vbapx-posnr            = lr_vbfa->posnn.
*    lst_bape_vbapx-zzpromo           = abap_true.
*    Syntax check is hidden since this a stardard syntax error with no possible way to avoid
      LST_EXTENSIONIN-STRUCTURE       = LC_BAPE_VBAKX.
      LST_BAPE_VBAKX-VBELN            = LR_VBFA->VBELN.
      LST_BAPE_VBAKX-ZZPROMO         = ABAP_TRUE.
      CALL METHOD CL_ABAP_CONTAINER_UTILITIES=>FILL_CONTAINER_C
        EXPORTING
          IM_VALUE     = LST_BAPE_VBAKX
        IMPORTING
          EX_CONTAINER = LST_EXTENSIONIN-VALUEPART1.

      APPEND LST_EXTENSIONIN TO LI_EXTENSIONIN.
      CLEAR  LST_EXTENSIONIN.
*    Syntax check is hidden since this a stardard syntax error with no possible way to avoid
*    CALL METHOD cl_abap_container_utilities=>fill_container_c
*      EXPORTING
*        im_value     = lst_bape_vbapx
*      IMPORTING
*        ex_container = lst_extensionin-valuepart1.
*
*    APPEND lst_extensionin TO li_extensionin.
*    CLEAR  lst_extensionin.
    ENDIF.



    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        SALESDOCUMENT    = LR_VBFA->VBELN
        ORDER_HEADER_INX = LST_HEADER_INX
        SIMULATION       = P_TEST
      TABLES
        RETURN           = LI_RETURN
*       order_item_in    = li_item_in
*       order_item_inx   = li_item_inx
        EXTENSIONIN      = LI_EXTENSIONIN.
    LOOP AT LI_RETURN REFERENCE INTO LR_RETURN  WHERE TYPE = LC_ERROR
                                                   OR TYPE = LC_ABEND.
    ENDLOOP.
*& If no Error / Abend happens
    IF SY-SUBRC <> 0 .
      IF P_TEST = SPACE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            WAIT = ABAP_TRUE.
      ENDIF.

      READ TABLE LI_RETURN REFERENCE INTO LR_RETURN WITH KEY TYPE = LC_SUCCESS.
      IF SY-SUBRC = 0.
        IF P_TEST = SPACE.
          IF FP_LR_FINAL-PROMO_CODE IS INITIAL AND LV_PROMO IS NOT INITIAL.
            CONCATENATE 'Previous Promo code'(a23) LV_PROMO 'has been removed'(a24)  INTO FP_LR_FINAL-MESSAGE
            SEPARATED BY SPACE.
          ELSEIF FP_LR_FINAL-PROMO_CODE  IS NOT INITIAL.
            CONCATENATE 'Promocode Successfully applied for'(a01) LR_VBFA->VBELN INTO FP_LR_FINAL-MESSAGE.
          ENDIF.

        ELSE.
          CONCATENATE 'Promocode can be  applied for'(x07) LR_VBFA->VBELN INTO FP_LR_FINAL-MESSAGE.
        ENDIF.

      ENDIF.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      CONCATENATE 'Promocode not applied for'(a02) LR_VBFA->VBELN INTO FP_LR_FINAL-MESSAGE.
    ENDIF.
  ENDIF.
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
FORM F_LAPASE_ORDER  USING    FP_LI_ITEM  TYPE TT_ITEM
                              FP_LI_HEADER TYPE TT_HEADER
                              FP_FLAG     TYPE CHAR1
                     CHANGING FP_LR_FINAL TYPE  TY_RENWL_PLAN
                              FP_I_RETURN TYPE TT_RETURN
                              FP_LV_LAPSED TYPE CHAR1.
  DATA: LI_RETURN             TYPE TABLE OF BAPIRET2,                    " Return Parameter
        LI_ITEM_IN            TYPE STANDARD TABLE OF BAPISDITM, " Communication Fields: Sales and Distribution Document Item
        LST_ITEM_IN           TYPE  BAPISDITM,
        LST_ITEM_INX          TYPE  BAPISDITMX,                 " Communication Fields: Sales and Distribution Document Item
        LI_ITEM_INX           TYPE STANDARD TABLE OF BAPISDITMX,
        LR_RETURN             TYPE REF TO BAPIRET2,                      " reference variable for Return Parameter
        LR_SALES_CONTRACT_IN  TYPE  REF TO BAPICTR ,                     " contract data
        LI_SALES_CONTRACT_IN  TYPE STANDARD TABLE OF BAPICTR ,           " Internal  table for cond
        LR_SALES_CONTRACT_INX TYPE REF TO  BAPICTRX ,                    " Communication fields: SD Contract Data Checkbox
        LI_SALES_CONTRACT_INX TYPE  STANDARD TABLE OF BAPICTRX ,         " Communication fields: SD Contract Data Checkbox
        LST_HEADER_INX        TYPE BAPISDHD1X.                           " Checkbox Fields for Sales and Distribution Document Header
  CONSTANTS: LC_UPDATE(1) TYPE C VALUE 'U',                               " Update
             LC_POSNR_LOW TYPE VBAP-POSNR VALUE '000000',                 " Item 0
             LC_LAPSE     TYPE VEDA-VKUESCH VALUE '0001',                 " Cancellation procedure
             LC_ERROR     TYPE CHAR1 VALUE 'E',                           " Error
             LC_ABEND     TYPE  CHAR1 VALUE 'A',                          " Abend
             LC_SUCCESS   TYPE CHAR1 VALUE 'S'.                           " success

  LOOP AT FP_LI_ITEM ASSIGNING FIELD-SYMBOL(<LST_LI_ITEM>) .
    READ TABLE FP_LI_HEADER ASSIGNING FIELD-SYMBOL(<LST_LI_HEADER>) WITH KEY DOC_NUMBER =   <LST_LI_ITEM>-DOC_NUMBER  .
    IF SY-SUBRC = 0.
      IF <LST_LI_ITEM>-ITM_NUMBER <> LC_POSNR_LOW.
        LST_ITEM_IN-ITM_NUMBER = <LST_LI_ITEM>-ITM_NUMBER.
        APPEND LST_ITEM_IN TO LI_ITEM_IN.
        CLEAR LST_ITEM_IN.
*   Populate the itemx table
        LST_ITEM_INX-ITM_NUMBER = <LST_LI_ITEM>-ITM_NUMBER.
        LST_ITEM_INX-UPDATEFLAG = LC_UPDATE.
        APPEND LST_ITEM_INX TO LI_ITEM_INX.
        CLEAR LST_ITEM_INX.
      ENDIF.
      CREATE DATA LR_SALES_CONTRACT_IN.
      LR_SALES_CONTRACT_IN->ITM_NUMBER = <LST_LI_ITEM>-ITM_NUMBER. " Iteme number
      LR_SALES_CONTRACT_IN->CANC_PROC = LC_LAPSE. " Cancellation Procedure
      LR_SALES_CONTRACT_IN->CON_EN_DAT = SY-DATUM. " Contract end date
*      lr_sales_contract_in->cancdocdat = sy-datum . "fp_lr_finaladat.,,
      APPEND LR_SALES_CONTRACT_IN->* TO LI_SALES_CONTRACT_IN.
      CLEAR LR_SALES_CONTRACT_IN->*.
      CREATE DATA LR_SALES_CONTRACT_INX.
      LR_SALES_CONTRACT_INX->ITM_NUMBER =  <LST_LI_ITEM>-ITM_NUMBER. " Iteme number
      LR_SALES_CONTRACT_INX->UPDATEFLAG = LC_UPDATE.
      LR_SALES_CONTRACT_INX->CANC_PROC = ABAP_TRUE. " Cancellation Procedure
      LR_SALES_CONTRACT_INX->CON_EN_DAT = ABAP_TRUE.
*      lr_sales_contract_inx->cancdocdat = abap_true.
      APPEND LR_SALES_CONTRACT_INX->* TO LI_SALES_CONTRACT_INX.
      CLEAR LR_SALES_CONTRACT_INX->*.
*& If flag is 'X' , then it's header of the renwal subcription
      IF SY-TABIX = 1 AND FP_FLAG = SPACE.

*& LAPSING THE HEADER ALSO
        LR_SALES_CONTRACT_IN->ITM_NUMBER = LC_POSNR_LOW. " Iteme number
        LR_SALES_CONTRACT_IN->CANC_PROC = LC_LAPSE. " Cancellation Procedure
        LR_SALES_CONTRACT_IN->CON_EN_DAT = SY-DATUM. " Contract end date
*        lr_sales_contract_in->cancdocdat = sy-datum.
        LR_SALES_CONTRACT_IN->CON_EN_DAT = SY-DATUM.
        APPEND LR_SALES_CONTRACT_IN->* TO LI_SALES_CONTRACT_IN.
        CLEAR LR_SALES_CONTRACT_IN->*.
        LR_SALES_CONTRACT_INX->ITM_NUMBER =  LC_POSNR_LOW. " Iteme number
        LR_SALES_CONTRACT_INX->UPDATEFLAG = LC_UPDATE.
        LR_SALES_CONTRACT_INX->CANC_PROC = ABAP_TRUE. " Cancellation Procedure
*        lr_sales_contract_inx->cancdocdat = abap_true.
        LR_SALES_CONTRACT_INX->CON_EN_DAT = ABAP_TRUE.
        APPEND LR_SALES_CONTRACT_INX->* TO LI_SALES_CONTRACT_INX.
        CLEAR LR_SALES_CONTRACT_INX->*.

      ENDIF.
    ENDIF.
  ENDLOOP.



  IF LI_SALES_CONTRACT_IN IS NOT INITIAL.
    LST_HEADER_INX-UPDATEFLAG = LC_UPDATE.
    CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
      EXPORTING
        SALESDOCUMENT      = <LST_LI_HEADER>-DOC_NUMBER
        ORDER_HEADER_INX   = LST_HEADER_INX
        SIMULATION         = P_TEST
*       business_object    = 'BUS2034'
      TABLES
        RETURN             = LI_RETURN
        ITEM_IN            = LI_ITEM_IN
        ITEM_INX           = LI_ITEM_INX
        SALES_CONTRACT_IN  = LI_SALES_CONTRACT_IN
        SALES_CONTRACT_INX = LI_SALES_CONTRACT_INX.
    LOOP AT LI_RETURN REFERENCE INTO LR_RETURN  WHERE TYPE = LC_ERROR
                                               OR TYPE = LC_ABEND.

      APPEND LR_RETURN->* TO FP_I_RETURN.
      MOVE LR_RETURN->MESSAGE TO FP_LR_FINAL-MESSAGE.
    ENDLOOP.
*& If no Error / Abend happens
    IF SY-SUBRC <> 0.
      FP_LV_LAPSED = ABAP_TRUE.
      IF P_TEST = SPACE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            WAIT = SPACE.
      ENDIF.

      READ TABLE LI_RETURN REFERENCE INTO LR_RETURN WITH KEY TYPE = LC_SUCCESS.
      IF SY-SUBRC = 0.
        IF P_TEST = SPACE.
          FP_LR_FINAL-ACT_STATUS = ABAP_TRUE.
          CONCATENATE 'Subsc. Order'(y01) <LST_LI_HEADER>-DOC_NUMBER 'has been lapsed'(y02) FP_LR_FINAL-MESSAGE
                  INTO FP_LR_FINAL-MESSAGE SEPARATED BY SPACE.
        ELSE.
          CONCATENATE 'Subsc. Order'(y01) <LST_LI_HEADER>-DOC_NUMBER 'can be lapsed'(y05) FP_LR_FINAL-MESSAGE
                  INTO FP_LR_FINAL-MESSAGE SEPARATED BY SPACE.
        ENDIF.
      ENDIF.

    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.


    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETE_ENTRY
*&---------------------------------------------------------------------*
*     Delete data from table
*----------------------------------------------------------------------*
*      -->fp_renwal     :   Renewal Plan table
*      -->P_FP_I_FINAL  : final table
*----------------------------------------------------------------------*
FORM F_DELETE_ENTRY  USING    FP_RENWAL TYPE TT_RENWL_PLAN
                    CHANGING FP_I_FINAL TYPE TT_FINAL.

*& Enque Table ZQTC_RENWL_PLAN
  CALL FUNCTION 'ENQUEUE_EZQTC_AUTO_RENEW'
    EXPORTING
      MODE_ZQTC_RENWL_PLAN = ABAP_TRUE
      MANDT                = SY-MANDT
    EXCEPTIONS
      FOREIGN_LOCK         = 1
      SYSTEM_FAILURE       = 2
      OTHERS               = 3.
  IF SY-SUBRC <> 0.
* No Need to throw error message
  ELSE.
    DELETE ZQTC_RENWL_PLAN FROM TABLE FP_RENWAL.
    IF SY-SUBRC = 0.

      CALL FUNCTION 'DEQUEUE_EZQTC_AUTO_RENEW'
        EXPORTING
          MODE_ZQTC_RENWL_PLAN = ABAP_TRUE
          MANDT                = SY-MANDT.
      LOOP AT FP_I_FINAL ASSIGNING FIELD-SYMBOL(<LST_I_FINAL>).

        READ TABLE FP_RENWAL ASSIGNING FIELD-SYMBOL(<LST_RENEWAL_E095>) WITH KEY VBELN  = <LST_I_FINAL>-VBELN
                                                                                POSNR = <LST_I_FINAL>-POSNR
                                                                                .
        IF SY-SUBRC = 0.
          <LST_I_FINAL>-MESSAGE = 'Entry Removed'(a03).
        ENDIF.

      ENDLOOP.
    ENDIF.
  ENDIF.
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
FORM F_LAPSE_QUOTATION  USING    FP_SUBSSDDOC TYPE VBAK-VBELN
                        CHANGING FP_MESSAGE TYPE CHAR120
                                 FP_STATUS  TYPE CHAR1
                                 FP_I_RETURN TYPE  TT_RETURN.
* Begin of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
  TYPES : BEGIN OF LTY_VBAP,
            VBELN TYPE VBELN_VA,
            POSNR TYPE POSNR_VA,
          END   OF LTY_VBAP.
* End   of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890

  DATA: LI_RETURN             TYPE TABLE OF BAPIRET2,           " Return Messages
        LR_RETURN             TYPE REF TO BAPIRET2,             " BAPI Return Messages
*       Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
        LR_SALES_CONTRACT_IN  TYPE  REF TO BAPICTR ,                     " contract data
        LI_SALES_CONTRACT_IN  TYPE STANDARD TABLE OF BAPICTR ,           " Internal  table for cond
        LR_SALES_CONTRACT_INX TYPE REF TO  BAPICTRX ,                    " Communication fields: SD Contract Data Checkbox
        LI_SALES_CONTRACT_INX TYPE  STANDARD TABLE OF BAPICTRX INITIAL SIZE 0 , " Communication fields: SD Contract Data Checkbox
        LR_HEADER             TYPE REF TO BAPISDHD1,                            " Communication Fields: Sales and Distribution Document Header
        LR_HEADERX            TYPE REF TO BAPISDHD1X,                           " Checkbox Fields for Sales and Distribution Document Header
*       End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
*       Begin of DEL:CR# 546:WROY:03-JUN-2017:ED2K906489
*       lr_header             TYPE REF TO bapisdh1, " Communication Fields: Sales and Distribution Document Header
*       lr_headerx            TYPE REF TO  bapisdh1x. " Checkbox Fields for Sales and Distribution Document Header
*       End   of DEL:CR# 546:WROY:03-JUN-2017:ED2K906489

* Begin of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
        LI_VBAP               TYPE STANDARD TABLE OF LTY_VBAP,
        LST_VBAP              TYPE LTY_VBAP,
        LI_ITEM               TYPE STANDARD TABLE OF BAPISDITM,
        LR_ITEM               TYPE REF TO BAPISDITM,
        LI_ITEMX              TYPE STANDARD TABLE OF BAPISDITMX,
        LR_ITEMX              TYPE REF TO BAPISDITMX.
* End   of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
  CONSTANTS:            LC_UPDATE  TYPE UPDKZ_D VALUE 'U',            " Update
                        LC_ERROR   TYPE BAPI_MTYPE       VALUE 'E',  " error
                        LC_ABEND   TYPE BAPI_MTYPE       VALUE 'A',  " Abbend
                        LC_SUCCESS TYPE BAPI_MTYPE       VALUE 'S',  " suceess
* Begin of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
                        LC_LP_CODE TYPE RVARI_VNAM       VALUE 'LP_CODE'. "Lapse code
* End   of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
  CREATE DATA: LR_HEADER,
               LR_HEADERX,
* Begin of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
               LR_ITEM,
               LR_ITEMX.
* End   of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890

* Begin of DEL:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
** Begin of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489
*               lr_sales_contract_inx,
*               lr_sales_contract_in.
** End   of ADD:CR# 546:WROY:03-JUN-2017:ED2K906489

*  lr_header->qt_valid_t = sy-datum.
*  lr_headerx->qt_valid_t = abap_true.
* End   of DEL:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890

  LR_HEADERX->UPDATEFLAG = LC_UPDATE.

* Begin of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
  CLEAR : LI_VBAP, LST_VBAP.
  READ TABLE I_CONST REFERENCE INTO DATA(LST_CONST) WITH KEY PARAM1 = LC_LP_CODE.
  IF SY-SUBRC = 0.
    SELECT VBELN POSNR FROM VBAP INTO TABLE LI_VBAP WHERE VBELN = FP_SUBSSDDOC.
*                                                  AND   uepos = '000000'.
    IF SY-SUBRC = 0.
      LOOP AT LI_VBAP INTO LST_VBAP.
* Update contract cancellation reason code
        LR_ITEM->ITM_NUMBER = LST_VBAP-POSNR.
        LR_ITEMX->ITM_NUMBER = LST_VBAP-POSNR.
        LR_ITEM->REASON_REJ = LST_CONST->LOW.
        LR_ITEMX->REASON_REJ = ABAP_TRUE.
        LR_ITEMX->UPDATEFLAG = LC_UPDATE.

        APPEND LR_ITEM->* TO LI_ITEM.
        CLEAR LR_ITEM->*.
        APPEND LR_ITEMX->* TO LI_ITEMX.
        CLEAR LR_ITEMX->*.
      ENDLOOP.

    ENDIF.
  ENDIF.
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

  CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
    EXPORTING
      SALESDOCUMENT    = FP_SUBSSDDOC
      ORDER_HEADER_IN  = LR_HEADER->*
      ORDER_HEADER_INX = LR_HEADERX->*
      SIMULATION       = P_TEST
*     business_object  = 'BUS2034'
    TABLES
* Begin of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
      ITEM_IN          = LI_ITEM
      ITEM_INX         = LI_ITEMX
* End   of ADD:ERP 4669:ANISAHA:09-OCT-2017:ED2K908890
      RETURN           = LI_RETURN.
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
  LOOP AT LI_RETURN REFERENCE INTO LR_RETURN  WHERE TYPE = LC_ERROR
                                                 OR TYPE = LC_ABEND.
  ENDLOOP.
*& If no Error / Abend happens
  IF SY-SUBRC <> 0.
    IF P_TEST = SPACE .
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          WAIT = SPACE.
    ENDIF.
    READ TABLE LI_RETURN REFERENCE INTO LR_RETURN WITH KEY TYPE = LC_SUCCESS.
    IF SY-SUBRC = 0.
      IF P_TEST EQ SPACE.
        IF FP_MESSAGE IS INITIAL.
          CONCATENATE 'Quotation'(x03) FP_SUBSSDDOC 'Lapsed'(x04) INTO FP_MESSAGE SEPARATED BY SPACE.
*Begin of Add-Anirban-07.25.2017-ED2K907327-Defect 3479
          FP_STATUS = ABAP_TRUE.
*End of Add-Anirban-07.25.2017-ED2K907327-Defect 3479
        ELSE.
          CONCATENATE 'Quotation'(x03) FP_SUBSSDDOC 'Lapsed'(x04) INTO FP_MESSAGE SEPARATED BY SPACE.
        ENDIF.
      ELSE.
        IF FP_MESSAGE IS INITIAL.
          CONCATENATE 'Quotation'(x03) FP_SUBSSDDOC 'can be Lapsed'(x08) INTO FP_MESSAGE SEPARATED BY SPACE.
        ELSE.
          CONCATENATE 'Quotation'(x03) FP_SUBSSDDOC 'can be Lapsed'(x08) INTO FP_MESSAGE SEPARATED BY SPACE.
        ENDIF.
      ENDIF.
    ENDIF.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    IF FP_MESSAGE IS INITIAL..
      CONCATENATE 'Quotation not Lapsed'(x02) FP_SUBSSDDOC INTO FP_MESSAGE SEPARATED BY SPACE.
    ELSE.
      CONCATENATE FP_MESSAGE 'Quotation not Lapsed'(x02) FP_SUBSSDDOC INTO FP_MESSAGE SEPARATED BY SPACE.
    ENDIF.

  ENDIF.

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
FORM F_VALIDATE_SALES_ORG .

  IF S_VKORG[] IS INITIAL.
    RETURN.
  ENDIF.

* Organizational Unit: Sales Organizations
  SELECT VKORG
    FROM TVKO
   UP TO 1 ROWS
    INTO @DATA(LV_VKORG)
   WHERE VKORG IN @S_VKORG.
  ENDSELECT.
  IF SY-SUBRC NE 0.
*   Message: Invalid Sales Organization Number!
    MESSAGE E012(ZQTC_R2).
  ENDIF.

ENDFORM.
* End   of ADD:ERP-6242:WROY:05-Feb-2018:ED2K910691
