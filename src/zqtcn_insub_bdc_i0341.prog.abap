*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INSUB_BDC_I0341 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Inbound Interface for Agent Subscription Renewal
* DEVELOPER: SAYANDAS ( Sayantan Das )
* CREATION DATE:   14/02/2017
* OBJECT ID: I0341
* TRANSPORT NUMBER(S):   ED2K904485
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912446
* REFERENCE NO: ERP-6801
* DEVELOPER: Writtick Roy (WROY)
* DATE:  28-June-2018
* DESCRIPTION: Populate Sales Area from IDOC instead of getting the
*              values from the Reference Document (Quote)
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K913538
* REFERENCE NO: ERP-7766
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE:  08-October-2018
* DESCRIPTION: Populate the Customer Purchase Order number from IDOC
* (Segment: E1EDK02, Qualifier: 001) instead of getting the value from
* the Reference Document (Quote)
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K916622
* REFERENCE NO:  ERPM1431
* DEVELOPER:     NPOLINA(Nageswara)
* DATE:          29-Oct-2019
* DESCRIPTION:Reference quotation identification logic added
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED1K911549
* REFERENCE NO:  ERPM1431
* DEVELOPER:     NPOLINA(Nageswara)
* DATE:          17-Jan-2020
* DESCRIPTION:   Clearing static variables
*------------------------------------------------------------------- *
**---------------------------------------------------------------------*
* REVISION NO   : ED2K926646
* REFERENCE NO  : OTCM-54391
* DEVELOPER     : VDPATABALL
* DATE          : 04/07/2022
* DESCRIPTION   : For FTP Orders, if Media change, then also coping the Freight
*                 forwarder based on Sold to paty Ref number
*-----------------------------------------------------------------------*
*** Local types declaration for XVBAK
TYPES: BEGIN OF lty_xvbak9. "Kopfdaten
         INCLUDE STRUCTURE vbak. " Sales Document: Header Data
         TYPES:  bstkd LIKE vbkd-bstkd. " Customer purchase order number

TYPES:  kursk LIKE vbkd-kursk. "Währungskurs
TYPES:  zterm LIKE vbkd-zterm. "Zahlungsbedingungsschlüssel
TYPES:  incov LIKE vbkd-incov. "Incoterms Teil Version
TYPES:  inco1 LIKE vbkd-inco1. "Incoterms Teil 1
TYPES:  inco2 LIKE vbkd-inco2. "Incoterms Teil 2
TYPES:  inco2_l LIKE vbkd-inco2_l. "Incoterms Teil 2_L
TYPES:  inco3_l LIKE vbkd-inco3_l. "Incoterms Teil 3_L
TYPES:  prsdt LIKE vbkd-prsdt. "Datum für Preisfindung
TYPES:  angbt LIKE vbak-vbeln. "Angebotsnummer Lieferant (SAP)
TYPES:  contk LIKE vbak-vbeln. "Kontraknummer Lieferant (SAP)
TYPES:  kzazu LIKE vbkd-kzazu. "Kz. Auftragszusammenführung
TYPES:  fkdat LIKE vbkd-fkdat. "Datum Faktura-/Rechnungsindex
TYPES:  fbuda LIKE vbkd-fbuda. "Datum der Leistungserstellung
TYPES:  empst LIKE vbkd-empst. "Empfangsstelle
TYPES:  valdt LIKE vbkd-valdt. "Valuta-Fix Datum
TYPES:  kdkg1 LIKE vbkd-kdkg1. "Kunden Konditionsgruppe 1
TYPES:  kdkg2 LIKE vbkd-kdkg2. "Kunden Konditionsgruppe 2
TYPES:  kdkg3 LIKE vbkd-kdkg3. "Kunden Konditionsgruppe 3
TYPES:  kdkg4 LIKE vbkd-kdkg4. "Kunden Konditionsgruppe 4
TYPES:  kdkg5 LIKE vbkd-kdkg5. "Kunden Konditionsgruppe 5
TYPES:  delco LIKE vbkd-delco. "vereinbarte Lieferzeit
TYPES:  abtnr LIKE vbkd-abtnr. "Abteilungsnummmer
TYPES:  dwerk LIKE rv45a-dwerk. "disponierendes Werk
TYPES:  angbt_ref LIKE vbkd-bstkd. "Angebotsnummer Kunde (SAP)
TYPES:  contk_ref LIKE vbkd-bstkd. "Kontraknummer Kunde  (SAP)
TYPES:  currdec LIKE tcurx-currdec. "Dezimalstellen Währung
TYPES:  bstkd_e LIKE vbkd-bstkd_e. "Bestellnummer Warenempfänger
TYPES:  bstdk_e LIKE vbkd-bstdk_e. "Bestelldatum Warenempfänger
TYPES: END OF lty_xvbak9.

*****
"Changed OCCURS 50 to OCCURS 0
TYPES: BEGIN OF lty_xvbap9. "Position
         INCLUDE STRUCTURE vbap. " Sales Document: Item Data
         TYPES:  matnr_output(40) TYPE c. " Output(40) of type Character
TYPES:  wmeng(18) TYPE c. " Types: wmeng(18) of type Character
TYPES:  lfdat LIKE vbap-abdat. " Reconciliation Date for Agreed Cumulative Quantity
TYPES:  kschl LIKE komv-kschl. " Condition type
TYPES:  kbtrg(16) TYPE c. " Types: kbtrg(16) of type Character
TYPES:  kschl_netwr LIKE komv-kschl. " Condition type
TYPES:  kbtrg_netwr(16) TYPE c. " Netwr(16) of type Character
TYPES:  inco1 LIKE vbkd-inco1. "Incoterms 1
TYPES:  inco2 LIKE vbkd-inco2. "Incoterms 2
TYPES:  inco2_l LIKE vbkd-inco2_l. "Incoterms 2_L
TYPES:  inco3_l LIKE vbkd-inco3_l. "Incoterms 3_L
TYPES:  incov LIKE vbkd-incov. "Incoterms v
TYPES:  yantlf(1) TYPE c. " Types: yantlf(1) of type Character
TYPES:  prsdt LIKE vbkd-prsdt. " Date for pricing and exchange rate
TYPES:  hprsfd LIKE tvap-prsfd. " Carry out pricing
TYPES:  bstkd_e LIKE vbkd-bstkd_e. " Ship-to Party's Purchase Order Number
TYPES:  bstdk_e LIKE vbkd-bstdk_e. " Ship-to party's PO date
TYPES:  bsark_e LIKE vbkd-bsark_e. " Ship-to party purchase order type
TYPES:  ihrez_e LIKE vbkd-ihrez_e. " Ship-to party character
TYPES:  posex_e LIKE vbkd-posex_e. " Item Number of the Underlying Purchase Order
TYPES:  lpnnr LIKE vbak-vbeln. " Sales Document
TYPES:  empst LIKE vbkd-empst. " Receiving point
TYPES:  ablad LIKE vbpa-ablad. " Unloading Point
TYPES:  knref LIKE vbpa-knref. " Customer description of partner (plant, storage location)
TYPES:  lpnnr_posnr LIKE vbap-posnr. " Sales Document Item
TYPES:  kdkg1 LIKE vbkd-kdkg1. " Customer condition group 1
TYPES:  kdkg2 LIKE vbkd-kdkg2. " Customer condition group 2
TYPES:  kdkg3 LIKE vbkd-kdkg3. " Customer condition group 3
TYPES:  kdkg4 LIKE vbkd-kdkg4. " Customer condition group 4
TYPES:  kdkg5 LIKE vbkd-kdkg5. " Customer condition group 5
TYPES:  abtnr LIKE vbkd-abtnr. " Department number
TYPES:  delco LIKE vbkd-delco. " Agreed delivery time
TYPES:  angbt LIKE vbak-vbeln. " Sales Document
TYPES:  angbt_posnr LIKE vbap-posnr. " Sales Document Item
TYPES:  contk LIKE vbak-vbeln. " Sales Document
TYPES:  contk_posnr LIKE vbap-posnr. " Sales Document Item
TYPES:  angbt_ref LIKE vbkd-bstkd. " Customer purchase order number
TYPES:  angbt_posex LIKE vbap-posex. " Item Number of the Underlying Purchase Order
TYPES:  contk_ref LIKE vbkd-bstkd. " Customer purchase order number
TYPES:  contk_posex LIKE vbap-posex. " Item Number of the Underlying Purchase Order

*- positionen ---------------------------------------------------------*
*- external config-id to set fcode 'POUP' on sub-item level ----*
TYPES:  config_id LIKE e1curef-config_id. " External Configuration ID (Temporary)
*- Instanznummer der Konfiguaration zum Setzen des FCODES 'POUP' bei --*
*- Unterpositionen ----------------------------------------------------*
*- instancenumber of the configuration to set fcode 'POUP' on sub-item *
*- level --------------------------------------------------------------*
TYPES:  inst_id LIKE e1curef-inst_id. " Instance Number in Configuration
TYPES:  kompp LIKE tvap-kompp. " Form delivery group and correlate BOM components
TYPES:  currdec LIKE tcurx-currdec. " Number of decimal places
TYPES:  curcy LIKE e1edp01-curcy. " Currency
TYPES:  valdt LIKE vbkd-valdt. " Fixed value date
TYPES:  valtg LIKE vbkd-valtg. " Additional value days
*- Flag  -------------------------------------------*
*- internal field additional ------------------------------------------*
TYPES:  vaddi(1) TYPE c. " Types: vaddi(1) of type Character
*- ARM Advanced Returns -----------------------------------------------*
TYPES: returns_reason     TYPE bezei40, " Description
       replace_request(1) TYPE c.       " Request(1) of type Character
TYPES: END OF lty_xvbap9.
*****

TYPES: BEGIN OF lty_item9,
         posex   TYPE posex,      " Item Number of the Underlying Purchase Order
         vbegdat TYPE vbdat_veda, " Contract start date
         venddat TYPE vndat_veda, " Contract end date
         traty   TYPE traty,      " Means-of-Transport Type
       END OF lty_item9.

***BOC by SAYANDAS for ERP-3450 on 26th July 2017
TYPES: BEGIN OF lty_p05,
         posex TYPE posex,     " Item Number of the Underlying Purchase Order
         kschl TYPE edi5189_a, " Condition type (coded)
         betrg TYPE edi5004_p, " Fixed surcharge/discount on total gross
       END OF lty_p05.
***EOC by SAYANDAS for ERP-3450 on 26th July 2017

*** Local work area declaration
DATA: lst_bdcdata9   TYPE bdcdata,                   " Batch input: New table field structure
      lst_bdcdata10  TYPE bdcdata,                   " Batch input: New table field structure
      lst_bdcdata_31 TYPE bdcdata,                   " Batch input: New table field structure
      lst_bdcdata11  TYPE bdcdata,                   " Batch input: New table field structure
      lst_idoc9      TYPE edidd,                     " Data record (IDoc)
      lst_xvbak9     TYPE lty_xvbak9,
      lst_vbap9      TYPE lty_xvbap9,
      lst_vbap10     TYPE lty_xvbap9,
      li_e1edp01_9   TYPE STANDARD TABLE OF e1edp01, " IDoc: Document Item General Data
      li_vbap9       TYPE STANDARD TABLE OF lty_xvbap9,
      lst_item9      TYPE lty_item9,
      lst_item91     TYPE lty_item9,
      li_item91      TYPE STANDARD TABLE OF lty_item9,
      li_di_doc1     TYPE STANDARD TABLE OF edidd,   " Data record (IDoc)
      lst_di_doc1    TYPE edidd,                     " Data record (IDoc)
*** change for quotation
      li_di_doc2     TYPE STANDARD TABLE OF edidd, " Data record (IDoc)
      lst_di_doc2    TYPE edidd,                   " Data record (IDoc)
*** change for quotation
      li_bdcdata41   TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
      li_item9       TYPE STANDARD TABLE OF lty_item9.

*** Local Data declaration
DATA: lv_line9               TYPE sytabix,          " Row Index of Internal Tables
      lst_e1edk03_9          TYPE e1edk03,          " IDoc: Document header date segment
      lst_z1qtc_e1edp01_01_9 TYPE z1qtc_e1edp01_01, " IDOC Segment for STATUS Field in Item Level
      lst_z1qtc_e1edk01_01_9 TYPE z1qtc_e1edk01_01, " Header General Data Entension
      lst_e1edk02_9          TYPE e1edk02,          " IDoc: Document header reference data
      lst_e1edp01_9          TYPE e1edp01,          " IDoc: Document Item General Data
***BOC by SAYANDAS for ERP-3450 on 26th July 2017
      lst_e1edp05_i0341      TYPE e1edp05,                   " IDoc: Document Item Conditions
      lst_e1edk01_i0341      TYPE e1edk01,                   " IDoc: Document header general data
      lv_curcy               TYPE edi6345_a,                 " Currency
      lv_kschl               TYPE edi5189_a,                 " Condition type (coded)
      lv_betrg               TYPE edi5004_p,                 " Fixed surcharge/discount on total gross
      lv_line_i0341          TYPE sytabix,                   " Row Index of Internal Tables
      lst_bdcdata_i0341      TYPE bdcdata,                   " Batch input: New table field structure
      lst_idoc_i0341         TYPE edidd,                     " Data record (IDoc)
      li_di_doc1_i0341       TYPE STANDARD TABLE OF edidd,   " Data record (IDoc)
      lst_di_doc1_i0341      TYPE edidd,                     " Data record (IDoc)
      lst_e1edp052_i0341     TYPE e1edp05,                   " IDoc: Document Item Conditions
      li_e1edp05_i0341       TYPE STANDARD TABLE OF e1edp05, " IDoc: Document Item Conditions
      lst_p05                TYPE lty_p05,
      li_p05                 TYPE STANDARD TABLE OF lty_p05,
      lv_psgnum_i0341        TYPE edi_psgnum,                " Number of the hierarchically higher SAP segment
      lst_idoc_p05_i0341     TYPE edidd,                     " Data record (IDoc)
      li_di_doc_p05          TYPE STANDARD TABLE OF edidd,   " Data record (IDoc)
      lst_e1edp01_i0341      TYPE e1edp01,                   " IDoc: Document Item General Data
*     Begin of ADD:ERP-6801:WROY:28-JUN-2018:ED2K912446
      lst_sales_area_i0341   TYPE erp_sales_area, " Sales Area Structure in ERP
      lv_mem_name_i0341      TYPE char30,         " Memory ID Name
*     End   of ADD:ERP-6801:WROY:28-JUN-2018:ED2K912446
*      lv_line_i0341          TYPE sytabix,   " Row Index of Internal Tables
***EOC by SAYANDAS for ERP-3450 on 26th July 2017
      lv_quotf1              TYPE char1,    " Quotf1 of type CHAR1
      lv_posex9              TYPE string,
      lv_1                   TYPE char1,    " 1 of type CHAR1
      lv_stdt9               TYPE char10,   " Stdt9 of type CHAR10
      lv_eddt9               TYPE char10,   " Eddt9 of type CHAR10
      lv_test9               TYPE sy-datum, " ABAP System Field: Current Date of Application Server
      lv_tabix1              TYPE syindex,  " Loop Index
      lv_tabix41             TYPE sytabix,  " Row Index of Internal Tables
      lv_tabixq1             TYPE sytabix,  " Row Index of Internal Tables
      lv_zmeng               TYPE char13,   " Zmeng of type CHAR13
      lv_kwmeng              TYPE char15,   " Kwmeng of type CHAR15
      lv_zuonr               TYPE ordnr_v,  " Assignment number
      lv_xblnr               TYPE xblnr_v1, " Reference Document Number
* BOC: CR#7766  KKRAVURI20181008  ED2K913538
      lv_bstkd               TYPE edi_belnr, " Customer Purchase Order
* EOC: CR#7766  KKRAVURI20181008  ED2K913538
      lv_posnr9              TYPE posnr_va, " Sales Document Item
      lv_pos                 TYPE char3,    " Pos of type CHAR3
      lv_val                 TYPE char6,    " Val of type CHAR6
      lv_selkz               TYPE char19,   " Selkz of type CHAR19
      lv_vbegdat             TYPE d,        " Vbegdat of type Date
      lv_venddat             TYPE d,        " Venddat of type Date
      lv_vbegdat1            TYPE dats,     " Field of type DATS
      lv_venddat1            TYPE dats,     " Field of type DATS
      lv_traty               TYPE traty,    " Means-of-Transport Type
      lv_traty1              TYPE traty,    " Means-of-Transport Type
      lv_date9               TYPE d,        " System Date
      lv_date91              TYPE dats,     " Field of type DATS
      lst_e1edp19_i0341      TYPE e1edp19,
      lst_e1edka1_i0341      TYPE e1edka1.
*** Local Field Symbols
FIELD-SYMBOLS: <lst_bdcdata_0341> TYPE bdcdata. " Batch input: New table field structure

*** local Constant declaration
CONSTANTS: lc_e1edk03_9          TYPE char7 VALUE 'E1EDK03', " E1edk03_9 of type CHAR7
           lc_e1edk02_9          TYPE char7 VALUE 'E1EDK02', " E1edk02_9 of type CHAR7
           lc_e1edp01_9          TYPE char7 VALUE 'E1EDP01', " E1edp01_9 of type CHAR7
***BOC by SAYANDAS for ERP-3450 on 26th July 2017
           lc_e1edp05_i0341      TYPE char7 VALUE 'E1EDP05', " E1edp05_i0341 of type CHAR7
           lc_e1edk01_i0341      TYPE char7 VALUE 'E1EDK01', " E1edk01_i0341 of type CHAR7
***EOC by SAYANDAS for ERP-3450 on 26th July 2017
           lc_z1qtc_e1edp01_01_9 TYPE char16 VALUE 'Z1QTC_E1EDP01_01', " Z1qtc_e1edp01_01_9 of type CHAR16
           lc_z1qtc_e1edk01_01_9 TYPE char16 VALUE 'Z1QTC_E1EDK01_01', " Z1qtc_e1edk01_01_9 of type CHAR16
           lc_004_9              TYPE edi_qualfr VALUE '004',          " IDOC qualifier reference document
           lc_011_9              TYPE edi_qualfr VALUE '011',          " IDOC qualifier reference document
           lc_022_9              TYPE edi_iddat  VALUE '022',          " Qualifier for IDOC date segment
           lc_019_9              TYPE edi_iddat  VALUE '019',          " Qualifier for IDOC date segment
           lc_020_9              TYPE edi_iddat  VALUE '020',          " Qualifier for IDOC date segment
* BOC: CR#7766  KKRAVURI20181008  ED2K913538
           lc_001_9              TYPE edi_iddat  VALUE '001'.          " Qualifier: Customer Purchase Order
* EOC: CR#7766  KKRAVURI20181008  ED2K913538

* Begin of ADD:ERP-6801:WROY:28-JUN-2018:ED2K912446
IF dlast_dynpro EQ dynpro-einstieg.                                    " Control is coming for the first time
  CLEAR: lst_sales_area_i0341.

* Check if the Document is being created with reference to a Renewal Quotation
  ASSIGN COMPONENT 'ANGBT' OF STRUCTURE dxvbak TO FIELD-SYMBOL(<lv_angbt>).
  IF sy-subrc   EQ 0 AND
     <lv_angbt> IS NOT INITIAL. " Renewal Quotation
*   Do not pass the Sales Area - Standard SAP logic validates these values
*   against the Reference Document and errors out if the values are not same

*   Sales Organization
    CLEAR: lst_bdcdata9.
    READ TABLE dxbdcdata INTO lst_bdcdata9
         WITH KEY fnam = 'VBAK-VKORG'.
    IF sy-subrc EQ 0.
      DELETE dxbdcdata INDEX sy-tabix.
      lst_sales_area_i0341-vkorg = lst_bdcdata9-fval. " Sales Organization
    ENDIF. " IF sy-subrc EQ 0
*   Distribution Channel
    CLEAR: lst_bdcdata9.
    READ TABLE dxbdcdata INTO lst_bdcdata9
         WITH KEY fnam = 'VBAK-VTWEG'.
    IF sy-subrc EQ 0.
      DELETE dxbdcdata INDEX sy-tabix.
      lst_sales_area_i0341-vtweg = lst_bdcdata9-fval. " Distribution Channel
    ENDIF. " IF sy-subrc EQ 0
*   Division
    CLEAR: lst_bdcdata9.
    READ TABLE dxbdcdata INTO lst_bdcdata9
         WITH KEY fnam = 'VBAK-SPART'.
    IF sy-subrc EQ 0.
      DELETE dxbdcdata INDEX sy-tabix.
      lst_sales_area_i0341-spart = lst_bdcdata9-fval. " Division
    ENDIF. " IF sy-subrc EQ 0

    IF lst_sales_area_i0341 IS NOT INITIAL. " Sales Area
*     Prepare the Memory ID Name
      CONCATENATE didoc_data-docnum
                  '_SALES_AREA'
             INTO lv_mem_name_i0341.
      EXPORT lst_sales_area_i0341 TO MEMORY ID lv_mem_name_i0341.
    ENDIF. " IF lst_sales_area_i0341 IS NOT INITIAL
  ENDIF. " IF sy-subrc EQ 0 AND
ENDIF. " IF dlast_dynpro EQ dynpro-einstieg
* End   of ADD:ERP-6801:WROY:28-JUN-2018:ED2K912446

*** getting number of lines in BDCDATA
DESCRIBE TABLE dxbdcdata LINES lv_line9.
* Read the Idoc Number from Idoc Data
READ TABLE didoc_data INTO lst_idoc9 INDEX 1.
* Reading BDCDATA table into a work area using last index
READ TABLE dxbdcdata INTO lst_bdcdata9 INDEX lv_line9.
IF sy-subrc IS INITIAL.
* BOC for BOM Material *
  li_di_doc1[] = didoc_data[].
  DELETE li_di_doc1 WHERE segnam NE lc_z1qtc_e1edp01_01_9.
  LOOP AT li_di_doc1 INTO lst_di_doc1.
    CLEAR: lst_z1qtc_e1edp01_01_9,
           lv_traty1, lv_vbegdat1,lv_venddat1,
           lv_vbegdat,lv_venddat.
    lst_z1qtc_e1edp01_01_9 = lst_di_doc1-sdata.
    lv_posex9 = lst_z1qtc_e1edp01_01_9-vposn.
    lv_traty1           = lst_z1qtc_e1edp01_01_9-traty. " Transportation Type
    lv_vbegdat1         = lst_z1qtc_e1edp01_01_9-vbegdat. " Contract Strat Date
    lv_venddat1         = lst_z1qtc_e1edp01_01_9-venddat. " Contract End Date
    WRITE lv_vbegdat1 TO lv_vbegdat.
    WRITE lv_venddat1 TO lv_venddat.


    IF lv_posex9 IS NOT INITIAL.
      lst_item91-posex = lv_posex9.
      lst_item91-vbegdat = lv_vbegdat.
      lst_item91-venddat = lv_venddat.
      lst_item91-traty = lv_traty1.
      APPEND lst_item91 TO li_item91.
      CLEAR: lst_item91, lv_posex9,
             lv_vbegdat, lv_venddat.
    ENDIF. " IF lv_posex9 IS NOT INITIAL
  ENDLOOP. " LOOP AT li_di_doc1 INTO lst_di_doc1
  SORT li_item91 BY posex.
  DELETE ADJACENT DUPLICATES FROM li_item91.

***BOC by SAYANDAS for ERP-3450 on 26th July 2017
*  LOOP AT didoc_data INTO lst_idoc_i0341.
*    CASE lst_idoc_i0341-segnam.
*      WHEN lc_e1edk02_9.
*        lst_e1edk02_9 = lst_idoc_i0341-sdata.
*        IF lst_e1edk02_9-qualf = lc_004_9.
*          lv_quotf1 = abap_true.
*        ENDIF. " IF lst_e1edk02_9-qualf = lc_004_9
*
*      WHEN lc_e1edp05_i0341.
*        CLEAR : lst_e1edp05_i0341,
*        lv_kschl , lv_betrg.
*        lst_e1edp05_i0341 = lst_idoc_i0341-sdata.
*        lv_kschl = lst_e1edp05_i0341-kschl.
*        lv_betrg = lst_e1edp05_i0341-betrg.
*
*      WHEN lc_e1edk01_i0341.
*        CLEAR : lst_e1edk01_i0341,
*         lv_curcy.
*        lst_e1edk01_i0341 = lst_idoc_i0341-sdata.
*        lv_curcy = lst_e1edk01_i0341-curcy.
*    ENDCASE.
*    CLEAR lst_idoc_i0341.
*  ENDLOOP. " LOOP AT didoc_data INTO lst_idoc_i0341


***EOC by SAYANDAS for ERP-3450 on 26th July 2017

  IF lst_bdcdata9-fnam+0(10) = 'VBAP-POSEX'.
    lv_pos = lst_bdcdata9-fnam+10(3).
    lv_val = lst_bdcdata9-fval.
*    BREAK-POINT.
    READ TABLE li_item91 INTO lst_item91 WITH KEY posex = lv_val.
    IF sy-subrc = 0.

      IF lst_item91 IS NOT INITIAL.

        CLEAR lst_bdcdata9.
        lst_bdcdata9-program = 'SAPMV45A'.
        lst_bdcdata9-dynpro = '4001'.
        lst_bdcdata9-dynbegin = 'X'.
        APPEND lst_bdcdata9 TO dxbdcdata. " Appending Screen

* BOC by SAYANDAS on 13-Jul-2017 for ERP-2772
*        IF lst_item91-vbegdat IS NOT INITIAL.
        IF lst_item91-vbegdat IS NOT INITIAL AND lst_item91-vbegdat NE  space.
* EOC by SAYANDAS on 13-Jul-2017 for ERP-2772

          CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos INTO lv_selkz.

          CLEAR lst_bdcdata9.
          lst_bdcdata9-fnam = lv_selkz.
          lst_bdcdata9-fval = 'X'.
          APPEND  lst_bdcdata9 TO dxbdcdata. "appending OKCODE

          CLEAR lst_bdcdata9.
          lst_bdcdata9-fnam = 'BDC_OKCODE'.
          lst_bdcdata9-fval = '=PVER'.
          APPEND  lst_bdcdata9 TO dxbdcdata. "appending OKCODE


          CLEAR lst_bdcdata9.
          lst_bdcdata9-program = 'SAPLV45W'.
          lst_bdcdata9-dynpro = '4001'.
          lst_bdcdata9-dynbegin = 'X'.
          APPEND lst_bdcdata9 TO dxbdcdata. " Appending Screen

          CLEAR lst_bdcdata9.
          lst_bdcdata9-fnam = 'VEDA-VBEGDAT'.
          lst_bdcdata9-fval = lst_item91-vbegdat.
          APPEND  lst_bdcdata9 TO dxbdcdata. " Appending Contract Start Date

          CLEAR lst_bdcdata9.
          lst_bdcdata9-fnam = 'VEDA-VENDDAT'.
          lst_bdcdata9-fval = lst_item91-venddat.
          APPEND  lst_bdcdata9 TO dxbdcdata. " Appending Contract End Date

* BOC by SAYANDAS on 13-Jul-2017 for ERP-2772
          IF lst_item91-venddat IS NOT INITIAL.
            CLEAR lst_bdcdata9.
            lst_bdcdata9-fnam = 'VEDA-VENDREG'.
            lst_bdcdata9-fval = space.
            APPEND  lst_bdcdata9 TO dxbdcdata. " Appending Contract End Date
          ENDIF. " IF lst_item91-venddat IS NOT INITIAL
* EOC by SAYANDAS on 13-Jul-2017 for ERP-2772
          CLEAR lst_bdcdata9.
          lst_bdcdata9-fnam = 'BDC_OKCODE'.
          lst_bdcdata9-fval = '/EBACK'.
          APPEND lst_bdcdata9 TO dxbdcdata.

          CLEAR lst_bdcdata9.
          lst_bdcdata9-program = 'SAPMV45A'.
          lst_bdcdata9-dynpro = '4001'.
          lst_bdcdata9-dynbegin = 'X'.
          APPEND lst_bdcdata9 TO dxbdcdata.

        ENDIF. " IF lst_item91-vbegdat IS NOT INITIAL AND lst_item91-vbegdat NE space

        IF lst_item91-traty IS NOT INITIAL.

          CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos INTO lv_selkz.

          CLEAR lst_bdcdata9.
          lst_bdcdata9-fnam = lv_selkz.
          lst_bdcdata9-fval = 'X'.
          APPEND  lst_bdcdata9 TO dxbdcdata. "appending OKCODE

          CLEAR lst_bdcdata9.
          lst_bdcdata9-fnam = 'BDC_OKCODE'.
          lst_bdcdata9-fval = '=PDE2'.
          APPEND  lst_bdcdata9 TO dxbdcdata. "appending OKCODE

          CLEAR lst_bdcdata9.
          lst_bdcdata9-program = 'SAPMV45A'.
          lst_bdcdata9-dynpro = '4003'.
          lst_bdcdata9-dynbegin = 'X'.
          APPEND lst_bdcdata9 TO dxbdcdata. " appending Screen

          CLEAR lst_bdcdata9.
          lst_bdcdata9-fnam = 'BDC_CURSOR'.
          lst_bdcdata9-fval = 'VBKD-TRATY'.
          APPEND lst_bdcdata9 TO dxbdcdata.

          CLEAR lst_bdcdata9.
          lst_bdcdata9-fnam = 'VBKD-TRATY'.
          lst_bdcdata9-fval = lst_item91-traty.
          APPEND lst_bdcdata9 TO dxbdcdata. " Appending TRATY

          CLEAR lst_bdcdata9.
          lst_bdcdata9-fnam = 'BDC_OKCODE'.
          lst_bdcdata9-fval = '/EBACK'.
          APPEND lst_bdcdata9 TO dxbdcdata.

          CLEAR lst_bdcdata9.
          lst_bdcdata9-program = 'SAPMV45A'.
          lst_bdcdata9-dynpro = '4001'.
          lst_bdcdata9-dynbegin = 'X'.
          APPEND lst_bdcdata9 TO dxbdcdata.
        ENDIF. " IF lst_item91-traty IS NOT INITIAL

      ENDIF. " IF lst_item91 IS NOT INITIAL
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF lst_bdcdata9-fnam+0(10) = 'VBAP-POSEX'
* EOC for BOM Material*

*   Check the FNAM and FVAL value of the Lst entry of BDCDATA
*   This is to restrict the execution of the code
  IF lst_bdcdata9-fnam = 'BDC_OKCODE'
     AND lst_bdcdata9-fval = 'SICH'.

    CLEAR lst_idoc9.
    lst_xvbak9 = dxvbak.

    LOOP AT didoc_data INTO lst_idoc9.
      CASE lst_idoc9-segnam.
        WHEN lc_e1edk03_9.
          lst_e1edk03_9 = lst_idoc9-sdata.

          IF lst_e1edk03_9-iddat = lc_022_9. " Billing Date
            lv_date91 = lst_e1edk03_9-datum.
            WRITE lv_date91 TO lv_date9.

          ELSEIF lst_e1edk03_9-iddat = lc_019_9. " Contract Start Date
            WRITE  lst_e1edk03_9-datum TO lv_test9.
            WRITE  lv_test9 TO lv_stdt9.

          ELSEIF lst_e1edk03_9-iddat = lc_020_9. " Contract End Date

            CLEAR lv_test9.
            WRITE lst_e1edk03_9-datum TO lv_test9.
            WRITE lv_test9 TO lv_eddt9.
          ENDIF. " IF lst_e1edk03_9-iddat = lc_022_9

          CLEAR: lst_e1edk03_9.
*** change for quotation
        WHEN lc_e1edk02_9.
          lst_e1edk02_9 = lst_idoc9-sdata.
          IF lst_e1edk02_9-qualf = lc_004_9.
            lv_quotf1 = abap_true.
          ENDIF. " IF lst_e1edk02_9-qualf = lc_004_9

* BOC: CR#7766  KKRAVURI20181008  ED2K913538
          IF lst_e1edk02_9-qualf = lc_001_9.
            lv_bstkd = lst_e1edk02_9-belnr.
          ENDIF. " IF lst_e1edk02_9-qualf = lc_001_9
* EOC: CR#7766  KKRAVURI20181008  ED2K913538

          IF lst_e1edk02_9-qualf = lc_011_9.
            lv_xblnr = lst_e1edk02_9-belnr.
          ENDIF. " IF lst_e1edk02_9-qualf = lc_011_9
*** change for quotation
        WHEN lc_z1qtc_e1edp01_01_9. " Custom Segment for Item Level
          CLEAR: lst_z1qtc_e1edp01_01_9,
                 lv_traty1, lv_vbegdat1,lv_venddat1,
                 lv_vbegdat,lv_venddat.
          lst_z1qtc_e1edp01_01_9 = lst_idoc9-sdata.
          lv_posex9 = lst_z1qtc_e1edp01_01_9-vposn.
*        Calling Conversion Exit FM
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lv_posex9
            IMPORTING
              output = lv_posex9.

          lv_traty1           = lst_z1qtc_e1edp01_01_9-traty. " Transportation Type
          lv_vbegdat1         = lst_z1qtc_e1edp01_01_9-vbegdat. " Contract Strat Date
          lv_venddat1         = lst_z1qtc_e1edp01_01_9-venddat. " Contract End Date
          WRITE lv_vbegdat1 TO lv_vbegdat.
          WRITE lv_venddat1 TO lv_venddat.
***BOC by SAYANDAS for ERP-3450 on 26th July 2017
        WHEN lc_e1edp05_i0341.
          CLEAR : lst_e1edp05_i0341,
          lv_kschl , lv_betrg.
          lst_e1edp05_i0341 = lst_idoc9-sdata.

          lv_kschl = lst_e1edp05_i0341-kschl.
          lv_betrg = lst_e1edp05_i0341-betrg.

        WHEN lc_e1edk01_i0341.
          CLEAR : lst_e1edk01_i0341,
           lv_curcy.
          lst_e1edk01_i0341 = lst_idoc9-sdata.
          lv_curcy = lst_e1edk01_i0341-curcy.
***EOC by SAYANDAS for ERP-3450 on 26th July 2017
        WHEN lc_z1qtc_e1edk01_01_9. "Custom Segment for Header Level
          CLEAR: lst_z1qtc_e1edk01_01_9, lv_traty.
          lst_z1qtc_e1edk01_01_9 = lst_idoc9-sdata.
          lv_traty = lst_z1qtc_e1edk01_01_9-traty. " Transportation Type
          lv_zuonr = lst_z1qtc_e1edk01_01_9-zuonr. " Assignment
      ENDCASE.

      IF lv_posex9 IS NOT INITIAL.

        lst_item9-posex = lv_posex9.
        lst_item9-traty = lv_traty1. " Transportation Type
        lst_item9-vbegdat = lv_vbegdat. " Contract Start Date
        lst_item9-venddat = lv_venddat. " Contract End Date
        APPEND lst_item9 TO li_item9.
        CLEAR: lst_item9, lv_posex9.

      ENDIF. " IF lv_posex9 IS NOT INITIAL
      CLEAR: lst_idoc9.
    ENDLOOP. " LOOP AT didoc_data INTO lst_idoc9

**** change for quotaion
    IF lv_quotf1 = abap_true.
      li_di_doc2[] = didoc_data[].
      DELETE li_di_doc2 WHERE segnam NE lc_e1edp01_9.
      LOOP AT li_di_doc2 INTO lst_di_doc2.
        lst_e1edp01_9 = lst_di_doc2-sdata.
        CLEAR lst_e1edp01_9-posex.
        lv_tabixq1 = sy-tabix.
        lv_tabixq1 = sy-tabix * 10.
        lv_posnr9 = lv_tabixq1.
        lst_e1edp01_9-posex = lv_posnr9.
        APPEND lst_e1edp01_9 TO li_e1edp01_9.
        CLEAR lst_e1edp01_9.
      ENDLOOP. " LOOP AT li_di_doc2 INTO lst_di_doc2
***BOC by SAYANDAS for ERP-3450 on 26th July 2017
      li_di_doc1_i0341[] = didoc_data[].
      DELETE  li_di_doc1_i0341 WHERE segnam NE lc_e1edp05_i0341.
      LOOP AT li_di_doc1_i0341 INTO lst_di_doc1_i0341.
        lst_e1edp052_i0341 = lst_di_doc1_i0341-sdata.
**********************************************************************
*        IF lst_e1edp052_i0341 IS NOT INITIAL.
*          lv_psgnum_i0341 = lst_di_doc1_i0341-psgnum.
*          READ TABLE didoc_data INTO lst_idoc_p05_i0341 WITH KEY segnum = lv_psgnum_i0341.
*          IF sy-subrc = 0.
*            lst_e1edp01_i0341 = lst_idoc_p05_i0341-sdata.
*          ENDIF.
*        ENDIF.
**********************************************************************
        APPEND lst_e1edp052_i0341 TO li_e1edp05_i0341.
        CLEAR lst_e1edp052_i0341.
      ENDLOOP. " LOOP AT li_di_doc1_i0341 INTO lst_di_doc1_i0341
***EOC by SAYANDAS for ERP-3450 on 26th July 2017
    ENDIF. " IF lv_quotf1 = abap_true
*** change for quotaion

    IF lv_date9 IS NOT INITIAL
* BOC: CR#7766  KKRAVURI20181008  ED2K913538
* Below OR Condition is added as part of CR#7766 changes
* Before CR#7766 changes, no OR Condition
       OR lv_bstkd IS NOT INITIAL.
* EOC: CR#7766  KKRAVURI20181008  ED2K913538
      CLEAR lst_bdcdata9. " Clearing work area for BDC data
      lst_bdcdata9-fnam = 'BDC_OKCODE'.
      lst_bdcdata9-fval = 'UER1'.
      APPEND  lst_bdcdata9 TO li_bdcdata41. "appending OKCODE

      CLEAR lst_bdcdata9.
      lst_bdcdata9-program = 'SAPMV45A'.
      lst_bdcdata9-dynpro = '4001'.
      lst_bdcdata9-dynbegin = 'X'.
      APPEND lst_bdcdata9 TO li_bdcdata41. " appending program and screen

*      CLEAR lst_bdcdata9.
*      lst_bdcdata9-fnam = 'KUAGV-KUNNR'.
*      lst_bdcdata9-fval = lst_xvbak9-kunnr.
*      APPEND lst_bdcdata9 TO dxbdcdata. " appending KUNNR

* BOC: CR#7766  KKRAVURI20181008  ED2K913538
* Below IF Condition is added as part of CR#7766 changes
* Before CR#7766 changes, no IF Condition
      IF lv_date9 IS NOT INITIAL.
        CLEAR lst_bdcdata9.
        lst_bdcdata9-fnam = 'VBKD-BSTDK'.
        lst_bdcdata9-fval = lv_date9.
        APPEND lst_bdcdata9 TO li_bdcdata41. " appending Billing Block
      ENDIF. " IF lv_date9 IS NOT INITIAL

* BOC: CR#7766  KKRAVURI20181008  ED2K913538
      IF lv_bstkd IS NOT INITIAL.
        CLEAR lst_bdcdata9.
        lst_bdcdata9-fnam = 'VBKD-BSTKD'.
        lst_bdcdata9-fval = lv_bstkd.
        APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Customer Purchase Order
        CLEAR lv_bstkd.
      ENDIF. " IF lv_bstkd IS NOT INITIAL
* EOC: CR#7766  KKRAVURI20181008  ED2K913538

    ENDIF. " IF lv_date9 IS NOT INITIAL OR

    IF lv_stdt9 IS NOT INITIAL. " Contract Date

      CLEAR lst_bdcdata9. " Clearing work area for BDC data
      lst_bdcdata9-fnam = 'BDC_OKCODE'.
      lst_bdcdata9-fval = 'UER1'.
      APPEND  lst_bdcdata9 TO li_bdcdata41. "appending OKCODE

      CLEAR lst_bdcdata9.
      lst_bdcdata9-program = 'SAPMV45A'.
      lst_bdcdata9-dynpro = '4001'.
      lst_bdcdata9-dynbegin = 'X'.
      APPEND lst_bdcdata9 TO li_bdcdata41. " appending program and screen

      CLEAR lst_bdcdata9.
      lst_bdcdata9-fnam = 'VEDA-VBEGDAT'.
      lst_bdcdata9-fval = lv_stdt9.
      APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Contract Start Date

      CLEAR lst_bdcdata9.
      lst_bdcdata9-fnam = 'VEDA-VENDDAT'.
      lst_bdcdata9-fval = lv_eddt9.
      APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Contract End Date

*      CLEAR lst_bdcdata9.
*      lst_bdcdata9-program = 'SAPLSPO1'.
*      lst_bdcdata9-dynpro = '0400'.
*      lst_bdcdata9-dynbegin = 'X'.
*      APPEND lst_bdcdata9 TO li_bdcdata41. " appending program and screen
*
*      CLEAR lst_bdcdata9.
*      lst_bdcdata9-fnam = 'BDC_OKCODE'.
*      lst_bdcdata9-fval = '=YES'.
*      APPEND  lst_bdcdata9 TO li_bdcdata41. " appending OKCODE

    ENDIF. " IF lv_stdt9 IS NOT INITIAL



******
*** Getting back to Initial Screen
    CLEAR lst_bdcdata9. " Clearing work area for BDCDATA
    lst_bdcdata9-fnam = 'BDC_OKCODE'.
    lst_bdcdata9-fval = 'UER1'.
    APPEND  lst_bdcdata9 TO li_bdcdata41. " appending OKCODE

    IF lv_quotf1 = abap_false.

      IF dxvbap[] IS NOT INITIAL.

        li_vbap9[] = dxvbap[].

        IF li_item9 IS NOT INITIAL.

          SORT li_item9 BY posex.
          DELETE ADJACENT DUPLICATES FROM li_item9.
          LOOP AT li_vbap9 INTO lst_vbap9.

            CLEAR lst_bdcdata9.
            lst_bdcdata9-program = 'SAPMV45A'.
            lst_bdcdata9-dynpro = '4001'.
            lst_bdcdata9-dynbegin = 'X'.
            APPEND lst_bdcdata9 TO li_bdcdata41.
*        Calling Conversion Exit FM
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lst_vbap9-posex
              IMPORTING
                output = lst_vbap9-posex.

            READ TABLE li_item9 INTO lst_item9 WITH KEY posex = lst_vbap9-posex BINARY SEARCH.
            IF sy-subrc = 0.
*              IF lst_item9-traty IS NOT INITIAL. " Means of transportation ID
*                CLEAR: lst_bdcdata9.
*                lst_bdcdata9-fnam = 'BDC_OKCODE'.
*                lst_bdcdata9-fval = 'POPO'.
*                APPEND lst_bdcdata9 TO li_bdcdata41. " appending OKCODE
*
*                CLEAR: lst_bdcdata9.
*                lst_bdcdata9-program = 'SAPMV45A'.
*                lst_bdcdata9-dynpro = '251'.
*                lst_bdcdata9-dynbegin = 'X'.
*                APPEND lst_bdcdata9 TO li_bdcdata41. " appending Screen
*
*                CLEAR: lst_bdcdata9.
*                lst_bdcdata9-fnam = 'RV45A-POSNR'.
*                lst_bdcdata9-fval = lst_vbap9-posex.
*                APPEND lst_bdcdata9 TO li_bdcdata41.
*
*                CLEAR: lst_bdcdata9.
*                lst_bdcdata9-program = 'SAPMV45A'.
*                lst_bdcdata9-dynpro = '4001'.
*                lst_bdcdata9-dynbegin = 'X'.
*                APPEND lst_bdcdata9 TO li_bdcdata41. " appending Screen
*
**              CLEAR lst_bdcdata9.
**              lst_bdcdata9-fnam = 'BDC_OKCODE'.
**              lst_bdcdata9-fval = 'PKAU'.
**              APPEND lst_bdcdata9 TO dxbdcdata."appending OKCODE
**
**              CLEAR lst_bdcdata9.
**              lst_bdcdata9-program = 'SAPMV45A'.
**              lst_bdcdata9-dynpro = '4003'.
**              lst_bdcdata9-dynbegin = 'X'.
**              APPEND lst_bdcdata9 TO dxbdcdata." appending Screen
*
*                CLEAR lst_bdcdata9.
*                lst_bdcdata9-fnam = 'BDC_OKCODE'.
*                lst_bdcdata9-fval = '=PDE2'.
*                APPEND  lst_bdcdata9 TO li_bdcdata41. "appending OKCODE
*
*                CLEAR lst_bdcdata9.
*                lst_bdcdata9-program = 'SAPMV45A'.
*                lst_bdcdata9-dynpro = '4003'.
*                lst_bdcdata9-dynbegin = 'X'.
*                APPEND lst_bdcdata9 TO li_bdcdata41. " appending Screen
*
*                CLEAR lst_bdcdata9.
*                lst_bdcdata9-fnam = 'BDC_CURSOR'.
*                lst_bdcdata9-fval = 'VBKD-TRATY'.
*                APPEND lst_bdcdata9 TO li_bdcdata41.
*
*                CLEAR lst_bdcdata9.
*                lst_bdcdata9-fnam = 'VBKD-TRATY'.
*                lst_bdcdata9-fval = lst_item9-traty.
*                APPEND lst_bdcdata9 TO li_bdcdata41. " Appending TRATY
*
*                CLEAR lst_bdcdata9.
*                lst_bdcdata9-fnam = 'BDC_OKCODE'.
*                lst_bdcdata9-fval = '/EBACK'.
*                APPEND lst_bdcdata9 TO li_bdcdata41.
*
*                CLEAR lst_bdcdata9.
*                lst_bdcdata9-program = 'SAPMV45A'.
*                lst_bdcdata9-dynpro = '4001'.
*                lst_bdcdata9-dynbegin = 'X'.
*                APPEND lst_bdcdata9 TO li_bdcdata41.
*              ENDIF. " IF lst_item9-traty IS NOT INITIAL

*              IF lst_item9-vbegdat IS NOT INITIAL. " Contract Date
*                CLEAR: lst_bdcdata9.
*                lst_bdcdata9-fnam = 'BDC_OKCODE'.
*                lst_bdcdata9-fval = 'POPO'.
*                APPEND lst_bdcdata9 TO li_bdcdata41. "Appending OKCODE
*
*                CLEAR: lst_bdcdata9.
*                lst_bdcdata9-program = 'SAPMV45A'.
*                lst_bdcdata9-dynpro = '251'.
*                lst_bdcdata9-dynbegin = 'X'.
*                APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Screen
*
*                CLEAR: lst_bdcdata9.
*                lst_bdcdata9-fnam = 'RV45A-POSNR'.
*                lst_bdcdata9-fval = lst_vbap9-posex.
*                APPEND lst_bdcdata9 TO li_bdcdata41.
*
*                CLEAR: lst_bdcdata9.
*                lst_bdcdata9-program = 'SAPMV45A'.
*                lst_bdcdata9-dynpro = '4001'.
*                lst_bdcdata9-dynbegin = 'X'.
*                APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Screen
*
**              CLEAR lst_bdcdata9.
**              lst_bdcdata9-fnam = 'BDC_OKCODE'.
**              lst_bdcdata9-fval = 'PKAU'.
**              APPEND lst_bdcdata9 TO dxbdcdata."Appending OKCODE
**
**              CLEAR lst_bdcdata9.
**              lst_bdcdata9-program = 'SAPMV45A'.
**              lst_bdcdata9-dynpro = '4003'.
**              lst_bdcdata9-dynbegin = 'X'.
**              APPEND lst_bdcdata9 TO dxbdcdata." Appending Screen
*
*                CLEAR lst_bdcdata9.
*                lst_bdcdata9-fnam = 'BDC_OKCODE'.
*                lst_bdcdata9-fval = '=PVER'.
*                APPEND  lst_bdcdata9 TO li_bdcdata41. "appending OKCODE
*
*                CLEAR lst_bdcdata9.
*                lst_bdcdata9-program = 'SAPLV45W'.
*                lst_bdcdata9-dynpro = '4001'.
*                lst_bdcdata9-dynbegin = 'X'.
*                APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Screen
*
*                CLEAR lst_bdcdata9.
*                lst_bdcdata9-fnam = 'VEDA-VBEGDAT'.
*                lst_bdcdata9-fval = lst_item9-vbegdat.
*                APPEND  lst_bdcdata9 TO li_bdcdata41. " Appending Contract Start Date
*
*                CLEAR lst_bdcdata9.
*                lst_bdcdata9-fnam = 'VEDA-VENDDAT'.
*                lst_bdcdata9-fval = lst_item9-venddat.
*                APPEND  lst_bdcdata9 TO li_bdcdata41. " Appending Contract End Date
*
*                CLEAR lst_bdcdata9.
*                lst_bdcdata9-fnam = 'BDC_OKCODE'.
*                lst_bdcdata9-fval = '/EBACK'.
*                APPEND lst_bdcdata9 TO li_bdcdata41.
*
*                CLEAR lst_bdcdata9.
*                lst_bdcdata9-program = 'SAPMV45A'.
*                lst_bdcdata9-dynpro = '4001'.
*                lst_bdcdata9-dynbegin = 'X'.
*                APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Screen
*              ENDIF. " IF lst_item9-vbegdat IS NOT INITIAL
            ENDIF. " IF sy-subrc = 0
          ENDLOOP. " LOOP AT li_vbap9 INTO lst_vbap9
        ENDIF. " IF li_item9 IS NOT INITIAL

      ENDIF. " IF dxvbap[] IS NOT INITIAL
    ENDIF. " IF lv_quotf1 = abap_false

*** change for quotation
***BOC by SAYANDAS for ERP-3450 on 26th July 2017
    IF lv_quotf1 = abap_true.
      DESCRIBE TABLE dxbdcdata LINES lv_line_i0341.

      lv_line_i0341 = lv_line_i0341 - 1.
* Reading BDCDATA table into a work area using last index
      READ TABLE dxbdcdata INTO lst_bdcdata_i0341 INDEX lv_line_i0341.
      IF lst_bdcdata_i0341-fnam = 'VBKD-IHREZ_E'.

*        IF lv_kschl IS NOT INITIAL.
        IF li_e1edp05_i0341 IS NOT INITIAL.
          CLEAR: lst_bdcdata9.
          lst_bdcdata9-fnam = 'BDC_OKCODE'.
          lst_bdcdata9-fval = 'POPO'.
          APPEND lst_bdcdata9 TO li_bdcdata41. "Appending OKCODE

          CLEAR: lst_bdcdata9.
          lst_bdcdata9-program = 'SAPMV45A'.
          lst_bdcdata9-dynpro = '251'.
          lst_bdcdata9-dynbegin = 'X'.
          APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Screen

          CLEAR: lst_bdcdata9.
          lst_bdcdata9-fnam = 'RV45A-POSNR'.
          lst_bdcdata9-fval = '000010'. " Assuming only one line item for ZREW scenario
          APPEND lst_bdcdata9 TO li_bdcdata41.

          CLEAR: lst_bdcdata9.
          lst_bdcdata9-program = 'SAPMV45A'.
          lst_bdcdata9-dynpro = '4001'.
          lst_bdcdata9-dynbegin = 'X'.
          APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Screen

          CLEAR: lst_bdcdata9.
          lst_bdcdata9-fnam = 'BDC_OKCODE'.
          lst_bdcdata9-fval = 'PKO1'.
          APPEND lst_bdcdata9 TO li_bdcdata41. " appending OKCODE

          CLEAR lst_bdcdata9.
          lst_bdcdata9-program = 'SAPMV45A'.
          lst_bdcdata9-dynpro = '5003'.
          lst_bdcdata9-dynbegin = 'X'.
          APPEND lst_bdcdata9 TO li_bdcdata41.

          LOOP AT li_e1edp05_i0341  INTO lst_e1edp052_i0341.

            CLEAR: lst_bdcdata9.
            lst_bdcdata9-fnam = 'BDC_OKCODE'.
            lst_bdcdata9-fval = 'V69A_KOAN'.
            APPEND lst_bdcdata9 TO li_bdcdata41. " appending OKCODE

            CLEAR lst_bdcdata9.
            lst_bdcdata9-program = 'SAPMV45A'.
            lst_bdcdata9-dynpro = '5003'.
            lst_bdcdata9-dynbegin = 'X'.
            APPEND lst_bdcdata9 TO li_bdcdata41.

            CLEAR: lst_bdcdata9.
            lst_bdcdata9-fnam = 'KOMV-KSCHL(02)'.
*          lst_bdcdata9-fval = lv_kschl.
            lst_bdcdata9-fval = lst_e1edp052_i0341-kschl.
            APPEND lst_bdcdata9 TO li_bdcdata41. " appending OKCODE

            CLEAR: lst_bdcdata9.
            lst_bdcdata9-fnam = 'RV61A-KOEIN(02)'.
            lst_bdcdata9-fval = lv_curcy.
            APPEND lst_bdcdata9 TO li_bdcdata41. " appending OKCODE

            CLEAR: lst_bdcdata9.
            lst_bdcdata9-fnam = 'KOMV-KWERT(02)'.
*          lst_bdcdata9-fval = lv_betrg.
            lst_bdcdata9-fval = lst_e1edp052_i0341-betrg.
            APPEND lst_bdcdata9 TO li_bdcdata41. " appending OKCODE

          ENDLOOP. " LOOP AT li_e1edp05_i0341 INTO lst_e1edp052_i0341

          CLEAR lst_bdcdata9. " Clearing work area for BDC data
          lst_bdcdata9-fnam = 'BDC_OKCODE'.
          lst_bdcdata9-fval = 'UER1'.
          APPEND  lst_bdcdata9 TO li_bdcdata41. "appending OKCODE

          CLEAR lst_bdcdata9.
          lst_bdcdata9-program = 'SAPMV45A'.
          lst_bdcdata9-dynpro = '4001'.
          lst_bdcdata9-dynbegin = 'X'.
          APPEND lst_bdcdata9 TO li_bdcdata41. " appending program and screen


        ENDIF. " IF li_e1edp05_i0341 IS NOT INITIAL
      ENDIF. " IF lst_bdcdata_i0341-fnam = 'VBKD-IHREZ_E'
***EOC by SAYANDAS for ERP-3450 on 26th July 2017
      IF li_e1edp01_9[] IS NOT INITIAL.
        IF li_item9 IS NOT INITIAL.
          SORT li_item9 BY posex.
          DELETE ADJACENT DUPLICATES FROM li_item9.
          LOOP AT li_e1edp01_9 INTO lst_e1edp01_9.

            CLEAR lst_bdcdata9.
            lst_bdcdata9-program = 'SAPMV45A'.
            lst_bdcdata9-dynpro = '4001'.
            lst_bdcdata9-dynbegin = 'X'.
            APPEND lst_bdcdata9 TO li_bdcdata41.

*        Calling Conversion Exit FM
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lst_e1edp01_9-posex
              IMPORTING
                output = lst_e1edp01_9-posex.

            READ TABLE li_item9 INTO lst_item9 WITH KEY posex = lst_e1edp01_9-posex BINARY SEARCH.
            IF sy-subrc = 0.
              IF lst_item9-traty IS NOT INITIAL. " Means of transportation ID
                CLEAR: lst_bdcdata9.
                lst_bdcdata9-fnam = 'BDC_OKCODE'.
                lst_bdcdata9-fval = 'POPO'.
                APPEND lst_bdcdata9 TO li_bdcdata41. " appending OKCODE

                CLEAR: lst_bdcdata9.
                lst_bdcdata9-program = 'SAPMV45A'.
                lst_bdcdata9-dynpro = '251'.
                lst_bdcdata9-dynbegin = 'X'.
                APPEND lst_bdcdata9 TO li_bdcdata41. " appending Screen

                CLEAR: lst_bdcdata9.
                lst_bdcdata9-fnam = 'RV45A-POSNR'.
                lst_bdcdata9-fval = lst_e1edp01_9-posex.
                APPEND lst_bdcdata9 TO li_bdcdata41.

                CLEAR: lst_bdcdata9.
                lst_bdcdata9-program = 'SAPMV45A'.
                lst_bdcdata9-dynpro = '4001'.
                lst_bdcdata9-dynbegin = 'X'.
                APPEND lst_bdcdata9 TO li_bdcdata41. " appending Screen

*              CLEAR lst_bdcdata9.
*              lst_bdcdata9-fnam = 'BDC_OKCODE'.
*              lst_bdcdata9-fval = 'PKAU'.
*              APPEND lst_bdcdata9 TO dxbdcdata."appending OKCODE
*
*              CLEAR lst_bdcdata9.
*              lst_bdcdata9-program = 'SAPMV45A'.
*              lst_bdcdata9-dynpro = '4003'.
*              lst_bdcdata9-dynbegin = 'X'.
*              APPEND lst_bdcdata9 TO dxbdcdata." appending Screen

                CLEAR lst_bdcdata9.
                lst_bdcdata9-fnam = 'BDC_OKCODE'.
                lst_bdcdata9-fval = '=PDE2'.
                APPEND  lst_bdcdata9 TO li_bdcdata41. "appending OKCODE

                CLEAR lst_bdcdata9.
                lst_bdcdata9-program = 'SAPMV45A'.
                lst_bdcdata9-dynpro = '4003'.
                lst_bdcdata9-dynbegin = 'X'.
                APPEND lst_bdcdata9 TO li_bdcdata41. " appending Screen

                CLEAR lst_bdcdata9.
                lst_bdcdata9-fnam = 'BDC_CURSOR'.
                lst_bdcdata9-fval = 'VBKD-TRATY'.
                APPEND lst_bdcdata9 TO li_bdcdata41.

                CLEAR lst_bdcdata9.
                lst_bdcdata9-fnam = 'VBKD-TRATY'.
                lst_bdcdata9-fval = lst_item9-traty.
                APPEND lst_bdcdata9 TO li_bdcdata41. " Appending TRATY

                CLEAR lst_bdcdata9.
                lst_bdcdata9-fnam = 'BDC_OKCODE'.
                lst_bdcdata9-fval = '/EBACK'.
                APPEND lst_bdcdata9 TO li_bdcdata41.

                CLEAR lst_bdcdata9.
                lst_bdcdata9-program = 'SAPMV45A'.
                lst_bdcdata9-dynpro = '4001'.
                lst_bdcdata9-dynbegin = 'X'.
                APPEND lst_bdcdata9 TO li_bdcdata41.
              ENDIF. " IF lst_item9-traty IS NOT INITIAL

              IF lst_item9-vbegdat IS NOT INITIAL. " Contract Date
                CLEAR: lst_bdcdata9.
                lst_bdcdata9-fnam = 'BDC_OKCODE'.
                lst_bdcdata9-fval = 'POPO'.
                APPEND lst_bdcdata9 TO li_bdcdata41. "Appending OKCODE

                CLEAR: lst_bdcdata9.
                lst_bdcdata9-program = 'SAPMV45A'.
                lst_bdcdata9-dynpro = '251'.
                lst_bdcdata9-dynbegin = 'X'.
                APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Screen

                CLEAR: lst_bdcdata9.
                lst_bdcdata9-fnam = 'RV45A-POSNR'.
                lst_bdcdata9-fval = lst_e1edp01_9-posex.
                APPEND lst_bdcdata9 TO li_bdcdata41.

                CLEAR: lst_bdcdata9.
                lst_bdcdata9-program = 'SAPMV45A'.
                lst_bdcdata9-dynpro = '4001'.
                lst_bdcdata9-dynbegin = 'X'.
                APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Screen

*              CLEAR lst_bdcdata9.
*              lst_bdcdata9-fnam = 'BDC_OKCODE'.
*              lst_bdcdata9-fval = 'PKAU'.
*              APPEND lst_bdcdata9 TO dxbdcdata."Appending OKCODE
*
*              CLEAR lst_bdcdata9.
*              lst_bdcdata9-program = 'SAPMV45A'.
*              lst_bdcdata9-dynpro = '4003'.
*              lst_bdcdata9-dynbegin = 'X'.
*              APPEND lst_bdcdata9 TO dxbdcdata." Appending Screen

                CLEAR lst_bdcdata9.
                lst_bdcdata9-fnam = 'BDC_OKCODE'.
                lst_bdcdata9-fval = '=PVER'.
                APPEND  lst_bdcdata9 TO li_bdcdata41. "appending OKCODE

                CLEAR lst_bdcdata9.
                lst_bdcdata9-program = 'SAPLV45W'.
                lst_bdcdata9-dynpro = '4001'.
                lst_bdcdata9-dynbegin = 'X'.
                APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Screen

                CLEAR lst_bdcdata9.
                lst_bdcdata9-fnam = 'VEDA-VBEGDAT'.
                lst_bdcdata9-fval = lst_item9-vbegdat.
                APPEND  lst_bdcdata9 TO li_bdcdata41. " Appending Contract Start Date

                CLEAR lst_bdcdata9.
                lst_bdcdata9-fnam = 'VEDA-VENDDAT'.
                lst_bdcdata9-fval = lst_item9-venddat.
                APPEND  lst_bdcdata9 TO li_bdcdata41. " Appending Contract End Date

                CLEAR lst_bdcdata9.
                lst_bdcdata9-fnam = 'BDC_OKCODE'.
                lst_bdcdata9-fval = '/EBACK'.
                APPEND lst_bdcdata9 TO li_bdcdata41.

                CLEAR lst_bdcdata9.
                lst_bdcdata9-program = 'SAPMV45A'.
                lst_bdcdata9-dynpro = '4001'.
                lst_bdcdata9-dynbegin = 'X'.
                APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Screen
              ENDIF. " IF lst_item9-vbegdat IS NOT INITIAL
            ENDIF. " IF sy-subrc = 0

          ENDLOOP. " LOOP AT li_e1edp01_9 INTO lst_e1edp01_9
        ENDIF. " IF li_item9 IS NOT INITIAL
      ENDIF. " IF li_e1edp01_9[] IS NOT INITIAL
    ENDIF. " IF lv_quotf1 = abap_true
*** change for quotation

    IF lv_zuonr IS NOT INITIAL OR lv_xblnr IS NOT INITIAL. " Assignment

      CLEAR lst_bdcdata9. " Clearing work area for BDC data
      lst_bdcdata9-fnam = 'BDC_OKCODE'.
      lst_bdcdata9-fval = 'UER1'.
      APPEND  lst_bdcdata9 TO li_bdcdata41. "appending OKCODE

      CLEAR lst_bdcdata9.
      lst_bdcdata9-program = 'SAPMV45A'.
      lst_bdcdata9-dynpro = '4001'.
      lst_bdcdata9-dynbegin = 'X'.
      APPEND lst_bdcdata9 TO li_bdcdata41. " appending program and screen

*      CLEAR lst_bdcdata9. " Clearing work area for BDC data
*      lst_bdcdata9-fnam = 'BDC_OKCODE'.
*      lst_bdcdata9-fval = 'KKAU'.
*      APPEND  lst_bdcdata9 TO dxbdcdata. "appending OKCODE
*
*      CLEAR lst_bdcdata9.
*      lst_bdcdata9-program = 'SAPMV45A'.
*      lst_bdcdata9-dynpro = '4002'.
*      lst_bdcdata9-dynbegin = 'X'.
*      APPEND lst_bdcdata9 TO dxbdcdata. " appending program and screen

      CLEAR lst_bdcdata9.
      lst_bdcdata9-fnam = 'BDC_OKCODE'.
      lst_bdcdata9-fval = '=KBUC'.
      APPEND  lst_bdcdata9 TO li_bdcdata41. "appending OKCODE

      CLEAR lst_bdcdata9.
      lst_bdcdata9-program = 'SAPMV45A'.
      lst_bdcdata9-dynpro = '4002'.
      lst_bdcdata9-dynbegin = 'X'.
      APPEND lst_bdcdata9 TO li_bdcdata41. " appending program and screen

      IF lv_zuonr IS NOT INITIAL.

        CLEAR lst_bdcdata9.
        lst_bdcdata9-fnam = 'BDC_CURSOR'.
        lst_bdcdata9-fval = 'VBAK-ZUONR'.
        APPEND lst_bdcdata9 TO li_bdcdata41.

        CLEAR lst_bdcdata9.
        lst_bdcdata9-fnam = 'VBAK-ZUONR'.
        lst_bdcdata9-fval = lv_zuonr.
        APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Assignment

      ENDIF. " IF lv_zuonr IS NOT INITIAL

      IF lv_xblnr IS NOT INITIAL.

        CLEAR lst_bdcdata9.
        lst_bdcdata9-fnam = 'BDC_CURSOR'.
        lst_bdcdata9-fval = 'VBAK-XBLNR'.
        APPEND lst_bdcdata9 TO li_bdcdata41.

        CLEAR lst_bdcdata9.
        lst_bdcdata9-fnam = 'VBAK-XBLNR'.
        lst_bdcdata9-fval = lv_xblnr.
        APPEND lst_bdcdata9 TO li_bdcdata41. " Appending Assignment

      ENDIF. " IF lv_xblnr IS NOT INITIAL

      CLEAR lst_bdcdata9.
      lst_bdcdata9-fnam = 'BDC_OKCODE'.
      lst_bdcdata9-fval = '/EBACK'.
      APPEND  lst_bdcdata9 TO li_bdcdata41. "appending OKCODE

      CLEAR lst_bdcdata9.
      lst_bdcdata9-program = 'SAPMV45A'.
      lst_bdcdata9-dynpro = '4001'.
      lst_bdcdata9-dynbegin = 'X'.
      APPEND lst_bdcdata9 TO li_bdcdata41. " appending program and screen

    ENDIF. " IF lv_zuonr IS NOT INITIAL OR lv_xblnr IS NOT INITIAL

    IF lv_traty IS NOT INITIAL. " Means of Transportation ID

      CLEAR lst_bdcdata9. " Clearing work area for BDC data
      lst_bdcdata9-fnam = 'BDC_OKCODE'.
      lst_bdcdata9-fval = 'UER1'.
      APPEND  lst_bdcdata9 TO li_bdcdata41. "appending OKCODE

      CLEAR lst_bdcdata9.
      lst_bdcdata9-program = 'SAPMV45A'.
      lst_bdcdata9-dynpro = '4001'.
      lst_bdcdata9-dynbegin = 'X'.
      APPEND lst_bdcdata9 TO li_bdcdata41. " appending program and screen

*      CLEAR lst_bdcdata9. " Clearing work area for BDC data
*      lst_bdcdata9-fnam = 'BDC_OKCODE'.
*      lst_bdcdata9-fval = 'KKAU'.
*      APPEND  lst_bdcdata9 TO dxbdcdata. "appending OKCODE
*
*      CLEAR lst_bdcdata9.
*      lst_bdcdata9-program = 'SAPMV45A'.
*      lst_bdcdata9-dynpro = '4002'.
*      lst_bdcdata9-dynbegin = 'X'.
*      APPEND lst_bdcdata9 TO dxbdcdata. " appending program and screen

      CLEAR lst_bdcdata9.
      lst_bdcdata9-fnam = 'BDC_OKCODE'.
      lst_bdcdata9-fval = '=KDE2'.
      APPEND  lst_bdcdata9 TO li_bdcdata41. "appending OKCODE

      CLEAR lst_bdcdata9.
      lst_bdcdata9-program = 'SAPMV45A'.
      lst_bdcdata9-dynpro = '4002'.
      lst_bdcdata9-dynbegin = 'X'.
      APPEND lst_bdcdata9 TO li_bdcdata41. " appending program and screen

      CLEAR lst_bdcdata9.
      lst_bdcdata9-fnam = 'BDC_CURSOR'.
      lst_bdcdata9-fval = 'VBKD-TRATY'.
      APPEND lst_bdcdata9 TO li_bdcdata41.

      CLEAR lst_bdcdata9.
      lst_bdcdata9-fnam = 'VBKD-TRATY'.
      lst_bdcdata9-fval = lv_traty.
      APPEND lst_bdcdata9 TO li_bdcdata41. "Appending Transportation Type

      CLEAR lst_bdcdata9.
      lst_bdcdata9-fnam = 'BDC_OKCODE'.
      lst_bdcdata9-fval = '/EBACK'.
      APPEND  lst_bdcdata9 TO li_bdcdata41. "appending OKCODE

      CLEAR lst_bdcdata9.
      lst_bdcdata9-program = 'SAPMV45A'.
      lst_bdcdata9-dynpro = '4001'.
      lst_bdcdata9-dynbegin = 'X'.
      APPEND lst_bdcdata9 TO li_bdcdata41. " appending program and screen


    ENDIF. " IF lv_traty IS NOT INITIAL

    DESCRIBE TABLE dxbdcdata LINES lv_tabix41.
    IF lv_quotf1 = abap_false.
      READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0341> INDEX lv_tabix41.
      IF <lst_bdcdata_0341> IS ASSIGNED.
        <lst_bdcdata_0341>-fval = 'OWN_OKCODE'.
      ENDIF. " IF <lst_bdcdata_0341> IS ASSIGNED
    ENDIF. " IF lv_quotf1 = abap_false
    INSERT LINES OF li_bdcdata41 INTO dxbdcdata INDEX lv_tabix41.

  ENDIF. " IF lst_bdcdata9-fnam = 'BDC_OKCODE'

  IF   lst_bdcdata9-fnam = 'BDC_OKCODE'
   AND lst_bdcdata9-fval = 'OWN_OKCODE'.

    DESCRIBE TABLE dxbdcdata LINES lv_tabix41.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0341> INDEX lv_tabix41.
    IF <lst_bdcdata_0341> IS ASSIGNED.
      <lst_bdcdata_0341>-fval = 'SICH'.
    ENDIF. " IF <lst_bdcdata_0341> IS ASSIGNED

  ENDIF. " IF lst_bdcdata9-fnam = 'BDC_OKCODE'
ENDIF. " IF sy-subrc IS INITIAL

*** Code to insert KWMENG
lst_vbap10 = dxvbap. " Copy the value in local work area
* Calling Conversion Exit FM to remove leading zeros
CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
  EXPORTING
    input  = lst_vbap10-posnr
  IMPORTING
    output = lv_1.


CONCATENATE 'VBAP-ZMENG(' lv_1 ')' INTO lv_zmeng. "ZMENG Field Name
READ TABLE dxbdcdata INTO lst_bdcdata9 WITH KEY fnam = lv_zmeng.
IF sy-subrc = 0.
  lv_tabix1 = sy-tabix. " Storing the index of ZMENG
  READ TABLE dxbdcdata INTO lst_bdcdata11 WITH KEY fnam = 'RV45A-KWMENG(1)'.
  IF sy-subrc NE 0.

    lst_bdcdata10-dynpro = '0000'.
    CONCATENATE 'RV45A-KWMENG(' lv_1 ')' INTO lv_kwmeng. " KWMENG field

    lst_bdcdata10-fnam = lv_kwmeng.
    lst_bdcdata10-fval = lst_bdcdata9-fval.

    INSERT lst_bdcdata10 INTO dxbdcdata INDEX lv_tabix1.
    CLEAR: lst_bdcdata11, lst_bdcdata10. " appending KWMENG
  ENDIF. " IF sy-subrc NE 0
  CLEAR lst_bdcdata9.
ENDIF. " IF sy-subrc = 0

* SOC by NPOLINA ERPM1431 29/Oct/2019
DATA:lv_begdt_10 TYPE char10,   " Stdt9 of type CHAR10
     lv_enddt_10 TYPE char10,   " Eddt9 of type CHAR10
     li_dxbdcdat TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
     lv_pos_10   TYPE char3,
     lv_selkz_10 TYPE char19,                    " Selkz of type CHAR19
     lv_tabx_10  TYPE sy-tabix.

STATICS:lv_line_10   TYPE char1,
        lv_condat    TYPE char1,
        lv_docnum_t4 TYPE edi_docnum.    " NPOLINA ERPM1431 ED1K911549

* SOC by NPOLINA  ERPM1431 ED1K911549
IF didoc_data-docnum NE lv_docnum_t4.
  CLEAR:lv_line_10,lv_condat,lv_docnum_t4.
  lv_docnum_t4 = didoc_data-docnum.
ENDIF.
* EOC by NPOLINA  ERPM1431 ED1K911549
* Update Item contract dates
CLEAR :lst_bdcdata_31.
READ TABLE dxbdcdata INTO lst_bdcdata_31  WITH KEY fnam = 'BDC_OKCODE' fval = 'SICH'.
IF sy-subrc EQ 0 AND lv_condat IS INITIAL.
  lv_tabx_10 = sy-tabix.
  lv_condat = abap_true.
  READ TABLE didoc_data ASSIGNING FIELD-SYMBOL(<lfs_edk03>) WITH KEY segnam = lc_e1edk03_9
                                                                     sdata+0(3) = lc_019_9.
  IF sy-subrc EQ 0.
    CLEAR:lst_e1edk03_9,lv_begdt_10.
    lst_e1edk03_9 = <lfs_edk03>-sdata.
    CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
      EXPORTING
        input  = lst_e1edk03_9-datum
      IMPORTING
        output = lv_begdt_10.
  ENDIF.
  READ TABLE didoc_data ASSIGNING FIELD-SYMBOL(<lfs_edk03_1>) WITH KEY segnam = lc_e1edk03_9
                                                                     sdata+0(3) = lc_020_9.
  IF sy-subrc EQ 0.
    CLEAR:lst_e1edk03_9,lv_enddt_10.
    lst_e1edk03_9 = <lfs_edk03_1>-sdata.
    CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
      EXPORTING
        input  = lst_e1edk03_9-datum
      IMPORTING
        output = lv_enddt_10.
  ENDIF.

  IF lv_begdt_10 IS INITIAL OR lv_enddt_10 IS INITIAL.
    READ TABLE didoc_data ASSIGNING FIELD-SYMBOL(<lfs_edp03_1>) WITH KEY segnam = lc_z1qtc_e1edp01_01_9.
    IF sy-subrc EQ 0.

      CLEAR:lst_z1qtc_e1edp01_01_9,lv_begdt_10,lv_enddt_10.
      lst_z1qtc_e1edp01_01_9 = <lfs_edp03_1>-sdata.
      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = lst_z1qtc_e1edp01_01_9-vbegdat
        IMPORTING
          output = lv_begdt_10.

      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = lst_z1qtc_e1edp01_01_9-venddat
        IMPORTING
          output = lv_enddt_10.
    ENDIF.
  ENDIF.

  IF lv_begdt_10 IS NOT INITIAL OR lv_enddt_10 IS NOT INITIAL.

    lv_pos_10 = 1.
    CONDENSE lv_pos_10 NO-GAPS.
    CLEAR lst_bdcdata11.
    lst_bdcdata11-program = 'SAPMV45A'.
    lst_bdcdata11-dynpro = '4001'.
    lst_bdcdata11-dynbegin = 'X'.
    APPEND lst_bdcdata11 TO li_dxbdcdat. " appending program and screen

    CONCATENATE 'RV45A-VBAP_SELKZ(' lv_pos_10 ')' INTO lv_selkz_10.

    CLEAR lst_bdcdata11.
    lst_bdcdata11-fnam = lv_selkz_10.
    lst_bdcdata11-fval = 'X'.
    APPEND  lst_bdcdata11 TO li_dxbdcdat. "appending OKCODE

    CLEAR lst_bdcdata11.
    lst_bdcdata11-fnam = 'BDC_OKCODE'.
    lst_bdcdata11-fval = '=PVER'.
    APPEND  lst_bdcdata11 TO li_dxbdcdat. "appending OKCODE

    CLEAR lst_bdcdata11.
    lst_bdcdata11-program = 'SAPLV45W'.
    lst_bdcdata11-dynpro = '4001'.
    lst_bdcdata11-dynbegin = 'X'.
    APPEND lst_bdcdata11 TO li_dxbdcdat. " Appending Screen

    CLEAR lst_bdcdata11.
    lst_bdcdata11-fnam = 'VEDA-VBEGDAT'.
    lst_bdcdata11-fval = lv_begdt_10.
    APPEND  lst_bdcdata11 TO li_dxbdcdat. " Appending Contract Start Date

    CLEAR lst_bdcdata11.
    lst_bdcdata11-fnam = 'VEDA-VENDDAT'.
    lst_bdcdata11-fval = lv_enddt_10.
    APPEND  lst_bdcdata11 TO li_dxbdcdat. " Appending Contract End Date

    CLEAR lst_bdcdata11.
    lst_bdcdata11-fnam = 'BDC_OKCODE'.
    lst_bdcdata11-fval = '/EBACK'.
    APPEND lst_bdcdata11 TO li_dxbdcdat.

    CLEAR lst_bdcdata11.
    lst_bdcdata11-program = 'SAPMV45A'.
    lst_bdcdata11-dynpro = '4001'.
    lst_bdcdata11-dynbegin = 'X'.
    APPEND lst_bdcdata11 TO li_dxbdcdat.

    INSERT LINES OF li_dxbdcdat INTO  dxbdcdata INDEX lv_tabx_10.
    FREE:li_dxbdcdat.
  ENDIF.
ENDIF.                 "if fnam = 'SICH'
* EOC by NPOLINA ERPM1431 29/Oct/2019

***---BOC VDPATABALL 04/07/2022 ED2K926646 FTP Orders, if Media change, then also coping the Freight Fwd

DATA:lv_vbeln_i0341       TYPE ihrez,
     lv_matnr_i0341       TYPE matnr,
     lv_matnr_agt         TYPE edi_idtnr,
     lv_ihrez_ag          TYPE edi3413la,
     li_bdcdata_i0341_agt TYPE STANDARD TABLE OF bdcdata. " Batch input: New table field structure

CONSTANTS:lc_idoc_cont_i0341 TYPE char30     VALUE '(SAPLVEDA)IDOC_CONTRL[]',
          lc_e1edp19_i0341   TYPE edilsegtyp VALUE 'E1EDP19',
          lc_e1edka1_i0341   TYPE edilsegtyp VALUE 'E1EDKA1',
          lc_devid1_i0341    TYPE zdevid     VALUE 'I0341',
          lc_sp_i0341        TYPE parvw      VALUE 'SP',
          lc_we_i0341        TYPE parvw      VALUE 'WE',
          lc_ag_i0341        TYPE parvw      VALUE 'AG',
          lc_header_i0341    TYPE posnr      VALUE '000000',
          lc_1_i0341         TYPE tvarv_numb VALUE 1,
          lc_message_fun     TYPE rvari_vnam VALUE 'MSG_FUN'.
FIELD-SYMBOLS:<li_contrl_i0341> TYPE edidc_tt.



*---check the inbound idoc related to India Agent bed on the Message Funcation.
*--once BDC record is completed, adding Frieght forward agent values if the material is different from Quotation
READ TABLE dxbdcdata INTO DATA(lst_bdcdata_i0341_agt) WITH KEY fnam = 'BDC_OKCODE' fval = 'SICH'.
IF sy-subrc = 0.

*--get Control record
  ASSIGN (lc_idoc_cont_i0341) TO <li_contrl_i0341>.
  IF <li_contrl_i0341> IS ASSIGNED.
    CALL METHOD zca_utilities=>get_constants
      EXPORTING
        im_devid     = lc_devid1_i0341           "I0341
        im_param1    = lc_message_fun
      IMPORTING
        et_constants = DATA(li_const_msg).          "Constant Values
    DATA(lv_msg_fun) =   li_const_msg[ param1 = lc_message_fun srno = lc_1_i0341 ]-low. "get the message fun

*---check the inbound idoc related to India Agent bed on the Message Funcation.
    READ TABLE <li_contrl_i0341> ASSIGNING FIELD-SYMBOL(<fs_contrl_i0341>) INDEX 1.
    IF sy-subrc = 0 AND <fs_contrl_i0341>-mesfct = lv_msg_fun .
*---Check the Quoatation number if exist then skip the below logic
      READ TABLE dxbdcdata INTO DATA(lst_dxbdcdata_t1) WITH KEY fnam = 'LV45C-VBELN'.
      IF lst_dxbdcdata_t1-fval IS INITIAL.
        READ TABLE dxbdcdata INTO lst_bdcdata_i0341_agt WITH KEY fnam = 'DV_PARVW' fval = lc_we_i0341.
        IF sy-subrc = 0.
          CLEAR lv_tabix.
          lv_tabix = sy-tabix + 1.
          LOOP AT didoc_data INTO lst_idoc_i0341 WHERE segnam = lc_e1edka1_i0341
                                                    OR segnam = lc_e1edp19_i0341.
            CASE lst_idoc_i0341-segnam.
              WHEN lc_e1edka1_i0341.
                lst_e1edka1_i0341 = lst_idoc_i0341-sdata.
                IF  lst_e1edka1_i0341-parvw = lc_ag_i0341.
                  lv_ihrez_ag = lst_e1edka1_i0341-ihrez.
                ENDIF.
              WHEN lc_e1edp19_i0341.
                lst_e1edp19_i0341 = lst_idoc_i0341-sdata.
                lv_matnr_i0341 = lst_e1edp19_i0341-idtnr.
                lv_matnr_i0341 = |{ lv_matnr_i0341  ALPHA = IN } |.
            ENDCASE.
          ENDLOOP.
          lv_matnr_agt = lv_matnr_i0341.
          CALL FUNCTION 'ZQTC_FIND_QUOTE_I0341'
            EXPORTING
              im_ihrez  = lv_ihrez_ag
              im_matnr  = lv_matnr_agt
              im_contrl = <fs_contrl_i0341>
            IMPORTING
              ex_quote  = lv_vbeln_i0341.

          SELECT SINGLE *
            FROM vbpa
            INTO @DATA(lv_vbpa_sp)
            WHERE vbeln    = @lv_vbeln_i0341
              AND posnr    = @lc_header_i0341
              AND parvw    = @lc_sp_i0341 .
          IF sy-subrc = 0.
            CLEAR lst_bdcdata_i0341.
            lst_bdcdata_i0341-program   = 'SAPMV45A'.
            lst_bdcdata_i0341-dynpro    = '4002'.
            lst_bdcdata_i0341-dynbegin  = abap_true.
            APPEND lst_bdcdata_i0341 TO li_bdcdata_i0341_agt.

            CLEAR lst_bdcdata_i0341.
            lst_bdcdata_i0341-fnam = 'BDC_OKCODE'.
            lst_bdcdata_i0341-fval = '/00'.
            APPEND lst_bdcdata_i0341 TO li_bdcdata_i0341_agt.

            CLEAR lst_bdcdata_i0341.
            lst_bdcdata_i0341-fnam = 'BDC_CURSOR'.
            lst_bdcdata_i0341-fval = 'GVS_TC_DATA-REC-PARTNER(02)'.
            APPEND lst_bdcdata_i0341 TO li_bdcdata_i0341_agt.

            CLEAR lst_bdcdata_i0341.
            lst_bdcdata_i0341-fnam = 'GVS_TC_DATA-REC-PARVW(02)'.
            lst_bdcdata_i0341-fval = lv_vbpa_sp-parvw.
            APPEND lst_bdcdata_i0341 TO li_bdcdata_i0341_agt.

            CLEAR lst_bdcdata_i0341.
            lst_bdcdata_i0341-fnam = 'GVS_TC_DATA-REC-PARTNER(02)'.
            lst_bdcdata_i0341-fval = lv_vbpa_sp-lifnr.
            APPEND lst_bdcdata_i0341 TO li_bdcdata_i0341_agt.
*****---inserting the new coping and selecting BDC lines
            INSERT LINES OF li_bdcdata_i0341_agt INTO dxbdcdata INDEX lv_tabix.
            FREE:li_bdcdata_i0341_agt.
          ENDIF. "SELECT SINGLE * FROM vbpa INTO @DATA(lv_vbpa_sp) WH
        ENDIF. "READ TABLE dxbdcdata INTO lst_bdcdata_i0341_agt WITH KEY fnam = 'DV_PARVW' fval = 'WE'.
      ENDIF. " IF lst_dxbdcdata-fval IS INITIAL.
    ENDIF. " IF sy-subrc = 0 AND <fs_contrl_i0341>-mesfct = lv_msg_fun .
  ENDIF. " if <li_contrl_i0341> IS ASSIGNED.
ENDIF. " READ TABLE dxbdcdata INTO lst_bdcdata_i0341 WITH KEY fnam = 'BDC_OKCODE' fval = 'SICH'.
*---EOC VDPATABALL  04/07/2022 ED2K926646 FTP Orders, if Media change, then also coping the Freight Fwd
