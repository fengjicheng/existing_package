*---------------------------------------------------------------------*
*PROGRAM NAME : ZQTCN_ITAB_FILL_I0395_1 (Include Program)           *
*REVISION NO :  ED2K919818                                            *
*REFERENCE NO:  OTCM-28269                                             *
*DEVELOPER  :  Lahiru Wathudura (LWATHUDURA)                          *
*WRICEF ID  :  I0395.1                                                *
*DATE       :  01/14/2021                                             *
*DESCRIPTION:  Change Order cancellation Process                      *
*---------------------------------------------------------------------*

*** Local types Declaration for VBAK
TYPES: BEGIN OF ty_xvbak_i0395_1. "Kopfdaten
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
       END OF ty_xvbak_i0395_1.

TYPES: BEGIN OF ty_xvbap_i0395_1. "Position
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
       END OF ty_xvbap_i0395_1.

DATA : lst_xvbak_i0395_1            TYPE ty_xvbak_i0395_1,  " Standard structure for vbak runtime data.
       lst_e1edk01_i0395_1          TYPE e1edk01,           " IDoc: Document header general data
       lst_xvbap_i0395_1            TYPE ty_xvbap_i0395_1,  " standard structure for vbap runtime data
       lst_e1edp01_i0395_1          TYPE e1edp01,           " IDoc: Document item data
       lst_control_data_z27_i0395_1 TYPE edidc.

CONSTANTS : lc_e1edk01_i0395_1 TYPE edi_segnam VALUE 'E1EDK01',
            lc_e1edp01_i0395_1 TYPE edi_segnam VALUE 'E1EDP01'.

STATICS : lv_vbeln_z27_i0395_1  TYPE vbeln_va,     " Sales document number
          lv_docnum_z27_i0395_1 TYPE edi_docnum.   " Idoc Number

FIELD-SYMBOLS: <li_idoc_rec_z27_i0395_1>  TYPE edidd_tt.


lst_control_data_z27_i0395_1 = contrl.

*---Static Variable clearing based on DOCNUM field (IDOC Number)..
IF lst_control_data_z27_i0395_1 IS NOT INITIAL.
  IF lv_docnum_z27_i0395_1 NE lst_control_data_z27_i0395_1-docnum.
    FREE:lv_docnum_z27_i0395_1 , lv_vbeln_z27_i0395_1.
    lv_docnum_z27_i0395_1  =  lst_control_data_z27_i0395_1-docnum.
  ENDIF.
ENDIF.

" Check the required segment and continue the logic
CASE segment-segnam.

  WHEN lc_e1edk01_i0395_1.                                    " IDoc: Document header general data

    lst_e1edk01_i0395_1 = segment-sdata.
    lst_xvbak_i0395_1-vbeln = lst_e1edk01_i0395_1-belnr.      " Sales document number Assignment
    lv_vbeln_z27_i0395_1  = lst_e1edk01_i0395_1-belnr.
    dxvbak = lst_xvbak_i0395_1.

  WHEN lc_e1edp01_i0395_1.                                    " Idoc Item general data

    lst_e1edp01_i0395_1 = segment-sdata.
    lst_xvbap_i0395_1 = dxvbap.                               " Storing XVBAP in local work area

    IF lst_e1edp01_i0395_1-posex IS NOT INITIAL.
      " Fetch actual matnr and posex value by passing the order no and line item
      SELECT SINGLE matnr, posex
        FROM vbap INTO @DATA(lv_vbap_z27_i0395_1)
        WHERE vbeln = @lv_vbeln_z27_i0395_1  AND
              posnr = @lst_e1edp01_i0395_1-posex.
      IF sy-subrc = 0.
        lst_xvbap_i0395_1-matnr = lv_vbap_z27_i0395_1-matnr.
        lst_xvbap_i0395_1-posex = lv_vbap_z27_i0395_1-posex.
      ENDIF.
      dxvbap = lst_xvbap_i0395_1.

    ELSE.  " Line item is blank Idoc should be failed.
      MESSAGE e588(zqtc_r2) RAISING user_error.
    ENDIF.

  WHEN OTHERS.
    " No action required.
ENDCASE.
