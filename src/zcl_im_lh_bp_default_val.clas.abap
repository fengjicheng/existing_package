class ZCL_IM_LH_BP_DEFAULT_VAL definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ISM_BP_DEFAULT_VALUE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_LH_BP_DEFAULT_VAL IMPLEMENTATION.


  METHOD if_ex_ism_bp_default_value~set_default_values.
*----------------------------------------------------------------------*
* PROGRAM: IF_EX_ISM_BP_DEFAULT_VALUE~SET_DEFAULT_VALUES.
* PROGRAM DESCRIPTION: Customer Default Settings
* DEVELOPER: Sunil Kairamkonda (SKKAIRAMKO)
* CREATION DATE:   03/13/2019
* OBJECT ID:  E191
* TRANSPORT NUMBER(S):  ED2K914681
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915283
* REFERENCE NO: E191
* DEVELOPER: Sunil kumar Kairamkonda(SKKAIRAMKO)
* DATE:  06/12/2019
* DESCRIPTION: Set defalts changes extended for other company code and sales area
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*

* Local Data
    DATA:
      lv_actv_e191  TYPE zactive_flag .

* Local constants
    CONSTANTS:
      lc_devid_e191   TYPE zdevid  VALUE 'E191',    " Development ID: E191
      lc_sno_e191_001 TYPE zsno    VALUE '001'.     " Serial Number: 001
*--------------------------------------------------------------------*
* To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_devid_e191                " Development ID: E191
        im_ser_num     = lc_sno_e191_001              " Serial Number: 001
      IMPORTING
        ex_active_flag = lv_actv_e191.                " Active / Inactive Flag
    IF lv_actv_e191 EQ abap_true.                     " Enhancement is not Active
      INCLUDE zqtcn_bp_set_default_values IF FOUND.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
