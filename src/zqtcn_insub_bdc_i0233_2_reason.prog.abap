*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVDBU02 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for populating BDC DATA
*
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   24/10/2016
* OBJECT ID: I0233.2
* TRANSPORT NUMBER(S):  ED2K903117
*----------------------------------------------------------------------*
*** Local types declaration for XVBAK
TYPES: BEGIN OF lty_xvbak_233_r. "Kopfdaten
        INCLUDE STRUCTURE vbak. " Sales Document: Header Data
TYPES:  bstkd LIKE vbkd-bstkd. "Bestellnummer
TYPES:  kursk LIKE vbkd-kursk. "Währungskurs
TYPES:  zterm LIKE vbkd-zterm. "Zahlungsbedingungsschlüssel
TYPES:  incov LIKE vbkd-incov. "Incoterms Teil v
TYPES:  inco1 LIKE vbkd-inco1. "Incoterms Teil 1
TYPES:  inco2 LIKE vbkd-inco2. "Incoterms Teil 2
TYPES:  inco2_l LIKE vbkd-inco2_l. "Incoterms Teil 2_l
TYPES:  inco3_l LIKE vbkd-inco3_l. "Incoterms Teil 3_l
TYPES:  prsdt LIKE vbkd-prsdt. "Datum für Preisfindung
TYPES:  angbt LIKE vbak-vbeln. "Angebotsnummer Lieferant (SAP)
TYPES:  contk LIKE vbak-vbeln. "Kontraknummer Lieferant (SAP)
TYPES:  kzazu LIKE vbkd-kzazu. "Kz. Auftragszusammenführung
TYPES:  fkdat LIKE vbkd-fkdat. "Datum für Faktura-/Rechnungsind
TYPES:  fbuda LIKE vbkd-fbuda. "Datum der Leistungserstellung
TYPES:  empst LIKE vbkd-empst. "Empfangsstelle
TYPES:  valdt LIKE vbkd-valdt. "Valuta-Fix Datum
TYPES:  kdkg1 LIKE vbkd-kdkg1. "Kunden Konditionsgruppe 1
TYPES:  kdkg2 LIKE vbkd-kdkg2. "Kunden Konditionsgruppe 2
TYPES:  kdkg3 LIKE vbkd-kdkg3. "Kunden Konditionsgruppe 3
TYPES:  kdkg4 LIKE vbkd-kdkg4. "Kunden Konditionsgruppe 4
TYPES:  kdkg5 LIKE vbkd-kdkg5. "Kunden Konditionsgruppe 5
TYPES:  ccins LIKE ccdata-ccins. "Zahlungskarten: Kartenart
TYPES:  ccnum LIKE ccdata-ccnum. "Zahlungskarten: kartennummer
TYPES:  exdatbi LIKE ccdate-exdatbi. "Zahlungskarte gültig bis
TYPES:  delco LIKE vbkd-delco. "vereinbarte Lieferzeit
TYPES:  abtnr LIKE vbkd-abtnr. "Abteilungsnummmer
TYPES:  currdec LIKE tcurx-currdec. "Dezimalstellen Währung
TYPES: END OF lty_xvbak_233_r.

*** Local Structure declaration for XVBADR
TYPES: BEGIN OF lty_xvbadr_233_2_r , "Partner
         posnr LIKE vbap-posnr,      " Sales Document Item
         parvw LIKE vbpa-parvw,      " Partner Function
         kunnr LIKE rv02p-kunde,     " Partner number (KUNNR, LIFNR, or PERNR)
         ablad LIKE vbpa-ablad.      " Unloading Point
        INCLUDE STRUCTURE vbadr. " Address work area
TYPES: END OF lty_xvbadr_233_2_r.

*** Local Structure for VEDA
TYPES: BEGIN OF lty_veda_233_2_r,
         vbeln   TYPE vbeln_va,   " Sales Document
         vposn   TYPE posnr_va,   " Sales Document Item
         vkuesch TYPE vkues_veda, " Assignment cancellation procedure/cancellation rule
         vkuegru TYPE vkgru_veda, " Reason for Cancellation of Contract
       END OF lty_veda_233_2_r.


*** Local work area and local internal table declaration
DATA: lst_vbadr_233_r      TYPE lty_xvbadr_233_2_r,
      li_bdcdata_233_r     TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
      lst_bdcdata_233_2_r  TYPE bdcdata,                   " Batch input: New table field structure
      lst_idoc1            TYPE edidd,                     " Data record (IDoc)
      lst_xvbak_233_r      TYPE lty_xvbak_233_r,
      lst_z1qtc_e1edp01_01 TYPE z1qtc_e1edp01_01,          " Item General Data Entension
      lst_veda_233_2_r     TYPE lty_veda_233_2_r,
      lst_didoc_data_233_r TYPE edidd.                     " Data record (IDoc)

*** Local Data declaration
DATA:  lv_line1_r    TYPE sytabix,    " Row Index of Internal Tables
       lv_tabix1_r   TYPE sytabix,    " Row Index of Internal Tables
       lv_fnam_233_r TYPE fnam_____4, " Field name
       lv_fval_233_r TYPE bdc_fval,   " BDC field value
       lv_temp       TYPE sy-datum,   " ABAP System Field: Current Date of Application Server
       lv_dt         TYPE char10,     " Dt of type CHAR10
       lv_vkuesch    TYPE vkues_veda, " Assignment cancellation procedure/cancellation rule
       lv_vkuegru    TYPE vkgru_veda, " Reason for Cancellation of Contract
       lv_vbeln_r    TYPE vbeln_va.   " Sales Document

*** Local Field Symbol declaration
FIELD-SYMBOLS: <lst_bdcdata_233_r> TYPE bdcdata. " Batch input: New table field structure

*** Local Constant declaration
CONSTANTS: lc_bok2  TYPE fnam_____4 VALUE 'BDC_OKCODE', " Field name
           lc_z1qtc_e1edp01_01 TYPE char16 VALUE 'Z1QTC_E1EDP01_01'.


DESCRIBE TABLE dxbdcdata LINES lv_line1_r.

*Read the Idoc Number from Idoc Data
READ TABLE didoc_data INTO lst_didoc_data_233_r INDEX 1.

* Reading BDCDATA table into a work area using last index
READ TABLE dxbdcdata INTO lst_bdcdata_233_2_r INDEX lv_line1_r.
IF sy-subrc IS INITIAL.



  IF   lst_bdcdata_233_2_r-fnam = lc_bok2
  AND lst_bdcdata_233_2_r-fval = 'SICH'.


*** Get Cancellation Procedure and Reason for Cancellation
*** From segment 'Z1QTC_E1EDP01_01'
    READ TABLE didoc_data INTO lst_idoc1 WITH KEY segnam = lc_z1qtc_e1edp01_01.

    IF sy-subrc = 0.
      lst_z1qtc_e1edp01_01 = lst_idoc1-sdata.
      lv_vkuesch   = lst_z1qtc_e1edp01_01-vkuesch.
      lv_vkuegru   = lst_z1qtc_e1edp01_01-vkuegru.
    ENDIF. " IF sy-subrc = 0
    IF lv_vkuesch IS NOT INITIAL
      AND lv_vkuegru IS NOT INITIAL.

      CLEAR:  lst_bdcdata_233_2_r,lv_fval_233_r.
      CLEAR:  lst_bdcdata_233_2_r,lv_fval_233_r.
      lv_fnam_233_r = lc_bok2.
      lv_fval_233_r = 'UER2'.
      IF lv_fval_233_r IS NOT INITIAL.
        lst_bdcdata_233_2_r-fnam = lv_fnam_233_r.
        lst_bdcdata_233_2_r-fval = lv_fval_233_r.
        APPEND lst_bdcdata_233_2_r TO li_bdcdata_233_r.
      ENDIF. " IF lv_fval_233_r IS NOT INITIAL

      CLEAR:  lst_bdcdata_233_2_r,lv_fval_233_r.
      CLEAR:  lst_bdcdata_233_2_r,lv_fval_233_r.
      lv_fnam_233_r = lc_bok2.
      lv_fval_233_r = 'POPO'.
      IF lv_fval_233_r IS NOT INITIAL.
        lst_bdcdata_233_2_r-fnam = lv_fnam_233_r.
        lst_bdcdata_233_2_r-fval = lv_fval_233_r.
        APPEND lst_bdcdata_233_2_r TO li_bdcdata_233_r.
      ENDIF. " IF lv_fval_233_r IS NOT INITIAL

      CLEAR: lst_bdcdata_233_2_r, lv_fnam_233_r.
      lst_bdcdata_233_2_r-program = 'SAPMV45A'.
      lst_bdcdata_233_2_r-dynpro  =  '0251'.
      lst_bdcdata_233_2_r-dynbegin   = 'X'.
      APPEND lst_bdcdata_233_2_r TO li_bdcdata_233_r.

      CLEAR: lst_bdcdata_233_2_r, lv_fnam_233_r.
      CLEAR:  lst_bdcdata_233_2_r,lv_fval_233_r.
      lv_fnam_233_r = 'BDC_CURSOR'.
      lv_fval_233_r = 'RV45A-POSNR'.
      IF lv_fval_233_r IS NOT INITIAL.
        lst_bdcdata_233_2_r-fnam = lv_fnam_233_r.
        lst_bdcdata_233_2_r-fval = lv_fval_233_r.
        APPEND lst_bdcdata_233_2_r TO li_bdcdata_233_r.
      ENDIF. " IF lv_fval_233_r IS NOT INITIAL

      CLEAR: lst_bdcdata_233_2_r, lv_fnam_233_r.
      CLEAR:  lst_bdcdata_233_2_r,lv_fval_233_r.
      lv_fnam_233_r = lc_bok2.
      lv_fval_233_r = 'POSI'.
      IF lv_fval_233_r IS NOT INITIAL.
        lst_bdcdata_233_2_r-fnam = lv_fnam_233_r.
        lst_bdcdata_233_2_r-fval = lv_fval_233_r.
        APPEND lst_bdcdata_233_2_r TO li_bdcdata_233_r.
      ENDIF. " IF lv_fval_233_r IS NOT INITIAL

      CLEAR: lst_bdcdata_233_2_r, lv_fnam_233_r.
      CLEAR:  lst_bdcdata_233_2_r,lv_fval_233_r.
      lv_fnam_233_r = 'RV45A-POSNR'.
      lv_fval_233_r = '000010'.
      IF lv_fval_233_r IS NOT INITIAL.
        lst_bdcdata_233_2_r-fnam = lv_fnam_233_r.
        lst_bdcdata_233_2_r-fval = lv_fval_233_r.
        APPEND lst_bdcdata_233_2_r TO li_bdcdata_233_r.
      ENDIF. " IF lv_fval_233_r IS NOT INITIAL

      CLEAR: lst_bdcdata_233_2_r, lv_fnam_233_r.
      lst_bdcdata_233_2_r-program = 'SAPMV45A'.
      lst_bdcdata_233_2_r-dynpro  =  '4001'.
      lst_bdcdata_233_2_r-dynbegin   = 'X'.
      APPEND lst_bdcdata_233_2_r TO li_bdcdata_233_r.


      CLEAR: lst_bdcdata_233_2_r, lv_fnam_233_r.
      CLEAR:  lst_bdcdata_233_2_r,lv_fval_233_r.
      lv_fnam_233_r = lc_bok2.
      lv_fval_233_r = 'PKAU'.
      IF lv_fval_233_r IS NOT INITIAL.
        lst_bdcdata_233_2_r-fnam = lv_fnam_233_r.
        lst_bdcdata_233_2_r-fval = lv_fval_233_r.
        APPEND lst_bdcdata_233_2_r TO li_bdcdata_233_r.
      ENDIF. " IF lv_fval_233_r IS NOT INITIAL

      CLEAR: lst_bdcdata_233_2_r, lv_fnam_233_r.
      lst_bdcdata_233_2_r-program = 'SAPMV45A'.
      lst_bdcdata_233_2_r-dynpro  =  '4003'.
      lst_bdcdata_233_2_r-dynbegin   = 'X'.
      APPEND lst_bdcdata_233_2_r TO li_bdcdata_233_r.


      CLEAR lst_bdcdata_233_2_r.
      lst_bdcdata_233_2_r-fnam = 'BDC_OKCODE'.
      lst_bdcdata_233_2_r-fval = 'PVER'.
      APPEND  lst_bdcdata_233_2_r TO  li_bdcdata_233_r.

      CLEAR lst_bdcdata_233_2_r.
      lst_bdcdata_233_2_r-program = 'SAPLV45W'.
      lst_bdcdata_233_2_r-dynpro  = '4001'.
      lst_bdcdata_233_2_r-dynbegin = 'X'.
      APPEND lst_bdcdata_233_2_r TO  li_bdcdata_233_r.

      CLEAR lst_bdcdata_233_2_r.
      lst_bdcdata_233_2_r-fnam = 'VEDA-VKUESCH'.
      lst_bdcdata_233_2_r-fval = lv_vkuesch.
      APPEND lst_bdcdata_233_2_r TO  li_bdcdata_233_r.

      CLEAR lst_bdcdata_233_2_r.
      lst_bdcdata_233_2_r-fnam = 'VEDA-VKUEGRU'.
      lst_bdcdata_233_2_r-fval = lv_vkuegru.
      APPEND lst_bdcdata_233_2_r TO  li_bdcdata_233_r.

      CLEAR lst_bdcdata_233_2_r.
      lst_bdcdata_233_2_r-fnam = 'VEDA-VEINDAT'.

*      lv_temp = sy-datum.
*
*      CONCATENATE  lv_temp+4(2) lv_temp+6(2) lv_temp+0(4) INTO lv_dt SEPARATED BY '/'.
      WRITE sy-datum TO lv_dt.
      lst_bdcdata_233_2_r-fval = lv_dt.

      APPEND lst_bdcdata_233_2_r TO  li_bdcdata_233_r.


      CLEAR lst_bdcdata_233_2_r.
      lst_bdcdata_233_2_r-fnam = 'VEDA-VWUNDAT'.

      lst_bdcdata_233_2_r-fval = lv_dt.
      APPEND lst_bdcdata_233_2_r TO  li_bdcdata_233_r.


      CLEAR lst_bdcdata_233_2_r.
      lst_bdcdata_233_2_r-fnam = 'VEDA-VBEDKUE'.

      lst_bdcdata_233_2_r-fval = lv_dt.
      CLEAR: lv_dt.
      APPEND lst_bdcdata_233_2_r TO  li_bdcdata_233_r.

*      CLEAR lst_bdcdata_233_2_r.
*      lst_bdcdata_233_2_r-program = 'SAPLSPO1'.
*      lst_bdcdata_233_2_r-dynpro  = '0400'.
*      lst_bdcdata_233_2_r-dynbegin = 'X'.
*      APPEND lst_bdcdata_233_2_r TO  li_bdcdata_233_r.
*
*      CLEAR lst_bdcdata_233_2_r.
*      lst_bdcdata_233_2_r-fnam = lc_bok2.
*      lst_bdcdata_233_2_r-fval = '=NO'.
*      APPEND lst_bdcdata_233_2_r TO li_bdcdata_233_r.
*
*      CLEAR lst_bdcdata_233_2_r.
*      lst_bdcdata_233_2_r-program = 'SAPLV45W'.
*      lst_bdcdata_233_2_r-dynpro = '4001'.
*      lst_bdcdata_233_2_r-dynbegin = 'X'.
*      APPEND lst_bdcdata_233_2_r TO li_bdcdata_233_r.

      CLEAR lst_bdcdata_233_2_r.
      lst_bdcdata_233_2_r-fnam = lc_bok2.
      lst_bdcdata_233_2_r-fval = 'BACK'.
      APPEND lst_bdcdata_233_2_r TO li_bdcdata_233_r.

      CLEAR lst_bdcdata_233_2_r.
      lst_bdcdata_233_2_r-program = 'SAPMV45A'.
      lst_bdcdata_233_2_r-dynpro = '4001'.
      lst_bdcdata_233_2_r-dynbegin = 'X'.
      APPEND lst_bdcdata_233_2_r TO li_bdcdata_233_r.





    ENDIF. " IF lst_veda_233_2_r-vkuesch IS NOT INITIAL


    DESCRIBE TABLE dxbdcdata LINES lv_tabix1_r.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_233_r> INDEX lv_tabix1_r.
    IF <lst_bdcdata_233_r> IS ASSIGNED.
      <lst_bdcdata_233_r>-fval = 'OWN_OKCODE'.
    ENDIF. " IF <lst_bdcdata_233_r> IS ASSIGNED
    INSERT LINES OF li_bdcdata_233_r INTO dxbdcdata INDEX lv_tabix1_r.
  ENDIF. " IF lst_bdcdata_233_2_r-fnam = lc_bok2


  IF   lst_bdcdata_233_2_r-fnam = lc_bok2
   AND lst_bdcdata_233_2_r-fval = 'OWN_OKCODE'.

    DESCRIBE TABLE dxbdcdata LINES lv_tabix1_r.
    READ TABLE dxbdcdata ASSIGNING <lst_bdcdata_233_r> INDEX lv_tabix1_r.
    IF <lst_bdcdata_233_r> IS ASSIGNED.
      <lst_bdcdata_233_r>-fval = 'SICH'.
    ENDIF. " IF <lst_bdcdata_233_r> IS ASSIGNED

  ENDIF. " IF lst_bdcdata_233_2_r-fnam = lc_bok2
ENDIF. " IF sy-subrc IS INITIAL
