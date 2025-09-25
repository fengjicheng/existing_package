class ZCL_IM_QTCBI_DB_BOM_PRCNTG definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BOM_UPDATE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_QTCBI_DB_BOM_PRCNTG IMPLEMENTATION.


  METHOD if_ex_bom_update~change_at_save.
*----------------------------------------------------------------------*
* PROGRAM NAME: IF_EX_BOM_UPDATE~CHANGE_AT_SAVE (BADI Method)
* PROGRAM DESCRIPTION: Validation for % Allocation for Database BOM
* DEVELOPER: Writtick Roy
* CREATION DATE:   07/06/2017
* OBJECT ID: E162
* TRANSPORT NUMBER(S): ED2K906978
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
    CONSTANTS:
      lc_wricef_id_e162 TYPE zdevid   VALUE 'E162',  " Development ID
      lc_ser_num_1_e162 TYPE zsno     VALUE '001'.   " Serial Number

    DATA:
      lv_actv_flag_e162 TYPE zactive_flag.           " Active / Inactive Flag

*   To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e162
        im_ser_num     = lc_ser_num_1_e162
      IMPORTING
        ex_active_flag = lv_actv_flag_e162.

    IF lv_actv_flag_e162 EQ abap_true.
      INCLUDE zqtcn_db_bom_prc_alloc IF FOUND.
    ENDIF.
  ENDMETHOD.


  method IF_EX_BOM_UPDATE~CHANGE_BEFORE_UPDATE.
  endmethod.


  method IF_EX_BOM_UPDATE~CHANGE_IN_UPDATE.
  endmethod.


  method IF_EX_BOM_UPDATE~CREATE_TREX_CPOINTER.
  endmethod.
ENDCLASS.
