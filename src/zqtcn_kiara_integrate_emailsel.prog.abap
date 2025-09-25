*&---------------------------------------------------------------------*
*&  Include           ZQTCR_KIARA_INTEGRATE_EMAILSEL
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_KIARA_INTEGRATE_EMAIL                            *
* PROGRAM DESCRIPTION: This program will trigger an Email when update  *
*                      from KIARA to Acceptance Date in Sales          *
*                      document fails                                  *
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 06/05/2021                                          *
* OBJECT ID      :                                                     *
* TRANSPORT NUMBER(S): ED2K923295                                      *
*----------------------------------------------------------------------*

SELECTION-SCREEN   BEGIN OF BLOCK a1 WITH FRAME TITLE text-001.

  SELECT-OPTIONS : s_exter  FOR balhdr-extnumber,
                   s_date   FOR sy-datum.

SELECTION-SCREEN END OF BLOCK a1.

INITIALIZATION.

  CLEAR: gv_fromdate,
         gv_todate.

  SELECT SINGLE
         lrdat
    FROM zcainterface
    INTO gv_fromdate
   WHERE devid = gc_devid.

  IF sy-subrc IS INITIAL.

    CLEAR gv_todate.

    gv_todate = sy-datum.

    MOVE: gc_i           TO s_date-sign,
          gc_bt          TO s_date-option,
          gv_fromdate    TO s_date-low,
          gv_todate      TO s_date-high.

    APPEND s_date.

  ENDIF.
