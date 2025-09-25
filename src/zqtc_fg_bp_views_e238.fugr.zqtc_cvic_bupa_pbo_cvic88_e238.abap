FUNCTION zqtc_cvic_bupa_pbo_cvic88_e238.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------
*"----------------------------------------------------------------------
* PROGRAM NAME:ZQTC_CVIC_BUPA_PAI_TAX_E238 (FM)
* PROGRAM DESCRIPTION: This FM is copied from standard FM CVIC_BUPA_PBO_CVIC88
*                      It has been assigned to BP views CVIC88,Transactoin BUPT
* Restricting the chnage of tax category field in BP, to only certain users
* assigned to newlt created authrization object
* DEVELOPER              : Prabhu (PTUFARAM)
* CREATION DATE          : 04/01/2020
* OBJECT ID              : E238/ERPM_10607
* TRANSPORT NUMBER(S)    :ED2K917888
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*&---------------------------------------------------------------------*
  DATA : lv_actv_flag_e238 TYPE zactive_flag.
  CONSTANTS : lc_table_name_knvi TYPE fsbp_table_name    VALUE 'KNVI',
              lc_wricef_id_e238  TYPE zdevid    VALUE 'E238',             " Development ID
              lc_sno_e238_002    TYPE zsno      VALUE '002'.               " Serial Number.
*--*Call standard assigned FM AS IT IS
  CALL FUNCTION 'CVIC_BUPA_PBO_CVIC88'.

*--*Enhancement control
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e238
      im_ser_num     = lc_sno_e238_002
    IMPORTING
      ex_active_flag = lv_actv_flag_e238.
*--*Enhancemnt active check
  IF lv_actv_flag_e238 = abap_true.
    INCLUDE zqtcn_bp_disable_tax_id IF FOUND.
  ENDIF.

ENDFUNCTION.
