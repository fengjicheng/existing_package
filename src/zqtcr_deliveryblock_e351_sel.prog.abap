*&---------------------------------------------------------------------*
*&  Include           ZQTCR_DELIVERYBLOCK_E351_SEL
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_DELIVERYBLOCK_SALES_E351                         *
* PROGRAM DESCRIPTION: The functionality of the program is to confirm  *
*       if the payment confirmation has been successfully received from*
*       bank or not. If there is some issue with the payment clearance *
*       then for the ZSUB/ZREW order, the delivery block will be       *
*       updated to 66-Return Direct Debit from DD -Direct Debits Order.*
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 02/09/2022                                          *
* OBJECT ID      : E351                                                *
* TRANSPORT NUMBER(S):  ED2K925720                                     *
*----------------------------------------------------------------------*
TABLES: vbrk.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
    SELECT-OPTIONS: s_date FOR sy-datum OBLIGATORY.
    SELECT-OPTIONS: s_invice FOR vbrk-vbeln.
  SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.

  DATA: lv_start TYPE sy-datum.

  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date            = sy-datum
      days            = '7'
      months          = '00'
      signum          = '-'
      years           = '00'
   IMPORTING
     CALC_DATE       = lv_start.

    IF sy-subrc IS INITIAL.
      s_date-sign    = 'I'.
      s_date-option  = 'BT'.
      s_date-low     = lv_start.
      s_date-high    = sy-datum.
      APPEND s_date.
    ENDIF.
