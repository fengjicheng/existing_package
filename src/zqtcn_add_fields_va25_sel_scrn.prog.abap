*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ADD_FIELDS_VA25_SEL_SCRN
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906855
* REFERENCE NO: CR# 543
* DEVELOPER: Paramita Bose (PBOSE)
* DATE:  2017-07-05
* DESCRIPTION:
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912181
* REFERENCE NO:  JIRA# 6289
* DEVELOPER: Sayantan Das
* DATE:  2018-05-04
* DESCRIPTION: Additional fields for VA05/45/25
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K917574
* REFERENCE NO:  ERPM-9418
* WRICEF ID: R054
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  02/13/2020
* DESCRIPTION: Add frieght forwarding agent for selection and report output
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED2K918259
* REFERENCE NO:  ERPM-14773
* WRICEF ID: R054
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  05/20/2020
* DESCRIPTION: Add new selection screen fields and output fields
*---------------------------------------------------------------------*
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   07/09/2020
* WRICEF ID: R054
* TRANSPORT NUMBER(S):  ED2K918842
* REFERENCE NO: ERPM-21199
* Change : Add two new selectino screen blocks
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO : ED2K924869
* REFERENCE NO: OTCM-54011
* WRICEF ID   : R054
* DEVELOPER   : VDPATABALL
* DATE        : 10/29/2021
* DESCRIPTION : Indian Agent Changes for Unrenewed Quotation list
*---------------------------------------------------------------------*
TABLES:
  vbkd,
  vbfa, " Sales Document Flow
**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
  veda.
*----BOC VDPATABALL 10/29/2021 ED2K924869 OTC-49605
SELECTION-SCREEN BEGIN OF BLOCK ren WITH FRAME TITLE text-z08.
PARAMETERS: ch_unren AS CHECKBOX MODIF ID unr USER-COMMAND ucom3 .
SELECTION-SCREEN END OF BLOCK ren.
*----EOC VDPATABALL 10/29/2021 ED2K924869 OTC-49605
SELECTION-SCREEN BEGIN OF BLOCK va25_item_val_period WITH FRAME TITLE text-z09.
SELECT-OPTIONS: sitemval FOR gv_validity NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK va25_item_val_period.

SELECTION-SCREEN BEGIN OF BLOCK va25_item_val_dates WITH FRAME TITLE text-z10.
SELECT-OPTIONS: s_start FOR veda-vbegdat,
                s_end   FOR veda-venddat.
SELECTION-SCREEN END OF BLOCK va25_item_val_dates.

**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-z01.
SELECT-OPTIONS:
s_vgbel    FOR vbak-vgbel,    " Document number of the reference document
s_zzligp   FOR vbak-zzlicgrp, " License Group
s_pstyv    FOR vbap-pstyv,    " Sales document item category
s_vbty_n   FOR vbfa-vbtyp_n,  " Document category of subsequent document
s_vbeln    FOR vbfa-vbeln,    " Subsequent sales and distribution document
*** BOC BY SAYANDAS for JIRA# 6289 on 04-MAR-2018
s_kdmat    FOR vbap-kdmat.
*** EOC BY SAYANDAS for JIRA# 6289 on 04-MAR-2018
SELECTION-SCREEN END OF BLOCK b1.

*---Begin of change by Lahiru on 17/02/2020 ERPM-9418 with ED2K917574
SELECTION-SCREEN BEGIN OF BLOCK flds_va45_frfor WITH FRAME TITLE text-z06.
SELECT-OPTIONS: s_ship2p FOR vbpa-kunnr,      "Ship to party
*---Begin of change by Lahiru on 05/20/2020 ERPM-14773 with ED2K918259
                s_lifnr FOR vbpa-lifnr.     " Frieght Forwarder.
*---End of change by Lahiru on 05/20/2020 ERPM-14773 with ED2K918259
SELECTION-SCREEN END OF BLOCK flds_va45_frfor.
*---End of change by Lahiru on 17/02/2020 ERPM-9418 with ED2K917574
*---Begin of change by Lahiru on 05/20/2020 ERPM-14773 with ED2K918259
SELECTION-SCREEN BEGIN OF BLOCK flds_va25_other WITH FRAME TITLE text-z08.
SELECT-OPTIONS : s_konda FOR vbkd-konda,
                 s_abgru FOR vbap-abgru,
                 s_zlsch FOR vbkd-zlsch.
SELECT-OPTIONS : s_bsark FOR vbkd-bsark.
PARAMETERS    :  cb_bom AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK flds_va25_other.
*---End of change by Lahiru on 05/20/2020 ERPM-14773 with ED2K918259
