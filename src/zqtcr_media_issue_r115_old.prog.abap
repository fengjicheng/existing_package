*&---------------------------------------------------------------------*
*& Report  ZQTCR_MEDIA_ISSUE_R115
* PROGRAM DESCRIPTION: Media Issue Cockpit
* DEVELOPER: Saideep Telukuntla (SRTELUKUNT)
* CREATION DATE:   3rd June, 2020
* OBJECT ID:  R115
* TRANSPORT NUMBER(S):
*&---------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
*&---------------------------------------------------------------------*
REPORT zqtcr_media_issue_r115_old.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_med_iss_r115_top_old.

*Include for Selection Screen
INCLUDE zqtcn_med_iss_r115_sel_old.

*Include for Subroutines
INCLUDE zqtcn_med_iss_r115_sub_old.

*&---------------------------------------------------------------------*
*&    initialization
*&---------------------------------------------------------------------*
INITIALIZATION.
*
** Populate the Contract Validity From date
*  s_vdat-sign = 'I'.
*  s_vdat-option = 'BT'.
*  s_vdat-low = sy-datum.
*  s_vdat-high = sy-datum.
*  APPEND s_vdat TO s_vdat.

*&---------------------------------------------------------------------*
*&    at selection-screen
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN.
** Validation to check if either of Media Issue or Product or Pub Date is selected

  IF s_prod[] IS INITIAL AND s_issu[] IS INITIAL AND s_pbdt[] IS INITIAL AND s_indt[] IS INITIAL AND s_dldt IS INITIAL.
    MESSAGE e023(zren) WITH lc_msg1 lc_msg3 lc_msg4 lc_msg5 DISPLAY LIKE 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.
***&---------------------------------------------------------------------*
***&    at selection-screen output
***&---------------------------------------------------------------------*

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_exbb-low.

  REFRESH it_stat.

  wa_stat-status = 'YES'.
*  wa_stat-maktx = 'Dummy Material 2'.
  APPEND wa_stat TO it_stat.

  wa_stat-status = 'NO'.
*  wa_stat-maktx = 'Dummy Material 3'.
  APPEND wa_stat TO it_stat.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'STATUS'
      value_org       = 'S'
    TABLES
      value_tab       = it_stat
      return_tab      = it_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  READ TABLE it_return INTO wa_return INDEX 1.
  IF sy-subrc = 0.
    s_exbb-low = wa_return-fieldval.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_exdb-low.

  REFRESH it_stat.

  wa_stat-status = 'YES'.
*  wa_stat-maktx = 'Dummy Material 2'.
  APPEND wa_stat TO it_stat.

  wa_stat-status = 'NO'.
*  wa_stat-maktx = 'Dummy Material 3'.
  APPEND wa_stat TO it_stat.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'STATUS'
      value_org       = 'S'
    TABLES
      value_tab       = it_stat
      return_tab      = it_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  READ TABLE it_return INTO wa_return INDEX 1.
  IF sy-subrc = 0.
    s_exdb-low = wa_return-fieldval.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_excb-low.

  REFRESH it_stat.

  wa_stat-status = 'YES'.
*  wa_stat-maktx = 'Dummy Material 2'.
  APPEND wa_stat TO it_stat.

  wa_stat-status = 'NO'.
*  wa_stat-maktx = 'Dummy Material 3'.
  APPEND wa_stat TO it_stat.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'STATUS'
      value_org       = 'S'
    TABLES
      value_tab       = it_stat
      return_tab      = it_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  READ TABLE it_return INTO wa_return INDEX 1.
  IF sy-subrc = 0.
    s_excb-low = wa_return-fieldval.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_excc-low.

  REFRESH it_stat.

  wa_stat-status = 'YES'.
*  wa_stat-maktx = 'Dummy Material 2'.
  APPEND wa_stat TO it_stat.

  wa_stat-status = 'NO'.
*  wa_stat-maktx = 'Dummy Material 3'.
  APPEND wa_stat TO it_stat.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'STATUS'
      value_org       = 'S'
    TABLES
      value_tab       = it_stat
      return_tab      = it_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  READ TABLE it_return INTO wa_return INDEX 1.
  IF sy-subrc = 0.
    s_excc-low = wa_return-fieldval.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_exro-low.

  REFRESH it_stat.

  wa_stat-status = 'YES'.
*  wa_stat-maktx = 'Dummy Material 2'.
  APPEND wa_stat TO it_stat.

  wa_stat-status = 'NO'.
*  wa_stat-maktx = 'Dummy Material 3'.
  APPEND wa_stat TO it_stat.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'STATUS'
      value_org       = 'S'
    TABLES
      value_tab       = it_stat
      return_tab      = it_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  READ TABLE it_return INTO wa_return INDEX 1.
  IF sy-subrc = 0.
    s_exro-low = wa_return-fieldval.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_irel-low.

  REFRESH it_stat.

  wa_stat-status = 'YES'.
*  wa_stat-maktx = 'Dummy Material 2'.
  APPEND wa_stat TO it_stat.

  wa_stat-status = 'NO'.
*  wa_stat-maktx = 'Dummy Material 3'.
  APPEND wa_stat TO it_stat.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'STATUS'
      value_org       = 'S'
    TABLES
      value_tab       = it_stat
      return_tab      = it_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  READ TABLE it_return INTO wa_return INDEX 1.
  IF sy-subrc = 0.
    s_irel-low = wa_return-fieldval.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_iamt-low.

  REFRESH it_stat.

  wa_stat-status = 'YES'.
*  wa_stat-maktx = 'Dummy Material 2'.
  APPEND wa_stat TO it_stat.

  wa_stat-status = 'NO'.
*  wa_stat-maktx = 'Dummy Material 3'.
  APPEND wa_stat TO it_stat.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'STATUS'
      value_org       = 'S'
    TABLES
      value_tab       = it_stat
      return_tab      = it_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  READ TABLE it_return INTO wa_return INDEX 1.
  IF sy-subrc = 0.
    s_iamt-low = wa_return-fieldval.
  ENDIF.

*&---------------------------------------------------------------------*
*&    start of selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM f_get_data.

*&---------------------------------------------------------------------*
*&    end-of-selection.
*&---------------------------------------------------------------------*
END-OF-SELECTION.

  PERFORM f_build_fieldcatalog.
  PERFORM f_build_layout.
  PERFORM f_list_display.
