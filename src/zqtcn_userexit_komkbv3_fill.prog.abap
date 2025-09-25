*----------------------------------------------------------------------*
* PROGRAM NAME:        RVCOMFZZ
* PROGRAM DESCRIPTION: Communication structure update with PO type value
* DEVELOPER:           Manami Chaudhuri
* CREATION DATE:       02/17/2017
* OBJECT ID:           I0245
* TRANSPORT NUMBER(S):  ED2K904235
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO : ED2K928517
* REFERENCE NO: E364/OTCM-68443
* DEVELOPER   : Vamsi Mamillapalli(VMAMILLAPA)
* DATE        : 09/05/2022
* DESCRIPTION : Update Order reason and sales rep(ZE partner) to
*               communication structure
*----------------------------------------------------------------------*

*  Fetch Sales / Subscription order  for Invoice Item
  DATA : lv_aubel TYPE vbeln_va. " Sales Document

* Assuming Invoice will have only single Order number
* For both cases of Invoice create & change , com_vbrp_tab table
* will have value for AUBEL
  READ TABLE com_vbrp_tab ASSIGNING FIELD-SYMBOL(<lst_vbrp>) INDEX 1.
  IF sy-subrc IS INITIAL AND <lst_vbrp>-aubel IS ASSIGNED.
    lv_aubel = <lst_vbrp>-aubel.
  ENDIF. " IF sy-subrc IS INITIAL AND <lst_vbrp> IS ASSIGNED

*   Pass the Subscription Number obtained above to fetch
*   Purchase Order Type
  SELECT bsark " Customer purchase order type
    UP TO 1 ROWS
    INTO @DATA(lv_bsark)
    FROM vbkd  " Sales Document: Business Data
    WHERE vbeln EQ @lv_aubel.
  ENDSELECT.
  IF sy-subrc IS INITIAL.
    com_kbv3-zzbsark = lv_bsark.
  ENDIF. " IF sy-subrc IS INITIAL

  CONSTANTS:
    lc_wricef_id_f024 TYPE zdevid VALUE 'F024',    "Constant value for WRICEF (F024)
    lc_ser_num_f024_1 TYPE zsno   VALUE '001'.     "Serial Number (001)

  DATA:
    lv_actv_flag_f024 TYPE zactive_flag.           "Active / Inactive flag

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_f024           "Constant value for WRICEF (F024)
      im_ser_num     = lc_ser_num_f024_1           "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_f024.          "Active / Inactive flag
  IF lv_actv_flag_f024 = abap_true.
    INCLUDE zrtrn_komkbv3_fill_f024 IF FOUND.
  ENDIF.

* Begin of ADD:E160:WROY:09-JUL-2017:ED2K907161
  CONSTANTS:
    lc_wricef_id_e160 TYPE zdevid VALUE 'E160',    "Constant value for WRICEF (E160)
    lc_ser_num_e160_1 TYPE zsno   VALUE '001'.     "Serial Number (001)

  DATA:
    lv_actv_flag_e160 TYPE zactive_flag.           "Active / Inactive flag

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e160           "Constant value for WRICEF (E160)
      im_ser_num     = lc_ser_num_e160_1           "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_e160.          "Active / Inactive flag
  IF lv_actv_flag_e160 = abap_true.
    INCLUDE zrtrn_komkbv3_fill_e160 IF FOUND.
  ENDIF.
* End   of ADD:E160:WROY:09-JUL-2017:ED2K907161
*BOC|VMAMILLAPA|OTCM-68443|ED2K928517|05-Sep-2022
  CONSTANTS:
    lc_wricef_id_e364 TYPE zdevid VALUE 'E364',    "Constant value for WRICEF (E364)
    lc_ser_num_e364_1 TYPE zsno   VALUE '001'.     "Serial Number (001)

  DATA:
    lv_actv_flag_e364 TYPE zactive_flag.           "Active / Inactive flag

* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e364           "Constant value for WRICEF (E364)
      im_ser_num     = lc_ser_num_e364_1           "Serial Number (001)
    IMPORTING
      ex_active_flag = lv_actv_flag_e364.          "Active / Inactive flag
  IF lv_actv_flag_e364 = abap_true.
    INCLUDE zqtcn_komkbv3_fill_e364 IF FOUND.
  ENDIF.
*EOC|VMAMILLAPA|OTCM-68443|ED2K928517|05-Sep-2022
* Begin of VMAMILLAPA OTCM-7209 15-Dec-2022
CONSTANTS:
  lc_wricef_id_i0397 TYPE zdevid   VALUE 'I0397.2', " Development ID
  lc_ser_num_1_i0397 TYPE zsno     VALUE '001'.  " Serial Number

DATA:
  lv_actv_flag_i0397 TYPE zactive_flag. " Active / Inactive Flag

* To check enhancement is active or not
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_i0397
    im_ser_num     = lc_ser_num_1_i0397
  IMPORTING
    ex_active_flag = lv_actv_flag_i0397.

IF lv_actv_flag_i0397 EQ abap_true.
   INCLUDE zqtcn_komkbv3_fill_i0397_2 IF FOUND.
ENDIF. " IF lv_actv_flag_e152 EQ abap_true
* End of VMAMILLAPA OTCM-7209 15-Dec-2022
