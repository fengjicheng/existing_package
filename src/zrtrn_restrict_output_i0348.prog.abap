*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVEDU03 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for segment population Outbound IDOC
* DEVELOPER: Writtick Roy ( Flower Box added by SAYANDAS)
* CREATION DATE:   24/04/2017
* OBJECT ID: I0348
* TRANSPORT NUMBER(S):  ED2K902781, ED2K902778(Dependent), ED2K905259
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908525, ED2K908527
* REFERENCE NO: CR#679/ERP-4293
* DEVELOPER: Writtick Roy
* DATE: 09/13/2017
* DESCRIPTION: Check for specific Publication Types
*----------------------------------------------------------------------*
DATA:
  lv_fname_vbak  TYPE char40 VALUE '(SAPMV45A)VBAK',         "Sales Document: Header Data
* Begin of ADD:CR#679/ERP-4293:WROY:13-SEP-2017:ED2K908525
  lv_fname_xvbap TYPE char40 VALUE '(SAPMV45A)XVBAP[]'.      "Sales Document: Item Data

DATA:
  li_constants   TYPE zcat_constants,                        "Constant Values
  lir_pub_types  TYPE rjksd_publtype_range_tab,              "Range: Publiocation Type
  li_order_items TYPE va_vbapvb_t.                           "Sales Document: Item Data
* End   of ADD:CR#679/ERP-4293:WROY:13-SEP-2017:ED2K908525

FIELD-SYMBOLS:
  <lst_ordr_hdr> TYPE vbak,                                  "Sales Document: Header Data
* Begin of ADD:CR#679/ERP-4293:WROY:13-SEP-2017:ED2K908525
  <li_ordr_itms> TYPE va_vbapvb_t.                           "Sales Document: Item Data

CONSTANTS:
  lc_devid_i0348 TYPE zdevid      VALUE 'I0348',             "Development ID (I0348)
  lc_prm_pub_typ TYPE rvari_vnam  VALUE 'PUBLICATION_TYPE'.  "Publication Type

* Get Constant Values
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_i0348                            "Developemnt ID (I0348)
  IMPORTING
    ex_constants = li_constants.                             "Constant Values
LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>).
  CASE <lst_constant>-param1.
    WHEN lc_prm_pub_typ.
*     Range: Paublication Type
      APPEND INITIAL LINE TO lir_pub_types ASSIGNING FIELD-SYMBOL(<lst_pub_type>).
      <lst_pub_type>-sign   = <lst_constant>-sign.           "ABAP: ID: I/E (include/exclude values)
      <lst_pub_type>-option = <lst_constant>-opti.           "ABAP: Selection option (EQ/BT/CP/...)
      <lst_pub_type>-low    = <lst_constant>-low.            "Publication Type (low)
      <lst_pub_type>-high   = <lst_constant>-high.           "Publication Type (high)
    WHEN OTHERS.
*     Nothing to do
  ENDCASE.
ENDLOOP.
* End   of ADD:CR#679/ERP-4293:WROY:13-SEP-2017:ED2K908525

* Retrieve Sales Document: Header Data
ASSIGN (lv_fname_vbak) TO <lst_ordr_hdr>.
IF sy-subrc EQ 0 AND
   <lst_ordr_hdr>-zzlicgrp IS NOT INITIAL.
  sy-subrc = 0.                                              "Assign the Output
ELSE.
  sy-subrc = 4.                                              "Do no assign Output
ENDIF.

* Begin of ADD:CR#679/ERP-4293:WROY:13-SEP-2017:ED2K908525
IF sy-subrc EQ 0.
* Retrieve Sales Document: Header Data
  ASSIGN (lv_fname_xvbap) TO <li_ordr_itms>.
  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING <li_ordr_itms> TO li_order_items.     "Sales Document: Item Data
    IF li_order_items IS NOT INITIAL.
      SORT li_order_items BY matnr.
      DELETE ADJACENT DUPLICATES FROM li_order_items
                   COMPARING matnr.
*     Fetch General Material Data
      SELECT matnr,                                          "Material Number
             ismpubltype                                     "Publication Type
        FROM mara
        INTO TABLE @DATA(li_mat_detls)
         FOR ALL ENTRIES IN @li_order_items
       WHERE matnr       EQ @li_order_items-matnr            "Materials from Sales Document: Item Data
         AND ismpubltype IN @lir_pub_types.                  "Range: Publication Type
      IF sy-subrc NE 0.
        CLEAR: li_mat_detls.
      ENDIF.
    ENDIF.
  ENDIF.
  IF li_mat_detls IS NOT INITIAL.
    sy-subrc = 0.                                            "Assign the Output
  ELSE.
    sy-subrc = 4.                                            "Do no assign Output
  ENDIF.
ENDIF.
* End   of ADD:CR#679/ERP-4293:WROY:13-SEP-2017:ED2K908525
