*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVDBU01 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Sales Order Determination
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   18/10/2016
* OBJECT ID: I0238
* TRANSPORT NUMBER(S):  ED2K903103
*----------------------------------------------------------------------*
*** Local Structure declaration of XVBADR
TYPES: BEGIN OF lty_xvbadr_238 , "Partner
         posnr LIKE vbap-posnr,  " Sales Document Item
         parvw LIKE vbpa-parvw,  " Partner Function
         kunnr LIKE rv02p-kunde, " Partner number (KUNNR, LIFNR, or PERNR)
         ablad LIKE vbpa-ablad.  " Unloading Point
        INCLUDE STRUCTURE vbadr. " Address work area
TYPES: END OF lty_xvbadr_238.

*** Local Structure declaration of XVBAP
*-------------------->>> XVBAP
TYPES: BEGIN OF lty_xvbap_238. "Position
        INCLUDE STRUCTURE vbap. " Sales Document: Item Data
TYPES:  matnr_output(40) TYPE c,            "Longer matnr ALRK165416
        wldat            LIKE vbak-bstdk,   "Wunschlieferdatum
        loekz(3)         TYPE c,            "Loeschkennzeichen
        wmeng(18)        TYPE c,            "Wunschliefermenge
        kschl            LIKE komv-kschl,   "Konditinsschlüssel
        kbtrg(16)        TYPE c,            "Konditionsbetrag
        kschl_netwr      LIKE komv-kschl,   "Konditinsschlüssel
        kbtrg_netwr(16)  TYPE c,            "Konditionswert
        incov            LIKE vbkd-incov,   "Incoterms v
        inco1            LIKE vbkd-inco1,   "Incoterms 1
        inco2            LIKE vbkd-inco2,   "Incoterms 2
        inco2_l          LIKE vbkd-inco2_l, "Incoterms 2_l
        inco3_l          LIKE vbkd-inco3_l, "Incoterms 3_l
        yantlf(1)        TYPE c,            "Anzahl Teillieferungen
        prsdt            LIKE vbkd-prsdt,   "Preisdatum
        hprsfd           LIKE tvap-prsfd,   "Preisfindung durchführen
        bstkd_e          LIKE vbkd-bstkd_e, "Bestellnummer Warenempfänger
        bstdk_e          LIKE vbkd-bstdk_e, "Bestelldatum Warenempfänger
        bsark_e          LIKE vbkd-bsark_e, "Bestellart des Warenempfängers
        ihrez_e          LIKE vbkd-ihrez_e, "Zeichen des Warenempfängers
        posex_e          LIKE vbkd-posex_e, "Posnr. Bestellung
        empst            LIKE vbkd-empst,   "Empfangsstelle
        ablad            LIKE vbpa-ablad,   "Abladestelle
        knref            LIKE vbpa-knref,   "Kundenindividuelle Bez.
        kdkg1            LIKE vbkd-kdkg1,   "Kunden Konditionsgruppe 1
        kdkg2            LIKE vbkd-kdkg2,   "Kunden Konditionsgruppe 2
        kdkg3            LIKE vbkd-kdkg3,   "Kunden Konditionsgruppe 3
        kdkg4            LIKE vbkd-kdkg4,   "Kunden Konditionsgruppe 4
        kdkg5            LIKE vbkd-kdkg5,   "Kunden Konditionsgruppe 5
        abtnr            LIKE vbkd-abtnr,   "Abteilungsnummer
        delco            LIKE vbkd-delco,   "vereinbarte Lieferzeit
        config_id        LIKE e1curef-config_id, " External Configuration ID (Temporary)
        inst_id          LIKE e1curef-inst_id,   " Instance Number in Configuration
        kompp            LIKE tvap-kompp,        "Liefergruppe bilden
        currdec          LIKE tcurx-currdec,     "Dezimalstellen Währung
        curcy            LIKE e1edp01-curcy,     "Währung
        valdt            LIKE vbkd-valdt,        "Valuta-Fixdatum
        valtg            LIKE vbkd-valtg,        "Valutatage
        vaddi(1)         TYPE c,                 " Vaddi(1) of type Character
        END OF lty_xvbap_238.

*** Local types Declaration for VBAK
TYPES: BEGIN OF lty_xvbak_238. "Kopfdaten
        INCLUDE STRUCTURE vbak. " Sales Document: Header Data
TYPES:  bstkd   LIKE vbkd-bstkd,     "Bestellnummer
        kursk   LIKE vbkd-kursk,     "Währungskurs
        zterm   LIKE vbkd-zterm,     "Zahlungsbedingungsschlüssel
        incov   LIKE vbkd-incov,     "Incoterms Teil v
        inco1   LIKE vbkd-inco1,     "Incoterms Teil 1
        inco2   LIKE vbkd-inco2,     "Incoterms Teil 2
        inco2_l LIKE vbkd-inco2_l,   "Incoterms Teil 2_l
        inco3_l LIKE vbkd-inco3_l,   "Incoterms Teil 3_l
        prsdt   LIKE vbkd-prsdt,     "Datum für Preisfindung
        angbt   LIKE vbak-vbeln,     "Angebotsnummer Lieferant (SAP)
        contk   LIKE vbak-vbeln,     "Kontraknummer Lieferant (SAP)
        kzazu   LIKE vbkd-kzazu,     "Kz. Auftragszusammenführung
        fkdat   LIKE vbkd-fkdat,     "Datum für Faktura-/Rechnungsind
        fbuda   LIKE vbkd-fbuda,     "Datum der Leistungserstellung
        empst   LIKE vbkd-empst,     "Empfangsstelle
        valdt   LIKE vbkd-valdt,     "Valuta-Fix Datum
        kdkg1   LIKE vbkd-kdkg1,     "Kunden Konditionsgruppe 1
        kdkg2   LIKE vbkd-kdkg2,     "Kunden Konditionsgruppe 2
        kdkg3   LIKE vbkd-kdkg3,     "Kunden Konditionsgruppe 3
        kdkg4   LIKE vbkd-kdkg4,     "Kunden Konditionsgruppe 4
        kdkg5   LIKE vbkd-kdkg5,     "Kunden Konditionsgruppe 5
        ccins   LIKE ccdata-ccins,   "Zahlungskarten: Kartenart
        ccnum   LIKE ccdata-ccnum,   "Zahlungskarten: kartennummer
        exdatbi LIKE ccdate-exdatbi, "Zahlungskarte gültig bis
        delco   LIKE vbkd-delco,     "vereinbarte Lieferzeit
        abtnr   LIKE vbkd-abtnr,     "Abteilungsnummmer
        currdec LIKE tcurx-currdec,  "Dezimalstellen Währung
        END OF lty_xvbak_238.

*** Local Data Declaration
DATA: lv_vbeln  TYPE vbeln_va,     " Sales Document
      lv_tabix  TYPE sytabix,      " Row Index of Internal Tables
      lv_jrnl2  TYPE ismidentcode, " Identification Code
      lv_partn2 TYPE bu_id_number, " Identification Number
      lv_kunnr2 TYPE kunnr.        " Customer Number

DATA: lst_e1edk01_238          TYPE e1edk01,          " IDoc: Document header general data
      lst_xvbak_238            TYPE lty_xvbak_238,
      lst_xvbap_238            TYPE lty_xvbap_238,
      lst_e1edka1_238          TYPE e1edka1,          " IDoc: Document Header Partner Information
      lst_z1qtc_e1edka1_01_238 TYPE z1qtc_e1edka1_01. " Partner Information (Legacy Customer Number)

*** Local field symbol declaration
FIELD-SYMBOLS: <lst_xvbadr_238> TYPE lty_xvbadr_238.

*** Local Constant Declaration
CONSTANTS: lc_zsub  TYPE auart VALUE 'ZSUB',         " Sales Document Type
           lc_ag2   TYPE parvw VALUE 'AG',           " Partner Function
           lc_jrnl2 TYPE ismidcodetype VALUE 'JRNL', " Type of Identification Code
           lc_00    TYPE posnr VALUE '000000'.       " Item number of the SD document


  IF segment-segnam = 'E1EDKA1'.
    lst_e1edka1_238 = segment-sdata.
    IF lst_e1edka1_238-hausn IS NOT INITIAL.

      DESCRIBE TABLE dxvbadr LINES lv_tabix.
***   Fetching partner information
      READ TABLE dxvbadr ASSIGNING <lst_xvbadr_238> INDEX lv_tabix.
      IF <lst_xvbadr_238> IS ASSIGNED.
        <lst_xvbadr_238>-hausn = lst_e1edka1_238-hausn.
      ENDIF. " IF <lst_xvbadr_238> IS ASSIGNED
    ENDIF. " IF lst_e1edka1_238-hausn IS NOT INITIAL
  ENDIF. " IF segment-segnam = 'E1EDKA1'

  IF segment-segnam = 'Z1QTC_E1EDKA1_01'.

*** keeping the segment data in local work area
    lst_z1qtc_e1edka1_01_238 = segment-sdata.
    DESCRIBE TABLE dxvbadr LINES lv_tabix.
*** Fetching partner information
    READ TABLE dxvbadr ASSIGNING <lst_xvbadr_238> INDEX lv_tabix.

    IF <lst_xvbadr_238> IS ASSIGNED.

      lv_partn2 = lst_z1qtc_e1edka1_01_238-partner.
      lst_xvbak_238 = dxvbak.
*** Calling FM to convert Customer
      CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_CUSTOMER'
        EXPORTING
          im_company_code    = lst_xvbak_238-vkorg
          im_leg_customer    = lv_partn2
        IMPORTING
          ex_sap_customer    = lv_kunnr2
        EXCEPTIONS
          wrong_input_values = 1
          invalid_comp_code  = 2
          OTHERS             = 3.
      IF sy-subrc = 0.
* Implement suitable error handling here
        <lst_xvbadr_238>-kunnr = lv_kunnr2.
      ELSE. " ELSE -> IF sy-subrc = 0
        <lst_xvbadr_238>-kunnr = lv_partn2.
      ENDIF. " IF sy-subrc = 0

*** Checking the partner type and if it is 'AG' the
*** Inserting partner value in XVBAK structure
      IF <lst_xvbadr_238>-parvw = lc_ag2.
        lst_xvbak_238 = dxvbak.
        lst_xvbak_238-kunnr = <lst_xvbadr_238>-kunnr.
        dxvbak = lst_xvbak_238.
      ENDIF. " IF <lst_xvbadr_238>-parvw = lc_ag2
    ENDIF. " IF <lst_xvbadr_238> IS ASSIGNED

  ENDIF. " IF segment-segnam = 'Z1QTC_E1EDKA1_01'

*** If the segment is E1EDP19 then we are fetching material from it
*** and converting it

  IF segment-segnam = 'E1EDP19'.
*** Storing XVBAP in local work area
    lst_xvbap_238 = dxvbap.
    lv_jrnl2   = lst_xvbap_238-matnr.
***** Calling FM to convert legacy material into SAP Material
    CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
      EXPORTING
        im_idcodetype      = lc_jrnl2
        im_legacy_material = lv_jrnl2
      IMPORTING
        ex_sap_material    = lst_xvbap_238-matnr
      EXCEPTIONS
        wrong_input_values = 1
        OTHERS             = 2.
    IF sy-subrc = 0.
* Implement suitable error handling here
      dxvbap = lst_xvbap_238.
    ENDIF. " IF sy-subrc = 0


  ENDIF. " IF segment-segnam = 'E1EDP19'

  IF segment-segnam = 'E1EDK01'.
    lst_e1edk01_238 = segment-sdata.

*   Get Sap Sales Order Number from legacy order number
    SELECT a~vbeln " Sales and Distribution Document Number
      UP TO 1 ROWS
      FROM vbak AS a
      INNER JOIN vbkd AS b ON b~vbeln = a~vbeln
                          AND b~posnr = lc_00
      INTO lv_vbeln
      WHERE a~auart = lc_zsub
        AND b~ihrez = lst_e1edk01_238-belnr.
    ENDSELECT.
    IF sy-subrc IS INITIAL.
      lst_xvbak_238 = dxvbak.
      lst_xvbak_238-vbeln = lv_vbeln.
      dxvbak = lst_xvbak_238.
    ELSE. " ELSE -> IF sy-subrc IS INITIAL
      MESSAGE e014(zqtc_r2) RAISING user_error WITH lst_e1edk01_238-belnr. " No Sales Order Exist for Your Reference &
    ENDIF. " IF sy-subrc IS INITIAL

  ENDIF. " IF segment-segnam = 'E1EDK01'
