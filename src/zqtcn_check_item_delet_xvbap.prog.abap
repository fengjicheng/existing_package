*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CHECK_ITEM_DELET_XVBAP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_CHECK_ITEM_DELET_XVBAP
* PROGRAM DESCRIPTION: Disable Deleting Items in Contracts and Orders
* in change transaction. ( VA42 OR VA02).
* DEVELOPER: Sunil Kairamkonda (SKKAIRAMKO)
* CREATION DATE:   1/16/2019
* OBJECT ID: CR#7810 / E188
* TRANSPORT NUMBER(S) ED2K914228
*----------------------------------------------------------------------*
* PROGRAM DESCRIPTION: Disable Deleting Items in Contracts and Orders
* in change transaction. ( VA42 OR VA02) at item level
* DEVELOPER: Bharani
* CREATION DATE:   2/14/2022 - Valantines Day
* OBJECT ID: PRB0048004
* TRANSPORT NUMBER(S) ED1K914089
*----------------------------------------------------------------------*

CONSTANTS:
    lc_param1     TYPE rvari_vnam VALUE 'AUART'.

 STATICS li_constant TYPE TABLE OF zcaconstant.
*--------------------------------------------------------------------*

  IF li_constant IS INITIAL.
   SELECT *
      FROM zcaconstant
      INTO TABLE li_constant
     WHERE devid    EQ lc_devid_e188  AND       "Development ID: E188
           param1   EQ lc_param1      AND
           activate EQ abap_true.

   ENDIF.

*    IF line_exists( li_constant[ low = xvbak-auart ] ). "ED1K914089
    IF line_exists( li_constant[ low = vbak-auart ] ).   "ED1K914089
      IF us_error NE space.
          MESSAGE s523(zqtc_r2) DISPLAY LIKE 'E'.
        ENDIF.
         us_exit = abap_true.
    ENDIF.
