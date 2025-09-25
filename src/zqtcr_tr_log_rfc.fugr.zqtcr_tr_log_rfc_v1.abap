FUNCTION zqtcr_tr_log_rfc_v1.
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
*"  TABLES
*"      S_TRKORR STRUCTURE  RSDSSELOPT OPTIONAL
*"      S_DES STRUCTURE  RSDSSELOPT OPTIONAL
*"      S_USER STRUCTURE  RSDSSELOPT OPTIONAL
*"      S_DATE STRUCTURE  RSDSSELOPT OPTIONAL
*"      GT_FINAL TYPE  ZQTCR_TR_LOG_OPT_STR_TT OPTIONAL
*"      GT_OBSEL STRUCTURE  E071 OPTIONAL
*"      GT_OBJECT_TEXTS STRUCTURE  KO100 OPTIONAL
*"      S_INC STRUCTURE  RSDSSELOPT OPTIONAL
*"      GT_ILOG STRUCTURE  ZCA_TR_LOG OPTIONAL
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
        lst_final    TYPE zqtcr_tr_log_opt_str.
*  IF gt_obsel IS NOT INITIAL.
  IF s_trkorr IS NOT INITIAL.
*---Removing the Spaces
    LOOP AT s_trkorr ASSIGNING FIELD-SYMBOL(<fs_trkorr>).
      CONDENSE <fs_trkorr>-low.
      CONDENSE <fs_trkorr>-high.
    ENDLOOP.
  ENDIF.
  IF ( s_date[] IS INITIAL AND s_trkorr[] IS INITIAL AND s_des[] IS INITIAL
       AND s_user[] IS INITIAL AND s_inc[] IS INITIAL AND gt_obsel[] IS INITIAL ).
  ELSE.

    SELECT a~trkorr
            a~trfunction
            a~trstatus
            a~tarsystem
            a~korrdev
            a~as4user
            a~as4date
            a~as4time
            a~strkorr
*         b~as4pos,
*         b~pgmid,
*         b~object,
*         b~obj_name,
*         b~objfunc,
            c~langu
            c~as4text
*         d~attribute,
*         d~reference,
*         e~zrequest,
*         e~zmessage,
*         e~log_num,
*         e~zdate,
*         e~ztime,
*         e~zuname,
*         e~dependency_tr,
*         e~dependency_cr,
*         e~cr_check,
*         e~incident_check,
*         e~incident_no,
*         e~retrofit_check
            INTO CORRESPONDING FIELDS OF  TABLE it_join
            FROM e070 AS a "INNER JOIN e071 AS b ON a~trkorr = b~trkorr
            INNER JOIN e07t AS c ON a~trkorr = c~trkorr
*         LEFT OUTER JOIN e070a AS d ON a~trkorr = d~trkorr
*         LEFT OUTER JOIN zca_tr_log AS e ON a~trkorr = e~zrequest
            WHERE
                a~trkorr IN s_trkorr
            AND a~as4user IN s_user
            AND a~as4date IN s_date
            AND c~langu = sy-langu
            AND c~as4text IN s_des.
*         AND ( d~attribute = @c_att or
*         AND e~incident_no IN @s_inc.
*--If the User Maintain the Description then Fecth from Table E07T
*    IF s_des IS NOT INITIAL.
*      SELECT *
*        FROM e07t
*        INTO TABLE @DATA(lt_e07t)
*      WHERE as4text IN @s_des.
*    ENDIF.
*    IF lt_e07t IS NOT INITIAL .
**----User maintain the description then Join the Two table E07t and E070 Table using For ALL Entries
*      SELECT *
*            FROM e070
*            INTO TABLE @DATA(lt_e070)
*            FOR ALL ENTRIES IN @lt_e07t
*            WHERE trkorr = @lt_e07t-trkorr
*              AND as4user IN @s_user
*              AND as4date IN @s_date.
*    ELSE.
**---If User Not maintain the Description then Fecth fron Table E070
*      SELECT *
*        FROM e070
*        INTO TABLE lt_e070
*        WHERE trkorr  IN s_trkorr
*          AND as4user IN s_user
*      AND as4date IN s_date.
*    ENDIF.
  ENDIF.
  IF it_join IS NOT INITIAL.
    DELETE it_join WHERE strkorr IS NOT INITIAL.
    LOOP AT it_join INTO DATA(lst_e070_tmp).
*---lst_settings work area for Log Overview with Description
      lst_settings-point_to_missing_steps = abap_true.
      lst_settings-detailed_depiction     = abap_true.
      FREE: lst_request, lt_requests.
      lst_request-header-trkorr = lst_e070_tmp-trkorr.
*----Read Individual Parts of a Request (Subsequently)
      CALL FUNCTION 'TRINT_READ_REQUEST_HEADER'
        EXPORTING
          iv_read_e070 = abap_true
          iv_read_e07t = abap_true
        CHANGING
          cs_request   = lst_request-header
        EXCEPTIONS
          OTHERS       = 1.
      IF sy-subrc <> 0.
        lst_request-header-trkorr = lst_e070_tmp-trkorr.
      ENDIF.
*----Below one is the Log Overview FM and This will Fetch the ALL systems Name with Importing Return response code.
      CALL FUNCTION 'TR_READ_GLOBAL_INFO_OF_REQUEST'
        EXPORTING
          iv_trkorr   = lst_e070_tmp-trkorr
          iv_dir_type = lv_dir_type
          is_settings = lst_settings
        IMPORTING
          es_cofile   = lst_request-cofile
          ev_user     = lv_username
          ev_project  = lst_request-project.

      IF lst_request-header-as4user = space.
        lst_request-header-as4user = lv_username.
      ENDIF.
      DATA(lv_des) = lst_request-header-as4text.
      DATA(lv_user) = lst_request-header-as4user.
      IF lst_request-header-trfunction = c_workbench.   " Transport Type
        lst_final-trtype = text-026.
      ELSEIF lst_request-header-trfunction = c_custom.
        lst_final-trtype = text-027.
      ENDIF.
      lst_request-cofile_filled = abap_true.
      APPEND lst_request TO lt_requests.

      IF lt_requests IS NOT  INITIAL AND
        lst_request-cofile-systems IS NOT INITIAL.
        LOOP AT lst_request-cofile-systems INTO DATA(lst_systems).
          CASE lst_systems-systemid.
*---Removing Additional Symbols in the Log table like <,>,!.
              DELETE lst_systems-steps WHERE stepid = c_lessthan.
              DELETE lst_systems-steps WHERE stepid = c_graterthan.
              DELETE lst_systems-steps WHERE stepid = c_exclamation.
            WHEN c_ed1.                                            "ED1 system Status

              PERFORM f_status CHANGING lst_systems
                                        lst_final-ed1
                                        lst_final-ed1date
                                        lst_final-ed1time.
            WHEN c_ed2.                                            "ED2 system Status
              PERFORM f_status CHANGING lst_systems
                                        lst_final-ed2
                                        lst_final-ed2date
                                        lst_final-ed2time.
            WHEN c_eq1.                                            "EQ1 system Status
              PERFORM f_status CHANGING lst_systems
                                      lst_final-eq1
                                      lst_final-eq1date
                                      lst_final-eq1time.
            WHEN c_eq2.                                           "EQ2 system Status
              PERFORM f_status CHANGING lst_systems
                                        lst_final-eq2
                                        lst_final-eq2date
                                        lst_final-eq2time.
            WHEN c_eq3.                                          "EQ3 system Status
              PERFORM f_status CHANGING lst_systems
                                        lst_final-eq3
                                        lst_final-eq3date
                                        lst_final-eq3time.
            WHEN c_ep1.                                          "EP1 system Status
              PERFORM f_status CHANGING lst_systems
                                        lst_final-ep1
                                        lst_final-ep1date
                                        lst_final-ep1time.
            WHEN c_es1.                                          "ES1 system Status
              PERFORM f_status CHANGING lst_systems
                                       lst_final-es1
                                       lst_final-es1date
                                       lst_final-es1time.
          ENDCASE.
        ENDLOOP.
      ENDIF.
******checking if the TR is imported in the system or not.
******if transported then displaying the date and time in the output.
      IF sy-sysid = c_ed1.
        IF lst_e070_tmp-trstatus = c_d.
          lst_final-ed1 = c_yellow.
        ELSE.
          lst_final-ed1 = c_green.
        ENDIF.
        lst_final-ed1date = lst_e070_tmp-as4date.
        lst_final-ed1time = lst_e070_tmp-as4time.
      ELSEIF sy-sysid = c_ed2.
        IF lst_e070_tmp-trstatus = c_d.
          lst_final-ed2 = c_yellow.
        ELSE.
          lst_final-ed2 = c_green.
        ENDIF.
        lst_final-ed2date = lst_e070_tmp-as4date.
        lst_final-ed2time = lst_e070_tmp-as4time.
      ENDIF.
      lst_final-trkorr  = lst_e070_tmp-trkorr.                  " Transport Number
      lst_final-as4text = lv_des.                             " TR Description
      lst_final-as4user = lst_e070_tmp-as4user."lv_user.                            " TR Owner Name
      lst_final-trstatus = lst_e070_tmp-trstatus.                            " TR Owner Name
      lst_final-date     = lst_e070_tmp-AS4DATE.                            " TR Owner Name
      APPEND lst_final TO gt_final.
      CLEAR: lst_final,lv_des,lst_e070_tmp.
    ENDLOOP.
  ENDIF.



**  DATA:  lst_request  TYPE  ctslg_request_info,
**         lt_requests  TYPE  ctslg_request_infos,
**         lst_settings TYPE  ctslg_settings,
**         lst_e070     TYPE e070,
**         lv_dir_type  TYPE   tstrf01-dirtype  VALUE 'T',
**         lv_username  TYPE  e070-as4user,
**         lst_final    TYPE zqtcr_tr_log_opt_str.
**  IF gt_obsel[] IS NOT INITIAL.
**    PERFORM get_data TABLES gt_obsel
**                            s_trkorr
**                            s_des
**                            s_user
**                            s_date
**                            s_inc.
**  ELSEIF gt_obsel[] IS INITIAL.
**
**    IF s_trkorr IS NOT INITIAL.
***---Removing the Spaces
**      LOOP AT s_trkorr ASSIGNING FIELD-SYMBOL(<fs_trkorr>).
**        CONDENSE <fs_trkorr>-low.
**        CONDENSE <fs_trkorr>-high.
***********Check if if there is any TR related to the ED1 system in the Input
***        IF <fs_trkorr>-low+0(3) = c_ed1 OR <fs_trkorr>-high+0(3) = c_ed1.
***          gst_tr = <fs_trkorr>.
***          APPEND gst_tr TO gt_tr.
***          CLEAR:gst_tr.
***        ENDIF.
**      ENDLOOP.
**    ENDIF.
**
***--If the User Maintain the Description then Fecth from Table E07T
**    IF s_des[] IS NOT INITIAL.
**      SELECT *
**        FROM e07t
**        INTO TABLE @DATA(lt_e07t)
**      WHERE trkorr IN @s_trkorr AND
**        as4text IN @s_des.
**    ENDIF.
**    IF lt_e07t IS NOT INITIAL .
***----User maintain the description then Join the Two table E07t and E070 Table using For ALL Entries
**      SELECT *
**            FROM e070
**            INTO TABLE @DATA(lt_e070)
**            FOR ALL ENTRIES IN @lt_e07t
**            WHERE ( trkorr = @lt_e07t-trkorr OR strkorr = @lt_e07t-trkorr )
**              AND as4user IN @s_user
**              AND as4date IN @s_date.
**    ELSE.
***---If User Not maintain the Description then Fecth fron Table E070
**      SELECT *
**        FROM e070
**        INTO TABLE lt_e070
**        WHERE ( trkorr  IN s_trkorr OR strkorr  IN s_trkorr )
**          AND as4user IN s_user
**      AND as4date IN s_date.
**    ENDIF.
**    IF lt_e070 IS NOT INITIAL.
***---If User Not maintain the Description then Fecth fron Table E070
**      SELECT *
**        FROM e071
**        INTO TABLE gt_e071
**        FOR ALL ENTRIES IN lt_e070
**        WHERE ( trkorr  = lt_e070-trkorr OR trkorr  = lt_e070-strkorr ).
**    ENDIF.
**
**  ENDIF.
**  IF gt_e070[] IS NOT INITIAL .
**    lt_e070[] = gt_e070[].
**  ENDIF.
**
**  IF lt_e070[] IS NOT INITIAL.
**    SORT lt_e070 BY trkorr.
**    SELECT * FROM e070a
**             INTO TABLE @DATA(lt_e070a)
**             FOR ALL ENTRIES IN @lt_e070
**             WHERE ( trkorr = @lt_e070-trkorr OR trkorr = @lt_e070-strkorr )
**             AND   attribute = @c_att.
**    REFRESH:gt_ilog[].
***    SELECT * FROM /ibmaccel/ctslog
**    SELECT * FROM zca_tr_log
**           INTO TABLE gt_ilog
**           FOR ALL ENTRIES IN lt_e070
**           WHERE ( zrequest = lt_e070-trkorr OR zrequest = lt_e070-strkorr )
**           AND incident_no IN s_inc.
**  ENDIF.
***  IF lt_e070 IS NOT INITIAL.
**  LOOP AT gt_e071 INTO gs_e071 .
**    READ TABLE lt_e070 INTO lst_e070 WITH KEY trkorr = gs_e071-trkorr BINARY SEARCH.
**    IF sy-subrc = 0 .""AND lst_e070-strkorr IS NOT INITIAL .
***    LOOP AT lt_e070 INTO lst_e070.
***---lst_settings work area for Log Overview with Description
**      lst_settings-point_to_missing_steps = abap_true.
**      lst_settings-detailed_depiction     = abap_true.
**      FREE: lst_request, lt_requests.
**
**      IF lst_e070-strkorr IS INITIAL.
**        lst_final-trkorr  = lst_e070-trkorr.                  " Transport Number
**      ELSE.
**        lst_final-trkorr  = lst_e070-strkorr.                  " Transport Number
**      ENDIF.
***      lst_request-header-trkorr = lst_e070-trkorr.
**      lst_request-header-trkorr = lst_final-trkorr.
***----Read Individual Parts of a Request (Subsequently)
**      CALL FUNCTION 'TRINT_READ_REQUEST_HEADER'
**        EXPORTING
**          iv_read_e070 = abap_true
**          iv_read_e07t = abap_true
**        CHANGING
**          cs_request   = lst_request-header
**        EXCEPTIONS
**          OTHERS       = 1.
**      IF sy-subrc <> 0.
**        lst_request-header-trkorr = lst_e070-trkorr.
**      ENDIF.
**
***----Below one is the Log Overview FM and This will Fetch the ALL systems Name with Importing Return response code.
**      CALL FUNCTION 'TR_READ_GLOBAL_INFO_OF_REQUEST'
**        EXPORTING
***         iv_trkorr   = lst_e070-trkorr
**          iv_trkorr   = lst_final-trkorr
**          iv_dir_type = lv_dir_type
**          is_settings = lst_settings
**        IMPORTING
**          es_cofile   = lst_request-cofile
**          ev_user     = lv_username
**          ev_project  = lst_request-project.
**
**      IF lst_request-header-as4user = space.
**        lst_request-header-as4user = lv_username.
**      ENDIF.
**      DATA(lv_des) = lst_request-header-as4text.
**      DATA(lv_user) = lst_request-header-as4user.
**      IF lst_request-header-trfunction = c_workbench OR
**        lst_request-header-trfunction = c_dev.   " Transport Type
**        lst_final-trtype = text-026.
**      ELSEIF lst_request-header-trfunction = c_custom.
**        lst_final-trtype = text-027.
**      ENDIF.
**      lst_request-cofile_filled = abap_true.
**      APPEND lst_request TO lt_requests.
**
**      IF lt_requests IS NOT  INITIAL AND
**        lst_request-cofile-systems IS NOT INITIAL.
**        LOOP AT lst_request-cofile-systems INTO DATA(lst_systems).
**          CASE lst_systems-systemid.
***---Removing Additional Symbols in the Log table like <,>,!.
**              DELETE lst_systems-steps WHERE stepid = c_lessthan.
**              DELETE lst_systems-steps WHERE stepid = c_graterthan.
**              DELETE lst_systems-steps WHERE stepid = c_exclamation.
**            WHEN c_ed1.                                            "ED1 system Status
**              IF sy-sysid <> c_ed1 OR p_ed1 = abap_true.
**
**                PERFORM f_status CHANGING lst_systems
**                                          lst_final-ed1
**                                          lst_final-ed1date
**                                          lst_final-ed1time.
**              ENDIF.
**            WHEN c_ed2.                                            "ED2 system Status
**
**              IF sy-sysid <> c_ed2 OR p_ed2 = abap_true.
**                PERFORM f_status CHANGING lst_systems
**                                          lst_final-ed2
**                                          lst_final-ed2date
**                                          lst_final-ed2time.
**              ENDIF.
**            WHEN c_eq1.                                            "EQ1 system Status
**              IF p_eq1 = abap_true.
**                PERFORM f_status CHANGING lst_systems
**                                        lst_final-eq1
**                                        lst_final-eq1date
**                                        lst_final-eq1time.
**              ENDIF.
**            WHEN c_eq2.                                           "EQ2 system Status
**              IF p_eq2 = abap_true.
**                PERFORM f_status CHANGING lst_systems
**                                          lst_final-eq2
**                                          lst_final-eq2date
**                                          lst_final-eq2time.
**              ENDIF.
**            WHEN c_eq3.                                          "EQ3 system Status
**              IF p_eq3 = abap_true.
**                PERFORM f_status CHANGING lst_systems
**                                          lst_final-eq3
**                                          lst_final-eq3date
**                                          lst_final-eq3time.
**              ENDIF.
**            WHEN c_ep1.                                          "EP1 system Status
**              IF p_ep1 = abap_true.
**                PERFORM f_status CHANGING lst_systems
**                                          lst_final-ep1
**                                          lst_final-ep1date
**                                          lst_final-ep1time.
**              ENDIF.
**            WHEN c_es1.                                          "ES1 system Status
**              IF p_es1 = abap_true.
**                PERFORM f_status CHANGING lst_systems
**                                         lst_final-es1
**                                         lst_final-es1date
**                                         lst_final-es1time.
**              ENDIF.
**          ENDCASE.
**        ENDLOOP.
**      ENDIF.
********checking if the TR is imported in the system or not.
********if transported then displaying the date and time in the output.
**      IF sy-sysid = c_ed1.
**        IF lst_e070-trstatus = c_d.
**          lst_final-ed1 = c_yellow.
**        ELSE.
**          lst_final-ed1 = c_green.
**        ENDIF.
**        lst_final-ed1date = lst_e070-as4date.
**        lst_final-ed1time = lst_e070-as4time.
**      ELSEIF sy-sysid = c_ed2.
**        IF lst_e070-trstatus = c_d.
**          lst_final-ed2 = c_yellow.
**        ELSE.
**          lst_final-ed2 = c_green.
**        ENDIF.
**        lst_final-ed2date = lst_e070-as4date.
**        lst_final-ed2time = lst_e070-as4time.
**      ENDIF.
**      lst_final-pgmid = gs_e071-pgmid.
**      lst_final-object = gs_e071-object.
**      lst_final-obj_name = gs_e071-obj_name.
**      READ TABLE gt_object_texts INTO DATA(ls_object_text)
**                               WITH KEY object = lst_final-object.
**      IF sy-subrc = 0.
**        lst_final-obj_txt = ls_object_text-text.
**      ENDIF.
***        lst_final-trkorr  = lst_e070-trkorr.                  " Transport Number
**      READ TABLE lt_e070a INTO DATA(ls_e070a) WITH KEY trkorr = lst_final-trkorr.
**      IF sy-subrc = 0.
**        lst_final-project = ls_e070a-reference.
**      ENDIF.
**      READ TABLE gt_ilog INTO gs_ilog WITH KEY zrequest = lst_final-trkorr.
**      IF sy-subrc = 0.
**        lst_final-dependency_tr  = gs_ilog-dependency_tr.
**        lst_final-dependency_cr  = gs_ilog-dependency_cr.
**        lst_final-incident_check = gs_ilog-incident_check.
**        lst_final-incident_no    = gs_ilog-incident_no.
**        lst_final-zmessage       = gs_ilog-zmessage.
**      ENDIF.
**      lst_final-as4text = lv_des.                             " TR Description
**      lst_final-as4user = lv_user.                            " TR Owner Name
**      IF p_ed1 IS NOT INITIAL AND ( p_eds1 IS NOT INITIAL AND p_eds1 = c_o ) AND lst_final-ed1 NE c_yellow.
**        CONTINUE.
**      ELSEIF p_ed1 IS NOT INITIAL AND ( p_eds1 IS NOT INITIAL AND p_eds1 = c_r ) AND lst_final-ed1 NE c_green.
**        CONTINUE.
**      ENDIF.
**
**      IF p_ed2 IS NOT INITIAL AND ( p_eds2 IS NOT INITIAL AND p_eds2 = c_o ) AND lst_final-ed2 NE c_yellow.
**        CONTINUE.
**      ELSEIF p_ed2 IS NOT INITIAL AND ( p_eds2 IS NOT INITIAL AND p_eds2 = c_r ) AND lst_final-ed2 NE c_green.
**        CONTINUE.
**      ENDIF.
**
**      IF p_eq1 IS NOT INITIAL AND ( p_eqs1  IS NOT INITIAL AND p_eqs1 = c_i ) AND lst_final-eq1 NE c_green.
**        CONTINUE.
**      ELSEIF p_eq1 IS NOT INITIAL AND ( p_eqs1 IS NOT INITIAL AND p_eqs1 = c_e ) AND lst_final-eq1 NE c_red.
**        CONTINUE.
**      ENDIF.
**
**      IF p_eq2 IS NOT INITIAL AND ( p_eqs2  IS NOT INITIAL AND p_eqs2 = c_i ) AND lst_final-eq2 NE c_green.
**        CONTINUE.
**      ELSEIF p_eq2 IS NOT INITIAL AND ( p_eqs2 IS NOT INITIAL AND p_eqs2 = c_e ) AND lst_final-eq2 NE c_red.
**        CONTINUE.
**      ENDIF.
**
**      IF p_eq3 IS NOT INITIAL AND ( p_eqs3  IS NOT INITIAL AND p_eqs3 = c_i ) AND lst_final-eq3 NE c_green.
**        CONTINUE.
**      ELSEIF p_eq3 IS NOT INITIAL AND ( p_eqs3 IS NOT INITIAL AND p_eqs3 = c_e ) AND lst_final-eq3 NE c_red.
**        CONTINUE.
**      ENDIF.
**
**      IF p_ep1 IS NOT INITIAL AND ( p_eps1  IS NOT INITIAL AND p_eps1 = c_i ) AND lst_final-ep1 NE c_green.
**        CONTINUE.
**      ELSEIF p_ep1 IS NOT INITIAL AND ( p_eps1 IS NOT INITIAL AND p_eps1 = c_e ) AND lst_final-ep1 NE c_red.
**        CONTINUE.
**      ENDIF.
**
**      IF p_es1 IS NOT INITIAL AND ( p_ess1  IS NOT INITIAL AND p_ess1 = c_i ) AND lst_final-es1 NE c_green.
**        CONTINUE.
**      ELSEIF p_es1 IS NOT INITIAL AND ( p_ess1 IS NOT INITIAL AND p_ess1 = c_e ) AND lst_final-es1 NE c_red.
**        CONTINUE.
**      ENDIF.
**
**      IF lst_final-incident_no IN s_inc[].
**        APPEND lst_final TO gt_final.
**        CLEAR: lst_final,lv_des,lst_e070.
**      ENDIF.
**    ENDIF.
**  ENDLOOP.
ENDFUNCTION.
