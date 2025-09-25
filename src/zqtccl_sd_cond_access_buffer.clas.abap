class ZQTCCL_SD_COND_ACCESS_BUFFER definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_SD_COND_ACCESS_BUFFER .
protected section.
private section.

  constants C_KAPPL_V type KAPPL value 'V' ##NO_TEXT.
  constants C_KOTAB_A911 type KOTAB value 'A911' ##NO_TEXT.
ENDCLASS.



CLASS ZQTCCL_SD_COND_ACCESS_BUFFER IMPLEMENTATION.


  METHOD if_ex_sd_cond_access_buffer~activate.
*----------------------------------------------------------------------*
* PROGRAM NAME: D_COND_ACCESS_BUFFER~ACTIVATE" (BADI Method)
* PROGRAM DESCRIPTION: Activate Program Buffer for Cond Table A911
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   30-NOV-2017
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K909087
*----------------------------------------------------------------------*

    CONSTANTS:
      lc_wricef_id_e075 TYPE zdevid   VALUE 'E075',  " Development ID
      lc_ser_num_8_e075 TYPE zsno     VALUE '008'.   " Serial Number

    DATA:
      lv_actv_flag_e075 TYPE zactive_flag.           " Active / Inactive Flag

*   To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e075
        im_ser_num     = lc_ser_num_8_e075
      IMPORTING
        ex_active_flag = lv_actv_flag_e075.

    IF lv_actv_flag_e075 EQ abap_true.
      INCLUDE zqtcn_sd_cond_access_buffer IF FOUND.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
