*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCC_CREATE_QUOTATION_C064
* PROGRAM DESCRIPTION: Get the data from input pipe dilimited file,
* Create quotation for the subs order present in input feed file and
* update table ZQTC_RENWL_PLAN.
* DEVELOPER: Lucky Kodwani(LKODWANI)
* CREATION DATE:   2017-07-03
* DER NUMBER: C064/CR_344
* TRANSPORT NUMBER(S): ED2K907090
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCC_CREATE_QUOTATION_C064
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtcc_create_quotation_c064 NO STANDARD PAGE HEADING
                                  MESSAGE-ID zqtc_r2.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zqtcn_create_quotatn_c064_top. " Include ZQTCN_CREATE_QUOTATN_C067_TOP
" Include ZQTCC_CREATE_QUOTATION_C064_TOP

*Include for Selection Screen
INCLUDE zqtcn_create_quotatn_c064_sel. " Include ZQTCN_CREATE_QUOTATN_C067_SEL
" Include ZQTCC_CREATE_QUOTATION_C064_SEL

*Include for Subroutines
INCLUDE zqtcn_create_quotatn_c064_f01. " Include ZQTCN_CREATE_QUOTATN_C067_F01
" Include ZQTCC_CREATE_QUOTATION_C064_F01

*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.

  PERFORM f_clear_varibles.
*----------------------------------------------------------------------*
*                AT SELECTION SCREEN ON VALUE REQUEST                  *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  IF rb_appl IS INITIAL. "Presentation Server
    PERFORM f_f4_presentation USING   syst-cprog
                                      c_field
                             CHANGING p_file.
  ELSE. " ELSE -> IF rb_appl IS INITIAL
    PERFORM f_f4_application CHANGING p_file.
  ENDIF. " IF rb_appl IS INITIAL

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN ON                *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON s_activ.
  IF s_activ IS NOT INITIAL.
* Validate activity
    PERFORM f_validate_activity.
  ENDIF. " IF s_activ IS NOT INITIAL


AT SELECTION-SCREEN ON p_qtype.
  IF p_qtype IS NOT INITIAL.
* Validate activity
    PERFORM f_validate_quotation_type.
  ENDIF. " IF p_qtype IS NOT INITIAL

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN                  *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
  IF sy-ucomm = c_rucomm. "'RUCOMM'.
    CLEAR p_file.
  ELSEIF sy-ucomm = c_onli. "'ONLI'.
    IF rb_appl IS INITIAL. "Presentation Server
      PERFORM f_validate_presentation USING p_file.
    ELSE. " ELSE -> IF rb_appl IS INITIAL
      PERFORM f_validate_application  USING p_file.
    ENDIF. " IF rb_appl IS INITIAL
  ENDIF. " IF sy-ucomm = c_rucomm

*--------------------------------------------------------------------*
*   START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

  IF rb_appl IS INITIAL.
    PERFORM  f_read_file_frm_pres_server USING    p_file
                                         CHANGING i_upload_file.
  ELSE. " ELSE -> IF rb_appl IS INITIAL
    PERFORM  f_read_file_frm_app_server  USING    p_file
                                         CHANGING i_upload_file.
  ENDIF. " IF rb_appl IS INITIAL

  PERFORM f_fetch_data.

*--------------------------------------------------------------------*
*   END-OF-SELECTION
*--------------------------------------------------------------------*
END-OF-SELECTION.

  PERFORM f_update_auto_renewal.

  PERFORM f_popul_field_catalog.

*& Display ALV
  PERFORM f_display_alv.
