*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CUST_ACC_GRP_CONV_SUB
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_CUST_ACC_GRP_CONV_SUB (Include)
* PROGRAM DESCRIPTION: Form declaration
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   08/15/2016
* OBJECT ID:C061
* TRANSPORT NUMBER(S): ED2K902790
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K903934
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:KCHAKRABOR ( Kamalendu Chakraborty )
* DATE:  2016-12-29
* DESCRIPTION: QA Fix
* BOC by KCHAKRABOR on 2016-12-29 ED2K903934 *
* EOC by KCHAKRABOR on 2016-12-29 ED2K903934 *
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_CUSTOMERS
*&---------------------------------------------------------------------*
*       Fetch Customer Numbers
*----------------------------------------------------------------------*
*      -->FP_P_KTOKDF     Customer Account Group (From)
*      -->FP_S_KUNNR      Customer Numbers (Sel Screen)
*      <--FP_I_CUSTOMERS  Customer Numbers
*----------------------------------------------------------------------*
FORM f_fetch_customers  USING    fp_p_ktokdf    TYPE ktokd
                                 fp_s_kunnr     TYPE fiappt_t_kunnr
                        CHANGING fp_i_customers TYPE tt_customer.

* Fetch details from General Data in Customer Master
  SELECT kunnr                                             "Customer Number
    FROM kna1
    INTO TABLE fp_i_customers ##TOO_MANY_ITAB_FIELDS
   WHERE ktokd EQ fp_p_ktokdf                              "Account Group
     AND kunnr IN fp_s_kunnr.                              "Customer Numbers
  IF sy-subrc NE 0.
    MESSAGE i398(00) WITH 'No Customer found with account group'(001) fp_p_ktokdf space space .
*   Display Information Message
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHANGE_ACC_GRP
*&---------------------------------------------------------------------*
*       Change Account Group of the Customers
*----------------------------------------------------------------------*
*      -->FP_P_KTOKDF     Customer Account Group (From)
*      -->FP_P_KTOKDT     Customer Account Group (To)
*      <--FP_I_CUSTOMERS  Customer Numbers
*----------------------------------------------------------------------*
FORM f_change_acc_grp  USING    fp_p_ktokdf    TYPE ktokd
                                fp_p_ktokdt    TYPE ktokd
                       CHANGING fp_i_customers TYPE tt_customer.

  FIELD-SYMBOLS:
    <lst_customer> TYPE ty_customer.

  LOOP AT fp_i_customers ASSIGNING <lst_customer>.
*   Change Account Group of Customer
    CALL FUNCTION 'CUSTOMER_CHANGE_ACCOUNTGROUP'
      EXPORTING
        iv_customer           = <lst_customer>-kunnr       "Customer Number
        iv_acc_group          = fp_p_ktokdt                "Account Group (To)
      EXCEPTIONS
        customer_not_found    = 1
        same_accountgroup     = 2
        no_authority          = 3
        new_required_fields   = 4
        new_suppressed_fields = 5
        change_not_allowed    = 6
        wrong_accountgroup    = 7
        wrong_number          = 8
        internal_error        = 9
        customer_locked       = 10
        OTHERS                = 11.
    IF sy-subrc EQ 0.
      <lst_customer>-stats_ind = c_stats_suc.              "Status Indicator-Success
*     Success Message: Customer &1: Account group &2 has been replaced by &3
      MESSAGE s696(f2)
         WITH <lst_customer>-kunnr                         "Customer Number
              fp_p_ktokdf                                  "Customer Account Group (From)
              fp_p_ktokdt                                  "Customer Account Group (To)
         INTO <lst_customer>-stats_msg.                    "Status Message
    ELSE.
      <lst_customer>-stats_ind = c_stats_err.              "Status Indicator-Error
*     Capture Error Message
      MESSAGE ID sy-msgid                                  "Message Class
            TYPE sy-msgty                                  "Message Type
          NUMBER sy-msgno                                  "Message Number
            WITH sy-msgv1                                  "Message Varaible-1
                 sy-msgv2                                  "Message Varaible-2
                 sy-msgv3                                  "Message Varaible-3
                 sy-msgv4                                  "Message Varaible-4
            INTO <lst_customer>-stats_msg.                 "Status Message
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_ACC_GRP
*&---------------------------------------------------------------------*
*       Validate Customer Account Group
*----------------------------------------------------------------------*
*      -->FP_P_KTOKD  Customer Account Group
*----------------------------------------------------------------------*
FORM f_validate_acc_grp  USING fp_p_ktokd TYPE ktokd.

  DATA:
    lv_ktokd TYPE ktokd.                                   "Customer Account Group
  IF rb_ktokd = abap_true.
* Validate Customer account group
    SELECT SINGLE ktokd                                      "Customer Account Group
      FROM t077d
      INTO lv_ktokd
     WHERE ktokd EQ fp_p_ktokd.
    IF sy-subrc NE 0.
      CLEAR: lv_ktokd.
*   Message: Customer account group &1 is not available; check Customizing settings
* BOC by KCHAKRABOR on 2016-12-29 ED2K903934 *
*    MESSAGE e006(mdg_bs_cust_harm) WITH fp_p_ktokd.
      MESSAGE s006(mdg_bs_cust_harm) WITH space DISPLAY LIKE 'E'.
      STOP.
* EOC by KCHAKRABOR on 2016-12-29 ED2K903934 *
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_COMPARE_ACC_GRPS
*&---------------------------------------------------------------------*
*       Compare Customer Account Group
*----------------------------------------------------------------------*
*      -->FP_RB_KTOKD  Radio Button: Customer Acc Group
*      -->FP_P_KTOKDF  Customer Account Group (From)
*      -->FP_P_KTOKDT  Customer Account Group (To)
*----------------------------------------------------------------------*
FORM f_compare_acc_grps  USING fp_rb_ktokd TYPE char1
                               fp_p_ktokdf TYPE ktokd
                               fp_p_ktokdt TYPE ktokd.

  IF fp_rb_ktokd IS NOT INITIAL AND
     fp_p_ktokdf EQ fp_p_ktokdt.
*   Message: Old and new account groups are the same
    MESSAGE e690(f2).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_STATUS
*&---------------------------------------------------------------------*
*       Display Status Messages
*----------------------------------------------------------------------*
*      -->FP_I_CUSTOMERS  Customer Numbers
*----------------------------------------------------------------------*
FORM f_display_status  USING fp_i_customers TYPE tt_customer.

  DATA:
    lv_col_pos   TYPE i.                                   "Column Position

  DATA:
    li_fieldcat  TYPE slis_t_fieldcat_alv.                 "Field catalog with field descriptions

  DATA:
    lst_layout   TYPE slis_layout_alv.                     "List layout specifications

  FIELD-SYMBOLS:
    <lst_fldcat> TYPE slis_fieldcat_alv.                   "Field catalog with field description

  CONSTANTS:
    lc_fld_stind TYPE slis_fieldname VALUE 'STATS_IND',    "Field: Status Indicator
    lc_fld_cstmr TYPE slis_fieldname VALUE 'KUNNR',        "Field: Customer Number
    lc_fld_messg TYPE slis_fieldname VALUE 'STATS_MSG',    "Field: Status Messages
    lc_cnv_alpha TYPE slis_edit_mask VALUE '==ALPHA',      "Conv Exit: ALPHA
    lc_cb_top    TYPE slis_formname  VALUE 'F_TOP_OF_PAGE'. "Subroutine Name: TOP-OF-PAGE

* List layout specifications
  lst_layout-zebra             = abap_true.                "Striped pattern
  lst_layout-colwidth_optimize = abap_true.                "Column Width Optimization
  lst_layout-lights_fieldname  = lc_fld_stind.             "Fieldname for exception

* Field catalog with field descriptions - Customer Number
  lv_col_pos = lv_col_pos + 1.
  APPEND INITIAL LINE TO li_fieldcat ASSIGNING <lst_fldcat>.
  <lst_fldcat>-col_pos   = lv_col_pos.
  <lst_fldcat>-fieldname = lc_fld_cstmr.
  <lst_fldcat>-edit_mask = lc_cnv_alpha.
  <lst_fldcat>-seltext_l = 'Customer Number'(c01).
  <lst_fldcat>-seltext_m = 'Customer Number'(c01).
  <lst_fldcat>-seltext_s = 'Customer Number'(c01).

* Field catalog with field descriptions - Status Message
  lv_col_pos = lv_col_pos + 1.
  APPEND INITIAL LINE TO li_fieldcat ASSIGNING <lst_fldcat>.
  <lst_fldcat>-col_pos   = lv_col_pos.
  <lst_fldcat>-fieldname = lc_fld_messg.
  <lst_fldcat>-seltext_l = 'Status Message'(c02).
  <lst_fldcat>-seltext_m = 'Status Message'(c02).
  <lst_fldcat>-seltext_s = 'Status Message'(c02).
  IF fp_i_customers[] IS INITIAL.
    LEAVE LIST-PROCESSING.
  ELSE.
* Display ALV Grid
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program     = sy-repid                    "Name of the calling program
        i_callback_top_of_page = lc_cb_top                   "EXIT routine for handling TOP-OF-PAGE
        is_layout              = lst_layout                  "List layout specifications
        it_fieldcat            = li_fieldcat                 "Field catalog with field descriptions
      TABLES
        t_outtab               = fp_i_customers              "Table with data to be displayed
      EXCEPTIONS
        program_error          = 1
        OTHERS                 = 2.
    IF sy-subrc NE 0.
*   Nothing to be done
    ENDIF.
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       Top Of page
*----------------------------------------------------------------------*
*      -->No Parameter
*----------------------------------------------------------------------*
FORM f_top_of_page.

  DATA:
    li_customers TYPE tt_customer,                         "Customer Numbers
    li_lst_headr TYPE slis_t_listheader.                   "List Header (TOP-OF-PAGE)

  DATA:
    lv_total_rec TYPE i,                                   "Total Number of Records
    lv_succs_rec TYPE i,                                   "Number of Success Records
    lv_error_rec TYPE i.                                   "Number of Error Records

  FIELD-SYMBOLS:
    <lst_lheadr> TYPE slis_listheader.                     "Header for top of page

  CONSTANTS:
    lc_typ_sel   TYPE char1 VALUE 'S'.                     "Type: Selection

* Get all the Success records
  li_customers[] = i_customers[].
  DELETE li_customers WHERE stats_ind NE c_stats_suc.

  lv_total_rec = lines( i_customers ).                     "Total Number of Records
  lv_succs_rec = lines( li_customers ).                    "Number of Success Records
  lv_error_rec = lv_total_rec - lv_succs_rec.              "Number of Error Records

  CLEAR: li_customers.

* Total Number of Records
  APPEND INITIAL LINE TO li_lst_headr ASSIGNING <lst_lheadr>.
  <lst_lheadr>-typ = lc_typ_sel.
  <lst_lheadr>-key = 'Total Records:'(h01).
  <lst_lheadr>-info = lv_total_rec.
* Number of Success Records
  APPEND INITIAL LINE TO li_lst_headr ASSIGNING <lst_lheadr>.
  <lst_lheadr>-typ = lc_typ_sel.
  <lst_lheadr>-key = 'Successful Records:'(h02).
  <lst_lheadr>-info = lv_succs_rec.
* Number of Error Records
  APPEND INITIAL LINE TO li_lst_headr ASSIGNING <lst_lheadr>.
  <lst_lheadr>-typ = lc_typ_sel.
  <lst_lheadr>-key = 'Errored Records:'(h03).
  <lst_lheadr>-info = lv_error_rec.

* Display List Header
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_lst_headr.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MODIFY_SCREEN
*&---------------------------------------------------------------------*
*       Modify Field Properties of Selection Screen
*----------------------------------------------------------------------*
*      -->FP_RB_KTOKD  Radio Button: Customer Acc Group
*      -->FP_RB_RLTYP  Radio Button: BP Role
*----------------------------------------------------------------------*
FORM f_modify_screen  USING    fp_rb_ktokd TYPE char1
                               fp_rb_rltyp TYPE char1.

  CONSTANTS:
    lc_ktokd_grp TYPE char3 VALUE 'MI1',                   "Group: Customer Acc Group
    lc_rltyp_grp TYPE char3 VALUE 'MI2',                   "Group: BP Role
    lc_invisible TYPE char1 VALUE '0'.                     "Value: Invisible / Inactive

  LOOP AT SCREEN.
    IF fp_rb_ktokd IS NOT INITIAL.
      IF screen-group1 EQ lc_rltyp_grp.
        screen-active = lc_invisible.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.

    IF fp_rb_rltyp IS NOT INITIAL.
      IF screen-group1 EQ lc_ktokd_grp.
        screen-active = lc_invisible.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_ACC_GRP
*&---------------------------------------------------------------------*
*       Convert Customer Account Group
*----------------------------------------------------------------------*
*      -->FP_RB_KTOKD     Radio Button: Customer Acc Group
*      -->FP_P_KTOKDF     Customer Account Group (From)
*      -->FP_P_KTOKDT     Customer Account Group (To)
*      -->FP_S_KUNNR      Customer Numbers (Sel Screen)
*      <--FP_I_CUSTOMERS  Customer Numbers
*----------------------------------------------------------------------*
FORM f_process_acc_grp  USING    fp_rb_ktokd    TYPE char1
                                 fp_p_ktokdf    TYPE ktokd
                                 fp_p_ktokdt    TYPE ktokd
                                 fp_s_kunnr     TYPE fiappt_t_kunnr
                        CHANGING fp_i_customers TYPE tt_customer.

  IF fp_rb_ktokd IS INITIAL.
    RETURN.
  ENDIF.

* Fetch Customer Numbers
  PERFORM f_fetch_customers USING  fp_p_ktokdf
                                   fp_s_kunnr
                          CHANGING fp_i_customers.

* Change Account Group of the Customers
  PERFORM f_change_acc_grp  USING  fp_p_ktokdf
                                   fp_p_ktokdt
                          CHANGING fp_i_customers.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_BP_ROLE
*&---------------------------------------------------------------------*
*       Convert Business Partner Role
*----------------------------------------------------------------------*
*      -->FP_RB_RLTYP     Radio Button: Business Partner Role
*      -->FP_P_RLTYPF     Business Partner Role (From)
*      -->FP_P_RLTYPT     Business Partner Role (To)
*      -->FP_S_KUNNR      Customer Numbers (Sel Screen)
*      <--FP_I_CUSTOMERS  Customer Numbers
*----------------------------------------------------------------------*
FORM f_process_bp_role  USING    fp_rb_rltyp    TYPE char1
                                 fp_p_rltypf    TYPE bu_partnerrole
                                 fp_p_rltypt    TYPE bu_partnerrole
                                 fp_s_kunnr     TYPE fiappt_t_kunnr
                        CHANGING fp_i_customers TYPE tt_customer.

  DATA:
    li_bp_roles_f TYPE tt_bp_roles,                        "Business Partner Role (From)
    li_bp_roles_t TYPE tt_bp_roles.                        "Business Partner Role (To)

  FIELD-SYMBOLS:
    <lst_bp_role> TYPE ty_bp_roles,                        "Business Partner Role
    <lst_customr> TYPE ty_customer.                        "Customer Number

  IF fp_rb_rltyp IS INITIAL.
    RETURN.
  ENDIF.

* Fetch Business Partners
  PERFORM f_fetch_bus_prtnr USING  fp_p_rltypf
                                   fp_p_rltypt
                                   fp_s_kunnr
                          CHANGING li_bp_roles_f
                                   li_bp_roles_t.

  LOOP AT li_bp_roles_f ASSIGNING <lst_bp_role>.
    READ TABLE li_bp_roles_t TRANSPORTING NO FIELDS
         WITH KEY bus_prtnr = <lst_bp_role>-bus_prtnr
         BINARY SEARCH.
    IF sy-subrc NE 0.
*     Add Business Partner Role
      PERFORM f_add_bp_role USING  fp_p_rltypt
                                   <lst_bp_role>-bus_prtnr
                          CHANGING fp_i_customers.
    ELSE.
      APPEND INITIAL LINE TO fp_i_customers ASSIGNING <lst_customr>.
      <lst_customr>-kunnr = <lst_bp_role>-bus_prtnr.       "Business Partner / Customer
      <lst_customr>-stats_ind = c_stats_suc.               "Status Indicator-Success
*     Success Message: Business partner &1 already exists in role &2
      MESSAGE s204(r1)
         WITH <lst_bp_role>-bus_prtnr                      "Business Partner
              fp_p_rltypt                                  "Business Partner Role (To)
         INTO <lst_customr>-stats_msg.                     "Status Message
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_BUS_PRTNR
*&---------------------------------------------------------------------*
*       Fetch Business Partners
*----------------------------------------------------------------------*
*      -->FP_P_RLTYPF     Business Partner Role (From)
*      -->FP_P_RLTYPT     Business Partner Role (To)
*      -->FP_S_KUNNR      Customer Numbers (Sel Screen)
*      <--FP_I_CUSTOMERS  Customer Numbers
*----------------------------------------------------------------------*
FORM f_fetch_bus_prtnr  USING    fp_p_rltypf      TYPE bu_partnerrole
                                 fp_p_rltypt      TYPE bu_partnerrole
                                 fp_s_kunnr       TYPE fiappt_t_kunnr
                        CHANGING fp_li_bp_roles_f TYPE tt_bp_roles
                                 fp_li_bp_roles_t TYPE tt_bp_roles.

* BP: Roles (From)
  SELECT partner                                           "Business Partner Number
         rltyp                                             "BP Role
         dfval                                             "BP: Differentiation type value
    FROM but100
    INTO TABLE fp_li_bp_roles_f
   WHERE partner IN fp_s_kunnr
     AND rltyp   EQ fp_p_rltypf.
  IF sy-subrc EQ 0.
    SORT fp_li_bp_roles_f BY bus_prtnr.

*   BP: Roles (To)
    SELECT partner                                         "Business Partner Number
           rltyp                                           "BP Role
           dfval                                           "BP: Differentiation type value
      FROM but100
      INTO TABLE fp_li_bp_roles_t
       FOR ALL ENTRIES IN fp_li_bp_roles_f
     WHERE partner EQ fp_li_bp_roles_f-bus_prtnr
       AND rltyp   EQ fp_p_rltypt.
    IF sy-subrc EQ 0.
      SORT fp_li_bp_roles_t BY bus_prtnr.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADD_BP_ROLE
*&---------------------------------------------------------------------*
*       Add Business Partner Role
*----------------------------------------------------------------------*
*      -->FP_P_RLTYPT     Business Partner Role (To)
*      -->FP_BUS_PRTNR    Business Partner Number
*      <--FP_I_CUSTOMERS  Customer Numbers
*----------------------------------------------------------------------*
FORM f_add_bp_role  USING    fp_p_rltypt    TYPE bu_partnerrole
                             fp_bus_prtnr   TYPE bu_partner
                    CHANGING fp_i_customers TYPE tt_customer.

  DATA:
    li_bapireturn TYPE bapiret2_t.                         "Return Messages

  FIELD-SYMBOLS:
    <lst_bapiret> TYPE bapiret2,                           "Return Message
    <lst_customr> TYPE ty_customer.                        "Customer Number

  APPEND INITIAL LINE TO fp_i_customers ASSIGNING <lst_customr>.
  <lst_customr>-kunnr = fp_bus_prtnr.                      "Business Partner / Customer

* SAP BP, BAPI: Add BP Role
  CALL FUNCTION 'BAPI_BUPA_ROLE_ADD_2'
    EXPORTING
      businesspartner     = fp_bus_prtnr                   "Business Partner
      businesspartnerrole = fp_p_rltypt                    "Business Partner Role
    TABLES
      return              = li_bapireturn.                 "Messages
* Check for Message Type: (A)bend
  READ TABLE li_bapireturn ASSIGNING <lst_bapiret>
       WITH KEY type = c_msgty_a.
  IF sy-subrc NE 0.
*   Check for Message Type: (E)rror
    READ TABLE li_bapireturn ASSIGNING <lst_bapiret>
         WITH KEY type = c_msgty_e.
    IF sy-subrc NE 0.                                        "Success
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

      <lst_customr>-stats_ind = c_stats_suc.                 "Status Indicator-Success
*   Success Message: Business partner &1 created in role &2
      MESSAGE s214(r1)
         WITH fp_bus_prtnr                                   "Business Partner
              fp_p_rltypt                                    "Business Partner Role (To)
         INTO <lst_customr>-stats_msg.                       "Status Message
    ELSE.                                                    "Abend / Error
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      <lst_customr>-stats_ind = c_stats_err.                 "Status Indicator-Error
*   Capture Abend / Error Message
      MESSAGE ID <lst_bapiret>-id                            "Message Class
            TYPE <lst_bapiret>-type                          "Message Type
          NUMBER <lst_bapiret>-number                        "Message Number
            WITH <lst_bapiret>-message_v1                    "Message Varaible-1
                 <lst_bapiret>-message_v2                    "Message Varaible-2
                 <lst_bapiret>-message_v3                    "Message Varaible-3
                 <lst_bapiret>-message_v4                    "Message Varaible-4
            INTO <lst_customr>-stats_msg.                    "Status Message
    ENDIF.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    <lst_customr>-stats_ind = c_stats_err.                 "Status Indicator-Error
*   Capture Abend / Error Message
    MESSAGE ID <lst_bapiret>-id                            "Message Class
          TYPE <lst_bapiret>-type                          "Message Type
        NUMBER <lst_bapiret>-number                        "Message Number
          WITH <lst_bapiret>-message_v1                    "Message Varaible-1
               <lst_bapiret>-message_v2                    "Message Varaible-2
               <lst_bapiret>-message_v3                    "Message Varaible-3
               <lst_bapiret>-message_v4                    "Message Varaible-4
          INTO <lst_customr>-stats_msg.                    "Status Message
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_BP_ROLE
*&---------------------------------------------------------------------*
*       Validate Business Partner Role
*----------------------------------------------------------------------*
*      -->FP_P_RLTYP  Business Partner Role
*----------------------------------------------------------------------*
FORM f_validate_bp_role  USING    fp_p_rltyp TYPE bu_partnerrole.

  DATA:
    lv_rltyp TYPE bu_partnerrole.                          "Business Partner Role
  IF rb_rltyp = abap_true.

* Validate Business Partner Role
    SELECT SINGLE role                                       "Business Partner Role
      FROM tb003
      INTO lv_rltyp
     WHERE role EQ fp_p_rltyp.
    IF sy-subrc NE 0.
      CLEAR: lv_rltyp.
*   Message: Please enter a valid partner role
* BOC by KCHAKRABOR on 2016-12-29 ED2K903934 *
*    MESSAGE e351(me) WITH space.
      MESSAGE s351(me) WITH space DISPLAY LIKE 'E'.
      STOP.
* EOC by KCHAKRABOR on 2016-12-29 ED2K903934 *
    ENDIF.
  ENDIF.
ENDFORM.
