*----------------------------------------------------------------------*
***INCLUDE RJKSDPROTOCOLF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  status_0100
*&---------------------------------------------------------------------*
*      Status auf dem Screen 0100 setzen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM status_0100 .
  DATA: fcode     TYPE t_fcode,
        fcode_tab TYPE t_fcode_tab.

  IF protocol_overview IS INITIAL.
    PERFORM status_no_overview CHANGING fcode_tab[].
    PERFORM status_no_detail   CHANGING fcode_tab[].
  ELSE.
    CASE dynnr_workarea.
      WHEN con_screen_overview.
        PERFORM status_no_overview CHANGING fcode_tab[].
        IF detail_tab[] IS INITIAL.
          fcode-fcode = con_fcode_show_detail.
          APPEND fcode TO fcode_tab.
        ENDIF.
        fcode-fcode = con_fcode_hide_detail.
        APPEND fcode TO fcode_tab.
      WHEN con_screen_detail.
        PERFORM status_no_detail CHANGING fcode_tab[].
        IF overview_tab[] IS INITIAL.
          fcode-fcode = con_fcode_show_overview.
          APPEND fcode TO fcode_tab.
        ENDIF.
        fcode-fcode = con_fcode_hide_overview.
        APPEND fcode TO fcode_tab.
      WHEN con_screen_overview_detail.
        IF overview_tab[] IS INITIAL.
          fcode-fcode = con_fcode_hide_overview.
          APPEND fcode TO fcode_tab.
        ENDIF.
        IF detail_tab[] IS INITIAL.
          fcode-fcode = con_fcode_hide_detail.
          APPEND fcode TO fcode_tab.
        ENDIF.
        fcode-fcode = con_fcode_show_overview.
        APPEND fcode TO fcode_tab.
        fcode-fcode = con_fcode_show_detail.
        APPEND fcode TO fcode_tab.
    ENDCASE.
  ENDIF.
  SET PF-STATUS 'MAIN' EXCLUDING fcode_tab.
  SET TITLEBAR  'MAIN'.
ENDFORM.                    " status_0100

*&---------------------------------------------------------------------*
*&      Form  select_data
*&---------------------------------------------------------------------*
*       Selektion von Protokollen gemäss den Eingaben
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM select_data.
  DATA not_locked_tab TYPE rjksdprotocollocked_tab.

* 1. Selektion der Daten
  PERFORM do_selection_on_db TABLES   head_tab[]
                                      state_tab[]
                             CHANGING item_tab
                                      not_locked_tab.

* 2. Aufbereiten der Kopfdaten zur Dynprodarstellung
  PERFORM fill_overview_tab TABLES head_tab[]
                                   state_tab[]
                            USING  not_locked_tab.
ENDFORM.                    " select_data

*&---------------------------------------------------------------------*
*&      Form  get_logids_to_item
*&---------------------------------------------------------------------*
*       LOGIDs zu Positionsdaten bestimmen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_logids_to_item USING    item_tab TYPE t_jksdprotocol_tab
                        CHANGING id_tab   TYPE t_jksdprotocol_tab.

* Ergebnis aufbauen
  id_tab[] = item_tab[].
  SORT id_tab BY logid.
  DELETE ADJACENT DUPLICATES FROM id_tab COMPARING logid.
ENDFORM.                    " get_logids_to_item

*&---------------------------------------------------------------------*
*&      Form  show_detail_on_screen
*&---------------------------------------------------------------------*
*       Detaildaten am Bildschirm anzeigen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM show_detail_on_screen USING overview  TYPE t_overview
                                 drilldown TYPE lvc_s_col-fieldname.

  IF protocol_detail IS INITIAL.
    PERFORM init_0200 USING overview
                            drilldown.
  ELSE.
*   Detaildaten aufbauen
    PERFORM get_detail_data USING    overview
                                     drilldown
                                     ' '
                            CHANGING detail_tab[].

*   Sortieren der selektierten Daten
    SORT detail_tab BY contract item issue counter.
*   und anzeigen der Detaildaten
    PERFORM refresh_detail_on_screen.
  ENDIF.
  IF sy-batch = abap_false.

    IF NOT detail_tab[] IS INITIAL.
      IF protocol_overview IS INITIAL.
        dynnr_workarea = con_screen_detail.
      ELSE.
        dynnr_workarea = con_screen_overview_detail.
      ENDIF.
      CALL SCREEN 100.
      IF NOT logsp IS INITIAL.
        LEAVE TO SCREEN 0.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                    " show_detail_on_screen

*&---------------------------------------------------------------------*
*&      Form  init_0100
*&---------------------------------------------------------------------*
*       Initialisierungen auf dem Screen 0100
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM init_0100.
  DATA: variant      TYPE disvariant,
        layout       TYPE lvc_s_layo,
        fieldcat_tab TYPE lvc_t_fcat.

  CHECK protocol_overview IS INITIAL.
* Referenz zum Dynpro herstellen
  CREATE OBJECT container
    EXPORTING
      container_name              = 'PROTOCOL_OVERVIEW'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.
  CHECK sy-subrc = 0.

* Protocol anlegen
  CREATE OBJECT protocol_overview
    EXPORTING
      i_parent      = container
      i_appl_events = 'X'.

  CONCATENATE sy-cprog '/1' INTO  variant-report.
* Layout für Bearbeitungsmaske NIPs aufbauen
  PERFORM get_layout CHANGING layout.
  layout-grid_title = text-300.

* Feldkatalog einlesen
  PERFORM build_fieldcatalog_overview CHANGING fieldcat_tab.

* Eventhandler setzen
  PERFORM set_event_handler_overview.

* Tabelle mit Protokollen am Screen zeigen
  CALL METHOD protocol_overview->set_table_for_first_display
    EXPORTING
      is_layout       = layout
      i_save          = 'A'
      is_variant      = variant
    CHANGING
      it_outtab       = overview_tab
      it_fieldcatalog = fieldcat_tab.

  CALL METHOD protocol_overview->set_ready_for_input
    EXPORTING
      i_ready_for_input = 1.
ENDFORM.                                                    " init_0100

*&---------------------------------------------------------------------*
*&      Form  init_0200
*&---------------------------------------------------------------------*
*       Initialisierungen auf dem Screen 0200
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM init_0200 USING overview  TYPE t_overview
                     drilldown TYPE lvc_s_col-fieldname.
  DATA: variant         TYPE disvariant,
        layout          TYPE lvc_s_layo,
        fieldcat_tab    TYPE lvc_t_fcat,
        dropdown_handle TYPE lvc_s_drop-handle.

  IF sy-batch EQ abap_false.

    CHECK protocol_detail IS INITIAL.
* Referenz zum Dynpro herstellen
    CREATE OBJECT container
      EXPORTING
        container_name              = 'PROTOCOL_DETAIL'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    CHECK sy-subrc = 0.

* Protocol anlegen
    CREATE OBJECT protocol_detail
      EXPORTING
        i_parent = container.
    CONCATENATE sy-cprog '/2' INTO  variant-report.

* Layout für Bearbeitungsmaske NIPs aufbauen
    PERFORM get_layout CHANGING layout.
    layout-info_fname = 'COLOR'.
    layout-grid_title = text-301.

* Feldkatalog einlesen
    PERFORM build_fieldcatalog CHANGING fieldcat_tab.

* Eventhandler setzen
    PERFORM set_event_handler.

* Dropdownbox aufbauen
    PERFORM create_dropdownbox_layer CHANGING dropdown_handle.
  ENDIF.

* Detaildaten aufbauen
  PERFORM get_detail_data USING    overview
                                   drilldown
                                   ' '
                          CHANGING detail_tab[].

* Sortieren der selektierten Daten
 " SORT detail_tab BY contract item issue counter.

  IF sy-batch EQ abap_false.
* Tabelle mit Protokollen am Screen zeigen
    CALL METHOD protocol_detail->set_table_for_first_display
      EXPORTING
        is_layout       = layout
        i_save          = 'A'
        is_variant      = variant
      CHANGING
        it_outtab       = detail_tab
        it_fieldcatalog = fieldcat_tab.
  ENDIF.
ENDFORM.                                                    " init_0200

*&---------------------------------------------------------------------*
*&      Form  set_event_handler
*&---------------------------------------------------------------------*
*       Eventhandler setzen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM set_event_handler .
  DATA event_handler TYPE REF TO lcl_handler_detail.

  CREATE OBJECT event_handler.
  SET HANDLER event_handler->handle_toolbar FOR protocol_detail.
  SET HANDLER event_handler->user_command   FOR protocol_detail.
ENDFORM.                    " set_event_handler

*&---------------------------------------------------------------------*
*&      Form  set_event_handler_overview
*&---------------------------------------------------------------------*
*       Eventhandler für Überblick setzen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM set_event_handler_overview.
  DATA event_handler TYPE REF TO lcl_handler_overview.

  CREATE OBJECT event_handler.
  SET HANDLER event_handler->handle_toolbar FOR protocol_overview.
  SET HANDLER event_handler->double_click   FOR protocol_overview.
  SET HANDLER event_handler->hotspot_click  FOR protocol_overview.
  SET HANDLER event_handler->user_command   FOR protocol_overview.
ENDFORM.                    " set_event_handler_overview

*&---------------------------------------------------------------------*
*&      Form  get_layout
*&---------------------------------------------------------------------*
*       Layout für Bearbeitungsmaske aufbauen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_layout CHANGING layout TYPE lvc_s_layo.
  layout-stylefname = 'CELL_TAB'.
  layout-no_rowmark = space.
ENDFORM.                    " get_layout

*&---------------------------------------------------------------------*
*&      Form  build_fieldcatalog
*&---------------------------------------------------------------------*
*       Feldkatalog aufbauen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM build_fieldcatalog CHANGING fieldcatalog TYPE lvc_t_fcat.
  FIELD-SYMBOLS <fieldcat> TYPE lvc_s_fcat.
  DATA          fieldcat   TYPE lvc_s_fcat.

* Feldkatalog aufbauen
  PERFORM fieldcatalog_merge USING    'RJKSDSHOWPROTOCOL'
                             CHANGING fieldcatalog.

  LOOP AT fieldcatalog ASSIGNING <fieldcat>.
    CASE <fieldcat>-fieldname.
      WHEN 'MSGTY' OR
           'MSGID' OR
           'MSGNO' OR
           'MSGV1' OR
           'MSGV2' OR
           'MSGV3' OR
           'MSGV4'.
        <fieldcat>-no_out = 'X'.
      WHEN 'ANNOTATION'.
        <fieldcat>-edit = 'X'.
      WHEN 'SOLVED'.
        <fieldcat>-checkbox = 'X'.
        <fieldcat>-edit     = 'X'.
        <fieldcat>-col_opt  = 'X'.
      WHEN 'LAYER'.
        <fieldcat>-tech   = 'X'.
      WHEN 'LAYERT'.
*       Die Herkunft der Meldung wird als Dropdowneingabebox dargestellt
        <fieldcat>-outputlen  = '40'.
        <fieldcat>-col_opt    = ' '.
        <fieldcat>-f4availabl = 'X'.
        <fieldcat>-drdn_field = 'DROPDOWN_LAYER'.
    ENDCASE.
  ENDLOOP.

* Ikone aufnehmen
  fieldcat-fieldname = 'ICON'.
  fieldcat-icon      = 'X'.
  fieldcat-coltext   = text-110.
  fieldcat-datatype  = 'CHAR'.
  fieldcat-outputlen = 4.
  fieldcat-rollname  = 'JMSGTYPPROTOCOL'.
  APPEND fieldcat TO fieldcatalog.

* Begin of change by lahiru on 06/02/2020 for ERPM-17101 with ED2K918328 *
  INCLUDE zqtcn_build_field_cat_r112 IF FOUND.
* End of change by lahiru on 06/02/2020 for ERPM-17101 with ED2K918328 *

ENDFORM.                    " build_fieldcatalog

*&---------------------------------------------------------------------*
*&      Form  build_fieldcatalog
*&---------------------------------------------------------------------*
*       Feldkatalog für Überblick Genererierungslauf aufbauen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM build_fieldcatalog_overview CHANGING fieldcatalog TYPE lvc_t_fcat.
  FIELD-SYMBOLS <fieldcat>    TYPE lvc_s_fcat.
  DATA          configuration TYPE tjksdprotocol.

* Feldkatalog aufbauen
  PERFORM fieldcatalog_merge USING    'RJKSDSHOWPROTOCOLOVERVIEW'
                             CHANGING fieldcatalog.

* Konfiguration des Protokolls einlesen
  PERFORM get_tjksdprotocol CHANGING configuration.

  IF cl_ism_sd_pdex_switch=>get_pdex_active( ) IS INITIAL.
    LOOP AT fieldcatalog ASSIGNING <fieldcat>.
      CASE <fieldcat>-fieldname.
        WHEN 'AREATEXT'.
          <fieldcat>-hotspot   = 'X'.
          <fieldcat>-emphasize = 'X'.
        WHEN 'READONLY'.
          <fieldcat>-checkbox = 'X'.
          <fieldcat>-col_opt  = 'X'.
        WHEN 'TESTRUN'.
          <fieldcat>-checkbox = 'X'.
          <fieldcat>-col_opt  = 'X'.
        WHEN 'LOGID' OR
             'AREA'  OR
             'TEXT'     OR
             'AREAPDEX' OR
             'PDEX'.
          <fieldcat>-tech = 'X'.
        WHEN 'COUNT1'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count1
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT2'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count2
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT3'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count3
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT4'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count4
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT5'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count5
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT6'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count6
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT7'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count7
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT8'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count8
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT9'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count9
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT10'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count10
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT11'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count11
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT12'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count12
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT13'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count13
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT14'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count14
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT15'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count15
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT16'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count16
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT17'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count17
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT18'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count18
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT19'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count19
                                                 CHANGING <fieldcat>.
        WHEN 'COUNT20'.
          PERFORM adapt_fieldcat_count_4_display USING    configuration-count20
                                                 CHANGING <fieldcat>.
      ENDCASE.
    ENDLOOP.
  ELSE.
    LOOP AT fieldcatalog ASSIGNING <fieldcat>.
      CASE <fieldcat>-fieldname.
        WHEN 'AREATEXT'.
          <fieldcat>-hotspot   = 'X'.
          <fieldcat>-emphasize = 'X'.
        WHEN 'READONLY'.
          <fieldcat>-checkbox = 'X'.
          <fieldcat>-col_opt  = 'X'.
        WHEN 'TESTRUN'.
          <fieldcat>-checkbox = 'X'.
          <fieldcat>-col_opt  = 'X'.
        WHEN 'LOGID'    OR
             'AREA'     OR
             'TEXT'     OR
             'AREAPDEX' OR
             'PDEX'.
          <fieldcat>-tech = 'X'.
        WHEN 'COUNT1'  OR
             'COUNT2'  OR
             'COUNT3'  OR
             'COUNT4'  OR
             'COUNT5'  OR
             'COUNT6'  OR
             'COUNT7'  OR
             'COUNT8'  OR
             'COUNT9'  OR
             'COUNT10' OR
             'COUNT11' OR
             'COUNT12' OR
             'COUNT13' OR
             'COUNT14' OR
             'COUNT15' OR
             'COUNT16' OR
             'COUNT17' OR
             'COUNT18' OR
             'COUNT19' OR
             'COUNT20'.
          <fieldcat>-tech = 'X'.
      ENDCASE.
    ENDLOOP.
  ENDIF.
ENDFORM.                    " build_fieldcatalog_overview

*&---------------------------------------------------------------------*
*&      Form   refresh_detail_on_screen
*&---------------------------------------------------------------------*
*       Detailbilddaten am Bildschirm auffrischen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM  refresh_detail_on_screen.
  DATA stable TYPE lvc_s_stbl.

  CHECK NOT protocol_detail IS INITIAL.
  stable-row = 'X'.
  stable-col = 'X'.
  CALL METHOD protocol_detail->refresh_table_display
    EXPORTING
      is_stable      = stable
      i_soft_refresh = 'X'.
ENDFORM.                    " refresh_detail_on_screen

*&---------------------------------------------------------------------*
*&      Form  refresh_overview_on_screen
*&---------------------------------------------------------------------*
*       Überblicksdaten am Bildschirm auffrischen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM refresh_overview_on_screen .
  DATA stable TYPE lvc_s_stbl.

  CHECK NOT protocol_overview IS INITIAL.
  stable-row = 'X'.
  stable-col = 'X'.
  CALL METHOD protocol_overview->refresh_table_display
    EXPORTING
      is_stable      = stable
      i_soft_refresh = 'X'.
ENDFORM.                    " refresh_overview_on_screen

*&---------------------------------------------------------------------*
*&      Form  do_selection_on_db
*&---------------------------------------------------------------------*
*       Selektion der Protokolle auf der Datenbank
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM do_selection_on_db TABLES   head_tab       STRUCTURE jksdprotocolhead
                                 state_tab      STRUCTURE jksdlogorderst
                        CHANGING item_tab       TYPE      t_jksdprotocol_tab
                                 not_locked_tab TYPE      rjksdprotocollocked_tab.
  FIELD-SYMBOLS <head> TYPE jksdprotocolhead.
  DATA: id_tab   TYPE t_jksdprotocol_tab,
        area_tab TYPE rjksd_area_range_tab.
  DATA: r_msgty      TYPE RANGE OF jksdprotocol-msgty,
        r_msgty_line LIKE LINE OF r_msgty.

* Rückgabewerte initialisieren
  CLEAR: head_tab[],
         item_tab[],
         not_locked_tab[],
         state_tab[].

* Selektionskriterien ermitteln
  PERFORM get_selection_criteria CHANGING area_tab.

* zusätzliche Filtereinstellungen
  IF p_warn IS NOT INITIAL.
    r_msgty_line-sign   = 'E'.
    r_msgty_line-option = 'EQ'.
    r_msgty_line-low    = 'W'.
    APPEND r_msgty_line TO r_msgty.
  ENDIF.

  IF p_sinfo IS NOT INITIAL.
    r_msgty_line-sign   = 'E'.
    r_msgty_line-option = 'EQ'.
    r_msgty_line-low    = 'I'.
    APPEND r_msgty_line TO r_msgty.

    r_msgty_line-low    = 'S'.
    APPEND r_msgty_line TO r_msgty.
  ENDIF.

* Selektion ausführen
  IF NOT area_tab[] IS INITIAL OR
     NOT date[]     IS INITIAL OR
     NOT time[]     IS INITIAL OR
     NOT erfuser[]  IS INITIAL OR
     NOT logid      IS INITIAL.
    IF logid IS INITIAL.
      SELECT * INTO TABLE head_tab FROM jksdprotocolhead
        WHERE area           IN area_tab AND
              generationdate IN date     AND
              generationtime IN time     AND
              erfuser        IN erfuser.              "#EC CI_SGLSELECT
                                                        "#EC CI_NOFIELD
    ELSE.
      SELECT * INTO TABLE head_tab FROM jksdprotocolhead
        WHERE logid = logid.                          "#EC CI_SGLSELECT
    ENDIF.
    IF sy-subrc <> 0.
      MESSAGE s100(jksdprotocol).
      EXIT.
    ENDIF.
  ENDIF.
  IF head_tab[] IS INITIAL.
    SELECT * INTO TABLE item_tab FROM jksdprotocol
      WHERE contract IN contract AND
            item     IN item     AND
            issue    IN issue    AND
            phasemdl IN phasemdl AND
            phasenbr IN phasenbr AND
            vkorg    IN vkorg    AND
            vtweg    IN vtweg    AND
            spart    IN spart    AND
            vkbur    IN vkbur    AND
            vkgrp    IN vkgrp    AND
            msgty    IN r_msgty  AND
            ag       IN ag       AND
            we       IN we.                           "#EC CI_SGLSELECT
                                                        "#EC CI_NOFIRST
    IF sy-subrc <> 0.
      MESSAGE s100(jksdprotocol).
      EXIT.
    ENDIF.
*   und noch die Kopfdaten zu den Positionsdaten beschaffen
    PERFORM get_logids_to_item USING    item_tab
                               CHANGING id_tab.

    SELECT * INTO TABLE head_tab FROM jksdprotocolhead
      FOR ALL ENTRIES IN id_tab
      WHERE logid = id_tab-logid.
  ELSE.
    SELECT * INTO TABLE item_tab FROM jksdprotocol
      FOR ALL ENTRIES IN head_tab
      WHERE logid    = head_tab-logid AND
            contract IN contract      AND
            item     IN item          AND
            issue    IN issue         AND
            phasemdl IN phasemdl      AND
            phasenbr IN phasenbr      AND
            vkorg    IN vkorg         AND
            vtweg    IN vtweg         AND
            spart    IN spart         AND
            vkbur    IN vkbur         AND
            vkgrp    IN vkgrp         AND
            msgty    IN r_msgty       AND
            ag       IN ag            AND
            we       IN we.                           "#EC CI_SGLSELECT
    IF NOT contract[] IS INITIAL OR
       NOT item[]     IS INITIAL OR
       NOT issue[]    IS INITIAL OR
       NOT phasemdl[] IS INITIAL OR
       NOT phasenbr[] IS INITIAL OR
       NOT vkorg[]    IS INITIAL OR
       NOT vtweg[]    IS INITIAL OR
       NOT spart[]    IS INITIAL OR
       NOT vkbur[]    IS INITIAL OR
       NOT vkgrp[]    IS INITIAL OR
       NOT r_msgty[]  IS INITIAL OR
       NOT ag[]       IS INITIAL OR
       NOT we[]       IS INITIAL.
*     Abgleichen mit den Kopfdaten
      SORT item_tab BY logid.
      LOOP AT head_tab ASSIGNING <head>.
        READ TABLE item_tab
          WITH KEY logid = <head>-logid TRANSPORTING NO FIELDS BINARY SEARCH.
        CHECK sy-subrc <> 0.
        DELETE head_tab.
      ENDLOOP.
      IF head_tab[] IS INITIAL.
        MESSAGE s100(jksdprotocol).
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.

* Sortieren
  SORT item_tab BY logid.

* Lesen der Tabelle jksdlogorderst
  PERFORM get_jksdlogorderst TABLES state_tab
                                    head_tab[].
* Sperren der Protokolldaten
  PERFORM lock_protocol TABLES   head_tab[]
                        CHANGING not_locked_tab.

* Einträge in der Tabelle item_tab numerieren
  PERFORM set_number_item_tab CHANGING item_tab.

ENDFORM.                    " do_selection_on_db

*&---------------------------------------------------------------------*
*&      Form  refresh
*&---------------------------------------------------------------------*
*       Refresh durchführen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM refresh.
  DATA abort TYPE xfeld.

* Daten sichern?
  PERFORM data_to_save CHANGING abort.
  CHECK abort IS INITIAL.

* Entsperren der gesperrten Protokolle
  PERFORM unlock.

  CLEAR: head_tab[],
         item_tab[],
         state_tab[],
         overview_tab[],
         detail_tab[],
         delete_overview_tab[].
ENDFORM.                    " refresh

*&---------------------------------------------------------------------*
*&      Form  save
*&---------------------------------------------------------------------*
*       Änderungen am Protokoll auf der Datenbank sichern
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM save.
  FIELD-SYMBOLS <item>          TYPE jksdprotocol.
  DATA: delete_head_tab TYPE STANDARD TABLE OF jksdprotocolhead,
        delete_item_tab TYPE STANDARD TABLE OF jksdprotocol,
        update_item_tab TYPE STANDARD TABLE OF jksdprotocol.

* Geänderte Positionsdaten bestimmen
  PERFORM get_changed_items TABLES update_item_tab[].

* Gelöschte Kopfdaten und Positionsdaten bestimmen
  PERFORM get_deleted_head TABLES delete_head_tab[]
                                  delete_item_tab[].

* Positionsdaten die sowohl zu löschen als auch upzudaten sind, sind nur zu löschen!
  SORT delete_item_tab BY logid
                          counter
                          contract
                          item
                          issue
                          phasemdl
                          phasenbr.
  LOOP AT update_item_tab ASSIGNING <item>.
    READ TABLE delete_item_tab
      WITH KEY logid    = <item>-logid
               counter  = <item>-counter
               contract = <item>-contract
               item     = <item>-item
               issue    = <item>-issue
               phasemdl = <item>-phasemdl
               phasenbr = <item>-phasenbr BINARY SEARCH TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      DELETE update_item_tab.
    ENDIF.
  ENDLOOP.

* Löschen der Daten auf der Datenbank
  PERFORM do_saving TABLES delete_head_tab[]
                           update_item_tab[]
                           delete_item_tab[].
  CLEAR delete_overview_tab[].
  COMMIT WORK.
ENDFORM.                    " save

*&---------------------------------------------------------------------*
*&      Form  lock_protocol
*&---------------------------------------------------------------------*
*       Sperren der Protokolleinträge
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM lock_protocol TABLES   head_tab       STRUCTURE jksdprotocolhead
                   CHANGING not_locked_tab TYPE      rjksdprotocollocked_tab.
  FIELD-SYMBOLS <head>     TYPE jksdprotocolhead.
  DATA: not_locked TYPE rjksdprotocollocked,
        lin        TYPE i.

* Rückgabewerte initialisieren
  CLEAR not_locked_tab[].

  LOOP AT head_tab ASSIGNING <head>.
    CALL FUNCTION 'ENQUEUE_E_JKSDPROTOCOL'
      EXPORTING
*       MODE_JKSDPROTOCOLHEAD = 'E'
*       MANDT          = SY-MANDT
        logid          = <head>-logid
*       X_LOGID        = ' '
        _scope         = '3'
*       _WAIT          = ' '
*       _COLLECT       = ' '
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      WRITE sy-msgv1 TO not_locked-lockedby.
      not_locked-logid = <head>-logid.
      APPEND not_locked TO not_locked_tab.
    ENDIF.
  ENDLOOP.

  CHECK NOT not_locked_tab[] IS INITIAL.
  lin = lines( not_locked_tab ).
  IF lin = 1.
    READ TABLE not_locked_tab INTO not_locked INDEX 1.
    MESSAGE s150(jksdprotocol) WITH not_locked-lockedby.
  ELSE.
    MESSAGE s153(jksdprotocol) WITH lin.
  ENDIF.
ENDFORM.                    " lock_protocol

*&---------------------------------------------------------------------*
*&      Form  safety_check
*&---------------------------------------------------------------------*
*       Sicherheitsabfrage durchführen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM safety_check  CHANGING answer TYPE c.
  answer = 'N'.
  CALL FUNCTION 'POPUP_TO_CONFIRM_DATA_LOSS'
    EXPORTING
      titel  = text-001
    IMPORTING
      answer = answer.
ENDFORM.                    " safety_check

*&---------------------------------------------------------------------*
*&      Form  get_changed_items
*&---------------------------------------------------------------------*
*       Geänderte Zeilen im Protokoll bestimmen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_changed_items TABLES update_tab STRUCTURE jksdprotocol.
  FIELD-SYMBOLS <item> TYPE t_jksdprotocol.
  DATA          update TYPE jksdprotocol.

  PERFORM get_changed_data.
  LOOP AT item_tab ASSIGNING <item>
    WHERE update = 'U'.
    MOVE-CORRESPONDING <item> TO update.
    APPEND update TO update_tab.
    CLEAR <item>-update.
  ENDLOOP.
ENDFORM.                    " get_changed_items

*&---------------------------------------------------------------------*
*&      Form  get_changed_item
*&---------------------------------------------------------------------*
*       Geänderte Zeilen im Protokoll bestimmen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_changed_item TABLES update_tab STRUCTURE jksdprotocol.
  FIELD-SYMBOLS <item> TYPE t_jksdprotocol.
  DATA          update TYPE jksdprotocol.

  PERFORM get_changed_data.
  LOOP AT item_tab ASSIGNING <item>
    WHERE update = 'U'.
    MOVE-CORRESPONDING <item> TO update.
    APPEND update TO update_tab.
  ENDLOOP.
ENDFORM.                    " get_changed_item

*&---------------------------------------------------------------------*
*&      Form  cancel
*&---------------------------------------------------------------------*
*       Abbrechen der Verarbeitung
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM cancel .
  DATA abort TYPE xfeld.

* Daten sichern?
  PERFORM data_to_save CHANGING abort.
  CHECK abort IS INITIAL.
* Entsperren der gesperrten Protokolle
  PERFORM unlock.

  CLEAR: head_tab[],
         item_tab[],
         state_tab[],
         overview_tab[],
         detail_tab[],
         delete_overview_tab[].
  LEAVE TO SCREEN 0.
ENDFORM.                    " cancel

*&---------------------------------------------------------------------*
*&      Form  exit
*&---------------------------------------------------------------------*
*       Verlassen der Transaktion
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM exit.
  DATA abort TYPE xfeld.

* Daten sichern?
  PERFORM data_to_save CHANGING abort.
  CHECK abort IS INITIAL.
* Entsperren der gesperrten Protokolle
  PERFORM unlock.

  CLEAR: head_tab[],
         item_tab[],
         state_tab[],
         overview_tab[],
         detail_tab[],
         delete_overview_tab[].
  LEAVE PROGRAM.
ENDFORM.                    " exit.

*&---------------------------------------------------------------------*
*&      Form  process_0102
*&---------------------------------------------------------------------*
*       Verarbeitung auf dem Screen 0102
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM process_0102.
  DATA: overview     TYPE t_overview,
        no_drilldown TYPE lvc_s_col-fieldname,
        char32       TYPE char32.

* ParameterID des Protokolls bestimmen
  GET PARAMETER ID 'JPROTOCOLID' FIELD char32.
  MOVE char32 TO logid.
  CLEAR char32.
  SET PARAMETER ID 'JPROTOCOLID' FIELD char32.

* Steuerparameter setzen
*  succ_msg  = 'X'.
*  err_msg   = 'X'.
*  warn_msg  = 'X'.
  logsp = 'X'.
  PERFORM select_data.
  IF protocol_overview IS INITIAL.
    PERFORM init_0100.
  ELSE.
    PERFORM refresh_overview_on_screen.
  ENDIF.
  PERFORM show_detail_on_screen USING overview
                                      no_drilldown.
  LEAVE TO SCREEN 0.
ENDFORM.                    " process_0102

*&---------------------------------------------------------------------*
*&      Form  do_saving
*&---------------------------------------------------------------------*
*       Sichern der Daten auf der Datenbank durchführen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM do_saving TABLES delete_head_tab STRUCTURE jksdprotocolhead
                      update_item_tab STRUCTURE jksdprotocol
                      delete_item_tab STRUCTURE jksdprotocol.

* Kopfdaten löschen
  CALL FUNCTION 'ISM_SD_JKSDPROTOCOLHEAD_BOOK' IN UPDATE TASK
    TABLES
      delete_tab = delete_head_tab[].

* Positionsdaten Protokoll anpassen
  CALL FUNCTION 'ISM_SD_JKSDPROTOCOL_BOOK' IN UPDATE TASK
    TABLES
      delete_tab = delete_item_tab[]
      update_tab = update_item_tab[].

  IF NOT delete_head_tab[] IS INITIAL OR
     NOT update_item_tab[] IS INITIAL OR
     NOT delete_item_tab[] IS INITIAL.
    MESSAGE s204(jksdorder2).
  ELSE.
    MESSAGE s205(jksdorder2).
  ENDIF.
ENDFORM.                    " do_saving

*&---------------------------------------------------------------------*
*&      Form  get_jksdlogorderst
*&---------------------------------------------------------------------*
*       Lesen der Tabelle jksdlogorderst zur in_item_tab
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_jksdlogorderst TABLES out_state_tab STRUCTURE jksdlogorderst
                               in_head_tab   STRUCTURE jksdprotocolhead.

* Lesen der Tabelle JKSDLOGORDERST
  CHECK NOT in_head_tab[] IS INITIAL.
  SELECT * INTO TABLE out_state_tab FROM jksdlogorderst
    FOR ALL ENTRIES IN in_head_tab
    WHERE logid = in_head_tab-logid.

* Sortieren der Tabelle
  SORT out_state_tab BY logid status contract item issue.
ENDFORM.                    " get_jksdlogorderst

*&---------------------------------------------------------------------*
*&      Form  show_data_overview_on_screen
*&---------------------------------------------------------------------*
*       Überblick Daten zum Generierungslauf am Bildschirm anzeigen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM show_data_overview_on_screen.
  IF protocol_overview IS INITIAL.
    PERFORM init_0100.
  ELSE.
    PERFORM refresh_overview_on_screen.
  ENDIF.
  CALL SCREEN 0100.
ENDFORM.                    " show_data_overview_on_screen

*&---------------------------------------------------------------------*
*&      Form  get_detail_data
*&---------------------------------------------------------------------*
*       Detaildaten zu den Überblicksdaten overview bestimmen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_detail_data USING    overview     TYPE t_overview
                              drilldown    TYPE lvc_s_col-fieldname
                              no_message   TYPE xfeld
                     CHANGING detail_tab   TYPE t_detail_tab.
  FIELD-SYMBOLS <item>        TYPE t_jksdprotocol.
  DATA: index         TYPE i,
        lines         TYPE i,
        msg_add_tab   TYPE rjksd_tjksdorderstmsg_tab,
        msg_minus_tab TYPE rjksd_tjksdorderstmsg_tab,
        do_drilldown  TYPE xfeld,
        failure       TYPE xfeld.

* Rückgabewert initialisieren
  CLEAR detail_tab[].

* Meldungen bestimmen, die laut Drilldown angezeigt werden sollen
  PERFORM get_msg_for_drilldown USING    drilldown
                                CHANGING msg_add_tab
                                         msg_minus_tab
                                         do_drilldown.
* Ergebnis aufbauen
  IF NOT overview-logid IS INITIAL.
    lines = lines( item_tab ).
    READ TABLE item_tab ASSIGNING <item>
      WITH KEY logid = overview-logid BINARY SEARCH.
    CHECK sy-subrc = 0.
    index = sy-tabix.
    DO.
      CLEAR failure.
*     Meldung laut Drilldown erlaubt?
      IF NOT do_drilldown IS INITIAL.
        READ TABLE msg_add_tab
          WITH KEY msgid = <item>-msgid
                   msgnr = <item>-msgno BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          failure = 'X'.
        ENDIF.
        READ TABLE msg_minus_tab
          WITH KEY msgid = <item>-msgid
                   msgnr = <item>-msgno BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          failure = 'X'.
        ENDIF.
      ENDIF.
      IF failure IS INITIAL.
*       Daten aufnehmen in Ergebnisstruktur
        PERFORM append_item USING    <item>
                                     overview-readonly
                            CHANGING detail_tab.
      ENDIF.
      index = index + 1.
      IF index > lines.EXIT.ENDIF.
      READ TABLE item_tab ASSIGNING <item> INDEX index.
      IF <item>-logid <> overview-logid.EXIT.ENDIF.
    ENDDO.
  ELSE.
    LOOP AT item_tab ASSIGNING <item>.
*     Daten aufnehmen in Ergebnisstruktur
      PERFORM append_item USING    <item>
                                   overview-readonly
                          CHANGING detail_tab.
    ENDLOOP.
  ENDIF.
  CHECK no_message IS INITIAL.
  IF detail_tab[] IS INITIAL.
    IF do_drilldown IS INITIAL.
      MESSAGE i160(jksdprotocol).
    ELSE.
      MESSAGE i161(jksdprotocol).
    ENDIF.
  ENDIF.

  INCLUDE zqtcn_fetch_data_sub_r112 IF FOUND.

ENDFORM.                    " get_detail_data

*&---------------------------------------------------------------------*
*&      Form  fill_overview_tab
*&---------------------------------------------------------------------*
*       Kopfdaten aufbereiten zur Darstellung am Bildschirm
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM fill_overview_tab TABLES head_tab       STRUCTURE jksdprotocolhead
                              state_tab      STRUCTURE jksdlogorderst
                       USING  not_locked_tab TYPE      rjksdprotocollocked_tab.
  FIELD-SYMBOLS: <head>       TYPE jksdprotocolhead,
                 <not_locked> TYPE rjksdprotocollocked.
  DATA: overview      TYPE t_overview,
        lines         TYPE i,
        configuration TYPE tjksdprotocol,
        cell          TYPE lvc_s_styl.

  CLEAR overview_tab[].
  lines = lines( state_tab ).
  SORT not_locked_tab BY logid.
* Konfiguration des Protokolls einlesen
  PERFORM get_tjksdprotocol CHANGING configuration.

  LOOP AT head_tab ASSIGNING <head>.
    CLEAR overview.
    MOVE-CORRESPONDING <head> TO overview.                  "#EC ENHOK
    READ TABLE not_locked_tab ASSIGNING <not_locked>
      WITH KEY logid = <head>-logid BINARY SEARCH.
    IF sy-subrc = 0.
      overview-readonly = 'X'.
      overview-lockedby = <not_locked>-lockedby.
      cell-style        = cl_gui_alv_grid=>mc_style_disabled.
      INSERT cell INTO TABLE overview-cell_tab.
    ENDIF.
    PERFORM get_msgs_in_state TABLES   state_tab
                              USING    <head>
                                       lines
                                       configuration
                              CHANGING overview.
    PERFORM set_hotspot USING    overview-count1
                                 'COUNT1'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count2
                                 'COUNT2'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count3
                                 'COUNT3'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count4
                                 'COUNT4'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count5
                             'COUNT5'
                    CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count6
                                 'COUNT6'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count7
                                 'COUNT7'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count8
                                 'COUNT8'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count9
                                 'COUNT9'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count10
                                 'COUNT10'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count11
                                 'COUNT11'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count12
                                 'COUNT12'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count13
                                 'COUNT13'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count14
                                 'COUNT14'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count15
                                 'COUNT15'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count16
                                 'COUNT16'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count17
                                 'COUNT17'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count18
                                 'COUNT18'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count19
                                 'COUNT19'
                        CHANGING overview-cell_tab.
    PERFORM set_hotspot USING    overview-count20
                                 'COUNT20'
                        CHANGING overview-cell_tab.
    CASE overview-area.
      WHEN 'RJKSDORDERGEN'.
        overview-areatext = text-130.
      WHEN 'RJKSEORDERGEN'.
        overview-areatext = text-131.
      WHEN 'RJKSDORDERCANCEL'.
        overview-areatext = text-132.
      WHEN 'RJKSEORDERCANCEL'.
        overview-areatext = text-133.
      WHEN 'RJKSDORDERGENTRANSPORTPLAN'.
        overview-areatext = text-134.
    ENDCASE.
    APPEND overview TO overview_tab.
  ENDLOOP.
  SORT overview_tab BY generationdate DESCENDING
                       generationtime DESCENDING.
ENDFORM.                    " fill_overview_tab

*&---------------------------------------------------------------------*
*&      Form  FIELDCATALOG_MERGE
*&---------------------------------------------------------------------*
*       Feldkatalog lesen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM fieldcatalog_merge  USING    structure    TYPE dd02l-tabname
                         CHANGING fieldcatalog TYPE lvc_t_fcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = structure
    CHANGING
      ct_fieldcat      = fieldcatalog.
ENDFORM.                    " FIELDCATALOG_MERGE

*&---------------------------------------------------------------------*
*&      Form  create_dropdownbox_layer
*&---------------------------------------------------------------------*
*       Dropdownbox für das Feld "Herkunft der Meldung" aufbauen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM create_dropdownbox_layer CHANGING handle TYPE lvc_s_drop-handle.
  FIELD-SYMBOLS <origin>   TYPE dd07v.
  DATA: origin_tab TYPE TABLE OF dd07v,
        drop       TYPE lvc_s_drop,
        drop_tab   TYPE lvc_t_drop,
        dropdown   TYPE t_dropdown_layer.

* Nummer für Dropdownhandle vergeben
  handle = handle + 1.

* Domänenfestwerte zum Datenelement ISMLAYER lesen
  PERFORM get_domainvalues TABLES origin_tab[]
                           USING  'ISMLAYER'.

* Aufbauen der Handles
  LOOP AT origin_tab ASSIGNING <origin>.
    drop-value  = <origin>-ddtext.
    drop-handle = handle.
    APPEND drop TO drop_tab.
    dropdown-handle = handle.
    dropdown-value  = <origin>-domvalue_l.
    dropdown-text   = <origin>-ddtext.
    APPEND dropdown TO dropdown_layer_tab.
  ENDLOOP.
  SORT dropdown_layer_tab BY value.
  CALL METHOD protocol_detail->set_drop_down_table
    EXPORTING
      it_drop_down = drop_tab.
ENDFORM.                    " create_dropdownbox_layer

*&---------------------------------------------------------------------*
*&      Form  get_domainvalue
*&---------------------------------------------------------------------*
*       Lesen von Domänenfestwerten
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_domainvalues TABLES tab        STRUCTURE dd07v
                      USING  domainname TYPE      dd01l-domname.

  CALL FUNCTION 'DD_DD07V_GET'
    EXPORTING
      domain_name    = domainname
    TABLES
      dd07v_tab      = tab[]
    EXCEPTIONS
      access_failure = 1
      OTHERS         = 2.
  IF sy-subrc <> 0.
    CLEAR tab[].
  ENDIF.
  SORT tab BY domvalue_l.
ENDFORM.                                                    " get_domainvalue

*&---------------------------------------------------------------------*
*&      Form  get_TJKSDPROTOCOL
*&---------------------------------------------------------------------*
*       Tabelle TJKSDPROTOCOL lesen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_tjksdprotocol CHANGING tjksdprotocol TYPE tjksdprotocol.

  CALL FUNCTION 'ISM_SD_SELECT_TJKSDPROTOCOL'
    IMPORTING
      out_tjksdprotocol = tjksdprotocol.
ENDFORM.                    " get_TJKSDPROTOCOL

*&---------------------------------------------------------------------*
*&      Form  get_msgs_in_state
*&---------------------------------------------------------------------*
*       Anzahl der Meldungen entsprechend der Konfiguration bestimmen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_msgs_in_state TABLES   state_tab     STRUCTURE jksdlogorderst
                       USING    head          TYPE      jksdprotocolhead
                                lines         TYPE      i
                                configuration TYPE      tjksdprotocol
                       CHANGING overview      TYPE      t_overview.

* Count1 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count1
                                      head
                                      lines
                             CHANGING overview-count1.

* Count2 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count2
                                      head
                                      lines
                             CHANGING overview-count2.
* Count3 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count3
                                      head
                                      lines
                             CHANGING overview-count3.
* Count4 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count4
                                      head
                                      lines
                             CHANGING overview-count4.
* Count5 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count5
                                      head
                                      lines
                             CHANGING overview-count5.
* Count6 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count6
                                      head
                                      lines
                             CHANGING overview-count6.
* Count7 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count7
                                      head
                                      lines
                             CHANGING overview-count7.
* Count8 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count8
                                      head
                                      lines
                             CHANGING overview-count8.
* Count9 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count9
                                      head
                                      lines
                             CHANGING overview-count9.
* Count10 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count10
                                      head
                                      lines
                             CHANGING overview-count10.
* Count11 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count11
                                      head
                                      lines
                             CHANGING overview-count11.

* Count12 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count12
                                      head
                                      lines
                             CHANGING overview-count12.
* Count13 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count13
                                      head
                                      lines
                             CHANGING overview-count13.
* Count14 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count14
                                      head
                                      lines
                             CHANGING overview-count14.
* Count15 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count15
                                      head
                                      lines
                             CHANGING overview-count15.
* Count16 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count16
                                      head
                                      lines
                             CHANGING overview-count16.
* Count17 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count17
                                      head
                                      lines
                             CHANGING overview-count17.
* Count18 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count18
                                      head
                                      lines
                             CHANGING overview-count18.
* Count19 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count19
                                      head
                                      lines
                             CHANGING overview-count19.
* Count20 bestimmen
  PERFORM count_msg_in_state TABLES   state_tab
                             USING    configuration-count20
                                      head
                                      lines
                             CHANGING overview-count20.
ENDFORM.                    " get_msgs_in_state

*&---------------------------------------------------------------------*
*&      Form  get_TJKSDORDERDESTt
*&---------------------------------------------------------------------*
*       Lesen der Tabelle TJKSDORDERPROT
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_tjksdorderprot
    USING    calcrule       TYPE tjksdorderpro-calcrule
    CHANGING tjksdorderprot TYPE tjksdorderprot.

  CALL FUNCTION 'ISM_SD_SELECT_TJKSDORDERPROT'
    EXPORTING
      in_calcrule        = calcrule
    IMPORTING
      out_tjksdorderprot = tjksdorderprot.
ENDFORM.                    " get_TJKSDORDERPROT

*&---------------------------------------------------------------------*
*&      Form  hide_overview
*&---------------------------------------------------------------------*
*       Übersichtsbild nicht anzeigen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM hide_overview.
  dynnr_workarea = con_screen_detail.
ENDFORM.                    " hide_overview

*&---------------------------------------------------------------------*
*&      Form  hide_detail
*&---------------------------------------------------------------------*
*       Detailbild nicht anzeigen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM hide_detail.
  dynnr_workarea = con_screen_overview.
ENDFORM.                    " hide_detail

*&---------------------------------------------------------------------*
*&      Form  show_overview
*&---------------------------------------------------------------------*
*       Überblick anzeigen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM show_overview .
  IF NOT detail_tab[] IS INITIAL.
    dynnr_workarea = con_screen_overview_detail.
  ELSE.
    dynnr_workarea = con_screen_detail.
  ENDIF.
ENDFORM.                    " show_overview

*&---------------------------------------------------------------------*
*&      Form  show_detail
*&---------------------------------------------------------------------*
*       Detailbild anzeigen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM show_detail.
  IF NOT overview_tab[] IS INITIAL.
    dynnr_workarea = con_screen_overview_detail.
  ELSE.
    dynnr_workarea = con_screen_overview.
  ENDIF.
ENDFORM.                    " show_detail

*&---------------------------------------------------------------------*
*&      Form  get_deleted_head
*&---------------------------------------------------------------------*
*       Gelöschte Kopfdaten bestimmen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_deleted_head TABLES delete_head_tab STRUCTURE jksdprotocolhead
                             delete_item_tab STRUCTURE jksdprotocol.
  FIELD-SYMBOLS: <overview> TYPE t_overview,
                 <item>     TYPE t_jksdprotocol.
  DATA: jksdprotocolhead TYPE jksdprotocolhead,
        jksdprotocol     TYPE jksdprotocol,
        index            TYPE sy-tabix,
        lines            TYPE sy-tabix.

* Rückgabewerte initialisieren
  CLEAR: delete_head_tab[],
         delete_item_tab[].

  lines = lines( item_tab ).
  LOOP AT delete_overview_tab ASSIGNING <overview>.
    MOVE-CORRESPONDING <overview> TO jksdprotocolhead.      "#EC ENHOK
    APPEND jksdprotocolhead TO delete_head_tab.

*   Positionsdaten zu den Kopfdaten bestimmen
    READ TABLE item_tab ASSIGNING <item>
      WITH KEY logid = <overview>-logid BINARY SEARCH.
    CHECK sy-subrc = 0.
    index = sy-tabix.
    DO.
      MOVE-CORRESPONDING <item> TO jksdprotocol.
      APPEND jksdprotocol TO delete_item_tab.
      index = index + 1.
      IF index > lines.EXIT.ENDIF.
      READ TABLE item_tab ASSIGNING <item> INDEX index.
      IF <item>-logid <> <overview>-logid.EXIT.ENDIF.
    ENDDO.
  ENDLOOP.
ENDFORM.                    " get_deleted_head

*&---------------------------------------------------------------------*
*&      Form  unlock
*&---------------------------------------------------------------------*
*       Entsperren der gesperrten Protokolle
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM unlock.
  FIELD-SYMBOLS <overview> TYPE t_overview.

  LOOP AT overview_tab ASSIGNING <overview>
    WHERE readonly = ' '.
    CALL FUNCTION 'DEQUEUE_E_JKSDPROTOCOL'
      EXPORTING
*       MODE_JKSDPROTOCOLHEAD = 'E'
*       MANDT  = SY-MANDT
        logid  = <overview>-logid
*       X_LOGID               = ' '
        _scope = '3'
*       _SYNCHRON             = ' '
*       _COLLECT              = ' '
      .
  ENDLOOP.
ENDFORM.                    " unlock

*&---------------------------------------------------------------------*
*&      Form  count_msg_in_state
*&---------------------------------------------------------------------*
*       Anzahl der Meldungen im Status state zählen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM count_msg_in_state
     TABLES   state_tab STRUCTURE jksdlogorderst
     USING    calcrule  TYPE      tjksdprotocol-count1
              head      TYPE      jksdprotocolhead
              lines     TYPE      i
     CHANGING count     TYPE      t_overview-count1.
  CONSTANTS operator_plus TYPE tjksdorderpro-operator_state5 VALUE '+'.
  DATA: tjksdorderpro TYPE tjksdorderpro,
        count1        TYPE rjksdshowprotocoloverview-count1,
        count2        TYPE rjksdshowprotocoloverview-count1,
        count3        TYPE rjksdshowprotocoloverview-count1,
        count4        TYPE rjksdshowprotocoloverview-count1,
        count5        TYPE rjksdshowprotocoloverview-count1.

* Lesen der Tabelle TJKSDORDERPRO
  PERFORM get_tjksdorderpro USING    calcrule
                            CHANGING tjksdorderpro.

* State1 verarbeiten
  PERFORM count_msg TABLES   state_tab
                    USING    head
                             lines
                             tjksdorderpro-state1
                             tjksdorderpro-cond1
                             operator_plus
                    CHANGING count1.
* State2 verarbeiten
  PERFORM count_msg TABLES   state_tab
                    USING    head
                             lines
                             tjksdorderpro-state2
                             tjksdorderpro-cond2
                             tjksdorderpro-operator_state2
                    CHANGING count2.
* State3 verarbeiten
  PERFORM count_msg TABLES   state_tab
                    USING    head
                             lines
                             tjksdorderpro-state3
                             tjksdorderpro-cond3
                             tjksdorderpro-operator_state3
                    CHANGING count3.
* State4 verarbeiten
  PERFORM count_msg TABLES   state_tab
                    USING    head
                             lines
                             tjksdorderpro-state4
                             tjksdorderpro-cond4
                             tjksdorderpro-operator_state4
                    CHANGING count4.
* State5 verarbeiten
  PERFORM count_msg TABLES   state_tab
                    USING    head
                             lines
                             tjksdorderpro-state5
                             tjksdorderpro-cond5
                             tjksdorderpro-operator_state5
                    CHANGING count5.

* Count berechnen
  count = count1 + count2 + count3 + count4 + count5.
ENDFORM.                    " count_msg_in_state

*&---------------------------------------------------------------------*
*&      Form  BP_SIMPLE_INTO_LINE_BUFFER
*&---------------------------------------------------------------------*
*       Name eines GPs ermitteln
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM bp_simple_into_line_buffer  USING    kunnr TYPE vbpa-kunnr
                                 CHANGING name  TYPE t_detail-name_ag.

  CHECK NOT kunnr IS INITIAL.
  CALL FUNCTION 'ISM_BP_SIMPLE_INTO_LINE_BUFFER'
    EXPORTING
      in_bp    = kunnr
    IMPORTING
      out_name = name.
ENDFORM.                    " BP_SIMPLE_INTO_LINE_BUFFER

*&---------------------------------------------------------------------*
*&      Form  get_TJKSDORDERPRO
*&---------------------------------------------------------------------*
*       Lesen der Tabelle TJKSDORDERPRO
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_tjksdorderpro  USING    calcrule      TYPE tjksdorderpro-calcrule
                        CHANGING tjksdorderpro TYPE tjksdorderpro.

  IF calcrule IS INITIAL.
    CLEAR tjksdorderpro.
  ELSE.
    CALL FUNCTION 'ISM_SD_SELECT_TJKSDORDERPRO'
      EXPORTING
        in_calcrule       = calcrule
      IMPORTING
        out_tjksdorderpro = tjksdorderpro
      EXCEPTIONS
        no_data_found     = 1
        OTHERS            = 2.
    IF sy-subrc <> 0.
      CLEAR tjksdorderpro.
    ENDIF.
  ENDIF.
ENDFORM.                    " get_TJKSDORDERPRO

*&---------------------------------------------------------------------*
*&      Form  count_msg
*&---------------------------------------------------------------------*
*       Meldungen im Status zählen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM count_msg  TABLES   state_tab STRUCTURE jksdlogorderst
                USING    head      TYPE      jksdprotocolhead
                         lines     TYPE      i
                         status    TYPE      tjksdorderpro-state1
                         cond      TYPE      tjksdorderpro-cond1
                         operator  TYPE      tjksdorderpro-operator_state2
                CHANGING count     TYPE      rjksdshowprotocoloverview-count1.
  FIELD-SYMBOLS <state>   TYPE jksdlogorderst.
  DATA: old_state TYPE jksdlogorderst,
        index     TYPE sy-tabix.

  CHECK NOT status IS INITIAL.
  CASE cond.
    WHEN '1'.
      CHECK NOT head-testrun IS INITIAL.
    WHEN '2'.
      CHECK head-testrun IS INITIAL.
  ENDCASE.
  READ TABLE state_tab ASSIGNING <state>
    WITH KEY logid  = head-logid
             status = status BINARY SEARCH.
  CHECK sy-subrc = 0.
  index = sy-tabix.
  DO.
    IF <state>-contract <> old_state-contract OR
       <state>-item     <> old_state-item     OR
       <state>-issue    <> old_state-issue.
      count     = count + 1.
      old_state = <state>.
    ENDIF.
    index = index + 1.
    IF index > lines.EXIT.ENDIF.
    READ TABLE state_tab ASSIGNING <state> INDEX index.
    IF <state>-logid  <> head-logid OR
       <state>-status <> status.
      EXIT.
    ENDIF.
  ENDDO.
  IF operator = '-'.
    count =  count * ( -1 ).
  ENDIF.
ENDFORM.                    " count_msg

*&---------------------------------------------------------------------*
*&      Form  get_msg_for_drilldown
*&---------------------------------------------------------------------*
*       Meldungen bestimmen, die im Drilldown enthalten sind. Ist ein
*       Drilldown zu machen ist  do_drilldown = 'X', sonst initial.
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_msg_for_drilldown
      USING    drilldown     TYPE lvc_s_col-fieldname
      CHANGING msg_add_tab   TYPE rjksd_tjksdorderstmsg_tab
               msg_minus_tab TYPE rjksd_tjksdorderstmsg_tab
               do_drilldown  TYPE xfeld.
  DATA: tjksdprotocol TYPE tjksdprotocol,
        tjksdorderpro TYPE tjksdorderpro.

  PERFORM get_tjksdprotocol CHANGING tjksdprotocol.
  CASE drilldown.
    WHEN 'COUNT1'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count1
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT2'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count2
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT3'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count3
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT4'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count4
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT5'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count5
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT6'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count6
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT7'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count7
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT8'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count8
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT9'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count9
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT10'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count10
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT11'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count11
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT12'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count12
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT13'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count13
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT14'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count14
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT15'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count15
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT16'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count16
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT17'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count17
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT18'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count18
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT19'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count19
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
    WHEN 'COUNT20'.
      PERFORM get_tjksdorderpro USING    tjksdprotocol-count20
                                CHANGING tjksdorderpro.
      do_drilldown = 'X'.
  ENDCASE.
  CHECK NOT tjksdorderpro IS INITIAL.

  PERFORM get_msg_add_to_calcrule USING    tjksdorderpro
                                  CHANGING msg_add_tab.
  PERFORM get_msg_minus_to_calcrule USING    tjksdorderpro
                                    CHANGING msg_minus_tab.
ENDFORM.                    " get_msg_for_drilldown

*&---------------------------------------------------------------------*
*&      Form  GET_TJKSDORDERSTMSG
*&---------------------------------------------------------------------*
*       Meldungen zu Status bestimmen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_tjksdorderstmsg
    USING    status              TYPE tjksdorderstmsg-status
    CHANGING tjksdorderstmsg_tab TYPE rjksd_tjksdorderstmsg_tab.

  CHECK NOT status IS INITIAL.
  CALL FUNCTION 'ISM_SD_GET_TJKSDORDERSTMSG'
    EXPORTING
      in_status               = status
    IMPORTING
      out_tjksdorderstmsg_tab = tjksdorderstmsg_tab.
ENDFORM.                    " GET_TJKSDORDERSTMSG

*&---------------------------------------------------------------------*
*&      Form  get_msg_add_to_calcrule
*&---------------------------------------------------------------------*
*       Meldungen bestimmen, die laut der Rechenvorschrift Calcrule
*       gezählt werden sollen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_msg_add_to_calcrule
    USING    tjksdorderpro       TYPE tjksdorderpro
    CHANGING tjksdorderstmsg_tab TYPE rjksd_tjksdorderstmsg_tab.
  DATA: msg2_tab TYPE rjksd_tjksdorderstmsg_tab,
        msg3_tab TYPE rjksd_tjksdorderstmsg_tab,
        msg4_tab TYPE rjksd_tjksdorderstmsg_tab,
        msg5_tab TYPE rjksd_tjksdorderstmsg_tab.

* Rückgabewerte initialiseren
  CLEAR tjksdorderstmsg_tab[].

  PERFORM get_tjksdorderstmsg USING    tjksdorderpro-state1
                              CHANGING tjksdorderstmsg_tab.

  IF tjksdorderpro-operator_state2 = '+'.
    PERFORM get_tjksdorderstmsg USING    tjksdorderpro-state2
                                CHANGING msg2_tab.
  ENDIF.

  IF tjksdorderpro-operator_state3 = '+'.
    PERFORM get_tjksdorderstmsg USING    tjksdorderpro-state3
                                CHANGING msg3_tab.
  ENDIF.

  IF tjksdorderpro-operator_state4 = '+'.
    PERFORM get_tjksdorderstmsg USING    tjksdorderpro-state4
                                CHANGING msg4_tab.
  ENDIF.

  IF tjksdorderpro-operator_state5 = '+'.
    PERFORM get_tjksdorderstmsg USING    tjksdorderpro-state5
                                CHANGING msg5_tab.
  ENDIF.
  APPEND LINES OF msg2_tab[] TO tjksdorderstmsg_tab.
  APPEND LINES OF msg3_tab[] TO tjksdorderstmsg_tab.
  APPEND LINES OF msg4_tab[] TO tjksdorderstmsg_tab.
  APPEND LINES OF msg5_tab[] TO tjksdorderstmsg_tab.
* Sortieren des Ergebnisses
  SORT tjksdorderstmsg_tab BY msgid
                              msgnr.
ENDFORM.                    "  get_msg_add_to_calcrule

*&---------------------------------------------------------------------*
*&      Form  get_msg_minus_to_calcrule
*&---------------------------------------------------------------------*
*       Meldungen bestimmen, die laut der Rechenvorschrift Calcrule
*       abgezogen werden sollen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_msg_minus_to_calcrule
    USING    tjksdorderpro       TYPE tjksdorderpro
    CHANGING tjksdorderstmsg_tab TYPE rjksd_tjksdorderstmsg_tab.
  DATA: msg3_tab TYPE rjksd_tjksdorderstmsg_tab,
        msg4_tab TYPE rjksd_tjksdorderstmsg_tab,
        msg5_tab TYPE rjksd_tjksdorderstmsg_tab.

* Rückgabewerte initialiseren
  CLEAR tjksdorderstmsg_tab[].

  IF tjksdorderpro-operator_state2 = '-'.
    PERFORM get_tjksdorderstmsg USING    tjksdorderpro-state2
                                CHANGING tjksdorderstmsg_tab.
  ENDIF.

  IF tjksdorderpro-operator_state3 = '-'.
    PERFORM get_tjksdorderstmsg USING    tjksdorderpro-state3
                                CHANGING msg3_tab.
  ENDIF.

  IF tjksdorderpro-operator_state4 = '-'.
    PERFORM get_tjksdorderstmsg USING    tjksdorderpro-state4
                                CHANGING msg4_tab.
  ENDIF.

  IF tjksdorderpro-operator_state5 = '-'.
    PERFORM get_tjksdorderstmsg USING    tjksdorderpro-state5
                                CHANGING msg5_tab.
  ENDIF.
  APPEND LINES OF msg3_tab[] TO tjksdorderstmsg_tab.
  APPEND LINES OF msg4_tab[] TO tjksdorderstmsg_tab.
  APPEND LINES OF msg5_tab[] TO tjksdorderstmsg_tab.
* Sortieren des Ergebnisses
  SORT tjksdorderstmsg_tab BY msgid
                              msgnr.
ENDFORM.                    "  get_msg_MINUS_to_calcrule

*&---------------------------------------------------------------------*
*&      Form  MSGTY_TO_RANGE
*&---------------------------------------------------------------------*
*       Meldungstyp in Rangetabelle konvertieren
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
*form msgty_to_range using    msgty     type jmsgty
*                    changing range_tab type rjksd_msgty_range_tab.
*
*  call function 'ISM_SD_MSGTY_TO_RANGE'
*    exporting
*      in_msgty  = msgty
*    changing
*      msgty_tab = range_tab.
*endform.                    " MSGTY_TO_RANGE

*&---------------------------------------------------------------------*
*&      Form  AREA_TO_RANGE
*&---------------------------------------------------------------------*
*       Area in Rangetabelle umwandeln
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM area_to_range USING    area      TYPE jarea
                   CHANGING range_tab TYPE rjksd_area_range_tab.

  CALL FUNCTION 'ISM_SD_AREA_TO_RANGE'
    EXPORTING
      in_area  = area
    CHANGING
      area_tab = range_tab.
ENDFORM.                    " AREA_TO_RANGE

*&---------------------------------------------------------------------*
*&      Form  get_selection_criteria
*&---------------------------------------------------------------------*
*       Selektionskriterien für Selektion von Protokolldaten
*       bestimmen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_selection_criteria CHANGING area_tab  TYPE rjksd_area_range_tab.

* Und für selektiertes Protokoll
  IF NOT gen_mps IS INITIAL.
    PERFORM area_to_range USING    'RJKSDORDERGEN'
                          CHANGING area_tab.
    PERFORM area_to_range USING    'RJKSDORDERGENTRANSPORTPLAN'
                          CHANGING area_tab.
  ENDIF.
  IF NOT gen_se IS INITIAL.
    PERFORM area_to_range USING    'RJKSEORDERGEN'
                          CHANGING area_tab.
  ENDIF.
  IF NOT del_mps IS INITIAL.
    PERFORM area_to_range USING    'RJKSDORDERCANCEL'
                          CHANGING area_tab.
  ENDIF.
  IF NOT del_se IS INITIAL.
    PERFORM area_to_range USING    'RJKSEORDERCANCEL'
                          CHANGING area_tab.
  ENDIF.
ENDFORM.                    " get_selection_criteria

*&---------------------------------------------------------------------*
*&      Form  append_item
*&---------------------------------------------------------------------*
*       Item an die Tabelle detail_tab bildschirmgerecht aufbereitet
*       anhängen.
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM append_item  USING    item       TYPE t_jksdprotocol
                           readonly   TYPE xfeld
                  CHANGING detail_tab TYPE t_detail_tab.
  FIELD-SYMBOLS <dropdown_layer> TYPE t_dropdown_layer.
  DATA: detail    TYPE t_detail,
        cell      TYPE lvc_s_styl,
        quickinfo TYPE icont-quickinfo,
        icon(30)  TYPE c.

  IF NOT item-msgid IS INITIAL AND
     NOT item-msgty IS INITIAL AND
     NOT item-msgno IS INITIAL.
    MESSAGE ID  item-msgid TYPE item-msgty NUMBER item-msgno
            WITH item-msgv1 item-msgv2 item-msgv3 item-msgv4
            INTO detail-msg.
  ENDIF.
  MOVE-CORRESPONDING item TO detail.                        "#EC ENHOK
  CASE detail-msgty.
    WHEN 'E'.
      icon      = 'ICON_RED_LIGHT'.
      quickinfo = text-232.
      PERFORM mark_line_with_error CHANGING detail.
    WHEN 'A'.
      icon      = 'ICON_RED_LIGHT'.
      quickinfo = text-232.
      PERFORM mark_line_with_error CHANGING detail.
    WHEN 'I'.
      icon      = 'ICON_MESSAGE_INFORMATION_SMALL'.
      quickinfo = text-235.
    WHEN 'W'.
      quickinfo = text-234.
      icon      = 'ICON_YELLOW_LIGHT'.
    WHEN 'S'.
      quickinfo = text-233.
      icon      = 'ICON_GREEN_LIGHT'.
  ENDCASE.
  IF NOT icon IS INITIAL.
    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name                  = icon
        info                  = quickinfo
      IMPORTING
        result                = detail-icon
      EXCEPTIONS
        icon_not_found        = 1
        outputfield_too_short = 2
        OTHERS                = 3.
  ENDIF.
  READ TABLE dropdown_layer_tab ASSIGNING <dropdown_layer>
    WITH KEY value = item-layer BINARY SEARCH.
  IF sy-subrc = 0.
    detail-dropdown_layer = <dropdown_layer>-handle.
    detail-layert         = <dropdown_layer>-text.
  ENDIF.
  IF NOT readonly IS INITIAL.
    cell-style = cl_gui_alv_grid=>mc_style_disabled.
    INSERT cell INTO TABLE detail-cell_tab.
  ENDIF.
* Name AG ermitteln
  PERFORM bp_simple_into_line_buffer USING    detail-ag
                                     CHANGING detail-name_ag.
* Name WE ermitteln
  PERFORM bp_simple_into_line_buffer USING    detail-we
                                     CHANGING detail-name_we.
  APPEND detail TO detail_tab.
ENDFORM.                    " append_item


*&---------------------------------------------------------------------*
*&      Form  adapt_fieldcat_count_4_display
*&---------------------------------------------------------------------*
*       Anpassen des Feldkatalogs für ein Count-Feld
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM adapt_fieldcat_count_4_display USING    count    TYPE tjksdprotocol-count1
                                    CHANGING fieldcat TYPE lvc_s_fcat.
  DATA tjksdorderprot TYPE tjksdorderprot.

  IF NOT count IS INITIAL.
    PERFORM get_tjksdorderprot USING    count
                               CHANGING tjksdorderprot.
    IF NOT tjksdorderprot-text IS INITIAL.
      fieldcat-reptext   = tjksdorderprot-text.
      fieldcat-scrtext_l = tjksdorderprot-text.
      fieldcat-scrtext_m = tjksdorderprot-text.
      fieldcat-scrtext_s = tjksdorderprot-text.
    ELSE.
      CONCATENATE text-200 count INTO fieldcat-reptext   SEPARATED BY space.
      CONCATENATE text-200 count INTO fieldcat-scrtext_l SEPARATED BY space.
      CONCATENATE text-200 count INTO fieldcat-scrtext_m SEPARATED BY space.
      CONCATENATE text-202 count INTO fieldcat-scrtext_s SEPARATED BY space.
    ENDIF.
    fieldcat-tooltip = tjksdorderprot-textlong.
  ELSE.
    fieldcat-tech = 'X'.
  ENDIF.
  fieldcat-emphasize = 'X'.
ENDFORM.                    " adapt_fieldcat_count_4_display

*&---------------------------------------------------------------------*
*&      Form  status_no_overview
*&---------------------------------------------------------------------*
*       Fcodes für Überblick deaktivieren
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM status_no_overview CHANGING fcode_tab TYPE t_fcode_tab.
  DATA fcode TYPE t_fcode.

  fcode-fcode = con_fcode_show_overview.
  APPEND fcode TO fcode_tab.
  fcode-fcode = con_fcode_hide_overview.
  APPEND fcode TO fcode_tab.
ENDFORM.                    " status_no_overview

*&---------------------------------------------------------------------*
*&      Form  status_no_detail
*&---------------------------------------------------------------------*
*       Fcodes für Detail deaktivieren
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM status_no_detail CHANGING fcode_tab TYPE t_fcode_tab.
  DATA fcode TYPE t_fcode.

  fcode-fcode = con_fcode_show_detail.
  APPEND fcode TO fcode_tab.
  fcode-fcode = con_fcode_hide_detail.
  APPEND fcode TO fcode_tab.
ENDFORM.                    " status_no_detail

*&---------------------------------------------------------------------*
*&      Form  data_to_save
*&---------------------------------------------------------------------*
*       Prüfe, ob Daten zu sichern sind. Wenn Anwender nicht sichern
*       möchte => abort = 'X', sonst initial.
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM data_to_save CHANGING abort TYPE xfeld.
  DATA: delete_head_tab TYPE STANDARD TABLE OF jksdprotocolhead,
        delete_item_tab TYPE STANDARD TABLE OF jksdprotocol,
        update_item_tab TYPE STANDARD TABLE OF jksdprotocol,
        answer          TYPE c.

* Rückgabewert initialisieren
  CLEAR abort.

* Geänderte Positionsdaten bestimmen
  PERFORM get_changed_item TABLES update_item_tab[].

* Gelöschte Kopfdaten und Positionsdaten bestimmen
  PERFORM get_deleted_head TABLES delete_head_tab[]
                                  delete_item_tab[].

  IF NOT update_item_tab[] IS INITIAL OR
     NOT delete_item_tab[] IS INITIAL OR
     NOT delete_head_tab[] IS INITIAL.
    PERFORM safety_check CHANGING answer.
    CASE answer.
      WHEN 'J'.
        PERFORM save.
      WHEN 'A'.
        abort = 'X'.
    ENDCASE.
  ENDIF.
ENDFORM.                    " data_to_save

*&---------------------------------------------------------------------*
*&      Form  set_hotspot
*&---------------------------------------------------------------------*
*       Hotspot auf dem Feld field setzen, falls count ungleich initial.
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM set_hotspot  USING    count     TYPE t_overview-count1
                           fieldname TYPE lvc_s_styl-fieldname
                  CHANGING cell_tab  TYPE lvc_t_styl.
  DATA cell TYPE lvc_s_styl.

  CHECK NOT count IS INITIAL.
  cell-fieldname = fieldname.
  cell-style     = cl_gui_alv_grid=>mc_style_hotspot.
  INSERT cell INTO TABLE cell_tab.
ENDFORM.                    " set_hotspot

*&---------------------------------------------------------------------*
*&      Form  mark_line_with_error
*&---------------------------------------------------------------------*
*       Zeile als fehlerhaft markieren
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM mark_line_with_error CHANGING line TYPE t_detail.
  DATA accessibility TYPE abap_bool.

  CALL FUNCTION 'GET_ACCESSIBILITY_MODE'
    IMPORTING
      accessibility     = accessibility
    EXCEPTIONS
      its_not_available = 1
      OTHERS            = 2.

  CHECK accessibility IS INITIAL.
  CONCATENATE 'C' '6' '0' '0' INTO line-color.
ENDFORM.                    " mark_line_with_error

*&---------------------------------------------------------------------*
*&      Form  get_changed_data
*&---------------------------------------------------------------------*
*       Geänderte Werte aus detail_tab in item_tab übernehmen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_changed_data.
  FIELD-SYMBOLS: <item>   TYPE t_jksdprotocol,
                 <detail> TYPE t_detail.

  CHECK NOT protocol_detail IS INITIAL.
  protocol_detail->check_changed_data( ).
* Geänderte Datensätze bestimmen
  LOOP AT detail_tab ASSIGNING <detail>.
    READ TABLE item_tab ASSIGNING <item>
      WITH KEY index = <detail>-index BINARY SEARCH.
    CHECK sy-subrc = 0.
    IF <detail>-annotation <> <item>-annotation OR
       <detail>-solved     <> <item>-solved.
      <item>-annotation = <detail>-annotation.
      <item>-solved     = <detail>-solved.
      <item>-update     = 'U'.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " get_changed_data

*&---------------------------------------------------------------------*
*&      Form  set_number_item_tab
*&---------------------------------------------------------------------*
*       Einträge in der Tabelle item_tab numerieren
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM set_number_item_tab CHANGING item_tab TYPE t_jksdprotocol_tab.
  FIELD-SYMBOLS <item> TYPE t_jksdprotocol.

  LOOP AT item_tab ASSIGNING <item>.
    <item>-index = sy-tabix.
  ENDLOOP.
ENDFORM.                    " set_number_item_tab
