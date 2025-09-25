*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ORDER_UPLOAD_E506_SUB
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_ORDER_UPLOAD_E506_SUB (INCLUDE)
* PROGRAM DESCRIPTION: To upload Mass Sales orders & Credit/Debit Memos
* REFERENCE NO: EAM-1155
* DEVELOPER: Vishnuvardhan Reddy(VCHITTIBAL)
* CREATION DATE:   19/April/2022
* OBJECT ID:    E506
* TRANSPORT NUMBER(S):ED2K926870
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_F4_FILE_NAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_FILE  text
*----------------------------------------------------------------------*
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
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM f_get_file.

  DATA:lv_template_name TYPE ztname,                   "Template Name
       lv_xstr_content  TYPE xstring,                  "Content
       li_content       TYPE STANDARD TABLE OF tdline, "Data Declaration for File upload
       lv_len           TYPE i,
       lv_fname         TYPE string,
       lv_fpath         TYPE string,
       lv_path          TYPE string,
       lv_title         TYPE string.

  CONSTANTS:lc_fc01     TYPE sy-ucomm VALUE 'FC01'.

  IF sy-ucomm = lc_fc01. "Download Template

    IF rb_so_ct EQ abap_true.

      lv_template_name = 'E506 - Create Mass Orders'(055).

    ELSEIF rb_cd_ct EQ abap_true.

      lv_template_name = 'E506 - Create Credit/Debit Memo'(056).

    ENDIF.

*   Select file content based on selection screen value
    SELECT SINGLE file_content FROM zca_templates
      INTO @DATA(lv_filecontent)
      WHERE program_name  = @sy-repid
        AND template_name = @lv_template_name
        AND active        = @abap_true
        AND wricef_id     = @c_e506.                    "#EC CI_NOORDER
    IF sy-subrc IS INITIAL.
      lv_xstr_content = lv_filecontent.
    ELSE.
      MESSAGE i000 WITH 'Template file not maintained'(057).
      RETURN.
    ENDIF.

*   Convert xstring/rawstring to binary itab
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = lv_xstr_content
      IMPORTING
        output_length = lv_len
      TABLES
        binary_tab    = li_content.

    lv_title = 'Save dialog'(058).
    CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
        default_extension         = 'XLS'
        window_title              = lv_title
      CHANGING
        filename                  = lv_fname
        path                      = lv_path
        fullpath                  = lv_fpath
      EXCEPTIONS
        cntl_error                = 1
        error_no_gui              = 2
        not_supported_by_gui      = 3
        invalid_default_file_name = 4
        OTHERS                    = 5.

    IF sy-subrc EQ 0 AND lv_fpath IS NOT INITIAL.
      " Download file to presentation server from SAP
      CALL METHOD cl_gui_frontend_services=>gui_download
        EXPORTING
          bin_filesize            = lv_len
          filename                = lv_fpath
          filetype                = 'BIN'
        CHANGING
          data_tab                = li_content
        EXCEPTIONS
          file_write_error        = 1
          no_batch                = 2
          gui_refuse_filetransfer = 3
          invalid_type            = 4
          no_authority            = 5
          unknown_error           = 6
          header_not_allowed      = 7
          separator_not_allowed   = 8
          filesize_not_allowed    = 9
          header_too_long         = 10
          dp_error_create         = 11
          dp_error_send           = 12
          dp_error_write          = 13
          unknown_dp_error        = 14
          access_denied           = 15
          dp_out_of_memory        = 16
          disk_full               = 17
          dp_timeout              = 18
          file_not_found          = 19
          dataprovider_exception  = 20
          control_flush_error     = 21
          not_supported_by_gui    = 22
          error_no_gui            = 23
          OTHERS                  = 24.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ELSE.
        MESSAGE s010(zfilupload).
      ENDIF.
    ENDIF.
  ENDIF. " IF sy-ucomm = c_fc01.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
FORM f_get_constants .

  CONSTANTS: lc_path     TYPE rvari_vnam VALUE 'LOGICAL_PATH',
             lc_email    TYPE rvari_vnam VALUE 'EMAIL',
             lc_row_text TYPE rvari_vnam VALUE 'ROW_TEXT',
             lc_line_lmt TYPE rvari_vnam VALUE 'LINE_LMT'.

  SELECT devid,    " Development ID
         param1,   " ABAP: Name of Variant Variable
         param2,   " ABAP: Name of Variant Variable
         srno,     " ABAP: Current selection number
         sign,     " ABAP: ID: I/E (include/exclude values)
         opti,     " ABAP: Selection option (EQ/BT/CP/...)
         low,      " Lower Value of Selection Condition
         high      " Upper Value of Selection Condition
  FROM zcaconstant " Wiley Application Constant Table
  INTO TABLE @i_const
  WHERE devid    = @c_e506
  AND   activate = @abap_true.
  IF sy-subrc IS INITIAL.
    SORT i_const BY param1
                    param2.
  ENDIF.

  LOOP AT i_const ASSIGNING FIELD-SYMBOL(<lfs_e506>) WHERE devid = c_e506 AND
                                                           param2 = lc_row_text. "#EC CI_STDSEQ
    APPEND INITIAL LINE TO ir_row_txt ASSIGNING FIELD-SYMBOL(<lfs_row_txt>).
    <lfs_row_txt>-sign = <lfs_e506>-sign.      "'I'.
    <lfs_row_txt>-opti = <lfs_e506>-opti.      "'CP'.
    <lfs_row_txt>-low  = <lfs_e506>-low.       " Row Text
    <lfs_row_txt>-high = <lfs_e506>-high.      " Row Text
  ENDLOOP.

  READ TABLE i_const ASSIGNING <lfs_e506> WITH KEY param1 = space
                                                   param2 = lc_line_lmt BINARY SEARCH.
  IF sy-subrc IS INITIAL.
    v_line_lmt = <lfs_e506>-low.
  ENDIF.

*--Application server Path
  READ TABLE i_const ASSIGNING <lfs_e506> WITH KEY param1 = space
                                                   param2 = lc_path BINARY SEARCH.
  IF sy-subrc EQ 0.
    v_e506 = <lfs_e506>-low.
  ENDIF.

*--Email
  READ TABLE i_const ASSIGNING <lfs_e506> WITH KEY param1 = space
                                                   param2 = lc_email BINARY SEARCH.
  IF sy-subrc EQ 0.
    v_email = <lfs_e506>-low.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_ORD_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_convert_ord_excel USING    fp_p_file TYPE localfile. " Local file for upload/download.


  DATA : li_excel        TYPE STANDARD TABLE OF alsmex_tabline  " Rows for Table with Excel Data
                         INITIAL SIZE 0,                        " Rows for Table with Excel Data
         lst_excel_dummy TYPE                   alsmex_tabline, " Rows for Table with Excel Data
         lst_excel       TYPE                   alsmex_tabline, " Rows for Table with Excel Data
         lst_regular_ord TYPE  zstqtc_reg_ord.                  " Order Input Structure

** Local Variables
  DATA: lv_kwmeng         TYPE char17,
        lv_begin_row      TYPE i,
        lv_begin_col      TYPE i,
        lv_end_row        TYPE i,
        lv_end_col        TYPE i,
        lv_index          TYPE sy-tabix,
        lv_identifier(10) TYPE n,
        lv_oid(10)        TYPE n,
        lv_item           TYPE posnr,
        lv_log            TYPE balognr,
        lv_loghandle      TYPE balloghndl,
        lv_msg            TYPE char100,
        lv_msgty          TYPE char1,
        lvf_skip_row      TYPE char1.

  STATICS: lv_ord_status   TYPE c.

  IF fp_p_file IS NOT INITIAL.
** Get Excel Starting Row and Column
    PERFORM f_get_row_column CHANGING lv_begin_row
                                      lv_begin_col
                                      lv_end_row
                                      lv_end_col.

    CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
      EXPORTING
        filename                = fp_p_file
        i_begin_col             = lv_begin_col
        i_begin_row             = lv_begin_row
        i_end_col               = lv_end_col
        i_end_row               = lv_end_row
      TABLES
        intern                  = li_excel
      EXCEPTIONS
        inconsistent_parameters = 1
        upload_ole              = 2
        OTHERS                  = 3.
    IF sy-subrc EQ 0.
*    *************NOW FILL DATA FROM EXCEL INTO FINAL LEGACY DATA ITAB--***************
      IF NOT li_excel[] IS INITIAL.
        CLEAR lst_regular_ord.
        LOOP AT li_excel INTO lst_excel.
          lst_excel_dummy = lst_excel.
          IF lst_excel_dummy-value(1) EQ text-sqt.
            lst_excel_dummy-value(1) = space.
            SHIFT lst_excel_dummy-value LEFT DELETING LEADING space.
          ENDIF. " IF lst_excel_dummy-value(1) EQ text-sqt

          AT NEW row.
            CLEAR lvf_skip_row.
*         If row starts with Order Identifier, Mandatory or Optional Skip the Row
            IF lst_excel_dummy-value IN ir_row_txt.
              lvf_skip_row = abap_true.
            ENDIF.
          ENDAT.

          IF lvf_skip_row  IS NOT INITIAL.
            CONTINUE.
          ENDIF.

          AT NEW col.

            CASE lst_excel_dummy-col.
              WHEN c_1.

                IF lst_excel_dummy-value IS NOT INITIAL.
                  " Process only with Numeric value for Identifier
                  FIND REGEX '[[:digit:]]' IN lst_excel_dummy-value.
                  IF sy-subrc NE 0.
                    MESSAGE s600(zqtc_r2) DISPLAY LIKE c_e.
                    LEAVE LIST-PROCESSING.
                  ENDIF.
                  lst_regular_ord-identifier = lst_excel_dummy-value(10).
                ELSE.
                  MESSAGE s593(zqtc_r2) DISPLAY LIKE c_e.
                  LEAVE LIST-PROCESSING.
                ENDIF.
                CONDENSE lst_regular_ord-identifier.
                CLEAR lst_excel_dummy.

              WHEN c_2.
                lst_regular_ord-auart = lst_excel_dummy-value(4).
                IF lst_regular_ord-auart IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-auart
                    IMPORTING
                      output = lst_regular_ord-auart.
                ENDIF. " IF lst_regular_ord-auart IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_3.
                lst_regular_ord-vkorg = lst_excel_dummy-value(4).
                IF lst_regular_ord-vkorg IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-vkorg
                    IMPORTING
                      output = lst_regular_ord-vkorg.
                ENDIF. " IF lst_regular_ord-vkorg IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_4.
                lst_regular_ord-vtweg = lst_excel_dummy-value(2).
                IF lst_regular_ord-vtweg IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-vtweg
                    IMPORTING
                      output = lst_regular_ord-vtweg.
                ENDIF. " IF lst_regular_ord-vtweg IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_5.
                lst_regular_ord-spart = lst_excel_dummy-value(2).
                IF lst_regular_ord-spart IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-spart
                    IMPORTING
                      output = lst_regular_ord-spart.
                ENDIF. " IF lst_regular_ord-spart IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_6.
                lst_regular_ord-ag_kunnr = lst_excel_dummy-value(10).
                IF lst_regular_ord-ag_kunnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-ag_kunnr
                    IMPORTING
                      output = lst_regular_ord-ag_kunnr.
                ENDIF. " IF lst_regular_ord-ag_kunnr IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_7.
                lst_regular_ord-we_kunnr = lst_excel_dummy-value(10).
                IF lst_regular_ord-we_kunnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-we_kunnr
                    IMPORTING
                      output = lst_regular_ord-we_kunnr.
                ENDIF. " IF lst_regular_ord-we_kunnr IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_8.
                lst_regular_ord-re_kunnr = lst_excel_dummy-value(10).
                IF lst_regular_ord-re_kunnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-re_kunnr
                    IMPORTING
                      output = lst_regular_ord-re_kunnr.
                ENDIF. " IF lst_regular_ord-re_kunnr IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_9.
                lst_regular_ord-rg_kunnr = lst_excel_dummy-value(10).
                IF lst_regular_ord-rg_kunnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-rg_kunnr
                    IMPORTING
                      output = lst_regular_ord-rg_kunnr.
                ENDIF. " IF lst_regular_ord-rg_kunnr IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_10.
                lst_regular_ord-cr_lifnr = lst_excel_dummy-value(10).
                IF lst_regular_ord-cr_lifnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-cr_lifnr
                    IMPORTING
                      output = lst_regular_ord-cr_lifnr.
                ENDIF. " IF lst_regular_ord-cr_lifnr IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_11.
                lst_regular_ord-ve_pernr = lst_excel_dummy-value(10).
                IF lst_regular_ord-ve_pernr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-ve_pernr
                    IMPORTING
                      output = lst_regular_ord-ve_pernr.
                ENDIF. " IF lst_regular_ord-ve_pernr IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_12.
                lst_regular_ord-bsark = lst_excel_dummy-value(4).
                CLEAR lst_excel_dummy.

              WHEN c_13.
                lst_regular_ord-bstnk = lst_excel_dummy-value(20).
                IF lst_regular_ord-bstnk IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-bstnk
                    IMPORTING
                      output = lst_regular_ord-bstnk.
                ENDIF. " IF lst_regular_ord-bstnk IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_14.
                lst_regular_ord-zzpromo = lst_excel_dummy-value(10).

                IF lst_regular_ord-zzpromo IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-zzpromo
                    IMPORTING
                      output = lst_regular_ord-zzpromo.
                ENDIF. " IF lst_regular_ord-zzpromo IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_15.
                WRITE lst_excel_dummy-value(06) TO lst_regular_ord-posnr.
                IF lst_regular_ord-posnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-posnr
                    IMPORTING
                      output = lst_regular_ord-posnr.
                ENDIF. " IF lst_regular_ord-posnr IS NOT INITIAL

              WHEN c_16.

                lst_regular_ord-matnr = lst_excel_dummy-value(18).

                IF lst_regular_ord-matnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-matnr
                    IMPORTING
                      output = lst_regular_ord-matnr.

                  CLEAR lst_excel_dummy.
                ENDIF. " IF lst_regular_ord-matnr IS NOT INITIAL

              WHEN c_17.
                lv_kwmeng  =  lst_excel_dummy-value(13).
                TRY.
                    lst_regular_ord-kwmeng  = lv_kwmeng.
                  CATCH cx_root.
*                 Message: Quantity & is not in the correct format
                    MESSAGE i131(o3) WITH lst_excel_dummy-value. " Quantity & is not in the correct format
                    LEAVE LIST-PROCESSING.
                ENDTRY.
                CLEAR lst_excel_dummy.

              WHEN c_18.
                lst_regular_ord-pstyv = lst_excel_dummy-value(4).
                IF lst_regular_ord-pstyv IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-pstyv
                    IMPORTING
                      output = lst_regular_ord-pstyv.
                ENDIF. " IF lst_regular_ord-pstyv IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_19.
                lst_regular_ord-augru = lst_excel_dummy-value(3).
                IF lst_regular_ord-augru IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_regular_ord-augru
                    IMPORTING
                      output = lst_regular_ord-augru.
                ENDIF. " IF lst_regular_ord-augru IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_20.
                lst_regular_ord-bstkd_e = lst_excel_dummy-value(35).
                CLEAR lst_excel_dummy.

              WHEN c_21.
                lst_regular_ord-hd1_stxh = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN c_22.
                lst_regular_ord-hd2_stxh = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN c_23.
                lst_regular_ord-it1_stxh = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

              WHEN c_24.
                lst_regular_ord-it2_stxh = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.

            ENDCASE.
          ENDAT.

          AT END OF row.
            IF NOT lst_regular_ord IS INITIAL.
              APPEND lst_regular_ord TO i_regular_ord.
              CLEAR lst_regular_ord.
            ENDIF. " IF NOT lst_final_ord IS INITIAL
          ENDAT.
        ENDLOOP. " LOOP AT li_excel INTO lst_excel
*   Populating the Last line
        IF lst_regular_ord IS NOT INITIAL.
          APPEND lst_regular_ord TO i_regular_ord.
          CLEAR lst_regular_ord.
        ENDIF.
      ENDIF. " IF NOT li_excel[] IS INITIAL
    ENDIF. " IF sy-subrc EQ 0

    IF i_regular_ord IS NOT INITIAL.
      IF p_v_oid IS NOT INITIAL.
        v_oid   = p_v_oid.
        lv_oid  = p_v_oid.
      ELSE.
        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            nr_range_nr             = c_zq
            object                  = c_zqtc_uplid
            quantity                = c_quantity
          IMPORTING
            number                  = lv_oid
          EXCEPTIONS
            interval_not_found      = 1
            number_range_not_intern = 2
            object_not_found        = 3
            quantity_is_0           = 4
            quantity_is_not_1       = 5
            interval_overflow       = 6
            buffer_overflow         = 7
            OTHERS                  = 8.
        IF sy-subrc EQ 0.
          v_oid   = lv_oid.
          p_v_oid = lv_oid.
        ENDIF.
      ENDIF.
      IF lv_oid IS NOT INITIAL.
        CONCATENATE 'Your Upload File Identification Number is'(003)
                    lv_oid
               INTO lv_msg SEPARATED BY space.
        CALL FUNCTION 'POPUP_TO_INFORM'
          EXPORTING
            titel = text-004
            txt1  = lv_msg
            txt2  = ''.
      ENDIF.
    ELSE.
      MESSAGE i000 WITH text-022 DISPLAY LIKE c_e. "Input file is Empty
      LEAVE LIST-PROCESSING.
    ENDIF. "IF fp_i_regular IS NOT INITIAL.

*   Get Customers
    PERFORM f_get_customers_ord USING i_regular_ord
                             CHANGING i_customer i_vendor.
**   Get Material
    PERFORM f_get_material_group_ord USING i_regular_ord
                                  CHANGING i_matnr
                                           i_mvke.
* Process Input File and Create SLG Logs
    SORT: "i_regular_ord BY identifier,
          i_customer BY kunnr.

    LOOP AT i_regular_ord ASSIGNING FIELD-SYMBOL(<lfs_i_regular_ord>).
      CLEAR:lv_msgty.
      lst_regular_ord = <lfs_i_regular_ord>.
      lv_item = lst_regular_ord-posnr.
      AT NEW identifier.
        lv_index      = sy-tabix.
        lv_identifier = lst_regular_ord-identifier.
        v_auart       = lst_regular_ord-auart.
      ENDAT.
      PERFORM f_create_log_staging_ord USING    lst_regular_ord  lv_oid    lv_item
                                       CHANGING lv_log           lv_msgty  lv_loghandle.
      IF lv_msgty IS INITIAL.
        lv_msgty = c_i.
      ENDIF.
      PERFORM f_retain_log_status USING    lv_msgty
                                  CHANGING lv_ord_status.
      <lfs_i_regular_ord>-zlogno     = lv_log.         "Application log: log number
      <lfs_i_regular_ord>-log_handle = lv_loghandle.   "Application Log: Log Handle
      <lfs_i_regular_ord>-zoid       = lv_oid.         "Order Identifier in Upload File

      AT END OF identifier.
*       At Last Identifier (Order) - Update all Lines of the Order with message Status
        LOOP AT i_regular_ord ASSIGNING FIELD-SYMBOL(<lfs_i_regular_ord1>) FROM lv_index. "#EC CI_NESTED
          IF <lfs_i_regular_ord1>-identifier <> lv_identifier.
            CLEAR: lv_index, lv_identifier,v_auart,st_log_handle.
            EXIT.
          ENDIF.
          <lfs_i_regular_ord1>-msgty = lv_ord_status.
          CASE lv_ord_status.
            WHEN c_i OR c_s.
              <lfs_i_regular_ord1>-msgv1 = 'File Validation - Successful'(060).
            WHEN c_w.
              <lfs_i_regular_ord1>-msgv1 = 'File Validation - Warnings'(061).
            WHEN c_e.
              <lfs_i_regular_ord1>-msgv1 = 'File Validation - Error'(062).
            WHEN OTHERS.
          ENDCASE.
        ENDLOOP.
        CLEAR: lv_ord_status.
      ENDAT.
    ENDLOOP.

    IF i_e506_stage[] IS NOT INITIAL.
      MODIFY zqtc_stagng_e506 FROM TABLE i_e506_stage.
    ENDIF.

** Cound the Input File Count.
    DESCRIBE TABLE i_regular_ord LINES v_lines.

  ELSE.
    MESSAGE i000 WITH text-031 DISPLAY LIKE c_e. "Input File is mandatory
    LEAVE LIST-PROCESSING.
  ENDIF.  "IF fp_p_file IS NOT INITIAL.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_REG_ORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_create_reg_ord .
** Call Method for Bulk Orders Creation
  CALL METHOD zqtccl_orders_create=>create_regular_orders
    IMPORTING
      ex_reg_ord_out = i_reg_ord_out
    CHANGING
      ch_reg_orders  = i_regular_ord.

  IF p_a_file IS INITIAL.

    IF i_reg_ord_out[] IS NOT INITIAL.

** Display Response output
      PERFORM f_display_output.

    ENDIF.

  ELSE.

** Trigger mail with/with out Attachment
    PERFORM f_send_email_move_file.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_REG_ORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_create_reg_ord_bg.
** Upload File in App Server and submit BG
  PERFORM f_sfile_app_ord_submit.
  MESSAGE i528(zqtc_r2) WITH v_line_lmt v_job_name sy-datum sy-uzeit. " The no. of selected lines is greater than & so backgroung job scheduled
  SET SCREEN 0.
  LEAVE SCREEN.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_FILE
*&---------------------------------------------------------------------*
FORM f_validate_file  USING   fp_file TYPE localfile. " Local file for upload/download

** Local Variables
  DATA : lv_file_char  TYPE localfile,  " Local file for upload/download
         lv_ferr_flg   TYPE xfld,
         lv_check_file TYPE c,
         li_stage_ref  TYPE STANDARD TABLE OF zqtc_stagng_e506,
         lst_stage_ref TYPE zqtc_stagng_e506.

** Local Constants
  CONSTANTS:  lc_f1  TYPE char2    VALUE 'F1'.       "Processing Status "File Validation Error

  IF fp_file IS NOT INITIAL AND p_a_file IS INITIAL.
* Reverse the string
    CALL FUNCTION 'STRING_REVERSE'
      EXPORTING
        string    = fp_file
        lang      = sy-langu
      IMPORTING
        rstring   = lv_file_char
      EXCEPTIONS
        too_small = 1
        OTHERS    = 2.
    IF sy-subrc IS INITIAL.
      IF lv_file_char+0(3) NE 'slx'  AND
         lv_file_char+0(3) NE 'SLX'  AND
         lv_file_char+0(4) NE 'xslx' AND
         lv_file_char+0(4) NE 'XSLX'.
        MESSAGE text-e01 TYPE c_e.
      ENDIF. " IF lv_file_char+0(3) NE 'slx' AND
    ENDIF. " IF sy-subrc IS INITIAL

*   Check if File needs to be validated based on selection
    PERFORM f_validate_file_needed CHANGING lv_check_file.
    CHECK lv_check_file IS NOT INITIAL.
*   Validate if File already processed
    CLEAR lv_ferr_flg.
    SELECT SINGLE * FROM zqtc_stagng_e506 INTO @DATA(lst_stage)
      WHERE zfilepath = @p_file.
    IF sy-subrc EQ 0 AND sy-batch IS INITIAL.
      SELECT * FROM zqtc_stagng_e506
        INTO TABLE @li_stage_ref
        WHERE zfilepath = @p_file.
      IF sy-subrc = 0.
*       Get the most recent file Processed
        SORT li_stage_ref BY zcrtdat DESCENDING
                             zcrttim DESCENDING.
*       If the Most recent File is in Validation Error Allow reporcessing
        READ TABLE li_stage_ref INTO lst_stage_ref INDEX 1.
        lv_ferr_flg = abap_true.
        LOOP AT li_stage_ref INTO DATA(lst_stage_ref1) WHERE zuid_upld = lst_stage_ref-zuid_upld
                                                         AND zprcstat  = lc_f1. "#EC CI_STDSEQ
          CLEAR: lv_ferr_flg,lst_stage_ref1.
          EXIT.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF lv_ferr_flg IS NOT INITIAL.
      MESSAGE e263(zqtc_r2). "DISPLAY LIKE 'S'. " File already processed.
    ENDIF.

  ENDIF. " IF fp_file IS NOT INITIAL AND p_a_file IS INITIAL.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_FILE_NEEDED
*&---------------------------------------------------------------------*
FORM f_validate_file_needed  CHANGING fv_check_file TYPE c.

  CLEAR: fv_check_file.

* Create Sales Orders
  IF rb_so_ct IS NOT INITIAL.
    fv_check_file = abap_true.
  ENDIF.

* Create Credit/Debit Memos
  IF rb_cd_ct IS NOT INITIAL.
    fv_check_file = abap_true.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ROW_COLUMN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_get_row_column  CHANGING fp_begin_row  TYPE i
                                fp_begin_col  TYPE i
                                fp_end_row    TYPE i
                                fp_end_col    TYPE i.

* RB_SO_CT - Create Regular Order
  IF rb_so_ct IS NOT INITIAL.
    LOOP AT i_const INTO DATA(lst_const) WHERE devid = c_e506
                                          AND param1 = c_rb_so_ct. "#EC CI_STDSEQ
      IF lst_const-param2 = 'BEG_END_COL'.
        fp_begin_col = lst_const-low.
        fp_end_col   = lst_const-high.
      ELSEIF lst_const-param2 = 'BEG_END_ROW'.
        fp_begin_row = lst_const-low.
        fp_end_row   = lst_const-high.
      ENDIF.
    ENDLOOP.

* Create Credit/Debit Memo
  ELSEIF rb_cd_ct IS NOT INITIAL.
    LOOP AT i_const INTO lst_const WHERE devid  = c_e506
                                     AND param1 = c_rb_cd_ct. "#EC CI_STDSEQ
      IF lst_const-param2 = 'BEG_END_COL'.
        fp_begin_col = lst_const-low.
        fp_end_col   = lst_const-high.
      ELSEIF lst_const-param2 = 'BEG_END_ROW'.
        fp_begin_row = lst_const-low.
        fp_end_row   = lst_const-high.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_LOG_STAGING_ORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_create_log_staging_ord  USING    fp_lst_regular_ord TYPE zstqtc_reg_ord
                                        fp_oid        TYPE numc10
                                        fp_item       TYPE posnr
                               CHANGING fp_lv_log     TYPE balognr
                                        fp_msgty      TYPE c
                                        fp_loghandle  TYPE balloghndl.

  STATICS:lst_regular_ord2 TYPE zstqtc_reg_ord.

  DATA: lv_matnr_err TYPE c.

  CONSTANTS:lc_zaor TYPE auart VALUE 'ZAOR',
            lc_za02 TYPE bsark VALUE 'ZA02',
            lc_za04 TYPE bsark VALUE 'ZA04'.

* Processing Header
  IF fp_lst_regular_ord-posnr IS INITIAL.
    IF st_log_handle IS INITIAL.
      CLEAR: v_error_file.
      lst_regular_ord2    = fp_lst_regular_ord.

      st_log-object     = 'ZQTC'.
      st_log-subobject  = 'ZQTC_ORD_E506'.
      st_log-extnumber  = fp_oid.
      st_log-aldate     = sy-datum.
      st_log-altime     = sy-uzeit.
      st_log-aluser     = sy-uname.
      st_log-alprog     = sy-repid.

*   Create Log to Add message(s)
      CLEAR:st_log_handle.
      CALL FUNCTION 'BAL_LOG_CREATE'
        EXPORTING
          i_s_log                 = st_log
        IMPORTING
          e_log_handle            = st_log_handle
        EXCEPTIONS
          log_header_inconsistent = 1
          OTHERS                  = 2.
      IF sy-subrc IS NOT INITIAL.
        CLEAR st_log_handle.
      ENDIF.
    ELSE. "IF st_log_handle IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Item Number missing in the file'(066).
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF. "IF st_log_handle IS INITIAL.
  ENDIF. " IF fp_lst_final-posnr IS INITIAL.

  IF fp_lst_regular_ord-posnr IS INITIAL.
* New Order
    IF st_log_handle IS NOT INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_i.
      st_msg-msgv1 = 'Processing Order'(005).
      st_msg-msgv2 = fp_lst_regular_ord-identifier.
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.

  ELSEIF fp_lst_regular_ord-posnr IS NOT INITIAL.
* Line Items of the Order
    IF st_log_handle IS NOT INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_i.
      st_msg-msgv1 = 'Processing Order'(005).
      st_msg-msgv2 = fp_lst_regular_ord-identifier.
      st_msg-msgv3 = 'Item'(006).
      st_msg-msgv4 = fp_lst_regular_ord-posnr.
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.
  ENDIF.

*-----Identifier
  IF fp_lst_regular_ord-identifier IS INITIAL.
    CLEAR:st_msg.
    st_msg-msgty = c_e.
    st_msg-msgv1 = 'Order Identifier is missing in the file'(007).
    PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
  ENDIF.

** Order Identifier
  IF fp_lst_regular_ord-auart IS NOT INITIAL AND v_auart NE fp_lst_regular_ord-auart.
    CLEAR:st_msg.
    st_msg-msgty = c_e.
    st_msg-msgv1 = 'Multiple Document Types provided for the same'(064).
    st_msg-msgv2 = 'order identifier in the file'(065).
    PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
  ENDIF.

* Fields in Header
  IF fp_lst_regular_ord-posnr IS INITIAL.
*-----Document Type
    IF fp_lst_regular_ord-auart IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Sales Document Type is missing in the file'(008).
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ELSEIF fp_lst_regular_ord-auart IS NOT INITIAL.
      READ TABLE i_auart TRANSPORTING NO FIELDS WITH KEY auart = fp_lst_regular_ord-auart
                                                         BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 =  'Sales Document Type in the file is Invalid'(009).
        PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ELSE.
        READ TABLE i_const TRANSPORTING NO FIELDS WITH KEY param1 = c_rb_so_ct
                                                           param2 = 'AUART'
                                                           low   = fp_lst_regular_ord-auart. "#EC CI_STDSEQ
        IF sy-subrc IS NOT INITIAL.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv1 =  'Sales Document Type in the file is Invalid'(009).
          PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                                   CHANGING   fp_lv_log
                                              fp_msgty
                                              fp_loghandle.
        ENDIF.
      ENDIF.
    ENDIF.

*-----Sales Organization
    IF fp_lst_regular_ord-vkorg IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Sales Organization is missing in the file'(010).
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ELSEIF fp_lst_regular_ord-vkorg IS NOT INITIAL.
      READ TABLE i_vkorg TRANSPORTING NO FIELDS WITH KEY vkorg = fp_lst_regular_ord-vkorg
                                                         BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = 'Sales Organization in the file is Invalid'(011).
        PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ELSE.
        READ TABLE i_const TRANSPORTING NO FIELDS WITH KEY param2 = 'VKORG'
                                                         low   = fp_lst_regular_ord-vkorg. "#EC CI_STDSEQ
        IF sy-subrc IS NOT INITIAL.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv1 =  'Sales Organization in the file is Invalid'(011).
          PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                                   CHANGING   fp_lv_log
                                              fp_msgty
                                              fp_loghandle.
        ENDIF.
      ENDIF.
    ENDIF.

*-----Distribution Channel
    IF fp_lst_regular_ord-vtweg IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Distribution Channel is missing in the file'(012).
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.

    ELSEIF fp_lst_regular_ord-vtweg IS NOT INITIAL.
      READ TABLE i_vtweg TRANSPORTING NO FIELDS WITH KEY vtweg = fp_lst_regular_ord-vtweg
                                                         BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 =  'Distribution Channel in the file is Invalid'(013).
        PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ELSE.
        READ TABLE i_const TRANSPORTING NO FIELDS WITH KEY param2 = 'VTWEG'
                                                         low   = fp_lst_regular_ord-vtweg. "#EC CI_STDSEQ
        IF sy-subrc IS NOT INITIAL.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv1 =  'Distribution Channel in the file is Invalid'(013).
          PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                                   CHANGING   fp_lv_log
                                              fp_msgty
                                              fp_loghandle.
        ENDIF.
      ENDIF.
    ENDIF.

*-----Division
    IF fp_lst_regular_ord-spart IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Division is missing in the file'(014).
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ELSEIF fp_lst_regular_ord-spart IS NOT INITIAL.
      READ TABLE i_spart TRANSPORTING NO FIELDS WITH KEY spart = fp_lst_regular_ord-spart
                                                         BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 =  'Division in the file in Invalid'(015).
        PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ENDIF.
    ENDIF.


*-----PO Type
    IF fp_lst_regular_ord-bsark IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'PO Type is missing in the file'(023).
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ELSEIF fp_lst_regular_ord-bsark IS NOT INITIAL.
      READ TABLE i_bsark TRANSPORTING NO FIELDS WITH KEY bsark = fp_lst_regular_ord-bsark
                                                         BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 =  'PO Type in the file is Invalid'(024).
        PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ENDIF.
    ENDIF.

*-----SP Partner Number - Header
    IF fp_lst_regular_ord-ag_kunnr IS INITIAL.
      CLEAR:st_msg.
      lv_matnr_err = abap_true.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Sold to Party is missing in the file'(016).
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ELSE.
      READ TABLE i_customer TRANSPORTING NO FIELDS WITH KEY kunnr = fp_lst_regular_ord-ag_kunnr BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = 'Sold to Party in the file is Invalid'(017).
        PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ENDIF.
    ENDIF.


** Token ID
    IF fp_lst_regular_ord-auart EQ lc_zaor AND ( fp_lst_regular_ord-bsark EQ lc_za02 OR fp_lst_regular_ord-bsark EQ lc_za04 )
      AND fp_lst_regular_ord-bstkd_e IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Token ID is mandatory for this PO type'(067).
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.

    ENDIF.
  ENDIF.

** Ship to Party
  IF fp_lst_regular_ord-we_kunnr IS NOT INITIAL.
    READ TABLE i_customer TRANSPORTING NO FIELDS WITH KEY kunnr = fp_lst_regular_ord-we_kunnr BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Ship to Party in the file is Invalid'(018).
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.
  ENDIF.

** Bill to Party
  IF fp_lst_regular_ord-re_kunnr IS NOT INITIAL.
    READ TABLE i_customer TRANSPORTING NO FIELDS WITH KEY kunnr = fp_lst_regular_ord-re_kunnr BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Bill to Party in the file is Invalid'(019).
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.
  ENDIF.

** Payer
  IF fp_lst_regular_ord-rg_kunnr IS NOT INITIAL.
    READ TABLE i_customer TRANSPORTING NO FIELDS WITH KEY kunnr = fp_lst_regular_ord-rg_kunnr BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Payer in the file is Invalid'(020).
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.
  ENDIF.

** Forwarding Agent
  IF fp_lst_regular_ord-cr_lifnr IS NOT INITIAL.
    READ TABLE i_vendor TRANSPORTING NO FIELDS WITH KEY lifnr = fp_lst_regular_ord-cr_lifnr. "#EC CI_STDSEQ
    IF sy-subrc NE 0.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Forwarding Agent(SP) in the file is Invalid'(021).
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.
  ENDIF.

*Fields at Line Item
  IF fp_lst_regular_ord-posnr IS NOT INITIAL.
*-----Material
    CLEAR lv_matnr_err.
    IF fp_lst_regular_ord-matnr IS INITIAL.
      CLEAR:st_msg.
      lv_matnr_err = abap_true.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Material is missing in the file'(025).
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ELSEIF fp_lst_regular_ord-matnr IS NOT INITIAL.
      READ TABLE i_matnr TRANSPORTING NO FIELDS WITH KEY matnr = fp_lst_regular_ord-matnr
                                                         BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR:st_msg.
        lv_matnr_err = abap_true.
        st_msg-msgty = c_e.
        st_msg-msgv1 = 'Material in the file is Invalid'(026).
        PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ENDIF.
    ENDIF.
*-----Material with Sales Area / PO Validation
    IF lv_matnr_err IS INITIAL.
      READ TABLE i_mvke TRANSPORTING NO FIELDS WITH KEY  matnr = fp_lst_regular_ord-matnr
                                                vkorg = lst_regular_ord2-vkorg  "from header
                                                vtweg = lst_regular_ord2-vtweg  "from header
                                                BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR:st_msg.
        lv_matnr_err = abap_true.
        st_msg-msgty = c_e.
        st_msg-msgv1 = 'Material not extended to '(027).
        CONCATENATE 'Sales Organization'(028) lst_regular_ord2-vkorg INTO st_msg-msgv2 SEPARATED BY space.
        CONCATENATE 'Distribution Channel'(029) lst_regular_ord2-vtweg INTO st_msg-msgv3 SEPARATED BY space.
        PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ELSE. "IF sy-subrc IS NOT INITIAL
*        IF fp_lst_regular_ord-bstnk IS INITIAL.
*          CLEAR:st_msg.
*          st_msg-msgty = c_w.
*          st_msg-msgv1 = 'Purchase Order should not be blank for this order'(030).
*          PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
*                                   CHANGING   fp_lv_log
*                                              fp_msgty
*                                              fp_loghandle.
*        ENDIF.
      ENDIF.
    ENDIF.

*-----Quantity
    IF fp_lst_regular_ord-kwmeng IS INITIAL.
      CLEAR:st_msg.
      lv_matnr_err = abap_true.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Quantity is missing in the file'(052).
      PERFORM f_adding_log_ord USING fp_lst_regular_ord fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADDING_LOG_ORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_adding_log_ord  USING fp_lst_regular_ord TYPE zstqtc_reg_ord
                             fp_item TYPE posnr
                       CHANGING   fp_lv_log   TYPE balognr
                                  fp_msgty    TYPE c
                                  fp_loghandle TYPE balloghndl.
  st_msg-msgid = 'ZQTC_R2'.
  st_msg-msgno = '000'.
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = st_log_handle
      i_s_msg          = st_msg
    EXCEPTIONS
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      OTHERS           = 4.
  IF sy-subrc IS NOT INITIAL.
    CLEAR st_log_handle.
  ENDIF.

  APPEND st_log_handle TO st_loghandle.

  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_client         = sy-mandt
      i_save_all       = abap_true
      i_t_log_handle   = st_loghandle
    IMPORTING
      e_new_lognumbers = i_lognum
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc EQ 0.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait          = abap_true
      EXCEPTIONS
        error_message = 1.

    IF sy-subrc EQ 0.
      CLEAR:st_e506_stage.
    ENDIF.
    READ TABLE i_lognum ASSIGNING FIELD-SYMBOL(<lfs_lognum>) INDEX 1.
    IF sy-subrc EQ 0.
      st_e506_stage-zlogno = <lfs_lognum>-lognumber.
*      lv_logno =  <lfs_lognum>-lognumber.
      fp_loghandle = <lfs_lognum>-log_handle.
      fp_lv_log = st_e506_stage-zlogno.
    ELSE.
      st_e506_stage-zlogno =  fp_lv_log."lv_logno.
    ENDIF.
    st_e506_stage-mandt = sy-mandt.
    st_e506_stage-zuid_upld =  p_v_oid."File Identifier
    st_e506_stage-zoid = fp_lst_regular_ord-identifier. " Order Identifier.
    st_e506_stage-zitem = fp_item.
    st_e506_stage-zuser = sy-uname.
    st_e506_stage-zfilepath = p_file.
    st_e506_stage-zcrtdat = sy-datum.
    st_e506_stage-zcrttim = sy-uzeit.
*   Capture the Message Type "Errors / Warning / Success.
    fp_msgty = st_msg-msgty.
*   If Error Update all lines of the Order to Error Status.
    IF v_error_file EQ abap_true OR st_msg-msgty = c_e.
      fp_msgty = c_e.
      st_e506_stage-zprcstat = c_f1. "'F1'.
      IF v_error_file NE abap_true.
        v_error_file = abap_true.
        LOOP AT i_e506_stage ASSIGNING FIELD-SYMBOL(<lfs_e506_stage>)
                             WHERE zuid_upld = p_v_oid
                               AND zoid      = fp_lst_regular_ord-identifier. "#EC CI_STDSEQ
          <lfs_e506_stage>-zprcstat = c_f1. "'F1'.
        ENDLOOP.
      ENDIF.
    ENDIF.
    APPEND st_e506_stage TO i_e506_stage.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CUSTOMERS_ORD
*&---------------------------------------------------------------------*
FORM f_get_customers_ord  USING    fp_i_regular_ord TYPE tt_regular_ord
                          CHANGING fp_i_customer    TYPE tt_customer
                                   fp_i_vendor      TYPE tt_vendor.

  DATA: li_regular_ord TYPE tt_regular_ord,
        li_customer    TYPE tt_customer,
        li_vendor      TYPE tt_vendor.

  IF fp_i_regular_ord[] IS NOT INITIAL.

    li_regular_ord[] = fp_i_regular_ord[].

    LOOP AT li_regular_ord INTO DATA(lst_regular_ord).
** Sold To Party
      APPEND INITIAL LINE TO li_customer ASSIGNING FIELD-SYMBOL(<lfs_customer>).
      IF <lfs_customer> IS ASSIGNED.
        <lfs_customer>-kunnr  = lst_regular_ord-ag_kunnr.
        UNASSIGN <lfs_customer>.
      ENDIF.

** Ship to Party
      IF lst_regular_ord-we_kunnr IS NOT INITIAL.
        APPEND INITIAL LINE TO li_customer ASSIGNING <lfs_customer>.
        IF <lfs_customer> IS ASSIGNED.
          <lfs_customer>-kunnr = lst_regular_ord-we_kunnr.
          UNASSIGN <lfs_customer>.
        ENDIF.
      ENDIF.

** Bill to Party
      IF lst_regular_ord-re_kunnr IS NOT INITIAL.
        APPEND INITIAL LINE TO li_customer ASSIGNING <lfs_customer>.
        IF <lfs_customer> IS ASSIGNED.
          <lfs_customer>-kunnr = lst_regular_ord-re_kunnr.
          UNASSIGN <lfs_customer>.
        ENDIF.
      ENDIF.

** Payer
      IF lst_regular_ord-rg_kunnr IS NOT INITIAL.
        APPEND INITIAL LINE TO li_customer ASSIGNING <lfs_customer>.
        IF <lfs_customer> IS ASSIGNED.
          <lfs_customer>-kunnr = lst_regular_ord-rg_kunnr.
          UNASSIGN <lfs_customer>.
        ENDIF.
      ENDIF.

** Forwarding Agent
      IF lst_regular_ord-cr_lifnr IS NOT INITIAL.
        APPEND INITIAL LINE TO li_vendor ASSIGNING FIELD-SYMBOL(<lfs_vendor>).
        IF <lfs_vendor> IS ASSIGNED.
          <lfs_vendor>-lifnr = lst_regular_ord-cr_lifnr.
          UNASSIGN <lfs_vendor>.
        ENDIF.
      ENDIF.

    ENDLOOP.

    SORT li_customer BY kunnr.
    DELETE ADJACENT DUPLICATES FROM li_customer COMPARING kunnr.
    DELETE li_customer WHERE kunnr IS INITIAL.           "#EC CI_STDSEQ

*   Selecting Customers from KNA1.
    IF li_customer IS NOT INITIAL.
      SELECT kunnr
        INTO TABLE @fp_i_customer
        FROM kna1
        FOR ALL ENTRIES IN @li_customer
        WHERE ( kunnr = @li_customer-kunnr ).
    ENDIF.

    SORT li_vendor BY lifnr.
    DELETE ADJACENT DUPLICATES FROM li_vendor COMPARING lifnr.

*   Selecting Vendors from LFA1.
    IF li_vendor IS NOT INITIAL.
      SELECT lifnr
        INTO TABLE @fp_i_vendor
        FROM lfa1
        FOR ALL ENTRIES IN @li_vendor
        WHERE ( lifnr = @li_vendor-lifnr ).             "#EC CI_NOFIELD

    ENDIF.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_INIT_DETIALS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_init_detials .

* Get Sales Organization (TVKO)
  SELECT vkorg
    INTO TABLE @i_vkorg
    FROM tvko.
  IF sy-subrc = 0.
    SORT i_vkorg BY vkorg.
  ENDIF.

* Get Distribution Channel (TVTW)
  SELECT vtweg
    INTO TABLE @i_vtweg
    FROM tvtw.
  IF sy-subrc = 0.
    SORT i_vtweg BY vtweg.
  ENDIF.

* Get Division (TSPA)
  SELECT spart
    INTO TABLE @i_spart
    FROM tspa.
  IF sy-subrc = 0.
    SORT i_spart BY spart.
  ENDIF.

* Get Sales Document Type (TVAK)
  SELECT auart
    INTO TABLE @i_auart
    FROM tvak.
  IF sy-subrc = 0.
    SORT i_auart BY auart.
  ENDIF.

* Get Sales Document Type (T176)
  SELECT bsark
    INTO TABLE @i_bsark
    FROM t176.
  IF sy-subrc = 0.
    SORT i_bsark BY bsark.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_RETAIN_LOG_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* Capture Messages based on below sequence
*  Error / Warning / Success or Information
*----------------------------------------------------------------------*
FORM f_retain_log_status  USING    fp_msgty TYPE c
                          CHANGING fp_ord_status TYPE c.

  IF ( fp_ord_status IS INITIAL ).
    fp_ord_status = fp_msgty.
    RETURN.
  ENDIF.

  IF ( fp_ord_status NE c_e ) AND
     ( fp_msgty = c_e ).
    fp_ord_status = c_e.
    RETURN.
  ENDIF.

  IF fp_ord_status NE c_e AND
     fp_msgty = c_w.
    fp_ord_status = c_w.
    RETURN.
  ENDIF.

  IF ( fp_ord_status NE c_e AND fp_ord_status NE c_w ) AND
     ( fp_msgty = c_s ).
    fp_ord_status = c_s.
    RETURN.
  ENDIF.

  IF ( fp_ord_status NE c_e AND fp_ord_status NE c_w AND fp_msgty = c_s ) AND
     ( fp_msgty = c_i ).
    fp_ord_status = c_i.
    RETURN.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MATERIAL_GROUP_ORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_get_material_group_ord  USING    fp_i_regular_ord TYPE tt_regular_ord
                               CHANGING fp_i_matnr       TYPE tt_matnr
                                        fp_i_mvke        TYPE tt_mvke.

  IF fp_i_regular_ord[] IS NOT INITIAL.
    DATA(li_regular_ord) = fp_i_regular_ord[].
    SORT li_regular_ord BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_regular_ord COMPARING matnr.
    DELETE li_regular_ord WHERE matnr IS INITIAL.        "#EC CI_STDSEQ

    IF li_regular_ord[] IS NOT INITIAL.
*   Select Materials from MARA
      SELECT matnr
        INTO TABLE @fp_i_matnr
        FROM mara
        FOR ALL ENTRIES IN @li_regular_ord
        WHERE matnr = @li_regular_ord-matnr.
      IF sy-subrc IS NOT INITIAL.
        CLEAR fp_i_matnr.
      ENDIF.
    ENDIF.

    li_regular_ord[] = fp_i_regular_ord[].
    SORT li_regular_ord BY matnr vkorg vtweg.
    DELETE ADJACENT DUPLICATES FROM li_regular_ord COMPARING matnr vkorg vtweg.

*   Select Material Group from MVKE
    SELECT matnr,
           vkorg,
           vtweg,
           dwerk  " Plant
      INTO TABLE @fp_i_mvke
      FROM mvke
      FOR ALL ENTRIES IN @li_regular_ord
      WHERE matnr = @li_regular_ord-matnr
        AND vkorg = @li_regular_ord-vkorg
        AND vtweg = @li_regular_ord-vtweg.
    IF sy-subrc IS NOT INITIAL.
      CLEAR fp_i_mvke.
    ENDIF.
  ENDIF.

  SORT fp_i_matnr BY matnr.
  SORT fp_i_mvke BY matnr vkorg vtweg.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_output .
  TYPE-POOLS : slis.

  DATA : li_fcat    TYPE slis_t_fieldcat_alv,
         lst_fcat   TYPE slis_fieldcat_alv,
         lst_layout TYPE slis_layout_alv,
         lv_val     TYPE i VALUE 1.

  lst_layout-colwidth_optimize = abap_true.
  lst_layout-zebra = abap_true.

  CLEAR: lv_val.
  lst_fcat-fieldname      = 'IDENTIFIER'.
  lst_fcat-tabname        = 'I_REG_ORD_OUT'.
  lst_fcat-seltext_m      = text-033. "Order Identifier
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname      = 'AUART'.
  lst_fcat-tabname        = 'I_REG_ORD_OUT'.
  lst_fcat-seltext_m      = text-034. "Sales Document Type
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname   = 'VKORG'.
  lst_fcat-tabname     = 'I_REG_ORD_OUT'.
  lst_fcat-seltext_m   = text-035.  "Sales org
  lst_fcat-col_pos     = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'VTWEG'.
  lst_fcat-tabname      = 'I_REG_ORD_OUT'.
  lst_fcat-seltext_m    = text-036. "Dist. channel
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'SPART'.
  lst_fcat-tabname      = 'I_REG_ORD_OUT'.
  lst_fcat-seltext_m    = text-037. "Division
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'AG_KUNNR'.
  lst_fcat-tabname      = 'I_REG_ORD_OUT'.
  lst_fcat-seltext_m    = text-038. "Sold to Party
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

*  lst_fcat-fieldname    = 'WE_KUNNR'.
*  lst_fcat-tabname      = 'I_REG_ORD_OUT'.
*  lst_fcat-seltext_m    = text-039. "Ship to Party
*  lst_fcat-col_pos      = lv_val.
*  APPEND lst_fcat TO li_fcat.
*  CLEAR  lst_fcat.
*  ADD 1 TO lv_val.
*
*  lst_fcat-fieldname    = 'BSARK'.
*  lst_fcat-tabname      = 'I_REG_ORD_OUT'.
*  lst_fcat-seltext_m    = text-040. "PO Type
*  lst_fcat-col_pos      = lv_val.
*  APPEND lst_fcat TO li_fcat.
*  CLEAR  lst_fcat.
*  ADD 1 TO lv_val.
*
*  lst_fcat-fieldname    = 'BSTNK'.
*  lst_fcat-tabname      = 'I_REG_ORD_OUT'.
*  lst_fcat-seltext_m    = text-041. "Purchase Order
*  lst_fcat-col_pos      = lv_val.
*  APPEND lst_fcat TO li_fcat.
*  CLEAR  lst_fcat.
*  ADD 1 TO lv_val.
*
*  lst_fcat-fieldname    = 'ZZPROMO'.
*  lst_fcat-tabname      = 'I_REG_ORD_OUT'.
*  lst_fcat-seltext_m    = text-042. "Promo code
*  lst_fcat-col_pos      = lv_val.
*  APPEND lst_fcat TO li_fcat.
*  CLEAR  lst_fcat.
*  ADD 1 TO lv_val.
*
*  lst_fcat-fieldname    = 'AUGRU'.
*  lst_fcat-tabname      = 'I_REG_ORD_OUT'.
*  lst_fcat-seltext_m    = text-043. "Order reason
*  lst_fcat-col_pos      = lv_val.
*  APPEND lst_fcat TO li_fcat.
*  CLEAR  lst_fcat.
*  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'ZLOGNO'.
  lst_fcat-tabname      = 'I_REG_ORD_OUT'.
  lst_fcat-seltext_m    = text-044. "Application log number
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'VBELN'.
  lst_fcat-tabname      = 'I_REG_ORD_OUT'.
  lst_fcat-seltext_m    = text-045. "Sales Document
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'STATUS'.
  lst_fcat-tabname      = 'I_REG_ORD_OUT'.
  lst_fcat-seltext_m    = text-046. "Status
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'MESSAGE'.
  lst_fcat-tabname      = 'I_REG_ORD_OUT'.
  lst_fcat-seltext_m    = text-047. "Message
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_grid_title       = text-048 " Bulk Order Creation Result
      it_fieldcat        = li_fcat
      is_layout          = lst_layout
    TABLES
      t_outtab           = i_reg_ord_out
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    CLEAR i_reg_ord_out[].
  ENDIF.
  REFRESH : li_fcat,
            i_reg_ord_out.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FILE_PATH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_get_file_path.
  DATA : lv_path       TYPE filepath-pathintern,
         lv_path_fname TYPE string.
  CLEAR : lv_path_fname,lv_path.

  lv_path = v_e506.
*--*Read file path from transaction FILE
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = lv_path
      operating_system           = sy-opsys
      file_name                  = v_path_fname
      eleminate_blanks           = abap_true
    IMPORTING
      file_name_with_path        = lv_path_fname
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE s001 DISPLAY LIKE c_e.
    LEAVE LIST-PROCESSING.
  ELSE.
    v_path_fname = lv_path_fname.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SFILE_APP_ORD_SUBMIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_sfile_app_ord_submit .
*** Local Constant Declaration
  CONSTANTS: lc_pipe       TYPE c VALUE '|',        " Tab of type Character
             lc_underscore TYPE char1 VALUE '_',    " Underscore of type CHAR1
             lc_extn       TYPE char4 VALUE '.csv', " Extn of type CHAR4
             lc_job_name   TYPE btcjob VALUE 'ZQTC_ORD_E506'. " Background job name

*** Local structure and internal table declaration
  DATA: lst_final_csv TYPE LINE OF truxs_t_text_data,
        li_final_csv  TYPE truxs_t_text_data.

  DATA: lv_job_number TYPE tbtcjob-jobcount, " Job Count
        lv_job_name   TYPE tbtcjob-jobname,  " Job Name
        lv_pre_chk    TYPE btcckstat,        " variable for pre. job status
        lv_kwmeng(15) TYPE c.

  LOOP AT i_regular_ord ASSIGNING FIELD-SYMBOL(<lfs_ord>).
    CLEAR:lst_final_csv.
** Moving quantity to local character varaibles for concatenation
    MOVE :<lfs_ord>-kwmeng TO lv_kwmeng.
    CONCATENATE <lfs_ord>-identifier
                <lfs_ord>-auart
                <lfs_ord>-vkorg
                <lfs_ord>-vtweg
                <lfs_ord>-spart
                <lfs_ord>-ag_kunnr
                <lfs_ord>-we_kunnr
                <lfs_ord>-re_kunnr
                <lfs_ord>-rg_kunnr
                <lfs_ord>-cr_lifnr
                <lfs_ord>-ve_pernr
                <lfs_ord>-bsark
                <lfs_ord>-bstnk
                <lfs_ord>-zzpromo
                <lfs_ord>-posnr
                <lfs_ord>-matnr
                 lv_kwmeng
                <lfs_ord>-pstyv
                <lfs_ord>-augru
                <lfs_ord>-bstkd_e
                <lfs_ord>-hd1_stxh
                <lfs_ord>-hd2_stxh
                <lfs_ord>-it1_stxh
                <lfs_ord>-it2_stxh
                <lfs_ord>-zlogno
                <lfs_ord>-log_handle
                <lfs_ord>-zoid
                <lfs_ord>-msgty
                <lfs_ord>-msgv1

         INTO lst_final_csv SEPARATED BY lc_pipe.

    APPEND lst_final_csv TO li_final_csv.
    CLEAR:lst_final_csv,
          lv_kwmeng.
  ENDLOOP.


  CONCATENATE lc_job_name
              lc_underscore
              sy-uname
              lc_underscore
              v_oid
              lc_extn
              INTO
              v_path_fname.

** Get Application Path
  PERFORM f_get_file_path.

  OPEN DATASET v_path_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
  LOOP AT li_final_csv INTO lst_final_csv.         "#EC CI_LOOP_INTO_WA
    TRANSFER lst_final_csv TO v_path_fname.
  ENDLOOP. " LOOP AT li_final_csv INTO lst_final_csv
  CLOSE DATASET v_path_fname.

**** Submit Program
  CLEAR lv_job_name.
  CONCATENATE lc_job_name '_' v_oid '_' sy-datum INTO lv_job_name.

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

    SUBMIT zqtcr_order_upload_e506  WITH rb_so_ct  = rb_so_ct
                                    WITH rb_cd_ct  = rb_cd_ct
                                    WITH p_v_oid  = v_oid
                                    WITH p_file  = p_file
                                    WITH p_a_file = v_path_fname
                                    WITH p_job    = p_job
                                    USER  'QTC_BATCH01'
                                    VIA JOB lv_job_name NUMBER lv_job_number
                                    AND RETURN.

** close the background job for successor jobs
    CALL FUNCTION 'JOB_CLOSE'
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
    IF sy-subrc IS NOT INITIAL.
      CLEAR lv_job_name.
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF sy-subrc = 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FROM_APP_ORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_read_from_app_ord .
  DATA : lv_string       TYPE string,
         lst_regular_ord TYPE zstqtc_reg_ord,
         lv_kwmeng(15)   TYPE c.

  OPEN DATASET p_a_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
  IF sy-subrc NE 0.
    MESSAGE e100(zqtc_r2). " File does not transfer to Application server
    LEAVE LIST-PROCESSING.
  ELSE.
*   Adding Success Messages.
    MESSAGE s303(zqtc_r2) WITH p_v_oid.  " Unique ID "&1" is assigned for this file upload.
    MESSAGE s000(zqtc_r2) WITH 'Application File'(049)
                               p_a_file+0(23) p_a_file+23(50) p_a_file+73.
  ENDIF. " IF sy-subrc NE 0

  DO.
    READ DATASET p_a_file INTO lv_string.
    IF sy-subrc EQ 0.
      SPLIT lv_string AT '|' INTO lst_regular_ord-identifier
                lst_regular_ord-auart
                lst_regular_ord-vkorg
                lst_regular_ord-vtweg
                lst_regular_ord-spart
                lst_regular_ord-ag_kunnr
                lst_regular_ord-we_kunnr
                lst_regular_ord-re_kunnr
                lst_regular_ord-rg_kunnr
                lst_regular_ord-cr_lifnr
                lst_regular_ord-ve_pernr
                lst_regular_ord-bsark
                lst_regular_ord-bstnk
                lst_regular_ord-zzpromo
                lst_regular_ord-posnr
                lst_regular_ord-matnr
                lv_kwmeng
                lst_regular_ord-pstyv
                lst_regular_ord-augru
                lst_regular_ord-bstkd_e
                lst_regular_ord-hd1_stxh
                lst_regular_ord-hd2_stxh
                lst_regular_ord-it1_stxh
                lst_regular_ord-it2_stxh
                lst_regular_ord-zlogno
                lst_regular_ord-log_handle
                lst_regular_ord-zoid
                lst_regular_ord-msgty
                lst_regular_ord-msgv1.
      MOVE lv_kwmeng TO lst_regular_ord-kwmeng.
      APPEND lst_regular_ord TO i_regular_ord.
      CLEAR  lst_regular_ord.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      EXIT.
    ENDIF. " IF sy-subrc EQ 0
  ENDDO.
  CLOSE DATASET p_a_file.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL_MOVE_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_send_email_move_file.

  DATA:
    lv_row_count_bg_max TYPE i,
    lv_lines            TYPE sy-tabix.

  CONSTANTS: lc_bg_max_count TYPE rvari_vnam VALUE 'ROW_COUNT_BG_MAX'.  " Maximum row count for attachment

  IF p_a_file IS NOT INITIAL.

    DESCRIBE TABLE i_reg_ord_out LINES lv_lines.
    READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lfs_constant>) WITH KEY param2 = lc_bg_max_count. "#EC CI_STDSEQ
    IF <lfs_constant> IS ASSIGNED.
      lv_row_count_bg_max = <lfs_constant>-low.
    ENDIF.

    IF lv_lines LE lv_row_count_bg_max.  " Row count less than maximum row conut for email attachment
      PERFORM f_send_attchment.
    ELSE.
*  Sending instruction email for download report
      PERFORM f_send_email_for_downlaod.
    ENDIF.
  ENDIF. " IF p_a_file IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_ATTCHMENT.
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_attchment.

  DATA:li_lines  TYPE idmx_di_t_tline,          "Table for read text
       lst_lines TYPE tline,                    "Workarea for line
       lv_name   TYPE thead-tdname.             "Name

  CONSTANTS:lc_st     TYPE thead-tdid    VALUE 'ST',                "Text ID of text to be read
            lc_object TYPE thead-tdobject VALUE 'TEXT',             "Object of text to be read
            lc_e      TYPE thead-tdspras VALUE 'E'.

*-  Populate table with details to be entered into .xls file
  PERFORM f_build_batch_log_data.

  lv_name = 'ZQTC_ORD_EMAIL_E506'.
  REFRESH li_lines[].

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = lc_e
      name                    = lv_name
      object                  = lc_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7.
  IF sy-subrc = 0.
*- Populate message body text
    REFRESH i_message.
* Populate Email Subject.
    LOOP AT li_lines INTO lst_lines.
      st_imessage = lst_lines-tdline.
      APPEND st_imessage TO i_message.
      CLEAR st_imessage.
    ENDLOOP.
  ENDIF.
*- Send file by email as .xls speadsheet
  PERFORM f_send_csv_xls_log.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_BATCH_LOG_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_batch_log_data.

  DATA:lv_vtweg TYPE char50,  "For Distribution Channel Leading Zeros
       lv_spart TYPE char50.  "For Division Leading Zeros
*- For Final Records
** For Regular Order
  IF rb_so_ct EQ abap_true.
    LOOP AT i_reg_ord_out INTO DATA(lst_output).
      IF i_attach_success[] IS INITIAL.
        CONCATENATE text-033 text-034 text-035 text-036 text-037
                    text-038 text-044 text-063 text-045 text-046 text-047
            INTO i_attach_success SEPARATED BY con_tab. "c_separator."con_tab.
        APPEND i_attach_success.
        CLEAR i_attach_success.
      ENDIF.

      IF i_attach_error[] IS INITIAL.
        CONCATENATE text-033 text-034 text-035 text-036 text-037
                    text-038 text-044 text-063 text-045 text-046 text-047
            INTO i_attach_error SEPARATED BY con_tab. "c_separator."con_tab.
        APPEND i_attach_error.
        CLEAR i_attach_error.
      ENDIF.

      IF i_attach_total[] IS INITIAL.
        CONCATENATE text-033 text-034 text-035 text-036 text-037
                    text-038 text-044 text-063 text-045 text-046 text-047
            INTO i_attach_total SEPARATED BY con_tab. "c_separator."con_tab.
        APPEND i_attach_total.
        CLEAR i_attach_total.
      ENDIF.
      CLEAR: lv_vtweg,lv_spart.
      CONCATENATE '=REPLACE("' lst_output-vtweg '",1,2,"'
                               lst_output-vtweg '")' INTO lv_vtweg.
      CONCATENATE '=REPLACE("' lst_output-spart '",1,2,"'
                               lst_output-spart '")' INTO lv_spart.
      IF lst_output-status EQ text-053.
        CONCATENATE lst_output-identifier
                    lst_output-auart
                    lst_output-vkorg
                    lv_vtweg
                    lv_spart
                    lst_output-ag_kunnr
                    lst_output-zlogno
                    lst_output-zoid
                    lst_output-vbeln
                    lst_output-status
                    lst_output-message
                   INTO i_attach_success SEPARATED BY con_tab."c_separator.
        CONCATENATE con_cret i_attach_success  INTO i_attach_success.
        APPEND  i_attach_success.
        CLEAR i_attach_success.

      ELSEIF lst_output-status EQ text-054.
        CONCATENATE lst_output-identifier
                    lst_output-auart
                    lst_output-vkorg
                    lv_vtweg
                    lv_spart
                    lst_output-ag_kunnr
                    lst_output-zlogno
                    lst_output-zoid
                    lst_output-vbeln
                    lst_output-status
                    lst_output-message
             INTO i_attach_error SEPARATED BY con_tab."c_separator.
        CONCATENATE con_cret i_attach_error  INTO i_attach_error.
        APPEND  i_attach_error.
        CLEAR i_attach_error .
      ENDIF.
      CONCATENATE lst_output-identifier
                    lst_output-auart
                    lst_output-vkorg
                    lv_vtweg
                    lv_spart
                    lst_output-ag_kunnr
                    lst_output-zlogno
                    lst_output-zoid
                    lst_output-vbeln
                    lst_output-status
                    lst_output-message
                     INTO i_attach_total SEPARATED BY con_tab."c_separator.
      CONCATENATE con_cret i_attach_total  INTO i_attach_total.
      APPEND  i_attach_total.
      CLEAR i_attach_total.

    ENDLOOP.

** Credit/Debit Memos
  ELSEIF rb_cd_ct EQ abap_true.

    LOOP AT i_crdrme_out INTO DATA(lst_output_crdr).
      IF i_attach_success[] IS INITIAL.
        CONCATENATE text-033 text-034 text-035 text-036 text-037
                    text-038 text-044 text-063 text-045 text-046 text-047
            INTO i_attach_success SEPARATED BY con_tab. "c_separator."con_tab.
        APPEND i_attach_success.
      ENDIF.

      IF i_attach_error[] IS INITIAL.
        CONCATENATE text-033 text-034 text-035 text-036 text-037
                    text-038 text-044 text-063 text-045 text-046 text-047
            INTO i_attach_error SEPARATED BY con_tab. "c_separator."con_tab.
        APPEND i_attach_error.
      ENDIF.

      IF i_attach_total[] IS INITIAL.
        CONCATENATE text-033 text-034 text-035 text-036 text-037
                    text-038 text-044 text-063 text-045 text-046 text-047
            INTO i_attach_total SEPARATED BY con_tab. "c_separator."con_tab.
        APPEND i_attach_total.
      ENDIF.

      CLEAR: lv_vtweg,lv_spart.
      CONCATENATE '=REPLACE("' lst_output_crdr-vtweg '",1,2,"'
                               lst_output_crdr-vtweg '")' INTO lv_vtweg.
      CONCATENATE '=REPLACE("' lst_output_crdr-spart '",1,2,"'
                               lst_output_crdr-spart '")' INTO lv_spart.
      IF lst_output_crdr-status EQ text-053.
        CONCATENATE lst_output_crdr-identifier
                    lst_output_crdr-auart
                    lst_output_crdr-vkorg
                    lv_vtweg
                    lv_spart
                    lst_output_crdr-ag_kunnr
                    lst_output_crdr-zlogno
                    lst_output_crdr-zoid
                    lst_output_crdr-vbeln
                    lst_output_crdr-status
                    lst_output_crdr-message
                   INTO i_attach_success SEPARATED BY con_tab."c_separator.
        CONCATENATE con_cret i_attach_success  INTO i_attach_success.
        APPEND  i_attach_success.

      ELSEIF lst_output_crdr-status EQ text-054.
        CONCATENATE lst_output_crdr-identifier
                    lst_output_crdr-auart
                    lst_output_crdr-vkorg
                    lv_vtweg
                    lv_spart
                    lst_output_crdr-ag_kunnr
                    lst_output_crdr-zlogno
                    lst_output_crdr-zoid
                    lst_output_crdr-vbeln
                    lst_output_crdr-status
                    lst_output_crdr-message
             INTO i_attach_error SEPARATED BY con_tab."c_separator.
        CONCATENATE con_cret i_attach_error  INTO i_attach_error.
        APPEND  i_attach_error.
      ENDIF.
      CONCATENATE lst_output_crdr-identifier
                    lst_output_crdr-auart
                    lst_output_crdr-vkorg
                    lv_vtweg
                    lv_spart
                    lst_output_crdr-ag_kunnr
                    lst_output_crdr-zlogno
                    lst_output_crdr-zoid
                    lst_output_crdr-vbeln
                    lst_output_crdr-status
                    lst_output_crdr-message
                     INTO i_attach_total SEPARATED BY con_tab."c_separator.
      CONCATENATE con_cret i_attach_total  INTO i_attach_total.
      APPEND  i_attach_total.

    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_CSV_XLS_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LV_LINES  text
*----------------------------------------------------------------------*
FORM f_send_csv_xls_log.
  DATA: lst_xdocdata             LIKE sodocchgi1,
        lv_lines_total(15)       TYPE n,
        lv_lines_tmp(15)         TYPE c,
        lv_lines_success(15)     TYPE n,
        lv_lines_success_tmp(15) TYPE c,
        lv_lines_error(15)       TYPE n,
        lv_lines_error_tmp(15)   TYPE c,
        lv_total                 TYPE sy-tabix.

* Fill the document data.
  lst_xdocdata-doc_size = 1.
  v_job_name = p_job.

  DESCRIBE TABLE i_attach_total   LINES lv_total.

*- Fill the document data and get size of attachment
  CLEAR lst_xdocdata.
  READ TABLE i_attach_total INDEX lv_total.
  lst_xdocdata-doc_size =
     ( lv_total - 1 ) * c_255 + strlen( i_attach_total ).

*- Populate the subject/generic message attributes
  lst_xdocdata-obj_langu  = sy-langu.
  lst_xdocdata-obj_name   = c_saprpt.
  lst_xdocdata-obj_descr = text-048 && ` ` && ':' && ` ` && sy-sysid. "Mass Order Creation Result

  CLEAR i_attachment.
  REFRESH i_attachment.
  i_attachment[] = i_attach_total[].

*- Describe the body of the message
  CLEAR i_packing_list.  REFRESH i_packing_list.
  i_packing_list-transf_bin = space.
  i_packing_list-head_start = 1.
  i_packing_list-head_num   = 0.
  i_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES i_packing_list-body_num.
  i_packing_list-doc_type = c_raw. " RAW
  APPEND i_packing_list.

  IF i_reg_ord_out[] IS NOT INITIAL OR i_crdrme_out[] IS NOT INITIAL.
    CLEAR: lv_lines_success,lv_lines_success_tmp.
    DESCRIBE TABLE i_attach_success LINES lv_lines_success.
    lv_lines_success_tmp = lv_lines_success - 1.
    CONDENSE lv_lines_success_tmp.
* First Line is Header; If more than one record, some data exists for the attachment
    IF lv_lines_success_tmp GE 1.
*- Create attachment notification
      i_packing_list-transf_bin = abap_true.
      i_packing_list-head_start = 1.
      i_packing_list-head_num   = 1.
      i_packing_list-body_start = 1.

      CONCATENATE text-053 sy-datum sy-uzeit INTO i_packing_list-obj_descr SEPARATED BY c_underscore. "Success
      i_packing_list-doc_type   =  c_xls.
      i_packing_list-obj_name   =  text-053.
      i_packing_list-body_num   =  lv_lines_success.
      i_packing_list-doc_size   =  lv_lines_success * c_255.
      APPEND i_packing_list.
    ENDIF.

    CLEAR : lv_lines_error,lv_lines_error_tmp.
    DESCRIBE TABLE i_attach_error LINES lv_lines_error.
    lv_lines_error_tmp = lv_lines_error - 1.
    CONDENSE lv_lines_error_tmp.
* First Line is Header; If more than one record, some data exists for the attachment
    IF lv_lines_error_tmp  GE 1.
*- Create attachment notification
      i_packing_list-transf_bin = abap_true.
      i_packing_list-head_start = 1.
      i_packing_list-head_num   = 1.
      i_packing_list-body_start = lv_lines_success_tmp + 1.

      CONCATENATE text-054 sy-datum sy-uzeit INTO i_packing_list-obj_descr SEPARATED BY c_underscore. "Error
      i_packing_list-doc_type   =  c_xls. " 'XLS'.
      i_packing_list-obj_name   =  text-054.
      i_packing_list-body_num   =  lv_lines_error.
      i_packing_list-doc_size   =  lv_lines_error * c_255.
      APPEND i_packing_list.
    ENDIF.
  ENDIF.
  IF v_email IS NOT INITIAL.
    CLEAR i_receivers.
    i_receivers-receiver   = v_email.
    i_receivers-rec_type   = c_u.
    i_receivers-com_type   = c_int. " INT
    i_receivers-notif_del  = abap_true.
    i_receivers-notif_ndel = abap_true.
    APPEND i_receivers.
  ELSE.
    SELECT SINGLE addrnumber,
                  persnumber FROM usr21 INTO @DATA(lst_usr21) WHERE bname = @sy-uname.
    IF sy-subrc IS INITIAL.
      IF lst_usr21 IS NOT INITIAL.
        SELECT SINGLE addrnumber,
                      smtp_addr FROM adr6 INTO @DATA(lst_adr6) WHERE addrnumber = @lst_usr21-addrnumber "#EC CI_NOORDER
                                                               AND   persnumber = @lst_usr21-persnumber.
        IF sy-subrc IS NOT INITIAL.
          CLEAR lst_adr6.
        ENDIF.
      ENDIF.
    ENDIF.
*- Add the recipients email address
    CLEAR i_receivers.
    REFRESH i_receivers.
    i_receivers-receiver   = lst_adr6-smtp_addr.
    i_receivers-rec_type   = c_u.
    i_receivers-com_type   = c_int." INT.
    i_receivers-notif_del  = abap_true.
    i_receivers-notif_ndel = abap_true.
    APPEND i_receivers.
  ENDIF.
  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lst_xdocdata
      put_in_outbox              = abap_true
      commit_work                = abap_true
    TABLES
      packing_list               = i_packing_list
      contents_bin               = i_attachment
      contents_txt               = i_message
      receivers                  = i_receivers
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
    MESSAGE text-050 TYPE c_i. "Error in sending Email
  ELSE.
    MESSAGE text-051 TYPE c_s. "Email sent with Success log file
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_CRDRME_CRT_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_FILE  text
*----------------------------------------------------------------------*
FORM f_convert_crdrme_crt_excel  USING  fp_p_file TYPE localfile. " Local file for upload/download.

  DATA : li_excel        TYPE STANDARD TABLE OF alsmex_tabline  " Rows for Table with Excel Data
                         INITIAL SIZE 0,                        " Rows for Table with Excel Data
         lst_excel_dummy TYPE                   alsmex_tabline, " Rows for Table with Excel Data
         lst_excel       TYPE                   alsmex_tabline, " Rows for Table with Excel Data
         lst_crdrme_crt  TYPE zstqtc_cr_dr_memo.                  " Order Input Structure

  DATA: lv_kwmeng         TYPE char17,
        lv_begin_row      TYPE i,
        lv_begin_col      TYPE i,
        lv_end_row        TYPE i,
        lv_end_col        TYPE i,
        lv_oid(10)        TYPE n,
        lv_msg            TYPE char100,
        lv_msgty          TYPE char1,
        lv_item           TYPE posnr,
        lvf_skip_row      TYPE char1,
        lv_index          TYPE sy-tabix,
        lv_identifier(10) TYPE n,        " Order Identifier
        lv_log            TYPE balognr,
        lv_loghandle      TYPE balloghndl.

  STATICS: lv_ord_status   TYPE c.

  IF fp_p_file IS NOT INITIAL.
** Get Excel Start Rows & End Rows
    PERFORM f_get_row_column CHANGING lv_begin_row
                                      lv_begin_col
                                      lv_end_row
                                      lv_end_col.


    CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
      EXPORTING
        filename                = fp_p_file
        i_begin_col             = lv_begin_col
        i_begin_row             = lv_begin_row
        i_end_col               = lv_end_col
        i_end_row               = lv_end_row
      TABLES
        intern                  = li_excel
      EXCEPTIONS
        inconsistent_parameters = 1
        upload_ole              = 2
        OTHERS                  = 3.
    IF sy-subrc EQ 0.
*    *************NOW FILL DATA FROM EXCEL INTO FINAL LEGACY DATA ITAB--***************
      IF NOT li_excel[] IS INITIAL.
        CLEAR lst_crdrme_crt.
        LOOP AT li_excel INTO lst_excel.
          lst_excel_dummy = lst_excel.
          IF lst_excel_dummy-value(1) EQ text-sqt.
            lst_excel_dummy-value(1) = space.
            SHIFT lst_excel_dummy-value LEFT DELETING LEADING space.
          ENDIF. " IF lst_excel_dummy-value(1) EQ text-sqt

          AT NEW row.
            CLEAR lvf_skip_row.
*         If row starts with Order Identifier, Mandatory or Optional Skip the Row
            IF lst_excel_dummy-value IN ir_row_txt.
              lvf_skip_row = abap_true.
            ENDIF.
          ENDAT.

          IF lvf_skip_row  IS NOT INITIAL.
            CONTINUE.
          ENDIF.

          AT NEW col.

            CASE lst_excel_dummy-col.
              WHEN c_1.

                IF lst_excel_dummy-value IS NOT INITIAL.
                  " Process only with Numeric value for Identifier
                  FIND REGEX '[[:digit:]]' IN lst_excel_dummy-value.
                  IF sy-subrc NE 0.
                    MESSAGE s600(zqtc_r2) DISPLAY LIKE c_e.
                    LEAVE LIST-PROCESSING.
                  ENDIF.
                  lst_crdrme_crt-identifier = lst_excel_dummy-value(10).
                ELSE.
                  MESSAGE s593(zqtc_r2) DISPLAY LIKE c_e.
                  LEAVE LIST-PROCESSING.
                ENDIF.
                CONDENSE lst_crdrme_crt-identifier.
                CLEAR lst_excel_dummy.

              WHEN c_2.
                lst_crdrme_crt-auart = lst_excel_dummy-value(4).
                IF lst_crdrme_crt-auart IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-auart
                    IMPORTING
                      output = lst_crdrme_crt-auart.
                ENDIF. " IF lst_crdrme_crt-auart IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_3.
                lst_crdrme_crt-vkorg = lst_excel_dummy-value(4).

                IF lst_crdrme_crt-vkorg IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-vkorg
                    IMPORTING
                      output = lst_crdrme_crt-vkorg.
                ENDIF. " IF lst_crdrme_crt-vkorg IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_4.
                lst_crdrme_crt-vtweg = lst_excel_dummy-value(2).
                IF lst_crdrme_crt-vtweg IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-vtweg
                    IMPORTING
                      output = lst_crdrme_crt-vtweg.
                ENDIF. " IF lst_crdrme_crt-vtweg IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_5.
                lst_crdrme_crt-spart = lst_excel_dummy-value(2).
                IF lst_crdrme_crt-spart IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-spart
                    IMPORTING
                      output = lst_crdrme_crt-spart.
                ENDIF. " IF lst_crdrme_crt-spart IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_6.
                lst_crdrme_crt-ag_kunnr = lst_excel_dummy-value(10).
                IF lst_crdrme_crt-ag_kunnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-ag_kunnr
                    IMPORTING
                      output = lst_crdrme_crt-ag_kunnr.
                ENDIF. " IF lst_crdrme_crt-ag_kunnr IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_7.
                lst_crdrme_crt-we_kunnr = lst_excel_dummy-value(10).
                IF lst_crdrme_crt-we_kunnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-we_kunnr
                    IMPORTING
                      output = lst_crdrme_crt-we_kunnr.
                ENDIF. " IF lst_crdrme_crt-we_kunnr IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_8.
                lst_crdrme_crt-re_kunnr = lst_excel_dummy-value(10).
                IF lst_crdrme_crt-re_kunnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-re_kunnr
                    IMPORTING
                      output = lst_crdrme_crt-re_kunnr.
                ENDIF. " IF lst_crdrme_crt-re_kunnr IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_9.
                lst_crdrme_crt-rg_kunnr = lst_excel_dummy-value(10).
                IF lst_crdrme_crt-rg_kunnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-rg_kunnr
                    IMPORTING
                      output = lst_crdrme_crt-rg_kunnr.
                ENDIF. " IF lst_crdrme_crt-rg_kunnr IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_10.
                lst_crdrme_crt-cr_lifnr = lst_excel_dummy-value(10).
                IF lst_crdrme_crt-cr_lifnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-cr_lifnr
                    IMPORTING
                      output = lst_crdrme_crt-cr_lifnr.
                ENDIF. " IF lst_crdrme_crt-cr_lifnr IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_11.
                lst_crdrme_crt-ve_pernr = lst_excel_dummy-value(10).
                IF lst_crdrme_crt-ve_pernr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-ve_pernr
                    IMPORTING
                      output = lst_crdrme_crt-ve_pernr.
                ENDIF. " IF lst_crdrme_crt-ve_pernr IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_12.
                lst_crdrme_crt-bsark = lst_excel_dummy-value(4).
                CLEAR lst_excel_dummy.
              WHEN c_13.
                lst_crdrme_crt-bstnk = lst_excel_dummy-value(20).
                IF lst_crdrme_crt-bstnk IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-bstnk
                    IMPORTING
                      output = lst_crdrme_crt-bstnk.
                ENDIF. " IF lst_crdrme_crt-bstnk IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_14.
                lst_crdrme_crt-zzpromo = lst_excel_dummy-value(10).

                IF lst_crdrme_crt-zzpromo IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-zzpromo
                    IMPORTING
                      output = lst_crdrme_crt-zzpromo.
                ENDIF. " IF lst_crdrme_crt-zzpromo IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_15.
                WRITE lst_excel_dummy-value(06) TO lst_crdrme_crt-posnr.
                IF lst_crdrme_crt-posnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-posnr
                    IMPORTING
                      output = lst_crdrme_crt-posnr.
                ENDIF. " IF lst_crdrme_crt-posnr IS NOT INITIAL

              WHEN c_16.

                lst_crdrme_crt-matnr = lst_excel_dummy-value(18).

                IF lst_crdrme_crt-matnr IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-matnr
                    IMPORTING
                      output = lst_crdrme_crt-matnr.

                  CLEAR lst_excel_dummy.
                ENDIF. " IF lst_crdrme_crt-matnr IS NOT INITIAL
              WHEN c_17.
                lv_kwmeng  =  lst_excel_dummy-value(13).
                TRY.
                    lst_crdrme_crt-kwmeng  = lv_kwmeng.
                  CATCH cx_root.
*                 Message: Quantity & is not in the correct format
                    MESSAGE i131(o3) WITH lst_excel_dummy-value. " Quantity & is not in the correct format
                    LEAVE LIST-PROCESSING.
                ENDTRY.
                CLEAR lst_excel_dummy.

              WHEN c_18.
                lst_crdrme_crt-pstyv = lst_excel_dummy-value(4).
                IF lst_crdrme_crt-pstyv IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-pstyv
                    IMPORTING
                      output = lst_crdrme_crt-pstyv.
                ENDIF. " IF lst_crdrme_crt-pstyv IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_19.
                lst_crdrme_crt-augru = lst_excel_dummy-value(3).
                IF lst_crdrme_crt-augru IS NOT INITIAL.
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = lst_crdrme_crt-augru
                    IMPORTING
                      output = lst_crdrme_crt-augru.
                ENDIF. " IF lst_crdrme_crt-augru IS NOT INITIAL
                CLEAR lst_excel_dummy.

              WHEN c_20.
                lst_crdrme_crt-bstkd_e = lst_excel_dummy-value(35).
                CLEAR lst_excel_dummy.
              WHEN c_21.
                lst_crdrme_crt-hd1_stxh = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.
              WHEN c_22.
                lst_crdrme_crt-hd2_stxh = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.
              WHEN c_23.
                lst_crdrme_crt-it1_stxh = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.
              WHEN c_24.
                lst_crdrme_crt-it2_stxh = lst_excel_dummy-value.
                CLEAR lst_excel_dummy.
            ENDCASE.
          ENDAT.

          AT END OF row.
            IF NOT lst_crdrme_crt IS INITIAL.
              APPEND lst_crdrme_crt TO i_crdrme_crt.
              CLEAR lst_crdrme_crt.
            ENDIF. " IF NOT lst_crdrme_crt IS INITIAL
          ENDAT.
        ENDLOOP. " LOOP AT li_excel INTO lst_excel
*   Populating the Last line
        IF lst_crdrme_crt IS NOT INITIAL.
          APPEND lst_crdrme_crt TO i_crdrme_crt.
          CLEAR lst_crdrme_crt.
        ENDIF.
      ENDIF. " IF NOT li_excel[] IS INITIAL
    ENDIF. " IF sy-subrc EQ 0


    IF i_crdrme_crt IS NOT INITIAL.
      IF p_v_oid IS NOT INITIAL.
        v_oid   = p_v_oid.
        lv_oid  = p_v_oid.
      ELSE.
        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            nr_range_nr             = c_zq
            object                  = c_zqtc_uplid
            quantity                = c_quantity
          IMPORTING
            number                  = lv_oid
          EXCEPTIONS
            interval_not_found      = 1
            number_range_not_intern = 2
            object_not_found        = 3
            quantity_is_0           = 4
            quantity_is_not_1       = 5
            interval_overflow       = 6
            buffer_overflow         = 7
            OTHERS                  = 8.
        IF sy-subrc EQ 0.
          v_oid   = lv_oid.
          p_v_oid = lv_oid.
        ENDIF.
      ENDIF.
      IF lv_oid IS NOT INITIAL.
        CONCATENATE 'Your Upload File Identification Number is'(003)
                    lv_oid
               INTO lv_msg SEPARATED BY space.
        CALL FUNCTION 'POPUP_TO_INFORM'
          EXPORTING
            titel = text-004
            txt1  = lv_msg
            txt2  = ''.
      ENDIF.
    ELSE.
      MESSAGE i000 WITH text-022 DISPLAY LIKE c_e. "Input file is Empty
      LEAVE LIST-PROCESSING.
    ENDIF. "IF fp_i_crdrme_crt IS NOT INITIAL.

*   Get Customers
    PERFORM f_get_customers_crdr USING i_crdrme_crt
                             CHANGING i_customer i_vendor.

**   Get Material
    PERFORM f_get_material_crdr USING i_crdrme_crt
                                  CHANGING i_matnr
                                            i_mvke.
* Process Input File and Create SLG Logs
    SORT: i_customer BY kunnr,
          i_const BY param2 low.
    LOOP AT i_crdrme_crt ASSIGNING FIELD-SYMBOL(<lfs_i_crdrme_crt>).
      CLEAR:lv_msgty.
      lst_crdrme_crt = <lfs_i_crdrme_crt>.
      lv_item = lst_crdrme_crt-posnr.
      AT NEW identifier.
        lv_index      = sy-tabix.
        lv_identifier = lst_crdrme_crt-identifier.
        v_auart       = lst_crdrme_crt-auart.
      ENDAT.
      PERFORM f_create_log_staging_crdr USING    lst_crdrme_crt  lv_oid  lv_item
                                       CHANGING lv_log  lv_msgty  lv_loghandle.
      IF lv_msgty IS INITIAL.
        lv_msgty = c_i.
      ENDIF.
      PERFORM f_retain_log_status USING    lv_msgty
                                  CHANGING lv_ord_status.
      <lfs_i_crdrme_crt>-zlogno     = lv_log.         "Application log: log number
      <lfs_i_crdrme_crt>-log_handle = lv_loghandle.   "Application Log: Log Handle
      <lfs_i_crdrme_crt>-zoid       = lv_oid.         "Order Identifier in Upload File

      AT END OF identifier.
*       At Last Identifier (Order) - Update all Lines of the Order with message Status
        LOOP AT i_crdrme_crt ASSIGNING FIELD-SYMBOL(<lfs_i_crdrme_crt1>) FROM lv_index. "#EC CI_NESTED
          IF <lfs_i_crdrme_crt1>-identifier <> lv_identifier.
            CLEAR: lv_index, lv_identifier,v_auart,st_log_handle.
            EXIT.
          ENDIF.
          <lfs_i_crdrme_crt1>-msgty = lv_ord_status.
          CASE lv_ord_status.
            WHEN c_i OR c_s.
              <lfs_i_crdrme_crt1>-msgv1 = 'File Validation - Successful'(060).
            WHEN c_w.
              <lfs_i_crdrme_crt1>-msgv1 = 'File Validation - Warnings'(061).
            WHEN c_e.
              <lfs_i_crdrme_crt1>-msgv1 = 'File Validation - Error'(062).
            WHEN OTHERS.
          ENDCASE.
        ENDLOOP.
        CLEAR: lv_ord_status.
      ENDAT.
    ENDLOOP.

    IF i_e506_stage[] IS NOT INITIAL.
      MODIFY zqtc_stagng_e506 FROM TABLE i_e506_stage.
    ENDIF.

** Cound the Input File Count.
    DESCRIBE TABLE i_crdrme_crt LINES v_lines.

  ELSE.
    MESSAGE i000 WITH text-031 DISPLAY LIKE c_e. "Input File is mandatory
    LEAVE LIST-PROCESSING.
  ENDIF.  "IF fp_p_file IS NOT INITIAL.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_CRDR_MEMO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_create_crdr_memo.
** Call Method for creating Credit/Debit Memos
  CALL METHOD zqtccl_orders_create=>create_cr_dr_memo
    IMPORTING
      ex_cr_dr_memo_out = i_crdrme_out
    CHANGING
      ch_cr_dr_memo     = i_crdrme_crt.


  IF p_a_file IS INITIAL.
    IF i_crdrme_out[] IS NOT INITIAL.
** Display output in Foreground
      PERFORM f_display_output_cr_dr.
    ENDIF.
  ELSE.
** Send out mail in background
    PERFORM f_send_email_move_file_cr_dr.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_CRDR_MEMO_BG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_crdr_memo_bg.
** Place the file in Application Server and trigger BG
  PERFORM f_sfile_app_crdt_submit.
  MESSAGE i528(zqtc_r2) WITH v_line_lmt v_job_name sy-datum sy-uzeit.
  SET SCREEN 0.
  LEAVE SCREEN.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SFILE_APP_CRDT_SUBMIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_sfile_app_crdt_submit .
*** Local Constant Declaration
  CONSTANTS: lc_pipe       TYPE c VALUE '|',        " Tab of type Character
             lc_underscore TYPE char1 VALUE '_',    " Underscore of type CHAR1
             lc_extn       TYPE char4 VALUE '.csv', " Extn of type CHAR4
             lc_job_name   TYPE btcjob VALUE 'ZQTC_CRDT_UPD_E506'. " Background job name


*** Local structure and internal table declaration
  DATA: lst_final_csv TYPE LINE OF truxs_t_text_data,
        li_final_csv  TYPE truxs_t_text_data.

  DATA: lv_job_number TYPE tbtcjob-jobcount, " Job Count
        lv_job_name   TYPE tbtcjob-jobname,  " Job Name
        lv_pre_chk    TYPE btcckstat,        " variable for pre. job status
        lv_kwmeng(15) TYPE c.

  LOOP AT i_crdrme_crt ASSIGNING FIELD-SYMBOL(<lfs_crdrme>).
    CLEAR:lst_final_csv.
** Moving quantity to local character varaibles for concatenation
    MOVE :<lfs_crdrme>-kwmeng TO lv_kwmeng.
    CONCATENATE <lfs_crdrme>-identifier
                <lfs_crdrme>-auart
                <lfs_crdrme>-vkorg
                <lfs_crdrme>-vtweg
                <lfs_crdrme>-spart
                <lfs_crdrme>-ag_kunnr
                <lfs_crdrme>-we_kunnr
                <lfs_crdrme>-re_kunnr
                <lfs_crdrme>-rg_kunnr
                <lfs_crdrme>-cr_lifnr
                <lfs_crdrme>-ve_pernr
                <lfs_crdrme>-bsark
                <lfs_crdrme>-bstnk
                <lfs_crdrme>-zzpromo
                <lfs_crdrme>-posnr
                <lfs_crdrme>-matnr
                 lv_kwmeng
                <lfs_crdrme>-pstyv
                <lfs_crdrme>-augru
                <lfs_crdrme>-bstkd_e
                <lfs_crdrme>-hd1_stxh
                <lfs_crdrme>-hd2_stxh
                <lfs_crdrme>-it1_stxh
                <lfs_crdrme>-it2_stxh
                <lfs_crdrme>-zlogno
                <lfs_crdrme>-log_handle
                <lfs_crdrme>-zoid
                <lfs_crdrme>-msgty
                <lfs_crdrme>-msgv1

         INTO lst_final_csv SEPARATED BY lc_pipe.

    APPEND lst_final_csv TO li_final_csv.
    CLEAR:lst_final_csv,
          lv_kwmeng.
  ENDLOOP.


  CONCATENATE lc_job_name
              lc_underscore
              sy-uname
              lc_underscore
              v_oid
              lc_extn
              INTO
              v_path_fname.

  PERFORM f_get_file_path.

  OPEN DATASET v_path_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
  LOOP AT li_final_csv INTO lst_final_csv.         "#EC CI_LOOP_INTO_WA
    TRANSFER lst_final_csv TO v_path_fname.
  ENDLOOP. " LOOP AT li_final_csv INTO lst_final_csv
  CLOSE DATASET v_path_fname.

**** Submit Program
  CLEAR lv_job_name.
  CONCATENATE lc_job_name '_' v_oid '_' sy-datum INTO lv_job_name.

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

    SUBMIT zqtcr_order_upload_e506  WITH rb_so_ct  = rb_so_ct
                                    WITH rb_cd_ct  = rb_cd_ct
                                    WITH p_v_oid  = v_oid
                                    WITH p_file  = p_file
                                    WITH p_a_file = v_path_fname
                                    WITH p_job    = p_job
                                    USER  'QTC_BATCH01'
                                    VIA JOB lv_job_name NUMBER lv_job_number
                                    AND RETURN.

** close the background job for successor jobs
    CALL FUNCTION 'JOB_CLOSE'
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
    IF sy-subrc IS NOT INITIAL.
      CLEAR lv_job_name.
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FROM_APP_CRDRME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_read_from_app_crdrme.
  DATA : lv_string      TYPE string,
         lst_crdrme_crt TYPE zstqtc_cr_dr_memo,
         lv_kwmeng(15)  TYPE c.

  OPEN DATASET p_a_file FOR INPUT IN TEXT MODE ENCODING DEFAULT. " Set as Ready for Input
  IF sy-subrc NE 0.
    MESSAGE e100(zqtc_r2). " File does not transfer to Application server
    LEAVE LIST-PROCESSING.
  ELSE.
*   Adding Success Messages.
    MESSAGE s303(zqtc_r2) WITH p_v_oid.  " Unique ID "&1" is assigned for this file upload.
    MESSAGE s000(zqtc_r2) WITH 'Application File'(049)
                               p_a_file+0(23) p_a_file+23(50) p_a_file+73.
  ENDIF. " IF sy-subrc NE 0

  DO.
    READ DATASET p_a_file INTO lv_string.
    IF sy-subrc EQ 0.
      SPLIT lv_string AT '|' INTO lst_crdrme_crt-identifier
                lst_crdrme_crt-auart
                lst_crdrme_crt-vkorg
                lst_crdrme_crt-vtweg
                lst_crdrme_crt-spart
                lst_crdrme_crt-ag_kunnr
                lst_crdrme_crt-we_kunnr
                lst_crdrme_crt-re_kunnr
                lst_crdrme_crt-rg_kunnr
                lst_crdrme_crt-cr_lifnr
                lst_crdrme_crt-ve_pernr
                lst_crdrme_crt-bsark
                lst_crdrme_crt-bstnk
                lst_crdrme_crt-zzpromo
                lst_crdrme_crt-posnr
                lst_crdrme_crt-matnr
                lv_kwmeng
                lst_crdrme_crt-pstyv
                lst_crdrme_crt-augru
                lst_crdrme_crt-bstkd_e
                lst_crdrme_crt-hd1_stxh
                lst_crdrme_crt-hd2_stxh
                lst_crdrme_crt-it1_stxh
                lst_crdrme_crt-it2_stxh
                lst_crdrme_crt-zlogno
                lst_crdrme_crt-log_handle
                lst_crdrme_crt-zoid
                lst_crdrme_crt-msgty
                lst_crdrme_crt-msgv1.
      MOVE lv_kwmeng TO lst_crdrme_crt-kwmeng.
      APPEND lst_crdrme_crt TO i_crdrme_crt.
      CLEAR  lst_crdrme_crt.
    ELSE. " ELSE -> IF sy-subrc EQ 0
      EXIT.
    ENDIF. " IF sy-subrc EQ 0
  ENDDO.
  CLOSE DATASET p_a_file.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL_FOR_DOWNLAOD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_send_email_for_downlaod .

  DATA:li_lines     TYPE idmx_di_t_tline,          "Table for read text
       lst_lines    TYPE tline,                    "Workarea for line
       lv_name      TYPE thead-tdname,             "Name
       lst_xdocdata LIKE sodocchgi1,
       lv_lines     TYPE n.

  CONSTANTS:lc_st                 TYPE thead-tdid     VALUE 'ST',                 "Text ID of text to be read
            lc_object             TYPE thead-tdobject VALUE 'TEXT',             "Object of text to be read
            lc_e                  TYPE thead-tdspras  VALUE 'E',
            lc_so10_text_app_mail TYPE rvari_vnam     VALUE 'SO10_TEXT_APP_MAIL'.

* Upload Excel file in Application Server
  PERFORM f_upload_to_folder.

  READ TABLE i_const INTO DATA(lst_const) WITH KEY param1 = c_rb_so_ct
                                                   param2 = lc_so10_text_app_mail. "#EC CI_STDSEQ
  IF sy-subrc IS INITIAL.
    lv_name = lst_const-low.
  ENDIF.

  CLEAR: li_lines[].

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = lc_e
      name                    = lv_name
      object                  = lc_object
    TABLES
      lines                   = li_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7.
  IF sy-subrc = 0.
*- Populate message body text
    REFRESH i_message.
* Populate Email Subject.
    LOOP AT li_lines INTO lst_lines.
      st_imessage = lst_lines-tdline.
      REPLACE ALL OCCURRENCES OF '&FILE_NAME&' IN st_imessage WITH v_a_output_path.
      APPEND st_imessage TO i_message.
      CLEAR st_imessage.
    ENDLOOP.
  ENDIF.

* Fill the document data.
  lst_xdocdata-doc_size = 1.
  DESCRIBE TABLE i_message LINES lv_lines.
  READ TABLE i_message INTO st_imessage INDEX lv_lines.
  lst_xdocdata-doc_size = ( lv_lines - 1 ) * c_255 + strlen( st_imessage ).

*- Populate the subject/generic message attributes
  lst_xdocdata-obj_langu  = sy-langu.
  lst_xdocdata-obj_name   = c_saprpt.
  lst_xdocdata-obj_descr = text-048 && ` ` && ':' && ` ` && sy-sysid. "Mass Order Creation Result

*  v_job_name = p_job.

*- Describe the body of the message
  CLEAR i_packing_list.  REFRESH i_packing_list.
  i_packing_list-transf_bin = space.
  i_packing_list-head_start = 1.
  i_packing_list-head_num   = 0.
  i_packing_list-body_start = 1.
  DESCRIBE TABLE i_message LINES i_packing_list-body_num.
  i_packing_list-doc_type = c_raw. " RAW
  APPEND i_packing_list.

  IF v_email IS NOT INITIAL.
    CLEAR i_receivers.
    i_receivers-receiver   = v_email.
    i_receivers-rec_type   = c_u.
    i_receivers-com_type   = c_int. " INT
    i_receivers-notif_del  = abap_true.
    i_receivers-notif_ndel = abap_true.
    APPEND i_receivers.
  ELSE.
    SELECT SINGLE addrnumber,
                  persnumber FROM usr21 INTO @DATA(lst_usr21) WHERE bname = @sy-uname.
    IF sy-subrc IS INITIAL.
      IF lst_usr21 IS NOT INITIAL.
        SELECT SINGLE addrnumber,
                      smtp_addr FROM adr6 INTO @DATA(lst_adr6) WHERE addrnumber = @lst_usr21-addrnumber "#EC CI_NOORDER
                                                               AND   persnumber = @lst_usr21-persnumber.
        IF sy-subrc IS NOT INITIAL.
          CLEAR lst_adr6.
        ENDIF.
      ENDIF.
    ENDIF.
*- Add the recipients email address
    CLEAR i_receivers.
    REFRESH i_receivers.
    i_receivers-receiver   = lst_adr6-smtp_addr.
    i_receivers-rec_type   = c_u.
    i_receivers-com_type   = c_int." INT.
    i_receivers-notif_del  = abap_true.
    i_receivers-notif_ndel = abap_true.
    APPEND i_receivers.
  ENDIF.
  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lst_xdocdata
      put_in_outbox              = abap_true
      commit_work                = abap_true
    TABLES
      packing_list               = i_packing_list
      contents_bin               = i_attachment
      contents_txt               = i_message
      receivers                  = i_receivers
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
    MESSAGE text-050 TYPE c_i."Error in sending Email
  ELSE.
    MESSAGE text-051 TYPE c_s. "Email sent with Success log file
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD_TO_FOLDER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_upload_to_folder .

  DATA: lv_path     TYPE localfile,
        lv_fullpath TYPE localfile,
        lv_string   TYPE string,
        lv_extn     TYPE string.

  CONSTANTS: lc_extn  TYPE char4 VALUE '.XLS'.
  lv_fullpath = p_a_file.
  REPLACE ALL OCCURRENCES OF '/E506/in' IN lv_fullpath WITH '/E506/prc'.
  SPLIT   lv_fullpath AT '.' INTO lv_path lv_extn.

  CONCATENATE lv_path lc_extn INTO lv_path.
  CONDENSE lv_path NO-GAPS.

  IF rb_so_ct EQ abap_true.
    OPEN DATASET lv_path FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
    IF sy-subrc IS INITIAL.
      LOOP AT i_reg_ord_out INTO DATA(lst_output).

        AT FIRST.
          CONCATENATE text-033
                      text-034
                      text-035
                      text-036
                      text-037
                      text-038
                      text-044
                      text-063
                      text-045
                      text-046
                      text-047
                      INTO lv_string
                      SEPARATED BY cl_abap_char_utilities=>horizontal_tab IN CHARACTER MODE.
          TRANSFER lv_string TO lv_path.   " Column Names to AL11
        ENDAT.

** Fill the data
        CONCATENATE lst_output-identifier
                    lst_output-auart
                    lst_output-vkorg
                    lst_output-vtweg
                    lst_output-spart
                    lst_output-ag_kunnr
                    lst_output-zlogno
                    lst_output-zoid
                    lst_output-vbeln
                    lst_output-status
                    lst_output-message INTO lv_string SEPARATED BY cl_abap_char_utilities=>horizontal_tab IN CHARACTER MODE.
        TRANSFER lv_string TO lv_path.   " Output data to AL11
      ENDLOOP.
      CLOSE DATASET lv_path.

      v_a_output_path = lv_path.
    ENDIF.

  ELSEIF rb_cd_ct EQ abap_true.

    OPEN DATASET lv_path FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
    IF sy-subrc IS INITIAL.
      LOOP AT i_crdrme_out INTO DATA(lst_output_crdr).

        AT FIRST.
          CONCATENATE text-033
                      text-034
                      text-035
                      text-036
                      text-037
                      text-038
                      text-044
                      text-063
                      text-045
                      text-046
                      text-047
                      INTO lv_string
                      SEPARATED BY cl_abap_char_utilities=>horizontal_tab IN CHARACTER MODE.
          TRANSFER lv_string TO lv_path.   " Column Names to AL11
        ENDAT.

** Fill the data
        CONCATENATE lst_output_crdr-identifier
                    lst_output_crdr-auart
                    lst_output_crdr-vkorg
                    lst_output_crdr-vtweg
                    lst_output_crdr-spart
                    lst_output_crdr-ag_kunnr
                    lst_output_crdr-zlogno
                    lst_output_crdr-zoid
                    lst_output_crdr-vbeln
                    lst_output_crdr-status
                    lst_output_crdr-message INTO lv_string SEPARATED BY cl_abap_char_utilities=>horizontal_tab IN CHARACTER MODE.
        TRANSFER lv_string TO lv_path.   " Output data to AL11
      ENDLOOP.
      CLOSE DATASET lv_path.

      v_a_output_path = lv_path.

    ENDIF.

  ENDIF.

  CLEAR:lv_fullpath.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_INITIALIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_initialization.

  REFRESH:i_const,
      i_regular_ord,
      i_crdrme_crt,
      i_reg_ord_out,
      i_attach_success,
      i_attach_error,
      i_attach_total,
      ir_row_txt,
      i_lognum,
      i_e506_stage,
      i_customer,
      i_vendor,
      i_vkorg,
      i_vtweg,
      i_spart,
      i_auart,
      i_bsark,
      i_matnr,
      i_mvke,
      i_return,
      i_message,
      i_packing_list,
      i_receivers,
      i_attachment.

  CLEAR:st_msg,
        st_log,
        st_log_handle,
        st_loghandle,
        st_lognum,
        st_e506_stage,
        st_imessage.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CUSTOMERS_CRDR
*&---------------------------------------------------------------------*
FORM f_get_customers_crdr  USING   fp_i_cr_dr_memo TYPE tt_crdrme_crt
                          CHANGING fp_i_customer   TYPE tt_customer
                                   fp_i_vendor     TYPE tt_vendor.

  DATA: li_cr_dr_memo TYPE tt_crdrme_crt,
        li_customer   TYPE tt_customer,
        li_vendor     TYPE tt_vendor.

  IF fp_i_cr_dr_memo[] IS NOT INITIAL.

    li_cr_dr_memo[] = fp_i_cr_dr_memo[].

    LOOP AT li_cr_dr_memo INTO DATA(lst_cr_dr_memo).
** Sold To Party
      APPEND INITIAL LINE TO li_customer ASSIGNING FIELD-SYMBOL(<lfs_customer>).
      IF <lfs_customer> IS ASSIGNED.
        <lfs_customer>-kunnr  = lst_cr_dr_memo-ag_kunnr.
        UNASSIGN <lfs_customer>.
      ENDIF.

** Ship to Party
      IF lst_cr_dr_memo-we_kunnr IS NOT INITIAL.
        APPEND INITIAL LINE TO li_customer ASSIGNING <lfs_customer>.
        IF <lfs_customer> IS ASSIGNED.
          <lfs_customer>-kunnr = lst_cr_dr_memo-we_kunnr.
          UNASSIGN <lfs_customer>.
        ENDIF.
      ENDIF.

** Bill to Party
      IF lst_cr_dr_memo-re_kunnr IS NOT INITIAL.
        APPEND INITIAL LINE TO li_customer ASSIGNING <lfs_customer>.
        IF <lfs_customer> IS ASSIGNED.
          <lfs_customer>-kunnr = lst_cr_dr_memo-re_kunnr.
          UNASSIGN <lfs_customer>.
        ENDIF.
      ENDIF.

** Payer
      IF lst_cr_dr_memo-rg_kunnr IS NOT INITIAL.
        APPEND INITIAL LINE TO li_customer ASSIGNING <lfs_customer>.
        IF <lfs_customer> IS ASSIGNED.
          <lfs_customer>-kunnr = lst_cr_dr_memo-rg_kunnr.
          UNASSIGN <lfs_customer>.
        ENDIF.
      ENDIF.

** Forwarding Agent
      IF lst_cr_dr_memo-cr_lifnr IS NOT INITIAL.
        APPEND INITIAL LINE TO li_vendor ASSIGNING FIELD-SYMBOL(<lfs_vendor>).
        IF <lfs_vendor> IS ASSIGNED.
          <lfs_vendor>-lifnr = lst_cr_dr_memo-cr_lifnr.
          UNASSIGN <lfs_vendor>.
        ENDIF.
      ENDIF.

    ENDLOOP.

    SORT li_customer BY kunnr.
    DELETE ADJACENT DUPLICATES FROM li_customer COMPARING kunnr.
    DELETE li_customer WHERE kunnr IS INITIAL.           "#EC CI_STDSEQ

*   Selecting Customers from KNA1.
    IF li_customer IS NOT INITIAL.
      SELECT kunnr
        INTO TABLE @fp_i_customer
        FROM kna1
        FOR ALL ENTRIES IN @li_customer
        WHERE ( kunnr = @li_customer-kunnr ).
    ENDIF.

    SORT li_vendor BY lifnr.
    DELETE ADJACENT DUPLICATES FROM li_vendor COMPARING lifnr.
    DELETE li_vendor WHERE lifnr IS INITIAL.             "#EC CI_STDSEQ

*   Selecting Vendors from LFA1.
    IF li_vendor IS NOT INITIAL.
      SELECT lifnr
        INTO TABLE @fp_i_vendor
        FROM lfa1
        FOR ALL ENTRIES IN @li_vendor
        WHERE ( lifnr = @li_vendor-lifnr ).             "#EC CI_NOFIELD

      IF sy-subrc IS INITIAL.
        SORT fp_i_vendor BY lifnr.
      ENDIF.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MATERIAL_CRDR
*&---------------------------------------------------------------------*
FORM f_get_material_crdr  USING    fp_i_cr_dr_memo TYPE tt_crdrme_crt
                          CHANGING fp_i_matnr       TYPE tt_matnr
                                   fp_i_mvke        TYPE tt_mvke.
  DATA: li_cr_dr_memo  TYPE tt_crdrme_crt.

  IF fp_i_cr_dr_memo[] IS NOT INITIAL.
    li_cr_dr_memo[] = fp_i_cr_dr_memo[].
    SORT li_cr_dr_memo BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_cr_dr_memo COMPARING matnr.
    DELETE li_cr_dr_memo WHERE matnr IS INITIAL.         "#EC CI_STDSEQ

*   Select Materials from MARA
    IF li_cr_dr_memo[] IS NOT INITIAL.
      SELECT matnr
        INTO TABLE @fp_i_matnr
        FROM mara
        FOR ALL ENTRIES IN @li_cr_dr_memo
        WHERE matnr = @li_cr_dr_memo-matnr.
      IF sy-subrc IS NOT INITIAL.
        CLEAR fp_i_matnr.
      ENDIF.
    ENDIF.

    li_cr_dr_memo[] = fp_i_cr_dr_memo[].
    SORT li_cr_dr_memo BY matnr vkorg vtweg.
    DELETE ADJACENT DUPLICATES FROM li_cr_dr_memo COMPARING matnr vkorg vtweg.

*   Select Material Group from MVKE
    SELECT matnr,
           vkorg,
           vtweg,
           dwerk  " Plant
      INTO TABLE @fp_i_mvke
      FROM mvke
      FOR ALL ENTRIES IN @li_cr_dr_memo
      WHERE matnr = @li_cr_dr_memo-matnr
        AND vkorg = @li_cr_dr_memo-vkorg
        AND vtweg = @li_cr_dr_memo-vtweg.
    IF sy-subrc IS NOT INITIAL.
      CLEAR fp_i_mvke.
    ENDIF.
  ENDIF.

  SORT fp_i_matnr BY matnr.
  SORT fp_i_mvke BY matnr vkorg vtweg.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_LOG_STAGING_CRDR
*&---------------------------------------------------------------------*
FORM f_create_log_staging_crdr  USING   fp_lst_cr_dr_memo TYPE zstqtc_cr_dr_memo
                                        fp_oid        TYPE numc10
                                        fp_item       TYPE posnr
                               CHANGING fp_lv_log     TYPE balognr
                                        fp_msgty      TYPE c
                                        fp_loghandle  TYPE balloghndl.

  STATICS:lst_cr_dr_memo2 TYPE zstqtc_cr_dr_memo.

  DATA: lv_matnr_err TYPE c.

* Processing Header
  IF fp_lst_cr_dr_memo-posnr IS INITIAL.
    IF st_log_handle IS INITIAL.
      CLEAR: v_error_file.
      lst_cr_dr_memo2    = fp_lst_cr_dr_memo.

      st_log-object     = 'ZQTC'.
      st_log-subobject  = 'ZQTC_ORD_E506'.
      st_log-extnumber  = fp_oid.
      st_log-aldate     = sy-datum.
      st_log-altime     = sy-uzeit.
      st_log-aluser     = sy-uname.
      st_log-alprog     = sy-repid.

*   Create Log to Add message(s)
      CLEAR:st_log_handle.
      CALL FUNCTION 'BAL_LOG_CREATE'
        EXPORTING
          i_s_log                 = st_log
        IMPORTING
          e_log_handle            = st_log_handle
        EXCEPTIONS
          log_header_inconsistent = 1
          OTHERS                  = 2.
      IF sy-subrc IS NOT INITIAL.
        CLEAR st_log_handle.
      ENDIF.
    ELSE.  "IF st_log_handle IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Item Number missing in the file'(066).
      PERFORM f_adding_log_ord USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF. " IF st_log_handle IS INITIAL.
  ENDIF. " IF fp_lst_final-posnr IS INITIAL.

  IF fp_lst_cr_dr_memo-posnr IS INITIAL.
* New Order
    IF st_log_handle IS NOT INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_i.
      st_msg-msgv1 = 'Processing Order'(005).
      st_msg-msgv2 = fp_lst_cr_dr_memo-identifier.
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.
  ELSEIF fp_lst_cr_dr_memo-posnr IS NOT INITIAL.
* Line Items of the Order
    IF st_log_handle IS NOT INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_i.
      st_msg-msgv1 = 'Processing Order'(005).
      st_msg-msgv2 = fp_lst_cr_dr_memo-identifier.
      st_msg-msgv3 = 'Item'(006).
      st_msg-msgv4 = fp_lst_cr_dr_memo-posnr.
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.
  ENDIF.

*-----Identifier
  IF fp_lst_cr_dr_memo-identifier IS INITIAL.
    CLEAR:st_msg.
    st_msg-msgty = c_e.
    st_msg-msgv1 = 'Order Identifier is missing in the file'(007).
    PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
  ENDIF.

** Order Identifier
  IF fp_lst_cr_dr_memo-auart IS NOT INITIAL AND v_auart NE fp_lst_cr_dr_memo-auart.
    CLEAR:st_msg.
    st_msg-msgty = c_e.
    st_msg-msgv1 = 'Multiple Document Types provided for the same'(064).
    st_msg-msgv2 = 'order identifier in the file'(065).
    PERFORM f_adding_log_ord USING fp_lst_cr_dr_memo fp_item
                             CHANGING   fp_lv_log
                                        fp_msgty
                                        fp_loghandle.
  ENDIF.

* Fields in Header
  IF fp_lst_cr_dr_memo-posnr IS INITIAL.
*-----Document Type
    IF fp_lst_cr_dr_memo-auart IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Sales Document Type is missing in the file'(008).
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ELSEIF fp_lst_cr_dr_memo-auart IS NOT INITIAL.
      READ TABLE i_auart TRANSPORTING NO FIELDS WITH KEY auart = fp_lst_cr_dr_memo-auart
                                                         BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 =  'Sales Document Type in the file is Invalid'(009).
        PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ELSE.
        READ TABLE i_const TRANSPORTING NO FIELDS WITH KEY param1 = c_rb_cd_ct
                                                           param2 = 'AUART'
                                                           low   = fp_lst_cr_dr_memo-auart.
        IF sy-subrc IS NOT INITIAL.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv1 =  'Sales Document Type in the file is Invalid'(009).
          PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                                   CHANGING   fp_lv_log
                                              fp_msgty
                                              fp_loghandle.
        ENDIF.
      ENDIF.
    ENDIF.

*-----Sales Organization
    IF fp_lst_cr_dr_memo-vkorg IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Sales Organization is missing in the file'(010).
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ELSEIF fp_lst_cr_dr_memo-vkorg IS NOT INITIAL.
      READ TABLE i_vkorg TRANSPORTING NO FIELDS WITH KEY vkorg = fp_lst_cr_dr_memo-vkorg
                                                         BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = 'Sales Organization in the file is Invalid'(011).
        PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ELSE.
        READ TABLE i_const TRANSPORTING NO FIELDS WITH KEY param2 = 'VKORG'
                                                           low   = fp_lst_cr_dr_memo-vkorg BINARY SEARCH.
        IF sy-subrc IS NOT INITIAL.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv1 =  'Sales Organization in the file is Invalid'(011).
          PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                                   CHANGING   fp_lv_log
                                              fp_msgty
                                              fp_loghandle.
        ENDIF.
      ENDIF.
    ENDIF.

*-----Distribution Channel
    IF fp_lst_cr_dr_memo-vtweg IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Distribution Channel is missing in the file'(012).
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.

    ELSEIF fp_lst_cr_dr_memo-vtweg IS NOT INITIAL.
      READ TABLE i_vtweg TRANSPORTING NO FIELDS WITH KEY vtweg = fp_lst_cr_dr_memo-vtweg
                                                         BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 =  'Distribution Channel in the file is Invalid'(013).
        PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ELSE.
        READ TABLE i_const TRANSPORTING NO FIELDS WITH KEY param2 = 'VTWEG'
                                                           low   = fp_lst_cr_dr_memo-vtweg BINARY SEARCH.
        IF sy-subrc IS NOT INITIAL.
          CLEAR:st_msg.
          st_msg-msgty = c_e.
          st_msg-msgv1 =  'Distribution Channel in the file is Invalid'(013).
          PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                                   CHANGING   fp_lv_log
                                              fp_msgty
                                              fp_loghandle.
        ENDIF.
      ENDIF.
    ENDIF.

*-----Division
    IF fp_lst_cr_dr_memo-spart IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Division is missing in the file'(014).
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ELSEIF fp_lst_cr_dr_memo-spart IS NOT INITIAL.
      READ TABLE i_spart TRANSPORTING NO FIELDS WITH KEY spart = fp_lst_cr_dr_memo-spart
                                                         BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 =  'Division in the file in Invalid'(015).
        PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ENDIF.
    ENDIF.


*-----PO Type
    IF fp_lst_cr_dr_memo-bsark IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'PO Type is missing in the file'(023).
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ELSEIF fp_lst_cr_dr_memo-bsark IS NOT INITIAL.
      READ TABLE i_bsark TRANSPORTING NO FIELDS WITH KEY bsark = fp_lst_cr_dr_memo-bsark
                                                         BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 =  'PO Type in the file is Invalid'(024).
        PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ENDIF.
    ENDIF.

** Order Reason
    IF fp_lst_cr_dr_memo-augru IS INITIAL.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Order Reason is missing in the file'(030).
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.

*-----SP Partner Number - Header
    IF fp_lst_cr_dr_memo-ag_kunnr IS INITIAL.
      CLEAR:st_msg.
      lv_matnr_err = abap_true.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Sold to Party is missing in the file'(016).
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ELSE.
      READ TABLE i_customer TRANSPORTING NO FIELDS WITH KEY kunnr = fp_lst_cr_dr_memo-ag_kunnr BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR:st_msg.
        st_msg-msgty = c_e.
        st_msg-msgv1 = 'Sold to Party in the file is Invalid'(017).
        PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ENDIF.
    ENDIF.
  ENDIF.

** Ship to Party
  IF fp_lst_cr_dr_memo-we_kunnr IS NOT INITIAL.
    READ TABLE i_customer TRANSPORTING NO FIELDS WITH KEY kunnr = fp_lst_cr_dr_memo-we_kunnr BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Ship to Party in the file is Invalid'(018).
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.
  ENDIF.

** Bill to Party
  IF fp_lst_cr_dr_memo-re_kunnr IS NOT INITIAL.
    READ TABLE i_customer TRANSPORTING NO FIELDS WITH KEY kunnr = fp_lst_cr_dr_memo-re_kunnr BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Bill to Party in the file is Invalid'(019).
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.
  ENDIF.

** Payer
  IF fp_lst_cr_dr_memo-rg_kunnr IS NOT INITIAL.
    READ TABLE i_customer TRANSPORTING NO FIELDS WITH KEY kunnr = fp_lst_cr_dr_memo-rg_kunnr BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Payer in the file is Invalid'(020).
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.
  ENDIF.

** Forwarding Agent
  IF fp_lst_cr_dr_memo-cr_lifnr IS NOT INITIAL.
    READ TABLE i_vendor TRANSPORTING NO FIELDS WITH KEY lifnr = fp_lst_cr_dr_memo-cr_lifnr BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR:st_msg.
      st_msg-msgty = c_e.
      st_msg-msgv1 = 'Forwarding Agent(SP) in the file is Invalid'(021).
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.
  ENDIF.

*Fields at Line Item
  IF fp_lst_cr_dr_memo-posnr IS NOT INITIAL.
*-----Material
    CLEAR lv_matnr_err.
    IF fp_lst_cr_dr_memo-matnr IS INITIAL.
      CLEAR:st_msg.
      lv_matnr_err = abap_true.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Material is missing in the file'(025).
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ELSEIF fp_lst_cr_dr_memo-matnr IS NOT INITIAL.
      READ TABLE i_matnr TRANSPORTING NO FIELDS WITH KEY matnr = fp_lst_cr_dr_memo-matnr
                                                         BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR:st_msg.
        lv_matnr_err = abap_true.
        st_msg-msgty = c_e.
        st_msg-msgv1 = 'Material in the file is Invalid'(026).
        PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ENDIF.
    ENDIF.
*-----Material with Sales Area / PO Validation
    IF lv_matnr_err IS INITIAL.
      READ TABLE i_mvke TRANSPORTING NO FIELDS WITH KEY  matnr = fp_lst_cr_dr_memo-matnr
                                                vkorg = lst_cr_dr_memo2-vkorg  "from header
                                                vtweg = lst_cr_dr_memo2-vtweg  "from header
                                                BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLEAR:st_msg.
        lv_matnr_err = abap_true.
        st_msg-msgty = c_e.
        st_msg-msgv1 = 'Material not extended to '(027).
        CONCATENATE 'Sales Organization'(028) lst_cr_dr_memo2-vkorg INTO st_msg-msgv2 SEPARATED BY space.
        CONCATENATE 'Distribution Channel'(029) lst_cr_dr_memo2-vtweg INTO st_msg-msgv3 SEPARATED BY space.
        PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                                 CHANGING   fp_lv_log
                                            fp_msgty
                                            fp_loghandle.
      ENDIF.
    ENDIF.

*-----Quantity
    IF fp_lst_cr_dr_memo-kwmeng IS INITIAL.
      CLEAR:st_msg.
      lv_matnr_err = abap_true.
      st_msg-msgty = c_e.
      st_msg-msgv1 =  'Quantity is missing in the file'(052).
      PERFORM f_adding_log_crdr USING fp_lst_cr_dr_memo fp_item
                               CHANGING   fp_lv_log
                                          fp_msgty
                                          fp_loghandle.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADDING_LOG_CRDR
*&---------------------------------------------------------------------*
FORM f_adding_log_crdr  USING fp_lst_cr_dr_memo TYPE zstqtc_cr_dr_memo
                             fp_item TYPE posnr
                       CHANGING   fp_lv_log   TYPE balognr
                                  fp_msgty    TYPE c
                                  fp_loghandle TYPE balloghndl.
  st_msg-msgid = 'ZQTC_R2'.
  st_msg-msgno = '000'.
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = st_log_handle
      i_s_msg          = st_msg
    EXCEPTIONS
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      OTHERS           = 4.
  IF sy-subrc IS NOT INITIAL.
    CLEAR st_log_handle.
  ENDIF.

  APPEND st_log_handle TO st_loghandle.

  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_client         = sy-mandt
      i_save_all       = abap_true
      i_t_log_handle   = st_loghandle
    IMPORTING
      e_new_lognumbers = i_lognum
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc EQ 0.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait          = abap_true
      EXCEPTIONS
        error_message = 1.

    IF sy-subrc EQ 0.
      CLEAR:st_e506_stage.
    ENDIF.
    READ TABLE i_lognum ASSIGNING FIELD-SYMBOL(<lfs_lognum>) INDEX 1.
    IF sy-subrc EQ 0.
      st_e506_stage-zlogno = <lfs_lognum>-lognumber.
*      lv_logno =  <lfs_lognum>-lognumber.
      fp_loghandle = <lfs_lognum>-log_handle.
      fp_lv_log = st_e506_stage-zlogno.
    ELSE.
      st_e506_stage-zlogno =  fp_lv_log."lv_logno.
    ENDIF.
    st_e506_stage-mandt = sy-mandt.
    st_e506_stage-zuid_upld =  p_v_oid."File Identifier
    st_e506_stage-zoid = fp_lst_cr_dr_memo-identifier. " Order Identifier.
    st_e506_stage-zitem = fp_item.
    st_e506_stage-zuser = sy-uname.
    st_e506_stage-zfilepath = p_file.
    st_e506_stage-zcrtdat = sy-datum.
    st_e506_stage-zcrttim = sy-uzeit.
*   Capture the Message Type "Errors / Warning / Success.
    fp_msgty = st_msg-msgty.
*   If Error Update all lines of the Order to Error Status.
    IF v_error_file EQ abap_true OR st_msg-msgty = c_e.
      fp_msgty = c_e.
      st_e506_stage-zprcstat = c_f1. "'F1'.
      IF v_error_file NE abap_true.
        v_error_file = abap_true.
        LOOP AT i_e506_stage ASSIGNING FIELD-SYMBOL(<lfs_e506_stage>)
                             WHERE zuid_upld = p_v_oid
                               AND zoid      = fp_lst_cr_dr_memo-identifier. "#EC CI_STDSEQ
          <lfs_e506_stage>-zprcstat = c_f1. "'F1'.
        ENDLOOP.
      ENDIF.
    ENDIF.
    APPEND st_e506_stage TO i_e506_stage.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_OUTPUT_CR_DR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_output_cr_dr .

  TYPE-POOLS : slis.

  DATA : li_fcat    TYPE slis_t_fieldcat_alv,
         lst_fcat   TYPE slis_fieldcat_alv,
         lst_layout TYPE slis_layout_alv,
         lv_val     TYPE i VALUE 1.

  lst_layout-colwidth_optimize = abap_true.
  lst_layout-zebra = abap_true.

  CLEAR: lv_val.
  lst_fcat-fieldname      = 'IDENTIFIER'.
  lst_fcat-tabname        = 'I_CRDRME_OUT'.
  lst_fcat-seltext_m      = text-033. "Order Identifier
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname      = 'AUART'.
  lst_fcat-tabname        = 'I_CRDRME_OUT'.
  lst_fcat-seltext_m      = text-034. "Sales Document Type
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname   = 'VKORG'.
  lst_fcat-tabname     = 'I_CRDRME_OUT'.
  lst_fcat-seltext_m   = text-035.  "Sales org
  lst_fcat-col_pos     = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'VTWEG'.
  lst_fcat-tabname      = 'I_CRDRME_OUT'.
  lst_fcat-seltext_m    = text-036. "Dist. channel
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'SPART'.
  lst_fcat-tabname      = 'I_CRDRME_OUT'.
  lst_fcat-seltext_m    = text-037. "Division
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'AG_KUNNR'.
  lst_fcat-tabname      = 'I_CRDRME_OUT'.
  lst_fcat-seltext_m    = text-038. "Sold to Party
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'ZLOGNO'.
  lst_fcat-tabname      = 'I_CRDRME_OUT'.
  lst_fcat-seltext_m    = text-044. "Application log number
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'VBELN'.
  lst_fcat-tabname      = 'I_CRDRME_OUT'.
  lst_fcat-seltext_m    = text-045. "Sales Document
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'STATUS'.
  lst_fcat-tabname      = 'I_CRDRME_OUT'.
  lst_fcat-seltext_m    = text-046. "Status
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  lst_fcat-fieldname    = 'MESSAGE'.
  lst_fcat-tabname      = 'I_CRDRME_OUT'.
  lst_fcat-seltext_m    = text-047. "Message
  lst_fcat-col_pos      = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_grid_title       = text-048 " Bulk Order Creation Result
      it_fieldcat        = li_fcat
      is_layout          = lst_layout
    TABLES
      t_outtab           = i_crdrme_out
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    CLEAR i_crdrme_crt[].
  ENDIF.
  REFRESH : li_fcat,
            i_crdrme_crt.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL_MOVE_FILE_CR_DR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_send_email_move_file_cr_dr.

  DATA:
    lv_row_count_bg_max TYPE i,
    lv_lines            TYPE sy-tabix.

  CONSTANTS: lc_bg_max_count TYPE rvari_vnam VALUE 'ROW_COUNT_BG_MAX'.  " Maximum row count for attachment

  IF p_a_file IS NOT INITIAL.

    DESCRIBE TABLE i_crdrme_out LINES lv_lines.
    READ TABLE i_const ASSIGNING FIELD-SYMBOL(<lfs_constant>) WITH KEY param2 = lc_bg_max_count. "#EC CI_STDSEQ
    IF <lfs_constant> IS ASSIGNED.
      lv_row_count_bg_max = <lfs_constant>-low.
    ENDIF.

    IF lv_lines LE lv_row_count_bg_max.  " Row count less than maximum row conut for email attachment
      PERFORM f_send_attchment.
    ELSE.
*  Sending instruction email for download report
      PERFORM f_send_email_for_downlaod.
    ENDIF.
  ENDIF. " IF p_a_file IS NOT INITIAL

ENDFORM.
