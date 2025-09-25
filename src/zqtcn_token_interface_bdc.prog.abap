*&---------------------------------------------------------------------*
*&  Include           ZQTCN_TOKEN_INTERFACE_BDC
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_TOKEN_INTERFACE_BDC(Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Token Interface BDC
* DEVELOPER: SAYANDAS ( Sayantan Das )
* CREATION DATE:   22/05/2017
* OBJECT ID: I0234
* TRANSPORT NUMBER(S):  ED2K905681
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *

*** Local types declaration for XVBAK
TYPES: BEGIN OF lty_xvbak234. "Kopfdaten
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
TYPES: END OF lty_xvbak234.

*****
"Changed OCCURS 50 to OCCURS 0
TYPES: BEGIN OF lty_xvbap234. "Position
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
TYPES: END OF lty_xvbap234.
*****

TYPES: BEGIN OF lty_item234,
         posex TYPE posex,      " Item Number of the Underlying Purchase Order
         acd   TYPE vadat_veda, " Agreement acceptance date
       END OF lty_item234.

*** Local Field Symbols
FIELD-SYMBOLS: <lst_bdcdata_0234> TYPE bdcdata. " Batch input: New table field structure

**** Local Data Declaration
DATA: lst_bdcdata234   TYPE bdcdata,                   " Batch input: New table field structure
      lst_e1edp03234   TYPE e1edp03,                   " IDoc: Document Item Date Segment
      lst_e1edp01234   TYPE e1edp01,                   " IDoc: Document Item General Data
      lst_e1edp01234_2 TYPE e1edp01,                   " IDoc: Document Item General Data
      li_e1edp01234    TYPE STANDARD TABLE OF e1edp01, " IDoc: Document Item General Data
      lst_e1edk02_234  TYPE e1edk02,                   " IDoc: Document header reference data
      lv_posex234      TYPE posnr_va,                  " Sales Document Item
      lv_posex2342     TYPE posnr_va,                  " Sales Document Item
      lst_idoc234      TYPE edidd,                     " Data record (IDoc)
      lst_idoc2342     TYPE edidd,                     " Data record (IDoc)
      lv_acd           TYPE d,                         " Acd of type Date
      lv_acd1          TYPE dats,                      " Field of type DATS
      li_di_doc234     TYPE STANDARD TABLE OF edidd,   " Data record (IDoc)
      lst_di_doc234    TYPE edidd,                     " Data record (IDoc)
      lv_tabixc        TYPE sytabix,                   " Row Index of Internal Tables
      lv_posnr234      TYPE posnr_va,                  " Sales Document Item
      lst_xvbak234     TYPE lty_xvbak234,
      li_vbap234       TYPE STANDARD TABLE OF lty_xvbap234,
      lst_vbap234      TYPE lty_xvbap234,
      lv_contf         TYPE char1 VALUE abap_false,    " Contf of type CHAR1
      li_bdcdata234    TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
      lst_item234      TYPE lty_item234,
      li_item234       TYPE STANDARD TABLE OF lty_item234,
      lst_item2342     TYPE lty_item234,
      li_item2342      TYPE STANDARD TABLE OF lty_item234,
      lv_psgnum234     TYPE edi_psgnum,                " Number of the hierarchically higher SAP segment
      lv_tabix234      TYPE sytabix,                   " Row Index of Internal Tables
      lv_line234       TYPE sytabix.                   " Row Index of Internal Tables

*** Local Constant Declaration
CONSTANTS: lc_e1edp03_234 TYPE char7 VALUE 'E1EDP03',   " E1edp03_234 of type CHAR7
           lc_000010_234  TYPE posnr_va VALUE '000010', " Sales Document Item
           lc_e1edp01_234 TYPE char7 VALUE 'E1EDP01',   " E1edp01_234 of type CHAR7
           lc_e1edk02_234 TYPE char7 VALUE 'E1EDK02',   " E1edk02_234 of type CHAR7
           lc_043_234     TYPE edi_qualfr VALUE '043',  " IDOC qualifier reference document
           lc_acd         TYPE edi_iddat VALUE 'ACD'.   " Qualifier for IDOC date segment

*** getting number of lines in BDCDATA
DESCRIBE TABLE dxbdcdata LINES lv_line234.
* Read the Idoc Number from Idoc Data
READ TABLE didoc_data INTO lst_idoc234 INDEX 1.
* Reading BDCDATA table into a work area using last index
READ TABLE dxbdcdata INTO lst_bdcdata234 INDEX lv_line234.
IF sy-subrc IS INITIAL.
*   Check the FNAM and FVAL value of the Lst entry of BDCDATA
*   This is to restrict the execution of the code
  IF lst_bdcdata234-fnam = 'BDC_OKCODE'
     AND lst_bdcdata234-fval = 'SICH'.

    CLEAR lst_idoc234.
    lst_xvbak234 = dxvbak.

    LOOP AT didoc_data INTO lst_idoc234.
      CASE lst_idoc234-segnam.
        WHEN lc_e1edp03_234.

          lst_e1edp03234 = lst_idoc234-sdata.
          IF lst_e1edp03234-iddat = lc_acd.
            lv_psgnum234 = lst_idoc234-psgnum.
            READ TABLE  didoc_data INTO lst_idoc2342 WITH KEY segnum = lv_psgnum234.
            IF sy-subrc = 0.
              lst_e1edp01234 = lst_idoc2342-sdata.
              lv_posex234 = lst_e1edp01234-posex.
            ENDIF. " IF sy-subrc = 0
            lv_acd1 = lst_e1edp03234-datum.
            WRITE lv_acd1 TO lv_acd.
          ENDIF. " IF lst_e1edp03234-iddat = lc_acd



        WHEN OTHERS.
      ENDCASE.

      CLEAR lst_idoc234.
    ENDLOOP. " LOOP AT didoc_data INTO lst_idoc234


    IF  lv_acd IS NOT INITIAL.

      CLEAR lst_bdcdata234.
      lst_bdcdata234-fnam = 'BDC_OKCODE'.
      lst_bdcdata234-fval = 'UER1'.

      APPEND lst_bdcdata234 TO li_bdcdata234.

      CLEAR: lst_bdcdata234.
      lst_bdcdata234-program = 'SAPMV45A'.
      lst_bdcdata234-dynpro = '4001'.
      lst_bdcdata234-dynbegin = 'X'.
      APPEND lst_bdcdata234 TO li_bdcdata234.

      IF lv_acd IS NOT INITIAL.

        CLEAR:  lst_bdcdata234.
        lst_bdcdata234-fnam = 'BDC_OKCODE'.
        lst_bdcdata234-fval = 'POPO'.
        APPEND lst_bdcdata234 TO li_bdcdata234.

        CLEAR:  lst_bdcdata234.
        lst_bdcdata234-program = 'SAPMV45A'.
        lst_bdcdata234-dynpro  =  '251'.
        lst_bdcdata234-dynbegin   = 'X'.
        APPEND lst_bdcdata234 TO li_bdcdata234.

        CLEAR:  lst_bdcdata234.
        lst_bdcdata234-fnam = 'RV45A-POSNR'.
        lst_bdcdata234-fval = lc_000010_234. " Single line item so constant has been used
        APPEND lst_bdcdata234 TO li_bdcdata234.

        CLEAR:  lst_bdcdata234.
        lst_bdcdata234-program = 'SAPMV45A'.
        lst_bdcdata234-dynpro  =  '4001'.
        lst_bdcdata234-dynbegin   = 'X'.
        APPEND lst_bdcdata234 TO li_bdcdata234.

        CLEAR lst_bdcdata234.
        lst_bdcdata234-fnam = 'BDC_OKCODE'.
        lst_bdcdata234-fval = 'PVER'.
        APPEND  lst_bdcdata234 TO li_bdcdata234. "appending OKCODE


        CLEAR lst_bdcdata234.
        lst_bdcdata234-program = 'SAPLV45W'.
        lst_bdcdata234-dynpro = '4001'.
        lst_bdcdata234-dynbegin = 'X'.
        APPEND lst_bdcdata234 TO li_bdcdata234. " Appending Screen

        CLEAR lst_bdcdata234.
        lst_bdcdata234-fnam = 'VEDA-VABNDAT'.
        lst_bdcdata234-fval =  lv_acd.
        APPEND  lst_bdcdata234 TO li_bdcdata234. "appending OKCODE

        CLEAR lst_bdcdata234.
        lst_bdcdata234-fnam = 'BDC_OKCODE'.
        lst_bdcdata234-fval = '/EBACK'.
        APPEND  lst_bdcdata234 TO li_bdcdata234. "appending OKCODE

        CLEAR:  lst_bdcdata234.
        lst_bdcdata234-program = 'SAPMV45A'.
        lst_bdcdata234-dynpro  =  '4001'.
        lst_bdcdata234-dynbegin   = 'X'.
        APPEND lst_bdcdata234 TO li_bdcdata234.

      ENDIF. " IF lv_acd IS NOT INITIAL

    ENDIF. " IF lv_acd IS NOT INITIAL


    DESCRIBE TABLE dxbdcdata LINES lv_tabix234.

    INSERT LINES OF li_bdcdata234 INTO dxbdcdata INDEX lv_tabix234.

  ENDIF. " IF lst_bdcdata234-fnam = 'BDC_OKCODE'

  IF   lst_bdcdata234-fnam = 'BDC_OKCODE'
   AND lst_bdcdata234-fval = 'OWN_OKCODE'.

    DESCRIBE TABLE dxbdcdata LINES lv_tabix234.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0234> INDEX lv_tabix234.
    IF <lst_bdcdata_0234> IS ASSIGNED.
      <lst_bdcdata_0234>-fval = 'SICH'.
    ENDIF. " IF <lst_bdcdata_0234> IS ASSIGNED

  ENDIF. " IF lst_bdcdata234-fnam = 'BDC_OKCODE'

ENDIF. " IF sy-subrc IS INITIAL
