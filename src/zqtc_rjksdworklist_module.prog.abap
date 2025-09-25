*----------------------------------------------------------------------*
*   INCLUDE RJKSDDEMANDCHANGE_MODULE
**----------------------------------------------------------------------
*

*---------------------------------------------------------------------*
*       MODULE PBO OUTPUT                                             *
*---------------------------------------------------------------------*
MODULE PBO OUTPUT.
* Auslagerung in Form                                      "TK28022007
  perform pbo_output.
*
ENDMODULE.                    "PBO OUTPUT

*&---------------------------------------------------------------------*
*&      Module  pbo_list  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PBO_LIST OUTPUT.
  PERFORM LIST_REFRESH_EXECUTE.
ENDMODULE.                             " pbo_list  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  exit_command  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_COMMAND INPUT.
  PERFORM LIST_TRANSFER_CHANGED_DATA.
  PERFORM EXIT_COMMAND CHANGING OK_CODE_101 GV_RECOMMEND_SAVE.
ENDMODULE.                             " exit_command  INPUT

*---------------------------------------------------------------------*
*       MODULE USER_COMMAND INPUT                                     *
*---------------------------------------------------------------------*
MODULE USER_COMMAND INPUT.
  PERFORM USER_COMMAND CHANGING OK_CODE_101 RJKSDWORKLIST_CHANGEFIELDS.
ENDMODULE.                    "USER_COMMAND INPUT

*&---------------------------------------------------------------------*
*&      Module  pai_list  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PAI_LIST INPUT.
  PERFORM LIST_TRANSFER_CHANGED_DATA.
ENDMODULE.                 " pai_list  INPUT

*&---------------------------------------------------------------------*
*&      Module  pai_310  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PAI_310 INPUT.
*  hier ev. Check auf die Zeitraum-Selektion
   perform pai_310_input.                         "Hinw. 1366505
ENDMODULE.                 " pai_310  INPUT



*&---------------------------------------------------------------------*
*&      Module  pbo_310  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PBO_310 OUTPUT.
  perform pbo_310_output.
ENDMODULE.                 " pbo_310  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PBO_500  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PBO_500 OUTPUT.
  SET PF-STATUS 'BATCHJOB_POPUP'.
  SET TITLEBAR 'BATCHJOB_TITEL'.
ENDMODULE.                 " PBO_500  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT_500  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_500 INPUT.
*
  GV_CANCEL = 'X'.
  SET SCREEN 0. LEAVE SCREEN.
*
ENDMODULE.                 " EXIT_500  INPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_500  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PAI_BATCH_500 INPUT.
*
  IF OK_CODE_0500 = 'GOON'.
    IF RJKSD13-BATCH_STARTIMMEDIATE EQ 'X'.
      CLEAR RJKSD13-BATCH_STARTDATE.
      CLEAR RJKSD13-BATCH_STARTTIME.
    ELSE.
      CLEAR RJKSD13-BATCH_STARTIMMEDIATE.
      IF RJKSD13-BATCH_STARTDATE < SY-DATUM.
        MESSAGE E006(BT). LEAVE SCREEN.
      ELSEIF RJKSD13-BATCH_STARTDATE = SY-DATUM.
        IF RJKSD13-BATCH_STARTTIME < SY-UZEIT.
          MESSAGE E006(BT). LEAVE SCREEN.
        ENDIF.
      ENDIF.
    ENDIF.
    SET SCREEN 0.
    LEAVE SCREEN.
  ENDIF.
*
ENDMODULE.                 " PAI_500  INPUT



*---------------------------------------------------------------------*
*  MODULE PBO_700 OUTPUT
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
MODULE PBO_700 OUTPUT.
*
  SET PF-STATUS 'SET_COLUMN_DEFAULT'.
  SET TITLEBAR 'SET_COLUMN_DEFAULT'.
*
ENDMODULE.                             " PBO_700  OUTPUT



*---------------------------------------------------------------------*
*  MODULE screen_modif_700 OUTPUT
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
MODULE SCREEN_MODIF_700 OUTPUT.
*
  LOOP AT SCREEN.
*   Nur die Felder sind aktiv, für die entsprechende Spalten markiert
*   sind:
    IF GV_VTL_STATUS_COLUMN_MARKED IS INITIAL.
      IF SCREEN-NAME = 'RJKSD13-MSTAV'.
        SCREEN-ACTIVE = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
    IF GV_WERKS_STATUS_COLUMN_MARKED IS INITIAL.
      IF SCREEN-NAME = 'RJKSD13-MSTAE'.
        SCREEN-ACTIVE = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
    IF GV_DATE_COLUMN_MARKED IS INITIAL.
      IF SCREEN-NAME = 'RJKSD13-MARKED_DATE'.
        SCREEN-ACTIVE = 0.
        screen-invisible = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
  ENDLOOP.
*
ENDMODULE.                             " screen_modif_700  OUTPUT

*---------------------------------------------------------------------*
*  MODULE EXIT_700 INPUT
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
MODULE EXIT_700 INPUT.
*
  GV_CANCEL = 'X'.
  SET SCREEN 0. LEAVE SCREEN.
*
ENDMODULE.                             " EXIT_700  INPUT


*---------------------------------------------------------------------*
*  MODULE PAI_700 INPUT
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
MODULE PAI_700 INPUT.
*
  IF OK_CODE_0700 = 'GOON'.
    SET SCREEN 0.
    LEAVE SCREEN.
  ENDIF.
*
ENDMODULE.                             " PAI_700  INPUT

MODULE PBO_550 OUTPUT.
  SET PF-STATUS 'SEL_WARNING_POPUP'.
  SET TITLEBAR 'SEL_WARNING_TITEL'.
ENDMODULE.                 " PBO_550  OUTPUT

MODULE EXIT_550 INPUT.
*
  GV_CANCEL = 'X'.
  SET SCREEN 0. LEAVE SCREEN.
*
ENDMODULE.                 " EXIT_550  INPUT

MODULE PAI_550 INPUT.
*
* IF OK_CODE_0550 = 'GOON'.
    SET SCREEN 0.
    LEAVE SCREEN.
* ENDIF.
*
ENDMODULE.                 " PAI_550  INPUT


*&---------------------------------------------------------------------*
*&      Module  CALLED_WITH_SET_GET_PARAMETER  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE called_with_set_get_parameter OUTPUT.     "CALL_JKSD13
  PERFORM called_with_set_get_parameter.         "CALL_JKSD13
ENDMODULE.                                       "CALL_JKSD13

MODULE save_okcode input.          "TK16072009/hint1365757
  PERFORM save_okcode.             "TK16072009/hint1365757
ENDMODULE.                         "TK16072009/hint1365757
