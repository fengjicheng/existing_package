*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCBI_CUSTOMER_ADD_DATA_CS~GET_TAXI_SCREEN
*               (BADI Implementation / Method)
* PROGRAM DESCRIPTION: BP Custom Fields
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/29/2016
* OBJECT ID: E036
* TRANSPORT NUMBER(S): ED2K903005
*----------------------------------------------------------------------*
CASE i_taxi_fcode.
  WHEN c_fcode_z1cus01.
    e_screen              = c_screen_9001.       "Screen Number: 9001 (Sales Area Data)
    e_program             = c_screen_prog.       "Program Name: SAPLZQTC_BP_CUSTOM_FIELDS
    e_headerscreen_layout = space.

  WHEN c_fcode_z1cus02.
    e_screen              = c_screen_9002.       "Screen Number: 9002 (General Data)
    e_program             = c_screen_prog.       "Program Name: SAPLZQTC_BP_CUSTOM_FIELDS
    e_headerscreen_layout = space.

  WHEN OTHERS.
*   Do Nothing.
ENDCASE.
