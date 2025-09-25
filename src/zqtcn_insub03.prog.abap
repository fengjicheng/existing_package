*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for customer population
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   19/08/2016
* OBJECT ID: I0230
* TRANSPORT NUMBER(S): ED2K902770
*----------------------------------------------------------------------*
* REVISION NO: ED2K918929 ---------------------------------------------*
* REFERENCE NO: ERPM-1392 (I0230)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 17-JULY-2020
* DESCRIPTION: " Process for Payment card manual Authorization
* If Auth. Number is passed then Auth. Amount, Auth. Order ID
* field values are passed mandatorly
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INSUB03
*&---------------------------------------------------------------------*

*** Local Structure declaration for XVBADR
TYPES: BEGIN OF lty_xvbadr ,       "Partner
         posnr LIKE vbap-posnr,      "Sales Document Item
         parvw LIKE vbpa-parvw,      "Partner Function
         kunnr LIKE rv02p-kunde,     "Partner number (KUNNR, LIFNR, or PERNR)
         ablad LIKE vbpa-ablad,      "Unloading Point
         knref LIKE knvp-knref.      "Customer description of partner (plant, storage location)
         INCLUDE STRUCTURE vbadr.
       TYPES: END OF lty_xvbadr.

*** Local Structure declaration for XVBAK
TYPES: BEGIN OF lty_xvbak.                  "Kopfdaten
         INCLUDE STRUCTURE vbak.
         TYPES:  bstkd LIKE vbkd-bstkd.

TYPES:  kursk LIKE vbkd-kursk.          "Währungskurs
TYPES:  zterm LIKE vbkd-zterm.          "Zahlungsbedingungsschlüssel
TYPES:  incov LIKE vbkd-incov.          "Incoterms Teil Version
TYPES:  inco1 LIKE vbkd-inco1.          "Incoterms Teil 1
TYPES:  inco2 LIKE vbkd-inco2.          "Incoterms Teil 2
TYPES:  inco2_l LIKE vbkd-inco2_l.      "Incoterms Teil 2_L
TYPES:  inco3_l LIKE vbkd-inco3_l.      "Incoterms Teil 3_L
TYPES:  prsdt LIKE vbkd-prsdt.          "Datum für Preisfindung
TYPES:  angbt LIKE vbak-vbeln.          "Angebotsnummer Lieferant (SAP)
TYPES:  contk LIKE vbak-vbeln.          "Kontraknummer Lieferant (SAP)
TYPES:  kzazu LIKE vbkd-kzazu.          "Kz. Auftragszusammenführung
TYPES:  fkdat LIKE vbkd-fkdat.          "Datum Faktura-/Rechnungsindex
TYPES:  fbuda LIKE vbkd-fbuda.          "Datum der Leistungserstellung
TYPES:  empst LIKE vbkd-empst.          "Empfangsstelle
TYPES:  valdt LIKE vbkd-valdt.          "Valuta-Fix Datum
TYPES:  kdkg1 LIKE vbkd-kdkg1.          "Kunden Konditionsgruppe 1
TYPES:  kdkg2 LIKE vbkd-kdkg2.          "Kunden Konditionsgruppe 2
TYPES:  kdkg3 LIKE vbkd-kdkg3.          "Kunden Konditionsgruppe 3
TYPES:  kdkg4 LIKE vbkd-kdkg4.          "Kunden Konditionsgruppe 4
TYPES:  kdkg5 LIKE vbkd-kdkg5.          "Kunden Konditionsgruppe 5
TYPES:  delco LIKE vbkd-delco.          "vereinbarte Lieferzeit
TYPES:  abtnr LIKE vbkd-abtnr.          "Abteilungsnummmer
TYPES:  dwerk LIKE rv45a-dwerk.         "disponierendes Werk
TYPES:  angbt_ref LIKE vbkd-bstkd.      "Angebotsnummer Kunde (SAP)
TYPES:  contk_ref LIKE vbkd-bstkd.      "Kontraknummer Kunde  (SAP)
TYPES:  currdec LIKE tcurx-currdec.     "Dezimalstellen Währung
TYPES:  bstkd_e LIKE vbkd-bstkd_e.      "Bestellnummer Warenempfänger
TYPES:  bstdk_e LIKE vbkd-bstdk_e.      "Bestelldatum Warenempfänger
TYPES: END OF lty_xvbak.


*** Local Structure declaration of XVBAP
*-------------------->>> XVBAP
TYPES: BEGIN OF lty_xvbap.        "Position
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
       END OF lty_xvbap.

TYPES: BEGIN OF d_flag_k1,
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
       END OF d_flag_k1.

* <<<---------------------
*** Local work area declaration
DATA:
  lst_xvbak            TYPE lty_xvbak,
  lst_xvbap            TYPE lty_xvbap,
  lst_flag1            TYPE d_flag_k1,
  lst_e1edk01_sub      TYPE e1edk01,
  lst_e1edp19_sub      TYPE e1edp19,
* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K906186
  lv_vbtyp_230         TYPE vbtyp,                " Document Category Type
  lv_ordtyp_230        TYPE auart,                " Order Type
  r_zca_vbtyp_230      TYPE efg_tab_ranges,       " Range for Doc. category
  lst_e1edk14_sub      TYPE e1edk14,
  li_zcaconst_230      TYPE zcat_constants,
  lst_zcaconst_230     TYPE zcast_constant,
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K906186
  lst_z1qtc_e1edka1_01 TYPE z1qtc_e1edka1_01,
*-- BOC: ERPM 1392 GKAMMILI 05-Feb-20202  ED2K917394
  lv_memid_i0230       TYPE char30,             " Memory ID Name
  lst_zlqtc_ze1edk01   TYPE z1qtc_e1edk01_01.
*-- EOC: ERPM 1392 GKAMMILI 05-Feb-20202  ED2K917394

*** Local field symbol declaration
FIELD-SYMBOLS: <lst_xvbadr> TYPE lty_xvbadr.

*** BOC: ERPM-1392 KKRAVURI 28-JULY-2020  ED2K919007
STATICS:
   ls_docnum       TYPE edi_docnum.
*** EOC: ERPM-1392 KKRAVURI 28-JULY-2020  ED2K919007

*** Local Data declaration
DATA: lv_tabix  TYPE sytabix,
      lv_partn1 TYPE bu_id_number,
      lv_jrnl   TYPE ismidentcode,
      lv_kunnr1 TYPE kunnr.


*** Local constant declaration
CONSTANTS: lc_ag          TYPE parvw VALUE 'AG',
           lc_jrnl1       TYPE ismidcodetype VALUE 'JRNL',
           lc_doc_cat_qty TYPE rvari_vnam VALUE 'DOC_CAT_QTY'.

*** If Partner type is Sold-to-party then we are putting the
*** partner number in Customer field of XVBAK structure
CASE segment-segnam.
  WHEN 'Z1QTC_E1EDKA1_01'.
*** keeping the segment data in local work area
    lst_z1qtc_e1edka1_01 = segment-sdata.
    DESCRIBE TABLE dxvbadr LINES lv_tabix.
*** Fetching partner information
    READ TABLE dxvbadr ASSIGNING <lst_xvbadr> INDEX lv_tabix.

*   Begin of ADD:ERP-3993:WROY:18-AUG-2017:ED2K907888
*   IF <lst_xvbadr> IS ASSIGNED.
    IF <lst_xvbadr> IS ASSIGNED AND
       lst_z1qtc_e1edka1_01-partner IS NOT INITIAL.
*   End   of ADD:ERP-3993:WROY:18-AUG-2017:ED2K907888

      lv_partn1 = lst_z1qtc_e1edka1_01-partner.
      lst_xvbak = dxvbak.
*** Calling FM to convert Customer
      CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_CUSTOMER'
        EXPORTING
          im_company_code    = lst_xvbak-vkorg
          im_leg_customer    = lv_partn1
        IMPORTING
          ex_sap_customer    = lv_kunnr1
        EXCEPTIONS
          wrong_input_values = 1
          invalid_comp_code  = 2
          OTHERS             = 3.
*      IF sy-subrc = 0 AND lv_kunnr1 IS NOT INITIAL.
      IF sy-subrc = 0.
* Implement suitable error handling here
        <lst_xvbadr>-kunnr = lv_kunnr1.

*     ELSE.
**   <lst_xvbadr>-kunnr = lv_partn1.
**** Calling Conversion Exit
*       CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*         EXPORTING
*           input  = lv_partn1
*         IMPORTING
*           output = lv_kunnr1.
*
*       <lst_xvbadr>-kunnr = lv_kunnr1.

      ENDIF.
*** Checking the partner type and if it is 'AG' the
*** Inserting partner value in XVBAK structure
      IF <lst_xvbadr>-parvw = lc_ag.
        lst_xvbak = dxvbak.
        lst_xvbak-kunnr = <lst_xvbadr>-kunnr.
        dxvbak = lst_xvbak.
      ENDIF."if <lst_XVBADR>-parvw = lc_ag.

    ENDIF."if <lst_XVBADR> IS ASSIGNED.

*** If the segment is E1EDP19 then we are fetching material from it
*** and converting it
  WHEN 'E1EDP19'.

*** Storing XVBAP in local work area
    lst_xvbap = dxvbap.
    lv_jrnl   = lst_xvbap-matnr.
    IF lv_jrnl IS INITIAL.
      lst_e1edp19_sub = segment-sdata.
      lv_jrnl = lst_e1edp19_sub-idtnr.
    ENDIF.
***** Calling FM to convert legacy material into SAP Material
    CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
      EXPORTING
        im_idcodetype      = lc_jrnl1
        im_legacy_material = lv_jrnl
      IMPORTING
        ex_sap_material    = lst_xvbap-matnr
      EXCEPTIONS
        wrong_input_values = 1
        OTHERS             = 2.
    IF sy-subrc = 0.
      dxvbap = lst_xvbap.
    ENDIF.

  WHEN 'E1EDK01'.
    lst_e1edk01_sub = segment-sdata.
    IF lst_e1edk01_sub-bsart IS NOT INITIAL.
      CLEAR: lst_xvbak.
      lst_xvbak = dxvbak.
      lst_xvbak-bsark = lst_e1edk01_sub-bsart.
      dxvbak = lst_xvbak.

      lst_flag1 = dd_flag_k.
      lst_flag1-kbes = abap_true.
      dd_flag_k = lst_flag1.

    ENDIF. " IF lst_e1edk01-bsart IS NOT INITIAL

* BOC: 10-Aug-2017 : PBANDLAPAL : ED2K906186
  WHEN 'E1EDK14'.
    lst_e1edk14_sub = segment-sdata.
    IF lst_e1edk14_sub-qualf =  c_qualf_012.    " Qualifier 012 for Order Type.
      lv_ordtyp_230  = lst_e1edk14_sub-orgid.

      CALL FUNCTION 'ZQTC_GET_ZCACONSTANT_ENT'
        EXPORTING
          im_devid         = c_devid_i0230
        IMPORTING
          ex_t_zcacons_ent = li_zcaconst_230.

      LOOP AT li_zcaconst_230 INTO lst_zcaconst_230 WHERE param1 EQ lc_doc_cat_qty.
        APPEND INITIAL LINE TO r_zca_vbtyp_230 ASSIGNING FIELD-SYMBOL(<fst_zca_vbtyp_230>).
        <fst_zca_vbtyp_230>-sign   = lst_zcaconst_230-sign.
        <fst_zca_vbtyp_230>-option = lst_zcaconst_230-opti.
        <fst_zca_vbtyp_230>-low    = lst_zcaconst_230-low.
        <fst_zca_vbtyp_230>-high   = lst_zcaconst_230-high.
      ENDLOOP.

      SELECT SINGLE vbtyp INTO lv_vbtyp_230
             FROM tvak
             WHERE auart = lv_ordtyp_230.
      IF sy-subrc EQ 0.
        IF lv_vbtyp_230 IN r_zca_vbtyp_230.
          v_vbtyp_flg_230 = abap_true.
        ENDIF.
      ENDIF.
    ENDIF.       " IF lst_e1edk14_sub-qualf =  c_qualf_012.
* EOC: 10-Aug-2017 : PBANDLAPAL : ED2K906186
*** BOC: ERPM-1392 KKRAVURI 17-JULY-2020  ED2K918929
  WHEN 'Z1QTC_E1EDK01_01'.
    " Get the Segment data into local variable for
    " further processing
    lst_zlqtc_ze1edk01 = segment-sdata.

    " Payment card Authorization fields input validation
    IF lst_zlqtc_ze1edk01-aunum IS NOT INITIAL.
      " Check Auth. amount field value is Initial
      IF lst_zlqtc_ze1edk01-autwr IS INITIAL.
        MESSAGE e345(zqtc_r2) RAISING user_error.
      ENDIF.
      " Check Auth. Order ID field value is Initial
      IF lst_zlqtc_ze1edk01-auth_order_id IS INITIAL.
        MESSAGE e349(zqtc_r2) RAISING user_error.
      ENDIF.
      IF ls_docnum <> segment-docnum.
        IF ls_docnum IS NOT INITIAL.
          lv_memid_i0230 = |{ ls_docnum }_ZOID|.
          " Free Memory ID of Previous Idoc in Batch Execution
          FREE MEMORY ID lv_memid_i0230.
        ENDIF.
        ls_docnum = segment-docnum.
      ENDIF.
      lv_memid_i0230 = |{ segment-docnum }_ZOID|.
      EXPORT lv_auth_order_id FROM lst_zlqtc_ze1edk01-auth_order_id
             TO MEMORY ID lv_memid_i0230.
    ENDIF.
*** EOC: ERPM-1392 KKRAVURI 17-JULY-2020  ED2K918929

  WHEN OTHERS.
    " Nothing to do
ENDCASE.
