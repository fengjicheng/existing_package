FUNCTION ZQTC_RELEASE_ORDER_UPDATE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_VBELN) TYPE  VBELN
*"----------------------------------------------------------------------

SELECT vbelv,
       posnv,
       vbeln,
       posnn,
       vbtyp_v
  FROM vbfa
  INTO TABLE @DATA(li_vbfa)
 WHERE vbeln   EQ @im_vbeln
   AND vbtyp_v EQ @c_g.

 IF  sy-subrc IS INITIAL
 AND li_vbfa  IS NOT INITIAL.

   SELECT DISTINCT
          vbeln
     FROM vbfa
     INTO TABLE @DATA(li_release)
      FOR ALL ENTRIES IN @li_vbfa
    WHERE vbelv   EQ @li_vbfa-vbelv
      AND vbtyp_n EQ @c_c.

   IF  sy-subrc   IS INITIAL
   AND li_release IS NOT INITIAL.

     CONCATENATE 'ZQTCT_RELEASE_ORDER_REJECT_UPDATE'
                 sy-datum
                 sy-uzeit
            INTO lv_jobname.

     CONDENSE lv_jobname NO-GAPS.

     CALL FUNCTION 'JOB_OPEN'
       EXPORTING
         jobname          = lv_jobname
       IMPORTING
         jobcount         = lv_number
       EXCEPTIONS
         cant_create_job  = 1
         invalid_job_data = 2
         jobname_missing  = 3
         OTHERS           = 4.

      IF sy-subrc = 0.

        IF sy-subrc = 0.
*           Closing the Job
          CALL FUNCTION 'JOB_CLOSE'
            EXPORTING
              jobcount             = lv_number   "Job number
              jobname              = lv_jobname  "Job name
              strtimmed            = abap_true   "Start immediately
            EXCEPTIONS
              cant_start_immediate = 1
              invalid_startdate    = 2
              jobname_missing      = 3
              job_close_failed     = 4
              job_nosteps          = 5
              job_notex            = 6
              lock_failed          = 7
              OTHERS               = 8.
          IF sy-subrc <> 0.
*     Implement suitable error handling here
          ENDIF.
        ENDIF.

      ENDIF.

   ENDIF.

 ENDIF.

ENDFUNCTION.
