*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INORD03
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Inbound Sales Order
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   28/08/2016
* OBJECT ID: I0212
* TRANSPORT NUMBER(S): ED2K903010
*----------------------------------------------------------------------*
*** Local Structure declaration for XVBAK
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

*** Local Structure declaration of XVBAP
*-------------------->>> XVBAP
TYPES: BEGIN OF lty_xvbap3.        "Position
        INCLUDE STRUCTURE vbap.
TYPES:  matnr_output(40) TYPE c,        "Longer matnr ALRK165416
  wmeng(18) TYPE c,               "Wunschliefermenge
  lfdat LIKE vbap-abdat,          "Wunschlieferdatum
  kschl LIKE komv-kschl,          "Konditinsschlüssel
  kbtrg(16) TYPE c,               "Konditionsbetrag
  kschl_netwr LIKE komv-kschl,    "Konditinsschlüssel
  kbtrg_netwr(16) TYPE c,         "Konditionswert
  inco1 LIKE vbkd-inco1,          "Incoterms 1
  inco2 LIKE vbkd-inco2,          "Incoterms 2
  inco2_l LIKE vbkd-inco2_l,      "Incoterms 2_L
  inco3_l LIKE vbkd-inco3_l,     "Incoterms 3_L
  incov LIKE vbkd-incov,          "Incoterms v
  yantlf(1) TYPE c,               "Anzahl Teillieferungen
  prsdt LIKE vbkd-prsdt,          "Preisdatum
  hprsfd LIKE tvap-prsfd,         "Preisfindung durchführen
  bstkd_e LIKE vbkd-bstkd_e,      "Bestellnummer Warenempfänger
  bstdk_e LIKE vbkd-bstdk_e,      "Bestelldatum Warenempfänger
  bsark_e LIKE vbkd-bsark_e,      "Bestellart des Warenempfängers
  ihrez_e LIKE vbkd-ihrez_e,      "Zeichen des Warenempfängers
  posex_e LIKE vbkd-posex_e,      "Posnr. Bestellung
  lpnnr LIKE vbak-vbeln,          "Lieferplannummer
  empst LIKE vbkd-empst,          "Empfangsstelle
  ablad LIKE vbpa-ablad,          "Abladestelle
  knref LIKE vbpa-knref,          "Kundenindividuelle Bez.
  lpnnr_posnr LIKE vbap-posnr,    "Lieferplanpositionsnummer
  kdkg1 LIKE vbkd-kdkg1,          "Kunden Konditionsgruppe 1
  kdkg2 LIKE vbkd-kdkg2,          "Kunden Konditionsgruppe 2
  kdkg3 LIKE vbkd-kdkg3,          "Kunden Konditionsgruppe 3
  kdkg4 LIKE vbkd-kdkg4,          "Kunden Konditionsgruppe 4
  kdkg5 LIKE vbkd-kdkg5,          "Kunden Konditionsgruppe 5
  abtnr LIKE vbkd-abtnr,          "Abteilungsnummer
  delco LIKE vbkd-delco,          "vereinbarte Lieferzeit
  angbt LIKE vbak-vbeln,          "Angebotsnummer Lieferant (SAP)
  angbt_posnr LIKE vbap-posnr,    "Angebotspositionsnummer
  contk LIKE vbak-vbeln,          "Kontraknummer Lieferant (SAP)
  contk_posnr LIKE vbap-posnr,    "Kontrakpositionsnummer
  angbt_ref LIKE vbkd-bstkd,      "Angebotsnummer Kunde (SAP)
  angbt_posex LIKE vbap-posex,    "Angebotspositionsnummer
  contk_ref LIKE vbkd-bstkd,      "Kontraknummer Kunde  (SAP)
  contk_posex LIKE vbap-posex,    "Kontrakpositionsnummer
  config_id LIKE e1curef-config_id,
  inst_id LIKE e1curef-inst_id,
  kompp LIKE tvap-kompp,          "Liefergruppe bilden
  currdec LIKE tcurx-currdec,     "Dezimalstellen Währung
  curcy LIKE e1edp01-curcy,       "Währung
  valdt LIKE vbkd-valdt,          "Valuta-Fixdatum
  valtg LIKE vbkd-valtg,          "Valutatage
  vaddi(1) TYPE c,
 END OF lty_xvbap3.


*** Local Structure declaration for XVBADR
TYPES: BEGIN OF lty_xvbadr3,       "Partner
       posnr LIKE vbap-posnr,
       parvw LIKE vbpa-parvw,
       kunnr LIKE rv02p-kunde,
       ablad LIKE vbpa-ablad,
       knref LIKE knvp-knref.
        INCLUDE STRUCTURE vbadr.
TYPES: END OF lty_xvbadr3.

TYPES: BEGIN OF d_flag_k3,
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
       END OF d_flag_k3.
** Local Structure Declaration
DATA:
  lst_xvbak3 TYPE lty_xvbak3,
  lst_flag3   TYPE d_flag_k3,
  lst_xvbap3 TYPE lty_xvbap3.
** Local Structure Declaration for segments
DATA: lst_e1edk01_3        TYPE e1edk01, " IDoc: Document header general data
      lst_e1edk35_3        TYPE e1edk35, " IDoc: Document Header Additional Data
      lst_e1edp01_3        TYPE e1edp01,
      lst_z1qtc_e1edka1_01_3 TYPE z1qtc_e1edka1_01.
** Local Data Declaration
DATA:
      lv_partn3 TYPE bu_id_number,
      lv_jrnl3 TYPE ismidentcode,
      lv_tabix3 TYPE sytabix,
      lv_kunnr3 TYPE kunnr.

*** Local constant declaration
CONSTANTS: lc_ag3 TYPE parvw VALUE 'AG',
           lc_011 TYPE char3 VALUE '011',
           lc_jrnl3 TYPE ismidcodetype VALUE 'JRNL'.

*** Local field symbol declaration
FIELD-SYMBOLS: <lst_xvbadr_3> TYPE lty_xvbadr3.

CASE segment-segnam.
    WHEN 'Z1QTC_E1EDKA1_01'.

*** keeping the segment data in local work area
   lst_z1qtc_e1edka1_01_3 = segment-sdata.
   DESCRIBE TABLE dxvbadr LINES lv_tabix3.
*** Fetching partner information
   READ TABLE dxvbadr ASSIGNING <lst_xvbadr_3> INDEX lv_tabix3.

   IF <lst_xvbadr_3> IS ASSIGNED.
   lv_partn3 =  lst_z1qtc_e1edka1_01_3-partner.
   lst_xvbak3 = dxvbak.
*** Calling FM to convert Customer
CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_CUSTOMER'
  EXPORTING
    im_company_code          = lst_xvbak3-vkorg

    im_leg_customer          = lv_partn3

 IMPORTING
     ex_sap_customer         = lv_kunnr3

 EXCEPTIONS
   wrong_input_values       = 1
   invalid_comp_code        = 2
   OTHERS                   = 3
          .
IF sy-subrc = 0.
* Implement suitable error handling here
  <lst_xvbadr_3>-kunnr = lv_kunnr3.

 ELSE.
    <lst_xvbadr_3>-kunnr = lv_partn3.
ENDIF.
*** Checking the partner type and if it is 'AG' the
*** Inserting partner value in XVBAK structure
   IF <lst_xvbadr_3>-parvw = lc_ag3.
     lst_xvbak3 = dxvbak.
     lst_xvbak3-kunnr = <lst_xvbadr_3>-kunnr.
     dxvbak = lst_xvbak3.
   ENDIF."if <lst_XVBADR>-parvw = lc_ag.

   ENDIF."if <lst_XVBADR> IS ASSIGNED.




*** If the segment is E1EDP19 then we are fetching material from it
*** and converting it
  WHEN 'E1EDP19'.

*** Storing XVBAP in local work area
    lst_xvbap3 = dxvbap.
    lv_jrnl3   = lst_xvbap3-matnr.
***** Calling FM to convert legacy material into SAP Material
      CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
       EXPORTING
         im_idcodetype            = lc_jrnl3
         im_legacy_material       = lv_jrnl3
       IMPORTING
         ex_sap_material          = lst_xvbap3-matnr
       EXCEPTIONS
         wrong_input_values       = 1
         OTHERS                   = 2
                .
      IF sy-subrc = 0.
        dxvbap = lst_xvbap3.
      ENDIF.

  WHEN 'E1EDK01'.
    lst_e1edk01_3 = segment-sdata.
    IF lst_e1edk01_3-bsart IS NOT INITIAL." for BSART
      CLEAR: lst_xvbak3.
      lst_xvbak3 = dxvbak.
      lst_xvbak3-bsark = lst_e1edk01_3-bsart.
      dxvbak = lst_xvbak3.

      lst_flag3 = dd_flag_k.
      lst_flag3-kbes = abap_true.
      IF lst_e1edk01_3-lifsk IS NOT INITIAL. " for LIFSK
        lst_flag3-kde2 = abap_true.
      ENDIF.
      IF lst_e1edk01_3-augru IS NOT INITIAL. " for AUGRU
        lst_flag3-kkau = abap_true.
      ENDIF.
      dd_flag_k = lst_flag3.

    ENDIF. " IF lst_e1edk01-bsart IS NOT INITIAL

  WHEN 'E1EDP01'.
    lst_e1edp01_3 = segment-sdata.
    IF lst_e1edp01_3-lgort IS NOT INITIAL. " for LGORT
      CLEAR lst_xvbap3.
      lst_xvbap3 = dxvbap.
      lst_xvbap3-lgort = lst_e1edp01_3-lgort.
      dxvbap = lst_xvbap3.
    ENDIF.

  WHEN 'E1EDK35'.
    lst_e1edk35_3 = segment-sdata.
    IF lst_e1edk35_3-qualz = lc_011.
      CLEAR: lst_xvbak3.
      lst_xvbak3 = dxvbak.
      lst_xvbak3-faksk = lst_e1edk35_3-cusadd.  " for FAKSK
      dxvbak = lst_xvbak3.
    ENDIF. " IF lst_e1edk35-qualz = '011'
ENDCASE.
