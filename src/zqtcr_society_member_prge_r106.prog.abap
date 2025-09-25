*---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_SOCIETY_MEMBER_PRGE_r106 (Main Program)
* PROGRAM DESCRIPTION: Society Member progression report
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   05/12/2020
* WRICEF ID:       R106
* TRANSPORT NUMBER(S):  ED2K918190
*---------------------------------------------------------------------*
REPORT zqtcr_society_member_prge_r106 NO STANDARD PAGE HEADING
                                      MESSAGE-ID zqtc_r2.


INCLUDE zqtcn_society_member_prge_top IF FOUND.        " Define global data

INCLUDE zqtcn_society_member_prge_sel IF FOUND.        " Define selection screen

INCLUDE zqtcn_society_member_prge_sub IF FOUND.        " Subroutines.

INITIALIZATION.

  PERFORM f_get_zcaconstants CHANGING i_constant.                  " ABAP Constant value table

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_socbp-low.
  PERFORM f_socbp_val_on_request CHANGING s_socbp-low.

AT SELECTION-SCREEN.
  PERFORM f_screen_validate.                  " Selection screen

START-OF-SELECTION.
  PERFORM f_screen_validate.                  " Selection screen
  PERFORM f_fetch_data CHANGING i_socbp
                                i_membp.

  PERFORM f_build_data USING i_socbp
                             i_membp.

  PERFORM f_display_data.
