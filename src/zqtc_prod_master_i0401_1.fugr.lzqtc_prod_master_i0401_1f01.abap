*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_PROD_MASTER_I0401_1F01 (Include for PBO Forms)
*               For Functional Group ZQTC_PROD_MASTER_I0401_1"
* PROGRAM DESCRIPTION: Add Custom fields to Product Master
*                      orders
* DEVELOPER: TDIMANTHA
* CREATION DATE: 03/02/2022
* OBJECT ID: I0401.1
* TRANSPORT NUMBER(S): ED2K925933
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_MODIFY_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_modify_screen .

  CONSTANTS: lc_disp_mode TYPE t130m-aktyp VALUE 'A',           " Display Mode
             lc_chng_mode TYPE t130m-aktyp VALUE 'V',           " Change Mode
             lc_crea_mode TYPE t130m-aktyp VALUE 'H',           " Create Mode
             lc_create    TYPE zvar_key    VALUE 'CREATE',      " Create
             lc_change    TYPE zvar_key    VALUE 'CHANGE',      " Change
             lc_t130m     TYPE char15      VALUE '(SAPLMGMM)T130M',  " T130M
             lc_wricef_id TYPE zdevid      VALUE 'I0401.1',          " Development ID
             lc_ser_num   TYPE zsno        VALUE '001'.              " Serial Number
  DATA: lv_actv_flag      TYPE zactive_flag .                   " Active / Inactive Flag

  FIELD-SYMBOLS: <lfs_t130m> TYPE t130m.
* Read from calling Program
  ASSIGN (lc_t130m) TO <lfs_t130m>.
  CHECK <lfs_t130m> IS ASSIGNED.

  CASE <lfs_t130m>-aktyp.
    WHEN lc_disp_mode. "If Display mode, not editable
      PERFORM f_screen_input USING '001' '0'. " Disable for input
    WHEN lc_chng_mode.    " Change Mode
* To check enhancement is active or not
      CALL FUNCTION 'ZCA_ENH_CONTROL'
        EXPORTING
          im_wricef_id   = lc_wricef_id
          im_ser_num     = lc_ser_num
          im_var_key     = lc_change
        IMPORTING
          ex_active_flag = lv_actv_flag.
      IF lv_actv_flag EQ abap_false.  "User not permitted for edit
        PERFORM f_screen_input USING '001' '0'.  " Disable for input
      ENDIF.
    WHEN lc_crea_mode.    " Create Mode
* To check enhancement is active or not
      CALL FUNCTION 'ZCA_ENH_CONTROL'
        EXPORTING
          im_wricef_id   = lc_wricef_id
          im_ser_num     = lc_ser_num
          im_var_key     = lc_create
        IMPORTING
          ex_active_flag = lv_actv_flag.
      IF lv_actv_flag EQ abap_false.  "User not permitted for edit
        PERFORM f_screen_input USING '001' '0'.   " Disable for input
      ENDIF.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_UUID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_uuid .

  CALL FUNCTION 'MARA_GET_SUB'
    IMPORTING
      wmara = mara
      xmara = *mara
      ymara = lmara.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHANGE_INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0074   text
*      -->P_0075   text
*----------------------------------------------------------------------*
FORM f_screen_input  USING fp_group1 TYPE screen-group1
                           fp_input  TYPE screen-input.
  LOOP AT SCREEN.
    IF screen-group1 EQ fp_group1.
      screen-input = fp_input.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDFORM.
