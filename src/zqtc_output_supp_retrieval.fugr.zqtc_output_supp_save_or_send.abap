FUNCTION zqtc_output_supp_save_or_send.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_SAVE_FILE) TYPE  XFELD OPTIONAL
*"     REFERENCE(IM_SEND_EMAIL) TYPE  XFELD OPTIONAL
*"     REFERENCE(IM_DOC_NUMBER) TYPE  SAEOBJID
*"     REFERENCE(IM_PDF_STREAM) TYPE  FPCONTENT
*"     REFERENCE(IM_ATTACHMENT_NAME) TYPE  TEXT60
*"     REFERENCE(IM_INVOICE) TYPE  XFELD OPTIONAL
*"     REFERENCE(IM_ORDER) TYPE  XFELD OPTIONAL
*"     REFERENCE(IM_ATTACH_DOC) TYPE  XFELD OPTIONAL
*"  EXPORTING
*"     VALUE(EX_EMAIL_DATA) TYPE  SOLIX_TAB
*"  EXCEPTIONS
*"      FILE_NOT_FOUND
*"----------------------------------------------------------------------
*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTC_OUTPUT_SUPP_RETRIEVAL
* PROGRAM DESCRIPTION: FM to save the pdf attachment list of Material
* in app server or sending the attachments in an email based on input
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2017-04-10
* OBJECT ID: E151
* TRANSPORT NUMBER(S):  ED2K905075(W)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No: <Transport No>
* Reference No:  <DER or TPR or SCR>
* Developer:
* Date:  YYYY-MM-DD
* Description:
*------------------------------------------------------------------- *
*Local data declaration
  DATA: lv_filepath        TYPE string,
        lv_length          TYPE i,
        lv_op_len          TYPE sapb-length,       " Op_len of type Integers
        lv_xstring_content TYPE xstring,
        li_binary_tab      TYPE solix_tab,
        li_email_data      TYPE solix_tab,
        lv_ar_object       TYPE saeobjart,
        lv_sap_object      TYPE saeanwdid.

*  Local constant declaration
  CONSTANTS: lc_pdf        TYPE saedoktyp VALUE 'PDF', "extension
             lc_filepath   TYPE rvari_vnam VALUE 'FILEPATH',
             lc_invoice    TYPE rvari_vnam VALUE 'INVOICE',
             lc_order      TYPE rvari_vnam VALUE 'ORDER',
             lc_ar_object  TYPE rvari_vnam VALUE 'AR_OBJECT',
             lc_sap_object TYPE rvari_vnam VALUE 'SAP_OBJECT',
             lc_devid      TYPE zdevid VALUE 'E098'.  " Development ID

  SELECT  devid,      " Development ID
          param1,     " ABAP: Name of Variant Variable
          param2,     " ABAP: Name of Variant Variable
          srno ,      " ABAP: Current selection number
          sign,       " ABAP: ID: I/E (include/exclude values)
          opti  ,     " ABAP: Selection option (EQ/BT/CP/...)
          low  ,      " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE @DATA(li_constant)
    WHERE devid = @lc_devid.
  IF sy-subrc EQ 0.
    SORT li_constant BY param1 param2.
  ENDIF. " IF sy-subrc IS INITIAL

  lv_xstring_content = im_pdf_stream.
*    Convert XSTRING to BINARY to get the length
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer        = lv_xstring_content
    IMPORTING
      output_length = lv_length
    TABLES
      binary_tab    = li_binary_tab.

* For email sending after conversion of XSTRING TO BINARY
  IF li_binary_tab IS NOT INITIAL.
    IF im_send_email IS NOT INITIAL.
      li_email_data[] = li_binary_tab[].
    ENDIF.
  ENDIF.

*   For saving the pdf files in application server
  IF im_save_file IS NOT INITIAL.
*        Get filepath from constant table
    READ TABLE li_constant INTO DATA(lst_constant) WITH KEY param1 = lc_filepath.
    IF sy-subrc EQ 0.
      DATA(lv_file) = lst_constant-low.
    ENDIF.

    IF im_invoice IS NOT INITIAL. "if its INVOICE
      DATA(lv_file_name) = lc_invoice.
    ELSEIF im_order IS NOT INITIAL. "if its ORDER
      lv_file_name = lc_order.
    ENDIF.
*     Filepath
    CONCATENATE lv_file lv_file_name '_' im_doc_number '_' sy-datum '_' sy-uzeit '.' lc_pdf INTO lv_filepath.

**** Open Folder and save Files in Application server
    IF lv_filepath IS NOT INITIAL.
      OPEN DATASET lv_filepath FOR OUTPUT IN BINARY MODE. " Set as Ready for Input
      IF sy-subrc NE 0.
        RAISE file_not_found.
      ELSE. " ELSE -> IF sy-subrc NE 0
        TRANSFER lv_xstring_content TO lv_filepath.
        CLOSE DATASET lv_filepath.
      ENDIF. " IF sy-subrc NE 0
    ENDIF. " IF lv_filepath IS NOT INITIAL
  ENDIF. "im_save_file is not initial


  IF lv_length IS NOT INITIAL.
*      Length of type SAPB-LENGTH
    lv_op_len = lv_length.

    IF im_invoice IS NOT INITIAL.
      CLEAR lst_constant.
*      INVOICE and AR_OBJECT
      READ TABLE li_constant INTO lst_constant WITH KEY param1 = lc_invoice
                                                        param2 = lc_ar_object.
      IF sy-subrc EQ 0.
        lv_ar_object = lst_constant-low.
      ENDIF.

      CLEAR lst_constant.
*      INVOICE & SAP_OBJECT
      READ TABLE li_constant INTO lst_constant WITH KEY param1 = lc_invoice
                                                        param2 = lc_sap_object.
      IF sy-subrc EQ 0.
        lv_sap_object = lst_constant-low.
      ENDIF.
    ELSEIF im_order IS NOT INITIAL.
      CLEAR lst_constant.
*      ORDER & AR_OBJECT
      READ TABLE li_constant INTO lst_constant WITH KEY param1 = lc_order
                                                        param2 = lc_ar_object.
      IF sy-subrc EQ 0.
        lv_ar_object = lst_constant-low.
      ENDIF.

      CLEAR lst_constant.
*     ORDER & SAP_OBJECT
      READ TABLE li_constant INTO lst_constant WITH KEY param1 = lc_order
                                                        param2 = lc_sap_object.
      IF sy-subrc EQ 0.
        lv_sap_object = lst_constant-low.
      ENDIF.
    ENDIF.

    IF im_attach_doc IS NOT INITIAL.
*      Create attachment in order/invoice/quotation/contract
      CALL FUNCTION 'ARCHIV_CREATE_TABLE'
        EXPORTING
          ar_object                = lv_ar_object
          object_id                = im_doc_number
          sap_object               = lv_sap_object
          flength                  = lv_op_len
          doc_type                 = lc_pdf
          document                 = lv_xstring_content
          descr                    = im_attachment_name
        EXCEPTIONS
          error_archiv             = 1
          error_communicationtable = 2
          error_connectiontable    = 3
          error_kernel             = 4
          error_parameter          = 5
          error_user_exit          = 6
          error_mandant            = 7
          blocked_by_policy        = 8
          OTHERS                   = 9.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    ENDIF.
  ENDIF.

* Populate output
  ex_email_data[] = li_email_data[].
ENDFUNCTION.
