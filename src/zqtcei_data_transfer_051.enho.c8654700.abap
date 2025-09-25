"Name: \PR:SAPFV45C\EX:DATEN_KOPIEREN_051_01\EI
ENHANCEMENT 0 ZQTCEI_DATA_TRANSFER_051.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_DATA_TRANSFER_051 (Implicit Enhancement)
* PROGRAM DESCRIPTION: Copy Sales Office
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   02-JUN-2017
* OBJECT ID: E096 (CR# 546)
* TRANSPORT NUMBER(S): ED2K906483
*----------------------------------------------------------------------*
* REVISION NO: ED2K915483                                              *
* REFERENCE NO: DM1913                                                 *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  01-July-2019                                                  *
* DESCRIPTION:Order Reason A10 transfer /update                        *
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_e096 TYPE zdevid   VALUE 'E096',  " Development ID
    lc_ser_num_1_e096 TYPE zsno     VALUE '001',   " Serial Number
    lc_wricef_id_e209 TYPE zdevid   VALUE 'E209',  " Development ID
    lc_ser_num_1_e209 TYPE zsno     VALUE '001'.   " Serial Number

  DATA:
    lv_actv_flag_e096 TYPE zactive_flag,           " Active / Inactive Flag
    lv_actv_flag_e209 TYPE zactive_flag.           " Active / Inactive Flag

*   To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e096
      im_ser_num     = lc_ser_num_1_e096
    IMPORTING
      ex_active_flag = lv_actv_flag_e096.

  IF lv_actv_flag_e096 EQ abap_true.
    INCLUDE zqtcn_data_transfer_051 IF FOUND.
  ENDIF.
* SOC by NPOLINA DM1913 ED2K915483
   CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e209
      im_ser_num     = lc_ser_num_1_e209
    IMPORTING
      ex_active_flag = lv_actv_flag_e209.

  IF lv_actv_flag_e209 EQ abap_true.
    INCLUDE zqtcn_transfer_reason_051 IF FOUND.
  ENDIF.
* EOC by NPOLINA DM1913 ED2K915483
ENDENHANCEMENT.
