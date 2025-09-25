*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_ZE225_STAGING_FORMS
* PROGRAM DESCRIPTION:Include for sub routines implementations
* DEVELOPER: GKAMMILI(Gopalakrishna K)
* CREATION DATE:   2019-12-04
* OBJECT ID:
* TRANSPORT NUMBER(S) ED2K916990
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:  ED2K924398 / ED2K927377
* REFERENCE NO: OTCM-47267
* DEVELOPER:    Nikhilesh Palla(NPALLA)
* DATE:         12/17/2021 and 05/24/2022
* DESCRIPTION:  Staging Changes - Add additional filterning by File Type
*               and capture File type in output.
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ZE225_STAGING_FORMS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data.
  IF s_zuid  IS INITIAL AND s_zoid   IS INITIAL AND
     s_zitem IS INITIAL AND s_zuser  IS INITIAL AND
     s_zbp   IS INITIAL AND s_vbeln  IS INITIAL AND
     s_zstat IS INITIAL AND s_zlogno IS INITIAL AND
     s_zdat  IS INITIAL AND s_ztim   IS INITIAL.
    MESSAGE:'Please enter at least one selection field value'(m01) TYPE 'I'.
    RETURN.
  ENDIF.

*---BOC NPALLA Staging Changes 12/17/2021  ED2K924398 E101/E225 OTCM-47267
* Get the File Types Selected in Selection Screen.
  PERFORM f_get_file_types.
*---EOC NPALLA Staging Changes 12/17/2021  ED2K924398 E101/E225 OTCM-47267

  REFRESH: i_staging.
  SELECT   *
           FROM ze225_staging
           INTO TABLE i_staging
           WHERE zuid_upld IN s_zuid
           AND   zoid      IN s_zoid
           AND   zitem     IN s_zitem
           AND   zuser     IN s_zuser
           AND   zbp       IN s_zbp
           AND   vbeln     IN s_vbeln
           AND   zprcstat  IN s_zstat
           AND   zlogno    IN s_zlogno
           AND   zcrtdat   IN s_zdat
           AND   zcrttim   IN s_ztim     "Selecting all fields for table ze225_staging
*---BOC NPALLA Staging Changes 12/17/2021  ED2K924398 E101/E225 OTCM-47267
           AND   zintf_stage_id IN ir_stage_id.
*---EOC NPALLA Staging Changes 12/17/2021  ED2K924398 E101/E225 OTCM-47267
  IF sy-subrc NE 0.
    MESSAGE:'No Data selected'(m02) TYPE 'I'.
    RETURN.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_process_data .
*-- Local structures declarations
  FIELD-SYMBOLS:<fs_staging> TYPE ze225_staging.        "Structure for ze225_staging
*-- Local Constants
  CONSTANTS:lc_p  TYPE symsgty  VALUE 'P',     "In process status
            lc_s  TYPE symsgty  VALUE 'S',     "Sucess
            lc_e  TYPE symsgty  VALUE 'E',     "Error
            lc_d  TYPE symsgty  VALUE 'D',     " Not picked
            lc_e1 TYPE zprcstat VALUE 'E1',    "BP Error
            lc_e2 TYPE zprcstat VALUE 'E2',    "Order Error
*---BOC NPALLA Staging Changes 05/24/2022 ED2K927377 E101/E225 OTCM-47267
            lc_f1 TYPE zprcstat VALUE 'F1',    "File Validation Error
*---EOC NPALLA Staging Changes 05/24/2022 ED2K927377 E101/E225 OTCM-47267
            lc_d1 TYPE zprcstat VALUE 'D1'.    "Completed
  REFRESH i_final.
  LOOP AT i_staging ASSIGNING <fs_staging>."INTO <fs_staging>.
    st_final-zuid_upld  = <fs_staging>-zuid_upld.
    st_final-zoid       = <fs_staging>-zoid.
    st_final-zitem      = <fs_staging>-zitem.
    st_final-zuser      = <fs_staging>-zuser.
    st_final-zfilepath  = <fs_staging>-zfilepath.
    st_final-zbp        = <fs_staging>-zbp.
    st_final-vbeln      = <fs_staging>-vbeln.
    st_final-zprcstat   = <fs_staging>-zprcstat.
    st_final-zlogno     = <fs_staging>-zlogno.
    PERFORM f_conversion_output CHANGING st_final-zlogno.
    st_final-zcrtdat    = <fs_staging>-zcrtdat.
    st_final-zcrttim    = <fs_staging>-zcrttim.
*---BOC NPALLA Staging Changes 12/17/2021 ED2K924398 E101/E225 OTCM-47267
    st_final-zintf_stage_id  = <fs_staging>-zintf_stage_id.
    PERFORM f_get_stage_id_desc USING st_final-zintf_stage_id
                                CHANGING st_final-stage_id_desc.
*---EOC NPALLA Staging Changes 12/17/2021 ED2K924398 E101/E225 OTCM-47267
    IF st_final-zprcstat = space.
      PERFORM f_get_msg_icon USING lc_d
                             CHANGING st_final-log_type_desc.
    ELSEIF st_final-zprcstat = lc_e1 OR st_final-zprcstat = lc_e2.
      PERFORM f_get_msg_icon USING lc_e
                             CHANGING st_final-log_type_desc.
*---BOC NPALLA Staging Changes 05/24/2022 ED2K927377 E101/E225 OTCM-47267
    ELSEIF st_final-zprcstat = lc_f1.
      PERFORM f_get_msg_icon USING lc_e
                             CHANGING st_final-log_type_desc.
*---EOC NPALLA Staging Changes 05/24/2022 ED2K927377 E101/E225 OTCM-47267
    ELSEIF st_final-zprcstat = lc_d1.
      PERFORM f_get_msg_icon USING lc_s
                             CHANGING st_final-log_type_desc.
    ELSE.
      PERFORM f_get_msg_icon USING lc_p
                             CHANGING st_final-log_type_desc.
    ENDIF.
    APPEND st_final TO i_final.
    CLEAR st_final.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_MSG_ICON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_get_msg_icon  USING    fp_msg_msgty     TYPE symsgty         " Message Type
                     CHANGING fp_msg_stat_desc TYPE zmsg_icon_desc. " Message Icon and Description

  DATA : lv_icon_fld TYPE icon_d, "Icon
         lv_msg_type TYPE char11. "Message type

  CLEAR: fp_msg_stat_desc.

  CASE fp_msg_msgty.
    WHEN 'A'.
      lv_icon_fld = '@8N@'(i01).
      lv_msg_type = 'Abort'(l01).
    WHEN 'E'.
      lv_icon_fld = '@5C@'(i02). "Red/Error
      lv_msg_type = 'Error'(l02).
    WHEN 'W'.
      lv_icon_fld = '@5D@'(i03). "Yellow/Warning
      lv_msg_type = 'Warning'(l03).
    WHEN 'S'.
      lv_icon_fld = '@5B@'(i04). "Green/Success
      lv_msg_type = 'Success'(l04).
    WHEN 'I'.
      lv_icon_fld = '@5B@'(i04). "Green/Success
      lv_msg_type = 'Information'(l05).
    WHEN 'D'.
      lv_icon_fld = '@00@'(i05). "Gray(Dummy)/Not Picked
      lv_msg_type = 'Not Picked'(l06).
    WHEN 'P'.
      lv_icon_fld = '@5D@'(i03).      "Yellow/In Process
      lv_msg_type = 'In Process'(l07).
    WHEN OTHERS.
  ENDCASE.

  CONCATENATE lv_icon_fld lv_msg_type INTO fp_msg_stat_desc SEPARATED BY space.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_data .
*-- Local Structures
  DATA: lst_layout   TYPE slis_layout_alv.         "Fieldcatalog structure
*-- Loca Constants
  CONSTANTS:lc_pf_status TYPE slis_formname  VALUE 'F_SET_PF_STATUS',    "PF status routine
            lc_user_comm TYPE slis_formname  VALUE 'F_USER_COMMAND'.     "User command routine
*-- Creating the fieldcatalog
  PERFORM f_prepare_fcat.
*-- Preparing the layout
  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.
*-- Displaying the data in ALV format
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid      "program name
      i_callback_pf_status_set = lc_pf_status  "PF status routine
      i_callback_user_command  = lc_user_comm  "User command routine
      is_layout                = lst_layout    "Layout
      it_fieldcat              = i_fcat        "fieldcatalog
      i_save                   = abap_true     "Varioant save
    TABLES
      t_outtab                 = i_final       "Final Table
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.     " ALV display of table failed
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2).
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PREPARE_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_prepare_fcat .


  CLEAR v_col_pos.
  PERFORM f_fcat_build USING 'ZUID_UPLD'(f01)     'I_FINAL'(t01) 'Identifier'(s01)
                       CHANGING i_fcat.
  PERFORM f_fcat_build USING 'ZOID'(f02)          'I_FINAL'(t01) 'Order'(s02)
                       CHANGING i_fcat.
  PERFORM f_fcat_build USING 'ZITEM'(f03)         'I_FINAL'(t01) 'Item'(s03)
                       CHANGING i_fcat.
  PERFORM f_fcat_build USING 'ZUSER'(f04)         'I_FINAL'(t01) 'User Name'(s04)
                       CHANGING i_fcat.
*---BOC NPALLA Staging Changes 12/17/2021 ED2K924398 E101/E225 OTCM-47267
*  PERFORM f_fcat_build USING 'ZFILEPATH'(f05)     'I_FINAL'(t01) 'File name'(s05)
*                       CHANGING i_fcat.
*---EOC NPALLA Staging Changes 12/17/2021 ED2K924398 E101/E225 OTCM-47267
  PERFORM f_fcat_build USING 'ZBP'(f06)           'I_FINAL'(t01) 'Business Partner'(s06)
                       CHANGING i_fcat.
  PERFORM f_fcat_build USING 'VBELN'(f07)         'I_FINAL'(t01) 'Sales Document'(s07)
                       CHANGING i_fcat.
  PERFORM f_fcat_build USING 'ZPRCSTAT'(f08)      'I_FINAL'(t01) 'Status'(s08)
                       CHANGING i_fcat.
  PERFORM f_fcat_build USING 'LOG_TYPE_DESC'(f12) 'I_FINAL'(t01) 'Log Type Desc'(s12)
                       CHANGING i_fcat.
  PERFORM f_fcat_build USING 'ZLOGNO'(f09)        'I_FINAL'(t01) 'Log number'(s09)
                       CHANGING i_fcat.
  PERFORM f_fcat_build USING 'ZCRTDAT'(f10)       'I_FINAL'(t01) 'Created on'(s10)
                       CHANGING i_fcat.
  PERFORM f_fcat_build USING 'ZCRTTIM'(f11)       'I_FINAL'(t01) 'Created Time'(s11)
                       CHANGING i_fcat.
*---BOC NPALLA Staging Changes 12/17/2021 ED2K924398 E101/E225 OTCM-47267
*  PERFORM f_fcat_build USING 'ZINTF_STAGE_ID'(f13) 'I_FINAL'(t01) 'Interface Staging ID'(s13)
*                       CHANGING i_fcat.
  PERFORM f_fcat_build USING 'STAGE_ID_DESC'(f14) 'I_FINAL'(t01) 'Staging ID Desc'(s14)
                       CHANGING i_fcat.
  PERFORM f_fcat_build USING 'ZFILEPATH'(f05)     'I_FINAL'(t01) 'File name'(s05)
                       CHANGING i_fcat.
*---EOC NPALLA Staging Changes 12/17/2021 ED2K924398 E101/E225 OTCM-47267
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FCAT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->fp_field   text
*      -->fp_field   text
*      -->fp_text   text
*      <--fp_i_fcat  text
*----------------------------------------------------------------------*
FORM f_fcat_build  USING    fp_field    TYPE slis_fieldname
                            fp_tabname  TYPE slis_tabname
                            fp_text     TYPE char50
                   CHANGING fp_i_fcat   TYPE slis_t_fieldcat_alv.
*-- Local structures declarations
  DATA:lst_fcat TYPE slis_fieldcat_alv.                      "Fieldcatalog structure
  CONSTANTS:lc_zlogno TYPE slis_fieldname VALUE 'ZLOGNO',    "log number
            lc_zprcstat TYPE slis_fieldname VALUE 'ZPRCSTAT'. "Processing Status

  v_col_pos              = v_col_pos + 1.
  lst_fcat-col_pos       = v_col_pos.
  lst_fcat-fieldname     = fp_field.
  lst_fcat-tabname       = fp_tabname.
  lst_fcat-seltext_l     = fp_text.
  IF lst_fcat-fieldname  = lc_zlogno.
    lst_fcat-hotspot     = abap_true.
  ELSEIF lst_fcat-fieldname  = lc_zprcstat.
    lst_fcat-ref_fieldname = 'ZPRCSTAT'(f08).
    lst_fcat-ref_tabname   = 'ZE225_STAGING'(t02).
  ENDIF.
*---BOC NPALLA Staging Changes 12/17/2021 ED2K924398 E101/E225 OTCM-47267
  IF lst_fcat-fieldname = 'ZUID_UPLD'(f01) OR
     lst_fcat-fieldname = 'ZOID'(f02)      OR
     lst_fcat-fieldname = 'ZITEM'(f03).
    lst_fcat-key = abap_true.
  ENDIF.
*---EOC NPALLA Staging Changes 12/17/2021 ED2K924398 E101/E225 OTCM-47267

  APPEND lst_fcat TO fp_i_fcat.
  CLEAR: lst_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form F_USER_COMMAND
*&---------------------------------------------------------------------*
*      USING fp_ucomm          " ABAP System Field: PAI-Triggering Function Code
*            fp_lst_selfield   .
*----------------------------------------------------------------------*
FORM f_user_command USING fp_ucomm TYPE syst_ucomm            " ABAP System Field: PAI-Triggering Function Code
                          fp_lst_selfield TYPE slis_selfield. "#EC CALLED
  CONSTANTS:lc_hotspot TYPE syst_ucomm     VALUE '&IC1',      "Hotspot function code
            lc_refresh TYPE syst_ucomm     VALUE '&REF',      "Refresh Function code
            lc_x       TYPE char1          VALUE 'X'.         "Flag
  CASE fp_ucomm.
    WHEN  lc_hotspot.
      PERFORM f_process_hotspot USING fp_lst_selfield.
    WHEN lc_refresh.
      PERFORM f_get_data.
      PERFORM f_process_data.
      fp_lst_selfield-refresh    = lc_x.
      fp_lst_selfield-col_stable = lc_x.
      fp_lst_selfield-row_stable = lc_x.

  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_HOTSPOT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_LST_SELFIELD TYPE slis_selfield
*----------------------------------------------------------------------*
FORM f_process_hotspot  USING fp_lst_selfield TYPE slis_selfield.
  TYPES: BEGIN OF lty_msg,
           msg_stat TYPE zmsg_icon_desc, " Message Icon and Description
           text     TYPE char200,        " Text of type CHAR200
         END OF lty_msg.

  DATA: li_log_handle     TYPE bal_t_logh,               " Application Log: Log Handle Table
        lst_msg           TYPE bal_s_msg,                " Application Log: Message Data
        lv_msg_log_handle TYPE balmsghndl,               " Application Log: Message handle
        lv_flg_exit       TYPE xchar,                    " Exit Flag
        li_msg_out        TYPE STANDARD TABLE OF lty_msg, "internal table for log details
        lst_msg_out       TYPE lty_msg,                   "structure for log details
        lv_lognumber      TYPE balognr,                  "Log number
        lv_log_handle     TYPE balloghndl.               "Log Handler

  FIELD-SYMBOLS:<fs_final>  TYPE ty_final.               " Final internal table structure
  CONSTANTS:lc_logno        TYPE slis_selfield-fieldname VALUE 'ZLOGNO'.    "Log number

  IF fp_lst_selfield-fieldname = lc_logno."'ZLOGNO'.


    READ TABLE i_final ASSIGNING <fs_final> INDEX fp_lst_selfield-tabindex.
    IF sy-subrc = 0.
      lv_lognumber = <fs_final>-zlogno.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_lognumber
        IMPORTING
          output = lv_lognumber.                  "Conversion for internal format

    ENDIF. " IF sy-subrc = 0

* Get Log Handle.
    SELECT SINGLE log_handle " Application Log: Log Handle
      FROM balhdr            " Application log: Header table
      INTO lv_log_handle
      WHERE lognumber = lv_lognumber.   "Selecting log handler
    IF sy-subrc <> 0.
      MESSAGE i000(zqtc_r2) WITH 'Select a Valid Log Number'(m03)."'Select a Valid Log Number'. " & & & &
      RETURN.
    ELSE.
      CLEAR lv_lognumber.
    ENDIF. " IF sy-subrc <> 0

* Application Log: Database: Load Logs
    APPEND lv_log_handle TO li_log_handle.

    CALL FUNCTION 'BAL_DB_LOAD'
      EXPORTING
        i_t_log_handle     = li_log_handle
      EXCEPTIONS
        no_logs_specified  = 1
        log_not_found      = 2
        log_already_loaded = 3
        OTHERS             = 4.           "Load application log
    IF sy-subrc <> 0.
      MESSAGE i000(zqtc_r2) WITH 'Enter a Valid Log Handle'(m04)."'Enter a Valid Log Handle'. " & & & &
      RETURN.
    ELSE.
      CLEAR li_log_handle[].
    ENDIF. " IF sy-subrc <> 0

* Get All the Log Messages for the given Log Handle.
    WHILE lv_flg_exit IS INITIAL.

      lv_msg_log_handle-log_handle = lv_log_handle.
      lv_msg_log_handle-msgnumber  = lv_msg_log_handle-msgnumber + 1 .

      CALL FUNCTION 'BAL_LOG_MSG_READ'
        EXPORTING
          i_s_msg_handle = lv_msg_log_handle
        IMPORTING
          e_s_msg        = lst_msg
        EXCEPTIONS
          log_not_found  = 1
          msg_not_found  = 2
          OTHERS         = 3.            "Reading application log message
      IF sy-subrc <> 0.
        lv_flg_exit = abap_true.
      ENDIF. " IF sy-subrc <> 0

      IF lv_flg_exit IS INITIAL.
        MESSAGE ID lst_msg-msgid TYPE lst_msg-msgty NUMBER lst_msg-msgno
                INTO DATA(lv_msg_text)
                WITH lst_msg-msgv1 lst_msg-msgv2 lst_msg-msgv3 lst_msg-msgv4.
        PERFORM f_get_msg_icon USING lst_msg-msgty
                               CHANGING lst_msg_out-msg_stat.
        IF lst_msg-msgv1 CS 'Comment By:'(004)."lc_comment_by.
          CONCATENATE lst_msg-msgv1 lst_msg-msgv2 lst_msg-msgv3 lst_msg-msgv4
                      INTO lv_msg_text.
        ENDIF.
        lst_msg_out-text = lv_msg_text.
        APPEND lst_msg_out TO li_msg_out.
        CLEAR: lst_msg_out,
               lst_msg,
               lv_msg_text.
      ENDIF. " IF lv_flg_exit IS INITIAL

    ENDWHILE.
    CLEAR lv_log_handle.

    PERFORM f_popup_log_window USING li_msg_out.
  ENDIF.
ENDFORM.
FORM f_popup_log_window  USING    fp_i_msg TYPE STANDARD TABLE.

  DATA: lo_alv TYPE REF TO cl_salv_table, " Basis Class for Simple Tables
        lo_msg TYPE REF TO cx_salv_msg.   "General Error Class with Message
  DATA: lo_functions TYPE REF TO cl_salv_functions_list. " Generic and User-Defined Functions in List-Type Tables
  DATA: lv_msg          TYPE string. "Message variable

  CONSTANTS:lc_start_column TYPE i VALUE 1,   " Start_column of type Integers
            lc_end_column   TYPE i VALUE 100, " End_column of type Integers
            lc_start_line   TYPE i VALUE 1,   " Start_line of type Integers
            lc_end_line     TYPE i VALUE 20.  " End_line of type Integers

  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = fp_i_msg[] ).
    CATCH cx_salv_msg INTO lo_msg.
      lv_msg = lo_msg->get_text( ).
      MESSAGE lv_msg TYPE 'I'.
  ENDTRY.

  lo_functions = lo_alv->get_functions( ).
  lo_functions->set_all( 'X' ).


  IF lo_alv IS BOUND.
    lo_alv->set_screen_popup(
      start_column = lc_start_column
      end_column   = lc_end_column
      start_line   = lc_start_line
      end_line     = lc_end_line ).
*   Display ALV
    lo_alv->display( ).
  ENDIF. " IF lo_alv IS BOUND

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_set_pf_status
*&---------------------------------------------------------------------*
*       Set the PF Status for ALV
*----------------------------------------------------------------------*
FORM f_set_pf_status USING fp_li_extab TYPE slis_t_extab.   "#EC CALLED
*  CONSTANTS:lc_refresh TYPE syst_ucomm VALUE '&REFRESH'.
**  DELETE li_extab WHERE fcode = lc_refresh.
  SET PF-STATUS 'ZSTANDARD' EXCLUDING fp_li_extab.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CONVERSION_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--fP_ST_FINAL_ZLOGNO  text
*----------------------------------------------------------------------*
FORM f_conversion_output  CHANGING fp_st_final_zlogno TYPE balognr.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = fp_st_final_zlogno
    IMPORTING
      output = fp_st_final_zlogno.               "Conversion for external number

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_POSSIBLE_VALUES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_S_ZSTAT  text
*----------------------------------------------------------------------*
FORM f_get_possible_values  USING  fp_s_zstat TYPE zprcstat.
  TYPES:BEGIN OF lty_value,
          domvalue_l     TYPE zprcstat,               "Domain Value
          ddtext         TYPE dd07t-ddtext,           "Value Text
        END OF lty_value.
  DATA:li_value          TYPE TABLE OF lty_value,
       li_return         TYPE TABLE OF ddshretval,
       lst_retun         TYPE ddshretval.
  CONSTANTS:lc_domname   TYPE dd07l-domname       VALUE 'ZPRCSTAT',
            lc_retfield  TYPE dfies-fieldname     VALUE 'DOMVALUE_L',
            lc_value_org TYPE ddbool_d            VALUE 'S'.
*-- Getting domain values from view dd07v
  SELECT domvalue_l ddtext FROM dd07v
                       INTO TABLE li_value
                       WHERE domname = lc_domname.
  IF sy-subrc = 0.
    SORT li_value BY domvalue_l.
  ENDIF.
*-- Calling function module for proving F4 help
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = lc_retfield
      dynpprog        = sy-repid
      window_title    = 'Processing status'(005)
      value_org       = lc_value_org
    TABLES
      value_tab       = li_value
      return_tab      = li_return[]
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc = 0.
*-- passing selected value to selecton screen field
    READ TABLE li_return INTO lst_retun INDEX 1.
    IF sy-subrc = 0.
      fp_s_zstat = lst_retun-fieldval.
    ENDIF.
  ENDIF.
ENDFORM.
*---BOC NPALLA Staging Changes 12/17/2021 ED2K924398 E101/E225 OTCM-47267
*&---------------------------------------------------------------------*
*&      Form  GET_FILE_TYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_get_file_types.

  CONSTANTS: lc_stage_id_dom TYPE dd07l-domname VALUE 'ZINTF_STAGE_ID'.

* Get Descriptions from Domain
  CALL FUNCTION 'DD_DOMVALUES_GET'
    EXPORTING
      domname              = lc_stage_id_dom
      text                 = abap_true
      langu                = sy-langu
*     bypass_buffer        = ' '
*   IMPORTING
*     rc                   =
    TABLES
      dd07v_tab            = i_stage_id_des
    EXCEPTIONS
      wrong_textflag       = 1
      others               = 2.
  IF sy-subrc = 0.
    SORT i_stage_id_des BY domvalue_l.
  ELSE. " IF sy-subrc = 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

* Check Boxes of E225
    IF rb_e225 IS NOT INITIAL.  "for Entries before E101/E225 OTCM-47267 Changes
      PERFORM f_update_file_type USING '  '.
    ENDIF.
    IF p_1a IS NOT INITIAL.
      PERFORM f_update_file_type USING '1A'.
    ENDIF.
    IF p_1b IS NOT INITIAL.
      PERFORM f_update_file_type USING '1B'.
    ENDIF.
    IF p_1c IS NOT INITIAL.
      PERFORM f_update_file_type USING '1C'.
    ENDIF.

* Check Boxes of E101
    IF p_2a IS NOT INITIAL.
      PERFORM f_update_file_type USING '2A'.
    ENDIF.
    IF p_2b IS NOT INITIAL.
      PERFORM f_update_file_type USING '2B'.
    ENDIF.
    IF p_2c IS NOT INITIAL.
      PERFORM f_update_file_type USING '2C'.
    ENDIF.
*---BOC NPALLA Staging Changes 05/24/2022 ED2K927377 E101/E225 OTCM-47267
*    IF p_2d IS NOT INITIAL.
*      PERFORM f_update_file_type USING '2D'.
*    ENDIF.
*    IF p_2e IS NOT INITIAL.
*      PERFORM f_update_file_type USING '2E'.
*    ENDIF.
*    IF p_2f IS NOT INITIAL.
*      PERFORM f_update_file_type USING '2F'.
*    ENDIF.
*---EOC NPALLA Staging Changes 05/24/2022 ED2K927377 E101/E225 OTCM-47267
    IF p_2g IS NOT INITIAL.
      PERFORM f_update_file_type USING '2G'.
    ENDIF.
    IF p_2h IS NOT INITIAL.
      PERFORM f_update_file_type USING '2H'.
    ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_FILE_TYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_update_file_type  USING    fp_file_type TYPE ze225_staging-zintf_stage_id.

  DATA: lst_stage_id TYPE ty_stage_id.
  CONSTANTS: lc_i(1)    TYPE c     VALUE 'I',   "Include
             lc_eq(2)   TYPE c     VALUE 'EQ'.  "Equal To

  lst_stage_id-sign   = lc_i.
  lst_stage_id-option = lc_eq.
  lst_stage_id-low    = fp_file_type.
  CLEAR lst_stage_id-high.
  APPEND lst_stage_id TO ir_stage_id.
  CLEAR lst_stage_id.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_STAGE_ID_DESC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_get_stage_id_desc  USING    fp_zintf_stage_id
                          CHANGING fp_zintf_stage_id_desc.

  READ TABLE i_stage_id_des INTO st_stage_id_des
                            WITH KEY domvalue_l = fp_zintf_stage_id
                            BINARY SEARCH.
  IF sy-subrc = 0.
    fp_zintf_stage_id_desc = st_stage_id_des-ddtext.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_FILE_OPTIONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_validate_file_options .

* When user selects anything other than radio button.
  CHECK sy-ucomm NE 'FTYPE'.

  IF rb_e225 IS NOT INITIAL.
    IF p_1a IS INITIAL AND
       p_1b IS INITIAL AND
       p_1c IS INITIAL.
      MESSAGE e000(zqtc_r2) WITH 'Select atlease one Option in '(009) 'Combined Upload'(010).
    ENDIF.
  ENDIF.

  IF rb_e101 IS NOT INITIAL.
    IF p_2a IS INITIAL AND
       p_2b IS INITIAL AND
       p_2c IS INITIAL AND
*---BOC NPALLA Staging Changes 05/24/2022 ED2K927377 E101/E225 OTCM-47267
*       p_2d IS INITIAL AND
*       p_2e IS INITIAL AND
*       p_2f IS INITIAL AND
*---EOC NPALLA Staging Changes 05/24/2022 ED2K927377 E101/E225 OTCM-47267
       p_2g IS INITIAL AND
       p_2h IS INITIAL.
      MESSAGE e000(zqtc_r2) WITH 'Select atlease one Option in '(009) 'Orders Only Upload'(011).
    ENDIF.
  ENDIF.

  IF s_zuid[]   IS INITIAL AND  "Unique Identifier
     s_zbp[]    IS INITIAL AND  "Business Partner Number
     s_vbeln[]  IS INITIAL AND  "Sales Document
     s_zlogno[] IS INITIAL AND  "Log Number
     s_zdat[]   IS INITIAL.     "Created Date
    PERFORM f_validate_mandatory_feilds.
    MESSAGE e000(zqtc_r2) WITH 'Please fill the details in atleast '(012)
                               'one of the above fields'(013).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SCREEN_DYNAMICS_01
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_screen_dynamics_01 .
  IF rb_e225 EQ abap_true.
    LOOP AT SCREEN.
      IF screen-group1 = 'M2'.
        screen-input = screen-active = screen-output = '1'.
      ENDIF. " IF screen-group1 = c_m3
      IF screen-group1 = 'M3'.
        screen-input = screen-active = screen-output = '0'.
      ENDIF. " IF screen-group1 = c_m9
      MODIFY SCREEN.
    ENDLOOP.
  ELSEIF rb_e101 EQ abap_true.
    LOOP AT SCREEN.
      IF screen-group1 = 'M3'.
        screen-input = screen-active = screen-output = '1'.
      ENDIF. " IF screen-group1 = c_m3
      IF screen-group1 = 'M2'.
        screen-input = screen-active = screen-output = '0'.
      ENDIF. " IF screen-group1 = c_m3
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.
ENDFORM.
*---EOC NPALLA Staging Changes 12/17/2021 ED2K924398 E101/E225 OTCM-47267
*---BOC NPALLA Staging Changes 05/24/2022 ED2K927377 E101/E225 OTCM-47267
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MANDATORY_FEILDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_validate_mandatory_feilds .

  STATICS: lsv_index TYPE i.

* Skip the first time.
  lsv_index = lsv_index + 1.
  CHECK lsv_index GT 1.

  IF s_zuid[]   IS INITIAL AND  "Unique Identifier
     s_zbp[]    IS INITIAL AND  "Business Partner Number
     s_vbeln[]  IS INITIAL AND  "Sales Document
     s_zlogno[] IS INITIAL AND  "Log Number
     s_zdat[]   IS INITIAL.     "Created Date
    LOOP AT SCREEN.
      IF ( screen-group1 = 'S1'  OR
           screen-group1 = 'M1'  OR
           screen-group1 = 'M2'  OR
           screen-group1 = 'M3'  OR
           screen-group1 = 'M4'  ).
        screen-input = '1'.
      ELSE.
        screen-input = '0'.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ELSE.
    LOOP AT SCREEN.
      screen-input = '1'.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.

ENDFORM.
*---EOC NPALLA Staging Changes 05/24/2022 ED2K927377 E101/E225 OTCM-47267
