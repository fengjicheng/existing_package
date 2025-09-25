*----------------------------------------------------------------------*
* PROGRAM NAME:         ZXVSVU01                                       *
* PROGRAM DESCRIPTION:  Include for RBDSEDEB for Enhancing the F4 help *
* DEVELOPER:            Cheenangshuk Das                               *
* CREATION DATE:        12/09/2016                                     *
* OBJECT ID:            I0202                                          *
* TRANSPORT NUMBER(S):  ED2K903293                                     *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*Purpose: The main purpose of this Enhancement is to commence all the
*         necessary General data of Business Partner that has been changed
*         and populate the Idoc and thereby while posting it should
*         be posted with the entire info.
*====================================================================*
* Data Declaration
*====================================================================*
  DATA : lv_active_stat TYPE zactive_flag. " Active / Inactive flag
*====================================================================*
* Local Constants
*====================================================================*
  CONSTANTS : lc_wricefid_i0202 TYPE zdevid VALUE 'I0202', " Constant value for WRICEF (I0202)
              lc_ser_num_003    TYPE zsno   VALUE '003'.   " Serial Number (001)

CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricefid_i0202
    im_ser_num     = lc_ser_num_003
  IMPORTING
    ex_active_flag = lv_active_stat.

IF lv_active_stat EQ abap_true.
   INCLUDE zqtcn_rbdsedeb_f4_enhance_02 IF FOUND.
ENDIF.
