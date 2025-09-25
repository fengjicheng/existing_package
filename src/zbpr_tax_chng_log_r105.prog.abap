*&---------------------------------------------------------------------*
*& Report  ZBPR_TAX_CHNG_LOG_R105
*&
*&---------------------------------------------------------------------*
*& REVISION NO:   ED2K917863
*& REFERENCE NO:  R105
*& DEVELOPER:     Mohammed Aslam (AMOHAMMED)
*& DATE:          2020-30-03
*& DESCRIPTION:   Generate a report to cpature manual changes to the tax
*                 classification type on BP and sending this report to
*                 a distribution list
*&---------------------------------------------------------------------*
*& REVISION NO:   ED2K918403
*& REFERENCE NO:  INC0296719_R105
*& DEVELOPER:     Mohammed Aslam (AMOHAMMED)
*& DATE:          2020-80-06
*& DESCRIPTION:   1. Changed message type from error to information
*                 2. Changed message from "No record found" to "No records found"
*&---------------------------------------------------------------------*
REPORT zbpr_tax_chng_log_r105 MESSAGE-ID so.
*----------------------------INCLUDES USED-----------------------------*
*
* INCLUDE ZBPN_TAX_CHNG_LOG_R105_TOP             " Declarations
*
*----------------------------------------------------------------------*
INCLUDE zbpn_tax_chng_log_r105_top.
*
* INCLUDE ZBPN_TAX_CHNG_LOG_R105_SCR             " Selection Screen
*
*----------------------------------------------------------------------*
INCLUDE zbpn_tax_chng_log_r105_scr.

*------------------------------INITIALIZATION--------------------------*
INITIALIZATION.
  so_utim-sign = 'I'.
  so_utim-option = 'BT'.
  so_utim-low = '00'.
  so_utim-high = '24'.
  APPEND so_utim.                            " Default time

*---------------------------AT SELECTION-SCREEN------------------------*
AT SELECTION-SCREEN.
* Fetch tax classification change log details
  SELECT objectclas, objectid, changenr, username, udate, utime
    FROM cdhdr
    INTO TABLE @t_cdhdr
    WHERE objectclas EQ @c_obj_cls
      AND objectid   IN @so_bp
      AND username   IN @so_user
      AND udate      IN @so_udat
      AND utime      IN @so_utim
      AND change_ind EQ @c_u.
  IF sy-subrc NE 0.
* Begin by AMOHAMMED on 06-08-2020 - ED2K918403
* Changed message type from error to information
* Changed message from "No record found" to "No change log records found"
*    MESSAGE text-002 TYPE c_e. " No record found
    MESSAGE text-002 TYPE c_i. " No change log records found
* End by AMOHAMMED on 06-08-2020 - ED2K918403
  ELSEIF t_cdhdr IS NOT INITIAL.
    SORT t_cdhdr BY objectclas objectid changenr.
    SELECT objectclas, objectid, changenr, tabname, tabkey, fname,
           chngind, value_new, value_old
      FROM cdpos
      INTO TABLE @t_cdpos
      FOR ALL ENTRIES IN @t_cdhdr
      WHERE objectclas EQ @t_cdhdr-objectclas
        AND objectid   EQ @t_cdhdr-objectid
        AND changenr   EQ @t_cdhdr-changenr
        AND fname      EQ @c_tax_field
        AND chngind    EQ @c_u.
    IF sy-subrc NE 0.
* Begin by AMOHAMMED on 06-08-2020 - ED2K918403
* Changed message type from error to information
* Changed message from "No record found" to "No change log records found"
*    MESSAGE text-002 TYPE c_e. " No record found
      MESSAGE text-002 TYPE c_i. " No change log records found
* End by AMOHAMMED on 06-08-2020 - ED2K918403
    ELSE.
      SORT t_cdpos BY objectid.
    ENDIF.
  ENDIF.

*---------------------------START-OF-SELECTION-------------------------*
START-OF-SELECTION.
  " When t_cdpos internal table has data
  IF t_cdpos IS NOT INITIAL.    " AMOHAMMED on 06-08-2020 - ED2K918403
    PERFORM f_get_data.         " Fetch the data
  ENDIF.                        " AMOHAMMED on 06-08-2020 - ED2K918403

END-OF-SELECTION.
  " When t_cdpos internal table has data
  IF t_cdpos IS NOT INITIAL.    " AMOHAMMED on 06-08-2020 - ED2K918403
    IF so_email IS NOT INITIAL. " When Email id is provided
      PERFORM f_send_email.
    ELSE.                       " When Email id is not provided
      PERFORM f_display_data.
    ENDIF.
  ENDIF.                        " AMOHAMMED on 06-08-2020 - ED2K918403
*----------------------------INCLUDES USED-----------------------------*

* INCLUDE ZBPN_TAX_CHNG_LOG_R105_F01.            " Subroutines
*
*----------------------------------------------------------------------*
  INCLUDE zbpn_tax_chng_log_r105_f01.
