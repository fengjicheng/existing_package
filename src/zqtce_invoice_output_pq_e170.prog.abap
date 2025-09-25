*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCE_INVOICE_OUTPUT_PQ_E170
* PROGRAM DESCRIPTION: Invoice list output for large orders from PQ
* DEVELOPER: Himanshu Patel (HIPATEL)
* CREATION DATE:   12/20/2017
* OBJECT ID: E170
* TRANSPORT NUMBER(S): ED2K910001
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtce_invoice_output_pq_e170 NO STANDARD PAGE HEADING.

*Include for Global Data Declaration
INCLUDE zqtce_invoice_output_pq_top IF FOUND.

*Include for Selection Screen
INCLUDE zqtce_invoice_output_pq_sel IF FOUND.

*Include for Form Routines
INCLUDE zqtce_invoice_output_pq_f01 IF FOUND.


AT SELECTION-SCREEN OUTPUT.
* Modify Field Properties of Selection Screen
  PERFORM f_modify_screen USING    rb_onli
                                   rb_batch.

AT SELECTION-SCREEN ON s_fkart.
* Validate Billing Type for billing Invoice
  PERFORM f_validate_fkart USING s_fkart[].

AT SELECTION-SCREEN ON s_auart.
* Validate Billing Type for billing Invoice
  PERFORM f_validate_auart USING s_auart[].

START-OF-SELECTION.
*Check enhancement activation
  PERFORM f_enh_control.

*Get Invoice data for large orders
  PERFORM f_get_invoice_details.


*Process Invoice data
  PERFORM f_process_invoice_deta.


END-OF-SELECTION.
  IF rb_batch = 'X' AND sy-batch = abap_true.
* Perform to set the latest run date and time value in ZCAINTERFACE
* in case of background run
    PERFORM f_set_date_val  USING v_cur_rundate
                                  v_cur_runtime.
  ENDIF.  " IF rb_error = 'X' AND sy-batch = abap_true.
