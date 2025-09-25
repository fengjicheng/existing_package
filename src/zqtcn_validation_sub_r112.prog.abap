*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_VALIDATION_SUB_R112 (Include Program)
* PROGRAM DESCRIPTION: Add validation
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   05/30/2020
* WRICEF ID: R112
* TRANSPORT NUMBER(S):  ED2K918328
* REFERENCE NO: ERPM-17101
*----------------------------------------------------------------------*

IF consp = abap_true AND s_email IS NOT INITIAL AND sy-batch NE abap_true.   " detail email and background mode
  MESSAGE text-905 TYPE 'I'.
ENDIF.
