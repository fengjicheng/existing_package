*&---------------------------------------------------------------------*
*&  Include           ZQTCN_TEMPLATE_UPLOAD_TOP
* PROGRAM DESCRIPTION: File layout Upload Data declaration
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   12/09/2019
* WRICEF ID:       E225
* TRANSPORT NUMBER(S):  ED2K916954
*&---------------------------------------------------------------------*

TABLES sscrfields.

TYPES : BEGIN OF ty_proname,                                    " Data declaration for get program name
          name TYPE trdir-name,
        END OF ty_proname.

TYPES : BEGIN OF ty_tempname,                                   " Data declaration for get template name
          template_name TYPE zca_templates-template_name,
        END OF ty_tempname.

TYPES : BEGIN OF ty_wricefid,                                    " Data declaration for get WRICEF ID
          wricef_id TYPE zca_templates-wricef_id,
        END OF ty_wricefid.

DATA : i_return  TYPE STANDARD TABLE OF ddshretval,               "
       st_return TYPE ddshretval.

DATA: i_content            TYPE STANDARD TABLE OF tdline,              " Data Declaration for File upload
      v_len                TYPE i,
      v_xstr_content       TYPE xstring,
      v_xstr_content_exist TYPE xstring,
      v_popup_return       TYPE char1,
      v_extension          TYPE char10.


DATA: st_store_file TYPE zca_templates.                           " Data declaration custom data upload

DATA : v_comments TYPE zca_templates-comments.                    " data declaration for long comments

CONSTANTS : c_errtype TYPE char1 VALUE 'E',                       " Error messege
            c_comment TYPE string VALUE 'COMMENTS'.               " Comment button.
