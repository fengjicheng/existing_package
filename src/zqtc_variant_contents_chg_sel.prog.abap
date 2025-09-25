*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_VARIANT_CONTENTS_CHG_SEL (Include Program)
* PROGRAM DESCRIPTION: Variant Content Change
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE:   04/01/2018
* OBJECT ID:  ?
* TRANSPORT NUMBER(S): ED2K911732
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS:p_pr_n TYPE rsvar-report OBLIGATORY.  "Program Name
PARAMETERS:p_vr_n TYPE rsvar-variant OBLIGATORY. "Varaint Name
PARAMETERS:p_div TYPE p OBLIGATORY.              "Division
SELECTION-SCREEN END OF BLOCK b1.
