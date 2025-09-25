*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTCEI_ISM_MATMAS_SGMNT_E158_2                 *
* PROGRAM DESCRIPTION:  Add IS-Media Segment(s) for MARC               *
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
  lc_mestype TYPE edimsg-mestyp VALUE 'ISM_MATMAS'.

CALL FUNCTION 'ISM_IDOC_MATMAS_CREATE_MARC'
  EXPORTING
    ps_i_mara         = mara
    ps_i_marc         = marc
    pv_i_mestyp       = lc_mestype "'ISM_MATMAS' "c_mtyp_matmas
  IMPORTING
    ps_e_idoc_cimtype = idoc_cimtype
  TABLES
    pt_e_idoc_data    = t_idoc_data.
