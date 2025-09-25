FUNCTION ZQTC_SET_FLAG.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_VALID_DATE) TYPE  CHAR1 OPTIONAL
*"     REFERENCE(IM_CONTENT_DATE) TYPE  CHAR1 OPTIONAL
*"     REFERENCE(IM_LICENSE_DATE) TYPE  CHAR1 OPTIONAL
*"     REFERENCE(IM_SALES_REP) TYPE  CHAR1 OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTC_SET_FLAG
* PROGRAM DESCRIPTION : This Function Module will Set Date Flag
* DEVELOPER           : Sayantan Das
* CREATION DATE       : 2017-03-13
* OBJECT ID           : I0229
* TRANSPORT NUMBER(S) : ED2K902781
*----------------------------------------------------------------------*

*** Valid date flag
gv_valid_date_flag = im_valid_date.

*** Content date flag
gv_content_date_flag = im_content_date.

*** License date flag
gv_license_date_flag = im_license_date.

*** Sales rep flag
gv_sales_rep_flag  = im_sales_rep.

ENDFUNCTION.
