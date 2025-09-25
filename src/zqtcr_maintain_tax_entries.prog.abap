*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCR_MAINTAIN_TAX_ENTRIES
*-----------------------------------------------------------------------*
* REVISION NO : ED2K926349
* REFERENCE NO: EAM-3116/I0502.1
* DEVELOPER   : Vamsi Mamillapalli(VMAMILLAPA)
* DATE        : 04-May-2022
* DESCRIPTION : Program to update ZQTC_TAXCAL table entries
*&---------------------------------------------------------------------*
REPORT zqtcr_maintain_tax_entries NO STANDARD PAGE HEADING
                           LINE-SIZE 132
                           LINE-COUNT 65
                           MESSAGE-ID zqtc_r2.

TABLES: zqtc_taxcal.

*======================================================================*
* Includes                                                             *
*======================================================================*
INCLUDE zqtcn_maintain_tax_ent.
*======================================================================*
* AT SELECTION-SCREEN           *
*======================================================================*
AT SELECTION-SCREEN.
  SELECT SINGLE vkorg
    INTO @DATA(v_vkorg)
    FROM tvko
    WHERE vkorg = @p_vkorg.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE e012.
  ENDIF.
*======================================================================*
* START-OF-SELECTION                *
*======================================================================*
START-OF-SELECTION.

* Get data
  PERFORM f_get_data.
* Display Report
  PERFORM f_display_alv_report.
* Clar the Varibles and Tables
  PERFORM f_clear_data.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data .
  CLEAR :i_taxcal[].
**- Checking Selection paramter value having data or not
*  IF p_devid IS NOT INITIAL.
*    v_devid = p_devid.
*  ENDIF.

  SELECT mandt
         vkorg
         vtweg
         spart
         mvgr4
         datab
         datbi
         kbetr
         aenam
         aedat
  FROM zqtc_taxcal
  INTO TABLE i_taxcal
  WHERE vkorg = p_vkorg.

  IF sy-subrc EQ 0.

  ELSE.
    CLEAR i_taxcal[].
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV_REPORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_alv_report.
  DATA: lst_layout   TYPE slis_layout_alv.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Displaying Results'(002).
*- Layout
  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.
*- Fieldcatlog
  PERFORM f_popul_field_catalog.
*  SORT i_zcaconstant  BY devid param1 param2 srno.
*- Display the report through ALV
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = lc_pf_status
      i_callback_user_command  = lc_user_comm
      i_callback_top_of_page   = lc_top_of_page
      is_layout                = lst_layout
      it_fieldcat              = li_fcat_out
    TABLES
      t_outtab                 = i_taxcal
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_set_pf_status
*&---------------------------------------------------------------------*
*       Set the PF Status for ALV
*----------------------------------------------------------------------*
FORM f_set_pf_status USING li_extab TYPE slis_t_extab ##NEEDED. "#EC CALLED
  SET PF-STATUS 'ZSTANDARD1'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_top_of_page ##CALLED.
*ALV Header declarations
  DATA: li_header  TYPE slis_t_listheader,
        lst_header TYPE slis_listheader.
* TITLE
  lst_header-typ = lc_typ_h . "'H'

  CONCATENATE 'Sales Org:'(031) p_vkorg INTO   lst_header-info  SEPARATED BY space. "Development ID:
  APPEND lst_header TO li_header.
  CLEAR lst_header.
  DELETE li_header WHERE info IS INITIAL.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_header.

ENDFORM. "APPLICATION_SERVER
FORM f_user_command USING fp_ucomm TYPE syst_ucomm ##CALLED " ABAP System Field: PAI-Triggering Function Code
                          fp_lst_selfield TYPE slis_selfield.

  DATA:lcl_ref_grid TYPE REF TO cl_gui_alv_grid, " ALV List Viewer
*       lst_final    TYPE zcaconstant,
       lst_final    TYPE zqtc_taxcal,
       lv_lines_tmp TYPE char6,
       i_rowindex   TYPE lvc_t_row.
  CONSTANTS: lc_insert  TYPE syst_ucomm     VALUE '&INSERT',       " ABAP System Field: PAI-Triggering Function Code
             lc_delete  TYPE syst_ucomm     VALUE '&DELETE', " ABAP System Field: PAI-Triggering Function Code
             lc_process TYPE syst_ucomm     VALUE '&PROCESS'.   " ABAP System Field: PAI-Triggering Function Code

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING "getting alv grid details
      e_grid = lcl_ref_grid.
  CALL METHOD lcl_ref_grid->check_changed_data. "checking and modifying
  CALL METHOD lcl_ref_grid->get_selected_rows "checking and modifying
    IMPORTING
      et_index_rows = i_rowindex.

  DESCRIBE TABLE i_rowindex LINES DATA(lv_lines).

  IF lv_lines LE 1.
    CASE fp_ucomm.
*- If user selects new entry
      WHEN lc_insert.
        CLEAR: zqtc_taxcal,
               i_outtab[].
        READ TABLE i_taxcal ASSIGNING FIELD-SYMBOL(<lst_final1>) INDEX fp_lst_selfield-tabindex.
        IF sy-subrc EQ 0.
          lst_final = <lst_final1>.
          zqtc_taxcal-vkorg = lst_final-vkorg.
          DATA(i_taxcal_tmp) = i_taxcal[].
          DELETE i_taxcal_tmp WHERE vkorg NE zqtc_taxcal-vkorg.
          CLEAR lv_lines_tmp.
          DESCRIBE TABLE i_taxcal_tmp LINES lv_lines_tmp.
          CONDENSE lv_lines_tmp.
*- Call popup screen
          CALL SCREEN 9001 STARTING AT  10 08
                           ENDING AT 70 15.
          IF i_outtab[] IS NOT INITIAL.
            LOOP AT i_outtab INTO st_outtab.
              READ TABLE i_taxcal ASSIGNING FIELD-SYMBOL(<lfs_taxcal>)
              WITH  KEY vkorg = st_outtab-vkorg
                        vtweg = st_outtab-vtweg
                        spart = st_outtab-spart
                        mvgr4 = st_outtab-mvgr4
                        datab = st_outtab-datab.
              IF sy-subrc IS NOT INITIAL.
                APPEND st_outtab TO i_taxcal.
              ELSE.
                <lfs_taxcal>-kbetr = st_outtab-kbetr.
                <lfs_taxcal>-datbi = st_outtab-datbi.
              ENDIF.
              CLEAR: st_outtab.
            ENDLOOP.
          ENDIF.
          SORT i_taxcal  BY vkorg vtweg spart mvgr4.
*- Redisplay the first screen
          CALL METHOD lcl_ref_grid->refresh_table_display.
        ELSE.
*            Call popup screen
          CALL SCREEN 9001 STARTING AT  10 08
                           ENDING AT 70 15.
          IF i_outtab[] IS NOT INITIAL.
            LOOP AT i_outtab INTO st_outtab.
              APPEND st_outtab TO i_taxcal.
              CLEAR: st_outtab.
            ENDLOOP.
          ENDIF.
          SORT i_taxcal  BY vkorg vtweg spart mvgr4.
*- Redisplay the first screen
          CALL METHOD lcl_ref_grid->refresh_table_display.
        ENDIF.
      WHEN lc_delete.
*- If user selects delete entry
        READ TABLE i_taxcal ASSIGNING FIELD-SYMBOL(<lst_final3>) INDEX fp_lst_selfield-tabindex.
        IF sy-subrc EQ 0.
          lst_final = <lst_final3>.
          CLEAR:v_title,
                v_question,
                v_answer.
          v_title = 'Delete Confirmation'(027).
          v_question = 'Do you want to Delete the selected entry'(028).
          PERFORM popup_screen USING v_title
                                     v_question
                                     v_answer.
          IF v_answer EQ 1.
            CLEAR i_outtab[].
            APPEND lst_final TO i_outtab.
            CLEAR: lst_final,
                   st_outtab.
            PERFORM lock_zqtc_taxcal.
            DELETE zqtc_taxcal FROM TABLE i_outtab.
            PERFORM unlock_zqtc_taxcal.
            DELETE i_taxcal INDEX fp_lst_selfield-tabindex.
            SORT i_taxcal  BY vkorg vtweg spart mvgr4.
            CALL METHOD lcl_ref_grid->check_changed_data. "checking and modifying
            CALL METHOD lcl_ref_grid->refresh_table_display.
          ELSE.
            SORT i_taxcal  BY vkorg vtweg spart mvgr4.
            CALL METHOD lcl_ref_grid->refresh_table_display.
          ENDIF.
        ENDIF.
      WHEN lc_process.
*- If user selects change existing entry
        READ TABLE i_taxcal INTO lst_final INDEX fp_lst_selfield-tabindex.
        IF sy-subrc EQ 0.
          CLEAR zqtc_taxcal.
          MOVE lst_final TO zqtc_taxcal.
          CALL SCREEN 9002 STARTING AT  10 08
                           ENDING AT 70 15.
          MOVE zqtc_taxcal TO lst_final.

*
          LOOP AT i_outtab INTO st_outtab.
            UNASSIGN <lfs_taxcal>.
            READ TABLE i_taxcal ASSIGNING <lfs_taxcal>
            WITH  KEY vkorg = st_outtab-vkorg
                      vtweg = st_outtab-vtweg
                      spart = st_outtab-spart
                      mvgr4 = st_outtab-mvgr4
                      datab = st_outtab-datab.
            IF sy-subrc IS NOT INITIAL.
              APPEND st_outtab TO i_taxcal.
            ELSE.
              <lfs_taxcal>-kbetr = st_outtab-kbetr.
              <lfs_taxcal>-datbi = st_outtab-datbi.
            ENDIF.
            CLEAR: st_outtab.
          ENDLOOP.
*

*          MODIFY i_taxcal FROM lst_final INDEX fp_lst_selfield-tabindex TRANSPORTING datbi kbetr  .
          CLEAR lst_final.
          SORT i_taxcal  BY vkorg vtweg spart mvgr4.
          CALL METHOD lcl_ref_grid->refresh_table_display.
        ENDIF.
    ENDCASE.
  ELSE.
    MESSAGE e000(zqtc_r2) WITH 'Please select only one record to processed further'(029).
    CALL METHOD lcl_ref_grid->check_changed_data. "checking and modifying
    CALL METHOD lcl_ref_grid->refresh_table_display.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CLEAR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_data.
  CLEAR : i_taxcal[],
          li_fcat_out[],
          st_fcat_out,
          st_layout,
          i_outtab[],
          st_outtab,
          v_vkorg,
          v_title,
          v_question,
          v_answer,
          v_ucomm.
  IF lcl_ref_grid IS NOT INITIAL.
    CALL METHOD lcl_ref_grid->free.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_popul_field_catalog .

  REFRESH li_fcat_out.
  DATA: lv_counter TYPE sycucol VALUE 1. " Counter of type Integers
  PERFORM f_buildcat USING:
            lv_counter 'MANDT'            'Client'(008),
            lv_counter 'VKORG'            'Sales Org'(009),
            lv_counter 'VTWEG'            'Distribution Channel'(010),
            lv_counter 'SPART'            'Division'(011),
            lv_counter 'MVGR4'            'Material group 4'(012),
            lv_counter 'DATAB'            'Validity start date'(013),
            lv_counter 'DATBI'            'Validity to date'(014),
            lv_counter 'KBETR'            'Tax %'(015),
            lv_counter 'AENAM'            'Name'(019),
            lv_counter 'AEDAT'            'Date'(020).    "Success/Error Msg


ENDFORM.
*&-----------------------------------*
*&      Form  F_BUILDCAT
*&-----------------------------------
*       text
**-----------------------------------*
*      ->P_LV_COUNTER  text
*      ->P_1057   text
*      ->P_TEXT_001  text
*-----------------------------------*
FORM f_buildcat  USING  fp_col   TYPE sycucol   " Horizontal Cursor Position
                        fp_fld   TYPE fieldname " Field Name
                        fp_title TYPE itex132.  " Text Symbol length 132

  CONSTANTS :           lc_tabname       TYPE tabname   VALUE 'I_TAXCAL'. " Table Name

  st_fcat_out-col_pos      = fp_col + 1.
  st_fcat_out-lowercase    = abap_true.
  st_fcat_out-fieldname    = fp_fld.
  st_fcat_out-tabname      = lc_tabname. "'I_OUTPUT_X'.
  st_fcat_out-seltext_m    = fp_title.

  IF fp_fld = 'MANDT'.
    st_fcat_out-no_out    = abap_true.
  ENDIF.
  APPEND st_fcat_out TO li_fcat_out.
  CLEAR st_fcat_out.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9001 OUTPUT.
  SET PF-STATUS 'ALVS_GUI'.
  SET TITLEBAR 'ALV_TITLE'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.

  MOVE sy-ucomm TO  v_ucomm.

  CASE  v_ucomm.
    WHEN c_canc.
      CLEAR i_outtab[].
      LEAVE TO SCREEN 0.
    WHEN c_save1.
      IF zqtc_taxcal-datab GT zqtc_taxcal-datbi.
        MESSAGE i266."Validity from date should be less than validity to date
      ENDIF.
      CLEAR i_outtab[].
      READ TABLE i_taxcal WITH KEY mandt = sy-mandt
                                   vkorg = zqtc_taxcal-vkorg
                                   vtweg = zqtc_taxcal-vtweg
                                   spart = zqtc_taxcal-spart
                                   mvgr4 = zqtc_taxcal-mvgr4
                                   datab = zqtc_taxcal-datab TRANSPORTING NO FIELDS.
      IF sy-subrc IS INITIAL.
        MESSAGE i267."'Entry already exists with the same key'
      ELSE.
        st_outtab-mandt = sy-mandt.
        st_outtab-vkorg = zqtc_taxcal-vkorg.
        st_outtab-vtweg = zqtc_taxcal-vtweg.
        st_outtab-spart = zqtc_taxcal-spart.
        st_outtab-mvgr4 = zqtc_taxcal-mvgr4.
        st_outtab-datab = zqtc_taxcal-datab.
        st_outtab-datbi = zqtc_taxcal-datbi.
        st_outtab-kbetr = zqtc_taxcal-kbetr.
        st_outtab-aenam = sy-uname.
        st_outtab-aedat = sy-datum.
        APPEND st_outtab TO i_outtab.
        CLEAR st_outtab.
        LOOP AT i_taxcal ASSIGNING FIELD-SYMBOL(<lfs_outtab>)
          WHERE vkorg = zqtc_taxcal-vkorg AND
                vtweg = zqtc_taxcal-vtweg AND
                spart = zqtc_taxcal-spart AND
                mvgr4 = zqtc_taxcal-mvgr4 AND
                datbi GE sy-datum.

          <lfs_outtab>-datbi = zqtc_taxcal-datab - 1 .
          APPEND <lfs_outtab> TO i_outtab.
        ENDLOOP.
        PERFORM lock_zqtc_taxcal.
        MODIFY zqtc_taxcal FROM TABLE i_outtab.
        PERFORM unlock_zqtc_taxcal.
      ENDIF.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9002  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9002 OUTPUT.
  SET PF-STATUS 'GUI_9001'.
  SET TITLEBAR 'TITLE_9001'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9002  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9002 INPUT.

  MOVE sy-ucomm TO  v_ucomm.
  CASE  v_ucomm.
    WHEN c_canc.
      CLEAR i_outtab[].
      LEAVE TO SCREEN 0.
    WHEN c_save1.
      IF zqtc_taxcal-datab GT zqtc_taxcal-datbi.
        MESSAGE i266."Validity from date should be less than validity to date
      ENDIF.
      CLEAR i_outtab[].
      UNASSIGN <lfs_outtab>.
      READ TABLE i_taxcal ASSIGNING <lfs_outtab>
      WITH KEY vkorg = zqtc_taxcal-vkorg
             vtweg = zqtc_taxcal-vtweg
             spart = zqtc_taxcal-spart
             mvgr4 = zqtc_taxcal-mvgr4
             datab = zqtc_taxcal-datab.
      IF sy-subrc IS INITIAL AND <lfs_outtab>-kbetr NE zqtc_taxcal-kbetr.
        <lfs_outtab>-datbi = sy-datum - 1 .
        APPEND <lfs_outtab> TO i_outtab.
        st_outtab-datab = sy-datum.
      ELSE.
        st_outtab-datab = zqtc_taxcal-datab.
      ENDIF.

      st_outtab-mandt = sy-mandt.
      st_outtab-vkorg = zqtc_taxcal-vkorg.
      st_outtab-vtweg = zqtc_taxcal-vtweg.
      st_outtab-spart = zqtc_taxcal-spart.
      st_outtab-mvgr4 = zqtc_taxcal-mvgr4.

      st_outtab-datbi = zqtc_taxcal-datbi.
      st_outtab-kbetr = zqtc_taxcal-kbetr.
      st_outtab-aenam = sy-uname.
      st_outtab-aedat = sy-datum.
      APPEND st_outtab TO i_outtab.
      CLEAR st_outtab.
      PERFORM lock_zqtc_taxcal.
      MODIFY zqtc_taxcal FROM TABLE i_outtab.
      PERFORM unlock_zqtc_taxcal.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
FORM popup_screen  USING    p_v_title      TYPE char255
                            p_v_question   TYPE char255
                            p_v_answer     TYPE char1.
  CONSTANTS : c_2 TYPE char2 VALUE '2'.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = p_v_title
      text_question         = p_v_question
      text_button_1         = 'Yes'(021)
      text_button_2         = 'No'(022)
      default_button        = c_2
      display_cancel_button = ''
    IMPORTING
      answer                = p_v_answer
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.
  IF sy-subrc EQ 0.
  ELSE.
    CLEAR p_v_answer.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  lock_ZQTC_TAXCAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM lock_zqtc_taxcal .
  CALL FUNCTION 'ENQUEUE_EZZQTC_TAXCAL'
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UNlock_ZQTC_TAXCAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM unlock_zqtc_taxcal.
  CALL FUNCTION 'DEQUEUE_EZZQTC_TAXCAL'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  AT_EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE at_exit_command INPUT.
  CASE sy-ucomm.
    WHEN c_canc.
      CLEAR i_outtab[].
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
