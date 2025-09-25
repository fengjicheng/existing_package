class ZQTCCL_CUSTOMER_ADD_DATA definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_CUSTOMER_ADD_DATA .
protected section.
private section.
ENDCLASS.



CLASS ZQTCCL_CUSTOMER_ADD_DATA IMPLEMENTATION.


  method IF_EX_CUSTOMER_ADD_DATA~BUILD_TEXT_FOR_CHANGE_DETAIL.
  endmethod.


  method IF_EX_CUSTOMER_ADD_DATA~CHECK_ACCOUNT_NUMBER.
  endmethod.


  METHOD if_ex_customer_add_data~check_add_on_active.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCBI_CUSTOMER_ADD_DATA~CHECK_ADD_ON_ACTIVE
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
    lv_var_key_e036 = i_screen_group.                      "Filter Value

*   Check if enhancement needs to be triggered
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e036                 "Constant value for WRICEF (E036)
        im_ser_num     = lc_ser_num_e036_1                 "Serial Number (001)
        im_var_key     = lv_var_key_e036                   "Variable Key (Screen Group)
      IMPORTING
        ex_active_flag = lv_actv_flag_e036.                "Active / Inactive flag
    IF lv_actv_flag_e036 = abap_true.
      INCLUDE zqtcn_customer_add_data_01 IF FOUND.
    ENDIF.
  ENDMETHOD.


  METHOD if_ex_customer_add_data~check_all_data.

*  INCLUDE ZQTCN_BP_CHANGES_CHECK_E191 IF FOUND.
    DATA: lst_knb5_o TYPE knb5,
          lst_knb1_n                  TYPE knb1,
          lst_knb5_n                  TYPE knb5,
          lt_knb5_n                   TYPE STANDARD TABLE OF knb5,
          lt_knb5_o                   TYPE STANDARD TABLE OF knb5,
          lt_busdata_x                TYPE STANDARD TABLE OF busdata.

    BREAK-POINT.

    IF 1 = 2.
      CALL FUNCTION 'FI_BUPA_KNB1_GET'
        IMPORTING
          E_KNB1        = lst_knb1_n.
*          E_DATA        =
*                .

**-- Get KNB1 data from runtime
*      CALL FUNCTION 'CVIC_BUPA_KNB1_GET'
*        IMPORTING
*          e_knb1 = lst_knb1_n.
*
*
*      CALL FUNCTION 'CVIC_BUPA_KNB5_GET'
*        TABLES
*          t_knb5 = lt_knb5_n
*          t_data = lt_busdata_x.
*
**-- Get KNB5 data from DB to compare the changes for respective companycode
*      SELECT * FROM knb5 INTO TABLE lt_knb5_o
*                    WHERE kunnr = lst_knb1_n-kunnr
*                    AND   bukrs = lst_knb1_n-bukrs.
*      IF sy-subrc = 0.
*        CLEAR: lst_knb5_o,
*               lst_knb5_n.
*        READ TABLE lt_knb5_o INTO lst_knb5_o WITH KEY maber = ''.
*        READ TABLE lt_knb5_n INTO lst_knb5_n WITH KEY maber = ''.
*        IF lst_knb5_o-mahna = lst_knb5_n-mahna.
*          LOOP AT lt_knb5_n ASSIGNING FIELD-SYMBOL(<lt_knb5_n>) WHERE mahna = lst_knb5_n-mahna.
*            IF <lt_knb5_n>-maber <> lst_knb5_n-maber.
*              <lt_knb5_n>-mansp = lst_knb5_n-mansp.
*            ENDIF.
*          ENDLOOP.
*        ENDIF.
*      ENDIF.
*
*      CALL FUNCTION 'CVIC_BUPA_KNB5_COLLECT'
*        EXPORTING
*          i_subname = 'KNB5'
*        TABLES
*          t_knb5    = lt_knb5_n. "t_knb5[].

    ENDIF. "IF 1 = 2.
  ENDMETHOD.


  method IF_EX_CUSTOMER_ADD_DATA~CHECK_DATA_CHANGED.
  endmethod.


  method IF_EX_CUSTOMER_ADD_DATA~GET_CHANGEDOCS_FOR_OWN_TABLES.
  endmethod.


  method IF_EX_CUSTOMER_ADD_DATA~INITIALIZE_ADD_ON_DATA.
  endmethod.


  method IF_EX_CUSTOMER_ADD_DATA~MODIFY_ACCOUNT_NUMBER.
  endmethod.


  method IF_EX_CUSTOMER_ADD_DATA~PRESET_VALUES_CCODE.
  endmethod.


  method IF_EX_CUSTOMER_ADD_DATA~PRESET_VALUES_SAREA.
  endmethod.


  method IF_EX_CUSTOMER_ADD_DATA~READ_ADD_ON_DATA.
  endmethod.


  method IF_EX_CUSTOMER_ADD_DATA~SAVE_DATA.
  endmethod.


  method IF_EX_CUSTOMER_ADD_DATA~SET_USER_INPUTS.
  endmethod.
ENDCLASS.
