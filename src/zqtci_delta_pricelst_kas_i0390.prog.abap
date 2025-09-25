*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCI_DELTA_PRICELST_KAS_I0390
* PROGRAM DESCRIPTION: Copy program w.r.t I0336
*                      Delta Price List for KAS from SAP
* DEVELOPER(S):        Nageswara
* CREATION DATE:       02/Nov/2020
* OBJECT ID:           I0390
* TRANSPORT NUMBER(S): ED2K920157
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtci_delta_pricelst_kas_i0390.

INCLUDE zqtcn_delta_prilst_top IF FOUND.

INCLUDE zqtcn_delta_prilst_sel IF FOUND.

INCLUDE zqtcn_delta_prilst_sub IF FOUND.


INITIALIZATION.
* Populate Default values of Selection Screen fields
  PERFORM f_default_values.

START-OF-SELECTION.
* SOC by NPOLINA OTCM-6914 ED2K920157
  IF ( s_date-high - s_date-low ) > v_runlimit AND sy-batch IS INITIAL.
    v_batch = abap_true.
  ENDIF.

  IF v_batch IS INITIAL AND sy-batch IS INITIAL.
    v_batch = abap_true.
* EOC by NPOLINA OTCM-6914 ED2K920157
* Run in Foreground
    CALL SCREEN 100.

* SOC by NPOLINA OTCM-6914 ED2K920157
  ELSEIF v_batch IS NOT INITIAL AND sy-batch IS INITIAL..
* Submit to Background Job
    PERFORM f_submit_program_background.
  ELSEIF sy-batch IS NOT INITIAL.
* Execute and Process Background jon from SM37
    PERFORM f_process_batch_logic.
  ENDIF.
* EOC by NPOLINA OTCM-6914 ED2K920157
