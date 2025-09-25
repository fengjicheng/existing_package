*&---------------------------------------------------------------------*
*&  Include           ZQTCN_TEMPLATE_DOWNLOAD_TOP
* PROGRAM DESCRIPTION: File layout Download program data declaration
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   12/09/2019
* WRICEF ID:       E225
* TRANSPORT NUMBER(S):  ED2K916954
*&---------------------------------------------------------------------*

  TYPES : BEGIN OF ty_proname,
            program_name TYPE zca_templates-program_name,
          END OF ty_proname.

  TYPES : BEGIN OF ty_tempname,
            template_name TYPE zca_templates-template_name,
          END OF ty_tempname.

  TYPES : BEGIN OF ty_version,
            version TYPE zca_templates-version,
          END OF ty_version.

  DATA : i_return  TYPE STANDARD TABLE OF ddshretval,
         st_return TYPE ddshretval.

  DATA: i_content            TYPE STANDARD TABLE OF tdline,              " Data Declaration for File upload
        v_len                TYPE i,
        v_xstr_content       TYPE xstring,
        v_xstr_content_exist TYPE xstring,
        v_filename           TYPE string,
        v_path               TYPE string,
        v_fullpath           TYPE string.

  DATA: st_store_file  TYPE zca_templates,
        v_window_title TYPE string.

  CONSTANTS : c_errtype TYPE char1 VALUE 'E'.        "Error messege
