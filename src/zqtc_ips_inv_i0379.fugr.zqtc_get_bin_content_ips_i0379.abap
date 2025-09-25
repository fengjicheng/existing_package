FUNCTION ZQTC_GET_BIN_CONTENT_IPS_I0379.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(ET_BIN_CONTENT) TYPE  RE_T_TEXTLINE
*"     REFERENCE(EX_FILENAME) TYPE  CHAR100
*"--------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_GET_BIN_CONTENT_IPS_I0379
* PROGRAM DESCRIPTION: Function module to get the pdf binary content from
*                      global variable along with PDF file name,this is copy of I0353 object
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE:   2020-02-08
* OBJECT ID:I0379 (ERPM-11517)
* TRANSPORT NUMBER(S): ED2K917673
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*

  et_bin_content = t1_bin_content.
  ex_filename    = v1_filename.

ENDFUNCTION.
