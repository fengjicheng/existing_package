*----------------------------------------------------------------------*
* PROGRAM NAME:       ZQTCN_INBOUND_I0233_2
* PROGRAM DESCRIPTION:Idoc will create a subscriptions in SAP
* DEVELOPER:          SRBOSE (Srabanti Bose)
* CREATION DATE:      17-Oct-2016
* OBJECT ID:          I0233.2
* TRANSPORT NUMBER(S):ED2K903117
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INBOUND_I0233_2
*&---------------------------------------------------------------------*

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

*** Local Structure declaration for XVBADR
TYPES: BEGIN OF lty_xvbadr_233 ,       "Partner
         posnr LIKE vbap-posnr,        "Sales Document Item
         parvw LIKE vbpa-parvw,        "Partner Function
         kunnr LIKE rv02p-kunde,       "Partner number (KUNNR, LIFNR, or PERNR)
         ablad LIKE vbpa-ablad,        "Unloading Point
         knref LIKE knvp-knref.        "Customer description of partner (plant, storage location)
        INCLUDE STRUCTURE vbadr.       "Address work area
TYPES: END OF lty_xvbadr_233.

*** Local Structure declaration for XVBAK
TYPES: BEGIN OF lty_xvbak_233.        "Kopfdaten
        INCLUDE STRUCTURE vbak.       "Sales Document: Header Data
TYPES:  bstkd     LIKE vbkd-bstkd.    "Customer purchase order number
TYPES:  kursk     LIKE vbkd-kursk.    "Währungskurs
TYPES:  zterm     LIKE vbkd-zterm.    "Zahlungsbedingungsschlüssel
TYPES:  incov     LIKE vbkd-incov.    "Incoterms Teil Version
TYPES:  inco1     LIKE vbkd-inco1.    "Incoterms Teil 1
TYPES:  inco2     LIKE vbkd-inco2.    "Incoterms Teil 2
TYPES:  inco2_l   LIKE vbkd-inco2_l.  "Incoterms Teil 2_L
TYPES:  inco3_l   LIKE vbkd-inco3_l.  "Incoterms Teil 3_L
TYPES:  prsdt     LIKE vbkd-prsdt.    "Datum für Preisfindung
TYPES:  angbt     LIKE vbak-vbeln.    "Angebotsnummer Lieferant (SAP)
TYPES:  contk     LIKE vbak-vbeln.    "Kontraknummer Lieferant (SAP)
TYPES:  kzazu     LIKE vbkd-kzazu.    "Kz. Auftragszusammenführung
TYPES:  fkdat     LIKE vbkd-fkdat.    "Datum Faktura-/Rechnungsindex
TYPES:  fbuda     LIKE vbkd-fbuda.    "Datum der Leistungserstellung
TYPES:  empst     LIKE vbkd-empst.    "Empfangsstelle
TYPES:  valdt     LIKE vbkd-valdt.    "Valuta-Fix Datum
TYPES:  kdkg1     LIKE vbkd-kdkg1.    "Kunden Konditionsgruppe 1
TYPES:  kdkg2     LIKE vbkd-kdkg2.    "Kunden Konditionsgruppe 2
TYPES:  kdkg3     LIKE vbkd-kdkg3.    "Kunden Konditionsgruppe 3
TYPES:  kdkg4     LIKE vbkd-kdkg4.    "Kunden Konditionsgruppe 4
TYPES:  kdkg5     LIKE vbkd-kdkg5.    "Kunden Konditionsgruppe 5
TYPES:  delco     LIKE vbkd-delco.    "vereinbarte Lieferzeit
TYPES:  abtnr     LIKE vbkd-abtnr.    "Abteilungsnummmer
TYPES:  dwerk     LIKE rv45a-dwerk.   "disponierendes Werk
TYPES:  angbt_ref LIKE vbkd-bstkd.    "Angebotsnummer Kunde (SAP)
TYPES:  contk_ref LIKE vbkd-bstkd.    "Kontraknummer Kunde  (SAP)
TYPES:  currdec   LIKE tcurx-currdec. "Dezimalstellen Währung
TYPES:  bstkd_e   LIKE vbkd-bstkd_e.  "Bestellnummer Warenempfänger
TYPES:  bstdk_e   LIKE vbkd-bstdk_e.  "Bestelldatum Warenempfänger
TYPES: END OF lty_xvbak_233.

TYPES: BEGIN OF d_flag_k_233,
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
       END OF d_flag_k_233.

*** Local Workarea declaration
DATA:
  lst_xvbak_233   TYPE lty_xvbak_233,
  lst_xvbap_233_2 TYPE lty_xvbap_233_2,
  lst_flag_233    TYPE d_flag_k_233,
  lst_e1edka3_233 TYPE e1edka3,
  lst_z1edka1_233 TYPE z1qtc_e1edka1_01,
  lst_e1edka1_233 TYPE e1edka1,
  lst_e1edk01_233 TYPE e1edk01. " IDoc: Document header general data

*** Local Data declaration
DATA: lv_tabix_233 TYPE sytabix,
      lv_jrnl3_2   TYPE ismidentcode. " Identification Code

*** Local field symbol declaration
FIELD-SYMBOLS: <lst_xvbadr_233> TYPE lty_xvbadr,
               <lv_field_value> TYPE any.

CONSTANTS: lc_jrnl3_2 TYPE ismidcodetype VALUE 'ZEAN'. " Type of Identification Code

DATA:
  lv_idoc_data    TYPE char30 VALUE '(SAPLVEDA)IDOC_DATA[]',
  lv_sap_customer TYPE kunnr.

FIELD-SYMBOLS:
  <li_idoc_recrd> TYPE edidd_tt.

DATA:
  lst_so_header   TYPE vbak,
  lst_so_item_det TYPE vbap.

ASSIGN (lv_idoc_data) TO <li_idoc_recrd>.

CASE segment-segnam.
  WHEN 'E1EDK01'.
    lst_e1edk01_233 = segment-sdata.
    IF lst_e1edk01_233-bsart IS NOT INITIAL.
      CLEAR: lst_xvbak_233.
      lst_xvbak_233 = dxvbak.
      lst_xvbak_233-bsark = lst_e1edk01_233-bsart.
      dxvbak = lst_xvbak_233.

      lst_flag_233 = dd_flag_k.
      lst_flag_233-kbes = abap_true.
      dd_flag_k = lst_flag_233.

    ENDIF. " IF lst_e1edk01-bsart IS NOT INITIAL

  WHEN 'E1EDKA1'.
    lst_e1edka1_233 = segment-sdata.

    IF lst_e1edka1_233-parvw EQ 'AG'.
      READ TABLE <li_idoc_recrd> ASSIGNING FIELD-SYMBOL(<lst_idoc_recrd>)
           WITH KEY segnam = 'E1EDK01'.
      IF sy-subrc EQ 0.
        lst_e1edk01_233 = <lst_idoc_recrd>-sdata.
      ENDIF.

      SELECT SINGLE vkorg
        FROM zqtc_sales_area
        INTO @DATA(lv_vkorg)
       WHERE land1 EQ @lst_e1edka1_233-land1
         AND waerk EQ @lst_e1edk01_233-curcy.
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING dxvbak TO lst_so_header.
        lst_so_header-vkorg = lv_vkorg.
        MOVE-CORRESPONDING lst_so_header TO dxvbak.
      ENDIF.
    ENDIF.

  WHEN 'E1EDKA3'.
    lst_e1edka3_233 = segment-sdata.
    IF lst_e1edka3_233-qualp = '005'.

      DESCRIBE TABLE dxvbadr LINES lv_tabix_233.
*** Fetching partner information
      READ TABLE dxvbadr ASSIGNING <lst_xvbadr_233> INDEX lv_tabix_233.
      IF <lst_xvbadr_233> IS ASSIGNED.
        <lst_xvbadr_233>-email_addr = lst_e1edka3_233-stdpn.
      ENDIF.
    ENDIF.

  WHEN 'Z1QTC_E1EDKA1_01'.
    lst_z1edka1_233 = segment-sdata.
    READ TABLE <li_idoc_recrd> ASSIGNING <lst_idoc_recrd>
         WITH KEY segnum = segment-psgnum.
    IF sy-subrc EQ 0.
      lst_e1edka1_233 = <lst_idoc_recrd>-sdata.

      MOVE-CORRESPONDING dxvbak TO lst_so_header.
*     Calling FM to convert Customer
      CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_CUSTOMER'
        EXPORTING
          im_company_code    = lst_so_header-vkorg
          im_leg_customer    = lst_z1edka1_233-partner
        IMPORTING
          ex_sap_customer    = lv_sap_customer
        EXCEPTIONS
          wrong_input_values = 1
          invalid_comp_code  = 2
          OTHERS             = 3.
      IF sy-subrc        NE 0 OR
         lv_sap_customer IS INITIAL..
        lv_sap_customer = lst_z1edka1_233-partner.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_sap_customer
          IMPORTING
            output = lv_sap_customer.
      ENDIF.
      lst_e1edka1_233-partn  = lv_sap_customer.
      <lst_idoc_recrd>-sdata = lst_e1edka1_233.

      IF lst_e1edka1_233-parvw EQ 'AG'.
        lst_so_header-kunnr = lv_sap_customer.
        MOVE-CORRESPONDING lst_so_header TO dxvbak.
      ENDIF.

      READ TABLE dxvbadr ASSIGNING FIELD-SYMBOL(<lst_xvbadr_233_1>)
           WITH KEY ('PARVW') = lst_e1edka1_233-parvw.
      IF sy-subrc EQ 0.
        ASSIGN COMPONENT 'KUNNR' OF STRUCTURE <lst_xvbadr_233_1> TO <lv_field_value>.
        IF sy-subrc EQ 0.
          <lv_field_value> = lv_sap_customer.
        ENDIF.
      ELSE.
        APPEND INITIAL LINE TO dxvbadr ASSIGNING <lst_xvbadr_233_1>.
        ASSIGN COMPONENT 'PARVW' OF STRUCTURE <lst_xvbadr_233_1> TO <lv_field_value>.
        IF sy-subrc EQ 0.
          <lv_field_value> = lst_e1edka1_233-parvw.
        ENDIF.
        ASSIGN COMPONENT 'KUNNR' OF STRUCTURE <lst_xvbadr_233_1> TO <lv_field_value>.
        IF sy-subrc EQ 0.
          <lv_field_value> = lst_e1edka1_233-partn.
        ENDIF.
      ENDIF.
    ENDIF.

  WHEN 'E1EDP19'.
    MOVE-CORRESPONDING dxvbap TO lst_so_item_det.
    lv_jrnl3_2      = lst_so_item_det-matnr.
*   Calling FM to convert legacy material into SAP Material
    CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
      EXPORTING
        im_idcodetype      = lc_jrnl3_2
        im_legacy_material = lv_jrnl3_2
      IMPORTING
        ex_sap_material    = lst_so_item_det-matnr
      EXCEPTIONS
        wrong_input_values = 1
        OTHERS             = 2.
    IF sy-subrc = 0.
      MOVE-CORRESPONDING lst_so_item_det TO dxvbap.
    ENDIF. " IF sy-subrc = 0

ENDCASE.
