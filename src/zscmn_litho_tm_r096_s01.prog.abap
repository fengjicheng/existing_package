*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTR_AR_MANDATE_XML_GEN_I0377
* PROGRAM DESCRIPTION: This report used to generate the XML file
* into AL11 directory. (XML file contains SEPA_Mandate info)
* DEVELOPER:           Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE:       18/11/2019
* OBJECT ID:           I0377
* TRANSPORT NUMBER(S): ED2K916852
*----------------------------------------------------------------------*
* REVISION HISTORY:
* REVISION NO:  <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:         MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include  ZSCM_LITHO_TM_R096_S01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_get_data.

  " Fetch the Litho Report Table Maintenance data
  SELECT mandt, tm_type, matnr, sub_type, act_date,
         sub_flag, quantity, aenam, aedat
         FROM zscm_litho_tm INTO TABLE @i_litho_tm.
  IF sy-subrc EQ 0.
    SORT i_litho_tm BY tm_type sub_type matnr.
  ELSE.
    CLEAR i_litho_tm[].
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

  " Local data declaration
  DATA: lst_layout   TYPE slis_layout_alv.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Displaying Results'(007).

  " Layout
*  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-box_fieldname  = 'SEL'.
  lst_layout-zebra          = abap_true.

  " Fieldcatlog
  PERFORM f_popul_field_catalog.

  " Display the report through ALV
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = lc_pf_status
      i_callback_user_command  = lc_user_comm
      i_callback_top_of_page   = lc_top_of_page
      is_layout                = lst_layout
      it_fieldcat              = i_fcat_out
    TABLES
      t_outtab                 = i_litho_tm
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
FORM f_set_pf_status USING li_extab TYPE slis_t_extab.

  SET PF-STATUS 'ZLITHO_TM_PFS'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form F_TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       Set the Title
*----------------------------------------------------------------------*
FORM f_top_of_page.

  " ALV Header declarations
  DATA: li_header      TYPE slis_t_listheader,
        lst_header     TYPE slis_listheader,
        lv_description TYPE char80.

  " Header Info
  lst_header-typ = lc_typ_h . "'H'
  lst_header-info = 'Maintenance Table for Renewal Period/BL-Buffer'(017).

  APPEND lst_header TO li_header.
  CLEAR lst_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_header.

ENDFORM. "APPLICATION_SERVER
*&---------------------------------------------------------------------*
*&      Form F_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_user_command USING fp_ucomm        TYPE syst_ucomm     " ABAP System Field: PAI-Triggering Function Code
                          fp_selfield TYPE slis_selfield. " Selected record

  " Local data declaration
  DATA: lv_title        TYPE char25,
        lv_question     TYPE char50,
        li_litho_tm_del TYPE STANDARD TABLE OF ty_litho_tm INITIAL SIZE 0,
        li_index_rows   TYPE lvc_t_row.

  " Local constants
  CONSTANTS:
    lc_insert TYPE syst_ucomm     VALUE '&INSERT',    " ABAP System Field: PAI-Triggering Function Code
    lc_delete TYPE syst_ucomm     VALUE '&DELETE',    " ABAP System Field: PAI-Triggering Function Code
    lc_change TYPE syst_ucomm     VALUE '&CHANGE'.    " ABAP System Field: PAI-Triggering Function Code

  " Getting ALV Grid Reference
  IF gr_alv_grid IS NOT BOUND.
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        e_grid = gr_alv_grid.
  ENDIF.

  " Get the selected row
  CALL METHOD gr_alv_grid->get_selected_rows   " checking and modifying
    IMPORTING
      et_index_rows = li_index_rows.

  " Get the selected records count
  DESCRIBE TABLE li_index_rows LINES DATA(lv_lines).

  CASE fp_ucomm.

    WHEN lc_insert.  " Insert Record
      " Call popup screen
      CALL SCREEN 9001 STARTING AT  10 08
                       ENDING AT 70 15.

    WHEN lc_delete.  " Delete Record
      IF lv_lines = 0.
        MESSAGE e000(zqtc_r2) WITH 'Please select at least one record for deletion'(018).
      ELSE.
        li_litho_tm_del[] = i_litho_tm[].
        DELETE li_litho_tm_del WHERE sel = abap_false.

        " If user selects delete entry
        IF li_litho_tm_del[] IS NOT INITIAL.
          lv_title = 'Delete Confirmation'(020).
          lv_question = 'Do you want to Delete the selected entry?'(021).
          PERFORM popup_screen USING lv_title
                                     lv_question
                                     v_answer.
          IF v_answer EQ 1.
*            PERFORM lock_zcaconstant.
            DELETE zscm_litho_tm FROM TABLE li_litho_tm_del.
            IF sy-subrc = 0.
              CLEAR: v_answer, li_litho_tm_del[].
*            PERFORM unlock_zcaconstant.
              " Fetch the latest data from DB
              PERFORM f_get_data.
              " Refresh the ALV Grid
              CALL METHOD gr_alv_grid->refresh_table_display.
            ENDIF.
          ELSE.
            REFRESH li_litho_tm_del.
          ENDIF.
        ENDIF. " IF li_litho_tm_del[] IS NOT INITIAL.
      ENDIF.

    WHEN lc_change. " Update Record
      IF lv_lines > 1.
        MESSAGE e000(zqtc_r2) WITH 'Record selection should be single for update'(019).
      ELSEIF lv_lines = 0.
        MESSAGE e000(zqtc_r2) WITH 'Please select a record for update'(023).
      ENDIF.
      " If user selects change existing entry
      READ TABLE i_litho_tm INTO DATA(lst_litho_tm) INDEX fp_selfield-tabindex.
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING lst_litho_tm TO zscm_litho_tm.
        CLEAR lst_litho_tm.
        " Call popup screen
        CALL SCREEN 9002 STARTING AT 10 08
                         ENDING AT 70 15.
      ENDIF.

    WHEN OTHERS.
      " Nothing to do

  ENDCASE.


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

  CLEAR: i_litho_tm[],
         i_fcat_out[],
         st_litho_tm,
         v_answer.
  IF gr_alv_grid IS BOUND.
    CALL METHOD gr_alv_grid->free.
    CLEAR gr_alv_grid.
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
FORM f_popul_field_catalog.

  DATA lv_counter TYPE sycucol VALUE 1. " Counter of type Integers

  PERFORM f_buildcat USING:
            lv_counter 'MANDT'            'Client'(008),
            lv_counter 'TM_TYPE'          'TM Type'(009),
            lv_counter 'SUB_TYPE'         'Subscription Type'(010),
            lv_counter 'MATNR'            'Material'(011),
            lv_counter 'ACT_DATE'         'Date of Activation'(012),
            lv_counter 'SUB_FLAG'         'Renewal Prd for Sub. Type'(013),
            lv_counter 'QUANTITY'         'Quantity'(014),
            lv_counter 'AENAM'            'Name'(015),
            lv_counter 'AEDAT'            'Date'(016).    "Success/Error Msg


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
  DATA:
   lst_fcat_out   TYPE slis_fieldcat_alv.  " ALV specific tables and structures

  CONSTANTS:
    lc_tabname TYPE tabname VALUE 'I_LITHO_TM'. " Table Name

  lst_fcat_out-col_pos      = fp_col + 1.
  lst_fcat_out-lowercase    = abap_true.
  lst_fcat_out-fieldname    = fp_fld.
  lst_fcat_out-tabname      = lc_tabname.
  lst_fcat_out-seltext_m    = fp_title.

  IF fp_fld = 'MANDT'.
    lst_fcat_out-no_out = abap_true.
  ELSEIF fp_fld = 'MATNR'.
    lst_fcat_out-outputlen = 21.
  ELSEIF fp_fld = 'SUB_TYPE'.
    lst_fcat_out-outputlen = 16.
  ELSEIF fp_fld = 'ACT_DATE'.
    lst_fcat_out-outputlen = 17.
  ELSEIF fp_fld = 'SUB_FLAG'.
    lst_fcat_out-outputlen = 17.
    lst_fcat_out-just = c_c.
  ELSEIF fp_fld = 'QUANTITY'.
    lst_fcat_out-just = 'L'.
    lst_fcat_out-outputlen = 15.
  ELSEIF fp_fld = 'AEDAT'.
    lst_fcat_out-outputlen = 15.
  ELSEIF fp_fld = 'AENAM'.
    lst_fcat_out-outputlen = 15.
  ENDIF.

  APPEND lst_fcat_out TO i_fcat_out.
  CLEAR lst_fcat_out.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9001 OUTPUT.

  SET PF-STATUS 'GUI_9001'.
  SET TITLEBAR 'TITLE_9001'.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9002  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9002 OUTPUT.

  SET PF-STATUS 'GUI_9002'.
  SET TITLEBAR 'TITLE_9002'.

  LOOP AT SCREEN.
    CASE screen-name.
      WHEN 'ZSCM_LITHO_TM-TM_TYPE'.
        screen-input = 0.
        MODIFY SCREEN.
      WHEN 'MARA-MATNR'.
        mara-matnr = zscm_litho_tm-matnr.
        screen-input = 0.
        MODIFY SCREEN.
      WHEN 'ZSCM_LITHO_TM-SUB_TYPE'.
        screen-input = 0.
        MODIFY SCREEN.
      WHEN 'ZSCM_LITHO_TM-SUB_FLAG'.
        IF zscm_litho_tm-tm_type = 'RPRD'.
          screen-input = 1.
          MODIFY SCREEN.
        ELSEIF zscm_litho_tm-tm_type = 'BLBF'.
          screen-input = 0.
          MODIFY SCREEN.
        ENDIF.
      WHEN 'ZSCM_LITHO_TM-QUANTITY'.
        IF zscm_litho_tm-tm_type = 'RPRD'.
          screen-input = 0.
          MODIFY SCREEN.
        ELSEIF zscm_litho_tm-tm_type = 'BLBF'.
          screen-input = 1.
          MODIFY SCREEN.
        ENDIF.
      WHEN OTHERS.
        " Nothing to do
    ENDCASE.
  ENDLOOP.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.

  " Local Data declaration
  DATA li_litho_tm TYPE STANDARD TABLE OF zscm_litho_tm INITIAL SIZE 0.

  CASE ok_code.

    WHEN c_canc.
      " Clear the Screen data
      CLEAR: s_matnr[],
             p_tmtyp, p_subtyp, p_datact, p_flag, p_qty.
      LEAVE TO SCREEN 0.

    WHEN c_save.
      " Validations
      IF p_tmtyp IS INITIAL.
        MESSAGE i000(zqtc_r2) WITH 'Please select TM Type'(028).
        RETURN.
      ENDIF.
      IF p_tmtyp = 'RPRD'.
        IF p_subtyp IS INITIAL.
          MESSAGE i000(zqtc_r2) WITH 'Please select Subscription Type'(029).
          RETURN.
        ENDIF.
        IF s_matnr[] IS INITIAL.
          MESSAGE i000(zqtc_r2) WITH 'Please enter Material'(030).
          RETURN.
        ENDIF.
        IF p_datact IS INITIAL.
          MESSAGE i000(zqtc_r2) WITH 'Please select Date of Activation'(031).
          RETURN.
        ENDIF.
        IF p_flag IS INITIAL.
          MESSAGE i000(zqtc_r2) WITH 'Please select Renewal Prd for Subs/OM'(032).
          RETURN.
        ENDIF.
      ELSEIF p_tmtyp = 'BLBF'.
        IF s_matnr[] IS INITIAL.
          MESSAGE i000(zqtc_r2) WITH 'Please enter Material'(030).
          RETURN.
        ENDIF.
        IF p_datact IS INITIAL.
          MESSAGE i000(zqtc_r2) WITH 'Please select Date of Activation'(031).
          RETURN.
        ENDIF.
        IF p_qty IS INITIAL.
          MESSAGE i000(zqtc_r2) WITH 'Please enter Quantity'(033).
          RETURN.
        ENDIF.
      ENDIF.
      " Structure update
      st_litho_tm-mandt    = sy-mandt.
      st_litho_tm-tm_type  = p_tmtyp.
      st_litho_tm-sub_type = p_subtyp.
      st_litho_tm-act_date = p_datact.
      st_litho_tm-sub_flag = p_flag.
      st_litho_tm-quantity = p_qty.
      st_litho_tm-aenam    = sy-uname.
      st_litho_tm-aedat    = sy-datum.
      LOOP AT s_matnr.
        st_litho_tm-matnr = s_matnr-low.
        IF s_matnr-low <> c_astrick.
          SELECT matnr FROM mara INTO @DATA(lv_matnr) UP TO 1 ROWS
                       WHERE matnr = @s_matnr-low.
          ENDSELECT.
          IF sy-subrc <> 0.
            MESSAGE i000(zqtc_r2) WITH 'Entered Invalid Material#'(027) s_matnr-low.
            RETURN.
          ENDIF.
        ENDIF.
        APPEND st_litho_tm TO li_litho_tm.
      ENDLOOP.

      " Save the record in DB table
      MODIFY zscm_litho_tm FROM TABLE li_litho_tm.
      IF sy-subrc = 0.
        " Clear the data
        CLEAR: st_litho_tm, li_litho_tm[], s_matnr[],
               p_tmtyp, p_subtyp, p_datact, p_flag, p_qty.
        " Fetch the latest data from DB
        PERFORM f_get_data.
        " Refresh the ALV Grid
        CALL METHOD gr_alv_grid->refresh_table_display.
      ELSE.
        CLEAR: st_litho_tm, li_litho_tm[].
        MESSAGE e000(zqtc_r2) WITH 'Record(s) Creation failed'(022) s_matnr-low.
      ENDIF.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
      " Nothing to do

  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9002  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9002 INPUT.

  CASE ok_code.

    WHEN c_canc.
      " Clear the screen data
      CLEAR zscm_litho_tm.
      LEAVE TO SCREEN 0.

    WHEN c_save.
      " Validations
      IF zscm_litho_tm-tm_type = 'RPRD'.
        IF zscm_litho_tm-act_date IS INITIAL.
          MESSAGE i000(zqtc_r2) WITH 'Please select Date of Activation'(031).
          RETURN.
        ENDIF.
        IF zscm_litho_tm-sub_flag IS INITIAL.
          MESSAGE i000(zqtc_r2) WITH 'Please select Renewal Prd for Subs/OM'(032).
          RETURN.
        ENDIF.
      ELSEIF zscm_litho_tm-tm_type = 'BLBF'.
        IF zscm_litho_tm-act_date IS INITIAL.
          MESSAGE i000(zqtc_r2) WITH 'Please select Date of Activation'(031).
          RETURN.
        ENDIF.
        IF zscm_litho_tm-quantity IS INITIAL.
          MESSAGE i000(zqtc_r2) WITH 'Please enter Quantity'(033).
          RETURN.
        ENDIF.
      ENDIF.

      " Structure Update
      st_litho_tm-mandt    = sy-mandt.
      st_litho_tm-tm_type  = zscm_litho_tm-tm_type.
      st_litho_tm-matnr    = mara-matnr.
      st_litho_tm-sub_type = zscm_litho_tm-sub_type.
      st_litho_tm-act_date = zscm_litho_tm-act_date.
      st_litho_tm-sub_flag = zscm_litho_tm-sub_flag.
      st_litho_tm-quantity = zscm_litho_tm-quantity.
      st_litho_tm-aenam    = sy-uname.
      st_litho_tm-aedat    = sy-datum.

      " Update record in DB table
      MODIFY zscm_litho_tm FROM st_litho_tm.
      IF sy-subrc = 0.
        READ TABLE i_litho_tm ASSIGNING FIELD-SYMBOL(<lst_litho_fs>)
                               WITH KEY tm_type = st_litho_tm-tm_type
                                        sub_type = st_litho_tm-sub_type
                                        matnr = mara-matnr.
        IF sy-subrc = 0.
          IF <lst_litho_fs>-act_date <> st_litho_tm-act_date.
            <lst_litho_fs>-act_date = st_litho_tm-act_date.
          ENDIF.
          IF <lst_litho_fs>-sub_flag <> st_litho_tm-sub_flag.
            <lst_litho_fs>-sub_flag = st_litho_tm-sub_flag.
          ENDIF.
          IF <lst_litho_fs>-quantity <> st_litho_tm-quantity.
            <lst_litho_fs>-quantity = st_litho_tm-quantity.
          ENDIF.
          IF <lst_litho_fs>-aenam <> st_litho_tm-aenam.
            <lst_litho_fs>-aenam = st_litho_tm-aenam.
          ENDIF.
          IF <lst_litho_fs>-aedat <> st_litho_tm-aedat.
            <lst_litho_fs>-aedat = st_litho_tm-aedat.
          ENDIF.
        ENDIF.
        CLEAR: st_litho_tm, zscm_litho_tm, mara-matnr.
        " Refresh the ALV Grid
        CALL METHOD gr_alv_grid->refresh_table_display.
      ENDIF.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
      " Nothing to do

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  POPUP_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM popup_screen  USING  p_v_title     TYPE char25
                          p_v_question  TYPE char50
                          p_v_answer    TYPE char1.

  " Local Constants
  CONSTANTS:
    lc_2 TYPE char2 VALUE '2'.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = p_v_title
      text_question         = p_v_question
      text_button_1         = 'Yes'(024)
      text_button_2         = 'No'(025)
      default_button        = lc_2
      display_cancel_button = ''
    IMPORTING
      answer                = p_v_answer
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.
  IF sy-subrc EQ 0.
    " Nothing to do
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
FORM lock_zcaconstant.

  CALL FUNCTION 'ENQUEUE_EZZCACONSTANT'
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  IF sy-subrc <> 0.
    " Implement suitable error handling here
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
    " Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  AT_EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE at_exit_command INPUT.

  CASE sy-ucomm.

    WHEN c_canc.
      LEAVE TO SCREEN 0.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  F_SCREEN_CONTROL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_screen_control.

  IF sy-ucomm = c_tmty.
    CLEAR: s_matnr[],
           p_subtyp, p_datact, p_flag, p_qty.
  ENDIF.

  LOOP AT SCREEN.
    CASE screen-name.
      WHEN 'P_SUBTYP'.
        IF p_tmtyp = 'RPRD'.
          screen-input = 1.
          MODIFY SCREEN.
        ELSEIF p_tmtyp = 'BLBF'.
          screen-input = 0.
          MODIFY SCREEN.
          CLEAR p_subtyp.
        ENDIF.
      WHEN 'P_FLAG'.
        IF p_tmtyp = 'RPRD'.
          screen-input = 1.
          MODIFY SCREEN.
        ELSEIF p_tmtyp = 'BLBF'.
          screen-input = 0.
          MODIFY SCREEN.
          CLEAR p_flag.
        ENDIF.
      WHEN 'P_QTY'.
        IF p_tmtyp = 'RPRD'.
          screen-input = 0.
          MODIFY SCREEN.
          CLEAR p_qty.
        ELSEIF p_tmtyp = 'BLBF'.
          screen-input = 1.
          MODIFY SCREEN.
        ENDIF.
      WHEN OTHERS.
        " Nothing to do
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_DEFAULTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_set_defaults.

  DATA: lw_opt_list TYPE sscr_opt_list,
        lw_restrict TYPE sscr_restrict,
        lw_ass      TYPE sscr_ass.

  lw_opt_list-name = c_opt_list.
  lw_opt_list-options-bt = space.
  lw_opt_list-options-eq = abap_true.
  APPEND lw_opt_list TO lw_restrict-opt_list_tab.

  lw_ass-kind = c_s.
  lw_ass-name = c_matnr.
  lw_ass-sg_main = c_inc.
  lw_ass-op_main = c_opt_list.
  APPEND lw_ass TO lw_restrict-ass_tab.

  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING
      restriction            = lw_restrict
    EXCEPTIONS
      too_late               = 1
      repeated               = 2
      selopt_without_options = 3
      selopt_without_signs   = 4
      invalid_sign           = 5
      empty_option_list      = 6
      invalid_kind           = 7
      repeated_kind_a        = 8
      OTHERS                 = 9.


ENDFORM.
