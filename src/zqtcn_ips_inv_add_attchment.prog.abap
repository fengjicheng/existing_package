*&---------------------------------------------------------------------*
*&  Include  ZQTCN_IPS_INV_ADD_ATTCHMENT
*&---------------------------------------------------------------------*
CONSTANTS : lc_objtyp      TYPE swo_objtyp VALUE 'BUS2081', " Object Type
            lc_note_objtyp TYPE swo_objtyp VALUE 'MESSAGE', " Object Type
            lc_att_objtyp  TYPE so_obj_tp VALUE 'EXT',      " Code for document class
            lc_reltyp      TYPE binreltyp VALUE 'ATTA'.     " Relationship type


DATA: it_lines       TYPE STANDARD TABLE OF tline,  " Text Lines
      lst_lines      TYPE tline,                    " SAPscript: Text Lines
      it_bin_content TYPE STANDARD TABLE OF tdline, " Text Line
      lv_header      TYPE char20,                   " Header of type CHAR20
      lv_string      TYPE string.


**&--------  Local Data Declaration  ---------------------------------------------------------------------*
DATA: lst_fol_id    TYPE soodk,                  " SAPoffice: Definition of an Object (Key Part)
      lst_obj_id    TYPE soodk,                  " SAPoffice: Definition of an Object (Key Part)
      lst_obj_data  TYPE sood1,                  " SAPoffice: object definition, change attributes
      lst_folmem_k  TYPE sofmk,                  " SAPoffice: folder contents (key part)
      lst_note      TYPE borident,               " Object Relationship Service: BOR object identifier
      lst_object    TYPE borident,               " Object Relationship Service: BOR object identifier
      lv_ep_note    TYPE borident-objkey,        " Object key
      lv_offset     TYPE i,                      " Offset of type Integers
      lv_filename   TYPE char100,                " Filename of type CHAR100
      lv_subrc      TYPE subrc,                  " Subroutines for return code
      lv_key        TYPE swo_typeid,             " Object key
      it_objhead    TYPE STANDARD TABLE OF soli, " SAPoffice: line, length 255
      it_content    LIKE STANDARD TABLE OF soli, " SAPoffice: line, length 2l
      lv_desc       TYPE so_obj_des ,            " Test pdf documents
      lv_xstring    TYPE xstring,
      li_binary_tab TYPE solix_tab.


CALL FUNCTION 'ZQTC_GET_BIN_CONTENT_IPS_I0353'
  IMPORTING
    et_bin_content = it_bin_content
    ex_filename    = lv_filename.

CHECK it_bin_content IS NOT INITIAL.

CONCATENATE i_rbkpv-belnr i_rbkpv-gjahr INTO lv_key.
IF lv_filename IS INITIAL.
  lv_desc = lv_key.
ELSE. " ELSE -> IF lv_filename IS INITIAL
  lv_desc = lv_filename.
ENDIF. " IF lv_filename IS INITIAL


lst_object-objkey  = lv_key.
lst_object-objtype = lc_objtyp. "BUS2081

*LOOP AT it_bin_content ASSIGNING FIELD-SYMBOL(<lfs_bin_content>).
*
*  lst_lines-tdline = <lfs_bin_content>.
*  APPEND lst_lines TO it_lines.
*
*  CLEAR : lst_lines.
*
*ENDLOOP. " LOOP AT it_bin_content ASSIGNING FIELD-SYMBOL(<lfs_bin_content>)

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


CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
  EXPORTING
    buffer        = lv_xstring
*  IMPORTING
*    output_length = lv_length
  TABLES
    binary_tab    = li_binary_tab.


CALL FUNCTION 'SO_SOLIXTAB_TO_SOLITAB'
  EXPORTING
    ip_solixtab = li_binary_tab
  IMPORTING
    ep_solitab  = it_content.


*CALL FUNCTION 'RKD_WORD_WRAP'
*  EXPORTING
*    textline            = lv_string
**   DELIMITER           = ' '
*    outputlen           = 255
*  TABLES
*    out_lines           = it_content
*  EXCEPTIONS
*    outputlen_too_large = 1
*    OTHERS              = 2.
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF. " IF sy-subrc <> 0


*
*CALL FUNCTION 'SX_TABLE_LINE_WIDTH_CHANGE' " Call Function Module for Change the Table Line Width
*  TABLES
*    content_in                  = it_lines
*    content_out                 = it_content
*  EXCEPTIONS
*    err_line_width_src_too_long = 1
*    err_line_width_dst_too_long = 2
*    err_conv_failed             = 3
*    OTHERS                      = 4.
*IF sy-subrc <> 0.
*  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*ENDIF. " IF sy-subrc <> 0

CHECK lv_subrc IS INITIAL.

CALL FUNCTION 'SO_CONVERT_CONTENTS_BIN' " Call the Function Module for Converts into Bin
  EXPORTING
    it_contents_bin = it_content
  IMPORTING
    et_contents_bin = it_content.


CALL FUNCTION 'SO_FOLDER_ROOT_ID_GET' " Call the Function Module to get the Folder Id
  EXPORTING
    region    = 'B'
  IMPORTING
    folder_id = lst_fol_id
  EXCEPTIONS
    OTHERS    = 1.

lst_obj_data-objsns    = 'O'.
lst_obj_data-objla     = sy-langu.
lst_obj_data-objdes    = lv_desc.
lst_obj_data-file_ext  = 'JPG'.
lst_obj_data-objlen    = lines( it_content ) * 255.

CALL FUNCTION 'SO_OBJECT_INSERT'
  EXPORTING
    folder_id             = lst_fol_id
    object_type           = lc_att_objtyp "EXT
    object_hd_change      = lst_obj_data
  IMPORTING
    object_id             = lst_obj_id
  TABLES
    objhead               = it_objhead
    objcont               = it_content
  EXCEPTIONS
    active_user_not_exist = 35
    folder_not_exist      = 6
    object_type_not_exist = 17
    owner_not_exist       = 22
    parameter_error       = 23
    OTHERS                = 1000.

IF sy-subrc = 0 AND lst_object-objkey IS NOT INITIAL.
  lst_folmem_k-foltp = lst_fol_id-objtp.
  lst_folmem_k-folyr = lst_fol_id-objyr.
  lst_folmem_k-folno = lst_fol_id-objno.
  lst_folmem_k-doctp = lst_obj_id-objtp.
  lst_folmem_k-docyr = lst_obj_id-objyr.
  lst_folmem_k-docno = lst_obj_id-objno.
  lv_ep_note        = lst_folmem_k.

  lst_note-objtype   = lc_note_objtyp. "MESSAGE.
  lst_note-objkey    = lv_ep_note.

  CALL FUNCTION 'BINARY_RELATION_CREATE_COMMIT' " Call the Function Module For Commit the Object
    EXPORTING
      obj_rolea    = lst_object
      obj_roleb    = lst_note
      relationtype = lc_reltyp                  "ATTA
    EXCEPTIONS
      OTHERS       = 1.
ELSE. " ELSE -> IF sy-subrc = 0 AND lst_object-objkey IS NOT INITIAL
  RETURN.
ENDIF. " IF sy-subrc = 0 AND lst_object-objkey IS NOT INITIAL
