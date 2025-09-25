*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU04 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for populating BDC DATA
*
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   19/08/2016
* OBJECT ID: I0230
* TRANSPORT NUMBER(S): ED2K902770
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907156
* REFERENCE NO: ERP-2772
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-07-10
* DESCRIPTION: As currently contract start date and end dates are not
*              being populated for the reprint scenario of CSS when legacy
*              system doesn't send any dates. Ideally it should have copied
*              from header contract dates. When the contract dates are passed
*              in conversion C064, C042 or interface(I230) same dates are not
*              taken into consideration. Issue is corrected now by not updating
*              the rule when there is a date.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INSUB04
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

*** Local type declaration for item level fields
TYPES: BEGIN OF lty_item,
         posex   TYPE posex,      "Item Number
         mvgr1   TYPE mvgr1,      " Material Group 1
         mvgr3   TYPE mvgr3,      " Material Group 3
         zzpromo TYPE zpromo,     " Promo Code
         zzartno TYPE zartno,     " Article Number
         vbegdat TYPE vbdat_veda, " Contract Start Date
         venddat TYPE vndat_veda, " Contract End Date
         csd     TYPE zconstart,  " Content Start Date Override
         ced     TYPE zconend,    " Content End Date Override
         lsd     TYPE zlicstar,   " License Start Date Override
         led     TYPE zlicend,    " License End Date Override
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

*** Local work area declaration
DATA: lst_bdcdata TYPE bdcdata, " Batch input: New table field structure
      lst_idoc    TYPE edidd,   " Data record (IDoc)
      lst_idoc12  TYPE edidd,   " Data record (IDoc)
      lst_xvbak   TYPE lty_xvbak,
      lst_e1edk03 TYPE e1edk03. " IDoc: Document header date segment



*** Local Data declaration
DATA: lv_line     TYPE sytabix,  " Row Index of Internal Tables
      lv_stdt     TYPE char10,   " Stdt of type CHAR10
      lv_eddt     TYPE char10,   " Eddt of type CHAR10
      lv_tabix230 TYPE sytabix,  " Row Index of Internal Tables
      lv_ihrez    TYPE ihrez,    " Your Reference
      lv_test     TYPE sy-datum. " ABAP System Field: Current Date of Application Server
*** BOC by SAYANDAS--->>>
*** Local Data Declaration
DATA : lst_vbap          TYPE lty_xvbap,
       lst_vbap4         TYPE lty_xvbap,
       li_vbap           TYPE STANDARD TABLE OF lty_xvbap,
       lst_vbap10_230    TYPE lty_xvbap,
       lst_bdcdata9_230  TYPE bdcdata,                   " Batch input: New table field structure
       lst_bdcdata10_230 TYPE bdcdata,                   " Batch input: New table field structure
       lst_bdcdata11_230 TYPE bdcdata,                   " Batch input: New table field structure
       lv_tabix1_230     TYPE syindex,                   " Loop Index
       lst_item          TYPE lty_item,
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
*       lst_item22        TYPE lty_item,
       lst_item22        TYPE ty_item,
       lv_qt_lines_230   TYPE syst_tabix,
       lst_qty_tabix_230 TYPE ty_qty_tabix_230,
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
       lst_itemcon       TYPE lty_item_con,
       li_itemcon        TYPE STANDARD TABLE OF lty_item_con,
       lst_itemlis       TYPE lty_item_lis,
       li_itemlis        TYPE STANDARD TABLE OF lty_item_lis,
       lst_item1         TYPE lty_item1,
       li_item1          TYPE STANDARD TABLE OF lty_item1,
       li_bdcdata230     TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
       li_di_doc4        TYPE STANDARD TABLE OF edidd,   " Data record (IDoc)
       lst_di_doc4       TYPE edidd,                     " Data record (IDoc)
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
*       i_item22          TYPE STANDARD TABLE OF lty_item,
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
       li_item           TYPE STANDARD TABLE OF lty_item.

DATA: lst_z1qtc_e1edp01_01_8 TYPE z1qtc_e1edp01_01, " IDOC Segment for STATUS Field in Item Level
      lst_z1qtc_e1edk01_01_8 TYPE z1qtc_e1edk01_01, " Header General Data Entension
      lst_e1edp02            TYPE e1edp02,          " IDoc: Document Item Reference Data
      lst_e1edp03            TYPE e1edp03,          " IDoc: Document Item Date Segment
      lst_e1edp01            TYPE e1edp01,          " IDoc: Document Item General Data
      lst_e1edka1_8          TYPE e1edka1,          " IDoc: Document Header Partner Information
      lv_pos2                TYPE char3,            " Pos of type CHAR3
      lv_val2                TYPE char6,            " Val of type CHAR6
      lv_selkz2              TYPE char19,           " Selkz of type CHAR19
      lv_fnamm               TYPE char10,           " Fnamm of type CHAR10
      lv_posex               TYPE posnr_va,         " Sales Document Item
      lv_posex1              TYPE posnr_va,         " Sales Document Item
      lv_posex2              TYPE posnr_va,         " Sales Document Item
      lv_posex3              TYPE posnr_va,         " Sales Document Item
      lv_mvgr1_8             TYPE mvgr1,            " Material group 1
      lv_mvgr3_8             TYPE mvgr3,            " Material group 3
      lv_1230                TYPE char1,            " 1230 of type CHAR1
      lv_ihrez_e2            TYPE ihrez_e,          " Ship-to party character
      lv_artno1              TYPE zartno,           " Article Number
      lv_zzpromo             TYPE zpromo,           " Promo code
      lv_promo_8             TYPE zpromo,           " Promo code
      lv_vbegdat2            TYPE d,                " Vbegdat2 of type Date
      lv_venddat2            TYPE d,                " Venddat2 of type Date
*** for content and license date
      lv_psgnum              TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
      lv_csd                 TYPE d,          " Csd of type Date
      lv_ced                 TYPE d,          " Ced of type Date
      lv_csd1                TYPE dats,       " Field of type DATS
      lv_ced1                TYPE dats,       " Field of type DATS
      lv_lsd                 TYPE d,          " Lsd of type Date
      lv_led                 TYPE d,          " Led of type Date
      lv_lsd1                TYPE dats,       " Field of type DATS
      lv_led1                TYPE dats,       " Field of type DATS
      lv_zmeng_230           TYPE char13,     " Zmeng of type CHAR13
      lv_kwmeng_230          TYPE char15,     " Kwmeng of type CHAR15
*** Change for FKDAT
      lv_fkdat1_230          TYPE dats, " Field of type DATS
      lv_fkdat_230           TYPE d,    " Fkdat_230 of type Date
*** Chaange for FKDAT
*** for content and license date
      lv_vbegdat3            TYPE dats, " Field of type DATS
      lv_venddat3            TYPE dats. " Field of type DATS

*** Local Field Symbols
FIELD-SYMBOLS: <lst_bdcdata_0230> TYPE bdcdata. " Batch input: New table field structure
***<<<--- EOC by SAYANDAS

***Local Constant Declaration
CONSTANTS: lc_e1edk03_1          TYPE char7 VALUE 'E1EDK03',           " E1edk03_1 of type CHAR7
           lc_z1qtc_e1edp01_01_8 TYPE char16 VALUE 'Z1QTC_E1EDP01_01', " Z1qtc_e1edp01_01_8 of type CHAR16
           lc_z1qtc_e1edk01_01_8 TYPE char16 VALUE 'Z1QTC_E1EDK01_01', " Z1qtc_e1edk01_01_8 of type CHAR16
           lc_e1edp02_8          TYPE char7 VALUE 'E1EDP02',           " E1edp02_8 of type CHAR7
           lc_e1edp03_8          TYPE char7 VALUE 'E1EDP03',           " E1edp03_8 of type CHAR7
           lc_e1edka1_8          TYPE char7 VALUE 'E1EDKA1',           " E1edka1_8 of type CHAR7
           lc_we_8               TYPE parvw VALUE 'WE',                " Partner Function
           lc_csd                TYPE edi_iddat VALUE 'CSD',           " Qualifier for IDOC date segment
           lc_ced                TYPE edi_iddat VALUE 'CED',           " Qualifier for IDOC date segment
           lc_lsd                TYPE edi_iddat VALUE 'LSD',           " Qualifier for IDOC date segment
           lc_led                TYPE edi_iddat VALUE 'LED',           " Qualifier for IDOC date segment
*** Change for FKDAT
           lc_016                TYPE edi_iddat VALUE '016', " Qualifier for IDOC date segment
*** Change for FKDAT
           lc_019                TYPE edi_iddat VALUE '019', " Qualifier for IDOC date segment
           lc_020                TYPE edi_iddat VALUE '020'. " Qualifier for IDOC date segment


*** Changing BDCDATA table to change contract start date and contract end date


DESCRIBE TABLE dxbdcdata LINES lv_line.
READ TABLE didoc_data INTO lst_idoc INDEX 1.
*** Reading BDCDATA table into a work area
READ TABLE dxbdcdata INTO lst_bdcdata INDEX lv_line.

* BOC for BOM Material *
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
IF i_item22 IS INITIAL.
  li_di_doc4[] = didoc_data[].
  DELETE li_di_doc4 WHERE segnam NE lc_z1qtc_e1edp01_01_8.
  LOOP AT li_di_doc4 INTO lst_di_doc4.
    CLEAR: lst_z1qtc_e1edp01_01_8,
            lv_vbegdat3,lv_venddat3,
           lv_vbegdat2,lv_venddat2.
    lst_z1qtc_e1edp01_01_8 = lst_di_doc4-sdata.
    lv_posex = lst_z1qtc_e1edp01_01_8-vposn.
*    lv_traty1           = lst_z1qtc_e1edp01_01_9-traty. " Transportation Type
    lv_zzpromo          = lst_z1qtc_e1edp01_01_8-zzpromo.
    lv_artno1           = lst_z1qtc_e1edp01_01_8-zzartno.
    lv_vbegdat3         = lst_z1qtc_e1edp01_01_8-vbegdat. " Contract Strat Date
    lv_venddat3         = lst_z1qtc_e1edp01_01_8-venddat. " Contract End Date
    WRITE lv_vbegdat3 TO lv_vbegdat2.
    WRITE lv_venddat3 TO lv_venddat2.

    lv_csd1            = lst_z1qtc_e1edp01_01_8-zzcontent_start_d.
    lv_ced1            = lst_z1qtc_e1edp01_01_8-zzcontent_end_d.
    lv_lsd1            = lst_z1qtc_e1edp01_01_8-zzlicense_start_d.
    lv_led1            = lst_z1qtc_e1edp01_01_8-zzlicense_end_d.

    WRITE lv_csd1 TO lv_csd.
    WRITE lv_ced1 TO lv_ced.
    WRITE lv_lsd1 TO lv_lsd.
    WRITE lv_led1 TO lv_led.


    IF lv_posex IS NOT INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_posex
        IMPORTING
          output = lv_posex.

      lst_item22-posex = lv_posex.
      lst_item22-vbegdat = lv_vbegdat2.
      lst_item22-venddat = lv_venddat2.
      lst_item22-zzpromo = lv_zzpromo.
      lst_item22-zzartno = lv_artno1.
      lst_item22-csd     = lv_csd.
      lst_item22-ced     = lv_ced.
      lst_item22-lsd     = lv_lsd.
      lst_item22-led     = lv_led.

      APPEND lst_item22 TO i_item22.
      CLEAR: lst_item22, lv_posex,
             lv_vbegdat2, lv_venddat2.
    ENDIF. " IF lv_posex IS NOT INITIAL
  ENDLOOP. " LOOP AT li_di_doc4 INTO lst_di_doc4

  SORT i_item22 BY posex.
  DELETE ADJACENT DUPLICATES FROM i_item22.
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
ENDIF.
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888

lst_vbap4 = dxvbap.

IF lst_vbap4-kdmat IS INITIAL.
  lv_fnamm = 'VBAP-POSEX'.
ELSE. " ELSE -> IF lst_vbap4-kdmat IS INITIAL
  lv_fnamm = 'VBAP-KDMAT'.
ENDIF. " IF lst_vbap4-kdmat IS INITIAL

IF lst_bdcdata-fnam+0(10) = lv_fnamm.
  lv_pos2 = lst_bdcdata-fnam+10(3).

  READ TABLE i_item22 INTO lst_item22 WITH KEY posex = lst_vbap4-posex.
  IF sy-subrc = 0.

    IF lst_item22 IS NOT INITIAL.

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO dxbdcdata. " Appending Screen

* Begin of Insert by PBANDLAPAL on 10-Jul-2017 for ERP-2772
*     IF lst_item22-vbegdat IS NOT INITIAL.
      IF lst_item22-vbegdat IS NOT INITIAL AND lst_item22-vbegdat NE space.
* End of Insert by PBANDLAPAL on 10-Jul-2017 for ERP-2772

        CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos2 INTO lv_selkz2.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = lv_selkz2.
        lst_bdcdata-fval = 'X'.
        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE


        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '=PVER'.
        APPEND  lst_bdcdata TO dxbdcdata. "appending OKCODE


        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPLV45W'.
        lst_bdcdata-dynpro = '4001'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO dxbdcdata. " Appending Screen

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VEDA-VBEGDAT'.
        lst_bdcdata-fval = lst_item22-vbegdat.
        APPEND  lst_bdcdata TO dxbdcdata. " Appending Contract Start Date

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VEDA-VENDDAT'.
        lst_bdcdata-fval = lst_item22-venddat.
        APPEND  lst_bdcdata TO dxbdcdata. " Appending Contract End Date

* Begin of Change by PBNADLAPAL on 11-Jul-2017 for ERP-2772
        IF lst_item22-venddat IS NOT INITIAL.
          CLEAR lst_bdcdata.
          lst_bdcdata-fnam = 'VEDA-VENDREG'.
          lst_bdcdata-fval = space.
          APPEND  lst_bdcdata TO dxbdcdata. " Appending Rule for Contract End Date
        ENDIF.
* End of Change by PBNADLAPAL on 11-Jul-2017 for ERP-2772

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_OKCODE'.
        lst_bdcdata-fval = '/EBACK'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-program = 'SAPMV45A'.
        lst_bdcdata-dynpro = '4001'.
        lst_bdcdata-dynbegin = 'X'.
        APPEND lst_bdcdata TO dxbdcdata.
      ENDIF. " IF lst_item22-vbegdat IS NOT INITIAL

      IF lst_item22-zzpromo IS NOT INITIAL.

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

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_CURSOR'.
        lst_bdcdata-fval = 'VBAP-ZZPROMO'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAP-ZZPROMO'.
        lst_bdcdata-fval = lst_item22-zzpromo.
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
      ENDIF. " IF lst_item22-zzpromo IS NOT INITIAL

      IF lst_item22-zzartno IS NOT INITIAL.

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

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_CURSOR'.
        lst_bdcdata-fval = 'VBAP-ZZARTNO'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAP-ZZARTNO'.
        lst_bdcdata-fval = lst_item22-zzartno.
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
      ENDIF. " IF lst_item22-zzartno IS NOT INITIAL

      IF lst_item22-csd IS NOT INITIAL.
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

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_CURSOR'.
        lst_bdcdata-fval = 'VBAP-ZZCONSTART'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAP-ZZCONSTART'.
        lst_bdcdata-fval = lst_item22-csd.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_CURSOR'.
        lst_bdcdata-fval = 'VBAP-ZZCONEND'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAP-ZZCONEND'.
        lst_bdcdata-fval = lst_item22-ced.
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

      ENDIF. " IF lst_item22-csd IS NOT INITIAL

      IF lst_item22-lsd IS NOT INITIAL.
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

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_CURSOR'.
        lst_bdcdata-fval = 'VBAP-ZZLICSTART'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAP-ZZLICSTART'.
        lst_bdcdata-fval = lst_item22-lsd.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'BDC_CURSOR'.
        lst_bdcdata-fval = 'VBAP-ZZLICEND'.
        APPEND lst_bdcdata TO dxbdcdata.

        CLEAR lst_bdcdata.
        lst_bdcdata-fnam = 'VBAP-ZZLICEND'.
        lst_bdcdata-fval = lst_item22-led.
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

      ENDIF. " IF lst_item22-lsd IS NOT INITIAL

    ENDIF. " IF lst_item22 IS NOT INITIAL
  ENDIF. " IF sy-subrc = 0
ENDIF. " IF lst_bdcdata-fnam+0(10) = lv_fnamm

* EOC for BOM Material*
*** Reading BDCDATA table into a work area
READ TABLE dxbdcdata INTO lst_bdcdata INDEX lv_line.
IF sy-subrc IS INITIAL.
*    IF lst_bdcdata-fnam = 'RV45A-DOCNUM'
*      AND lst_bdcdata-fval = lst_idoc-docnum.
  IF lst_bdcdata-fnam = 'BDC_OKCODE'
  AND lst_bdcdata-fval = 'SICH'.
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
**** Change for FKDAT
          ELSEIF lst_e1edk03-iddat = lc_016.

            lv_fkdat1_230 = lst_e1edk03-datum.
            WRITE lv_fkdat1_230 TO lv_fkdat_230.
*** Change for FKDAT
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
****** Code for content start date and end date
*        WHEN lc_e1edp03_8.
*          CLEAR: lst_e1edp03.
*
*          lst_e1edp03 = lst_idoc-sdata.
*          IF lst_e1edp03-iddat = lc_csd.
*            lv_psgnum = lst_idoc-psgnum.
*            READ TABLE didoc_data INTO lst_idoc12 WITH KEY segnum = lv_psgnum.
*            IF sy-subrc = 0.
*              lst_e1edp01 = lst_idoc12-sdata.
*              lv_posex2 = lst_e1edp01-posex.
*            ENDIF. " IF sy-subrc = 0
*            lv_csd1 = lst_e1edp03-datum.
*            WRITE lv_csd1   TO lv_csd.
*          ENDIF. " IF lst_e1edp03-iddat = lc_csd
*
*          IF lst_e1edp03-iddat = lc_ced.
*            lv_psgnum = lst_idoc-psgnum.
*            READ TABLE didoc_data INTO lst_idoc12 WITH KEY segnum = lv_psgnum.
*            IF sy-subrc = 0.
*              lst_e1edp01 = lst_idoc12-sdata.
*              lv_posex2 = lst_e1edp01-posex.
*            ENDIF. " IF sy-subrc = 0
*            lv_ced1 = lst_e1edp03-datum.
*            WRITE lv_ced1 TO lv_ced.
*          ENDIF. " IF lst_e1edp03-iddat = lc_ced
*
*          IF lst_e1edp03-iddat = lc_lsd.
*            lv_psgnum = lst_idoc-psgnum.
*            READ TABLE didoc_data INTO lst_idoc12 WITH KEY segnum = lv_psgnum.
*            IF sy-subrc = 0.
*              lst_e1edp01 = lst_idoc12-sdata.
*              lv_posex3 = lst_e1edp01-posex.
*            ENDIF. " IF sy-subrc = 0
*            lv_lsd1 = lst_e1edp03-datum.
*            WRITE lv_lsd1 TO lv_lsd.
*          ENDIF. " IF lst_e1edp03-iddat = lc_lsd
*
*          IF lst_e1edp03-iddat = lc_led.
*            lv_psgnum = lst_idoc-psgnum.
*            READ TABLE didoc_data INTO lst_idoc12 WITH  KEY segnum = lv_psgnum.
*            IF sy-subrc = 0.
*              lst_e1edp01 = lst_idoc12-sdata.
*              lv_posex3 = lst_e1edp01-posex.
*            ENDIF. " IF sy-subrc = 0
*            lv_led1 = lst_e1edp03-datum.
*            WRITE lv_led1 TO lv_led.
*          ENDIF. " IF lst_e1edp03-iddat = lc_led
***** code for content start date and end date
        WHEN lc_z1qtc_e1edk01_01_8.
          CLEAR:lst_z1qtc_e1edk01_01_8, lv_promo_8.
          lst_z1qtc_e1edk01_01_8 = lst_idoc-sdata.
          lv_promo_8 = lst_z1qtc_e1edk01_01_8-zzpromo.

      ENDCASE.
***** code for content and license date
*      IF lv_posex2 IS NOT INITIAL.
*        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*          EXPORTING
*            input  = lv_posex2
*          IMPORTING
*            output = lv_posex2.
*
*        IF lv_csd IS NOT INITIAL.
*
*          lst_itemcon-posex = lv_posex2.
*          lst_itemcon-csd = lv_csd.
**        lst_itemcon-ced = lv_ced.
*          APPEND lst_itemcon TO li_itemcon.
*          CLEAR: lst_itemcon,lv_posex2,
*                 lv_csd.
*        ENDIF. " IF lv_csd IS NOT INITIAL
*
*        IF lv_ced IS NOT INITIAL.
*          lst_itemcon-posex = lv_posex2.
*          lst_itemcon-ced = lv_ced.
*          MODIFY li_itemcon FROM lst_itemcon TRANSPORTING ced WHERE posex = lv_posex2.
*          CLEAR: lv_ced.
*        ENDIF. " IF lv_ced IS NOT INITIAL
*
*      ENDIF. " IF lv_posex2 IS NOT INITIAL
*
*      IF lv_posex3 IS NOT INITIAL.
*        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*          EXPORTING
*            input  = lv_posex3
*          IMPORTING
*            output = lv_posex3.
*        IF lv_lsd IS NOT INITIAL.
*
*          lst_itemlis-posex = lv_posex3.
*          lst_itemlis-lsd = lv_lsd.
**        lst_itemlis-led = lv_led.
*          APPEND lst_itemlis TO li_itemlis.
*          CLEAR: lst_itemlis, lv_posex3,
*                 lv_lsd.
*        ENDIF. " IF lv_lsd IS NOT INITIAL
*
*        IF lv_led IS NOT INITIAL.
*          lst_itemlis-posex = lv_posex3.
*          lst_itemlis-led = lv_led.
*          MODIFY li_itemlis FROM lst_itemlis TRANSPORTING led WHERE posex = lv_posex3.
*          CLEAR: lv_led.
*        ENDIF. " IF lv_led IS NOT INITIAL
*      ENDIF. " IF lv_posex3 IS NOT INITIAL
***** code for content and license date
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

    IF lv_stdt IS NOT INITIAL.
      CLEAR lst_bdcdata. " Clearing work area for BDC data

      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER1'.
      APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE


      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen

      lst_xvbak = dxvbak. " Putting VBAK data in local work area

*      CLEAR lst_bdcdata.
*      lst_bdcdata-fnam = 'KUAGV-KUNNR'.
*      lst_bdcdata-fval = lst_xvbak-kunnr.
*      APPEND lst_bdcdata TO dxbdcdata. " appending KUNNR
*
*      CLEAR lst_bdcdata.
*      lst_bdcdata-fnam = 'KUAGV-KUNNR'.
*      lst_bdcdata-fval = lst_xvbak-kunnr.
*      APPEND lst_bdcdata TO dxbdcdata.  "appending KUNNR

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'VEDA-VBEGDAT'.
      lst_bdcdata-fval = lv_stdt.
      APPEND lst_bdcdata TO li_bdcdata230. " appending contract start date

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'VEDA-VENDDAT'.
      lst_bdcdata-fval = lv_eddt.
      APPEND lst_bdcdata TO li_bdcdata230. " appending contract end date

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

    ENDIF. " IF lv_stdt IS NOT INITIAL

    IF lv_promo_8 IS NOT INITIAL.

      CLEAR lst_bdcdata. " Clearing work area for BDC data
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER1'.
      APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE


      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen

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
      APPEND lst_bdcdata TO li_bdcdata230.

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4002'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO li_bdcdata230.

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'VBAK-ZZPROMO'.
      lst_bdcdata-fval = lv_promo_8.
      APPEND lst_bdcdata TO li_bdcdata230.

      CLEAR lst_bdcdata. " Clearing work area for BDC data
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER1'.
      APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE


      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen

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

*** Change for FKDAT
    IF lv_fkdat_230 IS NOT INITIAL.
      CLEAR lst_bdcdata. " Clearing work area for BDC data
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER1'.
      APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'KDE3'.
      APPEND lst_bdcdata TO li_bdcdata230. "appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4002'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'VBKD-FKDAT'.
      lst_bdcdata-fval = lv_fkdat_230.
      APPEND lst_bdcdata TO li_bdcdata230. " Appending Assignment

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = '/EBACK'.
      APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen


    ENDIF. " IF lv_fkdat_230 IS NOT INITIAL
*** Change for FKDAT

    IF lv_ihrez_e2 IS NOT INITIAL.
      CLEAR lst_bdcdata. " Clearing work area for BDC data
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = 'UER1'.
      APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = '=KBES'.
      APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4002'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'BDC_CURSOR'.
      lst_bdcdata-fval = 'VBKD-IHREZ_E'.
      APPEND lst_bdcdata TO li_bdcdata230.

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'VBKD-IHREZ_E'.
      lst_bdcdata-fval = lv_ihrez_e2.
      APPEND lst_bdcdata TO li_bdcdata230. " Appending Assignment

      CLEAR lst_bdcdata.
      lst_bdcdata-fnam = 'BDC_OKCODE'.
      lst_bdcdata-fval = '/EBACK'.
      APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE

      CLEAR lst_bdcdata.
      lst_bdcdata-program = 'SAPMV45A'.
      lst_bdcdata-dynpro = '4001'.
      lst_bdcdata-dynbegin = 'X'.
      APPEND lst_bdcdata TO li_bdcdata230. " appending program and screen
    ENDIF. " IF lv_ihrez_e2 IS NOT INITIAL
***<<<--- BOC by SAYANDAS

    CLEAR lst_bdcdata. " Clearing work area for BDC data
    lst_bdcdata-fnam = 'BDC_OKCODE'.
    lst_bdcdata-fval = 'UER1'.
    APPEND  lst_bdcdata TO li_bdcdata230. "appending OKCODE

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
            IF lst_item1-ihrez IS NOT INITIAL.
              CLEAR:  lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'POPO'.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '251'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-fnam = 'RV45A-PO_POSEX'.
              lst_bdcdata-fval = lst_vbap-posex.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4001'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = 'PBES'.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4003'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'VBKD-IHREZ'.
              lst_bdcdata-fval = lst_item1-ihrez.
              APPEND lst_bdcdata TO li_bdcdata230.


              CLEAR: lst_bdcdata.
              lst_bdcdata-fnam = 'BDC_OKCODE'.
              lst_bdcdata-fval = '/EBACK'.
              APPEND lst_bdcdata TO li_bdcdata230.

              CLEAR:  lst_bdcdata.
              lst_bdcdata-program = 'SAPMV45A'.
              lst_bdcdata-dynpro  =  '4001'.
              lst_bdcdata-dynbegin   = 'X'.
              APPEND lst_bdcdata TO li_bdcdata230.
            ENDIF. " IF lst_item1-ihrez IS NOT INITIAL
          ENDIF. " IF sy-subrc = 0
        ENDLOOP. " LOOP AT li_vbap INTO lst_vbap

      ENDIF. " IF li_item1 IS NOT INITIAL
******** code for ihrez
******** code for content and license date
*      IF li_itemcon IS NOT INITIAL.
*        SORT li_itemcon BY posex.
*        DELETE ADJACENT DUPLICATES FROM li_itemcon.
*        LOOP AT li_vbap INTO lst_vbap.
*          CLEAR: lst_bdcdata.
*          lst_bdcdata-program = 'SAPMV45A'.
*          lst_bdcdata-dynpro = '4001'.
*          lst_bdcdata-dynbegin = 'X'.
*          APPEND lst_bdcdata TO li_bdcdata230.
**        Calling Conversion Exit FM
*          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*            EXPORTING
*              input  = lst_vbap-posex
*            IMPORTING
*              output = lst_vbap-posex.
*          READ TABLE li_itemcon INTO lst_itemcon WITH KEY posex = lst_vbap-posex.
*          IF sy-subrc = 0.
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
*          ENDIF. " IF sy-subrc = 0
*        ENDLOOP. " LOOP AT li_vbap INTO lst_vbap
*      ENDIF. " IF li_itemcon IS NOT INITIAL
*
*      IF li_itemlis IS NOT INITIAL.
*        SORT li_itemlis BY posex.
*        DELETE ADJACENT DUPLICATES FROM li_itemlis.
*        LOOP AT li_vbap INTO lst_vbap.
*          CLEAR: lst_bdcdata.
*          lst_bdcdata-program = 'SAPMV45A'.
*          lst_bdcdata-dynpro = '4001'.
*          lst_bdcdata-dynbegin = 'X'.
*          APPEND lst_bdcdata TO li_bdcdata230.
**        Calling Conversion Exit FM
*          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*            EXPORTING
*              input  = lst_vbap-posex
*            IMPORTING
*              output = lst_vbap-posex.
*          READ TABLE li_itemlis INTO lst_itemlis WITH KEY posex = lst_vbap-posex.
*          IF sy-subrc = 0.
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
*          ENDIF. " IF sy-subrc = 0
*        ENDLOOP. " LOOP AT li_vbap INTO lst_vbap
*      ENDIF. " IF li_itemlis IS NOT INITIAL
******* code for content and license date

* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
*      IF li_item IS NOT INITIAL.
*
*        SORT li_item BY posex.
*        DELETE ADJACENT DUPLICATES FROM li_item.
*
*
*        LOOP AT li_vbap INTO lst_vbap.
*
*          CLEAR: lst_bdcdata.
*          lst_bdcdata-program = 'SAPMV45A'.
*          lst_bdcdata-dynpro = '4001'.
*          lst_bdcdata-dynbegin = 'X'.
*          APPEND lst_bdcdata TO li_bdcdata230.
**        Calling Conversion Exit FM
*          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*            EXPORTING
*              input  = lst_vbap-posex
*            IMPORTING
*              output = lst_vbap-posex.
*
*          READ TABLE li_item INTO lst_item WITH  KEY posex = lst_vbap-posex BINARY SEARCH.
*          IF sy-subrc = 0.
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
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
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
*          ENDIF. " IF sy-subrc = 0
*        ENDLOOP. " LOOP AT li_vbap INTO lst_vbap
*      ENDIF. " IF li_item IS NOT INITIAL
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
    ENDIF. " IF dxvbap[] IS NOT INITIAL

    DESCRIBE TABLE dxbdcdata LINES lv_tabix230.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0230> INDEX lv_tabix230.
    IF <lst_bdcdata_0230> IS ASSIGNED.
      <lst_bdcdata_0230>-fval = 'OWN_OKCODE'.
    ENDIF. " IF <lst_bdcdata_0230> IS ASSIGNED
    INSERT LINES OF li_bdcdata230 INTO dxbdcdata INDEX lv_tabix230.


***EOC by SAYANDAS--->>>
  ENDIF. " IF lst_bdcdata-fnam = 'BDC_OKCODE'

  IF   lst_bdcdata-fnam = 'BDC_OKCODE'
   AND lst_bdcdata-fval = 'OWN_OKCODE'.

    DESCRIBE TABLE dxbdcdata LINES lv_tabix230.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0230> INDEX lv_tabix230.
    IF <lst_bdcdata_0230> IS ASSIGNED.
      <lst_bdcdata_0230>-fval = 'SICH'.
    ENDIF. " IF <lst_bdcdata_0230> IS ASSIGNED

  ENDIF. " IF lst_bdcdata-fnam = 'BDC_OKCODE'

ENDIF. " IF sy-subrc IS INITIAL

*** Code to insert KWMENG
lst_vbap10_230 = dxvbap. " Copy the value in local work area

* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
IF v_vbtyp_flg_230 = abap_true.
  READ TABLE i_qty_tabix_230 INTO lst_qty_tabix_230
                             WITH KEY posnr = lst_vbap10_230-posnr.
  IF sy-subrc NE 0.
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
    IF lst_vbap10_230-posnr EQ 1.
      lv_zmeng_230 = 'VBAP-ZMENG(1)'. "ZMENG Field Name
    ELSE. " ELSE -> IF lst_vbap10_230-posnr EQ 1
      lv_zmeng_230 = 'VBAP-ZMENG(2)'. "ZMENG Field Name
    ENDIF. " IF lst_vbap10_230-posnr EQ 1

* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
*LOOP AT dxbdcdata INTO lst_bdcdata9_230 WHERE fnam = lv_zmeng_230.
    DESCRIBE TABLE i_qty_tabix_230 LINES lv_qt_lines_230.
    IF lv_qt_lines_230 GE 1.
      READ TABLE i_qty_tabix_230 INTO lst_qty_tabix_230 INDEX lv_qt_lines_230.
      IF sy-subrc EQ 0.
        LOOP AT dxbdcdata INTO lst_bdcdata9_230 FROM lst_qty_tabix_230-tabix
                                                WHERE fnam = lv_zmeng_230.
          lv_tabix1_230 = sy-tabix. " Storing the index of ZMENG
        ENDLOOP. " LOOP AT dxbdcdata INTO lst_bdcdata9_230 WHERE fnam = lv_zmeng_230
      ENDIF.
    ELSE.
      LOOP AT dxbdcdata INTO lst_bdcdata9_230 WHERE fnam = lv_zmeng_230.
        lv_tabix1_230 = sy-tabix. " Storing the index of ZMENG
      ENDLOOP. " LOOP AT dxbdcdata INTO lst_bdcdata9_230 WHERE fnam = lv_zmeng_230
    ENDIF.
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
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
        lst_qty_tabix_230-posnr = lst_vbap10_230-posnr.
        lst_qty_tabix_230-tabix = lv_tabix1_230.
        APPEND lst_qty_tabix_230 TO i_qty_tabix_230.
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
        CLEAR: lst_bdcdata11_230,
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
               lst_qty_tabix_230,
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
               lst_bdcdata10_230. " appending KWMENG
      ENDIF. " IF sy-subrc EQ 0 AND
      CLEAR lst_bdcdata9_230.
    ENDIF. " IF sy-subrc = 0
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888

  ENDIF.  " sy-subrc check of READ TABLE i_qty_tabix_230
ENDIF. " IF v_vbtyp_flg_230 = abap_true.
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K907888
