*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_EMAIL_GENARATE_SUB_R112 (Include Program)
* PROGRAM DESCRIPTION: Email Generation
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   06/01/2020
* WRICEF ID: R112
* TRANSPORT NUMBER(S):  ED2K918328
* REFERENCE NO: ERPM-17101
*----------------------------------------------------------------------**

DATA: li_objpack  TYPE STANDARD TABLE OF sopcklsti1,
      lst_objpack TYPE sopcklsti1.

DATA: li_objhead  TYPE STANDARD TABLE OF solisti1,
      lst_objhead TYPE solisti1.

DATA: li_objbin  TYPE STANDARD TABLE OF solix,
      lst_objbin TYPE solix.

DATA: li_objtxt  TYPE STANDARD TABLE OF solisti1,
      lst_objtxt TYPE solisti1.

DATA: li_reclist  TYPE STANDARD TABLE OF somlreci1,
      lst_reclist TYPE somlreci1.

DATA: lv_doc_chng  TYPE sodocchgi1.
DATA: lv_tab_lines TYPE sy-tabix.

DATA : v_recname  TYPE bapibname-bapibname.

DATA :lv_data_string TYPE xstring, "declare string
      lv_string22    TYPE xstring,
      lv_xstring     TYPE xstring.

CONSTANTS : lc_addtype TYPE soextreci1-adr_typ VALUE 'INT'.


lv_date = sy-datum.       " System date
lv_time = sy-uzeit.       " System time

* Mail Subject
CONCATENATE text-967 '_' lv_date+4(2) lv_date+6(2) lv_date+0(4) INTO lv_doc_chng-obj_descr. "Release Order Job Run Report
CONCATENATE lv_doc_chng-obj_descr '_' lv_time INTO lv_doc_chng-obj_descr.

* Mail Contents
lst_objtxt = text-968.
APPEND lst_objtxt TO li_objtxt.

CLEAR lst_objtxt.
APPEND lst_objtxt TO li_objtxt.

" Mail Contents
lst_objtxt = text-969.
APPEND lst_objtxt TO li_objtxt.

CLEAR lst_objtxt.
APPEND lst_objtxt TO li_objtxt.

lst_objtxt = text-970.
APPEND lst_objtxt TO li_objtxt.

CLEAR lst_objtxt.
APPEND lst_objtxt TO li_objtxt.

lst_objtxt = text-971.
APPEND lst_objtxt TO li_objtxt.


DESCRIBE TABLE li_objtxt LINES lv_tab_lines.
READ TABLE li_objtxt INTO lst_objtxt INDEX lv_tab_lines.
lv_doc_chng-doc_size = ( lv_tab_lines - 1 ) * 255 + strlen( lst_objtxt ).

* Packing List For the E-mail Body
lst_objpack-head_start = 1.
lst_objpack-head_num   = 0.
lst_objpack-body_start = 1.
lst_objpack-body_num   = lv_tab_lines.
lst_objpack-doc_type   = 'RAW'.
APPEND lst_objpack TO li_objpack.

* Creation of the Document Attachment
LOOP AT i_xml_table ASSIGNING <gfs_xml>.

  lv_string22 = <gfs_xml>-data.
  CONCATENATE lv_data_string lv_string22 INTO lv_data_string IN BYTE MODE."SEPARATED BY cl_abap_char_utilities=>newline.
  CLEAR lv_string22.
ENDLOOP.

*TRY.
*    cl_bcs_convert=>string_to_xstring(
*      EXPORTING
*        iv_string     =     lv_data_string
*      "  iv_codepage   =     '4103'
*       " iv_add_bom    =     abap_true
*      RECEIVING
*        ev_xstring    =     lv_xstring ).
*
*  CATCH cx_bcs.    "
*
*ENDTRY.

**CALL FUNCTION 'HR_KR_STRING_TO_XSTRING'
**  EXPORTING
***   codepage_to      = '8300'
**    unicode_string   = lv_data_string
***   OUT_LEN          =
**  IMPORTING
**    xstring_stream   = lv_xstring
**  EXCEPTIONS
**    invalid_codepage = 1
**    invalid_string   = 2
**    OTHERS           = 3.
**IF sy-subrc <> 0.
**  IF sy-subrc = 1 .
**
**  ELSEIF sy-subrc = 2 .
**    WRITE:/ 'invalid string ' .
**  ENDIF.
**ENDIF.

DATA: l_zipper TYPE REF TO cl_abap_zip.
***Xstring to binary
CREATE OBJECT l_zipper.
"add file to zip
CALL METHOD l_zipper->add
  EXPORTING
    name    = 'test_file.xls' "filename
    content = lv_data_string.
"save zip
CALL METHOD l_zipper->save
  RECEIVING
    zip = lv_data_string.

DATA:
  lv_xls            TYPE so_obj_tp  VALUE 'xls',
  lv_htm            TYPE so_obj_tp  VALUE 'HTM',
  lv_sub            TYPE string,
  lv_mailto         TYPE ad_smtpadr,
  lv_status         TYPE val_text,
  lv_flag_exit      TYPE xchar,
  li_log_handle     TYPE bal_t_logh,
  li_log_numbers    TYPE bal_t_lgnm,
  lst_msg           TYPE bal_s_msg,
  lv_noofmsgs       TYPE i,
  lv_lncnt          TYPE i,
  li_msg            TYPE STANDARD TABLE OF bal_s_msg,
  lv_log_handle     TYPE balloghndl,
  lv_msg_handle     TYPE  balmsghndl,
  lst_text          TYPE so_text255,
  li_text           TYPE bcsy_text,
  lv_subject        TYPE sood-objdes,
  lv_subject2       TYPE sood-objdes,
  lv_binary_content TYPE solix_tab,
  lv_excel          TYPE string,
  lv_count          TYPE string,
  lv_hgt_cnt        TYPE string,
  lv_size           TYPE so_obj_len,
  lv_sent_to_all    TYPE os_boolean,
  lv_document_2     TYPE REF TO cl_document_bcs,
  bcs_exception     TYPE REF TO cx_bcs,
  lv_sender         TYPE REF TO cl_cam_address_bcs,
  lv_send_request   TYPE REF TO cl_bcs,
  lv_recipient      TYPE REF TO if_recipient_bcs,
  lt_dd07v_tab      TYPE STANDARD TABLE OF dd07v,
  li_final_tmp      TYPE zttqtc_bporder,
  gr_bcs_exception  TYPE REF TO cx_bcs.

lst_text   = 'Dear User,'(078).
APPEND lst_text TO li_text.

TRY.



    CALL METHOD cl_bcs_convert=>xstring_to_solix
      EXPORTING
        iv_xstring = lv_data_string
      RECEIVING
        et_solix   = lv_binary_content.


**
**
**    cl_bcs_convert=>string_to_solix(
**
**    EXPORTING
**      iv_string = lv_xstring
**      iv_codepage = '4103' "suitable for MS Excel, leave empty
**      iv_add_bom  = abap_true  "for other doc types
**    IMPORTING
**      et_solix = lv_binary_content
**      ev_size  = lv_size ).
**  CATCH cx_bcs.
**    MESSAGE e445(so).
ENDTRY.


TRY .

    lv_send_request = cl_bcs=>create_persistent( ).

    CALL METHOD cl_cam_address_bcs=>create_internet_address
      EXPORTING
        i_address_string = 'no-reply@wiley.com'
        i_address_name   = 'SAP ERP Team'
      RECEIVING
        result           = lv_sender.
    lv_subject = lv_sub.
    CALL METHOD lv_send_request->set_sender
      EXPORTING
        i_sender = lv_sender.


    lv_document_2 = cl_document_bcs=>create_document(
            i_type = lv_htm
            i_text = li_text
            i_subject = 'Test subject' ).                   "#EC NOTEXT

    lv_document_2->add_attachment(
i_attachment_type = 'ZIP'                                   "#EC NOTEXT
i_attachment_subject = 'Test file'                          "#EC NOTEXT
*          i_attachment_subject = lv_subject                 "#EC NOTEXT
i_att_content_hex = lv_binary_content ).

    lv_mailto = 'lwathudura@wiley.com'.

    lv_send_request->set_document( lv_document_2 ).

    lv_recipient = cl_cam_address_bcs=>create_internet_address( lv_mailto ).

    lv_send_request->add_recipient( lv_recipient ).

    lv_sent_to_all = lv_send_request->send( i_with_error_screen = abap_true ).

    COMMIT WORK.

  CATCH cx_bcs INTO gr_bcs_exception.
    WRITE:
      'Error!',
      'Error type:',
      gr_bcs_exception->error_type.
ENDTRY.


****DESCRIBE TABLE li_objbin LINES lv_tab_lines.
****lst_objhead = text-967.
****APPEND lst_objhead TO li_objhead.
****
***** Packing List For the E-mail Attachment
****lst_objpack-transf_bin = abap_true.
****lst_objpack-head_start = 1.
****lst_objpack-head_num   = 0.
****lst_objpack-body_start = 1.
****lst_objpack-body_num = lv_tab_lines.
****CONCATENATE text-967 '_' lv_date+4(2) lv_date+6(2) lv_date+0(4) INTO lst_objpack-obj_descr.   "Release Order Job Run Report
****CONCATENATE lst_objpack-obj_descr '_' lv_time INTO lst_objpack-obj_descr.
****lst_objpack-doc_type = 'XLS'.
****lst_objpack-doc_size = lv_tab_lines * 255.
****APPEND lst_objpack TO li_objpack.
****
****" Check email address is empty
****IF li_adr6 IS NOT INITIAL.
****  LOOP AT li_adr6 INTO DATA(lst_adr6).
***** Target Recipent
****    CLEAR lst_reclist.
****    lst_reclist-receiver = lst_adr6-smtp_addr.
****    lst_reclist-rec_type = 'U'.
****    lst_reclist-express = abap_true.
****    lst_reclist-com_type = lc_addtype.
****    lst_reclist-notif_del = abap_true.
****    lst_reclist-notif_ndel = abap_true.
****    APPEND lst_reclist TO li_reclist.
****  ENDLOOP.
****ENDIF.
****
****
****CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
****  EXPORTING
****    document_data              = lv_doc_chng
****    put_in_outbox              = abap_true
****    sender_address             = v_sender
****    sender_address_type        = lc_addtype
****    commit_work                = abap_true
****  TABLES
****    packing_list               = li_objpack
****    object_header              = li_objhead
****    contents_txt               = li_objtxt
****    contents_hex               = li_objbin
****    receivers                  = li_reclist
****  EXCEPTIONS
****    too_many_receivers         = 1
****    document_not_sent          = 2
****    document_type_not_exist    = 3
****    operation_no_authorization = 4
****    parameter_error            = 5
****    x_error                    = 6
****    enqueue_error              = 7
****    OTHERS                     = 8.
****IF sy-subrc NE 0.
****  MESSAGE text-973 TYPE lc_msgtype_e.
****ELSE.
****  MESSAGE text-972 TYPE lc_msgtype_i.
****ENDIF.
