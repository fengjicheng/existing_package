*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INSO_BDC_I0297 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Entitlement Usage
* DEVELOPER: SAYANDAS (Sayantan Das )
* CREATION DATE:   13/01/2017
* OBJECT ID: I0297
* TRANSPORT NUMBER(S): ED2K904122
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
*** Local types declaration for XVBAK
TYPES: BEGIN OF lty_xvbak7. "Kopfdaten
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
TYPES: END OF lty_xvbak7.

*****
"Changed OCCURS 50 to OCCURS 0
TYPES: BEGIN OF lty_xvbap7. "Position
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
TYPES: END OF lty_xvbap7.
*****

TYPES: BEGIN OF lty_item7,
         posex TYPE posex,  " Item Number of the Underlying Purchase Order
         mvgr3 TYPE mvgr3,  " Material group 3
         artno TYPE zartno, " Article Number
       END OF lty_item7.


*** Local work area declaration
DATA: lst_bdcdata7 TYPE bdcdata,                   " Batch input: New table field structure
      lst_idoc7    TYPE edidd,                     " Data record (IDoc)
      lst_xvbak7   TYPE lty_xvbak7,
      lst_vbap7    TYPE lty_xvbap7,
      li_vbap7     TYPE STANDARD TABLE OF lty_xvbap7,
      lst_item7    TYPE lty_item7,
      li_item7     TYPE STANDARD TABLE OF lty_item7,
      li_bdcdata97 TYPE STANDARD TABLE OF bdcdata. " Batch input: New table field structure


*** Local Data declaration
DATA: lv_line7               TYPE sytabix,          " Row Index of Internal Tables
      lst_e1edk03_7          TYPE e1edk03,          " IDoc: Document header date segment
      lst_z1qtc_e1edp01_01_7 TYPE z1qtc_e1edp01_01, " IDOC Segment for STATUS Field in Item Level
      lst_z1qtc_e1edk01_01_7 TYPE z1qtc_e1edk01_01, " Header General Data Entension
      lv_posex7              TYPE string,
      lv_mvgr3               TYPE mvgr3,            " Material group 3
      lv_promo               TYPE zpromo,           " Promo code
      lv_artno               TYPE zartno,           " Article Number
      lv_tabix_0297          TYPE sytabix,          " Row Index of Internal Tables
      lv_date7               TYPE d,                " System Date
      lv_date71              TYPE dats.             " Field of type DATS

FIELD-SYMBOLS: <lst_bdcdata_0297> TYPE bdcdata. " Batch input: New table field structure

*** local Constant declaration
CONSTANTS: lc_e1edk03_7        TYPE char7 VALUE 'E1EDK03',           " E1edk03_7 of type CHAR7
           lc_z1qtc_e1edp01_01 TYPE char16 VALUE 'Z1QTC_E1EDP01_01', " Z1qtc_e1edp01_01 of type CHAR16
           lc_z1qtc_e1edk01_01 TYPE char16 VALUE 'Z1QTC_E1EDK01_01', " Z1qtc_e1edk01_01 of type CHAR16
           lc_022_7            TYPE edi_iddat VALUE '022'.           " Qualifier for IDOC date segment

*** getting number of lines in BDCDATA
DESCRIBE TABLE dxbdcdata LINES lv_line7.

* Read the Idoc Number from Idoc Data
READ TABLE didoc_data INTO lst_idoc7 INDEX 1.
* Reading BDCDATA table into a work area using last index
READ TABLE dxbdcdata INTO lst_bdcdata7 INDEX lv_line7.
IF sy-subrc IS INITIAL.
*   Check the FNAM and FVAL value of the Lst entry of BDCDATA
*   This is to restrict the execution of the code

  IF lst_bdcdata7-fnam = 'BDC_OKCODE'
    AND lst_bdcdata7-fval = 'SICH'.


    CLEAR lst_idoc7.
    lst_xvbak7 = dxvbak.

    LOOP AT didoc_data INTO lst_idoc7. " WHERE segnam = lc_e1edk03_7.
      CASE lst_idoc7-segnam.

        WHEN lc_e1edk03_7.
          lst_e1edk03_7 = lst_idoc7-sdata.
          IF lst_e1edk03_7-iddat = lc_022_7.
            lv_date71 = lst_e1edk03_7-datum.
            WRITE lv_date71 TO lv_date7.

          ENDIF. " IF lst_e1edk03_7-iddat = lc_022_7


        WHEN lc_z1qtc_e1edp01_01.
          CLEAR: lst_z1qtc_e1edp01_01_7,
                 lv_mvgr3, lv_artno.
          lst_z1qtc_e1edp01_01_7 = lst_idoc7-sdata.
          lv_posex7 = lst_z1qtc_e1edp01_01_7-vposn.
          lv_mvgr3 = lst_z1qtc_e1edp01_01_7-mvgr3.
          lv_artno = lst_z1qtc_e1edp01_01_7-zzartno.

        WHEN lc_z1qtc_e1edk01_01.
          CLEAR: lst_z1qtc_e1edk01_01_7, lv_promo.
          lst_z1qtc_e1edk01_01_7 = lst_idoc7-sdata.
          lv_promo = lst_z1qtc_e1edk01_01_7-zzpromo.

      ENDCASE.

      IF lv_posex7 IS NOT INITIAL.

        lst_item7-posex = lv_posex7.
        lst_item7-mvgr3 = lv_mvgr3.
        lst_item7-artno = lv_artno.

        APPEND lst_item7 TO li_item7.
        CLEAR: lst_item7.
      ENDIF. " IF lv_posex7 IS NOT INITIAL
      CLEAR: lst_idoc7.
    ENDLOOP. " LOOP AT didoc_data INTO lst_idoc7

    IF lv_date7 IS NOT INITIAL. " Populating PO DATE in BDCDATA
      CLEAR lst_bdcdata7. " Clearing work area for BDC data
      lst_bdcdata7-fnam = 'BDC_OKCODE'.
      lst_bdcdata7-fval = 'UER1'.
      APPEND  lst_bdcdata7 TO li_bdcdata97. "appending OKCODE

      CLEAR lst_bdcdata7.
      lst_bdcdata7-program = 'SAPMV45A'.
      lst_bdcdata7-dynpro = '4001'.
      lst_bdcdata7-dynbegin = 'X'.
      APPEND lst_bdcdata7 TO li_bdcdata97. " appending program and screen


      CLEAR lst_bdcdata7.
      lst_bdcdata7-fnam = 'VBKD-BSTDK'.
      lst_bdcdata7-fval = lv_date7.
      APPEND lst_bdcdata7 TO li_bdcdata97. " appending Billing Block
    ENDIF. " IF lv_date7 IS NOT INITIAL

    IF lv_promo IS NOT INITIAL. " Populating Promo Code in BDCDATA

      CLEAR lst_bdcdata7. " Clearing work area for BDC data
      lst_bdcdata7-fnam = 'BDC_OKCODE'.
      lst_bdcdata7-fval = 'UER1'.
      APPEND  lst_bdcdata7 TO li_bdcdata97. "appending OKCODE
*
      CLEAR lst_bdcdata7.
      lst_bdcdata7-program = 'SAPMV45A'.
      lst_bdcdata7-dynpro = '4001'.
      lst_bdcdata7-dynbegin = 'X'.
      APPEND lst_bdcdata7 TO li_bdcdata97. " appending program and screen

      CLEAR lst_bdcdata7. " Clearing work area for BDC data
      lst_bdcdata7-fnam = 'BDC_OKCODE'.
      lst_bdcdata7-fval = 'KZKU'.
      APPEND  lst_bdcdata7 TO li_bdcdata97. "appending OKCODE

      CLEAR lst_bdcdata7.
      lst_bdcdata7-program = 'SAPMV45A'.
      lst_bdcdata7-dynpro = '4002'.
      lst_bdcdata7-dynbegin = 'X'.
      APPEND  lst_bdcdata7 TO li_bdcdata97. "appending OKCODE

      CLEAR lst_bdcdata7.
      lst_bdcdata7-fnam = 'VBAK-ZZPROMO'.
      lst_bdcdata7-fval = lv_promo.
      APPEND lst_bdcdata7 TO li_bdcdata97.

    ENDIF. " IF lv_promo IS NOT INITIAL

*******
*** Getting back to Initial Screen
    CLEAR lst_bdcdata7. " Clearing work area for BDC data
    lst_bdcdata7-fnam = 'BDC_OKCODE'.
    lst_bdcdata7-fval = 'UER1'.
    APPEND  lst_bdcdata7 TO li_bdcdata97. "appending OKCODE

    IF dxvbap[] IS NOT INITIAL.

      li_vbap7[] = dxvbap[].

      IF lv_mvgr3 IS NOT INITIAL
      OR lv_artno IS NOT INITIAL.

        SORT li_item7 BY posex.
        DELETE ADJACENT DUPLICATES FROM li_item7.
        LOOP AT li_vbap7 INTO lst_vbap7.

          CLEAR lst_bdcdata7.
          lst_bdcdata7-program = 'SAPMV45A'.
          lst_bdcdata7-dynpro = '4001'.
          lst_bdcdata7-dynbegin = 'X'.
          APPEND lst_bdcdata7 TO li_bdcdata97.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_vbap7-posex
            IMPORTING
              output = lst_vbap7-posex.

          READ TABLE li_item7 INTO lst_item7  WITH KEY posex = lst_vbap7-posex BINARY SEARCH.
          IF sy-subrc = 0.



            IF lst_item7-artno IS NOT INITIAL. " Populating Article number in BDCDATA

              CLEAR: lst_bdcdata7.
              lst_bdcdata7-fnam = 'BDC_OKCODE'.
              lst_bdcdata7-fval = 'POPO'.
              APPEND lst_bdcdata7 TO li_bdcdata97.

              CLEAR: lst_bdcdata7.
              lst_bdcdata7-program = 'SAPMV45A'.
              lst_bdcdata7-dynpro = '251'.
              lst_bdcdata7-dynbegin = 'X'.
              APPEND lst_bdcdata7 TO li_bdcdata97.

              CLEAR: lst_bdcdata7.
              lst_bdcdata7-fnam = 'RV45A-PO_POSEX'.
              lst_bdcdata7-fval = lst_vbap7-posex.
              APPEND lst_bdcdata7 TO li_bdcdata97.

              CLEAR: lst_bdcdata7.
              lst_bdcdata7-program = 'SAPMV45A'.
              lst_bdcdata7-dynpro = '4001'.
              lst_bdcdata7-dynbegin = 'X'.
              APPEND lst_bdcdata7 TO li_bdcdata97.


              CLEAR lst_bdcdata7.
              lst_bdcdata7-fnam = 'BDC_OKCODE'.
              lst_bdcdata7-fval = '=PZKU'.
              APPEND lst_bdcdata7 TO li_bdcdata97.

              CLEAR lst_bdcdata7.
              lst_bdcdata7-program = 'SAPMV45A'.
              lst_bdcdata7-dynpro = '4003'.
              lst_bdcdata7-dynbegin = 'X'.
              APPEND lst_bdcdata7 TO li_bdcdata97.

              CLEAR lst_bdcdata7.
              lst_bdcdata7-fnam = 'BDC_CURSOR'.
              lst_bdcdata7-fval = 'VBAP-ZZARTNO'.
              APPEND lst_bdcdata7 TO li_bdcdata97.

              CLEAR lst_bdcdata7.
              lst_bdcdata7-fnam = 'VBAP-ZZARTNO'.
              lst_bdcdata7-fval = lst_item7-artno.
              APPEND lst_bdcdata7 TO li_bdcdata97.

              CLEAR lst_bdcdata7.
              lst_bdcdata7-fnam = 'BDC_OKCODE'.
              lst_bdcdata7-fval = '/EBACK'.
              APPEND lst_bdcdata7 TO li_bdcdata97.

              CLEAR lst_bdcdata7.
              lst_bdcdata7-program = 'SAPMV45A'.
              lst_bdcdata7-dynpro = '4001'.
              lst_bdcdata7-dynbegin = 'X'.
              APPEND lst_bdcdata7 TO li_bdcdata97.

            ENDIF. " IF lst_item7-artno IS NOT INITIAL

          ENDIF. " IF sy-subrc = 0


        ENDLOOP. " LOOP AT li_vbap7 INTO lst_vbap7

      ENDIF. " IF lv_mvgr3 IS NOT INITIAL
    ENDIF. " IF dxvbap[] IS NOT INITIAL
********* Item segment

    DESCRIBE TABLE dxbdcdata LINES lv_tabix_0297.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0297> INDEX lv_tabix_0297.
    IF <lst_bdcdata_0297> IS ASSIGNED.
      <lst_bdcdata_0297>-fval = 'OWN_OKCODE'.
    ENDIF. " IF <lst_bdcdata_0297> IS ASSIGNED
    INSERT LINES OF li_bdcdata97 INTO dxbdcdata INDEX lv_tabix_0297.

  ENDIF. " IF lst_bdcdata7-fnam = 'BDC_OKCODE'

  IF   lst_bdcdata7-fnam = 'BDC_OKCODE'
   AND lst_bdcdata7-fval = 'OWN_OKCODE'.

    DESCRIBE TABLE dxbdcdata LINES lv_tabix_0297.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_0297> INDEX lv_tabix_0297.
    IF <lst_bdcdata_0297> IS ASSIGNED.
      <lst_bdcdata_0297>-fval = 'SICH'.
    ENDIF. " IF <lst_bdcdata_0297> IS ASSIGNED

  ENDIF. " IF lst_bdcdata7-fnam = 'BDC_OKCODE'
ENDIF. " IF sy-subrc IS INITIAL
