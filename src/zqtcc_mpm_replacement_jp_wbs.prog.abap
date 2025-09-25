*----------------------------------------------------------------------*
* PROGRAM NAME:         ZQTCC_MPM_REPLACEMENT_JP_WBS
* PROGRAM DESCRIPTION:  MPM replacement on JP WBS element
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
*& Report  ZQTCC_MPM_REPLACEMENT_JP_WBS
*&
*&---------------------------------------------------------------------*

REPORT zqtcc_mpm_replacement_jp_wbs.

INCLUDE zqtcn_mpm_rplcmnt_wbs_top IF FOUND.
INCLUDE zqtcn_mpm_rplcmnt_wbs_sel IF FOUND.
INCLUDE zqtcn_mpm_rplcmnt_wbs_sub IF FOUND.

INITIALIZATION.

* Populate Selection Screen Default Values
  PERFORM f_populate_defaults CHANGING s_mtyp_o[]
                                       s_mtyp_n[].


AT SELECTION-SCREEN ON s_proj.
* Validate Project Definition
  PERFORM f_validate_proj_dfntn USING s_proj[].

AT SELECTION-SCREEN ON s_wbs.
* Validate WBS Element
  PERFORM f_validate_wbs USING s_wbs[].

AT SELECTION-SCREEN ON s_bukrs.
* Validate Company code for WBS element
  PERFORM f_validate_bukrs USING s_bukrs[].

AT SELECTION-SCREEN ON s_mpm.
* Validate MPM Issue
  PERFORM f_validate_zzmpm USING s_mpm[].

AT SELECTION-SCREEN ON s_mtyp_o.
* Validate Material Type(Old)
  PERFORM f_validate_mat_type USING s_mtyp_o[].

AT SELECTION-SCREEN ON s_mtyp_n.
* Validate Material Type(New)
  PERFORM f_validate_mat_type USING s_mtyp_n[].

AT SELECTION-SCREEN ON p_idtype.
* Validate Type of Identification Code
  PERFORM f_validate_idtype USING p_idtype.

START-OF-SELECTION.
* Fetch and Process Records
  PERFORM f_fetch_process_records USING s_proj[]
                                        s_wbs[]
                                        s_bukrs[]
                                        s_mpm[]
                                        s_mtyp_o[]
                                        s_mtyp_n[]
                                        p_idtype.
