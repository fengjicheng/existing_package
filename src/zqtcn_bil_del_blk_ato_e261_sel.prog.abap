*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BIL_DEL_BLK_ATO_E261_SEL.
*&---------------------------------------------------------------------*
*& PROGRAM NAME: ZQTCE_BILL_DELV_BLK_AUTO
*& PROGRAM DESCRIPTION: As a CSR, I need the system to automatically
*&                      release DG billing and delivery blocks on
*&                      existing orders/subs when the DG block is
*&                      removed from the customer in order to service
*&                      our customer quicker
*& DEVELOPER: AMOHAMMED
*& CREATION DATE: 11/24/2020
*& OBJECT ID: E261
*& TRANSPORT NUMBER(S): ED2K920450
*&---------------------------------------------------------------------*
*& REVISION HISTORY----------------------------------------------------*
*& REVISION NO:  ED2K926799
*& REFERENCE NO: OTCM-55825
*& DEVELOPER:    Nikhilesh Palla (NPALLA)
*& DATE:         12-Apr-2022
*& DESCRIPTION:  Change "No.of days old order" field from 2 to 3 digits
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
*---BOC NPALLA Staging Changes 04/12/2022 ED2K926799 E261  OTCM-55825
*PARAMETERS : p_days(2) TYPE n OBLIGATORY.                        " No.of days old order
PARAMETERS : p_days(3) TYPE n OBLIGATORY.                        " No.of days old order
*---EOC NPALLA Staging Changes 04/12/2022 ED2K926799 E261  OTCM-55825
SELECT-OPTIONS : s_lifsk FOR vbak-lifsk NO INTERVALS OBLIGATORY, " Delivery block (document header)
                 s_faksk FOR vbak-faksk NO INTERVALS OBLIGATORY. " Billing block in SD document
SELECTION-SCREEN END OF BLOCK b1.
