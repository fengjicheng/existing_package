*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SHIPPING_PLAN_CONV_SUB (Include Program)
* PROGRAM DESCRIPTION: Shipping Plan Conversion
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   01/02/2017
* OBJECT ID:  C075
* TRANSPORT NUMBER(S): ED2K903953
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K903942
* REFERENCE NO: ERP-6564
* DEVELOPER: Writtick Roy
* DATE:  2018-02-07
* DESCRIPTION: Implement logic to populate File path
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_MODIFY_SCREEN
*&---------------------------------------------------------------------*
*     This Perform is for Screen Modification
*----------------------------------------------------------------------*

FORM f_modify_screen .
  IF rb_pres EQ abap_true." Presentation server
    LOOP AT SCREEN.
      IF screen-name = 'P_PR_PH'.
        screen-input = 1.
        screen-active = 1.
        screen-invisible = 0.
        MODIFY SCREEN.

      ELSEIF screen-name = 'P_AP_PH'.
        screen-input = 0.
        screen-active = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF rb_appl EQ abap_true. "appliocation server
    LOOP AT SCREEN.
      IF screen-name = 'P_AP_PH'.
        screen-input = 1.
        screen-active = 1.
        screen-invisible = 0.
        MODIFY SCREEN.

      ELSEIF screen-name = 'P_PR_PH'.
        screen-input = 0.
        screen-active = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOCALFILE_F4
*&---------------------------------------------------------------------*
*    This perform is for application server F4 help
*----------------------------------------------------------------------*

FORM f_localfile_f4 .
* F4 value population*
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
    IMPORTING
      file_name     = p_pr_ph.

  IF p_pr_ph IS NOT INITIAL.
    v_pr_ph = p_pr_ph. " assigning path to variable
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SERVERFILE_F4
*&---------------------------------------------------------------------*
*      This perform is for application server F4 help
*----------------------------------------------------------------------*

FORM f_serverfile_f4 .
*** Calling FM for F4 help
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    IMPORTING
      serverfile       = p_ap_ph
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.

  IF sy-subrc = 0.
    v_ap_ph = p_ap_ph. " assigning path to variable
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_PRES_DATA
*&---------------------------------------------------------------------*
*     This perform is for presentation server data uploading
*----------------------------------------------------------------------*
FORM f_upload_pres_data .
*** Local Data Declaration
  DATA: lst_input TYPE ty_input,
        lst_fdata TYPE ty_fdata.
*** Local Constant Declaration
  CONSTANTS: lc_asc TYPE char10 VALUE 'ASC'.

* Begin of ADD:ERP-6564:WROY:07-Feb-2018:ED2K903942
  IF v_pr_ph IS INITIAL.
    v_pr_ph = p_pr_ph.
  ENDIF.
* End   of ADD:ERP-6564:WROY:07-Feb-2018:ED2K903942
*** Call FM to retrieve the file data
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = v_pr_ph
      filetype                = lc_asc
      has_field_separator     = abap_true
    TABLES
      data_tab                = i_input
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE i088(zqtc_r2). " displaying info message
    LEAVE LIST-PROCESSING.
  ELSEIF i_input IS NOT INITIAL.
*   Ignore 1st Line for Column Headers
    IF cb_head IS NOT INITIAL.
      DELETE i_input INDEX 1.
    ENDIF.

    LOOP AT i_input INTO lst_input. " preparing file data
      lst_fdata-matnr = lst_input-matnr.
      lst_fdata-nod = lst_input-nod.
      APPEND lst_fdata TO i_fdata.
      CLEAR: lst_fdata.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_APPL_DATA
*&---------------------------------------------------------------------*
*    This perform is for application server data uploading
*----------------------------------------------------------------------*

FORM f_upload_appl_data .
*** Local Data declaration
  DATA: lst_string  TYPE string,
        lst_input   TYPE ty_input,
        lst_fdata   TYPE ty_fdata,
        lv_subrc    TYPE sy-subrc,
        lv_filepath TYPE string.

* Begin of ADD:ERP-6564:WROY:07-Feb-2018:ED2K903942
  IF v_ap_ph IS INITIAL.
    v_ap_ph = p_ap_ph.
  ENDIF.
* End   of ADD:ERP-6564:WROY:07-Feb-2018:ED2K903942
  lv_filepath = v_ap_ph.

  IF lv_filepath IS NOT INITIAL.
    OPEN DATASET lv_filepath FOR INPUT IN TEXT MODE ENCODING DEFAULT." opening the file
    IF sy-subrc NE 0.
      MESSAGE i089(zqtc_r2).
    ELSE.
      WHILE lv_subrc = 0.
        CLEAR: lst_string, lst_input.
        READ DATASET lv_filepath INTO lst_string." Reading the file
        IF sy-subrc = 0.
          SPLIT lst_string AT c_tab INTO
          lst_input-matnr
          lst_input-nod.

          APPEND lst_input TO i_input.
          CLEAR: lst_input,lst_string.
        ELSE.
          lv_subrc = 4.
        ENDIF.
      ENDWHILE.
      CLOSE DATASET lv_filepath." Closing the file
    ENDIF.
    IF i_input[] IS NOT INITIAL.
*     Ignore 1st Line for Column Headers
      IF cb_head IS NOT INITIAL.
        DELETE i_input INDEX 1.
      ENDIF.

      LOOP AT i_input INTO lst_input.
        lst_fdata-matnr = lst_input-matnr.
        lst_fdata-nod = lst_input-nod.
        APPEND lst_fdata TO i_fdata.
        CLEAR: lst_fdata.
      ENDLOOP.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATION_MATERIAL
*&---------------------------------------------------------------------*
*    This perform is used to validate the Material
*----------------------------------------------------------------------*

FORM f_validation_material .
*** Local Types Declaration
  TYPES: BEGIN OF lty_valid,
           matnr TYPE matnr,
         END OF lty_valid.
*** Local data declaration
  DATA: li_fdata   TYPE STANDARD TABLE OF ty_fdata,
        li_disp    TYPE STANDARD TABLE OF ty_disp,
        lst_fdata  TYPE ty_fdata,
        lst_disp   TYPE ty_disp,
        lst_final  TYPE ty_final,
        li_valid   TYPE STANDARD TABLE OF lty_valid INITIAL SIZE 0
                     WITH NON-UNIQUE SORTED KEY material COMPONENTS matnr,
        lst_valmat TYPE ty_fdata,
        lst_valid  TYPE lty_valid.
*** Local Constant Declaration
  CONSTANTS:lc_redl TYPE char4 VALUE '@0A@'. "Red signal


  li_fdata = i_fdata.
*** Selectiing Data from Mara
  SELECT matnr
    INTO TABLE li_valid
    FROM mara
    FOR ALL ENTRIES IN li_fdata
    WHERE matnr = li_fdata-matnr.


  IF sy-subrc = 0.
    LOOP AT li_fdata INTO lst_fdata.
      READ TABLE li_valid INTO lst_valid WITH TABLE KEY material COMPONENTS
      matnr = lst_fdata-matnr. "explicit key specification Binary Search not permitted

      IF sy-subrc = 0.
        lst_disp-matnr = lst_fdata-matnr.
        lst_disp-nod   = lst_fdata-nod.
        lst_disp-status = '1'. " Not valid

        APPEND lst_disp TO li_disp.
        CLEAR: lst_disp.
        " appending only valid materials
        lst_valmat = lst_fdata.
        APPEND lst_valmat TO i_valmat.
        CLEAR lst_valmat.
      ELSE.
        v_erflag = abap_true.
        lst_disp-matnr = lst_fdata-matnr.
        lst_disp-nod   = lst_fdata-nod.
        lst_disp-status = 3.  " Not valid
        APPEND lst_disp TO li_disp.
        lst_final-matnr = lst_disp-matnr. " preparing Final tbl if not a valid material
        lst_final-nod = lst_disp-nod.
        lst_final-status = lc_redl.
        lst_final-ermsg = text-010.
        APPEND lst_final TO i_final.
        CLEAR: lst_disp,lst_final.
      ENDIF.
      CLEAR lst_valid.
    ENDLOOP.
  ELSE. " all thye materials are invalid
    v_erflag = abap_true.
    LOOP AT li_fdata INTO lst_fdata.
      lst_final-matnr = lst_fdata-matnr.
      lst_final-nod = lst_fdata-nod.
      lst_final-status = lc_redl.
      lst_final-ermsg = text-010.
      APPEND lst_final TO i_final.
      CLEAR lst_final.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*    This perform is used  for  Building field catalogue.
*----------------------------------------------------------------------*

FORM f_build_fcat .
*** Local Data Declaration
  DATA: lst_fieldcat TYPE slis_fieldcat_alv,
        lv_col_pos   TYPE i VALUE 0.    "alv FIELD CAT
*** Local Constant Declaration
  CONSTANTS: lc_material   TYPE slis_fieldname VALUE 'MATNR',
             lc_nod        TYPE slis_fieldname VALUE 'NOD',
             lc_medp       TYPE slis_fieldname VALUE 'MEDP',
             lc_cald       TYPE slis_fieldname VALUE 'CALD',
             lc_stat       TYPE slis_fieldname VALUE 'STATUS',
             lc_ermsg      TYPE slis_fieldname VALUE 'ERMSG',
             lc_200        TYPE outputlen      VALUE '200',
             lc_20         TYPE outputlen      VALUE '20',
             lc_3          TYPE outputlen      VALUE '3',
             lc_output_tab TYPE slis_tabname   VALUE 'I_FINAL'.

  "Material
  lv_col_pos = lv_col_pos + 1.
  CLEAR lst_fieldcat.
  lst_fieldcat-col_pos = lv_col_pos.
  lst_fieldcat-tabname = lc_output_tab.
  lst_fieldcat-fieldname = lc_material.
  lst_fieldcat-outputlen = lc_20.
  lst_fieldcat-seltext_m = text-004.
  APPEND lst_fieldcat TO i_fieldcat.
  CLEAR lst_fieldcat.

  "No. of Days
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcat-col_pos = lv_col_pos.
  lst_fieldcat-tabname = lc_output_tab.
  lst_fieldcat-fieldname = lc_nod.
  lst_fieldcat-outputlen = lc_3.
  lst_fieldcat-seltext_m = text-005.
  APPEND lst_fieldcat TO i_fieldcat.
  CLEAR lst_fieldcat.

  "Media Product
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcat-col_pos = lv_col_pos.
  lst_fieldcat-tabname = lc_output_tab.
  lst_fieldcat-fieldname = lc_medp.
  lst_fieldcat-outputlen = lc_20.
  lst_fieldcat-seltext_m = text-006.
  APPEND lst_fieldcat TO i_fieldcat.
  CLEAR lst_fieldcat.

  "Calculated Date
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcat-col_pos = lv_col_pos.
  lst_fieldcat-tabname = lc_output_tab.
  lst_fieldcat-fieldname = lc_cald.
  lst_fieldcat-outputlen = lc_3.
  lst_fieldcat-seltext_m = text-007.
  APPEND lst_fieldcat TO i_fieldcat.
  CLEAR lst_fieldcat.

  "Error Message
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcat-col_pos = lv_col_pos.
  lst_fieldcat-tabname = lc_output_tab.
  lst_fieldcat-fieldname = lc_ermsg.
  lst_fieldcat-outputlen = lc_200.
  lst_fieldcat-seltext_m = text-009.
  APPEND lst_fieldcat TO i_fieldcat.
  CLEAR lst_fieldcat.

  "Status
  lv_col_pos = lv_col_pos + 1.
  lst_fieldcat-col_pos = lv_col_pos.
  lst_fieldcat-tabname = lc_output_tab.
  lst_fieldcat-fieldname = lc_stat.
*   lst_fieldcat-outputlen = lc_3.
  lst_fieldcat-icon    = abap_true.
  lst_fieldcat-seltext_m = text-008.
  APPEND lst_fieldcat TO i_fieldcat.
  CLEAR lst_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_STDATE_ORD_GENE
*&---------------------------------------------------------------------*
*    This Perform is used for update start date for Order Generation
*----------------------------------------------------------------------*

FORM f_update_stdate_ord_gene .
  TYPES: BEGIN OF lty_mara,
           matnr           TYPE matnr,
           ismrefmdprod    TYPE ismrefmdprod,
           isminitshipdate TYPE ismerstverdat,
         END OF lty_mara.

  DATA: li_mara    TYPE STANDARD TABLE OF lty_mara,
        lst_mara   TYPE lty_mara,
        li_valmat  TYPE STANDARD TABLE OF ty_fdata,
        lst_valmat TYPE ty_fdata,
        lst_final  TYPE ty_final,
        lv_gstdt   TYPE jgen_start_date,
        lv_message TYPE string,
        lv_temp    TYPE sydatum.

  CONSTANTS:lc_redl TYPE char4 VALUE '@0A@', "Red signal
            lc_grnl TYPE char4 VALUE '@08@'. "Green signal

  li_valmat = i_valmat.
***Sorting li_valmat by matnr and delete duplicate adjacent
  SORT li_valmat BY matnr.
  DELETE ADJACENT DUPLICATES FROM li_valmat COMPARING matnr.


  IF li_valmat IS NOT INITIAL.
*** Select Data from MARA table
    SELECT matnr
           ismrefmdprod
           isminitshipdate
      INTO TABLE li_mara
      FROM mara
      FOR ALL ENTRIES IN li_valmat
      WHERE matnr = li_valmat-matnr.



    IF sy-subrc = 0.
      LOOP AT li_mara INTO lst_mara.
        lv_temp = lst_mara-isminitshipdate.
        READ TABLE li_valmat INTO lst_valmat WITH KEY
        matnr = lst_mara-matnr
        BINARY SEARCH.
        IF sy-subrc = 0.
*** Populating fields for ALV
          lst_final-matnr = lst_valmat-matnr.
          lst_final-nod   = lst_valmat-nod.
          lst_final-medp   = lst_mara-ismrefmdprod.

          lv_gstdt = lv_temp - lst_valmat-nod." Calculation of Date

          lst_final-cald = lv_gstdt.
***       Calling FM  to Update start date for Order Generation
          CALL FUNCTION 'ZQTC_EDIT_SHIPPING_PLAN'
            EXPORTING
              im_med_issue          = lst_valmat-matnr
              im_med_product        = lst_mara-ismrefmdprod
              im_gen_start_date     = lv_gstdt
            EXCEPTIONS
              exc_med_issue_missing = 1
              exc_shp_sch_missing   = 2
              exc_shp_sch_locked    = 3
              exc_miscellaneous     = 4
              OTHERS                = 5.

          IF sy-subrc <> 0.

            lst_final-status = lc_redl. " Not Valid
*** Formatting Message
            CLEAR lv_message.

            MESSAGE ID sy-msgid
            TYPE       sy-msgty
            NUMBER     sy-msgno
            INTO       lv_message
            WITH       sy-msgv1
                       sy-msgv2
                       sy-msgv3
                       sy-msgv4.

            lst_final-ermsg = lv_message.

          ELSE.

            lst_final-status = lc_grnl. " Valid

          ENDIF.
          APPEND lst_final TO i_final.
          CLEAR lst_final.
        ENDIF.

      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_LAYOUT
*&---------------------------------------------------------------------*
*    This perform is used to build layout
*----------------------------------------------------------------------*

FORM f_build_layout .

  st_layout-no_input = abap_true.
  st_layout-colwidth_optimize = abap_true.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GRID_DISPLAY
*&---------------------------------------------------------------------*
*   This perform is used for  ALV Grid Display
*----------------------------------------------------------------------*
FORM f_grid_display .

**** Calling FM to grid display
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
      is_layout          = st_layout
      it_fieldcat        = i_fieldcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
      i_default          = abap_true
      i_save             = abap_true
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = i_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
* if ALV cannot be displayed then we are displaying error message
    MESSAGE e096(zqtc_r2). " ALV cannot be displayed
  ENDIF.

ENDFORM.
