class ZQTCCL_CUSTOMER_ADD_DATA_CS definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_CUSTOMER_ADD_DATA_CS .

  constants C_FCODE_Z1CUS01 type FCODE value 'Z1CUS01' ##NO_TEXT.
  constants C_FCODE_Z1CUS02 type FCODE value 'Z1CUS02' ##NO_TEXT.
  constants C_SCREEN_9001 type DYNNR value '9001' ##NO_TEXT.
  constants C_SCREEN_9002 type DYNNR value '9002' ##NO_TEXT.
  constants C_SCREEN_PROG type REPID value 'SAPLZQTC_BP_CUSTOM_FIELDS' ##NO_TEXT.
protected section.
private section.
ENDCLASS.



CLASS ZQTCCL_CUSTOMER_ADD_DATA_CS IMPLEMENTATION.


  METHOD if_ex_customer_add_data_cs~get_data.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCBI_CUSTOMER_ADD_DATA_CS~GET_DATA
*               (BADI Implementation / Method)
* PROGRAM DESCRIPTION: BP Custom Fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/29/2016
* OBJECT ID: E036
* TRANSPORT NUMBER(S): ED2K903005
*----------------------------------------------------------------------*
    CONSTANTS:
      lc_wricef_id_e036 TYPE zdevid VALUE 'E036',          "Constant value for WRICEF (E036)
      lc_ser_num_e036_1 TYPE zsno   VALUE '001'.           "Serial Number (001)

    DATA:
      lv_var_key_e036   TYPE zvar_key,                     "Variable Key
      lv_actv_flag_e036 TYPE zactive_flag.                 "Active / Inactive flag

*   Populate Variable Key
    lv_var_key_e036 = flt_val.                             "Filter Value

*   Check if enhancement needs to be triggered
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e036                 "Constant value for WRICEF (E036)
        im_ser_num     = lc_ser_num_e036_1                 "Serial Number (001)
        im_var_key     = lv_var_key_e036                   "Variable Key (Screen Group)
      IMPORTING
        ex_active_flag = lv_actv_flag_e036.                "Active / Inactive flag
    IF lv_actv_flag_e036 = abap_true.
      INCLUDE zqtcn_customer_add_data_cs_04 IF FOUND.
    ENDIF.
  ENDMETHOD.


  method IF_EX_CUSTOMER_ADD_DATA_CS~GET_FIELDNAME_FOR_CHANGEDOC.
  endmethod.


  METHOD if_ex_customer_add_data_cs~get_taxi_screen.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCBI_CUSTOMER_ADD_DATA_CS~GET_TAXI_SCREEN
*               (BADI Implementation / Method)
* PROGRAM DESCRIPTION: BP Custom Fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/29/2016
* OBJECT ID: E036
* TRANSPORT NUMBER(S): ED2K903005
*----------------------------------------------------------------------*
    CONSTANTS:
      lc_wricef_id_e036 TYPE zdevid VALUE 'E036',          "Constant value for WRICEF (E036)
      lc_ser_num_e036_1 TYPE zsno   VALUE '001'.           "Serial Number (001)

    DATA:
      lv_var_key_e036   TYPE zvar_key,                     "Variable Key
      lv_actv_flag_e036 TYPE zactive_flag.                 "Active / Inactive flag

*   Populate Variable Key
    lv_var_key_e036 = flt_val.                             "Filter Value

*   Check if enhancement needs to be triggered
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e036                 "Constant value for WRICEF (E036)
        im_ser_num     = lc_ser_num_e036_1                 "Serial Number (001)
        im_var_key     = lv_var_key_e036                   "Variable Key (Screen Group)
      IMPORTING
        ex_active_flag = lv_actv_flag_e036.                "Active / Inactive flag
    IF lv_actv_flag_e036 = abap_true.
      INCLUDE zqtcn_customer_add_data_cs_01 IF FOUND.
    ENDIF.
  ENDMETHOD.


  METHOD if_ex_customer_add_data_cs~set_data.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCBI_CUSTOMER_ADD_DATA_CS~SET_DATA
*               (BADI Implementation / Method)
* PROGRAM DESCRIPTION: BP Custom Fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/29/2016
* OBJECT ID: E036
* TRANSPORT NUMBER(S): ED2K903005
*----------------------------------------------------------------------*
    CONSTANTS:
      lc_wricef_id_e036 TYPE zdevid VALUE 'E036',          "Constant value for WRICEF (E036)
      lc_ser_num_e036_1 TYPE zsno   VALUE '001'.           "Serial Number (001)

    DATA:
      lv_var_key_e036   TYPE zvar_key,                     "Variable Key
      lv_actv_flag_e036 TYPE zactive_flag.                 "Active / Inactive flag

*   Populate Variable Key
    lv_var_key_e036 = flt_val.                             "Filter Value

*   Check if enhancement needs to be triggered
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e036                 "Constant value for WRICEF (E036)
        im_ser_num     = lc_ser_num_e036_1                 "Serial Number (001)
        im_var_key     = lv_var_key_e036                   "Variable Key (Screen Group)
      IMPORTING
        ex_active_flag = lv_actv_flag_e036.                "Active / Inactive flag
    IF lv_actv_flag_e036 = abap_true.
      INCLUDE zqtcn_customer_add_data_cs_03 IF FOUND.
    ENDIF.
  ENDMETHOD.


  method IF_EX_CUSTOMER_ADD_DATA_CS~SET_FCODE.
  endmethod.


  METHOD if_ex_customer_add_data_cs~suppress_taxi_tabstrips.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCBI_CUSTOMER_ADD_DATA_CS~SUPPRESS_TAXI_TABSTRIPS
*               (BADI Implementation / Method)
* PROGRAM DESCRIPTION: BP CUstom Fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/29/2016
* OBJECT ID: E036
* TRANSPORT NUMBER(S): ED2K903005
*----------------------------------------------------------------------*
    CONSTANTS:
      lc_wricef_id_e036 TYPE zdevid VALUE 'E036',          "Constant value for WRICEF (E036)
      lc_ser_num_e036_1 TYPE zsno   VALUE '001'.           "Serial Number (001)

    DATA:
      lv_var_key_e036   TYPE zvar_key,                     "Variable Key
      lv_actv_flag_e036 TYPE zactive_flag.                 "Active / Inactive flag

*   Populate Variable Key
    lv_var_key_e036 = flt_val.                             "Filter Value

*   Check if enhancement needs to be triggered
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e036                 "Constant value for WRICEF (E036)
        im_ser_num     = lc_ser_num_e036_1                 "Serial Number (001)
        im_var_key     = lv_var_key_e036                   "Variable Key (Credit Segment)
      IMPORTING
        ex_active_flag = lv_actv_flag_e036.                "Active / Inactive flag
    IF lv_actv_flag_e036 = abap_true.
      INCLUDE zqtcn_customer_add_data_cs_02 IF FOUND.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
