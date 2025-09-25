*&---------------------------------------------------------------------*
*&  Include           ZQTCN_LOCKBOX_RENEW
*&---------------------------------------------------------------------*
*** Local types declaration for XVBAK
TYPES: BEGIN OF lty_xvbak_e097. "Kopfdaten
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
TYPES: END OF lty_xvbak_e097.

***<--- Change by SAYNADAS
*****
"Changed OCCURS 50 to OCCURS 0
TYPES: BEGIN OF lty_xvbap_e097. "Position
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
TYPES: END OF lty_xvbap_e097.

*** Local Work Area Declaration
DATA: lst_bdcdata_e097          TYPE bdcdata,                   " Batch input: New table field structure
      lst_idoc_e097             TYPE edidd,                     " Data record (IDoc)
      lst_vbak_e097             TYPE lty_xvbak_e097,
      lst_vbap_e097             TYPE lty_xvbap_e097,
      lst_e1edk02_e097          TYPE e1edk02,                   " IDoc: Document header reference data
      li_bdcdata_e097           TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
      lst_z1qtc_e1edk01_01_e097 TYPE z1qtc_e1edk01_01,          " Header General Data Entension
      lv_quot_flag              TYPE char1 VALUE abap_false,    " Quot_flag of type CHAR1
*** Local Variable Declaration
      lv_line_e097              TYPE sytabix,    " Row Index of Internal Tables
      lv_tabix_e097             TYPE sytabix,    " Row Index of Internal Tables
      lv_fnam_e097              TYPE fnam_____4, " Field name
      lv_fval_e097              TYPE bdc_fval,   " BDC field value
      lv_zlsch_e097             TYPE char1,      " Zlsch of type CHAR1
      lv_xblnr_e097             TYPE xblnr_v1.   " Reference Document Number

FIELD-SYMBOLS: <lst_bdcdata_e097> TYPE bdcdata. " Batch input: New table field structure

CONSTANTS: lc_e1edk02_e097          TYPE edilsegtyp VALUE 'E1EDK02',          " Segment type
           lc_z1qtc_e1edk01_01_e097 TYPE edilsegtyp VALUE 'Z1QTC_E1EDK01_01', " Z1qtc_e1edk01_01_8 of type CHAR16
           lc_011_e097              TYPE edi_qualfr VALUE '011',              " IDOC qualifier reference document
           lc_004_e097              TYPE edi_qualfr VALUE '004'.              " IDOC qualifier reference document.

DESCRIBE TABLE dxbdcdata LINES lv_line_e097.
READ TABLE didoc_data INTO lst_idoc_e097 INDEX 1.
*** Reading BDCDATA table into a work area
READ TABLE dxbdcdata INTO lst_bdcdata_e097 INDEX lv_line_e097.

IF sy-subrc = 0.
*  IF lst_bdcdata_e097-fnam = 'KUAGV-KUNNR' OR lst_bdcdata_e097-fnam = 'KUWEV-KUNNR'
*    OR lst_bdcdata_e097-fnam = 'VBKD-BSTKD' OR lst_bdcdata_e097-fnam = 'VBKD-BSTDK'
*    OR lst_bdcdata_e097-fnam = 'RV45A-KETDAT' OR lst_bdcdata_e097-fnam = 'RV45A-DWERK'
*    OR lst_bdcdata_e097-fnam = 'VBAK-VBELN'.

  IF lst_bdcdata_e097-fnam = 'BDC_OKCODE' AND lst_bdcdata_e097-fval = 'SICH'.

    CLEAR: lst_idoc_e097.

    LOOP AT didoc_data INTO lst_idoc_e097.
      CASE lst_idoc_e097-segnam.
        WHEN lc_e1edk02_e097.
          CLEAR lst_e1edk02_e097.
          lst_e1edk02_e097 = lst_idoc_e097-sdata.
          IF lst_e1edk02_e097-qualf = lc_011_e097.
            lv_xblnr_e097 = lst_e1edk02_e097-belnr.
          ENDIF. " IF lst_e1edk02_e097-qualf = lc_011_e097
          IF lst_e1edk02_e097-qualf = lc_004_e097.
*            lv_xblnr_e097 = lst_e1edk02_e097-belnr.
            lv_quot_flag = abap_true.
          ENDIF. " IF lst_e1edk02_e097-qualf = lc_004_e097

        WHEN lc_z1qtc_e1edk01_01_e097.
          CLEAR lst_z1qtc_e1edk01_01_e097.
          lst_z1qtc_e1edk01_01_e097 = lst_idoc_e097-sdata.
          lv_zlsch_e097 = lst_z1qtc_e1edk01_01_e097-zlsch.

        WHEN OTHERS.
      ENDCASE.
      CLEAR : lst_idoc_e097.
    ENDLOOP. " LOOP AT didoc_data INTO lst_idoc_e097

**** Accounting TAB -------------->>>>>>>>>>>
    IF lv_zlsch_e097 IS NOT INITIAL OR lv_xblnr_e097 IS NOT INITIAL.

      CLEAR lst_bdcdata_e097. " Clearing work area for BDC data
      lst_bdcdata_e097-fnam = 'BDC_OKCODE'.
      lst_bdcdata_e097-fval = 'KBUC'.
      APPEND  lst_bdcdata_e097 TO li_bdcdata_e097. "appending OKCODE

      CLEAR:  lst_bdcdata_e097.
      lst_bdcdata_e097-program = 'SAPMV45A'.
      lst_bdcdata_e097-dynpro  =  '4002'.
      lst_bdcdata_e097-dynbegin   = 'X'.
      APPEND lst_bdcdata_e097 TO li_bdcdata_e097.

***** Payment Method
      IF lv_zlsch_e097 IS NOT INITIAL.

        CLEAR:  lst_bdcdata_e097.
        lst_bdcdata_e097-fnam = 'VBKD-ZLSCH'.
        lst_bdcdata_e097-fval = lv_zlsch_e097.
        APPEND lst_bdcdata_e097 TO li_bdcdata_e097.

      ENDIF. " IF lv_zlsch_e097 IS NOT INITIAL

**** Reference Document Number
      IF lv_xblnr_e097 IS NOT INITIAL.

        CLEAR lst_bdcdata_e097.
        lst_bdcdata_e097-fnam = 'BDC_CURSOR'.
        lst_bdcdata_e097-fval = 'VBAK-XBLNR'.
        APPEND lst_bdcdata_e097 TO li_bdcdata_e097.

        CLEAR lst_bdcdata_e097.
        lst_bdcdata_e097-fnam = 'VBAK-XBLNR'.
        lst_bdcdata_e097-fval = lv_xblnr_e097.
        APPEND lst_bdcdata_e097 TO li_bdcdata_e097. " Appending Assignment

      ENDIF. " IF lv_xblnr_e097 IS NOT INITIAL

      CLEAR lst_bdcdata_e097. " Clearing work area for BDC data
      lst_bdcdata_e097-fnam = 'BDC_OKCODE'.
      lst_bdcdata_e097-fval = 'UER2'.
      APPEND  lst_bdcdata_e097 TO li_bdcdata_e097. "appending OKCODE

      CLEAR lst_bdcdata_e097.
      lst_bdcdata_e097-program = 'SAPMV45A'.
      lst_bdcdata_e097-dynpro = '4001'.
      lst_bdcdata_e097-dynbegin = 'X'.
      APPEND lst_bdcdata_e097 TO li_bdcdata_e097. " appending program and screen

    ENDIF. " IF lv_zlsch_e097 IS NOT INITIAL OR lv_xblnr_e097 IS NOT INITIAL

    DESCRIBE TABLE dxbdcdata LINES lv_tabix_e097.
    IF lv_quot_flag = abap_false.


    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_e097> INDEX lv_tabix_e097.
   IF <lst_bdcdata_e097> IS ASSIGNED.
    <lst_bdcdata_e097>-fval = 'OWN_OKCODE'.
  ENDIF. " IF <lst_bdcdata> IS ASSIGNED
   ENDIF.
  INSERT LINES OF li_bdcdata_e097 INTO dxbdcdata INDEX lv_tabix_e097.
  ENDIF. " IF lst_bdcdata_e097-fnam = 'BDC_OKCODE' AND lst_bdcdata_e097-fval = 'SICH'

IF   lst_bdcdata_e097-fnam = 'BDC_OKCODE'
   AND lst_bdcdata_e097-fval = 'OWN_OKCODE'.

    DESCRIBE TABLE dxbdcdata LINES lv_tabix_e097.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_e097> INDEX lv_tabix_e097.
    IF <lst_bdcdata_e097> IS ASSIGNED.
      <lst_bdcdata_e097>-fval = 'SICH'.
    ENDIF. " IF <lst_bdcdata_0343> IS ASSIGNED

  ENDIF. " IF lst_bdcdata13-fnam = 'BDC_OKCODE'
ENDIF. " IF sy-subrc = 0
