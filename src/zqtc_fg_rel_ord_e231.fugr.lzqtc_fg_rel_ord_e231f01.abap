*----------------------------------------------------------------------*
***INCLUDE LJKSEORDER12F01 .
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:LZQTC_FG_REL_ORD_E231F01
* PROGRAM DESCRIPTION: Include for all subroutines
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE: 02/21/2020
* OBJECT ID:     E231/ERPM-12582
* TRANSPORT NUMBER(S): ED2K917590
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  get_jksecontrindex
*&---------------------------------------------------------------------*
*       Kontraktindex lesen
*----------------------------------------------------------------------*
*       ...
*----------------------------------------------------------------------*
FORM get_jksecontrindex  USING    vbeln          TYPE vbak-vbeln
                                  posnr          TYPE vbap-posnr
                         CHANGING jksecontrindex TYPE jksecontrindex.

  CALL FUNCTION 'ISM_SD_SELECT_JKSECONTRINDEX'
    EXPORTING
      in_vbeln           = vbeln
      in_posnr           = posnr
    IMPORTING
      out_jksecontrindex = jksecontrindex
    EXCEPTIONS
      not_found          = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    CLEAR jksecontrindex.
  ENDIF.
ENDFORM.                    " get_jksecontrindex
*&---------------------------------------------------------------------*
*&      Form  F_GET_SHIPTO_ADDRESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_shipto_address USING fp_vbeln  TYPE vbak-vbeln
                                fp_posnr  TYPE vbap-posnr.

  DATA : lv_parvw TYPE parvw VALUE 'WE',
         lv_posnr TYPE posnr VALUE '000000',
         lv_lines TYPE i.
  FREE : i_vbpa_addr.
  FREE : i_vbpa.
  CALL FUNCTION 'SD_PARTNER_READ'
    EXPORTING
      f_vbeln  = fp_vbeln
      object   = 'VBPA'
      iv_parvw = lv_parvw
      iv_posnr = fp_posnr
    TABLES
      i_xvbadr = i_vbpa_addr
      i_xvbpa  = i_vbpa.
  IF i_vbpa IS INITIAL.
    CALL FUNCTION 'SD_PARTNER_READ'
      EXPORTING
        f_vbeln  = fp_vbeln
        object   = 'VBPA'
        iv_parvw = lv_parvw
        iv_posnr = lv_posnr
      TABLES
        i_xvbadr = i_vbpa_addr
        i_xvbpa  = i_vbpa.
  ENDIF.
*--*Make sure address itab containes only shipto address
  DESCRIBE TABLE i_vbpa_addr LINES lv_lines.
  IF lv_lines GT 1.
    DELETE i_vbpa WHERE parvw NE lv_parvw.
    READ TABLE i_vbpa INTO DATA(lst_vbpa) INDEX 1.
    IF sy-subrc EQ 0.
      DELETE i_vbpa_addr WHERE adrnr NE lst_vbpa-adrnr.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MATERIAL_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_material_info USING fp_issue TYPE matnr.
  CLEAR : st_mvke.
  CALL FUNCTION 'MVKE_SINGLE_READ'
    EXPORTING
      matnr             = fp_issue
      vkorg             = jksecontrindex-vkorg
      vtweg             = jksecontrindex-vtweg
    IMPORTING
      wmvke             = st_mvke
*     O_MVKE            =
    EXCEPTIONS
      lock_on_mvke      = 1
      lock_system_error = 2
      wrong_call        = 3
      not_found         = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants .
  CONSTANTS : lc_dev_id        TYPE zdevid VALUE 'E231',
              lc_item_cat_grp  TYPE rvari_vnam VALUE 'ITEM_CAT_GRP',
              lc_country       TYPE rvari_vnam VALUE 'COUNTRY',
              lc_plant         TYPE rvari_vnam VALUE  'PLANT',
              lc_postal_code   TYPE rvari_vnam VALUE 'POSTAL_CODE',
              lc_shiiping_cond TYPE rvari_vnam VALUE 'SHIIPING_COND',
              lc_vendor        TYPE rvari_vnam VALUE 'VENDOR',
              lc_fp            TYPE rvari_vnam VALUE 'FIRST_PRINT',
              lc_wh            TYPE rvari_vnam VALUE 'WAREHOUSE',
              lc_contract_type TYPE rvari_vnam VALUE 'CONTRACT_TYPE'.

  IF li_constants_e231 IS INITIAL.
**   Fetch Constant Values
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_dev_id                                  "Development ID: E231
      IMPORTING
        ex_constants = li_constants_e231.                         "Constant Values
    READ TABLE i_vbpa_addr INTO DATA(lst_vbpa_address) INDEX 1.
    LOOP AT li_constants_e231 ASSIGNING FIELD-SYMBOL(<lst_const>).
      CASE <lst_const>-param1.
        WHEN lc_country.       "Country
*      CASE <lst_constant>-param2.
          APPEND INITIAL LINE TO lir_country ASSIGNING FIELD-SYMBOL(<lst_country>).
          <lst_country>-sign   = <lst_const>-sign.
          <lst_country>-option = <lst_const>-opti.
          <lst_country>-low    = <lst_const>-low.
          <lst_country>-high   = <lst_const>-high.
        WHEN lc_item_cat_grp.
          IF <lst_const>-param2 = lc_fp.
            APPEND INITIAL LINE TO lir_item_cat_grp_fp ASSIGNING FIELD-SYMBOL(<lst_item_cat_grp>).
            <lst_item_cat_grp>-sign   = <lst_const>-sign.
            <lst_item_cat_grp>-option = <lst_const>-opti.
            <lst_item_cat_grp>-low    = <lst_const>-low.
            <lst_item_cat_grp>-high   = <lst_const>-high.
          ELSEIF <lst_const>-param2 = lc_wh.
            APPEND INITIAL LINE TO lir_item_cat_grp_wh ASSIGNING FIELD-SYMBOL(<lst_item_cat_grp2>).
            <lst_item_cat_grp2>-sign   = <lst_const>-sign.
            <lst_item_cat_grp2>-option = <lst_const>-opti.
            <lst_item_cat_grp2>-low    = <lst_const>-low.
            <lst_item_cat_grp2>-high   = <lst_const>-high.
          ENDIF.
        WHEN lc_plant.
          APPEND INITIAL LINE TO lir_plant ASSIGNING FIELD-SYMBOL(<lst_plant>).
          <lst_plant>-sign   = <lst_const>-sign.
          <lst_plant>-option = <lst_const>-opti.
          <lst_plant>-low    = <lst_const>-low.
          <lst_plant>-high   = <lst_const>-high.
        WHEN lc_postal_code.
          IF <lst_const>-param2 = lst_vbpa_address-land1 OR <lst_const>-low = '*'.
            APPEND INITIAL LINE TO  lir_post_code ASSIGNING FIELD-SYMBOL(<lst_post_code>).
            <lst_post_code>-sign   = <lst_const>-sign.
            <lst_post_code>-option = <lst_const>-opti.
            <lst_post_code>-low    = <lst_const>-low.
            <lst_post_code>-high   = <lst_const>-high.
          ENDIF.
        WHEN lc_shiiping_cond.
          APPEND INITIAL LINE TO lir_ship_cond ASSIGNING FIELD-SYMBOL(<lst_ship_cond>).
          <lst_ship_cond>-sign   = <lst_const>-sign.
          <lst_ship_cond>-option = <lst_const>-opti.
          <lst_ship_cond>-low    = <lst_const>-low.
          <lst_ship_cond>-high   = <lst_const>-high.
        WHEN lc_vendor.
          APPEND INITIAL LINE TO lir_vendor ASSIGNING FIELD-SYMBOL(<lst_vendor>).
          <lst_vendor>-sign   = <lst_const>-sign.
          <lst_vendor>-option = <lst_const>-opti.
          <lst_vendor>-low    = <lst_const>-low.
          <lst_vendor>-high   = <lst_const>-high.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = <lst_vendor>-low
            IMPORTING
              output = <lst_vendor>-low.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = <lst_vendor>-high
            IMPORTING
              output = <lst_vendor>-high.
        WHEN lc_contract_type.
          APPEND INITIAL LINE TO lir_contract_type ASSIGNING FIELD-SYMBOL(<lst_contract_type>).
          <lst_contract_type>-sign   = <lst_const>-sign.
          <lst_contract_type>-option = <lst_const>-opti.
          <lst_contract_type>-low    = <lst_const>-low.
          <lst_contract_type>-high   = <lst_const>-high.
        WHEN OTHERS.
*         Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_OUT_CHECK_FAILED  text
*----------------------------------------------------------------------*
FORM f_validate_data  CHANGING    fp_out_check_failed TYPE c.
  DATA : lv_landx               TYPE landx,
         lv_vsbed_text          TYPE vsbed_bez,
         lv_mtpos_fp            TYPE mtpos,
         lv_first_print_nocheck TYPE c,
         lv_warehouse_nocheck   TYPE c,
         lv_country_msg         TYPE char10,
         lv_vendor_msg          TYPE char10,
         lv_vsbed_msg           TYPE char10,
         lv_pstlz_msg           TYPE char10,
         lv_plant_msg           TYPE char10,
         lv_values              TYPE char50,
         lv_msg                 TYPE char200.
  CLEAR : fp_out_check_failed.
  CLEAR : v_first_print.
  CLEAR : v_distr_warehouse.
  CLEAR : v_msg.
  CLEAR : lv_first_print_nocheck.
  CLEAR :  lv_warehouse_nocheck.
*--*Order type checks and validations
  IF lir_contract_type IS INITIAL.
    " order type check is not required
  ELSE.
    IF jksecontrindex-auart IN lir_contract_type[].
      "since the contract type is for exclusion.. check is not required.
      RETURN.
    ELSE.
      "continue with future checks
    ENDIF.
  ENDIF.

  READ TABLE i_vbpa_addr INTO DATA(lst_vbpa_addr) INDEX 1.
  IF sy-subrc EQ 0.
*--*Consider only constnat table active entries
    IF lir_country IS INITIAL.
      CLEAR lst_vbpa_addr-land1.
    ENDIF.
    IF lir_post_code[] IS INITIAL.
      CLEAR lst_vbpa_addr-pstlz.
    ENDIF.
  ENDIF.
  IF lir_ship_cond[] IS INITIAL .
    CLEAR st_knvv-vsbed.
  ENDIF.
  IF lir_plant[] IS INITIAL.
    CLEAR st_mvke-dwerk.
  ENDIF.
  lv_mtpos_fp = st_mvke-mtpos.
  IF lir_item_cat_grp_fp[] IS INITIAL.
    CLEAR lv_mtpos_fp.
  ENDIF.
  IF lir_item_cat_grp_wh[] IS INITIAL.
    CLEAR st_mvke-mtpos.
  ENDIF.
*--*BOC INC0298878 ED2K918868 7/10/2020 Prabhu
*--*Check all the first print paremeters active status in constant table
  IF lir_country IS INITIAL AND lir_post_code IS INITIAL AND
     lir_ship_cond IS INITIAL AND lir_vendor IS INITIAL.
    lv_first_print_nocheck = abap_true.
  ENDIF.
*--*Check all the first warehouse paremeters active status in constant table
  IF lir_country IS INITIAL AND lir_post_code IS INITIAL AND
     lir_ship_cond IS INITIAL AND lir_plant IS INITIAL.
    lv_warehouse_nocheck  = abap_true.
  ENDIF.
*--*EOC INC0298878 ED2K918868 7/10/2020 Prabhu
*--*Country and Postal code check
  IF lst_vbpa_addr-land1 IN lir_country
     AND lst_vbpa_addr-pstlz IN lir_post_code.
*--* First Print
*--*Item category group check
    IF lv_mtpos_fp IN lir_item_cat_grp_fp AND lv_first_print_nocheck IS INITIAL.
*--*Shipping condition and Vendor
      IF st_knvv-vsbed IN lir_ship_cond
         AND v_lifnr IN lir_vendor.
        fp_out_check_failed = abap_true.
        v_first_print = abap_true.
      ENDIF.
    ENDIF.
*--*Distributed from warehouse
*--*Shipping conditions and Plant along with item category group -
    IF st_mvke-mtpos IN lir_item_cat_grp_wh AND lv_warehouse_nocheck IS INITIAL.
      IF st_knvv-vsbed IN lir_ship_cond
        AND st_mvke-dwerk IN lir_plant.
        fp_out_check_failed = abap_true.
        v_distr_warehouse = abap_true.
      ENDIF.
    ENDIF.
*--*If check is failed get country name and other required paraeters to built error message
    IF fp_out_check_failed = abap_true.
*      CLEAR : lv_landx.
*      SELECT SINGLE landx FROM t005t INTO lv_landx WHERE land1 = lst_vbpa_addr-land1
*                                                     AND spras = sy-langu.
      CLEAR : lv_vsbed_text.
      SELECT SINGLE vtext FROM tvsbt INTO lv_vsbed_text WHERE vsbed = st_knvv-vsbed
                                                              AND spras = sy-langu.
      IF v_first_print = abap_true.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = v_lifnr
          IMPORTING
            output = v_lifnr.
*       CONCATENATE text-001 lv_landx text-002 lst_vbpa_addr-pstlz text-003 v_lifnr text-004 lv_vsbed_text
*                                          INTO v_msg SEPARATED BY ' '.
*--*BOC INC0298878:7/29/2020
*        CONCATENATE text-001 lv_landx lst_vbpa_addr-pstlz v_lifnr lv_vsbed_text
*                                           INTO v_msg SEPARATED BY ' '.
        CLEAR:lv_msg,lv_values.
        IF lst_vbpa_addr-land1 IS NOT INITIAL.
          lv_country_msg = text-007.
          lv_msg = lv_country_msg.
          lv_values = lst_vbpa_addr-land1.
        ENDIF.
        IF v_lifnr IS NOT INITIAL.
          lv_vendor_msg = text-008.
          IF lv_msg IS NOT INITIAL.
            CONCATENATE lv_msg ',' lv_vendor_msg INTO lv_msg.
            CONCATENATE lv_values ',' v_lifnr INTO lv_values.
          ELSE.
            lv_msg = lv_vendor_msg.
            lv_values = v_lifnr.
          ENDIF.
        ENDIF.
        IF lv_vsbed_text IS NOT INITIAL.
          lv_vsbed_msg = text-009.
          IF lv_msg IS NOT INITIAL.
            CONCATENATE lv_msg ',' lv_vsbed_msg INTO lv_msg.
            CONCATENATE lv_values ',' lv_vsbed_text INTO lv_values.
          ELSE.
            lv_msg = lv_vsbed_msg.
            lv_values = lv_vsbed_text.
          ENDIF.
        ENDIF.
        IF lst_vbpa_addr-pstlz IS NOT INITIAL.
          lv_pstlz_msg = text-010.
          IF lv_msg IS NOT INITIAL.
            CONCATENATE lv_msg ',' lv_pstlz_msg INTO lv_msg.
            CONCATENATE lv_values ',' lst_vbpa_addr-pstlz INTO lv_values.
          ELSE.
            lv_msg = lv_pstlz_msg.
            lv_values = lst_vbpa_addr-pstlz.
          ENDIF.
        ENDIF.
        IF v_vendor_maintained IS NOT INITIAL AND lst_vbpa_addr-land1 IS INITIAL
           AND v_lifnr IS INITIAL AND lv_vsbed_text IS INITIAL AND lst_vbpa_addr-pstlz IS INITIAL.
          v_msg = text-006.
        ELSE.
          CONCATENATE text-001 lv_msg INTO lv_msg.
          CONCATENATE lv_msg lv_values INTO v_msg SEPARATED BY ' - '.
        ENDIF.
      ENDIF.


      IF v_distr_warehouse = abap_true..
*        CONCATENATE text-001 lv_landx text-002 lst_vbpa_addr-pstlz text-005 st_mvke-dwerk text-004 lv_vsbed_text
*                                          INTO v_msg SEPARATED BY ' '.
*      CONCATENATE text-001 lv_landx lst_vbpa_addr-pstlz st_mvke-dwerk lv_vsbed_text
*                                        INTO v_msg SEPARATED BY ' '.
        CLEAR:lv_msg,lv_values.
        IF lst_vbpa_addr-land1 IS NOT INITIAL.
          lv_country_msg = text-007.
          lv_msg = lv_country_msg.
          lv_values = lst_vbpa_addr-land1.
        ENDIF.
        IF st_mvke-dwerk IS NOT INITIAL.
          lv_plant_msg = text-011.
          IF lv_msg IS NOT INITIAL.
            CONCATENATE lv_msg ',' lv_plant_msg INTO lv_msg.
            CONCATENATE lv_values ',' st_mvke-dwerk INTO lv_values.
          ELSE.
            lv_msg = lv_plant_msg.
            lv_values = st_mvke-dwerk.
          ENDIF.
        ENDIF.
        IF lv_vsbed_text IS NOT INITIAL.
          lv_vsbed_msg = text-009.
          IF lv_msg IS NOT INITIAL.
            CONCATENATE lv_msg ',' lv_vsbed_msg INTO lv_msg.
            CONCATENATE lv_values ',' lv_vsbed_text INTO lv_values.
          ELSE.
            lv_msg = lv_vsbed_msg.
            lv_values = lv_vsbed_text.
          ENDIF.
        ENDIF.
        IF lst_vbpa_addr-pstlz IS NOT INITIAL.
          lv_pstlz_msg = text-010.
          IF lv_msg IS NOT INITIAL.
            CONCATENATE lv_msg ',' lv_pstlz_msg INTO lv_msg.
            CONCATENATE lv_values ',' lst_vbpa_addr-pstlz INTO lv_values.
          ELSE.
            lv_msg = lv_pstlz_msg.
            lv_values = lst_vbpa_addr-pstlz.
          ENDIF.
        ENDIF.

        CONCATENATE text-001 lv_msg INTO lv_msg.
        CONCATENATE lv_msg lv_values INTO v_msg SEPARATED BY ' - '.

      ENDIF.
    ENDIF.
  ENDIF.
*---*EOC INC0298878:7/29/2020
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADDITIONAL_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_additional_info.
  CLEAR  : st_knvv.
  CALL FUNCTION 'KNVV_SINGLE_READ'
    EXPORTING
      i_kunnr         = jksecontrindex-soldto
      i_vkorg         = jksecontrindex-vkorg
      i_vtweg         = jksecontrindex-vtweg
      i_spart         = jksecontrindex-spart
    IMPORTING
      o_knvv          = st_knvv
    EXCEPTIONS
      not_found       = 1
      parameter_error = 2
      kunnr_blocked   = 3
      OTHERS          = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  CLEAR : v_lifnr.
*--*Consider only when constant table entry active.
  CLEAR:v_vendor_maintained.
  IF lir_vendor[] IS NOT INITIAL.
    v_vendor_maintained = abap_true.
    SELECT SINGLE lifnr INTO v_lifnr FROM eord WHERE matnr = st_mvke-matnr
                                               AND werks = st_mvke-dwerk
                                               AND flifn = abap_true.
    IF sy-subrc EQ 0.
*--*Do nothing
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PREREQUISITES_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_prerequisites_check .
  DATA: lt_constants TYPE zcat_constants.

  CLEAR: v_prerequisite_fail.

  lt_constants[] = li_constants_e231[].

  "Below 2 paramenters should be removed as they are not controlled by end users
  DELETE lt_constants WHERE param1 = 'ITEM_CAT_GRP'.
  DELETE lt_constants WHERE param1 = 'CONTRACT_TYPE'.


  IF lt_constants[] IS INITIAL.
    "all the checks are deactivated by end uers in foreground..
    v_prerequisite_fail = abap_true.
    RETURN. "No need of additional check
  ENDIF.



ENDFORM.
