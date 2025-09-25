*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCR_REPAIR_ADDRESS_SEL
* PROGRAM DESCRIPTION: This report uses a sales document order as input.
*                      The incorrect addresses in the specified document
*                      will be set to the standard address coming from
*                      customer master data. It is possible to maintain/change
*                      such a document afterwards.
*                      This report has a testflag. Please test the report
*                      carefully with this flag before changing data.
*                      - per Note 2713240 (Z_REPAIR_ADRNR_1)
* DEVELOPER:           Nikhiesh Palla (NPALLA).
* CREATION DATE:       09/13/2019
* OBJECT ID:
* TRANSPORT NUMBER(S): ED1K910781
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
*----------------------------------------------------------------------*

*====================================================================*
* Selection Screen
*====================================================================*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .
SELECT-OPTIONS: s_vbeln FOR vbpa-vbeln OBLIGATORY.  " Sales and Distribution Document Number
PARAMETERS: p_test AS CHECKBOX DEFAULT 'X'.         " Test Run
SELECTION-SCREEN END OF BLOCK b1.
