*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_INVENT_RECO
* PROGRAM DESCRIPTION: Include contains the logic and other subroutines
* DEVELOPER: Alankruta Patnaik
* CREATION DATE:   2017-03-27
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INVENT_RECON_IDOC_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SET_EDIDC_PO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_ST_EDIDC_PO  text
*----------------------------------------------------------------------*
FORM f_set_edidc_po  CHANGING fp_st_edidc_po TYPE edidc. " Control record (IDoc)
*  * Local Constant Declaration
  CONSTANTS:
    lc_mestyp     TYPE edi_mestyp VALUE 'MBGMCR',   "Message Type
    lc_basic_type TYPE edi_idoctp VALUE 'MBGMCR03', "Basic type
    lc_prt_ls     TYPE edi_sndprt VALUE 'LS',       "Logical port
    lc_sap        TYPE char3      VALUE 'SAP',      "system name SAP
    lc_direct_2   TYPE edi_direct VALUE '2',        "direction-inbound
    lc_status_53  TYPE edi_status VALUE '53',       "idoc status-started
    lc_mesfct_gr  TYPE edi_mesfct VALUE 'GR',      " Message Function GR
    lc_mescod_jrr TYPE edi_mescod VALUE 'JRR'.     " Message Variant JRR

* Get Logical System
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system             = fp_st_edidc_po-sndprn
    EXCEPTIONS
      own_logical_system_not_defined = 1
      OTHERS                         = 2.
  IF sy-subrc = 0.
    fp_st_edidc_po-rcvprn = fp_st_edidc_po-sndprn.
  ENDIF. " IF sy-subrc = 0

  fp_st_edidc_po-mandt  = sy-mandt.
  fp_st_edidc_po-status = lc_status_53. "53
  fp_st_edidc_po-direct = lc_direct_2. "2
  CONCATENATE lc_sap sy-sysid INTO fp_st_edidc_po-rcvpor. "Reciever Port
  fp_st_edidc_po-sndpor = fp_st_edidc_po-rcvpor. "Sender Port
  fp_st_edidc_po-sndprt = lc_prt_ls. "LS
  fp_st_edidc_po-rcvprt = fp_st_edidc_po-sndprt. "Reciving Partner
  fp_st_edidc_po-credat = sy-datum. "Creation date
  fp_st_edidc_po-cretim = sy-uzeit. "Creation time
  fp_st_edidc_po-mestyp = lc_mestyp. "MBGMCR
  fp_st_edidc_po-mescod = lc_mescod_jrr.     " Message Variant JRR
  fp_st_edidc_po-mesfct = lc_mesfct_gr.      " Message function GR
  fp_st_edidc_po-idoctp = lc_basic_type. "Basic type


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_IDOC_GR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_EDIDC_PO  text
*      <--P_I_UPLOAD_FILE  text
*      <--P_I_OUTPUT_DET  text
*----------------------------------------------------------------------*
FORM f_build_idoc_gr USING fp_edidc_po      TYPE edidc. " Control record (IDoc)

  DATA : lst_custom_tmp TYPE zqtc_inven_recon,        " Table for Inventory Reconciliation Data
         li_final       TYPE tt_final,
         lst_header     TYPE e1bp2017_gm_head_01,     "header strcuture
         lv_rcpt        TYPE zrcpt,                  " Receipt Qty
         lv_flag        TYPE abekz,
         lst_ekpo_tmp   TYPE ty_ekpo,
         lv_lifnr       TYPE lifnr,
         lv_lifnr_mult  TYPE xfeld,
         lv_idx_po      TYPE sytabix.

  CONSTANTS : lc_flag_e TYPE abekz VALUE 'E',
              lc_flag_d TYPE abekz VALUE 'D',
              lc_flag_a TYPE abekz VALUE 'A',
              lc_flag_b TYPE abekz VALUE 'B',
              lc_flag_c TYPE abekz VALUE 'C'.

* To process the records of EKPO and populate idoc structure
  SORT i_custom BY matnr   ASCENDING
                   werks   ASCENDING
                   zmaildt DESCENDING.

* Loop on Custom table by material and Plant combination
* Here only one entry available for one material plant combination
  LOOP AT i_custom_tmp INTO lst_custom_tmp.

*   Check whether there is any failed idoc for this material plant combination
*   then don't proceed further and provide error message
**   Binary search is not required as table will have very few records.
    READ TABLE i_custom_fail TRANSPORTING NO FIELDS
    WITH KEY matnr = lst_custom_tmp-matnr
             werks = lst_custom_tmp-werks.
    IF sy-subrc IS INITIAL.
*     Populate error message no PO exist
      lv_flag = lc_flag_d.   "D
      PERFORM f_update_log USING lst_custom_tmp
                                 lv_flag.
      CLEAR: lv_flag.
    ELSE.

*     Check whether ZDATE not in current period then assign ZMAILDT
*     to ZDATE and also check whether ZMAILDT is not in the
*     range then populate error
*   Binary search is not required as table will have very few records.
      IF lst_custom_tmp-zdate NOT IN i_date.
        READ TABLE i_custom INTO DATA(lst_custom_date)
        WITH KEY matnr = lst_custom_tmp-matnr
                 werks = lst_custom_tmp-werks.
        IF sy-subrc IS INITIAL.
          lst_custom_tmp-zdate = lst_custom_date-zmaildt.
        ENDIF.
      ENDIF.

*     Check whether posting date is in current period
      IF lst_custom_tmp-zdate IN i_date.
*       Check whether there is any PO for this
*       Material and Plant combination
*   Binary search is not required as table will have very few records.
        READ TABLE i_ekpo TRANSPORTING NO FIELDS
        WITH KEY matnr = lst_custom_tmp-matnr
                 werks = lst_custom_tmp-werks.
        IF sy-subrc IS INITIAL. "--------------------->> PO Exist

          lv_idx_po = sy-tabix.

*         Calculate total RCPT quantity for this Material Plant combination
          PERFORM f_calculate_rcpt USING    lst_custom_tmp
                                   CHANGING lv_rcpt.
*         To populate header table and pass in IDOC
          PERFORM f_populate_header USING    lst_custom_tmp
                                    CHANGING lst_header.

*         Check the PO quantity with this Material Plant
*         combination to find out open quantity
          LOOP AT i_ekpo INTO DATA(lst_ekpo) FROM lv_idx_po.
            IF lst_ekpo-matnr NE lst_custom_tmp-matnr
              OR lst_ekpo-werks NE lst_custom_tmp-werks.
              EXIT.
            ELSE.
*             To populate item table and pass it in idoc
              PERFORM f_populate_item USING   lst_ekpo
                                              lst_custom_tmp
                                     CHANGING li_final
                                              lv_rcpt
                                              lst_ekpo_tmp
                                              lv_lifnr
                                              lv_lifnr_mult.
              IF lv_rcpt IS INITIAL
              OR lv_lifnr_mult EQ abap_true.
                EXIT. " Exit for EKPO and EKBE calculation loop.
*                     " Now it will go to create idoc
              ENDIF.  " IF lv_rcpt IS NOT INITIAL
            ENDIF.
            CLEAR: lst_ekpo.
          ENDLOOP.

          IF lv_lifnr_mult EQ abap_true.
*           Populate Error Message : Multiple vendor exists for this
*           Material Plant combination
            lv_flag = lc_flag_e. "'E'.
            PERFORM f_update_log USING lst_custom_tmp
                                       lv_flag.
            CLEAR: lv_flag.
          ELSE.

*           Check whether still there is some ZRCPT quantity remain for
*           this material plant combination then raise error message
            IF lv_rcpt IS INITIAL.
*             Try to create Idoc with the idoc data populated
              PERFORM f_execute_process USING    fp_edidc_po
                                                 lst_custom_tmp
                                                 lst_ekpo_tmp
                                                 lst_header
                                                 li_final.
            ELSE.
*             Try to allocate the tolerance quantity from i_ekpo_tol table
              IF i_ekpo_tol[] IS NOT INITIAL.
                PERFORM f_allocate_tollerence USING    lst_custom_tmp
                                              CHANGING li_final
                                                       lv_rcpt
                                                       lst_ekpo_tmp
                                                       lv_lifnr
                                                       lv_lifnr_mult.
                IF lv_lifnr_mult EQ abap_true.
*                 Populate Error Message : Multiple vendor exists for this
*                 Material Plant combination
                  lv_flag = lc_flag_e. "'E'.
                  PERFORM f_update_log USING lst_custom_tmp
                                             lv_flag.
                  CLEAR: lv_flag.
                ELSE.
                  IF lv_rcpt IS INITIAL.
*                   Try to create Idoc with the idoc data populated
                    PERFORM f_execute_process USING    fp_edidc_po
                                                       lst_custom_tmp
                                                       lst_ekpo_tmp
                                                       lst_header
                                                       li_final.
                  ELSE.
*                   Populate Error Message : Open PO quantity is less than
*                   total RCPT quantity for Material Plant combination
                    lv_flag = lc_flag_b. "'B'.
                    PERFORM f_update_log USING lst_custom_tmp
                                               lv_flag.
                    CLEAR: lv_flag.
                  ENDIF.
                ENDIF.
              ELSE.
*               Populate Error Message : Open PO quantity is less than
*               total RCPT quantity for Material Plant combination
                lv_flag = lc_flag_b. "'B'.
                PERFORM f_update_log USING lst_custom_tmp
                                           lv_flag.
                CLEAR: lv_flag.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSE. " Check whether any PO exist for Material Plant combination
*             " -------------->> PO does not exist.
*         Populate error message no PO exist
          lv_flag = lc_flag_a."'A'.
          PERFORM f_update_log USING lst_custom_tmp
                                     lv_flag.
          CLEAR: lv_flag.
        ENDIF.

      ELSE. " Check whether posting date is in current period
*       Populate error message no PO exist
        lv_flag = lc_flag_c. "'C'.
        PERFORM f_update_log USING lst_custom_tmp
                                   lv_flag.
        CLEAR: lv_flag.

      ENDIF. " Check whether posting date is in current period
    ENDIF.   " Check whether there is any failed idoc

    CLEAR: lst_header, li_final[], lv_rcpt,
           i_ekpo_tol, lst_ekpo_tmp, lv_lifnr, lv_lifnr_mult.
  ENDLOOP. " Loop on Custom table by material and Plant combination

* Update the custom table with the idoc number
  IF i_idoc IS NOT INITIAL.
    PERFORM f_populate_gr_doc.

    PERFORM f_update_table.
  ENDIF. " IF i_idoc IS NOT INITIAL

  CALL FUNCTION 'DEQUEUE_E_TABLE'
    EXPORTING
      tabname = 'ZQTC_INVEN_RECON'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_IDOC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_EDIDC_PO  text
*      -->P_LC_EVCODE  text
*      -->P_LV_PO_DOCUMENT  text
*      -->P_LV_SO_DOCUMENT  text
*      <--P_LI_EDIDD  text
*      <--P_FP_I_OUTPUT_DET  text
*----------------------------------------------------------------------*
FORM f_create_idoc  USING    fp_lst_edidc TYPE edidc             " Control record (IDoc)
                             fp_lc_evcode TYPE edi_evcode        " Process code for inbound processing
                             fp_lst_custom TYPE zqtc_inven_recon " Table for Inventory Reconciliation Data
                             fp_lst_ekpo_tmp TYPE ty_ekpo
                    CHANGING fp_li_edidd TYPE tt_edidd.


*  * Local data declaration
  DATA:  lst_inb_pr_data    TYPE tede2,                   "inbound data
         lv_upd_tsk         TYPE i,
         lv_sy_subrc        TYPE sy-subrc,                "Sy-subrc
         li_control_records TYPE STANDARD TABLE OF edidc, "IDOC control record
         lst_process_data   TYPE tede2,                   "IDOC process data
         lst_output_det     TYPE ty_output_det,           "Output Details Table
         lst_edidc          TYPE edidc,                   "IDOC control record data
         lst_idoc           TYPE zqtc_inven_recon.        "IDOC control record data

* Local Constant declaration
  CONSTANTS:
    lc_6   TYPE edi_edivr2 VALUE '6'. "Event No

  CLEAR lst_output_det.
  lst_edidc = fp_lst_edidc.

* Call the FM to create the IDOC no and initatiate the IDOC
  CALL FUNCTION 'IDOC_INBOUND_WRITE_TO_DB'
    EXPORTING
      pi_do_handle_error      = abap_true
      pi_return_data_flag     = space
    IMPORTING
      pe_idoc_number          = lst_output_det-idoc_number
      pe_state_of_processing  = lv_sy_subrc
      pe_inbound_process_data = lst_inb_pr_data
    TABLES
      t_data_records          = fp_li_edidd[]
    CHANGING
      pc_control_record       = lst_edidc
    EXCEPTIONS
      idoc_not_saved          = 1
      OTHERS                  = 2.
  IF sy-subrc = 0.
    CALL METHOD cl_system_transaction_state=>get_in_update_task
      RECEIVING
        in_update_task = lv_upd_tsk.
    IF lv_upd_tsk EQ 0.
      COMMIT WORK.
    ENDIF. " IF lv_upd_tsk EQ 0

*   Append the data in the control record table to pass
    APPEND lst_edidc TO li_control_records.
    CLEAR: lst_edidc,
           lst_process_data.

*   Assign the Event code details
    lst_process_data-mandt  = sy-mandt.
    lst_process_data-evcode = fp_lc_evcode.
    lst_process_data-edivr2 = lc_6.

*   Call the FM to schedule the Inbound processing in Foreground
    CALL FUNCTION 'IDOC_START_INBOUND'
      EXPORTING
        pi_inbound_process_data       = lst_process_data
        succ_show_flag                = abap_true
        pi_called_online              = abap_true
        pi_start_event_enabled        = abap_true
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

    IF sy-subrc EQ 0.
*     Do nothing. We don't have any specific logic for failed idoc.
    ENDIF. " IF sy-subrc EQ 0

    DATA(lv_idoc) = lst_output_det-idoc_number.
*   Populate Log entry for Idoc
    PERFORM f_update_log_idoc USING fp_lst_custom
                                    fp_lst_ekpo_tmp
                                    lv_idoc.

*   Populate cutom table update entry
    PERFORM f_upd_cust_table_entry USING fp_lst_custom
                                         fp_lst_ekpo_tmp
                                         lv_idoc.


    st_idocnumber-idocnumber = lst_output_det-idoc_number.
    APPEND st_idocnumber TO i_idocnumber.

    CLEAR: lst_idoc,st_idocnumber.
  ENDIF. " IF sy-subrc = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_EDIDD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_SEGNAM  text
*      -->P_LV_HLEVEL  text
*      -->P_LST_SDATA  text
*      <--P_LI_EDIDD  text
*----------------------------------------------------------------------*
FORM f_set_edidd  USING   fp_lv_segnam TYPE edilsegtyp " Segment type
                          fp_lv_hlevel TYPE edi_hlevel " Hierarchy level
                          fp_lst_sdata TYPE edi_sdata  " Application data
                 CHANGING fp_li_edidd  TYPE tt_edidd.

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

* Add the hierarchy level
  lst_edidd-hlevel = fp_lv_hlevel.
  APPEND lst_edidd TO fp_li_edidd.
  CLEAR lst_edidd.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_populate_header
               USING    fp_lst_custom_tmp TYPE zqtc_inven_recon
               CHANGING fp_lst_header     TYPE e1bp2017_gm_head_01.

  fp_lst_header-pstng_date = fp_lst_custom_tmp-zdate.
  fp_lst_header-doc_date   = fp_lst_custom_tmp-zdate.

ENDFORM.



*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_populate_item  USING    fp_lst_ekpo       TYPE ty_ekpo
                               fp_lst_custom_tmp TYPE zqtc_inven_recon
                      CHANGING fp_li_final       TYPE tt_final
                               fp_lv_rcpt        TYPE zrcpt " Receipt Qty
                               fp_lst_ekpo_tmp   TYPE ty_ekpo
                               fp_lv_lifnr       TYPE lifnr
                               fp_lv_lifnr_mult  TYPE xfeld.

*Local constant declaration
  CONSTANTS: lc_shkzg_s TYPE shkzg VALUE 'S', " Debit/Credit Indicator
             lc_shkzg_h TYPE shkzg VALUE 'H'. " Debit/Credit Indicator


* Local data declaration
  DATA: lst_ekbe     TYPE ty_ekbe,
        lst_final    TYPE e1bp2017_gm_item_create, " BAPI Communication Structure: Create Material Document Item
        lv_qty_open  TYPE menge_d,                 " Quantity
        lv_qty_po    TYPE menge_d,                 " Quantity
        lv_qty_gr    TYPE menge_d,                 " Quantity
        lv_qty_alloc TYPE p,
        lst_ekpo_tol TYPE ty_ekpo,                 " EKPO structure
        lv_menge_clr TYPE menge_d,                 " MENGE type clear variable
        lv_menge     TYPE menge_d,                 " tolerance Value
        lv_date      TYPE char10,
        lv_seq_no    TYPE char10,
        lv_index_val TYPE sy-tabix.                " ABAP System Field: Row Index of Internal Tables

* Calculation part to find out Allocation qty
* Allocation Qty = Open Qty
* Open Qty = PO Qty - GR Qty
  CLEAR: lv_qty_open,
         lv_qty_po,
         lv_qty_gr,
         lv_qty_alloc,
         lv_menge_clr.

* Assign PO qty for this specific po item
  lv_qty_po = fp_lst_ekpo-menge.

* Check for GR quantity with this PO item
  READ TABLE i_ekbe TRANSPORTING NO FIELDS
  WITH KEY ebeln = fp_lst_ekpo-ebeln
           ebelp = fp_lst_ekpo-ebelp
  BINARY SEARCH.
  IF sy-subrc IS INITIAL.
    lv_index_val = sy-tabix.

    LOOP AT i_ekbe INTO lst_ekbe FROM lv_index_val.
      IF   lst_ekbe-ebeln NE fp_lst_ekpo-ebeln
        OR lst_ekbe-ebelp NE fp_lst_ekpo-ebelp.
        EXIT.
      ELSE. " ELSE -> IF lst_ekbe-ebeln NE fp_lst_ekpo-ebeln

*       Calculation of S-H
        IF lst_ekbe-shkzg = lc_shkzg_s.
          lv_qty_gr = lv_qty_gr + lst_ekbe-menge.
        ELSEIF lst_ekbe-shkzg = lc_shkzg_h.
          lv_qty_gr = lv_qty_gr - lst_ekbe-menge.
        ENDIF. " IF lst_ekbe-shkzg = lc_shkzg_s

      ENDIF. " IF lst_ekbe-ebeln NE fp_lst_ekpo-ebeln
    ENDLOOP. " LOOP AT i_ekbe INTO lst_ekbe FROM lv_index_val

*   Calculation of Open Qty (EKPO-MENGE - EKBE-MENGE)
    lv_qty_open = lv_qty_po - lv_qty_gr.

  ELSE. " ELSE -> IF sy-subrc IS INITIAL
    lv_qty_open = lv_qty_po.
  ENDIF. " IF sy-subrc IS INITIAL


* Check whether open qty is not initial
  IF lv_qty_open LT lv_menge_clr.      " Open quantity is lesser than 0
*   Get how much can be assigned and
*   Append Tolerance table (I_EKPO_TOL)
*   ----->> Calculate tolerance amount and append to
*   tolerance value for further use
    IF fp_lst_ekpo-uebto IS NOT INITIAL.
      lv_menge = trunc( ( fp_lst_ekpo-menge * fp_lst_ekpo-uebto ) / 100 ).
      lv_menge = lv_menge + lv_qty_open.
      IF lv_menge IS NOT INITIAL.
        lst_ekpo_tol = fp_lst_ekpo.
        lst_ekpo_tol-menge = lv_menge.
        APPEND lst_ekpo_tol TO i_ekpo_tol.
      ENDIF.
      CLEAR: lst_ekpo_tol, lv_menge.
    ENDIF.

  ELSEIF lv_qty_open EQ lv_menge_clr.   " Open quantity is initial
*   Append tolerance table (I_EKPO_TOL)
*   ----->> Calculate tolerance amount and append to
*   tolerance value for further use
    IF fp_lst_ekpo-uebto IS NOT INITIAL.
      lv_menge = trunc( ( fp_lst_ekpo-menge * fp_lst_ekpo-uebto ) / 100 ).
      lst_ekpo_tol = fp_lst_ekpo.
      lst_ekpo_tol-menge = lv_menge.
      APPEND lst_ekpo_tol TO i_ekpo_tol.
      CLEAR: lst_ekpo_tol, lv_menge.
    ENDIF.

  ELSEIF lv_qty_open GT lv_menge_clr.   " Open quantity is greater than 0
*   Allocate the Quantity for GR and Append
*   tolerance table (I_EKPO_TOL)
*   ------->> Allocate the quantity
    IF lv_qty_open GE fp_lv_rcpt.
*     Calculation of Allocation qty wrt custom table
      lv_qty_alloc = fp_lv_rcpt.
      CLEAR: fp_lv_rcpt.
    ELSE. " ELSE -> IF lv_qty_open GE fp_lv_rcpt
      lv_qty_alloc = lv_qty_open.
      fp_lv_rcpt = fp_lv_rcpt - lv_qty_open.
    ENDIF. " IF lv_qty_open GE fp_lv_rcpt

*   ----->> Calculate tolerance amount and append to
*   tolerance value for further use
    IF fp_lst_ekpo-uebto IS NOT INITIAL.
      lv_menge = trunc( ( fp_lst_ekpo-menge * fp_lst_ekpo-uebto ) / 100 ).
      lst_ekpo_tol = fp_lst_ekpo.
      lst_ekpo_tol-menge = lv_menge.
      APPEND lst_ekpo_tol TO i_ekpo_tol.
      CLEAR: lst_ekpo_tol, lv_menge.
    ENDIF.

  ENDIF.

  IF lv_qty_open IS NOT INITIAL
    AND fp_lv_rcpt IS NOT INITIAL.

  ENDIF. " IF lv_qty_open IS NOT INITIAL

  IF lv_qty_alloc IS NOT INITIAL.
    IF fp_lv_lifnr IS INITIAL.
      fp_lv_lifnr = fp_lst_ekpo-lifnr.
    ELSEIF fp_lv_lifnr NE fp_lst_ekpo-lifnr.
      fp_lv_lifnr_mult = abap_true.
    ENDIF.
    lst_final-material      = fp_lst_ekpo-matnr.
    lst_final-stge_loc      = p_sloc.
    lst_final-move_type     = p_mov.
    lst_final-entry_uom     = p_uom.
    lst_final-mvt_ind       = p_mov_i.
    lst_final-plant         = fp_lst_ekpo-werks.
    lst_final-po_number     = fp_lst_ekpo-ebeln.
    lst_final-po_item       = fp_lst_ekpo-ebelp.
    lst_final-entry_qnt     = lv_qty_alloc.
    lv_date = fp_lst_custom_tmp-zdate.
    lv_seq_no = fp_lst_custom_tmp-zseqno.
    CONCATENATE lv_date
                lv_seq_no
    INTO lst_final-unload_pt SEPARATED BY c_dash.
    APPEND lst_final TO fp_li_final.
    IF fp_lst_ekpo_tmp IS INITIAL.
      fp_lst_ekpo_tmp = fp_lst_ekpo.
    ENDIF.
  ENDIF. " IF lv_qty_alloc IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_data .
****Selection from custom table
  SELECT *
    INTO TABLE i_custom
    FROM zqtc_inven_recon " Table for Inventory Reconciliation Data
    WHERE zadjtyp EQ  p_adj
      AND ZRCPT   NE space.

  IF sy-subrc IS INITIAL.
    i_custom_idoc = i_custom.
    i_custom_fail = i_custom.
    DELETE i_custom WHERE xblnr IS NOT INITIAL.
    DELETE i_custom WHERE zrcpt IS INITIAL.

    DELETE i_custom_fail WHERE xblnr IS INITIAL.
    DELETE i_custom_fail WHERE mblnr IS NOT INITIAL.

    DELETE i_custom_idoc WHERE xblnr IS INITIAL.
    DELETE i_custom_idoc WHERE zfgrdat IS INITIAL.
    i_custom_tmp[] = i_custom.
    SORT i_custom_tmp BY matnr ASCENDING
                         werks ASCENDING
                         zdate DESCENDING.
    DELETE ADJACENT DUPLICATES FROM i_custom_tmp
    COMPARING matnr
              werks.
  ENDIF. " IF sy-subrc IS INITIAL

  IF i_custom_tmp IS NOT INITIAL.
*   Fetch entry from EKPO table basef on material
*   getting from custom table
    SELECT h~matnr " Material Number
       h~ebeln " Purchasing Document Number
       h~ebelp " Item Number of Purchasing Document
       h~loekz " Deletion Indicator in Purchasing Document
       h~werks " Plant
       h~lgort " Storage Location
       h~menge " Purchase Order Quantity
       h~meins " Purchase Order Unit of Measure
       h~knttp " Account Assignment Category
       h~elikz " Delivery Completed" Indicator
       h~uebto " tolerance
       h~banfn " Purchase Requsition
       p~bsart " Doc type
       p~lifnr " Vendor
FROM ekpo  AS h
INNER JOIN ekko AS p ON  p~ebeln EQ h~ebeln
INTO TABLE i_ekpo
FOR ALL ENTRIES IN i_custom_tmp
WHERE h~loekz   EQ space   " PVN
  AND h~matnr   EQ i_custom_tmp-matnr
  AND h~werks   EQ i_custom_tmp-werks
  AND h~knttp   EQ p_acc
  AND h~elikz   EQ space  " PVN
  AND h~emlif   NE space
  AND p~bsart   EQ p_doc.
    IF sy-subrc IS INITIAL.
      SORT i_ekpo BY matnr ASCENDING
                     werks ASCENDING
                     banfn DESCENDING.
    ENDIF. " IF sy-subrc IS INITIAL

    IF i_ekpo IS NOT INITIAL.
*     Get GR details from EKBE table based on prefetch
*     EBELN and EBELP from EKPO
      SELECT ebeln " Purchasing Document Number
             ebelp " Item Number of Purchasing Document
             zekkn " Sequential Number of Account Assignment
             vgabe " Transaction/event type, purchase order history
             gjahr " Material Document Year
             belnr " Number of Material Document
             buzei " Item in Material Document
             bwart " Movement Type (Inventory Management)
             menge " Quantity
             waers " Currency Key
             shkzg " Debit/Credit Indicator
       FROM ekbe INTO TABLE i_ekbe
        FOR ALL ENTRIES IN i_ekpo
        WHERE ebeln EQ i_ekpo-ebeln
        AND   ebelp EQ i_ekpo-ebelp
        AND   bewtp EQ p_po_h.   "PVN
      IF sy-subrc IS INITIAL.
        SORT i_ekbe BY ebeln
                       ebelp
                       bwart.
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF i_ekpo IS NOT INITIAL
  ENDIF. " IF li_custom_tmp IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_GR_DOC
*&---------------------------------------------------------------------*
*   Populate GR material Document number
*----------------------------------------------------------------------*
FORM f_populate_gr_doc.

  DATA: lv_tabix TYPE sy-tabix.

* To get the roleid based on idoc number
* No need initial check of i_idocnumber[]
  SELECT objkey,
         objtype,
         logsys,
         roletype,
         roleid
    FROM srrelroles
    INTO TABLE @DATA(li_service_roles)
    FOR ALL ENTRIES IN @i_idocnumber
    WHERE objkey = @i_idocnumber-idocnumber.

  IF sy-subrc EQ 0.
*   SORT and Delete Adjacent duplicates is not required because for this
*   case only one roleid can be assigned against one idoc.
*   Because one Idoc can only create one GR (MAterial Document Number)
    SELECT role_a,
           role_b
      FROM idocrel
      INTO TABLE @DATA(li_idocrel)
      FOR ALL ENTRIES IN @li_service_roles
      WHERE role_a = @li_service_roles-roleid.

    IF sy-subrc EQ 0.
*     Here also Sort and Delete adjacent duplicates is not required for
*     the same reason
*     Again select is done from srrelroles table to get the OBJKEY
*     which will now containm the material document after putting
*     ROLE_B of IDOCREL into roleid
      SELECT objkey,
             roleid
        FROM srrelroles
        INTO TABLE @DATA(li_objkey)
        FOR ALL ENTRIES IN @li_idocrel
        WHERE roleid = @li_idocrel-role_b.

      IF sy-subrc EQ 0.

*       Modify the final idoc table from where the
*       cumtom table will be updated
        LOOP AT i_idoc ASSIGNING FIELD-SYMBOL(<lst_idoc>).
*   Binary search is not required as table will have very few records.
          READ TABLE li_service_roles INTO DATA(lst_service_roles)
          WITH KEY objkey = <lst_idoc>-xblnr.
          IF sy-subrc IS INITIAL.
*   Binary search is not required as table will have very few records.
            READ TABLE li_idocrel INTO DATA(lst_idocrel)
            WITH KEY role_a = lst_service_roles-roleid.
            IF sy-subrc IS INITIAL.
*   Binary search is not required as table will have very few records.
              READ TABLE li_objkey INTO DATA(lst_objkey)
              WITH KEY roleid = lst_idocrel-role_b.
              IF sy-subrc IS INITIAL
                AND lst_objkey-objkey+0(10) IS NOT INITIAL.

                <lst_idoc>-mblnr = lst_objkey-objkey+0(10).

*               Update Log table with MBLNR
*   Binary search is not required as table will have very few records.
                READ TABLE i_output TRANSPORTING NO FIELDS
                WITH KEY idoc_number = <lst_idoc>-xblnr.
                IF sy-subrc IS INITIAL.
                  lv_tabix = sy-tabix.
                  LOOP AT i_output ASSIGNING FIELD-SYMBOL(<lst_op>) FROM lv_tabix.
                    IF <lst_op>-idoc_number NE <lst_idoc>-xblnr.
                      EXIT.
                    ELSE.
                      <lst_op>-material_doc = lst_objkey-objkey+0(10).
                    ENDIF.
                  ENDLOOP.
                ENDIF.

              ELSE. " ------>> Material Doc not generated so delete PO number and date
                CLEAR: <lst_idoc>-zfgrdat,
                       <lst_idoc>-zlgrdat,
                       <lst_idoc>-ebeln.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.

      ENDIF. " Fetching from srrelroles executes based on role_b
    ENDIF.   " Fetching from idocrel successful
  ENDIF.     " fetch from srrelroles successful based on idoc number

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_TABLE
*&---------------------------------------------------------------------*
* Update custom table
*----------------------------------------------------------------------*
FORM f_update_table .
* We are updating multiple entries. So we are doing table level
* lock instead of row level lock.
  IF i_idoc IS NOT INITIAL.
    UPDATE zqtc_inven_recon FROM TABLE i_idoc.
    IF sy-subrc IS INITIAL.
      COMMIT WORK.
    ENDIF.
  ENDIF.   "   IF sy-subrc EQ 0.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ALV_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_OUTPUT  text
*----------------------------------------------------------------------*
FORM f_alv_display  USING    fp_i_output TYPE tt_output.

  DATA: lst_fieldcatalog TYPE slis_fieldcat_alv,
        lst_layout       TYPE slis_layout_alv,
        li_fieldcatalog  TYPE slis_t_fieldcat_alv.

* Fill traffic lights field name in the ALV layout
  lst_layout-lights_fieldname = 'STATUS'.
  lst_layout-colwidth_optimize = abap_true.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'NUMBER'.
  lst_fieldcatalog-seltext_m   = 'MSG NO'(m01).
  lst_fieldcatalog-col_pos     = 2.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'ID'.
  lst_fieldcatalog-seltext_m   = 'MSG ID'(m02).
  lst_fieldcatalog-col_pos     = 3.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'IDOC_NUMBER'.
  lst_fieldcatalog-seltext_m   = 'IDOC NO'(m03).
  lst_fieldcatalog-col_pos     = 4.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'ZADJTYP'.
  lst_fieldcatalog-seltext_m   = 'ADJ Typ'(m04).
  lst_fieldcatalog-col_pos     = 5.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'MATNR'.
  lst_fieldcatalog-seltext_m   = 'Material No'(m05).
  lst_fieldcatalog-col_pos     = 6.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'PLANT'.
  lst_fieldcatalog-seltext_m   = 'Plant'(m06).
  lst_fieldcatalog-col_pos     = 7.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'PO_NUMBER'.
  lst_fieldcatalog-seltext_m   = 'PO NO'(m07).
  lst_fieldcatalog-col_pos     = 8.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'ITEM_NO'.
  lst_fieldcatalog-seltext_m   = 'Item No'(m08).
  lst_fieldcatalog-col_pos     = 9.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'MATERIAL_DOC'.
  lst_fieldcatalog-seltext_m   = 'Material Do No(GR/GI)'(m09).
  lst_fieldcatalog-col_pos     = 10.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

*  Populate fieldcatalog
  lst_fieldcatalog-fieldname   = 'SOURCE_FILE'.
  lst_fieldcatalog-seltext_m   = 'Source File'(m10).
  lst_fieldcatalog-col_pos     = 11.
  lst_fieldcatalog-outputlen = 50.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

  lst_fieldcatalog-fieldname   = 'MESSAGE'.
  lst_fieldcatalog-seltext_m   = 'Message'(m11).
  lst_fieldcatalog-col_pos     = 12.
  lst_fieldcatalog-outputlen = 100.
  APPEND lst_fieldcatalog TO li_fieldcatalog.
  CLEAR  lst_fieldcatalog.

* Pass data and field catalog to ALV function module to display ALV list
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = lst_layout
      it_fieldcat        = li_fieldcatalog
    TABLES
      t_outtab           = fp_i_output
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    CLEAR li_fieldcatalog[].
  ENDIF.
ENDFORM.



*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_update_log  USING    fp_lst_custom_tmp TYPE zqtc_inven_recon
                            fp_lv_flag        TYPE abekz.

* Local data declaration
  DATA: lst_custom TYPE zqtc_inven_recon,
        lst_output TYPE ty_output,
        lv_idx     TYPE sytabix.

  CONSTANTS : lc_a TYPE abekz VALUE 'A',
              lc_b TYPE abekz VALUE 'B',
              lc_c TYPE abekz VALUE 'C',
              lc_d TYPE abekz VALUE 'D',
              lc_e TYPE abekz VALUE 'E'.

* Error Message No PO found for Material Plant Combination
*   Binary search is not required as table will have very few records.
  READ TABLE i_custom TRANSPORTING NO FIELDS
  WITH KEY matnr = fp_lst_custom_tmp-matnr
           werks = fp_lst_custom_tmp-werks.
  IF sy-subrc IS INITIAL.
    lv_idx = sy-tabix.
    LOOP AT i_custom INTO lst_custom FROM lv_idx.
      IF lst_custom-matnr NE fp_lst_custom_tmp-matnr
        OR lst_custom-werks NE fp_lst_custom_tmp-werks.
        EXIT.
      ELSE.
        lst_output-status      = c_err.
        IF fp_lv_flag = lc_a.
          lst_output-message     = 'No PO Available for this Material Plant Combination'(m13).
        ELSEIF fp_lv_flag = lc_b.
          lst_output-message     = 'Open PO quantity is less than total RCPT quantity'(m14).
        ELSEIF fp_lv_flag = lc_c.
          lst_output-message     = 'Date is not in current posting period'(m15).
        ELSEIF fp_lv_flag = lc_d.
          lst_output-message     = 'There is failed idoc for this material plant combination'(m16).
        ELSEIF fp_lv_flag = lc_e.
          lst_output-message     = 'Multiple Vendor exists for this material plant combination'(m17).
        ENDIF.
        lst_output-zadjtyp     = p_adj.               "Adjustment Type
        lst_output-matnr       = lst_custom-matnr.    "Material
        lst_output-plant       = lst_custom-werks.    "Plant
        lst_output-source_file = lst_custom-zsource.  "Source File
        APPEND lst_output TO i_output.
        CLEAR: lst_output.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_CALCULATE_RCPT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_calculate_rcpt  USING    fp_lst_custom_tmp TYPE zqtc_inven_recon
                       CHANGING fp_lv_rcpt        TYPE zrcpt.
* Local data declaration
  DATA: lv_idx TYPE sytabix.

  CLEAR: fp_lv_rcpt.
*   Binary search is not required as table will have very few records.
  READ TABLE i_custom TRANSPORTING NO FIELDS
  WITH KEY matnr = fp_lst_custom_tmp-matnr
           werks = fp_lst_custom_tmp-werks.
  IF sy-subrc IS INITIAL.

    lv_idx = sy-tabix.
    LOOP AT i_custom INTO DATA(lst_custom) FROM lv_idx.
      IF lst_custom-matnr NE fp_lst_custom_tmp-matnr
        OR lst_custom-werks NE fp_lst_custom_tmp-werks.
        EXIT.
      ELSE.
        fp_lv_rcpt = fp_lv_rcpt + lst_custom-zrcpt.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.



*&---------------------------------------------------------------------*
*&      Form  F_EXECUTE_PROCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_execute_process  USING
          fp_edidc_po       TYPE edidc
          fp_lst_custom_tmp TYPE zqtc_inven_recon
          fp_lst_ekpo_tmp   TYPE ty_ekpo
          fp_lst_header     TYPE e1bp2017_gm_head_01
          fp_li_final       TYPE tt_final.

  DATA: lv_hlevel TYPE edi_hlevel,              "Hierarchy level
        lst_sdata TYPE edi_sdata,               "sdata structure
        li_edidd  TYPE tt_edidd.                "EDIDD table

* Local constant declaration
  CONSTANTS: lc_segnam   TYPE edilsegtyp VALUE 'E1MBGMCR',            "Idoc segment name E1MBGCR
             lc_segnam1  TYPE edilsegtyp VALUE 'E1BP2017_GM_HEAD_01', "Idoc segment name
             lc_segnam2  TYPE edilsegtyp VALUE 'E1BP2017_GM_CODE',    "Idoc segment name
             lc_segnam4  TYPE edilsegtyp VALUE 'E1BP2017_GM_ITEM_CREATE',  "Idoc segment name
             lc_gm_code  TYPE gm_code VALUE '01',      "Value for GM_CODE
             lc_evcode   TYPE edi_evcode VALUE 'BAPI'. " Process code for inbound processing


* To build the IDOC  data structure
  DATA(lv_segnam) = lc_segnam.
  CLEAR lv_hlevel.

  lv_hlevel = lv_hlevel + 1.
  PERFORM f_set_edidd USING lv_segnam
                            lv_hlevel
                            lst_sdata
                      CHANGING li_edidd.

  CLEAR lv_segnam.
  lv_segnam = lc_segnam1.
  lst_sdata = fp_lst_header.
  lv_hlevel = lv_hlevel + 1.

* To build the IDOC  data structure
  PERFORM f_set_edidd USING lv_segnam
                            lv_hlevel
                            lst_sdata
                      CHANGING li_edidd.

  lv_hlevel = lv_hlevel - 1.

* To set edidc for GM Code
  DATA(lv_code) = lc_gm_code.
  lv_segnam = lc_segnam2.
  lst_sdata = lv_code.
  lv_hlevel = lv_hlevel + 1.
* To build the IDOC  data structure
  PERFORM f_set_edidd USING lv_segnam
                            lv_hlevel
                            lst_sdata
                      CHANGING li_edidd.
  lv_hlevel = lv_hlevel - 1.

* To set EDIDC for items
  LOOP AT fp_li_final INTO DATA(lst_final).
    "For line item
    lv_segnam = lc_segnam4.
    lst_sdata = lst_final.
    lv_hlevel = lv_hlevel + 1.
*   To build the IDOC  data structure
    PERFORM f_set_edidd USING lv_segnam
                              lv_hlevel
                              lst_sdata
                        CHANGING li_edidd.

    lv_hlevel = lv_hlevel - 1.
    CLEAR lst_final.
  ENDLOOP. " LOOP AT li_final INTO lst_final

  lv_hlevel = lv_hlevel - 1.

* Create IDOC
  PERFORM f_create_idoc USING    fp_edidc_po
                                 lc_evcode
                                 fp_lst_custom_tmp
                                 fp_lst_ekpo_tmp
                        CHANGING li_edidd.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_UPD_CUST_TABLE_ENTRY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_upd_cust_table_entry  USING    fp_lst_custom  TYPE zqtc_inven_recon
                                      fp_lst_ekpo_tmp TYPE ty_ekpo
                                      fp_lv_idoc TYPE edi_docnum.
  DATA: lv_idx   TYPE sytabix,
        lst_idoc TYPE zqtc_inven_recon. "IDOC control record data.

  READ TABLE i_custom TRANSPORTING NO FIELDS
    WITH KEY matnr = fp_lst_custom-matnr
             werks = fp_lst_custom-werks
    BINARY SEARCH.
  IF sy-subrc IS INITIAL.
    lv_idx = sy-tabix.
    LOOP AT i_custom INTO DATA(lst_custom_idoc) FROM lv_idx.
      IF fp_lst_custom-matnr NE lst_custom_idoc-matnr
        OR fp_lst_custom-werks NE lst_custom_idoc-werks.
        EXIT.
      ELSE. "IF lst_ekpo-matnr NE lst_custom-matnr.
        IF lst_custom_idoc-zrcpt IS NOT INITIAL.
          MOVE-CORRESPONDING lst_custom_idoc TO lst_idoc.
*   Binary search is not required as table will have very few records.
          READ TABLE i_custom_idoc INTO DATA(lst_custom_idoc1)
          WITH KEY matnr = lst_custom_idoc-matnr
                   werks = lst_custom_idoc-werks.
          IF sy-subrc IS INITIAL.
            lst_idoc-zfgrdat   = lst_custom_idoc1-zfgrdat.
          ELSE.
            lst_idoc-zfgrdat   = sy-datum.
          ENDIF.
          lst_idoc-zlgrdat   = fp_lst_custom-zdate.
          lst_idoc-ebeln     = fp_lst_ekpo_tmp-ebeln.
          lst_idoc-xblnr     = fp_lv_idoc.
          APPEND lst_idoc TO i_idoc.
        ENDIF.
      ENDIF. "IF lst_ekpo-matnr NE lst_custom-matnr.
    ENDLOOP. "LOOP AT i_custom INTO lst_custom FROM lv_index.
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_LOG_IDOC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_LST_CUSTOM  text
*      -->P_FP_LST_EKPO_TMP  text
*      -->P_LV_IDOC  text
*----------------------------------------------------------------------*
FORM f_update_log_idoc  USING    fp_lst_custom TYPE zqtc_inven_recon
                                 fp_lst_ekpo_tmp TYPE ty_ekpo
                                 fp_lv_idoc TYPE edi_docnum.


  DATA: li_edids   TYPE STANDARD TABLE OF edids, "table for edidd
        li_edidd   TYPE STANDARD TABLE OF edidd, "table for edidc
        lv_msg     TYPE bapi_msg, "message
        lst_output TYPE ty_output,
        lv_idx     TYPE sytabix.

* FM to read the idoc details
  CALL FUNCTION 'IDOC_READ_COMPLETELY'
    EXPORTING
      document_number         = fp_lv_idoc
    TABLES
      int_edids               = li_edids
      int_edidd               = li_edidd
    EXCEPTIONS
      document_not_exist      = 1
      document_number_invalid = 2
      OTHERS                  = 3.

  IF sy-subrc = 0.
    SORT li_edids BY countr DESCENDING.
    READ TABLE li_edids INTO DATA(lst_edids) INDEX 1.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'FORMAT_MESSAGE'
        EXPORTING
          id        = lst_edids-stamid
          lang      = sy-langu
          no        = lst_edids-stamno
          v1        = lst_edids-stapa1
          v2        = lst_edids-stapa2
          v3        = lst_edids-stapa3
          v4        = lst_edids-stapa4
        IMPORTING
          msg       = lv_msg
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF sy-subrc EQ 0.

        READ TABLE i_custom TRANSPORTING NO FIELDS
          WITH KEY matnr = fp_lst_custom-matnr
                   werks = fp_lst_custom-werks.
        IF sy-subrc IS INITIAL.
          lv_idx = sy-tabix.
          LOOP AT i_custom INTO DATA(lst_custom) FROM lv_idx.
            IF lst_custom-matnr NE fp_lst_custom-matnr
              OR lst_custom-werks NE fp_lst_custom-werks.
              EXIT.
            ELSE.
              IF lst_edids-status      = c_st.
                lst_output-status      = c_succ.
              ELSE .
                lst_output-status = c_err.
              ENDIF. "if lst_edids-status = '53'.
              lst_output-id          = lst_edids-stamid.           "Id
              lst_output-number      = lst_edids-stamno.           "Number
              lst_output-message     = lv_msg.                     "Message
              lst_output-idoc_number = fp_lv_idoc.                 "Idoc Number
              lst_output-zadjtyp     = p_adj.                      "Adjustment Type
              lst_output-matnr       = lst_custom-matnr . "Material
              lst_output-plant       = lst_custom-werks .    "Plant
              lst_output-po_number   = fp_lst_ekpo_tmp-ebeln. "PO Number
              lst_output-item_no     = fp_lst_ekpo_tmp-ebelp .  "PO Item
              lst_output-source_file = lst_custom-zsource.               "Source File
              APPEND lst_output TO i_output.
              CLEAR: lst_output.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_ALLOCATE_TOLLERENCE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_allocate_tollerence  USING    fp_lst_custom_tmp TYPE zqtc_inven_recon
                            CHANGING fp_li_final       TYPE tt_final
                                     fp_lv_rcpt        TYPE zrcpt
                                     fp_lst_ekpo_tmp   TYPE ty_ekpo
                                     fp_lv_lifnr       TYPE lifnr
                                     fp_lv_lifnr_mult  TYPE xfeld.

  DATA: lv_tabix  TYPE sytabix,
        lv_tabix1 TYPE sytabix,
        lv_menge  TYPE menge_d,
        lv_date   TYPE char10,
        lv_seq_no TYPE char10,
        lst_final TYPE e1bp2017_gm_item_create.

  LOOP AT fp_li_final INTO lst_final.
    lv_tabix = sy-tabix.
    READ TABLE i_ekpo_tol INTO DATA(lst_ekpo_tol)
    WITH KEY ebeln = lst_final-po_number
             ebelp = lst_final-po_item.
    IF sy-subrc IS INITIAL.
      lv_tabix1 = sy-tabix.
      IF fp_lst_ekpo_tmp IS INITIAL.
        fp_lst_ekpo_tmp = lst_ekpo_tol.
      ENDIF.
      IF fp_lv_rcpt GT lst_ekpo_tol-menge.
        lst_final-entry_qnt = lst_final-entry_qnt + lst_ekpo_tol-menge.
        fp_lv_rcpt = fp_lv_rcpt - lst_ekpo_tol-menge.
      ELSE.
        lst_final-entry_qnt = lst_final-entry_qnt + fp_lv_rcpt.
        CLEAR: fp_lv_rcpt.
      ENDIF.

      MODIFY fp_li_final FROM lst_final
      INDEX lv_tabix TRANSPORTING entry_qnt.

      DELETE i_ekpo_tol INDEX lv_tabix1.

      IF fp_lv_rcpt IS INITIAL.
        EXIT.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF fp_lv_rcpt IS NOT INITIAL.
    LOOP AT i_ekpo_tol INTO lst_ekpo_tol.
      IF fp_lv_lifnr IS INITIAL.
        fp_lv_lifnr = lst_ekpo_tol-lifnr.
      ELSEIF fp_lv_lifnr NE lst_ekpo_tol-lifnr..
        fp_lv_lifnr_mult = abap_true.
        EXIT.
      ENDIF.

      IF fp_lst_ekpo_tmp IS INITIAL.
        fp_lst_ekpo_tmp = lst_ekpo_tol.
      ENDIF.

      IF fp_lv_rcpt GT lst_ekpo_tol-menge.
        lv_menge = lst_ekpo_tol-menge.
        fp_lv_rcpt = fp_lv_rcpt - lst_ekpo_tol-menge.
      ELSE.
        lv_menge = fp_lv_rcpt.
        CLEAR: fp_lv_rcpt.
      ENDIF.
      lst_final-material      = lst_ekpo_tol-matnr.
      lst_final-stge_loc      = p_sloc.
      lst_final-move_type     = p_mov.
      lst_final-entry_uom     = p_uom.
      lst_final-mvt_ind       = p_mov_i.
      lst_final-plant         = lst_ekpo_tol-werks.
      lst_final-po_number     = lst_ekpo_tol-ebeln.
      lst_final-po_item       = lst_ekpo_tol-ebelp.
      lst_final-entry_qnt     = lv_menge.
      lv_date = fp_lst_custom_tmp-zdate.
      lv_seq_no = fp_lst_custom_tmp-zseqno.
      CONCATENATE lv_date
                  lv_seq_no
      INTO lst_final-unload_pt SEPARATED BY c_dash.
      APPEND lst_final TO fp_li_final.
      IF fp_lv_rcpt IS INITIAL.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.



*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_POSTING_PERIOD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_populate_posting_period .

  DATA: lst_date TYPE fieu_s_date_range,
        lv_month TYPE fcmnr,
        lv_year  TYPE gjahr.

  CONSTANTS: lc_month  TYPE fcmnr    VALUE '12',
             lc_sign   TYPE ddsign   VALUE 'I',
             lc_option TYPE ddoption VALUE 'BT'.

* Get last date of current month
  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = sy-datum
    IMPORTING
      last_day_of_month = lst_date-high
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.
  IF sy-subrc <> 0.
*  Do nothing
  ENDIF.

* Get current month and year
  lv_month = sy-datum+4(2).
  lv_year = sy-datum+0(4).

* Calculate previous month considering year
  IF lv_month > 1.
    lv_month = lv_month - 1.
  ELSE.
    lv_month = lc_month.
    lv_year = lv_year - 1.
  ENDIF.

  CALL FUNCTION 'OIL_MONTH_GET_FIRST_LAST'
    EXPORTING
      i_month     = lv_month
      i_year      = lv_year
    IMPORTING
      e_first_day = lst_date-low
    EXCEPTIONS
      wrong_date  = 1
      OTHERS      = 2.

  IF sy-subrc <> 0.
*  Do nothing
  ENDIF.

  lst_date-sign =   lc_sign.
  lst_date-option = lc_option.
  APPEND lst_date TO i_date.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOCK_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_lock_table .
* Lock the custom table
  CALL FUNCTION 'ENQUEUE_E_TABLE'
    EXPORTING
      tabname        = 'ZQTC_INVEN_RECON'
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.

  IF sy-subrc IS INITIAL.
*   Set IDOC control structure
    PERFORM f_set_edidc_po CHANGING st_edidc_po.

*   Build IDOC for posting GR
    PERFORM f_build_idoc_gr USING st_edidc_po.
  ELSE.
*   Local data declaration
    DATA: lst_output_e TYPE ty_output.
    lst_output_e-status      = c_err.
    lst_output_e-message     = 'Table is locked.No entry will be processed.'(m12).
    lst_output_e-zadjtyp     = p_adj.               "Adjustment Type
    APPEND lst_output_e TO i_output.
    CLEAR: lst_output_e.
  ENDIF.

ENDFORM.
