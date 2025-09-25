FUNCTION ZQTC_NOTICE_F035.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_DESCRIPTION) TYPE  /BCV/FND_STRING OPTIONAL
*"     VALUE(IM_VALUE) TYPE  CHAR4 OPTIONAL
*"     REFERENCE(IM_LINK) TYPE  CHAR90
*"----------------------------------------------------------------------
*Global Variable declaration
  v_description = im_description.
  v_value      = im_value.
* Begin of change by SRBOSE: 29-June-2017: #TR: ED2K907341
  v_link       = im_link.
* End of change by SRBOSE: 29-June-2017: #TR: ED2K907341




ENDFUNCTION.
