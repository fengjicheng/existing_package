FUNCTION zqtc_bup0id_event_dchck_e165 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------
*------------------------------------------------------------------------*
* FUNCTION MODULE NAME: ZQTC_BUP0ID_EVENT_DCHCK_E165
*                       called via BUP event check maintained in BUS3 tcode
* DESCRIPTION: BP Validations - Identifications
* DEVELOPER: PRABHU (PTUFARAM)
* CREATION DATE: 09/12/2018
* OBJECT ID: E165 / CR# 6664
* TRANSPORT NUMBER(s):ED2K913318
*------------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K920531
* REFERENCE NO: OTCM-29502
* DEVELOPER:MIMMADISET
* DATE: 11/27/2020
* DESCRIPTION:Set defalts changes for mandatory checks
*----------------------------------------------------------------------*

* Local declarations
  DATA: lv_actv_flag_e165 TYPE zactive_flag.                            "Active / Inactive flag

* Local constants
  CONSTANTS:
    lc_wricef_id_e165 TYPE zdevid VALUE 'E165',       "Constant value for WRICEF (E165)
    lc_var            TYPE zvar_key VALUE 'RELTYP_VALIDATION',
    lc_ser_num_e165_2 TYPE zsno   VALUE '002'.        "Serial Number (001).
* Check if enhancement needs to be triggered
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e165              "Constant value for WRICEF (E165)
      im_ser_num     = lc_ser_num_e165_2              "Serial Number (001)
      im_var_key     = lc_var
    IMPORTING
      ex_active_flag = lv_actv_flag_e165.             "Active / Inactive flag
  IF lv_actv_flag_e165 EQ abap_true.
    INCLUDE zqtcn_valid_relation_id IF FOUND.
  ENDIF.
****BOC  MIMMADISET OTCM-29502 ED2K920531
* Local Data
  DATA:
    lv_actv_e191  TYPE zactive_flag .

* Local constants
  CONSTANTS:
    lc_devid_e191   TYPE zdevid  VALUE 'E191',    " Development ID: E191
    lc_sno_e191_001 TYPE zsno    VALUE '001'.     " Serial Number: 001
*--------------------------------------------------------------------*
* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_devid_e191                " Development ID: E191
      im_ser_num     = lc_sno_e191_001              " Serial Number: 001
    IMPORTING
      ex_active_flag = lv_actv_e191.                " Active / Inactive Flag
  IF lv_actv_e191 EQ abap_true.                     " Enhancement is not Active
    INCLUDE zqtcn_bp_def_mandatory_e191 IF FOUND.
  ENDIF.
****EOC  MIMMADISET OTCM-29502 ED2K920531
** BOC VCHITTIBAL
  CONSTANTS: lc_title    TYPE sytitle VALUE 'Reason for Change',  "title text
             lc_asterisk TYPE c       VALUE '*',                  "Asterisk(*)
             lc_colon    TYPE c       VALUE ':',                 "Colon(:)
             lc_tdobject TYPE char4  VALUE 'KNA1'.                "Text Object

  DATA: li_ch_text  TYPE catsxt_longtext_itab,      "table to store pop up text
        lv_tdid     TYPE char4,
        lv_bp       TYPE bu_partner,                "BP
        lst_header  TYPE thead,                     "Header for text creattion/updation
        li_lines    TYPE TABLE OF tline,            "Text lines
        lst_lines   TYPE tline,                     "work area for text lines
        lv_insert   TYPE c,                         "Insert flag
        lv_function TYPE c,                         "Function: Insert
        lst_ch_text TYPE char72,                    "work area for popup text
        lt_roles    TYPE bup_partnerroles_t,
        lv_partner  TYPE bu_partner,
        lv_change   TYPE bu_xchng.

*  IF sy-uname = 'VCHITTIBAL'.
*    BREAK-POINT.
*    lv_tdid = '0005'.
*    lv_partner = cvi_bdt_adapter=>get_current_bp( ).
*    lt_roles = cvi_bdt_adapter=>get_current_roles( ).
*
**    READ TABLE lt_roles INTO DATA(lst_role) WITH KEY role = 'ISM000'.
**    IF sy-subrc IS INITIAL.
**      DATA(lv_check) = abap_true.
**    ENDIF.
**
**    READ TABLE lt_roles INTO lst_role WITH KEY role = '000000'.
**    IF sy-subrc IS INITIAL.
**      lv_check = abap_true.
**    ENDIF.
*
*    CALL FUNCTION 'BUP_BUPA_EVENT_XCHNG'
*      IMPORTING
*        e_xchng = lv_change.
*    .
*
*    IF lv_change = abap_true.
*      "Calling FM to have a popup that will allow user to provide reason for change
*      CALL FUNCTION 'CATSXT_SIMPLE_TEXT_EDITOR'
*        EXPORTING
*          im_title        = lc_title
*          im_start_column = 25
*          im_start_row    = 6
*        CHANGING
*          ch_text         = li_ch_text.
*      lv_bp = lv_partner.
*      "If reason for change is provided
*      IF li_ch_text IS NOT INITIAL.
*
*        "Populate header data for text
*        lst_header-tdid      = lv_tdid.
*        lst_header-tdname    = lv_bp.
*        lst_header-tdspras   = sy-langu.
*        lst_header-tdobject  = lc_tdobject.
*
**  IF t180-trtyp = lc_mode. "IF Change mode get the existing text if any
*        "Calling FM to read the existing text
*        CALL FUNCTION 'READ_TEXT'
*          EXPORTING
*            client                  = sy-mandt
*            id                      = lst_header-tdid
*            language                = lst_header-tdspras
*            name                    = lst_header-tdname
*            object                  = lst_header-tdobject
*          TABLES
*            lines                   = li_lines
*          EXCEPTIONS
*            id                      = 1
*            language                = 2
*            name                    = 3
*            not_found               = 4
*            object                  = 5
*            reference_check         = 6
*            wrong_access_to_archive = 7
*            OTHERS                  = 8.
*        IF sy-subrc <> 0.
*        ENDIF.
**    ELSE.
**** For Creation mode Sales document number will not be generated by the time, so passing XXXXXXXXXX in run time to tdname
**      IF lst_header-tdname IS INITIAL.
**        lst_header-tdname = VALUE #( xthead[ tdid = lv_tdid ]-tdname OPTIONAL  ).
**      ENDIF.
**    ENDIF.
*
*        IF li_lines[] IS NOT INITIAL.
*          lst_lines-tdformat = lc_asterisk.
*          APPEND lst_lines TO li_lines.
*          CLEAR: lst_lines.
*        ELSE.
*          lv_insert = abap_true.
*        ENDIF.
*
*        "Updating change reason
*        LOOP AT li_ch_text INTO lst_ch_text.
*          lst_lines-tdformat = lc_asterisk.
*          lst_lines-tdline   = lst_ch_text.
*          APPEND lst_lines TO li_lines.
*          CLEAR: lst_lines.
*        ENDLOOP.
*
*        "Updating User details who is reponsible for the changes made
*        CONCATENATE sy-uname lc_colon sy-datum sy-uzeit INTO DATA(lv_usr_info) SEPARATED BY space.
*        lst_lines-tdformat = lc_asterisk.
*        lst_lines-tdline = lv_usr_info.
*        APPEND lst_lines TO li_lines.
*        CLEAR: lst_lines.
*
*        "Calling FM to save the text
*        CALL FUNCTION 'SAVE_TEXT'
*          EXPORTING
*            client          = sy-mandt
*            header          = lst_header
**           insert          = lv_insert
*            savemode_direct = abap_true
*          IMPORTING
*            function        = lv_function
*            newheader       = lst_header
*          TABLES
*            lines           = li_lines
*          EXCEPTIONS
*            id              = 1
*            language        = 2
*            name            = 3
*            object          = 4
*            OTHERS          = 5.
*        IF sy-subrc = 0.
**              MESSAGE 'Reason for the change was noted' TYPE 'S'.
*        ENDIF. "IF sy-subrc = 0.
*      ELSE.
*        MESSAGE e276(zqtc_r2).
*      ENDIF."IF li_ch_text IS NOT INITIAL.
*
*    ENDIF.
*  ENDIF.
** EOC VCHITTIBAL
ENDFUNCTION.
