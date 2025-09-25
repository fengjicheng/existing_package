*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCR_ORD_RES_REJ_UPD_E186
* PROGRAM DESCRIPTION: This program implemented for to apply reason
*                      for rejection to the Cancelled Contract Lines
* DEVELOPER:           Siva Guda (SGUDA) / Geeta
* CREATION DATE:       01/10/2019
* OBJECT ID:           E186
* TRANSPORT NUMBER(S): ED2K914211
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION NO : ED2K921929/ED2K922697/ED2K922788/ED2K922941            *
* REFERENCE NO: OTCM-43362 / OTCM-29655                                            *
* DEVELOPER   : Prabhu (PTUFARAM)                          *
* DATE        : 03/25/2021                               *
* DESCRIPTION : Adding sales org and Item category exclusion
*              OTCM-43362 is replaced with OTCM-29655
*----------------------------------------------------------------------*
* REVISION NO : ED2K926559
* REFERENCE NO: EAM-1661
* DEVELOPER   : Vishnu (VCHITTIBAL)
* DATE        : 06/04/2022
* OBJECT ID   : E505
* DESCRIPTION : Adding new functionality to update reason for rejection
*               for Back orders
*----------------------------------------------------------------------*
REPORT zqtcr_ord_res_rej_upd_e186 NO STANDARD PAGE HEADING  MESSAGE-ID zqtc_r2.
*** INCLUDES-------------------------------------------------------------*
*- For Declaration
INCLUDE zqtcn_ord_res_rej_upd_top IF FOUND.

*- For Selection screen
INCLUDE zqtcn_ord_res_rej_upd_sel IF FOUND.

*- For subroutines
INCLUDE zqtcn_ord_res_rej_upd_sub IF FOUND.

*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.

* To restrict the select options
    PERFORM f_sel_dynamics.

* To refresh the global varaibles
    PERFORM f_initialization.

* To change selection screen dynamics.
    PERFORM f_screen_dynamics.

*--*BOC EAM-1661 Vishnu ED2K926559 06/04/2022

* To refresh the global varaibles
    PERFORM f_initialization_apl.

* To change selection screen dynamics.
    PERFORM f_screen_dynamics_apl.

*====================================================================*
* AT SELECTION-SCREEN OUTPUT.
*=======================================================
AT SELECTION-SCREEN OUTPUT.
* To Dynamic change the selection screen based on radio button selection
  PERFORM f_screen_output.
*--*EOC EAM-1661 Vishnu ED2K926559 06/04/2022


START-OF-SELECTION.
*--*BOC EAM-1661 Vishnu ED2K926559 06/04/2022
  IF rb_1 EQ abap_true.
*--*EOC EAM-1661 Vishnu ED2K926559 06/04/2022
    PERFORM batch_job.
    li_mail[] = s_mail[].
*--*BOC EAM-1661 Vishnu ED2K926559 06/04/2022
  ELSEIF rb_2 EQ abap_true.
** Mandatory check on Input fields
    PERFORM f_mandatory_check.
    IF sy-batch EQ abap_true.
      PERFORM f_batch_job_apl.
    ELSE.
      PERFORM f_process_foreground.
    ENDIF.
  ENDIF.
*--*EOC EAM-1661 Vishnu ED2K926559 06/04/2022
