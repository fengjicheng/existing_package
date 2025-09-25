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

TYPES : BEGIN OF ty_contract,
          company_code    TYPE bukrs,     " Company Code
          acct_principle  TYPE accounting_principle,   " Accounting Principle
          contract_id     TYPE farr_contract_id,       " Revenue Recognition Contract ID
          gjahr           TYPE gjahr,                  " Fiscal Year
          poper           TYPE poper,                  " Posting period
          recon_key       TYPE farr_recon_key,         " Revenue Reconciliation Key
          keypp           TYPE farr_keypp,             " Subarea for Parallelization
          status          TYPE farr_recon_key_status,  " Status of Revenue Reconciliation Key
          type            TYPE farr_recon_key_type,    " Reconciliation Key Type
          tm_convert      TYPE farr_tm_convert,        " Time based deferral item transferred
          liab_asset_flag TYPE farr_liab_asset_flag,   " Posting Job Includes Contract Liabilities/Assets
          runid           TYPE farr_run_id,            " Posting Service Run ID
          run_date        TYPE datum,                  " Date
          zz_vbeln        TYPE vbeln_va,               " Sales Document
          pob_id          TYPE farr_pob_id,            " Performance Obligation ID
          zz_posnr        TYPE posnr_va,               " Sales Document Item
          alloc_amt       TYPE farr_alloc_amt,         " Allocated Amount
          trx_price       TYPE farr_transaction_price, " Transaction Price
          srcdoc_id       TYPE farr_rai_srcid,         " Source Item ID
          origdoc_id      TYPE farr_rai_oriid,         " Original Item ID
          due_date        TYPE farr_due_date,          " Invoice Due Date
          bismt           TYPE bismt,                  " Old material number
        END OF ty_contract,

        BEGIN OF ty_amount,
          contract_id    TYPE farr_contract_id,     " Revenue Recognition Contract ID
          pob_id         TYPE farr_pob_id,          " Performance Obligation ID
          recon_key      TYPE farr_recon_key,       " Revenue Reconciliation Key
          company_code   TYPE bukrs,                " Company Code
          rev_amt_delta  TYPE farr_amount_tc,       " Amount in Transaction Currency
          acct_principle TYPE accounting_principle, " Accounting Principle
          condition_type TYPE kscha,               " Condition type
          post_cat       TYPE farr_post_category,  " Category for Posting Document
          shkzg          TYPE shkzg,               " Debit/Credit Indicator
          guid           TYPE farr_posting_guid,   " Posting Table GUID
*         Begin of ADD:Conv Ord:WROY:15-Feb-2018:ED2K910918
          gjahr          TYPE gjahr,               " Fiscal Year
*         End   of ADD:Conv Ord:WROY:15-Feb-2018:ED2K910918
*         Begin of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
*         End   of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
*         Begin of DEL:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
*         rev_amt_delta TYPE farr_amount,          " Amount of Revenue Accounting Item
*         fulfill_type  TYPE farr_fulfill_type,    " Fulfillment Type
*         timestamp     TYPE timestamp,            " UTC Time Stamp in Short Form (YYYYMMDDhhmmss)
*         End   of DEL:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
        END OF ty_amount,

        BEGIN OF ty_vbak,
          vbeln TYPE vbeln_va,                     " Sales Document
          bname TYPE bname_v,                      " Name of orderer
*         Begin of ADD:Conv Ord:WROY:15-Feb-2018:ED2K910918
          waerk TYPE waerk,                        " SD Document Currency
*         End   of ADD:Conv Ord:WROY:15-Feb-2018:ED2K910918
*         Begin of ADD:ERP-7131:WROY:19-Mar-2018:ED2K911451
          txtnm TYPE tdobname,                     " Text Name
*         End   of ADD:ERP-7131:WROY:19-Mar-2018:ED2K911451
        END OF ty_vbak,

        BEGIN OF ty_vbrk,
          vbeln TYPE vbeln_vf,                     " Billing Document
          fkart TYPE fkart,                        " Billing Type
          waerk TYPE fkart,                        " Billing Type
          vsbed TYPE vsbed,                        " Shipping Conditions
          fkdat TYPE fkdat,                        " Billing date for billing index and printout
          konda TYPE konda,                        " Price group (customer)
          kdgrp TYPE kdgrp,                        " Customer group
          inco1 TYPE inco1,                        " Incoterms (Part 1)
        END OF ty_vbrk,

        BEGIN OF ty_vbkd,
          vbeln TYPE vbeln,                        " Sales and Distribution Document Number
          posnr TYPE posnr,                        " Item number of the SD document
          prsdt TYPE prsdt,                        " Date for pricing and exchange rate
        END OF ty_vbkd,

        BEGIN OF ty_bkpf,
          gjahr TYPE gjahr,                        " Fiscal Year
          awtyp TYPE awtyp,                        " Reference Transaction
          awkey TYPE awkey,                        " Reference Key
        END OF ty_bkpf,

        BEGIN OF ty_fiscal_range,
          sign   TYPE tvarv_sign,                  " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv_opti,                  " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE char7,                       " Low of type CHAR7
          high   TYPE char7,                       " High of type CHAR7
        END OF ty_fiscal_range,

        BEGIN OF ty_zcaint,
          devid  TYPE zdevid,                      " Development ID
          param1 TYPE rvari_vnam,                  " Name of Variant Variable
          param2 TYPE rvari_vnam,                  " Name of Variant Variable
          lrdat  TYPE sy-datlo,                    " Last run date
          lrtime TYPE sy-timlo,                    " Last run time
        END OF ty_zcaint,

        ty_datum TYPE  /grcpi/gria_s_date_range,   " Date Range

        BEGIN OF ty_srcdoc_type,
          sign   TYPE tvarv-sign,                  " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv-opti,                  " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE farr_rai_srcty,              " ABAP/4: Selection value (LOW or HIGH value, external format)
          high   TYPE farr_rai_srcty,              " ABAP/4: Selection value (LOW or HIGH value, external format)
        END OF ty_srcdoc_type,

        BEGIN OF ty_raic,
          sign   TYPE tvarv-sign,                  " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv-opti,                  " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE farr_raic,                   " ABAP/4: Selection value (LOW or HIGH value, external format)
          high   TYPE farr_raic,                   " ABAP/4: Selection value (LOW or HIGH value, external format)
        END OF ty_raic,

        BEGIN OF ty_status,
          sign   TYPE tvarv-sign,                  " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv-opti,                  " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE farr_rai_status,             " ABAP/4: Selection value (LOW or HIGH value, external format)
          high   TYPE farr_rai_status,             " ABAP/4: Selection value (LOW or HIGH value, external format)
        END OF ty_status,

*       Begin of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
        BEGIN OF ty_pst_ct,
          sign   TYPE tvarv-sign,                  " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv-opti,                  " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE farr_post_category,          " ABAP/4: Selection value (LOW or HIGH value, external format)
          high   TYPE farr_post_category,          " ABAP/4: Selection value (LOW or HIGH value, external format)
        END OF ty_pst_ct,
*       End   of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180

        BEGIN OF ty_rec_st,
          sign   TYPE tvarv-sign,                  " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv-opti,                  " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE farr_recon_key_status,       " ABAP/4: Selection value (LOW or HIGH value, external format)
          high   TYPE farr_recon_key_status,       " ABAP/4: Selection value (LOW or HIGH value, external format)
        END OF ty_rec_st,

        BEGIN OF ty_pobsta,
          sign   TYPE tvarv-sign,                  " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv-opti,                  " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE farr_pob_status,             " ABAP/4: Selection value (LOW or HIGH value, external format)
          high   TYPE farr_pob_status,             " ABAP/4: Selection value (LOW or HIGH value, external format)
        END OF ty_pobsta,

        BEGIN OF ty_output_det,
          idoc_number TYPE edi_docnum,             " Idoc Number
          contract_id TYPE farr_contract_id,       " Revenue Recognition Contract ID
          data_error  TYPE flag,                   " Flag: Date Error
        END OF ty_output_det,

*       Begin of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*       BEGIN OF ty_pubtyp_range,
*         sign   TYPE tvarv-sign,                  " ABAP: ID: I/E (include/exclude values)
*         option TYPE tvarv-opti,                  " ABAP: Selection option (EQ/BT/CP/...)
*         low    TYPE ismpubltype,                 " ABAP/4: Selection value (LOW or HIGH value, external format)
*         high   TYPE ismpubltype,                 " ABAP/4: Selection value (LOW or HIGH value, external format)
*       END OF ty_pubtyp_range,
*       End   of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*       Begin of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
        BEGIN OF ty_mat_grp_1_range,
          sign   TYPE tvarv-sign,                  " ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv-opti,                  " ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE mvgr1,                       " ABAP/4: Selection value (LOW or HIGH value, external format)
          high   TYPE mvgr1,                       " ABAP/4: Selection value (LOW or HIGH value, external format)
        END OF ty_mat_grp_1_range,
*       End   of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467


        tt_datum       TYPE /grcpi/gria_t_date_range,

        tt_srcdoc_type TYPE STANDARD TABLE OF ty_srcdoc_type INITIAL SIZE 0,

        tt_raic        TYPE STANDARD TABLE OF ty_raic INITIAL SIZE 0,

        tt_status      TYPE STANDARD TABLE OF ty_status INITIAL SIZE 0,

*       Begin of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
        tt_pst_ct      TYPE STANDARD TABLE OF ty_pst_ct INITIAL SIZE 0,
*       End   of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180

        tt_rec_st      TYPE STANDARD TABLE OF ty_rec_st INITIAL SIZE 0,

        tt_pobsta      TYPE STANDARD TABLE OF ty_pobsta INITIAL SIZE 0,

        tt_contract    TYPE STANDARD TABLE OF ty_contract INITIAL SIZE 0,

        tt_amount      TYPE STANDARD TABLE OF ty_amount  INITIAL SIZE 0,

        tt_vbak        TYPE STANDARD TABLE OF ty_vbak INITIAL SIZE 0,

        tt_vbrk        TYPE STANDARD TABLE OF ty_vbrk INITIAL SIZE 0,

        tt_vbkd        TYPE STANDARD TABLE OF ty_vbkd INITIAL SIZE 0,

        tt_bkpf        TYPE STANDARD TABLE OF ty_bkpf INITIAL SIZE 0,

        tt_output_det  TYPE STANDARD TABLE OF ty_output_det INITIAL SIZE 0,

*       Begin of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*       tt_pubtyp      TYPE STANDARD TABLE OF ty_pubtyp_range INITIAL SIZE 0.
*       End   of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*       Begin of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
        tt_mat_grp_1   TYPE STANDARD TABLE OF ty_mat_grp_1_range INITIAL SIZE 0.
*       End   of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467


DATA :         i_edidd        TYPE STANDARD TABLE OF edidd      INITIAL SIZE 0, " Data record (IDoc)
               i_idoc_control TYPE STANDARD TABLE OF edidc      INITIAL SIZE 0, " Control record (IDoc)
               i_output_det   TYPE tt_output_det,                               " Output details
               i_fieldcatalog TYPE slis_t_fieldcat_alv,                         " fieldcatalog table
               st_edidc       TYPE edidc,                                       " Control record (IDoc)
               st_edidd       TYPE edidd,                                       " Data record (IDoc)
               st_rylty_hdr   TYPE z1qtc_royalty_hdr,                           " I0340: Royalty Feed from Inv / Cred - Header
               st_rylty_itm   TYPE z1qtc_royalty_itm,                           " I0340: Royalty Feed from Inv / Cred - Item
               st_rylty_trl   TYPE z1qtc_royalty_trl,                           " I0340: Royalty Feed from Inv / Cred - Trailor
*              Begin of ADD:ERP-3783:WROY:07-AUG-2017:ED2K907760
               v_lr_date      TYPE sydatum,                                     " Last Run Date
*              End   of ADD:ERP-3783:WROY:07-AUG-2017:ED2K907760
               v_datum        TYPE sydatum,                                     " System Date
               v_uzeit        TYPE syuzeit,                                     " System Time
               v_lr_dt_tm     TYPE timestamp,                                   " UTC Time Stamp in Short Form (YYYYMMDDhhmmss)
               v_curr_dt_tm   TYPE timestamp,                                   " UTC Time Stamp in Short Form (YYYYMMDDhhmmss)
*              Begin of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*              v_pubtyp       TYPE mara-ismpubltype,                            " Publication Type
*              End   of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*              Begin of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
               v_mat_grp_1    TYPE mvke-mvgr1,                                  " Material Group 1
*              End   of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
               v_doctyp       TYPE /1ra/0sd034mi-srcdoc_type,                   " Source Document Item Type
               v_raic         TYPE /1ra/0sd034mi-raic,                          " Revenue Accounting Item Class
               v_status       TYPE /1ra/0sd034mi-status,                        " Status of Revenue Accounting Item
               v_rec_status   TYPE farr_d_recon_key-status,                     " Status of Revenue Reconciliation Key
               v_pob_stat     TYPE farr_d_pob-status,                           " Performance Obligation Status
*              Begin of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
               v_post_cat     TYPE farr_d_posting-post_cat,                     " Category for Posting Document
*              End   of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
               v_pdate        TYPE budat.                                       " Posting Date in the Document


CONSTANTS : c_sign        TYPE tvarv_sign      VALUE 'I',                " ABAP: ID: I/E (include/exclude values)
            c_opti        TYPE tvarv_opti      VALUE 'EQ',               " ABAP: Selection option (EQ/BT/CP/...)
            c_opti_le     TYPE tvarv_opti      VALUE 'LE',               " ABAP: Selection option (EQ/BT/CP/...)
            c_opti_bt     TYPE tvarv_opti      VALUE 'BT',               " ABAP: Selection option (EQ/BT/CP/...)
            c_ls          TYPE edi_rcvprt      VALUE 'LS',               " Partner Type of Receiver
            c_err_idoc_st TYPE edi_status      VALUE '05',               " Status of Error IDOCs
            c_msgtyp      TYPE edi_mestyp      VALUE 'ZQTC_ROYALTY',     " Message Type
            c_idoctyp     TYPE edi_idoctp      VALUE 'ZQTCB_ROYALTY_01', " Basic type
            c_devid       TYPE zdevid          VALUE 'I0340',            " Development ID
            c_time        TYPE sy-uzeit        VALUE '235959',           " ABAP System Field: Current Time of Application Server
            c_sep_comma   TYPE flag            VALUE ',',                " Separator: Comma
            c_msgty_info  TYPE sy-msgty        VALUE 'I',                " ABAP System Field: Message Type
            c_msgty_err   TYPE sy-msgty        VALUE 'E',                " ABAP System Field: Message Type
*           Begin of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*           c_pubtyp_6    TYPE ismpubltype     VALUE '06',               " Publication Type
*           c_pubtyp_bk   TYPE ismpubltype     VALUE 'BK',               " Publication Type
*           c_pubtyp_cp   TYPE ismpubltype     VALUE 'CP',               " Publication Type
*           c_pubtyp_mr   TYPE ismpubltype     VALUE 'MR',               " Publication Type
*           End   of DEL:ERP-6094:WROY:24-Jan-2018:ED2K910467
*           Begin of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
            c_mvgr1_ol    TYPE mvgr1           VALUE 'OL',               " Material Group 1 (OLBK)
            c_mvgr1_cp    TYPE mvgr1           VALUE 'CP',               " Material Group 1 (CPOL)
            c_mvgr1_em    TYPE mvgr1           VALUE 'EM',               " Material Group 1 (EMRW)
            c_mvgr1_ne    TYPE mvgr1           VALUE 'NE',               " Material Group 1 (NEMRW)
            c_mvgr1_ed    TYPE mvgr1           VALUE 'ED',               " Material Group 1 (EDATB)
            c_mvgr1_tp    TYPE mvgr1           VALUE 'TP',               " Material Group 1 (TPROD)
*           End   of ADD:ERP-6094:WROY:24-Jan-2018:ED2K910467
            c_doctyp_sdii TYPE farr_rai_srcty  VALUE 'SDII',             " Source Document Item Type
            c_raic_sd03   TYPE farr_raic       VALUE 'SD03',             " Revenue Accounting Item Class
            c_b           TYPE char1           VALUE 'B',                " B of type CHAR1
            c_stat_4      TYPE farr_rai_status VALUE '4',                " Status of Revenue Accounting Item
*           Begin of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
            c_post_cat_rv TYPE farr_post_category    VALUE 'RV',         " Category for Posting Document
*           End   of ADD:ERP-XXXX:WROY:09-Jan-2017:ED2K910180
            c_rec_stat_a  TYPE farr_recon_key_status VALUE 'A',          " Status of Revenue Reconciliation Key
            c_rec_stat_c  TYPE farr_recon_key_status VALUE 'C',          " Status of Revenue Reconciliation Key
            c_ful_type_t  TYPE farr_fulfill_type     VALUE 'T',          " Fulfillment Type (Time Based)
            c_stat_c      TYPE farr_pob_status VALUE 'C'.                " Performance Obligation Status
