*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_RESTRICT_QUOTATIONS(Include Program)
* PROGRAM DESCRIPTION: Restrict creation of multiple Quotations
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 10/03/2017
* OBJECT ID: E070
* TRANSPORT NUMBER(S): ED2K908787
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO : ED2K923770
* REFERENCE NO : OTCM-43783
* DEVELOPER : Thilina Dimantha (TDIMANTHA)
* DATE : 14-June-2021
* DESCRIPTION : Rejected lines getting copied to subsequent document
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_RESTRICT_QUOTATIONS
*&---------------------------------------------------------------------*
CONSTANTS:
  lc_dev_e070 TYPE zdevid     VALUE 'E070',    "Development ID OTCM-43783 ED2K923770 TDIMANTHA 14-June-2021
  lc_p_auarn  TYPE rvari_vnam VALUE 'AUARN'.   "Parameter: Target Doc Type. OTCM-43783 ED2K923770 TDIMANTHA 14-June-2021

DATA:
  lv_ref_item   TYPE char30 VALUE '(SAPFV45C)CVBAP'.       "Item of the Reference

DATA:
  lst_sdoc_type TYPE tvak,                                 "Sales Document Types
  li_constant   TYPE zcat_constants.                       "Constant table

STATICS:
  li_doc_flows TYPE shp_vl10_vbfa_key_t,                  "Key for SD Document Flow
  lr_auarn_i   TYPE RANGE OF auart_nach.                  "Target Sales Document Type ED2K923770

FIELD-SYMBOLS:
  <lst_ref_itm> TYPE vbapvb.                               "Item Data of the Reference

bp_subrc = 0.
*BOI OTCM-43783 ED2K923770 TDIMANTHA 14-June-2021
IF lr_auarn_i IS INITIAL.
  " Get the Country keys, Delivery plants and Sales Orgs from zcaconstant Table
  SELECT devid       "Development ID
         param1	     "ABAP: Name of Variant Variable
         param2	     "ABAP: Name of Variant Variable
         srno	       "ABAP: Current selection number
         sign	       "ABAP: ID: I/E (include/exclude values)
         opti	       "ABAP: Selection option (EQ/BT/CP/...)
         low         "Lower Value of Selection Condition
         high	       "Upper Value of Selection Condition
    FROM zcaconstant "Wiley Application Constant Table
    INTO TABLE li_constant
   WHERE devid  = lc_dev_e070
     AND activate = abap_true.
  IF sy-subrc NE 0.
    "Do Nothing
  ENDIF.
  LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lst_constants>).
    CASE <lst_constants>-param1.
      WHEN lc_p_auarn.
        APPEND INITIAL LINE TO lr_auarn_i ASSIGNING FIELD-SYMBOL(<lst_auarn_i>).
        <lst_auarn_i>-sign   = <lst_constants>-sign.
        <lst_auarn_i>-option = <lst_constants>-opti.
        <lst_auarn_i>-low    = <lst_constants>-low.
        <lst_auarn_i>-high   = <lst_constants>-high.
      WHEN OTHERS.
*       Do nothing.
    ENDCASE.
  ENDLOOP. " LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constants>)
ENDIF.
IF fvcpa-auarn IN lr_auarn_i. "Below logic should trigger only if target document type is ZSQT
*EOI OTCM-43783 ED2K923770 TDIMANTHA 14-June-2021
* Get Item of the Reference
  ASSIGN (lv_ref_item) TO <lst_ref_itm>.
  IF sy-subrc EQ 0.
* Fetch details of Sales Document Type
    CALL FUNCTION 'ISM_SELECT_SINGLE_TVAK'
      EXPORTING
        auart     = fvcpa-auarn                              "Target sales document type
      IMPORTING
        tvak_i    = lst_sdoc_type                            "Sales Document Types
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
    IF sy-subrc EQ 0.
*   Buffering Concept: Check Sales Document Flow
      READ TABLE li_doc_flows TRANSPORTING NO FIELDS
           WITH KEY vbelv = <lst_ref_itm>-vbeln              "Preceding sales and distribution document
           BINARY SEARCH.
      IF sy-subrc NE 0.
*     Check Sales Document Flow
        SELECT vbelv                                         "Preceding sales and distribution document
               posnv 	                                       "Preceding item of an SD document
               vbeln 	                                       "Subsequent sales and distribution document
               posnn 	                                       "Subsequent item of an SD document
               vbtyp_n                                       "Document category of subsequent document
          FROM vbfa
          INTO TABLE li_doc_flows
         WHERE vbelv   EQ <lst_ref_itm>-vbeln                "Preceding sales and distribution document
           AND vbtyp_n EQ lst_sdoc_type-vbtyp.               "Document category of subsequent document
        IF sy-subrc EQ 0.
          SORT li_doc_flows BY vbelv posnv vbtyp_n.
        ELSE.
          CLEAR: li_doc_flows.
          APPEND INITIAL LINE TO li_doc_flows ASSIGNING FIELD-SYMBOL(<lst_doc_flow>).
          <lst_doc_flow>-vbelv = <lst_ref_itm>-vbeln.        "Preceding sales and distribution document
        ENDIF.
      ENDIF.

      READ TABLE li_doc_flows TRANSPORTING NO FIELDS
           WITH KEY vbelv   = <lst_ref_itm>-vbeln            "Preceding sales and distribution document
                    posnv   = <lst_ref_itm>-posnr            "Preceding item of an SD document
                    vbtyp_n = lst_sdoc_type-vbtyp            "Document category of subsequent document
           BINARY SEARCH.
      IF sy-subrc NE 0.
*     Line can be copied
        bp_subrc = 0.
      ELSE.
*     Do not copy the line, if already referenced
        bp_subrc = 1.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF. "IF fvcpa-auarn IN lr_auarn_i OTCM-43783 ED2K923770 TDIMANTHA 14-June-2021
