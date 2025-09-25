*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_VARIANT_CONTENTS_CHANGE
* PROGRAM DESCRIPTION: Variant content change
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE:   04/01/2018
* OBJECT ID:  ?
* TRANSPORT NUMBER(S): ED2K911732
*----------------------------------------------------------------------*
REPORT zqtc_variant_contents_change NO STANDARD PAGE
                                    HEADING MESSAGE-ID zqtc_r2.

*** INCLUDES-------------------------------------------------------------*
*- For Declaration
INCLUDE zqtc_variant_contents_chg_top IF FOUND.
*- For Selection screen
INCLUDE zqtc_variant_contents_chg_sel IF FOUND.
*- For subroutines
INCLUDE zqtc_variant_contents_chg_sub IF FOUND.

**** AT Selection Screen ***
AT SELECTION-SCREEN.
  SELECT SINGLE * FROM varid
                  INTO lst_varid
                  WHERE report  = p_pr_n
                  AND   variant = p_vr_n.
  IF sy-subrc NE 0.
    MESSAGE e015(zqtc_r2). " displaying Error message
  ENDIF.
*********** START-OF-SELECTION ***************
START-OF-SELECTION.
*- Get Variant Data based on selection  screen input
  PERFORM get_variant_data.
*- Get IDOC count based on varient information
  PERFORM get_count_for_idocs.
*- Modify Variant data with latest packet size
  IF lt_idoc_control_r[] IS NOT INITIAL AND
     lv_get_packet_n IS NOT INITIAL.
    PERFORM modify_variant_data.
  ENDIF.
*- Display the report with information
  PERFORM display_rpt.
*- Clear work areas and internal tables
  PERFORM clear_data.
