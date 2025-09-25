*-------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_INBOUND_I0219
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

*** Local Structure declaration for XVBAK
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

TYPES: BEGIN OF d_flag_k,
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
       END OF d_flag_k.

DATA:
  lst_xvbak1 TYPE lty_xvbak1,
  lst_flag   TYPE d_flag_k.

DATA: lst_e1edk01 TYPE e1edk01, " IDoc: Document header general data
      lst_e1edk35 TYPE e1edk35. " IDoc: Document Header Additional Data

*Populating the document type and billing block in the structure
CASE segment-segnam.
  WHEN 'E1EDK01'.
    lst_e1edk01 = segment-sdata.
    IF lst_e1edk01-bsart IS NOT INITIAL.
      CLEAR: lst_xvbak1.
      lst_xvbak1 = dxvbak.
      lst_xvbak1-bsark = lst_e1edk01-bsart.
      dxvbak = lst_xvbak1.

      lst_flag = dd_flag_k.
      lst_flag-kbes = abap_true.
      dd_flag_k = lst_flag.

    ENDIF. " IF lst_e1edk01-bsart IS NOT INITIAL

  WHEN 'E1EDK35'.
    lst_e1edk35 = segment-sdata.
    IF lst_e1edk35-qualz = '011'.
      CLEAR: lst_xvbak1.
      lst_xvbak1 = dxvbak.
      lst_xvbak1-faksk = lst_e1edk35-cusadd.
      dxvbak = lst_xvbak1.
    ENDIF. " IF lst_e1edk35-qualz = '011'
ENDCASE.
