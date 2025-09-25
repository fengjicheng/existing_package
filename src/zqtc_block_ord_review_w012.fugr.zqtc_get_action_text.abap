FUNCTION ZQTC_GET_ACTION_TEXT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_WORKITEMID) TYPE  SWR_STRUCT-WORKITEMID
*"     REFERENCE(IM_USER) TYPE  SWP_AGENT
*"     REFERENCE(IM_LANGU) TYPE  SYLANGU
*"  EXPORTING
*"     REFERENCE(EX_TEXT) TYPE  TLINE_T
*"     REFERENCE(EX_REASON_TEXT) TYPE  ZTQTC_REASON_TEXT
*"----------------------------------------------------------------------
**----------------------------------------------------------------------*
** PROGRAM NAME:         ZQTC_GET_ACTION_TEXT                           *
** PROGRAM DESCRIPTION:  Function Module implemented to get reason text *
** DEVELOPER:            Paramita Bose (PBOSE)                          *
** CREATION DATE:        10/03/2017                                     *
** OBJECT ID:            W012                                           *
** TRANSPORT NUMBER(S):  ED2K904702                                     *
**----------------------------------------------------------------------*
**----------------------------------------------------------------------*
** REVISION HISTORY-----------------------------------------------------*
** REVISION NO: <TRANSPORT NO>
** REFERENCE NO:  <DER OR TPR OR SCR>
** DEVELOPER:
** DATE:  MM/DD/YYYY
** DESCRIPTION:
**----------------------------------------------------------------------*

DATA:  li_reason_txt               TYPE STANDARD TABLE OF
                         swcont-value INITIAL SIZE 0,      " Character value
         st_reason_txt               TYPE swcont-value, " Character value
         li_object_content           TYPE STANDARD TABLE OF
                   solisti1 INITIAL SIZE 0,
         li_subcontainer_all_objects TYPE STANDARD TABLE OF
         swr_cont INITIAL SIZE 0, " Container (name-value pairs)
         lv_wa_reason                 TYPE swr_cont, " Container (name-value pairs)
         lv_no_att                    TYPE  sy-index,         " Loop Index
         lv_document_id               TYPE sofolenti1-doc_id,
         li_simple_container         TYPE STANDARD TABLE OF
                 swr_cont INITIAL SIZE 0, " Container (name-value pairs)
         li_message_lines            TYPE STANDARD TABLE OF
                    swr_messag INITIAL SIZE 0, " Workflow Interfaces: Messages
         li_message_struct           TYPE STANDARD TABLE OF
                   swr_mstruc INITIAL SIZE 0,
         li_subcontainer_bor_objects TYPE STANDARD TABLE OF
         swr_cont INITIAL SIZE 0, " Container (name-value pairs)
         lv_user                      TYPE xubname, " User Name in User Master Record
         li_text                     TYPE STANDARD TABLE OF tline INITIAL SIZE 0,
         st_text                     TYPE tline.              " SAPscript: Text Lines

* Constant declaration
  CONSTANTS: lc_tdformat TYPE tdformat VALUE '*', " Tag column
             lc_element  TYPE swc_elem VALUE '_ATTACH_OBJECTS'. " Element

* Get user
  lv_user = im_user+2(12).

* Read the work item container from the work item ID
  CALL FUNCTION 'SAP_WAPI_READ_CONTAINER'
    EXPORTING
      workitem_id              = im_workitemid
      language                 = im_langu
      user                     = lv_user
    TABLES
      simple_container         = li_simple_container
      message_lines            = li_message_lines
      message_struct           = li_message_struct
      subcontainer_bor_objects = li_subcontainer_bor_objects
      subcontainer_all_objects = li_subcontainer_all_objects.

* Initialize
  lv_no_att = 0.

* Read the _ATTACH_OBJECTS element
  LOOP AT li_subcontainer_all_objects INTO lv_wa_reason
                           WHERE element = lc_element.
    lv_no_att = lv_no_att + 1.
    lv_document_id = lv_wa_reason-value.

  ENDLOOP.

* Read the SOFM Document
  CALL FUNCTION 'SO_DOCUMENT_READ_API1'
    EXPORTING
      document_id                = lv_document_id
    TABLES
      object_content             = li_object_content
    EXCEPTIONS
      document_id_not_exist      = 1
      operation_no_authorization = 2
      x_error                    = 3
      OTHERS                     = 4.

* Pass the text to the exporting parameter
  IF sy-subrc = 0.
    LOOP AT li_object_content INTO st_reason_txt.
      SHIFT st_reason_txt BY 5 PLACES LEFT.
      APPEND st_reason_txt TO li_reason_txt.

      st_text-tdformat = lc_tdformat.
      st_text-tdline   = st_reason_txt+0(125).

      APPEND st_text TO li_text.

      st_text-tdformat = lc_tdformat.
      st_text-tdline   = st_reason_txt+126(125).
      IF st_text-tdline IS NOT INITIAL.
        APPEND st_text TO li_text.
      ENDIF.

    ENDLOOP.
  ENDIF.
* Populate reason text and other text
  ex_reason_text[] = li_reason_txt[].
  ex_text[] = li_text[].

ENDFUNCTION.
