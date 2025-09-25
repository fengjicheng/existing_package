*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVDBU02 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for populating BDC DATA
*
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   18/10/2016
* OBJECT ID: I0238
* TRANSPORT NUMBER(S):  ED2K903103
*----------------------------------------------------------------------*
*** Local types declaration for XVBAK
TYPES: BEGIN OF lty_xvbak_238. "Kopfdaten
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
TYPES: END OF lty_xvbak_238.

*** Local Structure declaration for XVBADR
TYPES: BEGIN OF lty_xvbadr_238 , "Partner
         posnr LIKE vbap-posnr,  " Sales Document Item
         parvw LIKE vbpa-parvw,  " Partner Function
         kunnr LIKE rv02p-kunde, " Partner number (KUNNR, LIFNR, or PERNR)
         ablad LIKE vbpa-ablad.  " Unloading Point
        INCLUDE STRUCTURE vbadr. " Address work area
TYPES: END OF lty_xvbadr_238.

*** Local work area and local internal table declaration
DATA: lst_bdcdata_238      TYPE bdcdata,                   " Batch input: New table field structure
      lst_xvbak_238        TYPE lty_xvbak_238,
      lst_xvbadr_238       TYPE lty_xvbadr_238,
      lst_z1qtc_e1edk01_01 TYPE z1qtc_e1edk01_01,          " Header General Data Entension
      lst_idoc             TYPE edidd,                     " Data record (IDoc)
      lst_xvbap            TYPE vbap,                      " Sales Document: Item Data
      li_bdcdata           TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
      l_fnam               TYPE fnam_____4,                " Field name
      l_fval               TYPE bdc_fval,                  " BDC field value
      lst_yvbap            TYPE vbap.                      " Sales Document: Item Data

*** Local Data declaration
DATA: lv_line  TYPE sytabix, " Row Index of Internal Tables
      lv_tabix TYPE sytabix. " Row Index of Internal Tables

FIELD-SYMBOLS: <lst_bdcdata> TYPE bdcdata. " Batch input: New table field structure



  DESCRIBE TABLE dxbdcdata LINES lv_line.
  READ TABLE didoc_data INTO lst_idoc INDEX 1.

*** Reading BDCDATA table into a work area
  READ TABLE dxbdcdata INTO lst_bdcdata_238 INDEX lv_line.
  IF sy-subrc IS INITIAL.
    IF lst_bdcdata_238-fnam = 'RV45A-DOCNUM'
      AND lst_bdcdata_238-fval = lst_idoc-docnum.

*     Assign XVBAK data into local structure to
*     get payment card information
      lst_xvbak_238 = dxvbak.

*     Get Payment Method and cancelletion rule
*     from segment 'Z1QTC_E1EDK01_01'
      READ TABLE didoc_data INTO lst_idoc WITH KEY segnam = 'Z1QTC_E1EDK01_01' .
      IF sy-subrc IS INITIAL.
        lst_z1qtc_e1edk01_01 = lst_idoc-sdata.
      ENDIF. " IF sy-subrc IS INITIAL

      CLEAR lst_bdcdata_238. " Clearing work area for BDC data
      lst_bdcdata_238-fnam = 'BDC_OKCODE'.
      lst_bdcdata_238-fval = 'UER1'.
      APPEND  lst_bdcdata_238 TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata_238.
      lst_bdcdata_238-program = 'SAPMV45A'.
      lst_bdcdata_238-dynpro = '4001'.
      lst_bdcdata_238-dynbegin = 'X'.
      APPEND lst_bdcdata_238 TO dxbdcdata. " appending program and screen

      CLEAR lst_bdcdata_238. " Clearing work area for BDC data
      lst_bdcdata_238-fnam = 'BDC_OKCODE'.
      lst_bdcdata_238-fval = 'KKAU'.
      APPEND  lst_bdcdata_238 TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata_238.
      lst_bdcdata_238-program = 'SAPMV45A'.
      lst_bdcdata_238-dynpro = '4002'.
      lst_bdcdata_238-dynbegin = 'X'.
      APPEND lst_bdcdata_238 TO dxbdcdata. " appending program and screen

*--------------->> Payment Method
      IF lst_z1qtc_e1edk01_01-zlsch IS NOT INITIAL.
        CLEAR lst_bdcdata_238. " Clearing work area for BDC data
        lst_bdcdata_238-fnam = 'BDC_OKCODE'.
        lst_bdcdata_238-fval = 'KBUC'.
        APPEND  lst_bdcdata_238 TO dxbdcdata. "appending OKCODE

        CLEAR lst_bdcdata_238.
        lst_bdcdata_238-program = 'SAPMV45A'.
        lst_bdcdata_238-dynpro = '4002'.
        lst_bdcdata_238-dynbegin = 'X'.
        APPEND lst_bdcdata_238 TO dxbdcdata. " appending program and screen

        CLEAR lst_bdcdata_238.
        lst_bdcdata_238-fnam = 'VBKD-ZLSCH'.
        lst_bdcdata_238-fval = lst_z1qtc_e1edk01_01-zlsch.
        APPEND lst_bdcdata_238 TO dxbdcdata. " appending billing date
      ENDIF. " IF lst_z1qtc_e1edk01_01-zlsch IS NOT INITIAL

*-------------->> Payment Card
      IF lst_xvbak_238-ccins IS NOT INITIAL
        AND lst_xvbak_238-ccnum IS NOT INITIAL
        AND lst_xvbak_238-exdatbi IS NOT INITIAL.
        CLEAR lst_bdcdata_238. " Clearing work area for BDC data
        lst_bdcdata_238-fnam = 'BDC_OKCODE'.
        lst_bdcdata_238-fval = 'KRPL'.
        APPEND  lst_bdcdata_238 TO dxbdcdata. "appending OKCODE

        CLEAR lst_bdcdata_238.
        lst_bdcdata_238-program = 'SAPLV60F'.
        lst_bdcdata_238-dynpro = '4001'.
        lst_bdcdata_238-dynbegin = 'X'.
        APPEND lst_bdcdata_238 TO dxbdcdata. " appending program and screen

        CLEAR lst_bdcdata_238.
        lst_bdcdata_238-fnam = 'FPLTC-CCINS(01)'.
        lst_bdcdata_238-fval = lst_xvbak_238-ccins.
        APPEND lst_bdcdata_238 TO dxbdcdata. " appending Card Type

        CLEAR lst_bdcdata_238.
        lst_bdcdata_238-fnam = 'FPLTC-CCNUM(01)'.
        lst_bdcdata_238-fval = lst_xvbak_238-ccnum.
        APPEND lst_bdcdata_238 TO dxbdcdata. " Card Number

        CLEAR lst_bdcdata_238.
        lst_bdcdata_238-fnam = 'CCDATE-EXDATBI(01)'.
        lst_bdcdata_238-fval = lst_xvbak_238-exdatbi.
        APPEND lst_bdcdata_238 TO dxbdcdata. " Expiration Date
      ENDIF. " IF lst_xvbak_238-ccins IS NOT INITIAL
*------------>> Cancelletion Rull
      CLEAR lst_bdcdata_238. " Clearing work area for BDC data
      lst_bdcdata_238-fnam = 'BDC_OKCODE'.
      lst_bdcdata_238-fval = 'KVER'.
      APPEND  lst_bdcdata_238 TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata_238.
      lst_bdcdata_238-program = 'SAPLV45W'.
      lst_bdcdata_238-dynpro = '4001'.
      lst_bdcdata_238-dynbegin = 'X'.
      APPEND lst_bdcdata_238 TO dxbdcdata. " appending program and screen

      IF lst_z1qtc_e1edk01_01-vkuesch IS NOT INITIAL.
        CLEAR lst_bdcdata_238.
        lst_bdcdata_238-fnam = 'VEDA-VKUESCH'.
        lst_bdcdata_238-fval = lst_z1qtc_e1edk01_01-vkuesch.
        APPEND lst_bdcdata_238 TO dxbdcdata. " appending billing date
      ENDIF. " IF lst_z1qtc_e1edk01_01-vkuesch IS NOT INITIAL

*------------>> Back to the main screen
      CLEAR lst_bdcdata_238. " Clearing work area for BDC data
      lst_bdcdata_238-fnam = 'BDC_OKCODE'.
      lst_bdcdata_238-fval = 'BACK'.
      APPEND  lst_bdcdata_238 TO dxbdcdata. "appending OKCODE

      CLEAR lst_bdcdata_238.
      lst_bdcdata_238-program = 'SAPMV45A'.
      lst_bdcdata_238-dynpro = '4001'.
      lst_bdcdata_238-dynbegin = 'X'.
      APPEND lst_bdcdata_238 TO dxbdcdata. " appending program and screen


    ENDIF. " IF lst_bdcdata_238-fnam = 'RV45A-DOCNUM'


*-------->> Update Material In an existing line item
    MOVE-CORRESPONDING dxvbap TO lst_xvbap.
    lst_yvbap = dyvbap.
    IF lst_bdcdata_238-fnam = 'VBAP-POSEX(1)'
      AND lst_bdcdata_238-fval = lst_yvbap-posnr.

      IF lst_xvbap-matnr NE lst_yvbap-matnr.
        lst_bdcdata_238-fnam = 'VBAP-MATNR(1)'.
        lst_bdcdata_238-fval = lst_xvbap-matnr.
        APPEND lst_bdcdata_238 TO dxbdcdata.
      ENDIF. " IF lst_xvbap-matnr NE lst_yvbap-matnr
    ENDIF. " IF lst_bdcdata_238-fnam = 'VBAP-POSEX(1)'

*---------------->> Start of Populating house number
    IF   lst_bdcdata_238-fnam = 'BDC_OKCODE'
     AND lst_bdcdata_238-fval = 'SICH'.

      CLEAR:  lst_bdcdata_238,l_fval.
      CLEAR:  lst_bdcdata_238,l_fval.
      l_fnam = 'BDC_OKCODE'.
      l_fval = 'UER2'.
      IF l_fval IS NOT INITIAL.
        lst_bdcdata_238-fnam = l_fnam.
        lst_bdcdata_238-fval = l_fval.
        APPEND lst_bdcdata_238 TO li_bdcdata.
      ENDIF. " IF l_fval IS NOT INITIAL

      CLEAR:  lst_bdcdata_238,l_fval.
      CLEAR:  lst_bdcdata_238,l_fval.
      l_fnam = 'BDC_OKCODE'.
      l_fval = 'KPAR_SUB'.
      IF l_fval IS NOT INITIAL.
        lst_bdcdata_238-fnam = l_fnam.
        lst_bdcdata_238-fval = l_fval.
        APPEND lst_bdcdata_238 TO li_bdcdata.
      ENDIF. " IF l_fval IS NOT INITIAL

      CLEAR:  lst_bdcdata_238,l_fval.
      lst_bdcdata_238-program = 'SAPMV45A'.
      lst_bdcdata_238-dynpro  =  '4002'.
      lst_bdcdata_238-dynbegin   = 'X'.
      APPEND lst_bdcdata_238 TO li_bdcdata.


      LOOP AT dxvbadr INTO lst_xvbadr_238.
        IF lst_xvbadr_238-hausn IS NOT INITIAL.

          CLEAR:  lst_bdcdata_238,l_fval.
          CLEAR:  lst_bdcdata_238,l_fval.
          l_fnam = 'BDC_OKCODE'.
          l_fval = 'PAPO'.
          IF l_fval IS NOT INITIAL.
            lst_bdcdata_238-fnam = l_fnam.
            lst_bdcdata_238-fval = l_fval.
            APPEND lst_bdcdata_238 TO li_bdcdata.
          ENDIF. " IF l_fval IS NOT INITIAL

          CLEAR:  lst_bdcdata_238,l_fval.
          lst_bdcdata_238-program = 'SAPLV09C'.
          lst_bdcdata_238-dynpro  =  '0666'.
          lst_bdcdata_238-dynbegin   = 'X'.
          APPEND lst_bdcdata_238 TO li_bdcdata.

          CLEAR:  lst_bdcdata_238,l_fval.
          CLEAR:  lst_bdcdata_238,l_fval.
          l_fnam = 'DV_PARVW'.
          l_fval = lst_xvbadr_238-parvw.
          IF l_fval IS NOT INITIAL.
            lst_bdcdata_238-fnam = l_fnam.
            lst_bdcdata_238-fval = l_fval.
            APPEND lst_bdcdata_238 TO li_bdcdata.
          ENDIF. " IF l_fval IS NOT INITIAL

          CLEAR:  lst_bdcdata_238,l_fval.
          lst_bdcdata_238-program = 'SAPMV45A'.
          lst_bdcdata_238-dynpro  =  '4002'.
          lst_bdcdata_238-dynbegin   = 'X'.
          APPEND lst_bdcdata_238 TO li_bdcdata.

          CLEAR:  lst_bdcdata_238,l_fval.
          CLEAR:  lst_bdcdata_238,l_fval.
          l_fnam = 'BDC_OKCODE'.
          l_fval = 'PSDE'.
          IF l_fval IS NOT INITIAL.
            lst_bdcdata_238-fnam = l_fnam.
            lst_bdcdata_238-fval = l_fval.
            APPEND lst_bdcdata_238 TO li_bdcdata.
          ENDIF. " IF l_fval IS NOT INITIAL

          CLEAR:  lst_bdcdata_238,l_fval.
          lst_bdcdata_238-program = 'SAPLV09C'.
          lst_bdcdata_238-dynpro  =  '5000'.
          lst_bdcdata_238-dynbegin   = 'X'.
          APPEND lst_bdcdata_238 TO li_bdcdata.

          CLEAR:  lst_bdcdata_238,l_fval.
          CLEAR:  lst_bdcdata_238,l_fval.
          l_fnam = 'ADDR1_DATA-HOUSE_NUM1'.
          l_fval = lst_xvbadr_238-hausn.
          IF l_fval IS NOT INITIAL.
            lst_bdcdata_238-fnam = l_fnam.
            lst_bdcdata_238-fval = l_fval.
            APPEND lst_bdcdata_238 TO li_bdcdata.
          ENDIF. " IF l_fval IS NOT INITIAL

          CLEAR:  lst_bdcdata_238,l_fval.
          CLEAR:  lst_bdcdata_238,l_fval.
          l_fnam = 'BDC_OKCODE'.
          l_fval = 'ENT1'.
          IF l_fval IS NOT INITIAL.
            lst_bdcdata_238-fnam = l_fnam.
            lst_bdcdata_238-fval = l_fval.
            APPEND lst_bdcdata_238 TO li_bdcdata.
          ENDIF. " IF l_fval IS NOT INITIAL

          CLEAR:  lst_bdcdata_238,l_fval.
          lst_bdcdata_238-program = 'SAPMV45A'.
          lst_bdcdata_238-dynpro  =  '4002'.
          lst_bdcdata_238-dynbegin   = 'X'.
          APPEND lst_bdcdata_238 TO li_bdcdata.


        ENDIF. " IF lst_xvbadr_238-hausn IS NOT INITIAL
      ENDLOOP. " LOOP AT dxvbadr INTO lst_xvbadr_238

      DESCRIBE TABLE dxbdcdata LINES lv_tabix.
      READ TABLE dxbdcdata ASSIGNING <lst_bdcdata> INDEX lv_tabix.
      IF <lst_bdcdata> IS ASSIGNED.
        <lst_bdcdata>-fval = 'OWN_OKCODE'.
      ENDIF. " IF <lst_bdcdata> IS ASSIGNED
      INSERT LINES OF li_bdcdata INTO dxbdcdata INDEX lv_tabix.

    ENDIF. " IF lst_bdcdata_238-fnam = 'BDC_OKCODE'

    IF   lst_bdcdata_238-fnam = 'BDC_OKCODE'
     AND lst_bdcdata_238-fval = 'OWN_OKCODE'.

      DESCRIBE TABLE dxbdcdata LINES lv_tabix.
      READ TABLE dxbdcdata ASSIGNING <lst_bdcdata> INDEX lv_tabix.
      IF <lst_bdcdata> IS ASSIGNED.
        <lst_bdcdata>-fval = 'SICH'.
      ENDIF. " IF <lst_bdcdata> IS ASSIGNED

    ENDIF. " IF lst_bdcdata_238-fnam = 'BDC_OKCODE'
*<<---------------- End of populating House Number
  ENDIF. " IF sy-subrc IS INITIAL
