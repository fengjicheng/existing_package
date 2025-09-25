*&---------------------------------------------------------------------*
*&  Include           ZQTCN_E199_SALES_REP_UPD_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_all .
* Clear Internal Table
  CLEAR: i_constant[],
         i_vbap[],
         i_vbak[],
         i_fcat[],
         i_final[],
         i_process[].

  IF sy-tcode = 'ZSALE_REP_UPDAT'.
    s_auart-sign = 'I'.
    s_auart-option = 'EQ'.
    s_auart-low = 'SUB'.
    APPEND s_auart.
    CLEAR s_auart.

  ELSEIF sy-tcode = 'ZQTC_ZSUB_REPCHG'.
    s_auart-sign = 'I'.
    s_auart-option = 'EQ'.
    s_auart-low = 'ZSUB'.
    APPEND s_auart.
    CLEAR s_auart.

    s_auart-sign = 'I'.
    s_auart-option = 'EQ'.
    s_auart-low = 'ZREW'.
    APPEND s_auart.
    CLEAR s_auart.
  ELSE.
    s_auart-sign = 'I'.
    s_auart-option = 'EQ'.
    s_auart-low = 'ZSUB'.
    APPEND s_auart.
    CLEAR s_auart.

    s_vkorg-sign = 'I'.
    s_vkorg-option = 'EQ'.
    s_vkorg-low = '1001'.
    APPEND s_vkorg.
    CLEAR s_vkorg.

    s_erdat-sign = 'I'.
    s_erdat-option = 'EQ'.
    s_erdat-low = sy-datum.
    s_erdat-high = sy-datum.
    APPEND s_erdat.
    CLEAR s_erdat.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants .
* Get the constant value from table Zcaconstant
  SELECT  devid,      " Development ID
          param1,     " ABAP: Name of Variant Variable
          param2,     " ABAP: Name of Variant Variable
          srno,       " ABAP: Current selection number
          sign,       " ABAP: ID: I/E (include/exclude values)
          opti,       " ABAP: Selection option (EQ/BT/CP/...)
          low,        " Lower Value of Selection Condition
          high      " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE @i_constant
    WHERE devid = @c_devid.
  IF sy-subrc IS INITIAL.
    SORT i_constant BY devid.
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_SALES_REP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_sales_rep .
* Local Type Declaration
  TYPES : BEGIN OF lty_pernr,
            pernr TYPE persno,                " Personnel number
          END OF lty_pernr,
          ltt_srep_r TYPE RANGE OF zz_persno. " Personnel Number

  DATA : lir_srep TYPE ltt_srep_r,
         lst_srep TYPE LINE OF ltt_srep_r,
         li_pernr TYPE STANDARD TABLE OF lty_pernr INITIAL SIZE 0.

  IF p_srep1 IS NOT INITIAL.
* Popualte Sales Rep 1
    lst_srep-sign   = c_i.
    lst_srep-option = c_eq.
    lst_srep-low    =  p_srep1.
    APPEND lst_srep TO lir_srep.
    CLEAR lst_srep.
  ENDIF. " IF p_srep1 IS NOT INITIAL

  IF p_srep2 IS NOT INITIAL.
* Popualte Sales Rep 2
    lst_srep-sign   = c_i.
    lst_srep-option = c_eq.
    lst_srep-low    =  p_srep2.
    APPEND lst_srep TO lir_srep.
    CLEAR lst_srep.
  ENDIF. " IF p_srep2 IS NOT INITIAL

  IF lir_srep IS NOT INITIAL.
    SELECT pernr " Personnel number
     FROM pa0002 " HR Master Record: Infotype 0002 (Personal Data)
      INTO TABLE li_pernr
      WHERE pernr IN lir_srep.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE e031(zqtc_r2). " Invalid Sales Rep!
    ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
      SORT li_pernr BY pernr.
      IF p_srep1 IS NOT INITIAL.
        READ TABLE li_pernr WITH KEY pernr = p_srep1 BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc IS NOT INITIAL .
          MESSAGE e059(zqtc_r2). " Invalid Sales Rep1!
        ENDIF. " IF sy-subrc IS NOT INITIAL
      ENDIF. " IF p_srep1 IS NOT INITIAL

      IF p_srep2 IS NOT INITIAL.
        READ TABLE li_pernr WITH KEY pernr = p_srep2 BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc IS NOT INITIAL .
          MESSAGE e061(zqtc_r2). " Invalid Sales Rep2!
        ENDIF. " IF sy-subrc IS NOT INITIAL
      ENDIF. " IF p_srep2 IS NOT INITIAL
    ENDIF. " IF sy-subrc IS NOT INITIAL
  ENDIF. " IF lir_srep IS NOT INITIAL
ENDFORM.

**&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_FINAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_final .
******Local decarations
  DATA : li_detail TYPE STANDARD TABLE OF ty_detail,
         lst_final TYPE ty_final,
         lv_srep   TYPE flag.
  CONSTANTS:  lc_posnr_hdr TYPE posnr   VALUE '000000'.

  li_detail[] = i_detail[].

  DELETE ADJACENT DUPLICATES FROM li_detail COMPARING vbeln posnr.

  LOOP AT li_detail INTO DATA(lst_detail).
    lst_final-vbeln  = lst_detail-vbeln.
    lst_final-auart  = lst_detail-auart.
    lst_final-posnr = lst_detail-posnr.
    lst_final-matnr = lst_detail-matnr.
*Get the newsalesname2 based on salesrep1
    READ TABLE i_pa002 INTO DATA(lst_pa002) WITH KEY pernr = p_srep1 .
    IF sy-subrc IS INITIAL.
      CONCATENATE lst_pa002-nachn
                  lst_pa002-vorna
             INTO lst_final-sname1 "Personnel Name
                 SEPARATED BY space.

    ENDIF.
*Get the newsalesname2 based on salesrep2
    READ TABLE i_pa002 INTO  lst_pa002 WITH KEY pernr = p_srep2 .
    IF sy-subrc IS INITIAL.
      CONCATENATE lst_pa002-nachn
                  lst_pa002-vorna
             INTO lst_final-sname2 "Personnel Name
                 SEPARATED BY space.

    ENDIF.
*Set the header flag based on posnr value equal to zero and partner function
* value equal to VE or ZE
    READ TABLE i_detail INTO DATA(lst_detai3) WITH KEY vbeln = lst_detail-vbeln
                                                         posnr  = lc_posnr_hdr.

    IF sy-subrc EQ 0 AND ( lst_detai3-parvw = c_parvw_ve OR lst_detai3-parvw = c_parvw_ze ).
      lst_final-flag = c_true.
    ENDIF.

    READ TABLE i_detail INTO DATA(lst_detail1) WITH KEY vbeln = lst_detail-vbeln
                                                        posnr  = lst_detail-posnr
                                                        parvw  = c_parvw_ve
                                                        pernr  = p_srep1.
    IF sy-subrc EQ 0.
      lst_final-srep1 = lst_detail1-pernr.
      IF p_srep2 IS NOT INITIAL .
        READ TABLE i_detail INTO DATA(lst_detail2) WITH KEY vbeln = lst_detail-vbeln
                                                       posnr  = lst_detail-posnr
                                                       parvw  = c_parvw_ze
                                                       pernr  = p_srep2.
        IF sy-subrc EQ 0.
          lst_final-srep2 = lst_detail2-pernr.
        ELSE.
          CLEAR : lst_final-srep1.
        ENDIF..
      ELSE.
        READ TABLE i_detail INTO DATA(lst_detail4) WITH KEY vbeln = lst_detail-vbeln
                                                 posnr  = lst_detail-posnr
                                                 parvw  = c_parvw_ze.
        IF sy-subrc EQ 0.
          lst_final-srep2 = lst_detail4-pernr.
        ENDIF.
      ENDIF.
    ENDIF.
    IF lst_final-srep1 IS NOT INITIAL.
      APPEND lst_final TO i_final.
    ENDIF.
    CLEAR: lst_final.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_RECORDS_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_records_alv .
  DATA: lst_layout   TYPE slis_layout_alv.
  CONSTANTS : lc_pf_status   TYPE slis_formname  VALUE 'F_SET_PF_STATUS',
              lc_user_comm   TYPE slis_formname  VALUE 'F_USER_COMMAND',
              lc_top_of_page TYPE slis_formname  VALUE 'F_TOP_OF_PAGE',
              lc_box_sel     TYPE slis_fieldname VALUE 'SEL'.
  IF i_final IS INITIAL.
    MESSAGE 'Selection Contains No Data ' TYPE 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.
  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Displaying Results'(002).

  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.
  lst_layout-box_fieldname      = lc_box_sel.
  PERFORM f_popul_field_catalog .
*  PERFORM build_events.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = lc_pf_status
      i_callback_user_command  = lc_user_comm
      i_callback_top_of_page   = lc_top_of_page
      is_layout                = lst_layout
      it_fieldcat              = i_fcat
      i_save                   = abap_true
    TABLES
      t_outtab                 = i_final
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_set_pf_status
*&---------------------------------------------------------------------*
*       Set the PF Status for ALV
*----------------------------------------------------------------------*
FORM f_set_pf_status USING li_extab TYPE slis_t_extab.      "#EC CALLED
  DESCRIBE TABLE li_extab. "Avoid Extended Check Warning
  SET PF-STATUS 'ZSTANDARD'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_top_of_page.
*ALV Header declarations
  DATA: li_header     TYPE slis_t_listheader,
        lst_header    TYPE slis_listheader,
        lv_line       TYPE slis_entry,
        lv_dat_low    TYPE slis_entry,
        lv_dat_high   TYPE slis_entry,
        lv_count      TYPE i,      " Count of type Integers
        lv_line_count TYPE i,      " Lines of type Integers
        lv_linesc     TYPE char10. " Linesc(10) of type Character

* Constant
  CONSTANTS :     lc_typ_h TYPE char1 VALUE 'H', " Typ_h of type CHAR1
                  lc_typ_s TYPE char1 VALUE 'S', " Typ_s of type CHAR1
                  lc_typ_a TYPE char1 VALUE 'A'. " Typ_a of type CHAR1
* TITLE
  lst_header-typ = lc_typ_h . "'H'
  lst_header-info = 'Sales Rep update'(005).
  APPEND lst_header TO li_header.
  CLEAR lst_header.

* DATE
  lst_header-typ = lc_typ_s . "'S'
  lst_header-key = 'Date: '(006).
  WRITE sy-datum TO lst_header-info.
  APPEND lst_header TO li_header.
  CLEAR: lst_header.

* TOTAL NO. OF RECORDS SELECTED
  DESCRIBE TABLE i_final LINES lv_line_count.
  lv_linesc = lv_line_count.
  CONCATENATE 'Total No. of Records Selected: '(007) lv_linesc
  INTO lv_line SEPARATED BY space.
  lst_header-typ = lc_typ_a . "'A'
  lst_header-info = lv_line.
  APPEND lst_header TO li_header.
  CLEAR: lst_header,
         lv_line.

  IF s_kunnr[] IS NOT INITIAL.
    CLEAR lv_line_count.
    DESCRIBE TABLE s_kunnr LINES lv_line_count.
    IF lv_line_count EQ 1.
* Sold to
      LOOP AT s_kunnr.
        IF s_kunnr-high IS INITIAL.
          lv_line = s_kunnr-low.
        ELSE. " ELSE -> IF s_kunnr-high IS INITIAL
          CONCATENATE  s_kunnr-low 'To'
         s_kunnr-high INTO lv_line SEPARATED BY space.
        ENDIF. " IF s_kunnr-high IS INITIAL
        lst_header-typ = lc_typ_s.
        lst_header-key = 'Customer Number:'(008).
        lst_header-info = lv_line.
        APPEND lst_header TO li_header.
        CLEAR: lst_header,
               lv_line.
      ENDLOOP. " LOOP AT s_kunnr
    ELSE. " ELSE -> IF lv_line_count EQ 1
      lv_count = 1.
      LOOP AT s_kunnr.
        IF  lv_count = 1.
          lv_line = s_kunnr-low.
        ELSE. " ELSE -> IF lv_count = 1
          CONCATENATE lv_line s_kunnr-low INTO lv_line SEPARATED BY ','.
        ENDIF. " IF lv_count = 1
        lv_count = lv_count + 1.
      ENDLOOP. " LOOP AT s_kunnr
      lst_header-typ = 'S'.
      lst_header-key = 'Customer Number:'(008).
      lst_header-info = lv_line.
      APPEND lst_header TO li_header.
      CLEAR: lst_header,
             lv_line.
    ENDIF. " IF lv_line_count EQ 1
  ENDIF. " IF s_kunnr[] IS NOT INITIAL

* Sales Org.
  IF s_vkorg[] IS NOT INITIAL.
    CLEAR lv_line_count.
    DESCRIBE TABLE s_vkorg LINES lv_line_count.
    IF lv_line_count EQ 1.
      LOOP AT s_vkorg.
        IF s_vkorg-high IS INITIAL.
          lv_line = s_vkorg-low.
        ELSE. " ELSE -> IF s_vkorg-high IS INITIAL
          CONCATENATE s_vkorg-low 'To'
          s_vkorg-high INTO lv_line SEPARATED BY space.
        ENDIF. " IF s_vkorg-high IS INITIAL
        lst_header-typ  = lc_typ_s.
        lst_header-key  = 'Sales Org:'(009).
        lst_header-info =  lv_line.
        APPEND lst_header TO li_header.
        CLEAR: lst_header,
               lv_line.
      ENDLOOP. " LOOP AT s_vkorg
    ELSE. " ELSE -> IF lv_line_count EQ 1
      lv_count = 1.
      LOOP AT s_vkorg.
        IF  lv_count = 1.
          lv_line = s_vkorg-low.
        ELSE. " ELSE -> IF lv_count = 1
          CONCATENATE lv_line s_vkorg-low INTO lv_line SEPARATED BY ','.
        ENDIF. " IF lv_count = 1
        lv_count = lv_count + 1.
      ENDLOOP. " LOOP AT s_vkorg
      lst_header-typ = lc_typ_s.
      lst_header-key = ':'.
      lst_header-info = lv_line.
      APPEND lst_header TO li_header.
      CLEAR: lst_header,
             lv_line.
    ENDIF. " IF lv_line_count EQ 1
  ENDIF. " IF s_vkorg[] IS NOT INITIAL
* Creation Date
  IF s_erdat[] IS NOT INITIAL.
    READ TABLE s_erdat INDEX 1.
    IF sy-subrc IS INITIAL.
      IF s_erdat-high IS INITIAL.
        WRITE s_erdat-low TO lv_line.
      ELSE. " ELSE -> IF s_erdat-high IS INITIAL
        WRITE s_erdat-low TO lv_dat_low.
        WRITE s_erdat-high TO lv_dat_high.
        CONCATENATE lv_dat_low 'To'
        lv_dat_high INTO lv_line SEPARATED BY space.
      ENDIF. " IF s_erdat-high IS INITIAL
    ENDIF.
    lst_header-typ  = lc_typ_s.
    lst_header-key  = 'Creation date:'(010).
    lst_header-info =  lv_line.
    APPEND lst_header TO li_header.
    CLEAR: lst_header,
            lv_line.
  ENDIF. " IF s_erdat[] IS NOT INITIAL
  DELETE li_header WHERE info IS INITIAL.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_header.
ENDFORM. "APPLICATION_SERVER
*&---------------------------------------------------------------------*
*&      Form F_USER_COMMAND
*&---------------------------------------------------------------------*
*      USING fp_ucomm          " ABAP System Field: PAI-Triggering Function Code
*            fp_lst_selfield   .
*----------------------------------------------------------------------*
FORM f_user_command USING fp_ucomm TYPE syst_ucomm " ABAP System Field: PAI-Triggering Function Code
                          fp_lst_selfield TYPE slis_selfield.
*Local data decalrations
  DATA: lst_final   TYPE ty_final,
        lst_process TYPE ty_final,
        lv_input    TYPE char35, " Input of type CHAR30
        lv_tabix    TYPE sy-tabix,
        i_events    TYPE slis_t_event.          "Events

  DATA: lcl_ref_grid TYPE REF TO cl_gui_alv_grid. " ALV List Viewer

  DATA :    lv_count TYPE i,
            li_tab   TYPE  esp1_message_tab_type,
            lst_tab  TYPE esp1_message_wa_type.
  DATA: lir_input TYPE tt_range_r,
        lst_input TYPE LINE OF tt_range_r.
  DATA :lv_value_initial TYPE char1,
        lv_job_created   TYPE char1.

*Local consatnts decalarations
  CONSTANTS :  lc_fld_vbeln TYPE slis_fieldname VALUE 'VBELN',
               lc_ic1       TYPE syst_ucomm     VALUE '&IC1',       " ABAP System Field: PAI-Triggering Function Code
               lc_data_save TYPE syst_ucomm     VALUE '&DATA_SAVE', " ABAP System Field: PAI-Triggering Function Code
               lc_process   TYPE syst_ucomm     VALUE '&PROCESS',   " ABAP System Field: PAI-Triggering Function Code
               lc_msg_id    TYPE symsgid        VALUE 'ZQTC_R2',          " Message Class
               lc_msgty     TYPE symsgty        VALUE 'E',              " Message Type
               lc_mesid     TYPE char8          VALUE 'ZQTC_R2', "Message class
               lc_msgno     TYPE char3          VALUE '525', "Message Number
               lc_msgno1    TYPE char3          VALUE '526', "Message Number
               lc_msgty_e   TYPE char1          VALUE 'E', "Message type
               lc_d         TYPE char1          VALUE 'D',
               lc_msgty_s   TYPE char1          VALUE 'S', "Message type
               lc_rfresh    TYPE syst_ucomm     VALUE '&REFRESH', " ABAP System Field: PAI-Triggering Function Code
               lc_ref       TYPE syst_ucomm     VALUE 'REFRESH'.


  CASE fp_ucomm.
    WHEN lc_ic1.
* User double clicks any Order number then tcode VF43 is called from ALV.
      READ TABLE i_final INTO lst_final INDEX fp_lst_selfield-tabindex .
      IF sy-subrc = 0.
        IF fp_lst_selfield-fieldname = lc_fld_vbeln
               AND NOT lst_final-vbeln IS INITIAL.
          SET PARAMETER ID 'KTN' FIELD lst_final-vbeln.
          CALL TRANSACTION 'VA43' AND SKIP FIRST SCREEN.
        ENDIF. " IF fp_lst_selfield-fieldname = lc_fld_vbeln
      ENDIF. " IF sy-subrc = 0
*User click on Refresh button to display salesname1&salesname2
* values based on newsalesrep1 or newsalesrep2
    WHEN lc_rfresh.
      fp_lst_selfield-refresh = abap_true.
    WHEN lc_process.
      CLEAR: lcl_ref_grid.
      IF lcl_ref_grid IS INITIAL.
        CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
          IMPORTING "getting alv grid details
            e_grid = lcl_ref_grid.

        IF sy-subrc <> 0.                                   "#EC *
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF lcl_ref_grid IS INITIAL

      IF NOT lcl_ref_grid IS INITIAL.
        CALL METHOD lcl_ref_grid->check_changed_data. "checking and modifying
        "changes in internal table
      ENDIF. " IF NOT lcl_ref_grid IS INITIAL
      i_process[] = i_final[].
      DELETE i_process WHERE sel IS INITIAL.
      IF i_process[] IS NOT INITIAL.
        LOOP AT i_process INTO lst_process.
          CONCATENATE lst_process-vbeln
                      lst_process-posnr
                      lst_process-nsrep1
                      lst_process-nsrep2
                      lst_process-flag
                      INTO lv_input.
          lst_input-sign = c_i.
          lst_input-option = c_eq.
          lst_input-low = lv_input.
          APPEND lst_input TO lir_input.
          CLEAR lst_input.
        ENDLOOP. " LOOP AT i_process INTO lst_process
        i_selines[] = i_process[].
        DELETE i_selines WHERE nsrep1 EQ space AND nsrep2 EQ space.
        CLEAR :  lv_value_initial,
                 lv_job_created .
        IF i_selines IS NOT INITIAL.
          LOOP AT lir_input INTO lst_input.
            lv_tabix = sy-tabix.
            READ TABLE i_selines INTO DATA(lst_selines)
                                                WITH KEY vbeln = lst_input-low+0(10)
                                                         posnr = lst_input-low+10(6)
                                                         nsrep1 = lst_input-low+16(8)
                                                         nsrep2 = lst_input-low+24(8).
            IF sy-subrc NE 0.
*          delete lir_input FROM lv_tabix.
              lst_input-high = lc_d."'D'.
              MODIFY lir_input FROM lst_input INDEX lv_tabix TRANSPORTING high .
            ENDIF.
*--*Check if the saelsitem value is initial
            READ TABLE i_vbap INTO DATA(lst_vbap) WITH KEY vbeln = lst_input-low+0(10)
                                                           posnr = lst_input-low+10(6).
            IF sy-subrc EQ 0 AND lst_vbap-posnr IS INITIAL.
*--* Make sure selected item is not BOM header
              READ TABLE i_vbap INTO DATA(lst_vbap2) WITH KEY vbeln = lst_input-low+0(10)
                                                              posnr = lst_input-low+10(6).
              IF sy-subrc NE 0.
                lv_value_initial = abap_true.
                EXIT.
              ENDIF.
            ENDIF.
*--*Check if job created already for the selected line
            READ TABLE i_final INTO DATA(lst_final2) WITH KEY vbeln = lst_input-low+0(10)
                                                             posnr = lst_input-low+10(6)                                                            .
            IF sy-subrc EQ 0 AND lst_final2-jobname IS NOT INITIAL.
              lv_job_created = abap_true.
              EXIT.
            ENDIF.
          ENDLOOP.
          IF lv_job_created = abap_true.
            MESSAGE e536(zqtc_r2) DISPLAY LIKE 'I' WITH lst_vbap-vbeln lst_vbap-posnr.
          ENDIF.
          IF lv_value_initial = abap_true.
            MESSAGE e529(zqtc_r2) DISPLAY LIKE 'I' WITH lst_vbap-vbeln lst_vbap-posnr.
          ENDIF.
          DELETE lir_input WHERE high = lc_d."'D'.
          PERFORM f_update_sales_order USING lir_input.
          fp_lst_selfield-refresh = abap_true.
        ELSE.
          MESSAGE e524(zqtc_r2) DISPLAY LIKE 'I'.
        ENDIF."i_selines is NOT INITIAL.
        REFRESH i_selines.
        i_selines[] = i_process[].
*        delete i_selines WHERE nsrep1 ne space AND nsrep2 ne space.
        LOOP AT i_selines INTO DATA(lst_selines1).
          lv_count = lv_count + 1.
          IF lst_selines1-nsrep1 IS INITIAL AND lst_selines1-nsrep2 IS INITIAL.
            lst_tab-msgid  = lc_mesid.
            lst_tab-msgno  = lc_msgno.
            lst_tab-msgty  = lc_msgty_e.
            lst_tab-msgv1  = lst_selines1-vbeln.
            lst_tab-msgv2  = lst_selines1-posnr.
            lst_tab-lineno = lv_count.
            APPEND lst_tab TO li_tab.
            CLEAR lst_tab.
          ENDIF.
          IF lst_selines1-nsrep1 IS NOT INITIAL AND lst_selines1-nsrep2 IS NOT INITIAL.
            lst_tab-msgid  = lc_mesid.
            lst_tab-msgno  = lc_msgno1.
            lst_tab-msgty  = lc_msgty_s.
            lst_tab-msgv1  = lst_selines1-vbeln.
            lst_tab-msgv2  = lst_selines1-posnr.
            lst_tab-lineno = lv_count.
            APPEND lst_tab TO li_tab.
            CLEAR lst_tab.
          ENDIF.
        ENDLOOP.
      ENDIF. " IF i_process[] IS NOT INITIAL
      CALL FUNCTION 'C14Z_MESSAGES_SHOW_AS_POPUP'
        TABLES
          i_message_tab = li_tab.

    WHEN lc_data_save.
      MESSAGE i070(zqtc_r2). " Changes saved successfully.
*To get the salesname1 and salesname2 details based on newsalesrep1 values
    WHEN lc_ref.
      CLEAR: lcl_ref_grid.
      IF lcl_ref_grid IS INITIAL.
        CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
          IMPORTING "getting alv grid details
            e_grid = lcl_ref_grid.

        IF sy-subrc <> 0.                                   "#EC *
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF. " IF sy-subrc <> 0
      ENDIF. " IF lcl_ref_grid IS INITIAL

      IF NOT lcl_ref_grid IS INITIAL.
        CALL METHOD lcl_ref_grid->check_changed_data. "checking and modifying
        "changes in internal table

      ENDIF. " IF NOT lcl_ref_grid IS INITIAL
      IF i_final[] IS NOT INITIAL.

        SELECT  pernr, " Personnel number
                nachn, "Last Name
                vorna  "First Name
          FROM pa0002 " HR Master Record: Infotype 0002 (Personal Data)
          INTO TABLE @i_pa002_temp
          FOR ALL ENTRIES IN @i_final
       WHERE  ( pernr EQ @i_final-nsrep1 OR pernr EQ @i_final-nsrep2 ).
        IF sy-subrc IS INITIAL.
          SORT i_pa002_temp BY pernr.
        ENDIF.
        LOOP AT i_final ASSIGNING FIELD-SYMBOL(<lfs_final>).
          IF <lfs_final>-nsrep1 IS NOT INITIAL.
*Get the newsalesname1 by selecting newsalesrep1 by
*selecting f4 functionality or manually
            READ TABLE i_pa002_temp ASSIGNING FIELD-SYMBOL(<lfs_pa002>) WITH KEY pernr = <lfs_final>-nsrep1.
            IF sy-subrc IS  INITIAL.
              CONCATENATE <lfs_pa002>-nachn <lfs_pa002>-vorna INTO <lfs_final>-nsname1 SEPARATED BY space.
            ENDIF.
          ENDIF.
*Get the newsalesname2 by selecting newsalesrep2 by
* selecting f4 functionality or manually
          IF <lfs_final>-nsrep2 IS NOT INITIAL.
            READ TABLE i_pa002_temp ASSIGNING FIELD-SYMBOL(<lfs_pa0021>) WITH KEY pernr = <lfs_final>-nsrep2.
            IF sy-subrc IS  INITIAL.
              CONCATENATE <lfs_pa0021>-nachn <lfs_pa0021>-vorna INTO <lfs_final>-nsname2 SEPARATED BY space.
            ENDIF.
          ENDIF.

        ENDLOOP. " LOOP AT i_process INTO lst_process
        fp_lst_selfield-refresh = abap_true.
      ENDIF.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_popul_field_catalog .
*   Populate the field catalog
  DATA : lv_col_pos TYPE sycucol. " Col_pos of type Integers

*Constant for hold for alv tablename
  CONSTANTS: lc_tabname     TYPE slis_tabname VALUE 'I_FINAL', "Tablename for Alv Display
* Constent for hold the alv field catelog
             lc_fld_vbeln   TYPE slis_fieldname VALUE 'VBELN',
             lc_fld_auart   TYPE slis_fieldname VALUE 'AUART',
             lc_fld_posnr   TYPE slis_fieldname VALUE 'POSNR',
             lc_fld_matnr   TYPE slis_fieldname VALUE 'MATNR',
             lc_fld_srep1   TYPE slis_fieldname VALUE 'SREP1',
             lc_fld_sname1  TYPE slis_fieldname VALUE 'SNAME1',
             lc_fld_srep2   TYPE slis_fieldname VALUE 'SREP2',
             lc_fld_sname2  TYPE slis_fieldname VALUE 'SNAME2',
             lc_fld_nsrep1  TYPE slis_fieldname VALUE 'NSREP1',
             lc_fld_nname1  TYPE slis_fieldname VALUE 'NSNAME1',
             lc_fld_nsrep2  TYPE slis_fieldname VALUE 'NSREP2',
             lc_fld_nname2  TYPE slis_fieldname VALUE 'NSNAME2',
             lc_fld_flag    TYPE slis_fieldname VALUE  'FLAG',
             lc_fld_jobname TYPE slis_fieldname VALUE 'JOBNAME'.

  lv_col_pos         = 0 .
* Populate field catalog

* SalesDoc Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_hotspot USING lc_fld_vbeln  lc_tabname   lv_col_pos  'Sales Document'(014)
                       CHANGING i_fcat.

* Document Type
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_auart  lc_tabname   lv_col_pos  'Document Type'(016)
                     CHANGING i_fcat.

* Line item
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_posnr  lc_tabname   lv_col_pos  'Line Item'(015)
                       CHANGING i_fcat.

* Material
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_matnr  lc_tabname   lv_col_pos  'Material'(017)
                     CHANGING i_fcat.

* Sales Rep 1
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_srep1  lc_tabname   lv_col_pos  'Sales rep 1'(018)
                     CHANGING i_fcat.
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_sname1  lc_tabname   lv_col_pos  'Sales name 1'(023)
                     CHANGING i_fcat.
*Sales Rep 2
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_srep2  lc_tabname   lv_col_pos  'Sales rep 2'(019)
                   CHANGING i_fcat.
*Sales name2
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_sname2  lc_tabname   lv_col_pos  'Sales name 2'(024)
                     CHANGING i_fcat.
* New Sales Rep2
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_edit USING lc_fld_nsrep1  lc_tabname   lv_col_pos  'New Sales rep 1'(020)
                                CHANGING i_fcat.
*New sale name1
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_nname1  lc_tabname   lv_col_pos  'NewSales name 1'(025)
                     CHANGING i_fcat.
* New Sales Rep2
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_edit_2 USING lc_fld_nsrep2  lc_tabname   lv_col_pos  'New Sales rep 2'(021)
                  CHANGING i_fcat.

*New salesname2
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_nname2 lc_tabname   lv_col_pos  'NewSales name 2'(026)
                     CHANGING i_fcat.

  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_flag lc_tabname   lv_col_pos  'Headersalesrepflag'(027)
                     CHANGING i_fcat.
* New Sales Rep2
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_jobname  lc_tabname   lv_col_pos  'Background Job Name'(022)
                  CHANGING i_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT_HOTSPOT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LC_FLD_VBELN  text
*      -->P_LC_TABNAME  text
*      -->P_LV_COL_POS  text
*      -->P_1937   text
*      <--P_I_FCAT  text
*----------------------------------------------------------------------*
FORM f_build_fcat_hotspot  USING fp_field    TYPE slis_fieldname
                                 fp_tabname  TYPE slis_tabname
                                 fp_col_pos  TYPE sycucol " Col_pos of type Integers
                                 fp_text     TYPE char50  " Text of type CHAR50
                        CHANGING fp_i_fcat   TYPE slis_t_fieldcat_alv.

  DATA: lst_fcat   TYPE slis_fieldcat_alv.
  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '30'. " Output Length

  lst_fcat-lowercase   = abap_true.
  lst_fcat-key         = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-hotspot     = abap_true.
  lst_fcat-seltext_m   = fp_text.
  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LC_FLD_AUART  text
*      -->P_LC_TABNAME  text
*      -->P_LV_COL_POS  text
*      -->P_1951   text
*      <--P_I_FCAT  text
*----------------------------------------------------------------------*
FORM f_build_fcat  USING      fp_field         TYPE slis_fieldname
                              fp_tabname       TYPE slis_tabname
                              fp_col_pos       TYPE sycucol " Col_pos of type Integers
                              fp_text          TYPE char50  " Text of type CHAR50
                     CHANGING fp_i_fcat       TYPE slis_t_fieldcat_alv.

  DATA: lst_fcat   TYPE slis_fieldcat_alv.

  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '30'." Output Length

  lst_fcat-lowercase   = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-seltext_m   = fp_text.
  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT_EDIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LC_FLD_NSREP1  text
*      -->P_LC_TABNAME  text
*      -->P_LV_COL_POS  text
*      -->P_2021   text
*      <--P_I_FCAT  text
*----------------------------------------------------------------------*
FORM f_build_fcat_edit  USING  fp_field         TYPE slis_fieldname
                              fp_tabname       TYPE slis_tabname
                              fp_col_pos       TYPE sycucol " Col_pos of type Integers
                              fp_text          TYPE char50  " Text of type CHAR50
                     CHANGING fp_i_fcat       TYPE slis_t_fieldcat_alv.

  DATA: lst_fcat   TYPE slis_fieldcat_alv.
  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '30',          " Output Length
              lc_ref_tab   TYPE tabname    VALUE 'ZQTC_SALEREP', " Table Name
              lc_ref_fld   TYPE fieldname  VALUE 'PERNR'.       " Field Name

  lst_fcat-lowercase   = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-edit        = abap_true.
  lst_fcat-seltext_l   = fp_text.
  lst_fcat-seltext_m   = fp_text.
  lst_fcat-seltext_s   = fp_text.
  lst_fcat-ref_tabname = lc_ref_tab.
  lst_fcat-ref_fieldname = lc_ref_fld.
  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT_EDIT_2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LC_FLD_NSREP2  text
*      -->P_LC_TABNAME  text
*      -->P_LV_COL_POS  text
*      -->P_2035   text
*      <--P_I_FCAT  text
*----------------------------------------------------------------------*
FORM f_build_fcat_edit_2 USING  fp_field         TYPE slis_fieldname
                              fp_tabname       TYPE slis_tabname
                              fp_col_pos       TYPE sycucol " Col_pos of type Integers
                              fp_text          TYPE char50  " Text of type CHAR50
                     CHANGING fp_i_fcat       TYPE slis_t_fieldcat_alv.

  DATA: lst_fcat   TYPE slis_fieldcat_alv.
  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '30' ,       " Output Length
              lc_ref_tab   TYPE tabname    VALUE 'ZQTC_SALEREP', " Table Name
              lc_ref_fld   TYPE fieldname  VALUE 'PERNR'.
  lst_fcat-lowercase   = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-edit        = abap_true.
  lst_fcat-seltext_l   = fp_text.
  lst_fcat-seltext_m   = fp_text.
  lst_fcat-seltext_s   = fp_text.
  lst_fcat-ref_tabname = lc_ref_tab.
  lst_fcat-ref_fieldname = lc_ref_fld.
  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_SALES_ORDER
*&---------------------------------------------------------------------*
*       Update Sales order with reference to ALV
*----------------------------------------------------------------------*
FORM f_update_sales_order USING fp_lir_input TYPE tt_range_r.

  DATA :lv_jobname      TYPE btcjob,                                    " Background job name
        lv_jobcount     TYPE btcjobcnt,                                 " Job ID
        lv_valid        TYPE char1,                                     " Valid of type Character
        lv_error        TYPE char1,                                     " Error of type CHAR1
        lv_flg_released TYPE flag,                                      " General Flag
        lv_message      TYPE string,
        lv_locl         TYPE sypri_pdest,                               " Spool Parameter: Name of Device
        lst_params      TYPE pri_params,                                " Structure for Passing Spool Parameters
        lst_constant    TYPE ty_constant.

  CONSTANTS : lc_destination TYPE rvari_vnam VALUE 'DESTINATION', " ABAP: Name of Variant Variable
              lc_msg_id      TYPE symsgid VALUE 'ZQTC_R2',        " Message Class
              lc_msgty       TYPE symsgty VALUE 'E',              " Message Type
              lc_space       TYPE char1 VALUE ' '.                " Space(1) of type Character

  FIELD-SYMBOLS : <lst_final> TYPE ty_final.
* Get the Program Name
  lv_jobname = sy-cprog.

* To Open the Job for background processing
  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_jobname
      sdlstrtdt        = sy-datum
      sdlstrttm        = sy-uzeit
    IMPORTING
      jobcount         = lv_jobcount
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
    MESSAGE s000(zqtc_r2) WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    lv_error = abap_true.
  ELSE. " ELSE -> IF sy-subrc <> 0

* Get the Destination Value from i_constant Table.
    READ TABLE i_constant INTO lst_constant WITH KEY param1 = lc_destination.
    IF sy-subrc EQ 0.
      lv_locl = lst_constant-low .
    ENDIF. " IF sy-subrc EQ 0

    CALL FUNCTION 'GET_PRINT_PARAMETERS'
      EXPORTING
        destination            = lv_locl " LOCL
        immediately            = space
        new_list_id            = abap_true
        no_dialog              = abap_true
        user                   = sy-uname
      IMPORTING
        out_parameters         = lst_params
        valid                  = lv_valid
      EXCEPTIONS
        archive_info_not_found = 1
        invalid_print_params   = 2
        invalid_archive_params = 3
        OTHERS                 = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF. " IF sy-subrc <> 0

* Execute abap program zqtcr_update_sale_order  in background job storing any output to spool
    SUBMIT zqtcr_update_sale_order WITH s_input IN fp_lir_input
                USER 'QTC_BATCH01'
                 VIA JOB  lv_jobname NUMBER lv_jobcount
                 TO SAP-SPOOL
                 WITHOUT SPOOL DYNPRO
                 DESTINATION lst_constant-low IMMEDIATELY lc_space
                 KEEP IN SPOOL abap_true AND RETURN.
*       Closing the Job
    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobcount             = lv_jobcount
        jobname              = lv_jobname
        sdlstrtdt            = sy-datum
        sdlstrttm            = sy-uzeit
      IMPORTING
        job_was_released     = lv_flg_released
      EXCEPTIONS
        cant_start_immediate = 1
        invalid_startdate    = 2
        jobname_missing      = 3
        job_close_failed     = 4
        job_nosteps          = 5
        job_notex            = 6
        lock_failed          = 7
        OTHERS               = 8.
    IF sy-subrc <> 0.
      lv_error = abap_true.
    ENDIF. " IF sy-subrc <> 0
  ENDIF. " IF sy-subrc <> 0
  IF lv_error = abap_true.
    MESSAGE ID lc_msg_id
    TYPE       lc_msgty
    NUMBER     '068'
    INTO       lv_message.

    LOOP AT i_final ASSIGNING <lst_final> WHERE sel = abap_true
                                           AND ( nsrep1 IS NOT INITIAL OR
                                                 nsrep2 IS NOT INITIAL ).
      <lst_final>-jobname  = lv_message.
    ENDLOOP. " LOOP AT i_final ASSIGNING <lst_final> WHERE sel = abap_true

  ELSEIF lv_error IS INITIAL.
    MESSAGE ID lc_msg_id
    TYPE       lc_msgty
    NUMBER     '069'
    INTO       lv_message
    WITH       lv_jobname
               sy-datum
               sy-uzeit.
    LOOP AT i_final ASSIGNING <lst_final> WHERE sel = abap_true
                                          AND ( nsrep1 IS NOT INITIAL OR
                                                 nsrep2 IS NOT INITIAL ).
      <lst_final>-jobname  = lv_message.
    ENDLOOP. " LOOP AT i_final ASSIGNING <lst_final> WHERE sel = abap_true

  ENDIF. " IF lv_error = abap_true
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_PA0002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data_pa0002 .
  IF p_srep1 IS NOT INITIAL OR p_srep2 IS NOT INITIAL .
*GEt the personnel number first and last name based on selectionfieldp_Srep1 or ps_Srep2
    SELECT  pernr, " Personnel number
            nachn, "Last Name
            vorna  "First Name
      FROM pa0002 " HR Master Record: Infotype 0002 (Personal Data)
      INTO TABLE @i_pa002
   WHERE pernr IN (@p_srep1,@p_srep2).
    IF sy-subrc IS INITIAL.
      SORT i_pa002 BY pernr.
    ENDIF.
  ENDIF. " IF p_srep1 IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA_VBPA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_data_det .
  DATA :  lir_parvw   TYPE tt_parvw_r,
          lir_pernr   TYPE tt_pernr_r,
          li_vbap_tmp TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0.

  CONSTANTS : lc_posnr_hdr TYPE posnr VALUE '00000'. " Item number of the SD document

* Populate Range Table for Partner Function(PARVW)
  PERFORM f_populate_range_parvw  USING c_parvw_ve
                                  CHANGING lir_parvw.

* Populate Range Table for Partner Function(PARVW)
  PERFORM f_populate_range_parvw  USING c_parvw_ze
                                  CHANGING lir_parvw.

  IF p_srep1 IS NOT INITIAL.
* Populate Range table for Personnel Number
    PERFORM f_poplate_range_pernr   USING p_srep1
                                    CHANGING lir_pernr.
  ENDIF. " IF p_srep1 IS NOT INITIAL

  IF p_srep2 IS NOT INITIAL.
* Populate Range table for Personnel Number
    PERFORM f_poplate_range_pernr   USING p_srep2
                                    CHANGING lir_pernr.
  ENDIF. " IF p_srep2 IS NOT INITIAL

  li_vbap_tmp[] = i_vbap[].
  SORT li_vbap_tmp BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM li_vbap_tmp COMPARING vbeln posnr.

*Fetch the salesorder details by joining vbak,vbap,vbpa tables
  SELECT
  a~vbeln,
  a~erdat,
  a~auart,
  a~vkorg,
  a~kunnr,
  b~matnr,
  c~posnr,
  c~parvw,
  c~pernr
  INTO TABLE @i_detail
  FROM vbak AS a INNER JOIN vbap AS b
  ON a~vbeln = b~vbeln
  INNER JOIN vbpa AS c
  ON a~vbeln = c~vbeln
  AND ( c~posnr = b~posnr
  OR   c~posnr = @lc_posnr_hdr )
 WHERE  a~vbeln IN @s_vbeln
 AND  a~erdat IN @s_erdat
 AND a~auart IN @s_auart
 AND a~vkorg IN @s_vkorg
 AND a~kunnr IN @s_kunnr
 AND b~uepos = @c_uepos        "Consider only BOM Header
 AND  c~parvw IN @lir_parvw.

  IF sy-subrc EQ 0.
    SORT i_detail BY vbeln posnr parvw.
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_RANGE_PARVW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_PARVW_VE  text
*      <--P_LIR_PARVW  text
*----------------------------------------------------------------------*
FORM f_populate_range_parvw  USING    fp_lc_parvw TYPE parvw " Partner Function
                             CHANGING fp_lir_parvw TYPE tt_parvw_r.

  DATA : lst_parvw TYPE LINE OF tt_parvw_r.

  lst_parvw-sign   = c_i.
  lst_parvw-option = c_eq.
  lst_parvw-low    = fp_lc_parvw.
  APPEND lst_parvw TO fp_lir_parvw.
  CLEAR lst_parvw.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPLATE_RANGE_PERNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_SREP1  text
*      <--P_LIR_PERNR  text
*----------------------------------------------------------------------*
FORM f_poplate_range_pernr  USING    fp_p_srep    TYPE zz_persno " Personnel Number
                            CHANGING fp_lir_pernr TYPE tt_pernr_r.

  DATA : lst_pernr TYPE LINE OF tt_pernr_r.
  lst_pernr-sign   = c_i.
  lst_pernr-option = c_eq.
  lst_pernr-low    = fp_p_srep.
  APPEND lst_pernr TO fp_lir_pernr.
  CLEAR lst_pernr.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_RESTRICT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_restrict .
* Get the constant value from table Zcaconstant
  SELECT  devid,      " Development ID
          param1,     " ABAP: Name of Variant Variable
          param2,     " ABAP: Name of Variant Variable
          srno,       " ABAP: Current selection number
          sign,       " ABAP: ID: I/E (include/exclude values)
          opti,       " ABAP: Selection option (EQ/BT/CP/...)
          low,        " Lower Value of Selection Condition
          high      " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE @i_constant
    WHERE devid = @c_devid
    AND  param1 = @c_doc.
  IF sy-subrc IS INITIAL.
    SORT i_constant BY devid.
  ENDIF. " IF sy-subrc IS INITIAL
*Restrict to display doc type maintained in Zcaconstant table
  SELECT DISTINCT auart FROM tvak
  INTO TABLE i_det.
  DATA : lv_tabix TYPE   sy-tabix.
  LOOP AT i_det INTO DATA(lst_det).
    lv_tabix = sy-tabix.
    READ TABLE i_constant INTO DATA(lst_constant) WITH KEY devid = c_devid
                                                            low = lst_det-auart.
    IF sy-subrc IS INITIAL.
      DELETE i_det INDEX lv_tabix..
    ENDIF.
  ENDLOOP.

  IF sy-subrc = 0.
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield    = c_auart
        pvalkey     = ' '
        dynpprog    = sy-repid
        dynpnr      = sy-dynnr
        dynprofield = c_auart1
        value_org   = c_s
      TABLES
        value_tab   = i_det.
  ENDIF.
ENDFORM.
