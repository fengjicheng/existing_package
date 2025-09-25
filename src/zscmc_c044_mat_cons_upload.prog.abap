*----------------------------------------------------------------------*
*PROGRAM NAME : ZSCMC_C044_MAT_CONS_UPLOAD
*PROGRAM DESCRIPTION: Load 3 years of consumption history for active
*materials
* DEVELOPER: Shivani Upadhyaya/Cheenangshuk Das
* CREATION DATE:   2016-07-18
* DER NUMBER:
* TRANSPORT NUMBER(S): ED2K902573
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zscmc_c044_mat_cons_upload NO STANDARD PAGE HEADING
                                  LINE-SIZE  132
                                  LINE-COUNT 65
                                  MESSAGE-ID zqtc_r2.
*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE zscmn_c044_mat_cons_upload_top. " Include ZSCMN_C044_MAT_CONS_UPLOAD_TOP
" Include ZSCMN_C044_MAT_CONS_UPLOAD_TOP

*Include for Selection Screen
INCLUDE zscmn_c044_mat_cons_upload_sel. " Include ZSCMN_C044_MAT_CONS_UPLOAD_SEL
" Include ZSCMN_C044_MAT_CONS_UPLOAD_SEL

*Include for Subroutines
INCLUDE zscmn_c044_mat_cons_upload_f01. " Include ZSCMN_C044_MAT_CONS_UPLOAD_F01
" Include ZSCMN_C044_MAT_CONS_UPLOAD_F01

*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.

  PERFORM f_clear_all.
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

*Remove the header line
  IF cb_hdr IS NOT INITIAL.
    DELETE i_upload_file INDEX 1.
  ENDIF. " IF cb_hdr IS NOT INITIAL

PERFORM f_get_constants changing i_constant.

END-OF-SELECTION.
*--------------------------------------------------------------------*
* Upload MVER
*--------------------------------------------------------------------*
 PERFORM f_upload_mver USING    i_upload_file
                       CHANGING i_amerrdat_f.

*IF i_amerrdat_f[] IS NOT INITIAL.
*--------------------------------------------------------------------*
* Populate the Alv table with Error message
*--------------------------------------------------------------------*
  PERFORM f_pop_succ_tab USING    i_amerrdat_f
                                  i_upload_file
                         CHANGING i_download_file.
*ENDIF.
*--------------------------------------------------------------------*
* DownLoad File
*--------------------------------------------------------------------*
  IF i_download_file[] IS NOT INITIAL.
    IF rb_appl IS INITIAL.
      PERFORM  f_write_file_frm_pres_server USING    p_file
                                                     i_download_file
                                           CHANGING  v_download_chk.

    ELSE. " ELSE -> IF rb_appl IS INITIAL
      PERFORM  f_write_file_frm_app_server  USING    p_file
                                                     i_download_file
                                           CHANGING  v_download_chk.
    ENDIF. " IF rb_appl IS INITIAL
  ENDIF. " IF i_download_file[] IS NOT INITIAL

*&**************************Count Display*************************&>
     WRITE :/ text-o01,v_total_lines_read,
            / text-o02,v_error_lines,
            / text-o03,v_success_lines.

   IF v_download_chk IS NOT INITIAL.
     WRITE:/ text-o04.
   ELSE.
     WRITE:/ text-o05.
   ENDIF.
