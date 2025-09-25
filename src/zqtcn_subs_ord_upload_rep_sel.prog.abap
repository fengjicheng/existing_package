*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SUBS_ORDER_UPLOAD_REP_SEL
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SUBS_ORDER_UPLOAD_REP_SEL (Selection Screen)
* PROGRAM DESCRIPTION: Subscription order upload selection screen include
* DEVELOPER: Prosenjit Chaudhuri(PCHAUDHURI)
* CREATION DATE:   28/11/2016
* OBJECT ID:  E101
* TRANSPORT NUMBER(S):  ED2K903417
*----------------------------------------------------------------------*
* REVISION NO: ED2K913189, ED2K913477                                  *
* REFERENCE NO: ERP-7614                                               *
* DEVELOPER: Sayantan Das (SAYANDAS)                                   *
* DATE: 24-AUG-2018                                                    *
* DESCRIPTION: Add Background Processing Option                        *
*----------------------------------------------------------------------*
* REVISION NO: ED2K913722                                              *
* REFERENCE NO: ERP7763                                                *
* DEVELOPER: Surya                                                     *
* DATE:  12-Nov-2018                                                   *
* DESCRIPTION: Added Download option                                   *
*----------------------------------------------------------------------*
* REVISION NO: ED2K913722/ED2K914078                                   *
* REFERENCE NO: ERP7763                                                *
* DEVELOPER: Surya/Nageswara Polina (NPOLINA)                          *
* DATE:  12-Dec-2018                                                   *
* DESCRIPTION: Added Converted Order(ZSCR) download and Upload         *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO: ED2K916854                                              *
* REFERENCE NO:ERPM2334                                                *
* DEVELOPER: Nageswara Polina (NPOLINA)                                *
* DATE:  05-Dec-2019                                                   *
* DESCRIPTION: Code adjustment to work for BP and Order Upload         *
*----------------------------------------------------------------------*
* REVISION NO: ED2K920134                                              *
* REFERENCE NO:ERPM-27580                                              *
* DEVELOPER: AMOHAMMED                                                 *
* DATE:  29-Oct-2020                                                   *
* DESCRIPTION: ZADR Acquisition Debit Additional Enhancements          *
*----------------------------------------------------------------------*
* REVISION NO: ED2K923278                                              *
* REFERENCE NO: OTCM-44200                                             *
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)                             *
* DATE:  05/05/2021                                                    *
* DESCRIPTION: ZADR File template changes and new validatinos          *
*----------------------------------------------------------------------*
* SELECTION SCREEN-----------------------------------------------------*


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.

PARAMETERS : rb_crea RADIOBUTTON GROUP rad1 USER-COMMAND ucom1 DEFAULT 'X' MODIF ID m2, "Radio button for creating new susbcription order
*SELECTION-SCREEN BEGIN OF LINE.
*   BOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907365
             rb_cros RADIOBUTTON GROUP rad1 MODIF ID m2.
SELECTION-SCREEN BEGIN OF LINE.
*   EOC CR#498: 02-JUL-2017 : SAYANDAS: ED2K907365
PARAMETERS : rb_modi RADIOBUTTON GROUP rad1 MODIF ID m2. "Radio button for modifying new subscription order
SELECTION-SCREEN COMMENT 3(40) text-002.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s03. "for the change subscription criteria
PARAMETERS: rb_sel_m RADIOBUTTON GROUP rad5 MODIF ID m9 USER-COMMAND ucom5 DEFAULT 'X',
            rb_upd_m RADIOBUTTON GROUP rad5 MODIF ID m9.

SELECT-OPTIONS: s_date   FOR sy-datum   MODIF ID s9. "date range
SELECT-OPTIONS: s_vbeln  FOR vbak-vbeln MODIF ID s10. " Sales Document
SELECT-OPTIONS: s_bstnk  FOR vbak-bstnk MODIF ID s9. "for purchase order range
SELECT-OPTIONS: s_userid FOR vbak-ernam MODIF ID s9  NO INTERVALS. "for purchase order range
SELECTION-SCREEN END OF BLOCK b3.

PARAMETERS: rb_crem RADIOBUTTON GROUP rad1 MODIF ID m2. "radio button for creating new credit memo

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02.
PARAMETERS: rb_sel RADIOBUTTON GROUP rad2 MODIF ID m3 USER-COMMAND ucom2 DEFAULT 'X',
            rb_upd RADIOBUTTON GROUP rad2 MODIF ID m3,
            rb_ord RADIOBUTTON GROUP rad2 MODIF ID m3.    "NPOLINA ERP7763 ED2K913722 Converted Orders

SELECT-OPTIONS : s_invo FOR sy-datum   MODIF ID s1. "for invoice creation date
SELECT-OPTIONS : s_doc  FOR vbak-vbeln MODIF ID s11. "for invoice

* SOC by NPOLINA ERP7763 ED2K913722
SELECT-OPTIONS:s_cdate FOR sy-datum MODIF ID s99.      " Date
PARAMETERS:    p_cvkbur TYPE vbak-vkbur DEFAULT '0050' MODIF ID s99.   " Sales Office
SELECT-OPTIONS:s_cvbeln FOR vbak-vbeln MODIF ID s99.   " Contracts
PARAMETERS:    p_count TYPE i DEFAULT 1000 MODIF ID s99.
* EOC by NPOLINA ERP7763 ED2K913722
SELECTION-SCREEN END OF BLOCK b2.

PARAMETERS: rb_crcg RADIOBUTTON GROUP rad1 MODIF ID m4. "radio button for creating new credit memo

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-s04.

PARAMETERS: rb_sel1 RADIOBUTTON GROUP rad3 MODIF ID m5 USER-COMMAND ucom3 DEFAULT 'X',
            rb_upd1 RADIOBUTTON GROUP rad3 MODIF ID m5.

SELECT-OPTIONS : s_inv    FOR sy-datum     MODIF ID s2.                       " for invoice creation date
SELECT-OPTIONS : s_cmr    FOR vbak-vbeln   MODIF ID s12,                      " Sales Document
                 s_bstnk1 FOR vbak-bstnk   MODIF ID s2,                       " Customer purchase order number
                 s_promo  FOR vbak-zzpromo MODIF ID s2,                       " Promo code
                 s_matnr  FOR mara-matnr   MODIF ID s2 MATCHCODE OBJECT mat1. " Material Number
SELECT-OPTIONS:  s_crd_by FOR vbak-ernam   MODIF ID s2 NO INTERVALS. " Name of Person who Created the Object
SELECTION-SCREEN END OF BLOCK b4.

* Begin by AMOHAMMED on 10/29/2020 TR # ED2K920134
* BOC by Lahiru on 05/05/2021 for OTCM-44200 with ED2K923278  *
SELECTION-SCREEN begin of LINE.
PARAMETERS: rb_dm_cr RADIOBUTTON GROUP rad1 MODIF ID m2.
SELECTION-SCREEN COMMENT 10(41) text-s07 FOR FIELD rb_dm_cr.
SELECTION-SCREEN END OF LINE.
* EOC by Lahiru on 05/05/2021 for OTCM-44200 with ED2K923278  *
* End by AMOHAMMED on 10/29/2020 TR # ED2K920134

PARAMETERS: rb_or_ct RADIOBUTTON GROUP rad1 MODIF ID m6,
            rb_or_cn RADIOBUTTON GROUP rad1 MODIF ID m6.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-s05.

PARAMETERS: rb_sel2 RADIOBUTTON GROUP rad4 MODIF ID m7 USER-COMMAND ucom4 DEFAULT 'X',
            rb_upd2 RADIOBUTTON GROUP rad4 MODIF ID m7.

SELECT-OPTIONS : s_ord_dt  FOR sy-datum     MODIF ID s3.                       " For invoice creation date
SELECT-OPTIONS : s_order   FOR vbak-vbeln   MODIF ID s13,                      " Sales Document
                 s_bstnk2  FOR vbak-bstnk   MODIF ID s3,                       " Customer purchase order number
                 s_promo1  FOR vbak-zzpromo MODIF ID s3,                       " Promo code
                 s_matnr1  FOR mara-matnr   MODIF ID s3 MATCHCODE OBJECT mat1. " Material Number
SELECT-OPTIONS:  s_user1   FOR vbak-ernam   MODIF ID s3 NO INTERVALS. " Name of Person who Created the Object


SELECTION-SCREEN END OF BLOCK b5.
PARAMETERS: p_file  TYPE rlgrap-filename MODIF ID z1. "rlgrap-filename    " Local file for upload
***BOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189
PARAMETERS: p_a_file TYPE localfile NO-DISPLAY,
            p_job    TYPE tbtcjob-jobname NO-DISPLAY,
            p_userid TYPE syuname  NO-DISPLAY.
PARAMETERS:p_devid TYPE zdevid NO-DISPLAY,             "NPOLINA E225 04/Dec/2019 ED2K916992
           p_v_oid TYPE numc10 NO-DISPLAY.             "VDPATABALL E225 12/31/2019
***EOC BY SAYANDAS for CR-7614 on 24-AUG-2018 in ED2K913189

***BOC BY SNGUTNUPAL for CR-7763 on 29-OCT-2018 in ED2K913722
SELECTION-SCREEN: FUNCTION KEY 1.
***EOC BY SNGUTNUPAL for CR-7763 on 29-OCT-2018 in ED2K913722

SELECTION-SCREEN END OF BLOCK b1.
