*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCR_WLS_ORDER_UPLOAD_E250 (Main Program)
* PROGRAM DESCRIPTION : Create  contracts for WLS Project
* DEVELOPER           : VDPATABALL
* CREATION DATE       : 06/26/2020
* OBJECT ID           : E250
* TRANSPORT NUMBER(S) : ED2K918622
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
PARAMETERS: p_file  TYPE rlgrap-filename OBLIGATORY. "rlgrap-filename    " Local file for upload
PARAMETERS: p_vkorg TYPE vkorg AS LISTBOX VISIBLE LENGTH 25 OBLIGATORY,
            p_vtweg TYPE vtweg ,
            p_kschl TYPE kschl ,
            p_tdid  TYPE tdid .
PARAMETERS: p_a_file TYPE localfile NO-DISPLAY,
            p_job    TYPE tbtcjob-jobname NO-DISPLAY,
            p_userid TYPE syuname  NO-DISPLAY.

SELECTION-SCREEN: FUNCTION KEY 1.
SELECTION-SCREEN END OF BLOCK b1.
