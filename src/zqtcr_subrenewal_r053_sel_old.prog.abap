*&---------------------------------------------------------------------*
*&  Include           ZQTCR_SUBRENEWAL_R053_SEL
*&---------------------------------------------------------------------*
*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_SUBRENEWAL_R053_sel
* PROGRAM DESCRIPTION: Renewals Subscription
* DEVELOPER: Mounika Nallapaneni
* CREATION DATE:   2017-06-02
* OBJECT ID: R053
* TRANSPORT NUMBER(S): ED2K906467
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K908710
* REFERENCE NO:  ERP 4700
* DEVELOPER: Anirban Saha
* DATE:  2017-09-28
* DESCRIPTION: Taking out the communication method field from report
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K909489
* REFERENCE NO:  ERP-5530
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-12-14
* DESCRIPTION: To improve the performance of the program and as part
*              of this made the dates as mandatory parameters.
*-------------------------------------------------------------------
* REVISION NO: ED2K913224, ED2K913417
* REFERENCE NO:  ERP-6311
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-08-28
* DESCRIPTION: Added new fields in Selection Screen and Report O/P
*-------------------------------------------------------------------
* REVISION NO: ED2K913419
* REFERENCE NO:  ERP-7727
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-09-21
* DESCRIPTION: Added new fields in Selection Screen and Report O/P
*-------------------------------------------------------------------
* REVISION NO:   ED2K915473
* REFERENCE NO:  DM-1995
* DEVELOPER:     Abdul Khadir (AKHADIR)
* DATE:          2019-06-26
* DESCRIPTION:   Added new field AUGRU-Order Reason in
*                Selection Screen and Report O/P
* Imp Notes:     The is a change done to the CDS view
*                ZQTC_SALES_001 and captured in Transport
*                ED2K915477 which need to be moved simultaneously
*-------------------------------------------------------------------
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------

TABLES: tsac, vbap, vbak, vbpa, vbkd.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.

SELECT-OPTIONS: s_saldoc FOR v_salesdocu,
                s_doctyp FOR v_doctyp NO INTERVALS OBLIGATORY,
                s_kunnr  FOR v_kunnr,
*               Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
                s_land1  FOR v_land1, " Sold-To Party's Country
                s_waerk  FOR v_waerk, " SD Document Currency / Payment Currency
                s_ihrez  FOR v_ihrez, " Your Reference
                s_konda  FOR v_konda, " Price group (customer)
                s_betdt  FOR v_betdt, " Payment Date
*               End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
*               Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
                s_shpto  FOR v_kunnr,    " Ship-To Party
                s_kdkg2  FOR vbkd-kdkg2, " Customer condition group 2
                s_mvgr5  FOR vbap-mvgr5, " Material group 5
*               End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
                s_matnum FOR v_matnum,
                s_ponum  FOR v_ponum,
                s_bsark  FOR vbkd-bsark NO INTERVALS, " Customer purchase order type
                s_vkorg  FOR v_vkorg NO INTERVALS OBLIGATORY,
                s_vkbur  FOR v_vkbur  NO INTERVALS,
*Begin of Del-Anirban-09.28.2017-ED2K908710-Defect 4700
*                s_comm   FOR tsac-comm_type NO INTERVALS,
*End of Del-Anirban-09.28.2017-ED2K908710-Defect 4700
*Begin of Add-Anirban-09.28.2017-ED2K908710-Defect 4700
                s_comm   FOR tsac-comm_type NO INTERVALS NO-DISPLAY, " Communication Method (Key) (Business Address Services)
*End of Add-Anirban-09.28.2017-ED2K908710-Defect 4700
                s_subs   FOR vbap-zzsubtyp  NO INTERVALS, " Subscription Type
                s_lifsk  FOR vbak-lifsk NO INTERVALS,     " Delivery block (document header)
                s_faksk  FOR vbak-faksk NO INTERVALS,     " Billing block in SD document
* BOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473
                s_augru  FOR vbak-augru NO INTERVALS.     " Order reason (reason for the business transaction)
* EOI by AKHADIR on 26-Jun-2019 for DM-1995 TR-ED2K915473
SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF LINE .
SELECTION-SCREEN COMMENT 1(31) text-t02 FOR FIELD p_cstaf.
* BOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*PARAMETERS : p_cstaf  TYPE vbdat_veda .
PARAMETERS : p_cstaf  TYPE vbdat_veda OBLIGATORY. " Contract start date
* EOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
SELECTION-SCREEN COMMENT 52(5) text-t03 FOR FIELD p_cstat.
PARAMETERS : p_cstat  TYPE vbdat_veda. " Contract start date
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE .
SELECTION-SCREEN COMMENT 1(31) text-t04 FOR FIELD p_cendf.
* BOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
*PARAMETERS : p_cendf  TYPE vbdat_veda.
PARAMETERS : p_cendf  TYPE vbdat_veda OBLIGATORY. " Contract start date
* EOC by PBANDLAPAL on 14-Dec-2017 for ERP-5530: ED2K909489
SELECTION-SCREEN COMMENT 52(5) text-t03 FOR FIELD p_cendt.
PARAMETERS : p_cendt  TYPE vbdat_veda. " Contract start date
SELECTION-SCREEN END OF LINE.
* Begin of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
PARAMETERS: cb_unqol TYPE char1 AS CHECKBOX. " Unqol of type CHAR1
* End   of ADD:ERP-6311:WROY:28-AUG-2018:ED2K913224
* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
PARAMETERS: cb_nocmp TYPE char1 AS CHECKBOX. " Do not Display BOM Components
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02.
*PARAMETERS :      cb_parfn AS CHECKBOX.
PARAMETERS :      p_parvw  TYPE vbpa-parvw. " Partner Function
SELECT-OPTIONS:   s_partne FOR v_partne.
SELECTION-SCREEN END OF BLOCK b2.

* Begin of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s04.
PARAMETERS : p_alv_vr TYPE slis_vari. " Layout
SELECTION-SCREEN END OF BLOCK b3.
* End   of ADD:ERP-7727:WROY:21-SEP-2018:ED2K913419
