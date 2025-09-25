*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ADD_FIELDS_VA45_SEL_SCRN (Include Program)
* PROGRAM DESCRIPTION: Add new fields in VA45
* DEVELOPER: Writtick Roy (WROY) / Sayantan Das (SAYANDAS)
* CREATION DATE:   05/30/2017
* OBJECT ID: R050
* TRANSPORT NUMBER(S): ED2K906227
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906843
* REFERENCE NO: CR# 543
* DEVELOPER: Paramita Bose (PBOSE)
* DATE:  2017-07-03
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
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914716
* REFERENCE NO: DM1748
* DEVELOPER: VDPATABALL
* DATE:  03/19/2019
* DESCRIPTION: added SALES TEXT DISPLAY in ZQTC_VA45 screen
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914716
* REFERENCE NO: DM1791
* DEVELOPER: PRABHU
* DATE:  05/15/2019
* DESCRIPTION: Layout field on ZQTC_VA45 selection screen
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910840 / ED2K916019
* REFERENCE NO: INC0248483
* DEVELOPER: Bharani
* DATE:  08/15/2019
* DESCRIPTION: Preceding document field added on the selection screen
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K917536
* REFERENCE NO:  ERPM-9418
* WRICEF ID: R050
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  02/13/2020
* DESCRIPTION: Add frieght forwarding agent for selection and report output
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918229
* REFERENCE NO:  ERPM-14773
* WRICEF ID: R050
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  05/15/2020
* DESCRIPTION: Add new selection screen fields and output fields
*---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ADD_FIELDS_VA45_SEL_SCRN
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   07/09/2020
* WRICEF ID: R050
* TRANSPORT NUMBER(S):  ED2K918827
* REFERENCE NO: ERPM-21199
* Change : Add two new selectino screen blocks
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ADD_FIELDS_VA45_SEL_SCRN
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   07/15/2020
* WRICEF ID: R050
* TRANSPORT NUMBER(S):   ED2K918914
* REFERENCE NO: ERPM-15415
* Change : Enable the existing Customer condition group2 field for selection
*          (Comment the existing modify ID)
*----------------------------------------------------------------------*
TABLES: vbrk, "Billing Document: Header Data
        vbrp, "Billing Document: Item Data
        vbfa, "Sales Document flow   "++BTIRUVATHU 2019/07/19 ED1K910841
        vbkd, "Sales Document: Business Data
        ttxid,"++VDPATABALL 03/19/2019 DM1748
        t002, "++VDPATABALL 03/19/2019 DM1748
**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
        veda.
SELECTION-SCREEN BEGIN OF BLOCK va45_item_val_period WITH FRAME TITLE text-z09.
SELECT-OPTIONS: sitemval FOR gv_validity NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK va45_item_val_period.

SELECTION-SCREEN BEGIN OF BLOCK va45_item_val_dates WITH FRAME TITLE text-z10.
SELECT-OPTIONS: s_start FOR veda-vbegdat,
                s_end   FOR veda-venddat.
SELECTION-SCREEN END OF BLOCK va45_item_val_dates.

**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****

SELECTION-SCREEN BEGIN OF BLOCK fields_va45_ord WITH FRAME TITLE text-z01.
SELECT-OPTIONS:
  s_fkdat  FOR vbkd-fkdat,    "++VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
  s_pstyv  FOR vbap-pstyv,    "Sales document item category
  s_vgbel  FOR vbak-vgbel,    "Document number of the reference document
  s_zterm  FOR vbkd-zterm,    "Terms of Payment Key
  s_ihrez  FOR vbkd-ihrez,    "Your Reference
  s_sbtyp  FOR vbap-zzsubtyp, "Subscription Type
  s_bsark  FOR vbak-bsark,    "Customer purchase order type
  s_mvgr1  FOR vbap-mvgr1,    "Material group 1
  s_mvgr2  FOR vbap-mvgr2,    "Material group 2
  s_mvgr3  FOR vbap-mvgr3,    "Material group 3
  s_mvgr4  FOR vbap-mvgr4,    "Material group 4
  s_mvgr5  FOR vbap-mvgr5,    "Material group 5
  s_promo  FOR vbap-zzpromo,  "Promo code
  s_licgrp FOR vbak-zzlicgrp, "License Group
  s_zuonr  FOR vbak-zuonr,    "Assignment number
* Begin of Change: PBOSE: 03-07-2017: CR#543: ED2K906843
**** Begin of change by Lahiru on 07/15/2020 with ERPM-15415 with ED2K918914 ****
  s_kdkg2  FOR vbkd-kdkg2," MODIF ID md1, "Customer condition group 2
**** End of change by Lahiru on 07/15/2020 with ERPM-15415 with ED2K918914 ****
  s_lifsk  FOR vbak-lifsk MODIF ID md1, "Delivery block
  s_faksk  FOR vbak-faksk MODIF ID md1, "Billing block in SD document
* End of Change: PBOSE: 03-07-2017: CR#543: ED2K906843
*** BOC BY SAYANDAS FOR CR706 on 12-OCT-2017
   s_bname FOR vbak-bname,
   s_ihreze FOR vbkd-ihrez_e,
*** EOC BY SAYANDAS FOR CR706 on 12-OCT-2017
*** BOC BY SAYANDAS FOR JIRA# 6289 on 04-May-2018
    s_kdmat FOR vbap-kdmat,
*** EOC BY SAYANDAS FOR JIRA# 6289 on 04-May-2018
* BOC - BTIRUVATHU - INC0248483- 2019/07/19 - ED1K910841
    s_vbty_n FOR vbfa-vbtyp_n.    "Document category of subsequent document
* EOC - BTIRUVATHU - INC0248483- 2019/07/19 - ED1K910841
SELECTION-SCREEN END OF BLOCK fields_va45_ord.

SELECTION-SCREEN BEGIN OF BLOCK fields_va45_inv WITH FRAME TITLE text-z02.
*** BOC BY SAYANDAS on 02-JAN-2018 for ERP-5688
*SELECT-OPTIONS:
* s_bldoc  FOR vbrk-vbeln, "Billing Document
* s_bltyp  FOR vbrk-fkart, "Billing Type
* s_ernam  FOR vbrk-ernam, "Name of Person who Created the Object
* s_erdat  FOR vbrk-erdat, "Date on Which Record Was Created
* s_kunrg  FOR vbrk-kunrg, "Payer
* s_ztrmr  FOR vbrk-zterm. "Terms of Payment Key
SELECT-OPTIONS:
  s_bldoc  FOR vbrk-vbeln MODIF ID md2, "Billing Document
  s_bltyp  FOR vbrk-fkart MODIF ID md2, "Billing Type
  s_ernam  FOR vbrk-ernam MODIF ID md2, "Name of Person who Created the Object
  s_erdat  FOR vbrk-erdat MODIF ID md2, "Date on Which Record Was Created
  s_kunrg  FOR vbrk-kunrg MODIF ID md2, "Payer
  s_ztrmr  FOR vbrk-zterm MODIF ID md2. "Terms of Payment Key
*** EOC BY SAYANDAS on 02-JAN-2018 for ERP-5688
*---Begin of change VDPATABALL 03/19/2019 DM1748
SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF BLOCK fields_va45_txt WITH FRAME TITLE text-z05.
SELECT-OPTIONS: s_lang   FOR t002-spras     NO-EXTENSION NO INTERVALS DEFAULT 'EN',
                s_object FOR ttxid-tdobject NO-EXTENSION NO INTERVALS,
                s_tdid   FOR ttxid-tdid     NO-EXTENSION NO INTERVALS.
SELECTION-SCREEN END OF BLOCK fields_va45_txt.
*---End of change VDPATABALL 03/19/2019 DM1791
SELECTION-SCREEN END OF BLOCK fields_va45_inv.
*---Begin of change by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536
SELECTION-SCREEN BEGIN OF BLOCK flds_va45_frfor WITH FRAME TITLE text-z06.
SELECT-OPTIONS: s_ship2p FOR vbpa-kunnr,    " Ship to party
*---Begin of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229
                s_lifnr FOR vbpa-lifnr.     " Frieght forwader
*---End of change by Lahiru on 10/02/2020 ERPM-14773 with ED2K918229
SELECTION-SCREEN END OF BLOCK flds_va45_frfor.
*---Begin of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229---*
SELECTION-SCREEN BEGIN OF BLOCK flds_va45_other WITH FRAME TITLE text-z08.
SELECT-OPTIONS : s_konda FOR vbkd-konda,
                 s_abgru FOR vbap-abgru,
                 s_zlsch FOR vbkd-zlsch.
PARAMETERS    :  cb_bom  AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK flds_va45_other.
*---End of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229---*
*---End of change by Lahiru on 10/02/2020 ERPM-9418 with ED2K917536
*---Begin of change PRABHU 05/195/2019 DM1748
SELECTION-SCREEN BEGIN OF BLOCK layout WITH FRAME.
PARAMETERS: p_layout TYPE disvariant-variant.
SELECTION-SCREEN END OF BLOCK layout.
*---End of change PRABHU 05/15/2019 DM1791
