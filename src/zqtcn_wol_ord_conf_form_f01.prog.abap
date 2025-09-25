*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WOL_ORD_CONF_FORM_F01
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_WOL_ORD_CONF_FORM_F01
* PROGRAM DESCRIPTION: This driver program is implemented for WOL
*                      Order Confirmation Email Form
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 17/03/2020
* OBJECT ID: F059
* TRANSPORT NUMBER(S): ED2K917812
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <........>
* REFERENCE NO: <........>
* DEVELOPER: <........>
* DATE: <........>
* DESCRIPTION: <........>
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_PROCESSING_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_processing_form CHANGING fp_v_returncode TYPE sysubrc.

  " Clear the data
  PERFORM f_get_clear.

  " Subroutine to fetch constant values
  PERFORM f_get_constant_values  USING c_devid_f059
                              CHANGING i_constants.

  " Subroutine to populate wiley logo
  PERFORM f_populate_logo_wiley CHANGING v_xstr_logo.

  " Subroutine to populate Form interface data
  PERFORM f_populate_st_wol_ord_inf  USING nast
                                  CHANGING st_wol_ord_inf.

  " Assign form name
  v_formname = c_zwol_form_name.

  IF v_ent_screen EQ abap_false AND
     nast-nacha = c_5. " Transmission medium: E-Mail ( External send )
    " Perform to send an E-Mail with an attachment of PDF
    PERFORM f_adobe_prnt_snd_mail CHANGING fp_v_returncode.
  ELSE.
    " Perform to print preview
    PERFORM f_populate_layout USING v_formname.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANT_VALUES
*&---------------------------------------------------------------------*
*  Retrieve constant values from table
*----------------------------------------------------------------------*
*      --> FP_V_DEVID  text
*      <-- FP_I_CONSTANT  text
*----------------------------------------------------------------------*
FORM f_get_constant_values  USING fp_v_devid     TYPE zdevid
                         CHANGING fp_i_constants TYPE tt_constant.

  SELECT devid, param1, param2, srno, sign, opti, low, high
         FROM zcaconstant INTO TABLE @fp_i_constants
         WHERE devid = @c_devid_f059 AND
            activate = @abap_true.
  IF sy-subrc = 0.
    " Nothing to do
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LOGO_WILEY
*&---------------------------------------------------------------------*
*  Subroutine to print wiley logo
*----------------------------------------------------------------------*
*      <-- P_V_XSTRING  text
*----------------------------------------------------------------------*
FORM f_populate_logo_wiley  CHANGING fp_v_xstring TYPE xstring.

* Local constant declaration
  CONSTANTS:
    lc_logo_name TYPE tdobname   VALUE 'ZJWILEY_LOGO', " Name
    lc_object    TYPE tdobjectgr VALUE 'GRAPHICS',     " SAPscript Graphics Management: Application object
    lc_id        TYPE tdidgr     VALUE 'BMAP',         " SAPscript Graphics Management: ID
    lc_btype     TYPE tdbtype    VALUE 'BMON'.         " Graphic type

* To Get a BDS Graphic in BMP Format
  CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
    EXPORTING
      p_object       = lc_object     " GRAPHICS
      p_name         = lc_logo_name  " ZJWILEY_LOGO
      p_id           = lc_id         " BMAP
      p_btype        = lc_btype      " BMON
    RECEIVING
      p_bmp          = fp_v_xstring " Image Data
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
  IF sy-subrc NE 0.
    CLEAR fp_v_xstring.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_ST_HEADER
*&---------------------------------------------------------------------*
*  Populate Header data
*----------------------------------------------------------------------*
*      -->FP_NAST  text
*      <--FP_ST_HEADER  text
*----------------------------------------------------------------------*
FORM f_populate_st_wol_ord_inf  USING  fp_nast           TYPE nast                          " Message Status
                             CHANGING  fp_st_wol_ord_inf TYPE zstqtc_wol_ord_conf_inf_f059. " Structure for WOL Order Confirmation Interface

  " Local Data declaration
  DATA:
    lv_kunnr      TYPE kunnr,                       " Customer Number
    lv_name1      TYPE name1_gp,                    " Name 1
    lv_po         TYPE bstnk,                       " Customer purchase order number
    lv_ord_date   TYPE erdat,                       " Date on Which Record Was Created
    lv_doc_curr   TYPE waerk,                       " SD Document Currency
    lv_tdline     TYPE tdline,                      " Text Line
    lst_header    TYPE zstqtc_wol_ord_conf_hdr_f059,  " Struc: Header of WOL Order Confirmation Form
    li_item_data  TYPE ztqtc_wol_ord_conf_item_f059,  " Itab: WOL Order Confirmation Item Data
    lst_item_data TYPE zstqtc_wol_ord_conf_itm_f059,  " Struc: WOL Order Confirmation Item Data
    lst_bill_adrc TYPE ty_bill_adrc,                  " Struc: Billing Address
    lst_constant  TYPE ty_constant,                   " Struc: Constant
    lr_parvw      TYPE RANGE OF parvw,                " Ranges: Partner function
    lst_parvw     LIKE LINE OF lr_parvw,              " Struc:
    lst_identcode TYPE ty_identcode,                  " Struc:
    li_identcode  TYPE STANDARD TABLE OF ty_identcode, " Itab:
    li_vbap_tmp   TYPE STANDARD TABLE OF ty_vbap,      " Item Details
    li_makt       TYPE STANDARD TABLE OF ty_makt,      " Itab:
    lst_makt      TYPE ty_makt,                        " Struc:
    lv_idcodetype TYPE ismidcodetype,                  " Identification code
    lv_hdr_text   TYPE text50,                         " Form Header Text
    lst_vbpa      TYPE ty_vbpa,                        " Struc: VBPA
    li_lines      TYPE STANDARD TABLE OF tline, " Lines of text read
    lst_lines     TYPE tline.                   " SAPscript: Text Lines

  " Local Constants
  CONSTANTS:
    lc_sign       TYPE char1 VALUE 'I',                             " Sign
    lc_option     TYPE char2 VALUE 'EQ',                            " Option
    lc_id_code_p1 TYPE rvari_vnam     VALUE 'ID_CODE',              " Parameter-1
    lc_idcodetype TYPE ismidcodetype  VALUE 'ZEAN',                 " Identification code
    lc_st         TYPE thead-tdid     VALUE 'ST',                   " Text ID of text to be read
    lc_object     TYPE thead-tdobject VALUE 'TEXT',                 " Object of text to be read
    lc_dear_txt   TYPE thead-tdname   VALUE 'ZQTC_DEAR_TEXT_F059'.  " Text: Dear

  " Order Confirmation Number
  IF fp_nast-objky+10 NE space.
    fp_nast-objky = fp_nast-objky+16(10).
  ELSE.
    fp_nast-objky = fp_nast-objky.
  ENDIF.

  lst_header-order_number = fp_nast-objky.  " Sales Document Number
  lst_header-lang = fp_nast-spras.          " Language Key

  " FM call to read text: Dear
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = lst_header-lang
      name                    = lc_dear_txt
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
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    LOOP AT li_lines INTO lst_lines.
      lv_hdr_text = lst_lines-tdline.
    ENDLOOP. " LOOP AT li_lines INTO lst_lines
    CLEAR li_lines[].
  ENDIF.

  " Fetch Customer Name
  lst_parvw-sign = lc_sign.
  lst_parvw-option = lc_option.
  lst_parvw-low = c_ag.   " Sold-to-party
  APPEND lst_parvw TO lr_parvw.
  CLEAR lst_parvw.

  lst_parvw-sign = lc_sign.
  lst_parvw-option = lc_option.
  lst_parvw-low = c_re.   " Bill-to-party
  APPEND lst_parvw TO lr_parvw.
  CLEAR lst_parvw.

  " Fetch Partner Functions Sold-to, Ship-to
  SELECT parvw, kunnr, adrnr FROM vbpa INTO TABLE @i_vbpa
                             WHERE vbeln = @lst_header-order_number AND
                                   posnr = @c_hdr_posnr AND
                                   parvw IN @lr_parvw.
  IF sy-subrc = 0.
    " Fetch Customer Number, and Name 1
    READ TABLE i_vbpa INTO lst_vbpa WITH KEY parvw = c_ag. " BINARY SEARCH is not required as we have very less entries
    IF sy-subrc = 0.
      SELECT SINGLE kunnr name1 FROM kna1 INTO ( lv_kunnr, lv_name1 )
                                WHERE kunnr = lst_vbpa-kunnr.
      IF sy-subrc = 0.
        lst_header-customer_name = lv_name1.
        lst_header-account_number = lv_kunnr.
        " Build Header Text (Dear <Customer Name>)
        CONCATENATE: lv_hdr_text lst_header-customer_name INTO lv_hdr_text SEPARATED BY space,
                     lv_hdr_text c_comma INTO lst_header-hdr_text.
        CLEAR: lst_vbpa,
               lv_kunnr,
               lv_name1,
               lr_parvw[],
               lv_hdr_text.
      ENDIF.
    ENDIF. " IF sy-subrc = 0.
  ENDIF. " IF sy-subrc = 0 of SELECT

  " Fetch Purchase Order Number, and Order Date
  SELECT SINGLE erdat waerk bstnk FROM vbak INTO ( lv_ord_date, lv_doc_curr, lv_po )
                                  WHERE vbeln = lst_header-order_number.
  IF sy-subrc = 0.
    lst_header-po_number = lv_po.
    lst_header-order_date = lv_ord_date.
    lst_header-currency = lv_doc_curr.
    CLEAR: lv_po,
           lv_ord_date,
           lv_doc_curr.
  ENDIF.

  " Fetching Billing Address
  READ TABLE i_vbpa INTO lst_vbpa WITH KEY parvw = c_re. " BINARY SEARCH is not required as we have very less entries
  IF sy-subrc = 0.
    SELECT SINGLE name1, stras, ort01, pstlz, land1
           FROM kna1 INTO @lst_bill_adrc
           WHERE kunnr = @lst_vbpa-kunnr.
    IF sy-subrc = 0.
      IF lst_bill_adrc-name1 IS NOT INITIAL.
        lv_tdline = lst_bill_adrc-name1.
        APPEND lv_tdline TO fp_st_wol_ord_inf-billing_addr.
        CLEAR lv_tdline.
      ENDIF.
      IF lst_bill_adrc-stras IS NOT INITIAL.
        lv_tdline = lst_bill_adrc-stras.
        APPEND lv_tdline TO fp_st_wol_ord_inf-billing_addr.
        CLEAR lv_tdline.
      ENDIF.
      IF lst_bill_adrc-ort01 IS NOT INITIAL.
        lv_tdline = lst_bill_adrc-ort01.
        APPEND lv_tdline TO fp_st_wol_ord_inf-billing_addr.
        CLEAR lv_tdline.
      ENDIF.
      IF lst_bill_adrc-pstlz IS NOT INITIAL.
        lv_tdline = lst_bill_adrc-pstlz.
        APPEND lv_tdline TO fp_st_wol_ord_inf-billing_addr.
        CLEAR lv_tdline.
      ENDIF.
      IF lst_bill_adrc-land1 IS NOT INITIAL.
        " Fetching Country Name
        SELECT SINGLE landx FROM t005t INTO @DATA(lv_country)
               WHERE spras = @fp_nast-spras AND
                     land1 = @lst_bill_adrc-land1.
        IF sy-subrc = 0.
          lv_tdline = lv_country.
          APPEND lv_tdline TO fp_st_wol_ord_inf-billing_addr.
          CLEAR: lv_tdline,
                 lv_country.
        ENDIF. " IF sy-subrc = 0.
      ENDIF. " IF lst_bill_adrc-land1 IS NOT INITIAL.

    ENDIF. " IF sy-subrc = 0 of SELECT

    CLEAR: lst_vbpa,
           lst_bill_adrc.
  ENDIF. " IF sy-subrc = 0 of READ TABLE i_vbpa

  " Fetch Sales document Item details
  SELECT vbeln, posnr, matnr, zmeng, netwr, kzwi5, kzwi6
         FROM vbap INTO TABLE @i_item_data
         WHERE vbeln = @lst_header-order_number.
  IF sy-subrc = 0 AND
     i_item_data[] IS NOT INITIAL.

    li_vbap_tmp[] = i_item_data[].
    SORT li_vbap_tmp BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_vbap_tmp
           COMPARING matnr.

    " Fetch Identification Code (ISBN Number) for all the Materials
    READ TABLE i_constants INTO lst_constant WITH KEY devid = c_devid_f059
                                                     param1 = lc_id_code_p1. " BINARY SEARCH is not required as i_constants has very less records
    IF sy-subrc = 0.
      lv_idcodetype = lst_constant-low.
      CLEAR lst_constant.
    ELSE.
      lv_idcodetype = lc_idcodetype.
    ENDIF.
    SELECT matnr, identcode FROM jptidcdassign INTO TABLE @li_identcode
                            FOR ALL ENTRIES IN @li_vbap_tmp
                            WHERE matnr = @li_vbap_tmp-matnr AND
                                  idcodetype = @lv_idcodetype.
    IF sy-subrc = 0.
      " Nothing to do
    ENDIF.

    " Fetch Material Description
    SELECT matnr, ismtitle FROM mara INTO TABLE @li_makt
                           FOR ALL ENTRIES IN @li_vbap_tmp
                           WHERE matnr = @li_vbap_tmp-matnr.
    IF sy-subrc = 0.
      " Nothing to do
    ENDIF.

    " Iterate the Sales document item data to populate the final item data
    LOOP AT i_item_data ASSIGNING FIELD-SYMBOL(<lf_item_data>).

      " ISBN Number
      READ TABLE li_identcode INTO lst_identcode WITH KEY matnr = <lf_item_data>-matnr.
      " BINARY SEARCH is not required as we have very less records
      IF sy-subrc = 0.
        lst_item_data-isbn_number = lst_identcode-identcode.
      ENDIF. " IF sy-subrc = 0.

      " Title Description
      READ TABLE li_makt INTO lst_makt WITH KEY matnr = <lf_item_data>-matnr.
      " BINARY SEARCH is not required as we have very less records
      IF sy-subrc = 0.
        lst_item_data-title_desc = lst_makt-ismtitle.
      ENDIF. " IF sy-subrc = 0.

      " Quantity
      lst_item_data-quantity = <lf_item_data>-zmeng.

      " Price
      lst_item_data-price = <lf_item_data>-netwr.

      " Subtotal
      lst_item_data-sub_total = <lf_item_data>-netwr.
      lst_header-sub_total = lst_header-sub_total + <lf_item_data>-netwr.

      " Tax
      lst_item_data-tax = <lf_item_data>-kzwi6.
      lst_header-tax = lst_header-tax + <lf_item_data>-kzwi6.

      " Total
      lst_item_data-total_due = <lf_item_data>-netwr + <lf_item_data>-kzwi6.
      lst_header-total_due = lst_header-total_due + <lf_item_data>-netwr + <lf_item_data>-kzwi6.

*      COLLECT lst_item_data INTO li_item_data.
      APPEND lst_item_data TO li_item_data.

      CLEAR: lst_identcode,
             lst_makt,
             lst_item_data.
    ENDLOOP.

    " Populate the WOL Order Interface structure
    fp_st_wol_ord_inf-header = lst_header.
    fp_st_wol_ord_inf-items = li_item_data.
    CLEAR: lst_header,
           li_item_data[],
           li_vbap_tmp[].


  ENDIF. " IF sy-subrc = 0 AND i_item_data[] IS NOT INITIAL.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROTOCOL_UPDATE
*&---------------------------------------------------------------------*
FORM f_protocol_update.

*  CHECK v_ent_screen = space.
  CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
    EXPORTING
      msg_arbgb              = syst-msgid
      msg_nr                 = syst-msgno
      msg_ty                 = syst-msgty
      msg_v1                 = syst-msgv1
      msg_v2                 = syst-msgv2
      msg_v3                 = syst-msgv3
      msg_v4                 = syst-msgv4
    EXCEPTIONS
      message_type_not_valid = 1
      no_sy_message          = 2
      OTHERS                 = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      --> FP_V_FORMNAME  text
*----------------------------------------------------------------------*
FORM f_populate_layout  USING fp_v_formname.

* Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,                      " String value
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        st_formoutput       TYPE fpformoutput,                " Formoutput
        lv_upd_tsk          TYPE i.                           " Update Task
*--------------------------------------------------------------------*

  lst_sfpoutputparams-nopributt = abap_true.
  lst_sfpoutputparams-noarchive = abap_true.
  IF v_ent_screen     = c_x.
    lst_sfpoutputparams-getpdf  = abap_false.
    lst_sfpoutputparams-preview = abap_true.
  ELSEIF v_ent_screen = c_w. " Web dynpro
    lst_sfpoutputparams-getpdf  = abap_true.
    lst_sfpoutputparams-preview = abap_false.
  ELSEIF v_ent_screen = abap_false.
    lst_sfpoutputparams-preview = abap_false.
    lst_sfpoutputparams-getpdf  = abap_true.
  ENDIF. " IF v_ent_screen = 'X'

  lst_sfpoutputparams-nodialog  = abap_true.
  lst_sfpoutputparams-dest      = nast-ldest.
  lst_sfpoutputparams-copies    = nast-anzal.
  lst_sfpoutputparams-dataset   = nast-dsnam.
  lst_sfpoutputparams-suffix1   = nast-dsuf1.
  lst_sfpoutputparams-suffix2   = nast-dsuf2.
  lst_sfpoutputparams-cover     = nast-tdocover.
  lst_sfpoutputparams-covtitle  = nast-tdcovtitle.
  lst_sfpoutputparams-authority = nast-tdautority.
  lst_sfpoutputparams-receiver  = nast-tdreceiver.
  lst_sfpoutputparams-division  = nast-tddivision.
  lst_sfpoutputparams-arcmode   = nast-tdarmod.
  lst_sfpoutputparams-reqimm    = nast-dimme.
  lst_sfpoutputparams-reqdel    = nast-delet.
  lst_sfpoutputparams-senddate  = nast-vsdat.
  lst_sfpoutputparams-sendtime  = nast-vsura.

  " Set language and default language
  lst_sfpdocparams-langu = nast-spras.

  " To Archive the document
  APPEND toa_dara TO lst_sfpdocparams-daratab.

  IF v_ent_retco = 0.
    " FM Call to create a job
    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = lst_sfpoutputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
      v_ent_retco = sy-subrc.
      " FM Call: Processing program protocol, protocol of a step
      CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
        EXPORTING
          msg_arbgb              = sy-msgid
          msg_nr                 = sy-msgno
          msg_ty                 = sy-msgty
          msg_v1                 = sy-msgv1
          msg_v2                 = sy-msgv2
          msg_v3                 = sy-msgv3
          msg_v4                 = sy-msgv4
        EXCEPTIONS
          message_type_not_valid = 1
          no_sy_message          = 2
          OTHERS                 = 3.
      IF sy-subrc NE 0.
        " Nothing to do
      ENDIF. " IF sy-subrc NE 0

    ELSE. " ELSE -> IF sy-subrc <> 0
      TRY.
          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name               = fp_v_formname
            IMPORTING
              e_funcname           = lv_funcname
            EXCEPTIONS
              cx_fp_api_repository = 1
              cx_fp_api_usage      = 2
              cx_fp_api_internal   = 3
              OTHERS               = 4.

        CATCH cx_fp_api_usage INTO lr_err_usg ##NO_HANDLER.
          lr_text = lr_err_usg->get_text( ).
          LEAVE LIST-PROCESSING.
        CATCH cx_fp_api_repository INTO lr_err_rep ##NO_HANDLER.
          lr_text = lr_err_rep->get_text( ).
          LEAVE LIST-PROCESSING.
        CATCH cx_fp_api_internal INTO lr_err_int ##NO_HANDLER.
          lr_text = lr_err_int->get_text( ).
          LEAVE LIST-PROCESSING.
      ENDTRY.

      " Call function module to generate WOL Order Confirmation details
      CALL FUNCTION lv_funcname
        EXPORTING
          /1bcdwb/docparams  = lst_sfpdocparams
          im_header_item     = st_wol_ord_inf
          im_xstring         = v_xstr_logo
        IMPORTING
          /1bcdwb/formoutput = st_formoutput
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
        " FM Call to update the log
        CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
          EXPORTING
            msg_arbgb              = sy-msgid
            msg_nr                 = sy-msgno
            msg_ty                 = sy-msgty
            msg_v1                 = sy-msgv1
            msg_v2                 = sy-msgv2
            msg_v3                 = sy-msgv3
            msg_v4                 = sy-msgv4
          EXCEPTIONS
            message_type_not_valid = 1
            no_sy_message          = 2
            OTHERS                 = 3.
        IF sy-subrc NE 0.
*         Nothing to do
        ENDIF. " IF sy-subrc NE 0
        v_ent_retco = 900.
        RETURN.
      ELSE. " ELSE -> IF sy-subrc <> 0

        PERFORM f_protocol_update. " update Sucess log
        " FM Call to close the job
        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.

          CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
            EXPORTING
              msg_arbgb              = sy-msgid
              msg_nr                 = sy-msgno
              msg_ty                 = sy-msgty
              msg_v1                 = sy-msgv1
              msg_v2                 = sy-msgv2
              msg_v3                 = sy-msgv3
              msg_v4                 = sy-msgv4
            EXCEPTIONS
              message_type_not_valid = 1
              no_sy_message          = 2
              OTHERS                 = 3.
          IF sy-subrc NE 0.
*           Nothing to do
          ENDIF. " IF sy-subrc NE 0
        ELSE.
*        PERFORM f_protocol_update. "update log
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF.
  ENDIF.
*- For Archiving
  IF lst_sfpoutputparams-arcmode <> c_1 AND  v_ent_screen IS INITIAL.
    " FM Call: to Storage of outgoing documents without SAP Spool
    CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
      EXPORTING
        documentclass            = c_pdf
        document                 = st_formoutput-pdf
      TABLES
        arc_i_tab                = lst_sfpdocparams-daratab
      EXCEPTIONS
        error_archiv             = 1
        error_communicationtable = 2
        error_connectiontable    = 3
        error_kernel             = 4
        error_parameter          = 5
        error_format             = 6
        OTHERS                   = 7.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE c_e NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              RAISING system_error.
    ELSE. " ELSE -> IF sy-subrc <> 0
*           Check if the subroutine is called in update task.
      CALL METHOD cl_system_transaction_state=>get_in_update_task
        RECEIVING
          in_update_task = lv_upd_tsk.
      IF lv_upd_tsk EQ 0.
        COMMIT WORK.
      ENDIF. " IF lv_upd_tsk EQ 0
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF fp_v_returncode = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADOBE_PRNT_SND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--FP_V_RETURNCODE  text
*----------------------------------------------------------------------*
FORM f_adobe_prnt_snd_mail  CHANGING fp_v_returncode.

  " Local Data
  DATA: lv_form          TYPE tdsfname,          " Smart Forms: Form Name
        lv_fm_name       TYPE funcname,          " Name of Function Module
        lv_upd_tsk       TYPE i,                 " Upd_tsk of type Integers
        lst_outputparams TYPE sfpoutputparams,   " Form Processing Output Parameter
        lst_sfpdocparams TYPE sfpdocparams,      " Form Parameters for Form Processing
        lst_vbpa         TYPE ty_vbpa.           " Struc: Partner Functions

*--------------------------------------------------------------------*

  " Fetch E-Mail Address of the Customer ( Sold-to-party )
  READ TABLE i_vbpa INTO lst_vbpa WITH KEY parvw = c_ag.
  " BINARY SEARCH is not required as we have very less records
  IF sy-subrc EQ 0.
    SELECT smtp_addr UP TO 1 ROWS " E-Mail Address
           FROM adr6              " E-Mail Addresses (Business Address Services)
           INTO v_send_email
           WHERE addrnumber EQ lst_vbpa-adrnr.
    ENDSELECT.
    IF sy-subrc NE 0 AND v_send_email IS INITIAL.
      SELECT SINGLE prsnr      " Person number
             FROM knvk         " Customer Master Contact Partner
             INTO v_persn_adrnr
             WHERE kunnr EQ lst_vbpa-kunnr AND
                   pafkt = c_z1.
      IF sy-subrc EQ 0.
        SELECT SINGLE smtp_addr " E-Mail Address
               FROM adr6        " E-Mail Addresses (Business Address Services)
               INTO v_send_email
               WHERE persnumber EQ v_persn_adrnr.
        IF sy-subrc NE 0 AND v_send_email IS INITIAL.
          syst-msgid = c_zqtc_r2.
          syst-msgno = c_msg_no.
          syst-msgty = c_e.
          syst-msgv1 = 'Email ID is not maintained for Sold-to Customer'(018).
          CLEAR: syst-msgv2,
                 syst-msgv3,
                 syst-msgv4.
          PERFORM f_protocol_update.
          v_ent_retco = 4.
        ENDIF.
      ELSE.
        syst-msgid = c_zqtc_r2.
        syst-msgno = c_msg_no.
        syst-msgty = c_e.
        syst-msgv1 = 'Email ID is not maintained for Sold-to Customer'(018).
        CLEAR: syst-msgv2,
               syst-msgv3,
               syst-msgv4.
        PERFORM f_protocol_update.
        v_ent_retco = 4.
      ENDIF.
    ENDIF.
    CLEAR lst_vbpa.
  ELSE.
    syst-msgid = c_zqtc_r2.
    syst-msgno = c_msg_no.
    syst-msgty = c_e.
    syst-msgv1 = 'BP partner function is not maintained'(017).
    CLEAR: syst-msgv2,
           syst-msgv3,
           syst-msgv4.
    PERFORM f_protocol_update.
    v_ent_retco = 4.
  ENDIF.

  " Check for E-Mail Address availability
  IF v_send_email IS NOT INITIAL.

    IF v_ent_retco = 0.
      lv_form = tnapr-sform.
      lst_outputparams-getpdf = abap_true.
      lst_outputparams-preview = abap_false.
    ENDIF. " IF fp_v_returncode = 0

    " Set output parameters
    lst_outputparams-nopributt = abap_true. " no print buttons in the preview
    lst_outputparams-noarchive = abap_true. " no archiving in the preview
    lst_outputparams-nodialog  = abap_true. " suppress printer dialog popup
    lst_outputparams-dest      = nast-ldest.
    lst_outputparams-copies    = nast-anzal.
    lst_outputparams-dataset   = nast-dsnam.
    lst_outputparams-suffix1   = nast-dsuf1.
    lst_outputparams-suffix2   = nast-dsuf2.
    lst_outputparams-cover     = nast-tdocover.
    lst_outputparams-covtitle  = nast-tdcovtitle.
    lst_outputparams-authority = nast-tdautority.
    lst_outputparams-receiver  = nast-tdreceiver.
    lst_outputparams-division  = nast-tddivision.
    lst_outputparams-arcmode   = nast-tdarmod.
    lst_outputparams-reqimm    = nast-dimme.
    lst_outputparams-reqdel    = nast-delet.
    lst_outputparams-senddate  = nast-vsdat.
    lst_outputparams-sendtime  = nast-vsura.

    " To Archive the document
    APPEND toa_dara TO lst_sfpdocparams-daratab.

    " Open the spool job
    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = lst_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
      v_ent_retco = sy-subrc.
      PERFORM f_protocol_update.
    ENDIF. " IF sy-subrc <> 0

    " Get the name of the generated function module
    IF v_ent_retco = 0.
      TRY.
          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = lv_form
            IMPORTING
              e_funcname = lv_fm_name.

        CATCH cx_fp_api_repository
              cx_fp_api_usage
              cx_fp_api_internal ##NO_HANDLER.
          v_ent_retco = sy-subrc.
          PERFORM f_protocol_update.
      ENDTRY.
    ENDIF.

    IF v_ent_retco = 0.
      " Call the generated function module
      CALL FUNCTION lv_fm_name
        EXPORTING
          /1bcdwb/docparams  = lst_sfpdocparams
          im_header_item     = st_wol_ord_inf
          im_xstring         = v_xstr_logo
        IMPORTING
          /1bcdwb/formoutput = st_formoutput
        EXCEPTIONS
          usage_error        = 1
          system_error       = 2
          internal_error     = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
        v_ent_retco = sy-subrc .
        PERFORM f_protocol_update.
      ELSE.
        v_ent_retco = sy-subrc.
        PERFORM f_protocol_update.  " Update processing log when success
      ENDIF. " IF sy-subrc <> 0
    ENDIF.

    " Close the spool job
    CALL FUNCTION 'FP_JOB_CLOSE'
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
      v_ent_retco = sy-subrc .
      PERFORM f_protocol_update.
    ENDIF. " IF sy-subrc <> 0

    IF lst_outputparams-arcmode <> c_1 AND v_ent_screen IS INITIAL.
      " FM Call: to Storage of outgoing documents without SAP Spool
      CALL FUNCTION 'ARCHIV_CREATE_OUTGOINGDOC_MULT'
        EXPORTING
          documentclass            = c_pdf
          document                 = st_formoutput-pdf
        TABLES
          arc_i_tab                = lst_sfpdocparams-daratab
        EXCEPTIONS
          error_archiv             = 1
          error_communicationtable = 2
          error_connectiontable    = 3
          error_kernel             = 4
          error_parameter          = 5
          error_format             = 6
          OTHERS                   = 7.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE c_e NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
                RAISING system_error.
      ELSE. " ELSE -> IF sy-subrc <> 0
        " Check if the subroutine is called in update task.
        CALL METHOD cl_system_transaction_state=>get_in_update_task
          RECEIVING
            in_update_task = lv_upd_tsk.
        IF lv_upd_tsk EQ 0.
          COMMIT WORK.
        ENDIF. " IF lv_upd_tsk EQ 0
      ENDIF. " IF sy-subrc <> 0
    ENDIF. " IF fp_v_returncode = 0

  ENDIF. " IF v_send_email IS NOT INITIAL.

  IF v_ent_retco = 0.
    " CONVERT_PDF_BINARY
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = st_formoutput-pdf
      TABLES
        binary_tab = i_content_hex.
    IF v_send_email IS NOT INITIAL.
      " Perform to create mail attachment with a creation of mail body
      PERFORM f_mail_attachment
              CHANGING v_ent_retco.
    ENDIF.
  ENDIF. " IF v_ent_retco = 0.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MAIL_ATTACHMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--FP_V_RETURNCODE  text
*----------------------------------------------------------------------*
FORM f_mail_attachment  CHANGING fp_v_returncode ##NEEDED.

* Local Constant Declaration
  CONSTANTS:
    lc_raw        TYPE so_obj_tp      VALUE 'RAW',                          " Code for document class
    lc_pdf        TYPE so_obj_tp      VALUE 'PDF',                          " Document Class for Attachment
    lc_s          TYPE bapi_mtype     VALUE 'S',                            " Message type: S Success, E Error, W Warning, I Info, A Abort
    lc_st         TYPE thead-tdid     VALUE 'ST',                           " Text ID of text to be read
    lc_object     TYPE thead-tdobject VALUE 'TEXT',                         " Object of text to be read
    lc_email_subj TYPE thead-tdname   VALUE 'ZQTC_EMAIL_BODY_SUBJECT_F059', " E-Mail Subject
    lc_email_body TYPE thead-tdname   VALUE 'ZQTC_EMAIL_BODY_CONTENT_F059', " E-Mail Body Content
    lc_atta_title TYPE thead-tdname   VALUE 'ZQTC_ATTACHMENT_TITLE_F059'.   " Attachment Title

* Local Data Declaration
  DATA: lr_sender       TYPE REF TO if_sender_bcs VALUE IS INITIAL, " Interface of Sender Object in BCS
        lr_send_request TYPE REF TO cl_bcs VALUE IS INITIAL,          " Business Communication Service
        lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL, " BCS: Document Exceptions
        lv_doc_title    TYPE so_obj_des,                              " Short description of contents
        li_lines        TYPE STANDARD TABLE OF tline, " Lines of text read
        lst_lines       TYPE tline.                   " SAPscript: Text Lines

* Message body and subject
  DATA: li_message_body  TYPE STANDARD TABLE OF soli INITIAL SIZE 0,    " SAPoffice: line, length 255
        lst_message_body TYPE soli,                                     " SAPoffice: line, length 255
        lr_document      TYPE REF TO cl_document_bcs VALUE IS INITIAL,  " Wrapper Class for Office Documents
        lv_sent_to_all   TYPE char1 VALUE IS INITIAL,                   " Sent_to_all(1) of type Character
        lr_recipient     TYPE REF TO if_recipient_bcs VALUE IS INITIAL, " Interface of Recipient Object in BCS
        lv_upd_tsk       TYPE i,                                        " Upd_tsk of type Integers
        lv_sub           TYPE string.

*--------------------------------------------------------------------*

  " Load Business Communication Service definition
*  CLASS cl_bcs DEFINITION LOAD.

  TRY.
      lr_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs ##NO_HANDLER.
  ENDTRY.

  " FM call: Read text to read Attachment title
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = st_wol_ord_inf-header-lang
      name                    = lc_atta_title
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
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    LOOP AT li_lines INTO lst_lines.
      lv_doc_title = lst_lines-tdline.
      REPLACE ALL OCCURRENCES OF '&DOC_NUM&' IN lv_doc_title WITH st_wol_ord_inf-header-order_number.
    ENDLOOP. " LOOP AT li_lines INTO lst_lines
    CLEAR li_lines[].
  ENDIF.

  " FM call: Read text to read E-Mail Subject
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = st_wol_ord_inf-header-lang
      name                    = lc_email_subj
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
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    LOOP AT li_lines INTO lst_lines.
      lv_sub = lst_lines-tdline.
      REPLACE ALL OCCURRENCES OF '&DOC_NUM&' IN lv_sub WITH st_wol_ord_inf-header-order_number.
    ENDLOOP. " LOOP AT li_lines INTO lst_lines
    CLEAR li_lines[].
  ENDIF.

  " FM call: Read text to read E-Mail body content
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = lc_st
      language                = st_wol_ord_inf-header-lang
      name                    = lc_email_body
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
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
    LOOP AT li_lines INTO lst_lines.
      lst_message_body-line = lst_lines-tdline.
      REPLACE ALL OCCURRENCES OF '&CUSTOMER_NAME&' IN lst_message_body-line WITH st_wol_ord_inf-header-customer_name.
      APPEND lst_message_body-line TO li_message_body.
    ENDLOOP. " LOOP AT li_lines INTO lst_lines
    CLEAR li_lines[].
  ENDIF. " IF sy-subrc EQ 0

  TRY.
      lr_document = cl_document_bcs=>create_document(
        i_type = lc_raw
        i_text = li_message_body
        i_subject = lv_doc_title ).
    CATCH cx_document_bcs ##NO_HANDLER.
    CATCH cx_send_req_bcs ##NO_HANDLER.
  ENDTRY.

  " Send email with the attachments we are getting from FM
  TRY.
      lr_document->add_attachment(
         EXPORTING
           i_attachment_type = lc_pdf "'PDF'
           i_attachment_subject = lv_doc_title " WOL Order Confirmation: 123456789
           i_att_content_hex = i_content_hex
      ).
    CATCH cx_document_bcs INTO lx_document_bcs ##NO_HANDLER.
  ENDTRY.

  TRY.
      CALL METHOD lr_send_request->set_message_subject
        EXPORTING
          ip_subject = lv_sub.
    CATCH cx_send_req_bcs.
  ENDTRY.

  " Add attachment
  TRY.
      CALL METHOD lr_send_request->set_document( lr_document ).
    CATCH cx_send_req_bcs ##NO_HANDLER.
  ENDTRY.

  IF v_send_email IS NOT INITIAL.
    " Pass the document to send request
    TRY.
        lr_send_request->set_document( lr_document ).
        " Create sender
        lr_sender = cl_sapuser_bcs=>create( sy-uname ).
        " Set sender
        lr_send_request->set_sender(
          EXPORTING
            i_sender = lr_sender ).
      CATCH cx_address_bcs ##NO_HANDLER.
      CATCH cx_send_req_bcs ##NO_HANDLER.
    ENDTRY.
    " Create recipient
    TRY.
        lr_recipient = cl_cam_address_bcs=>create_internet_address( v_send_email ).
        " Set recipient
        lr_send_request->add_recipient(
          EXPORTING
            i_recipient = lr_recipient
            i_express = abap_true ).
      CATCH cx_address_bcs ##NO_HANDLER.
      CATCH cx_send_req_bcs ##NO_HANDLER.
    ENDTRY.
    " Send email
    TRY.
        lr_send_request->send(
          EXPORTING
            i_with_error_screen = abap_true
          RECEIVING
            result = lv_sent_to_all ).
      CATCH cx_send_req_bcs ##NO_HANDLER.
    ENDTRY.
    " Check if the subroutine is called in update task.
    CALL METHOD cl_system_transaction_state=>get_in_update_task
      RECEIVING
        in_update_task = lv_upd_tsk.
    " COMMINT only if the subroutine is not called in update task
    IF lv_upd_tsk EQ 0.
      COMMIT WORK.
      MESSAGE 'Email sent successfully'(002) TYPE lc_s. " Email sent successfully
    ENDIF. " IF lv_upd_tsk EQ 0

    IF lv_sent_to_all = abap_true.
      MESSAGE 'Email sent successfully'(002) TYPE lc_s. " Email sent successfully
    ENDIF. " IF lv_sent_to_all = abap_true
  ENDIF. " IF v_send_email IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CLEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_get_clear.

  CLEAR: st_wol_ord_inf,     " Interface structure
         st_formoutput,      " Form Output (PDF, PDL)
         v_xstr_logo,        " Logo Variable
         v_formname,         " Formname
         v_ent_retco,        " ABAP System Field: Return Code of ABAP Statements
         v_send_email,       " E-Mail Address
         v_persn_adrnr,      " Personal Number
         i_constants[],      " Itab: Constant entries
         i_vbpa[],           " Itab: Sales Document Item details
         i_item_data[],      " Item Details
         i_content_hex[].    " Content table

ENDFORM.
