*----------------------------------------------------------------------*
* PROGRAM NAME: ZCAR_DOWNLD_AL11_TO_LOCAL_F04(ZCAR_DOWNLOAD_AL11_FILE)
* PROGRAM DESCRIPTION: Download Media Issue Cockpit Report
* DEVELOPER:           TDIMANTHA
* CREATION DATE:       31/03/2022
* OBJECT ID:           R115
* TRANSPORT NUMBER(S): ED2K918057
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SET_TITLE_MI_CP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_set_title_mi_cp .
  sy-title = 'Download Media Issue Cockpit report files'(024).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_MICP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_f4_micp .

  CONSTANTS : lc_name         TYPE fieldname  VALUE 'NAME',       " Field name
              lc_logical_path TYPE rvari_vnam VALUE 'LOGICAL_PATH', " Param1 value
              lc_fname        TYPE localfile  VALUE 'dummy'.         " Local file for upload/download
  DATA : lv_dir_path TYPE eps2filnam,                           " To store directory path
         lt_tab      TYPE TABLE OF eps2fili.                    " To store list of file names

  TYPES : BEGIN OF lty_value,                                   " Structure for F4 help file names
            name  TYPE tpm_source_name,
            owner TYPE epsfilown,
            mtim  TYPE eps2timestmp,
            size  TYPE eps2filsiz,
          END OF lty_value.
  DATA : lt_value_tab  TYPE TABLE OF lty_value,                 " To store list of file names
         lst_value     TYPE lty_value,
         lt_return_tab TYPE TABLE OF ddshretval,                " Selected file name
         lst_return    TYPE ddshretval,
         lv_path       TYPE pathintern,
         lv_path_fname TYPE string.

  CLEAR : lv_path, lv_path_fname, lv_dir_path.
* Select logical path from constant table
  SELECT SINGLE devid, param1, param2, srno, low
    FROM zcaconstant
    INTO @DATA(lv_dir_fpath)
    WHERE devid EQ @c_r115
      AND param1 EQ @lc_logical_path
      AND activate EQ @c_x.
  IF sy-subrc = 0.
    lv_path = lv_dir_fpath-low.
  ENDIF.

  " Read file path from transaction FILE
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = lv_path
      operating_system           = sy-opsys
      file_name                  = lc_fname
      eleminate_blanks           = c_x
    IMPORTING
      file_name_with_path        = lv_path_fname
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE s001 DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSE.
    REPLACE ALL OCCURRENCES OF lc_fname IN lv_path_fname WITH ''.
    CONDENSE lv_path_fname NO-GAPS.
    lv_dir_path = lv_path_fname.
  ENDIF.

  CALL FUNCTION 'ZQTCCA_EPS2_GET_DIRECTORY_LIST' " Read list of file names from the directory path
    EXPORTING
      iv_dir_name            = lv_dir_path
    TABLES
      dir_list               = lt_tab
    EXCEPTIONS
      invalid_eps_subdir     = 1
      sapgparam_failed       = 2
      build_directory_failed = 3
      no_authorization       = 4
      read_directory_failed  = 5
      too_many_read_errors   = 6
      empty_directory_list   = 7
      OTHERS                 = 8.
  IF sy-subrc EQ 0.
    CLEAR : lst_value, lst_return.
    REFRESH : lt_value_tab, lt_return_tab.
    LOOP AT lt_tab INTO DATA(lst_tab).                 " Move file names to F4 help internal table
      lst_value-name  = lst_tab-name.
      lst_value-owner = lst_tab-owner.
      lst_value-mtim  = lst_tab-mtim.
      lst_value-size  = lst_tab-size.
      APPEND lst_value TO lt_value_tab.
      CLEAR : lst_value, lst_tab.
    ENDLOOP.
    SORT lt_value_tab BY mtim DESCENDING.
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'      " Display list of file names in F4 help
      EXPORTING
        retfield        = lc_name
        value_org       = 'S'
      TABLES
        value_tab       = lt_value_tab
        return_tab      = lt_return_tab
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
    IF sy-subrc = 0.
      CLEAR v_filename.
      READ TABLE lt_return_tab INTO lst_return INDEX 1.
      v_filename = lst_return-fieldval+0(60).
      CONCATENATE lv_dir_path '/' lst_return-fieldval+0(60)  " display the selected file name from F4 help
             INTO p_as_fn.
    ELSE.
      CASE sy-subrc.
        WHEN 1.
          MESSAGE 'Parameter Error'(004) TYPE c_i.
        WHEN 2.
          MESSAGE 'No Values found'(005) TYPE c_i.
        WHEN 3.
          MESSAGE 'Unknown error for Directory path'(003) TYPE c_i.
      ENDCASE.
    ENDIF.
  ELSE.
    CASE sy-subrc.
      WHEN 1.
        MESSAGE 'Invalid subdirectory'(006) TYPE c_i.
      WHEN 2.
        MESSAGE 'EPS_GET_DIRECTORY_LISTING failed'(007) TYPE c_i.
      WHEN 3.
        MESSAGE 'Build directory failed'(008) TYPE c_i.
      WHEN 4.
        MESSAGE 'No authorization'(009) TYPE c_i.
      WHEN 5.
        MESSAGE 'Read directory failed'(010) TYPE c_i.
      WHEN 6.
        MESSAGE 'Too many read error'(011) TYPE c_i.
      WHEN 7.
        MESSAGE 'Empty directory'(012) TYPE c_i.
      WHEN 8.
        MESSAGE 'Unknown error for Directory path'(003) TYPE c_i.
    ENDCASE.
  ENDIF.
ENDFORM.
