*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTR_AR_MANDATE_XML_GEN_I0377
* PROGRAM DESCRIPTION: This report used to generate the XML file into AL11
* DEVELOPER:           Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE:       18/11/2019
* OBJECT ID:           I0377
* TRANSPORT NUMBER(S): ED2K916852
*----------------------------------------------------------------------*
* REVISION HISTORY:
* REVISION NO:  <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:         MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&  Include  ZRTR_AR_MANDATE_XML_GEN_SSCRN
*&---------------------------------------------------------------------*

PARAMETERS:
  p_fpath TYPE localfile OBLIGATORY LOWER CASE,
  p_dtag  TYPE string OBLIGATORY LOWER CASE DEFAULT '<Document xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:iso:std:iso:20022:tech:xsd:pain.008.001.02">',
  p_appid TYPE sepa_anwnd OBLIGATORY DEFAULT 'F'.
SELECT-OPTIONS:
   s_mndid  FOR v_mndid  NO INTERVALS LOWER CASE,
   s_crdid  FOR v_crdid  NO INTERVALS LOWER CASE,
   s_credt  FOR v_credt  NO-EXTENSION,
   s_fcdate FOR v_fcdate NO-EXTENSION,
   s_fctime FOR v_fctime NO-EXTENSION.

SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_full TYPE char1 AS CHECKBOX USER-COMMAND full MODIF ID ful.
SELECTION-SCREEN:
  COMMENT 2(15) text-001 FOR FIELD p_full.
SELECTION-SCREEN POSITION 20.
PARAMETERS: p_disp TYPE char1 AS CHECKBOX. " USER-COMMAND delt MODIF ID del.
SELECTION-SCREEN:
  COMMENT 22(25) text-002 FOR FIELD p_disp.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN SKIP.
PARAMETERS: p_cutdt TYPE sepa_erdat MODIF ID cdt.
