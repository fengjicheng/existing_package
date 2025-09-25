*----------------------------------------------------------------------*
*   INCLUDE RJKSDDEMANDCHANGE_FORM
**----------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  init
*&---------------------------------------------------------------------*
FORM init CHANGING xauthority_ok.
*
  DATA: oref TYPE REF TO cx_root,
        text TYPE string.
  DATA: lv_progid LIKE sy-cprog.                            "TK01042008

* customizing Transaktionsvarianten lesen --- Anfang ---- "TK08022007
  DATA: lt_tjksd13a TYPE STANDARD TABLE OF tjksd13a.
  IF NOT cl_ism_sd_pdex_switch=>get_pdex_active( ) = 'X'.
*   PEDEX nicht aktiv:
    CLEAR gv_pedex_active.
*   con_tcode_display/change bleiben wie im TOP1 definiert, unverändert
  ELSE.
*   PEDEX aktiv
    gv_pedex_active = con_angekreuzt.

    SELECT * FROM tjksd130t INTO TABLE gt_tjksd130t
       WHERE spras = sy-langu.
    SORT gt_tjksd130t.

    SELECT * FROM tjksd130 INTO TABLE gt_tjksd130.      "#EC CI_NOWHERE
    SORT gt_tjksd130.

    SELECT SINGLE * FROM tjksd13a INTO gs_tjksd13a
       WHERE wl_tcode_change = sy-tcode.
    IF sy-subrc = 0.
*     Aufruf Änderungstransaktion
      SELECT * FROM tjksd13 INTO TABLE gt_tjksd13
        WHERE wl_function_grp = gs_tjksd13a-wl_function_grp.
    ELSE.
*     Aufruf Anzeigetransaktion
      SELECT * FROM tjksd13a INTO TABLE lt_tjksd13a
         WHERE wl_tcode_display = sy-tcode.             "#EC CI_NOFIELD
      IF sy-subrc = 0.
        READ TABLE lt_tjksd13a INTO gs_tjksd13a INDEX 1.
        SELECT * FROM tjksd13 INTO TABLE gt_tjksd13
          WHERE wl_function_grp = gs_tjksd13a-wl_function_grp.
      ENDIF. " sy-subrc = 0.
    ENDIF. " sy-subrc = 0.
*
    SORT gt_tjksd13 BY wl_sort.
    IF NOT gt_tjksd13[] IS INITIAL.
      con_tcode_display = gs_tjksd13a-wl_tcode_display.
      con_tcode_change  = gs_tjksd13a-wl_tcode_change.
    ENDIF.
*
  ENDIF.

* Vorlageverteilzentrum lesen für optimisitsches Sperren "TK13062008
  SELECT SINGLE vlgvz INTO gv_twpa_vlgvz FROM twpa.         "TK13062008

* -----Anfang----------------------------------------- "TK01022008
* break kast.
* gv_phasenlayout ev. auch Transaktionabhängig (TJKSD13A?)??
*
* Wenn ja, müsste hier globaler schalter gesetzt werden und dann
* die Selektionsfelder ausgeblendet werden.
*
  IF NOT cl_ism_sd_pdex_switch=>get_pdex_2_active( ) = 'X'.
*   PEDEX2 nicht aktiv:
    CLEAR gv_pedex2_active.
  ELSE.
*   PEDEX2 aktiv
    gv_pedex2_active = con_angekreuzt.
  ENDIF.

  gv_segment_level = con_level_mara_marc_mvke.       "Default
* gv_change_dynnr             ist schon vorbelegt    "Default

  IF gv_pedex2_active = con_angekreuzt.

*   optimistisches Sperren --------- Anfang-------------------- "TK01042008

*   Sperrmodus lesen
    SELECT SINGLE xworklistenque xworklistpubldat xworklistselvar FROM tjy00
      INTO (gv_wl_enq_active, gv_wl_erschdat_change, gv_wl_selvar_separated).

*   optimistisches Sperren --------- Ende---------------------- "TK01042008

*   Feldsteuerung lesen
    SELECT * FROM tjksd13f INTO TABLE gt_tjksd13f
       WHERE wl_tcode_change  = con_tcode_change.
*   Segmentlevel und Selektions-subscreen setzen
    IF NOT gs_tjksd13a-wl_segment_level IS INITIAL.
      gv_segment_level = gs_tjksd13a-wl_segment_level.
    ENDIF.
    IF NOT gs_tjksd13a-wl_sel_subscreen IS INITIAL AND
       NOT gs_tjksd13a-wl_sel_subprog   IS INITIAL .
      gv_change_dynnr   = gs_tjksd13a-wl_sel_subscreen.
      gv_change_program = gs_tjksd13a-wl_sel_subprog.
    ENDIF.

*   Filter------------------------Anfang-------------------"TK01042009
*   Als TCODE, mit dem in der Filter-Suchhilfe JKSD13FILTER_SH_CHANGE
*   die Tabelle TJKSD13A gelesen wird, wird immer der WL_TCODE_CHANGE gemommen,
*   auch in der DSIPLAY-Transaktiosnvariante.
*   Die Übergaben des TCODE an die Suchhilfe erfolgt per Patameter:
    SET PARAMETER ID 'JKSD13_F4_SH_TCODE' FIELD gs_tjksd13a-wl_tcode_change.
*   Filter------------------------Ende---------------------"TK01042009
  ENDIF.
* -----Ende------------------------------------------- "TK01022008

* Plausis für Customizing hier einbauen <== todo !!!!
* transaktionscode / subscreen prüfen

* customizing Transaktionsvarianten lesen --- Ende ------ "TK08022007


* Set mode based on transaction code
  IF sy-tcode = con_tcode_display.
    gv_display = 'X'.
  ELSE.
    CLEAR gv_display.
  ENDIF.

  PERFORM authority_checks USING gv_display
                        CHANGING xauthority_ok.
  IF xauthority_ok IS INITIAL.
    EXIT.  " => ENDFORM
  ENDIF.


* Texte zu Selektionsvarianten beschaffen
  CALL METHOD cl_ism_report_variant_tree=>get_default_texts
    IMPORTING
      e_frame_title = gv_frame
      e_field_text  = gv_field
      e_button_text = gb_ssave
      e_description = gv_vtxt.

* Container für Selektionsvariantenbaum anlegen
  CREATE OBJECT gv_tree_container
    EXPORTING
      container_name = 'VARIANT_TREE'.

  IF gv_wl_selvar_separated = con_angekreuzt.               "TK01042008
    CONCATENATE sy-cprog sy-tcode INTO lv_progid.           "TK01042008
  ENDIF.                                                    "TK01042008

* Selektionsvariantenbaum anlegen
  CREATE OBJECT gv_variant_tree
    EXPORTING
*     I_REPID      = SY-CPROG                                   "TK01042008
      i_repid      = lv_progid                               "TK01042008
      i_dynnr      = '100'
      i_container  = gv_tree_container
*     Selection is done on double click immidiately-- start---- TK18012007
*     Effect: After double_click the program continues first with PAI !!!
*     Selection is done on double click immidiately-- start---- TK18012007
      i_appl_event = 'X'.   "!!!!!!!!!!!!!!!!!!
*     Selection is done on double click immidiately-- end------ TK18012007


* Selektions-Subscreen bei vorhandenen Varianten aus-, sonst einblenden
  DATA: n TYPE i.
  CALL METHOD gv_variant_tree->get_number_variants
    IMPORTING
      e_number = n.

* -------Anfang------------------------------------"TK11082009/hint1374274
  IF NOT sy-calld IS INITIAL.
    PERFORM no_selection_in_call_mode.
  ELSE.
* -------Ende--------------------------------------"TK11082009/hint1374274

    IF n > 0.
      PERFORM selection_hide.
    ELSE.
      PERFORM selection_show.
    ENDIF.
    gv_activeselecttab  = con_selecttab_main.
    gv_selectsubscreen  = con_selecttab_main.

  ENDIF.                                           "TK11082009/hint1374274

* BADI für neue Felder ----------- Anfang -------------- "TK01102006
* Aufruf VOR(!!) dem Create Object!!
  TRY.
      GET BADI worklist_add_fields.
    CATCH cx_badi_not_implemented INTO oref.
      text = oref->get_text( ).
    CATCH cx_badi_multiply_implemented INTO oref.
      text = oref->get_text( ).
  ENDTRY.

* aufruf Badi für Strukturerweiterung im ALV
  IF NOT worklist_add_fields IS INITIAL.
    CALL BADI worklist_add_fields->add_fields            "Standardfelder
      EXPORTING
        tcode          = sy-tcode   "Transaktionsvarianten
      CHANGING
        gt_badi_fields = gt_badi_fields.
    CALL BADI worklist_add_fields->add_customer_fields   "Kundenfelder
      EXPORTING
        tcode          = sy-tcode   "Transaktionsvarianten
      CHANGING
        gt_badi_fields = gt_badi_fields.
  ENDIF.

* Test BADI für Strukturerweiterung im ALV--------------------------
* perform test_add_fields changing gt_badi_fields.
* Test BADI für Strukturerweiterung im ALV--------------------------
* BADI für neue Felder ----------- Anfang -------------- "TK01102006


* Create  list object
  CREATE OBJECT gv_list
    EXPORTING
      i_container = con_list_container.

* Create local handler object
  CREATE OBJECT gv_handler.
  SET HANDLER gv_handler->handle_new_selection    FOR gv_variant_tree.
  SET HANDLER gv_handler->handle_add_request      FOR gv_variant_tree.

* Get preset selection values
  CLEAR rjksdworklist_changefields.
  rjksdworklist_changefields-xsequence = con_angekreuzt.    "TK10082005
  PERFORM parameter_holen CHANGING rjksdworklist_changefields.

* init ALOG-protocol
  CREATE OBJECT log
    EXPORTING
      log_object  = con_log_object
      header_text = text-008
      height      = 100
      dynnr       = '0101'
      program     = 'RJKSDWORKLIST'.
*              expand_level = 1.
*   Log muß hier generell aufgeklappt sein !!!!!!
*   (wird EXPAND_LEVEL mitgegeben und dann im Log versucht,
*   eine Ebene aufzuklicken, wird PBO ausgelöst(warum auch immer)
*   und damit wird der Log als ganzes (ist in dieser Anwendung
*   so programmiert) geschlossen => EXPAND_LEVEL hier ungeeignet!!!
  CALL METHOD log->hide.
  CREATE OBJECT return
    EXPORTING
      level1_interpretation = text-007
      level2_interpretation = text-004.
*             LEVEL3_INTERPRETATION = TEXT-005
*             LEVEL4_INTERPRETATION = TEXT-006.
*
* BADI für Plausibilitäten
  TRY.
      GET BADI exit_worklist_checks.
    CATCH cx_badi_not_implemented INTO oref.
      text = oref->get_text( ).
    CATCH cx_badi_multiply_implemented INTO oref.
      text = oref->get_text( ).
  ENDTRY.

ENDFORM.                    "INIT


*&---------------------------------------------------------------------*
*&      Form  selection_hide
*&---------------------------------------------------------------------*
FORM selection_hide.
  gv_main_screen = con_screen_0102.
  gv_selection_toggle_text = text-102.
  gv_selection_hidden = 'X'.
*  gv_selection_dynnr = con_subscreen_empty.
*  gv_selection_toggle_text = text-102.
ENDFORM.                    "SELECTION_HIDE

*&---------------------------------------------------------------------*
*&      Form  selection_show
*&---------------------------------------------------------------------*
FORM selection_show.
  gv_main_screen = con_screen_0100.
  gv_selection_toggle_text = text-101.
  gv_selection_hidden = ' '.
*  gv_selection_dynnr = con_subscreen_select.
*  gv_selection_dynnr = con_subscreen_select.
*  gv_selection_toggle_text = text-101.
ENDFORM.                    "SELECTION_SHOW

*&---------------------------------------------------------------------*
*&      Form  selection_save
*&---------------------------------------------------------------------*
FORM selection_save.
  convert_to gt_params.

  CALL METHOD gv_variant_tree->add
    EXPORTING
      i_text         = gv_vtxt
      i_params       = gt_params
    EXCEPTIONS
      exists_already = 1
      OTHERS         = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    MESSAGE s022(jksdworklist) WITH gv_vtxt.
  ENDIF.


ENDFORM.                    "SELECTION_SAVE

*&---------------------------------------------------------------------*
*&      Form  selection_check
*&---------------------------------------------------------------------*
FORM selection_check CHANGING pt_params         TYPE rsparams_tt
                              pt_dbtab          TYPE status_tab_type
                              pt_mara_db    TYPE ism_mara_db_tab "TK01042008
                              pt_marc_db    TYPE ism_marc_db_tab "TK01042008
                              pt_mvke_db    TYPE ism_mvke_db_tab "TK01042008
                              pt_statuslist_tab TYPE status_tab_type
                              ps_changefields    TYPE changefields_type
                              pv_save           TYPE xfeld
                              pv_ok_code        LIKE sy-ucomm.
*
  DATA: xonly_changefields TYPE xfeld VALUE 'X'.
  DATA: lv_phase_display.                                   "TK01022008
  DATA: lv_publdate_changeable TYPE xfeld.                  "TK01042008

*
  STATICS: lt_params    LIKE pt_params,
           lv_date_from LIKE ps_changefields-date_from,
           lv_date_to   LIKE ps_changefields-date_to,
           lv_xsequence LIKE ps_changefields-date_to.

  STATICS: ls_changefields  TYPE changefields_type.         "TK01022008
  "Hinweis 1138201


* Check for changed selection criteria
  IF lt_params    <> pt_params OR pv_ok_code = 'REFRESH'  OR
                                  pv_ok_code = 'REFRESH_INTERNAL' OR   "TK16072009/hint1365757
     ls_changefields <> ps_changefields  OR "TK01022008 Hinweis 1138201
     lv_date_from <> ps_changefields-date_from            OR
     lv_date_to   <> ps_changefields-date_to              OR
     lv_xsequence <> ps_changefields-xsequence .

*   ---------------------------Anfang----------------------"TK16072009/hint1365757

    CLEAR gv_reset_sorting.                                "TK11082009/hint1374477

*   ok-code REFRESH wird gesetz, wenn
*   1.)nach dem Rücksprung aus "Weitere Funktionen" wieder in die Worklist
*     verzweigt wird => es darf KEIN(!!) Reset markierter Zeilen erfolgen
*   2.)Drucktaste 'Auffrischen' direkt ausgeführt wird => Reset markierter Zeilen notwendig
*   3.)Doppelklich auf Selektionsvariante => Reset markierter Zeilen notwendig
    IF pv_ok_code <> 'REFRESH' AND pv_ok_code <> 'REFRESH_INTERNAL'.
*     es wurden explizit(!) Selektionsfelder geändert und deshalb eine
*     erneute Selektion angestartet => Reset markierter Zeilen notwendig
      gv_reset_marked_lines = 'X'.
      gv_reset_sorting = 'X'.                              "TK11082009/hint1374477
*     --------Anfang---------------------------------------"TK15102009/hint1397078
      IF xshow_error_alog = 'X'.
        CALL METHOD log->hide.
        CLEAR xshow_error_alog.
      ENDIF.
*     --------Ende-----------------------------------------"TK15102009/hint1397078
    ELSE.
*      pv_ok_code = 'REFRESH'  oder pv_ok_code = 'REFRESH_INTERNAL'.
      IF gv_double_click_selection = 'X'.
*        ok_code REFRESH wurde durch Doppelklick auf Selektiosvariante belegt (3.)
        gv_reset_marked_lines = 'X'.
        gv_reset_sorting = 'X'.                           "TK11082009/hint1374477
*        --------Anfang------------------------------------"TK15102009/hint1397078
        IF xshow_error_alog = 'X'.
          CALL METHOD log->hide.
          CLEAR xshow_error_alog.
        ENDIF.
*        --------Ende--------------------------------------"TK15102009/hint1397078
      ENDIF.
      IF gv_save_okcode = 'REFRESH'.
*        'REFRESH' wurde explizit mit Drucktastes ausgeführt(2.)
        gv_reset_marked_lines = 'X'.
        gv_reset_sorting = 'X'.                           "TK11082009/hint1374477
*        außerhalb der Klasse lassen sich markierte Zeilen NICHT ermitteln
*        (CALL METHOD GV_ALV_GRID->GET_SELECTED_ROWS bringt keine Ergebnisse)
*        => markierte Zeilen müssen hier gelöscht werden
*        --------Anfang------------------------------------"TK15102009/hint1397078
        IF xshow_error_alog = 'X'.
          CALL METHOD log->hide.
          CLEAR xshow_error_alog.
        ENDIF.
*        --------Ende--------------------------------------"TK15102009/hint1397078
      ENDIF.
    ENDIF.
*   ---------------------------Ende------------------------"TK16072009/hint1365757

*   Make sure no user input is lost
    IF NOT pv_save IS INITIAL.
      DATA: safety_answer.
      PERFORM safety_check CHANGING safety_answer.
      IF safety_answer = 'J'.
        PERFORM save.
      ELSEIF safety_answer = 'A'.
*       reset all selection criteria
        pt_params =  lt_params.
        ps_changefields-date_from = lv_date_from.
        ps_changefields-date_to = lv_date_to.
        EXIT.
      ENDIF.
      PERFORM unlock USING gt_lock_error.
      CLEAR pv_save.
    ELSE.
      IF NOT pt_dbtab[] IS INITIAL.
        PERFORM unlock USING gt_lock_error.
      ENDIF.
    ENDIF.
*
    CLEAR xindustrymaterial.
    CLEAR xretailmaterial.
    CLEAR xretail.
    CLEAR xabort_selection.

*   Get and lock the data
    PERFORM selection_get_data USING  pt_params
                                      ps_changefields-date_from
                                      ps_changefields-date_to
                                      ps_changefields-xsequence
                                      ps_changefields-xwithout_phases "TK01022008
                                      ps_changefields-xincl_phases "TK01022008
                                      ps_changefields-xexcl_phases "TK01022008
                             CHANGING pt_statuslist_tab
                                      pt_dbtab
                                      pt_mara_db            "TK01042008
                                      pt_marc_db            "TK01042008
                                      pt_mvke_db            "TK01042008
                                      xindustrymaterial
                                      xretailmaterial
                                      xabort_selection.
*                                      pt_issue.
*
    IF ps_changefields-xincl_phases = con_angekreuzt OR     "TK01022008
       ps_changefields-xexcl_phases = con_angekreuzt .      "TK01022008
      lv_phase_display = con_angekreuzt.                    "TK01022008
    ENDIF. " ps_changefields-xincl_phases = con_angekreuzt             "TK01022008

    IF xretailmaterial = 'X'          AND                   "TK01042008
       xindustrymaterial IS INITIAL   AND                   "TK01042008
       gv_wl_erschdat_change = 'X'    AND                   "TK01042008
       gv_display            = space.                       "TK01042008
      lv_publdate_changeable = 'X'.                         "TK01042008
    ENDIF.                                                  "TK01042008
*   Now add the entries to the ALV GRID (and lock the entries)
    PERFORM list_add_entries USING pt_statuslist_tab
                                   lv_phase_display         "TK01022008
                                   gv_wl_enq_active         "TK01042008
                                   lv_publdate_changeable   "TK01042008
                                   gv_display
                                   gv_reset_marked_lines       "TK16072009/hint1365757
                                   gv_reset_sorting            "TK11082009/hint1374477
                          CHANGING gt_lock_error.
*                                   pt_issue
*                                   pv_issue
*                                   pv_ref_issue.

    CLEAR gv_reset_marked_lines.                               "TK16072009/hint1365757

    IF pt_statuslist_tab[] IS INITIAL.
      IF xabort_selection = con_angekreuzt.
*       Treffermenge bei Selektion groß: Benutzer hat Selektion abgebrochen
*       PT(GT)_STATUSLIST_TAB wurde gecleart
        MESSAGE i065(jksdworklist).
      ELSE.
        IF xindustrymaterial = con_angekreuzt      AND
           xretailmaterial   = con_angekreuzt .
*         Industrie und Retail-Mix: PT(GT)_STATUSLIST_TAB wurde gecleart
          MESSAGE i044(jksdworklist).
        ELSE.
*         es wurden keine Ausgaben selektiert
          IF ps_changefields-date_from > ps_changefields-date_to. "TK20072009 Hinw.1366505
            MESSAGE i068(jksdworklist).                             "TK20072009 Hinw.1366505
          ELSE.                                                   "TK20072009 Hinw.1366505
            MESSAGE i024(jksdworklist).
          ENDIF.                                                  "TK20072009 Hinw.1366505
        ENDIF.
      ENDIF.
    ENDIF.

*   -----------------Anfang---------------------------------------"TK20072009 Hinw.1366505
*   Beim Lesen über die Ausagbenfolge (XSEQUENZE) werden Ausgaben mit initialem Publdate
*   auch dann selektiert, wenn date_from > date_to (siehe Buba ISM_DELIVERYSEQUENCE_GET)
    IF NOT pt_statuslist_tab[] IS INITIAL AND
       ps_changefields-date_from > ps_changefields-date_to.
      MESSAGE i068(jksdworklist).
    ENDIF.
*   -----------------Ende-----------------------------------------"TK20072009 Hinw.1366505



    IF xretailmaterial = con_angekreuzt.
      xretail = con_angekreuzt.
    ENDIF.


*   Make a copy of the selection criteria
    lt_params =  pt_params.
    lv_date_from     = ps_changefields-date_from.
    lv_date_to       = ps_changefields-date_to.
    lv_xsequence     = ps_changefields-xsequence.
    ls_changefields  = ps_changefields.     "TK01022008 Hinweis 1138201

*
  ENDIF.
*
ENDFORM.                    "SELECTION_CHECK


*&---------------------------------------------------------------------*
*&      Form  list_add_entries
*&---------------------------------------------------------------------*
FORM list_add_entries USING pt_statuslist_tab TYPE status_tab_type
                            pv_phase_display                "TK01022008
                            pv_wl_enq_active                "TK01042008
                            pv_publdate_changeable          "TK01042008
                            pv_display    TYPE xfeld
                            pv_reset_marked_lines TYPE xfeld   "TK01022008 Hinweis 1138201
                            pv_reset_sorting                   "TK11082009/hint1374477
                  CHANGING  pt_lock_error TYPE locked_tab.
*                            pt_issue     TYPE issue_tab_type
*                            pv_issue     TYPE ismmatnr_issue
*                            pv_ref_issue TYPE ismmatnr_issue.

  DATA: ls_lock_error TYPE matnr_stru.
* lock entries

* break kast.

  IF pv_display IS INITIAL. "Change-Mode

*   optimitisches Sperren -------- Anfang ------------------"TK01042008

    IF pv_wl_enq_active IS INITIAL.                         "TK01042008
*    Standard-Sperren auf die komplette Ausgabe
      PERFORM lock USING pt_statuslist_tab
                   CHANGING pt_lock_error.
    ELSE.                                                   "TK01042008
*     Segmentweises Worklist-Sperren erfolgt in           "TK01042008
*     Methode ADD_ENTRIES. Dort werden eingabebereite     "TK01042008
*     Segmente identifiziert und gesperrt                 "TK01042008
    ENDIF. " pv_wl_enq_active is initial.                 "TK01042008

*   optimitisches Sperren -------- Ende---------------------"TK01042008

  ENDIF.
*
* Sort  (Sort schon beim Lesen der Daten erfolgt)
* SORT PT_STATUSLIST_TAB BY ISMREFMDPROD ISMPUBLDATE MARC_WERKS
*                            MVKE_VKORG MVKE_VTWEG.
* Now add the entries to the ALV object
  CALL METHOD gv_list->add_entries
    EXPORTING
      i_statustab          = pt_statuslist_tab
      i_phase_display      = pv_phase_display               "TK01022008
      i_wl_enq_active      = pv_wl_enq_active               "TK01042008
      i_wl_erschdat_change = pv_publdate_changeable         "TK01042008
      i_display            = pv_display
      i_reset_marked_lines = pv_reset_marked_lines            "TK01022008 Hinweis 1138201
      i_reset_sorting      = pv_reset_sorting                 "TK11082009/hint1374477
      i_lock_error         = pt_lock_error.  "is still sorted
*               i_issue     = pv_issue
*               i_ref_issue = pv_ref_issue.

ENDFORM.                                    " list_add_entries


*&---------------------------------------------------------------------*
*&      Form  list_tranfer_changed_data
*&---------------------------------------------------------------------*
FORM list_transfer_changed_data.
  CALL METHOD gv_list->check_changed_data.
ENDFORM.                    " list_tranfer_changed_data

*&---------------------------------------------------------------------*
*&      Form  list_refresh_execute
*&---------------------------------------------------------------------*
FORM list_refresh_execute.
  CALL METHOD gv_list->execute_refresh.
ENDFORM.                               " list_refresh_execute

*&---------------------------------------------------------------------*
*&      Form  exit_command
*&---------------------------------------------------------------------*
FORM exit_command CHANGING pv_ok_code LIKE sy-ucomm
                           pv_save    TYPE xfeld.
  DATA: safety_answer TYPE c.

  xshow_error_alog = con_angekreuzt.

  IF pv_save IS INITIAL.
    PERFORM leave_program.
  ELSE.
    PERFORM safety_check CHANGING safety_answer.
    IF safety_answer = 'J'.
      PERFORM save.
    ENDIF.
    IF safety_answer = 'J' OR safety_answer = 'N'.
      PERFORM leave_program.
    ELSE.
      CLEAR pv_ok_code.
    ENDIF.
  ENDIF.

ENDFORM.                               " exit_command

*&---------------------------------------------------------------------*
*&      Form  user_command
*&---------------------------------------------------------------------*
FORM user_command CHANGING pv_ok_code     LIKE sy-ucomm
                           ps_changefields TYPE changefields_type.

*
  DATA: h_dat TYPE sy-datum.
  DATA: lv_switch_aborted TYPE xfeld.                       "TK18012007

  CLEAR gv_double_click_selection.                          "TK16072009/hint1365757

*

* Selection is done on double click immidiately-- start---- TK18012007
* this method calls the event handler method of an event
  DATA: return_code TYPE i.
  CALL METHOD cl_gui_cfw=>dispatch
    IMPORTING
      return_code = return_code.
  IF return_code <> cl_gui_cfw=>rc_noevent.
*   if ok_code_101 <> 'REFRESH'.                  "TK16072009/hint1365757
    IF ok_code_101 <> 'REFRESH_INTERNAL'.         "TK16072009/hint1365757
      CLEAR pv_ok_code.
*     PERFORM USER_COMMAND CHANGING PV_OK_CODE
*                                  PS_CHANGEFIELDS.
    ELSE.
*     OK_CODE_101 = 'REFRESH' behalten
*     PV_OK_CODE = 'REFRESH'.                      "TK16072009/hint1365757
      pv_ok_code = 'REFRESH_INTERNAL'.             "TK16072009/hint1365757

      gv_double_click_selection = 'X'.             "TK16072009/hint1365757

    ENDIF.
  ENDIF.
* Selection is done on double click immidiately-- end ----- TK18012007


* Vor dem Verlassen sichern
  IF pv_ok_code = 'BACK'.
    IF gv_recommend_save IS INITIAL.
      PERFORM leave_program.
    ELSE.
      DATA: safety_answer.
      PERFORM safety_check CHANGING safety_answer.
      IF safety_answer = 'J'.
        PERFORM save.
      ELSEIF safety_answer = 'A'.
        CLEAR pv_ok_code.
        EXIT.
      ENDIF.
      PERFORM leave_program.
    ENDIF.
  ENDIF.

  CASE pv_ok_code.

*   -------Anfang---------------------------------------"TK15102009/hint1397078
    WHEN 'ALOG_OUT'.
      IF xshow_error_alog = 'X'.
        CALL METHOD log->hide.
        CLEAR xshow_error_alog.
      ENDIF.
*   -------Ende-----------------------------------------"TK15102009/hint1397078

    WHEN 'SAVE'.
      CLEAR pv_ok_code.
      PERFORM save.
*     pv_ok_code = 'REFRESH'.                   "TK16072009/hint1365757
      pv_ok_code = 'REFRESH_INTERNAL'.          "TK16072009/hint1365757
      PERFORM user_command CHANGING pv_ok_code
                                    ps_changefields.
    WHEN 'SELSAVE'.
      CLEAR pv_ok_code.
      PERFORM selection_save.

    WHEN 'SELECTION'.
      CLEAR pv_ok_code.
      IF gv_selection_hidden IS INITIAL.
        PERFORM selection_hide.
      ELSE.
        PERFORM selection_show.
      ENDIF.

    WHEN 'SWITCH'.
      CLEAR pv_ok_code.
*     Check Authority only for switch from DISPLAY to CHANGE
      IF gv_display IS INITIAL.
*       Switch from CHANGE to DISPLAY
      ELSE.
*       Switch from DISPLAY to CHANGE
        PERFORM authority_checks USING space  "SPACE = Check for CHANGE
                              CHANGING xauthority_ok.
        IF xauthority_ok IS INITIAL.
*         No authority for CHANGE  => NO SWITCH !
          MESSAGE s003(jksdworklist).
          EXIT.  " => ENDFORM
        ENDIF.
      ENDIF.
      PERFORM switch_mode CHANGING gv_recommend_save
                                   lv_switch_aborted .      "TK18012007

      IF lv_switch_aborted = 'X'.                           "TK18012007
        pv_ok_code = 'DO_NOTHING'.                          "TK18012007
      ELSE.                                                 "TK18012007
*       pv_ok_code = 'REFRESH'.                        "TK16072009/hint1365757
        pv_ok_code = 'REFRESH_INTERNAL'.               "TK16072009/hint1365757
      ENDIF.                                                "TK18012007
      PERFORM user_command CHANGING pv_ok_code
                                    ps_changefields.

    WHEN 'MENGENPLAN'.
      CLEAR pv_ok_code.
      PERFORM call_sddemandchange.

    WHEN 'BEILAGPLAN'.
      CLEAR pv_ok_code.
      PERFORM call_beilagenplanung.

    WHEN 'MEDIENAUSG'.
      CLEAR pv_ok_code.
      PERFORM call_medienausgabe.

    WHEN 'ORDERGEN'.
      CLEAR pv_ok_code.
      PERFORM call_auftragsgenerierung.


    WHEN con_selecttab_main .
      gv_activeselecttab = pv_ok_code.
      gv_selectsubscreen = pv_ok_code.

    WHEN 'PROT'.
      CLEAR pv_ok_code.
      h_dat = sy-datum - 1 .
      SUBMIT rjksdworklist_prot
         VIA SELECTION-SCREEN
         AND RETURN .
*         WITH P_FROM     = H_DAT         "neue Protklasse
*         WITH P_UNTIL    = SY-DATUM.     "neue Protklasse


    WHEN 'DEFAULT'.
    WHEN 'DO_NOTHING'.  "nichts zu tun                    "TK18012007
*     Notwendig, damit bei FCODE = 'SWITCH' und           "TK18012007
*     Abbrechen des Wechsels von DISPLAY <-> CHANGE       "TK18012007
*     das Sicherungspopup NICHT zweimal prozessiert wird  "TK18012007

    WHEN OTHERS.
*     if pv_ok_code is initial or pv_ok_code = 'REFRESH'.
      IF pv_ok_code = 'ENTER' OR pv_ok_code = 'REFRESH'
                              OR pv_ok_code = 'REFRESH_INTERNAL'. "TK16072009/hint1365757

        convert_to gt_params.
*       ---- Anfang----Phasenversand radio buttons --------"TK01022008
*       clear ps_changefields-xwithout_phases.
*       clear ps_changefields-xincl_phases.
*       clear ps_changefields-xexcl_phases.
*       if not gv_norm is initial.
*         ps_changefields-xwithout_phases = 'X'.
*       endif.
*       if not gv_incl is initial.
*         ps_changefields-xincl_phases = 'X'.
*       endif.
*       if not gv_excl is initial.
*         ps_changefields-xexcl_phases = 'X'.
*       endif.
*       ---- Ende------Phasenversand radio buttons --------"TK01022008
        PERFORM selection_check   CHANGING gt_params
                                           gt_dbtab
                                           gt_mara_db       "TK01042008
                                           gt_marc_db       "TK01042008
                                           gt_mvke_db       "TK01042008
                                           gt_statuslist_tab
                                           ps_changefields
                                           gv_recommend_save
                                           pv_ok_code.
        convert_from gt_params.
        CLEAR pv_ok_code.
      ELSE.
*        MESSAGE i598(ed) WITH pv_ok_code.
      ENDIF.
  ENDCASE.

* Selection is done on double click immidiately-- start---- TK18012007
** this method calls the event handler method of an event
*  DATA: RETURN_CODE TYPE I.
*  CALL METHOD CL_GUI_CFW=>DISPATCH
*    IMPORTING
*      RETURN_CODE = RETURN_CODE.
*  IF RETURN_CODE <> CL_GUI_CFW=>RC_NOEVENT.
*    CLEAR PV_OK_CODE.
*    PERFORM USER_COMMAND CHANGING PV_OK_CODE
*                                  PS_CHANGEFIELDS.
*  ENDIF.
* Selection is done on double click immidiately-- end ----- TK18012007

  pv_ok_code = 'DUMMY'.

ENDFORM.                               " user_command

**&---------------------------------------------------------------------*
**&      Form  save
**&---------------------------------------------------------------------*
*FORM SAVE .
*
*  DATA: N LIKE SY-TABIX.
*  DATA: LV_SUBRC TYPE SY-SUBRC.
*  DATA: ERR_CNT TYPE SY-TABIX.
*  DATA: XNO_CHANGES LIKE CON_ANGEKREUZT.
*  DATA: XALOG_ACTIVE LIKE CON_ANGEKREUZT VALUE 'X'.
*  DATA: XTEST TYPE XFELD.  "initial => Updates are active
*
*  CALL METHOD GV_VARIANT_TREE->SAVE_REQUIRED
*    EXCEPTIONS
*      NOT_REQUIRED = 1
*      OTHERS       = 2.
*  IF SY-SUBRC <> 1.
*    CALL METHOD GV_VARIANT_TREE->SAVE_TO_DATABASE
*      EXCEPTIONS
*        SAVE_FAILED = 1
*        OTHERS      = 2.
*    IF SY-SUBRC = 0.
*      COMMIT WORK.
*      IF N = 0.
*        MESSAGE S027(JKSDWORKLIST).
*      ENDIF.
*    ELSE.
*      ROLLBACK WORK.
*      MESSAGE E025(JKSDWORKLIST) WITH SY-SUBRC.
*    ENDIF.
*  ENDIF.
*
*  CLEAR GV_RECOMMEND_SAVE.
*
*  CALL METHOD GV_LIST->GET_CHANGED_ENTRIES
*    EXPORTING
*      I_STATUSTAB      = GT_STATUSLIST_TAB
*      I_DBTAB          = GT_DBTAB
*    IMPORTING
*      E_AMARA_UEB      = GT_AMARA_UEB
*      e_jptmara_Tab    = GT_JPTMARA_TAB                     "TK01102006
*      E_AMARC_UEB      = GT_AMARC_UEB
*      E_AMVKE_UEB      = GT_AMVKE_UEB
*      E_AMFIELDRES_TAB = GT_AMFIELDRES_TAB
*      E_TRANC_TAB      = GT_TRANC_TAB
*      E_XNO_CHANGES    = XNO_CHANGES.
*
*
*  IF XNO_CHANGES = CON_ANGEKREUZT.
*    MESSAGE S018(JKSDWORKLIST).  "WITH lv_count.
*  ELSE.
*    PERFORM MAINTAIN_DARK TABLES GT_AMARA_UEB GT_AMARC_UEB GT_AMVKE_UEB
*                                 GT_AMFIELDRES_TAB GT_TRANC_TAB
*                                 GT_ERROR_TAB    "hier dummy(ALOG aktiv)
*                          USING  XALOG_ACTIVE    " Alog ist hier aktiv
*                                 XTEST           "hier generell Echtlauf
*                                 XRETAIL
*                                 gt_jptmara_tab             "TK01102006
*                        CHANGING LV_SUBRC ERR_CNT.
**   (MAÌNTAIN_DARK ist hier Form und keine Methode! Grund:
**    Parameter von Methoden dürfen  nicht veränder werden
**    FUBA MAINTAIN_DARK führt SORT auf Material-Tabellen aus => DUMP)
*    IF LV_SUBRC = 0.
*      COMMIT WORK.
*      MESSAGE S019(JKSDWORKLIST).  "WITH lv_count.
*    ELSE.
**      ROLLBACK WORK.    "Rollback zu mächtig
**      Alle Änderungen, die möglich sind, werden durchgeführt,
**      Änderungen die nicht möglich sind, werden protokolliert
*      COMMIT WORK.
*      XSHOW_ERROR_ALOG = CON_ANGEKREUZT.  "init bei PBO
*      MESSAGE S036(JKSDWORKLIST) WITH ERR_CNT.
*    ENDIF.
*  ENDIF.
**
*  CLEAR GV_RECOMMEND_SAVE.
**
*ENDFORM.                    "SAVE

**&---------------------------------------------------------------------*
**&      Form  SAFETY_CHECK
**&---------------------------------------------------------------------*
*FORM SAFETY_CHECK CHANGING ANSWER TYPE C.
*
*  ANSWER = 'N'.
*  CALL FUNCTION 'POPUP_TO_CONFIRM_DATA_LOSS'
*    EXPORTING
*      TITEL  = TEXT-001
*    IMPORTING
*      ANSWER = ANSWER.
*
*ENDFORM.                               " SAFETY_CHECK


*&---------------------------------------------------------------------*
*&      Form  parameter_holen
*&---------------------------------------------------------------------*
FORM parameter_holen
       CHANGING ps_changefields TYPE changefields_type.


* Don't get parameter's for selection screen here (!)
* (otherwise every selection variant is wrongly filled with these
*  parameters, if you push "Show selection".)

* Get from and to dates
  CALL FUNCTION 'ISM_ISSSTAT_CHANGE_GET_FROM_TO'
    IMPORTING
      out_date_from = ps_changefields-date_from
      out_date_to   = ps_changefields-date_to.

*  Don't get organisational data from parameter here(!)
*  GET PARAMETER ID 'VKO' FIELD GV_VKORG.
*  GET PARAMETER ID 'VTW' FIELD GV_VTWEG.
*  GET PARAMETER ID 'SPA' FIELD GV_SPART.
*  GET PARAMETER ID 'WRK' FIELD GV_WERK.

ENDFORM.                    " parameter_holen

*---------------------------------------------------------------------*
*       FORM leave_program                                            *
*---------------------------------------------------------------------*
FORM leave_program.
  LEAVE PROGRAM.
ENDFORM.                    "LEAVE_PROGRAM

*&---------------------------------------------------------------------*
*&      Form  set_change_mode
*&---------------------------------------------------------------------*
FORM set_change_mode.
  IF NOT gv_display IS INITIAL.
    CLEAR gv_display.
*   break kast.
*    optimistisches sperren (Schalter ???)
*    PERFORM LOCK USING GT_STATUSLIST_TAB
*                 CHANGING GT_LOCK_ERROR.
  ENDIF.
ENDFORM.                    "SET_CHANGE_MODE

*&---------------------------------------------------------------------*
*&      Form  set_display_mode
*&---------------------------------------------------------------------*
FORM set_display_mode.
  IF gv_display IS INITIAL.
    gv_display = 'X'.
*    IF NOT GV_LIST IS INITIAL.
*      CALL METHOD GV_LIST->SET_MODE EXPORTING I_DISPLAY = GV_DISPLAY.
*    ENDIF.
    PERFORM unlock USING gt_lock_error.
  ENDIF.
ENDFORM.                    "SET_DISPLAY_MODE

*---------------------------------------------------------------------*
*       FORM switch_mode                                              *
*---------------------------------------------------------------------*
FORM switch_mode CHANGING pv_save TYPE xfeld
                          pv_switch_aborted TYPE xfeld.     "TK18012007

  CLEAR pv_switch_aborted.                                  "TK18012007


  IF gv_display IS INITIAL.
* Make sure no user input is lost
    IF NOT pv_save IS INITIAL.
      DATA: safety_answer TYPE c.
      PERFORM safety_check CHANGING safety_answer.
      IF safety_answer = 'J'.
        PERFORM save.
      ELSEIF safety_answer = 'A'.
        pv_switch_aborted = 'X'.                            "TK18012007
        EXIT.
      ENDIF.
      CLEAR pv_save.
    ENDIF.

    PERFORM set_display_mode.
  ELSE.

    PERFORM set_change_mode.
  ENDIF.

ENDFORM.                    "SWITCH_MODE


*---------------------------------------------------------------------*
*       FORM selection_get_data                                       *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  PT_PARAMS                                                     *
*  -->  PT_STATUSLIST                                                 *
*---------------------------------------------------------------------*
FORM selection_get_data USING    pt_params     TYPE rsparams_tt
                                 date_from date_to xsequence
                                 xwithout_phases            "TK01022008
                                 xincl_phases               "TK01022008
                                 xexcl_phases               "TK01022008
                        CHANGING pt_statuslist TYPE status_tab_type
                                 pt_dbtab      TYPE status_tab_type
                                 pt_mara_db    TYPE ism_mara_db_tab "TK01042008
                                 pt_marc_db    TYPE ism_marc_db_tab "TK01042008
                                 pt_mvke_db    TYPE ism_mvke_db_tab "TK01042008
                                 xindustrymaterial
                                 xretailmaterial
                                 xabort_selection.


*
  DATA: lt_medprod TYPE medprod_tab.
  DATA: sel_date_from TYPE sy-datum.
  DATA: sel_date_to   TYPE sy-datum.
  DATA: status_stru TYPE status_type.
  DATA: lt_marc TYPE jksdmarcstattab.  "MARC_TAB.
*  DATA: LS_MARC TYPE JKSDMARCSTAT.  "MARC_STRU
*  DATA: LS_MVKE TYPE JKSDMVKESTAT. "MVKE_STRU.
  DATA: lt_mvke TYPE jksdmvkestattab. "MVKE_TAB.
  RANGES: vkorg_range FOR mvke-vkorg.
  RANGES: vtweg_range FOR mvke-vtweg.

  DATA: lv_mara_cnt TYPE sy-tabix.
  DATA: lv_marc_cnt TYPE sy-tabix.
  DATA: lv_mvke_cnt TYPE sy-tabix.
  DATA: lv_selected_objects_cnt TYPE sy-tabix.

*  DATA: LS_STATUSLIST LIKE LINE OF PT_STATUSLIST.
*
* 0.) init
  CLEAR pt_statuslist. REFRESH pt_statuslist.
  CLEAR pt_dbtab.      REFRESH pt_dbtab.
* 1.) Convert params table to local variables
  convert_from pt_params .
*
* 2.) Read MARA-Tables
* Select Media-products
  SELECT matnr FROM mara
    INTO CORRESPONDING FIELDS OF TABLE lt_medprod
    WHERE matnr        IN gr_mprod
    AND   ismhierarchlevl = con_lvl_med_prod
    AND   ismperrule      IN gr_prule
    AND   ismpubltype     IN gr_ptype
    AND   ismmediatype    IN gr_mtype.
*
  IF lt_medprod[] IS INITIAL.
    EXIT. "=> Endform
  ENDIF.
*

* DATE_FROM/TO: Set default for initial dates
  IF date_from IS INITIAL OR
     date_from EQ '00000000'.
    sel_date_from = con_time_begin.
  ELSE.
    sel_date_from = date_from.
  ENDIF.
  IF date_to IS INITIAL OR
     date_to EQ '00000000'.
    sel_date_to = con_time_infinity.
  ELSE.
    sel_date_to = date_to.
  ENDIF.
*
  REFRESH pt_statuslist. REFRESH lt_marc. REFRESH lt_mvke.  "TK10082005

  IF rjksdworklist_changefields-xpubldate = con_angekreuzt. "TK10082005
*   aktuell nur ISMPUBLDATE auf MARA-Ebene                  "TK01022008
*   Auslagerung in Form                                      "TK10082005
    PERFORM sel_by_mara_date                                "TK01022008
*   perform sel_by_publdate                                 "TK01022008
     USING lt_medprod xsequence sel_date_from sel_date_to
           rjksdworklist_changefields                       "TK01022008
     CHANGING pt_statuslist lt_marc lt_mvke .
  ENDIF.                                                    "TK10082005
*
  IF rjksdworklist_changefields-xerfdate      = con_angekreuzt. "TK26062008
    PERFORM sel_by_mara_erfdate                             "TK26062008
     USING lt_medprod xsequence sel_date_from sel_date_to   "TK26062008
     CHANGING pt_statuslist lt_marc lt_mvke .               "TK26062008
  ENDIF.                                                    "TK26062008


  IF rjksdworklist_changefields-xonsaledate = con_angekreuzt "TK10082005

  OR rjksdworklist_changefields-xismreturnbegin = con_angekreuzt "TK01022008
  OR rjksdworklist_changefields-xismreturnend   = con_angekreuzt "TK01022008
  OR rjksdworklist_changefields-xismoffsaledate = con_angekreuzt. "TK01022008
*    diverse MARC-Satumsfelder als Selektion möglich             "TK01022008
*    perform sel_by_onsaledate                               "TK01022008
    PERFORM sel_by_mvke_date                                "TK01022008
    USING lt_medprod xsequence sel_date_from sel_date_to    "TK10082005
          rjksdworklist_changefields                        "TK01022008
    CHANGING pt_statuslist lt_marc lt_mvke .                "TK10082005
  ENDIF.                                                    "TK10082005
*
  IF rjksdworklist_changefields-xpurchdate = con_angekreuzt "TK10082005

  OR rjksdworklist_changefields-xismfirstretedi   = con_angekreuzt "TK01022008
  OR rjksdworklist_changefields-xismlatestretedi  = con_angekreuzt "TK01022008
  OR rjksdworklist_changefields-xismfirstret      = con_angekreuzt "TK01022008
  OR rjksdworklist_changefields-xismlatestret     = con_angekreuzt "TK01022008
  OR rjksdworklist_changefields-xismarrivaldatepl = con_angekreuzt "TK01022008
  OR rjksdworklist_changefields-xincl_phases      = con_angekreuzt. " For Actual Goods Arrival Date
*    perform sel_by_PURCHDATE                                "TK01022008
    PERFORM sel_by_marc_date                                "TK01022008
    USING lt_medprod xsequence sel_date_from sel_date_to    "TK10082005
          rjksdworklist_changefields                        "TK01022008
    CHANGING pt_statuslist lt_marc lt_mvke .                "TK10082005
  ENDIF.                                                    "TK10082005
*
  IF rjksdworklist_changefields-xinitshipdate = con_angekreuzt. "TK10082005
    PERFORM sel_by_initshipdate                             "TK10082005
     USING lt_medprod xsequence sel_date_from sel_date_to   "TK10082005
     CHANGING pt_statuslist lt_marc lt_mvke .               "TK10082005
  ENDIF.                                                    "TK10082005
*

* ---Anfang ----------------------------------------"TK01022008
  DATA: lt_jvtphdate TYPE jvtphdate_tab.
* abhängig vom level werden gelesene Segmente gecleart
  CASE gv_segment_level.
    WHEN con_level_mara.
      CLEAR lt_marc. REFRESH lt_marc.
      CLEAR lt_mvke. REFRESH lt_mvke.
    WHEN con_level_mara_mvke.
      CLEAR lt_marc. REFRESH lt_marc.
    WHEN con_level_mara_marc.
      CLEAR lt_mvke. REFRESH lt_mvke.
  ENDCASE.

*  Phasenlogik (vorläufig?) wieder inaktiviert

*  if RJKSDWORKLIST_CHANGEFIELDS-xincl_phases = con_angekreuzt or
*     RJKSDWORKLIST_CHANGEFIELDS-xexcl_phases = con_angekreuzt.
*    clear lt_marc. refresh lt_marc.
*    clear lt_mvke. refresh lt_mvke.
*    perform read_JVTPHDATE using pt_statuslist
*                                 SEL_DATE_FROM SEL_DATE_to
*                        changing lt_JVTPHDATE.
*    if not lt_jvtphdate[] is initial.
*      perform merge_jvtphdate using lt_jvtphdate
*                           changing pt_statuslist.
*    endif.
*  endif.
* ---Ende-------------------------------------------"TK01022008

* Prüfung erst NACH(!) Segment-Eingrenzung--- Anfang----- "TK29042008
* ein Mix aus Industrie- und Retailmaterialien wird nicht verarbeitet.
* (Grund: die Protokollaufbereitungen unterscheiden sich wesentlich!)
  PERFORM check_industry_retail_mix
     USING pt_statuslist
     CHANGING xindustrymaterial xretailmaterial.
  IF xindustrymaterial = con_angekreuzt    AND
     xretailmaterial   = con_angekreuzt.
    CLEAR pt_statuslist. REFRESH pt_statuslist.
    CLEAR lt_marc.       REFRESH lt_marc.
    CLEAR lt_mvke.       REFRESH lt_mvke.
*   EXIT. "=> Endform
  ENDIF.
* Prüfung erst NACH(!) Segment-Eingrenzung--- Ende------- "TK29042008

* Warnung, wenn (zu) viele Sperreinträge entstehen--Anfang-----"TK01072008
* Anzahl selektierter MARA-Sätze
  DESCRIBE TABLE pt_statuslist LINES lv_mara_cnt.
  IF gv_wl_enq_active = con_angekreuzt.
*   segmentweises Sperren aktiv: MARC/MVKE-Sätze mitzählen
    DESCRIBE TABLE lt_marc LINES lv_marc_cnt.
    DESCRIBE TABLE lt_mvke LINES lv_mvke_cnt.
  ENDIF.
  lv_selected_objects_cnt = lv_mara_cnt + lv_marc_cnt + lv_mvke_cnt.
  IF lv_selected_objects_cnt > gv_selection_warning_cnt.
    CALL SCREEN con_dynnr_selection_warning STARTING AT 40  15
                                            ENDING   AT  110 22.

    IF ok_code_0550 <> 'GOON'.
*     Neustart der Transaktion
      CLEAR pt_statuslist. REFRESH pt_statuslist.
      CLEAR lt_marc.       REFRESH lt_marc.
      CLEAR lt_mvke.       REFRESH lt_mvke.
      xabort_selection = con_angekreuzt.
    ENDIF.
  ENDIF. " lv_selected_objects_cnt > gv_selection_warning_cnt.
* Warnung, (zu) wenn viele Sperreinträge entstehen--Ende-------"TK01072008

*-------Anfang Issue-Filterung---------------------------------"TK01402009
  IF NOT gv_filt IS INITIAL.
    PERFORM issue_filterung USING gv_filt
                            CHANGING pt_statuslist
                                     lt_marc
                                     lt_mvke.
  ENDIF. " not gv_filt is initial.
*-------Ende   Issue-Filterung---------------------------------"TK01402009

* 2. ) Enhance PT_STATUSLIST by MARC and MVKE)
*      (PT:STATUSLIST contains one entry for each(!) MARA-entry)
* (Structure of PT_STATUSLIST : MARA   MARC1  MVKE1
*                                      MARC2  MVKE2
*                                             MVKE3   )

  CALL FUNCTION 'ISM_ISSUE_STATUSTAB_ENHANCE'
    EXPORTING                                               "TK01102006
      it_baditab   = gt_badi_fields                         "TK01102006
    CHANGING
      ct_statustab = pt_statuslist
      it_marcstat  = lt_marc
      it_mvkestat  = lt_mvke.
*
* KEIN!! Sort hier               "TK14012005 Hinweis 809072
*  SORT PT_STATUSLIST BY ISMREFMDPROD SEQUENCE_LFDNR ISMPUBLDATE
*                         MARC_WERKS MVKE_VKORG MVKE_VTWEG.
*

* ----------- BADI zum füllen der Kundenfelder----------- "TK01102006
  DATA: gt_change_worklist TYPE jksdmaterialstatustab.

  gt_change_worklist[] = pt_statuslist[].
  i_outtab[] = pt_statuslist[].

* aufruf Badi zum Füllen der Kundenfelder
  IF NOT worklist_add_fields IS INITIAL.
    CALL BADI worklist_add_fields->fill_customer_fields
      EXPORTING
        tcode              = sy-tcode   "Transaktionsvarianten
      CHANGING
        gt_change_worklist = gt_change_worklist.
  ENDIF.

* Test Badi für Lesen und Füllen der Kundenfelder-------
* perform test_fill_customer_fields
*              changing gt_change_worklist .
* Test Badi für Lesen und Füllen der Kundenfelder-------

  pt_statuslist[] = gt_change_worklist[].
* ----------- BADI zum füllen der Kundenfelder----------- "TK01102006

* Save DB-Tables before change in dialog
  CLEAR pt_dbtab. REFRESH pt_dbtab.
  pt_dbtab[] = pt_statuslist[].

* --- Anfang-----------optimistisches Sperren----- "TK01042008

* komlette Satzbetten müssen jetzt nachgelesen werden
*
  DATA: ls_statuslist LIKE LINE OF pt_statuslist.
  DATA: ls_marcstat TYPE jksdmarcstat.
  DATA: ls_mvkestat TYPE jksdmvkestat.

* MARA:
* DB-Zustand MARA merken in GT_MARA_DB.
  CLEAR pt_mara_db. REFRESH pt_mara_db.
* loop at pt_statuslist into ls_statuslist.             "TK25092009 hint1389068
*   select * from mara appending table pt_mara_db       "TK25092009 hint1389068
*     where matnr    = ls_statuslist-matnr.             "TK25092009 hint1389068
* endloop.                                              "TK25092009 hint1389068
  IF NOT pt_statuslist[] IS INITIAL.                    "TK25092009 hint1389068
    SELECT * FROM mara INTO TABLE pt_mara_db            "TK25092009 hint1389068
      FOR ALL ENTRIES IN pt_statuslist                  "TK25092009 hint1389068
      WHERE matnr = pt_statuslist-matnr.                "TK25092009 hint1389068
  ENDIF.                                                "TK25092009 hint1389068

* MARC:
* DB-Zustand MARC merken in GT_MARC_DB.
  CLEAR pt_marc_db. REFRESH pt_marc_db.
* loop at lt_marc into ls_marcstat.                     "TK25092009 hint1389068
*   select * from marc appending table pt_marc_db       "TK25092009 hint1389068
*     where matnr    = ls_marcstat-matnr                "TK25092009 hint1389068
*     and   werks    = ls_marcstat-werks.               "TK25092009 hint1389068
* endloop.                                              "TK25092009 hint1389068
  IF NOT lt_marc[] IS INITIAL.                          "TK25092009 hint1389068
    SELECT * FROM marc INTO TABLE pt_marc_db            "TK25092009 hint1389068
      FOR ALL ENTRIES IN lt_marc                        "TK25092009 hint1389068
      WHERE matnr = lt_marc-matnr                       "TK25092009 hint1389068
      AND   werks = lt_marc-werks.                      "TK25092009 hint1389068
  ENDIF.                                                "TK25092009 hint1389068

* MVKE:
* DB-Zustand MVKE merken in GT_MVKE_DB.
  CLEAR pt_mvke_db. REFRESH pt_mvke_db.
* loop at lt_mvke into ls_mvkestat.                     "TK25092009 hint1389068
*   select * from mvke appending table pt_mvke_db       "TK25092009 hint1389068
*     where matnr    = ls_mvkestat-matnr                "TK25092009 hint1389068
*     and   vkorg    = ls_mvkestat-vkorg                "TK25092009 hint1389068
*     and   vtweg    = ls_mvkestat-vtweg.               "TK25092009 hint1389068
* endloop.                                              "TK25092009 hint1389068
  IF NOT lt_mvke[] IS INITIAL.                          "TK25092009 hint1389068
    SELECT * FROM mvke INTO TABLE pt_mvke_db            "TK25092009 hint1389068
      FOR ALL ENTRIES IN lt_mvke                        "TK25092009 hint1389068
      WHERE matnr = lt_mvke-matnr                       "TK25092009 hint1389068
      AND   vkorg = lt_mvke-vkorg                       "TK25092009 hint1389068
      AND   vtweg = lt_mvke-vtweg.                      "TK25092009 hint1389068
  ENDIF.                                                "TK25092009 hint1389068

  SORT pt_mara_db.
  DELETE ADJACENT DUPLICATES FROM pt_mara_db.
  SORT pt_marc_db.
  DELETE ADJACENT DUPLICATES FROM pt_marc_db.
  SORT pt_mvke_db.
  DELETE ADJACENT DUPLICATES FROM pt_mvke_db.

* --- Ende-------------optimistisches Sperren----- "TK01042008



*
ENDFORM.                                    " selection_get_data
*&---------------------------------------------------------------------*
*&      Form  lock
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PT_STATUSLIST_TAB  text
*      <--P_LT_lockED  text
*----------------------------------------------------------------------*
FORM lock USING    pt_statuslist_tab TYPE status_tab_type
          CHANGING lt_lock_error TYPE locked_tab.
*
  DATA: ls_list LIKE LINE OF pt_statuslist_tab.
  DATA: ls_lock_error LIKE LINE OF lt_lock_error.
  DATA: lock_cnt TYPE sy-tabix.
  DATA: issue_cnt TYPE sy-tabix.
*
  CLEAR lt_lock_error. REFRESH lt_lock_error.
  LOOP AT pt_statuslist_tab INTO ls_list.
    CHECK ls_list-xfirst_issue_line = con_angekreuzt.
    issue_cnt = issue_cnt + 1 .
*   lock Media-issue
*   (no lock on issue-sequence(ENQUEUE_EJPLF):
*    statusfields has no conflicts with issue_sequences )
    CALL FUNCTION 'ENQUEUE_EMMARAE'
      EXPORTING
        matnr          = ls_list-matnr
      EXCEPTIONS
        foreign_lock   = 01
        system_failure = 02.
    IF sy-subrc <> 0.
      ls_lock_error-matnr = ls_list-matnr.
      APPEND ls_lock_error TO lt_lock_error.
    ENDIF.
  ENDLOOP.
*
  SORT lt_lock_error.
  DESCRIBE TABLE lt_lock_error LINES lock_cnt.
*
  IF lock_cnt > 0.
    MESSAGE s009(jksdworklist) WITH lock_cnt
                                 issue_cnt.
  ENDIF.
*
ENDFORM.                    " lock



*---------------------------------------------------------------------*
*       FORM unLOCK                                                   *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  LT_LOCKED                                                     *
*---------------------------------------------------------------------*
FORM unlock USING  lt_lock_error TYPE locked_tab.
*
  CALL FUNCTION 'DEQUEUE_ALL'
    EXPORTING
      _synchron = 'X'.
*
  CLEAR lt_lock_error. REFRESH lt_lock_error.
*
ENDFORM.                    " lock


*---------------------------------------------------------------------*
*       FORM issue_sequence_read                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  LT_MEDPROD                                                    *
*  -->  DATE_FROM                                                     *
*  -->  DATE_TO                                                       *
*  -->  PT_STATUSLIST                                                 *
*---------------------------------------------------------------------*
FORM issue_sequence_read USING   lt_medprod TYPE medprod_tab
                                 date_from date_to
                        CHANGING pt_statuslist TYPE status_tab_type.
*
  TYPES: BEGIN OF maus_sel_tab_stru.
           INCLUDE STRUCTURE rjp_maus1.
*        INCLUDE STRUCTURE MARA.
* TYPES:  MAKTX LIKE MAKT-MAKTX.         "hier nicht sprachabhängig
* TYPES:  XACTIVE LIKE CON_ANGEKREUZT.
         TYPES: END   OF maus_sel_tab_stru..
  TYPES: maus_sel_tab TYPE maus_sel_tab_stru OCCURS 0.
*
  DATA: ls_medprod LIKE LINE OF lt_medprod.
  DATA: ls_statuslist LIKE LINE OF pt_statuslist.
  DATA: sel_vondat LIKE sy-datum.
  DATA: sel_bisdat LIKE sy-datum.
  DATA: lf_dynpro_tab TYPE rjp_mg1_tab.
  DATA: maus_sel_tab TYPE maus_sel_tab.
  DATA: ls_mara TYPE maus_sel_tab_stru.
  DATA: ls_dynpro_tab TYPE rjp_mg1.
  DATA: max_sel_ek_lfdnr LIKE jptmg0-mpg_lfdnr.
  DATA: min_sel_ek_lfdnr LIKE jptmg0-mpg_lfdnr.
  DATA: h_mara TYPE mara.
*
  sel_vondat = date_from.
  sel_bisdat = date_to.
*
  LOOP AT lt_medprod INTO ls_medprod.
*   Read issue_sequence
    CALL FUNCTION 'ISM_DELIV_SEQUENCE_READ'
      EXPORTING
        medprod          = ls_medprod-matnr
        sel_variante     = con_sel_zeitraum
      IMPORTING
        min_sel_ek_lfdnr = min_sel_ek_lfdnr  "dummy
        max_sel_ek_lfdnr = max_sel_ek_lfdnr  "dummy
      CHANGING
        publdate_from    = sel_vondat
        publdate_to      = sel_bisdat
*       MAUS_DB_ALL_TAB  = MAUS_DB_ALL_TAB
*       LF_DB_ALL_TAB    = LF_DB_ALL_TAB
        maus_sel_tab     = maus_sel_tab   "selekt. Med.ausg(MARA)
*                                                "incl. nicht der Folge
*                                                "zugeord.Ausgaben(MARA)
*              Achtung: MAUS_SEL_TAB enthält NUR Ausgaben des Med.prod.
        lf_dynpro_tab    = lf_dynpro_tab. "Folge incl. Planwerte
*              LF_SEL_TAB       = LF_SEL_TAB
*              LF_OUT_SEL_TAB   = LF_OUT_SEL_TAB.
*
*   Add issue to pt_statuslist.
    SORT maus_sel_tab BY mandt matnr.
    LOOP AT lf_dynpro_tab INTO ls_dynpro_tab.
      CHECK ls_dynpro_tab-xdbexist = con_angekreuzt.
      READ TABLE maus_sel_tab INTO ls_mara
                              WITH KEY mandt = sy-mandt
                                       matnr = ls_dynpro_tab-matnr
                              BINARY SEARCH.
      IF sy-subrc <> 0.
*       Med.ausgabe gehört zu anderem Produkt => nachlesen von DB
*       (ist bei nicht-synchronisierten Produkten erlaubt!)
        SELECT SINGLE * FROM mara INTO h_mara
          WHERE matnr = ls_dynpro_tab-matnr.
        MOVE-CORRESPONDING h_mara TO ls_mara.
      ENDIF.
*     Check MARA-Status for issues from issue-sequence
      IF NOT gr_mstav[] IS INITIAL
        OR  gr_mstae[] IS INITIAL.
        CHECK ls_mara-mstav IN gr_mstav.
        CHECK ls_mara-mstae IN gr_mstae.
      ENDIF.
      MOVE-CORRESPONDING ls_mara TO ls_statuslist.
*     Med.prod. muß Bezug zur Lieferfolge sein (ISMREFMDPROD ist dann
*     falsch, wenn bei nicht-synchron. Produkten die Ausgabe mehreren
*     Lieferfolgen zugeordnet ist!)
      ls_statuslist-ismrefmdprod = ls_dynpro_tab-med_prod.
      ls_statuslist-sequence_lfdnr = ls_dynpro_tab-mpg_lfdnr.
      APPEND ls_statuslist TO pt_statuslist.
    ENDLOOP.
  ENDLOOP.
*
*
* If issues are multiple used in a sequence(non-synchronized products),
* this information has to be deleted here!
  SORT pt_statuslist.
  DELETE ADJACENT DUPLICATES FROM pt_statuslist.
*
ENDFORM.                    "ISSUE_SEQUENCE_READ


*-------------------- Anfang-------------------------"TK0106205
FORM issue_sequence_read_new USING   lt_medprod TYPE medprod_tab
                                 date_from date_to
                        CHANGING pt_statuslist TYPE status_tab_type.
*
  TYPES: BEGIN OF maus_sel_tab_stru.
           INCLUDE STRUCTURE rjp_maus1.
*        INCLUDE STRUCTURE MARA.
* TYPES:  MAKTX LIKE MAKT-MAKTX.         "hier nicht sprachabhängig
* TYPES:  XACTIVE LIKE CON_ANGEKREUZT.
         TYPES: END   OF maus_sel_tab_stru..
  TYPES: maus_sel_tab TYPE maus_sel_tab_stru OCCURS 0.
*
  DATA: ls_medprod LIKE LINE OF lt_medprod.
  DATA: ls_statuslist LIKE LINE OF pt_statuslist.
  DATA: sel_vondat LIKE sy-datum.
  DATA: sel_bisdat LIKE sy-datum.
  DATA: lf_dynpro_tab TYPE rjp_mg1_tab.
  DATA: maus_sel_tab TYPE maus_sel_tab.
  DATA: ls_mara TYPE maus_sel_tab_stru.
  DATA: ls_dynpro_tab TYPE rjp_mg1.
  DATA: max_sel_ek_lfdnr LIKE jptmg0-mpg_lfdnr.
  DATA: min_sel_ek_lfdnr LIKE jptmg0-mpg_lfdnr.
  DATA: h_mara TYPE mara.
*
  DATA: lt_sequence TYPE  rjdissueseqtab  .
  DATA: lt_sequenceattr TYPE  rjksejptmg0_tab .
  DATA: ls_sequenceattr LIKE LINE OF lt_sequenceattr .
*
  sel_vondat = date_from.
  sel_bisdat = date_to.
*
  LOOP AT lt_medprod INTO ls_medprod.
*
*   init
    CLEAR lt_sequence. REFRESH lt_sequence.
    CLEAR lt_sequenceattr. REFRESH lt_sequenceattr.
    CLEAR lf_dynpro_tab. REFRESH lf_dynpro_tab.
*
*   Read issue_sequence
    CALL FUNCTION 'ISM_DELIVERYSEQUENCE_GET'
      EXPORTING
*       IN_ISSUE_FROM       =
*       IN_ISSUE_TO         =
        in_mediaproduct     = ls_medprod-matnr
        in_validfrom        = sel_vondat
        in_validto          = sel_bisdat
*       IN_COPYNUMBERFROM   =
*       IN_COPYNUMBERTO     =
*       IN_FLAG_HORIZONT    =
      IMPORTING
        out_sequencetab     = lt_sequence
        out_sequenceattrtab = lt_sequenceattr
      EXCEPTIONS
        issue_not_assigned  = 1
        missing_sequence    = 2
        copynr_not_assigned = 3
        OTHERS              = 4.
*
*   LF_DYNPRO_TAB füllen
    LOOP AT lt_sequenceattr INTO ls_sequenceattr.
      MOVE-CORRESPONDING ls_sequenceattr TO ls_dynpro_tab.
      ls_dynpro_tab-xdbexist = con_flag_yes.
      APPEND ls_dynpro_tab TO lf_dynpro_tab.
    ENDLOOP.
*   MAUS_SEL_TAB füllen
    IF NOT lf_dynpro_tab[] IS INITIAL.
      SELECT * FROM mara INTO TABLE maus_sel_tab
        FOR ALL ENTRIES IN lf_dynpro_tab
        WHERE matnr = lf_dynpro_tab-matnr.
**     Duplikate aus lt_mara löschen
*      sort lt_mara.
*      delete adjacent duplicates from lt_mara.
    ENDIF. " not lt_dynpro_tab[] is initial.

*   Add issue to pt_statuslist.
    SORT maus_sel_tab BY mandt matnr.
    LOOP AT lf_dynpro_tab INTO ls_dynpro_tab.
      CHECK ls_dynpro_tab-xdbexist = con_angekreuzt.
      READ TABLE maus_sel_tab INTO ls_mara
                              WITH KEY mandt = sy-mandt
                                       matnr = ls_dynpro_tab-matnr
                              BINARY SEARCH.
      IF sy-subrc <> 0.
*       Med.ausgabe gehört zu anderem Produkt => nachlesen von DB
*       (ist bei nicht-synchronisierten Produkten erlaubt!)
        SELECT SINGLE * FROM mara INTO h_mara
          WHERE matnr = ls_dynpro_tab-matnr.
        MOVE-CORRESPONDING h_mara TO ls_mara.
      ENDIF.
*     Check MARA-Status for issues from issue-sequence
      IF NOT gr_mstav[] IS INITIAL
        OR NOT gr_issue[] IS INITIAL                    "SEL_ISSUE
        OR NOT gr_mstae[] IS INITIAL.
        CHECK ls_mara-mstav IN gr_mstav.
        CHECK ls_mara-mstae IN gr_mstae.
        CHECK ls_mara-matnr IN gr_issue.                "SEL_ISSUE
      ENDIF.
      MOVE-CORRESPONDING ls_mara TO ls_statuslist.
*     Med.prod. muß Bezug zur Lieferfolge sein (ISMREFMDPROD ist dann
*     falsch, wenn bei nicht-synchron. Produkten die Ausgabe mehreren
*     Lieferfolgen zugeordnet ist!)
      ls_statuslist-ismrefmdprod = ls_dynpro_tab-med_prod.
      ls_statuslist-sequence_lfdnr = ls_dynpro_tab-mpg_lfdnr.
      ls_statuslist-xarchive       = ls_dynpro_tab-xarchive. "TK28112007
      APPEND ls_statuslist TO pt_statuslist.
    ENDLOOP.
  ENDLOOP.
*
*
* If issues are multiple used in a sequence(non-synchronized products),
* this information has to be deleted here!
  SORT pt_statuslist.
  DELETE ADJACENT DUPLICATES FROM pt_statuslist.
*
ENDFORM.                    "ISSUE_SEQUENCE_READ
*-------------------- Ende---------------------------"TK0106205


*&---------------------------------------------------------------------*
*&      Form  AUTHORITY_CHECKS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GV_DISPLAY  text
*      <--P_XAUTHORITY_OK  text
*----------------------------------------------------------------------*
FORM authority_checks USING    gv_display
                      CHANGING xauthority_ok.
*
  DATA: h_aktyp LIKE t130m-aktyp.
*
  xauthority_ok = con_angekreuzt.
*
  IF gv_display IS INITIAL.                         "Status change
    h_aktyp = con_actype_change.
  ELSE.                                             "Status Display
    h_aktyp = con_actype_display.
  ENDIF.
*
* Berechtigung für Materialstamm
  CALL FUNCTION 'MARA_AUTHORITY_CHECK'
    EXPORTING
      aktyp        = h_aktyp
    EXCEPTIONS
      only_display = 1
      no_authority = 2
      OTHERS       = 3.
  .
  IF sy-subrc <> 0.
    CLEAR xauthority_ok.
  ENDIF.
*
ENDFORM.                    " AUTHORITY_CHECKS
*&---------------------------------------------------------------------*
*&      Form  CALL_sddemandchange
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM call_sddemandchange.
*
  DATA: marked_issue TYPE mara-matnr.
  DATA: marked_plant TYPE marc-werks.    "TK01042008/hint1158167
  DATA: marked_vkorg TYPE mvke-vkorg.    "TK01042008/hint1158167
  DATA: marked_vtweg TYPE mvke-vtweg.    "TK01042008/hint1158167
  DATA: mark_count TYPE sy-tabix.
  DATA: ls_statuslist TYPE jksdmaterialstatus.
*
* Check: One row must be marked
  CALL METHOD gv_list->get_marked_issue
    EXPORTING
      i_statustab  = gt_statuslist_tab
    IMPORTING
      e_issue      = marked_issue
      e_plant      = marked_plant         "TK01042008/hint1158167
      e_vkorg      = marked_vkorg         "TK01042008/hint1158167
      e_vtweg      = marked_vtweg         "TK01042008/hint1158167
      e_mark_count = mark_count.

  IF marked_issue IS INITIAL.
    MESSAGE s005 WITH mark_count.
  ELSE.
*   PEDEX aktiv: - Mengenplanung wurde umgestellt
*                - es gibt keine Anzeige/Pflege-Transaktionen mehr,
*                  sondern nur noch EINE Transaktion für Anzeige/Pflege
    SET PARAMETER ID 'JP_ISS' FIELD marked_issue.
    SET PARAMETER ID 'JP_PROD'     FIELD ' '. " ls_version-mprod.
*
    IF gv_display IS INITIAL.
*     Worklist im Pflege-Modus
      IF gv_pedex_active IS INITIAL.
*       PEDEX nicht aktiv
        CALL TRANSACTION 'JKSD07'.    "Pflegetransaktion
*       siehe RJKSDCONTRACTDEAMNDVERSION
      ELSE.
*       PEDEX aktiv
        LOOP AT gt_statuslist_tab INTO ls_statuslist.
          IF ls_statuslist-matnr = marked_issue.
            EXIT.
          ENDIF.
        ENDLOOP.
        IF sy-subrc = 0.
          CALL FUNCTION 'ISM_SD_SQP_FOR_MEDIAISSUE'
            EXPORTING
*             Werk und Vertr.ber. bleiben initial
              im_issue   = marked_issue
              im_product = ls_statuslist-ismrefmdprod.
*             Werk und Vertr.ber. bleiben initial
        ENDIF.
      ENDIF.
    ELSE.
*     Worklist im Anzeige-Modus
      IF gv_pedex_active IS INITIAL.
*       PEDEX nicht aktiv
        CALL TRANSACTION 'JKSD07A'.
      ELSE.
*       PEDEX aktiv
        LOOP AT gt_statuslist_tab INTO ls_statuslist.
          IF ls_statuslist-matnr = marked_issue.
            EXIT.
          ENDIF.
        ENDLOOP.
        IF sy-subrc = 0.
          CALL FUNCTION 'ISM_SD_SQP_FOR_MEDIAISSUE'
            EXPORTING
*             Werk und Vertr.ber. bleiben initial
              im_issue   = marked_issue
              im_product = ls_statuslist-ismrefmdprod.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
*
ENDFORM.                    "CALL_SDDEMANDCHANGE


*---------------------------------------------------------------------*
*       FORM CALL_beilagenplanung                                     *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM call_beilagenplanung.
*
  DATA: marked_issue TYPE mara-matnr.
  DATA: marked_plant TYPE marc-werks.    "TK01042008/hint1158167
  DATA: marked_vkorg TYPE mvke-vkorg.    "TK01042008/hint1158167
  DATA: marked_vtweg TYPE mvke-vtweg.    "TK01042008/hint1158167
  DATA: mark_count TYPE sy-tabix.
*
* Check: One row must be marked
  CALL METHOD gv_list->get_marked_issue
    EXPORTING
      i_statustab  = gt_statuslist_tab
    IMPORTING
      e_issue      = marked_issue
      e_plant      = marked_plant         "TK01042008/hint1158167
      e_vkorg      = marked_vkorg         "TK01042008/hint1158167
      e_vtweg      = marked_vtweg         "TK01042008/hint1158167
      e_mark_count = mark_count.
  IF marked_issue IS INITIAL.
    MESSAGE s005 WITH mark_count.
  ELSE.
    SET PARAMETER ID 'JP_ISS' FIELD marked_issue.
    IF gv_display IS INITIAL.
      CALL TRANSACTION 'JVSD12' .                           "'JVSD06'.
    ELSE.
*     Anzeige von JVSD12 ?? setzuff
      CALL TRANSACTION 'JVSD12'.                            "'JVSD07'.
    ENDIF.
  ENDIF.
*
ENDFORM.                    " CALL_BEILAGENPLANUNG



*---------------------------------------------------------------------*
*       FORM CALL_medienausgabe                                       *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM call_medienausgabe.
*
  DATA: marked_issue TYPE mara-matnr.
  DATA: marked_plant TYPE marc-werks.    "TK01042008/hint1158167
  DATA: marked_vkorg TYPE mvke-vkorg.    "TK01042008/hint1158167
  DATA: marked_vtweg TYPE mvke-vtweg.    "TK01042008/hint1158167
  DATA: mark_count TYPE sy-tabix.
*
* Check: One row must be marked
  CALL METHOD gv_list->get_marked_issue
    EXPORTING
      i_statustab  = gt_statuslist_tab
    IMPORTING
      e_issue      = marked_issue
      e_plant      = marked_plant         "TK01042008/hint1158167
      e_vkorg      = marked_vkorg         "TK01042008/hint1158167
      e_vtweg      = marked_vtweg         "TK01042008/hint1158167
      e_mark_count = mark_count.
  IF marked_issue IS INITIAL.
    MESSAGE s005 WITH mark_count.
  ELSE.
*    SET PARAMETER ID 'JP_ISS' FIELD MARKED_ISSUE.
*    IF GV_DISPLAY IS INITIAL.
**     Sprung in das Ändern erfolgt hier nicht!! (problematisch
**     wäre die Sperr-Mimik sowie das Warten nach dem Sichern
**     beim Rücksprung in die Statusverwaltung: MARA-Änderungen
**     "gleichzeitig" in zwei Transaktionen.)
*      CALL TRANSACTION 'JP29'.  "Sprung in die Anzeige!!
**     falls doch Sprung ins Ändern, dann mit Fuba:
**     CALL FUNCTION 'ISM_PMD_MAINTAIN_DIALOG_CT'  (siehe MJPG0F01)
*    ELSE.
*      CALL TRANSACTION 'JP29'.
*    ENDIF.
    CALL FUNCTION 'ISM_CALL_MEDIAISSUE_SHOW'
      EXPORTING
        matnr           = marked_issue
        xretail_mode    = xretail
*       XMODE_DETERMINATION       =
*       XSCIP_FIRST_SCREEN        =
      EXCEPTIONS
        matnr_not_exist = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.
*
ENDFORM.                    " CALL_medienausgabe
*&---------------------------------------------------------------------*
*&      Form  CALL_auftragsgenerierung
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM call_auftragsgenerierung.
*
*
  DATA: marked_issue_tab TYPE marked_tab.
  DATA: mark_count TYPE sy-tabix.
  DATA: xbatch_error TYPE xfeld.
*
* Check: One row must be marked
  CALL METHOD gv_list->get_marked_issues
    EXPORTING
      i_statustab  = gt_statuslist_tab
    IMPORTING
      e_issue_tab  = marked_issue_tab
      e_mark_count = mark_count.
  IF mark_count = 0.
    MESSAGE s030.
  ELSE.
*   Info, wieviele Ausgaben markiert sind
    MESSAGE i031 WITH mark_count.
*   POPUP zur Eingabe des "Batchjob-Start-Datums" prozessieren
    PERFORM popup_fuer_batchjob
    CHANGING rjksd13-batch_startdate
             rjksd13-batch_starttime
             rjksd13-batch_startimmediate
             rjksd13-vkorg
             rjksd13-auart
             popup_status.

    IF popup_status EQ con_popupstatus_abort.
*     POPUP wurde mit F12  abgebrochen
      EXIT.                            "Sichern wurde abgebrochen
    ELSE.
      PERFORM ordergen_batch
          USING    rjksd13-batch_startdate
                   rjksd13-batch_starttime
                   rjksd13-batch_startimmediate
                   rjksd13-vkorg
                   rjksd13-auart
                   marked_issue_tab
         CHANGING  xbatch_error.
    ENDIF.
  ENDIF.
ENDFORM.                    " CALL_auftragsgenerierung


*---------------------------------------------------------------------*
*       FORM ordergen_BATCH                                           *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  MEDPROD                                                       *
*  -->  RJP_MG0-BATCH_STARTDATE                                       *
*  -->  RJP_MG0-BATCH_STARTTIME                                       *
*  -->  RJP_MG0-BATCH_STARTIMMEDIATE                                  *
*  -->  XBATCH_ERROR                                                  *
*---------------------------------------------------------------------*
FORM ordergen_batch
    USING    rjksd13-batch_startdate
             rjksd13-batch_starttime
             rjksd13-batch_startimmediate
             rjksd13-vkorg
             rjksd13-auart
             marked_issue_tab TYPE marked_tab
    CHANGING xbatch_error .
*
*
  DATA: jobnummer            LIKE tbtcjob-jobcount,
        jobname              LIKE tbtcjob-jobname,
        job_already_released.
*
  DATA: in_startdate LIKE syst-datum.
  DATA: in_starttime LIKE syst-uzeit.
  DATA: ls_issue LIKE LINE OF marked_issue_tab.
  RANGES: issue_range FOR mara-matnr.
  RANGES: vkorg_range FOR mara-matnr.

*
  CLEAR xbatch_error.
  CLEAR issue_range. REFRESH issue_range.
  CLEAR vkorg_range. REFRESH vkorg_range.

*
* Übernahme des Jobnamens aus der LISPLT
  jobname = text-013.                  "Auftragsgenerierung
*
** Anlegen eines Hintergrundjobs
  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      delanfrep        = ' '
      jobgroup         = ' '
      jobname          = jobname
    IMPORTING
      jobcount         = jobnummer
    EXCEPTIONS
      cant_create_job  = 01
      invalid_job_data = 02
      jobname_missing  = 03.
  IF sy-subrc = 01 OR sy-subrc = 02.
*   Hintergrundjob konnte nicht angelegt werden
    MESSAGE s034(jpmgen).
    xbatch_error = con_angekreuzt.
    EXIT.
  ELSEIF sy-subrc = 03.
*   Hintergrundjob hat keinen Namen
    MESSAGE s035(jpmgen).
    xbatch_error = con_angekreuzt.
    EXIT.
  ENDIF.
*
* Add a job step to a report
* Prepare Selection for report
  CLEAR vkorg_range.
  vkorg_range-sign = 'I'.
  vkorg_range-option = 'EQ'.
  vkorg_range-low = rjksd13-vkorg.
  APPEND vkorg_range.
  LOOP AT marked_issue_tab INTO ls_issue.
    CLEAR issue_range.
    issue_range-sign = 'I'.
    issue_range-option = 'EQ'.
    issue_range-low = ls_issue-matnr.
    APPEND issue_range.
  ENDLOOP.
* job step = REPORT starten
  SUBMIT rjksdordergen AND RETURN
         USER sy-uname                 " Benutzername
         VIA JOB jobname               " JOBNAME, d.h. TEXT
             NUMBER jobnummer          " JOBNUMMER.
*        via selection-screen    "Test
          WITH vkorg IN vkorg_range
          WITH doc   = rjksd13-auart
          WITH issue IN issue_range
          WITH testrun = con_char_blank.  "immer Echtlauf
  IF sy-subrc <> 0.
    CALL FUNCTION 'BP_JOB_DELETE'
      EXPORTING
        forcedmode = 'X'
        jobcount   = jobnummer
        jobname    = jobname.
*   Löschen des Hintergrundjobs, da er nicht eingeplant werden kann
    MESSAGE s036(jpmgen).
    xbatch_error = con_angekreuzt.
    EXIT.
  ENDIF.
*
* Vorbelegung in JOB_CLOSE für TAG/ZEIT ist Blank!!
* (mit Intialwerten bricht JOB_CLOSE ab!)
  IF rjksd13-batch_startdate IS INITIAL.
    in_startdate = '       '.
  ELSE.
    in_startdate = rjksd13-batch_startdate.
  ENDIF.
  IF rjksd13-batch_starttime IS INITIAL.
    in_starttime = '     '.
  ELSE.
    in_starttime = rjksd13-batch_starttime.
  ENDIF.
* Pass job to background processing
* Job cannot be started until you have closed it
  CALL FUNCTION 'JOB_CLOSE'
    EXPORTING
      jobcount             = jobnummer
      jobname              = jobname
      sdlstrtdt            = in_startdate
      sdlstrttm            = in_starttime
      strtimmed            = rjksd13-batch_startimmediate
*       IMPORTING
*     JOB_WAS_RELEASED     = JOB_ALREADY_RELEASED
    EXCEPTIONS
      cant_start_immediate = 01
      invalid_startdate    = 02
      jobname_missing      = 03
      job_close_failed     = 04
      job_nosteps          = 05
      job_notex            = 06
      lock_failed          = 07.
*
  IF sy-subrc <> 0.
    CALL FUNCTION 'BP_JOB_DELETE'
      EXPORTING
        forcedmode = 'X'
        jobcount   = jobnummer
        jobname    = jobname.
*   Löschen des Hintergrundjobs, da er nicht eingeplant werden kann
    MESSAGE s036(jpmgen).
    xbatch_error = con_angekreuzt.
    EXIT.
  ELSE.
*   Hintergrundjob wurde erfolgreich eingeplant
    MESSAGE s037.
  ENDIF.
*
ENDFORM.                               "ORDERGEN_batch

*---------------------------------------------------------------------*
*       FORM POPUP_FUER_BATCHJOB                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  RJKSD13-BATCH_STARTDATE                                       *
*  -->  RJKSD13-BATCH_STARTTIME                                       *
*  -->  RJKSD13-BATCH_STARTIMMEDIATE                                  *
*  -->  RJKSD13-VKORG                                                 *
*  -->  RJKSD13-AUART                                                 *
*  -->  POPUP_STATUS                                                  *
*---------------------------------------------------------------------*
FORM popup_fuer_batchjob
     CHANGING rjksd13-batch_startdate
              rjksd13-batch_starttime
              rjksd13-batch_startimmediate
              rjksd13-vkorg rjksd13-auart
              popup_status.

*
* Init
  CLEAR popup_status.
  CLEAR gv_cancel.
  CLEAR rjksd13-batch_starttime.
  rjksd13-batch_startimmediate = con_angekreuzt.
  rjksd13-batch_startdate = syst-datum.

*
  CALL SCREEN 500 STARTING AT 10 3.
*
  IF NOT gv_cancel IS INITIAL.
    popup_status = con_popupstatus_abort.
  ENDIF.
*

ENDFORM.                    "POPUP_FUER_BATCHJOB

*&--------------------------------------------------------------------*
*&      Form  MAKTX_FILL
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->P_MATNR    text
*      -->P_MAKTX    text
*---------------------------------------------------------------------*
FORM maktx_fill USING    p_matnr
                CHANGING p_maktx.
*
  DATA: BEGIN OF makt_db_tab OCCURS 0.
          INCLUDE STRUCTURE makt.
        DATA: END   OF makt_db_tab.
*
  DATA: tabcount LIKE sy-tabix.

* MAKT lesen (alle Sprachen)
  CLEAR makt_db_tab. REFRESH makt_db_tab.
  SELECT * FROM makt INTO TABLE makt_db_tab
    WHERE matnr = p_matnr.
*
  PERFORM maktx_select TABLES makt_db_tab
                     CHANGING p_maktx.

*
ENDFORM.                               " MAKTX_FILL


*&--------------------------------------------------------------------*
*&      Form  MAKTX_SELECT
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->MAKT_TAB   text
*      -->P_MAKTX    text
*---------------------------------------------------------------------*
FORM maktx_select TABLES   makt_tab STRUCTURE makt
                     CHANGING p_maktx.
*
  DATA: tabcount LIKE sy-tabix.
*
  CLEAR p_maktx.
  DESCRIBE TABLE makt_tab LINES tabcount.
  CASE tabcount.
    WHEN 0.
    WHEN 1.
      READ TABLE makt_tab INDEX 1.
      p_maktx = makt_tab-maktx.
    WHEN OTHERS.
*     Materialtext für n Sprachen vorhanden
      LOOP AT makt_tab.
        IF makt_tab-spras = sy-langu.
          p_maktx = makt_tab-maktx.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF p_maktx IS INITIAL.
        READ TABLE makt_tab INDEX 1.
        p_maktx = makt_tab-maktx.
      ENDIF.
  ENDCASE.
*
ENDFORM.                               " maktx_fill_back


*&---------------------------------------------------------------------*
*&      Form  sel_by_publdate
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LT_MEDPROD     text
*      -->XSEQUENCE      text
*      -->SEL_DATE_FROM  text
*      -->SEL_DATE_TO    text
*      -->PT_STATUSLIST  text
*      -->LT_MARC        text
*      -->LT_MVKE        text
*----------------------------------------------------------------------*
*form sel_by_publdate                                        "TK10082005
FORM sel_by_mara_date                                       "TK01022008
   USING lt_medprod  TYPE medprod_tab
         xsequence sel_date_from sel_date_to
         rjksdworklist_changefields                         "TK01022008
                        TYPE rjksdworklist_changefields     "TK01022008
  CHANGING   pt_statuslist TYPE status_tab_type
             lt_marc TYPE jksdmarcstattab
             lt_mvke TYPE jksdmvkestattab .

*
  DATA: ls_statuslist LIKE LINE OF pt_statuslist.
  DATA: ls_marc TYPE jksdmarcstat.  "MARC_STRU
  DATA: ls_mvke TYPE jksdmvkestat. "MVKE_STRU.
  DATA: xmarc_sel_input TYPE xfeld.
  DATA: xmvke_sel_input TYPE xfeld.
  DATA: xmarc_selected TYPE xfeld.
  DATA: xmvke_selected TYPE xfeld.


*
  IF xsequence IS INITIAL.
*   Select Issues from MARA
*   (SPART concerns to Media-Issue; Spart currently not active in
*    Selection)
*   SELECT ISMREFMDPROD MATNR ISMPUBLDATE ISMINITSHIPDATE ISMCOPYNR "TK01102006
*         MSTAV MSTDV MSTAE MSTDE ATTYP                             "TK01102006
    SELECT *                                                "TK01102006
      FROM mara
        INTO CORRESPONDING FIELDS OF TABLE pt_statuslist
        FOR ALL ENTRIES IN lt_medprod
        WHERE ismhierarchlevl = con_lvl_med_iss
        AND   ismrefmdprod   = lt_medprod-matnr
        AND   mstav          IN gr_mstav
        AND   mstae          IN gr_mstae
        AND   matnr          IN gr_issue                     "SEL_ISSUE
        AND   ismpubldate    >= sel_date_from
        AND   ismpubldate    <= sel_date_to.
    SORT pt_statuslist BY ismrefmdprod ismpubldate.         "TK25022005
  ELSE.
*   select issues form issue-sequence
*   PERFORM ISSUE_SEQUENCE_READ USING LT_MEDPROD             "TK0106205
    PERFORM issue_sequence_read_new USING lt_medprod        "TK0106205
                                      sel_date_from sel_date_to
                             CHANGING pt_statuslist .
  ENDIF.
*
* Kurztexte ergänzen (MAKT)
  LOOP AT pt_statuslist INTO ls_statuslist.
*   Matertialkurztext Med.prod. lesen: Mimik analog ISM_POST_MSD_DATA
    PERFORM maktx_fill USING ls_statuslist-ismrefmdprod
                CHANGING ls_statuslist-medprod_maktx.
*   Matertialkurztext Med.prod. lesen: Mimik analog ISM_POST_MSD_DATA
    PERFORM maktx_fill USING ls_statuslist-matnr
                CHANGING ls_statuslist-medissue_maktx.
*
*   ev. JPTMARA-BADIFIELDS lesen-------------Anfang------"TK01102006
    PERFORM jptmara_badifields_fill USING ls_statuslist-matnr
                      CHANGING ls_statuslist.
*   ev. JPTMARA-BADIFIELDS lesen--------------Ende-------"TK01102006
    MODIFY pt_statuslist FROM ls_statuslist.
  ENDLOOP.

*
  IF pt_statuslist[] IS INITIAL.
    EXIT. "=> Endform
  ENDIF.
*
** Prüfung erst NACH(!) Segment-Eingrenzung--- Anfang----- "TK29042008
** ein Mix aus Industrie- und Retailmaterialien wird nicht verarbeitet.
** (Grund: die Protokollaufbereitungen unterscheiden sich wesentlich!)
** Auslagerung in Form                                     "TK10082005
*  perform check_industry_retail_mix                         "TK10082005
*     using PT_STATUSLIST
*     changing XINDUSTRYMATERIAL XRETAILMATERIAL.
*  IF XINDUSTRYMATERIAL = CON_ANGEKREUZT    AND
*     XRETAILMATERIAL   = CON_ANGEKREUZT.
*    CLEAR PT_STATUSLIST.
*    EXIT. "=> Endform
*  ENDIF.
** Prüfung erst NACH(!) Segment-Eingrenzung--- Ende------- "TK29042008

* Select MARC
  IF gv_werk IS INITIAL.
*   SELECT MATNR WERKS MMSTA MMSTD                               "TK01102006
*          ismpurchasedate ismarrivaldateac ismarrivaldatepl     "TK01102006
    SELECT *                                                "TK01102006
      FROM marc
    INTO CORRESPONDING FIELDS OF TABLE lt_marc
    FOR ALL ENTRIES IN pt_statuslist
    WHERE matnr = pt_statuslist-matnr
    AND   mmsta IN gr_mmsta.
  ELSE.
*   SELECT MATNR WERKS MMSTA MMSTD                               "TK01102006
*          ismpurchasedate ismarrivaldateac ismarrivaldatepl     "TK01102006
    SELECT *                                                "TK01102006
      FROM marc
    INTO CORRESPONDING FIELDS OF TABLE lt_marc
    FOR ALL ENTRIES IN pt_statuslist
    WHERE matnr = pt_statuslist-matnr
    AND   mmsta IN gr_mmsta
    AND   werks = gv_werk.
  ENDIF.
*
* Select MVKE
*  SELECT MATNR VKORG VTWEG VMSTA VMSTD                             "TK01102006
*         ismcolldate isminterrupt isminterruptdate isminitshipdate "TK01102006
*         ismonsaledate ismoffsaledate                              "TK01102006
*         ismreturnbegin ismreturnend                               "TK01102006
  SELECT *                                                  "TK01102006
   FROM mvke
 INTO CORRESPONDING FIELDS OF TABLE lt_mvke
 FOR ALL ENTRIES IN pt_statuslist
 WHERE matnr = pt_statuslist-matnr
 AND   vmsta IN gr_vmsta.
*
  SORT lt_mvke. SORT lt_marc.                               "TK10082005

  PERFORM authority_check_marc_mvke USING    gv_display     "TK13062008
                                    CHANGING lt_marc        "TK13062008
                                             lt_mvke.       "TK13062008

*
* Check VKORG / VTWEG
* Auslagerung in Form                            "TK10082005
  PERFORM check_sel_vkorg_vtweg                             "TK10082005
             CHANGING lt_mvke.
*
*----------------------------------------------------------------
* If selection for MARC and/or VKORG/VTWEG was done, only
* issues(MARA) for selected MARC/Vkorg/Vtweg-segments are relevant.
* Auslagerung in Form                            "TK10082005
  PERFORM check_sel_mara_vkorg_vtweg                        "TK10082005
             CHANGING pt_statuslist lt_mvke lt_marc.

*----------------------------------------------------------------
*
ENDFORM. " sel_by_publdate.                          "TK10082005


*&---------------------------------------------------------------------*
*&      Form  sel_by_mara_erfdate
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LT_MEDPROD     text
*      -->XSEQUENCE      text
*      -->SEL_DATE_FROM  text
*      -->SEL_DATE_TO    text
*      -->PT_STATUSLIST  text
*      -->LT_MARC        text
*      -->LT_MVKE        text
*----------------------------------------------------------------------*
FORM sel_by_mara_erfdate                                    "TK26062008
   USING lt_medprod  TYPE medprod_tab
         xsequence sel_date_from sel_date_to
  CHANGING   pt_statuslist TYPE status_tab_type
             lt_marc TYPE jksdmarcstattab
             lt_mvke TYPE jksdmvkestattab .

*
  DATA: ls_statuslist LIKE LINE OF pt_statuslist.
  DATA: ls_marc TYPE jksdmarcstat.  "MARC_STRU
  DATA: ls_mvke TYPE jksdmvkestat. "MVKE_STRU.
  DATA: xmarc_sel_input TYPE xfeld.
  DATA: xmvke_sel_input TYPE xfeld.
  DATA: xmarc_selected TYPE xfeld.
  DATA: xmvke_selected TYPE xfeld.


*
* Select Issues from MARA
  SELECT *
    FROM mara
      INTO CORRESPONDING FIELDS OF TABLE pt_statuslist
      FOR ALL ENTRIES IN lt_medprod
      WHERE ismhierarchlevl = con_lvl_med_iss
      AND   ismrefmdprod   = lt_medprod-matnr
      AND   mstav          IN gr_mstav
      AND   mstae          IN gr_mstae
      AND   matnr          IN gr_issue                     "SEL_ISSUE
      AND   ersda           >= sel_date_from
      AND   ersda           <= sel_date_to.
  SORT pt_statuslist BY ismrefmdprod ismpubldate.
*
  IF NOT xsequence IS INITIAL.
*   Ausgaben, die in keiner Ausgabenfolge sind, aus pt_statuslist löschen
    LOOP AT pt_statuslist INTO ls_statuslist.
      SELECT * FROM jptmg0 INTO ls_jptmg0
        WHERE med_prod   = ls_statuslist-ismrefmdprod
        AND   matnr      = ls_statuslist-matnr.
        EXIT.  "=> ENDSELECT
      ENDSELECT.
      IF sy-subrc <> 0.
        DELETE pt_statuslist.
      ENDIF.
    ENDLOOP.
  ENDIF.

* Kurztexte ergänzen (MAKT)
  LOOP AT pt_statuslist INTO ls_statuslist.
*   Matertialkurztext Med.prod. lesen: Mimik analog ISM_POST_MSD_DATA
    PERFORM maktx_fill USING ls_statuslist-ismrefmdprod
                CHANGING ls_statuslist-medprod_maktx.
*   Matertialkurztext Med.prod. lesen: Mimik analog ISM_POST_MSD_DATA
    PERFORM maktx_fill USING ls_statuslist-matnr
                CHANGING ls_statuslist-medissue_maktx.
*
*   ev. JPTMARA-BADIFIELDS lesen-------------Anfang------"TK01102006
    PERFORM jptmara_badifields_fill USING ls_statuslist-matnr
                      CHANGING ls_statuslist.
*   ev. JPTMARA-BADIFIELDS lesen--------------Ende-------"TK01102006
    MODIFY pt_statuslist FROM ls_statuslist.
  ENDLOOP.

*
  IF pt_statuslist[] IS INITIAL.
    EXIT. "=> Endform
  ENDIF.
*
** Prüfung erst NACH(!) Segment-Eingrenzung--- Anfang----- "TK29042008
** ein Mix aus Industrie- und Retailmaterialien wird nicht verarbeitet.
** (Grund: die Protokollaufbereitungen unterscheiden sich wesentlich!)
** Auslagerung in Form                                     "TK10082005
*  perform check_industry_retail_mix                         "TK10082005
*     using PT_STATUSLIST
*     changing XINDUSTRYMATERIAL XRETAILMATERIAL.
*  IF XINDUSTRYMATERIAL = CON_ANGEKREUZT    AND
*     XRETAILMATERIAL   = CON_ANGEKREUZT.
*    CLEAR PT_STATUSLIST.
*    EXIT. "=> Endform
*  ENDIF.
** Prüfung erst NACH(!) Segment-Eingrenzung--- Ende------- "TK29042008

* Select MARC
  IF gv_werk IS INITIAL.
*   SELECT MATNR WERKS MMSTA MMSTD                               "TK01102006
*          ismpurchasedate ismarrivaldateac ismarrivaldatepl     "TK01102006
    SELECT *                                                "TK01102006
      FROM marc
    INTO CORRESPONDING FIELDS OF TABLE lt_marc
    FOR ALL ENTRIES IN pt_statuslist
    WHERE matnr = pt_statuslist-matnr
    AND   mmsta IN gr_mmsta.
  ELSE.
*   SELECT MATNR WERKS MMSTA MMSTD                               "TK01102006
*          ismpurchasedate ismarrivaldateac ismarrivaldatepl     "TK01102006
    SELECT *                                                "TK01102006
      FROM marc
    INTO CORRESPONDING FIELDS OF TABLE lt_marc
    FOR ALL ENTRIES IN pt_statuslist
    WHERE matnr = pt_statuslist-matnr
    AND   mmsta IN gr_mmsta
    AND   werks = gv_werk.
  ENDIF.
*
* Select MVKE
*  SELECT MATNR VKORG VTWEG VMSTA VMSTD                             "TK01102006
*         ismcolldate isminterrupt isminterruptdate isminitshipdate "TK01102006
*         ismonsaledate ismoffsaledate                              "TK01102006
*         ismreturnbegin ismreturnend                               "TK01102006
  SELECT *                                                  "TK01102006
   FROM mvke
 INTO CORRESPONDING FIELDS OF TABLE lt_mvke
 FOR ALL ENTRIES IN pt_statuslist
 WHERE matnr = pt_statuslist-matnr
 AND   vmsta IN gr_vmsta.
*
  SORT lt_mvke. SORT lt_marc.                               "TK10082005

  PERFORM authority_check_marc_mvke USING    gv_display     "TK13062008
                                    CHANGING lt_marc        "TK13062008
                                             lt_mvke.       "TK13062008

*
* Check VKORG / VTWEG
* Auslagerung in Form                            "TK10082005
  PERFORM check_sel_vkorg_vtweg                             "TK10082005
             CHANGING lt_mvke.
*
*----------------------------------------------------------------
* If selection for MARC and/or VKORG/VTWEG was done, only
* issues(MARA) for selected MARC/Vkorg/Vtweg-segments are relevant.
* Auslagerung in Form                            "TK10082005
  PERFORM check_sel_mara_vkorg_vtweg                        "TK10082005
             CHANGING pt_statuslist lt_mvke lt_marc.

*----------------------------------------------------------------
*
ENDFORM. " sel_by_mara_erfdate.                          "TK26062008

*&---------------------------------------------------------------------*
*&      Form  sel_by_onsaledate
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LT_MEDPROD     text
*      -->XSEQUENCE      text
*      -->SEL_DATE_FROM  text
*      -->SEL_DATE_TO    text
*      -->PT_STATUSLIST  text
*      -->LT_MARC        text
*      -->LT_MVKE        text
*----------------------------------------------------------------------*
FORM sel_by_mvke_date                                       "TK01022008
*orm sel_by_onsaledate                                      "TK10082005
   USING lt_medprod  TYPE medprod_tab
         xsequence sel_date_from sel_date_to
         rjksdworklist_changefields                         "TK01022008
                        TYPE rjksdworklist_changefields     "TK01022008
  CHANGING   pt_statuslist TYPE status_tab_type
             lt_marc TYPE jksdmarcstattab
             lt_mvke TYPE jksdmvkestattab .

*
* Selection is mainly determined through segment MVKE
*

* ranges: range_matnr_prod for mara-matnr.                 "TK25092009 hint1389068
  DATA:   range_matnr_prod TYPE rjp_matnr_range_tab.       "TK25092009 hint1389068
  DATA:   ls_range_matnr_prod TYPE rjp_matnr_range.        "TK25092009 hint1389068

  DATA: ls_statuslist LIKE LINE OF pt_statuslist.
  DATA: ls_marc TYPE jksdmarcstat.  "MARC_STRU
  DATA: ls_mvke TYPE jksdmvkestat. "MVKE_STRU.
  DATA: lt_mara TYPE amara_tab .
  DATA: ls_mara TYPE amara_stru.
  DATA: ls_medprod TYPE matnr_stru.
*
* -------- Anfang------------------------------------------- "TK01022008
  DATA: t1  TYPE c LENGTH 30,                 "  VALUE 'ISMPUBLDATE',
        t2  TYPE c LENGTH 4 VALUE ' >= ',
        t22 TYPE c LENGTH 4 VALUE ' <= ',
        t3  TYPE c LENGTH 4 VALUE ' '' ',
        t44 TYPE c LENGTH 10,                  "  VALUE '20080101',
        t4  TYPE c LENGTH 10,                  "  VALUE '20080101',
        t5  TYPE c LENGTH 4 VALUE ''' '.
  DATA: ls_and_from TYPE string.                            "TK01022008
  DATA: ls_and_to TYPE string.                              "TK01022008
  CONSTANTS: con_onsaledate    TYPE fieldname VALUE 'MVKE~ISMONSALEDATE'.  "TK25092009 hint1389068
  CONSTANTS: con_returnbegin   TYPE fieldname VALUE 'MVKE~ISMRETURNBEGIN'. "TK25092009 hint1389068
  CONSTANTS: con_returnend     TYPE fieldname VALUE 'MVKE~ISMRETURNEND'.   "TK25092009 hint1389068
  CONSTANTS: con_offsaledate   TYPE fieldname VALUE 'MVKE~ISMOFFSALEDATE'. "TK25092009 hint1389068
* -------- Ende--------------------------------------------- "TK01022008

* todo inaktiveren range_matnr_prod nach den tests !!!!

* Prepare Range_tab for selected products
  LOOP AT lt_medprod INTO ls_medprod.
*   clear range_matnr_prod.                              "TK25092009 hint1389068
*   range_matnr_prod-sign   = 'I'.                       "TK25092009 hint1389068
*   range_matnr_prod-option = 'EQ'.                      "TK25092009 hint1389068
*   range_matnr_prod-low    = ls_medprod-matnr.          "TK25092009 hint1389068
*   append range_matnr_prod.                             "TK25092009 hint1389068
    CLEAR ls_range_matnr_prod.                           "TK25092009 hint1389068
    ls_range_matnr_prod-sign   = 'I'.                    "TK25092009 hint1389068
    ls_range_matnr_prod-option = 'EQ'.                   "TK25092009 hint1389068
    ls_range_matnr_prod-low    = ls_medprod-matnr.       "TK25092009 hint1389068
    APPEND ls_range_matnr_prod TO range_matnr_prod.      "TK25092009 hint1389068
  ENDLOOP.
*

* -------- Anfang------------------------------------------- "TK01022008
  t4 = sel_date_from.
  t44 = sel_date_to.
  IF rjksdworklist_changefields-xonsaledate = con_angekreuzt.
    t1 = con_onsaledate.
  ENDIF.
  IF rjksdworklist_changefields-xismreturnbegin = con_angekreuzt.
    t1 = con_returnbegin.
  ENDIF.
  IF rjksdworklist_changefields-xismreturnend = con_angekreuzt.
    t1 = con_returnend.
  ENDIF.
  IF rjksdworklist_changefields-xismoffsaledate = con_angekreuzt.
    t1 = con_offsaledate.
  ENDIF.

  CONCATENATE t1 t2 t3 t4 t5 INTO ls_and_from.              "TK01022008
  CONCATENATE t1 t22 t3 t44 t5 INTO ls_and_to.              "TK01022008
* -------- Ende--------------------------------------------- "TK01022008

* ----Anfang-------alte Selektion inaktiviert---------------"TK25092009 hint1389068
** Select MVKE  - with ISMONSALEDATE
**              - for all products
**  SELECT MATNR VKORG VTWEG VMSTA VMSTD                             "TK01102006
**         ismcolldate isminterrupt isminterruptdate isminitshipdate "TK01102006
**         ismonsaledate ismoffsaledate                              "TK01102006
**         ismreturnbegin ismreturnend                               "TK01102006
*  select *                                                  "TK01102006
*   from mvke
* into corresponding fields of table lt_mvke
**  FOR ALL ENTRIES IN PT_STATUSLIST
**    WHERE MATNR = PT_STATUSLIST-MATNR
* where  vmsta in gr_vmsta
** and   ismonsaledate between sel_date_from and sel_date_to.   "TK01022008
*  and  (ls_and_from)      "    and DATUM >= FROMDATE           "TK01022008
*  and  (ls_and_to)   .    "    and DATUM <= TODATE             "TK01022008
*
**
** Check selected products for LT_MVKE
*  if not lt_medprod[] is initial.
*    loop at lt_mvke into ls_mvke.
*      select single * from mara into ls_mara
*        where matnr = ls_mvke-matnr
*        and   ismrefmdprod in range_matnr_prod.
*      if sy-subrc <> 0.
*        delete lt_mvke.
*      endif.
*    endloop.
*  endif.
* ----Ende---------alte Selektion inaktiviert---------------"TK25092009 hint1389068

* ----Anfang-------neue Selektion---------------------------"TK25092009 hint1389068
* Die unterschiedlichen Selektions-Datümer werden in ls_and_from und ls_and_to übergeben.
  PERFORM mvke_select_ismdate USING range_matnr_prod ls_and_from ls_and_to
                             CHANGING lt_mvke.
* ----Ende---------neue Selektion---------------------------"TK25092009 hint1389068

  CHECK NOT lt_mvke[] IS INITIAL.

* Select MARC ( for all Materials with selected MVKE )
  IF gv_werk IS INITIAL.
*   SELECT MATNR WERKS MMSTA MMSTD                               "TK01102006
*          ismpurchasedate ismarrivaldateac ismarrivaldatepl     "TK01102006
    SELECT *                                                "TK01102006
      FROM marc
    INTO CORRESPONDING FIELDS OF TABLE lt_marc
    FOR ALL ENTRIES IN lt_mvke
    WHERE matnr = lt_mvke-matnr
    AND     mmsta IN gr_mmsta.
  ELSE.
*    SELECT MATNR WERKS MMSTA MMSTD                              "TK01102006
*           ismpurchasedate ismarrivaldateac ismarrivaldatepl    "TK01102006
    SELECT *                                                "TK01102006
      FROM marc
    INTO CORRESPONDING FIELDS OF TABLE lt_marc
    FOR ALL ENTRIES IN lt_mvke
    WHERE matnr = lt_mvke-matnr
    AND   mmsta IN gr_mmsta
    AND   werks = gv_werk.
  ENDIF.
*
  SORT lt_mvke. SORT lt_marc.                               "TK10082005

  PERFORM authority_check_marc_mvke USING    gv_display     "TK13062008
                                    CHANGING lt_marc        "TK13062008
                                             lt_mvke.       "TK13062008

*
* create PT_STATUSLIST (based on LT_MVKE;
* all materials in LT_MARC are still resented in LT_MVKE)

  LOOP AT lt_mvke INTO ls_mvke.
    CLEAR ls_mara.
    ls_mara-matnr = ls_mvke-matnr.
    APPEND ls_mara TO lt_mara.
  ENDLOOP.
  SORT lt_mara BY matnr.
  DELETE ADJACENT DUPLICATES FROM lt_mara.
*
* Ausgaben direkt selektiert: LT_MARA/LT_MARC/LT_MVKE bereinigen "SEL_ISSUE Anfang
  IF NOT gr_issue[] IS INITIAL.
    LOOP AT lt_mara INTO ls_mara.
      IF ls_mara-matnr IN gr_issue.
*       Ausgabe wurde selektiert
      ELSE.
*       Ausgabe wurde nicht selektiert => aus LT_Mxxx löschen
        DELETE lt_mara.
        LOOP AT lt_marc INTO ls_marc.
          IF ls_marc-matnr = ls_mara-matnr.
            DELETE lt_marc.
          ENDIF.
        ENDLOOP.
        LOOP AT lt_mvke INTO ls_mvke.
*         if ls_mvke-matnr = ls_mvke-matnr.                     "TK14082009/hint1375941
          IF ls_mvke-matnr = ls_mara-matnr.                     "TK14082009/hint1375941
            DELETE lt_mvke.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP. " at lt_mara into ls_mara.
  ENDIF. " not gr_issue[] is initial.

  CHECK NOT lt_mara[] IS INITIAL.

* Ausgaben direkt selektiert: LT_MARA/LT_MARC/LT_MVKE bereinigen "SEL_ISSUE Ende

*  SELECT ISMREFMDPROD MATNR ISMPUBLDATE ISMINITSHIPDATE ISMCOPYNR "TK01102006
*         MSTAV MSTDV MSTAE MSTDE ATTYP                            "TK01102006
  SELECT *                                                  "TK01102006
    FROM mara
      INTO CORRESPONDING FIELDS OF TABLE pt_statuslist
      FOR ALL ENTRIES IN lt_mara
      WHERE ismhierarchlevl = con_lvl_med_iss
*     and   ismrefmdprod    in RANGE_matnr_prod
      AND   matnr          = lt_mara-matnr
      AND   mstav          IN gr_mstav
      AND   mstae          IN gr_mstae.
*      AND   ISMPUBLDATE    >= SEL_DATE_FROM
*      AND   ISMPUBLDATE    <= SEL_DATE_TO.
  SORT pt_statuslist BY ismrefmdprod ismpubldate.
*
** Prüfung erst NACH(!) Segment-Eingrenzung--- Anfang----- "TK29042008
** ein Mix aus Industrie- und Retailmaterialien wird nicht verarbeitet.
** (Grund: die Protokollaufbereitungen unterscheiden sich wesentlich!)
*  perform check_industry_retail_mix
*     using PT_STATUSLIST
*     changing XINDUSTRYMATERIAL XRETAILMATERIAL.
*  IF XINDUSTRYMATERIAL = CON_ANGEKREUZT    AND
*     XRETAILMATERIAL   = CON_ANGEKREUZT.
*    CLEAR PT_STATUSLIST.
*    EXIT. "=> Endform
*  ENDIF.
** Prüfung erst NACH(!) Segment-Eingrenzung--- Ende------- "TK29042008

* Check VKORG / VTWEG
  PERFORM check_sel_vkorg_vtweg
             CHANGING lt_mvke.
*
* If selection for MARC and/or VKORG/VTWEG was done, only
* issues(MARA) for selected MARC/Vkorg/Vtweg-segments are relevant.
  PERFORM check_sel_mara_vkorg_vtweg
             CHANGING pt_statuslist lt_mvke lt_marc.

  IF NOT xsequence IS INITIAL.
*   Check issue in sequence
    LOOP AT pt_statuslist INTO ls_statuslist.
      SELECT * FROM jptmg0 UP TO 1 ROWS
        INTO ls_jptmg0
        WHERE matnr = ls_statuslist-matnr
        AND   med_prod IN range_matnr_prod.
      ENDSELECT.
      IF sy-subrc <> 0.
*       issue not in sequence=>MARA (incl MARC/MVKE) not selected:
*       Delete MARA-entries in PT_STATUSLIST
        DELETE pt_statuslist.
*       Delete MARC-entries in LT_MARC
        PERFORM delete_matnr_in_lt_marc USING ls_statuslist-matnr
                                     CHANGING lt_marc .
*       Delete MVKE-entries in LT_MVKE
        PERFORM delete_matnr_in_lt_mvke USING ls_statuslist-matnr
                                     CHANGING lt_mvke .
      ENDIF.
    ENDLOOP.
  ENDIF.
*
  SORT pt_statuslist BY ismrefmdprod ismpubldate.
*
* Kurztexte ergänzen (MAKT)
  LOOP AT pt_statuslist INTO ls_statuslist.
*   Matertialkurztext Med.prod. lesen: Mimik analog ISM_POST_MSD_DATA
    PERFORM maktx_fill USING ls_statuslist-ismrefmdprod
                CHANGING ls_statuslist-medprod_maktx.
*   Matertialkurztext Med.prod. lesen: Mimik analog ISM_POST_MSD_DATA
    PERFORM maktx_fill USING ls_statuslist-matnr
                CHANGING ls_statuslist-medissue_maktx.
*   ev. JPTMARA-BADIFIELDS lesen-------------Anfang------"TK01102006
    PERFORM jptmara_badifields_fill USING ls_statuslist-matnr
                      CHANGING ls_statuslist.
*   ev. JPTMARA-BADIFIELDS lesen--------------Ende-------"TK01102006
    MODIFY pt_statuslist FROM ls_statuslist.
  ENDLOOP.
*
ENDFORM. " sel_by_onsaledate                                  "TK10082005

*&---------------------------------------------------------------------*
*&      Form  sel_by_purchdate
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LT_MEDPROD     text
*      -->XSEQUENCE      text
*      -->SEL_DATE_FROM  text
*      -->SEL_DATE_TO    text
*      -->PT_STATUSLIST  text
*      -->LT_MARC        text
*      -->LT_MVKE        text
*----------------------------------------------------------------------*
FORM sel_by_marc_date                                       "TK01022008
*form sel_by_purchdate                                       "TK10082005
   USING lt_medprod  TYPE medprod_tab
         xsequence sel_date_from sel_date_to
         rjksdworklist_changefields                         "TK01022008
                        TYPE rjksdworklist_changefields     "TK01022008
  CHANGING   pt_statuslist TYPE status_tab_type
             lt_marc TYPE jksdmarcstattab
             lt_mvke TYPE jksdmvkestattab .

*
* Selection is mainly determined through segment MARC
*
* -------- Anfang------------------------------------------- "TK01022008
  DATA: t1  TYPE c LENGTH 30,                 "  VALUE 'ISMPUBLDATE',
        t2  TYPE c LENGTH 4 VALUE ' >= ',
        t22 TYPE c LENGTH 4 VALUE ' <= ',
        t3  TYPE c LENGTH 4 VALUE ' '' ',
        t44 TYPE c LENGTH 10,                  "  VALUE '20080101',
        t4  TYPE c LENGTH 10,                  "  VALUE '20080101',
        t5  TYPE c LENGTH 4 VALUE ''' '.
  DATA: ls_and_from TYPE string.                            "TK01022008
  DATA: ls_and_to TYPE string.                              "TK01022008
  CONSTANTS: con_purchasedate  TYPE fieldname VALUE 'MARC~ISMPURCHASEDATE'. "TK28072009 hint1369718
  CONSTANTS: con_firstretedi   TYPE fieldname VALUE 'MARC~ISMFIRSTRETEDI'.  "TK28072009 hint1369718
  CONSTANTS: con_latestretedi  TYPE fieldname VALUE 'MARC~ISMLATESTRETEDI'. "TK28072009 hint1369718
  CONSTANTS: con_firstret      TYPE fieldname VALUE 'MARC~ISMFIRSTRET'.     "TK28072009 hint1369718
  CONSTANTS: con_latestret     TYPE fieldname VALUE 'MARC~ISMLATESTRET'.    "TK28072009 hint1369718
  CONSTANTS: con_arrivaldatepl TYPE fieldname VALUE 'MARC~ISMARRIVALDATEPL'."TK28072009 hint1369718
  CONSTANTS: con_arrivaldateac TYPE fieldname VALUE 'MARC~ISMARRIVALDATEAC'.
* -------- Ende--------------------------------------------- "TK01022008

*  ranges: range_matnr_prod for mara-matnr.                 "TK28072009 hint1369718
  DATA:   range_matnr_prod TYPE rjp_matnr_range_tab.       "TK28072009 hint1369718
  DATA:   ls_range_matnr_prod TYPE rjp_matnr_range.        "TK28072009 hint1369718
  DATA: ls_statuslist LIKE LINE OF pt_statuslist.
  DATA: ls_marc TYPE jksdmarcstat.  "MARC_STRU
  DATA: ls_mvke TYPE jksdmvkestat. "MVKE_STRU.
  DATA: lt_mara TYPE amara_tab .
  DATA: ls_mara TYPE amara_stru.
  DATA: ls_medprod TYPE matnr_stru.
*
* Prepare Range_tab for selected products
  LOOP AT lt_medprod INTO ls_medprod.
*   clear range_matnr_prod.                              "TK28072009 hint1369718
*   range_matnr_prod-sign   = 'I'.                       "TK28072009 hint1369718
*   range_matnr_prod-option = 'EQ'.                      "TK28072009 hint1369718
*   range_matnr_prod-low    = ls_medprod-matnr.          "TK28072009 hint1369718
*   append range_matnr_prod.                             "TK28072009 hint1369718
    CLEAR ls_range_matnr_prod.                           "TK28072009 hint1369718
    ls_range_matnr_prod-sign   = 'I'.                    "TK28072009 hint1369718
    ls_range_matnr_prod-option = 'EQ'.                   "TK28072009 hint1369718
    ls_range_matnr_prod-low    = ls_medprod-matnr.       "TK28072009 hint1369718
    APPEND ls_range_matnr_prod TO range_matnr_prod.      "TK28072009 hint1369718
  ENDLOOP.
*

* -------- Anfang------------------------------------------- "TK01022008
  t4 = sel_date_from.
  t44 = sel_date_to.
  IF rjksdworklist_changefields-xpurchdate = con_angekreuzt.
    t1 = con_purchasedate.
  ENDIF.
  IF rjksdworklist_changefields-xismfirstretedi = con_angekreuzt.
    t1 = con_firstretedi.
  ENDIF.
  IF rjksdworklist_changefields-xismlatestretedi = con_angekreuzt.
    t1 = con_latestretedi.
  ENDIF.
  IF rjksdworklist_changefields-xismfirstret = con_angekreuzt.
    t1 = con_firstret.
  ENDIF.
  IF rjksdworklist_changefields-xismlatestret = con_angekreuzt.
    t1 = con_latestret.
  ENDIF.
  IF rjksdworklist_changefields-xismarrivaldatepl = con_angekreuzt.
    t1 = con_arrivaldatepl.
  ENDIF.
  " Below IF condition is added for Actual Goods Arival Date
  IF rjksdworklist_changefields-xincl_phases = con_angekreuzt.
    t1 = con_arrivaldateac.
  ENDIF.


  CONCATENATE t1 t2 t3 t4 t5 INTO ls_and_from.              "TK01022008
  CONCATENATE t1 t22 t3 t44 t5 INTO ls_and_to.              "TK01022008
* -------- Ende--------------------------------------------- "TK01022008

* ----Anfang-------alte Selektion inaktiviert---------------------"TK28072009 hint1369718
** Select MARC  - with ISMPURCHASEDATE
**              - for all products
*  if gv_werk is initial.
**   SELECT MATNR WERKS MMSTA MMSTD                               "TK01102006
**          ismpurchasedate ismarrivaldateac ismarrivaldatepl     "TK01102006
*    select *                                                "TK01102006
*      from marc
*    into corresponding fields of table lt_marc
*    where mmsta           in gr_mmsta
**   and   ismpurchasedate between sel_date_from and sel_date_to."TK01022008
*    and  (ls_and_from)      "    and DATUM >= FROMDATE          "TK01022008
*    and  (ls_and_to)   .    "    and DATUM <= TODATE            "TK01022008
*
*  else.
**    SELECT MATNR WERKS MMSTA MMSTD                              "TK01102006
**           ismpurchasedate ismarrivaldateac ismarrivaldatepl    "TK01102006
*    select *                                                "TK01102006
*      from marc
*    into corresponding fields of table lt_marc
*    where mmsta           in gr_mmsta
*    and   werks           = gv_werk
**   and   ismpurchasedate between sel_date_from and sel_date_to."TK01022008
*    and  (ls_and_from)      "    and DATUM >= FROMDATE          "TK01022008
*    and  (ls_and_to)   .    "    and DATUM <= TODATE            "TK01022008
*  endif.
**
** Check selected products for LT_MARC
*  if not lt_medprod[] is initial.
*    loop at lt_marc into ls_marc.
*      select single * from mara into ls_mara
*        where matnr = ls_marc-matnr
*        and   ismrefmdprod in range_matnr_prod.
*      if sy-subrc <> 0.
*        delete lt_marc.
*      endif.
*    endloop.
*  endif.
* ----Ende---------alte Selektion inaktiviert--------------------"TK28072009 hint1369718

* ----Anfang-------neue Selektion---------------------------------"TK28072009 hint1369718
* Die unterschiedlichen Selektions-Datümer werden in ls_and_from und ls_and_to übergeben.
  PERFORM marc_select_ismdate USING range_matnr_prod ls_and_from ls_and_to
                             CHANGING lt_marc.
* ----Ende---------neue Selektion---------------------------------"TK28072009 hint1369718

  CHECK NOT lt_marc[] IS INITIAL.

* Select MVKE ( for all Materials with selected MARC )
*  SELECT MATNR VKORG VTWEG VMSTA VMSTD                             "TK01102006
*         ismcolldate isminterrupt isminterruptdate isminitshipdate "TK01102006
*         ismonsaledate ismoffsaledate                              "TK01102006
*         ismreturnbegin ismreturnend                               "TK01102006
  SELECT *                                                  "TK01102006
   FROM mvke
 INTO CORRESPONDING FIELDS OF TABLE lt_mvke
 FOR ALL ENTRIES IN lt_marc
 WHERE matnr = lt_marc-matnr
 AND   vmsta IN gr_vmsta .
*
  SORT lt_mvke. SORT lt_marc.                               "TK10082005

  PERFORM authority_check_marc_mvke USING    gv_display     "TK13062008
                                    CHANGING lt_marc        "TK13062008
                                             lt_mvke.       "TK13062008

*
* create PT_STATUSLIST (based on LT_MARC;
* all materials in LT_MVKE are still represented in LT_MARC)
  LOOP AT lt_marc INTO ls_marc.
    CLEAR ls_mara.
    ls_mara-matnr = ls_marc-matnr.
    APPEND ls_mara TO lt_mara.
  ENDLOOP.
  SORT lt_mara BY matnr.
  DELETE ADJACENT DUPLICATES FROM lt_mara.
*
* Ausgaben direkt selektiert: LT_MARA/LT_MARC/LT_MVKE bereinigen "SEL_ISSUE Anfang
  IF NOT gr_issue[] IS INITIAL.
    LOOP AT lt_mara INTO ls_mara.
      IF ls_mara-matnr IN gr_issue.
*       Ausgabe wurde selektiert
      ELSE.
*       Ausgabe wurde nicht selektiert => aus LT_Mxxx löschen
        DELETE lt_mara.
        LOOP AT lt_marc INTO ls_marc.
          IF ls_marc-matnr = ls_mara-matnr.
            DELETE lt_marc.
          ENDIF.
        ENDLOOP.
        LOOP AT lt_mvke INTO ls_mvke.
*         if ls_mvke-matnr = ls_mvke-matnr.                     "TK14082009/hint1375941
          IF ls_mvke-matnr = ls_mara-matnr.                     "TK14082009/hint1375941
            DELETE lt_mvke.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP. " at lt_mara into ls_mara.
  ENDIF. " not gr_issue[] is initial.

  CHECK NOT lt_mara[] IS INITIAL.

* Ausgaben direkt selektiert: LT_MARA/LT_MARC/LT_MVKE bereinigen "SEL_ISSUE Ende

*  SELECT ISMREFMDPROD MATNR ISMPUBLDATE ISMINITSHIPDATE ISMCOPYNR "TK01102006
*         MSTAV MSTDV MSTAE MSTDE ATTYP                            "TK01102006
  SELECT *                                                  "TK01102006
    FROM mara
      INTO CORRESPONDING FIELDS OF TABLE pt_statuslist
      FOR ALL ENTRIES IN lt_mara
      WHERE ismhierarchlevl = con_lvl_med_iss
*     and   ismrefmdprod    in RANGE_matnr_prod
      AND   matnr          = lt_mara-matnr
      AND   mstav          IN gr_mstav
      AND   mstae          IN gr_mstae.
*      AND   ISMPUBLDATE    >= SEL_DATE_FROM
*      AND   ISMPUBLDATE    <= SEL_DATE_TO.
  SORT pt_statuslist BY ismrefmdprod ismpubldate.
*
** Prüfung erst NACH(!) Segment-Eingrenzung--- Anfang----- "TK29042008
** ein Mix aus Industrie- und Retailmaterialien wird nicht verarbeitet.
** (Grund: die Protokollaufbereitungen unterscheiden sich wesentlich!)
*  perform check_industry_retail_mix
*     using PT_STATUSLIST
*     changing XINDUSTRYMATERIAL XRETAILMATERIAL.
*  IF XINDUSTRYMATERIAL = CON_ANGEKREUZT    AND
*     XRETAILMATERIAL   = CON_ANGEKREUZT.
*    CLEAR PT_STATUSLIST.
*    EXIT. "=> Endform
*  ENDIF.
** Prüfung erst NACH(!) Segment-Eingrenzung--- Ende ------ "TK29042008

* Check VKORG / VTWEG
  PERFORM check_sel_vkorg_vtweg
             CHANGING lt_mvke.
*
* If selection for MARC and/or VKORG/VTWEG was done, only
* issues(MARA) for selected MARC/Vkorg/Vtweg-segments are relevant.
  PERFORM check_sel_mara_vkorg_vtweg
             CHANGING pt_statuslist lt_mvke lt_marc.

  IF NOT xsequence IS INITIAL.
*   Check issue in sequence
    LOOP AT pt_statuslist INTO ls_statuslist.
      SELECT * FROM jptmg0 UP TO 1 ROWS
        INTO ls_jptmg0
        WHERE matnr = ls_statuslist-matnr
        AND   med_prod IN range_matnr_prod.
      ENDSELECT.
      IF sy-subrc <> 0.
*       issue not in sequence=>MARA (incl MARC/MVKE) not selected:
*       Delete MARA-entries in PT_STATUSLIST
        DELETE pt_statuslist.
*       Delete MARC-entries in LT_MARC
        PERFORM delete_matnr_in_lt_marc USING ls_statuslist-matnr
                                     CHANGING lt_marc .
*       Delete MVKE-entries in LT_MVKE
        PERFORM delete_matnr_in_lt_mvke USING ls_statuslist-matnr
                                     CHANGING lt_mvke .
      ENDIF.
    ENDLOOP.
  ENDIF.
*
  SORT pt_statuslist BY ismrefmdprod ismpubldate.
*
* Kurztexte ergänzen (MAKT)
  LOOP AT pt_statuslist INTO ls_statuslist.
*   Matertialkurztext Med.prod. lesen: Mimik analog ISM_POST_MSD_DATA
    PERFORM maktx_fill USING ls_statuslist-ismrefmdprod
                CHANGING ls_statuslist-medprod_maktx.
*   Matertialkurztext Med.prod. lesen: Mimik analog ISM_POST_MSD_DATA
    PERFORM maktx_fill USING ls_statuslist-matnr
                CHANGING ls_statuslist-medissue_maktx.
*   ev. JPTMARA-BADIFIELDS lesen-------------Anfang------"TK01102006
    PERFORM jptmara_badifields_fill USING ls_statuslist-matnr
                      CHANGING ls_statuslist.
*   ev. JPTMARA-BADIFIELDS lesen--------------Ende-------"TK01102006
    MODIFY pt_statuslist FROM ls_statuslist.
  ENDLOOP.
*
ENDFORM. " sel_by_purchdate                                  "TK10082005

*&---------------------------------------------------------------------*
*&      Form  check_sel_vkorg_vtweg
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM check_sel_vkorg_vtweg                                  "TK10082005
       CHANGING lt_mvke TYPE jksdmvkestattab .
*
  DATA: ls_mvke TYPE jksdmvkestat. "MVKE_STRU.
*
  IF NOT gv_vkorg IS INITIAL OR
     NOT gv_vtweg IS INITIAL.
    LOOP AT lt_mvke INTO ls_mvke.
      IF gv_vkorg IS INITIAL.
*       Check vtweg
        IF ls_mvke-vtweg <> gv_vtweg.
          DELETE lt_mvke.
        ENDIF.
      ELSE.
        IF gv_vtweg IS INITIAL.
*         Check vkorg
          IF ls_mvke-vkorg <> gv_vkorg.
            DELETE lt_mvke.
          ENDIF.
        ELSE.
*         Check vkorg and vtweg
          IF ls_mvke-vkorg <> gv_vkorg OR
             ls_mvke-vtweg <> gv_vtweg.
            DELETE lt_mvke.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.
*
ENDFORM. " check_sel_vkorg_vtweg.                             "TK10082005

*&---------------------------------------------------------------------*
*&      Form  check_sel_mara_vkorg_vtweg
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PT_STATUSLIST  text
*      -->LT_MVKE        text
*      -->LT_MARC        text
*----------------------------------------------------------------------*
FORM check_sel_mara_vkorg_vtweg                             "TK10082005
       CHANGING pt_statuslist TYPE status_tab_type
                lt_mvke TYPE jksdmvkestattab
                lt_marc TYPE jksdmarcstattab .
*
  DATA: ls_statuslist LIKE LINE OF pt_statuslist.
  DATA: ls_marc TYPE jksdmarcstat.  "MARC_STRU
  DATA: ls_mvke TYPE jksdmvkestat. "MVKE_STRU.
  DATA: xmarc_sel_input TYPE xfeld.
  DATA: xmvke_sel_input TYPE xfeld.
  DATA: xmarc_selected TYPE xfeld.
  DATA: xmvke_selected TYPE xfeld.
*
  IF NOT gr_mmsta[] IS INITIAL   OR
     NOT gv_werk    IS INITIAL .                            "TK10082005
    xmarc_sel_input = con_angekreuzt.
  ENDIF.
  IF NOT gr_vmsta[] IS INITIAL   OR
     NOT gv_vkorg   IS INITIAL   OR                         "TK10082005
     NOT gv_vtweg   IS INITIAL.                             "TK10082005
    xmvke_sel_input = con_angekreuzt.
  ENDIF.
  IF xmarc_sel_input = con_angekreuzt   OR
     xmvke_sel_input = con_angekreuzt.
*   MVKE and/or MARC was selected: Check MARA for selected MARC/MVKE
    LOOP AT pt_statuslist INTO ls_statuslist.
      CLEAR xmarc_selected.
      CLEAR xmvke_selected.
      IF xmarc_sel_input = con_angekreuzt.
        READ TABLE lt_marc INTO ls_marc
                   WITH KEY matnr = ls_statuslist-matnr
                   BINARY SEARCH.
        IF sy-subrc = 0.
          xmarc_selected = con_angekreuzt.
        ENDIF.
      ENDIF.
      IF xmvke_sel_input = con_angekreuzt.
        READ TABLE lt_mvke INTO ls_mvke
                   WITH KEY matnr = ls_statuslist-matnr
                   BINARY SEARCH.
        IF sy-subrc = 0.
          xmvke_selected = con_angekreuzt.
        ENDIF.
      ENDIF.
      IF ( xmarc_sel_input = con_angekreuzt   AND
           xmarc_selected  IS INITIAL             )  OR
         ( xmvke_sel_input = con_angekreuzt   AND
           xmvke_selected IS INITIAL              ) .
*       Delete MARA-entries in LT_PROD_MARA
        DELETE pt_statuslist.
*       Delete MARC-entries in LT_MARC
*       Auslagerung in Form                                       "TK10082005
        PERFORM delete_matnr_in_lt_marc USING ls_statuslist-matnr "TK20082005
                                     CHANGING lt_marc .
*       Delete MVKE-entries in LT_MVKE
*       Auslagerung in Form                                       "TK10082005
        PERFORM delete_matnr_in_lt_mvke USING ls_statuslist-matnr "TK20082005
                                     CHANGING lt_mvke .
      ENDIF.
    ENDLOOP.
  ENDIF.
*
ENDFORM. " check_sel_mara_vkorg_vtweg                          "TK10082005

* Auslagerung in Form                                     "TK10082005
FORM check_industry_retail_mix                              "TK10082005
     USING pt_statuslist TYPE status_tab_type
     CHANGING xindustrymaterial xreatilmaterial.
*
  DATA: ls_statuslist LIKE LINE OF pt_statuslist.
*
  LOOP AT pt_statuslist INTO ls_statuslist.
    IF ls_statuslist-attyp IS INITIAL.
      xindustrymaterial = con_angekreuzt.
    ELSE.
      xretailmaterial = con_angekreuzt.
    ENDIF.
  ENDLOOP.
*
ENDFORM. " check_industry_retail_mix                       "TK10082005

*&---------------------------------------------------------------------*
*&      Form  delete_matnr_in_lt_marc
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->MATNR      text
*      -->LT_MARC    text
*----------------------------------------------------------------------*
FORM delete_matnr_in_lt_marc USING matnr                    "TK20082005
                         CHANGING lt_marc TYPE jksdmarcstattab.
*
  DATA: ls_marc TYPE jksdmarcstat.  "MARC_STRU
*
  DO.
    READ TABLE lt_marc INTO ls_marc
               WITH KEY matnr = matnr
               BINARY SEARCH.
    IF sy-subrc = 0.
      DELETE lt_marc INDEX sy-tabix.
    ELSE.
      EXIT. "=> ENDDO
    ENDIF.
  ENDDO.
*
ENDFORM. " delete_matnr_in_lt_marc                           "TK10082005

*&---------------------------------------------------------------------*
*&      Form  delete_matnr_in_lt_mvke
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->MATNR      text
*      -->LT_MVKE    text
*----------------------------------------------------------------------*
FORM delete_matnr_in_lt_mvke USING matnr                    "TK20082005
                         CHANGING lt_mvke TYPE jksdmvkestattab.
*
  DATA: ls_mvke TYPE jksdmvkestat. "MVKE_STRU.
*
  DO.
    READ TABLE lt_mvke INTO ls_mvke
               WITH KEY matnr = matnr
               BINARY SEARCH.
    IF sy-subrc = 0.
      DELETE lt_mvke INDEX sy-tabix.
    ELSE.
      EXIT. "=> ENDDO
    ENDIF.
  ENDDO.
*
ENDFORM. " delete_matnr_in_lt_mvke                           "TK10082005


*&---------------------------------------------------------------------*
*&      Form  sel_by_initshipdate
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LT_MEDPROD     text
*      -->XSEQUENCE      text
*      -->SEL_DATE_FROM  text
*      -->SEL_DATE_TO    text
*      -->PT_STATUSLIST  text
*      -->LT_MARC        text
*      -->LT_MVKE        text
*----------------------------------------------------------------------*
FORM sel_by_initshipdate                                    "TK10082005
   USING lt_medprod  TYPE medprod_tab
         xsequence sel_date_from sel_date_to
  CHANGING   pt_statuslist TYPE status_tab_type
             lt_marc TYPE jksdmarcstattab
             lt_mvke TYPE jksdmvkestattab .

*
* Selection is mainly determined through segment MVKE
*
  RANGES: range_matnr_prod FOR mara-matnr.
  DATA: ls_statuslist LIKE LINE OF pt_statuslist.
  DATA: ls_marc TYPE jksdmarcstat.  "MARC_STRU
  DATA: ls_mvke TYPE jksdmvkestat. "MVKE_STRU.
  DATA: lt_mara TYPE amara_tab .
  DATA: ls_mara TYPE amara_stru.
  DATA: ls_medprod TYPE matnr_stru.
*
* Prepare Range_tab for selected products
  LOOP AT lt_medprod INTO ls_medprod.
    CLEAR range_matnr_prod.
    range_matnr_prod-sign   = 'I'.
    range_matnr_prod-option = 'EQ'.
    range_matnr_prod-low    = ls_medprod-matnr.
    APPEND range_matnr_prod.
  ENDLOOP.

* ---- inperformante Selektion inaktiviert----- Anfang---- "TK07032007
*
**
** Select MVKE  - with ISMINITHSIPDATE in intervall
**                                     or initial
**              - for all products
**  SELECT MATNR VKORG VTWEG VMSTA VMSTD                             "TK01102006
**         ismcolldate isminterrupt isminterruptdate isminitshipdate "TK01102006
**         ismonsaledate ismoffsaledate                              "TK01102006
**         ismreturnbegin ismreturnend                               "TK01102006
*  SELECT *                                                  "TK01102006
*   FROM MVKE
* INTO CORRESPONDING FIELDS OF TABLE LT_MVKE
**  FOR ALL ENTRIES IN PT_STATUSLIST
**    WHERE MATNR = PT_STATUSLIST-MATNR
* where  VMSTA IN GR_VMSTA
* and   isminitshipdate between sel_date_from and sel_date_to
* or    isminitshipdate EQ '00000000'
* or    isminitshipdate eq space .                       "#EC CI_NOFIRST
*                                                        "#EC CI_NOFIELD
**
** Check selected products for LT_MVKE     AND(!)
** Check MARA-ISMINITSHIPDATE for initial MVKE-INITSHIPDATE
*  if not lt_medprod[] is initial.
*    loop at lt_mvke into ls_mvke.
*      select single * from mara into ls_mara
*        where matnr = ls_mvke-matnr
*        and   ismrefmdprod in RANGE_matnr_prod.
*      if sy-subrc <> 0.
*        delete lt_mvke.
*      else.
**       Product is valid
*        if  ls_mvke-ISMINITSHIPDATE is initial       or
*            ls_mvke-ISMinitshipdate eq space  .
**         Check MARA-ISMINITHSIPDATE            .
*          if ls_mara-isminitshipdate >= sel_date_from  and
*              ls_mara-isminitshipdate <= sel_date_to  .
**           selection (MARA-ISMINITSHIPDATE) is valid
*          else.
**           selection is not valid => delete MVKE-Segement
*            delete lt_mvke.
*          endif.
*        else.
**         selection is valid
*        endif.
*      endif.
*    endloop.
*  endif.
*
* ---- inperformante Selektion inktiviert----- Ende------- "TK07032007


* ------------------- neue Selektion ----- Anfang-----------"TK07032007

  TABLES: mara.

  TYPES: BEGIN OF lt_seg_type,
           matnr           TYPE matnr,
           vkorg           TYPE vkorg,
           vtweg           TYPE vtweg,
           isminitshipdate TYPE sy-datum.
  TYPES:    END OF lt_seg_type.

  DATA: lt_seg_tab TYPE TABLE OF lt_seg_type,
        lt_seg     TYPE lt_seg_type.

  CLEAR lt_seg_tab. REFRESH lt_seg_tab.

* Select inaktiviert---------------start--------"TK15102009/hint1138201
*  SELECT mvke~matnr mvke~vkorg mvke~vtweg mvke~isminitshipdate
*   INTO TABLE lt_seg_TAB
*   FROM mvke AS mvke
*       INNER JOIN MARA AS MARA                              " 453715
*         ON mvke~MATNR = MARA~MATNR                         " 453715
*  WHERE   mvke~VMSTA IN GR_VMSTA                        and
**       Anfang-----------------------"TK01022008 Hinweis 1138201
**                        OR-Bedingung wird zusätzlich geklammert
**       ( mvke~isminitshipdate >= sel_date_from and
**         mvke~isminitshipdate <= sel_date_to        )  or
**       ( mara~isminitshipdate >= sel_date_from and
**         mara~isminitshipdate <= sel_date_to        )  and
*      ( ( mvke~isminitshipdate >= sel_date_from and
*          mvke~isminitshipdate <= sel_date_to        )  or
*        ( mara~isminitshipdate >= sel_date_from and
*          mara~isminitshipdate <= sel_date_to        )  )     and
**       Ende-------------------------"TK01022008 Hinweis 1138201
*          MARA~ISMHIERARCHLEVL EQ '3'                   and
*          MARA~ismrefmdprod in RANGE_matnr_prod         .
* Select inaktiviert---------------end----------"TK15102009/hint1138201

* Select aktiviert-----------------start--------"TK15102009/hint1138201
* 1.) MVKE-INITSHIPDATE selektieren (zunächst OHNE MARA-INITSHIPDATE)
  SELECT mvke~matnr mvke~vkorg mvke~vtweg mvke~isminitshipdate
   INTO TABLE lt_seg_tab
   FROM mvke AS mvke
       INNER JOIN mara AS mara
         ON mvke~matnr = mara~matnr
  WHERE   mvke~vmsta IN gr_vmsta                        AND
          mvke~isminitshipdate >= sel_date_from         AND
          mvke~isminitshipdate <= sel_date_to           AND
          mara~ismhierarchlevl EQ '3'                   AND
          mara~ismrefmdprod IN range_matnr_prod         .

* 2.) MARA-ISMINITSHIPDATE NUR DANN selektieren, wenn MVKE-INITSHIPDATE leer!
  SELECT mvke~matnr mvke~vkorg mvke~vtweg mvke~isminitshipdate
   APPENDING TABLE lt_seg_tab
   FROM mvke AS mvke
       INNER JOIN mara AS mara
         ON mvke~matnr = mara~matnr
  WHERE ( mvke~isminitshipdate = space           OR
          mvke~isminitshipdate = '00000000'          )  AND
          mara~isminitshipdate >= sel_date_from         AND
          mara~isminitshipdate <= sel_date_to           AND
          mvke~vmsta IN gr_vmsta                        AND
          mara~ismhierarchlevl EQ '3'                   AND
          mara~ismrefmdprod IN range_matnr_prod         .
* Select aktiviert-----------------end----------"TK15102009/hint1138201

  IF NOT lt_seg_tab[] IS INITIAL.
    SELECT * FROM mvke INTO CORRESPONDING FIELDS OF TABLE lt_mvke
      FOR ALL ENTRIES IN lt_seg_tab
        WHERE matnr = lt_seg_tab-matnr
        AND   vkorg = lt_seg_tab-vkorg
        AND   vtweg = lt_seg_tab-vtweg .
  ENDIF. " not lt_seg_tab[] is initial.

* ------------------- neue Selektion ----- Ende---------------"TK07032007


  CHECK NOT lt_mvke[] IS INITIAL.
*
* Select MARC ( for all Materials with selected MVKE )
  IF gv_werk IS INITIAL.
*   SELECT MATNR WERKS MMSTA MMSTD                               "TK01102006
*          ismpurchasedate ismarrivaldateac ismarrivaldatepl     "TK01102006
    SELECT *                                                "TK01102006
      FROM marc
    INTO CORRESPONDING FIELDS OF TABLE lt_marc
    FOR ALL ENTRIES IN lt_mvke
    WHERE matnr = lt_mvke-matnr
    AND     mmsta IN gr_mmsta.
  ELSE.
*   SELECT MATNR WERKS MMSTA MMSTD                               "TK01102006
*          ismpurchasedate ismarrivaldateac ismarrivaldatepl     "TK01102006
    SELECT *                                                "TK01102006
      FROM marc
    INTO CORRESPONDING FIELDS OF TABLE lt_marc
    FOR ALL ENTRIES IN lt_mvke
    WHERE matnr = lt_mvke-matnr
    AND   mmsta IN gr_mmsta
    AND   werks = gv_werk.
  ENDIF.
*
  SORT lt_mvke. SORT lt_marc.

  PERFORM authority_check_marc_mvke USING    gv_display     "TK13062008
                                    CHANGING lt_marc        "TK13062008
                                             lt_mvke.       "TK13062008
*
* create PT_STATUSLIST (from LT_MVKE;
* LT_MARC has only MARA-entries from LT_MVKE, not more)
  LOOP AT lt_mvke INTO ls_mvke.
    CLEAR ls_mara.
    ls_mara-matnr = ls_mvke-matnr.
    APPEND ls_mara TO lt_mara.
  ENDLOOP.
  SORT lt_mara BY matnr.
  DELETE ADJACENT DUPLICATES FROM lt_mara.
*
*  SELECT ISMREFMDPROD MATNR ISMPUBLDATE ISMINITSHIPDATE ISMCOPYNR "TK01102006
*         MSTAV MSTDV MSTAE MSTDE ATTYP                            "TK01102006
  SELECT *                                                  "TK01102006
    FROM mara
      INTO CORRESPONDING FIELDS OF TABLE pt_statuslist
      FOR ALL ENTRIES IN lt_mara
      WHERE ismhierarchlevl = con_lvl_med_iss
*     and   ismrefmdprod    in RANGE_matnr_prod
      AND   matnr          = lt_mara-matnr
      AND   mstav          IN gr_mstav
      AND   mstae          IN gr_mstae.
*      AND   ISMPUBLDATE    >= SEL_DATE_FROM
*      AND   ISMPUBLDATE    <= SEL_DATE_TO.
  SORT pt_statuslist BY ismrefmdprod ismpubldate.

** Prüfung erst NACH(!) Segment-Eingrenzung--- Anfang----- "TK29042008
** ein Mix aus Industrie- und Retailmaterialien wird nicht verarbeitet.
** (Grund: die Protokollaufbereitungen unterscheiden sich wesentlich!)
*  perform check_industry_retail_mix
*     using PT_STATUSLIST
*     changing XINDUSTRYMATERIAL XRETAILMATERIAL.
*  IF XINDUSTRYMATERIAL = CON_ANGEKREUZT    AND
*     XRETAILMATERIAL   = CON_ANGEKREUZT.
*    CLEAR PT_STATUSLIST.
*    EXIT. "=> Endform
*  ENDIF.
** Prüfung erst NACH(!) Segment-Eingrenzung--- Ende------- "TK29042008

* Check VKORG / VTWEG
  PERFORM check_sel_vkorg_vtweg
             CHANGING lt_mvke.
*
* If selection for MARC and/or VKORG/VTWEG was done, only
* issues(MARA) for selected MARC/Vkorg/Vtweg-segments are relevant.
  PERFORM check_sel_mara_vkorg_vtweg
             CHANGING pt_statuslist lt_mvke lt_marc.

  IF NOT xsequence IS INITIAL.
*   Check issue in sequence
    LOOP AT pt_statuslist INTO ls_statuslist.
      SELECT * FROM jptmg0 UP TO 1 ROWS
        INTO ls_jptmg0
        WHERE matnr = ls_statuslist-matnr
        AND   med_prod IN range_matnr_prod.
      ENDSELECT.
      IF sy-subrc <> 0.
*       issue not in sequence=>MARA (incl MARC/MVKE) not selected:
*       Delete MARA-entries in PT_STATUSLIST
        DELETE pt_statuslist.
*       Delete MARC-entries in LT_MARC
        PERFORM delete_matnr_in_lt_marc USING ls_statuslist-matnr
                                     CHANGING lt_marc .
*       Delete MVKE-entries in LT_MVKE
        PERFORM delete_matnr_in_lt_mvke USING ls_statuslist-matnr
                                     CHANGING lt_mvke .
      ENDIF.
    ENDLOOP.
  ENDIF.
*
  SORT pt_statuslist BY ismrefmdprod ismpubldate.
*
* Kurztexte ergänzen (MAKT)
  LOOP AT pt_statuslist INTO ls_statuslist.
*   Matertialkurztext Med.prod. lesen: Mimik analog ISM_POST_MSD_DATA
    PERFORM maktx_fill USING ls_statuslist-ismrefmdprod
                CHANGING ls_statuslist-medprod_maktx.
*   Matertialkurztext Med.prod. lesen: Mimik analog ISM_POST_MSD_DATA
    PERFORM maktx_fill USING ls_statuslist-matnr
                CHANGING ls_statuslist-medissue_maktx.
*   ev. JPTMARA-BADIFIELDS lesen-------------Anfang------"TK01102006
    PERFORM jptmara_badifields_fill USING ls_statuslist-matnr
                      CHANGING ls_statuslist.
*   ev. JPTMARA-BADIFIELDS lesen--------------Ende-------"TK01102006
    MODIFY pt_statuslist FROM ls_statuslist.
  ENDLOOP.
*
ENDFORM. " sel_by_initshipdate                                "TK10082005


*&---------------------------------------------------------------------*
*&      Form  JPTMARA_badifields_Fill
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR        text
*      -->LS_STATUSLIST  text
*----------------------------------------------------------------------*
FORM jptmara_badifields_fill                                "TK01102006
         USING p_matnr                                      "TK01102006
         CHANGING ls_statuslist TYPE jksdmaterialstatus.    "TK01102006
*
  DATA: ls_jptmara TYPE jptmara.
*
  SELECT SINGLE * FROM jptmara INTO ls_jptmara
    WHERE matnr = ls_statuslist-matnr.
*
  LOOP AT gt_badi_fields INTO gs_badi_field.
    IF gs_badi_field-fieldname(8) = 'JPTMARA_'.
      PERFORM jptmara_badi_to_ls_statuslist USING ls_jptmara
                                                  ls_statuslist
                                                  gs_badi_field-fieldname.
    ENDIF.
  ENDLOOP. " at gt_badi_fields into gs_badi_field.

*
ENDFORM. " JPTMARA_Fill                                       "TK01102006


*&---------------------------------------------------------------------*
*&      Form  test_fill_customer_fields
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->GT_CHANGE_WORKLIST  text
*----------------------------------------------------------------------*
FORM test_fill_customer_fields
              CHANGING gt_change_worklist TYPE jksdmaterialstatustab .

*  data: ls_worklist type JKSDMATERIALSTATUS.
*  data: ls_jptmg0 type jptmg0.
*  data: text(10).
**
*  loop at gt_change_worklist into ls_worklist.
**   --------------------------------------------------------------
**   fill fields related to segment MARA
**   with key ls_worklist-matnr
**   --------------------------------------------------------------
*    select * from jptmg0 into ls_jptmg0 up to 1 rows
*      where matnr = ls_worklist-matnr.
*    endselect.
*    ls_worklist-JJZZMARAFIELD = ls_jptmg0-mpg_lfdnr.
**   -------------------------------------------------------------
**   fill fields related to segment MVKE
**   with key ls_worklist-matnr
**            ls_worklist-MVKE_VKORG
**            ls_worklist-MVKE_VTWEG
**   --------------------------------------------------------------
*    if not ls_worklist-MVKE_VKORG is initial.
*      write sy-uzeit to text.
*      ls_worklist-JJZZMVKEFIELD = text.
*    endif.
**   --------------------------------------------------------------
**   fill fields related to segment MARC
**   with key ls_worklist-matnr
**            ls_worklist-MARC_WERKS
**    --------------------------------------------------------------
*    if not ls_worklist-MARC_WERKS is initial.
*      write sy-uzeit to text.
*      ls_worklist-JJZZMARCFIELD = text.
*    endif.
**
*    modify gt_change_worklist from ls_worklist.
**
*  endloop. " at gt_change_worklist into ls_worklist.
*
ENDFORM. " test_method_fill_customer_fields.


*&---------------------------------------------------------------------*
*&      Form  test_add_fields
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->GT_BADI_FIELDS  text
*----------------------------------------------------------------------*
FORM test_add_fields CHANGING gt_badi_fields TYPE jksdbaditab.
*
*  data: gs_badi_field type JKSDBADIFIELD.
**
**------------------------------------------------------------------*
** Enhance MARA-Fields
**------------------------------------------------------------------*
** MARA-Non-mediafield: Enhance MARA-PLGTP as output field
*  clear gs_badi_field.
*  gs_badi_field-fieldname = 'PLGTP'.
*  gs_badi_field-xinput    = ' '.
*  append gs_badi_field to gt_badi_fields.
** MARA-Mediafield: Enhance MARA-ISMYEARNR as input field
*  clear gs_badi_field.
*  gs_badi_field-fieldname = 'ISMYEARNR'.
*  gs_badi_field-xinput    = 'X'.
*  append gs_badi_field to gt_badi_fields.
*
** Weiteres Feld auf MARA-Ebene
*  clear gs_badi_field.
*  gs_badi_field-fieldname = 'JJZZMARAFIELD'.
*  gs_badi_field-xinput    = ' '.
*  append gs_badi_field to gt_badi_fields.
*
*
**------------------------------------------------------------------*
** Enhance JPTMARA-Fields
**------------------------------------------------------------------*
** JPTMARA-Mediafield: Enhance JPTMARA-SMFIRSTRETEDI as input field
*  clear gs_badi_field.
*  gs_badi_field-fieldname = 'JPTMARA_ISMFIRSTRETEDI'. "JPTMARA-Medienfeld
*  gs_badi_field-xinput    = 'X'.
*  append gs_badi_field to gt_badi_fields.
** JPTMARA-Mediafield: Enhance JPTMARA-ISMLATESTRETEDI as output field
*  clear gs_badi_field.
*  gs_badi_field-fieldname = 'JPTMARA_ISMLATESTRETEDI'. "JPTMARA-Medienfeld
*  gs_badi_field-xinput    = ' '.
*  append gs_badi_field to gt_badi_fields.
*
**------------------------------------------------------------------*
** Enhance MVKE-Fields
**------------------------------------------------------------------*
** MVKE-Non-mediafield: Enhance MVKE-DWERK as output field
*  clear gs_badi_field.
*  gs_badi_field-fieldname = 'MVKE_DWERK'.        "MVKE-Standardfeld
*  gs_badi_field-xinput    = ' '.
*  append gs_badi_field to gt_badi_fields.
** MVKE-Mediafield: Enhance MVKE-ISMRCPATTERN as input field
*  clear gs_badi_field.
*  gs_badi_field-fieldname = 'MVKE_ISMRCPATTERN'. "MVKE-Medienfeld
*  gs_badi_field-xinput    = 'X'.
*  append gs_badi_field to gt_badi_fields.
*
**------------------------------------------------------------------*
** Enhance MARC-Fields
**------------------------------------------------------------------*
** MARC-Non-mediafield: Enhance MARC-FPRFM as input field
*  clear gs_badi_field.
*  gs_badi_field-fieldname = 'MARC_FPRFM'.       "MARC-Standardfeld
*  gs_badi_field-xinput    = 'X'.
*  append gs_badi_field to gt_badi_fields.
** MARC-Mediafield: Enhance MARC-ISMSTORAGE as output field
*  clear gs_badi_field.
*  gs_badi_field-fieldname = 'MARC_ISMSTORAGE'.  "MARC-Medienfeld
*  gs_badi_field-xinput    = 'X'.
*  append gs_badi_field to gt_badi_fields.
**---------------------------- Test ------Ende--------------------------

ENDFORM. " test_add_fields

* Auslagerung in Form  -------Anfang---------------------"TK28022007
FORM pbo_output.
*
  STATICS: xprocessed TYPE xfeld.
  IF xprocessed IS INITIAL.
    xprocessed = con_angekreuzt.
    IF gv_pedex_active IS INITIAL.
*     PEDEX nicht aktiv: Sprung in Transkationen über Drucktasten
    ELSE.
*     PEDEX aktiv: Drucktasten für Calls sind inaktiv
      READ TABLE excl_buttons WITH KEY fcode = 'MENGENPLAN'.
      IF sy-subrc <> 0.
        excl_buttons-fcode = 'MENGENPLAN'.
        APPEND excl_buttons.
      ENDIF.
      READ TABLE excl_buttons WITH KEY fcode = 'BEILAGPLAN'.
      IF sy-subrc <> 0.
        excl_buttons-fcode = 'BEILAGPLAN'.
        APPEND excl_buttons.
      ENDIF.
      READ TABLE excl_buttons WITH KEY fcode = 'MEDIENAUSG'.
      IF sy-subrc <> 0.
        excl_buttons-fcode = 'MEDIENAUSG'.
        APPEND excl_buttons.
      ENDIF.
      READ TABLE excl_buttons WITH KEY fcode = 'ORDERGEN'.
      IF sy-subrc <> 0.
        excl_buttons-fcode = 'ORDERGEN'.
        APPEND excl_buttons.
      ENDIF.

*-----Anfang------------------------------------------"TK17092009/hint1386691
*     Wenn der BADI zur Vorbelegung der Selektion implementiert ist,
*     dann wird die Selektion sofort durchgeführt und nur die
*     Ergebnisliste OHNE Selektionsscreens angezeigt!
*
      DATA: oref TYPE REF TO cx_root,
            text TYPE string.
*     Vorbelegung der Selektion nur einmalig beim Neustart der Transaktion
      TRY.
          GET BADI worklist_call.
        CATCH cx_badi_not_implemented INTO oref.
          text = oref->get_text( ).
        CATCH cx_badi_multiply_implemented INTO oref.
          text = oref->get_text( ).
      ENDTRY.
      IF NOT worklist_call IS INITIAL.
*       BADI für Vorbelegung der Selektion ist implementiert:
*       => Check, ob Selektion dieser Transaktion vorbelegt wird:
        CALL BADI worklist_call->selection_check_active
          EXPORTING
            in_tcode    = sy-tcode   "Transaktionsvarianten
          IMPORTING
            out_xactive = gv_selection_set_active.
*
        IF gv_selection_set_active = 'X'.
*         Selektion für diese Transaktionsvarinte wird durch BADI vorbelegt; *
*         => es werden keine Selektionsscreens angezeigt
*         angezeigt
          PERFORM no_selection_in_call_mode.
        ENDIF.
      ENDIF.
*-----Ende--------------------------------------------"TK17092009/hint1386691

    ENDIF.
*
  ENDIF. " xprocessed is initial.

* ------Anfang----------------------------------------------"TK01042008
  DATA: lv_tstct LIKE tstct.
* Titel jetzt aus TSTCT(damit Titel je Transktionsvariante)
  CALL FUNCTION 'TSTCT_SINGLE_READ'
    EXPORTING
      sprache    = sy-langu
      tcode      = sy-tcode
*     KZRFB      = ' '
    IMPORTING
      wtstct     = lv_tstct
    EXCEPTIONS
      wrong_call = 1
      OTHERS     = 2.
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
* ------Ende------------------------------------------------"TK01042008

* --------Anfang---------------------------------------"TK15102009/hint1397078
  IF xshow_error_alog <> con_angekreuzt.
*   Update ohne Fehler => keine Drucktaste 'Fehlerprotokoll ausblenden'
    READ TABLE excl_buttons WITH KEY 'ALOG_OUT'.
    IF sy-subrc <> 0.
      excl_buttons-fcode = 'ALOG_OUT'.
      APPEND excl_buttons.
    ENDIF.
  ELSE.
*   Update mit Fehler => Drucktaste 'Fehlerprotokoll ausblenden' anbieten
    LOOP AT excl_buttons.
      IF excl_buttons-fcode = 'ALOG_OUT'.
        DELETE excl_buttons.
        EXIT.  "=> ENDLOOP
      ENDIF.
    ENDLOOP.
  ENDIF.
*  --------Ende-----------------------------------------"TK15102009/hint1397078

  IF gv_display IS INITIAL.
    SET PF-STATUS 'MAIN100' EXCLUDING excl_buttons.
*   SET TITLEBAR 'MAIN100'.
  ELSE.
    SET PF-STATUS 'MAIN100A' EXCLUDING excl_buttons.
*   SET TITLEBAR 'MAIN100A'.
  ENDIF.
  SET TITLEBAR 'MAINTOREPLACE' WITH lv_tstct-ttext.         "TK1042008
*
* --------Anfang---------------------------------------"TK15102009/hint1397078
** ALOG für Update-Fehler nur umittelbar nach dem Sichern anzeigen
** nächste Aktion => ALOG wird automatisch ausgeblendet
*  if xshow_error_alog <> con_angekreuzt.
*    call method log->hide.
*  endif.
*  clear xshow_error_alog.
* --------Ende-----------------------------------------"TK15102009/hint1397078

*
ENDFORM. " pbo_output.
* Auslagerung in Form  -------Ende-----------------------"TK28022007


* Anfang---------------------------------------------------"TK01022008

FORM pbo_310_output.                                        "TK01022008
*
  STATICS: x_310_processed TYPE xfeld.
  IF x_310_processed IS INITIAL.
    x_310_processed = con_angekreuzt.
*   screen modifikation der PDEX2-Felder erfolgt über Schalter
*   in der SE51 ! Hier ist nichts zu tun.
    IF gv_pedex2_active IS INITIAL.
*     PEDEX2 nicht aktiv: Neue Datums-Selektionen werden ausgeblendet
    ELSE.
*     PEDEX2 aktiv: Neue Datums-Selektionen bleiben eingeblendet
    ENDIF.
  ENDIF. " x_310_processed is initial.
*
ENDFORM. " pbo_310_output.


*&---------------------------------------------------------------------*
*&      Form  read_JVTPHDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PT_STATUSLIST  text
*      -->PT_JVTPHDATE   text
*----------------------------------------------------------------------*
FORM read_jvtphdate                                         "TK01022008
     USING pt_statuslist TYPE status_tab_type
           pv_date_from pv_date_to
           CHANGING pt_jvtphdate TYPE jvtphdate_tab.
*
  SELECT * FROM jvtphdate INTO TABLE pt_jvtphdate
    FOR ALL ENTRIES IN pt_statuslist
    WHERE mediaissue   = pt_statuslist-matnr
    AND   deliv_date BETWEEN pv_date_from AND pv_date_to.
  SORT pt_jvtphdate.
*
ENDFORM. " read_JVTPHDATE#

*&---------------------------------------------------------------------*
*&      Form  merge_jvtphdate
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LT_JVTPHDATE   text
*      -->PT_STATUSLIST  text
*----------------------------------------------------------------------*
FORM merge_jvtphdate                                        "TK01022008
     USING pt_jvtphdate TYPE jvtphdate_tab
     CHANGING pt_statuslist TYPE status_tab_type.
*
  DATA: ls_jvtphdate TYPE jvtphdate_stru.
  DATA: ls_statuslist TYPE status_type.
  DATA: ls_mara TYPE mara.
  DATA: lt_statuslist TYPE status_tab_type.
*
* Ausgaben und Phasen sortiert in neue Hilfstabelle aufnehmen
  LOOP AT pt_statuslist INTO ls_statuslist.
    APPEND ls_statuslist TO lt_statuslist.
    LOOP AT pt_jvtphdate INTO ls_jvtphdate
      WHERE mediaissue = ls_statuslist-matnr.
      SELECT SINGLE * FROM mara INTO ls_mara
        WHERE matnr = ls_jvtphdate-mediaissue.
      IF sy-subrc = 0.
        CLEAR ls_statuslist.
        MOVE-CORRESPONDING ls_mara TO ls_statuslist.
*      ls_statuslist-SEQUENCE_LFDNR
        ls_statuslist-matnr                = ls_jvtphdate-mediaissue.
        ls_statuslist-ph_phasemdl          = ls_jvtphdate-phasemdl.
        ls_statuslist-ph_phasenbr          = ls_jvtphdate-phasenbr.
        ls_statuslist-ph_deliv_date        = ls_jvtphdate-deliv_date.
*      ls_statuslist-MEDPROD_MAKTX
*      ls_statuslist-MEDISSUE_MAKTX
*      ls_statuslist-XFIRST_ISSUE_LINE
*      ls_statuslist-XISSUE_IS_DUPLICATE
*      ls_statuslist-TEXT_ICON
*      ls_statuslist-XARCHIVE
*
        APPEND ls_statuslist TO lt_statuslist.
      ENDIF.
    ENDLOOP.
  ENDLOOP.
*
* Hilfstabelle in Schnittstelle zurückgeben
  CLEAR pt_statuslist. REFRESH pt_statuslist.
  pt_statuslist[] = lt_statuslist[].
*
ENDFORM. " merge_jvtphdate

* Ende-----------------------------------------------------"TK01022008

FORM authority_check_marc_mvke                              "TK13062008
                  USING    gv_display                       "TK13062008
                  CHANGING lt_marc TYPE jksdmarcstattab     "TK13062008
                           lt_mvke TYPE jksdmvkestattab.    "TK13062008
*
  DATA: h_aktyp LIKE t130m-aktyp.
  DATA: ls_marc TYPE jksdmarcstat.
  DATA: ls_mvke TYPE jksdmvkestat.
*
  xauthority_ok = con_angekreuzt.
*
  IF gv_display IS INITIAL.                         "Status change
    h_aktyp = con_actype_change.
  ELSE.                                             "Status Display
    h_aktyp = con_actype_display.
  ENDIF.
*
* Check MARC-Authority
  LOOP AT lt_marc INTO ls_marc.
    CALL FUNCTION 'WERKS_AUTHORITY_CHECK'
      EXPORTING
        aktyp        = h_aktyp
        werks        = ls_marc-werks
*       KZ_REF       = ' '
      EXCEPTIONS
        no_authority = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
      DELETE lt_marc.
    ENDIF.
  ENDLOOP.
*
* Check MVKE-Authority
  LOOP AT lt_mvke INTO ls_mvke.
    CALL FUNCTION 'VKORG_VTWEG_AUTHORITY_CHECK'
      EXPORTING
        aktyp        = h_aktyp
        vkorg        = ls_mvke-vkorg
        vtweg        = ls_mvke-vtweg
*       KZ_REF       = ' '
      EXCEPTIONS
        no_authority = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
      DELETE lt_mvke.
    ENDIF.
  ENDLOOP.
*
ENDFORM. " authority_check_marc_mvke                      "TK13062008
*&---------------------------------------------------------------------*
*&      Form  CALLED_WITH_SET_GET_PARAMETER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM called_with_set_get_parameter .

  DATA: lv_search TYPE xfeld.
  DATA: BEGIN OF lv_wl_call_jksd13,
          issue LIKE mara-matnr,
          plant LIKE marc-werks,
          vkorg LIKE mvke-vkorg,
          vtweg LIKE mvke-vtweg.
  DATA: END OF lv_wl_call_jksd13.

  IMPORT lv_wl_call_jksd13  FROM MEMORY ID 'JKSD13_EXT'.
  IF sy-subrc = 0.

    DELETE FROM MEMORY ID 'JKSD13_EXT'.

*   1.) Parameter und Select options füllen:
*   Status-Selektionen werden beim CALL NICHT(!) übergeben!

*   GR_ISSUE:
    IF lv_wl_call_jksd13-issue IS NOT INITIAL.
      gr_issue-low = lv_wl_call_jksd13-issue.
      gr_issue-sign = 'I'.
      gr_issue-option = 'EQ'.
      APPEND gr_issue TO gr_issue[].
    ENDIF.

*   GV_WERK:
    IF lv_wl_call_jksd13-plant IS NOT INITIAL.
      gv_werk = lv_wl_call_jksd13-plant.
    ENDIF.

*   GV_VKORG:
    IF lv_wl_call_jksd13-vkorg IS NOT INITIAL.
      gv_vkorg = lv_wl_call_jksd13-vkorg.
    ENDIF.

*   GV_VTWEG:
    IF lv_wl_call_jksd13-vtweg IS NOT INITIAL.
      gv_vtweg = lv_wl_call_jksd13-vtweg.
    ENDIF.

*   2.) Changefields füllen:
    SELECT SINGLE ismpubldate
    INTO rjksdworklist_changefields-date_from
        FROM mara
         WHERE matnr = lv_wl_call_jksd13-issue.

    rjksdworklist_changefields-date_to = rjksdworklist_changefields-date_from.
    rjksdworklist_changefields-xpubldate = 'X'.

*   3) Selektion durchführen:
    convert_to gt_params.
    PERFORM selection_check   CHANGING gt_params
                                       gt_dbtab
                                       gt_mara_db           "TK01042008
                                       gt_marc_db           "TK01042008
                                       gt_mvke_db           "TK01042008
                                       gt_statuslist_tab
                                       rjksdworklist_changefields
                                       gv_recommend_save
                                       ok_code_101.
    convert_from gt_params.

*   4.) Navigation auf Ergebnisbild:
*   LEAVE TO SCREEN sy-dynnr.  => inaktiviert!!! in Resizing-Version,
*                              da SET SCREEN im Subscreen nicht erlaubt!!!


*-----Anfang------------------------------------------"TK17092009/hint1386691
  ELSE.
*
*   Vorbelegung der Selektion über Fuba oder BADI prüfen
*
*   Ist diese der Fall, wird die Selektion sofort ausgeführt;
*   alle Selektionsscreens werden ausgeblendet,
*   es wird dann sofort die Trefferliste dargestellt.)

*
    IF sy-ucomm IS INITIAL AND          "nur beim Start der Transaktion
      gv_selection_set_done IS INITIAL. "sonst werden beim Resizing direkt nach
*                                       "Transaktionsstart (SY-UCOMM ist noch initial)
*                                       "die Daten nochmal gelesen
*
*     Fall 2
*     ======
*     - Fuba, der die zuvor mit Fuba ISM_WORKLIST_CALL ins
*     memory gestellten Selektionseingaben wieder einliest.
*     (Für Aufruf der Worklist aus einem beliebigen Kontext, es können alle
*     Selektionsvariablen vorbelegt werden)
*     - SY_CALLD sitzt hier => Selektionsscreens sind daher schon ausgeblendet
      PERFORM selection_get_from_fuba CHANGING gv_selection_set_done.
      CHECK gv_selection_set_done IS INITIAL.
*
*     Fall 3
*     ======
*     - BADI-Implementierung, mit der die Selektion vorbelegt werden kann
*     (Für Aufruf der Worklist direkt aus dem Menü heraus;
*     Es kann hiermit z.B. je Transaktionsaktionsvariante und user und ...
*     die Selektion vorbelegt werden.
*     - SY-CALLD sitzt in diesem Fall nicht! => Selektionsscreens
*     werden über gv_selection_set_active (aus Methode SELECTION_CHECK_ACTIVE)
*     ausgeblendet.
      IF gv_selection_set_active = 'X'.  "BADI ist implementiert UND aktiviert
*       Aufruf Badi für Vorbelegung Selektion
        PERFORM selection_get_from_badi CHANGING gv_selection_set_done.
      ENDIF.
    ENDIF.
*-----Ende--------------------------------------------"TK17092009/hint1386691

  ENDIF.

ENDFORM.                    "CALLED_WITH_SET_GET_PARAMETER

*-------Anfang Issue-Filterung---------------------------------"TK01402009
FORM issue_filterung USING lv_filt                          "TK01042009
                  CHANGING   pt_statuslist TYPE status_tab_type "TK01042009
                             lt_marc TYPE jksdmarcstattab   "TK01042009
                             lt_mvke TYPE jksdmvkestattab . "TK01042009
*
  DATA: oref TYPE REF TO cx_root.
  DATA: lv_msg(80) TYPE c,
        lv_text    TYPE string.
  DATA: ls_tjksd13filter TYPE tjksd13filter.
  DATA: in_issue_tab TYPE ism_matnr_tab.
  DATA: out_issue_tab TYPE ism_matnr_tab.
  DATA: ls_statuslist LIKE LINE OF pt_statuslist.
  DATA: ls_marc TYPE jksdmarcstat.
  DATA: ls_mvke TYPE jksdmvkestat.
  DATA: del_issue_tab TYPE ism_matnr_range_tab.
  DATA: del_issue_stru TYPE ism_matnr_range.

*
  CHECK NOT pt_statuslist[] IS INITIAL.
*
  LOOP AT pt_statuslist INTO ls_statuslist.
    APPEND ls_statuslist-matnr TO in_issue_tab.
  ENDLOOP.

* break-point.

* call method to do filter-selection
  IF lv_filt IS NOT INITIAL.
    SELECT SINGLE * FROM tjksd13filter INTO ls_tjksd13filter
      WHERE filter_id = lv_filt.
    IF sy-subrc = 0.
      TRY.
          CALL METHOD (ls_tjksd13filter-class_name)=>if_ism_worklist_sel_filter~worklist_filter_selection
            EXPORTING
              i_filter_id = ls_tjksd13filter-filter_id
              i_issue_tab = in_issue_tab
            IMPORTING
              e_issue_tab = out_issue_tab.
        CATCH cx_root INTO oref.
          lv_text = oref->get_text( ).
          MESSAGE e011(jksdfc) WITH ls_tjksd13filter-class_name
                                    INTO lv_msg.
*        me->add_msg_to_log( i_log_handle = log
*                            i_probclass  = lcl_def=>con_probclass_very_high ).
      ENDTRY.
    ENDIF.
  ENDIF.
*
  CHECK in_issue_tab[] <> out_issue_tab[].
*

*------------------------------------------------------------------------------
* 1.) Vom Filter gelöscht Materialen werden gelöscht
*------------------------------------------------------------------------------
* Sortierung der out_issue_tab muß jetzt (wegen Produkt-kits) erhalten bleiben
  DATA: h_out_issue_tab TYPE ism_matnr_tab.
  h_out_issue_tab[] = out_issue_tab[].

  CLEAR del_issue_stru.
  del_issue_stru-sign = 'I'.
  del_issue_stru-option = 'EQ'.
*
  SORT h_out_issue_tab.
  LOOP AT pt_statuslist INTO ls_statuslist.
    READ TABLE h_out_issue_tab WITH KEY ls_statuslist-matnr BINARY SEARCH
      TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
*     issue deleted by filter => delete issue
      MOVE ls_statuslist-matnr TO del_issue_stru-low.
      APPEND del_issue_stru TO del_issue_tab.
      DELETE pt_statuslist.
    ENDIF. " sy-subrc <> 0.  endloop. " at pt_Statuslist into ls_Statuslist.
  ENDLOOP. " at pt_Statuslist into ls_Statuslist.
*
* delete corresponding MARC/MVKE
  IF NOT del_issue_tab[] IS INITIAL.
    LOOP AT lt_marc INTO ls_marc
      WHERE matnr IN del_issue_tab.
      DELETE lt_marc.
    ENDLOOP.
    LOOP AT lt_mvke INTO ls_mvke
      WHERE matnr IN del_issue_tab.
      DELETE lt_mvke.
    ENDLOOP.
  ENDIF. " not del_issue_tab[] is initial.
*
**------------------------------------------------------------------------------
** 2.) Vom Filter ergänzte Materialen werden ergänzt
**------------------------------------------------------------------------------
** Ausgabetabelle füllen
*  data: lv_matnr type matnr.
*  data: lv_last_matnr type matnr.
*  data: ls_marc_db type marc.
*  data: pt_statuslist_Save type status_tab_type.
*  data: ls_makt type makt.
*  data: ls_issue like line of in_issue_tab.
**
*  pt_statuslist_Save[] = pt_statuslist[].
*  clear pt_statuslist. refresh pt_statuslist.
*
*  sort pt_statuslist_save.
*  loop at out_issue_tab into lv_matnr.
*    loop at pt_statuslist_save into ls_statuslist
*      where matnr = lv_matnr.
*      exit.
*    endloop.
*    if sy-subrc = 0.
**     Material war bereits selektiert
*      append ls_statuslist to pt_statuslist.
**     Ausgabe wurde schon ohne Filter selektiert
**     => wird als "übergeordnete" Ausgabe gewertet, d.h. diese Ausgabe
**        bestimmt die MARC/MVKE-Übernahme der untergeordneten Ausgaben
**
**     völlig offen:
**     - welche Segmente werden ohne die Kit-Hierarchie von den
**     neuen Ausgaben übernommen ????? Ein NACH-Selektieren geht NICHT(!)
**     - Müssen die Segmente auch in den Filter aufgenommen werden !!??
**     - Die Treffermenge ist nicht mehr transparent!!
**     - Wie wird damit umgegangen, wenn ein Bestandteil in mehreren Kits
**       enthalten ist
**     - Was, wenn Bestandteile schon in der Treffermenge der Selektion
**       vorhanden sind, speziell, wenn Bestandteile ohne(!) Träger
**       selektiert wurden
**
*      lv_last_matnr = lv_matnr.
*    else.
**     Material wurde im Filter ergänzt.
**     Diese Ausgabe steuert keine Segmentübernahme von MARC und MVKE,
**     lv_last_marc wird nicht mit dieser Ausgabe gefüllt
*      perform enhance_new_issue using lv_matnr
*                                      lv_last_matnr
*                             changing pt_statuslist
*                                      lt_marc
*                                      lt_mvke.
*
*    endif.
*  endloop.
*

ENDFORM. " issue_filterung                                  "TK01042009
*-------Ende---Issue-Filterung---------------------------------"TK01402009
FORM save_okcode.                              "TK16072009/hint1365757
  gv_save_okcode = sy-ucomm.                   "TK16072009/hint1365757
ENDFORM. " save_okcode.                        "TK16072009/hint1365757



FORM pai_310_input.                                         "Hinw. 1366505
  IF rjksdworklist_changefields-date_from >
     rjksdworklist_changefields-date_to.
    MESSAGE e068.
  ENDIF.

ENDFORM. " pai_310_input.                                   "Hinw. 1366505

* ----Anfang-------neue Selektion---------------------------------"TK28072009 hint1369718
FORM marc_select_ismdate USING range_matnr_prod TYPE rjp_matnr_range_tab
                                 ls_and_from ls_and_to
                            CHANGING lt_marc TYPE jksdmarcstattab.
*

  TYPES: BEGIN OF lt_seg_type,
           matnr TYPE matnr,
           werks TYPE werks_d.
*            ISMPURCHASEDATE type sy-datum.
  TYPES:    END OF lt_seg_type.

  DATA: lt_seg_tab TYPE TABLE OF lt_seg_type,
        lt_seg     TYPE lt_seg_type.

  CLEAR lt_seg_tab. REFRESH lt_seg_tab.

  IF gv_werk IS INITIAL.
*   Werk wurde nicht selektiert
    SELECT marc~matnr marc~werks "marc~ISMPURCHASEDATE
      INTO TABLE lt_seg_tab
      FROM marc AS marc
         INNER JOIN mara AS mara
           ON marc~matnr = mara~matnr
         WHERE   marc~mmsta IN gr_mmsta                  AND
         (ls_and_from)                                   AND  "and DATUM >= FROMDATE
         (ls_and_to)                                     AND  "and DATUM <= TODATE
          mara~ismhierarchlevl EQ '3'                    AND
          mara~ismrefmdprod IN range_matnr_prod     .

  ELSE. " gv_werk is initial.
*   Werk wurde selektiert
    SELECT marc~matnr marc~werks "marc~ISMPURCHASEDATE
      INTO TABLE lt_seg_tab
      FROM marc AS marc
         INNER JOIN mara AS mara
           ON marc~matnr = mara~matnr
         WHERE   marc~mmsta IN gr_mmsta                  AND
                 marc~werks = gv_werk                    AND "<== werk
         (ls_and_from)                                   AND "and DATUM >= FROMDATE
         (ls_and_to)                                     AND "and DATUM <= TODATE
          mara~ismhierarchlevl EQ '3'                   AND
          mara~ismrefmdprod IN range_matnr_prod         .

  ENDIF. " gv_werk is initial.

  IF NOT lt_seg_tab[] IS INITIAL.
    SELECT * FROM marc INTO CORRESPONDING FIELDS OF TABLE lt_marc
      FOR ALL ENTRIES IN lt_seg_tab
        WHERE matnr = lt_seg_tab-matnr
        AND   werks = lt_seg_tab-werks .
  ENDIF. " not lt_seg_tab[] is initial.
*
ENDFORM. " marc_Select_ISMDATE


* ----Ende---------neue Selektion---------------------------------"TK28072009 hint1369718


* -------Ende--------------------------------------"TK11082009/hint1374274
FORM no_selection_in_call_mode.
  gv_main_screen = con_screen_0103.

  gv_selection_toggle_text = text-102.             "TK17092009/hint1386691
  gv_selection_hidden = 'X'.                       "TK17092009/hint1386691

ENDFORM.                    "no_selection_in_call_mode
* -------Ende--------------------------------------"TK11082009/hint1374274


*-----Anfang---------------------------------------"TK17092009/hint1386691
FORM selection_get_from_badi CHANGING gv_selection_set_done.
*
  CALL BADI worklist_call->selection_set
    EXPORTING
      in_tcode           = sy-tcode   "Transaktionsvarianten
    IMPORTING
      out_from_date      = gv_from_date
      out_to_date        = gv_to_date
      out_read_sequence  = gv_read_sequence
      out_selection_date = gv_selection_date
      out_pt_params      = gt_params.

  IF " gt_params[]         is initial  or  "kann initial sein
     gv_from_date        IS INITIAL  OR
     gv_to_date          IS INITIAL  OR
     gv_selection_date   IS INITIAL.
*   Selektionsvorbelegung unvollständig => Abbruch
    MESSAGE e103.
  ENDIF.

* 2.) Changefields füllen:
  rjksdworklist_changefields-date_from = gv_from_date.
  rjksdworklist_changefields-date_to   = gv_to_date.
  rjksdworklist_changefields-xsequence = gv_read_sequence.
  MOVE-CORRESPONDING gv_selection_date TO rjksdworklist_changefields.
*
* 3) Selektion durchführen:
  PERFORM selection_check   CHANGING gt_params
                                     gt_dbtab
                                     gt_mara_db             "TK01042008
                                     gt_marc_db             "TK01042008
                                     gt_mvke_db             "TK01042008
                                     gt_statuslist_tab
                                     rjksdworklist_changefields
                                     gv_recommend_save
                                     ok_code_101.
  convert_from gt_params.
*
  gv_selection_set_done = 'X'.
*
ENDFORM. " selection_get_from_badi.

FORM selection_get_from_fuba CHANGING gv_selection_set_done.
*
  DATA: lv_from_date      TYPE jdate_from2,
        lv_to_date        TYPE jdate_to2,
        lv_read_sequence  TYPE jread_issue_by_sequence,
        lv_selection_date TYPE rjksdworklist_selection_date,
        lt_params         TYPE rsparams_tt.
*
  CALL FUNCTION 'ISM_WORKLIST_SELECTION_GET'
    IMPORTING
      out_from_date      = lv_from_date
      out_to_date        = lv_to_date
      out_read_sequence  = lv_read_sequence
      out_selection_date = lv_selection_date
      out_pt_params      = lt_params.
*
  IF NOT lv_from_date        IS INITIAL  AND
     NOT lv_to_date          IS INITIAL  AND
     NOT lv_selection_date   IS INITIAL .
    gv_from_date           = lv_from_date.
    gv_to_date             = lv_to_date.
    gv_read_sequence       = lv_read_sequence.
    gv_selection_date      = lv_selection_date.
    gt_params              = lt_params .
*
    gv_selection_set_done = 'X'.
*
  ENDIF.
*
  IF gv_selection_set_done = 'X'.
*   2.) Changefields füllen:
    rjksdworklist_changefields-date_from = gv_from_date.
    rjksdworklist_changefields-date_to   = gv_to_date.
    rjksdworklist_changefields-xsequence = gv_read_sequence.
    MOVE-CORRESPONDING gv_selection_date TO rjksdworklist_changefields.
*
*   3) Selektion durchführen:
    PERFORM selection_check   CHANGING gt_params
                                       gt_dbtab
                                       gt_mara_db           "TK01042008
                                       gt_marc_db           "TK01042008
                                       gt_mvke_db           "TK01042008
                                       gt_statuslist_tab
                                       rjksdworklist_changefields
                                       gv_recommend_save
                                       ok_code_101.
    convert_from gt_params.
*
  ENDIF.
*
ENDFORM. " selection_get_From_fuba.
*-----Ende-----------------------------------------"TK17092009/hint1386691

* ----Anfang-------neue Selektion------------------"TK25092009/hint1389068
FORM mvke_select_ismdate USING range_matnr_prod TYPE rjp_matnr_range_tab
                                 ls_and_from ls_and_to
                            CHANGING lt_mvke TYPE jksdmvkestattab.
*

  TYPES: BEGIN OF lt_seg_type,
           matnr TYPE matnr,
           vkorg TYPE vkorg,
           vtweg TYPE vtweg.
*            ISMPURCHASEDATE type sy-datum.
  TYPES:    END OF lt_seg_type.

  DATA: lt_seg_tab TYPE TABLE OF lt_seg_type,
        lt_seg     TYPE lt_seg_type.

  CLEAR lt_seg_tab. REFRESH lt_seg_tab.
  CLEAR lt_mvke.    REFRESH lt_mvke.

  IF gv_vkorg IS INITIAL AND
     gv_vtweg IS INITIAL.
*   VKORG/VTWEG wurden nicht selektiert
    SELECT mvke~matnr mvke~vkorg mvke~vtweg
      INTO TABLE lt_seg_tab
      FROM mvke AS mvke
         INNER JOIN mara AS mara
           ON mvke~matnr = mara~matnr
         WHERE   mvke~vmsta IN gr_vmsta                  AND
         (ls_and_from)                                   AND  "and DATUM >= FROMDATE
         (ls_and_to)                                     AND  "and DATUM <= TODATE
          mara~ismhierarchlevl EQ '3'                    AND
          mara~ismrefmdprod IN range_matnr_prod     .
  ENDIF.

  IF NOT gv_vkorg IS INITIAL AND
     NOT gv_vtweg IS INITIAL.
*   VKORG/VTWEG wurden beide selektiert
    SELECT mvke~matnr mvke~vkorg mvke~vtweg
      INTO TABLE lt_seg_tab
      FROM mvke AS mvke
         INNER JOIN mara AS mara
           ON mvke~matnr = mara~matnr
         WHERE   mvke~vmsta IN gr_vmsta                  AND
                 mvke~vkorg = gv_vkorg                   AND  "<== Vkorg
                 mvke~vtweg = gv_vtweg                   AND  "<== Vtweg
         (ls_and_from)                                   AND  "and DATUM >= FROMDATE
         (ls_and_to)                                     AND  "and DATUM <= TODATE
          mara~ismhierarchlevl EQ '3'                    AND
          mara~ismrefmdprod IN range_matnr_prod     .
  ENDIF.

  IF NOT gv_vkorg IS INITIAL AND
         gv_vtweg IS INITIAL.
*   VKORG selektiert, Vtweg initial
    SELECT mvke~matnr mvke~vkorg mvke~vtweg
      INTO TABLE lt_seg_tab
      FROM mvke AS mvke
         INNER JOIN mara AS mara
           ON mvke~matnr = mara~matnr
         WHERE   mvke~vmsta IN gr_vmsta                  AND
                 mvke~vkorg = gv_vkorg                   AND  "<== Vkorg
         (ls_and_from)                                   AND  "and DATUM >= FROMDATE
         (ls_and_to)                                     AND  "and DATUM <= TODATE
          mara~ismhierarchlevl EQ '3'                    AND
          mara~ismrefmdprod IN range_matnr_prod     .
  ENDIF.

  IF gv_vkorg IS INITIAL AND
     NOT  gv_vtweg IS INITIAL.
*   VKORG initial, Vtweg selektiert
    SELECT mvke~matnr mvke~vkorg mvke~vtweg
      INTO TABLE lt_seg_tab
      FROM mvke AS mvke
         INNER JOIN mara AS mara
           ON mvke~matnr = mara~matnr
         WHERE   mvke~vmsta IN gr_vmsta                  AND
                 mvke~vtweg = gv_vtweg                   AND  "<== Vtweg
         (ls_and_from)                                   AND  "and DATUM >= FROMDATE
         (ls_and_to)                                     AND  "and DATUM <= TODATE
          mara~ismhierarchlevl EQ '3'                    AND
          mara~ismrefmdprod IN range_matnr_prod     .
  ENDIF.

  IF NOT lt_seg_tab[] IS INITIAL.
    SELECT * FROM mvke INTO CORRESPONDING FIELDS OF TABLE lt_mvke
      FOR ALL ENTRIES IN lt_seg_tab
        WHERE matnr = lt_seg_tab-matnr
        AND   vkorg = lt_seg_tab-vkorg
        AND   vtweg = lt_seg_tab-vtweg.
  ENDIF. " not lt_seg_tab[] is initial.
*
ENDFORM. " mvke_Select_ISMDATE
* ----Ende---------neue Selektion------------------"TK25092009/hint1389068

*-------Anfang Issue-Filterung------------------------------------"TK01402009
FORM enhance_new_issue USING   pv_matnr                     "TK01042009
                               pv_last_matnr                "TK01042009
                    CHANGING   pt_statuslist TYPE status_tab_type "TK01042009
                               pt_marc TYPE jksdmarcstattab "TK01042009
                               pt_mvke TYPE jksdmvkestattab . "TK01042009
*
  DATA: ls_statuslist TYPE jksdmaterialstatus.
  DATA: ls_marc_db TYPE marc.
  DATA: ls_marc TYPE jksdmarcstat.
  DATA: ls_marc_new TYPE jksdmarcstat.
  DATA: ls_makt_db TYPE makt.
*
* todo:
* - SEQUENCE_LFDNR aus Ausgabenfolge, wenn über Folge gelesen wird ?
* - Stock-Framework (gehört zu MARC)
* - alle Kundenappendfelder (oder kommen die später noch??)
* - MARC_/MVKE_ Felder
* - segmente des 'übergeordneten Materials' werden ergänzt
*   (OHNE(!!) eventuell zuvor relevante Selektionseingaben zu berücksichtigen)

*  Frage:
*  - welche Segmente werden denn ergänzt, wenn neue Ausgabgen OHNE(!)
*    Kit-Struktur im Filter hinzugefügt wurden ???
*
*

  SELECT SINGLE * FROM mara INTO ls_mara
    WHERE matnr =  pv_matnr.
  IF sy-subrc = 0.
    MOVE-CORRESPONDING ls_mara TO ls_statuslist.
*   MAKT für Produkt und Material nachlesen
    SELECT SINGLE * FROM makt INTO ls_makt_db
      WHERE matnr = ls_mara-ismrefmdprod
      AND   spras = sy-langu.
    IF sy-subrc = 0.
      ls_statuslist-medprod_maktx = ls_makt_db-maktx.
    ENDIF.
    SELECT SINGLE * FROM makt INTO ls_makt_db
      WHERE matnr = ls_mara-matnr
      AND   spras = sy-langu.
    IF sy-subrc = 0.
      ls_statuslist-medissue_maktx = ls_makt_db-maktx.
    ENDIF.
*   MARC ergänzen (alle Segmente, die bei lv_last_matnr auch selektiert wurden!)
    LOOP AT pt_marc INTO ls_marc
      WHERE matnr = pv_last_matnr.
      SELECT SINGLE * FROM marc INTO ls_marc_db
        WHERE matnr = pv_matnr
        AND   werks = ls_marc-werks.
      IF sy-subrc = 0.
*       MARC wird ergänzt (und zwar a
        MOVE-CORRESPONDING ls_marc_db TO ls_marc_new.
        APPEND ls_marc_new TO pt_marc.
      ENDIF.
    ENDLOOP.
    APPEND ls_statuslist TO pt_statuslist.
  ENDIF.
*
ENDFORM. " enhance_new_issue                                      "TK01042009
*-------Ende   Issue-Filterung------------------------------------"TK01402009
