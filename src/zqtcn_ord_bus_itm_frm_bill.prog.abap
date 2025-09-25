*---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_ORD_BUS_ITM_FRM_BILL (Include)
* [Called from Sales Orders Data Transfer Routine - 904 (RV45C904)]
* PROGRAM DESCRIPTION: Additional fields for Order Business Item Data
* DEVELOPER:           Writtick Roy (WROY)
* CREATION DATE:       07/13/2017
* OBJECT ID:           E070
* TRANSPORT NUMBER(S): ED2K907268
*---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* REVISION HISTORY----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*---------------------------------------------------------------------*
DATA:
  lst_vbkd_e070 TYPE vbkd.                                      "Sales Document: Business Data

* Buffered Func Module: Read Sales Document: Business Data
CALL FUNCTION 'ZQTC_VBKD_SINGLE_READ'
  EXPORTING
    im_vbeln             = cvbrp-aubel                          "Sales Document
    im_posnr             = cvbrp-aupos                          "Sales Document Item
  IMPORTING
    ex_vbkd              = lst_vbkd_e070                        "Sales Document: Business Data
  EXCEPTIONS
    exc_record_not_found = 1
    OTHERS               = 2.
IF sy-subrc EQ 0.
  vbkd-bsark   = lst_vbkd_e070-bsark.                           "Customer purchase order type
  vbkd-bstkd   = lst_vbkd_e070-bstkd.                           "Customer purchase order number
  vbkd-bstdk   = lst_vbkd_e070-bstdk.                           "Customer purchase order date

  vbkd-ihrez   = lst_vbkd_e070-ihrez.                           "Your Reference
  vbkd-ihrez_e = lst_vbkd_e070-ihrez_e.                         "Ship-to party character
  vbkd-posex_e = lst_vbkd_e070-posex_e.                         "Item Number of the Underlying Purchase Order
ENDIF.
