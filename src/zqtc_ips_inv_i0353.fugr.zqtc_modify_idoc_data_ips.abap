FUNCTION zqtc_modify_idoc_data_ips.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EX_ERROR) TYPE  CHAR01
*"  CHANGING
*"     REFERENCE(CT_IDOC_DATA) TYPE  EDIDD_TT OPTIONAL
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_MODIFY_IDOC_DATA_IPS
* PROGRAM DESCRIPTION: Function module to distribute the Incoming PO Qty
*                      Amount into multiple PO line items and update the
*                      new segment to populate the same
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-26
* OBJECT ID:E095 (CR# ERP-6594)
* TRANSPORT NUMBER(S): ED2K912233
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*



*Local data declarations
  DATA : lst_idoc_data  TYPE edidd,   " Data record (IDoc)
         lst_e1edp02    TYPE e1edp02, " IDoc: Document Item Reference Data
         lst_e1edp26    TYPE e1edp26, " IDoc: Document Item Amount Segment
         lst_e1edp01    TYPE e1edp01, " IDoc: Document Item General Data
*         lst_e1eds01    TYPE e1eds01,    " IDoc: Summary segment general
         lv_po_no       TYPE ebeln_d,    " Purchasing Document
         lv_hl_ep01     TYPE edi_hlevel, " Hierarchy level
         lv_segnum      TYPE idocdsgnum, " Number of SAP segment
         lv_docnum      TYPE edi_docnum, " IDoc number
         li_ekpo_data   TYPE STANDARD TABLE OF ty_ekpo_data
                                INITIAL SIZE 0,
         lst_ekpo_data  TYPE ty_ekpo_data,
         lv_item_no     TYPE i,          " Item_no of type Integers
*         lv_wrbtr       TYPE wrbtr,      " Amount in Document Currency
         lv_wrbtr_idoc  TYPE wrbtr,      " Amount in Document Currency
         lv_tabix       TYPE sytabix,    " Row Index of Internal Tables
         lv_psgnum_ep01 TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
         li_idoc_data   TYPE edidd_tt,
         lv_uom         TYPE meins.      " Base Unit of Measure


*Local constant declarations
  CONSTANTS : lc_e1edp02 TYPE edilsegtyp VALUE 'E1EDP02', " Segment typet
              lc_e1edp26 TYPE edilsegtyp VALUE 'E1EDP26', " Segment type
              lc_e1edp01 TYPE edilsegtyp VALUE 'E1EDP01'. " Segment type




*Get the PO number from IDOC data
  READ TABLE ct_idoc_data INTO lst_idoc_data
                             WITH KEY segnam = lc_e1edp02.
  IF sy-subrc EQ 0.
    lst_e1edp02 = lst_idoc_data-sdata.
    lv_po_no = lst_e1edp02-belnr.
  ENDIF. " IF sy-subrc EQ 0

* Get the Invoice Amount received
  READ TABLE ct_idoc_data INTO lst_idoc_data
                            WITH KEY segnam = lc_e1edp26.
  IF sy-subrc EQ 0.

    lst_e1edp26 = lst_idoc_data-sdata.

    IF lst_e1edp26-qualf = '003'.

      lv_wrbtr_idoc = lst_e1edp26-betrg.

    ENDIF. " IF lst_e1edp26-qualf = '003'

  ENDIF. " IF sy-subrc EQ 0


  PERFORM f_calculate_po_qty USING ct_idoc_data
                                   lv_po_no
                                   lv_wrbtr_idoc
                             CHANGING li_ekpo_data
                                      ex_error.

  IF ex_error IS NOT INITIAL.

    RETURN.

  ENDIF. " IF ex_error IS NOT INITIAL


*Get the Last IDOC segment populated into IDOC data and get the segment information
  DESCRIBE TABLE ct_idoc_data LINES lv_tabix.
  READ TABLE ct_idoc_data INTO lst_idoc_data INDEX lv_tabix.
  IF sy-subrc EQ 0.

    lv_segnum = lst_idoc_data-segnum - 1.
    lv_docnum = lst_idoc_data-docnum.

  ENDIF. " IF sy-subrc EQ 0
** Modify the existing Line item details with value and

  LOOP AT li_ekpo_data INTO lst_ekpo_data.

    lv_item_no = lv_item_no + 1.

    IF lv_item_no EQ 1.

**modify the quntity
      CLEAR lst_e1edp01.
      READ TABLE ct_idoc_data INTO lst_idoc_data
                            WITH KEY segnam = lc_e1edp01.
      IF sy-subrc EQ 0.
        lv_hl_ep01 = lst_idoc_data-hlevel.

        lst_e1edp01 = lst_idoc_data-sdata.
        lst_e1edp01-posex = lv_item_no.
        MOVE lst_ekpo_data-menge TO lst_e1edp01-menge.
        CONDENSE lst_e1edp01-menge.
        lst_idoc_data-sdata = lst_e1edp01.
        MODIFY ct_idoc_data FROM lst_idoc_data INDEX sy-tabix.

      ENDIF. " IF sy-subrc EQ 0

*Modify the lien item and Po details
      CLEAR: lst_e1edp02,
             lst_idoc_data.
      READ TABLE ct_idoc_data INTO lst_idoc_data
                              WITH KEY segnam = lc_e1edp02.
      IF sy-subrc EQ 0.

        lst_e1edp02 = lst_idoc_data-sdata.
        lst_e1edp02-belnr = lst_ekpo_data-ebeln.
        lst_e1edp02-zeile = lst_ekpo_data-ebelp.
        lst_idoc_data-sdata = lst_e1edp02.
        MODIFY ct_idoc_data FROM lst_idoc_data INDEX sy-tabix.

      ENDIF. " IF sy-subrc EQ 0


**Modify the amount
      CLEAR : lst_e1edp26,
              lst_idoc_data.
      READ TABLE ct_idoc_data INTO lst_idoc_data
                              WITH KEY segnam = lc_e1edp26.
      IF sy-subrc EQ 0.

        lst_e1edp26 = lst_idoc_data-sdata.
        MOVE lst_ekpo_data-wrbtr TO lst_e1edp26-betrg.
        CONDENSE lst_e1edp26-betrg.
        lst_idoc_data-sdata = lst_e1edp26.
        MODIFY ct_idoc_data FROM lst_idoc_data INDEX sy-tabix.
      ENDIF. " IF sy-subrc EQ 0


    ELSE. " ELSE -> IF lv_item_no EQ 1

      CLEAR lst_e1edp01.
      lst_e1edp01-posex = lv_item_no.
      lst_e1edp01-menge = lst_ekpo_data-menge.
      lst_e1edp01-menee = lv_uom.

**add the additional PO lines into IDOC data.
      lv_segnum = lv_segnum + 1.
      lst_idoc_data-mandt = sy-mandt.
      lst_idoc_data-docnum = lv_docnum.
      lst_idoc_data-segnum = lv_segnum.
      lst_idoc_data-segnam = lc_e1edp01.
      lst_idoc_data-psgnum = '0'.
      lst_idoc_data-hlevel = lv_hl_ep01.
      lst_idoc_data-sdata = lst_e1edp01.
      APPEND lst_idoc_data TO li_idoc_data.

      lv_hl_ep01 = lv_hl_ep01 + 1.
      lv_psgnum_ep01 = lv_segnum.

**Populate E1EDP02 segment with PO and Line item no
      lst_e1edp02-qualf = '001'.
      lst_e1edp02-belnr = lst_ekpo_data-ebeln.
      lst_e1edp02-zeile = lst_ekpo_data-ebelp.

      lv_segnum = lv_segnum + 1.
      lst_idoc_data-mandt = sy-mandt.
      lst_idoc_data-docnum = lv_docnum.
      lst_idoc_data-segnum = lv_segnum.
      lst_idoc_data-segnam = lc_e1edp02.
      lst_idoc_data-psgnum = lv_psgnum_ep01.
      lst_idoc_data-hlevel = lv_hl_ep01.
      lst_idoc_data-sdata = lst_e1edp02.
      APPEND lst_idoc_data TO li_idoc_data.

**Populate the Amount for PO line item
      lst_e1edp26-qualf = '003'.
      MOVE lst_ekpo_data-wrbtr TO lst_e1edp26-betrg.
      CONDENSE lst_e1edp26-betrg.

      lv_segnum = lv_segnum + 1.
      lst_idoc_data-mandt = sy-mandt.
      lst_idoc_data-docnum = lv_docnum.
      lst_idoc_data-segnum = lv_segnum.
      lst_idoc_data-segnam = lc_e1edp26.
      lst_idoc_data-psgnum = lv_psgnum_ep01.
      lst_idoc_data-hlevel = lv_hl_ep01.
      lst_idoc_data-sdata = lst_e1edp26.
      APPEND lst_idoc_data TO li_idoc_data.

      lv_hl_ep01 = lv_hl_ep01 - 1.

    ENDIF. " IF lv_item_no EQ 1

  ENDLOOP. " LOOP AT li_ekpo_data INTO lst_ekpo_data


**modify the IDOC segment for last line item

  IF li_idoc_data IS NOT INITIAL AND lv_tabix IS NOT INITIAL.
    READ TABLE ct_idoc_data ASSIGNING FIELD-SYMBOL(<lst_idoc_data>)
                          INDEX lv_tabix.
    IF sy-subrc EQ 0
   AND <lst_idoc_data> IS ASSIGNED.

      <lst_idoc_data>-segnum = lv_segnum + 1.

    ENDIF. " IF sy-subrc EQ 0

    INSERT LINES OF li_idoc_data INTO ct_idoc_data
     INDEX lv_tabix.

  ENDIF. " IF li_idoc_data IS NOT INITIAL AND lv_tabix IS NOT INITIAL

ENDFUNCTION.
