*&---------------------------------------------------------------------*
*& Report  REPORT ZQTC_STANDARD_TEXT_UPDATE.                           *
*& Author : Siva Guda
* REPORT DESCRIPTION:
*& AS : ALV report which displays the contents of the table T006
*& (as a docking container in the bottom) along with the
*& editable ALV which contains the ALV fieldcatalogue table structure.
*& With the available toolbar options of the editable ALV in the output,
*& user can change the fieldcatalogue as per his requirement.
*& When the user clicks 'SUBMIT',the display of the ALV with table T006
*& gets modified and customised accordingly to the user's requirement.
*&---------------------------------------------------------------------*
REPORT zqtc_standard_text_update.
TABLES: stxh.
* Output table T006 structure declaration
TYPES : BEGIN OF ty_t006.
        INCLUDE STRUCTURE t006.
TYPES : END OF ty_t006.
*Internal table and wa declaration for T006
DATA : it_t006 TYPE STANDARD TABLE OF ty_t006,
       wa_t006 TYPE ty_t006.
TYPES: BEGIN OF ty_final,
         tdobject TYPE stxh-tdobject,
         tdname   TYPE stxh-tdname,
         tdid     TYPE stxh-tdid,
         tdspras  TYPE stxh-tdspras,
         tdformat TYPE tline-tdformat,
         tdline   TYPE tline-tdline,
       END OF ty_final.
DATA: li_final TYPE TABLE OF ty_final,
      wa_final TYPE ty_final.
*declarations for ALV
DATA: ok_code          TYPE sy-ucomm,
* fieldcatalog for T006
      it_fielcat       TYPE lvc_t_fcat,
* fieldcatalog for fieldcatalog itself:
      it_fielcatalogue TYPE lvc_t_fcat,
      it_layout        TYPE lvc_s_layo.
*declaration for toolbar function
DATA:   it_excl_func        TYPE ui_functions.
* Controls to display it_t006 and corresponding fieldcatalog
DATA: cont_dock  TYPE REF TO cl_gui_docking_container,
      cont_alvgd TYPE REF TO cl_gui_alv_grid.
*controls to display the fieldcatalog as editable alv grid and container
DATA: cont_cust      TYPE REF TO cl_gui_custom_container,
      cont_editalvgd TYPE REF TO cl_gui_alv_grid.
DATA li_stxh TYPE TABLE OF stxh.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS : s_tdname FOR stxh-tdname.
SELECT-OPTIONS : p_spras FOR stxh-tdspras.
SELECTION-SCREEN END OF BLOCK b1.

*intialization event
INITIALIZATION.

AT SELECTION-SCREEN.

*start of selection event
START-OF-SELECTION.
  PERFORM f_get_data.
**************************************************************
* LOCAL CLASS Definition for data changed in fieldcatalog ALV
**************************************************************
CLASS lcl_event_receiver DEFINITION.
  PUBLIC SECTION.
    METHODS handle_data_changed
                  FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING er_data_changed.
ENDCLASS.                    "lcl_event_receiver DEFINITION
**************************************************************
* LOCAL CLASS implementation for data changed in fieldcatalog ALV
**************************************************************
CLASS lcl_event_receiver IMPLEMENTATION.
  METHOD handle_data_changed.
  ENDMETHOD.                    "handle_data_changed
ENDCLASS.                    "lcl_event_receiver IMPLEMENTATION
*data declaration for event receiver
DATA: event_receiver TYPE REF TO lcl_event_receiver.
*end of selection event
END-OF-SELECTION.
*setting the screen for alv output for table display and
*changed fieldcatalalogue display
  CALL SCREEN 600.
*On this statement double click  it takes you to the screen painter SE51.
* Enter the attributes
*Create a Custom container and name it CCONT and OK code as OK_CODE.
*Save check and Activate the screen painter.
*Now a normal screen with number 600 is created which holds the ALV grid.
* PBO of the actual screen , Here we can give a title and customized menus
*Go to SE41 and create status 'STATUS600' and create THE function code 'SUBMIT'
*and 'EXIT' with icons and icon texts
*Also create a TitleBar 'TITLE600' and give the relevant title.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0600  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0600 OUTPUT.
  SET PF-STATUS 'STATUS600'.
  SET TITLEBAR 'TITLE600'.
* CREATE ALV GRID CONTROL IF DOES NOT EXISTS INITIALLY
  IF cont_dock IS INITIAL.
    PERFORM create_alv.
  ENDIF.
ENDMODULE.                             " STATUS_0600  OUTPUT
* PAI module of the screen created. In case we use an interactive ALV or
*for additional functionalities we can create OK codes and based on the
*user command we can do the coding as shown below
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0600  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0600 INPUT.
  CASE sy-ucomm.
    WHEN 'SUBMIT'.
*      BREAK-POINT.
*TO GET THE CURRENT FIELDCATALOGUE FROM THE FRONTEND
      CALL METHOD cont_alvgd->set_frontend_fieldcatalog
        EXPORTING
          it_fieldcatalog = it_fielcat.
*refresh the alv
      CALL METHOD cont_alvgd->refresh_table_display.
*to Send Buffered Automation Queue to Frontend
      CALL METHOD cl_gui_cfw=>flush.
*Exit button clicked to leave the program
    WHEN 'EXIT' OR 'BACK'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0600  INPUT
*&---------------------------------------------------------------------*
*&      Form  CREATE_ALV
*&---------------------------------------------------------------------*
FORM create_alv.
*create a docking container and dock the control at the botton
  IF cont_dock IS INITIAL.

    CREATE OBJECT cont_dock
      EXPORTING
        dynnr = '600'.
*      extension = 100.
*      side      = cl_gui_docking_container=>dock_at_bottom.
*create the alv grid for display the table
    CREATE OBJECT cont_alvgd
      EXPORTING
        i_parent = cont_dock.
*create custome container for alv
    CREATE OBJECT cont_cust
      EXPORTING
        container_name = 'CCONT'.
*create alv editable grid
    CREATE OBJECT cont_editalvgd
      EXPORTING
        i_parent = cont_cust.
* register events for the editable alv
    CREATE OBJECT event_receiver.
    SET HANDLER event_receiver->handle_data_changed FOR cont_editalvgd.
    CALL METHOD cont_editalvgd->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.
*building the fieldcatalogue for the initial display
    PERFORM build_fieldcat CHANGING it_fielcat it_fielcatalogue.
*building the fieldcatalogue after the user has changed it
    PERFORM change_fieldcat CHANGING it_fielcat ."it_fielcatalogue.
*fetch data from the table
*  PERFORM fetch_data.
*    Get excluding functions for the alv editable tool bar
****  APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_fc_loc_cut TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_fc_sort TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_fc_sort_asc TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_fc_sort_dsc TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_fc_subtot TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_fc_sum TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_fc_graph TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_fc_info TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_fc_print TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_fc_filter TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_fc_views TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_mb_export TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_mb_sum TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_mb_sum TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_mb_paste TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_fc_find TO it_excl_func.
****  APPEND cl_gui_alv_grid=>mc_fc_loc_copy  TO it_excl_func.
*****Alv display for the T006 table at the bottom
****  CALL METHOD cont_alvgd->set_table_for_first_display
****    CHANGING
****      it_outtab       = li_final
****      it_fieldcatalog = it_fielcat[].
* optimize column width of grid displaying fieldcatalog
    it_layout-cwidth_opt = 'X'.
* Get fieldcatalog of table T006 - alv might have
* modified it after passing.
****  CALL METHOD cont_alvgd->get_frontend_fieldcatalog
****    IMPORTING
****      et_fieldcatalog = it_fielcat[].
*to Send Buffered Automation Queue to Frontend
    CALL METHOD cl_gui_cfw=>flush.
* Display fieldcatalog of table T006 in editable alv grid
    CALL METHOD cont_editalvgd->set_table_for_first_display
      EXPORTING
        is_layout            = it_layout
        it_toolbar_excluding = it_excl_func
      CHANGING
        it_outtab            = li_final "it_fielcat[]
        it_fieldcatalog      = it_fielcat[]. "it_fielcatalogue[].
  ENDIF.
ENDFORM.                               " CREATE_alv
*&---------------------------------------------------------------------*
*&      Form  fetch_data
*&---------------------------------------------------------------------*
FORM fetch_data.
* select data of T006
*  SELECT * FROM t006 INTO TABLE it_t006 UP TO 50 ROWS.
ENDFORM.                               " fetch_data
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
FORM build_fieldcat CHANGING it_fldcat TYPE lvc_t_fcat
                                   it_fcat TYPE lvc_t_fcat.

* Fieldcatalog for table T006: it_fldcat
* to generate the fields automatically
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZQTC_TEXTS'
    CHANGING
      ct_fieldcat            = it_fldcat[]
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
*----------------------------------------------------
* Fieldcatalog for table LVC_T_FCAT:it_fcat
*----------------------------------------------------
* Generate fieldcatalog of fieldcatalog structure.
* This fieldcatalog is used to display fieldcatalog 'it_fldcat'
* on the top of the screen.
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'LVC_S_FCAT'
    CHANGING
      ct_fieldcat            = it_fcat[]
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.                               " BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  CHANGE_FIELDCAT
*&---------------------------------------------------------------------*
*after the user has modified the fieldcatalogue we build another fieldcat
*for the modified alv display
FORM change_fieldcat CHANGING it_fcat TYPE lvc_t_fcat.
  DATA ls_fcat TYPE lvc_s_fcat.
  LOOP AT it_fcat INTO ls_fcat WHERE ( fieldname = 'TDFORMAT' OR fieldname = 'TDLINE' ).
    ls_fcat-coltext = ls_fcat-fieldname.
    ls_fcat-edit = 'X'.
    IF ls_fcat-fieldname = 'COL_POS' OR ls_fcat-fieldname = 'FIELDNAME'.
      ls_fcat-key = 'X'.
    ENDIF.
    MODIFY it_fcat FROM ls_fcat.
  ENDLOOP.
ENDFORM.                               " CHANGE_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data .
  DATA : st_read_text  TYPE TABLE OF tline,
         lst_read_text TYPE tline,
         lv_text       TYPE string.



  SELECT * FROM stxh
         INTO TABLE li_stxh
         WHERE tdname IN s_tdname[].
*         AND TDSPRAS EQ p_spras-low.

  LOOP AT li_stxh INTO DATA(lst_stxh).
    MOVE-CORRESPONDING lst_stxh TO wa_final.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = lst_stxh-tdid
        language                = lst_stxh-tdspras
        name                    = lst_stxh-tdname
        object                  = lst_stxh-tdobject
      TABLES
        lines                   = st_read_text
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
*    BREAK-POINT.
    IF st_read_text[] IS NOT INITIAL.
      LOOP AT st_read_text INTO DATA(lsst_read_text).
        wa_final-tdline = lsst_read_text-tdline.
        wa_final-tdformat = lsst_read_text-tdformat.
        APPEND wa_final TO li_final.
        CLEAR wa_final.
      ENDLOOP.
    ENDIF.
    CLEAR wa_final.
  ENDLOOP.
*  SORT li_final BY tdname tdspras.
*  DELETE ADJACENT DUPLICATES FROM li_final COMPARING tdname tdspras.
ENDFORM.
