*----------------------------------------------------------------------*
* PROGRAM NAME:LZQTC_POP_UP_TO_INFORMI01
* PROGRAM DESCRIPTION:Show Pop up
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-10-20
* OBJECT ID:E111
* TRANSPORT NUMBER(S)ED2K903147
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

MODULE user_command_9001 INPUT.

  v_ok_code = ok_code.
  CLEAR ok_code.
  CASE sy-ucomm.
    WHEN 'YES'.
      SET SCREEN 0.
      LEAVE SCREEN.
*	WHEN .
    WHEN OTHERS.
      LEAVE SCREEN .
  ENDCASE.
  SET SCREEN 0.
  LEAVE SCREEN.
ENDMODULE.
