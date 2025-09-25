*&---------------------------------------------------------------------*
*&      Form  MARA_CHANGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_AMARA_UEB  text
*      -->P_H_MARA  text
*----------------------------------------------------------------------*
form mara_change tables   e_amara_ueb structure mara_ueb
                 using    h_mara structure mara
                          tranc_cnt
                 changing e_tranc_tab type tranc_tab.
*
  data: ls_amara like line of e_amara_ueb.
  data: ls_tranc like line of e_tranc_tab.
*
* MARA-Felder in Schnittstelle übertragen
  clear ls_amara.
* MARA übertragen
  move-corresponding h_mara to ls_amara.
* Änderungsfelder füllen
  ls_amara-laeda = syst-datum.
  ls_amara-aenam = syst-uname.
* MARA-Transaktionszähler
  ls_amara-tranc    = tranc_cnt.
* MARA-Transkationscode
  ls_amara-tcode = con_tcode_medaus_update.
*
* Konvert ISMPUBLERIOD /ISMFRSTPUBLPER generell ---- Anfang---TK16012002
* (analog ISM_DATA_PROVIDE)
* convert publication period in user specific format
  call function 'ISM_PUBL_PERIOD_CONVERT'
    EXPORTING
      pvi_publ_period = ls_amara-ismpublperiod
      pvi_period_type = ls_amara-ismpublpertyp
    IMPORTING
      pve_publ_period = ls_amara-ismpublperiod.

* convert first publication period in user specific format
  call function 'ISM_PUBL_PERIOD_CONVERT'
    EXPORTING
      pvi_publ_period = ls_amara-ismfrstpublper
      pvi_period_type = ls_amara-ismfrstpbpertyp
    IMPORTING
      pve_publ_period = ls_amara-ismfrstpublper.
* Konvert ISMPUBLERIOD /ISMFRSTPUBLPER generell ---- Ende  ---TK16012002
*
* MARA-Satz in Schnittstellen-Tabelle aufnehmen
  append ls_amara to e_amara_ueb.
*
* Infotabelle (für Levelbestimmung im ALOG) füllen
  clear ls_tranc.
  ls_tranc-tranc = tranc_cnt.
  ls_tranc-ismrefmdprod = h_mara-ismrefmdprod.
  ls_tranc-matnr        = h_mara-matnr.
  append ls_tranc to e_tranc_tab.
*
endform.                    " MARA_CHANGE


*---------------------------------------------------------------------*
*       FORM MARA_CHANGE_duplikat                                     *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  E_AMARA_UEB                                                   *
*  -->  H_MARA                                                        *
*  -->  TRANC_CNT                                                     *
*---------------------------------------------------------------------*
form mara_change_duplikat tables   e_amara_ueb structure mara_ueb
                 using    h_mara structure mara
                          tranc_cnt.
*
  data: ls_amara like line of e_amara_ueb.
*
* MARA-Felder in Schnittstelle übertragen
  clear ls_amara.
* MARA übertragen
  move-corresponding h_mara to ls_amara.
* Änderungsfelder füllen
  ls_amara-laeda = syst-datum.
  ls_amara-aenam = syst-uname.
* MARA-Transaktionszähler
  ls_amara-tranc    = tranc_cnt.
* MARA-Transkationscode
  ls_amara-tcode = con_tcode_medaus_update.
*
* Konvert ISMPUBLERIOD /ISMFRSTPUBLPER generell Anfang
* (analog ISM_DATA_PROVIDE)
* convert publication period in user specific format
  call function 'ISM_PUBL_PERIOD_CONVERT'
    EXPORTING
      pvi_publ_period = ls_amara-ismpublperiod
      pvi_period_type = ls_amara-ismpublpertyp
    IMPORTING
      pve_publ_period = ls_amara-ismpublperiod.

* convert first publication period in user specific format
  call function 'ISM_PUBL_PERIOD_CONVERT'
    EXPORTING
      pvi_publ_period = ls_amara-ismfrstpublper
      pvi_period_type = ls_amara-ismfrstpbpertyp
    IMPORTING
      pve_publ_period = ls_amara-ismfrstpublper.
* Konvert ISMPUBLERIOD /ISMFRSTPUBLPER generell
*
* MARA-Satz in Schnittstellen-Tabelle aufnehmen
  append ls_amara to e_amara_ueb.
*
* kein(!!) Satz in Infotabelle (für Levelbestimmung im ALOG) füllen

endform.                    " MARA_CHANGE_duplikat

*&---------------------------------------------------------------------*
*&      Form  MARC_CREATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_AMARC_UEB  text
*      -->P_H_MARC  text
*      -->P_TRANC_CNT  text
*----------------------------------------------------------------------*
form marc_change tables   e_amarc_ueb structure marc_ueb
                 using    h_marc structure marc
                          h_mara structure mara
                          tranc_cnt
                 changing e_tranc_tab type tranc_tab.
*
*
  data: ls_amarc like line of e_amarc_ueb.
  data: ls_tranc like line of e_tranc_tab.
*
* MARC-Felder in Schnittstelle übertragen
  clear ls_amarc.
* MARC übertragen
  move-corresponding h_marc to ls_amarc.
* MARC-Transaktionszähler
  ls_amarc-tranc    = tranc_cnt.
*
* MARC-Satz in Schnittstellen-Tabelle aufnehmen
  append ls_amarc to e_amarc_ueb.
*
* Infotabelle (für Levelbestimmung im ALOG) füllen
  clear ls_tranc.
  ls_tranc-tranc = tranc_cnt.
  ls_tranc-ismrefmdprod = h_mara-ismrefmdprod.
  ls_tranc-matnr        = h_marc-matnr.
  ls_tranc-marc_werks   = h_marc-werks.
  append ls_tranc to e_tranc_tab.
*
endform.                    " MARC_CREATE

*---------------------------------------------------------------------*
*       FORM Mvke_Change                                              *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  E_AMVKE_UEB                                                   *
*  -->  H_MVKE                                                        *
*  -->  TRANC_CNT                                                     *
*---------------------------------------------------------------------*
form mvke_change tables   e_amvke_ueb structure mvke_ueb
                 using    h_mvke structure mvke
                          h_mara structure mara
                          tranc_cnt
                 changing e_tranc_tab type tranc_tab.
*
  data: ls_amvke like line of e_amvke_ueb.
  data: ls_tranc like line of e_tranc_tab.
*
* MVKE-Felder in Schnittstelle übertragen
  clear ls_amvke.
* MVKE übertragen
  move-corresponding h_mvke to ls_amvke.
* MARC-Transaktionszähler
  ls_amvke-tranc    = tranc_cnt.
*
* MVKE-Satz in Schnittstellen-Tabelle aufnehmen
  append ls_amvke to e_amvke_ueb.
*
* Infotabelle (für Levelbestimmung im ALOG) füllen
  clear ls_tranc.
  ls_tranc-tranc = tranc_cnt.
  ls_tranc-ismrefmdprod = h_mara-ismrefmdprod.
  ls_tranc-matnr        = h_mvke-matnr.
*         XFIRST_ISSUE_LINE TYPE XFELD,
  ls_tranc-mvke_vkorg =  h_mvke-vkorg.
  ls_tranc-mvke_vtweg =  h_mvke-vtweg.
  append ls_tranc to e_tranc_tab.
*
endform.                    " MVKE_CREATE


*---------------------------------------------------------------------*
*       FORM maintain_Dark                                            *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  I_AMARA_UEB                                                   *
*  -->  I_AMARC_UEB                                                   *
*  -->  I_AMVKE_UEB                                                   *
*  -->  LV_SUBRC                                                      *
*---------------------------------------------------------------------*
form maintain_dark tables i_amara_ueb type amara_tab
                          i_amarc_ueb type amarc_tab
                          i_amvke_ueb type amvke_tab
                          i_amfieldres_tab type amfieldres_tab
                          i_tranc_tab      type tranc_tab
                          e_error_tab      type error_tab
                    using xalog_active xtest xretail
                          i_jptmara_tab type jptmara_tab    "TK01102006
                          i_mara_db    type ism_mara_Db_Tab "TK01042008
                          i_marc_db    type ism_marc_Db_Tab "TK01042008
                          i_mvke_db    type ism_mvke_Db_Tab "TK01042008
                          XENQUE_SEGMENTS                   "TK01042008
                  changing lv_subrc err_cnt.
*
  data: h_matnr_last type mara-matnr.
  data: h_number_errors_transaction type tbist-numerror.
  data: errmsg_stru type errmsg_stru.
  data: errmsg_tab type errmsg_tab.
  data: ls_tranc like line of i_tranc_tab.
  data: level_text(28).
  data: error_stru like line of e_error_tab.
  data: ls_jptmara type jptmara.                            "TK01102006
  data: jptmara_errmsg_tab type jp_merrdat_tab.             "TK01102006
  data: matnr_dummy type matnr.                             "TK01102006

*
* Intitale Datümer der Status werden mit Tagesdatum belegt
  perform set_dates_for_status tables i_amara_ueb i_amarc_ueb
                                      i_amvke_ueb.
*
* Wenn ISMINTERRUPTDATE gefüllt => Flag ISMINTERRUPT ist Mußfeld
  perform set_xflag_for_interruptdate tables i_amvke_ueb.
*

* ------------------------------------- Anfang ----------"TK18022005
  data: in_mara_tab type amara_tab.
  data: in_marc_tab type amarc_tab.
  data: in_mvke_tab type amvke_tab.
  data: out_badi_error_tab type errmsg_tab.
*
* Schnittstelle prepare
  perform badi_tables_prepare tables i_amara_ueb i_amarc_ueb
                                     i_amvke_ueb
                                     in_mara_tab in_marc_tab
                                     in_mvke_tab.
* Badi Aufruf
  perform badi_plausis tables in_mara_tab in_marc_tab  in_mvke_tab
                              out_badi_error_tab.
* Fehlersätze ausselektieren
  perform maintain_dark_tables_adjust tables errmsg_tab
                                      out_badi_error_tab
                                      i_amara_ueb i_amarc_ueb
                                      i_amvke_ueb.
* weiter mit den Updates
* ------------------------------------- Ende ------------"TK18022005

* --- Anfang ----------optimistisches Sperren----------- "TK01042008
  data: out_enque_error_tab type errmsg_tab.
  data: out_change_error_tab type errmsg_tab.

  if XENQUE_SEGMENTS = con_angekreuzt.
*   "optimistische" Sperren setzen, Daten abgleichen, und
*   gesperrte bzw. inzwischen veränderte Objekte ausselektieren
    perform optimistic_enque_handling tables  " errmsg_tab
                                              out_enque_error_tab
                                              out_change_error_tab
                                              i_amara_ueb i_amarc_ueb
                                              i_amvke_ueb
                                      using   i_mara_db
                                              i_marc_db
                                              i_mvke_db.
  endif. " XENQUE_SEGMENTS = con_angkreuzt.
* --- Ende ------------optimistisches Sperren----------- "TK01042008

  if xretail = 'X'.
*     BREAK KAST.
*     Info zum Fehlerhandling:
*     Fehler des BAPI werden in ERRMSG_TAB aufgenommen. Dadurch werden
*     in der Protokllaufbereitung(siehe unten) LV_SUBRC und ERR_CNT
*     automatisch versorgt.
    perform retail_einzelartikel_aendern
                   tables i_amara_ueb i_amvke_ueb i_amarc_ueb
                                errmsg_tab i_tranc_tab
                   using        i_jptmara_tab               "TK01102006
                changing        jptmara_errmsg_tab .        "TK01102006
  else.

*   DB-Updates

    call function 'MATERIAL_MAINTAIN_DARK'
         exporting
*             Bedeutung von FLAG_MUSS_PRUEFEN siehe F1 auf "Mußfelder
*             prüfen" des Selektionsbildes von RMDATIND !!
              flag_muss_pruefen         = ' '
             sperrmodus                = 'E'                 "Exclusiv
              max_errors                = 0
              p_kz_no_warn              = 'N'
              kz_prf                    = ' '  "nicht eingabebereite
                                                "Felder
*               KZ_VERW                   = 'X'
*               KZ_AEND                   = 'X'
*               KZ_DISPO                  = 'X'
              kz_test                   = xtest "Testlauf/Echtlauf
*               NO_DATABASE_UPDATE        = ' '
*               CALL_MODE                 = ' '
              call_mode2                = 'ISM'
*               damit MATERIAL_UPDATE_OTHER_DATA wieder prozessiert wird
*               USER                      = SY-UNAME
*               SUPPRESS_ARRAY_READ       = ' '
         importing
              matnr_last                = h_matnr_last
              number_errors_transaction = h_number_errors_transaction
         tables
              amara_ueb                 = i_amara_ueb
*               AMAKT_UEB                 = MAKT_TAB
              amarc_ueb                 = i_amarc_ueb
*               AMARD_UEB                 = MARD_TAB
*               AMFHM_UEB                 = MFHM_TAB
*               AMARM_UEB                 = MARM_TAB
*               AMBEW_UEB                 = MBEW_TAB
*               ASTEU_UEB                 = STEU_TAB
*               ASTMM_UEB                 = STMM_TAB
*               AMLGN_UEB                 = MLGN_TAB
*               AMLGT_UEB                 = MLGT_TAB
*               AMPGD_UEB                 = MPGD_TAB
              amvke_ueb                 = i_amvke_ueb
*               ALTX1_UEB                 = LTX1_TAB
*               AMEA1_UEB                 = MEA1_TAB
*               AMPRW_UEB                 = MPRW_TAB
*               AMPOP_UEB                 = MPOP_TAB
*               AMVEG_UEB                 = MVEG_TAB
*               AMVEU_UEB                 = MVEU_TAB
              amfieldres                = i_amfieldres_tab
              amerrdat                  = errmsg_tab
         exceptions
              kstatus_empty             = 1
              tkstatus_empty            = 2
              t130m_error               = 3
              internal_error            = 4
              too_many_errors           = 5
              update_error              = 6
              others                    = 7.
*     Erfolgsmeldungen: (MSGTY = D):
*     M3 801: Material wird geändert
*     Fehlermeldung M3 139: Gültigabdatum für Vertriebsstatus fehlt
*                       Werksstatus brauch kein Gültigabdatum
*     Jede Exception wird als Fehler gewertet
    if sy-subrc <> 0.
      lv_subrc = 1.
*     Exception in  Fehlertabelle des MAINTAIN_DARK aufnehmen
*     Meldung "Änderungen unvollständing gesichert."
      perform exception_nach_alog tables errmsg_tab
                                using syst '036'
                                matnr_dummy. "n Materialien "TK01102006
    endif.

*   JPTMARA anlegen----Anfang-------------------------------"TK01102006
*   Fuba zum Anlegen/Ändern der JPTMARA macht intern einen Check auf
*   die Existenz der Medienausgabe!
*   Auch wenn MAINTAIN_DARK einen SUBRC <> 0 hat, kann dieser Fuba
*   über alle Medienausgaben laufen und JPTMARA aktualisieren.
    loop at i_jptmara_tab into ls_jptmara.
*
      perform jptmara_maintain using ls_jptmara
                          changing jptmara_errmsg_tab
                                   lv_subrc.
*
    endloop.
*   JPTMARA anlegen----Ende---------------------------------"TK01102006


  endif.

* ------------------------------------- Anfang ----------"TK18022005
  if not out_badi_error_tab[] is initial.
*   Fehlermeldung des BADI ins Protokoll aufnehmen
    loop at out_badi_error_tab into errmsg_stru.
      append errmsg_stru to errmsg_tab.
    endloop.
  endif.
* ------------------------------------- Ende ------------"TK18022005

* --- Anfang ----------optimistisches Sperren----------- "TK01042008
  data: ls_error type ERRMSG_STRU.

  if XENQUE_SEGMENTS = con_angekreuzt.
    if not out_enque_error_tab[] is initial.
*     Fehlermeldung (Sperre bei opt.Sperrren) ins Protokoll aufnehmen
      loop at out_enque_error_tab into ls_error.
        append ls_error to errmsg_tab.
      endloop.
    endif.
    if not out_change_error_tab[] is initial.
*     Fehlermeldung (Datenänderung bei opt.Sperrren) ins Protokoll aufnehmen
      loop at out_change_error_tab into ls_error.
        append ls_error to errmsg_tab.
      endloop.
    endif.
  endif. " XENQUE_SEGMENTS = con_angekreuzt.

* --- Ende ------------optimistisches Sperren---------- "TK01042008


*-------------Anwendungslog-------------------------------------------
*
*  Für XALOG_ACTIVE wichtig:
*  die objekte LOG und RETURN sind schon erzeugt (CREATE OBJECT in der
*  Form INIT ist für LOG und RETURN schon erfolgt) !!
*

  data: header type string.
  data: dummy(80) type c.
  data: text_16(16).
  data: text_4(4).
*
  clear e_error_tab. refresh e_error_tab.
  clear err_cnt.
*
  if xalog_active = con_angekreuzt.
*   ALOG:
*   init MSG_TAB (des Objektes RETURN)
    call method return->delete_all.
*
    call method log->replace.
    call method log->hide.
    clear log.
    get time.
    create object log
      EXPORTING
        log_object  = con_log_object
        header_text = text-008
        height      = 100
        dynnr       = '0101'
        program     = 'RJKSDWORKLIST'.

    call method log->hide.                          "TK07122009/hint1414570

  endif.
* MSG_TAB (des Message-Objektes RETURN) füllen (nur Fehlermeldungen)
* (" MSGTY = 'D' kann Message-Befehl bzw. Methode ADD nicht !)
  sort gt_tranc_tab. "je TRANC ein(!) Satz mit Info über Update-Segment
  loop at errmsg_tab into errmsg_stru.
    if errmsg_stru-msgty = 'E'                or
       errmsg_stru-msgty = 'A'                  .
*     Fehler ist aufgetreten
      lv_subrc = 1.
*
      clear error_stru.
*
*     GT_TRANC_TAB enthält Infos über Prod/Ausg./werk/vkorg
*     => Level müssen aus GT_TRANC_TAB bestimmt werden
*     (ERRMSG_TAB hat z.B. für MARA und MARC identische Fehlereinträge!)
      read table gt_tranc_tab into ls_tranc
                              with key tranc = errmsg_stru-tranc
                              binary search.
      if sy-subrc = 0.
        clear level_text.
*       ---- Anfang----------optimitische Sperren---------- "TK01042008
*       Protokollausgabe erfolgt generell auf MARA-Ebene für Fehler, die
*       beim optimistischen Sperren (Sperre oder Datenänderung) auftreten:
*       (eine Differenierung nach Segmenten ist nicht realisiert, bei
*        Sperre oder DB-Konflikten wird die Ausgabe inclusive ALLER(!!)
*        Segmente aus den Schnittstellentabellen für MAINTAIN_DARK bzw.
*        Retail-BAPI gelöscht!!)
        if   errmsg_stru-msgid = 'JKSDWORKLIST'             and
           ( errmsg_stru-msgno = '057'          or
             errmsg_stru-msgno = '058'              ).
          clear ls_tranc-marc_werks.
          clear ls_tranc-mvke_vkorg.
          clear ls_tranc-mvke_vtweg.
        endif.
*       ---- Ende------------optimitische Sperren---------- "TK01042008
        if ls_tranc-marc_werks is initial and
           ls_tranc-mvke_vkorg is initial.
*          MARA-Fehler
          level_text = text-012.
          error_stru-tabname = 'MARA'.
        else.
          if ls_tranc-marc_werks is initial.
*           MVKE-Fehler
            text_16 = text-011.
            level_text = text_16.
            level_text+17(4) = ls_tranc-mvke_vkorg.
            level_text+21(1) = '/'.
            level_text+22(2) = ls_tranc-mvke_vtweg.
            error_stru-tabname = 'MVKE'.
            error_stru-vkorg = ls_tranc-mvke_vkorg.
            error_stru-vtweg = ls_tranc-mvke_vtweg.

          else.
*           MARC-Fehler
            text_4 = text-005.
            level_text = text_4.
            level_text+5(4) = ls_tranc-marc_werks.
            error_stru-tabname = 'MARC'.
            error_stru-werks = ls_tranc-marc_werks.
          endif.
        endif.
      else.
        level_text = 'Fehler:'(010).                        "text-010
      endif.
*
      if xalog_active = con_angekreuzt.
*       Zähler für nicht erfolgreiche Updates
        err_cnt = err_cnt + 1 .
*       ALOG:
*       Message-Variable in Syst-Felder stellen
        message id errmsg_stru-msgid type errmsg_stru-msgty number
                       errmsg_stru-msgno
              with errmsg_stru-msgv1 errmsg_stru-msgv2
                   errmsg_stru-msgv3 errmsg_stru-msgv4
              into dummy.
*       => damit Aufnahme in RETURN
        if xretail is initial.
*         Fehlerprotokoll für Industriematerial geht bis LEVEL3!
          call method return->add
            EXPORTING
              level1 = ls_tranc-ismrefmdprod
              level2 = errmsg_stru-matnr
              level3 = level_text.
        else.
*         Fehlerprotokoll für Retail-Artikel geht bis LEVEL2!
          call method return->add
            EXPORTING
              level1 = ls_tranc-ismrefmdprod
              level2 = errmsg_stru-matnr.
        endif.
      else.
*       Fehlertab. (ohne ALOG)
*       ERROR_STRU-ISMREFMDPROD = LS_TRANC-ISMREFMDPROD.
        error_stru-matnr        = ls_tranc-matnr.
        error_stru-msgid        = errmsg_stru-msgid. "SY-MSGID.
        error_stru-msgty        = errmsg_stru-msgty. "SY-MSGTY.
        error_stru-msgno        = errmsg_stru-msgno. "SY-MSGNO.
        error_stru-msgv1        = errmsg_stru-msgv1.        "SY-MSGV1.
        error_stru-msgv2        = errmsg_stru-msgv2.        "SY-MSGV2.
        error_stru-msgv3        = errmsg_stru-msgv3.        "SY-MSGV3.
        error_stru-msgv4        = errmsg_stru-msgv4.        "SY-MSGV4.
        append error_stru to e_error_tab.
      endif.
    else.

*     Aufnahme dieser Info würde bedeuten, daß die Interpretation der
*     Fehlertabelle angepasst werden müsste => momentan nicht notwendig
***********************************************************************
**     Info-meldungen
**     Momentan selektiv nur eine Infomeldung:
**     Bei Retail-Artikel wird Anwendungslognr. als Info ausgegeben
*      IF ERRMSG_STRU-MSGTY         = 'I'               AND
*         ERRMSG_STRU-MSGID         = 'JKSDWORKLIST'    AND
*         ERRMSG_STRU-MSGNO         = '043'.
*
*        CLEAR ERROR_STRU.
**
**       GT_TRANC_TAB enthält Infos über Prod/Ausg./werk/vkorg
**       => Level müssen aus GT_TRANC_TAB bestimmt werden
**       (ERRMSG_TAB hat z.B. für MARA und MARC ident.Fehlereintr.!)
*        READ TABLE GT_TRANC_TAB INTO LS_TRANC
*                                WITH KEY TRANC = ERRMSG_STRU-TRANC
*                                BINARY SEARCH.
**       Retail hat nur MARA-Fehler!
*        IF SY-SUBRC = 0.
*          CLEAR LEVEL_TEXT.
**          MARA-Fehler
*          LEVEL_TEXT = TEXT-012.
*          ERROR_STRU-TABNAME = 'MARA'.
*        ELSE.
*          LEVEL_TEXT = 'Fehler:'(010).                      "text-010
*        ENDIF.
**
*        IF XALOG_ACTIVE = CON_ANGEKREUZT.
**         ERR_CNT wird für Info nicht hochgezählt
*
**         ALOG:
**         Message-Variable in Syst-Felder stellen
*          MESSAGE ID ERRMSG_STRU-MSGID TYPE ERRMSG_STRU-MSGTY NUMBER
*                         ERRMSG_STRU-MSGNO
*                WITH ERRMSG_STRU-MSGV1 ERRMSG_STRU-MSGV2
*                     ERRMSG_STRU-MSGV3 ERRMSG_STRU-MSGV4
*                INTO DUMMY.
**         => damit Aufnahme in RETURN
*          CALL METHOD RETURN->ADD
*            EXPORTING
*              LEVEL1 = LS_TRANC-ISMREFMDPROD
*              LEVEL2 = ERRMSG_STRU-MATNR
*              LEVEL3 = LEVEL_TEXT.
*        ELSE.
**         Fehlertab. (ohne ALOG)
**         ERROR_STRU-ISMREFMDPROD = LS_TRANC-ISMREFMDPROD.
*          ERROR_STRU-MATNR        = LS_TRANC-MATNR.
*          ERROR_STRU-MSGID        = ERRMSG_STRU-MSGID. "SY-MSGID.
*          ERROR_STRU-MSGTY        = ERRMSG_STRU-MSGTY. "SY-MSGTY.
*          ERROR_STRU-MSGNO        = ERRMSG_STRU-MSGNO. "SY-MSGNO.
*          ERROR_STRU-MSGV1        = ERRMSG_STRU-MSGV1.      "SY-MSGV1.
*          ERROR_STRU-MSGV2        = ERRMSG_STRU-MSGV2.      "SY-MSGV2.
*          ERROR_STRU-MSGV3        = ERRMSG_STRU-MSGV3.      "SY-MSGV3.
*          ERROR_STRU-MSGV4        = ERRMSG_STRU-MSGV4.      "SY-MSGV4.
*          APPEND ERROR_STRU TO E_ERROR_TAB.
*        ENDIF.
*      ENDIF.
***********************************************************************
    endif.
  endloop.
*
  if xalog_active = con_angekreuzt.
*   ALOG:
*   Message-Objekt RETURN der Log-Klasse übergeben
    call method log->add_msg
      EXPORTING
        message = return.
*   Sichern des Anwendungslogs auf der Datenbank
    call method log->save.

    if lv_subrc <> 0.          "TK07122009/hint1414570
*   Log anzeigen
    call method log->show.
    endif.                     "TK07122009/hint1414570
  endif.
*
*-------------Anwendungslog-------------------------------------------

*
endform.                    "MAINTAIN_DARK

*---------------------------------------------------------------------*
*       FORM EXCEPTION_NACH_ALOG                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  ERRMSG_TAB_SINGLE                                             *
*  -->  SYST                                                          *
*  -->  H_MSGNO                                                       *
*---------------------------------------------------------------------*
form exception_nach_alog tables errmsg_tab structure merrdat
                                using syst structure syst
                                      h_msgno
                                      p_matnr.              "TK01102006
*
  data: h_errmsg type merrdat.
*
* konkrete Materialnummer ist hier nicht bekannt: MAINTAIN_DARK
* wird für alle geänderten Medienausgaben einmalig prozessiert
*
  clear h_errmsg.
  h_errmsg-tranc = 1.  " ?
  h_errmsg-matnr = p_matnr.                                 "TK01102006
  h_errmsg-msgid = 'JKSDWORKLIST'.
  h_errmsg-msgno = h_msgno.
  h_errmsg-msgty = con_error.
  h_errmsg-msgv1 = p_matnr.
  h_errmsg-msgv1 = sy-subrc.
  append h_errmsg to errmsg_tab.
*   Originalmeldung
  clear h_errmsg.
  h_errmsg-tranc = 1.  " ?
  h_errmsg-matnr = p_matnr.                                 "TK01102006
  h_errmsg-msgid = sy-msgid.
  h_errmsg-msgno = sy-msgno.
  h_errmsg-msgty = sy-msgty.
  h_errmsg-msgv1 = sy-msgv1.
  h_errmsg-msgv2 = sy-msgv2.
  h_errmsg-msgv3 = sy-msgv3.
  h_errmsg-msgv4 = sy-msgv4.
  append h_errmsg to errmsg_tab.
*
endform.                    "EXCEPTION_NACH_ALOG
*&---------------------------------------------------------------------*
*&      Form  set_dates_for_status
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_AMARA_UEB  text
*      -->P_I_AMARC_UEB  text
*      -->P_I_AMVKE_UEB  text
*----------------------------------------------------------------------*
form set_dates_for_status  tables i_amara_ueb type amara_tab
                                  i_amarc_ueb type amarc_tab
                                  i_amvke_ueb type amvke_tab.

*
  data:   ls_amara_ueb like line of i_amara_ueb,
          ls_amarc_ueb like line of i_amarc_ueb,
          ls_amvke_ueb like line of i_amvke_ueb.
*
* MARA-Status
  loop at i_amara_ueb into ls_amara_ueb.
    if not ls_amara_ueb-mstae is initial and
           ls_amara_ueb-mstde is initial.
      ls_amara_ueb-mstde = syst-datum.
    endif.
    if     ls_amara_ueb-mstae is initial and
       not ls_amara_ueb-mstde is initial.
      clear ls_amara_ueb-mstde.
    endif.
    if not ls_amara_ueb-mstav is initial and
           ls_amara_ueb-mstdv is initial.
      ls_amara_ueb-mstdv = syst-datum.
    endif.
    if     ls_amara_ueb-mstav is initial and
       not ls_amara_ueb-mstdv is initial.
      clear ls_amara_ueb-mstdv.
    endif.
    modify i_amara_ueb from ls_amara_ueb.
  endloop.
*
* MARC-Status
  loop at i_amarc_ueb into ls_amarc_ueb.
    if not ls_amarc_ueb-mmsta is initial and
           ls_amarc_ueb-mmstd is initial.
      ls_amarc_ueb-mmstd = syst-datum.
    endif.
    if     ls_amarc_ueb-mmsta is initial and
       not ls_amarc_ueb-mmstd is initial.
      clear ls_amarc_ueb-mmstd.
    endif.
    modify i_amarc_ueb from ls_amarc_ueb.
  endloop.
*
* MVKE-Status
  loop at i_amvke_ueb into ls_amvke_ueb.
    if not ls_amvke_ueb-vmsta is initial and
           ls_amvke_ueb-vmstd is initial.
      ls_amvke_ueb-vmstd = syst-datum.
    endif.
    if     ls_amvke_ueb-vmsta is initial and
       not ls_amvke_ueb-vmstd is initial.
      clear ls_amvke_ueb-vmstd.
    endif.
    modify i_amvke_ueb from ls_amvke_ueb.
  endloop.
*
endform.                    " set_dates_for_status


*&--------------------------------------------------------------------*
*&      Form  SET_XFLAG_FOR_INTERRUPTDATE
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->I_AMVKE_UEBtext
*---------------------------------------------------------------------*
form set_xflag_for_interruptdate
                          tables i_amvke_ueb type amvke_tab.

*
  data: ls_amvke_ueb like line of i_amvke_ueb.
*
* MVKE-Flag ISMINTERRUPT wird abhänging von ISMINTERRUPTDATE verwaltet
  loop at i_amvke_ueb into ls_amvke_ueb.
    if not ls_amvke_ueb-isminterruptdate is initial and
           ls_amvke_ueb-isminterrupt is initial.
      ls_amvke_ueb-isminterrupt = con_angekreuzt.
    endif.
    if     ls_amvke_ueb-isminterruptdate is initial and
       not ls_amvke_ueb-isminterrupt is initial.
      clear ls_amvke_ueb-isminterrupt.
    endif.

*   -- Flag ISMMATRETURN wird implizit hier mitverwaltet-- Anfang "TK13022006
    if not ls_amvke_ueb-ismreturnbegin is initial or
       not ls_amvke_ueb-ismreturnend   is initial.
      ls_amvke_ueb-ismmatreturn = con_angekreuzt.
    else.
      clear ls_amvke_ueb-ismmatreturn.
    endif.
*   -- Flag ISMMATRETURN wird implizit hier mitverwaltet-- Ende   "TK13022006

    modify i_amvke_ueb from ls_amvke_ueb.
  endloop.
*
endform. " SET_XFLAG_FOR_INTERRUPTDATE

*&--------------------------------------------------------------------*
*&      Form  RETAIL_EINZELARTIKEL_Aendern
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->MARA_TAB   text
*      -->MVKE_TAB   text
*      -->MARC_TAB   text
*      -->ERRMSG_TAB text
*      -->I_TRANC_TABtext
*---------------------------------------------------------------------*
form retail_einzelartikel_aendern
            tables mara_tab structure mara_ueb
                   mvke_tab structure mvke_ueb
                   marc_tab structure marc_ueb
                   errmsg_tab
                   i_tranc_tab      type tranc_tab
            using  jptmara_tab  type jptmara_tab            "TK01102006
         changing  jptmara_errmsg_tab type jp_merrdat_tab.  "TK01102006

*
  data: variant_tab type jmm_variants_tab.
  data: dummy_matnr type matnr.
  data: makt_stru type makt.
  data: mvke_prepare_tab type standard table of mvke.
  data: mvke_prepare_stru like line of mvke_prepare_tab.
  data: marc_prepare_tab type standard table of marc.
  data: marc_prepare_stru like line of marc_prepare_tab.
  data: begin of mara_tab_save occurs 0.
          include structure mara_ueb.
  data: end   of mara_tab_save.
  data: ls_jptmara type jptmara.                            "TK01102006

*
  mara_tab_save[] = mara_tab[].
  "für nachlesen MARA-SATZ bei Gruppenwechsel

*
  loop at mara_tab.
    at new matnr.
*     Daten für PREPARE für jeden Einzelartikel aufbereiten:
*     (in den Übergabetabellen sind ALLE Materialien enthalten)
*     Vertriebsbereiche:
      clear mvke_prepare_tab. refresh mvke_prepare_tab.
      loop at mvke_tab
        where matnr = mara_tab-matnr.
        move-corresponding mvke_tab to mvke_prepare_stru.
        append mvke_prepare_stru  to mvke_prepare_tab.
      endloop.
      sort mvke_prepare_tab.
      delete adjacent duplicates from mvke_prepare_tab.
*     Werke:
      clear marc_prepare_tab. refresh marc_prepare_tab.
      loop at marc_tab
        where matnr = mara_tab-matnr.
        move-corresponding marc_tab to marc_prepare_stru.
        append marc_prepare_stru  to marc_prepare_tab.
      endloop.
      sort marc_prepare_tab.
      delete adjacent duplicates from marc_prepare_tab.
*
*     JPTMARA:                                           "TK01102006
      clear ls_jptmara.                                     "TK01102006
      read table jptmara_tab into ls_jptmara                "TK01102006
         with key    mandt   = sy-mandt                     "TK01102006
                     matnr   = mara_tab-matnr.              "TK01102006
*     JPTMARA muß nicht zwingend übergeben worden sein   "TK01102006

      read table mara_tab_save with key mandt = sy-mandt
                                       matnr = mara_tab-matnr.
*
*     init (bei Einzelartikel erfolgt INIT in Folge-Forms)
      perform ism_maintain_retail_prepare
               tables   mvke_prepare_tab              "Vertr.ber.
                        marc_prepare_tab              "Werke
                  using mara_tab-matnr                "neue MATNR
                        mara_tab_save.                "MSD-aufber. MARA

*
      perform ism_maintain_retail tables errmsg_tab
                                         mvke_prepare_tab "Vertr.ber.
                                         marc_prepare_tab "Werke
                                         i_tranc_tab
                                  using mara_tab-matnr  "neue MATNR
                                        mara_tab_save   "MSD-aufber. MARA
                                        ls_jptmara          "TK01102006
                               changing jptmara_errmsg_tab. "TK01102006
    endat.
*
  endloop.

*
endform.                    "RETAIL_EINZELARTIKEL_Aendern




*&--------------------------------------------------------------------*
*&      Form  ISM_MAINTAIN_RETAIL_PREPARE
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->MVKE_PREPARtextB
*      -->MARC_PREPARtextB
*      -->NEW_MATNR  text
*      -->MARA_TAB_SAtext
*---------------------------------------------------------------------*
form ism_maintain_retail_prepare
            tables mvke_prepare_tab structure mvke
                   marc_prepare_tab structure marc
            using  new_matnr
                   mara_tab_save structure mara_ueb .

*
  data: pattern_matnr type matnr.
  data: makt_stru type makt.
  data: variant_tab type jmm_variants_tab.
*
* Schnittstellen werden händisch (anstelle des PREPARE-Bausteins,
* Siehe unten) aufgebaut:
  perform prepare_rt_for_statuschange
            tables mvke_prepare_tab marc_prepare_tab
            using  mara_tab_save.



  check 1 = 2.

** ab hier die lauffähige Version, in der mit dem Fuba
** ISM_BAPI_MATERIAL_RT_PREPARE die Schittstellen für den
** Retail-Bapi aufgebaut wird. (Damit dies funktioniert, wird
** in PATTERN_ARTICLE die Materialnummer übergeben. Der Fuba liest
** dann für diese MATNR alle Segmente. Danach müssen die relevanten
** Schnittstellentabellen wieder mit den echten Status, die in der
** Transaktion gepflegt wurden, versorgt werden.)
*
**
*  CALL FUNCTION 'ISM_BAPI_MATERIAL_RT_PREPARE'
*    EXPORTING
*      PATTERN_ARTICLE      = NEW_MATNR " PATTERN_MATNR
*      NEW_SINGLE_MATERIAL  = NEW_MATNR
*      NEW_VARIANTS_TAB     = VARIANT_TAB
*      MAKT_STRU            = MAKT_STRU
*    IMPORTING
*      HEADDATA             = HEADDATA
*    TABLES
*      IN_MVKE_TAB          = MVKE_PREPARE_TAB           "Input
*      IN_MARC_TAB          = MARC_PREPARE_TAB           "Input
**      VARIANTSKEYS         = VARIANTSKEYS
**      CHARACTERISTICVALUE  = CHARACTERISTICVALUE
**      CHARACTERISTICVALUEX = CHARACTERISTICVALUEX
*      CLIENTDATA           = CLIENTDATA                 "out
*      CLIENTDATAX          = CLIENTDATAX
*      CLIENTEXT            = CLIENTEXT
*      CLIENTEXTX           = CLIENTEXTX
*      ADDNLCLIENTDATA      = ADDNLCLIENTDATA            "out
*      ADDNLCLIENTDATAX     = ADDNLCLIENTDATAX
**      MATERIALDESCRIPTION  = MATERIALDESCRIPTION
*      PLANTDATA            = PLANTDATA                  "out
*      PLANTDATAX           = PLANTDATAX
*      PLANTEXT             = PLANTEXT
*      PLANTEXTX            = PLANTEXTX
**      FORECASTPARAMETERS   = FORECASTPARAMETERS
**      FORECASTPARAMETERSX  = FORECASTPARAMETERSX
**      FORECASTVALUES       = FORECASTVALUES
**      TOTALCONSUMPTION     = TOTALCONSUMPTION
**      UNPLNDCONSUMPTION    = UNPLNDCONSUMPTION
**      PLANNINGDATA         = PLANNINGDATA               "out
**      PLANNINGDATAX        = PLANNINGDATAX
**      STORAGELOCATIONDATA  = STORAGELOCATIONDATA
**      STORAGELOCATIONDATAX = STORAGELOCATIONDATAX
**      STORAGELOCATIONEXT   = STORAGELOCATIONEXT
**      STORAGELOCATIONEXTX  = STORAGELOCATIONEXTX
**      UNITSOFMEASURE       = UNITSOFMEASURE
**      UNITSOFMEASUREX      = UNITSOFMEASUREX
**      UNITOFMEASURETEXTS   = UNITOFMEASURETEXTS
**      INTERNATIONALARTNOS  = INTERNATIONALARTNOS
**      VENDOREAN            = VENDOREAN
**      LAYOUTMODULEASSGMT   = LAYOUTMODULEASSGMT
**      LAYOUTMODULEASSGMTX  = LAYOUTMODULEASSGMTX
**      TAXCLASSIFICATIONS   = TAXCLASSIFICATIONS
**      VALUATIONDATA        = VALUATIONDATA
**      VALUATIONDATAX       = VALUATIONDATAX
**      VALUATIONEXT         = VALUATIONEXT
**      VALUATIONEXTX        = VALUATIONEXTX
**      WAREHOUSENUMBERDATA  = WAREHOUSENUMBERDATA
**      WAREHOUSENUMBERDATAX = WAREHOUSENUMBERDATAX
**      WAREHOUSENUMBEREXT   = WAREHOUSENUMBEREXT
**      WAREHOUSENUMBEREXTX  = WAREHOUSENUMBEREXTX
**      STORAGETYPEDATA      = STORAGETYPEDATA
**      STORAGETYPEDATAX     = STORAGETYPEDATAX
**      STORAGETYPEEXT       = STORAGETYPEEXT
**      STORAGETYPEEXTX      = STORAGETYPEEXTX
*      SALESDATA            = SALESDATA                 "out
*      SALESDATAX           = SALESDATAX
*      SALESEXT             = SALESEXT
*      SALESEXTX            = SALESEXTX
*      POSDATA              = POSDATA                   "out
*      POSDATAX             = POSDATAX
**      POSEXT               = POSEXT
**      POSEXTX              = POSEXTX
**      MATERIALLONGTEXT     = MATERIALLONGTEXT
**      PLANTKEYS            = PLANTKEYS
**      STORAGELOCATIONKEYS  = STORAGELOCATIONKEYS
**      DISTRCHAINKEYS       = DISTRCHAINKEYS
**      WAREHOUSENOKEYS      = WAREHOUSENOKEYS
**      STORAGETYPEKEYS      = STORAGETYPEKEYS
**      VALUATIONTYPEKEYS    = VALUATIONTYPEKEYS
*    EXCEPTIONS                          "wichtig !!!
*      ERROR_MESSAGE        = 1.         "wichtig !!!
*  IF SY-SUBRC = 1.
**     damit werden S-, W- und I-Messages unterdrückt
**     (bei der Anlage der ersten(!) Variante für einen Sammelartikel
**      bricht sonst die Verarbeitung ab, weil W-Message MH087
**      prozessiert würde.)
*  ENDIF.
**
** Anpassung Schittstellentabellen für geänderte Status
*  PERFORM ADJUST_PREPARE_TO_STATUSCHANGE
*            TABLES MVKE_PREPARE_TAB MARC_PREPARE_TAB
*            USING  MARA_TAB_SAVE.
*
endform.                    " ism_maintaindate_rt_prepare




*&--------------------------------------------------------------------*
*&      Form  ISM_MAINTAIN_RETAIL
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->ERRMSG_TAB text
*      -->MVKE_PREPARtextB
*      -->MARC_PREPARtextB
*      -->I_TRANC_TABtext
*      -->MEDIAISSUE text
*      -->MARA_TAB_SAtext
*---------------------------------------------------------------------*
form ism_maintain_retail
       tables errmsg_tab
              mvke_prepare_tab structure mvke
              marc_prepare_tab structure marc
              i_tranc_tab      type tranc_tab
        using mediaissue
              mara_tab_save structure mara_ueb
              ls_jptmara type jptmara                       "TK01102006
    changing  jptmara_errmsg_tab type jp_merrdat_tab.       "TK01102006
*
  data: return like  bapireturn1. " STRUCTURE  BAPIRETURN1
  data: h_msgno_mara like syst-msgno.
  data: xcreated type xfeld.
  data: ls_tranc_stru like line of i_tranc_tab.
*
  call function 'BAPI_MATERIAL_MAINTAINDATA_RT'
    exporting
      headdata             = headdata
    importing
      return               = return
    tables
*      VARIANTSKEYS         = VARIANTSKEYS
*      CHARACTERISTICVALUE  = CHARACTERISTICVALUE
*      CHARACTERISTICVALUEX = CHARACTERISTICVALUEX
      clientdata           = clientdata
      clientdatax          = clientdatax
      clientext            = clientext                      "TK01102006
      clientextx           = clientextx                     "TK01102006
*      ADDNLCLIENTDATA      = ADDNLCLIENTDATA
*      ADDNLCLIENTDATAX     = ADDNLCLIENTDATAX
*      MATERIALDESCRIPTION  = MATERIALDESCRIPTION
      plantdata            = plantdata
      plantdatax           = plantdatax
      plantext             = plantext                       "TK01102006
      plantextx            = plantextx                      "TK01102006
*      FORECASTPARAMETERS   = FORECASTPARAMETERS
*      FORECASTPARAMETERSX  = FORECASTPARAMETERSX
*      FORECASTVALUES       = FORECASTVALUES
*      TOTALCONSUMPTION     = TOTALCONSUMPTION
*      UNPLNDCONSUMPTION    = UNPLNDCONSUMPTION
*      PLANNINGDATA         = PLANNINGDATA
*      PLANNINGDATAX        = PLANNINGDATAX
*      STORAGELOCATIONDATA  = STORAGELOCATIONDATA
*      STORAGELOCATIONDATAX = STORAGELOCATIONDATAX
*      STORAGELOCATIONEXT   = STORAGELOCATIONEXT
*      STORAGELOCATIONEXTX  = STORAGELOCATIONEXTX
*      UNITSOFMEASURE       = UNITSOFMEASURE
*      UNITSOFMEASUREX      = UNITSOFMEASUREX
*      UNITOFMEASURETEXTS   = UNITOFMEASURETEXTS
*      INTERNATIONALARTNOS  = INTERNATIONALARTNOS
*      VENDOREAN            = VENDOREAN
*      LAYOUTMODULEASSGMT   = LAYOUTMODULEASSGMT
*      LAYOUTMODULEASSGMTX  = LAYOUTMODULEASSGMTX
*      TAXCLASSIFICATIONS   = TAXCLASSIFICATIONS
*      VALUATIONDATA        = VALUATIONDATA
*      VALUATIONDATAX       = VALUATIONDATAX
*      VALUATIONEXT         = VALUATIONEXT
*      VALUATIONEXTX        = VALUATIONEXTX
*      WAREHOUSENUMBERDATA  = WAREHOUSENUMBERDATA
*      WAREHOUSENUMBERDATAX = WAREHOUSENUMBERDATAX
*      WAREHOUSENUMBEREXT   = WAREHOUSENUMBEREXT
*      WAREHOUSENUMBEREXTX  = WAREHOUSENUMBEREXTX
*      STORAGETYPEDATA      = STORAGETYPEDATA
*      STORAGETYPEDATAX     = STORAGETYPEDATAX
*      STORAGETYPEEXT       = STORAGETYPEEXT
*      STORAGETYPEEXTX      = STORAGETYPEEXTX
      salesdata            = salesdata
      salesdatax           = salesdatax
      salesext             = salesext                       "TK01102006
      salesextx            = salesextx                      "TK01102006
*      POSDATA              = POSDATA
*      POSDATAX             = POSDATAX
*      POSEXT               = POSEXT
*      POSEXTX              = POSEXTX
*      MATERIALLONGTEXT     = MATERIALLONGTEXT
*      PLANTKEYS            = PLANTKEYS
*      STORAGELOCATIONKEYS  = STORAGELOCATIONKEYS
*      DISTRCHAINKEYS       = DISTRCHAINKEYS
*      WAREHOUSENOKEYS      = WAREHOUSENOKEYS
*      STORAGETYPEKEYS      = STORAGETYPEKEYS
*      VALUATIONTYPEKEYS    = VALUATIONTYPEKEYS.
       .

  if return-type = 'S'.
*   Artikel wurde erfolgreich angelegt ==>

*   Commit für Einkaufsinfosätze notwendig
    call function 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

*   1.) MSD-Felder füllen
*     temporär werden IS-M-Felder direkt upgedatet---------Anfang---*
*     in MARA_TAB bzw. MARA_TAB_SAVE sind die Felder aus LF_DYNPRO_TAB
*     schon übertragen, die Datumsfelder müssen noch am Erscheinungs-
*     datum ausgerichtet werden)
    perform media_retail_fields_fill
             tables   mvke_prepare_tab                  "Vertr.ber.
                      marc_prepare_tab                  "Werke
                using " MAT_PATTERN_TAB-ISMMATNR_PATTERN  "Vorlage
                      mediaissue                        "neue MATNR
                      "VARIANT_TAB                       "hier dummy
                      "MAKT_STRU                         "Mat.kurztext
                      mara_tab_save           "MSD-aufbereitete MARA
                      "MEDPROD.                "Produkt
                      ls_jptmara                            "TK27062006
             changing jptmara_errmsg_tab.                   "TK27062006


*   hier keine weiteren Updates erforderlich
*   1.1.) XMARAEXIST in JPTMG     => hier nicht erforderlich
*   2.) Listung                   => hier nicht erforderlich
*   3.) Einkaufsinfosätze anlegen => hier nicht erforderlich
  else.
*   Retail-Bapi wird für JEDEN(!) Artikel aufgerufen(im Gegensatz zum
*   MAINTAIN_DARK für Industriematerialien)
*   => Fehler können artikelspezifisch protoklliert werden
*   Achtung: die Aufbereitung des Protokolles hängt an dem Feld TRANC,
*   das ist der Transaktionszähler, der für das Versorgen des
*   MAINTAIN_DARK notwendig ist. Im Retail Fall hier muß TRANC
*   für die Retail-Fehlermeldung dazugelesen werden!!
    if return-type = 'E' or return-type = 'A'.
*     Fehlermeldung ins Protokoll aufnehmen:
*     Im Retailfall kann die Fehler-Meldung nicht dem entsprechenden
*     Segment(MARA,MARC oder MVKE) zugeordnet werden => die Zuordnung
*     im Protokoll erfolgt deshalb generell auf MARA-Ebene, also für den
*     Transaktionszähler der MARA
      loop at i_tranc_tab into ls_tranc_stru
        where matnr = mara_tab_save-matnr.       "TK10022008/Hinw.1144233
*        and   marc_werks = space                "TK10022008/Hinw.1144233
*        and   mvke_vkorg = space                "TK10022008/Hinw.1144233
*        and   mvke_vtweg = space.               "TK10022008/Hinw.1144233
        exit.
      endloop.
      if sy-subrc = 0.
*       ERRMSG_TAB füllen mit Retail-Meldungen (lesen ALOG des BAPI)
        perform errmsg_tab_fill_by_retail tables errmsg_tab
                                          using  return-log_no
                                                 ls_tranc_stru
                                                 return.
      endif.
    endif.
  endif.
*
endform.                    "ISM_MAINTAIN_RETAIL


*&--------------------------------------------------------------------*
*&      Form  adjust_prepare_to_statuschange
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->MVKE_PREPARtextB
*      -->MARC_PREPARtextB
*      -->MARA_TAB_SAtext
*---------------------------------------------------------------------*
form adjust_prepare_to_statuschange
            tables mvke_prepare_tab structure mvke
                   marc_prepare_tab structure marc
            using  mara_tab_save structure mara_ueb .

*
  data: ls_clientdatax like  bapie1marartx.
  data: ls_clientdata like  bapie1marart.
  data: ls_plantdata like bapie1marcrt.
  data: ls_plantdatax like bapie1marcrtx.
  data: ls_salesdata like bapie1mvkert.
  data: ls_salesdatax like bapie1mvkertx.

  data: ls_save_clientdatax like  bapie1marartx.
  data: ls_save_clientdata like  bapie1marart.
  data: ls_save_plantdata like bapie1marcrt.
  data: ls_save_plantdatax like bapie1marcrtx.
  data: ls_save_salesdata like bapie1mvkert.
  data: ls_save_salesdatax like bapie1mvkertx.

  data: ls_marc   type marc,
        ls_mvke   type mvke.
*
* 1.) MARA:
* 1.a.)Änderungs-felder
  loop at clientdatax into ls_clientdatax.
    ls_save_clientdatax = ls_clientdatax.
    clear ls_clientdatax.     "Reset aller Änderungsfelder
*   Keyfelder wieder füllen
    ls_clientdatax-function = ls_save_clientdatax-function.
    ls_clientdatax-material = ls_save_clientdatax-material.
*   zu ändernde Felder(Statusfelder) markieren:
    ls_clientdatax-pur_status = con_angekreuzt.
    ls_clientdatax-pvalidfrom = con_angekreuzt.
    ls_clientdatax-sal_status = con_angekreuzt.
    ls_clientdatax-svalidfrom = con_angekreuzt.
    modify clientdatax from ls_clientdatax.
  endloop.
* 1.b.)Ausprägungen der zu ändernden Felder
  loop at clientdata into ls_clientdata.
    ls_save_clientdata = ls_clientdata.
    clear ls_clientdata.     "Reset aller Attribute
*   Keyfelder wieder füllen
    ls_clientdata-function = ls_save_clientdata-function.
    ls_clientdata-material = ls_save_clientdata-material.
*   zu ändernde Felder(Statusfelder) markieren:
    ls_clientdata-pur_status = mara_tab_save-mstae.
    ls_clientdata-pvalidfrom = mara_tab_save-mstde.
    ls_clientdata-sal_status = mara_tab_save-mstav.
    ls_clientdata-svalidfrom = mara_tab_save-mstdv.
    modify clientdata from ls_clientdata.
  endloop.
*
* 2.) MARC:
* 2.a.)Änderungs-felder
  loop at plantdatax into ls_plantdatax.
    ls_save_plantdatax = ls_plantdatax.
    clear ls_plantdatax.     "Reset aller Änderungsfelder
*   Keyfelder wieder füllen
    ls_plantdatax-function = ls_save_plantdatax-function.
    ls_plantdatax-material = ls_save_plantdatax-material.
    ls_plantdatax-plant    = ls_save_plantdatax-plant.
*   zu ändernde Felder(Statusfelder) markieren:
    ls_plantdatax-pur_status = con_angekreuzt.
    ls_plantdatax-pvalidfrom = con_angekreuzt.
    modify plantdatax from ls_plantdatax.
  endloop.
* 2.b.)Ausprägungen der zu ändernden Felder
  loop at plantdata into ls_plantdata.
    ls_save_plantdata = ls_plantdata.
    clear ls_plantdata.     "Reset aller Änderungsfelder
*   Keyfelder wieder füllen
    ls_plantdata-function = ls_save_plantdata-function.
    ls_plantdata-material = ls_save_plantdata-material.
    ls_plantdata-plant    = ls_save_plantdata-plant.
*   zu ändernde Felder(Statusfelder) markieren:
    read table marc_prepare_tab into ls_marc
      with key  matnr = ls_plantdata-material
                werks = ls_plantdata-plant.
    if sy-subrc  = 0.
      ls_plantdata-pur_status = ls_marc-mmsta.
      ls_plantdata-pvalidfrom = ls_marc-mmstd.
    endif.
    modify plantdata from ls_plantdata.
  endloop.
*
* 3.) MVKE:
* 3.a.)Änderungs-felder
  loop at salesdatax into ls_salesdatax.
    ls_save_salesdatax = ls_salesdatax.
    clear ls_salesdatax.     "Reset aller Änderungsfelder
*   Keyfelder wieder füllen
    ls_salesdatax-function   = ls_save_salesdatax-function.
    ls_salesdatax-material   = ls_save_salesdatax-material.
    ls_salesdatax-sales_org  = ls_save_salesdatax-sales_org.
    ls_salesdatax-distr_chan = ls_save_salesdatax-distr_chan.
*   zu ändernde Felder(Statusfelder) markieren:
    ls_salesdatax-sal_status = con_angekreuzt.
    ls_salesdatax-valid_from = con_angekreuzt.
    modify salesdatax from ls_salesdatax.
  endloop.
* 3.b.)Ausprägungen der zu ändernden Felder
  loop at salesdata into ls_salesdata.
    ls_save_salesdata = ls_salesdata.
    clear ls_salesdata.     "Reset aller Änderungsfelder
*   Keyfelder wieder füllen
    ls_salesdata-function   = ls_save_salesdatax-function.
    ls_salesdata-material   = ls_save_salesdatax-material.
    ls_salesdata-sales_org  = ls_save_salesdatax-sales_org.
    ls_salesdata-distr_chan = ls_save_salesdatax-distr_chan.
*   zu ändernde Felder(Statusfelder) markieren:
    read table mvke_prepare_tab into ls_mvke
      with key  matnr = ls_salesdata-material
                vkorg = ls_salesdata-sales_org
                vtweg = ls_salesdata-distr_chan .
    if sy-subrc  = 0.
      ls_salesdata-sal_status = ls_mvke-vmsta.
      ls_salesdata-valid_from = ls_mvke-vmstd.
    endif.
    modify salesdata from ls_salesdata.
  endloop.
*
endform.                    "adjust_prepare_to_statuschange


*&--------------------------------------------------------------------*
*&      Form  prepare_rt_for_statuschange
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->MVKE_PREPARtextB
*      -->MARC_PREPARtextB
*      -->MARA_TAB_SAtext
*---------------------------------------------------------------------*
form prepare_rt_for_statuschange
            tables mvke_prepare_tab structure mvke
                   marc_prepare_tab structure marc
            using  mara_tab_save structure mara_ueb .
*
  data: ls_clientdatax like  bapie1marartx.
  data: ls_clientdata like  bapie1marart.
  data: ls_plantdata like bapie1marcrt.
  data: ls_plantdatax like bapie1marcrtx.
  data: ls_salesdata like bapie1mvkert.
  data: ls_salesdatax like bapie1mvkertx.

  data: ls_save_clientdatax like  bapie1marartx.
  data: ls_save_clientdata like  bapie1marart.
  data: ls_save_plantdata like bapie1marcrt.
  data: ls_save_plantdatax like bapie1marcrtx.
  data: ls_save_salesdata like bapie1mvkert.
  data: ls_save_salesdatax like bapie1mvkertx.

  data: ls_marc   type marc,
        ls_mvke   type mvke.

  data: con_function type msgfn value '005'.                "TK01102006
  data: ls_mara type mara.                                  "TK01102006
*

* break kast.
*


* 1.) HEADDATA füllen
  clear headdata.
  headdata-material     = mara_tab_save-matnr.
*  headdat-MATL_TYPE    =
*  headdat-MATL_GROUP   =
*  headdat-MATL_CAT     =
  headdata-basic_view   = con_angekreuzt.
  headdata-list_view    = con_angekreuzt.
  headdata-sales_view   = con_angekreuzt.
  headdata-logdc_view   = con_angekreuzt.
  headdata-logst_view   = con_angekreuzt.
  headdata-pos_view     = con_angekreuzt.




* neue Version---------MARA-------------- Anfang-----"TK01102006

** 2.) ClIENTDATA und ClIENTDATAX
** 2.a.)Änderungs-felder
*  CLEAR CLIENTDATAX. REFRESH CLIENTDATAX.
*  CLEAR LS_CLIENTDATAX.     "Reset aller Änderungsfelder
** Keyfelder füllen
*  LS_CLIENTDATAX-FUNCTION = con_function.                   " '005' .
*  LS_CLIENTDATAX-MATERIAL = MARA_TAB_SAVE-MATNR.
** zu ändernde Felder(Statusfelder) markieren:
*  LS_CLIENTDATAX-PUR_STATUS = CON_ANGEKREUZT.
*  LS_CLIENTDATAX-PVALIDFROM = CON_ANGEKREUZT.
*  LS_CLIENTDATAX-SAL_STATUS = CON_ANGEKREUZT.
*  LS_CLIENTDATAX-SVALIDFROM = CON_ANGEKREUZT.
*  APPEND LS_CLIENTDATAX TO CLIENTDATAX.
** 2.b.)Ausprägungen der zu ändernden Felder
*  CLEAR CLIENTDATA. REFRESH CLIENTDATA.
*  CLEAR LS_CLIENTDATA.     "Reset aller Änderungsfelder
** Keyfelder füllen
*  LS_CLIENTDATA-FUNCTION = con_function.                    "  '005' .
*  LS_CLIENTDATA-MATERIAL = MARA_TAB_SAVE-MATNR.
** zu ändernde Felder füllen:
*  LS_CLIENTDATA-PUR_STATUS = MARA_TAB_SAVE-MSTAE.
*  LS_CLIENTDATA-PVALIDFROM = MARA_TAB_SAVE-MSTDE.
*  LS_CLIENTDATA-SAL_STATUS = MARA_TAB_SAVE-MSTAV.
*  LS_CLIENTDATA-SVALIDFROM = MARA_TAB_SAVE-MSTDV.
*  APPEND LS_CLIENTDATA TO CLIENTDATA.

* kann ev. auch  nur aktiviert werden, wenn BADi aktiv ist
* (unschön: ALLE(!) Felder in plantdatax werden auf "zu ändern" gesetzt,
*           was eine Flut von "unbegründeten" Warnungen produziert, daß
*           viele Felder nicht änderbar sind!!

  clear clientdatax. refresh clientdatax.
  clear clientdata. refresh clientdata.

  move-corresponding mara_tab_save to ls_mara.

  call function 'MAP2E_MARA_TO_BAPIE1MARART'
    EXPORTING
      mara         = ls_mara
    CHANGING
      bapie1marart = ls_clientdata.
  .
  ls_clientdata-function = con_function .
  append ls_clientdata to clientdata.

  translate ls_clientdatax using ' X'.

* Anpassung zu EHP5-------------------------Anfang  "TK01072009
  if cl_retail_switch_check=>isr_appl_promo_sfws( ) is initial.
    clear ls_clientdatax-allow_pmat_igno.
  endif.
* Anpassung zu EHP5-------------------------Ende    "TK01072009

  ls_clientdatax-function = ls_clientdata-function.
  ls_clientdatax-material = ls_clientdata-material.

  append ls_clientdatax to clientdatax.

* neue Version---------MARA-------------- Ende-------"TK01102006


* neue Version---------MARC-------------- Anfang-----"TK01102006

* 3.) PLANTDATA und PLANTDATAX
*  CLEAR PLANTDATAX. REFRESH PLANTDATAX.
*  CLEAR PLANTDATA. REFRESH PLANTDATA.
*  LOOP AT MARC_PREPARE_TAB INTO LS_MARC
*      WHERE MATNR = MARA_TAB_SAVE-MATNR.
**   3.a.)Änderungs-felder
*    CLEAR LS_PLANTDATAX.
**   Keyfelder wieder füllen
*    LS_PLANTDATAX-FUNCTION = '005'.
*    LS_PLANTDATAX-MATERIAL = LS_MARC-MATNR.
*    LS_PLANTDATAX-PLANT    = LS_MARC-WERKS.
**   zu ändernde Felder(Statusfelder) markieren:
*    LS_PLANTDATAX-PUR_STATUS = CON_ANGEKREUZT.
*    LS_PLANTDATAX-PVALIDFROM = CON_ANGEKREUZT.
*    APPEND LS_PLANTDATAX TO PLANTDATAX.
**   3.b.)Ausprägungen der zu ändernden Felder
*    CLEAR LS_PLANTDATA.
**   Keyfelder füllen
*    LS_PLANTDATA-FUNCTION = '005'.
*    LS_PLANTDATA-MATERIAL = LS_MARC-MATNR.
*    LS_PLANTDATA-PLANT    = LS_MARC-WERKS.
**   zu ändernde Felder füllen:
*    LS_PLANTDATA-PUR_STATUS = LS_MARC-MMSTA.
*    LS_PLANTDATA-PVALIDFROM = LS_MARC-MMSTD.
*    APPEND LS_PLANTDATA TO PLANTDATA.
*  ENDLOOP.

* kann ev. auch  nur aktiviert werden, wenn BADi aktiv ist
* (unschön: ALLE(!) Felder in plantdatax werden auf "zu ändern" gesetzt,
*           was eine Flut von "unbegründeten" Warnungen produziert, daß
*           viele Felder nicht änderbar sind!!

  data: it001w type t001w.
  data: it001k type t001k.
  data: it001  type t001.
*
  clear plantdatax. refresh plantdatax.
  clear plantdata. refresh plantdata.
  loop at marc_prepare_tab into ls_marc
      where matnr = mara_tab_save-matnr.
*   Currency des Werkes ermitteln
    call function 'T001W_SINGLE_READ'
      EXPORTING
        t001w_werks = ls_marc-werks
      IMPORTING
        wt001w      = it001w
      EXCEPTIONS
        not_found   = 1
        others      = 2.

    if sy-subrc = 0.
      call function 'T001K_SINGLE_READ'
        EXPORTING
          bwkey      = it001w-bwkey
        IMPORTING
          wt001k     = it001k
        EXCEPTIONS
          not_found  = 1
          wrong_call = 2
          others     = 3.

      if sy-subrc = 0.
        call function 'T001_SINGLE_READ'
          EXPORTING
            bukrs      = it001k-bukrs
          IMPORTING
            wt001      = it001
          EXCEPTIONS
            not_found  = 1
            wrong_call = 2
            others     = 3.
      endif.
    endif.

    call function 'MAP2E_MARC_TO_BAPIE1MARCRT'
      EXPORTING
        marc                         = ls_marc
        currency                     = it001-waers
      CHANGING
        bapie1marcrt                 = ls_plantdata
      EXCEPTIONS
        error_converting_curr_amount = 1
        others                       = 2.
    if sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.

    ls_plantdata-function = con_function .
    append ls_plantdata to plantdata.

    translate ls_plantdatax using ' X'.
    ls_plantdatax-function = ls_plantdata-function.
    ls_plantdatax-material = ls_plantdata-material.
    ls_plantdatax-plant    = ls_plantdata-plant.

    append ls_plantdatax to plantdatax.

  endloop.
* neue Version---------MARC-------------- Ende-------"TK01102006


* neue Version---------MVKE-------------- Anfang-----"TK01102006

** 4.) SALESDATA und SALESDATAX
*  CLEAR SALESDATAX. REFRESH SALESDATAX.
*  CLEAR SALESDATA. REFRESH SALESDATA.
*  LOOP AT MVKE_PREPARE_TAB INTO LS_MVKE
*      WHERE MATNR = MARA_TAB_SAVE-MATNR.
**   4.a.)Änderungs-felder
*    CLEAR LS_SALESDATAX.
**   Keyfelder wieder füllen
*    LS_SALESDATAX-FUNCTION   = '005'.
*    LS_SALESDATAX-MATERIAL   = LS_MVKE-MATNR.
*    LS_SALESDATAX-SALES_ORG  = LS_MVKE-VKORG.
*    LS_SALESDATAX-DISTR_CHAN = LS_MVKE-VTWEG.
**   zu ändernde Felder(Statusfelder) markieren:
*    LS_SALESDATAX-SAL_STATUS = CON_ANGEKREUZT.
*    LS_SALESDATAX-VALID_FROM = CON_ANGEKREUZT.
*    APPEND LS_SALESDATAX TO SALESDATAX.
**   4.b.)Ausprägungen der zu ändernden Felder
*    CLEAR LS_SALESDATA.
**   Keyfelder wieder füllen
*    LS_SALESDATA-FUNCTION   = '005'.
*    LS_SALESDATA-MATERIAL   = LS_MVKE-MATNR.
*    LS_SALESDATA-SALES_ORG  = LS_MVKE-VKORG.
*    LS_SALESDATA-DISTR_CHAN = LS_MVKE-VTWEG.
**   zu ändernde Felder(Statusfelder) markieren:
*    LS_SALESDATA-SAL_STATUS = LS_MVKE-VMSTA.
*    LS_SALESDATA-VALID_FROM = LS_MVKE-VMSTD.
*    APPEND LS_SALESDATA TO SALESDATA.
*  ENDLOOP.
*

* kann ev. auch  nur aktiviert werden, wenn BADi aktiv ist
* (unschön: ALLE(!) Felder in plantdatax werden auf "zu ändern" gesetzt,
*           was eine Flut von "unbegründeten" Warnungen produziert, daß
*           viele Felder nicht änderbar sind!!

  clear salesdatax. refresh salesdatax.
  clear salesdata. refresh salesdata.
  loop at mvke_prepare_tab into ls_mvke
      where matnr = mara_tab_save-matnr.

    call function 'MAP2E_MVKE_TO_BAPIE1MVKERT'
      EXPORTING
        mvke         = ls_mvke
      CHANGING
        bapie1mvkert = ls_salesdata.

    ls_salesdata-function = con_function .
    append ls_salesdata to salesdata.

    translate ls_salesdatax using ' X'.
    ls_salesdatax-function      = ls_salesdata-function.
    ls_salesdatax-material      = ls_salesdata-material.
    ls_salesdatax-sales_org     = ls_salesdata-sales_org.
    ls_salesdatax-distr_chan    = ls_salesdata-distr_chan.

    append ls_salesdatax to salesdatax.

  endloop.

* neue Version---------MVKE-------------- Ende-------"TK01102006

* neu: Medienfelder intergiert im BAPI ---Anfang---  "TK01102006
  data : lv_ism_mara type rjmaramapping ,
         lv_ism_marax type rjmaramappingx ,
         lv_ism_marc_tab type rjmarcmapping_tab ,
         lv_ism_marcx_tab type rjmarcmappingx_tab ,
         lv_ism_mvke_tab type rjmvkemapping_tab ,
         lv_ism_mvkex_tab type rjmvkemappingx_tab .

  clear clientext.   refresh clientext.
  clear clientextx.  refresh clientextx.
  clear plantext.    refresh plantext.
  clear plantextx.   refresh plantextx.
  clear salesext.    refresh salesext.
  clear salesextx.   refresh salesextx.

  call function 'ISM_SD_MAP_TO_ART_BAPI_PREPARE'
    EXPORTING
      iv_matnr          = mara_tab_save-matnr
      is_mara           = ls_mara
      it_marc           = marc_prepare_tab[]
      it_mvke           = mvke_prepare_tab[]
    IMPORTING
      es_ism_bapi_mara  = lv_ism_mara
      es_ism_bapi_marax = lv_ism_marax
      et_ism_bapi_marc  = lv_ism_marc_tab[]
      et_ism_bapi_marcx = lv_ism_marcx_tab[]
      et_ism_bapi_mvke  = lv_ism_mvke_tab[]
      et_ism_bapi_mvkex = lv_ism_mvkex_tab[].

  call function 'ISM_SD_MAP_OUTSIDE_ART_BAPI'
    EXPORTING
      iv_matnr            = mara_tab_save-matnr
      is_ism_bapi_mara    = lv_ism_mara
      is_ism_bapi_marax   = lv_ism_marax
      it_ism_bapi_marc    = lv_ism_marc_tab[]
      it_ism_bapi_marcx   = lv_ism_marcx_tab[]
      it_ism_bapi_mvke    = lv_ism_mvke_tab[]
      it_ism_bapi_mvkex   = lv_ism_mvkex_tab[]
    IMPORTING
      et_bapi_clientext   = clientext[]
      et_bapi_clientextx  = clientextx[]
      et_bapi_plantext    = plantext[]
      et_bapi_plantextx   = plantextx[]
      et_bapi_salesext    = salesext[]
      et_bapi_salesextx   = salesextx[]
    CHANGING
      ct_bapi_clientdata  = clientdata[]
      ct_bapi_clientdatax = clientdatax[]
      ct_bapi_plantdata   = plantdata[]
      ct_bapi_plantdatax  = plantdatax[]
      ct_bapi_salesdata   = salesdata[]
      ct_bapi_salesdatax  = salesdatax[].

* neu: Medienfelder intergiert im BAPI ---Ende-----  "TK01102006

*--BADI für Kunden-Appends--------- Anfang --------------- "TK05022009
  data: issue_appends_map_outside
           type ref to ism_issue_appends_map_outside.  "#EC NEEDED
  data:  oref   type ref to cx_root,
         text   type string.
  data: append_clientext type bapie1maraextrt_tab.
  data: append_clientextx type bapie1maraextrtx_tab.
  data: append_plantext type bapie1marcextrt_tab.
  data: append_plantextx type bapie1marcextrtx_tab.
  data: append_salesext type bapie1mvkeextrt_tab.
  data: append_salesextx type bapie1mvkeextrtx_tab.

  data: in_mara type mara.
  data: in_marc_Tab type ISM_MARC_DB_TAB.
  data: in_mvke_Tab type ISM_Mvke_DB_TAB.

* Aufruf VOR(!!) dem Create Object!!
  try.
      get badi issue_appends_map_outside.
    catch cx_badi_not_implemented into oref.
      text = oref->get_text( ).
    catch cx_badi_multiply_implemented into oref.
      text = oref->get_text( ).
  endtry.
*
* aufruf Badi für Mapping Kundenappends in EXT-STrukturen des BAPI
  if not issue_appends_map_outside is initial.

    in_mara = mara_Tab_Save.
    in_marc_tab[] = marc_prepare_tab[].
    in_mvke_tab[] = mvke_prepare_tab[].

*   Im Kontext der Worlist sind NUR Mara,Marc,Mvke unterstützt!

    call badi issue_appends_map_outside->map_appends_to_ext
      exporting
        in_context_tcode  = sy-tcode
        in_mara           = in_mara
        in_marc_tab       = in_marc_tab
        in_mvke_tab       = in_mvke_tab
      changing
        ch_clientext      = append_clientext
        ch_clientextx     = append_clientextx
        ch_plantext       = append_plantext
        ch_plantextx      = append_plantextx
        ch_salesext       = append_salesext
        ch_salesextx      = append_salesextx.
*
    append lines of append_clientext  to clientext.
    append lines of append_clientextx to clientextx.
    append lines of append_plantext   to plantext.
    append lines of append_plantextx  to plantextx.
    append lines of append_salesext   to salesext.
    append lines of append_salesextx  to salesextx.

*
  endif.
*
*--BADI für Kunden-Appends--------- Anfang --------------- "TK05022009


endform.                    "prepare_rt_for_statuschange

*&--------------------------------------------------------------------*
*&      Form  ERRMSG_TAB_FILL_BY_RETAIL
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->ERRMSG_TAB text
*      -->P_LOG_NO   text
*      -->LS_TRANC_STtext
*---------------------------------------------------------------------*
form errmsg_tab_fill_by_retail tables  errmsg_tab structure merrdat
                                using    p_log_no
                                ls_tranc_stru type tranc_type
                                return type bapireturn1.
*
  data: lt_lognumbers       type szal_lognumbers.
  data: lt_balm             like          balm    occurs 0.
  data: ls_balm             like line of  lt_balm.
  data: ls_lognumber        type szal_lognumber.
  data: errmsg_stru type merrdat.
  data: h_matnr type matnr.

*   Die Meldungen zum aktuellen Protokoll lesen
  clear lt_lognumbers[].
  clear lt_balm[].
  ls_lognumber-item = p_log_no.

  append ls_lognumber to lt_lognumbers.

*
  call function 'APPL_LOG_READ_DB_WITH_LOGNO'
    TABLES
      lognumbers = lt_lognumbers
      messages   = lt_balm.
*

* Ausgabe der "original"-Fehlermeldung des Retail-Bapi(RETURN)
  clear errmsg_stru.
  errmsg_stru-tranc         = ls_tranc_stru-tranc.
  errmsg_stru-matnr         = ls_tranc_stru-matnr.  "H_MATNR.
  errmsg_stru-msgty         = return-type.
  errmsg_stru-msgid         = return-id.
  errmsg_stru-msgno         = return-number.
  errmsg_stru-msgv1         = return-message_v1.
  errmsg_stru-msgv2         = return-message_v2.
  errmsg_stru-msgv3         = return-message_v3.
  errmsg_stru-msgv4         = return-message_v4 .
  append errmsg_stru to errmsg_tab.

* Es wird generell für jeden Artikel eine Info-Nachricht ausgegeben,
* unter welcher Nummer der Anwendunglog(SLG1) nachzulesen ist.
* Grund:
* Vor allem im Fehlerfall können im aufführlichen ALOG die betroffenen
* Segmente identifiziert werden (das aufbereitete Protokoll dieser
* Statusänderungen ist für Retail nicht segmentspezifisch.)
  clear errmsg_stru.
  errmsg_stru-tranc         = ls_tranc_stru-tranc.
  errmsg_stru-matnr         = ls_tranc_stru-matnr.  "H_MATNR.
  errmsg_stru-msgty         = 'I'.
  errmsg_stru-msgid         = 'JKSDWORKLIST'.
  errmsg_stru-msgno         = '043'.
  errmsg_stru-msgv1         = ls_tranc_stru-matnr.
  errmsg_stru-msgv2         = p_log_no.               .
* ERRMSG_STRU-MSGV3         = LS_BALM-MSGV3               .
* ERRMSG_STRU-MSGV4         = LS_BALM-MSGV4               .
* ERRMSG_stru-class         = ls_balm-probclass  ?????           .

  append errmsg_stru to errmsg_tab.


*   und ebenfalls abbilden
  loop at lt_balm into ls_balm.
*    IF LS_BALM-MSGID = 'MG'  AND LS_BALM-MSGNO = '541'.
**       wenn ALOG nicht anders gecustomized, dann beginnen mit MG541
**       alle Meldungen zur Variante MSGV1 (alle Folgemeldungen (bis zur
**       nächsten MG541) beziehen sich auf die Variante)
*      H_MATNR = LS_BALM-MSGV1.
*    ENDIF.
    clear errmsg_stru.
    errmsg_stru-tranc         = ls_tranc_stru-tranc.
    errmsg_stru-matnr         = ls_tranc_stru-matnr.  "H_MATNR.
    errmsg_stru-msgty         = ls_balm-msgty               .
    errmsg_stru-msgid         = ls_balm-msgid               .
    errmsg_stru-msgno         = ls_balm-msgno               .
    errmsg_stru-msgv1         = ls_balm-msgv1               .
    errmsg_stru-msgv2         = ls_balm-msgv2               .
    errmsg_stru-msgv3         = ls_balm-msgv3               .
    errmsg_stru-msgv4         = ls_balm-msgv4               .
*      ERRMSG_stru-class         = ls_balm-probclass  ?????           .

    append errmsg_stru to errmsg_tab.

  endloop.

*
endform.                    " errmsg_tab_fill_by_retail

*&--------------------------------------------------------------------*
*&      Form  MEDIA_RETAIL_FIELDS_FILL
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->MVKE_PREPARtextB
*      -->MARC_PREPARtextB
*      -->NEW_MATNR  text
*      -->MARA_TAB_SAtext
*---------------------------------------------------------------------*
form media_retail_fields_fill
            tables mvke_prepare_tab structure mvke
                   marc_prepare_tab structure marc
            using " PATTERN_MATNR                            "Vorlage
                  new_matnr                                "neue MATNR
                  "VARIANT_TAB TYPE JMM_VARIANTS_TAB
                  "MAKT_STRU TYPE MAKT
                  mara_tab_save structure mara_ueb
                  "MEDPROD TYPE MARA.
                  ls_jptmara type jptmara                   "TK01102006
        changing  jptmara_errmsg_tab type jp_merrdat_tab.   "TK01102006

*
* DATA: JPTMARA_PATTERN_STRU TYPE JPTMARA.
  data: marc_stru type marc.
  data: mvke_stru type mvke.
*
*** ohne Commit sind die Artikel nicht vorhanden
*** (vermtlicn arbeitet der Retail-Bapi mit PERFORM ON COMMIT)
**  commit work.
**

* Medienfelder sind im Retail-BAPI integriert --- Anfang--------"TK01102006

** 1.) MARA-Updates der MSD-Felder
*
*** Ev JPTMARA nachlesen : momentan nicht erforderlich
**  select single * from jptmara into jptmara_pattern_Stru
**    where matnr = PATTERN_MATNR.
**
*  UPDATE MARA
*    SET
*        ISMINITSHIPDATE    = MARA_TAB_SAVE-ISMINITSHIPDATE
*        ismcopynr          = MARA_TAB_SAVE-ISMCOPYNR
*    WHERE MATNR = NEW_MATNR.
**
** 2.) Marc-updates der MSD-Felder
**     (MARC_PREPARE_TAB ist bzgl der MSD-Eingabefelder schon
**      atualisiert
*  LOOP  AT MARC_PREPARE_TAB INTO MARC_STRU
*    WHERE MATNR = NEW_MATNR.
*    UPDATE MARC
*      SET
*        ISMARRIVALDATEPL   = MARC_STRU-ISMARRIVALDATEPL
*        ISMARRIVALDATEAC   = MARC_STRU-ISMARRIVALDATEAC
*        ISMPURCHASEDATE    = MARC_STRU-ISMPURCHASEDATE
*      WHERE MATNR = MARC_STRU-MATNR
*      AND   WERKS = MARC_STRU-WERKS.
*  ENDLOOP.
**
** 3.) Mvke-updates der MSD-Felder
**     (MVKE_PREPARE_TAB ist bzgl der MSD-Eingabefelder schon
**      atualisiert
*  LOOP  AT MVKE_PREPARE_TAB INTO MVKE_STRU
*    WHERE MATNR = NEW_MATNR.
**
**
*    UPDATE MVKE
*      SET
*        ISMRETURNBEGIN     = MVKE_STRU-ISMRETURNBEGIN
*        ISMRETURNEND       = MVKE_STRU-ISMRETURNEND
*        ISMMATRETURN       = MVKE_STRU-ISMMATRETURN         "TK13022006
*        ISMINTERRUPT       = MVKE_STRU-ISMINTERRUPT
*        ISMINITSHIPDATE    = MVKE_STRU-ISMINITSHIPDATE
*        ISMONSALEDATE      = MVKE_STRU-ISMONSALEDATE
*        ISMOFFSALEDATE     = MVKE_STRU-ISMOFFSALEDATE
*        ISMINTERRUPTDATE   = MVKE_STRU-ISMINTERRUPTDATE
**       ISMCOLLDATE        = MVKE_STRU-ISMCOLLDATE         "TK08082005
*      WHERE MATNR = MVKE_STRU-MATNR
*      AND   VKORG = MVKE_STRU-VKORG
*      AND   VTWEG = MVKE_STRU-VTWEG.
*  ENDLOOP.

* Medienfelder sind im Retail-BAPI integriert --- Ende----------"TK01102006


*4.) JPTMARA-insert                                         "TK27062006
* =========================                                 "TK27062006
  data: rc type subrc.                                      "TK27062006
  if not ls_jptmara is initial.                             "TK27062006
    perform jptmara_maintain using ls_jptmara               "TK27062006
                          changing jptmara_errmsg_tab rc .  "TK27062006
  endif. " not ls_jptmara is initial.                       "TK27062006
*
endform. "media_retail_fields_fill

* ------------------------------------- Anfang ------------"TK18022005
form badi_plausis tables  in_mara_tab type amara_tab
                          in_marc_tab type amarc_tab
                          in_mvke_tab type amvke_tab
                          out_badi_error_tab.
*
  data: in_badi_mara_tab type jp_mara_ueb_tab.
  data: in_badi_marc_tab type jp_marc_ueb_tab.
  data: in_badi_mvke_tab type jp_mvke_ueb_tab.

* Schnittstellen füllen
  in_badi_mara_tab[] = in_mara_tab[].
  in_badi_marc_tab[] = in_marc_tab[].
  in_badi_mvke_tab[] = in_mvke_tab[].

* aufruf Badi für Plausibilitäten
  if not exit_worklist_checks is initial.
    call badi exit_worklist_checks->check_worklist
      EXPORTING
        in_badi_mara_tab   = in_badi_mara_tab
        in_badi_marc_tab   = in_badi_marc_tab
        in_badi_mvke_tab   = in_badi_mvke_tab
      IMPORTING
        out_badi_error_tab = out_badi_error_tab.
  endif.

endform. " badi_plausis changing lt_badi_ERRor.

*&--------------------------------------------------------------------*
*&      Form  badi_tables_prepare
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->I_AMARA_UEBtext
*      -->I_AMARC_UEBtext
*      -->I_AMVKE_UEBtext
*      -->IN_MARA_TABtext
*      -->IN_MARC_TABtext
*      -->IN_MVKE_TABtext
*---------------------------------------------------------------------*
form badi_tables_prepare   tables i_amara_ueb type amara_tab
                                  i_amarc_ueb type amarc_tab
                                  i_amvke_ueb type amvke_tab
                                  in_mara_tab  type amara_tab
                                  in_marc_tab  type amarc_tab
                                  in_mvke_tab  type amvke_tab.
*
  data   ls_tranc type ls_tranc.
  data:  lt_tranc type lt_tranc.
  data: ls_marc like line of in_marc_tab.
  data: ls_mvke like line of in_mvke_tab.
  data: ls_mara like line of in_mara_tab.
*
* I_MARC_UEB enthält alle geänderten MARC-Segmente
  in_marc_tab[] = i_amarc_ueb[].
  loop at in_marc_tab into ls_marc.
    ls_tranc = ls_marc-tranc.
    append ls_tranc to lt_tranc.
  endloop.
* I_MVKE_UEB enthält alle geänderten MVKE-Segmente
  in_mvke_tab[] = i_amvke_ueb[].
  loop at in_mvke_tab into ls_mvke.
    ls_tranc = ls_mvke-tranc.
    append ls_tranc to lt_tranc.
  endloop.
*
* Es werden jetzt die Mara-Segmente aus I_MARA_UEB herausgefiltert,
* für die tatsächlich Änderungen erfolgt sind:
  sort lt_tranc.
  loop at i_amara_ueb into ls_mara.
    read table lt_tranc into ls_tranc with key ls_mara-tranc.
    if sy-subrc <> 0.
*     MARA-Satz wurde direkt geänder (Eintrag in I_AMARA_UEB resultiert
*     NICHT aus MARC- oder MVKE-Änderung)
      append ls_mara to in_mara_tab.
    endif.
  endloop.
*
endform. " badi_tables_prepare


*&--------------------------------------------------------------------*
*&      Form  maintain_dark_Tables_adjust
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->ERRMSG_TAB text
*      -->OUT_BADI_ERtextTAB
*      -->I_AMARA_UEBtext
*      -->I_AMARC_UEBtext
*      -->I_AMVKE_UEBtext
*---------------------------------------------------------------------*
form maintain_dark_tables_adjust
                           tables errmsg_tab
                                  out_badi_error_tab
                                  i_amara_ueb type amara_tab
                                  i_amarc_ueb type amarc_tab
                                  i_amvke_ueb type amvke_tab .

*
  data: errmsg_stru type errmsg_stru.
  data   ls_tranc_del type ls_tranc.
  data:  lt_tranc_del type lt_tranc.
  data: ls_marc like line of i_amarc_ueb.
  data: ls_mvke like line of i_amvke_ueb.
  data: ls_mara like line of i_amara_ueb.

*
* Segmente mit BADI-Fehlern merken
  if not out_badi_error_tab[] is initial.
    loop at out_badi_error_tab into errmsg_stru.
*     Transaktionszähler (der BADI-Fehlermeldungen) merken
      ls_tranc_del = errmsg_stru-tranc.
      append ls_tranc_del to lt_tranc_del.
    endloop.
  endif.
*
* Feherhafte Segmente aus MAINTAIN_DARK-Tabellen löschen
  sort lt_tranc_del.
  loop at i_amara_ueb into ls_mara.
    read table lt_tranc_del into ls_tranc_del with key ls_mara-tranc
         binary search.
    if sy-subrc = 0.
*       Badi bringt Fehler für MARA-Satz hat Fehler
*       => KEIN MARA-Update (Eintrag in I_AMARA_UEB löschen)
      delete i_amara_ueb.
    endif.
  endloop.
  loop at i_amarc_ueb into ls_marc.
    read table lt_tranc_del into ls_tranc_del with key ls_marc-tranc
         binary search.
    if sy-subrc = 0.
*       Badi bringt Fehler für MARA-Satz hat Fehler
*       => KEIN MARA-Update (Eintrag in I_AMARA_UEB löschen)
      delete i_amarc_ueb.
    endif.
  endloop.
  loop at i_amvke_ueb into ls_mvke.
    read table lt_tranc_del into ls_tranc_del with key ls_mvke-tranc
         binary search.
    if sy-subrc = 0.
*       Badi bringt Fehler für MARA-Satz hat Fehler
*       => KEIN MARA-Update (Eintrag in I_AMARA_UEB löschen)
      delete i_amvke_ueb.
    endif.
  endloop.

*
endform. " maintain_dark_Tables_adjust

* ------------------------------------- Ende---------------"TK18022005


* ev. neue BADI Felder-----------------Anfang ----------"TK01102006
form check_badifield_changed using ls_statustab type  jksdmaterialstatus
                                 ls_dbtab  type jksdmaterialstatus
                                 p_fieldname
                        changing x_badifield_change.
**
  field-symbols: <value> type any.
  data:     ls_statustab_strucname(100) value 'LS_STATUSTAB-',
            ls_dbtab_strucname(100) value 'LS_DBTAB-',
            ls_statustab_fieldname(100),
            ls_dbtab_fieldname(100),
            lv_new_value(100),    "setzuff  welcher Typ hier ???????
            lv_old_value(100).    "setzuff  welcher Typ hier ???????
*
* neuer Wert in LS_STATUSTAB
  concatenate ls_statustab_strucname p_fieldname into ls_statustab_fieldname.
  assign (ls_statustab_fieldname) to <value>.
  lv_new_value = <value>.
* alter Wert in LS_DBTAB
  concatenate ls_dbtab_strucname p_fieldname into ls_dbtab_fieldname.
  assign (ls_dbtab_fieldname) to <value>.
  lv_old_value = <value>.
* Vergleich
  if lv_new_value <> lv_old_value.
    x_badifield_change = con_angekreuzt.
  endif.
*
endform. " check_badifield_changed

*&---------------------------------------------------------------------*
*&      Form  marc_badifields_to_h_marc
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_STATUSTAB  text
*      -->H_MARC        text
*      -->P_FIELDNAME   text
*----------------------------------------------------------------------*
form marc_badifields_to_h_marc using ls_statustab type  jksdmaterialstatus
                                     h_marc  type marc
                                     p_fieldname .
**
  field-symbols: <value> type any.
  data:     ls_statustab_strucname(100) value 'LS_STATUSTAB-',
            ls_h_marc_strucname(100) value 'H_MARC-',
            ls_statustab_fieldname(100),
            ls_h_marc_fieldname(100),
            lv_new_value(100),    "setzuff  welcher Typ hier ???????
            lv_old_value(100).    "setzuff  welcher Typ hier ???????
*
* neuer Wert in LS_STATUSTAB
  concatenate ls_statustab_strucname p_fieldname into ls_statustab_fieldname.
  assign (ls_statustab_fieldname) to <value>.
  lv_new_value = <value>.
* alter Wert in H_MARC durch neuen Wert ersetzen
  shift p_fieldname by 5 places.
  concatenate ls_h_marc_strucname p_fieldname into ls_h_marc_fieldname.
  assign (ls_h_marc_fieldname) to <value>.
  <value>  = lv_new_value..
*
endform. " marc_badifields_to_h_marc

*&---------------------------------------------------------------------*
*&      Form  mvke_badifields_to_h_mvke
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_STATUSTAB  text
*      -->H_MVKE        text
*      -->P_FIELDNAME   text
*----------------------------------------------------------------------*
form mvke_badifields_to_h_mvke using ls_statustab type  jksdmaterialstatus
                                     h_mvke  type mvke
                                     p_fieldname .
**
  field-symbols: <value> type any.
  data:     ls_statustab_strucname(100) value 'LS_STATUSTAB-',
            ls_h_mvke_strucname(100) value 'H_MVKE-',
            ls_statustab_fieldname(100),
            ls_h_mvke_fieldname(100),
            lv_new_value(100),    "setzuff  welcher Typ hier ???????
            lv_old_value(100).    "setzuff  welcher Typ hier ???????
*
* neuer Wert in LS_STATUSTAB
  concatenate ls_statustab_strucname p_fieldname into ls_statustab_fieldname.
  assign (ls_statustab_fieldname) to <value>.
  lv_new_value = <value>.
* alter Wert in H_MVKE durch neuen Wert ersetzen
  shift p_fieldname by 5 places.
  concatenate ls_h_mvke_strucname p_fieldname into ls_h_mvke_fieldname.
  assign (ls_h_mvke_fieldname) to <value>.
  <value>  = lv_new_value..
*
endform. " mvke_badifields_to_h_mvke


*&---------------------------------------------------------------------*
*&      Form  mara_badifields_to_h_mara
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_STATUSTAB  text
*      -->H_MARA        text
*      -->P_FIELDNAME   text
*----------------------------------------------------------------------*
form mara_badifields_to_h_mara using ls_statustab type  jksdmaterialstatus
                                     h_mara  type mara
                                     p_fieldname .
**
  field-symbols: <value> type any.
  data:     ls_statustab_strucname(100) value 'LS_STATUSTAB-',
            ls_h_mara_strucname(100) value 'H_MARA-',
            ls_statustab_fieldname(100),
            ls_h_mara_fieldname(100),
            lv_new_value(100),    "setzuff  welcher Typ hier ???????
            lv_old_value(100).    "setzuff  welcher Typ hier ???????
*
* neuer Wert in LS_STATUSTAB
  concatenate ls_statustab_strucname p_fieldname into ls_statustab_fieldname.
  assign (ls_statustab_fieldname) to <value>.
  lv_new_value = <value>.
* alter Wert in H_MARC durch neuen Wert ersetzen
* shift p_fieldname by 5 places.
  concatenate ls_h_mara_strucname p_fieldname into ls_h_mara_fieldname.
  assign (ls_h_mara_fieldname) to <value>.
  <value>  = lv_new_value..
*
endform. " mara_badifields_to_h_marc


*&---------------------------------------------------------------------*
*&      Form  jptmara_badi_to_h_jptmara
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_STATUSTAB  text
*      -->H_JPTMARA     text
*      -->P_FIELDNAME   text
*----------------------------------------------------------------------*
form jptmara_badi_to_h_jptmara using ls_statustab type  jksdmaterialstatus
                                     h_jptmara  type jptmara
                                     p_fieldname .
**
  field-symbols: <value> type any.
  data:     ls_statustab_strucname(100) value 'LS_STATUSTAB-',
            ls_h_jptmara_strucname(100) value 'H_JPTMARA-',
            ls_statustab_fieldname(100),
            ls_h_jptmara_fieldname(100),
            lv_new_value(100),    "setzuff  welcher Typ hier ???????
            lv_old_value(100).    "setzuff  welcher Typ hier ???????
*
* neuer Wert in LS_STATUSTAB
  concatenate ls_statustab_strucname p_fieldname into ls_statustab_fieldname.
  assign (ls_statustab_fieldname) to <value>.
  lv_new_value = <value>.
* alter Wert in H_JPTMARA durch neuen Wert ersetzen
  shift p_fieldname by 8 places.
  concatenate ls_h_jptmara_strucname p_fieldname into ls_h_jptmara_fieldname.
  assign (ls_h_jptmara_fieldname) to <value>.
  <value>  = lv_new_value..
*
endform. " jptmara_badi_to_h_jptmara


*&---------------------------------------------------------------------*
*&      Form  jptmara_badi_to_ls_statuslist
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_JPTMARA     text
*      -->LS_STATUSLIST  text
*      -->P_FIELDNAME    text
*----------------------------------------------------------------------*
form jptmara_badi_to_ls_statuslist
                    using ls_jptmara type jptmara
                          ls_statuslist  type jksdmaterialstatus
                          p_fieldname .
*
  field-symbols: <value> type any.
  data:     ls_jptmara_strucname(100) value 'ls_jptmara-',
            ls_statuslist_strucname(100) value 'ls_statuslist-jptmara_',
            ls_jptmara_fieldname(100),
            ls_statuslist_fieldname(100),
            lv_new_value(100),    "setzuff  welcher Typ hier ???????
            lv_old_value(100).    "setzuff  welcher Typ hier ???????
*
* neuer Wert in ls_jptmara
  shift p_fieldname by 8 places.
  concatenate ls_jptmara_strucname p_fieldname into ls_jptmara_fieldname.
  assign (ls_jptmara_fieldname) to <value>.
  lv_new_value = <value>.
* alter Wert in ls_statuslist durch neuen Wert ersetzen
  concatenate ls_statuslist_strucname p_fieldname into ls_statuslist_fieldname.
  assign (ls_statuslist_fieldname) to <value>.
  <value>  = lv_new_value..
*
endform. " jptmara_badi_to_ls_statuslist

*&---------------------------------------------------------------------*
*&      Form  marc_badifields_to_AMFIELDRES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->H_MARC            text
*      -->P_FIELDNAME       text
*      -->LS_AMFIELDRES     text
*      -->E_AMFIELDRES_TAB  text
*----------------------------------------------------------------------*
form marc_badifields_to_amfieldres
                         using h_marc  type marc
                               value(p_fieldname)
                      changing ls_amfieldres type amfieldres_stru
                               e_amfieldres_tab type amfieldres_tab.
*
  field-symbols: <value> type any.
  data:     ls_h_marc_strucname(100) value 'H_MARC-',
            ls_h_marc_fieldname(100),
            lv_new_value(100).    "setzuff  welcher Typ hier TYPE STRING ?????
  data: comp_tab     type cl_abap_structdescr=>component_table,
        comp         like line of comp_tab,
        lv_type      type abap_typekind.

*
* neuen Wert aus H_MARC lesen
  shift p_fieldname by 5 places.  " entfernen von 'MARC_'
  concatenate ls_h_marc_strucname p_fieldname into ls_h_marc_fieldname.
  assign (ls_h_marc_fieldname) to <value>.
  lv_new_value = <value>.
*
* Datentyp des Feldes ermitteln
  shift ls_h_marc_fieldname by 2 places.  " entfernen von 'H_'
  comp-type ?= cl_abap_datadescr=>describe_by_name( ls_h_marc_fieldname ).
  lv_type = comp-type->type_kind.
*
  case lv_type .
    when cl_abap_typedescr=>typekind_date.
*     Feld ist Datumsfeld
      if lv_new_value is initial   or
         lv_new_value = '00000000' .
*       Eintrag in E_AMFIELDRES_TAB aufnehmen
        ls_amfieldres-fname = ls_h_marc_fieldname.
        append ls_amfieldres to e_amfieldres_tab.
      endif.
    when others.
*     Feld ist kein Datumsfeld
      if lv_new_value is initial.
*       Eintrag in E_AMFIELDRES_TAB aufnehmen
        ls_amfieldres-fname = ls_h_marc_fieldname.
        append ls_amfieldres to e_amfieldres_tab.
      endif.
  endcase.
*
endform. " marc_badifields_to_AMFIELDRES

*&---------------------------------------------------------------------*
*&      Form  mvke_badifields_to_AMFIELDRES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->H_MVKE            text
*      -->P_FIELDNAME       text
*      -->LS_AMFIELDRES     text
*      -->E_AMFIELDRES_TAB  text
*----------------------------------------------------------------------*
form mvke_badifields_to_amfieldres
                         using h_mvke  type mvke
                               value(p_fieldname)
                      changing ls_amfieldres type amfieldres_stru
                               e_amfieldres_tab type amfieldres_tab.
*
  field-symbols: <value> type any.
  data:     ls_h_mvke_strucname(100) value 'H_MVKE-',
            ls_h_mvke_fieldname(100),
            lv_new_value(100).    "setzuff  welcher Typ hier TYPE STRING ?????
  data: comp_tab     type cl_abap_structdescr=>component_table,
        comp         like line of comp_tab,
        lv_type      type abap_typekind.

*
* neuen Wert aus H_MARC lesen
  shift p_fieldname by 5 places.  " entfernen von 'MVKE_'
  concatenate ls_h_mvke_strucname p_fieldname into ls_h_mvke_fieldname.
  assign (ls_h_mvke_fieldname) to <value>.
  lv_new_value = <value>.
*
* Datentyp des Feldes ermitteln
  shift ls_h_mvke_fieldname by 2 places.  " entfernen von 'H_'
  comp-type ?= cl_abap_datadescr=>describe_by_name( ls_h_mvke_fieldname ).
  lv_type = comp-type->type_kind.
*
  case lv_type .
    when cl_abap_typedescr=>typekind_date.
*     Feld ist Datumsfeld
      if lv_new_value is initial   or
         lv_new_value = '00000000' .
*       Eintrag in E_AMFIELDRES_TAB aufnehmen
        ls_amfieldres-fname = ls_h_mvke_fieldname.
        append ls_amfieldres to e_amfieldres_tab.
      endif.
    when others.
*     Feld ist kein Datumsfeld
      if lv_new_value is initial.
*       Eintrag in E_AMFIELDRES_TAB aufnehmen
        ls_amfieldres-fname = ls_h_mvke_fieldname.
        append ls_amfieldres to e_amfieldres_tab.
      endif.
  endcase.
*
endform. " mvke_badifields_to_AMFIELDRES


*&---------------------------------------------------------------------*
*&      Form  mara_badifields_to_AMFIELDRES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->H_MARA            text
*      -->P_FIELDNAME       text
*      -->LS_AMFIELDRES     text
*      -->E_AMFIELDRES_TAB  text
*----------------------------------------------------------------------*
form mara_badifields_to_amfieldres
                         using h_mara  type mara
                               p_fieldname
                      changing ls_amfieldres type amfieldres_stru
                               e_amfieldres_tab type amfieldres_tab.
*
  field-symbols: <value> type any.
  data:     ls_h_mara_strucname(100) value 'H_MARA-',
            ls_h_mara_fieldname(100),
            lv_new_value(100).    "setzuff  welcher Typ hier TYPE STRING ?????
  data: comp_tab     type cl_abap_structdescr=>component_table,
        comp         like line of comp_tab,
        lv_type      type abap_typekind.

*
* neuen Wert aus H_MARA lesen
* shift p_fieldname by 5 places.  " entfernen von 'MARC_'
  concatenate ls_h_mara_strucname p_fieldname into ls_h_mara_fieldname.
  assign (ls_h_mara_fieldname) to <value>.
  lv_new_value = <value>.
*
* Datentyp des Feldes ermitteln
  shift ls_h_mara_fieldname by 2 places.  " entfernen von 'H_'
  comp-type ?= cl_abap_datadescr=>describe_by_name( ls_h_mara_fieldname ).
  lv_type = comp-type->type_kind.
*
  case lv_type .
    when cl_abap_typedescr=>typekind_date.
*     Feld ist Datumsfeld
      if lv_new_value is initial   or
         lv_new_value = '00000000' .
*       Eintrag in E_AMFIELDRES_TAB aufnehmen
        ls_amfieldres-fname = ls_h_mara_fieldname.
        append ls_amfieldres to e_amfieldres_tab.
      endif.
    when others.
*     Feld ist kein Datumsfeld
      if lv_new_value is initial.
*       Eintrag in E_AMFIELDRES_TAB aufnehmen
        ls_amfieldres-fname = ls_h_mara_fieldname.
        append ls_amfieldres to e_amfieldres_tab.
      endif.
  endcase.
*
endform. " mara_badifields_to_AMFIELDRES


*&---------------------------------------------------------------------*
*&      Form  jptmara_maintain
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_JPTMARA          text
*      -->JPTMARA_ERRMSG_TAB  text
*      -->LV_SUBRC            text
*----------------------------------------------------------------------*
form jptmara_maintain using ls_jptmara type jptmara
       changing jptmara_errmsg_tab type jp_merrdat_tab
       lv_subrc.
*
  data:  ls_jptmara_single   type jptmara
*      , lt_jptmara_single   type jptmara_tab       "TK20102011/Hinw.1644212
       , lt_jptmara_single   type jptmara_tab_dark  "TK20102011/Hinw.1644212
       , lt_merrdat_single   type jp_merrdat_tab .
*  data: lv_subrc type sy-subrc.
  data: ls_errmsg type merrdat.
  data: h_msgno_mara like syst-msgno.

* JPTMARA anlegen/ändern
  refresh lt_jptmara_single.
  ls_jptmara_single = ls_jptmara.
  append ls_jptmara_single to lt_jptmara_single.

  call function 'ISM_PMD_JPTMARA_MAINTAIN_DARK'
    exporting
*     PVI_SPERRMODUS                  = 'E'
      pvi_max_errors                  = 1
      pvi_x_mat_check                 = 'X'     "<== Check hier notwendig
*     PVI_XCDOC                       = 'X'
*     PVI_XTEST                       = ' '
*     PVI_XCOMMIT                     = ' '
*     PVI_CALL_MODE                   = ' '
*     PVI_CALL_MODE2                  = ' '
*     PVI_USER                        = SY-UNAME
    importing
*     PVE_MATNR_LAST                  =
*     PVE_NR_ERRORS_TRANSACTION       =
      pte_amerrdat                    = lt_merrdat_single
    changing
      ptc_jptmara                     = lt_jptmara_single
    exceptions
      internal_error                  = 1
      too_many_errors                 = 2
      update_error                    = 3
      others                          = 4 .

  lv_subrc = sy-subrc.
  if lv_subrc = 0.
**   Wenn kein MARA-Feld geändert wurde, meldet der MATERIAL_MAINTAIN_DARK
**   Meldung M3/810: Keine Änderungen (dies Meldung hat KEINE(!) Materialnummer)
**   => Zusatzmeldung hier: JPMGEN/382 wird ergänzt MIT(!) Materialnummer
**     (ist notwendig für den Fall, daß NUR JPTMARA-Attribute geändert wurden!)
*    clear ls_errmsg.
*    ls_errmsg-matnr = ls_jptmara-matnr.
*    ls_errmsg-msgid = 'JPMGEN'.
*    ls_errmsg-msgno = 382.
*    ls_errmsg-msgty = 'D'.
*    ls_errmsg-msgv1 = ls_jptmara-matnr.
*    append ls_errmsg to jptmara_ERRMSG_TAB.
  else.
*   JPTMARA Exception in  Fehlertabelle des MAINTAIN_DARK(!) aufnehmen
*   (Exeption wird hier jeder(!) Med.ausgabe zugeordnet)
*   Meldung "Fehler beim Anlegen der JPTMARA der Medienausgaben"
    h_msgno_mara = '047'.
    perform exception_nach_alog tables jptmara_errmsg_tab
                                using syst h_msgno_mara ls_jptmara-matnr.

*   Originalmeldungen des ISM_PMD_JPTMARA_MAINTAIN_DARK sammeln
    append lines of lt_merrdat_single to jptmara_errmsg_tab.

  endif.
*
endform. " jptmara_maintain

* ev. neue BADI Felder-----------------Ende ------------"TK01102006


* --- Anfang ----------optimistisches Sperren----- "TK01042008
form optimistic_enque_handling
                           tables " errmsg_tab type errmsg_tab
                                  out_enque_error_tab type errmsg_tab
                                  out_change_error_tab type errmsg_tab
                                  pt_amara_ueb type amara_tab
                                  pt_amarc_ueb type amarc_tab
                                  pt_amvke_ueb type amvke_tab
                           using  pt_mara_db   type ism_mara_Db_Tab "TK01042008
                                  pt_marc_db   type ism_marc_Db_Tab "TK01042008
                                  pt_mvke_db   type ism_mvke_Db_Tab. "TK01042008
  .

*
  data: errmsg_stru type errmsg_stru.
  data   ls_tranc_del type ls_tranc.
  data:  lt_tranc_del type lt_tranc.
  data: ls_marc like line of pt_amarc_ueb.
  data: ls_mvke like line of pt_amvke_ueb.
  data: ls_mara like line of pt_amara_ueb.
  data: ls_mara_save like line of pt_amara_ueb.
  DATA: LOCK_CNT TYPE SY-TABIX.
  DATA: ISSUE_CNT TYPE SY-TABIX.
  data: LT_LOCK_ERROR TYPE LOCKED_TAB.
  DATA: LS_LOCK_ERROR LIKE LINE OF LT_LOCK_ERROR.
  DATA: change_CNT TYPE SY-TABIX.
  data: LT_change_ERROR TYPE LOCKED_TAB.
  DATA: LS_change_ERROR LIKE LINE OF LT_LOCK_ERROR.
  data: ls_mara_old type mara.
  data: ls_marc_old type marc.
  data: ls_mvke_old type mvke.
  data: ls_mara_new type mara.
  data: ls_marc_new type marc.
  data: ls_mvke_new type mvke.
  data: lv_mara_change type xfeld.
  data: lv_marc_change type xfeld.
  data: lv_mvke_change type xfeld.
  DATA: user LIKE syst-uname.
*
* 1.) "optimistische" Sperren setzen
*      - gesperrte Ausgaben sammlen in LT_LOCK_ERROR
*      - und aus MAINTAIN_DARK-Tabellen löschen
  loop at pt_amara_ueb into ls_mara.
    ls_mara_save = ls_mara.
    at new matnr.
      ISSUE_CNT = ISSUE_CNT + 1 .
*     lock Media-issue
*     (no lock on issue-sequence(ENQUEUE_EJPLF):
*      statusfields has no conflicts with issue_sequences )
      CALL FUNCTION 'ENQUEUE_EMMARAE'
        EXPORTING
          MATNR          = LS_mara-MATNR
        EXCEPTIONS
          FOREIGN_LOCK   = 01
          SYSTEM_FAILURE = 02.
      IF SY-SUBRC <> 0.
        user = syst-msgv1.
*       LT_LOCK_ERROR füllen
        LS_LOCK_ERROR-MATNR = LS_mara-MATNR.
        APPEND LS_LOCK_ERROR TO LT_LOCK_ERROR.
*       out_enque_error_tab füllen
        clear errmsg_stru.
        errmsg_stru-tranc = ls_mara_save-tranc.
        errmsg_stru-MATNR = ls_mara-matnr.
        errmsg_stru-MSGID = 'JKSDWORKLIST'.
        errmsg_stru-MSGTY = 'E'.
        errmsg_stru-MSGNO = '057'.
        errmsg_stru-MSGV1 = ls_mara-matnr.
        errmsg_stru-MSGV2 = user.
        append errmsg_stru to out_enque_error_tab.
      ENDIF.
    endat.
  endloop.

  SORT LT_LOCK_ERROR.
  DESCRIBE TABLE LT_LOCK_ERROR LINES LOCK_CNT.

* Gesperrte Segmente aus MAINTAIN_DARK-Tabellen löschen
  sort LT_LOCK_ERROR.
  loop at pt_amara_ueb into ls_mara.
    read table LT_LOCK_ERROR into LS_LOCK_ERROR with key ls_mara-matnr
         binary search.
    if sy-subrc = 0.
*       Ausgabe konnte nicht gesperrt werden
*       => KEIN MARA-Update (Eintrag in I_AMARA_UEB löschen)
      delete pt_amara_ueb.
*     Kein MARC-Update (Eintrag in I_AMARC_UEB löschen)
      loop at pt_amarc_ueb into ls_marc
        where matnr    = ls_mara-matnr.
        delete pt_amarc_ueb.
      endloop. " at pt_amarc_ueb into ls_marc
*     Kein MVKE-Update (Eintrag in I_AMVKE_UEB löschen)
      loop at pt_amvke_ueb into ls_mvke
        where matnr    = ls_mara-matnr.
        delete pt_amvke_ueb.
      endloop. " at pt_amvke_ueb into ls_mvke
    endif.
  endloop.

* 2.) Daten abgleichen
*      - inzwischen veränderte Ausgaben sammeln in LT_CHANGE_ERROR
*      - und aus MAINTAIN_DARK-Tabellen löschen
  loop at pt_amara_ueb into ls_mara.
    ls_mara_save = ls_mara.
    clear lv_mara_change.
    clear lv_marc_change.
    clear lv_mvke_change.
    at new matnr.
*     Ausgabe lesen von Datenbank (NICHT!! gepuffert)
      select single * from mara into ls_mara_new bypassing buffer
          where MATNR          = LS_mara-MATNR.
      if sy-subrc <> 0.
        message a054(JKSDWORKLIST) with LS_mara-MATNR .
      endif.
      read table pt_mara_db into ls_mara_old
           with key mandt =   sy-mandt
                    matnr =   LS_mara-MATNR.
*     Verwaltungsfelder der MARA dürfen nicht verglichen werden, da diese auch
*     durch Updates auf Segmente(z.B: MARC) in der MARA aktualisiert werden
      clear ls_mara_new-LAEDA.
      clear ls_mara_old-LAEDA.
      clear ls_mara_new-AENAM.
      clear ls_mara_old-AENAM.
*
      if sy-subrc       = 0      and
        ls_mara_new     = ls_mara_old.
*       MARA hat sich seit dem Einlesen nicht verändert
*       Check MARC-Changes:
        loop at pt_amarc_ueb into ls_marc
          where matnr = LS_mara-MATNR.
*         Werk der Ausgabe lesen von Datenbank (NICHT!! gepuffert)
          select single * from marc into ls_marc_new bypassing buffer
            where MATNR          = LS_marc-MATNR
            and   werks          = ls_marc-werks.
          if sy-subrc <> 0.
            message a055(JKSDWORKLIST) with LS_marc-MATNR .
          endif.
          read table pt_marc_db into ls_marc_old
            with key mandt =   sy-mandt
                     matnr =   LS_marc-MATNR
                     werks =   ls_marc-werks    binary search.
          if sy-subrc       = 0      and
            ls_marc_new    = ls_marc_old.
*           MARC hat sich seit dem Einlesen nicht verändert
          else.
*           MARC hat sich seit dem Einlesen verändert
            lv_marc_change = 'X'.
            exit. "=> ENDLOOP at pt_amarc_ueb
          endif.
        endloop. " at pt_amarc_ueb into ls_marc
*       Check MVKE-Changes, wenn bisher alles unverändert
        if lv_marc_change is initial.
          loop at pt_amvke_ueb into ls_mvke
            where matnr = LS_mara-MATNR.
*           Vber der Ausgabe lesen von Datenbank (NICHT!! gepuffert)
            select single * from mvke into ls_mvke_new bypassing buffer
              where MATNR          = LS_mvke-MATNR
              and   vkorg          = ls_mvke-vkorg
              and   vtweg          = ls_mvke-vtweg.
            if sy-subrc <> 0.
              message a056(JKSDWORKLIST) with LS_mvke-MATNR .
            endif.
            read table pt_mvke_db into ls_mvke_old
              with key mandt =   sy-mandt
                       matnr =   LS_mvke-MATNR
                       vkorg =   ls_mvke-vkorg
                       vtweg =   ls_mvke-vtweg  binary search.
            if sy-subrc       = 0      and
              ls_mvke_new    = ls_mvke_old.
*             MVKE hat sich seit dem Einlesen nicht verändert
            else.
*             MVKE hat sich seit dem Einlesen verändert
              lv_mvke_change = 'X'.
              exit. "=> ENDLOOP at pt_amvke_ueb
            endif.
          endloop. " at pt_amarc_ueb into ls_marc
        endif. " lv_marc_change is initial.
      else.
*       MARA hat sich seit dem Einlesen verändert
        lv_mara_change = 'X'.
      ENDIF.
*
      if lv_mara_change = 'X'   or
         lv_marc_change = 'X'   or
         lv_mvke_change = 'X'   .
*       Fehlertabelle LT_CHANGE_ERROR füllen
        LS_change_ERROR-MATNR = LS_mara-MATNR.
        APPEND LS_change_ERROR TO LT_change_ERROR.
*       out_change_error_tab füllen
        clear errmsg_stru.
        errmsg_stru-tranc = ls_mara_save-tranc.
        errmsg_stru-MATNR = ls_mara-matnr.
        errmsg_stru-MSGID = 'JKSDWORKLIST'.
        errmsg_stru-MSGTY = 'E'.
        errmsg_stru-MSGNO = '058'.
        errmsg_stru-MSGV1 = ls_mara-matnr.
        append errmsg_stru to out_change_error_tab.
      endif. " lv_mara_change = 'X'   or
*
    endat.
  endloop.

  SORT LT_change_ERROR.
  DESCRIBE TABLE LT_change_ERROR LINES change_CNT.

* Inzwischen veränderte Segmente aus MAINTAIN_DARK-Tabellen löschen
  sort LT_change_ERROR.
  loop at pt_amara_ueb into ls_mara.
    read table LT_change_ERROR into LS_change_ERROR with key ls_mara-matnr
         binary search.
    if sy-subrc = 0.
*      Ausgabe wurde inzwischen verändert
*      => KEIN MARA-Update (Eintrag in I_AMARA_UEB löschen)
      delete pt_amara_ueb.
*     Kein MARC-Update (Eintrag in I_AMARC_UEB löschen)
      loop at pt_amarc_ueb into ls_marc
        where matnr    = ls_mara-matnr.
        delete pt_amarc_ueb.
      endloop. " at pt_amarc_ueb into ls_marc
*     Kein MVKE-Update (Eintrag in I_AMVKE_UEB löschen)
      loop at pt_amvke_ueb into ls_mvke
        where matnr    = ls_mara-matnr.
        delete pt_amvke_ueb.
      endloop. " at pt_amvke_ueb into ls_mvke
    endif.
  endloop.
*
endform. " optimistic_enque_handling

* --- Ende-------------optimistisches Sperren----- "TK01042008
