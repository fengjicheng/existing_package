FUNCTION zqtc_customer_ib_vch_i0500 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_DATA) TYPE  ZTQTC_CUSTOMER_DATE_INPUTS
*"     VALUE(IM_SOURCE) TYPE  TPM_SOURCE_NAME OPTIONAL
*"     VALUE(IM_GUID) TYPE  IDOCCARKEY OPTIONAL
*"  EXPORTING
*"     VALUE(EX_RETURN) TYPE  ZTQTC_CUSTOMER_DATE_OUTPUTS
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_CUSTOMER_IB_VCH_I0500
* PROGRAM DESCRIPTION: Create BP with Comapny Code data,Sales Data,
*                      Collection & Credit management data
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE: 04/06/2022
* OBJECT ID: I0500
* TRANSPORT NUMBER(S): ED2K926562
*----------------------------------------------------------------------*
  i_input[] = im_data[].
  gv_guid   = im_guid.
  gv_source = im_source.
  IF i_input[] IS NOT INITIAL.
*----- Clear Global variables
*"----------------------------------------------------------------------
    PERFORM f_clear_global_v.
*"----------------------------------------------------------------------
*----- Get Constants from ZCAINTEG_MAPPING
*"----------------------------------------------------------------------
    PERFORM f_get_constants CHANGING i_constant.
*"----------------------------------------------------------------------
    LOOP AT i_input INTO st_bp_input.
*"----------------------------------------------------------------------
*-----Variables that needs to be cleared with in loop
*"----------------------------------------------------------------------
      PERFORM f_clear_global_v_2.
*"----------------------------------------------------------------------
*-----Input file validations
*"----------------------------------------------------------------------
      PERFORM f_input_bp_validations USING ex_return.
*"----------------------------------------------------------------------
*-----Map input file data to BP deep structures
*"----------------------------------------------------------------------
      CHECK gv_error IS INITIAL.
      PERFORM f_map_input_data.
*-----Call BP update FM
*"----------------------------------------------------------------------
      PERFORM f_call_bp_update_fm USING ex_return.
    ENDLOOP.
  ENDIF.

ENDFUNCTION.
