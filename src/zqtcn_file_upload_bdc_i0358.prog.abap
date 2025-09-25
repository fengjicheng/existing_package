*&---------------------------------------------------------------------*
*&  Include           ZQTCN_FILE_UPLOAD_BDC_I0358
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for BDC of File Upload Order and Society
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   16/08/2018
* OBJECT ID: I0358
* TRANSPORT NUMBER(S): ED2K913027
*----------------------------------------------------------------------*
*** Local types declaration for XVBAK
TYPES: BEGIN OF lty_xvbak_358. "Kopfdaten
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
TYPES: END OF lty_xvbak_358.

***BOC by SAYANDAS on 9th May 2017 for ERP-1975
"Changed OCCURS 50 to OCCURS 0
TYPES: BEGIN OF lty_xvbap_358. "Position
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
TYPES: END OF lty_xvbap_358.

*** Local type declaration for item level fields
TYPES: BEGIN OF lty_item_358,
         posex   TYPE posex,      " Item Number of the Underlying Purchase Order
         vbegdat TYPE vbdat_veda, " Contract Start Date
         venddat TYPE vndat_veda, " Contract End Date
       END OF lty_item_358.

TYPES: BEGIN OF lty_item1_358,
         posex TYPE posex, " Item Number of the Underlying Purchase Order
         ihrez TYPE ihrez, " Your Reference
       END OF lty_item1_358.

*** Local work area declaration
DATA : lst_bdcdata_358   TYPE bdcdata, " Batch input: New table field structure
       lst_bdcdata9_358  TYPE bdcdata, " Batch input: New table field structure
       lst_bdcdata10_358 TYPE bdcdata, " Batch input: New table field structure
       lst_bdcdata11_358 TYPE bdcdata, " Batch input: New table field structure
       lst_idoc_358      TYPE edidd,   " Data record (IDoc)
       lst_vbap4_358     TYPE lty_xvbap_358,
       lst_xvbak_358     TYPE lty_xvbak_358.

*** Local Data declaration
DATA: lv_line_358     TYPE sytabix,    " Row Index of Internal Tables
      lv_posex_358    TYPE posnr_va,   " Sales Document Item
      lv_posex1_358   TYPE posnr_va,   " Sales Document Item
      lv_zlsch_358    TYPE char1,      " Zlsch1 of type CHAR1
      lv_psgnum_358   TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
      lv_zmeng_358    TYPE char13,     " Zmeng of type CHAR13
      lv_kwmeng_358   TYPE char15,     " Kwmeng of type CHAR15
      lv_faksk_358    TYPE faksk,      " Billing block in SD document
      lv_ihrez_358    TYPE ihrez,      " Your Reference
      lv_val2_358     TYPE char6,      " Val of type CHAR6
      lv_selkz2_358   TYPE char19,     " Selkz of type CHAR19
      lv_vbegdat3_358 TYPE dats,       " Field of type DATS
      lv_venddat3_358 TYPE dats,       " Field of type DATS
      lv_pos2_358     TYPE char3,      " Pos of type CHAR3
      lv_vbegdat2_358 TYPE d,          " Vbegdat2 of type Date
      lv_venddat2_358 TYPE d,          " Venddat2 of type Date
      lv_promo_358    TYPE zpromo,     " Promo code
      lv_fnamm_358    TYPE char10,     " Fnamm of type CHAR10
      lv_tabix1_358   TYPE sytabix,    " Row Index of Internal Tables
      lv_tabix_358    TYPE sytabix.    " Row Index of Internal Tables

DATA: li_item_358              TYPE STANDARD TABLE OF lty_item_358 INITIAL SIZE 0,
      li_item1_358             TYPE STANDARD TABLE OF lty_item1_358 INITIAL SIZE 0,
      li_bdcdata358            TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
*      lst_idoc_358             TYPE edidd,                     " Data record (IDoc)
      lst_idoc12_358           TYPE edidd,                   " Data record (IDoc)
      lst_item_358             TYPE lty_item_358,
      lst_item1_358            TYPE lty_item1_358,
      lst_e1edk35_358          TYPE e1edk35,                 " IDoc: Document Header Additional Data
      li_vbap_358              TYPE STANDARD TABLE OF lty_xvbap_358,
      li_vbap10_358            TYPE STANDARD TABLE OF lty_xvbap_358,
      lst_vbap10_358           TYPE lty_xvbap_358,
      li_di_doc4_358           TYPE STANDARD TABLE OF edidd, " Data record (IDoc)
      lst_di_doc4_358          TYPE edidd,                   " Data record (IDoc)
      lst_z1qtc_e1edp01_01_358 TYPE z1qtc_e1edp01_01,        " IDOC Segment for STATUS Field in Item Level
      lst_z1qtc_e1edk01_01_358 TYPE z1qtc_e1edk01_01,        " Header General Data Entension
      lst_e1edp01_358          TYPE e1edp01,                 " IDoc: Document Item General Data
      lst_e1edp02_358          TYPE e1edp02.                 " IDoc: Document Item Reference Data

*** Local Field Symbols
FIELD-SYMBOLS: <lst_bdcdata_358> TYPE bdcdata. " Batch input: New table field structure

***Local Constant Declaration
CONSTANTS:lc_z1qtc_e1edp01_01_358 TYPE char16 VALUE 'Z1QTC_E1EDP01_01', " Z1qtc_e1edp01_01_8 of type CHAR16
          lc_z1qtc_e1edk01_01_358 TYPE char16 VALUE 'Z1QTC_E1EDK01_01', " Z1qtc_e1edk01_01_8 of type CHAR16
          lc_e1edp02_358          TYPE char7 VALUE  'E1EDP02',          " E1edp02_358 of type CHAR7
          lc_e1edk35_358          TYPE char7  VALUE 'E1EDK35'.          " E1edk35_358 of type CHAR7
*          lc_019                  TYPE edi_iddat  VALUE '019',          " Qualifier for IDOC date segment
*          lc_020                  TYPE edi_iddat  VALUE '020'.          " Qualifier for IDOC date segment


*** Changing BDCDATA table to change contract start date and contract end date
DESCRIBE TABLE dxbdcdata LINES lv_line_358.
READ TABLE didoc_data INTO lst_idoc_358 INDEX 1.
*** Reading BDCDATA table into a work area
READ TABLE dxbdcdata INTO lst_bdcdata_358 INDEX lv_line_358.

IF li_item_358 IS INITIAL.
  li_di_doc4_358[] = didoc_data[].
  DELETE li_di_doc4_358 WHERE segnam NE lc_z1qtc_e1edp01_01_358.
  LOOP AT li_di_doc4_358 INTO lst_di_doc4_358.
    CLEAR: lst_z1qtc_e1edp01_01_358,
               lv_vbegdat3_358, lv_venddat3_358,
               lv_vbegdat2_358, lv_venddat2_358.
    lst_z1qtc_e1edp01_01_358 = lst_di_doc4_358-sdata.
    lv_posex_358 = lst_z1qtc_e1edp01_01_358-vposn.
    lv_vbegdat3_358         = lst_z1qtc_e1edp01_01_358-vbegdat. " Contract Strat Date
    lv_venddat3_358         = lst_z1qtc_e1edp01_01_358-venddat. " Contract End Date
    WRITE lv_vbegdat3_358 TO lv_vbegdat2_358.
    WRITE lv_venddat3_358 TO lv_venddat2_358.

    IF lv_posex_358 IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_posex_358
        IMPORTING
          output = lv_posex_358.

      lst_item_358-posex = lv_posex_358.
      lst_item_358-vbegdat = lv_vbegdat2_358.
      lst_item_358-venddat = lv_venddat2_358.

      APPEND lst_item_358 TO li_item_358.
      CLEAR: lst_item_358, lv_posex_358,
             lv_vbegdat2_358, lv_venddat2_358.
    ENDIF. " IF lv_posex_358 IS NOT INITIAL
  ENDLOOP. " LOOP AT li_di_doc4_358 INTO lst_di_doc4_358
  SORT li_item_358 BY posex.
  DELETE ADJACENT DUPLICATES FROM li_item_358.
ENDIF. " IF li_item_358 IS INITIAL


lst_vbap4_358 = dxvbap.

IF lst_vbap4_358-kdmat IS INITIAL.
  lv_fnamm_358 = 'VBAP-POSEX'.
ELSE. " ELSE -> IF lst_vbap4_358-kdmat IS INITIAL
  lv_fnamm_358 = 'VBAP-KDMAT'.
ENDIF. " IF lst_vbap4_358-kdmat IS INITIAL

IF lst_bdcdata_358-fnam+0(10) = lv_fnamm_358.
  lv_pos2_358 = lst_bdcdata_358-fnam+10(3).

  READ TABLE li_item_358 INTO lst_item_358 WITH KEY posex = lst_vbap4_358-posex.
  IF sy-subrc = 0.
    IF ( lst_item_358-vbegdat IS NOT INITIAL AND lst_item_358-vbegdat NE space ).

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-program = 'SAPMV45A'.
      lst_bdcdata_358-dynpro = '4001'.
      lst_bdcdata_358-dynbegin = 'X'.
      APPEND lst_bdcdata_358 TO dxbdcdata. " Appending Screen

      CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos2_358 INTO lv_selkz2_358.

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-fnam = lv_selkz2_358.
      lst_bdcdata_358-fval = 'X'.
      APPEND  lst_bdcdata_358 TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-fnam = 'BDC_OKCODE'.
      lst_bdcdata_358-fval = '=PVER'.
      APPEND  lst_bdcdata_358 TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-program = 'SAPLV45W'.
      lst_bdcdata_358-dynpro = '4001'.
      lst_bdcdata_358-dynbegin = 'X'.
      APPEND lst_bdcdata_358 TO dxbdcdata. " Appending Screen

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-fnam = 'VEDA-VBEGDAT'.
      lst_bdcdata_358-fval = lst_item_358-vbegdat.
      APPEND  lst_bdcdata_358 TO dxbdcdata. " Appending Contract Start Date

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-fnam = 'VEDA-VENDDAT'.
      lst_bdcdata_358-fval = lst_item_358-venddat.
      APPEND  lst_bdcdata_358 TO dxbdcdata. " Appending Contract End Date


      IF lst_item_358-venddat IS NOT INITIAL AND lst_item_358-venddat NE space.
        CLEAR lst_bdcdata_358.
        lst_bdcdata_358-fnam = 'VEDA-VENDREG'.
        lst_bdcdata_358-fval = space.
        APPEND  lst_bdcdata_358 TO dxbdcdata. " Appending Rule for Contract End Date
      ENDIF. " IF lst_item_358-venddat IS NOT INITIAL AND lst_item_358-venddat NE space
      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-fnam = 'BDC_OKCODE'.
      lst_bdcdata_358-fval = '/EBACK'.
      APPEND lst_bdcdata_358 TO dxbdcdata.

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-program = 'SAPMV45A'.
      lst_bdcdata_358-dynpro = '4001'.
      lst_bdcdata_358-dynbegin = 'X'.
      APPEND lst_bdcdata_358 TO dxbdcdata.
    ENDIF. " IF ( lst_item_358-vbegdat IS NOT INITIAL AND lst_item_358-vbegdat NE space )
  ENDIF. " IF sy-subrc = 0
ENDIF. " IF lst_bdcdata_358-fnam+0(10) = lv_fnamm_358
*** Reading BDCDATA table into a work area
READ TABLE dxbdcdata INTO lst_bdcdata_358 INDEX lv_line_358.
IF sy-subrc = 0.
  IF lst_bdcdata_358-fnam = 'BDC_OKCODE'
    AND lst_bdcdata_358-fval = 'SICH'.

*    lst_xvbak_358 = dxvbak.

    CLEAR lst_idoc_358.
    LOOP AT didoc_data INTO lst_idoc_358.
      CASE lst_idoc_358-segnam.
        WHEN lc_e1edp02_358.
          CLEAR: lst_e1edp02_358.
          lst_e1edp02_358 = lst_idoc_358-sdata.
          IF lst_e1edp02_358-qualf = '001'.
            lv_psgnum_358 = lst_idoc_358-psgnum.
            READ TABLE didoc_data INTO lst_idoc12_358 WITH KEY segnum = lv_psgnum_358.
            IF sy-subrc = 0.
              lst_e1edp01_358 = lst_idoc12_358-sdata.
              lv_posex1_358 = lst_e1edp01_358-posex.
              lv_ihrez_358 = lst_e1edp02_358-ihrez.
            ENDIF. " IF sy-subrc = 0
            CLEAR: lst_e1edp01_358,lst_idoc12_358,lv_psgnum_358.
          ENDIF. " IF lst_e1edp02_358-qualf = '001'
        WHEN lc_z1qtc_e1edk01_01_358.
          CLEAR: lst_z1qtc_e1edk01_01_358.
          lst_z1qtc_e1edk01_01_358 = lst_idoc_358-sdata.
          lv_zlsch_358 = lst_z1qtc_e1edk01_01_358-zlsch.
          lv_promo_358 = lst_z1qtc_e1edk01_01_358-zzpromo.

        WHEN lc_e1edk35_358.
          CLEAR: lst_e1edk35_358.
          lst_e1edk35_358 = lst_idoc_358-sdata.
          IF lst_e1edk35_358-qualz = '011'.
            lv_faksk_358 = lst_e1edk35_358-cusadd.
          ENDIF. " IF lst_e1edk35_358-qualz = '011'

*      	WHEN OTHERS.
      ENDCASE.

      IF lv_posex1_358 IS NOT INITIAL AND lv_ihrez_358 IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_posex1_358
          IMPORTING
            output = lv_posex1_358.

        lst_item1_358-posex = lv_posex1_358.
        lst_item1_358-ihrez = lv_ihrez_358.
        APPEND lst_item1_358 TO li_item1_358.

        CLEAR: lst_item1_358,
               lv_posex1_358,
               lv_ihrez_358.
      ENDIF. " IF lv_posex1_358 IS NOT INITIAL AND lv_ihrez_358 IS NOT INITIAL
    ENDLOOP. " LOOP AT didoc_data INTO lst_idoc_358

    IF dxvbap[] IS NOT INITIAL.

      li_vbap_358[] = dxvbap[].

      IF li_item1_358 IS NOT INITIAL.
        SORT li_item1_358 BY posex.
        DELETE ADJACENT DUPLICATES FROM li_item1_358.

        LOOP AT li_vbap_358 INTO DATA(lst_vbap_358).
*        Calling Conversion Exit FM
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_vbap_358-posex
            IMPORTING
              output = lst_vbap_358-posex.

          READ TABLE li_item1_358 INTO lst_item1_358 WITH KEY posex = lst_vbap_358-posex BINARY SEARCH.
          IF sy-subrc = 0.
            IF lst_item1_358-ihrez IS NOT INITIAL.
              CLEAR lst_bdcdata_358.
              lst_bdcdata_358-program = 'SAPMV45A'.
              lst_bdcdata_358-dynpro = '4001'.
              lst_bdcdata_358-dynbegin = 'X'.
              APPEND lst_bdcdata_358 TO li_bdcdata358.

              CLEAR lst_bdcdata_358.
              lst_bdcdata_358-fnam = 'BDC_OKCODE'.
              lst_bdcdata_358-fval = 'POPO'.
              APPEND lst_bdcdata_358 TO li_bdcdata358.

              CLEAR lst_bdcdata_358.
              lst_bdcdata_358-program = 'SAPMV45A'.
              lst_bdcdata_358-dynpro  =  '251'.
              lst_bdcdata_358-dynbegin   = 'X'.
              APPEND lst_bdcdata_358 TO li_bdcdata358.

              CLEAR lst_bdcdata_358.
              lst_bdcdata_358-fnam = 'RV45A-PO_POSEX'.
              lst_bdcdata_358-fval = lst_vbap_358-posex.
              APPEND lst_bdcdata_358 TO li_bdcdata358.

              CLEAR lst_bdcdata_358.
              lst_bdcdata_358-program = 'SAPMV45A'.
              lst_bdcdata_358-dynpro  =  '4001'.
              lst_bdcdata_358-dynbegin   = 'X'.
              APPEND lst_bdcdata_358 TO li_bdcdata358.

              CLEAR lst_bdcdata_358.
              lst_bdcdata_358-fnam = 'BDC_OKCODE'.
              lst_bdcdata_358-fval = 'PBES'.
              APPEND lst_bdcdata_358 TO li_bdcdata358.

              CLEAR lst_bdcdata_358.
              lst_bdcdata_358-program = 'SAPMV45A'.
              lst_bdcdata_358-dynpro  =  '4003'.
              lst_bdcdata_358-dynbegin   = 'X'.
              APPEND lst_bdcdata_358 TO li_bdcdata358.

              CLEAR lst_bdcdata_358.
              lst_bdcdata_358-fnam = 'VBKD-IHREZ'.
              lst_bdcdata_358-fval = lst_item1_358-ihrez.
              APPEND lst_bdcdata_358 TO li_bdcdata358.

              CLEAR lst_bdcdata_358.
              lst_bdcdata_358-fnam = 'BDC_OKCODE'.
              lst_bdcdata_358-fval = '/EBACK'.
              APPEND lst_bdcdata_358 TO li_bdcdata358.

              CLEAR lst_bdcdata_358.
              lst_bdcdata_358-program = 'SAPMV45A'.
              lst_bdcdata_358-dynpro  =  '4001'.
              lst_bdcdata_358-dynbegin = 'X'.
              APPEND lst_bdcdata_358 TO li_bdcdata358.
            ENDIF. " IF lst_item1_358-ihrez IS NOT INITIAL
          ENDIF. " IF sy-subrc = 0
        ENDLOOP. " LOOP AT li_vbap_358 INTO DATA(lst_vbap_358)
      ENDIF. " IF li_item1_358 IS NOT INITIAL
    ENDIF. " IF dxvbap[] IS NOT INITIAL

    IF lv_zlsch_358 IS NOT INITIAL.
      CLEAR lst_bdcdata_358. " Clearing work area for BDC data
      lst_bdcdata_358-fnam = 'BDC_OKCODE'.
      lst_bdcdata_358-fval = 'UER1'.
      APPEND  lst_bdcdata_358 TO li_bdcdata358. "appending OKCODE

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-program = 'SAPMV45A'.
      lst_bdcdata_358-dynpro = '4001'.
      lst_bdcdata_358-dynbegin = 'X'.
      APPEND lst_bdcdata_358 TO li_bdcdata358. " appending program and screen

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-fnam = 'BDC_OKCODE'.
      lst_bdcdata_358-fval = 'KBUC'.
      APPEND  lst_bdcdata_358 TO li_bdcdata358. "appending OKCODE

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-program = 'SAPMV45A'.
      lst_bdcdata_358-dynpro = '4002'.
      lst_bdcdata_358-dynbegin = 'X'.
      APPEND lst_bdcdata_358 TO li_bdcdata358. " appending program and screen

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-fnam = 'VBKD-ZLSCH'.
      lst_bdcdata_358-fval = lv_zlsch_358.
      APPEND lst_bdcdata_358 TO li_bdcdata358. " Appending Assignment

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-fnam = 'BDC_OKCODE'.
      lst_bdcdata_358-fval = '/EBACK'.
      APPEND  lst_bdcdata_358 TO li_bdcdata358. "appending OKCODE

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-program = 'SAPMV45A'.
      lst_bdcdata_358-dynpro = '4001'.
      lst_bdcdata_358-dynbegin = 'X'.
      APPEND lst_bdcdata_358 TO li_bdcdata358. " appending program and screen
    ENDIF. " IF lv_zlsch_358 IS NOT INITIAL

    IF lv_faksk_358 IS NOT INITIAL.
      CLEAR lst_bdcdata_358. " Clearing work area for BDC data
      lst_bdcdata_358-fnam = 'BDC_OKCODE'.
      lst_bdcdata_358-fval = 'UER1'.
      APPEND  lst_bdcdata_358 TO li_bdcdata358. "appending OKCODE

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-program = 'SAPMV45A'.
      lst_bdcdata_358-dynpro = '4001'.
      lst_bdcdata_358-dynbegin = 'X'.
      APPEND lst_bdcdata_358 TO li_bdcdata358. " appending program and screen

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-fnam = 'VBAK-FAKSK'.
      lst_bdcdata_358-fval = lv_faksk_358.
      APPEND lst_bdcdata_358 TO li_bdcdata358. " Appending Assignment

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-fnam = 'BDC_OKCODE'.
      lst_bdcdata_358-fval = 'UER1'.
      APPEND  lst_bdcdata_358 TO li_bdcdata358. "appending OKCODE

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-program = 'SAPMV45A'.
      lst_bdcdata_358-dynpro = '4001'.
      lst_bdcdata_358-dynbegin = 'X'.
      APPEND lst_bdcdata_358 TO li_bdcdata358. " appending program and screen
    ENDIF. " IF lv_faksk_358 IS NOT INITIAL

    IF lv_promo_358 IS NOT INITIAL. " Populating Promo Code in BDCDATA

      CLEAR lst_bdcdata_358. " Clearing work area for BDC data
      lst_bdcdata_358-fnam = 'BDC_OKCODE'.
      lst_bdcdata_358-fval = 'UER1'.
      APPEND  lst_bdcdata_358 TO li_bdcdata358. "appending OKCODE

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-program = 'SAPMV45A'.
      lst_bdcdata_358-dynpro = '4001'.
      lst_bdcdata_358-dynbegin = 'X'.
      APPEND lst_bdcdata_358 TO li_bdcdata358. " appending program and screen

      CLEAR lst_bdcdata_358. " Clearing work area for BDC data
      lst_bdcdata_358-fnam = 'BDC_OKCODE'.
      lst_bdcdata_358-fval = 'KZKU'.
      APPEND  lst_bdcdata_358 TO li_bdcdata358. "appending OKCODE

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-program = 'SAPMV45A'.
      lst_bdcdata_358-dynpro = '4002'.
      lst_bdcdata_358-dynbegin = 'X'.
      APPEND  lst_bdcdata_358 TO li_bdcdata358. "appending OKCODE

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-fnam = 'VBAK-ZZPROMO'.
      lst_bdcdata_358-fval = lv_promo_358.
      APPEND lst_bdcdata_358 TO li_bdcdata358.

      CLEAR lst_bdcdata_358. " Clearing work area for BDC data
      lst_bdcdata_358-fnam = 'BDC_OKCODE'.
      lst_bdcdata_358-fval = 'UER1'.
      APPEND  lst_bdcdata_358 TO li_bdcdata358. "appending OKCODE

      CLEAR lst_bdcdata_358.
      lst_bdcdata_358-program = 'SAPMV45A'.
      lst_bdcdata_358-dynpro = '4001'.
      lst_bdcdata_358-dynbegin = 'X'.
      APPEND lst_bdcdata_358 TO li_bdcdata358. " appending program and screen
    ENDIF. " IF lv_promo_358 IS NOT INITIAL

    DESCRIBE TABLE dxbdcdata LINES lv_tabix_358.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_358> INDEX lv_tabix_358.
    IF <lst_bdcdata_358> IS ASSIGNED.
      <lst_bdcdata_358>-fval = 'OWN_OKCODE'.
    ENDIF. " IF <lst_bdcdata_358> IS ASSIGNED
    INSERT LINES OF li_bdcdata358 INTO dxbdcdata INDEX lv_tabix_358.
  ENDIF. " IF lst_bdcdata_358-fnam = 'BDC_OKCODE'
  IF   lst_bdcdata_358-fnam = 'BDC_OKCODE'
   AND lst_bdcdata_358-fval = 'OWN_OKCODE'.

    DESCRIBE TABLE dxbdcdata LINES lv_tabix_358.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_358> INDEX lv_tabix_358.
    IF <lst_bdcdata_358> IS ASSIGNED.
      <lst_bdcdata_358>-fval = 'SICH'.
    ENDIF. " IF <lst_bdcdata_358> IS ASSIGNED

  ENDIF. " IF lst_bdcdata_358-fnam = 'BDC_OKCODE'
ENDIF. " IF sy-subrc = 0
*** Code to insert KWMENG
lst_vbap10_358 = dxvbap. " Copy the value in local work area

IF lst_vbap10_358-posnr EQ 1.
  lv_zmeng_358 = 'VBAP-ZMENG(1)'. "ZMENG Field Name
ELSE. " ELSE -> IF lst_vbap10_358-posnr EQ 1
  lv_zmeng_358 = 'VBAP-ZMENG(2)'. "ZMENG Field Name
ENDIF. " IF lst_vbap10_358-posnr EQ 1

LOOP AT dxbdcdata INTO lst_bdcdata9_358 WHERE fnam = lv_zmeng_358.
  lv_tabix1_358 = sy-tabix. " Storing the index of ZMENG
ENDLOOP. " LOOP AT dxbdcdata INTO lst_bdcdata9_358 WHERE fnam = lv_zmeng_358
IF sy-subrc = 0.
  IF lst_vbap10_358-posnr EQ 1.
    lv_kwmeng_358 = 'RV45A-KWMENG(1)'. "KWMENG Field Name
  ELSE. " ELSE -> IF lst_vbap10_358-posnr EQ 1
    lv_kwmeng_358 = 'RV45A-KWMENG(2)'. "KWMENG Field Name
  ENDIF. " IF lst_vbap10_358-posnr EQ 1

  READ TABLE dxbdcdata INTO lst_bdcdata11_358 INDEX ( lv_tabix1_358 - 1 ).
  IF sy-subrc EQ 0 AND
     lst_bdcdata11_358-fnam NE lv_kwmeng_358.

    lst_bdcdata10_358-dynpro = '0000'.
    lst_bdcdata10_358-fnam = lv_kwmeng_358.
    lst_bdcdata10_358-fval = lst_bdcdata9_358-fval.

    INSERT lst_bdcdata10_358 INTO dxbdcdata INDEX lv_tabix1_358.
    CLEAR: lst_bdcdata11_358, lst_bdcdata10_358. " appending KWMENG
  ENDIF. " IF sy-subrc EQ 0 AND
  CLEAR lst_bdcdata9_358.
ENDIF. " IF sy-subrc = 0
