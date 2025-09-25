*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCC_EDIT_ISSUE_SEQUENCE
* PROGRAM DESCRIPTION: Edit Issue Sequence
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   12/14/2016
* OBJECT ID: C039
* TRANSPORT NUMBER(S): ED2K903634
*----------------------------------------------------------------------*
REPORT zqtcc_edit_issue_sequence.

INCLUDE zqtcn_edit_issue_sequence_top IF FOUND.
INCLUDE zqtcn_edit_issue_sequence_sel IF FOUND.
INCLUDE zqtcn_edit_issue_sequence_sub IF FOUND.

INITIALIZATION.
* Populate Selection Screen Default Values
  PERFORM f_populate_defaults CHANGING s_mtyp_i[]
                                       s_st_del[]
                                       s_iv_typ[]
                                       s_shp_st[].

AT SELECTION-SCREEN ON s_mtyp_i.
* Validate Material Type
  PERFORM f_validate_mat_type USING    s_mtyp_i[].

AT SELECTION-SCREEN ON s_st_del.
* Validate X-Plant Status
  PERFORM f_validate_status   USING    s_st_del[].

AT SELECTION-SCREEN ON s_iv_typ.
* Validate Issue Variant Type - Standard (Planned)
  PERFORM f_validate_iv_type  USING    s_iv_typ[].

AT SELECTION-SCREEN ON s_shp_st.
* Validate Status of Shipping Planning
  PERFORM f_validate_shp_st   USING    s_shp_st[].

START-OF-SELECTION.
* Fetch and Process Records
  PERFORM f_fetch_n_process   USING    s_mtyp_i[]
                                       s_st_del[]
                                       s_iv_typ[]
                                       s_shp_st[]
                                       p_ts_upd.
