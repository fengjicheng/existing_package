FUNCTION zqtc_get_bin_content_ips_i0353.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(ET_BIN_CONTENT) TYPE  RE_T_TEXTLINE
*"     REFERENCE(EX_FILENAME) TYPE  CHAR100
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_GET_BIN_CONTENT_IPS_I0353
* PROGRAM DESCRIPTION: Function module to get the pdf binary content from
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

  et_bin_content = t_bin_content.
  ex_filename    = v_filename.



ENDFUNCTION.
