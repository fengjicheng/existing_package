FUNCTION zscm_mi_wl_scrapping_e223.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IN_CHANGE_MODE) TYPE  XFELD DEFAULT ' '
*"     VALUE(IN_ISSUE_TAB) TYPE  ISMMATNR_ISSUETAB
*"----------------------------------------------------------------------
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916413
* REFERENCE NO: E223, ERPM# 835 (E223)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-16
* DESCRIPTION: Scrapping functionality
*----------------------------------------------------------------------*

* Local Data
  DATA: lv_xretail      TYPE xfeld,
        ls_attyp        TYPE attyp,
        ls_issue_matnr  TYPE ismmatnr_issue,
        lv_xerror       TYPE xfeld,
        lv_mark_count   TYPE sy-tabix,
        lv_xbatch_error TYPE xfeld,
        li_outtab_gf    TYPE string VALUE '(RJKSDWORKLIST)I_OUTTAB[]'.

  FIELD-SYMBOLS:
    <lfi_outtab>     TYPE lty_rjksdworklist_alv.

* Get Selected Media Issue Worklist
  ASSIGN (li_outtab_gf) TO <lfi_outtab>.
  IF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS NOT INITIAL.
* Call Material Scrapping from worklist
    LOOP AT <lfi_outtab> INTO DATA(lst_outtab).
      IF lst_outtab-matnr IS INITIAL.
        lst_outtab-matnr = lst_outtab-matnr_save.
      ENDIF.
      SELECT SINGLE attyp FROM mara INTO ls_attyp
             WHERE matnr = lst_outtab-matnr.
      IF sy-subrc <> 0.
        lv_xerror = abap_true.
        EXIT.
      ELSE.
        lv_mark_count = lv_mark_count + 1.
        APPEND ls_issue_matnr TO i_matnr_issue.
        IF NOT ls_attyp IS INITIAL.
          lv_xretail = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF. " IF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS NOT INITIAL.

  CHECK sy-subrc = 0  AND
        lv_xerror IS INITIAL.

* Info, wieviele Ausgaben markiert sind
  MESSAGE i317(zqtc_r2) WITH lv_mark_count.

* POPUP zur Eingabe des "Batchjob-Start-Datums" prozessieren
  PERFORM popup_fuer_batchjob
  CHANGING rjksd13-batch_startdate
           rjksd13-batch_starttime
           rjksd13-batch_startimmediate
           rjksd13-vkorg
           rjksd13-auart
           popup_status.

  IF popup_status EQ con_popupstatus_abort.
*   POPUP wurde mit F12  abgebrochen
    EXIT.                            "Sichern wurde abgebrochen
  ELSE.
    EXIT.
*    PERFORM ORDERGEN_BATCH
*        USING    RJKSD13-BATCH_STARTDATE
*                 RJKSD13-BATCH_STARTTIME
*                 RJKSD13-BATCH_STARTIMMEDIATE
*                 RJKSD13-VKORG
*                 RJKSD13-AUART
*                 IN_ISSUE_TAB
*       CHANGING  LV_XBATCH_ERROR.
  ENDIF.

ENDFUNCTION.

FORM popup_fuer_batchjob
     CHANGING rjksd13-batch_startdate
              rjksd13-batch_starttime
              rjksd13-batch_startimmediate
              rjksd13-vkorg rjksd13-auart
              popup_status.

* Init
  CLEAR: popup_status, gv_cancel.

*  CLEAR RJKSD13-BATCH_STARTTIME.
*  RJKSD13-BATCH_STARTIMMEDIATE = 'X'.
*  RJKSD13-BATCH_STARTDATE = SYST-DATUM.

  CALL SCREEN 500 STARTING AT 10 3.

  IF NOT gv_cancel IS INITIAL.
    popup_status = con_popupstatus_abort.
  ENDIF.


ENDFORM.                    "POPUP_FUER_BATCHJOB


MODULE pbo_500 OUTPUT.

  SET PF-STATUS 'ZPOPUP_SCRAPPING'.
  SET TITLEBAR 'ZTITLE_SCRAPPING'.

ENDMODULE.                 " PBO_500  OUTPUT

MODULE exit_500 INPUT.

  gv_cancel = abap_true.
  SET SCREEN 0.
  LEAVE SCREEN.

ENDMODULE.                 " EXIT_500  INPUT

MODULE pai_batch_500 INPUT.

  TYPES: BEGIN OF ty_return_log,
           msg_stat TYPE zmsg_icon_desc, " Message Icon and Description
           matnr    TYPE matnr,
           message  TYPE bapi_msg,
         END OF ty_return_log.

  DATA: lst_gm_header  TYPE bapi2017_gm_head_01,
        li_gm_item     TYPE STANDARD TABLE OF bapi2017_gm_item_create INITIAL SIZE 0,
        li_constant    TYPE STANDARD TABLE OF ty_constant INITIAL SIZE 0,
        lst_gm_item    TYPE bapi2017_gm_item_create,
        lv_entry_qty   TYPE erfmg,
        ls_issue_matnr TYPE ismmatnr_issue,
        li_return      TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0,
        lst_return     TYPE bapiret2,
        li_return_log  TYPE STANDARD TABLE OF ty_return_log INITIAL SIZE 0,
        li_outtab_gf   TYPE string VALUE '(RJKSDWORKLIST)I_OUTTAB[]'.

  DATA: lr_alv_table    TYPE REF TO cl_salv_table,           " Basis Class for Simple Tables
        lr_functions    TYPE REF TO cl_salv_functions_list,  " Generic and User-Defined Functions in List-Type Tables
        lr_display      TYPE REF TO cl_salv_display_settings,
        lv_start_column TYPE i, " Start_column of type Integers
        lv_end_column   TYPE i, " End_column of type Integers
        lv_start_line   TYPE i, " Start_line of type Integers
        lv_end_line     TYPE i, " End_line of type Integers
        lv_mcount_tmp   TYPE numc3,
        lv_count        TYPE numc3,
        lv_mcount       TYPE numc3 VALUE '50'.

  FIELD-SYMBOLS:
    <lfi_outtab>     TYPE lty_rjksdworklist_alv,
    <lfs_return_log> TYPE ty_return_log.

  CONSTANTS:
    lc_gm_code   TYPE bapi2017_gm_code VALUE '03',
    lc_msg       TYPE text50     VALUE 'Material successfully posted',
    lc_emsg      TYPE string     VALUE 'Material is locked. Please unlock it and re-run the Scrapping.',
    lc_mcount    TYPE rvari_vnam VALUE 'MAX_COUNT',
    lc_devid     TYPE zdevid     VALUE 'E223',
    lc_mtyp_s    TYPE symsgty    VALUE 'S',
    lc_mtyp_e    TYPE symsgty    VALUE 'E',
    lc_msgid_m3  TYPE symsgid    VALUE 'M3',
    lc_msgno_024 TYPE symsgno    VALUE '024',
    lc_uom       TYPE erfme      VALUE 'EA'.

  IF ok_code_0500 = 'GOON'.
*    IF RJKSD13-BATCH_STARTIMMEDIATE EQ 'X'.
*      CLEAR RJKSD13-BATCH_STARTDATE.
*      CLEAR RJKSD13-BATCH_STARTTIME.
*    ELSE.
*      CLEAR RJKSD13-BATCH_STARTIMMEDIATE.
*      IF RJKSD13-BATCH_STARTDATE < SY-DATUM.
*        MESSAGE E006(BT). LEAVE SCREEN.
*      ELSEIF RJKSD13-BATCH_STARTDATE = SY-DATUM.
*        IF RJKSD13-BATCH_STARTTIME < SY-UZEIT.
*          MESSAGE E006(BT). LEAVE SCREEN.
*        ENDIF.
*      ENDIF.
*    ENDIF.

* Fetch MAX_COUNT from constant table
    IF li_constant[] IS INITIAL.
      SELECT  devid, param1, srno, sign, opti, low, high
              INTO TABLE @li_constant
              FROM zcaconstant
              WHERE devid = @lc_devid AND
                    activate = @abap_true.
    ENDIF.
    IF sy-subrc = 0 AND li_constant[] IS NOT INITIAL.
      READ TABLE li_constant INTO DATA(lst_constant) WITH KEY devid = lc_devid param1 = lc_mcount.
      IF sy-subrc = 0.
        IF lst_constant-low IS NOT INITIAL.
          lv_mcount_tmp = lst_constant-low.
          IF lv_mcount_tmp > 1.
            lv_mcount = lv_mcount_tmp.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

* Get Selected Media Issue Worklist
    ASSIGN (li_outtab_gf) TO <lfi_outtab>.
    IF <lfi_outtab> IS ASSIGNED AND <lfi_outtab> IS NOT INITIAL.

* Fill Goods Movement Header data
      lst_gm_header-pstng_date = sy-datum.
      lst_gm_header-doc_date = sy-datum.

* Fill Goods Movement Item data
      LOOP AT <lfi_outtab> INTO DATA(lst_outtab).
        lv_entry_qty = lst_outtab-zwkbst.
        IF lst_outtab-matnr IS NOT INITIAL.
          lst_gm_item-material = lst_outtab-matnr.
        ELSE.
          lst_gm_item-material = lst_outtab-matnr_save.
        ENDIF.
        lst_gm_item-plant = lst_outtab-marc_werks.
        lst_gm_item-stge_loc = t001l-lgort.
        lst_gm_item-move_type = marc-ismretmove_st.
        lst_gm_item-entry_qnt = lv_entry_qty.
        lst_gm_item-entry_uom = lc_uom.
        lst_gm_item-entry_uom_iso = lc_uom.
        lst_gm_item-costcenter = csks-kostl.
        APPEND lst_gm_item TO li_gm_item.

        " DO loop is required to aviod the Error:
        " Valuation data for material XXXXX is locked by user XXXXXX
        " Message ID: M3, Message Type: E, Message No: 024
        DO.
          CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
            EXPORTING
              goodsmvt_header = lst_gm_header
              goodsmvt_code   = lc_gm_code
            TABLES
              goodsmvt_item   = li_gm_item
              return          = li_return.
          IF li_return[] IS NOT INITIAL.
            " Specific check if the Media Issue (Material) is locked
            READ TABLE li_return TRANSPORTING NO FIELDS
                 WITH KEY type   = lc_mtyp_e
                          id     = lc_msgid_m3
                          number = lc_msgno_024.
            IF sy-subrc <> 0.
              " If Material is unlocked, exit from DO loop.
              " Otherwise DO loop continues till the Max Count is reached.
              EXIT.
            ELSEIF sy-subrc = 0.
              lv_count = lv_count + 1.
              IF lv_count > lv_mcount.
                EXIT.   " Exit from DO loop if Max Count is reached.
              ENDIF.
            ENDIF. " IF sy-subrc <> 0
          ELSE.
            EXIT.
          ENDIF.   " IF li_return[] IS NOT INITIAL.
        ENDDO.
        IF li_return[] IS INITIAL.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

          APPEND INITIAL LINE TO li_return_log ASSIGNING <lfs_return_log>.
          PERFORM f_get_msg_icon USING lc_mtyp_s
                                 CHANGING <lfs_return_log>-msg_stat.
          <lfs_return_log>-matnr = lst_gm_item-material.
          <lfs_return_log>-message = lc_msg.
        ELSEIF li_return[] IS NOT INITIAL.
          " Specific check if the Media Issue (Material) is locked
          READ TABLE li_return TRANSPORTING NO FIELDS
               WITH KEY type   = lc_mtyp_e
                        id     = lc_msgid_m3
                        number = lc_msgno_024.
          IF sy-subrc = 0.
            APPEND INITIAL LINE TO li_return_log ASSIGNING <lfs_return_log>.
            PERFORM f_get_msg_icon USING lc_mtyp_e
                                   CHANGING <lfs_return_log>-msg_stat.
            <lfs_return_log>-matnr = lst_gm_item-material.
            <lfs_return_log>-message = lc_emsg.
          ELSE.
            READ TABLE li_return INTO lst_return INDEX 1.
            IF sy-subrc = 0.
              APPEND INITIAL LINE TO li_return_log ASSIGNING <lfs_return_log>.
              PERFORM f_get_msg_icon USING lc_mtyp_e
                                     CHANGING <lfs_return_log>-msg_stat.
              <lfs_return_log>-matnr = lst_gm_item-material.
              <lfs_return_log>-message = lst_return-message.
            ENDIF.
          ENDIF.
        ENDIF. " IF li_return[] IS INITIAL.

        CLEAR: lst_gm_item, lst_outtab, lst_return, lv_count, lv_entry_qty, li_gm_item[], li_return[].
      ENDLOOP.

    ENDIF.

    IF li_return_log[] IS NOT INITIAL.
      TRY.
          cl_salv_table=>factory(
            IMPORTING
              r_salv_table = lr_alv_table
            CHANGING
              t_table      = li_return_log[] ).
        CATCH cx_salv_msg.
      ENDTRY.

      lr_functions = lr_alv_table->get_functions( ).
      lr_functions->set_all( abap_true ).

      lr_display = lr_alv_table->get_display_settings( ).
      lr_display->set_list_header( 'Scrapping Log' ).

      lv_start_column  = 1.
      lv_end_column    = 100.
      lv_start_line    = 1.
      lv_end_line      = 20.

      IF lr_alv_table IS BOUND.
        lr_alv_table->set_screen_popup(
          start_column = lv_start_column
          end_column  = lv_end_column
          start_line  = lv_start_line
          end_line    = lv_end_line ).
*   Display ALV
        lr_alv_table->display( ).
      ENDIF. " IF lo_alv IS BOUND
      CLEAR li_return_log[].
    ENDIF.  " IF li_return_log[] IS NOT INITIAL.

* Leave from Screen: 500
    REFRESH li_return_log.
    SET SCREEN 0.
    LEAVE SCREEN.
  ELSEIF ok_code_0500 = 'CANC'.
    gv_cancel = abap_true.
    SET SCREEN 0.
    LEAVE SCREEN.
  ENDIF.

ENDMODULE.                 " PAI_500  INPUT

FORM ordergen_batch
    USING    rjksd13-batch_startdate
             rjksd13-batch_starttime
             rjksd13-batch_startimmediate
             rjksd13-vkorg
             rjksd13-auart
             marked_issue_tab TYPE ismmatnr_issuetab
    CHANGING lv_xbatch_error .
*
*
  DATA: jobnummer            LIKE tbtcjob-jobcount,
        jobname              LIKE tbtcjob-jobname,
        job_already_released.
*
  DATA: in_startdate LIKE syst-datum.
  DATA: in_starttime LIKE syst-uzeit.
  DATA: ls_issue LIKE LINE OF marked_issue_tab.
  RANGES: issue_range FOR mara-matnr.
  RANGES: vkorg_range FOR mara-matnr.

*
  CLEAR lv_xbatch_error.
  CLEAR issue_range. REFRESH issue_range.
  CLEAR vkorg_range. REFRESH vkorg_range.

*
* Übernahme des Jobnamens aus der LISPLT
  jobname = text-013.                  "Auftragsgenerierung
*
** Anlegen eines Hintergrundjobs
  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      delanfrep        = ' '
      jobgroup         = ' '
      jobname          = jobname
    IMPORTING
      jobcount         = jobnummer
    EXCEPTIONS
      cant_create_job  = 01
      invalid_job_data = 02
      jobname_missing  = 03.
  IF sy-subrc = 01 OR sy-subrc = 02.
*   Hintergrundjob konnte nicht angelegt werden
    MESSAGE s034(jpmgen).
    lv_xbatch_error = 'X'.
    EXIT.
  ELSEIF sy-subrc = 03.
*   Hintergrundjob hat keinen Namen
    MESSAGE s035(jpmgen).
    lv_xbatch_error = 'X'.
    EXIT.
  ENDIF.
*
* Add a job step to a report
* Prepare Selection for report
  CLEAR vkorg_range.
  vkorg_range-sign = 'I'.
  vkorg_range-option = 'EQ'.
  vkorg_range-low = rjksd13-vkorg.
  APPEND vkorg_range.
  LOOP AT marked_issue_tab INTO ls_issue.
    CLEAR issue_range.
    issue_range-sign = 'I'.
    issue_range-option = 'EQ'.
    issue_range-low = ls_issue.
    APPEND issue_range.
  ENDLOOP.
* job step = REPORT starten
  SUBMIT rjksdordergen AND RETURN
         USER sy-uname                 " Benutzername
         VIA JOB jobname               " JOBNAME, d.h. TEXT
             NUMBER jobnummer          " JOBNUMMER.
*        via selection-screen    "Test
          WITH vkorg IN vkorg_range
          WITH doc   = rjksd13-auart
          WITH issue IN issue_range
          WITH testrun = space.  "immer Echtlauf
  IF sy-subrc <> 0.
    CALL FUNCTION 'BP_JOB_DELETE'
      EXPORTING
        forcedmode = 'X'
        jobcount   = jobnummer
        jobname    = jobname.
*   Löschen des Hintergrundjobs, da er nicht eingeplant werden kann
    MESSAGE s036(jpmgen).
    lv_xbatch_error = 'X'.
    EXIT.
  ENDIF.
*
* Vorbelegung in JOB_CLOSE für TAG/ZEIT ist Blank!!
* (mit Intialwerten bricht JOB_CLOSE ab!)
  IF rjksd13-batch_startdate IS INITIAL.
    in_startdate = '       '.
  ELSE.
    in_startdate = rjksd13-batch_startdate.
  ENDIF.
  IF rjksd13-batch_starttime IS INITIAL.
    in_starttime = '     '.
  ELSE.
    in_starttime = rjksd13-batch_starttime.
  ENDIF.
* Pass job to background processing
* Job cannot be started until you have closed it
  CALL FUNCTION 'JOB_CLOSE'
    EXPORTING
      jobcount             = jobnummer
      jobname              = jobname
      sdlstrtdt            = in_startdate
      sdlstrttm            = in_starttime
      strtimmed            = rjksd13-batch_startimmediate
*       IMPORTING
*     JOB_WAS_RELEASED     = JOB_ALREADY_RELEASED
    EXCEPTIONS
      cant_start_immediate = 01
      invalid_startdate    = 02
      jobname_missing      = 03
      job_close_failed     = 04
      job_nosteps          = 05
      job_notex            = 06
      lock_failed          = 07.
*
  IF sy-subrc <> 0.
    CALL FUNCTION 'BP_JOB_DELETE'
      EXPORTING
        forcedmode = 'X'
        jobcount   = jobnummer
        jobname    = jobname.
*   Löschen des Hintergrundjobs, da er nicht eingeplant werden kann
    MESSAGE s036(jpmgen).
    lv_xbatch_error = 'X'.
    EXIT.
  ELSE.
*   Hintergrundjob wurde erfolgreich eingeplant
    MESSAGE s037(jksdworklist).
  ENDIF.
*
ENDFORM.                               "ORDERGEN_batch
*&---------------------------------------------------------------------*
*&      Form  F_GET_MSG_ICON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_get_msg_icon  USING    fp_msg_msgty     TYPE symsgty         " Message Type
                     CHANGING fp_msg_stat_desc TYPE zmsg_icon_desc. " Message Icon and Description

  DATA : lv_icon_fld TYPE icon_d, "Icon
         lv_msg_type TYPE char11.

  CLEAR: fp_msg_stat_desc.

  CASE fp_msg_msgty.
    WHEN 'A'.
      lv_icon_fld = '@8N@'.
      lv_msg_type = 'Abort'.
    WHEN 'E'.
      lv_icon_fld = '@5C@'. "Red/Error
      lv_msg_type = 'Error'.
    WHEN 'W'.
      lv_icon_fld = '@5D@'. "Yellow/Warning
      lv_msg_type = 'Warning'.
    WHEN 'S'.
      lv_icon_fld = '@5B@'. "Green/Success
      lv_msg_type = 'Success'.
    WHEN 'I'.
      lv_icon_fld = '@5B@'. "Green/Success
      lv_msg_type = 'Information'.
    WHEN OTHERS.
  ENDCASE.

  CONCATENATE lv_icon_fld lv_msg_type INTO fp_msg_stat_desc SEPARATED BY space.

ENDFORM.
