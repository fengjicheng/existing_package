*&---------------------------------------------------------------------*
*& Report  ZQTCR_MEDIA_ISSUE_R115
* PROGRAM DESCRIPTION: Media Issue Cockpit
* DEVELOPER: Saideep Telukuntla (SRTELUKUNT)
* CREATION DATE:   3rd June, 2020
* OBJECT ID:  R115
* TRANSPORT NUMBER(S):
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO : ED2K925006                                             *
* REFERENCE NO: OTCM-45347                                             *
* DEVELOPER   : Thilina Dimantha (TDIMANTHA)                           *
* DATE        : 11/12/2021                                             *
* DESCRIPTION : Media Issue cockpit Performence improvement
*----------------------------------------------------------------------*
REPORT zqtcr_media_issue_r115_poc.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE ZQTCR_MED_ISS_R115_POC_TOP.

*Include for Selection Screen
INCLUDE ZQTCR_MED_ISS_R115_POC_SEL.

*Include for Subroutines
INCLUDE ZQTCR_MED_ISS_R115_POC_SUB.

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

* BOC by Lahiru on 03/24/2021 for OTCM-29592 with ED2K922697  *
  PERFORM f_get_constant_values.            " Fetch constant values
  PERFORM f_populate_defaults.              " Set default values.
* EOC by Lahiru on 03/24/2021 for OTCM-29592 with ED2K922697  *

*&---------------------------------------------------------------------*
*&    at selection-screen
*&---------------------------------------------------------------------*
* BOC by Lahiru on 03/31/2021 for OTCM-29592 with ED2K922788  *
*AT SELECTION-SCREEN.
*** Validation to check if either of Media Issue or Product or Pub Date is selected
*
*  IF s_prod[] IS INITIAL AND s_issu[] IS INITIAL AND s_pbdt[] IS INITIAL AND s_indt[] IS INITIAL AND s_dldt IS INITIAL.
*    MESSAGE e023(zren) WITH lc_msg1 lc_msg3 lc_msg4 lc_msg5 DISPLAY LIKE 'I'.
*    LEAVE LIST-PROCESSING.
*  ENDIF.
* EOC by Lahiru on 03/31/2021 for OTCM-29592 with ED2K922788  *
***&---------------------------------------------------------------------*
***&    at selection-screen output
***&---------------------------------------------------------------------*

*AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_exbb-low.
*
*  REFRESH it_stat.
*
*  wa_stat-status = 'YES'.
**  wa_stat-maktx = 'Dummy Material 2'.
*  APPEND wa_stat TO it_stat.
*
*  wa_stat-status = 'NO'.
**  wa_stat-maktx = 'Dummy Material 3'.
*  APPEND wa_stat TO it_stat.
*
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield        = 'STATUS'
*      value_org       = 'S'
*    TABLES
*      value_tab       = it_stat
*      return_tab      = it_return
*    EXCEPTIONS
*      parameter_error = 1
*      no_values_found = 2
*      OTHERS          = 3.
*
*  READ TABLE it_return INTO wa_return INDEX 1.
*  IF sy-subrc = 0.
*    s_exbb-low = wa_return-fieldval.
*  ENDIF.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_exdb-low.
*
*  REFRESH it_stat.
*
*  wa_stat-status = 'YES'.
**  wa_stat-maktx = 'Dummy Material 2'.
*  APPEND wa_stat TO it_stat.
*
*  wa_stat-status = 'NO'.
**  wa_stat-maktx = 'Dummy Material 3'.
*  APPEND wa_stat TO it_stat.
*
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield        = 'STATUS'
*      value_org       = 'S'
*    TABLES
*      value_tab       = it_stat
*      return_tab      = it_return
*    EXCEPTIONS
*      parameter_error = 1
*      no_values_found = 2
*      OTHERS          = 3.
*
*  READ TABLE it_return INTO wa_return INDEX 1.
*  IF sy-subrc = 0.
*    s_exdb-low = wa_return-fieldval.
*  ENDIF.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_excb-low.
*
*  REFRESH it_stat.
*
*  wa_stat-status = 'YES'.
**  wa_stat-maktx = 'Dummy Material 2'.
*  APPEND wa_stat TO it_stat.
*
*  wa_stat-status = 'NO'.
**  wa_stat-maktx = 'Dummy Material 3'.
*  APPEND wa_stat TO it_stat.
*
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield        = 'STATUS'
*      value_org       = 'S'
*    TABLES
*      value_tab       = it_stat
*      return_tab      = it_return
*    EXCEPTIONS
*      parameter_error = 1
*      no_values_found = 2
*      OTHERS          = 3.
*
*  READ TABLE it_return INTO wa_return INDEX 1.
*  IF sy-subrc = 0.
*    s_excb-low = wa_return-fieldval.
*  ENDIF.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_excc-low.
*
*  REFRESH it_stat.
*
*  wa_stat-status = 'YES'.
**  wa_stat-maktx = 'Dummy Material 2'.
*  APPEND wa_stat TO it_stat.
*
*  wa_stat-status = 'NO'.
**  wa_stat-maktx = 'Dummy Material 3'.
*  APPEND wa_stat TO it_stat.
*
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield        = 'STATUS'
*      value_org       = 'S'
*    TABLES
*      value_tab       = it_stat
*      return_tab      = it_return
*    EXCEPTIONS
*      parameter_error = 1
*      no_values_found = 2
*      OTHERS          = 3.
*
*  READ TABLE it_return INTO wa_return INDEX 1.
*  IF sy-subrc = 0.
*    s_excc-low = wa_return-fieldval.
*  ENDIF.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_exro-low.
*
*  REFRESH it_stat.
*
*  wa_stat-status = 'YES'.
**  wa_stat-maktx = 'Dummy Material 2'.
*  APPEND wa_stat TO it_stat.
*
*  wa_stat-status = 'NO'.
**  wa_stat-maktx = 'Dummy Material 3'.
*  APPEND wa_stat TO it_stat.
*
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield        = 'STATUS'
*      value_org       = 'S'
*    TABLES
*      value_tab       = it_stat
*      return_tab      = it_return
*    EXCEPTIONS
*      parameter_error = 1
*      no_values_found = 2
*      OTHERS          = 3.
*
*  READ TABLE it_return INTO wa_return INDEX 1.
*  IF sy-subrc = 0.
*    s_exro-low = wa_return-fieldval.
*  ENDIF.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_irel-low.
*
*  REFRESH it_stat.
*
*  wa_stat-status = 'YES'.
**  wa_stat-maktx = 'Dummy Material 2'.
*  APPEND wa_stat TO it_stat.
*
*  wa_stat-status = 'NO'.
**  wa_stat-maktx = 'Dummy Material 3'.
*  APPEND wa_stat TO it_stat.
*
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield        = 'STATUS'
*      value_org       = 'S'
*    TABLES
*      value_tab       = it_stat
*      return_tab      = it_return
*    EXCEPTIONS
*      parameter_error = 1
*      no_values_found = 2
*      OTHERS          = 3.
*
*  READ TABLE it_return INTO wa_return INDEX 1.
*  IF sy-subrc = 0.
*    s_irel-low = wa_return-fieldval.
*  ENDIF.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_iamt-low.
*
*  REFRESH it_stat.
*
*  wa_stat-status = 'YES'.
**  wa_stat-maktx = 'Dummy Material 2'.
*  APPEND wa_stat TO it_stat.
*
*  wa_stat-status = 'NO'.
**  wa_stat-maktx = 'Dummy Material 3'.
*  APPEND wa_stat TO it_stat.
*
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield        = 'STATUS'
*      value_org       = 'S'
*    TABLES
*      value_tab       = it_stat
*      return_tab      = it_return
*    EXCEPTIONS
*      parameter_error = 1
*      no_values_found = 2
*      OTHERS          = 3.
*
*  READ TABLE it_return INTO wa_return INDEX 1.
*  IF sy-subrc = 0.
*    s_iamt-low = wa_return-fieldval.
*  ENDIF.

* BOC by Lahiru on 02/16/2021 for OTCM-29592 with ED2K921929  *
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_alv_vr.
  PERFORM f_alv_variant_value_request CHANGING p_alv_vr.
* EOC by Lahiru on 02/16/2021 for OTCM-29592 with ED2K921929  *


*&---------------------------------------------------------------------*
*&    start of selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.

* BOC by Lahiru on 03/31/2021 for OTCM-29592 with ED2K922788  *
* Validation to check if either of Media Issue or Product or Pub Date is selected
  IF s_prod[] IS INITIAL AND s_issu[] IS INITIAL AND s_pbdt[] IS INITIAL AND s_indt[] IS INITIAL AND s_dldt IS INITIAL.
    MESSAGE s023(zren) WITH lc_msg1 lc_msg3 lc_msg4 lc_msg5 DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
* EOC by Lahiru on 03/31/2021 for OTCM-29592 with ED2K922788  *

* BOC by Lahiru on 02/16/2021 for OTCM-29592 with ED2K921929  *
*  PERFORM f_validate_alv_variant USING p_alv_vr.
* EOC by Lahiru on 02/16/2021 for OTCM-29592 with ED2K921929  *

* BOC by Lahiru on 04/07/2021 for OTCM-29592 with ED2K922941  *
*  PERFORM f_check_row_count.                        " Check the row count
* EOC by Lahiru on 04/07/2021 for OTCM-29592 with ED2K922941  *

* BOC by Lahiru on 03/31/2021 for OTCM-29592 with ED2K922788  *
  IF sy-batch = abap_false AND rb_bgr = abap_true.
    PERFORM f_create_bg_process.
  ENDIF.
* EOC by Lahiru on 03/31/2021 for OTCM-29592 with ED2K922788  *

  IF sy-batch = abap_true AND rb_bgr = abap_true.   " Skip the data fetch from foreground once submitted to the background
    PERFORM f_get_data.
  ELSEIF rb_fgr = abap_true.
    PERFORM f_get_data.
  ENDIF.

*&---------------------------------------------------------------------*
*&    end-of-selection.
*&---------------------------------------------------------------------*
END-OF-SELECTION.

  IF rb_fgr = abap_true.                                 " Foreground process
    PERFORM f_build_fieldcatalog.
    PERFORM f_build_layout.
    PERFORM f_list_display.
* BOC by Lahiru on 03/31/2021 for OTCM-29592 with ED2K922788  *
  ELSEIF sy-batch = abap_true AND rb_bgr = abap_true.    " Background process
    PERFORM f_generate_bg_file.
    PERFORM f_get_email.
    PERFORM f_send_mail.
  ELSE.
    MESSAGE s589(zqtc_r2) WITH text-014 .
  ENDIF.
* EOC by Lahiru on 03/31/2021 for OTCM-29592 with ED2K922788  *
