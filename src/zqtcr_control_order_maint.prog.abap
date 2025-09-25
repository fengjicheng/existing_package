*&---------------------------------------------------------------------*
*& Report  ZQTCR_CONTROL_ORDER_MAINT_E231
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtcr_control_order_maint NO STANDARD PAGE HEADING.
TABLES:ztest.
DATA:lv_devid TYPE zdevid,
     sel      TYPE char1,
     iv_flg1  TYPE char1,
     iv_flg2  TYPE char1.

CONTROLS:tab_ctrl TYPE TABLEVIEW USING SCREEN 101,
         tc       TYPE TABLEVIEW USING SCREEN 100.
DATA:i_constants TYPE STANDARD TABLE OF ztest.

START-OF-SELECTION.

  SELECT *
    FROM ztest
    INTO TABLE @DATA(li_constants).
*  WHERE devid = @lv_devid+1(9).


  CALL SCREEN '0100'.

END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  DATA:lv_lines TYPE i.
  SET PF-STATUS 'STATUS_0100'.
  DESCRIBE TABLE li_constants LINES lv_lines.
  tc-lines = lv_lines + 10.

  IF sy-ucomm IS INITIAL.
    LOOP AT SCREEN.
      IF screen-name = 'ZTEST-OPTI'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'ZTEST-HIGH'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'ZTEST-SIGN'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'ZTEST-LOW'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'ZTEST-ACTIVATE'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'ZTEST-DESCRIPTION'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'ZTEST-DEVID'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'ZTEST-PARAM1'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'ZTEST-PARAM2'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
      IF screen-name = 'ZTEST-SRNO'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT tc-cols INTO DATA(lst_cols).
      IF lst_cols-screen-input = '1'.
        lst_cols-screen-input = '0'.
      ENDIF.
      MODIFY tc-cols FROM lst_cols INDEX sy-tabix.
    ENDLOOP.
  ENDIF.

ENDMODULE.                 " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK' OR
         'EXIT'  OR
         'CANCEL'.
      SET SCREEN 0. LEAVE SCREEN.

    WHEN 'CHANGE'.
*      LOOP AT li_constants INTO DATA(lst_const).
*        READ TABLE i_constants INTO DATA(lst_constant) WITH KEY devid = lst_const-devid
*                                                               param1 = lst_const-param1
*                                                               param2 = lst_const-param2
*                                                               srno   = lst_const-srno .
*        IF sy-subrc = 0.
*          LOOP AT tc-cols INTO lst_cols WHERE ( index GE 5 AND index LE 10 ).
**            IF lst_cols-screen-input = '0'.
**              lst_cols-screen-input = '1'.
***            ELSE
*            IF lst_cols-screen-input = '1'.
*              lst_cols-screen-input = '0'.
*            ENDIF.
*            MODIFY tc-cols FROM lst_cols INDEX sy-tabix.
*          ENDLOOP.
*        ENDIF.
*      ENDLOOP.
*      FREE:i_con stants.
    WHEN 'DELETE'.
*      IF sy-uname = 'VDPATABALL'.
*        LOOP AT li_constants INTO DATA(lst_const).
*          READ TABLE i_constants INTO DATA(lst_constant) WITH KEY devid = lst_const-devid
*                                                                 param1 = lst_const-param1
*                                                                 param2 = lst_const-param2
*                                                                 srno   = lst_const-srno .
*          IF sy-subrc = 0.
*            DELETE ztest FROM lst_constant.
*
*          ENDIF.
*        ENDLOOP.
*      ELSE.
        IF i_constants IS INITIAL.
          MESSAGE 'Please select the record' TYPE 'I'.
        ENDIF.
        LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<fs_const>).
          READ TABLE i_constants INTO DATA(lst_constant) WITH KEY devid = <fs_const>-devid
                                                                 param1 = <fs_const>-param1
                                                                 param2 = <fs_const>-param2
                                                                 srno   = <fs_const>-srno .
          IF sy-subrc = 0.
            <fs_const>-activate = abap_false.
            <fs_const>-aenam = sy-uname.
            <fs_const>-aedat = sy-datum.
          ENDIF.
        ENDLOOP.
        IF i_constants IS NOT INITIAL.
          MODIFY ztest FROM TABLE li_constants.
          IF sy-subrc = 0.
            MESSAGE 'Flag Removed..!!!' TYPE 'S'.
            FREE:i_constants.
          ELSE.
            MESSAGE 'Flag Not Removed' TYPE 'S'.
          ENDIF.
        ENDIF.
*      ENDIF.

      FREE:sy-ucomm.
    WHEN 'ACTIVE'.
      LOOP AT li_constants ASSIGNING <fs_const>.
        READ TABLE i_constants INTO lst_constant WITH KEY devid = <fs_const>-devid
                                                               param1 = <fs_const>-param1
                                                               param2 = <fs_const>-param2
                                                               srno   = <fs_const>-srno .
        IF sy-subrc = 0.
          <fs_const>-activate = abap_true.
          <fs_const>-aenam = sy-uname.
          <fs_const>-aedat = sy-datum.
        ENDIF.
      ENDLOOP.
      IF i_constants IS INITIAL.
        MESSAGE 'Please select the record' TYPE 'I'.
      ENDIF.
      IF i_constants IS NOT INITIAL.
        MODIFY ztest FROM TABLE li_constants.
        IF sy-subrc = 0.
          MESSAGE 'Flag Activated..!!!' TYPE 'S'.
          FREE:i_constants.
        ELSE.
          MESSAGE 'Flag Not Activated' TYPE 'S'.
        ENDIF.
      ENDIF.
      FREE:sy-ucomm.

    WHEN 'CREATE'.
      FREE:i_constants.
      CALL SCREEN 101.
    WHEN 'SAVE'.
      MODIFY ztest FROM TABLE li_constants.
      IF sy-subrc = 0.
        MESSAGE 'Data Saved..!!!' TYPE 'S'.
      ELSE.
        MESSAGE 'Data not Saved' TYPE 'S'.
      ENDIF.
      FREE:sy-ucomm.
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.
  DATA:lv_count TYPE char10.
  CASE sy-ucomm.
    WHEN 'BACK' OR
            'EXIT'  OR
            'CANCEL'.
      SET SCREEN 0. LEAVE SCREEN.
*      FREE:sy-ucomm.
    WHEN 'SAVE'.
      IF iv_flg1 = abap_false.
        MODIFY ztest FROM TABLE i_constants.
        IF sy-subrc = 0.
          MESSAGE 'Data Saved' TYPE 'S'.
*        DESCRIBE TABLE li_constants LINES lv_count.
          LOOP AT i_constants INTO ztest.
            lv_count = lv_count + 1.
            tc-current_line = lv_count.
            APPEND ztest TO  li_constants.
*          MODIFY li_constants FROM ztest INDEX tc-current_line.
*          INSERT ztest INTO li_constants INDEX tc-current_line."sy-tabix.
          ENDLOOP.
        ELSE.
          MESSAGE 'Data not Saved' TYPE 'S'.
        ENDIF.
      ENDIF.
      FREE:i_constants.
      iv_flg2 = abap_true.
      SET SCREEN 100.
*      CALL SCREEN 100.
*      SET SCREEN 0.
      LEAVE SCREEN.
*      LEAVE SCREEN.
      FREE:sy-ucomm.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  READ_TABLE_CONTROL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE read_table_control INPUT."101 in
*  IF sy-ucomm IS NOT INITIAL.

  READ TABLE i_constants INTO lst_constant WITH KEY devid = ztest-devid
                                                    param1 = ztest-param1
                                                     param2 = ztest-param2
                                                     srno   = ztest-srno .
  IF sy-subrc NE 0.
    IF ztest-devid IS NOT INITIAL.
      SELECT SINGLE *
        FROM ztest
        INTO @DATA(lst_constants_t)
        WHERE devid = @ztest-devid
          AND param1 = @ztest-param1
          AND param2 = @ztest-param2
          AND srno   = @ztest-srno .
      IF sy-subrc = 0.
        iv_flg1 = abap_true.
        MESSAGE 'Data existing' TYPE 'I'.
      ELSE.
        ztest-aenam = sy-uname.
        ztest-aedat = sy-datum.
        APPEND ztest TO i_constants.
      ENDIF.
    ENDIF.
  ELSE.
    iv_flg1 = abap_true.
    MESSAGE 'Duplicate Key not allowed' TYPE 'I'.
    EXIT.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0101  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0101 OUTPUT.

  SET PF-STATUS 'STATUS_101'.

*---set the no.of lines of the tabe control
  DESCRIBE TABLE i_constants LINES lv_count.
  tab_ctrl-lines = lv_count.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_TABLE_CONTROL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_table_control INPUT.
  MODIFY li_constants FROM ztest INDEX tc-current_line.
  READ TABLE li_constants INTO DATA(lst_constants) INDEX tc-current_line.
  IF sel IS NOT INITIAL.
    APPEND lst_constants TO i_constants.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen OUTPUT.
  IF iv_flg2 = abap_false OR sy-ucomm = 'CHANGE'.
    READ TABLE i_constants INTO lst_constants  WITH KEY devid = ztest-devid
                                                        param1 = ztest-param1
                                                        param2 = ztest-param2
                                                        srno   = ztest-srno .
    IF sy-subrc = 0.
      LOOP AT SCREEN.
        IF screen-name = 'ZTEST-OPTI'.
          screen-input = 1.
          MODIFY SCREEN.
        ENDIF.
        IF screen-name = 'ZTEST-HIGH'.
          screen-input = 1.
          MODIFY SCREEN.
        ENDIF.
        IF screen-name = 'ZTEST-SIGN'.
          screen-input = 1.
          MODIFY SCREEN.
        ENDIF.
        IF screen-name = 'ZTEST-LOW'.
          screen-input = 1.
          MODIFY SCREEN.
        ENDIF.
        IF screen-name = 'ZTEST-ACTIVATE'.
          screen-input = 1.
          MODIFY SCREEN.
        ENDIF.
        IF screen-name = 'ZTEST-DESCRIPTION'.
          screen-input = 1.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  FREE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE free INPUT.
  FREE:i_constants.
ENDMODULE.
