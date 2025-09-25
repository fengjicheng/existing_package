*&---------------------------------------------------------------------*
*&  Include           ZQTCR_SALES_PARTNER_SEL
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_SALES_ORDER_UPDATE
* PROGRAM DESCRIPTION: Update Partner Email IDs in Sales Documents
* DEVELOPER: Nageswar (NPOLINA)
* CREATION DATE: 06/25/2018
* OBJECT ID: E208/INC0236477
* TRANSPORT NUMBER(S):  ED2K915303
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
* TRANSPORT NUMBER(S):
*------------------------------------------------------------------- *

FORM f_f4_file_name  CHANGING fp_p_file TYPE rlgrap-filename. " Local file for upload/download 1

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
FORM f_convert_ord_excel USING fp_p_file  TYPE rlgrap-filename " Local file for upload/download 5
                               CHANGING fp_i_final TYPE tt_excel.

  DATA :    li_excel        TYPE STANDARD TABLE OF zqtc_alsmex_tabline " Rows for Table with Excel Data
                                  INITIAL SIZE 0,                  " Rows for Table with Excel Data
            lst_excel_dummy TYPE zqtc_alsmex_tabline,             " Rows for Table with Excel Data
            lst_excel       TYPE zqtc_alsmex_tabline,             " Rows for Table with Excel Data
            lst_final       TYPE ty_excel,
            lv_posnr1       TYPE posnr,
            lv_ole          TYPE char1.

  WHILE lv_ole IS INITIAL.
    CALL FUNCTION 'ZQTC_EXCEL_TO_INTERNAL_TABLE'
      EXPORTING
        filename                = p_file
        i_begin_col             = 1
        i_begin_row             = 2       " File contains header
        i_end_col               = 35
        i_end_row               = 65000
      TABLES
        intern                  = li_excel
      EXCEPTIONS
        inconsistent_parameters = 1
        upload_ole              = 2
        OTHERS                  = 3.

    IF sy-subrc EQ 0.
      IF li_excel[] IS NOT INITIAL.

        CLEAR lst_final.
        LOOP AT li_excel INTO lst_excel.
          lst_excel_dummy = lst_excel.
          IF lst_excel_dummy-value(1) EQ text-sqt.
            lst_excel_dummy-value(1) = space.
            SHIFT lst_excel_dummy-value LEFT DELETING LEADING space.
          ENDIF. " IF lst_excel_dummy-value(1) EQ '''

          AT NEW col.
            CASE lst_excel_dummy-col.
              WHEN 1.
                IF NOT lst_final IS INITIAL.
                  APPEND lst_final TO fp_i_final.
                  CLEAR lst_final.
                ENDIF. " IF NOT lst_final IS INITIAL

                lst_final-vbeln = lst_excel_dummy-value.

                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lst_final-vbeln
                  IMPORTING
                    output = lst_final-vbeln.

                CLEAR lst_excel_dummy.

              WHEN 2.
                lst_final-posnr = lst_excel_dummy-value.
                CLEAR: lst_excel_dummy.
              WHEN 3.
                lst_final-parvw = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 4.
                lst_final-kunnr = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN 5.
                lst_final-email = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

                IF NOT lst_final IS INITIAL.
                  APPEND lst_final TO fp_i_final.
                  CLEAR: lst_final.
                ENDIF. " IF NOT lst_final IS INITIAL

            ENDCASE.
          ENDAT.
        ENDLOOP. " LOOP AT li_excel INTO lst_excel
* For last row population
        IF lst_final IS NOT INITIAL.

          APPEND lst_final TO fp_i_final.
          CLEAR lst_final.
        ENDIF. " IF lst_final IS NOT INITIAL
      ENDIF. " IF li_excel[] IS NOT INITIAL
      lv_ole = abap_true.
    ELSE.

      v_log = 'ERROR : Input file could not read'(061).
    ENDIF. " IF sy-subrc EQ 0
  ENDWHILE.
ENDFORM.
*&-----------------------------------*
*&      Form  DISPLAY_NEW_zopm_ORD_ALV
*&-----------------------------------*
*       text
*-----------------------------------*
*  ->  p1        text
*  <-  p2        text
*-----------------------------------*
FORM f_display_ord_alv .  "6
  DATA:lst_final TYPE ty_excel.
  REFRESH i_fcat_out.

  DATA: lv_counter TYPE sycucol VALUE 1. " Counter of type Integers


  PERFORM f_buildcat USING:
            lv_counter 'VBELN'     'Order'(037)    , "document type
            lv_counter 'POSNR'     'Item Number'(038)    ,       "division
            lv_counter 'PARVW'     'Partner Type'(039)    , "purchase document number
            lv_counter 'KUNNR'     'Business Partner'(040)    , "Sold to
            lv_counter 'EMAIL'     'Email ID'(041)    . "SHip to


* fill up the ALV table
  LOOP AT i_final INTO st_final_x.
    CLEAR: st_output_x.

    st_output_x-vbeln    = st_final_x-vbeln. " Customer Number
    st_output_x-posnr    = st_final_x-posnr. " Customer Number
    st_output_x-parvw    = st_final_x-parvw. " Partner Function
    st_output_x-kunnr    = st_final_x-kunnr. " Customer Number sold to
    st_output_x-email    = st_final_x-email. " Customer Number ship to

    APPEND st_output_x TO i_ord_alv.
    CLEAR st_output_x.
  ENDLOOP. " LOOP AT i_final INTO st_final_x

  IF    i_ord_alv[] IS NOT INITIAL
    AND i_fcat_out IS NOT INITIAL.

    st_layout-box_fieldname = 'SEL'.
    st_layout-colwidth_optimize = abap_true.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program       = sy-repid
        i_callback_pf_status_set = 'F_SET_PF_STATUS'
        i_callback_user_command  = 'F_USER_COMMAND'
        is_layout                = st_layout
        it_fieldcat              = i_fcat_out
      TABLES
        t_outtab                 = i_ord_alv
      EXCEPTIONS
        program_error            = 1
        OTHERS                   = 2.
    IF sy-subrc <> 0.

      MESSAGE e000 WITH 'Material Description'(008).

    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF i_output_x[] IS NOT INITIAL

ENDFORM.
*&-----------------------------------*
*&      Form  F_BUILDCAT
*&-----------------------------------*
*       text
*-----------------------------------*
*      ->P_LV_COUNTER  text
*      ->P_1057   text
*      ->P_TEXT_001  text
*-----------------------------------*
FORM f_buildcat  USING  fp_col   TYPE sycucol   " Horizontal Cursor Position  7
                        fp_fld   TYPE fieldname " Field Name
                        fp_title TYPE itex132.  " Text Symbol length 132

  CONSTANTS:  lc_tabname       TYPE tabname   VALUE 'I_ORD_ALV'. " Table Name

  st_fcat_out-col_pos      = fp_col + 1.
  st_fcat_out-lowercase    = abap_true.
  st_fcat_out-fieldname    = fp_fld.
  st_fcat_out-tabname      = lc_tabname. "'I_OUTPUT_X'.
  st_fcat_out-seltext_m    = fp_title.

  APPEND st_fcat_out TO i_fcat_out.
  CLEAR st_fcat_out.

ENDFORM.
*====================================================================*
*
*====================================================================*
FORM f_set_pf_status USING fp_i_extab TYPE slis_t_extab.  "8
  SET PF-STATUS 'ZQTC_SUBS_ALV'.
ENDFORM.
*====================================================================*
*
*====================================================================*
FORM f_user_command USING fp_ucomm        TYPE sy-ucomm       " ABAP System Field: PAI-Triggering Function Code 9
                          fp_st_selfields TYPE slis_selfield. " ABAP System Field: PAI-Triggering Function Code
  CASE fp_ucomm.
    WHEN 'UPDA'.

      DATA(li_output_x) = i_ord_alv.
      DELETE li_output_x WHERE sel NE abap_true.
      DATA(lv_lines) = lines( li_output_x ).
      IF lv_lines GE v_line_lmt AND p_a_file IS INITIAL.
        PERFORM f_save_file_app_server_submit USING li_output_x.
        PERFORM f_send_notification.
        MESSAGE i555(zqtc_r2) WITH v_line_lmt sy-datum sy-uzeit v_job_name. " The no. of selected lines is greater than & so backgroung job scheduled
        SET SCREEN 0.
        LEAVE SCREEN.
      ELSE. " ELSE -> IF lv_lines GE v_line_lmt AND p_a_file IS INITIAL
        PERFORM f_order_update .
      ENDIF. " IF lv_lines GE v_line_lmt AND p_a_file IS INITIAL

  ENDCASE.
ENDFORM.
*&-----------------------------------*
*&      Form  F_CONTRACT_CREATEFROMDATA
*&-----------------------------------*
*       text
*-----------------------------------*
*  ->  p1        text
*  <-  p2        text
*-----------------------------------*
FORM f_order_update .

  DATA:
    lst_view     TYPE order_view,
    li_vbeln     TYPE TABLE OF sales_key,

    li_hdr_o     TYPE TABLE OF bapisdhd,

    li_itm_o     TYPE TABLE OF bapisdit,

    li_schd_o    TYPE TABLE OF bapisdhedu,

    li_buss_o    TYPE TABLE OF bapisdbusi,

    li_part_o    TYPE TABLE OF bapisdpart,

    li_adr_o     TYPE TABLE OF bapisdcoad,

    li_st_hdr_o  TYPE TABLE OF bapisdhdst,

    li_st_itm_o  TYPE TABLE OF bapisditst,

    li_cond_o    TYPE TABLE OF bapisdcond,

    li_cond_h    TYPE TABLE OF bapicondhd,

    li_cond_i    TYPE TABLE OF bapicondit,

    li_cond_qty  TYPE TABLE OF bapicondqs,

    li_cond_val  TYPE TABLE OF bapicondvs,

    li_contr_o   TYPE TABLE OF bapisdcntr,

    li_txt_h     TYPE TABLE OF bapisdtehd,

    li_txtln_o   TYPE TABLE OF bapitextli,

    li_flow_o    TYPE TABLE OF bapisdflow,

    li_curefs    TYPE TABLE OF bapicurefm,

    li_cucfgs    TYPE TABLE OF bapicucfgm,

    li_cuins     TYPE TABLE OF bapicuinsm,
    li_cuprts    TYPE TABLE OF bapicuprtm,
    li_cuvals    TYPE TABLE OF bapicuvalm,
    li_cublbs    TYPE TABLE OF bapicublbm,
    li_cuvks     TYPE TABLE OF bapicuvkm,
    li_bilpln    TYPE TABLE OF bapisdbpl,
    li_bildate   TYPE TABLE OF bapisdbpld,
    li_cred_cart TYPE TABLE OF bapiccardm,
    li_extens    TYPE TABLE OF bapiparex.

**====================================================================*
**       Local Internal Table
**====================================================================*
  DATA: li_return        TYPE STANDARD TABLE OF bapiret2,  " Return messages
        lst_output_dummy TYPE ty_ord_alv,
        lst_output_head  TYPE ty_ord_alv,
        lst_return       TYPE bapiret2, " For status of contract creation
        lst_hdr          TYPE bapisdh1,
        lst_hdr_x        TYPE bapisdh1x,
        lst_ret          TYPE bapiret2,

        lst_item         TYPE bapisditm,

        lst_item_x       TYPE bapisditmx,

        lst_partn        TYPE bapiparnr,

        lst_part_ch      TYPE bapiparnrc,

        lst_addr         TYPE bapiaddr1,

        lst_cnf_ref      TYPE bapicucfg,

        lst_cnf_ins      TYPE bapicuins,

        lst_cnf_part     TYPE bapicuprt,

        lst_cnf_val      TYPE bapicuval,

        lst_cnf_blob     TYPE bapicublb,

        lst_cnf_vk       TYPE bapicuvk,

        lst_cnf_ref_ins  TYPE bapicuref,

        lst_schl         TYPE bapischdl,

        lst_schl_x       TYPE bapischdlx,

        lst_ordtxt       TYPE bapisdtext,

        lst_ord_keys     TYPE bapisdkey,
        lst_cond         TYPE bapicond,
        lst_cond_x       TYPE bapicondx,
        li_ret           TYPE TABLE OF bapiret2,
        li_item          TYPE TABLE OF bapisditm,
        li_item_x        TYPE TABLE OF bapisditmx,
        li_partn         TYPE TABLE OF bapiparnr,
        li_part_ch       TYPE TABLE OF bapiparnrc,
        li_addr          TYPE TABLE OF bapiaddr1,
        li_cnf_ref       TYPE TABLE OF bapicucfg,
        li_cnf_ins       TYPE TABLE OF bapicuins,
        li_cnf_part      TYPE TABLE OF bapicuprt,
        li_cnf_val       TYPE TABLE OF bapicuval,
        li_cnf_blob      TYPE TABLE OF bapicublb,
        ii_cnf_vk        TYPE TABLE OF bapicuvk,
        li_cnf_ref_ins   TYPE TABLE OF bapicuref,
        li_schl          TYPE TABLE OF bapischdl,
        li_schl_x        TYPE TABLE OF bapischdlx,
        li_ordtxt        TYPE TABLE OF bapisdtext,
        li_ord_keys      TYPE TABLE OF bapisdkey,
        li_cond          TYPE TABLE OF bapicond,
        li_cond_x        TYPE TABLE OF bapicondx.


*====================================================================*
*       Local Variable
*====================================================================*
  DATA:       lv_salesdocin    TYPE bapivbeln-vbeln. "for export field

*====================================================================*
*       Local Constants
*====================================================================*
  CONSTANTS:
    lc_posnr           TYPE posnr  VALUE '000000',     " Item number of the SD document
    lc_bape_vbakx      TYPE char10 VALUE 'BAPE_VBAKX', " Bape_vbak of type CHAR9
    lc_bape_vbapx      TYPE char10 VALUE 'BAPE_VBAPX', " Bape_vbak of type CHAR9
    lc_vbbp            TYPE char4 VALUE 'VBBP',    " Vbbp of type CHAR4
    lc_msgid           TYPE msgid VALUE 'ZQTC_R2', " Message identification
    lc_e               TYPE msgty VALUE 'E',       " Message Type
    lc_msgno           TYPE msgno VALUE '242',     " System Message Number
    lc_msgno2          TYPE msgno VALUE '260',     " System Message Number
    lc_tdid_eal        TYPE tdid VALUE '0012',
    lc_tdid_inv_header TYPE tdid VALUE '0007',
    lc_999             TYPE addr_link VALUE  '999999',
    lc_int(3)          TYPE c VALUE  'INT'.

  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR' "This FM will get the reference of the changed data in ref_grid
    IMPORTING
      e_grid = o_ref_grid.

  IF o_ref_grid IS NOT INITIAL.
    CALL METHOD o_ref_grid->check_changed_data( ).
  ENDIF. " IF o_ref_grid IS NOT INITIAL

** Get Increment of item number in the SD document*
  DATA(li_output) = i_ord_alv.

  DATA(lst_ord_alv) = i_ord_alv[ 1  ].

*
  DATA(li_update) = i_ord_alv.
  DELETE li_update WHERE sel NE abap_true.
*
  IF li_update IS INITIAL.
    MESSAGE 'Select Header and Line Items'(e19) TYPE 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF. " IF li_create_contract IS INITIAL

  LOOP AT li_update INTO DATA(lst_output_x).

    CLEAR:lv_salesdocin.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lst_output_x-vbeln
      IMPORTING
        output = lv_salesdocin.

    FREE:li_vbeln[],li_hdr_o[], li_itm_o[],li_schd_o[],
         li_buss_o[],li_part_o[],li_adr_o[], li_st_hdr_o[],
         li_st_itm_o[],li_cond_o[],li_cond_h[],li_cond_i[],
         li_cond_qty[],li_cond_val[],li_contr_o[],li_txt_h[],
         li_txtln_o[],li_flow_o[],li_curefs[],li_cucfgs[],
         li_cuins[],li_cuprts[],li_cuvals[],li_cublbs[],
         li_cuvks[],li_bilpln[],li_bildate[],li_cred_cart[],li_extens[].

    APPEND INITIAL LINE TO li_vbeln ASSIGNING FIELD-SYMBOL(<lfs_vbeln>).
    <lfs_vbeln>-vbeln = lst_output_x-vbeln.

    CLEAR:lst_view.
    lst_view-header = abap_true.
    lst_view-item  = abap_true.
    lst_view-sdschedule = abap_true.
    lst_view-business = abap_true.
    lst_view-partner = abap_true.
    lst_view-address = abap_true.
    lst_view-status_h = abap_true.
    lst_view-status_i = abap_true.
    lst_view-sdcond = abap_true.
    lst_view-sdcond_add = abap_true.
    lst_view-contract = abap_true.
    lst_view-text = abap_true.


    CALL FUNCTION 'BAPISDORDER_GETDETAILEDLIST' ##FM_SUBRC_OK
      EXPORTING
        i_bapi_view             = lst_view
      TABLES
        sales_documents         = li_vbeln
        order_headers_out       = li_hdr_o
        order_items_out         = li_itm_o
        order_schedules_out     = li_schd_o
        order_business_out      = li_buss_o
        order_partners_out      = li_part_o
        order_address_out       = li_adr_o
        order_statusheaders_out = li_st_hdr_o
        order_statusitems_out   = li_st_itm_o
        order_conditions_out    = li_cond_o
        order_cond_head         = li_cond_h
        order_cond_item         = li_cond_i
        order_cond_qty_scale    = li_cond_qty
        order_cond_val_scale    = li_cond_val
        order_contracts_out     = li_contr_o
        order_textheaders_out   = li_txt_h
        order_textlines_out     = li_txtln_o
        order_flows_out         = li_flow_o
        order_cfgs_curefs_out   = li_curefs
        order_cfgs_cucfgs_out   = li_cucfgs
        order_cfgs_cuins_out    = li_cuins
        order_cfgs_cuprts_out   = li_cuprts
        order_cfgs_cuvals_out   = li_cuvals
        order_cfgs_cublbs_out   = li_cublbs
        order_cfgs_cuvks_out    = li_cuvks
        order_billingplans_out  = li_bilpln
        order_billingdates_out  = li_bildate
        order_creditcards_out   = li_cred_cart
        extensionout            = li_extens. ##FM_SUBRC_OK


    IF sy-subrc EQ 0.
      FREE:li_ret[],li_part_ch[],li_addr[].
      SORT: li_adr_o[] BY address.
      CLEAR:lst_hdr,lst_hdr_x,lst_addr,lst_part_ch.

      lst_hdr_x = 'U'.
      READ TABLE li_hdr_o ASSIGNING FIELD-SYMBOL(<lfs_hdr_o>) INDEX 1.
      IF sy-subrc EQ 0.
        lst_hdr-sales_org = <lfs_hdr_o>-sales_org.
        lst_hdr-distr_chan = <lfs_hdr_o>-distr_chan.
        lst_hdr-division = <lfs_hdr_o>-division.
      ENDIF.

      MOVE lst_output_x-vbeln TO lst_part_ch-document.
      lst_part_ch-p_numb_old = lst_output_x-kunnr.
      lst_part_ch-p_numb_new = lst_output_x-kunnr.
      lst_part_ch-itm_number = lst_output_x-posnr.

      MOVE 'U' TO lst_part_ch-updateflag.

      MOVE lst_output_x-parvw TO lst_part_ch-partn_role.

      SORT li_part_o[] BY itm_number partn_role customer.
      READ TABLE li_part_o ASSIGNING FIELD-SYMBOL(<lst_part_o>) WITH KEY itm_number = lst_output_x-posnr
                                                                         partn_role = lst_output_x-parvw
                                                                         customer = lst_output_x-kunnr
                                                                         BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_part_ch-addr_link = lc_999.
        lst_part_ch-address = <lst_part_o>-address.
        APPEND lst_part_ch TO li_part_ch.

        READ TABLE li_adr_o ASSIGNING FIELD-SYMBOL(<lfs_adr_o>) WITH KEY address = lst_part_ch-address
                                                                        BINARY SEARCH.
        IF sy-subrc EQ 0.
          MOVE-CORRESPONDING <lfs_adr_o> TO lst_addr.
          lst_addr-addr_no = lc_999.

          lst_addr-comm_type = lc_int.
          lst_addr-e_mail = lst_output_x-email..
          lst_addr-postl_cod1 = <lfs_adr_o>-postl_code.
          lst_addr-tel1_numbr = <lfs_adr_o>-telephone.

          APPEND lst_addr TO li_addr.

        ENDIF.
      ENDIF.

    ENDIF.
    FREE:li_ret[].
    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument     = lv_salesdocin
        order_header_in   = lst_hdr
        order_header_inx  = lst_hdr_x
        behave_when_error = 'P'
      TABLES
        return            = li_ret
        partnerchanges    = li_part_ch
        partneraddresses  = li_addr.

    READ TABLE li_ret INTO lst_return WITH KEY type = 'E'. " Return into lst_ of type
    IF sy-subrc IS INITIAL.
      st_err_msg-wbeln = lv_salesdocin.
      st_err_msg-posnr = lst_output_x-posnr.
      st_err_msg-msgid = lst_return-id.
      st_err_msg-msgty = lst_return-type.
      st_err_msg-msgno = lst_return-number.
      st_err_msg-msgv1 = lst_return-message_v1.
      st_err_msg-msgv2 = lst_return-message_v2.
      st_err_msg-msgv3 = lst_return-message_v3.
      st_err_msg-msgv4 = lst_return-message_v4.
      APPEND st_err_msg TO i_err_msg.

      CLEAR: lst_return,
             lst_output_head,
             st_err_msg.
    ELSE. " ELSE -> IF sy-subrc IS INITIAL

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

      READ TABLE li_ret INTO lst_return WITH KEY type = 'S'. " Return into lst_ of type
      IF sy-subrc IS INITIAL.
        st_err_msg-wbeln = lv_salesdocin.
        st_err_msg-posnr = lst_output_x-posnr.
        st_err_msg-msgid = lst_return-id.
        st_err_msg-msgty = lst_return-type.
        st_err_msg-msgno = lst_return-number.
        st_err_msg-msgv1 = lst_return-message_v1.
        st_err_msg-msgv2 = lst_return-message_v2.
        st_err_msg-msgv3 = lst_return-message_v3.
        st_err_msg-msgv4 = lst_return-message_v4.
        APPEND st_err_msg TO i_err_msg.
        CLEAR: lst_return,
               lst_output_head,
               st_err_msg.

        FREE:li_return[].

      ENDIF. " IF sy-subrc IS INITIAL

    ENDIF. " IF sy-subrc IS INITIAL

  ENDLOOP  . " LOOP AT li_create_contract INTO DATA(lst_output_x)

  PERFORM f_send_email_move_file.

  CALL FUNCTION 'WLF_PRINT_ERROR_MESSAGES_LIST'
    EXPORTING
      i_titlebar       = v_titlebar
      i_report         = sy-cprog
    TABLES
      t_error_messages = i_err_msg
    EXCEPTIONS
      program_error    = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF. " IF sy-subrc <> 0
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_READ_FROM_APP_SUB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_read_from_app_orders . "4
  DATA : lv_string    TYPE string,
         lv_flag      TYPE char1,
         lst_output_x TYPE ty_ord_alv.
  FIELD-SYMBOLS:<lfs_outpt> TYPE ty_ord_alv.

  OPEN DATASET p_a_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
  IF sy-subrc NE 0.
    MESSAGE e100(zqtc_r2). " File does not transfer to Application server
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc NE 0

  WHILE lv_flag IS INITIAL.
    READ DATASET p_a_file INTO lv_string.
    IF sy-subrc EQ 0.
      APPEND INITIAL LINE TO   i_ord_alv ASSIGNING <lfs_outpt> .
      SPLIT lv_string AT '|' INTO <lfs_outpt>-sel
            <lfs_outpt>-vbeln
            <lfs_outpt>-posnr
            <lfs_outpt>-parvw
            <lfs_outpt>-kunnr
            <lfs_outpt>-email.


    ELSE. " ELSE -> IF sy-subrc EQ 0
      lv_flag = abap_true.
    ENDIF. " IF sy-subrc EQ 0
  ENDWHILE.
  CLOSE DATASET p_a_file.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SEND_LOG_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_log_email.
  DATA: lv_con_cret TYPE char2  VALUE cl_abap_char_utilities=>cr_lf, " Con_cret of type Character
        lst_message TYPE solisti1,                               " SAPoffice: Single List with Column Length 255
        lst_attach  TYPE solisti1.                               " SAPoffice: Single List with Column Length 255


  CONCATENATE 'Order No'(087) 'Message ID'(088) 'Type'(091) 'Message no'(092) 'Status'(093) 'Message1'(094) 'Message2'(095)     INTO lst_attach SEPARATED BY ','.
  CONCATENATE lv_con_cret lst_attach INTO lst_attach.
  APPEND  lst_attach TO i_attach.
  CLEAR:lst_attach.

  LOOP AT i_err_msg_list INTO DATA(lst_err_msg).
    CONCATENATE lst_err_msg-wbeln lst_err_msg-msgid lst_err_msg-msgty lst_err_msg-msgno lst_err_msg-natxt lst_err_msg-msgv1 lst_err_msg-msgv2
    lst_err_msg-msgv3 lst_err_msg-msgv4
    INTO lst_attach SEPARATED BY ','.
    CONCATENATE lv_con_cret lst_attach INTO lst_attach.
    APPEND  lst_attach TO i_attach.
    CLEAR:lst_attach.
  ENDLOOP. " LOOP AT i_err_msg_list INTO DATA(lst_err_msg)

  v_job_name = p_job.

  PERFORM f_send_csv_xls_log.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_SEND_CSV_XLS_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_csv_xls_log .
  DATA: lst_xdocdata     TYPE sodocchgi1,                           " Data of an object which can be changed
        lst_message      TYPE  solisti1,
        lv_xcnt          TYPE syst_index,                                    " Xcnt of type Integers
        lv_file_name     TYPE char100,                              " File_name of type CHAR100
        lst_usr21        TYPE usr21,                                " User Name/Address Key Assignment
        lst_adr6         TYPE adr6,                                 " E-Mail Addresses (Business Address Services)
        li_packing_list  TYPE TABLE OF sopcklsti1 , "Itab to hold packing list for email
        lst_packing_list TYPE sopcklsti1 , "Itab to hold packing list for email
        li_receivers     TYPE TABLE OF somlreci1 ,  "Itab to hold mail receipents
        lst_receivers    TYPE  somlreci1 ,  "Itab to hold mail receipents
        li_attachment    TYPE TABLE OF solisti1 ,   " SAPoffice: Single List with Column Length 255
        lst_attachment   TYPE solisti1 ,   " SAPoffice: Single List with Column Length 255
        lv_n             TYPE syst_index,                                    " N of type Integers
        lst_attach       TYPE  solisti1,
        lv_desc          TYPE so_obj_des.                           " Short description of contents

  CONSTANTS:lc_uc  TYPE char1 VALUE '_',
            lc_ep1 TYPE sy-sysid VALUE 'EP1'.
  IF sy-sysid NE lc_ep1.
    CONCATENATE sy-sysid 'Upload File'(082) v_job_name 'Log'(098) INTO lv_desc SEPARATED BY lc_uc.
  ELSE.
    CONCATENATE 'Upload File'(082) v_job_name 'Log'(098) INTO lv_desc SEPARATED BY lc_uc.
  ENDIF.
*- Fill the document data.
  lst_xdocdata-doc_size = 1.

*- Populate the subject/generic message attributes
  lst_xdocdata-obj_langu = sy-langu.
  lst_xdocdata-obj_name  = 'SAPRPT'.
  lst_xdocdata-obj_descr = lv_desc.
*- Populate message body text
  CLEAR i_message.
  REFRESH i_message.
  lst_message = 'Dear User,'(078). "Dear Wiley Customer,Please find Attachmen
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.

*- Populate message body text
  CONCATENATE 'JOB NAME:' v_job_name INTO lst_message SEPARATED BY space.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.

  lst_message = 'Process completed.Please find the attachment.'(089).
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  lst_message = 'Thanks,'(080).
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  lst_message = 'WILEY ERP Team'(081).
  APPEND lst_message TO i_message.
  CLEAR lst_message.
*- Fill the document data and get size of attachment
  CLEAR lst_xdocdata.
  DESCRIBE TABLE i_attach LINES lv_xcnt.
  lst_xdocdata-doc_size =
     ( lv_xcnt - 1 ) * 255 + strlen( lst_attach ).
  lst_xdocdata-obj_langu  = sy-langu.
  lst_xdocdata-obj_name   = 'SAPRPT'.
  lst_xdocdata-obj_descr  = lv_desc.
  CLEAR li_attachment[].
  APPEND lst_attach TO i_attach.
  CLEAR:lst_attach.
  li_attachment[] = i_attach[].

*- Describe the body of the message
  CLEAR li_packing_list.
  lst_packing_list-transf_bin = space.
  lst_packing_list-head_start = 1.
  lst_packing_list-head_num = 0.
  lst_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES lst_packing_list-body_num.
  lst_packing_list-doc_type = 'RAW'.
  APPEND lst_packing_list TO li_packing_list.
  IF i_attach[] IS NOT INITIAL.
    lv_n = 1.
*- Create attachment notification
    lst_packing_list-transf_bin = abap_true.
    lst_packing_list-head_start = 1.
    lst_packing_list-head_num   = 1.
    lst_packing_list-body_start = lv_n.

    DESCRIBE TABLE i_attach LINES lst_packing_list-body_num.
    CLEAR lv_file_name .
    CONCATENATE 'ZORDER_ZOPM' sy-datum sy-uzeit  INTO lv_file_name SEPARATED BY '_'.
    CONCATENATE lv_file_name '.CSV' INTO lv_file_name.
    lst_packing_list-doc_type   =  'CSV'.
    lst_packing_list-obj_descr  =  lv_file_name. "p_attdescription.
    lst_packing_list-obj_name   =  lv_file_name. "."p_filename.
    lst_packing_list-doc_size   =  lst_packing_list-body_num * 255.
    APPEND lst_packing_list TO li_packing_list.
  ENDIF. " IF i_attach[] IS NOT INITIAL

  CLEAR : lst_usr21,
          lst_adr6.
  SELECT SINGLE addrnumber persnumber FROM usr21
    INTO ( lst_usr21-addrnumber ,lst_usr21-persnumber )
    WHERE bname = p_userid.
  IF sy-subrc EQ 0 AND lst_usr21 IS NOT INITIAL.
    SELECT SINGLE smtp_addr FROM adr6 INTO lst_adr6-smtp_addr WHERE addrnumber = lst_usr21-addrnumber
                                            AND   persnumber = lst_usr21-persnumber.
    IF   sy-subrc EQ 0 .

*- Add the recipients email address
      CLEAR lst_receivers.
      lst_receivers-receiver = lst_adr6-smtp_addr.
      lst_receivers-rec_type = 'U'.
      lst_receivers-com_type = 'INT'.
      lst_receivers-notif_del = abap_true.
      lst_receivers-notif_ndel = abap_true.
      APPEND lst_receivers TO li_receivers.

      CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
        EXPORTING
          document_data              = lst_xdocdata
          put_in_outbox              = abap_true
          commit_work                = abap_true
        TABLES
          packing_list               = li_packing_list
          contents_bin               = li_attachment
          contents_txt               = i_message
          receivers                  = li_receivers
        EXCEPTIONS
          too_many_receivers         = 1
          document_not_sent          = 2
          document_type_not_exist    = 3
          operation_no_authorization = 4
          parameter_error            = 5
          x_error                    = 6
          enqueue_error              = 7
          OTHERS                     = 8.
      IF sy-subrc NE 0.
        MESSAGE 'Country'(083) TYPE 'E'. "Error in sending Email
      ELSE. " ELSE -> IF sy-subrc NE 0
        MESSAGE 'Time ZOne'(084) TYPE 'S'. "Email sent with Success log file
      ENDIF. " IF sy-subrc NE 0
    ENDIF.
  ENDIF. " IF lst_usr21 IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL_MOVE_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_email_move_file .

  DATA:
    lv_dirtemp   TYPE btcxpgpar,                               " Parameters of external program (string)
    lv_path      TYPE btcxpgpar,                               " Parameters of external program (string)
    lv_directory TYPE btcxpgpar,                               " Parameters of external program (string)                          " Directory of Files
    li_exec_move TYPE STANDARD TABLE OF btcxpm INITIAL SIZE 0. " Log message from external program to calling program

  IF p_a_file IS NOT INITIAL.

    lv_path = p_a_file.
    READ TABLE i_err_msg TRANSPORTING NO FIELDS WITH KEY msgty = c_e.
    IF sy-subrc = 0.
      REPLACE ALL OCCURRENCES OF '/E208/in' IN lv_path WITH '/E208/err'.
    ELSE. " ELSE -> IF sy-subrc = 0
      REPLACE ALL OCCURRENCES OF '/E208/in' IN lv_path WITH '/E208/prc'.
    ENDIF. " IF sy-subrc = 0

    i_err_msg1 = i_err_msg.
    PERFORM transfer_add_error_msg IN PROGRAM saplwlf5
      TABLES i_err_msg1 i_err_msg_list.
    PERFORM f_send_log_email.
*
    lv_dirtemp = p_a_file.
    CONCATENATE lv_dirtemp
                lv_path
          INTO lv_directory
          SEPARATED BY space.

    CALL FUNCTION 'SXPG_COMMAND_EXECUTE'
      EXPORTING
        commandname                   = 'ZSSPMOVE'
        additional_parameters         = lv_directory
      TABLES
        exec_protocol                 = li_exec_move
      EXCEPTIONS
        no_permission                 = 1
        command_not_found             = 2
        parameters_too_long           = 3
        security_risk                 = 4
        wrong_check_call_interface    = 5
        program_start_error           = 6
        program_termination_error     = 7
        x_error                       = 8
        parameter_expected            = 9
        too_many_parameters           = 10
        illegal_command               = 11
        wrong_asynchronous_parameters = 12
        cant_enq_tbtco_entry          = 13
        jobcount_generation_error     = 14
        OTHERS                        = 15.

    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

    ENDIF. " IF sy-subrc IS INITIAL
    CLEAR: li_exec_move[],
           lv_directory,
           lv_dirtemp.
  ENDIF. " IF p_a_file IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_NOTIFICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_notification .
  DATA: lst_xdocdata     TYPE sodocchgi1,                           " Data of an object which can be changed
        lst_message      TYPE solisti1,
        lv_xcnt          TYPE syst_index,                                    " Xcnt of type Integers
        lv_file_name     TYPE char100,                              " File_name of type CHAR100
        lst_usr21        TYPE usr21,                                " User Name/Address Key Assignment
        lst_adr6         TYPE adr6,                                 " E-Mail Addresses (Business Address Services)
        li_packing_list  TYPE TABLE OF sopcklsti1 ,                 "Itab to hold packing list for email
        lst_packing_list TYPE sopcklsti1 ,                         "Itab to hold packing list for email
        li_receivers     TYPE TABLE OF somlreci1 ,                  "Itab to hold mail receipents
        lst_receivers    TYPE somlreci1 ,                          "Itab to hold mail receipents
        li_attachment    TYPE TABLE OF solisti1 ,                   " SAPoffice: Single List with Column Length 255
        lst_attachment   TYPE solisti1 ,                            " SAPoffice: Single List with Column Length 255
        lv_n             TYPE syst_index,                                    " N of type Integers
        lv_desc          TYPE so_obj_des,                           " Short description of contents
        lc_ep1           TYPE sy-sysid VALUE 'EP1'.

  IF sy-sysid NE lc_ep1.
    CONCATENATE sy-sysid 'Upload File'(082) v_job_name 'Log'(098) INTO lv_desc SEPARATED BY '_'.
  ELSE.
    CONCATENATE 'Upload File'(082) v_job_name 'Log'(098) INTO lv_desc SEPARATED BY '_'.
  ENDIF.

*  CONCATENATE sy-sysid 'Upload File'(082) v_job_name 'Log'(098) INTO lv_desc SEPARATED BY '_'.
*- Fill the document data.
  lst_xdocdata-doc_size = 1.

*- Populate the subject/generic message attributes
  lst_xdocdata-obj_langu = sy-langu.
  lst_xdocdata-obj_name  = 'SAPRPT'.
  lst_xdocdata-obj_descr = lv_desc.
*- Populate message body text
  CLEAR i_message.
  REFRESH i_message.
  lst_message = 'Dear User,'(078).
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.

*- Populate message body text
  CONCATENATE 'Your order upload file is being processed through background job'(079) v_job_name INTO lst_message SEPARATED BY space.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.

  CONCATENATE 'File name'(090) p_file INTO lst_message SEPARATED BY ':'.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  CONCATENATE 'Date & Time'(096) sy-datum sy-uzeit INTO lst_message SEPARATED BY ':'.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  lst_message = 'Thanks,'(080).
  APPEND lst_message TO i_message.
  CLEAR lst_message.
  lst_message = 'WILEY ERP Team'(081).
  APPEND lst_message TO i_message.
  CLEAR lst_message.

*- Describe the body of the message
  CLEAR lst_packing_list.
  lst_packing_list-transf_bin = space.
  lst_packing_list-head_start = 1.
  lst_packing_list-head_num = 0.
  lst_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES lst_packing_list-body_num.
  lst_packing_list-doc_type = 'RAW'.
  APPEND lst_packing_list TO li_packing_list.
  CLEAR :
          lst_usr21,
          lst_adr6.
  p_userid = sy-uname.
  SELECT SINGLE addrnumber persnumber FROM usr21 INTO (lst_usr21-addrnumber,lst_usr21-persnumber ) WHERE bname = p_userid.
  IF sy-subrc EQ 0 AND lst_usr21 IS NOT INITIAL.
    SELECT SINGLE smtp_addr FROM adr6 INTO lst_adr6-smtp_addr WHERE addrnumber = lst_usr21-addrnumber
                                            AND   persnumber = lst_usr21-persnumber.
    IF sy-subrc EQ 0.
*- Add the recipients email address
      CLEAR lst_receivers.
      lst_receivers-receiver = lst_adr6-smtp_addr.
      lst_receivers-rec_type = 'U'.
      lst_receivers-com_type = 'INT'.
      lst_receivers-notif_del = abap_true.
      lst_receivers-notif_ndel = abap_true.
      APPEND lst_receivers TO li_receivers.

      CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
        EXPORTING
          document_data              = lst_xdocdata
          put_in_outbox              = abap_true
          commit_work                = abap_true
        TABLES
          packing_list               = li_packing_list
          contents_bin               = li_attachment
          contents_txt               = i_message
          receivers                  = li_receivers
        EXCEPTIONS
          too_many_receivers         = 1
          document_not_sent          = 2
          document_type_not_exist    = 3
          operation_no_authorization = 4
          parameter_error            = 5
          x_error                    = 6
          enqueue_error              = 7
          OTHERS                     = 8.
      IF sy-subrc NE 0.
        MESSAGE 'Country'(083) TYPE 'E'. "Error in sending Email
      ELSE. " ELSE -> IF sy-subrc NE 0
        MESSAGE 'Time Zone'(084) TYPE 'S'. "Email sent with Success log file
      ENDIF. " IF sy-subrc NE 0
    ENDIF. "sy-subrc eq 0
  ENDIF. " IF lst_usr21 IS NOT INITIAL
  CLEAR : li_packing_list,
          li_attachment,
          i_message,
          li_receivers.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_PATH  text
*      -->P_LV_FILENAME  text
*----------------------------------------------------------------------*
FORM f_get_file_path  USING   fp_lv_filename.
  DATA : lv_path         TYPE filepath-pathintern .
  DATA:lv_path_fname TYPE string.
  CLEAR : lv_path_fname,
          lv_path.
  lv_path = v_path.
*--*Read file path from transaction FILE
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = lv_path
      operating_system           = sy-opsys
      file_name                  = fp_lv_filename
      eleminate_blanks           = c_x
    IMPORTING
      file_name_with_path        = lv_path_fname
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE s001 DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSE.
    v_path_fname = lv_path_fname.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_template
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_file_template .   "2

  IF sy-ucomm ='FC01'.
* Start Excel
    CREATE OBJECT v_excel 'EXCEL.APPLICATION'.
    SET PROPERTY OF  v_excel  'Visible' = 1.

* get list of workbooks, initially empty
    CALL METHOD OF v_excel 'Workbooks' = v_mapl.
* add a new workbook
    CALL METHOD OF v_mapl 'Add' = v_map.

    CALL METHOD OF v_excel 'Columns' = v_column.
    CALL METHOD OF v_column 'Autofit'.

* output column headings to active Excel sheet
    PERFORM:
    f_fill_cell USING 1 1 1 'Order Number'(042),
    f_fill_cell USING 1 2 1 'Item Number'(038),
    f_fill_cell USING 1 3 1 'Partner Type'(039),
    f_fill_cell USING 1 4 1 'Business Partner'(040),
    f_fill_cell USING 1 5 1 'Email ID'(041).


    CALL METHOD OF v_excel 'Worksheets' = v_mapl.

    FREE OBJECT v_excel.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_SAVE_FILE_APP_SERVER_SUBMIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_OUTPUT_X  text
*----------------------------------------------------------------------*
FORM f_save_file_app_server_submit  USING fp_li_output_x TYPE tt_ord_alv.
*** Local Constant Declaration
  CONSTANTS: lc_pipe       TYPE char1 VALUE '|',        " Tab of type Character
             lc_semico     TYPE char1 VALUE ';',    " Semico of type CHAR1
             lc_underscore TYPE char1 VALUE '_',    " Underscore of type CHAR1
             lc_slash      TYPE char1 VALUE '/',    " Slash of type CHAR1
             lc_extn       TYPE char4 VALUE '.csv', " Extn of type CHAR4
             lc_job_name   TYPE btcjob VALUE 'ZORDER_EMAIL_UPD'. " Background job name
**** Local field symbol declaration
  FIELD-SYMBOLS: <lfs_final_csv> TYPE LINE OF truxs_t_text_data.
*** Local structure and internal table declaration
  DATA: lst_final_csv TYPE LINE OF truxs_t_text_data,
        lv_length     TYPE syst_index,      " Length of type Integers
        lv_fnm        TYPE char70, " Fnm of type CHAR70
        li_final_csv  TYPE truxs_t_text_data.

  DATA:   lv_job_number TYPE tbtcjob-jobcount, " Job Count
          lv_job_name   TYPE tbtcjob-jobname,  " Job Name
          lv_user       TYPE sy-uname,         " User Name
          lv_pre_chk    TYPE btcckstat.        " variable for pre. job status

  LOOP AT fp_li_output_x ASSIGNING FIELD-SYMBOL(<lfs_outpt>).
    CLEAR:lst_final_csv.
    CONCATENATE
            <lfs_outpt>-sel
            <lfs_outpt>-vbeln
            <lfs_outpt>-posnr
            <lfs_outpt>-parvw
            <lfs_outpt>-kunnr
            <lfs_outpt>-email

        INTO lst_final_csv SEPARATED BY lc_pipe.

    APPEND lst_final_csv TO li_final_csv.
    CLEAR:lst_final_csv.
  ENDLOOP.

  CLEAR v_fpath.

  CONCATENATE 'ZORDER_EMAIL'
              lc_underscore
              sy-uname
              lc_underscore
              sy-datum
              lc_underscore
              sy-uzeit
              lc_extn
              INTO
              v_path_fname.

  PERFORM f_get_file_path USING v_path_fname.

  OPEN DATASET v_path_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
  IF sy-subrc EQ 0.
    LOOP AT li_final_csv INTO lst_final_csv.
      TRANSFER lst_final_csv TO v_path_fname.
    ENDLOOP. " LOOP AT li_final_csv INTO lst_final_csv
    CLOSE DATASET v_path_fname.
  ENDIF.
**** Submit Program
  CLEAR lv_job_name.
  CONCATENATE lc_job_name '_' sy-datum '_' sy-uzeit '_' sy-uname  INTO lv_job_name.

  lv_user = sy-uname.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Assignment number'(066).

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_job_name
    IMPORTING
      jobcount         = lv_job_number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.
  IF sy-subrc = 0.
    v_job_name = lv_job_name.
    p_job   = lv_job_name.
    SUBMIT zqtcr_sales_partner_update
                                        WITH p_file  = p_file
                                        WITH p_a_file = v_path_fname
                                        WITH p_job    = p_job
                                        WITH p_userid = sy-uname
                                        USER  'QTC_BATCH01'
                                        VIA JOB lv_job_name NUMBER lv_job_number
                                        AND RETURN.
** close the background job for successor jobs
    CALL FUNCTION 'JOB_CLOSE' ##FM_SUBRC_OK
      EXPORTING
        jobname              = lv_job_name
        jobcount             = lv_job_number
        predjob_checkstat    = lv_pre_chk
        sdlstrtdt            = sy-datum
        sdlstrttm            = sy-uzeit
      EXCEPTIONS
        cant_start_immediate = 01
        invalid_startdate    = 02
        jobname_missing      = 03
        job_close_failed     = 04
        job_nosteps          = 05
        job_notex            = 06
        lock_failed          = 07
        OTHERS               = 08.
    IF sy-subrc = 0.

    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF sy-subrc = 0
ENDFORM.

*---------------------------------------------------------------------*
*       FORM FILL_CELL                                                *
*---------------------------------------------------------------------*
*       sets cell at coordinates i,j to value val boldtype bold       *
*---------------------------------------------------------------------*
FORM f_fill_cell USING fp_i fp_j fp_bold fp_val.
  DATA: lv_interior TYPE ole2_object,
        lv_borders  TYPE ole2_object.

  CALL METHOD OF v_excel 'Cells' = v_zl EXPORTING #1 = fp_i #2 = fp_j.

  SET PROPERTY OF v_zl 'Value' = fp_val .

  GET PROPERTY OF v_zl 'Font' = v_f.
  SET PROPERTY OF v_zl 'ColumnWidth' = 20.

  SET PROPERTY OF v_f 'Bold' = 1 .

  SET PROPERTY OF v_f 'COLORINDEX' = 1 .

  GET PROPERTY OF v_zl 'Interior' = lv_interior .

  SET PROPERTY OF lv_interior 'ColorIndex' = 15.
  SET PROPERTY OF v_zl 'WrapText' = 1.
*left

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '1'.

  SET PROPERTY OF lv_borders 'LineStyle' = '1'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '2'.

  SET PROPERTY OF lv_borders 'LineStyle' = '3'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '3'.

  SET PROPERTY OF lv_borders 'LineStyle' = '3'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

  CALL METHOD OF v_zl 'BORDERS' = lv_borders EXPORTING #1 = '4'.

  SET PROPERTY OF lv_borders 'LineStyle' = '3'.

  SET PROPERTY OF lv_borders 'WEIGHT' = 3.

  FREE OBJECT lv_borders.

ENDFORM.
