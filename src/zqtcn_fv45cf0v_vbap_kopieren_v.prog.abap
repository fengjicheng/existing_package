*----------------------------------------------------------------------*
*   INCLUDE FV45CF0V_VBAP_KOPIEREN_VORBERE                             *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  VBAP_KOPIEREN_VORBEREITEN
*&---------------------------------------------------------------------*
*       Vorbereiten des Kopierens für VBAP und VBKD
*       Wird auch bei VBAP_KOPIEREN_PRUEFEN verwendet
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM VBAP_KOPIEREN_VORBEREITEN USING US_POSNR
                                     US_VGTYP
                                     US_VGBEL
                                     US_VGPOS
                                     US_VGREF
                                     US_CHECK_ONLY.

  DATA: L_SD_SALES_ITEM_EXIT TYPE REF TO IF_EX_BADI_SD_SALES_ITEM,
        ACTIVE TYPE XFELD.
*ENHANCEMENT-SECTION     VBAP_KOPIEREN_VORBEREITEN_01 SPOTS ES_SAPFV45C.
  CLEAR VBAP.
*END-ENHANCEMENT-SECTION.
  MODUL-SUFF = TVCPA-GRUAP.
  IF MODUL-SUFF = 0.
    MESSAGE A472 WITH 'VBAP'.
  ENDIF.

* Belegposition erzeugen
  SVBAP-TABIX = 0.
*ENHANCEMENT-SECTION     VBAP_KOPIEREN_VORBEREITEN_02 SPOTS ES_SAPFV45C.
* Position und kaufmänn. Daten vorbereiten
  PERFORM VBAP_BEARBEITEN_VORBEREITEN(SAPFV45P).
* Keine Textfindung im Kopieren_Pruefen
  IF US_CHECK_ONLY NE SPACE.
    NO_TEXT_COPY-CHECK = CHARX.
  ENDIF.

  PERFORM VBAP_FUSSZEILE_FUELLEN_VORLAGE.
*END-ENHANCEMENT-SECTION.

  IF US_CHECK_ONLY NE SPACE.
    VBAP_MATNR_LOE    = VBAP-MATNR. " Keine Hinweise auf
    VBAP_WERKS_LOE    = VBAP-WERKS. " Löschvormerkung
  ENDIF.

* Referenznummer übernehmen, vor FUELLEN wegen Textübernahme
* Die VG-Felder wurden vor dem Umschlüsseln der Positionsnummern
* gesetzt
  VBAP-VGTYP = US_VGTYP.
  VBAP-VGBEL = US_VGBEL.
  VBAP-VGPOS = US_VGPOS.
  VBAP-VGREF = US_VGREF.
  PERFORM VBAP_FUELLEN(SAPFV45P).
* Positionsdaten kopieren
  PERFORM VBAP_COPY_DATA_STANDARD.
  PERFORM (MODUL) IN PROGRAM SAPFV45C.

  IF CL_FAGL_SWITCH_CHECK=>FAGL_FIN_REORG_PRCTR_RS( ) = 'X'.
* Reorg Profit-Center
    IF NOT CVBRK-VBELN IS INITIAL.
      DATA: LD_VBELN LIKE VBAP-VBELN,
            LD_POSNR LIKE VBAP-POSNR.

      CLEAR GT_FAGL_R_SD_LOG.
* Invoice correction
      IF NOT CVBRP-RKCOP IS INITIAL.
        LD_VBELN = CVBRP-RKBEL.
        LD_POSNR = CVBRP-RKPOS.
      ELSE.
        LD_VBELN = CVBRP-VBELN.
        LD_POSNR = CVBRP-POSNR.
      ENDIF.

      READ TABLE GT_FAGL_R_SD_LOG WITH KEY
                                 VBELN = LD_VBELN
                                 POSNR = LD_POSNR
                                 BINARY SEARCH.

      IF VBAP-PRCTR IS NOT INITIAL.
* "Normal" billing or intercompany billing
        IF GT_FAGL_R_SD_LOG-SO_PRCTR IS NOT INITIAL.
          VBAP-PRCTR = GT_FAGL_R_SD_LOG-SO_PRCTR.
        ENDIF.
* Customer billing document in cross company process
        IF CVBRK-VBTYP NA '56'.
          IF GT_FAGL_R_SD_LOG-SO_PCTRF IS NOT INITIAL.
            VBAP-PCTRF = GT_FAGL_R_SD_LOG-SO_PCTRF.
          ENDIF.
        ENDIF.
* Possibly new determination of the profitability segment
        IF VBAP-PAOBJNR IS NOT INITIAL AND
          VBAP-PRCTR NE CVBRP-PRCTR.                    " new PRCTR ?
          DATA: LD_KOKRS    LIKE COBL-KOKRS,
                LD_PAOBJNR  LIKE VBAP-PAOBJNR,
                LS_COPADATA TYPE COPADATA,
                LT_COPADATA TYPE TABLE OF COPADATA.

          CALL FUNCTION 'COPA_ERKRS_FIND'
            EXPORTING
              BUKRS              = VBAK-BUKRS_VF
              GSBER              = VBAP-GSBER
            IMPORTING
              KOKRS              = LD_KOKRS
            EXCEPTIONS
              ERROR_KOKRS_FIND   = 01
              NO_ERKRS_DEFINED   = 02
              NO_ERKRS_FOR_KOKRS = 03
              ERROR_MESSAGE      = 04
              OTHERS             = 05.

          IF SY-SUBRC IS INITIAL.
            CLEAR LT_COPADATA.
            LS_COPADATA-FNAM = 'PRCTR'.
            LS_COPADATA-FVAL = VBAP-PRCTR.
            INSERT LS_COPADATA INTO TABLE LT_COPADATA.

            CALL FUNCTION 'RKE_EXCHANGE_ACCTNR'
              EXPORTING
                I_KOKRS            = LD_KOKRS
                I_ACCTNR           = VBAP-PAOBJNR
                DO_DERIVATION      = 'R'
                CHECK_ORG_ELEMENTS = ABAP_TRUE
                I_DATUM            = SY-DATUM
              IMPORTING
                E_ACCTNR           = LD_PAOBJNR
              TABLES
                T_COPADATA         = LT_COPADATA
              EXCEPTIONS
                NO_ERKRS_FOUND     = 1
                ACCTNR_NOT_FOUND   = 2
                DERIVATION_ERROR   = 3
                ORG_ELEMENTS_ERROR = 4.

            IF SY-SUBRC IS INITIAL..
              VBAP-PAOBJNR = LD_PAOBJNR.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

  perform vbap_copy_logic.

* Call SD Sales BAdI
  CALL FUNCTION 'GET_HANDLE_SD_SALES_ITEM'
    IMPORTING
      HANDLE = L_SD_SALES_ITEM_EXIT
      ACTIVE = ACTIVE.
  IF ACTIVE = CHARX.
    CALL METHOD L_SD_SALES_ITEM_EXIT->ITEM_COPY
      EXPORTING
        F_TVCPA    = TVCPA
        FCVBAP     = CVBAP[]
        FCVBKD     = CVBKD[]
        FVBAK      = VBAK
        FCVBAK     = CVBAK
        check_only = US_CHECK_ONLY
      CHANGING
        FVBAP      = VBAP
        FVBKD      = VBKD.
  ENDIF.

  VBAP-VBELN = VBAK-VBELN.
  VBAP-POSNR = US_POSNR.
* Referenzdaten nochmal übernehmen, weil sie sonst in der
* Datenübernahmeroutine kaputt gemacht werden können
  VBAP-VGTYP = US_VGTYP.
  VBAP-VGBEL = US_VGBEL.
  VBAP-VGPOS = US_VGPOS.
  VBAP-VGREF = US_VGREF.
* Kennzeichen Vollreferenz
*  VBAP-VOREF = *TVCPA-VOREF.
* Update Belegfuss
  VBAP-UPFLU = TVCPA-UPFLU.
* kaufmännische Daten kopieren
  MODUL-SUFF = TVCPA-GRUKD.
  IF MODUL-SUFF = 0.
    MESSAGE A472 WITH 'VBKD'.
  ENDIF.
* Bei Bezug Faktura werden die kaufm. Daten aus der Rechnung übernommen
  IF CVBRK-VBELN IS INITIAL.
    PERFORM CVBKD_LESEN_VORLAGE.
  ENDIF.
  SVBKD-TABIX = 0.
  PERFORM VBKD_COPY_DATA_STANDARD USING VBAP-POSNR.
  PERFORM (MODUL) IN PROGRAM SAPFV45C.

* EURO - Zusatzfunktionen 2 performs
* perform vbkd-kursk_fuellen(sapfv45k).
* perform vbkd-stcur_ermitteln(sapfv45k).

  VBKD-VBELN = VBAK-VBELN.
  VBKD-POSNR = POSNR_LOW.

ENDFORM.                    " VBAP_KOPIEREN_VORBEREITEN
