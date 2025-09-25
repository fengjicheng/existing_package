class ZCL_IM_QTCEI_ISM_MATMAS definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_BADI_MATMAS_ALE_IN .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_QTCEI_ISM_MATMAS IMPLEMENTATION.


  method IF_EX_BADI_MATMAS_ALE_IN~CHANGE_UEB_TAB.
*-------------------------------------------------------------------
* REVISION NO :  ED2K925269                                            *
* REFERENCE NO:  ASOTC-406                                             *
* DEVELOPER   : Rajkumar Madavoina(MRAJKUMAR)                          *
* DATE        : 04/05/2022                                             *
* DESCRIPTION : As part of ASOTC-496 Requirement,Updating              *
*               MARA-ZZSTEP_UUID through IDoc segment E1MARAM-MFPRN    *
*                                                                      *
*----------------------------------------------------------------------*
  "Constants
    CONSTANTS: lc_wricefid_i0401_1 TYPE zdevid VALUE 'I0401.1', " Constant value for WRICEF (I021)
               lc_ser_num_002      TYPE zsno   VALUE '002'.   " Serial Number (001)
  "Data Declaration
    DATA: lv_var_key_i0401_1 TYPE zvar_key, " Variable Key
          lv_activ_flag_2    TYPE flag.     " General Flag
    READ TABLE idoc_contrl
      ASSIGNING FIELD-SYMBOL(<lfs_contrl>) INDEX 1.
    IF  sy-subrc IS INITIAL
    AND <lfs_contrl> IS ASSIGNED.
"   Based on Message type and Message Code combination fetching the
"   Enhancement Control indicator from table.
      CONCATENATE <lfs_contrl>-mestyp
                  <lfs_contrl>-mescod
             INTO lv_var_key_i0401_1.
    ENDIF.
  "Enhancement Control
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricefid_i0401_1  " Constant value for WRICEF
        im_ser_num     = lc_ser_num_002       " Serial Number
        im_var_key     = lv_var_key_i0401_1   " Variable Key (Message Type)
      IMPORTING
        ex_active_flag = lv_activ_flag_2.
    IF   sy-subrc IS INITIAL
    AND  lv_activ_flag_2 IS NOT INITIAL.
      INCLUDE zqtcn_matmas_exten_i0401_1 IF FOUND.
    ENDIF.
  endmethod.
ENDCLASS.
