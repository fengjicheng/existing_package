FUNCTION zqtc_ib_gobi_order_i0233_5 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_BUYERID) TYPE  CHAR20
*"     VALUE(IM_ORDERTYPE) TYPE  CHAR20 DEFAULT 'Purchase'
*"     VALUE(IM_CUSTOMERID) TYPE  CHAR35
*"     VALUE(IM_PURCHASEORDERNUMBER) TYPE  CHAR16
*"     VALUE(IM_ITEMDETAILS) TYPE  ZQTC_TT_GOBI_ITEMDETAILS
*"     VALUE(IM_SOURCE) TYPE  TPM_SOURCE_NAME OPTIONAL
*"     VALUE(IM_GUID) TYPE  IDOCCARKEY
*"  EXPORTING
*"     VALUE(EX_BUYERID) TYPE  CHAR20
*"     VALUE(EX_ORDERTYPE) TYPE  CHAR20
*"     VALUE(EX_CUSTOMERID) TYPE  CHAR35
*"     VALUE(EX_PURCHASEORDERNUMBER) TYPE  CHAR16
*"     VALUE(EX_RESPONSE) TYPE  ZQTC_TT_GOBI_RESPONSE
*"     VALUE(EX_STATUS) TYPE  CHAR10
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_IB_GOBI_ORDER_I0233_5                             *
* PROGRAM DESCRIPTION: This RFC will receive the request from GOBI     *
*          through     TIBCO, Once the request received in SAP it will *
*                      validate the data and send the overall response *
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 20/12/2021                                          *
* OBJECT ID      : I0233.5                                             *
* TRANSPORT NUMBER(S): ED2K925270                                      *
*----------------------------------------------------------------------*

*----- Clear Global variables
*"----------------------------------------------------------------------
    PERFORM f_clear_global_v.
*"----------------------------------------------------------------------
*----- Get Constants from ZCACONSTANT
*"----------------------------------------------------------------------
    PERFORM f_get_constants.
*"----------------------------------------------------------------------
*----- Fetch Sold to Party and Ship to Party
*"----------------------------------------------------------------------
    i_itemdetails[] = im_itemdetails[] .
    PERFORM f_fetch_sold_to_ship_vali USING im_buyerid  im_customerid
                                      CHANGING i_response.
*"----------------------------------------------------------------------
*----- Validating Item level Purchase Document
*"----------------------------------------------------------------------
    PERFORM f_validate_purchase_docu USING im_purchaseordernumber.
*"----------------------------------------------------------------------
*------Prepapare the header data and item data for BAPI
*"----------------------------------------------------------------------
    PERFORM f_prepare_header_item_data.
*"----------------------------------------------------------------------
*------Passing data to BAPI to Simulate
*"----------------------------------------------------------------------
    PERFORM f_call_bapi_simulate.
*"----------------------------------------------------------------------
*------Creat input logs
*"----------------------------------------------------------------------
    PERFORM f_create_input_logs USING im_guid im_buyerid
                               im_ordertype im_customerid
                               im_purchaseordernumber im_source.
*"----------------------------------------------------------------------
*------Creat ouput logs
*"----------------------------------------------------------------------
    PERFORM f_create_output_logs USING im_guid im_buyerid
                               im_ordertype im_customerid
                               im_purchaseordernumber im_source
                                CHANGING ex_status.
*"----------------------------------------------------------------------
*------Arranging Errors as per priotity
*"----------------------------------------------------------------------
    PERFORM f_error_priority.
*"----------------------------------------------------------------------
*------Exporting output
*"----------------------------------------------------------------------
    ex_response[]      =         i_response.
    ex_buyerid         =         im_buyerid.
    ex_ordertype       =         im_ordertype.
    ex_customerid      =         im_customerid.
    ex_purchaseordernumber  =    im_purchaseordernumber.
ENDFUNCTION.
