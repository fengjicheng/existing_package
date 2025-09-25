*&---------------------------------------------------------------------*
*& Report ZCA_QR_DIGITALSIGNATURE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zca_qr_digitalsignature.

DATA :
  lv_fname        TYPE rs38l_fnam,
  lv_formname     TYPE tdsfname VALUE 'ZCA_QRCODE_DIGITAL',
  ls_fpformout    TYPE fpformoutput,
*  lo_fp           TYPE REF TO if_fp,
*  lo_pdfobj       TYPE REF TO if_fp_pdf_object,
  lv_len          TYPE i,
  lt_tab          TYPE TABLE OF solix,
  lv_file_name    TYPE string,
  lv_timestamps   TYPE string,
  lv_qrcode       TYPE char300,
  iv_barcode_text TYPE string VALUE 'Test QR Data',
  lv_message      TYPE string.

INITIALIZATION.


START-OF-SELECTION.
* lv_qrcode = 'https://www.adobe.com/express/feature/image/qr-code-generator'.

  lv_qrcode = 'https://digitalpayments-paymentbylink.test-digitalpayments-sap.cfapps.us10.hana.ondemand.com/index.html#pr=HO2BBQTYOWFBLKCBIZNZLMFRK4&vc=53ACUPI5UA4NS'.
 CONDENSE lv_qrcode.
  DATA(l_control) = VALUE ssfctrlop( no_dialog = 'X' preview = 'X' no_open = '' no_close = '' device = 'LP01' ).

*DATA(ls_outputparams) = VALUE sfpoutputparams( getpdf = 'X' dest = 'LP01' ).
  DATA(ls_outputparams) = VALUE sfpoutputparams( device = 'PRINTER'
                                                 nodialog = 'X'
                                                 preview  = 'X'
                                                 noprint  = 'X'
                                                 getpdf   = ''
                                                 dest     = 'LP01' ).

  DATA(ls_docparams) = VALUE sfpdocparams( langu = 'E'
                                           fillable = 'X' ).

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = ls_outputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = lv_formname
    IMPORTING
      e_funcname = lv_fname.


  CALL FUNCTION lv_fname
    EXPORTING
      /1bcdwb/docparams  = ls_docparams
      iv_qrcode          = lv_qrcode
    IMPORTING
      /1bcdwb/formoutput = ls_fpformout
    EXCEPTIONS
      usage_error        = 1
      system_error       = 2
      internal_error     = 3
      OTHERS             = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here

    CALL FUNCTION 'FORMAT_MESSAGE'
      EXPORTING
        id   = sy-msgid
        lang = sy-langu
        no   = sy-msgno
        v1   = sy-msgv1
      IMPORTING
        msg  = lv_message.

    MESSAGE lv_message TYPE 'I' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.

*  lo_fp = cl_fp=>get_reference( ).
*
*  lo_pdfobj = lo_fp->create_pdf_object( connection = CONV #('ADS') ).
*
*  CALL METHOD lo_pdfobj->set_document
*    EXPORTING
*      pdfdata = ls_fpformout-pdf.
*
*  CALL METHOD lo_pdfobj->set_template
*    EXPORTING
*      xftdata  = ls_fpformout-pdf
*      fillable = 'X'.
*
*  CALL METHOD lo_pdfobj->set_signature
*    EXPORTING
*      keyname     = 'STTGlobal' "'ReaderRights' "Signature name from solution manager
*      fieldname   = 'SignatureField1'
*      reason      = 'TEST'
*      location    = 'Mumbai'
*      contactinfo = 'Rajesh'.
*  TRY.
*
*      CALL METHOD lo_pdfobj->execute( ).
*
*    CATCH cx_fp_runtime_internal INTO DATA(lc_interanl).
*      MESSAGE lc_interanl->get_longtext( ) TYPE 'I'.
*    CATCH cx_fp_runtime_system INTO DATA(lc_runtime).
*      MESSAGE lc_runtime->get_longtext( ) TYPE 'I'.
*    CATCH cx_fp_runtime_usage INTO DATA(lc_usage).
*      MESSAGE lc_usage->get_longtext( ) TYPE 'I'.
*
*  ENDTRY.
*
**   get result -> l_out
*  CALL METHOD lo_pdfobj->get_document
*    IMPORTING
*      pdfdata = DATA(lv_out).
*
*  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
*    EXPORTING
*      buffer        = lv_out
**     buffer        = l_pdf
*    IMPORTING
*      output_length = lv_len
*    TABLES
*      binary_tab    = lt_tab.
*
*  GET TIME STAMP FIELD DATA(lv_timestamp).
*  lv_timestamps = lv_timestamp.
*  CONCATENATE 'C:\temp\' lv_timestamps '.pdf' INTO lv_file_name.
*
*  CALL METHOD cl_gui_frontend_services=>gui_download
*    EXPORTING
*      bin_filesize = lv_len "bitmap2_size "l_len
*      filename     = lv_file_name
*      filetype     = 'BIN'
*    CHANGING
*      data_tab     = lt_tab
*    EXCEPTIONS
*      OTHERS       = 1.
