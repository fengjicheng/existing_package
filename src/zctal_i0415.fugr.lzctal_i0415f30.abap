*-------------------------------------------------------------------
***INCLUDE LCTALF30 .
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  CHK_CHANGE_ALLOWED
*&---------------------------------------------------------------------*
*
*       check if local change of characteristic is allowed.
*       write error log if local change is allowed
*
*----------------------------------------------------------------------*
*  -->  CHARACT   characteristic
*  -->  CHANGE_NO change number
*  -->  KEY_DATE  key date of change
*  <--  F_ERROR   flag for error
*----------------------------------------------------------------------*
FORM CHK_CHANGE_ALLOWED USING CHARACT   LIKE CABN-ATNAM
                              KEY_DATE  LIKE SY-DATUM
                              F_ERROR   type flag.

  DATA:
    FIELDGROUP_TAB LIKE ALEPDM_FIELDGROUP_TAB OCCURS 1 WITH HEADER LINE,
    L_CABN LIKE CABN,                 "local copy of character. master
    lh_msgv1 like sy-msgv1.

*... check if PDM is active

  CALL FUNCTION 'FUNCTION_EXISTS'
       EXPORTING
            FUNCNAME           = 'ALEPDM_GET_FIELD_GROUPS'
       EXCEPTIONS
            FUNCTION_NOT_EXIST = 1
            OTHERS             = 2.
  IF NOT SY-SUBRC IS INITIAL.
    exit.
  ENDIF.


*--- read characteristic master
  CALL FUNCTION 'CTUT_FEATURE_DATA'
       EXPORTING
            FEATURE_NEUTRAL_NAME        = CHARACT
            KEY_DATE                    = '99991231'
       IMPORTING
            ECABN                       = L_CABN
       EXCEPTIONS
            OTHERS                      = 1.

*--- get status if characteristic exists
  CHECK SY-SUBRC IS INITIAL.
  SELECT SINGLE * FROM TCMS
    WHERE ATMST EQ L_CABN-ATMST.

*--- if status contains a profile, check for local change
  CHECK NOT TCMS-AUPRF IS INITIAL.
  CALL FUNCTION 'ALEPDM_GET_FIELD_GROUPS'
       EXPORTING
            BUSINESS_OBJECT                = C_BUS_OBJECT
            PROFILE                        = TCMS-AUPRF
       TABLES
            FIELDGROUP_TAB                 = FIELDGROUP_TAB
       EXCEPTIONS
            NO_GROUPS_FOUND                = 1
            OWN_LOGICAL_SYSTEM_NOT_DEFINED = 2
            OTHERS                         = 3. "#EC EXISTS
  IF SY-SUBRC EQ 2.
    PERFORM DISPLAY_MESSAGE USING SY-MSGID
                                  SY-MSGNO
                                  'E'
                                  SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    F_ERROR = C_MARK.
    EXIT.
  ELSEIF NOT SY-SUBRC IS INITIAL.
    EXIT.
  ENDIF.

*--- check for local change
  READ TABLE FIELDGROUP_TAB INDEX 1.
  IF FIELDGROUP_TAB-FGROU EQ '1'.
    lh_msgv1 = charact.
    PERFORM DISPLAY_MESSAGE USING 'C1'
                                  175
                                  'E'
                                  lh_msgv1 SPACE SPACE SPACE.
    F_ERROR = C_MARK.
    EXIT.
  ENDIF.

ENDFORM.                    " CHK_CHANGE_ALLOWED


*eject
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_MESSAGE
*&---------------------------------------------------------------------*
*                                                                      *
*       Anzeigen einer Nachricht bzw. Absetzen eines
*       Protokolleintrages                                             *
*                                                                      *
*----------------------------------------------------------------------*
*  -->  MESSAGE_ID                 Nachrichten-ID
*  -->  MESSAGE_NR                 Nachrichtennummer
*  -->  MESSAGE_TYPE               Nachrichtenart
*  -->  MTEXT1                     Textvariable 1
*  -->  MTEXT2                     Textvariable 2
*  -->  MTEXT3                     Textvariable 3
*  -->  MTEXT4                     Textvariable 4
*----------------------------------------------------------------------*
FORM DISPLAY_MESSAGE USING MESSAGE_ID   LIKE SY-MSGID
                           MESSAGE_NR   LIKE SY-MSGNO
                           MESSAGE_TYPE LIKE SY-MSGTY
                           MTEXT1       like sy-msgv1
                           MTEXT2       like sy-msgv2
                           MTEXT3       like sy-msgv3
                           MTEXT4       like sy-msgv4.

  DATA:
    MESSAGE LIKE BALMI.                 "structure for message

  MESSAGE-MSGTY = MESSAGE_TYPE.
  MESSAGE-MSGID = MESSAGE_ID.
  MESSAGE-MSGNO = MESSAGE_NR.
  MESSAGE-MSGV1 = mtext1.
  MESSAGE-MSGV2 = mtext2.
  MESSAGE-MSGV3 = mtext3.
  MESSAGE-MSGV4 = mtext4.
  CALL FUNCTION 'STAP_LOG_WRITE_SINGLE_MESSAGE'
       EXPORTING
            MESSAGE                 = MESSAGE
       EXCEPTIONS
            LOG_OBJECT_NOT_FOUND    = 1
            LOG_SUBOBJECT_NOT_FOUND = 2
            OTHERS                  = 3.
  if not sy-subrc is initial.
    clear sy-subrc.
  endif.


ENDFORM.         " DISPLAY_MESSAGE
