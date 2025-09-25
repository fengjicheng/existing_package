*----------------------------------------------------------------------*
* PROGRAM NAME:       ZCAR_IDOC_SEGMENT_DETAILS
* PROGRAM DESCRIPTION:Report to show no of segements selected
* DEVELOPER:          Nageswar (NPOLINA)
* CREATION DATE:      07/05/2019
* OBJECT ID:          XXXXX
* TRANSPORT NUMBER(S):
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Selection Screen
*----------------------------------------------------------------------*
SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: p_direct TYPE edidc-direct NO-DISPLAY,
            p_mestyp TYPE edidc-mestyp  NO-DISPLAY.   " Message type


SELECT-OPTIONS: s_mescod FOR edidc-mescod NO-DISPLAY,
                s_mesfct FOR edidc-mesfct NO INTERVALS NO-DISPLAY,
                s_idoctp FOR edidc-idoctp , " Idoc Type
                s_docnum FOR edidc-docnum,
                s_status FOR edidc-status ,

                s_credat FOR edidc-credat,
                s_cretim FOR edidc-cretim NO-DISPLAY.

PARAMETERS: p_limit  TYPE i DEFAULT 2000000.
SELECTION-SCREEN:END OF BLOCK b1.
