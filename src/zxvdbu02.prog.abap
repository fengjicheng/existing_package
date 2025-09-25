
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVDBU02 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for populating BDC DATA
*
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   18/10/2016
* OBJECT ID: I0238
* TRANSPORT NUMBER(S):  ED2K903103
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K916358
* REFERENCE NO:  I0230.20
* DEVELOPER:     NPOLINA (Nageswara)
* DATE:          2019-10-03
* DESCRIPTION:   ZACO Order Change with Message Variant Z22 (Moodle Inbound).
*-------------------------------------------------------------------
***------Enhancement Stub Code for I0238>>>>>>>>>>>>>
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K916358
* REFERENCE NO:  OTCM-28269
* WRICEF ID  :   I0395.1
* DEVELOPER:     Lahiru Wathudura (LWATHUDURA)
* DATE:          01/14/2021
* DESCRIPTION:  Change Order cancellation Process
*-------------------------------------------------------------------
 CONSTANTS:
   lc_wricef_id_i0238 TYPE zdevid VALUE 'I0238', "Constant value for WRICEF (C030)
   lc_ser_num_i0238_2 TYPE zsno   VALUE '002'.   "Serial Number (003)

 DATA:
   lv_var_key_i0238   TYPE zvar_key,     "Variable Key
   lv_actv_flag_i0238 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
 lv_var_key_i0238 = dxmescod. "Message Code

* Check if enhancement needs to be triggered
 CALL FUNCTION 'ZCA_ENH_CONTROL'
   EXPORTING
     im_wricef_id   = lc_wricef_id_i0238  "Constant value for WRICEF (C030)
     im_ser_num     = lc_ser_num_i0238_2  "Serial Number (003)
     im_var_key     = lv_var_key_i0238    "Variable Key (Message Type)
   IMPORTING
     ex_active_flag = lv_actv_flag_i0238. "Active / Inactive flag

 IF lv_actv_flag_i0238 = abap_true.

   INCLUDE zqtcn_insub_bdc_i0238 IF FOUND.

 ENDIF. " IF lv_actv_flag_i0230 = abap_true
***<<<<<< for I0238 ---------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVDBU02 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for populating BDC DATA
*
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   24/10/2016
* OBJECT ID: I0233.2
* TRANSPORT NUMBER(S):  ED2K903117
*----------------------------------------------------------------------*
***------Enhancement Stub Code for I0233.2>>>>>>>>>>>>>
 CONSTANTS:
   lc_wricef_id_i0233_2_a TYPE zdevid VALUE 'I0233.2', "Constant value for WRICEF (C030)
   lc_ser_num_i0233_2_4   TYPE zsno   VALUE '004'.   "Serial Number (003)

 DATA:
   lv_var_key_i0233_2_a   TYPE zvar_key,     "Variable Key
   lv_actv_flag_i0233_2_a TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
 lv_var_key_i0233_2_a = dxmescod. "Message Code

* Check if enhancement needs to be triggered
 CALL FUNCTION 'ZCA_ENH_CONTROL'
   EXPORTING
     im_wricef_id   = lc_wricef_id_i0233_2_a  "Constant value for WRICEF (C030)
     im_ser_num     = lc_ser_num_i0233_2_4  "Serial Number (003)
     im_var_key     = lv_var_key_i0233_2_a    "Variable Key (Message Type)
   IMPORTING
     ex_active_flag = lv_actv_flag_i0233_2_a. "Active / Inactive flag

 IF lv_actv_flag_i0233_2_a = abap_true.

   INCLUDE zqtcn_insub_bdc_i0233_2 IF FOUND.

 ENDIF. " IF lv_actv_flag_i0230 = abap_true
****<<<<<< for I0233.2 ---------------

* SOC by NPOLINA I0230.20 03/Oct/2019  ED2K916358
* IDOC with Message Variant Z20 , Order Type ZACO
 CONSTANTS:
   lc_wricef_id_z22 TYPE zdevid VALUE 'I0230.20', "Constant value for WRICEF (I0230.20)
   lc_ser_num_z22   TYPE zsno   VALUE '001'. "Serial Number (001)

 DATA:
   lv_var_key_z22   TYPE zvar_key,     "Variable Key
   lv_ser_num_z22   TYPE zsno,         " Serial Number
   lv_actv_flag_z22 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
 lv_var_key_z22 = dxmescod. "Message Code Z6

 CALL FUNCTION 'ZCA_ENH_CONTROL'
   EXPORTING
     im_wricef_id   = lc_wricef_id_z22  "Constant value for WRICEF (I0230.20)
     im_ser_num     = lc_ser_num_z22    "Serial Number (001)
     im_var_key     = lv_var_key_z22    "Variable Key (Message Type)
   IMPORTING
     ex_active_flag = lv_actv_flag_z22. "Active / Inactive flag
 IF lv_actv_flag_z22 = abap_true .
   INCLUDE zqtcn_inbound_bdc_i0230_20 IF FOUND.
 ENDIF.
* EOC by NPOLINA I0230.20 03/Oct/2019  ED2K916358

* BOC by Lahiru on 01/14/2021 for OTCM-OTCM-28269 with ED2K921221*
* IDOC with Message Variant ---- ,
 CONSTANTS:
   lc_wricef_id_z27_i0395_1 TYPE zdevid VALUE 'I0395.1',   " Constant value for WRICEF (I0395.1)
   lc_ser_num_z27_i0395_1   TYPE zsno   VALUE '001'.       " Serial Number (001)

 DATA:
   lv_var_key_z27_i0395_1   TYPE zvar_key,      " Variable Key
   lv_ser_num_z27_i0395_1   TYPE zsno,          " Serial Number
   lv_actv_flag_z27_i0395_1 TYPE zactive_flag.  " Active / Inactive flag

* Populate Variable Key

 lv_var_key_z27_i0395_1 = dxmescod. " Message Code Z27

 CALL FUNCTION 'ZCA_ENH_CONTROL'
   EXPORTING
     im_wricef_id   = lc_wricef_id_z27_i0395_1       " Constant value for WRICEF (I0395.1)
     im_ser_num     = lc_ser_num_z27_i0395_1         " Serial Number (001)
     im_var_key     = lv_var_key_z27_i0395_1         " Variable Key (Message Type)
   IMPORTING
     ex_active_flag = lv_actv_flag_z27_i0395_1.      "Active / Inactive flag
 IF lv_actv_flag_z27_i0395_1 = abap_true .
   INCLUDE zqtcn_inbound_bdc_i0395_1 IF FOUND.
 ENDIF.
* EOC by Lahiru on 01/14/2021 for OTCM-OTCM-28269 with ED2K921221*
