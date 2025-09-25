*----------------------------------------------------------------------*
***INCLUDE LZQTCR_TR_LOG_RFCF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LST_SYSTEMS  text
*      <--P_LST_FINAL_ED1  text
*      <--P_LST_FINAL_ED1DATE  text
*      <--P_LST_FINAL_ED1TIME  text
*----------------------------------------------------------------------*
FORM f_status CHANGING lst_systems TYPE ctslg_system
                       lv_status   TYPE icon_d
                       lv_date     TYPE as4date
                       lv_time     TYPE as4time.
  CLEAR:lv_status.

  DESCRIBE TABLE lst_systems-steps LINES DATA(lv_lines). " Total Number of Lines in the SYSTEMS-STEPS
  READ TABLE lst_systems-steps INTO DATA(lst_action) INDEX lv_lines.
*  lst_action-rc = lst_systems-rc.
  lst_action-rc = lst_action-rc.
  IF sy-subrc = 0 AND lst_action-stepid = c_genrat.          "G  Generation of ABAPs and Screens
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_version . "V  Version Management: Set I Flags at Import
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_export .   " Export
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_y. "Conversion Program Call for Matchcode Generation
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_o. "Conversion Program Call in Background (SE14 TBATG)
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_a. "Activation of ABAP Dictionary objects
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_x. "Export Application-Defined Objects
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_d. "Import Application-Defined Objects
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_r. "Perform Actions after Activation
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_b. "Activation with TACOB
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_n. "Conversion with TBATG (Upgrade or Transport)
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_q. "Perform Actions Before Activation
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_u. "Evaluation of Conversion Logs
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_s. "Distributor (Compare Program for Inactive Nametabs)
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_j. "Activation of Dictionary Obj. with Inact. Nametab w/o Conv.
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_m. "Activation of ENQU/D, MCOB/ID/OF/OD
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_f. "Create Versions After Import
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_w. "Create Backup Versions before Import
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_p. "Activation of Nametab Entries
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_ext_t. "External Deployment Objects
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_t. "Check Deploy Status
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_c. "HANA deployment for HOTA, HOTO, and HOTP objects
    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.

  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_7. "Execute method (follow-up actions)

    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.
  ELSEIF sy-subrc = 0 AND lst_action-stepid = c_i. "Set I Flags at Import

    PERFORM f_action_status CHANGING lst_action
                                     lv_status
                                     lv_date
                                     lv_time.
  ENDIF.
ENDFORM.

FORM f_action_status CHANGING fp_action TYPE ctslg_step
                              fp_status TYPE icon_d
                              fp_date   TYPE as4date
                              fp_time   TYPE as4time.
  IF fp_action-rc = c_zero OR fp_action-rc = c_four.
    fp_status = c_green.
    fp_date = fp_action-actions[ 1 ]-date.
    fp_time = fp_action-actions[ 1 ]-time.
  ELSEIF fp_action-rc = space .
    fp_status = space.
  ELSE.
    fp_status = c_red.
    fp_date = fp_action-actions[ 1 ]-date.
    fp_time = fp_action-actions[ 1 ]-time.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data TABLES  gt_obsel STRUCTURE e071
                      s_trkorr STRUCTURE rsdsselopt
                      s_des    STRUCTURE rsdsselopt
                      s_user   STRUCTURE rsdsselopt
                      s_date   STRUCTURE rsdsselopt
                      s_inc    STRUCTURE rsdsselopt.
*   SELECT a~trkorr,
*          a~trfunction,
*          a~trstatus,
*          a~tarsystem,
*          a~korrdev,
*          a~as4user,
*          a~as4date,
*          a~as4time,
*          a~strkorr,
*          b~as4pos,
*          b~pgmid,
*          b~object,
*          b~obj_name,
*          b~objfunc,
*          c~langu,
*          c~as4text,
*          d~attribute,
*          d~reference,
*          e~zrequest,
*          e~zmessage,
*          e~log_num,
*          e~zdate,
*          e~ztime,
*          e~zuname,
*          e~dependency_tr,
*          e~dependency_cr,
*          e~cr_check,
*          e~incident_check,
*          e~incident_no,
*          e~retrofit_check
*          INTO TABLE @it_join
*          FROM e070 AS a LEFT OUTER JOIN e071 AS b ON a~trkorr = b~trkorr
*          LEFT OUTER JOIN e07t AS c ON a~trkorr = c~trkorr
*          LEFT OUTER JOIN e070a AS d ON a~trkorr = d~trkorr
*          LEFT OUTER JOIN zca_tr_log AS e ON a~trkorr = e~zrequest
*          FOR ALL ENTRIES IN @gt_obsel
*          WHERE
*              a~trkorr IN @s_trkorr
*          AND a~as4user IN @s_user
*          AND a~as4date IN @s_date
*          AND c~langu = @sy-langu
*          AND c~as4text IN @s_des
*          AND d~attribute = @c_att
*          AND e~incident_no IN @s_inc
*          AND b~pgmid      = @gt_obsel-pgmid
*          AND b~object     = @gt_obsel-object
*          AND b~obj_name   = @gt_obsel-obj_name.
*  CHECK 1 = 2.
  REFRESH:gt_e070[],gt_e071[].
  IF gt_obsel[] IS NOT INITIAL.
    SELECT * FROM e071 INTO TABLE @gt_e071
             FOR ALL ENTRIES IN @gt_obsel
             WHERE trkorr IN @s_trkorr
             AND pgmid      = @gt_obsel-pgmid
             AND object     = @gt_obsel-object
             AND obj_name   = @gt_obsel-obj_name.
    IF sy-subrc = 0 AND s_des[] IS NOT INITIAL.
      SELECT *
        FROM e07t
        INTO TABLE @DATA(lt_e07t)
      WHERE as4text IN @s_des.
      IF lt_e07t IS NOT INITIAL.
*----User maintain the description then Join the Two table E07t and E070 Table using For ALL Entries
        SELECT *
              FROM e070
              INTO TABLE @gt_e070
              FOR ALL ENTRIES IN @lt_e07t
              WHERE ( trkorr = @lt_e07t-trkorr OR strkorr = @lt_e07t-trkorr )
                AND as4user IN @s_user
                AND as4date IN @s_date.
      ENDIF.
    ELSEIF sy-subrc = 0 AND s_des[] IS INITIAL.
*---If User Not maintain the Description then Fecth fron Table E070
      SELECT *
        FROM e070
        INTO TABLE gt_e070
        FOR ALL ENTRIES IN gt_e071
        WHERE ( trkorr = gt_e071-trkorr OR strkorr = gt_e071-trkorr )
          AND as4user IN s_user
          AND as4date IN s_date.
    ENDIF.
  ENDIF.
ENDFORM.
