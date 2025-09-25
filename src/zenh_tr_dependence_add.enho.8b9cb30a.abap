"Name: \TY:/IBMACCEL/TRANS_DEP_CHECK\IN:IF_EX_CTS_REQUEST_CHECK\ME:CHECK_BEFORE_RELEASE\SE:BEGIN\EI
ENHANCEMENT 0 ZENH_TR_DEPENDENCE_ADD.
*
DATA:  lr_rlv_usr  TYPE RANGE OF tvarv_val INITIAL SIZE 0.
DATA : lst_fields      TYPE STANDARD TABLE OF sval INITIAL SIZE 0,
       ls_fields       TYPE sval,
       ls_task_rel     TYPE zca_tr_log,
       lv_badi_flag    TYPE char01,
       lv_modi_flag    TYPE char01,
       lv_strkorr      TYPE strkorr,
       lv_returncode   TYPE c,
       lv_request      TYPE trkorr,
       lv_answer       TYPE char01,
       gv_trdep_act    TYPE flag,
       gv_tdc_autotrig TYPE flag.

CONSTANTS: lc_rlv_usr           TYPE rvari_vnam  VALUE 'ZIBM_CTS_DEP_CHECK',
           lc_sel_opt           TYPE rsscr_kind  VALUE 'S',
           lc_e                 TYPE enqmode     VALUE 'E',
           lc_tabname1          TYPE tabname     VALUE '/IBMACCEL/CTSLOG',
           lc_fieldname         TYPE fieldname   VALUE 'ZMESSAGE',
           lc_code              TYPE c           VALUE 'A',
           lc_col               TYPE char1       VALUE '5', " Column
           lc_x                 TYPE char01      VALUE 'X',
           lc_tr_dep_chk        TYPE rvari_vnam  VALUE 'ZIBM_TRANSPORT_DEP_CHECKER',
           lc_type_param        TYPE rsscr_kind  VALUE 'P',
           lc_type_selopt       TYPE rsscr_kind  VALUE 'S',
           lc_trdep_valid_users TYPE rvari_vnam  VALUE 'ZIBM_TDC_VALID_USERS',
           lc_tdc_auto          TYPE rvari_vnam  VALUE 'ZIBM_TDC_AUTO_TRIGGER'.

IF gv_trdep_act IS INITIAL.
* Fetch Target System name from /IBMACCEL/CNTRLR table
  SELECT low  "Low value
    FROM /ibmaccel/cntrlr
    INTO gv_trdep_act
   UP TO 1 ROWS
   WHERE name = lc_tr_dep_chk
     AND type = lc_type_param.
  ENDSELECT.
  IF sy-subrc NE 0 OR gv_trdep_act IS INITIAL.
    RETURN.
  ENDIF.
ENDIF.

IF gv_tdc_autotrig IS INITIAL.
  SELECT low  "Low value
   FROM /ibmaccel/cntrlr
   INTO gv_tdc_autotrig
  UP TO 1 ROWS
  WHERE name = lc_tdc_auto
    AND type = lc_type_param.
  ENDSELECT.
  IF sy-subrc NE 0 OR gv_tdc_autotrig IS INITIAL.
    RETURN.
  ENDIF.

ENDIF.
IF lr_rlv_usr[] IS INITIAL.

  SELECT sign "Sign
         opti "Option
         low  "Low value
         high "High value
    FROM /ibmaccel/cntrlr
    INTO TABLE lr_rlv_usr
   WHERE name = lc_trdep_valid_users
     AND type = lc_type_selopt.
  IF sy-subrc NE 0.
    REFRESH: lr_rlv_usr.
    RETURN.
  ENDIF.
ENDIF.

IF sy-uname  IN lr_rlv_usr AND
  lr_rlv_usr IS NOT INITIAL.
* retrieve the task's Higher-level request
  SELECT SINGLE strkorr
    FROM e070
    INTO lv_strkorr
    WHERE trkorr = request.
  IF sy-subrc = 0.
    IF lv_strkorr IS INITIAL . " For eg if the transport is a repackaging transport
      lv_strkorr = request.
    ENDIF.
    lv_badi_flag = lc_x.
*  Exprot flag value so we can check that program is called from BADI
    EXPORT var1 FROM lv_badi_flag TO MEMORY ID 'ZMEM_BADI'.
*   Call Report Program /IBMACCEL/TRANSPORT_DEP_CHECK
    SUBMIT /ibmaccel/transport_dep_check WITH p_treq = lv_strkorr AND RETURN.

    IF sy-subrc = 0.
*   Get Modifiable Status flag
      IMPORT var2 TO lv_modi_flag FROM MEMORY ID 'ZMEM_TASK_MODI'.
      FREE MEMORY ID 'ZMEM_BADI'.
      IF lv_modi_flag = lc_x AND lv_strkorr <> request.
*      Ask for the QA status give popup
        CALL FUNCTION 'POPUP_TO_CONFIRM_WITH_MESSAGE'
          EXPORTING
            diagnosetext1  = 'There is a dependency,For details run the object dependency report'(001)
            textline1      = 'Do you still want to release'(002)
            titel          = 'Dependency check!'(003)
            cancel_display = ' '
          IMPORTING
            answer         = lv_answer.
        IF lv_answer = 'A' OR lv_answer = 'N'.
*Raise Exception
          RAISE cancel.
* If the user has entered Yes, One popup will appear to provide the reason
        ELSEIF lv_answer = 'J'.

          CLEAR :ls_task_rel,lv_returncode.
          CALL FUNCTION 'ZRTR_TR_POP_UP_SCREEN'
            EXPORTING
              trkorr         = lv_strkorr
              sub_task       = request
            IMPORTING
              message        = ls_task_rel-zmessage
              dependency_tr  = ls_task_rel-dependency_tr
              dependency_cr  = ls_task_rel-dependency_cr
              cr_check       = ls_task_rel-cr_check
              incident_check = ls_task_rel-incident_check
              incident_no    = ls_task_rel-incident_no
              return         = lv_returncode.

          IF sy-subrc EQ 0 AND lv_returncode EQ abap_false.
            RAISE cancel.
          ELSEIF sy-subrc EQ 0 AND lv_returncode EQ abap_true.
            ls_fields-value = ls_task_rel-zmessage.
            SUBMIT /ibmaccel/chk_trdepen_sendmail WITH p_trkorr EQ lv_strkorr  "Transport Request
                                                  WITH p_text = ls_fields-value
                                                  AND RETURN.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
RETURN.

ENDENHANCEMENT.
