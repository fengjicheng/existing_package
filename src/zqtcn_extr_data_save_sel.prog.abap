*&---------------------------------------------------------------------*
*&  Include           ZQTCN_EXTR_DATA_SAVE_SEL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZQTCR_EXTR_DATA_SAVE
*&*----------------------------------------------------------------------*
*& PROGRAM NAME:        ZQTCR_EXTR_DATA_SAVE
*& PROGRAM DESCRIPTION: Program to update Custom table from extractor data
*& DEVELOPER:           Krishna & Rajkumar Madavoina
*& CREATION DATE:       04/20/2021
*& OBJECT ID:
*& TRANSPORT NUMBER(S): ED2K923107
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

*--------------------------------------------------------------------*
*--                       SELECTION SCREEN                         --*
*--------------------------------------------------------------------*
SELECTION-SCREEN   BEGIN OF BLOCK a1 WITH FRAME TITLE text-001.
SELECT-OPTIONS : s_date  FOR sy-datum OBLIGATORY.
SELECTION-SCREEN END OF BLOCK a1.
*SELECTION-SCREEN   BEGIN OF BLOCK a2 WITH FRAME TITLE text-002.
*PARAMETERS: p_dl AS CHECKBOX USER-COMMAND abc,
*            p_layout TYPE disvariant-variant.
*SELECTION-SCREEN END OF BLOCK a2.

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
