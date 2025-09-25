"Name: \PR:SAPMV60A\FO:CUST_HEAD_ACTIVATE\SE:BEGIN\EI
ENHANCEMENT 0 ZQTCEI_ADD_CUSTOM_TAB.
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCEI_ADD_CUSTOM_TAB (Enhancement)
*               Called from "MV60AF0C_CUST_HEAD_ACTIVATE(SAPMV60A)"
* PROGRAM DESCRIPTION: This enhancement spot is used to create
*                      Custom tab in Invoice header
* DEVELOPER: Manami Chaudhuri
* CREATION DATE:   09/02/2017
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K904422
*----------------------------------------------------------------------*

LOOP AT SCREEN.

  IF screen-name EQ 'TABSTRIP_TAB06'.
    gs_cust_tab-head_caption = 'Custom fields'. "custom tab name
    gs_cust_tab-head_program = 'ZQTCE_E106_INVOICE'." custom program
    gs_cust_tab-head_dynpro = '0001'. " screen number

    IF NOT gs_cust_tab-head_dynpro IS INITIAL.
      screen-active = 1.
      screen-invisible = 0.
      MODIFY SCREEN.
      tabstrip_tab06 = gs_cust_tab-head_caption.
    ENDIF.
  ENDIF.

ENDLOOP.


ENDENHANCEMENT.
