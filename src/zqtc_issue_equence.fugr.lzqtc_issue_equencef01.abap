*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_ISSUE_EQUENCEF01
* PROGRAM DESCRIPTION: Edit Issue Sequence
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   12/14/2016
* OBJECT ID: C039
* TRANSPORT NUMBER(S): ED2K903634
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_IF_LOCKED
*&---------------------------------------------------------------------*
*       Check if the Media Product is locked
*----------------------------------------------------------------------*
*      -->FP_IM_MED_PROD  Media Product
*----------------------------------------------------------------------*
FORM f_check_if_locked  USING    fp_im_med_prod TYPE matnr.

  DATA:
    lst_enq_del_seq TYPE rjp_enq_deliv_seq.                            "IS-M: Lock Structure for Issue Sequence

  DATA:
    lv_lock_argumnt TYPE eqegraarg,                                    "Argument String (=Key Fields) of Lock Entry
    lv_enq_tab_name TYPE eqegraname VALUE 'RJP_ENQ_DELIV_SEQ'.         "Elementary Lock of Lock Entry (Table Name)

  DATA:
    li_lock_entries TYPE wlf_seqg3_tab.                                "Dialog Fields for Lock Display/Delete (SM12)

* Build the lock argument
  CALL 'C_ENQ_WILDCARD' ID 'HEX0' FIELD lst_enq_del_seq.               "Initialization of lock argument
  lst_enq_del_seq-mandt    = sy-mandt.                                 "Client
  lst_enq_del_seq-med_prod = fp_im_med_prod.                           "Media Product
  lv_lock_argumnt = lst_enq_del_seq.                                   "Lock Argument
* Check for Lock Entry (EJPLF - Issue Sequence)
  CALL FUNCTION 'ENQUEUE_READ'
    EXPORTING
      gclient               = sy-mandt                                 "Client
      gname                 = lv_enq_tab_name                          "Elementary Lock of Lock Entry (Table Name)
      garg                  = lv_lock_argumnt                          "Argument String (=Key Fields) of Lock Entry
      guname                = space                                    "User ID
    TABLES
      enq                   = li_lock_entries                          "List of the chosen lock entries
    EXCEPTIONS
      communication_failure = 1
      system_failure        = 2
      OTHERS                = 3.
  IF sy-subrc EQ 0 AND
     li_lock_entries[] IS NOT INITIAL.
    READ TABLE li_lock_entries ASSIGNING FIELD-SYMBOL(<lst_lock_entry>) INDEX 1.
    IF sy-subrc EQ 0.
*     Message: Issues of media product & blocked by user &
      MESSAGE e258(jd)
         WITH fp_im_med_prod
              <lst_lock_entry>-guname
      RAISING exc_lock_issue_seq.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_MED_ISSUES
*&---------------------------------------------------------------------*
*       Fetch All Issues of the Media Product
*----------------------------------------------------------------------*
*      -->FP_IM_MED_PROD        Media Product
*      -->FP_IM_X_PLANT_STATUS  X-Plant Status
*      -->FP_IM_ISSUE_VAR_TYPE  Issue Variant Type - Standard (Planned)
*      -->FP_IM_SHP_PLN_STATUS  Status of Shipping Planning
*      <--FP_LI_MEDIA_ISSUES    Media Issues
*----------------------------------------------------------------------*
FORM f_fetch_med_issues  USING    fp_im_med_prod       TYPE matnr
                                  fp_im_x_plant_status TYPE rjksd_mstae_range_tab
                                  fp_im_issue_var_type TYPE ztqtc_vavartyp_range
                                  fp_im_shp_pln_status TYPE rjkse_nipstatus_range_tab
                         CHANGING fp_li_media_issues   TYPE ism_mdissue_tab.

  DATA:
    li_media_issues TYPE ism_mdissue_tab.

* Read All Issues for Media Product
  CALL FUNCTION 'ISM_ISSUE_PROVIDE_BY_PRODUCT'
    EXPORTING
      pv_i_product = fp_im_med_prod                                    "Media Product
    TABLES
      pt_e_issue   = fp_li_media_issues                                "List of Media Issues
    EXCEPTIONS
      no_issues    = 1
      OTHERS       = 2.
  IF sy-subrc EQ 0.
*   Fetch Shipping Schedule Details
    SELECT id,                                                         "ID of Next Issue Pointer
           product,                                                    "Media Product
           issue,                                                      "Media Issue
           status                                                      "IS-M: Status of Shipping Planning
      FROM jksenip                                                     "Shipping Schedule
      INTO TABLE @DATA(li_shp_sch)
       FOR ALL ENTRIES IN @fp_li_media_issues
     WHERE product EQ @fp_im_med_prod                                  "Media Product
       AND issue   EQ @fp_li_media_issues-matnr.                       "Media Issue
    IF sy-subrc EQ 0.
      SORT li_shp_sch BY issue.
    ENDIF.

*   Determine if the Media Issue needs to be removed from the Issue Sequence
    LOOP AT fp_li_media_issues ASSIGNING FIELD-SYMBOL(<lst_media_issue>).
*     Check if the Media Issue can be removed from from the Issue Sequence
*     depending Status of Shipping Planning (Initial / Planned)
      READ TABLE li_shp_sch ASSIGNING FIELD-SYMBOL(<lst_shp_sch>)
           WITH KEY issue = <lst_media_issue>-matnr
           BINARY SEARCH.
      IF sy-subrc NE 0 OR                                              "Not in Issue Sequence Yet
       ( <lst_shp_sch> IS ASSIGNED AND
         <lst_shp_sch>-status IN fp_im_shp_pln_status ).               "IS-M: Status of Shipping Planning
*       Filter based on Cross-Plant Material Status
        IF fp_im_x_plant_status[]  IS NOT INITIAL AND
           <lst_media_issue>-mstae NOT IN fp_im_x_plant_status.
          CLEAR: <lst_media_issue>-matnr.
        ENDIF.
*       Filter based on Issue Variant Type - Standard (Planned)
        IF fp_im_issue_var_type[]  IS NOT INITIAL AND
           <lst_media_issue>-ismissuetypest IN fp_im_issue_var_type.
          CLEAR: <lst_media_issue>-matnr.
        ENDIF.
      ENDIF.
      UNASSIGN: <lst_shp_sch>.
    ENDLOOP.
    DELETE fp_li_media_issues WHERE matnr IS INITIAL.

*   Sort entries based on Publication Date
    SORT fp_li_media_issues BY ismpubldate.
  ELSE.
*   Message: No media issue found for media product
    MESSAGE e285(jksdorder)
       WITH fp_im_med_prod
    RAISING exc_no_issue.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_EDIT_ISSUE_SEQ
*&---------------------------------------------------------------------*
*       Create / Update Issue Sequence
*----------------------------------------------------------------------*
*      -->FP_IM_MED_PROD      Media Product
*      -->FP_LI_MEDIA_ISSUES  Media Issues
*----------------------------------------------------------------------*
FORM f_edit_issue_seq  USING    fp_im_med_prod     TYPE matnr
                                fp_li_media_issues TYPE ism_mdissue_tab.

  DATA:
    lv_xerror       TYPE xfeld,
    lv_xsave_abort  TYPE xfeld,
    lv_xbatch_error TYPE xfeld.

* Initialize Transaction (Custom Logic)
  PERFORM f_init_transaction USING fp_im_med_prod.

* Initialize (Calling subroutine of standard program)
  PERFORM d0100_init           IN PROGRAM sapmjpg0 IF FOUND.

* Validate (Calling subroutine of standard program)
  PERFORM input_check_and_read IN PROGRAM sapmjpg0 IF FOUND.

* Populate Media Issue details (Custom Logic)
  PERFORM f_popule_med_issue USING fp_im_med_prod
                                   fp_li_media_issues.

* Save / Post (Calling subroutine of standard program)
  v_c039_flag = abap_true.                                             "Flag: To indicate C039 processing
  PERFORM checks_and_save IN PROGRAM sapmjpg0 IF FOUND
 CHANGING lv_xerror
          lv_xsave_abort
          lv_xbatch_error.
  v_c039_flag = abap_false.                                            "Flag: To indicate C039 processing
  IF lv_xsave_abort  IS NOT INITIAL OR
     lv_xbatch_error IS NOT INITIAL OR
     lv_xerror       IS NOT INITIAL.
*   Message: Error while saving rule for issue sequence (media product &)
    MESSAGE e009(jpmgen)
       WITH fp_im_med_prod
    RAISING exc_error_in_iss_seq.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INIT_TRANSACTION
*&---------------------------------------------------------------------*
*       Initialize Transaction
*----------------------------------------------------------------------*
*      -->FP_IM_MED_PROD  Media Product
*----------------------------------------------------------------------*
FORM f_init_transaction  USING    fp_im_med_prod TYPE matnr.

  DATA:
    lv_init_date   TYPE sydatum,                                       "Date (Initial value)
    lv_f_init_0100 TYPE char30     VALUE '(SAPMJPG0)INIT_0100'.        "Initialize Transaction

  FIELD-SYMBOLS:
    <lv_init_0100> TYPE xfeld.                                         "Initialize Transaction

* Mimicing functionality of Standard transaction JPMG0
  sy-tcode = 'JPMG0'.
  SET PARAMETER ID 'JP1'     FIELD lv_init_date.                       "Sel: From Publication Date
  SET PARAMETER ID 'JP2'     FIELD lv_init_date.                       "Sel: To Publication Date
  SET PARAMETER ID 'JP3'     FIELD space.                              "Sel: From Copy Number
  SET PARAMETER ID 'JP4'     FIELD space.                              "Sel: To Copy Number
  SET PARAMETER ID 'JP5'     FIELD space.                              "Sel: From Media Issue
  SET PARAMETER ID 'JP6'     FIELD space.                              "Sel: To Media Issue
  SET PARAMETER ID 'JP7'     FIELD space.                              "Sel: Selection Variant for Issue Sequence
  SET PARAMETER ID 'JP_PROD' FIELD fp_im_med_prod.                     "Sel: Media Product
* Initialize Transaction
  ASSIGN (lv_f_init_0100) TO <lv_init_0100>.
  IF sy-subrc EQ 0.
    CLEAR: <lv_init_0100>.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULE_MED_ISSUE
*&---------------------------------------------------------------------*
*       Populate Media Issue details
*----------------------------------------------------------------------*
*      -->FP_IM_MED_PROD      Media Product
*      -->FP_LI_MEDIA_ISSUES  Media Issues
*----------------------------------------------------------------------*
FORM f_popule_med_issue  USING  fp_im_med_prod     TYPE matnr
                                fp_li_media_issues TYPE ism_mdissue_tab.

* Begin of ADD:SAP Recommendations:WROY:10-AUG-2017:ED2K907855
  DATA:
    li_media_issues TYPE ism_mdissue_tab.
* End   of ADD:SAP Recommendations:WROY:10-AUG-2017:ED2K907855

* Begin of DEL:SAP Recommendations:WROY:10-AUG-2017:ED2K907855
* DATA:
*   lst_mat_desc    TYPE makt.                                         "Material Descriptions
* End   of DEL:SAP Recommendations:WROY:10-AUG-2017:ED2K907855

  DATA:
    lv_med_iss_seq  TYPE mpg_lfdnr,                                    "Sequence number of media issue within issue sequence
    lv_dynpro_table TYPE char30     VALUE '(SAPMJPG0)LF_DYNPRO_TAB[]'. "IS-M: Table for Media Product Generation: Media Issues

  FIELD-SYMBOLS:
    <li_issue_seqs> TYPE rjp_mg1_tab.                                  "IS-M: Table for Media Product Generation: Media Issues

* Begin of ADD:SAP Recommendations:WROY:10-AUG-2017:ED2K907855
  IF fp_li_media_issues IS NOT INITIAL.
    li_media_issues[] = fp_li_media_issues[].
    SORT li_media_issues BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_media_issues
                  COMPARING matnr.
    SELECT matnr,                                                      "Material Number
           maktx                                                       "Material Description (Short Text)
      FROM makt
      INTO TABLE @DATA(li_mat_desc)
       FOR ALL ENTRIES IN @li_media_issues
     WHERE matnr EQ @li_media_issues-matnr
       AND spras EQ @sy-langu.
    IF sy-subrc EQ 0.
      SORT li_mat_desc BY matnr.
    ENDIF.
  ENDIF.
* End   of ADD:SAP Recommendations:WROY:10-AUG-2017:ED2K907855

  ASSIGN (lv_dynpro_table) TO <li_issue_seqs>.
  CLEAR: <li_issue_seqs>,
         lv_med_iss_seq.
  LOOP AT fp_li_media_issues ASSIGNING FIELD-SYMBOL(<lst_med_issue>).
    APPEND INITIAL LINE TO <li_issue_seqs> ASSIGNING FIELD-SYMBOL(<lst_issue_seq>).
    MOVE-CORRESPONDING <lst_med_issue> TO <lst_issue_seq>.
    <lst_issue_seq>-med_prod   = fp_im_med_prod.                       "Higher-Level Media Product
    <lst_issue_seq>-xgenerate  = abap_true.                            "IS-M: Media issue being created or already exists
    <lst_issue_seq>-xmaraexist = abap_true.                            "IS-M: Media Issue Already Exists on Database
    <lst_issue_seq>-mark       = abap_true.                            "Checkbox
    <lst_issue_seq>-xdbexist   = abap_true.                            "IS-M: Media issue already exists on database
*   Fetch Material Description
*   Begin of ADD:SAP Recommendations:WROY:10-AUG-2017:ED2K907855
    READ TABLE li_mat_desc INTO DATA(lst_mat_desc)
         WITH KEY matnr = <lst_med_issue>-matnr                        "Media Issue
         BINARY SEARCH.
*   End   of ADD:SAP Recommendations:WROY:10-AUG-2017:ED2K907855
*   Begin of DEL:SAP Recommendations:WROY:10-AUG-2017:ED2K907855
*   CALL FUNCTION 'MAKT_SINGLE_READ'
*     EXPORTING
*       matnr      = <lst_med_issue>-matnr                             "Media Issue
*       spras      = sy-langu                                          "Language Key
*     IMPORTING
*       wmakt      = lst_mat_desc                                      "Material Description
*     EXCEPTIONS
*       wrong_call = 1
*       not_found  = 2
*       OTHERS     = 3.
*   End   of DEL:SAP Recommendations:WROY:10-AUG-2017:ED2K907855
    IF sy-subrc EQ 0.
      <lst_issue_seq>-maktx    = lst_mat_desc-maktx.                   "Material Description (Short Text)
    ENDIF.
*   Calculate Sequence number of media issue within issue sequence
    lv_med_iss_seq = lv_med_iss_seq + 1.
    <lst_issue_seq>-mpg_lfdnr  = lv_med_iss_seq.                       "Sequence number of media issue within issue sequence
  ENDLOOP.

  SET PARAMETER ID 'MAT' FIELD fp_im_med_prod.                         "Media Product

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UNLOCK_ENTRIES
*&---------------------------------------------------------------------*
*       Unlock entries (Media Product)
*----------------------------------------------------------------------*
*  -->  No parameter
*----------------------------------------------------------------------*
FORM f_unlock_entries .

* Unlock entries
  CALL FUNCTION 'DEQUEUE_ALL'
    EXPORTING
      _synchron = abap_true.

ENDFORM.
