* PROGRAM NAME:         ZQTCR_ISMMATMAS_CHANGE_I369                    *
* PROGRAM DESCRIPTION:  Report to get the BDCP2 unprocessed            *
*                       Change Pointer details against the Message Type*
*                       and Submit program “RBDSEMAT” (Tcode BD10)with *
*                       materials and Update the process indicator = ‘X’
*                       using FM CHANGE_POINTERS_STATUS_WRITE
* DEVELOPER:            MIMMADISET                                     *
* CREATION DATE:        03/30/2021                                     *
* OBJECT ID:            I0369.1                                        *
* TRANSPORT NUMBER(S):  ED2K922771                                     *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtcr_ismmatmas_change_i369 NO STANDARD PAGE HEADING
                                     MESSAGE-ID zqtc_r2.

*---Top include
INCLUDE zqtcn_matmas_change_i369_top IF FOUND.

*---Include for Selection Screen
INCLUDE zqtcn_matmas_change_i369_scr IF FOUND.

*--Form inlude
INCLUDE zqtcn_matmas_change_i369_f01 IF FOUND.

INITIALIZATION.

* authority check
AT SELECTION-SCREEN.

  PERFORM authority_check_master_data USING p_mestyp abap_true.

* message type check
AT SELECTION-SCREEN ON p_mestyp.

*Validating the Input
  PERFORM f_validating_input  USING p_mestyp.

AT SELECTION-SCREEN OUTPUT.
*Enable a field on selection screen based on a condition
  PERFORM f_enable_fld.

START-OF-SELECTION.
* Enter date if reprocessed check is checked
  PERFORM f_enter_date.
*---free the gloabl tables
  PERFORM f_free_gloabl_tables.
*---Fetch the contstant table data
  PERFORM f_fetch_constants.
*Fetch from BDCP2
  PERFORM f_get_bdcp2 USING    p_mestyp
                      CHANGING i_bdcp2
                               i_mara.
