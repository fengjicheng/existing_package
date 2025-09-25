*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU16 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for Additional values in Outbound IDOC
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   30/08/2017
* OBJECT ID: I0229
* TRANSPORT NUMBER(S):  ED2K908278, ED2K908389
*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU16 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include to modify the internal tables based on
*                      confirmed quantity which are using for IDoc
*                      segments
* DEVELOPER: Jagadeeswara Rao M (JMADAKA)
* CREATION DATE:   04/21/2022
* OBJECT ID: EAM-6881/I0511
* TRANSPORT NUMBER(S):  ED2K926811
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_wricef_id_i0229 TYPE zdevid VALUE 'I0229', "Constant value for WRICEF (I0229)
    lc_ser_num_i0229_1 TYPE zsno   VALUE '001'.   "Serial Number (001)

  DATA:
    lv_var_key_i0229   TYPE zvar_key,             "Variable Key
    lv_actv_flag_i0229 TYPE zactive_flag.         "Active / Inactive flag

* Populate Variable Key
  CONCATENATE dcontrol_record_out-mestyp           "Message Type
              dcontrol_record_out-mescod           "Message Function
         INTO lv_var_key_i0229.

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0229         "Constant value for WRICEF (I0229)
      im_ser_num     = lc_ser_num_i0229_1         "Serial Number (001)
      im_var_key     = lv_var_key_i0229           "Variable Key (Message Type + Message Function)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0229.        "Active / Inactive flag

  IF lv_actv_flag_i0229 = abap_true.
    INCLUDE zqtcn_missing_fields_sub_ord IF FOUND.
  ENDIF. " IF lv_actv_flag_i0229 = abap_true


* BOC by JMADAKA on 04/21/2022 for EAM-6881/I0511 with ED2K926811*
  CONSTANTS: lc_wricef_id_i0511 TYPE zdevid VALUE 'I0511.1', "Constant value for WRICEF (I0511)
             lc_ser_num_i0511_1 TYPE zsno   VALUE '001'.     " Sequence Number (001)

  DATA: lv_var_key_i0511_1   TYPE zvar_key,      " Variable Key
        lv_ser_num_i0511_1   TYPE zsno,          " Serial Number
        lv_actv_flag_i0511_1 TYPE zactive_flag.  " Active / Inactive flag

  CONCATENATE dcontrol_record_out-mestyp   " Message Type
              dcontrol_record_out-mescod   " Message Variant
              dcontrol_record_out-mesfct   " Message Function
  INTO lv_var_key_i0511_1.

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0511       " Constant value for WRICEF (I0511)
      im_ser_num     = lc_ser_num_i0511_1       " Serial Number (001)
      im_var_key     = lv_var_key_i0511_1       " Variable Key (Message Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0511_1.    "Active / Inactive flag
  IF lv_actv_flag_i0511_1 = abap_true.
    INCLUDE zqtcn_modify_data_ukcore_i0511 IF FOUND.
  ENDIF.
* EOC by JMADAKA on 04/21/2022 for EAM-6881/I0511 with ED2K926811*
