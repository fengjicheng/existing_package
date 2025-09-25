*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CCDUP_SUB
*&---------------------------------------------------------------------*
FORM f_f4_file_name  CHANGING fp_p_file TYPE rlgrap-filename. " Local file for upload/download

* Popup for file path

  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name     = fp_p_file " File Path
    EXCEPTIONS
      mask_too_long = 1
      OTHERS        = 2.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid
          TYPE sy-msgty
        NUMBER sy-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.

*&-----------------------------------*
*&      Form  F_CONVERT_EXCEL
*&-----------------------------------*
*       Convert Excel
*-----------------------------------*
*      ->P_P_FILE  text
*      <-P_I_FINAL  text
*-----------------------------------*

FORM f_convert_excel  USING   fp_p_file  TYPE rlgrap-filename .

  DATA : li_excel        TYPE STANDARD TABLE OF zqtc_alsmex_tabline "alsmex_tabline " Rows for Table with Excel Data
                              INITIAL SIZE 0,                  " Rows for Table with Excel Data
         lst_excel_dummy TYPE zqtc_alsmex_tabline, "alsmex_tabline,                  " Rows for Table with Excel Data
         lst_excel       TYPE zqtc_alsmex_tabline, "alsmex_tabline,                  " Rows for Table with Excel Data
         lv_excol        TYPE kcd_ex_col_n,
         lv_parw         TYPE parvw,
         lv_sold         TYPE parvw,
         lv_tbx          TYPE sy-tabix,
         lv_hdr          TYPE i,
         lv_loghandle    TYPE balloghndl.


  DATA:  lv_zmeng TYPE char17. " Zmeng of type CHAR17
  DATA:lv_auart_cre  TYPE auart,
       lv_col        TYPE i,
       lv_oid(10)    TYPE n,
       lv_count      TYPE i,
       li_log_handle TYPE bal_t_logh,
       lv_item       TYPE posnr,
       lv_log        TYPE balognr,
       lv_msgty      TYPE char1,
       lv_kdkg2      TYPE kdkg2.

  CALL FUNCTION 'ZQTC_EXCEL_TO_INTERNAL_TABLE' "'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = fp_p_file
      i_begin_col             = 1
      i_begin_row             = 2
* BOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820 *
*     i_end_col               = 67
      i_end_col               = 70
* EOC by Lahiru on 10/09/2020 for OTCM-22276 with ED2K919820 *
      i_end_row               = 65000
    TABLES
      intern                  = li_excel
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.

  IF sy-subrc EQ 0.
* Now fill data from excel into final legacy data internal table

    IF NOT li_excel[] IS INITIAL.
      IF rb_cel IS NOT INITIAL.
        LOOP AT li_excel INTO lst_excel.
          lst_excel_dummy = lst_excel.
          AT NEW col.

            CASE lst_excel_dummy-col.
              WHEN 1.
                IF NOT wa_client IS INITIAL.

                  APPEND wa_client TO i_client.
                  CLEAR wa_client.
                ENDIF. " IF NOT wa_client IS INITIAL

                wa_client-locid = lst_excel_dummy-value(10).

              WHEN 2.
                wa_client-currcode = lst_excel_dummy-value(10).

              WHEN 3.
                wa_client-fundate = lst_excel_dummy-value(2).

              WHEN 4.

                wa_client-extmid = lst_excel_dummy-value(1).

              WHEN 5.
                wa_client-dbaname = lst_excel_dummy-value(1).

              WHEN 6.
                wa_client-terminal = lst_excel_dummy-value(4).

              WHEN 7.
                wa_client-batchnum = lst_excel_dummy-value.

              WHEN 8.

                wa_client-batchseqnum = lst_excel_dummy-value.

              WHEN 9.

                wa_client-invoice = lst_excel_dummy-value.

              WHEN 10.

                wa_client-trdate = lst_excel_dummy-value.

              WHEN 11.

                wa_client-subdate = lst_excel_dummy-value.


              WHEN 12.
                wa_client-cardtype = lst_excel_dummy-value.


              WHEN 13.
                wa_client-cardnumber = lst_excel_dummy-value.


              WHEN 14.
                wa_client-pstatus = lst_excel_dummy-value.

              WHEN 15.

                wa_client-trans_amt = lst_excel_dummy-value.


              WHEN 16.
                wa_client-trans_type = lst_excel_dummy-value.

              WHEN 17.
                wa_client-trans_status = lst_excel_dummy-value.

              WHEN 18.
                wa_client-pos_mode = lst_excel_dummy-value(2).

              WHEN 19.
                wa_client-pos_descr = lst_excel_dummy-value.

              WHEN 20.
                wa_client-authcode = lst_excel_dummy-value(2).


              WHEN 21.
                wa_client-sapdoc = lst_excel_dummy-value(3).


              WHEN 22.

                wa_client-sapcust = lst_excel_dummy-value.

              WHEN 23.
                wa_client-sapdupsheet = lst_excel_dummy-value.
              WHEN 24.
                wa_client-code1 = lst_excel_dummy-value.
              WHEN 25.
                wa_client-servicecode = lst_excel_dummy-value.

              WHEN 26.
                wa_client-auth_trtype = lst_excel_dummy-value.

              WHEN 27.
                wa_client-plancode = lst_excel_dummy-value.
              WHEN 28.
                wa_client-plan_descr = lst_excel_dummy-value.

              WHEN 29.
                wa_client-debitnwid = lst_excel_dummy-value.


              WHEN 30.
                wa_client-rejectreas = lst_excel_dummy-value.

              WHEN 31.
                wa_client-track_numb = lst_excel_dummy-value.

              WHEN 32.
                wa_client-order_num = lst_excel_dummy-value.

              WHEN 33.
                wa_client-tr_class = lst_excel_dummy-value.

              WHEN 34.
                wa_client-mobile_ind = lst_excel_dummy-value.

              WHEN 35.
                wa_client-elec_commind = lst_excel_dummy-value.

            ENDCASE.
          ENDAT.
        ENDLOOP. " LOOP AT li_excel INTO lst_excel

        IF NOT wa_client IS INITIAL.

          APPEND wa_client TO i_client.
          CLEAR wa_client.
        ENDIF. " IF NOT wa_client IS INITIAL

      ELSEIF rb_amx IS NOT INITIAL.  "Amex Merchant
        FREE:i_amex[].
        CLEAR:wa_amex.
        LOOP AT li_excel INTO lst_excel.
          lst_excel_dummy = lst_excel.
          AT NEW col.

            CASE lst_excel_dummy-col.
              WHEN 1.
                IF NOT wa_amex IS INITIAL.

                  APPEND wa_amex TO i_amex.
*                  MOVE-CORRESPONDING wa_wpay TO wa_client.
*                  APPEND wa_client TO i_client.
                  CLEAR: wa_amex.
                ENDIF. " IF NOT wa_client IS INITIAL
                wa_amex-trdate  =  lst_excel_dummy-value.
              WHEN 2.
                wa_amex-settl_date  =  lst_excel_dummy-value.
              WHEN 3.
                wa_amex-merch_numb  =  lst_excel_dummy-value.
              WHEN 4.
                wa_amex-trans_amt  =  lst_excel_dummy-value.
              WHEN 5.
                wa_amex-locid  =  lst_excel_dummy-value.
              WHEN 6.
                wa_amex-cardnumber  =  lst_excel_dummy-value.
              WHEN 7.
                wa_amex-adj_type  =  lst_excel_dummy-value.
              WHEN 8.
                wa_amex-charge_ref  =  lst_excel_dummy-value.
              WHEN 9.
                wa_amex-auth_type  =  lst_excel_dummy-value.
              WHEN 10.
                wa_amex-authcode  =  lst_excel_dummy-value.
                IF  wa_amex-authcode CA '-'.
                  CLEAR: wa_amex-authcode.
                ENDIF.
              WHEN 11.
                wa_amex-type  =  lst_excel_dummy-value.
            ENDCASE.
          ENDAT.
        ENDLOOP.
        IF NOT wa_amex IS INITIAL.

          APPEND wa_amex TO i_amex.
          CLEAR wa_amex.
        ENDIF. " IF NOT wa_client IS INITIAL


      ELSEIF rb_wrk IS NOT INITIAL.  "World Pay

        LOOP AT li_excel INTO lst_excel.
          lst_excel_dummy = lst_excel.
          AT NEW col.

            CASE lst_excel_dummy-col.
              WHEN 1.
                IF NOT wa_wpay IS INITIAL.

                  APPEND wa_wpay TO i_wpay.
*                  MOVE-CORRESPONDING wa_wpay TO wa_client.
*                  APPEND wa_client TO i_client.
                  CLEAR: wa_wpay,wa_client..
                ENDIF. " IF NOT wa_client IS INITIAL
                wa_wpay-orderid	=	 lst_excel_dummy-value.
              WHEN 2.
                wa_wpay-settype	=	 lst_excel_dummy-value.
              WHEN 3.
                wa_wpay-trdate  =  lst_excel_dummy-value.
              WHEN 4.
                wa_wpay-tstamp  =  lst_excel_dummy-value.
              WHEN 5.
                wa_wpay-setstatus	=	 lst_excel_dummy-value.
              WHEN 6.
                wa_wpay-setstreason	=	 lst_excel_dummy-value.
              WHEN 7.
                wa_wpay-setdate	=	 lst_excel_dummy-value.
              WHEN 8.
                wa_wpay-trans_amt  =  lst_excel_dummy-value.
              WHEN 9.
                wa_wpay-currcode  =  lst_excel_dummy-value.
              WHEN 10.
                wa_wpay-set_amt	=	 lst_excel_dummy-value.
              WHEN 11.
                wa_wpay-setamt_curr	=	 lst_excel_dummy-value.
              WHEN 12.
                wa_wpay-tr_src  =  lst_excel_dummy-value.
              WHEN 13.
                wa_wpay-pay_method  =  lst_excel_dummy-value.
              WHEN 14.
                wa_wpay-cardtype  =  lst_excel_dummy-value.
              WHEN 15.
                wa_wpay-cardnumber  =  lst_excel_dummy-value.
              WHEN 16.
                wa_wpay-issu_bank	=	 lst_excel_dummy-value.
              WHEN 17.
                wa_wpay-bank_country  =  lst_excel_dummy-value.
              WHEN 18.
                wa_wpay-provider  =  lst_excel_dummy-value.
              WHEN 19.
                wa_wpay-prov_path	=	 lst_excel_dummy-value.
              WHEN 20.
                wa_wpay-trid  =  lst_excel_dummy-value.
              WHEN 21.
                wa_wpay-arn	=	 lst_excel_dummy-value.
              WHEN 22.
                wa_wpay-fun_trid  =  lst_excel_dummy-value.
              WHEN 23.
                wa_wpay-authcode  =  lst_excel_dummy-value.
              WHEN 24.
                wa_wpay-auth_method	=	 lst_excel_dummy-value.
              WHEN 25.
                wa_wpay-cvv2  =  lst_excel_dummy-value.
              WHEN 26.
                wa_wpay-avs	=	 lst_excel_dummy-value.
              WHEN 27.
                wa_wpay-term_typ  =  lst_excel_dummy-value.
              WHEN 28.
                wa_wpay-termid  =  lst_excel_dummy-value.
              WHEN 29.
                wa_wpay-entry_meth  =  lst_excel_dummy-value.
              WHEN 30.
                wa_wpay-bu_path	=	 lst_excel_dummy-value.
              WHEN 31.
                wa_wpay-compid  =  lst_excel_dummy-value.
              WHEN 32.
                wa_wpay-mid	=	 lst_excel_dummy-value.
              WHEN 33.
                wa_wpay-mcc	=	 lst_excel_dummy-value.
              WHEN 34.
                wa_wpay-recp_numb	=	 lst_excel_dummy-value.
              WHEN 35.
                wa_wpay-al_tick_num	=	 lst_excel_dummy-value.
              WHEN 36.
                wa_wpay-fund_trgrp  =  lst_excel_dummy-value.
              WHEN 37.
                wa_wpay-prov_cvv2	=	 lst_excel_dummy-value.
              WHEN 38.
                wa_wpay-prov_avs  =  lst_excel_dummy-value.
              WHEN 39.
                wa_wpay-storeid	=	 lst_excel_dummy-value.
              WHEN 40.
                wa_wpay-bill_descr  =  lst_excel_dummy-value.
              WHEN 41.
                wa_wpay-term_country  =  lst_excel_dummy-value.
              WHEN 42.
                wa_wpay-term_city	=	 lst_excel_dummy-value.
              WHEN 43.
                wa_wpay-termi_model	=	 lst_excel_dummy-value.
              WHEN 44.
                wa_wpay-iin	=	 lst_excel_dummy-value.
              WHEN 45.
                wa_wpay-last4	=	 lst_excel_dummy-value.
              WHEN 46.
                wa_wpay-bank_st_narr  =  lst_excel_dummy-value.
              WHEN 47.
                wa_wpay-digi_wall	=	 lst_excel_dummy-value.
              WHEN 48.
                wa_wpay-ord_amt	=	 lst_excel_dummy-value.
              WHEN 49.

                wa_wpay-ord_amt_curr  =  lst_excel_dummy-value.
              WHEN 50.
                wa_wpay-cashback_amt  =  lst_excel_dummy-value.
              WHEN 51.
                wa_wpay-cashback_curr	=	 lst_excel_dummy-value.
              WHEN 52.
                wa_wpay-dona_amt  =  lst_excel_dummy-value.
              WHEN 53.
                wa_wpay-dona_curr	=	 lst_excel_dummy-value.
              WHEN 54.
                wa_wpay-grat_amt  =  lst_excel_dummy-value.
              WHEN 55.
                wa_wpay-grat_amt_curr	=	 lst_excel_dummy-value.
              WHEN 56.
                wa_wpay-repogrp	=	 lst_excel_dummy-value.
              WHEN 57.
                wa_wpay-accp_dat  =  lst_excel_dummy-value.
              WHEN 58.
                wa_wpay-est_date  =  lst_excel_dummy-value.
              WHEN 59.
                wa_wpay-sch_refid	=	 lst_excel_dummy-value.


            ENDCASE.
          ENDAT.
        ENDLOOP. " LOOP AT li_excel INTO lst_excel

        IF NOT wa_wpay IS INITIAL.

          APPEND wa_wpay TO i_wpay.
*          MOVE-CORRESPONDING wa_wpay TO wa_client.
*          APPEND wa_client TO i_client.
          CLEAR: wa_wpay,wa_client..
          CLEAR wa_wpay.
        ENDIF. " IF NOT wa_client IS INITIAL

      ENDIF.   "IF RB_CEL is not initial

    ENDIF. " IF NOT li_excel[] IS INITIAL

  ENDIF. " IF sy-subrc EQ 0





ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LIST_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_list_display .
  FREE:i_fieldcat[].
  PERFORM f_build_fieldcatalog.
  PERFORM f_build_layout.

  IF i_output IS NOT INITIAL.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program = sy-repid
        is_layout          = w_layout
*       i_callback_user_command = 'F_HANDLE_USER_COMMAND' "To handle user command
        it_fieldcat        = i_fieldcat
*       is_variant         = i_variant
        i_save             = 'A'
      TABLES
        t_outtab           = i_output
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
  ENDIF.
*
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_fieldcatalog .

  IF rb_cel IS NOT INITIAL.
    PERFORM f_build_fcatalog USING:
      'LOCID' 'I_OUTPUT'    'Location ID' ,
      'CURRCODE'  'I_OUTPUT'    'Processed Currency Code' ,
      'FUNDATE' 'I_OUTPUT'    'Funded Date' ,
      'EXTMID'  'I_OUTPUT'    'External MID'  ,
      'DBANAME' 'I_OUTPUT'    'DBA Name'  ,
      'TERMINAL'  'I_OUTPUT'    'Terminal ID' ,
      'BATCHNUM'  'I_OUTPUT'    'Batch Number'  ,
      'BATCHSEQNUM' 'I_OUTPUT'    'Batch Sequence Number' ,
      'INVOICE' 'I_OUTPUT'    'Invoice Number'  ,
      'TRDATE'  'I_OUTPUT'    'Transaction Date'  ,
      'SUBDATE' 'I_OUTPUT'    'Submit Date' ,
      'CARDTYPE'  'I_OUTPUT'    'Card Type' ,
      'CARDNUMBER'  'I_OUTPUT'    'Cardholder Number' ,
      'PSTATUS' 'I_OUTPUT'    'SAP Duplicate '  ,
      'TRANS_AMT' 'I_OUTPUT'    'Processed Transaction Amount'  ,
      'TRANS_TYPE'  'I_OUTPUT'    'Transaction Type'  ,
      'TRANS_STATUS'  'I_OUTPUT'    'Transaction Status'  ,
      'POS_MODE'  'I_OUTPUT'    'POS Entry Mode'  ,
      'POS_DESCR' 'I_OUTPUT'    'POS Entry Description' ,
      'AUTHCODE'  'I_OUTPUT'    'Auth Code' ,
      'DUPLI_PAY'    'I_OUTPUT'   'Double Pay in SAP',
      'SAPDOC'  'I_OUTPUT'    'SAP Doc No'  ,
      'SAPCUST' 'I_OUTPUT'    'SAP Customer No' ,
      'SAPDUPSHEET' 'I_OUTPUT'    'SAP Duplicate Sheet' ,
      'CODE1' 'I_OUTPUT'    'Code1' ,
      'SERVICECODE' 'I_OUTPUT'    'Service Code'  ,
      'AUTH_TRTYPE' 'I_OUTPUT'    'Authorization Transaction Type'  ,
      'PLANCODE'  'I_OUTPUT'    'Plan Code' ,
      'PLANCODE_DESCR'  'I_OUTPUT'    'Plan Code Description' ,
      'DEBITNWID' 'I_OUTPUT'    'Debit Network ID'  ,
      'REJECTREAS'  'I_OUTPUT'    'Reject Reason' ,
      'TRACK_NUMB'  'I_OUTPUT'    'Tracking Number' ,
      'ORDER_NUM' 'I_OUTPUT'    'Order Number'  ,
      'TR_CLASS'  'I_OUTPUT'    'Transaction Integrity Class' ,
      'MOBILE_IND'  'I_OUTPUT'    'Mobile Indicator'  ,
      'ELEC_COMMIND'  'I_OUTPUT'    'Electronic Commerce Indicator' ,
      'DUPLI_PAY'    'I_OUTPUT'   'Duplicate Pay in SAP',
      'NAME1'    'I_OUTPUT'   'Customer Name',
      'EMAIL'    'I_OUTPUT'   'Email ID',
      'LAND1'    'I_OUTPUT'   'Country',
      'TEL_NUMBER'    'I_OUTPUT'   'Telephone',
      'CITY1'    'I_OUTPUT'   'City',
      'STREET'    'I_OUTPUT'   'Street',
      'STR_SUPPL1'    'I_OUTPUT'   'Address1',
      'STR_SUPPL2'    'I_OUTPUT'   'Address2'.



  ELSEIF rb_amx IS NOT INITIAL.
    PERFORM f_build_fcatalog USING:
     'TRDATE' 'I_OUTPUT'  'Transaction date'  ,
'SETTL_DATE'  'I_OUTPUT'  'Settlement date' ,
'MERCH_NUMB'  'I_OUTPUT'  'Submitting merchant number'  ,
'CHARGE_AMT'  'I_OUTPUT'  'Charge amount' ,
'LOC_ID'  'I_OUTPUT'  'Submitting location ID'  ,
'CARD_NUMB' 'I_OUTPUT'  'Card member number'  ,
'ADJ_TYPE'  'I_OUTPUT'  'Adjustment type' ,
'CHARGE_REF'  'I_OUTPUT'  'Charge reference number' ,
'AUTH_TYPE' 'I_OUTPUT'  'Auth Type' ,
'AUTHCODE' 'I_OUTPUT'  'Approval code' ,
'DUPLI_PAY'    'I_OUTPUT'   'Double Pay in SAP',
'TYPE'  'I_OUTPUT'  'Type'  ,

      'NAME1'    'I_OUTPUT'   'Customer Name',
      'EMAIL'    'I_OUTPUT'   'Email ID',
      'LAND1'    'I_OUTPUT'   'Country',
      'TEL_NUMBER'    'I_OUTPUT'   'Telephone',
      'CITY1'    'I_OUTPUT'   'City',
      'STREET'    'I_OUTPUT'   'Street',
      'STR_SUPPL1'    'I_OUTPUT'   'Address1',
      'STR_SUPPL2'    'I_OUTPUT'   'Address2',
      'SAPDOC'  'I_OUTPUT'    'SAP Doc No'  ,
      'SAPCUST' 'I_OUTPUT'    'SAP Customer No' .

  ELSEIF rb_wrk IS NOT INITIAL.

    PERFORM f_build_fcatalog USING:
'ORDERID' 'I_WPAY'  'Order ID'  ,
'SETTYPE' 'I_WPAY'  'Settlement type' ,
'TRDATE'  'I_WPAY'  'Transaction date'  ,
'TSTAMP'  'I_WPAY'  'Timestamp' ,
'SETSTATUS' 'I_WPAY'  'Settlement status' ,
'SETSTREASON' 'I_WPAY'  'Settlement status reason'  ,
'SETDATE' 'I_WPAY'  'Settlement date' ,
'TR_AMT'  'I_WPAY'  'Transaction amount'  ,
'TRAMT_CURR'  'I_WPAY'  'Transaction amount currency' ,
'SET_AMT' 'I_WPAY'  'Settlement amount' ,
'SETAMT_CURR' 'I_WPAY'  'Settlement amount currency'  ,
'TR_SRC'  'I_WPAY'  'Transaction source'  ,
'PAY_METHOD'  'I_WPAY'  'Payment method'  ,
'CARDTYPE'  'I_WPAY'  'Card type' ,
'ACCOUNT' 'I_WPAY'  'Account' ,
'ISSU_BANK' 'I_WPAY'  'Issuing bank'  ,
'BANK_COUNTRY'  'I_WPAY'  'Issuing bank country'  ,
'PROVIDER'  'I_WPAY'  'Provider'  ,
'PROV_PATH' 'I_WPAY'  'Provider path' ,
'TRID'  'I_WPAY'  'Transaction ID'  ,
'ARN' 'I_WPAY'  'ARN' ,
'FUN_TRID'  'I_WPAY'  'Funds transfer ID' ,
'AUTHCODE'  'I_WPAY'  'Auth code' ,
'DUPLI_PAY'    'I_OUTPUT'   'Double Pay in SAP',
'AUTH_METHOD' 'I_WPAY'  'Authentication method' ,
'CVV2'  'I_WPAY'  'CVV2 response code'  ,
'AVS' 'I_WPAY'  'AVS response code' ,
'TERM_TYP'  'I_WPAY'  'Terminal type' ,
'TERMID'  'I_WPAY'  'Terminal ID' ,
'ENTRY_METH'  'I_WPAY'  'Entry method'  ,
'BU_PATH' 'I_WPAY'  'Business unit path'  ,
'COMPID'  'I_WPAY'  'Company ID'  ,
'MID' 'I_WPAY'  'MID' ,
'MCC' 'I_WPAY'  'MCC' ,
'RECP_NUMB' 'I_WPAY'  'Receipt number'  ,
'AL_TICK_NUM' 'I_WPAY'  'Airline ticket number' ,
'FUND_TRGRP'  'I_WPAY'  'Funds transfer group'  ,
'PROV_CVV2' 'I_WPAY'  'Provider CVV2 response code' ,
'PROV_AVS'  'I_WPAY'  'Provider AVS response code'  ,
'STOREID' 'I_WPAY'  'Store ID'  ,
'BILL_DESCR'  'I_WPAY'  'Billing descriptor'  ,
'TERM_COUNTRY'  'I_WPAY'  'Terminal country'  ,
'TERM_CITY' 'I_WPAY'  'Terminal city' ,
'TERMI_MODEL' 'I_WPAY'  'Terminal model'  ,
'IIN' 'I_WPAY'  'IIN' ,
'LAST4' 'I_WPAY'  'Last four' ,
'BANK_ST_NARR'  'I_WPAY'  'Bank statement narrative'  ,
'DIGI_WALL' 'I_WPAY'  'Digital wallet'  ,
'ORD_AMT' 'I_WPAY'  'Order amount'  ,
'ORD_AMT_CURR'  'I_WPAY'  'Order amount currency' ,
'CASHBACK_AMT'  'I_WPAY'  'Cash back amount'  ,
'CASHBACK_CURR' 'I_WPAY'  'Cash back amount currency' ,
'DONA_AMT'  'I_WPAY'  'Donation amount' ,
'DONA_CURR' 'I_WPAY'  'Donation amount currency'  ,
'GRAT_AMT'  'I_WPAY'  'Gratuity amount' ,
'GRAT_AMT_CURR' 'I_WPAY'  'Gratuity amount currency'  ,
'REPOGRP' 'I_WPAY'  'Report group'  ,
'ACCP_DAT'  'I_WPAY'  'Accepted date' ,
'EST_DATE'  'I_WPAY'  'Estimated bank date' ,
'SCH_REFID' 'I_WPAY'  'Scheme reference ID' ,
      'NAME1'    'I_OUTPUT'   'Customer Name',
      'EMAIL'    'I_OUTPUT'   'Email ID',
      'LAND1'    'I_OUTPUT'   'Country',
      'TEL_NUMBER'    'I_OUTPUT'   'Telephone',
      'CITY1'    'I_OUTPUT'   'City',
      'STREET'    'I_OUTPUT'   'Street',
      'STR_SUPPL1'    'I_OUTPUT'   'Address1',
      'STR_SUPPL2'    'I_OUTPUT'   'Address2'.


  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_layout .
  w_layout-colwidth_optimize = 'X'.
  w_layout-zebra             = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0432   text
*      -->P_0433   text
*      -->P_0434   text
*----------------------------------------------------------------------*
FORM f_build_fcatalog  USING fp_field TYPE any
                            fp_tab TYPE any
                            fp_text TYPE any.


  w_fieldcat-fieldname      = fp_field.
  w_fieldcat-tabname        = fp_tab.
  w_fieldcat-seltext_l      = fp_text.


  APPEND w_fieldcat TO i_fieldcat.
  CLEAR w_fieldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUB_CHECK_CLIENTLINE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sub_check_clientline .
  DATA:lv_tbx  TYPE sy-tabix,
       lv_len1 TYPE i,
       lv_len2 TYPE i.

  IF i_client IS NOT INITIAL.
* Get all Documents from BSEGC
    SELECT bukrs,belnr,gjahr,rfzei,ccins,ccnum,datbi,ccname,csour,autwr,
           ccwae,settl,aunum,autra,audat,merch,locid,trmid,ccbtc,cctyp,setra,rtext,kunnr
      FROM bsegc INTO TABLE @DATA(li_bsegc)
      FOR ALL ENTRIES IN @i_client
      WHERE ( aunum = @i_client-authcode OR aunum IN @s_aunum )
        AND audat IN @s_date
        AND gjahr IN @s_gjahr
        AND bukrs IN @s_bukrs
      AND ccnum IN @s_ccnum.


    IF li_bsegc[] IS NOT INITIAL..
      SELECT bukrs ,belnr,gjahr,blart,xblnr FROM bkpf INTO TABLE @DATA(li_bkpf)
        FOR ALL ENTRIES IN @li_bsegc
        WHERE bukrs EQ @li_bsegc-bukrs
         AND belnr EQ @li_bsegc-belnr
          AND gjahr EQ @li_bsegc-gjahr.
      IF sy-subrc EQ 0.
        SORT li_bkpf BY bukrs belnr gjahr.
        DATA(li_bkpf2) = li_bkpf.
        DELETE li_bkpf2 WHERE blart NE 'RV'. " Keep only Billing Bocs

      ENDIF.

*      Get Partners for SAP Documents from VBPA
      SELECT vbeln,posnr,kunnr,parvw,adrnr
        FROM vbpa INTO TABLE @DATA(li_vbpa)
        FOR ALL ENTRIES IN @li_bkpf
        WHERE vbeln = @li_bkpf-xblnr+0(10).
*          AND kunnr = @li_client-sapcust.
      IF sy-subrc EQ 0.
        SORT li_vbpa BY vbeln kunnr parvw.
*    Get Address details of Customer
        SELECT * FROM adrc INTO TABLE @DATA(li_adrc)
          FOR ALL ENTRIES IN @li_vbpa
          WHERE addrnumber = @li_vbpa-adrnr.
        IF sy-subrc EQ 0.
          SORT li_adrc BY addrnumber.
*          Get Email Address of customer
          SELECT addrnumber,persnumber,date_from,consnumber,smtp_addr
               FROM adr6 INTO TABLE @DATA(li_adr6)
            FOR ALL ENTRIES IN @li_adrc
            WHERE addrnumber = @li_adrc-addrnumber.
          IF sy-subrc EQ 0.
            SORT li_adr6 BY addrnumber.
          ENDIF.
        ENDIF.
      ENDIF.
      SORT li_bsegc BY aunum ccnum ccwae kunnr autwr.

      DATA(li_client2) = i_client[].
      SORT li_client2 BY cardnumber .

      LOOP AT i_client INTO DATA(lst_client).
        CLEAR:lv_len1,lv_len2.
        lv_len1 = strlen( lst_client-cardnumber ).
        lv_len1 = lv_len1 - 4.
        IF lst_client-trans_amt CA '(' .
          TRANSLATE lst_client-trans_amt USING '( '.
          CONDENSE  lst_client-trans_amt NO-GAPS.
        ENDIF.
        IF lst_client-trans_amt CA ')' .
          TRANSLATE lst_client-trans_amt USING ') '.
          CONDENSE  lst_client-trans_amt NO-GAPS.
        ENDIF.

        IF lst_client-trans_amt CA ',' .
          TRANSLATE lst_client-trans_amt USING ', '.
          CONDENSE  lst_client-trans_amt NO-GAPS.
        ENDIF.
        MOVE-CORRESPONDING  lst_client TO wa_output.
        READ TABLE li_bsegc INTO DATA(lst_bsegc) WITH KEY aunum = lst_client-authcode BINARY SEARCH.



        IF sy-subrc EQ 0.
          lv_len2 = strlen( lst_bsegc-ccnum ).
          lv_len2 = lv_len2 - 4.
          IF lst_bsegc-ccwae = lst_client-currcode AND lst_bsegc-autwr = lst_client-trans_amt AND
             lst_bsegc-ccnum+lv_len2(4) = lst_client-cardnumber+lv_len1(4).
* if entry found , consider as NOT duplicate
            wa_output-dupli_pay = 'No'.
          ELSE.
*    if entry not found , consider as DUPLICATE and pull BP details from prev successful entry
            wa_output-dupli_pay = 'Yes'.
* For customer details, read from prev success cardnumber associated details
            READ TABLE i_output INTO DATA(lst_op2) WITH KEY cardnumber = lst_client-cardnumber BINARY SEARCH.
            IF sy-subrc EQ 0.
              wa_output-sapcust = lst_op2-sapcust.
              lst_client-sapdoc = lst_op2-sapdoc.
            ELSE.
              wa_output-dupli_pay = 'Re-Check'.
            ENDIF.


          ENDIF.
        ELSE.
          wa_output-dupli_pay = 'Yes'.

        ENDIF.
* Get Customer communication info
        READ TABLE li_bkpf INTO DATA(lst_bkpf) WITH KEY bukrs = lst_bsegc-bukrs belnr = lst_bsegc-belnr gjahr = lst_bsegc-gjahr BINARY SEARCH.
        IF sy-subrc EQ 0.
          READ TABLE li_vbpa INTO DATA(lst_vbpa) WITH KEY vbeln = lst_client-sapdoc kunnr = lst_bkpf-xblnr+0(10) parvw = 'SP' BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = lst_vbpa-adrnr BINARY SEARCH.
            IF sy-subrc EQ 0.
              MOVE-CORRESPONDING lst_adrc TO wa_output.
              READ TABLE li_adr6 INTO DATA(lst_adr6) WITH KEY addrnumber = lst_adrc-addrnumber BINARY SEARCH.
              IF sy-subrc EQ 0.
                wa_output-email = lst_adr6-smtp_addr.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        APPEND wa_output TO i_output.
        CLEAR:wa_output,lst_client.
      ENDLOOP.

    ENDIF.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUB_CHECK_AMEX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sub_check_amex .
  DATA:lv_tbx  TYPE sy-tabix,
       lv_len1 TYPE i,
       lv_len2 TYPE i.

  IF i_amex IS NOT INITIAL.
* Get all Documents from BSEGC
    SELECT bukrs,belnr,gjahr,rfzei,ccins,ccnum,datbi,ccname,csour,autwr,
           ccwae,settl,aunum,autra,audat,merch,locid,trmid,ccbtc,cctyp,setra,rtext,kunnr
      FROM bsegc INTO TABLE @DATA(li_bsegc)
      FOR ALL ENTRIES IN @i_amex
      WHERE ( aunum = @i_amex-authcode OR aunum IN @s_aunum )
        AND audat IN @s_date
        AND gjahr IN @s_gjahr
        AND bukrs IN @s_bukrs
      AND ( ccnum IN @s_ccnum  ).

    IF sy-subrc EQ 0.

      SELECT bukrs ,belnr,gjahr,blart,xblnr FROM bkpf INTO TABLE @DATA(li_bkpf)
      FOR ALL ENTRIES IN @li_bsegc
      WHERE bukrs EQ @li_bsegc-bukrs
       AND belnr EQ @li_bsegc-belnr
        AND gjahr EQ @li_bsegc-gjahr.
      IF sy-subrc EQ 0.
        SORT li_bkpf BY bukrs belnr gjahr.
*        DATA(li_bkpf2) = li_bkpf.
*        DELETE li_bkpf2 WHERE blart NE 'RV'. " Keep only Billing Bocs

      ENDIF.
*      Get Partners for SAP Documents from VBPA
      SELECT vbeln,posnr,kunnr,parvw,adrnr
        FROM vbpa INTO TABLE @DATA(li_vbpa)
        FOR ALL ENTRIES IN @li_bkpf
        WHERE vbeln = @li_bkpf-xblnr+0(10).
*          AND kunnr = @i_client-sapcust.
      IF sy-subrc EQ 0.
        SORT li_vbpa BY vbeln kunnr parvw.
*    Get Address details of Customer
        SELECT * FROM adrc INTO TABLE @DATA(li_adrc)
          FOR ALL ENTRIES IN @li_vbpa
          WHERE addrnumber = @li_vbpa-adrnr.
        IF sy-subrc EQ 0.
          SORT li_adrc BY addrnumber.
*          Get Email Address of customer
          SELECT addrnumber,persnumber,date_from,consnumber,smtp_addr
               FROM adr6 INTO TABLE @DATA(li_adr6)
            FOR ALL ENTRIES IN @li_adrc
            WHERE addrnumber = @li_adrc-addrnumber.
          IF sy-subrc EQ 0.
            SORT li_adr6 BY addrnumber.
          ENDIF.
        ENDIF.
      ENDIF.
      SORT li_bsegc BY aunum ccnum ccwae kunnr autwr.

      DATA(li_amex2) = i_amex[].
      SORT li_amex2 BY cardnumber .

      LOOP AT i_amex INTO DATA(lst_amex).
        CLEAR:lv_len1,lv_len2.
        lv_len1 = strlen( lst_amex-cardnumber ).
        lv_len1 = lv_len1 - 4.
        IF lst_amex-trans_amt CA '(' .
          TRANSLATE lst_amex-trans_amt USING '( '.
          CONDENSE  lst_amex-trans_amt NO-GAPS.
        ENDIF.
        IF lst_amex-trans_amt CA ')' .
          TRANSLATE lst_amex-trans_amt USING ') '.
          CONDENSE  lst_amex-trans_amt NO-GAPS.
        ENDIF.

        IF lst_amex-trans_amt CA ',' .
          TRANSLATE lst_amex-trans_amt USING ', '.
          CONDENSE  lst_amex-trans_amt NO-GAPS.
        ENDIF.

        IF lst_amex-trans_amt CA '$' .
          TRANSLATE lst_amex-trans_amt USING '$ '.
          CONDENSE  lst_amex-trans_amt NO-GAPS.
        ENDIF.
        MOVE-CORRESPONDING  lst_amex TO wa_output.
        READ TABLE li_bsegc INTO DATA(lst_bsegc) WITH KEY aunum = lst_amex-authcode BINARY SEARCH.
        IF sy-subrc EQ 0.
          lv_len2 = strlen( lst_bsegc-ccnum ).
          lv_len2 = lv_len2 - 4.
          IF  lst_bsegc-autwr = lst_amex-trans_amt AND    "lst_bsegc-ccwae = lst_amex-currcode AND
             lst_bsegc-ccnum+lv_len2(4) = lst_amex-cardnumber+lv_len1(4).
* if entry found , consider as NOT duplicate
            wa_output-dupli_pay = 'No'.
          ELSE.
*    if entry not found , consider as DUPLICATE and pull BP details from prev successful entry
            wa_output-dupli_pay = 'Yes'.
* For customer details, read from prev success cardnumber associated details
            READ TABLE i_output INTO DATA(lst_op2) WITH KEY cardnumber = lst_amex-cardnumber BINARY SEARCH.
            IF sy-subrc EQ 0.
              wa_output-sapcust = lst_op2-sapcust.
              wa_output-sapdoc = lst_op2-sapdoc.

            ELSE.
              wa_output-dupli_pay = 'Re-Check'.
            ENDIF.


          ENDIF.
        ELSE.
          wa_output-dupli_pay = 'Yes'.

        ENDIF.
* Get Customer communication info
        READ TABLE li_bkpf INTO DATA(lst_bkpf) WITH KEY bukrs = lst_bsegc-bukrs belnr = lst_bsegc-belnr gjahr = lst_bsegc-gjahr BINARY SEARCH.
        IF sy-subrc EQ 0.
          wa_output-sapdoc = lst_bkpf-xblnr+0(10).
          READ TABLE li_vbpa INTO DATA(lst_vbpa) WITH KEY vbeln = wa_output-sapdoc  parvw = 'SP' BINARY SEARCH.
          IF sy-subrc EQ 0.
            wa_output-sapcust = lst_vbpa-kunnr.
            READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = lst_vbpa-adrnr BINARY SEARCH.
            IF sy-subrc EQ 0.
              MOVE-CORRESPONDING lst_adrc TO wa_output.
              READ TABLE li_adr6 INTO DATA(lst_adr6) WITH KEY addrnumber = lst_adrc-addrnumber BINARY SEARCH.
              IF sy-subrc EQ 0.
                wa_output-email = lst_adr6-smtp_addr.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        APPEND wa_output TO i_output.
        CLEAR:wa_output.
      ENDLOOP.

    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUB_CHECK_WORLDPAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sub_check_worldpay .
  DATA:lv_tbx  TYPE sy-tabix,
       lv_len1 TYPE i,
       lv_len2 TYPE i.

  IF i_wpay IS NOT INITIAL.
* Get all Documents from BSEGC
    SELECT bukrs,belnr,gjahr,rfzei,ccins,ccnum,datbi,ccname,csour,autwr,
           ccwae,settl,aunum,autra,audat,merch,locid,trmid,ccbtc,cctyp,setra,rtext,kunnr
      FROM bsegc INTO TABLE @DATA(li_bsegc)
      FOR ALL ENTRIES IN @i_wpay
      WHERE ( aunum = @i_wpay-authcode OR aunum IN @s_aunum )
        AND audat IN @s_date
        AND gjahr IN @s_gjahr
        AND bukrs IN @s_bukrs
      AND ccnum IN @s_ccnum.

    IF sy-subrc EQ 0.
      SELECT bukrs ,belnr,gjahr,blart,xblnr FROM bkpf INTO TABLE @DATA(li_bkpf)
FOR ALL ENTRIES IN @li_bsegc
WHERE bukrs EQ @li_bsegc-bukrs
 AND belnr EQ @li_bsegc-belnr
  AND gjahr EQ @li_bsegc-gjahr.
      IF sy-subrc EQ 0.
        SORT li_bkpf BY bukrs belnr gjahr.

*            Get Partners for SAP Documents from VBPA
        SELECT vbeln,posnr,kunnr,parvw,adrnr
          FROM vbpa INTO TABLE @DATA(li_vbpa)
          FOR ALL ENTRIES IN @li_bkpf
          WHERE vbeln = @li_bkpf-xblnr+0(10).

        IF sy-subrc EQ 0.
          SORT li_vbpa BY vbeln kunnr parvw.
*    Get Address details of Customer
          SELECT * FROM adrc INTO TABLE @DATA(li_adrc)
            FOR ALL ENTRIES IN @li_vbpa
            WHERE addrnumber = @li_vbpa-adrnr.
          IF sy-subrc EQ 0.
            SORT li_adrc BY addrnumber.
*          Get Email Address of customer
            SELECT addrnumber,persnumber,date_from,consnumber,smtp_addr
                 FROM adr6 INTO TABLE @DATA(li_adr6)
              FOR ALL ENTRIES IN @li_adrc
              WHERE addrnumber = @li_adrc-addrnumber.
            IF sy-subrc EQ 0.
              SORT li_adr6 BY addrnumber.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
      SORT li_bsegc BY aunum ccnum ccwae kunnr autwr.

      DATA(li_wpay2) = i_wpay[].
      SORT li_wpay2 BY cardnumber .

      LOOP AT i_wpay INTO DATA(lst_wpay).
        CLEAR:lv_len1,lv_len2.
        lv_len1 = strlen( lst_wpay-cardnumber ).
        lv_len1 = lv_len1 - 4.
        IF lst_wpay-trans_amt CA '(' .
          TRANSLATE lst_wpay-trans_amt USING '( '.
          CONDENSE  lst_wpay-trans_amt NO-GAPS.
        ENDIF.
        IF lst_wpay-trans_amt CA ')' .
          TRANSLATE lst_wpay-trans_amt USING ') '.
          CONDENSE  lst_wpay-trans_amt NO-GAPS.
        ENDIF.

        IF lst_wpay-trans_amt CA ',' .
          TRANSLATE lst_wpay-trans_amt USING ', '.
          CONDENSE  lst_wpay-trans_amt NO-GAPS.
        ENDIF.
        MOVE-CORRESPONDING  lst_wpay TO wa_output.
        READ TABLE li_bsegc INTO DATA(lst_bsegc) WITH KEY aunum = lst_wpay-authcode BINARY SEARCH.



        IF sy-subrc EQ 0.
          lv_len2 = strlen( lst_bsegc-ccnum ).
          lv_len2 = lv_len2 - 4.
          IF lst_bsegc-ccwae = lst_wpay-currcode AND lst_bsegc-autwr = lst_wpay-trans_amt AND
             lst_bsegc-ccnum+lv_len2(4) = lst_wpay-cardnumber+lv_len1(4).
* if entry found , consider as NOT duplicate
            wa_output-dupli_pay = 'No'.
          ELSE.
*    if entry not found , consider as DUPLICATE and pull BP details from prev successful entry
            wa_output-dupli_pay = 'Yes'.
* For customer details, read from prev success cardnumber associated details
            READ TABLE i_output INTO DATA(lst_op2) WITH KEY cardnumber = lst_wpay-cardnumber BINARY SEARCH.
            IF sy-subrc EQ 0.
              wa_output-sapcust = lst_op2-sapcust.
              wa_output-sapdoc = lst_op2-sapdoc.

            ELSE.
              wa_output-dupli_pay = 'Re-Check'.
            ENDIF.


          ENDIF.
        ELSE.
          wa_output-dupli_pay = 'Yes'.

        ENDIF.
* Get Customer communication info
*         Get Customer communication info
        READ TABLE li_bkpf INTO DATA(lst_bkpf) WITH KEY bukrs = lst_bsegc-bukrs belnr = lst_bsegc-belnr gjahr = lst_bsegc-gjahr BINARY SEARCH.
        IF sy-subrc EQ 0.
          wa_output-sapdoc = lst_bkpf-xblnr+0(10).
          READ TABLE li_vbpa INTO DATA(lst_vbpa) WITH KEY vbeln = wa_output-sapdoc  parvw = 'SP' BINARY SEARCH.
          IF sy-subrc EQ 0.
            wa_output-sapcust = lst_vbpa-kunnr.
            READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = lst_vbpa-adrnr BINARY SEARCH.
            IF sy-subrc EQ 0.
              MOVE-CORRESPONDING lst_adrc TO wa_output.
              READ TABLE li_adr6 INTO DATA(lst_adr6) WITH KEY addrnumber = lst_adrc-addrnumber BINARY SEARCH.
              IF sy-subrc EQ 0.
                wa_output-email = lst_adr6-smtp_addr.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        APPEND wa_output TO i_output.
        CLEAR:wa_output,lst_wpay.
      ENDLOOP.

    ENDIF.

  ENDIF.
ENDFORM.
