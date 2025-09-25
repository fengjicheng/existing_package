*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_MAINTAIN_CONSTANT_ENTRIES
* PROGRAM DESCRIPTION: This Program is  for maintina constant entries
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE: 02/27/2020
* OBJECT ID:     ERPM-12528
* TRANSPORT NUMBER(S): ED2K917665
* Modifications :
*   1)  Delete/Insert/Modifiy the Wiley constant table entires by using this program
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918271
* REFERENCE NO: ERPM-10175 (E244)
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 2020-06-24
* DESCRIPTION: Journal First Print Optimization
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*&---------------------------------------------------------------------*
REPORT zca_maintain_constant_entries NO STANDARD PAGE HEADING
                           LINE-SIZE 132
                           LINE-COUNT 65
                           MESSAGE-ID zqtc_r2.

TABLES: zcaconstant.

*======================================================================*
* Includes                                                             *
*======================================================================*
INCLUDE zca_maintain_const_ent_top.


*======================================================================*
* INITILAZATION                                                             *
*======================================================================*
INITIALIZATION.

  IF sy-tcode NE c_se38 AND v_devid IS INITIAL.
    SELECT SINGLE low FROM zcaconstant
             INTO v_devid
             WHERE param1 = sy-tcode.
    IF sy-subrc EQ 0.
    ELSE.
      CLEAR v_devid.
    ENDIF.
  ENDIF.
*======================================================================*
* AT SELECTION-SCREEN OUTPUT (PBO-Zeitpunkt)                *
*======================================================================*
AT SELECTION-SCREEN.

AT SELECTION-SCREEN OUTPUT.
  IF v_devid IS NOT INITIAL.
    LOOP AT SCREEN.
      IF screen-name = 'P_DEVID'.
        screen-active = '0'.
        MODIFY SCREEN.
        LEAVE TO SCREEN 0.
      ENDIF.
    ENDLOOP.
  ENDIF.

AT SELECTION-SCREEN ON p_devid.
  SELECT SINGLE devid FROM zcaconstant
           INTO v_devid
           WHERE devid = p_devid.
  IF sy-subrc NE 0.
    MESSAGE e000(zqtc_r2) WITH 'Please enter a valid Development ID'(030).
  ENDIF.
*======================================================================*
* START-OF-SELECTION                *
*======================================================================*
START-OF-SELECTION.
*IF sy-tcode EQ c_zqtc_rel_ord_maint.
*INCLUDE zca_main_const_ent_rel_ord.
*ELSE.
* Get data
  PERFORM f_get_data.
* Display Report
  PERFORM f_display_alv_report.
*ENDIF.
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
  CLEAR :i_zcaconstant[].
*- Checking Selection paramter value having data or not
  IF p_devid IS NOT INITIAL.
    v_devid = p_devid.
  ENDIF.
*- Checking DEVID is intial or not
  IF v_devid IS NOT INITIAL.
*- get ZCACONSTANT entries againest to DEVID
    SELECT mandt
           devid
           param1
           param2
           srno
           sign
           opti
           low
           high
           activate
           description
           aenam
           aedat
    FROM zcaconstant
    INTO TABLE i_zcaconstant
    WHERE devid = v_devid.

    IF sy-subrc EQ 0.

    ELSE.
      CLEAR i_zcaconstant[].
    ENDIF.
    IF sy-tcode EQ c_zqtc_rel_ord_maint.
      SORT i_zcaconstant  BY devid param1 param2 srno.
      DELETE i_zcaconstant WHERE param1 = 'ITEM_CAT_GRP'.
      DELETE i_zcaconstant WHERE param1 = 'CONTRACT_TYPE'.
    ENDIF.
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
  SORT i_zcaconstant  BY devid param1 param2 srno.
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
      t_outtab                 = i_zcaconstant
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
  IF sy-tcode =  c_zqtc_rel_ord_maint.
    SET PF-STATUS 'ZSTANDARD2'.
  ELSE.
    SET PF-STATUS 'ZSTANDARD1'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_top_of_page ##CALLED.
*ALV Header declarations
  DATA: li_header      TYPE slis_t_listheader,
        lst_header     TYPE slis_listheader,
        lv_description TYPE char80.
* TITLE
  lst_header-typ = lc_typ_h . "'H'
  CLEAR lv_description.
*- Get The Description
  SELECT SINGLE description FROM zcaconstant
  INTO lv_description
  WHERE param1 = sy-tcode.  "Specifying the left-most/least specific key fields in a WHERE clause improves efficiency

  IF sy-subrc EQ 0 AND lv_description IS NOT INITIAL.
    lst_header-info = lv_description.
  ELSE.
    CONCATENATE 'Development ID:'(031) v_devid INTO   lst_header-info  SEPARATED BY space. "Development ID:
  ENDIF.

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
       lst_final    TYPE zcaconstant,
       lv_lines_tmp TYPE char6,
       i_rowindex   TYPE lvc_t_row.
  CONSTANTS: lc_insert    TYPE syst_ucomm     VALUE '&INSERT',       " ABAP System Field: PAI-Triggering Function Code
             lc_deactivat TYPE syst_ucomm     VALUE '&DEACTIVAT', " ABAP System Field: PAI-Triggering Function Code
             lc_activate  TYPE syst_ucomm     VALUE '&ACTIVATE', " ABAP System Field: PAI-Triggering Function Code
             lc_delete    TYPE syst_ucomm     VALUE '&DELETE', " ABAP System Field: PAI-Triggering Function Code
             lc_process   TYPE syst_ucomm     VALUE '&PROCESS'.   " ABAP System Field: PAI-Triggering Function Code

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING "getting alv grid details
      e_grid = lcl_ref_grid.
  CALL METHOD lcl_ref_grid->check_changed_data. "checking and modifying
  CALL METHOD lcl_ref_grid->get_selected_rows "checking and modifying
    IMPORTING
      et_index_rows = i_rowindex.

  DESCRIBE TABLE i_rowindex LINES DATA(lv_lines).

  IF lv_lines EQ 1.
    CASE fp_ucomm.
*- If user selects new entry
      WHEN lc_insert.
        CLEAR: zcaconstant,
               li_outtab[].
        READ TABLE i_zcaconstant ASSIGNING FIELD-SYMBOL(<lst_final1>) INDEX fp_lst_selfield-tabindex.
        IF sy-subrc EQ 0.
          lst_final = <lst_final1>.
          zcaconstant-param1 = lst_final-param1.
          zcaconstant-param2 = lst_final-param2.
          DATA(i_zcaconstant_tmp) = i_zcaconstant[].
          DELETE i_zcaconstant_tmp WHERE param1 NE zcaconstant-param1.
          CLEAR lv_lines_tmp.
          DESCRIBE TABLE i_zcaconstant_tmp LINES lv_lines_tmp.
          CONDENSE lv_lines_tmp.
          zcaconstant-srno = lv_lines_tmp + 1.
*- Call popup screen
          CALL SCREEN 9001 STARTING AT  10 08
                           ENDING AT 70 15.
          IF li_outtab[] IS NOT INITIAL.
            LOOP AT li_outtab INTO st_outtab.
              APPEND st_outtab TO i_zcaconstant.
              CLEAR: st_outtab.
            ENDLOOP.
          ENDIF.
          SORT i_zcaconstant  BY devid param1 param2 srno.
*- Redisplay the first screen
          CALL METHOD lcl_ref_grid->refresh_table_display.
        ENDIF.
      WHEN lc_deactivat.
*- If user selects deactivate entry
        READ TABLE i_zcaconstant ASSIGNING FIELD-SYMBOL(<lst_final>) INDEX fp_lst_selfield-tabindex.
        IF sy-subrc EQ 0.
          lst_final = <lst_final>.
          CLEAR:v_title,
                v_question,
                v_answer.
          v_title = 'Deactivation Confirmation'(023).
          v_question = 'Do you want to Deactivate the selected entry'(024).
          PERFORM popup_screen USING v_title
                                     v_question
                                     v_answer.
          IF v_answer EQ 1.
            CLEAR lst_final-mandt.
            lst_final-activate = space.
            lst_final-aenam = sy-uname.
            lst_final-aedat = sy-datum.
            PERFORM lock_zcaconstant.
            MODIFY zcaconstant FROM lst_final.
            PERFORM unlock_zcaconstant.
            MODIFY i_zcaconstant INDEX fp_lst_selfield-tabindex FROM lst_final TRANSPORTING  activate aenam aedat.
            SORT i_zcaconstant  BY devid param1 param2 srno.
            CALL METHOD lcl_ref_grid->check_changed_data. "checking and modifying
*- Redisplay the first screen
            CALL METHOD lcl_ref_grid->refresh_table_display.
          ELSE.
            SORT i_zcaconstant  BY devid param1 param2 srno.
            CALL METHOD lcl_ref_grid->refresh_table_display.
          ENDIF.
        ENDIF.
      WHEN lc_activate.
*- If user selets activate entry
        READ TABLE i_zcaconstant ASSIGNING FIELD-SYMBOL(<lst_final2>) INDEX fp_lst_selfield-tabindex.
        IF sy-subrc EQ 0.
          lst_final = <lst_final2>.
          CLEAR:v_title,
                v_question,
                v_answer.
          v_title = 'Activation Confirmation'(025).
          v_question = 'Do you want to Activate the selected entry'(026).
          PERFORM popup_screen USING v_title
                                     v_question
                                     v_answer.
          IF v_answer EQ 1.
            lst_final-activate = abap_true.
            lst_final-aenam = sy-uname.
            lst_final-aedat = sy-datum.
            PERFORM lock_zcaconstant.
            MODIFY zcaconstant FROM lst_final.
            PERFORM unlock_zcaconstant.
            MODIFY i_zcaconstant INDEX fp_lst_selfield-tabindex FROM lst_final TRANSPORTING  activate aenam aedat.

            SORT i_zcaconstant  BY devid param1 param2 srno.
            CALL METHOD lcl_ref_grid->check_changed_data. "checking and modifying
*- Redisplay the first screen
            CALL METHOD lcl_ref_grid->refresh_table_display.

          ELSE.
            SORT i_zcaconstant  BY devid param1 param2 srno.
            CALL METHOD lcl_ref_grid->refresh_table_display.
          ENDIF.
        ENDIF.
      WHEN lc_delete.
*- If user selects delete entry
        READ TABLE i_zcaconstant ASSIGNING FIELD-SYMBOL(<lst_final3>) INDEX fp_lst_selfield-tabindex.
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
            CLEAR li_outtab[].
            APPEND lst_final TO li_outtab.
            CLEAR: lst_final,
                   st_outtab.
            PERFORM lock_zcaconstant.
            DELETE zcaconstant FROM TABLE li_outtab.
            PERFORM unlock_zcaconstant.
            DELETE i_zcaconstant INDEX fp_lst_selfield-tabindex.
            SORT i_zcaconstant  BY devid param1 param2 srno.
            CALL METHOD lcl_ref_grid->check_changed_data. "checking and modifying
            CALL METHOD lcl_ref_grid->refresh_table_display.
          ELSE.
            SORT i_zcaconstant  BY devid param1 param2 srno.
            CALL METHOD lcl_ref_grid->refresh_table_display.
          ENDIF.
        ENDIF.
      WHEN lc_process.
*- If user selects change existing entry
        READ TABLE i_zcaconstant INTO lst_final INDEX fp_lst_selfield-tabindex.
        IF sy-subrc EQ 0.
          CLEAR zcaconstant.
          MOVE lst_final TO zcaconstant.
          CALL SCREEN 9002 STARTING AT  10 08
                           ENDING AT 70 15.
          MOVE zcaconstant TO lst_final.
          MODIFY i_zcaconstant FROM lst_final INDEX fp_lst_selfield-tabindex TRANSPORTING sign opti low high description  .
          CLEAR lst_final.
          SORT i_zcaconstant  BY devid param1 param2 srno.
          CALL METHOD lcl_ref_grid->refresh_table_display.
        ENDIF.
    ENDCASE.
  ELSE.
    " BOC: ERPM-10175  KKRAVURI 24-JUNE-2020  ED2K918271
    " IF Condition is added as part of ERPM-10175 to call the Pop-up
    " Screen of 'New Entry' functionality without any record selection
    " for TCode run: 'ZSCM_VENDOR_PLANT'
    IF sy-tcode = c_zscm_vendor_plant AND fp_ucomm = lc_insert.
      CLEAR: zcaconstant, li_outtab[].
      zcaconstant-sign = 'I'.
      zcaconstant-opti = 'EQ'.
      " Call popup screen
      CALL SCREEN 9001 STARTING AT  10 08
                       ENDING AT 70 15.
      IF li_outtab[] IS NOT INITIAL.
        LOOP AT li_outtab INTO st_outtab.
          APPEND st_outtab TO i_zcaconstant.
          CLEAR st_outtab.
        ENDLOOP.
      ENDIF.
      SORT i_zcaconstant BY devid param1 param2 srno.
      " Redisplay the first screen
      CALL METHOD lcl_ref_grid->refresh_table_display.
    ELSE.
      " EOC: ERPM-10175  KKRAVURI 24-JUNE-2020  ED2K918271
      MESSAGE e000(zqtc_r2) WITH 'Please select only one record to processed further'(029).
      CALL METHOD lcl_ref_grid->check_changed_data. "checking and modifying
      CALL METHOD lcl_ref_grid->refresh_table_display.
    ENDIF.
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
  CLEAR : i_zcaconstant[],
          li_fcat_out[],
          st_fcat_out,
          st_layout,
          li_outtab[],
          st_outtab,
          v_devid,
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
            lv_counter 'DEVID'            'Development ID'(009),
            lv_counter 'PARAM1'           'Name of Variable#1'(010),
            lv_counter 'PARAM2'           'Name of Variable#2'(011),
            lv_counter 'SRNO'             'Number'(012),
            lv_counter 'SIGN'             'ID: I/E'(013),
            lv_counter 'OPTI'             'Option (EQ/BT/CP/...)'(014),
            lv_counter 'LOW'              'Lower Value'(015),
            lv_counter 'HIGH'             'Upper Value'(016),
            lv_counter 'ACTIVATE'         'Activation Flag'(017),
            lv_counter 'DESCRIPTION'      'Description'(018),
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

  CONSTANTS :           lc_tabname       TYPE tabname   VALUE 'I_ZCACONSTANT'. " Table Name

  st_fcat_out-col_pos      = fp_col + 1.
  st_fcat_out-lowercase    = abap_true.
  st_fcat_out-fieldname    = fp_fld.
  st_fcat_out-tabname      = lc_tabname. "'I_OUTPUT_X'.
  st_fcat_out-seltext_m    = fp_title.

  IF fp_fld = 'MANDT'.
    st_fcat_out-no_out    = abap_true.
  ENDIF.
  IF fp_fld = 'DEVID'.
    st_fcat_out-no_out    = abap_true.
  ENDIF.
  IF fp_fld = 'SRNO' OR fp_fld = 'SIGN' OR fp_fld = 'OPTI' OR fp_fld = 'ACTIVATE'.
    st_fcat_out-just    = c_c.
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
  IF sy-tcode EQ   c_zqtc_rel_ord_maint AND zcaconstant-param1 = 'POSTAL_CODE'.
    LOOP AT SCREEN.
      CASE screen-name.
        WHEN 'ZCACONSTANT-PARAM1'.
          screen-display_3d = 0.
          MODIFY SCREEN.
        WHEN 'ZCACONSTANT-SRNO'.
          screen-display_3d = 0.
          MODIFY SCREEN.
        WHEN OTHERS.
          " Nothing to do
      ENDCASE.
    ENDLOOP.
    " BOC: ERPM-10175  KKRAVURI 24-JUNE-2020  ED2K918271
    " Below ELSEIF block is added to make Variable#1 and
    " Number fields as Inputable on 'New Entry' Pop-up
  ELSEIF sy-tcode = c_zscm_vendor_plant.
    LOOP AT SCREEN.
      CASE screen-name.
        WHEN 'ZCACONSTANT-PARAM1'.
          screen-input = 1.
          screen-required = 1.
          MODIFY SCREEN.
        WHEN 'ZCACONSTANT-SRNO'.
          screen-input = 1.
          screen-required = 1.
          MODIFY SCREEN.
        WHEN OTHERS.
          " Nothing to do
      ENDCASE.
    ENDLOOP.
    " EOC: ERPM-10175  KKRAVURI 24-JUNE-2020  ED2K918271
  ELSE.
    LOOP AT SCREEN.
      CASE screen-name.
        WHEN 'ZCACONSTANT-PARAM1'.
          screen-display_3d = 0.
          MODIFY SCREEN.
        WHEN 'ZCACONSTANT-SRNO'.
          screen-display_3d = 0.
          MODIFY SCREEN.
        WHEN 'ZCACONSTANT-PARAM2'.
          screen-input = 0.
          MODIFY SCREEN.
        WHEN OTHERS.
          " Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF.
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
      CLEAR li_outtab[].
      LEAVE TO SCREEN 0.
    WHEN c_save.
      CLEAR li_outtab[].
      st_outtab-mandt = sy-mandt.
      st_outtab-devid = v_devid.
      st_outtab-param1 = zcaconstant-param1.
      st_outtab-param2 = zcaconstant-param2.
      st_outtab-srno  = zcaconstant-srno.
      st_outtab-sign = zcaconstant-sign.
      st_outtab-opti = zcaconstant-opti.
      st_outtab-low = zcaconstant-low.
      st_outtab-high = zcaconstant-high.
      st_outtab-activate = abap_true.
      st_outtab-description = zcaconstant-description.
      st_outtab-aenam = sy-uname.
      st_outtab-aedat = sy-datum.
      APPEND st_outtab TO li_outtab.
      CLEAR st_outtab.
      PERFORM lock_zcaconstant.
      MODIFY zcaconstant FROM TABLE li_outtab.
      PERFORM unlock_zcaconstant.
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
      CLEAR li_outtab[].
      LEAVE TO SCREEN 0.
    WHEN c_save.
      CLEAR li_outtab[].
      st_outtab-mandt = sy-mandt.
      st_outtab-devid = v_devid.
      st_outtab-param1 = zcaconstant-param1.
      st_outtab-param2 = zcaconstant-param2.
      st_outtab-srno  = zcaconstant-srno.
      st_outtab-sign = zcaconstant-sign.
      st_outtab-opti = zcaconstant-opti.
      st_outtab-low = zcaconstant-low.
      st_outtab-high = zcaconstant-high.
      st_outtab-activate = abap_true.
      st_outtab-description = zcaconstant-description.
      st_outtab-aenam = sy-uname.
      st_outtab-aedat = sy-datum.
      APPEND st_outtab TO li_outtab.
      CLEAR st_outtab.
      PERFORM lock_zcaconstant.
      MODIFY zcaconstant FROM TABLE li_outtab.
      PERFORM unlock_zcaconstant.
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
*&      Form  LOCK_ZCACONSTANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM lock_zcaconstant .
  CALL FUNCTION 'ENQUEUE_EZZCACONSTANT'
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UNLOCK_ZCACONSTANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM unlock_zcaconstant.
  CALL FUNCTION 'DEQUEUE_EZZCACONSTANT'.
  IF sy-subrc <> 0 ##FM_SUBRC_OK.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  VALUE_ZCACONSTANT-SIGN  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE value_zcaconstant-sign INPUT.
  DATA: st_sign TYPE  ty_sign.
  CLEAR li_sign[].
  st_sign-sign = c_i.
  st_sign-desc = 'Inclusive'(032).
  APPEND st_sign TO li_sign.
  CLEAR st_sign.
  st_sign-sign = c_e.
  st_sign-desc = 'Exclusive'(033).
  APPEND st_sign TO li_sign.
  CLEAR st_sign.
*
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'SIGN'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'ZCACONSTANT-SIGN'
      value_org       = c_s
    TABLES
      value_tab       = li_sign
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALUE_ZCACONSTANT-OPTI  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE value_zcaconstant-opti INPUT.
  DATA: st_opti TYPE ty_opti.
  CLEAR li_opti[].
  st_opti-opti = c_eq.
  st_opti-desc = 'Equal'(034).
  APPEND st_opti TO li_opti.
  CLEAR st_opti.
  st_opti-opti = c_bt.
  st_opti-desc = 'Between'(036).
  APPEND st_opti TO li_opti.
  CLEAR st_opti.
  st_opti-opti = c_cp.
  st_opti-desc = 'Contains Pattern'(035).
  APPEND st_opti TO li_opti.
  CLEAR st_opti.
*
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'OPTI'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'ZCACONSTANT-OPTI'
      value_org       = c_s
    TABLES
      value_tab       = li_opti
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  AT_EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE at_exit_command INPUT.
  CASE sy-ucomm.
    WHEN c_canc.
      CLEAR li_outtab[].
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
