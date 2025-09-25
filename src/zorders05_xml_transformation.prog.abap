*&---------------------------------------------------------------------*
*& Report  ZTIBCO_BP_XML_TRANSFORMATION
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zorders05_xml_transformation.

DATA: lr_xml_doc     TYPE REF TO cl_xml_document,
      lv_retcode     TYPE sy-subrc,
      lv_xml_string  TYPE string,
      lv_xml_xstring TYPE xstring,
      lv_size        TYPE sytabix,
      lt_xml_data    TYPE TABLE OF smum_xmltb,
      lt_return      TYPE TABLE OF bapiret2,
      lv_ex_vbeln    TYPE vbeln_va,
      lt_ex_message  TYPE bapiretct,
      ls_im_data     TYPE zstqtc_idoc_orders05,
      ls_edidc       TYPE edidc.

DATA: lr_transformation_error    TYPE REF TO cx_transformation_error,
      lr_conversion_no_date_time TYPE REF TO cx_sy_conversion_no_date_time,
      lr_root                    TYPE REF TO cx_root,
      lv_err_text                TYPE string,
      lv_err_source_line         TYPE i,
      lv_err_program_name        TYPE syrepid,
      lv_err_include_name        TYPE syrepid,
      lv_off                     TYPE i,
      lv_len                     TYPE i.

PARAMETERS: p_file  TYPE rlgrap-filename,
            p_immed TYPE char1 DEFAULT 'X'.
SELECTION-SCREEN SKIP 1.
PARAMETERS: p_direct TYPE edi_direct DEFAULT '2',                 " Direction for IDoc
            p_rcvpor TYPE edi_rcvpor DEFAULT 'SAPEQ2',            " Receiver port
            p_rcvprt TYPE edi_rcvprt DEFAULT 'LS',                " Partner Type of Receiver
            p_rcvprn TYPE edi_rcvprn DEFAULT 'EQ2CLNT400',        " Partner Number of Receiver
            p_mescod TYPE edi_mescod DEFAULT 'Z9',                " Logical Message Variant
            p_sndpor TYPE edi_sndpor DEFAULT 'TIBCO',             " Sender port
            p_sndprt TYPE edi_sndprt DEFAULT 'LS',                " Partner type of sender
            p_sndprn TYPE edi_sndprn DEFAULT 'TIBCO',             " Partner Number of Sender
            p_arckey TYPE idoccarkey,                             " EDI archive key
            p_mestyp TYPE edi_mestyp DEFAULT 'ORDERS',            " Message Type
            p_idoctp TYPE edi_idoctp DEFAULT 'ORDERS05',          " Basic type
            p_cimtyp TYPE edi_cimtyp DEFAULT 'ZQTCE_ORDERS05_01'. " Extension
SELECTION-SCREEN SKIP 1.
PARAMETERS: p_xmlv   TYPE text100,
            p_asxbeg TYPE text100,
            p_rootop TYPE text100,
            p_rootcl TYPE text100,
            p_asxend TYPE text100.
SELECTION-SCREEN SKIP 1.
PARAMETERS: p_parse  TYPE char1,
            p_format TYPE char1 DEFAULT 'X'.

INITIALIZATION.
  p_xmlv = '<?xml version="1.0" encoding="utf-16"?>'.
  p_asxbeg = '<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0"><asx:values>'.
  p_rootop = '<ROOT>'.
  p_rootcl = '</ROOT>'.
  p_asxend = '</asx:values></asx:abap>'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name     = p_file  " File Path
    EXCEPTIONS
      mask_too_long = 1
      OTHERS        = 2.

START-OF-SELECTION.
* Fill Communication Structure
  ls_edidc-direct = p_direct.
  ls_edidc-rcvpor = p_rcvpor.
  ls_edidc-rcvprt = p_rcvprt.
  ls_edidc-rcvprn = p_rcvprn.
  ls_edidc-mescod = p_mescod.
  ls_edidc-sndpor = p_sndpor.
  ls_edidc-sndprt = p_sndprt.
  ls_edidc-sndprn = p_sndprn.
  ls_edidc-arckey = p_arckey.
  ls_edidc-mestyp = p_mestyp.
  ls_edidc-idoctp = p_idoctp.
  ls_edidc-cimtyp = p_cimtyp.

* Create XML Object
  CREATE OBJECT lr_xml_doc.
* Upload XML File
  CALL METHOD lr_xml_doc->import_from_file
    EXPORTING
      filename = p_file
    RECEIVING
      retcode  = lv_retcode.
  IF lv_retcode = 0 OR lv_retcode <> 0.

    CALL METHOD lr_xml_doc->render_2_string
*      EXPORTING
*        pretty_print = 'X'
      IMPORTING
        retcode = lv_retcode
        stream  = lv_xml_string
        size    = lv_size.

    IF lv_retcode = 0.
* Convert XML to internal table
      IF p_parse = 'X'.
        CALL METHOD lr_xml_doc->render_2_xstring
          IMPORTING
            retcode = lv_retcode
            stream  = lv_xml_xstring
            size    = lv_size.

        CALL FUNCTION 'SMUM_XML_PARSE'
          EXPORTING
            xml_input = lv_xml_xstring
          TABLES
            xml_table = lt_xml_data
            return    = lt_return.
      ENDIF.

      IF p_format IS NOT INITIAL.
        DATA(liv_size) = strlen( lv_xml_string ).
        FIND '<ROOT>' IN lv_xml_string MATCH OFFSET lv_off
                                       MATCH LENGTH lv_len.
        SHIFT lv_xml_string BY lv_off PLACES LEFT.
        SHIFT lv_xml_string BY lv_len PLACES LEFT.
        DATA(liv_len1) = strlen( lv_xml_string ).
        FIND '</ROOT>' IN lv_xml_string MATCH OFFSET lv_off
                                        MATCH LENGTH lv_len.
        IF sy-subrc = 0.
          REPLACE '</ROOT>' IN lv_xml_string WITH space.
        ENDIF.
*        CONDENSE lv_xml_string NO-GAPS.
        DATA(liv_len2) = strlen( lv_xml_string ).

        CONCATENATE p_xmlv p_asxbeg p_rootop lv_xml_string INTO lv_xml_string.
        CONCATENATE lv_xml_string p_rootcl p_asxend INTO lv_xml_string.
        DATA(liv_len3) = strlen( lv_xml_string ).
      ENDIF.

      TRY.
          CALL TRANSFORMATION id
               SOURCE XML lv_xml_string
               RESULT root = ls_im_data.

          IF ls_im_data IS NOT INITIAL.
            CALL FUNCTION 'ZQTC_INBOUND_SAP_ORDERS_FM'
              EXPORTING
                im_edidd     = ls_im_data
                im_edidc     = ls_edidc
                im_immediate = p_immed
              IMPORTING
                ex_vbeln     = lv_ex_vbeln
                ex_message   = lt_ex_message.
            IF sy-subrc = 0.
              IF lv_ex_vbeln IS NOT INITIAL.
                WRITE: / lv_ex_vbeln, '--> Subscription Order Created Successfully'.
              ELSEIF lt_ex_message[] IS NOT INITIAL.
                LOOP AT lt_ex_message INTO DATA(ls_ex_message).
                  WRITE: / 'Error Information during IDOC creation:',
                         /  ls_ex_message-message.
                ENDLOOP.
              ENDIF.
            ENDIF.
          ENDIF.

        CATCH cx_transformation_error INTO lr_transformation_error.
          IF lr_transformation_error->kernel_errid IS NOT INITIAL.
            WRITE :/ 'kernel_errid = ', lr_transformation_error->kernel_errid.
          ENDIF.
          lv_err_text = lr_transformation_error->get_text( ).
          WRITE :/ 'Error Text = ', lv_err_text.

          IF lr_transformation_error->previous IS NOT INITIAL.
            lr_root = lr_transformation_error->previous.
            lr_conversion_no_date_time ?= lr_root.
            lv_err_text = lr_conversion_no_date_time->get_text( ).
            WRITE :/ 'Detailed Error Text = ', lv_err_text.
          ENDIF.

          lr_transformation_error->get_source_position(
            IMPORTING
              source_line  = lv_err_source_line
              program_name = lv_err_program_name
              include_name = lv_err_include_name ).
          WRITE: / 'Error Source Line = ', lv_err_source_line,
                 / 'Error Program Name = ', lv_err_program_name,
                 / 'Error Include Nname = ', lv_err_include_name.
      ENDTRY.
    ENDIF. "   IF lv_retcode = 0.

  ENDIF. "   IF lv_retcode = 0.
