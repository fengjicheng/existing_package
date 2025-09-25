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
REPORT zqtcr_display_log NO STANDARD PAGE HEADING LINE-SIZE 256 LINE-COUNT 65.
*----INCLUDES --------------------------
INCLUDE zqtcn_display_log_top IF FOUND.
INCLUDE zqtcn_display_log_scr IF FOUND.
INCLUDE zqtcn_display_log_f01 IF FOUND.

*--Local Declaration ------
DATA: lst_e070    TYPE e070,
      lv_dir_type TYPE   tstrf01-dirtype  VALUE 'T',
      lst_final   TYPE ty_final.

DATA:  lst_request  TYPE  ctslg_request_info,
       lt_requests  TYPE  ctslg_request_infos,
       lst_settings TYPE  ctslg_settings,
       lv_username  TYPE  e070-as4user.


*====================================================================*
* AT SELECTION-SCREEN OUTPUT.
*====================================================================*
AT SELECTION-SCREEN OUTPUT.
  PERFORM f_dynamic_screen.
*====================================================================*
* S T A R T - O F - S E L E C T I O N
*====================================================================*
START-OF-SELECTION.
  REFRESH:gt_tr[].
  IF s_trkorr IS NOT INITIAL.
*---Removing the Spaces
    LOOP AT s_trkorr ASSIGNING FIELD-SYMBOL(<fs_trkorr>).
      CONDENSE <fs_trkorr>-low.
      CONDENSE <fs_trkorr>-high.
*********Check if if there is any TR related to the ED1 system in the Input
      IF <fs_trkorr>-low+0(3) = c_ed1 OR <fs_trkorr>-high+0(3) = c_ed1.
        gst_tr = <fs_trkorr>.
        APPEND gst_tr TO gt_tr.
        CLEAR:gst_tr.
      ENDIF.
    ENDLOOP.
  ENDIF.

*--If the User Maintain the Description then Fecth from Table E07T
  IF s_des IS NOT INITIAL.
    SELECT *
      FROM e07t
      INTO TABLE @DATA(lt_e07t)
    WHERE as4text IN @s_des.
  ENDIF.
  IF lt_e07t IS NOT INITIAL .
*----User maintain the description then Join the Two table E07t and E070 Table using For ALL Entries
    SELECT *
          FROM e070
          INTO TABLE @DATA(lt_e070)
          FOR ALL ENTRIES IN @lt_e07t
          WHERE trkorr = @lt_e07t-trkorr
            AND as4user IN @s_user
            AND as4date IN @s_date.
  ELSE.
*---If User Not maintain the Description then Fecth fron Table E070
    SELECT *
      FROM e070
      INTO TABLE lt_e070
      WHERE trkorr  IN s_trkorr
        AND as4user IN s_user
    AND as4date IN s_date.
  ENDIF.

  IF lt_e070 IS NOT INITIAL.
    DELETE lt_e070 WHERE strkorr IS NOT INITIAL.
    LOOP AT lt_e070 INTO lst_e070.
*---lst_settings work area for Log Overview with Description
      lst_settings-point_to_missing_steps = abap_true.
      lst_settings-detailed_depiction     = abap_true.
      FREE: lst_request, lt_requests.
      lst_request-header-trkorr = lst_e070-trkorr.
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
        lst_request-header-trkorr = lst_e070-trkorr.
      ENDIF.
*----Below one is the Log Overview FM and This will Fetch the ALL systems Name with Importing Return response code.
      CALL FUNCTION 'TR_READ_GLOBAL_INFO_OF_REQUEST'
        EXPORTING
          iv_trkorr   = lst_e070-trkorr
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
        lst_final-ed1date = lst_e070-as4date.
        lst_final-ed1time = lst_e070-as4time.
      ELSEIF sy-sysid = c_ed2.
        IF lst_e070-trstatus = c_d.
          lst_final-ed2 = c_yellow.
        ELSE.
          lst_final-ed2 = c_green.
        ENDIF.
        lst_final-ed2date = lst_e070-as4date.
        lst_final-ed2time = lst_e070-as4time.
      ENDIF.
      lst_final-trkorr  = lst_e070-trkorr.                  " Transport Number
      lst_final-as4text = lv_des.                             " TR Description
      lst_final-as4user = lv_user.                            " TR Owner Name
      APPEND lst_final TO i_final.
      CLEAR: lst_final,lv_des,lst_e070.
    ENDLOOP.
  ELSE.
*    MESSAGE text-007 TYPE c_e.
  ENDIF.
*====================================================================*
* E N D - O F - S E L E C T I O N
*====================================================================*
END-OF-SELECTION.
***************Begin of changes by sparimi om 06/03/2019*************
************Calling ED1 system RFC fm to get the TR status.
  PERFORM call_rfc_tr.
***************End of changes by sparimi om 06/03/2019*************
  IF i_final IS NOT INITIAL.
    IF p_mail = abap_true.
      PERFORM f_build_mail.
    ENDIF.
    IF p_disp = abap_true.
      PERFORM f_display.
    ENDIF.
  ELSE.
    MESSAGE text-007 TYPE c_e.
  ENDIF.
