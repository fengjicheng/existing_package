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
TYPES: BEGIN OF lty_xvbak_233_2. "Kopfdaten
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
        END OF lty_xvbak_233_2.

*** Local Structure declaration of XVBAP
*-------------------->>> XVBAP
TYPES: BEGIN OF lty_xvbap_233_2. "Position
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
        END OF lty_xvbap_233_2.

*** Local Structure declaration of XVBADR
TYPES: BEGIN OF lty_xvbadr_233_2 , "Partner
         posnr LIKE vbap-posnr,  " Sales Document Item
         parvw LIKE vbpa-parvw,  " Partner Function
         kunnr LIKE rv02p-kunde, " Partner number (KUNNR, LIFNR, or PERNR)
         ablad LIKE vbpa-ablad.  " Unloading Point
        INCLUDE STRUCTURE vbadr. " Address work area
TYPES: END OF lty_xvbadr_233_2.

*** Local types declaration for vbeln
TYPES: BEGIN OF lty_vbeln,
         vbeln   TYPE vbeln_va,
         bstdk   TYPE bstdk,     " Customer purchase order date
         vbegdat TYPE vbdat_veda,
       END OF lty_vbeln.

TYPES: BEGIN OF lty_vbpa,
         vbeln TYPE vbeln,
         posnr TYPE posnr,
         parvw TYPE parvw,
         kunnr TYPE kunnr,
       END OF lty_vbpa.

TYPES: BEGIN OF lty_vbap,
         vbeln TYPE vbeln_va,
         posnr TYPE posnr_va,
         matnr TYPE matnr,
         abgru TYPE abgru_va,
       END OF lty_vbap.

*TYPES: BEGIN OF lty_veda,
*         vbeln   TYPE vbeln_va,
*         vbegdat TYPE vbdat_veda,
*       END OF lty_veda.

TYPES: BEGIN OF lty_insub_agu,
         land1 TYPE land1,
         waerk TYPE waerk,
         vkorg TYPE vkorg,
         vtweg TYPE vtweg,
         spart TYPE spart,
       END OF lty_insub_agu.

*** Local structure dfeclaration
DATA:   lst_xvbak_233_2          TYPE lty_xvbak_233_2,
        lst_xvbap_233_2          TYPE lty_xvbap_233_2,
        lst_xvbadr_233_2         TYPE lty_xvbadr_233_2,
        lst_z1qtc_e1edka1_01_233 TYPE z1qtc_e1edka1_01, " Partner Information (Legacy Customer Number)
        lst_e1edka3_233_2        TYPE e1edka3,
        lst_e1edka1_233_2        TYPE e1edka1,
        lst_veda                 TYPE lty_vbeln, "lty_veda,
        lst_vbelnf               TYPE lty_vbeln,
        lst_e1edk03_233_2        TYPE e1edk03,
        lst_e1edk01_233_2        TYPE e1edk01,
        lst_e1edk14_233_2        TYPE e1edk14,
        lst_xvbadr_233_2w        TYPE lty_xvbadr_233_2,
        lst_insub_agu            TYPE lty_insub_agu,
        lst_e1eds01              TYPE e1eds01.

*** Local variable declaration
DATA:  lv_jrnl3   TYPE ismidentcode, " Identification Code
       lv_tabix1  TYPE sytabix,
       lv_tabix2  TYPE sytabix,
       lv_partn3  TYPE bu_id_number, " Identification Number
       lv_kunnr3  TYPE kunnr,        " Customer Number.
       lv_partd   TYPE char10,
       lv_year    TYPE char4,
       lv_sa_flag TYPE char1,
       lv_year1   TYPE char4.

*** Local Internal table Declaration
DATA: li_vbeln       TYPE STANDARD TABLE OF lty_vbeln,
      li_xvbadr      TYPE STANDARD TABLE OF lty_xvbadr_233_2,
      li_xvbap_233_2 TYPE STANDARD TABLE OF lty_xvbap_233_2,
      li_vbelnf      TYPE STANDARD TABLE OF lty_vbeln.

*** Local Variable Declaration
DATA: lv_stdt  TYPE char4,
      lv_land1 TYPE land1,
      lv_waerk TYPE waerk,
      lv_test  TYPE sy-datum.

*** Local field symbol declaration
FIELD-SYMBOLS: <lst_xvbadr_233_2> TYPE lty_xvbadr_233_2.

*** Local Constant Declaration
CONSTANTS: lc_jrnl3         TYPE ismidcodetype VALUE 'ZEAN', " Type of Identification Code
           lc_ag3           TYPE parvw VALUE 'AG',
           lc_we3           TYPE parvw VALUE 'WE',
           lc_e1edk03_233_2 TYPE edi_segnam VALUE 'E1EDK03',
           lc_e1eds01_233_2 TYPE edi_segnam VALUE 'E1EDS01',
           lc_29            TYPE sumid VALUE '029',
           lc_19            TYPE edi_iddat VALUE '019',
           lc_000           TYPE posnr_va VALUE '000000',
           lc_005           TYPE edi_qualp VALUE '005'.

*** Fetching Subscription Order
IF segment-segnam = lc_e1eds01_233_2.
  lst_e1eds01 = segment-sdata.
  IF lst_e1eds01-sumid = lc_29.

    lst_xvbak_233_2 = dxvbak.

    li_xvbadr[] = dxvbadr[].
    li_xvbap_233_2[] = dxvbap[].
    APPEND dxvbap TO li_xvbap_233_2.
    SORT li_xvbadr BY parvw.
    READ TABLE li_xvbadr INTO lst_xvbadr_233_2 WITH KEY parvw = lc_we3
                                                         BINARY SEARCH.

***<<--- Change
    IF lst_xvbak_233_2-vkorg IS INITIAL.

*   For small amount of data binary search is not required
      READ TABLE li_xvbadr INTO lst_xvbadr_233_2w
      WITH KEY parvw = lc_ag3.

      IF sy-subrc IS INITIAL.
        lv_land1 = lst_xvbadr_233_2w-land1.
      ENDIF.
*** select data from ZQTC_INSUB_AGU table
      SELECT SINGLE land1
                    waerk
                    vkorg
                    vtweg
                    spart
        INTO lst_insub_agu
        FROM zqtc_sales_area
        WHERE land1 = lv_land1
        AND waerk = lst_xvbak_233_2-waerk. "lv_waerk.

      IF sy-subrc = 0.
        lst_xvbak_233_2 = dxvbak.
        lst_xvbak_233_2-vkorg = lst_insub_agu-vkorg.
        lst_xvbak_233_2-vtweg = lst_insub_agu-vtweg.
        lst_xvbak_233_2-spart = lst_insub_agu-spart.
        dxvbak = lst_xvbak_233_2.
      ENDIF.

    ENDIF.
*** Change <<----
    SORT li_xvbap_233_2 BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM li_xvbap_233_2.

    SELECT a~vbeln
           a~bstdk "Customer purchase order date
           d~vbegdat
      INTO TABLE li_vbeln
      FROM vbak AS a
      INNER JOIN vbap AS b ON b~vbeln = a~vbeln
      INNER JOIN vbpa AS c ON c~vbeln = a~vbeln
                          AND c~parvw = lst_xvbadr_233_2-parvw
                          AND c~kunnr = lst_xvbadr_233_2-kunnr
      INNER JOIN veda AS d ON d~vbeln = a~vbeln
                          AND d~vposn = lc_000
      FOR ALL ENTRIES IN li_xvbap_233_2
      WHERE a~auart = lst_xvbak_233_2-auart
        AND a~vkorg = lst_xvbak_233_2-vkorg
        AND a~vtweg = lst_xvbak_233_2-vtweg
        AND a~spart = lst_xvbak_233_2-spart
        AND a~kunnr = lst_xvbak_233_2-kunnr
        AND b~matnr = li_xvbap_233_2-matnr
        AND b~abgru = li_xvbap_233_2-abgru.

    IF sy-subrc = 0.

      CALL FUNCTION 'ZQTC_GET_CON_STDT_FM'
        IMPORTING
          ex_stdt = lv_stdt.


      LOOP AT li_vbeln INTO lst_veda.

*       lv_year = lv_stdt." from IDOC
*       lv_year1 = lst_veda-vbegdat+0(4).
        lv_year = lst_xvbak_233_2-bstdk+0(4). "Customer purchase order date
        lv_year1 = lst_veda-bstdk+0(4).
        IF lv_year = lv_year1.
          lst_vbelnf-vbeln = lst_veda-vbeln.
          APPEND lst_vbelnf TO li_vbelnf.
        ENDIF.
      ENDLOOP.
      DESCRIBE TABLE li_vbelnf LINES lv_tabix2.
      IF lv_tabix2 NE '1'.
        MESSAGE e020(zqtc_r2) RAISING user_error.
      ELSE.
        READ TABLE li_vbelnf INTO lst_vbelnf INDEX 1.
        lst_xvbak_233_2-vbeln = lst_vbelnf-vbeln.
        dxvbak = lst_xvbak_233_2.
      ENDIF.

    ELSE.

      IF li_vbeln IS INITIAL.
        MESSAGE e020(zqtc_r2) RAISING user_error.
      ENDIF.

    ENDIF.

  ENDIF.

ENDIF.


IF segment-segnam = lc_e1edk03_233_2.
  lst_e1edk03_233_2 = segment-sdata.
  IF lst_e1edk03_233_2-iddat = lc_19.
    WRITE lst_e1edk03_233_2-datum TO lv_test.
    lv_stdt = lv_test+0(4).

    CALL FUNCTION 'ZQTC_SET_CON_STDT_FM'
      EXPORTING
        im_stdt = lv_stdt.


  ENDIF.
ENDIF.

***Fetching Email Address of Partner and inserting it into XVBADR structure
IF segment-segnam = 'E1EDKA3'.
  lst_e1edka3_233_2 = segment-sdata.
  IF lst_e1edka3_233_2-qualp = lc_005.

    DESCRIBE TABLE dxvbadr LINES lv_tabix1.
*** Fetching partner information
    READ TABLE dxvbadr ASSIGNING <lst_xvbadr_233_2> INDEX lv_tabix1.
    IF <lst_xvbadr_233_2> IS ASSIGNED.
      <lst_xvbadr_233_2>-email_addr = lst_e1edka3_233_2-stdpn.
    ENDIF.
  ENDIF.

ENDIF.

*** If the segment is E1EDP19 then we are fetching material from it
*** and converting it

IF segment-segnam = 'E1EDP19'.
*** Storing XVBAP in local work area
  lst_xvbap_233_2 = dxvbap.
  lv_jrnl3   = lst_xvbap_233_2-matnr.
***** Calling FM to convert legacy material into SAP Material
  CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
    EXPORTING
      im_idcodetype      = lc_jrnl3
      im_legacy_material = lv_jrnl3
    IMPORTING
      ex_sap_material    = lst_xvbap_233_2-matnr
    EXCEPTIONS
      wrong_input_values = 1
      OTHERS             = 2.
  IF sy-subrc = 0.
* Implement suitable error handling here
    dxvbap = lst_xvbap_233_2.
  ENDIF. " IF sy-subrc = 0

ENDIF. " IF segment-segnam = 'E1EDP19'

*** Customer Conversion, fetching customer from z1qtc_e1edka1 segment
*** and inserting it xvbadr structure
IF segment-segnam = 'Z1QTC_E1EDKA1_01'.

*** keeping the segment data in local work area
  lst_z1qtc_e1edka1_01_233 = segment-sdata.
  DESCRIBE TABLE dxvbadr LINES lv_tabix1.
*** Fetching partner information
  READ TABLE dxvbadr ASSIGNING <lst_xvbadr_233_2> INDEX lv_tabix1.

  IF <lst_xvbadr_233_2> IS ASSIGNED.

    lv_partn3 = lst_z1qtc_e1edka1_01_233-partner.
    lst_xvbak_233_2 = dxvbak.
*** Calling FM to convert Customer
    CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_CUSTOMER'
      EXPORTING
        im_company_code    = lst_xvbak_233_2-vkorg
        im_leg_customer    = lv_partn3
      IMPORTING
        ex_sap_customer    = lv_kunnr3
      EXCEPTIONS
        wrong_input_values = 1
        invalid_comp_code  = 2
        OTHERS             = 3.
    IF sy-subrc = 0 AND lv_kunnr3 IS NOT INITIAL.
* Implement suitable error handling here
      <lst_xvbadr_233_2>-kunnr = lv_kunnr3.
    ELSE. " ELSE -> IF sy-subrc = 0
      lv_partd = lv_partn3.
*** Conversion exit for customer conversion
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_partd
        IMPORTING
          output = lv_partd.

      <lst_xvbadr_233_2>-kunnr = lv_partd.
    ENDIF. " IF sy-subrc = 0

*** Checking the partner type and if it is 'AG' the
*** Inserting partner value in XVBAK structure
    IF <lst_xvbadr_233_2>-parvw = lc_ag3.
      lst_xvbak_233_2 = dxvbak.
      lst_xvbak_233_2-kunnr = <lst_xvbadr_233_2>-kunnr.
      dxvbak = lst_xvbak_233_2.
    ENDIF. " IF <lst_xvbadr_238>-parvw = lc_ag2
  ENDIF. " IF <lst_xvbadr_238> IS ASSIGNED

ENDIF. " IF segment-segnam = 'Z1QTC_E1EDKA1_01'
