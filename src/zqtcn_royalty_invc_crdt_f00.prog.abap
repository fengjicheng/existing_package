*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTC_ROYALTY_INVC_CRDT_I0340
* PROGRAM DESCRIPTION: Royalty Feed From Invoice_Credit.SAP system will
*                      trigger the interface to CORE via TIBCO.
* DEVELOPER(S):        Aratrika Banerjee
* CREATION DATE:       03/23/2017
* OBJECT ID:           I0340
* TRANSPORT NUMBER(S): ED2K905073
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907760
* REFERENCE NO: ERP-3783
* DEVELOPER: Writtick Roy (WROY)
* DATE:  08/07/YYYY
* DESCRIPTION: For Time Based entries, consider the record if the Job
* is being executed for the first time in the current Posting Period
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910467
* REFERENCE NO: ERP-6094
* DEVELOPER: Writtick Roy (WROY)
* DATE:  01/24/2018
* DESCRIPTION: Use Material Group 1 instead of Publication Type
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910918
* REFERENCE NO: Converted Orders
* DEVELOPER: Writtick Roy (WROY)
* DATE:  02/15/2018
* DESCRIPTION: Fields - Currency and Fiscal Year population for
* Converted Orders where SD Billing Document will not be available
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911451
* REFERENCE NO: ERP-7131
* DEVELOPER: Writtick Roy (WROY)
* DATE:  03/19/2018
* DESCRIPTION: Use proper Language for fetching Long Text
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_VARIABLES
*&---------------------------------------------------------------------*
*       Clear Global variables
*----------------------------------------------------------------------*

FORM f_clear_variables .

  CLEAR : i_edidd,
          i_idoc_control,
          i_output_det,
          i_fieldcatalog,
          st_edidc,
          st_edidd,
          st_rylty_hdr,
          st_rylty_itm,
          st_rylty_trl.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA
*&---------------------------------------------------------------------*
*       Retrieving the data from tables
*----------------------------------------------------------------------*

FORM f_fetch_data CHANGING  fp_li_contract TYPE tt_contract
                            fp_li_contract_tmp TYPE tt_contract
                            fp_li_amount TYPE tt_amount
                            fp_li_vbak TYPE tt_vbak
                            fp_li_vbrk TYPE tt_vbrk
                            fp_li_vbkd TYPE tt_vbkd
                            fp_li_bkpf TYPE tt_bkpf.

  TYPES : BEGIN OF lty_orgid,
            vbeln TYPE vbeln_va, " Sales Document
            posnr TYPE posnr_va, " Sales Document
          END OF lty_orgid,

          BEGIN OF lty_srcid,
            vbeln TYPE awkey,    " Sales Document Item
          END OF lty_srcid.


  DATA : lst_fiscal_range TYPE ty_fiscal_range,
         lst_return       TYPE bapireturn1,              " Return Parameter
         lst_orgid        TYPE lty_orgid,
         lst_srcid        TYPE lty_srcid,
         li_orgid         TYPE STANDARD TABLE OF lty_orgid INITIAL SIZE 0,
         li_srcid         TYPE STANDARD TABLE OF lty_srcid INITIAL SIZE 0,
         li_amount        TYPE tt_amount,
         lv_period        TYPE numc3,                    " Numc3, internal use
         lv_monat         TYPE monat,
         lv_first_day     TYPE sydatum,
         lv_fiscal_curr   TYPE char7,                    " Fiscal of type CHAR7
         lv_fiscal_last   TYPE char7,                    " Fiscal of type CHAR7
         lv_fiscal        TYPE char7,                    " Fiscal of type CHAR7
         lv_posting_dt    TYPE bapi0002_4-posting_date,  " Posting Date in the Document
         lv_compcod       TYPE bapi0002_2-comp_code,     " Company Code
         lv_fiscal_year   TYPE bapi0002_4-fiscal_year,   " Fiscal Year
         lv_fiscal_prd    TYPE bapi0002_4-fiscal_period. " Fiscal period

  CONSTANTS : lc_zero TYPE posnr VALUE '000000', " Item number of the SD document
              lc_vbrk TYPE awtyp VALUE 'VBRK'.   " Reference Transaction

*========================================================================================*
* Selection from FARR_D_POB table where VBELN and POSNR is equal to the values
* fetched from the table /1RA/0SD034MI table and MARA table deleting duplicate ORIGDOC_ID
*========================================================================================*
  SELECT r~company_code,     " Company Code
         r~acct_principle,   " Accounting Principle
         r~contract_id,      " Revenue Recognition Contract ID
         r~gjahr,            " Fiscal Year
         r~poper,            " Posting period
         r~recon_key,        " Revenue Reconciliation Key
         r~keypp,            " Subarea for Parallelization
         r~status,           " Status of Revenue Reconciliation Key
         r~type,             " Reconciliation Key Type
         r~tm_convert,       " Time based deferral item transferred
         r~liab_asset_flag,  " Posting Job Includes Contract Liabilities/Assets
         r~runid,            " Posting Service Run ID
         r~run_date,         " Date
         a~zz_vbeln,         " Sales Document
         a~pob_id,           " Performance Obligation ID
         a~zz_posnr,         " Sales Document Item
         a~alloc_amt,        " Allocated Amount
         a~trx_price,        " Transaction Price
         b~srcdoc_id,        " Source Item ID
         b~origdoc_id,       " Original Item ID
         b~due_date,         " Invoice Due Date
         c~bismt             " Old material number
    FROM farr_d_recon_key   AS r
   INNER JOIN farr_d_pob    AS a
      ON r~contract_id EQ a~contract_id
   INNER JOIN /1ra/0sd034mi AS b
      ON a~zz_vbeln    EQ b~zz_vbeln
     AND a~zz_posnr    EQ b~zz_posnr
   INNER JOIN mara          AS c
      ON b~zz_matnr    EQ c~matnr
*  Begin of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
   INNER JOIN mvke          AS d
      ON d~matnr       EQ a~zz_matnr
     AND d~vkorg       EQ a~sales_org
*  End   of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
    INTO TABLE @fp_li_contract
   WHERE r~last_changed_on GE @v_lr_dt_tm
     AND r~last_changed_on LE @v_curr_dt_tm
     AND r~status          IN @s_rec_st
     AND b~srcdoc_type     IN @s_doctyp
     AND b~raic            IN @s_raic
     AND b~status          IN @s_status
*  Begin of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*    AND c~ismpubltype     IN @s_ismtyp.
*  End   of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*  Begin of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
     AND d~mvgr1           IN @s_mvgr1.
*  End   of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
  IF sy-subrc IS INITIAL.
    SORT fp_li_contract BY contract_id pob_id recon_key.

    fp_li_contract_tmp[] = fp_li_contract[].
*   SORT fp_li_contract_tmp BY pob_id.
*   DELETE ADJACENT DUPLICATES FROM fp_li_contract_tmp COMPARING pob_id.

    SORT fp_li_contract_tmp BY contract_id zz_vbeln zz_posnr.
    DELETE ADJACENT DUPLICATES FROM fp_li_contract_tmp COMPARING contract_id zz_vbeln zz_posnr.
*   Getting the Sales Order data and Billing Document data in an Internal Table
    LOOP AT fp_li_contract_tmp ASSIGNING FIELD-SYMBOL(<lst_contract>).
      lst_orgid-vbeln = <lst_contract>-origdoc_id+0(10).
      lst_orgid-posnr = <lst_contract>-origdoc_id+10(06).
      APPEND lst_orgid TO li_orgid.

      lst_srcid-vbeln = <lst_contract>-srcdoc_id+0(10).
      APPEND lst_srcid TO li_srcid.
    ENDLOOP. " LOOP AT fp_li_contract ASSIGNING FIELD-SYMBOL(<lst_contract>)

*========================================================================================*
*   Inserting data into an temporary Internal table and deleting entries
*   from this table depending on Contract_ID. This will help in looping
*   of final table data for Idoc Processing
*========================================================================================*
*   fp_li_contract_tmp[] = fp_li_contract[].
*   SORT fp_li_contract_tmp[] BY contract_id.
    DELETE ADJACENT DUPLICATES FROM fp_li_contract_tmp COMPARING contract_id.

*========================================================================================*
*   Selection from FARR_D_DEFITEM depending on the POB_ID and CONTRACT_ID of the
*   above table. After fetching the data, we need to get the fiscal year and period
*   range for the current year. Depending on the Fiscal period, a range table is
*   created that contains all the concatenated data of Fiscal Year and period till
*   the period that is fetched form the FM . Based on this data , the table(LI_AMOUNT)
*   that was first created is deleted that doesnot contain this range of Fiscal period
*========================================================================================*
*   Begin of DEL:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
*    SELECT contract_id,
*           pob_id,
*           recon_key,
*           company_code,
*           rev_amt_delta,      " Amount of Revenue Accounting Item
*           fulfill_type,       " Fulfillment Type
*           timestamp           " UTC Time Stamp in Short Form (YYYYMMDDhhmmss)
*      FROM farr_d_defitem " Deferral Items
*      INTO TABLE @fp_li_amount
*       FOR ALL ENTRIES IN @fp_li_contract
*     WHERE pob_id      EQ @fp_li_contract-pob_id
*       AND contract_id EQ @fp_li_contract-contract_id
*       AND recon_key   EQ @fp_li_contract-recon_key.
*   End   of DEL:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
*   Begin of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
    SELECT contract_id,
           pob_id,
           recon_key,
           company_code,
           betrw,              " Amount in Transaction Currency
           acct_principle,     " Fulfillment Type
           condition_type,     " UTC Time Stamp in Short Form (YYYYMMDDhhmmss)
           post_cat,
           shkzg,
           guid,
*          Begin of ADD:Conv Ord:WROY:15-Feb-2018:ED2K910918
           gjahr               " Fiscal Year
*          End   of ADD:Conv Ord:WROY:15-Feb-2018:ED2K910918
      FROM farr_d_posting " Deferral Items
      INTO TABLE @fp_li_amount
       FOR ALL ENTRIES IN @fp_li_contract
     WHERE pob_id      EQ @fp_li_contract-pob_id
       AND contract_id EQ @fp_li_contract-contract_id
       AND recon_key   EQ @fp_li_contract-recon_key
       AND post_cat    IN @s_pst_ct
       AND timestamp   GE @v_lr_dt_tm
       AND timestamp   LE @v_curr_dt_tm.
*   End   of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
    IF sy-subrc IS INITIAL.
*     Begin of DEL:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
*      SORT fp_li_amount BY contract_id.
*
*      LOOP AT fp_li_amount INTO DATA(lst_amount).
*
*        DATA(lst_amount_tmp) = lst_amount.
*        READ TABLE fp_li_contract ASSIGNING <lst_contract>
*             WITH KEY contract_id = lst_amount-contract_id
*                      pob_id      = lst_amount-pob_id
*                      recon_key   = lst_amount-recon_key
*             BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          IF <lst_contract>-status EQ c_rec_stat_a.
*            lst_amount-rev_amt_delta = lst_amount-rev_amt_delta * -1.
*          ENDIF.
*
*          IF lst_amount-timestamp GE v_lr_dt_tm AND
*             lst_amount-timestamp LE v_curr_dt_tm.
*            APPEND lst_amount TO li_amount.
*            CLEAR: lst_amount.
*          ELSEIF lst_amount-fulfill_type EQ c_ful_type_t.         " Time-based
*            lv_monat = <lst_contract>-poper+1(2).
**           Get the First date of the Fiscal Period
*            CALL FUNCTION 'BAPI_CCODE_GET_FIRSTDAY_PERIOD'
*              EXPORTING
*                companycodeid       = <lst_contract>-company_code " Company Code
*                fiscal_period       = lv_monat                    " Fiscal period
*                fiscal_year         = <lst_contract>-gjahr        " Fiscal year
*              IMPORTING
*                first_day_of_period = lv_first_day.               " First date of the Fiscal Period
**           Check if the Job was executed on the First date of the Fiscal Period
**           Begin of DEL:ERP-3783:WROY:07-AUG-2017:ED2K907760
**           IF <lst_contract>-run_date EQ lv_first_day.
**           End   of DEL:ERP-3783:WROY:07-AUG-2017:ED2K907760
**           Begin of ADD:ERP-3783:WROY:07-AUG-2017:ED2K907760
*            IF <lst_contract>-run_date GE lv_first_day AND
*               v_lr_date               LT lv_first_day.
**           End   of ADD:ERP-3783:WROY:07-AUG-2017:ED2K907760
*              APPEND lst_amount TO li_amount.
*              CLEAR: lst_amount.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*      ENDLOOP. " LOOP AT fp_li_amount INTO DATA(lst_amount)
*
*      fp_li_amount[] = li_amount[].
*     End   of DEL:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
      SORT fp_li_amount   BY contract_id pob_id.

      SORT fp_li_contract BY contract_id pob_id.
      DELETE ADJACENT DUPLICATES FROM fp_li_contract
                   COMPARING contract_id pob_id.
    ENDIF. " IF sy-subrc IS INITIAL

*========================================================================================*
*   Selection from VBAK to fetch the Name of Orderer(BNAME)
*========================================================================================*
    SELECT vbeln " Sales Document
         bname   " Name of orderer
*        Begin of ADD:Conv Ord:WROY:15-Feb-2018:ED2K910918
         waerk   " SD Document Currency
*        End   of ADD:Conv Ord:WROY:15-Feb-2018:ED2K910918
*        Begin of ADD:ERP-7131:WROY:19-Mar-2018:ED2K911451
         vbeln   " Text Name
*        End   of ADD:ERP-7131:WROY:19-Mar-2018:ED2K911451
    FROM vbak    " Sales Document: Header Data
    INTO TABLE fp_li_vbak
    FOR ALL ENTRIES IN li_orgid
    WHERE vbeln EQ li_orgid-vbeln.
    IF sy-subrc IS INITIAL.
      SORT fp_li_vbak BY vbeln.
    ENDIF. " IF sy-subrc IS INITIAL

*========================================================================================*
*   Selection from VBRK depending upon Billing Document Header detail
*========================================================================================*
    SELECT vbeln " Billing Document
           fkart " Billing Type
           waerk " SD Document Currency
           vsbed " Shipping Conditions
           fkdat " Billing date for billing index and printout
           konda " Price group (customer)
           kdgrp " Customer group
           inco1 " Incoterms (Part 1)
      FROM vbrk  " Billing Document: Header Data
      INTO TABLE fp_li_vbrk
      FOR ALL ENTRIES IN li_srcid
      WHERE vbeln EQ li_srcid-vbeln+0(10).
    IF sy-subrc IS INITIAL.
      SORT fp_li_vbrk BY vbeln.
    ENDIF. " IF sy-subrc IS INITIAL

*========================================================================================*
*   Selection from VBKD depending upon Sales Document Header detail
*========================================================================================*
    SELECT vbeln " Sales and Distribution Document Number
           posnr " Item number of the SD document
           prsdt " Date for pricing and exchange rate
      FROM vbkd  " Sales Document: Business Data
      INTO TABLE fp_li_vbkd
      FOR ALL ENTRIES IN li_orgid
      WHERE vbeln EQ li_orgid-vbeln
      AND posnr EQ lc_zero.
    IF sy-subrc IS INITIAL.
      SORT fp_li_vbkd BY vbeln posnr.
    ENDIF. " IF sy-subrc IS INITIAL

*========================================================================================*
*   Selection from BKPF on the basis of Billing Document Header detail
*========================================================================================*
    SELECT gjahr " Fiscal Year
           awtyp " Reference Transaction
           awkey " Reference Key
      FROM bkpf  " Accounting Document Header
      INTO TABLE fp_li_bkpf
      FOR ALL ENTRIES IN li_srcid
      WHERE awtyp EQ lc_vbrk
      AND awkey EQ li_srcid-vbeln.
    IF sy-subrc IS INITIAL.
      SORT fp_li_bkpf BY awkey.
      DELETE ADJACENT DUPLICATES FROM fp_li_bkpf COMPARING awkey.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONTROL_DATA
*&---------------------------------------------------------------------*
*       Populate Control records for IDOC
*----------------------------------------------------------------------*

FORM f_control_data .

* Local Constant Declaration
  CONSTANTS:
*   Direction of Idoc
    lc_direct_out TYPE edi_direct VALUE '1',   " Direction for IDoc
*   SAP Value
    lc_sap        TYPE char3      VALUE 'SAP', " Sap of type CHAR3
*   Partner type
    lc_partyp_ls  TYPE edi_sndprt VALUE 'LS'.  " Partner type of sender

* Direction ( 1 : Outbound Idoc)
  st_edidc-direct = lc_direct_out.
* Receiver Port
  st_edidc-rcvpor = p_rcvpor.
* Receiver partner type
  st_edidc-rcvprt = p_rcvprt.
* Receiver partner number
  st_edidc-rcvprn = p_rcvprn.
* Sender port
  CONCATENATE lc_sap
              sy-sysid
              INTO st_edidc-sndpor.
  CONDENSE st_edidc-sndpor.
* Sender partner type
  st_edidc-sndprt = lc_partyp_ls.

* Sender partner number
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system             = st_edidc-sndprn
    EXCEPTIONS
      own_logical_system_not_defined = 1
      OTHERS                         = 2.

* If not found , pass blank entry
  IF sy-subrc IS NOT INITIAL.
    CLEAR st_edidc-sndprn.
  ENDIF. " IF sy-subrc IS NOT INITIAL

* Message type
  st_edidc-mestyp = c_msgtyp.
* Idoc Type
  st_edidc-idoctp = c_idoctyp.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DATA
*&---------------------------------------------------------------------*
*       Populate DATA records for Idoc
*----------------------------------------------------------------------*

FORM f_populate_data USING li_contract TYPE tt_contract
                           li_contract_tmp TYPE tt_contract
                           li_amount TYPE tt_amount
                           li_vbak TYPE tt_vbak
                           li_vbrk TYPE tt_vbrk
                           li_vbkd TYPE tt_vbkd
                           li_bkpf TYPE tt_bkpf
                  CHANGING fp_lst_output_det TYPE ty_output_det
                           fp_i_output_det TYPE tt_output_det.

  DATA :
    lv_rec_rev_amt     TYPE tb_amount, " Amount
    lv_tot_rec_rev_amt TYPE tb_amount, " Amount
    lv_tot_trx_amt     TYPE tb_amount, " Amount
    lv_text_name       TYPE tdobname,  " Text name
*   Begin of ADD:ERP-7131:WROY:19-Mar-2018:ED2K911451
    lv_language        TYPE spras,     " Language Key
*   End   of ADD:ERP-7131:WROY:19-Mar-2018:ED2K911451
    lv_data_error      TYPE char256,   " Data Error
    lv_counter         TYPE numc7.     " StADUEV: Seven-Digit Value

  DATA:
    li_texts           TYPE tline_t.   " Text Lines

  CONSTANTS :
    lc_txtid_0009     TYPE tdid       VALUE '0009',              " Text ID
    lc_tdobj_vbbk     TYPE tdobject   VALUE 'VBBK',              " Text Object
*   Hierarchy level
    lc_hlvl_01        TYPE edi_hlevel VALUE '01',                " Hierarchy level
*   Hierarchy level
    lc_hlvl_02        TYPE edi_hlevel VALUE '02',                " Hierarchy level
*   Segment Name
    lc_seg_roylty_hdr TYPE edilsegtyp VALUE 'Z1QTC_ROYALTY_HDR', " Segment type
*   Segment name
    lc_seg_roylty_itm TYPE edilsegtyp VALUE 'Z1QTC_ROYALTY_ITM', " Segment type
*   Withholding data segment
    lc_seg_roylty_trl TYPE edilsegtyp VALUE 'Z1QTC_ROYALTY_TRL'. " Segment type

* Begin of ADD:ERP-7131:WROY:19-Mar-2018:ED2K911451
* Fetch STXD SAPscript text file header
  SELECT tdname,      "Name
         tdspras      "Language Key
    FROM stxh
    INTO TABLE @DATA(li_text_langu)
     FOR ALL ENTRIES IN @li_vbak
   WHERE tdobject EQ @lc_tdobj_vbbk
     AND tdname   EQ @li_vbak-txtnm
     AND tdid     EQ @lc_txtid_0009.
  IF sy-subrc EQ 0.
    SORT li_text_langu BY tdname.
  ENDIF.
* End   of ADD:ERP-7131:WROY:19-Mar-2018:ED2K911451
* Populate Idoc Data Segment
  LOOP AT li_amount ASSIGNING FIELD-SYMBOL(<lst_amount>).
    AT NEW contract_id.
*=====================================================================*
* 1.  Z1QTC_ROYALTY_HDR - I0340: Royalty Feed from Inv / Cred - Header
*=====================================================================*
      CLEAR st_edidd.
      st_edidd-segnam = lc_seg_roylty_hdr.
      st_edidd-hlevel = lc_hlvl_01.

      st_rylty_hdr-contract_id = <lst_amount>-contract_id.               " SAP RAR Contract ID

      READ TABLE li_contract_tmp ASSIGNING FIELD-SYMBOL(<lst_contract_tmp>)
           WITH KEY contract_id = <lst_amount>-contract_id
           BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        st_rylty_hdr-origdoc_id   = <lst_contract_tmp>-origdoc_id+0(10). " Order reference number
        st_rylty_hdr-rev_rec_date = <lst_contract_tmp>-due_date.         " Shipment verify date = Revenue Recognition Date

*       For one contract ID only a single Sales Order can be tagged.
        READ TABLE li_vbak ASSIGNING FIELD-SYMBOL(<lst_vbak>)
             WITH KEY vbeln = <lst_contract_tmp>-zz_vbeln
             BINARY SEARCH.
        IF sy-subrc IS INITIAL.
*         Begin of ADD:Conv Ord:WROY:15-Feb-2018:ED2K910918
          st_rylty_hdr-doc_currency = <lst_vbak>-waerk.                  " SD Document Currency
*         End   of ADD:Conv Ord:WROY:15-Feb-2018:ED2K910918
*         Begin of DEL:ERP-5260:WROY:21-Nov-2017:ED2K909540
*         st_rylty_hdr-cust_acc = <lst_vbak>-bname.                      " BNAME : Name of Orderer
*         End   of DEL:ERP-5260:WROY:21-Nov-2017:ED2K909540
          IF st_rylty_hdr-cust_acc IS INITIAL.
            lv_text_name = <lst_contract_tmp>-zz_vbeln.
*           Begin of ADD:ERP-7131:WROY:19-Mar-2018:ED2K911451
            READ TABLE li_text_langu ASSIGNING FIELD-SYMBOL(<lst_text_langu>)
                 WITH KEY tdname = lv_text_name
                 BINARY SEARCH.
            IF sy-subrc EQ 0.
              lv_language = <lst_text_langu>-tdspras.
            ELSE.
              lv_language = sy-langu.
            ENDIF.
*           End   of ADD:ERP-7131:WROY:19-Mar-2018:ED2K911451
            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                id                      = lc_txtid_0009
*               Begin of ADD:ERP-7131:WROY:19-Mar-2018:ED2K911451
                language                = lv_language
*               End   of ADD:ERP-7131:WROY:19-Mar-2018:ED2K911451
*               Begin of DEL:ERP-7131:WROY:19-Mar-2018:ED2K911451
*               language                = sy-langu
*               End   of DEL:ERP-7131:WROY:19-Mar-2018:ED2K911451
                name                    = lv_text_name
                object                  = lc_tdobj_vbbk
              TABLES
                lines                   = li_texts
              EXCEPTIONS
                id                      = 1
                language                = 2
                name                    = 3
                not_found               = 4
                object                  = 5
                reference_check         = 6
                wrong_access_to_archive = 7
                OTHERS                  = 8.
            IF sy-subrc EQ 0.
              READ TABLE li_texts ASSIGNING FIELD-SYMBOL(<lst_text>) INDEX 1.
              IF sy-subrc EQ 0.
                st_rylty_hdr-cust_acc = <lst_text>-tdline.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF. " IF sy-subrc IS INITIAL

        READ TABLE li_vbrk ASSIGNING FIELD-SYMBOL(<lst_vbrk>)
             WITH KEY vbeln = <lst_contract_tmp>-srcdoc_id+0(10)
             BINARY SEARCH.
        IF sy-subrc IS INITIAL.
*         st_rylty_hdr-inv_date     = <lst_vbrk>-fkdat.
          st_rylty_hdr-inv_date     = sy-datum.                          " Invoice date
          st_rylty_hdr-doc_currency = <lst_vbrk>-waerk.                  " Currency code
*       Begin of ADD:Conv Ord:WROY:15-Feb-2018:ED2K910918
        ELSE.
          st_rylty_hdr-inv_date     = sy-datum.                          " Invoice date
*       End   of ADD:Conv Ord:WROY:15-Feb-2018:ED2K910918
        ENDIF. " IF sy-subrc IS INITIAL

        READ TABLE li_vbkd ASSIGNING FIELD-SYMBOL(<lst_vbkd>)
             WITH KEY vbeln = <lst_contract_tmp>-zz_vbeln
             BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          st_rylty_hdr-ship_date  = <lst_vbkd>-prsdt.                    " Ship date
          st_rylty_hdr-order_date = <lst_vbkd>-prsdt.                    " Order date
        ENDIF. " IF sy-subrc IS INITIAL

        READ TABLE li_bkpf ASSIGNING FIELD-SYMBOL(<lst_bkpf>)
             WITH KEY awkey = <lst_contract_tmp>-srcdoc_id+0(10)
             BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          st_rylty_hdr-fiscal_year = <lst_bkpf>-gjahr.                   " Fiscal Year
*       Begin of ADD:Conv Ord:WROY:15-Feb-2018:ED2K910918
        ELSE.
          st_rylty_hdr-fiscal_year = <lst_amount>-gjahr.                 " Fiscal Year
*       End   of ADD:Conv Ord:WROY:15-Feb-2018:ED2K910918
        ENDIF. " IF sy-subrc IS INITIAL
      ENDIF. " IF sy-subrc IS INITIAL

      IF st_rylty_hdr-contract_id IS INITIAL.
        IF lv_data_error IS INITIAL.
          lv_data_error = 'Contract ID'(009).
        ELSE.
          CONCATENATE lv_data_error 'Contract ID'(009)
                 INTO lv_data_error
            SEPARATED BY c_sep_comma.
        ENDIF.
      ENDIF.

      IF st_rylty_hdr-origdoc_id IS INITIAL.
        IF lv_data_error IS INITIAL.
          lv_data_error = 'Original Doc'(008).
        ELSE.
          CONCATENATE lv_data_error 'Original Doc'(008)
                 INTO lv_data_error
            SEPARATED BY c_sep_comma.
        ENDIF.
      ENDIF.

      IF st_rylty_hdr-inv_date IS INITIAL.
        IF lv_data_error IS INITIAL.
          lv_data_error = 'Invoice Date'(010).
        ELSE.
          CONCATENATE lv_data_error 'Invoice Date'(010)
                 INTO lv_data_error
            SEPARATED BY c_sep_comma.
        ENDIF.
      ENDIF.

      IF st_rylty_hdr-cust_acc IS INITIAL.
        IF lv_data_error IS INITIAL.
          lv_data_error = 'Customer Acc'(011).
        ELSE.
          CONCATENATE lv_data_error 'Customer Acc'(011)
                 INTO lv_data_error
            SEPARATED BY c_sep_comma.
        ENDIF.
      ENDIF.

      IF st_rylty_hdr-doc_currency IS INITIAL.
        IF lv_data_error IS INITIAL.
          lv_data_error = 'Doc Currency'(012).
        ELSE.
          CONCATENATE lv_data_error 'Doc Currency'(012)
                 INTO lv_data_error
            SEPARATED BY c_sep_comma.
        ENDIF.
      ENDIF.

      IF st_rylty_hdr-rev_rec_date IS INITIAL.
        IF lv_data_error IS INITIAL.
          lv_data_error = 'Rev Rec Date'(013).
        ELSE.
          CONCATENATE lv_data_error 'Rev Rec Date'(013)
                 INTO lv_data_error
            SEPARATED BY c_sep_comma.
        ENDIF.
      ENDIF.

      st_edidd-sdata = st_rylty_hdr.

      APPEND st_edidd TO i_edidd.
      CLEAR: st_edidd,
             st_rylty_hdr.
    ENDAT.

*   Begin of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
    <lst_amount>-rev_amt_delta = <lst_amount>-rev_amt_delta * -1.
*   End   of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
    lv_rec_rev_amt = lv_rec_rev_amt + <lst_amount>-rev_amt_delta.

    AT END OF pob_id.
      lv_counter = lv_counter + 1.

*=====================================================================*
* 2.  Z1QTC_ROYALTY_ITM - I0340: Royalty Feed from Inv / Cred - Item
*=====================================================================*
      CLEAR st_edidd.
      st_edidd-segnam = lc_seg_roylty_itm.
      st_edidd-hlevel = lc_hlvl_02.

      st_rylty_itm-pob_id      = <lst_amount>-pob_id.                    " SAP RAR POB ID
      st_rylty_itm-trans_amt   = lv_rec_rev_amt.                         " SAP Title price
      st_rylty_itm-rev_rec_amt = lv_rec_rev_amt.                         " Amount of Revenue Accounting Item

      READ TABLE li_contract ASSIGNING FIELD-SYMBOL(<lst_contract>)
           WITH KEY contract_id = <lst_amount>-contract_id
                    pob_id      = <lst_amount>-pob_id
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        st_rylty_itm-isbn_13 = <lst_contract>-bismt.                     " ISBN13
      ENDIF.

      IF st_rylty_itm-isbn_13 IS INITIAL.
        IF lv_data_error IS INITIAL.
          lv_data_error = 'ISBN#'(014).
        ELSE.
          CONCATENATE lv_data_error 'ISBN#'(014)
                 INTO lv_data_error
            SEPARATED BY c_sep_comma.
        ENDIF.
      ENDIF.

      st_edidd-sdata = st_rylty_itm.

      APPEND st_edidd TO i_edidd.
      CLEAR: st_edidd,
             st_rylty_itm.

*     Adding the total Transaction price amount for all the POB_IDs
      lv_tot_trx_amt = lv_tot_trx_amt + <lst_contract>-trx_price.
*     Adding the total Recognized Revenue amount for all the POB_IDs
      lv_tot_rec_rev_amt = lv_tot_rec_rev_amt + lv_rec_rev_amt.
      CLEAR lv_rec_rev_amt.
    ENDAT.

    AT END OF contract_id.
*=====================================================================*
* 3.  Z1QTC_ROYALTY_TRL - I0340: Royalty Feed from Inv / Cred - Trailor
*=====================================================================*
      CLEAR st_edidd.
      st_edidd-segnam = lc_seg_roylty_trl.
      st_edidd-hlevel = lc_hlvl_02.

      st_rylty_trl-units_total       = lv_counter.                       " Units Total
*     st_rylty_trl-trans_amt_total   = lv_tot_trx_amt.
      st_rylty_trl-trans_amt_total   = lv_tot_rec_rev_amt.               " SAP Transaction amount
      st_rylty_trl-rev_rec_amt_total = lv_tot_rec_rev_amt.               " Total Recognized Revenue Amount

      st_edidd-sdata = st_rylty_trl.

      APPEND st_edidd TO i_edidd.
      CLEAR: st_edidd,
             st_rylty_trl,
             lv_tot_trx_amt,
             lv_tot_rec_rev_amt,
             lv_counter.

*     Posting IDOC
      PERFORM f_post_idoc USING <lst_amount>-contract_id
                                st_edidc
                                i_edidd
                                lv_data_error
                      CHANGING  fp_lst_output_det
                                fp_i_output_det.

      CLEAR: i_edidd,
             lv_data_error.
    ENDAT.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DATA_PROCESSING
*&---------------------------------------------------------------------*
*       Fetching of data and populating in Idoc
*----------------------------------------------------------------------*

FORM f_data_processing .

  DATA:    li_contract     TYPE tt_contract,
           li_contract_tmp TYPE tt_contract,
           li_amount       TYPE tt_amount,
           li_vbak         TYPE tt_vbak,
           li_vbrk         TYPE tt_vbrk,
           li_vbkd         TYPE tt_vbkd,
           li_bkpf         TYPE tt_bkpf,
           lst_output_det  TYPE ty_output_det.

* Subroutine to fetch data from tables
  PERFORM f_fetch_data CHANGING li_contract
                                li_contract_tmp
                                li_amount
                                li_vbak
                                li_vbrk
                                li_vbkd
                                li_bkpf.

* Subroutine to fetch Control Record for Outbound Idoc
  PERFORM f_control_data.

* Subroutine to populate Data Records in Idoc.
  PERFORM f_populate_data USING li_contract
                                li_contract_tmp
                                li_amount
                                li_vbak
                                li_vbrk
                                li_vbkd
                                li_bkpf
                       CHANGING lst_output_det
                                i_output_det.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POST_IDOC
*&---------------------------------------------------------------------*
*       Idoc Posting with Data Records
*----------------------------------------------------------------------*

FORM f_post_idoc  USING    fp_v_contract_id TYPE farr_contract_id " Revenue Recognition Contract ID
                           fp_st_edidc TYPE edidc                 " Control record (IDoc)
                           fp_i_edidd TYPE edidd_tt
                           fp_lv_data_error TYPE char256
                  CHANGING fp_lst_output_det TYPE ty_output_det
                           fp_i_output_det TYPE tt_output_det.

  DATA : lv_msg   TYPE string.
  DATA : li_idoc_st TYPE t_idoc_status.

* FM to post Outbound IDOC
  CALL FUNCTION 'MASTER_IDOC_DISTRIBUTE'
    EXPORTING
      master_idoc_control            = fp_st_edidc
    TABLES
      communication_idoc_control     = i_idoc_control
      master_idoc_data               = fp_i_edidd
    EXCEPTIONS
      error_in_idoc_control          = 1
      error_writing_idoc_status      = 2
      error_in_idoc_data             = 3
      sending_logical_system_unknown = 4
      OTHERS                         = 5.

  IF sy-subrc <> 0.
*   Implement suitable error handling here
    MESSAGE ID sy-msgid
    TYPE c_msgty_err
    NUMBER sy-msgno
    INTO lv_msg
    WITH sy-msgv1
         sy-msgv2
         sy-msgv3
         sy-msgv4.

    ROLLBACK WORK.
  ELSE. " ELSE -> IF sy-subrc <> 0
*   Apply Commit work
    COMMIT WORK AND WAIT.

*   Getting the IDOC Number for every Idoc that is being processed.
    READ TABLE i_idoc_control INTO DATA(lst_idoc_control) INDEX 1.
    IF sy-subrc IS INITIAL.
      fp_lst_output_det-idoc_number = lst_idoc_control-docnum.

      IF fp_lv_data_error IS NOT INITIAL.
        fp_lst_output_det-data_error = abap_true.

*       Prepare IDOC Status Record
        APPEND INITIAL LINE TO li_idoc_st ASSIGNING FIELD-SYMBOL(<lst_idoc_st>).
        <lst_idoc_st>-docnum = lst_idoc_control-docnum. " IDoc number
        <lst_idoc_st>-status = c_err_idoc_st.           " Status of IDoc
*       Determine the Message Variables
        CALL FUNCTION 'RKD_WORD_WRAP'
          EXPORTING
            textline            = fp_lv_data_error
            outputlen           = 50
          IMPORTING
            out_line1           = sy-msgv1              " Parameter 1
            out_line2           = sy-msgv2              " Parameter 2
            out_line3           = sy-msgv3              " Parameter 3
          EXCEPTIONS
            outputlen_too_large = 1
            OTHERS              = 2.
        IF sy-subrc EQ 0.
*         Message: Mandatory field &1 &2 &3 not/incorrectly maintained
          MESSAGE e329(88)
             WITH sy-msgv1
                  sy-msgv2
                  sy-msgv3
             INTO DATA(lv_msg_txt).
          <lst_idoc_st>-msgty = sy-msgty.               " Message Type
          <lst_idoc_st>-msgid = sy-msgid.               " Message identification
          <lst_idoc_st>-msgno = sy-msgno.               " Message Number
          <lst_idoc_st>-msgv1 = sy-msgv1.               " Parameter 1
          <lst_idoc_st>-msgv2 = sy-msgv2.               " Parameter 2
          <lst_idoc_st>-msgv3 = sy-msgv3.               " Parameter 3
        ENDIF.

*       Change the IDOC status to 05 (Error During Translation)
        CALL FUNCTION 'IDOC_STATUS_WRITE_TO_DATABASE'
          EXPORTING
            idoc_number               = lst_idoc_control-docnum
          TABLES
            idoc_status               = li_idoc_st
          EXCEPTIONS
            idoc_foreign_lock         = 1
            idoc_not_found            = 2
            idoc_status_records_empty = 3
            idoc_status_invalid       = 4
            db_error                  = 5
            OTHERS                    = 6.
        IF sy-subrc EQ 0.
*         Apply Commit work
          COMMIT WORK AND WAIT.
        ENDIF.
      ENDIF.
      CLEAR : lst_idoc_control,
              i_idoc_control.
    ENDIF. " IF sy-subrc IS INITIAL

*   Appending the Contract_ID data into the Report Output Table
    fp_lst_output_det-contract_id = fp_v_contract_id.
    APPEND fp_lst_output_det TO fp_i_output_det.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_LAST_RUNDATE
*&---------------------------------------------------------------------*
*       Subroutine to fetch Last Rundate and RunTime
*----------------------------------------------------------------------*

FORM f_fetch_last_rundate.

*--------------------------------------------------------------------*
*    L O C A L     W O R K - A R E A
*--------------------------------------------------------------------*
  DATA: lst_zcaint_lastrun TYPE ty_zcaint,
        lst_date_range     TYPE ty_datum,
        lv_syst_timezone   TYPE timezone.
*--------------------------------------------------------------------*
*    L O C A L    C O N S T A N T S
*--------------------------------------------------------------------*
  CONSTANTS : lc_param1 TYPE rvari_vnam VALUE 'PARAM1', " ABAP: Name of Variant Variable
              lc_param2 TYPE rvari_vnam VALUE '001'.    " ABAP: Name of Variant Variable

  CALL FUNCTION 'GET_SYSTEM_TIMEZONE'
    IMPORTING
      timezone            = lv_syst_timezone
    EXCEPTIONS
      customizing_missing = 1
      OTHERS              = 2.
  IF sy-subrc <> 0.
    CLEAR: lv_syst_timezone.
  ENDIF.

*Selecting data from ZCAINTERFACE table
  SELECT SINGLE devid  " Development ID
                param1 " ABAP: Name of Variant Variable
                param2 " ABAP: Name of Variant Variable
                lrdat  " Last run date
                lrtime " Last run time
    FROM zcainterface  " Interface run details
    INTO lst_zcaint_lastrun
    WHERE devid = c_devid
    AND param1 = lc_param1
    AND param2 = lc_param2.

*  IF rb_1st EQ abap_true.
  IF sy-subrc IS INITIAL.
*   Calculate UTC Timestamp (Last Run)
    CONVERT DATE lst_zcaint_lastrun-lrdat
            TIME lst_zcaint_lastrun-lrtime
       INTO TIME STAMP v_lr_dt_tm
       TIME ZONE lv_syst_timezone.
*   Begin of ADD:ERP-3783:WROY:07-AUG-2017:ED2K907760
    v_lr_date = lst_zcaint_lastrun-lrdat.
*   End   of ADD:ERP-3783:WROY:07-AUG-2017:ED2K907760
  ENDIF. " IF sy-subrc IS INITIAL

  CLEAR: v_datum,
         v_uzeit.

  v_datum = sy-datum.
  v_uzeit = sy-uzeit.
* Calculate UTC Timestamp (Current)
  CONVERT DATE v_datum
          TIME v_uzeit
     INTO TIME STAMP v_curr_dt_tm
     TIME ZONE lv_syst_timezone.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_LAST_RUN_DAT
*&---------------------------------------------------------------------*
*       Subroutine to update the Last Run date and Time
*----------------------------------------------------------------------*

FORM f_update_last_run_dat .

  DATA:       lst_zcaint_lastrun TYPE zcainterface.     " Interface run details

  CONSTANTS : lc_param1 TYPE rvari_vnam VALUE 'PARAM1', " ABAP: Name of Variant Variable
              lc_param2 TYPE rvari_vnam VALUE '001'.    " ABAP: Name of Variant Variable

* Lock the Table entry
  CALL FUNCTION 'ENQUEUE_EZCAINTERFACE'
    EXPORTING
      mode_zcainterface = abap_true "Lock mode
      mandt             = sy-mandt  "01th enqueue argument (Client)
      devid             = c_devid   "02th enqueue argument (Development ID)
      param1            = lc_param1 "03th enqueue argument (ABAP: Name of Variant Variable)
      param2            = lc_param2 "04th enqueue argument (ABAP: Name of Variant Variable)
    EXCEPTIONS
      foreign_lock      = 1
      system_failure    = 2
      OTHERS            = 3.

  IF sy-subrc EQ 0.
    CLEAR  lst_zcaint_lastrun.

    lst_zcaint_lastrun-mandt  = sy-mandt. "Client
    lst_zcaint_lastrun-devid  = c_devid. "Development ID
    lst_zcaint_lastrun-param1 = lc_param1. "ABAP: Name of Variant Variable
    lst_zcaint_lastrun-param2 = lc_param2. "ABAP: Name of Variant Variable
    lst_zcaint_lastrun-lrdat  = v_datum. "Last run date
    lst_zcaint_lastrun-lrtime = v_uzeit. "Last run time

*   Modify (Insert / Update) the Table entry
    MODIFY zcainterface FROM lst_zcaint_lastrun.
*   Unlock the Table entry
    CALL FUNCTION 'DEQUEUE_EZCAINTERFACE'.

  ELSE. " ELSE -> IF sy-subrc EQ 0

*   Error Message
    MESSAGE ID sy-msgid     "Message Class
          TYPE c_msgty_info "Message Type: Information
        NUMBER sy-msgno     "Message Number
          WITH sy-msgv1     "Message Variable-1
               sy-msgv2     "Message Variable-2
               sy-msgv3     "Message Variable-3
               sy-msgv4.    "Message Variable-4
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DEFAULTS
*&---------------------------------------------------------------------*
*       Default values in Selection Screen
*----------------------------------------------------------------------*

*Begin of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*FORM f_populate_defaults  CHANGING fp_s_ismtyp TYPE tt_pubtyp
*End   of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*Begin of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
FORM f_populate_defaults  CHANGING fp_s_mvgr1 TYPE tt_mat_grp_1
*End   of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
                                   fp_s_doctyp TYPE tt_srcdoc_type
                                   fp_s_raic TYPE tt_raic
                                   fp_s_status TYPE tt_status
* Begin of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
                                   fp_s_pst_ct TYPE tt_pst_ct
* End   of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
                                   fp_s_rec_st TYPE tt_rec_st.

* Begin of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
* APPEND INITIAL LINE TO fp_s_ismtyp ASSIGNING FIELD-SYMBOL(<lst_ismtyp>).
* <lst_ismtyp>-sign   = c_sign. "Sign: (I)nclude
* <lst_ismtyp>-option = c_opti. "Option: (EQ)ual
* <lst_ismtyp>-low    = c_pubtyp_6.
* <lst_ismtyp>-high   = space.
*
* APPEND INITIAL LINE TO fp_s_ismtyp ASSIGNING <lst_ismtyp>.
* <lst_ismtyp>-sign   = c_sign. "Sign: (I)nclude
* <lst_ismtyp>-option = c_opti. "Option: (EQ)ual
* <lst_ismtyp>-low    = c_pubtyp_bk.
* <lst_ismtyp>-high   = space.
*
* APPEND INITIAL LINE TO fp_s_ismtyp ASSIGNING <lst_ismtyp>.
* <lst_ismtyp>-sign   = c_sign. "Sign: (I)nclude
* <lst_ismtyp>-option = c_opti. "Option: (EQ)ual
* <lst_ismtyp>-low    = c_pubtyp_cp.
* <lst_ismtyp>-high   = space.
*
* APPEND INITIAL LINE TO fp_s_ismtyp ASSIGNING <lst_ismtyp>.
* <lst_ismtyp>-sign   = c_sign. "Sign: (I)nclude
* <lst_ismtyp>-option = c_opti. "Option: (EQ)ual
* <lst_ismtyp>-low    = c_pubtyp_mr.
* <lst_ismtyp>-high   = space.
* End   of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
* Begin of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
  APPEND INITIAL LINE TO fp_s_mvgr1 ASSIGNING FIELD-SYMBOL(<lst_mvgr1>).
  <lst_mvgr1>-sign   = c_sign. "Sign: (I)nclude
  <lst_mvgr1>-option = c_opti. "Option: (EQ)ual
  <lst_mvgr1>-low    = c_mvgr1_ol.
  <lst_mvgr1>-high   = space.

  APPEND INITIAL LINE TO fp_s_mvgr1 ASSIGNING <lst_mvgr1>.
  <lst_mvgr1>-sign   = c_sign. "Sign: (I)nclude
  <lst_mvgr1>-option = c_opti. "Option: (EQ)ual
  <lst_mvgr1>-low    = c_mvgr1_cp.
  <lst_mvgr1>-high   = space.

  APPEND INITIAL LINE TO fp_s_mvgr1 ASSIGNING <lst_mvgr1>.
  <lst_mvgr1>-sign   = c_sign. "Sign: (I)nclude
  <lst_mvgr1>-option = c_opti. "Option: (EQ)ual
  <lst_mvgr1>-low    = c_mvgr1_em.
  <lst_mvgr1>-high   = space.

  APPEND INITIAL LINE TO fp_s_mvgr1 ASSIGNING <lst_mvgr1>.
  <lst_mvgr1>-sign   = c_sign. "Sign: (I)nclude
  <lst_mvgr1>-option = c_opti. "Option: (EQ)ual
  <lst_mvgr1>-low    = c_mvgr1_ne.
  <lst_mvgr1>-high   = space.

  APPEND INITIAL LINE TO fp_s_mvgr1 ASSIGNING <lst_mvgr1>.
  <lst_mvgr1>-sign   = c_sign. "Sign: (I)nclude
  <lst_mvgr1>-option = c_opti. "Option: (EQ)ual
  <lst_mvgr1>-low    = c_mvgr1_ed.
  <lst_mvgr1>-high   = space.

  APPEND INITIAL LINE TO fp_s_mvgr1 ASSIGNING <lst_mvgr1>.
  <lst_mvgr1>-sign   = c_sign. "Sign: (I)nclude
  <lst_mvgr1>-option = c_opti. "Option: (EQ)ual
  <lst_mvgr1>-low    = c_mvgr1_tp.
  <lst_mvgr1>-high   = space.
* End   of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467

  APPEND INITIAL LINE TO fp_s_doctyp ASSIGNING FIELD-SYMBOL(<lst_doctyp>).
  <lst_doctyp>-sign   = c_sign. "Sign: (I)nclude
  <lst_doctyp>-option = c_opti. "Option: (EQ)ual
  <lst_doctyp>-low    = c_doctyp_sdii.
  <lst_doctyp>-high   = space.

  APPEND INITIAL LINE TO fp_s_raic ASSIGNING FIELD-SYMBOL(<lst_raic>).
  <lst_raic>-sign   = c_sign. "Sign: (I)nclude
  <lst_raic>-option = c_opti. "Option: (EQ)ual
  <lst_raic>-low    = c_raic_sd03.
  <lst_raic>-high   = space.

  APPEND INITIAL LINE TO fp_s_status ASSIGNING FIELD-SYMBOL(<lst_status>).
  <lst_status>-sign   = c_sign. "Sign: (I)nclude
  <lst_status>-option = c_opti. "Option: (EQ)ual
  <lst_status>-low    = c_stat_4.
  <lst_status>-high   = space.

* Begin of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
  APPEND INITIAL LINE TO fp_s_pst_ct ASSIGNING FIELD-SYMBOL(<lst_pst_ct>).
  <lst_pst_ct>-sign   = c_sign. "Sign: (I)nclude
  <lst_pst_ct>-option = c_opti. "Option: (EQ)ual
  <lst_pst_ct>-low    = c_post_cat_rv.
  <lst_pst_ct>-high   = space.
* End   of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180

  APPEND INITIAL LINE TO fp_s_rec_st ASSIGNING FIELD-SYMBOL(<lst_rec_st>).
  <lst_rec_st>-sign   = c_sign. "Sign: (I)nclude
  <lst_rec_st>-option = c_opti. "Option: (EQ)ual
  <lst_rec_st>-low    = c_rec_stat_a.
  <lst_rec_st>-high   = space.

  APPEND INITIAL LINE TO fp_s_rec_st ASSIGNING <lst_rec_st>.
  <lst_rec_st>-sign   = c_sign. "Sign: (I)nclude
  <lst_rec_st>-option = c_opti. "Option: (EQ)ual
  <lst_rec_st>-low    = c_rec_stat_c.
  <lst_rec_st>-high   = space.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_OUTPUT
*&---------------------------------------------------------------------*
*       Generate a Report Output
*----------------------------------------------------------------------*

FORM f_display_output  USING  fp_i_output_det TYPE tt_output_det.

*  Build Fieldcatalog
  PERFORM f_build_fieldcatalog.

*  Display ALV
  PERFORM f_display_alv CHANGING fp_i_output_det.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_fieldcatalog .

  DATA: lst_fieldcatalog TYPE slis_fieldcat_alv.

  CONSTANTS: lc_idoc     TYPE slis_fieldname VALUE 'IDOC_NUMBER',
             lc_contract TYPE slis_fieldname VALUE 'CONTRACT_ID',
             lc_data_err TYPE slis_fieldname VALUE 'DATA_ERROR'.

* Populate fieldcatalog : IDOC Number
  lst_fieldcatalog-fieldname   = lc_idoc.
  lst_fieldcatalog-seltext_m   = 'Idoc Number'(003).
  lst_fieldcatalog-col_pos     = 0.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

* Populate fieldcatalog : Contract_ID
  lst_fieldcatalog-fieldname   = lc_contract.
  lst_fieldcatalog-seltext_m   = 'Contract ID'(004).
  lst_fieldcatalog-col_pos     = 1.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

* Populate fieldcatalog : Flag for Data Error
  lst_fieldcatalog-fieldname   = lc_data_err.
  lst_fieldcatalog-seltext_m   = 'Data Error'(007).
  lst_fieldcatalog-col_pos     = 2.
  APPEND lst_fieldcatalog TO i_fieldcatalog.
  CLEAR  lst_fieldcatalog.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*       To display ALV
*----------------------------------------------------------------------*

FORM f_display_alv  CHANGING fp_i_output_det TYPE tt_output_det.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = i_fieldcatalog[]
      i_save             = abap_true
    TABLES
      t_outtab           = fp_i_output_det
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    CLEAR i_fieldcatalog[].
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*Begin of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
**&---------------------------------------------------------------------*
**&      Form  F_VALIDATE_ISMTYP
**&---------------------------------------------------------------------*
**       Validation of Publication Type
**----------------------------------------------------------------------*
*
*FORM f_validate_ismtyp  USING  fp_s_ismtyp TYPE tt_pubtyp.
*
*  SELECT SINGLE ismpubltype " Publication Type
*    FROM tjppubtp           " Publication Type Customizing Table
*    INTO @DATA(lv_publtyp)
*    WHERE ismpubltype IN @fp_s_ismtyp.
*  IF sy-subrc NE 0.
**   Message: Invalid Publication Type
*    MESSAGE e135(zqtc_r2) WITH lv_publtyp. " Invalid Project Definition
*  ENDIF. " IF sy-subrc NE 0
*
*ENDFORM.
*End   of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*Begin of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MAT_GRP_1
*&---------------------------------------------------------------------*
*       Validation of Publication Type
*----------------------------------------------------------------------*

FORM f_validate_mat_grp_1  USING  fp_s_mvgr1 TYPE tt_mat_grp_1.

  SELECT SINGLE mvgr1   " Material group 1
    FROM tvm1           " Material Pricing Group 1
    INTO @DATA(lv_mvgr1)
    WHERE mvgr1 IN @fp_s_mvgr1.
  IF sy-subrc NE 0.
*   Message: Invalid Material Group 1
    MESSAGE e241(zqtc_r2). " Invalid Material Group 1
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*End   of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_RAIC
*&---------------------------------------------------------------------*
*       Validation of Revenue Accounting Item Class
*----------------------------------------------------------------------*

FORM f_validate_raic  USING  fp_s_raic TYPE tt_raic.

  SELECT SINGLE raic  " Revenue Accounting Item Class
    FROM farr_c_rai01 " Revenue Accounting Item Classes
    INTO @DATA(lv_raic)
    WHERE raic IN @fp_s_raic.
  IF sy-subrc NE 0.
*   Message: Invalid Revenue Accounting Item Class
    MESSAGE e172(zqtc_r2). " Invalid Project Definition
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SELECT_RADIO
*&---------------------------------------------------------------------*
*       Sub Routine to select radio button for Interface Run and selection
*       date range(Manual Run)
*----------------------------------------------------------------------*

FORM f_select_radio .

  CONSTANTS: lc_app TYPE char3 VALUE 'DAT'. " App of type CHAR3

  IF rb_1st = abap_true.
    LOOP AT SCREEN.
      IF  screen-group1 = lc_app.
        screen-input = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = lc_app
    ENDLOOP. " LOOP AT SCREEN
  ELSEIF rb_2nd = abap_true.
    LOOP AT SCREEN.
      IF  screen-group1 = lc_app.
        screen-input = 1.
        screen-invisible = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = lc_app
    ENDLOOP. " LOOP AT SCREEN
  ENDIF. " IF rb_1st = abap_true

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_RUN_DT
*&---------------------------------------------------------------------*
*       Sub-routine to get the Fiscal Year and period for the current run date
*----------------------------------------------------------------------*

FORM f_run_dt  USING  fp_lv_compcod     TYPE bapi0002_2-comp_code          " Company Code
                  CHANGING fp_lv_posting_dt TYPE bapi0002_4-posting_date   " Posting Date in the Document
                           fp_lv_fiscal_year TYPE bapi0002_4-fiscal_year   " Fiscal Year
                           fp_lv_fiscal_prd  TYPE bapi0002_4-fiscal_period " Fiscal Period
                           fp_lv_period      TYPE numc3                    " Numc3, internal use
                           fp_lv_fiscal_curr TYPE char7.                   " Lv_fiscal_last of type CHAR7

  DATA lst_return TYPE bapireturn1. " Return Parameter

  CALL FUNCTION 'BAPI_COMPANYCODE_GET_PERIOD'
    EXPORTING
      companycodeid = fp_lv_compcod
      posting_date  = fp_lv_posting_dt "v_date
    IMPORTING
      fiscal_year   = fp_lv_fiscal_year
      fiscal_period = fp_lv_fiscal_prd
      return        = lst_return.

  IF lst_return IS INITIAL.

* Converting 2-digit Fiscal Period into a 3-digit Fiscal Period
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = fp_lv_fiscal_prd
      IMPORTING
        output = fp_lv_period.

* Concatenating the Fiscal Year and the Fiscal Period into a local variable
    CONCATENATE fp_lv_fiscal_year fp_lv_period INTO fp_lv_fiscal_curr.
  ENDIF. " IF lst_return IS INITIAL
ENDFORM.
