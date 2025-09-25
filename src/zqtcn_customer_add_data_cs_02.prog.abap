*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_CUSTOMER_ADD_DATA_CS_02 (Include Program)
* PROGRAM DESCRIPTION: BP CUstom Fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/29/2016
* OBJECT ID: E036
* TRANSPORT NUMBER(S): ED2K903005
*----------------------------------------------------------------------*

FIELD-SYMBOLS:
  <lv_fcode> TYPE fcode.

IF i_vkorg IS INITIAL OR                         "Sales Organization
   i_vtweg IS INITIAL OR                         "Distribution Channel
   i_spart IS INITIAL.                           "Division
  APPEND INITIAL LINE TO e_not_used_taxi_fcodes ASSIGNING <lv_fcode>.
  <lv_fcode> = c_fcode_z1cus01.
ENDIF.
