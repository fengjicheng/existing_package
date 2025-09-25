*&---------------------------------------------------------------------*
*& Report  ZQTCR_WLS_QUOTATION_RNWL_F065
*&---------------------------------------------------------------------*
* PROGRAM NAME    : ZQTCR_WLS_QUOTATION_RNWL_F065
* DESCRIPTION     : This driver program implemented for WLS
*                   Quotation Renewal forms F065
* DEVELOPER       : VDPATABALL
* CREATION DATE   : 06/29/2020
* OBJECT ID       : ERPM-20839/F065
* TRANSPORT NUMBER(S):ED2K918582
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K920414
* REFERENCE NO    : OTCM-32214 /F067
* DEVELOPER       : VDPATABALL
* DATE            : 11/23/2020
* DESCRIPTION     : WES DA-New Quotation form changes
*----------------------------------------------------------------------*
REPORT zqtcr_wls_quotation_rnwl_f065  NO STANDARD PAGE HEADING.

TYPE-POOLS: szadr.

*- Top include
INCLUDE zqtcn_wls_quotat_rnwl_f065_top.

*- Subroutine
INCLUDE zqtcn_wls_quotat_rnwl_f065_f01.

*--------------------------------------------------------------------*
* f_entry_adobe_form
*--------------------------------------------------------------------*
FORM f_entry_adobe_form  USING  fp_v_ent_retco  LIKE sy-subrc " ABAP System Field: Return Code of ABAP Statements
                                 v_ent_scn      TYPE c.       " Ent_screen of type Character
*- Local Constant Declaration
  CONSTANTS: lc_prntev_new TYPE c VALUE '1', "Neudruck
             lc_prntev_chg TYPE c VALUE '2'. "Änderungsdruck

*- Data declaration
  DATA: lv_xdruvo TYPE t166k-druvo. " Indicator: Print Operation
*--------------------------------------------------------------------*
  v_ent_retco = 0.
  v_ent_screen = v_ent_scn.
  IF nast-aende EQ space.
*- Implement all the processing logic
    PERFORM f_processing_inv_form CHANGING v_ent_retco.
    lv_xdruvo = lc_prntev_new.
  ELSE. " ELSE -> IF nast-aende EQ space
    lv_xdruvo = lc_prntev_chg.
  ENDIF. " IF nast-aende EQ space
  fp_v_ent_retco = v_ent_retco.
ENDFORM.
