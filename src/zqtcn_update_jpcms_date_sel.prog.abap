*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCN_UPDATE_JPCMS_DATE_SEL (Selection Screen)
* PROGRAM DESCRIPTION: Report to update JPCMS date in material master
*                      (Program documentation maintained)
* DEVELOPER: Sarada Mukherjee (SARMUKHERJ)
* CREATION DATE: 22/12/2016
* OBJECT ID: E145
* TRANSPORT NUMBER(S): ED2K903846
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906306
* REFERENCE NO: ERP-2217
* DEVELOPER: Writtick Roy
* DATE:  2017-05-22
* DESCRIPTION: Swap the population logic of Material Availability Date
*              (MARC-ISMAVAILDATE) and Planned Goods Arrival Date
*              (MARC-ISMARRIVALDATEPL)
*              Add Z01 as Default Movement Type (along with 101)
*----------------------------------------------------------------------*
* REVISION NO: ED2K910759
* REFERENCE NO: ERP-6470
* DEVELOPER: Writtick ROY (WROY)
* DATE:  2018-02-08
* DESCRIPTION: Add Manual Execution Option with checkboxes to choose
*              individual Date fields.
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
SELECT-OPTIONS:
  s_kschl FOR nast-kschl OBLIGATORY DEFAULT 'ZNEU',
  s_vstat FOR nast-vstat OBLIGATORY DEFAULT '1'.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02.
SELECT-OPTIONS:
  s_typ_p FOR ekko-bsart OBLIGATORY DEFAULT 'NB',
  s_aac_p FOR ekpo-knttp OBLIGATORY DEFAULT 'P'.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-s03.
SELECT-OPTIONS:
  s_typ_d FOR ekko-bsart OBLIGATORY DEFAULT 'ZNB',
  s_cat_d FOR ekpo-pstyp OBLIGATORY DEFAULT '5',
  s_aac_d FOR ekpo-knttp OBLIGATORY DEFAULT 'X',
* Begin of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
  s_bwart FOR ekbe-bwart OBLIGATORY.
* End   of ADD:ERP-2217:WROY:24-MAY-2017:ED2K906306
* Begin of DEL:ERP-2217:WROY:24-MAY-2017:ED2K906306
* s_bwart FOR ekbe-bwart OBLIGATORY DEFAULT '101'.
* End   of DEL:ERP-2217:WROY:24-MAY-2017:ED2K906306
SELECTION-SCREEN END OF BLOCK b3.
* Begin of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-s04.
PARAMETERS:
  cb_man_e TYPE char1 AS CHECKBOX USER-COMMAND man.
SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-s05.
SELECT-OPTIONS:
  s_exdate FOR ekko-aedat NO-EXTENSION MODIF ID man.
PARAMETERS:
  cb_pla_d TYPE char1 AS CHECKBOX MODIF ID man DEFAULT 'X',
  cb_gda_d TYPE char1 AS CHECKBOX MODIF ID man DEFAULT 'X',
  cb_aga_d TYPE char1 AS CHECKBOX MODIF ID man DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b5.
SELECTION-SCREEN END OF BLOCK b4.
* End   of ADD:ERP-6470:WROY:07-Feb-2018:ED2K910759
SELECTION-SCREEN END OF BLOCK b1.
