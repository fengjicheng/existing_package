*----------------------------------------------------------------------*
***INCLUDE LZQTC_FG_BP_INTERFACE_I0500F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_GLOBAL_V
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_global_v .
  FREE: i_constant,i_bp_input,i_bp_return,st_bp_input,st_create,
        li_role,lst_role,lsr_rel_type,lir_rel_type.

  CLEAR:gv_support_mode,gv_error,gv_cat_flag,gv_bp,gv_tf_prefix, gv_id_cat,
       gv_zca_valid,gv_zca_katr6,gv_zca_bukrs,gv_return_msg,
       gv_country,gv_log_handle,lsr_zca_val.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants CHANGING fp_li_constant TYPE tt_constant.
*  Local constant declaration
  CONSTANTS: lc_devid       TYPE zdevid     VALUE 'I0500',    " Development ID
             lc_support_mod TYPE rvari_vnam VALUE 'SUPPORT_MODE',
             lc_comm_method TYPE rvari_vnam VALUE 'COMM_METHOD',
             lc_bu_group    TYPE rvari_vnam VALUE 'BU_GROUP',
             lc_bu_cat      TYPE rvari_vnam VALUE 'BU_CAT',
             lc_bp_role     TYPE rvari_vnam VALUE 'BP_ROLE',
             lc_valid_end   TYPE rvari_vnam VALUE 'VALID_END',
             lc_katr6       TYPE rvari_vnam VALUE 'KATR6',
             lc_bukrs       TYPE rvari_vnam VALUE 'BUKRS',
             lc_vkorg       TYPE rvari_vnam VALUE 'KNVV-VKORG',
             lc_vtweg       TYPE rvari_vnam VALUE 'KNVV-VTWEG',
             lc_spart       TYPE rvari_vnam VALUE 'KNVV-SPART',
             lc_id_cat      TYPE rvari_vnam VALUE 'ID_CATEGORY',
             lc_tf_prefix   TYPE rvari_vnam VALUE 'TEL_FAX_PREFIX'.

*Fetch data from ZCAINTEG_MAPPING
  SELECT   devid,           " Development ID
           param1,          " ABAP: Name of Variant Variable
           param2,          " ABAP: Name of Variant Variable
           srno,            " ABAP: Current selection number
           sign,            " ABAP: ID: I/E (include/exclude values)
           opti,            " ABAP: Selection option (EQ/BT/CP/...)
           legacy_value,    " Legacy Value
           sap_value,       " SAP Value
           activate         "
    FROM zcainteg_mapping    " Wiley Application Constant Table
    INTO TABLE @fp_li_constant
    WHERE devid = @lc_devid AND
          activate = @abap_true.
  IF sy-subrc EQ 0.
    SORT fp_li_constant BY param1.
    "Get data from zcainteg table
    LOOP AT fp_li_constant INTO DATA(lst_zcainteg).
      CASE lst_zcainteg-param1.
        WHEN lc_vkorg.
          lsr_zca_val-vkorg = lst_zcainteg-sap_value.
        WHEN lc_vtweg.
          lsr_zca_val-vtweg = lst_zcainteg-sap_value.
        WHEN lc_spart.
          lsr_zca_val-spart = lst_zcainteg-sap_value.
        WHEN lc_bukrs.
          gv_zca_bukrs = lst_zcainteg-sap_value.
*---*kna1-katr6
        WHEN lc_katr6.
          gv_zca_katr6 = lst_zcainteg-sap_value.
*--*BP role
        WHEN lc_bp_role.
          lsr_rel_type-legacy_value = lst_zcainteg-legacy_value.
          lsr_rel_type-sap_value = lst_zcainteg-sap_value.
          APPEND lsr_rel_type TO lir_rel_type.
          CLEAR lsr_rel_type.
*--*Valididty End date
        WHEN lc_valid_end .
          gv_zca_valid = lst_zcainteg-legacy_value.
        WHEN lc_support_mod.
          IF lst_zcainteg-sap_value IS NOT INITIAL.
            gv_support_mode = abap_true.
          ENDIF.
*BOC VMAMILLA
*-- Id category
        WHEN lc_id_cat.
          gv_id_cat = lst_zcainteg-sap_value.
        WHEN lc_tf_prefix.
          gv_tf_prefix = lst_zcainteg-sap_value.
*EOC VMAMILLA
        WHEN OTHERS.
          "not required in this case
      ENDCASE.
    ENDLOOP.
  ENDIF.
  IF gv_support_mode IS NOT INITIAL.
    DO.
      BREAK-POINT.
    ENDDO.
  ENDIF.
ENDFORM.
FORM f_populate_return  USING fp_st_cust_input TYPE zstqtc_customer_date_input
                              fp_return_msg    TYPE bapiretc
                     CHANGING fp_ex_return     TYPE ztqtc_customer_date_outputs.

  FIELD-SYMBOLS:
    <lst_ex_ret>  TYPE zstqtc_customer_date_output, " I0500: Customer Data (Customer / BP Number, Messages)
    <lst_message> TYPE bapiretc.                    " Return Parameter for Complex Data Type

  APPEND INITIAL LINE TO fp_ex_return ASSIGNING <lst_ex_ret>.
  IF <lst_ex_ret> IS ASSIGNED.
    <lst_ex_ret>-seq_id                    = fp_st_cust_input-seq_id.
    <lst_ex_ret>-partner_info-cdm_ecid     = fp_st_cust_input-data_key-id_number.

    APPEND INITIAL LINE TO <lst_ex_ret>-messages ASSIGNING <lst_message>.
    <lst_message>-type          = c_msgty_err.
    <lst_message>-id            = c_msgid_zrtr.
    <lst_message>-number        = c_msgno_000.
    <lst_message>-message       = fp_return_msg-message.

  ENDIF. " IF <lst_ex_ret> IS ASSIGNED
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_SAVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_V_LOG_HANDLE  TYPE BALLOGHNDL
*----------------------------------------------------------------------*
FORM f_log_save  USING    fp_v_log_handle TYPE balloghndl. " Application Log: Log Handle

*====================================================================*
* Local Internal Table
*====================================================================*
  DATA li_log_handle TYPE bal_t_logh. "Application Log: Log Handle Table

*====================================================================*
* Add the Application Log: Log Handle
*====================================================================*
  APPEND fp_v_log_handle TO  li_log_handle.

*====================================================================*
* Application Log: Database: Save logs
*====================================================================*
  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_t_log_handle   = li_log_handle "Application Log: Log Handle
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc NE 0.
*   Nothing to do
  ELSE.
    CLEAR: li_log_handle, fp_v_log_handle.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
FORM f_log_create  USING    fp_im_guid       TYPE idoccarkey                 " GUID in 'CHAR' Format in Uppercase
                            fp_im_data       TYPE zstqtc_customer_date_input " I0500: Customer Data (Gen, Comp Code, Sales Area, Crdt/Coll)
                            fp_li_constant   TYPE tt_constant
                   CHANGING fp_lv_log_handle TYPE balloghndl.                " Application Log: Log Handle
*====================================================================*
* Local Structure
*====================================================================*
  DATA: lst_log      TYPE bal_s_log, " Application Log: Log header data
        lv_extnumber TYPE char100,   " Extnumber of type CHAR100
        lv_days      TYPE i,
        lv_date      TYPE aldate_del.
*====================================================================*
* Local Constants
*====================================================================*
  CONSTANTS: lc_slash  TYPE c1 VALUE '/'. " Select time frame in units of day

  CLEAR lv_extnumber.
* Create extnumber
  CONCATENATE fp_im_guid
              fp_im_data-seq_id
              fp_im_data-data_key-partner
              fp_im_data-data_key-id_number+0(13)
              INTO
              lv_extnumber
              SEPARATED BY lc_slash.

  CONDENSE lv_extnumber NO-GAPS.
* Get Expiry date and update in header data
  READ TABLE fp_li_constant INTO DATA(lst_constant)
                         WITH KEY param1 = c_expiry
                                  param2 = c_appl.
  IF sy-subrc EQ 0.
    lv_days = lst_constant-sap_value.
    lv_date = sy-datum + lv_days.
  ENDIF.
  lst_log-aldate_del = lv_date.
*====================================================================*
* Define some header data of this log
*====================================================================*
  lst_log-extnumber  = lv_extnumber. "Application Log: External ID
  lst_log-object     = c_bal_obj. "Application Log: Object Name (ZRTR)
  lst_log-subobject  = c_bal_sub. "Application Log: Subobject (ZCUST_LKUP)
  lst_log-aldate     = sy-datum. "Application log: Date
  lst_log-altime     = sy-uzeit. "Application log: Time
  lst_log-aluser     = sy-uname. "Application log: User name
  lst_log-alprog     = sy-repid. "Application log: Program name

*====================================================================*
* Application Log: Log: Create with Header Data
*====================================================================*
  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = lst_log          "Log header data
    IMPORTING
      e_log_handle            = fp_lv_log_handle "Application Log: Log Handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc NE 0.
    CLEAR: fp_lv_log_handle.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_GLOBAL_V_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_global_v_2 .
  FREE:i_bp_input,i_bp_return,st_create.

  CLEAR:gv_error,gv_cat_flag,gv_bp,
        gv_return_msg,gv_country,gv_log_handle.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_ERROR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GV_MESSAGE  text
*      -->P_LV_ISSUE  text
*      <--P_EX_RETURN  text
*----------------------------------------------------------------------*
FORM f_log_error USING    fp_message TYPE char200
                          fp_issue   TYPE syst_msgv
                 CHANGING  ex_return TYPE ztqtc_customer_date_outputs.
  "update the error log
  PERFORM f_log_create USING   gv_guid
                               st_bp_input
                               i_constant
                      CHANGING gv_log_handle.
  PERFORM f_log_add  USING gv_log_handle
                           c_msgty_err         "Message Type - (e)rror
                           fp_issue
                           ''
                           fp_message
                           ''
                           ''.
  PERFORM f_log_save USING gv_log_handle.
  "update the response to requestor
  CONCATENATE fp_issue fp_message INTO gv_return_msg-message SEPARATED BY space.

  PERFORM f_populate_return USING st_bp_input
                                  gv_return_msg
                         CHANGING ex_return.

  CLEAR: gv_message, gv_return_msg.
ENDFORM.
