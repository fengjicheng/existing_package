*----------------------------------------------------------------------*
***INCLUDE LZCA_TR_LOG_GRPF01.
*----------------------------------------------------------------------*
FORM f_status CHANGING lst_systems TYPE ctslg_system
                       lv_status   TYPE icon_d
                       lv_date     TYPE as4date
                       lv_time     TYPE as4time.
  CLEAR:lv_status.

  DESCRIBE TABLE lst_systems-steps LINES DATA(lv_lines). " Total Number of Lines in the SYSTEMS-STEPS
  READ TABLE lst_systems-steps INTO DATA(lst_action) INDEX lv_lines.
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
