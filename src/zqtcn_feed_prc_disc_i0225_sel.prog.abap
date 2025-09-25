*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_FEED_PRC_DISC_I0225_SEL (Selection Screen)
* PROGRAM DESCRIPTION: Feed Price and Discount Data from SAP
* DEVELOPER(S):        Writtick Roy
* CREATION DATE:       04/12/2017
* OBJECT ID:           I0225
* TRANSPORT NUMBER(S): ED2K904244
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904908
* REFERENCE NO:  CR# 490
* DEVELOPER: Writtick Roy
* DATE:  05/25/2017
* DESCRIPTION: 1. Update calculation logic for Librarian XLSX file to
* reflect list and net price (after ZSD1 discount/surcharge applied).
*              2. List Price should come from specific Condition table
* (A911 or A913) depending on Relationship Category from ZSD1
*              3. Populate 2 additional IDOC fields for Soceity Number
* and Relationship Category
*              4. Retrieve Material Text
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904908
* REFERENCE NO:  CR# 523
* DEVELOPER: Writtick Roy
* DATE:  06/22/2017
* DESCRIPTION: 1. Add All ISSNs in the XML / IDOC data (Print ISSN,
* Online ISSN, Print+Online ISSN)
*              2. Add Indicator for Multi-Journal Products
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904908, ED2K907257
* REFERENCE NO:  CR# 565
* DEVELOPER: Writtick Roy
* DATE:  07/08/2017
* DESCRIPTION: 1. Additional Exclusion Criteria - "Pricing Only" and
* "Pricing and Products".
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
PARAMETERS:
  rb_jps_x TYPE char1 RADIOBUTTON GROUP rdb1 DEFAULT 'X' USER-COMMAND srch,  "JPS XML
  rb_lib_e TYPE char1 RADIOBUTTON GROUP rdb1.                                "Librarian XLSX
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02.
PARAMETERS:
  p_prsdt  TYPE komk-prsdt DEFAULT sy-datum OBLIGATORY.                      "Pricing Date
SELECT-OPTIONS:
  s_kdgrp  FOR  komk-kdgrp,                                                  "Customer Group
  s_rltyp  FOR  komk-zzreltyp,                                               "Relationship Category
  s_sc_no  FOR  komk-zzpartner2,                                             "Society Number
  s_mstae  FOR  mara-mstae,                                                  "Material Status
  s_matnr  FOR  mara-matnr.                                                  "Material Number
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(25) text-c01 FOR FIELD s_rc_sn.
SELECTION-SCREEN POSITION 30.
SELECT-OPTIONS:
  s_rc_sn  FOR  mara-free_char NO INTERVALS.                                 "Relationship Category & Society Number
SELECTION-SCREEN COMMENT 58(40) text-c02.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s03.
SELECT-OPTIONS:
  s_matnr1 FOR  mara-matnr,                                                  "Material Number
  s_mstae1 FOR  mara-mstae,                                                  "Material Status
  s_mtart1 FOR  mara-mtart,                                                  "Material Type
  s_mdtyp1 FOR  mara-ismmediatype,                                           "Media Type
  s_kdgrp1 FOR  komk-kdgrp,                                                  "Customer Group
* Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
  s_sc_no1 FOR  komk-zzpartner2.                                             "Society Number
* End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
* Begin of DEL:CR#565:WROY:08-JUL-2017:ED2K904908
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT 1(25) text-c01 FOR FIELD s_rc_sn1.
*SELECTION-SCREEN POSITION 30.
*SELECT-OPTIONS:
*  s_rc_sn1 FOR  mara-free_char NO INTERVALS.                                 "Relationship Category & Society Number
*SELECTION-SCREEN COMMENT 58(40) text-c02.
*SELECTION-SCREEN END OF LINE.
* End   of DEL:CR#565:WROY:08-JUL-2017:ED2K904908
* Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK b13 WITH FRAME TITLE text-s13.
PARAMETERS:
  p_rs_wm1 TYPE text1024,
  p_rc_sn1 TYPE text1024,
  p_sn_pt1 TYPE text1024,
  p_rltyp1 TYPE text1024,
  p_prtyp1 TYPE text1024.
SELECTION-SCREEN END OF BLOCK b13.
* End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-s04.
SELECT-OPTIONS:
  s_matnr2 FOR  mara-matnr,                                                  "Material Number
  s_mstae2 FOR  mara-mstae,                                                  "Material Status
  s_mtart2 FOR  mara-mtart,                                                  "Material Type
  s_mdtyp2 FOR  mara-ismmediatype,                                           "Media Type
  s_kdgrp2 FOR  komk-kdgrp,                                                  "Customer Group
* Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
  s_sc_no2 FOR  komk-zzpartner2.                                             "Society Number
* End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
* Begin of DEL:CR#565:WROY:08-JUL-2017:ED2K904908
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT 1(25) text-c01 FOR FIELD s_rc_sn2.
*SELECTION-SCREEN POSITION 30.
*SELECT-OPTIONS:
*  s_rc_sn2 FOR  mara-free_char NO INTERVALS.                                 "Relationship Category & Society Number
*SELECTION-SCREEN COMMENT 58(40) text-c02.
*SELECTION-SCREEN END OF LINE.
* End   of DEL:CR#565:WROY:08-JUL-2017:ED2K904908
* Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK b14 WITH FRAME TITLE text-s14.
PARAMETERS:
  p_rs_wm2 TYPE text1024,
  p_rc_sn2 TYPE text1024,
  p_sn_pt2 TYPE text1024,
  p_rltyp2 TYPE text1024,
  p_prtyp2 TYPE text1024.
SELECTION-SCREEN END OF BLOCK b14.
* End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-s05.
SELECT-OPTIONS:
  s_email  FOR  adr6-smtp_addr NO INTERVALS.                                 "E-Mail Address
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE text-s06.
PARAMETERS:
  p_idcdty TYPE jptidcdassign-idcodetype DEFAULT 'ZSSN'.                     "Type of Identification Code
SELECT-OPTIONS:
  s_opt_in FOR  mara-ismpubltype         DEFAULT 'OI',                       "Publication Type
  s_land_v FOR  marc-herkl               DEFAULT 'DE'.                       "Country of origin of the material (VCH)

SELECTION-SCREEN BEGIN OF BLOCK b7 WITH FRAME TITLE text-s07.
SELECT-OPTIONS:
  s_kdgrpi FOR  komk-kdgrp               DEFAULT '03',
  s_kdgrpp FOR  komk-kdgrp               DEFAULT '01'.
SELECTION-SCREEN END OF BLOCK b7.

SELECTION-SCREEN BEGIN OF BLOCK b8 WITH FRAME TITLE text-s08.
SELECT-OPTIONS:
  s_mtyppo FOR  mara-ismmediatype        DEFAULT 'PH',
  s_mtypoo FOR  mara-ismmediatype        DEFAULT 'DI',
  s_mtypop FOR  mara-ismmediatype        DEFAULT 'MM'.
SELECTION-SCREEN END OF BLOCK b8.

SELECTION-SCREEN BEGIN OF BLOCK b9 WITH FRAME TITLE text-s09.
SELECT-OPTIONS:
  s_pltyp1 FOR  komk-pltyp               DEFAULT 'P1',
  s_pltyp2 FOR  komk-pltyp               DEFAULT 'P2',
  s_pltyp3 FOR  komk-pltyp               DEFAULT 'P3',
  s_pltyp4 FOR  komk-pltyp               DEFAULT 'P4'.
SELECTION-SCREEN END OF BLOCK b9.

SELECTION-SCREEN BEGIN OF BLOCK b10 WITH FRAME TITLE text-s10.
SELECT-OPTIONS:
  s_mtarta FOR  mara-mtart,                                                  "Material Type (All)
  s_mtartb FOR  mara-mtart,                                                  "Material Type (BOM Header)
  s_mtartc FOR  mara-mtart               DEFAULT 'ZMJL'.                     "Material Type (Combined)
SELECTION-SCREEN END OF BLOCK b10.

SELECTION-SCREEN BEGIN OF BLOCK b11 WITH FRAME TITLE text-s11.
SELECT-OPTIONS:
  s_kschlp FOR  komv-kschl,                                                  "Condition type (List Price)
  s_kschld FOR  komv-kschl.                                                  "Condition type (Discount)
SELECTION-SCREEN END OF BLOCK b11.
SELECTION-SCREEN BEGIN OF BLOCK b12 WITH FRAME TITLE text-s12.
PARAMETERS:
  p_ns_ttl TYPE ausp-atinn,                                                  "Characteristic (New Start Title)
  p_megd_w TYPE ausp-atinn.                                                  "Characteristic (Merged With)
SELECTION-SCREEN END OF BLOCK b12.
SELECTION-SCREEN END OF BLOCK b6.
