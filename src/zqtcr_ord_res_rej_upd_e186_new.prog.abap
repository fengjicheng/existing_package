*&---------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCR_ORD_RES_REJ_UPD_E186
* PROGRAM DESCRIPTION: This program implemented for to apply reason
*                      for rejection to the Cancelled Contract Lines
* DEVELOPER:           Siva Guda (SGUDA) / Geeta
* CREATION DATE:       01/10/2019
* OBJECT ID:           E186
* TRANSPORT NUMBER(S): ED2K914211
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  OTCM-29655
* REFERENCE NO: ED2K915695
* DEVELOPER: Siva Guda (SGUDA)
* DATE: 12-21-2020
* DESCRIPTION: Auto rejection on release order
* 1) Add order type as VBAK-AUART in Excel file.
* 2) Change Mail Body
* 3) Add reason for rejection for subsequent documents.
*----------------------------------------------------------------------*
REPORT zqtcr_ord_res_rej_upd_e186_new NO STANDARD PAGE HEADING  MESSAGE-ID zqtc_r2.
*** INCLUDES-------------------------------------------------------------*
*- For Declaration
INCLUDE ZQTCN_ORD_RES_REJ_UPD_TOP_NEW.
*INCLUDE zqtcn_ord_res_rej_upd_top IF FOUND.

*- For Selection screen
INCLUDE ZQTCN_ORD_RES_REJ_UPD_SEL_NEW.
*INCLUDE zqtcn_ord_res_rej_upd_sel IF FOUND.

*- For subroutines
INCLUDE ZQTCN_ORD_RES_REJ_UPD_SUB_NEW.
*INCLUDE zqtcn_ord_res_rej_upd_sub IF FOUND.

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

*Validate Document Type
  PERFORM f_val_doctype.

START-OF-SELECTION.
  PERFORM batch_job.
  li_mail[] = s_mail[].
