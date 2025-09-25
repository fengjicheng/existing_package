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
  CLEAR lst_objbin.
  lst_objbin-line = <gfs_xml>-data.
  APPEND lst_objbin TO li_objbin.
ENDLOOP.


DESCRIBE TABLE li_objbin LINES lv_tab_lines.
lst_objhead = text-967.
APPEND lst_objhead TO li_objhead.

* Packing List For the E-mail Attachment
lst_objpack-transf_bin = abap_true.
lst_objpack-head_start = 1.
lst_objpack-head_num   = 0.
lst_objpack-body_start = 1.
lst_objpack-body_num = lv_tab_lines.
CONCATENATE text-967 '_' lv_date+4(2) lv_date+6(2) lv_date+0(4) INTO lst_objpack-obj_descr.   "Release Order Job Run Report
CONCATENATE lst_objpack-obj_descr '_' lv_time INTO lst_objpack-obj_descr.
lst_objpack-doc_type = 'XLS'.
lst_objpack-doc_size = lv_tab_lines * 255.
APPEND lst_objpack TO li_objpack.

" Check email address is empty
IF li_adr6 IS NOT INITIAL.
  LOOP AT li_adr6 INTO DATA(lst_adr6).
* Target Recipent
    CLEAR lst_reclist.
    lst_reclist-receiver = lst_adr6-smtp_addr.
    lst_reclist-rec_type = 'U'.
    lst_reclist-express = abap_true.
    lst_reclist-com_type = lc_addtype.
    lst_reclist-notif_del = abap_true.
    lst_reclist-notif_ndel = abap_true.
    APPEND lst_reclist TO li_reclist.
  ENDLOOP.
ENDIF.


CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
  EXPORTING
    document_data              = lv_doc_chng
    put_in_outbox              = abap_true
    sender_address             = v_sender
    sender_address_type        = lc_addtype
    commit_work                = abap_true
  TABLES
    packing_list               = li_objpack
    object_header              = li_objhead
    contents_txt               = li_objtxt
    contents_hex               = li_objbin
    receivers                  = li_reclist
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
  MESSAGE text-973 TYPE lc_msgtype_e.
ELSE.
  MESSAGE text-972 TYPE lc_msgtype_i.
ENDIF.
