FUNCTION ZQTC_GET_FLAG.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EX_VALID_DATE) TYPE  CHAR1
*"     REFERENCE(EX_CONTENT_DATE) TYPE  CHAR1
*"     REFERENCE(EX_LICENSE_DATE) TYPE  CHAR1
*"     REFERENCE(EX_SALES_REP) TYPE  CHAR1
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTC_GET_FLAG
* PROGRAM DESCRIPTION : This Function Module will get Date Flag .
* DEVELOPER           : Sayantan Das
* CREATION DATE       : 2017-03-13
* OBJECT ID           : I0229
* TRANSPORT NUMBER(S) : ED2K902781
*----------------------------------------------------------------------*

*** Valid date flag
ex_valid_date = gv_valid_date_flag.

*** Content date flag
ex_content_date = gv_content_date_flag.

*** License date flag
ex_license_date = gv_license_date_flag.

*** Sales rep flag
ex_sales_rep = gv_sales_rep_flag.

ENDFUNCTION.
