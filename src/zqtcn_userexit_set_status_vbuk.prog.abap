*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_SET_STATUS_VBUK (Include)
*               Called from "USEREXIT_SET_STATUS_VBUK(RV45PFZA)"
* PROGRAM DESCRIPTION: Additional logic can be entered in this form in
*                      order to set user-defined status in workarea VBUK
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/21/2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K902972
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCEI_INCOMPLETE_LOG
* PROGRAM DESCRIPTION:Setting status for Incompletion.
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-10-20
* OBJECT ID:E111
* TRANSPORT NUMBER(S):ED2K902972
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
*& Data Declration ---------------------------------------------
*
*DATA:
*  lv_actv_flag      TYPE zactive_flag . " Active / Inactive Flag
*
**& Constants
*CONSTANTS : lc_wricef_id TYPE zdevid      VALUE 'E111', " Development ID
*            lc_ser_num   TYPE zsno        VALUE '001'.  " Serial Number
*
** To check enhancement is active or not
*CALL FUNCTION 'ZCA_ENH_CONTROL'
*  EXPORTING
*    im_wricef_id   = lc_wricef_id
*    im_ser_num     = lc_ser_num
*  IMPORTING
*    ex_active_flag = lv_actv_flag.
*IF lv_actv_flag EQ abap_true.
*
*
*  INCLUDE zqtcn_set_incom_status_vbuk IF FOUND.

*
*ENDIF.
