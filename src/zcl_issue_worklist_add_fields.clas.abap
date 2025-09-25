class ZCL_ISSUE_WORKLIST_ADD_FIELDS definition
  public
  final
  create public .

*"* public components of class ZCL_ISSUE_WORKLIST_ADD_FIELDS
*"* do not include other source files here!!!
public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_ISM_WORKLIST_ADD_FIELDS .
protected section.
*"* protected components of class ZCL_ISSUE_WORKLIST_ADD_FIELDS
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_ISSUE_WORKLIST_ADD_FIELDS
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_ISSUE_WORKLIST_ADD_FIELDS IMPLEMENTATION.


METHOD if_ism_worklist_add_fields~add_customer_fields.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916413
* REFERENCE NO: ERPM# 835 (E223)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-16
* DESCRIPTION: Additional Field 'ATP Qty' in Media Issue Worklist
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916492
* REFERENCE NO: ERPM# 837 (R096)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-25
* DESCRIPTION: Media Issue Worklist For Planning
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Local Data
*----------------------------------------------------------------------*
  DATA gs_badi_field TYPE jksdbadifield.

**---------------------------------------------------------------------*
** Enhance Fields on MARA-level (e.g: ZZMARATAB-ZZMARAFIELD)
**---------------------------------------------------------------------*
  IF sy-tcode = 'ZSCM_JKSD13_01'.

    gs_badi_field-fieldname = 'ZWKBST'.
    gs_badi_field-xinput    = ' '.
    APPEND gs_badi_field TO gt_badi_fields.
    CLEAR gs_badi_field.

    " BOC: ERPM-10175  KKRAVURI 02-JUNE-2020  ED2K918271
    gs_badi_field-fieldname = 'STATUS'.
    gs_badi_field-xinput    = ' '.
    APPEND gs_badi_field TO gt_badi_fields.
    CLEAR gs_badi_field.
    " EOC: ERPM-10175  KKRAVURI 02-JUNE-2020  ED2K918271

*** BOC: ERPM# 837 KKRAVURI 2019/10/25  ED2K916492
    gs_badi_field-fieldname = 'JOURNAL_CODE'.
    gs_badi_field-xinput    = ' '.
    APPEND gs_badi_field TO gt_badi_fields.
    CLEAR gs_badi_field.

    gs_badi_field-fieldname = 'ML_PYEAR'.
    gs_badi_field-xinput    = ' '.
    APPEND gs_badi_field TO gt_badi_fields.
    CLEAR gs_badi_field.

    gs_badi_field-fieldname = 'BL_PYEAR'.
    gs_badi_field-xinput    = ' '.
    APPEND gs_badi_field TO gt_badi_fields.
    CLEAR gs_badi_field.

    gs_badi_field-fieldname = 'SUB_ACTUAL_PY'.
    gs_badi_field-xinput    = ' '.
    APPEND gs_badi_field TO gt_badi_fields.
    CLEAR gs_badi_field.

    gs_badi_field-fieldname = 'RENEWAL_PER'.
    gs_badi_field-xinput    = ' '.
    APPEND gs_badi_field TO gt_badi_fields.
    CLEAR gs_badi_field.

    gs_badi_field-fieldname = 'NOT_RENEWED_PER'.
    gs_badi_field-xinput    = ' '.
    APPEND gs_badi_field TO gt_badi_fields.
    CLEAR gs_badi_field.

    gs_badi_field-fieldname = 'ML_CYEAR'.
    gs_badi_field-xinput    = ' '.
    APPEND gs_badi_field TO gt_badi_fields.
    CLEAR gs_badi_field.

    gs_badi_field-fieldname = 'REN_CURR_SUBS'.
    gs_badi_field-xinput    = ' '.
    APPEND gs_badi_field TO gt_badi_fields.
    CLEAR gs_badi_field.

    gs_badi_field-fieldname = 'BL_PCURR_YR'.
    gs_badi_field-xinput    = ' '.
    APPEND gs_badi_field TO gt_badi_fields.
    CLEAR gs_badi_field.

    gs_badi_field-fieldname = 'PURCHASE_REQ'.
    gs_badi_field-xinput    = ' '.
    APPEND gs_badi_field TO gt_badi_fields.
    CLEAR gs_badi_field.
*** EOC: ERPM# 837 KKRAVURI 2019/10/25  ED2K916492

  ENDIF.  " IF sy-tcode = 'ZSCM_JKSD13_01'.



ENDMETHOD.


METHOD if_ism_worklist_add_fields~add_fields.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916413
* REFERENCE NO: ERPM# 835 (E223)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-16
* DESCRIPTION: Additional Field 'PUB Year' in Media Issue Worklist
*-----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916492
* REFERENCE NO: ERPM# 837 (R096)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-25
* DESCRIPTION: Media Issue Worklist For Planning
*----------------------------------------------------------------------*

*------------------------------------------------------------------------*
* Local Data
*------------------------------------------------------------------------*
  DATA lst_badi_field TYPE jksdbadifield.

*------------------------------------------------------------------*
* Enhance MARA-Fields
*------------------------------------------------------------------*
* MARA-mediafield: Enhance MARA-ISMYEARNR as output field
  IF sy-tcode = 'ZSCM_JKSD13_01'.
    lst_badi_field-fieldname = 'ISMYEARNR'.
    lst_badi_field-xinput    = ' '.
    APPEND lst_badi_field TO gt_badi_fields.
    CLEAR lst_badi_field.

* BOC: ERPM# 837  KKRAVURI 20191025  ED2K916492
* Enhance MARA-ISMNRINYEAR as output field
    lst_badi_field-fieldname = 'ISMNRINYEAR'.
    lst_badi_field-xinput    = ' '.
    APPEND lst_badi_field TO gt_badi_fields.
    CLEAR lst_badi_field.
* EOC: ERPM# 837  KKRAVURI 20191025  ED2K916492

  ENDIF. " IF sy-tcode = 'ZSCM_JKSD13_01'.

ENDMETHOD.


METHOD if_ism_worklist_add_fields~fill_customer_fields.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K903605
* REFERENCE NO: ERPM# 835 (E223)
* DEVELOPER: Kiran Kumar Ravuri
* DATE: 2019-10-16
* DESCRIPTION: Additional Fields 'ATP Qty' in Media Issue Worklist
*-----------------------------------------------------------------------*

* Local Data
  DATA: lst_worklist  TYPE jksdmaterialstatus,
        lv_av_qty_plt TYPE mng01,
        li_bapiwmdvs  TYPE STANDARD TABLE OF bapiwmdvs,
        li_bapiwmdve  TYPE STANDARD TABLE OF bapiwmdve,
        lv_sytabix    TYPE syst_tabix,
        lv_filter     TYPE string VALUE '(RJKSDWORKLIST)GV_FILT',
        lv_agadt      TYPE string VALUE '(RJKSDWORKLIST)V_AGADT'.

*** Local Constants
  CONSTANTS:
    lc_strog_loc TYPE lgort_d VALUE 'J001',
    lc_unit      TYPE meinh VALUE 'EA'.


  IF sy-tcode = 'ZSCM_JKSD13_01'.

    " Get the Filter Value
    ASSIGN (lv_filter) TO FIELD-SYMBOL(<lv_filter>).
    IF <lv_filter> IS ASSIGNED AND
       <lv_filter> IS INITIAL.
      " Get the Period selection
      ASSIGN (lv_agadt) TO FIELD-SYMBOL(<lv_agadt>).
      IF <lv_agadt> IS ASSIGNED AND
         <lv_agadt> = abap_true.
        " Clear the flag
        <lv_agadt> = abap_false.
        " Below Logic is applicable only when the Period selection
        " is 'Actual GA Date'
        " Logic to derive ATP Qty value
        LOOP AT gt_change_worklist INTO lst_worklist.
          lv_sytabix = sy-tabix.
          CALL FUNCTION 'BAPI_MATERIAL_AVAILABILITY'
            EXPORTING
              plant      = lst_worklist-marc_werks
              material   = lst_worklist-matnr
              unit       = lc_unit                    " MARC_SFMEINS
              stge_loc   = lc_strog_loc
            IMPORTING
              av_qty_plt = lv_av_qty_plt
            TABLES
              wmdvsx     = li_bapiwmdvs
              wmdvex     = li_bapiwmdve.

          READ TABLE li_bapiwmdve INTO DATA(ls_bapiwmdve) INDEX 1.
          IF sy-subrc = 0.
            lst_worklist-zwkbst = ls_bapiwmdve-com_qty.
          ENDIF.

          IF lst_worklist-zwkbst IS NOT INITIAL.
*        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*          EXPORTING
*            input  = lst_worklist-zwkbst
*          IMPORTING
*            output = lst_worklist-zwkbst.
            MODIFY gt_change_worklist FROM lst_worklist INDEX lv_sytabix.
          ENDIF.

          CLEAR: lst_worklist, ls_bapiwmdve, lv_sytabix.
        ENDLOOP. " LOOP AT gt_change_worklist into lst_worklist.

      ENDIF. " IF <lv_agadt> IS ASSIGNED AND

    ELSE.
      " Nothing to do
    ENDIF. " IF <lv_filter> IS ASSIGNED AND


  ENDIF.  " IF sy-tcode = 'ZSCM_JKSD13_01'.



ENDMETHOD.
ENDCLASS.
