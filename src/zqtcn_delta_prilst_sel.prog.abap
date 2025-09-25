*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCI_DELTA_PRICELST_KAS_I0390
* PROGRAM DESCRIPTION: Delta Price List for KAS from SAP
* DEVELOPER(S):        Nageswara
* CREATION DATE:       02/Nov/2020
* OBJECT ID:           I0390
* TRANSPORT NUMBER(S): ED2K920157
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
PARAMETERS:
*  rb_age_x TYPE char1 RADIOBUTTON GROUP rdb1,                                "Delta XML
  rb_age_c TYPE char1 RADIOBUTTON GROUP rdb1,                               "Delta CSV
  rb_age_e TYPE char1 RADIOBUTTON GROUP rdb1 .                                "Agent XLSX
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02.
PARAMETERS :   p_prsdt TYPE komk-prsdt DEFAULT sy-datum.                  "Pricing Date
SELECT-OPTIONS:
*  s_prsdt  FOR  komk-prsdt NO-EXTENSION,                                     "Pricing Date
  s_kdgrp  FOR  komk-kdgrp,                                                  "Customer Group
*  s_rltyp  FOR  komk-zzreltyp,                                               "Relationship Category
*  s_sc_no  FOR  komk-zzpartner2,                                             "Society Number
  s_mstae  FOR  mara-mstae,                                                  "Material Status
  s_matnr  FOR  mara-matnr,                                                  "Material Number
  s_date   FOR mara-ersda OBLIGATORY.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT 1(25) text-c01 FOR FIELD s_rc_sn.
*SELECTION-SCREEN POSITION 30.
*SELECT-OPTIONS:
*  s_rc_sn  FOR  mara-free_char NO INTERVALS.                                 "Relationship Category & Society Number
*SELECTION-SCREEN COMMENT 58(40) text-c02.
*SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s03.
SELECT-OPTIONS:
  s_matnr1 FOR  mara-matnr,                                                  "Material Number
  s_mstae1 FOR  mara-mstae,                                                  "Material Status
  s_mtart1 FOR  mara-mtart,                                                  "Material Type
  s_mdtyp1 FOR  mara-ismmediatype,                                           "Media Type
  s_kdgrp1 FOR  komk-kdgrp.                                                  "Customer Group
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT 1(25) text-c01 FOR FIELD s_rc_sn1.
*SELECTION-SCREEN POSITION 30.
*SELECT-OPTIONS:
*  s_rc_sn1 FOR  mara-free_char NO INTERVALS.                                 "Relationship Category & Society Number
*SELECTION-SCREEN COMMENT 58(40) text-c02.
*SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-s04.
SELECT-OPTIONS:
  s_matnr2 FOR  mara-matnr,                                                  "Material Number
  s_mstae2 FOR  mara-mstae,                                                  "Material Status
  s_mtart2 FOR  mara-mtart,                                                  "Material Type
  s_mdtyp2 FOR  mara-ismmediatype,                                           "Media Type
  s_kdgrp2 FOR  komk-kdgrp.                                                  "Customer Group
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT 1(25) text-c01 FOR FIELD s_rc_sn2.
*SELECTION-SCREEN POSITION 30.
*SELECT-OPTIONS:
*  s_rc_sn2 FOR  mara-free_char NO INTERVALS.                                 "Relationship Category & Society Number
*SELECTION-SCREEN COMMENT 58(40) text-c02.
*SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-s05.
SELECT-OPTIONS:
  s_email  FOR  adr6-smtp_addr NO INTERVALS.                                 "E-Mail Address
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE text-s06.
PARAMETERS:
  p_idcdty TYPE jptidcdassign-idcodetype DEFAULT 'ZSSN'.                     "Type of Identification Code
SELECT-OPTIONS:
  s_opt_in FOR  mara-ismpubltype         DEFAULT 'OI'.                       "Publication Type

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
*Begin of Add-Anirban-07.25.2017-ED2K907503-Defect 3536
PARAMETERS : p_rec TYPE i DEFAULT 500.
*End of Add-Anirban-07.25.2017-ED2K907503-Defect 3536
SELECTION-SCREEN END OF BLOCK b6.
