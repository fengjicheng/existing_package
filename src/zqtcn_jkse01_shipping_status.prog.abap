*&---------------------------------------------------------------------*
*&  Include           ZQTCN_JKSE01_SHIPPING_STATUS
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_JKSE01_SHIPPING_STATUS (Include)
* PROGRAM DESCRIPTION: Validation based on Media issue to restrict
*                      shipping schedule planning in JKSE01 or JKSE02 Tcodes.
* DEVELOPER: Nikhiesh Palla (NPALLA)
* CREATION DATE:   08-APR-2022
* OBJECT ID: E139 (OTCM-55733)
* TRANSPORT NUMBER(S): ED2K926692 / ED2K927453
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
* ZCACONSTANT Table entries
TYPES : BEGIN OF lty_constants,
          devid  TYPE zdevid,                                        "Devid
          param1 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
          param2 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
          srno   TYPE tvarv_numb,                                   "Current selection number
          sign   TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
          opti   TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
          high   TYPE salv_de_selopt_high,                          "higher Value of Selection Condition
        END OF lty_constants.
* Range Table for Issue Type (Supplimentary Issue)
TYPES : BEGIN OF ty_issue,
          sign   TYPE tvarv_sign,
          option TYPE tvarv_opti,
          low    TYPE char1,
          high   TYPE char1,
        END OF ty_issue.
* Range Table for Std.Issue Var.Type
TYPES : BEGIN OF ty_issue_vartype,
          sign   TYPE tvarv_sign,
          option TYPE tvarv_opti,
          low    TYPE ismausgvartyppl,
          high   TYPE ismausgvartyppl,
        END OF ty_issue_vartype.

DATA: li_constants  TYPE STANDARD TABLE OF lty_constants.           "Itab for constants
* Range Internal Tables:
DATA: lr_issue         TYPE STANDARD TABLE OF ty_issue.             "rjksd_issue_range_tab Supplimentary Media Issue
DATA: lr_issue_vartype TYPE STANDARD TABLE OF ty_issue_vartype.     "Std.Issue Var.Type
DATA: lr_new_status    TYPE rjkse_nipstatus_range_tab.              "IS-M: Range Table for JNIPSTATUS

DATA: lv_id    TYPE ism_nip_id.               "NIP ID
DATA: lv_issue TYPE ismmatnr_issue,           "Media Issue
      lv_status TYPE jnipstatus.              "Status of Shipping Plan
DATA: lv_issuetypest TYPE ismausgvartyppl.    "Std.Issue Var.Type

CONSTANTS: lc_devid_e139    TYPE zdevid     VALUE 'E139'.       "Development ID
CONSTANTS: lc_issuetype     TYPE rvari_vnam VALUE 'SUPP_ISSUE'. "ISMMATNR_ISSUE'.  "Supplimentary Issue/Media Issue "
CONSTANTS: lc_issue_vartype TYPE rvari_vnam VALUE 'VAR_TYPE'.   "ISMAUSGVARTYPPL'. "Std.Issue Var.Type          " - Exclude
CONSTANTS: lc_new_status    TYPE rvari_vnam VALUE 'NEW_STATUS'. "JNIPSTATUS'.      "Status of Ship.Sched.Record "

* Get Cnonstant values
  SELECT devid,                                                  "Devid
         param1,                                                  "ABAP: Name of Variant Variable
         param2,                                                  "ABAP: Name of Variant Variable
         srno,                                                    "Current selection number
         sign,                                                    "ABAP: ID: I/E (include/exclude values)
         opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
         low,                                                     "Lower Value of Selection Condition
         high                                                     "Upper Value of Selection Condition
    FROM zcaconstant
    INTO TABLE @li_constants
   WHERE devid    EQ @lc_devid_e139                               "Development ID
     AND activate EQ @abap_true.                                  "Only active record
  IF sy-subrc IS INITIAL.
    LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_const_value>).
      CASE <lst_const_value>-param1.
        WHEN lc_issuetype.                                        "Supplimentary Issue
          APPEND INITIAL LINE TO lr_issue ASSIGNING FIELD-SYMBOL(<lst_issue>).
          <lst_issue>-sign   = <lst_const_value>-sign.
          <lst_issue>-option = <lst_const_value>-opti.
          <lst_issue>-low    = <lst_const_value>-low.
          <lst_issue>-high   = <lst_const_value>-high.
        WHEN lc_issue_vartype.
          APPEND INITIAL LINE TO lr_issue_vartype ASSIGNING FIELD-SYMBOL(<lst_issue_vartype>).
          <lst_issue_vartype>-sign   = <lst_const_value>-sign.
          <lst_issue_vartype>-option = <lst_const_value>-opti.
          <lst_issue_vartype>-low    = <lst_const_value>-low.
          <lst_issue_vartype>-high   = <lst_const_value>-high.
        WHEN lc_new_status.
          APPEND INITIAL LINE TO lr_new_status ASSIGNING FIELD-SYMBOL(<lst_new_status>).
          <lst_new_status>-sign   = <lst_const_value>-sign.
          <lst_new_status>-option = <lst_const_value>-opti.
          <lst_new_status>-low    = <lst_const_value>-low.
          <lst_new_status>-high   = <lst_const_value>-high.
        WHEN OTHERS.
*       Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF. " IF sy-subrc IS INITIAL

  IF in_nip IS BOUND.
    lv_id = in_nip->get_id( ).
  ENDIF.

* Validate based on Media issue to restrict shipping schedule planning
  IF lv_id IS NOT INITIAL.
    SELECT SINGLE issue
                  status
      FROM jksenip
      INTO (lv_issue,lv_status)
      WHERE id = lv_id.
    IF sy-subrc = 0 AND lv_issue+8(1) IN lr_issue. "Check if Supplimentary Issue
      SELECT SINGLE ismissuetypest
        FROM mara
        INTO (lv_issuetypest)
        WHERE matnr = lv_issue.
      IF sy-subrc = 0.
        IF lv_issuetypest IN lr_issue_vartype AND  "02 - Exclude
           in_new_status NOT IN lr_new_status.     "00 - Initial
          "Status cannot be changed as Issue Variant Type is "Excluded"
          MESSAGE e615(zqtc_r2) RAISING not_allowed. "e151(jseor) with status_text raising not_allowed.
        ELSEIF lv_issuetypest IN lr_issue_vartype AND "02 - Exclude
               in_new_status  IN lr_new_status.       "00 - Initial
          sy-subrc = 0.
          EXIT.
        ENDIF.
      ENDIF. "IF sy-subrc = 0.
    ENDIF. "IF sy-subrc = 0.
  ENDIF. "IF lv_id IS NOT INITIAL.
