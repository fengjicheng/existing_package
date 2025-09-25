*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_KOMPG (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_KOMPG(MV45AFZA)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the communication workarea for product
*                      listing or exclusion.
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   06/08/2018
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K912244
*----------------------------------------------------------------------*
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the communication workarea for product
*                      listing or exclusion.
* DEVELOPER: Siva Guda (sguda)
* CREATION DATE:   07/29/2020
* OBJECT ID: E257
* TRANSPORT NUMBER(S): ED2K919014
*----------------------------------------------------------------------*

CONSTANTS:
  lc_wricef_id_e257 TYPE zdevid VALUE 'E257', " Development ID
  lc_ser_num_1_e257 TYPE zsno   VALUE '001'.  " Serial Number

DATA:
  lv_actv_flag_e257 TYPE zactive_flag .       " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e257
    im_ser_num     = lc_ser_num_1_e257
  IMPORTING
    ex_active_flag = lv_actv_flag_e257.

IF lv_actv_flag_e257 EQ abap_true.
  INCLUDE zqtcn_prod_listing_excl_e257 IF FOUND.
ENDIF. " IF lv_actv_flag EQ abap_true


** BOC VCHITTIBAL ** POC **
DATA:lv_idnumber   TYPE but0id-idnumber,
     lv_lic_id_grp TYPE zzlic_id_grp,
     lv_mtart      TYPE mara-mtart,
     lst_kotg504   TYPE kotg504.
IF vbak-kunnr IS NOT INITIAL AND vbap-matnr IS NOT INITIAL.
  SELECT SINGLE idnumber FROM but0id INTO lv_idnumber WHERE partner EQ vbak-kunnr AND
                                                            type    EQ 'ZLGRP'.
  IF sy-subrc IS INITIAL.
*    kompg-zzlic_id_grp = abap_true.
    lv_lic_id_grp = abap_true.
  ENDIF.

  SELECT SINGLE mtart FROM mara INTO lv_mtart WHERE matnr = vbap-matnr.
  IF sy-subrc IS NOT INITIAL.
    CLEAR lv_mtart.
  ENDIF.
  SELECT SINGLE * FROM kotg504 INTO lst_kotg504 WHERE kappl = 'V' AND
                                                      kschl = 'Z003' AND
                                                      vkorg = vbak-vkorg AND
                                                      auart = vbak-auart AND
                                                      vkbur = vbak-vkbur AND
                                                      zzlic_id_grp = lv_lic_id_grp AND
                                                      mtart = lv_mtart AND
                                                      ( datab LE sy-datum AND datbi GE sy-datum ) .
  IF sy-subrc IS INITIAL.
    MESSAGE 'Single issue sale is not applicable at DDP rate for EAL customer' TYPE 'E'.
  ENDIF.
ENDIF.
** EOC VCHITTIBAL ** POC **
