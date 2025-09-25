*&---------------------------------------------------------------------*
*&  Include           LZQTC_TAXCALF01
*&---------------------------------------------------------------------*
* PROGRAM DESCRIPTION : Include for TMG events subroutines             *
* DEVELOPER           : VMAMILLAPA (Vamsi Mamillapalli)                *
* CREATION DATE       : 2022-04-28                                     *
* OBJECT ID           : I0502.1/EAM-3116                               *
* TRANSPORT NUMBER(S) : ED2K926349                                     *
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_changed, "TD
*         INCLUDE TYPE zqtc_taxcal.
         mandt TYPE mandt,
         vkorg TYPE vkorg,
         vtweg TYPE vtweg,
         spart TYPE spart,
         mvgr4 TYPE mvgr4,
         datab TYPE kodatab,
         datbi TYPE datbi,
         kbetr TYPE zkbetr_kond,
         aenam TYPE aenam,
         aedat TYPE aedat.
TYPES: chang_flag TYPE c.
TYPES: index TYPE char10.
TYPES: END OF ty_changed.

TYPES: ty_t_changed TYPE TABLE OF ty_changed. "TD

*Local constants
CONSTANTS: lc_new_entry TYPE char1 VALUE 'N',
           lc_upd_entry TYPE char1 VALUE 'U',
           lc_del_entry TYPE char1 VALUE 'D'. "TD
FORM f_on_save.

**Local data declarations
*  DATA: lv_tot_index TYPE sy-tabix,
*        lv_ext_index TYPE sy-tabix,
*        lv_changed   TYPE ty_changed, "TD
*        li_changed   TYPE TABLE OF ty_changed. "TD
*
*  DATA:lv_date TYPE sy-datum.
**Local field symbol declarations
*  FIELD-SYMBOLS: <lfs_record> TYPE any. " Work area for table
** BREAK-POINT.
**loop over the table contents
*  LOOP AT total.
*    lv_tot_index = sy-tabix.
*    CLEAR: lv_changed. "TD
** Assign the table header line to the work area
*    ASSIGN total TO <lfs_record>.
*
*    IF <action> = lc_new_entry OR <action> = lc_upd_entry OR <action> = lc_del_entry. "TD
**      IF strlen( <lfs_record> ) GE 41.
**        lv_changed-mandt = <lfs_record>+0(3).
**        lv_changed-vkorg = <lfs_record>+3(4).
**        lv_changed-vtweg = <lfs_record>+7(2).
**        lv_changed-spart = <lfs_record>+9(2).
**        lv_changed-mvgr4 = <lfs_record>+11(3).
**        lv_changed-datab = <lfs_record>+14(8).
**        lv_changed-datbi = <lfs_record>+22(8).
*        lv_changed = <VIM_TOTAL_STRUC>.
*MOVE-CORRESPONDING <VIM_TOTAL_STRUC> to lv_changed.
**        ASSIGN COMPONENT 8 OF STRUCTURE  <lfs_record> TO FIELD-SYMBOL(<lfs_kbetr>).
**        IF <lfs_kbetr> IS ASSIGNED.
**          lv_changed-kbetr =  <lfs_kbetr>.
**        ENDIF.
**      ENDIF.
**      IF strlen( <lfs_record> ) GE 61.
**        lv_changed-aenam = <lfs_record>+41(12).
**
**        lv_changed-aedat = <lfs_record>+53(8).
**      ENDIF.
*      lv_changed-chang_flag = <action>.
*      lv_changed-index = lv_tot_index.
*      APPEND lv_changed TO li_changed.
*    ENDIF.
*
*    IF <action> = lc_new_entry OR <action> = lc_upd_entry.      " New or updated entry
*      READ TABLE extract WITH KEY <vim_xtotal_key>.
*      IF sy-subrc = 0.
*        lv_ext_index = sy-tabix.
**
**        <lfs_record>+58(1)   = sy-langu.
**        ASSIGN COMPONENT 9 OF STRUCTURE  <lfs_record> TO FIELD-SYMBOL(<lfs_changedby>).
**        IF <lfs_changedby> IS ASSIGNED.
**         <lfs_changedby> =  sy-uname.
**        ENDIF.
**        ASSIGN COMPONENT 8 OF STRUCTURE  <lfs_record> TO FIELD-SYMBOL(<lfs_datechange>).
**        IF <lfs_datechange> IS ASSIGNED.
**          <lfs_datechange> =  sy-datum.
**        ENDIF.
**        <lfs_record>+41(12) = sy-uname.
**        <lfs_record>+53(8)  = sy-datum.
*        ASSIGN COMPONENT 'AENAM' OF STRUCTURE <VIM_TOTAL_STRUC> to FIELD-SYMBOL(<lfs_aenam>).
*        if <lfs_aenam> IS ASSIGNED.
*       <lfs_aenam> = sy-uname.
*        ENDIF.
*        ASSIGN COMPONENT 'AEDAT' OF STRUCTURE <VIM_TOTAL_STRUC> to FIELD-SYMBOL(<lfs_aedat>).
*        if <lfs_aedat> IS ASSIGNED.
*       <lfs_aedat> = sy-datum.
*        ENDIF.
**        <VIM_TOTAL_STRUC>-aedat = sy-datum.
**       Modify total table
*        MODIFY total FROM <lfs_record> INDEX lv_tot_index.
*
*        extract = <lfs_record>.
**       Modify extract table
*        MODIFY extract INDEX lv_ext_index.
*
*      ENDIF.
*    ENDIF.
*
*    ASSIGN total TO FIELD-SYMBOL(<lfs_record1>).
*    IF <lfs_record1> IS ASSIGNED.
*      IF <lfs_record1>+0(13) EQ <vim_cextract>+0(13)
*        AND ( <lfs_record1>+22(8) NE <vim_cextract>+22(8)
*           OR <lfs_record1>+14(8) NE <vim_cextract>+14(8) ).
*
*        lv_date =  <vim_cextract>+14(8).
*        lv_date = lv_date - 1.
*        <lfs_record1>+22(8) = lv_date.
**        <lfs_record1>+41(12) = sy-uname.
**        <lfs_record1>+53(8)  = sy-datum.
**        DATA(lv_len) =  strlen( <lfs_record1> ).
**        IF <lfs_record1>+lv_len(1) NE  'U'.
**        <lfs_record1>+lv_len(1) = 'U'.
**      ENDIF.
**         CONCATENATE 'U'  <lfs_extract1>  into <lfs_extract1> .
**         REPLACE 'UU' WITH 'U'  INTO <lfs_extract1>.
*        MODIFY total FROM <lfs_record1> INDEX lv_tot_index.
*      ENDIF.
*      UNASSIGN <lfs_record1>.
*    ENDIF.
*  ENDLOOP.
*
*  LOOP AT extract ASSIGNING FIELD-SYMBOL(<lfs_extract1>).
*    IF <lfs_extract1>+0(13) EQ <vim_cextract>+0(13) AND
*      ( <lfs_extract1>+22(8) NE <vim_cextract>+22(8) OR
*      <lfs_extract1>+14(8) NE <vim_cextract>+14(8) ).
*      lv_date =  <vim_cextract>+14(8).
*      lv_date = lv_date - 1.
*      <lfs_extract1>+22(8) = lv_date.
**      <lfs_extract1>+41(12) = sy-uname.
**      <lfs_extract1>+53(8)  = sy-datum.
**      lv_len =  strlen( <lfs_extract1> ).
**      lv_len = lv_len - 1.
**      IF <lfs_extract1>+lv_len(1) NE  'U'.
**        <lfs_extract1>+lv_len(1) = 'U'.
**      ENDIF.
**      CONCATENATE 'U' <lfs_extract1> INTO  <lfs_extract1>.
*      MODIFY extract FROM <lfs_extract1>.
*    ENDIF.
*  ENDLOOP.
*  PERFORM f_log_changes USING li_changed."TD

ENDFORM.   "F_ON_SAVE

FORM f_log_changes USING fp_i_changed TYPE ty_t_changed.

  DATA: l_log_handle  TYPE balloghndl,
        l_timestamp   TYPE tzntstmps,
        l_timezone    TYPE timezone VALUE 'UTC',
        l_str_log     TYPE bal_s_log,
        l_str_balmsg  TYPE bal_s_msg,
        li_str_balmsg TYPE bal_t_msg,
        l_str_message TYPE bapiret2,
        l_msg_logged  TYPE boolean,
        l_s_par       TYPE bal_s_par,
        l_record      TYPE zqtc_taxcal,
        lv_reason     TYPE zreason_chg,
        li_long       TYPE gpp_html_lines,
        lv_txtcount   TYPE char10,
        lv_txtline    TYPE char20.
**** Fetching original values of update records ******
  DATA(li_updated) = fp_i_changed.
  DELETE li_updated WHERE chang_flag NE lc_upd_entry.

  CONSTANTS: lc_obj     TYPE balobj_d  VALUE 'ZQTC',
             lc_sub_obj TYPE balsubobj VALUE 'ZAPL_PRICING',
             lc_msgty   TYPE symsgty   VALUE 'S',
             lc_msgid   TYPE symsgid   VALUE 'ZCA',
             lc_updmsg  TYPE symsgno   VALUE '006',
             lc_cremsg  TYPE symsgno   VALUE '007',
             lc_delmsg  TYPE symsgno   VALUE '008',
             lc_table   TYPE symsgv    VALUE 'ZQTC_TAXCAL',
             lc_etext   TYPE baltext   VALUE 'ZQTC_TAXCAL_MAINT_EDIT_TXT',
             lc_text    TYPE baltext   VALUE 'ZQTC_TAXCAL_MAINT_TXT'.

  SELECT  vkorg,
          vtweg,
          spart,
          mvgr4,
          datab,
          datbi,
          kbetr,
          aenam,
          aedat
    FROM zqtc_taxcal
    INTO TABLE @DATA(li_ori)
    FOR ALL ENTRIES IN @li_updated
    WHERE vkorg = @li_updated-vkorg
    AND vtweg = @li_updated-vtweg
    AND spart = @li_updated-spart
    AND mvgr4 = @li_updated-mvgr4
    AND datab = @li_updated-datab.

  SORT li_updated BY vkorg vtweg spart mvgr4 datab.
  SORT li_ori BY vkorg vtweg spart mvgr4 datab.

*-Create Log
  CONVERT DATE sy-datum TIME sy-uzeit
  INTO TIME STAMP l_timestamp TIME ZONE l_timezone.

  l_str_log-extnumber = l_timestamp.
  CONDENSE l_str_log-extnumber.
  l_str_log-object = lc_obj.
  l_str_log-subobject = lc_sub_obj.
  l_str_log-aldate_del = sy-datum + 5.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = l_str_log
    IMPORTING
      e_log_handle            = l_log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc EQ 0.
***** Appending to LOG ****************
    LOOP AT fp_i_changed ASSIGNING FIELD-SYMBOL(<fp_i_changed>).

      l_record = <fp_i_changed>.

      l_str_balmsg-msgty = lc_msgty.
      l_str_balmsg-msgid = lc_msgid.
      l_str_balmsg-msgv1 = sy-uname.
      l_str_balmsg-msgv2 = lc_table.
********* Add Message Parameters ***************
      l_s_par-parname  = 'MANDT'.                           "#EC NOTEXT
      l_s_par-parvalue = <fp_i_changed>-mandt.
      APPEND l_s_par TO l_str_balmsg-params-t_par.

      l_s_par-parname  = 'VKORG'.                           "#EC NOTEXT
      l_s_par-parvalue = <fp_i_changed>-vkorg.
      APPEND l_s_par TO l_str_balmsg-params-t_par.

      l_s_par-parname  = 'VTWEG'.                           "#EC NOTEXT
      l_s_par-parvalue = <fp_i_changed>-vtweg.
      APPEND l_s_par TO l_str_balmsg-params-t_par.

      l_s_par-parname  = 'SPART'.                           "#EC NOTEXT
      l_s_par-parvalue = <fp_i_changed>-spart.
      APPEND l_s_par TO l_str_balmsg-params-t_par.

      l_s_par-parname  = 'MVGR4'.                           "#EC NOTEXT
      l_s_par-parvalue = <fp_i_changed>-mvgr4.
      APPEND l_s_par TO l_str_balmsg-params-t_par.

      l_s_par-parname  = 'DATAB'.                           "#EC NOTEXT
      l_s_par-parvalue = <fp_i_changed>-datab.
      APPEND l_s_par TO l_str_balmsg-params-t_par.


      l_s_par-parname  = 'DATBI'.                           "#EC NOTEXT
      l_s_par-parvalue = <fp_i_changed>-datbi.
      APPEND l_s_par TO l_str_balmsg-params-t_par.


      l_s_par-parname  = 'KBETR'.                           "#EC NOTEXT
      l_s_par-parvalue = <fp_i_changed>-kbetr.
      APPEND l_s_par TO l_str_balmsg-params-t_par.

      l_s_par-parname  = 'AENAM'.                           "#EC NOTEXT
      l_s_par-parvalue = sy-uname.
      APPEND l_s_par TO l_str_balmsg-params-t_par.

      l_s_par-parname  = 'AEDAT'.                           "#EC NOTEXT
      l_s_par-parvalue = sy-datum.
      APPEND l_s_par TO l_str_balmsg-params-t_par.

      CASE <fp_i_changed>-chang_flag.
        WHEN lc_upd_entry.  "U
          l_str_balmsg-msgno = lc_updmsg.
******** Get Original record ****************
          READ TABLE li_ori ASSIGNING FIELD-SYMBOL(<lfs_ori>)
                            WITH KEY vkorg  = <fp_i_changed>-vkorg
                                     vtweg = <fp_i_changed>-vtweg
                                     spart = <fp_i_changed>-spart
                                     mvgr4   = <fp_i_changed>-mvgr4
                                     datab   = <fp_i_changed>-datab
                                     BINARY SEARCH.
********* Add message Parameters for Original record ****************
          IF <lfs_ori> IS ASSIGNED.

            l_s_par-parname  = 'TAX_OLD'.                   "#EC NOTEXT
            l_s_par-parvalue = <lfs_ori>-kbetr.
            APPEND l_s_par TO l_str_balmsg-params-t_par.

            l_s_par-parname  = 'AENAM_OLD'.                 "#EC NOTEXT
            l_s_par-parvalue = <lfs_ori>-aenam.
            APPEND l_s_par TO l_str_balmsg-params-t_par.

            l_s_par-parname  = 'AEDAT_OLD'.                 "#EC NOTEXT
            l_s_par-parvalue = <lfs_ori>-aedat.
            APPEND l_s_par TO l_str_balmsg-params-t_par.

            UNASSIGN <lfs_ori>.
          ENDIF.

          l_str_balmsg-params-altext = lc_etext.

        WHEN lc_new_entry.
          l_str_balmsg-msgno = lc_cremsg.
          l_str_balmsg-params-altext = lc_text.
        WHEN lc_del_entry.
          l_str_balmsg-msgno = lc_delmsg.
          l_str_balmsg-params-altext = lc_text.
      ENDCASE.

      LOOP AT li_long ASSIGNING FIELD-SYMBOL(<lf_long>).
        ADD 1 TO lv_txtcount.
        CONDENSE lv_txtcount.
        CONCATENATE 'LONG_TXT' lv_txtcount INTO lv_txtline.
        CONDENSE lv_txtline.
        l_s_par-parname  = lv_txtline.
        l_s_par-parvalue = <lf_long>.
        APPEND l_s_par TO l_str_balmsg-params-t_par.
      ENDLOOP.

      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle     = l_log_handle
          i_s_msg          = l_str_balmsg
        IMPORTING
          e_msg_was_logged = l_msg_logged
        EXCEPTIONS
          log_not_found    = 1
          msg_inconsistent = 2
          log_is_full      = 3
          OTHERS           = 4.
      IF sy-subrc NE 0.
      ENDIF.

      CLEAR:l_str_balmsg.

    ENDLOOP.

**************** Save Log *************
    IF sy-subrc EQ 0.
      CALL FUNCTION 'BAL_DB_SAVE'
        EXPORTING
          i_save_all       = abap_true
        EXCEPTIONS
          log_not_found    = 1
          save_not_allowed = 2
          numbering_error  = 3
          OTHERS           = 4.
      IF sy-subrc <> 0.
      ENDIF.
    ENDIF.

  ENDIF.

ENDFORM.
