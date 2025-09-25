*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_PROF_INV_CREATE_E182
* PROGRAM DESCRIPTION: This program implemented for to create Regular Invoice
*                      Proforma Invoice by using BAPI
* DEVELOPER: Siva Guda (SGUDA)
* CREATION DATE: 08/22/2018
* OBJECT ID: WRICEF - E182
* TRANSPORT NUMBER(S): ED2K913168
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
REPORT zqtc_prof_inv_create_e182  NO STANDARD PAGE HEADING  MESSAGE-ID zqtc_r2.
*** INCLUDES-------------------------------------------------------------*
*- For Declaration
INCLUDE zqtc_prof_inv_create_top.
*INCLUDE zqtcc_create_invoice_vf04_top IF FOUND.
*- For Selection screen
INCLUDE zqtc_prof_inv_create_sel.
*INCLUDE zqtcc_create_invoice_vf04_sel IF FOUND.
*- For subroutines
INCLUDE zqtc_prof_inv_create_sub.
*INCLUDE zqtcc_create_invoice_vf04_sub IF FOUND.
*====================================================================*
*I N I T I A L I Z A T I O N
*====================================================================*
INITIALIZATION.
  PERFORM f_initialization.
  PERFORM f_dynamic.
*====================================================================*
* A T  S E L E C T I O N  S C R E E N  O U T P U T
*====================================================================*
AT SELECTION-SCREEN OUTPUT.
*  PERFORM f_dynamic.
*----------------------------------------------------------------------*
*                AT SELECTION SCREEN ON                *
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON s_fkdat.
  IF s_fkdat[] IS NOT INITIAL.
* Validate Billing Date
    PERFORM f_validate_fkdat.
  ENDIF. " IF s_fkdat IS NOT INITIAL

AT SELECTION-SCREEN ON s_vbeln.
  IF s_vbeln[] IS NOT INITIAL.
* Validate Sales Document
    PERFORM f_validate_vbeln.
  ENDIF. " IF s_vbeln IS NOT INITIAL

AT SELECTION-SCREEN ON s_kunnr.
  IF s_kunnr[] IS NOT INITIAL.
* Validate Sold-to
    PERFORM f_validate_kunnr.
  ENDIF. " IF s_kunnr IS NOT INITIAL

AT SELECTION-SCREEN ON s_fkart.
  IF s_fkart[] IS NOT INITIAL.
* Validate Billing Type
    PERFORM f_validate_fkart.
  ENDIF. " IF s_fkart IS NOT INITIAL

AT SELECTION-SCREEN ON s_vkbur.
  IF s_vkbur[] IS NOT INITIAL.
* Validate Sales Office
    PERFORM f_validate_vkbur.
  ENDIF. " IF s_vkbur IS NOT INITIAL

AT SELECTION-SCREEN ON s_bsark.
  IF s_bsark[] IS NOT INITIAL.
* Validate PO Type
    PERFORM f_validate_bsark.
  ENDIF. " IF s_bsark IS NOT INITIAL
*--------------------------------------------------------------------*
*   START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.
* Get Data based on selection
  PERFORM f_get_data.
* Process Invoice creation
  PERFORM f_create_invoice.
*--------------------------------------------------------------------*
*   END-OF-SELECTION
*--------------------------------------------------------------------*
END-OF-SELECTION.
* Display the log
*  IF li_msg_log[] IS NOT INITIAL.
    PERFORM f_display_log.
*  ENDIF.
