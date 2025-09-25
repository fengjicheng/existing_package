*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_IPS_INV_ATTCH_I0379_005
* PROGRAM DESCRIPTION: This Include program is used read the PDF file
*                      content and create PDF file and attach to Invoice
*                      document created
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE:   2020-02-08
* OBJECT ID:I0379 (ERPM-11517)
* TRANSPORT NUMBER(S): ED2K917673
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*

CONSTANTS :lc1_pdf        TYPE saedoktyp VALUE 'PDF',         "extension
           lc1_ar_object  TYPE rvari_vnam VALUE 'AR_OBJECT',  " ABAP: Name of Variant Variable
           lc1_sap_object TYPE rvari_vnam VALUE 'SAP_OBJECT', " ABAP: Name of Variant Variable
           lc1_devid      TYPE zdevid VALUE 'I0379'.          " Development ID


DATA: it1_bin_content        TYPE STANDARD TABLE OF tdline, " Text Line
      lv1_string             TYPE string,
      lv1_xstring            TYPE xstring,
      lv1_xstring_temp(2000) TYPE x,                        " Xsting_temp(2000) of type Byte fields
      lv1_desc               TYPE text60,                   " Desc of type CHAR20
      lv1_filename           TYPE char100,                  " Filename of type CHAR100
      lv1_key                TYPE sapb-sapobjid,            " SAP ArchiveLink: Object ID (object identifier)
      lv1_length             TYPE i,                        " Length of type Integers
      lv1_op_len             TYPE sapb-length,              " Op_len of type Integers
      lv1_ar_object          TYPE saeobjart,                " Document type
      lv1_sap_object         TYPE saeanwdid,                " SAP ArchiveLink: Object type of business object
      li1_binary_tab         TYPE solix_tab.

CALL FUNCTION 'ZQTC_GET_BIN_CONTENT_IPS_I0379'
  IMPORTING
    et_bin_content = it1_bin_content
    ex_filename    = lv1_filename.

CHECK it1_bin_content IS NOT INITIAL.


SELECT  devid,     " Development ID
        param1,    " ABAP: Name of Variant Variable
        param2,    " ABAP: Name of Variant Variable
        srno ,     " ABAP: Current selection number
        sign,      " ABAP: ID: I/E (include/exclude values)
        opti,      " ABAP: Selection option (EQ/BT/CP/...)
        low,       " Lower Value of Selection Condition
        high       " Upper Value of Selection Condition
  FROM zcaconstant " Wiley Application Constant Table
  INTO TABLE @DATA(li1_constant)
  WHERE devid = @lc1_devid.
IF sy-subrc EQ 0.
  SORT li1_constant BY param1.
ENDIF. " IF sy-subrc EQ 0

CONCATENATE i_rbkpv-belnr i_rbkpv-gjahr INTO lv1_key.
IF lv1_filename IS INITIAL.
  lv1_desc = lv1_key.
ELSE. " ELSE -> IF lv1_filename IS INITIAL
  lv1_desc = lv1_filename.
ENDIF. " IF lv1_filename IS INITIAL


LOOP AT it1_bin_content ASSIGNING FIELD-SYMBOL(<lfs1_bin_content>).

  CONCATENATE lv1_string <lfs1_bin_content> INTO lv1_string.

ENDLOOP. " LOOP AT it1_bin_content ASSIGNING FIELD-SYMBOL(<lfs1_bin_content>)

CALL FUNCTION 'SCMS_BASE64_DECODE_STR'
  EXPORTING
    input  = lv1_string
*   UNESCAPE       = 'X'
  IMPORTING
    output = lv1_xstring
  EXCEPTIONS
    failed = 1
    OTHERS = 2.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF. " IF sy-subrc <> 0


*    Convert XSTRING to BINARY to get the length
CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
  EXPORTING
    buffer        = lv1_xstring
  IMPORTING
    output_length = lv1_length
  TABLES
    binary_tab    = li1_binary_tab.


IF lv1_length IS NOT INITIAL.
*      Length of type SAPB-LENGTH
  lv1_op_len = lv1_length.

  READ TABLE li1_constant INTO DATA(lst1_constant)
                            WITH KEY param1 = lc1_ar_object
                            BINARY SEARCH.
  IF sy-subrc EQ 0.
    lv1_ar_object = lst1_constant-low.
  ENDIF. " IF sy-subrc EQ 0

  READ TABLE li1_constant INTO lst1_constant
                            WITH KEY param1 = lc1_sap_object
                            BINARY SEARCH.
  IF sy-subrc EQ 0.
    lv1_sap_object = lst1_constant-low.
  ENDIF. " IF sy-subrc EQ 0

  IF lv1_ar_object IS NOT INITIAL AND lv1_sap_object IS NOT INITIAL.
*      Create attachment in MM Invoice
    CALL FUNCTION 'ARCHIV_CREATE_TABLE'
      EXPORTING
        ar_object                = lv1_ar_object
        object_id                = lv1_key
        sap_object               = lv1_sap_object
        flength                  = lv1_op_len
        doc_type                 = lc1_pdf
        document                 = lv1_xstring
        descr                    = lv1_desc
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
      MOVE sy-subrc TO lv1_length.
      " To create the application log
      PERFORM f1_log_create.

      "Maintaing Failed attachment information in the Log
      PERFORM f1_log_maintain USING lv1_key lv1_length.

      " Send Information to SAP Inbox
      PERFORM f1_send_info_to_sap_inbox USING lv1_key lv1_length.

      " Saving the log
      PERFORM f1_log_save.
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF lv1_ar_object IS NOT INITIAL AND lv1_sap_object IS NOT INITIAL

ENDIF. " IF lv1_length IS NOT INITIAL
