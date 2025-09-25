*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_OPM_ORDER_SEL
* PROGRAM DESCRIPTION: Create ZOPM (Online Program Management ) contracts
* DEVELOPER: Nageswara (NPOLINA)
* CREATION DATE:   03/06/2019
* OBJECT ID:       C108
* TRANSPORT NUMBER(S): ED2K914619
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
* TRANSPORT NUMBER(S):
*------------------------------------------------------------------- *

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
PARAMETERS: p_file  TYPE rlgrap-filename . "rlgrap-filename    " Local file for upload
PARAMETERS: p_a_file  TYPE localfile NO-DISPLAY,
            p_job TYPE tbtcjob-jobname NO-DISPLAY,
            p_userid  TYPE syuname  NO-DISPLAY.

SELECTION-SCREEN: FUNCTION KEY 1.
SELECTION-SCREEN END OF BLOCK b1.
