REPORT zsdbilldl.

*ENHANCEMENT-POINT sdbilldl_11 SPOTS es_sdbilldl STATIC.

*======================================================================*
* Tabellen                                                             *
*======================================================================*
TABLES : vbco7.
TABLES : rv60a.
TABLES : tvfk .
TABLES : tvfkd.
TABLES : tvko .
TABLES : t005 .
TABLES : vkdfi.
*======================================================================*
* Includes                                                             *
*======================================================================*
INCLUDE zrvreuse_global_data.
*INCLUDE rvreuse_global_data.
INCLUDE zrvreuse_local_data.
*INCLUDE rvreuse_local_data.
INCLUDE zrvreuse_forms.
*INCLUDE rvreuse_forms.
*======================================================================*
* Interne Strukturen                                                   *
*======================================================================*
DATA: ls_isu_vkdfs_data_collect TYPE isu_vkdfs_data_collect."IS2ERP

" variable for screen help (POH)
DATA: gd_repid LIKE sy-repid VALUE 'ZSDBILLDL'.
DATA: BEGIN OF links OCCURS 0.
        INCLUDE STRUCTURE tline.
DATA: END OF links.

DATA : retcode LIKE sy-subrc.
DATA : BEGIN OF exclude OCCURS 5,
         fcode LIKE sy-ucomm,
       END   OF exclude.
RANGES : s_kunnr   FOR  vbco7-kunnr.
RANGES : s_lland   FOR  vbco7-lland.
RANGES : s_fkart   FOR  vbco7-fkart.
*RANGES : S_VBELN   FOR  VBCO7-VBELN.
RANGES : s_sortkri FOR  vbco7-sortkri.
DATA   : gt_fvkdfi LIKE vkdfif OCCURS 50 WITH HEADER LINE,
         lt_fvkdfi TYPE STANDARD TABLE OF vkdfif INITIAL SIZE 0,
         gt_vbsk   TYPE STANDARD TABLE OF vbsk INITIAL SIZE 0,
         gt_vbfs   TYPE STANDARD TABLE OF vbfs INITIAL SIZE 0,
         gt_vbss   TYPE STANDARD TABLE OF vbss INITIAL SIZE 0.

DATA   : trvog TYPE c.
DATA   : o_no_direct_posting LIKE rv50s-bform VALUE 'X'.
DATA   : ld_leave TYPE c,
         lv_batch TYPE char1 VALUE 'X'.


*======================================================================*
* Selektionsdynpro 1000                                                *
*======================================================================*

*Block : Belegdaten----------------------------------------------------*
SELECTION-SCREEN SKIP 1.


SELECTION-SCREEN BEGIN OF BLOCK beleg WITH FRAME TITLE text-a01.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(31) text-p01 FOR FIELD p_fkdat.
PARAMETERS: p_fkdat LIKE vbco7-fkdat.
SELECTION-SCREEN COMMENT 52(5) text-p02 FOR FIELD p_fkdat.
PARAMETERS: p_fkdab LIKE vbco7-fkdat_bis DEFAULT sy-datlo.
SELECTION-SCREEN END OF LINE.

SELECT-OPTIONS p_fkart FOR vbco7-fkart.
SELECT-OPTIONS s_vbeln FOR vbco7-vbeln.
SELECTION-SCREEN END   OF BLOCK beleg.


*Tabstrip--------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF TABBED BLOCK a_ts FOR 16 LINES.
SELECTION-SCREEN TAB (30) tsse USER-COMMAND tsse DEFAULT SCREEN 8001.
SELECTION-SCREEN TAB (30) tsdf USER-COMMAND tsdf DEFAULT SCREEN 8002.
SELECTION-SCREEN TAB (30) tsop USER-COMMAND tsop DEFAULT SCREEN 8003.
SELECTION-SCREEN END OF BLOCK a_ts.


SELECTION-SCREEN BEGIN OF SCREEN 8001 AS SUBSCREEN.

*Block : Organisationsdaten--------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK organ WITH FRAME TITLE text-o01.
PARAMETERS: p_vkorg   LIKE vbco7-vkorg MEMORY ID fko.
SELECT-OPTIONS s_vtweg FOR vbco7-vtweg.
SELECT-OPTIONS s_spart FOR vbco7-spart.
SELECT-OPTIONS s_vstel FOR vbco7-vstel.
SELECTION-SCREEN END   OF BLOCK organ.

*Block : Kundendaten---------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK kunde WITH FRAME TITLE text-a02.
SELECT-OPTIONS p_kunnr FOR vbco7-kunnr MATCHCODE OBJECT debi.
SELECT-OPTIONS p_lland FOR vbco7-lland.
SELECT-OPTIONS p_sort FOR vbco7-sortkri.
SELECTION-SCREEN END   OF BLOCK kunde.

*Block : Zu selektierende Belege---------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK choice WITH FRAME TITLE text-a03.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_allea LIKE vbco7-allea MEMORY ID sna.
SELECTION-SCREEN COMMENT 3(29) text-p09 FOR FIELD p_allea.
PARAMETERS: p_allel LIKE vbco7-allel DEFAULT 'X' MEMORY ID snl.
SELECTION-SCREEN COMMENT 37(29) text-p10 FOR FIELD p_allel.
PARAMETERS: p_alleb LIKE vbco7-alleb MEMORY ID snb.
SELECTION-SCREEN COMMENT 71(29) text-p07 FOR FIELD p_alleb.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_allei LIKE vbco7-allei MEMORY ID sni.
SELECTION-SCREEN COMMENT 3(29) text-p08 FOR FIELD p_allei.
PARAMETERS  no_faksk LIKE vbco7-no_faksk.
SELECTION-SCREEN COMMENT 37(29) text-p12 FOR FIELD no_faksk.
PARAMETERS  p_pdstk  LIKE vbco7-pdstk AS CHECKBOX.
SELECTION-SCREEN COMMENT 71(29) text-p13 FOR FIELD p_pdstk.
SELECTION-SCREEN END OF LINE.

PARAMETERS: p_allef LIKE vbco7-allef NO-DISPLAY MEMORY ID snf.

*ENHANCEMENT-POINT sdbilldl_10 SPOTS es_sdbilldl STATIC.

SELECTION-SCREEN END OF BLOCK choice.

SELECTION-SCREEN END OF SCREEN 8001.


SELECTION-SCREEN BEGIN OF SCREEN 8003 AS SUBSCREEN.

*Block : Ablaufsteuerung für Batchverarbeitung-------------------------*

SELECTION-SCREEN BEGIN OF BLOCK ablauf  WITH FRAME TITLE text-a05.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETER  p_anzei TYPE sdbill_listanzei AS CHECKBOX DEFAULT ' '.
SELECTION-SCREEN COMMENT 3(30)  text-p06 FOR FIELD p_anzei.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_proto TYPE sdbill_sammelgang AS CHECKBOX.
SELECTION-SCREEN COMMENT 3(40)  text-p11 FOR FIELD p_proto.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END   OF BLOCK ablauf.


*Block : Verbuchungssteuerung------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK update WITH FRAME TITLE text-a07.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_utasy TYPE utasy RADIOBUTTON GROUP updt DEFAULT 'X'.
SELECTION-SCREEN COMMENT 5(30) text-u01 FOR FIELD p_utasy.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_utswl TYPE utswl RADIOBUTTON GROUP updt.
SELECTION-SCREEN COMMENT 5(30) text-u02 FOR FIELD p_utswl.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_utsnl TYPE utsnl RADIOBUTTON GROUP updt.
SELECTION-SCREEN COMMENT 5(30) text-u03 FOR FIELD p_utsnl.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END   OF BLOCK update.

SELECTION-SCREEN END OF SCREEN 8003.


SELECTION-SCREEN BEGIN OF SCREEN 8002 AS SUBSCREEN.

*ENHANCEMENT-POINT sdbilldl_03 SPOTS es_sdbilldl STATIC.

SELECTION-SCREEN BEGIN OF BLOCK default WITH FRAME TITLE text-a08.
PARAMETERS : pv_fkart LIKE rv60a-fkart.
PARAMETERS : pv_fkdat LIKE rv60a-fkdat.
PARAMETERS : pv_fbuda LIKE rv60a-fbuda.
PARAMETERS : pv_prsdt LIKE rv60a-prsdt.
SELECTION-SCREEN END   OF BLOCK default.

SELECTION-SCREEN END OF SCREEN 8002.


*======================================================================*
* Selektionsdynpro 2110                                                *
*======================================================================*
*SELECTION-SCREEN BEGIN OF SCREEN 2110 TITLE text-tt1 AS WINDOW.
*PARAMETERS : pv_fkart LIKE rv60a-fkart.
*PARAMETERS : pv_fkdat LIKE rv60a-fkdat.
*PARAMETERS : pv_fbuda LIKE rv60a-fbuda.
*PARAMETERS : pv_prsdt LIKE rv60a-prsdt.
*SELECTION-SCREEN END OF SCREEN 2110.
*ENHANCEMENT-POINT sdbilldl_08 SPOTS es_sdbilldl STATIC.

*======================================================================*
* versteckte Parameter aus Übergabe von RV60SBAT                       *
*======================================================================*
PARAMETERS : p_samml(1) NO-DISPLAY.
PARAMETERS : p_varnr LIKE gs_sd_alv-variant NO-DISPLAY.


INITIALIZATION.
*ENHANCEMENT-POINT SDBILLDL_04 SPOTS ES_SDBILLDL STATIC .

  tsse = text-tss.    "Tabstrip Main selection
  tsop = text-tsb.    "Tabstrip batch and update
  tsdf = text-tst.    "Tabstrip default data

*======================================================================*
* Ereignis : AT SELECTION-SCREEN OUTPUT (PBO-Zeitpunkt)                *
*======================================================================*
AT SELECTION-SCREEN OUTPUT.
  DATA: exclude        LIKE rsexfcode OCCURS 0 WITH HEADER LINE,
        ls_submit_info TYPE rssubinfo.

  IF sy-dynnr = 1000.
    CALL FUNCTION 'RS_SUBMIT_INFO'
      IMPORTING
        p_submit_info = ls_submit_info.

    CHECK ls_submit_info-mode_norml = 'X'.

    CALL FUNCTION 'RS_SET_SELSCREEN_STATUS'
      EXPORTING
        p_status  = 'SELK'
      TABLES
        p_exclude = exclude
      EXCEPTIONS
        OTHERS    = 1.

  ENDIF.

  CALL FUNCTION 'RS_DISABLE_SPAGPA_ON_CURR_DYNP'.

AT SELECTION-SCREEN ON p_fkdab.
  IF sy-dynnr = 1000 AND
      NOT p_fkdab IS INITIAL AND
      p_fkdat GT p_fkdab.
    SET CURSOR FIELD 'P_FKDAB'.
    MESSAGE e650(db).
  ENDIF.

*======================================================================*
* Ereignis : AT SELECTION-SCREEN (PAI-Zeitpunkt)                       *
*            letztes PAI-Ereignis                                      *
*======================================================================*
AT SELECTION-SCREEN.
  SET PARAMETER ID 'SNA' FIELD p_allea.
  SET PARAMETER ID 'SNL' FIELD p_allel.
  SET PARAMETER ID 'SNI' FIELD p_allei.
  SET PARAMETER ID 'SNB' FIELD p_alleb.
  SET PARAMETER ID 'FKO' FIELD p_vkorg.
*ENHANCEMENT-POINT SDBILLDL_06 SPOTS ES_SDBILLDL .
  IF sy-ucomm = 'SAMD'.
    DATA : ld_answer TYPE c.
    CHECK sy-dynnr EQ '1000'.
    CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
      EXPORTING
        titel     = text-pt5
        textline1 = text-056
        textline2 = text-057
      IMPORTING
        answer    = ld_answer.
    IF ld_answer = 'J'.
      CLEAR o_no_direct_posting.
      PERFORM authority_check USING '19' 'X' retcode.
      PERFORM vbco7_fill CHANGING vbco7.
      rv60a-fkart = pv_fkart.
      rv60a-fkdat = pv_fkdat.
      rv60a-fbuda = pv_fbuda.
      rv60a-prsdt = pv_prsdt.

*ENHANCEMENT-POINT sdbilldl_20 SPOTS es_sdbilldl.

      PERFORM vkdfs_data_collect
                TABLES
                  gt_fvkdfi
                  s_kunnr
                  s_vbeln
                  s_lland
                  s_fkart
                  s_sortkri
                  s_vtweg
                  s_spart
                  s_vstel
                USING vbco7 rv60a
                  ls_isu_vkdfs_data_collect.                "IS2ERP


      DATA : ld_sammg LIKE vbsk-sammg.
      DATA : lt_vbsk LIKE vbsk OCCURS 1  WITH HEADER LINE.
      DATA : lt_vbfs LIKE vbfs OCCURS 10 WITH HEADER LINE.
      DATA : lt_vbss LIKE vbss OCCURS 10 WITH HEADER LINE.

      gt_fvkdfi-selkz = 'X'.
      MODIFY gt_fvkdfi TRANSPORTING selkz WHERE selkz = space.

      LOOP AT gt_fvkdfi INTO DATA(lis_fvkdfi).
        APPEND lis_fvkdfi TO lt_fvkdfi.

        CALL FUNCTION 'SD_COLLECTIVE_RUN_EXECUTE'
          EXPORTING
            v60p_input_rv60a  = rv60a
            id_utasy          = p_utasy
            id_utswl          = p_utswl
            id_utsnl          = p_utsnl
          IMPORTING
            v60p_output_vbsk  = lt_vbsk
          TABLES
            v60p_input_vkdfif = lt_fvkdfi
            v60p_output_vbfs  = lt_vbfs
            v60p_output_vbss  = lt_vbss
          EXCEPTIONS
            OTHERS            = 1.

        APPEND lt_vbsk.
        CLEAR: lt_vbsk, lis_fvkdfi, lt_fvkdfi[].
      ENDLOOP.

      CALL FUNCTION 'VBSK_ALV_DISPLAY'
        TABLES
          i_vbsk = lt_vbsk
        EXCEPTIONS
          OTHERS = 1.

    ENDIF.
  ENDIF.
*ENHANCEMENT-SECTION     sdbilldl_21 SPOTS es_sdbilldl.
* CHECK sy-dynnr EQ '1000'.
*END-ENHANCEMENT-SECTION.

  IF sy-ucomm = 'SPAL'.
    IF gs_sd_alv-variant IS INITIAL.
      PERFORM reuse_alv_variant_fill USING 'ZSDBILLDL'
                                           trvog
                                           space
                                           sy-uname
                                           gs_sd_alv-variant.
    ENDIF.
*   PERFORM ALV_VARIANT_DISPLAY USING 'X'.
    DATA: lv_viewname LIKE dd02l-tabname.
    lv_viewname = 'VKDFIF'.
    gs_sd_alv-variant-report = 'ZSDBILLDL'.
    PERFORM reuse_alv_fieldcatalog_merge USING gs_sd_alv-fieldcat[]
                                               lv_viewname
                                               space
                                               space.
    CALL FUNCTION 'REUSE_ALV_VARIANT_SELECT'
      EXPORTING
        i_dialog            = 'X'
        i_user_specific     = 'A'
        i_default           = space
        it_default_fieldcat = gs_sd_alv-fieldcat[]
        i_layout            = gs_sd_alv-layout
      IMPORTING
        et_fieldcat         = gs_sd_alv-fieldcat[]
        et_sort             = gs_sd_alv-sort[]
        et_filter           = gs_sd_alv-filter[]
      CHANGING
        cs_variant          = gs_sd_alv-variant
      EXCEPTIONS
        wrong_input         = 1
        fc_not_complete     = 2
        not_found           = 3
        program_error       = 4
        OTHERS              = 5.
  ENDIF.

*======================================================================*
* Ereignis : HELP-REQUEST (POH-Zeitpunkt)                              *
*                                                                      *
*======================================================================*
AT SELECTION-SCREEN ON HELP-REQUEST FOR s_vbeln-low.

  CALL FUNCTION 'HELP_OBJECT_SHOW'
    EXPORTING
      dokclass                      = 'DE'
      dokname                       = 'VBELN'
      called_by_program             = gd_repid
      called_by_dynp                = sy-dynnr
      called_for_field              = 'S_VBELN-LOW'
      called_for_tab_fld_btch_input = 'S_VBELN-LOW'
      called_by_cuastat             = sy-pfkey
    TABLES
      links                         = links
    EXCEPTIONS
      object_not_found              = 1
      sapscript_error               = 2
      OTHERS                        = 3.

AT SELECTION-SCREEN ON HELP-REQUEST FOR s_vbeln-high.

  CALL FUNCTION 'HELP_OBJECT_SHOW'
    EXPORTING
      dokclass                      = 'DE'
      dokname                       = 'VBELN'
      called_by_program             = gd_repid
      called_by_dynp                = sy-dynnr
      called_for_field              = 'S_VBELN-HIGH'
      called_for_tab_fld_btch_input = 'S_VBELN-HIGH'
      called_by_cuastat             = sy-pfkey
    TABLES
      links                         = links
    EXCEPTIONS
      object_not_found              = 1
      sapscript_error               = 2
      OTHERS                        = 3.


*======================================================================*
* Ereignis : START-OF-SELECTION (PAI-Zeitpunkt)                        *
*                                                                      *
*======================================================================*
START-OF-SELECTION.
  IF gs_sd_alv-variant IS INITIAL.
    gs_sd_alv-variant-report = 'SDBILLDL'.
    PERFORM reuse_alv_variant_default
            USING gs_sd_alv.
  ENDIF.
  PERFORM authority_check USING '03' 'X' retcode.
  PERFORM function_exclude TABLES exclude.
  PERFORM vbco7_fill CHANGING vbco7.
  rv60a-fkart = pv_fkart.
  rv60a-fkdat = pv_fkdat.
  rv60a-fbuda = pv_fbuda.
  rv60a-prsdt = pv_prsdt.
*ENHANCEMENT-SECTION     SDBILLDL_12 SPOTS ES_SDBILLDL.
  PERFORM vkdfs_data_collect
            TABLES
              gt_fvkdfi
              s_kunnr
              s_vbeln
              s_lland
              s_fkart
              s_sortkri
              s_vtweg
              s_spart
              s_vstel
             USING
              vbco7 rv60a
              ls_isu_vkdfs_data_collect.                    "IS2ERP
*END-ENHANCEMENT-SECTION.



*======================================================================*
* Ereignis : END-OF-SELECTION (PAI-Zeitpunkt)                          *
*                                                                      *
*======================================================================*
END-OF-SELECTION.
* Im Dialog wird der ALV aufgerufen und die weitere Verarbeitung mittels
* Callback-Technik realisiert.
* Im Batch wird der ALV nur aufgerufen, falls eine Liste des Faktura-
* vorrates gewünscht ist (Selektion im RV60SBAT)
  IF  sy-batch IS INITIAL OR
    ( NOT sy-batch IS INITIAL AND  NOT p_anzei IS INITIAL ).
    IF NOT p_varnr IS INITIAL.
      gs_sd_alv-variant = p_varnr.
    ENDIF.
    PERFORM vkdfs_data_display
              TABLES
                gt_fvkdfi
              USING
                rv60a.
  ENDIF.

* In the batch, collective billing of all billing index entries is made
  IF NOT sy-batch IS INITIAL.
    DATA : ld_sammg LIKE vbsk-sammg.
    DATA : lt_vbsk LIKE vbsk OCCURS 1  WITH HEADER LINE.
    DATA : lt_vbfs LIKE vbfs OCCURS 10 WITH HEADER LINE.
    DATA : lt_vbss LIKE vbss OCCURS 10 WITH HEADER LINE.
    DATA : lt_fvbss TYPE TABLE OF vbssf.
    DATA : ls_fvbss TYPE vbssf.
    DATA : ls_vbss  TYPE vbss.

    gt_fvkdfi-selkz = 'X'.
    MODIFY gt_fvkdfi TRANSPORTING selkz WHERE selkz = space.

    IF gt_fvkdfi[] IS NOT INITIAL.
      LOOP AT gt_fvkdfi INTO DATA(lis_fvkdfi).
        APPEND lis_fvkdfi TO lt_fvkdfi.

        CALL FUNCTION 'SD_COLLECTIVE_RUN_EXECUTE'
          EXPORTING
            v60p_input_rv60a  = rv60a
            id_utasy          = p_utasy
            id_utswl          = p_utswl
            id_utsnl          = p_utsnl
          IMPORTING
            v60p_output_vbsk  = lt_vbsk
          TABLES
            v60p_input_vkdfif = lt_fvkdfi
            v60p_output_vbfs  = lt_vbfs
            v60p_output_vbss  = lt_vbss
          EXCEPTIONS
            OTHERS            = 1.
        IF sy-subrc = 0.
          APPEND lt_vbsk TO gt_vbsk.
          APPEND LINES OF: lt_vbfs TO gt_vbfs,
                           lt_vbss TO gt_vbss.
          REFRESH: lt_vbfs, lt_vbss, lt_fvkdfi.
          CLEAR: lt_vbsk, lt_vbfs, lt_vbss, lis_fvkdfi.
        ENDIF.
      ENDLOOP.
    ENDIF. " IF gt_fvkdfi[] IS NOT INITIAL.
  ENDIF. " IF NOT sy-batch IS INITIAL

* The processing log is output in the batch if a corresponding
* selection has been made using report RV60SBAT.
  IF NOT sy-batch IS INITIAL AND NOT p_proto IS INITIAL.
    CALL FUNCTION 'VBSK_ALV_DISPLAY'
      TABLES
        i_vbsk = gt_vbsk
      EXCEPTIONS
        OTHERS = 1.

    CALL FUNCTION 'VBFS_TREE_LIST_DISPLAY'
      TABLES
        i_vbfs = gt_vbfs
      EXCEPTIONS
        OTHERS = 1.

    LOOP AT gt_vbss INTO ls_vbss.
      MOVE-CORRESPONDING ls_vbss TO ls_fvbss.
      APPEND ls_fvbss TO lt_fvbss.
      CLEAR: ls_vbss, ls_fvbss.
    ENDLOOP.

    CALL FUNCTION 'VBSS_ALV_DISPLAY'
      EXPORTING
        smart   = 'F'
      TABLES
        i_vbss  = gt_vbss
        i_fvbss = lt_fvbss.
  ENDIF.


*&---------------------------------------------------------------------*
*&      Form  AUTHORITY_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0405   text                                                *
*      -->P_0406   text                                                *
*----------------------------------------------------------------------*
FORM authority_check USING aktivitaet nachricht
                     CHANGING rcode.
  AUTHORITY-CHECK OBJECT 'V_VBRK_VKO'
     ID 'VKORG' DUMMY
     ID 'ACTVT' FIELD aktivitaet.
  CLEAR rcode.
  IF sy-subrc <> 0.
    rcode = sy-subrc.
    IF nachricht <> space.
      IF aktivitaet = '03'.
        MESSAGE e124(vr).
      ELSE.
        MESSAGE e123(vr).
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    "AUTHORITY_CHECK
*&---------------------------------------------------------------------*
*&      Form  FUNCTION_EXCLUDE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_EXCLUDE  text                                              *
*----------------------------------------------------------------------*
FORM function_exclude TABLES   p_exclude STRUCTURE exclude.
  DATA : rcode LIKE sy-subrc.
  CLEAR p_exclude.
  REFRESH p_exclude.
  PERFORM authority_check USING '01' ' ' CHANGING rcode.
  IF rcode <> 0.
    exclude-fcode = 'SAMQ'. APPEND exclude.
  ENDIF.
  PERFORM authority_check USING '19' ' ' CHANGING rcode.
  IF rcode <> 0.
    exclude-fcode = 'SAMO'. APPEND exclude.
    exclude-fcode = 'MARA'. APPEND exclude.
    exclude-fcode = 'MARK'. APPEND exclude.
    exclude-fcode = 'MARL'. APPEND exclude.
    exclude-fcode = 'EPRO'. APPEND exclude.
    exclude-fcode = 'LPRO'. APPEND exclude.
    exclude-fcode = 'SPRO'. APPEND exclude.
  ENDIF.
ENDFORM.                               " FUNCTION_EXCLUDE
*&---------------------------------------------------------------------*
*&      Form  VBCO7_FILL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_VBCO7  text                                                *
*----------------------------------------------------------------------*
FORM vbco7_fill CHANGING p_vbco7 LIKE vbco7.
* Konstanten:
  DATA:
    option_equal   LIKE s_kunnr-option VALUE 'EQ',
    option_between LIKE s_kunnr-option VALUE 'BT',
    sign_include   LIKE s_kunnr-sign   VALUE 'I'.

  CLEAR p_vbco7.
  p_vbco7-fkdat     = p_fkdat.
  p_vbco7-fkdat_bis = p_fkdab.
  p_vbco7-vkorg     = p_vkorg.
  p_vbco7-kunnr     = p_kunnr-low.
  p_vbco7-fkart     = p_fkart-low.
  p_vbco7-lland     = p_lland.
  p_vbco7-allef     = p_allef.
  p_vbco7-allel     = p_allel.
  p_vbco7-allea     = p_allea.
  p_vbco7-alleb     = p_alleb.
  p_vbco7-allei     = p_allei.
  p_vbco7-no_faksk  = no_faksk.
  p_vbco7-name_dazu = 'X'.
  p_vbco7-pdstk     = p_pdstk.
  REFRESH: s_kunnr, s_lland, s_fkart, s_sortkri.
  CLEAR:   s_kunnr, s_lland, s_fkart, s_sortkri.
  LOOP AT p_kunnr.
    s_kunnr = p_kunnr.
    APPEND s_kunnr.
  ENDLOOP.
  LOOP AT p_fkart.
    s_fkart = p_fkart.
    APPEND s_fkart.
  ENDLOOP.
* Land gefüllt ?
  LOOP AT p_lland.
    s_lland = p_lland.
    APPEND s_lland.
  ENDLOOP.
  LOOP AT p_sort.
    s_sortkri = p_sort.
    APPEND s_sortkri.
  ENDLOOP.
*ENHANCEMENT-POINT sdbilldl_13 SPOTS es_sdbilldl.

ENDFORM.                               " VBCO7_FILL
*&---------------------------------------------------------------------*
*&      Form  VKDFS_DATA_COLLECT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_VKDFS  text                                             *
*      -->P_S_KUNNR  text                                              *
*      -->P_S_VBELN  text                                              *
*      -->P_S_LLAND  text                                              *
*      -->P_S_FKART  text                                              *
*      -->P_S_SORTKRI  text                                            *
*      -->P_VBCO7  text                                                *
*      -->P_RV60A  text                                                *
*----------------------------------------------------------------------*
FORM vkdfs_data_collect
       TABLES
         p_gt_fvkdfi STRUCTURE vkdfif
         p_s_kunnr STRUCTURE s_kunnr
         p_s_vbeln STRUCTURE s_vbeln
         p_s_lland STRUCTURE s_lland
         p_s_fkart STRUCTURE s_fkart
         p_s_sortkri STRUCTURE s_sortkri
         p_s_vtweg   STRUCTURE s_vtweg
         p_s_spart   STRUCTURE s_spart
         p_s_vstel   STRUCTURE s_vstel
       USING
         p_vbco7 LIKE vbco7
         p_rv60a LIKE rv60a
         is_enhancement TYPE isu_vkdfs_data_collect.

  DATA: tvfkd_rc LIKE sy-subrc.
  DATA: BEGIN OF auftrag OCCURS 100,
          vbeln LIKE vkdfs-vbeln,
          fkdat LIKE vkdfs-fkdat,
        END   OF auftrag.

  REFRESH p_gt_fvkdfi.

*ENHANCEMENT-SECTION     sdbilldl_02 SPOTS es_sdbilldl.
  break sguda.
  DATA lv_opt_enabled TYPE abap_bool.
  lv_opt_enabled = cl_sd_616_switch_check=>sd_sfws_report_opt_sdbilldl( ).
  "PERFORM opt_switch USING VBCO7 CHANGING lv_opt_enabled.

  CALL FUNCTION 'RV_READ_INVOICE_INDEX'
    EXPORTING
      comwa                = vbco7
      no_billing_block     = vbco7-no_faksk
      default_billing_type = rv60a-fkart
      opt_enabled          = lv_opt_enabled
    TABLES
      lvkdfi               = p_gt_fvkdfi
      s_kunnr              = p_s_kunnr
      s_vbeln              = p_s_vbeln
      s_lland              = p_s_lland
      s_fkart              = p_s_fkart
      s_sortkri            = p_s_sortkri
      s_vtweg              = p_s_vtweg
      s_spart              = p_s_spart
      s_vstel              = p_s_vstel
    EXCEPTIONS
      OTHERS               = 1.
*END-ENHANCEMENT-SECTION.
  LOOP AT p_gt_fvkdfi.
    IF p_rv60a-fkart IS INITIAL.
      p_gt_fvkdfi-v_fkart = p_gt_fvkdfi-fkart.
    ELSE.
      p_gt_fvkdfi-v_fkart = p_rv60a-fkart.
    ENDIF.
    IF p_gt_fvkdfi-v_fkart <> tvfk-fkart.
      SELECT SINGLE * FROM tvfk WHERE fkart = p_gt_fvkdfi-v_fkart.
      tvfkd_rc = sy-subrc.
      IF sy-subrc = 0.
        IF tvfk-numki <> tvfkd-numki.
          SELECT SINGLE * FROM tvfkd WHERE numki = tvfk-numki.
          tvfkd_rc = sy-subrc.
        ENDIF.
      ENDIF.
    ENDIF.
    IF tvfkd_rc = 0.
      p_gt_fvkdfi-v_fkdat = tvfkd-fkdat.
      IF p_gt_fvkdfi-fktyp = 'A'.
        READ TABLE auftrag WITH KEY p_gt_fvkdfi-vbeln BINARY SEARCH.
        IF sy-subrc = 0.
          p_gt_fvkdfi-v_fkdat = auftrag-fkdat.
        ELSE.
          auftrag-vbeln = p_gt_fvkdfi-vbeln.
          auftrag-fkdat = p_gt_fvkdfi-v_fkdat.
          INSERT auftrag INDEX sy-tabix.
        ENDIF.
      ENDIF.
    ELSE.
      IF p_rv60a-fkdat IS INITIAL.
        p_gt_fvkdfi-v_fkdat = p_gt_fvkdfi-fkdat.
        IF p_gt_fvkdfi-fktyp = 'A'.
          READ TABLE auftrag WITH KEY p_gt_fvkdfi-vbeln BINARY SEARCH.
          IF sy-subrc = 0.
            p_gt_fvkdfi-v_fkdat = auftrag-fkdat.
          ELSE.
            auftrag-vbeln = p_gt_fvkdfi-vbeln.
            auftrag-fkdat = p_gt_fvkdfi-fkdat.
            INSERT auftrag INDEX sy-tabix.
          ENDIF.
        ENDIF.
      ELSE.
        p_gt_fvkdfi-v_fkdat = rv60a-fkdat.
      ENDIF.
    ENDIF.
    MODIFY p_gt_fvkdfi.
  ENDLOOP.

ENDFORM.                               " VKDFS_DATA_COLLECT
*&---------------------------------------------------------------------*
*&      Form  VKDFS_DATA_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_VKDFI  text                                             *
*----------------------------------------------------------------------*
FORM vkdfs_data_display
       TABLES
         p_gt_fvkdfi STRUCTURE vkdfif
       USING
         p_rv60a LIKE rv60a.

  p_gt_fvkdfi-selkz = 'X'.
  MODIFY p_gt_fvkdfi TRANSPORTING selkz WHERE selkz = ' '.

  CALL FUNCTION 'SD_VF04_CALL_CUSTOMER_FUNCTION'
    TABLES
      c_vkdfif = p_gt_fvkdfi
    EXCEPTIONS
      OTHERS   = 1.
  PERFORM reuse_berechtigung_setzen
                      CHANGING gs_sd_alv-save.

  CALL FUNCTION 'VKDFS_ALV_DISPLAY'
    EXPORTING
      i_vkdfs_fieldcat_progname    = 'SDBILLDL'
      i_vkdfs_fieldcat_int_tabname = 'GT_FVKDFI'
      i_vkdfs_fieldcat_inclname    = 'SDBILLDL'
      i_default_data               = p_rv60a
      i_variant                    = gs_sd_alv-variant
      i_save                       = gs_sd_alv-save
    TABLES
      i_fvkdfi                     = p_gt_fvkdfi
    EXCEPTIONS
      OTHERS                       = 1.

ENDFORM.                               " VKDFS_DATA_DISPLAY
*ENHANCEMENT-POINT SDBILLDL_14 SPOTS ES_SDBILLDL STATIC .

*ENHANCEMENT-POINT SDBILLDL_15 SPOTS ES_SDBILLDL STATIC .
