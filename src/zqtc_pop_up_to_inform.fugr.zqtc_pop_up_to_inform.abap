FUNCTION zqtc_pop_up_to_inform.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_FLAG) TYPE  CHAR1 OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_POP_UP_TO_INFORM
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
  CLEAR v_text.
  IF im_flag = c_mail.
    CONCATENATE text-002 text-003 INTO v_text SEPARATED BY space.
  ELSEIF im_flag = c_tel.
    CONCATENATE text-002 text-004 INTO v_text SEPARATED BY space.
  ENDIF.
  IF v_text IS NOT INITIAL.
    CALL SCREEN 9001 STARTING AT 1 3
                     ENDING AT 80 5.
  ENDIF.





ENDFUNCTION.
