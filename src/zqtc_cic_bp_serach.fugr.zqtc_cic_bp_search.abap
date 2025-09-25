FUNCTION ZQTC_CIC_BP_SEARCH.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_PS_RJYCIC_SEARCH) TYPE  RJYCIC_SEARCH OPTIONAL
*"  EXPORTING
*"     VALUE(EX_PS_RJYCIC_SEARCH) TYPE  RJYCIC_SEARCH
*"     VALUE(EX_PARTNER_ERROR) TYPE  XFELD
*"----------------------------------------------------------------------
*------------------------------------------------------------------- *
* PROGRAM NAME: ZQTC_CIC_BP_SEARCH
* PROGRAM DESCRIPTION: This FM will call a screen which contains additional
* search criteria for BP and the BP will be transferred to the main screen
* i.e;CIC screen
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2017-07-01
* OBJECT ID: E157
* TRANSPORT NUMBER(S): ED2K906716(W),ED2K907051(C)
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
*----------------------------------------------------------------------*
  CLEAR: v_partner_error,
         v_bp_search,
         ex_ps_rjycic_search,
         ex_partner_error.

* Call modal dialogue screen
  CALL SCREEN 9001 STARTING AT 20 9 ENDING AT 128 16.

  ex_ps_rjycic_search = im_ps_rjycic_search.

  IF im_ps_rjycic_search-gpnr IS INITIAL.
    ex_ps_rjycic_search-gpnr = v_bp_search-partner.
  ENDIF. " IF im_ps_rjycic_search-gpnr IS INITIAL

  ex_partner_error = v_partner_error.

ENDFUNCTION.
