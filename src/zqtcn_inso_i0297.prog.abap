*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INSO_I0297 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Entitlement Usage
* DEVELOPER: SAYANDAS ( Sayantan Das )
* CREATION DATE:   13/01/2017
* OBJECT ID: I0297
* TRANSPORT NUMBER(S):  ED2K904122
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907834
* REFERENCE NO: CR#632( ERP-3372)
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE:  2017-08-15
* DESCRIPTION: To convert the journal code populated in E1EDP19 to
*              SAP journal material.
*------------------------------------------------------------------- *
*** Local Structure declaration for XVBAK
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

*** Local Structure declaration of XVBAP
*-------------------->>> XVBAP
TYPES: BEGIN OF lty_xvbap7.        "Position
        INCLUDE STRUCTURE vbap.
TYPES:  matnr_output(40) TYPE c,        "Longer matnr ALRK165416
        wmeng(18)        TYPE c,               "Wunschliefermenge
        lfdat            LIKE vbap-abdat,          "Wunschlieferdatum
        kschl            LIKE komv-kschl,          "Konditinsschlüssel
        kbtrg(16)        TYPE c,               "Konditionsbetrag
        kschl_netwr      LIKE komv-kschl,    "Konditinsschlüssel
        kbtrg_netwr(16)  TYPE c,         "Konditionswert
        inco1            LIKE vbkd-inco1,          "Incoterms 1
        inco2            LIKE vbkd-inco2,          "Incoterms 2
        inco2_l          LIKE vbkd-inco2_l,      "Incoterms 2_L
        inco3_l          LIKE vbkd-inco3_l,     "Incoterms 3_L
        incov            LIKE vbkd-incov,          "Incoterms v
        yantlf(1)        TYPE c,               "Anzahl Teillieferungen
        prsdt            LIKE vbkd-prsdt,          "Preisdatum
        hprsfd           LIKE tvap-prsfd,         "Preisfindung durchführen
        bstkd_e          LIKE vbkd-bstkd_e,      "Bestellnummer Warenempfänger
        bstdk_e          LIKE vbkd-bstdk_e,      "Bestelldatum Warenempfänger
        bsark_e          LIKE vbkd-bsark_e,      "Bestellart des Warenempfängers
        ihrez_e          LIKE vbkd-ihrez_e,      "Zeichen des Warenempfängers
        posex_e          LIKE vbkd-posex_e,      "Posnr. Bestellung
        lpnnr            LIKE vbak-vbeln,          "Lieferplannummer
        empst            LIKE vbkd-empst,          "Empfangsstelle
        ablad            LIKE vbpa-ablad,          "Abladestelle
        knref            LIKE vbpa-knref,          "Kundenindividuelle Bez.
        lpnnr_posnr      LIKE vbap-posnr,    "Lieferplanpositionsnummer
        kdkg1            LIKE vbkd-kdkg1,          "Kunden Konditionsgruppe 1
        kdkg2            LIKE vbkd-kdkg2,          "Kunden Konditionsgruppe 2
        kdkg3            LIKE vbkd-kdkg3,          "Kunden Konditionsgruppe 3
        kdkg4            LIKE vbkd-kdkg4,          "Kunden Konditionsgruppe 4
        kdkg5            LIKE vbkd-kdkg5,          "Kunden Konditionsgruppe 5
        abtnr            LIKE vbkd-abtnr,          "Abteilungsnummer
        delco            LIKE vbkd-delco,          "vereinbarte Lieferzeit
        angbt            LIKE vbak-vbeln,          "Angebotsnummer Lieferant (SAP)
        angbt_posnr      LIKE vbap-posnr,    "Angebotspositionsnummer
        contk            LIKE vbak-vbeln,          "Kontraknummer Lieferant (SAP)
        contk_posnr      LIKE vbap-posnr,    "Kontrakpositionsnummer
        angbt_ref        LIKE vbkd-bstkd,      "Angebotsnummer Kunde (SAP)
        angbt_posex      LIKE vbap-posex,    "Angebotspositionsnummer
        contk_ref        LIKE vbkd-bstkd,      "Kontraknummer Kunde  (SAP)
        contk_posex      LIKE vbap-posex,    "Kontrakpositionsnummer
        config_id        LIKE e1curef-config_id,
        inst_id          LIKE e1curef-inst_id,
        kompp            LIKE tvap-kompp,          "Liefergruppe bilden
        currdec          LIKE tcurx-currdec,     "Dezimalstellen Währung
        curcy            LIKE e1edp01-curcy,       "Währung
        valdt            LIKE vbkd-valdt,          "Valuta-Fixdatum
        valtg            LIKE vbkd-valtg,          "Valutatage
        vaddi(1)         TYPE c,
        END OF lty_xvbap7.

*** Local Structure declaration for XVBADR
TYPES: BEGIN OF lty_xvbadr7,       "Partner
         posnr LIKE vbap-posnr,
         parvw LIKE vbpa-parvw,
         kunnr LIKE rv02p-kunde,
         ablad LIKE vbpa-ablad,
         knref LIKE knvp-knref.
        INCLUDE STRUCTURE vbadr.
TYPES: END OF lty_xvbadr7.

TYPES: BEGIN OF d_flag_k7,
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
       END OF d_flag_k7.
* BOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
TYPES: BEGIN OF lty_jrnlcd,
         identcode TYPE ismidentcode,
       END OF lty_jrnlcd.
* EOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834

** Local Structure Declaration
DATA:lst_xvbak7         TYPE lty_xvbak7,
     lst_flag7          TYPE d_flag_k7,
     lst_xvbap7         TYPE lty_xvbap7,
* BOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
     lst_jrnlcd         TYPE lty_jrnlcd,
     li_jrnlcd          TYPE TABLE OF lty_jrnlcd,
     li_mat_dtls_tmp    TYPE TABLE OF ty_mat_dtls_297 INITIAL SIZE 0,
     lst_mat_dtls_297   TYPE ty_mat_dtls_297,
     lst_extwg_dtls_297 TYPE ty_extwg_dtls_297,
     lst_idoc_data_297  TYPE edidd.
* EOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834

** Local Structure Declaration for segments
DATA: lst_e1edk01_7          TYPE e1edk01, " IDoc: Document header general data
* BOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
      lst_e1edp19_7          TYPE e1edp19,
* EOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
      lst_z1qtc_e1edka1_01_7 TYPE z1qtc_e1edka1_01.

*** Local Data Declaration
DATA: lv_partn7 TYPE bu_id_number,
      lv_zssn7  TYPE ismidentcode,
      lv_tabix7 TYPE sytabix,
      lv_kunnr7 TYPE kunnr.

*** Local constant declaration
CONSTANTS: lc_ag7              TYPE parvw VALUE 'AG',
*           lc_zssn7            TYPE ismidcodetype VALUE 'ZSSN',
           lc_z1qtc_e1edka1_01 TYPE edilsegtyp VALUE 'Z1QTC_E1EDKA1_01',
           lc_e1edp19          TYPE edilsegtyp VALUE 'E1EDP19',
           lc_e1edk01          TYPE edilsegtyp VALUE 'E1EDK01'.

*** Local field symbol declaration
FIELD-SYMBOLS: <lst_xvbadr_7>     TYPE lty_xvbadr7,
* BOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
               <fs_idoc_data_297> TYPE edidd_tt.
* EOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834

CASE segment-segnam.
  WHEN lc_z1qtc_e1edka1_01.
*** keeping the segment data in local work area
    lst_z1qtc_e1edka1_01_7 = segment-sdata.
    DESCRIBE TABLE dxvbadr LINES lv_tabix7.
*** Fetching partner information
    READ TABLE dxvbadr ASSIGNING <lst_xvbadr_7> INDEX lv_tabix7.
    IF <lst_xvbadr_7> IS ASSIGNED.
      lv_partn7 = lst_z1qtc_e1edka1_01_7-partner.
      lst_xvbak7 = dxvbak.
*** Calling FM to convert Customer
      CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_CUSTOMER'
        EXPORTING
          im_company_code    = lst_xvbak7-vkorg
          im_leg_customer    = lv_partn7
        IMPORTING
          ex_sap_customer    = lv_kunnr7
        EXCEPTIONS
          wrong_input_values = 1
          invalid_comp_code  = 2
          OTHERS             = 3.

      IF sy-subrc = 0 AND lv_kunnr7 IS NOT INITIAL.
* Implement suitable error handling here
        <lst_xvbadr_7>-kunnr = lv_kunnr7.
      ELSE.
        <lst_xvbadr_7>-kunnr = lv_partn7.
      ENDIF.
*** Checking the partner type and if it is 'AG' the
*** Inserting partner value in XVBAK structure
      IF <lst_xvbadr_7>-parvw = lc_ag7.
        lst_xvbak7 = dxvbak.
        lst_xvbak7-kunnr = <lst_xvbadr_7>-kunnr.
        dxvbak = lst_xvbak7.
      ENDIF.

    ENDIF.

*** If the segment is E1EDP19 then we are fetching material from it
*** and converting it
  WHEN lc_e1edp19.
* BOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
**** Storing XVBAP in local work area
*    lst_xvbap7 = dxvbap.
*    lv_zssn7   = lst_xvbap7-matnr.
****** Calling FM to convert legacy material into SAP Material
*    CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
*      EXPORTING
*        im_idcodetype      = lc_zssn7
*        im_legacy_material = lv_zssn7
*      IMPORTING
*        ex_sap_material    = lst_xvbap7-matnr
*      EXCEPTIONS
*        wrong_input_values = 1
*        OTHERS             = 2.
*
*    IF sy-subrc = 0.
*      dxvbap = lst_xvbap7.
*    ENDIF.
*        im_idcodetype      = c_idcodetyp_zjcd
    IF i_idoc_data_297 IS INITIAL.
      ASSIGN (c_fld_idoc_data) TO <fs_idoc_data_297>.
      IF <fs_idoc_data_297> IS ASSIGNED.
        i_idoc_data_297[] = <fs_idoc_data_297>.
      ENDIF.
      LOOP AT i_idoc_data_297 INTO lst_idoc_data_297
                              WHERE segnam = lc_e1edp19.
        lst_e1edp19_7 = lst_idoc_data_297-sdata.
        lst_jrnlcd-identcode = lst_e1edp19_7-idtnr.
        APPEND lst_jrnlcd TO li_jrnlcd.
      ENDLOOP.

      IF li_jrnlcd[] IS NOT INITIAL.
        SELECT j~matnr
               j~identcode
               m~mtart
               m~extwg
               m~ismmediatype
               INTO TABLE  i_mat_dtls_297
               FROM jptidcdassign AS j INNER JOIN mara AS m
               ON j~matnr = m~matnr
               FOR ALL ENTRIES IN li_jrnlcd
               WHERE m~mtart = c_mtart_zsbe AND
                     j~idcodetype   EQ c_idcodetyp_zjcd AND
                     j~identcode    EQ li_jrnlcd-identcode.
        IF sy-subrc EQ 0.
          li_mat_dtls_tmp[] = i_mat_dtls_297[].
          DELETE li_mat_dtls_tmp WHERE ismmediatype EQ c_medtyp_di.
          IF li_mat_dtls_tmp[] IS NOT INITIAL.
            SELECT matnr extwg
                   INTO TABLE i_extwg_dtls_297
                   FROM mara
                   FOR ALL ENTRIES IN li_mat_dtls_tmp
                   WHERE mtart = c_mtart_zsbe AND
                         extwg = li_mat_dtls_tmp-extwg AND
                         ismmediatype = c_medtyp_di.
            IF sy-subrc EQ 0.
              SORT i_extwg_dtls_297 BY extwg.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    lst_xvbap7 = dxvbap.
    READ TABLE i_mat_dtls_297 INTO lst_mat_dtls_297 WITH KEY identcode = lst_xvbap7-matnr
                                                             ismmediatype = c_medtyp_di.
    IF sy-subrc EQ 0.
      lst_xvbap7-matnr = lst_mat_dtls_297-matnr.
    ELSE.
      READ TABLE i_mat_dtls_297 INTO lst_mat_dtls_297 WITH KEY identcode = lst_xvbap7-matnr.
      IF sy-subrc EQ 0.
        READ TABLE i_extwg_dtls_297 INTO lst_extwg_dtls_297
                                    WITH KEY extwg = lst_mat_dtls_297-extwg.
        IF sy-subrc EQ 0.
          lst_xvbap7-matnr = lst_extwg_dtls_297-matnr.
        ENDIF.
      ENDIF.
    ENDIF.
    dxvbap = lst_xvbap7.
* EOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834

  WHEN lc_e1edk01.
    lst_e1edk01_7 = segment-sdata.
    IF lst_e1edk01_7-bsart IS NOT INITIAL. " for BSART
      CLEAR: lst_xvbak7.
      lst_xvbak7 = dxvbak.
      lst_xvbak7-bsark = lst_e1edk01_7-bsart.
      dxvbak = lst_xvbak7.

      lst_flag7 = dd_flag_k.
      lst_flag7-kbes = abap_true.
      dd_flag_k = lst_flag7.
    ENDIF.
ENDCASE.
