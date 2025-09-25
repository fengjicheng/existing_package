"Name: \PR:SAPFV45P\EX:VBAP_MATNR_PRUE_TEIL2_02\EI
ENHANCEMENT 0 ZQTCEI_MATERIAL_STATUS_MSG.
*----------------------------------------------------------------------
* PROGRAM NAME        : ZQTCEI_MATERIAL_STATUS_MSG
* PROGRAM DESCRIPTION : Manipulate message for Material Status Validation based on PO Type
* DEVELOPER           : PBANDLAPAL(Pavan Bandlapalli)
* CREATION DATE       : 15-Aug-2017
* OBJECT ID           : Common to orders interfaces
* TRANSPORT NUMBER(S) : ED2K907834
* DESCRIPTION:          To allow the obsolete/discontinued materials to post the idoc
*                       with out any error. we are converting the error to information
*                       so that the idoc gets posted.
*----------------------------------------------------------------------
* BOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
* To allow the obsolete/discontinued materials to post the idoc with out any error.
* we are converting the error to information so that the idoc gets posted.

************* Start of Enhancement for I0297 *******************
*** This enhancement is for I0297 and this is to change material status message from
* error to information.
  CONSTANTS:
    lc_wricef_id_i0297 TYPE zdevid   VALUE 'I0297',    "Constant value for WRICEF (I0297)
    lc_var_key_i0297   TYPE zvar_key VALUE 'PO_TYPE',  "Variable Key
    lc_ser_num_i0297   TYPE zsno     VALUE '002'.      "Serial Number (002)

  DATA:
    lv_actv_flag_i0297 TYPE zactive_flag. "Active / Inactive flag

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0297  "Constant value for WRICEF (i0297)
      im_ser_num     = lc_ser_num_i0297    "Serial Number (002)
      im_var_key     = lc_var_key_i0297    "Variable Key (PO Type)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0297. "Active / Inactive flag

  IF lv_actv_flag_i0297 = abap_true.
    INCLUDE zqtcn_mat_sta_potype_chk_i0297 IF FOUND.
  ENDIF. " IF lv_actv_flag_i0297 = abap_true
************* End of Enhancement for I0297 *******************
* EOC by PBANDLAPAL on 15-Aug-2017 for CR#632: ED2K907834
*----------------------------------------------------------------------
* PROGRAM DESCRIPTION : During the renewal process changeCVBAP-UEPOS as zero
* DEVELOPER           : mimmadiset(murali)
* CREATION DATE       : 02-June-2020
* OBJECT ID           : renewal process
* TRANSPORT NUMBER(S) : ED2K918348
* DESCRIPTION:         During the renewal process using tcode VA46, we want to copy 1 line item
*  from the new partner contract to a new contract document for the renewal,
*but we want to copy only the Partner Fee material.
*The partner fee material happens to be part of the New Partner BOM.
*Therefore, SAP is forcing the BOM header material to be copied as well,
*but this will disrupt our pricing strategy and is not wanted.
*----------------------------------------------------------------------
************* Start of Enhancement for E245*******************
*** This enhancement is for E245 and this is to change CVBAP-UEPOS as zero
  CONSTANTS:
    lc_wricef_id_E245 TYPE zdevid   VALUE 'E245',     "Constant value for WRICEF (E245)
    lc_var_key_E245   TYPE zvar_key VALUE '',         "Variable Key
    lc_ser_num_E245   TYPE zsno     VALUE '001'.      "Serial Number (001)

  DATA:
    lv_actv_flag_E245 TYPE zactive_flag. "Active / Inactive flag

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_E245  "Constant value for WRICEF (E245)
      im_ser_num     = lc_ser_num_E245    "Serial Number (001)
      im_var_key     = lc_var_key_E245    "Variable Key
    IMPORTING
      ex_active_flag = lv_actv_flag_E245. "Active / Inactive flag

  IF lv_actv_flag_E245 = abap_true.
    INCLUDE zqtcn_WLS_RENEWAL_E245 IF FOUND.
  ENDIF. " IF lv_actv_flag_E245 = abap_true

* Begin of change SISIREDDY EAM-1111/E502 11-April-2022 ED2K926690
CONSTANTS: lc_wricef_id_e502 TYPE zdevid   VALUE 'E502',  " Development ID
           lc_ser_num_1_e502 TYPE zsno     VALUE '001'.   " Serial Number

DATA: lv_actv_flag_e502 TYPE zactive_flag.                " Activation flag
* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e502
    im_ser_num     = lc_ser_num_1_e502
  IMPORTING
    ex_active_flag = lv_actv_flag_e502.

IF lv_actv_flag_e502 EQ abap_true.
 INCLUDE zqtcn_apl_matnr_excl_e502.
ENDIF.
* End of change  SISIREDDY EAM-1111/E502 11-April-2022 ED2K926690

ENDENHANCEMENT.
