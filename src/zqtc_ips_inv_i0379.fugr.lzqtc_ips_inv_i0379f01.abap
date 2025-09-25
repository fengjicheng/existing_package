*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_IPS_INV_I0353F01
* PROGRAM DESCRIPTION: Include program contains the Form routine for
*                      Function group
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE:   2020-03-01
* OBJECT ID:I0379 (ERPM-11517)
* TRANSPORT NUMBER(S): ED2K917673
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_ERROR_MSG
*&---------------------------------------------------------------------*
*       Populate the Error log Messages
*----------------------------------------------------------------------*
*      <--FP_EX_MESSAGE  text
*----------------------------------------------------------------------*
*FORM f_populate_error_msg  CHANGING fp_ex_message TYPE bapiretct.
*
*  DATA :  lst_message TYPE bapiretc. " Return Parameter for Complex Data Type
*
*  lst_message-type        = sy-msgty.
*  lst_message-id          = sy-msgid.
*  lst_message-number      = sy-msgno.
*  lst_message-message_v1  = sy-msgv1.
*  lst_message-message_v2  = sy-msgv2.
*  lst_message-message_v3  = sy-msgv3.
*  lst_message-message_v4  = sy-msgv4.
*  MESSAGE ID sy-msgid
*        TYPE sy-msgty
*      NUMBER sy-msgno
*        WITH sy-msgv1
*             sy-msgv2
*             sy-msgv3
*             sy-msgv4
*        INTO lst_message-message.
*
*  APPEND lst_message TO fp_ex_message.
*  CLEAR lst_message.
*
*ENDFORM.
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
                                  fp_li_e1edp01_data TYPE tt1_e1edp01_data
                         CHANGING fp_li_ekpo_data TYPE tt1_ekpo_data
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
            matnr TYPE matnr,   " Material number
          END OF lty_ekbe,
          BEGIN OF lty1_ekbe,
            ebeln TYPE ebeln,   " Purchasing Document Number
            ebelp TYPE ebelp,   " Item Number of Purchasing Document
            matnr TYPE matnr,   " Material number
            zekkn TYPE dzekkn,  " Sequential Number of Account Assignment
            vgabe TYPE vgabe,   " Transaction/event type, purchase order history
            gjahr TYPE gjahr,   " Fiscal Year
            belnr TYPE mblnr,   " Number of Material Document
            buzei TYPE mblpo,   " Item in Material Document
            menge TYPE menge_d, " Quantity
            wrbtr TYPE wrbtr,   " Amount in Document Currency
            shkzg TYPE shkzg,   " Debit/Credit Indicator
          END OF lty1_ekbe,

          BEGIN OF lty_po_item,
            ebeln TYPE ebeln,   " Purchasing Document Number
            ebelp TYPE ebelp,   " Item Number of Purchasing Document
            loekz TYPE eloek,   " Deletion Indicator in Purchasing Document
            matnr TYPE matnr,   " Materil Number
            menge TYPE bstmg,   " Purchase Order Quantity
            meins TYPE meins,   " Base Unit of Measure
            netwr TYPE bwert,    " Net Order Value in PO Currency
            uebto TYPE uebto,   " Overdelivery Tolerance Limit
            erekz TYPE erekz,   " Final Invoice Indicator
            banfn TYPE banfn,   " Purchase Requisition Number
          END OF lty_po_item.

*Local data declarations
  DATA : lst_idoc_data     TYPE edidd,   " Data record (IDoc)
         lst_e1edp01       TYPE e1edp01, " IDoc: Document Item General Data
         lst_e1edk01       TYPE e1edk01, " IDoc: Document header general data
         lst_e1edk14       TYPE e1edk14, " IDoc: Document for company code details
         lst_e1edka1       TYPE e1edka1, " IDoc: Document header general data
*         lst_e1edp04         TYPE e1edp04,                      " IDoc: Document Item Taxes
         li_ekbe_data      TYPE STANDARD TABLE OF lty_ekbe    " Transfer Structure for PO History
                              INITIAL SIZE 0,
         li_ekbe_mat       TYPE STANDARD TABLE OF lty1_ekbe    " Transfer Structure for PO History
                               INITIAL SIZE 0,
         li_open_ekpo      TYPE STANDARD TABLE OF ty_ekpo_data "
                                INITIAL SIZE 0,
         li_po_item        TYPE STANDARD TABLE OF lty_po_item " Transfer Structure: Display/List PO Item
                                 INITIAL SIZE 0,
         li_po_mat_rep     TYPE STANDARD TABLE OF lty_po_item " Transfer Structure: Display/List PO Item
                                 INITIAL SIZE 0,
         li_po_item_main   TYPE STANDARD TABLE OF lty_po_item " Transfer Structure: Display/List PO Item
                                 INITIAL SIZE 0,
         ls_ekbe_mat       TYPE lty1_ekbe,                    "Transfer Structure for PO History
         lst_ekbe_mat      TYPE lty1_ekbe,                    "Transfer Structure for PO History
         lst_ekbe_data     TYPE lty_ekbe,                     " Transfer Structure for PO History
         lst_open_ekpo     TYPE ty_ekpo_data,
         lst_ekpo_data     TYPE ty_ekpo_data,
         lst_ekbe_temp     TYPE lty_ekbe,                     " Transfer Structure for PO History
         lst_ekbe_temp_mat TYPE lty1_ekbe,                     " Transfer Structure for PO History
         lst_po_item       TYPE lty_po_item,                  " Transfer Structure: Display/List PO Item
         lv_menge          TYPE menge_d,                      " Quantity
         lv_menge_po       TYPE menge_d,                      " Quantity
         lv_netwr_po(16)   TYPE p DECIMALS 5,                 " Amount in Document Currency
         lv_netwr_tol(16)  TYPE p DECIMALS 5,                 " Amount in Document Currency
         lv_menge_inv      TYPE menge_d,                      " Quantity
         lv_uom            TYPE meins,                        " Base Unit of Measure
         lv_inv_qty        TYPE menge_d,                      " Quantity
         lv_wrbtr(16)      TYPE p DECIMALS 5,                 " Amount in Document Currency
         lv_bsart          TYPE bsart,                        " document Type
         lv_bukrs          TYPE bukrs,                         " Company code
         lv_message        TYPE char100.                      " Message of type CHAR100
*Local constant declarations
  CONSTANTS : lc_e1edp01    TYPE edilsegtyp VALUE 'E1EDP01', " Segment type
              lc_e1edka1    TYPE edilsegtyp VALUE 'E1EDKA1', " Segment type
              lc_e1edk01    TYPE edilsegtyp VALUE 'E1EDK01', " Segment type
              lc_e1edk14    TYPE edilsegtyp VALUE 'E1EDK14', " Segment type
              lc_qual       TYPE edi_qualfo VALUE '011',     " qualifer organization
              lc_shkzg_s    TYPE shkzg      VALUE 'S',       " Debit/Credit Indicator
              lc_cr_memo    TYPE bsart      VALUE 'CRME',    " Order Type (Purchasing)
              lc_invoice    TYPE bsart      VALUE 'INVO',    " Order Type (Purchasing)
              lc_parvw      TYPE parvw      VALUE 'LF',      " Partner function
              lc_l          TYPE char1      VALUE 'L',       " Deleted
              lc_s          TYPE char1      VALUE 'S',       " Blocked
              lc_tolkey_dq  TYPE tolsl      VALUE 'DQ',      " Tolerance key
              lc_tolkey_pp  TYPE tolsl      VALUE 'PP',      " Tolerance key
              lc_vgabe_gr   TYPE vgabe      VALUE '1',       " Transaction/event type,Goods receipt
              lc_vgabe_post TYPE vgabe      VALUE '2'.       " Transaction/event type, purchase order history

  CLEAR:ls_ekbe_mat,
           lst_ekbe_mat,
           lst_ekbe_data,
           lst_open_ekpo,
           lst_ekpo_data,
           lst_ekbe_temp,
           lst_ekbe_temp_mat,
           lst_po_item,
           lv_menge,
           lv_menge_po,
           lv_netwr_po,
           lv_netwr_tol,
           lv_menge_inv,
           lv_uom,
           lv_inv_qty,
           lv_wrbtr,
           lv_bsart,
           lv_bukrs,
           lv_message,
           lst_idoc_data,
           lst_e1edp01,
           lst_e1edk01,
           lst_e1edk14,
           lst_e1edka1.
  REFRESH: li_ekbe_data,li_ekbe_mat,
           li_open_ekpo,li_po_item,
           li_po_mat_rep,li_po_item_main.
  "lv_tot_open_qty_tol.

**check the PO exist or not
  SELECT SINGLE lifnr,waers " Currency Key
     FROM ekko        " Purchasing Document Header
     INTO @DATA(ls_ekko)
     WHERE ebeln = @fp_lv_po_no.
  IF sy-subrc EQ 0.
**Get the IDOc ccurrency from E1EDK01 Segment and compare with PO currency
** if not matching then raise the error message
    READ TABLE fp_ct_idoc_data INTO lst_idoc_data
                                  WITH KEY segnam = lc_e1edk01.
    IF sy-subrc EQ 0.
      lst_e1edk01 = lst_idoc_data-sdata.
      lv_bsart = lst_e1edk01-bsart.
**If document type is empty consider as Invoice.
      IF lv_bsart EQ space.
        lv_bsart = lc_invoice.
      ENDIF.
      IF ls_ekko-waers NE lst_e1edk01-curcy.
* Currency Not same as PO currency
        fp_ex_error = abap_true.
        MESSAGE e504(zqtc_r2) INTO lv_message. " Invoice Currency is not same as PO currency
        RETURN.
      ENDIF. " IF ls_ekko-waers NE lst_e1edk01-curcy
    ENDIF. " IF sy-subrc EQ 0
** Get the IDOC Vendor Invoice party from E1EDKA1 Segment and compare with PO Vendor
** If not matching the raise the error message.
    READ TABLE fp_ct_idoc_data INTO lst_idoc_data
                                  WITH KEY segnam = lc_e1edka1.
    IF sy-subrc EQ 0.
      lst_e1edka1 = lst_idoc_data-sdata.
      IF ls_ekko-lifnr NE lst_e1edka1-partn AND lst_e1edka1-parvw = lc_parvw.
* Vendor Not same as PO Vendor
        fp_ex_error = abap_true.
        MESSAGE e033(zptp_r1) WITH lst_e1edka1-partn ls_ekko-lifnr. " Vendor invoice party is different from the Purchase order Invoice party
        RETURN.
      ENDIF. " IF ls_ekko-waers NE lst_e1edk01-curcy
    ENDIF. " IF sy-subrc EQ 0
  ELSE. " ELSE -> IF sy-subrc EQ 0
*    *   purchase Order number does not exist in ekko table
    fp_ex_error = abap_true.
    MESSAGE e031(zptp_r1) WITH fp_lv_po_no.
    RETURN.
  ENDIF. " IF sy-subrc EQ 0
* Read the material number/old material number (MATNR/BISMT) from
* MARA table based on the IDOC (E1EDP01-MATNR)
  SELECT matnr,bismt
    FROM mara INTO
    TABLE @DATA(lt_mara)
    FOR ALL ENTRIES IN @fp_li_e1edp01_data
    WHERE matnr = @fp_li_e1edp01_data-matnr_idoc
       OR bismt = @fp_li_e1edp01_data-matnr_idoc.
  IF lt_mara[] IS NOT INITIAL AND sy-subrc = 0.
****************End logic***********
** Delclare the temporary internal table for adding new material and old material
** Beased on ekpo table
    DATA(lt_mara_temp) = lt_mara.
    REFRESH:lt_mara_temp[].
**select PO details frm EKPO table
    SELECT ebeln " Purchasing Document Number
           ebelp " Item Number of Purchasing Document
           loekz " Deletion Indicator in Purchasing Document
           matnr " Material Number
           menge " Purchase Order Quantity
           meins " Purchase Order Unit of Measure
           netwr " Purchase item amount
           uebto " Overdelivery Tolerance Limit
           erekz " Final Invoice Indicator
           banfn " Purchase Requisition Number
     FROM ekpo   " Purchasing Document Item
      INTO TABLE li_po_item
      FOR ALL ENTRIES IN lt_mara
      WHERE ebeln = fp_lv_po_no
         AND matnr EQ lt_mara-matnr. "AND loekz EQ space
    IF sy-subrc EQ 0.
      SORT li_po_item BY erekz.
** Check Transaction type, if Invoice then remove the PO line item
**where final invoice indicator set.
      IF lv_bsart EQ lc_invoice.
        DELETE li_po_item WHERE erekz IS NOT INITIAL .
      ENDIF. " IF lv_bsart EQ lc_invoice
** •  Purchase Order line item has been deleted or blocked,
      READ TABLE li_po_item INTO lst_po_item WITH KEY loekz = lc_l." PO line item deleted
      IF sy-subrc = 0.
*      Purchase Order line item has been deleted
        fp_ex_error = abap_true.
        MESSAGE e032(zptp_r1) WITH lst_po_item-ebelp.
        RETURN.
      ENDIF.
      READ TABLE li_po_item INTO lst_po_item WITH KEY loekz = lc_s." PO line item Blocked
      IF sy-subrc = 0.
*      Purchase Order line item has been blocked
        fp_ex_error = abap_true.
        MESSAGE e035(zptp_r1) WITH lst_po_item-ebelp.
        RETURN.
      ENDIF.
      DELETE li_po_item WHERE loekz NE space.
**Valdiation to check Repeated Material number  exist in IDOC
** IF exist throwing error message
      LOOP AT lt_mara INTO DATA(ls_mara).
        READ TABLE fp_li_e1edp01_data INTO DATA(ls1_e1edp01_data)
        WITH KEY  matnr_idoc = ls_mara-matnr.
        IF sy-subrc NE 0.
          READ TABLE fp_li_e1edp01_data INTO ls1_e1edp01_data
          WITH KEY  matnr_idoc = ls_mara-bismt.
          IF sy-subrc = 0.
            "Nothing to do
          ENDIF.
        ENDIF.
        IF ls1_e1edp01_data IS NOT INITIAL..
* There will not be a repetition of material in idoc,if there is a repetition is there, program shall fail the IDOC
          DATA(fp1_li_e1edp01_data) = fp_li_e1edp01_data[].
          DELETE fp1_li_e1edp01_data WHERE matnr_idoc NE ls1_e1edp01_data-matnr_idoc.
          DESCRIBE TABLE fp1_li_e1edp01_data LINES DATA(lv_coun_mat).
*      if lv_coun_mat more than 2 times, same material exist for multiple items in segment
          IF lv_coun_mat GE 2.
            fp_ex_error = abap_true.
            MESSAGE e034(zptp_r1) WITH ls1_e1edp01_data-matnr_idoc.
            RETURN.
          ENDIF.
          CLEAR:lv_coun_mat.
* There will not be a repetition of material in po,if there is a repetition is there, program shall fail the IDOC
          DATA(li_po_item_dup) = li_po_item[].
          DELETE li_po_item_dup WHERE matnr NE ls_mara-matnr.
          DESCRIBE TABLE li_po_item_dup LINES lv_coun_mat.
          IF lv_coun_mat GE 2." if lv_coun_mat more than 2 times, same material exist for multiple items in segment
            fp_ex_error = abap_true.
            MESSAGE e045(zptp_r1) WITH ls1_e1edp01_data-matnr_idoc.
            RETURN.
          ENDIF.
*****read for adding old material no and new material number into one internal table
          READ TABLE li_po_item INTO lst_po_item WITH KEY matnr = ls_mara-matnr.
          IF sy-subrc = 0.
            APPEND ls_mara TO lt_mara_temp.
          ENDIF.
        ENDIF.
        CLEAR:lv_coun_mat,ls1_e1edp01_data,ls_mara,lst_po_item.
      ENDLOOP.

      lt_mara[] = lt_mara_temp[].
**** Logic to read the Tolerance based on the company code and Tolerance keys (DQ AND PP).
      READ TABLE fp_ct_idoc_data INTO lst_idoc_data
                                WITH KEY segnam = lc_e1edk14.
      IF sy-subrc EQ 0.
        lst_e1edk14 = lst_idoc_data-sdata.
        lv_bukrs = lst_e1edk14-orgid.
        IF lv_bukrs IS NOT INITIAL AND lst_e1edk14-qualf = lc_qual.
          SELECT bukrs,tolsl,proz2 FROM t169g
            INTO TABLE @DATA(lt_t169g_dq)
            WHERE bukrs = @lv_bukrs AND
            ( tolsl = @lc_tolkey_dq OR
            tolsl = @lc_tolkey_pp ).
          IF sy-subrc = 0.
            READ TABLE lt_t169g_dq INTO DATA(ls_t169g_dq) WITH KEY tolsl = lc_tolkey_dq.
            IF sy-subrc = 0.
              "Nothing to do
            ENDIF.
            READ TABLE lt_t169g_dq INTO DATA(ls_t169g_pp) WITH KEY tolsl = lc_tolkey_pp.
            IF sy-subrc = 0.
              "Nothing to do
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF."IF sy-subrc EQ 0.
    ENDIF. " IF sy-subrc EQ 0
    IF li_po_item IS NOT INITIAL.
      SORT li_po_item BY ebeln ebelp matnr.
      li_po_mat_rep[] = li_po_item[].
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
                matnr " Materil number
          FROM  ekbe  " History per Purchasing Document
          INTO TABLE li_ekbe_data
          FOR ALL ENTRIES IN li_po_item
          WHERE ebeln EQ li_po_item-ebeln
            AND ebelp EQ li_po_item-ebelp
*            AND vgabe EQ lc_vgabe_post
            AND matnr EQ li_po_item-matnr.
      IF sy-subrc EQ 0.
        SORT li_ekbe_data BY ebeln ebelp.
        DATA(li_ekbe_data_gr) = li_ekbe_data[].
***** Delete the items other than goods receipt item.
        DELETE li_ekbe_data_gr WHERE vgabe NE lc_vgabe_gr.
**** Delete the items other than invoice receipt to get the open qty.
        DELETE li_ekbe_data WHERE vgabe NE lc_vgabe_post.
        LOOP AT li_ekbe_data INTO lst_ekbe_data.
*Calculate the Total Open Quantity for Invoice,credit memo
          IF lst_ekbe_data-shkzg = lc_shkzg_s.
            lv_inv_qty = lst_ekbe_data-menge + lv_inv_qty.
            lv_netwr_po = lst_ekbe_data-wrbtr + lv_netwr_po.
          ELSE. " ELSE -> IF ls_ekbe_mat-shkzg = lc_shkzg_s
            lv_inv_qty = lv_inv_qty - lst_ekbe_data-menge.
            lv_netwr_po = lv_netwr_po - lst_ekbe_data-wrbtr.
          ENDIF. " IF ls_ekbe_mat-shkzg = lc_shkzg_s
          lst_ekbe_temp = lst_ekbe_data.
          AT END OF ebelp.
            lst_ekbe_data = lst_ekbe_temp.
            IF lv_bsart EQ lc_cr_memo.
              lst_open_ekpo-menge = lv_inv_qty.
              lst_open_ekpo-wrbtr = lv_netwr_po.
            ELSEIF lv_bsart EQ lc_invoice.

              READ TABLE li_po_item INTO lst_po_item
                                WITH KEY ebeln  = lst_ekbe_data-ebeln
                                         ebelp = lst_ekbe_data-ebelp
                                         matnr = lst_ekbe_data-matnr
                                BINARY SEARCH.
              IF sy-subrc EQ 0.
                lst_open_ekpo-menge = lst_po_item-menge - lv_inv_qty.
                lst_open_ekpo-wrbtr = lst_po_item-netwr - lv_netwr_po.
              ENDIF. " IF sy-subrc EQ 0
            ENDIF. " IF lv_bsart EQ lc_cr_memo
            lst_open_ekpo-ebeln = lst_ekbe_data-ebeln.
            lst_open_ekpo-ebelp = lst_ekbe_data-ebelp.
            lst_open_ekpo-matnr = lst_ekbe_data-matnr.
            APPEND lst_open_ekpo TO li_open_ekpo.
            CLEAR : lv_inv_qty,lst_open_ekpo,lv_netwr_po.
          ENDAT.
        ENDLOOP. " loop at li_ekbe_mat INTO ls_ekbe_mat.
      ENDIF. " IF sy-subrc EQ 0
*** Logic to calculate the open Quantity
      IF li_open_ekpo[] IS NOT INITIAL.
        SORT li_open_ekpo BY ebeln ebelp matnr.
      ENDIF.
      LOOP AT fp_li_e1edp01_data INTO DATA(ls_e1edp01_data).
        CLEAR:lst_po_item,ls_mara,lv_wrbtr,
             lst_ekpo_data,lst_open_ekpo,
             lv_menge,lv_menge_po,lv_netwr_tol,lv_netwr_po.
        lv_menge = ls_e1edp01_data-menge_idoc.       "invoice Receipt quantity
*** checking material number/old material number (MATNR/BISMT) from the IDOC (E1EDP01-MATNR)
** and Read the PO item values.
        READ TABLE li_po_item INTO lst_po_item
          WITH KEY matnr = ls_e1edp01_data-matnr_idoc.
        IF sy-subrc NE 0.
** If no new material exist check the old material number using below read statement,
          READ TABLE lt_mara INTO ls_mara
              WITH KEY bismt = ls_e1edp01_data-matnr_idoc.
          IF sy-subrc = 0.
** If record exist with old material and get the po details from the below internal table
** by passing new material number.
            READ TABLE li_po_item INTO lst_po_item
            WITH KEY matnr = ls_mara-matnr.
            IF sy-subrc = 0.
              "Nothing to do
            ENDIF.
          ENDIF.
        ENDIF.
        CASE lv_bsart.
          WHEN lc_invoice.
            IF lst_po_item IS NOT INITIAL.
              CLEAR : lst_open_ekpo.
              lst_ekpo_data-menge = lv_menge.
              lst_ekpo_data-bismt = ls_mara-bismt.
              lst_ekpo_data-ebeln = lst_po_item-ebeln.
              lst_ekpo_data-ebelp = lst_po_item-ebelp.
              lst_ekpo_data-banfn = lst_po_item-banfn.
              lst_ekpo_data-matnr = lst_po_item-matnr.
              READ TABLE li_open_ekpo INTO lst_open_ekpo
                                WITH KEY ebeln = lst_po_item-ebeln
                                         ebelp = lst_po_item-ebelp
                                         matnr = lst_po_item-matnr BINARY SEARCH.
              IF sy-subrc EQ 0.
                IF lst_open_ekpo-menge IS NOT INITIAL.
*If the invoice Receipt quantity is more than Purchase Order line item quantity
*** 5.1.3  Quantity Calculation in case of Excess Invoice receipt
                  IF lst_open_ekpo-menge LT lv_menge.
                    IF ls_t169g_dq-proz2 IS NOT INITIAL. "Tolerance amount
                      lst_ekpo_data-tol_menge = lst_po_item-menge * ( ls_t169g_dq-proz2 / 100 ).
                      lv_menge_po = lst_open_ekpo-menge + lst_ekpo_data-tol_menge.
*•  Purchase Order Quantity  + over delivery tolerance less than Invoice quantity from quantity
                      IF lv_menge_po LT lv_menge.
                        fp_ex_error = abap_true.
                        MESSAGE e041(zptp_r1) WITH lst_po_item-matnr. "Invoice Quantity is more than Open PO quantity with tolarane.
                        RETURN.
                      ENDIF. " IF lv_tot_open_qty_tol LT lv_menge
                    ENDIF. " IF lst_po_item-uebto IS NOT INITIAL
                  ELSE. " ELSE -> IF lst_open_ekpo-menge LE lv_menge
*5.1.2  Quantity Calculation in case of Partial Invoice receipt
                  ENDIF. " IF lst_open_ekpo-menge LE lv_menge
*5.1.4 If the invoice amount is allowed to be higher up to 5% of PO total item amount,
                  IF lst_open_ekpo-wrbtr LT ls_e1edp01_data-wrbtr_idoc.
                    IF ls_t169g_pp-proz2 IS NOT INITIAL. "Tolerance amount
                      lv_netwr_tol = lst_po_item-netwr * ( ls_t169g_pp-proz2 / 100 ). "5 % po total amount
                      lv_netwr_po = lst_open_ekpo-wrbtr + lv_netwr_tol.
                      IF lv_netwr_po LT ls_e1edp01_data-wrbtr_idoc.
                        fp_ex_error = abap_true.
                        MESSAGE e044(zptp_r1) WITH lst_po_item-matnr. "Invoice amount is greater than PO/GR amount”
                        RETURN.
                      ENDIF.
                    ENDIF.
                  ENDIF.
                  APPEND lst_ekpo_data TO fp_li_ekpo_data.
                ENDIF. " IF lst_open_ekpo-menge IS NOT INITIAL
              ELSE. " ELSE -> IF sy-subrc EQ 0
**5.1.1. If the Goods receipt is not done then the IDOC must fail.
                READ TABLE li_ekbe_data_gr INTO DATA(ls_ekbe_gr)
                                 WITH KEY ebeln = lst_po_item-ebeln
                                         ebelp = lst_po_item-ebelp
                                         matnr = lst_po_item-matnr.
                IF sy-subrc NE 0.
                  fp_ex_error = abap_true.
                  MESSAGE e046(zptp_r1) WITH lst_po_item-matnr.
                  RETURN.
                ENDIF.
*If the invoice Receipt quantity is less than Purchase Order line item quantity,
*the corresponding line item amount will be assumed to represent the value for partial quantity
                IF lst_po_item-menge LT lv_menge.
                  IF ls_t169g_dq-proz2 IS NOT INITIAL. "Tolerance QTY
                    lst_ekpo_data-tol_menge = lst_po_item-menge * ( ls_t169g_dq-proz2 / 100 ).
                    lv_menge_po = lst_po_item-menge + lst_ekpo_data-tol_menge.
*•  Purchase Order Quantity  + over delivery tolerance less than Invoice quantity from quantity
                    IF lv_menge_po LT lv_menge.
                      fp_ex_error = abap_true.
                      MESSAGE e041(zptp_r1) WITH lst_po_item-matnr. "Invoice Quantity is more than Open PO quantity with tolarane.
                      RETURN.
                    ENDIF. " IF lv_tot_open_qty_tol LT lv_menge
                  ENDIF.
                ENDIF.
**5.1.4  If the invoice amount is allowed to be higher up to 5% of PO total item amount,
                IF lst_po_item-netwr LT ls_e1edp01_data-wrbtr_idoc.
                  IF ls_t169g_pp-proz2 IS NOT INITIAL. "Tolerance amount
                    lv_netwr_tol = lst_po_item-netwr * ( ls_t169g_pp-proz2 / 100 ).
                    lv_netwr_po = lst_po_item-netwr + lv_netwr_tol.
                    IF lv_netwr_po LT ls_e1edp01_data-wrbtr_idoc.
                      fp_ex_error = abap_true.
                      MESSAGE e044(zptp_r1) WITH lst_po_item-matnr. "Invoice amount is greater than PO/GR amount idoc should fail with error”
                      RETURN.
                    ENDIF.
                  ENDIF.
                ENDIF.

                APPEND lst_ekpo_data TO fp_li_ekpo_data.
              ENDIF. " IF sy-subrc EQ 0
            ELSE.
*** If multible materials are coming from idoc,one material exist and another one
** Does not exist in EKPO table and throwing error message
              fp_ex_error = abap_true.
              MESSAGE e042(zptp_r1) WITH ls1_e1edp01_data-matnr_idoc fp_lv_po_no.
              RETURN.
            ENDIF.
**Credit memo Request Quantity distribution logic.
          WHEN lc_cr_memo."
            IF lst_po_item IS NOT INITIAL.
              CLEAR : lst_open_ekpo.
              READ TABLE li_open_ekpo INTO lst_open_ekpo
                                WITH KEY ebeln = lst_po_item-ebeln
                                         ebelp = lst_po_item-ebelp
                                         matnr = lst_po_item-matnr BINARY SEARCH.
              IF sy-subrc = 0.
                IF lst_open_ekpo-menge IS NOT INITIAL.
                  IF lst_open_ekpo-menge LT lv_menge.
                    fp_ex_error = abap_true.
                    MESSAGE e041(zptp_r1) WITH lst_po_item-matnr. "Invoice Quantity is more than Open PO quantity with tolarane.
                    RETURN.
                  ENDIF. " IF lv_tot_open_qty_tol LT lv_menge
** 5.1.4 Invoice amount is greater than PO/GR amount idoc should fail with error”
                  IF lst_open_ekpo-wrbtr LT ls_e1edp01_data-wrbtr_idoc.
                    fp_ex_error = abap_true.
                    MESSAGE e044(zptp_r1) WITH lst_po_item-matnr. "Invoice amount is greater than PO/GR amount”
                    RETURN.
                  ENDIF.
                  lst_ekpo_data-menge = lv_menge.
                  lst_ekpo_data-bismt = ls_mara-bismt.
                  lst_ekpo_data-ebeln = lst_open_ekpo-ebeln.
                  lst_ekpo_data-ebelp = lst_open_ekpo-ebelp.
                  lst_ekpo_data-matnr = lst_open_ekpo-matnr.
                  APPEND lst_ekpo_data TO fp_li_ekpo_data.
                ENDIF. " IF lst_open_ekpo-menge IS NOT INITIAL
              ELSE.
                fp_ex_error = abap_true.
                MESSAGE e043(zptp_r1) WITH ls_e1edp01_data-matnr_idoc.
                RETURN.
              ENDIF.
            ELSE.
*** If multible materials are coming from idoc,one material exist and another one
** Does not exist in EKPO table and throwing error message
              fp_ex_error = abap_true.
              MESSAGE e042(zptp_r1) WITH ls1_e1edp01_data-matnr_idoc fp_lv_po_no.
              RETURN.
            ENDIF.
          WHEN OTHERS.
            "Nothing to do
        ENDCASE.
      ENDLOOP.
    ELSE.
      fp_ex_error = abap_true.
      MESSAGE e037(zptp_r1) WITH fp_lv_po_no.
      RETURN.
    ENDIF. " IF li_po_item IS NOT INITIAL
  ELSE.
    fp_ex_error = abap_true.
    MESSAGE e040(zptp_r1).
    RETURN.
  ENDIF."IF lt_mara[] IS NOT INITIAL.
ENDFORM.
