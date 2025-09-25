
*---------------------------------------------------------------------*
*       CLASS LCL_handler DEFINITION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS LCL_HANDLER DEFINITION.
  PUBLIC SECTION.
    METHODS:
      HANDLE_NEW_SELECTION
        FOR EVENT VARIANT_SELECTED
        OF CL_ISM_REPORT_VARIANT_TREE
        IMPORTING E_VARIANT
                  E_TEXT
                  E_PARAMS,
      HANDLE_ADD_REQUEST
        FOR EVENT REQUEST_FOR_ADD
        OF CL_ISM_REPORT_VARIANT_TREE.
*      HANDLE_CHANGE_REQUEST
*        FOR EVENT REQUEST_FOR_CHANGE
*        OF CL_ISM_REPORT_VARIANT_TREE,
*      DATA_CHANGED
*        FOR EVENT DATA_CHANGED
*        OF CL_ISM_SD_VIEWERDEMANDCHANGE.
ENDCLASS.                    "LCL_HANDLER DEFINITION

*---------------------------------------------------------------------*
*       CLASS LCL_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS LCL_HANDLER IMPLEMENTATION.
*----------------------------------------------------------------------
* New selection in variant tree
*----------------------------------------------------------------------
  METHOD  HANDLE_NEW_SELECTION.
    GV_VTXT   = E_TEXT.
    CONVERT_FROM E_PARAMS.

    gt_params = e_params.                                "TK16012007

*   Trigger PAI for DYNP processing
    CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
      EXPORTING
        NEW_CODE = ' '.

*   ok_code_101 = 'REFRESH'.  "Auswahl Variante neue Selektion          "TK16072009 Hinw. 1365757
    ok_code_101 = 'REFRESH_INTERNAL'.  "Auswahl Variante neue Selektion "TK16072009 Hinw. 1365757

  ENDMETHOD.                    "HANDLE_NEW_SELECTION
*----------------------------------------------------------------------
* Add a new variant to the variant tree
*----------------------------------------------------------------------
  METHOD  HANDLE_ADD_REQUEST.
    DATA: LT_PARAMS TYPE RSPARAMS_TT.
    CONVERT_TO LT_PARAMS.
*    CALL METHOD CHANGE_EXIT->APPEND_VARIANT_PARAMS
*      CHANGING
*        E_PARAMS = LT_PARAMS.
    CALL METHOD GV_VARIANT_TREE->ADD
      EXPORTING
        I_TEXT         = GV_VTXT
        I_PARAMS       = LT_PARAMS
      EXCEPTIONS
        EXISTS_ALREADY = 1
        OTHERS         = 2.
    IF SY-SUBRC = 0.
      MESSAGE S022(JKSDWORKLIST) WITH GV_VTXT.
    ENDIF.
*   Trigger PAI for DYNP processing
    CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
      EXPORTING
        NEW_CODE = ' '.
  ENDMETHOD.                    "HANDLE_ADD_REQUEST
**----------------------------------------------------------------------
** Change a variant in the variant tree
**----------------------------------------------------------------------
*  METHOD  HANDLE_CHANGE_REQUEST.
*    DATA: LT_PARAMS TYPE RSPARAMS_TT.
*    CONVERT_TO LT_PARAMS.
**    CALL METHOD CHANGE_EXIT->APPEND_VARIANT_PARAMS
**      CHANGING
**        E_PARAMS = LT_PARAMS.
*    CALL METHOD GV_VARIANT_TREE->CHANGE
*       EXPORTING
*        I_TEXT           = GV_VTXT
*        I_PARAMS         = LT_PARAMS
*       EXCEPTIONS
*         NOT_EXIST        = 1
*         NOTHING_SELECTED = 2
*         OTHERS           = 3.
*    IF SY-SUBRC = 0.
*      MESSAGE S021(JKSDWORKLIST) WITH GV_VTXT.
*    ENDIF.
**   Trigger PAI for DYNP processing
*    CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE
*      EXPORTING NEW_CODE = ' '.
*  ENDMETHOD.
*----------------------------------------------------------------------
* Data was changed by the user
*----------------------------------------------------------------------
*  METHOD DATA_CHANGED.
*    GV_RECOMMEND_SAVE = 'X'.
*  ENDMETHOD.                    "DATA_CHANGED

ENDCLASS.                    "LCL_HANDLER IMPLEMENTATION
