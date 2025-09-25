*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_ENTITLEMENT_STATUS_I0318
* PROGRAM DESCRIPTION: FM to update Entitlement Status
* DEVELOPER: Paramita Bose
* CREATION DATE: 12/09/2016
* OBJECT ID: I0318
* TRANSPORT NUMBER(S): ED2K903833
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906508
* REFERENCE NO: CR#534
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE: 05-Jun-2017
* DESCRIPTION: To include subscription number also as part of the selection
* along with the fulfillment line item id.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K906768
* REFERENCE NO: JIRA Defect ERP-2837
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 16-Jun-2017
* DESCRIPTION: Added application logs to make sure we will have a tracking.
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910736
* REFERENCE NO: ERP-6918
* DEVELOPER: Himanshu Patel
* DATE: 02/09/2018
* DESCRIPTION: New FM added ZQTC_ENTITLEMENT_IDOC_I0318 in same Function
*              group which will be process Idoc for Subscription Order change
*              so all subroutine added in this include
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_POP_ITEM_DATA
*&---------------------------------------------------------------------*
* Perform to populate item data.
*----------------------------------------------------------------------*
*      -->FP_LST_VBAP  Item data structure
*      <--FP_CONTRACT  Contract data
*      <--FP_COND_IND  Contract data indicator
*----------------------------------------------------------------------*
FORM f_pop_item_data  USING    fp_lst_vbap TYPE ty_vbap      " Item data structure
                      CHANGING fp_contract TYPE tt_contract  " Contract data
                               fp_cond_ind TYPE tt_cond_ind. " Communication Fields: Sales and Distribution Document Item

* Data declaration
  DATA : lst_contract TYPE bapisditm,  " Communication Fields: Sales and Distribution Document Item
         lst_cond_ind TYPE bapisditmx. " Communication Fields: Sales and Distribution Document Item

* Fill Item data
  lst_contract-itm_number = fp_lst_vbap-posnr. " Item Number
  lst_contract-material   = fp_lst_vbap-matnr. " Material Number
  lst_contract-target_qty = fp_lst_vbap-zmeng. " Quantity
  lst_contract-item_categ = fp_lst_vbap-pstyv. " Item Category
  APPEND lst_contract TO fp_contract.
  CLEAR lst_contract.

* Fill Item Index.
  lst_cond_ind-itm_number = fp_lst_vbap-posnr. " Item Number
  lst_cond_ind-updateflag = c_upd. " Updation Flag
  lst_cond_ind-material   = abap_true. " X
  lst_cond_ind-target_qty = abap_true. " X
  lst_cond_ind-item_categ = abap_true. " X
  APPEND lst_cond_ind TO fp_cond_ind.
  CLEAR lst_cond_ind.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POP_AGREEMENT_DATE
*&---------------------------------------------------------------------*
* Subroutine to get agrrement date
*----------------------------------------------------------------------*
*      -->FP_LST_VEDA               Structure to get Item number
*      -->FP_LST_ENT_STATUS_DUMMY   Structure for Entitlement status
*      <--FP_AGR_DATE               Agreement date
*      <--FP_AGR_DATE_IND           Agreement date indicator
*
*----------------------------------------------------------------------*
FORM f_pop_agreement_date  USING    fp_lst_vbap             TYPE ty_vbap           " Structure to get Item number
                                    fp_lst_ent_status_dummy TYPE ty_entitle_status " Import Structure for Entitlement status
                           CHANGING fp_agr_date             TYPE tt_agr_date       " Agreement date
                                    fp_agr_date_ind         TYPE tt_agr_date_ind.  " Agreement date indicator

* Data Declaration
  DATA : lst_bapictr  TYPE bapictr,  " Communciation Fields: SD Contract Data
         lst_bapictrx TYPE bapictrx. " Communication fields: SD Contract Data Checkbox

* Fill Agreement acceptance date in contract data field.
  lst_bapictr-itm_number = fp_lst_vbap-posnr. " Item Number
  lst_bapictr-accept_dat = fp_lst_ent_status_dummy-licence_start_date. " Acceptance date
  APPEND lst_bapictr TO fp_agr_date.
  CLEAR lst_bapictr.

* Fill value for Item
  lst_bapictrx-itm_number = fp_lst_vbap-posnr. " Item Number
  lst_bapictrx-updateflag = c_upd. " Updation Flag
  lst_bapictrx-accept_dat = abap_true. " X
  APPEND lst_bapictrx TO fp_agr_date_ind.
  CLEAR lst_bapictrx.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POP_UPDATE_TEXT
*&---------------------------------------------------------------------*
*  Subroutine to update text
*----------------------------------------------------------------------*
*      -->FP_LST_ENT_STATUS_DUMMY  Import Structure for Entitlement status
*      -->FP_LST_VBKD              Structure to get Sales Doc No
*      <--FP_TEXT                  Structure for customer ID text
*----------------------------------------------------------------------*
FORM f_pop_update_text  USING    fp_lst_ent_status_dummy TYPE ty_entitle_status " Import Structure for Entitlement status
                                 fp_lst_vbkd             TYPE ty_vbkd           " Structure to get Sales Doc No
                        CHANGING fp_text                 TYPE tt_text.          " Structure for customer ID text

* Data Declaration
  DATA : li_lines       TYPE TABLE OF tline,
         lv_rtxt_name   TYPE tdobname,
         lst_bapisdtext TYPE bapisdtext. " Communication fields: SD texts

  REFRESH li_lines.

  CONCATENATE fp_lst_vbkd-vbeln fp_lst_vbkd-posnr INTO lv_rtxt_name.

* To check if text already exists or not and if it exists then we don't need to update
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_textid      " Text ID
      language                = sy-langu
      name                    = lv_rtxt_name
      object                  = c_tdobj_vbbp
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.

  IF li_lines[] IS INITIAL.

* Fill Details to update text
    lst_bapisdtext-doc_number = fp_lst_vbkd-vbeln. " Sales doc number
    lst_bapisdtext-itm_number = fp_lst_vbkd-posnr. " Item Number
    lst_bapisdtext-text_id    = c_textid. " Text ID
    lst_bapisdtext-langu      = sy-langu. " Language Key
    lst_bapisdtext-text_line  = fp_lst_ent_status_dummy-customer_id. " Customer ID
    lst_bapisdtext-function   = c_func. " Function
    APPEND lst_bapisdtext TO fp_text.
    CLEAR lst_bapisdtext.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POP_SALES_DATA
*&---------------------------------------------------------------------*
* Populate Header data related to sales
*----------------------------------------------------------------------*
*      -->FP_LST_VBAK         Item Header structure
*      -->FP_GST_HEADER_DATA  Communication Fields: SD Order Header
*      -->FP_GST_HEADER_IND   Checkbox List: SD Order Header
*----------------------------------------------------------------------*
FORM f_pop_sales_data  USING  fp_lst_vbak        TYPE ty_vbak    " Item Header structure
                     CHANGING fp_gst_header_data TYPE bapisdh1   " Communication Fields: SD Order Header
                              fp_gst_header_ind  TYPE bapisdh1x. " Checkbox List: SD Order Header

*   Fill value for contract header data.
  fp_gst_header_data-sales_org  = fp_lst_vbak-vkorg. " Sales Organization
  fp_gst_header_data-distr_chan = fp_lst_vbak-vtweg. " Distribution Channel
  fp_gst_header_data-division   = fp_lst_vbak-spart. " Division

*   Fill value for Update flag
  fp_gst_header_ind-updateflag = c_upd. " Updation Flag
  fp_gst_header_ind-sales_org  = abap_true. " X
  fp_gst_header_ind-distr_chan = abap_true. " X
  fp_gst_header_ind-division   = abap_true. " X

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_SUBSCRPT_ORD
*&---------------------------------------------------------------------*
*  Subroutine to update contract data by calling BAPI
*----------------------------------------------------------------------*
*      -->FP_GST_HEADER_DATA        Header Data
*      -->FP_LST_VBKD               Structure to get Sales Doc No
*      -->FP_GST_HEADER_IND         Indicator for setting flag in header
*      -->FP_CONTRACT               Structure for contract data
*      -->FP_COND_IND               Indicator for setting flag in contract
*      -->FP_AGR_DATE_IND           Indicator for setting flag agreement date
*      -->FP_AGR_DATE               Structure for agreement date
*      -->FP_TEXT                   Structure for customer ID text
*----------------------------------------------------------------------*
FORM f_update_subscrpt_ord  USING   fp_gst_header_data      TYPE bapisdh1          " Communication Fields: SD Order Header
                                    fp_lst_vbkd             TYPE ty_vbkd           " Sales Doc Number
                                    fp_gst_header_ind       TYPE bapisdh1x         " Checkbox List: SD Order Header
                                    fp_contract             TYPE tt_contract       " Contract data
                                    fp_cond_ind             TYPE tt_cond_ind       " Contract data indicator
                                    fp_agr_date_ind         TYPE tt_agr_date_ind   " Agreement date indicator
                                    fp_agr_date             TYPE tt_agr_date       " Agreement date
                                    fp_text                 TYPE tt_text           " Text data
                                    fp_entitle_status       TYPE tt_entitle_status " Entitle data  "+<HIPATEL> <ERP-6918> <02/12/2018>
                                    fp_im_err_idoc          TYPE errhandle         " Flag for Idoc Generation +<HIPATEL> <ERP-6918> <02/12/2018>
                          CHANGING  fp_ex_t_return_msg      TYPE bapiret2_t.       " Return message

* Data declaration
  DATA : lv_msg_type        TYPE bapi_mtype,                                " Message Type: S/E
         lst_return         TYPE bapiret2,                                  " Return Parameter
         fp_return          TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0, " Return Parameter
         lv_order           TYPE char15,                                    " Order of type CHAR15
         lv_subs_no         TYPE string,                                    " Subscription Number
         lv_msgno           TYPE symsgno,                                   " Message Number
         lv_idocnum         TYPE string,                                    " Generated Idoc number "+ <HIPATEL> <ERP-6918>
         fp_return_idoc_msg TYPE STANDARD TABLE OF bapiret2,                " Return Idoc Table     "+ <HIPATEL> <ERP-6918>
         lst_msg_ret        TYPE bapiret2.                                  " Return Parameter      "+ <HIPATEL> <ERP-6918>

* Begin of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
  CLEAR lv_subs_no.
  lv_subs_no = fp_lst_vbkd-vbeln.
* End of Change by PBANDLAPAL on 06/16/2017 for ERP-2837

* Call BAPI to update the Acceptance Date and customer ID
  CALL FUNCTION 'BAPI_CUSTOMERCONTRACT_CHANGE'
    EXPORTING
      salesdocument       = fp_lst_vbkd-vbeln  " Document Number
      contract_header_in  = fp_gst_header_data " Header Data
      contract_header_inx = fp_gst_header_ind  " Header data update Indicator
    TABLES
      return              = fp_return          " Return table
      contract_item_in    = fp_contract        " Contract Data table
      contract_item_inx   = fp_cond_ind        " Contract Data indicator table
      contract_text       = fp_text            " Text table
      contract_data_in    = fp_agr_date        " Agreement data table
      contract_data_inx   = fp_agr_date_ind.   " Agreement data indicator table


  SORT fp_return BY type.

  READ TABLE fp_return INTO lst_return WITH KEY type = c_err " Return into lst_ of type
                                       BINARY SEARCH.
  IF sy-subrc IS NOT INITIAL.
    READ TABLE fp_return INTO lst_return WITH KEY type = c_abt " Return into lst_ of type
                                      BINARY SEARCH.
    IF sy-subrc IS INITIAL.
*    Rollback the changes if error occurs
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

*     Populate error message if BAPI fails

      PERFORM f_populate_return_message USING   fp_return
                                     CHANGING   fp_ex_t_return_msg.

*Start insert by <HIPATEL> <ERP-6918> <ED2K910736/ED2K911423> <02/08/2018>
*If update fails - generate Idoc to be processed later
      IF fp_im_err_idoc = space.              "Generate Idoc only if processing through RFC
        PERFORM f_idoc_generate USING fp_lst_vbkd
                                      fp_agr_date
                                      fp_text
                                      fp_entitle_status
                             CHANGING fp_return_idoc_msg
                                      lv_idocnum.
      ENDIF.  "IF fp_im_err_idoc = space.

      IF NOT lv_idocnum IS INITIAL.
*  Add Idoc Number in BAPI return parameter
        lst_msg_ret-type = c_err.                                           "Message Type
        lst_msg_ret-id   = c_msg_cls.                                       "Message Class - ZQTC_R2
        lst_msg_ret-number = c_msgno_000.                                   "Message Number
        CONCATENATE 'IDOC:('(t14) lv_idocnum') has been created to process within SAP '(t15)
                    INTO lst_msg_ret-message SEPARATED BY space.
        lst_msg_ret-message_v1 = lv_subs_no.                                ""Message Variable 1
        lst_msg_ret-message_v2 = lv_idocnum.                                ""Message Variable 2
*      lst_msg_ret-message_v3 = lst_return-message_v3.
*      lst_msg_ret-message_v4 = lst_return-message_v4.
        APPEND lst_msg_ret TO fp_ex_t_return_msg.
        CLEAR lst_msg_ret.

*  Idoc number details with error log
        PERFORM f_log_add USING c_err                                         "Message Type
                                c_msgno_000                                   "Message Number
                                'Update Failed for Subscription Order '(t06)  "Message Variable 1
                                lv_subs_no                                    "Message Variable 2
                                ', IDoc has been created '(t13)               "Message Variable 3
                                lv_idocnum.                                   "Message Variable 4
      ELSE.
*End insert by <HIPATEL> <ERP-6918> <ED2K910736/ED2K911423> <02/08/2018>

*  Begin of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
        PERFORM f_log_add USING c_err                                         "Message Type
                                c_msgno_000                                   "Message Number
                                'Update Failed for Subscription Order '(t06)  "Message Variable 1
                                lv_subs_no                                    "Message Variable 2
                                space                                         "Message Variable 3
                                space.                                        "Message Variable 4
*  End of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
      ENDIF.  "IF not lv_idocnum is INITIAL.
*End insert by <HIPATEL> <ERP-6918> <ED2K910736> <02/08/2018>
    ELSE. " ELSE -> IF sy-subrc IS INITIAL

*   Commit work done to save the updated values in the contract data.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

*   Populate success message after saving the updation
      CLEAR : lv_msg_type,
              lv_msgno.
      lv_msg_type = c_suc.
      lv_order = fp_lst_vbkd-vbeln.
      lv_msgno    = c_060.
      PERFORM f_populate_message USING   lv_msg_type
                                         lv_order
                                         lv_msgno
                               CHANGING  fp_ex_t_return_msg.

* Begin of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
      PERFORM f_log_add USING c_suc                              "Message Type
                              c_msgno_000                        "Message Number
                              'Data has been successfully updated for '(t07) "Message Variable 1
                              'Subscription Order '(t08)         "Message Variable 2
                              lv_subs_no                         "Message Variable 3
                              space.                             "Message Variable 4
* End of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
    ENDIF. " IF sy-subrc IS INITIAL
  ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
*   Rollback the changes if error occurs
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    PERFORM f_populate_return_message USING   fp_return
                                   CHANGING   fp_ex_t_return_msg.

*Start insert by <HIPATEL> <ERP-6918> <ED2K910736/ED2K911423> <02/08/2018>
*If update fails - generate Idoc to be processed later
    IF fp_im_err_idoc = space.              "Generate Idoc only if processing through RFC
      PERFORM f_idoc_generate USING fp_lst_vbkd
                                    fp_agr_date
                                    fp_text
                                    fp_entitle_status
                           CHANGING fp_return_idoc_msg
                                    lv_idocnum.
    ENDIF.  "IF fp_im_err_idoc = space.

    IF NOT lv_idocnum IS INITIAL.
*  Add Idoc Number in BAPI return parameter
      lst_msg_ret-type = c_err.                                           "Message Type
      lst_msg_ret-id   = c_msg_cls.                                       "Message Class - ZQTC_R2
      lst_msg_ret-number = c_msgno_000.                                   "Message Number
      CONCATENATE 'IDOC:('(t14) lv_idocnum') has been created to process within SAP '(t15)
                  INTO lst_msg_ret-message SEPARATED BY space.
      lst_msg_ret-message_v1 = lv_subs_no.                                ""Message Variable 1
      lst_msg_ret-message_v2 = lv_idocnum.                                ""Message Variable 2
*      lst_msg_ret-message_v3 = lst_return-message_v3.
*      lst_msg_ret-message_v4 = lst_return-message_v4.
      APPEND lst_msg_ret TO fp_ex_t_return_msg.
      CLEAR lst_msg_ret.

*  Idoc number details with error log
      PERFORM f_log_add USING c_err                                         "Message Type
                              c_msgno_000                                   "Message Number
                              'Update Failed for Subscription Order '(t06)  "Message Variable 1
                              lv_subs_no                                    "Message Variable 2
                              ', IDoc has been created '(t13)               "Message Variable 3
                              lv_idocnum.                                   "Message Variable 4
    ELSE.
*End insert by <HIPATEL> <ERP-6918> <ED2K910736/ED2K911423> <02/08/2018>

*  Begin of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
      PERFORM f_log_add USING c_err                                         "Message Type
                              c_msgno_000                                   "Message Number
                              'Update Failed for Subscription Order '(t06)  "Message Variable 1
                              lv_subs_no                                    "Message Variable 2
                              space                                         "Message Variable 3
                              space.                                        "Message Variable 4
*  End of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
    ENDIF.  "IF not lv_idocnum is INITIAL.
  ENDIF. " IF sy-subrc IS NOT INITIAL

ENDFORM.
*&      Form  F_POPULATE_MESSAGE
*&---------------------------------------------------------------------*
* Populate error or success messages
*----------------------------------------------------------------------*
*      -->FP_MSG_TYPE         Message Type (Success/Error)
*      -->FP_MSGNO            Message Number
*      <--FP_EX_T_RETURN_MSG  Message return table
*----------------------------------------------------------------------*
FORM f_populate_message  USING    fp_msg_type        TYPE symsgty     " Message Type
                                  fp_number          TYPE char15      " Number of type CHAR15
                                  fp_msgno           TYPE symsgno     " Message Number
                         CHANGING fp_ex_t_return_msg TYPE bapiret2_t. " Return Message

* Local Work area & variable declaration
  DATA : lst_return TYPE bapiret2, " Return Parameter
         lv_string  TYPE string.   " Variable to store the return message text

* Constant declaration
  CONSTANTS : lc_msg_cls TYPE symsgid VALUE 'ZQTC_R2'. " Message_class 'ZQTC_R2'

* Fill details needed to populate error or success message
  lst_return-type    =  fp_msg_type. " 'S' /'E'
  lst_return-id      =  lc_msg_cls. " Message class
  lst_return-number  =  fp_msgno. "060' or '024' or '065'.
  CLEAR lv_string.

* Call FM to form message to display while updation is successful or errorneous.
  CALL FUNCTION 'FORMAT_MESSAGE'
    EXPORTING
      id        = lst_return-id     " Message ID
      lang      = sy-langu          " System Language
      no        = lst_return-number " Message Number
    IMPORTING
      msg       = lv_string         " Output Variable
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.
  IF sy-subrc IS NOT INITIAL.
    CLEAR lv_string.
* Implement suitable error handling here

  ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
    CONCATENATE lv_string fp_number INTO lv_string SEPARATED BY space.
    lst_return-message = lv_string.
  ENDIF. " IF sy-subrc IS NOT INITIAL

  APPEND lst_return TO fp_ex_t_return_msg.
  CLEAR  lst_return.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_RETURN_MESSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_MSG_TYPE  text
*      -->P_LV_MSGNO  text
*      <--P_FP_EX_T_RETURN_MSG  text
*----------------------------------------------------------------------*
FORM f_populate_return_message  USING    fp_return            TYPE tt_return
                                CHANGING fp_ex_t_return_msg TYPE bapiret2_t. " Return Message.

* Local Work area & variable declaration
  DATA : lst_return  TYPE bapiret2, " Return Parameter
         lst_msg_ret TYPE bapiret2. " Return Parameter


  LOOP AT fp_return INTO lst_return.
    lst_msg_ret-type = lst_return-type.
    lst_msg_ret-id   = lst_return-id.
    lst_msg_ret-number = lst_return-number.
    lst_msg_ret-message = lst_return-message.
    lst_msg_ret-message_v1 = lst_return-message_v1.
    lst_msg_ret-message_v2 = lst_return-message_v2.
    lst_msg_ret-message_v3 = lst_return-message_v3.
    lst_msg_ret-message_v4 = lst_return-message_v4.
    APPEND lst_msg_ret TO fp_ex_t_return_msg.
    CLEAR lst_msg_ret.

  ENDLOOP. " LOOP AT fp_return INTO lst_return


ENDFORM.
* Begin of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
*&---------------------------------------------------------------------*
*&      Form  F_LOG_CREATE_AND_ADD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_log_create_and_add  USING      fp_im_subs_num    TYPE vbeln
                                      fp_im_ent_status  TYPE ztqtc_entitlemnt_stat.

  DATA: lst_log        TYPE bal_s_log,
        lv_msg1        TYPE string,
        lv_msg2        TYPE string,
        lv_msg3        TYPE string,
        lv_msg4        TYPE string,
        lst_ent_status TYPE zstqtc_ent_stat.

* Define some header data of this log
  lst_log-extnumber  = fp_im_subs_num.                             "Application Log: External ID
  lst_log-object     = c_bal_objnm.                             "Application Log: Object Name (ZQTC)
  lst_log-subobject  = c_bal_subobjnm.                          "Application Log: Subobject ()
  lst_log-aldate     = sy-datum.                                "Application log: Date
  lst_log-altime     = sy-uzeit.                                "Application log: Time
  lst_log-aluser     = sy-uname.                                "Application log: User name
  lst_log-alprog     = sy-repid.                                "Application log: Program name

* Application Log: Log: Create with Header Data
  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = lst_log                         "Log header data
    IMPORTING
      e_log_handle            = v_log_handle                "Application Log: Log Handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc NE 0.
    CLEAR: v_log_handle.
  ENDIF. " IF sy-subrc <> 0

  lv_msg1 = 'Input Subscription Order is -'(t05).
  lv_msg2 = fp_im_subs_num.

  PERFORM f_log_add USING c_inf                              "Message Type - (I)Info
                          c_msgno_000                        "Message Number - 000
                          lv_msg1                            "Message Variable 1
                          lv_msg2                            "Message Variable 2
                          space                              "Message Variable 3
                          space.                             "Message Variable 4

  LOOP AT fp_im_ent_status INTO lst_ent_status.

*   Add message to Application Log - Fulfilment data

    lv_msg1 = 'Input for Fulfilment Items'(t01).
    CONCATENATE 'FULFILLMENT_ID is -'(t02) lst_ent_status-fulfillment_id INTO lv_msg2.
    CONCATENATE 'CUSTOMER_ID is -'(t03) lst_ent_status-customer_id INTO lv_msg3.
    CONCATENATE 'LICENCE_START_DATE is - '(t04) lst_ent_status-licence_start_date INTO lv_msg4.

    PERFORM f_log_add USING c_inf                              "Message Type - (I)Info
                            c_msgno_000                        "Message Number - 000
                            lv_msg1                            "Message Variable 1
                            lv_msg2                            "Message Variable 2
                            lv_msg3                            "Message Variable 3
                            lv_msg4.                           "Message Variable 4

  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_LOG_ADD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_INF  text
*      -->P_LV_MSG1  text
*      -->P_LV_MSG2  text
*      -->P_LV_MSG3  text
*      -->P_LV_MSG4  text
*----------------------------------------------------------------------*
FORM f_log_add  USING    fp_i_msg_typ         TYPE symsgty
                         fp_i_msgno           TYPE symsgno
                         fp_i_msgv1           TYPE string
                         fp_i_msgv2           TYPE string
                         fp_i_msgv3           TYPE string
                         fp_i_msgv4           TYPE string.

  DATA: lst_message  TYPE bal_s_msg.                                "Application Log: Message Data

  IF v_log_handle IS INITIAL.
    RETURN.
  ENDIF. " IF fp_i_log_handle IS INITIAL

* Prepare the message
  lst_message-msgty  = fp_i_msg_typ.                     "Message Type
  lst_message-msgid  = c_msg_cls.                        "Message Class - ZQTC_R2
  lst_message-msgno  = fp_i_msgno.                       "Message Number
  lst_message-msgv1  = fp_i_msgv1.                       "Message Variable 1
  lst_message-msgv2  = fp_i_msgv2.                       "Message Variable 2
  lst_message-msgv3  = fp_i_msgv3.                       "Message Variable 3
  lst_message-msgv4  = fp_i_msgv4.                       "Message Variable 4

* Application Log: Log: Message: Add
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = v_log_handle                        "Application Log: Log Handle
      i_s_msg          = lst_message                            "Message
    EXCEPTIONS
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      OTHERS           = 4.
  IF sy-subrc NE 0.
*   Nothing to do
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_SAVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_log_save .
  DATA:
    li_log_handle TYPE bal_t_logh. "Application Log: Log Handle Table


* Add the Application Log: Log Handle
  INSERT v_log_handle INTO TABLE li_log_handle.

  IF sy-subrc IS INITIAL.
*   Application Log: Database: Save logs
    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_t_log_handle   = li_log_handle                        "Application Log: Log Handle
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.

    IF sy-subrc NE 0.
*     Nothing to do
    ENDIF. " IF sy-subrc NE 0
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
* End of Change by PBANDLAPAL on 06/16/2017 for ERP-2837
*&---------------------------------------------------------------------*
*&      Form  F_IDOC_GENERATE
*&---------------------------------------------------------------------*
*       New Idoc Generate
*----------------------------------------------------------------------*
*      -->P_FP_LST_VBKD  text
*      -->P_FP_TEXT  text
*      <--P_FP_EX_RETURN_IDOC_MSG  text
*----------------------------------------------------------------------*
FORM f_idoc_generate  USING    p_fp_lst_vbkd            TYPE ty_vbkd           " Sales Doc Number
                               p_fp_agr_date            TYPE tt_agr_date       " Agreement date
                               p_fp_text                TYPE tt_text           " Text data
                               p_fp_entitle_status      TYPE tt_entitle_status " Entitle data
                      CHANGING p_fp_return_idoc_msg     TYPE bapiret2_t        " Return message.
                               p_lv_idocnum             TYPE string.       " Idoc Number


  DATA: li_idoc_data   TYPE edidd_tt,                          "IDoc Data Records
        li_idoc_contrl TYPE edidc_tt.                          "IDoc Control Records

  DATA: lst_e1edk01    TYPE e1edk01,                    "IDoc: Document header general data
        lst_e1edk14    TYPE e1edk14,                    "IDoc: Document Header Organizational Data
        lst_e1edp01    TYPE e1edp01,                    "IDoc: Document Item General Data
        lst_e1edp02    TYPE e1edp02,                    "IDoc: Document Item Reference Data
        lst_e1edp03    TYPE e1edp03,                    "IDoc: Document Item Date Segment
        lst_e1edpt1    TYPE e1edpt1,                    "IDoc: Document Item Text Identification
        lst_e1edpt2    TYPE e1edpt2,                    "IDoc: Document Item Texts
        lst_ent_status TYPE ty_entitle_status,          "Entitle data
        lst_ib_process TYPE tede2,                      "EDI process types (inbound)
        lst_cntrl_rec  TYPE edidc,                      "Control record (IDoc)
        lst_idoc_data  TYPE edidd.


  DATA: lv_logsys    TYPE tbdls-logsys,
        lv_segnum(6) TYPE n VALUE 0,
        lv_idocnum   TYPE edidc-docnum,
        lv_tabix     TYPE syst_tabix,
        lv_flg_date  TYPE char01,
        lv_flg_text  TYPE char01.

  CONSTANTS:  c_e1edk01     TYPE char7        VALUE 'E1EDK01',  " Segment structure
              c_e1edp01     TYPE char7        VALUE 'E1EDP01',  " Segment structure
              c_e1edp02     TYPE char7        VALUE 'E1EDP02',  " Segment structure
              c_e1edp03     TYPE char7        VALUE 'E1EDP03',  " Segment structure
              c_e1edpt1     TYPE char7        VALUE 'E1EDPT1',  " Segment structure
              c_e1edpt2     TYPE char7        VALUE 'E1EDPT2',  " Segment structure
              lc_staus_64   TYPE edi_status   VALUE '64',            "Idoc status
              lc_direct_2   TYPE edidc-direct VALUE '2',           "Idoc Direction
              lc_mestyp     TYPE edidc-mestyp VALUE 'ORDCHG',      "Message Type
              lc_idoctp     TYPE edidc-idoctp VALUE 'ORDERS05',    "Basic type
              lc_prt_ls     TYPE edidc-rcvprt VALUE 'LS',          "Partner type of receiver
              lc_sap        TYPE char3        VALUE 'SAP',         "system name SAP
              lc_318        TYPE edi_mescod   VALUE '318',         "Logical Message Variant
              lc_action_004 TYPE char3        VALUE '004',         "Action for change Header/Item
              lc_action_002 TYPE char3        VALUE '002',         "Action for change Item
              lc_action_043 TYPE char3        VALUE '043',         "Action for change Item
              lc_hlvl_01    TYPE edi_hlevel   VALUE '01',          "Segment level
              lc_hlvl_02    TYPE edi_hlevel   VALUE '02',          "Segment level
              lc_hlvl_03    TYPE edi_hlevel   VALUE '03',          "Segment level
              lc_hlvl_04    TYPE edi_hlevel   VALUE '04',          "Segment level
              lc_tdformat   TYPE char2        VALUE '*'.           "Paragraph format




*Getting the name of the current logical system we are working in:
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system = lv_logsys.
  IF sy-subrc = 0.
    lst_cntrl_rec-rcvprn = lv_logsys.  "Partner Number of Receiver
    lst_cntrl_rec-sndprn = lv_logsys.  "Partner Number of Sender
  ENDIF.
*Fill Control record for Idoc
  lst_cntrl_rec-mandt = sy-mandt.
  lst_cntrl_rec-status = lc_staus_64.                    "'64'. Status of Idoc
  lst_cntrl_rec-direct = lc_direct_2.                    "'2'.  Inbound Idoc

  CONCATENATE lc_sap sy-sysid INTO lst_cntrl_rec-rcvpor. "Reciever Port
  lst_cntrl_rec-sndpor = lst_cntrl_rec-rcvpor.           "Sender Port

  lst_cntrl_rec-rcvprt = lc_prt_ls.                      "LS "Reciving Partner
  lst_cntrl_rec-sndprt = lc_prt_ls.                      "LS "Sender Partner

  lst_cntrl_rec-stdmes = lc_mestyp.                      "Sender Message Type
  lst_cntrl_rec-mestyp = lc_mestyp.                      "Reciever Message Type

  lst_cntrl_rec-doctyp = lc_idoctp.                      "Sender Basic type
  lst_cntrl_rec-idoctp = lc_idoctp.                      "Reciever Basic type

  lst_cntrl_rec-mescod = lc_318.                         "Logical Message Variant
  lst_cntrl_rec-credat = sy-datum.                       "Creation date
  lst_cntrl_rec-cretim = sy-uzeit.                       "Creation time


*Fill Header Segment
*Fill segment E1EDK01 - IDoc: Document header general data
  CLEAR: lst_idoc_data, lst_e1edk01.
  lv_segnum = lv_segnum + 1.
  lst_e1edk01-action = lc_action_004.       "'004'.
  lst_e1edk01-belnr  = p_fp_lst_vbkd-vbeln. " lst_vbak-vbeln.

  lst_idoc_data-segnum   = lv_segnum.
  lst_idoc_data-segnam   = c_e1edk01.        "'E1EDK01'.
  lst_idoc_data-hlevel   = lc_hlvl_01.       "'01'.
  lst_idoc_data-sdata    = lst_e1edk01.
  APPEND lst_idoc_data TO li_idoc_data.      " E1EDK01

*Fill Line Item segments
  READ TABLE p_fp_entitle_status INTO lst_ent_status
                      WITH KEY vbeln = p_fp_lst_vbkd-vbeln
                      BINARY SEARCH.
  IF sy-subrc = 0.
    lv_tabix = sy-tabix.
    LOOP AT p_fp_entitle_status INTO lst_ent_status FROM lv_tabix.
      IF lst_ent_status-vbeln NE p_fp_lst_vbkd-vbeln.
        EXIT.
      ELSE.
        CLEAR: lv_flg_date, lv_flg_text.
*Check Acceptance date to be updated or not
        READ TABLE p_fp_agr_date INTO DATA(lst_fp_agr_date) WITH KEY itm_number = lst_ent_status-posnr.
        IF sy-subrc = 0 AND NOT lst_fp_agr_date-accept_dat IS INITIAL.
          lv_flg_date = abap_true.
        ENDIF.
*Check EAL Text field to be updated or not
        READ TABLE p_fp_text INTO DATA(lst_fp_text) WITH KEY doc_number = lst_ent_status-vbeln
                                                             itm_number = lst_ent_status-posnr.
        IF sy-subrc = 0 AND NOT lst_fp_text-text_line IS INITIAL.
          lv_flg_text = abap_true.
        ENDIF.

        IF lv_flg_date = abap_true OR lv_flg_text = abap_true.
*Fill segment E1EDP01 - IDoc: Document Item General Data
          CLEAR: lst_idoc_data, lst_e1edp01.
          lv_segnum = lv_segnum + 1.
          lst_e1edp01-posex = lst_ent_status-posnr.
          lst_e1edp01-action = lc_action_002.       "'002'.

          lst_idoc_data-segnum   = lv_segnum.
          lst_idoc_data-segnam   = c_e1edp01.       "'E1EDP01'.
          lst_idoc_data-hlevel   = lc_hlvl_02.      "'02'.
          lst_idoc_data-sdata    = lst_e1edp01.
          APPEND lst_idoc_data TO li_idoc_data.     "E1EDP01


*Fill segment E1EDP02 - IDoc: Document Item Reference Data
          CLEAR: lst_idoc_data, lst_e1edp02.
          lv_segnum = lv_segnum + 1.
          lst_e1edp02-qualf = lc_action_043.                 "'043'.
          lst_e1edp02-belnr = lst_ent_status-vbeln.
          lst_e1edp02-zeile = lst_ent_status-posnr.
          lst_e1edp02-ihrez = lst_ent_status-fulfillment_id. "Reference number

          lst_idoc_data-segnum   = lv_segnum.
          lst_idoc_data-segnam   = c_e1edp02.          "'E1EDP02'.
          lst_idoc_data-hlevel   = lc_hlvl_03.         "'03'.
          lst_idoc_data-sdata    = lst_e1edp02.
          APPEND lst_idoc_data TO li_idoc_data.        "E1EDP02
        ENDIF.

*Fill segment E1EDP03 - IDoc: Document Item Date Segment
        IF lv_flg_date = abap_true.
          CLEAR: lst_idoc_data, lst_e1edp03.
          lv_segnum = lv_segnum + 1.
          lst_e1edp03-iddat  = lc_action_043.                     "'043'.
          lst_e1edp03-datum  = lst_fp_agr_date-accept_dat.        "Contract acceptance date

          lst_idoc_data-segnum   = lv_segnum.
          lst_idoc_data-segnam   = c_e1edp03.       "'E1EDP03'.
          lst_idoc_data-hlevel   = lc_hlvl_03.      "'03'.
          lst_idoc_data-sdata    = lst_e1edp03.
          APPEND lst_idoc_data TO li_idoc_data.     "E1EDP03
        ENDIF.

*Fill segment E1EDPT1 - IDoc: Document Item Text Identification
        IF lv_flg_text = abap_true.
          CLEAR: lst_idoc_data, lst_e1edpt1.
          lv_segnum = lv_segnum + 1.
          lst_e1edpt1-tdid   = lst_fp_text-text_id.
          lst_e1edpt1-tsspras   = lst_fp_text-langu.

          lst_idoc_data-segnum   = lv_segnum.
          lst_idoc_data-segnam   = c_e1edpt1.     "'E1EDPT1'.
          lst_idoc_data-hlevel   = lc_hlvl_03.    "'03'.
          lst_idoc_data-sdata    = lst_e1edpt1.
          APPEND lst_idoc_data TO li_idoc_data.   "E1EDPT1


*Fill segment E1EDPT2 - IDoc: Document Item Texts
          CLEAR: lst_idoc_data, lst_e1edpt2.
          lv_segnum = lv_segnum + 1.
          lst_e1edpt2-tdline    = lst_fp_text-text_line.   "customer_id. "Text
          lst_e1edpt2-tdformat    = lc_tdformat.           "'*'.

          lst_idoc_data-segnum   = lv_segnum.
          lst_idoc_data-segnam   = c_e1edpt2.              "'E1EDPT2'.
          lst_idoc_data-hlevel   = lc_hlvl_04.             "'04'.
          lst_idoc_data-sdata    = lst_e1edpt2.
          APPEND lst_idoc_data TO li_idoc_data.            "E1EDPT2

        ENDIF.  "IF sy-subrc = 0.
      ENDIF.   "IF lst_ent_status-vbeln NE p_fp_lst_vbkd-vbeln.
    ENDLOOP.  "LOOP AT p_fp_entitle_status INTO lst_ent_status FROM lv_tabix.
  ENDIF.     "IF sy-subrc = 0.


  IF NOT li_idoc_data[] IS INITIAL.
*Create and Save IDOC in DB
    CALL FUNCTION 'IDOC_INBOUND_WRITE_TO_DB'
      EXPORTING
        pi_do_handle_error      = abap_true              "Flag: Error handling yes/no
        pi_return_data_flag     = abap_false             "Return of initialized data records
      IMPORTING
        pe_idoc_number          = lst_cntrl_rec-docnum   "IDOC Number
        pe_inbound_process_data = lst_ib_process         "EDI process types (inbound)
      TABLES
        t_data_records          = li_idoc_data           "IDOC Data Records
      CHANGING
        pc_control_record       = lst_cntrl_rec          "IDOC Control Record
      EXCEPTIONS
        idoc_not_saved          = 1
        OTHERS                  = 2.

    IF NOT lst_cntrl_rec-docnum IS INITIAL.
      p_lv_idocnum = lst_cntrl_rec-docnum.
    ENDIF.
  ENDIF.  "IF NOT li_idoc_data[] IS INITIAL.

ENDFORM.
*Start insert by <HIPATEL> <ERP-6918> <ED2K910736> <02/09/2018>
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_SUBSCRPT_ORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_VBELN  text
*      -->P_LI_ENT_STAT  text
*      <--P_LI_RETURN  text
*----------------------------------------------------------------------*
FORM f_update_sub_order  USING    fp_lv_vbeln TYPE vbeln_va
                                  fp_li_ent_stat TYPE tt_ent_stat
                                  fp_flag
                         CHANGING fp_li_return TYPE bapiret2_t.

  CALL FUNCTION 'ZQTC_ENTITLEMENT_STATUS_I0318'
    EXPORTING
      im_ent_status   = fp_li_ent_stat
      im_subs_num     = fp_lv_vbeln
      im_err_idoc     = fp_flag
    IMPORTING
      ex_t_return_msg = fp_li_return.

  SORT fp_li_return BY type.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_IDOC_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_IDOCNUM  text
*      -->P_LI_RETURN  text
*----------------------------------------------------------------------*
FORM f_fill_idoc_status  USING  fp_lv_idocnum TYPE edi_docnum
                                fp_lv_vbeln TYPE vbeln_va
                                fp_li_return  TYPE bapiret2_t
                      CHANGING  fp_idoc_status TYPE tt_bdidocstat.

  DATA :  lst_idoc_status TYPE bdidocstat. " Status record

*Populate messages to Idoc Status table
  READ TABLE fp_li_return INTO DATA(lst_return) WITH KEY type = c_err.
  IF sy-subrc = 0.
    DELETE fp_li_return[] WHERE type NE c_err.
  ENDIF.
  LOOP AT fp_li_return INTO lst_return.
    IF lst_return-type EQ c_suc OR lst_return-type EQ c_inf.
      lst_idoc_status-status = c_status_53. "'53'.
      lst_return-message_v1 = fp_lv_vbeln.
    ELSE.
      lst_idoc_status-status = c_status_51. "'51'.
    ENDIF.
    lst_idoc_status-docnum = fp_lv_idocnum.
    lst_idoc_status-msgty = lst_return-type.
    lst_idoc_status-msgid = lst_return-id.
    lst_idoc_status-msgno = lst_return-number.
    lst_idoc_status-msgv1 = lst_return-message_v1.
    lst_idoc_status-msgv2 = lst_return-message_v2.
    lst_idoc_status-msgv3 = lst_return-message_v3.
    lst_idoc_status-msgv4 = lst_return-message_v4.
    APPEND lst_idoc_status TO  fp_idoc_status.
  ENDLOOP.
ENDFORM.
*End insert by <HIPATEL> <ERP-6918> <ED2K910736> <02/09/2018>
