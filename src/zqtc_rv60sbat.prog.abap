REPORT zqtc_rv60sbat MESSAGE-ID vr.
*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTC_RV60SBAT
* PROGRAM DESCRIPTION: This Program is copied from  RV60SBAT(VF06)
* DEVELOPER: Prabhu (PTUFARAM)
* CREATION DATE: 01/27/2020
* OBJECT ID:     E227/ERPM-8161
* TRANSPORT NUMBER(S):ED2K917355
* Modifications :
*   1)  Main job should be remain in active status until all child jobs get completed
*   2)  If any one of the child job get cancelled then change the main job status to cancelled
*   3)  Removed “Customer per Step and Target Computer on selection screen to avoid the confusion.
*   4)  Replaced ‘Number of Jobs’ on selection screen with ““No. of Jobs per App server”
*   5)  Control the number of records per Job using ZCACONSTANT table
*   6)  Check each App server resources (Background work processes) availability and see
*       if it is >=50%(Maintained in constant table) then release child jobs as per selection screen entry.
*   7)  Ensure the release jobs should utilize only half of the resources which are available on App Server.
*   9)  No. of child batch jobs = No. of records to be processed /No. of records per Job.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*&---------------------------------------------------------------------*
TABLES: vkdfs, vbco7, rv75a, t180z, tvfsp.

*======================================================================*
* Includes                                                             *
*======================================================================*
INCLUDE zqtc_rvreuse_global_data.
*INCLUDE RVREUSE_GLOBAL_DATA.
INCLUDE zqtc_rvreuse_local_data.
*INCLUDE RVREUSE_LOCAL_DATA.
INCLUDE zqtc_rvreuse_forms.
*INCLUDE RVREUSE_FORMS.


*ENHANCEMENT-POINT RV60SBAT_02 SPOTS ES_RV60SBAT STATIC.

*======================================================================*
* Ereignis : AT SELECTION-SCREEN OUTPUT (PBO-Zeitpunkt)                *
*======================================================================*
AT SELECTION-SCREEN OUTPUT.

  PERFORM f_selection_output.

*ENHANCEMENT-POINT RV60SBAT_03 SPOTS ES_RV60SBAT.

AT SELECTION-SCREEN ON fkdab.

  PERFORM f_fkdab_validation.

AT SELECTION-SCREEN ON HELP-REQUEST FOR exdate.

  PERFORM f_exdate_show.

AT SELECTION-SCREEN ON HELP-REQUEST FOR extime.

  PERFORM f_extime_show.

AT SELECTION-SCREEN ON HELP-REQUEST FOR immedi.

  PERFORM f_immedi_help.

AT SELECTION-SCREEN ON HELP-REQUEST FOR test.

  PERFORM f_test_help.

AT SELECTION-SCREEN ON HELP-REQUEST FOR utasy.

  PERFORM f_show_utasy.

AT SELECTION-SCREEN ON HELP-REQUEST FOR utswl.

  PERFORM f_show_utswl.

AT SELECTION-SCREEN ON HELP-REQUEST FOR utsnl.

  PERFORM f_show_utnsl.

AT SELECTION-SCREEN ON HELP-REQUEST FOR numbjobs.

  PERFORM f_show_numbjobs.

AT SELECTION-SCREEN ON HELP-REQUEST FOR x_vbeln-low.

  PERFORM f_show_vbeln_low.

AT SELECTION-SCREEN ON HELP-REQUEST FOR x_vbeln-high.

  PERFORM f_show_vbeln_high.

START-OF-SELECTION.
  IF gs_sd_alv-variant IS INITIAL.
    gs_sd_alv-variant-report = 'SAPLV60P'.
    PERFORM reuse_alv_variant_default
            USING gs_sd_alv.
  ENDIF.
* initialze data
  PERFORM initialize.
*ENHANCEMENT-POINT RV60SBAT_04 SPOTS ES_RV60SBAT.
  PERFORM get_server_list USING rc.
* get all customers into CUSTOMERS_INVOICE and CUSTOMERS_RD01
  PERFORM get_customers.
* analyze workload for customers
  PERFORM analyze_workload TABLES    customers_invoice
                           USING     numbjobs max_cust.
* creation of jobs
  PERFORM create_jobs      TABLES    customers_invoice
                           USING     jobname_invoice
                                     max_cust
                                     numbjobs.

*ENHANCEMENT-POINT RV60SBAT_09 SPOTS ES_RV60SBAT STATIC.


*---------------------------------------------------------------------*
*       FORM ANALYZE_WORKLOAD                                         *
*---------------------------------------------------------------------*
*       Analyze Worklaod per given Table Customer                     *
*---------------------------------------------------------------------*
*  -->  CUSTOMERS : Tables with customers                             *
*  -->  NO_JOBS   : Number of jobs                                    *
*  -->  NO_CUST   : Number of customers per step                      *
*---------------------------------------------------------------------*
FORM analyze_workload TABLES    customers STRUCTURE customers_invoice
                      USING     no_jobs no_cust.
  DATA: temp_jobs(2) TYPE n.
* sort descending by number of orders
  SORT customers DESCENDING BY orders kunnr.
  CLEAR temp_jobs.
  LOOP AT customers.
    ADD 1 TO temp_jobs.
    customers-jobs = temp_jobs.
    MODIFY customers.
    IF temp_jobs = no_jobs.
      CLEAR temp_jobs.
    ENDIF.
  ENDLOOP.
ENDFORM.                    "ANALYZE_WORKLOAD

*---------------------------------------------------------------------*
*       FORM CLOSE_JOB                                                *
*---------------------------------------------------------------------*
*       Export job to job schedulings ysstem                          *
*---------------------------------------------------------------------*
FORM close_job USING cj_host cj_steps cj_custs cj_orders.
*  CHECK job_close = 'X'.
  IF test = space.
    IF immedi = space.
      CALL FUNCTION 'JOB_CLOSE'
        EXPORTING
          jobname              = jobname
          jobcount             = jobcount
          sdlstrtdt            = exdate
          sdlstrttm            = extime
          targetsystem         = cj_host
        EXCEPTIONS
          cant_start_immediate = 01
          invalid_startdate    = 02
          jobname_missing      = 03
          job_close_failed     = 04
          job_nosteps          = 05
          job_notex            = 06
          lock_failed          = 07
          OTHERS               = 08.
    ELSE.
      CALL FUNCTION 'JOB_CLOSE'
        EXPORTING
          jobname              = jobname
          jobcount             = jobcount
          strtimmed            = immedi
          targetsystem         = cj_host
        EXCEPTIONS
          cant_start_immediate = 01
          invalid_startdate    = 02
          jobname_missing      = 03
          job_close_failed     = 04
          job_nosteps          = 05
          job_notex            = 06
          lock_failed          = 07
          OTHERS               = 08.
    ENDIF.
    IF NOT sy-subrc IS INITIAL.
      MESSAGE e026(bt).
      EXIT.
    ELSE.
      READ TABLE i_child_jobs INTO DATA(lst_child_jobs) WITH KEY jobname = jobname
                                                                 jobcount = jobcount.
      IF sy-subrc EQ 0.
        lst_child_jobs-job_closed = abap_true.
        MODIFY i_child_jobs FROM lst_child_jobs INDEX sy-tabix TRANSPORTING job_closed.
      ENDIF.
    ENDIF.
  ENDIF.
  job_close = space.

  MOVE jobname   TO gs_output-jobname .
  MOVE cj_steps  TO gs_output-steps .
  MOVE cj_custs  TO gs_output-customers .
  MOVE cj_orders TO gs_output-orders .
  MOVE cj_host   TO gs_output-host .
  APPEND gs_output TO gt_output.
  IF sy-batch IS NOT INITIAL.
    PERFORM f_update_job_log.
  ENDIF.
ENDFORM.                    "CLOSE_JOB

*---------------------------------------------------------------------*
*       FORM CREATE_JOBS                                              *
*---------------------------------------------------------------------*
*       Create job for given table                                    *
*---------------------------------------------------------------------*
*  -->  CUSTOMERS  : Customer table                                   *
*  -->  CJ_JOBNAME : Jobname                                          *
*  -->  NO_CUST    : number of customers per step                     *
*  -->  NO_JOBS    : number of steps                                  *
*---------------------------------------------------------------------*
FORM create_jobs TABLES customers STRUCTURE customers_invoice
                 USING  cj_jobname
                        no_cust no_jobs.
  DATA: cust_count(4) TYPE n.
  DATA: comp_jobs LIKE customers_invoice-jobs.
  DATA: first_step_in_job,
        lv_job_log            TYPE char100.
  DATA : lv_tabix          TYPE sy-tabix,
         lv_lines          TYPE i,
         lv_count          TYPE i,
         lv_docs           TYPE char10,
         lv_previous_kunnr TYPE kunnr. "Prabhu
  PERFORM f_get_constants.
* something to do ?
  CHECK no_jobs <> 0.
* reset counter for jobs
  CLEAR job_count.
*  DO no_jobs TIMES.
  CLEAR: cust_count,
         created_steps,
         created_custs,
         created_orders,
         lv_previous_kunnr,
         v_sel_docs.

*--*Prabhu
*    LOOP AT customers WHERE jobs = comp_jobs.
  SORT customers_docs BY kunnr vbeln.
  DELETE ADJACENT DUPLICATES FROM customers_docs COMPARING kunnr vbeln.
  DESCRIBE TABLE customers_docs LINES lv_lines.
*--*Job log update
  IF x_vbeln[] IS NOT INITIAL.
    DESCRIBE TABLE x_vbeln LINES v_sel_docs.
    REFRESH x_vbeln[].
    IF sy-batch IS NOT INITIAL.
      CONCATENATE text-022 v_sel_docs INTO lv_job_log SEPARATED BY ':'.
      MESSAGE lv_job_log TYPE 'I'.
      CLEAR : lv_job_log.
    ENDIF.
  ENDIF.
  lv_docs = lv_lines.
  v_total_docs = lv_lines.
  IF sy-batch IS NOT INITIAL.
    CONCATENATE text-015 lv_docs INTO lv_job_log SEPARATED BY ':'.
    MESSAGE lv_job_log TYPE 'I'.
  ENDIF.
  LOOP AT customers_docs.
    lv_tabix = sy-tabix.
    ADD 1 TO lv_count.
*--*Build docs
    x_vbeln-sign = 'I'.
    x_vbeln-option = 'EQ'.
    x_vbeln-low = customers_docs-vbeln.
    CLEAR x_vbeln-high.
    APPEND x_vbeln.
*    MOVE customers_docs-orders TO created_orders.
    IF customers_docs-kunnr NE lv_previous_kunnr.
      ADD 1 TO created_custs.
      ADD 1 TO cust_count.
    ENDIF.
    lv_previous_kunnr = customers_docs-kunnr.
* set jobname for first job
*      IF first_step_in_job = 'X'.
**--*Check next record OR No.of records reached to threshold
    IF lv_count = v_no_docs OR lv_tabix = lv_lines.
      created_orders = lv_count.
      ADD 1 TO created_steps.
      PERFORM open_job USING cj_jobname.
      PERFORM submit_step.
      cust_count = 0.
*        CLEAR first_step_in_job.
      CLEAR : lv_count, created_orders,created_custs, lv_previous_kunnr,created_steps.
      REFRESH : x_vbeln.
    ENDIF.
  ENDLOOP.
*--*Assign availability server when closing the job
  PERFORM f_assign_servers.

  IF sy-batch IS NOT INITIAL.
    PERFORM f_verify_status_of_child_jobs.
  ENDIF.
  IF test IS NOT INITIAL.
    MOVE cj_jobname   TO gs_output-jobname .
*  MOVE cj_steps  TO gs_output-steps .
    MOVE created_custs  TO gs_output-customers .
    MOVE v_total_docs TO gs_output-orders .
*  MOVE cj_host   TO gs_output-host .
    APPEND gs_output TO gt_output.
  ENDIF.
  PERFORM show_jobs_alv.

ENDFORM.                    "CREATE_JOBS

*---------------------------------------------------------------------*
*       FORM GET_CUSTOMERS                                            *
*---------------------------------------------------------------------*
*       Read all Customers into internal table and split by           *
*       account group                                                 *
*---------------------------------------------------------------------*
FORM get_customers.
  FREE : customers_docs.
* fill fktyp table
  CLEAR x_fktyp.
  x_fktyp-sign = 'I'.
  x_fktyp-option = 'EQ'.
  IF allea = 'X'.
    x_fktyp-low = 'A'.
    APPEND x_fktyp.
  ENDIF.
  IF allel = 'X'.
    x_fktyp-low = 'L'.
    APPEND x_fktyp.
  ENDIF.
  IF alleb = 'X'.
    x_fktyp-low = 'B'.
    APPEND x_fktyp.
  ENDIF.
  IF allei = 'X'.
    x_fktyp-low = 'I'.
    APPEND x_fktyp.
  ENDIF.
* get all customer numbers which orders to be invoiced
  DATA: x_vbeln_lines LIKE sy-tabix.
  DESCRIBE TABLE x_vbeln LINES x_vbeln_lines.
  LOOP AT x_vbeln WHERE sign >< 'I' OR option >< 'EQ'.
    EXIT.
  ENDLOOP.
  IF sy-subrc = 0 OR x_vbeln_lines = 0.
*ENHANCEMENT-SECTION     RV60SBAT_05 SPOTS ES_RV60SBAT.
    SELECT * FROM vkdfs WHERE fktyp IN x_fktyp
                        AND   vkorg = vkor1
                        AND   vtweg IN so_vtweg
                        AND   spart IN so_spart
                        AND   vstel IN so_vstel
                        AND   fkdat BETWEEN fkdat AND fkdab
                        AND   kunnr IN x_kunnr
                        AND   fkart IN x_fkart
                        AND   lland IN x_lland
                        AND   vbeln IN x_vbeln
                        AND   sortkri IN x_sortk.
* no document with billing block
      sy-subrc = 4.
      IF NOT no_faksk IS INITIAL AND
         NOT vkdfs-faksk IS INITIAL.
        IF NOT vfkar IS INITIAL.
          vkdfs-fkart = vfkar.
        ENDIF.
        READ TABLE xtvfsp WITH KEY mandt = sy-mandt
                                   faksp = vkdfs-faksk
                                   fkart = vkdfs-fkart
                                   BINARY SEARCH.
      ENDIF.
      IF sy-subrc = 4.
*
        READ TABLE customers_invoice WITH KEY vkdfs-kunnr BINARY SEARCH.
* get number of orders per customer
        IF sy-subrc = 0.
          ADD 1 TO customers_invoice-orders.
          MODIFY customers_invoice INDEX sy-tabix.
        ELSE.
* initialize customer table
          CLEAR customers_invoice.
          customers_invoice-kunnr = vkdfs-kunnr.
          customers_invoice-orders = 1.
* update table
          CASE sy-subrc.
            WHEN 4.
* sometime SY-TABIX = 0 (Don't know why ?)
              IF sy-tabix = 0. sy-tabix = 1. ENDIF.
              INSERT customers_invoice INDEX sy-tabix.
            WHEN 8.
              APPEND customers_invoice.
          ENDCASE.
        ENDIF.
*--* Prabhu
        customers_docs-vbeln =  vkdfs-vbeln.
        customers_docs-kunnr =  vkdfs-kunnr.
        ADD 1 TO customers_docs-orders.
        APPEND customers_docs.
      ENDIF.
    ENDSELECT.
*END-ENHANCEMENT-SECTION.
  ELSE.
*ENHANCEMENT-SECTION     RV60SBAT_06 SPOTS ES_RV60SBAT.
    SELECT * FROM vkdfs FOR ALL ENTRIES IN x_vbeln
                          WHERE fktyp IN x_fktyp
                          AND   vkorg = vkor1
                          AND   vtweg IN so_vtweg
                          AND   spart IN so_spart
                          AND   vstel IN so_vstel
                          AND   fkdat BETWEEN fkdat AND fkdab
                          AND   kunnr IN x_kunnr
                          AND   fkart IN x_fkart
                          AND   lland IN x_lland
                          AND   vbeln EQ x_vbeln-low
                          AND   sortkri IN x_sortk.
* no document with billing block
      sy-subrc = 4.
      IF NOT no_faksk IS INITIAL AND
         NOT vkdfs-faksk IS INITIAL.
        IF NOT vfkar IS INITIAL.
          vkdfs-fkart = vfkar.
        ENDIF.
        READ TABLE xtvfsp WITH KEY mandt = sy-mandt
                                   faksp = vkdfs-faksk
                                   fkart = vkdfs-fkart
                                   BINARY SEARCH.
      ENDIF.
      IF sy-subrc = 4.
*
        READ TABLE customers_invoice WITH KEY vkdfs-kunnr BINARY SEARCH.
* get number of orders per customer
        IF sy-subrc = 0.
          ADD 1 TO customers_invoice-orders.
          MODIFY customers_invoice INDEX sy-tabix.
        ELSE.
* initialize customer table
          CLEAR customers_invoice.
          customers_invoice-kunnr = vkdfs-kunnr.
          customers_invoice-orders = 1.
* update table
          CASE sy-subrc.
            WHEN 4.
* sometime SY-TABIX = 0 (Don't know why ?)
              IF sy-tabix = 0. sy-tabix = 1. ENDIF.
              INSERT customers_invoice INDEX sy-tabix.
            WHEN 8.
              APPEND customers_invoice.
          ENDCASE.
        ENDIF.
*--* Prabhu
        customers_docs-vbeln =  vkdfs-vbeln.
        customers_docs-kunnr =  vkdfs-kunnr.
        APPEND customers_docs.
      ENDIF.
    ENDSELECT.
*END-ENHANCEMENT-SECTION.
  ENDIF.
*ENHANCEMENT-POINT RV60SBAT_07 SPOTS ES_RV60SBAT.

ENDFORM.                    "GET_CUSTOMERS

*---------------------------------------------------------------------*
*       FORM INITIALIZE                                               *
*---------------------------------------------------------------------*
*       Initialize all fields                                         *
*---------------------------------------------------------------------*
FORM initialize.
  DATA: out6(6), out8(8),
  help_time LIKE sy-uzeit.
* set correct number of jobs
  IF numbjobs = 0.
    numbjobs = 1.
  ENDIF.
* set correct number of maximal customers
  IF max_cust = 0 OR
     max_cust > 100.
    max_cust = 100.
  ENDIF.
* set correct start date
  GET TIME.
  IF exdate IS INITIAL OR
     exdate <  sy-datum.
    exdate = sy-datum.
  ENDIF.
* set correct start time
  IF immedi = space.
    help_time = sy-uzeit + 720.
    IF help_time < sy-uzeit.
      exdate = exdate + 1.
      extime = help_time.
    ENDIF.
  ELSE.
    help_time = sy-uzeit.
  ENDIF.
  IF extime IS INITIAL    OR
     ( exdate <= sy-datum AND
       extime <  help_time ).
    extime = help_time.
  ENDIF.
* set date and time into job names
  WRITE exdate YYMMDD TO out6.
  WRITE extime USING EDIT MASK '__:__:__' TO out8.
  REPLACE '&D' WITH out6 INTO jobname_invoice.
  REPLACE '&T' WITH extime  INTO jobname_invoice.
*  REPLACE '&H' WITH syst-host INTO jobname_invoice.
  SET LOCALE LANGUAGE sy-langu.
  TRANSLATE jobname_invoice TO UPPER CASE.
  SET LOCALE LANGUAGE space.
* set selection date to todays date
  IF fkdab IS INITIAL.
    IF fkdat > sy-datlo.
      fkdab = fkdat.
    ELSE.
      fkdab = sy-datlo.
    ENDIF.
  ENDIF.
*
  IF NOT no_faksk IS INITIAL.
    SELECT * FROM tvfsp INTO TABLE xtvfsp ORDER BY PRIMARY KEY.
  ENDIF.
*--*Prabhu
  FREE : i_child_jobs, st_child_jobs,customers_docs,v_doc_count.
ENDFORM.                    "INITIALIZE

*---------------------------------------------------------------------*
*       FORM OPEN_JOB                                                 *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  OJ_JOBNAME                                                    *
*---------------------------------------------------------------------*
FORM open_job USING oj_jobname.
  DATA: jc(5),
        lv_msg(100).
* set counter
  ADD 1 TO job_count.
  UNPACK job_count TO jc.
  jobname = oj_jobname.
  REPLACE '&&' WITH jc INTO jobname.
* rest job counter
  CLEAR jobcount.
  IF test = space.
    CALL FUNCTION 'JOB_OPEN'
      EXPORTING
        jobname          = jobname
        jobgroup         = jobgroup
      IMPORTING
        jobcount         = jobcount
      EXCEPTIONS
        cant_create_job  = 01
        invalid_job_data = 02
        jobname_missing  = 03
        OTHERS           = 04.
    IF NOT sy-subrc IS INITIAL.
      MESSAGE e026(bt).
      EXIT.
    ENDIF.
*--*Prabhu
    st_child_jobs-jobname  = jobname.
    st_child_jobs-jobcount = jobcount.
    st_child_jobs-created_orders = created_orders.
    st_child_jobs-created_custs = created_custs.
    st_child_jobs-created_steps = created_steps.
    APPEND st_child_jobs TO i_child_jobs.
    CLEAR : st_child_jobs.
    IF sy-batch IS NOT INITIAL.
      CONCATENATE text-011 jobname INTO lv_msg.
      MESSAGE lv_msg TYPE 'I'.
      CONCATENATE text-016 created_orders INTO lv_msg SEPARATED BY ':'.
      MESSAGE lv_msg TYPE 'I'.
    ENDIF.
  ENDIF.
  job_close = 'X'.
ENDFORM.                    "OPEN_JOB


*---------------------------------------------------------------------*
*       FORM SUBMIT_STEP                                              *
*---------------------------------------------------------------------*
*       Add a new step to the invoicing program                       *
*---------------------------------------------------------------------*
FORM submit_step.
  CHECK test = space.
*ENHANCEMENT-SECTION     RV60SBAT_08 SPOTS ES_RV60SBAT.
  IF sy-batch IS INITIAL.
    SUBMIT sdbilldl VIA JOB jobname
                   NUMBER jobcount
                  WITH p_vkorg  = vkor1
                  WITH s_vtweg IN so_vtweg
                  WITH s_spart IN so_spart
                  WITH s_vstel IN so_vstel
                  WITH p_fkdat = fkdat
                  WITH p_fkdab = fkdab
                  WITH p_kunnr IN kunnr_sel
                  WITH p_fkart IN x_fkart
                  WITH p_lland IN x_lland
                  WITH s_vbeln IN x_vbeln
                  WITH p_sort  IN x_sortk
                  WITH p_allea = allea
                  WITH p_allel = allel
                  WITH p_alleb = alleb
                  WITH p_allei = allei
                  WITH p_allef = allef
                  WITH no_faksk = no_faksk
                  WITH p_pdstk  = p_pdstk
                  WITH p_samml = 'X'
                  WITH p_anzei = anzei
                  WITH p_varnr = gs_sd_alv-variant
                  WITH p_proto = proto
                  WITH pv_fkart = vfkar
                  WITH pv_fkdat = vfkda
                  WITH pv_fbuda = fbuda
                  WITH pv_prsdt = prsdt
                  WITH p_utasy = utasy
                  WITH p_utswl = utswl
                  WITH p_utsnl = utsnl
                  AND RETURN.
  ELSE.
* determine spool infromation
    CALL FUNCTION 'GET_PRINT_PARAMETERS'
      EXPORTING
        no_dialog      = 'X'
        mode           = 'CURRENT'
      IMPORTING
        out_parameters = params.

    SUBMIT sdbilldl VIA JOB jobname
                     NUMBER jobcount
                     TO SAP-SPOOL SPOOL PARAMETERS params
                     WITHOUT SPOOL DYNPRO
                     WITH p_vkorg  = vkor1
                     WITH s_vtweg IN so_vtweg
                     WITH s_spart IN so_spart
                     WITH s_vstel IN so_vstel
                     WITH p_fkdat = fkdat
                     WITH p_fkdab = fkdab
                     WITH p_kunnr IN kunnr_sel
                     WITH p_fkart IN x_fkart
                     WITH p_lland IN x_lland
                     WITH s_vbeln IN x_vbeln
                     WITH p_sort  IN x_sortk
                     WITH p_allea = allea
                     WITH p_allel = allel
                     WITH p_alleb = alleb
                     WITH p_allei = allei
                     WITH p_allef = allef
                     WITH no_faksk = no_faksk
                     WITH p_pdstk  = p_pdstk
                     WITH p_samml = 'X'
                     WITH p_anzei = anzei
                     WITH p_varnr = gs_sd_alv-variant
                     WITH p_proto = proto
                     WITH pv_fkart = vfkar
                     WITH pv_fkdat = vfkda
                     WITH pv_fbuda = fbuda
                     WITH pv_prsdt = prsdt
                     WITH p_utasy = utasy
                     WITH p_utswl = utswl
                     WITH p_utsnl = utsnl
                     AND RETURN.
  ENDIF.

*END-ENHANCEMENT-SECTION.
ENDFORM.                    "SUBMIT_STEP

*---------------------------------------------------------------------*
*       FORM GET_SERVER_LIST                                          *
*---------------------------------------------------------------------*
* Hole Liste aller am System angeschlossenen Server                   *
*   RC = 1: Liste aller Server kann nicht vom Messageserver beschafft *
*           werden                                                    *
*   RC = 2: derzeit sind dem Messageserver keine Server bekannt       *
*           (darf eigentlich nicht passieren)                         *
*---------------------------------------------------------------------*
FORM get_server_list USING rc.

  DATA: BEGIN OF sys_tabl OCCURS 50.
          INCLUDE STRUCTURE msxxlist.
        DATA: END OF sys_tabl.

  DATA: num_lines  TYPE i,
        lv_grp     TYPE rzllitab-grouptype VALUE 'S',
        li_servers TYPE STANDARD TABLE OF rzlliapsrv.

  FREE : sys_tabl,li_servers,btc_sys_tbl.
  IF p_sergrp IS NOT INITIAL.
    CALL FUNCTION 'SMLG_GET_DEFINED_SERVERS'
      EXPORTING
        grouptype          = lv_grp
        groupname          = p_sergrp
      TABLES
        instances          = li_servers
      EXCEPTIONS
        invalid_group_type = 1
        no_instances_found = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
      rc = cant_get_server_info.  " Liste kann nicht beschafft werden
      EXIT.
    ELSE.
*--*Get host name
      CALL FUNCTION 'TH_SERVER_LIST'
        TABLES
          list   = sys_tabl
        EXCEPTIONS
          OTHERS = 99.
      IF sy-subrc <> 0.
        rc = cant_get_server_info.  " Liste kann nicht beschafft werden
        EXIT.
      ENDIF.
      LOOP AT li_servers INTO DATA(lst_servers).
        btc_sys_tbl-instname  = lst_servers-applserver.
        READ TABLE sys_tabl WITH KEY name = lst_servers-applserver.
        IF sy-subrc EQ 0.
          btc_sys_tbl-btcsystem = sys_tabl-host.
        ENDIF.
        APPEND btc_sys_tbl.
        CLEAR : btc_sys_tbl.
      ENDLOOP.
    ENDIF.
*--*Full servers list
  ELSE.
    CALL FUNCTION 'TH_SERVER_LIST'
      TABLES
        list   = sys_tabl
      EXCEPTIONS
        OTHERS = 99.

    IF sy-subrc <> 0.
      rc = cant_get_server_info.  " Liste kann nicht beschafft werden
      EXIT.
    ENDIF.

    DESCRIBE TABLE sys_tabl LINES num_lines.

    IF num_lines EQ 0.
      rc = no_server_found.              " keine Server vorhanden
      EXIT.
    ENDIF.

    SORT sys_tabl BY name ASCENDING.

    FREE btc_sys_tbl.
    LOOP AT sys_tabl.
      btc_sys_tbl-btcsystem = sys_tabl-host.
      btc_sys_tbl-instname  = sys_tabl-name.
      APPEND btc_sys_tbl.
    ENDLOOP.
  ENDIF.
  rc = 0.

ENDFORM.                    " GET_SERVER_LIST

*&---------------------------------------------------------------------*
*&      Form  SHOW_SERVER_LIST
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_server_list USING rc.

  DATA: selected_system LIKE tbtcjob-btcsystem.

  IF rc EQ tgt_host_chk_has_failed.
    MESSAGE e505(bt).
  ELSEIF rc EQ no_batch_server_found.
    MESSAGE e504(bt).
  ENDIF.

  FREE btc_sys_host_tbl.

  LOOP AT btc_sys_tbl.
    btc_sys_host_tbl-btcsystem = btc_sys_tbl-btcsystem.
    btc_sys_host_tbl-instname  = btc_sys_tbl-instname.
    APPEND btc_sys_host_tbl.
  ENDLOOP.

  FREE field_tbl.
  field_tbl-tabname    = 'BTCTGTITBL'.

  field_tbl-fieldname  = 'BTCSYSTEM'.
  field_tbl-selectflag = 'X'.
  APPEND field_tbl.

  CALL FUNCTION 'HELP_VALUES_GET_WITH_TABLE'
    EXPORTING
      tabname      = field_tbl-tabname
      fieldname    = field_tbl-fieldname
    IMPORTING
      select_value = selected_system
    TABLES
      fields       = field_tbl
      valuetab     = btc_sys_host_tbl
    EXCEPTIONS
      OTHERS       = 99.

  IF sy-subrc EQ 0.
    host-low = selected_system.
  ENDIF.

ENDFORM.                    " SHOW_SERVER_LIST

*&---------------------------------------------------------------------*
*&      Form  CHECK_SERVER
*&---------------------------------------------------------------------*
*       Prüfung, ob Server aktiv                                       *
*----------------------------------------------------------------------*
FORM check_server.

  LOOP AT host.
    LOOP AT btc_sys_tbl WHERE btcsystem = host-low.
      EXIT.
    ENDLOOP.
    IF sy-subrc <> 0.
      MESSAGE e523 WITH host-low.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " CHECK_SERVER

*======================================================================*
* Ereignis : AT SELECTION-SCREEN (PAI-Zeitpunkt)                       *
*            letztes PAI-Ereignis                                      *
*======================================================================*
AT SELECTION-SCREEN.
  IF sy-ucomm = 'SPAL'.
    IF gs_sd_alv-variant IS INITIAL.
      PERFORM reuse_alv_variant_fill USING sy-repid
                                           trvog
                                           space
                                           sy-uname
                                           gs_sd_alv-variant.
    ENDIF.
    DATA: lv_viewname LIKE dd02l-tabname.
    lv_viewname = 'VKDFIF'.
    gs_sd_alv-variant-report = 'SAPLV60P'.
    PERFORM reuse_alv_fieldcatalog_merge USING gs_sd_alv-fieldcat[]
                                               lv_viewname
                                               space
                                               space.
    CALL FUNCTION 'REUSE_ALV_VARIANT_SELECT'
      EXPORTING
        i_dialog            = 'X'
        i_user_specific     = 'A'
        i_default           = space
        it_default_fieldcat = gs_sd_alv-fieldcat[]
        i_layout            = gs_sd_alv-layout
      IMPORTING
        et_fieldcat         = gs_sd_alv-fieldcat[]
        et_sort             = gs_sd_alv-sort[]
        et_filter           = gs_sd_alv-filter[]
      CHANGING
        cs_variant          = gs_sd_alv-variant
      EXCEPTIONS
        wrong_input         = 1
        fc_not_complete     = 2
        not_found           = 3
        program_error       = 4
        OTHERS              = 5.
    SET SCREEN sy-dynnr.
    LEAVE SCREEN.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  SHOW_JOBS_ALV
*&---------------------------------------------------------------------*
FORM show_jobs_alv .
  DATA : lst_print TYPE slis_print_alv.
*Build fieldcatalog
  PERFORM fieldcat_alv_build CHANGING gt_fieldcat.

*Build layout
  PERFORM layout_build CHANGING gt_layout.
  lst_print-print = 'X'.
  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
      i_callback_program    = gd_repid
      is_layout             = gt_layout
      it_fieldcat           = gt_fieldcat
      i_suppress_empty_data = 'X'
*     IS_PRINT              = lst_print
    TABLES
      t_outtab              = gt_output
    EXCEPTIONS
      program_error         = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " SHOW_JOBS_ALV

*&---------------------------------------------------------------------*
*&      Form  FIELDCAT_ALV_BUILD
*&---------------------------------------------------------------------*
FORM fieldcat_alv_build  CHANGING pt_fieldcat TYPE slis_t_fieldcat_alv.

  DATA : ls_fieldcat TYPE slis_fieldcat_alv.

  REFRESH pt_fieldcat.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = gd_repid
      i_structure_name       = gc_strct
    CHANGING
      ct_fieldcat            = pt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT pt_fieldcat INTO ls_fieldcat.
    CASE ls_fieldcat-fieldname.
      WHEN 'JOBNAME'.
        ls_fieldcat-seltext_l     = text-001.
        ls_fieldcat-seltext_m     = text-001.
        ls_fieldcat-seltext_s     = text-001.
        ls_fieldcat-ddictxt       = 'M'.
        ls_fieldcat-reptext_ddic  = text-001.
        MODIFY pt_fieldcat FROM ls_fieldcat.
      WHEN 'HOST'.
        ls_fieldcat-seltext_l     = text-005.
        ls_fieldcat-seltext_m     = text-005.
        ls_fieldcat-seltext_s     = text-005.
        ls_fieldcat-ddictxt       = 'M'.
        ls_fieldcat-reptext_ddic  = text-005.
        MODIFY pt_fieldcat FROM ls_fieldcat.
    ENDCASE.
  ENDLOOP.

ENDFORM.                    " FIELDCAT_ALV_BUILD

*&---------------------------------------------------------------------*
*&      Form  LAYOUT_BUILD
*&---------------------------------------------------------------------*
FORM layout_build  CHANGING lt_layout TYPE slis_layout_alv.

  lt_layout-colwidth_optimize = 'X'.

ENDFORM.                    " LAYOUT_BUILD
*&---------------------------------------------------------------------*
*&      Form  F_VERIFY_STATUS_OF_CHILD_JOBS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_verify_status_of_child_jobs .
  DATA: lv_job_name           TYPE btcjob,
        lv_job_count          TYPE btcjobcnt,
        lv_dailog             TYPE c VALUE 'N',
        li_step               TYPE STANDARD TABLE OF tbtcstep,
        lst_job_head          TYPE tbtcjob,
        lst_ret               TYPE bapiret2,
        lv_ext_user           TYPE bapixmlogr-extuser VALUE 'Batch',
        btc_close_job         TYPE btch0000-int4 VALUE 29,
        btc_read_jobhead_only TYPE btch0000-int4 VALUE 19,
        lv_job_log            TYPE char100,
        lv_job_abort          TYPE c.
*--*Check each child job status
  IF test = space.
**--*Remove already finished jobs from child jobs internal table
    DELETE i_child_jobs WHERE remove = abap_true.
    PERFORM f_check_jobs_status.
    DO.
      READ TABLE i_child_jobs INTO DATA(lst_child_jobs) WITH KEY jobstatus = space.
      IF sy-subrc NE 0.
        READ TABLE i_child_jobs INTO DATA(lst_child_jobs3) WITH KEY jobstatus = 'R'.
      ENDIF.
*--*If child jobs status is active, keep checking the status until finished
      IF sy-subrc EQ 0.
        PERFORM f_check_jobs_status.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.
*--*Update Job log and Spool
    LOOP AT i_child_jobs INTO DATA(lst_child_jobs2) WHERE jobstatus = gc_chara.
      lv_job_abort = abap_true.
      CONCATENATE text-009 lst_child_jobs2-jobname INTO lv_job_log.
      MESSAGE lv_job_log TYPE 'I'.
    ENDLOOP.
*--*Cancel Main job when child jobs get cancelled
    IF lv_job_abort = abap_true.
      PERFORM show_jobs_alv.
      MESSAGE text-010 TYPE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_JOBS_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_check_jobs_status .
  DATA: lv_status   TYPE tbtcjob-status,
        lv_msg(100).
*--*Check status of each job
  LOOP AT i_child_jobs ASSIGNING FIELD-SYMBOL(<fs_child_jobs>).
    CLEAR lv_status.
    CALL FUNCTION 'BP_JOB_STATUS_GET'
      EXPORTING
        jobcount                   = <fs_child_jobs>-jobcount
        jobname                    = <fs_child_jobs>-jobname
*       READ_ONLY_STATUS           =
      IMPORTING
        status                     = lv_status
*       HAS_CHILD                  =
      EXCEPTIONS
        job_doesnt_exist           = 1
        unknown_error              = 2
        parent_child_inconsistency = 3
        OTHERS                     = 4.
    IF sy-subrc <> 0.
      MOVE gc_charf TO <fs_child_jobs>-jobstatus.
    ELSE.
*--*If job status is finished or cancelled
      IF lv_status EQ gc_charf OR lv_status EQ gc_chara.
*--*Update job log for finished one, only first time
        IF lv_status EQ gc_charf AND <fs_child_jobs>-jobstatus NE gc_charf.
          CONCATENATE text-012 <fs_child_jobs>-jobname INTO lv_msg.
          MESSAGE lv_msg TYPE 'I'.
          v_doc_count = v_doc_count + <fs_child_jobs>-created_orders.
          v_rem_docs = v_total_docs - v_doc_count.
          CONCATENATE text-019 v_total_docs text-020 v_doc_count text-021 v_rem_docs INTO lv_msg SEPARATED BY ''.
          MESSAGE lv_msg TYPE 'I'.
          MESSAGE text-023 TYPE 'I'.
        ENDIF.
*--*Update Job log for the cancelled one only first one
        IF lv_status EQ gc_chara AND <fs_child_jobs>-jobstatus NE gc_chara.
          CONCATENATE text-013 <fs_child_jobs>-jobname INTO lv_msg.
          MESSAGE lv_msg TYPE 'I'.
*--*Reschedule the cancelled job only once
          IF <fs_child_jobs>-jobstatus NE 'R'. "Means rescheduled already
            PERFORM f_reschedule_cancelled_job USING <fs_child_jobs>-jobcount
                                                     <fs_child_jobs>-jobname
                                               CHANGING <fs_child_jobs>-remove.
          ENDIF.
        ENDIF.
        MOVE lv_status TO <fs_child_jobs>-jobstatus.
      ENDIF.
      IF <fs_child_jobs>-jobstatus = gc_charz."space or charz means job is still active
        CLEAR : <fs_child_jobs>-jobstatus.
      ENDIF.
    ENDIF.
  ENDLOOP.
*--*Remove rescheduled job from child jobs for further status check
  DELETE i_child_jobs WHERE remove = abap_true.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_constants .
  TYPES: BEGIN OF lty_constant,
           devid    TYPE zdevid,              " Development ID
           param1   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
           param2   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
           srno     TYPE tvarv_numb,          " ABAP: Current selection number
           sign     TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
           opti     TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
           low      TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
           high     TYPE salv_de_selopt_high, " Upper Value of Selection Condition
           activate TYPE zconstactive,      "Activation indicator for constant
         END OF lty_constant.
  DATA : li_constants  TYPE STANDARD TABLE OF lty_constant,
         lst_constants TYPE lty_constant.
  CONSTANTS : lc_devid   TYPE zdevid VALUE 'E227',
              lc_docs    TYPE rvari_vnam VALUE 'NO_OF_RECORDS',
              lc_percent TYPE rvari_vnam VALUE 'SERVER_PERCENTAGE'.
  SELECT devid            " Development ID
         param1           " ABAP: Name of Variant Variable
         param2           " ABAP: Name of Variant Variable
         srno             " Current selection number
         sign             " ABAP: ID: I/E (include/exclude values)
         opti             " ABAP: Selection option (EQ/BT/CP/...)
         low              " Lower Value of Selection Condition
         high             " Upper Value of Selection Condition
         activate         " Activation indicator for constant
         FROM zcaconstant " Wiley Application Constant Table
         INTO TABLE li_constants
         WHERE devid    = lc_devid
         AND   activate = abap_true. " Only active record
  IF sy-subrc EQ 0.
    LOOP AT li_constants INTO lst_constants.
      CASE lst_constants-param1.
        WHEN lc_docs.
          v_no_docs = lst_constants-low.
        WHEN lc_percent.
          v_serv_per = lst_constants-low.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ASSIGN_SERVERS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_assign_servers .
  DATA : lv_total_btc    TYPE i,
         lv_free_btc     TYPE i,
         lv_percentage   TYPE p DECIMALS 4,
         lv_index        TYPE sy-tabix VALUE 1,
         lv_no_more_jobs TYPE c,
         lv_server_name  TYPE msname2.
  IF btc_sys_tbl[] IS NOT INITIAL.
    DO.
*--*Check availability of Work processes for each server
      LOOP AT btc_sys_tbl.
        lv_server_name = btc_sys_tbl-instname.
        CALL FUNCTION 'TH_COUNT_WPS'
          EXPORTING
            server       = lv_server_name
          IMPORTING
            btc_wps      = lv_total_btc
            free_btc_wps = lv_free_btc
          EXCEPTIONS
            failed       = 1
            OTHERS       = 2.
        IF sy-subrc = 0 AND numbjobs IS NOT INITIAL.
*--*Calculate availability percentage
          lv_percentage = lv_free_btc / lv_total_btc * 100.
*--*If availability is more than mainatined in constnat table
          IF lv_percentage GT v_serv_per.
*--*Schedule number of jobs per server
            DO numbjobs TIMES.
              READ TABLE i_child_jobs INTO st_child_jobs  INDEX lv_index.
              IF sy-subrc EQ 0.
                jobname = st_child_jobs-jobname.
                jobcount = st_child_jobs-jobcount.
                host-low = btc_sys_tbl-btcsystem.
                created_steps = st_child_jobs-created_steps.
                created_custs = st_child_jobs-created_custs.
                created_orders = st_child_jobs-created_orders.
*--*Provide the host details and other to be printed info to close Job
                PERFORM close_job USING host-low
                      created_steps created_custs created_orders.
                ADD 1 TO lv_index.
              ELSE.
                lv_no_more_jobs = abap_true.
                EXIT.
              ENDIF.
            ENDDO.
          ENDIF.
        ELSE.
          lv_no_more_jobs = abap_true.
        ENDIF.
      ENDLOOP.
      IF lv_no_more_jobs = abap_true.
        EXIT.
      ENDIF.
    ENDDO.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_RESCHEDULE_CANCELLED_JOB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_CHILD_JOBS>_JOBCOUNT  text
*      -->P_<FS_CHILD_JOBS>_JOBNAME  text
*----------------------------------------------------------------------*
FORM f_reschedule_cancelled_job  USING    fp_jobcount TYPE tbtcjob-jobcount
                                          fp_jobname TYPE tbtcjob-jobname
                                          fp_remove TYPE c.
  DATA : lv_dailog       TYPE btch0000-char1 VALUE 'N',
         lv_job_name_new TYPE tbtcjob-jobname,
         lst_jobhead     TYPE tbtcjob,
         lv_server       TYPE btctgtsys,
         lv_msg(100)..
  CONCATENATE fp_jobname 'Res' INTO lv_job_name_new SEPARATED BY '-'.
  CALL FUNCTION 'BP_JOB_COPY'
    EXPORTING
      dialog                  = lv_dailog
      source_jobcount         = fp_jobcount
      source_jobname          = fp_jobname
      target_jobname          = lv_job_name_new
      step_number             = 1
    IMPORTING
      new_jobhead             = lst_jobhead
** CHANGING
**   RET                           =
    EXCEPTIONS
      cant_create_new_job     = 1
      cant_enq_job            = 2
      cant_read_sourcedata    = 3
      invalid_opcode          = 4
      jobname_missing         = 5
      job_copy_canceled       = 6
      no_copy_privilege_given = 7
      no_plan_privilege_given = 8
      OTHERS                  = 9.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    immedi = abap_true.
    CONCATENATE text-014 lst_jobhead-jobname INTO lv_msg.
    MESSAGE lv_msg TYPE 'I'.
*--*Check available server from server group
    PERFORM f_check_available_server CHANGING lv_server.
    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobname              = lst_jobhead-jobname
        jobcount             = lst_jobhead-jobcount
        strtimmed            = immedi
        targetsystem         = lv_server
      EXCEPTIONS
        cant_start_immediate = 01
        invalid_startdate    = 02
        jobname_missing      = 03
        job_close_failed     = 04
        job_nosteps          = 05
        job_notex            = 06
        lock_failed          = 07
        OTHERS               = 08.
    IF sy-subrc EQ 0.
      st_child_jobs-jobname  = lst_jobhead-jobname.
      st_child_jobs-jobcount = lst_jobhead-jobcount.
      st_child_jobs-jobstatus = 'R'. "Rescheduled
      APPEND st_child_jobs TO i_child_jobs.
      CLEAR : st_child_jobs.
      fp_remove = abap_true.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_AVAILABLE_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LV_SERVER  text
*----------------------------------------------------------------------*
FORM f_check_available_server  CHANGING fp_lv_server TYPE btctgtsys.
  DATA:lv_total_btc   TYPE i,
       lv_free_btc    TYPE i,
       lv_server_name TYPE msname2,
       lv_percentage  TYPE p DECIMALS 4.
  DO.
*--*Check availability of Work processes for each server
    LOOP AT btc_sys_tbl.
      lv_server_name = btc_sys_tbl-instname.
      CALL FUNCTION 'TH_COUNT_WPS'
        EXPORTING
          server       = lv_server_name
        IMPORTING
          btc_wps      = lv_total_btc
          free_btc_wps = lv_free_btc
        EXCEPTIONS
          failed       = 1
          OTHERS       = 2.
      IF sy-subrc = 0.
*--*Calculate availability percentage
        lv_percentage = lv_free_btc / lv_total_btc * 100.
*--*If availability is more than mainatined in constnat table
        IF lv_percentage GT v_serv_per.
          fp_lv_server = btc_sys_tbl-btcsystem.
          EXIT.
        ENDIF.
      ELSE.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF fp_lv_server IS NOT INITIAL.
      EXIT.
    ENDIF.
  ENDDO.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_JOB_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_update_job_log .
  DATA: lv_status   TYPE tbtcjob-status,
        lv_msg(100).
*--*Check status of each job
  LOOP AT i_child_jobs ASSIGNING FIELD-SYMBOL(<fs_child_jobs>) WHERE job_closed = abap_true.
    CLEAR lv_status.
    CALL FUNCTION 'BP_JOB_STATUS_GET'
      EXPORTING
        jobcount                   = <fs_child_jobs>-jobcount
        jobname                    = <fs_child_jobs>-jobname
*       READ_ONLY_STATUS           =
      IMPORTING
        status                     = lv_status
*       HAS_CHILD                  =
      EXCEPTIONS
        job_doesnt_exist           = 1
        unknown_error              = 2
        parent_child_inconsistency = 3
        OTHERS                     = 4.
    IF sy-subrc = 0 AND lv_status = gc_charf AND <fs_child_jobs>-jobstatus NE gc_charf.."Update finished job status
      CONCATENATE text-012 <fs_child_jobs>-jobname INTO lv_msg.
      MESSAGE lv_msg TYPE 'I'.
      CLEAR : lv_msg.
      v_doc_count = v_doc_count + <fs_child_jobs>-created_orders.
      v_rem_docs = v_total_docs - v_doc_count.
      CONCATENATE text-019 v_total_docs text-020 v_doc_count text-021 v_rem_docs INTO lv_msg SEPARATED BY ''.
      MESSAGE lv_msg TYPE 'I'.
      MESSAGE text-023 TYPE 'I'.
      <fs_child_jobs>-remove = abap_true.
      <fs_child_jobs>-jobstatus = gc_charf.
    ELSEIF lv_status = gc_charr AND <fs_child_jobs>-jobstatus NE gc_charz. "Update Active job status
      CONCATENATE text-018 <fs_child_jobs>-jobname INTO lv_msg.
      MESSAGE lv_msg TYPE 'I'.
      <fs_child_jobs>-jobstatus = gc_charz.
    ENDIF.
  ENDLOOP.

ENDFORM.
