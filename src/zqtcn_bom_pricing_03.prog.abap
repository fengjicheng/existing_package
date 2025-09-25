*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BOM_PRICING_03 (Include)
*               Called from "Routine 994 (RV64A994)"
* PROGRAM DESCRIPTION: Calculate Tax for BOM Header
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   20-MAY-2017
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K905792
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:
  lv_xvbap_f TYPE char40 VALUE '(SAPMV45A)XVBAP[]',             "Sales Document: Item Data
  lv_xkomv_f TYPE char40 VALUE '(SAPMV45A)XKOMV[]'.             "Pricing Communications-Condition Record

DATA:
  li_xvbap_f TYPE va_vbapvb_t,                                  "Sales Document: Item Data
  li_xvbap_b TYPE va_vbapvb_t,                                  "Sales Document: Item Data (BOM)
  li_xkomv_f TYPE va_komv_t,                                    "Pricing Communications-Condition Record
  li_xkomv_t TYPE va_komv_t.                                    "Pricing Communications-Condition Record (Tax)

* Sales Document: Item Data
ASSIGN (lv_xvbap_f) TO FIELD-SYMBOL(<li_xvbap>).
IF sy-subrc EQ 0.
  li_xvbap_f = <li_xvbap>.
ENDIF.
* Pricing Communications-Condition Record
ASSIGN (lv_xkomv_f) TO FIELD-SYMBOL(<li_xkomv>).
IF sy-subrc EQ 0.
  li_xkomv_f = <li_xkomv>.
ENDIF.

IF li_xvbap_f IS NOT INITIAL AND                                "Sales Document: Item Data
   li_xkomv_f IS NOT INITIAL.                                   "Pricing Communications-Condition Record
* Get Sales Document: Item Data details
  READ TABLE li_xvbap_f ASSIGNING FIELD-SYMBOL(<lst_xvbap_l>)
       WITH KEY posnr = xkomv-kposn.
  IF sy-subrc EQ 0 AND
     <lst_xvbap_l>-uepos IS INITIAL.                            "Check for BOM Header
*   Identify the BOM Line Items (Components) using Higher-level item in BOM structure
    li_xvbap_b[] = li_xvbap_f[].
    DELETE li_xvbap_b WHERE uepos NE <lst_xvbap_l>-posnr.

    IF li_xvbap_b IS NOT INITIAL.                               "If BOM Line Item (Component) exists
      CLEAR: xkwert.
*     Go through all BOM Line Items (Components)
      LOOP AT li_xvbap_b ASSIGNING FIELD-SYMBOL(<lst_xvbap_b>).
*       Identify Condition Type value of the BOM Line Item (Component)
        li_xkomv_t[] = li_xkomv_f[].
        DELETE li_xkomv_t WHERE kposn NE <lst_xvbap_b>-posnr
                             OR kschl NE xkomv-kschl.
        LOOP AT li_xkomv_t ASSIGNING FIELD-SYMBOL(<lst_xkomv_l>).
*         Sum up Condition Type values of all the BOM Line Items (Components)
          xkwert = xkwert + <lst_xkomv_l>-kwert.
        ENDLOOP.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDIF.
