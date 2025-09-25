*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTCE_INIT_SHP_DATE_CHG
* PROGRAM DESCRIPTION: Include for subroutines
* DEVELOPER: Writtick Roy/Monalisa Dutta
* CREATION DATE:   2017-01-11
* OBJECT ID: E147
* TRANSPORT NUMBER(S):ED2K904056(W)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: <Transport No>
* Reference No:  <DER or TPR or SCR>
* Developer:
* Date:  YYYY-MM-DD
* Description:
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INIT_SHP_DATE_CHG_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DEFAULTS
*&---------------------------------------------------------------------*
*       Populate Selection Screen Default Values
*----------------------------------------------------------------------*
*      <--FP_S_MTYP_I  Material Type (Media Issue)
*      <--FP_S_STAT_I  Media Issue Status
*----------------------------------------------------------------------*
FORM f_populate_defaults  CHANGING fp_s_mtyp_i TYPE cfb_t_mtart_range
                                   fp_s_stat_i TYPE rjksd_mstae_range_tab.

* Material Type (Media Issue)
  APPEND INITIAL LINE TO fp_s_mtyp_i ASSIGNING FIELD-SYMBOL(<lst_mtyp_i>).
  <lst_mtyp_i>-sign   = c_sign_incld.                                "Sign: (I)nclude
  <lst_mtyp_i>-option = c_opti_equal.                                "Option: (EQ)ual
  <lst_mtyp_i>-low    = c_mtart_zjip.                                "Material Type: ZJIP
  <lst_mtyp_i>-high   = space.
  APPEND INITIAL LINE TO fp_s_mtyp_i ASSIGNING <lst_mtyp_i>.
  <lst_mtyp_i>-sign   = c_sign_incld.                                "Sign: (I)nclude
  <lst_mtyp_i>-option = c_opti_equal.                                "Option: (EQ)ual
  <lst_mtyp_i>-low    = c_mtart_zjid.                                "Material Type: ZJID
  <lst_mtyp_i>-high   = space.

* Media Issue Status
  APPEND INITIAL LINE TO fp_s_stat_i ASSIGNING FIELD-SYMBOL(<lst_stat_i>).
  <lst_stat_i>-sign   = c_sign_incld.                             "Sign: (I)nclude
  <lst_stat_i>-option = c_opti_equal.                             "Option: (EQ)ual
  <lst_stat_i>-low    = c_mstae_p.                                "media Issue Status P: current status
  <lst_stat_i>-high   = space.
  APPEND INITIAL LINE TO fp_s_stat_i ASSIGNING <lst_stat_i>.
  <lst_stat_i>-sign   = c_sign_incld.                             "Sign: (I)nclude
  <lst_stat_i>-option = c_opti_equal.                             "Option: (EQ)ual
  <lst_stat_i>-low    = c_mstae_n.                                "media Issue Status N: Not yet published
  <lst_stat_i>-high   = space.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MAT_TYPE
*&---------------------------------------------------------------------*
*       Validate Material Type
*----------------------------------------------------------------------*
*      -->FP_S_MTYP_I  Material Type (Media Issue)
*      -->FP_S_STAT_I  Media Issue Status
*----------------------------------------------------------------------*
FORM f_validate_mat_type  USING    fp_s_mtyp_i TYPE cfb_t_mtart_range.


* Material Types
  SELECT mtart                                                       "Material type
    FROM t134
   UP TO 1 ROWS
    INTO @DATA(lv_mtart)
   WHERE mtart IN @fp_s_mtyp_i.
  ENDSELECT.
  IF sy-subrc NE 0.
*   Message: Invalid material type; check your entry
    MESSAGE e084(ob).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_N_PROCESS
*&---------------------------------------------------------------------*
*       Fetch and Process Records
*----------------------------------------------------------------------*
*      -->FP_S_MTYP_I  Material Type (Media Issue)
*      -->FP_S_STAT_I  Media Issue Status
*      -->FP_P_TS_UPD  Update TimeStamp Even If Error
*----------------------------------------------------------------------*
FORM f_fetch_n_process  USING    fp_s_mtyp_i TYPE cfb_t_mtart_range
                                 fp_s_stat_i TYPE rjksd_mstae_range_tab
                                 fp_p_ts_upd TYPE char1.

  DATA:
    lv_curr_date TYPE sydatum,                                       "Current/To Date
    lv_curr_time TYPE syuzeit,                                       "Current/To Time
    lv_from_date TYPE sydatum,                                       "From Date
    lv_from_time TYPE syuzeit,                                       "From Time
    lv_any_error TYPE flag.                                          "Flag: Any Error

  DATA:
    li_med_issue TYPE tt_med_issue.                                  "Media Issues

  lv_curr_date = sy-datum.                                           "Current/To Date
  lv_curr_time = sy-uzeit.                                           "Current/To Time

* Get last run details (Date and Time)
  PERFORM f_get_last_run_details CHANGING lv_from_date
                                          lv_from_time.

* Fetch Records being Created / Changed
  PERFORM f_fetch_records        USING    fp_s_mtyp_i
                                          fp_s_stat_i
                                          lv_from_date
                                          lv_curr_date
                                          lv_from_time
                                          lv_curr_time
                                 CHANGING li_med_issue.

* Process Records being Changed
  PERFORM f_process_records      CHANGING li_med_issue
                                          lv_any_error.

  IF fp_p_ts_upd  IS NOT INITIAL OR                                  "Update TimeStamp Even If Error
     lv_any_error IS INITIAL.                                        "No Error Identified
*   Set last run details (Date and Time)
    PERFORM f_set_last_run_details USING  lv_curr_date
                                          lv_curr_time.
  ELSE.
*   Message: Execution Date/Time is not updated in ZCAINTERFACE table!
    MESSAGE s119(zqtc_r2).
  ENDIF.

* Display Process Log (ALV)
  PERFORM f_display_process_log CHANGING  li_med_issue.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_LAST_RUN_DETAILS
*&---------------------------------------------------------------------*
*       Get last run details (Date and Time)
*----------------------------------------------------------------------*
*      <--FP_LV_FROM_DATE  Last Run Date
*      <--FP_LV_FROM_TIME  Last Run Time
*----------------------------------------------------------------------*
FORM f_get_last_run_details  CHANGING fp_lv_from_date TYPE sydatum
                                      fp_lv_from_time TYPE syuzeit.

* Interface run details
  SELECT SINGLE lrdat                                                "Last run date
                lrtime                                               "Last run time
    FROM zcainterface
    INTO (fp_lv_from_date,
          fp_lv_from_time)
   WHERE devid  EQ c_devid_e147
     AND param1 EQ space
     AND param2 EQ space.
  IF sy-subrc NE 0.
    CLEAR: fp_lv_from_date,
           fp_lv_from_time.
  ENDIF.

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
                               fp_s_stat_i     TYPE rjksd_mstae_range_tab
                               fp_lv_from_date TYPE sydatum
                               fp_lv_curr_date TYPE sydatum
                               fp_lv_from_time TYPE syuzeit
                               fp_lv_curr_time TYPE syuzeit
                      CHANGING fp_li_med_issue TYPE tt_med_issue.

  DATA:
    lir_date   TYPE trgr_date,
    lir_fields TYPE farr_rt_fieldname.

  APPEND INITIAL LINE TO lir_date   ASSIGNING FIELD-SYMBOL(<lst_date>).
  <lst_date>-sign    = c_sign_incld.                                 "Sign: (I)nclude
  <lst_date>-option  = c_opti_betwn.                                 "Option: (B)e(T)ween
  <lst_date>-low     = fp_lv_from_date.                              "From Date
  <lst_date>-high    = fp_lv_curr_date.                              "To Date

  APPEND INITIAL LINE TO lir_fields ASSIGNING FIELD-SYMBOL(<lst_field>).
  <lst_field>-sign   = c_sign_incld.                                 "Sign: (I)nclude
  <lst_field>-option = c_opti_equal.                                 "Option: (E)qual
  <lst_field>-low    = c_fn_shp_dt.                                  "Field Name: ISMINITSHIPDATE
  <lst_field>-high   = space.                                        "To Date

* Identify the Media Issues being created / changed during the Date interval
  SELECT matnr           AS objectid,                                "Object value
         mstae           AS issue_status,                            "Media Issue Status
         ismrefmdprod    AS media_prod,                              "Higher-Level Media Product
         isminitshipdate AS ship_date                                "Initial Shipping Date
    FROM mara
    INTO TABLE @fp_li_med_issue
   WHERE mtart IN @fp_s_mtyp_i
     AND mstae IN @fp_s_stat_i
     AND laeda IN @lir_date.
  IF sy-subrc EQ 0.
*   Filter entries based on specific field changes (Initial Shipping Date Change)
    SELECT h~objectclas,                                             "Object class
           h~objectid,                                               "Object value
           h~changenr,                                               "Document change number
           h~udate,	                                                 "Creation date of the change document
           h~utime,                                        	         "Time changed
           p~tabname,                                                "Table Name
           p~tabkey,                                                 "Changed table record key
           p~fname                                         	         "Field Name
      FROM cdhdr AS h
INNER JOIN cdpos AS p
        ON p~objectclas EQ h~objectclas                              "Object class
       AND p~objectid   EQ h~objectid                                "Object value
       AND p~changenr   EQ h~changenr                                "Document change number
      INTO TABLE @DATA(li_objects)
       FOR ALL ENTRIES IN @fp_li_med_issue
     WHERE h~objectclas EQ @c_objcl_mat                              "Object class: MATERIAL
       AND h~objectid   EQ @fp_li_med_issue-objectid                 "Object value: Material Number
       AND h~udate      IN @lir_date                                 "Creation date of the change document
       AND p~tabname    EQ @c_table_mara                             "Table Name
       AND p~fname      IN @lir_fields                               "Field Name
       AND p~chngind    EQ @c_chngind_u.                             "Change Type - Update
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
    ENDIF.

*   Check if the Initial Shipping Date was changed
    LOOP AT fp_li_med_issue ASSIGNING FIELD-SYMBOL(<lst_issue>).
      READ TABLE li_objects ASSIGNING FIELD-SYMBOL(<lst_object>)
           WITH KEY objectid = <lst_issue>-objectid
           BINARY SEARCH.
      IF sy-subrc NE 0.
        <lst_issue>-del_flag   = abap_true.                          "Flag: to delete record
      ENDIF.
    ENDLOOP.
    DELETE fp_li_med_issue WHERE del_flag EQ abap_true.

    SORT fp_li_med_issue BY objectid.
  ENDIF.

  IF fp_li_med_issue[] IS INITIAL.
*   Message: No data records changed
    MESSAGE i008(cpmass).
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_LAST_RUN_DETAILS
*&---------------------------------------------------------------------*
*       Set last run details (Date and Time)
*----------------------------------------------------------------------*
*      -->FP_LV_CURR_DATE  Current Date
*      -->FP_LV_CURR_TIME  Current Time
*----------------------------------------------------------------------*
FORM f_set_last_run_details  USING    fp_lv_curr_date TYPE sydatum
                                      fp_lv_curr_time TYPE syuzeit.

  DATA:
    lst_interface TYPE zcainterface.                                 "Interface run details

* Lock the Table entry
  CALL FUNCTION 'ENQUEUE_EZCAINTERFACE'
    EXPORTING
      mode_zcainterface = abap_true                                  "Lock mode
      mandt             = sy-mandt                                   "01th enqueue argument (Client)
      devid             = c_devid_e147                               "02th enqueue argument (Development ID)
      param1            = space                                      "03th enqueue argument (ABAP: Name of Variant Variable)
      param2            = space                                      "04th enqueue argument (ABAP: Name of Variant Variable)
    EXCEPTIONS
      foreign_lock      = 1
      system_failure    = 2
      OTHERS            = 3.
  IF sy-subrc EQ 0.
    lst_interface-mandt  = sy-mandt.                                 "Client
    lst_interface-devid  = c_devid_e147.                             "Development ID
    lst_interface-param1 = space.                                    "ABAP: Name of Variant Variable
    lst_interface-param2 = space.                                    "ABAP: Name of Variant Variable
    lst_interface-lrdat  = fp_lv_curr_date.                          "Last run date
    lst_interface-lrtime = fp_lv_curr_time.                          "Last run time
*   Modify (Insert / Update) the Table entry
    MODIFY zcainterface FROM lst_interface.
*   Unlock the Table entry
    CALL FUNCTION 'DEQUEUE_EZCAINTERFACE'.
  ELSE.
*   Error Message
    MESSAGE ID sy-msgid                                              "Message Class
          TYPE c_msgty_info                                          "Message Type: Information
        NUMBER sy-msgno                                              "Message Number
          WITH sy-msgv1                                              "Message Variable-1
               sy-msgv2                                              "Message Variable-2
               sy-msgv3                                              "Message Variable-3
               sy-msgv4.                                             "Message Variable-4
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_RECORDS
*&---------------------------------------------------------------------*
*       Process Records being Changed
*----------------------------------------------------------------------*
*      <--P_LI_MED_ISSUE  FP_LI_MED_ISSUE  Media Issues - changed
*      <--FP_LV_ANY_ERROR  Flag: Any Error
*----------------------------------------------------------------------*
FORM f_process_records  CHANGING fp_li_med_issue TYPE tt_med_issue
                                 fp_lv_any_error TYPE flag.

  DATA:
    li_message         TYPE merrdat_tt,                              "DI: Structure for Returning Error Messages
    lst_med_issue_mara TYPE zstqtc_media_issue_mara,                 "I0344: Media Issue - General Material Data from JANIS
    lst_med_issue_marc TYPE zstqtc_media_issue_marc,                 "I0344: Media Issue - Plant Data for Material from JANIS
    lst_med_issue_makt TYPE zstqtc_media_issue_makt,                 "I0344: Media Issue - Material Description from JANIS
    lst_med_issue_mvke TYPE zstqtc_media_issue_mvke,                 "I0344: Media Issue - Sales Data for Material from JANIS
    li_med_issue_idcd  TYPE ztqtc_media_issue_idcd.                  "I0344: Media Issue - Assignment of ID codes from JANIS

  DATA:
    lv_message   TYPE char100,                                       "Message
    lv_days_diff TYPE i,                                             "Offset Days
    lv_error     TYPE flag,                                          "Error Flag
    lv_po_date   TYPE ismpurchase_date_pl,                           "PO Date
    lv_gen_start TYPE jgen_start_date.                               "Start Date for Order Generation

* Fetch General Material Data (Issue Template)
  SELECT matnr,                                                      "Material Number (Issue Template)
         ismrefmdprod,                                               "Higher-Level Media Product
         ismpubldate                                                 "Publication Date
    FROM mara
    INTO TABLE @DATA(li_issue_temp)
     FOR ALL ENTRIES IN @fp_li_med_issue
   WHERE matnr           LIKE @c_issue_temp                          "Pattern: %_TEMP%
     AND ismrefmdprod    EQ   @fp_li_med_issue-media_prod               "Media Product
     AND ismhierarchlevl EQ   @c_lvl_med_i.                          "Hierarchy Level (Media Issue)
  IF sy-subrc EQ 0.
    SORT li_issue_temp BY ismrefmdprod.

*   Fetch Shipping Schedule details
    SELECT id,                                                       "ID of Next Issue Pointer
           product,                                                  "Media Product
           issue,                                                    "Media Issue
           shipping_date,                                            "Shipping Date
           gen_start_date                                            "Start Date for Order Generation
      FROM jksenip
      INTO TABLE @DATA(li_shp_plan)
       FOR ALL ENTRIES IN @li_issue_temp
     WHERE product EQ @li_issue_temp-ismrefmdprod                    "Media Product
       AND issue   EQ @li_issue_temp-matnr.                          "Media Issue
    IF sy-subrc EQ 0.
      SORT li_shp_plan BY product issue.
    ENDIF.

*   Latest PO date
  SELECT matnr,          " Material Number
         werks,          " Plant
         ismpurchasedate " IS-M: Latest Possible Purchase Order Date
    FROM marc
    INTO TABLE @DATA(li_marc)
    FOR ALL ENTRIES IN @li_issue_temp
    WHERE matnr = @li_issue_temp-matnr.
  IF sy-subrc EQ 0.
    SORT li_marc BY matnr.
  ENDIF.
ENDIF.

* Order Creation Date determination
  LOOP AT fp_li_med_issue ASSIGNING FIELD-SYMBOL(<lst_med_issue>).
    <lst_med_issue>-media_issue  = <lst_med_issue>-objectid.         "Media Issue

*   Identify the Issue Template
    READ TABLE li_issue_temp ASSIGNING FIELD-SYMBOL(<lst_issue_temp>)
         WITH KEY ismrefmdprod = <lst_med_issue>-media_prod
         BINARY SEARCH.
    IF sy-subrc EQ 0.
*     Get Shipping Schedule details of the Issue Template
      READ TABLE li_shp_plan ASSIGNING FIELD-SYMBOL(<lst_shp_plan>)
           WITH KEY product = <lst_issue_temp>-ismrefmdprod
                    issue   = <lst_issue_temp>-matnr
           BINARY SEARCH.
      IF sy-subrc EQ 0.
*       Calculate Offset Days from Issue Template details
        lv_days_diff = <lst_issue_temp>-ismpubldate -                "Publication Date
                       <lst_shp_plan>-gen_start_date.                "Start Date for Order Generation
*       Calculate Start Date for Order Generation
        lv_gen_start = <lst_med_issue>-ship_date -                   "Initial Shipping Date
                       lv_days_diff.                                 "Offset Days

        <lst_med_issue>-order_date    = lv_gen_start.                "Start Date for Order Generation
        <lst_med_issue>-delivery_date = <lst_med_issue>-ship_date.   "Shipping Date

*       Shipping Plan Update
        CALL FUNCTION 'ZQTC_EDIT_SHIPPING_PLAN'
          EXPORTING
            im_med_issue          = <lst_med_issue>-media_issue      "Media Issue
            im_med_product        = <lst_med_issue>-media_prod       "Media Product
            im_shipping_date      = <lst_med_issue>-ship_date        "Shipping Date
            im_gen_start_date     = lv_gen_start                     "Start Date for Order Generation
          EXCEPTIONS
            exc_med_issue_missing = 1
            exc_shp_sch_missing   = 2
            exc_shp_sch_locked    = 3
            exc_miscellaneous     = 4
            OTHERS                = 5.
        IF sy-subrc NE 0.
*         Error Message
          MESSAGE ID sy-msgid                                        "Message Class
                TYPE sy-msgty                                        "Message Type
              NUMBER sy-msgno                                        "Message Number
                WITH sy-msgv1                                        "Message Variable-1
                     sy-msgv2                                        "Message Variable-2
                     sy-msgv3                                        "Message Variable-3
                     sy-msgv4                                        "Message Variable-4
                INTO <lst_med_issue>-message.
          <lst_med_issue>-status  =  c_status_err.                   "Status: '1' = Red/Error
          fp_lv_any_error = abap_true.                               "Check if there is any Error
        ELSE.
          <lst_med_issue>-message = 'Order creation from date & Delivery Date successfully updated'(m04).
          <lst_med_issue>-status = c_status_suc.
        ENDIF.
      ELSE.
        <lst_med_issue>-message =  'Shipping Schedule is not maintained for Issue Template'(m02).
        <lst_med_issue>-status  =  c_status_err.                     "Status: '1' = Red/Error
        fp_lv_any_error = abap_true.                                 "Check if there is any Error
      ENDIF.

    ELSE.
      <lst_med_issue>-message =  'Issue Template can not be determined'(m01).
      <lst_med_issue>-status  =  c_status_err.                       "Status: '1' = Red/Error
      fp_lv_any_error = abap_true.                                   "Check if there is any Error
    ENDIF.

    CLEAR: lv_days_diff,
           lv_gen_start.
  ENDLOOP.

* Splitting in 2 LOOPS, to avoid locking issue
  WAIT UP TO 1 SECONDS.

* Latest PO date determination
  LOOP AT fp_li_med_issue ASSIGNING <lst_med_issue>.
*   Identify the Issue Template
    READ TABLE li_issue_temp ASSIGNING <lst_issue_temp>
         WITH KEY ismrefmdprod = <lst_med_issue>-media_prod
         BINARY SEARCH.
    IF sy-subrc EQ 0.
*     Latest PO date calculation
      READ TABLE li_marc ASSIGNING FIELD-SYMBOL(<lst_marc>)
             WITH KEY matnr = <lst_issue_temp>-matnr
             BINARY SEARCH.
      IF sy-subrc EQ 0.
*       Calculate Offset Days from Issue Template details
        CLEAR lv_days_diff.
        lv_days_diff = <lst_issue_temp>-ismpubldate -                "Publication Date
                       <lst_marc>-ismpurchasedate.                   "IS-M: Latest Possible Purchase Order Date
*       Calculate PO date
        lv_po_date = <lst_med_issue>-ship_date -                     "Initial Shipping Date
                       lv_days_diff.                                 "Offset Days

        <lst_med_issue>-latest_po = lv_po_date.                      "Latest PO Date

*       Update Latest PO date
        lst_med_issue_mara-matnr = <lst_med_issue>-objectid.         "Media Issue
        lst_med_issue_mara-ismrefmdprod = <lst_med_issue>-media_prod."Media Product
        lst_med_issue_marc-ismpurchasedate = lv_po_date.             "PO Date
        CALL FUNCTION 'ZQTC_CREATE_UPDATE_MEDIA_ISSUE'
          EXPORTING
            im_med_issue_mara      = lst_med_issue_mara              "Media Issue - General Material Data
            im_med_issue_makt      = lst_med_issue_makt              "Media Issue - Material Description
            im_med_issue_marc      = lst_med_issue_marc              "Media Issue - Plant Data for Material
            im_med_issue_mvke      = lst_med_issue_mvke              "Media Issue - Sales Data for Material
            im_med_issue_idcd      = li_med_issue_idcd               "Media Issue - Assignment of ID Codes
          IMPORTING
            ex_is_error            = lv_error                        "Flag: If there is any Error
            ex_message_tab         = li_message                      "Returning Error Messages
          EXCEPTIONS
            exc_med_prod_invalid   = 1
            exc_med_prod_locked    = 2
            exc_temp_issue_missing = 3
            OTHERS                 = 4.
        IF sy-subrc NE 0 OR lv_error IS NOT INITIAL.
          IF sy-subrc NE 0.
*           Error Message
            CLEAR: lv_message.
            MESSAGE ID sy-msgid                                     "Message Class
                  TYPE sy-msgty                                     "Message Type
                NUMBER sy-msgno                                     "Message Number
                  WITH sy-msgv1                                     "Message Variable-1
                       sy-msgv2                                     "Message Variable-2
                       sy-msgv3                                     "Message Variable-3
                       sy-msgv4                                     "Message Variable-4
                  INTO lv_message.
            CONCATENATE <lst_med_issue>-message
                        lv_message
                   INTO <lst_med_issue>-message
              SEPARATED BY c_semi_colon.
          ENDIF.

          LOOP AT li_message ASSIGNING FIELD-SYMBOL(<lst_message>).
            CONCATENATE <lst_med_issue>-message
                        <lst_message>-msgv1
                   INTO <lst_med_issue>-message
              SEPARATED BY c_semi_colon.
          ENDLOOP.
          <lst_med_issue>-status = c_status_err.
          fp_lv_any_error = abap_true.                               "Check if there is any Error
        ELSE.
          CONCATENATE <lst_med_issue>-message
                      'Latest PO date sucessfully updated'(m05)
                 INTO <lst_med_issue>-message
            SEPARATED BY c_semi_colon.
          IF <lst_med_issue>-status NE c_status_err.
            <lst_med_issue>-status = c_status_suc.
          ENDIF.
        ENDIF.

      ELSE.
        CONCATENATE <lst_med_issue>-message
                    'Material not found in MARC for issue template'(m03)
               INTO <lst_med_issue>-message
          SEPARATED BY c_semi_colon.
        <lst_med_issue>-status  =  c_status_err.                     "Status: '1' = Red/Error
        fp_lv_any_error = abap_true.                                 "Check if there is any Error
      ENDIF.
    ENDIF.

    CLEAR: li_message,
           lv_days_diff,
           lv_error,
           lv_po_date.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_PROCESS_LOG
*&---------------------------------------------------------------------*
*       ALV Display
*----------------------------------------------------------------------*
*      -->FP_LI_MED_ISSUE  Output table for display
*----------------------------------------------------------------------*
FORM f_display_process_log  CHANGING  fp_li_med_issue TYPE tt_med_issue.
  DATA: lst_fieldcatalog TYPE slis_fieldcat_alv,
        lst_layout       TYPE slis_layout_alv,
        li_fieldcatalog  TYPE slis_t_fieldcat_alv.

* Fill traffic lights field name in the ALV layout
  lst_layout-lights_fieldname = 'STATUS'.
  lst_layout-colwidth_optimize = abap_true.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'MEDIA_ISSUE'.
  lst_fieldcatalog-seltext_m   = 'Media Issue'(t01).
  lst_fieldcatalog-col_pos     = 0.
  lst_fieldcatalog-outputlen = 16.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'MEDIA_PROD'.
  lst_fieldcatalog-seltext_m   = 'Media Product'(t02).
  lst_fieldcatalog-col_pos     = 1.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'ORDER_DATE'.
  lst_fieldcatalog-seltext_m   = 'Order creation from date'(t03).
  lst_fieldcatalog-col_pos     = 2.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'DELIVERY_DATE'.
  lst_fieldcatalog-seltext_m   = 'Delivery Date'(t04).
  lst_fieldcatalog-col_pos     = 3.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'LATEST_PO'.
  lst_fieldcatalog-seltext_m   = 'Latest PO Date'(t05).
  lst_fieldcatalog-col_pos     = 4.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'MESSAGE'.
  lst_fieldcatalog-seltext_m   = 'Message'(t06).
  lst_fieldcatalog-col_pos     = 5.
  lst_fieldcatalog-outputlen = 100.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'STATUS'.
  lst_fieldcatalog-seltext_m   = 'Status'(t07).
  lst_fieldcatalog-col_pos     = 6.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

* Pass data and field catalog to ALV function module to display ALV list
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = lst_layout
      it_fieldcat        = li_fieldcatalog
    TABLES
      t_outtab           = fp_li_med_issue
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    CLEAR li_fieldcatalog[].
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_STATUS
*&---------------------------------------------------------------------*
*       validation of Media Status field
*----------------------------------------------------------------------*
*      -->FP_S_STAT_I[]  Media Status
*----------------------------------------------------------------------*
FORM f_validate_status  USING    fp_s_stat_i TYPE rjksd_mstae_range_tab.
*  Media issue status
  SELECT mmsta "Material status from MM/PP view
    FROM t141
    UP TO 1 ROWS
    INTO @DATA(lv_mmsta)
    WHERE mmsta IN @fp_s_stat_i.
  ENDSELECT.
  IF sy-subrc NE 0.
*    Material status from MM/PP view does not exist, check your entry
    MESSAGE e408(ob).
  ENDIF.
ENDFORM.
