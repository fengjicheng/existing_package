*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SEGMENT_FILL_I0229_09
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SEGMENT_FILL_I0229_09(FM)
* PROGRAM DESCRIPTION: Update ACTION field for Output Type ZOA2 bassed on
*                      - Change to cancellation procedure filed (VEDA-VKUESCH)
*                      - Change Logs for specified table fields (ZCACONSTANT)
*                      - Changes to Texts (ZCACONSTANT)
*                      - Changes maintained in SLG1 logs
*                        logs created in pgms ZQTCN_MEDIA_SUSPEN_SAVE_I0229
*                                             ZQTCN_MEDIA_SUSPEN_SPRE_I0229
* DEVELOPER          : Nikhilesh Palla (NPALLA)
* CREATION DATE      : 2021-09-21
* OBJECT ID          : I0229 (OTCM-40685)
* TRANSPORT NUMBER(S): ED2K924568 / ED2K924909
*----------------------------------------------------------------------*

TYPES: BEGIN OF lty_nast_09,
         objky TYPE nast-objky,
         kschl TYPE nast-kschl,
         datvr TYPE nast-datvr,
         uhrvr TYPE nast-uhrvr,
       END OF lty_nast_09.
DATA: li_nast_09 TYPE STANDARD TABLE OF lty_nast_09.
DATA: lst_nast_09 TYPE lty_nast_09.
TYPES: BEGIN OF lty_cdhdr_09,
         objectclas TYPE cdhdr-objectclas,
         objectid   TYPE cdhdr-objectid,
         changenr   TYPE cdhdr-changenr,
         udate      TYPE cdhdr-udate,
         utime      TYPE cdhdr-utime,
         tcode      TYPE cdhdr-tcode,
       END OF lty_cdhdr_09.
DATA: li_cdhdr_09 TYPE STANDARD TABLE OF lty_cdhdr_09.
DATA: lst_cdhdr_09 TYPE lty_cdhdr_09.

TYPES: BEGIN OF lty_cdpos_09,
         objectid  TYPE cdpos-objectid,
         changenr  TYPE cdpos-changenr,
         tabname   TYPE cdpos-tabname,
         tabkey    TYPE cdpos-tabkey,
         fname     TYPE cdpos-fname,
         value_new TYPE cdpos-value_new,
         value_old TYPE cdpos-value_old,
       END OF lty_cdpos_09.
DATA: li_cdpos_09 TYPE STANDARD TABLE OF lty_cdpos_09.
DATA: lst_cdpos_09 TYPE lty_cdpos_09.

TYPES: BEGIN OF lty_stxh_09,
         tdobject TYPE stxh-tdobject,
         tdname   TYPE stxh-tdname,
         tdid     TYPE stxh-tdid,
         tdspras  TYPE stxh-tdspras,
         tdldate  TYPE stxh-tdldate,
         tdltime  TYPE stxh-tdltime,
       END OF lty_stxh_09.
DATA: li_stxh_09 TYPE STANDARD TABLE OF lty_stxh_09.
DATA: lst_stxh_09 TYPE lty_stxh_09.

* Range for Table Fields
TYPES: BEGIN OF lty_table_fld,
         sign   TYPE zcaconstant-sign,
         option TYPE zcaconstant-opti,
         low    TYPE zcaconstant-low,
         high   TYPE zcaconstant-high,
       END OF lty_table_fld.
* Range for KSCHL
TYPES: BEGIN OF ty_kschl,
         sign   TYPE tvarv_sign,
         option TYPE tvarv_opti,
         low    TYPE kschl,
         high   TYPE kschl,
       END OF ty_kschl.
* Range for Cancellation Procedue
TYPES: BEGIN OF ty_cancel_proc,
         sign   TYPE tvarv_sign,
         option TYPE tvarv_opti,
         low    TYPE vkues_veda,
         high   TYPE vkues_veda,
       END OF ty_cancel_proc.
*
TYPES: BEGIN OF lty_vbap_msg_key,
         vbeln TYPE vbap-vbeln,
         posnr TYPE vbap-posnr,
       END OF lty_vbap_msg_key.
DATA: lst_vbap_msg_key TYPE lty_vbap_msg_key.
STATICS: li_vbap_msg_key TYPE STANDARD TABLE OF lty_vbap_msg_key.
DATA: lst_msg_09        TYPE bal_s_msg.
DATA: lst_msg_handle    TYPE balmsghndl.
DATA: li_log_handle     TYPE bal_t_logh.
DATA: lv_flag_exit      TYPE xchar.
DATA: lst_msg           TYPE bal_s_msg.
DATA: lv_msg_handle     TYPE balmsghndl.
DATA: lst_09_e1edp01    TYPE e1edp01. " IDoc: Document Item General Data
*
STATICS: lir_flds_vbak TYPE STANDARD TABLE OF lty_table_fld.
STATICS: lir_flds_vbap TYPE STANDARD TABLE OF lty_table_fld.
STATICS: lir_flds_vbkd TYPE STANDARD TABLE OF lty_table_fld.
STATICS: lir_flds_vbpa TYPE STANDARD TABLE OF lty_table_fld.
STATICS: lir_flds_veda TYPE STANDARD TABLE OF lty_table_fld.
STATICS: lir_tdid      TYPE STANDARD TABLE OF lty_table_fld.
STATICS: lir_parvw     TYPE STANDARD TABLE OF lty_table_fld.
STATICS: lir_kschl     TYPE STANDARD TABLE OF ty_kschl.
STATICS: lir_cancel_proc TYPE STANDARD TABLE OF ty_cancel_proc.
STATICS: lir_cancel_proc_old TYPE STANDARD TABLE OF ty_cancel_proc.
*
FIELD-SYMBOLS: <lfs_table_fld> TYPE lty_table_fld.
FIELD-SYMBOLS: <lfs_tdid>      TYPE lty_table_fld.
FIELD-SYMBOLS: <lfs_parvw>     TYPE lty_table_fld.
FIELD-SYMBOLS: <lfs_edidd>     TYPE edidd.
*
DATA: lv_action_flg TYPE xflag.
DATA: lv_action_flg_003 TYPE xflag.
DATA: lv_text_09    TYPE thead-tdname.
DATA: lv_tdname_09  TYPE tdobname.
DATA: lv_log_handle TYPE balhdr-log_handle.
DATA: lv_extnumber  TYPE balhdr-extnumber.
DATA: lv_extnumber_old  TYPE balhdr-extnumber.
DATA: lv_line_09    TYPE sy-tabix.
*
CONSTANTS: lc_x         TYPE char1      VALUE 'X',
           lc_v1        TYPE nast-kappl VALUE 'V1',
           lc_zoa2      TYPE nast-kschl VALUE 'ZOA2',
           lc_va42      TYPE nast-kschl VALUE 'VA42',
           lc_vbbp      TYPE nast-kschl VALUE 'VBBP',
           lc_vbak      TYPE char4      VALUE 'VBAK',
           lc_vbap      TYPE char4      VALUE 'VBAP',
           lc_vbkd      TYPE char4      VALUE 'VBKD',
           lc_vbpa      TYPE char4      VALUE 'VBPA',
           lc_veda      TYPE char4      VALUE 'VEDA',
           lc_kschl     TYPE char5      VALUE 'KSCHL',
           lc_i0229_09  TYPE zdevid     VALUE 'I0229',
           lc_table     TYPE rvari_vnam VALUE 'TABLE',
           lc_object_09 TYPE balobj_d   VALUE 'ZQTC',   " Application Log: Object Name (Application Code)
           lc_subobj_09 TYPE balsubobj  VALUE 'ZORD_CHG_ALM',
           lc_tdid      TYPE char4      VALUE 'TDID',
           lc_parvw     TYPE char5      VALUE 'PARVW',
           lc_vkuesch   TYPE char7      VALUE 'VKUESCH',
           lc_vkuesch_old TYPE char11      VALUE 'VKUESCH_OLD'. "Cancellation Procedure

* Get Details from ZCACONSTANT Table
IF lir_flds_vbap[] IS INITIAL AND
   lir_flds_vbkd[] IS INITIAL AND
   lir_flds_vbpa[] IS INITIAL AND
   lir_flds_veda[] IS INITIAL AND
   lir_parvw[]     IS INITIAL AND
   lir_tdid[]      IS INITIAL AND
   lir_cancel_proc[] IS INITIAL.
  SELECT devid,
         param1,
         param2,
         srno,
         sign,
         opti,
         low,
         high,
         activate
  INTO TABLE @DATA(li_zcaconstant_09)
  FROM zcaconstant
    WHERE devid    = @lc_i0229_09
      AND activate = @lc_x.
  IF sy-subrc = 0.
    SORT li_zcaconstant_09 BY param1.
    LOOP AT li_zcaconstant_09 ASSIGNING FIELD-SYMBOL(<lfs_constant_09>). "WHERE param1 = lc_table.
      IF <lfs_constant_09>-param1 = lc_table.
        CASE <lfs_constant_09>-param2.
          WHEN lc_vbak.
            APPEND INITIAL LINE TO lir_flds_vbak ASSIGNING <lfs_table_fld>.
            <lfs_table_fld>-sign = <lfs_constant_09>-sign.
            <lfs_table_fld>-option = <lfs_constant_09>-opti.
            <lfs_table_fld>-low =  <lfs_constant_09>-low.
            <lfs_table_fld>-high = <lfs_constant_09>-high.
          WHEN lc_vbap.
            APPEND INITIAL LINE TO lir_flds_vbap ASSIGNING <lfs_table_fld>.
            <lfs_table_fld>-sign = <lfs_constant_09>-sign.
            <lfs_table_fld>-option = <lfs_constant_09>-opti.
            <lfs_table_fld>-low =  <lfs_constant_09>-low.
            <lfs_table_fld>-high = <lfs_constant_09>-high.
          WHEN lc_vbkd.
            APPEND INITIAL LINE TO lir_flds_vbkd ASSIGNING <lfs_table_fld>.
            <lfs_table_fld>-sign = <lfs_constant_09>-sign.
            <lfs_table_fld>-option = <lfs_constant_09>-opti.
            <lfs_table_fld>-low =  <lfs_constant_09>-low.
            <lfs_table_fld>-high = <lfs_constant_09>-high.
          WHEN lc_vbpa.
            APPEND INITIAL LINE TO lir_flds_vbpa ASSIGNING <lfs_table_fld>.
            <lfs_table_fld>-sign = <lfs_constant_09>-sign.
            <lfs_table_fld>-option = <lfs_constant_09>-opti.
            <lfs_table_fld>-low =  <lfs_constant_09>-low.
            <lfs_table_fld>-high = <lfs_constant_09>-high.
          WHEN lc_veda.
            APPEND INITIAL LINE TO lir_flds_veda ASSIGNING <lfs_table_fld>.
            <lfs_table_fld>-sign = <lfs_constant_09>-sign.
            <lfs_table_fld>-option = <lfs_constant_09>-opti.
            <lfs_table_fld>-low =  <lfs_constant_09>-low.
            <lfs_table_fld>-high = <lfs_constant_09>-high.
        ENDCASE.
      ENDIF.
      IF <lfs_constant_09>-param1 = lc_parvw.
        APPEND INITIAL LINE TO lir_parvw ASSIGNING <lfs_parvw>.
        <lfs_parvw>-sign = <lfs_constant_09>-sign.
        <lfs_parvw>-option = <lfs_constant_09>-opti.
        <lfs_parvw>-low =  <lfs_constant_09>-low.
        <lfs_parvw>-high = <lfs_constant_09>-high.
      ENDIF.
      IF <lfs_constant_09>-param1 = lc_tdid.
        APPEND INITIAL LINE TO lir_tdid ASSIGNING <lfs_tdid>.
        <lfs_tdid>-sign = <lfs_constant_09>-sign.
        <lfs_tdid>-option = <lfs_constant_09>-opti.
        <lfs_tdid>-low =  <lfs_constant_09>-low.
        <lfs_tdid>-high = <lfs_constant_09>-high.
      ENDIF.
      IF <lfs_constant_09>-param1 = lc_kschl.
        APPEND INITIAL LINE TO lir_kschl ASSIGNING FIELD-SYMBOL(<lfs_kschl>).
        <lfs_kschl>-sign = <lfs_constant_09>-sign.
        <lfs_kschl>-option = <lfs_constant_09>-opti.
        <lfs_kschl>-low =  <lfs_constant_09>-low.
        <lfs_kschl>-high = <lfs_constant_09>-high.
      ENDIF.
      IF <lfs_constant_09>-param1 = lc_vkuesch.
        APPEND INITIAL LINE TO lir_cancel_proc ASSIGNING FIELD-SYMBOL(<lfs_cancel_proc>).
        <lfs_cancel_proc>-sign = <lfs_constant_09>-sign.
        <lfs_cancel_proc>-option = <lfs_constant_09>-opti.
        <lfs_cancel_proc>-low =  <lfs_constant_09>-low.
        <lfs_cancel_proc>-high = <lfs_constant_09>-high.
      ELSEIF <lfs_constant_09>-param1 = lc_vkuesch_old.
        APPEND INITIAL LINE TO lir_cancel_proc_old ASSIGNING FIELD-SYMBOL(<lfs_cancel_proc_old>).
        <lfs_cancel_proc_old>-sign = <lfs_constant_09>-sign.
        <lfs_cancel_proc_old>-option = <lfs_constant_09>-opti.
        <lfs_cancel_proc_old>-low =  <lfs_constant_09>-low.
        <lfs_cancel_proc_old>-high = <lfs_constant_09>-high.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDIF.

*** Describing IDOC Data Table
DESCRIBE TABLE int_edidd LINES lv_line_09.
*** Reading last record of IDOC Data Table
READ TABLE int_edidd ASSIGNING <lfs_edidd> INDEX lv_line_09.
IF sy-subrc = 0 AND dobject-kschl IN lir_kschl[]. "Execute only for Output Type ZOA2

*** Checking segments and implementing required logic
  CASE <lfs_edidd>-segnam.
    WHEN 'E1EDP01'.
*Logic to derive status in IDOC (E1EDP01-ACTION).
*      lst_09_e1edp01 = lst_edidd-sdata.
      lst_09_e1edp01 = <lfs_edidd>-sdata.

      CLEAR: lst_nast_09,
             lst_cdhdr_09,
             lv_action_flg.
*Pass the contract number to NAST-OBJKY where NAST-KSCHL = “ZOA2” and validate the entries.
*If entries are not found E1EDP01-ACTION derivation is not required.
      SELECT objky,
             kschl,
             datvr,
             uhrvr
        INTO TABLE @li_nast_09
        FROM nast
        WHERE kappl = @lc_v1
          AND objky = @dxvbak-vbeln
          AND kschl IN @lir_kschl[].   "lc_zoa2.
      IF sy-subrc = 0.
        SORT li_nast_09 BY datvr DESCENDING
                           uhrvr DESCENDING.
        READ TABLE li_nast_09 INTO lst_nast_09 INDEX 1.
*If entries are available, get time stamp (NAST-DATVR & NAST- UHRVR) for the latest processed output
*pass the contract number to CDHDR-OBJECTID where CDHDR-TCODE = “VA42” and get CDHDR-CHANGENR
*if CDHDR latest time stamp is greater than or equal to NAST time stamp.
        SELECT objectclas,
               objectid,
               changenr,
               udate,
               utime,
               tcode
          INTO TABLE @li_cdhdr_09
          FROM cdhdr
          WHERE objectid = @dxvbak-vbeln
            AND tcode    = @lc_va42
            AND ( ( udate GT @lst_nast_09-datvr ) OR
                  ( udate EQ @lst_nast_09-datvr AND
                    utime GE @lst_nast_09-uhrvr ) ).
        IF sy-subrc = 0.
          IF li_cdhdr_09[] IS NOT INITIAL.
            DATA: lv_pos_tabkey TYPE cdpos-tabkey.
            CONCATENATE sy-mandt
                        dxvbap-vbeln
                        dxvbap-posnr
                        INTO lv_pos_tabkey.
            CONDENSE lv_pos_tabkey.
            lv_pos_tabkey = '%' && lv_pos_tabkey && '%'.
            SELECT objectid,
                   changenr,
                   tabname,
                   tabkey,
                   fname,
                   value_new,
                   value_old
              INTO TABLE @li_cdpos_09
              FROM cdpos
              FOR ALL ENTRIES IN @li_cdhdr_09
              WHERE objectclas = @li_cdhdr_09-objectclas
                AND objectid   = @li_cdhdr_09-objectid
                AND changenr   = @li_cdhdr_09-changenr
                AND tabkey     LIKE @lv_pos_tabkey.
            IF sy-subrc = 0.
*Check if the CDPOS fileds are related to Cancellation Procedure.
              LOOP AT li_cdpos_09 INTO lst_cdpos_09.
                CASE lst_cdpos_09-tabname.
                  WHEN lc_veda.
                    IF lst_cdpos_09-fname = lc_vkuesch. "Cancellation Procedure
                      IF lst_cdpos_09-value_new IN lir_cancel_proc AND lir_cancel_proc[] IS NOT INITIAL.
                        "If Cancellation Procedure changed to Z001/Z002/Z003.
                        lv_action_flg_003 = lc_x.
                        EXIT.
                      ELSEIF ( lst_cdpos_09-value_new IN lir_cancel_proc_old AND lir_cancel_proc_old[] IS NOT INITIAL )
                         AND ( lst_cdpos_09-value_old IN lir_cancel_proc     AND lir_cancel_proc[] IS NOT INITIAL ).
                        "If Cancellation Procedure changed to 0001/0002 from Z001/Z002/Z003.
                        lv_action_flg = lc_x.
                        EXIT.
                      ENDIF.
                    ENDIF.
                  WHEN OTHERS.
                ENDCASE.
              ENDLOOP.
*Check if the CDPOS fileds are one among the fields (Table / Field) maintained in ZCACONSTANT.
              LOOP AT li_cdpos_09 INTO lst_cdpos_09.
                IF lv_action_flg IS NOT INITIAL OR lv_action_flg_003 IS NOT INITIAL.
                  EXIT.
                ENDIF.
*               Check for Line Item
                CASE lst_cdpos_09-tabname.
                  WHEN lc_vbak.
                    IF lst_cdpos_09-fname IN lir_flds_vbak[] AND lir_flds_vbak[] IS NOT INITIAL.
                      lv_action_flg = lc_x.
                    ENDIF.
                  WHEN lc_veda.
                    IF lst_cdpos_09-fname IN lir_flds_veda[] AND lir_flds_veda[] IS NOT INITIAL.
                      lv_action_flg = lc_x.
                    ENDIF.
                  WHEN lc_vbkd.
                    IF lst_cdpos_09-fname IN lir_flds_vbkd[] AND lir_flds_vbkd[] IS NOT INITIAL.
                      lv_action_flg = lc_x.
                    ENDIF.
                  WHEN lc_vbap.
                    IF lst_cdpos_09-fname IN lir_flds_vbap[] AND lir_flds_vbap[] IS NOT INITIAL.
                      lv_action_flg = lc_x.
                    ENDIF.
                  WHEN lc_vbpa.
                    IF lst_cdpos_09-fname IN lir_flds_vbpa[] AND lir_flds_vbpa[] IS NOT INITIAL. "'KEY'/ 'KUNNR'.
                      IF lst_cdpos_09-tabkey IN lir_parvw[] AND lir_parvw[] IS NOT INITIAL.
                        lv_action_flg = lc_x.
                      ENDIF.
                    ENDIF.
                  WHEN OTHERS.
                ENDCASE.
              ENDLOOP.
            ENDIF.
          ENDIF.
        ENDIF.

*   If Changes not done in CDHDR/CDPOS, Check for changes in Texts.
        IF lv_action_flg IS INITIAL AND lv_action_flg_003 IS INITIAL.
          CLEAR: lst_stxh_09.
          CONCATENATE dxvbap-vbeln dxvbap-posnr INTO lv_tdname_09.
          CONDENSE lv_tdname_09.
          SELECT tdobject,
                 tdname,
                 tdid,
                 tdspras,
                 tdldate,
                 tdltime
            INTO TABLE @li_stxh_09
            FROM stxh
            WHERE tdobject = @lc_vbbp
              AND tdname   = @lv_tdname_09
              AND tdid     IN @lir_tdid
              AND tdspras  = @sy-langu
              AND ( ( tdldate GT @lst_nast_09-datvr ) OR
                    ( tdldate EQ @lst_nast_09-datvr AND
                      tdltime GE @lst_nast_09-uhrvr ) ).
          IF sy-subrc = 0.
            lv_action_flg = lc_x.
          ENDIF.
        ENDIF.

*   If Changes not done in CDHDR/CDPOS and Texts, then check "JKSEINTERRUPT" Changes updated in SLG1 Logs
*   These Logs are updated in ZQTCN_MEDIA_SUSPEN_SAVE_I0229
        IF lv_action_flg IS INITIAL AND lv_action_flg_003 IS INITIAL.
          READ TABLE li_vbap_msg_key INTO lst_vbap_msg_key WITH KEY vbeln = dxvbak-vbeln.
          IF sy-subrc = 0. "READ TABLE li_vbap_msg_key
*             Read from VBAP logs
            READ TABLE li_vbap_msg_key INTO lst_vbap_msg_key WITH KEY vbeln = dxvbap-vbeln
                                                                      posnr = dxvbap-posnr
                                                                      BINARY SEARCH.
            IF sy-subrc = 0.
              lv_action_flg = abap_true.
            ENDIF.
          ELSE. "READ TABLE li_vbap_msg_key
*             Get VBAP logs
            lv_extnumber = '%' && dxvbak-vbeln && '%'.
            SELECT lognumber,
                   object,
                   subobject,
                   extnumber,
                   aldate,
                   altime,
                   aluser,
                   altcode,
                   log_handle
             FROM balhdr            " Application log: Header table
             INTO TABLE @DATA(li_balhdr)
             WHERE object     EQ @lc_object_09
               AND subobject  EQ @lc_subobj_09
               AND ( ( aldate GT @lst_nast_09-datvr ) OR
                     ( aldate EQ @lst_nast_09-datvr AND
                       altime GE @lst_nast_09-uhrvr ) )
               AND extnumber  LIKE @lv_extnumber.
            IF sy-subrc = 0.
*
              CLEAR: lv_log_handle,
                     li_log_handle[].
              LOOP AT li_balhdr ASSIGNING FIELD-SYMBOL(<lst_balhdr>).
                lv_log_handle = <lst_balhdr>-log_handle.   "LOG GUI ID
                APPEND lv_log_handle TO li_log_handle.

                CALL FUNCTION 'BAL_DB_LOAD'
                  EXPORTING
                    i_t_log_handle     = li_log_handle
                  EXCEPTIONS
                    no_logs_specified  = 1
                    log_not_found      = 2
                    log_already_loaded = 3
                    OTHERS             = 4.
                IF sy-subrc <> 0.
                  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
                ELSE.
                  CLEAR: lv_flag_exit,
                         lv_msg_handle.
                  WHILE lv_flag_exit IS INITIAL.
                    CLEAR:lst_msg.
                    lv_msg_handle-log_handle = lv_log_handle.
                    lv_msg_handle-msgnumber  = lv_msg_handle-msgnumber + 1 .
                    CALL FUNCTION 'BAL_LOG_MSG_READ'
                      EXPORTING
                        i_s_msg_handle = lv_msg_handle
                      IMPORTING
                        e_s_msg        = lst_msg
                      EXCEPTIONS
                        log_not_found  = 1
                        msg_not_found  = 2
                        OTHERS         = 3.
                    IF sy-subrc <> 0.
                      lv_flag_exit = abap_true.
                    ELSEIF sy-subrc = 0.
                      IF lst_msg IS NOT INITIAL.
                        lst_vbap_msg_key-vbeln = lst_msg-msgv1.
                        lst_vbap_msg_key-posnr = lst_msg-msgv2.
                        APPEND lst_vbap_msg_key TO li_vbap_msg_key.
                        CLEAR lst_vbap_msg_key.
                      ENDIF.
                    ENDIF.
                  ENDWHILE.
                ENDIF.
              ENDLOOP.
            ENDIF.
            SORT li_vbap_msg_key BY vbeln posnr.
            DELETE ADJACENT DUPLICATES FROM li_vbap_msg_key COMPARING vbeln posnr.
            READ TABLE li_vbap_msg_key INTO lst_vbap_msg_key WITH KEY vbeln = dxvbap-vbeln
                                                                      posnr = dxvbap-posnr
                                                                      BINARY SEARCH.
            IF sy-subrc = 0.
              lv_action_flg = abap_true.
            ENDIF.
          ENDIF. "READ TABLE li_vbap_msg_key
        ENDIF.
* If Action Flag is set, update IDoc Segment
        IF lv_action_flg = lc_x.
          lst_09_e1edp01-action = '002'.
          <lfs_edidd>-sdata  = lst_09_e1edp01.
        ELSEIF lv_action_flg_003 = lc_x.
          lst_09_e1edp01-action = '003'.
          <lfs_edidd>-sdata  = lst_09_e1edp01.
        ENDIF.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.

ENDIF.
