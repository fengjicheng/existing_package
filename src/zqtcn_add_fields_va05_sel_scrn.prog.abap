*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ADD_FIELDS_VA05_SEL_SCRN (Include Program)
* PROGRAM DESCRIPTION: Add new fields in VA05
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   06/15/2017
* OBJECT ID: R052
* TRANSPORT NUMBER(S): ED2K906705
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912181
* REFERENCE NO:  JIRA# 6289
* DEVELOPER: Sayantan Das
* DATE:  2018-05-04
* DESCRIPTION: Additional fields for VA05/45/25
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915777
* REFERENCE NO: DM7836
* DEVELOPER: NPOLINA
* DATE:  08/13/2019
* DESCRIPTION: Layout field on ZQTC_VA05 selection screen
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918275
* REFERENCE NO:  ERPM-14773
* WRICEF ID: R052
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  05/21/2020
* DESCRIPTION: Add new selection screen fields and output fields
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K922945
* REFERENCE NO:  OTCM-42980
* WRICEF ID: R052
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  04/08/2021
* DESCRIPTION: Add Customer material no to Selection and report output
*---------------------------------------------------------------------*
TABLES: vbkd, " Sales Document: Business Data
        vbrk. " Billing Document: Header Data


SELECTION-SCREEN BEGIN OF BLOCK fields_va05_vbak WITH FRAME TITLE text-z01.
SELECT-OPTIONS:
s_vgbel  FOR vbak-vgbel,     " Document number of the reference document
s_promo  FOR vbak-zzpromo,  " Promo code
s_licgrp FOR vbak-zzlicgrp, " License Group
*--*Prabhu CR 7836
s_dlvblk FOR vbak-lifsk, " delivery bock,
s_bilblk FOR vbak-faksk. " billing block
SELECTION-SCREEN END OF BLOCK fields_va05_vbak.

SELECTION-SCREEN BEGIN OF BLOCK fields_va05_vbap WITH FRAME TITLE text-z02.
SELECT-OPTIONS:
s_pstyv FOR vbap-pstyv, " Sales document item category
s_mvgr1 FOR vbap-mvgr1, " Material group 1
s_mvgr2 FOR vbap-mvgr2, " Material group 2
s_mvgr3 FOR vbap-mvgr3, " Material group 3
s_mvgr4 FOR vbap-mvgr4, " Material group 4
s_mvgr5 FOR vbap-mvgr5. " Material group 5
SELECTION-SCREEN END OF BLOCK fields_va05_vbap.

SELECTION-SCREEN BEGIN OF BLOCK fields_va05_vbkd WITH FRAME TITLE text-z03.
SELECT-OPTIONS:
s_bsark FOR vbkd-bsark, " Customer purchase order type
s_ihrez FOR vbkd-ihrez, " Your Reference
*** BOC BY SAYANDAS for JIRA# 6289 on 04-MAY-2018
s_ihreze FOR vbkd-ihrez_e,
s_matnr2  FOR vbap-matnr,
*** EOC BY SAYANDAS for JIRA# 6289 on 04-MAY-2018
* BOC by Lahiru on 04/08/2021 for OTCM-42980 with ED2K922945  *
s_kdmat FOR vbap-kdmat.
* EOC by Lahiru on 04/08/2021 for OTCM-42980 with ED2K922945  *
SELECTION-SCREEN END OF BLOCK fields_va05_vbkd.

SELECTION-SCREEN BEGIN OF BLOCK fields_va05_vbrk WITH FRAME TITLE text-z04.
SELECT-OPTIONS:
s_bldoc FOR vbrk-vbeln, " Billing Document
s_bltyp FOR vbrk-fkart, " Billing Type
s_zterm FOR vbrk-zterm, " Terms of Payment Key
s_ernam FOR vbrk-ernam, " Name of Person who Created the Object
s_erdat FOR vbrk-erdat, " Date on Which Record Was Created
s_kunrg FOR vbrk-kunrg. " Sold-to party
SELECTION-SCREEN END OF BLOCK fields_va05_vbrk.
*--SOC NPOLINA 08/13/2019 DM7836 ED2K915777
*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275
SELECTION-SCREEN BEGIN OF BLOCK flds_va05_frfor WITH FRAME TITLE text-z06.
SELECT-OPTIONS : s_ship2p FOR vbpa-kunnr,      " Ship to party
                 s_lifnr FOR vbpa-lifnr.       " Frieght Forwarder

SELECTION-SCREEN END OF BLOCK flds_va05_frfor.

SELECTION-SCREEN BEGIN OF BLOCK flds_va05_other WITH FRAME TITLE text-z08.
SELECT-OPTIONS : s_konda FOR vbkd-konda,
                 s_abgru FOR vbap-abgru,
                 s_zlsch FOR vbkd-zlsch.
PARAMETERS    :  cb_bom  AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK flds_va05_other.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*

SELECTION-SCREEN BEGIN OF BLOCK layout WITH FRAME.
PARAMETERS: p_layout TYPE disvariant-variant.
SELECTION-SCREEN END OF BLOCK layout.
*--EOC NPOLINA 08/13/2019 DM7836 ED2K915777
