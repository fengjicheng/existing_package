FUNCTION zqtcr_tr_log_rfc_v2.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(P_ED1) TYPE  OAX OPTIONAL
*"     VALUE(P_ED2) TYPE  OAX OPTIONAL
*"     VALUE(P_EQ1) TYPE  OAX OPTIONAL
*"     VALUE(P_EQ2) TYPE  OAX OPTIONAL
*"     VALUE(P_EQ3) TYPE  OAX OPTIONAL
*"     VALUE(P_EP1) TYPE  OAX OPTIONAL
*"     VALUE(P_ES1) TYPE  OAX OPTIONAL
*"     VALUE(P_EDS1) TYPE  OAX OPTIONAL
*"     VALUE(P_EDS2) TYPE  OAX OPTIONAL
*"     VALUE(P_EQS1) TYPE  OAX OPTIONAL
*"     VALUE(P_EQS2) TYPE  OAX OPTIONAL
*"     VALUE(P_EQS3) TYPE  OAX OPTIONAL
*"     VALUE(P_EPS1) TYPE  OAX OPTIONAL
*"     VALUE(P_ESS1) TYPE  OAX OPTIONAL
*"     VALUE(P_RFIT) TYPE  OAX OPTIONAL
*"  TABLES
*"      S_TRKORR STRUCTURE  RSDSSELOPT OPTIONAL
*"      S_DES STRUCTURE  ZQTCR_TR_LOG_DES OPTIONAL
*"      S_USER STRUCTURE  RSDSSELOPT OPTIONAL
*"      S_DATE STRUCTURE  RSDSSELOPT OPTIONAL
*"      GT_FINAL TYPE  ZQTCR_TR_LOG_OPT_STR_TT OPTIONAL
*"      GT_OBSEL STRUCTURE  E071 OPTIONAL
*"      GT_OBJECT_TEXTS STRUCTURE  KO100 OPTIONAL
*"      S_INC STRUCTURE  RSDSSELOPT OPTIONAL
*"      GT_ILOG STRUCTURE  ZCA_TR_LOG OPTIONAL
*"      GT_RDES STRUCTURE  ZQTCR_TR_LOG_DES OPTIONAL
*"  EXCEPTIONS
*"      RFC_ERROR
*"----------------------------------------------------------------------
*&---------------------------------------------------------------------*
*& PROGRAM NAME:          ZQTCR_TR_LOG_RFC
*& PROGRAM DESCRIPTION:   RFC FM to read the TR logs
*& DEVELOPER:             SPARIMI
*& CREATION DATE:         06/01/2019
*& OBJECT ID:
*& TRANSPORT NUMBER(S):
*&----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

  DATA: lst_request  TYPE  ctslg_request_info,
        lt_requests  TYPE  ctslg_request_infos,
        lst_settings TYPE  ctslg_settings,
        lst_e070     TYPE e070,
        lv_dir_type  TYPE   tstrf01-dirtype  VALUE 'T',
        lv_username  TYPE  e070-as4user,
        lst_final    TYPE zqtcr_tr_log_opt_str,
        ls_rdes      TYPE zqtcr_tr_log_des,
        lv_odata     TYPE char1.

  REFRESH:it_join[].

  IF ( s_date[] IS INITIAL AND s_trkorr[] IS INITIAL AND s_des[] IS INITIAL
     AND s_user[] IS INITIAL AND s_inc[] IS INITIAL AND gt_obsel[] IS INITIAL ).

  ELSE.
    IF s_trkorr IS NOT INITIAL.
*---Removing the Spaces
      LOOP AT s_trkorr ASSIGNING FIELD-SYMBOL(<fs_trkorr>).
        CONDENSE <fs_trkorr>-low.
        CONDENSE <fs_trkorr>-high.
      ENDLOOP.
    ENDIF.
    IF gt_obsel[] IS NOT INITIAL.
      PERFORM get_data_1 TABLES gt_obsel
                              s_trkorr
                              s_des
                              s_user
                              s_date
                              s_inc.
    ELSEIF gt_obsel[] IS INITIAL.
      PERFORM get_data_2 TABLES gt_obsel
                              s_trkorr
                              s_des
                              s_user
                              s_date
                              s_inc.
    ENDIF.

  ENDIF.
  DATA:lv_str1  TYPE string,
       lv_str2  TYPE string,
       lv_fdpos TYPE sy-fdpos,
       ls_num   TYPE c LENGTH 7.
  SORT it_join BY trkorr.
  DATA(it_join_t) = it_join.
  DELETE it_join_t WHERE strkorr IS NOT INITIAL .
  LOOP AT it_join INTO lst_join .""WHERE trkorr in S_TRKORR.
    IF lst_join-strkorr IS INITIAL.
      lst_final-as4text        = lst_join-as4text.
    ELSE.
      READ TABLE it_join_t INTO DATA(lst_join_t) WITH KEY trkorr = lst_join-strkorr.
      IF sy-subrc = 0.
        lst_final-as4text       = lst_join_t-as4text.
      ENDIF.
    ENDIF.
    lst_final-trstatus       = lst_join-trstatus.
    lst_final-dependency_tr  = lst_join-dependency_tr.
    lst_final-dependency_cr  = lst_join-dependency_cr.
    lst_final-incident_check = lst_join-incident_check.
    lst_final-incident_no    = lst_join-incident_no.
    lst_final-zmessage       = lst_join-log_num.
*    lst_final-as4text        = lst_join-as4text.                            " TR Description
    lst_final-date           = lst_join-as4date.                            " TR Description
    lst_final-as4user        = lst_join-as4user.                            " TR Owner Name
    IF p_rfit IS NOT INITIAL.
      DO 5 TIMES.
        IF lst_join-as4text CP '*INC*'.
          sy-fdpos = sy-fdpos + 3.
          MOVE sy-fdpos TO lv_fdpos.
          MOVE lst_join-as4text+sy-fdpos(7) TO ls_num.
          IF ls_num CO '1234567890'.
            CONCATENATE 'INC' ls_num INTO lv_str1."ls_incident.
*            MOVE lst_join-as4text TO ls_ed1-text.
*            MOVE gs_trkorr TO ls_ed1-trkorr.
*            MOVE ls_incident TO ls_ed1-incident.
*            APPEND ls_ed1 TO ed1.
*            CLEAR ls_ed1.
*            APPEND gs_trkorr TO gt_trkorr.
            EXIT.
          ELSE.
            lst_join-as4text = lst_join-as4text+lv_fdpos.
          ENDIF.
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.
*      TRANSLATE lst_join-as4text TO UPPER CASE.
*      REPLACE ALL OCCURRENCES OF c_c4   IN lst_join-as4text WITH c_c4.
*      REPLACE ALL OCCURRENCES OF c_c2   IN lst_join-as4text WITH c_c4.
*      REPLACE ALL OCCURRENCES OF c_c1   IN lst_join-as4text WITH c_c4.
*      REPLACE ALL OCCURRENCES OF c_c3   IN lst_join-as4text WITH c_c4.
*      IF lst_join-as4text CS c_inc.
*        CLEAR:lv_str1,lv_str2.
*        SPLIT lst_join-as4text AT c_inc INTO lv_str1 lv_str2.
*        SPLIT lv_str2 AT c_c2 INTO lv_str1 lv_str2.
      CONDENSE lv_str1 NO-GAPS.
      ls_rdes-sign = c_i.
      ls_rdes-option = 'CP'.
      lst_final-incident_no = lv_str1.
      CONCATENATE c_const  lv_str1 c_const INTO  ls_rdes-low.
      APPEND ls_rdes TO gt_rdes.
*        CLEAR:ls_rdes.
*      ENDIF.
    ENDIF.

    lst_settings-point_to_missing_steps = abap_true.
    lst_settings-detailed_depiction     = abap_true.
    FREE: lst_request, lt_requests.

    IF lst_join-strkorr IS INITIAL.
      lst_final-trkorr  = lst_join-trkorr.                  " Transport Number
    ELSE.
      lst_final-trkorr  = lst_join-strkorr.                  " Transport Number
    ENDIF.
    lst_request-header-trkorr = lst_final-trkorr.

    IF lst_final-trkorr IN s_trkorr[].
    ELSE.
      CLEAR:lst_final.
      CONTINUE.
    ENDIF.

*----Below one is the Log Overview FM and This will Fetch the ALL systems Name with Importing Return response code.
    CALL FUNCTION 'TR_READ_GLOBAL_INFO_OF_REQUEST'
      EXPORTING
        iv_trkorr   = lst_final-trkorr
        iv_dir_type = lv_dir_type
        is_settings = lst_settings
      IMPORTING
        es_cofile   = lst_request-cofile
        ev_user     = lv_username
        ev_project  = lst_request-project.

    IF lst_join-trfunction = c_workbench OR
      lst_join-trfunction = c_dev     OR  " Transport Type
      lst_join-trfunction = c_repair  OR  "Repair
      lst_join-trfunction = c_dev_crt OR  "S  Development/Correction
      lst_join-trfunction = c_cust_tsk.   "Q  Customizing Task
      lst_final-trtype = text-026.
    ELSEIF lst_join-trfunction = c_custom.
      lst_final-trtype = text-027.
    ENDIF.
    lst_request-cofile_filled = abap_true.
    APPEND lst_request TO lt_requests.
    lst_final-project = lst_request-project.

    IF lt_requests IS NOT  INITIAL AND
      lst_request-cofile-systems IS NOT INITIAL.
      LOOP AT lst_request-cofile-systems INTO DATA(lst_systems).
        CASE lst_systems-systemid.
*---Removing Additional Symbols in the Log table like <,>,!.
            DELETE lst_systems-steps WHERE stepid = c_lessthan.
            DELETE lst_systems-steps WHERE stepid = c_graterthan.
            DELETE lst_systems-steps WHERE stepid = c_exclamation.
            DELETE lst_systems-steps WHERE stepid = 'V' ."c_exclamation.
          WHEN c_ed1.                                            "ED1 system Status
            IF sy-sysid <> c_ed1 OR p_ed1 = abap_true.

              PERFORM f_status CHANGING lst_systems
                                        lst_final-ed1
                                        lst_final-ed1date
                                        lst_final-ed1time.
            ENDIF.
          WHEN c_ed2.                                            "ED2 system Status

            IF sy-sysid <> c_ed2 OR p_ed2 = abap_true.
              PERFORM f_status CHANGING lst_systems
                                        lst_final-ed2
                                        lst_final-ed2date
                                        lst_final-ed2time.
            ENDIF.
          WHEN c_eq1.                                            "EQ1 system Status
            IF p_eq1 = abap_true.
              PERFORM f_status CHANGING lst_systems
                                      lst_final-eq1
                                      lst_final-eq1date
                                      lst_final-eq1time.
            ENDIF.
          WHEN c_eq2.                                           "EQ2 system Status
            IF p_eq2 = abap_true.
              PERFORM f_status CHANGING lst_systems
                                        lst_final-eq2
                                        lst_final-eq2date
                                        lst_final-eq2time.
            ENDIF.
          WHEN c_eq3.                                          "EQ3 system Status
            IF p_eq3 = abap_true.
              PERFORM f_status CHANGING lst_systems
                                        lst_final-eq3
                                        lst_final-eq3date
                                        lst_final-eq3time.
            ENDIF.
          WHEN c_ep1.                                          "EP1 system Status
            IF p_ep1 = abap_true.
              PERFORM f_status CHANGING lst_systems
                                        lst_final-ep1
                                        lst_final-ep1date
                                        lst_final-ep1time.
            ENDIF.
          WHEN c_es1.                                          "ES1 system Status
            IF p_es1 = abap_true.
              PERFORM f_status CHANGING lst_systems
                                       lst_final-es1
                                       lst_final-es1date
                                       lst_final-es1time.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDIF.
******checking if the TR is imported in the system or not.
******if transported then displaying the date and time in the output.
    IF sy-sysid = c_ed1.
      IF lst_e070-trstatus = c_d.
        lst_final-ed1 = c_yellow.
      ELSE.
        lst_final-ed1 = c_green.
      ENDIF.
      lst_final-ed1date = lst_join-as4date.
      lst_final-ed1time = lst_join-as4time.
    ELSEIF sy-sysid = c_ed2.
      IF lst_e070-trstatus = c_d.
        lst_final-ed2 = c_yellow.
      ELSE.
        lst_final-ed2 = c_green.
      ENDIF.
      lst_final-ed2date = lst_join-as4date.
      lst_final-ed2time = lst_join-as4time.
    ENDIF.
    lst_final-pgmid = lst_join-pgmid.
    lst_final-object = lst_join-object.
    lst_final-obj_name = lst_join-obj_name.
    READ TABLE gt_object_texts INTO DATA(ls_object_text)
                             WITH KEY object = lst_final-object.
    IF sy-subrc = 0.
      lst_final-obj_txt = ls_object_text-text.
    ENDIF.
*    lst_final-project = lst_join-reference.

    IF p_ed1 IS NOT INITIAL AND ( p_eds1 IS NOT INITIAL AND p_eds1 = c_o ) AND lst_final-ed1 NE c_yellow.
      CONTINUE.
    ELSEIF p_ed1 IS NOT INITIAL AND ( p_eds1 IS NOT INITIAL AND p_eds1 = c_r ) AND lst_final-ed1 NE c_green.
      CONTINUE.
    ENDIF.

    IF p_ed2 IS NOT INITIAL AND ( p_eds2 IS NOT INITIAL AND p_eds2 = c_o ) AND lst_final-ed2 NE c_yellow.
      CONTINUE.
    ELSEIF p_ed2 IS NOT INITIAL AND ( p_eds2 IS NOT INITIAL AND p_eds2 = c_r ) AND lst_final-ed2 NE c_green.
      CONTINUE.
    ENDIF.

    IF p_eq1 IS NOT INITIAL AND ( p_eqs1  IS NOT INITIAL AND p_eqs1 = c_i ) AND lst_final-eq1 NE c_green.
      CONTINUE.
    ELSEIF p_eq1 IS NOT INITIAL AND ( p_eqs1 IS NOT INITIAL AND p_eqs1 = c_e ) AND lst_final-eq1 NE c_red.
      CONTINUE.
    ENDIF.

    IF p_eq2 IS NOT INITIAL AND ( p_eqs2  IS NOT INITIAL AND p_eqs2 = c_i ) AND lst_final-eq2 NE c_green.
      CONTINUE.
    ELSEIF p_eq2 IS NOT INITIAL AND ( p_eqs2 IS NOT INITIAL AND p_eqs2 = c_e ) AND lst_final-eq2 NE c_red.
      CONTINUE.
    ENDIF.

    IF p_eq3 IS NOT INITIAL AND ( p_eqs3  IS NOT INITIAL AND p_eqs3 = c_i ) AND lst_final-eq3 NE c_green.
      CONTINUE.
    ELSEIF p_eq3 IS NOT INITIAL AND ( p_eqs3 IS NOT INITIAL AND p_eqs3 = c_e ) AND lst_final-eq3 NE c_red.
      CONTINUE.
    ENDIF.

    IF p_ep1 IS NOT INITIAL AND ( p_eps1  IS NOT INITIAL AND p_eps1 = c_i ) AND lst_final-ep1 NE c_green.
      CONTINUE.
    ELSEIF p_ep1 IS NOT INITIAL AND ( p_eps1 IS NOT INITIAL AND p_eps1 = c_e ) AND lst_final-ep1 NE c_red.
      CONTINUE.
    ENDIF.

    IF p_es1 IS NOT INITIAL AND ( p_ess1  IS NOT INITIAL AND p_ess1 = c_i ) AND lst_final-es1 NE c_green.
      CONTINUE.
    ELSEIF p_es1 IS NOT INITIAL AND ( p_ess1 IS NOT INITIAL AND p_ess1 = c_e ) AND lst_final-es1 NE c_red.
      CONTINUE.
    ENDIF.

    APPEND lst_final TO gt_final.
    CLEAR: lst_final.
  ENDLOOP.
  FREE:it_join_t.
ENDFUNCTION.
