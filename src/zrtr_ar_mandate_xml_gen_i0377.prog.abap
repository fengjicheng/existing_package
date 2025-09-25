*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTR_AR_MANDATE_XML_GEN_I0377
* PROGRAM DESCRIPTION: This report used to generate the XML file
* into AL11 directory. (XML file contains SEPA_Mandate info)
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
*& Report  ZRTR_AR_MANDATE_XML_GEN_I0377
*&
*&---------------------------------------------------------------------*
REPORT zrtr_ar_mandate_xml_gen_i0377 NO STANDARD PAGE HEADING.

INCLUDE zrtr_ar_mandate_xml_gen_top.    " Global Data Declarations

INCLUDE zrtr_ar_mandate_xml_gen_sscrn.  " Selection Screen

INCLUDE zrtr_ar_mandate_xml_gen_s01.    " Subroutines

INITIALIZATION.
  PERFORM f_initialization.

AT SELECTION-SCREEN OUTPUT.
  PERFORM f_modify_sel_screen.

AT SELECTION-SCREEN.
  PERFORM f_ss_validations.

START-OF-SELECTION.
  PERFORM f_get_data.
