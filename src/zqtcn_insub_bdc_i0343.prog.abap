*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INSUB_BDC_I0343
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INSUB_BDC_I0343(Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Inbound Subscription
* DEVELOPER: SAYANDAS ( Sayantan Das )
* CREATION DATE:   18/03/2017
* OBJECT ID: I0343
* TRANSPORT NUMBER(S):  ED2K904999
*----------------------------------------------------------------------*
* REVISION NO: ED2K913753                                              *
* REFERENCE NO: CR7807                                                *
* DEVELOPER: Surya Guntupalli (SNGUNTUPAL)                             *
* DATE:  05-Nov-2018                                                   *
* DESCRIPTION: Contract start and end dates are reflecting different year
*              due to logic determining data calculated from date of order *
*----------------------------------------------------------------------*
* REVISION NO: ED2K921163
* REFERENCE NO: ERPM-29848
* DEVELOPER: AMOHAMMED
* DATE:  01/15/2021
* DESCRIPTION: * When the Message varient is 'Z9' call the function module
*                to clear the material in POPO popup
*----------------------------------------------------------------------*


*** Local types declaration for XVBAK
TYPES: BEGIN OF lty_xvbak11. "Kopfdaten
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
TYPES: END OF lty_xvbak11.

*****
"Changed OCCURS 50 to OCCURS 0
TYPES: BEGIN OF lty_xvbap11. "Position
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
TYPES: END OF lty_xvbap11.
*****

TYPES: BEGIN OF lty_item11,
         posex   TYPE posex,      " Item Number of the Underlying Purchase Order
         vbegdat TYPE vbdat_veda, " Contract start date
         venddat TYPE vndat_veda, " Contract end date
       END OF lty_item11.

***BOC BY SNGUTNUPAL for CR-7807 on 02-NOV-2018 in ED2K913753
TYPES: BEGIN OF lty_pos,
         posnr   TYPE vbap-posnr,      " Item Number of contract doc
         vbegdat TYPE vbdat_veda,      " Contract start date
         vlaufz  TYPE veda-vlaufz,     " Validity period of contract
         vlaufk  TYPE veda-vlaufk,     " Validity period category of contract
       END OF lty_pos.

TYPES: BEGIN OF ty_mvke,
         matnr TYPE mvke-matnr,        " Material
         prat1 TYPE mvke-prat1,        " Prod Attribute - ZZSUBTYPE
       END OF ty_mvke.
***EOC BY SNGUTNUPAL for CR-7807 on 02-NOV-2018 in ED2K913753

*** Local work area declaration
DATA: lst_bdcdata13 TYPE bdcdata, " Batch input: New table field structure
      lst_bdcdata14 TYPE bdcdata, " Batch input: New table field structure
      lst_bdcdata15 TYPE bdcdata, " Batch input: New table field structure
      lst_idoc11    TYPE edidd,   " Data record (IDoc)
*** change for quotation
      li_di_doc     TYPE STANDARD TABLE OF edidd, " Data record (IDoc)
      lst_di_doc    TYPE edidd,                   " Data record (IDoc)
*** change for quotation
*** BOC for BOM Material
      li_di_doc3    TYPE STANDARD TABLE OF edidd, " Data record (IDoc)
      lst_di_doc3   TYPE edidd,                   " Data record (IDoc)
      lst_item12    TYPE lty_item11,
      li_item12     TYPE STANDARD TABLE OF lty_item11,
*** EOC for BOM Material
      lst_xvbak11   TYPE lty_xvbak11,
      lst_vbap12    TYPE lty_xvbap11,
      lst_vbap13    TYPE lty_xvbap11,
      li_vbap11     TYPE STANDARD TABLE OF lty_xvbap11,
      lst_item11    TYPE lty_item11,
      li_bdcdata343 TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
*      li_bdcdata3431 TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
      li_item11     TYPE STANDARD TABLE OF lty_item11.

*** Local Data declaration
DATA: lv_line11               TYPE sytabix,                   " Row Index of Internal Tables
      lst_e1edk03_11          TYPE e1edk03,                   " IDoc: Document header date segment
      lst_z1qtc_e1edp01_01_11 TYPE z1qtc_e1edp01_01,          " IDOC Segment for STATUS Field in Item Level
      lst_z1qtc_e1edk01_01_11 TYPE z1qtc_e1edk01_01,          " Header General Data Entension
      lst_e1edk02_11          TYPE e1edk02,                   " IDoc: Document header reference data
      lst_e1edp01_11          TYPE e1edp01,                   " IDoc: Document Item General Data
      lst_e1edka1_11          TYPE e1edka1,                   " IDoc: Document Header Partner Information
      li_e1edp01_11           TYPE STANDARD TABLE OF e1edp01, " IDoc: Document Item General Data
      lv_posex11              TYPE string,
      lv_posnr11              TYPE posnr_va,                  " Sales Document Item
      lv_stdt11               TYPE char10,                    " Stdt9 of type CHAR10
      lv_eddt11               TYPE char10,                    " Eddt9 of type CHAR10
      lv_test11               TYPE sy-datum,                  " ABAP System Field: Current Date of Application Server
      lv_tabix343             TYPE sytabix,                   " Row Index of Internal Tables
      lv_tabixq               TYPE sytabix,                   " Row Index of Internal Tables
      lv_tabix2               TYPE syindex,                   " Loop Index
      lv_pos1                 TYPE char3,                     " Pos of type CHAR3
      lv_val1                 TYPE char6,                     " Val of type CHAR6
      lv_selkz1               TYPE char19,                    " Selkz of type CHAR19
      lv_zlsch1               TYPE char1,                     " Zlsch1 of type CHAR1
      lv_promo1               TYPE zpromo,                    " Promo code
      lv_3431                 TYPE char1,                     " 3431 of type CHAR1
      lv_ihrez_e              TYPE ihrez_e,                   " Ship-to party character
      lv_zmeng1               TYPE char13,                    " Zmeng of type CHAR13
      lv_kwmeng1              TYPE char15,                    " Kwmeng of type CHAR15
      lv_zuonr1               TYPE ordnr_v,                   " Assignment number
      lv_quotf                TYPE char1 VALUE abap_false,    " Quotf of type CHAR1
      lv_vbegdat6             TYPE d,                         " Vbegdat of type Date
      lv_venddat6             TYPE d,                         " Venddat of type Date
      lv_vbegdat7             TYPE dats,                      " Field of type DATS
      lv_venddat7             TYPE dats,                      " Field of type DATS
***BOC BY SNGUTNUPAL for CR-7807 on 02-NOV-2018 in ED2K913753
      lv_vkorg                TYPE vbak-vkorg,                " Sales Org
      lv_vtweg                TYPE vbak-vtweg,                " Dist Channel
      lv_multi                TYPE zzmulti_year,              " Multi Year Indicator
      lv_pyear                TYPE zzpricing_year,            " Contract start year
      lv_vlaufz               TYPE veda-vlaufz,
      lv_vlaufk               TYPE veda-vlaufk,
      li_mvke                 TYPE STANDARD TABLE OF ty_mvke,
      lst_mvke                TYPE ty_mvke,
      li_vbapm                TYPE STANDARD TABLE OF lty_xvbap11,
      lst_vbapm               TYPE lty_xvbap11,               " Contract item table
      lst_vbakm               TYPE lty_xvbak11,               " Contract header
      li_pos                  TYPE STANDARD TABLE OF lty_pos, " Contract data upd table
      lst_pos                 TYPE lty_pos,
      lv_flg                  TYPE c,
      lv_ind                  TYPE sy-index,
      lv_vind                 TYPE sy-index,
      lv_vbdat1               TYPE d,                         " Vbegdat of type Date
      lv_vbdat2               TYPE dats.                      " Field of type DATS.
***EOC BY SNGUTNUPAL for CR-7807 on 02-NOV-2018 in ED2K913753

*** Local Field Symbols
FIELD-SYMBOLS:          <lst_bdcdata_0343> TYPE bdcdata. " Batch input: New table field structure

*** local Constant declaration
CONSTANTS: lc_e1edk03_11          TYPE char7 VALUE 'E1EDK03',           " E1edk03_9 of type CHAR7
           lc_e1edp01_11          TYPE char7 VALUE 'E1EDP01',           " E1edp01_11 of type CHAR7
           lc_e1edka1_11          TYPE char7 VALUE 'E1EDKA1',           " E1edka1_11 of type CHAR7
           lc_z1qtc_e1edp01_01_11 TYPE char16 VALUE 'Z1QTC_E1EDP01_01', " Z1qtc_e1edp01_01_9 of type CHAR16
           lc_z1qtc_e1edk01_01_11 TYPE char16 VALUE 'Z1QTC_E1EDK01_01', " Z1qtc_e1edk01_01_9 of type CHAR16
           lc_e1edk02_11          TYPE char7 VALUE 'E1EDK02',           " E1edk02_11 of type CHAR7
           lc_004_11              TYPE edi_qualfr VALUE '004',          " IDOC qualifier reference document
           lc_we_11               TYPE parvw VALUE 'WE',                " Partner Function
*          Begin of ADD:ERP-XXXX:WROY:24-Feb-2018:ED2K905573
           lc_fnam_addr1_data     TYPE fnam_____4 VALUE 'ADDR1_DATA',
           lc_fval_no_data        TYPE bdc_fval   VALUE '/',
*          End   of ADD:ERP-XXXX:WROY:24-Feb-2018:ED2K905573
*           lc_022_10              TYPE edi_iddat VALUE '022',           " Qualifier for IDOC date segment
           lc_019_11              TYPE edi_iddat VALUE '019', " Qualifier for IDOC date segment
           lc_020_11              TYPE edi_iddat VALUE '020', " Qualifier for IDOC date segment
***BOC BY SNGUTNUPAL for CR-7807 on 02-NOV-2018 in ED2K913753
           lc_1                   TYPE zzmulti_year VALUE 1,
           lc_2                   TYPE zzmulti_year VALUE 2,
           lc_3                   TYPE zzmulti_year VALUE 3,
           lc_4                   TYPE zzmulti_year VALUE 4,
           lc_5                   TYPE zzmulti_year VALUE 5,
           lc_v1                  TYPE veda-vlaufz VALUE 1,
           lc_v2                  TYPE veda-vlaufz VALUE 2,
           lc_v3                  TYPE veda-vlaufz VALUE 3,
           lc_v4                  TYPE veda-vlaufz VALUE 4,
           lc_v5                  TYPE veda-vlaufz VALUE 5,
           lc_02                  TYPE veda-vlaufk VALUE '02',
           lc_03                  TYPE veda-vlaufk VALUE '03',
           lc_06                  TYPE veda-vlaufk VALUE '06',
           lc_07                  TYPE veda-vlaufk VALUE '07',
           lc_08                  TYPE veda-vlaufk VALUE '08'.
***EOC BY SNGUTNUPAL for CR-7807 on 02-NOV-2018 in ED2K913753

***BOC BY SNGUTNUPAL for CR-7807 on 02-NOV-2018 in ED2K913753
CLEAR: lv_vkorg, lv_vtweg, li_mvke[], lst_mvke, li_vbapm[], lst_vbapm, li_pos,
       lst_pos, lv_ind, lv_vind, lst_bdcdata13.
*lv_vkorg = dxvbak-vkorg.
*lv_vtweg = dxvbak-vtweg.
*READ TABLE dxbdcdata INTO lst_bdcdata13 WITH KEY fnam = 'VBAK-VKORG'.
*IF sy-subrc = 0.
*  lv_vkorg = lst_bdcdata13-fval.
*ENDIF.
*CLEAR: lst_bdcdata13.
*READ TABLE dxbdcdata INTO lst_bdcdata13 WITH KEY fnam = 'VBAK-VTWEG'.
*IF sy-subrc = 0.
*  lv_vtweg = lst_bdcdata13-fval.
*ENDIF.

lst_vbakm = dxvbak.             "Copy contract header data
lv_vkorg = lst_vbakm-vkorg.     " Get sales org
lv_vtweg = lst_vbakm-vtweg.     " Get Dist Channel

li_vbapm[] = dxvbap[].          " Copy Contract item data
DESCRIBE TABLE li_vbapm LINES lv_vind.  "Get No.of line items in document

IF li_vbapm[] IS NOT INITIAL.    " Get material product attributes
  SELECT matnr prat1 FROM mvke INTO TABLE li_mvke
         FOR ALL ENTRIES IN li_vbapm[]
         WHERE matnr = li_vbapm-matnr
         AND   vkorg = lv_vkorg
         AND   vtweg = lv_vtweg.
*** If no entries found then contract date will not be updated.
ENDIF.
***EOC BY SNGUTNUPAL for CR-7807 on 02-NOV-2018 in ED2K913753

*** getting number of lines in BDCDATA
DESCRIBE TABLE dxbdcdata LINES lv_line11.
* Read the Idoc Number from Idoc Data
READ TABLE didoc_data INTO lst_idoc11 INDEX 1.
* Reading BDCDATA table into a work area using last index
READ TABLE dxbdcdata INTO lst_bdcdata13 INDEX lv_line11.
IF sy-subrc IS INITIAL.

* BOC for BOM Material *
  li_di_doc3[] = didoc_data[].
  DELETE li_di_doc3 WHERE segnam NE lc_z1qtc_e1edp01_01_11.
  LOOP AT li_di_doc3 INTO lst_di_doc3.
***BOC BY SNGUTNUPAL for CR-7807 on 02-NOV-2018 in ED2K913753
    CLEAR: lst_z1qtc_e1edp01_01_11, lst_pos, lv_multi,
           lv_vbegdat7,lv_venddat7, lv_vbdat1, lv_vbdat2,
           lv_vbegdat6,lv_venddat6.
    lv_ind = lv_ind + 1.           " Get loop Index
***EOC BY SNGUTNUPAL for CR-7807 on 02-NOV-2018 in ED2K913753
    lst_z1qtc_e1edp01_01_11 = lst_di_doc3-sdata.
    lv_posex11          = lst_z1qtc_e1edp01_01_11-vposn.
*    lv_traty1           = lst_z1qtc_e1edp01_01_9-traty. " Transportation Type
    lv_vbegdat7         = lst_z1qtc_e1edp01_01_11-vbegdat. " Contract Strat Date
    lv_venddat7         = lst_z1qtc_e1edp01_01_11-venddat. " Contract End Date
    WRITE lv_vbegdat7 TO lv_vbegdat6.
    WRITE lv_venddat7 TO lv_venddat6.
***BOC BY SNGUTNUPAL for CR-7807 on 02-NOV-2018 in ED2K913753
*** Get contract start and validity info for each line item
*** Changes for contract start date only if ZZSUBTYPE = 01 and
*** replace with pricing year. Get contract validity based on ZZMULTI_YEAR.
    IF lv_ind IS NOT INITIAL AND lv_ind LE lv_vind.
      READ TABLE li_vbapm INTO lst_vbapm INDEX lv_ind.
      IF sy-subrc = 0.
        lst_pos-posnr = lst_vbapm-posnr.
        lv_multi = lst_z1qtc_e1edp01_01_11-zzmulti_year.
        IF lv_multi = lc_1.
          lst_pos-vlaufz = 1.
          lst_pos-vlaufk = '02'.
        ELSEIF lv_multi = lc_2.
          lst_pos-vlaufz = 2.
          lst_pos-vlaufk = '03'.
        ELSEIF lv_multi = lc_3.
          lst_pos-vlaufz = 3.
          lst_pos-vlaufk = '06'.
        ELSEIF lv_multi = lc_4.
          lst_pos-vlaufz = 4.
          lst_pos-vlaufk = '07'.
        ELSEIF lv_multi = lc_5.
          lst_pos-vlaufz = 5.
          lst_pos-vlaufk = '08'.
        ENDIF.
        READ TABLE li_mvke INTO lst_mvke WITH KEY matnr = lst_vbapm-matnr.
        IF sy-subrc = 0 AND lst_mvke-prat1 IS NOT INITIAL.
          IF lst_z1qtc_e1edp01_01_11-vbegdat IS NOT INITIAL AND
             lst_z1qtc_e1edp01_01_11-zzpricing_year IS NOT INITIAL.
            lst_z1qtc_e1edp01_01_11-vbegdat+0(4) = lst_z1qtc_e1edp01_01_11-zzpricing_year.
            lst_z1qtc_e1edp01_01_11-vbegdat+4(4) = '0101'.
            lv_vbdat2                            = lst_z1qtc_e1edp01_01_11-vbegdat.
            WRITE lv_vbdat2 TO lv_vbdat1.
            lst_pos-vbegdat = lv_vbdat1.
          ENDIF.
        ENDIF.
        IF lst_pos-vbegdat IS NOT INITIAL OR lst_pos-vlaufz IS NOT INITIAL.
          APPEND lst_pos TO li_pos[].
          CLEAR: lst_pos.
        ENDIF.
      ENDIF.
    ENDIF.
***EOC BY SNGUTNUPAL for CR-7807 on 02-NOV-2018 in ED2K913753

    IF lv_posex11 IS NOT INITIAL.
      lst_item12-posex = lv_posex11.
      lst_item12-vbegdat = lv_vbegdat6.
      lst_item12-venddat = lv_venddat6.
      APPEND lst_item12 TO li_item12.
      CLEAR: lst_item12, lv_posex11,
             lv_vbegdat6, lv_venddat6.
    ENDIF. " IF lv_posex11 IS NOT INITIAL
  ENDLOOP. " LOOP AT li_di_doc3 INTO lst_di_doc3
  SORT li_item12 BY posex.
  DELETE ADJACENT DUPLICATES FROM li_item12.


  IF lst_bdcdata13-fnam+0(10) = 'VBAP-POSEX'.
    lv_pos1 = lst_bdcdata13-fnam+10(3).
    lv_val1 = lst_bdcdata13-fval.
*    BREAK-POINT.
    READ TABLE li_item12 INTO lst_item12 WITH KEY posex = lv_val1.
    IF sy-subrc = 0.

      IF lst_item12-vbegdat IS NOT INITIAL.

        CLEAR lst_bdcdata13.
        lst_bdcdata13-program = 'SAPMV45A'.
        lst_bdcdata13-dynpro = '4001'.
        lst_bdcdata13-dynbegin = 'X'.
        APPEND lst_bdcdata13 TO dxbdcdata. " Appending Screen

        CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos1 INTO lv_selkz1.

        CLEAR lst_bdcdata13.
        lst_bdcdata13-fnam = lv_selkz1.
        lst_bdcdata13-fval = 'X'.
        APPEND  lst_bdcdata13 TO dxbdcdata. "appending OKCODE

        CLEAR lst_bdcdata13.
        lst_bdcdata13-fnam = 'BDC_OKCODE'.
        lst_bdcdata13-fval = '=PVER'.
        APPEND  lst_bdcdata13 TO dxbdcdata. "appending OKCODE

        CLEAR lst_bdcdata13.
        lst_bdcdata13-program = 'SAPLV45W'.
        lst_bdcdata13-dynpro = '4001'.
        lst_bdcdata13-dynbegin = 'X'.
        APPEND lst_bdcdata13 TO dxbdcdata. " Appending Screen

        CLEAR lst_bdcdata13.
        lst_bdcdata13-fnam = 'VEDA-VBEGDAT'.
        lst_bdcdata13-fval = lst_item12-vbegdat.
        APPEND  lst_bdcdata13 TO dxbdcdata. " Appending Contract Start Date

        CLEAR lst_bdcdata13.
        lst_bdcdata13-fnam = 'VEDA-VENDDAT'.
        lst_bdcdata13-fval = lst_item12-venddat.
        APPEND  lst_bdcdata13 TO dxbdcdata. " Appending Contract End Date

        CLEAR lst_bdcdata13.
        lst_bdcdata13-fnam = 'BDC_OKCODE'.
        lst_bdcdata13-fval = '/EBACK'.
        APPEND lst_bdcdata13 TO dxbdcdata.

        CLEAR lst_bdcdata13.
        lst_bdcdata13-program = 'SAPMV45A'.
        lst_bdcdata13-dynpro = '4001'.
        lst_bdcdata13-dynbegin = 'X'.
        APPEND lst_bdcdata13 TO dxbdcdata.

      ENDIF. " IF lst_item12-vbegdat IS NOT INITIAL
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF lst_bdcdata13-fnam+0(10) = 'VBAP-POSEX'
* EOC for BOM Material*

*   Check the FNAM and FVAL value of the Lst entry of BDCDATA
*   This is to restrict the execution of the code
  IF lst_bdcdata13-fnam = 'BDC_OKCODE'
     AND lst_bdcdata13-fval = 'SICH'.

    CLEAR lst_idoc11.
    lst_xvbak11 = dxvbak.

    LOOP AT didoc_data INTO lst_idoc11.
      CASE lst_idoc11-segnam.
        WHEN lc_e1edk03_11.
          lst_e1edk03_11 = lst_idoc11-sdata.

*          IF lst_e1edk03_11-iddat = lc_022_10. " Billing Date
*            lv_date101 = lst_e1edk03_10-datum.
*            WRITE lv_date101 TO lv_date10.

          IF lst_e1edk03_11-iddat = lc_019_11. " Contract Start Date
            WRITE  lst_e1edk03_11-datum TO lv_test11.
            WRITE  lv_test11 TO lv_stdt11.

          ELSEIF lst_e1edk03_11-iddat = lc_020_11. " Contract End Date

            CLEAR lv_test11.
            WRITE lst_e1edk03_11-datum TO lv_test11.
            WRITE lv_test11 TO lv_eddt11.
          ENDIF. " IF lst_e1edk03_11-iddat = lc_019_11

          CLEAR: lst_e1edk03_11.

        WHEN lc_e1edk02_11.

          lst_e1edk02_11 = lst_idoc11-sdata.
          IF lst_e1edk02_11-qualf = lc_004_11.
            lv_quotf = abap_true.
          ENDIF. " IF lst_e1edk02_11-qualf = lc_004_11

        WHEN lc_e1edka1_11.

          lst_e1edka1_11 = lst_idoc11-sdata.
          IF lst_e1edka1_11-parvw = lc_we_11.
            lv_ihrez_e = lst_e1edka1_11-ihrez.
          ENDIF. " IF lst_e1edka1_11-parvw = lc_we_11

        WHEN lc_z1qtc_e1edp01_01_11. " Custom Segment for Item Level
          CLEAR: lst_z1qtc_e1edp01_01_11,
                  lv_vbegdat7,lv_venddat7,
                 lv_vbegdat6,lv_venddat6.
          lst_z1qtc_e1edp01_01_11 = lst_idoc11-sdata.
          lv_posex11 = lst_z1qtc_e1edp01_01_11-vposn.
*        Calling Conversion Exit FM
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lv_posex11
            IMPORTING
              output = lv_posex11.
*          lv_traty1           = lst_z1qtc_e1edp01_01_9-traty. " Transportation Type
*          lv_zzpromo12        = lst_z1qtc_e1edp01_01_10-zzpromo.
*          lv_artno12          = lst_z1qtc_e1edp01_01_10-zzartno.
          IF lst_z1qtc_e1edp01_01_11-vbegdat IS NOT INITIAL AND lst_z1qtc_e1edp01_01_11-zzpricing_year IS NOT INITIAL.
            lst_z1qtc_e1edp01_01_11-vbegdat+0(4) = lst_z1qtc_e1edp01_01_11-zzpricing_year.
          ENDIF.
          lv_vbegdat7         = lst_z1qtc_e1edp01_01_11-vbegdat. " Contract Strat Date
          lv_venddat7         = lst_z1qtc_e1edp01_01_11-venddat. " Contract End Date
          WRITE lv_vbegdat7 TO lv_vbegdat6.
          WRITE lv_venddat7 TO lv_venddat6.

        WHEN lc_z1qtc_e1edk01_01_11. "Custom Segment for Header Level
          CLEAR: lst_z1qtc_e1edk01_01_11.
          lst_z1qtc_e1edk01_01_11 = lst_idoc11-sdata.
*          lv_traty = lst_z1qtc_e1edk01_01_9-traty. " Transportation Type
          lv_zlsch1 = lst_z1qtc_e1edk01_01_11-zlsch.
          lv_promo1 = lst_z1qtc_e1edk01_01_11-zzpromo.
          lv_zuonr1 = lst_z1qtc_e1edk01_01_11-zuonr. " Assignment
      ENDCASE.

      IF lv_posex11 IS NOT INITIAL.

        lst_item11-posex = lv_posex11.
*        lst_item9-traty = lv_traty1. " Transportation Type
*        lst_item10-zzpromo = lv_zzpromo12.
        lst_item11-vbegdat = lv_vbegdat6. " Contract Start Date
        lst_item11-venddat = lv_venddat6. " Contract End Date
*        lst_item10-artno   = lv_artno12.
        APPEND lst_item11 TO li_item11.
        CLEAR: lst_item11, lv_posex11,
        lv_vbegdat6,lv_venddat6.

      ENDIF. " IF lv_posex11 IS NOT INITIAL
      CLEAR: lst_idoc11.
    ENDLOOP. " LOOP AT didoc_data INTO lst_idoc11
**** change for quotaion
    IF lv_quotf = abap_true.
      li_di_doc[] = didoc_data[].
      DELETE li_di_doc WHERE segnam NE lc_e1edp01_11.
      LOOP AT li_di_doc INTO lst_di_doc.
        lst_e1edp01_11 = lst_di_doc-sdata.
        CLEAR lst_e1edp01_11-posex.
        lv_tabixq = sy-tabix.
        lv_tabixq = sy-tabix * 10.
        lv_posnr11 = lv_tabixq.
        lst_e1edp01_11-posex = lv_posnr11.
        APPEND lst_e1edp01_11 TO li_e1edp01_11.
        CLEAR lst_e1edp01_11.
      ENDLOOP. " LOOP AT li_di_doc INTO lst_di_doc
    ENDIF. " IF lv_quotf = abap_true
*** change for quotaion
    IF lv_stdt11 IS NOT INITIAL. " Contract Date

      CLEAR lst_bdcdata13. " Clearing work area for BDC data
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = 'UER1'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro = '4001'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'VEDA-VBEGDAT'.
      lst_bdcdata13-fval = lv_stdt11.
      APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Contract Start Date

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'VEDA-VENDDAT'.
      lst_bdcdata13-fval = lv_eddt11.
      APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Contract End Date

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPLSPO1'.
      lst_bdcdata13-dynpro = '0400'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = '=YES'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. " appending OKCODE

    ENDIF. " IF lv_stdt11 IS NOT INITIAL



******
*** Getting back to Initial Screen
*    CLEAR lst_bdcdata13. " Clearing work area for BDCDATA
*    lst_bdcdata13-fnam = 'BDC_OKCODE'.
*    lst_bdcdata13-fval = 'UER1'.
*    APPEND  lst_bdcdata13 TO li_bdcdata343. " appending OKCODE

    CLEAR: lv_flg.
    IF lv_quotf = abap_false.

      IF dxvbap[] IS NOT INITIAL.

        li_vbap11[] = dxvbap[].

        IF li_item11 IS NOT INITIAL.

          SORT li_item11 BY posex.
          DELETE ADJACENT DUPLICATES FROM li_item11.
          LOOP AT li_vbap11 INTO lst_vbap12.
            DATA(lv_vbap_tabix) = sy-tabix.

            CLEAR lst_bdcdata13.
            lst_bdcdata13-program = 'SAPMV45A'.
            lst_bdcdata13-dynpro = '4001'.
            lst_bdcdata13-dynbegin = 'X'.
            APPEND lst_bdcdata13 TO li_bdcdata343.
*        Calling Conversion Exit FM
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lst_vbap12-posex
              IMPORTING
                output = lst_vbap12-posex.

            READ TABLE li_item11 INTO lst_item11 WITH KEY posex = lst_vbap12-posex BINARY SEARCH.
            IF sy-subrc NE 0.
              READ TABLE li_item11 INTO lst_item11 INDEX lv_vbap_tabix.
            ENDIF. " IF sy-subrc NE 0
            IF sy-subrc = 0.
*              IF lst_item11-vbegdat IS NOT INITIAL. " Contract Date
*                CLEAR: lst_bdcdata13.
*                lst_bdcdata13-fnam = 'BDC_OKCODE'.
*                lst_bdcdata13-fval = 'POPO'.
*                APPEND lst_bdcdata13 TO li_bdcdata343. "Appending OKCODE
*
*                CLEAR: lst_bdcdata13.
*                lst_bdcdata13-program = 'SAPMV45A'.
*                lst_bdcdata13-dynpro = '251'.
*                lst_bdcdata13-dynbegin = 'X'.
*                APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Screen
*
*                CLEAR: lst_bdcdata13.
*                lst_bdcdata13-fnam = 'RV45A-POSNR'.
*                lst_bdcdata13-fval = lst_vbap12-posex.
*                APPEND lst_bdcdata13 TO li_bdcdata343.
*
*                CLEAR: lst_bdcdata13.
*                lst_bdcdata13-program = 'SAPMV45A'.
*                lst_bdcdata13-dynpro = '4001'.
*                lst_bdcdata13-dynbegin = 'X'.
*                APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Screen
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
*                CLEAR lst_bdcdata13.
*                lst_bdcdata13-fnam = 'BDC_OKCODE'.
*                lst_bdcdata13-fval = '=PVER'.
*                APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE
*
*                CLEAR lst_bdcdata13.
*                lst_bdcdata13-program = 'SAPLV45W'.
*                lst_bdcdata13-dynpro = '4001'.
*                lst_bdcdata13-dynbegin = 'X'.
*                APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Screen
*
*                CLEAR lst_bdcdata13.
*                lst_bdcdata13-fnam = 'VEDA-VBEGDAT'.
*                lst_bdcdata13-fval = lst_item11-vbegdat.
*                APPEND  lst_bdcdata13 TO li_bdcdata343. " Appending Contract Start Date
*
*                CLEAR lst_bdcdata13.
*                lst_bdcdata13-fnam = 'VEDA-VENDDAT'.
*                lst_bdcdata13-fval = lst_item11-venddat.
*                APPEND  lst_bdcdata13 TO li_bdcdata343. " Appending Contract End Date
*
*                CLEAR lst_bdcdata13.
*                lst_bdcdata13-fnam = 'BDC_OKCODE'.
*                lst_bdcdata13-fval = '/EBACK'.
*                APPEND lst_bdcdata13 TO li_bdcdata343.
*
*                CLEAR lst_bdcdata13.
*                lst_bdcdata13-program = 'SAPMV45A'.
*                lst_bdcdata13-dynpro = '4001'.
*                lst_bdcdata13-dynbegin = 'X'.
*                APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Screen
*              ENDIF. " IF lst_item11-vbegdat IS NOT INITIAL
            ENDIF. " IF sy-subrc = 0
          ENDLOOP. " LOOP AT li_vbap11 INTO lst_vbap12
        ENDIF. " IF li_item11 IS NOT INITIAL

      ENDIF. " IF dxvbap[] IS NOT INITIAL

    ENDIF. " IF lv_quotf = abap_false
*** change for quotation
    IF lv_quotf = abap_true.
      IF li_e1edp01_11[] IS NOT INITIAL.
        IF li_item11 IS NOT INITIAL.
          SORT li_item11 BY posex.
          DELETE ADJACENT DUPLICATES FROM li_item11.
          LOOP AT li_e1edp01_11 INTO lst_e1edp01_11.
            CLEAR lst_bdcdata13.
            lst_bdcdata13-program = 'SAPMV45A'.
            lst_bdcdata13-dynpro = '4001'.
            lst_bdcdata13-dynbegin = 'X'.
            APPEND lst_bdcdata13 TO li_bdcdata343.

*        Calling Conversion Exit FM
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = lst_e1edp01_11-posex
              IMPORTING
                output = lst_e1edp01_11-posex.

            READ TABLE li_item11 INTO lst_item11 WITH KEY posex = lst_e1edp01_11-posex BINARY SEARCH.
            IF sy-subrc = 0.
              IF lst_item11-vbegdat IS NOT INITIAL. " Contract Date
                CLEAR: lst_bdcdata13.
                lst_bdcdata13-fnam = 'BDC_OKCODE'.
                lst_bdcdata13-fval = 'POPO'.
                APPEND lst_bdcdata13 TO li_bdcdata343. "Appending OKCODE

                CLEAR: lst_bdcdata13.
                lst_bdcdata13-program = 'SAPMV45A'.
                lst_bdcdata13-dynpro = '251'.
                lst_bdcdata13-dynbegin = 'X'.
                APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Screen

                CLEAR: lst_bdcdata13.
                lst_bdcdata13-fnam = 'RV45A-POSNR'.
                lst_bdcdata13-fval = lst_e1edp01_11-posex.
                APPEND lst_bdcdata13 TO li_bdcdata343.

                CLEAR: lst_bdcdata13.
                lst_bdcdata13-program = 'SAPMV45A'.
                lst_bdcdata13-dynpro = '4001'.
                lst_bdcdata13-dynbegin = 'X'.
                APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Screen

                CLEAR lst_bdcdata13.
                lst_bdcdata13-fnam = 'BDC_OKCODE'.
                lst_bdcdata13-fval = '=PVER'.
                APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

                CLEAR lst_bdcdata13.
                lst_bdcdata13-program = 'SAPLV45W'.
                lst_bdcdata13-dynpro = '4001'.
                lst_bdcdata13-dynbegin = 'X'.
                APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Screen

                CLEAR lst_bdcdata13.
                lst_bdcdata13-fnam = 'VEDA-VBEGDAT'.
                lst_bdcdata13-fval = lst_item11-vbegdat.
                APPEND  lst_bdcdata13 TO li_bdcdata343. " Appending Contract Start Date

                CLEAR lst_bdcdata13.
                lst_bdcdata13-fnam = 'VEDA-VENDDAT'.
                lst_bdcdata13-fval = lst_item11-venddat.
                APPEND  lst_bdcdata13 TO li_bdcdata343. " Appending Contract End Date

                CLEAR lst_bdcdata13.
                lst_bdcdata13-fnam = 'BDC_OKCODE'.
                lst_bdcdata13-fval = '/EBACK'.
                APPEND lst_bdcdata13 TO li_bdcdata343.

                CLEAR lst_bdcdata13.
                lst_bdcdata13-program = 'SAPMV45A'.
                lst_bdcdata13-dynpro = '4001'.
                lst_bdcdata13-dynbegin = 'X'.
                APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Screen
              ENDIF. " IF lst_item11-vbegdat IS NOT INITIAL
            ENDIF. " IF sy-subrc = 0
          ENDLOOP. " LOOP AT li_e1edp01_11 INTO lst_e1edp01_11
        ENDIF. " IF li_item11 IS NOT INITIAL

      ENDIF. " IF li_e1edp01_11[] IS NOT INITIAL
    ENDIF. " IF lv_quotf = abap_true
*** change for quotation
    IF lv_zuonr1 IS NOT INITIAL. " Assignment

      CLEAR lst_bdcdata13. " Clearing work area for BDC data
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = 'UER1'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro = '4001'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

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

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = '=KBUC'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro = '4002'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_CURSOR'.
      lst_bdcdata13-fval = 'VBAK-ZUONR'.
      APPEND lst_bdcdata13 TO li_bdcdata343.

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'VBAK-ZUONR'.
      lst_bdcdata13-fval = lv_zuonr1.
      APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Assignment

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = '/EBACK'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro = '4001'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

    ENDIF. " IF lv_zuonr1 IS NOT INITIAL

    IF lv_promo1 IS NOT INITIAL.

      CLEAR lst_bdcdata13. " Clearing work area for BDC data
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = 'UER1'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro = '4001'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = '=KZKU'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro = '4002'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_CURSOR'.
      lst_bdcdata13-fval = 'VBAK-ZZPROMO'.
      APPEND lst_bdcdata13 TO li_bdcdata343.

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'VBAK-ZZPROMO'.
      lst_bdcdata13-fval = lv_promo1.
      APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Assignment

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = '/EBACK'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro = '4001'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

    ENDIF. " IF lv_promo1 IS NOT INITIAL

    IF lv_ihrez_e IS NOT INITIAL.

      CLEAR lst_bdcdata13. " Clearing work area for BDC data
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = 'UER1'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro = '4001'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = '=KBES'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro = '4002'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_CURSOR'.
      lst_bdcdata13-fval = 'VBKD-IHREZ_E'.
      APPEND lst_bdcdata13 TO li_bdcdata343.

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'VBKD-IHREZ_E'.
      lst_bdcdata13-fval = lv_ihrez_e.
      APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Assignment

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = '/EBACK'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro = '4001'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

    ENDIF. " IF lv_ihrez_e IS NOT INITIAL

    IF lv_zlsch1 IS NOT INITIAL.
      CLEAR lst_bdcdata13. " Clearing work area for BDC data
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = 'UER1'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro = '4001'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = 'KBUC'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro = '4002'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'VBKD-ZLSCH'.
      lst_bdcdata13-fval = lv_zlsch1.
      APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Assignment

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = '/EBACK'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro = '4001'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen
    ENDIF. " IF lv_zlsch1 IS NOT INITIAL

***BOC BY SNGUTNUPAL for CR-7807 on 02-NOV-2018 in ED2K913753
*** BDC to update the Contract start date and Contract Validity period
    LOOP AT li_pos INTO lst_pos.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'    "Convert line item
        EXPORTING
          input  = lst_pos-posnr
        IMPORTING
          output = lv_3431.

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro = '4001'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Screen

      CLEAR lst_bdcdata13.
      CONCATENATE 'RV45A-VBAP_SELKZ(' lv_3431 ')' INTO  lst_bdcdata13-fnam.
      lst_bdcdata13-fval = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = '=PVER'.
      APPEND lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPLV45W'.
      lst_bdcdata13-dynpro = '4001'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

      IF lst_pos-vlaufz IS NOT INITIAL.
        CLEAR lst_bdcdata13.
        lst_bdcdata13-fnam = 'BDC_CURSOR'.
        lst_bdcdata13-fval = 'VEDA-VLAUFZ'.
        APPEND lst_bdcdata13 TO li_bdcdata343.

        CLEAR lst_bdcdata13.
        lst_bdcdata13-fnam = 'VEDA-VLAUFZ'.
        lst_bdcdata13-fval = lst_pos-vlaufz.
        APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Contract Validity Period

        CLEAR lst_bdcdata13.
        lst_bdcdata13-fnam = 'BDC_CURSOR'.
        lst_bdcdata13-fval = 'VEDA-VLAUFK'.
        APPEND lst_bdcdata13 TO li_bdcdata343.

        CLEAR lst_bdcdata13.
        lst_bdcdata13-fnam = 'VEDA-VLAUFK'.
        lst_bdcdata13-fval = lst_pos-vlaufk.
        APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Validity period category of contract
      ENDIF.

      IF lst_pos-vbegdat IS NOT INITIAL.
        CLEAR lst_bdcdata13.
        lst_bdcdata13-fnam = 'BDC_CURSOR'.
        lst_bdcdata13-fval = 'VEDA-VBEGDAT'.
        APPEND lst_bdcdata13 TO li_bdcdata343.

        CLEAR lst_bdcdata13.
        lst_bdcdata13-fnam = 'VEDA-VBEGDAT'.
        lst_bdcdata13-fval = lst_pos-vbegdat.
        APPEND lst_bdcdata13 TO li_bdcdata343. " Appending Contract start date
      ENDIF.

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPLSPO1'.
      lst_bdcdata13-dynpro = '0400'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343.

      CLEAR: lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = '=YES'.
      APPEND  lst_bdcdata TO li_bdcdata343. "appending Yes or NO popup

      CLEAR lst_bdcdata13.
      lst_bdcdata13-program = 'SAPLV45W'.
      lst_bdcdata13-dynpro = '4001'.
      lst_bdcdata13-dynbegin = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343. " appending program and screen

      CLEAR: lst_bdcdata13.
      lst_bdcdata13-fnam = 'BDC_OKCODE'.
      lst_bdcdata13-fval = '=S\BACK'.
      APPEND  lst_bdcdata13 TO li_bdcdata343. "appending OKCODE

      CLEAR:  lst_bdcdata13.
      lst_bdcdata13-program = 'SAPMV45A'.
      lst_bdcdata13-dynpro  =  '4001'.
      lst_bdcdata13-dynbegin   = 'X'.
      APPEND lst_bdcdata13 TO li_bdcdata343.

    ENDLOOP.
***EOC BY SNGUTNUPAL for CR-7807 on 02-NOV-2018 in ED2K913753

    DESCRIBE TABLE dxbdcdata LINES lv_tabix343.
    IF lv_quotf = abap_false.
      READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0343> INDEX lv_tabix343.
      IF <lst_bdcdata_0343> IS ASSIGNED.
        <lst_bdcdata_0343>-fval = 'OWN_OKCODE'.
      ENDIF. " IF <lst_bdcdata_0343> IS ASSIGNED
    ENDIF. " IF lv_quotf = abap_false
    INSERT LINES OF li_bdcdata343 INTO dxbdcdata INDEX lv_tabix343.

  ENDIF. " IF lst_bdcdata13-fnam = 'BDC_OKCODE'

  IF   lst_bdcdata13-fnam = 'BDC_OKCODE'
   AND lst_bdcdata13-fval = 'OWN_OKCODE'.

    DESCRIBE TABLE dxbdcdata LINES lv_tabix343.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0343> INDEX lv_tabix343.
    IF <lst_bdcdata_0343> IS ASSIGNED.
      <lst_bdcdata_0343>-fval = 'SICH'.
    ENDIF. " IF <lst_bdcdata_0343> IS ASSIGNED

  ENDIF. " IF lst_bdcdata13-fnam = 'BDC_OKCODE'
ENDIF. " IF sy-subrc IS INITIAL

*** Code to insert KWMENG
lst_vbap13 = dxvbap. " Copy the value in local work area
* Calling Conversion Exit FM to remove leading zeros
CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
  EXPORTING
    input  = lst_vbap13-posnr
  IMPORTING
    output = lv_3431.


CONCATENATE 'VBAP-ZMENG(' lv_3431 ')' INTO lv_zmeng1. "ZMENG Field Name
READ TABLE dxbdcdata INTO lst_bdcdata13 WITH KEY fnam = lv_zmeng1.
IF sy-subrc = 0.
  lv_tabix2 = sy-tabix. " Storing the index of ZMENG
  READ TABLE dxbdcdata INTO lst_bdcdata15 WITH KEY fnam = 'RV45A-KWMENG(1)'.
  IF sy-subrc NE 0.

    lst_bdcdata14-dynpro = '0000'.
    CONCATENATE 'RV45A-KWMENG(' lv_3431 ')' INTO lv_kwmeng1. " KWMENG field

    lst_bdcdata14-fnam = lv_kwmeng1.
    lst_bdcdata14-fval = lst_bdcdata13-fval.

    INSERT lst_bdcdata14 INTO dxbdcdata INDEX lv_tabix2.
    CLEAR: lst_bdcdata15, lst_bdcdata14. " appending KWMENG
  ENDIF. " IF sy-subrc NE 0
  CLEAR lst_bdcdata13.
ENDIF. " IF sy-subrc = 0




*IF lv_quotf = abap_true.
*
*  CLEAR: lst_bdcdata13.
*  READ TABLE dxbdcdata INTO lst_bdcdata13 WITH KEY fval = 'UEBR'.
*  IF sy-subrc = 0.
*    lv_tabix2 = sy-tabix.
*    lv_tabix2 = lv_tabix2 + 1.
*    CLEAR lst_bdcdata14.
*    lst_bdcdata14-program = 'SAPLSPO1'.
*    lst_bdcdata14-dynpro = '0400'.
*    lst_bdcdata14-dynbegin = 'X'.
*    APPEND lst_bdcdata14 TO li_bdcdata3431. " appending program and screen
*
*    CLEAR lst_bdcdata14.
*    lst_bdcdata14-fnam = 'BDC_OKCODE'.
*    lst_bdcdata14-fval = '=YES'.
*    APPEND  lst_bdcdata14 TO li_bdcdata3431. " appending OKCODE
*    INSERT LINES OF li_bdcdata3431 INTO dxbdcdata INDEX lv_tabix2.
*
*  ENDIF. " IF sy-subrc = 0
*ENDIF. " IF lv_quotf = abap_true

* Begin of ADD:ERP-XXXX:WROY:24-Feb-2018:ED2K905573
READ TABLE dxbdcdata TRANSPORTING NO FIELDS
     WITH KEY fnam(10) = lc_fnam_addr1_data
              fval     = lc_fval_no_data.
IF sy-subrc EQ 0.
  CLEAR: lst_bdcdata14.
  MODIFY dxbdcdata FROM lst_bdcdata14 TRANSPORTING fval
   WHERE fnam(10) = lc_fnam_addr1_data
     AND fval     = lc_fval_no_data.
ENDIF.
* End   of ADD:ERP-XXXX:WROY:24-Feb-2018:ED2K905573

* Begin by AMOHAMMED on 01/15/2021 TR # ED2K921163
* When the Message varient is 'Z9' call the function module
* to clear the material in POPO popup
CONSTANTS:
  lc_wricef_i0343   TYPE zdevid VALUE 'I0343', "Constant value for WRICEF (I0212.17)
  lc_ser_no_i0343_5 TYPE zsno   VALUE '005'.   "Serial Number (005)

DATA: lv_actv_flg_i0343 TYPE zactive_flag. "Active / Inactive flag

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_i0343  "Constant value for WRICEF (C030)
    im_ser_num     = lc_ser_no_i0343_5  "Serial Number (003)
  IMPORTING
    ex_active_flag = lv_actv_flg_i0343. "Active / Inactive flag

IF lv_actv_flag_i0343 = abap_true.

  CALL FUNCTION 'ZQTC_CLR_POPUP_MATERIAL'
    TABLES
      i_bdcdata = dxbdcdata.
ENDIF. " IF lv_actv_flag_i0343 = abap_true
* End by AMOHAMMED on 01/15/2021 TR # ED2K921163
