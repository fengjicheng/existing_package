*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_E205_ORDER_UPLOAD (Main Program)
* PROGRAM DESCRIPTION: Create order for Knewton
* DEVELOPER: Nageswara (NPOLINA)
* CREATION DATE:   05/28/2019
* OBJECT ID:       E205
* TRANSPORT NUMBER(S): ED2K915128
*----------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------
* REVISION NO   : ED2K919875
* REFERENCE NO  : OTCM-4728
* DEVELOPER     : VDPATABALL
* DATE(MM/DD/YYYY): 10/12/2020
* DESCRIPTION   : If the check box is enable then creating the sales order
*-------------------------------------------------------------------
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
* TRANSPORT NUMBER(S):
*------------------------------------------------------------------- *

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
PARAMETERS: p_file  TYPE rlgrap-filename OBLIGATORY. "rlgrap-filename    " Local file for upload
PARAMETERS: p_vkorg TYPE vkorg AS LISTBOX VISIBLE LENGTH 25 OBLIGATORY,
            p_vtweg TYPE vtweg,
            p_kschl TYPE kschl,
            p_tdid  TYPE tdid,
            ch_sales AS CHECKBOX. "++VDPATABALL OTCM-4728 ED2K919875 Knewton Sales Order changes
PARAMETERS: p_a_file TYPE localfile NO-DISPLAY,
            p_job    TYPE tbtcjob-jobname NO-DISPLAY,
            p_userid TYPE syuname  NO-DISPLAY.

SELECTION-SCREEN: FUNCTION KEY 1.
SELECTION-SCREEN END OF BLOCK b1.
