FUNCTION zqtc_set_bin_content_ips_i0353.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_BIN_CONTENT) TYPE  RE_T_TEXTLINE OPTIONAL
*"     REFERENCE(IM_FILENAME) TYPE  CHAR100 OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_SET_BIN_CONTENT_IPS_I0353
* PROGRAM DESCRIPTION: Function module to set the pdf binary content to
*                      global variable along with PDF file name
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-26
* OBJECT ID:E095 (CR# ERP-6594)
* TRANSPORT NUMBER(S): ED2K912233
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*
  CLEAR: t_bin_content[],
         v_filename.

  t_bin_content = it_bin_content.
  v_filename   = im_filename.


ENDFUNCTION.
