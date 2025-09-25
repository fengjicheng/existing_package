*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INSO_BDC_I0212_17
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INSO_BDC_I0212_17 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Inbound Sales Order
* DEVELOPER: SAYANDAS ( Sayantan Das )
* CREATION DATE:   09/03/2017
* OBJECT ID: I0212.17
* TRANSPORT NUMBER(S):   ED2K904859
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K907358
* REFERENCE NO: INC0194433
* DEVELOPER: SAYANDAS ( Sayantan Das )
* DATE:  2018-05-17
* DESCRIPTION: Program logic has been added to update content start date
*              content end date, License start date and License end date
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
*** Local types declaration for XVBAK
TYPES: BEGIN OF lty_xvbak10. "Kopfdaten
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
TYPES: END OF lty_xvbak10.

*****
"Changed OCCURS 50 to OCCURS 0
TYPES: BEGIN OF lty_xvbap10. "Position
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
TYPES: END OF lty_xvbap10.
*****

TYPES: BEGIN OF lty_item10,
         posex   TYPE posex,      " Item Number of the Underlying Purchase Order
         vbegdat TYPE vbdat_veda, " Contract start date
         venddat TYPE vndat_veda, " Contract end date
         zzpromo TYPE zpromo,     " Promo Code
         artno   TYPE zartno,     " Article Number
*         traty   TYPE traty,      " Means-of-Transport Type
*** BOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358
         csd     TYPE zconstart, " Content Start Date Override
         ced     TYPE zconend,   " Content End Date Override
         lsd     TYPE zlicstar,  " License Start Date Override
         led     TYPE zlicend,   " License End Date Override
*** EOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358
       END OF lty_item10.

*** Local work area declaration
DATA: lst_bdcdata12 TYPE bdcdata,                   " Batch input: New table field structure
      lst_idoc10    TYPE edidd,                     " Data record (IDoc)
      lst_xvbak10   TYPE lty_xvbak10,
      lst_xvbak10k  TYPE lty_xvbak10,
      lst_vbap11    TYPE lty_xvbap10,
      li_vbap10     TYPE STANDARD TABLE OF lty_xvbap10,
      lst_vbap10k   TYPE lty_xvbap10,
      lst_item10    TYPE lty_item10,
      li_bdcdata212 TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
      lst_bdcdata17 TYPE bdcdata,                   " Batch input: New table field structure
      lst_bdcdata18 TYPE bdcdata,                   " Batch input: New table field structure
      lst_bdcdata19 TYPE bdcdata,                   " Batch input: New table field structure
      li_item10     TYPE STANDARD TABLE OF lty_item10.

*** Local Data declaration
DATA: lv_line10               TYPE sytabix,          " Row Index of Internal Tables
      lst_e1edk03_10          TYPE e1edk03,          " IDoc: Document header date segment
      lst_e1edka1_10          TYPE e1edka1,          " IDoc: Document Header Partner Information
      lst_z1qtc_e1edp01_01_10 TYPE z1qtc_e1edp01_01, " IDOC Segment for STATUS Field in Item Level
      lv_posex10              TYPE posnr_va,         " Sales Document Item
      lv_ihrez_e1             TYPE ihrez_e,          " Ship-to party character
      lv_2121                 TYPE char1,            " 2121 of type CHAR1
      lv_tabix3               TYPE syindex,          " Loop Index
      lv_zmeng2               TYPE char13,           " Zmeng of type CHAR13
      lv_kwmeng2              TYPE char15,           " Kwmeng of type CHAR15
      lv_auart                TYPE auart,            " Sales Document Type
      lv_stdt10               TYPE char10,           " Stdt9 of type CHAR10
      lv_eddt10               TYPE char10,           " Eddt9 of type CHAR10
      lv_test10               TYPE sy-datum,         " ABAP System Field: Current Date of Application Server
      lv_tabix212             TYPE sytabix,          " Row Index of Internal Tables
      lv_zzpromo12            TYPE zpromo,           " Promo code
      lv_vbtyp                TYPE vbtyp,            " SD document category
      lv_vbegdat4             TYPE d,                " Vbegdat of type Date
      lv_venddat4             TYPE d,                " Venddat of type Date
      lv_vbegdat5             TYPE dats,             " Field of type DATS
      lv_venddat5             TYPE dats,             " Field of type DATS
      lv_artno12              TYPE zartno,           " Article Number
      lv_date10               TYPE d,                " System Date
      lv_date101              TYPE dats,             " Field of type DATS
*** BOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358
      lv_csd_212              TYPE d,    " Csd of type Date
      lv_ced_212              TYPE d,    " Ced of type Date
      lv_csd1_212             TYPE dats, " Field of type DATS
      lv_ced1_212             TYPE dats, " Field of type DATS
      lv_lsd_212              TYPE d,    " Lsd of type Date
      lv_led_212              TYPE d,    " Led of type Date
      lv_lsd1_212             TYPE dats, " Field of type DATS
      lv_led1_212             TYPE dats. " Field of type DATS
*** EOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358

*** Local Field Symbols
FIELD-SYMBOLS: <lst_bdcdata_0212> TYPE bdcdata. " Batch input: New table field structure

*** local Constant declaration
CONSTANTS: lc_e1edk03_10          TYPE char7 VALUE 'E1EDK03',           " E1edk03_9 of type CHAR7
           lc_e1edka1_10          TYPE char7 VALUE 'E1EDKA1',           " E1edka1_10 of type CHAR7
           lc_we_10               TYPE parvw VALUE 'WE',                " Partner Function
           lc_g                   TYPE vbtyp VALUE 'G',                 " SD document category
           lc_z1qtc_e1edp01_01_10 TYPE char16 VALUE 'Z1QTC_E1EDP01_01', " Z1qtc_e1edp01_01_9 of type CHAR16
           lc_022_10              TYPE edi_iddat VALUE '022',           " Qualifier for IDOC date segment
           lc_019_10              TYPE edi_iddat VALUE '019',           " Qualifier for IDOC date segment
           lc_020_10              TYPE edi_iddat VALUE '020'.           " Qualifier for IDOC date segment

*** getting number of lines in BDCDATA
DESCRIBE TABLE dxbdcdata LINES lv_line10.
* Read the Idoc Number from Idoc Data
READ TABLE didoc_data INTO lst_idoc10 INDEX 1.
* Reading BDCDATA table into a work area using last index
READ TABLE dxbdcdata INTO lst_bdcdata12 INDEX lv_line10.
IF sy-subrc IS INITIAL.
*   Check the FNAM and FVAL value of the Lst entry of BDCDATA
*   This is to restrict the execution of the code
  IF lst_bdcdata12-fnam = 'BDC_OKCODE'
     AND lst_bdcdata12-fval = 'SICH'.

    CLEAR lst_idoc10.
    lst_xvbak10 = dxvbak.

    LOOP AT didoc_data INTO lst_idoc10.
      CASE lst_idoc10-segnam.
        WHEN lc_e1edk03_10.
          lst_e1edk03_10 = lst_idoc10-sdata.

          IF lst_e1edk03_10-iddat = lc_022_10. " Billing Date
            lv_date101 = lst_e1edk03_10-datum.
            WRITE lv_date101 TO lv_date10.

          ELSEIF lst_e1edk03_10-iddat = lc_019_10. " Contract Start Date
            WRITE  lst_e1edk03_10-datum TO lv_test10.
            WRITE  lv_test10 TO lv_stdt10.

          ELSEIF lst_e1edk03_10-iddat = lc_020_10. " Contract End Date

            CLEAR lv_test10.
            WRITE lst_e1edk03_10-datum TO lv_test10.
            WRITE lv_test10 TO lv_eddt10.
          ENDIF. " IF lst_e1edk03_10-iddat = lc_022_10

          CLEAR: lst_e1edk03_10.

        WHEN lc_e1edka1_10.

          lst_e1edka1_10 = lst_idoc10-sdata.
          IF lst_e1edka1_10-parvw = lc_we_10.
            lv_ihrez_e1 = lst_e1edka1_10-ihrez.
          ENDIF. " IF lst_e1edka1_10-parvw = lc_we_10

        WHEN lc_z1qtc_e1edp01_01_10. " Custom Segment for Item Level
          CLEAR: lst_z1qtc_e1edp01_01_10,
                  lv_vbegdat5,lv_venddat5,
                 lv_vbegdat4,lv_venddat4.
          lst_z1qtc_e1edp01_01_10 = lst_idoc10-sdata.
          lv_posex10 = lst_z1qtc_e1edp01_01_10-vposn.
          lv_zzpromo12        = lst_z1qtc_e1edp01_01_10-zzpromo.
          lv_artno12          = lst_z1qtc_e1edp01_01_10-zzartno.
          lv_vbegdat5         = lst_z1qtc_e1edp01_01_10-vbegdat. " Contract Strat Date
          lv_venddat5         = lst_z1qtc_e1edp01_01_10-venddat. " Contract End Date
          WRITE lv_vbegdat5 TO lv_vbegdat4.
          WRITE lv_venddat5 TO lv_venddat4.
*** BOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358
          lv_csd1_212            = lst_z1qtc_e1edp01_01_10-zzcontent_start_d.
          lv_ced1_212            = lst_z1qtc_e1edp01_01_10-zzcontent_end_d.
          lv_lsd1_212            = lst_z1qtc_e1edp01_01_10-zzlicense_start_d.
          lv_led1_212            = lst_z1qtc_e1edp01_01_10-zzlicense_end_d.

          WRITE lv_csd1_212 TO lv_csd_212.
          WRITE lv_ced1_212 TO lv_ced_212.
          WRITE lv_lsd1_212 TO lv_lsd_212.
          WRITE lv_led1_212 TO lv_led_212.
*** EOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358
      ENDCASE.

      IF lv_posex10 IS NOT INITIAL.
*** BOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_posex10
          IMPORTING
            output = lv_posex10.
*** EOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358
        lst_item10-posex = lv_posex10.
        lst_item10-zzpromo = lv_zzpromo12.
        lst_item10-vbegdat = lv_vbegdat4. " Contract Start Date
        lst_item10-venddat = lv_venddat4. " Contract End Date
        lst_item10-artno   = lv_artno12.
*** BOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358
        lst_item10-csd     = lv_csd_212.
        lst_item10-ced     = lv_ced_212.
        lst_item10-lsd     = lv_lsd_212.
        lst_item10-led     = lv_led_212.
*** EOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358
        APPEND lst_item10 TO li_item10.
        CLEAR: lst_item10, lv_posex10,
        lv_vbegdat4,lv_venddat4,lv_zzpromo12,lv_artno12,
*** BOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358
         lv_csd_212,lv_ced_212,lv_lsd_212,lv_led_212.
*** EOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358
      ENDIF. " IF lv_posex10 IS NOT INITIAL
      CLEAR: lst_idoc10.
    ENDLOOP. " LOOP AT didoc_data INTO lst_idoc10

    IF lv_date10 IS NOT INITIAL.
      CLEAR lst_bdcdata12. " Clearing work area for BDC data
      lst_bdcdata12-fnam = 'BDC_OKCODE'.
      lst_bdcdata12-fval = 'UER1'.
      APPEND  lst_bdcdata12 TO li_bdcdata212. "appending OKCODE

      CLEAR lst_bdcdata12.
      lst_bdcdata12-program = 'SAPMV45A'.
      lst_bdcdata12-dynpro = '4001'.
      lst_bdcdata12-dynbegin = 'X'.
      APPEND lst_bdcdata12 TO li_bdcdata212. " appending program and screen


      CLEAR lst_bdcdata12.
      lst_bdcdata12-fnam = 'VBKD-BSTDK'.
      lst_bdcdata12-fval = lv_date10.
      APPEND lst_bdcdata12 TO li_bdcdata212. " appending Billing Block

    ENDIF. " IF lv_date10 IS NOT INITIAL

    IF lv_stdt10 IS NOT INITIAL. " Contract Date

      CLEAR lst_bdcdata12. " Clearing work area for BDC data
      lst_bdcdata12-fnam = 'BDC_OKCODE'.
      lst_bdcdata12-fval = 'UER1'.
      APPEND  lst_bdcdata12 TO li_bdcdata212. "appending OKCODE

      CLEAR lst_bdcdata12.
      lst_bdcdata12-program = 'SAPMV45A'.
      lst_bdcdata12-dynpro = '4001'.
      lst_bdcdata12-dynbegin = 'X'.
      APPEND lst_bdcdata12 TO li_bdcdata212. " appending program and screen

      CLEAR lst_bdcdata12.
      lst_bdcdata12-fnam = 'VEDA-VBEGDAT'.
      lst_bdcdata12-fval = lv_stdt10.
      APPEND lst_bdcdata12 TO li_bdcdata212. " Appending Contract Start Date

      CLEAR lst_bdcdata12.
      lst_bdcdata12-fnam = 'VEDA-VENDDAT'.
      lst_bdcdata12-fval = lv_eddt10.
      APPEND lst_bdcdata12 TO li_bdcdata212. " Appending Contract End Date

      CLEAR lst_bdcdata12.
      lst_bdcdata12-program = 'SAPLSPO1'.
      lst_bdcdata12-dynpro = '0400'.
      lst_bdcdata12-dynbegin = 'X'.
      APPEND lst_bdcdata12 TO li_bdcdata212. " appending program and screen

      CLEAR lst_bdcdata12.
      lst_bdcdata12-fnam = 'BDC_OKCODE'.
      lst_bdcdata12-fval = '=YES'.
      APPEND  lst_bdcdata12 TO li_bdcdata212. " appending OKCODE

    ENDIF. " IF lv_stdt10 IS NOT INITIAL
*** code for IHREZ_E
    IF lv_ihrez_e1 IS NOT INITIAL.

      CLEAR lst_bdcdata12. " Clearing work area for BDC data
      lst_bdcdata12-fnam = 'BDC_OKCODE'.
      lst_bdcdata12-fval = 'UER1'.
      APPEND  lst_bdcdata12 TO li_bdcdata212. "appending OKCODE

      CLEAR lst_bdcdata12.
      lst_bdcdata12-program = 'SAPMV45A'.
      lst_bdcdata12-dynpro = '4001'.
      lst_bdcdata12-dynbegin = 'X'.
      APPEND lst_bdcdata12 TO li_bdcdata212. " appending program and screen

      CLEAR lst_bdcdata12.
      lst_bdcdata12-fnam = 'BDC_OKCODE'.
      lst_bdcdata12-fval = '=KBES'.
      APPEND  lst_bdcdata12 TO li_bdcdata212. "appending OKCODE

      CLEAR lst_bdcdata12.
      lst_bdcdata12-program = 'SAPMV45A'.
      lst_bdcdata12-dynpro = '4002'.
      lst_bdcdata12-dynbegin = 'X'.
      APPEND lst_bdcdata12 TO li_bdcdata212. " appending program and screen

      CLEAR lst_bdcdata12.
      lst_bdcdata12-fnam = 'BDC_CURSOR'.
      lst_bdcdata12-fval = 'VBKD-IHREZ_E'.
      APPEND lst_bdcdata12 TO li_bdcdata212.

      CLEAR lst_bdcdata12.
      lst_bdcdata12-fnam = 'VBKD-IHREZ_E'.
      lst_bdcdata12-fval = lv_ihrez_e1.
      APPEND lst_bdcdata12 TO li_bdcdata212. " Appending Assignment

      CLEAR lst_bdcdata12.
      lst_bdcdata12-fnam = 'BDC_OKCODE'.
      lst_bdcdata12-fval = '/EBACK'.
      APPEND  lst_bdcdata12 TO li_bdcdata212. "appending OKCODE

      CLEAR lst_bdcdata12.
      lst_bdcdata12-program = 'SAPMV45A'.
      lst_bdcdata12-dynpro = '4001'.
      lst_bdcdata12-dynbegin = 'X'.
      APPEND lst_bdcdata12 TO li_bdcdata212. " appending program and screen

    ENDIF. " IF lv_ihrez_e1 IS NOT INITIAL
******
*** Getting back to Initial Screen
    CLEAR lst_bdcdata12. " Clearing work area for BDCDATA
    lst_bdcdata12-fnam = 'BDC_OKCODE'.
    lst_bdcdata12-fval = 'UER1'.
    APPEND  lst_bdcdata12 TO li_bdcdata212. " appending OKCODE

    IF dxvbap[] IS NOT INITIAL.

      li_vbap10[] = dxvbap[].

      IF li_item10 IS NOT INITIAL.

        SORT li_item10 BY posex.
        DELETE ADJACENT DUPLICATES FROM li_item10.
        LOOP AT li_vbap10 INTO lst_vbap11.

          CLEAR lst_bdcdata12.
          lst_bdcdata12-program = 'SAPMV45A'.
          lst_bdcdata12-dynpro = '4001'.
          lst_bdcdata12-dynbegin = 'X'.
          APPEND lst_bdcdata12 TO li_bdcdata212.
*        Calling Conversion Exit FM
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_vbap11-posex
            IMPORTING
              output = lst_vbap11-posex.

          READ TABLE li_item10 INTO lst_item10 WITH KEY posex = lst_vbap11-posex BINARY SEARCH.
          IF sy-subrc = 0.
            IF lst_item10-vbegdat IS NOT INITIAL. " Contract Date

              CLEAR lst_bdcdata12. " Clearing work area for BDC data
              lst_bdcdata12-fnam = 'BDC_OKCODE'.
              lst_bdcdata12-fval = 'UER1'.
              APPEND  lst_bdcdata12 TO li_bdcdata212. "appending OKCODE

              CLEAR lst_bdcdata12.
              lst_bdcdata12-program = 'SAPMV45A'.
              lst_bdcdata12-dynpro = '4001'.
              lst_bdcdata12-dynbegin = 'X'.
              APPEND lst_bdcdata12 TO li_bdcdata212. " appending program and screen

              CLEAR: lst_bdcdata12.
              lst_bdcdata12-fnam = 'BDC_OKCODE'.
              lst_bdcdata12-fval = 'POPO'.
              APPEND lst_bdcdata12 TO li_bdcdata212. "Appending OKCODE

              CLEAR: lst_bdcdata12.
              lst_bdcdata12-program = 'SAPMV45A'.
              lst_bdcdata12-dynpro = '251'.
              lst_bdcdata12-dynbegin = 'X'.
              APPEND lst_bdcdata12 TO li_bdcdata212. " Appending Screen

              CLEAR: lst_bdcdata12.
              lst_bdcdata12-fnam = 'RV45A-PO_POSEX'.
              lst_bdcdata12-fval = lst_vbap11-posex.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR: lst_bdcdata12.
              lst_bdcdata12-program = 'SAPMV45A'.
              lst_bdcdata12-dynpro = '4001'.
              lst_bdcdata12-dynbegin = 'X'.
              APPEND lst_bdcdata12 TO li_bdcdata212. " Appending Screen


              CLEAR lst_bdcdata12.
              lst_bdcdata12-fnam = 'BDC_OKCODE'.
              lst_bdcdata12-fval = '=PVER'.
              APPEND  lst_bdcdata12 TO li_bdcdata212. "appending OKCODE

              CLEAR lst_bdcdata12.
              lst_bdcdata12-program = 'SAPLV45W'.
              lst_bdcdata12-dynpro = '4001'.
              lst_bdcdata12-dynbegin = 'X'.
              APPEND lst_bdcdata12 TO li_bdcdata212. " Appending Screen

              CLEAR lst_bdcdata12.
              lst_bdcdata12-fnam = 'VEDA-VBEGDAT'.
              lst_bdcdata12-fval = lst_item10-vbegdat.
              APPEND  lst_bdcdata12 TO li_bdcdata212. " Appending Contract Start Date

              CLEAR lst_bdcdata12.
              lst_bdcdata12-fnam = 'VEDA-VENDDAT'.
              lst_bdcdata12-fval = lst_item10-venddat.
              APPEND  lst_bdcdata12 TO li_bdcdata212. " Appending Contract End Date

              CLEAR lst_bdcdata12.
              lst_bdcdata12-fnam = 'BDC_OKCODE'.
              lst_bdcdata12-fval = '/EBACK'.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR lst_bdcdata12.
              lst_bdcdata12-program = 'SAPMV45A'.
              lst_bdcdata12-dynpro = '4001'.
              lst_bdcdata12-dynbegin = 'X'.
              APPEND lst_bdcdata12 TO li_bdcdata212. " Appending Screen
            ENDIF. " IF lst_item10-vbegdat IS NOT INITIAL

            IF lst_item10-zzpromo IS NOT INITIAL.

              CLEAR lst_bdcdata12. " Clearing work area for BDC data
              lst_bdcdata12-fnam = 'BDC_OKCODE'.
              lst_bdcdata12-fval = 'UER1'.
              APPEND  lst_bdcdata12 TO li_bdcdata212. "appending OKCODE

              CLEAR lst_bdcdata12.
              lst_bdcdata12-program = 'SAPMV45A'.
              lst_bdcdata12-dynpro = '4001'.
              lst_bdcdata12-dynbegin = 'X'.
              APPEND lst_bdcdata12 TO li_bdcdata212. " appending program and screen

              CLEAR: lst_bdcdata12.
              lst_bdcdata12-fnam = 'BDC_OKCODE'.
              lst_bdcdata12-fval = 'POPO'.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR: lst_bdcdata12.
              lst_bdcdata12-program = 'SAPMV45A'.
              lst_bdcdata12-dynpro = '251'.
              lst_bdcdata12-dynbegin = 'X'.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR: lst_bdcdata12.
              lst_bdcdata12-fnam = 'RV45A-PO_POSEX'.
              lst_bdcdata12-fval = lst_vbap11-posex.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR: lst_bdcdata12.
              lst_bdcdata12-program = 'SAPMV45A'.
              lst_bdcdata12-dynpro = '4001'.
              lst_bdcdata12-dynbegin = 'X'.
              APPEND lst_bdcdata12 TO li_bdcdata212.


              CLEAR: lst_bdcdata12.
              lst_bdcdata12-fnam = 'BDC_OKCODE'.
              lst_bdcdata12-fval = 'PZKU'.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR lst_bdcdata12.
              lst_bdcdata12-program = 'SAPMV45A'.
              lst_bdcdata12-dynpro = '4003'.
              lst_bdcdata12-dynbegin = 'X'.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR lst_bdcdata12.
              lst_bdcdata12-fnam = 'BDC_CURSOR'.
              lst_bdcdata12-fval = 'VBAP-ZZPROMO'.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR lst_bdcdata12.
              lst_bdcdata12-fnam = 'VBAP-ZZPROMO'.
              lst_bdcdata12-fval = lst_item10-zzpromo.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR lst_bdcdata12.
              lst_bdcdata12-fnam = 'BDC_OKCODE'.
              lst_bdcdata12-fval = '/EBACK'.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR lst_bdcdata12.
              lst_bdcdata12-program = 'SAPMV45A'.
              lst_bdcdata12-dynpro = '4001'.
              lst_bdcdata12-dynbegin = 'X'.
              APPEND lst_bdcdata12 TO li_bdcdata212.
            ENDIF. " IF lst_item10-zzpromo IS NOT INITIAL

            IF lst_item10-artno IS NOT INITIAL OR
*** BOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358
               ( lst_item10-csd IS NOT INITIAL AND lst_item10-csd NE space ) OR
         ( lst_item10-ced IS NOT INITIAL AND lst_item10-ced NE space ) OR
         ( lst_item10-lsd IS NOT INITIAL AND lst_item10-lsd NE space ) OR
         ( lst_item10-led IS NOT INITIAL AND lst_item10-led NE space ) .
*** EOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358
              CLEAR: lst_bdcdata12.
              lst_bdcdata12-fnam = 'BDC_OKCODE'.
              lst_bdcdata12-fval = 'POPO'.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR: lst_bdcdata12.
              lst_bdcdata12-program = 'SAPMV45A'.
              lst_bdcdata12-dynpro = '251'.
              lst_bdcdata12-dynbegin = 'X'.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR: lst_bdcdata12.
              lst_bdcdata12-fnam = 'RV45A-PO_POSEX'.
              lst_bdcdata12-fval = lst_vbap11-posex.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR: lst_bdcdata12.
              lst_bdcdata12-program = 'SAPMV45A'.
              lst_bdcdata12-dynpro = '4001'.
              lst_bdcdata12-dynbegin = 'X'.
              APPEND lst_bdcdata12 TO li_bdcdata212.


              CLEAR lst_bdcdata12.
              lst_bdcdata12-fnam = 'BDC_OKCODE'.
              lst_bdcdata12-fval = '=PZKU'.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR lst_bdcdata12.
              lst_bdcdata12-program = 'SAPMV45A'.
              lst_bdcdata12-dynpro = '4003'.
              lst_bdcdata12-dynbegin = 'X'.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              IF lst_item10-artno IS NOT INITIAL.

                CLEAR lst_bdcdata12.
                lst_bdcdata12-fnam = 'BDC_CURSOR'.
                lst_bdcdata12-fval = 'VBAP-ZZARTNO'.
                APPEND lst_bdcdata12 TO li_bdcdata212.

                CLEAR lst_bdcdata12.
                lst_bdcdata12-fnam = 'VBAP-ZZARTNO'.
                lst_bdcdata12-fval = lst_item10-artno.
                APPEND lst_bdcdata12 TO li_bdcdata212.

              ENDIF. " IF lst_item10-artno IS NOT INITIAL
*** BOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358
              IF lst_item10-csd IS NOT INITIAL AND lst_item10-csd NE space.
                CLEAR lst_bdcdata12.
                lst_bdcdata12-fnam = 'BDC_CURSOR'.
                lst_bdcdata12-fval = 'VBAP-ZZCONSTART'.
                APPEND lst_bdcdata12 TO li_bdcdata212.

                CLEAR lst_bdcdata12.
                lst_bdcdata12-fnam = 'VBAP-ZZCONSTART'.
                lst_bdcdata12-fval = lst_item10-csd.
                APPEND lst_bdcdata12 TO li_bdcdata212.

                CLEAR lst_bdcdata12.
                lst_bdcdata12-fnam = 'BDC_CURSOR'.
                lst_bdcdata12-fval = 'VBAP-ZZCONEND'.
                APPEND lst_bdcdata12 TO li_bdcdata212.

                CLEAR lst_bdcdata12.
                lst_bdcdata12-fnam = 'VBAP-ZZCONEND'.
                lst_bdcdata12-fval = lst_item10-ced.
                APPEND lst_bdcdata12 TO li_bdcdata212.
              ENDIF. " IF lst_item10-csd IS NOT INITIAL AND lst_item10-csd NE space

              IF lst_item10-lsd IS NOT INITIAL AND lst_item10-lsd NE space.
                CLEAR lst_bdcdata12.
                lst_bdcdata12-fnam = 'BDC_CURSOR'.
                lst_bdcdata12-fval = 'VBAP-ZZLICSTART'.
                APPEND lst_bdcdata12 TO li_bdcdata212.

                CLEAR lst_bdcdata12.
                lst_bdcdata12-fnam = 'VBAP-ZZLICSTART'.
                lst_bdcdata12-fval = lst_item10-lsd.
                APPEND lst_bdcdata12 TO li_bdcdata212.

                CLEAR lst_bdcdata12.
                lst_bdcdata12-fnam = 'BDC_CURSOR'.
                lst_bdcdata12-fval = 'VBAP-ZZLICEND'.
                APPEND lst_bdcdata12 TO li_bdcdata212.

                CLEAR lst_bdcdata12.
                lst_bdcdata12-fnam = 'VBAP-ZZLICEND'.
                lst_bdcdata12-fval = lst_item10-led.
                APPEND lst_bdcdata12 TO li_bdcdata212.

              ENDIF. " IF lst_item10-lsd IS NOT INITIAL AND lst_item10-lsd NE space
*** BOC BY SAYANDAS on 17-May-2018 for Content License Date issue in  ED1K907358

              CLEAR lst_bdcdata12.
              lst_bdcdata12-fnam = 'BDC_OKCODE'.
              lst_bdcdata12-fval = '/EBACK'.
              APPEND lst_bdcdata12 TO li_bdcdata212.

              CLEAR lst_bdcdata12.
              lst_bdcdata12-program = 'SAPMV45A'.
              lst_bdcdata12-dynpro = '4001'.
              lst_bdcdata12-dynbegin = 'X'.
              APPEND lst_bdcdata12 TO li_bdcdata212.

            ENDIF. " IF lst_item10-artno IS NOT INITIAL OR
          ENDIF. " IF sy-subrc = 0
        ENDLOOP. " LOOP AT li_vbap10 INTO lst_vbap11
      ENDIF. " IF li_item10 IS NOT INITIAL

    ENDIF. " IF dxvbap[] IS NOT INITIAL

    DESCRIBE TABLE dxbdcdata LINES lv_tabix212.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0212> INDEX lv_tabix212.
    IF <lst_bdcdata_0212> IS ASSIGNED.
      <lst_bdcdata_0212>-fval = 'OWN_OKCODE'.
    ENDIF. " IF <lst_bdcdata_0212> IS ASSIGNED
    INSERT LINES OF li_bdcdata212 INTO dxbdcdata INDEX lv_tabix212.

  ENDIF. " IF lst_bdcdata12-fnam = 'BDC_OKCODE'

  IF   lst_bdcdata12-fnam = 'BDC_OKCODE'
   AND lst_bdcdata12-fval = 'OWN_OKCODE'.

    DESCRIBE TABLE dxbdcdata LINES lv_tabix212.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0212> INDEX lv_tabix212.
    IF <lst_bdcdata_0212> IS ASSIGNED.
      <lst_bdcdata_0212>-fval = 'SICH'.
    ENDIF. " IF <lst_bdcdata_0212> IS ASSIGNED

  ENDIF. " IF lst_bdcdata12-fnam = 'BDC_OKCODE'
ENDIF. " IF sy-subrc IS INITIAL
*** Code to insert KWMENG
lst_xvbak10k = dxvbak.
lv_auart = lst_xvbak10k-auart.
****Selecting data from TVAK table
SELECT SINGLE vbtyp " SD document category
       FROM tvak    " Sales Document Types
    INTO lv_vbtyp
  WHERE auart = lv_auart.

IF lv_vbtyp = lc_g.

  lst_vbap10k = dxvbap. " Copy the value in local work area
  IF lst_vbap10k-posnr EQ 1.
    lv_zmeng2 = 'VBAP-ZMENG(1)'. "ZMENG Field Name
  ELSE. " ELSE -> IF lst_vbap10k-posnr EQ 1
    lv_zmeng2 = 'VBAP-ZMENG(2)'. "ZMENG Field Name
  ENDIF. " IF lst_vbap10k-posnr EQ 1

  LOOP AT dxbdcdata INTO lst_bdcdata17 WHERE fnam = lv_zmeng2.
    lv_tabix3 = sy-tabix. " Storing the index of ZMENG
  ENDLOOP. " LOOP AT dxbdcdata INTO lst_bdcdata17 WHERE fnam = lv_zmeng2
  IF sy-subrc = 0.
    IF lst_vbap10k-posnr EQ 1.
      lv_kwmeng2 = 'RV45A-KWMENG(1)'. "KWMENG Field Name
    ELSE. " ELSE -> IF lst_vbap10k-posnr EQ 1
      lv_kwmeng2 = 'RV45A-KWMENG(2)'. "KWMENG Field Name
    ENDIF. " IF lst_vbap10k-posnr EQ 1

    READ TABLE dxbdcdata INTO lst_bdcdata19 INDEX ( lv_tabix3 - 1 ).
    IF sy-subrc EQ 0 AND
       lst_bdcdata19-fnam NE lv_kwmeng2.

      lst_bdcdata18-dynpro = '0000'.
      lst_bdcdata18-fnam = lv_kwmeng2.
      lst_bdcdata18-fval = lst_bdcdata17-fval.

      INSERT lst_bdcdata18 INTO dxbdcdata INDEX lv_tabix3.
      CLEAR: lst_bdcdata19, lst_bdcdata18. " appending KWMENG
    ENDIF. " IF sy-subrc EQ 0 AND
    CLEAR lst_bdcdata17.
  ENDIF. " IF sy-subrc = 0
ENDIF. " IF lv_vbtyp = lc_g
