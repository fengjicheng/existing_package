*----------------------------------------------------------------------*
***INCLUDE LZQTC_PRICE_ASF01.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_AS_PRICE_SIMULATION_I0419                         *
* PROGRAM DESCRIPTION: This RFC will receive the request from AS       *
*                      through TIBCO, Once the request received in SAP *
*                      it will validate the data for price simulation  *
*                      and send the overall response.                  *
* DEVELOPER      : Ramesh N (RNARAYANAS)                               *
* CREATION DATE  : 24/03/2022                                          *
* OBJECT ID      : I0419                                               *
* TRANSPORT NUMBER(S):  ED2K926086 , ED2K926565 ,ED2K926784 ,ED2K926894*
*                       ED2K927020 , ED2K927142 ,ED2K927144 ,ED2K927322*
*                       ED2K927355 .                                   *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_GLOBAL_V
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
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

  FREE : i_itemdetails,
         i_priceout,
         i_hdr,
         i_itm ,
         i_result,
         i_caller_data_head,
         i_caller_data_item ,
         i_varcond,
         i_message,
         i_constant,
         i_as_desc.

  CLEAR : st_itemdetails,
          st_global,
          st_control,
          st_caller_data,
          st_priceout,
          st_log_handle,
          st_log,
          st_msg,
          st_hdrdet,
          st_as_desc,
          ir_cond_type,
          ir_manu_type,
          v_matnr,
          v_date,
          v_days,
          v_flg_exec,
          v_slglogdays,
          v_kunnr,
          v_vbeln,
          v_qty,
          v_posnr,
          v_uom,
          v_doc_type,
          v_status.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_MATNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_PRICEOUT  text
*----------------------------------------------------------------------*
FORM f_fetch_matnr  CHANGING  v_matnr    TYPE mara-matnr
                              i_priceout TYPE zqtc_tt_price_out.

  DATA lv_txt TYPE symsgv.

* BOC by Ramesh on 04/18/2022 for ASOTC-226(ASOTC-665 defect) with ED2K926784  *
  "Translate the UUID to lowercase
  TRANSLATE st_itemdetails-zuuid TO LOWER CASE.
* EOC by Ramesh on 04/18/2022 for ASOTC-226(ASOTC-665 defect) with ED2K926784  *

  "Fetch the material number for the given UUID
  SELECT SINGLE matnr FROM mara
                      INTO @DATA(lv_matnr)
* BOC by Ramesh on 04/26/2022 for ASOTC-226(SIT defect) with ED2K927020  *
              WHERE ismmediatype = @c_digital
* EOC by Ramesh on 04/26/2022 for ASOTC-226(SIT defect) with ED2K927020  *
                AND zzstep_uuid = @st_itemdetails-zuuid.

  "validate the material with success to proceed
  IF sy-subrc = 0 AND lv_matnr IS NOT INITIAL.
    v_matnr = lv_matnr.
    v_flg_exec = abap_true.

    "Send error message when material not mapped
  ELSE.
    st_priceout-zuuid = st_itemdetails-zuuid.
    st_priceout-msgno = text-024.
    st_priceout-msg   = text-025.
    APPEND st_priceout TO i_priceout.

    v_status = text-030.  "Status

    "Build the log when no material found for UUID
    lv_txt = text-027 &&  text-007 && st_itemdetails-zuuid.
    PERFORM f_add_msg  USING c_msgtyp_e lv_txt '' text-009 .

    "Set the flag to Skip Execution
    v_flg_exec = abap_false.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PREPARE_HEADER_ITEM_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IM_HDRDET  text
*      -->P_st_itemdetails  text
*----------------------------------------------------------------------*
FORM f_prepare_header_item_data  USING    fp_im_hdrdet TYPE zqtc_st_price_hdr
                                          fp_st_itemdetails TYPE zqtc_st_price_itm.

  CHECK v_flg_exec = abap_true.

*  PERFORM f_prepare_bapi USING fp_im_hdrdet fp_st_itemdetails.

  "Build the control Flag
  st_control-price_details  = abap_true.
  st_control-prc_simulation = abap_true.

  "Build the Global Parameters
  st_global-auart = v_doc_type.
  st_global-vkorg = fp_im_hdrdet-vkorg.
  st_global-vtweg = fp_im_hdrdet-vtweg.
  st_global-spart = fp_im_hdrdet-spart.
  st_global-prsdt = sy-datum.

*  " Build the callerdata for header
  PERFORM f_build_caller_data_head USING fp_im_hdrdet
                                   CHANGING i_caller_data_head.

*  " Build the callerdata for Item
  PERFORM f_build_caller_data_item  USING fp_st_itemdetails
                                    CHANGING i_caller_data_item.
  "Build the header Data
  INSERT VALUE #( vbeln = v_vbeln kunnr = st_hdrdet-kunnr_bill spras = sy-langu caller_data = i_caller_data_head ) INTO TABLE i_hdr.

  "Build the Item Data
  INSERT VALUE #( kposn = v_posnr matnr = v_matnr mgame = v_qty  vrkme = v_uom varcond = i_varcond caller_data = i_caller_data_item ) INTO TABLE i_itm.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_CALLER_DATA_HEAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_CALLER_DATA_HEAD  text
*      -->P_IM_HDRDET  text
*----------------------------------------------------------------------*
FORM f_build_caller_data_head  USING    fp_im_data TYPE zqtc_st_price_hdr
                               CHANGING fp_i_caller_data TYPE piqt_name_value
                                 .
  FIELD-SYMBOLS <lfs_va1> TYPE any.
  "Get the structure for the header data
  DATA(lo_strdesc) = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( p_data = fp_im_data ) ).
  "Get the components for the header strucutre
  DATA(li_components) = lo_strdesc->get_components( ).
  "Loop the components and it values to the header caller data
  LOOP AT li_components INTO DATA(lst_components).

    "Assign the field name and value to build the header caller data
    ASSIGN COMPONENT lst_components-name OF STRUCTURE fp_im_data TO <lfs_va1>.

    IF <lfs_va1> IS ASSIGNED AND <lfs_va1> IS NOT INITIAL.
      st_caller_data-name  = lst_components-name.  "Field Name
      st_caller_data-value = <lfs_va1>.            "Value
      SHIFT st_caller_data-value LEFT DELETING LEADING space.
      APPEND st_caller_data TO fp_i_caller_data.

      UNASSIGN <lfs_va1>.
      CLEAR st_caller_data.

    ENDIF.
    CLEAR lst_components.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_CALLER_DATA_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_CALLER_DATA_ITEM  text
*      -->P_IM_HDRDET  text
*----------------------------------------------------------------------*
FORM f_build_caller_data_item  USING    fp_im_data TYPE zqtc_st_price_itm
                               CHANGING fp_i_caller_data TYPE piqt_name_value
                                 .
  FIELD-SYMBOLS <lfs_va1> TYPE any.
  "Get the structure for the Item data
  DATA(lo_strdesc) = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( p_data = fp_im_data ) ).
  "Get the components for the item strucutre
  DATA(li_components) = lo_strdesc->get_components( ).
  "Loop the components and it values to the Item caller data

  LOOP AT li_components INTO DATA(lst_components).
    "Assign the field name and value to build the item caller data
    ASSIGN COMPONENT lst_components-name OF STRUCTURE fp_im_data TO <lfs_va1>.

    IF <lfs_va1> IS ASSIGNED AND <lfs_va1> IS NOT INITIAL.
      st_caller_data-name  = lst_components-name.  "Field Name
      st_caller_data-value = <lfs_va1>.            "Value

      SHIFT st_caller_data-value LEFT DELETING LEADING space.
      APPEND st_caller_data TO fp_i_caller_data.

      UNASSIGN <lfs_va1>.
      CLEAR st_caller_data.
    ENDIF.

    CLEAR lst_components.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_INPUT_LOGS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IM_GUID  text
*      -->P_IM_HDRDET  text
*      -->P_IM_ITMDET  text
*----------------------------------------------------------------------*
FORM f_create_input_logs  USING    fp_im_guid   TYPE idoccarkey
                                   fp_im_hdrdet TYPE zqtc_st_price_hdr
                                   fp_v_itmdet  TYPE zqtc_st_price_itm
                                   fp_im_source TYPE tpm_source_name.
  "External Number
  CONCATENATE fp_im_guid
              '/'
              fp_im_hdrdet-vkorg
              fp_v_itmdet-zuuid
              INTO DATA(lv_externalnumber)
       SEPARATED BY space.

  "Creating the logs
  v_days = v_slglogdays.
  v_date = sy-datum + v_days.

*   define some header data of this log
  st_log-object     = c_object.  "ZQTC
  st_log-subobject  = c_subobj.  "ZASOTC
  st_log-aldate     = sy-datum.
  st_log-altime     = sy-uzeit.
  st_log-aluser     = sy-uname.
  st_log-alprog     = sy-repid.
  st_log-aldate_del = v_date.
  st_log-extnumber  = lv_externalnumber.  " Unique identification SLG log

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = st_log
    IMPORTING
      e_log_handle            = st_log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF. " IF sy-subrc <> 0

  " Adding the  Message logs
  PERFORM f_add_msg USING c_msgtyp '' text-001 ''.

  "Input paramter Source ID
  PERFORM f_add_msg USING c_msgtyp text-027 text-011 fp_im_source.

  "Input paramter IM_GUID
  PERFORM f_add_msg USING c_msgtyp text-027 text-048 fp_im_guid.

  "Input paramter Sales org
  PERFORM f_add_msg  USING c_msgtyp text-027 text-002 fp_im_hdrdet-vkorg.

  "Input paramter Distribution Channel
  PERFORM f_add_msg  USING c_msgtyp text-027 text-003 fp_im_hdrdet-vtweg.

  "Input paramter Division
  PERFORM f_add_msg  USING  c_msgtyp text-027 text-004 fp_im_hdrdet-spart.

* BOC by Ramesh on 05/03/2022 for ASOTC-226(ASOTC-713 defect) with ED2K927142  *

  "Input paramter Bill to party customer
  PERFORM f_add_msg  USING  c_msgtyp text-027 text-049 fp_im_hdrdet-kunnr_bill.

  "Input paramter City Bill to Party
  PERFORM f_add_msg  USING  c_msgtyp text-027 text-050 fp_im_hdrdet-city1_bp_bill.

  "Input paramter Postal Code Bill to party
  PERFORM f_add_msg  USING  c_msgtyp text-027 text-051 fp_im_hdrdet-post_code2_bill.

  "Input paramter Region Bill to party
  PERFORM f_add_msg  USING  c_msgtyp text-027 text-052 fp_im_hdrdet-regio_bill.

  "Input paramter Land Bill to party
  PERFORM f_add_msg  USING  c_msgtyp text-027 text-053 fp_im_hdrdet-land1_bill.

  "Input paramter Currency Bill to party
  PERFORM f_add_msg  USING  c_msgtyp text-027 text-054 fp_im_hdrdet-waers_bill.

  "Input paramter Customer Ship to party
  PERFORM f_add_msg  USING  c_msgtyp text-027 text-055 fp_im_hdrdet-kunnr_ship.

  "Input paramter City Ship to party
  PERFORM f_add_msg  USING  c_msgtyp text-027 text-056 fp_im_hdrdet-city1_ship.

  "Input paramter Postal code ship to party
  PERFORM f_add_msg  USING  c_msgtyp text-027 text-057 fp_im_hdrdet-post_code2_ship.

  "Input paramter Region Ship to party
  PERFORM f_add_msg  USING  c_msgtyp text-027 text-058 fp_im_hdrdet-regio_ship.

  "Input paramter Land1 ship to party
  PERFORM f_add_msg  USING c_msgtyp text-027 text-059 fp_im_hdrdet-land1_ship.

  "Input paramter Currency Ship to party
  PERFORM f_add_msg  USING c_msgtyp text-027 text-060 fp_im_hdrdet-waers_ship.

  "Input paramter VAT Registration Number
  PERFORM f_add_msg  USING c_msgtyp text-027 text-061 fp_im_hdrdet-stceg.

* EOC by Ramesh on 05/03/2022 for ASOTC-226(ASOTC-713 defect) with ED2K927142  *

  "Input paramter Pricelist
  PERFORM f_add_msg  USING c_msgtyp text-027 text-005 fp_im_hdrdet-pltyp.

  "Input paramter UUID
  PERFORM f_add_msg  USING c_msgtyp text-027 text-007 fp_v_itmdet-zuuid.

  "Input paramter Institutional Discount1(%)
  PERFORM f_add_msg  USING c_msgtyp text-027 text-032 fp_v_itmdet-zzins_disc_p1.

  "Input paramter Institutional Discount2(%)
  PERFORM f_add_msg  USING c_msgtyp text-027 text-033 fp_v_itmdet-zzins_disc_p2.

  "Input paramter Institutional Discount value1
  PERFORM f_add_msg  USING c_msgtyp text-027 text-034 fp_v_itmdet-zzins_disc_v1.

  "Input paramter Institutional Discount value2
  PERFORM f_add_msg  USING c_msgtyp text-027 text-035 fp_v_itmdet-zzins_disc_v2.

  "Input paramter Custom Discount
  PERFORM f_add_msg  USING c_msgtyp text-027 text-036 fp_v_itmdet-zzcus_disc.

  "Input paramter Society Promo Discount 1
  PERFORM f_add_msg  USING c_msgtyp text-027 text-042 fp_v_itmdet-zzassocpromo.

  "Input paramter Society Promo Discount 2
  PERFORM f_add_msg  USING c_msgtyp text-027 text-043 fp_v_itmdet-zzassocpromo2.

  "Input paramter Society Promo Discount 3
  PERFORM f_add_msg  USING c_msgtyp text-027 text-044 fp_v_itmdet-zzassocpromo3.

  "Input paramter Society Promo Discount 4
  PERFORM f_add_msg  USING c_msgtyp text-027 text-045 fp_v_itmdet-zzassocpromo4.

  "Input paramter Society Promo Discount 5
  PERFORM f_add_msg  USING c_msgtyp text-027 text-046 fp_v_itmdet-zzassocpromo5.

  "Input paramter Promo Discount 1
  PERFORM f_add_msg  USING c_msgtyp text-027 text-037 fp_v_itmdet-zzpromo.

  "Input paramter Promo Discount 2
  PERFORM f_add_msg  USING c_msgtyp text-027 text-038 fp_v_itmdet-zzaspromo2.

  "Input paramter Promo Discount 3
  PERFORM f_add_msg  USING c_msgtyp text-027 text-039 fp_v_itmdet-zzaspromo3.

  "Input paramter Promo Discount 4
  PERFORM f_add_msg  USING c_msgtyp text-027 text-040 fp_v_itmdet-zzaspromo4.

  "Input paramter Promo Discount 5
  PERFORM f_add_msg  USING c_msgtyp text-027 text-041 fp_v_itmdet-zzaspromo5.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADD_MSG_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_add_msg_log .

  " Adding messages.
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = st_log_handle
      i_s_msg          = st_msg
    EXCEPTIONS
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      OTHERS           = 4.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_ITEM_DETAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IM_ITMDET  text
*      <--P_st_itemdetails  text
*----------------------------------------------------------------------*
FORM f_read_item_detail  USING   fp_im_hdrdet TYPE zqtc_st_price_hdr
                                 fp_im_itmdet TYPE zqtc_tt_price_itm
                         CHANGING fp_st_itemdetails TYPE zqtc_st_price_itm.

  "Read the Item Data
  READ TABLE fp_im_itmdet INTO fp_st_itemdetails INDEX 1.
  "Move the item data
  st_hdrdet = fp_im_hdrdet.

  "Bill to party customer
  IF st_hdrdet-kunnr_bill IS INITIAL.
    st_hdrdet-kunnr_bill  = v_kunnr.
  ENDIF.

  "Ship to party Customer
  IF st_hdrdet-kunnr_ship IS INITIAL.
    st_hdrdet-kunnr_ship  = v_kunnr.
  ENDIF.

* BOC by Ramesh on 04/20/2022 for ASOTC-226 with ED2K926894  *
  PERFORM f_replace_symbols CHANGING fp_st_itemdetails.
* EOC by Ramesh on 04/20/2022 for ASOTC-226 with ED2K926894  *

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALL_PRICE_SIMULATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_call_price_simulate .

  DATA : li_cond_cpy TYPE piqt_calculate_cond_result,
         lv_flg_zidn TYPE c.

*  PERFORM f_call_bapi.

  "Check the flag to execute or not
  CHECK v_flg_exec = abap_true.
  TRY.
      "Call the Price enquiry FM
      CALL FUNCTION 'PIQ_CALCULATE'
        EXPORTING
          iv_caller_id   = c_std
          is_control     = st_control
          is_global      = st_global
          it_head        = i_hdr
          it_item        = i_itm
        IMPORTING
          et_result      = i_result
          et_message     = i_message
        EXCEPTIONS
          system_failure = 1000
          OTHERS         = 1002.

      IF sy-subrc = 0 AND i_result IS NOT INITIAL.
        READ TABLE i_result INTO DATA(lst_result) INDEX 1.
        IF sy-subrc = 0.
          "Read item data from given results
          DATA(li_item) = lst_result-item[].
          READ TABLE li_item INTO DATA(lst_item) INDEX 1.
          IF sy-subrc = 0.
            "Move the condition type from givine results
            DATA(li_cond) = lst_item-cond.
            li_cond_cpy[] = li_cond[].

            "Read the Institutional condition types of the output data
            READ TABLE li_cond INTO DATA(lst_cond) WITH KEY kschl = c_zidn
                                                            kinak = abap_false.

            IF sy-subrc = 0 AND lst_cond-kwert < 0.
              st_priceout-apld_disctyp = lst_cond-kschl.
              lv_flg_zidn = abap_true.

              "Copy to local condition
              DELETE li_cond_cpy WHERE kschl NOT IN ir_manu_type.
              DELETE li_cond_cpy WHERE kwert = 0.

              "Promo and Society promo discount condition types from the output
            ELSE.
              DELETE li_cond_cpy WHERE kschl NOT IN ir_cond_type.
              DELETE li_cond_cpy WHERE kwert = 0.
              READ TABLE li_cond_cpy INTO DATA(lst_cond_man)
                                                        WITH KEY kinak = abap_false .
              IF sy-subrc = 0.
                "Map the Condition type, desc and amount from the given results
                PERFORM f_map_cond_desc USING lv_flg_zidn lst_cond_man
                                     CHANGING st_priceout.
                FREE li_cond_cpy.
              ENDIF.

            ENDIF.

            "Build the output data to the AS return data
            st_priceout-zuuid      = st_itemdetails-zuuid. "Journal ID
            st_priceout-currency   = lst_result-waerk.  "Currency
            st_priceout-base_price = lst_item-kzwi1.    "Base Price
            st_priceout-disc_price = lst_item-kzwi3.  "kzwi5 "Discounted Price

            "Discounted price is in + then set to 0
            IF st_priceout-disc_price < 0.
              st_priceout-disc_price = 0.
            ENDIF.

            st_priceout-amt_chrgd  = lst_item-kzwi4. "kzwi2. "Amount to be charged
            "Amount charged is in - then set to 0
            IF st_priceout-amt_chrgd < 0.
              st_priceout-amt_chrgd = 0.
            ENDIF.
            st_priceout-apld_disc  = lst_item-kzwi5.
            st_priceout-apld_tax   = lst_item-kzwi6.
            st_priceout-msgno    = 200.
            st_priceout-msg      = text-008.
            v_status             = text-029.
            APPEND st_priceout TO i_priceout.

            "Institional Discounts Processing for SPLIT UP the condtion price
            IF li_cond_cpy[] IS NOT INITIAL.

              LOOP AT li_cond_cpy INTO lst_cond.

                IF lv_flg_zidn = abap_true.
                  "Check for values sent from AS for ZIP1 condition type
                  IF st_itemdetails-zzins_disc_p1 IS NOT INITIAL AND
                    lst_cond-kschl = c_zip1.
                    "Map the Condition type, desc and amount from the given results
                    PERFORM f_map_cond_desc USING lv_flg_zidn lst_cond CHANGING st_priceout.
                  ENDIF.

                  "Check for values sent from AS for ZIP2 condition type
                  IF st_itemdetails-zzins_disc_p2 IS NOT INITIAL AND
                   lst_cond-kschl = c_zip2.
                    "Map the Condition type, desc and amount from the given results
                    PERFORM f_map_cond_desc USING lv_flg_zidn lst_cond CHANGING st_priceout.
                  ENDIF.

                  "Check for values sent from AS for ZIV1 condition type
                  IF st_itemdetails-zzins_disc_v1 IS NOT INITIAL AND
                     lst_cond-kschl = c_ziv1.
                    "Map the Condition type, desc and amount from the given results
                    PERFORM f_map_cond_desc USING lv_flg_zidn lst_cond CHANGING st_priceout.
                  ENDIF.

                  "Check for values sent from AS for ZIV2 condition type
                  IF st_itemdetails-zzins_disc_v2 IS NOT INITIAL AND
                     lst_cond-kschl = c_ziv2.
                    "Map the Condition type, desc and amount from the given results
                    PERFORM f_map_cond_desc USING lv_flg_zidn lst_cond CHANGING st_priceout.
                  ENDIF.
                ENDIF.

                CLEAR lst_cond.
              ENDLOOP.

              IF lv_flg_zidn = abap_true.
                DELETE i_priceout WHERE apld_disctyp  = c_zidn.
              ENDIF.

            ENDIF.
          ENDIF.
        ENDIF.

        "Check for error in return messages
      ELSEIF i_result IS INITIAL AND i_message IS NOT INITIAL.
        st_priceout-zuuid = st_itemdetails-zuuid.
        st_priceout-msgno = text-024.
        st_priceout-msg   = text-026.
        APPEND st_priceout TO i_priceout.
        v_status = text-030.
      ENDIF.

      "Catch the exception
    CATCH cx_root INTO io_err.
      IF io_err IS BOUND.
        st_priceout-zuuid = st_itemdetails-zuuid.
        st_priceout-msgno = text-024.
        st_priceout-msg = io_err->get_text( ).
        APPEND st_priceout TO i_priceout.
        st_msg-msgno    = st_priceout-msgno.
        st_msg-msgv1    = st_priceout-msg.
        PERFORM f_add_msg_log.
      ENDIF.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_OUTPUT_LOGS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IM_GUID  text
*      -->P_IM_HDRDET  text
*      -->P_st_itemdetails  text
*      -->P_IM_SOURCE  text
*----------------------------------------------------------------------*
FORM f_create_output_logs  USING    fp_im_guid       TYPE idoccarkey
                                    fp_im_hdrdet     TYPE zqtc_st_price_hdr
                                    fp_v_itmdet      TYPE zqtc_st_price_itm
                                    fp_im_source.

  DATA lv_data TYPE char50.
  DATA li_log_handle TYPE bal_t_logh.

  FREE li_log_handle.

  "Append the log handle data
  APPEND st_log_handle TO li_log_handle.

  "Response from SAP, After validation
  PERFORM f_add_msg  USING c_msgtyp '' text-012 ''.

  "Output paramter UUID
  PERFORM f_add_msg  USING c_msgtyp text-028 text-007 fp_v_itmdet-zuuid.

  LOOP AT i_priceout INTO st_priceout.
    "Base Price
    WRITE  st_priceout-base_price TO lv_data CURRENCY st_priceout-currency .
    SHIFT lv_data LEFT DELETING LEADING space.
    PERFORM f_add_msg  USING c_msgtyp text-028 text-015 lv_data.

    "Currency
    PERFORM f_add_msg  USING c_msgtyp text-028 text-016 st_priceout-currency.

    "Applied Discount
    CLEAR lv_data.
    WRITE  st_priceout-apld_disc TO lv_data CURRENCY st_priceout-currency .
    SHIFT lv_data LEFT DELETING LEADING space.
    PERFORM f_add_msg  USING c_msgtyp text-028 text-017 lv_data.

    "Applied Discount type
    CLEAR lv_data.
    WRITE  st_priceout-apld_disctyp TO lv_data CURRENCY st_priceout-currency .
    SHIFT lv_data LEFT DELETING LEADING space.
    PERFORM f_add_msg  USING c_msgtyp text-028 text-018 lv_data.

    "Applied Tax
    CLEAR lv_data.
    WRITE  st_priceout-apld_tax TO lv_data CURRENCY st_priceout-currency .
    SHIFT lv_data LEFT DELETING LEADING space.
    PERFORM f_add_msg  USING c_msgtyp text-028 text-019 lv_data.

    "Discount Price
    CLEAR lv_data.
    WRITE  st_priceout-disc_price TO lv_data CURRENCY st_priceout-currency .
    SHIFT lv_data LEFT DELETING LEADING space.
    PERFORM f_add_msg  USING c_msgtyp text-028 text-020 lv_data.

    "Amount Charged
    CLEAR lv_data.
    WRITE  st_priceout-amt_chrgd TO lv_data CURRENCY st_priceout-currency .
    SHIFT lv_data LEFT DELETING LEADING space.
    PERFORM f_add_msg  USING c_msgtyp text-028 text-021 lv_data.

  ENDLOOP.

  IF i_message IS NOT INITIAL.
    DELETE i_message WHERE type NE c_e.
    IF sy-subrc = 0 AND i_message[] IS NOT INITIAL.
      LOOP AT i_message INTO DATA(lst_message).
        st_priceout-zuuid = fp_v_itmdet-zuuid.
        st_priceout-msgno = text-024.
        st_priceout-msg   = lst_message-message.

        "Add the msg log
        st_msg-msgty      = c_msgtyp_e.
        st_msg-msgno      = st_priceout-msgno.
        st_msg-msgv1      = lst_message-message.
        PERFORM f_add_msg_log.

        "Append the message log
        APPEND st_priceout TO i_priceout.
        CLEAR : lst_message , st_priceout.

      ENDLOOP.
      PERFORM f_add_msg  USING c_msgtyp text-028 text-026 ''.
      v_status = text-030.
    ENDIF.
  ENDIF.

  IF v_status = text-030.
    PERFORM f_add_msg  USING c_msgtyp_e text-028 text-047 text-030.
  ELSEIF v_status = text-029.
    PERFORM f_add_msg  USING c_msgtyp text-028 text-047 text-029.
  ENDIF.

  "Response from SAP, After validation
  PERFORM f_add_msg  USING c_msgtyp '' text-022 ' '.

  "*  Save logs in the database
  CALL FUNCTION 'BAL_DB_SAVE' ##FM_SUBRC_OK
    EXPORTING
      i_t_log_handle   = li_log_handle
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
    "Do Nothing
  ENDIF. " IF sy-subrc <> 0

  " Commit work for the Application log update
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADD_MSG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TEXT_001  text
*      -->P_0352   text
*----------------------------------------------------------------------*
FORM f_add_msg  USING    fp_v_msgtyp
                         fp_param
                         fp_text
                         fp_v_data.

  DATA lv_text TYPE char50.

  CLEAR lv_text.
  CLEAR st_msg.

  "Map the msg log
  st_msg-msgty     = fp_v_msgtyp.
  st_msg-msgid     = c_msgid.
  st_msg-msgno     = c_msgno.
  st_msg-msgv1     = fp_param.

  CONCATENATE fp_text fp_v_data INTO lv_text.
  st_msg-msgv2     =  lv_text.

  PERFORM f_add_msg_log.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PREPARE_BAPI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IM_HDRDET  text
*      -->P_st_itemdetails  text
*----------------------------------------------------------------------*
FORM f_prepare_bapi  USING    fp_im_hdrdet     TYPE zqtc_st_price_hdr
                              fp_st_itemdetails TYPE zqtc_st_price_itm.

  "Filling Header Data.
  CLEAR st_header_in.
  st_header_in-doc_type    = v_doc_type.
  st_header_in-sales_org   = fp_im_hdrdet-vkorg.
  st_header_in-distr_chan  = fp_im_hdrdet-vtweg.
  st_header_in-division    = fp_im_hdrdet-spart.
  st_header_in-price_list  = fp_im_hdrdet-pltyp.

  CLEAR st_partner.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALL_BAPI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_call_bapi .

  IF i_items_in[] IS NOT INITIAL.
    "Passing all values to BAPI Simulate order to validate further
    CALL FUNCTION 'BAPI_SALESORDER_SIMULATE'
      EXPORTING
        order_header_in    = st_header_in
      IMPORTING
        sold_to_party      = st_sold
        ship_to_party      = st_ship
        billing_party      = st_bill
        return             = st_return
      TABLES
        order_items_in     = i_items_in
        order_partners     = i_partner
        order_condition_ex = i_conditions_ex
      EXCEPTIONS
        system_failure     = 1000
        OTHERS             = 1002.
    IF  sy-subrc IS INITIAL.

    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants .

  DATA lst_cond_type TYPE farr_s_range_cond.

  "Fetching Entries from Constant Table
  SELECT mandt
         devid
         param1
         param2
         srno
         sign
         opti
         low
         high
         activate
         description
         aenam
         aedat
    FROM zcaconstant
    INTO TABLE i_constant
   WHERE devid    EQ c_devid
     AND activate EQ abap_true.

  IF  sy-subrc     IS INITIAL
  AND i_constant   IS NOT INITIAL.

    LOOP AT i_constant
      INTO DATA(lst_constant).
      CASE lst_constant-param1.
          "Promo & Society Promo condition types
        WHEN  c_cond_type.
          lst_cond_type-sign   =  lst_constant-sign.
          lst_cond_type-option =  lst_constant-opti.
          lst_cond_type-low    =  lst_constant-low.
          APPEND lst_cond_type TO ir_cond_type.

        WHEN c_manu_cond_type.      "Manual condition types
          lst_cond_type-sign   =  lst_constant-sign.
          lst_cond_type-option =  lst_constant-opti.
          lst_cond_type-low    =  lst_constant-low.
          APPEND lst_cond_type TO ir_manu_type.

        WHEN c_slglogdays.          "SLG Log days
          v_slglogdays = lst_constant-low.

        WHEN c_customer.            "Customer
          v_kunnr = lst_constant-low.

        WHEN c_item_no.             "Sales document item number
          v_posnr = lst_constant-low.

        WHEN c_quantity.            "Quantity
          v_qty = lst_constant-low.

        WHEN c_sales_doc.           "Sales document number
          v_vbeln = lst_constant-low.

        WHEN c_uom.                 "Unit of measure
          v_uom = lst_constant-low.

        WHEN c_document_type.       "Document type
          v_doc_type = lst_constant-low.

        WHEN c_as_desc.             "Author Service Description Text
          CLEAR st_as_desc.
          st_as_desc-kschl = lst_constant-param2.
          st_as_desc-desc = lst_constant-low.
          APPEND st_as_desc TO i_as_desc.

        WHEN: OTHERS.
          "Do Nothing
      ENDCASE.

      CLEAR : lst_cond_type, lst_constant.
    ENDLOOP.

    "Sort the Data for AS description
    IF i_as_desc[] IS NOT INITIAL.
      SORT i_as_desc BY kschl.
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPD_COND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_COND  text
*      <--P_ST_PRICEOUT  text
*----------------------------------------------------------------------*
FORM f_map_cond_desc  USING   fp_lv_flg_zidn  TYPE c
                              fp_lst_cond     TYPE piqs_calculate_cond_result
                    CHANGING fp_st_priceout   TYPE zqtc_st_price_out .

  "Read the AS description and map the final output
  READ TABLE i_as_desc  INTO st_as_desc
                        WITH KEY kschl = fp_lst_cond-kschl
                        BINARY SEARCH.

  IF sy-subrc = 0.
    fp_st_priceout-as_cond_desc = st_as_desc-desc.
  ENDIF.

  fp_st_priceout-apld_disctyp = fp_lst_cond-kschl.
*  fp_st_priceout-apld_disc    = fp_lst_cond-kwert.

  "Append for multiple institutional discounts
  IF fp_lv_flg_zidn = abap_true.
    APPEND fp_st_priceout TO i_priceout.
    CLEAR : fp_st_priceout-apld_disctyp.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_INP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_ITEMDETAILS  text
*      <--P_I_PRICEOUT  text
*----------------------------------------------------------------------*
FORM f_validate_inp  USING    fp_st_itemdetails TYPE zqtc_st_price_itm
                     CHANGING fp_i_priceout     TYPE zqtc_tt_price_out.

  IF ( ( fp_st_itemdetails-zzins_disc_p1 > 0 AND
     fp_st_itemdetails-zzins_disc_v1 > 0 ) OR
     ( fp_st_itemdetails-zzins_disc_p2 > 0 AND
     fp_st_itemdetails-zzins_disc_v2 > 0 ) ) .

    "Add msg log
    PERFORM f_add_msg USING c_msgtyp_e text-027 text-031 ' '.
    st_priceout-zuuid = fp_st_itemdetails-zuuid.
    st_priceout-msgno = text-024.
    st_priceout-msg   = text-031.

    APPEND st_priceout TO fp_i_priceout.
    v_status = text-030.
    v_flg_exec = abap_false.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_REPLACE_SYMBOLS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_FP_ST_ITEMDETAILS  text
*----------------------------------------------------------------------*
FORM f_replace_symbols  CHANGING fp_st_itemdetails TYPE zqtc_st_price_itm.

  CONSTANTS lc_comma TYPE c VALUE ','.

  "Custom Discounts
  IF fp_st_itemdetails-zzcus_disc CA lc_comma.
    REPLACE lc_comma WITH space INTO fp_st_itemdetails-zzcus_disc.
    CONDENSE fp_st_itemdetails-zzcus_disc NO-GAPS.
  ENDIF.

  "Institutional Discount Percentage 1
  IF fp_st_itemdetails-zzins_disc_p1 CA lc_comma.
    REPLACE lc_comma WITH space INTO fp_st_itemdetails-zzins_disc_p1.
    CONDENSE fp_st_itemdetails-zzins_disc_p1 NO-GAPS.
  ENDIF.

  "Institutional Discount Percentage 2
  IF fp_st_itemdetails-zzins_disc_p2 CA lc_comma.
    REPLACE lc_comma WITH space INTO fp_st_itemdetails-zzins_disc_p2.
    CONDENSE fp_st_itemdetails-zzins_disc_p2 NO-GAPS.
  ENDIF.

  "Institutional Discount Value 1
  IF fp_st_itemdetails-zzins_disc_v1 CA lc_comma.
    REPLACE lc_comma WITH space INTO fp_st_itemdetails-zzins_disc_v1.
    CONDENSE fp_st_itemdetails-zzins_disc_v1 NO-GAPS.
  ENDIF.

  "Institutional Discount Value 2
  IF fp_st_itemdetails-zzins_disc_v2 CA lc_comma.
    REPLACE lc_comma WITH space INTO fp_st_itemdetails-zzins_disc_v2.
    CONDENSE fp_st_itemdetails-zzins_disc_v2 NO-GAPS.
  ENDIF.

ENDFORM.
