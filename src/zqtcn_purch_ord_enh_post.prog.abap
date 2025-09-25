*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_PURCH_ORD_ENH_HDR                        *
* PROGRAM DESCRIPTION : Enhance Purchase Order                         *
* Inside this include updating Close indicator in all Conference
* Purchase Requisition for printer PO and Updating Item category group
* and General Item category in material master for distributor PO.
* DEVELOPER           : Writtick Roy(WROY)/Lucky Kodwani(LKODWANI)     *
* CREATION DATE       : 22/03/2017                                     *
* OBJECT ID           : E0143                                          *
* TRANSPORT NUMBER(S) : ED2K904444                                     *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908861
* REFERENCE NO:  E143_CR656/657/658
* DEVELOPER: Writtick Roy
* DATE:  2017-10-10
* DESCRIPTION: Delete Planned Independent Requirement
* Changes has done inside below tags
* Begin of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
* End   of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PURCH_ORD_ENH_POST
*&---------------------------------------------------------------------*

* Local Variable Declaration
DATA : lv_matnr          TYPE matnr ,              " Material Number
*      Begin of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
       lv_werks          TYPE werks_d,             " Plant
*      End   of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
       lv_itm_cat_gr     TYPE mtpos,               " Item category group from material master
       lst_item_data_2   TYPE purchase_order_item, " Purchase Order Item
       lst_item_data     TYPE mepoitem,            " Purchase Order Item
*      Begin of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
       lst_hdr_data      TYPE mepoheader,          " Purchase Order Header
*      End   of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
       lv_gen_itm_cat_gr TYPE mtpos_mara.          " General item category group

* Local Internal Table Declaration
DATA:  li_item_data TYPE purchase_order_items,                      " PO Item External View
*      Begin of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
       lir_po_typ_p TYPE rjksd_bsart_range_tab,                     " Range Table for Purchase Order Types
       li_bapi_ret  TYPE bapireturn1_tabtype,                       " Return Parameter
*      End   of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
       li_item      TYPE STANDARD TABLE OF mepoitem INITIAL SIZE 0. " Purchase Order Item

* Local Variable Declaration
DATA :  lst_constant TYPE ty_constants.

CONSTANTS : lc_item_cat_gr  TYPE rvari_vnam  VALUE 'ITEM_CAT_GRP',     " ABAP: Name of Variant Variable
*           Begin of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
            lc_order_type   TYPE rvari_vnam  VALUE 'ORDER_TYPE',       " ABAP: Name of Variant Variable
            lc_print_po     TYPE rvari_vnam  VALUE 'PRINT_PO',         " ABAP: Name of Variant Variable
*           End   of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
            lc_gen_item_cat TYPE rvari_vnam  VALUE 'GEN_ITEM_CAT_GRP'. " ABAP: Name of Variant Variable

IF im_ebeln IS NOT INITIAL.
  IF i_eban IS NOT INITIAL.
* Updating Close indicator in all Conference Purchase Requisition
    SET UPDATE TASK LOCAL.
    CALL FUNCTION 'ZQTC_UPDATE_PR' IN UPDATE TASK
      EXPORTING
        im_eban = i_eban.
  ENDIF. " IF i_eban IS NOT INITIAL

  IF v_dropship_fg = abap_true.

* Get Item Data
    CALL METHOD im_header->get_items
      RECEIVING
        re_items = li_item_data. "Purchase Order Item

* Get the Item Data
    LOOP AT li_item_data INTO lst_item_data_2.
      CALL METHOD lst_item_data_2-item->get_data
        RECEIVING
          re_data = lst_item_data.
      APPEND lst_item_data TO li_item.
      CLEAR lst_item_data.
    ENDLOOP. " LOOP AT li_item_data INTO lst_item_data_2

* PO will have only one material number
    READ TABLE li_item ASSIGNING FIELD-SYMBOL(<lst_item>) INDEX 1.
    IF sy-subrc EQ 0.
      lv_matnr = <lst_item>-matnr.
    ENDIF. " IF sy-subrc EQ 0

* Item Category
* Binary search is not required as table will have very few records.
    CLEAR lst_constant.
    READ TABLE i_constants INTO lst_constant WITH KEY param1 =  lc_item_cat_gr.
    IF sy-subrc EQ 0.
      lv_itm_cat_gr = lst_constant-low.
    ENDIF. " IF sy-subrc EQ 0

* General Item Category
* Binary search is not required as table will have very few records.
    CLEAR lst_constant.
    READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_gen_item_cat.

    IF sy-subrc EQ 0.
      lv_gen_itm_cat_gr = lst_constant-low.
    ENDIF. " IF sy-subrc EQ 0

    IF lv_itm_cat_gr IS NOT INITIAL
      OR lv_gen_itm_cat_gr IS NOT INITIAL.
* Updating Item category group and General Item category in
* material master .
      SET UPDATE TASK LOCAL.
      CALL FUNCTION 'ZQTC_UPDATE_MAT_MASTER' IN UPDATE TASK
        EXPORTING
          im_matnr           = lv_matnr
          im_itm_cat_grp     = lv_itm_cat_gr
          im_gen_itm_cat_grp = lv_gen_itm_cat_gr.

    ENDIF. " IF lv_itm_cat_gr IS NOT INITIAL
  ENDIF. " IF v_dropship_fg = abap_true

* Begin of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
  LOOP AT i_constants INTO lst_constant.
    CASE lst_constant-param1.
      WHEN lc_order_type.
        CASE lst_constant-param2.
          WHEN lc_print_po.
*           Purchase Order Types for Print PO
            APPEND INITIAL LINE TO lir_po_typ_p ASSIGNING FIELD-SYMBOL(<lst_po_type>).
            <lst_po_type>-sign   = lst_constant-sign.
            <lst_po_type>-option = lst_constant-opti.
            <lst_po_type>-low    = lst_constant-low.
            <lst_po_type>-high   = lst_constant-high.
          WHEN OTHERS.
*           Nothing to Do
        ENDCASE.
      WHEN OTHERS.
*       Nothing to Do
    ENDCASE.
  ENDLOOP.

  CLEAR: lv_matnr,
         lv_werks.
* Get Header data
  CALL METHOD im_header->get_data
    RECEIVING
      re_data = lst_hdr_data.
  IF lst_hdr_data-bsart IN lir_po_typ_p.                " Print PO
*   Get Item Data
    CALL METHOD im_header->get_items
      RECEIVING
        re_items = li_item_data. "Purchase Order Item
*   Get the Item Data
    LOOP AT li_item_data INTO lst_item_data_2.
      CALL METHOD lst_item_data_2-item->get_data
        RECEIVING
          re_data = lst_item_data.
      IF lst_item_data-banfn IS NOT INITIAL AND        " With Ref To Purchase Req
         lst_item_data-bnfpo IS NOT INITIAL.
        lv_matnr = lst_item_data-matnr.                " Material
        lv_werks = lst_item_data-werks.                " Plant
        EXIT.
      ENDIF.
    ENDLOOP. " LOOP AT li_item_data INTO lst_item_data_2
  ENDIF.

  IF lv_matnr IS NOT INITIAL AND
     lv_werks IS NOT INITIAL.
*   Fetch Independent Requirements for Material
    SELECT matnr,	"Material Number
           werks,	"Plant
           bedae,	"Requirements type
           versb,	"Version number for independent requirements
           pbdnr  "Requirements Plan Number
      FROM pbim
      INTO @DATA(lst_ind_req_det)
     UP TO 1 ROWS
     WHERE matnr EQ @lv_matnr                      " Material
       AND werks EQ @lv_werks.                     " Plant
    ENDSELECT.
    IF sy-subrc EQ 0.
*     Change / Delete Planned Independent Reqmt
      CALL FUNCTION 'BAPI_REQUIREMENTS_CHANGE'
        EXPORTING
          material         = lst_ind_req_det-matnr " Material
          plant            = lst_ind_req_det-werks " Plant
          requirementstype = lst_ind_req_det-bedae " Requirements Type
          version          = lst_ind_req_det-versb " Version
          reqmtsplannumber = lst_ind_req_det-pbdnr " Requirements Plan Number
          vers_activ       = abap_false            " Version active
          do_commit        = abap_false            " Indicator: COMMIT WORK Executed
          update_mode      = abap_true             " Indicator: Changes Posted
          delete_old       = abap_true             " Deletion indicator
        TABLES
          return           = li_bapi_ret.          " Return Parameter
    ENDIF.
  ENDIF.
* End   of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
ENDIF. " IF im_ebeln IS NOT INITIAL
