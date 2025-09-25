*---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SOCIETY_MEMBER_PRGE_SEL (Include Program)
* PROGRAM DESCRIPTION: Define Selection Screen
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   05/12/2020
* WRICEF ID:       R106
* TRANSPORT NUMBER(S):  ED2K918190
*---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN  OF BLOCK b1 WITH FRAME TITLE text-001.

SELECT-OPTIONS : s_socbp FOR but050-partner2 NO INTERVALS NO-EXTENSION OBLIGATORY,    " Society BP
                 s_reltyp FOR but050-reltyp.                                          " Relationship Category

SELECTION-SCREEN END OF BLOCK b1.
