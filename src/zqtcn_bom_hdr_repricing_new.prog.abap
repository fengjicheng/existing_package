*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BOM_HDR_REPRICING_NEW (Include)
* PROGRAM DESCRIPTION: Re-trigger Pricing
* DEVELOPER: Nikhilesh Palla (NPALLA)
* CREATION DATE:   21-Dec-2019 / 28-Sep-2020 / 21-Jan-2021
* OBJECT ID: E075/INC0270978
* TRANSPORT NUMBER(S): ED1K911417 / ED1K912203 / ED2K921414
* DESCRIPTION:  To Improve the performance of Batch Job (Entries > 25 lines).
*               Create (in Batch Mode)
*               - trigger the standard Subroutine for Repricing at the Header
*                level of the last BOM Header (i.e., which is Not a BOM Item).
*               Create (in Online Mode) or Change (in Both Online & Batch Mode)
*               - Use the Existing Logic (in zqtcn_bom_hdr_repricing)
*----------------------------------------------------------------------*
CONSTANTS: lc_last_bom_hdr_create TYPE char40  VALUE '(SAPLVBAK)EX_VBAPKOM[]',
           lc_prc_type_c1         TYPE knprs   VALUE 'C'.                 "Pricing Type: C
DATA:      li_vbapkom             TYPE STANDARD TABLE OF vbapkom.
DATA:      li_zcaconstant         TYPE STANDARD TABLE OF zcaconstant.
STATICS:   lv_last_bom_hdr_posnr  TYPE posnr_va.
STATICS:   lr_vbtyp               TYPE RANGE OF vbtyp.   "SD document category
STATICS:   lr_auart               TYPE RANGE OF auart.   "Sales Document Type

*To Improve the performance of Batch Job
* Get Sales Document Type(s) from ZCACONSTANT
IF lr_auart IS INITIAL.
    SELECT *
      FROM zcaconstant
      INTO TABLE li_zcaconstant
      WHERE devid  = lc_wricef_id_e075 "'E075'
        AND param1 = lc_ser_num_9_e075 "'009'
        AND activate = abap_true.
  IF sy-subrc = 0.
    LOOP AT li_zcaconstant ASSIGNING FIELD-SYMBOL(<lst_zcaconstant>).
      CASE <lst_zcaconstant>-param2.
        WHEN 'VBTYP'.
          APPEND INITIAL LINE TO lr_vbtyp ASSIGNING FIELD-SYMBOL(<lst_vbtyp>).
          <lst_vbtyp>-sign   = <lst_zcaconstant>-sign.
          <lst_vbtyp>-option = <lst_zcaconstant>-opti.
          <lst_vbtyp>-low    = <lst_zcaconstant>-low.
          <lst_vbtyp>-high   = <lst_zcaconstant>-high.
        WHEN 'AUART'.
          APPEND INITIAL LINE TO lr_auart ASSIGNING FIELD-SYMBOL(<lst_auart>).
          <lst_auart>-sign   = <lst_zcaconstant>-sign.
          <lst_auart>-option = <lst_zcaconstant>-opti.
          <lst_auart>-low    = <lst_zcaconstant>-low.
          <lst_auart>-high   = <lst_zcaconstant>-high.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDIF.
ENDIF.

* Create Document in Batch Mode for Doc Type in ZCACONSTANT.
IF sy-batch = abap_true  AND
   vbak-vbeln IS INITIAL AND "Create Mode
   vbak-vbtyp IN lr_vbtyp AND "SD document category
   vbak-auart IN lr_auart.   "Document Type in ZCACONSTANT.
* Determine Last BOM Header
  IF lv_last_bom_hdr_posnr IS INITIAL.
*   Sales Document: BOM Header Data - CREATE Contract
    ASSIGN (lc_last_bom_hdr_create) TO FIELD-SYMBOL(<li_vbapkom>).
    IF sy-subrc EQ 0.
      li_vbapkom = <li_vbapkom>.
      DESCRIBE TABLE li_vbapkom[] LINES DATA(lv_tabix_kom).
      READ TABLE li_vbapkom ASSIGNING FIELD-SYMBOL(<lst_vbapkom>) INDEX lv_tabix_kom.
      IF sy-subrc = 0.
        lv_last_bom_hdr_posnr = <lst_vbapkom>-posnr.
      ENDIF.
    ENDIF.
  ENDIF.

* Perfrom RePricing For All Items when the current Item is the Last BOM Header Item
  IF vbap-posnr = lv_last_bom_hdr_posnr.
*   Call the standard Subroutine for Repricing at the Header level
    PERFORM preisfindung_gesamt IN PROGRAM sapmv45a IF FOUND
      USING lc_prc_type_c1.                              "Pricing Type: C
*   Clear for the Subsequent Contract.
    CLEAR: lv_last_bom_hdr_posnr.
  ENDIF. "IF lv_last_bom_hdr_posnr = vbap-posnr.
ELSE.  "IF sy-batch = abap_true.
* Create in Online Mode and Change in Both Online and Batch Mode - Use existing Logic.
* Header Level Pricing
  IF vbkd-posnr IS NOT INITIAL AND
     vbap-posnr IS NOT INITIAL.
*   BOM Header
    IF vbap-uepos IS INITIAL AND
       vbap-stlnr IS NOT INITIAL.
*     Change in Amount / Quantity
      IF vbap-kzwi3  NE *vbap-kzwi3 OR
         vbap-kwmeng NE *vbap-kwmeng.
*       Call the standard Subroutine for Repricing at the Header level
        PERFORM preisfindung_gesamt IN PROGRAM sapmv45a IF FOUND
          USING lc_prc_type_c1.                             "Pricing Type: C
      ENDIF.
    ENDIF.
  ENDIF.

ENDIF. "IF sy-batch = abap_true.
