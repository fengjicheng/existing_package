*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_EDIT_ISSUE_SEQUENCE_SUB
* PROGRAM DESCRIPTION: Edit Issue Sequence
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   12/14/2016
* OBJECT ID: C039
* TRANSPORT NUMBER(S): ED2K903634
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DEFAULTS
*&---------------------------------------------------------------------*
*       Populate Selection Screen Default Values
*----------------------------------------------------------------------*
*      <--FP_S_MTYP_I  Material Type (Media Issue)
*      <--FP_S_ST_DEL  X-Plant Status
*      <--FP_S_IV_TYP  Issue Variant Type - Standard (Planned)
*      <--FP_S_SHP_ST  Status of Shipping Planning
*----------------------------------------------------------------------*
FORM f_populate_defaults  CHANGING fp_s_mtyp_i TYPE cfb_t_mtart_range
                                   fp_s_st_del TYPE rjksd_mstae_range_tab
                                   fp_s_iv_typ TYPE ztqtc_vavartyp_range
                                   fp_s_shp_st TYPE rjkse_nipstatus_range_tab.

* Material Type (Media Issue)
  APPEND INITIAL LINE TO fp_s_mtyp_i ASSIGNING FIELD-SYMBOL(<lst_mtyp_i>).
  <lst_mtyp_i>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_mtyp_i>-option = c_opti_equal. "Option: (EQ)ual
  <lst_mtyp_i>-low    = c_mtart_zjip. "Material Type: ZJIP
  <lst_mtyp_i>-high   = space.
  APPEND INITIAL LINE TO fp_s_mtyp_i ASSIGNING <lst_mtyp_i>.
  <lst_mtyp_i>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_mtyp_i>-option = c_opti_equal. "Option: (EQ)ual
  <lst_mtyp_i>-low    = c_mtart_zjid. "Material Type: ZJID
  <lst_mtyp_i>-high   = space.

* Cross-Plant Status
  APPEND INITIAL LINE TO fp_s_st_del ASSIGNING FIELD-SYMBOL(<lst_st_del>).
  <lst_st_del>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_st_del>-option = c_opti_equal. "Option: (EQ)ual
  <lst_st_del>-low    = c_mstae_p. "X-Plant Status: P (Current Publication)
  <lst_st_del>-high   = space.
  APPEND INITIAL LINE TO fp_s_st_del ASSIGNING <lst_st_del>.
  <lst_st_del>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_st_del>-option = c_opti_equal. "Option: (EQ)ual
  <lst_st_del>-low    = c_mstae_n. "X-Plant Status: N (Not yet published)
  <lst_st_del>-high   = space.

* Issue Variant Type - Standard (Planned)
  APPEND INITIAL LINE TO fp_s_iv_typ ASSIGNING FIELD-SYMBOL(<lst_iv_typ>).
  <lst_iv_typ>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_iv_typ>-option = c_opti_equal. "Option: (EQ)ual
  <lst_iv_typ>-low    = c_iv_typ_02. "Issue Variant Type - Standard (Exclude)
  <lst_iv_typ>-high   = space.

* Status of Shipping Planning
  APPEND INITIAL LINE TO fp_s_shp_st ASSIGNING FIELD-SYMBOL(<lst_shp_st>).
  <lst_shp_st>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_shp_st>-option = c_opti_equal. "Option: (EQ)ual
  <lst_shp_st>-low    = c_shp_st_00.  "Status of Shipping Schedule Record (Initial)
  <lst_shp_st>-high   = space.
  APPEND INITIAL LINE TO fp_s_shp_st ASSIGNING <lst_shp_st>.
  <lst_shp_st>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_shp_st>-option = c_opti_equal. "Option: (EQ)ual
  <lst_shp_st>-low    = c_shp_st_01.  "Status of Shipping Schedule Record (Planned)
  <lst_shp_st>-high   = space.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MAT_TYPE
*&---------------------------------------------------------------------*
*       Validate Material Type
*----------------------------------------------------------------------*
*      -->FP_S_MTYP_I  Material Type (Media Issue)
*----------------------------------------------------------------------*
FORM f_validate_mat_type  USING    fp_s_mtyp_i TYPE cfb_t_mtart_range.

* Material Types
  SELECT mtart "Material type
    FROM t134  " Material Types
   UP TO 1 ROWS
    INTO @DATA(lv_mtart)
   WHERE mtart IN @fp_s_mtyp_i.
  ENDSELECT.
  IF sy-subrc NE 0.
*   Message: Invalid material type; check your entry
    MESSAGE e084(ob). " Invalid material type,check your entry
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_STATUS
*&---------------------------------------------------------------------*
*       Validate X-Plant Status
*----------------------------------------------------------------------*
*      -->FP_S_ST_DEL  X-Plant Status
*----------------------------------------------------------------------*
FORM f_validate_status  USING    fp_s_st_del TYPE rjksd_mstae_range_tab.

* Material Status from Materials Management/PPC View
  SELECT mmsta "Material status from MM/PP view
    FROM t141  " Material Status from Materials Management/PPC View
   UP TO 1 ROWS
    INTO @DATA(lv_mmsta)
   WHERE mmsta IN @fp_s_st_del.
  ENDSELECT.
  IF sy-subrc NE 0.
*   Message: Invalid Material status
    MESSAGE e294(8i). " Invalid Material status
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_IV_TYPE
*&---------------------------------------------------------------------*
*       Validate Issue Variant Type - Standard (Planned)
*----------------------------------------------------------------------*
*      -->FP_S_IV_TYP    Issue Variant Type - Standard (Planned)
*----------------------------------------------------------------------*
FORM f_validate_iv_type  USING    fp_s_iv_typ TYPE ztqtc_vavartyp_range.

* IS-M/SD: Issue Variant Types
  SELECT vavartyp "Issue Variant Type
    FROM tjd05    " IS-M/SD: Issue Variant Types
   UP TO 1 ROWS
    INTO @DATA(lv_ivtyp)
   WHERE vavartyp IN @fp_s_iv_typ.
  ENDSELECT.
  IF sy-subrc NE 0.
*   Message: Invalid issue variant type
    MESSAGE e665(jr). " Invalid issue variant type
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_N_PROCESS
*&---------------------------------------------------------------------*
*       Fetch and Process Records
*----------------------------------------------------------------------*
*      -->FP_S_MTYP_I  Material Type (Media Issue)
*      -->FP_S_ST_DEL  X-Plant Status
*      -->FP_S_IV_TYP  Issue Variant Type - Standard (Planned)
*      -->FP_S_SHP_ST  Status of Shipping Planning
*      -->FP_P_TS_UPD  Update TimeStamp Even If Error
*----------------------------------------------------------------------*
FORM f_fetch_n_process  USING    fp_s_mtyp_i TYPE cfb_t_mtart_range
                                 fp_s_st_del TYPE rjksd_mstae_range_tab
                                 fp_s_iv_typ TYPE ztqtc_vavartyp_range
                                 fp_s_shp_st TYPE rjkse_nipstatus_range_tab
                                 fp_p_ts_upd TYPE char1. " P_ts_upd of type CHAR1

  DATA:
    lv_curr_date TYPE sydatum, "Current/To Date
    lv_curr_time TYPE syuzeit, "Current/To Time
    lv_from_date TYPE sydatum, "From Date
    lv_from_time TYPE syuzeit, "From Time
    lv_any_error TYPE flag.    "Flag: Any Error

  DATA:
    li_med_issue TYPE tt_med_issue. "Media Issues

  lv_curr_date = sy-datum. "Current/To Date
  lv_curr_time = sy-uzeit. "Current/To Time

* Get last run details (Date and Time)
  PERFORM f_get_last_run_details CHANGING lv_from_date
                                          lv_from_time.

* Fetch Records being Created / Changed
  PERFORM f_fetch_records   USING fp_s_mtyp_i
                                  lv_from_date
                                  lv_curr_date
                                  lv_from_time
                                  lv_curr_time
                         CHANGING li_med_issue.

* Process Records being Created / Changed
  PERFORM f_process_records USING fp_s_st_del
                                  fp_s_iv_typ
                                  fp_s_shp_st
                         CHANGING li_med_issue
                                  lv_any_error.

  IF fp_p_ts_upd  IS NOT INITIAL OR "Update TimeStamp Even If Error
     lv_any_error IS INITIAL.       "No Error Identified
*   Set last run details (Date and Time)
    PERFORM f_set_last_run_details USING  lv_curr_date
                                          lv_curr_time.
  ELSE. " ELSE -> IF fp_p_ts_upd IS NOT INITIAL OR
*   Message: Execution Date/Time is not updated in ZCAINTERFACE table!
    MESSAGE s119(zqtc_r2). " Execution Date/Time is not updated in ZCAINTERFACE table!
  ENDIF. " IF fp_p_ts_upd IS NOT INITIAL OR

* Display Process Log (ALV)
  PERFORM f_display_process_log USING li_med_issue.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_LAST_RUN_DETAILS
*&---------------------------------------------------------------------*
*       Get last run details (Date and Time)
*----------------------------------------------------------------------*
*      <--FP_LV_FROM_DATE  Last Run Date
*      <--FP_LV_FROM_TIME  Last Run Time
*----------------------------------------------------------------------*
FORM f_get_last_run_details  CHANGING fp_lv_from_date TYPE sydatum  " System Date
                                      fp_lv_from_time TYPE syuzeit. " System Time

* Interface run details
  SELECT SINGLE lrdat  "Last run date
                lrtime "Last run time
    FROM zcainterface  " Interface run details
    INTO (fp_lv_from_date,
          fp_lv_from_time)
   WHERE devid  EQ c_devid_c039
     AND param1 EQ space
     AND param2 EQ space.
  IF sy-subrc NE 0.
    CLEAR: fp_lv_from_date,
           fp_lv_from_time.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_RECORDS
*&---------------------------------------------------------------------*
*       Fetch Records being Created / Changed
*----------------------------------------------------------------------*
*      -->FP_S_MTYP_I      Material Type: Media Issues
*      -->FP_LV_FROM_DATE  From Date
*      -->FP_LV_CURR_DATE  To Date
*      -->FP_LV_FROM_TIME  From Time
*      -->FP_LV_CURR_TIME  To Time
*      <--FP_LI_MED_ISSUE  Media Issues - created / changed
*----------------------------------------------------------------------*
FORM f_fetch_records  USING    fp_s_mtyp_i     TYPE cfb_t_mtart_range
                               fp_lv_from_date TYPE sydatum " System Date
                               fp_lv_curr_date TYPE sydatum " System Date
                               fp_lv_from_time TYPE syuzeit " System Time
                               fp_lv_curr_time TYPE syuzeit " System Time
                      CHANGING fp_li_med_issue TYPE tt_med_issue.

  DATA:
    lir_date   TYPE trgr_date,
    lir_fields TYPE farr_rt_fieldname.

  APPEND INITIAL LINE TO lir_date   ASSIGNING FIELD-SYMBOL(<lst_date>).
  <lst_date>-sign    = c_sign_incld. "Sign: (I)nclude
  <lst_date>-option  = c_opti_betwn. "Option: (B)e(T)ween
  <lst_date>-low     = fp_lv_from_date. "From Date
  <lst_date>-high    = fp_lv_curr_date. "To Date

  APPEND INITIAL LINE TO lir_fields ASSIGNING FIELD-SYMBOL(<lst_field>).
  <lst_field>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_field>-option = c_opti_equal. "Option: (E)qual
  <lst_field>-low    = c_fn_mat_key. "Field Name: KEY
  <lst_field>-high   = space. "To Date
  APPEND INITIAL LINE TO lir_fields ASSIGNING <lst_field>.
  <lst_field>-sign   = c_sign_incld. "Sign: (I)nclude
  <lst_field>-option = c_opti_equal. "Option: (E)qual
  <lst_field>-low    = c_fn_xp_stat. "Field Name: MSTAE
  <lst_field>-high   = space. "To Date

* Identify the Media Issues being created / changed during the Date interval
  SELECT ismrefmdprod AS media_prod, "Higher-Level Media Product
         matnr        AS objectid    "Object value
    FROM mara                        " General Material Data
    INTO TABLE @fp_li_med_issue
   WHERE mtart IN @fp_s_mtyp_i
     AND ( ersda IN @lir_date
      OR   laeda IN @lir_date ).
  IF sy-subrc EQ 0.
*   Filter entries based on specific field changes (Creation / X-plant status Change)
    SELECT h~objectclas,                                     "Object class
           h~objectid,                                       "Object value
           h~changenr,                                       "Document change number
           h~udate,	                                         "Creation date of the change document
           h~utime,                                        	 "Time changed
           p~tabname,                                        "Table Name
           p~tabkey,                                         "Changed table record key
           p~fname,                                        	 "Field Name
           p~chngind,                                        "Change Type (U, I, S, D)
           p~value_new                                       "New contents of changed field
      FROM cdhdr AS h
INNER JOIN cdpos AS p
        ON p~objectclas EQ h~objectclas                      "Object class
       AND p~objectid   EQ h~objectid                        "Object value
       AND p~changenr   EQ h~changenr                        "Document change number
      INTO TABLE @DATA(li_objects)
       FOR ALL ENTRIES IN @fp_li_med_issue
     WHERE h~objectclas EQ @c_objcl_mat                      "Object class: MATERIAL
       AND h~objectid   EQ @fp_li_med_issue-objectid         "Object value: Material Number
       AND h~udate      IN @lir_date                         "Creation date of the change document
       AND p~tabname    EQ @c_table_mara                     "Table Name
       AND p~fname      IN @lir_fields.                      "Field Name
    IF sy-subrc EQ 0.
*     Remove the entries based on Time
      DELETE li_objects WHERE udate EQ fp_lv_from_date
                          AND utime LT fp_lv_from_time.
      DELETE li_objects WHERE udate EQ fp_lv_curr_date
                          AND utime GT fp_lv_curr_time.

*     Get the latest entry
      SORT li_objects BY objectid ASCENDING
                         udate    DESCENDING
                         utime    DESCENDING.
      DELETE ADJACENT DUPLICATES FROM li_objects
               COMPARING objectid.
    ENDIF. " IF sy-subrc EQ 0

*   Check if the Media Issue was created / if the X-plant status was changed
    LOOP AT fp_li_med_issue ASSIGNING FIELD-SYMBOL(<lst_issue>).
      READ TABLE li_objects ASSIGNING FIELD-SYMBOL(<lst_object>)
           WITH KEY objectid = <lst_issue>-objectid
           BINARY SEARCH.
      IF sy-subrc NE 0.
        <lst_issue>-del_flag   = abap_true. "Flag: to delete record
      ELSE. " ELSE -> IF sy-subrc NE 0
        <lst_issue>-change_ind = <lst_object>-chngind. "Change Type (U, I, S, D)
      ENDIF. " IF sy-subrc NE 0
    ENDLOOP. " LOOP AT fp_li_med_issue ASSIGNING FIELD-SYMBOL(<lst_issue>)
    DELETE fp_li_med_issue WHERE del_flag EQ abap_true.

    SORT fp_li_med_issue BY media_prod.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_RECORDS
*&---------------------------------------------------------------------*
*       Process Records being Created / Changed
*----------------------------------------------------------------------*
*      -->FP_S_ST_DEL      X-Plant Status
*      -->FP_S_IV_TYP      Issue Variant Type - Standard (Planned)
*      -->FP_S_SHP_ST      Status of Shipping Planning
*      <--FP_LI_MED_ISSUE  Media Issues - created / changed
*      <--FP_LV_ANY_ERROR  Flag: Any Error
*----------------------------------------------------------------------*
FORM f_process_records  USING    fp_s_st_del     TYPE rjksd_mstae_range_tab
                                 fp_s_iv_typ     TYPE ztqtc_vavartyp_range
                                 fp_s_shp_st     TYPE rjkse_nipstatus_range_tab
                        CHANGING fp_li_med_issue TYPE tt_med_issue
                                 fp_lv_any_error TYPE flag. " General Flag

  DATA:
    lv_message TYPE char100, " Message of type CHAR100
    lv_status  TYPE char1.   " Status of type CHAR1

  LOOP AT fp_li_med_issue ASSIGNING FIELD-SYMBOL(<lst_issue>).
    AT NEW media_prod.
      CLEAR: lv_message,
             lv_status.
*     Create / Update Issue Sequence
      CALL FUNCTION 'ZQTC_EDIT_ISSUE_EQUENCE'
        EXPORTING
          im_med_prod          = <lst_issue>-media_prod "Media Product
          im_x_plant_status    = fp_s_st_del            "X-Plant Status (Delete Record)
          im_issue_var_type    = fp_s_iv_typ            "Issue Variant Type - Standard (Planned)
          im_shp_pln_status    = fp_s_shp_st            "Status of Shipping Planning
        EXCEPTIONS
          exc_no_issue         = 1
          exc_lock_issue_seq   = 2
          exc_error_in_iss_seq = 3
          exc_miscellaneous    = 4
          OTHERS               = 5.
      IF sy-subrc EQ 0.
*       Message: Issue Sequence for Media Product &1 successfully created / updated!
        MESSAGE s053(zqtc_r2) " Issue Sequence for Media Product &1 successfully created / updated!
           WITH <lst_issue>-media_prod
           INTO lv_message.
        lv_status = c_status_suc. "Status: '3' = Green/Success
      ELSE. " ELSE -> IF sy-subrc EQ 0
*       Error Message
        MESSAGE ID sy-msgid "Message Class
              TYPE sy-msgty "Message Type
            NUMBER sy-msgno "Message Number
              WITH sy-msgv1 "Message Variable-1
                   sy-msgv2 "Message Variable-2
                   sy-msgv3 "Message Variable-3
                   sy-msgv4 "Message Variable-4
              INTO lv_message.
        lv_status = c_status_err. "Status: '1' = Red/Error
      ENDIF. " IF sy-subrc EQ 0
    ENDAT.

    <lst_issue>-message = lv_message. "Status Message
    <lst_issue>-status  = lv_status. "Status: '1' = red/error, '3' = green/success

    AT END OF media_prod.
      IF lv_status EQ c_status_err.
        fp_lv_any_error = abap_true. "Check if there is any Error
      ENDIF. " IF lv_status EQ c_status_err
    ENDAT.
  ENDLOOP. " LOOP AT fp_li_med_issue ASSIGNING FIELD-SYMBOL(<lst_issue>)

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_LAST_RUN_DETAILS
*&---------------------------------------------------------------------*
*       Set last run details (Date and Time)
*----------------------------------------------------------------------*
*      -->FP_LV_CURR_DATE  Current Date
*      -->FP_LV_CURR_TIME  Current Time
*----------------------------------------------------------------------*
FORM f_set_last_run_details  USING    fp_lv_curr_date TYPE sydatum  " System Date
                                      fp_lv_curr_time TYPE syuzeit. " System Time

  DATA:
    lst_interface TYPE zcainterface. "Interface run details

* Lock the Table entry
  CALL FUNCTION 'ENQUEUE_EZCAINTERFACE'
    EXPORTING
      mode_zcainterface = abap_true    "Lock mode
      mandt             = sy-mandt     "01th enqueue argument (Client)
      devid             = c_devid_c039 "02th enqueue argument (Development ID)
      param1            = space        "03th enqueue argument (ABAP: Name of Variant Variable)
      param2            = space        "04th enqueue argument (ABAP: Name of Variant Variable)
    EXCEPTIONS
      foreign_lock      = 1
      system_failure    = 2
      OTHERS            = 3.
  IF sy-subrc EQ 0.
    lst_interface-mandt  = sy-mandt. "Client
    lst_interface-devid  = c_devid_c039. "Development ID
    lst_interface-param1 = space. "ABAP: Name of Variant Variable
    lst_interface-param2 = space. "ABAP: Name of Variant Variable
    lst_interface-lrdat  = fp_lv_curr_date. "Last run date
    lst_interface-lrtime = fp_lv_curr_time. "Last run time
*   Modify (Insert / Update) the Table entry
    MODIFY zcainterface FROM lst_interface.
*   Unlock the Table entry
    CALL FUNCTION 'DEQUEUE_EZCAINTERFACE'.
  ELSE. " ELSE -> IF sy-subrc EQ 0
*   Error Message
    MESSAGE ID sy-msgid     "Message Class
          TYPE c_msgty_info "Message Type: Information
        NUMBER sy-msgno     "Message Number
          WITH sy-msgv1     "Message Variable-1
               sy-msgv2     "Message Variable-2
               sy-msgv3     "Message Variable-3
               sy-msgv4.    "Message Variable-4
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_PROCESS_LOG
*&---------------------------------------------------------------------*
*       Display Process Log (ALV)
*----------------------------------------------------------------------*
*      -->FP_LI_MED_ISSUE  Media Issues - created / changed
*----------------------------------------------------------------------*
FORM f_display_process_log  USING    fp_li_med_issue TYPE tt_med_issue.

  DATA:
    lv_col_pos   TYPE i. "Column Position

  DATA:
    li_fieldcat  TYPE slis_t_fieldcat_alv. "Field catalog with field descriptions

  DATA:
    lst_layout   TYPE slis_layout_alv. "List layout specifications

  FIELD-SYMBOLS:
    <lst_fldcat> TYPE slis_fieldcat_alv. "Field catalog with field description

  CONSTANTS:
    lc_fld_mprod TYPE slis_fieldname VALUE 'MEDIA_PROD', "Field: Media Product
    lc_fld_objid TYPE slis_fieldname VALUE 'OBJECTID',   "Field: Media Issue
    lc_fld_chind TYPE slis_fieldname VALUE 'CHANGE_IND', "Field: Change Ind
    lc_fld_messg TYPE slis_fieldname VALUE 'MESSAGE',    "Field: Status Messages
    lc_fld_stind TYPE slis_fieldname VALUE 'STATUS',     "Field: Status Ind
    lc_cnv_matn1 TYPE slis_edit_mask VALUE '==MATN1'.    "Conv Exit: MATN1

  IF fp_li_med_issue[] IS INITIAL.
*   Message: No data records found for the specified selection criteria
    MESSAGE i004(wrf_at_generate). " No data records found for the specified selection criteria
    LEAVE LIST-PROCESSING.
  ENDIF. " IF fp_li_med_issue[] IS INITIAL

* List layout specifications
  lst_layout-zebra             = abap_true. "Striped pattern
  lst_layout-colwidth_optimize = abap_true. "Column Width Optimization
  lst_layout-lights_fieldname  = lc_fld_stind. "Fieldname for exception

* Field catalog with field descriptions - Media Product
  lv_col_pos = lv_col_pos + 1.
  APPEND INITIAL LINE TO li_fieldcat ASSIGNING <lst_fldcat>.
  <lst_fldcat>-col_pos   = lv_col_pos.
  <lst_fldcat>-fieldname = lc_fld_mprod.
  <lst_fldcat>-edit_mask = lc_cnv_matn1.
  <lst_fldcat>-seltext_l = 'Media Product'(c01).
  <lst_fldcat>-seltext_m = 'Media Product'(c01).
  <lst_fldcat>-seltext_s = 'Media Product'(c01).

* Field catalog with field descriptions - Media Issue
  lv_col_pos = lv_col_pos + 1.
  APPEND INITIAL LINE TO li_fieldcat ASSIGNING <lst_fldcat>.
  <lst_fldcat>-col_pos   = lv_col_pos.
  <lst_fldcat>-fieldname = lc_fld_objid.
  <lst_fldcat>-edit_mask = lc_cnv_matn1.
  <lst_fldcat>-seltext_l = 'Media Issue'(c02).
  <lst_fldcat>-seltext_m = 'Media Issue'(c02).
  <lst_fldcat>-seltext_s = 'Media Issue'(c02).

* Field catalog with field descriptions - Change Indicator
  lv_col_pos = lv_col_pos + 1.
  APPEND INITIAL LINE TO li_fieldcat ASSIGNING <lst_fldcat>.
  <lst_fldcat>-col_pos   = lv_col_pos.
  <lst_fldcat>-fieldname = lc_fld_chind.
  <lst_fldcat>-edit_mask = space.
  <lst_fldcat>-seltext_l = 'Change Ind'(c03).
  <lst_fldcat>-seltext_m = 'Change Ind'(c03).
  <lst_fldcat>-seltext_s = 'Change Ind'(c03).

* Field catalog with field descriptions - Status Message
  lv_col_pos = lv_col_pos + 1.
  APPEND INITIAL LINE TO li_fieldcat ASSIGNING <lst_fldcat>.
  <lst_fldcat>-col_pos   = lv_col_pos.
  <lst_fldcat>-fieldname = lc_fld_messg.
  <lst_fldcat>-seltext_l = 'Status Message'(c04).
  <lst_fldcat>-seltext_m = 'Status Message'(c04).
  <lst_fldcat>-seltext_s = 'Status Message'(c04).

* Display ALV Grid
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid        "Name of the calling program
      is_layout          = lst_layout      "List layout specifications
      it_fieldcat        = li_fieldcat     "Field catalog with field descriptions
    TABLES
      t_outtab           = fp_li_med_issue "Table with data to be displayed
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc NE 0.
*   Error Message
    MESSAGE ID sy-msgid     "Message Class
          TYPE c_msgty_info "Message Type: Information
        NUMBER sy-msgno     "Message Number
          WITH sy-msgv1     "Message Variable-1
               sy-msgv2     "Message Variable-2
               sy-msgv3     "Message Variable-3
               sy-msgv4.    "Message Variable-4
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_SHP_ST
*&---------------------------------------------------------------------*
*       Validate Status of Shipping Planning
*----------------------------------------------------------------------*
*      -->FP_S_SHP_ST[]  Status of Shipping Planning
*----------------------------------------------------------------------*
FORM f_validate_shp_st USING fp_s_shp_st TYPE rjkse_nipstatus_range_tab.

  DATA:
    li_dd07v_tab_a TYPE dd07v_tab,                    "View on fixed values and domain texts
    li_dd07v_tab_n TYPE dd07v_tab.                    "View on fixed values and domain texts

  CONSTANTS:
    lc_dm_jnipstat TYPE domname VALUE 'JNIPSTATUS'.   "Domain Name

* Fetch Domain Values
  CALL FUNCTION 'DD_DOMA_GET'
    EXPORTING
      domain_name   = lc_dm_jnipstat                  "Domain Name: JNIPSTATUS
      withtext      = abap_false
    TABLES
      dd07v_tab_a   = li_dd07v_tab_a                  "View on fixed values and domain texts
      dd07v_tab_n   = li_dd07v_tab_n                  "View on fixed values and domain texts
    EXCEPTIONS
      illegal_value = 1
      op_failure    = 2
      OTHERS        = 3.
  IF sy-subrc EQ 0.
    DELETE li_dd07v_tab_a WHERE domvalue_l IN fp_s_shp_st[].
    IF sy-subrc NE 0.
*     Message: Invalid status. Check entry
      MESSAGE e407(cn).
    ENDIF.
  ENDIF.

ENDFORM.
