*&---------------------------------------------------------------------*
*&  Include           ZQTCN_USEREXIT_XVBAP_FOR_DELET
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_XVBAP_FOR_DELET
* PROGRAM DESCRIPTION: Disable Deleting Items in Contracts and Orders
* in change transaction. ( VA42 OR VA02).
* DEVELOPER: Sunil Kairamkonda (SKKAIRAMKO)
* CREATION DATE:   1/16/2019
* OBJECT ID: CR#7810 / E188
* TRANSPORT NUMBER(S) ED2K914228
*----------------------------------------------------------------------*
CONSTANTS:
    lc_devid_e188     TYPE zdevid     VALUE 'E188',
    lc_change         TYPE c          VALUE 'V',
    lc_sno_001        TYPE zsno       VALUE '001'.  "Serial Number.

DATA: lv_actv_flag_e188 TYPE c.

*--------------------------------------------------------------------*

  IF t180-trtyp EQ lc_change. " change

*-- To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_devid_e188    "E188
      im_ser_num     = lc_sno_001      "001
    IMPORTING
      ex_active_flag = lv_actv_flag_e188.

  IF lv_actv_flag_e188 EQ abap_true.
    INCLUDE zqtcn_check_item_delet_xvbap.
   ENDIF.
 ENDIF.
