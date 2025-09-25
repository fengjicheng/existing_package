*----------------------------------------------------------------------*
* INCLUDE NAME: ZQTCN_BP_VALIDATIONS
*               Called from BDT event FM: ZQTC_BUP_BUPA_EVENT_DCHCK_E165
*              (BDT Event: DCHCK)
* DESCRIPTION: BP Validations
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 07/04/2018
* OBJECT ID: E165 / CR# 6664
* TRANSPORT NUMBER(s): ED2K913317
*----------------------------------------------------------------------*

* Local Types
  TYPES: BEGIN OF ty_enh_ctrl,
           wricef_id   TYPE zdevid,
           ser_num     TYPE zsno,
           var_key     TYPE zvar_key,
           active_flag TYPE zactive_flag,
         END OF ty_enh_ctrl.

* Local Data declaration
  DATA:
    li_enh_ctrl           TYPE STANDARD TABLE OF ty_enh_ctrl INITIAL SIZE 0,
    lir_devid             TYPE RANGE OF zdevid,
    lsr_devid             LIKE LINE OF lir_devid,
    lv_actv_flag_e165_001 TYPE zactive_flag, " Active/Inactive Flag
    lv_actv_flag_e184_001 TYPE zactive_flag. " Active/Inactive Flag

* Local constant Declaration
  CONSTANTS:
    lc_wricef_id_e165 TYPE zdevid   VALUE 'E165',                " Development ID: E165
    lc_wricef_id_e184 TYPE zdevid   VALUE 'E184',                " Development ID: E184
    lc_sno_e165_001   TYPE zsno     VALUE '001',                 " Serial Number: 001
    lc_sno_e184_001   TYPE zsno     VALUE '001',                 " Serial Number: 003
    lc_vkey_e165_001  TYPE zvar_key VALUE 'RELTYP_VALIDATION',   " Variable Key: 001
    lc_vkey_e184_001  TYPE zvar_key VALUE 'RESTRICT_COMPCODE'. " Variable Key: 003

* Fetch the enhancement control records
  lsr_devid-sign   = 'I'.
  lsr_devid-option = 'EQ'.
  lsr_devid-low    = lc_wricef_id_e165.
  APPEND lsr_devid TO lir_devid.
  CLEAR lsr_devid.

  lsr_devid-sign   = 'I'.
  lsr_devid-option = 'EQ'.
  lsr_devid-low    = lc_wricef_id_e184.
  APPEND lsr_devid TO lir_devid.
  CLEAR lsr_devid.

  SELECT wricef_id, ser_num, var_key, active_flag
         FROM zca_enh_ctrl INTO TABLE @li_enh_ctrl
         WHERE wricef_id IN @lir_devid AND
               active_flag = @abap_true.
  IF sy-subrc = 0.
    CLEAR lir_devid[].
    IF li_enh_ctrl[] IS NOT INITIAL.
      SORT li_enh_ctrl BY wricef_id ser_num var_key.
    ENDIF.
  ENDIF.

* READ enhancement control table to get active/inactive flag
* BINARY SEARCH in not required in this READ stmt as it has very less entries
  READ TABLE li_enh_ctrl INTO DATA(lsi_e165_001) WITH KEY wricef_id = lc_wricef_id_e165
                                                     ser_num = lc_sno_e165_001
                                                     var_key = lc_vkey_e165_001.
  IF sy-subrc = 0.
    lv_actv_flag_e165_001 = lsi_e165_001-active_flag.
    CLEAR lsi_e165_001.
  ENDIF.
* check to trigger the enhancement
  IF lv_actv_flag_e165_001 EQ abap_true.
    INCLUDE zqtcn_relationship_validation IF FOUND.
  ENDIF.

* READ enhancement control table to get active/inactive flag
* BINARY SEARCH in not required in this READ stmt as it has very less entries
  READ TABLE li_enh_ctrl INTO DATA(lsi_e184_001) WITH KEY wricef_id = lc_wricef_id_e184
                                                     ser_num = lc_sno_e184_001
                                                     var_key = lc_vkey_e184_001.
  IF sy-subrc = 0.
    lv_actv_flag_e184_001 = lsi_e184_001-active_flag.
    CLEAR lsi_e184_001.
  ENDIF.
* check to trigger the enhancement
  IF lv_actv_flag_e184_001 EQ abap_true.
    INCLUDE zqtcn_restrict_compcode_ext IF FOUND.
  ENDIF.
