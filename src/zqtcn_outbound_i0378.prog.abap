*&---------------------------------------------------------------------*
*&  Include           ZQTCN_OUTBOUND_I0378
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Segment population in
* Outbound IDOC
* DEVELOPER: KKRAVURI (Kiran Kumar Ravuri)
* CREATION DATE: 07/05/2020
* OBJECT ID: ERPM-197
* TRANSPORT NUMBER(S): ED2K918118
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*

* Local Constans
CONSTANTS:
  lc_we_i0378      TYPE char2  VALUE 'WE',       " Partner Function: WE (Ship-to)
  lc_e1edpa1_i0378 TYPE char7  VALUE 'E1EDPA1',  " Segment: E1EDPA1
  lc_e1edka1_i0378 TYPE char7  VALUE 'E1EDKA1'.  " Segment: E1EDKA1

* Local Data declarations
DATA:
  lst_e1edpa1_i0378 TYPE e1edpa1,          " Segment: E1EDPA1
  lst_e1edka1_i0378 TYPE e1edka1.          " Segment: E1EDKA1



*** Checking segments and implementing required logic
CASE int_edidd-segnam.

*** BOC: ERPM-197
*** Update IHREZ field in E1EDKA1 & E1EDPA1 segments
  WHEN lc_e1edka1_i0378.
    lst_e1edka1_i0378 = int_edidd-sdata.
    IF lst_e1edka1_i0378-parvw = lc_we_i0378.
      lst_e1edka1_i0378-ihrez = dxvbkd[ 1 ]-ihrez_e.
      int_edidd-sdata = lst_e1edka1_i0378.
      MODIFY int_edidd.
    ENDIF.
    CLEAR lst_e1edka1_i0378.

  WHEN lc_e1edpa1_i0378.
    lst_e1edpa1_i0378 = int_edidd-sdata.
    IF lst_e1edpa1_i0378-parvw = lc_we_i0378.
      " DXVBAP[] contains corresponding item value in it's header
      " in standard, so we have used dxvbap
      READ TABLE dxvbkd INTO DATA(lst_dxvbkd) WITH KEY vbeln = dxvbap-vbeln
                                                       posnr = dxvbap-posnr.
      IF sy-subrc = 0.
        lst_e1edpa1_i0378-ihrez = lst_dxvbkd-ihrez_e.
        int_edidd-sdata = lst_e1edpa1_i0378.
        MODIFY int_edidd.
      ENDIF.
    ENDIF.
    CLEAR: lst_e1edpa1_i0378, lst_dxvbkd.
*** EOC: ERPM-197

  WHEN OTHERS.
    " Nothing to do


ENDCASE. " CASE int_edidd-segnam.
