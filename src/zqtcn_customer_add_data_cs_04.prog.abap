*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_CUSTOMER_ADD_DATA_CS_04 (Include Program)
* PROGRAM DESCRIPTION: BP Custom Fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/29/2016
* OBJECT ID: E036
* TRANSPORT NUMBER(S): ED2K903005
*----------------------------------------------------------------------*
PERFORM  f_get_data IN PROGRAM saplzqtc_bp_custom_fields IF FOUND
CHANGING s_kna1                                  "General Data in Customer Master
         s_knvv.                                 "Customer Master Sales Data
