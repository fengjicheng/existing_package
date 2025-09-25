*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_SAVE_DOCUMENT (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to save data in
*                      additional tables when a document is saved.
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   01/06/2017
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K903817
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* PROGRAM NAME:ZQTCN_USEREXIT_SAVE_DOCUMENT
* PROGRAM DESCRIPTION:Updating auto renewal Plan custom tab;le.
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2017-01-05
* OBJECT ID:E095
* TRANSPORT NUMBER(S)ED2K903817
* BOC by KCHAKRABOR on 2017-01-05 TR#ED2K903817 *
* EOC by KCHAKRABOR on 2017-01-05 TR#ED2K903817 *
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_SAVE_DOC_PREP (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT_PREPARE(MV45AFZZ)"
* PROGRAM DESCRIPTION: NAST Table Update for ZANP/ZANE output for Future Renewal Contracts
* REFERENCE NO: F032 - ERPM-21151
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE: 09-07-2020
* TRANSPORT NUMBER(s): ED2K919397
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K924568
* REFERENCE NO:  OTCM-40685
* DEVELOPER: Nikhilesh Palla (NPALLA)
* DATE:  09/21/2021
* PROGRAM NAME: ZQTCN_MEDIA_SUSPENSION_SAVE (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT(MV45AFZZ)"
* DESCRIPTION: Capture changes to JKSEINTERRUPT to update SLG1 Logs
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* REVISION NO: ED2K926258                                              *
* PROGRAM DESCRIPTION: This enhancmenet will deactivate the ZOA2 output*
*            if the sales org, document type and delvery block matches *
*            as per the constant table entries.                        *
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 03/23/2022                                          *
* OBJECT ID      : E351                                                *
* TRANSPORT NUMBER(S): ED2K926206                                      *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
* BOC by KCHAKRABOR on 16-Nov-2016 TR#ED2K903817 *
CONSTANTS:
  lc_wricef_id_e095 TYPE zdevid   VALUE 'E095', " Development ID
  lc_ser_num_1_e095 TYPE zsno     VALUE '001'.  " Serial Number

DATA:
  lv_actv_flag_e095 TYPE zactive_flag. " Active / Inactive Flag


* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e095
    im_ser_num     = lc_ser_num_1_e095
  IMPORTING
    ex_active_flag = lv_actv_flag_e095.
IF lv_actv_flag_e095 EQ abap_true
  .
*& First Include for separate logic for exclusion of customer
  INCLUDE zqtcn_aut_renewal_plan IF FOUND. " zqtcn_aut_renewal_plan
ENDIF. " IF lv_actv_flag_e095 EQ abap_true
* EOC by KCHAKRABOR on 16-Nov-2016 TR#ED2K903817 *

* Begin of ADD:ERP-6272:WROY:09-Feb-2018:ED2K910582
CONSTANTS:
  lc_wricef_id_e141 TYPE zdevid   VALUE 'E141', " Development ID
  lc_ser_num_4_e141 TYPE zsno     VALUE '004'.  " Serial Number

DATA:
  lv_actv_flag_e141 TYPE zactive_flag.          " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e141
    im_ser_num     = lc_ser_num_4_e141
  IMPORTING
    ex_active_flag = lv_actv_flag_e141.
IF lv_actv_flag_e141 EQ abap_true.
  INCLUDE zqtcn_offline_rel_ord_02 IF FOUND.
ENDIF.
* End   of ADD:ERP-6272:WROY:09-Feb-2018:ED2K910582

* BOC: CR#7463  KKRAVURI20190218  ED2K914492
CONSTANTS:
  lc_wricef_id_e179 TYPE zdevid   VALUE 'E179', " Development ID
  lc_ser_num_1_e179 TYPE zsno     VALUE '001',  " Serial Number
  lc_create_mode    TYPE trtyp    VALUE 'H',
  lc_var_key        TYPE zvar_key VALUE 'UPD_BP_RELTYPE'.

DATA:
  lv_actv_flag_e179 TYPE zactive_flag.          " Active / Inactive Flag

IF t180-trtyp = lc_create_mode AND
   rv45a-docnum IS NOT INITIAL.
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e179
      im_ser_num     = lc_ser_num_1_e179
      im_var_key     = lc_var_key
    IMPORTING
      ex_active_flag = lv_actv_flag_e179.
  IF lv_actv_flag_e179 EQ abap_true.
    INCLUDE zqtcn_upd_bp_reltypes_i0343 IF FOUND.
  ENDIF.
ENDIF.
* EOC: CR#7463  KKRAVURI20190218  ED2K914492
*--------------------------------------------------------------------*
* CR#7899
*--------------------------------------------------------------------*
*--BOC by SKKAIRAMKO -ED2K914447 - CR#7899
IF t180-trtyp = lc_create_mode .
  CONSTANTS:
    lc_wricef_id_e142 TYPE zdevid   VALUE 'E142', " Development ID
    lc_ser_num_4_e142 TYPE zsno     VALUE '002'.  " Serial Number

  DATA:
    lv_actv_flag_e142 TYPE zactive_flag.          " Active / Inactive Flag

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e142
      im_ser_num     = lc_ser_num_4_e142
    IMPORTING
      ex_active_flag = lv_actv_flag_e142.
  IF lv_actv_flag_e142 EQ abap_true.
    INCLUDE zqtcn_gracing_rel_ord_02 IF FOUND.
  ENDIF.
ENDIF.
*--BOC by SKKAIRAMKO -ED2K914447 - CR#7899
* BOC by SGUDA on 2020-09-07 TR# ED2K919397 ERPM-21151
CONSTANTS: lc_wricef_id_e112 TYPE zdevid VALUE 'E112', " Development ID
           lc_ser_num_e112   TYPE zsno   VALUE '002',  " Serial Number
           lc_creat          TYPE trtyp  VALUE 'H',      " Transaction type
           lc_chnge          TYPE c      VALUE 'V'.    " Change mode


DATA: lv_actv_flag_e112    TYPE zactive_flag. " Active / Inactive Flag

IF t180-trtyp = lc_creat OR " Create Mode
   t180-trtyp = lc_chnge.    " Change Mode
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e112
      im_ser_num     = lc_ser_num_e112
    IMPORTING
      ex_active_flag = lv_actv_flag_e112.

  IF lv_actv_flag_e112 EQ abap_true.
    INCLUDE zqtcn_frm_inv_ord_save_e112 IF FOUND.
  ENDIF. " IF lv_actv_flag EQ abap_true
ENDIF. " IF t180-trtyp = lc_create OR t180-trtyp = lc_change.
* EOC by SGUDA on 2020-09-07 TR# ED2K919397 ERPM-21151

* BOC by NPALLA on 09/21/2021 for OTCM-40685 with ED2K924568*
  CONSTANTS: lc_wricef_id_i0229  TYPE zdevid VALUE 'I0229'. "Constant value for WRICEF (I0229)
  CONSTANTS: lc_ser_num_i0229_11 TYPE zsno   VALUE '011'.     " Sequence Number (009)
  DATA: lv_actv_flag_i0229_11    TYPE zactive_flag.  " Active / Inactive flag

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0229       " Constant value for WRICEF (I0229)
      im_ser_num     = lc_ser_num_i0229_11       " Serial Number (010)
    IMPORTING
      ex_active_flag = lv_actv_flag_i0229_11.    "Active / Inactive flag
  IF lv_actv_flag_i0229_11 = abap_true .
    INCLUDE zqtcn_media_suspen_save_i0229 IF FOUND.
  ENDIF.
* EOC by NPALLA on 09/21/2021 for OTCM-40685 with ED2K924568*
**Begin of OTCM-53031:MRAJKUMAR:23-MAR-2022:ED2K926258
  CONSTANTS: lc_wricef_id_e351 TYPE zdevid VALUE 'E351', " Development ID
             lc_ser_num_e351   TYPE zsno   VALUE '002'.  " Serial Number
  DATA:  lv_actv_flag_e351    TYPE zactive_flag.

  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e351
      im_ser_num     = lc_ser_num_e351
    IMPORTING
      ex_active_flag = lv_actv_flag_e351.

  IF lv_actv_flag_e351 = abap_true.
    INCLUDE zqtcn_delvblk_outputblock_e351 IF FOUND.
  ENDIF.
**End of OTCM-53031:MRAJKUMAR:23-MAR-2022:ED2K926258

*Begin of POC for OTCM-64057
CONSTANTS:
  lc_wricef_id_e369 TYPE zdevid VALUE 'E369',       "Constant value for WRICEF (E369)
  lc_ser_num_e369   TYPE zsno   VALUE '001',        "Serial Number (001)
  lc_bu_id_type TYPE bu_id_type VALUE 'ZLGRP',
  lc_kappl      TYPE kappl VALUE 'V',
  lc_kschl      TYPE kschg VALUE 'Z003',
  lc_chgmd      TYPE t180-trtyp VALUE 'V'.

*DATA:
STATICS:
  lv_actv_flag_e369 TYPE zactive_flag.              "Active / Inactive flag

DATA:lv_idnumber   TYPE but0id-idnumber,
     lv_lic_id_grp TYPE zzlic_id_grp,
     lv_mtart      TYPE mara-mtart,
     lst_kotg504   TYPE kotg504.

IF lv_actv_flag_e369 IS INITIAL.
* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e369            "Constant value for WRICEF (E369)
      im_ser_num     = lc_ser_num_e369              "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_e369.           "Active / Inactive flag

  IF lv_actv_flag_e369 IS INITIAL.
    lv_actv_flag_e369 = abap_undefined.
  ENDIF.
ENDIF. "IF lv_actv_flag_e369 IS INITIAL.

IF lv_actv_flag_e369 is NOT INITIAL AND vbak-kunnr IS NOT INITIAL AND vbap-matnr IS NOT INITIAL AND t180-trtyp = lc_chgmd.
** Get Licence ID Group Value
  SELECT SINGLE idnumber FROM but0id INTO lv_idnumber WHERE partner EQ vbak-kunnr AND
                                                            type    EQ lc_bu_id_type.
  IF sy-subrc IS INITIAL.
    lv_lic_id_grp = abap_true.
*- Populate to Material Listing/Exclusion - Item
*    kompg-zzlic_id_grp = abap_true.                     " Licence ID Group
  ENDIF. "IF sy-subrc IS INITIAL.

** Get material type details
  SELECT SINGLE mtart FROM mara INTO lv_mtart WHERE matnr = vbap-matnr.
  IF sy-subrc IS NOT INITIAL.
    CLEAR lv_mtart.
  ENDIF.

** Check if condition record exists with the combination, if yes then pass the error message
  SELECT SINGLE * FROM kotg504 INTO lst_kotg504 WHERE kappl = lc_kappl AND
                                                      kschl = lc_kschl AND
                                                      vkorg = vbak-vkorg AND
                                                      auart = vbak-auart AND
                                                      vkbur = vbak-vkbur AND
                                                      zzlic_id_grp = lv_lic_id_grp AND
                                                      mtart = lv_mtart AND
                                                      ( datab LE sy-datum AND datbi GE sy-datum ) .
  IF sy-subrc IS INITIAL.
    MESSAGE 'Single issue sale is not applicable at DDP rate for EAL customer' TYPE 'E'. "Single issue sale is not applicable at DDP rate for EAL customer
  ENDIF. "IF sy-subrc IS INITIAL.
ENDIF. "IF vbak-kunnr IS NOT INITIAL AND vbap-matnr IS NOT INITIAL.
*End of POC for OTCM-64057
