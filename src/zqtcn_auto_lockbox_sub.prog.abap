*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_AUTO_LOCKBOX_SUB
* PROGRAM DESCRIPTION: Automated Lockbox Renewals Sub routines
* DEVELOPER: Shivangi Priya
* CREATION DATE: 11/14/2016
* OBJECT ID: E097
* TRANSPORT NUMBER(S): ED2K903276
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907585
* REFERENCE NO: E097(ERP-3178)
* DEVELOPER: Lucky Kodwani
* DATE: 28/07/2017
* DESCRIPTION:
* Begin of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
* End of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  Include           ZQTCE_AUTO_LOCKBOX_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  UPDATE_CUST_TAB_ERROR_ENTRY
*&---------------------------------------------------------------------*
*       Update custom table ZQTCLOCKBOX_UPD for error entry
*----------------------------------------------------------------------*
*                             -->   FP_st_bsid TYPE ty_bsid
*                             -->   fp_st_vbak TYPE ty_vbak
*                             -->   fp_st_vbfa TYPE ty_vbfa
*                             <--  fp_i_final TYPE tt_final.
*----------------------------------------------------------------------*
FORM f_update_cust_tab_error_entry USING fp_st_bsid TYPE ty_bsid
                                         fp_st_vbak TYPE ty_vbak
                                         fp_st_vbfa TYPE ty_vbfa
                                         fp_paybl_amt TYPE wrbtr      " Amount in Document Currency
                                         fp_v_flag_und_tol TYPE char1 " V_flag_und_tol of type CHAR1
                                         fp_v_flag_und_amt TYPE char1 " V_flag_und_amt of type CHAR1
                                         fp_v_flag_ovr_tol TYPE char1 " V_flag_ovr_tol of type CHAR1
                                         fp_v_flag_ovr_amt TYPE char1 " V_flag_ovr_amt of type CHAR1
                              CHANGING   fp_i_final TYPE tt_final.
  DATA: lst_final   TYPE ty_final,
        lst_custtab TYPE zqtclockbox_upd. " Lockbox Renewal  " Para

  lst_custtab-mandt = sy-mandt. "Client
*  lst_custtab-xblnr = fp_st_bsid-xblnr. "Quote number  "(--)PBOSE: 15-05-2017: CR#384: ED2K905720
  lst_custtab-xblnr = fp_st_bsid-xref1. "(++)PBOSE: 15-05-2017: CR#384: ED2K905720
  lst_custtab-augdt = sy-datum. "Clearing Date
  lst_custtab-ztime = sy-uzeit. "Clearing Date
  lst_custtab-belnr = fp_st_bsid-belnr.
  lst_custtab-vbeln = fp_st_vbak-vbeln.
  lst_custtab-bukrs = fp_st_bsid-bukrs.
  lst_custtab-waers = fp_st_bsid-waers.
  lst_custtab-reference = fp_st_bsid-xblnr.
  lst_custtab-kunnr = fp_st_bsid-kunnr. "Customer number
  lst_custtab-name1 = v_name. "Customer number
  lst_custtab-quote_currency = fp_st_vbak-waerk.
* Begin of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
*  lst_custtab-quote_amount = fp_st_vbak-netwr. "Amount
  lst_custtab-quote_amount = fp_paybl_amt. "Amount
* End of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
  lst_custtab-payment_amount = fp_st_bsid-wrbtr. "Amount
  lst_custtab-posting_date = fp_st_bsid-budat. "Amount
  lst_custtab-sales_area = fp_st_vbak-vkorg. "Amount
  lst_custtab-quote_type = fp_st_vbak-auart.
  lst_custtab-reason_code = fp_st_bsid-flag. "Failed reason
  IF lst_custtab-reason_code = c_b.
    lst_custtab-flreason = text-012.
  ELSEIF lst_custtab-reason_code = c_c.
    lst_custtab-flreason = text-013.
  ELSEIF lst_custtab-reason_code = c_d.
    lst_custtab-flreason = text-014.
  ELSEIF lst_custtab-reason_code = c_e.
    lst_custtab-flreason = text-015.
  ELSEIF lst_custtab-reason_code = c_f.
    lst_custtab-flreason = text-016.
  ELSEIF fp_v_flag_und_tol EQ abap_true.
    lst_custtab-flreason = text-025.
  ELSEIF fp_v_flag_und_amt EQ abap_true.
    lst_custtab-flreason = text-026.
  ELSEIF fp_v_flag_ovr_tol EQ abap_true.
    lst_custtab-flreason = text-027.
  ELSEIF fp_v_flag_ovr_amt EQ abap_true.
    lst_custtab-flreason = text-028.
  ENDIF. " IF lst_custtab-reason_code = c_b
*
  APPEND lst_custtab TO i_custtab_upd.
  INSERT lst_custtab INTO TABLE i_custtab.

  CLEAR lst_custtab.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  TRIGGER_IDOC_RENEWAL_CREATION
*&---------------------------------------------------------------------*
*       For successful records, trigger Idoc to create order
*----------------------------------------------------------------------*
*  -->  fp_st_vbak  TYPE ty_vbak.
*----------------------------------------------------------------------*
FORM f_trigger_idoc_renewal_create USING      fp_i_constant TYPE tt_constant " (++) PBOSE: 02-02-2017: ED2K903276
                                              fp_st_bsid    TYPE ty_bsid
                                              fp_st_vbak    TYPE ty_vbak
                                              fp_v_name     TYPE name1_gp    " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
                                              fp_paybl_amt  TYPE wrbtr       " Amount in Document Currency
                                              fp_tot_paid   TYPE wrbtr       " Amount in Document Currency
                                   CHANGING   fp_i_final    TYPE tt_final.
* Type Declaration
  TYPES:
*  Range Table declaration:
    BEGIN OF lty_ord_type,
      sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
      opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
      low  TYPE auart,      " Sales Document Type
      high TYPE auart,      " Sales Document Type
    END OF lty_ord_type.

* Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720

  DATA:                                         "li_z1qtc_e1edk01_01  TYPE  STANDARD TABLE OF z1qtc_e1edk01_01,
    li_e1edk05           TYPE ztqtc_e1edk05,
    lst_e1edk05          TYPE e1edk05,          " IDoc: Document header conditions
    lst_z1qtc_e1edk01_01 TYPE z1qtc_e1edk01_01, " Header General Data Entension
    lv_zlsch             TYPE schzw_bseg,       " Payment Method
* End of change: PBOSE: 15-05-2017: CR#384: ED2K905720
    lst_final            TYPE ty_final,
    lst_custtab          TYPE zqtclockbox_upd. " Lockbox Renewal

  DATA: li_e1edk14     TYPE ztqtc_e1edk14,        "E1EDK14 table
        li_message     TYPE bapiretct,            "Int table for messages
        li_constant    TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
        lir_ord_type   TYPE STANDARD TABLE OF lty_ord_type INITIAL SIZE 0,
        lst_ord_type   TYPE lty_ord_type,
        lst_constant   TYPE ty_constant,
        li_e1edka1     TYPE ztqtc_e1edka1,        "E1EDKA1 table
        lst_edidd      TYPE zstqtc_idoc_orders05, "EDIDD structure
        lst_edidc      TYPE edidc,                "EDIDC structure
        lst_e1edk14    TYPE e1edk14,              "E1EDK14 structure
        lst_e1edk02    TYPE e1edk02,              " IDoc: Document header reference data  (++) " PBOSE: 13-Jan-2016:
        li_e1edk02     TYPE ztqtc_e1edk02,
        lst_edp21      TYPE edp21,                "Int table for EDP21
        lstqtc_e1edka1 TYPE zstqtc_e1edka1,       "ZSTQTC_E1EDKA1 structure
        lv_auart       TYPE auart,                " Sales Document Type
        lv_vbeln       TYPE vbeln_va,             "Order number
*       Begin of Change: PBOSE: 03-07-2017: ERP-3018: ED2K907088
        lv_port        TYPE char10, " Port of type CHAR10
*       End of Change: PBOSE: 03-07-2017: ERP-3018: ED2K907088

* Begin of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
        lst_vbfa       TYPE ty_vbfa.
* End of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585

  CONSTANTS:                                  "lc_saped2   TYPE char10 VALUE 'SAPED2',   "Port NUmber  "(--) PBOSE: 03-07-2017: ERP-3018: ED2K907088
    lc_orders   TYPE char10 VALUE 'ORDERS',   "Message type
    lc_orders05 TYPE char10 VALUE 'ORDERS05', "Idoc Type
*            Begin of change: PBOSE: 24-Jan-2017:ED2K903276
    lc_z8       TYPE char10 VALUE 'Z8',          "Message variant
    lc_devid    TYPE zdevid        VALUE 'E097', " Type of Identification Code
    lc_ord_type TYPE rvari_vnam    VALUE 'AUART',
* Begin of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
    lc_reason   TYPE rvari_vnam    VALUE 'REASON_CODE', " ABAP: Name of Variant Variable
* End of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
*            End of change: PBOSE: 24-Jan-2017:ED2K903276
    lc_ag       TYPE char10 VALUE 'AG', "Sold to Party
*            Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
    lc_zsub     TYPE char4  VALUE 'ZSUB', " Zsub of type CHAR4
    lc_zsqt     TYPE auart  VALUE 'ZSQT', " Sales Document Type
    lc_zqt      TYPE auart  VALUE 'ZQT',  " Sales Document Type
*            End of change: PBOSE: 15-05-2017: CR#384: ED2K905720
*            Begin of Change: PBOSE: 03-07-2017: ERP-3018: ED2K907088
    lc_sap      TYPE char3  VALUE 'SAP'. " Sap of type CHAR3
*            End of Change: PBOSE: 03-07-2017: ERP-3018: ED2K907088


  lst_final-zzxblnr = fp_st_bsid-xblnr. "Reference field
  lst_final-zzvbeln = fp_st_vbak-vbeln. "Doc number
  lst_final-zzwrbtr = fp_tot_paid. "Amount
  lst_final-zzvgbel = fp_st_vbak-vgbel. "Doc num for Ref Doc
  lst_final-zznetwr = fp_paybl_amt. "Net value of Sales order
  lst_final-zzwaers = fp_st_bsid-waers. "Currency Key
  lst_final-zzkunnr = fp_st_bsid-kunnr. "Cust num
  lst_final-zzblart = fp_st_bsid-blart. "FI Doc type
  lst_final-zzvbtyp = fp_st_vbak-vbtyp. "Order type
  lst_final-zzwaerk = fp_st_vbak-waerk. "Contract Currency
  lst_final-zzbukrs = fp_st_bsid-bukrs. "Company Code
* Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
  lst_final-zzxref1 = fp_st_bsid-xref1.
  lst_final-zzbelnr = fp_st_bsid-belnr.
  lst_final-zzzuonr = fp_st_bsid-zuonr.
  lst_final-zzname1 =  fp_v_name.
* End of change: PBOSE: 15-05-2017: CR#384: ED2K905720
  APPEND lst_final TO fp_i_final.

  SELECT SINGLE
        mandt                "Client
        sndprn               "Partner Number of Sender
        sndprt               "Partner Type of Sender
        sndpfc               "Partner function of sender
        mestyp               "Message Type
        mescod               "Message Code
        mesfct               "Message function
        test                 "Flag for test mode
    FROM edp21               " Partner Profile: Inbound
    INTO lst_edp21
    WHERE mestyp = lc_orders "'ORDERS'
*    Begin of change: PBOSE: 24-Jan-2017:ED2K903276
      AND mescod = lc_z8. "'Z8'
*    End of change: PBOSE: 24-Jan-2017:ED2K903276

* Begin of change: PBOSE: 24-Jan-2016:ED2K903276
  CLEAR lst_constant.
  READ TABLE i_constant INTO lst_constant
                        WITH KEY devid  = lc_devid
                                 param1 = lc_ord_type
                                 BINARY SEARCH.
  IF sy-subrc EQ 0.
* Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
*    lv_auart = lst_constant-low.
    IF fp_st_vbak-auart EQ lc_zsqt.
      lv_auart = lst_constant-low.
    ELSEIF fp_st_vbak-auart EQ lc_zqt.
      lv_auart = lc_zsub.
    ENDIF. " IF fp_st_vbak-auart EQ lc_zsqt
* End of change: PBOSE: 24-Jan-2017:ED2K903276
  ENDIF. " IF sy-subrc EQ 0
*Populating segments of the IDoc
  lst_edidd-e1edk01-curcy = fp_st_vbak-waerk.

*Begin of Del-Anirban-08.07.2017-ED2K907585-Defect 3683
**   Begin of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
*  IF v_flag_und_tol EQ abap_true.
*    READ TABLE i_constant INTO lst_constant
*                        WITH KEY devid  = lc_devid
*                                 param1 = lc_reason
*                                 BINARY SEARCH.
*    IF sy-subrc EQ 0.
*      lst_edidd-e1edk01-augru = lst_constant-low. "'U00
*    ENDIF. " IF sy-subrc EQ 0
*  ENDIF. " IF v_flag_und_tol EQ abap_true
**   End   of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
*Begin of Del-Anirban-08.07.2017-ED2K907585-Defect 3683

*Begin of Add-Anirban-08.07.2017-ED2K907585-Defect 3683
  IF v_flag_ord_rsn EQ abap_true.
    READ TABLE i_constant INTO lst_constant
                        WITH KEY devid  = lc_devid
                                 param1 = lc_reason
                                 BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_edidd-e1edk01-augru = lst_constant-low. "'U00
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF v_flag_und_tol EQ abap_true

*End of Add-Anirban-08.07.2017-ED2K907585-Defect 3683


  CLEAR : lst_e1edk14.
  lst_e1edk14-qualf = '006'. "division
  lst_e1edk14-orgid = fp_st_vbak-spart.
  APPEND lst_e1edk14 TO li_e1edk14.

  CLEAR lst_e1edk14.
  lst_e1edk14-qualf = '007'. "Distribution channel
  lst_e1edk14-orgid = fp_st_vbak-vtweg.
  APPEND lst_e1edk14 TO li_e1edk14.

  CLEAR lst_e1edk14.
  lst_e1edk14-qualf = '008'. "Sales Org
  lst_e1edk14-orgid = fp_st_vbak-vkorg.
  APPEND lst_e1edk14 TO li_e1edk14.

  CLEAR lst_e1edk14.
  lst_e1edk14-qualf = '012'. "Sales order type
  lst_e1edk14-orgid = lv_auart.
  APPEND lst_e1edk14 TO li_e1edk14.
  lst_edidd-e1edk14 = li_e1edk14.

  lstqtc_e1edka1-e1edka1-parvw = lc_ag. "Sold to party
  lstqtc_e1edka1-e1edka1-partn = fp_st_vbak-kunnr.
  APPEND lstqtc_e1edka1 TO li_e1edka1.
  lst_edidd-e1edka1 = li_e1edka1.

* Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720

* Fetch payment method from VBKD table
  SELECT zlsch " Payment Method
    FROM vbkd  " Sales Document: Business Data
    UP TO 1 ROWS
    INTO lv_zlsch
    WHERE vbeln EQ fp_st_vbak-vbeln.
  ENDSELECT.
  IF sy-subrc EQ 0.
* Do nothing
  ENDIF. " IF sy-subrc EQ 0

  CLEAR lst_z1qtc_e1edk01_01.
* Populate payment method
  IF lv_zlsch IS NOT INITIAL.
    lst_z1qtc_e1edk01_01-zlsch = lv_zlsch.
  ELSE. " ELSE -> IF lv_zlsch IS NOT INITIAL
    lst_z1qtc_e1edk01_01-zlsch = '2'.
  ENDIF. " IF lv_zlsch IS NOT INITIAL
  lst_edidd-z1qtc_e1edk01_01 = lst_z1qtc_e1edk01_01.

  CLEAR lst_e1edk05.
  lst_e1edk05-kschl = 'ZPAY'.
*Begin of Del-Anirban-08.31.2017-ED2K908320-Defect 4191
*  lst_e1edk05-betrg = fp_st_bsid-wrbtr.
*End of Del-Anirban-08.31.2017-ED2K908320-Defect 4191

*Begin of Add-Anirban-08.31.2017-ED2K908320-Defect 4191
  lst_e1edk05-betrg = fp_tot_paid.
*End of Add-Anirban-08.31.2017-ED2K908320-Defect 4191
  APPEND lst_e1edk05 TO li_e1edk05.
  lst_edidd-e1edk05 = li_e1edk05.
* End of change: PBOSE: 15-05-2017: CR#384: ED2K905720

* Begin of change: PBOSE: 24-Jan-2017:ED2K903276
  CLEAR lst_e1edk02.
  lst_e1edk02-qualf = '004'.
*  lst_e1edk02-belnr = fp_st_bsid-xblnr. "(--)PBOSE: 15-05-2017: CR#384: ED2K905720
  lst_e1edk02-belnr = fp_st_bsid-xref1. "(++)PBOSE: 15-05-2017: CR#384: ED2K905720
  APPEND lst_e1edk02 TO li_e1edk02.
  lst_edidd-e1edk02 = li_e1edk02.

  CLEAR lst_e1edk02.
  lst_e1edk02-qualf = '011'.
  lst_e1edk02-belnr = fp_st_bsid-xblnr.
  APPEND lst_e1edk02 TO li_e1edk02.
  lst_edidd-e1edk02 = li_e1edk02.

* End of change: PBOSE: 24-Jan-2017:ED2K903276

* Begin of Change: PBOSE: 03-07-2017: ERP-3018: ED2K907088
  CONCATENATE lc_sap sy-sysid INTO lv_port.

* End of Change: PBOSE: 03-07-2017: ERP-3018: ED2K907088
*Populating Control record
  lst_edidc-direct = 2.
*  lst_edidc-rcvpor = lc_saped2.  " (--) PBOSE: 03-07-2017: ERP-3018: ED2K907088
  lst_edidc-rcvpor = lv_port. " (++) PBOSE: 03-07-2017: ERP-3018: ED2K907088
  lst_edidc-rcvprt = lst_edp21-sndprt.
  lst_edidc-rcvprn = lst_edp21-sndprn.
  lst_edidc-mescod = lc_z8.
*  lst_edidc-sndpor = lc_saped2.  " (--) PBOSE: 03-07-2017: ERP-3018: ED2K907088
  lst_edidc-sndpor = lv_port. " (++) PBOSE: 03-07-2017: ERP-3018: ED2K907088
  lst_edidc-sndprt = lst_edp21-sndprt.
  lst_edidc-sndprn = lst_edp21-sndprn.
  lst_edidc-mestyp = lc_orders.
  lst_edidc-idoctp = lc_orders05.
  lst_edidc-cimtyp = 'ZQTCE_ORDERS05_01'.

  CALL FUNCTION 'ZQTC_INBOUND_SAP_ORDERS_FM'
    EXPORTING
      im_edidd   = lst_edidd
      im_edidc   = lst_edidc
    IMPORTING
      ex_vbeln   = lv_vbeln
      ex_message = li_message.

* Begin of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
  IF lv_vbeln IS NOT INITIAL.
    lst_vbfa-vbelv = fp_st_bsid-xref1.
    lst_vbfa-vbeln = lv_vbeln.
    INSERT lst_vbfa INTO TABLE i_vbfa.
    CLEAR lst_vbfa.
  ENDIF. " IF lv_vbeln IS NOT INITIAL
* End of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VAL_BUKRS
*&---------------------------------------------------------------------*
*       Validation Company Code
*----------------------------------------------------------------------*
FORM f_val_bukrs .

*Data Selection
  SELECT bukrs " Company Code
  FROM   t001  " Company Codes
  INTO @DATA(lv_bukrs)
  UP TO 1 ROWS
  WHERE bukrs IN @s_bukrs.
  ENDSELECT.
  IF sy-subrc NE 0.
*Invalid Company Code Message
    MESSAGE e041. " Invalid Company Code
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_TAB_RECORDS
*&---------------------------------------------------------------------*
*       Select data from BSID VBFA VBAK VBAP
*----------------------------------------------------------------------*
*                        <-- fp_i_bsid TYPE tt_bsid
*                        <-- fp_i_vbak TYPE tt_vbak
*                        <-- fp_i_vbfa TYPE tt_vbfa
*                        <-- fp_i_custtab TYPE tt_custtab.
*----------------------------------------------------------------------*
FORM f_tab_records CHANGING fp_i_bsid     TYPE tt_bsid
                            fp_i_vbak     TYPE tt_vbak
                            fp_i_vbap     TYPE tt_vbap     " (++) PBOSE:04-Jan-2017 : ED2K903276
                            fp_i_constant TYPE tt_constant " (++) PBOSE:02-02-2017: ED2K903276
                            fp_i_vbfa     TYPE tt_vbfa
                            fp_i_custtab  TYPE tt_custtab
                            fp_i_kna1     TYPE tt_kna1.
** Data declaration
  DATA: li_bsid1    TYPE tt_bsid1,
        li_vbap_fin TYPE tt_vbap_final,
        li_bsid2    TYPE tt_bsid1,
        li_cus_bsid TYPE tt_bsid,
        lv_wrbtr    TYPE wrbtr, " Amount in Document Currency
        lst_bsid1   TYPE ty_bsid1,
        lst_bsid    TYPE ty_bsid.

* Constant Declaration
  CONSTANTS: lc_b     TYPE c      VALUE 'B',    " B of type Character
             lc_s     TYPE c      VALUE 'S',    " S of type Character
             lc_devid TYPE zdevid VALUE 'E097', " Type of Identification Code " (++) PBOSE:04-Jan-2017 : ED2K903276
             lc_dz    TYPE char2  VALUE 'DZ',   " Dz of type CHAR2
             lc_da    TYPE char2  VALUE 'DA'.   " Document type  " (++) PBOSE: 15-05-2017: CR#384: ED2K905720

* Fetch constant value for order type (ZREW)
  SELECT devid       " Development ID
         param1      " ABAP: Name of Variant Variable
         param2      " ABAP: Name of Variant Variable
         sign        " ABAP: ID: I/E (include/exclude values)
         opti        " ABAP: Selection option (EQ/BT/CP/...)
         low         " Lower Value of Selection Condition
         high        " Upper Value of Selection Condition
         activate    " Activation indicator for constant
    INTO TABLE i_constant
    FROM zcaconstant " Wiley Application Constant Table
    WHERE devid    = lc_devid
      AND activate = abap_true.
  IF sy-subrc EQ 0.
    SORT i_constant BY devid param1.
  ENDIF. " IF sy-subrc EQ 0

* End of change: PBOSE: 02-02-2017: ED2K903276

  IF s_date[] IS INITIAL.
    SELECT bukrs "Company Code
           kunnr "Customer
           zuonr " Assignment Number           " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
           belnr " Accounting Document Number  " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
           budat "Posting Date in the Document   "
           waers "Currency Key
           xblnr "Refernece key
           blart "FI Doc Type
           bschl " Posting Key  " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
           shkzg "Indicator
           wrbtr "Amount
           xref1 " Business Partner Reference Key " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
      FROM bsid  " Accounting: Secondary Index for Customers
      INTO TABLE li_bsid1
*WHERE bukrs = p_bukrs  " (--) PBOSE: 15-05-2017: CR#384: ED2K905720
      WHERE bukrs IN s_bukrs "Company Code
*      AND budat IN i_date_range "Posting dATE
*  AND xblnr NE space   " (--) PBOSE: 15-05-2017: CR#384: ED2K905720
*  AND blart = lc_dz.   " (--) PBOSE: 15-05-2017: CR#384: ED2K905720
        AND ( blart = lc_dz
          OR blart = lc_da )
      AND bschl IN s_bschl
      AND xref1 IN s_xref1.
  ELSE. " ELSE -> IF s_date[] IS INITIAL
    SELECT
           bukrs "Company Code
           kunnr "Customer
           zuonr " Assignment Number           " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
           belnr " Accounting Document Number  " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
           budat "Posting Date in the Document   "
           waers "Currency Key
           xblnr "Refernece key
           blart "FI Doc Type
           bschl " Posting Key  " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
           shkzg "Indicator
           wrbtr "Amount
           xref1 " Business Partner Reference Key " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
FROM bsid        " Accounting: Secondary Index for Customers
INTO TABLE li_bsid1
*WHERE bukrs = p_bukrs  " (--) PBOSE: 15-05-2017: CR#384: ED2K905720
  WHERE bukrs IN s_bukrs
  AND budat IN s_date
*  AND xblnr NE space   " (--) PBOSE: 15-05-2017: CR#384: ED2K905720
*  AND blart = lc_dz.   " (--) PBOSE: 15-05-2017: CR#384: ED2K905720
       AND ( blart = lc_dz
          OR blart = lc_da )
      AND bschl IN s_bschl
      AND xref1 IN s_xref1.
  ENDIF. " IF s_date[] IS INITIAL
  IF sy-subrc = 0.
    SORT li_bsid1.
    CLEAR: lst_bsid1,
           lst_bsid.

* Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
*      LOOP AT li_bsid1 INTO lst_bsid1.
*
*        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*          EXPORTING
*            input  = lst_bsid1-xblnr
*          IMPORTING
*            output = lst_bsid1-xblnr.
*        MOVE-CORRESPONDING lst_bsid1 TO lst_bsid.
*        APPEND lst_bsid TO fp_i_bsid[].
*        APPEND lst_bsid1 TO li_bsid2.
*        CLEAR: lst_bsid1,
*               lst_bsid.
*      ENDLOOP. " LOOP AT li_bsid1 INTO lst_bsid1

    LOOP AT li_bsid1 INTO lst_bsid1.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lst_bsid1-xref1
        IMPORTING
          output = lst_bsid1-xref1.
      MOVE-CORRESPONDING lst_bsid1 TO lst_bsid.
      APPEND lst_bsid TO fp_i_bsid[].
      CLEAR: lst_bsid1,
             lst_bsid.
    ENDLOOP. " LOOP AT li_bsid1 INTO lst_bsid1

* End of change: PBOSE: 15-05-2017: CR#384: ED2K905720

    IF fp_i_bsid[] IS NOT INITIAL.
*       Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
      SELECT kunnr " Customer Number
             name1 " Name 1
      INTO TABLE fp_i_kna1
        FROM kna1  " General Data in Customer Master
        FOR ALL ENTRIES IN fp_i_bsid
        WHERE kunnr = fp_i_bsid-kunnr.
      IF sy-subrc EQ 0.
        SORT fp_i_kna1 BY kunnr.
      ENDIF. " IF sy-subrc EQ 0
*       End of change: PBOSE: 15-05-2017: CR#384: ED2K905720

      SELECT vbeln " Sales Document
             vbtyp " SD document category
             auart " Sales Document Type
             netwr " Net Value of the Sales Order in Document Currency
             waerk " SD Document Currency
             vkorg " Sales Organization
             vtweg " Distribution Channel
             spart " Division
             kunnr " Sold-to party
             vgbel " Document number of the reference document
        FROM vbak  " Sales Document: Header Data
        INTO TABLE fp_i_vbak
        FOR ALL ENTRIES IN fp_i_bsid
*          WHERE vbeln = fp_i_bsid-xblnr  " (--) PBOSE: 15-05-2017: CR#384: ED2K905720
        WHERE vbeln = fp_i_bsid-xref1 " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
          AND vbtyp = lc_b.
      IF sy-subrc = 0.
        SORT fp_i_vbak BY vbeln.
*     Begin of Change: 04-Jan-2017 : PBOSE: ED2K903276
*     Fetch Sales Item data from VBAP table
        SELECT vbeln " Sales Document
               posnr " Sales Document Item
               kzwi6 " Subtotal 6 from pricing procedure for condition
          FROM vbap  " Sales Document: Item Data
          INTO TABLE fp_i_vbap
          FOR ALL ENTRIES IN fp_i_vbak
          WHERE vbeln = fp_i_vbak-vbeln.
        IF sy-subrc EQ 0.
          SORT fp_i_vbap BY vbeln posnr.
        ENDIF. " IF sy-subrc EQ 0
*      End of Change: 04-Jan-2017 : PBOSE: ED2K903276

        SELECT vbelv                           " Preceding sales and distribution document
               vbeln                           " Subsequent sales and distribution document
                FROM vbfa                      " Sales Document Flow
                INTO TABLE fp_i_vbfa
                FOR ALL ENTRIES IN fp_i_vbak
                WHERE vbelv = fp_i_vbak-vbeln. " (++) PBOSE:24-Jan-2017:ED2K903276
        IF sy-subrc = 0.
*          SORT fp_i_vbfa BY vbelv.
          DELETE ADJACENT DUPLICATES FROM fp_i_vbfa COMPARING vbelv.
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF sy-subrc = 0

**Select from custom table for existing error docs
      SELECT *
        FROM zqtclockbox_upd " Lockbox Renewal
        INTO TABLE fp_i_custtab.
      IF sy-subrc IS INITIAL.
* Begin of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
*        SORT fp_i_custtab BY xblnr.
* End of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
      ENDIF. " IF sy-subrc IS INITIAL
      DELETE ADJACENT DUPLICATES FROM fp_i_bsid.
    ENDIF. " IF fp_i_bsid[] IS NOT INITIAL
  ENDIF. " IF sy-subrc = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FINAL_RECORDS
*&---------------------------------------------------------------------*
*       Populate final ALV Table
*----------------------------------------------------------------------*
*      -->fp_I_VBAK[]  text
*      -->FP_I_VBAP[]  Sales Doc.Item data
*      -->fp_I_VBFA[]  text
*      <--fp_I_BSID[]  text
*----------------------------------------------------------------------*
FORM f_final_records  CHANGING fp_i_vbak     TYPE tt_vbak
                               fp_i_vbap     TYPE tt_vbap     " (++) PBOSE: 04-Jan-2017: ED2K903276
                               fp_i_constant TYPE tt_constant " (++) PBOSE: 02-02-2017: ED2K903276
                               fp_i_vbfa     TYPE tt_vbfa
                               fp_i_custtab  TYPE tt_custtab
                               fp_i_bsid     TYPE tt_bsid
                               fp_i_final    TYPE tt_final.

* Type declaration for VBAP
  TYPES : BEGIN OF lty_vbap_final,
            vbeln TYPE vbeln, " Sales and Distribution Document Number
            kzwi6 TYPE kzwi6, " Subtotal 6 from pricing procedure for condition
          END OF lty_vbap_final,

*         Type declarion for amount
          BEGIN OF lty_amount,
            sign TYPE tvarv_sign, " ABAP: ID: I/E (include/exclude values)
            opti TYPE tvarv_opti, " ABAP: Selection option (EQ/BT/CP/...)
            low  TYPE wrbtr,      " Amount in Document Currency
            high TYPE wrbtr,      " Amount in Document Currency
          END OF lty_amount.

* Data Declaration
  DATA: li_vbap_final  TYPE STANDARD TABLE OF lty_vbap_final INITIAL SIZE 0, " IT for VBAP
        li_amount      TYPE STANDARD TABLE OF lty_amount     INITIAL SIZE 0, " IT for Amount
        li_vbap_fin    TYPE STANDARD TABLE OF lty_vbap_final INITIAL SIZE 0, " IT for VBAP
        lst_vbap_final TYPE lty_vbap_final,                                  " WA for VBAP
        lst_vbap_fin   TYPE lty_vbap_final,                                  " WA for VBAP
        lst_constant   TYPE ty_constant,                                     " WA for Constant
        lst_vbap       TYPE ty_vbap,                                         " WA for VBAP
        lst_bsid       TYPE ty_bsid,                                         " WA for BSID
        lst_amount     TYPE lty_amount,                                      " WA for amount
        lst_vbak       TYPE ty_vbak,                                         " WA for VBAK
        lst_vbfa       TYPE ty_vbfa,                                         " WA for VBFA
        lst_kna1       TYPE ty_kna1,                                         " WA for KNA1  " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
        lst_custtab    TYPE zqtclockbox_upd,                                 " Lockbox Renewal
        lst_custtab1   TYPE zqtclockbox_upd,                                 " Lockbox Renewal
        lv_tot_tax     TYPE kzwi6,                                           " Subtotal 6 from pricing procedure for condition
        lv_paybl_amt   TYPE kzwi6,                                           " Subtotal 6 from pricing procedure for condition
        lv_index_val   TYPE sy-index,                                        " ABAP System Field: Loop Index
        lv_index       TYPE sy-index,                                        " ABAP System Field: Loop Index
        lv_vbak_amt    TYPE netwr,                                           " Net Value in Document Currency
        lv_diff        TYPE wrbtr,                                           " Amount in Document Currency
        lv_percent     TYPE i,                                               " Percentage value
        lv_alrd_payamt TYPE wrbtr,                                           " Amount in Document Currency
        lv_tot_paid    TYPE wrbtr,                                           " Amount in Document Currency
        lv_tol_amt     TYPE wrbtr,                                           " Amount in Document Currency
        lv_tol_amt_ls  TYPE wrbtr,                                           " Amount in Document Currency
        lv_tol_amt_hg  TYPE wrbtr,                                           " Amount in Document Currency
        lv_perc        TYPE wrbtr,                                           " Amount in Document Currency
*       Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
        lv_currency    TYPE waers, " Currency for fixed amount
        lv_fix_amt     TYPE wrbtr, " Fixed amount value
        lv_tol_amount  TYPE wrbtr, " Tolerance amount
        lv_less_amount TYPE wrbtr, " Amount in Document Currency
        lv_fixed_amt   TYPE wrbtr, " Fixed amount
*       End of change: PBOSE: 15-05-2017: CR#384: ED2K905720
        lv_tot_bsid    TYPE wrbtr. " Amount in Document Currency


* Constant declaration
  CONSTANTS : lc_devid    TYPE zdevid     VALUE 'E097',    " Identification Code: E097
              lc_percentg TYPE rvari_vnam VALUE 'PERCENT', " Parameter value: PERCENT
              lc_inc      TYPE tvarv_sign VALUE 'I',       " ABAP: ID: I/E (include/exclude values)
              lc_bt       TYPE tvarv_opti VALUE 'BT',      " ABAP: Selection option (EQ/BT/CP/...)
*     Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
              lc_amount   TYPE rvari_vnam VALUE 'AMOUNT',   " ABAP: Selection option (EQ/BT/CP/...)
              lc_currency TYPE rvari_vnam VALUE 'CURRENCY'. " ABAP: Selection option (EQ/BT/CP/...)
*     End of change: PBOSE: 15-05-2017: CR#384: ED2K905720

* Begin of Change: PBOSE: 09-Feb-2017: ED2K903276
  CLEAR lst_constant.
* Read constant table to get tolerance limit
  READ TABLE i_constant INTO lst_constant
                        WITH KEY devid  = lc_devid
                                 param1 = lc_percentg
                                 BINARY SEARCH.
  IF sy-subrc EQ 0.
    lv_percent = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0


* Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
  CLEAR lst_constant.
* Read constant table to get tolerance limit
  READ TABLE i_constant INTO lst_constant
                        WITH KEY devid  = lc_devid
                                 param1 = lc_amount
                                 BINARY SEARCH.
  IF sy-subrc EQ 0.
    lv_fix_amt = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0
* End of change: PBOSE: 15-05-2017: CR#384: ED2K905720

  IF fp_i_vbap[] IS NOT INITIAL.

    LOOP AT fp_i_vbap INTO lst_vbap.
      lst_vbap_fin-vbeln = lst_vbap-vbeln.
      lst_vbap_fin-kzwi6 = lst_vbap-kzwi6.
      APPEND lst_vbap_fin TO li_vbap_fin.
      CLEAR lst_vbap_fin.
    ENDLOOP. " LOOP AT fp_i_vbap INTO lst_vbap

    SORT li_vbap_fin BY vbeln.
*   Summed up tax value irrespective of item value
    LOOP AT li_vbap_fin INTO lst_vbap_fin.
      AT NEW vbeln.
        CLEAR lv_tot_tax.
      ENDAT.
      lv_tot_tax = lv_tot_tax + lst_vbap_fin-kzwi6.
      AT END OF vbeln.
        lst_vbap_final-vbeln = lst_vbap_fin-vbeln.
        lst_vbap_final-kzwi6 = lv_tot_tax.
        APPEND lst_vbap_final TO li_vbap_final.
        CLEAR lst_vbap_final.
      ENDAT.

    ENDLOOP. " LOOP AT li_vbap_fin INTO lst_vbap_fin
  ENDIF. " IF fp_i_vbap[] IS NOT INITIAL

*  If BSID int table is not initial do processing
  IF fp_i_bsid[] IS NOT INITIAL.
    SORT: fp_i_bsid BY xblnr,
          fp_i_vbak BY vbeln.
*          fp_i_vbfa BY vbelv.
*          fp_i_custtab BY xblnr.

* Loop at BSID table , fetch VBAK and VBFA corr. line items
* Check for various conditions of quote price and payments
    LOOP AT fp_i_bsid INTO lst_bsid.

*   Begin of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
      lv_index = sy-tabix.
*   End   of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585

*   Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
      CLEAR v_name.
      READ TABLE i_kna1 INTO lst_kna1 WITH KEY kunnr = lst_bsid-kunnr
                                         BINARY SEARCH.
      IF sy-subrc EQ 0.
        v_name = lst_kna1-name1.
      ENDIF. " IF sy-subrc EQ 0
      CLEAR :lst_vbak,
             lst_vbfa.
*     End of change: PBOSE: 15-05-2017: CR#384: ED2K905720

*   Begin of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
*     lv_index = sy-tabix.
*   End   of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585

      READ TABLE fp_i_vbak INTO lst_vbak
*           WITH KEY vbeln = lst_bsid-xblnr  "(--)PBOSE: 15-05-2017: CR#384: ED2K905720
           WITH KEY vbeln = lst_bsid-xref1 "(++)PBOSE: 15-05-2017: CR#384: ED2K905720
           BINARY SEARCH.
      IF sy-subrc NE 0.
        lst_bsid-flag = c_e. " Record not found
        MODIFY fp_i_bsid FROM lst_bsid INDEX lv_index.
        PERFORM f_update_cust_tab_error_entry USING lst_bsid
                                                    lst_vbak
                                                    lst_vbfa
                                                    lv_paybl_amt
                                                    v_flag_und_tol
                                                    v_flag_und_amt
                                                    v_flag_ovr_tol
                                                    v_flag_ovr_amt
                                            CHANGING fp_i_final.

      ELSE. " ELSE -> IF sy-subrc NE 0
        READ TABLE i_vbap INTO st_vbap
        WITH KEY vbeln = lst_vbak-vbeln
        BINARY SEARCH.
        IF sy-subrc EQ 0.
          " Do nothing
        ENDIF. " IF sy-subrc EQ 0

*       Checking for VBFA-VBELN entry as initial (Renewal already exists)
        READ TABLE fp_i_vbfa INTO lst_vbfa
             WITH KEY vbelv = lst_vbak-vbeln
            BINARY SEARCH.
        IF sy-subrc IS INITIAL. "READ TABLE fp_i_vbfa INTO lst_vbfa
          IF lst_vbfa-vbeln IS NOT INITIAL.
            lst_bsid-flag = c_d. "Renewal already exists
            MODIFY fp_i_bsid FROM lst_bsid INDEX lv_index.
*Begin of Add-Anirban-08.07.2017-ED2K907585-Defect 3683
            READ TABLE i_custtab INTO lst_custtab1 WITH KEY xblnr = lst_vbak-vbeln
                                                belnr = lst_bsid-belnr.
            IF NOT sy-subrc = 0.
*End of Add-Anirban-08.07.2017-ED2K907585-Defect 3683
              PERFORM f_update_cust_tab_error_entry USING lst_bsid
                                                          lst_vbak
                                                          lst_vbfa
                                                          lv_paybl_amt
                                                          v_flag_und_tol
                                                          v_flag_und_amt
                                                          v_flag_ovr_tol
                                                          v_flag_ovr_amt
                                                 CHANGING fp_i_final.
*Begin of Add-Anirban-08.07.2017-ED2K907585-Defect 3683
            ENDIF.
*End of Add-Anirban-08.07.2017-ED2K907585-Defect 3683
          ENDIF. " IF lst_vbfa-vbeln IS NOT INITIAL
          CONTINUE.
        ENDIF. " IF sy-subrc IS INITIAL

*       Checking for quote amount payment Currency
        CLEAR : lv_vbak_amt,
                lv_paybl_amt.

        IF lst_vbak-waerk NE lst_bsid-waers.
          lst_bsid-flag = c_f. " Payment amount is in the wrong currency
          MODIFY fp_i_bsid FROM lst_bsid INDEX lv_index.
          PERFORM f_update_cust_tab_error_entry USING lst_bsid
                                                      lst_vbak
                                                      lst_vbfa
                                                      lv_paybl_amt
                                                      v_flag_und_tol
                                                      v_flag_und_amt
                                                      v_flag_ovr_tol
                                                      v_flag_ovr_amt
                                          CHANGING fp_i_final.
          CONTINUE.
        ELSE. " ELSE -> IF lst_vbak-waerk NE lst_bsid-waers
          lv_vbak_amt = lst_vbak-netwr.
        ENDIF. " IF lst_vbak-waerk NE lst_bsid-waers

        CLEAR : lst_vbap_final,
                lv_tol_amount,
                lv_less_amount,
                lv_tot_tax.

        READ TABLE li_vbap_final INTO lst_vbap_final
                                WITH KEY vbeln = lst_vbak-vbeln
                                BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          lv_tot_tax = lst_vbap_final-kzwi6.
        ENDIF. " IF sy-subrc IS INITIAL

        lv_paybl_amt = lv_vbak_amt + lv_tot_tax.

        CLEAR lv_alrd_payamt.
* Checking payment amount .
        IF lst_bsid-wrbtr LT lv_paybl_amt.

          READ TABLE fp_i_custtab TRANSPORTING NO FIELDS WITH KEY vbeln       = lst_bsid-xref1
                                                                  belnr       = lst_bsid-belnr
                                                                  reason_code = c_b.
          IF sy-subrc NE 0.
*         Looping through custom table to get alreadt paid amount if any.
            IF lst_bsid-wrbtr  LT lv_paybl_amt.
              lst_bsid-flag = c_b.
            ELSEIF lst_bsid-wrbtr  GT lv_paybl_amt.
              lst_bsid-flag = c_c.
            ENDIF. " IF lst_bsid-wrbtr LT lv_paybl_amt

            PERFORM f_update_cust_tab_error_entry USING lst_bsid
                                                        lst_vbak
                                                        lst_vbfa
                                                        lv_paybl_amt
                                                        v_flag_und_tol
                                                        v_flag_und_amt
                                                        v_flag_ovr_tol
                                                        v_flag_ovr_amt
                                              CHANGING fp_i_final.

          ENDIF. " IF sy-subrc NE 0
          READ TABLE fp_i_custtab  INTO lst_custtab1
                                   WITH KEY xblnr = lst_vbak-vbeln
                                   BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            lv_index_val = sy-tabix.
            LOOP AT fp_i_custtab INTO lst_custtab FROM lv_index_val.
              IF lst_vbak-vbeln NE lst_custtab-xblnr.
                EXIT.
              ELSE. " ELSE -> IF lst_vbak-vbeln NE lst_custtab-xblnr
                IF lst_custtab-reason_code EQ c_b.
                  lv_alrd_payamt = lv_alrd_payamt + lst_custtab-payment_amount.
                ENDIF. " IF lst_custtab-reason_code EQ c_b
              ENDIF. " IF lst_vbak-vbeln NE lst_custtab-xblnr
            ENDLOOP. " LOOP AT fp_i_custtab INTO lst_custtab FROM lv_index_val
          ENDIF. " IF sy-subrc IS INITIAL

          CLEAR : lv_index_val,
                  lv_tot_paid,
                  lv_perc,
                  lv_tol_amt_ls,
                  lv_tol_amt_hg.

*         Give 5% variation flexibility. if diff more than 5% then update cust table
*          lv_tot_paid = lv_alrd_payamt + lst_bsid-wrbtr.
          lv_tot_paid = lv_alrd_payamt.
          lv_perc = ( lv_percent * lv_paybl_amt ) / 100.
          lv_tol_amt_ls = lv_paybl_amt - lv_perc.

*   Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
*          lv_tol_amt_hg = lv_paybl_amt + lv_perc.

**         Populate higher limit and lower limit in a range table.
*          CLEAR li_amount.
*          lst_amount-sign = lc_inc.
*          lst_amount-opti = lc_bt.
*          lst_amount-low  = lv_tol_amt_ls.
*          lst_amount-high = lv_tol_amt_hg.
*          APPEND lst_amount TO li_amount.
*          CLEAR lst_amount.

          CLEAR lst_constant.
* Read constant table to get tolerance limit
          READ TABLE i_constant INTO lst_constant
                                WITH KEY devid  = lc_devid
                                         param1 = lc_currency
                                         param2 = lst_bsid-bukrs
                                         BINARY SEARCH.
          IF sy-subrc EQ 0.
            lv_currency = lst_constant-low.
          ENDIF. " IF sy-subrc EQ 0

          IF lst_vbak-waerk NE lv_currency.
            CALL FUNCTION 'CONVERT_AMOUNT_TO_CURRENCY'
              EXPORTING
                date             = sy-datum
                foreign_currency = lst_vbak-waerk
                foreign_amount   = lv_fix_amt
                local_currency   = lst_vbak-waerk
              IMPORTING
                local_amount     = lv_fixed_amt
              EXCEPTIONS
                error            = 1
                OTHERS           = 2.
            IF sy-subrc EQ 0.
              lv_fix_amt = lv_fixed_amt.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF lst_vbak-waerk NE lv_currency

          lv_less_amount = lv_paybl_amt - lv_fix_amt.

*         Finf out Tolerance percentage or fixed value which one is lesser
          IF lv_less_amount GT lv_tol_amt_ls.
            lv_tol_amount = lv_less_amount.
            v_flag_und_amt = abap_true.
          ELSE. " ELSE -> IF lv_less_amount GT lv_tol_amt_ls
            lv_tol_amount = lv_tol_amt_ls.
            v_flag_und_tol = abap_true.
          ENDIF. " IF lv_less_amount GT lv_tol_amt_ls

*Begin of Add-Anirban-08.07.2017-ED2K907585-Defect 3683
          IF ( lv_tot_paid LT lv_paybl_amt AND ( lv_tot_paid GT lv_less_amount OR lv_tot_paid GT lv_tol_amt_ls ) ).
            v_flag_ord_rsn = abap_true.
          ENDIF.
*End of Add-Anirban-08.07.2017-ED2K907585-Defect 3683

*         Populate higher limit and lower limit in a range table.
          CLEAR li_amount.
          lst_amount-sign = lc_inc.
          lst_amount-opti = lc_bt.
          lst_amount-low  = lv_tol_amount.
          lst_amount-high = lv_paybl_amt.
          APPEND lst_amount TO li_amount.
          CLEAR : lst_amount.

*   End of change: PBOSE: 15-05-2017: CR#384: ED2K905720

*         Check if total paid amt less than equal tolerance value 5%
          IF lv_tot_paid IN li_amount. "5
*          IF lv_tot_paid EQ lv_tol_amount.
*           Populate success message
            lst_bsid-flag = c_a. " Success , quote amt = payment amount
            MODIFY fp_i_bsid FROM lst_bsid INDEX lv_index.
*           Triggering IDOC to create subscription order
            PERFORM f_trigger_idoc_renewal_create USING    i_constant " (++) PBOSE: 02-02-2017: ED2K903276
                                                           lst_bsid
                                                           lst_vbak
                                                           v_name     " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
                                                           lv_paybl_amt
                                                           lv_tot_paid
                                                  CHANGING fp_i_final.

*           Delete entry which are already used.
            PERFORM f_delete_cust_tab_error_entry USING lst_bsid-xref1.


*            ELSEIF lv_tot_paid LT lv_tol_amount. " lv_tol_amt_ls  " (--)PBOSE: 15-05-2017: CR#384: ED2K905720
*
**           Payment amount is not matching after adding amount value also
*              lst_bsid-flag = c_b. " Payment amount is less than quote amount
*
**           Update custom table when error occurs
*              PERFORM f_update_cust_tab_error_entry USING lst_bsid
*                                                        lst_vbak
*                                                        lst_vbfa
*                                                        lv_paybl_amt
*                                                        v_flag_und_tol
*                                                        v_flag_und_amt
*                                                        v_flag_ovr_tol
*                                                        v_flag_ovr_amt
*                                              CHANGING fp_i_final.
*
*
*            ELSEIF lv_tot_paid GT lv_tol_amt_hg.
**           Payment amount is not matching after adding amount value also
*              lst_bsid-flag = c_c. " Quote amount lesser than payment amount
**           Update custom table when error occurs
*              PERFORM f_update_cust_tab_error_entry USING lst_bsid
*                                                        lst_vbak
*                                                        lst_vbfa
*                                                        lv_paybl_amt
*                                                        v_flag_und_tol
*                                                        v_flag_und_amt
*                                                        v_flag_ovr_tol
*                                                        v_flag_ovr_amt
*                                              CHANGING fp_i_final.


          ENDIF. " IF lv_tot_paid IN li_amount

*  If payment amount is same as quotation amount
        ELSEIF lst_bsid-wrbtr EQ lv_paybl_amt.

*         Populate success message
          lst_bsid-flag = c_a. " Success , quote amt = payment amount
          MODIFY fp_i_bsid FROM lst_bsid INDEX lv_index.
*         Triggering IDOC to create subscription order
          PERFORM f_trigger_idoc_renewal_create USING    i_constant
                                                         lst_bsid
                                                         lst_vbak
                                                         v_name
                                                         lv_paybl_amt
                                                         lst_bsid-wrbtr
                                                CHANGING fp_i_final.
*         Delete entry which are already used.
          PERFORM f_delete_cust_tab_error_entry USING lst_bsid-xref1.

        ELSEIF lst_bsid-wrbtr GT lv_paybl_amt.

          CLEAR : lv_perc,
                  lv_tol_amt.
          lv_perc = ( lv_percent * lv_paybl_amt ) / 100.
          lv_tol_amt = lv_perc + lv_paybl_amt.

*   Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
*         Read constant table to get tolerance limit
          READ TABLE i_constant INTO lst_constant
                                WITH KEY devid  = lc_devid
                                         param1 = lc_currency
                                         param2 = lst_bsid-bukrs
                                         BINARY SEARCH.
          IF sy-subrc EQ 0.
            lv_currency = lst_constant-low.
          ENDIF. " IF sy-subrc EQ 0

          IF lst_vbak-waerk NE lv_currency.
            CALL FUNCTION 'CONVERT_AMOUNT_TO_CURRENCY'
              EXPORTING
                date             = sy-datum
                foreign_currency = lst_vbak-waerk
                foreign_amount   = lv_fix_amt
                local_currency   = lst_vbak-waerk
              IMPORTING
                local_amount     = lv_fixed_amt
              EXCEPTIONS
                error            = 1
                OTHERS           = 2.
            IF sy-subrc EQ 0.
              lv_fix_amt = lv_fixed_amt.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF lst_vbak-waerk NE lv_currency

          lv_less_amount = lv_paybl_amt + lv_fix_amt.

*         Find out Tolerance percentage or fixed value which one is lesser
          IF lv_less_amount GT lv_tol_amt.
            lv_tol_amount = lv_tol_amt.
            v_flag_ovr_tol = abap_true.
          ELSE. " ELSE -> IF lv_less_amount GT lv_tol_amt
            lv_tol_amount = lv_less_amount.
            v_flag_ovr_amt = abap_true.
          ENDIF. " IF lv_less_amount GT lv_tol_amt

*         Populate higher limit and lower limit in a range table.
          CLEAR li_amount.
          lst_amount-sign = lc_inc.
          lst_amount-opti = lc_bt.
          lst_amount-low  = lv_paybl_amt.
*          lst_amount-high = lv_tol_amt.  " (--)PBOSE: 15-05-2017: CR#384: ED2K905720
          lst_amount-high = lv_tol_amount.
          APPEND lst_amount TO li_amount.
          CLEAR lst_amount.

          IF lst_bsid-wrbtr IN li_amount.
*           Populate success message
            lst_bsid-flag = c_a. " Success , quote amt = payment amount
            MODIFY fp_i_bsid FROM lst_bsid INDEX lv_index.
*           Triggering IDOC to create subscription order
            PERFORM f_trigger_idoc_renewal_create USING    i_constant " (++) PBOSE: 02-02-2017: ED2K903276
                                                           lst_bsid
                                                           lst_vbak
                                                           v_name     " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
                                                           lv_paybl_amt
                                                           lst_bsid-wrbtr
                                                  CHANGING fp_i_final.
*           Delete entry which are already used.
            PERFORM f_delete_cust_tab_error_entry USING lst_bsid-xref1.

          ELSE. " ELSE -> IF lst_bsid-wrbtr IN li_amount
*            lst_bsid-flag = c_c. " Payment amount is greater than quote amount
*           Update custom table when error occurs
            PERFORM f_update_cust_tab_error_entry USING lst_bsid
                                                        lst_vbak
                                                        lst_vbfa
                                                        lv_paybl_amt
                                                        v_flag_und_tol
                                                        v_flag_und_amt
                                                        v_flag_ovr_tol
                                                        v_flag_ovr_amt
                                               CHANGING fp_i_final.
          ENDIF. " IF lst_bsid-wrbtr IN li_amount
        ENDIF. " IF lst_bsid-wrbtr LT lv_paybl_amt
*        ENDAT.
      ENDIF. " IF sy-subrc NE 0
* Begin of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
      CLEAR: v_flag_und_tol,
             v_flag_und_amt,
             v_flag_ovr_tol,
             v_flag_ovr_amt,
             v_name.
* End of change: LKODWANI: 28-07-2017: ERP-3178: ED2K907585
    ENDLOOP. " LOOP AT fp_i_bsid INTO lst_bsid

    IF i_custtab_upd IS NOT INITIAL.
      PERFORM f_update_lockbox_upd.
    ENDIF. " IF i_custtab_upd IS NOT INITIAL

  ENDIF. " IF fp_i_bsid[] IS NOT INITIAL
* End of Change: PBOSE: 09-Feb-2017: ED2K903276
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       Build Field catalog
*----------------------------------------------------------------------*
FORM f_build_fieldcat .

  CONSTANTS:
********Fields**********************************************************
    lc_xblnr  TYPE char10 VALUE 'ZZXBLNR', " Xblnr of type CHAR10
    lc_vbeln  TYPE char10 VALUE 'ZZVBELN', " Vbeln of type CHAR10
    lc_wrbtr  TYPE char10 VALUE 'ZZWRBTR', " Wrbtr of type CHAR10
    lc_vgbel  TYPE char10 VALUE 'ZZVGBEL', " Vgbel of type CHAR10
    lc_netwr  TYPE char10 VALUE 'ZZNETWR', " Netwr of type CHAR10
    lc_waers  TYPE char10 VALUE 'ZZWAERS', " Waers of type CHAR10
    lc_kunnr  TYPE char10 VALUE 'ZZKUNNR', " Kunnr of type CHAR10
    lc_blart  TYPE char10 VALUE 'ZZBLART', " Blart of type CHAR10
    lc_vbtyp  TYPE char10 VALUE 'ZZVBTYP', " Vbtyp of type CHAR10
    lc_waerk  TYPE char10 VALUE 'ZZWAERK', " Waerk of type CHAR10
    lc_bukrs  TYPE char10 VALUE 'ZZBUKRS', " Bukrs of type CHAR10
*   Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
    lc_xref1  TYPE char10 VALUE 'ZZXREF1',  " Xref1 of type CHAR10
    lc_belnr  TYPE char10 VALUE 'ZZBELNR',  " Belnr of type CHAR10
    lc_zuonr  TYPE char10 VALUE 'ZZZUONR',  " Zuonr of type CHAR10
    lc_name1  TYPE char10 VALUE 'ZZNAME1',  " Name1 of type CHAR10
    lc_reason TYPE char10 VALUE 'ZZREASON'. " Reason of type CHAR10
*   End of change: PBOSE: 15-05-2017: CR#384: ED2K905720

  PERFORM f_populate_catalog USING :
      lc_xblnr   text-001,
      lc_vbeln   text-002,
      lc_wrbtr   text-003,
      lc_vgbel   text-004,
      lc_netwr   text-005,
      lc_waers   text-006,
      lc_kunnr   text-007,
      lc_blart   text-008,
      lc_vbtyp   text-009,
      lc_waerk   text-010,
      lc_bukrs   text-011,
*     Begin of change: PBOSE: 15-05-2017: CR#384: ED2K905720
      lc_xref1   text-020,
      lc_belnr   text-023,
      lc_zuonr   text-024,
      lc_name1   text-021,
      lc_reason  text-022.
*     End of change: PBOSE: 15-05-2017: CR#384: ED2K905720

  CLEAR v_count.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_CATALOG
*&---------------------------------------------------------------------*
*       Populate field catalog
*----------------------------------------------------------------------*
*      -->fp_LC_FLAID  text
*      -->fp_0490   text
*----------------------------------------------------------------------*
FORM f_populate_catalog  USING  fp_fname
                                fp_text.
*** Local work area of field catalogue.
  DATA : lst_fcat TYPE slis_fieldcat_alv,
         lv_pos   TYPE int4. " Natural Number

  CONSTANTS: lc_tabname TYPE char30 VALUE 'I_FINAL'. " Tabname of type CHAR30

* Populating Catalogue
  v_count = v_count + 1.
  lst_fcat-col_pos        = v_count.
  lst_fcat-fieldname      = fp_fname.
  lst_fcat-seltext_l      = fp_text.
  lst_fcat-tabname        = lc_tabname.

* Append the work area to the internal table
  APPEND   lst_fcat TO i_fieldcat.
* Clear the work area
  CLEAR   lst_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LAYOUT
*&---------------------------------------------------------------------*
*       Layout building for ALV
*----------------------------------------------------------------------*
*      <--fp_ST_LAYOUT
*----------------------------------------------------------------------*
FORM f_layout  CHANGING fp_st_layout TYPE slis_layout_alv.
  CLEAR fp_st_layout.

  fp_st_layout-zebra = abap_true.
  fp_st_layout-colwidth_optimize = abap_true. "adjusting column

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRID_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->fp_I_FIELDCAT
*      -->fp_ST_LAYOUT
*      -->fp_I_FINAL[]
*----------------------------------------------------------------------*
FORM f_grid_display  USING    fp_i_fieldcat    TYPE slis_t_fieldcat_alv
                              fp_st_layout     TYPE slis_layout_alv
                              fp_i_final         TYPE tt_final.

* Call FM for ALV Grid Display
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = fp_st_layout
      it_fieldcat        = fp_i_fieldcat
      i_save             = abap_true
    TABLES
      t_outtab           = fp_i_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LASTRUNDATE
*&---------------------------------------------------------------------*
*       Form to determine last run date of interface prog
*----------------------------------------------------------------------*
FORM f_lastrundate .
*--------------------------------------------------------------------*
*    W O R K - A R E A
*--------------------------------------------------------------------*
  DATA: lst_time_range     TYPE ty_uzeit,
        lst_zcaint_lastrun TYPE ty_zcaint,
        lst_date_range     TYPE ty_datum.
*--------------------------------------------------------------------*
*    C O N S T A N T S
*--------------------------------------------------------------------*
  CONSTANTS: lc_devid  TYPE zdevid     VALUE 'E097',    " Development ID
             lc_param1 TYPE rvari_vnam VALUE 'RUNDATE', " ABAP: Name of Variant Variable
             lc_param2 TYPE rvari_vnam VALUE '001'.     " ABAP: Name of Variant Variable

  CONSTANTS: c_sign    TYPE tvarv_sign VALUE 'I',  " ABAP: ID: I/E (include/exclude values)
             c_opti    TYPE tvarv_opti VALUE 'EQ', " ABAP: Selection option (EQ/BT/CP/...)
             c_opti_bt TYPE tvarv_opti VALUE 'BT', " ABAP: Selection option (EQ/BT/CP/...)
             c_opti_ge TYPE tvarv_opti VALUE 'GE', " ABAP: Selection option (EQ/BT/CP/...)
             c_opti_lt TYPE tvarv_opti VALUE 'LT'. " ABAP: Selection option (EQ/BT/CP/...)

  IF s_date IS INITIAL.
    SELECT SINGLE mandt      " Client
                  devid      " Development ID
                  param1     " ABAP: Name of Variant Variable
                  param2     " ABAP: Name of Variant Variable
                  lrdat      " Last run date
                  lrtime     " Last run time
           FROM zcainterface " Interface run details
           INTO lst_zcaint_lastrun
           WHERE devid  EQ lc_devid
           AND   param1 EQ lc_param1
           AND   param2 EQ lc_param2.
    IF sy-subrc = 0.

      lst_date_range-sign    = c_sign.
      lst_date_range-option  = c_opti_ge.
      lst_date_range-low     = lst_zcaint_lastrun-lrdat.
      APPEND lst_date_range TO  i_date_range.
      CLEAR lst_date_range.


      lst_time_range-sign    = c_sign.
      lst_time_range-option  = c_opti_lt.
      lst_time_range-low     = lst_zcaint_lastrun-lrtime.
      APPEND lst_time_range      TO  i_uzeit.
      CLEAR lst_time_range.

*     Update the Record in ZCAINTERFACE table

      CLEAR lst_zcaint_lastrun.
      lst_zcaint_lastrun-mandt  = sy-mandt.
      lst_zcaint_lastrun-devid  =	lc_devid.
      lst_zcaint_lastrun-param1	= lc_param1.
      lst_zcaint_lastrun-param2	= lc_param2.
      lst_zcaint_lastrun-lrdat  = sy-datum.
      lst_zcaint_lastrun-lrtime	= sy-uzeit.
* Enqueue cust table lock object
      CALL FUNCTION 'ENQUEUE_EZCAINTERFACE'
        EXPORTING
          mode_zcainterface = abap_true
          mandt             = sy-mandt
          devid             = lc_devid
          param1            = lc_param1
          param2            = lc_param2
          x_devid           = abap_true
          x_param1          = abap_true
          x_param2          = abap_true
          _scope            = c_2
        EXCEPTIONS
          foreign_lock      = 1
          system_failure    = 2.
      IF sy-subrc IS INITIAL.
        UPDATE zcainterface FROM lst_zcaint_lastrun.
        IF sy-subrc IS INITIAL.
* Dequeue cust table lock object
          CALL FUNCTION 'DEQUEUE_EZCAINTERFACE'
            EXPORTING
              mode_zcainterface = abap_true "'X'
              mandt             = sy-mandt
              devid             = lc_devid
              param1            = lc_param1
              param2            = lc_param2
              x_devid           = abap_true "'X'
              x_param1          = abap_true "'X'
              x_param2          = abap_true "'X'
              _scope            = c_3.
        ENDIF. " IF sy-subrc IS INITIAL
      ENDIF. " IF sy-subrc IS INITIAL
    ELSE. " ELSE -> IF sy-subrc = 0
      " Where we need to create the new record.

      CLEAR lst_zcaint_lastrun.
      lst_zcaint_lastrun-mandt  = sy-mandt.
      lst_zcaint_lastrun-devid  =	lc_devid.
      lst_zcaint_lastrun-param1	= lc_param1.
      lst_zcaint_lastrun-param2	= lc_param2.
      lst_zcaint_lastrun-lrdat  = sy-datum.
      lst_zcaint_lastrun-lrtime	= sy-uzeit.
* Enqueue cust table lock object
      CALL FUNCTION 'ENQUEUE_EZCAINTERFACE'
        EXPORTING
          mode_zcainterface = abap_true
          mandt             = sy-mandt
          _scope            = c_2
        EXCEPTIONS
          foreign_lock      = 1
          system_failure    = 2.

      IF sy-subrc IS INITIAL.
        INSERT zcainterface FROM lst_zcaint_lastrun.
        IF sy-subrc IS INITIAL.
* Dequeue cust table lock object
          CALL FUNCTION 'DEQUEUE_EZCAINTERFACE'
            EXPORTING
              mode_zcainterface = abap_true "'X'
              mandt             = sy-mandt
              _scope            = c_3.
        ENDIF. " IF sy-subrc IS INITIAL
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF s_date IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DELETE_CUST_TAB_ERROR_ENTRY
*&---------------------------------------------------------------------*
*       Delete error entry cust table after processing it
*----------------------------------------------------------------------*
*  -->   fp_xblnr TYPE char10
*----------------------------------------------------------------------*
FORM f_delete_cust_tab_error_entry USING fp_xblnr TYPE char10. " Delete_cust_tab_error_e of type CHAR10

  DELETE i_custtab_upd WHERE xblnr = fp_xblnr.

* Enqueue cust table lock object
  CALL FUNCTION 'ENQUEUE_EZQTCLOCKBOX_UPD'
    EXPORTING
      mode_zqtclockbox_upd = abap_true
      mandt                = sy-mandt
      xblnr                = fp_xblnr
      x_xblnr              = abap_true
      _scope               = c_2
    EXCEPTIONS
      foreign_lock         = 1
      system_failure       = 2
      OTHERS               = 3.

  IF sy-subrc = 0.
    DELETE FROM zqtclockbox_upd WHERE xblnr =  fp_xblnr.
    COMMIT WORK.
* Dequeue cust table lock object
    CALL FUNCTION 'DEQUEUE_EZQTCLOCKBOX_UPD'
      EXPORTING
        mode_zqtclockbox_upd = abap_true
        mandt                = sy-mandt
        xblnr                = fp_xblnr
        _scope               = c_3.

  ENDIF. " IF sy-subrc = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_BLART
*&---------------------------------------------------------------------*
*  Validate document type (BLART)
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_blart.

*Data Selection
  SELECT blart " Document Type
  FROM   t003  " Document Types
  INTO @DATA(lv_blart)
  UP TO 1 ROWS
  WHERE blart IN @s_blart.
  ENDSELECT.
  IF sy-subrc NE 0.
*Invalid Company Code Message
    MESSAGE e212. "Invalid Document Type
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_LOCKBOX_UPD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_lockbox_upd .


  IF i_custtab_upd IS NOT INITIAL.

    CALL FUNCTION 'ENQUEUE_E_TABLE'
      EXPORTING
        tabname        = 'ZQTCLOCKBOX_UPD'
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.

    IF sy-subrc EQ 0.
*    Updating custom table
      MODIFY zqtclockbox_upd FROM TABLE i_custtab_upd.

      CALL FUNCTION 'DEQUEUE_E_TABLE'
        EXPORTING
          tabname = 'ZQTCLOCKBOX_UPD'.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF i_custtab_upd IS NOT INITIAL
ENDFORM.
