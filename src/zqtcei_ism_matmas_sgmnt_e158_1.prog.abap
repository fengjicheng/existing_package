*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTCEI_ISM_MATMAS_SGMNT_E158_1                 *
* PROGRAM DESCRIPTION:  Add IS-Media Segment(s) for MARA               *
* DEVELOPER:            MMUKHERJEE                                     *
* CREATION DATE:        18/04/2017                                     *
* OBJECT ID:            I158                                           *
* TRANSPORT NUMBER(S):  ED2K905426,ED2K905437(C)                       *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

CONSTANTS:
lc_mestyp TYPE edimsg-mestyp VALUE 'ISM_MATMAS'.

CALL FUNCTION 'ISM_IDOC_MATMAS_CREATE'
  EXPORTING
    ps_i_mara         = mara
    pv_i_mestyp       = lc_mestyp "'ISM_MATMAS'
  IMPORTING
    ps_e_idoc_cimtype = idoc_cimtype
  TABLES
    pt_e_idoc_data    = t_idoc_data.
