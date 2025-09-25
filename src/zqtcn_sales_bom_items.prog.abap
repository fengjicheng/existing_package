*-------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SALES_BOM_ITEMS
* PROGRAM DESCRIPTION: Plant override for BOM sub items in Sales Order
* DEVELOPER: Shivani Upadhyaya
* CREATION DATE: 2016-09-22
* OBJECT ID: E134
* TRANSPORT NUMBER(S): ED2K902977
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*-------------------------------------------------------------------*
*&------------------------------------------------------------------*
*&  Include           ZQTCN_SALES_BOM_ITEMS
*&------------------------------------------------------------------*

* Data Declaration
TYPES:
  BEGIN OF lty_delv_plant,
    matnr TYPE matnr,                                           " Material Number
    vkorg TYPE vkorg,                                           " Sales Organization
    vtweg TYPE vtweg,                                           " Distribution Channel
    dwerk TYPE dwerk_ext,                                       " Delivering Plant (Own or External)
  END OF lty_delv_plant,

  ltt_delv_plant TYPE STANDARD TABLE OF lty_delv_plant INITIAL SIZE 0,
  ltt_bom_items  TYPE STANDARD TABLE OF sdstpox        INITIAL SIZE 0.

STATICS:
  li_delv_plant  TYPE ltt_delv_plant.                           " Delivering Plant

DATA:
  lv_bom_items   TYPE char30 VALUE '(SAPFV45S)XSTB[]'.          " BOM Items / Components

FIELD-SYMBOLS:
  <li_bom_itms>  TYPE ltt_bom_items.                            " BOM Items / Components

IF vbap-uepos IS NOT INITIAL.
* Determine Delivering Plant
  READ TABLE li_delv_plant ASSIGNING FIELD-SYMBOL(<lst_delv_plant>)
       WITH KEY matnr = vbap-matnr                              " Current Item Material Number
                vkorg = vbak-vkorg                              " Sales Org from header
                vtweg = vbak-vtweg                              " Distribution Channel from header
       BINARY SEARCH.
  IF sy-subrc EQ 0.
    MOVE <lst_delv_plant>-dwerk TO vbap-werks.                  " Plant
  ELSE.
    ASSIGN (lv_bom_items) TO <li_bom_itms>.
    IF sy-subrc EQ 0.
*     Fetch Sales Data for Material
      SELECT matnr                                              " Material Number
             vkorg                                              " Sales Organization
             vtweg                                              " Distribution Channel
             dwerk                                              " Delivering Plant (Own or External)
        FROM mvke
        INTO TABLE li_delv_plant
         FOR ALL ENTRIES IN <li_bom_itms>
       WHERE matnr EQ <li_bom_itms>-idnrk                       " Material Number
         AND vkorg EQ vbak-vkorg                                " Sales Org from header
         AND vtweg EQ vbak-vtweg.                               " Distribution Channel from header
      IF sy-subrc EQ 0.
        SORT li_delv_plant BY matnr vkorg vtweg.
      ENDIF.
    ENDIF.
*   Determine Delivering Plant
    READ TABLE li_delv_plant ASSIGNING <lst_delv_plant>
         WITH KEY matnr = vbap-matnr                            " Current Item Material Number
                  vkorg = vbak-vkorg                            " Sales Org from header
                  vtweg = vbak-vtweg                            " Distribution Channel from header
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      MOVE <lst_delv_plant>-dwerk TO vbap-werks.                " Plant
    ENDIF.
  ENDIF.
ENDIF.

*DATA: lv_dwerk TYPE dwerk_ext. " Delivering Plant (Own or External)
*
*IF vbap-uepos IS NOT INITIAL.
**Selecting elivering plant from Sales Data for Material.
*  SELECT SINGLE dwerk " Delivering Plant (Own or External)
*            FROM mvke " Sales Data for Material
*            INTO lv_dwerk
*            WHERE matnr = vbap-matnr   " Current Item Material Number
*              AND vkorg = vbak-vkorg   " Sales Org from header
*              AND vtweg = vbak-vtweg.  " Distribution Channel from header
*  IF sy-subrc EQ 0.
*    MOVE lv_dwerk TO vbap-werks.
*  ENDIF. " IF sy-subrc EQ 0
*ENDIF. " IF vbap-uepos IS NOT INITIAL
