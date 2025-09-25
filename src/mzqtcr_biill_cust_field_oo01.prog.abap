*----------------------------------------------------------------------*
***INCLUDE MZQTCR_BIILL_CUST_FIELD_OO01.
*----------------------------------------------------------------------*
* PROGRAM NAME:MZQTCR_BIILL_CUST_FIELD_OO01
* PROGRAM DESCRIPTION:Custom Copy control.
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-10-02
* OBJECT ID:E070
* TRANSPORT NUMBER(S):ED2K903028
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*-------------------------------------------------------------------*

MODULE status_9001 OUTPUT.

  CONSTANTS: lc_vf01 TYPE tcode VALUE 'VF01', " Transaction Code
             lc_vf02 TYPE tcode VALUE 'VF02', " Transaction Code
             lc_vf03 TYPE tcode VALUE 'VF03'. " Transaction Code

  IF sy-tcode = lc_vf01
    OR sy-tcode = lc_vf02
    OR sy-tcode = lc_vf03.
    LOOP AT SCREEN.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDLOOP. " LOOP AT SCREEN
  ENDIF. " IF sy-tcode = lc_vf01

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.


ENDMODULE.
