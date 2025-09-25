***INCLUDE RVREUSE0 .

FORM reuse_alv_fieldcatalog_merge
     USING pt_fieldcat TYPE slis_t_fieldcat_alv
     VALUE(pi_structure) LIKE dd02l-tabname
     VALUE(pi_tablename) LIKE dd02l-tabname
     VALUE(pi_sp_group).

  DATA: ls_fieldcat TYPE slis_fieldcat_alv.
  FIELD-SYMBOLS: <ls_fieldcat> TYPE slis_fieldcat_alv.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
*     I_PROGRAM_NAME         =
*     I_INTERNAL_TABNAME     =
      i_structure_name       = pi_structure
      i_client_never_display = 'X'
    CHANGING
      ct_fieldcat            = pt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  IF NOT pi_tablename IS INITIAL OR
     NOT pi_sp_group  IS INITIAL.


    ls_fieldcat-tabname  = pi_tablename.
    ls_fieldcat-sp_group = pi_sp_group.

    MODIFY pt_fieldcat FROM ls_fieldcat TRANSPORTING tabname sp_group
                       WHERE tabname IS INITIAL OR
                             sp_group IS INITIAL.

  ENDIF.

  IF pi_structure = 'FAMTV'.
* set fields ACTIVE and DUMMY as technical fields, so they do not appear on UI
    READ TABLE pt_fieldcat ASSIGNING <ls_fieldcat>
    WITH KEY fieldname = 'ACTIV'.
    IF sy-subrc IS INITIAL.
      <ls_fieldcat>-tech = 'X'.
    ENDIF.
    READ TABLE pt_fieldcat ASSIGNING <ls_fieldcat>
    WITH KEY fieldname = 'DUMMY'.
    IF sy-subrc IS INITIAL.
      <ls_fieldcat>-tech = 'X'.
    ENDIF.

  ENDIF.

ENDFORM.                    "REUSE_ALV_FIELDCATALOG_MERGE

*---------------------------------------------------------------------*
*       FORM REUSE_ALV_VARIANT_DEFAULT                                *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
FORM reuse_alv_variant_default
     USING ps_sd_alv         TYPE sd_alv.

  DATA: ls_fieldcat TYPE slis_fieldcat_alv.
  DATA: ls_variant  LIKE disvariant.
  DATA: ls_import_flag.
  STATICS: ls_counter TYPE i.

  IMPORT ls_import_flag FROM MEMORY ID ps_sd_alv-variant(48).
  IF NOT ls_import_flag IS INITIAL.
    IMPORT ps_sd_alv-variant FROM MEMORY ID ps_sd_alv-variant(48).
  ENDIF.

  IF ps_sd_alv-variant-variant IS INITIAL.
    ps_sd_alv-default = gc_charx.
  ELSE.
    CLEAR ps_sd_alv-default.
  ENDIF.
  ls_variant = ps_sd_alv-variant.

  CALL FUNCTION 'REUSE_ALV_VARIANT_SELECT'
    EXPORTING
      i_dialog            = 'N'
      i_user_specific     = gc_chara
      i_default           = ps_sd_alv-default
      i_tabname_header    = ps_sd_alv-tabname_header
      i_tabname_item      = ps_sd_alv-tabname_item
      it_default_fieldcat = ps_sd_alv-fieldcat
      i_layout            = ps_sd_alv-layout
    IMPORTING
      e_exit              = ps_sd_alv-exit
      et_fieldcat         = ps_sd_alv-fieldcat
      et_sort             = ps_sd_alv-sort
      et_filter           = ps_sd_alv-filter
    CHANGING
      cs_variant          = ps_sd_alv-variant
    EXCEPTIONS
      wrong_input         = 1
      fc_not_complete     = 2
      not_found           = 3
      program_error       = 4
      OTHERS              = 5.

  IF ps_sd_alv-variant IS INITIAL.
    ps_sd_alv-variant = ls_variant.
  ENDIF.
  ps_sd_alv-default = gc_charx.
  CLEAR ls_counter.
ENDFORM.                    "REUSE_ALV_VARIANT_DEFAULT

*---------------------------------------------------------------------*
*       FORM REUSE_ALV_EVENTS_GET                                     *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  PT_EVENTS                                                     *
*  -->  PI_LIST_TYPE                                                  *
*---------------------------------------------------------------------*
FORM reuse_alv_events_get TABLES pt_events   TYPE slis_t_event
                          USING pi_list_type.

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type     = pi_list_type
    IMPORTING
      et_events       = pt_events[]
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.

ENDFORM.                    "REUSE_ALV_EVENTS_GET
*&---------------------------------------------------------------------*
*&      Form  REUSE_PARTNERANSCHRIFT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PS_SELFIELD-VALUE  text                                    *
*      -->P_LIST1-VBKA-PARVW  text                                     *
*      -->P_LIST1-VBPA-ARDNR  text                                     *
*----------------------------------------------------------------------*
FORM reuse_partneranschrift USING    pi_kunde
                                     pi_parvw
                                     pi_ardnr.
  DATA: ls_vbpa     LIKE vbpa,
        ls_vbadr    LIKE vbadr,
        ls_adrs     LIKE adrs,
        da_temp(60) TYPE c.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = pi_kunde
    IMPORTING
      output = ls_vbpa-kunnr.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = pi_kunde
    IMPORTING
      output = ls_vbpa-lifnr.

  MOVE pi_kunde TO da_temp.
  CONDENSE da_temp.
  IF da_temp+8(2) CO ' '.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = pi_kunde
      IMPORTING
        output = ls_vbpa-pernr.
  ELSE.
    ls_vbpa-pernr = '00000000'.
  ENDIF.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = pi_kunde
    IMPORTING
      output = ls_vbpa-parnr.
  MOVE pi_parvw TO ls_vbpa-parvw.
  MOVE pi_ardnr TO ls_vbpa-adrnr.

  CALL FUNCTION 'VIEW_VBADR'
    EXPORTING
      input   = ls_vbpa
    IMPORTING
      adresse = ls_vbadr.

  MOVE-CORRESPONDING ls_vbadr TO ls_adrs.
  CALL FUNCTION 'RV_ADDRESS_WINDOW_DISPLAY'
    EXPORTING
      adrswa_in = ls_adrs
      fadrtype  = space.

ENDFORM.                               " REUSE_PARTNERANSCHRIFT

*&---------------------------------------------------------------------*
*&      Form  REUSE_KONTAKT_BERECHTIGUNG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_RCODE  text                                             *
*----------------------------------------------------------------------*
TYPE-POOLS: v43.
*---------------------------------------------------------------------*
*       FORM REUSE_KONTAKT_BERECHTIGUNG                               *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  PI_VBELN                                                      *
*  -->  PO_RCODE                                                      *
*---------------------------------------------------------------------*
FORM reuse_kontakt_berechtigung USING pi_vbeln
                                      po_rcode.
  DATA: lt_vbka LIKE vbka OCCURS 1 WITH HEADER LINE,
        lt_vbpa LIKE vbpavb OCCURS 1 WITH HEADER LINE.

  DATA: lt_vbeln TYPE  v43_t_vbeln.
  RANGES: lr_vbeln FOR vbka-vbeln.

  CLEAR po_rcode.
  APPEND pi_vbeln TO lt_vbeln.
  CALL FUNCTION 'SDCAS_SALES_ACTIVITY_READ_MANY'
    EXPORTING
      fi_vbuk_read         = space
      fi_vbka_read         = gc_charx
      fi_vbpa_read         = space
      fi_sadr_read         = space
      fi_stxh_tlines_read  = space
      fi_vbfa_read         = space
    TABLES
      fi_vbeln             = lt_vbeln
      fe_vbka              = lt_vbka
    EXCEPTIONS
      not_all_docs_in_vbuk = 1
      not_all_docs_in_vbka = 2
      OTHERS               = 3.

  CALL FUNCTION 'SD_AUTHORITY_SALES_ACTIVITY'
    EXPORTING
      activity     = '1'
    TABLES
      fxvbka       = lt_vbka
      fxvbpa       = lt_vbpa
      no_authority = lr_vbeln.
  DESCRIBE TABLE lr_vbeln LINES sy-tfill.
  IF sy-tfill > 0.
    po_rcode = 4.
  ENDIF.

ENDFORM.                               " REUSE_KONTAKT_BERECHTIGUNG
*&---------------------------------------------------------------------*
*&      Form  REUSE_CHANGE_DOCUMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PS_SELFIELD-VALUE  text                                    *
*      -->P_CHAR1  text                                                *
*      -->P_SPACE  text                                                *
*----------------------------------------------------------------------*
FORM reuse_change_document USING  pi_vbeln LIKE vbak-vbeln
                                  pi_vbtyp TYPE c
                                  pi_fcode TYPE c.

  CALL FUNCTION 'RV_CALL_CHANGE_TRANSACTION'
    EXPORTING
      vbeln = pi_vbeln
      vbtyp = pi_vbtyp
      fcode = pi_fcode.

ENDFORM.                               " REUSE_CHANGE_DOCUMENT
*&---------------------------------------------------------------------*
*&      Form  REUSE_DISPLAY_DOCUMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PS_SELFIELD-VALUE  text                                    *
*      -->P_CHAR1  text                                                *
*      -->P_SPACE  text                                                *
*----------------------------------------------------------------------*
FORM reuse_display_document USING    pi_vbeln LIKE vbak-vbeln
                                     pi_vbtyp TYPE c
                                     pi_fcode TYPE c.

  CALL FUNCTION 'RV_CALL_DISPLAY_TRANSACTION'
    EXPORTING
      vbeln = pi_vbeln
      vbtyp = pi_vbtyp
      fcode = pi_fcode.
ENDFORM.                               " REUSE_DISPLAY_DOCUMENT
*&---------------------------------------------------------------------*
*&      Form  REUSE_STATUS_ANZEIGEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_LIST1-VBELN  text                                       *
*      -->P_NULL  text                                                 *
*----------------------------------------------------------------------*
FORM reuse_status_anzeigen USING pi_vbeln LIKE vbak-vbeln
                                 pi_posnr TYPE c
                                 pe_fcode LIKE sy-ucomm.

  DATA: ls_vbuk LIKE vbuk,
        ls_vbup LIKE vbup.

  IF pi_posnr IS INITIAL.
    ls_vbuk-vbeln = pi_vbeln.
    CALL FUNCTION 'RV_DOCUMENT_HEAD_STATUS_TEXTS'
      EXPORTING
        vbuk_in       = ls_vbuk
        window_senden = gc_charx
      IMPORTING
        fcode         = pe_fcode.
  ELSE.
    ls_vbup-vbeln = pi_vbeln.
    ls_vbup-posnr = pi_posnr.
    CALL FUNCTION 'RV_DOCUMENT_POS_STATUS_TEXTS'
      EXPORTING
        vbup_in       = ls_vbup
        window_senden = gc_charx
      IMPORTING
        fcode         = pe_fcode.
  ENDIF.
ENDFORM.                               " REUSE_STATUS_ANZEIGEN
*&---------------------------------------------------------------------*
*&      Form  REUSE_FLUSS_ANZEIGEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_VBKA-VBELN  text                                        *
*      -->P_NULL  text                                                 *
*----------------------------------------------------------------------*
FORM reuse_fluss_anzeigen USING    pi_vbeln LIKE vbak-vbeln
                                   pi_posnr LIKE vbap-posnr.
  DATA: ls_vbco6 LIKE vbco6.

  ls_vbco6-mandt = sy-mandt.
  ls_vbco6-vbeln = pi_vbeln.
  ls_vbco6-posnr = pi_posnr.

  CALL DIALOG 'RV_DOCUMENT_FLOW'
    EXPORTING
      vbco6 FROM ls_vbco6.

ENDFORM.                               " REUSE_FLUSS_ANZEIGEN
*&---------------------------------------------------------------------*
*&      Form  REUSE_EVENTS_EXIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_EVENTS_EXIT  text                                       *
*----------------------------------------------------------------------*
FORM reuse_events_exit TABLES   pt_events_exit TYPE slis_t_event_exit.

  CLEAR pt_events_exit.
  pt_events_exit-ucomm = '&ERW'.
  pt_events_exit-after = gc_charx.
  APPEND pt_events_exit.

  CLEAR pt_events_exit.
  pt_events_exit-ucomm = '&OLX'.
  pt_events_exit-after = gc_charx.
  APPEND pt_events_exit.

  pt_events_exit-ucomm = '&OL0'.
  pt_events_exit-after = gc_charx.
  APPEND pt_events_exit.

  CLEAR pt_events_exit.
  pt_events_exit-ucomm = '&OAD'.
  pt_events_exit-after = gc_charx.
  APPEND pt_events_exit.

  CLEAR pt_events_exit.
  pt_events_exit-ucomm = '&OUP'.
  pt_events_exit-after  = gc_charx.
  APPEND pt_events_exit.

  CLEAR pt_events_exit.
  pt_events_exit-ucomm = '&ODN'.
  pt_events_exit-after  = gc_charx.
  APPEND pt_events_exit.

  CLEAR pt_events_exit.
  pt_events_exit-ucomm = '&ILT'.
  pt_events_exit-after = gc_charx.
  APPEND pt_events_exit.

  CLEAR pt_events_exit.
  pt_events_exit-ucomm = '&ILD'.
  pt_events_exit-after = gc_charx.
  APPEND pt_events_exit.
ENDFORM.                               " REUSE_EVENTS_EXIT
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_LIST_LAYOUT_INFO_GET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_FIELDCAT  text                                          *
*      -->P_GT_LAYOUT  text                                            *
*      -->P_GT_SORT  text                                              *
*      -->P_GT_FILTER  text                                            *
*----------------------------------------------------------------------*
FORM reuse_alv_list_layout_info_get USING    pt_fieldcat
                                             ps_layout
                                             pt_sort
                                             pt_filter.

  CALL FUNCTION 'REUSE_ALV_LIST_LAYOUT_INFO_GET'
    IMPORTING
      es_layout     = ps_layout
      et_fieldcat   = pt_fieldcat
      et_sort       = pt_sort
      et_filter     = pt_filter
*     ES_LIST_SCROLL =
    EXCEPTIONS
      no_infos      = 1
      program_error = 2
      OTHERS        = 3.

ENDFORM.                               " REUSE_ALV_LIST_LAYOUT_INFO_GET
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_LIST_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_LIST1  text                                             *
*      -->P_GS_SD_ALV  text                                            *
*      -->P_PI_DEFAULT  text                                           *
*      -->P_PI_TABNAME_HEADER  text                                    *
*----------------------------------------------------------------------*
FORM reuse_alv_list_display
*    USING    pt_outtab         TYPE ANY TABLE
     USING    pt_outtab         TYPE STANDARD TABLE
              ps_sd_alv         TYPE sd_alv.
  DATA: ls_fieldcat LIKE LINE OF ps_sd_alv-fieldcat.
  DATA: lv_number_outfields TYPE int4.
  IF ps_sd_alv-variant-variant IS INITIAL.
    LOOP AT ps_sd_alv-fieldcat  TRANSPORTING
            NO FIELDS WHERE no_out = 'O'.
      lv_number_outfields = lv_number_outfields + 1.
    ENDLOOP.
    LOOP AT ps_sd_alv-fieldcat INTO ls_fieldcat
            WHERE no_out IS INITIAL AND tech IS INITIAL.
      lv_number_outfields = lv_number_outfields + 1.
      IF lv_number_outfields > 99.
        ls_fieldcat-no_out = 'X'.
        MODIFY ps_sd_alv-fieldcat FROM ls_fieldcat.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF NOT ps_sd_alv-grid_display IS INITIAL.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
*       i_interface_check        =
        i_callback_program       = ps_sd_alv-program
        i_callback_pf_status_set = ps_sd_alv-pf_status_set
        i_callback_user_command  = ps_sd_alv-user_command
        i_structure_name         = ps_sd_alv-structure
        is_layout                = ps_sd_alv-layout
        it_fieldcat              = ps_sd_alv-fieldcat
        it_excluding             = ps_sd_alv-excluding
        it_special_groups        = ps_sd_alv-special_groups
        it_sort                  = ps_sd_alv-sort
        it_filter                = ps_sd_alv-filter
        is_sel_hide              = ps_sd_alv-sel_hide
        i_default                = 'X'
        i_save                   = ps_sd_alv-save
        is_variant               = ps_sd_alv-variant
        it_events                = ps_sd_alv-events
        it_event_exit            = ps_sd_alv-event_exit
        is_print                 = ps_sd_alv-print
*       IS_REPREP_ID             =
        i_screen_start_column    = ps_sd_alv-start_column
        i_screen_start_line      = ps_sd_alv-start_line
        i_screen_end_column      = ps_sd_alv-end_column
        i_screen_end_line        = ps_sd_alv-end_line
      IMPORTING
        e_exit_caused_by_caller  = ps_sd_alv-exit
        es_exit_caused_by_user   = ps_sd_alv-user_exit
      TABLES
        t_outtab                 = pt_outtab
      EXCEPTIONS
        program_error            = 1
        OTHERS                   = 2.


    EXPORT ps_sd_alv-variant TO MEMORY ID ps_sd_alv-variant(48).
  ELSE.
    CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
      EXPORTING
*       i_interface_check        =
        i_callback_program       = ps_sd_alv-program
        i_callback_pf_status_set = ps_sd_alv-pf_status_set
        i_callback_user_command  = ps_sd_alv-user_command
        i_structure_name         = ps_sd_alv-structure
        is_layout                = ps_sd_alv-layout
        it_fieldcat              = ps_sd_alv-fieldcat
        it_excluding             = ps_sd_alv-excluding
        it_special_groups        = ps_sd_alv-special_groups
        it_sort                  = ps_sd_alv-sort
        it_filter                = ps_sd_alv-filter
        is_sel_hide              = ps_sd_alv-sel_hide
        i_default                = 'X'
        i_save                   = ps_sd_alv-save
        is_variant               = ps_sd_alv-variant
        it_events                = ps_sd_alv-events
        it_event_exit            = ps_sd_alv-event_exit
        is_print                 = ps_sd_alv-print
*       IS_REPREP_ID             =
        i_screen_start_column    = ps_sd_alv-start_column
        i_screen_start_line      = ps_sd_alv-start_line
        i_screen_end_column      = ps_sd_alv-end_column
        i_screen_end_line        = ps_sd_alv-end_line
      IMPORTING
        e_exit_caused_by_caller  = ps_sd_alv-exit
        es_exit_caused_by_user   = ps_sd_alv-user_exit
      TABLES
        t_outtab                 = pt_outtab
      EXCEPTIONS
        program_error            = 1
        OTHERS                   = 2.


    EXPORT ps_sd_alv-variant TO MEMORY ID ps_sd_alv-variant(48).
  ENDIF.

ENDFORM.                               " REUSE_ALV_LIST_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_HIERSEQ_LIST_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_LIST2  text                                             *
*      -->P_GT_LIST1  text                                             *
*      -->P_GS_SD_ALV  text                                            *
*----------------------------------------------------------------------*
FORM reuse_alv_hierseq_list_display TABLES   pt_outtab1
                                             pt_outtab2
                                    USING    ps_sd_alv TYPE sd_alv.
  DATA: ls_fieldcat LIKE LINE OF ps_sd_alv-fieldcat.
  DATA: lv_number_outfields TYPE int4.
  IF ps_sd_alv-variant-variant IS INITIAL.
    LOOP AT ps_sd_alv-fieldcat  TRANSPORTING
            NO FIELDS WHERE no_out = 'O'.
      lv_number_outfields = lv_number_outfields + 1.
    ENDLOOP.
    LOOP AT ps_sd_alv-fieldcat INTO ls_fieldcat
            WHERE no_out IS INITIAL AND tech IS INITIAL AND
             tabname = ps_sd_alv-tabname_header.
      IF lv_number_outfields > 98.
        ls_fieldcat-no_out = 'X'.
        MODIFY ps_sd_alv-fieldcat FROM ls_fieldcat.
      ELSE.
        lv_number_outfields = lv_number_outfields + 1.
      ENDIF.
    ENDLOOP.
  ENDIF.
*  clear lv_number_outfields.
  IF ps_sd_alv-variant-variant IS INITIAL.
    LOOP AT ps_sd_alv-fieldcat INTO ls_fieldcat
            WHERE no_out IS INITIAL AND tech IS INITIAL AND
            tabname = ps_sd_alv-tabname_item.
      lv_number_outfields = lv_number_outfields + 1.
      IF lv_number_outfields > 99.
        ls_fieldcat-no_out = 'X'.
        MODIFY ps_sd_alv-fieldcat FROM ls_fieldcat.
      ENDIF.
    ENDLOOP.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
    EXPORTING
      i_callback_program       = ps_sd_alv-program
      i_callback_pf_status_set = ps_sd_alv-pf_status_set
      i_callback_user_command  = ps_sd_alv-user_command
      is_layout                = ps_sd_alv-layout
      it_fieldcat              = ps_sd_alv-fieldcat
      it_excluding             = ps_sd_alv-excluding
      it_special_groups        = ps_sd_alv-special_groups
      it_sort                  = ps_sd_alv-sort
      it_filter                = ps_sd_alv-filter
      is_sel_hide              = ps_sd_alv-sel_hide
      i_screen_start_column    = ps_sd_alv-start_column
      i_screen_start_line      = ps_sd_alv-start_line
      i_screen_end_column      = ps_sd_alv-end_column
      i_screen_end_line        = ps_sd_alv-end_line
      i_default                = ps_sd_alv-default
      i_save                   = ps_sd_alv-save
      is_variant               = ps_sd_alv-variant
      it_events                = ps_sd_alv-events
      it_event_exit            = ps_sd_alv-event_exit
      i_tabname_header         = ps_sd_alv-tabname_header
      i_tabname_item           = ps_sd_alv-tabname_item
      i_structure_name_header  = ps_sd_alv-structure
      i_structure_name_item    = ps_sd_alv-structure_item
      is_keyinfo               = ps_sd_alv-keyinfo
      is_print                 = ps_sd_alv-print
    IMPORTING
      e_exit_caused_by_caller  = ps_sd_alv-exit
    TABLES
      t_outtab_header          = pt_outtab1
      t_outtab_item            = pt_outtab2
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.

ENDFORM.                               " REUSE_ALV_HIERSEQ_LIST_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_POPUP_TO_SELECT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_LIST_TYPES  text                                        *
*      -->P_LS_SD_ALV  text                                            *
*----------------------------------------------------------------------*
FORM reuse_alv_popup_to_select TABLES   pt_outtab
                               USING    ps_sd_alv TYPE sd_alv.

  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_title                 = ps_sd_alv-title
*     I_SELECTION             = 'X'
*     I_ZEBRA                 = ' '
      i_screen_start_column   = ps_sd_alv-start_column
      i_screen_start_line     = ps_sd_alv-start_line
      i_screen_end_column     = ps_sd_alv-end_column
      i_screen_end_line       = ps_sd_alv-end_line
      i_checkbox_fieldname    = ps_sd_alv-checkbox
      i_linemark_fieldname    = ps_sd_alv-linemark
*     I_SCROLL_TO_SEL_LINE    = 'X'
      i_tabname               = ps_sd_alv-tabname
      i_structure_name        = ps_sd_alv-structure
      it_fieldcat             = ps_sd_alv-fieldcat
      i_callback_program      = ps_sd_alv-program
      i_callback_user_command = ps_sd_alv-user_command
    IMPORTING
      es_selfield             = ps_sd_alv-selfield
      e_exit                  = ps_sd_alv-exit
    TABLES
      t_outtab                = pt_outtab
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
ENDFORM.                               " REUSE_ALV_POPUP_TO_SELECT
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_VARIANT_F4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_SD_ALV  text                                            *
*----------------------------------------------------------------------*
FORM reuse_alv_variant_f4 USING    ps_sd_alv TYPE sd_alv.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant          = ps_sd_alv-variant
      i_tabname_header    = ps_sd_alv-tabname_header
      i_tabname_item      = ps_sd_alv-tabname_item
      it_default_fieldcat = ps_sd_alv-fieldcat
      i_save              = ps_sd_alv-save
    IMPORTING
      e_exit              = ps_sd_alv-exit
      es_variant          = ps_sd_alv-variant
    EXCEPTIONS
      not_found           = 1
      program_error       = 2
      OTHERS              = 3.

  ps_sd_alv-subrc = sy-subrc.

ENDFORM.                               " REUSE_ALV_VARIANT_F4
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_VARIANT_EXISTENCE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PC_DVARI  text                                             *
*      -->P_CHARA  text                                                *
*      -->P_LV_SUBRC  text                                             *
*----------------------------------------------------------------------*
FORM reuse_alv_variant_existence USING    ps_variant LIKE disvariant
                                          pi_save  TYPE c
                                          pe_subrc LIKE sy-subrc.

  CALL FUNCTION 'REUSE_ALV_VARIANT_EXISTENCE'
    EXPORTING
      i_save        = pi_save
    CHANGING
      cs_variant    = ps_variant
    EXCEPTIONS
      wrong_input   = 1
      not_found     = 2
      program_error = 3
      OTHERS        = 4.

  pe_subrc = sy-subrc.

ENDFORM.                               " REUSE_ALV_VARIANT_EXISTENCE

*&---------------------------------------------------------------------*
*&      Form  RVREUSE_FORMS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM reuse_alv_variant_fill USING
                               pi_report    LIKE disvariant-report
                               pi_handle    TYPE c
                               pi_loggroup  TYPE c
                               pi_username  LIKE disvariant-username
                               ps_variant   LIKE disvariant.

  ps_variant-report   = pi_report  .
  ps_variant-handle   = pi_handle  .
  ps_variant-log_group = pi_loggroup.
* ps_variant-username = pi_username.

ENDFORM.                               " RVREUSE_FORMS
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_FIELDCATALOG_SELKZ
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_SD_ALV-FIELDCAT[]  text                                 *
*----------------------------------------------------------------------*
FORM reuse_alv_fieldcatalog_selkz TABLES pt_fieldcat
                                  TYPE slis_t_fieldcat_alv.
  pt_fieldcat-tabname   = 'LIST1'.
  pt_fieldcat-sp_group  = gc_char5.
  pt_fieldcat-fieldname =  'SELKZ'.
  pt_fieldcat-ref_fieldname = 'SELKZ'.
  pt_fieldcat-ref_tabname   = 'VBMTV'.
  APPEND pt_fieldcat.
ENDFORM.                               " REUSE_ALV_FIELDCATALOG_SELKZ
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_EVENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_SD_ALV-EVENTS  text                                     *
*----------------------------------------------------------------------*
FORM reuse_alv_events TABLES pt_events TYPE slis_t_event
                      USING  pe_program LIKE sy-repid.

  pt_events-form = pt_events-name = slis_ev_user_command.
  APPEND pt_events.
  pt_events-form = pt_events-name = slis_ev_pf_status_set.
  APPEND pt_events.
  pt_events-form = pt_events-name = slis_ev_top_of_page.
  APPEND pt_events.
  pt_events-form = pt_events-name = slis_ev_foreign_top_of_page.
  APPEND pt_events.
  pe_program = sy-repid.

ENDFORM.                               " REUSE_ALV_EVENTS_USER_COMMAND

*---------------------------------------------------------------------*
*       FORM REUSE_ALV_EVENTS_LINE_OUTPUT                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  PT_EVENTS                                                     *
*  -->  PI_BEFORE                                                     *
*  -->  PI_AFTER                                                      *
*---------------------------------------------------------------------*
FORM reuse_alv_events_line_output TABLES pt_events TYPE slis_t_event
                                  USING  pi_before
                                         pi_after.
  IF NOT pi_before IS INITIAL.
    pt_events-form = pt_events-name = slis_ev_before_line_output.
    APPEND pt_events.
  ENDIF.

  IF NOT pi_after IS INITIAL.
    pt_events-form = pt_events-name = slis_ev_after_line_output.
    APPEND pt_events.
  ENDIF.

  pt_events-form = pt_events-name = slis_ev_end_of_list.
  APPEND pt_events.
ENDFORM.                               " REUSE_ALV_EVENTS_USER_COMMAND
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_FIELDCATALOG_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_SD_ALV-FIELDCAT  text                                   *
*      -->P_3585   text                                                *
*      -->P_3587   text                                                *
*----------------------------------------------------------------------*
FORM reuse_alv_fieldcatalog_field TABLES pt_fieldcat
                                  TYPE slis_t_fieldcat_alv
                                  USING pi_field TYPE c
                                        pi_table TYPE c.

  pt_fieldcat-fieldname =  pi_field.
  pt_fieldcat-ref_fieldname = pi_field.
  pt_fieldcat-ref_tabname   = pi_table.
  APPEND pt_fieldcat.

ENDFORM.                               " REUSE_ALV_FIELDCATALOG_FIELD
*&---------------------------------------------------------------------*
*&      Form  REUSE_DDIF_FIELDINFO_GET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_DFIES  text                                             *
*      -->P_LV_FIELDNAME  text                                         *
*      -->P_LV_TABNAME  text                                           *
*----------------------------------------------------------------------*
FORM reuse_ddif_fieldinfo_get TABLES   pt_dfies STRUCTURE dfies
                              USING    pi_fieldname LIKE dfies-fieldname
                                       pi_tabname   LIKE dcobjdef-name.

  CALL FUNCTION 'DDIF_FIELDINFO_GET'
    EXPORTING
      tabname        = pi_tabname
      fieldname      = pi_fieldname
*     LANGU          = SY-LANGU
*    IMPORTING
*     X030L_WA       =
    TABLES
      dfies_tab      = pt_dfies
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
ENDFORM.                               " REUSE_DDIF_FIELDINFO_GET
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_FIELDCATALOG_NO_KEY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_SD_ALV-FIELDCAT  text                                   *
*----------------------------------------------------------------------*
FORM reuse_alv_fieldcatalog_no_key TABLES pt_fieldcat
                                          TYPE slis_t_fieldcat_alv.

  pt_fieldcat-key_sel = gc_charx.
  MODIFY pt_fieldcat FROM pt_fieldcat TRANSPORTING key_sel
                     WHERE key = gc_charx.
ENDFORM.                               " REUSE_ALV_FIELDCATALOG_NO_KEY
*&---------------------------------------------------------------------*
*&      Form  REUSE_VIEW_GET_FIELDINFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_DD27P  text                                             *
*      -->P_FIELDCAT-REF_TABNAME  text                                 *
*----------------------------------------------------------------------*
FORM reuse_view_get_fieldinfo TABLES   pt_dd27p STRUCTURE dd27p
                              USING    pi_tabname TYPE c.

  CALL FUNCTION 'DDIF_VIEW_GET'
    EXPORTING
      name          = pi_tabname
*     STATE         = 'A'
*     LANGU         = ' '
*    IMPORTING
*     GOTSTATE      =
*     DD25V_WA      =
*     DD09L_WA      =
    TABLES
*     DD26V_TAB     =
      dd27p_tab     = pt_dd27p
*     DD28J_TAB     =
*     DD28V_TAB     =
    EXCEPTIONS
      illegal_input = 1
      OTHERS        = 2.

ENDFORM.                               " REUSE_VIEW_GET_FIELDINFO
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_TEXTE_MERGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PT_FIELDCAT[]  text                                        *
*      -->P_0037   text                                                *
*      -->P_0038   text                                                *
*      -->P_CHAR8  text                                                *
*----------------------------------------------------------------------*
FORM reuse_alv_texte_merge
     TABLES pt_fieldcat TYPE slis_t_fieldcat_alv
     USING
     VALUE(pi_structure) LIKE dd02l-tabname
     VALUE(pi_tablename) LIKE dd02l-tabname
     VALUE(pi_sp_group).

  DATA: lt_dfies_text LIKE dfies OCCURS 1 WITH HEADER LINE,
        lt_dfies      LIKE dfies OCCURS 1 WITH HEADER LINE,
        lv_tabname    LIKE dcobjdef-name,
        lv_fieldname  LIKE dfies-fieldname.

  lv_tabname =  pi_structure.

  PERFORM reuse_ddif_fieldinfo_get TABLES   lt_dfies_text
                                   USING    space
                                            lv_tabname .

  REPLACE '_RTEXTE' WITH space INTO lv_tabname.

  PERFORM reuse_ddif_fieldinfo_get TABLES   lt_dfies
                                   USING    space
                                            lv_tabname .

  SORT lt_dfies_text BY position.

  LOOP AT lt_dfies_text.
    pt_fieldcat-fieldname     = lt_dfies_text-fieldname.
    pt_fieldcat-tabname       = pi_tablename.
    pt_fieldcat-ref_fieldname = lt_dfies_text-fieldname.
    pt_fieldcat-ref_tabname   = pi_structure.
    pt_fieldcat-sp_group      = pi_sp_group.

    lv_fieldname = lt_dfies_text-fieldname.

    IF lv_fieldname CS '_'.
      WRITE space TO lv_fieldname+sy-fdpos.
    ENDIF.
    READ TABLE lt_dfies WITH KEY fieldname = lv_fieldname.
    IF sy-subrc = 0.
      pt_fieldcat-seltext_l  =  lt_dfies-scrtext_l.
      pt_fieldcat-seltext_m  =  lt_dfies-scrtext_m.
      pt_fieldcat-seltext_s  =  lt_dfies-scrtext_s.
      pt_fieldcat-reptext_ddic = lt_dfies-scrtext_m.
      pt_fieldcat-rollname   =  lt_dfies-rollname.
    ENDIF.
    IF pi_structure = 'VBKA_RTEXTE'.
      pt_fieldcat-lowercase = 'X'.
    ENDIF.
    APPEND pt_fieldcat.
  ENDLOOP.

ENDFORM.                               " REUSE_ALV_TEXTE_MERGE
*&---------------------------------------------------------------------*
*&      Form  REUSE_KKB_LIST_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*        PS_SD_ALV TYPE SD_ALV.             *
*----------------------------------------------------------------------*
FORM reuse_kkb_list_layout USING    ps_sd_alv TYPE sd_alv.

  CALL FUNCTION 'K_KKB_LIST_LAYOUT_INFO_GET'
    IMPORTING
*     ES_LAYOUT                =
*     ET_FIELDCAT              =
*     ET_SORT                  =
*     ET_FILTER                =
      et_filtered_entries      = ps_sd_alv-filtered_entries
      et_filtered_entries_item = ps_sd_alv-filtered_entries_item
      es_list_scroll           = ps_sd_alv-list_scroll
*     E_TABNAME                =
*     E_TABNAME_SLAVE          =
    EXCEPTIONS
      no_infos                 = 1
      OTHERS                   = 2.

ENDFORM.                               " REUSE_KKB_LIST_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_LAYOUT_FILL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_SD_ALV-LAYOUT  text                                     *
*      -->P_LV_DUMMY  text                                             *
*      -->P_LV_DUMMY  text                                             *
*----------------------------------------------------------------------*
FORM reuse_alv_layout_fill USING    ps_layout TYPE slis_layout_alv
                                    pi_box_fieldname
                                    pi_box_tabname.

  ps_layout-get_selinfos      = gc_charx.
  ps_layout-colwidth_optimize = gc_charx.
  ps_layout-detail_popup      = gc_charx.
  ps_layout-box_tabname       = pi_box_tabname.
  ps_layout-box_fieldname     = pi_box_fieldname.
  ps_layout-no_keyfix         = gc_charx.
  ps_layout-key_hotspot       = gc_charx.
  ps_layout-group_change_edit = gc_charx.
  ps_layout-totals_before_items = gc_charx.

ENDFORM.                               " REUSE_ALV_LAYOUT_FILL
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_LIST_LAYOUT_INFO_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GS_SD_ALV_FIELDCAT  text                                   *
*      -->P_GS_SD_ALV_LAYOUT  text                                     *
*      -->P_GS_SD_ALV_SORT  text                                       *
*      -->P_GS_SD_ALV_FILTER  text                                     *
*----------------------------------------------------------------------*
FORM reuse_alv_list_layout_info_set USING    pt_fieldcat
                                             ps_layout
                                             pt_sort
                                             pt_filter.

  CALL FUNCTION 'REUSE_ALV_LIST_LAYOUT_INFO_SET'
    EXPORTING
      is_layout   = ps_layout
      it_fieldcat = pt_fieldcat
      it_sort     = pt_sort
      it_filter   = pt_filter
*     IS_LIST_SCROLL =
    EXCEPTIONS
      OTHERS      = 0.

ENDFORM.                               " REUSE_ALV_LIST_LAYOUT_INFO_SET

*---------------------------------------------------------------------*
*       FORM REUSE_ALV_LIST_REFRESH                                   *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  PS_SELFIELD                                                   *
*---------------------------------------------------------------------*
FORM reuse_alv_list_refresh USING ps_selfield TYPE slis_selfield.

  ps_selfield-refresh = gc_charx.
  ps_selfield-col_stable = gc_charx.
  ps_selfield-row_stable = gc_charx.

ENDFORM.                    "REUSE_ALV_LIST_REFRESH
*&---------------------------------------------------------------------*
*&      Form  REUSE_SUBMIT_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_SUBINFO  text                                           *
*----------------------------------------------------------------------*
FORM reuse_submit_info USING  ps_subinfo STRUCTURE rssubinfo.

  CALL FUNCTION 'RS_SUBMIT_INFO'
    IMPORTING
      p_submit_info = ps_subinfo
    EXCEPTIONS
      OTHERS        = 1.

ENDFORM.                               " REUSE_SUBMIT_INFO

*---------------------------------------------------------------------*
*       FORM REUSE_EXPORT_VARIANT                                     *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  PS_SD_ALV-VARIANT                                             *
*---------------------------------------------------------------------*
FORM reuse_export_variant_to_memory
     USING ps_sd_alv-variant LIKE disvariant.

  DATA: ls_import_flag VALUE 'X'.
  DATA: ls_variant LIKE disvariant.
  ls_variant = ps_sd_alv-variant.
  EXPORT ls_import_flag
         ps_sd_alv-variant TO MEMORY ID ls_variant(48).
ENDFORM.                    "REUSE_EXPORT_VARIANT_TO_MEMORY

*---------------------------------------------------------------------*
*       FORM REUSE_REFRESH_SD_ALV                            *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
FORM reuse_refresh_sd_alv CHANGING gs_sd_alv TYPE sd_alv.
  CLEAR gs_sd_alv.
ENDFORM.                               "REUSE_REFRESH_SD_ALV
*&---------------------------------------------------------------------*
*&      Form  REUSE_LENGTH_WIDTH_POPUP
*&---------------------------------------------------------------------*
* to use the list-viewer in a popup-window it is necessary to
* set the height and width. To do this somehow dynamically
* we supply this function.
*----------------------------------------------------------------------*
FORM reuse_length_width_popup
                        TABLES
                         pt_fieldcat TYPE slis_t_fieldcat_alv
                         pt_outtab
                        CHANGING
                                 p_popup_start_column
                                 p_popup_start_line
                                 p_popup_end_line
                                 p_popup_end_column.
  DATA: lin    TYPE i, laenge TYPE i.
  DATA: lv_breite      TYPE i, lv_anz_display TYPE i.
  IF p_popup_start_column IS INITIAL.
    p_popup_start_column = 1.
  ENDIF.
  IF p_popup_start_line IS INITIAL.
    p_popup_start_line = 1.
  ENDIF.

  lv_breite = 11.
  lv_anz_display = 0.
  LOOP AT pt_fieldcat WHERE no_out IS INITIAL AND tech IS INITIAL.
    lv_anz_display = lv_anz_display + 1.
    lv_breite = lv_breite + pt_fieldcat-outputlen.
  ENDLOOP.
  lv_breite = lv_breite + lv_anz_display.
  IF lv_breite < 50.
    lv_breite = 50.
  ENDIF.
  IF lv_breite > 84.
    lv_breite = 84.
  ENDIF.

  p_popup_end_column = p_popup_start_column + lv_breite.
  laenge = 3.
  DESCRIBE TABLE pt_outtab LINES lin.
  laenge = laenge + ( ( lin * 8 ) DIV 10 ).
  IF laenge > 22.
    laenge = 22.
  ENDIF.
  p_popup_end_line = p_popup_start_line + laenge.
ENDFORM.                               " LAENGE_BREITE_BESTIMMEN

*&---------------------------------------------------------------------*
*&      Form  REUSE_BERECHTIGUNG_SETZEN
*&---------------------------------------------------------------------*
* Only priviliged users should change the global variants
*----------------------------------------------------------------------*
FORM reuse_berechtigung_setzen
                    CHANGING p_save LIKE gs_sd_alv-save.
  GET PARAMETER ID 'SD_VARIANT_MAINTAIN' FIELD p_save.
  IF p_save NE 'X' AND p_save NE 'A' AND p_save NE 'U'.
    CLEAR p_save.
  ENDIF.
ENDFORM.                               "REUSE_BERECHTIGUNG_SETZEN
*&---------------------------------------------------------------------*
*&      Form  REUSE_WARNING_OBSOLETE
*&---------------------------------------------------------------------*
* We want to show a warning for a report which will be disposed
*----------------------------------------------------------------------*
FORM reuse_warning_obsolete
                USING VALUE(p_last_release) TYPE c
                      VALUE(p_reportname) TYPE programm.

  DATA: gvf_last_release(5), gvf_first_release_without(5),
        gvf_reportname TYPE programm.
  DATA: BEGIN OF lvt_parameters OCCURS 2.
          INCLUDE STRUCTURE  spar.
        DATA: END OF lvt_parameters.

  lvt_parameters-param = 'GVF_LAST'.
  lvt_parameters-value = p_last_release.
  APPEND lvt_parameters.
  lvt_parameters-param = 'GVF_REP'.
  lvt_parameters-value = p_reportname.
  APPEND lvt_parameters.




  CALL FUNCTION 'POPUP_DISPLAY_TEXT_WITH_PARAMS'
    EXPORTING
      language       = sy-langu
      popup_title    = space                          "text-001
*     START_COLUMN   = 10
*     START_ROW      = 3
      text_object    = 'SDCAS_WARNING_OBSOLETE'
*     HELP_MODAL     = 'X'
*    IMPORTING
*     CANCELLED      =
    TABLES
      parameters     = lvt_parameters
    EXCEPTIONS
      error_in_text  = 1
      text_not_found = 2
      OTHERS         = 3.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                               "REUSE_BERECHTIGUNG_SETZEN
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_GRID_LAYOUT_INFO_GET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PT_FIELDCAT  text
*      -->PS_LAYOUT    text
*      -->PT_SORT  text
*      -->PT_FILTER  text
*----------------------------------------------------------------------*
FORM reuse_alv_grid_layout_info_get USING  pt_fieldcat
                                           ps_layout
                                           pt_sort
                                           pt_filter.

  CALL FUNCTION 'REUSE_ALV_GRID_LAYOUT_INFO_GET'
    IMPORTING
      es_layout     = ps_layout
      et_fieldcat   = pt_fieldcat
      et_sort       = pt_sort
      et_filter     = pt_filter
    EXCEPTIONS
      no_infos      = 1
      program_error = 2
      OTHERS        = 3.

ENDFORM.                               " REUSE_ALV_GRID_LAYOUT_INFO_GET
*&---------------------------------------------------------------------*
*&      Form  REUSE_ALV_GRID_LAYOUT_INFO_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PT_FIELDCAT  text
*      -->PS_LAYOUT  text
*      -->PT_SORT  text
*      -->PT_FILTER  text
*----------------------------------------------------------------------*
FORM reuse_alv_grid_layout_info_set USING    pt_fieldcat
                                             ps_layout
                                             pt_sort
                                             pt_filter.

  CALL FUNCTION 'REUSE_ALV_GRID_LAYOUT_INFO_SET'
    EXPORTING
      is_layout   = ps_layout
      it_fieldcat = pt_fieldcat
      it_sort     = pt_sort
      it_filter   = pt_filter
*     IS_LIST_SCROLL =
    EXCEPTIONS
      OTHERS      = 0.


ENDFORM.                               " REUSE_ALV_GRID_LAYOUT_INFO_SET
*&---------------------------------------------------------------------*
*&      Form  F_SELECTION_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_selection_output .
  DATA: exclude        LIKE rsexfcode OCCURS 0 WITH HEADER LINE,
        ls_submit_info TYPE rssubinfo.

  IF sy-dynnr = 1000.
    CALL FUNCTION 'RS_SUBMIT_INFO'
      IMPORTING
        p_submit_info = ls_submit_info.

    IF ls_submit_info-mode_norml IS NOT INITIAL.
      CALL FUNCTION 'RS_SET_SELSCREEN_STATUS'
        EXPORTING
          p_status  = 'SELK'
        TABLES
          p_exclude = exclude
        EXCEPTIONS
          OTHERS    = 1.
    ENDIF.
  ENDIF.

  LOOP AT SCREEN.
    CHECK screen-group1 = 'INT'.
    screen-intensified = '1'.
    MODIFY SCREEN.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FKDAB_VALIDATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fkdab_validation .
  IF NOT fkdab IS INITIAL AND
        fkdat GT fkdab.
    SET CURSOR FIELD 'FKDAB'.
    MESSAGE e650(db).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_EXDATE_SHOW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_exdate_show .
  CALL FUNCTION 'HELP_OBJECT_SHOW'
    EXPORTING
      dokclass                      = 'DE'
      dokname                       = 'BTCSDATE'
      called_by_program             = gd_repid
      called_by_dynp                = sy-dynnr
      called_for_field              = 'EXDATE'
      called_for_tab_fld_btch_input = 'EXDATE'
      called_by_cuastat             = sy-pfkey
    TABLES
      links                         = links
    EXCEPTIONS
      object_not_found              = 1
      sapscript_error               = 2
      OTHERS                        = 3.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_EXTIME_SHOW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_extime_show .
  CALL FUNCTION 'HELP_OBJECT_SHOW'
    EXPORTING
      dokclass                      = 'DE'
      dokname                       = 'BTCSTIME'
      called_by_program             = gd_repid
      called_by_dynp                = sy-dynnr
      called_for_field              = 'EXTIME'
      called_for_tab_fld_btch_input = 'EXTIME'
      called_by_cuastat             = sy-pfkey
    TABLES
      links                         = links
    EXCEPTIONS
      object_not_found              = 1
      sapscript_error               = 2
      OTHERS                        = 3.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_IMMEDI_HELP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_immedi_help .
  CALL FUNCTION 'HELP_OBJECT_SHOW'
    EXPORTING
      dokclass                      = 'DE'
      dokname                       = 'BTCSTRTMOD'
      called_by_program             = gd_repid
      called_by_dynp                = sy-dynnr
      called_for_field              = 'IMMEDI'
      called_for_tab_fld_btch_input = 'IMMEDI'
      called_by_cuastat             = sy-pfkey
    TABLES
      links                         = links
    EXCEPTIONS
      object_not_found              = 1
      sapscript_error               = 2
      OTHERS                        = 3.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_TEST_HELP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_test_help .
  CALL FUNCTION 'HELP_OBJECT_SHOW'
    EXPORTING
      dokclass                      = 'DE'
      dokname                       = 'TSTFLAG'
      called_by_program             = gd_repid
      called_by_dynp                = sy-dynnr
      called_for_field              = 'TEST'
      called_for_tab_fld_btch_input = 'TEST'
      called_by_cuastat             = sy-pfkey
    TABLES
      links                         = links
    EXCEPTIONS
      object_not_found              = 1
      sapscript_error               = 2
      OTHERS                        = 3.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SHOW_UTASY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_show_utasy .
  CALL FUNCTION 'HELP_OBJECT_SHOW'
    EXPORTING
      dokclass                      = 'DE'
      dokname                       = 'UTASY'
      called_by_program             = gd_repid
      called_by_dynp                = sy-dynnr
      called_for_field              = 'UTASY'
      called_for_tab_fld_btch_input = 'UTASY'
      called_by_cuastat             = sy-pfkey
    TABLES
      links                         = links
    EXCEPTIONS
      object_not_found              = 1
      sapscript_error               = 2
      OTHERS                        = 3.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SHOW_UTSWL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_show_utswl .
  CALL FUNCTION 'HELP_OBJECT_SHOW'
    EXPORTING
      dokclass                      = 'DE'
      dokname                       = 'UTSWL'
      called_by_program             = gd_repid
      called_by_dynp                = sy-dynnr
      called_for_field              = 'UTSWL'
      called_for_tab_fld_btch_input = 'UTSWL'
      called_by_cuastat             = sy-pfkey
    TABLES
      links                         = links
    EXCEPTIONS
      object_not_found              = 1
      sapscript_error               = 2
      OTHERS                        = 3.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SHOW_UTNSL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_show_utnsl .
  CALL FUNCTION 'HELP_OBJECT_SHOW'
    EXPORTING
      dokclass                      = 'DE'
      dokname                       = 'UTSNL'
      called_by_program             = gd_repid
      called_by_dynp                = sy-dynnr
      called_for_field              = 'UTSNL'
      called_for_tab_fld_btch_input = 'UTSNL'
      called_by_cuastat             = sy-pfkey
    TABLES
      links                         = links
    EXCEPTIONS
      object_not_found              = 1
      sapscript_error               = 2
      OTHERS                        = 3.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SHOW_NUMBJOBS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_show_numbjobs .
  CALL FUNCTION 'HELP_OBJECT_SHOW'
    EXPORTING
      dokclass                      = 'DE'
      dokname                       = 'NUMBJOBS'
      called_by_program             = gd_repid
      called_by_dynp                = sy-dynnr
      called_for_field              = 'NUMBJOBS'
      called_for_tab_fld_btch_input = 'NUMBJOBS'
      called_by_cuastat             = sy-pfkey
    TABLES
      links                         = links
    EXCEPTIONS
      object_not_found              = 1
      sapscript_error               = 2
      OTHERS                        = 3.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SHOW_VBELN_LOW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_show_vbeln_low .
CALL FUNCTION 'HELP_OBJECT_SHOW'
    EXPORTING
      dokclass                      = 'DE'
      dokname                       = 'VBELN'
      called_by_program             = gd_repid
      called_by_dynp                = sy-dynnr
      called_for_field              = 'X_VBELN-LOW'
      called_for_tab_fld_btch_input = 'X_VBELN-LOW'
      called_by_cuastat             = sy-pfkey
    TABLES
      links                         = links
    EXCEPTIONS
      object_not_found              = 1
      sapscript_error               = 2
      OTHERS                        = 3.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SHOW_VBELN_HIGH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_show_vbeln_high .
  CALL FUNCTION 'HELP_OBJECT_SHOW'
    EXPORTING
      dokclass                      = 'DE'
      dokname                       = 'VBELN'
      called_by_program             = gd_repid
      called_by_dynp                = sy-dynnr
      called_for_field              = 'X_VBELN-HIGH'
      called_for_tab_fld_btch_input = 'X_VBELN-HIGH'
      called_by_cuastat             = sy-pfkey
    TABLES
      links                         = links
    EXCEPTIONS
      object_not_found              = 1
      sapscript_error               = 2
      OTHERS                        = 3.

ENDFORM.
