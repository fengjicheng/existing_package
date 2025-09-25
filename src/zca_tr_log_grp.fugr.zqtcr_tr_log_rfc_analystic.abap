FUNCTION zqtcr_tr_log_rfc_analystic.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(P_ED1) TYPE  OAX DEFAULT 'X'
*"     VALUE(P_ED2) TYPE  OAX DEFAULT 'X'
*"     VALUE(P_EQ1) TYPE  OAX DEFAULT 'X'
*"     VALUE(P_EQ2) TYPE  OAX DEFAULT 'X'
*"     VALUE(P_EQ3) TYPE  OAX DEFAULT 'X'
*"     VALUE(P_EP1) TYPE  OAX DEFAULT 'X'
*"     VALUE(P_ES1) TYPE  OAX DEFAULT 'X'
*"  TABLES
*"      GT_FINAL_CNT TYPE  ZCA_TR_LOG_NUM_STR_TT OPTIONAL
*"      S_TRKORR STRUCTURE  RSDSSELOPT OPTIONAL
*"      S_DES STRUCTURE  ZQTCR_TR_LOG_DES OPTIONAL
*"      S_USER STRUCTURE  RSDSSELOPT OPTIONAL
*"      S_DATE STRUCTURE  RSDSSELOPT OPTIONAL
*"----------------------------------------------------------------------

  DATA:li_final_ed2  TYPE zqtcr_tr_log_opt_str_tt,   "ED2 TR LOg Detaiils
       li_final_ed1  TYPE zqtcr_tr_log_opt_str_tt,   "ED1 TR LOg Detaiils
       li_final_out  TYPE STANDARD TABLE OF ty_final, "All systems output
       lst_final_out TYPE ty_final,                   "All system data work area
       li_final_out1 TYPE STANDARD TABLE OF ty_final,  "Temp table for user wise sorting
       lst_final_cnt TYPE zca_tr_log_num_str,          "final output workarea
       lv_rel_ed1    TYPE char10,
       lv_fail_ed1   TYPE char10,
       lv_opn_ed1    TYPE char10,
       lv_tot_ed1    TYPE char10,
       lv_rel_ed2    TYPE char10,
       lv_fail_ed2   TYPE char10,
       lv_opn_ed2    TYPE char10,
       lv_tot_ed2    TYPE char10,
       lv_suc_eq1    TYPE char10,
       lv_fail_eq1   TYPE char10,
       lv_tot_eq1    TYPE char10,
       lv_suc_eq2    TYPE char10,
       lv_fail_eq2   TYPE char10,
       lv_tot_eq2    TYPE char10,
       lv_tot_ep1    TYPE char10,
       lv_suc_ep1    TYPE char10,
       lv_fail_ep1   TYPE char10,
       lv_suc_eq3    TYPE char10,
       lv_fail_eq3   TYPE char10,
       lv_tot_eq3    TYPE char10,
       lv_rel_es1    TYPE char10,
       lv_fail_es1   TYPE char10,
       lv_opn_es1    TYPE char10,
       lv_tot_es1    TYPE char10.

  FREE:li_final_ed2,
       gt_final_cnt,
       li_final_ed1,
       li_final_out,
       lst_final_out,
       li_final_out1,
       lst_final_cnt,
       lv_rel_ed1,
       lv_fail_ed1,
       lv_opn_ed1,
       lv_tot_ed1,
       lv_rel_ed2,
       lv_fail_ed2,
       lv_opn_ed2,
       lv_tot_ed2,
       lv_suc_eq1,
       lv_fail_eq1,
       lv_tot_eq1,
       lv_suc_eq2,
       lv_fail_eq2,
       lv_tot_eq2,
       lv_tot_ep1,
       lv_suc_ep1,
       lv_fail_ep1,
       lv_suc_eq3,
       lv_fail_eq3,
       lv_tot_eq3,
       lv_rel_es1,
       lv_fail_es1,
       lv_opn_es1,
       lv_tot_es1.

*----ED2 system data into li_final_ed2
  CALL FUNCTION 'ZQTCR_TR_LOG_RFC_V1'
    EXPORTING
      p_ed1    = p_ed1
      p_ed2    = p_ed2
      p_eq1    = p_eq1
      p_eq2    = p_eq2
      p_eq3    = p_eq3
      p_ep1    = p_ep1
      p_es1    = p_es1
    TABLES
      s_trkorr = s_trkorr
      s_des    = s_des
      s_user   = s_user
      s_date   = s_date
      gt_final = li_final_ed2.

*----ED1 system data into li_final_ed1
*  CLEAR p_ed1.
*  IF p_ed1 IS NOT INITIAL.
*    CALL FUNCTION 'ZQTCR_TR_LOG_RFC'
*      DESTINATION c_ed1rfc ""Calling RFC to read the TR log.
*      EXPORTING
*        p_ed1    = p_ed1
*        p_ed2    = p_ed2
*        p_eq1    = p_eq1
*        p_eq2    = p_eq2
*        p_eq3    = p_eq3
*        p_ep1    = p_ep1
*        p_es1    = p_es1
*      TABLES
*        s_trkorr = s_trkorr
*        s_des    = s_des
*        s_user   = s_user
*        s_date   = s_date
*        gt_final = li_final_ed1.
*  ENDIF.
*---consolidated all data into li_final_ed2
  IF li_final_ed1[] IS NOT INITIAL.
    SORT li_final_ed1 BY pgmid.
    DELETE li_final_ed1 WHERE pgmid = 'CORR'.
    APPEND LINES OF li_final_ed1 TO li_final_ed2.
  ENDIF.
  FREE:li_final_ed1.

*---Data Trasfered to required formate from li_final_ed2 to li_final_out
  IF li_final_ed2 IS NOT INITIAL.
    LOOP AT li_final_ed2 INTO DATA(lst_final_ed2).
      MOVE-CORRESPONDING lst_final_ed2 TO lst_final_out.
      APPEND lst_final_out TO li_final_out.
    ENDLOOP.
    FREE li_final_ed2.
  ENDIF.

  SORT li_final_out BY trkorr.
  DELETE ADJACENT DUPLICATES FROM li_final_out COMPARING trkorr.
  IF li_final_out IS NOT INITIAL.
    FREE:li_final_out1,lst_final_out.
    SORT li_final_out BY as4user.
*---User wise count vs systems
    LOOP AT li_final_out INTO lst_final_out.
      APPEND lst_final_out TO li_final_out1.
      AT END OF as4user.
        CLEAR lst_final_out.
        LOOP AT li_final_out1 INTO lst_final_out.
          IF lst_final_out-trstatus IS NOT INITIAL.
            IF lst_final_out-trstatus <> 'D' .
              IF lst_final_out-ed1 = c_green.
                lv_rel_ed1 =  lv_rel_ed1 + 1.
              ENDIF.
              IF lst_final_out-ed1 = c_red.
                lv_fail_ed1 =  lv_fail_ed1 + 1.
              ENDIF.
            ELSE.
              lv_opn_ed1 =  lv_opn_ed1 + 1.
            ENDIF.
          ENDIF.
          lv_tot_ed1 = lv_rel_ed1 + lv_fail_ed1 + lv_opn_ed1.
          IF lst_final_out-trstatus IS NOT INITIAL.
            IF lst_final_out-trstatus <> 'D'.
              IF lst_final_out-ed2 = c_green.
                lv_rel_ed2 =  lv_rel_ed2 + 1.
              ENDIF.
              IF lst_final_out-ed2 = c_red.
                lv_fail_ed2 =  lv_fail_ed2 + 1.
              ENDIF.
            ELSE.
              lv_opn_ed2 =  lv_opn_ed2 + 1.
            ENDIF.
          ENDIF.
          lv_tot_ed2 = lv_rel_ed2 + lv_fail_ed2 + lv_opn_ed2.

          IF lst_final_out-eq1 IS NOT INITIAL.
            IF lst_final_out-eq1 = c_green.
              lv_suc_eq1 =  lv_suc_eq1 + 1.
            ENDIF.
            IF lst_final_out-eq1 = c_red.
              lv_fail_eq1 =  lv_fail_eq1 + 1.
            ENDIF.
            lv_tot_eq1 = lv_suc_eq1 + lv_fail_eq1 .
          ENDIF.
          IF lst_final_out-eq2 IS NOT INITIAL.
            IF lst_final_out-eq2 = c_green.
              lv_suc_eq2 =  lv_suc_eq2 + 1.
            ENDIF.
            IF lst_final_out-eq2 = c_red.
              lv_fail_eq2 =  lv_fail_eq2 + 1.
            ENDIF.
            lv_tot_eq2 = lv_suc_eq2 + lv_fail_eq2 .
          ENDIF.
          IF lst_final_out-eq3 IS NOT INITIAL.
            IF lst_final_out-eq3 = c_green.
              lv_suc_eq3 =  lv_suc_eq3 + 1.
            ENDIF.
            IF lst_final_out-eq3 = c_red.
              lv_fail_eq3 =  lv_fail_eq3 + 1.
            ENDIF.
            lv_tot_eq3 = lv_suc_eq3 + lv_fail_eq3 .
          ENDIF.
          IF lst_final_out-ep1 IS NOT INITIAL.
            IF lst_final_out-ep1 = c_green.
              lv_suc_ep1 =  lv_suc_ep1 + 1.
            ENDIF.
            IF lst_final_out-ep1 = c_red.
              lv_fail_ep1 =  lv_fail_ep1 + 1.
            ENDIF.
            lv_tot_ep1 = lv_suc_ep1 + lv_fail_ep1 .
          ENDIF.
        ENDLOOP.
        lst_final_cnt-as4user = lst_final_out-as4user.
        lst_final_cnt-trkorr  = lst_final_out-trkorr.
        lst_final_cnt-date    = lst_final_out-date.
        lst_final_cnt-trtype  = lst_final_out-trtype.
        lst_final_cnt-as4text = lst_final_out-as4text.

        lst_final_cnt-ed1_rel_cnt   = lv_rel_ed1.
        lst_final_cnt-ed1_fail_cnt  = lv_fail_ed1.
        lst_final_cnt-ed1_opn_cnt   = lv_opn_ed1.
        lst_final_cnt-ed1_tot_cnt   = lv_tot_ed1.

        lst_final_cnt-ed2_rel_cnt   = lv_rel_ed2.
        lst_final_cnt-ed2_fail_cnt  = lv_fail_ed2.
        lst_final_cnt-ed2_opn_cnt   = lv_opn_ed2.
        lst_final_cnt-ed2_tot_cnt   = lv_tot_ed2.

        lst_final_cnt-eq3_suc_cnt   = lv_suc_eq3.
        lst_final_cnt-eq3_fail_cnt  = lv_fail_eq3.
        lst_final_cnt-eq3_tot_cnt   = lv_tot_eq3.

        lst_final_cnt-eq2_suc_cnt   = lv_suc_eq2.
        lst_final_cnt-eq2_fail_cnt  = lv_fail_eq2.
        lst_final_cnt-eq2_tot_cnt   = lv_tot_eq2.

        lst_final_cnt-eq1_suc_cnt   = lv_suc_eq1.
        lst_final_cnt-eq1_fail_cnt  = lv_fail_eq1.
        lst_final_cnt-eq1_tot_cnt   = lv_tot_eq1.

        lst_final_cnt-ep1_suc_cnt   = lv_suc_ep1.
        lst_final_cnt-ep1_fail_cnt  = lv_fail_ep1.
        lst_final_cnt-ep1_tot_cnt   = lv_tot_ep1.
        APPEND lst_final_cnt TO gt_final_cnt.
        FREE: li_final_out1,
             lst_final_out,
             lst_final_cnt,
             lv_rel_ed1,
             lv_fail_ed1,
             lv_opn_ed1,
             lv_tot_ed1,
             lv_rel_ed2,
             lv_fail_ed2,
             lv_opn_ed2,
             lv_tot_ed2,
             lv_suc_eq1,
             lv_fail_eq1,
             lv_tot_eq1,
             lv_suc_eq2,
             lv_fail_eq2,
             lv_tot_eq2,
             lv_tot_ep1,
             lv_suc_ep1,
             lv_fail_ep1,
             lv_suc_eq3,
             lv_fail_eq3,
             lv_tot_eq3,
             lv_rel_es1,
             lv_fail_es1,
             lv_opn_es1,
             lv_tot_es1.
      ENDAT.
    ENDLOOP.

  ENDIF.


ENDFUNCTION.
