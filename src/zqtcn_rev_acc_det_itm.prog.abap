*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_REV_ACC_DET_ITM (Include)
*               Called from "USEREXIT_ACCOUNT_PREP_KOMPCV (RV60AFZZ)"
* PROGRAM DESCRIPTION: Additional Field for Revenue Account
*                      Determination (Item fields)
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   03/27/2017
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K905004
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907534
* REFERENCE NO: CR595
* DEVELOPER: Writtick Roy (WROY)
* DATE:  07/26/2017
* DESCRIPTION: Get Price Group from Order Line instead of Billing Header
*----------------------------------------------------------------------*
DATA:
  lv_str_vbap TYPE char30 VALUE '(SAPFV45P)VBAP',
  lv_str_vbkd TYPE char30 VALUE '(SAPFV45P)VBKD'.

DATA:
  lst_mat_det TYPE mara,                                        "General Material Data
* Begin of ADD:CR#595:WROY:26-JUL-2017:ED2K907534
  lst_sd_busd TYPE vbkd,                                        "Sales Document: Business Data
* End   of ADD:CR#595:WROY:26-JUL-2017:ED2K907534
  lst_ord_itm TYPE vbap.                                        "Sales Document: Item Data

FIELD-SYMBOLS:
  <lst_ord_b> TYPE vbkd,                                        "Sales Document: Business Data
  <lst_ord_i> TYPE vbap.                                        "Sales Document: Item Data

IF vbrp-aubel IS INITIAL OR
   vbrp-aupos IS INITIAL.
* Sales Document: Business Data
  ASSIGN (lv_str_vbkd) TO <lst_ord_b>.
  IF sy-subrc EQ 0.
*   Begin of DEL:CR#595:WROY:26-JUL-2017:ED2K907534
*   IF kompcv-ispkonda IS INITIAL.
*     kompcv-ispkonda = <lst_ord_b>-konda.                      "Price group (customer)
*   ENDIF.
*   End   of DEL:CR#595:WROY:26-JUL-2017:ED2K907534
*   Begin of ADD:CR#595:WROY:26-JUL-2017:ED2K907534
    kompcv-ispkonda = <lst_ord_b>-konda.                        "Price group (customer)
*   End   of ADD:CR#595:WROY:26-JUL-2017:ED2K907534
  ENDIF.

* Sales Document: Item Data
  ASSIGN (lv_str_vbap) TO <lst_ord_i>.
  IF sy-subrc EQ 0.
    lst_ord_itm = <lst_ord_i>.
  ENDIF.
ELSE.
* Get Price Group from Order Lines instead of Billing Header
* Begin of DEL:CR#595:WROY:26-JUL-2017:ED2K907534
* IF kompcv-ispkonda IS INITIAL.
*   kompcv-ispkonda = vbrk-konda.                               "Price group (customer)
* ENDIF.
* End   of DEL:CR#595:WROY:26-JUL-2017:ED2K907534
* Begin of ADD:CR#595:WROY:26-JUL-2017:ED2K907534
* Read Sales Document: Business Data entry (Buffered)
  CALL FUNCTION 'ZQTC_VBKD_SINGLE_READ'
    EXPORTING
      im_vbeln             = vbrp-aubel                         "Sales Document
      im_posnr             = vbrp-aupos                         "Sales Document Item
    IMPORTING
      ex_vbkd              = lst_sd_busd                        "Sales Document: Business Data
    EXCEPTIONS
      exc_record_not_found = 1
      OTHERS               = 2.
  IF sy-subrc EQ 0.
    kompcv-ispkonda = lst_sd_busd-konda.                        "Price group (customer)
  ENDIF.
* End   of ADD:CR#595:WROY:26-JUL-2017:ED2K907534

* Fetch Sales Document: Item Data
  CALL FUNCTION 'SD_VBAP_SINGLE_READ'
    EXPORTING
      i_vbeln          = vbrp-aubel                             "Sales Document
      i_posnr          = vbrp-aupos                             "Sales Document Item
    IMPORTING
      e_vbap           = lst_ord_itm                            "Sales Document: Item Data
    EXCEPTIONS
      record_not_found = 1
      OTHERS           = 2.
  IF sy-subrc NE 0.
    CLEAR: lst_ord_itm.
  ENDIF.
ENDIF.

IF lst_ord_itm IS NOT INITIAL.
  kompcv-zzvkaus = lst_ord_itm-vkaus.                           "Usage Indicator
* Fetch General Material Data
  CALL FUNCTION 'MARA_SINGLE_READ'
    EXPORTING
      matnr             = lst_ord_itm-matnr                     "Material Number
    IMPORTING
      wmara             = lst_mat_det                           "General Material Data
    EXCEPTIONS
      lock_on_material  = 1
      lock_system_error = 2
      wrong_call        = 3
      not_found         = 4
      OTHERS            = 5.
  IF sy-subrc EQ 0.
    kompcv-zzismpubltype = lst_mat_det-ismpubltype.             "Publication Type
  ENDIF.
ENDIF.
