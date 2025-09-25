*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MAINTAIN_REPDET_TABL_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CALL_TMG
*&---------------------------------------------------------------------*
*       Call Table Maintenence Generator
*----------------------------------------------------------------------*
*      -->FP_P_VKORG  Sales Organization
*      -->FP_P_VTWEG  Distribution Channel
*      -->FP_P_SPART  Division
*      -->FP_P_DATUM  As-on Date
*      -->FP_CB_ALLF  Display All Fields
*      -->FP_RB_PROD  Material / Product
*      -->FP_RB_PRFT  Profit Center
*      -->FP_RB_DPRD  Default (Product)
*      -->FP_RB_BPID  Sold-to BPID
*      -->FP_RB_CGRP  Customer Group
*      -->FP_RB_DIND  Default (Industry)
*      -->FP_RB_PCDS  Postal Code (Individual)
*      -->FP_RB_PCDR  Postal Code (Range)
*      -->FP_RB_REGN  Region
*      -->FP_RB_LAND  Country
*      -->FP_RB_DGEO  Default (Geography)
*----------------------------------------------------------------------*
FORM f_call_tmg  USING    fp_p_vkorg TYPE vkorg
                          fp_p_vtweg TYPE vtweg
                          fp_p_spart TYPE spart
                          fp_p_bsark TYPE bsark  " ADD:CR#7764 KKRAVURI20181025  ED2K913679
                          fp_p_datum TYPE sydatum
                          fp_cb_allf TYPE char1
                          fp_rb_prod TYPE char1
                          fp_rb_prft TYPE char1
                          fp_rb_dprd TYPE char1
                          fp_rb_bpid TYPE char1
                          fp_rb_sp   TYPE char1  " ADD:CR#7764 KKRAVURI20181025  ED2K913679
                          fp_rb_cgrp TYPE char1
                          fp_rb_dind TYPE char1
                          fp_rb_pcds TYPE char1
                          fp_rb_pcdr TYPE char1
                          fp_rb_regn TYPE char1
                          fp_rb_land TYPE char1
                          fp_rb_dgeo TYPE char1.

  DATA:
    li_sel_list TYPE scprvimsellist,
    li_exc_func TYPE rj_vimexclfun_tab,
    li_header   TYPE scprvimdesc,
    li_namtab   TYPE scprvimnamtab.

  DATA:
    lv_val_date TYPE char10,
    lv_action   TYPE char1.

  WRITE fp_p_datum TO lv_val_date.                    "Convert Date to External format

* Populate Selection range for view maintenance
  PERFORM f_populate_sel_list:
*   Sales organization
    USING c_fld_vkorg c_oprtr_eq fp_p_vkorg  c_scond_and
 CHANGING li_sel_list,
*   Distribution Channel
    USING c_fld_vtweg c_oprtr_eq fp_p_vtweg  c_scond_and
 CHANGING li_sel_list,
*   Division
    USING c_fld_spart c_oprtr_eq fp_p_spart  c_scond_and
 CHANGING li_sel_list.

* BOC: CR#7764 KKRAVURI20181025  ED2K913679
  IF fp_p_bsark IS NOT INITIAL.
*   PO Type
    PERFORM f_populate_sel_list
      USING c_fld_bsark c_oprtr_eq fp_p_bsark  c_scond_and
      CHANGING li_sel_list.
  ELSEIF fp_cb_allf IS INITIAL AND fp_p_bsark IS INITIAL.
*   PO Type
    PERFORM f_populate_sel_list
      USING c_fld_bsark c_oprtr_eq space c_scond_and
      CHANGING li_sel_list.
  ENDIF.
* EOC: CR#7764 KKRAVURI20181025  ED2K913679

  IF fp_cb_allf IS INITIAL.
    IF fp_rb_prod IS NOT INITIAL.                     "Material / Product
      PERFORM f_populate_sel_list:
*       Material / Product
        USING c_fld_matnr c_oprtr_ne space     c_scond_and
     CHANGING li_sel_list,
*       Profit Center
        USING c_fld_prctr c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list.
    ENDIF.

    IF fp_rb_prft IS NOT INITIAL.                     "Profit Center
      PERFORM f_populate_sel_list:
*       Material / Product
        USING c_fld_matnr c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list,
*       Profit Center
        USING c_fld_prctr c_oprtr_ne space     c_scond_and
     CHANGING li_sel_list.
    ENDIF.

    IF fp_rb_dprd IS NOT INITIAL.                     "Default (Product)
      PERFORM f_populate_sel_list:
*       Material / Product
        USING c_fld_matnr c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list,
*       Profit Center
        USING c_fld_prctr c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list.
    ENDIF.

    IF fp_rb_bpid IS NOT INITIAL.                     "Sold-to BPID
      PERFORM f_populate_sel_list:
*       Sold-to BPID
        USING c_fld_kunnr c_oprtr_ne space     c_scond_and
     CHANGING li_sel_list,
*       Customer Group
        USING c_fld_kvgr1 c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list.
    ENDIF.

* BOC: CR#7764 KKRAVURI20181025  ED2K913679
    IF fp_rb_sp IS NOT INITIAL.                     "Ship-to BPID
      PERFORM f_populate_sel_list:
*       Ship-to BPID
        USING c_fld_zsp   c_oprtr_ne space     c_scond_and
     CHANGING li_sel_list,
*       Customer Group
        USING c_fld_kvgr1 c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list.
    ENDIF.
* EOC: CR#7764 KKRAVURI20181025  ED2K913679

    IF fp_rb_cgrp IS NOT INITIAL.                     "Customer Group
      PERFORM f_populate_sel_list:
*       Sold-to BPID
        USING c_fld_kunnr c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list,
* BOC: CR#7764 KKRAVURI20181025  ED2K913679
        " Ship-to BPID
        USING c_fld_zsp   c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list,
* EOC: CR#7764 KKRAVURI20181025  ED2K913679
*       Customer Group
        USING c_fld_kvgr1 c_oprtr_ne space     c_scond_and
     CHANGING li_sel_list.
    ENDIF.

    IF fp_rb_dind IS NOT INITIAL.                     "Default (Industry)
      PERFORM f_populate_sel_list:
*       Sold-to BPID
        USING c_fld_kunnr c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list,
* BOC: CR#7764 KKRAVURI20181025  ED2K913679
        " Ship-to BPID
        USING c_fld_zsp   c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list,
* EOC: CR#7764 KKRAVURI20181025  ED2K913679
*       Customer Group
        USING c_fld_kvgr1 c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list.
    ENDIF.

    IF fp_rb_pcds IS NOT INITIAL.                     "Postal Code (Individual)
      PERFORM f_populate_sel_list:
*       Postal Code (From)
        USING c_fld_pst_f c_oprtr_ne space     c_scond_and
     CHANGING li_sel_list,
*       Postal Code (To)
        USING c_fld_pst_t c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list,
*       Region
        USING c_fld_regio c_oprtr_eq space     space
     CHANGING li_sel_list.
    ENDIF.

    IF fp_rb_pcdr IS NOT INITIAL.                     "Postal Code (Range)
      PERFORM f_populate_sel_list:
*       Postal Code (To)
        USING c_fld_pst_t c_oprtr_ne space     c_scond_and
     CHANGING li_sel_list,
*       Region
        USING c_fld_regio c_oprtr_eq space     space
     CHANGING li_sel_list.
    ENDIF.

    IF fp_rb_regn IS NOT INITIAL.                     "Region
      PERFORM f_populate_sel_list:
*       Postal Code (To)
        USING c_fld_pst_t c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list,
*       Postal Code (From)
        USING c_fld_pst_f c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list,
*       Region
        USING c_fld_regio c_oprtr_ne space     space
     CHANGING li_sel_list.
    ENDIF.

    IF fp_rb_land IS NOT INITIAL.                     "Country
      PERFORM f_populate_sel_list:
*       Postal Code (To)
        USING c_fld_pst_t c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list,
*       Postal Code (From)
        USING c_fld_pst_f c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list,
*       Region
        USING c_fld_regio c_oprtr_eq space     space
     CHANGING li_sel_list.
    ENDIF.

    IF fp_rb_dgeo IS NOT INITIAL.                     "Country
      PERFORM f_populate_sel_list:
*       Postal Code (To)
        USING c_fld_pst_t c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list,
*       Postal Code (From)
        USING c_fld_pst_f c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list,
*       Region
        USING c_fld_regio c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list,
*       Country
        USING c_fld_land1 c_oprtr_eq space     c_scond_and
     CHANGING li_sel_list.
    ENDIF.
  ENDIF.

* Only Display possible, if "Display All Fields" selected
  IF fp_cb_allf IS NOT INITIAL.
    lv_action = c_action_s.                           "Action: Display
    APPEND INITIAL LINE TO li_exc_func ASSIGNING FIELD-SYMBOL(<lst_exc_func>).
    <lst_exc_func>-function = c_fc_aend.              "Function Code: Display -> Change
  ELSE.
    lv_action = c_action_u.                           "Action: Update
  ENDIF.

  CALL FUNCTION 'ZQTC_REPDET_VALUES_SET'
    EXPORTING
      im_rb_prod = fp_rb_prod                         "Material / Product
      im_rb_prft = fp_rb_prft                         "Profit Center
      im_rb_dprd = fp_rb_dprd                         "Default (Product)
      im_rb_bpid = fp_rb_bpid                         "Sold-to BPID
* BOC: CR#7764 KKRAVURI20181025  ED2K913679
      im_bsark   = fp_p_bsark                         "PO Type
      im_rb_sp   = fp_rb_sp                           "Ship-to BPID
* EOC: CR#7764 KKRAVURI20181025  ED2K913679
      im_rb_cgrp = fp_rb_cgrp                         "Customer Group
      im_rb_dind = fp_rb_dind                         "Default (Industry)
      im_rb_pcds = fp_rb_pcds                         "Postal Code (Individual)
      im_rb_pcdr = fp_rb_pcdr                         "Postal Code (Range)
      im_rb_regn = fp_rb_regn                         "Region
      im_rb_land = fp_rb_land                         "Country
      im_rb_dgeo = fp_rb_dgeo                         "Default (Gepgraphy)
      im_cb_allf = fp_cb_allf                         "Display All Fields
      im_p_datum = fp_p_datum.                        "As-on Date

* Call Table Maintenence Generator
  CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
    EXPORTING
      action                       = lv_action        "Action
      view_name                    = c_view_name      "View Name
      check_ddic_mainflag          = abap_true
    TABLES
      dba_sellist                  = li_sel_list      "Selection range for view maintenance
      excl_cua_funct               = li_exc_func      "GUI Functions to be Deactivated Dynamically
    EXCEPTIONS
      client_reference             = 1
      foreign_lock                 = 2
      invalid_action               = 3
      no_clientindependent_auth    = 4
      no_database_function         = 5
      no_editor_function           = 6
      no_show_auth                 = 7
      no_tvdir_entry               = 8
      no_upd_auth                  = 9
      only_show_allowed            = 10
      system_failure               = 11
      unknown_field_in_dba_sellist = 12
      view_not_found               = 13
      maintenance_prohibited       = 14
      OTHERS                       = 15.
  IF sy-subrc NE 0.
*   Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_SEL_LIST
*&---------------------------------------------------------------------*
*       Populate Selection range for view maintenance
*----------------------------------------------------------------------*
*      -->FP_VIEWFIELD    View Field Name
*      -->FP_OPERATOR     Operator
*      -->FP_VALUE        Field Value
*      -->FP_AND_OR       Selection Condition - AND / OR
*      <--FP_LI_SEL_LIST  Selection range for view maintenance
*----------------------------------------------------------------------*
FORM f_populate_sel_list  USING    fp_viewfield   TYPE viewfield
                                   fp_operator    TYPE vsoperator
                                   fp_value       TYPE any
                                   fp_and_or      TYPE vsconj
                          CHANGING fp_li_sel_list TYPE scprvimsellist.

  FIELD-SYMBOLS:
    <lst_sel_list> TYPE vimsellist.

  APPEND INITIAL LINE TO fp_li_sel_list ASSIGNING <lst_sel_list>.
  <lst_sel_list>-viewfield = fp_viewfield.
  <lst_sel_list>-operator  = fp_operator.
  <lst_sel_list>-value     = fp_value.
  <lst_sel_list>-and_or    = fp_and_or.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MODIFY_SCREEN
*&---------------------------------------------------------------------*
*       Modify Selection Screen Display
*----------------------------------------------------------------------*
*      -->FP_CB_ALLF  Display all fields
*      -->FP_RB_BPID  Business Partner / Sold-to Party
*      <--FP_RB_PCDS  Postal Code (Individual)
*      <--FP_RB_PCDR  Postal Code (Range)
*      <--FP_RB_REGN  Region
*      <--FP_RB_LAND  Country
*      <--FP_RB_DGEO  Default (Geography)
*----------------------------------------------------------------------*
FORM f_modify_screen  USING    fp_cb_allf TYPE char1
                               fp_rb_bpid TYPE char1
                               fp_rb_sp   TYPE char1
                      CHANGING fp_rb_pcds TYPE char1
                               fp_rb_pcdr TYPE char1
                               fp_rb_regn TYPE char1
                               fp_rb_land TYPE char1
                               fp_rb_dgeo TYPE char1.

  CONSTANTS:
    lc_grp_prd TYPE char3 VALUE 'PRD',                "Radio Buttons - Product
    lc_grp_ind TYPE char3 VALUE 'IND',                "Radio Buttons - Industry/Channel
    lc_grp_geo TYPE char3 VALUE 'GEO',                "Radio Buttons - Geography
    lc_activ_0 TYPE char1 VALUE '0'.                  "Inactive

  LOOP AT SCREEN.
    IF fp_cb_allf    IS NOT INITIAL AND               "Display all fields
     ( screen-group1 EQ lc_grp_prd OR                 "Radio Buttons - Product
       screen-group1 EQ lc_grp_ind OR                 "Radio Buttons - Industry/Channel
       screen-group1 EQ lc_grp_geo ).                 "Radio Buttons - Geography
      screen-active = lc_activ_0.                     "Do not display
      MODIFY SCREEN.
    ENDIF.

    IF ( fp_rb_bpid    IS NOT INITIAL OR
         fp_rb_sp IS NOT INITIAL ) AND               "Business Partner / Sold-to Party
       ( screen-group1 EQ lc_grp_geo ).                 "Radio Buttons - Geography
      screen-input  = lc_activ_0.                     "Not ready for input
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

  IF fp_rb_bpid IS NOT INITIAL OR
     fp_rb_sp IS NOT INITIAL.
    fp_rb_pcds = abap_false.                          "Postal Code (Individual)
    fp_rb_pcdr = abap_false.                          "Postal Code (Range)
    fp_rb_regn = abap_false.                          "Region
    fp_rb_land = abap_false.                          "Country
    fp_rb_dgeo = abap_true.                           "Default (Geography)
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_SALES_ORG
*&---------------------------------------------------------------------*
*       Validate Sales Organization
*----------------------------------------------------------------------*
*      -->FP_P_VKORG  Sales Organization
*----------------------------------------------------------------------*
FORM f_validate_sales_org  USING    fp_p_vkorg TYPE vkorg.

  SELECT SINGLE vkorg
    FROM tvko
    INTO @DATA(lv_vkorg)
   WHERE vkorg EQ @fp_p_vkorg.
  IF sy-subrc NE 0.
*   Message: Invalid Sales Organization Number!
    MESSAGE e012(zqtc_r2).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_DISTR_CHNL
*&---------------------------------------------------------------------*
*       Validate Distribution Channel
*----------------------------------------------------------------------*
*      -->FP_P_VTWEG  Distribution Channel
*----------------------------------------------------------------------*
FORM f_validate_distr_chnl  USING    fp_p_vtweg TYPE vtweg.

  SELECT SINGLE vtweg
    FROM tvtw
    INTO @DATA(lv_vtweg)
   WHERE vtweg EQ @fp_p_vtweg.
  IF sy-subrc NE 0.
*   Message: Invalid Distribution Channel!
    MESSAGE e013(zqtc_r2).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_DIVISION
*&---------------------------------------------------------------------*
*       Validate Sales Division
*----------------------------------------------------------------------*
*      -->FP_P_SPART  Sales Division
*----------------------------------------------------------------------*
FORM f_validate_division  USING    fp_p_spart TYPE spart.

  SELECT SINGLE spart
    FROM tspa
    INTO @DATA(lv_spart)
   WHERE spart EQ @fp_p_spart.
  IF sy-subrc NE 0.
*   Message: Invalid Division!
    MESSAGE e021(zqtc_r2).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DD_LIST
*&---------------------------------------------------------------------*
*       Populate drop down
*----------------------------------------------------------------------*
FORM f_populate_dd_list.

*Local data declarations
  DATA: li_vrm_values TYPE vrm_values,        " Value table
        lst_list      TYPE vrm_value.         " Value structure

* local constants
  CONSTANTS:
    lc_po_type TYPE vrm_id  VALUE 'P_BSARK',  " Name of Value Set
    lc_param1  TYPE rvari_vnam VALUE 'PO_TYPE',
    lc_param2  TYPE rvari_vnam VALUE 'BSARK',
    lc_devid   TYPE zdevid     VALUE 'E129'.


  SELECT devid, param1, param2, srno, low, high, description
         FROM zcaconstant INTO TABLE @i_zcaconstant
         WHERE devid = @lc_devid AND
               param1 = @lc_param1 AND
               param2 = @lc_param2 AND
               activate = @abap_true.
  IF i_zcaconstant[] IS NOT INITIAL.
    SORT i_zcaconstant BY low.
    LOOP AT i_zcaconstant INTO DATA(lst_caconstant).
      lst_list-key = lst_caconstant-low.
      lst_list-text = lst_caconstant-description.
      APPEND lst_list TO li_vrm_values.

      CLEAR: lst_caconstant, lst_list.
    ENDLOOP.
  ENDIF.

* Value Request Manager: Set new Values for Valueset
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = lc_po_type      " Name of Value Set
      values          = li_vrm_values   " Value table
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
  IF sy-subrc EQ 0.
*    Nothing to do
  ENDIF.

ENDFORM.
