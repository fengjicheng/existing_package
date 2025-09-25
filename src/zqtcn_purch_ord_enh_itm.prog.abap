*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_PURCH_ORD_ENH_ITM                        *
* PROGRAM DESCRIPTION : Purchase Order Item Enhancement                *
* In this include enhancing standard PO Item's free of cost indicator,
* account assignment, PO price calculation,updating distributer 's name,
* Conditions value for condition type PB00.
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
* DESCRIPTION: Account Assignment for Reprint POs
* Changes has done inside below tags
* Begin of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
* End   of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
*----------------------------------------------------------------------*
* REVISION NO:  ED2K910358
* REFERENCE NO:  ERP-6013
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2018-01-18
* DESCRIPTION: Message e163(zqtc_r2) has been changed.
*----------------------------------------------------------------------*
* REVISION NO:  ED2K912490
* REFERENCE NO:  ERP-6152
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-07-02
* DESCRIPTION: Price should be calculated during Creation only; it
*              should not be recalculated while changing the PO
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PURCH_ORD_ENH_ITM
*&---------------------------------------------------------------------*

* TYPE DECLARATION
TYPES : ltt_cost_elem TYPE RANGE OF kstar. " Cost Element

* Local Work Area Declaration
DATA: lst_itm_data      TYPE mepoitem,       "Purchase Order Item
      lst_acc_data      TYPE mepoaccounting, "Account Assignment Fields for Purchase Order
      lst_constant      TYPE ty_constants,
      lst_cost_elem     TYPE LINE OF ltt_cost_elem,
      lst_po_header     TYPE mepoheader,     "Purchase Order Header Data

* Local Internal Table Declaration
      li_constant_tmp   TYPE STANDARD TABLE OF ty_constants INITIAL SIZE 0, " Constant table
      li_accountings    TYPE purchase_order_accountings,                    "Table with PO Account Assignments
      lir_cost_elem     TYPE ltt_cost_elem,

* Local Variable Declaration
      lv_objnr          TYPE j_objnr, " Object number
      lv_jour_price     TYPE wogxxx,  " Total Value in Object Currency
      lv_final_price    TYPE wogxxx,  " Total Value in Object Currency
      lv_pur_price      TYPE kbetr,   " Total Value in Object Currency
      lv_wrttp_10       TYPE wrttp,   " Value
      lv_order_type_znb TYPE bsart,   " Order Type (Purchasing)
      lv_order_type_nb  TYPE bsart,   " Order Type (Purchasing)
      lv_menge_out      TYPE bstmg,   " Material Master View: Alternative Quantity of Material
      lv_total_qtn      TYPE bstmg,   " Material Master View: Alternative Quantity of Material
      lv_mat_type_zjip  TYPE mtart,   " Material Type
*     Begin of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
      lv_purdate        TYPE sydatum, " Latest PO date
      lv_knttp_y        TYPE knttp,   " Account Assignment Category
*     End   of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
      lv_knttp_p        TYPE knttp.   " Account Assignment Category

* Local Constant Declaration
CONSTANTS : lc_i          TYPE tvarv_sign  VALUE 'I',           " ABAP: ID: I/E (include/exclude values)
            lc_eq         TYPE tvarv_opti  VALUE 'EQ',          " ABAP: Selection option (EQ/BT/CP/...)
            lc_order_type TYPE rvari_vnam  VALUE 'ORDER_TYPE',
            lc_value_type TYPE rvari_vnam  VALUE 'VALUE_TYPE',
            lc_wrttp      TYPE rvari_vnam  VALUE 'WRTTP',       " ABAP: Name of Variant Variable
            lc_print_po   TYPE rvari_vnam  VALUE 'PRINT_PO',    " ABAP: Name of Variant Variable
            lc_mat_type   TYPE rvari_vnam  VALUE 'MAT_TYPE',    " ABAP: Name of Variant Variable
            lc_mtart      TYPE rvari_vnam  VALUE 'MTART',       " ABAP: Name of Variant Variable
            lc_distr_po   TYPE rvari_vnam  VALUE 'DISTR_PO',    " ABAP: Name of Variant Variable
            lc_acc_cat    TYPE rvari_vnam  VALUE 'ACCOUNT_CAT', " ABAP: Name of Variant Variable
            lc_cost_elem  TYPE rvari_vnam  VALUE 'COST_ELEM',   " ABAP: Name of Variant Variable
            lc_kstar      TYPE rvari_vnam  VALUE 'KSTAR',       " ABAP: Name of Variant Variable
*           Begin of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
            lc_reprint    TYPE rvari_vnam  VALUE 'REPRINT',     " ABAP: Name of Variant Variable
*           End   of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
            lc_project    TYPE rvari_vnam  VALUE 'PROJECT'.     " ABAP: Name of Variant Variable

DATA: lr_pord_hdr  TYPE REF TO if_purchase_order_mm,         "PO Header External View
      lr_pord_accm TYPE REF TO if_purchase_order_account_mm. "PO Account Assignment External View


* Document Header for Item
CALL METHOD im_item->get_header
  RECEIVING
    re_header = lr_pord_hdr.
IF lr_pord_hdr IS BOUND.
* Get Header Data
  CALL METHOD lr_pord_hdr->get_data
    RECEIVING
      re_data = lst_po_header. "Purchase Order Header Data
ENDIF. " IF lr_pord_hdr IS BOUND

* Get Item Data
CALL METHOD im_item->get_data
  RECEIVING
    re_data = lst_itm_data. "Purchase Order Item

* Get The order type from ZCA constant table.
* Binary search is not required as table will have very few records.
CLEAR lst_constant.
READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_order_type
                                                  param2 = lc_print_po.
IF sy-subrc EQ 0.
  lv_order_type_nb = lst_constant-low.
ENDIF. " IF sy-subrc EQ 0

* Get Material Type from ZCA constant table.
* Binary search is not required as table will have very few records.
CLEAR lst_constant.
READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_mat_type
                                                  param2 = lc_mtart.
IF sy-subrc EQ 0.
  lv_mat_type_zjip = lst_constant-low.
ENDIF. " IF sy-subrc EQ 0

* Get Account assignmet from ZCA table
* Binary search is not required as table will have very few records.
CLEAR lst_constant.
READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_acc_cat
                                                  param2 = lc_project.
IF sy-subrc EQ 0.
  lv_knttp_p = lst_constant-low.
ENDIF. " IF sy-subrc EQ 0

* Begin of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
* Get Account assignmet (Reprint) from ZCA table
* Binary search is not required as table will have very few records.
CLEAR lst_constant.
READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_acc_cat
                                                  param2 = lc_reprint.
IF sy-subrc EQ 0.
  lv_knttp_y = lst_constant-low.
ENDIF. " IF sy-subrc EQ 0
* End   of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861

* Binary search is not required as table will have very few records.
CLEAR lst_constant.
READ TABLE i_constants INTO lst_constant WITH KEY  param1 = lc_order_type
                                                   param2 = lc_distr_po.
IF sy-subrc EQ 0.
  lv_order_type_znb = lst_constant-low.
ENDIF. " IF sy-subrc EQ 0

* Check if the order is type 'NB' and material is of type 'ZJIP'
IF lst_po_header-bsart EQ lv_order_type_nb
  AND lst_itm_data-umson EQ abap_false "Not a Free Item
  AND ( lst_itm_data-knttp  EQ lv_knttp_p  OR
      lst_itm_data-knttp  IS INITIAL ).

  IF st_mat_detl-mtart EQ lv_mat_type_zjip.

    SELECT pspnr,                        "WBS Element
           posid,
           pkokr,                        "Controlling area for WBS element
           kostl,                        "Cost center to which costs are actually posted
           objnr                         " Object number
      FROM prps                          " WBS (Work Breakdown Structure) Element Master Data
      UP TO 1 ROWS
      INTO @DATA(lst_prps)
     WHERE zzmpm EQ @lst_itm_data-matnr. "MPM Issue
    ENDSELECT.
    IF sy-subrc EQ 0.
      lv_objnr = lst_prps-objnr.
    ENDIF. " IF sy-subrc EQ 0

* Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
    IF v_first_print IS NOT INITIAL.
* End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
      IF lst_itm_data-knttp IS INITIAL     "Account Assignment Category
        AND lst_itm_data-umson IS INITIAL. "Free Item
        lst_itm_data-knttp = lv_knttp_p. "Account Assignment Category: Project
*   Account Assignments
        CALL METHOD im_item->get_accountings
          RECEIVING
            re_accountings = li_accountings.
        IF li_accountings IS INITIAL.
*     Factory Account Assignment
          CALL METHOD im_item->create_account
            EXPORTING
              im_zexkn   = '01'
            RECEIVING
              re_account = lr_pord_accm. "PO Account Assignment External View

*     Get Account Assignment Data
          CALL METHOD lr_pord_accm->get_data
            RECEIVING
              re_data = lst_acc_data. "Account Assignment Fields for Purchase Order

          SELECT kokrs,               " Controlling Area
                 kostl,               " Cost Center
                 datbi,               " Valid To Date
                 prctr                " Profit Center
            FROM csks                 " Cost Center Master Data
            UP TO 1 ROWS
            INTO @DATA(lst_wbs_ele)
            WHERE kokrs = @lst_prps-pkokr
             AND  kostl = @lst_prps-kostl
             AND  datbi GE @sy-datum  "Valid To Date
             AND  datab LE @sy-datum. "Valid From Date
          ENDSELECT.
          IF sy-subrc EQ 0.
            lst_acc_data-kostl      = lst_prps-kostl. "Cost Center
            lst_acc_data-kokrs      = lst_prps-pkokr. "Controlling Area
            lst_acc_data-prctr      = lst_wbs_ele-prctr. "Profit Center
            lst_acc_data-ps_psp_pnr = lst_prps-posid. "Work Breakdown Structure Element (WBS Element)
            lst_acc_data-psp_pnr = lst_prps-posid. "Work Breakdown Structure Element (WBS Element)
*       Set Account Assignment Data (Without Validation)
            CALL METHOD lr_pord_accm->set_data
              EXPORTING
                im_data = lst_acc_data. "Account Assignment Fields for Purchase Order
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF li_accountings IS INITIAL
      ENDIF. " IF lst_itm_data-knttp IS INITIAL
*  ENDIF. " IF st_mat_detl-mtart EQ lv_mat_type_zjip

** Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
*  IF v_first_print IS NOT INITIAL.
** End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319

*   Update Distributor Name
      SELECT lifnr " Vendor Account Number
        FROM eord  " Purchasing Source List
        UP TO 1 ROWS
        INTO @DATA(lv_lifnr)
        WHERE matnr = @lst_itm_data-matnr
        AND  werks  = @lst_itm_data-werks
        AND flifn = @abap_true
        AND vdatu LT @sy-datum
        AND bdatu GT @sy-datum.
        IF sy-subrc EQ 0.
          lst_itm_data-emlif = lv_lifnr.
        ENDIF. " IF sy-subrc EQ 0
      ENDSELECT.

      li_constant_tmp[] = i_constants[].
      DELETE li_constant_tmp WHERE param1 <>  lc_cost_elem
                              AND  param2 <>  lc_kstar.

      LOOP AT li_constant_tmp ASSIGNING FIELD-SYMBOL(<lst_const>).
        lst_cost_elem-sign    = <lst_const>-sign.
        lst_cost_elem-option  = <lst_const>-opti.
        lst_cost_elem-low     = <lst_const>-low.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lst_cost_elem-low
          IMPORTING
            output = lst_cost_elem-low.
        APPEND lst_cost_elem TO lir_cost_elem.
        CLEAR lst_cost_elem.
      ENDLOOP. " LOOP AT li_constant_tmp ASSIGNING FIELD-SYMBOL(<lst_const>)

* Binary search is not required as table will have very few records.
      CLEAR lst_constant.
      READ TABLE i_constants INTO lst_constant WITH KEY param1 = lc_value_type
                                                        param2 = lc_wrttp.
      IF sy-subrc EQ 0.
        lv_wrttp_10 = lst_constant-low.
      ENDIF. " IF sy-subrc EQ 0

*     Begin of DEL:ERP-6152:WROY:02-JUL-2018:ED2K912490
*     IF lv_objnr IS NOT INITIAL .
*     End   of DEL:ERP-6152:WROY:02-JUL-2018:ED2K912490
*     Begin of ADD:ERP-6152:WROY:02-JUL-2018:ED2K912490
      IF lst_po_header-ebeln IS INITIAL AND
         lv_objnr IS NOT INITIAL .
*     End   of ADD:ERP-6152:WROY:02-JUL-2018:ED2K912490

* Calculate Purchase Order Price
        SELECT lednr,   " Ledger for Controlling objects
               objnr,
               gjahr,   " Fiscal Year
               wrttp,   " Value Type
               versn,   " Version
               kstar,   " Cost Element
               hrkft,   " CO key subnumber
               vrgng,   " CO Business Transaction
               vbund,   " Company ID of Trading Partner
               pargb,   " Trading Partner's Business Area
               beknz,   " Debit/credit indicator
               twaer,   " Transaction Currency
               perbl,   " Period block
               wog001,  " Total Value in Object Currency
               wog002,  " Total Value in Object Currency
               wog003,  " Total Value in Object Currency
               wog004,  " Total Value in Object Currency
               wog005,  " Total Value in Object Currency
               wog006,  " Total Value in Object Currency
               wog007,  " Total Value in Object Currency
               wog008,  " Total Value in Object Currency
               wog009,  " Total Value in Object Currency
               wog010,  " Total Value in Object Currency
               wog011,  " Total Value in Object Currency
               wog012   " Total Value in Object Currency
           FROM    cosp " CO Object: Cost Totals for External Postings
          INTO TABLE @DATA(li_cosp)
          WHERE objnr EQ @lv_objnr
          AND   wrttp = @lv_wrttp_10
          AND   kstar IN @lir_cost_elem.
        IF sy-subrc EQ 0.
          SORT li_cosp BY kstar ASCENDING versn DESCENDING.
          DELETE ADJACENT DUPLICATES FROM li_cosp COMPARING kstar.

          LOOP AT li_cosp ASSIGNING FIELD-SYMBOL(<lst_cosp>).
            lv_jour_price = ( <lst_cosp>-wog001 + <lst_cosp>-wog002 +
                              <lst_cosp>-wog003 + <lst_cosp>-wog004 +
                              <lst_cosp>-wog005 + <lst_cosp>-wog006 +
                              <lst_cosp>-wog007 + <lst_cosp>-wog008 +
                              <lst_cosp>-wog009 + <lst_cosp>-wog010 +
                              <lst_cosp>-wog011 + <lst_cosp>-wog012 ).

            lv_final_price = lv_final_price + lv_jour_price .
            CLEAR: lv_jour_price.
          ENDLOOP. " LOOP AT li_cosp ASSIGNING FIELD-SYMBOL(<lst_cosp>)
          lv_total_qtn =  v_itm_qty + v_conf_qunt .
          IF lv_total_qtn IS NOT INITIAL.
            lv_pur_price = (  lv_final_price / lv_total_qtn ).
          ENDIF. " IF lv_total_qtn IS NOT INITIAL
        ENDIF. " IF sy-subrc EQ 0

      ENDIF. " IF lv_objnr IS NOT INITIAL
*Get all the PO price
      IF  lv_pur_price IS NOT INITIAL.
        lst_itm_data-netpr = lv_pur_price.
      ENDIF. " IF lv_pur_price IS NOT INITIAL
* Begin of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
    ELSE. " ELSE -> IF v_first_print IS NOT INITIAL
*     Begin of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
      IF lst_itm_data-knttp IS INITIAL     "Account Assignment Category
        AND lst_itm_data-umson IS INITIAL. "Free Item
        lst_itm_data-knttp = lv_knttp_y. "Account Assignment Category: Reprint
*       Account Assignments
        CALL METHOD im_item->get_accountings
          RECEIVING
            re_accountings = li_accountings.
        IF li_accountings IS INITIAL.
*         Factory Account Assignment
          CALL METHOD im_item->create_account
            EXPORTING
              im_zexkn   = '01'
            RECEIVING
              re_account = lr_pord_accm. "PO Account Assignment External View

*         Get Account Assignment Data
          CALL METHOD lr_pord_accm->get_data
            RECEIVING
              re_data = lst_acc_data. "Account Assignment Fields for Purchase Order

          SELECT kokrs,               " Controlling Area
                 kostl,               " Cost Center
                 datbi,               " Valid To Date
                 prctr                " Profit Center
            FROM csks                 " Cost Center Master Data
            UP TO 1 ROWS
            INTO @lst_wbs_ele
            WHERE kokrs = @lst_prps-pkokr
             AND  kostl = @lst_prps-kostl
             AND  datbi GE @sy-datum  "Valid To Date
             AND  datab LE @sy-datum. "Valid From Date
          ENDSELECT.
          IF sy-subrc EQ 0.
            lst_acc_data-kostl      = lst_prps-kostl. "Cost Center
            lst_acc_data-kokrs      = lst_prps-pkokr. "Controlling Area
            lst_acc_data-prctr      = lst_wbs_ele-prctr. "Profit Center
            lst_acc_data-ps_psp_pnr = lst_prps-posid. "Work Breakdown Structure Element (WBS Element)
            lst_acc_data-psp_pnr = lst_prps-posid. "Work Breakdown Structure Element (WBS Element)
*           Set Account Assignment Data (Without Validation)
            CALL METHOD lr_pord_accm->set_data
              EXPORTING
                im_data = lst_acc_data. "Account Assignment Fields for Purchase Order
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF li_accountings IS INITIAL
      ENDIF. " IF lst_itm_data-knttp IS INITIAL
*     End   of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
      IF lst_po_header-ebeln IS INITIAL AND
         v_netpr             IS NOT INITIAL.
        lst_itm_data-netpr = v_netpr.
      ENDIF. " IF lst_po_header-ebeln IS INITIAL
    ENDIF. " IF v_first_print IS NOT INITIAL
* End of CHANGE:CR#509:LKODWANI:25-MAY-2017:ED2K906319
  ENDIF. " IF st_mat_detl-mtart EQ lv_mat_type_zjip

ELSEIF lst_po_header-bsart EQ lv_order_type_znb .

  IF lst_itm_data-loekz IS INITIAL.
*   Free of Cost Indicator
    lst_itm_data-umson = abap_true.

*   Latest Purchase Order Date Validation
*   Begin of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
    CLEAR: lv_purdate.
    SELECT SINGLE plifz         " Planned Delivery Time in Days
      FROM marc                 " Plant Data for Material
      INTO @DATA(lv_planned_delv)
     WHERE matnr EQ @lst_itm_data-matnr
       AND werks EQ @lst_itm_data-werks.
    IF sy-subrc EQ 0.
      SELECT gen_start_date     " IS-M: Start Date for Order Generation
        FROM jksenip            " IS-M: Shipping Schedule
       UP TO 1 ROWS
        INTO @DATA(lv_ord_cr_date)
       WHERE issue EQ @lst_itm_data-matnr.
      ENDSELECT.
      IF sy-subrc EQ 0.
        lv_purdate = lv_ord_cr_date + lv_planned_delv.
      ENDIF.
    ENDIF.
    IF lv_purdate IS INITIAL OR
       lv_purdate GT sy-datum.
* BOC by PBANDLAPAL on 18-Jan-2018 for ERP-6013: ED2K910358
*      MESSAGE e163(zqtc_r2). " Latest Purchase Order Date is less then system date.
      MESSAGE e163(zqtc_r2)." Shipping Plan Order creation Date is greater then system date.
* EOC by PBANDLAPAL on 18-Jan-2018 for ERP-6013: ED2K910358
      CALL METHOD im_item->invalidate( ).
    ENDIF.
*   End   of ADD:CR656/657/658:WROY:10-OCT-2017:ED2K908861
*   Begin of DEL:CR656/657/658:WROY:10-OCT-2017:ED2K908861
*   SELECT SINGLE ismpurchasedate " IS-M: Latest Possible Purchase Order Date
*       FROM marc                 " Plant Data for Material
*      INTO @DATA(lv_purdate)
*      WHERE matnr = @lst_itm_data-matnr
*       AND werks =  @lst_itm_data-werks.
*   IF sy-subrc EQ 0.
*     IF lv_purdate IS INITIAL OR
*        lv_purdate GT sy-datum.
*       MESSAGE e163(zqtc_r2). " Latest Purchase Order Date is less then system date.
*       CALL METHOD im_item->invalidate( ).
*     ENDIF. " IF lv_purdate IS INITIAL OR
*   ENDIF. " IF sy-subrc EQ 0
*   End   of DEL:CR656/657/658:WROY:10-OCT-2017:ED2K908861
  ENDIF. " IF lst_itm_data-loekz IS INITIAL

ENDIF. " IF lst_po_header-bsart EQ lv_order_type_nb

* Set Item Data (Without Check)
CALL METHOD im_item->set_data
  EXPORTING
    im_data = lst_itm_data. "Purchase Order Item
