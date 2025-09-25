*----------------------------------------------------------------------*
*   INCLUDE RJKSDDEMANDCHANGE_CLASS
**----------------------------------------------------------------------
*



*----------------------------------------------------------------------
CLASS ism_worklist_list DEFINITION.
*----------------------------------------------------------------------

*----------------------------------------------------------------------
  PUBLIC SECTION.
*----------------------------------------------------------------------
    METHODS:

      constructor
        IMPORTING i_container TYPE scrfname,

      register_refresh,

      execute_refresh,

      check_changed_data,

      add_entries
        IMPORTING i_statustab          TYPE status_tab_type
                  i_phase_display      TYPE xfeld           "TK01022008
                  i_wl_enq_active      TYPE xfeld           "TK01042008
                  i_wl_erschdat_change TYPE xfeld           "TK01042008
                  i_display            TYPE xfeld
                  i_reset_marked_lines TYPE xfeld          "TK16072009 Hinw. 1365757
                  i_reset_sorting      TYPE xfeld               "TK11082009/hint1374477
                  i_lock_error         TYPE locked_tab,

      get_marked_issue
        IMPORTING i_statustab  TYPE status_tab_type
        EXPORTING e_issue      TYPE mara-matnr
                  e_plant      TYPE marc-werks       "TK01042008/hint1158167
                  e_vkorg      TYPE mvke-vkorg       "TK01042008/hint1158167
                  e_vtweg      TYPE mvke-vtweg       "TK01042008/hint1158167
                  e_mark_count TYPE sy-tabix,

      get_marked_issues
        IMPORTING i_statustab  TYPE status_tab_type
        EXPORTING e_issue_tab  TYPE marked_tab
                  e_mark_count TYPE sy-tabix,


      get_changed_entries
        IMPORTING i_statustab      TYPE status_tab_type
                  i_dbtab          TYPE status_tab_type
        EXPORTING e_amara_ueb      TYPE amara_tab
                  e_jptmara_tab    TYPE jptmara_tab
                  e_amarc_ueb      TYPE amarc_tab
                  e_amvke_ueb      TYPE amvke_tab
                  e_amfieldres_tab TYPE amfieldres_tab
                  e_tranc_tab      TYPE tranc_tab
                  e_xno_changes    TYPE xfeld,
*   OK-Code-Verarbeitung für neue Drucktaste(n) in der Toolbar des ALV
      handle_toolbar
                  FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,

      handle_user_command
                  FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm.
*   OK-Code-Verarbeitung für neue Drucktaste(n) in der Toolbar des ALV


**   Menue in Toolbar ------------Anfang-------------------------  "TK08022007
*    if gv_pedex_active = con_angekreuzt.
    METHODS: handle_menu_button
                FOR EVENT menu_button OF cl_gui_alv_grid
      IMPORTING e_object e_ucomm.
*    endif.
**   Menue in Toolbar ------------Ende---------------------------  "TK08022007

*   Text-Anbingung----------------------------------------------"TK01102006
    METHODS:  handle_double_click
                FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING e_row e_column es_row_no .

*    data:  dba_sellist type table of VIMSELLIST initial size 0 .
*    DATA : EXCL_CUA_FUNCT type table of VIMEXCLFUN initial size 0.

    DATA: dba_sellist    TYPE rj_vimsellist_tab,
          excl_cua_funct TYPE rj_vimexclfun_tab.


*   Text-Anbingung----------------------------------------------"TK01102006


    TYPES: BEGIN OF lt_party_type,
             vbeln TYPE vbeln,
             posnr TYPE posnr,
             ewkun TYPE ewkun,
           END OF lt_party_type.
    TYPES: BEGIN OF lt_status_type,
             vbeln TYPE vbeln,
             posnr TYPE posnr,
             issue TYPE ismmatnr_issue,
             icon  TYPE jdeliv_status,
           END OF lt_status_type.
    CONSTANTS: con_structure                  TYPE tabname VALUE 'RJKSDWORKLIST_ALV',
               con_mstav_fname                TYPE fieldname VALUE 'MSTAV',
               con_mstdv_fname                TYPE fieldname VALUE 'MSTDV',
               con_mstae_fname                TYPE fieldname VALUE 'MSTAE',
               con_mstde_fname                TYPE fieldname VALUE 'MSTDE',
               con_isminitshipdate_fname      TYPE fieldname
                                          VALUE 'ISMINITSHIPDATE',
               con_ismcopynr_fname            TYPE fieldname
                                          VALUE 'ISMCOPYNR',
               con_ismpubldate_fname          TYPE fieldname "TK01042008
                                          VALUE 'ISMPUBLDATE', "TK01042008
               con_medprod_maktx_fname        TYPE fieldname
                                          VALUE 'MEDPROD_MAKTX',
               con_medissue_maktx_fname       TYPE fieldname
                                          VALUE 'MEDISSUE_MAKTX',
               con_text_icon_fname            TYPE fieldname "TK01102006
                                          VALUE 'ICON_TEXT', "TK01102006
               con_mvke_vmsta_fname           TYPE fieldname VALUE 'MVKE_VMSTA',
               con_mvke_vmstd_fname           TYPE fieldname VALUE 'MVKE_VMSTD',
               con_mvke_isminitshipdate_fname TYPE fieldname
                              VALUE 'MVKE_ISMINITSHIPDATE',
               con_mvke_ismonsaledate_fname   TYPE fieldname
                              VALUE 'MVKE_ISMONSALEDATE',
               con_mvke_ismoffsaledate_fname  TYPE fieldname
                              VALUE 'MVKE_ISMOFFSALEDATE',
               con_mvke_isminterrupt_fname    TYPE fieldname
                              VALUE 'MVKE_ISMINTERRUPT',
               con_mvke_ismintrupdate_fname   TYPE fieldname
                              VALUE 'MVKE_ISMINTERRUPTDATE',
               con_mvke_ismcolldate_fname     TYPE fieldname
                              VALUE 'MVKE_ISMCOLLDATE',
               con_mvke_ismreturnbegin_fname  TYPE fieldname
                              VALUE 'MVKE_ISMRETURNBEGIN',
               con_mvke_ismreturnend_fname    TYPE fieldname
                              VALUE 'MVKE_ISMRETURNEND',
               con_marc_mmsta_fname           TYPE fieldname VALUE 'MARC_MMSTA',
               con_marc_mmstd_fname           TYPE fieldname VALUE 'MARC_MMSTD',
               con_marc_ismpurchasedate_fname TYPE fieldname
                              VALUE 'MARC_ISMPURCHASEDATE',
               con_marc_ismarrivdatepl_fname  TYPE fieldname
                              VALUE 'MARC_ISMARRIVALDATEPL',
               con_marc_ismarrivdateac_fname  TYPE fieldname
                              VALUE 'MARC_ISMARRIVALDATEAC'.

    DATA: gv_custom_container TYPE REF TO cl_gui_custom_container,
          gv_alv_grid         TYPE REF TO cl_gui_alv_grid,
          gt_outtab           TYPE TABLE OF rjksdworklist_alv,
          gt_fieldcat         TYPE lvc_t_fcat,
          gv_refresh          TYPE xfeld,
          gv_refresh_catalog  TYPE xfeld.

*   optimitisches Sperren -------- Anfang-------------------"TK01042008

    DATA: xmara_input_active TYPE xfeld.                    "TK01042008
    DATA: xmarc_input_active TYPE xfeld.                    "TK01042008
    DATA: xmvke_input_active TYPE xfeld.                    "TK01042008
    DATA: gt_lock_mara TYPE rjp_enq_mara_tab.               "TK01042008
    DATA: gt_lock_marc TYPE rjp_enq_marc_tab.               "TK01042008
    DATA: gt_lock_mvke TYPE rjp_enq_mvke_tab.               "TK01042008
    DATA: gt_locked_mara TYPE rjp_enq_mara_tab.             "TK01042008
    DATA: gt_locked_marc TYPE rjp_enq_marc_tab.             "TK01042008
    DATA: gt_locked_mvke TYPE rjp_enq_mvke_tab.             "TK01042008
    DATA: gt_mara_input_fields TYPE rjp_fieldname_tab.      "TK01042008
    DATA: gt_marc_input_fields TYPE rjp_fieldname_tab.      "TK01042008
    DATA: gt_mvke_input_fields TYPE rjp_fieldname_tab.      "TK01042008

*   optimitisches Sperren -------- Ende---------------------"TK01042008

*   ----------------Anfang-----------------------"TK16072009/hint1365757
*   Zeilen/Markierung merken für Rücksprung aus "Weiter Funktionen'
    DATA: gt_index_rows TYPE lvc_t_row.
    DATA: gs_index_row LIKE LINE OF gt_index_rows.
    DATA: gt_row_no TYPE lvc_t_roid.
*   ---Anfang----explizites Merken des keys markierter Zeilen  "TK19102009
    TYPES: BEGIN OF ls_marked_key,
             issue TYPE matnr,
             werks TYPE werks,
             vkorg TYPE vkorg,
             vtweg TYPE vtweg,
           END OF ls_marked_key.
    TYPES: gt_marked_key_tab TYPE TABLE OF ls_marked_key.
    DATA:  gs_marked_key TYPE ls_marked_key.
    DATA:  gt_marked_key TYPE gt_marked_key_tab.
*   ---Anfang----explizites Merken des keys markierter Zeilen  "TK19102009
*   ----------------Ende-------------------------"TK16072009/hint1365757

*---------Anfang----------------------------------"TK01082009/hint1371256
*   Sicherung der Sortierung, bevor über 'weitere Funktionen' aus der
*   Worklist navigiert wird, damit nach dem Rücksprung genau diese Sortierung
*   wieder hergestellt werden kann.
    DATA: gt_outtab_before_call  TYPE TABLE OF rjksdworklist_alv.
*---------Ende------------------------------------"TK01082009/hint1371256

*----------------------------------------------------------------------
  PROTECTED SECTION.
*----------------------------------------------------------------------
    METHODS:
      handle_changed_cell
                  FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed.


ENDCLASS.                    "ISM_WORKLIST_LIST DEFINITION


*---------------------------------------------------------------------*
*       CLASS ism_worklist_list IMPLEMENTATION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS ism_worklist_list IMPLEMENTATION.

*----------------------------------------------------------------------
*
*----------------------------------------------------------------------
  METHOD constructor.


    DATA: lv_tjy00_xworklistpubldat TYPE xfeld.             "TK01042008

*   container
    CREATE OBJECT gv_custom_container
      EXPORTING
        container_name = i_container.
*   ALV
    CREATE OBJECT gv_alv_grid
      EXPORTING
        i_parent = gv_custom_container.

    SET HANDLER me->handle_toolbar FOR gv_alv_grid.
    SET HANDLER me->handle_user_command FOR gv_alv_grid.
    SET HANDLER me->handle_double_click FOR gv_alv_grid.    "TK10102006

    IF gv_pedex_active = con_angekreuzt.
      SET HANDLER me->handle_menu_button FOR gv_alv_grid.   "TK08022007
    ENDIF.


*   field catalog
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = con_structure
      CHANGING
        ct_fieldcat      = gt_fieldcat.

*   ----- Anfang---------------------------------------"TK22042008
*   Adopt field catalog according to stock interpretation framework of
*   PDEX2
    DATA : lv_appl TYPE jksdsfapplication .
    lv_appl = con_tcode_change.  "generell Change-Transaktionscode
*    if cl_ism_sd_pdex_switch=>get_pdex_2_active( ) is not initial .
*    Methode set_fieldcat muß auch(!) prozessiert werden, wenn PDEX2 nicht
*    aktiv ist, weil in diesem Fall die stock-felder ausgeblendet werden!
    cl_ism_stockfw=>set_fieldcat(
      EXPORTING
        iv_application = lv_appl
        iv_issue_wl    = 'X'
      CHANGING
        ct_fieldcat    = gt_fieldcat ).
*    endif .
*   ----- Ende-----------------------------------------"TK22042008

*   Change field catalog
    DATA: ls_fieldcat TYPE lvc_s_fcat.
    LOOP AT gt_fieldcat INTO ls_fieldcat.
      CASE ls_fieldcat-fieldname.
*        WHEN 'STATE_ICON'.
*          ls_fieldcat-icon = 'X'.
*          ls_fieldcat-outputlen = 4.
*        WHEN 'ISSUE'.
*          ls_fieldcat-no_out = 'X'.
        WHEN 'ISMYEARNR'.
          ls_fieldcat-coltext = 'Pub Year'.
          ls_fieldcat-JUST = 'L'.
          ls_fieldcat-outputlen = 10.
        WHEN 'ZWKBST'.
          ls_fieldcat-coltext = 'Actual ATP qty'.
        WHEN 'MSTAV'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'MSTDV'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'MSTAE'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'MSTDE'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'ISMINITSHIPDATE'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'ISMCOPYNR'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.

*       ---- Anfang------------------------------------------------------"TK01042008
        WHEN 'ISMPUBLDATE'.
          SELECT SINGLE xworklistpubldat FROM tjy00 INTO lv_tjy00_xworklistpubldat.
          IF lv_tjy00_xworklistpubldat = 'X'.
*           TJY00-Einstellung: PUBLDATE soll für Artikel änderbar sein.
*           Hier wird PUBLDATE generell als editierbar eingestellt.
*           Welche Medienausgaben im Laufe der Transaktion dann selektiert werden,
*           ist hier nicht bekannt. Der Construktor wird je Transaktion nur 1x durchaufen.
            ls_fieldcat-edit = 'X'.
            ls_fieldcat-colddictxt = 'M'.
          ENDIF.
*       ---- Ende--------------------------------------------------------"TK01042008


        WHEN 'MEDPROD_MAKTX'.
          ls_fieldcat-edit = ' '.
          ls_fieldcat-colddictxt = 'L'.
          ls_fieldcat-outputlen = 18.
        WHEN 'MEDISSUE_MAKTX'.
          ls_fieldcat-edit = ' '.
          ls_fieldcat-colddictxt = 'L'.
          ls_fieldcat-outputlen = 18.
        WHEN 'TEXT_ICON'.                                   "TK01102006
          ls_fieldcat-icon = 'X'.                           "TK01102006
          ls_fieldcat-outputlen = 4.                        "TK01102006
          IF gv_pedex_active IS INITIAL.
*           Spalte für Textikone inaktivieren
            ls_fieldcat-no_out = con_angekreuzt.            "TK01102006
          ENDIF.


        WHEN 'MARC_MMSTA'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'MARC_MMSTD'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'MARC_ISMPURCHASEDATE'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'MARC_ISMARRIVALDATEPL'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'MARC_ISMARRIVALDATEAC'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.


        WHEN 'MVKE_VMSTA'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'MVKE_VMSTD'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'MVKE_ISMINITSHIPDATE'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'MVKE_ISMONSALEDATE'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'MVKE_ISMOFFSALEDATE'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'MVKE_ISMINTERRUPT'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
          ls_fieldcat-checkbox = 'X'.
        WHEN 'MVKE_ISMINTERRUPTDATE'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'MVKE_ISMCOLLDATE'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
          ls_fieldcat-no_out = 'X'.                         "TK08082005
        WHEN 'MVKE_ISMRETURNBEGIN'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.
        WHEN 'MVKE_ISMRETURNEND'.
          ls_fieldcat-edit = 'X'.
          ls_fieldcat-colddictxt = 'M'.

*      ------------------Anfang---------------------------"TK08012013/Hinw.1807258
        WHEN 'MATNR_SAVE'.
          ls_fieldcat-no_out = con_angekreuzt.            "nicht sichtbar
        WHEN 'ISMREFMDPROD_SAVE'.
          ls_fieldcat-no_out = con_angekreuzt.            "nicht sichtbar
*      ------------------Ende-----------------------------"TK08012013/Hinw.1807258

        WHEN OTHERS.
*         Check if BADI field-------------------------"TK01102006
          CLEAR gs_badi_field.
          READ TABLE gt_badi_fields INTO gs_badi_field
             WITH KEY fieldname = ls_fieldcat-fieldname.
          IF sy-subrc = 0.
            IF gs_badi_field-xinput = 'X'.
              ls_fieldcat-edit = 'X'.
              ls_fieldcat-colddictxt = 'M'.
            ENDIF.
          ENDIF.

*---------Anfang----------------------------------"TK01082009/hint1371256
*         break kast.  "to check !
*         if ls_fieldcat-fieldname cs 'ICON' or
*            ls_fieldcat-fieldname cs 'TRAFFIC' .
*            ls_fieldcat-icon = 'X'.
*            ls_fieldcat-outputlen = 4.
*         endif.
*---------Ende------------------------------------"TK01082009/hint1371256

*         Check if BADI field-------------------------"TK01102006

      ENDCASE.
      MODIFY gt_fieldcat FROM ls_fieldcat.
    ENDLOOP.
*


*   ---Anfang ----------------------------------------"TK01022008
    DATA: lv_fieldname_mara TYPE fieldname VALUE 'MARA-'.
    DATA: lv_fieldname_marc TYPE fieldname VALUE 'MARC_'.
    DATA: lv_fieldname_mvke TYPE fieldname VALUE 'MVKE_'.

*   Abhängig vom Segmentlevel werden Felder aus dem Feldkatalog genommen
    CASE gv_segment_level.
      WHEN con_level_mara.
        LOOP AT gt_fieldcat INTO ls_fieldcat.
          IF ls_fieldcat-fieldname(5) = 'MARC_'  OR
            ls_fieldcat-fieldname(5) = 'MVKE_'  .
*           alle Felder nicht relevanter Segmente ausblenden
            DELETE gt_fieldcat.
          ELSE.
*           einzelne Felder relevanter Segmente ausblenden/eingabe wegnehmen
            lv_fieldname_mara+5 = ls_fieldcat-fieldname.  "MARA- ergänzen
*           FIELD_STATUS:
*           - einzelne Felder relevanter Segmente AUSBLENDEN(!)
            LOOP AT gt_tjksd13f INTO gs_tjksd13f
              WHERE wl_tcode_change = con_tcode_change
                AND wl_fieldname    = lv_fieldname_mara
                AND wl_fieldstatus  = con_field_status_invisible.
              DELETE gt_fieldcat.
              EXIT. "=> ENDLOOP
            ENDLOOP. " at gt_tjksd13f into gt_tjksd13f
            IF sy-subrc = 0.
              CONTINUE.   "=> next GT_FIELDCAT
            ENDIF.
*           FIELD_STATUS:
*           - Eingabebereitschaft einzelne Felder rel. Segmente wegnehmen
            IF ls_fieldcat-edit = 'X'.
              LOOP AT gt_tjksd13f INTO gs_tjksd13f
                WHERE wl_tcode_change = con_tcode_change
                  AND wl_fieldname    = lv_fieldname_mara
                  AND wl_fieldstatus  = con_field_status_display.
                CLEAR ls_fieldcat-edit.
                MODIFY gt_fieldcat FROM ls_fieldcat.
                EXIT.  "=> ENDLOOP
              ENDLOOP. " at gt_tjksd13f into gt_tjksd13f
            ENDIF. " LS_FIELDCAT-EDIT = 'X'.
          ENDIF.
        ENDLOOP.
      WHEN con_level_mara_marc.
        LOOP AT gt_fieldcat INTO ls_fieldcat.
          IF ls_fieldcat-fieldname(5) = 'MVKE_'.
*           alle Felder nicht relevanter Segmente ausblenden
            DELETE gt_fieldcat.
          ELSE.
*           einzelne Felder relevanter Segmente ausblenden/eingabe wegnehmen
            lv_fieldname_mara+5 = ls_fieldcat-fieldname.  "MARA- ergänzen
*           lv_fieldname_marc+5 = ls_fieldcat-fieldname.  "MARC- ergänzen   "TK07052013/Hinw.1855818
            lv_fieldname_marc   = ls_fieldcat-fieldname.  "MARC- ergänzen   "TK07052013/Hinw.1855818
            lv_fieldname_marc+4(1) = '-'.                 "MARC- ergänzen   "TK07052013/Hinw.1855818/1876988
*           FIELD_STATUS:
*           - einzelne Felder relevanter Segmente AUSBLENDEN(!)
            LOOP AT gt_tjksd13f INTO gs_tjksd13f
              WHERE wl_tcode_change = con_tcode_change
                AND (  wl_fieldname    = lv_fieldname_mara   OR
                       wl_fieldname    = lv_fieldname_marc      )
                AND wl_fieldstatus  = con_field_status_invisible.
              DELETE gt_fieldcat.
              EXIT. "=> ENDLOOP
            ENDLOOP. " at gt_tjksd13f into gt_tjksd13f
            IF sy-subrc = 0.
              CONTINUE.   "=> next GT_FIELDCAT
            ENDIF.
*           FIELD_STATUS:
*           - Eingabebereitschaft einzelne Felder rel. Segmente wegnehmen
            IF ls_fieldcat-edit = 'X'.
              LOOP AT gt_tjksd13f INTO gs_tjksd13f
                WHERE wl_tcode_change = con_tcode_change
                  AND (  wl_fieldname    = lv_fieldname_mara  OR
                         wl_fieldname    = lv_fieldname_marc )
                  AND wl_fieldstatus  = con_field_status_display.
                CLEAR ls_fieldcat-edit.
                MODIFY gt_fieldcat FROM ls_fieldcat.
                EXIT.  "=> ENDLOOP
              ENDLOOP. " at gt_tjksd13f into gt_tjksd13f
            ENDIF. " LS_FIELDCAT-EDIT = 'X'.
          ENDIF.
        ENDLOOP.
      WHEN con_level_mara_mvke.
        LOOP AT gt_fieldcat INTO ls_fieldcat.
          IF ls_fieldcat-fieldname(5) = 'MARC_'.
*           alle Felder nicht relevanter Segmente ausblenden
            DELETE gt_fieldcat.
          ELSE.
*           einzelne Felder relevanter Segmente ausblenden/eingabe wegnehmen
            lv_fieldname_mara+5 = ls_fieldcat-fieldname.  "MARA- ergänzen
*           lv_fieldname_mvke+5 = ls_fieldcat-fieldname.  "MVKE- ergänzen   "TK07052013/Hinw.1855818
            lv_fieldname_mvke   = ls_fieldcat-fieldname.  "MVKE- ergänzen   "TK07052013/Hinw.1855818
            lv_fieldname_mvke+4(1) = '-'.                 "MVKE- ergänzen   "TK07052013/Hinw.1855818/1876988
*           FIELD_STATUS:
*           - einzelne Felder relevanter Segmente AUSBLENDEN(!)
            LOOP AT gt_tjksd13f INTO gs_tjksd13f
              WHERE wl_tcode_change = con_tcode_change
                AND (  wl_fieldname    = lv_fieldname_mara  OR
                       wl_fieldname    = lv_fieldname_mvke      )
                AND wl_fieldstatus  = con_field_status_invisible.
              DELETE gt_fieldcat.
              EXIT. "=> ENDLOOP
            ENDLOOP. " at gt_tjksd13f into gt_tjksd13f
            IF sy-subrc = 0.
              CONTINUE.   "=> next GT_FIELDCAT
            ENDIF.
*           FIELD_STATUS:
*           - Eingabebereitschaft einzelne Felder rel. Segmente wegnehmen
            IF ls_fieldcat-edit = 'X'.
              LOOP AT gt_tjksd13f INTO gs_tjksd13f
                WHERE wl_tcode_change = con_tcode_change
                  AND (  wl_fieldname    = lv_fieldname_mara  OR
                         wl_fieldname    = lv_fieldname_mvke      )
                  AND wl_fieldstatus  = con_field_status_display.
                CLEAR ls_fieldcat-edit.
                MODIFY gt_fieldcat FROM ls_fieldcat.
                EXIT.  "=> ENDLOOP
              ENDLOOP. " at gt_tjksd13f into gt_tjksd13f
            ENDIF. " LS_FIELDCAT-EDIT = 'X'.
          ENDIF.
        ENDLOOP.
*     ------Anfang--------------------------------------------------"TK07052013/1876988
      WHEN con_level_mara_marc_mvke.
        LOOP AT gt_fieldcat INTO ls_fieldcat.
*         Es werden zwar keine ganzen Segmente ausgeblenet, aber einzele Felder!
*         einzelne Felder relevanter Segmente ausblenden/eingabe wegnehmen
          lv_fieldname_mara+5 = ls_fieldcat-fieldname.  "MARA- ergänzen
          lv_fieldname_marc   = ls_fieldcat-fieldname.  "MARC- ergänzen
          lv_fieldname_marc+4(1) = '-'.                 "MARC- ergänzen
          lv_fieldname_mvke   = ls_fieldcat-fieldname.  "MVKE- ergänzen
          lv_fieldname_mvke+4(1) = '-'.                 "MVKE- ergänzen
*         FIELD_STATUS:
*         - einzelne Felder relevanter Segmente AUSBLENDEN(!)
          LOOP AT gt_tjksd13f INTO gs_tjksd13f
            WHERE wl_tcode_change = con_tcode_change
              AND (  wl_fieldname    = lv_fieldname_mara   OR
                     wl_fieldname    = lv_fieldname_marc   OR
                     wl_fieldname    = lv_fieldname_mvke       )
              AND wl_fieldstatus  = con_field_status_invisible.
            DELETE gt_fieldcat.
            EXIT. "=> ENDLOOP
          ENDLOOP. " at gt_tjksd13f into gt_tjksd13f
          IF sy-subrc = 0.
            CONTINUE.   "=> next GT_FIELDCAT
          ENDIF.
*         FIELD_STATUS:
*         - Eingabebereitschaft einzelne Felder rel. Segmente wegnehmen
          IF ls_fieldcat-edit = 'X'.
            LOOP AT gt_tjksd13f INTO gs_tjksd13f
              WHERE wl_tcode_change = con_tcode_change
                AND (  wl_fieldname    = lv_fieldname_mara  OR
                       wl_fieldname    = lv_fieldname_marc  OR
                       wl_fieldname    = lv_fieldname_mvke     )
                AND wl_fieldstatus  = con_field_status_display.
              CLEAR ls_fieldcat-edit.
              MODIFY gt_fieldcat FROM ls_fieldcat.
              EXIT.  "=> ENDLOOP
            ENDLOOP. " at gt_tjksd13f into gt_tjksd13f
          ENDIF. " LS_FIELDCAT-EDIT = 'X'.
        ENDLOOP.
*     ------Ende----------------------------------------------------"TK07052013/1876988
    ENDCASE.
*   ---Ende-------------------------------------------"TK01022008


**   Initially, change the field catalog to hide phase model fields
*    CALL METHOD me->change_fieldcat
*         EXPORTING
*           i_phasemdl = ' '.
*
*   Set ALV details
    DATA: lt_exclude TYPE ui_functions.
    CLEAR lt_exclude[].
    APPEND gv_alv_grid->mc_fc_check             TO lt_exclude.
    APPEND gv_alv_grid->mc_fc_refresh           TO lt_exclude.
    APPEND gv_alv_grid->mc_fc_loc_copy          TO lt_exclude.
    APPEND gv_alv_grid->mc_fc_loc_copy_row      TO lt_exclude.
    APPEND gv_alv_grid->mc_fc_loc_cut           TO lt_exclude.
    APPEND gv_alv_grid->mc_fc_loc_delete_row    TO lt_exclude.
    APPEND gv_alv_grid->mc_fc_loc_append_row    TO lt_exclude.
    APPEND gv_alv_grid->mc_fc_loc_insert_row    TO lt_exclude.
    APPEND gv_alv_grid->mc_fc_loc_move_row      TO lt_exclude.
    APPEND gv_alv_grid->mc_fc_loc_paste         TO lt_exclude.
    APPEND gv_alv_grid->mc_fc_loc_paste_new_row TO lt_exclude.
    APPEND gv_alv_grid->mc_fc_loc_undo          TO lt_exclude.
    IF gv_segment_level <> con_level_mara  AND   "TK01082009/hint1371256
       gv_segment_level <> space .               "TK01082009/hint1371256
*   Sortierung inaktiviert                                   "TK16092004
      APPEND gv_alv_grid->mc_fc_sort           TO lt_exclude. "TK16092004
      APPEND gv_alv_grid->mc_fc_sort_asc       TO lt_exclude. "TK16092004
      APPEND gv_alv_grid->mc_fc_sort_dsc       TO lt_exclude. "TK16092004
    ENDIF.                                       "TK01082009/hint1371256
*   Zeilen verschieben mit Drag&Drop inaktiviert             "TK16122004
    APPEND gv_alv_grid->mc_lystyle_drag_drop_rows           "TK16122004
                                        TO lt_exclude.      "TK16122004
    APPEND gv_alv_grid->mc_ly_drag_drop_rows                "TK16122004
                                        TO lt_exclude.      "TK16122004

    DATA: ls_layout TYPE lvc_s_layo.
    DATA: ls_layout2 TYPE disvariant.   " for "save layout"
    ls_layout-sel_mode = 'B'.
    ls_layout-stylefname = 'COLTAB'.

*   Drag&Drop der Zeilen unterbinden                         "TK22032005
    ls_layout-no_rowins  = 'X'.                             "TK22032005
    ls_layout-no_rowmove  = 'X'.                            "TK22032005

*   Acc: Titel im ALV ergänzt
    ls_layout-grid_title = text-103.
    ls_layout-smalltitle = 'X'.

    ls_layout2-report = sy-repid.       " for "Save Layout"

*   Layout transaktionsvariantenspezifisch speichern:
    CONCATENATE sy-cprog sy-tcode INTO ls_layout2-report.   "TK26052008

    CALL METHOD gv_alv_grid->set_table_for_first_display
      EXPORTING
        is_layout            = ls_layout
        it_toolbar_excluding = lt_exclude
        i_save               = 'A'        "Save Layout
        is_variant           = ls_layout2 "Save Layout
      CHANGING
        it_fieldcatalog      = gt_fieldcat
        it_outtab            = gt_outtab.

*   Register "ENTER" event
    CALL METHOD gv_alv_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_enter.

*   Set handler for the "ENTER" event just registered
    SET HANDLER me->handle_changed_cell FOR gv_alv_grid.


  ENDMETHOD.                    "CONSTRUCTOR


*----------------------------------------------------------------------
* Note to refresh the list at next PBO event
*----------------------------------------------------------------------
  METHOD register_refresh.
    gv_refresh = 'X'.
  ENDMETHOD.                    "REGISTER_REFRESH

*----------------------------------------------------------------------
* Refresh the list
*----------------------------------------------------------------------
  METHOD execute_refresh.

    DATA: ls_stable       TYPE lvc_s_stbl.                  "TK01102006

    ls_stable-row  = 'X'.                                   "TK01102006
    ls_stable-col  = 'X'.                                   "TK01102006

    IF gv_refresh = 'X'.
      CALL METHOD gv_alv_grid->refresh_table_display
        EXPORTING                                           "TK01102006
          is_stable = ls_stable                        "TK01102006
*         I_SOFT_REFRESH = 'X'                              "TK08112009/hint1394055
        EXCEPTIONS
          finished  = 1
          OTHERS    = 2.
      IF sy-subrc = 0.
        CLEAR gv_refresh.
      ENDIF.
    ENDIF.
  ENDMETHOD.                    "EXECUTE_REFRESH



*----------------------------------------------------------------------
* Check if data was changed (automatically raises "ENTER" event)
*----------------------------------------------------------------------
  METHOD check_changed_data.
    DATA: lv_valid   TYPE xfeld,
          lv_refresh TYPE xfeld.
    CALL METHOD gv_alv_grid->check_changed_data
      IMPORTING
        e_valid   = lv_valid
      CHANGING
        c_refresh = lv_refresh.            " Hinweis 360938
  ENDMETHOD.                    "CHECK_CHANGED_DATA


*----------------------------------------------------------------------
* Check and Get one marked issue
*----------------------------------------------------------------------
  METHOD get_marked_issue.
*
    DATA: lt_index_rows TYPE lvc_t_row.
    DATA: ls_index_row LIKE LINE OF lt_index_rows.
    DATA: lt_row_no TYPE lvc_t_roid.
    DATA: ls_outtab TYPE rjksdworklist_alv.
    DATA: ls_statustab LIKE LINE OF i_statustab.
*
    CLEAR e_issue.
    CLEAR e_mark_count.
*
*   Check: Read marked lines
    CALL METHOD gv_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows
        et_row_no     = lt_row_no.
*
    DESCRIBE TABLE lt_index_rows LINES e_mark_count.
*   Check: One row must be marked
    IF e_mark_count <> 1.
      EXIT.
    ENDIF.
*   One line is marked
    READ TABLE lt_index_rows INTO ls_index_row INDEX 1.

*   ------Anfang---------------------------"TK01082009/hint1371256
*   READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSTAB
*             INDEX LS_INDEX_ROW-INDEX.
*   E_ISSUE = LS_STATUSTAB-MATNR.
    READ TABLE gt_outtab INTO ls_outtab
              INDEX ls_index_row-index.

*   e_issue = ls_outtab-matnr.             "TK23112015/hint2247913
    e_issue = ls_outtab-matnr_save.        "TK23112015/hint2247913

*   ------Ende-----------------------------"TK01082009/hint1371256

*   --- Anfang------------------------------  "TK01042008/hint1158167
*   E_plant = LS_STATUSTAB-MARC_WERKS.        "TK19102009/hint1397291
*   E_vkorg = LS_STATUSTAB-MVKE_vkorg.        "TK19102009/hint1397291
*   E_vtweg = LS_STATUSTAB-MVKE_vtweg.        "TK19102009/hint1397291
    e_plant = ls_outtab-marc_werks.           "TK19102009/hint1397291
    e_vkorg = ls_outtab-mvke_vkorg.           "TK19102009/hint1397291
    e_vtweg = ls_outtab-mvke_vtweg.           "TK19102009/hint1397291
*   --- Ende    ----------------------------  "TK01042008/hint1158167

*   --- Anfang------------------------------  "TK16072009/hint1365757
    gt_index_rows = lt_index_rows.
    gt_row_no     = lt_row_no.

*   ---Anfang----explizites Merken des keys markierter Zeilen  "TK19102009

*   gs_marked_key-issue = ls_outtab-matnr.                     "TK23112015/hint2247913
    gs_marked_key-issue = ls_outtab-matnr_save.                "TK23112015/hint2247913

    gs_marked_key-werks = ls_outtab-marc_werks.
    gs_marked_key-vkorg = ls_outtab-mvke_vkorg.
    gs_marked_key-vtweg = ls_outtab-mvke_vtweg.
    APPEND gs_marked_key TO gt_marked_key.
*   ---Anfang----explizites Merken des keys markierter Zeilen  "TK19102009

*   --- Ende    ----------------------------  "TK16072009/hint1365757

*
  ENDMETHOD.                    "GET_MARKED_ISSUE

*----------------------------------------------------------------------
* Get all marked issues
*----------------------------------------------------------------------
  METHOD get_marked_issues.
*
    DATA: lt_index_rows TYPE lvc_t_row.
    DATA: ls_index_row LIKE LINE OF lt_index_rows.
    DATA: lt_row_no TYPE lvc_t_roid.
    DATA: ls_outtab TYPE rjksdworklist_alv.
    DATA: ls_statustab LIKE LINE OF i_statustab.
    DATA: ls_issue LIKE LINE OF e_issue_tab.
*
    CLEAR e_issue_tab. REFRESH e_issue_tab.
    CLEAR e_mark_count.
*
*   Check: Read marked lines
    CALL METHOD gv_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows
        et_row_no     = lt_row_no.
*
    DESCRIBE TABLE lt_index_rows LINES e_mark_count.
*   Check: Is any issue marked
    IF e_mark_count = 0.
      EXIT.
    ENDIF.
*   One ore more lines are marked
    LOOP AT lt_index_rows INTO ls_index_row.

*   ------Anfang---------------------------"TK01082009/hint1371256
*     READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSTAB
*               INDEX LS_INDEX_ROW-INDEX.
*     LS_ISSUE = LS_STATUSTAB-MATNR.
      READ TABLE gt_outtab INTO ls_outtab
                INDEX ls_index_row-index.

*     ls_issue = ls_outtab-matnr.          "TK23112015/hint2247913
      ls_issue = ls_outtab-matnr_save.     "TK23112015/hint2247913

*   ------Ende-----------------------------"TK01082009/hint1371256

      APPEND ls_issue TO e_issue_tab.
    ENDLOOP.
*
    SORT e_issue_tab.
    DELETE ADJACENT DUPLICATES FROM e_issue_tab.
    DESCRIBE TABLE e_issue_tab LINES e_mark_count.
*
*   --- Anfang------------------------------  "TK16072009/hint1365757
    gt_index_rows = lt_index_rows.
    gt_row_no     = lt_row_no.
*   --- Ende    ----------------------------  "TK16072009/hint1365757

  ENDMETHOD.                    "GET_MARKED_ISSUES
*----------------------------------------------------------------------
* Add entries to the list
*----------------------------------------------------------------------
  METHOD add_entries.

    DATA: ls_statustab  LIKE LINE OF i_statustab,
          ls_outtab     LIKE LINE OF gt_outtab,
          ls_lock_error LIKE LINE OF i_lock_error.
    DATA: xmatnr_locked TYPE xfeld.
    DATA: ls_fieldcat TYPE lvc_s_fcat.                      "TK01022008

    CLEAR: gt_outtab[], ls_outtab.

*   ------------Anfang--------------------------"TK11082009/hint1374477
    IF i_reset_sorting = 'X'.
      CLEAR: gt_outtab_before_call.
    ENDIF.
*   ------------Ende----------------------------"TK11082009/hint1374477

*   --- Anfang------------------------------  "TK16072009/hint1365757
    IF i_reset_marked_lines = 'X'.
*     Bei neuer Selektion muß alte Markierung aufgehoben werden.
      CLEAR gt_index_rows. REFRESH gt_index_rows.
      CLEAR gt_row_no.     REFRESH gt_row_no.

*     -Anfang----explizites Merken des keys markierter Zeilen  "TK19102009
      CLEAR gt_marked_key. REFRESH gt_marked_key.
*     -Ende------explizites Merken des keys markierter Zeilen  "TK19102009

    ENDIF.
*   --- Ende    ----------------------------  "TK16072009/hint1365757

*   --- Anfang-Phasenlayout-----------------------------------"TK01022008
*   Feldcatalog wird jedesmal initialisiert, d.h. ev. ausgeblendete Felder
*   sind zunächst wieder aktiv und werden am Ende der Methode abhängig
*   vom Phasenlayout oder "Normal"-Layout ausgeblendet.
    LOOP AT gt_fieldcat INTO ls_fieldcat.
      IF ls_fieldcat-tech        = con_angekreuzt.
        CLEAR ls_fieldcat-tech.
        MODIFY gt_fieldcat FROM ls_fieldcat.
      ENDIF.
    ENDLOOP. " AT GT_FIELDCAT INTO LS_FIELDCAT.
*   --- Ende---Phasenlayout-----------------------------------"TK01022008

*   Copy the data to the ALV output table
    DATA: ls_coltab LIKE LINE OF ls_outtab-coltab.
    LOOP AT i_statustab INTO ls_statustab.
      MOVE-CORRESPONDING ls_statustab TO ls_outtab.
      IF i_display IS INITIAL.  "CHANGE-Mode
        CLEAR xmatnr_locked.
        READ TABLE i_lock_error INTO ls_lock_error
                            WITH KEY matnr = ls_statustab-matnr
                            BINARY SEARCH.
        IF sy-subrc = 0.
          xmatnr_locked = con_angekreuzt.
        ENDIF.
      ENDIF.
      CLEAR ls_coltab. REFRESH ls_outtab-coltab.
*     Screen-Modif
*
*     MARA-Statusfields
      IF ls_statustab-xfirst_issue_line IS INITIAL.
*       MARA-Statusfields (except first line) not editable
        CLEAR: ls_outtab-coltab[].
*       MSTAV
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_mstav_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*       MSTDV
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_mstdv_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*       MSTAE
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_mstae_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*       MSTDE
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_mstde_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*       ISMINITSHIPDATE
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_isminitshipdate_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*       ISMCOPYNR
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_ismcopynr_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.

*       PUBLDATE--------------------------------Anfang----------------"TK01042008
*       ISMPUBLDATE
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_ismpubldate_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*       PUBLDATE--------------------------------Ende------------------"TK01042008


*       MEDPROD_MAKTX
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_medprod_maktx_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*       MEDISSUE_MAKTX
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_medissue_maktx_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*       TEXT_ICON  ---------------- Anfang----------------------------"TK01102006
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_text_icon_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*       TEXT_ICON  ---------------- Ende -----------------------------"TK01102006

*       ev. neu BADI Felder auf MARA/JPTMARA-Ebene------------------- "TK10102006
        FIELD-SYMBOLS: <value> TYPE any.
        DATA: ls_outtab_strucname(100) VALUE 'LS_OUTTAB-',
              ls_outtab_fieldname(100).
*        data: lv_new_value(100).    "setzuff  welcher Typ hier ???????

        LOOP AT gt_badi_fields INTO gs_badi_field.
          IF gs_badi_field-fieldname(5) <> 'MVKE_'    AND
            gs_badi_field-fieldname(5)  <> 'MARC_' .
*             gs_badi_field-xinput       =  'X'.  clear AUCH für Ausgabefelder
            CLEAR ls_coltab.
            ls_coltab-fieldname = gs_badi_field-fieldname.
            ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
            INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*           clear MARA/JPTMARA-Attribute
            CONCATENATE ls_outtab_strucname gs_badi_field-fieldname INTO ls_outtab_fieldname.
            ASSIGN (ls_outtab_fieldname) TO <value>.
            CLEAR <value>.  "(Typgerechter initialwert????? setzuff)
          ENDIF.
        ENDLOOP.
*       ev. neu BADI Felder auf MARA/JPTMARA-Ebene------------------- "TK10102006

        ls_outtab-ismrefmdprod_save = ls_outtab-ismrefmdprod.         "TK08012013/Hinw.1807258
        ls_outtab-matnr_save        = ls_outtab-matnr.                "TK08012013/Hinw.1807258

*       Clear MARA attributes
        CLEAR ls_outtab-ismrefmdprod.
        CLEAR ls_outtab-matnr.
        CLEAR ls_outtab-ismpubldate.
        CLEAR ls_outtab-mstav.
        CLEAR ls_outtab-mstdv.
        CLEAR ls_outtab-mstae.
        CLEAR ls_outtab-mstde.
        CLEAR ls_outtab-isminitshipdate.
        CLEAR ls_outtab-ismcopynr.
        CLEAR ls_outtab-medprod_maktx.
        CLEAR ls_outtab-medissue_maktx.
        CLEAR ls_outtab-text_icon.                          "TK01102006

      ELSE.
*       First MARA line

        ls_outtab-ismrefmdprod_save = ls_outtab-ismrefmdprod.  "TK08012013/Hinw.1807258
        ls_outtab-matnr_save        = ls_outtab-matnr.         "TK08012013/Hinw.1807258

*       PUBLDATE--------------------------------Anfang----------------"TK01042008
        IF i_wl_erschdat_change  = space . "Erschdat nicht änderbar
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_ismpubldate_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled.
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        ENDIF. " I_DISPLAY
*       PUBLDATE--------------------------------Ende------------------"TK01042008

        IF i_display = con_angekreuzt OR
           xmatnr_locked = con_angekreuzt   OR
           ls_statustab-xissue_is_duplicate  = con_angekreuzt.
*         MARA-Statusfields in DISPLAY-MODE not editable
*         MSTAV
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_mstav_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*         MSTDV
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_mstdv_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*         MSTAE
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_mstae_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*         MSTDE
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_mstde_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*         ISMINITSHIPDATE
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_isminitshipdate_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*         ISMCOPYNR
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_ismcopynr_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.

**         PUBLDATE--------------------------------Anfang----------------"TK01042008
**         ISMPUBLDATE
*          CLEAR LS_COLTAB.
*          LS_COLTAB-FIELDNAME = CON_ISMPUBLDATE_FNAME.
*          LS_COLTAB-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED .
*          INSERT LS_COLTAB INTO TABLE LS_OUTTAB-COLTAB.
**         PUBLDATE--------------------------------Ende------------------"TK01042008

*         MEDPROD_MAKTX
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_medprod_maktx_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*         MEDISSUE_MAKTX
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_medissue_maktx_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*         TEXT_ICON  ---------------- Anfang----------------------------"TK01102006
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_text_icon_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
*         TEXT_ICON  ---------------- Ende -----------------------------"TK01102006

*         ev. neu BADI Felder auf MARA/JPTMARA-Ebene------------------- "TK10102006
          LOOP AT gt_badi_fields INTO gs_badi_field.
            IF gs_badi_field-fieldname(5) <> 'MVKE_'    AND
              gs_badi_field-fieldname(5)  <> 'MARC_'    AND
               gs_badi_field-xinput       =  'X'.
              CLEAR ls_coltab.
              ls_coltab-fieldname = gs_badi_field-fieldname.
              ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
              INSERT ls_coltab INTO TABLE ls_outtab-coltab.
            ENDIF.
          ENDLOOP.
*         ev. neu BADI Felder auf MARA/JPTMARA-Ebene------------------- "TK10102006

        ENDIF.
      ENDIF.
*
*     MVKE-Status
      IF ls_statustab-mvke_vkorg IS INITIAL.
*       MVKE-Status not editable if MVKE-Segment doesnt exist
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_mvke_vmsta_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_mvke_vmstd_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_mvke_isminitshipdate_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_mvke_ismonsaledate_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_mvke_ismoffsaledate_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_mvke_isminterrupt_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_mvke_ismintrupdate_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_mvke_ismcolldate_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_mvke_ismreturnbegin_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_mvke_ismreturnend_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        CLEAR ls_coltab.

*       ev. neu BADI Felder auf MVKE-Ebene     ------------- "TK10102006
        LOOP AT gt_badi_fields INTO gs_badi_field.
          IF gs_badi_field-fieldname(5) = 'MVKE_'    AND
             gs_badi_field-xinput       = 'X'.
            CLEAR ls_coltab.
            ls_coltab-fieldname = gs_badi_field-fieldname.
            ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
            INSERT ls_coltab INTO TABLE ls_outtab-coltab.
          ENDIF.
        ENDLOOP.
*       ev. neu BADI Felder auf MVKE-Ebene     ------------- "TK10102006

*       --- Anfang Phasenlayout------------------------------"TK01022008
        IF NOT i_phase_display IS INITIAL                    AND
          ls_statustab-xissue_is_duplicate  = con_angekreuzt.
*         Es handelt sich um das Layout einer Phasenzeile:
*         clear alle Nicht-Phasen-Attribute (clear ist zwingende notwendig,
*         da diese Werte z.T. auf erster MARA-Zeile änderbar sind!)
          CLEAR ls_outtab-mvke_vmsta.
          CLEAR ls_outtab-mvke_vmstd.
          CLEAR ls_outtab-mvke_isminitshipdate.
          CLEAR ls_outtab-mvke_ismonsaledate.
          CLEAR ls_outtab-mvke_ismoffsaledate.
          CLEAR ls_outtab-mvke_isminterrupt.
          CLEAR ls_outtab-mvke_isminterruptdate.
          CLEAR ls_outtab-mvke_ismreturnbegin.
          CLEAR ls_outtab-mvke_ismreturnend.
        ENDIF.
*       --- Ende---Phasenlayout------------------------------"TK01022008

      ELSE.
        IF i_display = con_angekreuzt     OR
           xmatnr_locked = con_angekreuzt  OR
           ls_statustab-xissue_is_duplicate  = con_angekreuzt.
*         MVKE-Statusfields in DISPLAY-MODE not editable
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_mvke_vmsta_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_mvke_vmstd_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_mvke_isminitshipdate_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_mvke_ismonsaledate_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_mvke_ismoffsaledate_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.

          CLEAR ls_coltab.                                  "TK01102006
          ls_coltab-fieldname = con_mvke_isminterrupt_fname. "TK01102006
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled . "TK01102006
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.     "TK01102006

          CLEAR ls_coltab.
          ls_coltab-fieldname = con_mvke_ismintrupdate_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_mvke_ismcolldate_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_mvke_ismreturnbegin_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_mvke_ismreturnend_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.

*         ev. neu BADI Felder auf MVKE-Ebene--------------"TK01102006
          LOOP AT gt_badi_fields INTO gs_badi_field.
            IF gs_badi_field-fieldname(5) = 'MVKE_'    AND
               gs_badi_field-xinput       = 'X'.
              CLEAR ls_coltab.
              ls_coltab-fieldname = gs_badi_field-fieldname.
              ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
              INSERT ls_coltab INTO TABLE ls_outtab-coltab.
            ENDIF.
          ENDLOOP.
*         ev. neu BADI Felder auf MVKE-Ebene--------------"TK01102006

*         --- Anfang Phasenlayout------------------------------"TK01022008
          IF NOT i_phase_display IS INITIAL                    AND
            ls_statustab-xissue_is_duplicate  = con_angekreuzt.
*           Es handelt sich um das Layout einer Phasenzeile:
*           clear alle Nicht-Phasen-Attribute (clear ist zwingende notwendig,
*           da diese Werte z.T. auf erster MARA-Zeile änderbar sind!)
            CLEAR ls_outtab-mvke_vmsta.
            CLEAR ls_outtab-mvke_vmstd.
            CLEAR ls_outtab-mvke_isminitshipdate.
            CLEAR ls_outtab-mvke_ismonsaledate.
            CLEAR ls_outtab-mvke_ismoffsaledate.
            CLEAR ls_outtab-mvke_isminterrupt.
            CLEAR ls_outtab-mvke_isminterruptdate.
            CLEAR ls_outtab-mvke_ismreturnbegin.
            CLEAR ls_outtab-mvke_ismreturnend.
          ENDIF.
*         --- Ende---Phasenlayout------------------------------"TK01022008

        ENDIF.
      ENDIF.

*
*     MARC-Status
      IF ls_statustab-marc_werks IS INITIAL.
*       MARC-Status not editable if MARC-Segment doesnt exist
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_marc_mmsta_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_marc_mmstd_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        CLEAR ls_coltab.
        ls_coltab-fieldname = con_marc_ismpurchasedate_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        ls_coltab-fieldname = con_marc_ismarrivdatepl_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.
        ls_coltab-fieldname = con_marc_ismarrivdateac_fname.
        ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
        INSERT ls_coltab INTO TABLE ls_outtab-coltab.

*       ev. neu BADI Felder auf MARC-Ebene     ------------- "TK10102006
        LOOP AT gt_badi_fields INTO gs_badi_field.
          IF gs_badi_field-fieldname(5) = 'MARC_'    AND
             gs_badi_field-xinput       = 'X'.
            CLEAR ls_coltab.
            ls_coltab-fieldname = gs_badi_field-fieldname.
            ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
            INSERT ls_coltab INTO TABLE ls_outtab-coltab.
          ENDIF.
        ENDLOOP.
*       ev. neu BADI Felder auf MARC-Ebene     ------------- "TK10102006

*       --- Anfang Phasenlayout------------------------------"TK01022008
        IF NOT i_phase_display IS INITIAL                    AND
          ls_statustab-xissue_is_duplicate  = con_angekreuzt.
*         Es handelt sich um das Layout einer Phasenzeile:
*         clear alle Nicht-Phasen-Attribute (clear ist zwingende notwendig,
*         da diese Werte z.T. auf erster MARA-Zeile änderbar sind!)
          CLEAR ls_outtab-marc_mmsta.
          CLEAR ls_outtab-marc_mmstd.
          CLEAR ls_outtab-marc_ismpurchasedate.
          CLEAR ls_outtab-marc_ismarrivaldatepl.
          CLEAR ls_outtab-marc_ismarrivaldateac.
        ENDIF.
*       --- Ende---Phasenlayout------------------------------"TK01022008

      ELSE.
        IF i_display = con_angekreuzt    OR
           xmatnr_locked = con_angekreuzt OR
           ls_statustab-xissue_is_duplicate  = con_angekreuzt.
*         MARC-Statusfields in DISPLAY-MODE not editable
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_marc_mmsta_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_marc_mmstd_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_marc_ismpurchasedate_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_marc_ismarrivdatepl_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.
          CLEAR ls_coltab.
          ls_coltab-fieldname = con_marc_ismarrivdateac_fname.
          ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
          INSERT ls_coltab INTO TABLE ls_outtab-coltab.

*         ev. neu BADI Felder auf MARC-Ebene--------------"TK01102006
          LOOP AT gt_badi_fields INTO gs_badi_field.
            IF gs_badi_field-fieldname(5) = 'MARC_'    AND
               gs_badi_field-xinput       = 'X'.
              CLEAR ls_coltab.
              ls_coltab-fieldname = gs_badi_field-fieldname.
              ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
              INSERT ls_coltab INTO TABLE ls_outtab-coltab.
            ENDIF.
          ENDLOOP.
*         ev. neu BADI Felder auf MARC-Ebene--------------"TK01102006

*         --- Anfang Phasenlayout------------------------------"TK01022008
          IF NOT i_phase_display IS INITIAL                    AND
            ls_statustab-xissue_is_duplicate  = con_angekreuzt.
*           Es handelt sich um das Layout einer Phasenzeile:
*           clear alle Nicht-Phasen-Attribute (clear ist zwingende notwendig,
*           da diese Werte z.T. auf erster MARA-Zeile änderbar sind!)
            CLEAR ls_outtab-marc_mmsta.
            CLEAR ls_outtab-marc_mmstd.
            CLEAR ls_outtab-marc_ismpurchasedate.
            CLEAR ls_outtab-marc_ismarrivaldatepl.
            CLEAR ls_outtab-marc_ismarrivaldateac.
          ENDIF.
*         --- Ende---Phasenlayout------------------------------"TK01022008

        ENDIF.
      ENDIF.
*
      APPEND ls_outtab TO gt_outtab.
    ENDLOOP.
*
**   --- Anfang-Phasenlayout-----------------------------------"TK01022008

    IF NOT i_phase_display IS INITIAL.
*     Phasenlayout
*      => MARC/MVKE-Segmente im Feldkatalog ausblenden
*     (unabhängig vom ev. gecustomizten Segmentlevel der Transaktionsvariante)
      LOOP AT gt_fieldcat INTO ls_fieldcat.
        IF ls_fieldcat-fieldname(5) = 'MARC_' OR
           ls_fieldcat-fieldname(5) = 'MVKE_'.
          ls_fieldcat-tech        = con_angekreuzt.
          MODIFY gt_fieldcat FROM ls_fieldcat.
        ENDIF. " LS_FIELDCAT-FIELDNAME(5) = 'MARC_' or
      ENDLOOP. " AT GT_FIELDCAT INTO LS_FIELDCAT.
    ELSE.
*     kein Phasenlayout (MARA/MARC/MVKE-Strukturierung)
*     Phasenfelder werden ausgeblendet
      LOOP AT gt_fieldcat INTO ls_fieldcat.
        IF ls_fieldcat-fieldname = 'PH_PHASEMDL' OR
           ls_fieldcat-fieldname = 'PH_PHASENBR' OR
           ls_fieldcat-fieldname = 'PH_DELIV_DATE'.
          ls_fieldcat-tech        = con_angekreuzt.
          MODIFY gt_fieldcat FROM ls_fieldcat.
        ENDIF. " LS_FIELDCAT-FIELDNAME(5) = 'MARC_' or
      ENDLOOP. " AT GT_FIELDCAT INTO LS_FIELDCAT.

    ENDIF. " not i_phase_display is initial.

*   Achtung:
*   Diese Coding kann NICHT(!!) einfach so aktiviert werden, da durch
*   die Methode set_frontend_fieldcatalog ein ev. definiertes default-layout
*   wieder verloren geht!!!!!!
*   Bei Aktivierung dieses Codings muß diese Problematik nochmal geprüft werden!

**
**   modifizierten Feldkatalog an ALV übergeben                              "TK26052008
*    gv_alv_grid->set_frontend_fieldcatalog( it_fieldcatalog = gt_fieldcat )."TK26052008
**
**   --- Ende---Phasenlayout-----------------------------------"TK01022008

* --- Anfang-----------optimistisches Sperren---------------- "TK01042008
    DATA: ls_fieldname TYPE rjp_fieldname.
    DATA: lv_save_matnr TYPE rjp_fieldname.

    IF i_wl_enq_active = con_angekreuzt.

      IF i_display = 'X'.
*       Anzeigemodus
        CLEAR gt_mara_input_fields. REFRESH gt_mara_input_fields.
        CLEAR gt_marc_input_fields. REFRESH gt_marc_input_fields.
        CLEAR gt_mvke_input_fields. REFRESH gt_mvke_input_fields.
        CLEAR gt_lock_mara.         REFRESH gt_lock_mara.
        CLEAR gt_lock_marc.         REFRESH gt_lock_marc.
        CLEAR gt_lock_mvke.         REFRESH gt_lock_mvke.
        CLEAR gt_locked_mara.       REFRESH gt_locked_mara.
        CLEAR gt_locked_marc.       REFRESH gt_locked_marc.
        CLEAR gt_locked_mvke.       REFRESH gt_locked_mvke.
      ELSE.
*       Bearbeitungsmodus
*       Aufgrund des Feldkatalogs Segmente und Felder, die Eingabebereit sind,
*       identifizieren:
        PERFORM input_segments_identify TABLES gt_fieldcat
                                      CHANGING xmara_input_active
                                               xmarc_input_active
                                               xmvke_input_active
                                               gt_mara_input_fields
                                               gt_marc_input_fields
                                               gt_mvke_input_fields.
*       Zu sperrende Segmente basierend auf statustab identifizieren
        PERFORM lock_keys_identify USING i_statustab
                                         xmara_input_active
                                         xmarc_input_active
                                         xmvke_input_active
                                CHANGING gt_lock_mara
                                         gt_lock_marc
                                         gt_lock_mvke
                                         gt_vlgvz_matnr .   "TK13062008
*       Zu sperrende Segmente sperren
        PERFORM lock_keys       USING    gt_lock_mara
                                         gt_lock_marc
                                         gt_lock_mvke
                                CHANGING gt_locked_mara
                                         gt_locked_marc
                                         gt_locked_mvke
                                         gt_vlgvz_matnr .   "TK13062008


        IF NOT gt_locked_mara[] IS INITIAL  OR
           NOT gt_locked_marc[] IS INITIAL  OR
           NOT gt_locked_mvke[] IS INITIAL  .
*
*         gesperrte Segmente auf Anzeige setzen
          LOOP AT gt_outtab INTO ls_outtab.
*
            MESSAGE s059(jksdworklist).
*
            lv_save_matnr = ls_outtab-matnr_save.                "TK23112015/hint2247913

            IF NOT ls_outtab-matnr IS INITIAL.
              lv_save_matnr = ls_outtab-matnr. "matnr merken, da ls_outtab-matnr...
*                                              ".. in manchen Zeilen leer ist!
*             MARA-Segment
              READ TABLE gt_locked_mara TRANSPORTING NO FIELDS
                         WITH KEY mandt   = sy-mandt
                                  matnr   = ls_outtab-matnr
                                  BINARY SEARCH.
              IF sy-subrc = 0.
*               MARA gesperrt => alle MARA-Ausgabefelder auf OUTPUT setzten
*               - falls MARA-Feld noch nicht in ls_outtab-coltab steht, dann aufnehmen
*               - falls MARA-Feld schon      in ls_outtab-coltab steht, dann output setzten
                LOOP AT gt_mara_input_fields INTO ls_fieldname.
                  READ TABLE ls_outtab-coltab INTO ls_coltab
                    WITH KEY fieldname = ls_fieldname.
                  IF sy-subrc = 0.
*                   Feld ist schon in coltab: Ausgabe setzen
                    ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
                    MODIFY TABLE ls_outtab-coltab FROM ls_coltab.
                  ELSE.
*                   Feld aufnehmen in coltab und Ausgabe setzen
                    CLEAR ls_coltab.
                    ls_coltab-fieldname = ls_fieldname.
                    ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
                    INSERT ls_coltab INTO TABLE ls_outtab-coltab.
                  ENDIF.
                ENDLOOP.
*               coltab in gt_outtab sichern
                MODIFY gt_outtab FROM ls_outtab.
              ENDIF.
            ENDIF.
*
            IF NOT ls_outtab-marc_werks IS INITIAL.
*           MARC-Segment
              READ TABLE gt_locked_marc TRANSPORTING NO FIELDS
                         WITH KEY mandt   = sy-mandt
                                  matnr   = lv_save_matnr" ls_outtab-matnr
                                  werks   = ls_outtab-marc_werks
                                  BINARY SEARCH.
              IF sy-subrc = 0.
*               MARC gesperrt => alle MARC-Eingabefelder auf OUTPUT setzten
*               - falls MARC-Feld noch nicht in ls_outtab-coltab steht, dann aufnehmen
*               - falls MARC-Feld schon      in ls_outtab-coltab steht, dann output setzten
                LOOP AT gt_marc_input_fields INTO ls_fieldname.
                  READ TABLE ls_outtab-coltab INTO ls_coltab
                    WITH KEY fieldname = ls_fieldname.
                  IF sy-subrc = 0.
*                   Feld ist schon in coltab: Ausgabe setzen
                    ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
                    MODIFY TABLE ls_outtab-coltab FROM ls_coltab.
                  ELSE.
*                   Feld aufnehmen in coltab und Ausgabe setzen
                    CLEAR ls_coltab.
                    ls_coltab-fieldname = ls_fieldname.
                    ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
                    INSERT ls_coltab INTO TABLE ls_outtab-coltab.
                  ENDIF.
                ENDLOOP.
*               coltab in gt_outtab sichern
                MODIFY gt_outtab FROM ls_outtab.
              ENDIF.
            ENDIF.
*
            IF NOT ls_outtab-mvke_vkorg IS INITIAL.
*             MVKE-Segment
              READ TABLE gt_locked_mvke TRANSPORTING NO FIELDS
                         WITH KEY mandt   = sy-mandt
                                  matnr   = lv_save_matnr " ls_outtab-matnr
                                  vkorg   = ls_outtab-mvke_vkorg
                                  vtweg   = ls_outtab-mvke_vtweg
                                  BINARY SEARCH.
              IF sy-subrc = 0.
*               MVKE gesperrt => alle MVKE-Eingabefelder auf OUTPUT setzten
*               - falls MVKE-Feld noch nicht in ls_outtab-coltab steht, dann aufnehmen
*               - falls MVKE-Feld schon      in ls_outtab-coltab steht, dann output setzten
                LOOP AT gt_mvke_input_fields INTO ls_fieldname.
                  READ TABLE ls_outtab-coltab INTO ls_coltab
                    WITH KEY fieldname = ls_fieldname.
                  IF sy-subrc = 0.
*                   Feld ist schon in coltab: Ausgabe setzen
                    ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
                    MODIFY TABLE ls_outtab-coltab FROM ls_coltab.
                  ELSE.
*                   Feld aufnehmen in coltab und Ausgabe setzen
                    CLEAR ls_coltab.
                    ls_coltab-fieldname = ls_fieldname.
                    ls_coltab-style = cl_gui_alv_grid=>mc_style_disabled .
                    INSERT ls_coltab INTO TABLE ls_outtab-coltab.
                  ENDIF.
                ENDLOOP.
*                coltab in gt_outtab sichern
                MODIFY gt_outtab FROM ls_outtab.
              ENDIF.
            ENDIF.
*
          ENDLOOP.
        ENDIF. "not gt_locked_mara[] is initial  or
      ENDIF. " i_display = 'X'.
    ENDIF. " I_wl_enq_active = con_angekreuzt.

* --- Ende-------------optimistisches Sperren---------------- "TK01042008

* ---------Anfang------------------------------"TK01082009/hint1371256

*  ---Anfang----explizites Merken des keys markierter Zeilen  "TK19102009
*  in gt_marked_key sind hier markierte keys vorhanden
*  (Achtung: Sortierung ist nur für Level=MARA aktiviert)
*  Ev. müssen GT_INDEX_ROWS/GT_ROW_NO für Methode SET_SELECTED_ROWS
*  basierend auf dieser Info ermittelt werden.
*  ---Ende------explizites Merken des keys markierter Zeilen  "TK19102009

* 'Alte Sortierung' vor dem Sprung in 'weiter Funktionen'
* (gesichert in gt_outtab_before_call) wieder herstellen für gt_outtab
    DATA: lt_outtab_tmp    TYPE TABLE OF rjksdworklist_alv.
    DATA: ls_outtab_before LIKE LINE OF lt_outtab_tmp.
*
    IF NOT gt_outtab_before_call[] IS INITIAL.
      LOOP AT gt_outtab_before_call INTO ls_outtab_before.
        LOOP AT gt_outtab INTO ls_outtab
          WHERE matnr = ls_outtab_before-matnr.
          EXIT.
        ENDLOOP.
        IF sy-subrc = 0.
          APPEND ls_outtab TO lt_outtab_tmp.
        ENDIF.
      ENDLOOP. " at gt_outtab_before_call into ls_outtab
      REFRESH gt_outtab.
      gt_outtab[] = lt_outtab_tmp[].
    ENDIF. " gt_outtab_before_call[] not is initial.

* ---------Anfang------------------------------"TK01082009/hint1371256



*   REFRESH ALV DISPLAY
    CALL METHOD me->register_refresh.
    CALL METHOD gv_list->execute_refresh. "ALV neu aufbauen "TK01022008

*   --- Anfang------------------------------  "TK16072009/hint1365757
    CALL METHOD gv_alv_grid->set_selected_rows
      EXPORTING
        it_index_rows = gt_index_rows
        it_row_no     = gt_row_no.
*   --- Ende--------------------------------  "TK16072009/hint1365757

*   Set focus
    CALL METHOD cl_gui_control=>set_focus
      EXPORTING
        control           = gv_custom_container
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2.

  ENDMETHOD.                    "ADD_ENTRIES

*----------------------------------------------------------------------
* Process changed entries
*----------------------------------------------------------------------
  METHOD get_changed_entries.
*
*  Methode wurde in Form strukturiert, weil diese Methode in den
*  Fuba ISM_MEDIAISSUE_STATUS_CHANGE nicht inlcudiert werden kann.
*  (Wird Methode includiert, dann Abbruch im Batch: Framework-Error)
*  => Form wird in Fuba includiert
*
    PERFORM get_changed_entries
       USING     i_statustab
                 i_dbtab
       CHANGING  e_amara_ueb
                 e_jptmara_tab                              "TK01102006
                 e_amarc_ueb
                 e_amvke_ueb
                 e_amfieldres_tab
                 e_tranc_tab
                 e_xno_changes.
*
  ENDMETHOD.                    "GET_CHANGED_ENTRIES



*----------------------------------------------------------------------
* Handle changed data
*----------------------------------------------------------------------
  METHOD handle_changed_cell.
    DATA: ls_good                  TYPE lvc_s_modi,
          lv_mstav                 TYPE mstav,
          lv_mstdv                 TYPE mstdv,
          lv_mstae                 TYPE mstae,
          lv_mstde                 TYPE mstde,
          lv_isminitshipdate       TYPE ismerstverdat,
          lv_ismcopynr             TYPE ismheftnummer,
          lv_ismpubldate           TYPE ismpubldate,        "TK01042008
          lv_medprod_maktx         TYPE maktx,
          lv_medissue_maktx        TYPE maktx,

          lv_marc_mmsta            TYPE mmsta,
          lv_marc_mmstd            TYPE mmstd,
          lv_marc_ismpurchasedate  TYPE ismpurchase_date_pl,
          lv_marc_ismarrivaldatepl TYPE ismanlftags,
          lv_marc_ismarrivaldateac TYPE ismanlftagi,

          lv_mvke_vmsta            TYPE vmsta,
          lv_mvke_vmstd            TYPE vmstd,
          lv_mvke_isminitshipdate  TYPE ismerstverdat,
          lv_mvke_ismonsaledate    TYPE ismonsaledate,
          lv_mvke_ismoffsaledate   TYPE ismoffsaledate,
          lv_mvke_isminterrupt     TYPE ismnotinterruptable,
          lv_mvke_isminterruptdate TYPE isminterruptdate,
          lv_mvke_ismcolldate      TYPE ismcolldate,
          lv_mvke_ismreturnbegin   TYPE ismreturnbegin,
          lv_mvke_ismreturnend     TYPE ismreturnend,

          ls_outtab                LIKE LINE OF gt_outtab,
          ls_statuslist            TYPE status_type.

    DATA: lt_changed_row_no TYPE lvc_t_roid.                "TK01082009/hint1371256
    DATA: ls_changed_row_no LIKE LINE OF lt_changed_row_no. "TK01082009/hint1371256

* neue BADI-Felder ---------------------------Anfang
    FIELD-SYMBOLS: <value> TYPE any.
    DATA: ls_outtab_strucname(100)     VALUE 'LS_OUTTAB-',
          ls_statuslist_strucname(100) VALUE 'LS_STATUSLIST-',
          ls_outtab_fieldname(100),
          ls_statuslist_fieldname(100),
          lv_new_value(100),    "setzuff  welcher Typ hier ???????
          lv_old_value(100).    "setzuff  welcher Typ hier ???????
* neue BADI-Felder ---------------------------Ende

*
*  Die Sortierbuttons im ALV_GRID sind inaktiviert!!
*  Grund: Das "matchen" der geänderten Zeilen mit dem Index
*  LS_GOOD-ROW_ID (aus ER_DATA_CHANGED) schlägt fehl nach einer
*  Sortierung.
*  Der Index LS_GOOD-ROW_ID ist der Index der inzwischen sortierten
*  ALV-Tabelle GT_OUTTAB, während die Tabelle des Rahmenprogrammes
*  GT_STATUSLIST_TAB nicht sortiert ist => so ist kein "matchen" möglich
*
    LOOP AT er_data_changed->mt_good_cells INTO ls_good.
      CASE ls_good-fieldname.
*       check changed status
        WHEN con_mstav_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_mstav.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_mstav <> ls_outtab-mstav.
*           modify gt_outtab
            gv_recommend_save = 'X'.
            ls_outtab-mstav = lv_mstav.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MSTAV = LV_MSTAV.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

*           SORT: - statustab aktualisieren für ALLE Felder hier inaktiviert
*                 - wird später als ganzes aus gt_outtab aktualisiert!!

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_mstdv_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_mstdv.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_mstdv <> ls_outtab-mstdv.
*           modify gt_outtab
            gv_recommend_save = 'X'.
            ls_outtab-mstdv = lv_mstdv.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MSTDV = LV_MSTDV.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                     INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_mstae_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_mstae.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_mstae <> ls_outtab-mstae.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-mstae = lv_mstae.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MSTAE = LV_MSTAE.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_mstde_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_mstde.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_mstde <> ls_outtab-mstde.
*           modify gt_outtab
            gv_recommend_save = 'X'.
            ls_outtab-mstde = lv_mstde.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MSTDE = LV_MSTDE.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_isminitshipdate_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_isminitshipdate.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_isminitshipdate <>
                                         ls_outtab-isminitshipdate.
*           modify gt_outtab
            gv_recommend_save = 'X'.
            ls_outtab-isminitshipdate = lv_isminitshipdate.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-isminitshipdate = LV_isminitshipdate.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_ismcopynr_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_ismcopynr.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_ismcopynr       <>
                                         ls_outtab-ismcopynr.
*           modify gt_outtab
            gv_recommend_save = 'X'.
            ls_outtab-ismcopynr       = lv_ismcopynr.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-ismcopynr       = LV_ismcopynr.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.


*       PUBLDATE (nur Artikel + TJY00)---------- Anfang---------"TK01042008
        WHEN con_ismpubldate_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_ismpubldate.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_ismpubldate <>
                                   ls_outtab-ismpubldate.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-ismpubldate     = lv_ismpubldate.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-ISMPUBLDATE = LV_ISMPUBLDATE.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.
*       PUBLDATE (nur Artikel + TJY00)---------- Anfang---------"TK01042008

        WHEN con_marc_mmsta_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_marc_mmsta.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_marc_mmsta <> ls_outtab-marc_mmsta.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-marc_mmsta = lv_marc_mmsta.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MARC_MMSTA = LV_MARC_MMSTA.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_marc_mmstd_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_marc_mmstd.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_marc_mmstd <> ls_outtab-marc_mmstd.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-marc_mmstd = lv_marc_mmstd.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MARC_MMSTD = LV_MARC_MMSTD.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_marc_ismpurchasedate_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_marc_ismpurchasedate.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_marc_ismpurchasedate <>
                                   ls_outtab-marc_ismpurchasedate.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-marc_ismpurchasedate = lv_marc_ismpurchasedate.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MARC_ISMPURCHASEDATE =
*                                             LV_MARC_ISMPURCHASEDATE.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_marc_ismarrivdatepl_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_marc_ismarrivaldatepl.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_marc_ismarrivaldatepl <>
                                   ls_outtab-marc_ismarrivaldatepl.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-marc_ismarrivaldatepl = lv_marc_ismarrivaldatepl.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MARC_ISMARRIVALDATEPL =
*                                             LV_MARC_ISMARRIVALDATEPL.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_marc_ismarrivdateac_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_marc_ismarrivaldateac.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_marc_ismarrivaldateac <>
                                   ls_outtab-marc_ismarrivaldateac.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-marc_ismarrivaldateac = lv_marc_ismarrivaldateac.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MARC_ISMARRIVALDATEAC =
*                                             LV_MARC_ISMARRIVALDATEAC.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_mvke_vmsta_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_mvke_vmsta.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_mvke_vmsta <> ls_outtab-mvke_vmsta.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-mvke_vmsta = lv_mvke_vmsta.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MVKE_VMSTA = LV_MVKE_VMSTA.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.


        WHEN con_mvke_vmstd_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_mvke_vmstd.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_mvke_vmstd <> ls_outtab-mvke_vmstd.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-mvke_vmstd = lv_mvke_vmstd.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MVKE_VMSTD = LV_MVKE_VMSTD.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_mvke_isminitshipdate_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_mvke_isminitshipdate.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_mvke_isminitshipdate <>
                                      ls_outtab-mvke_isminitshipdate.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-mvke_isminitshipdate = lv_mvke_isminitshipdate.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MVKE_ISMINITSHIPDATE =
*                                            LV_MVKE_ISMINITSHIPDATE.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_mvke_ismonsaledate_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_mvke_ismonsaledate.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_mvke_ismonsaledate <>
                                      ls_outtab-mvke_ismonsaledate.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-mvke_ismonsaledate = lv_mvke_ismonsaledate.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MVKE_ISMONSALEDATE =
*                                            LV_MVKE_ISMONSALEDATE.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_mvke_ismoffsaledate_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_mvke_ismoffsaledate.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_mvke_ismoffsaledate <>
                                      ls_outtab-mvke_ismoffsaledate.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-mvke_ismoffsaledate = lv_mvke_ismoffsaledate.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MVKE_ISMOFFSALEDATE =
*                                            LV_MVKE_ISMOFFSALEDATE.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_mvke_isminterrupt_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_mvke_isminterrupt.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_mvke_isminterrupt <>
                                      ls_outtab-mvke_isminterrupt.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-mvke_isminterrupt = lv_mvke_isminterrupt.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MVKE_ISMINTERRUPT =
*                                            LV_MVKE_ISMINTERRUPT.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_mvke_ismintrupdate_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_mvke_isminterruptdate.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_mvke_isminterruptdate <>
                                      ls_outtab-mvke_isminterruptdate.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-mvke_isminterruptdate = lv_mvke_isminterruptdate.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MVKE_ISMINTERRUPTDATE =
*                                            LV_MVKE_ISMINTERRUPTDATE.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_mvke_ismcolldate_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_mvke_ismcolldate.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_mvke_ismcolldate <>
                                      ls_outtab-mvke_ismcolldate.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-mvke_ismcolldate = lv_mvke_ismcolldate.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MVKE_ISMCOLLDATE =
*                                            LV_MVKE_ISMCOLLDATE.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_mvke_ismreturnbegin_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_mvke_ismreturnbegin.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_mvke_ismreturnbegin <>
                                      ls_outtab-mvke_ismreturnbegin.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-mvke_ismreturnbegin = lv_mvke_ismreturnbegin.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MVKE_ISMRETURNBEGIN =
*                                            LV_MVKE_ISMRETURNBEGIN.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN con_mvke_ismreturnend_fname.
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_good-row_id
              i_fieldname = ls_good-fieldname
            IMPORTING
              e_value     = lv_mvke_ismreturnend.
*
          READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
          IF sy-subrc = 0 AND lv_mvke_ismreturnend <>
                                      ls_outtab-mvke_ismreturnend.
            gv_recommend_save = 'X'.
*           modify gt_outtab
            ls_outtab-mvke_ismreturnend = lv_mvke_ismreturnend.
            MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*           modify gt_statustab_list

*           ------Anfang---------------------------"TK01082009/hint1371256
*           READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                      INDEX LS_GOOD-ROW_ID.
*           LS_STATUSLIST-MVKE_ISMRETURNEND =
*                                            LV_MVKE_ISMRETURNEND.
*           MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                    INDEX LS_GOOD-ROW_ID.

            ls_changed_row_no-row_id = ls_good-row_id.
            APPEND ls_changed_row_no TO lt_changed_row_no.
*           ------Ende-----------------------------"TK01082009/hint1371256

          ENDIF.

        WHEN OTHERS.
*         ev. neue BADI-Felder-----------------------------------"TK01102006
*         Check if BADI field
          READ TABLE gt_badi_fields INTO gs_badi_field
             WITH KEY fieldname = ls_good-fieldname.
          IF sy-subrc = 0.
*           get new value
            CALL METHOD er_data_changed->get_cell_value
              EXPORTING
                i_row_id    = ls_good-row_id
                i_fieldname = ls_good-fieldname
              IMPORTING
                e_value     = lv_new_value.
            READ TABLE gt_outtab INDEX ls_good-row_id INTO ls_outtab.
*           read old value
            CONCATENATE ls_outtab_strucname ls_good-fieldname INTO ls_outtab_fieldname.
            ASSIGN (ls_outtab_fieldname) TO <value>.
            lv_old_value = <value>.
*           compare old and new value
            IF sy-subrc = 0 AND lv_new_value <>
                                lv_old_value .
              gv_recommend_save = 'X'.
*             modify gt_outtab
              <value>  = lv_new_value.  "replace old by new value
              MODIFY gt_outtab FROM ls_outtab INDEX ls_good-row_id.
*             modify gt_statustab_list

*             ------Anfang---------------------------"TK01082009/hint1371256
*             READ TABLE GT_STATUSLIST_TAB INTO LS_STATUSLIST
*                        INDEX LS_GOOD-ROW_ID.
*
**            replace old value
*             concatenate LS_STATUSLIST_strucname LS_GOOD-FIELDNAME into LS_STATUSLIST_fieldname.
*             assign (LS_STATUSLIST_fieldname) to <value>.
*             <value> = lv_new_value.
*             MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST
*                                       INDEX LS_GOOD-ROW_ID.

              ls_changed_row_no-row_id = ls_good-row_id.
              APPEND ls_changed_row_no TO lt_changed_row_no.
*             ------Ende-----------------------------"TK01082009/hint1371256

            ENDIF.
          ENDIF.
*         ev. neue BADI-Felder-----------------------------------"TK01102006

      ENDCASE.
    ENDLOOP.

*   ----------------Anfang---------------------------"TK01082009/hint1371256
*   Aktualisieren statuslist_tab by gt_outtab

    SORT lt_changed_row_no.
    DELETE ADJACENT DUPLICATES FROM lt_changed_row_no.
    LOOP AT lt_changed_row_no INTO ls_changed_row_no.
*     geänderte Zeilen in GT_OUTTAB lesen und gt_statuslist_Tab aktualisieren
      READ TABLE gt_outtab INDEX ls_changed_row_no-row_id INTO ls_outtab.
      IF sy-subrc = 0.
*       aktualisieren der in gt_outtab geänderten Werte in gt_statuslist_tab
        LOOP AT gt_statuslist_tab INTO ls_statuslist.
*         if ls_statuslist-ISMREFMDPROD = LS_OUTTAB-ISMREFMDPROD  and      "TK08012013/Hinw.1807258
*            ls_statuslist-MATNR        = LS_OUTTAB-MATNR  and             "TK08012013/Hinw.1807258
          IF ls_statuslist-ismrefmdprod = ls_outtab-ismrefmdprod_save  AND "TK08012013/Hinw.1807258
             ls_statuslist-matnr        = ls_outtab-matnr_save  AND        "TK08012013/Hinw.1807258
             ls_statuslist-marc_werks   = ls_outtab-marc_werks  AND
             ls_statuslist-mvke_vkorg   = ls_outtab-mvke_vkorg  AND
             ls_statuslist-mvke_vtweg   = ls_outtab-mvke_vtweg.
            MOVE-CORRESPONDING ls_outtab TO ls_statuslist.
*           LS_OUTTAB-MATNR/ISMREFMDPROD is in Folgezeilen leer:           "TK22082013/Hinw.1903363
*           => Inhalt wiederherstellen                                     "TK22082013/Hinw.1903363
            ls_statuslist-matnr         =  ls_outtab-matnr_save .          "TK22082013/Hinw.1903363
            ls_statuslist-ismrefmdprod  =  ls_outtab-ismrefmdprod_save.    "TK22082013/Hinw.1903363
            MODIFY gt_statuslist_tab FROM ls_statuslist INDEX sy-tabix.
            EXIT.  "=> ENDLOOP
          ENDIF.
        ENDLOOP.
      ENDIF. " sy-subrc = 0.
    ENDLOOP.
*   ----------------Ende-----------------------------"TK01082009/hint1371256

  ENDMETHOD.                    "HANDLE_CHANGED_CELL

*----------------------------------------------------------------------
* Neue Drucktaste(n) in der Tollbar des ALV-GRID
*----------------------------------------------------------------------
  METHOD handle_toolbar.
    DATA: ls_toolbar  TYPE stb_button.
    IF gv_display IS INITIAL.                               "TK18012007
*     "Vorbelegung Datümer" nur im Änderungsmodus           "TK18012007

*     append a separator to normal toolbar
      CLEAR ls_toolbar.
      MOVE 3 TO ls_toolbar-butn_type.
      APPEND ls_toolbar TO e_object->mt_toolbar.
*     append an icon to show booking table
      CLEAR ls_toolbar.
      MOVE 'VORBELEGUNG' TO ls_toolbar-function.
      MOVE icon_assign TO ls_toolbar-icon.
      MOVE 'Vorbelegung Status/Termine'(100)
                                       TO ls_toolbar-quickinfo.
      MOVE 'Vorbelegung Status/Termine'(099) TO ls_toolbar-text.
      MOVE ' ' TO ls_toolbar-disabled.
      APPEND ls_toolbar TO e_object->mt_toolbar.

    ENDIF. " gv_display is initial.                          "TK18012007


*   ------------ Anfang-----Menu in toolbar-------------------"TK08022007
    IF gv_pedex_active = con_angekreuzt.
*     append a separator to normal toolbar
      CLEAR ls_toolbar.
      MOVE 3 TO ls_toolbar-butn_type.
      APPEND ls_toolbar TO e_object->mt_toolbar.
*     append menu in toolbar
      CLEAR ls_toolbar.
      MOVE 'FUNKTIONEN' TO ls_toolbar-function.
      MOVE icon_list TO ls_toolbar-icon.
      MOVE 'Weitere Funktionen'(150)
                                       TO ls_toolbar-quickinfo.
      MOVE 'Weitere Funktionen'(150) TO ls_toolbar-text.
      MOVE ' ' TO ls_toolbar-disabled.  "<== Menü !!
      MOVE 2 TO ls_toolbar-butn_type.
      APPEND ls_toolbar TO e_object->mt_toolbar.
    ENDIF. " gv_pedex_active is initial.
*   ------------ Ende------Menu in toolbar -------------------"TK08022007

*
  ENDMETHOD.                    "handle_toolbar

* Menue in Toolbar ------------Anfang-------------------------  "TK08022007
  METHOD handle_menu_button.

    DATA: ls_tjksd13a TYPE tjksd13a.
    DATA: ls_tjksd13  TYPE tjksd13.
    DATA: ls_tjksd130t  TYPE tjksd130t.
    DATA: lv_fcode TYPE ui_func.

* § 3.At event MENU_BUTTON query your function code and define a
*     menu in the same way as a context menu.
*..........
* Part II: Evaluate 'e_ucomm' to see which menu button of the toolbar
*          has been clicked on.
*          Define then the corresponding menu.
*          The menu contains function codes that are evaluated
*          in 'handle_user_command'.
*...........
*   handle own menubuttons

    CHECK gv_pedex_active = con_angekreuzt.

    LOOP AT gt_tjksd13 INTO ls_tjksd13.
      lv_fcode = sy-tabix.
      IF e_ucomm = 'FUNKTIONEN'.

        READ TABLE gt_tjksd130t INTO ls_tjksd130t
          WITH KEY    mandt       = sy-mandt
                      spras       = sy-langu
                      wl_function = ls_tjksd13-wl_function.

        CALL METHOD e_object->add_function
          EXPORTING
            fcode = lv_fcode                                "'FC_001'
            text  = ls_tjksd130t-wl_text.           "'erste Funktion'.
      ENDIF.
    ENDLOOP. " at gt_tjksd13 into ls_tjksd13.
*
  ENDMETHOD.                    "handle_menu_button
* Menue in Toolbar ------------Ende---------------------------  "TK08022007


*----------------------------------------------------------------------
* Text-Anbingung   ------------Anfang-----------           "TK01102006
*----------------------------------------------------------------------

  METHOD handle_double_click.
*        FOR EVENT double_click OF CL_GUI_ALV_GRID
*            IMPORTING  E_ROW E_COLUMN ES_ROW_NO .


    DATA: ls_outtab TYPE rjksdworklist_alv.
    DATA: ls_statustab TYPE jksdmaterialstatus.
    DATA: text_action(1).

*   Check double click on text-icon
    CHECK e_column = 'TEXT_ICON'.

*   Read selected line
    READ TABLE gt_outtab INTO ls_outtab INDEX e_row-index.

*   ------Anfang---------------------------"TK01082009/hint1371256
    DATA: lv_statustab_index TYPE sy-tabix.         "setzuff sorting

*   READ TABLE gt_statuslist_tab INTO ls_statustab INDEX e_row-index.
*   if sy-subrc = 0.

*   Die der gt_outtab zugeordnete Zeile in statuslist_tab muß gefunden werden,
*   da gt_outtab sortiert sein kann und gt_statuslist_tab nicht sortiert ist
    LOOP AT gt_statuslist_tab INTO ls_statustab.
      IF ls_statustab-ismrefmdprod = ls_outtab-ismrefmdprod  AND

*        ls_statustab-matnr        = ls_outtab-matnr  and           "TK23112015/hint2247913
         ls_statustab-matnr        = ls_outtab-matnr_save  AND      "TK23112015/hint2247913

         ls_statustab-marc_werks   = ls_outtab-marc_werks  AND
         ls_statustab-mvke_vkorg   = ls_outtab-mvke_vkorg  AND
         ls_statustab-mvke_vtweg   = ls_outtab-mvke_vtweg.
        lv_statustab_index = sy-tabix.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF NOT lv_statustab_index IS INITIAL.
*   ------Ende-----------------------------"TK01082009/hint1371256

      IF ls_statustab-xfirst_issue_line = 'X'.

*       set action for SM30
*       if sy-tcode = con_tcode_change.                         "TK18012007
        IF gv_display IS INITIAL.                           "TK18012007
          text_action = 'U'.

*         - Sperrmimik SM30-Pflege umgestellt---- Anfang--TK01072008/hint1226213
          IF gv_wl_enq_active = 'X'.
*           optimistisches Sperren aktiv:
*           => parallel gesperrte Ausgaben stehen in gt_locked_mara
            READ TABLE gt_locked_mara WITH KEY mandt = sy-mandt
                                               matnr = ls_statustab-matnr
                                               TRANSPORTING NO FIELDS.
          ELSE.
*           optimistisches Sperren nicht aktiv:
*           => parallel gesperrte Ausgaben stehen in gt_lock_error
            READ TABLE gt_lock_error  WITH KEY matnr = ls_statustab-matnr
                                               TRANSPORTING NO FIELDS.
          ENDIF.
          IF sy-subrc = 0.
*           Material von anderer Worklist gesperrt
            MESSAGE i066(jksdworklist) WITH ls_statustab-matnr.
            text_action = 'S'.
          ENDIF.
*         - Sperrmimik SM30-Pflege umgestellt---- Anfang--TK01072008/hint1226213

        ELSE.
          text_action = 'S'.
        ENDIF.

*     text icon only activ on first issue line: Call SM30 for texts
        PERFORM call_worklist_text USING ls_statustab-matnr text_action
                                   CHANGING dba_sellist excl_cua_funct .
*     perform adjust_text_icon changing ls_statustab.
        PERFORM status_stru_text_icon_fill USING ls_statustab-matnr
                                         CHANGING ls_statustab-text_icon.

*     ----Anfang-------------------------------"TK01082009/hint1371256
*     modify gt_statuslist_tab
*     modify gt_statuslist_tab from ls_statustab index e_row-index.
        MODIFY gt_statuslist_tab FROM ls_statustab INDEX lv_statustab_index..
*     ----Ende---------------------------------"TK01082009/hint1371256

*     modify gt_outtab
        ls_outtab-text_icon = ls_statustab-text_icon.
        MODIFY gt_outtab FROM ls_outtab INDEX e_row-index.
*     Icon refresh
        CALL METHOD gv_list->register_refresh.
        CALL METHOD gv_list->execute_refresh.
      ENDIF.
    ENDIF. " sy-subrc = 0.

*
  ENDMETHOD. " HANDLE_double_click.
* Text-Anbingung   ------------Ende ------------           "TK01102006


*----------------------------------------------------------------------
* OK-Code-Verarbeitung für neue Drucktaste(n) in der Toolbar des ALV
*----------------------------------------------------------------------
  METHOD handle_user_command.
* § 3.In event handler method for event USER_COMMAND: Query your
*   function codes defined in step 2 and react accordingly.

    DATA: lt_index_columns TYPE lvc_t_col.
    DATA: ls_index_columns LIKE LINE OF lt_index_columns.
    DATA: lt_index_rows TYPE lvc_t_row.
    DATA: ls_index_row LIKE LINE OF lt_index_rows.
    DATA: lt_row_no TYPE lvc_t_roid.
    DATA: ta_cnt TYPE sy-tabix.
    DATA: ls_outtab LIKE LINE OF gt_outtab.
    DATA: ls_statuslist TYPE status_type.
    DATA: lt_filtered_entries TYPE lvc_t_fidx.
*    DATA: Ls_FILTERED_ENTRIES like line of LT_FILTERED_ENTRIES.
    DATA: ls_filtered_entries TYPE int4.
    DATA: cnt1 TYPE sy-tabix.
    DATA: cnt2 TYPE sy-tabix.
    DATA: ls_tabix TYPE sy-tabix.
    DATA: xbadifield_marked TYPE xfeld.                     "TK01102006
    DATA: ls_tjksd13 TYPE tjksd13.                          "TK08022007
    DATA: lv_tabix TYPE sytabix.                            "TK08022007
    DATA: marked_issue TYPE mara-matnr.                     "TK08022007

    DATA: marked_plant TYPE marc-werks.    "TK01042008/hint1158167
    DATA: marked_vkorg TYPE mvke-vkorg.    "TK01042008/hint1158167
    DATA: marked_vtweg TYPE mvke-vtweg.    "TK01042008/hint1158167

    DATA: marked_issue_tab TYPE marked_tab.                 "TK08022007
    DATA: mark_count TYPE sy-tabix.                         "TK08022007
    DATA: in_issue_tab TYPE  ismmatnr_issuetab.             "TK08022007
    DATA: ls_tjksd130 TYPE tjksd130.                        "TK08022007
    DATA: lv_rc TYPE i.

    DATA: lv_save_matnr TYPE rjp_fieldname.                 "TK01042008
*
    CLEAR: gv_werks_status_column_marked,
           gv_vtl_status_column_marked,
           gv_date_column_marked.
*
    CASE e_ucomm.
      WHEN 'VORBELEGUNG'.   "GV_ALV_GRID

        IF gt_statuslist_tab IS INITIAL.
          MESSAGE i046(jksdworklist).
          EXIT.
        ENDIF.

        CALL METHOD gv_alv_grid->get_selected_columns
          IMPORTING
            et_index_columns = lt_index_columns.


*       BADI-Felder sind nicht unterstützt--- Anfang----------"TK01102006
        PERFORM check_badifields_marked USING lt_index_columns
                                      CHANGING xbadifield_marked.
        IF xbadifield_marked = con_angekreuzt.
          MESSAGE i048(jksdworklist).
          EXIT.
        ENDIF.
*       BADI-Felder sind nicht unterstützt--- Ende------------"TK01102006

        CALL METHOD gv_alv_grid->get_filtered_entries
          IMPORTING
            et_filtered_entries = lt_filtered_entries.
*       Achtung:
*       In LT_FILTERED_ENTRIES enthält die Zeilen, die NICHT(!) mehr
*       auf dem Schirm bleiben, die also ausgefiltert wurden!

*       Check, ob nach dem Filtern noch Zeilen übrigbleiben:
        DESCRIBE TABLE lt_filtered_entries LINES cnt1.
        DESCRIBE TABLE gt_statuslist_tab LINES cnt2.
        IF cnt1 >= cnt2.
          MESSAGE i046(jksdworklist).
          EXIT.
        ENDIF.

*       Read marked lines
        CALL METHOD gv_alv_grid->get_selected_rows
          IMPORTING
            et_index_rows = lt_index_rows
            et_row_no     = lt_row_no.

        CALL METHOD cl_gui_cfw=>flush.
        IF sy-subrc NE 0.
*         Fehler in Methode FLUSH
          CALL FUNCTION 'POPUP_TO_INFORM'
            EXPORTING
              titel = sy-repid
              txt2  = sy-subrc
              txt1  = 'Fehler bei Methode FLUSH des ALV GRID'(500).
        ELSE.
          LOOP AT lt_index_columns INTO ls_index_columns.
*           Werks-Status
            IF ls_index_columns-fieldname = 'MSTAE'               OR
               ls_index_columns-fieldname = 'MARC_MMSTA'.
              gv_werks_status_column_marked = con_angekreuzt.
            ENDIF.
*           Vertriebslinien-Status
            IF ls_index_columns-fieldname = 'MSTAV'               OR
               ls_index_columns-fieldname = 'MVKE_VMSTA' .
              gv_vtl_status_column_marked = con_angekreuzt.
            ENDIF.
*           Datümer
            IF ls_index_columns-fieldname = 'MSTDV'                 OR
               ls_index_columns-fieldname = 'MSTDE'                 OR
               ls_index_columns-fieldname = 'ISMINITSHIPDATE'       OR

               ls_index_columns-fieldname = 'MVKE_VMSTD'            OR
               ls_index_columns-fieldname = 'MVKE_ISMINITSHIPDATE'  OR
               ls_index_columns-fieldname = 'MVKE_ISMONSALEDATE'    OR
               ls_index_columns-fieldname = 'MVKE_ISMOFFSALEDATE'   OR
               ls_index_columns-fieldname = 'MVKE_ISMINTERRUPTDATE' OR
               ls_index_columns-fieldname = 'MVKE_ISMCOLLDATE'      OR
               ls_index_columns-fieldname = 'MVKE_ISMRETURNBEGIN'   OR
               ls_index_columns-fieldname = 'MVKE_ISMRETURNEND'     OR

               ls_index_columns-fieldname = 'MARC_MMSTD'            OR
               ls_index_columns-fieldname = 'MARC_ISMPURCHASEDATE'  OR
               ls_index_columns-fieldname = 'MARC_ISMARRIVALDATEPL' OR
               ls_index_columns-fieldname = 'MARC_ISMARRIVALDATEAC'
               .
              gv_date_column_marked = con_angekreuzt.
            ENDIF.
          ENDLOOP.
          IF gv_werks_status_column_marked IS INITIAL AND
             gv_vtl_status_column_marked IS INITIAL AND
             gv_date_column_marked IS INITIAL.
            MESSAGE i045(jksdworklist).
          ELSE.
*           Popup für Status/Datum Eingabe
            PERFORM popup_fuer_default
                    USING lt_index_rows
                    CHANGING rjksd13-marked_date
                             rjksd13-mstav
                             rjksd13-mstae
                             rjksd13-xonly_marked_columns
                             popup_status.
            IF popup_status EQ con_popupstatus_abort.
*             POPUP wurde mit F12  abgebrochen
*              PERFORM MARKED_LINES_RESET.
              EXIT.

            ELSE.

*           ------Anfang---------------------------"TK01082009/hint1371256
*
*           GT_STATUSLIST_TAB ist hier MICHT(!!) sortiert und wird daher
*           erst NACH(!!)DEM die sortierte GT_OUTTAB aktualisiert wurde
*           mit den VORBELEGUNGEN versorgt!!

**             Update der Vorbelegungen in GT_STATUSLIST_TAB
*            LOOP AT GT_STATUSLIST_TAB INTO LS_STATUSLIST.
*
*              ls_tabix = sy-tabix.
*
**               Check Filter
*              LS_FILTERED_ENTRIES = SY-TABIX.
*              READ TABLE LT_FILTERED_ENTRIES FROM LS_FILTERED_ENTRIES
*                   TRANSPORTING NO FIELDS.
*              IF SY-SUBRC = 0.
**                 Zeile wurde "ausgefiltert"(ist nicht am Schirm)
*                CONTINUE.
*              ENDIF.
*
**               check Zeilenmarkierung
*              if rjksd13-XONLY_MARKED_COLUMNS = con_angekreuzt.
**                 nur markierte Zeilen ändern
*                read table lt_index_rows transporting no fields
*                  with key index = ls_tabix.
*                if sy-subrc <> 0.
**                   Zeile ist nicht markiert => nicht ändern
*                  continue.
*                endif.
*              endif.
*
**               Check: MARA "optimistisch" gesperrt ?                   "TK01042008
*              if not ls_statuslist-matnr is initial.        "TK01042008
*                read table gt_locked_mara transporting no fields "TK01042008
*                  with key mandt   = sy-mandt               "TK01042008
*                           matnr   =  LS_STATUSLIST-matnr   "TK01042008
*                           binary search.                   "TK01042008
*                if sy-subrc <> 0.                           "TK01042008
**                   MARA ist nicht gesperrt, kann also vorbelegt werden."TK01042008
*
**                   Vertriebslinien-Status
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MSTAV'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT RJKSD13-MSTAV IS INITIAL.
*                    LS_STATUSLIST-MSTAV
*                                = RJKSD13-MSTAV.
*                  ENDIF.
**                   Werks-Status
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MSTAE'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT RJKSD13-MSTAE IS INITIAL.
*                    LS_STATUSLIST-MSTAE
*                                = RJKSD13-MSTAE.
*                  ENDIF.
**                   Datümer
**                   MARA-Datümer
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MSTDV'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-MSTDV
*                                = rjksd13-marked_Date.
*                  ENDIF.
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MSTDE'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-MSTDE
*                                = rjksd13-marked_Date.
*                  ENDIF.
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'ISMINITSHIPDATE'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-ISMINITSHIPDATE
*                                = rjksd13-marked_Date.
*                  ENDIF.
*
*                endif. " sy-subrc <> 0.                               "TK01042008
*              endif. " not ls_statuslist-matnr is initial             "TK01042008
*
*
*
**               Check: MVKE "optimistisch" gesperrt ?                   "TK01042008
*              if not ls_statuslist-mvke_vkorg is initial.   "TK01042008
*                read table gt_locked_mvke transporting no fields "TK01042008
*                  with key mandt   = sy-mandt               "TK01042008
*                           matnr   =  LS_STATUSLIST-matnr   "TK01042008
*                           vkorg   =  LS_STATUSLIST-mvke_vkorg "TK01042008
*                           vtweg   =  LS_STATUSLIST-mvke_vtweg "TK01042008
*                           binary search.                   "TK01042008
*                if sy-subrc <> 0.                           "TK01042008
**                   MVKE ist nicht gesperrt, kann also vorbelegt werden."TK01042008
*
**                   Vertriebslinienspezfischer Status
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MVKE_VMSTA'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT RJKSD13-MSTAV IS INITIAL.
*                    LS_STATUSLIST-MVKE_VMSTA
*                                = RJKSD13-MSTAV.
*                  ENDIF.
*
**                   MVKE-Datümer
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MVKE_VMSTD'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-MVKE_VMSTD
*                                = rjksd13-marked_Date.
*                  ENDIF.
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MVKE_ISMINITSHIPDATE'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-MVKE_ISMINITSHIPDATE
*                                = rjksd13-marked_Date.
*                  ENDIF.
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MVKE_ISMONSALEDATE'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-MVKE_ISMONSALEDATE
*                                = rjksd13-marked_Date.
*                  ENDIF.
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MVKE_ISMOFFSALEDATE'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-MVKE_ISMOFFSALEDATE
*                                = rjksd13-marked_Date.
*                  ENDIF.
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MVKE_ISMINTERRUPTDATE'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-MVKE_ISMINTERRUPTDATE
*                                = rjksd13-marked_Date.
*                  ENDIF.
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MVKE_ISMCOLLDATE'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-MVKE_ISMCOLLDATE
*                                = rjksd13-marked_Date.
*                  ENDIF.
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MVKE_ISMRETURNBEGIN'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-MVKE_ISMRETURNBEGIN
*                                = rjksd13-marked_Date.
*                  ENDIF.
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MVKE_ISMRETURNEND'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-MVKE_ISMRETURNEND
*                                = rjksd13-marked_Date.
*                  ENDIF.
*
*                endif. " sy-subrc <> 0.                               "TK01042008
*              endif. " not ls_statuslist-matnr is initial             "TK01042008
*
**               Check: MARC "optimistisch" gesperrt ?                   "TK01042008
*              if not ls_statuslist-marc_werks is initial.   "TK01042008
*                read table gt_locked_marc transporting no fields "TK01042008
*                  with key mandt   = sy-mandt               "TK01042008
*                           matnr   =  LS_STATUSLIST-matnr   "TK01042008
*                           werks   =  LS_STATUSLIST-marc_werks "TK01042008
*                           binary search.                   "TK01042008
*                if sy-subrc <> 0.                           "TK01042008
**                   MARC ist nicht gesperrt, kann also vorbelegt werden."TK01042008
*
**                   Werksspezifischer Status
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MARC_MMSTA'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT RJKSD13-MSTAE IS INITIAL.
*                    LS_STATUSLIST-MARC_MMSTA
*                                = RJKSD13-MSTAE.
*                  ENDIF.
*
**                   MARC-Datümer
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MARC_MMSTD'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-MARC_MMSTD
*                                = rjksd13-marked_Date.
*                  ENDIF.
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MARC_ISMPURCHASEDATE'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-MARC_ISMPURCHASEDATE
*                                = rjksd13-marked_Date.
*                  ENDIF.
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MARC_ISMARRIVALDATEPL'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-MARC_ISMARRIVALDATEPL
*                                = rjksd13-marked_Date.
*                  ENDIF.
*                  READ TABLE LT_INDEX_COLUMNS INTO LS_INDEX_COLUMNS
*                    WITH KEY FIELDNAME = 'MARC_ISMARRIVALDATEAC'.
*                  IF SY-SUBRC  = 0 AND
*                     NOT rjksd13-marked_Date IS INITIAL AND
*                     NOT rjksd13-marked_Date = '00000000'.
*                    LS_STATUSLIST-MARC_ISMARRIVALDATEAC
*                                = rjksd13-marked_Date.
*                  ENDIF.
*
*                endif. " sy-subrc <> 0.                               "TK01042008
*              endif. " not ls_statuslist-matnr is initial             "TK01042008
*
*
*              MODIFY GT_STATUSLIST_TAB FROM LS_STATUSLIST.
*            ENDLOOP. "AT GT_STATUSLIST_TAB
*           ------Ende-----------------------------"TK01082009/hint1371256


*             Update der Vorbelegungen in gt_outtab
              LOOP AT gt_outtab INTO ls_outtab.
                ls_tabix = sy-tabix.
*
*               Check Filter
                ls_filtered_entries = sy-tabix.
                READ TABLE lt_filtered_entries FROM ls_filtered_entries
                     TRANSPORTING NO FIELDS.
                IF sy-subrc = 0.
*                 Zeile wurde "ausgefiltert"(ist nicht am Schirm)
                  CONTINUE.
                ENDIF.
*
*               check Zeilenmarkierung
                IF rjksd13-xonly_marked_columns = con_angekreuzt.
*                 nur markierte Zeilen ändern
                  READ TABLE lt_index_rows TRANSPORTING NO FIELDS
                    WITH KEY index = ls_tabix.
                  IF sy-subrc <> 0.
*                   Zeile ist nicht markiert => nicht ändern
                    CONTINUE.
                  ENDIF.
                ENDIF.

                lv_save_matnr = ls_outtab-matnr_save.                     "TK23112015/hint2247913

*               Check: MARA "optimistisch" gesperrt ?                   "TK01042008
                IF NOT ls_outtab-matnr IS INITIAL.          "TK01042008
                  lv_save_matnr = ls_outtab-matnr. "matnr merken, da ls_outtab-matnr...
*                                                  ".. in manchen Zeilen leer ist!

                  READ TABLE gt_locked_mara TRANSPORTING NO FIELDS "TK01042008
                    WITH KEY mandt   = sy-mandt             "TK01042008
                             matnr   =  ls_outtab-matnr     "TK01042008
                             BINARY SEARCH.                 "TK01042008
                  IF sy-subrc <> 0.                         "TK01042008
*                   MARA ist nicht gesperrt, kann also vorbelegt werden."TK01042008

*                   Vertriebslinien-Status
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MSTAV'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-mstav IS INITIAL
                       AND NOT ls_outtab-matnr IS INITIAL. "MARA-Ebene"
                      ls_outtab-mstav = rjksd13-mstav.
                    ENDIF.
*                   Werks-Status
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MSTAE'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-mstae IS INITIAL
                       AND NOT ls_outtab-matnr IS INITIAL. "MARA-Ebene"
                      ls_outtab-mstae = rjksd13-mstae.
                    ENDIF.
*                   Datümer
*                   MARA-Datümer
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MSTDV'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000'
                       AND NOT ls_outtab-matnr IS INITIAL. "MARA-Ebene"
                      ls_outtab-mstdv = rjksd13-marked_date.
                    ENDIF.
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MSTDE'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000'
                       AND NOT ls_outtab-matnr IS INITIAL. "MARA-Ebene"
                      ls_outtab-mstde = rjksd13-marked_date.
                    ENDIF.
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'ISMINITSHIPDATE'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000'
                       AND NOT ls_outtab-matnr IS INITIAL. "MARA-Ebene"
                      ls_outtab-isminitshipdate = rjksd13-marked_date.
                    ENDIF.

                  ENDIF. " sy-subrc <> 0.               "TK01042008
                ENDIF. " not ls_outtab-matnr is initial                 "TK01042008


*               Check: MVKE "optimistisch" gesperrt ?                   "TK01042008
                IF NOT ls_outtab-mvke_vkorg IS INITIAL.     "TK01042008
                  READ TABLE gt_locked_mvke TRANSPORTING NO FIELDS "TK01042008
                    WITH KEY mandt   = sy-mandt             "TK01042008
                             matnr   =  lv_save_matnr       "TK01042008
                             vkorg   =  ls_outtab-mvke_vkorg "TK01042008
                             vtweg   =  ls_outtab-mvke_vtweg "TK01042008
                             BINARY SEARCH.                 "TK01042008
                  IF sy-subrc <> 0.                         "TK01042008
*                   MVKE ist nicht gesperrt, kann also vorbelegt werden."TK01042008

                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MVKE_VMSTA'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-mstav IS INITIAL AND
                       NOT ls_outtab-mvke_vkorg IS INITIAL. "MVKE-Ebene"
                      ls_outtab-mvke_vmsta = rjksd13-mstav.
                    ENDIF.

*                   MVKE-Datümer
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MVKE_VMSTD'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000' AND
                       NOT ls_outtab-mvke_vkorg IS INITIAL. "MVKE-Ebene"
                      ls_outtab-mvke_vmstd = rjksd13-marked_date.
                    ENDIF.
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MVKE_ISMINITSHIPDATE'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000' AND
                       NOT ls_outtab-mvke_vkorg IS INITIAL. "MVKE-Ebene"
                      ls_outtab-mvke_isminitshipdate = rjksd13-marked_date.
                    ENDIF.
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MVKE_ISMONSALEDATE'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000' AND
                       NOT ls_outtab-mvke_vkorg IS INITIAL. "MVKE-Ebene"
                      ls_outtab-mvke_ismonsaledate = rjksd13-marked_date.
                    ENDIF.
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MVKE_ISMOFFSALEDATE'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000' AND
                       NOT ls_outtab-mvke_vkorg IS INITIAL. "MVKE-Ebene"
                      ls_outtab-mvke_ismoffsaledate = rjksd13-marked_date.
                    ENDIF.
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MVKE_ISMINTERRUPTDATE'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000' AND
                       NOT ls_outtab-mvke_vkorg IS INITIAL. "MVKE-Ebene"
                      ls_outtab-mvke_isminterruptdate = rjksd13-marked_date.
                    ENDIF.
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MVKE_ISMCOLLDATE'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000' AND
                       NOT ls_outtab-mvke_vkorg IS INITIAL. "MVKE-Ebene"
                      ls_outtab-mvke_ismcolldate = rjksd13-marked_date.
                    ENDIF.
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MVKE_ISMRETURNBEGIN'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000' AND
                       NOT ls_outtab-mvke_ismreturnbegin IS INITIAL.
*                   ls_outtab-mvke_vmstd = rjksd13-marked_date.                "TK08012013/Hinw.1807258
                      ls_outtab-mvke_ismreturnbegin = rjksd13-marked_date.       "TK08012013/Hinw.1807258
                    ENDIF.
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MVKE_ISMRETURNEND'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000' AND
                       NOT ls_outtab-mvke_vkorg IS INITIAL. "MVKE-Ebene"
                      ls_outtab-mvke_ismreturnend = rjksd13-marked_date.
                    ENDIF.

                  ENDIF. " sy-subrc <> 0.                               "TK01042008
                ENDIF. " not ls_statuslist-matnr is initial             "TK01042008

*               Check: MARC "optimistisch" gesperrt ?                   "TK01042008
                IF NOT ls_outtab-marc_werks IS INITIAL.     "TK01042008
                  READ TABLE gt_locked_marc TRANSPORTING NO FIELDS "TK01042008
                    WITH KEY mandt   = sy-mandt             "TK01042008
                             matnr   =  lv_save_matnr       "TK01042008
                             werks   =  ls_outtab-marc_werks "TK01042008
                             BINARY SEARCH.                 "TK01042008
                  IF sy-subrc <> 0.                         "TK01042008
*                   MARC ist nicht gesperrt, kann also vorbelegt werden."TK01042008

                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MARC_MMSTA'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-mstae IS INITIAL AND
                       NOT ls_outtab-marc_werks IS INITIAL. "MARC-Ebene"
                      ls_outtab-marc_mmsta = rjksd13-mstae.
                    ENDIF.

*                   MARC-Datümer
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MARC_MMSTD'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000' AND
                       NOT ls_outtab-marc_werks IS INITIAL. "MARC-Ebene"
                      ls_outtab-marc_mmstd = rjksd13-marked_date.
                    ENDIF.
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MARC_ISMPURCHASEDATE'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000' AND
                       NOT ls_outtab-marc_werks IS INITIAL. "MARC-Ebene"
                      ls_outtab-marc_ismpurchasedate = rjksd13-marked_date.
                    ENDIF.
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MARC_ISMARRIVALDATEPL'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000' AND
                       NOT ls_outtab-marc_werks IS INITIAL. "MARC-Ebene"
                      ls_outtab-marc_ismarrivaldatepl = rjksd13-marked_date.
                    ENDIF.
                    READ TABLE lt_index_columns INTO ls_index_columns
                      WITH KEY fieldname = 'MARC_ISMARRIVALDATEAC'.
                    IF sy-subrc  = 0 AND
                       NOT rjksd13-marked_date IS INITIAL AND
                       NOT rjksd13-marked_date = '00000000' AND
                       NOT ls_outtab-marc_werks IS INITIAL. "MARC-Ebene"
                      ls_outtab-marc_ismarrivaldateac = rjksd13-marked_date.
                    ENDIF.

                  ENDIF. " sy-subrc <> 0.                               "TK01042008
                ENDIF. " not ls_statuslist-matnr is initial             "TK01042008

                MODIFY gt_outtab FROM ls_outtab.
              ENDLOOP. " at gt_outtab

*           ------Anfang---------------------------"TK01082009/hint1371256
*           Erst NACH(!!) Übernahme der VORBELEGUNG in GT_OUTTAB wird
*           die GT_STATUSLIST_TAB aktualisiert:
              LOOP AT gt_outtab INTO ls_outtab.
*             Zeilen aus GT_OUTTAB in GT_STATUSLIST_TAB aktualisieren
                LOOP AT gt_statuslist_tab INTO ls_statuslist.
*               if ls_statuslist-ISMREFMDPROD = LS_OUTTAB-ISMREFMDPROD  and      "TK08012013/Hinw.1807258
*                  ls_statuslist-MATNR        = LS_OUTTAB-MATNR  and             "TK08012013/Hinw.1807258
                  IF ls_statuslist-ismrefmdprod = ls_outtab-ismrefmdprod_save AND  "TK08012013/Hinw.1807258
                     ls_statuslist-matnr        = ls_outtab-matnr_save  AND        "TK08012013/Hinw.1807258
                     ls_statuslist-marc_werks   = ls_outtab-marc_werks  AND
                     ls_statuslist-mvke_vkorg   = ls_outtab-mvke_vkorg  AND
                     ls_statuslist-mvke_vtweg   = ls_outtab-mvke_vtweg.
                    MOVE-CORRESPONDING ls_outtab TO ls_statuslist.
*                 LS_OUTTAB-MATNR/ISMREFMDPROD is in Folgezeilen leer:           "TK08012013/Hinw.1807258
*                 => Inhalt wiederherstellen                                     "TK08012013/Hinw.1807258
                    ls_statuslist-matnr         =  ls_outtab-matnr_save .          "TK08012013/Hinw.1807258
                    ls_statuslist-ismrefmdprod  =  ls_outtab-ismrefmdprod_save.    "TK08012013/Hinw.1807258
                    MODIFY gt_statuslist_tab FROM ls_statuslist.
                    EXIT.  "=> ENDLOOP
                  ENDIF.
                ENDLOOP.  "at gt_statuslist_tab
              ENDLOOP. "AT gt_outtab
*           ------Ende-----------------------------"TK01082009/hint1371256

              gv_recommend_save = 'X'.
              gv_refresh = 'X'.

              CALL METHOD cl_gui_cfw=>set_new_ok_code
                EXPORTING
                  new_code = 'DEFAULT'
                IMPORTING
                  rc       = lv_rc.
            ENDIF.
          ENDIF.
        ENDIF.

*     *------------------- Anfang --------------------------"TK08022007
      WHEN OTHERS.
        IF NOT gt_tjksd13[] IS INITIAL.
          DATA: safety_answer.
          DATA: lv_change_mode TYPE xfeld.
*         change mode determine
          CLEAR lv_change_mode.
          IF gv_display IS INITIAL.
            lv_change_mode = con_angekreuzt.
          ENDIF.
*         Transaktionsvariante ist ausgeführt
          MOVE e_ucomm TO lv_tabix.
          READ TABLE gt_tjksd13 INTO ls_tjksd13 INDEX lv_tabix.
          IF sy-subrc = 0.

            READ TABLE gt_tjksd130 INTO ls_tjksd130
              WITH KEY mandt       = sy-mandt
                       wl_function = ls_tjksd13-wl_function.

            IF ls_tjksd130-wl_n_issues IS INITIAL.
*             Check: One issue must be marked
              CALL METHOD gv_list->get_marked_issue
                EXPORTING
                  i_statustab  = gt_statuslist_tab
                IMPORTING
                  e_issue      = marked_issue
                  e_plant      = marked_plant    "TK01042008/hint1158167
                  e_vkorg      = marked_vkorg    "TK01042008/hint1158167
                  e_vtweg      = marked_vtweg    "TK01042008/hint1158167
                  e_mark_count = mark_count.
              IF marked_issue IS INITIAL.
                MESSAGE i005(jksdworklist) WITH mark_count.
              ELSE.
*               call transaction (incl. Parameterübergabe)
*               Sicherheitsabfrage für Worklist
                IF NOT gv_recommend_save IS INITIAL.
                  PERFORM safety_check CHANGING safety_answer.
                  IF safety_answer = 'J'.
                    PERFORM save.
*                   lv_ucomm = 'REFRESH'.
                  ELSEIF safety_answer = 'A'.
*                    CLEAR PV_OK_CODE.
                    EXIT.
                  ENDIF.
                ENDIF.
*
                IF safety_answer = 'N'.
*                 Antwort auf Sicherheits-Popup = Nein
*                 => REFRESH ist notwendig
*                 => Sicherheitspopup nicht nochmal prozessieren
                  CLEAR gv_recommend_save.
                ENDIF.
*
                EXPORT in_plant FROM marked_plant             "TK01042008/hint1158167
                    TO MEMORY ID con_plant_memoryid.          "TK01042008/hint1158167.
                EXPORT in_vkorg FROM marked_vkorg             "TK01042008/hint1158167
                    TO MEMORY ID con_vkorg_memoryid.          "TK01042008/hint1158167.
                EXPORT in_vtweg FROM marked_vtweg             "TK01042008/hint1158167
                    TO MEMORY ID con_vtweg_memoryid.          "TK01042008/hint1158167.
*
*             ---------Anfang------------------------------"TK01082009/hint1371256
*             Sicherung der Sortierung in gt_outtab_before_call (nur MARA-Level)
                REFRESH gt_outtab_before_call.
                gt_outtab_before_call[] = gt_outtab[].
*             ---------Anfang------------------------------"TK01082009/hint1371256

                CALL FUNCTION ls_tjksd130-wl_module
                  EXPORTING
                    in_change_mode = lv_change_mode " GV_DISPLAY
                    in_issue       = marked_issue.
*
*               Neustart der Transaktion (Daten werden neu eingelesen)
                CALL METHOD cl_gui_cfw=>set_new_ok_code
                  EXPORTING
*                   NEW_CODE = 'REFRESH'  "lv_ucomm              "TK16072009/hint1365757
                    new_code = 'REFRESH_INTERNAL'  "lv_ucomm     "TK16072009/hint1365757
                  IMPORTING
                    rc       = lv_rc.
              ENDIF.
            ELSE.
*             Check: One ore more issues must be marked
              CALL METHOD gv_list->get_marked_issues
                EXPORTING
                  i_statustab  = gt_statuslist_tab
                IMPORTING
                  e_issue_tab  = marked_issue_tab
                  e_mark_count = mark_count.
              IF mark_count = 0.
                MESSAGE s030(jksdworklist).
              ELSE.
*               call transaction (incl. Parameterübergabe)
*               Sicherheitsabfrage für Worklist
                IF NOT gv_recommend_save IS INITIAL.
                  PERFORM safety_check CHANGING safety_answer.
                  IF safety_answer = 'J'.
                    PERFORM save.
*                   lv_ucomm = 'REFRESH'.
                  ELSEIF safety_answer = 'A'.
*                    CLEAR PV_OK_CODE.
                    EXIT.
                  ENDIF.
                ENDIF.
*
                IF safety_answer = 'N'.
*                 Antwort auf Sicherheits-Popup = Nein
*                 => REFRESH ist notwendig
*                 => Sicherheitspopup nicht nochmal prozessieren
                  CLEAR gv_recommend_save.
                ENDIF.
*
*               call transaction (incl. Parameterübergabe)
                in_issue_tab[] = marked_issue_tab[].
                CALL FUNCTION ls_tjksd130-wl_module
                  EXPORTING
                    in_change_mode = lv_change_mode "GV_DISPLAY
                    in_issue_tab   = in_issue_tab.
*
*               Neustart der Transaktion (Daten werden neu eingelesen)
                CALL METHOD cl_gui_cfw=>set_new_ok_code
                  EXPORTING
*                   NEW_CODE = 'REFRESH'  "lv_ucomm            "TK16072009/hint1365757
                    new_code = 'REFRESH_INTERNAL'  "lv_ucomm   "TK16072009/hint1365757
                  IMPORTING
                    rc       = lv_rc.

              ENDIF. " MARK_COUNT = 0.
            ENDIF. " ls_tjksd130-WL_N_ISSUES is initial.
          ENDIF. " sy-subrc = 0.
        ENDIF. " gt_tjksd13[] not is initial.
*     *------------------- Ende ----------------------------"TK08022007

    ENDCASE.
  ENDMETHOD.                           "handle_user_command


ENDCLASS.                    "ISM_WORKLIST_LIST IMPLEMENTATION



*---------------------------------------------------------------------*
*       FORM GET_CHANGED_ENTRIES                                      *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  I_STATUSTAB                                                   *
*  -->  I_DBTAB                                                       *
*  -->  E_AMARA_UEB                                                   *
*  -->  E_AMARC_UEB                                                   *
*  -->  E_AMVKE_UEB                                                   *
*  -->  E_AMFIELDRES_TAB                                              *
*  -->  E_TRANC_TAB                                                   *
*  -->  E_XNO_CHANGES                                                 *
*---------------------------------------------------------------------*
FORM get_changed_entries
         USING     i_statustab TYPE status_tab_type
                   i_dbtab      TYPE status_tab_type
         CHANGING  e_amara_ueb  TYPE amara_tab
                   e_jptmara_tab TYPE jptmara_tab
                   e_amarc_ueb   TYPE amarc_tab
                   e_amvke_ueb   TYPE amvke_tab
                   e_amfieldres_tab  TYPE amfieldres_tab
                   e_tranc_tab TYPE tranc_tab
                   e_xno_changes TYPE xfeld.
*
  DATA: ls_dbtab      LIKE LINE OF i_dbtab,
        ls_statustab  LIKE LINE OF i_statustab,
        ls_amara_ueb  LIKE LINE OF e_amara_ueb,
        ls_amarc_ueb  LIKE LINE OF e_amarc_ueb,
        ls_amvke_ueb  LIKE LINE OF e_amvke_ueb,
        ls_amfieldres LIKE LINE OF e_amfieldres_tab,
        ls_tranc_stru LIKE LINE OF e_tranc_tab.
  DATA: con_datum_blank(8).
*
  DATA: h_tabix TYPE sy-tabix.
  DATA: h_mara TYPE mara.
  DATA: h_jptmara TYPE jptmara.                             "TK01102006
  DATA: jptmara_tab TYPE TABLE OF jptmara.                  "TK01102006
  DATA: mara_tab TYPE TABLE OF mara.
  DATA: h_marc TYPE marc.
  DATA: marc_tab TYPE TABLE OF marc.
  DATA: h_mvke TYPE mvke.
  DATA: mvke_tab TYPE TABLE OF mvke.
  DATA: save_ls_statustab LIKE LINE OF i_statustab.
  DATA: tranc_cnt LIKE sy-tabix.
*   MARA is also used , if no status in MARA is changed(if e.g.only(!)
*   MARC-Status is changed) => save-tab for real MARA-changes:
  TYPES: BEGIN OF mara_stru,
           matnr TYPE mara-matnr,
         END OF mara_stru,
         mara_real_update_tab TYPE TABLE OF mara_stru.
  DATA: mara_stru TYPE mara_stru.
  DATA: mara_real_update_tab TYPE mara_real_update_tab.
*   Flag XDBTAB_EMPTY:
*   - If DBTAB is empty: all entries in STATUSTAB
*                      are relevant for DB-(Status) Updates.
*   - If DBTAB is not empty: => compare STATUSTAB with DBTAB to
*                             find entries relevant for DB-Update
  DATA: xdbtab_empty TYPE xfeld.

  DATA: xmara_badifields_change TYPE xfeld.                 "TK01102006
  DATA: xjptmara_badifields_change TYPE xfeld.              "TK01102006
  DATA: xmarc_badifields_change TYPE xfeld.                 "TK01102006
  DATA: xmvke_badifields_change TYPE xfeld.                 "TK01102006
  DATA: xmara_badifields_change_save TYPE xfeld.            "TK01102006
  DATA: xjptmara_badi_change_save TYPE xfeld.               "TK01102006
  DATA: xmarc_badifields_change_save TYPE xfeld.            "TK01102006
  DATA: xmvke_badifields_change_save TYPE xfeld.            "TK01102006

*
*    setzuff : Ist das hier notwendig ???ß vermutlich ja
**   Make sure to raise the "ENTER" event now at the latestbb ???
*    CALL METHOD me->check_changed_data.
*



*   1. )Compare statustab/DBtab (indentically tables, ident. sorted )
*       => Fill for changed status MARA_TAB, MARC_TAB, MVKE_TAB
  CLEAR mara_tab. REFRESH mara_tab.
  CLEAR marc_tab. REFRESH marc_tab.
  CLEAR mvke_tab. REFRESH mvke_tab.
  CLEAR mara_real_update_tab. REFRESH mara_real_update_tab.
*   Check if DBTAB is relevant to compare with statustab
  READ TABLE i_dbtab INTO ls_dbtab INDEX 1.
  IF sy-subrc <> 0.
    xdbtab_empty = con_angekreuzt.
  ENDIF.
*
  DO.
    h_tabix = h_tabix + 1 .
    READ TABLE i_dbtab INTO ls_dbtab INDEX h_tabix.
    READ TABLE i_statustab INTO ls_statustab INDEX h_tabix.
    IF sy-subrc <> 0.
      EXIT.   "=> ENDDO
    ENDIF.
*   Check MARA
    IF NOT ls_statustab-xfirst_issue_line IS INITIAL.
      save_ls_statustab = ls_statustab.
*     ev. neue BADI Felder-------------------Anfang --------"TK01102006
      CLEAR xmara_badifields_change.
      CLEAR xjptmara_badifields_change.
      LOOP AT gt_badi_fields INTO gs_badi_field.
        IF gs_badi_field-fieldname(5) <> 'MARC_'    AND
           gs_badi_field-fieldname(5) <> 'MVKE_'    AND
           gs_badi_field-xinput       = 'X'.
          IF gs_badi_field-fieldname(8) = 'JPTMARA_'.
*           JPTMARA-Feld
            PERFORM check_badifield_changed  USING ls_statustab
                                                 ls_dbtab
                                                 gs_badi_field-fieldname
                                CHANGING xjptmara_badifields_change.
            IF xjptmara_badifields_change = con_angekreuzt.
              xjptmara_badi_change_save = con_angekreuzt.
            ENDIF. " xjptmara_badifields_change = con_Angekreuzt.
          ELSE.
*           MARA-Feld
            PERFORM check_badifield_changed  USING ls_statustab
                                                 ls_dbtab
                                                 gs_badi_field-fieldname
                                CHANGING xmara_badifields_change.
            IF xmara_badifields_change = con_angekreuzt.
              xmara_badifields_change_save = con_angekreuzt.
            ENDIF. " xmara_badifields_change = con_Angekreuzt.
          ENDIF.
        ENDIF.
      ENDLOOP. " at gt_badi_fields into gs_badi_field.
*     ev. neue BADI Felder-------------------Ende ----------"TK01102006
      IF ls_statustab-mstav <> ls_dbtab-mstav   OR
         ls_statustab-mstdv <> ls_dbtab-mstdv   OR
         ls_statustab-mstae <> ls_dbtab-mstae   OR
         ls_statustab-mstde <> ls_dbtab-mstde   OR
         ls_statustab-ismpubldate <> ls_dbtab-ismpubldate   OR
         ls_statustab-isminitshipdate <> ls_dbtab-isminitshipdate   OR
         ls_statustab-ismcopynr       <> ls_dbtab-ismcopynr         OR
         ls_statustab-ismpubldate     <> ls_dbtab-ismpubldate       OR "TK01042008
         xmara_badifields_change     = con_angekreuzt               OR "TK01102006
         xdbtab_empty       =  con_angekreuzt  .
        SELECT SINGLE * FROM mara INTO h_mara
          WHERE matnr = ls_statustab-matnr.
        IF sy-subrc <> 0.
*          BREAK-POINT. " MARA ??????
        ENDIF.
*         insert mara_tab
        h_mara-mstav = ls_statustab-mstav.
        h_mara-mstdv = ls_statustab-mstdv.
        h_mara-mstae = ls_statustab-mstae.
        h_mara-mstde = ls_statustab-mstde.
        h_mara-ismpubldate = ls_statustab-ismpubldate.
        h_mara-isminitshipdate = ls_statustab-isminitshipdate.
        h_mara-ismcopynr       = ls_statustab-ismcopynr.
        h_mara-ismpubldate     = ls_statustab-ismpubldate.  "TK01042008
*       ev. neue BADI Felder-------------------Anfang --------"TK01102006
        IF xmara_badifields_change = con_angekreuzt.
          LOOP AT gt_badi_fields INTO gs_badi_field.
            IF gs_badi_field-fieldname(5) <> 'MARC_'    AND
               gs_badi_field-fieldname(5) <> 'MVKE_'    AND
               gs_badi_field-fieldname(8) <> 'JPTMARA_' AND
                   gs_badi_field-xinput       = 'X'.
              PERFORM mara_badifields_to_h_mara  USING ls_statustab
                                                       h_mara
                                                       gs_badi_field-fieldname.
            ENDIF.
          ENDLOOP. " at gt_badi_fields into gs_badi_field.
        ENDIF. " xmara_badifields_change = con_angekreuzt.
*       ev. neue BADI Felder-------------------Ende ----------"TK01102006

        APPEND h_mara TO mara_tab.
*         insert mara_real_update_tab
        mara_stru-matnr = ls_statustab-matnr.
        APPEND mara_stru TO mara_real_update_tab.
      ENDIF.

*     Check JPTMARA-BADIFIELDS------------------ Anfang------"TK01102006
      IF xjptmara_badifields_change  = con_angekreuzt.
        SELECT SINGLE * FROM jptmara INTO h_jptmara
          WHERE matnr = ls_statustab-matnr.
        IF sy-subrc = 0.
*         JPTMARA-Satz ist schon vorhanden
          LOOP AT gt_badi_fields INTO gs_badi_field.
            IF gs_badi_field-fieldname(8) = 'JPTMARA_'.
              PERFORM jptmara_badi_to_h_jptmara  USING ls_statustab
                                                       h_jptmara
                                                       gs_badi_field-fieldname.
            ENDIF.
          ENDLOOP. " at gt_badi_fields into gs_badi_field.
          APPEND h_jptmara TO jptmara_tab.
        ELSE.
*         JPTMARA-Satz ist noch nicht vorhanden
          LOOP AT gt_badi_fields INTO gs_badi_field.
            IF gs_badi_field-fieldname(8) = 'JPTMARA_'.
              PERFORM jptmara_badi_to_h_jptmara  USING ls_statustab
                                                       h_jptmara
                                                       gs_badi_field-fieldname.
            ENDIF.
          ENDLOOP. " at gt_badi_fields into gs_badi_field.
          h_jptmara-mandt = sy-mandt.
          h_jptmara-matnr = ls_statustab-matnr.
          APPEND h_jptmara TO jptmara_tab.
        ENDIF.
      ENDIF. " xjptmara_badifields_change  = con_angekreuzt
*     Check JPTMARA-BADIFIELDS------------------ Ende--------"TK01102006

    ENDIF.
*     Check MARC
    IF NOT ls_statustab-marc_werks IS INITIAL.
*     ev. neue BADI Felder-------------------Anfang --------"TK01102006
      CLEAR xmarc_badifields_change.
      LOOP AT gt_badi_fields INTO gs_badi_field.
        IF gs_badi_field-fieldname(5) = 'MARC_'    AND
           gs_badi_field-xinput       = 'X'.
          PERFORM check_badifield_changed  USING ls_statustab
                                               ls_dbtab
                                               gs_badi_field-fieldname
                              CHANGING xmarc_badifields_change.
          IF xmarc_badifields_change = con_angekreuzt.
            xmarc_badifields_change_save = con_angekreuzt.
          ENDIF. " xmarc_badifields_change = con_Angekreuzt.
        ENDIF.
      ENDLOOP. " at gt_badi_fields into gs_badi_field.
*     ev. neue BADI Felder-------------------Ende ----------"TK01102006
      IF ls_statustab-marc_mmsta <> ls_dbtab-marc_mmsta OR
         ls_statustab-marc_mmstd <> ls_dbtab-marc_mmstd OR
         ls_statustab-marc_ismpurchasedate <>
                          ls_dbtab-marc_ismpurchasedate OR
         ls_statustab-marc_ismarrivaldatepl <>
                         ls_dbtab-marc_ismarrivaldatepl OR
         ls_statustab-marc_ismarrivaldateac <>
                         ls_dbtab-marc_ismarrivaldateac OR
         xmarc_badifields_change     = con_angekreuzt   OR  "TK01102006
         xdbtab_empty       =  con_angekreuzt  .
        SELECT SINGLE * FROM marc INTO h_marc
          WHERE matnr = ls_statustab-matnr
          AND   werks = ls_statustab-marc_werks.
        IF sy-subrc <> 0.
*         BREAK-POINT. " MARC ??????
        ENDIF.
*         insert marc_tab
        h_marc-mmsta = ls_statustab-marc_mmsta.
        h_marc-mmstd = ls_statustab-marc_mmstd.
        h_marc-ismpurchasedate = ls_statustab-marc_ismpurchasedate.
        h_marc-ismarrivaldatepl = ls_statustab-marc_ismarrivaldatepl.
        h_marc-ismarrivaldateac = ls_statustab-marc_ismarrivaldateac.
*       ev. neue BADI Felder-------------------Anfang --------"TK01102006
        IF xmarc_badifields_change = con_angekreuzt.
          LOOP AT gt_badi_fields INTO gs_badi_field.
            IF gs_badi_field-fieldname(5) = 'MARC_'    AND
               gs_badi_field-xinput       = 'X'.
              PERFORM marc_badifields_to_h_marc  USING ls_statustab
                                                       h_marc
                                                       gs_badi_field-fieldname.
            ENDIF.
          ENDLOOP. " at gt_badi_fields into gs_badi_field.
        ENDIF. " xmarc_badifields_change = con_angekreuzt.
*       ev. neue BADI Felder-------------------Ende ----------"TK01102006
        APPEND h_marc TO marc_tab.
*         Check: MARA_TAB filled ?
        READ TABLE mara_tab WITH KEY mandt = sy-mandt
                                matnr = ls_statustab-matnr
                           INTO h_mara.
        IF sy-subrc <> 0.
          SELECT SINGLE * FROM mara INTO h_mara
            WHERE matnr = ls_statustab-matnr.
          IF sy-subrc <> 0.
*            BREAK-POINT. " MARA ??????
          ENDIF.
*           insert mara_tab
          h_mara-mstav = save_ls_statustab-mstav.
          h_mara-mstdv = save_ls_statustab-mstdv.
          h_mara-mstae = save_ls_statustab-mstae.
          h_mara-mstde = save_ls_statustab-mstde.
          h_mara-ismpubldate = save_ls_statustab-ismpubldate.
          h_mara-isminitshipdate = save_ls_statustab-isminitshipdate.
          h_mara-ismcopynr       = save_ls_statustab-ismcopynr.
          APPEND h_mara TO mara_tab.
        ENDIF.
      ENDIF.
    ENDIF.
*     Check MVKE
    IF NOT ls_statustab-mvke_vkorg IS INITIAL.
*     ev. neue BADI Felder-------------------Anfang --------"TK01102006
      CLEAR xmvke_badifields_change.
      LOOP AT gt_badi_fields INTO gs_badi_field.
        IF gs_badi_field-fieldname(5) = 'MVKE_'    AND
           gs_badi_field-xinput       = 'X'.
          PERFORM check_badifield_changed USING ls_statustab
                                               ls_dbtab
                                               gs_badi_field-fieldname
                              CHANGING xmvke_badifields_change.
          IF xmvke_badifields_change = con_angekreuzt.
            xmvke_badifields_change_save = con_angekreuzt.
          ENDIF. " xmvke_badifields_change = con_Angekreuzt.
        ENDIF.
      ENDLOOP. " at gt_badi_fields into gs_badi_field.
*     ev. neue BADI Felder-------------------Ende ----------"TK01102006
      IF ls_statustab-mvke_vmsta <> ls_dbtab-mvke_vmsta  OR
         ls_statustab-mvke_vmstd <> ls_dbtab-mvke_vmstd  OR
         ls_statustab-mvke_isminitshipdate <>
                          ls_dbtab-mvke_isminitshipdate  OR
         ls_statustab-mvke_ismonsaledate <>
                          ls_dbtab-mvke_ismonsaledate    OR
         ls_statustab-mvke_ismoffsaledate <>
                          ls_dbtab-mvke_ismoffsaledate   OR
         ls_statustab-mvke_isminterrupt <>
                          ls_dbtab-mvke_isminterrupt     OR
         ls_statustab-mvke_isminterruptdate <>
                          ls_dbtab-mvke_isminterruptdate OR
         ls_statustab-mvke_ismcolldate <>
                          ls_dbtab-mvke_ismcolldate      OR
         ls_statustab-mvke_ismreturnbegin <>
                          ls_dbtab-mvke_ismreturnbegin   OR
         ls_statustab-mvke_ismreturnend <>
                       ls_dbtab-mvke_ismreturnend        OR
         xmvke_badifields_change     = con_angekreuzt    OR "TK01102006
         xdbtab_empty       =  con_angekreuzt  .
        SELECT SINGLE * FROM mvke INTO h_mvke
          WHERE matnr = ls_statustab-matnr
          AND   vkorg = ls_statustab-mvke_vkorg
          AND   vtweg = ls_statustab-mvke_vtweg.
        IF sy-subrc <> 0.
*          BREAK-POINT. " MVKE ??????
        ENDIF.
*         insert mvke_tab
        h_mvke-vmsta = ls_statustab-mvke_vmsta.
        h_mvke-vmstd = ls_statustab-mvke_vmstd.
        h_mvke-isminitshipdate = ls_statustab-mvke_isminitshipdate.
        h_mvke-ismonsaledate = ls_statustab-mvke_ismonsaledate.
        h_mvke-ismoffsaledate = ls_statustab-mvke_ismoffsaledate.
        h_mvke-isminterrupt = ls_statustab-mvke_isminterrupt.
        h_mvke-isminterruptdate = ls_statustab-mvke_isminterruptdate.
        h_mvke-ismcolldate = ls_statustab-mvke_ismcolldate.
        h_mvke-ismreturnbegin = ls_statustab-mvke_ismreturnbegin.
        h_mvke-ismreturnend = ls_statustab-mvke_ismreturnend.
*       ev. neue BADI Felder-------------------Anfang --------"TK01102006
        IF xmvke_badifields_change = con_angekreuzt.
          LOOP AT gt_badi_fields INTO gs_badi_field.
            IF gs_badi_field-fieldname(5) = 'MVKE_'    AND
               gs_badi_field-xinput       = 'X'.
              PERFORM mvke_badifields_to_h_mvke  USING ls_statustab
                                                       h_mvke
                                                       gs_badi_field-fieldname.
            ENDIF.
          ENDLOOP. " at gt_badi_fields into gs_badi_field.
        ENDIF. " xmvke_badifields_change = con_angekreuzt.
*       ev. neue BADI Felder-------------------Ende ----------"TK01102006
        APPEND h_mvke TO mvke_tab.
*         Check: MARA_TAB filled ?
        READ TABLE mara_tab WITH KEY mandt = sy-mandt
                                matnr = ls_statustab-matnr
                           INTO h_mara.
        IF sy-subrc <> 0.
          SELECT SINGLE * FROM mara INTO h_mara
            WHERE matnr = ls_statustab-matnr.
          IF sy-subrc <> 0.
*            BREAK-POINT. " MARA ??????
          ENDIF.
*           insert mara_tab
          h_mara-mstav = save_ls_statustab-mstav.
          h_mara-mstdv = save_ls_statustab-mstdv.
          h_mara-mstae = save_ls_statustab-mstae.
          h_mara-mstde = save_ls_statustab-mstde.
          h_mara-ismpubldate = save_ls_statustab-ismpubldate.
          h_mara-isminitshipdate = save_ls_statustab-isminitshipdate.
          h_mara-ismcopynr       = save_ls_statustab-ismcopynr.
          APPEND h_mara TO mara_tab.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDDO.
*
* 2.) Prepare E_AMARA/MARC/MVKE_UEB and E_AMFIELDRES_TAB
*     for MAINTAIN_DARK (based on MARA/MARC/MVKE_TAB)
  CLEAR e_amara_ueb. REFRESH e_amara_ueb.
  CLEAR e_amarc_ueb. REFRESH e_amarc_ueb.
  CLEAR e_amvke_ueb. REFRESH e_amvke_ueb.
  CLEAR e_amfieldres_tab. REFRESH e_amfieldres_tab.
  CLEAR e_tranc_tab. REFRESH e_tranc_tab.
  CLEAR tranc_cnt.
*
  SORT mara_tab BY mandt matnr.
  SORT mara_real_update_tab.
  SORT marc_tab BY mandt matnr werks.
  SORT mvke_tab BY mandt matnr vkorg vtweg.
*
  LOOP AT mara_tab INTO h_mara.
    tranc_cnt = tranc_cnt + 1.
*     Check: MARA CHANGE ?
    READ TABLE mara_real_update_tab
                            WITH KEY matnr  = h_mara-matnr
                              BINARY SEARCH
                              INTO mara_stru.
    IF sy-subrc = 0.
*     MARA change
      PERFORM mara_change TABLES e_amara_ueb
                      USING    h_mara tranc_cnt
                      CHANGING e_tranc_tab.
      IF h_mara-mstav IS INITIAL.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARA-MSTAV'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
*       if status is inital, corresponding date is deleted
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARA-MSTDV'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mara-mstdv IS INITIAL OR
         h_mara-mstdv EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARA-MSTDV'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mara-mstae IS INITIAL.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARA-MSTAE'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
*       if status is inital, corresponding date is deleted
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARA-MSTDE'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mara-mstde IS INITIAL OR
         h_mara-mstde EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARA-MSTDE'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mara-ismpubldate IS INITIAL OR
         h_mara-ismpubldate EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARA-ISMPUBLDATE'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mara-isminitshipdate IS INITIAL OR
         h_mara-isminitshipdate EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARA-ISMINITSHIPDATE'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mara-ismcopynr       IS INITIAL.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARA-ISMCOPYNR'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
*     ev. neue BADI Felder-------------------Anfang --------"TK01102006
      IF xmara_badifields_change_save = con_angekreuzt.
        LOOP AT gt_badi_fields INTO gs_badi_field.
          IF gs_badi_field-fieldname(5) <> 'MARC_'     AND
            gs_badi_field-fieldname(5)  <> 'MVKE_'     AND
            gs_badi_field-fieldname(8)  <> 'JPTMARA_'  AND
            gs_badi_field-xinput        =  'X'.
            CLEAR ls_amfieldres.
            ls_amfieldres-tranc = tranc_cnt.
            PERFORM mara_badifields_to_amfieldres  USING h_mara
                                                     gs_badi_field-fieldname
                                            CHANGING ls_amfieldres
                                                     e_amfieldres_tab.
          ENDIF.
        ENDLOOP. " at gt_badi_fields into gs_badi_field.
      ENDIF. " xmara_badifields_change_save = con_angekreuzt.
*
      IF xjptmara_badi_change_save = con_angekreuzt.
*       für ISM_PMD_JPTMARA_MAINTAIN_DARK ist keine AMFIELDRES_TAB
*       für die Feld-Initialisierung notwendig.
*       Jeder initiale Feldwert in der JPTMARA-Tabelle wird initial
*       auf die Datenbank geschrieben.
*       => hier ist für JPTMARA nichts zu tun
      ENDIF. " xjptmara_badi_change_save = con_angekreuzt.

*     ev. neue BADI Felder-------------------Ende ----------"TK01102006
    ENDIF.

*   MARC Change
    LOOP AT marc_tab INTO h_marc
      WHERE matnr = h_mara-matnr.
      tranc_cnt = tranc_cnt + 1.
*     MARA change (MARC_UEB hat keinen TCODE!)
      PERFORM mara_change_duplikat TABLES e_amara_ueb
                      USING    h_mara tranc_cnt.
*                        CHANGING E_TRANC_TAB.
*     MARC Change
      PERFORM marc_change TABLES e_amarc_ueb
                          USING  h_marc h_mara tranc_cnt
                       CHANGING e_tranc_tab.
      IF h_marc-mmsta IS INITIAL.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARC-MMSTA'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
*       if status is inital, corresponding date is deleted
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARC-MMSTD'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_marc-mmstd IS INITIAL OR
         h_marc-mmstd EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARC-MMSTD'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_marc-ismpurchasedate IS INITIAL OR
         h_marc-ismpurchasedate EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARC-ISMPURCHASEDATE'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_marc-ismarrivaldatepl IS INITIAL OR
         h_marc-ismarrivaldatepl EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARC-ISMARRIVALDATEPL'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_marc-ismarrivaldateac IS INITIAL OR
         h_marc-ismarrivaldateac EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MARC-ISMARRIVALDATEAC'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
*     ev. neue BADI Felder-------------------Anfang --------"TK01102006
      IF xmarc_badifields_change_save = con_angekreuzt.
        LOOP AT gt_badi_fields INTO gs_badi_field.
          IF gs_badi_field-fieldname(5) = 'MARC_'    AND
            gs_badi_field-xinput       = 'X'.
            CLEAR ls_amfieldres.
            ls_amfieldres-tranc = tranc_cnt.
            PERFORM marc_badifields_to_amfieldres  USING h_marc
                                                     gs_badi_field-fieldname
                                            CHANGING ls_amfieldres
                                                     e_amfieldres_tab.
          ENDIF.
        ENDLOOP. " at gt_badi_fields into gs_badi_field.
      ENDIF. " xmarc_badifields_change_save = con_angekreuzt.
*     ev. neue BADI Felder-------------------Ende ----------"TK01102006
    ENDLOOP.
*
*     MVKE Change
    LOOP AT mvke_tab INTO h_mvke
      WHERE matnr = h_mara-matnr.
      tranc_cnt = tranc_cnt + 1.
*       MARA change (MVKE_UEB hat keinen TCODE!)
      PERFORM mara_change_duplikat TABLES e_amara_ueb
                      USING    h_mara tranc_cnt.
*                        CHANGING E_TRANC_TAB.
*       MVKE Change
      PERFORM mvke_change TABLES e_amvke_ueb
                          USING  h_mvke h_mara tranc_cnt
                        CHANGING e_tranc_tab.
      IF h_mvke-vmsta IS INITIAL.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MVKE-VMSTA'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
*       if status is inital, corresponding date is deleted
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MVKE-VMSTD'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mvke-vmstd IS INITIAL OR
         h_mvke-vmstd EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MVKE-VMSTD'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mvke-isminitshipdate IS INITIAL OR
         h_mvke-isminitshipdate EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MVKE-ISMINITSHIPDATE'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mvke-ismonsaledate IS INITIAL OR
         h_mvke-ismonsaledate EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MVKE-ISMONSALEDATE'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mvke-ismoffsaledate IS INITIAL OR
         h_mvke-ismoffsaledate EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MVKE-ISMOFFSALEDATE'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mvke-isminterrupt IS INITIAL.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MVKE-ISMINTERRUPT'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mvke-isminterruptdate IS INITIAL OR
         h_mvke-isminterruptdate EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MVKE-ISMINTERRUPTDATE'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
*       if date is inital, corresponding xflag is deleted
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MVKE-ISMINTERRUPT'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mvke-ismcolldate IS INITIAL OR
         h_mvke-ismcolldate EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MVKE-ISMCOLLDATE'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mvke-ismreturnbegin IS INITIAL OR
         h_mvke-ismreturnbegin EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MVKE-ISMRETURNBEGIN'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
      IF h_mvke-ismreturnend IS INITIAL OR
         h_mvke-ismreturnend EQ con_datum_blank.
        CLEAR ls_amfieldres.
        ls_amfieldres-fname = 'MVKE-ISMRETURNEND'.
        ls_amfieldres-tranc = tranc_cnt.
        APPEND ls_amfieldres TO e_amfieldres_tab.
      ENDIF.
*     ev. neue BADI Felder-------------------Anfang --------"TK01102006
      IF xmvke_badifields_change_save = con_angekreuzt.
        LOOP AT gt_badi_fields INTO gs_badi_field.
          IF gs_badi_field-fieldname(5) = 'MVKE_'    AND
            gs_badi_field-xinput       = 'X'.
            CLEAR ls_amfieldres.
            ls_amfieldres-tranc = tranc_cnt.
            PERFORM mvke_badifields_to_amfieldres  USING h_mvke
                                                     gs_badi_field-fieldname
                                            CHANGING ls_amfieldres
                                                     e_amfieldres_tab.
          ENDIF.
        ENDLOOP. " at gt_badi_fields into gs_badi_field.
      ENDIF. " xmarc_badifields_change_save = con_angekreuzt.
*     ev. neue BADI Felder-------------------Ende ----------"TK01102006

    ENDLOOP.
  ENDLOOP.
*
* JPTMARA_TAB in Ausgabetabelle E_JPTMARA_TAB übernehmen      "TK01102006
  CLEAR e_jptmara_tab. REFRESH e_jptmara_tab.               "TK01102006
  e_jptmara_tab[] = jptmara_tab[].                          "TK01102006
  SORT e_jptmara_tab BY mandt matnr .                       "TK01102006

*   Check, if changes were done
  IF e_amara_ueb[] IS INITIAL   AND
     e_amarc_ueb[] IS INITIAL   AND
     e_amvke_ueb[] IS INITIAL   AND
     e_jptmara_tab[] IS INITIAL .                           "TK01102006
    e_xno_changes = con_angekreuzt.
  ELSE.
    CLEAR e_xno_changes.
  ENDIF.
*
ENDFORM.                    "GET_CHANGED_ENTRIES


*&--------------------------------------------------------------------*
*&      Form  POPUP_FUER_default
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
*      -->DEFAULT_STAtext
*      -->DEFAULT_DATtext
*      -->POPUP_STATUtext
*      -->G_CANCEL   text
*---------------------------------------------------------------------*
FORM popup_fuer_default
                          USING lt_index_rows  TYPE lvc_t_row
                          CHANGING rjksd13-marked_date
                                   rjksd13-mstav
                                   rjksd13-mstae
                                   rjksd13-xonly_marked_columns
                                   popup_status.
*
* Init
  CLEAR popup_status.
  CLEAR gv_cancel.
  CLEAR rjksd13-marked_date.
  CLEAR rjksd13-mstav.
  CLEAR rjksd13-mstae.
*
* Vorbelegung des Popup-Flags: "nur markierte Zeilen" abhängig
* davon, ob Zeilen markiert sind:
  READ TABLE lt_index_rows INDEX 1 TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    rjksd13-xonly_marked_columns = con_angekreuzt.
  ELSE.
    CLEAR rjksd13-xonly_marked_columns.
  ENDIF.
*
  CALL SCREEN 700 STARTING AT 40 15                         "#EC *
*            ENDING AT 90 16.                               "TK01102006
             ENDING AT 90 20.                               "TK01102006

*
  IF NOT gv_cancel IS INITIAL.
    popup_status = con_popupstatus_abort.
  ENDIF.
*
ENDFORM.                    "POPUP_FUER_MIGRATION_PATTERN



*&---------------------------------------------------------------------*
*&      Form  call_worklist_text
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR         text
*      -->TEXT_ACTION     text
*      -->DBA_SELLIST     text
*      -->EXCL_CUA_FUNCT  text
*----------------------------------------------------------------------*
FORM call_worklist_text USING p_matnr text_action           "TK01102006
    CHANGING dba_sellist TYPE rj_vimsellist_tab
             excl_cua_funct TYPE rj_vimexclfun_tab .

*
  DATA: ls_excl_cua_funct TYPE vimexclfun.
*
  CLEAR dba_sellist. REFRESH dba_sellist.
*
  IF NOT p_matnr IS INITIAL.
    PERFORM sellist_append USING  'MEDIAISSUE' p_matnr   'EQ' 'AND'
                           CHANGING dba_sellist .
  ENDIF.

  IF excl_cua_funct[] IS INITIAL.
*   F-Codes werden ausgeschlossen
    ls_excl_cua_funct-function = 'COMP' .
    APPEND ls_excl_cua_funct TO excl_cua_funct .

    ls_excl_cua_funct-function = 'CMPO' .
    APPEND ls_excl_cua_funct TO excl_cua_funct .

    ls_excl_cua_funct-function = 'CMPR' .
    APPEND ls_excl_cua_funct TO excl_cua_funct .

    ls_excl_cua_funct-function = 'ORDR' .
    APPEND ls_excl_cua_funct TO excl_cua_funct .

    ls_excl_cua_funct-function = 'ALCO' .
    APPEND ls_excl_cua_funct TO excl_cua_funct .

    ls_excl_cua_funct-function = 'ALNC' .
    APPEND ls_excl_cua_funct TO excl_cua_funct .

    ls_excl_cua_funct-function = 'TRIN' .
    APPEND ls_excl_cua_funct TO excl_cua_funct .

    ls_excl_cua_funct-function = 'TREX' .
    APPEND ls_excl_cua_funct TO excl_cua_funct .

    ls_excl_cua_funct-function = 'TRSP' .
    APPEND ls_excl_cua_funct TO excl_cua_funct .

*   If DISPLAY no CHANGE-Pushbutton in SM30          "TK01102006
    IF sy-tcode = con_tcode_display.                        "TK01102006
      ls_excl_cua_funct-function = 'AEND' .                 "TK01102006
      APPEND ls_excl_cua_funct TO excl_cua_funct .          "TK01102006
    ENDIF.                                                  "TK01102006
  ENDIF. " EXCL_CUA_FUNCT[] is initial.              "TK01102006

* --auf TABLEFRAME_JKSDWORKLIST umgestellt--Anfang-- TK01072008/hint 1226213

* Grund: VIEW_MAINTENANCE_CALL setzt globale Sperre auf JKSDWORKLISTTEXT

  CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
    EXPORTING
      action         = text_action        " 'U'
      view_name      = 'V_JKSDWORKLSTTXT'
    TABLES
      dba_sellist    = dba_sellist
      excl_cua_funct = excl_cua_funct.

*  DATA: BEGIN OF HEADER_JKSDWORKLISTTEXT OCCURS 1.
*          INCLUDE STRUCTURE VIMDESC.
*  DATA: END   OF HEADER_JKSDWORKLISTTEXT.
** Kontrollblocktabelle für die Textviewfelder
*  DATA: BEGIN OF NAMTAB_JKSDWORKLISTTEXT OCCURS 20.
*          INCLUDE STRUCTURE VIMNAMTAB.
*  DATA: END   OF NAMTAB_JKSDWORKLISTTEXT.
** Tabelle der Selektionsbedingungen für den Arbeitsbereich der View
*  DATA: BEGIN OF RANGETAB_JKSDWORKLISTTEXT OCCURS 15.
*          INCLUDE STRUCTURE VIMSELLIST.
*  DATA: END   OF RANGETAB_JKSDWORKLISTTEXT.
*
** Kontrollblöcke initialisieren:
*  CLEAR   HEADER_JKSDWORKLISTTEXT.
*  REFRESH HEADER_JKSDWORKLISTTEXT.
*  CLEAR   NAMTAB_JKSDWORKLISTTEXT.
*  REFRESH NAMTAB_JKSDWORKLISTTEXT.
** Selektionstabelle intialisieren:
*  CLEAR   RANGETAB_JKSDWORKLISTTEXT.
*  REFRESH RANGETAB_JKSDWORKLISTTEXT.
*  CALL FUNCTION 'VIEW_GET_DDIC_INFO'
*    EXPORTING
*      VIEWNAME        = 'JKSDWORKLISTTEXT' "CON_VIEWNAME
*    TABLES
*      X_HEADER        = HEADER_JKSDWORKLISTTEXT
*      X_NAMTAB        = NAMTAB_JKSDWORKLISTTEXT
*      SELLIST         = RANGETAB_JKSDWORKLISTTEXT
*    EXCEPTIONS
*      NO_TVDIR_ENTRY  = 1
*      TABLE_NOT_FOUND = 2.
*  CASE SYST-SUBRC.
*    WHEN 1. MESSAGE ID 'JV' TYPE 'A' NUMBER 541 WITH 'JKSDWORKLISTTEXT'. "CON_VIEWNAME.
*    WHEN 2. MESSAGE ID 'JV' TYPE 'A' NUMBER 542 WITH 'JKSDWORKLISTTEXT'. "CON_VIEWNAME.
*  ENDCASE. " SYST-SUBRC.
**
*  CALL FUNCTION 'TABLEFRAME_JKSDWORKLIST'
*      EXPORTING VIEW_ACTION     = text_action
*                VIEW_NAME       = 'JKSDWORKLISTTEXT'  " CON_VIEWNAME
**                CORR_NUMBER     = ' '
*      TABLES    X_HEADER        = HEADER_JKSDWORKLISTTEXT
*                X_NAMTAB        = NAMTAB_JKSDWORKLISTTEXT
*                DBA_SELLIST     = DBA_SELLIST    "RANGETAB_JVVDSPTR
*                DPL_SELLIST     = DBA_SELLIST
*                EXCL_CUA_FUNCT  = EXCL_CUA_FUNCT " FU_TO_EXCL
*      EXCEPTIONS
*                MISSING_CORR_NUMBER       = 2.

* --auf TABLEFRAME_JKSDWORKLIST umgestellt--Ende---- TK01072008/hint 1226213

*
ENDFORM. " call_worklist_text using p_matnr.                "TK01102006

*---------------------------------------------------------------------*
FORM sellist_append USING  vfield  fieldval  op  and_or     "TK01102006
    CHANGING dba_sellist TYPE rj_vimsellist_tab .

*---------------------------------------------------------------------*
*
  DATA: ls_dba_sellist TYPE vimsellist.
*
  IF NOT fieldval IS INITIAL .
    MOVE: vfield       TO ls_dba_sellist-viewfield,
          space        TO ls_dba_sellist-negation,
          op           TO ls_dba_sellist-operator,
          fieldval     TO ls_dba_sellist-value,
          and_or       TO ls_dba_sellist-and_or.

    MOVE  2            TO ls_dba_sellist-tabix." <= 2 Feld im view !!
    "TK01072008/hint 1226213


    APPEND ls_dba_sellist TO dba_sellist.
  ENDIF .
ENDFORM.                                                    "TK01102006



*&---------------------------------------------------------------------*
*&      Form  STATUS_STRU_text_icon_fill
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MATNR      text
*      -->P_TEXT_ICON  text
*----------------------------------------------------------------------*
FORM status_stru_text_icon_fill USING p_matnr               "TK01102006
                             CHANGING p_text_icon.
*
  DATA: lv_icon_quick TYPE iconquick,
        lv_icon_name  TYPE iconname,
        lv_icon_text  TYPE text30.
  DATA: ls_text TYPE jksdworklisttext .
*
  SELECT * FROM jksdworklisttext INTO ls_text
    WHERE mediaissue = p_matnr.
    EXIT.
  ENDSELECT.
  IF sy-subrc = 0.
*   text vorhanden
    lv_icon_text = text-601.
    lv_icon_name = 'ICON_TEXT_ACT'. "gv_icon_text_active.
  ELSE.
*   kein text vorhanden
    lv_icon_text = text-600.
    lv_icon_name = 'ICON_TEXT_INA'.  "gv_icon_text_inactive.
  ENDIF.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                  = lv_icon_name
      info                  = lv_icon_text
    IMPORTING
      result                = p_text_icon
    EXCEPTIONS
      icon_not_found        = 1
      outputfield_too_short = 2
      OTHERS                = 3.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
*
ENDFORM. " STATUS_STRU_text_icon_fill using p_matnr       "TK01102006

*&---------------------------------------------------------------------*
*&      Form  check_badifields_marked
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LT_INDEX_COLUMNS   text
*      -->XBADIFIELD_MARKED  text
*----------------------------------------------------------------------*
FORM check_badifields_marked                                "TK01102006
           USING lt_index_columns TYPE lvc_t_col            "TK01102006
                 CHANGING xbadifield_marked.                "TK01102006
*
  DATA: ls_index_columns LIKE LINE OF lt_index_columns.
*
  CLEAR xbadifield_marked.
*
  LOOP AT lt_index_columns INTO ls_index_columns.
    READ TABLE gt_badi_fields INTO gs_badi_field
      WITH KEY ls_index_columns-fieldname.
    IF sy-subrc = 0.
*     Markierte Spalte ist ein BADI-Feld
      xbadifield_marked = con_angekreuzt.
    ENDIF.
  ENDLOOP.
*
ENDFORM. " check_badifields_marked                        "TK01102006


*&---------------------------------------------------------------------*
*&      Form  SAFETY_CHECK
*&---------------------------------------------------------------------*
FORM safety_check CHANGING answer TYPE c.

  answer = 'N'.
  CALL FUNCTION 'POPUP_TO_CONFIRM_DATA_LOSS'
    EXPORTING
      titel  = text-001
    IMPORTING
      answer = answer.

ENDFORM.                               " SAFETY_CHECK

*&---------------------------------------------------------------------*
*&      Form  save
*&---------------------------------------------------------------------*
FORM save .

  DATA: n LIKE sy-tabix.
  DATA: lv_subrc TYPE sy-subrc.
  DATA: err_cnt TYPE sy-tabix.
  DATA: xno_changes LIKE con_angekreuzt.
  DATA: xalog_active LIKE con_angekreuzt VALUE 'X'.
  DATA: xtest TYPE xfeld.  "initial => Updates are active

  CALL METHOD gv_variant_tree->save_required
    EXCEPTIONS
      not_required = 1
      OTHERS       = 2.
  IF sy-subrc <> 1.
    CALL METHOD gv_variant_tree->save_to_database
      EXCEPTIONS
        save_failed = 1
        OTHERS      = 2.
    IF sy-subrc = 0.
      COMMIT WORK.
      IF n = 0.
        MESSAGE s027(jksdworklist).
      ENDIF.
    ELSE.
      ROLLBACK WORK.
      MESSAGE e025(jksdworklist) WITH sy-subrc.
    ENDIF.
  ENDIF.

  CLEAR gv_recommend_save.

  CALL METHOD gv_list->get_changed_entries
    EXPORTING
      i_statustab      = gt_statuslist_tab
      i_dbtab          = gt_dbtab
    IMPORTING
      e_amara_ueb      = gt_amara_ueb
      e_jptmara_tab    = gt_jptmara_tab                     "TK01102006
      e_amarc_ueb      = gt_amarc_ueb
      e_amvke_ueb      = gt_amvke_ueb
      e_amfieldres_tab = gt_amfieldres_tab
      e_tranc_tab      = gt_tranc_tab
      e_xno_changes    = xno_changes.


  IF xno_changes = con_angekreuzt.
    MESSAGE s018(jksdworklist).  "WITH lv_count.
  ELSE.
    PERFORM maintain_dark TABLES gt_amara_ueb gt_amarc_ueb gt_amvke_ueb
                                 gt_amfieldres_tab gt_tranc_tab
                                 gt_error_tab    "hier dummy(ALOG aktiv)
                          USING  xalog_active    " Alog ist hier aktiv
                                 xtest           "hier generell Echtlauf
                                 xretail
                                 gt_jptmara_tab             "TK01102006
                                 gt_mara_db                 "TK01042008
                                 gt_marc_db                 "TK01042008
                                 gt_mvke_db                 "TK01042008
                                 gv_wl_enq_active           "TK01042008
                        CHANGING lv_subrc err_cnt.
*   (MAÌNTAIN_DARK ist hier Form und keine Methode! Grund:
*    Parameter von Methoden dürfen  nicht veränder werden
*    FUBA MAINTAIN_DARK führt SORT auf Material-Tabellen aus => DUMP)
    IF lv_subrc = 0.
      COMMIT WORK.
      MESSAGE s019(jksdworklist).  "WITH lv_count.
    ELSE.
*      ROLLBACK WORK.    "Rollback zu mächtig
*      Alle Änderungen, die möglich sind, werden durchgeführt,
*      Änderungen die nicht möglich sind, werden protokolliert
      COMMIT WORK.
      xshow_error_alog = con_angekreuzt.  "init bei PBO

*     Anzahl der Fehlermeldung (ERR_CNT) repräsentiert NICHT mehr die
*     Anzahl nicht geänderter Status. Dieser Zähler ist inzwichen nicht
*     mehr eindeutig auf Anzahl Status-fehler zurrückzuführen (Bsp. bei
*     Sperrkonflikt landet ein(!) Satz in der Fehlertabelle, es werden
*     aber Änderungen ALLER(!) Segmente nicht durchgeführt!!

      MESSAGE s036(jksdworklist). " WITH ERR_CNT.
    ENDIF.
  ENDIF.
*
  CLEAR gv_recommend_save.
*
ENDFORM.                    "SAVE

* --- Anfang-----------optimistisches Sperren------------- "TK01042008
FORM input_segments_identify  TABLES gt_fieldcat
                            CHANGING xmara_input_active
                                     xmarc_input_active
                                     xmvke_input_active
                                     gt_mara_input_fields TYPE rjp_fieldname_tab
                                     gt_marc_input_fields TYPE rjp_fieldname_tab
                                     gt_mvke_input_fields TYPE rjp_fieldname_tab.

*
  DATA: ls_fieldname TYPE rjp_fieldname.
*
* Aus dem letztendlich gültigen Feldkatalog werden die Segmente
* bestimmt, die Eingabefelder haben.
*
  CLEAR xmara_input_active.
  CLEAR xmarc_input_active.
  CLEAR xmvke_input_active.
  CLEAR gt_mara_input_fields. REFRESH gt_mara_input_fields.
  CLEAR gt_marc_input_fields. REFRESH gt_marc_input_fields.
  CLEAR gt_mvke_input_fields. REFRESH gt_mvke_input_fields.

*
  DATA: ls_fieldcat TYPE lvc_s_fcat.
*
  LOOP AT gt_fieldcat INTO ls_fieldcat.

**   --- PUBLDATE änderbar------------ Anfang------------------"TK01042008
*    if LS_FIELDCAT-FIELDNAME = 'ISMPUBLDATE'.
*      if I_wl_erschdat_change = 'X'.
*        xmara_input_active = con_angekreuzt.
*        ls_fieldname = LS_FIELDCAT-FIELDNAME.
*        append ls_fieldname to gt_mara_input_fields.
*
*      endif.
*    else.
**   --- PUBLDATE änderbar------------ Ende--------------------"TK01042008

    IF ls_fieldcat-edit = 'X'.
      IF ls_fieldcat-fieldname(5) <> 'MARC_'   AND
         ls_fieldcat-fieldname(5) <> 'MVKE_'   AND
         ls_fieldcat-fieldname(2) <> 'ZZ'      AND
         ls_fieldcat-fieldname(2) <> 'YY'      .
        xmara_input_active = con_angekreuzt.
        ls_fieldname = ls_fieldcat-fieldname.
        APPEND ls_fieldname TO gt_mara_input_fields.
      ENDIF.
      IF ls_fieldcat-fieldname(5) = 'MARC_'.
        xmarc_input_active = con_angekreuzt.
        ls_fieldname = ls_fieldcat-fieldname.
        APPEND ls_fieldname TO gt_marc_input_fields.
      ENDIF.
      IF ls_fieldcat-fieldname(5) = 'MVKE_'.
        xmvke_input_active = con_angekreuzt.
        ls_fieldname = ls_fieldcat-fieldname.
        APPEND ls_fieldname TO gt_mvke_input_fields.
      ENDIF.
    ENDIF.

*    endif.                                                  "TK01042008

  ENDLOOP.
*
ENDFORM. " input_segments_identify  tables gt_Fieldcat.



*&---------------------------------------------------------------------*
*&      Form  lock_keys_identify
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->I_STATUSTAB         text
*      -->XMARA_INPUT_ACTIVE  text
*      -->XMARC_INPUT_ACTIVE  text
*      -->XMVKE_INPUT_ACTIVE  text
*      -->GT_LOCK_MARA        text
*      -->GT_LOCK_MARC        text
*      -->GT_LOCK_MVKE        text
*----------------------------------------------------------------------*
FORM lock_keys_identify USING i_statustab TYPE jksdmaterialstatustab
                              xmara_input_active
                              xmarc_input_active
                              xmvke_input_active
                     CHANGING gt_lock_mara TYPE rjp_enq_mara_tab
                              gt_lock_marc TYPE rjp_enq_marc_tab
                              gt_lock_mvke TYPE rjp_enq_mvke_tab
                              gt_vlgvz_matnr TYPE matnr_tab. "TK13062008
*
  DATA: ls_statustab LIKE LINE OF i_statustab.
  DATA: ls_lock_mara LIKE LINE OF gt_lock_mara.
  DATA: ls_lock_marc LIKE LINE OF gt_lock_marc.
  DATA: ls_lock_mvke LIKE LINE OF gt_lock_mvke.
  DATA: ls_vlgvz_matnr TYPE matnr_stru.                     "TK13062008


*
  CLEAR gt_lock_mara. REFRESH gt_lock_mara.
  CLEAR gt_lock_marc. REFRESH gt_lock_marc.
  CLEAR gt_lock_mvke. REFRESH gt_lock_mvke.
  CLEAR gt_vlgvz_matnr. REFRESH gt_vlgvz_matnr.             "TK13062008
*
  LOOP AT i_statustab INTO ls_statustab.
*
    IF xmara_input_active = con_angekreuzt.
      ls_lock_mara-mandt = sy-mandt.
      ls_lock_mara-matnr = ls_statustab-matnr.
      APPEND ls_lock_mara TO gt_lock_mara.
    ENDIF.
*
    IF xmarc_input_active = con_angekreuzt AND
       NOT ls_statustab-marc_werks IS INITIAL.
      ls_lock_marc-mandt = sy-mandt.
      ls_lock_marc-matnr = ls_statustab-matnr.
      ls_lock_marc-werks = ls_statustab-marc_werks.
      APPEND ls_lock_marc TO gt_lock_marc.
    ENDIF.

*   ---------------  Anfang--------------------------------"TK13062008
*   Sperre im Retail für alle Werke, wenn Vorlageverteilzentrum
*   selektiert wurde
    IF NOT xretailmaterial IS INITIAL      AND
       NOT gv_twpa_vlgvz   IS INITIAL.
*     sammeln Medienausgaben, für die Vorlagewerk selektiert wurde
      ls_vlgvz_matnr-matnr =  ls_statustab-matnr.
      APPEND ls_vlgvz_matnr TO gt_vlgvz_matnr.
    ENDIF. " not xretail         is initial      and
*   ---------------  Ende ---------------------------------"TK13062008

*
    IF xmvke_input_active = con_angekreuzt AND
       NOT ls_statustab-mvke_vkorg IS INITIAL.
      ls_lock_mvke-mandt = sy-mandt.
      ls_lock_mvke-matnr = ls_statustab-matnr.
      ls_lock_mvke-vkorg = ls_statustab-mvke_vkorg.
      ls_lock_mvke-vtweg = ls_statustab-mvke_vtweg.
      APPEND ls_lock_mvke TO gt_lock_mvke.
    ENDIF.
*
  ENDLOOP.
*

* ---------------  Anfang--------------------------------"TK13062008
* Sperre im Retail für alle Werke, wenn Vorlageverteilzentrum
* selektiert wurde
  SORT gt_vlgvz_matnr.
  DELETE ADJACENT DUPLICATES FROM gt_vlgvz_matnr.
* ---------------  Ende ---------------------------------"TK13062008


  SORT gt_lock_mara.
  DELETE ADJACENT DUPLICATES FROM gt_lock_mara.
  SORT gt_lock_marc.
  DELETE ADJACENT DUPLICATES FROM gt_lock_marc.
  SORT gt_lock_mvke.
  DELETE ADJACENT DUPLICATES FROM gt_lock_mvke.
*
ENDFORM. " lock_keys_identify

* Zu soerrende Segmente sperren
FORM lock_keys USING    gt_lock_mara TYPE rjp_enq_mara_tab
                        gt_lock_marc TYPE rjp_enq_marc_tab
                        gt_lock_mvke TYPE rjp_enq_mvke_tab
               CHANGING gt_locked_mara TYPE rjp_enq_mara_tab
                        gt_locked_marc TYPE rjp_enq_marc_tab
                        gt_locked_mvke TYPE rjp_enq_mvke_tab
                        gt_vlgvz_matnr TYPE matnr_tab.      "TK13062008
*
  DATA: ls_lock_mara LIKE LINE OF gt_locked_mara.
  DATA: ls_lock_marc LIKE LINE OF gt_locked_marc.
  DATA: ls_lock_mvke LIKE LINE OF gt_locked_mvke.
  DATA: ls_vlgvz_matnr TYPE matnr_stru.                     "TK13062008
*
*
  CLEAR gt_locked_mara. REFRESH gt_locked_mara.
  CLEAR gt_locked_marc. REFRESH gt_locked_marc.
  CLEAR gt_locked_mvke. REFRESH gt_locked_mvke.

* MARA-Segmente sperren
  LOOP AT gt_lock_mara INTO ls_lock_mara.
*
    CALL FUNCTION 'ENQUEUE_EJKWORKLISTMARA'
      EXPORTING
*       MODE_MARA      = 'E'
*       MANDT          = SY-MANDT
        matnr          = ls_lock_mara-matnr
*       X_MATNR        = ' '
*       _SCOPE         = '2'
*       _WAIT          = ' '
*       _COLLECT       = ' '
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      APPEND ls_lock_mara TO gt_locked_mara.
    ENDIF.
*
  ENDLOOP.
*
* MARC-Segmente sperren
  LOOP AT gt_lock_marc INTO ls_lock_marc.
*
    READ TABLE gt_vlgvz_matnr INTO ls_vlgvz_matnr           "TK13062008
      WITH KEY ls_lock_marc-matnr.                          "TK13062008
    IF sy-subrc = 0.                                        "TK13062008
*     alle Werke zur Ausgabe generisch sperren              "TK13062008
      CALL FUNCTION 'ENQUEUE_EJKWORKLISTMARC'
        EXPORTING
*         MODE_MARA      = 'E'
*         MANDT          = SY-MANDT
          matnr          = ls_lock_marc-matnr
*         WERKS          = ls_lock_marc-werks "<= generische Sperre
*         X_MATNR        = ' '
*         _SCOPE         = '2'
*         _WAIT          = ' '
*         _COLLECT       = ' '
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        APPEND ls_lock_marc TO gt_locked_marc.
      ENDIF.
    ELSE.                                                   "TK13062008
*     jedes einzelen Werk explizit sperren                  "TK13062008
      CALL FUNCTION 'ENQUEUE_EJKWORKLISTMARC'
        EXPORTING
*         MODE_MARA      = 'E'
*         MANDT          = SY-MANDT
          matnr          = ls_lock_marc-matnr
          werks          = ls_lock_marc-werks  "<= explizite Sperre
*         X_MATNR        = ' '
*         _SCOPE         = '2'
*         _WAIT          = ' '
*         _COLLECT       = ' '
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        APPEND ls_lock_marc TO gt_locked_marc.
      ENDIF.
    ENDIF.                                                  "TK13062008

*
  ENDLOOP.

*
* MVKE-Segmente sperren
  LOOP AT gt_lock_mvke INTO ls_lock_mvke.
*
    CALL FUNCTION 'ENQUEUE_EJKWORKLISTMVKE'
      EXPORTING
*       MODE_MARA      = 'E'
*       MANDT          = SY-MANDT
        matnr          = ls_lock_mvke-matnr
        vkorg          = ls_lock_mvke-vkorg
        vtweg          = ls_lock_mvke-vtweg
*       X_MATNR        = ' '
*       _SCOPE         = '2'
*       _WAIT          = ' '
*       _COLLECT       = ' '
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      APPEND ls_lock_mvke TO gt_locked_mvke.
    ENDIF.
*
  ENDLOOP.
*
ENDFORM. " lock_keys


* --- Ende-------------optimistisches Sperren------------- "TK01042008
