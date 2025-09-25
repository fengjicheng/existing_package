FUNCTION zqtc_modi_idoc_data_ips_i0379.
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
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE:   2020-03-01
* OBJECT ID:I0379 (ERPM-11517)
* TRANSPORT NUMBER(S): ED2K917673
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
  DATA : lst_idoc_data    TYPE edidd,   " Data record (IDoc)
         lst_e1edp02      TYPE e1edp02, " IDoc: Document Item Reference Data
         lst_e1edp26      TYPE e1edp26, " IDoc: Document Item Amount Segment
         lst_e1edp01      TYPE e1edp01, " IDoc: Document Item General Data
         lv_po_no         TYPE ebeln_d,    " Purchasing Document
         lv_hl_ep01       TYPE edi_hlevel, " Hierarchy level
         li_ekpo_data     TYPE STANDARD TABLE OF ty_ekpo_data
                                INITIAL SIZE 0,
         lst_ekpo_data    TYPE ty_ekpo_data,
         li_e1edp01_data  TYPE STANDARD TABLE OF ty_e1edp01_data,
         lst_e1edp01_data TYPE ty_e1edp01_data,
         lv_item_no       TYPE i,          " Item_no of type Integers
         li_idoc_data     TYPE edidd_tt,
         li1_const_data   TYPE STANDARD TABLE OF lty1_constant INITIAL SIZE 0,
         lst1_const_data  TYPE lty1_constant,
         lv_message       TYPE char100.

*Local constant declarations
  CONSTANTS : lc_e1edp02      TYPE edilsegtyp VALUE 'E1EDP02', " Segment typet
              lc_e1edp26      TYPE edilsegtyp VALUE 'E1EDP26', " Segment type
              lc_e1eds01      TYPE edilsegtyp VALUE 'E1EDS01',        " Segment type
              lc1_devid_i0379 TYPE zdevid VALUE 'I0379',       " Development ID
              lc_qual         TYPE qualibetrg VALUE '003',     " Qualifier
              lc1_ebeln       TYPE  rvari_vnam VALUE 'EBELN',  " ABAP: Name of Variant Variable
              lc_e1edp01      TYPE edilsegtyp VALUE 'E1EDP01'. " Segment type

  CLEAR:lst_idoc_data,lst_e1edp02,lst_e1edp26,lst_e1edp01,lv_po_no,
  lst_ekpo_data,lst_e1edp01_data,lv_item_no,lst1_const_data,lv_message.

  REFRESH:li_e1edp01_data,li_ekpo_data,li_idoc_data,li1_const_data.
*Get the PO number from IDOC data
* this loop is used to prepare one common IT table with fields
* Material number,po,Quantity and segment numbers.
  LOOP AT ct_idoc_data INTO lst_idoc_data WHERE segnam = lc_e1edp01.
    lst_e1edp01 = lst_idoc_data-sdata.
    lst_e1edp01_data-segp01 = lst_idoc_data-segnum.
* Get the po number from the segement lc_e1edp02
    READ TABLE ct_idoc_data INTO DATA(lst_child_seg) WITH KEY
    segnam = lc_e1edp02
    psgnum = lst_idoc_data-segnum.
    IF sy-subrc = 0.
      lst_e1edp02 = lst_child_seg-sdata.
      lst_e1edp01_data-segp02 = lst_child_seg-segnum.
      IF lv_po_no IS INITIAL.
        lv_po_no = lst_e1edp02-belnr.
      ENDIF.
    ENDIF.
    CLEAR:lst_child_seg.
* Get the Invoice Amount received
    READ TABLE ct_idoc_data INTO lst_child_seg WITH KEY
      segnam = lc_e1edp26
      psgnum = lst_idoc_data-segnum.
    IF sy-subrc = 0.
      lst_e1edp26 = lst_child_seg-sdata.
      IF lst_e1edp26-qualf = lc_qual.
        lst_e1edp01_data-wrbtr_idoc = lst_e1edp26-betrg.
        lst_e1edp01_data-segp26 = lst_child_seg-segnum.
      ENDIF. " IF lst_e1edp26-qualf = '003'
    ENDIF.
** Get the Quantity
    lst_e1edp01_data-menge_idoc = lst_e1edp01-menge.
** Get the Base Unit of Measure
    lst_e1edp01_data-uom_idoc = lst_e1edp01-menee.
    lst_e1edp01_data-matnr_idoc = lst_e1edp01-matnr.
    IF lst_e1edp01_data-matnr_idoc IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input  = lst_e1edp01_data-matnr_idoc
        IMPORTING
          output = lst_e1edp01_data-matnr_idoc.
      lst_e1edp01_data-ebeln_idoc = lv_po_no.
      APPEND lst_e1edp01_data TO li_e1edp01_data.
      CLEAR:lst_e1edp01_data,lst_e1edp01.
    ENDIF.
  ENDLOOP.

* If the purchase Order number does not exist or Blank
  IF lv_po_no IS INITIAL.
*   purchase Order number Blank
    ex_error = abap_true.
    MESSAGE e030(zptp_r1) INTO lv_message.
    RETURN.
  ELSE.
* Get data from constant table
    SELECT devid                   "Development ID
           param1                  "ABAP: Name of Variant Variable
           param2                  "ABAP: Name of Variant Variable
           srno                    "Current selection number
           sign                    "ABAP: ID: I/E (include/exclude values)
           opti                    "ABAP: Selection option (EQ/BT/CP/...)
           low                     "Lower Value of Selection Condition
           high                    "Upper Value of Selection Condition
           activate                "Activation indicator for constant
       FROM zcaconstant            " Wiley Application Constant Table
       INTO TABLE li1_const_data
       WHERE devid    = lc1_devid_i0379
       AND   activate = abap_true. "Only active record
    IF sy-subrc = 0.
*    Check WLS PO number will be unique number range start
      READ TABLE li1_const_data INTO lst1_const_data
                            WITH KEY param1 = lc1_ebeln param2 = space.

      IF sy-subrc EQ 0 AND lv_po_no BETWEEN lst1_const_data-low AND lst1_const_data-high.
        "Nothing to do
      ELSE.
** WLS PO number will be unique number range start with 7200000000
        ex_error = abap_true.
        MESSAGE e036(zptp_r1) WITH lst1_const_data-low.
        RETURN.
      ENDIF.
    ENDIF.
    IF li_e1edp01_data IS NOT INITIAL.
      PERFORM f_calculate_po_qty USING ct_idoc_data
                                       lv_po_no
                                       li_e1edp01_data
                                 CHANGING li_ekpo_data
                                          ex_error.

      IF ex_error IS NOT INITIAL.
        RETURN.
      ENDIF. " IF ex_error IS NOT INITIAL
** Modify the existing Line item details with value and
      LOOP AT li_e1edp01_data INTO lst_e1edp01_data.
*** checking material number/old material number (MATNR/BISMT) from the IDOC (E1EDP01-MATNR)
        READ TABLE li_ekpo_data INTO lst_ekpo_data
          WITH KEY matnr = lst_e1edp01_data-matnr_idoc.
        IF sy-subrc NE 0.
          READ TABLE li_ekpo_data INTO lst_ekpo_data
              WITH KEY bismt = lst_e1edp01_data-matnr_idoc.
          IF sy-subrc = 0.
            "Nothing to do
          ENDIF.
        ENDIF.
        IF lst_ekpo_data IS NOT INITIAL.
          lv_item_no = lv_item_no + 1.
**modify the line item quntity in the segment lc_e1edp01
          CLEAR lst_e1edp01.
          READ TABLE ct_idoc_data INTO lst_idoc_data
                                WITH KEY segnum = lst_e1edp01_data-segp01 segnam = lc_e1edp01.
          IF sy-subrc EQ 0.
            DATA(lv_tabix1) = sy-tabix.
            lv_hl_ep01 = lst_idoc_data-hlevel.
            lst_e1edp01 = lst_idoc_data-sdata.
            lst_e1edp01-posex = lv_item_no.
            MOVE lst_ekpo_data-menge TO lst_e1edp01-menge.
            CONDENSE lst_e1edp01-menge.
            lst_idoc_data-sdata = lst_e1edp01.
            MODIFY ct_idoc_data FROM lst_idoc_data INDEX lv_tabix1.
          ENDIF. " IF sy-subrc EQ 0
*Modify the lien item and Po details in the segment e1edp02
          CLEAR: lst_e1edp02,lst_idoc_data.
          READ TABLE ct_idoc_data INTO lst_idoc_data
                                  WITH KEY segnum = lst_e1edp01_data-segp02 segnam = lc_e1edp02.
          IF sy-subrc EQ 0.
            lv_tabix1 = sy-tabix.
            lst_e1edp02 = lst_idoc_data-sdata.
            lst_e1edp02-belnr = lst_ekpo_data-ebeln.
            lst_e1edp02-zeile = lst_ekpo_data-ebelp.
            lst_idoc_data-sdata = lst_e1edp02.
            MODIFY ct_idoc_data FROM lst_idoc_data INDEX lv_tabix1.
          ENDIF. " IF sy-subrc EQ 0
**Modify the amount with tolarance
        ENDIF."li_ekpo_data INTO lst_ekpo_data
        CLEAR: lst_ekpo_data,lst_e1edp01_data, lst_e1edp26,lst_idoc_data.
      ENDLOOP.
    ENDIF."li_e1edp01_data IS NOT INITIAL.
  ENDIF."IF lv_po_no IS INITIAL.
ENDFUNCTION.
