*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTC_SMR_RENEWAL_TBL_UPD_C064
* PROGRAM DESCRIPTION: Update renewal Plan table to update Status
* obtained from E096
* DEVELOPER: Aratrika Banerjee
* CREATION DATE:   2017-04-07
* OBJECT ID : C064
* TRANSPORT NUMBER(S):  ED2K905240
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*

REPORT zqtc_smr_renewal_tbl_upd_c064 NO STANDARD PAGE HEADING
                                  LINE-SIZE  132
                                  LINE-COUNT 65
                                  MESSAGE-ID zqtc_r2.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
**Include for Global Data Declaration
INCLUDE ZQTCN_RENEWAL_TBL_UPD_C064_TOP.
*INCLUDE zqtc_renewal_tbl_upd_c064_top. " Include ZQTC_RENEWAL_TBL_UPD_C064_TOP

*Include for Selection Screen
INCLUDE ZQTCN_RENEWAL_TBL_UPD_C064_SEL.
*INCLUDE zqtc_renewal_tbl_upd_c064_sel. " Include ZQTC_RENEWAL_TBL_UPD_C064_SEL

*Include for Subroutines
INCLUDE ZQTCN_RENEWAL_TBL_UPD_C064_F01.
*INCLUDE zqtc_renewal_tbl_upd_c064_f01. " Include ZQTC_RENEWAL_TBL_UPD_C064_F01

*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.

  PERFORM f_global_clear.

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

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.
  IF rb_appl IS INITIAL.
    PERFORM  f_read_file_frm_pres_server USING    p_file
                                         CHANGING i_upload_file.
  ELSE. " ELSE -> IF rb_appl IS INITIAL
    PERFORM  f_read_file_frm_app_server  USING    p_file
                                         CHANGING i_upload_file.
  ENDIF. " IF rb_appl IS INITIAL

  IF i_upload_file IS NOT INITIAL.

    PERFORM f_update_table USING i_upload_file.

    LEAVE LIST-PROCESSING.

  ENDIF. " IF i_upload_file IS NOT INITIAL
