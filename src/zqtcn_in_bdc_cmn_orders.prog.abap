*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU04 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for populating BDC DATA
*
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   10/04/2017
* OBJECT ID: All Orders
* TRANSPORT NUMBER(S):  ED2K905282
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_IN_BDC_CMN_ORDERS
*&---------------------------------------------------------------------*

*** Local types declaration for XVBAK
TYPES: BEGIN OF lty_xvbak. "Kopfdaten
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
TYPES: END OF lty_xvbak.

***<--- Change by SAYNADAS
*****
"Changed OCCURS 50 to OCCURS 0
TYPES: BEGIN OF lty_xvbap. "Position
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
TYPES: END OF lty_xvbap.

*** Local Structure declaration for XVBADR
TYPES: BEGIN OF lty_xvbadr ,     "Partner
         posnr LIKE vbap-posnr,  " Sales Document Item
         parvw LIKE vbpa-parvw,  " Partner Function
         kunnr LIKE rv02p-kunde, " Partner number (KUNNR, LIFNR, or PERNR)
         ablad LIKE vbpa-ablad,  " Unloading Point
         knref LIKE knvp-knref.  " Customer description of partner (plant, storage location)
        INCLUDE STRUCTURE vbadr. " Address work area
TYPES: END OF lty_xvbadr.

*** Local type declaration for item level fields
TYPES: BEGIN OF lty_item,
         posex    TYPE posex,      "Item Number
         mvgr1    TYPE mvgr1,      " Material Group 1
         mvgr3    TYPE mvgr3,      " Material Group 3
         zzpromo  TYPE zpromo,     " Promo Code
         zzartno  TYPE zartno,     " Article Number
         vbegdat  TYPE vbdat_veda, " Contract Start Date
         venddat  TYPE vndat_veda, " Contract End Date
         faksp    TYPE char2,      " Faksp of type CHAR2
         zzsubtyp TYPE zsubtyp,    " Subscription Type
         vbelkue  TYPE vbelk_veda, " Cancellation document number of contract partner
         traty    TYPE traty,      " Means-of-Transport Type
         csd      TYPE zconstart,  " Content Start Date Override
         ced      TYPE zconend,    " Content End Date Override
         lsd      TYPE zlicstar,   " License Start Date Override
         led      TYPE zlicend,    " License End Date Override
       END OF lty_item.

TYPES: BEGIN OF lty_item1,
         posex TYPE posex, " Item Number of the Underlying Purchase Order
         ihrez TYPE ihrez, " Your Reference
       END OF lty_item1.

TYPES: BEGIN OF lty_item_con,
         posex TYPE posex,     " Item Number of the Underlying Purchase Order
         csd   TYPE zconstart, " Content Start Date Override
         ced   TYPE zconend,   " Content End Date Override
*        lsd   TYPE ZLICSTAR,
*        led   TYPE ZLICEND,
       END OF lty_item_con.

TYPES: BEGIN OF lty_item_lis,
         posex TYPE posex,    " Item Number of the Underlying Purchase Order
         lsd   TYPE zlicstar, " License Start Date Override
         led   TYPE zlicend,  " License End Date Override
       END OF lty_item_lis.
***<--- Change by SAYANDAS

TYPES : BEGIN OF lty_item_qtotf,
          posex   TYPE posex,      " Item Number of the Underlying Purchase Order
          vbegdat TYPE vbdat_veda, " Contract start date
          venddat TYPE vndat_veda, " Contract end date
          traty   TYPE traty,      " Means-of-Transport Type
        END OF lty_item_quotf.

TYPES : BEGIN OF lty_item_final,
          posex    TYPE posex,      "Item Number
          zzpromo  TYPE zpromo,     " Promo Code
          zzartno  TYPE zartno,     " Article Number
          vbegdat  TYPE vbdat_veda, " Contract Start Date
          venddat  TYPE vndat_veda, " Contract End Date
          ihrez    TYPE ihrez,      " Your Reference
          csd      TYPE zconstart,  " Content Start Date Override
          ced      TYPE zconend,    " Content End Date Override
          lsd      TYPE zlicstar,   " License Start Date Override
          led      TYPE zlicend,    " License End Date Override
          faksp    TYPE char2,      " Faksp of type CHAR2
          zzsubtyp TYPE zsubtyp,    " Subscription Type
          vbelkue  TYPE vbelk_veda, " Cancellation document number of contract partner
          traty    TYPE traty,      " Means-of-Transport Type
        END OF lty_item_final.
*** Local work area declaration
DATA: lst_bdcdata TYPE bdcdata, " Batch input: New table field structure
      lst_idoc    TYPE edidd,   " Data record (IDoc)
      lst_idoc12  TYPE edidd,   " Data record (IDoc)
      lst_vbadr   TYPE lty_xvbadr,
      lst_xvbak   TYPE lty_xvbak,
      lst_xvbakk  TYPE lty_xvbak,
      lst_e1edk03 TYPE e1edk03. " IDoc: Document header date segment



*** Local Data declaration
DATA: lv_line      TYPE sytabix,    " Row Index of Internal Tables
      lv_stdt      TYPE char10,     " Stdt of type CHAR10
      lv_eddt      TYPE char10,     " Eddt of type CHAR10
      lv_bstdk     TYPE d,          " Bstdk of type Date
      lv_bstdk1    TYPE dats,       " Field of type DATS
      lv_fkdat1    TYPE dats,       " Field of type DATS
      lv_prd1      TYPE dats,       " Field of type DATS
      lv_prd       TYPE d,          " Prd of type Date
      lv_fkdat     TYPE d,          " Fkdat of type Date
      lv_konda1    TYPE konda,      " Price group (customer)
      lv_posnr     TYPE posnr_va,   " Sales Document Item
      lv_tabixqcmn TYPE sytabix,    " Row Index of Internal Tables
      lv_tabixcmn1 TYPE sytabix,    " Row Index of Internal Tables
      lv_fnam      TYPE fnam_____4, " Field name
      lv_fval      TYPE bdc_fval,   " BDC field value
      lv_ihrez     TYPE ihrez,      " Your Reference
      lv_vbegdatc1 TYPE char8,      " Vbegdatc1 of type CHAR8
      lv_test      TYPE sy-datum.   " ABAP System Field: Current Date of Application Server
*** BOC by SAYANDAS--->>>
*** Local Data Declaration
DATA : lst_vbap          TYPE lty_xvbap,
       lst_vbap4         TYPE lty_xvbap,
       li_vbap           TYPE STANDARD TABLE OF lty_xvbap,
       li_item_final     TYPE STANDARD TABLE OF lty_item_final,
       lst_item_final    TYPE lty_item_final,
*** change for quotation
       li_di_doc         TYPE STANDARD TABLE OF edidd, " Data record (IDoc)
       lst_di_doc        TYPE edidd,                   " Data record (IDoc)
*** change for quotation
       lst_vbap10_230    TYPE lty_xvbap,
       lst_bdcdata9_230  TYPE bdcdata,                   " Batch input: New table field structure
       lst_bdcdata10_230 TYPE bdcdata,                   " Batch input: New table field structure
       lst_bdcdata11_230 TYPE bdcdata,                   " Batch input: New table field structure
       lv_tabix1_230     TYPE syindex,                   " Loop Index
       lst_item          TYPE lty_item,
       lst_item22        TYPE lty_item,
       lst_item01        TYPE lty_item,
       lst_item_qf       TYPE lty_item_quotf,
       li_item_qf        TYPE STANDARD TABLE OF lty_item_quotf,
       lst_itemcon       TYPE lty_item_con,
       li_itemcon        TYPE STANDARD TABLE OF lty_item_con,
       lst_itemlis       TYPE lty_item_lis,
       li_itemlis        TYPE STANDARD TABLE OF lty_item_lis,
       lst_item1         TYPE lty_item1,
       li_item1          TYPE STANDARD TABLE OF lty_item1,
       li_bdcdata230     TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
       li_bdcdatacmn     TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
       li_di_doc4        TYPE STANDARD TABLE OF edidd,   " Data record (IDoc)
       lst_di_doc4       TYPE edidd,                     " Data record (IDoc)
       li_di_doc5        TYPE STANDARD TABLE OF edidd,   " Data record (IDoc)
       lst_di_doc5       TYPE edidd,                     " Data record (IDoc)
       li_di_doc6        TYPE STANDARD TABLE OF edidd,   " Data record (IDoc)
       lst_di_doc6       TYPE edidd,                     " Data record (IDoc)
       li_item22         TYPE STANDARD TABLE OF lty_item,
       li_item01         TYPE STANDARD TABLE OF lty_item,
       li_item           TYPE STANDARD TABLE OF lty_item.

DATA: lst_z1qtc_e1edp01_01_8  TYPE z1qtc_e1edp01_01,          " IDOC Segment for STATUS Field in Item Level
      lst_z1qtc_e1edp01_01_qf TYPE z1qtc_e1edp01_01,          " IDOC Segment for STATUS Field in Item Level
      lst_z1qtc_e1edk01_01_8  TYPE z1qtc_e1edk01_01,          " Header General Data Entension
      lst_e1edk36_2           TYPE e1edk36,                   " IDOC: Doc.header payment cards
      lst_e1edp02             TYPE e1edp02,                   " IDoc: Document Item Reference Data
      lst_e1edp03             TYPE e1edp03,                   " IDoc: Document Item Date Segment
      lst_e1edp01             TYPE e1edp01,                   " IDoc: Document Item General Data
      li_e1edp01              TYPE STANDARD TABLE OF e1edp01, " IDoc: Document Item General Data
      lst_e1edka3             TYPE e1edka3,                   " IDoc: Document Header Partner Information Additional Data
      lst_e1edka1_8           TYPE e1edka1,                   " IDoc: Document Header Partner Information
      lst_e1edk02             TYPE e1edk02,                   " IDoc: Document header reference data
      lv_pos2                 TYPE char3,                     " Pos of type CHAR3
      lv_val2                 TYPE char6,                     " Val of type CHAR6
      lv_selkz2               TYPE char19,                    " Selkz of type CHAR19
      lv_fnamm                TYPE char10,                    " Fnamm of type CHAR10
      lv_posexqf              TYPE posnr_va,                  " Sales Document Item
      lv_posex                TYPE posnr_va,                  " Sales Document Item
      lv_posex1               TYPE posnr_va,                  " Sales Document Item
      lv_posex2               TYPE posnr_va,                  " Sales Document Item
      lv_posex3               TYPE posnr_va,                  " Sales Document Item
      lv_mvgr1_8              TYPE mvgr1,                     " Material group 1
      lv_mvgr3_8              TYPE mvgr3,                     " Material group 3
      lv_faksp                TYPE string,
      lv_tabix_cmn            TYPE sytabix,                   " Row Index of Internal Tables
      lv_vbelkue1             TYPE vbelk_veda,                " Cancellation document number of contract partner
      lv_1230                 TYPE char1,                     " 1230 of type CHAR1
      lv_auart1               TYPE auart,                     " Sales Document Type
      lv_vbtyp1               TYPE vbtyp,                     " SD document category
      lv_zzsubtyp1            TYPE zsubtyp,                   " Subscription Type
      lv_tratyi               TYPE traty,                     " Means-of-Transport Type
      lv_tratyiqf             TYPE traty,                     " Means-of-Transport Type
      lv_tratyh               TYPE traty,                     " Means-of-Transport Type
      lv_ihrez_e2             TYPE ihrez_e,                   " Ship-to party character
      lv_artno1               TYPE zartno,                    " Article Number
      lv_zzpromo              TYPE zpromo,                    " Promo code
      lv_promo_8              TYPE zpromo,                    " Promo code
      lv_zlsch                TYPE char1,                     " Zlsch of type CHAR1
      lv_xblnr1               TYPE xblnr_v1,                  " Reference Document Number
      lv_vbegdat2             TYPE d,                         " Vbegdat2 of type Date
      lv_venddat2             TYPE d,                         " Venddat2 of type Date
      lv_aue_flag             TYPE char1 VALUE abap_false,    " Aue_flag of type CHAR1
      lv_eml_flag             TYPE char1 VALUE abap_false,    " Eml_flag of type CHAR1
      lv_upd_flag             TYPE char1 VALUE abap_false,    " Upd_flag of type CHAR1
      lv_quotfcmn             TYPE char1 VALUE abap_false,    " Quotfcmn of type CHAR1
*** for content and license date
      lv_psgnum               TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
      lv_and1                 TYPE dats,       " Field of type DATS
      lv_and                  TYPE d,          " And of type Date
      lv_bnd1                 TYPE dats,       " Field of type DATS
      lv_bnd                  TYPE d,          " Bnd of type Date
      lv_csd                  TYPE d,          " Csd of type Date
      lv_ced                  TYPE d,          " Ced of type Date
      lv_csd1                 TYPE dats,       " Field of type DATS
      lv_ced1                 TYPE dats,       " Field of type DATS
      lv_lsd                  TYPE d,          " Lsd of type Date
      lv_led                  TYPE d,          " Led of type Date
      lv_lsd1                 TYPE dats,       " Field of type DATS
      lv_led1                 TYPE dats,       " Field of type DATS
      lv_zmeng_230            TYPE char13,     " Zmeng of type CHAR13
      lv_kwmeng_230           TYPE char15,     " Kwmeng of type CHAR15
      lv_ccins                TYPE ccins,      " Payment cards: Card type
      lv_aunum                TYPE char10,     " Aunum of type CHAR10
      lv_zuonr                TYPE ordnr_v,    " Assignment number
*** for content and license date
      lv_vbegdat2qf           TYPE d,    " Vbegdat2qf of type Date
      lv_venddat2qf           TYPE d,    " Venddat2qf of type Date
      lv_vbegdat3qf           TYPE dats, " Field of type DATS
      lv_venddat3qf           TYPE dats, " Field of type DATS
      lv_vbegdat3             TYPE dats, " Field of type DATS
      lv_venddat3             TYPE dats. " Field of type DATS

*** Local Field Symbols
FIELD-SYMBOLS: <lst_bdcdata_cmn> TYPE bdcdata. " Batch input: New table field structure
***<<<--- EOC by SAYANDAS

***Local Constant Declaration
CONSTANTS: lc_e1edk03_1          TYPE edilsegtyp VALUE 'E1EDK03',          " E1edk03_1 of type CHAR7
           lc_z1qtc_e1edp01_01_8 TYPE edilsegtyp VALUE 'Z1QTC_E1EDP01_01', " Z1qtc_e1edp01_01_8 of type CHAR16
           lc_z1qtc_e1edk01_01_8 TYPE edilsegtyp VALUE 'Z1QTC_E1EDK01_01', " Z1qtc_e1edk01_01_8 of type CHAR16
           lc_e1edp02_8          TYPE edilsegtyp VALUE 'E1EDP02',          " E1edp02_8 of type CHAR7
           lc_e1edp03_8          TYPE edilsegtyp VALUE 'E1EDP03',          " E1edp03_8 of type CHAR7
           lc_e1edka1_8          TYPE edilsegtyp VALUE 'E1EDKA1',          " E1edka1_8 of type CHAR7
           lc_e1edk36            TYPE edilsegtyp VALUE 'E1EDK36',          " Segment type
           lc_e1edka3            TYPE edilsegtyp VALUE 'E1EDKA3',          " Segment type
           lc_e1edk02            TYPE edilsegtyp VALUE 'E1EDK02',          " Segment type
           lc_e1edp01            TYPE edilsegtyp VALUE 'E1EDP01',          " Segment type
           lc_we_8               TYPE parvw VALUE 'WE',                    " Partner Function
           lc_g1                 TYPE vbtyp VALUE 'G',                     " SD document category
           lc_001_8              TYPE edi_qualfr VALUE '001',              " IDOC qualifier reference document
           lc_011_8              TYPE edi_qualfr VALUE '011',              " IDOC qualifier reference document
           lc_005                TYPE edi_qualp VALUE '005',               " IDOC Partner identification (e.g.Dun&Bradstreet number)
           lc_004                TYPE edi_qualfr VALUE '004',              " IDOC qualifier reference document
           lc_csd                TYPE edi_iddat VALUE 'CSD',               " Qualifier for IDOC date segment
           lc_ced                TYPE edi_iddat VALUE 'CED',               " Qualifier for IDOC date segment
           lc_lsd                TYPE edi_iddat VALUE 'LSD',               " Qualifier for IDOC date segment
           lc_led                TYPE edi_iddat VALUE 'LED',               " Qualifier for IDOC date segment
           lc_and                TYPE edi_iddat  VALUE 'AND',              " Qualifier for IDOC date segment
           lc_bnd                TYPE edi_iddat  VALUE 'BND',              " Qualifier for IDOC date segment
           lc_0222               TYPE edi_iddat VALUE '022',               " Qualifier for IDOC date segment
           lc_prd                TYPE edi_iddat VALUE 'PRD',               " Qualifier for IDOC date segment
           lc_016                TYPE edi_iddat VALUE '016',               " Qualifier for IDOC date segment
           lc_019                TYPE edi_iddat VALUE '019',               " Qualifier for IDOC date segment
           lc_020                TYPE edi_iddat VALUE '020'.               " Qualifier for IDOC date segment


*** Changing BDCDATA table to change contract start date and contract end date


DESCRIBE TABLE dxbdcdata LINES lv_line.
READ TABLE didoc_data INTO lst_idoc INDEX 1.
*** Reading BDCDATA table into a work area
READ TABLE dxbdcdata INTO lst_bdcdata INDEX lv_line.

* BOC for BOM Material *
*** Collected data from Z1QTC_E1EDP01_01 segment
li_di_doc4[] = didoc_data[].
DELETE li_di_doc4 WHERE segnam NE lc_z1qtc_e1edp01_01_8.
LOOP AT li_di_doc4 INTO lst_di_doc4.
  CLEAR: lst_z1qtc_e1edp01_01_8,
          lv_vbegdat3,lv_venddat3,
         lv_vbegdat2,lv_venddat2.
  lst_z1qtc_e1edp01_01_8 = lst_di_doc4-sdata.
  lv_posex = lst_z1qtc_e1edp01_01_8-vposn.
  lv_zzpromo          = lst_z1qtc_e1edp01_01_8-zzpromo.
  lv_artno1           = lst_z1qtc_e1edp01_01_8-zzartno.
  lv_zzsubtyp1        = lst_z1qtc_e1edp01_01_8-zzsubtyp.
  lv_faksp            = lst_z1qtc_e1edp01_01_8-faksp.
  lv_tratyi           = lst_z1qtc_e1edp01_01_8-traty.
  lv_vbelkue1         = lst_z1qtc_e1edp01_01_8-vbelkue.
  lv_vbegdat3         = lst_z1qtc_e1edp01_01_8-vbegdat. " Contract Strat Date
  lv_venddat3         = lst_z1qtc_e1edp01_01_8-venddat. " Contract End Date
  WRITE lv_vbegdat3 TO lv_vbegdat2.
  WRITE lv_venddat3 TO lv_venddat2.

**** Change for Content and License Date
  lv_csd1 = lst_z1qtc_e1edp01_01_8-zzcontent_start_d.
  lv_ced1 = lst_z1qtc_e1edp01_01_8-zzcontent_end_d.
  lv_lsd1 = lst_z1qtc_e1edp01_01_8-zzlicense_start_d.
  lv_led1 = lst_z1qtc_e1edp01_01_8-zzlicense_end_d.

  WRITE lv_csd1 TO lv_csd.
  WRITE lv_ced1 TO lv_ced.
  WRITE lv_lsd1 TO lv_lsd.
  WRITE lv_led1 TO lv_led.
**** Chnage for Content and License Date

  IF lv_posex IS NOT INITIAL.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_posex
      IMPORTING
        output = lv_posex.

    lst_item01-posex = lv_posex.
    lst_item01-vbegdat = lv_vbegdat2.
    lst_item01-venddat = lv_venddat2.
    lst_item01-zzpromo = lv_zzpromo.
    lst_item01-zzartno = lv_artno1.
    lst_item01-faksp   = lv_faksp.
    lst_item01-zzsubtyp = lv_zzsubtyp1.
    lst_item01-vbelkue  = lv_vbelkue1.
    lst_item01-traty    = lv_tratyi.
    lst_item01-csd      = lv_csd.
    lst_item01-ced      = lv_ced.
    lst_item01-lsd      = lv_lsd.
    lst_item01-led      = lv_led.
    APPEND lst_item01 TO li_item01.
    CLEAR: lst_item01, lv_posex,
           lv_vbegdat2, lv_venddat2.
  ENDIF. " IF lv_posex IS NOT INITIAL
ENDLOOP. " LOOP AT li_di_doc4 INTO lst_di_doc4
*** Collecting data from P01 segment

*** Collecting data from E1EDP02 segment
li_di_doc5[] = didoc_data[].
DELETE li_di_doc5 WHERE segnam NE lc_e1edp02_8.
LOOP AT li_di_doc5 INTO lst_di_doc5.
  CLEAR : lst_e1edp02.
  lst_e1edp02 = lst_di_doc5-sdata.
  IF lst_e1edp02-qualf = lc_001_8.
    lv_psgnum = lst_di_doc5-psgnum.
    READ TABLE didoc_data INTO lst_idoc12 WITH KEY segnum = lv_psgnum.
    IF sy-subrc = 0.
      lst_e1edp01 = lst_idoc12-sdata.
      lv_posex1 = lst_e1edp01-posex.
      lv_ihrez = lst_e1edp02-ihrez.
    ENDIF. " IF sy-subrc = 0
    CLEAR: lst_e1edp01, lst_idoc12, lv_psgnum.
  ENDIF. " IF lst_e1edp02-qualf = lc_001_8
*** code for ihrez
  IF lv_posex1 IS NOT INITIAL.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_posex1
      IMPORTING
        output = lv_posex1.

    lst_item1-posex = lv_posex1.
    lst_item1-ihrez = lv_ihrez.
    APPEND lst_item1 TO li_item1.
    CLEAR: lst_item1,
           lv_posex1,
           lv_ihrez.
  ENDIF. " IF lv_posex1 IS NOT INITIAL
ENDLOOP. " LOOP AT li_di_doc5 INTO lst_di_doc5
*** Collected data from p02 segment

**** Collected data from  E1EDP03 segment
*li_di_doc6[] = didoc_data[].
*DELETE li_di_doc6 WHERE segnam NE lc_e1edp03_8.
*LOOP AT li_di_doc6 INTO lst_di_doc6.
*  CLEAR : lst_e1edp03.
*  lst_e1edp03 = lst_di_doc6-sdata.
*  IF lst_e1edp03-iddat = lc_csd.
*    lv_psgnum = lst_idoc-psgnum.
*    READ TABLE didoc_data INTO lst_idoc12 WITH KEY segnum = lv_psgnum.
*    IF sy-subrc = 0.
*      lst_e1edp01 = lst_idoc12-sdata.
*      lv_posex2 = lst_e1edp01-posex.
*    ENDIF. " IF sy-subrc = 0
*    lv_csd1 = lst_e1edp03-datum.
*    WRITE lv_csd1   TO lv_csd.
*  ENDIF. " IF lst_e1edp03-iddat = lc_csd
*
*  IF lst_e1edp03-iddat = lc_ced.
*    lv_psgnum = lst_idoc-psgnum.
*    READ TABLE didoc_data INTO lst_idoc12 WITH KEY segnum = lv_psgnum.
*    IF sy-subrc = 0.
*      lst_e1edp01 = lst_idoc12-sdata.
*      lv_posex2 = lst_e1edp01-posex.
*    ENDIF. " IF sy-subrc = 0
*    lv_ced1 = lst_e1edp03-datum.
*    WRITE lv_ced1 TO lv_ced.
*  ENDIF. " IF lst_e1edp03-iddat = lc_ced
*
*  IF lst_e1edp03-iddat = lc_lsd.
*    lv_psgnum = lst_idoc-psgnum.
*    READ TABLE didoc_data INTO lst_idoc12 WITH KEY segnum = lv_psgnum.
*    IF sy-subrc = 0.
*      lst_e1edp01 = lst_idoc12-sdata.
*      lv_posex3 = lst_e1edp01-posex.
*    ENDIF. " IF sy-subrc = 0
*    lv_lsd1 = lst_e1edp03-datum.
*    WRITE lv_lsd1 TO lv_lsd.
*  ENDIF. " IF lst_e1edp03-iddat = lc_lsd
*
*  IF lst_e1edp03-iddat = lc_led.
*    lv_psgnum = lst_idoc-psgnum.
*    READ TABLE didoc_data INTO lst_idoc12 WITH  KEY segnum = lv_psgnum.
*    IF sy-subrc = 0.
*      lst_e1edp01 = lst_idoc12-sdata.
*      lv_posex3 = lst_e1edp01-posex.
*    ENDIF. " IF sy-subrc = 0
*    lv_led1 = lst_e1edp03-datum.
*    WRITE lv_led1 TO lv_led.
*  ENDIF. " IF lst_e1edp03-iddat = lc_led
*
***** code for content and license date
*  IF lv_posex2 IS NOT INITIAL.
*    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*      EXPORTING
*        input  = lv_posex2
*      IMPORTING
*        output = lv_posex2.
*
*    IF lv_csd IS NOT INITIAL.
*
*      lst_itemcon-posex = lv_posex2.
*      lst_itemcon-csd = lv_csd.
*      APPEND lst_itemcon TO li_itemcon.
*      CLEAR: lst_itemcon,lv_posex2,
*             lv_csd.
*    ENDIF. " IF lv_csd IS NOT INITIAL
*
*    IF lv_ced IS NOT INITIAL.
*      lst_itemcon-posex = lv_posex2.
*      lst_itemcon-ced = lv_ced.
*      MODIFY li_itemcon FROM lst_itemcon TRANSPORTING ced WHERE posex = lv_posex2.
*      CLEAR: lv_ced.
*    ENDIF. " IF lv_ced IS NOT INITIAL
*
*  ENDIF. " IF lv_posex2 IS NOT INITIAL
*
*  IF lv_posex3 IS NOT INITIAL.
*    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*      EXPORTING
*        input  = lv_posex3
*      IMPORTING
*        output = lv_posex3.
*    IF lv_lsd IS NOT INITIAL.
*
*      lst_itemlis-posex = lv_posex3.
*      lst_itemlis-lsd = lv_lsd.
*      APPEND lst_itemlis TO li_itemlis.
*      CLEAR: lst_itemlis, lv_posex3,
*             lv_lsd.
*    ENDIF. " IF lv_lsd IS NOT INITIAL
*
*    IF lv_led IS NOT INITIAL.
*      lst_itemlis-posex = lv_posex3.
*      lst_itemlis-led = lv_led.
*      MODIFY li_itemlis FROM lst_itemlis TRANSPORTING led WHERE posex = lv_posex3.
*      CLEAR: lv_led.
*    ENDIF. " IF lv_led IS NOT INITIAL
*  ENDIF. " IF lv_posex3 IS NOT INITIAL
***** code for content and license date
*ENDLOOP. " LOOP AT li_di_doc6 INTO lst_di_doc6
**** from P03 segment

*** Code to merge all item segment
LOOP AT li_item01 INTO lst_item01.
  lst_item_final-posex = lst_item01-posex.
  lst_item_final-vbegdat = lst_item01-vbegdat.
  lst_item_final-venddat = lst_item01-venddat.
  lst_item_final-zzpromo = lst_item01-zzpromo.
  lst_item_final-zzartno = lst_item01-zzartno.
  lst_item_final-faksp   = lst_item01-faksp.
  lst_item_final-zzsubtyp = lst_item01-zzsubtyp.
  lst_item_final-vbelkue = lst_item01-vbelkue.
  lst_item_final-traty  = lst_item01-traty.
  lst_item_final-csd    = lst_item01-csd.
  lst_item_final-ced    = lst_item01-ced.
  lst_item_final-lsd    = lst_item01-lsd.
  lst_item_final-led    = lst_item01-led.
  READ TABLE li_item1 INTO lst_item1 WITH KEY posex = lst_item01-posex.
  IF sy-subrc = 0.
    lst_item_final-ihrez = lst_item1-ihrez.
  ENDIF. " IF sy-subrc = 0

*  READ TABLE li_itemcon INTO lst_itemcon WITH KEY posex = lst_item01-posex.
*  IF sy-subrc = 0.
*    lst_item_final-csd = lst_itemcon-csd.
*    lst_item_final-ced = lst_itemcon-ced.
*  ENDIF. " IF sy-subrc = 0
*
*  READ TABLE li_itemlis INTO lst_itemlis WITH KEY posex = lst_item01-posex.
*  IF sy-subrc = 0.
*    lst_item_final-lsd = lst_itemlis-lsd.
*    lst_item_final-led = lst_itemlis-led.
*  ENDIF. " IF sy-subrc = 0

  APPEND lst_item_final TO li_item_final.
  CLEAR lst_item_final.
ENDLOOP. " LOOP AT li_item01 INTO lst_item01
*** Code to merge all item segment


SORT li_item_final BY posex.
DELETE ADJACENT DUPLICATES FROM li_item_final.

lst_vbap4 = dxvbap.

IF lst_vbap4-kdmat IS INITIAL.
  lv_fnamm = 'VBAP-POSEX'.
ELSE. " ELSE -> IF lst_vbap4-kdmat IS INITIAL
  lv_fnamm = 'VBAP-KDMAT'.
ENDIF. " IF lst_vbap4-kdmat IS INITIAL

IF lst_bdcdata-fnam+0(10) = lv_fnamm.
  lv_pos2 = lst_bdcdata-fnam+10(3).
*    lv_val2 = lst_bdcdata-fval.
*    BREAK-POINT.
  READ TABLE li_item_final INTO lst_item_final WITH KEY posex = lst_vbap4-posex.
  IF sy-subrc = 0.

    IF lst_item_final IS NOT INITIAL.

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata. " Appending Screen

      lv_vbegdatc1  = lst_item_final-vbegdat.

*** CONTRACT DATA TAB ----------------->>>>>>
      IF lv_vbegdatc1 IS NOT INITIAL OR lst_item_final-vbelkue IS NOT INITIAL.

        CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos2 INTO lv_selkz2.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = lv_selkz2.
        lst_bdcdata-fval = 'X'.
        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE


        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'PVER'.
        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE


        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPLV45W'.
        lst_bdcdata-dynpro = '4001'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO dxbdcdata. " Appending Screen
*** Contract Start Date and contract End Date
        IF lv_vbegdatc1 IS NOT INITIAL.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'VEDA-VBEGDAT'.
          lst_bdcdata-fval = lst_item_final-vbegdat.
          APPEND  lst_bdcdata TO dxbdcdata. " Appending Contract Start Date

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'VEDA-VENDDAT'.
          lst_bdcdata-fval = lst_item_final-venddat.
          APPEND  lst_bdcdata TO dxbdcdata. " Appending Contract End Date

        ENDIF. " IF lv_vbegdatc1 IS NOT INITIAL
*** Contract Start Date and contract End Date

*** Cancellation Document Number
        IF lst_item_final-vbelkue IS NOT INITIAL.

          CLEAR: lst_bdcdata.
          lst_bdcdata-fnam = 'VEDA-VBELKUE'.
          lst_bdcdata-fval = lst_item_final-vbelkue.
          APPEND lst_bdcdata TO dxbdcdata.

        ENDIF. " IF lst_item_final-vbelkue IS NOT INITIAL
*** Cancellation Document Number
        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '/EBACK'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4001'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO dxbdcdata.
      ENDIF. " IF lv_vbegdatc1 IS NOT INITIAL OR lst_item_final-vbelkue IS NOT INITIAL
**** <<<<-------------  CONTRACT DATA TAB

**** ADDITIONAL DATA B TAB ------------>>>>>>
      IF lst_item_final-zzpromo IS NOT INITIAL OR lst_item_final-zzartno IS NOT INITIAL
      OR lst_item_final-csd IS NOT INITIAL OR lst_item_final-lsd IS NOT INITIAL
      OR lst_item_final-zzsubtyp IS NOT INITIAL.


        CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos2 INTO lv_selkz2.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = lv_selkz2.
        lst_bdcdata-fval = 'X'.
        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

        CLEAR: lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'PZKU'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4003'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO dxbdcdata.

*** ZZPROMO
        IF lst_item_final-zzpromo IS NOT INITIAL.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'BDC_CURSOR'.
          lst_bdcdata-fval = 'VBAP-ZZPROMO'.
          APPEND lst_bdcdata TO dxbdcdata.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'VBAP-ZZPROMO'.
          lst_bdcdata-fval = lst_item_final-zzpromo.
          APPEND lst_bdcdata TO dxbdcdata.

        ENDIF. " IF lst_item_final-zzpromo IS NOT INITIAL
*** ZZPROMO
*** ZZARTNO
        IF lst_item_final-zzartno IS NOT INITIAL.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'BDC_CURSOR'.
          lst_bdcdata-fval = 'VBAP-ZZARTNO'.
          APPEND lst_bdcdata TO dxbdcdata.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'VBAP-ZZARTNO'.
          lst_bdcdata-fval = lst_item_final-zzartno.
          APPEND lst_bdcdata TO dxbdcdata.

        ENDIF. " IF lst_item_final-zzartno IS NOT INITIAL
*** ZZARTNO
*** ZZCONSTART and ZZCONEND
        IF lst_item_final-csd IS NOT INITIAL.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'BDC_CURSOR'.
          lst_bdcdata-fval = 'VBAP-ZZCONSTART'.
          APPEND lst_bdcdata TO dxbdcdata.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'VBAP-ZZCONSTART'.
          lst_bdcdata-fval = lst_item_final-csd.
          APPEND lst_bdcdata TO dxbdcdata.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'BDC_CURSOR'.
          lst_bdcdata-fval = 'VBAP-ZZCONEND'.
          APPEND lst_bdcdata TO dxbdcdata.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'VBAP-ZZCONEND'.
          lst_bdcdata-fval = lst_item_final-ced.
          APPEND lst_bdcdata TO dxbdcdata.

        ENDIF. " IF lst_item_final-csd IS NOT INITIAL
*** ZZCONSTART and ZZCONEND
*** ZZLICSTAR and ZZLICEND
        IF lst_item_final-lsd IS NOT INITIAL.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'BDC_CURSOR'.
          lst_bdcdata-fval = 'VBAP-ZZLICSTART'.
          APPEND lst_bdcdata TO dxbdcdata.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'VBAP-ZZLICSTART'.
          lst_bdcdata-fval = lst_item_final-lsd.
          APPEND lst_bdcdata TO dxbdcdata.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'BDC_CURSOR'.
          lst_bdcdata-fval = 'VBAP-ZZLICEND'.
          APPEND lst_bdcdata TO dxbdcdata.

          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'VBAP-ZZLICEND'.
          lst_bdcdata-fval = lst_item_final-led.
          APPEND lst_bdcdata TO dxbdcdata.
        ENDIF. " IF lst_item_final-lsd IS NOT INITIAL
*** ZZLICSTAR and ZZLICEND

**** ZZSUBTYP
        IF lst_item_final-zzsubtyp IS NOT INITIAL.

          CLEAR: lst_bdcdata.
          lst_bdcdata-fnam = 'VBAP-ZZSUBTYP'.
          lst_bdcdata-fval = lst_item_final-zzsubtyp.
          APPEND lst_bdcdata TO dxbdcdata.

        ENDIF. " IF lst_item_final-zzsubtyp IS NOT INITIAL
**** ZZSUBTYP

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '/EBACK'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4001'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO dxbdcdata.
      ENDIF. " IF lst_item_final-zzpromo IS NOT INITIAL OR lst_item_final-zzartno IS NOT INITIAL

*****<<<<---------- ADDITIONAL DATA B TAB

*      IF lst_item_final-zzartno IS NOT INITIAL.
*
*        CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos2 INTO lv_selkz2.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = lv_selkz2.
*        lst_bdcdata-fval = 'X'.
*        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE
*
*        CLEAR: lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_OKCODE'.
*        lst_bdcdata-fval = 'PZKU'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-program = 'SAPMV45A'.
*        lst_bdcdata-dynpro = '4003'.
*        lst_bdcdata-dynbegin = 'X'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_CURSOR'.
*        lst_bdcdata-fval = 'VBAP-ZZARTNO'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = 'VBAP-ZZARTNO'.
*        lst_bdcdata-fval = lst_item_final-zzartno.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_OKCODE'.
*        lst_bdcdata-fval = '/EBACK'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-program = 'SAPMV45A'.
*        lst_bdcdata-dynpro = '4001'.
*        lst_bdcdata-dynbegin = 'X'.
*        APPEND lst_bdcdata TO dxbdcdata.
*      ENDIF. " IF lst_item_final-zzartno IS NOT INITIAL

**** ORDER DATA TAB ------------------->>>>>>
      IF lst_item_final-ihrez IS NOT INITIAL.

        CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos2 INTO lv_selkz2.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = lv_selkz2.
        lst_bdcdata-fval = 'X'.
        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

        CLEAR: lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'PBES'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro  =  '4003'.
        lst_bdcdata-dynbegin   = 'X'.
        APPEND lst_bdcdata TO dxbdcdata.
*** SOLD TO YOUR REFERENCE
        CLEAR: lst_bdcdata.
        lst_bdcdata-fnam = 'VBKD-IHREZ'.
        lst_bdcdata-fval = lst_item_final-ihrez.
        APPEND lst_bdcdata TO dxbdcdata.


        CLEAR: lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '/EBACK'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro  =  '4001'.
        lst_bdcdata-dynbegin   = 'X'.
        APPEND lst_bdcdata TO dxbdcdata.
      ENDIF. " IF lst_item_final-ihrez IS NOT INITIAL
******<<<<---------------- ORDER DATA TAB

*      IF lst_item_final-csd IS NOT INITIAL.
*        CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos2 INTO lv_selkz2.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = lv_selkz2.
*        lst_bdcdata-fval = 'X'.
*        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE
*
*        CLEAR: lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_OKCODE'.
*        lst_bdcdata-fval = 'PZKU'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-program = 'SAPMV45A'.
*        lst_bdcdata-dynpro = '4003'.
*        lst_bdcdata-dynbegin = 'X'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_CURSOR'.
*        lst_bdcdata-fval = 'VBAP-ZZCONSTART'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = 'VBAP-ZZCONSTART'.
*        lst_bdcdata-fval = lst_item_final-csd.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_CURSOR'.
*        lst_bdcdata-fval = 'VBAP-ZZCONEND'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = 'VBAP-ZZCONEND'.
*        lst_bdcdata-fval = lst_item_final-ced.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_OKCODE'.
*        lst_bdcdata-fval = '/EBACK'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-program = 'SAPMV45A'.
*        lst_bdcdata-dynpro = '4001'.
*        lst_bdcdata-dynbegin = 'X'.
*        APPEND lst_bdcdata TO dxbdcdata.
*      ENDIF. " IF lst_item_final-csd IS NOT INITIAL

*      IF lst_item_final-lsd IS NOT INITIAL.
*        CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos2 INTO lv_selkz2.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = lv_selkz2.
*        lst_bdcdata-fval = 'X'.
*        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE
*
*        CLEAR: lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_OKCODE'.
*        lst_bdcdata-fval = 'PZKU'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-program = 'SAPMV45A'.
*        lst_bdcdata-dynpro = '4003'.
*        lst_bdcdata-dynbegin = 'X'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_CURSOR'.
*        lst_bdcdata-fval = 'VBAP-ZZLICSTART'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = 'VBAP-ZZLICSTART'.
*        lst_bdcdata-fval = lst_item_final-lsd.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_CURSOR'.
*        lst_bdcdata-fval = 'VBAP-ZZLICEND'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = 'VBAP-ZZLICEND'.
*        lst_bdcdata-fval = lst_item_final-led.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_OKCODE'.
*        lst_bdcdata-fval = '/EBACK'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-program = 'SAPMV45A'.
*        lst_bdcdata-dynpro = '4001'.
*        lst_bdcdata-dynbegin = 'X'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*      ENDIF. " IF lst_item_final-lsd IS NOT INITIAL
***** <<<----------- Billing Document TAB
      IF lst_item_final-faksp IS NOT INITIAL.

        CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos2 INTO lv_selkz2.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = lv_selkz2.
        lst_bdcdata-fval = 'X'.
        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'PDE3'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro  =  '4003'.
        lst_bdcdata-dynbegin   = 'X'.
        APPEND lst_bdcdata TO dxbdcdata.

*** Billing Block

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'VBAP-FAKSP'.
        lst_bdcdata-fval = lst_item_final-faksp.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '/EBACK'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4001'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO dxbdcdata.

      ENDIF. " IF lst_item_final-faksp IS NOT INITIAL
******<<<<----------------- Billing Document TAB

*      IF lst_item_final-zzsubtyp IS NOT INITIAL.
*
*        CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos2 INTO lv_selkz2.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = lv_selkz2.
*        lst_bdcdata-fval = 'X'.
*        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE
*
*        CLEAR: lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_OKCODE'.
*        lst_bdcdata-fval = 'PZKU'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR:  lst_bdcdata.
*        lst_bdcdata-program = 'SAPMV45A'.
*        lst_bdcdata-dynpro  =  '4003'.
*        lst_bdcdata-dynbegin   = 'X'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR: lst_bdcdata.
*        lst_bdcdata-fnam = 'VBAP-ZZSUBTYP'.
*        lst_bdcdata-fval = lst_item_final-zzsubtyp.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*
*        CLEAR: lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_OKCODE'.
*        lst_bdcdata-fval = '/EBACK'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*        CLEAR:  lst_bdcdata.
*        lst_bdcdata-program = 'SAPMV45A'.
*        lst_bdcdata-dynpro  =  '4001'.
*        lst_bdcdata-dynbegin   = 'X'.
*        APPEND lst_bdcdata TO dxbdcdata.
*      ENDIF. " IF lst_item_final-zzsubtyp IS NOT INITIAL

*      IF lst_item_final-vbelkue IS NOT INITIAL.
*
*        CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos2 INTO lv_selkz2.
*
*        CLEAR lst_bdcdata.
*        lst_bdcdata-fnam = lv_selkz2.
*        lst_bdcdata-fval = 'X'.
*        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE
*
*        CLEAR: lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_OKCODE'.
*        lst_bdcdata-fval = 'PVER'.
*        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE
*
*        CLEAR:  lst_bdcdata.
*        lst_bdcdata-program = 'SAPLV45W'.
*        lst_bdcdata-dynpro  =  '4001'.
*        lst_bdcdata-dynbegin   = 'X'.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*
*        CLEAR: lst_bdcdata.
*        lst_bdcdata-fnam = 'VEDA-VBELKUE'.
*        lst_bdcdata-fval = lst_item_final-vbelkue.
*        APPEND lst_bdcdata TO dxbdcdata.
*
*
*        CLEAR: lst_bdcdata.
*        lst_bdcdata-fnam = 'BDC_OKCODE'.
*        lst_bdcdata-fval = '=S\BACK'.
*        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE
*
*        CLEAR:  lst_bdcdata.
*        lst_bdcdata-program = 'SAPMV45A'.
*        lst_bdcdata-dynpro  =  '4001'.
*        lst_bdcdata-dynbegin   = 'X'.
*        APPEND lst_bdcdata TO dxbdcdata.
*      ENDIF. " IF lst_item_final-vbelkue IS NOT INITIAL

****  Shipping TAB -------------->>>>>>>>>>>>>>
      IF lst_item_final-traty IS NOT INITIAL.

        CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos INTO lv_selkz.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = lv_selkz.
        lst_bdcdata-fval = 'X'.
        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'PDE2'.
        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4003'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO dxbdcdata. " appending Screen

**** Means of Transporation Type

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_CURSOR'.
        lst_bdcdata-fval = 'VBKD-TRATY'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBKD-TRATY'.
        lst_bdcdata-fval = lst_item_final-traty.
        APPEND lst_bdcdata TO dxbdcdata. " Appending TRATY

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '/EBACK'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4001'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO dxbdcdata.
      ENDIF. " IF lst_item_final-traty IS NOT INITIAL
*****<<<<----------- Shipping TAB

    ENDIF. " IF lst_item_final IS NOT INITIAL
  ENDIF. " IF sy-subrc = 0
ENDIF. " IF lst_bdcdata-fnam+0(10) = lv_fnamm

* EOC for BOM Material*
*** Reading BDCDATA table into a work area
READ TABLE dxbdcdata INTO lst_bdcdata INDEX lv_line.
IF sy-subrc IS INITIAL.
*    IF lst_bdcdata-fnam = 'RV45A-DOCNUM'
*      AND lst_bdcdata-fval = lst_idoc-docnum.
*  IF lst_bdcdata-fnam = 'BDC_OKCODE'
*  AND lst_bdcdata-fval = 'SICH'.
  IF lst_bdcdata-fnam = 'KUAGV-KUNNR' OR lst_bdcdata-fnam = 'KUWEV-KUNNR'
    OR lst_bdcdata-fnam = 'VBKD-BSTKD' OR lst_bdcdata-fnam = 'VBKD-BSTDK'
    OR lst_bdcdata-fnam = 'RV45A-KETDAT' OR lst_bdcdata-fnam = 'RV45A-DWERK'
    OR lst_bdcdata-fnam = 'VBAK-VBELN'.

    CLEAR lst_idoc.
*** Loop at IDOC DATA if segment is E1EDK03 Date segment
*    LOOP AT didoc_data INTO lst_idoc WHERE segnam =  lc_e1edk03_1.
    LOOP AT didoc_data INTO lst_idoc.
      CASE lst_idoc-segnam.
        WHEN lc_e1edk03_1.

*** Putting the idoc data in a local work area

          lst_e1edk03 = lst_idoc-sdata.

          IF lst_e1edk03-iddat = lc_019.
***     Qualifier for IDOC date segment is '019' then
***     we are putting IDOC: Date in local variable.

            WRITE lst_e1edk03-datum TO lv_test.
            WRITE lv_test TO lv_stdt. " lv_stdt is used for contract start date
*        WRITE '01/08/2016' TO lv_stdt.

          ELSEIF lst_e1edk03-iddat = lc_020.
***     Qualifier for IDOC date segment is '020' then
***     we are putting IDOC: Date in local variable.

            CLEAR lv_test.
            WRITE lst_e1edk03-datum TO lv_test.
            WRITE lv_test TO lv_eddt. " lv_eddt is used for contract end date

          ELSEIF lst_e1edk03-iddat = lc_0222.
            lv_bstdk1 = lst_e1edk03-datum.
            WRITE lv_bstdk1 TO lv_bstdk.

          ELSEIF lst_e1edk03-iddat = lc_016.

            lv_fkdat1 = lst_e1edk03-datum.
            WRITE lv_fkdat1 TO lv_fkdat.

          ELSEIF lst_e1edk03-iddat = lc_prd.

            lv_prd1 = lst_e1edk03-datum.
            WRITE lv_prd1  TO lv_prd.

          ELSEIF lst_e1edk03-iddat = lc_and.

            lv_and1 = lst_e1edk03-datum.
            WRITE lv_and1 TO lv_and.

          ELSEIF lst_e1edk03-iddat = lc_bnd.

            lv_bnd1 = lst_e1edk03-datum.
            WRITE lv_bnd1 TO lv_bnd.

          ENDIF. " IF lst_e1edk03-iddat = lc_019
          CLEAR: lst_e1edk03, lst_idoc. " Clearing local work area
***<<<
        WHEN lc_z1qtc_e1edp01_01_8.
          CLEAR: lst_z1qtc_e1edp01_01_8, lv_artno1,
                 lv_mvgr1_8, lv_mvgr3_8,lv_zzpromo.

          lst_z1qtc_e1edp01_01_8 = lst_idoc-sdata.
          lv_posex = lst_z1qtc_e1edp01_01_8-vposn.
          lv_mvgr1_8 = lst_z1qtc_e1edp01_01_8-mvgr1.
          lv_mvgr3_8 = lst_z1qtc_e1edp01_01_8-mvgr3.
          lv_zzpromo = lst_z1qtc_e1edp01_01_8-zzpromo.
          lv_artno1  = lst_z1qtc_e1edp01_01_8-zzartno.
          lv_vbegdat3  = lst_z1qtc_e1edp01_01_8-vbegdat.
          lv_venddat3  = lst_z1qtc_e1edp01_01_8-venddat.
          WRITE lv_vbegdat3 TO lv_vbegdat2.
          WRITE lv_venddat3 TO lv_venddat2.

        WHEN lc_e1edka1_8.
          lst_e1edka1_8 = lst_idoc-sdata.
          IF lst_e1edka1_8-parvw = lc_we_8.
            lv_ihrez_e2 = lst_e1edka1_8-ihrez.
          ENDIF. " IF lst_e1edka1_8-parvw = lc_we_8
********* code for IHREZ
        WHEN lc_e1edp02_8.
          CLEAR: lst_e1edp02.
          lst_e1edp02 = lst_idoc-sdata.
          IF lst_e1edp02-qualf = '001'.
*            lv_posex1 = lst_e1edp02-zeile.
            lv_psgnum = lst_idoc-psgnum.
            READ TABLE didoc_data INTO lst_idoc12 WITH KEY segnum = lv_psgnum.
            IF sy-subrc = 0.
              lst_e1edp01 = lst_idoc12-sdata.
              lv_posex1 = lst_e1edp01-posex.
              lv_ihrez = lst_e1edp02-ihrez.
            ENDIF. " IF sy-subrc = 0
            CLEAR: lst_e1edp01, lst_idoc12,lv_psgnum.
          ENDIF. " IF lst_e1edp02-qualf = '001'
******   code for IHREZ
***** Code for content start date and end date
        WHEN lc_e1edp03_8.
          CLEAR: lst_e1edp03.

          lst_e1edp03 = lst_idoc-sdata.
          IF lst_e1edp03-iddat = lc_csd.
            lv_psgnum = lst_idoc-psgnum.
            READ TABLE didoc_data INTO lst_idoc12 WITH KEY segnum = lv_psgnum.
            IF sy-subrc = 0.
              lst_e1edp01 = lst_idoc12-sdata.
              lv_posex2 = lst_e1edp01-posex.
            ENDIF. " IF sy-subrc = 0
            lv_csd1 = lst_e1edp03-datum.
            WRITE lv_csd1   TO lv_csd.
          ENDIF. " IF lst_e1edp03-iddat = lc_csd

          IF lst_e1edp03-iddat = lc_ced.
            lv_psgnum = lst_idoc-psgnum.
            READ TABLE didoc_data INTO lst_idoc12 WITH KEY segnum = lv_psgnum.
            IF sy-subrc = 0.
              lst_e1edp01 = lst_idoc12-sdata.
              lv_posex2 = lst_e1edp01-posex.
            ENDIF. " IF sy-subrc = 0
            lv_ced1 = lst_e1edp03-datum.
            WRITE lv_ced1 TO lv_ced.
          ENDIF. " IF lst_e1edp03-iddat = lc_ced

          IF lst_e1edp03-iddat = lc_lsd.
            lv_psgnum = lst_idoc-psgnum.
            READ TABLE didoc_data INTO lst_idoc12 WITH KEY segnum = lv_psgnum.
            IF sy-subrc = 0.
              lst_e1edp01 = lst_idoc12-sdata.
              lv_posex3 = lst_e1edp01-posex.
            ENDIF. " IF sy-subrc = 0
            lv_lsd1 = lst_e1edp03-datum.
            WRITE lv_lsd1 TO lv_lsd.
          ENDIF. " IF lst_e1edp03-iddat = lc_lsd

          IF lst_e1edp03-iddat = lc_led.
            lv_psgnum = lst_idoc-psgnum.
            READ TABLE didoc_data INTO lst_idoc12 WITH  KEY segnum = lv_psgnum.
            IF sy-subrc = 0.
              lst_e1edp01 = lst_idoc12-sdata.
              lv_posex3 = lst_e1edp01-posex.
            ENDIF. " IF sy-subrc = 0
            lv_led1 = lst_e1edp03-datum.
            WRITE lv_led1 TO lv_led.
          ENDIF. " IF lst_e1edp03-iddat = lc_led

        WHEN lc_e1edk02.
          lst_e1edk02 = lst_idoc-sdata.
          IF lst_e1edk02-qualf = lc_011_8.
            lv_xblnr1 = lst_e1edk02-belnr.
          ENDIF. " IF lst_e1edk02-qualf = lc_011_8
**** code for content start date and end date
        WHEN lc_z1qtc_e1edk01_01_8.
          CLEAR:lst_z1qtc_e1edk01_01_8, lv_promo_8.
          lst_z1qtc_e1edk01_01_8 = lst_idoc-sdata.
          lv_promo_8 = lst_z1qtc_e1edk01_01_8-zzpromo.
          lv_konda1 =  lst_z1qtc_e1edk01_01_8-konda.
          lv_aunum =   lst_z1qtc_e1edk01_01_8-aunum.
          lv_zlsch =   lst_z1qtc_e1edk01_01_8-zlsch.
          lv_zuonr =   lst_z1qtc_e1edk01_01_8-zuonr.
          lv_tratyh =  lst_z1qtc_e1edk01_01_8-traty.

        WHEN lc_e1edk36.
          CLEAR : lst_e1edk36.
          lst_e1edk36_2 = lst_idoc-sdata.
          lv_ccins = lst_e1edk36_2-ccins.
      ENDCASE.
**** code for content and license date
      IF lv_posex2 IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_posex2
          IMPORTING
            output = lv_posex2.

        IF lv_csd IS NOT INITIAL.

          lst_itemcon-posex = lv_posex2.
          lst_itemcon-csd = lv_csd.
*        lst_itemcon-ced = lv_ced.
          APPEND lst_itemcon TO li_itemcon.
          CLEAR: lst_itemcon,lv_posex2,
                 lv_csd.
        ENDIF. " IF lv_csd IS NOT INITIAL

        IF lv_ced IS NOT INITIAL.
          lst_itemcon-posex = lv_posex2.
          lst_itemcon-ced = lv_ced.
          MODIFY li_itemcon FROM lst_itemcon TRANSPORTING ced WHERE posex = lv_posex2.
          CLEAR: lv_ced.
        ENDIF. " IF lv_ced IS NOT INITIAL

      ENDIF. " IF lv_posex2 IS NOT INITIAL

      IF lv_posex3 IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_posex3
          IMPORTING
            output = lv_posex3.
        IF lv_lsd IS NOT INITIAL.

          lst_itemlis-posex = lv_posex3.
          lst_itemlis-lsd = lv_lsd.
*        lst_itemlis-led = lv_led.
          APPEND lst_itemlis TO li_itemlis.
          CLEAR: lst_itemlis, lv_posex3,
                 lv_lsd.
        ENDIF. " IF lv_lsd IS NOT INITIAL

        IF lv_led IS NOT INITIAL.
          lst_itemlis-posex = lv_posex3.
          lst_itemlis-led = lv_led.
          MODIFY li_itemlis FROM lst_itemlis TRANSPORTING led WHERE posex = lv_posex3.
          CLEAR: lv_led.
        ENDIF. " IF lv_led IS NOT INITIAL
      ENDIF. " IF lv_posex3 IS NOT INITIAL
**** code for content and license date
*** code for ihrez
      IF lv_posex1 IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_posex1
          IMPORTING
            output = lv_posex1.

        lst_item1-posex = lv_posex1.
        lst_item1-ihrez = lv_ihrez.
        APPEND lst_item1 TO li_item1.
        CLEAR: lst_item1,
               lv_posex1,
               lv_ihrez.

      ENDIF. " IF lv_posex1 IS NOT INITIAL
*** code for ihrez

      IF lv_posex IS NOT INITIAL.
        lst_item-posex = lv_posex.
        lst_item-mvgr1 = lv_mvgr1_8.
        lst_item-mvgr3 = lv_mvgr3_8.
        lst_item-zzpromo = lv_zzpromo.
        lst_item-zzartno = lv_artno1.
        lst_item-vbegdat = lv_vbegdat2.
        lst_item-venddat = lv_venddat2.
        APPEND lst_item TO li_item.
        CLEAR: lst_item, lv_posex,
              lv_mvgr1_8,lv_mvgr3_8,lv_zzpromo,
              lv_vbegdat2,lv_venddat2.
      ENDIF. " IF lv_posex IS NOT INITIAL
      CLEAR: lst_idoc.
    ENDLOOP. " LOOP AT didoc_data INTO lst_idoc

    lst_xvbak = dxvbak.

****   Initial Sales Screen ------------------->>>>>>>
    IF lv_stdt IS NOT INITIAL OR lst_xvbak-faksk IS NOT INITIAL
    OR lv_bstdk IS NOT INITIAL OR lv_and IS NOT INITIAL.
      CLEAR lst_bdcdata. " Clearing work area for BDC data

      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER1'.
      APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE


      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata. " appending program and screen

*      lst_xvbak = dxvbak. " Putting VBAK data in local work area

*      CLEAR lst_bdcdata.
*      lst_bdcdata-fnam = 'KUAGV-KUNNR'.
*      lst_bdcdata-fval = lst_xvbak-kunnr.
*      APPEND lst_bdcdata TO dxbdcdata. " appending KUNNR
*
*      CLEAR lst_bdcdata.
*      lst_bdcdata-fnam = 'KUAGV-KUNNR'.
*      lst_bdcdata-fval = lst_xvbak-kunnr.
*      APPEND lst_bdcdata TO dxbdcdata.  "appending KUNNR

*** Contract Start Date and Contract End Date
      IF lv_stdt IS NOT INITIAL.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VEDA-VBEGDAT'.
        lst_bdcdata-fval = lv_stdt.
        APPEND lst_bdcdata TO dxbdcdata. " appending contract start date

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VEDA-VENDDAT'.
        lst_bdcdata-fval = lv_eddt.
        APPEND lst_bdcdata TO dxbdcdata. " appending contract end date

      ENDIF. " IF lv_stdt IS NOT INITIAL

***** Billing Block
      IF lst_xvbak-faksk IS NOT INITIAL.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAK-FAKSK'.
        lst_bdcdata-fval = lst_xvbak-faksk.
        APPEND lst_bdcdata TO dxbdcdata. " appending contract end date

      ENDIF. " IF lst_xvbak-faksk IS NOT INITIAL

**** Purchase Order Date
      IF lv_bstdk IS NOT INITIAL.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBKD-BSTDK'.
        lst_bdcdata-fval = lv_bstdk.
        APPEND lst_bdcdata TO dxbdcdata. " appending contract end date

      ENDIF. " IF lv_bstdk IS NOT INITIAL

**** Quotation Start Date and Quotation End Date
      IF lv_and IS NOT INITIAL.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAK-ANGDT'.
        lst_bdcdata-fval = lv_and.
        APPEND lst_bdcdata TO dxbdcdata. " appending contract start date

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAK-BNDDT'.
        lst_bdcdata-fval = lv_bnd.
        APPEND lst_bdcdata TO dxbdcdata. " appending contract end date

      ENDIF. " IF lv_and IS NOT INITIAL
*      CLEAR lst_bdcdata.
*      lst_bdcdata-program = 'SAPLSPO1'.
*      lst_bdcdata-dynpro = '0400'.
*      lst_bdcdata-dynbegin = 'X'.
*      APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen
*
*      CLEAR lst_bdcdata.
*      lst_bdcdata-fnam = 'BDC_OKCODE'.
*      lst_bdcdata-fval = '=YES'.
*      APPEND  lst_bdcdata TO li_bdcdata230. " appending OKCODE

    ENDIF. " IF lv_stdt IS NOT INITIAL OR lst_xvbak-faksk IS NOT INITIAL
***<<<------------ Initial Sales Screen
***** Billing Document TAB ----------->>>>>>
    IF lv_fkdat IS NOT INITIAL.

      CLEAR lst_bdcdata. " Clearing work area for BDC data
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'KDE3'.
      APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE


      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4002'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata. " appending program and screen

****  Billing Date field
      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'VBKD-FKDAT'.
      lst_bdcdata-fval = lv_fkdat.
      APPEND lst_bdcdata TO dxbdcdata. " appending billing date

      CLEAR lst_bdcdata. " Clearing work area for BDC data
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER2'.
      APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE


      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata. " appending program and screen

    ENDIF. " IF lv_fkdat IS NOT INITIAL
***** <<<<------- Billing Document TAB
**** Sales TAB ----------------->>>>>>>>>>>>>
    IF lv_konda1 IS NOT INITIAL OR lv_prd IS NOT INITIAL.

      CLEAR lst_bdcdata. " Clearing work area for BDC data
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'KKAU'.
      APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4002'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata. " appending program and screen

**** Price Group
      IF lv_konda1 IS NOT INITIAL.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBKD-KONDA'.
        lst_bdcdata-fval = lv_konda1.
        APPEND lst_bdcdata TO dxbdcdata.

      ENDIF. " IF lv_konda1 IS NOT INITIAL

**** Pricing Date
      IF lv_prd IS NOT INITIAL.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'VBKD-PRSDT'.
        lst_bdcdata-fval = lv_prd.
        APPEND lst_bdcdata TO dxbdcdata.

      ENDIF. " IF lv_prd IS NOT INITIAL

      CLEAR lst_bdcdata. " Clearing work area for BDC data
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER2'.
      APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata. " appending program and screen

    ENDIF. " IF lv_konda1 IS NOT INITIAL OR lv_prd IS NOT INITIAL

**** <<<<--------------- Sales TAB

***** Payment Card TAB ----------------->>>>>>
*    IF lv_ccins IS NOT INITIAL AND lv_aunum IS NOT INITIAL.
*
*      CLEAR:  lst_bdcdata.
*      lst_bdcdata-fnam = 'BDC_OKCODE'.
*      lst_bdcdata-fval = 'KRPL'.
*      APPEND lst_bdcdata TO dxbdcdata.
*
*      CLEAR:  lst_bdcdata.
*      lst_bdcdata-program = 'SAPLV60F'.
*      lst_bdcdata-dynpro  =  '4001'.
*      lst_bdcdata-dynbegin   = 'X'.
*      APPEND lst_bdcdata TO dxbdcdata.
*
*      CLEAR:  lst_bdcdata.
*      lst_bdcdata-fnam = 'FPLTD-SELKZ(01)'.
*      lst_bdcdata-fval ='X'.
*      APPEND lst_bdcdata TO dxbdcdata.
*
*      CLEAR:  lst_bdcdata.
*      lst_bdcdata-fnam = 'BDC_OKCODE'.
*      lst_bdcdata-fval = '=CCMA'.
*      APPEND lst_bdcdata TO dxbdcdata.
*
*      CLEAR:  lst_bdcdata.
*      lst_bdcdata-program = 'SAPLV60F'.
*      lst_bdcdata-dynpro  =  '0200'.
*      lst_bdcdata-dynbegin   = 'X'.
*      APPEND lst_bdcdata TO dxbdcdata.
*
*****  Authorization Number
*      CLEAR:  lst_bdcdata.
*      lst_bdcdata-fnam = 'FPLTC-AUNUM'.
*      lst_bdcdata-fval = lv_aunum.
*      APPEND lst_bdcdata TO dxbdcdata.
*
*      CLEAR:  lst_bdcdata.
*      lst_bdcdata-fnam = 'BDC_OKCODE'.
*      lst_bdcdata-fval = '=BACK'.
*      APPEND lst_bdcdata TO dxbdcdata.
*
*      CLEAR:  lst_bdcdata.
*      lst_bdcdata-program = 'SAPLV60F'.
*      lst_bdcdata-dynpro  =  '4001'.
*      lst_bdcdata-dynbegin   = 'X'.
*      APPEND lst_bdcdata TO dxbdcdata.
*
*      CLEAR:  lst_bdcdata.
*      lst_bdcdata-fnam = 'BDC_OKCODE'.
*      lst_bdcdata-fval = '=S\BACK'.
*      APPEND lst_bdcdata TO dxbdcdata.
*
*      CLEAR:  lst_bdcdata.
*      lst_bdcdata-program = 'SAPMV45A'.
*      lst_bdcdata-dynpro  =  '4001'.
*      lst_bdcdata-dynbegin   = 'X'.
*      APPEND lst_bdcdata TO dxbdcdata.
*    ENDIF. " IF lv_ccins IS NOT INITIAL AND lv_aunum IS NOT INITIAL
****** <<<<-------------- Payment Card TAB
**** Shipping TAB ---------->>>>>>>
    IF lv_tratyh IS NOT INITIAL.

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'KDE2'.
      APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4002'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata. " appending program and screen

**** Means of Transportation Type
      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'BDC_CURSOR'.
      lst_bdcdata-fval = 'VBKD-TRATY'.
      APPEND lst_bdcdata TO dxbdcdata.

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'VBKD-TRATY'.
      lst_bdcdata-fval = lv_tratyh.
      APPEND lst_bdcdata TO dxbdcdata. "Appending Transportation Type

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER2'.
      APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata. " appending program and screen

    ENDIF. " IF lv_tratyh IS NOT INITIAL
******<<<<<------------- Shipping TAB
**** Accounting TAB -------------->>>>>>>>>>>
    IF lv_zlsch IS NOT INITIAL OR lv_zuonr IS NOT INITIAL
      OR lv_xblnr1 IS NOT INITIAL.

      CLEAR lst_bdcdata. " Clearing work area for BDC data
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'KBUC'.
      APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

      CLEAR:  lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro  =  '4002'.
      lst_bdcdata-dynbegin   = 'X'.
      APPEND lst_bdcdata TO dxbdcdata.

***** Payment Method
      IF lv_zlsch IS NOT INITIAL.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'VBKD-ZLSCH'.
        lst_bdcdata-fval = lv_zlsch.
        APPEND lst_bdcdata TO dxbdcdata.

      ENDIF. " IF lv_zlsch IS NOT INITIAL

***** Assignment
      IF lv_zuonr IS NOT INITIAL.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_CURSOR'.
        lst_bdcdata-fval = 'VBAK-ZUONR'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAK-ZUONR'.
        lst_bdcdata-fval = lv_zuonr.
        APPEND lst_bdcdata TO dxbdcdata. " Appending Assignment

      ENDIF. " IF lv_zuonr IS NOT INITIAL

**** Reference Document Number
      IF lv_xblnr1 IS NOT INITIAL.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_CURSOR'.
        lst_bdcdata-fval = 'VBAK-XBLNR'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAK-XBLNR'.
        lst_bdcdata-fval = lv_xblnr1.
        APPEND lst_bdcdata TO dxbdcdata. " Appending Assignment

      ENDIF. " IF lv_xblnr1 IS NOT INITIAL

      CLEAR lst_bdcdata. " Clearing work area for BDC data
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER2'.
      APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata. " appending program and screen

    ENDIF. " IF lv_zlsch IS NOT INITIAL OR lv_zuonr IS NOT INITIAL

**** <<<<--------- Accounting TAB
*****  Additional Data TAB B----------->>>>>>>>
    IF lv_promo_8 IS NOT INITIAL.

      CLEAR lst_bdcdata. " Clearing work area for BDC data
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER1'.
      APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE


      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata. " appending program and screen

*      CLEAR lst_bdcdata." Clearing work area for BDC data
*      lst_bdcdata-fnam = 'BDC_OKCODE'.
*      lst_bdcdata-fval = 'KKAU'.
*      APPEND lst_bdcdata TO dxbdcdata.
*
*      CLEAR lst_bdcdata.
*      lst_bdcdata-program = 'SAPMV45A'.
*      lst_bdcdata-dynpro = '4002'.
*      lst_bdcdata-dynbegin = 'X'.
*      APPEND lst_bdcdata TO dxbdcdata.

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'KZKU'.
      APPEND lst_bdcdata TO dxbdcdata.

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4002'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata.

**** Promo Code
      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'VBAK-ZZPROMO'.
      lst_bdcdata-fval = lv_promo_8.
      APPEND lst_bdcdata TO dxbdcdata.

      CLEAR lst_bdcdata. " Clearing work area for BDC data
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER2'.
      APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE


      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata. " appending program and screen

*      CLEAR lst_bdcdata.
*      lst_bdcdata-fnam = 'BDC_OKCODE'.
*      lst_bdcdata-fval = '=SICH'.
*      APPEND lst_bdcdata TO dxbdcdata.
*
*      CLEAR lst_bdcdata.
*      lst_bdcdata-program = 'SAPLSPO2'.
*      lst_bdcdata-dynpro = '0101'.
*      lst_bdcdata-dynbegin = 'X'.
*      APPEND lst_bdcdata TO dxbdcdata. " appending program and screen
*
*      CLEAR lst_bdcdata.
*      lst_bdcdata-fnam = 'BDC_OKCODE'.
*      lst_bdcdata-fval = '=OPT1'.
*      APPEND lst_bdcdata TO dxbdcdata.

    ENDIF. " IF lv_promo_8 IS NOT INITIAL
**** <<<<------------- Additional Data TAB B
***** Order DATA TAB --------->>>>>>>>>>>
    IF lv_ihrez_e2 IS NOT INITIAL.
*      CLEAR lst_bdcdata. " Clearing work area for BDC data
*      lst_bdcdata-fnam = 'BDC_OKCODE'.
*      lst_bdcdata-fval = 'UER1'.
*      APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE
*
*      CLEAR lst_bdcdata.
*      lst_bdcdata-program = 'SAPMV45A'.
*      lst_bdcdata-dynpro = '4001'.
*      lst_bdcdata-dynbegin = 'X'.
*      APPEND lst_bdcdata TO dxbdcdata. " appending program and screen

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'KBES'.
      APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4002'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata. " appending program and screen

*** Ship - to your reference
      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'BDC_CURSOR'.
      lst_bdcdata-fval = 'VBKD-IHREZ_E'.
      APPEND lst_bdcdata TO dxbdcdata.

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'VBKD-IHREZ_E'.
      lst_bdcdata-fval = lv_ihrez_e2.
      APPEND lst_bdcdata TO dxbdcdata. " Appending Assignment

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = '/EBACK'.
      APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata. " appending program and screen
    ENDIF. " IF lv_ihrez_e2 IS NOT INITIAL
**** <<<<<---------- Order Data TAB

    CLEAR lst_bdcdata. " Clearing work area for BDC data
    lst_bdcdata-fnam = 'BDC_OKCODE'.
    lst_bdcdata-fval = 'UER1'.
    APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE

    IF dxvbap[] IS NOT INITIAL.

      li_vbap[] = dxvbap[].

******** code for ihrez
      IF li_item1 IS NOT INITIAL.
        SORT li_item1 BY posex.
        DELETE ADJACENT DUPLICATES FROM li_item1.

        LOOP AT li_vbap INTO lst_vbap.

          CLEAR: lst_bdcdata.
          lst_bdcdata-program = 'SAPMV45A'.
          lst_bdcdata-dynpro = '4001'.
          lst_bdcdata-dynbegin = 'X'.
          APPEND lst_bdcdata TO li_bdcdata230.
*        Calling Conversion Exit FM
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_vbap-posex
            IMPORTING
              output = lst_vbap-posex.

          READ TABLE li_item1 INTO lst_item1 WITH KEY posex = lst_vbap-posex BINARY SEARCH.
          IF sy-subrc = 0.
*            IF lst_item1-ihrez IS NOT INITIAL.
*              CLEAR:  lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'POPO'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR:  lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro  =  '251'.
*              lst_bdcdata-dynbegin   = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR:  lst_bdcdata.
*              lst_bdcdata-fnam = 'RV45A-PO_POSEX'.
*              lst_bdcdata-fval = lst_vbap-posex.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR:  lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro  =  '4001'.
*              lst_bdcdata-dynbegin   = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'PBES'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR:  lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro  =  '4003'.
*              lst_bdcdata-dynbegin   = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'VBKD-IHREZ'.
*              lst_bdcdata-fval = lst_item1-ihrez.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = '/EBACK'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR:  lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro  =  '4001'.
*              lst_bdcdata-dynbegin   = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*            ENDIF. " IF lst_item1-ihrez IS NOT INITIAL
          ENDIF. " IF sy-subrc = 0
        ENDLOOP. " LOOP AT li_vbap INTO lst_vbap

      ENDIF. " IF li_item1 IS NOT INITIAL
******** code for ihrez
******* code for content and license date
      IF li_itemcon IS NOT INITIAL.
        SORT li_itemcon BY posex.
        DELETE ADJACENT DUPLICATES FROM li_itemcon.
        LOOP AT li_vbap INTO lst_vbap.
          CLEAR: lst_bdcdata.
          lst_bdcdata-program = 'SAPMV45A'.
          lst_bdcdata-dynpro = '4001'.
          lst_bdcdata-dynbegin = 'X'.
          APPEND lst_bdcdata TO li_bdcdata230.
*        Calling Conversion Exit FM
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_vbap-posex
            IMPORTING
              output = lst_vbap-posex.
          READ TABLE li_itemcon INTO lst_itemcon WITH KEY posex = lst_vbap-posex.
          IF sy-subrc = 0.
*            IF lst_itemcon-csd IS NOT INITIAL.
*              CLEAR lst_bdcdata. " Clearing work area for BDC data
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'UER1'.
*              APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE
*
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'POPO'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '251'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'RV45A-PO_POSEX'.
*              lst_bdcdata-fval = lst_vbap-posex.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
**              CLEAR lst_bdcdata.
**              lst_bdcdata-fnam = 'BDC_OKCODE'.
**              lst_bdcdata-fval = 'PKAU'.
**              APPEND lst_bdcdata TO dxbdcdata.
**
**              CLEAR lst_bdcdata.
**              lst_bdcdata-program = 'SAPMV45A'.
**              lst_bdcdata-dynpro = '4003'.
**              lst_bdcdata-dynbegin = 'X'.
**              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'PZKU'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4003'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_CURSOR'.
*              lst_bdcdata-fval = 'VBAP-ZZCONSTART'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'VBAP-ZZCONSTART'.
*              lst_bdcdata-fval = lst_itemcon-csd.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_CURSOR'.
*              lst_bdcdata-fval = 'VBAP-ZZCONEND'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'VBAP-ZZCONEND'.
*              lst_bdcdata-fval = lst_itemcon-ced.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = '/EBACK'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*            ENDIF. " IF lst_itemcon-csd IS NOT INITIAL
          ENDIF. " IF sy-subrc = 0
        ENDLOOP. " LOOP AT li_vbap INTO lst_vbap
      ENDIF. " IF li_itemcon IS NOT INITIAL

      IF li_itemlis IS NOT INITIAL.
        SORT li_itemlis BY posex.
        DELETE ADJACENT DUPLICATES FROM li_itemlis.
        LOOP AT li_vbap INTO lst_vbap.
          CLEAR: lst_bdcdata.
          lst_bdcdata-program = 'SAPMV45A'.
          lst_bdcdata-dynpro = '4001'.
          lst_bdcdata-dynbegin = 'X'.
          APPEND lst_bdcdata TO li_bdcdata230.
*        Calling Conversion Exit FM
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_vbap-posex
            IMPORTING
              output = lst_vbap-posex.
          READ TABLE li_itemlis INTO lst_itemlis WITH KEY posex = lst_vbap-posex.
          IF sy-subrc = 0.
*            IF lst_itemlis-lsd IS NOT INITIAL.
*              CLEAR lst_bdcdata. " Clearing work area for BDC data
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'UER1'.
*              APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE
*
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'POPO'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '251'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'RV45A-PO_POSEX'.
*              lst_bdcdata-fval = lst_vbap-posex.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
**              CLEAR lst_bdcdata.
**              lst_bdcdata-fnam = 'BDC_OKCODE'.
**              lst_bdcdata-fval = 'PKAU'.
**              APPEND lst_bdcdata TO dxbdcdata.
**
**              CLEAR lst_bdcdata.
**              lst_bdcdata-program = 'SAPMV45A'.
**              lst_bdcdata-dynpro = '4003'.
**              lst_bdcdata-dynbegin = 'X'.
**              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'PZKU'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4003'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_CURSOR'.
*              lst_bdcdata-fval = 'VBAP-ZZLICSTART'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'VBAP-ZZLICSTART'.
*              lst_bdcdata-fval = lst_itemlis-lsd.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_CURSOR'.
*              lst_bdcdata-fval = 'VBAP-ZZLICEND'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'VBAP-ZZLICEND'.
*              lst_bdcdata-fval = lst_itemlis-led.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = '/EBACK'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*            ENDIF. " IF lst_itemlis-lsd IS NOT INITIAL
          ENDIF. " IF sy-subrc = 0
        ENDLOOP. " LOOP AT li_vbap INTO lst_vbap
      ENDIF. " IF li_itemlis IS NOT INITIAL
****** code for content and license date

      IF li_item IS NOT INITIAL.

        SORT li_item BY posex.
        DELETE ADJACENT DUPLICATES FROM li_item.


        LOOP AT li_vbap INTO lst_vbap.

          CLEAR: lst_bdcdata.
          lst_bdcdata-program = 'SAPMV45A'.
          lst_bdcdata-dynpro = '4001'.
          lst_bdcdata-dynbegin = 'X'.
          APPEND lst_bdcdata TO li_bdcdata230.
*        Calling Conversion Exit FM
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_vbap-posex
            IMPORTING
              output = lst_vbap-posex.

          READ TABLE li_item INTO lst_item WITH  KEY posex = lst_vbap-posex BINARY SEARCH.
          IF sy-subrc = 0.

*              IF lst_item-mvgr1 IS NOT INITIAL
*                OR lst_item-mvgr3 IS NOT INITIAL.
*
*                CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'POPO'.
*              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '251'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'RV45A-PO_POSEX'.
*              lst_bdcdata-fval = lst_vbap-posex.
*              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'PKAU'.
*              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4003'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'PGRU'.
*              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4003'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO dxbdcdata.
*
*              IF lst_item-mvgr1 IS NOT INITIAL.
*               CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_CURSOR'.
*              lst_bdcdata-fval = 'VBAP-MVGR1'.
*              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'VBAP-MVGR1'.
*              lst_bdcdata-fval = lst_item-mvgr1.
*              APPEND lst_bdcdata TO dxbdcdata.
*              ENDIF.
*
*              IF lst_item-mvgr3 IS NOT INITIAL.
*                CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_CURSOR'.
*              lst_bdcdata-fval = 'VBAP-MVGR3'.
*              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'VBAP-MVGR3'.
*              lst_bdcdata-fval = lst_item-mvgr3.
*              APPEND lst_bdcdata TO dxbdcdata.
*              ENDIF.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = '/EBACK'.
*              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO dxbdcdata.
*
*              ENDIF." for Material Group

*            IF lst_item-vbegdat IS NOT INITIAL.
*
*              CLEAR lst_bdcdata. " Clearing work area for BDC data
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'UER1'.
*              APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE
*
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'POPO'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '251'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'RV45A-PO_POSEX'.
*              lst_bdcdata-fval = lst_vbap-posex.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
**              CLEAR lst_bdcdata.
**              lst_bdcdata-fnam = 'BDC_OKCODE'.
**              lst_bdcdata-fval = 'PKAU'.
**              APPEND lst_bdcdata TO dxbdcdata.
**
**              CLEAR lst_bdcdata.
**              lst_bdcdata-program = 'SAPMV45A'.
**              lst_bdcdata-dynpro = '4003'.
**              lst_bdcdata-dynbegin = 'X'.
**              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'PVER'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR:  lst_bdcdata.
*              lst_bdcdata-program = 'SAPLV45W'.
*              lst_bdcdata-dynpro  =  '4001'.
*              lst_bdcdata-dynbegin   = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'VEDA-VBEGDAT'.
*              lst_bdcdata-fval = lst_item-vbegdat.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'VEDA-VENDDAT'.
*              lst_bdcdata-fval = lst_item-venddat.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = '=S\BACK'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*            ENDIF. " IF lst_item-vbegdat IS NOT INITIAL

*            IF lst_item-zzpromo IS NOT INITIAL.
*
*              CLEAR lst_bdcdata. " Clearing work area for BDC data
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'UER1'.
*              APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE
*
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'POPO'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '251'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'RV45A-PO_POSEX'.
*              lst_bdcdata-fval = lst_vbap-posex.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
**              CLEAR lst_bdcdata.
**              lst_bdcdata-fnam = 'BDC_OKCODE'.
**              lst_bdcdata-fval = 'PKAU'.
**              APPEND lst_bdcdata TO dxbdcdata.
**
**              CLEAR lst_bdcdata.
**              lst_bdcdata-program = 'SAPMV45A'.
**              lst_bdcdata-dynpro = '4003'.
**              lst_bdcdata-dynbegin = 'X'.
**              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'PZKU'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4003'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_CURSOR'.
*              lst_bdcdata-fval = 'VBAP-ZZPROMO'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'VBAP-ZZPROMO'.
*              lst_bdcdata-fval = lst_item-zzpromo.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = '/EBACK'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*            ENDIF. " IF lst_item-zzpromo IS NOT INITIAL
*
*            IF lst_item-zzartno IS NOT INITIAL.
*              CLEAR lst_bdcdata. " Clearing work area for BDC data
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'UER1'.
*              APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE
*
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'POPO'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '251'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'RV45A-PO_POSEX'.
*              lst_bdcdata-fval = lst_vbap-posex.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
**              CLEAR lst_bdcdata.
**              lst_bdcdata-fnam = 'BDC_OKCODE'.
**              lst_bdcdata-fval = 'PKAU'.
**              APPEND lst_bdcdata TO dxbdcdata.
**
**              CLEAR lst_bdcdata.
**              lst_bdcdata-program = 'SAPMV45A'.
**              lst_bdcdata-dynpro = '4003'.
**              lst_bdcdata-dynbegin = 'X'.
**              APPEND lst_bdcdata TO dxbdcdata.
*
*              CLEAR: lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = 'PZKU'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4003'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_CURSOR'.
*              lst_bdcdata-fval = 'VBAP-ZZARTNO'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'VBAP-ZZARTNO'.
*              lst_bdcdata-fval = lst_item-zzartno.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-fnam = 'BDC_OKCODE'.
*              lst_bdcdata-fval = '/EBACK'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*
*              CLEAR lst_bdcdata.
*              lst_bdcdata-program = 'SAPMV45A'.
*              lst_bdcdata-dynpro = '4001'.
*              lst_bdcdata-dynbegin = 'X'.
*              APPEND lst_bdcdata TO li_bdcdata230.
*            ENDIF. " IF lst_item-zzartno IS NOT INITIAL
          ENDIF. " IF sy-subrc = 0
        ENDLOOP. " LOOP AT li_vbap INTO lst_vbap
      ENDIF. " IF li_item IS NOT INITIAL
    ENDIF. " IF dxvbap[] IS NOT INITIAL

*    DESCRIBE TABLE dxbdcdata LINES lv_tabix230.
*    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0230> INDEX lv_tabix230.
*    IF <lst_bdcdata_0230> IS ASSIGNED.
*      <lst_bdcdata_0230>-fval = 'OWN_OKCODE'.
*    ENDIF. " IF <lst_bdcdata_0230> IS ASSIGNED
*    INSERT LINES OF li_bdcdata230 INTO dxbdcdata INDEX lv_tabix230.


***EOC by SAYANDAS--->>>
  ELSEIF lst_bdcdata-fnam = 'BDC_OKCODE'
  AND lst_bdcdata-fval = 'SICH'.

    CLEAR lst_idoc.
    LOOP AT didoc_data INTO lst_idoc.
      CASE lst_idoc-segnam.
        WHEN lc_z1qtc_e1edk01_01.
          lst_z1qtc_e1edk01_01 = lst_idoc-sdata.
          lv_aunum = lst_z1qtc_e1edk01_01-aunum.
          IF lv_aunum IS NOT INITIAL.
            lv_aue_flag = abap_true.
          ENDIF. " IF lv_aunum IS NOT INITIAL

        WHEN lc_e1edk36.
          CLEAR: lst_e1edk36.
          lst_e1edk36 = lst_idoc-sdata.
          lv_ccins = lst_e1edk36-ccins.

        WHEN lc_e1edka3.
          CLEAR: lst_e1edka3.
          lst_e1edka3 = lst_idoc-sdata.
          IF lst_e1edka3-qualp = lc_005.
            lv_eml_flag = abap_true.
          ENDIF. " IF lst_e1edka3-qualp = lc_005

        WHEN lc_e1edk02.

          lst_e1edk02 = lst_idoc-sdata.
          IF lst_e1edk02-qualf = lc_004.
            lv_quotfcmn = abap_true.
          ENDIF. " IF lst_e1edk02-qualf = lc_004

        WHEN lc_z1qtc_e1edp01_01_8.
          CLEAR: lst_z1qtc_e1edp01_01_qf,
          lv_tratyiqf, lv_vbegdat2qf, lv_venddat2qf,
          lv_vbegdat3qf, lv_venddat3qf.

          lst_z1qtc_e1edp01_01_qf = lst_idoc-sdata.
          lv_posexqf = lst_z1qtc_e1edp01_01_qf-vposn.
*        Calling Conversion Exit FM
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lv_posexqf
            IMPORTING
              output = lv_posexqf.

          lv_tratyiqf = lst_z1qtc_e1edp01_01_qf-traty.
          lv_vbegdat3qf = lst_z1qtc_e1edp01_01_qf-vbegdat.
          lv_venddat3qf = lst_z1qtc_e1edp01_01_qf-venddat.
          WRITE lv_vbegdat3qf TO lv_vbegdat2qf.
          WRITE lv_venddat3qf TO lv_venddat2qf.


      ENDCASE.

      IF lv_posexqf IS NOT INITIAL.

        lst_item_qf-posex = lv_posexqf.
        lst_item_qf-traty = lv_tratyiqf. " Transportation Type
        lst_item_qf-vbegdat = lv_vbegdat2qf. " Contract Start Date
        lst_item_qf-venddat = lv_venddat2qf. " Contract End Date
        APPEND lst_item_qf TO li_item_qf.
        CLEAR: lst_item_qf, lv_posexqf.

      ENDIF. " IF lv_posexqf IS NOT INITIAL
    ENDLOOP. " LOOP AT didoc_data INTO lst_idoc

**** change for quotaion
    IF lv_quotfcmn = abap_true.
      li_di_doc[] = didoc_data[].
      DELETE li_di_doc WHERE segnam NE lc_e1edp01.
      LOOP AT li_di_doc INTO lst_di_doc.
        lst_e1edp01 = lst_di_doc-sdata.
        CLEAR lst_e1edp01-posex.
        lv_tabixqcmn = sy-tabix.
        lv_tabixqcmn = sy-tabix * 10.
        lv_posnr     = lv_tabixqcmn.
        lst_e1edp01-posex = lv_posnr.
        APPEND lst_e1edp01 TO li_e1edp01.
        CLEAR lst_e1edp01.
      ENDLOOP. " LOOP AT li_di_doc INTO lst_di_doc
    ENDIF. " IF lv_quotfcmn = abap_true
*** change for quotaion

    IF lv_aue_flag = abap_true OR lv_eml_flag = abap_true.
      lv_upd_flag = abap_true.
    ENDIF. " IF lv_aue_flag = abap_true OR lv_eml_flag = abap_true

    IF lv_aue_flag = abap_true.

      IF lv_ccins IS NOT INITIAL.
        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = 'KRPL'.
        APPEND lst_bdcdata TO li_bdcdatacmn.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-program = 'SAPLV60F'.
        lst_bdcdata-dynpro  =  '4001'.
        lst_bdcdata-dynbegin   = 'X'.
        APPEND lst_bdcdata TO li_bdcdatacmn.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'FPLTD-SELKZ(01)'.
        lst_bdcdata-fval ='X'.
        APPEND lst_bdcdata TO li_bdcdatacmn.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '=CCMA'.
        APPEND lst_bdcdata TO li_bdcdatacmn.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-program = 'SAPLV60F'.
        lst_bdcdata-dynpro  =  '0200'.
        lst_bdcdata-dynbegin   = 'X'.
        APPEND lst_bdcdata TO li_bdcdatacmn.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'FPLTC-AUNUM'.
        lst_bdcdata-fval = lv_aunum.
        APPEND lst_bdcdata TO li_bdcdatacmn.

        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '=BACK'.
        APPEND lst_bdcdata TO li_bdcdatacmn.

        CLEAR:  lst_bdcdata,lv_fval.
        lst_bdcdata-program = 'SAPLV60F'.
        lst_bdcdata-dynpro  =  '4001'.
        lst_bdcdata-dynbegin   = 'X'.
        APPEND lst_bdcdata TO li_bdcdatacmn.


        CLEAR:  lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '=S\BACK'.
        APPEND lst_bdcdata TO li_bdcdatacmn.

        CLEAR:  lst_bdcdata,lv_fval.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro  =  '4001'.
        lst_bdcdata-dynbegin   = 'X'.
        APPEND lst_bdcdata TO li_bdcdatacmn.


      ENDIF. " IF lv_ccins IS NOT INITIAL

    ENDIF. " IF lv_aue_flag = abap_true

    IF lv_eml_flag = abap_true.
      CLEAR:  lst_bdcdata,lv_fval.
      CLEAR:  lst_bdcdata,lv_fval.
      lv_fnam = 'BDC_OKCODE'.
      lv_fval = 'UER2'.
      IF lv_fval IS NOT INITIAL.
        lst_bdcdata-fnam = lv_fnam.
        lst_bdcdata-fval = lv_fval.
        APPEND lst_bdcdata TO li_bdcdatacmn.
      ENDIF. " IF lv_fval IS NOT INITIAL

      CLEAR:  lst_bdcdata,lv_fval.
      CLEAR:  lst_bdcdata,lv_fval.
      lv_fnam = 'BDC_OKCODE'.
      lv_fval = 'KPAR_SUB'.
      IF lv_fval IS NOT INITIAL.
        lst_bdcdata-fnam = lv_fnam.
        lst_bdcdata-fval = lv_fval.
        APPEND lst_bdcdata TO li_bdcdatacmn.
      ENDIF. " IF lv_fval IS NOT INITIAL

      CLEAR:  lst_bdcdata,lv_fval.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro  =  '4002'.
      lst_bdcdata-dynbegin   = 'X'.
      APPEND lst_bdcdata TO li_bdcdatacmn.


      LOOP AT dxvbadr INTO lst_vbadr.
        IF lst_vbadr-email_addr IS NOT INITIAL.

          CLEAR:  lst_bdcdata,lv_fval.
          CLEAR:  lst_bdcdata,lv_fval.
          lv_fnam = 'BDC_OKCODE'.
          lv_fval = 'PAPO'.
          IF lv_fval IS NOT INITIAL.
            lst_bdcdata-fnam = lv_fnam.
            lst_bdcdata-fval = lv_fval.
            APPEND lst_bdcdata TO li_bdcdatacmn.
          ENDIF. " IF lv_fval IS NOT INITIAL

          CLEAR:  lst_bdcdata,lv_fval.
          lst_bdcdata-program = 'SAPLV09C'.
          lst_bdcdata-dynpro  =  '0666'.
          lst_bdcdata-dynbegin   = 'X'.
          APPEND lst_bdcdata TO li_bdcdatacmn.

          CLEAR:  lst_bdcdata,lv_fval.
          CLEAR:  lst_bdcdata,lv_fval.
          lv_fnam = 'DV_PARVW'.
          lv_fval = lst_vbadr-parvw.
          IF lv_fval IS NOT INITIAL.
            lst_bdcdata-fnam = lv_fnam.
            lst_bdcdata-fval = lv_fval.
            APPEND lst_bdcdata TO li_bdcdatacmn.
          ENDIF. " IF lv_fval IS NOT INITIAL

          CLEAR:  lst_bdcdata,lv_fval.
          lst_bdcdata-program = 'SAPMV45A'.
          lst_bdcdata-dynpro  =  '4002'.
          lst_bdcdata-dynbegin   = 'X'.
          APPEND lst_bdcdata TO li_bdcdatacmn.

          CLEAR:  lst_bdcdata,lv_fval.
          CLEAR:  lst_bdcdata,lv_fval.
          lv_fnam = 'BDC_OKCODE'.
          lv_fval = 'PSDE'.
          IF lv_fval IS NOT INITIAL.
            lst_bdcdata-fnam = lv_fnam.
            lst_bdcdata-fval = lv_fval.
            APPEND lst_bdcdata TO li_bdcdatacmn.
          ENDIF. " IF lv_fval IS NOT INITIAL

          CLEAR:  lst_bdcdata,lv_fval.
          lst_bdcdata-program = 'SAPLV09C'.
          lst_bdcdata-dynpro  =  '5000'.
          lst_bdcdata-dynbegin   = 'X'.
          APPEND lst_bdcdata TO li_bdcdatacmn.

          CLEAR:  lst_bdcdata,lv_fval.
          CLEAR:  lst_bdcdata,lv_fval.
          lv_fnam = 'SZA1_D0100-SMTP_ADDR'.
          lv_fval = lst_vbadr-email_addr.
          IF lv_fval IS NOT INITIAL.
            lst_bdcdata-fnam = lv_fnam.
            lst_bdcdata-fval = lv_fval.
            APPEND lst_bdcdata TO li_bdcdatacmn.
          ENDIF. " IF lv_fval IS NOT INITIAL

          CLEAR:  lst_bdcdata,lv_fval.
          CLEAR:  lst_bdcdata,lv_fval.
          lv_fnam = 'BDC_OKCODE'.
          lv_fval = 'ENT1'.
          IF lv_fval IS NOT INITIAL.
            lst_bdcdata-fnam = lv_fnam.
            lst_bdcdata-fval = lv_fval.
            APPEND lst_bdcdata TO li_bdcdatacmn.
          ENDIF. " IF lv_fval IS NOT INITIAL

          CLEAR:  lst_bdcdata,lv_fval.
          lst_bdcdata-program = 'SAPMV45A'.
          lst_bdcdata-dynpro  =  '4002'.
          lst_bdcdata-dynbegin   = 'X'.
          APPEND lst_bdcdata TO li_bdcdatacmn.


        ENDIF. " IF lst_vbadr-email_addr IS NOT INITIAL
      ENDLOOP. " LOOP AT dxvbadr INTO lst_vbadr
    ENDIF. " IF lv_eml_flag = abap_true

*** change for quotation
    IF lv_quotfcmn = abap_true.
      IF li_e1edp01[] IS NOT INITIAL.
        IF li_item_qf IS NOT INITIAL.
          SORT li_item_qf BY posex.
          DELETE ADJACENT DUPLICATES FROM li_item_qf.
          LOOP AT li_e1edp01 INTO lst_e1edp01.

            CLEAR lst_bdcdata.
            lst_bdcdata-program = 'SAPMV45A'.
            lst_bdcdata-dynpro = '4001'.
            lst_bdcdata-dynbegin = 'X'.
            APPEND lst_bdcdata TO li_bdcdatacmn.

*        Calling Conversion Exit FM
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lst_e1edp01-posex
              IMPORTING
                output = lst_e1edp01-posex.

            READ TABLE li_item_qf INTO lst_item_qf WITH KEY posex = lst_e1edp01-posex BINARY SEARCH.
            IF sy-subrc = 0.
              IF lst_item_qf-traty IS NOT INITIAL. " Means of transportation ID
                CLEAR: lst_bdcdata.
                lst_bdcdata-fnam = 'BDC_OKCODE'.
                lst_bdcdata-fval = 'POPO'.
                APPEND lst_bdcdata TO li_bdcdatacmn. " appending OKCODE

                CLEAR: lst_bdcdata.
                lst_bdcdata-program = 'SAPMV45A'.
                lst_bdcdata-dynpro = '251'.
                lst_bdcdata-dynbegin = 'X'.
                APPEND lst_bdcdata TO li_bdcdatacmn. " appending Screen

                CLEAR: lst_bdcdata.
                lst_bdcdata-fnam = 'RV45A-POSNR'.
                lst_bdcdata-fval = lst_e1edp01-posex.
                APPEND lst_bdcdata TO li_bdcdatacmn.

                CLEAR: lst_bdcdata.
                lst_bdcdata-program = 'SAPMV45A'.
                lst_bdcdata-dynpro = '4001'.
                lst_bdcdata-dynbegin = 'X'.
                APPEND lst_bdcdata TO li_bdcdatacmn. " appending Screen

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

                CLEAR lst_bdcdata.
                lst_bdcdata-fnam = 'BDC_OKCODE'.
                lst_bdcdata-fval = '=PDE2'.
                APPEND  lst_bdcdata TO li_bdcdatacmn. "appending OKCODE

                CLEAR lst_bdcdata.
                lst_bdcdata-program = 'SAPMV45A'.
                lst_bdcdata-dynpro = '4003'.
                lst_bdcdata-dynbegin = 'X'.
                APPEND lst_bdcdata TO li_bdcdatacmn. " appending Screen

                CLEAR lst_bdcdata.
                lst_bdcdata-fnam = 'BDC_CURSOR'.
                lst_bdcdata-fval = 'VBKD-TRATY'.
                APPEND lst_bdcdata TO li_bdcdatacmn.

                CLEAR lst_bdcdata.
                lst_bdcdata-fnam = 'VBKD-TRATY'.
                lst_bdcdata-fval = lst_item_qf-traty.
                APPEND lst_bdcdata TO li_bdcdatacmn. " Appending TRATY

                CLEAR lst_bdcdata.
                lst_bdcdata-fnam = 'BDC_OKCODE'.
                lst_bdcdata-fval = '/EBACK'.
                APPEND lst_bdcdata TO li_bdcdatacmn.

                CLEAR lst_bdcdata.
                lst_bdcdata-program = 'SAPMV45A'.
                lst_bdcdata-dynpro = '4001'.
                lst_bdcdata-dynbegin = 'X'.
                APPEND lst_bdcdata TO li_bdcdatacmn.
              ENDIF. " IF lst_item_qf-traty IS NOT INITIAL

              IF lst_item_qf-vbegdat IS NOT INITIAL. " Contract Date
                CLEAR: lst_bdcdata.
                lst_bdcdata-fnam = 'BDC_OKCODE'.
                lst_bdcdata-fval = 'POPO'.
                APPEND lst_bdcdata TO li_bdcdatacmn. "Appending OKCODE

                CLEAR: lst_bdcdata.
                lst_bdcdata-program = 'SAPMV45A'.
                lst_bdcdata-dynpro = '251'.
                lst_bdcdata-dynbegin = 'X'.
                APPEND lst_bdcdata TO li_bdcdatacmn. " Appending Screen

                CLEAR: lst_bdcdata.
                lst_bdcdata-fnam = 'RV45A-POSNR'.
                lst_bdcdata-fval = lst_e1edp01-posex.
                APPEND lst_bdcdata TO li_bdcdatacmn.

                CLEAR: lst_bdcdata.
                lst_bdcdata-program = 'SAPMV45A'.
                lst_bdcdata-dynpro = '4001'.
                lst_bdcdata-dynbegin = 'X'.
                APPEND lst_bdcdata TO li_bdcdatacmn. " Appending Screen

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

                CLEAR lst_bdcdata.
                lst_bdcdata-fnam = 'BDC_OKCODE'.
                lst_bdcdata-fval = '=PVER'.
                APPEND  lst_bdcdata TO li_bdcdatacmn. "appending OKCODE

                CLEAR lst_bdcdata.
                lst_bdcdata-program = 'SAPLV45W'.
                lst_bdcdata-dynpro = '4001'.
                lst_bdcdata-dynbegin = 'X'.
                APPEND lst_bdcdata TO li_bdcdatacmn. " Appending Screen

                CLEAR lst_bdcdata.
                lst_bdcdata-fnam = 'VEDA-VBEGDAT'.
                lst_bdcdata-fval = lst_item_qf-vbegdat.
                APPEND  lst_bdcdata TO li_bdcdatacmn. " Appending Contract Start Date

                CLEAR lst_bdcdata.
                lst_bdcdata-fnam = 'VEDA-VENDDAT'.
                lst_bdcdata-fval = lst_item_qf-venddat.
                APPEND  lst_bdcdata TO li_bdcdatacmn. " Appending Contract End Date

                CLEAR lst_bdcdata.
                lst_bdcdata-fnam = 'BDC_OKCODE'.
                lst_bdcdata-fval = '/EBACK'.
                APPEND lst_bdcdata TO li_bdcdatacmn.

                CLEAR lst_bdcdata.
                lst_bdcdata-program = 'SAPMV45A'.
                lst_bdcdata-dynpro = '4001'.
                lst_bdcdata-dynbegin = 'X'.
                APPEND lst_bdcdata TO li_bdcdatacmn. " Appending Screen
              ENDIF. " IF lst_item_qf-vbegdat IS NOT INITIAL
            ENDIF. " IF sy-subrc = 0

          ENDLOOP. " LOOP AT li_e1edp01 INTO lst_e1edp01
        ENDIF. " IF li_item_qf IS NOT INITIAL
      ENDIF. " IF li_e1edp01[] IS NOT INITIAL
    ENDIF. " IF lv_quotfcmn = abap_true
*** change for quotation

    IF li_bdcdatacmn IS NOT INITIAL.
      DESCRIBE TABLE dxbdcdata LINES lv_tabixcmn.
      IF lv_quotfcmn = abap_false AND lv_upd_flag = abap_true.
        READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_cmn> INDEX lv_tabixcmn.
        IF <lst_bdcdata_cmn> IS ASSIGNED.
          <lst_bdcdata_cmn>-fval = 'OWN_OKCODE'.
        ENDIF. " IF <lst_bdcdata_cmn> IS ASSIGNED
      ENDIF. " IF lv_quotfcmn = abap_false AND lv_upd_flag = abap_true
      INSERT LINES OF li_bdcdatacmn INTO dxbdcdata INDEX lv_tabixcmn.
    ENDIF. " IF li_bdcdatacmn IS NOT INITIAL


  ENDIF. " IF lst_bdcdata-fnam = 'KUAGV-KUNNR' OR lst_bdcdata-fnam = 'KUWEV-KUNNR'

  IF   lst_bdcdata-fnam = 'BDC_OKCODE'
   AND lst_bdcdata-fval = 'OWN_OKCODE'.

    DESCRIBE TABLE dxbdcdata LINES lv_tabixcmn1.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_cmn> INDEX lv_tabixcmn1.
    IF <lst_bdcdata_cmn> IS ASSIGNED.
      <lst_bdcdata_cmn>-fval = 'SICH'.
    ENDIF. " IF <lst_bdcdata_cmn> IS ASSIGNED

  ENDIF. " IF lst_bdcdata-fnam = 'BDC_OKCODE'

ENDIF. " IF sy-subrc IS INITIAL

*** Code to insert KWMENG
lst_xvbakk = dxvbak.
lv_auart1 = lst_xvbakk-auart.
****Selecting data from TVAK table
SELECT SINGLE vbtyp " SD document category
       FROM tvak    " Sales Document Types
    INTO lv_vbtyp1
  WHERE auart = lv_auart1.

IF lv_vbtyp1 = lc_g1.


  lst_vbap10_230 = dxvbap. " Copy the value in local work area

  IF lst_vbap10_230-posnr EQ 1.
    lv_zmeng_230 = 'VBAP-ZMENG(1)'. "ZMENG Field Name
  ELSE. " ELSE -> IF lst_vbap10_230-posnr EQ 1
    lv_zmeng_230 = 'VBAP-ZMENG(2)'. "ZMENG Field Name
  ENDIF. " IF lst_vbap10_230-posnr EQ 1

  LOOP AT dxbdcdata INTO lst_bdcdata9_230 WHERE fnam = lv_zmeng_230.
    lv_tabix1_230 = sy-tabix. " Storing the index of ZMENG
  ENDLOOP. " LOOP AT dxbdcdata INTO lst_bdcdata9_230 WHERE fnam = lv_zmeng_230
  IF sy-subrc = 0.
    IF lst_vbap10_230-posnr EQ 1.
      lv_kwmeng_230 = 'RV45A-KWMENG(1)'. "KWMENG Field Name
    ELSE. " ELSE -> IF lst_vbap10_230-posnr EQ 1
      lv_kwmeng_230 = 'RV45A-KWMENG(2)'. "KWMENG Field Name
    ENDIF. " IF lst_vbap10_230-posnr EQ 1

    READ TABLE dxbdcdata INTO lst_bdcdata11_230 INDEX ( lv_tabix1_230 - 1 ).
    IF sy-subrc EQ 0 AND
       lst_bdcdata11_230-fnam NE lv_kwmeng_230.

      lst_bdcdata10_230-dynpro = '0000'.
      lst_bdcdata10_230-fnam = lv_kwmeng_230.
      lst_bdcdata10_230-fval = lst_bdcdata9_230-fval.

      INSERT lst_bdcdata10_230 INTO dxbdcdata INDEX lv_tabix1_230.
      CLEAR: lst_bdcdata11_230, lst_bdcdata10_230. " appending KWMENG
    ENDIF. " IF sy-subrc EQ 0 AND
    CLEAR lst_bdcdata9_230.
  ENDIF. " IF sy-subrc = 0
ENDIF. " IF lv_vbtyp1 = lc_g1
