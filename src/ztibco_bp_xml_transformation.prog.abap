*----------------------------------------------------------------------*
* PROGRAM NAME: ZTIBCO_BP_XML_TRANSFORMATION (Report)
* PROGRAM DESCRIPTION:
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 27/08/2018
* TRANSPORT NUMBER(S): ED2K913229
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZTIBCO_BP_XML_TRANSFORMATION
*&
*&---------------------------------------------------------------------*

REPORT ztibco_bp_xml_transformation.

DATA: lr_xml_doc     TYPE REF TO cl_xml_document,
      lv_retcode     TYPE sy-subrc,
      lv_xml_string  TYPE string,
      lv_xml_xstring TYPE xstring,
      lv_size        TYPE sytabix,
      li_xml_data    TYPE TABLE OF smum_xmltb,
      li_return      TYPE TABLE OF bapiret2,
      li_ex_return   TYPE ztqtc_customer_date_outputs,
      li_messages    TYPE bapiretct,
      li_im_data     TYPE ztqtc_customer_date_inputs.

DATA: lr_transformation_error    TYPE REF TO cx_transformation_error,
      lr_conversion_no_date_time TYPE REF TO cx_sy_conversion_no_date_time,
      lr_root                    TYPE REF TO cx_root,
      lv_err_text                TYPE string,
      lv_err_source_line         TYPE i,
      lv_err_program_name        TYPE syrepid,
      lv_err_include_name        TYPE syrepid,
      lv_off                     TYPE i,
      lv_len                     TYPE i.

PARAMETERS: p_file   TYPE rlgrap-filename,
            p_source TYPE tpm_source_name,
            p_guid   TYPE idoccarkey.
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
  p_rootop = '<ROOT><ZSTQTC_CUSTOMER_DATE_INPUT>'.
  p_rootcl = '</ZSTQTC_CUSTOMER_DATE_INPUT></ROOT>'.
  p_asxend = '</asx:values></asx:abap>'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name     = p_file  " File Path
    EXCEPTIONS
      mask_too_long = 1
      OTHERS        = 2.

START-OF-SELECTION.
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
            xml_table = li_xml_data
            return    = li_return.
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
*        SHIFT lv_xml_string BY lv_len PLACES RIGHT.
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
               RESULT root = li_im_data.

          IF li_im_data[] IS NOT INITIAL.
            CALL FUNCTION 'ZQTC_CUSTOMER_IB_INTERFACE'
              EXPORTING
                im_data   = li_im_data
                im_source = p_source
                im_guid   = p_guid
              IMPORTING
                ex_return = li_ex_return.
            IF li_ex_return[] IS NOT INITIAL.
              LOOP AT li_ex_return INTO DATA(lis_ex_return).
                li_messages = lis_ex_return-messages.
                IF li_messages[] IS NOT INITIAL.
                  READ TABLE li_messages TRANSPORTING NO FIELDS
                                         WITH KEY type = 'E'.
                  IF sy-subrc = 0.
                    WRITE 'Please find the below BP Creation/Updation error details:'.
                    SKIP.
                    LOOP AT li_messages INTO DATA(lis_err_messages) WHERE type = 'E'.
                      WRITE: / lis_err_messages-message.
                      CLEAR lis_err_messages.
                    ENDLOOP.
                  ELSE.
                    WRITE 'Please find the below details of BP Creation/Updation:'.
                    SKIP.
                    LOOP AT li_messages INTO DATA(lis_messages).
                      WRITE: / lis_messages-message.
                      CLEAR lis_messages.
                    ENDLOOP.
                  ENDIF.
                ENDIF.
                CLEAR lis_ex_return.
              ENDLOOP.
            ENDIF.
          ENDIF.

        CATCH cx_transformation_error INTO lr_transformation_error.
          WRITE 'Please find the below Transformation Error details:'.
          SKIP.
          IF lr_transformation_error->kernel_errid IS NOT INITIAL.
            WRITE: / 'kernel_errid = ', lr_transformation_error->kernel_errid.
          ENDIF.
          lv_err_text = lr_transformation_error->get_text( ).
          WRITE: / 'Error Text = ', lv_err_text.

          IF lr_transformation_error->previous IS NOT INITIAL.
            lr_root = lr_transformation_error->previous.
            lr_conversion_no_date_time ?= lr_root.
            lv_err_text = lr_conversion_no_date_time->get_text( ).
            WRITE: / 'Detailed Error Text = ', lv_err_text.
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
    ENDIF. " IF lv_retcode = 0.

  ENDIF. " IF lv_retcode = 0 OR lv_retcode <> 0.
