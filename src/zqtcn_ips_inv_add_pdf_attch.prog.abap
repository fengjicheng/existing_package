*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_IPS_INV_ADD_PDF_ATTCH
* PROGRAM DESCRIPTION: This Include program is used read the PDF file
*                      content and create PDF file and attach to Invoice
*                      document created
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-26
* OBJECT ID:E095 (CR# ERP-6594)
* TRANSPORT NUMBER(S): ED2K912233
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: ED1K911103
* REFERENCE NO: INC0260559
* DEVELOPER: BTIRUVATHU
* DATE: 3-Sep-2019
* DESCRIPTION: New log features enabled while system fails to create
*              Attachment in the IntellidocX server.
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*

CONSTANTS :lc_pdf        TYPE saedoktyp VALUE 'PDF',         "extension
           lc_ar_object  TYPE rvari_vnam VALUE 'AR_OBJECT',  " ABAP: Name of Variant Variable
           lc_sap_object TYPE rvari_vnam VALUE 'SAP_OBJECT', " ABAP: Name of Variant Variable
           lc_devid      TYPE zdevid VALUE 'I0353'.          " Development ID


DATA: it_bin_content        TYPE STANDARD TABLE OF tdline, " Text Line
      lv_string             TYPE string,
      lv_xstring            TYPE xstring,
      lv_xstring_temp(2000) TYPE x,                        " Xsting_temp(2000) of type Byte fields
      lv_desc               TYPE text60,                   " Desc of type CHAR20
      lv_filename           TYPE char100,                  " Filename of type CHAR100
      lv_key                TYPE sapb-sapobjid,            " SAP ArchiveLink: Object ID (object identifier)
      lv_length             TYPE i,                        " Length of type Integers
      lv_op_len             TYPE sapb-length,              " Op_len of type Integers
      lv_ar_object          TYPE saeobjart,                " Document type
      lv_sap_object         TYPE saeanwdid,                " SAP ArchiveLink: Object type of business object
      li_binary_tab         TYPE solix_tab.


CALL FUNCTION 'ZQTC_GET_BIN_CONTENT_IPS_I0353'
  IMPORTING
    et_bin_content = it_bin_content
    ex_filename    = lv_filename.

CHECK it_bin_content IS NOT INITIAL.


SELECT  devid,     " Development ID
        param1,    " ABAP: Name of Variant Variable
        param2,    " ABAP: Name of Variant Variable
        srno ,     " ABAP: Current selection number
        sign,      " ABAP: ID: I/E (include/exclude values)
        opti,      " ABAP: Selection option (EQ/BT/CP/...)
        low,       " Lower Value of Selection Condition
        high       " Upper Value of Selection Condition
  FROM zcaconstant " Wiley Application Constant Table
  INTO TABLE @DATA(li_constant)
  WHERE devid = @lc_devid.
IF sy-subrc EQ 0.
  SORT li_constant BY param1.
ENDIF. " IF sy-subrc EQ 0

CONCATENATE i_rbkpv-belnr i_rbkpv-gjahr INTO lv_key.
IF lv_filename IS INITIAL.
  lv_desc = lv_key.
ELSE. " ELSE -> IF lv_filename IS INITIAL
  lv_desc = lv_filename.
ENDIF. " IF lv_filename IS INITIAL


LOOP AT it_bin_content ASSIGNING FIELD-SYMBOL(<lfs_bin_content>).

  CONCATENATE lv_string <lfs_bin_content> INTO lv_string.

ENDLOOP. " LOOP AT it_bin_content ASSIGNING FIELD-SYMBOL(<lfs_bin_content>)

CALL FUNCTION 'SCMS_BASE64_DECODE_STR'
  EXPORTING
    input  = lv_string
*   UNESCAPE       = 'X'
  IMPORTING
    output = lv_xstring
  EXCEPTIONS
    failed = 1
    OTHERS = 2.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF. " IF sy-subrc <> 0


*    Convert XSTRING to BINARY to get the length
CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
  EXPORTING
    buffer        = lv_xstring
  IMPORTING
    output_length = lv_length
  TABLES
    binary_tab    = li_binary_tab.


IF lv_length IS NOT INITIAL.
*      Length of type SAPB-LENGTH
  lv_op_len = lv_length.

  READ TABLE li_constant INTO DATA(lst_constant)
                            WITH KEY param1 = lc_ar_object
                            BINARY SEARCH.
  IF sy-subrc EQ 0.
    lv_ar_object = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

  READ TABLE li_constant INTO lst_constant
                            WITH KEY param1 = lc_sap_object
                            BINARY SEARCH.
  IF sy-subrc EQ 0.
    lv_sap_object = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

  IF lv_ar_object IS NOT INITIAL AND lv_sap_object IS NOT INITIAL.
*      Create attachment in MM Invoice
    CALL FUNCTION 'ARCHIV_CREATE_TABLE'
      EXPORTING
        ar_object                = lv_ar_object
        object_id                = lv_key
        sap_object               = lv_sap_object
        flength                  = lv_op_len
        doc_type                 = lc_pdf
        document                 = lv_xstring
        descr                    = lv_desc
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
* BOC - BTIRUVATHU - INC0260559- 2019/09/30 - ED1K911103
      MOVE sy-subrc TO lv_length.
" To create the application log
      PERFORM f_log_create.

      "Maintaing Failed attachment information in the Log
      PERFORM f_log_maintain USING lv_key lv_length.

      " Send Information to SAP Inbox
      PERFORM f_send_info_to_sap_inbox USING lv_key lv_length.

      " Saving the log
      PERFORM f_log_save.
* EOC - BTIRUVATHU - INC0260559- 2019/09/30 - ED1K911103
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF lv_ar_object IS NOT INITIAL AND lv_sap_object IS NOT INITIAL

ENDIF. " IF lv_length IS NOT INITIAL
