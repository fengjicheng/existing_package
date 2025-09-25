*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INSUB_I0343
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INSUB_I0343 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Inbound Subscription Order
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   18/03/2017
* OBJECT ID: I0343
* TRANSPORT NUMBER(S): ED2K904999
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910335
* REFERENCE NO: ERP-5975
* DEVELOPER: Writtick Roy
* DATE:  17-Jan-2018
* DESCRIPTION: For Renewals, populate Customer Details from Reference
*              Quotation
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K913969
* REFERENCE NO: CR#7463
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 19-Feb-2019
* DESCRIPTION: Update Relationship category (Student Membership) at
* BP(Ship-to) Relationships if it is sent via Inbound Renewal
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915227
* REFERENCE NO: DM-1901 E106
* DEVELOPER:Murali(MIMMADISET)
* DATE: 2019-06-07
* DESCRIPTION:DM-1901 Price Group in WOL Orders can not be overridden from customer default
*----------------------------------------------------------------------
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
*** Local Structure declaration for XVBAK
TYPES: BEGIN OF lty_xvbak11. "Kopfdaten
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
TYPES: END OF lty_xvbak11.

*** Local Structure declaration of XVBAP
*-------------------->>> XVBAP
TYPES: BEGIN OF lty_xvbap11. "Position
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
        END OF lty_xvbap11.

*** Local Structure declaration for XVBADR
TYPES: BEGIN OF lty_xvbadr11,    "Partner
         posnr LIKE vbap-posnr,  " Sales Document Item
         parvw LIKE vbpa-parvw,  " Partner Function
         kunnr LIKE rv02p-kunde, " Partner number (KUNNR, LIFNR, or PERNR)
         ablad LIKE vbpa-ablad,  " Unloading Point
         knref LIKE knvp-knref.  " Customer description of partner (plant, storage location)
        INCLUDE STRUCTURE vbadr. " Address work area
TYPES: END OF lty_xvbadr11.

***** Local Types Declaration for DD_FLAG
TYPES: BEGIN OF d_flag_k18,
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
       END OF d_flag_k18,
*** BOC: CR#7463  KKRAVURI20190219  ED2K913969
       BEGIN OF ty_reltyp,
         partner1 TYPE bu_partner,
         reltyp   TYPE bu_reltyp,
         credat   TYPE dats,
       END OF ty_reltyp.
*** EOC: CR#7463  KKRAVURI20190219  ED2K913969
* Begin of ADD:ERP-5975:WROY:17-Jan-2018:ED2K910335
DATA:
  li_vbpa_i0343 TYPE tab_vbpa,
  lst_e1edka1   TYPE e1edka1,
  lst_e1edk02   TYPE e1edk02.

STATICS:
  li_const_i0343    TYPE zcat_constants,
  lr_doc_type_i0343 TYPE farric_rt_auart,
*** BOC: CR#7463  KKRAVURI20190314  ED2K914698
  lst_reltyp        TYPE ty_reltyp.  " Structure: ty_reltyp
*** BOC: CR#7463  KKRAVURI20190314  ED2K914698
* End   of ADD:ERP-5975:WROY:17-Jan-2018:ED2K910335

** Local Structure Declaration
DATA: lst_xvbak11    TYPE lty_xvbak11,
      lst_xvbap11    TYPE lty_xvbap11,
      lst_flag_18    TYPE d_flag_k18,
*    Begin of ADD:ERP-5975:WROY:17-Jan-2018:ED2K910335
      lst_e1edka1_11 TYPE e1edka1, " IDoc: Document Header Partner Information
      lst_e1edka1_we TYPE e1edka1, " IDoc: Document Header Partner Information
      lst_e1edk02_11 TYPE e1edk02, " IDoc: Document header reference data
*    End   of ADD:ERP-5975:WROY:17-Jan-2018:ED2K910335
      lst_e1edk01_11 TYPE e1edk01. " IDoc: Document header general data.

** Local Structure Declaration for segments
DATA: lst_z1qtc_e1edka1_01_11 TYPE z1qtc_e1edka1_01, " Partner Information (Legacy Customer Number)
*** BOC: CR#7463  KKRAVURI20190219  ED2K913969
      lst_z1qtc_e1edp01_01    TYPE z1qtc_e1edp01_01,
      lv_pric_yr              TYPE numc4,
      lv_reltyp               TYPE bu_reltyp,  " Relation category
      lst_edidd               TYPE edidd,
      lv_mem_name             TYPE char30.      " Memory ID Name

*** EOC: CR#7463  KKRAVURI20190219  ED2K913969

*** Local Data Declaration
DATA: lv_partn11        TYPE bu_id_number, " Identification Number
      lv_zssn11         TYPE ismidentcode, " Identification Code
      lv_tabix11        TYPE sytabix,      " Row Index of Internal Tables
*     Begin of ADD:ERP-5975:WROY:17-Jan-2018:ED2K910335
      lv_quote          TYPE vbeln_va,     " Quotation
*     End   of ADD:ERP-5975:WROY:17-Jan-2018:ED2K910335
      lv_kunnr11        TYPE kunnr,        " Customer Number
*       Begin of CHANGE:CR#DM-1901:MIMMADISET:07-June-2019:ED2K915227
      lv_actv_flag_e106 TYPE zactive_flag. " Active / Inactive Flag
* End of CHANGE:CR#DM-1901:MIMMADISET:07-June-2019:ED2K915227
*** Local constant declaration
CONSTANTS: lc_ag11                TYPE parvw VALUE 'AG',                    " Partner Function
           lc_we_11               TYPE parvw VALUE 'WE',                    " Partner Function
           lc_zssn11              TYPE ismidcodetype VALUE 'ZSSN',          " Type of Identification Code
*          Begin of ADD:ERP-5975:WROY:17-Jan-2018:ED2K910335
           lc_document_type       TYPE rvari_vnam VALUE 'DOCUMENT_TYPE',    " Parameter: Document Type
           lc_renewal_subs        TYPE rvari_vnam VALUE 'RENEWAL_SUBS',     " Parameter: Renewal Subscription
           lc_devid_i0343         TYPE zdevid     VALUE 'I0343',            " Development ID: I0343
           lc_qualf_004_11        TYPE edi_qualfr VALUE '004',              " IDOC qualifier: 004
           lc_posnr_low_i0343     TYPE posnr_va   VALUE '000000',           " SD Document Item Number (Header)
           lc_idoc_i0343          TYPE char30     VALUE '(SAPLVEDA)IDOC_DATA[]',
           lc_e1edka1_11          TYPE edilsegtyp VALUE 'E1EDKA1',
           lc_e1edk02_11          TYPE edilsegtyp VALUE 'E1EDK02',
*          End   of ADD:ERP-5975:WROY:17-Jan-2018:ED2K910335
           lc_z1qtc_e1edka1_01_11 TYPE edilsegtyp VALUE 'Z1QTC_E1EDKA1_01', " Segment type
           lc_e1edk01_11          TYPE edilsegtyp VALUE 'E1EDK01',
           lc_e1edp19_11          TYPE edilsegtyp VALUE 'E1EDP19',          " Segment type
*** BOC: CR#7463  KKRAVURI20190314  ED2K914698
           lc_z1qtc_e1edp01_01    TYPE edilsegtyp VALUE 'Z1QTC_E1EDP01_01', " Segment type
           lc_0101                TYPE char4      VALUE '0101',
           lc_e1edp01             TYPE edilsegtyp VALUE 'E1EDP01',
*** BOC: CR#7463  KKRAVURI20190314  ED2K914698
* Begin of CHANGE:CR#DM-1901:MIMMADISET:07-June-2019:ED2K915227
           lc_ser_num_1_e106      TYPE zsno       VALUE '004',  " Serial Number
           lc_wricef_id_e106      TYPE zdevid     VALUE 'E106'.    " Object id
* End   of CHANGE:CR#DM-1901:MIMMADISET:07-June-2019:ED2K915227
*** Local field symbol declaration
FIELD-SYMBOLS: <lst_xvbadr_11>     TYPE lty_xvbadr10,
* Begin of ADD:ERP-5975:WROY:17-Jan-2018:ED2K910335
               <li_idoc_rec_i0343> TYPE edidd_tt.
* End   of ADD:ERP-5975:WROY:17-Jan-2018:ED2K910335

IF li_const_i0343 IS INITIAL.
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_i0343
    IMPORTING
      ex_constants = li_const_i0343.
  LOOP AT li_const_i0343 ASSIGNING FIELD-SYMBOL(<lst_const_i0343>).
    CASE <lst_const_i0343>-param1.
      WHEN lc_document_type.
        CASE <lst_const_i0343>-param2.
          WHEN lc_renewal_subs.
            APPEND INITIAL LINE TO lr_doc_type_i0343 ASSIGNING FIELD-SYMBOL(<lst_doc_type_i0343>).
            <lst_doc_type_i0343>-sign   = <lst_const_i0343>-sign.
            <lst_doc_type_i0343>-option = <lst_const_i0343>-opti.
            <lst_doc_type_i0343>-low    = <lst_const_i0343>-low.
            <lst_doc_type_i0343>-high   = <lst_const_i0343>-high.
          WHEN OTHERS.
*           Nothing to do
        ENDCASE.
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF.

CASE segment-segnam.
  WHEN lc_z1qtc_e1edka1_01_11. " Segment for legacy customer
*** keeping the segment data in local work area
    lst_z1qtc_e1edka1_01_11 = segment-sdata.
    DESCRIBE TABLE dxvbadr LINES lv_tabix11.
*** Fetching partner information
    READ TABLE dxvbadr ASSIGNING <lst_xvbadr_11> INDEX lv_tabix11.
    IF <lst_xvbadr_11> IS ASSIGNED.
      lv_partn11 = lst_z1qtc_e1edka1_01_11-partner.
      lst_xvbak11 = dxvbak.
*** Calling FM to convert Customer
      CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_CUSTOMER'
        EXPORTING
          im_company_code    = lst_xvbak11-vkorg
          im_leg_customer    = lv_partn11
        IMPORTING
          ex_sap_customer    = lv_kunnr11
        EXCEPTIONS
          wrong_input_values = 1
          invalid_comp_code  = 2
          OTHERS             = 3.
      IF sy-subrc = 0 AND lv_kunnr11 IS NOT INITIAL.
        <lst_xvbadr_11>-kunnr = lv_kunnr11.
      ELSE. " ELSE -> IF sy-subrc = 0 AND lv_kunnr10 IS NOT INITIAL
        <lst_xvbadr_11>-kunnr = lv_partn11.
      ENDIF. " IF sy-subrc = 0 AND lv_kunnr10 IS NOT INITIAL
*** Checking the partner type and if it is 'AG' the
*** Inserting partner value in XVBAK structure
      IF <lst_xvbadr_11>-parvw = lc_ag11.
        lst_xvbak11 = dxvbak.
        lst_xvbak11-kunnr = <lst_xvbadr_11>-kunnr.
        dxvbak = lst_xvbak11.
      ENDIF. " IF <lst_xvbadr_10>-parvw = lc_ag10
    ENDIF. " IF <lst_xvbadr_10> IS ASSIGNED

*** If the segment is E1EDP19 then we are fetching material from it
*** and converting it
  WHEN lc_e1edp19_11.
*** Storing XVBAP in local work area
    lst_xvbap11 = dxvbap.
    lv_zssn11   = lst_xvbap11-matnr.
***** Calling FM to convert legacy material into SAP Material
    CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
      EXPORTING
        im_idcodetype      = lc_zssn11
        im_legacy_material = lv_zssn11
      IMPORTING
        ex_sap_material    = lst_xvbap11-matnr
      EXCEPTIONS
        wrong_input_values = 1
        OTHERS             = 2.
    IF sy-subrc = 0.
      dxvbap = lst_xvbap11.
    ENDIF. " IF sy-subrc = 0

  WHEN lc_e1edk01_11.
    lst_e1edk01_11 = segment-sdata.
    IF lst_e1edk01_11-bsart IS NOT INITIAL.
      CLEAR: lst_xvbak11.
      lst_xvbak11 = dxvbak.
      lst_xvbak11-bsark = lst_e1edk01_11-bsart.
      dxvbak = lst_xvbak11.

      lst_flag_18 = dd_flag_k.
      lst_flag_18-kbes = abap_true.
      dd_flag_k = lst_flag_18.
    ENDIF.
*** BOC: CR#7463  KKRAVURI20190314  ED2K914698
  WHEN lc_e1edp01.
    IF <li_idoc_rec_i0343> IS ASSIGNED.
      UNASSIGN <li_idoc_rec_i0343>.
    ENDIF.
    ASSIGN (lc_idoc_i0343) TO <li_idoc_rec_i0343>.
    IF sy-subrc = 0 AND <li_idoc_rec_i0343> IS ASSIGNED.
      READ TABLE <li_idoc_rec_i0343> INTO lst_edidd WITH KEY
                                     segnam = lc_z1qtc_e1edp01_01
                                     psgnum = segment-segnum.     " psgnum --> parentsegment number
      IF sy-subrc = 0.
        lst_z1qtc_e1edp01_01 = lst_edidd-sdata.
        lv_pric_yr = lst_z1qtc_e1edp01_01-zzpricing_year.
        IF lv_pric_yr IS NOT INITIAL.
          CONCATENATE lv_pric_yr lc_0101 INTO DATA(lv_creatdt).
          lst_reltyp-credat = lv_creatdt.
        ENDIF.
        CONCATENATE segment-docnum '_REL_TYPE' INTO lv_mem_name.
        EXPORT lst_reltyp TO MEMORY ID lv_mem_name.
        CLEAR: lst_edidd, lst_reltyp.
      ENDIF.
      UNASSIGN <li_idoc_rec_i0343>.
    ENDIF.
*** EOC: CR#7463  KKRAVURI20190314  ED2K914698
* Begin of ADD:ERP-5975:WROY:17-Jan-2018:ED2K910335
  WHEN lc_e1edka1_11.
    lst_e1edka1_11 = segment-sdata.                        " IDoc: Document Header Partner Information
    lst_xvbak11    = dxvbak.                               " Sales Document: Header Data

*** BOC: CR#7463  KKRAVURI20190219  ED2K913969
    IF lst_e1edka1_11-parvw = lc_we_11.
      ASSIGN (lc_idoc_i0343) TO <li_idoc_rec_i0343>.
      IF sy-subrc = 0 AND <li_idoc_rec_i0343> IS ASSIGNED.
        READ TABLE <li_idoc_rec_i0343> INTO lst_edidd WITH KEY
                                       segnam = lc_z1qtc_e1edka1_01_11
                                       psgnum = segment-segnum.     " psgnum --> parentsegment number
        IF sy-subrc = 0.
          lst_z1qtc_e1edka1_01_11 = lst_edidd-sdata.
          lv_reltyp = lst_z1qtc_e1edka1_01_11-reltyp.
          IF lv_reltyp IS NOT INITIAL.
            lst_reltyp-partner1 = lst_e1edka1_11-partn.
            lst_reltyp-reltyp = lv_reltyp.
*            lst_reltyp-credat = contrl-credat.
* Begin of CHANGE:CR#DM-1901:MIMMADISET:24-June-2019:ED2K915227
            CALL FUNCTION 'ZCA_ENH_CONTROL'
              EXPORTING
                im_wricef_id   = lc_wricef_id_e106
                im_ser_num     = lc_ser_num_1_e106
              IMPORTING
                ex_active_flag = lv_actv_flag_e106.

            IF lv_actv_flag_e106 EQ abap_true.
              INCLUDE zqtcn_insub_e106_004 IF FOUND.
* End of CHANGE:CR#DM-1901:MIMMADISET:24-June-2019:ED2K915227
            ENDIF."lv_actv_flag_e106 EQ abap_true.
            CLEAR: lst_z1qtc_e1edka1_01_11, lst_edidd.
          ENDIF.
        ENDIF.
        UNASSIGN <li_idoc_rec_i0343>.
      ENDIF. " IF sy-subrc = 0 AND <li_idoc_rec_i0343> IS ASSIGNED.
    ENDIF. " IF lst_e1edka1_11-parvw = lc_we_11.
*** EOC: CR#7463  KKRAVURI20190219  ED2K913969

**-Begin of Add : ERP-7318 : PRABHU : 11-Feb-2019 ED2K913969
    CLEAR : v_quote.
*--* Check document type
    IF lst_xvbak11-auart IN lr_doc_type_i0343.
*   Read Ship-to segment data to get your reference number
      ASSIGN (lc_idoc_i0343) TO <li_idoc_rec_i0343>.
      READ TABLE <li_idoc_rec_i0343> ASSIGNING FIELD-SYMBOL(<lst_idoc11>) WITH KEY segnam     = lc_e1edka1_11
                                                                                   sdata+0(2) = lc_we_11.
      IF sy-subrc EQ 0.
        lst_e1edka1_we = <lst_idoc11>-sdata.
*--*Call FM to get right quote number
        CALL FUNCTION 'ZQTC_FIND_QUOTE_I0343'
          EXPORTING
            im_ihrez = lst_e1edka1_we-ihrez
          IMPORTING
            ex_quote = v_quote.
      ENDIF. " IF sy-subrc eq 0
*--*Customer is not initial scenario
      IF lst_e1edka1_11-partn IS NOT INITIAL AND v_quote IS NOT INITIAL.
*     Read ABAP Stack to get details of IDOC Data
        ASSIGN (lc_idoc_i0343) TO <li_idoc_rec_i0343>.
*     Get IDoc: Document header reference data
        READ TABLE <li_idoc_rec_i0343> ASSIGNING FIELD-SYMBOL(<lst_idoc_rec_i0343_cust>)
             WITH KEY segnam   = lc_e1edk02_11
                      sdata(3) = lc_qualf_004_11.
        IF sy-subrc EQ 0.
          lst_e1edk02_11 = <lst_idoc_rec_i0343_cust>-sdata.       " IDoc: Document header reference data
          lst_e1edk02_11-belnr = v_quote.
          <lst_idoc_rec_i0343_cust>-sdata = lst_e1edk02_11.
        ENDIF.
      ENDIF.
    ENDIF. "IF lst_xvbak11-auart IN lr_doc_type_i0343.
**End of Add : ERP-7318 : PRABHU : 11-Feb-2019 ED2K913969
    IF lst_e1edka1_11-partn IS INITIAL AND                 " Partner number is not populated
       lst_xvbak11-auart    IN lr_doc_type_i0343.
*     Read ABAP Stack to get details of IDOC Data
      ASSIGN (lc_idoc_i0343) TO <li_idoc_rec_i0343>.
*     Get IDoc: Document header reference data
      READ TABLE <li_idoc_rec_i0343> ASSIGNING FIELD-SYMBOL(<lst_idoc_rec_i0343>)
           WITH KEY segnam   = lc_e1edk02_11
                    sdata(3) = lc_qualf_004_11.
      IF sy-subrc EQ 0.
        lst_e1edk02_11 = <lst_idoc_rec_i0343>-sdata.       " IDoc: Document header reference data
* Begin of ADD:ERP-5975:WROY:17-Jan-2018:ED2K910335
        IF v_quote IS NOT INITIAL.
          lst_e1edk02_11-belnr = v_quote.
          <lst_idoc_rec_i0343>-sdata = lst_e1edk02_11.
          lv_quote = v_quote.                             " Quotation Number (Reference)
        ELSE.
**End of Add : ERP-7318 : PRABHU : 11-Feb-2019 ED2K913969
          lv_quote = lst_e1edk02_11-belnr.                   " Quotation Number (Reference)
        ENDIF.
        IF lv_quote IS NOT INITIAL.
*         Add Leading Zeros (convert external to internal format)
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lv_quote                            " External Format
            IMPORTING
              output = lv_quote.                           " Internal Format
*         Fetch Sales Document: Partner Details
          CALL FUNCTION 'SD_VBPA_READ_WITH_VBELN'
            EXPORTING
              i_vbeln          = lv_quote                  " Quotation Number (Reference)
            TABLES
              et_vbpa          = li_vbpa_i0343             " Sales Document: Partner Details
            EXCEPTIONS
              record_not_found = 1
              OTHERS           = 2.
          IF sy-subrc EQ 0.
*           Get Sales Document: Partner Details of Quotation Number (Reference)
            READ TABLE li_vbpa_i0343 ASSIGNING FIELD-SYMBOL(<lst_vbpa_i0343>)
                 WITH KEY posnr = lc_posnr_low_i0343
                          parvw = lst_e1edka1_11-parvw.
            IF sy-subrc EQ 0.
*             Update Address details
              READ TABLE dxvbadr ASSIGNING <lst_xvbadr_11>
                   WITH KEY ('POSNR') = lc_posnr_low_i0343
                            ('PARVW') = lst_e1edka1_11-parvw.
              IF sy-subrc EQ 0.
                <lst_xvbadr_11>-kunnr = <lst_vbpa_i0343>-kunnr.

                IF lst_e1edka1_11-parvw EQ lc_ag11.
                  lst_xvbak11-kunnr = <lst_vbpa_i0343>-kunnr.
                  dxvbak = lst_xvbak11.                    " Sales Document: Header Data
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
* End   of ADD:ERP-5975:WROY:17-Jan-2018:ED2K910335

  WHEN OTHERS.
    " nothing to do

ENDCASE.
