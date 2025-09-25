*&---------------------------------------------------------------------*
*&  Include           ZQTC_MOVE_FOLDER_IN_AL11_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_F4_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_f4_file_path_source.
  DATA:      l_repid       TYPE syrepid,
             l_dnum        TYPE sychar04,
             l_i_dynflds   TYPE STANDARD TABLE OF dynpread,
             l_wa_dynflds  TYPE dynpread,
             lv_serverfile TYPE esh_e_co_path.
  CONSTANTS : lc_path TYPE char6 VALUE 'P_SFILE',
              lc_1000 TYPE char4 VALUE '1000'.

  l_wa_dynflds-fieldname  = lc_path.
  APPEND l_wa_dynflds TO l_i_dynflds.
  l_repid = sy-repid.
  l_dnum = lc_1000.
  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname     = l_repid
      dynumb     = l_dnum
    TABLES
      dynpfields = l_i_dynflds
                   EXCEPTIONS
                   OTHERS.
  READ TABLE l_i_dynflds INTO l_wa_dynflds INDEX 1.
  IF sy-subrc = 0.
    gv_directory = l_wa_dynflds-fieldvalue.
  ENDIF.
*--Calling FM for F4 for AL11 Transaction with given directory
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    EXPORTING
      directory        = gv_directory
*     FILEMASK         =
    IMPORTING
      serverfile       = lv_serverfile
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  p_sfile = lv_serverfile.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MOVE_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_move_file .
* Local data declarations
  DATA: lv_message      TYPE char255,                 "Email body content
        lv_subject      TYPE so_obj_des,              "Email subject
        lv_arg          TYPE btcxpgpar,               "Parameter of external program
        lv_sfile_with_p TYPE localfile,               "Source file path with paranthesis
        lv_tfile_with_p TYPE localfile.               "Target file path with paranthesis

* Local constant declarations
  CONSTANTS: lc_opsystem TYPE syopsys VALUE 'Linux' ##NO_TEXT,  "Opeating system
             lc_open_p   TYPE char1   VALUE '(',      "Open paranthesis
             lc_close_p  TYPE char1   VALUE ')',      "Close paranthesis
             lc_stop     TYPE char1   VALUE '.'.      "Stop

  CONCATENATE p_sfile                                "Source file path
              p_tfile                                "Target directory
         INTO lv_arg SEPARATED BY space.              "Population of additional parameter

* Move the files from processing to processed directory
* We are using this unix command to move the file from one
* directory to another directory and simultaneously delete the
* file from the source folder at one shot
* from one
  IF p_user IS NOT INITIAL.
    sy-uname =  p_user.
  ENDIF.

  CALL FUNCTION 'SXPG_COMMAND_EXECUTE'   "Unix command Fm for moving file
    EXPORTING
      commandname                   = 'ZSSPMOVE'
      additional_parameters         = lv_arg
      operatingsystem               = lc_opsystem
    EXCEPTIONS
      no_permission                 = 1
      command_not_found             = 2
      parameters_too_long           = 3
      security_risk                 = 4
      wrong_check_call_interface    = 5
      program_start_error           = 6
      program_termination_error     = 7
      x_error                       = 8
      parameter_expected            = 9
      too_many_parameters           = 10
      illegal_command               = 11
      wrong_asynchronous_parameters = 12
      cant_enq_tbtco_entry          = 13
      jobcount_generation_error     = 14
      OTHERS                        = 15.

  IF sy-subrc <> 0.
    PERFORM raise_excepetion USING sy-subrc.
  ELSE.
*   Enclose the Source File path by parathesis
    CONCATENATE lc_open_p
                p_sfile
                lc_close_p
           INTO lv_sfile_with_p.    " Source file path enclosed by paranthesis
*   Enclose the Target directory path by parathesis
    CONCATENATE lc_open_p
                p_tfile
                lc_close_p
                lc_stop
           INTO lv_tfile_with_p.   "Target directory enclosed by paranthesis

    CONCATENATE 'File successfully moved to '(005)
                lv_tfile_with_p
            INTO lv_message SEPARATED BY space.
    MESSAGE s000(zqtc_r2) WITH lv_message.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_FILE_PATH_TARGET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_f4_file_path_target .
  DATA:      l_repid_t       TYPE syrepid,
             l_dnum_t        TYPE sychar04,
             l_i_dynflds_t   TYPE STANDARD TABLE OF dynpread,
             l_wa_dynflds_t  TYPE dynpread,
             lv_serverfile_t TYPE esh_e_co_path.
  CONSTANTS : lc_tpath  TYPE char6 VALUE 'P_TFILE',
              lc_1000_t TYPE char4 VALUE '1000'.

  l_wa_dynflds_t-fieldname  = lc_tpath.
  APPEND l_wa_dynflds_t TO l_i_dynflds_t.
  l_repid_t = sy-repid.
  l_dnum_t = lc_1000_t.
  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname     = l_repid_t
      dynumb     = l_dnum_t
    TABLES
      dynpfields = l_i_dynflds_t
                   EXCEPTIONS
                   OTHERS.
  READ TABLE l_i_dynflds_t INTO l_wa_dynflds_t INDEX 1.
  IF sy-subrc = 0.
    gv_directory = l_wa_dynflds_t-fieldvalue.
  ENDIF.
*--Calling FM for F4 for AL11 Transaction with given directory
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    EXPORTING
      directory        = gv_directory
*     FILEMASK         =
    IMPORTING
      serverfile       = lv_serverfile_t
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  p_tfile = lv_serverfile_t.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RAISE_EXCEPETION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_SY_SUBRC  text
*----------------------------------------------------------------------*
FORM raise_excepetion  USING    p_sy_subrc.
  CASE p_sy_subrc.
    WHEN 1.
      MESSAGE e000(zqtc_r2) WITH text-006 text-007 text-022 .
    WHEN 2.
      MESSAGE e000(zqtc_r2) WITH text-006 text-007  text-021.
    WHEN 3.
      MESSAGE e000(zqtc_r2) WITH text-006 text-007  text-020.
    WHEN 4.
      MESSAGE e000(zqtc_r2) WITH text-006 text-007  text-019.
    WHEN 5.
      MESSAGE e000(zqtc_r2) WITH text-006 text-007  text-018.
    WHEN 6.
      MESSAGE e000(zqtc_r2) WITH text-006 text-007  text-017.
    WHEN 7.
      MESSAGE e000(zqtc_r2) WITH text-006 text-007  text-016.
    WHEN 8.
      MESSAGE e000(zqtc_r2) WITH text-006 text-007  text-015.
    WHEN 9.
      MESSAGE e000(zqtc_r2) WITH text-006 text-007  text-014.
    WHEN 10.
      MESSAGE e000(zqtc_r2) WITH text-006 text-007  text-013.
    WHEN 11.
      MESSAGE e000(zqtc_r2) WITH text-006 text-007  text-012.
    WHEN 12.
      MESSAGE e000(zqtc_r2) WITH text-006 text-007  text-011.
    WHEN 13.
      MESSAGE e000(zqtc_r2) WITH text-006 text-007  text-010.
    WHEN 14.
      MESSAGE e000(zqtc_r2) WITH text-006 text-007  text-009.
    WHEN 15.
      MESSAGE e000(zqtc_r2) WITH text-006 text-008.
    WHEN OTHERS.
      MESSAGE e000(zqtc_r2) WITH text-006 text-008.
  ENDCASE.
ENDFORM.
