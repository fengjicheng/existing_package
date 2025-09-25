*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTCN_MPM_RPLCMNT_WBS_SEL
* PROGRAM DESCRIPTION:  Include for Selection Screen
* DEVELOPER:            Aratrika Banerjee(ARABANERJE)
* CREATION DATE:        17-Jan-2017
* OBJECT ID:            C079
* TRANSPORT NUMBER(S):  ED2K904151
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
*&  Include           ZQTCN_MPM_RPLCMNT_WBS_SEL
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-s01.
SELECT-OPTIONS:
  s_proj   FOR proj-pspid, " Project Definition
  s_wbs FOR prps-pspnr,    " WBS Element
  s_bukrs  FOR prps-pbukr, " Company code for WBS element
  s_mpm    FOR prps-zzmpm, " MPM Issue
  s_mtyp_o FOR mara-mtart, " Material Type
  s_mtyp_n FOR mara-mtart. " Material Type
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-s02.
PARAMETERS: p_idtype TYPE ismidcodetype DEFAULT c_jrnl.
SELECTION-SCREEN END OF BLOCK b2.
