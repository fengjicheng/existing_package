FUNCTION zqtc_cmir_searchhlep_exit.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     VALUE(SHLP) TYPE  SHLP_DESCR
*"     VALUE(CALLCONTROL) LIKE  DDSHF4CTRL STRUCTURE  DDSHF4CTRL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------
* PROGRAM NAME: ZQTC_CMIR_SEARCHHLEP_EXIT (function module)
* PROGRAM DESCRIPTION: Preparing search help displaying data
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   07/15/2020
* WRICEF ID: E253
* TRANSPORT NUMBER(S): ED2K918906
* REFERENCE NO: ERPM-20026
*----------------------------------------------------------------------*

  DATA : lv_var_key_e253   TYPE zvar_key,                           " variable key
         lv_actv_flag_e253 TYPE zactive_flag.                       " Active / Inactive Flag

  CONSTANTS : lc_wricef_id_e253 TYPE zdevid VALUE 'E253',           " WRICEF ID
              lc_ser_num_e253   TYPE zsno   VALUE '001',            " Serial No
              lc_step           TYPE ddshf4ctrl-step VALUE 'DISP',  " Search help exit call step name
              lc_vd51           TYPE sy-tcode VALUE 'VD51',
              lc_vd52           TYPE sy-tcode VALUE 'VD52',
              lc_vd53           TYPE sy-tcode VALUE 'VD53',
              lc_var_key_e253   TYPE zvar_key VALUE 'VD51_VD52'.

  CASE callcontrol-step.
    WHEN lc_step.       " Search help exit call step name
      " Fetch Society models from the material group 5 config table
      SELECT a~mvgr5 AS sortl,b~bezei
        FROM tvm5 AS a INNER JOIN
             tvm5t AS b ON b~mvgr5 = a~mvgr5
        INTO TABLE @DATA(li_data)
        WHERE b~spras EQ @sy-langu.

      " Check whether T-code is equal to Customer info record actions
      IF sy-tcode = lc_vd51 OR sy-tcode = lc_vd52 OR sy-tcode = lc_vd53.
        lv_var_key_e253 = lc_var_key_e253.
      ENDIF.

      " Check whether enhancement is active
      CALL FUNCTION 'ZCA_ENH_CONTROL'                   " Function Module for Enhancement status check
        EXPORTING
          im_wricef_id   = lc_wricef_id_e253
          im_ser_num     = lc_ser_num_e253
          im_var_key     = lv_var_key_e253
        IMPORTING
          ex_active_flag = lv_actv_flag_e253.

      IF lv_actv_flag_e253 EQ abap_true.                " E253 Enhancement is active,then apply the additional logic
        INCLUDE zqtcn_shelp_logic_e253 IF FOUND.        " Subroutine for addtional logic build for search help exit
      ENDIF.

      REFRESH record_tab.                               " Clear the existing search help data
      CALL FUNCTION 'F4UT_RESULTS_MAP'                  " Mapping new data for search help
        EXPORTING
          apply_restrictions = 'X'
        TABLES
          shlp_tab           = shlp_tab
          record_tab         = record_tab
          source_tab         = li_data
        CHANGING
          shlp               = shlp
          callcontrol        = callcontrol
        EXCEPTIONS
          illegal_structure  = 1
          OTHERS             = 2.

  ENDCASE.

ENDFUNCTION.
