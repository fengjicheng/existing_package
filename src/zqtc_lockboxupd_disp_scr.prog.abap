*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTC_LOCKBOXUPD_DISP_SCR
* PROGRAM DESCRIPTION: To Display Lockbox ZQTCLOCKBOX_UPD Table Data
* DEVELOPER: Rajasekhar.T (RBTIRUMALA)
* CREATION DATE: 18/03/2019
* OBJECT ID: INC0235034
* TRANSPORT NUMBER(S): ED1K909832
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K911298
* REFERENCE NO:  ERPM-3463
* DEVELOPER: GKAMMILI
* DATE:  11/07/2019
* DESCRIPTION:Adding Reason code in selection screen and providing
*             Variant save option in the output
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTC_LOCKBOXUPD_DISP_SCR
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS : S_augdt FOR  v_augdt OBLIGATORY.                 "Clearing Date
PARAMETERS :     P_BUKRS LIKE v_bukrs OBLIGATORY.                 "Company Code
SELECT-OPTIONS : s_BELNR for v_BELNR NO INTERVALS NO-EXTENSION,   "Document No
                 s_KUNNR for v_KUNNR NO INTERVALS NO-EXTENSION,   "Customer No
                 s_rcode FOR v_rcode .                       "Reason Code Added by GKAMMILI on 07/11/2019 TR-ED1K911298 Jar ERPM - 3463

SELECTION-SCREEN END OF BLOCK B1.
