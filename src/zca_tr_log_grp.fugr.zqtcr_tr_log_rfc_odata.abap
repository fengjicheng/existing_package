FUNCTION zqtcr_tr_log_rfc_odata.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_TRKORR) TYPE  TRKORR OPTIONAL
*"     VALUE(IM_DES) TYPE  AS4TEXT OPTIONAL
*"     VALUE(IM_USER) TYPE  TR_AS4USER OPTIONAL
*"     VALUE(IM_DATE) TYPE  CHAR10 OPTIONAL
*"     VALUE(P_ED1) TYPE  OAX DEFAULT 'X'
*"     VALUE(P_ED2) TYPE  OAX DEFAULT 'X'
*"     VALUE(P_EQ1) TYPE  OAX DEFAULT 'X'
*"     VALUE(P_EQ2) TYPE  OAX DEFAULT 'X'
*"     VALUE(P_EQ3) TYPE  OAX DEFAULT 'X'
*"     VALUE(P_EP1) TYPE  OAX DEFAULT 'X'
*"     VALUE(P_ES1) TYPE  OAX DEFAULT 'X'
*"  TABLES
*"      GT_FINAL TYPE  ZCA_TR_LOG_OPT_STR_TT OPTIONAL
*"      S_TRKORR STRUCTURE  RSDSSELOPT OPTIONAL
*"      S_DES STRUCTURE  ZQTCR_TR_LOG_DES OPTIONAL
*"      S_USER STRUCTURE  RSDSSELOPT OPTIONAL
*"      S_DATE STRUCTURE  RSDSSELOPT OPTIONAL
*"----------------------------------------------------------------------

  DATA:lt_final TYPE zqtcr_tr_log_opt_str_tt,
       ls_final TYPE zca_tr_log_opt_str.



  CALL FUNCTION 'ZQTCR_TR_LOG_RFC_V2'
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
      gt_final = lt_final.

  IF lt_final IS NOT INITIAL.
    SORT lt_final BY pgmid.
    DELETE lt_final WHERE pgmid = 'CORR'.
    SORT lt_final BY trkorr.
  ENDIF.

  LOOP AT lt_final INTO DATA(lst_final).
    MOVE-CORRESPONDING lst_final TO ls_final.
    APPEND ls_final TO gt_final.
    CLEAR: ls_final, lst_final.
  ENDLOOP.
ENDFUNCTION.
