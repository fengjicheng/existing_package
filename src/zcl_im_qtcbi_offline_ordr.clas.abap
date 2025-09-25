class ZCL_IM_QTCBI_OFFLINE_ORDR definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ISM_SE_ORDERCREATION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_QTCBI_OFFLINE_ORDR IMPLEMENTATION.


  METHOD if_ex_ism_se_ordercreation~buffer_data_for_framework.
  ENDMETHOD.


  METHOD if_ex_ism_se_ordercreation~change_data_before_rfc.

    CONSTANTS:
      lc_wricef_id      TYPE zdevid VALUE 'E141', " Development ID
      lc_wricef_id_e142 TYPE zdevid VALUE 'E142', "++SKKAIRAMKO
      lc_ser_num   TYPE zsno   VALUE '003',  " Serial Number
      lc_ser_num_002   TYPE zsno   VALUE '002'.  " Serial Number

    DATA:
      lv_actv_flag TYPE zactive_flag.        " Active / Inactive Flag

*   To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id
        im_ser_num     = lc_ser_num
      IMPORTING
        ex_active_flag = lv_actv_flag.

    IF lv_actv_flag EQ abap_true.
      INCLUDE zqtcn_offline_rel_ord_01 IF FOUND.
    ENDIF.

*--------------------------------------------------------------------*
* Deterime Item Category for Gracing
*--------------------------------------------------------------------*
*--Begin of change for CR#7899 - SKKAIRAMKO - 02/12/2019
*   To check enhancement is active or not
    CLEAR lv_actv_flag.
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e142
        im_ser_num     = lc_ser_num_002
      IMPORTING
        ex_active_flag = lv_actv_flag.

    IF lv_actv_flag EQ abap_true.
        INCLUDE zqtcn_determine_pstyv_for_grc IF FOUND.
    ENDIF.
*--End of change for CR#7899 - SKKAIRAMKO - 02/12/2019
  ENDMETHOD.


  method IF_EX_ISM_SE_ORDERCREATION~SET_FIELDS_R3.

  endmethod.
ENDCLASS.
