*---------------------------------------------------------------------*
*       FORM VBRP_KOPIEREN_PRUEFEN                                    *
*---------------------------------------------------------------------*
*       Prüfen, ob eine Position kopiert werden kann                  *
*---------------------------------------------------------------------*
FORM vbrp_kopieren_pruefen.

  DATA: da_vrgng LIKE tj01-vrgng.
  DATA: da_subrc  LIKE sy-subrc.
* Für Aufruf von VBAP_PRUEFEN
  DATA: BEGIN OF da_messages OCCURS 0.
          INCLUDE STRUCTURE bapireturn1.
  DATA: END OF da_messages.
  DATA: SAVE_*VBAP_WAERK LIKE VBAP-WAERK.

***** DSEG *****
  CALL FUNCTION 'J_1BSA_COMPONENT_ACTIVE'
         EXPORTING
              BUKRS                = CVBRK-BUKRS
              COMPONENT            = 'BR'
         EXCEPTIONS
              COMPONENT_NOT_ACTIVE = 02.
  IF SY-SUBRC = 0.
* Brasilien: Kopieren aus Faktura nur dann, wenn diese bereits gedruckt
  CALL FUNCTION 'J_1B_SD_SA_CHECK_COPY'
       EXPORTING
            i_vbrk = cvbrk
            i_tvak = tvak.
  ENDIF.
****** DSEG *****

* Alle: Schleife über Positionen
  LOOP AT cvbrp WHERE updkz NE updkz_delete.
    CLEAR CVBAP.
    SAVE_*VBAP_WAERK = *VBAP-WAERK.
    CLEAR *VBAP.
    *VBAP-WAERK = SAVE_*VBAP_WAERK.
*   Ergebnisobjekt darf nicht kopiert werden
    CLEAR cvbrp-paobjnr.

*   Bei intercompany müssen die Kontierungen richtiggestellt werden "Prabhu
*    PERFORM VBAP_INTERCOMPANY_PRUEFEN USING    CVBRP-WERKS
*                                               CVBRP-GSBER
*                                               CVBRP-AUBEL
*                                               CVBRP-AUPOS
*                                               CVBRK-BUKRS
*                                      CHANGING CVBRP-PRCTR
*                                               cvbrp-pctrf
*                                               CVBRP-PS_PSP_PNR
*                                               CVBRP-AUFNR
*                                               CVBRP-GSBER.


    PERFORM tvcpa_select(sapmv45a) USING vbak-auart
                                         cvbak-auart
                                         cvbrk-fkart
                                         cvbrp-pstyv
                                         space
                                         space
                                         sy-subrc.
* Eintrag nicht da -> nicht kopieren
    IF sy-subrc NE 0.
      DELETE cvbrp.
      MESSAGE i473 WITH vbak-auart cvbrk-fkart cvbrp-pstyv space.
      MESSAGE i476 WITH cvbrp-posnr.
    ELSE.
      IF CVBRP-UEPVW EQ CHARA.
         CLEAR CVBRP-UEPVW.
      ENDIF.
* Kopierbedingung der Position prüfen
      IF tvcpa-grbed > 0.
        PERFORM xvbup_lesen(sapfv45p) USING cvbrp-vbeln
                                            cvbrp-posnr.
        vbup = xvbup.
        vbrp = cvbrp.
        CALL FUNCTION 'RV_DOCUMENT_COPY_ITEM_CHECK'
             EXPORTING
                  fvcpa          = tvcpa
                  fvbup          = vbup
                  fvbap          = vbap
                  fvbrp          = vbrp
             EXCEPTIONS
                  nicht_kopieren = 1.
        IF sy-subrc NE 0.
          DELETE cvbrp.
          CHECK 1 = 0.                 " Nächste Position
        ENDIF.
      ENDIF.

* Einzelfertigung: Status pruefen
      IF NOT cvbrp-vbelv IS INITIAL.
        CALL FUNCTION 'SD_ACTIVITY_DETERMINE'
             EXPORTING
                  i_document_type = vbak-vbtyp
             IMPORTING
                  e_activity      = da_vrgng.
        CALL FUNCTION 'SD_DOCUMENT_ACCOUNT_ASSIGNMENT'
             EXPORTING
                  i_document_number = cvbrp-vbelv
                  i_item_number     = cvbrp-posnv
                  i_ps_psp_pnr      = cvbrp-ps_psp_pnr
                  i_vrgng           = da_vrgng
             EXCEPTIONS
                  error_message     = 1
                  OTHERS            = 2.
        IF sy-subrc > 0.
          IF sy-subrc = 2.
            MESSAGE ID sy-msgid TYPE chari NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.
          MESSAGE i476 WITH cvbrp-posnr.
          DELETE cvbrp.
          CHECK 1 = 0.                 " Nächste Position
        ENDIF.
      ENDIF.

      gewicht_kopiert = space.
      MOVE-CORRESPONDING cvbrp TO cvbap.
      cvbap-zieme = cvbap-vrkme.
      cvbap-umziz = cvbap-umvkz.
      cvbap-umzin = cvbap-umvkn.
      PERFORM tvap_select(sapmv45a) USING cvbrp-pstyn
                                          space
                                          sy-subrc.
      IF sy-subrc NE 0.
        MESSAGE a478 WITH cvbrp-pstyn.
      ENDIF.

* sonst hat die Konfiguration, die durch VBAP_KOPIEREN, VBAP_BEARBEITEN
* aufgerufen wird keine Menge
      IF NOT cvbrp-cuobj IS INITIAL.
        cvbap-orfmng = cvbrp-fkimg.
      ENDIF.

* Für eine einheitliche Fußzeilenprüfung wird CVBAP temporär gefüllt
* Zurück kommt der Vorschlagspositionstyp
      PERFORM cvbap_fusszeile_pruefen USING sy-subrc.
      IF sy-subrc NE 0.
        DELETE cvbrp.
        MESSAGE i476 WITH cvbrp-posnr.
        continue.
      ELSE.
        cvbrp-pstyn = cvbap-pstyn.
        MODIFY cvbrp.
      ENDIF.

*   Beim Kopieren von Unterpositionen kann das Kopieren nicht simuliert
*   werden, da die XVBAP nicht mit der Hauptposition gefüllt ist
      IF cvbrp-uepos IS INITIAL.
        PERFORM vbap_kopieren_vorbereiten USING cvbrp-posnr
                                                cvbrk-vbtyp
                                                cvbrp-vgbel
                                                cvbrp-vgpos
                                                charx  " Immer Vorgänger
                                                charx. " Check Only

* Prüfen der zu erzeugenden Position
      PERFORM vbap_pruefen(sapfv45p) TABLES da_messages
                                     USING  space
                                     CHANGING da_subrc.

      IF da_subrc > 0.
        MESSAGE i476 WITH cvbrp-posnr.
        DELETE cvbrp.
        CONTINUE.                      " Nächste Position
        ENDIF.
      ENDIF.

* KZFME prüfen
      IF NOT cvbrp-kzfme IS INITIAL.
        IF NOT vbak-abdis IS INITIAL.
          MESSAGE i476 WITH cvbrp-posnr.
          DELETE cvbrp.
          CONTINUE.
        ENDIF.
      ENDIF.

    ENDIF.

  ENDLOOP.

ENDFORM.

FORM cvbap_fusszeile_pruefen USING ch_subrc.

  DATA:
    da_cif_destination TYPE logsys,
    da_mtpos LIKE maapv-mtpos,
    da_subrc LIKE sy-subrc,
    da_atpcheck_in_apo TYPE xfeld.

  DATA: da_kunnr LIKE kuagv-kunnr,
        da_knmt TYPE knmt.


  LOCAL:
    sy-tabix,
    vbapd.

  IF NOT cvbrk-vbeln IS INITIAL.
    CLEAR cvbrp-prosa.
* Bei Einzelbestand ist der Lagerort nicht zu prüfen
    IF NOT cvbrp-vbelv IS INITIAL.
      CLEAR cvbrp-lgort.
    ENDIF.
    MOVE-CORRESPONDING cvbrk TO cvbap.
    MOVE-CORRESPONDING cvbrp TO cvbap.
    vbap = cvbap.
  ENDIF.
  CLEAR *vbap.
  PERFORM vbap-matnr_pruefen(sapfv45p) USING space
                                             sy-subrc.
  CASE sy-subrc.
    WHEN 0.
      IF vbap-matnr NE cvbap-matnr.
        cvbap-matnr = vbap-matnr.
        cvbap-arktx = maapv-arktx.
      ENDIF.
      if ( vbap-vrkme ne cvbap-vrkme or
           not matnr_subst is initial ) and
         NOT vbap-vrkme IS INITIAL.
        cvbap-vrkme = vbap-vrkme.
        PERFORM vbap-umvkz_ermitteln(sapfv45p).
        cvbap-umvkn = vbap-umvkn.
        cvbap-umvkz = vbap-umvkz.
      ENDIF.
      cvbap-prosa = vbap-prosa.
      cvbap-sugrd = vbap-sugrd.
    WHEN 2.
      MESSAGE s474 WITH cvbap-posnr.
*      message_collect msgg_copy_item type_e.
      ch_subrc = 3.
      EXIT.
    WHEN 4.
      ch_subrc = 5.
      EXIT.
    WHEN OTHERS.
      ch_subrc = 6.
      EXIT.
  ENDCASE.

  PERFORM cvbap_lesen_uepos USING cvbap-uepos
                                  sy-subrc.
  IF sy-subrc NE 0.
* ARM II
    IF cl_ops_switch_check=>ops_sfws_sc_advret2( ) = abap_true.
      IF gs_tvak IS INITIAL.
        SELECT SINGLE * FROM tvak INTO gs_tvak WHERE auart = tvcpa-auarn.
      ENDIF.
      IF gs_tvak-vbtyp = 'H' AND gs_tvak-msr_active IS NOT INITIAL.
        cvbap-uepos = space.
        CLEAR cvbap-stlnr.
        CLEAR cvbap-cuobj.
        CLEAR cvbap-stlkn.
      ELSE.
        IF NOT cvbap-stlkn IS INITIAL.
          MESSAGE i104(v2) WITH cvbap-posnr.
*          message_collect msgg_copy_item type_i.
          ch_subrc = 8.
          EXIT.
        ENDIF.
      ENDIF.
    ELSE.
* standard
      IF NOT cvbap-stlkn IS INITIAL.
        MESSAGE i104(v2) WITH cvbap-posnr.
*        message_collect msgg_copy_item type_i.
        ch_subrc = 8.
        EXIT.
      ELSE.
        cvbap-uepos = space.
      ENDIF.
    ENDIF.
  ENDIF.


  IF cvbap-matnr NE space.
    t184_vwpos = space.
    da_mtpos = maapv-mtpos.
  ELSE.
    t184_vwpos = 'TEXT'.
    da_mtpos = space.
  ENDIF.

  IF cvbap-prosa CA 'ABC' OR
     ( cvbap-prosa EQ space AND cvbap-uepvw EQ chara ).
    CALL FUNCTION 'SD_MAT_WERK_APOATPCHECK'
      EXPORTING
        iv_matnr           = cvbap-matnr
        iv_werks           = cvbap-werks
      IMPORTING
        ev_atpcheck_in_apo = da_atpcheck_in_apo.
    IF da_atpcheck_in_apo = charx.
      CLEAR cvbap-prosa.
      CLEAR cvbap-sugrd.
      CLEAR cvbap-uepvw.
    ENDIF.
  ENDIF.
* Product Selection
  IF NOT cvbap-sugrd IS INITIAL.
    PERFORM tvsu_select(sapmv45a) USING cvbap-sugrd
                                  charx
                                  sy-subrc.
    IF tvsu-suerg EQ chara.
      IF cvbap-uepos IS INITIAL.
        t184_vwpos = 'PSHP'.
      ELSE.
        t184_vwpos = 'PSEL'.
      ENDIF.
    ENDIF.
    IF tvsu-suerg EQ charb.
      IF cvbap-uepos IS INITIAL.
        t184_vwpos = 'PSA1'.
      ELSE.
        t184_vwpos = 'PSA2'.
      ENDIF.
    ENDIF.
  ENDIF.

* Use FREE for Free Goods (Subitems)
  IF cvbap-uepvw CA naturalrabatt.
    t184_vwpos = 'FREE'.
  ENDIF.

* Cross selling
  IF t184_vwpos IS INITIAL           AND
     NOT vbap-matnr IS INITIAL       AND
     cvbap-uepvw CA cross_selling    AND
     ( vbrp-uepvw CA cross_selling   OR
       vbap-uepvw CA cross_selling ) AND
     hvbap IS NOT INITIAL.
    t184_vwpos = 'CSEL'.
  ENDIF.


*Customer-Material Info
*  IF t184_vwpos IS INITIAL AND "Prabhu
*         NOT vbap-matnr IS INITIAL AND
*         NOT kuagv-kunnr IS INITIAL AND
*         tvak-infls NE space.
*    da_kunnr = kuagv-kunnr.
*
** Userexit
*    PERFORM userexit_cust_material_read(sapmv45a) USING da_kunnr.
*    CALL FUNCTION 'RV_CUSTOMER_MATERIAL_READ'
*      EXPORTING
*        cmr_kdmat      = vbap-kdmat
*        cmr_kunnr      = da_kunnr
*        cmr_matnr      = vbap-matnr
*        cmr_vkorg      = vbak-vkorg
*        cmr_vtweg      = vbak-vtweg
*        cmr_spart      = vbak-spart
*      IMPORTING
*        cmr_knmt       = da_knmt
*      EXCEPTIONS
*        knmt_not_found = 1.
*    IF sy-subrc EQ 0.
*      t184_vwpos = da_knmt-vwpos.
*    ENDIF.
*  ENDIF.

* Bestimmung des 1. Positionstyps
*
* Handelt es sich um eine Rechnungskorrektur bekommt die Position
* mit RKCOP = SPACE den 1. Positionstyp zugewiesen
  IF cvbrp-rkcop EQ space.
    CALL FUNCTION 'RV_VBAP_PSTYV_DETERMINE'
      EXPORTING
        t184_auart          = tvak-auart
        t184_mtpos          = da_mtpos
        t184_uepst          = hvbap-pstyn
        t184_vwpos          = t184_vwpos
        vbap_pstyv_i        = tvcpa-pstyn
      IMPORTING
        vbap_pstyv          = cvbap-pstyn
      EXCEPTIONS
        eintrag_nicht_da    = 1
        pstyv_nicht_erlaubt = 2.
    IF sy-subrc NE 0.
      cvbap-pstyn = space.
      CALL FUNCTION 'RV_VBAP_PSTYV_DETERMINE'
        EXPORTING
          t184_auart          = tvak-auart
          t184_mtpos          = da_mtpos
          t184_uepst          = hvbap-pstyn
          t184_vwpos          = t184_vwpos
          vbap_pstyv_i        = cvbap-pstyn
        IMPORTING
          vbap_pstyv          = cvbap-pstyn
        EXCEPTIONS
          eintrag_nicht_da    = 1
          pstyv_nicht_erlaubt = 2.
      IF sy-subrc NE 0.
        MESSAGE i475 WITH cvbap-posnr.
        ch_subrc = 1.
        EXIT.
      ENDIF.
    ENDIF.
* Wenn es sich um eine Rechnungskorrekturanforderung handelt, muß der
* Positionstyp für die 2. Position (dupl.Position) bestimmt werden
  ELSE.
    CALL FUNCTION 'RV_VBAP_PSTYV_DETERMINE'
      EXPORTING
        t184_auart          = tvak-auart
        t184_mtpos          = da_mtpos
        t184_uepst          = hvbap-pstyn
        t184_vwpos          = t184_vwpos
        vbap_pstyv_i        = tvcpa-psty2
      IMPORTING
        vbap_pstyv          = cvbap-pstyn
      EXCEPTIONS
        eintrag_nicht_da    = 1
        pstyv_nicht_erlaubt = 2.
    IF sy-subrc NE 0.
      cvbap-pstyn = space.
      CALL FUNCTION 'RV_VBAP_PSTYV_DETERMINE'
        EXPORTING
          t184_auart          = tvak-auart
          t184_mtpos          = da_mtpos
          t184_uepst          = hvbap-pstyn
          t184_vwpos          = t184_vwpos
          vbap_pstyv_i        = cvbap-pstyn
        IMPORTING
          vbap_pstyv          = cvbap-pstyn
        EXCEPTIONS
          eintrag_nicht_da    = 1
          pstyv_nicht_erlaubt = 2.
      IF sy-subrc NE 0.
        MESSAGE s475 WITH cvbap-posnr.
*        message_collect msgg_copy_item type_e.
        ch_subrc = 1.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.


  PERFORM tvap_select(sapmv45a) USING cvbap-pstyv
                                      space
                                      sy-subrc.
   *tvap = tvap.
  IF sy-subrc NE 0.
    ch_subrc = 3.
    MESSAGE s324 WITH cvbap-pstyv.
*    message_collect msgg_copy_item type_e.
    EXIT.
  ENDIF.
  PERFORM tvap_select(sapmv45a) USING cvbap-pstyn
                                      space
                                      sy-subrc.
  IF sy-subrc NE 0.
    ch_subrc = 2.
    MESSAGE i324 WITH cvbap-pstyn.
    EXIT.
  ENDIF.

  PERFORM vbapd_fuellen_t001w(sapfv45p).

* check plant
  IF NOT cvbap-werks IS INITIAL.
    PERFORM vbap-werks_pruefen(sapfv45p) USING cvbap-posnr
                                               cvbap-werks
                                               space
                                               space
                                               space
                                               sy-subrc
                                               space.
    IF sy-subrc NE 0.
      MESSAGE i148(v2) WITH cvbap-posnr.
      CLEAR cvbap-werks.
    ENDIF.
  ENDIF.

* Material im Werk/Lager da ?
*  PERFORM maepv_select(sapfv45p) USING cvbap-matnr "Prabhu
*                                       cvbap-werks
*                                       cvbap-berid
*                                       cvbap-lgort
*                                       space
*                                       space
*                                       da_subrc.
*  IF da_subrc EQ 2 AND NOT t001w_ext-logsys IS INITIAL.
*    ch_subrc = 0.
*  ELSEIF da_subrc EQ 5.
*    PERFORM t005t_select(sapmv45a) USING mtcom-aland
*                                         charx
*                                         sy-subrc.
*    CLEAR mtcom.
*    SET CURSOR FIELD 'VBAP-WERKS' LINE sy-stepl.
*    MESSAGE i030 WITH cvbap-matnr t005t-landx.
*    ch_subrc = 4.
*    EXIT.
*  ELSEIF da_subrc NE 0.
*    MESSAGE i478 WITH cvbap-posnr.
*    ch_subrc = 4.
*    EXIT.
*  ENDIF.

* Charge prüfen, wenn sie auch kopiert wird
  IF tvcpa-chnew IS INITIAL.
    PERFORM vbep-edatu_pruefen_charge(sapfv45e) USING vbap-posnr
                                                      cvbap-matnr
                                                      cvbap-werks
                                                      cvbap-charg
                                                      rv45a-kedatu
                                                      sy-subrc.
    IF sy-subrc > 0.
      ch_subrc = 7.
*     SÜW / CSFG: In case of external plant Batch is not checked
*      IF NOT t001w_ext-werks IS INITIAL AND "prabhu
*             t001w_ext-werks EQ cvbap-werks.
*        CLEAR ch_subrc.
*      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    "CVBAP_FUSSZEILE_PRUEFEN
