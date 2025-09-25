*-------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_NEW_PROJECTMASTER_JANIS
* PROGRAM DESCRIPTION: Create Maintain Media Product Master Records
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-02-02
* OBJECT ID:E148
* TRANSPORT NUMBER(S):ED2K904337
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*& Report  ZQTCE_NEW_PROJECTMASTER_JANIS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtce_new_projectmaster_janis  LINE-SIZE  165     "Line width
                                      LINE-COUNT 65      "Page length
                                      MESSAGE-ID zrtr_r2 "Message class
                                      NO STANDARD PAGE HEADING.

*----------------------------------------------------------------------*
*                             INCLUDES                                 *
*----------------------------------------------------------------------*
*Include for Global Data Declaration
INCLUDE zqtcn_projectmaster_janis_top. " Include zqtcn_projectmaster_janis_top

*Include for Selection Screen
INCLUDE zqtcn_projectmaster_janis_sel. " Include zqtcn_projectmaster_janis_sel

*Include for Form Routines
INCLUDE zqtcn_projectmaster_janis_f00. " Include zqtcn_projectmaster_janis_f00

*----------------------------------------------------------------------*
*               I N I T I A L I Z A T I O N                            *
*----------------------------------------------------------------------*
INITIALIZATION.
* Populate Selection Screen Default Values
  PERFORM f_populate_defaults CHANGING s_mtyp_i[].

* Clear all variables .
  PERFORM f_clear_all.

*&---------------------------------------------------------------------*
*&****              At Selection-Screen On                          ****
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON s_mtyp_i.
  IF s_mtyp_i IS NOT INITIAL.
* Validate Material Type
    PERFORM f_validate_mat_type USING s_mtyp_i[].
  ENDIF. " IF s_mtyp_i IS NOT INITIAL

*&---------------------------------------------------------------------*
*&****              At Selection-Screen Output                       ****
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF rb_backg = abap_true.
      IF screen-group1 = c_scrgrp.
        screen-active = 0.
      ENDIF. " IF screen-group1 = c_scrgrp
    ELSE. " ELSE -> IF rb_backg = abap_true
      CLEAR rb_backg.
      IF screen-group1 = c_scrgrp.
        screen-active = 1.
      ENDIF. " IF screen-group1 = c_scrgrp
    ENDIF. " IF rb_backg = abap_true
    MODIFY SCREEN. "To update the screen table with the new value during runtime
  ENDLOOP. " LOOP AT SCREEN

*----------------------------------------------------------------------*
*                AT SELECTION SCREEN
*----------------------------------------------------------------------*
* Selection Screen data validation for Media Issue
AT SELECTION-SCREEN ON s_issue.
  IF rb_foreg IS NOT INITIAL.
    IF s_issue[] IS NOT INITIAL.
      PERFORM f_validate_media_issue USING s_issue[].
    ENDIF. " IF s_issue[] IS NOT INITIAL
  ENDIF. " IF rb_foreg IS NOT INITIAL

* Selection Screen data validation for Media Product
AT SELECTION-SCREEN ON s_prod.
  IF rb_foreg IS NOT INITIAL.
    IF s_prod[] IS NOT INITIAL.
      PERFORM f_validate_media_product USING s_prod[].
    ENDIF. " IF s_prod[] IS NOT INITIAL
  ENDIF. " IF rb_foreg IS NOT INITIAL

***----------------------------------------------------------------------*
***             START-OF-SELECTION Event
***----------------------------------------------------------------------*
START-OF-SELECTION.
* Fetch and Process MPM data
  PERFORM f_fetch_n_process .

***----------------------------------------------------------------------*
***             END-OF-SELECTION Event
***----------------------------------------------------------------------*
END-OF-SELECTION.
 " Display Message
  PERFORM f_get_message.
