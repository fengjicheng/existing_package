*----------------------------------------------------------------------*
* PROGRAM NAME:       ZQTCN_INBOUND_I0233_2
* PROGRAM DESCRIPTION:Include for populating BDC DATA
* DEVELOPER:          SRBOSE (Srabanti Bose)
* CREATION DATE:      17-Oct-2016
* OBJECT ID:          I0233.2
* TRANSPORT NUMBER(S):ED2K903117
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906911
* REFERENCE NO: ERP-2886
* DEVELOPER: WROY (Writtick Roy)
* DATE: 26-JUN-2017
* DESCRIPTION: Instead of SO Line#, use PO Line# for searching
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K907395
* REFERENCE NO: RITM0026041
* DEVELOPER: SAYANDAS
* DATE: 21-MAY-2018
* DESCRIPTION: logic added to update "Your Reference (IHREZ)" from
*              E1EDP02 (qulaifer 001)
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INBOUND_BDC_I0233_2
*&---------------------------------------------------------------------*

*** Local types declaration for XVBAK
TYPES: BEGIN OF lty_xvbak_233. "Kopfdaten
        INCLUDE STRUCTURE vbak. "Sales Document: Header Data
TYPES:  bstkd LIKE vbkd-bstkd. "Customer purchase order number

TYPES:  kursk     LIKE vbkd-kursk. "Währungskurs
TYPES:  zterm     LIKE vbkd-zterm. "Zahlungsbedingungsschlüssel
TYPES:  incov     LIKE vbkd-incov. "Incoterms Teil Version
TYPES:  inco1     LIKE vbkd-inco1. "Incoterms Teil 1
TYPES:  inco2     LIKE vbkd-inco2. "Incoterms Teil 2
TYPES:  inco2_l   LIKE vbkd-inco2_l. "Incoterms Teil 2_L
TYPES:  inco3_l   LIKE vbkd-inco3_l. "Incoterms Teil 3_L
TYPES:  prsdt     LIKE vbkd-prsdt. "Datum für Preisfindung
TYPES:  angbt     LIKE vbak-vbeln. "Angebotsnummer Lieferant (SAP)
TYPES:  contk     LIKE vbak-vbeln. "Kontraknummer Lieferant (SAP)
TYPES:  kzazu     LIKE vbkd-kzazu. "Kz. Auftragszusammenführung
TYPES:  fkdat     LIKE vbkd-fkdat. "Datum Faktura-/Rechnungsindex
TYPES:  fbuda     LIKE vbkd-fbuda. "Datum der Leistungserstellung
TYPES:  empst     LIKE vbkd-empst. "Empfangsstelle
TYPES:  valdt     LIKE vbkd-valdt. "Valuta-Fix Datum
TYPES:  kdkg1     LIKE vbkd-kdkg1. "Kunden Konditionsgruppe 1
TYPES:  kdkg2     LIKE vbkd-kdkg2. "Kunden Konditionsgruppe 2
TYPES:  kdkg3     LIKE vbkd-kdkg3. "Kunden Konditionsgruppe 3
TYPES:  kdkg4     LIKE vbkd-kdkg4. "Kunden Konditionsgruppe 4
TYPES:  kdkg5     LIKE vbkd-kdkg5. "Kunden Konditionsgruppe 5
TYPES:  delco     LIKE vbkd-delco. "vereinbarte Lieferzeit
TYPES:  abtnr     LIKE vbkd-abtnr. "Abteilungsnummmer
TYPES:  dwerk     LIKE rv45a-dwerk. "disponierendes Werk
TYPES:  angbt_ref LIKE vbkd-bstkd. "Angebotsnummer Kunde (SAP)
TYPES:  contk_ref LIKE vbkd-bstkd. "Kontraknummer Kunde  (SAP)
TYPES:  currdec   LIKE tcurx-currdec. "Dezimalstellen Währung
TYPES:  bstkd_e   LIKE vbkd-bstkd_e. "Bestellnummer Warenempfänger
TYPES:  bstdk_e   LIKE vbkd-bstdk_e. "Bestelldatum Warenempfänger
TYPES: END OF lty_xvbak_233.

***BOC by SAYANDAS on 9th May 2017 for ERP-1975
"Changed OCCURS 50 to OCCURS 0
TYPES: BEGIN OF lty_xvbap_233. "Position
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
TYPES: END OF lty_xvbap_233.

*** Type for item
TYPES: BEGIN OF lty_item_233,
         posex   TYPE posex,      " Item Number of the Underlying Purchase Order
         vbegdat TYPE vbdat_veda, " Contract start date
         venddat TYPE vndat_veda, " Contract end date
       END OF lty_item_233.
***EOC by SAYANDAS on 9th May 2017 for ERP-1975

*** Local Structure declaration for XVBADR
TYPES: BEGIN OF lty_xvbadr_233 , "Partner
         posnr LIKE vbap-posnr,  " Sales Document Item
         parvw LIKE vbpa-parvw,  " Partner Function
         kunnr LIKE rv02p-kunde, " Partner number (KUNNR, LIFNR, or PERNR)
         ablad LIKE vbpa-ablad,  " Unloading Point
         knref LIKE knvp-knref.  " Customer description of partner (plant, storage location)
        INCLUDE STRUCTURE vbadr. " Address work area
TYPES: END OF lty_xvbadr_233.

*** BOC BY SAYANDAS on 21-MAY-2018 for IHREZ issue in  ED1K907395
TYPES: BEGIN OF lty_item1_233,
         posex TYPE posex, " Item Number of the Underlying Purchase Order
         ihrez TYPE ihrez, " Your Reference
       END OF lty_item1_233.
*** EOC BY SAYANDAS on 21-MAY-2018 for IHREZ issue in  ED1K907395

DATA:  lst_bdcdata_233   TYPE bdcdata, " Batch input: New table field structure
       lst_vbadr         TYPE lty_xvbadr_233,
*** BOC BY SAYANDAS on 21-MAY-2018 for IHREZ issue in  ED1K907395
       lst_e1edp02_233   TYPE e1edp02,    " IDoc: Document Item Reference Data
       lv_psgnum_233     TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
       lst_idoc12_233    TYPE edidd,      " Data record (IDoc)
       lst_e1edp01_233_2 TYPE e1edp01,    " IDoc: Document Item General Data
       lv_posex1_233     TYPE posnr_va,   " Sales Document Item
       lv_ihrez_233      TYPE ihrez,      " Your Reference
       lst_item1_233     TYPE lty_item1_233,
       li_item1_233      TYPE STANDARD TABLE OF lty_item1_233,
       lst_vbap_233_2    TYPE lty_xvbap_233,
*** EOC BY SAYANDAS on 21-MAY-2018 for IHREZ issue in  ED1K907395
       li_bdcdata        TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
       lv_fnam           TYPE fnam_____4,                " Field name
       lv_fval           TYPE bdc_fval,                  " BDC field value
       lv_tabix          TYPE sytabix,                   " Row Index of Internal Tables
       lst_didoc_data1   TYPE edidd,                     " Data record (IDoc)
       lst_didoc_data    TYPE edidd.                     " Data record (IDoc)


DATA: lst_e1edk03_233          TYPE e1edk03,          " IDoc: Document header date segment
      lst_z1qtc_e1edk01_01_233 TYPE z1qtc_e1edk01_01, " Header General Data Entension
      lst_xvbak_233            TYPE lty_xvbak_233,

*** BOC by SAYANDAS on 9th May 2017 for ERP-1975
      lst_vbap_233             TYPE lty_xvbap_233,
      li_vbap_233              TYPE STANDARD TABLE OF lty_xvbap_233,
      lst_item_233             TYPE lty_item_233,
      li_item_233              TYPE STANDARD TABLE OF lty_item_233,
      lst_z1qtc_e1edp01_01_233 TYPE z1qtc_e1edp01_01, " IDOC Segment for STATUS Field in Item Level
      lv_vbegdat233            TYPE dats,             " Field of type DATS
      lv_venddat233            TYPE dats,             " Field of type DATS
      lv_vbegdat2332           TYPE d,                " Vbegdat2332 of type Date
      lv_venddat2332           TYPE d,                " Venddat2332 of type Date
      lv_posex233              TYPE posnr_va,         " Sales Document Item
      lv_psgnum233             TYPE edi_psgnum,       " Number of the hierarchically higher SAP segment
      lst_e1edp01_233          TYPE e1edp01,          " IDoc: Document Item General Data
*** EOC by SAYANDAS on 9th May 2017 for ERP-1975
      lv_date_233              TYPE d,        " System Date
      lv_fkdat_233             TYPE d,        " System Date
      lv_date1_233             TYPE dats,     " Field of type DATS
      lv_temp1                 TYPE sy-datum, " ABAP System Field: Current Date of Application Server
      lv_stdt_233              TYPE char10,   " Stdt_233 of type CHAR10
      lv_konda                 TYPE konda.    " Price group (customer)

FIELD-SYMBOLS: <lst_bdcdata> TYPE bdcdata. " Batch input: New table field structure

CONSTANTS: lc_bok TYPE fnam_____4 VALUE 'BDC_OKCODE'. " Field name

DESCRIBE TABLE dxbdcdata LINES lv_tabix.

*Read the Idoc Number from Idoc Data
READ TABLE didoc_data INTO lst_didoc_data INDEX 1.

* Reading BDCDATA table into a work area using last index
READ TABLE dxbdcdata INTO lst_bdcdata_233 INDEX lv_tabix.
IF sy-subrc IS INITIAL.
*   Check the FNAM and FVAL value of the Lst entry of BDCDATA
*   This is to restrict the execution of the code
  IF    lst_bdcdata_233-fnam = 'RV45A-DOCNUM'         " Field Name of Idoc
    AND lst_bdcdata_233-fval = lst_didoc_data-docnum. " Idoc Number

*   Get PO Date from Idoc Structure ----->>
    LOOP AT didoc_data INTO lst_didoc_data WHERE segnam = 'E1EDK03'.
      lst_e1edk03_233 = lst_didoc_data-sdata.
      IF lst_e1edk03_233-iddat = '022'.
        lv_date1_233 = lst_e1edk03_233-datum.
        WRITE lv_date1_233 TO lv_date_233.
      ENDIF. " IF lst_e1edk03_233-iddat = '022'
      IF lst_e1edk03_233-iddat = '026'.
        lv_date1_233 = lst_e1edk03_233-datum.
        WRITE lv_date1_233 TO lv_fkdat_233.
      ENDIF. " IF lst_e1edk03_233-iddat = '026'
*** Change --->>
*     Contract Start Date
      IF lst_e1edk03_233-iddat = '019'.
        WRITE lst_e1edk03_233-datum TO lv_temp1.
        WRITE lv_temp1 TO lv_stdt_233.
      ENDIF. " IF lst_e1edk03_233-iddat = '019'
***<<--- Change
    ENDLOOP. " LOOP AT didoc_data INTO lst_didoc_data WHERE segnam = 'E1EDK03'

*** BOC by SAYANDAS on 9th May 2017 for ERP-1975
*    LOOP AT didoc_data INTO lst_didoc_data WHERE segnam = 'Z1QTC_E1EDP01_01'.
*      CLEAR : lst_z1qtc_e1edp01_01_233,
*              lv_vbegdat233, lv_venddat233,
*              lv_vbegdat2332, lv_venddat2332.
*      lst_z1qtc_e1edp01_01_233 = lst_didoc_data-sdata.
*
*      lv_posex233 = lst_z1qtc_e1edp01_01_233-vposn.
*      lv_vbegdat233 = lst_z1qtc_e1edp01_01_233-vbegdat.
*      lv_venddat233 = lst_z1qtc_e1edp01_01_233-venddat.
*
*      WRITE lv_vbegdat233 TO lv_vbegdat2332.
*      WRITE lv_venddat233 TO lv_venddat2332.
*
*      IF lv_posex233 IS NOT INITIAL.
*
*        lst_item_233-posex = lv_posex233.
*        lst_item_233-vbegdat = lv_vbegdat2332.
*        lst_item_233-venddat = lv_venddat2332.
*
*        APPEND lst_item_233 TO li_item_233.
*        CLEAR lst_item_233.
*        CLEAR: lv_posex233, lv_vbegdat2332, lv_venddat2332.
*
*      ENDIF. " IF lv_posex233 IS NOT INITIAL
*    ENDLOOP. " LOOP AT didoc_data INTO lst_didoc_data WHERE segnam = 'Z1QTC_E1EDP01_01'
*** EOC by SAYANDAS on 9th May 2017 for ERP-1975

*   Get Condition Proce Group(KONDA) from Idoc Structure ------------>>
    READ TABLE didoc_data INTO lst_didoc_data
    WITH KEY segnam = 'Z1QTC_E1EDK01_01'.
    IF sy-subrc IS INITIAL.
      lst_z1qtc_e1edk01_01_233 = lst_didoc_data-sdata.
      lv_konda = lst_z1qtc_e1edk01_01_233-konda.
    ENDIF. " IF sy-subrc IS INITIAL

    IF lv_date_233 IS NOT INITIAL
      OR lv_fkdat_233 IS NOT INITIAL
      OR lv_konda IS NOT INITIAL.

      lst_xvbak_233 = dxvbak. " Putting VBAK data in local work area

      CLEAR lst_bdcdata_233. " Clearing work area for BDC data
      lst_bdcdata_233-fnam = lc_bok.
      lst_bdcdata_233-fval = 'UER1'.
      APPEND  lst_bdcdata_233 TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata_233.
      lst_bdcdata_233-program = 'SAPMV45A'.
      lst_bdcdata_233-dynpro = '4001'.
      lst_bdcdata_233-dynbegin = 'X'.
      APPEND lst_bdcdata_233 TO dxbdcdata. " appending program and screen

      CLEAR lst_bdcdata_233.
      lst_bdcdata_233-fnam = 'KUAGV-KUNNR'.
      lst_bdcdata_233-fval = lst_xvbak_233-kunnr.
      APPEND lst_bdcdata_233 TO dxbdcdata. " appending KUNNR
** Change --->>
      IF lv_stdt_233 IS NOT INITIAL.

        CLEAR lst_bdcdata_233.
        lst_bdcdata_233-fnam = 'VEDA-VBEGDAT'.
        lst_bdcdata_233-fval = lv_stdt_233.
        APPEND lst_bdcdata_233 TO dxbdcdata. " appending contract start date

      ENDIF. " IF lv_stdt_233 IS NOT INITIAL
** <<--- Change

      IF lv_date_233 IS NOT INITIAL.
        CLEAR lst_bdcdata_233.
        lst_bdcdata_233-fnam = 'VBKD-BSTDK'.
        lst_bdcdata_233-fval = lv_date_233.
        APPEND lst_bdcdata_233 TO dxbdcdata. " appending PO Date
      ENDIF. " IF lv_date_233 IS NOT INITIAL

      IF lv_stdt_233 IS NOT INITIAL.
        CLEAR lst_bdcdata_233.
        lst_bdcdata_233-program = 'SAPLSPO1'.
        lst_bdcdata_233-dynpro = '0400'.
        lst_bdcdata_233-dynbegin = 'X'.
        APPEND lst_bdcdata_233 TO dxbdcdata. " appending program and screen

        CLEAR lst_bdcdata_233. " Clearing work area for BDC data
        lst_bdcdata_233-fnam = lc_bok.
        lst_bdcdata_233-fval = '=YES'.
        APPEND  lst_bdcdata_233 TO dxbdcdata. "appending OKCODE



        CLEAR lst_bdcdata_233.
        lst_bdcdata_233-program = 'SAPMV45A'.
        lst_bdcdata_233-dynpro = '4001'.
        lst_bdcdata_233-dynbegin = 'X'.
        APPEND lst_bdcdata_233 TO dxbdcdata. " appending program and screen

        CLEAR lst_bdcdata_233.
        lst_bdcdata_233-program = 'SAPLSPO1'.
        lst_bdcdata_233-dynpro = '0400'.
        lst_bdcdata_233-dynbegin = 'X'.
        APPEND lst_bdcdata_233 TO dxbdcdata. " appending program and screen

        CLEAR lst_bdcdata_233. " Clearing work area for BDC data
        lst_bdcdata_233-fnam = lc_bok.
        lst_bdcdata_233-fval = '=YES'.
        APPEND  lst_bdcdata_233 TO dxbdcdata. "appending OKCODE

        CLEAR lst_bdcdata_233.
        lst_bdcdata_233-program = 'SAPMV45A'.
        lst_bdcdata_233-dynpro = '4001'.
        lst_bdcdata_233-dynbegin = 'X'.
        APPEND lst_bdcdata_233 TO dxbdcdata. " appending program and screen

      ENDIF. " IF lv_stdt_233 IS NOT INITIAL
*     Billing Date --------->>
      IF lv_fkdat_233 IS NOT INITIAL.
        CLEAR lst_bdcdata_233. " Clearing work area for BDC data
        lst_bdcdata_233-fnam = lc_bok.
        lst_bdcdata_233-fval = 'KDE3'.
        APPEND  lst_bdcdata_233 TO dxbdcdata. "appending OKCODE

        CLEAR lst_bdcdata_233.
        lst_bdcdata_233-program = 'SAPMV45A'.
        lst_bdcdata_233-dynpro = '4002'.
        lst_bdcdata_233-dynbegin = 'X'.
        APPEND lst_bdcdata_233 TO dxbdcdata. " appending program and screen

        CLEAR lst_bdcdata_233.
        lst_bdcdata_233-fnam = 'VBKD-FKDAT'.
        lst_bdcdata_233-fval = lv_fkdat_233.
        APPEND lst_bdcdata_233 TO dxbdcdata. " appending billing date

*** Change for FKDAT issue
        CLEAR lst_bdcdata_233.
        lst_bdcdata_233-fnam = 'BDC_OKCODE'.
        lst_bdcdata_233-fval = '/EBACK'.
        APPEND  lst_bdcdata_233 TO dxbdcdata. "appending OKCODE

        CLEAR lst_bdcdata_233.
        lst_bdcdata_233-program = 'SAPMV45A'.
        lst_bdcdata_233-dynpro = '4001'.
        lst_bdcdata_233-dynbegin = 'X'.
        APPEND lst_bdcdata_233 TO dxbdcdata. " appending program and screen
*** Change for FKDAT issue
      ENDIF. " IF lv_fkdat_233 IS NOT INITIAL

*     Pricing Group --------->>
      IF lv_konda IS NOT INITIAL.
        CLEAR lst_bdcdata_233. " Clearing work area for BDC data
        lst_bdcdata_233-fnam = lc_bok.
        lst_bdcdata_233-fval = 'KKAU'.
        APPEND  lst_bdcdata_233 TO dxbdcdata. "appending OKCODE

        CLEAR lst_bdcdata_233.
        lst_bdcdata_233-program = 'SAPMV45A'.
        lst_bdcdata_233-dynpro = '4002'.
        lst_bdcdata_233-dynbegin = 'X'.
        APPEND lst_bdcdata_233 TO dxbdcdata. " appending program and screen

        CLEAR lst_bdcdata_233.
        lst_bdcdata_233-fnam = 'VBKD-KONDA'.
        lst_bdcdata_233-fval = lv_konda.
        APPEND lst_bdcdata_233 TO dxbdcdata. " appending billing date
      ENDIF. " IF lv_konda IS NOT INITIAL
    ENDIF. " IF lv_date_233 IS NOT INITIAL
  ENDIF. " IF lst_bdcdata_233-fnam = 'RV45A-DOCNUM'
ENDIF. " IF sy-subrc IS INITIAL



IF   lst_bdcdata_233-fnam = lc_bok
 AND lst_bdcdata_233-fval = 'SICH'.

*** BOC by SAYANDAS on 9th May 2017 for ERP-1975
*** BOC BY SAYANDAS on 21-MAY-2018 for IHREZ issue in  ED1K907395
*  LOOP AT didoc_data INTO lst_didoc_data WHERE segnam = 'Z1QTC_E1EDP01_01'.
  LOOP AT didoc_data INTO lst_didoc_data.
    IF lst_didoc_data-segnam = 'Z1QTC_E1EDP01_01'.

*** EOC BY SAYANDAS on 21-MAY-2018 for IHREZ issue in  ED1K907395
      CLEAR : lst_z1qtc_e1edp01_01_233,
              lv_vbegdat233, lv_venddat233,
              lv_vbegdat2332, lv_venddat2332.
      lst_z1qtc_e1edp01_01_233 = lst_didoc_data-sdata.

      lv_posex233 = lst_z1qtc_e1edp01_01_233-vposn.
      lv_vbegdat233 = lst_z1qtc_e1edp01_01_233-vbegdat.
      lv_venddat233 = lst_z1qtc_e1edp01_01_233-venddat.

      WRITE lv_vbegdat233 TO lv_vbegdat2332.
      WRITE lv_venddat233 TO lv_venddat2332.

      IF lv_posex233 IS INITIAL.
        lv_psgnum233 = lst_didoc_data-psgnum.
        READ TABLE didoc_data INTO lst_didoc_data1 WITH KEY segnum = lv_psgnum233.
        IF sy-subrc = 0.
          lst_e1edp01_233 = lst_didoc_data1-sdata.
          lv_posex233 = lst_e1edp01_233-posex.
        ENDIF. " IF sy-subrc = 0
      ENDIF. " IF lv_posex233 IS INITIAL

      IF lv_posex233 IS NOT INITIAL.

        lst_item_233-posex = lv_posex233.
        lst_item_233-vbegdat = lv_vbegdat2332.
        lst_item_233-venddat = lv_venddat2332.

        APPEND lst_item_233 TO li_item_233.
        CLEAR lst_item_233.
        CLEAR: lv_posex233, lv_vbegdat2332, lv_venddat2332.

      ENDIF. " IF lv_posex233 IS NOT INITIAL
*** BOC BY SAYANDAS on 21-MAY-2018 for IHREZ issue in  ED1K907395
    ELSEIF lst_didoc_data-segnam = 'E1EDP02'.
      CLEAR: lst_e1edp02_233.
      lst_e1edp02_233 = lst_didoc_data-sdata.
      IF lst_e1edp02_233-qualf = '001'.
        lv_psgnum_233 = lst_didoc_data-psgnum.
        READ TABLE didoc_data INTO lst_idoc12_233 WITH KEY segnum = lv_psgnum_233.
        IF sy-subrc = 0.
          lst_e1edp01_233_2 = lst_idoc12_233-sdata.
          lv_posex1_233 = lst_e1edp01_233_2-posex.
          lv_ihrez_233 = lst_e1edp02_233-ihrez.
        ENDIF. " IF sy-subrc = 0
        CLEAR: lst_e1edp01_233_2, lst_idoc12_233,lv_psgnum_233.
      ENDIF. " IF lst_e1edp02_233-qualf = '001'

      IF lv_posex1_233 IS NOT INITIAL AND lv_ihrez_233 IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_posex1_233
          IMPORTING
            output = lv_posex1_233.

        lst_item1_233-posex = lv_posex1_233.
        lst_item1_233-ihrez = lv_ihrez_233.
        APPEND lst_item1_233 TO li_item1_233.

        CLEAR: lst_item1_233,
               lv_posex1_233,
               lv_ihrez_233.

      ENDIF. " IF lv_posex1_233 IS NOT INITIAL AND lv_ihrez_233 IS NOT INITIAL
    ENDIF. " IF lst_didoc_data-segnam = 'Z1QTC_E1EDP01_01'
*** EOC BY SAYANDAS on 21-MAY-2018 for IHREZ issue in  ED1K907395
  ENDLOOP. " LOOP AT didoc_data INTO lst_didoc_data

  IF dxvbap[] IS NOT INITIAL.

    li_vbap_233 = dxvbap[].

    IF li_item_233 IS NOT INITIAL.
*      CLEAR:  lst_bdcdata_233,lv_fval.
*      CLEAR:  lst_bdcdata_233,lv_fval.
*      lv_fnam = lc_bok.
*      lv_fval = 'UER1'.
*      IF lv_fval IS NOT INITIAL.
*        lst_bdcdata_233-fnam = lv_fnam.
*        lst_bdcdata_233-fval = lv_fval.
*        APPEND lst_bdcdata_233 TO li_bdcdata.
*      ENDIF. " IF lv_fval IS NOT INITIAL


      SORT li_item_233 BY posex.
      DELETE ADJACENT DUPLICATES FROM li_item_233.
      LOOP AT li_vbap_233 INTO lst_vbap_233.


*        CLEAR:  lst_bdcdata_233,lv_fval.
*        lst_bdcdata_233-program = 'SAPMV45A'.
*        lst_bdcdata_233-dynpro  =  '4002'.
*        lst_bdcdata_233-dynbegin   = 'X'.
*        APPEND lst_bdcdata_233 TO li_bdcdata.

*        Calling Conversion Exit FM
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lst_vbap_233-posex
          IMPORTING
            output = lst_vbap_233-posex.

        READ TABLE li_item_233 INTO lst_item_233 WITH KEY posex = lst_vbap_233-posex BINARY SEARCH.

        IF sy-subrc = 0.
          IF lst_item_233-vbegdat IS NOT INITIAL.

            CLEAR lst_bdcdata_233. " Clearing work area for BDC data
            lst_bdcdata_233-fnam = 'BDC_OKCODE'.
            lst_bdcdata_233-fval = 'UER1'.
            APPEND  lst_bdcdata_233 TO li_bdcdata. "appending OKCODE

            CLEAR lst_bdcdata_233.
            lst_bdcdata_233-program = 'SAPMV45A'.
            lst_bdcdata_233-dynpro = '4001'.
            lst_bdcdata_233-dynbegin = 'X'.
            APPEND lst_bdcdata_233 TO li_bdcdata. " appending program and screen

            CLEAR: lst_bdcdata_233.
            lst_bdcdata_233-fnam = 'BDC_OKCODE'.
            lst_bdcdata_233-fval = 'POPO'.
            APPEND lst_bdcdata_233 TO li_bdcdata. "Appending OKCODE

            CLEAR: lst_bdcdata_233.
            lst_bdcdata_233-program = 'SAPMV45A'.
            lst_bdcdata_233-dynpro = '251'.
            lst_bdcdata_233-dynbegin = 'X'.
            APPEND lst_bdcdata_233 TO li_bdcdata. " Appending Screen

            CLEAR: lst_bdcdata_233.
*           Begin of CHANGE:ERP-2886:WROY:26-JUN-2017:ED2K906911
*           lst_bdcdata_233-fnam = 'RV45A-POSNR'.
            lst_bdcdata_233-fnam = 'RV45A-PO_POSEX'.
*           End   of CHANGE:ERP-2886:WROY:26-JUN-2017:ED2K906911
            lst_bdcdata_233-fval = lst_vbap_233-posex.
            APPEND lst_bdcdata_233 TO li_bdcdata.

            CLEAR: lst_bdcdata_233.
            lst_bdcdata_233-program = 'SAPMV45A'.
            lst_bdcdata_233-dynpro = '4001'.
            lst_bdcdata_233-dynbegin = 'X'.
            APPEND lst_bdcdata_233 TO li_bdcdata. " Appending Screen


            CLEAR lst_bdcdata_233.
            lst_bdcdata_233-fnam = 'BDC_OKCODE'.
            lst_bdcdata_233-fval = '=PVER'.
            APPEND  lst_bdcdata_233 TO li_bdcdata. "appending OKCODE

            CLEAR lst_bdcdata_233.
            lst_bdcdata_233-program = 'SAPLV45W'.
            lst_bdcdata_233-dynpro = '4001'.
            lst_bdcdata_233-dynbegin = 'X'.
            APPEND lst_bdcdata_233 TO li_bdcdata. " Appending Screen

            CLEAR lst_bdcdata_233.
            lst_bdcdata_233-fnam = 'VEDA-VBEGDAT'.
            lst_bdcdata_233-fval = lst_item_233-vbegdat.
            APPEND  lst_bdcdata_233 TO li_bdcdata. " Appending Contract Start Date

            IF lst_item_233-venddat IS NOT INITIAL.

              CLEAR lst_bdcdata_233.
              lst_bdcdata_233-fnam = 'VEDA-VENDDAT'.
              lst_bdcdata_233-fval = lst_item_233-venddat.
              APPEND  lst_bdcdata_233 TO li_bdcdata. " Appending Contract End Date

            ENDIF. " IF lst_item_233-venddat IS NOT INITIAL

            CLEAR lst_bdcdata_233.
            lst_bdcdata_233-fnam = 'BDC_OKCODE'.
            lst_bdcdata_233-fval = '/EBACK'.
            APPEND lst_bdcdata_233 TO li_bdcdata.

            CLEAR lst_bdcdata_233.
            lst_bdcdata_233-program = 'SAPMV45A'.
            lst_bdcdata_233-dynpro = '4001'.
            lst_bdcdata_233-dynbegin = 'X'.
            APPEND lst_bdcdata_233 TO li_bdcdata. " Appending Screen

          ENDIF. " IF lst_item_233-vbegdat IS NOT INITIAL
        ENDIF. " IF sy-subrc = 0
      ENDLOOP. " LOOP AT li_vbap_233 INTO lst_vbap_233
    ENDIF. " IF li_item_233 IS NOT INITIAL
*** BOC BY SAYANDAS on 21-MAY-2018 for IHREZ issue in  ED1K907395
    IF li_item1_233 IS NOT INITIAL.
      SORT li_item1_233 BY posex.
      DELETE ADJACENT DUPLICATES FROM li_item1_233.

      LOOP AT li_vbap_233 INTO lst_vbap_233_2.

*        Calling Conversion Exit FM
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lst_vbap_233_2-posex
          IMPORTING
            output = lst_vbap_233_2-posex.

        READ TABLE li_item1_233 INTO lst_item1_233 WITH KEY posex = lst_vbap_233_2-posex BINARY SEARCH.
        IF sy-subrc = 0.
          IF lst_item1_233-ihrez IS NOT INITIAL.
            CLEAR: lst_bdcdata_233.
            lst_bdcdata_233-program = 'SAPMV45A'.
            lst_bdcdata_233-dynpro = '4001'.
            lst_bdcdata_233-dynbegin = 'X'.
            APPEND lst_bdcdata_233 TO li_bdcdata.

            CLEAR:  lst_bdcdata_233.
            lst_bdcdata_233-fnam = 'BDC_OKCODE'.
            lst_bdcdata_233-fval = 'POPO'.
            APPEND lst_bdcdata_233 TO li_bdcdata.

            CLEAR:  lst_bdcdata_233.
            lst_bdcdata_233-program = 'SAPMV45A'.
            lst_bdcdata_233-dynpro  =  '251'.
            lst_bdcdata_233-dynbegin   = 'X'.
            APPEND lst_bdcdata_233 TO li_bdcdata.

            CLEAR:  lst_bdcdata_233.
            lst_bdcdata_233-fnam = 'RV45A-PO_POSEX'.
            lst_bdcdata_233-fval = lst_vbap_233_2-posex.
            APPEND lst_bdcdata_233 TO li_bdcdata.

            CLEAR:  lst_bdcdata_233.
            lst_bdcdata_233-program = 'SAPMV45A'.
            lst_bdcdata_233-dynpro  =  '4001'.
            lst_bdcdata_233-dynbegin   = 'X'.
            APPEND lst_bdcdata_233 TO li_bdcdata.

            CLEAR: lst_bdcdata_233.
            lst_bdcdata_233-fnam = 'BDC_OKCODE'.
            lst_bdcdata_233-fval = 'PBES'.
            APPEND lst_bdcdata_233 TO li_bdcdata.

            CLEAR: lst_bdcdata_233.
            lst_bdcdata_233-program = 'SAPMV45A'.
            lst_bdcdata_233-dynpro  =  '4003'.
            lst_bdcdata_233-dynbegin   = 'X'.
            APPEND lst_bdcdata_233 TO li_bdcdata.

            CLEAR: lst_bdcdata_233.
            lst_bdcdata_233-fnam = 'VBKD-IHREZ'.
            lst_bdcdata_233-fval = lst_item1_233-ihrez.
            APPEND lst_bdcdata_233 TO li_bdcdata.

            CLEAR: lst_bdcdata_233.
            lst_bdcdata_233-fnam = 'BDC_OKCODE'.
            lst_bdcdata_233-fval = '/EBACK'.
            APPEND lst_bdcdata_233 TO li_bdcdata.

            CLEAR: lst_bdcdata_233.
            lst_bdcdata_233-program = 'SAPMV45A'.
            lst_bdcdata_233-dynpro  =  '4001'.
            lst_bdcdata_233-dynbegin   = 'X'.
            APPEND lst_bdcdata_233 TO li_bdcdata.
          ENDIF. " IF lst_item1_233-ihrez IS NOT INITIAL
        ENDIF. " IF sy-subrc = 0
      ENDLOOP. " LOOP AT li_vbap_233 INTO lst_vbap_233_2

    ENDIF. " IF li_item1_233 IS NOT INITIAL
*** EOC BY SAYANDAS on 21-MAY-2018 for IHREZ issue in  ED1K907395

  ENDIF. " IF dxvbap[] IS NOT INITIAL
*** EOC by SAYANDAS on 9th May 2017 for ERP-1975
  CLEAR:  lst_bdcdata_233,lv_fval.
  CLEAR:  lst_bdcdata_233,lv_fval.
  lv_fnam = lc_bok.
  lv_fval = 'UER2'.
  IF lv_fval IS NOT INITIAL.
    lst_bdcdata_233-fnam = lv_fnam.
    lst_bdcdata_233-fval = lv_fval.
    APPEND lst_bdcdata_233 TO li_bdcdata.
  ENDIF. " IF lv_fval IS NOT INITIAL

  CLEAR:  lst_bdcdata_233,lv_fval.
  CLEAR:  lst_bdcdata_233,lv_fval.
  lv_fnam = lc_bok.
  lv_fval = 'KPAR_SUB'.
  IF lv_fval IS NOT INITIAL.
    lst_bdcdata_233-fnam = lv_fnam.
    lst_bdcdata_233-fval = lv_fval.
    APPEND lst_bdcdata_233 TO li_bdcdata.
  ENDIF. " IF lv_fval IS NOT INITIAL

  CLEAR:  lst_bdcdata_233,lv_fval.
  lst_bdcdata_233-program = 'SAPMV45A'.
  lst_bdcdata_233-dynpro  =  '4002'.
  lst_bdcdata_233-dynbegin   = 'X'.
  APPEND lst_bdcdata_233 TO li_bdcdata.


  LOOP AT dxvbadr INTO lst_vbadr.
    IF lst_vbadr-email_addr IS NOT INITIAL.

      CLEAR:  lst_bdcdata_233,lv_fval.
      CLEAR:  lst_bdcdata_233,lv_fval.
      lv_fnam = lc_bok.
      lv_fval = 'PAPO'.
      IF lv_fval IS NOT INITIAL.
        lst_bdcdata_233-fnam = lv_fnam.
        lst_bdcdata_233-fval = lv_fval.
        APPEND lst_bdcdata_233 TO li_bdcdata.
      ENDIF. " IF lv_fval IS NOT INITIAL

      CLEAR:  lst_bdcdata_233,lv_fval.
      lst_bdcdata_233-program = 'SAPLV09C'.
      lst_bdcdata_233-dynpro  =  '0666'.
      lst_bdcdata_233-dynbegin   = 'X'.
      APPEND lst_bdcdata_233 TO li_bdcdata.

      CLEAR:  lst_bdcdata_233,lv_fval.
      CLEAR:  lst_bdcdata_233,lv_fval.
      lv_fnam = 'DV_PARVW'.
      lv_fval = lst_vbadr-parvw.
      IF lv_fval IS NOT INITIAL.
        lst_bdcdata_233-fnam = lv_fnam.
        lst_bdcdata_233-fval = lv_fval.
        APPEND lst_bdcdata_233 TO li_bdcdata.
      ENDIF. " IF lv_fval IS NOT INITIAL

      CLEAR:  lst_bdcdata_233,lv_fval.
      lst_bdcdata_233-program = 'SAPMV45A'.
      lst_bdcdata_233-dynpro  =  '4002'.
      lst_bdcdata_233-dynbegin   = 'X'.
      APPEND lst_bdcdata_233 TO li_bdcdata.

      CLEAR:  lst_bdcdata_233,lv_fval.
      CLEAR:  lst_bdcdata_233,lv_fval.
      lv_fnam = lc_bok.
      lv_fval = 'PSDE'.
      IF lv_fval IS NOT INITIAL.
        lst_bdcdata_233-fnam = lv_fnam.
        lst_bdcdata_233-fval = lv_fval.
        APPEND lst_bdcdata_233 TO li_bdcdata.
      ENDIF. " IF lv_fval IS NOT INITIAL

      CLEAR:  lst_bdcdata_233,lv_fval.
      lst_bdcdata_233-program = 'SAPLV09C'.
      lst_bdcdata_233-dynpro  =  '5000'.
      lst_bdcdata_233-dynbegin   = 'X'.
      APPEND lst_bdcdata_233 TO li_bdcdata.

      CLEAR:  lst_bdcdata_233,lv_fval.
      CLEAR:  lst_bdcdata_233,lv_fval.
      lv_fnam = 'SZA1_D0100-SMTP_ADDR'.
      lv_fval = lst_vbadr-email_addr.
      IF lv_fval IS NOT INITIAL.
        lst_bdcdata_233-fnam = lv_fnam.
        lst_bdcdata_233-fval = lv_fval.
        APPEND lst_bdcdata_233 TO li_bdcdata.
      ENDIF. " IF lv_fval IS NOT INITIAL

      CLEAR:  lst_bdcdata_233,lv_fval.
      CLEAR:  lst_bdcdata_233,lv_fval.
      lv_fnam = lc_bok.
      lv_fval = 'ENT1'.
      IF lv_fval IS NOT INITIAL.
        lst_bdcdata_233-fnam = lv_fnam.
        lst_bdcdata_233-fval = lv_fval.
        APPEND lst_bdcdata_233 TO li_bdcdata.
      ENDIF. " IF lv_fval IS NOT INITIAL

      CLEAR:  lst_bdcdata_233,lv_fval.
      lst_bdcdata_233-program = 'SAPMV45A'.
      lst_bdcdata_233-dynpro  =  '4002'.
      lst_bdcdata_233-dynbegin   = 'X'.
      APPEND lst_bdcdata_233 TO li_bdcdata.


    ENDIF. " IF lst_vbadr-email_addr IS NOT INITIAL
  ENDLOOP. " LOOP AT dxvbadr INTO lst_vbadr

  DESCRIBE TABLE dxbdcdata LINES lv_tabix.
  READ TABLE dxbdcdata ASSIGNING <lst_bdcdata> INDEX lv_tabix.
  IF <lst_bdcdata> IS ASSIGNED.
    <lst_bdcdata>-fval = 'OWN_OKCODE'.
  ENDIF. " IF <lst_bdcdata> IS ASSIGNED
  INSERT LINES OF li_bdcdata INTO dxbdcdata INDEX lv_tabix.

ENDIF. " IF lst_bdcdata_233-fnam = lc_bok

IF   lst_bdcdata_233-fnam = lc_bok
 AND lst_bdcdata_233-fval = 'OWN_OKCODE'.

  DESCRIBE TABLE dxbdcdata LINES lv_tabix.
  READ TABLE dxbdcdata ASSIGNING <lst_bdcdata> INDEX lv_tabix.
  IF <lst_bdcdata> IS ASSIGNED.
    <lst_bdcdata>-fval = 'SICH'.
  ENDIF. " IF <lst_bdcdata> IS ASSIGNED

ENDIF. " IF lst_bdcdata_233-fnam = lc_bok
