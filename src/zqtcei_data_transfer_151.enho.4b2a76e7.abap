"Name: \PR:SAPFV45C\EX:DATEN_KOPIEREN_151_10\EI
ENHANCEMENT 0 ZQTCEI_DATA_TRANSFER_151.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_DATA_TRANSFER_151 (Implicit Enhancement)
* PROGRAM DESCRIPTION: Copy Subscription Type
* DEVELOPER: Monalisa Dutta (MODUTTA)
* CREATION DATE:   06-JUN-2018
* OBJECT ID: E096 (INC0197849)
* TRANSPORT NUMBER(S): ED1K907602
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K920664
* REFERENCE NO: OTCM-29848
* DEVELOPER:    AMOHAMMED
* DATE:         12-04-2020
* DESCRIPTION:  The below enhancement was part of E096( serial # 001 )
*               Now moved as part of E070( serial # 011 )
*----------------------------------------------------------------------*
  CONSTANTS:
* Begin by AMOHAMMED on 04/12/2020 TR # ED2K920664
*    lc_wricef_id_e096 TYPE zdevid   VALUE 'E096',  " Development ID
*    lc_ser_num_1_e096 TYPE zsno     VALUE '001'.   " Serial Number
*
*  DATA:
*    lv_actv_flag_e096 TYPE zactive_flag.           " Active / Inactive Flag
    lc_wricef_id_e070  TYPE zdevid   VALUE 'E070',  " Development ID
    lc_ser_num_11_e070 TYPE zsno     VALUE '011'.   " Serial Number

  DATA: lv_actv_flag_e070 TYPE zactive_flag.        " Active / Inactive Flag
* End by AMOHAMMED on 04/12/2020 TR # ED2K920664

*   To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e070  " lc_wricef_id_e096 " by AMOHAMMED on 04/12/2020 TR # ED2K920664
      im_ser_num     = lc_ser_num_11_e070  " lc_ser_num_1_e096 " by AMOHAMMED on 04/12/2020 TR # ED2K920664
    IMPORTING
      ex_active_flag = lv_actv_flag_e070. " lv_actv_flag_e096. " by AMOHAMMED on 04/12/2020 TR # ED2K920664

*  IF lv_actv_flag_e096 EQ abap_true. " by AMOHAMMED on 04/12/2020 TR # ED2K920664
  IF lv_actv_flag_e070 EQ abap_true.
    INCLUDE zqtcn_data_transfer_151 IF FOUND.
  ENDIF.
ENDENHANCEMENT.
