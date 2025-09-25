*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SSP_PRICING_01 (Include)
*               Called from "Routine 901 (RV64A901)"
* PROGRAM DESCRIPTION: Calculate Standalone Selling Price (SSP)
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   20-MAY-2017
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K903762
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906514
* REFERENCE NO: CR#549
* DEVELOPER: Writtick Roy (WROY)
* DATE:  05-JUN-2017
* DESCRIPTION: SSP for BOM Header should be Zero
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907469
* REFERENCE NO: ERP-3496
* DEVELOPER: Writtick Roy (WROY)
* DATE:  24-JUL-2017
* DESCRIPTION: Check if the Document is being created wrt another one
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K915927
* REFERENCE NO:  E075/ERPM-1435
* DEVELOPER: SKKAIRAMKO
* DATE:  08/21/2019
* DESCRIPTION: Aadding check to skip RETURN Keyword for Item Cat 'ZACC'
*----------------------------------------------------------------------*

DATA:
* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
  lv_xvbap_f TYPE char40 VALUE '(SAPMV45A)XVBAP[]'.             "Sales Document: Item Data
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514

DATA:
  li_const   TYPE zcat_constants,                               "Internal table for Constant Table
* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
  li_const_s TYPE zcat_constants,                               "Internal table for Constant Table
  li_xvbap_f TYPE va_vbapvb_t,                                  "Sales Document: Item Data
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
  li_xkomv_f TYPE va_komv_t,                                    "Pricing Communications-Condition Record
  lir_pstyv  TYPE rjksd_pstyv_range_tab.                        "++E075/ERPM-1435

CONSTANTS:
  lc_param_s TYPE rvari_vnam     VALUE 'SSP_CALC',              "ABAP: Name of Variant Variable
  lc_param_c TYPE rvari_vnam     VALUE 'COND_TYPE',             "ABAP: Name of Variant Variable
  lc_devid   TYPE zdevid         VALUE 'E075',                  "Development ID
  lc_param1  TYPE rvari_vnam     VALUE 'PSTYV'.                 "++E075/ERPM-1435

* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
FIELD-SYMBOLS:
  <li_xvbap> TYPE va_vbapvb_t.                                  "Sales Document: Item Data
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514

CLEAR: xkwert.
* Get data from constant table
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid
  IMPORTING
    ex_constants = li_const.
* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
li_const_s[] = li_const[].
DELETE li_const_s WHERE param1 NE lc_param_s                    "ABAP: Name of Variant Variable (SSP_CALC)
                     OR param2 NE lc_param_c.                   "ABAP: Name of Variant Variable (COND_TYPE)
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514

*--BOC : SKKAIRAMKO - E075/ERPM-1435 - 08/21/2019 ******
STATICS:
  li_constants TYPE zcat_constants.

* Check the table and varable is empty or not.
IF li_constants[] IS INITIAL.
* Fetch Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid  "Development ID
    IMPORTING
      ex_constants = li_constants. "Constant Values
  SORT li_constants BY param1.
 ENDIF.

*--Check the Item Category from ZCACONSTANT
IF li_constants[] IS NOT INITIAL.
* Identify the Valid Item Category
  READ TABLE li_constants TRANSPORTING NO FIELDS
       WITH KEY param1 = lc_param1 "PSTYV
       BINARY SEARCH.
  IF sy-subrc EQ 0. " If record found successfully.
    DATA(lv_tabix) = sy-tabix.
    LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>) FROM lv_tabix.
      IF <lst_constant>-param1 NE lc_param1.
        EXIT.
      ENDIF.

      APPEND INITIAL LINE TO lir_pstyv ASSIGNING FIELD-SYMBOL(<lst_pstyv>).
      <lst_pstyv>-sign   = <lst_constant>-sign.
      <lst_pstyv>-option = <lst_constant>-opti.
      <lst_pstyv>-low    = <lst_constant>-low.
      <lst_pstyv>-high   = <lst_constant>-high.
    ENDLOOP. " LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>) FROM sy-tabix
  ENDIF.
  ENDIF.
*--EOC : SKKAIRAMKO - E075/ERPM-1435 - 08/21/2019 ******

* Sales Document: Item Data
ASSIGN (lv_xvbap_f) TO <li_xvbap>.
IF sy-subrc EQ 0.
* As per SAP's recommendation, SORTing is becoming expensive for huge number of records.
* In stead of that, we should use linear search to avoid overhead of SORTing
* li_xvbap_f = <li_xvbap>.
* SORT li_xvbap_f BY uepos.                                     "As per SAP's recommendation

* Check for BOM Header
* READ TABLE li_xvbap_f TRANSPORTING NO FIELDS
*      WITH KEY uepos = xkomv-kposn
*      BINARY SEARCH.                                           "As per SAP's recommendation

*--BOC : SKKAIRAMKO - E075/ERPM-1435 - 08/21/2019 ******
*  READ TABLE <li_xvbap> TRANSPORTING NO FIELDS
*       WITH KEY uepos = xkomv-kposn.
*  IF sy-subrc EQ 0.
**   Standalone Selling Price (SSP) should be Zero for BOM Header
*    xkwert = 0.
*    RETURN.
*  ENDIF.
  READ TABLE <li_xvbap> INTO DATA(lst_xvbap)
       WITH KEY uepos = xkomv-kposn.
  IF sy-subrc EQ 0.
    IF lst_xvbap-pstyv IN lir_pstyv.
*   Standalone Selling Price (SSP) should be Zero for BOM Header
    xkwert = 0.
      ELSE.
*   Standalone Selling Price (SSP) should be Zero for BOM Header
    xkwert = 0.
    RETURN.
   ENDIF.
 ENDIF.
*--EOC : SKKAIRAMKO - E075/ERPM-1435 - 08/21/2019 ******

ENDIF.

* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514

IF xkomv[] IS NOT INITIAL.                                      "Pricing Communications-Condition Record
* SORT li_xkomv_f BY kposn kschl kinak.                         "As per SAP's recommendation

* Begin of DEL:CR#549:WROY:05-JUN-2017:ED2K906514
* LOOP AT li_const ASSIGNING FIELD-SYMBOL(<lst_const>).
* End   of DEL:CR#549:WROY:05-JUN-2017:ED2K906514
* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
  LOOP AT li_const_s ASSIGNING FIELD-SYMBOL(<lst_const>).
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
*   Get Condition value of the specific Condition type
    READ TABLE xkomv[] ASSIGNING FIELD-SYMBOL(<lst_xkomv_f>)
         WITH KEY kposn = xkomv-kposn
                  kschl = <lst_const>-low
                  kinak = space.
*        BINARY SEARCH.                                         "As per SAP's recommendation
    IF sy-subrc EQ 0.
      xkwert = <lst_xkomv_f>-kwert.
      EXIT.
    ENDIF.

    IF <lst_const>-high EQ abap_true.
*     Get Condition value of the default Condition type
      READ TABLE xkomv[] ASSIGNING <lst_xkomv_f>
           WITH KEY kposn = xkomv-kposn
                    kschl = <lst_const>-low.
*          BINARY SEARCH.                                       "As per SAP's recommendation
      IF sy-subrc EQ 0.
        DATA(lv_deflt_kwert) = <lst_xkomv_f>-kwert.
      ENDIF.
    ENDIF.
  ENDLOOP.
* Assign default Condition value (if not assigned already)
  IF xkwert IS INITIAL.
    xkwert = lv_deflt_kwert.
  ENDIF.
ENDIF.
