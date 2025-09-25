*----------------------------------------------------------------------*
* PROGRAM NAME:ZXM08U26
* PROGRAM DESCRIPTION: Include program for User Exit for populating
*                      1. Tax code and Tax jurisdiction code in PO and
*                         GL accouting line item
*                      2. Populate the GL line items from custom accouting
*                         segment
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-26
* OBJECT ID:E095 (CR# ERP-6594)
* TRANSPORT NUMBER(S): ED2K912233
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE:   2020-02-08
* OBJECT ID:I0379 (ERPM-11517)
* TRANSPORT NUMBER(S): ED2K917673
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*


*Constant Declaration
CONSTANTS: lc_wricefid_i0353 TYPE zdevid VALUE 'I0353',                   " Constant value for WRICEF (I0353)
           lc_wricefid_i0379 TYPE zdevid VALUE 'I0379',
           lc_ser_num_004    TYPE zsno   VALUE '004',                     " Serial Number (001)
           lc_ser_num_006    TYPE zsno   VALUE '006',                     " Serial Number (006)
           lc_idoc_contrl    TYPE char30 VALUE '(SAPLMRMH)I_IDOC_CONTRL'. " Idoc_contrl of type CHAR30

* Data Declaration
DATA : lv_active_stat TYPE zactive_flag, " Active / Inactive flag
       lv_varkey      TYPE zvar_key,     " Variable Key
       lv_mescod      TYPE edi_mescod.   " Logical Message Variant


CALL FUNCTION 'ZQTC_GET_MESCOD_IPS_I0353'
  IMPORTING
    ex_mescod = lv_mescod.

lv_varkey = lv_mescod.

CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0353
    im_ser_num     = lc_ser_num_004
    im_var_key     = lv_varkey
  IMPORTING
    ex_active_flag = lv_active_stat.

IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true.
* Include to implement logic for determonation of company code
  INCLUDE zqtcn_ips_inv_populate_gl IF FOUND.

ENDIF. " IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true

*-- BOC AKHADIR ERPM-14395 Tr-ED2K916268
*---------------------------------------------------------------------*
* REVISION NO:   ED2K916268
* REFERENCE NO:  ERPM-14395
* DEVELOPER:     Abdul Khadir (AKHADIR)
* DATE:          2020-03-30
* DESCRIPTION:   Added logic to block the invoice for payments if any
*                duplicates are found at FI Invoice Side from Ariba
*---------------------------------------------------------------------*
CLEAR: lv_active_stat.
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0353
    im_ser_num     = lc_ser_num_006
    im_var_key     = lv_varkey
  IMPORTING
    ex_active_flag = lv_active_stat.

IF lv_active_stat EQ abap_true.
*-- Include to implement logic for duplicate FI Vendor Invoice check
  INCLUDE zqtcn_ips_inv_ven_dup_chk IF FOUND.
ENDIF. " IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true

*-- EOC AKHADIR ERPM-14395 Tr-ED2K916268

** BOC MIMMADISET-ED2K917673-2020-03-01
CALL FUNCTION 'ZQTC_GET_MESCOD_IPS_I0379'
  IMPORTING
    ex_mescod = lv_mescod.

lv_varkey = lv_mescod.

CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0379
    im_ser_num     = lc_ser_num_004
    im_var_key     = lv_varkey
  IMPORTING
    ex_active_flag = lv_active_stat.

IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true.
* Include to implement logic for determonation of company code
  INCLUDE zqtcn_ips_inv_pop_gl_i0379_004 IF FOUND.

ENDIF. " IF sy-subrc EQ 0 AND lv_active_stat EQ abap_true
** EOC MIMMADISET-ED2K917673-2020-03-01
