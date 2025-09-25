*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_AUTO_LOCKBOX_SUB
* PROGRAM DESCRIPTION: Automated Lockbox Renewals Sub routines
* DEVELOPER: Anirban Saha
* CREATION DATE: 09/05/2017
* OBJECT ID: E097
* TRANSPORT NUMBER(S): ED2K908367
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K908320
* REFERENCE NO: ERP-5005
* DEVELOPER:    Srabanti Bose(SRBOSE)/Pavan Bandlapalli(PBANDLAPAL)
* DATE:         08-Dec-2017
* DESCRIPTION: 1.Additional filter criteria code for REference Document S_REF1
*              has been added as XREF1 field is character field its even
*              considering the records that have length less than the one
*              entered.
*              2. Custom table ZQTCLOCKBOX_UPD for field XBLNR data element is
*                changed so that only the values entered in the range are displayed.
*                As previously it was the character field it was not filtering properly.
*              3. Added the logic to populate the i_final internal table to display
*                 in the output.
*              4. Adjusted the logic for tolerance.
*              5. Added the new reason code 'X' to update in custom table to
*                 populate any error messages during order creation.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K910300
* REFERENCE NO: ERP-5879
* DEVELOPER:    Writtick Roy (WROY)
* DATE:         15-Jan-2018
* DESCRIPTION: 1.Pass Customer PO while populating the IDOC Segments
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
  lst_custtab-quote_amount = fp_paybl_amt. "Amount
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

  APPEND lst_custtab TO i_custtab_upd.
  INSERT lst_custtab INTO TABLE i_custtab.

  CLEAR lst_custtab.

* BOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
  CLEAR lst_final.
  lst_final-zzxblnr = fp_st_bsid-xblnr. "Reference field
  lst_final-zzvbeln = fp_st_vbak-vbeln. "Doc number
  lst_final-zzwrbtr = fp_st_bsid-wrbtr. "Amount
  lst_final-zzvgbel = fp_st_vbak-vgbel. "Doc num for Ref Doc
  lst_final-zznetwr = fp_paybl_amt. "Net value of Sales order
  lst_final-zzwaers = fp_st_bsid-waers. "Currency Key
  lst_final-zzkunnr = fp_st_bsid-kunnr. "Cust num
  lst_final-zzblart = fp_st_bsid-blart. "FI Doc type
  lst_final-zzvbtyp = fp_st_vbak-vbtyp. "Order type
  lst_final-zzwaerk = fp_st_vbak-waerk. "Contract Currency
  lst_final-zzbukrs = fp_st_bsid-bukrs. "Company Code
  lst_final-zzxref1 = fp_st_bsid-xref1.
  lst_final-zzbelnr = fp_st_bsid-belnr.
  lst_final-zzzuonr = fp_st_bsid-zuonr.
  lst_final-zzname1 =  v_name.
  lst_final-zzmessage = lst_custtab-flreason.
  lst_final-zzstatus = icon_red_light.
  APPEND lst_final TO fp_i_final.
* EOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320

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
                                              fp_ord_reason TYPE char3       " Order Reason Code
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

  DATA:                                         "li_z1qtc_e1edk01_01  TYPE  STANDARD TABLE OF z1qtc_e1edk01_01,
    li_e1edk05           TYPE ztqtc_e1edk05,
    lst_e1edk05          TYPE e1edk05,          " IDoc: Document header conditions
    lst_z1qtc_e1edk01_01 TYPE z1qtc_e1edk01_01, " Header General Data Entension
    lv_zlsch             TYPE schzw_bseg,       " Payment Method
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
        lv_port        TYPE char10, " Port of type CHAR10
        lst_vbfa       TYPE ty_vbfa.

  CONSTANTS:
    lc_orders    TYPE char10 VALUE 'ORDERS',   "Message type
    lc_orders05  TYPE char10 VALUE 'ORDERS05', "Idoc Type
    lc_z8        TYPE char10 VALUE 'Z8',          "Message variant
    lc_devid     TYPE zdevid        VALUE 'E097', " Type of Identification Code
    lc_ord_type  TYPE rvari_vnam    VALUE 'AUART',
    lc_reason    TYPE rvari_vnam    VALUE 'REASON_CODE', " ABAP: Name of Variant Variable
* BOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
    lc_msgtyp_a  TYPE bapi_mtype VALUE 'A',
    lc_msgtyp_e  TYPE bapi_mtype VALUE 'E',
    lc_msgtyp_i  TYPE bapi_mtype VALUE 'I',
    lc_others    TYPE char1 VALUE 'X',
    lc_over_pay  TYPE rvari_vnam VALUE 'OVER_PAY',
    lc_under_pay TYPE rvari_vnam VALUE 'UNDER_PAY',
* EOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
*    lc_u00      TYPE rvari_vnam    VALUE 'U00', "Underpayment with Tolerance
*    lc_o01      TYPE rvari_vnam    VALUE 'O01', "Underpayment with Tolerance
    lc_ag        TYPE char10 VALUE 'AG', "Sold to Party
    lc_zsub      TYPE char4  VALUE 'ZSUB', " Zsub of type CHAR4
    lc_zsqt      TYPE auart  VALUE 'ZSQT', " Sales Document Type
    lc_zqt       TYPE auart  VALUE 'ZQT',  " Sales Document Type
    lc_sap       TYPE char3  VALUE 'SAP'. " Sap of type CHAR3

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
  lst_final-zzxref1 = fp_st_bsid-xref1.
  lst_final-zzbelnr = fp_st_bsid-belnr.
  lst_final-zzzuonr = fp_st_bsid-zuonr.
  lst_final-zzname1 =  fp_v_name.
*  APPEND lst_final TO fp_i_final.   (--SRBOSE #ERP:5005 #TR:ED2K908320)

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
      AND mescod = lc_z8. "'Z8'

  CLEAR lst_constant.
  READ TABLE i_constant INTO lst_constant
                        WITH KEY devid  = lc_devid
                                 param1 = lc_ord_type
                                 BINARY SEARCH.
  IF sy-subrc EQ 0.
    IF fp_st_vbak-auart EQ lc_zsqt.
      lv_auart = lst_constant-low.
    ELSEIF fp_st_vbak-auart EQ lc_zqt.
      lv_auart = lc_zsub.
    ENDIF. " IF fp_st_vbak-auart EQ lc_zsqt
  ENDIF. " IF sy-subrc EQ 0
*---Begin of VDPATABALL ERPM-2126 - WLS Realization - WRICEF E097 Automated Renewal Triggering
  IF lv_auart IS INITIAL.
    SELECT SINGLE auara FROM tvak INTO @DATA(lv_cont_auart) WHERE auart  = @fp_st_vbak-auart.
    IF sy-subrc = 0.
      lv_auart = lv_cont_auart.
    ENDIF.
  ENDIF.
*---End of VDPATABALL ERPM-2126 - WLS Realization - WRICEF E097 Automated Renewal Triggering
*Populating segments of the IDoc
  lst_edidd-e1edk01-curcy = fp_st_vbak-waerk.

* Populate Order reason code in Idoc
* BOC by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
*  IF NOT fp_ord_reason IS INITIAL.
*    CLEAR : lst_constant.
*    READ TABLE i_constant INTO lst_constant
*                      WITH KEY devid  = lc_devid
*                               param1 = lc_reason
*                               param2 = fp_ord_reason
*                               BINARY SEARCH.
*
*    IF sy-subrc = 0.
*      lst_edidd-e1edk01-augru = lst_constant-low. "O01
*    ENDIF.
*  ENDIF.
  IF fp_tot_paid LT fp_paybl_amt.
    CLEAR : lst_constant.
    READ TABLE i_constant INTO lst_constant
                      WITH KEY devid  = lc_devid
                               param1 = lc_reason
                               param2 = lc_under_pay
                               BINARY SEARCH.

    IF sy-subrc = 0.
      lst_edidd-e1edk01-augru = lst_constant-low. "O01
    ENDIF.
  ELSEIF fp_tot_paid GT fp_paybl_amt.
    CLEAR : lst_constant.
    READ TABLE i_constant INTO lst_constant
                      WITH KEY devid  = lc_devid
                               param1 = lc_reason
                               param2 = lc_over_pay
                               BINARY SEARCH.

    IF sy-subrc = 0.
      lst_edidd-e1edk01-augru = lst_constant-low. "O01
    ENDIF.
  ENDIF.
* EOC by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
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

* Begin of ADD:ERP-5879:WROY:15-Jan-2018:ED2K910300
  CLEAR lst_e1edk14.
  lst_e1edk14-qualf = '019'. "PO type (SD)
  lst_e1edk14-orgid = fp_st_vbak-bsark.
  APPEND lst_e1edk14 TO li_e1edk14.
* End   of ADD:ERP-5879:WROY:15-Jan-2018:ED2K910300

  CLEAR lst_e1edk14.
  lst_e1edk14-qualf = '012'. "Sales order type
  lst_e1edk14-orgid = lv_auart.
  APPEND lst_e1edk14 TO li_e1edk14.
  lst_edidd-e1edk14 = li_e1edk14.

  lstqtc_e1edka1-e1edka1-parvw = lc_ag. "Sold to party
  lstqtc_e1edka1-e1edka1-partn = fp_st_vbak-kunnr.
  APPEND lstqtc_e1edka1 TO li_e1edka1.
  lst_edidd-e1edka1 = li_e1edka1.

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
  lst_e1edk05-betrg = fp_tot_paid.
  APPEND lst_e1edk05 TO li_e1edk05.
  lst_edidd-e1edk05 = li_e1edk05.

  CLEAR lst_e1edk02.
  lst_e1edk02-qualf = '004'.
  lst_e1edk02-belnr = fp_st_bsid-xref1. "(++)PBOSE: 15-05-2017: CR#384: ED2K905720
  APPEND lst_e1edk02 TO li_e1edk02.
  lst_edidd-e1edk02 = li_e1edk02.

  CLEAR lst_e1edk02.
  lst_e1edk02-qualf = '011'.
  lst_e1edk02-belnr = fp_st_bsid-xblnr.
  APPEND lst_e1edk02 TO li_e1edk02.
  lst_edidd-e1edk02 = li_e1edk02.
  CONCATENATE lc_sap sy-sysid INTO lv_port.

*Populating Control record
  lst_edidc-direct = 2.
  lst_edidc-rcvpor = lv_port. " (++) PBOSE: 03-07-2017: ERP-3018: ED2K907088
  lst_edidc-rcvprt = lst_edp21-sndprt.
  lst_edidc-rcvprn = lst_edp21-sndprn.
  lst_edidc-mescod = lc_z8.
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

***BOC BY SRBOSE ON 05-DEC-2017 #ERP:5005 #TR:ED2K908320
  READ TABLE li_message INTO DATA(lst_message) INDEX 1.
  IF sy-subrc IS INITIAL.
    IF lst_message-type = lc_msgtyp_e OR lst_message-type = lc_msgtyp_a.
      lst_final-zzmessage = lst_message-message.
      lst_final-zzstatus = icon_red_light.
* BOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
* To update any errors occured during order creation to custom table
      lst_custtab-mandt = sy-mandt. "Client
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
      lst_custtab-quote_amount = fp_paybl_amt. "Amount
      lst_custtab-payment_amount = fp_st_bsid-wrbtr. "Amount
      lst_custtab-posting_date = fp_st_bsid-budat. "Amount
      lst_custtab-sales_area = fp_st_vbak-vkorg. "Amount
      lst_custtab-quote_type = fp_st_vbak-auart.
      lst_custtab-reason_code = lc_others. "Failed reason
      lst_custtab-flreason = lst_message-message.

      APPEND lst_custtab TO i_custtab_upd.
      INSERT lst_custtab INTO TABLE i_custtab.

      CLEAR lst_custtab.
* EOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
    ELSE.
* If it  is successful give the order number.
      lst_final-zzmessage = lst_message-message.
      lst_final-zzstatus = icon_green_light.
    ENDIF.
  ENDIF.
  APPEND lst_final TO fp_i_final.
***EOC BY SRBOSE ON 05-DEC-2017 #ERP:5005 #TR:ED2K908320


  IF lv_vbeln IS NOT INITIAL.
    lst_vbfa-vbelv = fp_st_bsid-xref1.
    lst_vbfa-vbeln = lv_vbeln.
    INSERT lst_vbfa INTO TABLE i_vbfa.
    CLEAR lst_vbfa.
  ENDIF. " IF lv_vbeln IS NOT INITIAL
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
        lst_bsid    TYPE ty_bsid,
* BOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
        lv_dattype  TYPE datatype_d,
        lv_xref1_n  TYPE itmf_ref_obj,
* EOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
        lv_answer.

* Constant Declaration
  CONSTANTS: lc_b         TYPE c      VALUE 'B',    " B of type Character
             lc_s         TYPE c      VALUE 'S',    " S of type Character
             lc_devid     TYPE zdevid VALUE 'E097', " Type of Identification Code " (++) PBOSE:04-Jan-2017 : ED2K903276
* BOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
             lc_dtyp_numc TYPE datatype_d VALUE 'NUMC',
* EOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
* Begin of ADD:ERP-5879:WROY:15-Jan-2018:ED2K910300
             lc_posnr_low TYPE posnr_va   VALUE '000000',    "Sales Document Item (Header)
* End   of ADD:ERP-5879:WROY:15-Jan-2018:ED2K910300
             lc_dz        TYPE char2  VALUE 'DZ',   " Dz of type CHAR2
             lc_da        TYPE char2  VALUE 'DA'.   " Document type  " (++) PBOSE: 15-05-2017: CR#384: ED2K905720

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
      WHERE bukrs IN s_bukrs "Company Code
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
  WHERE bukrs IN s_bukrs
       AND ( blart = lc_dz
          OR blart = lc_da )
      AND bschl IN s_bschl
      AND xref1 IN s_xref1.
  ENDIF. " IF s_date[] IS INITIAL
  IF sy-subrc = 0.
    SORT li_bsid1.

    CLEAR: lst_bsid1,
           lst_bsid.

    LOOP AT li_bsid1 INTO lst_bsid1.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lst_bsid1-xref1
        IMPORTING
          output = lst_bsid1-xref1.
      MOVE-CORRESPONDING lst_bsid1 TO lst_bsid.
* BOC by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
* As S_XREF1 is na character field it considers all XREF1 docs that are starting
* with the given range. For example when we are running with 2000000000 to 2999999999
* then xref1 containing 25678 is also picked so to filter out this we are adding this check.
* Also as per business scenario we are only expecting the quote number as the reference.
*      APPEND lst_bsid TO fp_i_bsid[].
      IF s_xref1[] IS NOT INITIAL.
        CALL FUNCTION 'NUMERIC_CHECK'
          EXPORTING
            string_in = lst_bsid1-xref1
          IMPORTING
            htype     = lv_dattype.
        IF lv_dattype = lc_dtyp_numc.
          TRY.
              lv_xref1_n = lst_bsid1-xref1.
              lst_bsid-xref1 = lv_xref1_n.
            CATCH cx_root.
          ENDTRY.
          APPEND lst_bsid TO fp_i_bsid[].
        ENDIF.

      ELSE.
        APPEND lst_bsid TO fp_i_bsid[].
      ENDIF.
* EOC by PBANDLAPAL on 08-Dec-2017 for ERp-5005: ED2K908320

      CLEAR: lst_bsid1,
             lst_bsid.
    ENDLOOP. " LOOP AT li_bsid1 INTO lst_bsid1

* BOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
    DELETE fp_i_bsid WHERE NOT xref1 IN s_xref1.
* EOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320

    IF fp_i_bsid[] IS NOT INITIAL.
      SELECT kunnr " Customer Number
             name1 " Name 1
      INTO TABLE fp_i_kna1
        FROM kna1  " General Data in Customer Master
        FOR ALL ENTRIES IN fp_i_bsid
        WHERE kunnr = fp_i_bsid-kunnr.
      IF sy-subrc EQ 0.
        SORT fp_i_kna1 BY kunnr.
      ENDIF. " IF sy-subrc EQ 0

*     Begin of DEL:ERP-5879:WROY:15-Jan-2018:ED2K910300
*     SELECT vbeln " Sales Document
*            vbtyp " SD document category
*            auart " Sales Document Type
*            netwr " Net Value of the Sales Order in Document Currency
*            waerk " SD Document Currency
*            vkorg " Sales Organization
*            vtweg " Distribution Channel
*            spart " Division
*            kunnr " Sold-to party
*            vgbel " Document number of the reference document
*       FROM vbak  " Sales Document: Header Data
*       INTO TABLE fp_i_vbak
*       FOR ALL ENTRIES IN fp_i_bsid
*       WHERE vbeln = fp_i_bsid-xref1 " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
*         AND vbtyp = lc_b.
*     End   of DEL:ERP-5879:WROY:15-Jan-2018:ED2K910300
*     Begin of ADD:ERP-5879:WROY:15-Jan-2018:ED2K910300
      SELECT k~vbeln " Sales Document
             k~vbtyp " SD document category
             k~auart " Sales Document Type
             k~netwr " Net Value of the Sales Order in Document Currency
             k~waerk " SD Document Currency
             k~vkorg " Sales Organization
             k~vtweg " Distribution Channel
             k~spart " Division
             k~kunnr " Sold-to party
             k~vgbel " Document number of the reference document
             d~bsark " Customer purchase order type
        FROM vbak AS k INNER JOIN " Sales Document: Header Data
             vbkd AS d            " Sales Document: Business Data
          ON d~vbeln EQ k~vbeln
         AND d~posnr EQ lc_posnr_low
        INTO TABLE fp_i_vbak
        FOR ALL ENTRIES IN fp_i_bsid
        WHERE k~vbeln = fp_i_bsid-xref1
          AND k~vbtyp = lc_b.
*     End   of ADD:ERP-5879:WROY:15-Jan-2018:ED2K910300
      IF sy-subrc = 0.
        SORT fp_i_vbak BY vbeln.
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

        SELECT vbelv                           " Preceding sales and distribution document
               vbeln                           " Subsequent sales and distribution document
                FROM vbfa                      " Sales Document Flow
                INTO TABLE fp_i_vbfa
                FOR ALL ENTRIES IN fp_i_vbak
                WHERE vbelv = fp_i_vbak-vbeln. " (++) PBOSE:24-Jan-2017:ED2K903276
        IF sy-subrc = 0.
          DELETE ADJACENT DUPLICATES FROM fp_i_vbfa COMPARING vbelv.
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF sy-subrc = 0


    ENDIF. " IF fp_i_bsid[] IS NOT INITIAL
  ENDIF. " IF sy-subrc = 0

* Delete records from custom table
  IF p_purge EQ abap_true.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        text_question         = text-029
        text_button_1         = 'Yes'(030)
        text_button_2         = 'No'(031)
        default_button        = '1'
        display_cancel_button = abap_true
      IMPORTING
        answer                = lv_answer
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF. " IF sy-subrc <> 0

    CASE lv_answer.

      WHEN '1'.
        SELECT * FROM zqtclockbox_upd INTO TABLE fp_i_custtab.
      WHEN '2'.
        LEAVE TO SCREEN 0.
      WHEN 'A'.
        LEAVE TO SCREEN 0.
      WHEN OTHERS.
*do nothing.
    ENDCASE.
  ELSE.
**Select from custom table for existing error docs
    DATA : li_xref1  TYPE STANDARD TABLE OF srg_char10,
           lst_xref1 TYPE srg_char10.
    LOOP AT s_xref1 ASSIGNING FIELD-SYMBOL(<lst_xref1>).
      lst_xref1-sign = <lst_xref1>-sign.
      lst_xref1-option = <lst_xref1>-option.
      lst_xref1-low = <lst_xref1>-low.
      lst_xref1-high = <lst_xref1>-high.
      APPEND lst_xref1 TO li_xref1.
    ENDLOOP.

    SELECT *
      FROM zqtclockbox_upd " Lockbox Renewal
      INTO TABLE fp_i_custtab
      WHERE bukrs IN s_bukrs
      AND   xblnr IN li_xref1.
  ENDIF.
  IF NOT fp_i_custtab IS INITIAL.
    CALL FUNCTION 'ENQUEUE_E_TABLE'
      EXPORTING
        tabname        = 'ZQTCLOCKBOX_UPD'
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.

    IF sy-subrc EQ 0.
      DELETE zqtclockbox_upd FROM TABLE fp_i_custtab.
      COMMIT WORK.
      CALL FUNCTION 'DEQUEUE_E_TABLE'
        EXPORTING
          tabname = 'ZQTCLOCKBOX_UPD'.
    ENDIF. " IF sy-subrc EQ 0

    IF p_purge EQ abap_true.
      LEAVE PROGRAM.
    ENDIF.
  ENDIF. " IF sy-subrc IS INITIAL

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
  DATA: li_vbap_final   TYPE STANDARD TABLE OF lty_vbap_final INITIAL SIZE 0, " IT for VBAP
        li_amount       TYPE STANDARD TABLE OF lty_amount     INITIAL SIZE 0, " IT for Amount
        li_vbap_fin     TYPE STANDARD TABLE OF lty_vbap_final INITIAL SIZE 0, " IT for VBAP
        lst_vbap_final  TYPE lty_vbap_final,                                  " WA for VBAP
        lst_vbap_fin    TYPE lty_vbap_final,                                  " WA for VBAP
        lst_constant    TYPE ty_constant,                                     " WA for Constant
        lst_vbap        TYPE ty_vbap,                                         " WA for VBAP
        lst_bsid        TYPE ty_bsid,                                         " WA for BSID
        lst_bsid1       TYPE ty_bsid,                                         " WA for BSID
        lst_amount      TYPE lty_amount,                                      " WA for amount
        lst_vbak        TYPE ty_vbak,                                         " WA for VBAK
        lst_vbfa        TYPE ty_vbfa,                                         " WA for VBFA
        lst_kna1        TYPE ty_kna1,                                         " WA for KNA1  " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
        lst_custtab     TYPE zqtclockbox_upd,                                 " Lockbox Renewal
        lst_custtab1    TYPE zqtclockbox_upd,                                 " Lockbox Renewal
        lv_tot_tax      TYPE kzwi6,                                           " Subtotal 6 from pricing procedure for condition
        lv_paybl_amt    TYPE kzwi6,                                           " Subtotal 6 from pricing procedure for condition
        lv_index_val    TYPE sy-index,                                        " ABAP System Field: Loop Index
        lv_index        TYPE sy-index,                                        " ABAP System Field: Loop Index
        lv_vbak_amt     TYPE netwr,                                           " Net Value in Document Currency
        lv_diff         TYPE wrbtr,                                           " Amount in Document Currency
        lv_percent      TYPE i,                                               " Percentage value
        lv_alrd_payamt  TYPE wrbtr,                                           " Amount in Document Currency
        lv_tot_paid     TYPE wrbtr,                                           " Amount in Document Currency
        lv_tol_amt      TYPE wrbtr,                                           " Amount in Document Currency
        lv_tol_amt_ls   TYPE wrbtr,                                           " Amount in Document Currency
        lv_tol_amt_hg   TYPE wrbtr,                                           " Amount in Document Currency
        lv_perc         TYPE wrbtr,                                           " Amount in Document Currency
        lv_currency     TYPE waers, " Currency for fixed amount
        lv_fix_amt      TYPE wrbtr, " Fixed amount value
        lv_tol_amount   TYPE wrbtr, " Tolerance amount
        lv_less_amount  TYPE wrbtr, " Amount in Document Currency
        lv_fixed_amt    TYPE wrbtr, " Fixed amount
        lv_tot_bsid     TYPE wrbtr, " Amount in Document Currency
        li_bsid_tmp     TYPE tt_bsid,
        li_bsid_ref     TYPE tt_bsid,
        lv_lower_tol_pc TYPE wrbtr,
        lv_upper_tol_pc TYPE wrbtr,
        lv_lower_tol_fa TYPE wrbtr,
        lv_upper_tol_fa TYPE wrbtr,
        lv_lower_tol    TYPE wrbtr,
        lv_upper_tol    TYPE wrbtr,
        lv_ord_reason   TYPE char3.

* Constant declaration
  CONSTANTS : lc_devid    TYPE zdevid     VALUE 'E097',    " Identification Code: E097
              lc_percentg TYPE rvari_vnam VALUE 'PERCENT', " Parameter value: PERCENT
              lc_inc      TYPE tvarv_sign VALUE 'I',       " ABAP: ID: I/E (include/exclude values)
              lc_bt       TYPE tvarv_opti VALUE 'BT',      " ABAP: Selection option (EQ/BT/CP/...)
              lc_amount   TYPE rvari_vnam VALUE 'AMOUNT',   " ABAP: Selection option (EQ/BT/CP/...)
              lc_currency TYPE rvari_vnam VALUE 'CURRENCY'. " ABAP: Selection option (EQ/BT/CP/...)

  CLEAR lst_constant.
  READ TABLE i_constant INTO lst_constant
                        WITH KEY devid  = lc_devid
                                 param1 = lc_percentg
                                 BINARY SEARCH.
  IF sy-subrc EQ 0.
    lv_percent = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0


  CLEAR lst_constant.
* Read constant table to get tolerance limit
  READ TABLE i_constant INTO lst_constant
                        WITH KEY devid  = lc_devid
                                 param1 = lc_amount
                                 BINARY SEARCH.
  IF sy-subrc EQ 0.
    lv_fix_amt = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

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

    li_bsid_ref[] = fp_i_bsid[].
    SORT li_bsid_ref BY xref1.
    DELETE ADJACENT DUPLICATES FROM li_bsid_ref COMPARING xref1.
    LOOP AT li_bsid_ref INTO lst_bsid.
      lv_index = sy-tabix.
      CLEAR: v_name, li_bsid_tmp, lv_perc, lv_paybl_amt, lv_lower_tol_pc,
             lv_upper_tol_pc, lv_lower_tol_fa, lv_upper_tol_fa, lv_lower_tol,
             lv_upper_tol, lv_tot_bsid.
      li_bsid_tmp[] = fp_i_bsid[].
      DELETE li_bsid_tmp WHERE xref1 NE lst_bsid-xref1.

      READ TABLE i_kna1 INTO lst_kna1 WITH KEY kunnr = lst_bsid-kunnr
                                         BINARY SEARCH.
      IF sy-subrc EQ 0.
        v_name = lst_kna1-name1.
      ENDIF. " IF sy-subrc EQ 0
      CLEAR :lst_vbak,
             lst_vbfa.

      READ TABLE fp_i_vbak INTO lst_vbak
           WITH KEY vbeln = lst_bsid-xref1 "(++)PBOSE: 15-05-2017: CR#384: ED2K905720
           BINARY SEARCH.
      IF sy-subrc NE 0.
        LOOP AT li_bsid_tmp INTO lst_bsid1.
          lst_bsid1-flag = c_e. " Record not found
* BOI by PBANDLAPAL on 08-Dec-2017 for ERp-5005: ED2K908320
* Since the relevant quote is not found we will not have the quote amount
* that needs to be passed to the lv_paybl_amt.
* EOI by PBANDLAPAL on 08-Dec-2017 for ERp-5005: ED2K908320
          PERFORM f_update_cust_tab_error_entry USING lst_bsid1
                                                      lst_vbak
                                                      lst_vbfa
                                                      lv_paybl_amt
                                                      v_flag_und_tol
                                                      v_flag_und_amt
                                                      v_flag_ovr_tol
                                                      v_flag_ovr_amt
                                              CHANGING fp_i_final.
        ENDLOOP.

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
            LOOP AT li_bsid_tmp INTO lst_bsid1.
* BOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
              lv_paybl_amt  = lst_vbak-netwr + st_vbap-kzwi6.
* EOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
              lst_bsid1-flag = c_d. "Renewal already exists
              PERFORM f_update_cust_tab_error_entry USING lst_bsid1
                                                          lst_vbak
                                                          lst_vbfa
                                                          lv_paybl_amt
                                                          v_flag_und_tol
                                                          v_flag_und_amt
                                                          v_flag_ovr_tol
                                                          v_flag_ovr_amt
                                                 CHANGING fp_i_final.
            ENDLOOP.
          ENDIF. " IF lst_vbfa-vbeln IS NOT INITIAL
          CONTINUE.
        ENDIF. " IF sy-subrc IS INITIAL
*       Checking for quote amount payment Currency
        CLEAR : lv_vbak_amt,
                lv_paybl_amt.
        IF lst_vbak-waerk NE lst_bsid-waers.
          LOOP AT li_bsid_tmp INTO lst_bsid1.
            lst_bsid1-flag = c_f. " Payment amount is in the wrong currency
* BOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
            lv_paybl_amt  = lst_vbak-netwr + st_vbap-kzwi6.
* EOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
            PERFORM f_update_cust_tab_error_entry USING lst_bsid1
                                                        lst_vbak
                                                        lst_vbfa
                                                        lv_paybl_amt
                                                        v_flag_und_tol
                                                        v_flag_und_amt
                                                        v_flag_ovr_tol
                                                        v_flag_ovr_amt
                                            CHANGING fp_i_final.
          ENDLOOP.
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

*Total quote value
        lv_paybl_amt = lv_vbak_amt + lv_tot_tax.

*Get total amount paid by the customer
        LOOP AT li_bsid_tmp INTO lst_bsid1.
          lv_tot_bsid = lv_tot_bsid + lst_bsid1-wrbtr.
        ENDLOOP.

*Set tollerance amount
        lv_perc = ( lv_percent * lv_paybl_amt ) / 100.
****   BOC BY SRBOSE on 06-Dec-2017 #ERP:5005
        IF lv_fix_amt GT lv_perc.
* BOC by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
*          lv_lower_tol_pc = lv_paybl_amt - lv_perc.
*          lv_upper_tol_pc = lv_paybl_amt + lv_perc.
          lv_lower_tol = lv_lower_tol_pc = lv_paybl_amt - lv_perc.
          lv_upper_tol = lv_upper_tol_pc = lv_paybl_amt + lv_perc.
* EOC by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
        ELSE.
* BOC by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
*          lv_lower_tol_fa = lv_paybl_amt - lv_fix_amt.
*          lv_upper_tol_fa = lv_paybl_amt + lv_fix_amt.
          lv_lower_tol = lv_lower_tol_fa = lv_paybl_amt - lv_fix_amt.
          lv_upper_tol = lv_upper_tol_fa = lv_paybl_amt + lv_fix_amt.
* EOC by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
        ENDIF.
****   EOC BY SRBOSE on 06-Dec-2017 #ERP:5005
* BOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
*        IF lv_lower_tol_pc LE lv_lower_tol_fa.
*          lv_lower_tol = lv_lower_tol_pc.
*        ELSE.
*          lv_lower_tol = lv_lower_tol_fa.
*        ENDIF.
*        IF lv_upper_tol_pc LE lv_upper_tol_fa.
*          lv_upper_tol = lv_upper_tol_fa.
*        ELSE.
*          lv_upper_tol = lv_upper_tol_pc.
*        ENDIF.
* EOI by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
        CLEAR li_amount.
        lst_amount-sign = lc_inc.
        lst_amount-opti = lc_bt.
        lst_amount-low  = lv_lower_tol.
        lst_amount-high = lv_upper_tol.
        APPEND lst_amount TO li_amount.
        CLEAR : lst_amount.

* Check if renewal order should be created or not
        IF lv_tot_bsid IN li_amount. "5
*Populate Order reason code.
          CLEAR : lv_ord_reason.
* BOC by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
*          IF lv_tot_bsid LT lv_paybl_amt.
*            lv_ord_reason = 'U00'.
*          ELSEIF lv_tot_bsid GT lv_paybl_amt.
*            lv_ord_reason = 'O01'.
*          ENDIF.
* EOC by PBANDLAPAL on 08-Dec-2017 for ERP-5005: ED2K908320
*           Populate success message
          lst_bsid-flag = c_a. " Success , quote amt = payment amount
*           Triggering IDOC to create subscription order
          PERFORM f_trigger_idoc_renewal_create USING    i_constant " (++) PBOSE: 02-02-2017: ED2K903276
                                                         lst_bsid
                                                         lst_vbak
                                                         v_name     " (++) PBOSE: 15-05-2017: CR#384: ED2K905720
                                                         lv_paybl_amt
                                                         lv_tot_bsid
                                                         lv_ord_reason
                                                CHANGING fp_i_final.
        ELSE.
          IF lv_tot_bsid LT lv_lower_tol.
*           Payment amount is not matching after adding amount value also
*           Update custom table when error occurs
            LOOP AT li_bsid_tmp INTO lst_bsid1.
              lst_bsid1-flag = c_b. " paid amount is lesses than the quote amount
              PERFORM f_update_cust_tab_error_entry USING lst_bsid1
                                                        lst_vbak
                                                        lst_vbfa
                                                        lv_paybl_amt
                                                        v_flag_und_tol
                                                        v_flag_und_amt
                                                        v_flag_ovr_tol
                                                        v_flag_ovr_amt
                                              CHANGING fp_i_final.
            ENDLOOP.

          ELSEIF lv_tot_bsid GT lv_upper_tol.
*           Payment amount is not matching after adding amount value also
*           Update custom table when error occurs
            LOOP AT li_bsid_tmp INTO lst_bsid1.
              lst_bsid1-flag = c_c. " paid amount is greater than the quote amount
              PERFORM f_update_cust_tab_error_entry USING lst_bsid1
                                                        lst_vbak
                                                        lst_vbfa
                                                        lv_paybl_amt
                                                        v_flag_und_tol
                                                        v_flag_und_amt
                                                        v_flag_ovr_tol
                                                        v_flag_ovr_amt
                                              CHANGING fp_i_final.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.


    IF i_custtab_upd IS NOT INITIAL.
      PERFORM f_update_lockbox_upd.
    ENDIF. " IF i_custtab_upd IS NOT INITIAL

  ENDIF. " IF fp_i_bsid[] IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       Build Field catalog
*----------------------------------------------------------------------*
FORM f_build_fieldcat .

  CONSTANTS:
********Fields**********************************************************
    lc_status  TYPE char10 VALUE 'ZZSTATUS',
    lc_xblnr   TYPE char10 VALUE 'ZZXBLNR', " Xblnr of type CHAR10
    lc_vbeln   TYPE char10 VALUE 'ZZVBELN', " Vbeln of type CHAR10
    lc_wrbtr   TYPE char10 VALUE 'ZZWRBTR', " Wrbtr of type CHAR10
    lc_vgbel   TYPE char10 VALUE 'ZZVGBEL', " Vgbel of type CHAR10
    lc_netwr   TYPE char10 VALUE 'ZZNETWR', " Netwr of type CHAR10
    lc_waers   TYPE char10 VALUE 'ZZWAERS', " Waers of type CHAR10
    lc_kunnr   TYPE char10 VALUE 'ZZKUNNR', " Kunnr of type CHAR10
    lc_blart   TYPE char10 VALUE 'ZZBLART', " Blart of type CHAR10
    lc_vbtyp   TYPE char10 VALUE 'ZZVBTYP', " Vbtyp of type CHAR10
    lc_waerk   TYPE char10 VALUE 'ZZWAERK', " Waerk of type CHAR10
    lc_bukrs   TYPE char10 VALUE 'ZZBUKRS', " Bukrs of type CHAR10
    lc_xref1   TYPE char10 VALUE 'ZZXREF1',  " Xref1 of type CHAR10
    lc_belnr   TYPE char10 VALUE 'ZZBELNR',  " Belnr of type CHAR10
    lc_zuonr   TYPE char10 VALUE 'ZZZUONR',  " Zuonr of type CHAR10
    lc_name1   TYPE char10 VALUE 'ZZNAME1',  " Name1 of type CHAR10
    lc_reason  TYPE char10 VALUE 'ZZREASON', " Reason of type CHAR10
    lc_message TYPE char10 VALUE 'ZZMESSAGE'. " Reason of type CHAR10

  PERFORM f_populate_catalog USING :
      lc_status  text-033,
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
      lc_xref1   text-020,
      lc_belnr   text-023,
      lc_zuonr   text-024,
      lc_name1   text-021,
      lc_reason  text-022,
      lc_message  text-032.

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
