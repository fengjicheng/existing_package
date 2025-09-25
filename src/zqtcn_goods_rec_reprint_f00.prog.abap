*----------------------------------------------------------------------*
* REPORT NAME:           ZQTCN_GOODS_REC_REPRINT_F00
* REPORT DESCRIPTION:    Include for subroutine
* DEVELOPER:             Pavan Bandlapalli (PBANDLAPAL)
* CREATION DATE:         23-OCT-2017
* OBJECT ID:             E143
* TRANSPORT NUMBER(S):   ED2K908861
* DESCRIPTION:           This program is used for processing of the output
*                        type ZALE for account assignments maintained in
*                        ZCACONSTANT. This will posts the goods receipt
*                        and inbound Idoc is created.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_GOODS_REC_REPRINT_F00
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GOODS_MOVEMENT_REPRINT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_NAST  text
*----------------------------------------------------------------------*
FORM f_goods_movement_reprint  USING    fp_nast   TYPE nast.

  CONSTANTS: lc_evcode  TYPE edi_evcode VALUE 'BAPI',                    " Process code for inbound processing
             lc_segnam  TYPE edilsegtyp VALUE 'E1MBGMCR',                "Idoc segment name E1MBGCR
             lc_segnam1 TYPE edilsegtyp VALUE 'E1BP2017_GM_HEAD_01',     "Idoc segment name
             lc_segnam2 TYPE edilsegtyp VALUE 'E1BP2017_GM_CODE',        "Idoc segment name
             lc_segnam4 TYPE edilsegtyp VALUE 'E1BP2017_GM_ITEM_CREATE'. "Idoc segment name

  DATA:
    lst_edidc          TYPE edidc,
    li_edidd           TYPE tt_edidd,                                     "EDIDD table
    li_return          TYPE TABLE OF bapiret2,
    lv_segnam          TYPE edilsegtyp,                                   "Segment type
    lv_hlevel          TYPE edi_hlevel,                                   "Hierarchy level
    lst_sdata          TYPE edi_sdata,                                    "sdata structure
    lv_ebelp_c         TYPE char6,                                       " Char of PO line item number
    lst_return         TYPE bapiret2,
    lv_unpoad_pt       TYPE char25,                                       " Unloading Point.
    lst_idoc_item      TYPE e1bp2017_gm_item_create,                      "Item structure
    lst_idoc_header    TYPE e1bp2017_gm_head_01,                          "BAPI Communication Structure: Material Document Header Data
    lv_idoc_num_gr     TYPE edi_docnum,                                   "IDoc number
    lv_matdoc_num      TYPE bapi2017_gm_head_02-mat_doc,
    lv_matdoc_itm      TYPE mblpo,
    lst_bwart_ale      TYPE zcast_constant,
    lv_matdoc_year     TYPE bapi2017_gm_head_02-doc_year,
    lst_goodsmvt_hdr   TYPE bapi2017_gm_head_02,
    lst_goodsmvt_items TYPE bapi2017_gm_item_show,
    li_goodsmvt_items  TYPE TABLE OF bapi2017_gm_item_show.

* Get Material document number from NAST structure
  lv_matdoc_num = fp_nast-objky(10).
  lv_matdoc_year = fp_nast-objky+10(4).
  lv_matdoc_itm  = fp_nast-objky+14(4).

*     Get GoodsMovement data
  CALL FUNCTION 'BAPI_GOODSMVT_GETDETAIL'
    EXPORTING
      materialdocument = lv_matdoc_num
      matdocumentyear  = lv_matdoc_year
    IMPORTING
      goodsmvt_header  = lst_goodsmvt_hdr
    TABLES
      goodsmvt_items   = li_goodsmvt_items
      return           = li_return.

  v_retcode = 0.
  LOOP AT li_return INTO lst_return WHERE type = c_msgtyp_err OR type = c_msgtyp_abt.
    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        msg_arbgb = lst_return-id
        msg_nr    = lst_return-number
        msg_ty    = lst_return-type
        msg_v1    = lst_return-message_v1
        msg_v2    = lst_return-message_v2
        msg_v3    = lst_return-message_v3
        msg_v4    = lst_return-message_v4
      EXCEPTIONS
        OTHERS    = 0.
    IF sy-subrc EQ 0.
      v_retcode = 999.
    ENDIF. " IF sy-subrc EQ 0
  ENDLOOP.
  IF v_retcode = 0.
    DELETE li_goodsmvt_items WHERE matdoc_itm NE lv_matdoc_itm.
    PERFORM f_get_zcaconstant_data.
*    Create IDOC for GR
****************************************************************************
*  To populate the control structure of idoc
    PERFORM f_set_edidc_gr CHANGING lst_edidc.

*    To build the IDOC data structure
    lv_segnam = lc_segnam.
    CLEAR lv_hlevel.
    lv_hlevel = lv_hlevel + 1.
*    To build the IDOC  data structure
    PERFORM f_set_edidd USING lv_segnam
                              lv_hlevel
                              lst_sdata
                    CHANGING li_edidd.

**    To populate header table and pass in IDOC
*      PERFORM f_populate_header USING lst_goodsmvt_hdr
*                                CHANGING lst_idoc_header.

    CLEAR lv_segnam.
    lv_segnam = lc_segnam1.
    lst_idoc_header-pstng_date = lst_goodsmvt_hdr-pstng_date.
    lst_idoc_header-doc_date = lst_goodsmvt_hdr-doc_date.
    lst_idoc_header-ref_doc_no = lst_goodsmvt_hdr-mat_doc.

    lst_sdata = lst_idoc_header.
    lv_hlevel = lv_hlevel + 1.

*    To build the IDOC  data structure
    PERFORM f_set_edidd USING lv_segnam
                              lv_hlevel
                              lst_sdata
                        CHANGING li_edidd.

*  To set edidc for GM Code
    CLEAR: lv_segnam,lst_sdata.
    lv_segnam = lc_segnam2.
    lst_sdata = v_zca_gm_code.

*  To build the IDOC  data structure
    PERFORM f_set_edidd USING lv_segnam
                              lv_hlevel
                              lst_sdata
                     CHANGING li_edidd.

**  To set EDIDC for items
**  To populate Item table and pass in IDOC
    LOOP AT li_goodsmvt_items INTO lst_goodsmvt_items.
      lst_idoc_item-material = lst_goodsmvt_items-material.
      lst_idoc_item-plant = lst_goodsmvt_items-plant.
      IF lst_goodsmvt_items-stge_loc IS NOT INITIAL.
        lst_idoc_item-stge_loc = lst_goodsmvt_items-stge_loc.
      ELSE.
        lst_idoc_item-stge_loc  = v_zca_lgort.  " 'J001'.
      ENDIF.
      lst_idoc_item-vendor = lst_goodsmvt_items-vendor.
      lst_idoc_item-entry_qnt = lst_goodsmvt_items-entry_qnt.
      lst_idoc_item-entry_uom = lst_goodsmvt_items-entry_uom.
      lv_ebelp_c  = lst_goodsmvt_items-po_item.
      CONCATENATE lst_goodsmvt_items-po_number  lv_ebelp_c INTO lv_unpoad_pt
                                                 SEPARATED BY c_hyphen.
      lst_idoc_item-unload_pt = lv_unpoad_pt.
      READ TABLE i_bwart_zale INTO lst_bwart_ale WITH KEY param1 = c_bwart_zale
                                                          param2 = lst_goodsmvt_items-move_type.
      IF sy-subrc EQ 0.
        lst_idoc_item-move_type = lst_bwart_ale-low.
      ENDIF.

      CLEAR: lv_segnam,lst_sdata.
      lv_segnam = lc_segnam4.
      lst_sdata = lst_idoc_item.

*   To build the IDOC  data structure
      PERFORM f_set_edidd USING lv_segnam
                                lv_hlevel
                                lst_sdata
                          CHANGING li_edidd.
    ENDLOOP.

*    Create IDOC
    PERFORM f_create_idoc USING    lst_edidc
                                   lc_evcode
                          CHANGING li_edidd
                                   lv_idoc_num_gr.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_EDIDC_PO
*&---------------------------------------------------------------------*
*       Set IDOC Status
*----------------------------------------------------------------------*
*      <--P_LST_EDIDC_PO  text
*----------------------------------------------------------------------*
FORM f_set_edidc_gr  CHANGING fp_lst_edidc TYPE edidc. " Control record (IDoc)

  CONSTANTS:
    lc_mestyp     TYPE edi_mestyp VALUE 'MBGMCR',   "Message Type
    lc_basic_type TYPE edi_idoctp VALUE 'MBGMCR03', "Basic type
    lc_prt_ls     TYPE edi_sndprt VALUE 'LS',       "Logical port
    lc_sap        TYPE char3      VALUE 'SAP',      "system name SAP
    lc_direct_2   TYPE edi_direct VALUE '2',        "direction-inbound
    lc_status_53  TYPE edi_status VALUE '53',       "idoc status-started
    lc_msgvar_rep TYPE edi_mescod VALUE 'REP'.      " Message Variant.

* Get Logical System
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system             = fp_lst_edidc-sndprn
    EXCEPTIONS
      own_logical_system_not_defined = 1
      OTHERS                         = 2.
  IF sy-subrc = 0.
    fp_lst_edidc-rcvprn = fp_lst_edidc-sndprn.
  ENDIF. " IF sy-subrc = 0

  fp_lst_edidc-mandt  = sy-mandt.
  fp_lst_edidc-status = lc_status_53. "53
  fp_lst_edidc-direct = lc_direct_2. "2
  CONCATENATE lc_sap sy-sysid INTO fp_lst_edidc-rcvpor. "Reciever Port
  fp_lst_edidc-sndpor = fp_lst_edidc-rcvpor. "Sender Port
  fp_lst_edidc-sndprt = lc_prt_ls. "LS
  fp_lst_edidc-rcvprt = fp_lst_edidc-sndprt. "Reciving Partner
  fp_lst_edidc-credat = sy-datum. "Creation date
  fp_lst_edidc-cretim = sy-uzeit. "Creation time
  fp_lst_edidc-mestyp = lc_mestyp. "MBGMCR
  fp_lst_edidc-idoctp = lc_basic_type. "Basic type
  fp_lst_edidc-mescod = lc_msgvar_rep. " Message Variant

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_EDIDD
*&---------------------------------------------------------------------*
*       To set EDIDD data
*----------------------------------------------------------------------*
FORM f_set_edidd USING fp_lv_segnam TYPE edilsegtyp " Segment type
                       fp_lv_hlevel TYPE edi_hlevel " Hierarchy level
                       fp_lst_sdata TYPE edi_sdata  " Application data
                 CHANGING fp_li_edidd TYPE tt_edidd.
* Local data declaration
  DATA lst_edidd TYPE edidd. "IDOC Data structure

* Local Constant Declaration
  CONSTANTS lc_mestyp TYPE edi_mestyp VALUE 'MBGMCR'. "Message type

* Call the FM to adjust the fields in SDATA structure
  CALL FUNCTION 'IDOC_REDUCTION_FIELD_REDUCE'
    EXPORTING
      message_type = lc_mestyp
      segment_type = fp_lv_segnam
      segment_data = fp_lst_sdata
    IMPORTING
      segment_data = lst_edidd-sdata.

* Add the segment name
  lst_edidd-segnam = fp_lv_segnam.
*  Add the hierarchy level
  lst_edidd-hlevel = fp_lv_hlevel.

  APPEND lst_edidd TO fp_li_edidd.
  CLEAR lst_edidd.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_IDOC
*&---------------------------------------------------------------------*
*      Create IDOC for GR
*----------------------------------------------------------------------*
FORM f_create_idoc  USING    fp_edidc            TYPE edidc      " Control record (IDoc)
                             fp_lc_evcode        TYPE edi_evcode " Process code for inbound processing
                    CHANGING fp_li_edidd         TYPE tt_edidd
                             fp_lv_idoc_number   TYPE edi_docnum.  " IDoc number

* Local data declaration
  DATA: lv_upd_tsk         TYPE i,
        lv_message         TYPE char255,                 "Message Text
        li_control_records TYPE STANDARD TABLE OF edidc, "IDOC control record
        lst_process_data   TYPE tede2,                   "IDOC process data
        lst_edidc          TYPE edidc.                   "IDOC control record data

* Local Constant declaration
  CONSTANTS:  lc_6    TYPE edi_edivr2 VALUE '6'. "Event No

  lst_edidc = fp_edidc.
* Call the FM to create the IDOC no and initatiate the IDOC
  CALL FUNCTION 'IDOC_INBOUND_WRITE_TO_DB'
    EXPORTING
      pi_do_handle_error  = abap_true
      pi_return_data_flag = space
    IMPORTING
      pe_idoc_number      = fp_lv_idoc_number
    TABLES
      t_data_records      = fp_li_edidd[]
    CHANGING
      pc_control_record   = lst_edidc
    EXCEPTIONS
      idoc_not_saved      = 1
      OTHERS              = 2.
  IF sy-subrc = 0.
    CALL METHOD cl_system_transaction_state=>get_in_update_task
      RECEIVING
        in_update_task = lv_upd_tsk.
    IF lv_upd_tsk EQ 0.
      COMMIT WORK.
    ENDIF. " IF lv_upd_tsk EQ 0
    MESSAGE i693(edereg_inv) WITH fp_lv_idoc_number INTO lv_message.
    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        msg_arbgb = syst-msgid
        msg_nr    = syst-msgno
        msg_ty    = syst-msgty
        msg_v1    = syst-msgv1
        msg_v2    = syst-msgv2
      EXCEPTIONS
        OTHERS    = 0.
* Append the data in the control record table to pass
    APPEND lst_edidc TO li_control_records.
    CLEAR: lst_edidc,
           lst_process_data.

* Assign the Event code details
    lst_process_data-mandt  = sy-mandt.
    lst_process_data-evcode = fp_lc_evcode.
    lst_process_data-edivr2 = lc_6.

* Call the FM to schedule the Inbound processing in Foreground
    CALL FUNCTION 'IDOC_START_INBOUND'
      EXPORTING
        pi_inbound_process_data       = lst_process_data
        pi_do_commit                  = abap_false
        pi_called_online              = abap_false
        pi_start_event_enabled        = abap_true
        succ_show_flag                = abap_false
      TABLES
        t_control_records             = li_control_records
      EXCEPTIONS
        invalid_document_number       = 1
        error_before_call_application = 2
        inbound_process_not_possible  = 3
        old_wf_start_failed           = 4
        wf_task_error                 = 5
        serious_inbound_error         = 6
        OTHERS                        = 7.
    IF sy-subrc NE 0.
      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          msg_arbgb = syst-msgid
          msg_nr    = syst-msgno
          msg_ty    = syst-msgty
          msg_v1    = syst-msgv1
          msg_v2    = syst-msgv2
        EXCEPTIONS
          OTHERS    = 0.
      IF sy-subrc EQ 0.
        v_retcode = 999.
      ENDIF.
    ENDIF. " IF sy-subrc EQ 0
  ELSE.
    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        msg_arbgb = syst-msgid
        msg_nr    = syst-msgno
        msg_ty    = syst-msgty
        msg_v1    = syst-msgv1
        msg_v2    = syst-msgv2
      EXCEPTIONS
        OTHERS    = 0.
    IF sy-subrc EQ 0.
      v_retcode = 999.
    ENDIF.
  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_ZCACONSTANT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_zcaconstant_data .

  DATA: li_constant  TYPE zcat_constants,
        lst_constant TYPE zcast_constant.

* To select the ZCACONSTANT entries for the E143 development and which contains *ZALE in param1.
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = c_devid_e143                                       "Development ID: E143
    IMPORTING
      ex_constants = li_constant.                                      "Constant Values

  LOOP AT li_constant INTO lst_constant.
    CASE lst_constant-param1.
      WHEN c_bwart_zale.                                                 "Parameter: Account Assignment Categories
        APPEND lst_constant TO i_bwart_zale.
      WHEN c_gm_code_zale.                                                 "Parameter: Movement Types
        v_zca_gm_code    =   lst_constant-low.
      WHEN c_strg_loc_zale.
        v_zca_lgort      =  lst_constant-low.
      WHEN OTHERS.
*     Nothing to do
    ENDCASE.
  ENDLOOP.

ENDFORM.
