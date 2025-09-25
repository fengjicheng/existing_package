*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INSO_I0212_17
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INSO_I0212_17 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Inbound Sales Order
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   09/03/2017
* OBJECT ID: I0212.17
* TRANSPORT NUMBER(S): ED2K904859
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
*** Local Structure declaration for XVBAK
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

*** Local Structure declaration of XVBAP
*-------------------->>> XVBAP
TYPES: BEGIN OF lty_xvbap10. "Position
        INCLUDE STRUCTURE vbap. " Sales Document: Item Data
TYPES:  matnr_output(40) TYPE c,                 "Longer matnr ALRK165416
        wmeng(18)        TYPE c,                 "Wunschliefermenge
        lfdat            LIKE vbap-abdat,        "Wunschlieferdatum
        kschl            LIKE komv-kschl,        "Konditinsschlüssel
        kbtrg(16)        TYPE c,                 "Konditionsbetrag
        kschl_netwr      LIKE komv-kschl,        "Konditinsschlüssel
        kbtrg_netwr(16)  TYPE c,                 "Konditionswert
        inco1            LIKE vbkd-inco1,        "Incoterms 1
        inco2            LIKE vbkd-inco2,        "Incoterms 2
        inco2_l          LIKE vbkd-inco2_l,      "Incoterms 2_L
        inco3_l          LIKE vbkd-inco3_l,      "Incoterms 3_L
        incov            LIKE vbkd-incov,        "Incoterms v
        yantlf(1)        TYPE c,                 "Anzahl Teillieferungen
        prsdt            LIKE vbkd-prsdt,        "Preisdatum
        hprsfd           LIKE tvap-prsfd,        "Preisfindung durchführen
        bstkd_e          LIKE vbkd-bstkd_e,      "Bestellnummer Warenempfänger
        bstdk_e          LIKE vbkd-bstdk_e,      "Bestelldatum Warenempfänger
        bsark_e          LIKE vbkd-bsark_e,      "Bestellart des Warenempfängers
        ihrez_e          LIKE vbkd-ihrez_e,      "Zeichen des Warenempfängers
        posex_e          LIKE vbkd-posex_e,      "Posnr. Bestellung
        lpnnr            LIKE vbak-vbeln,        "Lieferplannummer
        empst            LIKE vbkd-empst,        "Empfangsstelle
        ablad            LIKE vbpa-ablad,        "Abladestelle
        knref            LIKE vbpa-knref,        "Kundenindividuelle Bez.
        lpnnr_posnr      LIKE vbap-posnr,        "Lieferplanpositionsnummer
        kdkg1            LIKE vbkd-kdkg1,        "Kunden Konditionsgruppe 1
        kdkg2            LIKE vbkd-kdkg2,        "Kunden Konditionsgruppe 2
        kdkg3            LIKE vbkd-kdkg3,        "Kunden Konditionsgruppe 3
        kdkg4            LIKE vbkd-kdkg4,        "Kunden Konditionsgruppe 4
        kdkg5            LIKE vbkd-kdkg5,        "Kunden Konditionsgruppe 5
        abtnr            LIKE vbkd-abtnr,        "Abteilungsnummer
        delco            LIKE vbkd-delco,        "vereinbarte Lieferzeit
        angbt            LIKE vbak-vbeln,        "Angebotsnummer Lieferant (SAP)
        angbt_posnr      LIKE vbap-posnr,        "Angebotspositionsnummer
        contk            LIKE vbak-vbeln,        "Kontraknummer Lieferant (SAP)
        contk_posnr      LIKE vbap-posnr,        "Kontrakpositionsnummer
        angbt_ref        LIKE vbkd-bstkd,        "Angebotsnummer Kunde (SAP)
        angbt_posex      LIKE vbap-posex,        "Angebotspositionsnummer
        contk_ref        LIKE vbkd-bstkd,        "Kontraknummer Kunde  (SAP)
        contk_posex      LIKE vbap-posex,        "Kontrakpositionsnummer
        config_id        LIKE e1curef-config_id, " External Configuration ID (Temporary)
        inst_id          LIKE e1curef-inst_id,   " Instance Number in Configuration
        kompp            LIKE tvap-kompp,        "Liefergruppe bilden
        currdec          LIKE tcurx-currdec,     "Dezimalstellen Währung
        curcy            LIKE e1edp01-curcy,     "Währung
        valdt            LIKE vbkd-valdt,        "Valuta-Fixdatum
        valtg            LIKE vbkd-valtg,        "Valutatage
        vaddi(1)         TYPE c,                 " Vaddi(1) of type Character
        END OF lty_xvbap10.

*** Local Structure declaration for XVBADR
TYPES: BEGIN OF lty_xvbadr10,    "Partner
         posnr LIKE vbap-posnr,  " Sales Document Item
         parvw LIKE vbpa-parvw,  " Partner Function
         kunnr LIKE rv02p-kunde, " Partner number (KUNNR, LIFNR, or PERNR)
         ablad LIKE vbpa-ablad,  " Unloading Point
         knref LIKE knvp-knref.  " Customer description of partner (plant, storage location)
        INCLUDE STRUCTURE vbadr. " Address work area
TYPES: END OF lty_xvbadr10.

***** Local Types Declaration for DD_FLAG
TYPES: BEGIN OF d_flag_k17,
         eins(1)   TYPE c, " Eins(1) of type Character
         kkau(1)   TYPE c, " Kkau(1) of type Character
         uer2(1)   TYPE c, " Uer2(1) of type Character
         kbes(1)   TYPE c, " Kbes(1) of type Character
         pbes(1)   TYPE c, " Pbes(1) of type Character
         pkau(1)   TYPE c, " Pkau(1) of type Character
         pein(1)   TYPE c, " Pein(1) of type Character
         eid1(1)   TYPE c, " Eid1(1) of type Character
         eian(1)   TYPE c, " Eian(1) of type Character
         kparag(1) TYPE c, " Kparag(1) of type Character
         psdeag(1) TYPE c, " Psdeag(1) of type Character
         kparlf(1) TYPE c, " Kparlf(1) of type Character
         psdelf(1) TYPE c, " Psdelf(1) of type Character
         kparwe(1) TYPE c, " Kparwe(1) of type Character
         psdewe(1) TYPE c, " Psdewe(1) of type Character
         kparre(1) TYPE c, " Kparre(1) of type Character
         psdere(1) TYPE c, " Psdere(1) of type Character
         kparrg(1) TYPE c, " Kparrg(1) of type Character
         psderg(1) TYPE c, " Psderg(1) of type Character
         kparsp(1) TYPE c, " Kparsp(1) of type Character
         psdesp(1) TYPE c, " Psdesp(1) of type Character
         kparzz(1) TYPE c, " Kparzz(1) of type Character
         psdezz(1) TYPE c, " Psdezz(1) of type Character
         rang(1)   TYPE c, " Rang(1) of type Character
         rkon(1)   TYPE c, " Rkon(1) of type Character
         kde1(1)   TYPE c, " Kde1(1) of type Character
         kde2(1)   TYPE c, " Kde2(1) of type Character
         kkon(1)   TYPE c, " Kkon(1) of type Character
         uer1(1)   TYPE c, " Uer1(1) of type Character
         kde3(1)   TYPE c, " Kde3(1) of type Character
         kgru(1)   TYPE c, " Kgru(1) of type Character
         krpl(1)   TYPE c, " Krpl(1) of type Character
         kzku(1)   TYPE c, " Kzku(1) of type Character
       END OF d_flag_k17.



** Local Structure Declaration
DATA:lst_xvbak10 TYPE lty_xvbak10,
     lst_xvbap10 TYPE lty_xvbap10,
     lst_flag_17    TYPE d_flag_k17,
     lst_e1edk01_10 TYPE e1edk01. " IDoc: Document header general data.

** Local Structure Declaration for segments
DATA:  lst_z1qtc_e1edka1_01_10 TYPE z1qtc_e1edka1_01. " Partner Information (Legacy Customer Number)

*** Local Data Declaration
DATA: lv_partn10 TYPE bu_id_number, " Identification Number
      lv_zssn10  TYPE ismidentcode, " Identification Code
      lv_tabix10 TYPE sytabix,      " Row Index of Internal Tables
      lv_kunnr10 TYPE kunnr.        " Customer Number

*** Local constant declaration
CONSTANTS: lc_ag10                TYPE parvw VALUE 'AG',                    " Partner Function
           lc_zssn10              TYPE ismidcodetype VALUE 'ZSSN',          " Type of Identification Code
           lc_z1qtc_e1edka1_01_10 TYPE edilsegtyp VALUE 'Z1QTC_E1EDKA1_01', " Segment type
           lc_e1edk01_10          TYPE edilsegtyp VALUE 'E1EDK01',
           lc_e1edp19_10          TYPE edilsegtyp VALUE 'E1EDP19'.          " Segment type


*** Local field symbol declaration
FIELD-SYMBOLS: <lst_xvbadr_10> TYPE lty_xvbadr10.

CASE segment-segnam.
  WHEN lc_z1qtc_e1edka1_01_10. " Segment for legacy customer
*** keeping the segment data in local work area
    lst_z1qtc_e1edka1_01_10 = segment-sdata.
    DESCRIBE TABLE dxvbadr LINES lv_tabix10.
*** Fetching partner information
    READ TABLE dxvbadr ASSIGNING <lst_xvbadr_10> INDEX lv_tabix10.
    IF <lst_xvbadr_10> IS ASSIGNED.
      lv_partn10 = lst_z1qtc_e1edka1_01_10-partner.
      lst_xvbak10 = dxvbak.
*** Calling FM to convert Customer
      CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_CUSTOMER'
        EXPORTING
          im_company_code    = lst_xvbak10-vkorg
          im_leg_customer    = lv_partn10
        IMPORTING
          ex_sap_customer    = lv_kunnr10
        EXCEPTIONS
          wrong_input_values = 1
          invalid_comp_code  = 2
          OTHERS             = 3.

      IF sy-subrc = 0 AND lv_kunnr10 IS NOT INITIAL.

        <lst_xvbadr_10>-kunnr = lv_kunnr10.
      ELSE. " ELSE -> IF sy-subrc = 0 AND lv_kunnr10 IS NOT INITIAL
        <lst_xvbadr_10>-kunnr = lv_partn10.
      ENDIF. " IF sy-subrc = 0 AND lv_kunnr10 IS NOT INITIAL
*** Checking the partner type and if it is 'AG' the
*** Inserting partner value in XVBAK structure
      IF <lst_xvbadr_10>-parvw = lc_ag10.
        lst_xvbak10 = dxvbak.
        lst_xvbak10-kunnr = <lst_xvbadr_10>-kunnr.
        dxvbak = lst_xvbak10.
      ENDIF. " IF <lst_xvbadr_10>-parvw = lc_ag10

    ENDIF. " IF <lst_xvbadr_10> IS ASSIGNED

*** If the segment is E1EDP19 then we are fetching material from it
*** and converting it
  WHEN lc_e1edp19_10.
*** Storing XVBAP in local work area
    lst_xvbap10 = dxvbap.
    lv_zssn10   = lst_xvbap10-matnr.
***** Calling FM to convert legacy material into SAP Material
    CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
      EXPORTING
        im_idcodetype      = lc_zssn10
        im_legacy_material = lv_zssn10
      IMPORTING
        ex_sap_material    = lst_xvbap10-matnr
      EXCEPTIONS
        wrong_input_values = 1
        OTHERS             = 2.

    IF sy-subrc = 0.
      dxvbap = lst_xvbap10.
    ENDIF. " IF sy-subrc = 0

  WHEN lc_e1edk01_10.
    lst_e1edk01_10 = segment-sdata.
    IF lst_e1edk01_10-bsart IS NOT INITIAL.
      CLEAR: lst_xvbak10.
      lst_xvbak10 = dxvbak.
      lst_xvbak10-bsark = lst_e1edk01_10-bsart.
      dxvbak = lst_xvbak10.

      lst_flag_17 = dd_flag_k.
      lst_flag_17-kbes = abap_true.
      dd_flag_k = lst_flag_17.
    ENDIF.
ENDCASE.
