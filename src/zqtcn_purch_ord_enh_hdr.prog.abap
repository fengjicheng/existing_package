*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_PURCH_ORD_ENH_HDR                        *
* PROGRAM DESCRIPTION : Purchase Order Header Enhancement              *
* In this include enhancing standard PO header's account assignment field,
* Our reference field, adding new line in PO for conference Purchase
* Requisition.
* DEVELOPER           : Writtick Roy(WROY)/Lucky Kodwani(LKODWANI)     *
* CREATION DATE       : 28/02/2017                                     *
* OBJECT ID           : E0143                                          *
* TRANSPORT NUMBER(S) : ED2K904444                                     *
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906319
* REFERENCE NO:  E143_CR509
* DEVELOPER: Lucky Kodwani
* DATE:  2017-05-25
* DESCRIPTION: Changes has done inside below tags
* Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
* End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908861
* REFERENCE NO:  E143_CR656/657/658
* DEVELOPER: Writtick Roy
* DATE:  2017-10-10
* DESCRIPTION: Collective Number for Distribution PO
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
*----------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PURCH_ORD_ENH_HDR
*&---------------------------------------------------------------------*

* Local Work Area Declaration
DATA:  lst_hdr_data      TYPE mepoheader,          "Purchase Order Item
       lst_item_data_2   TYPE purchase_order_item, " Purchase Order Item
       lst_constant      TYPE ty_constants,
       lst_conf_item     TYPE mepoitem,            " Purchase Order Item
       lst_item_data     TYPE mepoitem,            " Purchase Order Item
*      Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
       lst_mat_plnt      TYPE marc,                " Plant Data for Material
*      End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319

* Local Internal Table Declaration
       lr_con_item       TYPE REF TO if_purchase_order_item_mm,          " PO Item External View
       li_item_data      TYPE purchase_order_items,                      " PO Item External View
       li_item           TYPE STANDARD TABLE OF mepoitem INITIAL SIZE 0, " Purchase Order Item

* Local Variable Declaration
       lv_dropship       TYPE unsez,  " Our Reference
       lv_matnr_tmp      TYPE matnr,  " Material Number
       lv_reprint        TYPE unsez,  " Reprint of type CHAR30
       lv_first_print    TYPE unsez,  " First_print of type CHAR30
       lv_order_type_nb  TYPE bsart,  " Order Type (Purchasing)
       lv_order_type_zcf TYPE bsart,  " Order Type (Purchasing)
       lv_order_type_znb TYPE bsart,  " Order Type (Purchasing)
       lv_mat_type_zjip  TYPE mtart,  " Material Type
       lv_matnr          TYPE matnr,  " Material Number
       lv_third_prt      TYPE pstyp , " ABAP: Name of Variant Variable
       lv_aux_acct       TYPE knttp , " ABAP: Name of Variant Variable
       lv_menge_out      TYPE bstmg,  " Material Master View: Alternative Quantity of Material
       lv_knttp_p        TYPE knttp,  " Account Assignment Category
       lv_knttp_tmp      TYPE knttp,  " Account Assignment Category
       lv_knttp_x        TYPE knttp,  " Account Assignment Category
       lv_conference     TYPE bednr,  " Requirement Tracking Number
       lv_line           TYPE i.      " Line of type Integers

* Constant Declaration
CONSTANTS : lc_devid       TYPE zdevid      VALUE 'E143',        " Development ID
            lc_autet_1     TYPE autet       VALUE '1',           " Source List Usage in Materials Planning
            lc_acc_cat     TYPE rvari_vnam  VALUE 'ACCOUNT_CAT', " ABAP: Name of Variant Variable
            lc_distr_po    TYPE rvari_vnam  VALUE 'DISTR_PO',    " ABAP: Name of Variant Variable
            lc_print_po    TYPE rvari_vnam  VALUE 'PRINT_PO',    " ABAP: Name of Variant Variable
            lc_conf_pr     TYPE rvari_vnam  VALUE 'CONF_PR',     " ABAP: Name of Variant Variable
            lc_conf        TYPE rvari_vnam  VALUE 'CONF',        " ABAP: Name of Variant Variable
            lc_bednr       TYPE rvari_vnam  VALUE 'BEDNR',       " ABAP: Name of Variant Variable
            lc_first_print TYPE rvari_vnam  VALUE 'FIRST_PRINT', " ABAP: Name of Variant Variable
            lc_reprint     TYPE rvari_vnam  VALUE 'REPRINT',     " ABAP: Name of Variant Variable
            lc_mat_type    TYPE rvari_vnam   VALUE 'MAT_TYPE',   " ABAP: Name of Variant Variable
            lc_mtart       TYPE rvari_vnam   VALUE 'MTART',      " ABAP: Name of Variant Variable
            lc_item_cat    TYPE rvari_vnam  VALUE 'ITEM_CAT',    " ABAP: Name of Variant Variable
            lc_third_prt   TYPE rvari_vnam  VALUE 'THIRD_PRT',   " ABAP: Name of Variant Variable
            lc_aux_acct    TYPE rvari_vnam  VALUE 'AUX_ACCT',    " ABAP: Name of Variant Variable
            lc_project     TYPE rvari_vnam  VALUE 'PROJECT',     " ABAP: Name of Variant Variable
            lc_dropship    TYPE rvari_vnam  VALUE 'DROPSHIP',    " ABAP: Name of Variant Variable
            lc_conference  TYPE bednr       VALUE 'CONFERENCE',  " Requirement Tracking Number
            lc_order_type  TYPE rvari_vnam  VALUE 'ORDER_TYPE'.  " ABAP: Name of Variant Variable

* Get the constant values from ZCACONSTANT value.
SELECT devid                   "Development ID
       param1                  "ABAP: Name of Variant Variable
       param2                  "ABAP: Name of Variant Variable
       srno                    "Current selection number
       sign                    "ABAP: ID: I/E (include/exclude values)
       opti                    "ABAP: Selection option (EQ/BT/CP/...)
       low                     "Lower Value of Selection Condition
       high                    "Upper Value of Selection Condition
   FROM zcaconstant            "Wiley Application Constant Table
   INTO TABLE i_constants
   WHERE devid    = lc_devid
   AND   activate = abap_true. "Only active record
IF sy-subrc IS INITIAL.
  SORT i_constants BY param1 param2.
ENDIF. " IF sy-subrc IS INITIAL

* Get Header Data
CALL METHOD im_header->get_data
  RECEIVING
    re_data = lst_hdr_data. "Purchase Order Item

* Begin of CHANGE:CR#512:LKODWANI:19-MAY-2017:ED2K906023
IF lst_hdr_data-ebeln IS NOT INITIAL.
  SELECT ebeln,
         ebelp " Item Number of Purchasing Document
    FROM ekpo  " Purchasing Document Item
    INTO TABLE @DATA(li_change_po)
    WHERE ebeln = @lst_hdr_data-ebeln.
  IF sy-subrc EQ 0.
    SORT li_change_po BY ebelp.
  ENDIF. " IF sy-subrc EQ 0
ENDIF. " IF lst_hdr_data-ebeln IS NOT INITIAL
* End of CHANGE:CR#512:LKODWANI:19-MAY-2017:ED2K906023

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

IF li_item[] IS NOT INITIAL.

* Get order type NB
* Binary search is not required as table will have very few records.
  CLEAR lst_constant.
  READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_order_type
                                                    param2 = lc_print_po.
  IF sy-subrc EQ 0.
    lv_order_type_nb = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

* Get Account Assignment
* Binary search is not required as table will have very few records.
  CLEAR lst_constant.
  READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_acc_cat
                                                    param2 = lc_project.
  IF sy-subrc EQ 0.
    lv_knttp_p = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

* Binary search is not required as table will have very few records.
  CLEAR lst_constant.
  READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_acc_cat
                                                    param2 = lc_aux_acct.
  IF sy-subrc EQ 0.
    lv_knttp_x = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

* Get order type ZNB
* Binary search is not required as table will have very few records.
  CLEAR lst_constant.
  READ TABLE i_constants INTO lst_constant WITH KEY  param1 = lc_order_type
                                                     param2 = lc_distr_po.
  IF sy-subrc EQ 0.
    lv_order_type_znb = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

* Get Material Type from ZCA constant table.
* Binary search is not required as table will have very few records.
  CLEAR lst_constant.
  READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_mat_type
                                                    param2 = lc_mtart.
  IF sy-subrc EQ 0.
    lv_mat_type_zjip = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

* Get Material Type from ZCA constant table.
* Binary search is not required as table will have very few records.
  CLEAR lst_constant.
  READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_conf
                                                    param2 = lc_bednr.
  IF sy-subrc EQ 0.
    lv_conference = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

*   Get the material number from Item Table .
  CLEAR lst_item_data.
  READ TABLE li_item INTO lst_item_data INDEX 1.
  IF sy-subrc EQ 0.
    lv_matnr = lst_item_data-matnr.

    CALL FUNCTION 'MARA_SINGLE_READ'
      EXPORTING
        matnr             = lst_item_data-matnr "Material Number
      IMPORTING
        wmara             = st_mat_detl         "General Material Data
      EXCEPTIONS
        lock_on_material  = 1
        lock_system_error = 2
        wrong_call        = 3
        not_found         = 4
        OTHERS            = 5.
    IF sy-subrc NE 0.
      CLEAR: st_mat_detl.
    ENDIF. " IF sy-subrc NE 0

*   Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
    CALL FUNCTION 'MARC_SINGLE_READ'
      EXPORTING
        matnr             = lst_item_data-matnr "Material Number
        werks             = lst_item_data-werks "Plant
      IMPORTING
        wmarc             = lst_mat_plnt
      EXCEPTIONS
        lock_on_marc      = 1
        lock_system_error = 2
        wrong_call        = 3
        not_found         = 4
        OTHERS            = 5.
    IF sy-subrc NE 0.
      CLEAR: lst_mat_plnt.
    ENDIF.
*   End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
  ENDIF. " IF sy-subrc EQ 0

  CLEAR: v_itm_qty,
         v_conf_qunt.

  IF lst_hdr_data-ebeln IS INITIAL AND
     lst_hdr_data-bsart = lv_order_type_nb AND
     st_mat_detl-mtart  = lv_mat_type_zjip.
    DATA(lv_print_po) = abap_true.
  ENDIF. " IF lst_hdr_data-ebeln IS INITIAL AND

  LOOP AT li_item ASSIGNING FIELD-SYMBOL(<lst_item>) WHERE loekz IS INITIAL.
    v_itm_qty = v_itm_qty + <lst_item>-menge.

    IF lst_hdr_data-bsart = lv_order_type_nb AND
       st_mat_detl-mtart  = lv_mat_type_zjip.

*** Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
**      IF lv_knttp_tmp IS INITIAL.
**        lv_knttp_tmp = <lst_item>-knttp.
***      ELSEIF lv_knttp_tmp <> <lst_item>-knttp AND
***           ( <lst_item>-knttp = lv_knttp_p OR
***             lv_knttp_tmp     = lv_knttp_p ).
**      ELSE.
**        if <lst_item>-knttp is not INITIAL. " ELSE -> IF lv_knttp_tmp IS INITIAL
**        READ TABLE li_change_po TRANSPORTING NO FIELDS WITH KEY ebelp = <lst_item>-ebelp
**                                                            BINARY SEARCH.
**        IF sy-subrc EQ 0.
**          IF lv_knttp_tmp <> <lst_item>-knttp AND
**           ( <lst_item>-knttp = lv_knttp_p OR
**             lv_knttp_tmp     = lv_knttp_p ).
**            MESSAGE e175(zqtc_r2). " Only one type of Acc Assignment Category is allowed.
**            CALL METHOD im_header->invalidate( ).
**          ENDIF. " IF lv_knttp_tmp <> <lst_item>-knttp AND
**        ELSE. " ELSE -> IF sy-subrc EQ 0
**          <lst_item>-knttp = lv_knttp_tmp.
**        ENDIF. " IF sy-subrc EQ 0
**      ENDIF. " IF lv_knttp_tmp IS INITIAL
**    ENDIF. " IF lst_hdr_data-bsart = lv_order_type_nb AND

      IF lv_knttp_tmp IS INITIAL.
        lv_knttp_tmp = <lst_item>-knttp.
      ENDIF. " IF lv_knttp_tmp IS INITIAL
      READ TABLE li_change_po TRANSPORTING NO FIELDS WITH KEY ebelp = <lst_item>-ebelp
                                                          BINARY SEARCH.
      IF sy-subrc NE 0 AND <lst_item>-knttp IS INITIAL.
        <lst_item>-knttp = lv_knttp_tmp.
      ENDIF. " IF sy-subrc NE 0 AND <lst_item>-knttp IS INITIAL

      IF lv_knttp_tmp <> <lst_item>-knttp AND
           ( <lst_item>-knttp = lv_knttp_p OR
             lv_knttp_tmp     = lv_knttp_p ).
        MESSAGE e175(zqtc_r2). " Only one type of Acc Assignment Category is allowed.
        CALL METHOD im_header->invalidate( ).
      ENDIF. " IF lv_knttp_tmp <> <lst_item>-knttp AND

    ENDIF. " IF lst_hdr_data-bsart = lv_order_type_nb AND
*** End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319

    IF lst_hdr_data-bsart = lv_order_type_nb AND
       st_mat_detl-mtart  = lv_mat_type_zjip AND
       <lst_item>-knttp   = lv_knttp_p.
* Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
      lv_print_po = abap_true.
* End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
      IF lv_matnr_tmp IS INITIAL.
        lv_matnr_tmp = <lst_item>-matnr.
      ELSEIF lv_matnr_tmp <> <lst_item>-matnr.
        MESSAGE e168(zqtc_r2). " Only one type of material is allowed.
        CALL METHOD im_header->invalidate( ).
      ENDIF. " IF lv_matnr_tmp IS INITIAL
* Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
    ELSEIF <lst_item>-knttp IS NOT INITIAL.
      lv_print_po = abap_false.
* End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
    ENDIF. " IF lst_hdr_data-bsart = lv_order_type_nb AND
  ENDLOOP. " LOOP AT li_item ASSIGNING FIELD-SYMBOL(<lst_item>) WHERE loekz IS INITIAL

* If Document type is NB (Print Purchase Order )
  IF lv_print_po = abap_true.

* Get the our reference
* Binary search is not required as table will have very few records.
    CLEAR lst_constant.
    READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_first_print.

    IF sy-subrc EQ 0.
      lv_first_print = lst_constant-low.
    ENDIF. " IF sy-subrc EQ 0

* Get the our reference
* Binary search is not required as table will have very few records.
    CLEAR lst_constant.
    READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_reprint.

    IF sy-subrc EQ 0.
      lv_reprint = lst_constant-low.
    ENDIF. " IF sy-subrc EQ 0

    IF lst_hdr_data-unsez NE lv_reprint AND
       lst_hdr_data-unsez NE lv_first_print.
* Get the Purchase Requisition Document from EKPO table
      SELECT ebeln, " Purchasing Document Number
             ebelp, " Item Number of Purchasing Document
             loekz, " Deletion Indicator in Purchasing Document
             matnr, " Material Number
             werks, " Plant
* Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
             netpr " Net Price in Purchasing Document (in Document Currency)
* End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
        FROM ekpo " Purchasing Document Item
        INTO TABLE @DATA(li_ekpo)
        FOR ALL ENTRIES IN @li_item
        WHERE loekz = @space
          AND matnr = @li_item-matnr
          AND werks = @li_item-werks
* Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
          AND knttp = @lv_knttp_p.
* End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
      IF sy-subrc EQ 0.
        SELECT ebeln, " Purchasing Document Number
               bsart, " Purchasing Document Type
* Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
               unsez
* End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
          FROM ekko " Purchasing Document Header
        INTO TABLE @DATA(li_ekko)
        FOR ALL ENTRIES IN @li_ekpo
        WHERE ebeln = @li_ekpo-ebeln
        AND   bsart = @lv_order_type_nb.
        IF sy-subrc NE 0.
          CLEAR: li_ekko,
                 li_ekpo.
        ENDIF. " IF sy-subrc NE 0
      ENDIF. " IF sy-subrc EQ 0

*   Do not consider the current PO
      DELETE li_ekko WHERE ebeln EQ lst_hdr_data-ebeln.
      DELETE li_ekpo WHERE ebeln EQ lst_hdr_data-ebeln.

      IF li_ekko IS INITIAL.
        SELECT lifnr " Vendor Account Number
          FROM eord  " Purchasing Source List
        UP TO 1 ROWS
        INTO @DATA(lv_lifnr)
        FOR ALL ENTRIES IN @li_item
        WHERE matnr = @li_item-matnr
        AND  werks  = @li_item-werks
        AND vdatu LE @sy-datum
        AND bdatu GE @sy-datum
        AND notkz EQ @space
        AND autet EQ @lc_autet_1.
        ENDSELECT.
        IF sy-subrc EQ 0.
*         Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
*         If the Planned Arrival Date is already populated, then only "Reprint" purchase order
          IF lst_hdr_data-ebeln IS INITIAL AND
             lst_hdr_data-unsez IS INITIAL AND
*            Begin of CHANGE:ERP-2927:WROY:12-JUL-2017:ED2K907247
*            lst_mat_plnt-ismarrivaldatepl IS NOT INITIAL. " Planned Goods Arrival Date
           ( lst_mat_plnt-ismarrivaldatepl IS NOT INITIAL AND " Planned Goods Arrival Date
             lst_mat_plnt-ismarrivaldatepl NE space ).
*            End   of CHANGE:ERP-2927:WROY:12-JUL-2017:ED2K907247
*           Populate Our reference Field
            lst_hdr_data-unsez  = lv_reprint.
          ELSE.
*         End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
*           Populate Our reference Field
            lst_hdr_data-unsez  = lv_first_print.
            v_first_print = abap_true.
*         Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
          ENDIF.
*         End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
        ENDIF. " IF sy-subrc EQ 0
      ELSE. " ELSE -> IF li_ekko IS INITIAL
        SELECT lifnr " Vendor Account Number
        FROM eord    " Purchasing Source List
        UP TO 1 ROWS
        INTO @DATA(lv_lifnr2)
        FOR ALL ENTRIES IN @li_item
        WHERE matnr = @li_item-matnr
        AND  werks  = @li_item-werks
        AND vdatu LE @sy-datum
        AND bdatu GE @sy-datum
        AND notkz EQ @space
        AND autet EQ @lc_autet_1.
        ENDSELECT.
        IF sy-subrc EQ 0.
* Populate Our reference Field
          lst_hdr_data-unsez  = lv_reprint.

* Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
          SORT li_ekko BY unsez .
          READ TABLE li_ekko INTO DATA(lst_ekko) WITH KEY unsez = lv_first_print
                                                         BINARY SEARCH.
          IF sy-subrc EQ 0.
            SORT li_ekpo BY ebeln.
            READ TABLE li_ekpo INTO DATA(lst_ekpo) WITH KEY ebeln = lst_ekko-ebeln
                                                             BINARY SEARCH.
            IF sy-subrc EQ 0.
              v_netpr  = lst_ekpo-netpr.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF sy-subrc EQ 0
* End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF li_ekko IS INITIAL
    ELSE. " ELSE -> IF lst_hdr_data-unsez NE lv_reprint AND
      IF lst_hdr_data-unsez EQ lv_first_print.
        v_first_print = abap_true.
      ENDIF. " IF lst_hdr_data-unsez EQ lv_first_print
    ENDIF. " IF lst_hdr_data-unsez NE lv_reprint AND
*    ELSE. " ELSE -> IF sy-subrc EQ 0
*      SELECT lifnr " Vendor Account Number
*       FROM eord   " Purchasing Source List
*     UP TO 1 ROWS
*     INTO  @DATA(lv_lifnr_fp)
*     FOR ALL ENTRIES IN @li_item
*     WHERE matnr = @li_item-matnr
*     AND  werks  = @li_item-werks
*     AND vdatu LT @sy-datum
*     AND bdatu GT @sy-datum
*     AND notkz EQ @space
*     AND autet EQ @lc_autet_1.
*      ENDSELECT.
*      IF sy-subrc EQ 0.
** Populate Our reference Field
*        lst_hdr_data-unsez  = lv_first_print.
*        v_first_print = abap_true.
*      ENDIF. " IF sy-subrc EQ 0
*    ENDIF. " IF sy-subrc EQ 0

*     Only one material will be present in PO
    IF v_mat_old <> lv_matnr.
      CLEAR lst_constant.
      READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_order_type
                                                        param2 = lc_conf_pr.
      IF sy-subrc EQ 0.
        lv_order_type_zcf = lst_constant-low.
      ENDIF. " IF sy-subrc EQ 0

* Get all the Conference PR(Order type ZCF) from EBAN table
      SELECT banfn " Purchase Requisition Number
             bnfpo " Item Number of Purchase Requisition
             bsart " Purchase Requisition Document Type
             matnr " Material Number
             menge " Purchase Requisition Quantity
             meins " Purchase Requisition Unit of Measure
        FROM eban  " Purchase Requisition
        INTO TABLE i_eban
        FOR ALL ENTRIES IN li_item
        WHERE bsart = lv_order_type_zcf
        AND matnr = li_item-matnr
        AND loekz = space
        AND ebakz = space
        AND blckd = space.
      IF sy-subrc EQ 0.
        LOOP AT i_eban ASSIGNING FIELD-SYMBOL(<lst_eban>).
*         If Purchase Order is getting created with reference to ZCF
*         Documents (Purchase Requisitions), no need to consider that
*         ZCF document again
          READ TABLE li_item TRANSPORTING NO FIELDS
               WITH KEY banfn	= <lst_eban>-banfn
                        bnfpo	= <lst_eban>-bnfpo.
          IF sy-subrc EQ 0.
            IF i_eban_nb IS INITIAL.
*             Identify NB Documents
              SELECT banfn " Purchase Requisition Number
                     bnfpo " Item Number of Purchase Requisition
                     bsart " Purchase Requisition Document Type
                     matnr " Material Number
                     menge " Purchase Requisition Quantity
                     meins " Purchase Requisition Unit of Measure
                FROM eban  " Purchase Requisition
                INTO TABLE i_eban_nb
                FOR ALL ENTRIES IN li_item
                WHERE bsart = lv_order_type_nb
                AND matnr = li_item-matnr
                AND loekz = space
                AND ebakz = space
                AND blckd = space.
              IF sy-subrc EQ 0.
*               Nothing to do
              ENDIF. " IF sy-subrc EQ 0
            ENDIF. " IF i_eban_nb IS INITIAL
            IF i_eban_nb IS NOT INITIAL.
              MESSAGE e171(zqtc_r2). " ZCF PRs can not be converted individually when NB PRs exist.
              CALL METHOD im_header->invalidate( ).
            ENDIF. " IF i_eban_nb IS NOT INITIAL
            RETURN.
          ENDIF. " IF sy-subrc EQ 0

* Convert the UOM to BASE UOM
* Fetch General Material Data
          IF <lst_eban>-meins <> st_mat_detl-meins.
            CALL FUNCTION 'MATERIAL_UNIT_CONVERSION'
              EXPORTING
                input                = <lst_eban>-menge
                kzmeinh              = abap_true
                matnr                = <lst_eban>-matnr
                meinh                = <lst_eban>-meins
                meins                = st_mat_detl-meins
              IMPORTING
                output               = lv_menge_out
              EXCEPTIONS
                conversion_not_found = 1
                input_invalid        = 2
                material_not_found   = 3
                meinh_not_found      = 4
                meins_missing        = 5
                no_meinh             = 6
                output_invalid       = 7
                overflow             = 8
                OTHERS               = 9.
            IF sy-subrc EQ 0.
*          Suitable error handling will be taken care in later steps.
            ENDIF. " IF sy-subrc EQ 0
          ELSE. " ELSE -> IF <lst_eban>-meins <> st_mat_detl-meins
            lv_menge_out = <lst_eban>-menge.
          ENDIF. " IF <lst_eban>-meins <> st_mat_detl-meins

          v_conf_qunt = v_conf_qunt + lv_menge_out.
          CLEAR lv_menge_out.
        ENDLOOP. " LOOP AT i_eban ASSIGNING FIELD-SYMBOL(<lst_eban>)

        lv_line = lines( li_item ).
        READ TABLE li_item INTO lst_item_data INDEX lv_line.
        IF sy-subrc EQ 0.
* Populate new line item
          CLEAR: lst_conf_item.
          MOVE-CORRESPONDING lst_item_data TO lst_conf_item.
          lst_conf_item-ebelp = lst_item_data-ebelp + 10.
          lst_conf_item-menge = v_conf_qunt.
          lst_conf_item-bednr = lv_conference.

          CLEAR:  lst_conf_item-banfn,
                  lst_conf_item-bnfpo.

* Add new line in PO for Conference order
          CALL METHOD im_header->create_item
            RECEIVING
              re_item = lr_con_item.

          CALL METHOD lr_con_item->set_data
            EXPORTING
              im_data = lst_conf_item.
        ENDIF. " IF sy-subrc EQ 0

      ENDIF. " IF sy-subrc EQ 0
      v_mat_old =  lv_matnr.
    ENDIF. " IF v_mat_old <> lv_matnr

  ELSEIF lst_hdr_data-bsart =  lv_order_type_znb.

*   Begin of DEL:CR656/657/658:WROY:10-OCT-2017:ED2K908861
* Get the item details from EKPO
*    SELECT ebeln, " Purchasing Document Number
*           ebelp, " Item Number of Purchasing Document
*           loekz, " Deletion Indicator in Purchasing Document
*           matnr, " Material Number
*           werks  " Plant
*      FROM ekpo   " Purchasing Document Item
*      INTO TABLE @DATA(li_ekpo1)
*      FOR ALL ENTRIES IN @li_item
*      WHERE loekz = @space
*        AND matnr = @li_item-matnr
*        AND werks = @li_item-werks.
*    IF sy-subrc EQ 0.
*      SELECT ebeln " Purchasing Document Number
*       FROM ekko   " Purchasing Document Header
*       INTO @DATA(lv_ebeln)
*       UP TO 1 ROWS
*       FOR ALL ENTRIES IN @li_ekpo1
*       WHERE ebeln = @li_ekpo1-ebeln
*       AND   bsart = @lv_order_type_nb
*       AND   unsez = @lv_first_print.
*      ENDSELECT.
*      IF sy-subrc EQ 0.
*        lst_hdr_data-submi  = lv_ebeln.
*      ENDIF. " IF sy-subrc EQ 0
*    ENDIF. " IF sy-subrc EQ 0
*   End   of DEL:CR656/657/658:WROY:10-OCT-2017:ED2K908861
*   Begin of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
*   Get the item details from EKPO
    SELECT p~ebeln, " Purchasing Document Number
           p~ebelp, " Item Number of Purchasing Document
           p~matnr, " Material Number
           p~werks, " Plant
           p~elikz  " Delivery Completed" Indicator
      FROM ekpo AS p       " Purchasing Document Item
     INNER JOIN ekko AS k  " Purchasing Document Header
        ON k~ebeln EQ p~ebeln
      INTO TABLE @DATA(li_ekpo1)
       FOR ALL ENTRIES IN @li_item
     WHERE p~loekz = @space
       AND p~matnr = @li_item-matnr
       AND p~werks = @li_item-werks
       AND p~knttp = @lv_knttp_p
       AND k~bsart = @lv_order_type_nb.
    IF sy-subrc EQ 0.
      SORT li_ekpo1 BY matnr ASCENDING
                       werks ASCENDING
                       elikz ASCENDING
                       ebeln DESCENDING.
      READ TABLE li_ekpo1 INTO DATA(lst_ekpo1) INDEX 1.
      IF sy-subrc EQ 0.
        lst_hdr_data-submi  = lst_ekpo1-ebeln.
      ENDIF.
    ENDIF.
*   End   of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
* Binary search is not required as table will have very few records.
    CLEAR lst_constant.
    READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_acc_cat
                                                      param2 = lc_aux_acct.

    IF sy-subrc EQ 0.
      lv_aux_acct = lst_constant-low.
    ENDIF. " IF sy-subrc EQ 0


* Binary search is not required as table will have very few records.
    CLEAR lst_constant.
    READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_item_cat
                                                      param2 = lc_third_prt.

    IF sy-subrc EQ 0.
      lv_third_prt = lst_constant-low.
    ENDIF. " IF sy-subrc EQ 0

    SORT li_item BY pstyp knttp.
    READ TABLE li_item TRANSPORTING NO FIELDS WITH KEY pstyp = lv_third_prt
                                                       knttp = lv_aux_acct
                                                       BINARY SEARCH.
    IF sy-subrc EQ 0.
*     Binary search is not required as table will have very few records.
      CLEAR lst_constant.
      READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_dropship.

      IF sy-subrc EQ 0.
        v_dropship_fg = abap_true.
        lv_dropship = lst_constant-low.
      ENDIF. " IF sy-subrc EQ 0

      lst_hdr_data-unsez =  lv_dropship.
    ENDIF. " IF sy-subrc EQ 0

  ENDIF. " IF lv_print_po = abap_true
ENDIF. " IF li_item[] IS NOT INITIAL

*  Set Header Data
CALL METHOD im_header->set_data
  EXPORTING
    im_data = lst_hdr_data.

IF lst_hdr_data-ebeln IS NOT INITIAL AND
   lv_print_po        EQ abap_true.
* Get Item Data
  CALL METHOD im_header->get_items
    RECEIVING
      re_items = li_item_data. "Purchase Order Item

* Get the Item Data
  LOOP AT li_item_data INTO lst_item_data_2.

    CLEAR lst_item_data.
    CALL METHOD lst_item_data_2-item->get_data
      RECEIVING
        re_data = lst_item_data.

    IF lst_item_data-knttp EQ lv_knttp_p.
      CALL METHOD me->if_ex_me_process_po_cust~process_item
        EXPORTING
          im_item = lst_item_data_2-item.
    ENDIF. " IF lst_item_data-knttp EQ lv_knttp_p
  ENDLOOP. " LOOP AT li_item_data INTO lst_item_data_2

ENDIF. " IF lst_hdr_data-ebeln IS NOT INITIAL AND

CLEAR : lst_conf_item,
        lv_matnr,
        lst_hdr_data,
        li_item_data[].
