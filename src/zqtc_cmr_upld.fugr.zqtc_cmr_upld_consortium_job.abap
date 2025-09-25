FUNCTION zqtc_cmr_upld_consortium_job.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(JOB_NO) TYPE  TBTCJOB-JOBCOUNT
*"     REFERENCE(JOB_NAME) TYPE  TBTCJOB-JOBNAME
*"     REFERENCE(PROGRAM) TYPE  SYST_XPROG
*"     REFERENCE(SEL_1) TYPE  CHAR1
*"     REFERENCE(SEL_2) TYPE  CHAR1
*"  TABLES
*"      RETURN STRUCTURE  BAPIRETURN1
*"----------------------------------------------------------------------


  SUBMIT zqtcr_cmr_upld_consortium WITH rb_ucmr = 'X'
                             WITH rb_bg_m  = 'X'
*                               WITH p_staneu = p_status
*                               WITH p_test = ' '
                             USER 'SGUDA'
                             VIA JOB job_name NUMBER job_no
                             AND RETURN.


ENDFUNCTION.
