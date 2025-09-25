*&----------------------------------------------------------------------------*
*&  Include           ZQTCN_UPDATE_REASON_FOR_CHANGE
*&----------------------------------------------------------------------------*
*-----------------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_UPDATE_REASON_FOR_CHANGE (Include)              *
*                       Called from "USEREXIT_SAVE_DOC_PREP(MV45AFZZ)"        *
* PROGRAM DESCRIPTION : When any change is made to Contract/Order/Quotation,  *
*                       then display a popup to provide reason for change.    *
* DEVELOPER           : Nageswara Polina(NPOLINA)                             *
* CREATION DATE       : 09-Feb-2023                                           *
* OBJECT ID           : E375(OTCM-49269)                                      *
* TRANSPORT NUMBER(S) : ED2K929792                                            *
*-----------------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO : ED2K932242
* REFERENCE NO: OTCM-77829
* DEVELOPER   : Vishnuvardhan Reddy(VCHITTIBAL)
* DATE        : 22/SEP/2023
* DESCRIPTION : Reason for change popup should be enabled for Credit Memo as well
*               ZCR & ZHCR
*------------------------------------------------------------------------------*

    "Types Declarations
    TYPES: BEGIN OF lty_const_e375,
             devid    TYPE zdevid,              "Development ID
             param1   TYPE rvari_vnam,          "Parameter1
             param2   TYPE rvari_vnam,          "Parameter2
             srno     TYPE tvarv_numb,          "Serial Number
             sign     TYPE tvarv_sign,          "Sign
             opti     TYPE tvarv_opti,          "Option
             low      TYPE salv_de_selopt_low,  "Low
             high     TYPE salv_de_selopt_high, "High
             activate TYPE zconstactive,        "Active/Inactive Indicator
           END OF lty_const_e375.


    "Local Data Declarations
    DATA: li_const_tab_e375 TYPE TABLE OF lty_const_e375,   "Internal table for const data
*          lst_header        TYPE thead,                     "Header for text creattion/updation
          lv_vbeln1         TYPE vbak-vbeln,                "Sales Document
*          li_lines          TYPE TABLE OF tline,            "Text lines
          lst_lines         TYPE tline,                     "work area for text lines
          li_ch_text        TYPE catsxt_longtext_itab,      "table to store pop up text
          lst_ch_text       TYPE char72,                    "work area for popup text
          lv_vkbur          TYPE vkbur,                     "Sales Office
          lv_insert         TYPE c,                         "Insert flag
          lv_function       TYPE c,                         "Function: Insert
          lr_sysid          TYPE RANGE OF syst-sysid,       "System ID
          lv_tdid           TYPE char4.                     "Text ID

    "Local Constant declarations
    CONSTANTS: lc_devid_e375   TYPE zdevid VALUE 'E375',                "Development ID
               lc_sales_office TYPE char5  VALUE 'VKBUR',               "Sales Office
               lc_trans_code   TYPE char5  VALUE 'TCODE',               "Transaction Code
               lc_sd_doc_cat   TYPE char5  VALUE 'VBTYP',               "SD doc cat
               lc_tdid         TYPE char4  VALUE 'TDID',                "Text ID
               lc_system       TYPE char6  VALUE 'SYSTEM',              "System
               lc_tdobject     TYPE char4  VALUE 'VBBK',                "Text Object
               lc_mode         TYPE c      VALUE 'V',                   "Change Mode
               lc_trans_va02   TYPE char4  VALUE 'VA02',                "Tcode
               lc_trans_va22   TYPE char4  VALUE 'VA22',                "Tcode
               lc_trans_va42   TYPE char4  VALUE 'VA42',                "Tcode
               lc_call_prgm    TYPE char8  VALUE 'SAPMV45A',            "Calling Program
               lc_title        TYPE sytitle VALUE 'Reason for Change',  "title text
               lc_asterisk     TYPE c       VALUE '*',                  "Asterisk(*)
               lc_colon        TYPE c       VALUE ':',                  "Colon(:)
               lc_err_msg      TYPE c       VALUE 'E'.

    "Range declarations
    RANGES: lr_vkbur FOR vbak-vkbur,
            lr_vbtyp FOR vbak-vbtyp,
            lr_tcode FOR syst-tcode.

*    IF t180-trtyp = lc_mode.

    "Foreground changes only
    IF sy-batch  IS INITIAL AND
       sy-binpt  IS INITIAL AND
       call_bapi IS INITIAL AND
       sy-cprog  EQ lc_call_prgm.

      "Fetch constant table data
      SELECT devid
             param1
             param2
             srno
             sign
             opti
             low
             high
             activate
        FROM zcaconstant
        INTO TABLE li_const_tab_e375
        WHERE devid    = lc_devid_e375 AND
              activate = abap_true.
*
      IF sy-subrc IS INITIAL.
        SORT li_const_tab_e375 BY param1 srno.
** Begin of Changes by Vishnuvarhan Reddy(VCHITTIBAL) on 22/SEP/2023 - OTCM-77829 - ED2K932242
** Code commented and implemented the same functionality with OTCM-77829
*          LOOP AT li_const_tab_e375 INTO DATA(lst_const_e375).
*            CASE lst_const_e375-param1.
*              WHEN lc_sales_office.    "Sales Office(VKBUR)
*                APPEND INITIAL LINE TO lr_vkbur ASSIGNING FIELD-SYMBOL(<lfs_vkbur>).
*                IF <lfs_vkbur> IS ASSIGNED.
*                  <lfs_vkbur>-sign   = lst_const_e375-sign.
*                  <lfs_vkbur>-option = lst_const_e375-opti.
*                  <lfs_vkbur>-low    = lst_const_e375-low.
*                  <lfs_vkbur>-high   = lst_const_e375-high.
*                  UNASSIGN <lfs_vkbur>.
*                ENDIF.
*              WHEN lc_trans_code.     "Transaction code(TCODE)
*                APPEND INITIAL LINE TO lr_tcode ASSIGNING FIELD-SYMBOL(<lfs_tcode>).
*                IF <lfs_tcode> IS ASSIGNED.
*                  <lfs_tcode>-sign   = lst_const_e375-sign.
*                  <lfs_tcode>-option = lst_const_e375-opti.
*                  <lfs_tcode>-low    = lst_const_e375-low.
*                  <lfs_tcode>-high   = lst_const_e375-high.
*                  UNASSIGN <lfs_tcode>.
*                ENDIF.
*              WHEN lc_sd_doc_cat.   "SD Document Category(VBTYP)
*                APPEND INITIAL LINE TO lr_vbtyp ASSIGNING FIELD-SYMBOL(<lfs_vbtyp>).
*                IF <lfs_vbtyp> IS ASSIGNED.
*                  <lfs_vbtyp>-sign   = lst_const_e375-sign.
*                  <lfs_vbtyp>-option = lst_const_e375-opti.
*                  <lfs_vbtyp>-low    = lst_const_e375-low.
*                  <lfs_vbtyp>-high   = lst_const_e375-high.
*                  UNASSIGN <lfs_vbtyp>.
*                ENDIF.
*              WHEN lc_tdid.       "TextId (TDID)
*                lv_tdid   = lst_const_e375-low.
*              WHEN lc_system.     "System ID (EP1/ED1/ED2/EQ1/EQ2/EQ3)
*                APPEND INITIAL LINE TO lr_sysid ASSIGNING FIELD-SYMBOL(<lfs_sysid>).
*                IF <lfs_sysid> IS ASSIGNED.
*                  <lfs_sysid>-sign   = lst_const_e375-sign.
*                  <lfs_sysid>-option = lst_const_e375-opti.
*                  <lfs_sysid>-low    = lst_const_e375-low.
*                  <lfs_sysid>-high   = lst_const_e375-high.
*                  UNASSIGN <lfs_sysid>.
*                ENDIF.
*              WHEN OTHERS.
*                "Do nothing.
*            ENDCASE.
*            CLEAR: lst_const_e375.
*          ENDLOOP.
*
      ENDIF. "IF sy-subrc IS INITIAL.
*
*        "Upon change in any Contract/Order/Quotation
*        IF ( lr_sysid[] IS NOT INITIAL AND sy-sysid IN lr_sysid ) AND
*           ( lr_tcode[] IS NOT INITIAL AND sy-tcode IN lr_tcode ).
*
*
*          REFRESH: li_lines.
*          CLEAR  : lv_vbeln1, lv_insert, lv_function.
*
*          lv_vbeln1 = vbak-vbeln.     "Sales document Number
*
*          IF ( lr_vkbur[] IS NOT INITIAL AND vbak-vkbur IN lr_vkbur ) AND     "Sales Office(VKBUR) = '0080' AND SD Doc cat(VBTYP) = B/C/G.
*             ( lr_vbtyp[] IS NOT INITIAL AND vbak-vbtyp IN lr_vbtyp ).
*
*            "Calling FM to have a popup that will allow user to provide reason for change
*            CALL FUNCTION 'CATSXT_SIMPLE_TEXT_EDITOR'
*              EXPORTING
*                im_title        = lc_title
*                im_start_column = 25
*                im_start_row    = 6
*              CHANGING
*                ch_text         = li_ch_text.
*            "If reason for change is provided
*            IF li_ch_text IS NOT INITIAL.
*
*              "Populate header data for text
*              lst_header-tdid      = lv_tdid.
*              lst_header-tdname    = lv_vbeln1.
*              lst_header-tdspras   = sy-langu.
*              lst_header-tdobject  = lc_tdobject.
*
*              "Calling FM to read the existing text
*              CALL FUNCTION 'READ_TEXT'
*                EXPORTING
*                  client                  = sy-mandt
*                  id                      = lst_header-tdid
*                  language                = lst_header-tdspras
*                  name                    = lst_header-tdname
*                  object                  = lst_header-tdobject
*                TABLES
*                  lines                   = li_lines
*                EXCEPTIONS
*                  id                      = 1
*                  language                = 2
*                  name                    = 3
*                  not_found               = 4
*                  object                  = 5
*                  reference_check         = 6
*                  wrong_access_to_archive = 7
*                  OTHERS                  = 8.
*              IF sy-subrc <> 0.
*              ENDIF.
*
*              IF li_lines[] IS NOT INITIAL.
*                lst_lines-tdformat = lc_asterisk.
*                APPEND lst_lines TO li_lines.
*                CLEAR: lst_lines.
*              ELSE.
*                lv_insert = abap_true.
*              ENDIF.
*
*              "Updating change reason
*              LOOP AT li_ch_text INTO lst_ch_text.
*                lst_lines-tdformat = lc_asterisk.
*                lst_lines-tdline   = lst_ch_text.
*                APPEND lst_lines TO li_lines.
*                CLEAR: lst_lines.
*              ENDLOOP.
*
*              "Updating User details who is reponsible for the changes made
*              CONCATENATE sy-uname lc_colon sy-datum sy-uzeit INTO DATA(lv_usr_info) SEPARATED BY space.
*              lst_lines-tdformat = lc_asterisk.
*              lst_lines-tdline = lv_usr_info.
*              APPEND lst_lines TO li_lines.
*              CLEAR: lst_lines.
*
*              "Calling FM to save the text
*              CALL FUNCTION 'SAVE_TEXT'
*                EXPORTING
*                  header    = lst_header
*                  insert    = lv_insert
*                IMPORTING
*                  function  = lv_function
*                  newheader = lst_header
*                TABLES
*                  lines     = li_lines
*                EXCEPTIONS
*                  id        = 1
*                  language  = 2
*                  name      = 3
*                  object    = 4
*                  OTHERS    = 5.
*              IF sy-subrc = 0.
**              MESSAGE 'Reason for the change was noted' TYPE 'S'.
*              ENDIF. "IF sy-subrc = 0.
*            ELSE.
*              MESSAGE e276(zqtc_r2).
*            ENDIF."IF li_ch_text IS NOT INITIAL.
*
*          ENDIF. "IF vbak-vkbur = '0080' AND vbak-vbtyp = 'B'/'C'/'G'
*
*        ENDIF. "IF sy-tcode = va02/va22/va42 AND t180-trtyp = lc_mode.
*
*      ENDIF."IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL.
*
*    ENDIF." IF t180-trtyp = lc_mode.
** End of Changes by Vishnuvarhan Reddy(VCHITTIBAL) on 22/SEP/2023 - OTCM-77829 - ED2K932242

*** BOC by VCHITTIBAL***

* Compressed text data without text name
      TYPES: BEGIN OF lty_stxl_raw,
               clustr TYPE stxl-clustr,
               clustd TYPE stxl-clustd,
             END OF lty_stxl_raw.

      TYPES: BEGIN OF lty_stxl,
               tdname TYPE stxl-tdname,
               clustr TYPE stxl-clustr,
               clustd TYPE stxl-clustd,
             END OF lty_stxl.

      DATA: lst_head     TYPE thead,                     "Header for text creattion/updation
            li_lines     TYPE TABLE OF tline,            "Text lines
            lt_stxh      TYPE STANDARD TABLE OF stxh,
            lt_stxl_raw  TYPE STANDARD TABLE OF lty_stxl_raw,
            lst_stxl_raw TYPE lty_stxl_raw,
            lt_tline     TYPE STANDARD TABLE OF tline,
            lst_stxl     TYPE lty_stxl.

      CONSTANTS: "lc_tdobject      TYPE char4  VALUE 'VBBK',                "Text Object
                 lc_fcode_ent(20) TYPE c    VALUE 'ENT1'.                     " FCODE


      lst_head-tdid      = '0004'.
      lst_head-tdname    = vbak-vbeln.
      lst_head-tdspras   = sy-langu.
      lst_head-tdobject  = lc_tdobject.


      "Calling FM to read the existing text
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = lst_head-tdid
          language                = lst_head-tdspras
          name                    = lst_head-tdname
          object                  = lst_head-tdobject
        TABLES
          lines                   = li_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
      ENDIF.

** Get the text data from Database
      SELECT SINGLE tdname clustr clustd
              INTO lst_stxl
              FROM stxl
              WHERE relid    = 'TX'          "standard text
                AND tdobject = lst_head-tdobject
                AND tdname   = lst_head-tdname
                AND tdid     = lst_head-tdid
                AND tdspras  = sy-langu.
      IF sy-subrc IS INITIAL.
*   decompress text
        CLEAR: lt_stxl_raw[], lt_tline[].
        lst_stxl_raw-clustr = lst_stxl-clustr.
        lst_stxl_raw-clustd = lst_stxl-clustd.
        APPEND lst_stxl_raw TO lt_stxl_raw.
** Convert the Raw data in to text internal table
        IMPORT tline = lt_tline FROM INTERNAL TABLE lt_stxl_raw.
        LOOP AT lt_tline INTO DATA(lst_tline).
          READ TABLE li_lines INTO lst_lines INDEX sy-tabix.
          IF sy-subrc IS INITIAL.
            IF lst_tline NE lst_lines.
              MESSAGE 'Please Dont change CS Credit Info existing text,Append the new text if any' TYPE 'I' DISPLAY LIKE 'E'.
              PERFORM folge_gleichsetzen(saplv00f).
              fcode = lc_fcode_ent.
              SET SCREEN syst-dynnr.
              LEAVE SCREEN.
            ENDIF.
          ENDIF.
        ENDLOOP.

      ENDIF.
      CLEAR lst_stxl.


** Begin of Changes by Vishnuvarhan Reddy(VCHITTIBAL) on 22/SEP/2023 - OTCM-77829 - ED2K932242
      CONSTANTS:lc_underscore  TYPE c     VALUE '_',    "Underscore
                lc_so          TYPE char2 VALUE 'SO',   "Sales Office
                lc_create_mode TYPE c     VALUE 'H'.    "Create Mode.

      DATA:lv_param1 TYPE rvari_vnam,  "Parameter1
           lv_param2 TYPE rvari_vnam.  "Parameter2

      lv_param1    = |{ sy-tcode }| & |{ lc_underscore }| & |{ vbak-vbtyp }|.
      lv_param2    = |{ lc_so }|    & |{ lc_underscore }| & |{ vbak-vkbur }|.

      CLEAR lv_tdid.
** Check if any entry exists in Constant table with  Tcode,Document Category & Sales Office Combination,
** If Yes then proceed..
      lv_tdid = VALUE #( li_const_tab_e375[ param1 = lv_param1
                                            param2 = lv_param2 ]-low OPTIONAL  ).
*      IF lv_tdid IS NOT INITIAL.
*
*        IF t180-trtyp = lc_mode OR t180-trtyp = lc_create_mode.
*          REFRESH: li_lines.
*          CLEAR  : lv_vbeln1, lv_insert, lv_function.
*
*          lv_vbeln1 = vbak-vbeln.     "Sales document Numbe
*
*          Calling FM to have a popup that will allow user to provide reason for change
*          CALL FUNCTION 'CATSXT_SIMPLE_TEXT_EDITOR'
*            EXPORTING
*              im_title        = lc_title
*              im_start_column = 25
*              im_start_row    = 6
*            CHANGING
*              ch_text         = li_ch_text.
*          If reason for change is provided
*          IF li_ch_text IS NOT INITIAL.
*
*            Populate header data for text
*            lst_header-tdid      = lv_tdid.
*            lst_header-tdname    = lv_vbeln1.
*            lst_header-tdspras   = sy-langu.
*            lst_header-tdobject  = lc_tdobject.
*
*            IF t180-trtyp = lc_mode. "IF Change mode get the existing text if any
*              Calling FM to read the existing text
*              CALL FUNCTION 'READ_TEXT'
*                EXPORTING
*                  client                  = sy-mandt
*                  id                      = lst_header-tdid
*                  language                = lst_header-tdspras
*                  name                    = lst_header-tdname
*                  object                  = lst_header-tdobject
*                TABLES
*                  lines                   = li_lines
*                EXCEPTIONS
*                  id                      = 1
*                  language                = 2
*                  name                    = 3
*                  not_found               = 4
*                  object                  = 5
*                  reference_check         = 6
*                  wrong_access_to_archive = 7
*                  OTHERS                  = 8.
*              IF sy-subrc <> 0.
*              ENDIF.
*            ELSE.
* For Creation mode Sales document number will not be generated by the time, so passing XXXXXXXXXX in run time to tdname
*              IF lst_header-tdname IS INITIAL.
*                lst_header-tdname = VALUE #( xthead[ tdid = lv_tdid ]-tdname OPTIONAL  ).
*              ENDIF.
*            ENDIF.
*
*            IF li_lines[] IS NOT INITIAL.
*              lst_lines-tdformat = lc_asterisk.
*              APPEND lst_lines TO li_lines.
*              CLEAR: lst_lines.
*            ELSE.
*              lv_insert = abap_true.
*            ENDIF.
*
*            Updating change reason
*            LOOP AT li_ch_text INTO lst_ch_text.
*              lst_lines-tdformat = lc_asterisk.
*              lst_lines-tdline   = lst_ch_text.
*              APPEND lst_lines TO li_lines.
*              CLEAR: lst_lines.
*            ENDLOOP.
*
*            Updating User details who is reponsible for the changes made
*            CONCATENATE sy-uname lc_colon sy-datum sy-uzeit INTO DATA(lv_usr_info) SEPARATED BY space.
*            lst_lines-tdformat = lc_asterisk.
*            lst_lines-tdline = lv_usr_info.
*            APPEND lst_lines TO li_lines.
*            CLEAR: lst_lines.
*
*            Calling FM to save the text
*            CALL FUNCTION 'SAVE_TEXT'
*              EXPORTING
*                header    = lst_header
*                insert    = lv_insert
*              IMPORTING
*                function  = lv_function
*                newheader = lst_header
*              TABLES
*                lines     = li_lines
*              EXCEPTIONS
*                id        = 1
*                language  = 2
*                name      = 3
*                object    = 4
*                OTHERS    = 5.
*            IF sy-subrc = 0.
*              MESSAGE 'Reason for the change was noted' TYPE 'S'.
*            ENDIF. "IF sy-subrc = 0.
*          ELSE.
*            MESSAGE e276(zqtc_r2).
*          ENDIF."IF li_ch_text IS NOT INITIAL.
*
*        ENDIF. " For Creation/Change Mode
*    ENDIF. "IF lv_tdid IS NOT INITIAL.
    ENDIF. "Foreground changes only
** End of Changes by Vishnuvarhan Reddy(VCHITTIBAL) on 22/SEP/2023 - OTCM-77829 - ED2K932242


** BOC New Requirement **

    IF lv_tdid IS NOT INITIAL.
**      Populate header data for text
      lst_header-tdid      = lv_tdid.
      lst_header-tdname    = lv_vbeln1.
      lst_header-tdspras   = sy-langu.
      lst_header-tdobject  = lc_tdobject.

      lv_vbeln1 = vbak-vbeln.     "Sales document Number

** For Creation mode Sales document number will not be generated by the time, so passing XXXXXXXXXX in run time to tdname
      IF lst_header-tdname IS INITIAL.
        lst_header-tdname = VALUE #( xthead[ tdid = lv_tdid ]-tdname OPTIONAL  ).
      ENDIF.

      "Calling FM to read the existing text
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = lst_header-tdid
          language                = lst_header-tdspras
          name                    = lst_header-tdname
          object                  = lst_header-tdobject
        TABLES
          lines                   = li_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
      ENDIF.

      IF t180-trtyp = lc_create_mode.
        IF li_lines[] IS INITIAL.
          "Calling FM to have a popup that will allow user to provide reason for change
          CALL FUNCTION 'CATSXT_SIMPLE_TEXT_EDITOR'
            EXPORTING
              im_title        = lc_title
              im_start_column = 25
              im_start_row    = 6
            CHANGING
              ch_text         = li_ch_text.

          "If reason for change is provided
          IF li_ch_text IS NOT INITIAL.

            "Populate header data for text
            lst_header-tdid      = lv_tdid.
            lst_header-tdname    = lv_vbeln1.
            lst_header-tdspras   = sy-langu.
            lst_header-tdobject  = lc_tdobject.

** For Creation mode Sales document number will not be generated by the time, so passing XXXXXXXXXX in run time to tdname
            IF lst_header-tdname IS INITIAL.
              lst_header-tdname = VALUE #( xthead[ tdid = lv_tdid ]-tdname OPTIONAL  ).
            ENDIF.

            lv_insert = abap_true.

            "Updating change reason
            LOOP AT li_ch_text INTO lst_ch_text.
              lst_lines-tdformat = lc_asterisk.
              lst_lines-tdline   = lst_ch_text.
              APPEND lst_lines TO li_lines.
              CLEAR: lst_lines.
            ENDLOOP.

            DATA:lv_date(10) TYPE c,
                 lv_time(8)  TYPE c.

            lv_date = |{ sy-datum+6(2) }| & | / | & |{ sy-datum+4(2) }| & | / | & |{ sy-datum+0(4) }| .
            lv_time = |{ sy-uzeit+0(2) }| & |{ lc_colon }| & |{ sy-uzeit+2(4) }| & |{ lc_colon }| & |{ sy-uzeit+4(2) }| .
            "Updating User details who is reponsible for the changes made
*            CONCATENATE sy-uname lc_colon sy-datum sy-uzeit INTO DATA(lv_usr_info) SEPARATED BY space.
            CONCATENATE sy-uname lc_colon lv_date lv_time INTO DATA(lv_usr_info) SEPARATED BY space.
            lst_lines-tdformat = lc_asterisk.
            lst_lines-tdline = lv_usr_info.
            APPEND lst_lines TO li_lines.
            CLEAR: lst_lines.

            "Calling FM to save the text
            CALL FUNCTION 'SAVE_TEXT'
              EXPORTING
                header    = lst_header
                insert    = lv_insert
              IMPORTING
                function  = lv_function
                newheader = lst_header
              TABLES
                lines     = li_lines
              EXCEPTIONS
                id        = 1
                language  = 2
                name      = 3
                object    = 4
                OTHERS    = 5.
            IF sy-subrc = 0.
*              MESSAGE 'Reason for the change was noted' TYPE 'S'.
            ENDIF. "IF sy-subrc = 0.
          ELSE.
            MESSAGE e276(zqtc_r2).
          ENDIF."IF li_ch_text IS NOT INITIAL.
        ELSE.
          "Updating User details who is reponsible for the changes made
          lv_date = |{ sy-datum+6(2) }| & |/| & |{ sy-datum+4(2) }| & |/| & |{ sy-datum+0(4) }| .
          lv_time = |{ sy-uzeit+0(2) }| & |{ lc_colon }| & |{ sy-uzeit+2(2) }| & |{ lc_colon }| & |{ sy-uzeit+4(2) }| .
          CONCATENATE sy-uname lc_colon lv_date lv_time INTO lv_usr_info SEPARATED BY space.

          lst_lines-tdformat = lc_asterisk.
          lst_lines-tdline = lv_usr_info.
          APPEND lst_lines TO li_lines.
          CLEAR: lst_lines.

          "Calling FM to save the text
          CALL FUNCTION 'SAVE_TEXT'
            EXPORTING
              header    = lst_header
              insert    = lv_insert
            IMPORTING
              function  = lv_function
              newheader = lst_header
            TABLES
              lines     = li_lines
            EXCEPTIONS
              id        = 1
              language  = 2
              name      = 3
              object    = 4
              OTHERS    = 5.
          IF sy-subrc = 0.
*              MESSAGE 'Reason for the change was noted' TYPE 'S'.
          ENDIF. "IF sy-subrc = 0.
        ENDIF.
      ELSEIF t180-trtyp = lc_mode.

** Get the text data from Database
        SELECT SINGLE tdname clustr clustd
                INTO lst_stxl
                FROM stxl
                WHERE relid    = 'TX'          "standard text
                  AND tdobject = lst_head-tdobject
                  AND tdname   = lst_head-tdname
                  AND tdid     = lst_head-tdid
                  AND tdspras  = sy-langu.
        IF sy-subrc IS INITIAL.
*   decompress text
          CLEAR: lt_stxl_raw[], lt_tline[].
          lst_stxl_raw-clustr = lst_stxl-clustr.
          lst_stxl_raw-clustd = lst_stxl-clustd.
          APPEND lst_stxl_raw TO lt_stxl_raw.
** Convert the Raw data in to text internal table
          IMPORT tline = lt_tline FROM INTERNAL TABLE lt_stxl_raw.

          LOOP AT lt_tline INTO lst_tline.
            READ TABLE li_lines INTO lst_lines INDEX sy-tabix.
            IF sy-subrc IS INITIAL AND lst_tline NE lst_lines.
              MESSAGE 'Please Dont change CS Credit Info existing text,Append the new text if any' TYPE 'I' DISPLAY LIKE 'E'.
              PERFORM folge_gleichsetzen(saplv00f).
              fcode = lc_fcode_ent.
              SET SCREEN syst-dynnr.
              LEAVE SCREEN.
            ENDIF.
          ENDLOOP.

          DATA:lv_db_count TYPE sy-tabix.
          DATA:lv_current_count TYPE sy-tabix.

          DESCRIBE TABLE lt_tline LINES lv_db_count.
          DESCRIBE TABLE li_lines LINES lv_current_count.

          IF lv_current_count LE lv_db_count.

            CLEAR  : lv_vbeln1, lv_insert, lv_function.

            lv_vbeln1 = vbak-vbeln.     "Sales document Number

            "Calling FM to have a popup that will allow user to provide reason for change
            CALL FUNCTION 'CATSXT_SIMPLE_TEXT_EDITOR'
              EXPORTING
                im_title        = lc_title
                im_start_column = 25
                im_start_row    = 6
              CHANGING
                ch_text         = li_ch_text.
            "If reason for change is provided
            IF li_ch_text IS NOT INITIAL.

              "Populate header data for text
              lst_header-tdid      = lv_tdid.
              lst_header-tdname    = lv_vbeln1.
              lst_header-tdspras   = sy-langu.
              lst_header-tdobject  = lc_tdobject.

              IF li_lines[] IS NOT INITIAL.
                CLEAR: lst_lines.
                lst_lines-tdformat = lc_asterisk.
                APPEND lst_lines TO li_lines.
                CLEAR: lst_lines.
              ENDIF.

              "Updating change reason
              LOOP AT li_ch_text INTO lst_ch_text.
                lst_lines-tdformat = lc_asterisk.
                lst_lines-tdline   = lst_ch_text.
                APPEND lst_lines TO li_lines.
                CLEAR: lst_lines.
              ENDLOOP.

              "Updating User details who is reponsible for the changes made
*              CONCATENATE sy-uname lc_colon sy-datum sy-uzeit INTO lv_usr_info SEPARATED BY space.
              lv_date = |{ sy-datum+6(2) }| & |/| & |{ sy-datum+4(2) }| & |/| & |{ sy-datum+0(4) }| .
              lv_time = |{ sy-uzeit+0(2) }| & |{ lc_colon }| & |{ sy-uzeit+2(2) }| & |{ lc_colon }| & |{ sy-uzeit+4(2) }| .
              CONCATENATE sy-uname lc_colon lv_date lv_time INTO lv_usr_info SEPARATED BY space.

              lst_lines-tdformat = lc_asterisk.
              lst_lines-tdline = lv_usr_info.
              APPEND lst_lines TO li_lines.
              CLEAR: lst_lines.

              "Calling FM to save the text
              CALL FUNCTION 'SAVE_TEXT'
                EXPORTING
                  header    = lst_header
                  insert    = lv_insert
                IMPORTING
                  function  = lv_function
                  newheader = lst_header
                TABLES
                  lines     = li_lines
                EXCEPTIONS
                  id        = 1
                  language  = 2
                  name      = 3
                  object    = 4
                  OTHERS    = 5.
              IF sy-subrc = 0.
*              MESSAGE 'Reason for the change was noted' TYPE 'S'.
              ENDIF. "IF sy-subrc = 0.
            ELSE.
              MESSAGE e276(zqtc_r2).
            ENDIF."IF li_ch_text IS NOT INITIAL.

          ELSE.

            "Updating User details who is reponsible for the changes made
            lv_date = |{ sy-datum+6(2) }| & |/| & |{ sy-datum+4(2) }| & |/| & |{ sy-datum+0(4) }| .
            lv_time = |{ sy-uzeit+0(2) }| & |{ lc_colon }| & |{ sy-uzeit+2(2) }| & |{ lc_colon }| & |{ sy-uzeit+4(2) }| .
            CONCATENATE sy-uname lc_colon lv_date lv_time INTO lv_usr_info SEPARATED BY space.

            lst_lines-tdformat = lc_asterisk.
            lst_lines-tdline = lv_usr_info.
            APPEND lst_lines TO li_lines.
            CLEAR: lst_lines.

            "Calling FM to save the text
            CALL FUNCTION 'SAVE_TEXT'
              EXPORTING
                header    = lst_header
                insert    = lv_insert
              IMPORTING
                function  = lv_function
                newheader = lst_header
              TABLES
                lines     = li_lines
              EXCEPTIONS
                id        = 1
                language  = 2
                name      = 3
                object    = 4
                OTHERS    = 5.
            IF sy-subrc = 0.
*              MESSAGE 'Reason for the change was noted' TYPE 'S'.
            ENDIF. "IF sy-subrc = 0.
          ENDIF.
        ENDIF.
        CLEAR lst_stxl.
      ENDIF.
    ENDIF.
** EOC New Requirement **
