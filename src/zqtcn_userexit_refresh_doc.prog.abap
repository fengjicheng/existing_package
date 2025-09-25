*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_REFRESH_DOC (Include)
*               Called from "ZQTCN_USEREXIT_REFRESH_DOCUMENT(MV45AFZA)"
* PROGRAM DESCRIPTION: It is always necessary to refresh user-specific
*                      data before the next document will be processed.
*                      This can be done in this userexit. This userexit
*                      can be used to refresh user-specific data when
*                      the processing of a sales document is finished
*                      - after the document is saved
*                      - when you leave the document processing with F3
*                        or F15
*                      It may be necessary to refresh user-specific data
*                      before the next document will be processed.
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/21/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K902972
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K902972
* REFERENCE NO:  E104
* DEVELOPER:  Kamalendu Chakraborty (KCHAKRABOR)
* DATE:  2016-11-16
* DESCRIPTION: Refreshing user specific variable
* Change Tag :
* BOC by KCHAKRABOR on 16-Nov-2016 TR#ED2K902972 *
* EOC by KCHAKRABOR on 16-Nov-2016 TR#ED2K902972 *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906642
* REFERENCE NO:  E161
* DEVELOPER:  Writtick Roy (WROY)
* DATE:  2017-06-23
* DESCRIPTION: Order Reasons by Document Type
* Change Tag :
* Begin of ADD:E161:WROY:23-JUN-2017:ED2K906642
* End   of ADD:E161:WROY:23-JUN-2017:ED2K906642
*-----------------------------------------------------------------------*
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
  INCLUDE zqtcn_refresh_doc IF FOUND. " zqtcn_refresh_doc
ENDIF.
* EOC by KCHAKRABOR on 16-Nov-2016 TR#ED2K902972 *

* Begin of ADD:E161:WROY:23-JUN-2017:ED2K906642
CONSTANTS:
  lc_wricef_id_e161 TYPE zdevid VALUE 'E161',       "Constant value for WRICEF (E161)
  lc_ser_num_e161   TYPE zsno   VALUE '001'.        "Serial Number (001)

DATA:
  lv_actv_flag_e161 TYPE zactive_flag.              "Active / Inactive flag

* Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e161              "Constant value for WRICEF (E161)
    im_ser_num     = lc_ser_num_e161                "Serial Number (001)
  IMPORTING
    ex_active_flag = lv_actv_flag_e161.             "Active / Inactive flag

IF lv_actv_flag_e161 = abap_true.
  INCLUDE zqtcn_ord_res_by_doc_typ_02 IF FOUND.
ENDIF. "IF lv_actv_flag_E161 = abap_true
* End   of ADD:E161:WROY:23-JUN-2017:ED2K906642

* Begin of ADD:E075:WROY:08-AUG-2017:ED2K907469
  CONSTANTS:
    lc_wricef_id_e075 TYPE zdevid   VALUE 'E075',  " Development ID
    lc_ser_num_7_e075 TYPE zsno     VALUE '007'.   " Serial Number

  DATA:
    lv_actv_flag_e075 TYPE zactive_flag.           " Active / Inactive Flag

* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e075
      im_ser_num     = lc_ser_num_7_e075
    IMPORTING
      ex_active_flag = lv_actv_flag_e075.

  IF lv_actv_flag_e075 EQ abap_true.
    INCLUDE zqtcn_bom_pricing_05 IF FOUND.
  ENDIF.
* End   of ADD:E075:WROY:08-AUG-2017:ED2K907469
