***------------------------------------------------------------------------*
*** PROGRAM NAME: ZQTCN_BILL_PLAN_BILLING_DATE (Include)
***               Called from "EXIT_SAPLV60F_001 (ZX60FU01)"
*** PROGRAM DESCRIPTION: Update the Billing Date in Billing Plan
*** DEVELOPER: Anirban Saha
*** CREATION DATE:   08/22/2017
*** OBJECT ID: E107 / CR 463
*** TRANSPORT NUMBER(S): ED2K908135
***------------------------------------------------------------------------*
* REVISION HISTORY---------------------------------------------------------*
* REVISION NO: ED2K909014
* REFERENCE NO:  ERP 4822
* DEVELOPER: Anirban Saha
* DATE:  2017-10-16
* DESCRIPTION: Non-EAL orders should bring the billing date as today's date
*-------------------------------------------------------------------------*
* REVISION HISTORY---------------------------------------------------------*
* REVISION NO: ED2K909694
* REFERENCE NO:  ERP 5292
* DEVELOPER: Writtick Roy
* DATE:  2017-12-04
* DESCRIPTION: EAL Scenario - additional filter based on Customer PO Type
*-------------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO: ED2K909813
* REFERENCE NO: ERP-4931
* DEVELOPER: Writtick Roy
* DATE:  2017-12-12
* DESCRIPTION: Non-EAL Scenario: Use Start date for billing/invoice plan
*-------------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO: ED2K909813, ED2K909815
* REFERENCE NO: ERP-5249
* DEVELOPER: Writtick Roy
* DATE:  2017-12-12
* DESCRIPTION: Changes as per SAP's recommendations (OSS: 573737 / 2017)
*-------------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO: ED2K910125
* REFERENCE NO: SAP's recommendations
* DEVELOPER: Writtick Roy
* DATE:  2018-01-05
* DESCRIPTION: Changes as per SAP's recommendations
*-------------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO: ED2K910322
* REFERENCE NO: ERP-5946
* DEVELOPER: Writtick Roy
* DATE:  2018-01-16
* DESCRIPTION: Some of the lines are missing FAZ entry
*-------------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO: ED2K911639
* REFERENCE NO: ERP-7250
* DEVELOPER: Writtick Roy
* DATE:  2018-03-28
* DESCRIPTION: Update Line Items if Header Billing Date is changed
*-------------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO: ED2K911774
* REFERENCE NO: ERP-7273
* DEVELOPER: Writtick Roy
* DATE:  2018-04-03
* DESCRIPTION: Use Billing Date instead of Start Date
*-------------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO: ED2K912409
* REFERENCE NO: ERP-6802
* DEVELOPER: Randheer Kumar (RKUMAR2/RK20180623)
* DATE:  2018-04-03
* DESCRIPTION: Create ZF5 billing under Billing Plan tab
* if Contract Start Date is > 30 days
*-------------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO: ED2K912853, ED2K912947, ED2K913123
* REFERENCE NO: CR#6122
* DEVELOPER(s): Rahul Tripathi(RTRIPAT22/RTR)
*             : Kiran Kumar Ravuri (KKRAVURI/KKR)
* DATE: 2018-08-04
* DESCRIPTION: Start date and Billing Date under Billing plan tab are
* updated from Billing date of Billing Doc. in case of Billing date passed
* from Inbound Subscription Order (I0230 with 026 Qualifier)
*-------------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO: ED2K914490
* REFERENCE NO:  CR7873
* DEVELOPER: PRABHU
* DATE:  2019-02-18
* DESCRIPTION:When Payment method gets updated to 'U' OR 'V' of ZREW,
* default billing plan date to 5th or 20th of the month from 10 days of modified date*
*-------------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO: ED1K911304
* REFERENCE NO:  INC0268352
* DEVELOPER: BTIRUVATHU
* DATE:  2019-08-11.
* DESCRIPTION: Invoices / Receipts being produced for Direct Debits
*                      not due to be collected until future date
*-------------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------------*
* REVISION NO: ED2K919114
* REFERENCE NO:  ERPM-21151
* DEVELOPER: AMOHAMMED
* DATE:  08/10/2020 (MM/DD/YYYY).
* DESCRIPTION: 1. When payment method is changed from Direct Debit
*                 to Firm Invoice on a future renewal contract.
*              2. When payment method is changed from Firm Invoice
*                 to Direct Debit on a future renewal contract.
*                 2.1 Action field is equal to 0001
*                 2.2 Action field is not equal to 0001
*              3. When the product is changed for DD and firm invoice on a
*              future renewal contract.
*              For all the above cases the Billling Date on the Future
*              Renewal Contract will be set to CS Activity Date of the current contract
*-------------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923739
* REFERENCE NO:  OTCM-37780
* DEVELOPER: Krishna Srikanth (Ksrikanth)
* DATE:  2021-06-09
* DESCRIPTION:  Added the logic to get the next business date & dispatch date.
*------------------------------------------------------------------- *
DATA:
  lv_strc_tkomk TYPE char40 VALUE '(SAPLV60F)TKOMK'.            "Communication Header for Pricing

FIELD-SYMBOLS:
  <lst_s_tkomk> TYPE komk.                                      "Communication Header for Pricing

DATA:
  lr_sofc_eal        TYPE rjksd_vkbur_range_tab,                  "Range: Sales Office (EAL)
  lr_sofc_n_eal      TYPE rjksd_vkbur_range_tab,                  "Range: Sales Office (Non-EAL)
* Begin of ADD:ERP-5292:WROY:03-Nov-2017:ED2K909694
  lr_po_type_eal     TYPE tdt_rg_bsark,                           "Range:Customer PO Type (EAL)
* End   of ADD:ERP-5292:WROY:03-Nov-2017:ED2K909694
* Begin of ADD:ERP-4931:WROY:12-Dec-2017:ED2K909813
  lr_po_type_agu     TYPE tdt_rg_bsark,                           "Range:Customer PO Type (AGU)
* End   of ADD:ERP-4931:WROY:12-Dec-2017:ED2K909813
* Begin of ADD:ERP-5092:WROY:17-NOV-2017:ED2K909495
  li_const_values    TYPE zcat_constants,                         "Table: Constant values
  lst_const_values   TYPE zcast_constant,                         "Structure: Constant value
* End   of ADD:ERP-5092:WROY:17-NOV-2017:ED2K909495
* Begin of DEL:ERP-5092:WROY:17-NOV-2017:ED2K909495
* li_const_values  TYPE STANDARD TABLE OF zcaconstant,          "Range: Constant table
* lst_const_values TYPE zcaconstant,                            "Range: Constant table
* End   of DEL:ERP-5092:WROY:17-NOV-2017:ED2K909495
* Begin of DEL:ERP-5249:WROY:12-Dec-2017:ED2K909813
* lt_vbkd          TYPE STANDARD TABLE OF vbkd,                 "Sales Document: Business Data
* End   of DEL:ERP-5249:WROY:12-Dec-2017:ED2K909813
* Begin of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
  lr_bukrs           TYPE acc_t_ra_bukrs,
  lr_auart           TYPE fip_t_auart_range,
  lr_zlsch           TYPE trty_zlsch_range,
  lr_bsark           TYPE tdt_rg_bsark,
  lv_bill_date_debit TYPE sy-datum,
  lv_debit_days      TYPE char2,
* End of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
  lst_veda           TYPE veda,
  lst_xfplt          TYPE fpltvb,
  lst_xfplt_n        TYPE fpltvb,
  lst_temp           TYPE fpltvb,

  lv_index           TYPE sy-tabix,
  lv_fplnr           TYPE fplnr,
  lv_faz             TYPE rfpln_d,                                "Billing/Invoicing Plan Number for FAZ
  lv_non_faz         TYPE rfpln_d,                                "Billing/Invoicing Plan Number for non-faz
  lv_zf5             TYPE rfpln_d,                                "Billing/Invoicing Plan Number for ZF5   "added for ERP-6802 RK20180623 ED2K912409
  lv_adv_days        TYPE rfpln_d,                                "advance days to check for ZF5           "added for ERP-6802 RK20180623 ED2K912409
  lv_adv_date        TYPE syst_datum,                             "Future contract start date to be checked "added for ERP-6802 RK20180623 ED2K912409
** Begin of ADD RTR #CR6122 ED2K912853 Variables for feting date form Memory
  lv_mem_name        TYPE char30,
  lv_fkdat2_230      TYPE dats,
**  END OF ADD RTR #CR6122 ED2K912853
  lv_vkorg           TYPE vkorg,                    ""added for ERP-7873
  lv_auart           TYPE auart,                    ""added for ERP-7873
  lv_prog            TYPE program_id,
  lv_prog1           TYPE program_id,
  lv_prog2(9)        TYPE c,
  set                TYPE i,
  lv_cust            TYPE c,
  lst_output         TYPE zrg_prog.
CONSTANTS:
  lc_devid_e164 TYPE zdevid      VALUE 'E164',                  "Development ID: E164
  lc_p1_sls_ofc TYPE rvari_vnam  VALUE 'SALES_OFFICE',          "Name of Variant Variable: Sales Office
* Begin of ADD:ERP-5292:WROY:03-Nov-2017:ED2K909694
  lc_p1_po_type TYPE rvari_vnam  VALUE 'CUST_PO_TYPE',          "Name of Variant Variable: Customer PO Type
* End   of ADD:ERP-5292:WROY:03-Nov-2017:ED2K909694
  lc_adv_days   TYPE rvari_vnam  VALUE 'ADVANCE_DAYS',          "added for ERP-6802 RK20180623 ED2K912409
  lc_reference  TYPE rvari_vnam  VALUE 'REFERENCE',             "Billing/Invoicing Plan Number
  lc_p2_eal     TYPE rvari_vnam  VALUE 'EAL',                   "Name of Variant Variable: EAL
  lc_p2_non_eal TYPE rvari_vnam  VALUE 'NON_EAL',               "Name of Variant Variable: NON_EAL
  lc_hdr        TYPE posnr       VALUE '000000',                "Header line item
  lc_posnr3     TYPE posnr       VALUE '000003',                "Line item 3
  lc_posnr2     TYPE posnr       VALUE '000002',                "Line item 2
  lc_posnr1     TYPE posnr       VALUE '000001',                "Line item 1
  lc_faz        TYPE fkara       VALUE 'FAZ',                   "Proposed billing type for an order-related billing document
  lc_non_faz    TYPE rvari_vnam  VALUE 'NON_FAZ',               "Proposed billing type for an order-related billing document
  lc_zf2        TYPE fkara       VALUE 'ZF2',                   "Proposed billing type for an order-related billing document
  lc_zf5        TYPE fkara       VALUE 'ZF5',                   "added for ERP-6802 RK20180623 ED2K912409
  lc_bukrs      TYPE rvari_vnam  VALUE 'BUKRS',                 "added for ERP-7873
  lc_zlsch      TYPE rvari_vnam  VALUE 'ZLSCH',                 "added for ERP-7873
  lc_auart      TYPE rvari_vnam  VALUE 'AUART',                 "added for ERP-7873
  lc_bsark      TYPE rvari_vnam  VALUE 'BSARK',                  "added for ERP-7873
  lc_days       TYPE rvari_vnam  VALUE 'DAYS',                   "added for ERP-7873
  lc_debit      TYPE rvari_vnam  VALUE 'DEBIT'.                  "added for ERP-7873
* Begin of ADD:OTCM-37780:KRISHNA:07-JUL-2021
STATICS:li_constant    TYPE  zcat_constants,                         "Table: Constant values
        r_constant     TYPE  zdt_rg_prog.
* Begin of ADD:OTCM-37780:KRISHNA:07-JUL-2021
CLEAR: lst_xfplt, lst_xfplt_n, lv_index, lv_fplnr.

* Begin by AMOHAMMED on 08-10-2020 TR# ED2K919114
CONSTANTS : lc_xveda      TYPE char40     VALUE '(SAPLV45W)XVEDA[]',
            lc_header     TYPE posnr_va   VALUE '000000', " Header Item number
            lc_vaktsch    TYPE vasch_veda VALUE '0001',   " Action at end of contract
            lc_zsub       TYPE auart      VALUE 'ZSUB', " Subscription Order
            lc_zrew       TYPE auart      VALUE 'ZREW', " Renewal Order
            lc_cs         TYPE zactivity_sub VALUE 'CS',  " E095: Activity
            lc_save       TYPE syst_ucomm VALUE 'SICH',   " When SAVE button is pressed
            lc_yes        TYPE syst_ucomm VALUE 'YES',    " When YES button is pressed
            lc_e          TYPE char1      VALUE 'E',      " Error message
            lc_create     TYPE t180-trtyp  VALUE 'H',
* Begin of ADD:OTCM-37780:KRISHNA:07-JUL-2021
            lc_devid_e112 TYPE zdevid        VALUE 'E112', "Development ID
            lc_prog       TYPE rvari_vnam    VALUE 'PROG',
            lc_auart1     TYPE rvari_vnam    VALUE 'AUART',
            lc_sno1       TYPE tvarv_numb    VALUE '1',
            lc_sno8       TYPE tvarv_numb    VALUE '8',
            lc_program    TYPE program_id    VALUE 'ZE096_REN'.
* End of ADD:OTCM-37780:KRISHNA:07-JUL-2021
DATA : ls_doc_typ         TYPE vbak,
       ls_zqtc_renwl_plan TYPE zqtc_renwl_plan,
       li_xveda           TYPE STANDARD TABLE OF vedavb.   " Reference Structure XVEDA/YVEDA

STATICS : lv_error_flag TYPE c.
FIELD-SYMBOLS : <lfs_xveda> TYPE ztrar_vedavb.         " Changed records with new values, Unchanged records with old values

CLEAR : ls_zqtc_renwl_plan.
REFRESH : li_xveda.
* End by AMOHAMMED on 08-10-2020 TR# ED2K919114

* Get Cnonstant values
* Begin of ADD:ERP-5092:WROY:17-NOV-2017:ED2K909495
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e164                              "Development ID: E164
  IMPORTING
    ex_constants = li_const_values.                           "Constant Values
IF li_const_values IS NOT INITIAL.
* End   of ADD:ERP-5092:WROY:17-NOV-2017:ED2K909495
* Begin of DEL:ERP-5092:WROY:17-NOV-2017:ED2K909495
*SELECT *
*  FROM zcaconstant
*  INTO TABLE li_const_values
* WHERE devid    EQ lc_devid_e164                               "Development ID
*   AND activate EQ abap_true.                                  "Only active record
*IF sy-subrc IS INITIAL.
* End   of DEL:ERP-5092:WROY:17-NOV-2017:ED2K909495
  LOOP AT li_const_values ASSIGNING FIELD-SYMBOL(<lst_const_value>).
    CASE <lst_const_value>-param1.
      WHEN lc_p1_sls_ofc.                                       "Sales Office (SALES_OFFICE)
        CASE <lst_const_value>-param2.
          WHEN lc_p2_eal.                                       "EAL Only
            APPEND INITIAL LINE TO lr_sofc_eal ASSIGNING FIELD-SYMBOL(<lst_sales_offc>).
            <lst_sales_offc>-sign   = <lst_const_value>-sign.
            <lst_sales_offc>-option = <lst_const_value>-opti.
            <lst_sales_offc>-low    = <lst_const_value>-low.
            <lst_sales_offc>-high   = <lst_const_value>-high.

          WHEN lc_p2_non_eal.                                   "Non-EAL Only
            APPEND INITIAL LINE TO lr_sofc_n_eal ASSIGNING <lst_sales_offc>.
            <lst_sales_offc>-sign   = <lst_const_value>-sign.
            <lst_sales_offc>-option = <lst_const_value>-opti.
            <lst_sales_offc>-low    = <lst_const_value>-low.
            <lst_sales_offc>-high   = <lst_const_value>-high.
          WHEN OTHERS.
*           Nothing to do
        ENDCASE.
*     Begin of ADD:ERP-5292:WROY:03-Nov-2017:ED2K909694
      WHEN lc_p1_po_type.                                       "Customer PO Type (CUST_PO_TYPE)
        CASE <lst_const_value>-param2.
          WHEN lc_p2_eal.                                       "EAL Only
            APPEND INITIAL LINE TO lr_po_type_eal ASSIGNING FIELD-SYMBOL(<lst_cust_po_type>).
            <lst_cust_po_type>-sign   = <lst_const_value>-sign.
            <lst_cust_po_type>-option = <lst_const_value>-opti.
            <lst_cust_po_type>-low    = <lst_const_value>-low.
            <lst_cust_po_type>-high   = <lst_const_value>-high.
          WHEN OTHERS.
*           Nothing to do
        ENDCASE.
*     End   of ADD:ERP-5292:WROY:03-Nov-2017:ED2K909694
* Begin of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
      WHEN lc_bukrs.
        CASE <lst_const_value>-param2.
          WHEN lc_debit.
            APPEND INITIAL LINE TO lr_bukrs ASSIGNING FIELD-SYMBOL(<lfs_bukrs>).
            <lfs_bukrs>-sign   = <lst_const_value>-sign.
            <lfs_bukrs>-option = <lst_const_value>-opti.
            <lfs_bukrs>-low    = <lst_const_value>-low.
            <lfs_bukrs>-high   = <lst_const_value>-high.
          WHEN OTHERS.
        ENDCASE.
      WHEN lc_auart.
        CASE <lst_const_value>-param2.
          WHEN lc_debit.
            APPEND INITIAL LINE TO lr_auart ASSIGNING FIELD-SYMBOL(<lfs_auart>).
            <lfs_auart>-sign   = <lst_const_value>-sign.
            <lfs_auart>-option = <lst_const_value>-opti.
            <lfs_auart>-low    = <lst_const_value>-low.
            <lfs_auart>-high   = <lst_const_value>-high.
          WHEN OTHERS.
        ENDCASE.
      WHEN lc_zlsch.
        CASE <lst_const_value>-param2.
          WHEN lc_debit.
            APPEND INITIAL LINE TO lr_zlsch ASSIGNING FIELD-SYMBOL(<lfs_zlsch>).
            <lfs_zlsch>-sign   = <lst_const_value>-sign.
            <lfs_zlsch>-option = <lst_const_value>-opti.
            <lfs_zlsch>-low    = <lst_const_value>-low.
            <lfs_zlsch>-high   = <lst_const_value>-high.
          WHEN OTHERS.
        ENDCASE.
      WHEN lc_bsark.
        CASE <lst_const_value>-param2.
          WHEN lc_debit.
            APPEND INITIAL LINE TO lr_bsark ASSIGNING FIELD-SYMBOL(<lfs_bsark>).
            <lfs_bsark>-sign   = <lst_const_value>-sign.
            <lfs_bsark>-option = <lst_const_value>-opti.
            <lfs_bsark>-low    = <lst_const_value>-low.
            <lfs_bsark>-high   = <lst_const_value>-high.
          WHEN OTHERS.
        ENDCASE.
      WHEN lc_days.
        CASE <lst_const_value>-param2.
          WHEN lc_debit.
            lv_debit_days    = <lst_const_value>-low.
          WHEN OTHERS.
        ENDCASE.
* End of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF. " IF sy-subrc IS INITIAL

READ TABLE li_const_values INTO lst_const_values WITH KEY param1 = lc_reference
                                                          param2 = lc_faz.
IF sy-subrc = 0.
  lv_faz = lst_const_values-low.
ENDIF.
READ TABLE li_const_values INTO lst_const_values WITH KEY param1 = lc_reference
                                                          param2 = lc_non_faz.
IF sy-subrc = 0.
  lv_non_faz = lst_const_values-low.
ENDIF.

"BOC ERP-6802 RK20180623 ED2K912409
CLEAR: lst_const_values.
READ TABLE li_const_values INTO lst_const_values WITH KEY param1 = lc_reference
                                                          param2 = lc_zf5.
IF sy-subrc = 0.
  lv_zf5 = lst_const_values-low.
ENDIF.
CLEAR: lst_const_values.

READ TABLE li_const_values INTO lst_const_values WITH KEY param1 = lc_adv_days
                                                          param2 = lc_zf5.
IF sy-subrc = 0.
  lv_adv_days = lst_const_values-low.
  lv_adv_date = sy-datum + lv_adv_days.
ELSE.
  lv_adv_date = sy-datum.
ENDIF.
CLEAR: lst_const_values.
"EOC for ERP-6802 RK20180623 ED2K912409

*Begin of DEL:ERP-5249:WROY:12-Dec-2017:ED2K909813
*lt_vbkd[] = xvbkd[].
*DELETE lt_vbkd WHERE posnr = lc_hdr.
*End   of DEL:ERP-5249:WROY:12-Dec-2017:ED2K909813
lv_fplnr = vbkd-fplnr.

*Begin of Add-Anirban-10.16.2017-ED2K909014-Defect 4822
*Begin of DEL:ERP-5249:WROY:12-Dec-2017:ED2K909813
*IF t180-trtyp = 'V' OR t180-trtyp = 'H'.
*End   of DEL:ERP-5249:WROY:12-Dec-2017:ED2K909813
*Begin of ADD:ERP-5249:WROY:12-Dec-2017:ED2K909813
IF t180-trtyp EQ 'H' OR
   vbak-vkbur NE yvbak-vkbur OR
 ( vbkd-posnr IS NOT INITIAL AND
   vbkd-bsark NE *vbkd-bsark ).
*End   of ADD:ERP-5249:WROY:12-Dec-2017:ED2K909813
*End of Add-Anirban-10.16.2017-ED2K909014-Defect 4822
  IF NOT lv_fplnr IS INITIAL.

*-----Get contract start date
    CALL FUNCTION 'SD_VEDA_GET_DATA'
      IMPORTING
*       EF_DATALOSS       =
        es_veda = lst_veda.

    IF tkomk-vkbur IN lr_sofc_eal.

*     Begin of ADD:ERP-5292:WROY:03-Nov-2017:ED2K909694
*     IF lst_veda-vbegdat GT sy-datum.
*      IF lst_veda-vbegdat GT sy-datum AND "line commented for for ERP-6802 RK20180623 ED2K912409
      IF lst_veda-vbegdat GT lv_adv_date AND  " added for ERP-6802 RK20180623 ED2K912409
         vbkd-bsark       IN lr_po_type_eal.
*     End   of ADD:ERP-5292:WROY:03-Nov-2017:ED2K909694
        IF NOT fpla-rfpln IS INITIAL.
*          fpla-rfpln = lv_faz. "commented for for ERP-6802 RK20180623 ED2K912409
          fpla-rfpln = lv_zf5. "added for ERP-6802 RK20180623 ED2K912409
        ENDIF.

*       Begin of DEL:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
*       LOOP AT xfpla ASSIGNING FIELD-SYMBOL(<lst_xfpla>) WHERE fplnr = lv_fplnr.
*       End of DEL:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
*       Begin of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
        READ TABLE xfpla TRANSPORTING NO FIELDS
             WITH KEY fplnr = lv_fplnr
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          DATA(lv_tabix_fpla) = sy-tabix.
          LOOP AT xfpla ASSIGNING FIELD-SYMBOL(<lst_xfpla>) FROM lv_tabix_fpla.
            IF <lst_xfpla>-fplnr NE lv_fplnr.
              EXIT.
            ENDIF.
*       End of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
*         Begin of ADD:ERP-5249:WROY:12-Dec-2017:ED2K909813
            IF <lst_xfpla>-updkz IS INITIAL.
              DATA(lst_xfpla) = <lst_xfpla>.
              APPEND lst_xfpla TO yfpla.
              CLEAR: lst_xfpla.

              <lst_xfpla>-updkz = 'U'.
            ENDIF.
*         End   of ADD:ERP-5249:WROY:12-Dec-2017:ED2K909813
*            <lst_xfpla>-rfpln = lv_faz."commented for for ERP-6802 RK20180623 ED2K912409
            <lst_xfpla>-rfpln = lv_zf5. "added for ERP-6802 RK20180623 ED2K912409
          ENDLOOP.
*       Begin of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
        ENDIF. " IF sy-subrc EQ 0
*       End of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125

*** Begin of: CR#6802 KKR20180820  ED2K913123
*   Delete FAZ entries from xfplt[] if any
*   FAZ Entries deletion had been added as part of CR#6802 changes
*   Before CR#6802 changes, no deletion of FAZ entries
        READ TABLE xfplt TRANSPORTING NO FIELDS WITH KEY fkarv = lc_faz.
        IF sy-subrc = 0.
          DELETE xfplt WHERE fkarv = lc_faz.
        ENDIF.
*** End of: CR#6802 KKR20180820  ED2K913123

*       Begin of DEL:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
*       LOOP AT xfplt INTO lst_xfplt WHERE fkarv = lc_zf2 AND fplnr = lv_fplnr.
*       End of DEL:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
*       Begin of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
        READ TABLE xfplt TRANSPORTING NO FIELDS
             WITH KEY fplnr = lv_fplnr
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          DATA(lv_tabix_fplt) = sy-tabix.
          LOOP AT xfplt INTO lst_xfplt FROM lv_tabix_fplt. "WHERE fkarv = lc_zf2 AND fplnr = lv_fplnr.
            IF lst_xfplt-fplnr NE lv_fplnr.
              EXIT.
            ENDIF.
            IF lst_xfplt-fkarv NE lc_zf2.
              CONTINUE.
            ENDIF.
*       End of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
*           lst_xfplt_n = <lst_xfplt>.
            IF NOT ( lst_xfplt-fareg EQ '4' OR lst_xfplt-fareg EQ '5' ).
*             Begin of ADD:ERP-4980:WROY:09-Nov-2017:ED2K909399
              IF lst_xfplt-updkz IS INITIAL.
                APPEND lst_xfplt TO yfplt.
              ENDIF.
*             End   of ADD:ERP-4980:WROY:09-Nov-2017:ED2K909399
              lst_xfplt-afdat = lst_veda-vbegdat.
              lst_xfplt-fkdat = lst_veda-vbegdat.
*             Begin of ADD:ERP-4980:WROY:09-Nov-2017:ED2K909399
              IF lst_xfplt-updkz IS INITIAL.
                lst_xfplt-updkz = 'U'.
              ENDIF.
*             End   of ADD:ERP-4980:WROY:09-Nov-2017:ED2K909399
            ENDIF.
*           Begin of DEL:ERP-4980:WROY:09-Nov-2017:ED2K909399
*           lst_xfplt-fpltr = lc_posnr3.
*           End   of DEL:ERP-4980:WROY:09-Nov-2017:ED2K909399
            MODIFY xfplt FROM lst_xfplt.
*           Begin of ADD:ERP-5946:WROY:16-Jan-2018:ED2K910322
            lst_xfplt_n = lst_xfplt.
*           End   of ADD:ERP-5946:WROY:16-Jan-2018:ED2K910322
          ENDLOOP.
*       Begin of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
        ENDIF. " IF sy-subrc EQ 0
*       End   of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
*       Begin of DEL:ERP-5946:WROY:16-Jan-2018:ED2K910322
*       lst_xfplt_n = lst_xfplt.
*       End   of DEL:ERP-5946:WROY:16-Jan-2018:ED2K910322
        CLEAR lst_xfplt.
        " No need to append a FAZ line if already exists
        READ TABLE xfplt INTO lst_temp WITH KEY fkarv = lc_zf5   " lc_faz "FAZ changed for ERP-6802 RK20180623 ED2K912409
                                                fplnr = lv_fplnr.
        IF sy-subrc NE 0.
*         Begin of DEL:ERP-4931:WROY:12-Dec-2017:ED2K909813
*         lst_xfplt_n-afdat = sy-datum.
*         lst_xfplt_n-fkdat = sy-datum.
*         End   of DEL:ERP-4931:WROY:12-Dec-2017:ED2K909813
*         Begin of: CR#6802 KKR20180817  ED2K913123
*         This logic is added to fix the Dump issue occurs
*         at the backend during Renewal Sub Order Creation.
*         Dump Issue occurs due to ZF5 entries without FPLNR
*         (Bill Plan Number) in XFPLT[]
          IF lst_xfplt_n-fplnr IS INITIAL.
            lst_xfplt_n-fplnr = lv_fplnr.
          ENDIF.
*         End of: CR#6802 KKR20180817  ED2K913123
*         Begin of ADD:ERP-4931:WROY:12-Dec-2017:ED2K909813
          lst_xfplt_n-afdat = vbak-erdat.
          lst_xfplt_n-fkdat = vbak-erdat.
*         End   of ADD:ERP-4931:WROY:12-Dec-2017:ED2K909813
*         Begin of DEL:ERP-4980:WROY:09-Nov-2017:ED2K909399
*         lst_xfplt_n-fpltr = lc_posnr2.
*         End   of DEL:ERP-4980:WROY:09-Nov-2017:ED2K909399
*         Begin of ADD:ERP-4980:WROY:09-Nov-2017:ED2K909399
          lst_xfplt_n-fpltr = lst_xfplt_n-fpltr + 1.
          lst_xfplt_n-updkz = 'I'.
*         End   of ADD:ERP-4980:WROY:09-Nov-2017:ED2K909399
          lst_xfplt_n-fareg = '4'.
*          lst_xfplt_n-fkarv = lc_faz.           "commented for for ERP-6802 RK20180623 ED2K912409
          lst_xfplt_n-fkarv = lc_zf5.            "added for ERP-6802 RK20180623 ED2K912409
          APPEND lst_xfplt_n TO xfplt.
*         Begin of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
          SORT xfplt BY fplnr fpltr.
*         End   of ADD:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
        ENDIF.
        CLEAR: lst_xfplt_n.
*       Begin of DEL:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
*       SORT xfplt BY fplnr fpltr.
*       End   of DEL:SAP's Recommendations:WROY:05-Jan-2018:ED2K910125
*     Begin of ADD:ERP-5292:WROY:03-Nov-2017:ED2K909694
*     ELSEIF lst_veda-vbegdat LE sy-datum.
      ELSE. " ELSE -> IF lst_veda-vbegdat GT lv_adv_date AND
*     End   of ADD:ERP-5292:WROY:03-Nov-2017:ED2K909694
        IF NOT fpla-rfpln IS INITIAL.
          fpla-rfpln = lv_non_faz.
        ENDIF.
        LOOP AT xfpla ASSIGNING FIELD-SYMBOL(<lst_xfpla1>) WHERE fplnr = lv_fplnr.
*         Begin of ADD:ERP-5249:WROY:12-Dec-2017:ED2K909813
          IF <lst_xfpla1>-updkz IS INITIAL.
            lst_xfpla = <lst_xfpla1>.
            APPEND lst_xfpla TO yfpla.
            CLEAR: lst_xfpla.

            <lst_xfpla1>-updkz = 'U'.
          ENDIF.
*         End   of ADD:ERP-5249:WROY:12-Dec-2017:ED2K909813
          <lst_xfpla1>-rfpln = lv_non_faz.
        ENDLOOP.
*       Delete FAZ entries from XFLT[] if any
        READ TABLE xfplt TRANSPORTING NO FIELDS WITH KEY fkarv = lc_faz.
        " fplnr = lv_fplnr. " Commented for CR#6802 RKK20180820  ED2K913123
        IF sy-subrc = 0.
          DELETE xfplt WHERE fkarv = lc_faz. " AND fplnr = lv_fplnr. " Commented for CR#6802 RKK20180820  ED2K913123
        ENDIF.

        READ TABLE xfplt INTO lst_temp WITH KEY fkarv = lc_zf2
                                                fplnr = lv_fplnr.
        IF sy-subrc = 0.
          lv_index = sy-tabix.
*         Begin of DEL:ERP-4980:WROY:09-Nov-2017:ED2K909399
*         lst_temp-fpltr = lc_posnr1.
*         End   of DEL:ERP-4980:WROY:09-Nov-2017:ED2K909399
*         Begin of ADD:ERP-5249:WROY:12-Dec-2017:ED2K909813
          IF lst_temp-updkz IS INITIAL.
            APPEND lst_temp TO yfplt.
            lst_temp-updkz = 'U'.
          ENDIF.
*         End   of ADD:ERP-5249:WROY:12-Dec-2017:ED2K909813
*         Begin of DEL:ERP-4931:WROY:12-Dec-2017:ED2K909813
*         lst_temp-fkdat = sy-datum.
*         lst_temp-afdat = sy-datum.
*         End   of DEL:ERP-4931:WROY:12-Dec-2017:ED2K909813
*         Begin of ADD:ERP-4931:WROY:12-Dec-2017:ED2K909813
          lst_temp-fkdat = vbak-erdat.
          lst_temp-afdat = vbak-erdat.
*         End   of ADD:ERP-4931:WROY:12-Dec-2017:ED2K909813
          MODIFY xfplt FROM lst_temp INDEX lv_index.
          CLEAR lst_temp.
        ENDIF.

      ENDIF. " IF lst_veda-vbegdat GT lv_adv_date AND
*Begin of Add-Anirban-10.16.2017-ED2K909014-Defect 4822
    ELSE. " ELSE -> IF tkomk-vkbur IN lr_sofc_eal
      IF tkomk-vkbur IN lr_sofc_n_eal.
*       Begin of ADD:ERP-4931:WROY:12-Dec-2017:ED2K909813
*       Begin of DEL:ERP-7273:WROY:03-Apr-2018:ED2K911774
*       DATA(lv_bill_date) = fpla-bedat.              "Start date for billing plan/invoice plan
*       End   of DEL:ERP-7273:WROY:03-Apr-2018:ED2K911774
*       Begin of ADD:ERP-7273:WROY:03-Apr-2018:ED2K911774
        DATA(lv_bill_date) = vbkd-fkdat.              "Billing date for billing index and printout
*       End   of ADD:ERP-7273:WROY:03-Apr-2018:ED2K911774
*       End   of ADD:ERP-4931:WROY:12-Dec-2017:ED2K909813
        LOOP AT xfplt INTO lst_temp WHERE fplnr = lv_fplnr.
          lv_index = sy-tabix.
*         Begin of ADD:ERP-5249:WROY:12-Dec-2017:ED2K909813
          IF lst_temp-updkz IS INITIAL.
            APPEND lst_temp TO yfplt.
            lst_temp-updkz = 'U'.
          ENDIF.
*         End   of ADD:ERP-5249:WROY:12-Dec-2017:ED2K909813
*         Begin of DEL:ERP-4931:WROY:12-Dec-2017:ED2K909813
*         lst_temp-fkdat = sy-datum.
*         lst_temp-afdat = sy-datum.
*         End   of DEL:ERP-4931:WROY:12-Dec-2017:ED2K909813
*         Begin of ADD:ERP-4931:WROY:12-Dec-2017:ED2K909813
          lst_temp-fkdat = lv_bill_date.
          lst_temp-afdat = lv_bill_date.
*         End   of ADD:ERP-4931:WROY:12-Dec-2017:ED2K909813
          MODIFY xfplt FROM lst_temp INDEX lv_index.
          CLEAR lst_temp.
        ENDLOOP.
      ENDIF. " IF tkomk-vkbur IN lr_sofc_n_eal
    ENDIF. " IF tkomk-vkbur IN lr_sofc_eal
*End of Add-Anirban-10.16.2017-ED2K909014-Defect 4822

*Begin of Del-Anirban-10.16.2017-ED2K909014-Defect 4822
*  ENDIF.
*ENDIF. "IF NOT lv_fplnr is initial.
*End of Del-Anirban-10.16.2017-ED2K909014-Defect 4822

*Begin of Add-Anirban-10.16.2017-ED2K909014-Defect 4822
  ELSE. " ELSE -> IF NOT lv_fplnr IS INITIAL
    IF tkomk-vkbur IN lr_sofc_n_eal.
*     Begin of ADD:ERP-4931:WROY:12-Dec-2017:ED2K909813
*     Begin of DEL:ERP-7273:WROY:03-Apr-2018:ED2K911774
*     lv_bill_date = fpla-bedat.              "Start date for billing plan/invoice plan
*     End   of DEL:ERP-7273:WROY:03-Apr-2018:ED2K911774
*     Begin of ADD:ERP-7273:WROY:03-Apr-2018:ED2K911774
      lv_bill_date = vbkd-fkdat.              "Billing date for billing index and printout
*     End   of ADD:ERP-7273:WROY:03-Apr-2018:ED2K911774
*     End   of ADD:ERP-4931:WROY:12-Dec-2017:ED2K909813
      LOOP AT xfplt INTO lst_temp WHERE fplnr = lv_fplnr.
        lv_index = sy-tabix.
*       Begin of ADD:ERP-5249:WROY:12-Dec-2017:ED2K909813
        IF lst_temp-updkz IS INITIAL.
          APPEND lst_temp TO yfplt.
          lst_temp-updkz = 'U'.
        ENDIF.
*       End   of ADD:ERP-5249:WROY:12-Dec-2017:ED2K909813
*       Begin of DEL:ERP-4931:WROY:12-Dec-2017:ED2K909813
*       lst_temp-fkdat = sy-datum.
*       lst_temp-afdat = sy-datum.
*       End   of DEL:ERP-4931:WROY:12-Dec-2017:ED2K909813
*       Begin of ADD:ERP-4931:WROY:12-Dec-2017:ED2K909813
        lst_temp-fkdat = lv_bill_date.
        lst_temp-afdat = lv_bill_date.
*       End   of ADD:ERP-4931:WROY:12-Dec-2017:ED2K909813
        MODIFY xfplt FROM lst_temp INDEX lv_index.
        CLEAR lst_temp.
      ENDLOOP.
    ENDIF. " IF tkomk-vkbur IN lr_sofc_n_eal
  ENDIF. " IF NOT lv_fplnr IS INITIAL
*Begin of ADD:ERP-7250:WROY:28-Mar-2018:ED2K911639
ELSEIF ( *vbkd       IS NOT INITIAL AND           " ELSE -> IF t180-trtyp EQ 'H' OR
         *vbkd-fkdat NE vbkd-fkdat ).             " Billing Date is changed

  READ TABLE xfpla TRANSPORTING NO FIELDS
               WITH KEY fplnr = lv_fplnr
               BINARY SEARCH.
  IF sy-subrc EQ 0.
    lv_tabix_fpla = sy-tabix.
    LOOP AT xfpla ASSIGNING <lst_xfpla> FROM lv_tabix_fpla.
      IF <lst_xfpla>-fplnr NE lv_fplnr.
        EXIT.
      ENDIF.
      IF <lst_xfpla>-updkz IS INITIAL.
        lst_xfpla = <lst_xfpla>.
        APPEND lst_xfpla TO yfpla.
        CLEAR: lst_xfpla.

        <lst_xfpla>-updkz = 'U'.
      ENDIF.
      <lst_xfpla>-bedat = vbkd-fkdat.                                "Start date for billing plan/invoice plan
    ENDLOOP.
  ENDIF.

  READ TABLE xfplt TRANSPORTING NO FIELDS
       WITH KEY fplnr = lv_fplnr
       BINARY SEARCH.
  IF sy-subrc EQ 0.
    lv_tabix_fplt = sy-tabix.
    LOOP AT xfplt ASSIGNING FIELD-SYMBOL(<lst_xfplt>) FROM lv_tabix_fplt.
      IF <lst_xfplt>-fplnr NE lv_fplnr.
        EXIT.
      ENDIF.
      IF NOT ( <lst_xfplt>-fareg EQ '4' OR <lst_xfplt>-fareg EQ '5' ).   "Rule in billing plan/invoice plan (Down Payment)
        IF <lst_xfplt>-updkz IS INITIAL.
          lst_xfplt = <lst_xfplt>.
          APPEND lst_xfplt TO yfplt.
          CLEAR: lst_xfplt.

          <lst_xfplt>-updkz = 'U'.
        ENDIF.
        <lst_xfplt>-afdat = vbkd-fkdat.                                "Billing date for billing index and printout
        <lst_xfplt>-fkdat = vbkd-fkdat.                                "Settlement date for deadline
      ENDIF.
    ENDLOOP.
  ENDIF.
*End   of ADD:ERP-7250:WROY:28-Mar-2018:ED2K911639
ENDIF. " IF t180-trtyp EQ 'H' OR
*End of Add-Anirban-10.16.2017-ED2K909014-Defect 4822


*** Begin of: CR#6122 KKR20180820  ED2K913123
*** If Billing date of Billing Doc. passes from IDOC, Update the Start date (FPLA-BEDAT)
*** and Billing Date (FPLT-AFDAT) for ZF2 available under Billing Plan tab at Item level
IF t180-trtyp EQ 'H' AND
   rv45a-docnum IS NOT INITIAL.

  CONCATENATE rv45a-docnum '_BILL_DATE' INTO lv_mem_name.
  IMPORT lv_fkdat2_230 FROM MEMORY ID lv_mem_name.

  " If IDoc passes Billing date.. then pass it to
  " Start Date (FPLA-BEDAT) and Billing Date (FPLT-AFDAT) of ZF2
  " available under Billing Plan tab
  IF lv_fkdat2_230 IS NOT INITIAL.

*   Updating Start date
    READ TABLE xfpla TRANSPORTING NO FIELDS
                     WITH KEY fplnr = lv_fplnr
                     BINARY SEARCH.
    IF sy-subrc EQ 0.
      DATA(liv_tabix_fpla) = sy-tabix.
      LOOP AT xfpla ASSIGNING FIELD-SYMBOL(<lis_xfpla>) FROM liv_tabix_fpla.
        IF <lis_xfpla>-fplnr NE lv_fplnr.
          EXIT.
        ENDIF.

        <lis_xfpla>-bedat = lv_fkdat2_230.  " Update Start date
      ENDLOOP.
    ENDIF. " IF sy-subrc EQ 0

*** Delete FAZ entries from xfplt[] if any
    READ TABLE xfplt TRANSPORTING NO FIELDS WITH KEY fkarv = lc_faz.
    IF sy-subrc = 0.
      DELETE xfplt WHERE fkarv = lc_faz.
    ENDIF.

*   Updating Billing Date of ZF2
    READ TABLE xfplt TRANSPORTING NO FIELDS
                     WITH KEY fplnr = lv_fplnr
                     BINARY SEARCH.
    IF sy-subrc EQ 0.
      DATA(liv_tabix_fplt) = sy-tabix.
      LOOP AT xfplt ASSIGNING FIELD-SYMBOL(<lis_xfplt>) FROM liv_tabix_fplt.
        IF <lis_xfplt>-fplnr NE lv_fplnr.
          EXIT.
        ENDIF.
        IF <lis_xfplt>-fkarv NE lc_zf2.
          CONTINUE.
        ENDIF.
        IF NOT ( <lis_xfplt>-fareg EQ '4' OR <lis_xfplt>-fareg EQ '5' ).
          <lis_xfplt>-afdat = lv_fkdat2_230.   " " Update Billing Date of ZF2
        ENDIF.
      ENDLOOP.
    ENDIF. " IF sy-subrc EQ 0

  ELSE.
    " Since IDoc didn't pass.. let system determine the date
  ENDIF. " IF lv_fkdat2_230 IS NOT INITIAL

ENDIF. " IF t180-trtyp EQ 'H' AND
*** End of: CR#6122 KKR20180820  ED2K913123

* Begin by AMOHAMMED on 08-10-2020 TR# ED2K919114
* Scenario 1: ZSUB -> ZREW
*    a. When ZSUB document is created there will be no reference document, then VBAK select st. fails and no error message.
*    b. When ZREW document is created with reference to ZSUB, then after VBAK select st. fetch record from ZQTC_RENWL_PLAN table,
*       if record not found throw error message
* Scenario 2: ZSUB -> ZSQT -> ZREW
*    a. When ZSUB document is created there will be no reference document, then VBAK select st. fails and no error message.
*    b. When ZSQT document is created with reference to ZSUB, then after VBAK select st. fetch record from ZQTC_RENWL_PLAN table,
*       if record not found no error message as lv_error_flag is false
*    c. When ZREW document is created with reference to ZSQT, then VBAK select st. fails and no error message.
* Scenario 3: ZREW -> ZREW
*    a. When ZREW document is created with reference to ZREW, then after VBAK select st. fetch record from ZQTC_RENWL_PLAN table,
*       if record not found throw error message
* Scenario 4: ZREW -> ZSQT -> ZREW
*    a. When ZSQT document is created with reference to ZREW, then after VBAK select st. fetch record from ZQTC_RENWL_PLAN table,
*       if record not found no error message as lv_error_flag is false
*    b. When ZREW document is created with reference to ZSQT, then VBAK select st. fails and no error message.

IF t180-trtyp = lc_create. " Create Mode
  SELECT SINGLE *
    FROM vbak
    INTO ls_doc_typ
    WHERE vbeln EQ vbak-vgbel
      AND ( auart EQ lc_zsub OR
            auart EQ lc_zrew ).
  IF sy-subrc EQ 0.
* Fetch the activity date
    SELECT SINGLE *
      FROM zqtc_renwl_plan
      INTO ls_zqtc_renwl_plan
      WHERE vbeln EQ vbak-vgbel
        AND activity EQ lc_cs
        AND act_status EQ space
        AND ren_status EQ space.
    IF sy-subrc EQ 0.
      " Do nothing
    ELSE.
      " When SAVE button or YES button is pressed
      IF ( sy-ucomm EQ lc_save OR
           sy-ucomm EQ lc_yes ) AND
         lv_error_flag EQ abap_true.
        MESSAGE 'No record in Renewal Plan table'(038) TYPE lc_e.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
* End by AMOHAMMED on 08-10-2020 TR# ED2K919114

* Begin of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
IF vbak-auart IN lr_auart AND vbak-bukrs_vf IN lr_bukrs AND vbkd-zlsch IN lr_zlsch
    AND vbak-bsark IN lr_bsark.
*--*Check if there is a change in Payment method or entered new item
  IF vbkd-zlsch NE *vbkd-zlsch OR vbkd-posnr NE *vbkd-posnr." IS NOT INITIAL.
*--*Get Future billing date
* Begin by AMOHAMMED on 08-10-2020 TR# ED2K919114
    " Read XVEDA[]
    lv_error_flag = abap_true.
    ASSIGN (lc_xveda) TO <lfs_xveda>.
    IF <lfs_xveda> IS ASSIGNED.
      " Get values of table XVEDA
      li_xveda[] = <lfs_xveda>.
      SORT li_xveda BY vbeln vposn.
      " Check the Action field value in the header record only
      READ TABLE li_xveda ASSIGNING FIELD-SYMBOL(<lst_xveda>)
        WITH KEY vposn = lc_header.
      IF sy-subrc EQ 0.
        " When Action field is equal to 0001, consider activity date
        IF <lst_xveda>-vaktsch EQ lc_vaktsch.
          "++ Begin of Changes By Krishna On_04062021
*& Get data from constant table
          IF li_constant[] IS INITIAL.
            CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
              EXPORTING
                im_devid     = lc_devid_e112
              IMPORTING
                ex_constants = li_constant.
            LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<ls_constant>).
              CASE <ls_constant>-param1.
*            -  Contract Type
                WHEN lc_prog.
                  lst_output-sign = <ls_constant>-sign.
                  lst_output-option = <ls_constant>-opti.
                  lst_output-low = <ls_constant>-low.
                  APPEND lst_output TO r_constant.
                WHEN OTHERS.
              ENDCASE.
              CLEAR lst_output.
            ENDLOOP.
         ENDIF.
          lv_prog1 = sy-cprog.
          set = strlen( lv_prog1 ).
          lv_cust = lv_prog1+0(set).
          lv_prog2 = lv_prog1+6(set).
          CONCATENATE 'Z' lv_prog2
                 INTO lv_prog2.
*      "++ End of Changes By Krishna On_04062021
          IF t180-trtyp = lc_create. " Create Mode
            IF ls_zqtc_renwl_plan-eadat IS NOT INITIAL.
       "++ Begin of Changes By Krishna On_04062021
              IF lv_prog2 IN r_constant.
                CALL FUNCTION 'ZQTC_BILLING_DATE_E164'
                  EXPORTING
                    im_date      = vbak-erdat         " ls_zqtc_renwl_plan-eadat
                    im_days      = lv_debit_days
                  IMPORTING
                    ex_bill_date = lv_bill_date_debit.
              ELSE.
                CALL FUNCTION 'ZQTC_BILLING_DATE_E164'
                  EXPORTING
                    im_date      = ls_zqtc_renwl_plan-eadat
                    im_days      = lv_debit_days
                  IMPORTING
                    ex_bill_date = lv_bill_date_debit.
              ENDIF.
       "++ End of Changes By Krishna On_04062021
            ENDIF.
          ENDIF.

        ELSE.
          " When Action field is not equ 0001, consider system date
          CALL FUNCTION 'ZQTC_BILLING_DATE_E164'
            EXPORTING
              im_date      = sy-datum
              im_days      = lv_debit_days
            IMPORTING
              ex_bill_date = lv_bill_date_debit.
        ENDIF.
      ENDIF. " IF sy-subrc EQ 0.
    ENDIF. " IF <lfs_xveda> IS ASSIGNED.
* End by AMOHAMMED on 08-10-2020 TR# ED2K919114

*--*Modify FPLA with new billing date
    IF lv_bill_date_debit NE '00000000'.
**--Modify Billing plan tables all items with new date
      LOOP AT xfpla ASSIGNING FIELD-SYMBOL(<lis_xfpla_debit>).
        IF <lis_xfpla_debit>-bedat NE lv_bill_date_debit.
          <lis_xfpla_debit>-bedat = lv_bill_date_debit.
          IF <lis_xfpla_debit>-updkz IS INITIAL.
            <lis_xfpla_debit>-updkz = 'U'.
          ENDIF.
          CLEAR : <lis_xfpla_debit>-bedar.
        ENDIF.
      ENDLOOP.
      LOOP AT xfplt ASSIGNING FIELD-SYMBOL(<lis_xfplt_debit>).
        IF <lis_xfplt_debit>-fkdat NE lv_bill_date_debit.
          <lis_xfplt_debit>-afdat = lv_bill_date_debit.
          <lis_xfplt_debit>-fkdat = lv_bill_date_debit.
          IF <lis_xfplt_debit>-updkz IS INITIAL.
            <lis_xfplt_debit>-updkz = 'U'.
          ENDIF.
        ENDIF.
      ENDLOOP.
* BOC - BTIRUVATHU - INC0268352 - 2019/08/11 - ED1K911304
      LOOP AT xvbkd ASSIGNING FIELD-SYMBOL(<lis_xvbkd_debit>).
        IF <lis_xvbkd_debit>-fkdat NE lv_bill_date_debit.
          <lis_xvbkd_debit>-fkdat = lv_bill_date_debit.
          IF <lis_xvbkd_debit>-updkz IS INITIAL.
            <lis_xvbkd_debit>-updkz = 'U'.
          ENDIF.
        ENDIF.
      ENDLOOP.
* EOC - BTIRUVATHU - INC0268352 - 2019/08/11 - ED1K911304
    ENDIF.
  ENDIF.
* Begin by AMOHAMMED on 08-10-2020 TR# ED2K919114
ELSEIF vbak-auart IN lr_auart AND vbak-bukrs_vf IN lr_bukrs AND vbkd-zlsch NOT IN lr_zlsch
  AND vbak-bsark IN lr_bsark.
  IF t180-trtyp = lc_create. " Create Mode
*--*Check if there is a change in Payment method or entered new item
    IF vbkd-zlsch NE *vbkd-zlsch OR vbkd-posnr NE *vbkd-posnr." IS NOT INITIAL.
*--*Get Future billing date
      lv_error_flag = abap_true.
      " Read XVEDA[]
      ASSIGN (lc_xveda) TO <lfs_xveda>.
      IF <lfs_xveda> IS ASSIGNED.
        " Get values of table XVEDA
        li_xveda[] = <lfs_xveda>.
        SORT li_xveda BY vbeln vposn.
        " Check the Action field value in the header record only
        READ TABLE li_xveda ASSIGNING <lst_xveda>
          WITH KEY vposn = lc_header.
        IF sy-subrc EQ 0 AND <lst_xveda>-vaktsch EQ lc_vaktsch.
          " When action field is equal to 0001, Activity date is billing date
          IF ls_zqtc_renwl_plan-eadat IS NOT INITIAL.
            lv_bill_date_debit = ls_zqtc_renwl_plan-eadat.
          ENDIF.
        ENDIF. " IF sy-subrc EQ 0 AND <lst_xveda>-vaktsch EQ lc_vaktsch.
      ENDIF. " IF <lfs_xveda> IS ASSIGNED.
*--*Modify FPLA with new billing date
      IF lv_bill_date_debit NE '00000000'.
**--Modify Billing plan tables all items with new date
        LOOP AT xfpla ASSIGNING <lis_xfpla_debit>.
          IF <lis_xfpla_debit>-bedat NE lv_bill_date_debit.
            <lis_xfpla_debit>-bedat = lv_bill_date_debit.
            IF <lis_xfpla_debit>-updkz IS INITIAL.
              <lis_xfpla_debit>-updkz = 'U'.
            ENDIF.
            CLEAR : <lis_xfpla_debit>-bedar.
          ENDIF.
        ENDLOOP.
        LOOP AT xfplt ASSIGNING <lis_xfplt_debit>.
          IF <lis_xfplt_debit>-fkdat NE lv_bill_date_debit.
            <lis_xfplt_debit>-afdat = lv_bill_date_debit.
            <lis_xfplt_debit>-fkdat = lv_bill_date_debit.
            IF <lis_xfplt_debit>-updkz IS INITIAL.
              <lis_xfplt_debit>-updkz = 'U'.
            ENDIF.
          ENDIF.
        ENDLOOP.
        LOOP AT xvbkd ASSIGNING <lis_xvbkd_debit>.
          IF <lis_xvbkd_debit>-fkdat NE lv_bill_date_debit.
            <lis_xvbkd_debit>-fkdat = lv_bill_date_debit.
            IF <lis_xvbkd_debit>-updkz IS INITIAL.
              <lis_xvbkd_debit>-updkz = 'U'.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF. " IF lv_bill_date_debit NE '00000000'.
    ENDIF. " IF vbkd-zlsch NE *vbkd-zlsch OR vbkd-posnr NE *vbkd-posnr.
  ENDIF.
* End by AMOHAMMED on 08-10-2020 TR# ED2K919114
ENDIF.
* End of ADD:ERP-7873:PRABHU:18-FEB-2019:ED2K914491
* Begin by AMOHAMMED on 08-10-2020 TR# ED2K919114
FREE : ls_zqtc_renwl_plan, li_xveda.
* End by AMOHAMMED on 08-10-2020 TR# ED2K919114
