FUNCTION zqtc_set_idoc_data_ips_i0353.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_DATA_IDOC) TYPE  EDIDD_TT OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_SET_IDOC_DATA_IPS_I0353
* PROGRAM DESCRIPTION: Function module to set IDOC data to
*                      global variable
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
  CLEAR t_data_idoc[].

  IF it_data_idoc IS NOT INITIAL.
    t_data_idoc = it_data_idoc.
  ENDIF. " IF it_data_idoc IS NOT INITIAL



ENDFUNCTION.
