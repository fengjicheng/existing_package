FUNCTION zqtc_set_bin_content_ips_i0379.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_BIN_CONTENT) TYPE  RE_T_TEXTLINE OPTIONAL
*"     REFERENCE(IM_FILENAME) TYPE  CHAR100 OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: zqtc_set_bin_content_ips_i0379
* PROGRAM DESCRIPTION: Function module to set the pdf binary content to
*                      global variable along with PDF file name
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
  CLEAR: t1_bin_content[],
         v1_filename.

  t1_bin_content = it_bin_content.
  v1_filename   = im_filename.


ENDFUNCTION.
