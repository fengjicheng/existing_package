*-------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_INBOUND_BDC_I0219
* PROGRAM DESCRIPTION:Royality Share Inbound.
* DEVELOPER: Nallapaneni Mounika
* CREATION DATE:   2016-09-29
* OBJECT ID:I0219
* TRANSPORT NUMBER(S):ED2K902882
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INBOUND_BDC_I0219
*&---------------------------------------------------------------------*


*** Local types declaration for XVBAK
TYPES: BEGIN OF lty_xvbak1. "Kopfdaten
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
TYPES: END OF lty_xvbak1.

*** Local work area declaration
DATA: lst_bdcdata1 TYPE bdcdata, " Batch input: New table field structure
      lst_idoc1    TYPE edidd,   " Data record (IDoc)
      lst_xvbak1   TYPE lty_xvbak1.
*** Local Data declaration
DATA: lv_line1  TYPE sytabix.  " Row Index of Internal Tables\

CONSTANTS : lc_docname TYPE FNAM_____4 VALUE 'RV45A-DOCNUM',
lc_bdc_okcode TYPE FNAM_____4 VALUE 'BDC_OKCODE' ,
lc_bdc_uer1   TYPE BDC_FVAL VALUE 'UER1',
lc_bdc_sapmv45a TYPE BDC_PROG VALUE 'sapmv45a',
lc_bdc_4001 TYPE BDC_DYNR VALUE '4001',
lc_bdc_x TYPE BDC_START VALUE 'X',
lc_bdc_kuagv-kunnr TYPE FNAM_____4 VALUE 'kuagv-kunnr',
lc_bdc_vbak-faksk TYPE  FNAM_____4 VALUE 'FNAM_____4'.


*** Changing BDCDATA table to populate Billing Block (VBAK-FAKSK)
DESCRIBE TABLE dxbdcdata LINES lv_line1.

* Read the Idoc Number from Idoc Data
READ TABLE didoc_data INTO lst_idoc1 INDEX 1.

* Reading BDCDATA table into a work area using last index
READ TABLE dxbdcdata INTO lst_bdcdata1 INDEX lv_line1.
IF sy-subrc IS INITIAL.
*   Check the FNAM and FVAL value of the Lst entry of BDCDATA
*   This is to restrict the execution of the code
  IF    lst_bdcdata1-fnam =  lc_docname  " Field Name of Idoc
    AND lst_bdcdata1-fval = lst_idoc1-docnum. " Idoc Number

    CLEAR lst_idoc1.
    lst_xvbak1 = dxvbak. " Putting VBAK data in local work area

*     Check whether Billing Block is not initial in DXVBAK structure
    IF lst_xvbak1-faksk IS NOT INITIAL.

      CLEAR lst_bdcdata1. " Clearing work area for BDC data
      lst_bdcdata1-fnam = lc_bdc_okcode. "'BDC_OKCODE'.
      lst_bdcdata1-fval = lc_bdc_uer1. "'UER1'.
      APPEND  lst_bdcdata1 TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata1.
      lst_bdcdata1-program = lc_bdc_sapmv45a."'SAPMV45A'.
      lst_bdcdata1-dynpro = lc_bdc_4001." '4001'.
      lst_bdcdata1-dynbegin = lc_bdc_x."'X'.
      APPEND lst_bdcdata1 TO dxbdcdata. " appending program and screen

      CLEAR lst_bdcdata1.
      lst_bdcdata1-fnam = lc_bdc_kuagv-kunnr."'KUAGV-KUNNR'.
      lst_bdcdata1-fval = lst_xvbak1-kunnr.
      APPEND lst_bdcdata1 TO dxbdcdata. " appending KUNNR

      CLEAR lst_bdcdata1.
      lst_bdcdata1-fnam = lc_bdc_vbak-faksk."'VBAK-FAKSK'.
      lst_bdcdata1-fval = lst_xvbak1-faksk.
      APPEND lst_bdcdata1 TO dxbdcdata. " appending Billing Block

    ENDIF. " IF lst_xvbak1-faksk IS NOT INITIAL
  ENDIF. " IF lst_bdcdata1-fnam = 'RV45A-DOCNUM'
ENDIF. " IF sy-subrc IS INITIAL
