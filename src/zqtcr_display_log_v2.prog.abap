*&---------------------------------------------------------------------*
*& Report  ZQTCR_DISPLAY_LOG
*&
*&---------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_DISPLAY_LOG
*& PROGRAM DESCRIPTION:   Transport log report
*& DEVELOPER:             VDPATABALL
*& CREATION DATE:         04/27/2019
*& OBJECT ID:
*& TRANSPORT NUMBER(S):
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915155
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:SPARIMI
* DATE:  06/03/2019
* DESCRIPTION:Calling ED1 RFC to read the Transport request logs.
*----------------------------------------------------------------------*
REPORT zqtcr_display_log_v2 NO STANDARD PAGE HEADING LINE-SIZE 256 LINE-COUNT 65.
*----INCLUDES --------------------------
INCLUDE zqtcn_display_log_top_v2 IF FOUND.

INCLUDE zqtcn_display_log_scr_v2 IF FOUND.

INCLUDE zqtcn_display_log_f01_v2 IF FOUND.

*--Local Declaration ------
DATA: lst_e070    TYPE e070,
      lv_dir_type TYPE tstrf01-dirtype  VALUE 'T',
      lst_final   TYPE zqtcr_tr_log_opt_str,
      lv_ed1_flag TYPE char3.

DATA: lst_request  TYPE  ctslg_request_info,
      lt_requests  TYPE  ctslg_request_infos,
      lst_settings TYPE  ctslg_settings,
      lv_username  TYPE  e070-as4user,
      lv_transport TYPE  char10.
*====================================================================*
* INITIALIZATION.
*====================================================================*
INITIALIZATION.
  PERFORM initialization.
  PERFORM read_object_table     TABLES gt_object_texts.
*====================================================================*
* AT SELECTION-SCREEN.
*====================================================================*
AT SELECTION-SCREEN.
  PERFORM selection_screen.
  PERFORM f_dynamic_screen.
*====================================================================*
* AT SELECTION-SCREEN OUTPUT.
*====================================================================*
AT SELECTION-SCREEN OUTPUT.
  PERFORM f_dynamic_screen.
*====================================================================*
* AT SELECTION-SCREEN ON <FIELD>.
*====================================================================*
AT SELECTION-SCREEN ON p_objta.
  PERFORM at_selection_screen_on_field    USING 'OBJECTA'.

AT SELECTION-SCREEN ON p_objtb.
  PERFORM at_selection_screen_on_field    USING 'OBJECTB'.

AT SELECTION-SCREEN ON p_objtc.
  PERFORM at_selection_screen_on_field    USING 'OBJECTC'.
*====================================================================*
* S T A R T - O F - S E L E C T I O N
*====================================================================*
START-OF-SELECTION.
  IF s_trkorr IS NOT INITIAL.
*---Removing the Spaces
    LOOP AT s_trkorr ASSIGNING FIELD-SYMBOL(<fs_trkorr>).
      CONDENSE <fs_trkorr>-low.
      CLEAR lv_transport.
      lv_transport = <fs_trkorr>-low.
      IF lv_transport IS NOT INITIAL .
        <fs_trkorr>-low = lv_transport.
        CLEAR lv_transport.
      ENDIF.
      CLEAR lv_transport.
      CONDENSE <fs_trkorr>-high.
      lv_transport = <fs_trkorr>-high.
      IF lv_transport IS NOT INITIAL .
        <fs_trkorr>-high = lv_transport.
        CLEAR lv_transport.
      ENDIF.
      IF <fs_trkorr>-low IS NOT INITIAL.
        IF <fs_trkorr>-low+0(3) = c_ed1.
          lv_ed1_flag = c_ed1.
        ENDIF.
      ENDIF.
      CLEAR lv_transport.
    ENDLOOP.
  ENDIF.
  IF ( s_date[] IS INITIAL AND s_trkorr[] IS INITIAL AND s_des[] IS INITIAL
     AND s_user[] IS INITIAL AND s_inc[] IS INITIAL AND gt_obsel[] IS INITIAL ).
    MESSAGE text-067 TYPE c_s.
  ELSE.
    PERFORM get_data_log.
    IF p_ed1 IS NOT INITIAL   ""Calling ED1 system RFC fm to get the TR status.
      OR lv_ed1_flag IS NOT INITIAL.
      PERFORM call_rfc_tr.
    ENDIF.
    IF i_final IS NOT INITIAL.
      REFRESH:gt_obsel[].
      SORT i_final BY trkorr as4user project pgmid object obj_name.
      DELETE ADJACENT DUPLICATES FROM i_final COMPARING trkorr as4user project pgmid object obj_name.
      IF p_ddup IS NOT INITIAL.
        DELETE ADJACENT DUPLICATES FROM i_final COMPARING trkorr as4user.
      ENDIF.
      IF p_mail = abap_true.
        PERFORM f_build_mail.
      ENDIF.
      IF p_disp = abap_true.
        PERFORM f_display.
      ENDIF.
    ELSE.
      MESSAGE text-007 TYPE c_i.
    ENDIF.
  ENDIF.
