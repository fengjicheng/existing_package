*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BOM_PRICING_02 (Include)
*               Called from "USEREXIT_NEW_PRICING_VBKD(MV45AFZB)"
* PROGRAM DESCRIPTION: Re-trigger Pricing
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   20-DEC-2016
* OBJECT ID: N/A
* TRANSPORT NUMBER(S): ED2K903762
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K905792
* REFERENCE NO: ERP-2500
* DEVELOPER: Writtick Roy (WROY)
* DATE:  01-JUN-2017
* DESCRIPTION: Re-trigger Pricing for Validity period category
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909134
* REFERENCE NO: SAP's Recommendations
* DEVELOPER: Writtick Roy (WROY)
* DATE:  02-NOV-2017
* DESCRIPTION: Do not re-trigger Pricing for BOMs
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909735
* REFERENCE NO: ERP-5421
* DEVELOPER: Writtick Roy (WROY)
* DATE:  06-DEC-2017
* DESCRIPTION: Re-trigger Header Level Pricing if Price and /or Quantity
*              of the BOM Header is changed
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911216
* REFERENCE NO: ERP-6840
* DEVELOPER: Writtick Roy (WROY)
* DATE:  07-FEB-2018
* DESCRIPTION: Removed the logic to "Re-trigger Header Level Pricing if
*              Price and /or Quantity of the BOM Header is changed"
*              The same logic is now available as part of Enhancement
*              Implementation "ZQTCEI_BOM_HDR_REPRICING" [ENHANCEMENT-
*              POINT VBAP_BEARBEITEN_ENDE_17 SPOTS ES_SAPFV45P]
*----------------------------------------------------------------------*
DATA:
* Begin of ADD:E075:WROY:08-AUG-2017:ED2K907469
  li_const_e075 TYPE zcat_constants,                  "Internal table for Constant Table
* End   of ADD:E075:WROY:08-AUG-2017:ED2K907469
  li_xvbap      TYPE va_vbapvb_t.

* Begin of ADD:E075:WROY:08-AUG-2017:ED2K907469
DATA:
  lv_prc_typ TYPE salv_de_selopt_low.                 "Pricing Type
* End   of ADD:E075:WROY:08-AUG-2017:ED2K907469

CONSTANTS:
* Begin of ADD:E075:WROY:08-AUG-2017:ED2K907469
  lc_devid_e075 TYPE zdevid     VALUE 'E075',         "Development ID
  lc_prc_typ    TYPE rvari_vnam VALUE 'PRICING_TYPE', "ABAP: Name of Variant Variable
* End   of ADD:E075:WROY:08-AUG-2017:ED2K907469
  lc_prc_type_c TYPE knprs      VALUE 'C'.            "Pricing Type: C

* Begin of ADD:E075:WROY:08-AUG-2017:ED2K907469
* Get data from constant table
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e075
  IMPORTING
    ex_constants = li_const_e075.
READ TABLE li_const_e075 ASSIGNING FIELD-SYMBOL(<lst_const>)
     WITH KEY param1 = lc_prc_typ                     "Pricing Type (PRICING_TYPE)
     BINARY SEARCH.
IF sy-subrc EQ 0.
  lv_prc_typ = <lst_const>-low.
ENDIF.

* Begin of DEL:SAP's Recommendations:WROY:02-NOV-2017:ED2K909134
*IF st_tvcpa-knprs IS INITIAL OR
*   st_tvcpa-knprs CA lv_prc_typ.
** End   of ADD:E075:WROY:08-AUG-2017:ED2K907469
*  IF vbak-vbtyp EQ charb.                             "Quotation
*    IF vbkd-posnr  EQ posnr_low AND
*       svbkd-tabix GT 0.
*      li_xvbap[] = xvbap[].
**   DELETE li_xvbap WHERE uepos IS INITIAL.
*      DELETE li_xvbap WHERE stlnr IS INITIAL.
*      IF li_xvbap[] IS NOT INITIAL.
*        new_pricing = lc_prc_type_c.
*      ENDIF.
*    ENDIF.
*  ELSE.
*    IF vbkd-posnr  EQ posnr_low AND
*       svbap-tabix GT 0.
*      li_xvbap[] = xvbap[].
**   DELETE li_xvbap WHERE uepos IS INITIAL.
*      DELETE li_xvbap WHERE stlnr IS INITIAL.
*      IF li_xvbap[] IS NOT INITIAL.
*        new_pricing = lc_prc_type_c.
*      ENDIF.
*    ENDIF.
*  ENDIF.
** Begin of ADD:E075:WROY:08-AUG-2017:ED2K907469
*ENDIF.
** End   of ADD:E075:WROY:08-AUG-2017:ED2K907469
* End   of DEL:SAP's Recommendations:WROY:02-NOV-2017:ED2K909134
* Begin of DEL:ERP-6840:WROY:07-FEB-2018:ED2K911216
** Begin of ADD:SAP's Recommendations:WROY:02-NOV-2017:ED2K909134
**  Header Level Pricing
** Begin of DEL:ERP-5421:WROY:06-DEC-2017:ED2K909735
**IF vbkd-posnr IS INITIAL AND
** End   of DEL:ERP-5421:WROY:06-DEC-2017:ED2K909735
** Begin of ADD:ERP-5421:WROY:06-DEC-2017:ED2K909735
*IF vbkd-posnr IS NOT INITIAL AND
** End   of ADD:ERP-5421:WROY:06-DEC-2017:ED2K909735
*   vbap-posnr IS NOT INITIAL.
** BOM Header
*  IF vbap-uepos IS INITIAL AND
*     vbap-stlnr IS NOT INITIAL.
**   Change in Amount / Quantity
*    IF vbap-kzwi3  NE *vbap-kzwi3 OR
*       vbap-kwmeng NE *vbap-kwmeng.
**     Begin of DEL:ERP-5421:WROY:06-DEC-2017:ED2K909735
**     new_pricing = lc_prc_type_c.                        "Pricing Type: C
**     End   of DEL:ERP-5421:WROY:06-DEC-2017:ED2K909735
**     Begin of ADD:ERP-5421:WROY:06-DEC-2017:ED2K909735
**     Call the standard Subroutine for Repricing at the Header level
*      PERFORM preisfindung_gesamt IN PROGRAM sapmv45a IF FOUND
*        USING lc_prc_type_c.                              "Pricing Type: C
**     End   of ADD:ERP-5421:WROY:06-DEC-2017:ED2K909735
*    ENDIF.
*  ENDIF.
*ENDIF.
** End   of ADD:SAP's Recommendations:WROY:02-NOV-2017:ED2K909134
* End   of DEL:ERP-6840:WROY:07-FEB-2018:ED2K911216

* Begin of DEL:ERP-7231:WROY:22-Mar-2018:ED2K911556
*IF veda-vlaufk NE *veda-vlaufk.                       "Validity period category of contract
* End   of DEL:ERP-7231:WROY:22-Mar-2018:ED2K911556
* Begin of ADD:ERP-7231:WROY:22-Mar-2018:ED2K911556
IF veda-vbeln  EQ *veda-vbeln  AND                    "Sales Document
   veda-vposn  EQ *veda-vposn  AND                    "Sales Document Item
   veda-vlaufk NE *veda-vlaufk.                       "Validity period category of contract
* End   of ADD:ERP-7231:WROY:22-Mar-2018:ED2K911556
  new_pricing = lc_prc_type_c.                        "Pricing Type: C
ENDIF.
