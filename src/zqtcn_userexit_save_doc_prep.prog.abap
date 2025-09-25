*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_SAVE_DOC_PREP (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT_PREPARE(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used for changes or checks,
*                      before a document is saved.
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/21/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K902972
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K903605
* REFERENCE NO:
* DEVELOPER:  Shivangi Priya(SHPRIYA)
* DATE:  2016-09-12
* DESCRIPTION:Enhanced copy control
* Change Tag :
* BOC by SHPRIYA on 2016-09-12 TR#ED2K903605 *
* EOC by SHPRIYA on 2016-09-12 TR#ED2K903605*
*-----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K902972
* REFERENCE NO:  E112
* DEVELOPER:  Lucky Kodwani (LKODWANI)
* DATE:  2016-10-20
* DESCRIPTION:
* Change Tag :
* BOC by LKODWANI on 20-Oct-2016 TR#ED2K902972 *
* EOC by LKODWANI on 20-Oct-2016 TR#ED2K902972*
*-----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K902972
* REFERENCE NO:  E130
* DEVELOPER:  Sarada Mukherjee (SARMUKHERJ)
* DATE:  2016-11-09
* DESCRIPTION:
* Change Tag :
* BOC by SARMUKHERJ on 09-Nov-2016 TR#ED2K902972 *
* EOC by SARMUKHERJ on 09-Nov-2016 TR#ED2K902972 *
*-----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K902972
* REFERENCE NO:  E104
* DEVELOPER:  Kamalendu Chakraborty (KCHAKRABOR)
* DATE:  2016-11-16
* DESCRIPTION:
* Change Tag :
* BOC by KCHAKRABOR on 16-Nov-2016 TR#ED2K902972 *
* EOC by KCHAKRABOR on 16-Nov-2016 TR#ED2K902972 *
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* PROGRAM NAME:ZQTCEI_SET_INCOM_LOG_VBAK
* PROGRAM DESCRIPTION:Setting status for Incompletion.
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-10-20
* OBJECT ID:E111
* TRANSPORT NUMBER(S)ED2K902972
* BOC by KCHAKRABOR on 2016-10-20 TR#ED2K902972 *
* EOC by KCHAKRABOR on 2016-10-20 TR#ED2K902972 *
*-------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBAK (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be used to move some fields
*                      into the sales dokument header workaerea VBAK
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/21/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K902972
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_MV_FLD_TO_VBAK (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This userexit can be changed VBAP-PSTYV (
*                      Sales document item category) to ZCCT if Net price
*                      is 0.01.
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE:   06/14/2016
* OBJECT ID: E173
* TRANSPORT NUMBER(S): ED2K912276
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_SAVE_DOC_PREP (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT_PREPARE(MV45AFZZ)"
* PROGRAM DESCRIPTION: Update PQ Deal Type & Cluster Type for BOM
* components at item level for Subscription Orders
* REFERENCE NO: I0230 - CR#6142
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 07-09-2018
* TRANSPORT NUMBER(s): ED2K912552
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_SAVE_DOC_PREP (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT_PREPARE(MV45AFZZ)"
* PROGRAM DESCRIPTION: Material and Order quantity Block
* REFERENCE NO: E251 - ERPM-17773
* DEVELOPER: Mohammed Aslam (AMOHAMMED)
* CREATION DATE: 07-13-2020
* TRANSPORT NUMBER(s): ED2K918882
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_SAVE_DOC_PREP (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT_PREPARE(MV45AFZZ)"
* PROGRAM DESCRIPTION: Firm Invoice Order Validation
* REFERENCE NO: E254 - ERPM-16414
* DEVELOPER: Mohammed Aslam (AMOHAMMED)
* CREATION DATE: 07-23-2020
* TRANSPORT NUMBER(s): ED2K918988
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_SAVE_DOCUMENT (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT(MV45AFZZ)"
* PROGRAM DESCRIPTION: 1. Validate the Ref doc number, BNAME contract
*                      2. Validate the Sub Ref ID, PO Type, PO number,
*                           Ship To Party “Your Reference” number at
*                           line item with BNAME contract
*                      3. Auto update the ZQTC_RENWL_PLAN table
* REFERENCE NO: E095 - ERPM-15045
* DEVELOPER: Mohammed Aslam (AMOHAMMED)
* CREATION DATE: 09-21-2020
* TRANSPORT NUMBER(s): ED2K919548
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923739
* REFERENCE NO:  OTCM-37780
* DEVELOPER: Krishna Srikanth (Ksrikanth)
* DATE:  2021-06-09
* DESCRIPTION: Auto update the VBAK-ZZFICE to track source of order.
*------------------------------------------------------------------- *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K924524
* REFERENCE NO:  OTCM-47271
* DEVELOPER: Nageswara Polina (NPOLINA)
* DATE:  2021-14-09
* PROGRAM NAME: ZQTCN_WARN_FOR_SHIP_INST_E265 (Include)
*               Called from "userexit_save_document_prepare(MV45AFZZ)"
* DESCRIPTION: Validation to pop-up soft warning in order manual entry process
*------------------------------------------------------------------------- *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K924568
* REFERENCE NO:  OTCM-40685
* DEVELOPER: Nikhilesh Palla (NPALLA)
* DATE:  09/21/2021
* PROGRAM NAME: ZQTCN_MEDIA_SUSPENSION_S_PREP (Include)
*               Called from "userexit_save_document_prepare(MV45AFZZ)"
* DESCRIPTION: Capture changes to JKSEINTERRUPT to update SLG1 Logs
*------------------------------------------------------------------------- *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K925947
* REFERENCE NO:  EAM-8227 / I0504.1
* DEVELOPER: Vamsi Mamillapalli (VMAMILLAPA)
* DATE:  03/04/2022
* PROGRAM NAME: ZQTCN_KNV_EDI_ORDERS(Include)
*               Called from "userexit_save_document_prepare(MV45AFZZ)"
* DESCRIPTION: Capture changes to Inbound Orders Interface from KNV-SAP
*------------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K926641
* REFERENCE NO:  EAM-5945 / E504
* DEVELOPER: Jagadeeswara Rao M (JMADAKA)
* DATE:  07/April/2022
* PROGRAM NAME: ZQTCN_TOKEN_ORDER_CHECK_E504(Include)
*               Called from "userexit_save_document_prepare(MV45AFZZ)"
* DESCRIPTION: Logic to check field value for mandatory token number
*              for credit card payments in the field BSTKD_E from
*              header data(Order data)
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------------*
* REVISION NO: ED2K926690                                                    *
* REFERENCE NO:  EAM-1111 / E502                                             *
* DEVELOPER: Sivarami Isireddy (SISIREDDY)                                   *
* DATE:  07/April/2022                                                       *
* PROGRAM NAME: ZQTCN_AUTO_DEL_INV_BLOCKS_E502(Include)                      *
*               Called from "userexit_save_document_prepare(MV45AFZZ)        *
* DESCRIPTION: Automatic_Delivery Block_Rejection_Rules                      *
*              When a Sales order is created, business requires rules should *
*              be built into SAP that would either reject the order (if rules*
*              suggest that) or insert delivery/ billing block.              *
*--------------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------------*
* REVISION NO: ED2K926921
* REFERENCE NO:  EAM-8514 / E507
* DEVELOPER: Jagadeeswara Rao M (JMADAKA)
* DATE:  21/April/2022
* PROGRAM NAME: ZQTCN_FRIEGHT_CARRIER_E507(Include)
*               Called from "userexit_save_document_prepare(MV45AFZZ)"
* DESCRIPTION: Logic to switch frieght carrier at line item level when the
*              total confirmed quantity weight exceeding 225 Kilo Grams
*----------------------------------------------------------------------------*

* BOC by LKODWANI on 20-Oct-2016 TR#ED2K902972*
CONSTANTS: lc_wricef_id  TYPE zdevid VALUE 'E112', " Development ID
           lc_ser_num    TYPE zsno   VALUE '001',  " Serial Number
           " Begin of ADD:OTCM-37780:KRISHNA:09-JUL-2021
           lc_devid_e112 TYPE zdevid VALUE 'E112', "Development ID
           lc_slno       TYPE zsno   VALUE '2'. " Serial Number
" End of ADD:OTCM-37780:KRISHNA:09-JUL-2021

DATA: lv_actv_flag      TYPE zactive_flag , " Active / Inactive Flag
      lv_actv_flag_e112 TYPE zactive_flag . " Active / Inactive Flag

* To check enhancement is active or not

CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id
    im_ser_num     = lc_ser_num
  IMPORTING
    ex_active_flag = lv_actv_flag.

IF lv_actv_flag EQ abap_true.
  INCLUDE zqtcn_add_subs_ref_id IF FOUND.
ENDIF. " IF lv_actv_flag EQ abap_true
* EOC by LKODWANI on 20-Oct-2016 TR#ED2K902972 *

* BOC by SARMUKHERJ on 09-Nov-2016 TR#ED2K902972 *
CONSTANTS: lc_wricef_id_e130 TYPE zdevid VALUE 'E130', " Development ID
           lc_ser_num_e130   TYPE zsno   VALUE '001'.  " Serial Number

DATA: lv_actv_flag_e130      TYPE zactive_flag . " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e130
    im_ser_num     = lc_ser_num_e130
  IMPORTING
    ex_active_flag = lv_actv_flag_e130.

IF lv_actv_flag_e130 EQ abap_true.
  INCLUDE   zqtcn_sales_rep_assnt IF FOUND.
ENDIF. " IF lv_actv_flag EQ abap_true
* EOC by SARMUKHERJ on 09-Nov-2016 TR#ED2K902972 *

* BOC by KCHAKRABOR on 16-Nov-2016 TR#ED2K902972 *
CONSTANTS:
  lc_wricef_id_e104 TYPE zdevid   VALUE 'E104', " Development ID
  lc_ser_num_1_e104 TYPE zsno     VALUE '001'.  " Serial Number

DATA:
  lv_actv_flag_e104 TYPE zactive_flag.          " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e104
    im_ser_num     = lc_ser_num_1_e104
  IMPORTING
    ex_active_flag = lv_actv_flag_e104.

IF lv_actv_flag_e104 EQ abap_true.
*& First Include for separate logic for exclusion of customer
  INCLUDE zqtcn_aut_rejct_vbap IF FOUND. " zqtcn_aut_rejct_vbap
*& This include for placing blocking ( Delivery/ billing block )
  INCLUDE zqtcn_aut_rejct_vbak IF FOUND. " Include zqtcn_aut_rejct_vbak

ENDIF.
* EOC by KCHAKRABOR on 16-Nov-2016 TR#ED2K902972 *
* BOC by KCHAKRABOR on 2016-10-20 TR#ED2K902972 *
* Data declaration
*& Constants
CONSTANTS:
  lc_wricef_id_e111 TYPE zdevid   VALUE 'E111',  " Development ID
  lc_ser_num_1_e111 TYPE zsno     VALUE '001'.   " Serial Number

DATA:
  lv_actv_flag_e111 TYPE zactive_flag .          " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e111
    im_ser_num     = lc_ser_num_1_e111
  IMPORTING
    ex_active_flag = lv_actv_flag_e111.

IF lv_actv_flag_e111 EQ abap_true.
  INCLUDE zqtcn_set_incom_log_vbak IF FOUND.
ENDIF.
* EOC by KCHAKRABOR on 2016-10-20 TR#ED2K902972 *

* SOC by SHPRIYA on 2016-09-12 TR#ED2K903605 *
* Data declaration
*& Constants
CONSTANTS:
  lc_wricef_id_e059 TYPE zdevid   VALUE 'E059',  " Development ID
  lc_ser_num_1_e059 TYPE zsno     VALUE '1'.   " Serial Number

DATA:
  lv_actv_flag_e059 TYPE zactive_flag .          " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e059
    im_ser_num     = lc_ser_num_1_e059
  IMPORTING
    ex_active_flag = lv_actv_flag_e059.

IF lv_actv_flag_e059 EQ abap_true.
  INCLUDE zqtcn_enh_copy_control_e059 IF FOUND.
ENDIF.
* EOC by SHPRIYA on 2016-09-12 TR#ED2K903605 *
* SOC by SGUDA on 2018-06-14 TR# ED2K912276
CONSTANTS: lc_wricef_id_e173 TYPE zdevid VALUE 'E173', " Development ID
           lc_ser_num_e173   TYPE zsno   VALUE '001'.  " Serial Number

DATA: lv_actv_flag_e173    TYPE zactive_flag . " Active / Inactive Flag
* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e173
    im_ser_num     = lc_ser_num_e173
  IMPORTING
    ex_active_flag = lv_actv_flag_e173.
IF lv_actv_flag_e173 EQ abap_true.
  INCLUDE zqtcn_change_vbap_pstyv IF FOUND.
ENDIF.
* EOC by SGUDA on 2018-06-14 TR# ED2K912276 *

*** Begin of: CR#6142  KKR20180709  ED2K912552
* Local Constants Declaration
CONSTANTS:
  lc_wricef_id_i0230   TYPE zdevid VALUE 'I0230', " Development ID
  lc_ser_num_i0230_004 TYPE zsno VALUE '004',     " Serial Number
  lc_var_key_i0230     TYPE zvar_key VALUE 'PQ_DEAL_CLUSTER_TYPE'. " Variable Key

* Local Variable Declaration
DATA:
  lv_actv_flag_i0230 TYPE zactive_flag. " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0230
    im_ser_num     = lc_ser_num_i0230_004
    im_var_key     = lc_var_key_i0230
  IMPORTING
    ex_active_flag = lv_actv_flag_i0230.
IF lv_actv_flag_i0230 EQ abap_true.
  INCLUDE zqtcn_upd_deal_clus_typ_to_bom IF FOUND.
ENDIF.
*** End of: CR#6142  KKR20180709  ED2K912552

** Begin of ADD:E186(ERP-7515):PRABHU:09-Jan-2019:ED2K914194
** Local Variable Declaration
DATA:
  lv_actv_flag_e186 TYPE zactive_flag. "Active / Inactive Flag

* Local Constant Declaration
CONSTANTS:
  lc_sno_e186_002   TYPE zsno    VALUE '001',   "Serial Number
  lc_wricef_id_e186 TYPE zdevid  VALUE 'E186'. "Development ID

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e186  "Development ID (I0341)
    im_ser_num     = lc_sno_e186_002    "Serial Number (004)
  IMPORTING
    ex_active_flag = lv_actv_flag_e186. "Active / Inactive Flag

IF lv_actv_flag_e186 EQ abap_true. "Check for Active Flag
  INCLUDE zqtcn_validate_con_terminate2 IF FOUND.
ENDIF. " IF lv_actv_flag_i0341 EQ abap_true
* End of ADD:E186(ERP-7515):PRABHU:09-Jan-2019:ED2K914194

**Begin of ADD:E217(ERPM-2213):MIMMADISET:01-10-2019
*Check if order should be put on hold (voucher)
DATA:
  lv_actv_flag_e217 TYPE zactive_flag. "Active / Inactive Flag

* Local Constant Declaration
CONSTANTS:
  lc_sno_e217_001   TYPE zsno    VALUE '001',   "Serial Number
  lc_wricef_id_e217 TYPE zdevid  VALUE 'E217'. "Development ID

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e217  "Development ID (I0217)
    im_ser_num     = lc_sno_e217_001    "Serial Number (001)
  IMPORTING
    ex_active_flag = lv_actv_flag_e217. "Active / Inactive Flag

IF lv_actv_flag_e217 EQ abap_true. "Check for Active Flag
  INCLUDE zqtcn_voucher_hold_e217 IF FOUND.
ENDIF. " IF lv_actv_flag_i0217 EQ abap_true

*** BOC: I0378(ERPM-197) KKRAVURI:26-DEC-2019:ED2K917150
* Local Variable declaration
DATA:
  lv_aflag_i0378 TYPE zactive_flag. "Active / Inactive Flag

* Local Constants Declaration
CONSTANTS:
  lc_sno_003_i0378   TYPE zsno     VALUE '003',   " Serial Number
  lc_wricef_id_i0378 TYPE zdevid   VALUE 'I0378', " Development ID
  lc_create_i0378    TYPE trtyp    VALUE 'H',     " Tx Type: Create
  lc_change_i0378    TYPE trtyp    VALUE 'V',     " Tx Type: Change
  lc_vkey_i0378      TYPE zvar_key VALUE 'NETVAL_VALIDATION'. " Variable Key

IF ( t180-trtyp = lc_create_i0378 AND rv45a-docnum IS NOT INITIAL ) OR
     t180-trtyp = lc_change_i0378.
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_i0378 " Development ID (I0378)
      im_ser_num     = lc_sno_003_i0378   " Serial Number (003)
      im_var_key     = lc_vkey_i0378
    IMPORTING
      ex_active_flag = lv_aflag_i0378.    " Active / Inactive Flag

  IF lv_aflag_i0378 = abap_true. " Check for Active Flag
    INCLUDE zqtcn_woa_netvalue_val_i0378 IF FOUND.
  ENDIF. " IF lv_aflag_i0378 = abap_true
ENDIF.
*** EOC: I0378(ERPM-197) KKRAVURI:26-DEC-2019:ED2K917150

* Begin by AMOHAMMED on 07-13-2020 TR# ED2K918882
CONSTANTS: lc_wricef_id_e251 TYPE zdevid VALUE 'E251', " Development ID
           lc_ser_num_e251   TYPE zsno   VALUE '001',  " Serial Number
           lc_chnge          TYPE c      VALUE 'V'.    " Change mode

DATA: lv_actv_flag_e251    TYPE zactive_flag . " Active / Inactive Flag

IF t180-trtyp = lc_chnge.
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e251
      im_ser_num     = lc_ser_num_e251
    IMPORTING
      ex_active_flag = lv_actv_flag_e251.

  IF lv_actv_flag_e251 EQ abap_true.
    INCLUDE zqtcn_matnr_kwmeng_block_e251 IF FOUND.
  ENDIF. " IF lv_actv_flag EQ abap_true
ENDIF. " IF t180-trtyp = lc_change.
* Begin by AMOHAMMED on 07-13-2020 TR# ED2K918882

* Begin by AMOHAMMED on 07-23-2020 TR# ED2K918988
CONSTANTS: lc_wricef_id_e254 TYPE zdevid VALUE 'E254', " Development ID
           lc_ser_num_e254   TYPE zsno   VALUE '001',  " Serial Number
           lc_creat          TYPE trtyp  VALUE 'H'.      " Transaction type

DATA: lv_actv_flag_e254    TYPE zactive_flag . " Active / Inactive Flag

IF t180-trtyp = lc_creat OR " Create Mode
   t180-trtyp = lc_chnge.    " Change Mode
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e254
      im_ser_num     = lc_ser_num_e254
    IMPORTING
      ex_active_flag = lv_actv_flag_e254.

  IF lv_actv_flag_e254 EQ abap_true.
    INCLUDE zqtcn_frm_inv_ord_save_e254 IF FOUND.
  ENDIF. " IF lv_actv_flag EQ abap_true
ENDIF. " IF t180-trtyp = lc_create OR t180-trtyp = lc_change.
* Begin by AMOHAMMED on 07-23-2020 TR# ED2K918988

* Begin by AMOHAMMED on 09-21-2020 TR# ED2K919548
CONSTANTS:
  lc_wricefid_e095  TYPE zdevid   VALUE 'E095', " Development ID
  lc_ser_num_7_e095 TYPE zsno     VALUE '007'.  " Serial Number

DATA:
  lv_actv_flg_e095 TYPE zactive_flag. " Active / Inactive Flag

IF t180-trtyp = lc_creat OR " Create Mode
   t180-trtyp = lc_chnge.   " Change Mode
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricefid_e095
      im_ser_num     = lc_ser_num_7_e095
    IMPORTING
      ex_active_flag = lv_actv_flg_e095.
  IF lv_actv_flg_e095 EQ abap_true.
    INCLUDE zqtcn_aut_renewal_plan_e095 IF FOUND. " zqtcn_aut_renewal_plan_e095
  ENDIF. " IF lv_actv_flag_e095 EQ abap_true
ENDIF. " IF t180-trtyp = lc_create.
* End by AMOHAMMED on 09-21-2020 TR# ED2K919548

" Begin of ADD:OTCM-37780:KRISHNA:09-JUL-2021
* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_devid_e112
    im_ser_num     = lc_slno
  IMPORTING
    ex_active_flag = lv_actv_flag_e112.

" IF lv_actv_flag_e112 EQ abap_true
IF lv_actv_flag_e112 EQ abap_true.
  INCLUDE zqtcn_track_order_source_e112 IF FOUND.
ENDIF.
" End of ADD:OTCM-37780:KRISHNA:09-JUL-2021

"Begin of ADD: OTCM-47271:NPOLINA:14-SEP-2021

CONSTANTS: lc_wricef_id_e265 TYPE zdevid VALUE 'E265', " Development ID
           lc_ser_num_e265   TYPE zsno   VALUE '002',  " Serial Number
           lc_cremd          TYPE trtyp  VALUE 'H',      " Transaction type Create Mode
           lc_chgmd          TYPE trtyp  VALUE 'V'.   "Transaction Type: Change Mode


DATA: lv_actv_flag_e265    TYPE zactive_flag . " Active / Inactive Flag

IF t180-trtyp = lc_cremd OR " Create Mode
   t180-trtyp = lc_chgmd.    " Change Mode
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e265
      im_ser_num     = lc_ser_num_e265
    IMPORTING
      ex_active_flag = lv_actv_flag_e265.

  IF lv_actv_flag_e265 EQ abap_true.

    INCLUDE zqtcn_warn_for_ship_inst_e265 IF FOUND.
  ENDIF. " IF lv_actv_flag EQ abap_true
ENDIF.

"End of ADD: OTCM-47271:NPOLINA:14-SEP-2021


* BOC by NPALLA on 09/21/2021 for OTCM-40685 with ED2K924568*
CONSTANTS: lc_wricef_id_i0229  TYPE zdevid VALUE 'I0229'. "Constant value for WRICEF (I0229)
CONSTANTS: lc_ser_num_i0229_10 TYPE zsno   VALUE '010'.     " Sequence Number (009)
DATA: lv_actv_flag_i0229_10    TYPE zactive_flag.  " Active / Inactive flag

CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0229       " Constant value for WRICEF (I0229)
    im_ser_num     = lc_ser_num_i0229_10      " Serial Number (009)
  IMPORTING
    ex_active_flag = lv_actv_flag_i0229_10.   " Active / Inactive flag
IF lv_actv_flag_i0229_10 = abap_true .
  INCLUDE zqtcn_media_suspen_spre_i0229 IF FOUND.
ENDIF.
* EOC by NPALLA on 09/21/2021 for OTCM-40685 with ED2K924568*
*BOC VMAMILLAPA on 03/04/2022 for EAM-8227 with ED2K925947
CONSTANTS: lc_wricef_i0504_1 TYPE zdevid VALUE 'I0504.1', "Constant value for WRICEF (I0229)
           lc_ser_num_001    TYPE zsno   VALUE '001'.     "Sequence Number (001)
DATA: lv_actv_flag_i0504_1    TYPE zactive_flag.           "Active / Inactive flag

CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_i0504_1       " Constant value for WRICEF (I0229)
    im_ser_num     = lc_ser_num_001          " Serial Number (009)
  IMPORTING
    ex_active_flag = lv_actv_flag_i0504_1.   " Active / Inactive flag
IF lv_actv_flag_i0504_1 = abap_true .
  INCLUDE zqtcn_knv_edi_orders_i0504 IF FOUND.
ENDIF.
*EOC VMAMILLAPA on 03/04/2022 for EAM-8227 with ED2K925947


* Begin of change JMADAKA EAM-5945/E504 07-April-2022 ED2K926641
CONSTANTS: lc_wricef_id_e504 TYPE zdevid   VALUE 'E504',  " Development ID
           lc_ser_num_1_e504 TYPE zsno     VALUE '001'.   " Serial Number

DATA: lv_actv_flag_e504 TYPE zactive_flag.                " Activation flag
* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e504
    im_ser_num     = lc_ser_num_1_e504
  IMPORTING
    ex_active_flag = lv_actv_flag_e504.

IF lv_actv_flag_e504 EQ abap_true.
  INCLUDE zqtcn_token_order_check_e504 IF FOUND. " Include zqtcn_token_order_check_e504
ENDIF.
* End of change JMADAKA EAM-5945/E504 07-April-2022 ED2K926641

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
  INCLUDE zqtcn_auto_del_inv_blocks_e502 IF FOUND. " zqtcn_auto_del_inv_blocks_e502
ENDIF.
* End of change  SISIREDDY EAM-1111/E502 11-April-2022 ED2K926690



* Begin of change JMADAKA EAM-8514/E507 21-April-2022 ED2K926921
CONSTANTS: lc_wricef_id_e507 TYPE zdevid   VALUE 'E507',  " Development ID
           lc_ser_num_1_e507 TYPE zsno     VALUE '001'.   " Serial Number

DATA: lv_actv_flag_e507 TYPE zactive_flag.                " Activation flag
* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e507
    im_ser_num     = lc_ser_num_1_e507
  IMPORTING
    ex_active_flag = lv_actv_flag_e507.

IF lv_actv_flag_e507 EQ abap_true.
  INCLUDE zqtcn_frieght_carrier_e507 IF FOUND. " INCLUDE zqtcn_frieght_carrier_e507
ENDIF.
* End of change JMADAKA EAM-8514/E507 21-April-2022 ED2K926921


*BOC VMAMILLAPA 28-Sep-2022 SNAP PAY POC
*  TYPES: BEGIN OF ty_edid4,
*          segnum  TYPE idocdsgnum,
*          segnam  TYPE edi_segnam,
*          psgnum  TYPE edi_psgnum,
*          sdata   TYPE edi_sdata,
*         END OF ty_edid4.
  DATA:li_edid4 TYPE STANDARD TABLE OF edid4.
  IF  vbak-crm_guid IS INITIAL AND vbkd-mndid IS INITIAL.
 IF idoc_number IS NOT INITIAL.
*   SELECT segnum
*          segnam
*         DTINT2
*          sdata
*          psgnum
*          tdobname
   SELECT *
   FROM edid4
*   FROM DTINT2
   INTO TABLE li_edid4
   WHERE docnum = idoc_number AND
         segnam = 'E1EDKT1'.
*         ( segnam = 'E1EDKT1' OR
*           segnam = 'E1EDKT2' ).
   IF sy-subrc IS INITIAL.
     DATA: lst_e1edkt1 TYPE e1edkt1,
           lst_e1edkt2 TYPE e1edkt2,
           lv_sdata TYPE char100.
     LOOP AT li_edid4 ASSIGNING FIELD-SYMBOL(<lfs_edid4>) WHERE segnam = 'E1EDKT1'.
*       IF line_exists( li_edid4[ psgnum = <lfs_edid4>-segnum ] ).
**         lst_e1edkt2 = li_edid4[ psgnum = <lfs_edid4>-segnum ]-sdata.*
*       ENDIF.
        lst_e1edkt1 = <lfs_edid4>-sdata.
*     IF lst_e1edkt2-tdline IS NOT INITIAL.
     IF lst_e1edkt1-tdobname IS NOT INITIAL.
       CASE lst_e1edkt1-tdid.
         WHEN 'SN01'.
*           vbak-msr_id = lst_e1edkt2-tdline.
           vbak-wtysc_clm_hdr = lst_e1edkt1-tdobname.
         WHEN 'SN02'.
*           vbak-handoverloc = lst_e1edkt2-tdline.
           vbkd-mndid = lst_e1edkt1-tdobname.
           LOOP AT xvbkd ASSIGNING <lfs_vbkd> WHERE posnr = '000000'.
             <lfs_vbkd>-mndid = lst_e1edkt1-tdobname.
           ENDLOOP.
         WHEN OTHERS.
       ENDCASE.

     ENDIF.
     CLEAR:lst_e1edkt1.
*     lst_e1edkt2,lv_sdata.
     ENDLOOP.
   ENDIF.
   ENDIF.

ENDIF.
