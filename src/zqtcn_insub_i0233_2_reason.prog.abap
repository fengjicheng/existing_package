*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVDBU01 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for order determination and material,
*                       customer conversion
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   24/10/2016
* OBJECT ID: I0233.2
* TRANSPORT NUMBER(S):  ED2K903117
*----------------------------------------------------------------------*
*** Local types Declaration for VBAK
TYPES: BEGIN OF lty_xvbak_233_r. "Kopfdaten
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
        END OF lty_xvbak_233_r.

*** Local types declaration for vbeln
TYPES: BEGIN OF lty_vbeln1,
         vbeln   TYPE vbeln_va,
         bstdk   TYPE bstdk,     " Customer purchase order date
         vbegdat TYPE vbdat_veda,
       END OF lty_vbeln1.

*** Local Structure declaration of XVBAP
*-------------------->>> XVBAP
TYPES: BEGIN OF lty_xvbap_233_r. "Position
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
        END OF lty_xvbap_233_r.

*** Local Structure declaration of XVBADR
TYPES: BEGIN OF lty_xvbadr_233_r , "Partner
         posnr LIKE vbap-posnr,  " Sales Document Item
         parvw LIKE vbpa-parvw,  " Partner Function
         kunnr LIKE rv02p-kunde, " Partner number (KUNNR, LIFNR, or PERNR)
         ablad LIKE vbpa-ablad.  " Unloading Point
        INCLUDE STRUCTURE vbadr. " Address work area
TYPES: END OF lty_xvbadr_233_r.

*** Local Structure for VEDA
*TYPES: BEGIN OF lty_veda_r,
*         vbeln   TYPE vbeln_va,
*         vbegdat TYPE vbdat_veda,
*       END OF lty_veda_r.

*** Local internal table declaration
DATA: li_xvbadr1     TYPE STANDARD TABLE OF lty_xvbadr_233_r,
      li_xvbap_233_r TYPE STANDARD TABLE OF lty_xvbap_233_r,
      li_vbeln1      TYPE STANDARD TABLE OF lty_vbeln1,
      li_vbelnfr     TYPE STANDARD TABLE OF lty_vbeln1.

*** Local Structure and internal table declaration
DATA:   lst_xvbak_233_r            TYPE lty_xvbak_233_r,
        lst_veda_r                 TYPE lty_vbeln1, "lty_veda_r,
        lst_xvbap_233_r            TYPE lty_xvbap_233_r,
        lst_xvbadr_233_r           TYPE lty_xvbadr_233_r,
        lst_z1qtc_e1edka1_01_233_r TYPE z1qtc_e1edka1_01, " Partner Information (Legacy Customer Number)
        lst_vbelnfr                TYPE lty_vbeln1,
        lst_knmt_r                 TYPE knmt,
        lst_e1edka3_233_r          TYPE e1edka3,
        lst_e1edk02_233_r          TYPE e1edk02,
        lst_e1eds01_r              TYPE e1eds01.


*** Local variable declaration
DATA:  lv_jrnl4  TYPE ismidentcode, " Identification Code
       lv_tabix4 TYPE sytabix,
       lv_tabix5 TYPE sytabix,
       lv_tabix6 TYPE sytabix,
       lv_stdt1  TYPE char4,
       lv_test1  TYPE sy-datum,
       lv_partn4 TYPE bu_id_number, " Identification Number
       lv_partc  TYPE char10,
       lv_year3  TYPE char4,
       lv_year2  TYPE char4,
       lv_matnr  TYPE matnr,
       lv_kdmat  TYPE MATNR_KU,
       lv_kunnr4 TYPE kunnr.        " Customer Number.

*** Local field symbol declaration
FIELD-SYMBOLS: <lst_xvbadr_233_r> TYPE lty_xvbadr_233_r.

*** Local Constant Declaration
CONSTANTS: lc_jrnl4         TYPE ismidcodetype VALUE 'ZEAN', " Type of Identification Code
           lc_as            TYPE Char2 VALUE 'AS',           " Publication type
           lc_ag4           TYPE parvw VALUE 'AG',
           lc_we4           TYPE parvw VALUE 'WE',
           lc_abgru         TYPE abgru_va VALUE '  ',
           lc_e1edk02_233_r TYPE edi_segnam VALUE 'E1EDK02',
           lc_e1eds01_233_r TYPE edi_segnam VALUE 'E1EDS01',
           lc_0000          TYPE posnr_va VALUE '000000',
           lc_29_r          TYPE sumid VALUE '029',
           lc_19_r          TYPE edi_iddat VALUE '001',
           lc_005_r         TYPE edi_qualp VALUE '005'.



*** Fetching Subscription Order
IF segment-segnam = lc_e1eds01_233_r.
  lst_e1eds01_r = segment-sdata.
  IF lst_e1eds01_r-sumid = lc_29_r.

    lst_xvbak_233_r = dxvbak.
    li_xvbadr1[] = dxvbadr[].
    li_xvbap_233_r[] = dxvbap[].
    APPEND dxvbap TO li_xvbap_233_r.
    SORT li_xvbadr1 BY parvw.
* While looking for Material, SOLD TO should be used                      "INC0193661+
*    READ TABLE li_xvbadr1 INTO lst_xvbadr_233_r WITH KEY parvw = lc_we4  "INC0193661-
    READ TABLE li_xvbadr1 INTO lst_xvbadr_233_r WITH KEY parvw = lc_ag4   "INC0193661+
                                                           BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      LOOP AT li_xvbap_233_r ASSIGNING FIELD-SYMBOL(<lst_xvbap_233_r>).
        IF <lst_xvbap_233_r>-matnr IS INITIAL AND
           <lst_xvbap_233_r>-kdmat IS NOT INITIAL.
          CALL FUNCTION 'RV_CUSTOMER_MATERIAL_READ'
            EXPORTING
              cmr_kdmat      = <lst_xvbap_233_r>-kdmat
              cmr_kunnr      = lst_xvbak_233_r-kunnr
              cmr_matnr      = <lst_xvbap_233_r>-matnr
              cmr_spart      = lst_xvbak_233_r-spart
              cmr_vkorg      = lst_xvbak_233_r-vkorg
              cmr_vtweg      = lst_xvbak_233_r-vtweg
            IMPORTING
              cmr_knmt       = lst_knmt_r
            EXCEPTIONS
              knmt_not_found = 1
              OTHERS         = 2.
          IF sy-subrc EQ 0.
            <lst_xvbap_233_r>-matnr = lst_knmt_r-matnr.
          ELSE.
* If the material is not found with all chars of KDMAT, search with first 2 chars
            lv_kdmat = <lst_xvbap_233_r>-kdmat+0(2).
            CALL FUNCTION 'RV_CUSTOMER_MATERIAL_READ'
              EXPORTING
                cmr_kdmat      = lv_kdmat
                cmr_kunnr      = lst_xvbak_233_r-kunnr
                cmr_matnr      = <lst_xvbap_233_r>-matnr
                cmr_spart      = lst_xvbak_233_r-spart
                cmr_vkorg      = lst_xvbak_233_r-vkorg
                cmr_vtweg      = lst_xvbak_233_r-vtweg
              IMPORTING
                cmr_knmt       = lst_knmt_r
              EXCEPTIONS
                knmt_not_found = 1
              OTHERS         = 2.
            IF sy-subrc EQ 0.
              <lst_xvbap_233_r>-matnr = lst_knmt_r-matnr.
* If found, check if the Material Publication type is 'AS'.
              clear lv_matnr.
              select single matnr from mara
                     into lv_matnr
                     where matnr = <lst_xvbap_233_r>-matnr
                     and   ismpubltype = lc_as.
* If Material pub type is not 'AS', the Material is not right one.
              if sy-subrc <> 0.
                clear <lst_xvbap_233_r>-matnr.
              endif.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
* While looking for Contracts/Orders, SHIP TO should be used                "INC0193661+
    READ TABLE li_xvbadr1 INTO lst_xvbadr_233_r WITH KEY parvw = lc_we4     "INC0193661+
                                                          BINARY SEARCH.    "INC0193661+
    SELECT a~vbeln
           a~bstdk "Customer purchase order date
           d~vbegdat
      INTO TABLE li_vbeln1
      FROM vbak AS a
      INNER JOIN vbap AS b ON b~vbeln = a~vbeln
      INNER JOIN vbpa AS c ON c~vbeln = a~vbeln
                          AND c~parvw = lst_xvbadr_233_r-parvw
                          AND c~kunnr = lst_xvbadr_233_r-kunnr
      INNER JOIN veda AS d ON d~vbeln = a~vbeln
                          AND d~vposn = lc_0000
      FOR ALL ENTRIES IN li_xvbap_233_r
      WHERE a~auart = lst_xvbak_233_r-auart
        AND a~vkorg = lst_xvbak_233_r-vkorg
        AND a~vtweg = lst_xvbak_233_r-vtweg
        AND a~spart = lst_xvbak_233_r-spart
        AND a~kunnr = lst_xvbak_233_r-kunnr
        AND b~matnr = li_xvbap_233_r-matnr
        AND b~abgru = lc_abgru.

    IF sy-subrc = 0.

      CALL FUNCTION 'ZQTC_GET_CON_STDT_FM'
        IMPORTING
          ex_stdt = lv_stdt1.


      LOOP AT li_vbeln1 INTO lst_veda_r.

*       lv_year3 = lv_stdt1." from IDOC
*       lv_year2 = lst_veda_r-vbegdat+0(4).
        lv_year3 = lst_xvbak_233_r-bstdk+0(4). "Customer purchase order date
        lv_year2 = lst_veda_r-bstdk+0(4).
        IF lv_year3 = lv_year2.
          lst_vbelnfr-vbeln   = lst_veda_r-vbeln.
          lst_vbelnfr-bstdk   = lst_veda_r-bstdk.
          lst_vbelnfr-vbegdat = lst_veda_r-vbegdat.
          APPEND lst_vbelnfr TO li_vbelnfr.
        ENDIF.
      ENDLOOP.
      DESCRIBE TABLE li_vbelnfr LINES lv_tabix5.
*      IF lv_tabix5 NE '1'.
      IF lv_tabix5 EQ '0'.
        MESSAGE e020(zqtc_r2) RAISING user_error.
      ELSE.
        sort li_vbelnfr by bstdk descending.
        READ TABLE li_vbelnfr INTO lst_vbelnfr INDEX 1.
        lst_xvbak_233_r-vbeln = lst_vbelnfr-vbeln.
        dxvbak = lst_xvbak_233_r.
      ENDIF.

    ELSE.
      IF li_vbeln1 IS INITIAL.
        MESSAGE e020(zqtc_r2) RAISING user_error.
      ENDIF.
    ENDIF.

  ENDIF.

ENDIF.

***Fetching Email Address of Partner and inserting it into XVBADR structure
IF segment-segnam = 'E1EDKA3'.
  lst_e1edka3_233_r = segment-sdata.
  IF lst_e1edka3_233_r-qualp = lc_005_r.

    DESCRIBE TABLE dxvbadr LINES lv_tabix6.
*** Fetching partner information
    READ TABLE dxvbadr ASSIGNING <lst_xvbadr_233_r> INDEX lv_tabix6.
    IF <lst_xvbadr_233_r> IS ASSIGNED.
      <lst_xvbadr_233_r>-email_addr = lst_e1edka3_233_r-stdpn.
    ENDIF.
  ENDIF.

ENDIF.

IF segment-segnam = lc_e1edk02_233_r.
  lst_e1edk02_233_r = segment-sdata.
  IF lst_e1edk02_233_r-qualf = lc_19_r.
*    WRITE lst_e1edk03_233_r-datum TO lv_test1.
    lv_stdt1 = lst_e1edk02_233_r-datum+0(4).

    CALL FUNCTION 'ZQTC_SET_CON_STDT_FM'
      EXPORTING
        im_stdt = lv_stdt1.


  ENDIF.
ENDIF.


*** If the segment is E1EDP19 then we are fetching material from it
*** and converting it

IF segment-segnam = 'E1EDP19'.
*** Storing XVBAP in local work area
  lst_xvbap_233_r = dxvbap.
  lv_jrnl4   = lst_xvbap_233_r-matnr.
***** Calling FM to convert legacy material into SAP Material

  CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
    EXPORTING
      im_idcodetype      = lc_jrnl4
      im_legacy_material = lv_jrnl4
    IMPORTING
      ex_sap_material    = lst_xvbap_233_r-matnr
    EXCEPTIONS
      wrong_input_values = 1
      OTHERS             = 2.

  IF sy-subrc = 0.
* Implement suitable error handling here
    dxvbap = lst_xvbap_233_r.
  ENDIF.

ENDIF.

*** Customer Conversion, fetching customer from z1qtc_e1edka1 segment
*** converting it and inserting it into XVBADR structure
IF segment-segnam = 'Z1QTC_E1EDKA1_01'.

*** keeping the segment data in local work area
  lst_z1qtc_e1edka1_01_233_r = segment-sdata.
  DESCRIBE TABLE dxvbadr LINES lv_tabix4.
*** Fetching partner information
  READ TABLE dxvbadr ASSIGNING <lst_xvbadr_233_r> INDEX lv_tabix4.

  IF <lst_xvbadr_233_r> IS ASSIGNED.

    lv_partn4 = lst_z1qtc_e1edka1_01_233_r-partner.
    lst_xvbak_233_r = dxvbak.
*** Calling FM to convert Customer
    CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_CUSTOMER'
      EXPORTING
        im_company_code    = lst_xvbak_233_r-vkorg
        im_leg_customer    = lv_partn4
      IMPORTING
        ex_sap_customer    = lv_kunnr4
      EXCEPTIONS
        wrong_input_values = 1
        invalid_comp_code  = 2
        OTHERS             = 3.
    IF sy-subrc = 0 AND lv_kunnr4 IS NOT INITIAL.
* Implement suitable error handling here
      <lst_xvbadr_233_r>-kunnr = lv_kunnr4.
    ELSE. " ELSE -> IF sy-subrc = 0
      lv_partc = lv_partn4.
*** Conversion exit for customer conversion
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_partc
        IMPORTING
          output = lv_partc.


      <lst_xvbadr_233_r>-kunnr = lv_partc.
    ENDIF. " IF sy-subrc = 0

*** Checking the partner type and if it is 'AG' the
*** Inserting partner value in XVBAK structure
    IF <lst_xvbadr_233_r>-parvw = lc_ag4.
      lst_xvbak_233_r = dxvbak.
      lst_xvbak_233_r-kunnr = <lst_xvbadr_233_r>-kunnr.
      dxvbak = lst_xvbak_233_r.
    ENDIF. " IF <lst_xvbadr_238>-parvw = lc_ag2
  ENDIF. " IF <lst_xvbadr_238> IS ASSIGNED

ENDIF. " IF segment-segnam = 'Z1QTC_E1EDKA1_01'
