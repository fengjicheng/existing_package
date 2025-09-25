*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INBOUND_BDC_I0212
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Inbound Sales Order
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   28/08/2016
* OBJECT ID: I0212
* TRANSPORT NUMBER(S): ED2K903010
*----------------------------------------------------------------------*


*** Local types declaration for XVBAK
TYPES: BEGIN OF lty_xvbak3. "Kopfdaten
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
TYPES: END OF lty_xvbak3.

*** Local work area declaration
DATA: lst_bdcdata3 TYPE bdcdata, " Batch input: New table field structure
      lst_idoc3    TYPE edidd,   " Data record (IDoc)
      lst_vbap10_212    TYPE lty_xvbap,
      lst_bdcdata9_212  TYPE bdcdata,                   " Batch input: New table field structure
      lst_bdcdata10_212 TYPE bdcdata,                   " Batch input: New table field structure
      lst_bdcdata11_212 TYPE bdcdata,                   " Batch input: New table field structure
      lv_tabix1_212     TYPE syindex,                   " Loop Index
      lst_xvbak3   TYPE lty_xvbak3.

*** Local Data declaration
DATA: lv_line3      TYPE sytabix, " Row Index of Internal Tables
      lst_e1edk03_3 TYPE e1edk03, " IDoc: Document header date segment
      lv_zmeng_212           TYPE char13,     " Zmeng of type CHAR13
      lv_kwmeng_212          TYPE char15,     " Kwmeng of type CHAR15
      lv_date       TYPE d,       " System Date
      lv_date1      TYPE dats.

*** local Constant declaration
CONSTANTS: lc_e1edk03_3 TYPE char7 VALUE 'E1EDK03',
           lc_022   TYPE edi_iddat VALUE '022'.

*** Changing BDCDATA table to populate Billing Block (VBAK-FAKSK)
DESCRIBE TABLE dxbdcdata LINES lv_line3.

* Read the Idoc Number from Idoc Data
READ TABLE didoc_data INTO lst_idoc3 INDEX 1.

* Reading BDCDATA table into a work area using last index
READ TABLE dxbdcdata INTO lst_bdcdata3 INDEX lv_line3.
IF sy-subrc IS INITIAL.
*   Check the FNAM and FVAL value of the Lst entry of BDCDATA
*   This is to restrict the execution of the code
  IF    lst_bdcdata3-fnam = 'RV45A-DOCNUM'    " Field Name of Idoc
    AND lst_bdcdata3-fval = lst_idoc3-docnum. " Idoc Number

    CLEAR lst_idoc3.
    lst_xvbak3 = dxvbak. " Putting VBAK data in local work area


    LOOP AT didoc_data INTO lst_idoc3 WHERE segnam = lc_e1edk03_3.
      lst_e1edk03_3 = lst_idoc3-sdata.
      IF lst_e1edk03_3-iddat = lc_022.
        lv_date1 = lst_e1edk03_3-datum.
        WRITE lv_date1 TO lv_date.
        EXIT.
      ENDIF. " IF lst_e1edk03_3-iddat = '022'
    ENDLOOP. " LOOP AT didoc_data INTO lst_idoc3 WHERE segnam = 'E1EDK03'

*     Check whether Billing Block is not initial in DXVBAK structure
    IF lst_xvbak3-faksk IS NOT INITIAL
      OR lv_date IS NOT INITIAL.
      CLEAR lst_bdcdata3. " Clearing work area for BDC data
      lst_bdcdata3-fnam = 'BDC_OKCODE'.
      lst_bdcdata3-fval = 'UER1'.
      APPEND  lst_bdcdata3 TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata3.
      lst_bdcdata3-program = 'SAPMV45A'.
      lst_bdcdata3-dynpro = '4001'.
      lst_bdcdata3-dynbegin = 'X'.
      APPEND lst_bdcdata3 TO dxbdcdata. " appending program and screen

      CLEAR lst_bdcdata3.
      lst_bdcdata3-fnam = 'KUAGV-KUNNR'.
      lst_bdcdata3-fval = lst_xvbak3-kunnr.
      APPEND lst_bdcdata3 TO dxbdcdata. " appending KUNNR

      IF lst_xvbak3-faksk IS NOT INITIAL.
        CLEAR lst_bdcdata3.
        lst_bdcdata3-fnam = 'VBAK-FAKSK'.
        lst_bdcdata3-fval = lst_xvbak3-faksk.
        APPEND lst_bdcdata3 TO dxbdcdata. " appending Billing Block
      ENDIF. " IF lst_xvbak3-faksk IS NOT INITIAL

      IF lv_date IS NOT INITIAL.
        CLEAR lst_bdcdata3.
        lst_bdcdata3-fnam = 'VBKD-BSTDK'.
        lst_bdcdata3-fval = lv_date.
        APPEND lst_bdcdata3 TO dxbdcdata. " appending Billing Block
      ENDIF. " IF lv_date IS NOT INITIAL

    ENDIF. " IF lst_xvbak3-faksk IS NOT INITIAL
  ENDIF. " IF lst_bdcdata3-fnam = 'RV45A-DOCNUM'
ENDIF. " IF sy-subrc IS INITIAL

*** Code to insert KWMENG
lst_vbap10_212 = dxvbap. " Copy the value in local work area

IF lst_vbap10_212-posnr EQ 1.
  lv_zmeng_212 = 'VBAP-ZMENG(1)'. "ZMENG Field Name
ELSE.
  lv_zmeng_212 = 'VBAP-ZMENG(2)'. "ZMENG Field Name
ENDIF.

LOOP AT dxbdcdata INTO lst_bdcdata9_212 WHERE fnam = lv_zmeng_212.
  lv_tabix1_212 = sy-tabix. " Storing the index of ZMENG
ENDLOOP.
IF sy-subrc = 0.
  IF lst_vbap10_212-posnr EQ 1.
    lv_kwmeng_212 = 'RV45A-KWMENG(1)'. "KWMENG Field Name
  ELSE.
    lv_kwmeng_212 = 'RV45A-KWMENG(2)'. "KWMENG Field Name
  ENDIF.

  READ TABLE dxbdcdata INTO lst_bdcdata11_212 INDEX ( lv_tabix1_212 - 1 ).
  IF sy-subrc EQ 0 AND
     lst_bdcdata11_212-fnam NE lv_kwmeng_212.

    lst_bdcdata10_212-dynpro = '0000'.
    lst_bdcdata10_212-fnam = lv_kwmeng_212.
    lst_bdcdata10_212-fval = lst_bdcdata9_212-fval.

    INSERT lst_bdcdata10_212 INTO dxbdcdata INDEX lv_tabix1_212.
    CLEAR: lst_bdcdata11_212, lst_bdcdata10_212. " appending KWMENG
  ENDIF. " IF sy-subrc NE 0
  CLEAR lst_bdcdata9_212.
ENDIF. " IF sy-subrc = 0
