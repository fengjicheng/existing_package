FUNCTION ZQTC_VOL_ISSUES_F037.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_VOLUME) TYPE  STRING
*"     REFERENCE(IM_START_ISSUE) TYPE  ISMNRIMJAHR
*"     REFERENCE(IM_TOT_ISSUE) TYPE  ISMNRIMJAHR
*"----------------------------------------------------------------------

v_volume        = im_volume.
v_start_issue   = im_start_issue.
v_tot_issue     = im_tot_issue.

ENDFUNCTION.
