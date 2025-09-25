FUNCTION zqtc_bp_interface_agu_i0368 .
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_DATA) TYPE  ZTQTC_BP_INPUT_I0368 OPTIONAL
*"  EXPORTING
*"     VALUE(EX_RETURN) TYPE  ZTQTC_BP_OUTPUT_I0368
*"--------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_BP_INTERFACE_AGU_I0368 (FM)
* PROGRAM DESCRIPTION: Create BP with Comapny Code data,Sales Data,
*                      Collection & Credit management data
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE: 09/10/2019
* OBJECT ID:      I0368
* TRANSPORT NUMBER(S):ED2K916061
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K917990
* REFERENCE NO: ERPM-10797
* DEVELOPER:    Prabhu
* DATE:         4/15/2020
* DESCRIPTION:  Skip Postal code validation for Ireland country
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K917990
* REFERENCE NO: ERPM-10797
* DEVELOPER:    Prabhu
* DATE:         4/15/2020
* DESCRIPTION:  Skip Postal code validation for Ireland country
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K918028
* REFERENCE NO: ERPM-3369
* DEVELOPER:    Prabhu
* DATE:         4/21/2020
* DESCRIPTION:  Update BP address when Indicator is COA(Change of address)
*&---------------------------------------------------------------------*
  i_input[] = im_data[].
  IF i_input[] IS NOT INITIAL.
*----- Clear Global variables
*"----------------------------------------------------------------------
    PERFORM f_clear_global_v.
*"----------------------------------------------------------------------
*----- Get Constants from ZCACONSTANT
*"----------------------------------------------------------------------
    PERFORM f_get_constants.
*"----------------------------------------------------------------------
*----- File data validations
*"----------------------------------------------------------------------
    PERFORM f_file_data_validation.
*"----------------------------------------------------------------------
*-----Fecth Custom tables data
*"----------------------------------------------------------------------
    PERFORM f_get_custom_tables_data.
*"----------------------------------------------------------------------
*-----Process file reords
*"----------------------------------------------------------------------
    LOOP AT i_input INTO st_input.
*"----------------------------------------------------------------------
*-----Variables that needs to be cleared with in loop
*"----------------------------------------------------------------------
      PERFORM f_clear_global_v_2.
*"----------------------------------------------------------------------
      CASE st_input-indicator.
        WHEN c_new.
*"----------------------------------------------------------------------
*-----Input file validations
*"----------------------------------------------------------------------
          PERFORM f_input_bp_validations.
*"----------------------------------------------------------------------
*-----Map input file data to BP deep structures
*"----------------------------------------------------------------------
          CHECK v_error IS INITIAL.
          PERFORM f_map_input_data.
*"----------------------------------------------------------------------
*-----Call AGU BP update FM
*"----------------------------------------------------------------------
          PERFORM f_call_bp_update_fm.
*"----------------------------------------------------------------------
*-----Build return log
*"----------------------------------------------------------------------
          PERFORM f_map_output_return.
*--*BOC ERPM-3369 ED2K918028 Prabhu 5/5/2020
*"----------------------------------------------------------------------
*-----BP Change of address
*"----------------------------------------------------------------------
        WHEN c_coa.
          PERFORM f_bp_coa USING st_input.
        WHEN OTHERS.
      ENDCASE.
*--*EOC ERPM-3369 ED2K918028 Prabhu 5/5/2020
    ENDLOOP.
    ex_return[] = i_output[].
    CLEAR:i_output.
  ENDIF.
ENDFUNCTION.
