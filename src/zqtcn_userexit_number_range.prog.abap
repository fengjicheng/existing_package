*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_NUMBER_RANGE (Include)
*               Called from "USEREXIT_NUMBER_RANGE(RV60AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to determine the
*                      number ranges for the internal document number.
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   03/16/2017
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K903817
*----------------------------------------------------------------------*
 CONSTANTS:
   lc_wricef_id_e155 TYPE zdevid VALUE 'E155', "Constant value for WRICEF (I0230)
   lc_ser_num_e155   TYPE zsno   VALUE '001'.  "Serial Number (001)

 DATA:
lv_actv_flag_e155 TYPE zactive_flag. "Active / Inactive flag

* Check if enhancement needs to be triggered
 CALL FUNCTION 'ZCA_ENH_CONTROL'
   EXPORTING
     im_wricef_id   = lc_wricef_id_e155  "Constant value for WRICEF (C030)
     im_ser_num     = lc_ser_num_e155    "Serial Number (003)
   IMPORTING
     ex_active_flag = lv_actv_flag_e155. "Active / Inactive flag

 IF lv_actv_flag_e155 = abap_true.
* Populate the sequential number range from custom table.
   INCLUDE zqtcn_seq_ran_e155 IF FOUND.
 ENDIF. " IF lv_actv_flag_e155 = abap_true
