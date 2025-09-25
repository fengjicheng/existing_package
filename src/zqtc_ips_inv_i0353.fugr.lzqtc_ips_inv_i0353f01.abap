*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_IPS_INV_I0353F01
* PROGRAM DESCRIPTION: Include program contains the Form routine for
*                      Function group
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-26
* OBJECT ID:E095 (CR# ERP-6594)
* TRANSPORT NUMBER(S): ED2K912233
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: ED2K913096
* REFERENCE NO: CR# 6594
* DEVELOPER: Niraj Gadre (NGADRE)
* DATE: 08-21-2018
* DESCRIPTION: Logic has been added for Subsequent credit and Subsequent
* credit scenario
*-------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_ERROR_MSG
*&---------------------------------------------------------------------*
*       Populate the Error log Messages
*----------------------------------------------------------------------*
*      <--FP_EX_MESSAGE  text
*----------------------------------------------------------------------*
FORM f_populate_error_msg  CHANGING fp_ex_message TYPE bapiretct.

  DATA :  lst_message TYPE bapiretc. " Return Parameter for Complex Data Type

  lst_message-type        = sy-msgty.
  lst_message-id          = sy-msgid.
  lst_message-number      = sy-msgno.
  lst_message-message_v1  = sy-msgv1.
  lst_message-message_v2  = sy-msgv2.
  lst_message-message_v3  = sy-msgv3.
  lst_message-message_v4  = sy-msgv4.
  MESSAGE ID sy-msgid
        TYPE sy-msgty
      NUMBER sy-msgno
        WITH sy-msgv1
             sy-msgv2
             sy-msgv3
             sy-msgv4
        INTO lst_message-message.

  APPEND lst_message TO fp_ex_message.
  CLEAR lst_message.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALCULATE_PO_QTY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_CT_IDOC_DATA  IDOC data
*      -->FP_LV_PO_NO  PO Number
*      <--FP_LI_EKPO_DATA  PO line item details for processing
*----------------------------------------------------------------------*
FORM f_calculate_po_qty  USING    fp_ct_idoc_data TYPE edidd_tt
                                  fp_lv_po_no TYPE ebeln_d    " Purchasing Document
                                  fp_lv_wrbtr_idoc TYPE wrbtr " Amount in Document Currency
                         CHANGING fp_li_ekpo_data TYPE tt_ekpo_data
                                  fp_ex_error TYPE char01.    " Ex_error of type CHAR01


  TYPES : BEGIN OF lty_ekbe,
            ebeln TYPE ebeln,   " Purchasing Document Number
            ebelp TYPE ebelp,   " Item Number of Purchasing Document
            zekkn TYPE dzekkn,  " Sequential Number of Account Assignment
            vgabe TYPE vgabe,   " Transaction/event type, purchase order history
            gjahr TYPE gjahr,   " Fiscal Year
            belnr TYPE mblnr,   " Number of Material Document
            buzei TYPE mblpo,   " Item in Material Document
            menge TYPE menge_d, " Quantity
            wrbtr TYPE wrbtr,   " Amount in Document Currency
            shkzg TYPE shkzg,   " Debit/Credit Indicator
          END OF lty_ekbe,

          BEGIN OF lty_po_item,
            ebeln TYPE ebeln,   " Purchasing Document Number
            ebelp TYPE ebelp,   " Item Number of Purchasing Document
            menge TYPE bstmg,   " Purchase Order Quantity
            meins TYPE meins,   " Base Unit of Measure
            uebto TYPE uebto,   " Overdelivery Tolerance Limit
            erekz TYPE erekz,   " Final Invoice Indicator
            banfn TYPE banfn,   " Purchase Requisition Number
          END OF lty_po_item.

*Local data declarations
  DATA : lst_idoc_data       TYPE edidd,   " Data record (IDoc)
         lst_e1edp01         TYPE e1edp01, " IDoc: Document Item General Data
         lst_e1edk01         TYPE e1edk01, " IDoc: Document header general data
*         lst_e1edp04         TYPE e1edp04,                      " IDoc: Document Item Taxes
         li_ekbe_data        TYPE STANDARD TABLE OF lty_ekbe    " Transfer Structure for PO History
                              INITIAL SIZE 0,
         li_open_ekpo        TYPE STANDARD TABLE OF ty_ekpo_data
                                INITIAL SIZE 0,
         li_po_item          TYPE STANDARD TABLE OF lty_po_item " Transfer Structure: Display/List PO Item
                                 INITIAL SIZE 0,
         lst_ekbe_data       TYPE lty_ekbe,                     " Transfer Structure for PO History
         lst_open_ekpo       TYPE ty_ekpo_data,
         lst_ekpo_data       TYPE ty_ekpo_data,
         lst_ekbe_temp       TYPE lty_ekbe,                     " Transfer Structure for PO History
         lst_po_item         TYPE lty_po_item,                  " Transfer Structure: Display/List PO Item
         lv_menge            TYPE menge_d,                      " Quantity
         lv_menge_inv        TYPE menge_d,                      " Quantity
         lv_uom              TYPE meins,                        " Base Unit of Measure
         lv_tot_inv_qty      TYPE menge_d,                      " Quantity
         lv_tot_open_qty     TYPE menge_d,                      " Quantity
         lv_tot_open_qty_tol TYPE menge_d,                      " Quantity
         lv_tol_qty          TYPE menge_d,                      " Quantity
         lv_inv_qty          TYPE menge_d,                      " Quantity
         lv_wrbtr(16)        TYPE p DECIMALS 5,                 " Amount in Document Currency
         lv_waers            TYPE waers,                        " Currency Key
         lv_bsart            TYPE bsart,                        " document Type
         lv_message          TYPE char100.                      " Message of type CHAR100



*Local constant declarations
  CONSTANTS :   lc_e1edp01    TYPE edilsegtyp VALUE 'E1EDP01', " Segment type
                lc_e1edk01    TYPE edilsegtyp VALUE 'E1EDK01', " Segment type
                lc_shkzg_s    TYPE shkzg      VALUE 'S',       " Debit/Credit Indicator
                lc_cr_memo    TYPE bsart      VALUE 'CRME',    " Order Type (Purchasing)
                lc_invoice    TYPE bsart      VALUE 'INVO',    " Order Type (Purchasing)
                lc_vgabe_post TYPE vgabe      VALUE '2',       " Transaction/event type, purchase order history
*Begin of ADD:ERP-6594:NGADRE:21-AUG-2018:ED2K913096
                lc_sub_debit  TYPE bsart      VALUE 'SUBD', " Order Type (Purchasing)
                lc_sub_credit TYPE bsart      VALUE 'SUBC'. " Order Type (Purchasing)
*End of ADD:ERP-6594:NGADRE:21-AUG-2018:ED2K913096

  CLEAR : lv_menge,
          lv_wrbtr,
          lv_tot_inv_qty,
          lv_tot_open_qty,
          lv_tot_open_qty_tol.

*Get the Inv Quntity from IDOC
*Get the PO number from IDOC data
  READ TABLE fp_ct_idoc_data INTO lst_idoc_data
                             WITH KEY segnam = lc_e1edp01.
  IF sy-subrc EQ 0.
    lst_e1edp01 = lst_idoc_data-sdata.
    lv_menge = lst_e1edp01-menge.
    lv_menge_inv = lst_e1edp01-menge.
    lv_uom   = lst_e1edp01-menee.
  ENDIF. " IF sy-subrc EQ 0


**check the PO exist or not
  SELECT SINGLE waers " Currency Key
     FROM ekko        " Purchasing Document Header
     INTO lv_waers
     WHERE ebeln = fp_lv_po_no.
  IF sy-subrc EQ 0.

**Get the IDO ccurrency from E1EDK01 Segment and compare with PO currency
** if not matching then raise the error message
    READ TABLE fp_ct_idoc_data INTO lst_idoc_data
                                  WITH KEY segnam = lc_e1edk01.
    IF sy-subrc EQ 0.

      lst_e1edk01 = lst_idoc_data-sdata.

      lv_bsart = lst_e1edk01-bsart.


      IF lv_waers NE lst_e1edk01-curcy.
* Currency Not same as PO currency
        fp_ex_error = abap_true.
        MESSAGE e504(zqtc_r2) INTO lv_message. " Invoice Currency is not same as PO currency
        RETURN.

      ENDIF. " IF lv_waers NE lst_e1edk01-curcy

    ENDIF. " IF sy-subrc EQ 0

  ELSE. " ELSE -> IF sy-subrc EQ 0

    RETURN.

  ENDIF. " IF sy-subrc EQ 0


**select PO details frm EKPO table
  SELECT ebeln " Purchasing Document Number
         ebelp " Item Number of Purchasing Document
         menge " Purchase Order Quantity
         meins " Purchase Order Unit of Measure
         uebto " Overdelivery Tolerance Limit
         erekz " Final Invoice Indicator
         banfn " Purchase Requisition Number
   FROM ekpo   " Purchasing Document Item
    INTO TABLE li_po_item
    WHERE ebeln = fp_lv_po_no
      AND loekz EQ space.
*      AND erekz EQ space.
  IF sy-subrc EQ 0.

    SORT li_po_item BY erekz.

** Check Transaction type, if Invoice then remove the PO line item
**where final invoice indicator set.
    IF lv_bsart EQ lc_invoice.

      DELETE li_po_item WHERE erekz IS NOT INITIAL .

    ENDIF. " IF lv_bsart EQ lc_invoice

  ENDIF. " IF sy-subrc EQ 0

  IF li_po_item IS NOT INITIAL.

    SORT li_po_item BY ebeln ebelp.

** Get the PO History
    SELECT    ebeln " Item Number of Purchasing Document
              ebelp " Item Number of Purchasing Document
              zekkn " Sequential Number of Account Assignment
              vgabe " Transaction/event type, purchase order history
              gjahr " Fiscal Year
              belnr " Number of Material Document
              buzei " Item in Material Document
              menge " Quantity
              wrbtr " Amount in Document Currency
              shkzg " Debit/Credit Indicator
        FROM  ekbe  " History per Purchasing Document
        INTO TABLE li_ekbe_data
        FOR ALL ENTRIES IN li_po_item
        WHERE ebeln EQ li_po_item-ebeln
          AND ebelp EQ li_po_item-ebelp
          AND vgabe EQ lc_vgabe_post.


    IF sy-subrc EQ 0.

      SORT li_ekbe_data BY vgabe shkzg.

*Begin of ADD:ERP-6594:NGADRE:21-AUG-2018:ED2K913096
      SORT li_ekbe_data BY ebeln ebelp.
*End of ADD:ERP-6594:NGADRE:21-AUG-2018:ED2K913096

      LOOP AT li_ekbe_data INTO lst_ekbe_data.

*Calculate the Total Open Quantity for Invoice,credit memo
* Sub credit memo and Sub Debit Memo.
        IF lst_ekbe_data-shkzg = lc_shkzg_s.
          lv_inv_qty = lst_ekbe_data-menge + lv_inv_qty.
        ELSE. " ELSE -> IF lst_ekbe_data-shkzg = lc_shkzg_s
          lv_inv_qty = lv_inv_qty - lst_ekbe_data-menge.
        ENDIF. " IF lst_ekbe_data-shkzg = lc_shkzg_s

        lst_ekbe_temp = lst_ekbe_data.
        AT END OF ebelp.
          lst_ekbe_data = lst_ekbe_temp.

          IF lv_bsart EQ lc_cr_memo
          OR lv_bsart EQ lc_sub_credit
          OR lv_bsart EQ lc_sub_debit.

            lst_open_ekpo-menge = lv_inv_qty.
            lv_tot_inv_qty = lv_tot_inv_qty + lst_open_ekpo-menge.

          ELSEIF lv_bsart EQ lc_invoice.

            READ TABLE li_po_item INTO lst_po_item
                              WITH KEY ebeln  = lst_ekbe_data-ebeln
                                       ebelp = lst_ekbe_data-ebelp
                              BINARY SEARCH.
            IF sy-subrc EQ 0.
              lst_open_ekpo-menge = lst_po_item-menge - lv_inv_qty.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF lv_bsart EQ lc_cr_memo

          lst_open_ekpo-ebeln = lst_ekbe_data-ebeln.
          lst_open_ekpo-ebelp = lst_ekbe_data-ebelp.

          APPEND lst_open_ekpo TO li_open_ekpo.

          CLEAR : lv_inv_qty,
                  lst_open_ekpo.

        ENDAT.

      ENDLOOP. " LOOP AT li_ekbe_data INTO lst_ekbe_data

    ENDIF. " IF sy-subrc EQ 0


    IF lv_menge IS NOT INITIAL.
      lv_wrbtr = fp_lv_wrbtr_idoc / lv_menge.
    ENDIF. " IF lv_menge IS NOT INITIAL

    CASE lv_bsart.

      WHEN lc_invoice.
**calculate the total Open Quamtity for PO.

        SORT li_open_ekpo BY ebeln ebelp.
        LOOP AT li_po_item INTO lst_po_item.

          CLEAR : lst_open_ekpo.
          READ TABLE li_open_ekpo INTO lst_open_ekpo
                            WITH KEY ebeln = lst_po_item-ebeln
                                     ebelp = lst_po_item-ebelp
                                     BINARY SEARCH.
          IF sy-subrc EQ 0.
            lv_tot_open_qty = lv_tot_open_qty + lst_open_ekpo-menge.
          ELSE. " ELSE -> IF sy-subrc EQ 0
            lv_tot_open_qty = lv_tot_open_qty + lst_po_item-menge.
          ENDIF. " IF sy-subrc EQ 0

**calculate the open qunatity with Tolarance limit
          IF lst_po_item-uebto IS NOT INITIAL.
            CLEAR lv_tol_qty.

            lv_tol_qty = ( lst_po_item-uebto / 100 ) * lst_po_item-menge.

            lv_tot_open_qty_tol = lv_tot_open_qty_tol + lv_tot_open_qty + lv_tol_qty.

          ELSE. " ELSE -> IF lst_po_item-uebto IS NOT INITIAL

            lv_tot_open_qty_tol = lv_tot_open_qty_tol + lv_tot_open_qty.

          ENDIF. " IF lst_po_item-uebto IS NOT INITIAL

          CLEAR lst_po_item.

        ENDLOOP. " LOOP AT li_po_item INTO lst_po_item

**check the open open qunantity along with Line item tolerence is greater than or equal to
* incoming invoice quantity
        IF lv_tot_open_qty_tol LT lv_menge.
          fp_ex_error = abap_true.
          MESSAGE e503(zqtc_r2) INTO lv_message. " Quantity is more than Open PO quantity with tolarane.
          RETURN.

        ENDIF. " IF lv_tot_open_qty_tol LT lv_menge

**check if Invoice Qty is greater than Open PO Quantity.
** If yes : Distribute the qty to Non PR line item first and then PR line item
** If No : Distribute the qty to PR line item  and then Non PR
        IF lv_tot_open_qty GT lv_menge_inv.
          SORT li_po_item BY banfn DESCENDING.
        ELSE. " ELSE -> IF lv_tot_open_qty GT lv_menge_inv
          SORT li_po_item BY banfn.
        ENDIF. " IF lv_tot_open_qty GT lv_menge_inv

* calculate the Qty distribution for each PO line item
        LOOP AT li_po_item INTO lst_po_item.

          CLEAR : lst_open_ekpo.
          READ TABLE li_open_ekpo INTO lst_open_ekpo
                            WITH KEY ebeln = lst_po_item-ebeln
                                     ebelp = lst_po_item-ebelp
                            BINARY SEARCH.
          IF sy-subrc EQ 0.

            IF lst_open_ekpo-menge IS NOT INITIAL.

              IF lst_open_ekpo-menge LE lv_menge.

                lst_ekpo_data-menge = lst_open_ekpo-menge.
*            lst_ekpo_data-wrbtr = lst_open_ekpo-menge * lv_wrbtr.

                lv_menge = lv_menge - lst_open_ekpo-menge.

              ELSE. " ELSE -> IF lst_open_ekpo-menge LE lv_menge

                lst_ekpo_data-menge = lv_menge.
*            lst_ekpo_data-wrbtr = lv_menge * lv_wrbtr.

                CLEAR lv_menge.

              ENDIF. " IF lst_open_ekpo-menge LE lv_menge

              lst_ekpo_data-ebeln = lst_open_ekpo-ebeln.
              lst_ekpo_data-ebelp = lst_open_ekpo-ebelp.
              lst_ekpo_data-banfn = lst_po_item-banfn.
**update tol. qty
              IF lst_po_item-uebto IS NOT INITIAL.
                lst_ekpo_data-tol_menge = lst_po_item-menge * ( lst_po_item-uebto / 100 ).
              ENDIF. " IF lst_po_item-uebto IS NOT INITIAL

*          lv_tot_open_qty = lv_tot_open_qty + lst_open_ekpo-menge + lst_ekpo_data-tol_menge.

              APPEND lst_ekpo_data TO fp_li_ekpo_data.

            ENDIF. " IF lst_open_ekpo-menge IS NOT INITIAL

          ELSE. " ELSE -> IF sy-subrc EQ 0

            lst_ekpo_data-ebeln = lst_po_item-ebeln.
            lst_ekpo_data-ebelp = lst_po_item-ebelp.
            lst_ekpo_data-banfn = lst_po_item-banfn.

            IF  lst_po_item-menge LE lv_menge.
              lst_ekpo_data-menge = lst_po_item-menge.
*          lst_ekpo_data-wrbtr = lst_po_item-menge * lv_wrbtr.

              lv_menge = lv_menge - lst_po_item-menge.

            ELSE. " ELSE -> IF lst_po_item-menge LE lv_menge
              lst_ekpo_data-menge = lv_menge.
*          lst_ekpo_data-wrbtr = lv_menge * lv_wrbtr.
              CLEAR lv_menge.
            ENDIF. " IF lst_po_item-menge LE lv_menge

**update tol. qty
            IF lst_po_item-uebto IS NOT INITIAL.
              lst_ekpo_data-tol_menge = lst_po_item-menge * ( lst_po_item-uebto / 100 ).
            ENDIF. " IF lst_po_item-uebto IS NOT INITIAL

            APPEND lst_ekpo_data TO fp_li_ekpo_data.

          ENDIF. " IF sy-subrc EQ 0

          CLEAR : lst_ekpo_data,
                  lst_po_item.

          IF lv_menge IS INITIAL
          OR lv_menge LT 0.
            EXIT.
          ENDIF. " IF lv_menge IS INITIAL

        ENDLOOP. " LOOP AT li_po_item INTO lst_po_item

**check if Quantity is still present for distribition if so then consider the tolerance value
** for each line item and distribute the remainig quantity
** Distribute the remaining Qty as per Line item tolarance with PR line item first
** and Non PR line item.

        SORT fp_li_ekpo_data BY banfn DESCENDING.

        IF lv_menge GT 0.
          LOOP AT fp_li_ekpo_data ASSIGNING FIELD-SYMBOL(<lst_ekpo_data>).

            IF <lst_ekpo_data>-tol_menge IS NOT INITIAL.
              IF <lst_ekpo_data>-tol_menge LE lv_menge.

                <lst_ekpo_data>-menge = <lst_ekpo_data>-menge + <lst_ekpo_data>-tol_menge.
                lv_menge  = lv_menge - <lst_ekpo_data>-tol_menge.

              ELSE. " ELSE -> IF <lst_ekpo_data>-tol_menge LE lv_menge

                <lst_ekpo_data>-menge = <lst_ekpo_data>-menge + lv_menge.
                CLEAR lv_menge.

              ENDIF. " IF <lst_ekpo_data>-tol_menge LE lv_menge

            ENDIF. " IF <lst_ekpo_data>-tol_menge IS NOT INITIAL

            IF lv_menge IS INITIAL
           OR lv_menge LT 0.
              EXIT.
            ENDIF. " IF lv_menge IS INITIAL

          ENDLOOP. " LOOP AT fp_li_ekpo_data ASSIGNING FIELD-SYMBOL(<lst_ekpo_data>)

        ENDIF. " IF lv_menge GT 0

**Credit memo Request Quantity distribution logic.
      WHEN lc_cr_memo OR lc_sub_credit OR lc_sub_debit.

        IF lv_tot_inv_qty LT lv_menge.

          fp_ex_error = abap_true.
          MESSAGE e505(zqtc_r2) INTO lv_message. " Quantity more than posted invoice qunaity.
          RETURN.

        ENDIF. " IF lv_tot_inv_qty LT lv_menge

        LOOP AT li_open_ekpo INTO lst_open_ekpo.

          IF lst_open_ekpo-menge IS NOT INITIAL.

            IF lst_open_ekpo-menge LE lv_menge.

              lst_ekpo_data-menge = lst_open_ekpo-menge.
              lv_menge = lv_menge - lst_open_ekpo-menge.

            ELSE. " ELSE -> IF lst_open_ekpo-menge LE lv_menge

              lst_ekpo_data-menge = lv_menge.

              CLEAR lv_menge.

            ENDIF. " IF lst_open_ekpo-menge LE lv_menge

            lst_ekpo_data-ebeln = lst_open_ekpo-ebeln.
            lst_ekpo_data-ebelp = lst_open_ekpo-ebelp.

            APPEND lst_ekpo_data TO fp_li_ekpo_data.

          ENDIF. " IF lst_open_ekpo-menge IS NOT INITIAL

          IF lv_menge IS INITIAL
         OR lv_menge LT 0.
            EXIT.
          ENDIF. " IF lv_menge IS INITIAL

          CLEAR : lst_ekpo_data,
                  lst_open_ekpo.

        ENDLOOP. " LOOP AT li_open_ekpo INTO lst_open_ekpo


      WHEN OTHERS.


    ENDCASE.

** calulate the amount for distributed line items
    SORT fp_li_ekpo_data BY ebelp.

    LOOP AT fp_li_ekpo_data ASSIGNING FIELD-SYMBOL(<lst_ekpo_temp>).

      <lst_ekpo_temp>-wrbtr = <lst_ekpo_temp>-menge * lv_wrbtr.

    ENDLOOP. " LOOP AT fp_li_ekpo_data ASSIGNING FIELD-SYMBOL(<lst_ekpo_temp>)

  ENDIF. " IF li_po_item IS NOT INITIAL

ENDFORM.
