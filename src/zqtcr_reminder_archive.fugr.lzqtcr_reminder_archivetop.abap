*----------------------------------------------------------------------*
* PROGRAM NAME:          ZQTCR_REMINDER_ARCHIVE (FM)
* PROGRAM DESCRIPTION:   FM to link the pdf form to BP
* DEVELOPER:             AGUDURKHAD
* CREATION DATE:         11/11/2018
* OBJECT ID:             F045 (ERP-7668)
* TRANSPORT NUMBER(S):   ED2K913677
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
FUNCTION-POOL zqtcr_reminder_archive.       "MESSAGE-ID ..

* INCLUDE LZQTCR_REMINDER_ARCHIVED...        " Local class definition

DATA: ls_arc_i_tab TYPE toa_dara.
DATA: lt_arc_i_tab TYPE STANDARD TABLE OF toa_dara.

CONSTANTS: gc_sap_object TYPE saeanwdid VALUE 'BUS1006',
           gc_ar_object  TYPE saeobject VALUE 'ZDPOPPDF01',
           gc_formarchiv TYPE saearchiv VALUE 'Z9'.
