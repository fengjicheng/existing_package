*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BP_DISABLE_TAX_ID
*&---------------------------------------------------------------------*
*"----------------------------------------------------------------------
* PROGRAM NAME:ZQTCN_BP_DISABLE_TAX_ID
* PROGRAM DESCRIPTION: This Include has been called in FM
*                      ZQTC_CVIC_BUPA_PBO_CVIC88_E238*
* Restricting the chnage of tax category field in BP, to only certain users
* assigned to newlt created authrization object
* DEVELOPER              : Prabhu (PTUFARAM)
* CREATION DATE          : 04/01/2020
* OBJECT ID              : E238/ERPM_10607
* TRANSPORT NUMBER(S)    : ED2K917888
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*&---------------------------------------------------------------------*
DATA : lv_field_group TYPE tbz3w-fldgr VALUE '1938',
       lv_auth_object TYPE ust12-objct VALUE 'ZBP_TAXCAT',
       lv_field       TYPE ust12-field VALUE 'TAXKD'.
TYPES : lty_tbz3r TYPE STANDARD TABLE OF tbz3r.
FIELD-SYMBOLS : <li_tbz3r> TYPE lty_tbz3r.
CONSTANTS: lc_objap    TYPE bu_objap VALUE 'BUPA',
           lc_tabnam   TYPE bu_dynptab VALUE  'GT_KNVI_TC',
           lc_fldnam   TYPE bu_dynpfld VALUE 'TAXKD',
           lc_gt_tbz3r TYPE char50 VALUE '(SAPLBUS5)GT_TBZ3R[]'.

*--*Authorization object check
CALL FUNCTION 'AUTHORITY_CHECK'
  EXPORTING
    user                = sy-uname
    object              = lv_auth_object
    field1              = lv_field
  EXCEPTIONS
    user_dont_exist     = 1
    user_is_authorized  = 2
    user_not_authorized = 3
    user_is_locked      = 4
    OTHERS              = 5.
IF sy-subrc <> 2."user_is_authorized  = 2
*--* Check if User is in edit mode
  IF cvi_bdt_adapter=>get_activity( ) = cvi_bdt_adapter=>activity_change.
*--* Check if User selected any sales area to edit data
    IF cvi_bdt_adapter=>get_current_sales_area( ) IS NOT INITIAL.
*--*Get BUDT configuration info
      ASSIGN (lc_gt_tbz3r) TO <li_tbz3r>.
      IF <li_tbz3r> IS ASSIGNED.
*--*Check if sales area newly entered or editing existing one
        IF cvi_bdt_adapter=>is_sales_area_new( ) = abap_false.
*--*Make Screen input 0 for Tax classification indicator field
          READ TABLE <li_tbz3r> ASSIGNING FIELD-SYMBOL(<lst_tbz3r>)
                                      WITH KEY objap = lc_objap
                                               tabnm = lc_tabnam
                                               fldnm = lc_fldnam
                                               fldgr = lv_field_group.
          IF sy-subrc EQ 0.
            CLEAR : <lst_tbz3r>-xinpt.
            v_modified = abap_true.
          ENDIF.
        ELSE.
*--*Make Screen input 1 for new sales area, if it is modified by this program already
          IF v_modified = abap_true.
            READ TABLE <li_tbz3r> ASSIGNING FIELD-SYMBOL(<lst_tbz3r_2>)
                                       WITH KEY objap = lc_objap
                                                tabnm = lc_tabnam
                                                fldnm = lc_fldnam
                                                fldgr = lv_field_group.
            IF sy-subrc EQ 0.
              <lst_tbz3r_2>-xinpt = abap_true.
            ENDIF. "IF sy-subrc EQ 0.
          ENDIF. "IF v_modified = abap_true.
        ENDIF." IF cvi_bdt_adapter=>is_sales_area_new( ) = abap_false.
      ENDIF." IF <li_tbz3r> IS ASSIGNED.
    ENDIF."IF cvi_bdt_adapter=>get_current_sales_area( ) IS NOT INITIAL.
  ENDIF. " IF cvi_bdt_adapter=>get_activity( ) = cvi_bdt_adapter=>activity_change.
ENDIF."IF Sy-subrc <> 0.
