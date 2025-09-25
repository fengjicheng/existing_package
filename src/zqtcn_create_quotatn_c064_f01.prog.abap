*----------------------------------------------------------------------*
* PROGRAM NAME : ZQTCC_CREATE_QUOTATION_C064
* PROGRAM DESCRIPTION: Get the data from input pipe dilimited file,
* Create quotation for the subs order present in input feed file and
* update table ZQTC_RENWL_PLAN.
* All the subroutine has been declared here.
* DEVELOPER: Lucky Kodwani(LKODWANI)
* CREATION DATE:   2017-07-03
* DER NUMBER: C064/CR_344
* TRANSPORT NUMBER(S): ED2K907090
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CREATE_QUOTATN_C067_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_VARIBLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_varibles .

  CLEAR : i_upload_file[],
          i_final[],
          i_fcat[].

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_PRESENTATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_SYST_CPROG  text
*      -->FP_C_FIELD  text
*      <--FP_P_FILE  text
*----------------------------------------------------------------------*
FORM f_f4_presentation  USING    fp_syst_cprog TYPE syst_cprog " ABAP System Field: Calling Program
                                 fp_c_field    TYPE dynfnam    " Field name
                        CHANGING fp_p_file     TYPE localfile. " Local file for upload/download

  CALL FUNCTION 'F4_FILENAME' "for search help in presentation server.
    EXPORTING
      program_name = fp_syst_cprog
      field_name   = fp_c_field
    IMPORTING
      file_name    = fp_p_file.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_APPLICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--FP_P_FILE  text
*----------------------------------------------------------------------*
FORM f_f4_application  CHANGING fp_p_file TYPE localfile. " Local file for upload/download

  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE' "for search help in application server.
    IMPORTING
      serverfile       = fp_p_file
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.
  IF sy-subrc EQ 0.
* Do Nothing.
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PRESENTATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_validate_presentation  USING    fp_p_file TYPE localfile. " Local file for upload/download
  DATA: lv_file   TYPE string,
        lv_result TYPE abap_bool.

  CLEAR lv_file.
  lv_file = fp_p_file.

  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file                 = lv_file
    RECEIVING
      result               = lv_result
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      wrong_parameter      = 3
      not_supported_by_gui = 4
      OTHERS               = 5.
  IF sy-subrc <> 0.
*  Error message : unable to check file 'E'
    MESSAGE e001(zqtc_r2). " Unable to check file
  ELSE. " ELSE -> IF sy-subrc <> 0
    IF lv_result EQ abap_false.
*   Error message :File does not exits 'E'
      MESSAGE e002(zqtc_r2). " 'File does not exits.
    ENDIF. " IF lv_result EQ abap_false
  ENDIF. " IF sy-subrc <> 0

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_APPLICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_validate_application  USING    fp_p_file TYPE localfile. " Local file for upload/download


  DATA:    lv_test TYPE orblk,            " Data block for original data
           lv_file TYPE rcgiedial-iefile, " Path or Name of Transfer File
           l_len   TYPE sy-tabix.         " ABAP System Field: Row Index of Internal Tables

  lv_file = fp_p_file.

  OPEN DATASET lv_file FOR INPUT IN BINARY MODE. " Set as Ready for Input
  IF sy-subrc EQ 0.
    CATCH SYSTEM-EXCEPTIONS dataset_read_error = 11
                          OTHERS = 12.
      READ DATASET lv_file INTO lv_test LENGTH l_len. " lst_str.

    ENDCATCH.
    IF sy-subrc EQ 0.
      CLOSE DATASET lv_file.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      CLOSE DATASET lv_file.
      MESSAGE e004.
    ENDIF. " IF sy-subrc EQ 0
  ELSE. " ELSE -> IF sy-subrc EQ 0
    MESSAGE e002. "File doesnot exist
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.

*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_UPLOAD_FILE  text
*----------------------------------------------------------------------*
FORM f_read_file_frm_pres_server USING    fp_p_file        TYPE localfile " Local file for upload/download
                                 CHANGING fp_i_upload_file TYPE tt_upload_file.

*--------------------------------------------------------------------*
*  Local Type Declaration
*--------------------------------------------------------------------*
  TYPES : BEGIN OF ty_data_tab,
            record TYPE char200, " Record of type CHAR500
          END OF ty_data_tab.

*--------------------------------------------------------------------*
*  Local Internal table
*--------------------------------------------------------------------*
  DATA: li_data_tab    TYPE STANDARD TABLE OF ty_data_tab INITIAL SIZE 0,

*--------------------------------------------------------------------*
*  Local Work-Area
*--------------------------------------------------------------------*
        lst_data_tab   TYPE ty_data_tab,
        lst_upload_txt TYPE ty_upload_file,
        lv_p_file      TYPE string.

*--------------------------------------------------------------------*
*  Local Constant Declaration
*--------------------------------------------------------------------*
  CONSTANTS: lc_pipe TYPE char1 VALUE '|'. " Pipe of type CHAR1

  CLEAR lv_p_file.
  lv_p_file = fp_p_file.

  CLEAR li_data_tab.
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = lv_p_file
    TABLES
      data_tab                = li_data_tab
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16.
  IF sy-subrc IS INITIAL.
*Remove the header line
    IF cb_hdr IS NOT INITIAL.
      DELETE li_data_tab INDEX 1.
    ENDIF. " IF cb_hdr IS NOT INITIAL

    CLEAR lst_data_tab.
    LOOP AT li_data_tab INTO lst_data_tab.
      CLEAR : lst_upload_txt.
      SPLIT lst_data_tab-record AT lc_pipe INTO  lst_upload_txt-vbeln
                                            lst_upload_txt-forwd
                                            lst_upload_txt-forwd_fun
                                            lst_upload_txt-sold_to
                                            lst_upload_txt-sold_to_fun
                                            lst_upload_txt-ship_to
                                            lst_upload_txt-ship_to_fun
                                            lst_upload_txt-waerk
                                            lst_upload_txt-posnr.
      APPEND lst_upload_txt TO fp_i_upload_file.
      CLEAR  lst_upload_txt.
    ENDLOOP. " LOOP AT li_data_tab INTO lst_data_tab
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FILE_FRM_APP_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_UPLOAD_FILE  text
*----------------------------------------------------------------------*
FORM f_read_file_frm_app_server  USING fp_p_file         TYPE localfile " Local file for upload/download
                              CHANGING fp_i_upload_file  TYPE tt_upload_file.

*--------------------------------------------------------------------*
*  Local Work-area
*--------------------------------------------------------------------*
  DATA: lst_string     TYPE string,
*        lst_string2    TYPE string,
        lst_upload_txt TYPE ty_upload_file,
*--------------------------------------------------------------------*
*  Local Variable
*--------------------------------------------------------------------*
        lv_file        TYPE localfile. " Local file for upload/download

*--------------------------------------------------------------------*
*  Local Constant Declaration
*--------------------------------------------------------------------*
  CLEAR lv_file.
  lv_file = fp_p_file.

*--------------------------------------------------------------------*
* Open Dataset
*--------------------------------------------------------------------*
  OPEN DATASET lv_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
  IF sy-subrc EQ 0.
    DO.
      CLEAR: lst_string.
*--------------------------------------------------------------------*
*  Read Dataset
*--------------------------------------------------------------------*
      READ DATASET lv_file INTO lst_string.
      IF sy-subrc NE 0.
        EXIT.
      ELSE. " ELSE -> IF sy-subrc NE 0
*        SPLIT lst_string AT c_con_tab2 INTO lst_string2 lst_upload_txt. " Ratio of the corrected value to the original value (CV:OV).
        SPLIT lst_string  AT c_con_tab INTO  lst_upload_txt-vbeln
                                      lst_upload_txt-forwd
                                      lst_upload_txt-forwd_fun
                                      lst_upload_txt-sold_to
                                      lst_upload_txt-sold_to_fun
                                      lst_upload_txt-ship_to
                                      lst_upload_txt-ship_to_fun
                                      lst_upload_txt-waerk
                                      lst_upload_txt-posnr.
        APPEND lst_upload_txt TO fp_i_upload_file.
        CLEAR lst_upload_txt.
      ENDIF. " IF sy-subrc NE 0
    ENDDO.
*--------------------------------------------------------------------*
*  Close Dataset
*--------------------------------------------------------------------*
    CLOSE DATASET lv_file.
  ENDIF. " IF sy-subrc EQ 0

* Remove the header line
  IF cb_hdr IS NOT INITIAL.
    DELETE fp_i_upload_file INDEX 1.
  ENDIF. " IF cb_hdr IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_fetch_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_UPLOAD_FILE  text
*      <--P_I_FINAL  text
*----------------------------------------------------------------------*
FORM f_fetch_data.
*
  DATA : lv_quotation_no TYPE vbeln_va,                                    " Sales Document
         li_renwl_plan   TYPE tt_renwl_plan,
         lst_renwl_tmp   TYPE zqtc_renwl_plan,                             " E095: Renewal Plan Table
         lst_bapi_view   TYPE order_view,                                  " View for Mass Selection of Sales Orders
         lst_renwl_plan1 TYPE zqtc_renwl_plan,                             " E095: Renewal Plan Table
         lst_final       TYPE ty_final,
         li_sales        TYPE STANDARD TABLE OF sales_key  INITIAL SIZE 0, " Structure for Mass Accesses to SD Documents
         li_item         TYPE STANDARD TABLE OF bapisdit   INITIAL SIZE 0, " Structure of VBAP with English Field Names
         li_partner      TYPE STANDARD TABLE OF bapisdpart INITIAL SIZE 0, " BAPI Structure of VBPA with English Field Names
         li_header       TYPE STANDARD TABLE OF bapisdhd   INITIAL SIZE 0, " BAPI Structure of VBAK with English Field Names
         li_business     TYPE STANDARD TABLE OF bapisdbusi INITIAL SIZE 0, " BAPI Structure of VBKD
         li_textheaders  TYPE STANDARD TABLE OF bapisdtehd INITIAL SIZE 0, " BAPI Structure of THEAD with English Field Names
         li_textlines    TYPE STANDARD TABLE OF bapitextli INITIAL SIZE 0, " BAPI Structure for STX_LINES Structure
         li_contract     TYPE STANDARD TABLE OF bapisdcntr INITIAL SIZE 0, " BAPI Structure of VEDA with English Field Names
         li_return       TYPE STANDARD TABLE OF bapiret2   INITIAL SIZE 0, " Return Parameter
         li_docflow      TYPE STANDARD TABLE OF bapisdflow INITIAL SIZE 0, " BAPI Structure of VBFA with English Field Names
         li_final        TYPE STANDARD TABLE OF ty_final   INITIAL SIZE 0.


  MOVE-CORRESPONDING i_upload_file TO i_final.
  IF i_upload_file IS NOT INITIAL.
    PERFORM f_fetch_renwl_plan CHANGING li_renwl_plan.
  ENDIF. " IF i_upload_file IS NOT INITIAL

  MOVE-CORRESPONDING i_upload_file TO li_sales.
  DELETE ADJACENT DUPLICATES FROM li_sales.

  lst_bapi_view-header   = abap_true.
  lst_bapi_view-item     = abap_true.
  lst_bapi_view-business = abap_true.
  lst_bapi_view-partner  = abap_true.
  lst_bapi_view-text     = abap_true.
  lst_bapi_view-contract = abap_true.
  lst_bapi_view-flow     = abap_true.

  CALL FUNCTION 'BAPISDORDER_GETDETAILEDLIST'
    EXPORTING
      i_bapi_view           = lst_bapi_view
    TABLES
      sales_documents       = li_sales
      order_headers_out     = li_header
      order_items_out       = li_item
      order_business_out    = li_business
      order_partners_out    = li_partner
      order_contracts_out   = li_contract
      order_textheaders_out = li_textheaders
      order_textlines_out   = li_textlines
      order_flows_out       = li_docflow.

  CLEAR : li_final.
  li_final[] = i_final[].
  CLEAR: i_final.

  LOOP AT li_final INTO lst_final.
    READ TABLE li_renwl_plan INTO lst_renwl_plan1 WITH KEY vbeln = lst_final-vbeln.
    IF sy-subrc = 0.
      LOOP AT li_renwl_plan INTO lst_renwl_plan1 WHERE vbeln = lst_final-vbeln.
        lst_final-act_status = lst_renwl_plan1-act_status.
        lst_final-posnr = lst_renwl_plan1-posnr.
        APPEND lst_final TO i_final.
      ENDLOOP. " LOOP AT li_renwl_plan INTO lst_renwl_plan1 WHERE vbeln = lst_final-vbeln
    ELSE. " ELSE -> IF sy-subrc = 0
      CLEAR : lst_final-posnr.
      APPEND lst_final TO i_final.
    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT li_final INTO lst_final
  CLEAR: li_final, lst_renwl_plan1, lst_final.

  LOOP AT i_final ASSIGNING FIELD-SYMBOL(<lst_final>).
    READ TABLE li_renwl_plan INTO lst_renwl_tmp WITH KEY vbeln = <lst_final>-vbeln
                                                         posnr = <lst_final>-posnr.
    IF sy-subrc = 0.
      IF <lst_final>-act_status = abap_true.
        <lst_final>-message = 'Activity already Preformed'(a12).
      ELSE. " ELSE -> IF <lst_final>-act_status = abap_true

        PERFORM f_create_quotation USING  li_header
                                          li_item
                                          li_business
                                          li_partner
                                          li_textheaders
                                          li_textlines
                                          li_contract
                                 CHANGING <lst_final>
                                          lv_quotation_no
                                          <lst_final>-act_status
                                          <lst_final>-message
                                          li_return.

* If any activity successfully performed up date the custom table
        IF <lst_final>-act_status IS NOT INITIAL.
          READ TABLE li_renwl_plan INTO DATA(lst_renwl_plan) WITH KEY vbeln = <lst_final>-vbeln
                                                                          BINARY SEARCH.
          IF sy-subrc EQ 0.
            MOVE-CORRESPONDING lst_renwl_plan TO lst_renwl_tmp.
            lst_renwl_tmp-act_status = abap_true.
            lst_renwl_tmp-aedat = sy-datum.
            lst_renwl_tmp-aezet = sy-uzeit.
            lst_renwl_tmp-aenam = sy-uname.
            APPEND lst_renwl_tmp TO i_renwl_tmp.
            CLEAR  lst_renwl_tmp.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF <lst_final>-act_status IS NOT INITIAL
      ENDIF. " IF <lst_final>-act_status = abap_true
    ELSE. " ELSE -> IF sy-subrc = 0
      <lst_final>-message = 'Order not found'(a14).
    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT i_final ASSIGNING FIELD-SYMBOL(<lst_final>)

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_fetch_RENWL_PLAN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LI_RENWL_PLAN  text
*----------------------------------------------------------------------*
FORM f_fetch_renwl_plan  CHANGING fp_li_renwl_plan TYPE tt_renwl_plan.

  SELECT *
  FROM zqtc_renwl_plan " E095: Renewal Plan Table
  INTO TABLE fp_li_renwl_plan
  FOR ALL ENTRIES IN i_upload_file
  WHERE vbeln = i_upload_file-vbeln
  AND activity IN s_activ
  ORDER BY PRIMARY KEY.
  IF sy-subrc EQ 0.
* Do Nothing.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_QUOATATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<LST_FINAL>_VBELN  text
*      -->P_LI_HEADER  text
*      -->P_LI_ITEM  text
*      -->P_LI_BUSINESS  text
*      -->P_LI_PARTNER  text
*      -->P_LI_TEXTHEADERS  text
*      -->P_LI_TEXTLINES  text
*      -->P_LI_CONTRACT  text
*      <--P_LV_QUOTATION_NO  text
*      <--P_<LST_FINAL>_ACT_STATUS  text
*      <--P_<LST_FINAL>_MESSAGE  text
*      <--P_LI_RETURN  text
*----------------------------------------------------------------------*
FORM f_create_quotation  USING     fp_i_header    TYPE tt_header
                                   fp_i_item      TYPE tt_item
                                   fp_i_business   TYPE tt_business
                                   fp_i_partner  TYPE tt_partner
                                   fp_i_textheaders  TYPE tt_textheaders
                                   fp_i_textlines    TYPE tt_textlines
                                   fp_i_contract     TYPE tt_contract
                           CHANGING fp_lst_final   TYPE ty_final           " Sales and Distribution Document Number
                                    fp_v_salesord     TYPE bapivbeln-vbeln " Sales Document
                                    fp_v_act_status   TYPE zact_status     " Activity Status
                                    fp_message        TYPE char120         " Message of type CHAR120
                                    fp_i_return       TYPE tt_return.

  DATA: lr_header             TYPE REF TO bapisdhd1,                            " Reference for header data
        lr_i_partner          TYPE REF TO bapisdpart,                           "Reference for partner
        lr_i_header           TYPE REF TO bapisdhd,                             " Reference for bapi header
        li_partner            TYPE STANDARD TABLE OF bapiparnr INITIAL SIZE 0,  " Internal table for partner details
        li_business           TYPE STANDARD TABLE OF bapisdbusi INITIAL SIZE 0, " BAPI Structure of VBKD with English Field Names
        li_return             TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0,   " reference variable for return
        lr_sales_contract_in  TYPE  REF TO bapictr ,                            " contract data
        li_sales_contract_in  TYPE STANDARD TABLE OF bapictr ,                  " Internal  table for cond
        lr_sales_contract_inx TYPE REF TO  bapictrx ,                           " Communication fields: SD Contract Data Checkbox
        li_sales_contract_inx TYPE  STANDARD TABLE OF bapictrx INITIAL SIZE 0 , " Communication fields: SD Contract Data Checkbox
        lr_partner            TYPE REF TO bapiparnr,                            " refrence for partner
        li_item               TYPE STANDARD TABLE OF bapisditm INITIAL SIZE 0,  " Items
        lr_item               TYPE REF TO bapisditm,                            " reference variable for Item
        lr_business           TYPE REF TO bapisdbusi,                           " VBKD data
        li_itemx              TYPE STANDARD TABLE OF bapisditmx INITIAL SIZE 0, " reference for itemx
        lr_contract           TYPE REF TO bapisdcntr,                           " BAPI Structure of VEDA
        lr_return             TYPE REF TO bapiret2,                             " BAPI return
        lst_bapisdls          TYPE bapisdls,                                    " SD Checkbox for the Logic Switch
        li_order_schedules_in TYPE STANDARD TABLE OF bapischdl INITIAL SIZE 0,  " Communication Fields for Maintaining SD Doc. Schedule Lines
        lr_order_schedules_in TYPE REF TO bapischdl,                            "  class
        lr_itemx              TYPE REF TO bapisditmx,                           " reference for itemx
        lr_i_item             TYPE REF TO bapisdit,                             " reference for itemx
        lr_i_business         TYPE REF TO bapisdbusi,                           "  class
        lr_headerx            TYPE REF TO bapisdhd1x.                           "  class

  DATA : lv_smatn TYPE smatn.

  CONSTANTS: lc_quotation TYPE vbtyp VALUE 'B',             " quotation type
             lc_contract  TYPE vbtyp VALUE 'G',             " contract
             lc_b         TYPE knprs VALUE 'B',             " Copy manual pricing elements and redetermine the others
             lc_insert    TYPE char1 VALUE 'I',             " iNSERT
             lc_posnr_low TYPE vbap-posnr    VALUE '00000', " Sales Document Item
             lc_days      TYPE t5a4a-dlydy VALUE '00',      " Days
             lc_month     TYPE t5a4a-dlymo  VALUE '00',     " Month
             lc_year      TYPE t5a4a-dlyyr  VALUE '01',     " Year
             lc_kappl     TYPE kappl VALUE 'V',
             lc_kschl     TYPE kschd VALUE 'Z001'.

  CREATE DATA: lr_header,
               lr_headerx,
               lr_partner,
               lr_i_partner,
               lr_sales_contract_inx,
               lr_sales_contract_in,
               lr_item,
               lr_itemx.

  DATA(li_item_tmp) = fp_i_item[].
  DELETE li_item_tmp WHERE doc_number <> fp_lst_final-vbeln.

  READ TABLE fp_i_header REFERENCE INTO lr_i_header WITH KEY doc_number = fp_lst_final-vbeln.

  IF sy-subrc = 0.
    lr_header->sd_doc_cat = lc_quotation.
  ENDIF. " IF sy-subrc = 0
  lr_header->doc_type = p_qtype.
  lr_header->sales_org = lr_i_header->sales_org.
  lr_header->sales_off = lr_i_header->sales_off.
  lr_header->distr_chan = lr_i_header->distr_chan.
  lr_header->division = lr_i_header->division.
  lr_header->ref_doc = lr_i_header->doc_number. "low.
  lr_header->ref_doc_l = lr_i_header->doc_number.
  lr_header->refdoc_cat = lc_contract. "'G'.
  lr_header->refdoctype = lc_contract. "'G'.
  lr_header->ref_1 = lr_i_header->doc_number.
  lr_header->refobjtype = 'VBAK'.
  lr_header->refobjkey = lr_i_header->doc_number.
  lr_header->po_method = lr_i_header->po_method.
  lr_header->currency = fp_lst_final-waerk.

  READ TABLE fp_i_business REFERENCE INTO lr_i_business WITH KEY sd_doc     =   lr_i_header->doc_number
                                                                 itm_number =   lc_posnr_low.
  IF sy-subrc = 0.
    lr_header->price_grp  =  lr_i_business->price_grp.
  ENDIF. " IF sy-subrc = 0
*
  READ TABLE fp_i_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_header->doc_number.
  IF sy-subrc = 0.
    lr_header->qt_valid_f = lr_contract->contenddat + 1.
    lr_header->price_date = lr_header->qt_valid_f.

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = lr_header->qt_valid_f
        days      = lc_days
        months    = lc_month
        years     = lc_year
      IMPORTING
        calc_date = lr_header->qt_valid_t.
    lr_header->qt_valid_t = lr_header->qt_valid_t - 1.

    lr_sales_contract_inx->updateflag = lc_insert.
    lr_sales_contract_in->con_st_dat = lr_contract->contenddat + 1.
    lr_sales_contract_inx->con_st_dat = abap_true.

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = lr_sales_contract_in->con_st_dat
        days      = lc_days
        months    = lc_month
        years     = lc_year
      IMPORTING
        calc_date = lr_sales_contract_in->con_en_dat.
    lr_sales_contract_in->con_en_dat = lr_sales_contract_in->con_en_dat - 1.
    lr_sales_contract_inx->con_en_dat = abap_true.
    APPEND lr_sales_contract_in->* TO li_sales_contract_in.
    CLEAR lr_sales_contract_in->*.
    APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
    CLEAR lr_sales_contract_inx->*.
  ENDIF. " IF sy-subrc = 0
  SELECT SINGLE taxk1 " Alternative tax classification
    FROM vbak         " Sales Document: Header Data
    INTO lr_header->alttax_cls
    WHERE vbeln = lr_header->ref_doc.

  SELECT SINGLE inco1 inco2
    FROM vbkd " Sales Document: Business Data
    INTO (lr_header->incoterms1, lr_header->incoterms2)
    WHERE vbeln = lr_header->ref_doc
    AND posnr = '00000'.
  lr_headerx->refdoc_cat = abap_true.
  lr_headerx->doc_type = abap_true.
  lr_headerx->sales_org = abap_true.
  lr_headerx->distr_chan = abap_true.
  lr_headerx->division = abap_true.
  lr_headerx->ref_doc = abap_true.
  lr_headerx->ref_1 = abap_true.
  lr_headerx->currency = abap_true.

  lr_headerx->updateflag = lc_insert.

  LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE sd_doc     = lr_i_header->doc_number
                                                     AND itm_number = lc_posnr_low.
    lr_partner->partn_role = lr_i_partner->partn_role.
    IF NOT lr_i_partner->customer IS INITIAL.
      lr_partner->partn_numb = lr_i_partner->customer.
    ELSEIF NOT lr_i_partner->person_no IS INITIAL.
      lr_partner->partn_numb = lr_i_partner->person_no.
    ENDIF. " IF NOT lr_i_partner->customer IS INITIAL
    lr_partner->itm_number = lc_posnr_low.
    APPEND lr_partner->* TO li_partner.
    CLEAR lr_partner->*.
  ENDLOOP. " LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE customer IS NOT INITIAL AND sd_doc = lr_i_header->doc_number

  CREATE DATA lr_order_schedules_in.
  LOOP AT li_item_tmp REFERENCE INTO lr_i_item WHERE doc_number  =   fp_lst_final-vbeln
                                               AND   itm_number = fp_lst_final-posnr. "lr_i_header->doc_number.

    lr_item->itm_number = lr_i_item->itm_number.
    lr_itemx->itm_number = lr_i_item->itm_number.

    lr_order_schedules_in->itm_number = lr_i_item->itm_number.
    lr_order_schedules_in->sched_line = '0001'.
    lr_order_schedules_in->req_qty = lr_i_item->target_qty.
*    lr_item->material =  lr_i_item->material.
    SELECT SINGLE smatn FROM kondd AS b INNER JOIN kotd001 AS a
      ON a~knumh = b~knumh
      WHERE a~kappl = @lc_kappl
      AND a~matwa   = @lr_i_item->material
      AND a~kschl   = @lc_kschl
      AND ( datab LE @sy-datum AND datbi GE @sy-datum )
  INTO @lv_smatn.
    IF sy-subrc = 0.
      lr_item->material = lv_smatn.
    ELSE.
      lr_item->material = lr_i_item->material.
    ENDIF.

    lr_item->target_qty =  lr_i_item->target_qty .
    lr_item->target_qu = lr_i_item->target_qu.
    lr_item->plant = lr_i_item->plant.
    lr_item->refobjkey = lr_header->ref_doc.
    lr_item->refobjtype =  'VBAK'.

    READ TABLE fp_i_business REFERENCE INTO lr_i_business WITH KEY sd_doc     = lr_i_header->doc_number
                                                                   itm_number = lr_i_item->itm_number.
    IF sy-subrc = 0.
      lr_item->po_method = lr_i_business->po_method.
      lr_item->ref_1 = lr_i_business->ref_1.

      lr_item->price_grp = lr_i_business->price_grp.
      lr_item->cust_group = lr_i_business->cust_group. "Customer Group
    ENDIF. " IF sy-subrc = 0

    LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE sd_doc     = lr_i_header->doc_number
                                                       AND itm_number = lr_i_item->itm_number.
      lr_partner->partn_role = lr_i_partner->partn_role.
      IF NOT lr_i_partner->customer IS INITIAL.
        lr_partner->partn_numb = lr_i_partner->customer.
      ELSEIF NOT lr_i_partner->person_no IS INITIAL.
        lr_partner->partn_numb = lr_i_partner->person_no.
      ENDIF. " IF NOT lr_i_partner->customer IS INITIAL
      lr_partner->itm_number = lr_i_partner->itm_number.
      APPEND lr_partner->* TO li_partner.
      CLEAR lr_partner->*.
    ENDLOOP. " LOOP AT fp_i_partner REFERENCE INTO lr_i_partner WHERE itm_number = lr_i_item->itm_number

    IF NOT lr_i_item->ref_doc IS INITIAL.
      lr_item->ref_doc  =   lr_i_item->ref_doc.
    ENDIF. " IF NOT lr_i_item->ref_doc IS INITIAL
    lr_item->hg_lv_item = lr_i_item->hg_lv_item.
    IF NOT lr_i_item->itm_number IS INITIAL.
      lr_item->ref_doc_it = lr_i_item->itm_number.
    ENDIF. " IF NOT lr_i_item->itm_number IS INITIAL
    IF lr_i_item->doc_cat_sd IS NOT INITIAL.
      lr_item->ref_doc_ca = lr_i_item->doc_cat_sd.
    ELSE. " ELSE -> IF lr_i_item->doc_cat_sd IS NOT INITIAL
      lr_item->ref_doc_ca = lc_contract.
    ENDIF. " IF lr_i_item->doc_cat_sd IS NOT INITIAL
    lr_item->ref_doc = lr_header->ref_doc.

    READ TABLE fp_i_contract REFERENCE INTO lr_contract WITH KEY doc_number = lr_i_item->doc_number
                                                                 itm_number = lr_i_item->itm_number.
    IF sy-subrc = 0.
      lr_sales_contract_inx->updateflag = lc_insert.
      lr_sales_contract_in->itm_number = lr_i_item->itm_number.
      lr_sales_contract_inx->itm_number = lr_i_item->itm_number.
      lr_sales_contract_in->con_st_dat = lr_contract->contenddat + 1.
      lr_sales_contract_inx->con_st_dat = abap_true.
      lr_header->price_date = lr_sales_contract_in->con_st_dat.

      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
        EXPORTING
          date      = lr_sales_contract_in->con_st_dat
          days      = lc_days
          months    = lc_month
          years     = lc_year
        IMPORTING
          calc_date = lr_sales_contract_in->con_en_dat.
      lr_sales_contract_in->con_en_dat = lr_sales_contract_in->con_en_dat - 1.
      lr_sales_contract_inx->con_en_dat = abap_true.
      APPEND lr_sales_contract_in->* TO li_sales_contract_in.
      CLEAR lr_sales_contract_in->*.
      APPEND lr_sales_contract_inx->* TO li_sales_contract_inx.
      CLEAR lr_sales_contract_inx->*.
    ENDIF. " IF sy-subrc = 0
    APPEND lr_item->* TO li_item.
    CLEAR lr_item->*.
    APPEND lr_order_schedules_in->* TO li_order_schedules_in.
    CLEAR  lr_order_schedules_in->*.
  ENDLOOP. " LOOP AT li_item_tmp REFERENCE INTO lr_i_item WHERE doc_number = fp_lst_final-vbeln

  SORT li_partner BY partn_role partn_numb.
  DELETE ADJACENT DUPLICATES FROM li_partner COMPARING partn_role partn_numb.

* Update partner details as per the feed file.
  IF fp_lst_final-forwd IS NOT INITIAL AND
     fp_lst_final-forwd_fun IS NOT INITIAL.

    PERFORM f_update_partner USING  fp_lst_final-forwd_fun
                           CHANGING fp_lst_final-forwd
                                    li_partner.
  ENDIF. " IF fp_lst_final-forwd IS NOT INITIAL AND

  IF fp_lst_final-sold_to IS NOT INITIAL AND
     fp_lst_final-sold_to_fun IS NOT INITIAL.
    PERFORM f_update_partner USING
                                    fp_lst_final-sold_to_fun
                           CHANGING fp_lst_final-sold_to
                                     li_partner.
  ENDIF. " IF fp_lst_final-sold_to IS NOT INITIAL AND

  IF fp_lst_final-ship_to IS NOT INITIAL AND
   fp_lst_final-ship_to_fun IS NOT INITIAL.
    PERFORM f_update_partner USING
                                    fp_lst_final-ship_to_fun
                            CHANGING fp_lst_final-ship_to
                                     li_partner.
  ENDIF. " IF fp_lst_final-ship_to IS NOT INITIAL AND

  lst_bapisdls-pricing = lc_b.

  CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
    EXPORTING
      sales_header_in       = lr_header->*
      int_number_assignment = abap_true
      logic_switch          = lst_bapisdls
      testrun               = p_test
    IMPORTING
      salesdocument_ex      = fp_v_salesord
    TABLES
      return                = li_return
      sales_items_in        = li_item
      sales_partners        = li_partner
      sales_schedules_in    = li_order_schedules_in
      sales_contract_in     = li_sales_contract_in
      sales_contract_inx    = li_sales_contract_inx
      textheaders_ex        = fp_i_textheaders
      textlines_ex          = fp_i_textlines.
  READ TABLE li_return REFERENCE INTO lr_return WITH KEY type = 'E'.
  IF sy-subrc <> 0.
    IF  p_test EQ space .
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
      fp_v_act_status = abap_true.
      CONCATENATE 'Quotation'(a10) fp_v_salesord 'created'(a11) INTO fp_message
      SEPARATED BY space.
    ELSE. " ELSE -> IF p_test EQ space
      CONCATENATE 'Quotation'(a10) fp_v_salesord 'can be created'(x11) INTO fp_message
      SEPARATED BY space.
    ENDIF. " IF p_test EQ space

  ELSE. " ELSE -> IF sy-subrc <> 0
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    APPEND LINES OF li_return TO fp_i_return.
    LOOP AT li_return REFERENCE INTO  lr_return WHERE type = 'E'.
      IF sy-tabix = 1.
        CONCATENATE 'Quotation failed'(a13) fp_message INTO fp_message.
      ELSE. " ELSE -> IF sy-tabix = 1
        CONCATENATE fp_message lr_return->message INTO fp_message SEPARATED BY space.
      ENDIF. " IF sy-tabix = 1

    ENDLOOP. " LOOP AT li_return REFERENCE INTO lr_return WHERE type = 'E'

  ENDIF. " IF sy-subrc <> 0


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CATALOG
*&---------------------------------------------------------------------*
*       Populate field catalog
*----------------------------------------------------------------------*
*  <--  fp_i_fca       Field Ctalog
*----------------------------------------------------------------------*
FORM f_popul_field_catalog.

*   Populate the field catalog
  DATA : lv_col_pos TYPE sycucol. " Col_pos of type Integers

*Constant for hold for alv tablename
  CONSTANTS: lc_tabname         TYPE slis_tabname VALUE 'I_FINAL', "Tablename for Alv Display
* Constent for hold the alv field catelog
             lc_fld_vbeln       TYPE slis_fieldname VALUE  'VBELN',
             lc_fld_posnr       TYPE slis_fieldname VALUE  'POSNR',
             lc_fld_forwd       TYPE slis_fieldname VALUE  'FORWD',
             lc_fld_forwd_fun   TYPE slis_fieldname VALUE  'FORWD_FUN',
             lc_fld_sold_to     TYPE slis_fieldname VALUE  'SOLD_TO',
             lc_fld_sold_to_fun TYPE slis_fieldname VALUE  'SOLD_TO_FUN',
             lc_fld_ship_to     TYPE slis_fieldname VALUE  'SHIP_TO',
             lc_fld_ship_to_fun TYPE slis_fieldname VALUE  'SHIP_TO_FUN',
             lc_fld_waerk       TYPE slis_fieldname VALUE  'WAERK',
             lc_fld_act_status  TYPE slis_fieldname VALUE  'ACT_STATUS',
             lc_fld_message     TYPE slis_fieldname VALUE  'MESSAGE'.

* Populate field catalog

* Invoice Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_vbeln  lc_tabname   lv_col_pos  'Sales Document'(A01)
                       CHANGING i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_posnr  lc_tabname   lv_col_pos  'Document Item'(A02)
                       CHANGING i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_forwd  lc_tabname   lv_col_pos  'Freight forwarder'(A03)
                       CHANGING i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_forwd_fun  lc_tabname   lv_col_pos  'Parnter Function'(A04)
                       CHANGING i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_sold_to  lc_tabname   lv_col_pos  'Sold To'(A05)
                       CHANGING i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_sold_to_fun  lc_tabname   lv_col_pos  'Parnter Function'(A04)
                       CHANGING i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_ship_to  lc_tabname   lv_col_pos  'Ship To '(A06)
                       CHANGING i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_ship_to_fun  lc_tabname   lv_col_pos  'Parnter Function'(A04)
                       CHANGING i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_waerk lc_tabname   lv_col_pos  'Currency'(A07)
                       CHANGING i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_act_status  lc_tabname   lv_col_pos  'Activity Status'(A08)
                       CHANGING i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_message lc_tabname   lv_col_pos  'Message'(A09)
                       CHANGING i_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*       Display ALV
*----------------------------------------------------------------------*
*      -->FP_I_FCAT  Field catalogiue
*      -->FP_I_FINAL Output table
*----------------------------------------------------------------------*
FORM f_display_alv.

  DATA: lst_layout   TYPE slis_layout_alv.

  CONSTANTS : lc_top_of_page TYPE slis_formname  VALUE 'F_TOP_OF_PAGE'.

  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = lc_top_of_page
      is_layout              = lst_layout
      it_fieldcat            = i_fcat
      i_save                 = abap_true
      i_default              = space
    TABLES
      t_outtab               = i_final
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT_HOTSPOT
*&---------------------------------------------------------------------*
*       Build hotspot
*----------------------------------------------------------------------*
*      -->fp_field  field name
*      -->fp_tabname  Table name
*      -->fp_col_pos  column position
*      <--FP_I_FCAT  Field catalogue
*----------------------------------------------------------------------*
FORM f_build_fcat_hotspot USING fp_field    TYPE slis_fieldname
                                 fp_tabname  TYPE slis_tabname
                                 fp_col_pos  TYPE sycucol " Col_pos of type Integers
                                 fp_text     TYPE char50  " Text of type CHAR50
                        CHANGING fp_i_fcat   TYPE slis_t_fieldcat_alv.
  DATA: lst_fcat   TYPE slis_fieldcat_alv.
  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '30'. " Output Length

  lst_fcat-lowercase   = abap_true.
  lst_fcat-key         = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-hotspot     = abap_true.
  lst_fcat-seltext_m   = fp_text.
  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT_HOTSPOT
*&---------------------------------------------------------------------*
*       Build hotspot
*----------------------------------------------------------------------*
*      -->fp_field  field name
*      -->fp_tabname  Table name
*      -->fp_col_pos  column position
*      <--FP_I_FCAT  Field catalogue
*----------------------------------------------------------------------*
FORM f_build_fcat USING fp_field    TYPE slis_fieldname
                                 fp_tabname  TYPE slis_tabname
                                 fp_col_pos  TYPE sycucol " Col_pos of type Integers
                                 fp_text     TYPE char50  " Text of type CHAR50
                        CHANGING fp_i_fcat   TYPE slis_t_fieldcat_alv.
  DATA: lst_fcat   TYPE slis_fieldcat_alv.
  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '30'. " Output Length

  lst_fcat-lowercase   = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-seltext_m   = fp_text.
  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.

ENDFORM.

FORM f_user_command USING fp_ucomm TYPE syst_ucomm " ABAP System Field: PAI-Triggering Function Code
                          fp_lst_selfield TYPE slis_selfield.

  CONSTANTS :lc_fld_vbeln TYPE slis_fieldname VALUE 'VBELN',
             lc_ic1       TYPE syst_ucomm     VALUE '&IC1'. " ABAP System Field: PAI-Triggering Function Code


  CASE fp_ucomm.
    WHEN lc_ic1.
* User double clicks any Invoice number then tcode VF03 is called from ALV.
      READ TABLE i_final INTO DATA(lst_final) INDEX fp_lst_selfield-tabindex .
      IF sy-subrc = 0.
        IF fp_lst_selfield-fieldname = lc_fld_vbeln
               AND NOT lst_final-vbeln IS INITIAL.
          SET PARAMETER ID 'KTN' FIELD lst_final-vbeln.
          CALL TRANSACTION 'VA43' AND SKIP FIRST SCREEN.
        ENDIF. " IF fp_lst_selfield-fieldname = lc_fld_vbeln
      ENDIF. " IF sy-subrc = 0

* Do nothing
  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_top_of_page.
*ALV Header declarations
  DATA: li_header  TYPE slis_t_listheader,
        lst_header TYPE slis_listheader.

* Constant
  CONSTANTS :     lc_typ_h TYPE char1 VALUE 'H'. " Typ_h of type CHAR1
* TITLE
  lst_header-typ = lc_typ_h . "'H'
  lst_header-info = 'Create Quotation'(H01).
  APPEND lst_header TO li_header.
  CLEAR lst_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_header.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_PARTNER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_FINAL_FORWD  text
*      -->P_LST_FINAL_FORWD_FUN  text
*      <--P_LI_PARTNER  text
*----------------------------------------------------------------------*
FORM f_update_partner  USING     fp_parvw  TYPE parvw " Partner Function
                       CHANGING  fp_kunnr TYPE kunnr  " Customer Number
                                 fp_li_partner  TYPE tt_partner_f.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = fp_kunnr
    IMPORTING
      output = fp_kunnr.

  READ TABLE fp_li_partner ASSIGNING FIELD-SYMBOL(<lst_partner>) WITH KEY partn_role = fp_parvw.
  IF sy-subrc = 0.
    <lst_partner>-partn_numb = fp_kunnr.
  ELSE. " ELSE -> IF sy-subrc = 0
    APPEND INITIAL LINE TO fp_li_partner ASSIGNING <lst_partner>.
    <lst_partner>-partn_role = fp_parvw.
    <lst_partner>-partn_numb = fp_kunnr.
  ENDIF. " IF sy-subrc = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_ACTIVITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_activity .

  SELECT SINGLE activity " E095: Activity
    FROM zqtc_activity   " E095: Activity Table
     INTO @DATA(lv_activity)
     WHERE activity IN @s_activ.
  IF sy-subrc NE 0.
    MESSAGE e216(zqtc_r2). " Invalid Activity.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_QUOTATION_TYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_quotation_type.

  SELECT SINGLE auart " E095: Activity
    FROM tvak         " Sales Document Types
     INTO @DATA(lv_auart)
     WHERE auart = @p_qtype.
  IF sy-subrc NE 0.
    MESSAGE e217(zqtc_r2). " Invalid Activity.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_AUTO_RENEWAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_auto_renewal .

  IF i_renwl_tmp IS NOT INITIAL AND p_test IS INITIAL.
    CALL FUNCTION 'ZQTC_UPDATE_AUTO_RENEWAL' IN UPDATE TASK
      TABLES
        t_renwl_plan = i_renwl_tmp.
    COMMIT WORK AND WAIT.
  ENDIF. " IF li_renwl_tmp IS NOT INITIAL AND p_test IS INITIAL

ENDFORM.
