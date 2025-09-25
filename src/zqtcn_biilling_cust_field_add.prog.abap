*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_BIILLING_CUST_FIELD_ADD
* PROGRAM DESCRIPTION:Custom Copy control.
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-10-02
* OBJECT ID:E070
* TRANSPORT NUMBER(S):ED2K903028
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
 CONSTANTS:
   lc_tab_strp7 TYPE char20    VALUE 'TABSTRIP_TAB07',
   lc_custm_fld TYPE char40    VALUE 'Custom Fields',
   lc_prog_name TYPE syrepid   VALUE 'SAPMZQTC_BILLING_ADD_FIELD',
   lc_scrn_9001 TYPE sydynnr   VALUE '9001'.

 LOOP AT SCREEN .
   IF screen-name EQ lc_tab_strp7 .           "'TABSTRIP_TAB07'.
     gs_cust_tab-item_caption = lc_custm_fld. "'Custom Fields'.
     gs_cust_tab-item_program = lc_prog_name. "'ZQTCR_BIILLING_CUST_FIELD_ADD'.
     gs_cust_tab-item_dynpro  = lc_scrn_9001. "'9001'.
     IF NOT gs_cust_tab-item_dynpro IS INITIAL.
       screen-active = 1.
       screen-invisible = 0.
       MODIFY SCREEN.
       tabstrip_tab07 = gs_cust_tab-item_caption.
     ENDIF.
   ENDIF.
 ENDLOOP.
