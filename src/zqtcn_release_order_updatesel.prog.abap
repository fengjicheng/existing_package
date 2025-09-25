*&---------------------------------------------------------------------*
*&  Include           ZQTCR_RELEASE_ORDER_UPDATESEL
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_RELEASE_ORDER_UPDATE                             *
* PROGRAM DESCRIPTION: This program will update the Reject Reason      *
*                      for release orders of Credit Memo for which     *
*                      reason for rejection is updated                 *
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 04/05/2021                                          *
* OBJECT ID      : E267                                                *
* TRANSPORT NUMBER(S): ED2K923233                                      *
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS : s_vbeln FOR vbak-vbeln,
                 s_date  FOR sy-datum.
SELECTION-SCREEN END OF BLOCK b1.
*----------------------------------------------------------------------*
* INITIALIZATION                                                       *
*----------------------------------------------------------------------*

INITIALIZATION.
  SELECT SINGLE
         lrdat
    FROM zcainterface
    INTO @DATA(lv_date)
   WHERE devid = @gc_devid.
  IF  sy-subrc IS INITIAL
  AND lv_date  IS NOT INITIAL.
    MOVE: gc_i      TO s_date-sign,
          gc_bt     TO s_date-option,
          lv_date   TO s_date-low,
          sy-datum  TO s_date-high.
    APPEND s_date.
  ENDIF.
