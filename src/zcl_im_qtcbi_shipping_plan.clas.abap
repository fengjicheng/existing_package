class ZCL_IM_QTCBI_SHIPPING_PLAN definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ISM_SHIPPING_PLAN .
protected section.
private section.

  class-data I_SHIPPING_SCH type RJKSENIP_TAB .
  constants C_END_DATE type DATUM value '99991231' ##NO_TEXT.
ENDCLASS.



CLASS ZCL_IM_QTCBI_SHIPPING_PLAN IMPLEMENTATION.


  METHOD if_ex_ism_shipping_plan~set_attributes.
*----------------------------------------------------------------------*
* ENHANCEMENT NAME: ZQTCBI_SHIPPING_PLAN
* PROGRAM DESCRIPTION: Create Shipping plan via BADI
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   2016-12-27
* OBJECT ID: E139
* TRANSPORT NUMBER(S): ED2K903924
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
    CONSTANTS:
      lc_wricef_id_e139 TYPE zdevid  VALUE 'E139', " Development ID
      lc_ser_num_1_e139 TYPE zsno    VALUE '001'.  " Serial Number

    DATA:
      lv_actv_flag_e139 TYPE zactive_flag .        " Active / Inactive Flag

* To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e139
        im_ser_num     = lc_ser_num_1_e139
      IMPORTING
        ex_active_flag = lv_actv_flag_e139.
    IF lv_actv_flag_e139 EQ abap_true.
      INCLUDE zqtcn_set_shipping_plan_attr IF FOUND.
    ENDIF. " IF lv_actv_flag EQ abap_true

  ENDMETHOD.


  method IF_EX_ISM_SHIPPING_PLAN~SET_DESCRIPTION.
  endmethod.


  method IF_EX_ISM_SHIPPING_PLAN~STATUS_CHANGED.
  endmethod.
ENDCLASS.
