
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVDBU01 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Sales Order Determination through
*                      legacy order numnber customer , material conversion
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
* DESCRIPTION:   ZACO Order Change with Message Variant Z22.(Moodle I/B)
*-------------------------------------------------------------------
*** Enhancement Stub Code for I0238------------>>>>>>>>
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K921221
* REFERENCE NO:  I0395.1
* DEVELOPER:     Lahiru Wathudura (LWATHUDURA)
* DATE:          01/14/2021
* DESCRIPTION:  Change Order cancellation Process
*-------------------------------------------------------------------

CONSTANTS:
  lc_wricef_id_i0238 TYPE zdevid VALUE 'I0238', "Constant value for WRICEF (I0230)
  lc_ser_num_i0238_1 TYPE zsno   VALUE '001'.   "Serial Number (001)

DATA:
  lv_var_key_i0238   TYPE zvar_key,     "Variable Key
  lv_actv_flag_i0238 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
lv_var_key_i0238 = contrl-mestyp. "Message Type

CONCATENATE lv_var_key_i0238
            contrl-mescod
INTO lv_var_key_i0238.

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0238
    im_ser_num     = lc_ser_num_i0238_1
    im_var_key     = lv_var_key_i0238
  IMPORTING
    ex_active_flag = lv_actv_flag_i0238.

IF lv_actv_flag_i0238 = abap_true.

  INCLUDE zqtcn_insub_i0238 IF FOUND.

ENDIF. " IF lv_actv_flag_i0238 = abap_true

***<<< For I0238---------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVDBU01 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for order determination through year of contract start
*                      date and material, customer conversion for Partner address change
*                      also inserting Sales Area information in DXVBAK structure
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   24/10/2016
* OBJECT ID: I0233.2
* TRANSPORT NUMBER(S):  ED2K903117
*----------------------------------------------------------------------*

*** Enhancement Stub Code for I0233.2------------>>>>>>>>
CONSTANTS:
  lc_wricef_id_i0233_2 TYPE zdevid VALUE 'I0233.2', "Constant value for WRICEF (I0230)
  lc_ser_num_i0233_2_3 TYPE zsno   VALUE '003'.   "Serial Number (001)

DATA:
  lv_var_key_i0233_2   TYPE zvar_key,     "Variable Key
  lv_actv_flag_i0233_2 TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
lv_var_key_i0233_2 = contrl-mestyp. "Message Type

CONCATENATE lv_var_key_i0233_2
            contrl-mescod
            contrl-mesfct
INTO lv_var_key_i0233_2.

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0233_2
    im_ser_num     = lc_ser_num_i0233_2_3
    im_var_key     = lv_var_key_i0233_2
  IMPORTING
    ex_active_flag = lv_actv_flag_i0233_2.

IF lv_actv_flag_i0233_2 = abap_true.

  INCLUDE zqtcn_insub_i0233_2 IF FOUND.

ENDIF. " IF lv_actv_flag_i0238 = abap_true
***<<< For I0233.2---------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVDBU01 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for order determination through year of
*                      contract start date  and material,customer conversion
*                       for termination related changes
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   24/10/2016
* OBJECT ID: I0233.2
* TRANSPORT NUMBER(S):  ED2K903117
*----------------------------------------------------------------------*

*** Enhancement Stub Code for I0233.2------------>>>>>>>>
CONSTANTS:
  lc_wricef_id_i0233_2_r TYPE zdevid VALUE 'I0233.2', "Constant value for WRICEF (I0230)
  lc_ser_num_i0233_2_5   TYPE zsno   VALUE '005'.   "Serial Number (001)

DATA:
  lv_var_key_i0233_2_r   TYPE zvar_key,     "Variable Key
  lv_actv_flag_i0233_2_r TYPE zactive_flag. "Active / Inactive flag

* Populate Variable Key
lv_var_key_i0233_2_r = contrl-mestyp. "Message Type

CONCATENATE lv_var_key_i0233_2_r
            contrl-mescod
            contrl-mesfct
INTO lv_var_key_i0233_2_r.

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0233_2_r
    im_ser_num     = lc_ser_num_i0233_2_5
    im_var_key     = lv_var_key_i0233_2_r
  IMPORTING
    ex_active_flag = lv_actv_flag_i0233_2_r.

IF lv_actv_flag_i0233_2_r = abap_true.

  INCLUDE zqtcn_insub_i0233_2_reason IF FOUND.

ENDIF. " IF lv_actv_flag_i0238 = abap_true
***<<< For I0233.2---------------------------------------

* SOC by NPOLINA I0230.20 03/Oct/2019  ED2K916358
* Check for IDOC with Message Variant Z22 , Order Type ZACO
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
  INCLUDE zqtcn_inbound_bdc_i0230_20_1 IF FOUND.
ENDIF.
* EOC by NPOLINA I0230.20 03/Oct/2019  ED2K916358

* BOC by Lahiru on 01/14/2021 for OTCM-OTCM-28269 with ED2K921221*
* IDOC with Message Variant ---- ,
CONSTANTS:
  lc_wricef_id_i0395_1 TYPE zdevid VALUE 'I0395.1',   " Constant value for WRICEF (I0395.1)
  lc_ser_num_i0395_1   TYPE zsno   VALUE '001'.       " Serial Number (001)

DATA:
  lv_var_key_i0395_1   TYPE zvar_key,      " Variable Key
  lv_ser_num_i0395_1   TYPE zsno,          " Serial Number
  lv_actv_flag_i0395_1 TYPE zactive_flag.  " Active / Inactive flag

* Populate Variable Key
lv_var_key_i0395_1 = dxmescod. " Message Code Z27

CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0395_1       " Constant value for WRICEF (I0395.1)
    im_ser_num     = lc_ser_num_i0395_1         " Serial Number (001)
    im_var_key     = lv_var_key_i0395_1         " Variable Key (Message Type)
  IMPORTING
    ex_active_flag = lv_actv_flag_i0395_1.      "Active / Inactive flag
IF lv_actv_flag_i0395_1 = abap_true .
  INCLUDE zqtcn_itab_fill_i0395_1 IF FOUND.
ENDIF.
* EOC by Lahiru on 01/14/2021 for OTCM-OTCM-28269 with ED2K921221*
