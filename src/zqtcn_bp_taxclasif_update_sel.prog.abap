*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BP_UPDATE_FROM_FILE_SEL
*&---------------------------------------------------------------------*
TABLES: ADR6.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
  PARAMETERS: rb_back RADIOBUTTON GROUP grp1 USER-COMMAND bck DEFAULT 'X'.
  PARAMETERS: rb_frnt RADIOBUTTON GROUP grp1 .
  PARAMETERS: p_file  TYPE rlgrap-filename NO-DISPLAY MODIF ID 001 .
  PARAMETERS: p_file1 TYPE rlgrap-filename MODIF ID 002.
  SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
  SELECT-OPTIONS: s_email FOR adr6-smtp_addr NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b3.

INITIALIZATION.
"Default Email ID Distribution.
  "Fetching Entries from Constant Table
  SELECT devid,
         param1,
         param2,
         srno,
         sign,
         opti,
         low
    FROM zcaconstant
    INTO TABLE @DATA(lt_constant)
   WHERE devid    EQ @c_devid
   AND   activate EQ @abap_true.

  IF  sy-subrc    IS INITIAL
                  AND lt_constant IS NOT INITIAL.
    CLEAR gv_user.
    LOOP AT lt_constant
      INTO DATA(lst_constant).
      CASE: lst_constant-param1.
        WHEN: c_email.
          s_email-sign    = lst_constant-sign.
          s_email-option  = lst_constant-opti.
          s_email-low     = lst_constant-low.
          APPEND s_email.
        WHEN: c_file.
          p_file = lst_constant-low.
        WHEN: c_user.
          gv_user = lst_constant-low.
        WHEN: OTHERS.
          "Do Nothing.
      ENDCASE.
    ENDLOOP.
  ENDIF.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF rb_frnt EQ abap_true AND screen-group1 EQ '001'.
      screen-invisible = 1.
      screen-active = 0.
      MODIFY SCREEN.
    ELSEIF rb_back EQ abap_true AND screen-group1 EQ '002'.
      screen-invisible = 1.
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
