*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTC_INVRECON_DEL_SCR
* PROGRAM DESCRIPTION: To Delete Data from Inventory Recon table
*                      ZQTC_INVEN_RECON based on
*                      Adjustment Type
*                      Material No
*                      Date
* DEVELOPER: Rajasekhar.T (RBTIRUMALA)
* CREATION DATE: 21/03/2019
* OBJECT ID: RITM0126734
* TRANSPORT NUMBER(S): ED1K909853
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTC_INVRECON_DEL_SCR
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS : S_ZDATE  FOR  v_ZDATE  NO INTERVALS NO-EXTENSION OBLIGATORY.                "Transactional date
PARAMETERS :     P_ADJTYP LIKE v_ADJTYP OBLIGATORY.                "Adjustment Type
SELECT-OPTIONS : s_MATNR  for  v_MATNR  NO INTERVALS NO-EXTENSION, "Material Number
                 s_WERKS  for  v_WERKS  NO INTERVALS NO-EXTENSION. "Delivering Plant
SELECTION-SCREEN Skip 1.
PARAMETERS : P_CHK AS CHECKBOX DEFAULT 'X'.  "Test Mode
SELECTION-SCREEN END OF BLOCK B1.
