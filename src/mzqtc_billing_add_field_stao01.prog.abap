*----------------------------------------------------------------------*
* PROGRAM NAME:MZQTC_BILLING_ADD_FIELD_STAO01
* PROGRAM DESCRIPTION:PBO include .
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-10-02
* OBJECT ID:E070
* TRANSPORT NUMBER(S):ED2K903028
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9001 OUTPUT.


  IF sy-tcode = c_vf01
    OR sy-tcode = c_vf02
    OR sy-tcode = c_vf03.
    LOOP AT SCREEN.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDLOOP. " LOOP AT SCREEN
  ENDIF.
ENDMODULE.
