FUNCTION zqtc_as_price_simulation_i0419 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_SOURCE) TYPE  TPM_SOURCE_NAME OPTIONAL
*"     VALUE(IM_HDRDET) TYPE  ZQTC_ST_PRICE_HDR
*"     VALUE(IM_ITMDET) TYPE  ZQTC_TT_PRICE_ITM
*"     VALUE(IM_GUID) TYPE  IDOCCARKEY
*"  EXPORTING
*"     VALUE(EX_PRICE_OUT) TYPE  ZQTC_TT_PRICE_OUT
*"     VALUE(EX_STATUS) TYPE  CHAR10
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_AS_PRICE_SIMULATION_I0419                         *
* PROGRAM DESCRIPTION: This RFC will receive the request from AS       *
*                      through TIBCO, Once the request received in SAP *
*                      it will validate the data for price simulation  *
*                      and send the overall response.                  *
* DEVELOPER      : Ramesh N (RNARAYANAS)                               *
* CREATION DATE  : 24/03/2022                                          *
* OBJECT ID      : I0419                                               *
* TRANSPORT NUMBER(S): ED2K926086 , ED2K926565 , ED2K926784, ED2K927144*
*                      ED2K927355.                                     *
*----------------------------------------------------------------------*

*----- Clear Global variables
*"----------------------------------------------------------------------
  PERFORM f_clear_global_v.
*"----------------------------------------------------------------------

*"----------------------------------------------------------------------
*----- Get Constants from ZCACONSTANT
*"----------------------------------------------------------------------
  PERFORM f_get_constants.

  "----------------------------------------------------------------------
*------Read the Item details
*"----------------------------------------------------------------------
  PERFORM f_read_item_detail USING im_hdrdet im_itmdet
                             CHANGING st_itemdetails.

  "----------------------------------------------------------------------
*------Creat input logs
*"----------------------------------------------------------------------
  PERFORM f_create_input_logs USING im_guid im_hdrdet
                                    st_itemdetails im_source.

*"----------------------------------------------------------------------
*----- Fetch material number for the given UUID
*"----------------------------------------------------------------------
  PERFORM f_fetch_matnr  CHANGING v_matnr i_priceout.

*"----------------------------------------------------------------------
*----- Validate the input data combinations
*"----------------------------------------------------------------------
* BOC by Ramesh on 04/18/2022 for ASOTC-226(ASOTC-665 defect) with ED2K926784  *
  PERFORM f_validate_inp  USING st_itemdetails CHANGING i_priceout.
* EOC by Ramesh on 04/18/2022 for ASOTC-226(ASOTC-665 defect) with ED2K926784  *

*"----------------------------------------------------------------------
*------Prepapare the header data and item data for RFC
*"----------------------------------------------------------------------
*"----------------------------------------------------------------------
  PERFORM f_prepare_header_item_data USING st_hdrdet st_itemdetails .


*"----------------------------------------------------------------------
*------Passing data to PRICE enquiry to Simulate
*"----------------------------------------------------------------------
  PERFORM f_call_price_simulate.
  "----------------------------------------------------------------------
*------Creat input logs
*"----------------------------------------------------------------------
  PERFORM f_create_output_logs USING im_guid im_hdrdet
                                    st_itemdetails im_source.

*"----------------------------------------------------------------------
*------Exporting output
*"----------------------------------------------------------------------
  ex_price_out[]      =         i_priceout[].
  ex_status           =         v_status.




ENDFUNCTION.
