class ZQTCCL_SDOC_WRAPPER_MASS definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_BADI_SDOC_WRAPPER_MASS .
protected section.
private section.

  constants C_WRICEF_ID_R050 type ZDEVID value 'R050' ##NO_TEXT.
  constants C_SER_NUM_1_R050 type ZSNO value '001' ##NO_TEXT.
  constants C_WRICEF_ID_R052 type ZDEVID value 'R052' ##NO_TEXT.
  constants C_SER_NUM_1_R052 type ZSNO value '001' ##NO_TEXT.
  constants C_WRICEF_ID_R054 type ZDEVID value 'R054' ##NO_TEXT.
  constants C_SER_NUM_1_R054 type ZSNO value '001' ##NO_TEXT.

  methods METH_CREATE_DYNAMIC_TABLE
    importing
      !IM_CT_RESULT type TABLE
    exporting
      !EX_DYNAMIC_S type ref to DATA
      !EX_DYNAMIC_T type ref to DATA .
ENDCLASS.



CLASS ZQTCCL_SDOC_WRAPPER_MASS IMPLEMENTATION.


  METHOD if_badi_sdoc_wrapper_mass~post_processing_mass.

*** BOC BY RKUMAR2 on 11-MAY-2018 for E075
    CONSTANTS: c_wricef_id_e075  TYPE zdevid VALUE 'E075',
               c_ser_num_11_e075 TYPE zsno VALUE '11'.

    DATA:
      lv_actv_flag_r050 TYPE zactive_flag,            "Active / Inactive Flag
      lv_var_key_r050   TYPE zvar_key,                "Variable Key
      lv_var_key_e075   TYPE zvar_key,
      lv_actv_flag_e075 TYPE zactive_flag.

    "check for converted orders
    lv_var_key_e075 =  sy-tcode.
    lv_var_key_r050 =  sy-tcode.
*---Begin of change VDPATABALL INC0245900 - ZQTC_VA45
*--For batch job need to include the custom fields in layout
    IF sy-batch = abap_true.
      IF sy-cprog = 'SD_SALES_DOCUMENT_VA45'.
        lv_var_key_r050 = 'ZQTC_VA45'.
      ENDIF.
    ENDIF.
*---End of change VDPATABALL INC0245900 - ZQTC_VA45
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = c_wricef_id_e075
        im_ser_num     = c_ser_num_11_e075
        im_var_key     = lv_var_key_e075
      IMPORTING
        ex_active_flag = lv_actv_flag_e075.
    IF lv_actv_flag_e075 EQ abap_true.
      "control processing legacy to SAP converted contracts using VA45
      INCLUDE zqtcn_filter_cnvrt_sdoc IF FOUND.
    ENDIF.
*** EOC BY RKUMAR2 on 11-MAY-2018 for E075
*   To check enhancement is active or not
*** BOC BY SAYANDAS on 02-JAN-2018 for ERP-5688
*   lv_var_key_r050 = iv_application_id.
    lv_var_key_r050 = sy-tcode.
*** EOC BY SAYANDAS on 02-JAN-2018 for ERP-5688
    IF sy-tcode = 'VA45'.
      lv_var_key_r050 = 'ZQTC_VA45'.
    ENDIF.
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = c_wricef_id_r050
        im_ser_num     = c_ser_num_1_r050
        im_var_key     = lv_var_key_r050
      IMPORTING
        ex_active_flag = lv_actv_flag_r050.

    IF lv_actv_flag_r050 EQ abap_true.
      INCLUDE zqtcn_sdoc_wrapper_mass_va45 IF FOUND.
    ENDIF.

    DATA:
      lv_actv_flag_r052 TYPE zactive_flag,            "Active / Inactive Flag
      lv_var_key_r052   TYPE zvar_key.                "Variable Key

*   To check enhancement is active or not
    lv_var_key_r052 = iv_application_id.
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = c_wricef_id_r052
        im_ser_num     = c_ser_num_1_r052
        im_var_key     = lv_var_key_r052
      IMPORTING
        ex_active_flag = lv_actv_flag_r052.

    IF lv_actv_flag_r052 EQ abap_true.
      INCLUDE zqtcn_sdoc_wrapper_mass_va05 IF FOUND.
    ENDIF.
*Boc nallapanenimounika(nmounika) 23-06-2017  ED2K906855
    DATA:
      lv_actv_flag_r054 TYPE zactive_flag,            "Active / Inactive Flag
      lv_var_key_r054   TYPE zvar_key.                "Variable Key

*   To check enhancement is active or not
    lv_var_key_r054 = iv_application_id.
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = c_wricef_id_r054
        im_ser_num     = c_ser_num_1_r054
        im_var_key     = lv_var_key_r054
      IMPORTING
        ex_active_flag = lv_actv_flag_r054.

    IF lv_actv_flag_r054 EQ abap_true.
      INCLUDE zqtcn_sdoc_wrapper_mass_va25 IF FOUND.
    ENDIF.
*Eoc nallapanenimounika(nmounika) 23-06-2017    ED2K906855

*** BOC BY SAYANDAS for JIRA# 6289 on 07-MAY-2018
    DATA : lv_var_key_va05   TYPE zvar_key.
    CONSTANTS: lc_va05 TYPE sytcode VALUE 'VA05'.

    lv_var_key_va05 = sy-tcode.

    IF lv_var_key_va05 = lc_va05.
      INCLUDE zqtcn_sdoc_wrapper_mass_va05_2 IF FOUND.
    ENDIF.
*** EOC BY SAYANDAS for JIRA# 6289 on 07-MAY-2018
*    FIELD-SYMBOLS:<FS> TYPE ANY TABLE.
*    if sy-subrc eq 0 and sy-uname = 'NPOLINA'.
*    assign ct_result to <FS> CASTING LIKE ct_result.
**    assign <fs> to FIELD-SYMBOL(<FS2>) CASTING like ct_result .
**    sort <fs2> by vbeln posnr.
*    endif.
*----BOC ERPM-2948 VDPATABALL Sorting the dynamic table for VA45
    DATA:lv_devid     TYPE zdevid,
         lv_var_key   TYPE zvar_key,
         lv_actv_flag TYPE zactive_flag.
    CONSTANTS:lc_sno TYPE zsno VALUE '002'.
    FREE:lv_devid,lv_var_key,lv_actv_flag.
    IF sy-tcode = 'VA45'
      OR sy-tcode = 'ZQTC_VA45'.
      lv_devid = c_wricef_id_r050.
      lv_var_key = sy-tcode.
    ELSEIF sy-tcode = 'VA25'
      OR sy-tcode = 'ZQTC_VA25'.
      lv_devid = c_wricef_id_r052.
      lv_var_key = sy-tcode.
    ELSEIF sy-tcode = 'ZQTC_VA05'
      OR sy-tcode = 'VA05'.
      lv_devid = c_wricef_id_r054.
      lv_var_key = sy-tcode.
*----BOC VDPATABALL 01/06/2022 ED2K924869 OTCM-47818
    ENDIF.
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lv_devid
        im_ser_num     = lc_sno
        im_var_key     = lv_var_key
      IMPORTING
        ex_active_flag = lv_actv_flag.
    IF lv_actv_flag EQ abap_true.
      INCLUDE zqtcn_sdoc_wrapper_mass_sort IF FOUND.
    ENDIF.
*----EOC ERPM-2948 VDPATABALL Sorting the dynamic table for VA45
  ENDMETHOD.


  METHOD meth_create_dynamic_table.

*   Data Declaration
    DATA:
      lr_struc_type TYPE REF TO cl_abap_structdescr,            "Runtime Type Services
      lr_table_type TYPE REF TO cl_abap_tabledescr.             "Runtime Type Services

*   Get Description of data object type (Table)
    lr_table_type ?= cl_abap_typedescr=>describe_by_data( im_ct_result ).
    lr_struc_type ?= lr_table_type->get_table_line_type( ).

*   Create data object (Structure)
    CREATE DATA ex_dynamic_s TYPE HANDLE lr_struc_type.         "Internal ID of an object
*   Create data object (Internal Table)
    CREATE DATA ex_dynamic_t TYPE HANDLE lr_table_type.         "Internal ID of an object

  ENDMETHOD.
ENDCLASS.
