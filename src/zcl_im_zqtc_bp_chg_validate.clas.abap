class ZCL_IM_ZQTC_BP_CHG_VALIDATE definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BUPA_FURTHER_CHECKS .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_ZQTC_BP_CHG_VALIDATE IMPLEMENTATION.


  METHOD if_ex_bupa_further_checks~check_central.
* Local Data
    DATA:
      lv_actv_e191  TYPE zactive_flag .
*
* Local constants
    CONSTANTS:
      lc_devid_e191   TYPE zdevid      VALUE 'E191',    " Development ID: E191
      lc_sno_e191_003 TYPE zsno        VALUE '003',     " Serial Number: 001
      lc_ar           TYPE zvar_key    VALUE 'AR'.      " Serial Number: 001
*--------------------------------------------------------------------*
* To check enhancement is active or not
    CLEAR:lv_actv_e191.
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_devid_e191                " Development ID: E191
        im_ser_num     = lc_sno_e191_003              " Serial Number: 003
        im_var_key     = lc_ar                        " Varkey
      IMPORTING
        ex_active_flag = lv_actv_e191.                " Active / Inactive Flag
    IF lv_actv_e191 EQ abap_true.                     " Enhancement is not Active
      INCLUDE zqtcn_bp_changes_check_e191 IF FOUND.
    ENDIF.
    " New
    INCLUDE zqtcn_bp_changes_check_e191_d IF FOUND.


*Begin of POC by Vishnu ***
    DATA: li_cc_data TYPE cvis_cc_info_overview_t,
          li_sa_data TYPE cvis_sales_area_info_t.

    li_cc_data = cvi_bdt_adapter=>get_company_codes( ).
    li_sa_data = cvi_bdt_adapter=>get_sales_areas( ).
    EXPORT li_cc_data FROM li_cc_data TO MEMORY ID 'BP_BUKRS'.
    EXPORT li_sa_data FROM li_sa_data TO MEMORY ID 'BP_VKORG'.

*End of POC by Vishnu ***
  ENDMETHOD.
ENDCLASS.
