*---------------------------------------------------------------------*
*       FORM VBAK_KOPIEREN                                            *
*---------------------------------------------------------------------*
*       Kopieren eines Kopfes aus Referenz                            *
*---------------------------------------------------------------------*
FORM vbak_kopieren.

  LOCAL: vbak-vbeln,
         vbak-knumv.

  DATA: da_edatu LIKE vbak-vdatu,
        da_ezeit LIKE vbep-ezeit,
        da_cmeng LIKE vbep-cmeng,
        da_menge LIKE vbep-wmeng VALUE 1,
        da_bstkd LIKE vbkd-bstkd.

* ISSWDHU D14 - Record Sales Area
*ENHANCEMENT-POINT VBAK_KOPIEREN_01 SPOTS ES_SAPFV45C STATIC.

*ENHANCEMENT-POINT VBAK_KOPIEREN_02 SPOTS ES_SAPFV45C.
  DATA: l_sd_sales_basic_exit TYPE REF TO if_ex_badi_sd_sales_basic,
            active TYPE xfeld.

  modul-suff = tvcpa-gruak.
  IF modul-suff = 0.
    MESSAGE a472 WITH 'VBAK'.
  ENDIF.

* Wenn Bestellnummer eingegeben wurde soll diese erhalten bleiben
* (Änderung zu 4.0 Bestellnummer von VBAK in VBKD)
  da_bstkd = vbkd-bstkd.

*ENHANCEMENT-POINT VBAK_KOPIEREN_10 SPOTS ES_SAPFV45C.
  IF rv45a-kedatu > 0.
* Wenn ein Vorschlagsdatum eingegeben wurde, zieht dieses
    cvbak-vdatu = rv45a-kedatu.
    cvbak-vprgr = rv45a-kprgrs.
  ENDIF.

* bei MAIS-Abwicklung Abholdatum setzen, wenn Tagestermin eingegeben
* wurde
  IF cvbak-vbklt EQ vbklt_lp_ausl_auft AND
     NOT tvak-vbklt EQ vbklt_ausl_auft_korr.
    IF NOT rv45a-abhod IS INITIAL.
      cvbak-vdatu = rv45a-abhod.
      cvbak-vprgr = char1.
      rv45a-kedatu = rv45a-abhod.
      rv45a-kprgrs = char1.
    ENDIF.
    cvbak-abhod = rv45a-abhod.
    cvbak-abhov = rv45a-abhov.
    cvbak-abhob = rv45a-abhob.
* Vorschlagszeit setzten aus Abholzeit
    IF NOT rv45a-abhov IS INITIAL.
      cvbak-vzeit = rv45a-abhov.
    ENDIF.
  ENDIF.

* Erste Rechnungsposition bereitstellen
  READ TABLE cvbrp INDEX 1.
  IF sy-subrc > 0.
    CLEAR cvbrp.
  ENDIF.
* Belegkopf erzeugen
  PERFORM vbak_bearbeiten_vorbereiten(sapfv45k).
  IF cvbrk-vbeln IS INITIAL.
    vbak-vgbel = cvbak-vbeln.
    vbak-vgtyp = cvbak-vbtyp.
    vbak-vkorg = cvbak-vkorg.
    vbak-vtweg = cvbak-vtweg.
    vbak-spart = cvbak-spart.
  ELSE.
    vbak-vgbel = cvbrk-vbeln.
    vbak-vgtyp = cvbrk-vbtyp.
    vbak-vkorg = cvbrk-vkorg.
    vbak-vtweg = cvbrk-vtweg.
    vbak-spart = cvbrk-spart.
  ENDIF.
*ENHANCEMENT-POINT VBAK_KOPIEREN_03 SPOTS ES_SAPFV45C.
* Cross-Selling-Profil zum Auftraggeber ermitteln
  PERFORM cross_sell_ermitteln(sapmv45a).
  vbkd-bstkd = da_bstkd.
  PERFORM vbak_fuellen(sapfv45k).
  PERFORM (modul) IN PROGRAM sapfv45c.

  IF cl_ops_switch_check=>sd_sfws_sc4( ) EQ abap_true.
    IF vbak-sppaym EQ cv_sppaym01.
*   Payment Service Provider
      CLEAR vbak-sppaym.
    ENDIF.
  ENDIF.

* Call SD Sales BAdI
  CALL FUNCTION 'GET_HANDLE_SD_SALES_BASIC'
    IMPORTING
      handle = l_sd_sales_basic_exit
      active = active.

  IF active = charx.
    CALL METHOD l_sd_sales_basic_exit->header_copy
      EXPORTING
        fcvbrk = cvbrk
        ftvak  = tvak
        frv45a = rv45a
        fcvbak = cvbak
        fcvbkd = cvbkd[]
      CHANGING
        fvbak  = vbak
        fvbkd  = vbkd.
  ENDIF.

  IF NOT cvbak-vbklt EQ vbklt_lp_ausl_auft.
* Anliefertermin prüfen ggf. I-Message ausgeben (nicht bei MAIS)
    PERFORM anliefertermin_pruefen(sapfv45e) USING cvbak-vprgr
                                                   cvbak-vdatu
                                                   da_ezeit
                                                   da_cmeng
                                                   da_menge
                                                   charx
                                                   da_edatu
                                                   da_ezeit
                                                   sy-subrc.
  ENDIF.

* Damit per move-corresponding nichts kaputt gehen kann
  IF cvbrk-vbeln IS INITIAL.
    vbak-vgbel = cvbak-vbeln.
    vbak-vgtyp = cvbak-vbtyp.
  ELSE.
    vbak-vgbel = cvbrk-vbeln.
    vbak-vgtyp = cvbrk-vbtyp.
  ENDIF.
  CLEAR vbak-netwr.
* Kaufmännische Daten erzeugen
  PERFORM vbkd_kopieren_kopf.
* EURO - Zusatzfunktionen 3 performs
* perform vbak-waerk_ermitteln(sapfv45k).
* perform vbkd-kursk_fuellen(sapfv45k).
* perform vbkd-stcur_ermitteln(sapfv45k).

* Vertragsdaten erzeugen.
*ENHANCEMENT-SECTION     VBAK_KOPIEREN_11 SPOTS ES_SAPFV45C.
  IF NOT tvak-vterl IS INITIAL.
*   VEDA nur kopieren, wenn VTERL in Quelle und Ziel aktiv ist
*    PERFORM veda_kopieren_kopf USING cvbak-vbeln. "Prabhu
  ENDIF.
*END-ENHANCEMENT-SECTION.
* Kopffakturierungsplan kopieren
  IF cvbrk-vbeln IS INITIAL.
*    PERFORM fpla_kopieren_kopf.  "Prabhu
  ENDIF.
* Belegfluß für Belegkopf erzeugen.
  PERFORM vbak_bearbeiten(sapfv45k).
*  IF NOT da_kfplnr IS INITIAL.
**   Erzeugen Kopffakturierungsplan
*    PERFORM fplan_kopf_aktualisieren_call(sapmv45a)
*      USING charx.
*  ENDIF.
* Header created, but *VBAK is empty, so we build it again
  PERFORM vbak_bearbeiten_vorbereiten(sapfv45k).

  IF cl_fagl_switch_check=>fagl_fin_reorg_prctr_rs( ) = 'X'.
* Reorg Profit-Center
    STATICS: lv_fagl_vbeln LIKE vbak-vbeln.
    IF NOT cvbrk-vbeln IS INITIAL.
      IF cvbrk-vbeln NE lv_fagl_vbeln.
        lv_fagl_vbeln = cvbrk-vbeln.
        SELECT * FROM fagl_r_sdlog_001
                 INTO TABLE gt_fagl_r_sd_log
                 WHERE vbeln EQ cvbrk-vbeln
                 ORDER BY PRIMARY KEY.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                    "VBAK_KOPIEREN
