FUNCTION ZQTC_SET_IDOC_DATA_IPS_I0379.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_DATA_IDOC) TYPE  EDIDD_TT OPTIONAL
*"--------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:   ZQTC_SET_IDOC_DATA_IPS_I0379
* PROGRAM DESCRIPTION: Function module to set IDOC data to
*                      global variable
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
  CLEAR t1_data_idoc[].

  IF it_data_idoc IS NOT INITIAL.
    t1_data_idoc = it_data_idoc.
  ENDIF. " IF it_data_idoc IS NOT INITIAL



ENDFUNCTION.
