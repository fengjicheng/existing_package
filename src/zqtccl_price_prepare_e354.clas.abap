class ZQTCCL_PRICE_PREPARE_E354 definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_BADI_PIQ_PREPARE .
protected section.
private section.
ENDCLASS.



CLASS ZQTCCL_PRICE_PREPARE_E354 IMPLEMENTATION.


  method IF_BADI_PIQ_PREPARE~ACTIVATE_LEAN_KOMP.
  endmethod.


  method IF_BADI_PIQ_PREPARE~ADAPT_HEAD_ITEM_DATA.
  endmethod.


  METHOD if_badi_piq_prepare~adapt_komk_komp_data.
*&---------------------------------------------------------------------*
* REVISION NO: ED2K926303
* PROGRAM NAME: ZQTCN_MAP_DISCOUNT_DET_E354
* REFRENCE NO  : ASOTC-266
* DEVELOPER: Lahiru Wathudura(LWATHUDURA)
* DATE : 03/25/2022
* OBJECT ID: E354
* DESCRIPTION: Map the caller data values to populate the KOMK & KOMP
*              pricing communication structures
*----------------------------------------------------------------------*

    DATA: lv_var_key_e354   TYPE zvar_key,                    " Variable Key
          lv_actv_flag_e354 TYPE zactive_flag.                " Active / Inactive Flag

    CONSTANTS: lc_wricef_id_e354 TYPE zdevid   VALUE 'E354',  " Development ID
               lc_ser_num_e354_1 TYPE zsno     VALUE '001'.   " Serial Number

* To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e354
        im_ser_num     = lc_ser_num_e354_1
      IMPORTING
        ex_active_flag = lv_actv_flag_e354.

    IF lv_actv_flag_e354 EQ abap_true.
      INCLUDE zqtcn_map_discount_det_e354 IF FOUND.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
