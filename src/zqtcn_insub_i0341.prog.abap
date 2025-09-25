*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INSUB_I0341 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Inbound Interface for Agent Subscription Renewal
* DEVELOPER: SAYANDAS ( Sayantan Das )
* CREATION DATE:   14/02/2017
* OBJECT ID: I0341
* TRANSPORT NUMBER(S):   ED2K904485
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K913048
* REFERENCE NO: ERP-7634
* DEVELOPER: Writtick Roy (WROY)
* DATE:  13-AUG-2018
* DESCRIPTION: Consider Reference# after removing leading zeros
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K909154
* REFERENCE NO: INC0223098
* DEVELOPER: NPALLA ( Nikhilesh Palla ) ED2K916111
* DATE:  18-Dec-2018
* DESCRIPTION: Fix to avoid internal session termination (TABLE_FREE_IN_LOOP)
*              And additional check for duplicate validation
*------------------------------------------------------------------- *
**************************************************************************
* REVISION NO: ED1K911128
* REFERENCE NO: INC0264018
* DEVELOPER: NRMODUGU ( NAGIREDDY MODUGU)
* DATE:  10-OCT-2019
* DESCRIPTION: Fixed to the sorting to pick up corrcet quoation instead old quotation.
*------------------------------------------------------------------- *
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916111/ED2K916473
* REFERENCE NO: ERPM1431
* DEVELOPER: NPOLINA( Nageswar)
* DATE:  13-Sept-2019
* DESCRIPTION: Determine Reference quote for Z10 IDOCs to create ZREW order
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K911474 / ED2K917139
* REFERENCE NO: ERPM1431
* DEVELOPER: NPALLA( Nikhilesh Palla)
* DATE:  23-Sept-2019
* DESCRIPTION: Fix to avoid shrotdump termination
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED1K911549
* REFERENCE NO:  ERPM1431
* DEVELOPER:     NPOLINA(Nageswara)
* DATE:          17-Jan-2020
* DESCRIPTION:   Clearing static variables
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K923781
* REFERENCE NO:  OTCM-42838
* DEVELOPER: Krishna Srikanth (Ksrikanth)
* DATE:  2021-06-15
* DESCRIPTION:  Added the logic to get the next business date & dispatch date.
*------------------------------------------------------------------- *
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INSUB_INDIAN_AGT_I0341 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Skiping the existing Include logic for Indain Agent
* DEVELOPER: VDPATABALL
* CREATION DATE:   12/14/2021
* OBJECT ID: OTCM-47818/51088 - I0341
* TRANSPORT NUMBER(S):   ED2K925253
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*------------------------------------------------------------------- *

*** Local Structure declaration for XVBAK
TYPES: BEGIN OF lty_xvbak9. "Kopfdaten
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
TYPES: END OF lty_xvbak9.

*** Local Structure declaration of XVBAP
*-------------------->>> XVBAP
TYPES: BEGIN OF lty_xvbap9. "Position
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
       END OF lty_xvbap9.

*** Local Structure declaration for XVBADR
TYPES: BEGIN OF lty_xvbadr9,     "Partner
         posnr LIKE vbap-posnr,  " Sales Document Item
         parvw LIKE vbpa-parvw,  " Partner Function
         kunnr LIKE rv02p-kunde, " Partner number (KUNNR, LIFNR, or PERNR)
         ablad LIKE vbpa-ablad,  " Unloading Point
         knref LIKE knvp-knref.  " Customer description of partner (plant, storage location)
         INCLUDE STRUCTURE vbadr. " Address work area
       TYPES: END OF lty_xvbadr9.
*   BOC CR#498: 01-JUL-2017 : SAYANDAS: ED2K907074
TYPES: BEGIN OF lty_vbeln_i0341,
         vbeln TYPE vbeln, " Sales and Distribution Document Number
         erdat TYPE erdat, " Date
         kunnr TYPE kunnr, " Customer Number
       END OF lty_vbeln_i0341.
*   EOC CR#498: 01-JUL-2017 : SAYANDAS: ED2K907074

** Local Structure Declaration
DATA:lst_xvbak9 TYPE lty_xvbak9,
     lst_xvbap9 TYPE lty_xvbap9.

** Local Structure Declaration for segments
DATA: lst_z1qtc_e1edka1_01_9 TYPE z1qtc_e1edka1_01, " Partner Information (Legacy Customer Number)
*   BOC CR#498: 01-JUL-2017 : SAYANDAS: ED2K907074
      lst_e1edka1_i0341      TYPE e1edka1, " IDoc: Document Header Partner Information
      lst_vbeln_i0341        TYPE lty_vbeln_i0341,
      lst_e1edk02_i0341      TYPE e1edk02, " IDoc: Document header reference data
      lst_e1edk14_i0341      TYPE e1edk14, " IDoc: Document Header Organizational Data
*   EOC CR#498: 01-JUL-2017 : SAYANDAS: ED2K907074
      lst_e1edk01_01_9       TYPE e1edk01. " Document header general data

*** Local Data Declaration
DATA: lv_partn9      TYPE bu_id_number, " Identification Number
      lv_zssn9       TYPE ismidentcode, " Identification Code
*   BOC CR#498: 01-JUL-2017 : SAYANDAS: ED2K907074
      lv_idoc_i0341  TYPE char30 VALUE '(SAPLVEDA)IDOC_DATA[]', " Idoc_i0341 of type CHAR30
      lv_idoc_status TYPE char30 VALUE '(SAPLVEDA)IDOC_STATUS[]', " Idoc_i0341 of type CHAR30
      lv_ihrez_i0341 TYPE ihrez,                                " Your Reference
      lv_vbeln_i0341 TYPE vbeln,                                " Sales and Distribution Document Number
      lv_sdata_temp  TYPE char13,                               " Sdata_temp of type CHAR13
      lv_tabix_i0341 TYPE sytabix,                              " Row Index of Internal Tables
*   EOC CR#498: 01-JUL-2017 : SAYANDAS: ED2K907074
      lv_tabix9      TYPE sytabix, " Row Index of Internal Tables

      lv_kunnr9      TYPE kunnr,   " Customer Number
*   BOC CR#498: 01-JUL-2017 : SAYANDAS: ED2K907074
      " Begin of ADD:OTCM-42838:KRISHNA:15-JUN-2021
      lv_msg12       TYPE string.
" End of ADD:OTCM-42838:KRISHNA:15-JUN-2021
FIELD-SYMBOLS:
  <li_idoc_rec_i0341>  TYPE edidd_tt,

  <li_idoc_rec_temp>   TYPE edidd_tt,
  <li_idoc_rec_temp1>  TYPE edidd_tt,
  <li_idoc_rec_n>      TYPE edidd_tt,                     "NPOLINA ERPM1431 11/Sep/2019 ED2K916111
  <lst_idoc_rec_i0341> TYPE edidd, " Data record (IDoc)
  <lst_idoc_rec_n>     TYPE edidd, " Data record (IDoc)   "NPOLINA ERPM1431 11/Sep/2019 ED2K916111
  <lst_idoc_rec_temp>  TYPE edidd, " Data record (IDoc)
  <lst_idoc_rec_temp1> TYPE edidd. " Data record (IDoc)
*   EOC CR#498: 01-JUL-2017 : SAYANDAS: ED2K907074

*** Local constant declaration
CONSTANTS: lc_ag9                TYPE parvw VALUE 'AG',                    " Partner Function
           lc_zssn9              TYPE ismidcodetype VALUE 'ZSSN',          " Type of Identification Code
           lc_z1qtc_e1edka1_01_9 TYPE edilsegtyp VALUE 'Z1QTC_E1EDKA1_01', " Segment type
           lc_e1edk01_9          TYPE edilsegtyp VALUE 'E1EDK01',          " Segment type
*   BOC CR#498: 01-JUL-2017 : SAYANDAS: ED2K907074
           lc_e1edka1_i0341      TYPE edilsegtyp VALUE 'E1EDKA1', " Segment type
           lc_e1edk02_i0341      TYPE edilsegtyp VALUE 'E1EDK02', " Segment type
           lc_e1edk14_i0341      TYPE edilsegtyp VALUE 'E1EDK14', " Segment type
           lc_b_i0341            TYPE vbtyp VALUE 'B',            " SD document category
           lc_004_i0341          TYPE edi_qualfr VALUE '004',     " IDOC qualifier reference document
           lc_011_i0341          TYPE edi_qualfr VALUE '011',     " IDOC qualifier reference document NPOLINA ERPM1431 ED2K916111
           lc_001_i0341          TYPE edi_qualfr VALUE '001',     " IDOC qualifier reference document
           lc_012_i0341          TYPE edi_qualfo VALUE '012',     " IDOC qualifer organization
           lc_002                TYPE edi_qualfo VALUE '002',     " IDOC qualifer organization       NPOLINA ERPM1431 ED2K916111
           lc_zrew_i0341         TYPE edi_orgid  VALUE 'ZREW',    " IDOC organization
*   BOC CR#498: 01-JUL-2017 : SAYANDAS: ED2K907074
           lc_e1edp19_9          TYPE edilsegtyp VALUE 'E1EDP19', " Segment type       "NPOLINA ERPM1431 ED2K916111
           lc_we9                TYPE parvw VALUE 'WE',                                "NPOLINA ERPM1431 ED2K916473
           lc_posnr_9            TYPE posnr VALUE '000000',                            "NPOLINA ERPM1431 ED2K916473
           lc_iag                TYPE char3 VALUE 'IAG'.                               "VDPATABALL  OTCM-47818 ED2K925253

*** Local field symbol declaration
FIELD-SYMBOLS: <lst_xvbadr_9> TYPE lty_xvbadr7.
*   BOC INC0223098: 18-Dec-2018 : NPALLA: ED1K909154
STATICS: lvs_idoc_num      TYPE edi_docnum,  "++ED1K909154
*   EOC INC0223098: 18-Dec-2018 : NPALLA: ED1K909154
* SOC by NPOLINA ERPM1431 11/Sep/2019 ED2K916111
         lr_doc_type_i0341 TYPE farric_rt_auart,
         lst_e1edka1_1     TYPE e1edka1,
         lst_e1edka1_9     TYPE e1edka1,          "ERP1431 NPOLINA ED2K916473
         lst_e1edp01       TYPE e1edp01,
         lv_subrc          TYPE sy-subrc,
         lst_e1edp19       TYPE e1edp19,
         lv_flag           TYPE char1,
         li_const_i0341    TYPE zcat_constants,
         lv_docnum_t5      TYPE edi_docnum.  " NPOLINA ERPM1431 ED1K911549
DATA:lv_idtnr TYPE edi_idtnr,
     lv_kunnr TYPE kunnr.
DATA:lv_idtnr2              TYPE edi_idtnr.
CONSTANTS:lc_devid_i0341  TYPE zdevid     VALUE 'I0341',        " Development ID: I0341
          lc_e1edp011     TYPE edilsegtyp VALUE 'E1EDP01',          " Segment type
          lc_document_typ TYPE rvari_vnam VALUE 'DOCUMENT_TYPE',    " Parameter: Document Type
          lc_renewal_sub  TYPE rvari_vnam VALUE 'RENEWAL_SUBS'.     " Parameter: Renewal Subscription

** SOC by NPOLINA ERPM1431 ED1K911549
IF lv_docnum_t5 NE contrl-docnum.
  FREE:lr_doc_type_i0341,lst_e1edka1_1,lst_e1edka1_9,
       lst_e1edp01,lv_subrc,lst_e1edp19,lv_flag,li_const_i0341,lv_docnum_t5.
  lv_docnum_t5 = contrl-docnum.
ENDIF.
* EOC by NPOLINA ERPM1431 ED1K911549
IF li_const_i0341 IS INITIAL.
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_i0341
    IMPORTING
      ex_constants = li_const_i0341.
  IF sy-subrc EQ 0.
    LOOP AT li_const_i0341 ASSIGNING FIELD-SYMBOL(<lst_const_i0341>).
      CASE <lst_const_i0341>-param1.
        WHEN lc_document_typ.
          CASE <lst_const_i0341>-param2.
            WHEN lc_renewal_sub.
              APPEND INITIAL LINE TO lr_doc_type_i0341 ASSIGNING FIELD-SYMBOL(<lst_doc_type_i0341>).
              <lst_doc_type_i0341>-sign   = <lst_const_i0341>-sign.
              <lst_doc_type_i0341>-option = <lst_const_i0341>-opti.
              <lst_doc_type_i0341>-low    = <lst_const_i0341>-low.
              <lst_doc_type_i0341>-high   = <lst_const_i0341>-high.

          ENDCASE.
      ENDCASE.
    ENDLOOP.
  ENDIF.
ENDIF.               "IF li_const_i0341 IS INITIAL.
* EOC by NPOLINA ERPM1431 11/Sep/2019 ED2K916111
IF contrl-mesfct NE lc_iag. "++ VDPATABALL OTCM-47818 ED2K925253 skip this line for Inbound Interface for Indain Agent
  CASE segment-segnam.
    WHEN lc_e1edk01_9.
      lst_e1edk01_01_9 = segment-sdata.
      IF lst_e1edk01_01_9-bsart IS NOT INITIAL.
        lst_xvbak9 = dxvbak.
        lst_xvbak9-bsark = lst_e1edk01_01_9-bsart.
        dxvbak = lst_xvbak9.

        lst_flag = dd_flag_k.
        lst_flag-kbes = abap_true.
        dd_flag_k = lst_flag.
      ENDIF. " IF lst_e1edk01_01_9-bsart IS NOT INITIAL

    WHEN lc_e1edk14_i0341.
      ASSIGN (lv_idoc_i0341) TO <li_idoc_rec_temp1>.

      READ TABLE <li_idoc_rec_temp1> ASSIGNING <lst_idoc_rec_temp1> WITH KEY segnam     = lc_e1edk14_i0341
                                                                             sdata+0(3) = lc_012_i0341.
      IF sy-subrc = 0.
*   BOC INC0223098: 18-Dec-2018 : NPALLA: ED1K909154
        IF lvs_idoc_num <> <lst_idoc_rec_temp1>-docnum.
          lvs_idoc_num = <lst_idoc_rec_temp1>-docnum.
*   EOC INC0223098: 18-Dec-2018 : NPALLA: ED1K909154
          lst_e1edk14_i0341 =  <lst_idoc_rec_temp1>-sdata.

          IF lst_e1edk14_i0341-orgid = lc_zrew_i0341.


*   BOC CR#498: 01-JUL-2017 : SAYANDAS: ED2K907074
            ASSIGN (lv_idoc_i0341) TO <li_idoc_rec_i0341>.

            LOOP AT <li_idoc_rec_i0341> ASSIGNING <lst_idoc_rec_i0341>
              WHERE segnam = lc_e1edka1_i0341.
*     Get the IDoc data into local work area to process further
              CLEAR lst_e1edka1_i0341.
              lst_e1edka1_i0341  = <lst_idoc_rec_i0341>-sdata.
              IF lst_e1edka1_i0341-parvw = lc_ag9 AND lst_e1edka1_i0341-ihrez IS NOT INITIAL.
                lv_ihrez_i0341 = lst_e1edka1_i0341-ihrez.
                " Begin of ADD:OTCM-42838:KRISHNA:15-JUN-2021
                DATA(lv_partn) = lst_e1edka1_i0341-partn.
                " End of ADD:OTCM-42838:KRISHNA:15-JUN-2021
**** Selecting Data to fetch Quotation Number
*   BOC INC0264018: 08-OCT-2019 : NRMODUGU: ED1K911128
*              SELECT vbkd~vbeln  " Sales and Distribution Document Number
                SELECT vbkd~vbeln, vbak~erdat," Sales and Distribution Document Number
*   EOC INC0264018: 08-OCT-2019 : NRMODUGU: ED1K911128
                " Begin of ADD:OTCM-42838:KRISHNA:15-JUN-2021
                       vbak~kunnr
                " End of ADD:OTCM-42838:KRISHNA:15-JUN-2021
                  FROM vbkd INNER JOIN vbak
                  ON vbkd~vbeln EQ vbak~vbeln
                  INTO TABLE @DATA(li_vbeln_quot)
                  WHERE vbkd~ihrez EQ @lv_ihrez_i0341
                  AND vbak~vbtyp EQ @lc_b_i0341. "#EC CI_SEL_NESTED    "#EC CI_SUBRC
*           Begin of ADD:ERP-7634:WROY:13-AUG-2018:ED2K913048
                IF sy-subrc NE 0.
*             Remove Leading Zeros
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                    EXPORTING
                      input  = lv_ihrez_i0341
                    IMPORTING
                      output = lv_ihrez_i0341.
*   BOC INC0264018: 08-OCT-2019 : NRMODUGU: ED1K911128
*                SELECT vbkd~vbeln  " Sales and Distribution Document Number
                  SELECT vbkd~vbeln, vbak~erdat" Sales and Distribution Document Number
*   EOC INC0264018: 08-OCT-2019 : NRMODUGU: ED1K911128
               " Begin of ADD:OTCM-42838:KRISHNA:15-JUN-2021
                          ,vbak~kunnr
               " End of ADD:OTCM-42838:KRISHNA:15-JUN-2021
                      FROM vbkd INNER JOIN vbak
                      ON vbkd~vbeln EQ vbak~vbeln
                      INTO TABLE @li_vbeln_quot
                      WHERE vbkd~ihrez EQ @lv_ihrez_i0341
                      AND vbak~vbtyp EQ @lc_b_i0341. "#EC CI_SEL_NESTED  "#EC CI_SUBRC
                ENDIF. " IF sy-subrc NE 0
*           End   of ADD:ERP-7634:WROY:13-AUG-2018:ED2K913048
              ENDIF. " IF lst_e1edka1_i0341-parvw = lc_ag9 AND lst_e1edka1_i0341-ihrez IS NOT INITIAL
            ENDLOOP. " LOOP AT <li_idoc_rec_i0341> ASSIGNING <lst_idoc_rec_i0341>
            IF li_vbeln_quot IS INITIAL. " No Quotation Number
              MESSAGE e222(zqtc_r2) RAISING user_error. " No Quotation Number Exists
            ELSE. " ELSE -> IF li_vbeln_quot IS INITIAL
*** Insert Quotation Number in E1EDK02 Segment
*   BOC INC0264018: 08-OCT-2019 : NRMODUGU: ED1K911128
              SORT li_vbeln_quot BY erdat DESCENDING.
*   EOC INC0264018: 08-OCT-2019 : NRMODUGU: ED1K911128
              READ TABLE li_vbeln_quot INTO lst_vbeln_i0341 INDEX 1.
              IF sy-subrc = 0.

                lv_vbeln_i0341 = lst_vbeln_i0341-vbeln.

                ASSIGN (lv_idoc_i0341) TO <li_idoc_rec_temp>.

                READ TABLE <li_idoc_rec_temp> ASSIGNING <lst_idoc_rec_temp> WITH KEY segnam     = lc_e1edk02_i0341
                                                                                     sdata+0(3) = lc_001_i0341.
                IF sy-subrc EQ 0.
                  lv_tabix_i0341 = sy-tabix + 1.
                  INSERT <lst_idoc_rec_temp> INTO <li_idoc_rec_temp> INDEX lv_tabix_i0341 .
                  UNASSIGN <lst_idoc_rec_temp>.
                ENDIF. " IF sy-subrc EQ 0

                LOOP AT <li_idoc_rec_temp> ASSIGNING <lst_idoc_rec_temp> FROM lv_tabix_i0341.
                  <lst_idoc_rec_temp>-segnum = <lst_idoc_rec_temp>-segnum + 1.
                  IF sy-tabix EQ lv_tabix_i0341 .
                    CONCATENATE lc_004_i0341 lv_vbeln_i0341 INTO lv_sdata_temp.
                    <lst_idoc_rec_temp>-sdata = lv_sdata_temp.
                  ENDIF. " IF sy-tabix EQ lv_tabix_i0341

                ENDLOOP. " LOOP AT <li_idoc_rec_temp> ASSIGNING <lst_idoc_rec_temp> FROM lv_tabix_i0341

                CLEAR : lv_tabix_i0341.
*   BOC ERPM1431: 23-Dec-2019 : NPALLA: ED1K911474
**   BOC INC0223098: 18-Dec-2018 : NPALLA: ED1K909154
*              MOVE-CORRESPONDING <li_idoc_rec_i0341> TO <li_idoc_rec_i0341>.  "--ED1K909154
**   EOC INC0223098: 18-Dec-2018 : NPALLA: ED1K909154F
                <li_idoc_rec_i0341> = <li_idoc_rec_temp>.  "++ED1K911474
*   EOC ERPM1431: 23-Dec-2019 : NPALLA: ED1K911474
                " Begin of ADD:OTCM-42838:KRISHNA:15-JUN-2021
                IF lv_partn NE lst_vbeln_i0341-kunnr.
                  MESSAGE e605(zqtc_r2) WITH lv_partn lst_vbeln_i0341-kunnr.
                ENDIF.
                " End of ADD:OTCM-42838:KRISHNA:15-JUN-2021
              ENDIF. " IF sy-subrc = 0

              UNASSIGN: <lst_idoc_rec_i0341>.
            ENDIF. " IF li_vbeln_quot IS INITIAL
          ENDIF. " IF lst_e1edk14_i0341-orgid = lc_zrew_i0341
*   BOC INC0223098: 18-Dec-2018 : NPALLA: ED1K909154
        ENDIF. " IF lvs_idoc_num <> <lst_idoc_rec_temp1>-docnum.
*   EOC INC0223098: 18-Dec-2018 : NPALLA: ED1K909154
      ENDIF. " IF sy-subrc = 0
*   EOC CR#498: 01-JUL-2017 : SAYANDAS: ED2K907074

    WHEN lc_z1qtc_e1edka1_01_9. " Segment for legacy customer
*** keeping the segment data in local work area
      lst_z1qtc_e1edka1_01_9 = segment-sdata.
      DESCRIBE TABLE dxvbadr LINES lv_tabix9.
*** Fetching partner information
      READ TABLE dxvbadr ASSIGNING <lst_xvbadr_9> INDEX lv_tabix9.
      IF <lst_xvbadr_9> IS ASSIGNED.
        lv_partn9 = lst_z1qtc_e1edka1_01_9-partner.
        lst_xvbak9 = dxvbak.
*** Calling FM to convert Customer
        CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_CUSTOMER'
          EXPORTING
            im_company_code    = lst_xvbak9-vkorg
            im_leg_customer    = lv_partn9
          IMPORTING
            ex_sap_customer    = lv_kunnr9
          EXCEPTIONS
            wrong_input_values = 1
            invalid_comp_code  = 2
            OTHERS             = 3.

        IF sy-subrc = 0 AND lv_kunnr9 IS NOT INITIAL.

          <lst_xvbadr_9>-kunnr = lv_kunnr9.
        ELSE. " ELSE -> IF sy-subrc = 0 AND lv_kunnr9 IS NOT INITIAL
          <lst_xvbadr_9>-kunnr = lv_partn9.
        ENDIF. " IF sy-subrc = 0 AND lv_kunnr9 IS NOT INITIAL
*** Checking the partner type and if it is 'AG' the
*** Inserting partner value in XVBAK structure
        IF <lst_xvbadr_9>-parvw = lc_ag9.
          lst_xvbak9 = dxvbak.
          lst_xvbak9-kunnr = <lst_xvbadr_9>-kunnr.
          dxvbak = lst_xvbak9.
        ENDIF. " IF <lst_xvbadr_9>-parvw = lc_ag9

      ENDIF. " IF <lst_xvbadr_9> IS ASSIGNED

*** If the segment is E1EDP19 then we are fetching material from it
*** and converting it
    WHEN lc_e1edp19_9.
*** Storing XVBAP in local work area
      lst_xvbap9 = dxvbap.
      lv_zssn9   = lst_xvbap9-matnr.
***** Calling FM to convert legacy material into SAP Material
      CALL FUNCTION 'ZRTR_DET_SAP_LEGACY_MATERIAL'
        EXPORTING
          im_idcodetype      = lc_zssn9
          im_legacy_material = lv_zssn9
        IMPORTING
          ex_sap_material    = lst_xvbap9-matnr
        EXCEPTIONS
          wrong_input_values = 1
          OTHERS             = 2.

      IF sy-subrc = 0.
        dxvbap = lst_xvbap9.
      ENDIF. " IF sy-subrc = 0

* SOC by NPOLINA ERPM1431 11/Sep/2019 ED2K916111
    WHEN lc_e1edka1_i0341.
      CLEAR : v_quote.
      ASSIGN (lv_idoc_i0341) TO <li_idoc_rec_n>.
      lst_e1edka1_1 = segment-sdata.                        " IDoc: Document Header Partner Information
      lst_xvbak9 = dxvbak.                               " Sales Document: Header Data
*--* Check document type
      IF lst_xvbak9-auart IN lr_doc_type_i0341 AND lv_flag IS INITIAL." AND 1 = 2.
        lv_flag = abap_true.
* Check E1EDP01-MENGE has Quantity from CLEO
        READ TABLE <li_idoc_rec_n> ASSIGNING FIELD-SYMBOL(<lst_idocp01>) WITH KEY segnam     = lc_e1edp011.
        IF sy-subrc EQ 0.
          lst_e1edp01 = <lst_idocp01>-sdata.
          IF lst_e1edp01-menge IS INITIAL.
            MESSAGE e315(zqtc_r2) RAISING user_error. " Quantity Missing in IDOC
          ENDIF.
        ENDIF.

* Logic to identify Quotation
* Read Reference from IDOC Sold-to segment
        READ TABLE <li_idoc_rec_n> ASSIGNING FIELD-SYMBOL(<lst_idocn>) WITH KEY segnam     = lc_e1edka1_i0341
                                                                                    sdata+0(2) = lc_ag9.
        IF sy-subrc EQ 0.
          lst_e1edka1_1 = <lst_idocn>-sdata.
* Read Materal from IDOC
          READ TABLE <li_idoc_rec_n> ASSIGNING FIELD-SYMBOL(<lst_idoc19>) WITH KEY segnam     = lc_e1edp19_9
                                                                                      sdata+0(3) = lc_002.
          IF sy-subrc EQ 0.
            lst_e1edp19 = <lst_idoc19>-sdata.
            IF lst_e1edp19-idtnr IS NOT INITIAL.
*--*Call FM to get right quote number
              CALL FUNCTION 'ZQTC_FIND_QUOTE_I0341'
                EXPORTING
                  im_ihrez = lst_e1edka1_1-ihrez
                  im_matnr = lst_e1edp19-idtnr
                IMPORTING
                  ex_quote = v_quote
                  ex_matnr = lv_idtnr
                  ex_kunnr = lv_kunnr.

              IF v_quote IS NOT INITIAL AND v_quote NE abap_true .    "Quote exist for Reference and Material
                READ TABLE <li_idoc_rec_n> ASSIGNING FIELD-SYMBOL(<lst_idoc_rec_k02>)
                            WITH KEY segnam   = lc_e1edk02_i0341
                                     sdata(3) = lc_004_i0341.
                IF sy-subrc EQ 0.
                  lst_e1edk02_i0341 = <lst_idoc_rec_k02>-sdata.       " IDoc: Document header reference data
                  lst_e1edk02_i0341-belnr = v_quote.
                  <lst_idoc_rec_k02>-sdata = lst_e1edk02_i0341.
                ENDIF.
* SOC by NPOLINA ERP1431 ED2K916473 18/Oct/2019
                SELECT SINGLE kunnr FROM vbpa INTO @DATA(lv_kunnr_we)
                   WHERE vbeln = @v_quote
                    AND posnr = @lc_posnr_9
                    AND parvw = @lc_we9.
                IF sy-subrc EQ 0 AND lv_kunnr_we IS NOT INITIAL.

* Read  IDOC Segement for Ship-to and update with Reference quote Ship to
                  READ TABLE <li_idoc_rec_n> ASSIGNING FIELD-SYMBOL(<lst_idocn_we>) WITH KEY segnam     = lc_e1edka1_i0341
                                                                                                sdata+0(2) = lc_we9.
                  IF sy-subrc EQ 0.
                    lst_e1edka1_9 = <lst_idocn_we>-sdata.
                    lst_e1edka1_9-partn = lv_kunnr_we.
                    <lst_idocn_we>-sdata = lst_e1edka1_9.
                  ENDIF.
                ENDIF.
* EOC by NPOLINA ERP1431 ED2K916473 18/Oct/2019

                IF  lst_e1edp19-idtnr EQ lv_idtnr OR lst_e1edp19-idtnr EQ lv_idtnr2 .
* Remove Material from CLEO where same material in Quote and IDOC
                  DELETE <li_idoc_rec_n> WHERE segnum = <lst_idoc19>-segnum.

* Clear E1EDP01-MENGE has Quantity from CLEO where same material in Quote and IDOC
                  READ TABLE <li_idoc_rec_n> ASSIGNING FIELD-SYMBOL(<lst_idocp011>) WITH KEY segnam     = lc_e1edp011.
                  IF sy-subrc EQ 0.
                    CLEAR: <lst_idocp011>-sdata.

                  ENDIF.

                ENDIF.
              ELSEIF v_quote IS NOT INITIAL AND v_quote EQ abap_true. "Quote NOT exist for Reference and Material
                MESSAGE e316(zqtc_r2) RAISING user_error.             " No Quotation Number Exists
              ELSE.
* No Quotation found, then create ZREW without Reference
                READ TABLE <li_idoc_rec_n> ASSIGNING FIELD-SYMBOL(<lst_idoc_rec_k021>)
                            WITH KEY segnam   = lc_e1edk02_i0341
                                     sdata(3) = lc_004_i0341.
                IF sy-subrc EQ 0.
                  CLEAR:<lst_idoc_rec_k021>-sdata.
                ENDIF.

                IF lv_kunnr IS NOT INITIAL.
* Read  IDOC Segement for Ship-to and update with Reference quote Ship to
                  READ TABLE <li_idoc_rec_n> ASSIGNING FIELD-SYMBOL(<lst_idocn_we1>) WITH KEY segnam     = lc_e1edka1_i0341
                                                                                                sdata+0(2) = lc_we9.
                  IF sy-subrc EQ 0.
                    lst_e1edka1_9 = <lst_idocn_we1>-sdata.
                    lst_e1edka1_9-partn = lv_kunnr.
                    <lst_idocn_we1>-sdata = lst_e1edka1_9.
                  ENDIF.
                ENDIF.
              ENDIF.                                                 "V_Quote not initial
            ENDIF.                                                  "IF lst_e1edp19-idtnr is not initial
          ENDIF.                                                   " IF sy-subrc eq 0
        ENDIF.
      ENDIF.                       " Check document type
* EOC by NPOLINA ERPM1431 11/Sep/2019 ED2K916111
  ENDCASE.
ENDIF. "IF contrl-mesfct NE lc_iag."++ VDPATABALL OTCM-47818 ED2K925253 skip this line for Inbound Interface for Indain Agent
