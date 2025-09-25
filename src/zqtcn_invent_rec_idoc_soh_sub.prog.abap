*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_INVENT_RECON_SOH_SUB
* PROGRAM DESCRIPTION: Inventory Reconcilliation subroutines include
* DEVELOPER: Monalisa Dutta
* CREATION DATE:   2017-04-03
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED1K909620
* REFERENCE NO: RITM0079465
* DEVELOPER: Rajasekhar.T (RBTIRUMALA)
* DATE:  2019-02-15
* DESCRIPTION: To delete the duplicate data from the Report output
*-------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INVENT_RECON_SOH_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_DATA
*&---------------------------------------------------------------------*
*       Validate selection screen paramters
*----------------------------------------------------------------------*
FORM f_validate_data USING fp_adjtyp TYPE zadjtyp.
  SELECT zadjtyp
    FROM zqtc_inven_recon
    INTO @DATA(lv_zadjtyp)
    UP TO 1 ROWS
    WHERE zadjtyp = @fp_adjtyp.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e169(zqtc_r2) WITH lv_zadjtyp. "Adjustment type & not found
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_VARIABLES
*&---------------------------------------------------------------------*
*       Clear all the variables
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_variables .

  CLEAR : i_inven_recon[].

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ZQTC_INVEN_RECON
*&---------------------------------------------------------------------*
*  Get data from ZQTC_INVEN_RECON table
*----------------------------------------------------------------------*
*  <-- fp_i_inven_recon
*----------------------------------------------------------------------*
FORM f_get_zqtc_inven_recon CHANGING fp_i_inven_recon TYPE tt_inven_recon.

  DATA : li_inven TYPE STANDARD TABLE OF zqtc_inven_recon INITIAL SIZE 0. " Table for Inventory Reconciliation Data

  SELECT *
  FROM zqtc_inven_recon " Table for Inventory Reconciliation Data
  INTO TABLE fp_i_inven_recon
  WHERE zadjtyp = p_adjtyp
    AND zsohqty NE space
    AND xblnr = space.
  IF sy-subrc EQ 0.
* To get the first GR date
    li_inven[] = fp_i_inven_recon[].
    SORT li_inven BY matnr werks.
    DELETE ADJACENT DUPLICATES FROM li_inven COMPARING matnr werks.

    IF li_inven IS NOT INITIAL .
      SELECT *
      FROM zqtc_inven_recon " Table for Inventory Reconciliation Data
      INTO TABLE i_inven_recon_all
      FOR ALL ENTRIES IN li_inven
      WHERE zadjtyp = p_adjtyp
      AND matnr = li_inven-matnr
      AND werks = li_inven-werks.
      IF sy-subrc EQ 0.
        SORT i_inven_recon_all BY matnr werks zdate.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF li_inven IS NOT INITIAL
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_PO_GR_GI
*&---------------------------------------------------------------------*
*  First Create PO for offline order and then do the GR and GI
*----------------------------------------------------------------------*
*  -->  fp_i_inven_recon
*----------------------------------------------------------------------*
FORM f_create_po_gr_gi USING fp_i_inven_recon TYPE tt_inven_recon.


* Local Constant Declaration
  CONSTANTS : lc_knttp_p    TYPE knttp      VALUE 'P',                       " Account Assignment Category
              lc_error      TYPE char1      VALUE 'E',                       " Error of type CHAR1
              lc_segnam     TYPE edilsegtyp VALUE 'E1MBGMCR',                "Idoc segment name E1MBGCR
              lc_segnam1    TYPE edilsegtyp VALUE 'E1BP2017_GM_HEAD_01',     "Idoc segment name
              lc_segnam2    TYPE edilsegtyp VALUE 'E1BP2017_GM_CODE',        "Idoc segment name
              lc_segnam4    TYPE edilsegtyp VALUE 'E1BP2017_GM_ITEM_CREATE', "Idoc segment name
              lc_gm_code_03 TYPE gm_code    VALUE '03',                      "Value for GM_CODE
              lc_gm_code_01 TYPE gm_code    VALUE '01',                      "Value for GM_CODE
              lc_bewtp_e    TYPE bewtp      VALUE 'E',                       " Purchase Order History Category
              lc_53         TYPE edi_status VALUE '53',                      " Status of IDoc
              lc_51         TYPE edi_status VALUE '51',                      " Status of IDoc
              lc_bednr      TYPE rvari_vnam VALUE 'BEDNR',                   " Requirement Tracking Number
              lc_offline    TYPE rvari_vnam VALUE 'OFFLINE',                 " Event
              lc_msg_no     TYPE edi_stamno VALUE '177',                     " Status message number
              lc_msg_no_183 TYPE edi_stamno VALUE '183',                     " Status message number
              lc_msg_id     TYPE edi_stamid VALUE 'ZQTC_R2',                 " Status message ID
              lc_msg_ty     TYPE edi_stamid VALUE 'E',                       " Status message ID
              lc_devid      TYPE zdevid     VALUE 'R040',                    " Development ID
              lc_evcode     TYPE edi_evcode VALUE 'BAPI',                    " Process code for inbound processing
              lc_red        TYPE char4      VALUE '@0A@',                    " Red of type CHAR4
              lc_green      TYPE char4      VALUE '@08@',                    " Green of type CHAR4
              lc_yellow     TYPE char4      VALUE '@09@'.                    " Yellow of type CHAR4

* Local Data Declaration
  DATA : lst_edidc_po      TYPE edidc, " Control record (IDoc)
*Structures to hold PO lst_header data
         lst_header        TYPE bapimepoheader,  " Purchase Order Header Data
         lst_headerx       TYPE bapimepoheaderx, " Purchase Order Header Data (Change Parameter)
*Internal Tables to hold PO lst_item DATA
         lst_item          TYPE bapimepoitem,  " Purchase Order Item
         lst_itemx         TYPE bapimepoitemx, " Purchase Order Item Data (Change Parameter)
         li_item           TYPE bapimepoitem_tp,
         li_itemx          TYPE bapimepoitemx_tp,
         lv_num            TYPE ebelp,         " Item Number of Purchasing Document
         lv_purchase_order TYPE ebeln,         " Purchasing Document Number
*Internal table to hold messages from BAPI call
         li_return         TYPE bapiret2_t,
* Variables for IDOc
         lst_alv           TYPE ty_alv,
         lst_recon         TYPE zqtc_inven_recon,                                  " Table for Inventory Reconciliation Data
         lv_mat_number     TYPE mblnr,                                             " Number of Material Document
         lv_mat_number_gi  TYPE mblnr,                                             " Number of Material Document
         lv_segnam         TYPE edilsegtyp,                                        " Segment type
         lv_hlevel         TYPE edi_hlevel,                                        " Hierarchy level
         lst_sdata         TYPE edi_sdata,                                         "sdata structure
         lst_idoc_item     TYPE e1bp2017_gm_item_create,                           "Item structure
         lst_idoc_header   TYPE e1bp2017_gm_head_01,                               " BAPI Communication Structure: Material Document Header Data
         lv_idoc_num_gr    TYPE edi_docnum,                                        " IDoc number
         lv_idoc_num_gi    TYPE edi_docnum,                                        " IDoc number
         li_edidd          TYPE tt_edidd,                                          "EDIDD table
         li_recon_tmp      TYPE STANDARD TABLE OF zqtc_inven_recon INITIAL SIZE 0, " Table for Inventory Reconciliation Data
         li_recon          TYPE STANDARD TABLE OF zqtc_inven_recon INITIAL SIZE 0. " Table for Inventory Reconciliation Data

* Range Declaration
  DATA : lir_date_range TYPE fieu_t_date_range.

* Get data from DataBase tables.
********************************************************************************
  li_recon_tmp[] = fp_i_inven_recon[].
  SORT li_recon_tmp BY matnr werks zdate DESCENDING.

* Get Data from ZCACONSTANT Table
* Get the constant values from ZCACONSTANT value.
  SELECT devid,                   "Development ID
         param1,                  "ABAP: Name of Variant Variable
         param2,                  "ABAP: Name of Variant Variable
         srno,                    "Current selection number
         sign,                    "ABAP: ID: I/E (include/exclude values)
         opti,                    "ABAP: Selection option (EQ/BT/CP/...)
         low,                     "Lower Value of Selection Condition
         high                     "Upper Value of Selection Condition
     FROM zcaconstant             "Wiley Application Constant Table
     INTO TABLE @DATA(li_constants)
     WHERE devid    = @lc_devid
     AND   activate = @abap_true. "Only active record
  IF sy-subrc IS INITIAL.
    SORT li_constants BY param1 param2.
  ENDIF. " IF sy-subrc IS INITIAL

  DATA(li_inven_recon)  = fp_i_inven_recon.
  SORT li_inven_recon BY werks.
  DELETE ADJACENT DUPLICATES FROM li_inven_recon COMPARING werks.

* Get the company code from T001W table .
  IF li_inven_recon[] IS NOT INITIAL.
    SELECT werks, " Plant
           bwkey  " Valuation Area
    INTO TABLE @DATA(li_cocd)
    FROM t001w    " Plants/Branches
    FOR ALL ENTRIES IN @li_inven_recon
    WHERE werks = @li_inven_recon-werks.
    IF sy-subrc EQ 0.
      SORT li_cocd BY werks.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_inven_recon[] IS NOT INITIAL

* Get Vendor from EORD table
  li_inven_recon[]  = fp_i_inven_recon[].
  SORT li_inven_recon BY matnr werks zdate.
  DELETE ADJACENT DUPLICATES FROM li_inven_recon COMPARING matnr werks zdate.
  IF li_inven_recon[] IS NOT INITIAL.
*   Update Distributor Name
    SELECT matnr, " Material Number
           werks, " Plant
           lifnr  " Vendor Account Number
      FROM eord   " Purchasing Source List
      INTO TABLE @DATA(li_eord)
      FOR ALL ENTRIES IN @li_inven_recon
      WHERE matnr = @li_inven_recon-matnr
      AND  werks  = @li_inven_recon-werks
      AND flifn = @abap_true
      AND vdatu LE @li_inven_recon-zdate
      AND bdatu GE @li_inven_recon-zdate.
    IF sy-subrc EQ 0.
      SORT li_eord BY matnr werks .
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_inven_recon[] IS NOT INITIAL

* Get the UOM from MARA table
  li_inven_recon[]  = fp_i_inven_recon[].
  SORT li_inven_recon BY matnr.
  DELETE ADJACENT DUPLICATES FROM li_inven_recon COMPARING matnr.

  IF li_inven_recon IS NOT INITIAL.
*  Get data from MARA table
    SELECT matnr, " Material Number
           meins  " Base Unit of Measure
    INTO TABLE @DATA(li_mara)
    FROM mara     " General Material Data
    FOR ALL ENTRIES IN @li_inven_recon
    WHERE matnr = @li_inven_recon-matnr.
    IF sy-subrc EQ 0.
      SORT li_mara BY matnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_inven_recon IS NOT INITIAL

* Get the UOM from MARA table
  li_inven_recon[]  = fp_i_inven_recon[].
  SORT li_inven_recon BY matnr werks.
  DELETE ADJACENT DUPLICATES FROM li_inven_recon COMPARING matnr werks.
  IF li_inven_recon IS NOT INITIAL.
*  Get Data from EKPO table.
    SELECT  a~ebeln, " Purchasing Document Number
            a~bsart, " Purchasing Document Type
            b~ebelp, " Item Number of Purchasing Document
            b~matnr, " Material Number
            b~werks, " Plant
            b~menge, " PO Amount
            b~knttp, " Account Assignment Category
            b~elikz  " "Delivery Completed" Indicator
      INTO TABLE @DATA(li_ekpo)
      FROM ekko AS a INNER JOIN ekpo AS b
      ON a~ebeln = b~ebeln
      FOR ALL ENTRIES IN @li_inven_recon
      WHERE a~bsart = @p_po_nb
      AND   b~loekz	= @space
      AND   b~matnr = @li_inven_recon-matnr
      AND   b~werks = @li_inven_recon-werks
* Begin of CHANGE:ERP_2215:LKODWANI:23-MAY-2017:ED2K905979
*      AND   b~elikz = @space
* End of CHANGE:ERP_2215:LKODWANI:23-MAY-2017:ED2K905979
      AND   b~knttp = @lc_knttp_p
      AND   b~emlif NE @space.
    IF sy-subrc EQ 0.
      SORT li_ekpo BY matnr werks elikz ebeln.
* Begin of CHANGE:ERP_2215:LKODWANI:23-MAY-2017:ED2K905979
* For delivery completed PO's we need to take the latest PO for collective number
* and hence we are taking it into another internal table.
      DATA(li_ekpo_dlvc) = li_ekpo[].
      SORT li_ekpo_dlvc DESCENDING BY matnr werks elikz ebeln.
* End of CHANGE:ERP_2215:LKODWANI:23-MAY-2017:ED2K905979
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_inven_recon IS NOT INITIAL

*  To populate the control structure of idoc
  PERFORM f_set_edidc_po CHANGING lst_edidc_po.

* For one material their will be only one PO.
  LOOP AT fp_i_inven_recon INTO DATA(lst_inven_recon).

    lst_alv-zadjtyp = lst_inven_recon-zadjtyp.
    lst_alv-zsource = lst_inven_recon-zsource.
    lst_alv-matnr   = lst_inven_recon-matnr.
    lst_alv-werks   = lst_inven_recon-werks.

    READ TABLE li_cocd INTO DATA(lst_cocd) WITH KEY werks = lst_inven_recon-werks
                                                    BINARY SEARCH.
    IF sy-subrc EQ 0.
* Populate Company Code
      lst_header-comp_code = lst_cocd-bwkey.
      lst_headerx-comp_code = abap_true.
    ENDIF. " IF sy-subrc EQ 0

* Populate Document number
    lst_header-doc_type  = p_bsart.
    lst_headerx-doc_type = abap_true.

* Populate Purchase Number
    lst_header-purch_org = p_ekorg.
    lst_headerx-purch_org = abap_true.

* Populate Purchase Grouping
    lst_header-pur_group = p_ekgrp.
    lst_headerx-pur_group = abap_true.

* Populate Vendor
    READ TABLE li_eord INTO DATA(lst_erod) WITH KEY matnr = lst_inven_recon-matnr
                                                    werks = lst_inven_recon-werks
                                                    BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      lst_header-vendor = lst_erod-lifnr.
      lst_headerx-vendor = abap_true.
    ENDIF. " IF sy-subrc IS INITIAL

* Populate Collective Number
    READ TABLE li_ekpo INTO DATA(lst_ekpo) WITH KEY matnr = lst_inven_recon-matnr
                                                    werks = lst_inven_recon-werks
                                                    elikz = space
                                                    BINARY SEARCH.
    IF sy-subrc EQ 0.
      lst_header-collect_no  = lst_ekpo-ebeln.
      lst_headerx-collect_no = abap_true.
* Begin of CHANGE:ERP_2215:LKODWANI:23-MAY-2017:ED2K905979
    ELSE. " ELSE -> IF sy-subrc EQ 0
      READ TABLE li_ekpo_dlvc INTO lst_ekpo WITH KEY matnr = lst_inven_recon-matnr
                                                     werks = lst_inven_recon-werks
                                                     BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_header-collect_no  = lst_ekpo-ebeln.
        lst_headerx-collect_no = abap_true.
      ELSE. " ELSE -> IF sy-subrc EQ 0

        lst_alv-light = lc_yellow. "red traffic light
        lst_alv-msg_id = lc_msg_id.
        lst_alv-msg_no = lc_msg_no.
        MESSAGE ID lc_msg_id
        TYPE       lc_msg_ty
        NUMBER     lc_msg_no
        INTO       lst_alv-message
        WITH   lst_inven_recon-matnr
        lst_inven_recon-werks.
        APPEND lst_alv TO i_alv.
      ENDIF. " IF sy-subrc EQ 0
* End of CHANGE:ERP_2215:LKODWANI:23-MAY-2017:ED2K905979
    ENDIF. " IF sy-subrc EQ 0

* Populate Our reference field
    lst_header-our_ref = p_unsez.
    lst_headerx-our_ref = abap_true.

** Populate Document number with latest GR date
*    READ TABLE li_recon_tmp  INTO DATA(lst_inven_tmp) WITH KEY matnr = lst_inven_recon-matnr
*                                                               werks = lst_inven_recon-werks
*                                                               BINARY SEARCH.
*    IF sy-subrc EQ 0.
    PERFORM f_check_posting_date_period
*                                       USING lst_inven_recon-zdate
                                        CHANGING lir_date_range.
    IF lst_inven_recon-zdate IN lir_date_range.
      lst_header-doc_date  = lst_inven_recon-zdate.
      lst_headerx-doc_date = abap_true.
    ELSE. " ELSE -> IF lst_inven_recon-zdate IN lir_date_range
      IF lst_inven_recon-zmaildt IN lir_date_range.
        lst_header-doc_date  = lst_inven_recon-zmaildt.
        lst_headerx-doc_date = abap_true.
      ELSE. " ELSE -> IF lst_inven_recon-zmaildt IN lir_date_range
        lst_alv-light = lc_red. "red traffic light
        lst_alv-msg_id = lc_msg_id.
        lst_alv-msg_no = lc_msg_no_183.
        MESSAGE ID lc_msg_id
        TYPE       lc_msg_ty
        NUMBER     lc_msg_no_183
        INTO       lst_alv-message.
        APPEND lst_alv TO i_alv.
        CLEAR lst_alv.
        CONTINUE.
      ENDIF. " IF lst_inven_recon-zmaildt IN lir_date_range
    ENDIF. " IF lst_inven_recon-zdate IN lir_date_range
*    ENDIF. " IF sy-subrc EQ 0

    lv_num = lv_num + 10.
* Populate item Number
    lst_item-po_item  = lv_num.
    lst_alv-ebelp     = lv_num.
    lst_itemx-po_item = lv_num.

* Populate Material Number
    lst_item-material = lst_inven_recon-matnr.
    lst_itemx-material = abap_true.

* Populate Plant
    lst_item-plant  = lst_inven_recon-werks.
    lst_itemx-plant = abap_true .

* Populate GR indicator
    lst_item-gr_ind   = abap_true.
    lst_itemx-gr_ind = abap_true.

* Populate Item Quantity
    lst_item-quantity = lst_inven_recon-zsohqty.
    lst_itemx-quantity = abap_true .

* Populate PO UOM
    READ TABLE li_mara INTO DATA(lst_mara) WITH KEY matnr = lst_inven_recon-matnr
                                                     BINARY SEARCH .
    IF sy-subrc EQ 0.
      lst_item-po_unit  = lst_mara-meins.
      lst_itemx-po_unit = abap_true.
    ENDIF. " IF sy-subrc EQ 0

*   Populate Free item
    lst_item-free_item = abap_true.
    lst_itemx-free_item = abap_true.

*   Populate tracking no
*   Binary search is not required as table will have very few records.
    READ TABLE li_constants INTO DATA(lst_constant) WITH KEY param1 = lc_bednr
                                                             param2 = c_bednr_whstk.
    IF sy-subrc EQ 0.
      lst_item-trackingno = lst_constant-low.
      lst_itemx-trackingno = abap_true.
    ENDIF. " IF sy-subrc EQ 0

    APPEND lst_item TO li_item.
    APPEND lst_itemx TO li_itemx.

****Call BAPI to create PO
****************************************************************************
    CALL FUNCTION 'BAPI_PO_CREATE1'
      EXPORTING
        poheader         = lst_header
        poheaderx        = lst_headerx
      IMPORTING
        exppurchaseorder = lv_purchase_order
      TABLES
        return           = li_return
        poitem           = li_item
        poitemx          = li_itemx.

* If no error found then do the Database Commit.
    READ TABLE li_return WITH KEY type = lc_error " Return with key of type
                         TRANSPORTING NO FIELDS.  " Return with key of type
    IF sy-subrc NE 0 AND lv_purchase_order IS NOT INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
    ELSE. " ELSE -> IF sy-subrc NE 0 AND lv_purchase_order IS NOT INITIAL
      LOOP AT li_return INTO DATA(lst_return).
        IF  lst_return-type = 'E'.
          lst_alv-light = lc_red. "red traffic light
        ELSE. " ELSE -> IF lst_return-type = 'E'
          lst_alv-light = lc_yellow. "red traffic light
        ENDIF. " IF lst_return-type = 'E'
        lst_alv-msg_id = lst_return-id.
        lst_alv-msg_no = lst_return-number.
        lst_alv-message = lst_return-message.
        APPEND lst_alv TO i_alv.
      ENDLOOP. " LOOP AT li_return INTO DATA(lst_return)

    ENDIF. " IF sy-subrc NE 0 AND lv_purchase_order IS NOT INITIAL


    IF lv_purchase_order IS NOT INITIAL.
      lst_alv-ebeln = lv_purchase_order.

*    Create IDOC for GR
****************************************************************************
*    To build the IDOC data structure
      lv_segnam = lc_segnam.
      CLEAR lv_hlevel.
      lv_hlevel = lv_hlevel + 1.
*    To build the IDOC  data structure
      PERFORM f_set_edidd USING lv_segnam
                                lv_hlevel
                                lst_sdata
                      CHANGING li_edidd.

*    To populate header table and pass in IDOC
      PERFORM f_populate_header USING lst_header
                                CHANGING lst_idoc_header.

      CLEAR lv_segnam.
      lv_segnam = lc_segnam1.
      lst_idoc_header-header_txt = lst_inven_recon-zsource.
      lst_sdata = lst_idoc_header.
      lv_hlevel = lv_hlevel + 1.

*    To build the IDOC  data structure
      PERFORM f_set_edidd USING lv_segnam
                                lv_hlevel
                                lst_sdata
                          CHANGING li_edidd.

*  To set edidc for GM Code
      DATA(lv_code) = lc_gm_code_01.
      CLEAR: lv_segnam,lst_sdata.
      lv_segnam = lc_segnam2.
      lst_sdata = lv_code.

*  To build the IDOC  data structure
      PERFORM f_set_edidd USING lv_segnam
                                lv_hlevel
                                lst_sdata
                       CHANGING li_edidd.

*  To set EDIDC for items
*  To populate Item table and pass in IDOC
      PERFORM f_populate_item   USING lst_item
                                      lv_purchase_order
                                      lst_inven_recon
                                CHANGING lst_idoc_item.
      lst_idoc_item-move_type = p_mvt_gr.

      CLEAR: lv_segnam,lst_sdata.
      lv_segnam = lc_segnam4.
      lst_sdata = lst_idoc_item.

*   To build the IDOC  data structure
      PERFORM f_set_edidd USING lv_segnam
                                lv_hlevel
                                lst_sdata
                          CHANGING li_edidd.

*    Create IDOC
      PERFORM f_create_idoc USING    lst_edidc_po
                                     lc_evcode
                            CHANGING li_edidd
                                     lv_idoc_num_gr.
*  Get the Material Document Number
      IF lv_idoc_num_gr IS NOT INITIAL .
        PERFORM f_get_mseg_det USING     lv_idoc_num_gr
                               CHANGING  lv_mat_number.
        lst_alv-mblnr   = lv_mat_number.
        lst_alv-idoc_no = lv_idoc_num_gr.
        APPEND lst_alv TO i_alv.
      ENDIF. " IF lv_idoc_num_gr IS NOT INITIAL

      CLEAR : lv_hlevel,
              lv_segnam,
              lst_sdata,
              li_edidd,
              lst_idoc_header,
              lst_idoc_item.
*
** Create IDOC for GI
*****************************************************************************
**    To build the IDOC data structure
*      lv_segnam = lc_segnam.
*      CLEAR lv_hlevel.
*      lv_hlevel = lv_hlevel + 1.
*      PERFORM f_set_edidd USING lv_segnam
*                                lv_hlevel
*                                lst_sdata
*                      CHANGING li_edidd.
*
**    To populate header table and pass in IDOC
*      PERFORM f_populate_header USING lst_header
*                                CHANGING lst_idoc_header.
*
*      CLEAR: lst_idoc_header-ref_doc_no,
*             lst_idoc_header-header_txt.
** Pass the Purchase Order Number
*      lst_idoc_header-ref_doc_no = lv_purchase_order.
** Pass the Material order Number
*      lst_idoc_header-header_txt = lv_mat_number.
*      CLEAR lv_segnam.
*
*      lv_segnam = lc_segnam1.
*      lst_sdata = lst_idoc_header.
*      lv_hlevel = lv_hlevel + 1.
**    To build the IDOC  data structure
*      PERFORM f_set_edidd USING lv_segnam
*                                lv_hlevel
*                                lst_sdata
*                          CHANGING li_edidd.
*
**  To set edidc for GM Code
*      lv_code = lc_gm_code_03.
*      CLEAR: lv_segnam,lst_sdata.
*      lv_segnam = lc_segnam2.
*      lst_sdata = lv_code.
*
**  To build the IDOC  data structure
*      PERFORM f_set_edidd USING lv_segnam
*                                lv_hlevel
*                                lst_sdata
*                          CHANGING li_edidd.
*
*
**  To set EDIDC for items
**  To populate item table and pass in IDOC
*      PERFORM f_populate_item   USING lst_item
*                                      lv_purchase_order
*                                      lst_inven_recon
*                                CHANGING lst_idoc_item.
**      lst_idoc_item-move_type = p_mvt_gi.
*      CLEAR lst_idoc_item-mvt_ind.
*
*      CLEAR: lv_segnam,lst_sdata.
*      lv_segnam = lc_segnam4.
*      lst_sdata = lst_idoc_item.
*
**  To build the IDOC  data structure
*      PERFORM f_set_edidd USING lv_segnam
*                                lv_hlevel
*                                lst_sdata
*                          CHANGING li_edidd.
*
**  Create IDOC for GI
*      PERFORM f_create_idoc USING    lst_edidc_po
*                                     lc_evcode
*                            CHANGING li_edidd
*                                     lv_idoc_num_gi.
*
**  Get the Material Document Number
*      IF lv_idoc_num_gi IS NOT INITIAL .
*        PERFORM f_get_mseg_det USING     lv_idoc_num_gi
*                               CHANGING  lv_mat_number_gi.
*        lst_alv-mblnr = lv_mat_number_gi.
*        lst_alv-idoc_no = lv_idoc_num_gi.
*        APPEND lst_alv TO i_alv .
*        CLEAR lst_alv.
*      ENDIF. " IF lv_idoc_num_gi IS NOT INITIAL

* Populate Table for updating ZQTC_INVEN_RECON table .
      MOVE-CORRESPONDING lst_inven_recon TO lst_recon.
      IF lv_idoc_num_gr IS NOT INITIAL.
*         OR lv_idoc_num_gi IS NOT INITIAL.
        lst_recon-mandt = sy-mandt.
* Populate Document number with latest GR date
*        READ TABLE li_recon_tmp  INTO DATA(lst_inven_tmp) WITH KEY matnr = lst_inven_recon-matnr
*                                                                   werks = lst_inven_recon-werks
*                                                                   BINARY SEARCH.
*        IF sy-subrc EQ 0.
        lst_recon-zlgrdat = lst_header-doc_date.
*        ENDIF. " IF sy-subrc EQ 0

        READ TABLE i_inven_recon_all INTO DATA(lst_inven_recon_all) WITH KEY matnr = lst_inven_recon-matnr
                                                                             werks = lst_inven_recon-werks
                                                                             BINARY SEARCH .
        IF sy-subrc EQ 0.
          lst_recon-zfgrdat = lst_inven_recon_all-zdate.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          lst_recon-zfgrdat = lst_inven_recon-zdate.
        ENDIF. " IF sy-subrc EQ 0
        lst_recon-ebeln = lv_purchase_order.
        lst_recon-xblnr = lv_idoc_num_gr.
        lst_recon-mblnr = lv_mat_number.
        lst_recon-zgi_docnum = lv_idoc_num_gi.
        APPEND lst_recon TO li_recon.
        CLEAR lst_recon.
      ENDIF. " IF lv_idoc_num_gr IS NOT INITIAL
    ENDIF. " IF lv_purchase_order IS NOT INITIAL

* Clear all the local Varible
    CLEAR: lv_purchase_order,
           lv_mat_number,
           lv_num,
           li_return[],
           lst_item,
           lst_itemx,
           li_item[],
           li_itemx[],
           lst_header,
           lst_headerx,
           lv_hlevel,
           lv_segnam,
           lst_sdata,
           li_edidd,
           lv_idoc_num_gi,
           lv_idoc_num_gr,
           lst_idoc_header,
           lst_idoc_item.

  ENDLOOP. " LOOP AT fp_i_inven_recon INTO DATA(lst_inven_recon)

  IF i_alv IS NOT INITIAL.
    SELECT docnum, " IDoc number
           logdat, " Date of status information
           logtim, " Time of status information
           countr, " IDoc status counter
           status, " Status of IDoc
           statxt, " Text for status code
           stapa1, " Parameter 1
           stapa2, " Parameter 1
           stapa3, " Parameter 1
           stapa4, " Parameter 1
           statyp, " Type of message(A,W,E,S,I)
           stamid, " Status message ID
           stamno  " Status message number
      FROM edids   " Status Record (IDoc)
      INTO TABLE @DATA(li_edids)
      FOR ALL ENTRIES IN @i_alv
      WHERE docnum = @i_alv-idoc_no.
    IF sy-subrc EQ 0.
      SORT li_edids BY docnum countr DESCENDING.
      LOOP AT i_alv ASSIGNING FIELD-SYMBOL(<lst_alv>).
        READ TABLE li_edids INTO DATA(lst_edids) WITH KEY docnum = <lst_alv>-idoc_no
                                                           BINARY SEARCH.
        IF sy-subrc EQ 0.
          <lst_alv>-msg_id  = lst_edids-stamid.
          <lst_alv>-msg_no  = lst_edids-stamno.
          CASE lst_edids-status.
            WHEN  lc_53.
              <lst_alv>-light = lc_green. "green traffic light
            WHEN lc_51.
              <lst_alv>-light = lc_red. "red traffic light
            WHEN OTHERS .
              <lst_alv>-light = lc_yellow. "Yellow traffic light
          ENDCASE.

          MESSAGE ID lst_edids-stamid
          TYPE       lst_edids-statyp
          NUMBER     lst_edids-stamno
          INTO       <lst_alv>-message
          WITH       lst_edids-stapa1
                     lst_edids-stapa2
                     lst_edids-stapa3
                     lst_edids-stapa4.

        ENDIF. " IF sy-subrc EQ 0
      ENDLOOP. " LOOP AT i_alv ASSIGNING FIELD-SYMBOL(<lst_alv>)
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF i_alv IS NOT INITIAL

* Update ZQTC_INVENT_RECON
****************************************************************************
  IF li_recon IS NOT INITIAL.
*    Updating custom table
    UPDATE zqtc_inven_recon FROM TABLE li_recon.
  ELSE. " ELSE -> IF li_recon IS NOT INITIAL
    MESSAGE i174(zqtc_r2). " No Data to Process.
  ENDIF. " IF li_recon IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_EDIDC_PO
*&---------------------------------------------------------------------*
*       Set IDOC Status
*----------------------------------------------------------------------*
*      <--P_LST_EDIDC_PO  text
*----------------------------------------------------------------------*
FORM f_set_edidc_po  CHANGING fp_lst_edidc_po TYPE edidc. " Control record (IDoc)

  CONSTANTS:
    lc_mestyp     TYPE edi_mestyp VALUE 'MBGMCR',   "Message Type
    lc_basic_type TYPE edi_idoctp VALUE 'MBGMCR03', "Basic type
    lc_prt_ls     TYPE edi_sndprt VALUE 'LS',       "Logical port
    lc_sap        TYPE char3      VALUE 'SAP',      "system name SAP
    lc_direct_2   TYPE edi_direct VALUE '2',        "direction-inbound
    lc_status_53  TYPE edi_status VALUE '53',       "idoc status-started
    lc_mesfct_gr  TYPE edi_mesfct VALUE 'GR',      " Message Fucntion GR
    lc_mescod_soh TYPE edi_mescod VALUE 'SOH'.     " Message Code SOH


* Get Logical System
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system             = fp_lst_edidc_po-sndprn
    EXCEPTIONS
      own_logical_system_not_defined = 1
      OTHERS                         = 2.
  IF sy-subrc = 0.
    fp_lst_edidc_po-rcvprn = fp_lst_edidc_po-sndprn.
  ENDIF. " IF sy-subrc = 0

  fp_lst_edidc_po-mandt  = sy-mandt.
  fp_lst_edidc_po-status = lc_status_53. "53
  fp_lst_edidc_po-direct = lc_direct_2. "2
  CONCATENATE lc_sap sy-sysid INTO fp_lst_edidc_po-rcvpor. "Reciever Port
  fp_lst_edidc_po-sndpor = fp_lst_edidc_po-rcvpor. "Sender Port
  fp_lst_edidc_po-sndprt = lc_prt_ls. "LS
  fp_lst_edidc_po-rcvprt = fp_lst_edidc_po-sndprt. "Reciving Partner
  fp_lst_edidc_po-credat = sy-datum. "Creation date
  fp_lst_edidc_po-cretim = sy-uzeit. "Creation time
  fp_lst_edidc_po-mestyp = lc_mestyp. "MBGMCR
  fp_lst_edidc_po-mescod = lc_mescod_soh.   "Message Variant SOH
  fp_lst_edidc_po-mesfct = lc_mesfct_gr.    "Message Function GR
  fp_lst_edidc_po-idoctp = lc_basic_type. "Basic type

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_EDIDD
*&---------------------------------------------------------------------*
*       To set EDIDD data
*----------------------------------------------------------------------*
FORM f_set_edidd USING fp_lv_segnam TYPE edilsegtyp " Segment type
                       fp_lv_hlevel TYPE edi_hlevel " Hierarchy level
                       fp_lst_sdata TYPE edi_sdata  " Application data
                 CHANGING fp_li_edidd TYPE tt_edidd.
* Local data declaration
  DATA lst_edidd TYPE edidd. "IDOC Data structure

* Local Constant Declaration
  CONSTANTS lc_mestyp TYPE edi_mestyp VALUE 'MBGMCR'. "Message type

* Call the FM to adjust the fields in SDATA structure
  CALL FUNCTION 'IDOC_REDUCTION_FIELD_REDUCE'
    EXPORTING
      message_type = lc_mestyp
      segment_type = fp_lv_segnam
      segment_data = fp_lst_sdata
    IMPORTING
      segment_data = lst_edidd-sdata.

* Add the segment name
  lst_edidd-segnam = fp_lv_segnam.
*  Add the hierarchy level
  lst_edidd-hlevel = fp_lv_hlevel.

  APPEND lst_edidd TO fp_li_edidd.
  CLEAR lst_edidd.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_HEADER
*&---------------------------------------------------------------------*
*       Populate IDOC header
*----------------------------------------------------------------------*
FORM f_populate_header  USING    fp_lst_header TYPE bapimepoheader            " Purchase Order Header Data
                        CHANGING fp_lst_idoc_header TYPE e1bp2017_gm_head_01. " BAPI Communication Structure: Material Document Header Data

*Populate idoc header details
  fp_lst_idoc_header-pstng_date = fp_lst_header-doc_date.
  fp_lst_idoc_header-doc_date   = fp_lst_header-doc_date.
  fp_lst_idoc_header-ref_doc_no = fp_lst_header-collect_no.
*  fp_lst_idoc_header-header_txt  = lc_offline.
  fp_lst_idoc_header-bill_of_lading  = p_unsez.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_ITEM
*&---------------------------------------------------------------------*
*       Populate items in IDOC
*----------------------------------------------------------------------*
FORM f_populate_item  USING    fp_lst_item          TYPE bapimepoitem             " Purchase Order Item
                               fp_lv_purchase_order TYPE ebeln                    " Purchasing Document Number
                               fp_lst_inven_recon   TYPE zqtc_inven_recon         " Table for Inventory Reconciliation Data
                      CHANGING fp_lst_idoc_item     TYPE e1bp2017_gm_item_create. " BAPI Communication Structure: Create Material Document Item

  CONSTANTS : lc_dash TYPE char1 VALUE '-'. " Dasg of type CHAR1

  DATA: lv_unload_pt TYPE char25, " Unload_pt of type CHAR25
        lv_seq_no    TYPE char10. " Seq_no of type CHAR10

* Populate idoc items
  fp_lst_idoc_item-material  = fp_lst_item-material.
  fp_lst_idoc_item-plant     = fp_lst_item-plant.
  fp_lst_idoc_item-stge_loc  = p_lgort.
  fp_lst_idoc_item-entry_qnt = fp_lst_item-quantity.
  CONDENSE fp_lst_idoc_item-entry_qnt.
  fp_lst_idoc_item-entry_uom = fp_lst_item-po_unit.
  fp_lst_idoc_item-po_number = fp_lv_purchase_order.
  fp_lst_idoc_item-po_item   = fp_lst_item-po_item.
  fp_lst_idoc_item-mvt_ind   = p_mv_ind.

  WRITE fp_lst_inven_recon-zseqno TO lv_seq_no.
  CONDENSE lv_seq_no.
  CONCATENATE fp_lst_inven_recon-zdate
               lv_seq_no
       INTO lv_unload_pt SEPARATED BY lc_dash.

  fp_lst_idoc_item-unload_pt   = lv_unload_pt.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_IDOC
*&---------------------------------------------------------------------*
*      Create IDOC for GR
*----------------------------------------------------------------------*
FORM f_create_idoc  USING    fp_edidc_po         TYPE edidc      " Control record (IDoc)
                             fp_lc_evcode        TYPE edi_evcode " Process code for inbound processing
                    CHANGING fp_li_edidd TYPE tt_edidd
                             fp_lv_idoc_number TYPE edi_docnum.  " IDoc number

* Local data declaration
  DATA: li_control_records TYPE STANDARD TABLE OF edidc, "IDOC control record
        lst_process_data   TYPE tede2,                   "IDOC process data
        lst_edidc          TYPE edidc.                   "IDOC control record data

* Local Constant declaration
  CONSTANTS:  lc_6    TYPE edi_edivr2 VALUE '6'. "Event No

  lst_edidc = fp_edidc_po.
* Call the FM to create the IDOC no and initatiate the IDOC
  CALL FUNCTION 'IDOC_INBOUND_WRITE_TO_DB'
    EXPORTING
      pi_do_handle_error  = abap_true
      pi_return_data_flag = space
    IMPORTING
      pe_idoc_number      = fp_lv_idoc_number
    TABLES
      t_data_records      = fp_li_edidd[]
    CHANGING
      pc_control_record   = lst_edidc
    EXCEPTIONS
      idoc_not_saved      = 1
      OTHERS              = 2.
  IF sy-subrc = 0.
    COMMIT WORK.

* Append the data in the control record table to pass
    APPEND lst_edidc TO li_control_records.
    CLEAR: lst_edidc,
           lst_process_data.

* Assign the Event code details
    lst_process_data-mandt  = sy-mandt.
    lst_process_data-evcode = fp_lc_evcode.
    lst_process_data-edivr2 = lc_6.

* Call the FM to schedule the Inbound processing in Foreground
    CALL FUNCTION 'IDOC_START_INBOUND'
      EXPORTING
        pi_inbound_process_data       = lst_process_data
        succ_show_flag                = abap_true
        pi_called_online              = abap_true
        pi_start_event_enabled        = abap_true
      TABLES
        t_control_records             = li_control_records
      EXCEPTIONS
        invalid_document_number       = 1
        error_before_call_application = 2
        inbound_process_not_possible  = 3
        old_wf_start_failed           = 4
        wf_task_error                 = 5
        serious_inbound_error         = 6
        OTHERS                        = 7.
    IF sy-subrc EQ 0.
*      No Action
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc = 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MSEG_DET
*&---------------------------------------------------------------------*
*      Get Posted Matrial Document number
*----------------------------------------------------------------------*
*      -->P_LV_IDOC_NUMBER  text
*      <--P_LV_MAT_NUMBER  text
*----------------------------------------------------------------------*
FORM f_get_mseg_det  USING    fp_lv_idoc_number  TYPE edi_docnum " Get_mseg_det using fp_l of type CHAR70
                     CHANGING fp_lv_mat_number   TYPE mblnr.     " Number of Material Document

*  To get the roleid based on idoc number
  SELECT objkey,
         objtype,
         logsys,
         roletype,
         roleid     " Object Relationship Service : Role GUID
    FROM srrelroles " Object Relationship Service: Roles
    UP TO 1 ROWS
    INTO @DATA(lst_service_roles)
    WHERE objkey = @fp_lv_idoc_number.
  ENDSELECT.
  IF sy-subrc EQ 0 AND lst_service_roles-roleid IS NOT INITIAL.
    SELECT role_a,
           role_b  " Object Relationship Service : Role GUID
      FROM idocrel " Links between IDoc and application object
      UP TO 1 ROWS
      INTO @DATA(lst_idocrel)
      WHERE role_a = @lst_service_roles-roleid.
    ENDSELECT.
    IF sy-subrc EQ 0 AND lst_idocrel-role_b IS NOT INITIAL.
*       Again select is done from srrelroles table to get the OBJKEY
*       which will now containm the material document after putting ROLE_B of IDOCREL into roleid
      SELECT objkey,
             roleid     " Object Relationship Service : Role GUID
        FROM srrelroles " Object Relationship Service: Roles
        UP TO 1 ROWS
        INTO @DATA(lst_objkey)
        WHERE roleid = @lst_idocrel-role_b.
      ENDSELECT.
      IF sy-subrc EQ 0 AND lst_objkey-objkey IS NOT INITIAL.
        SELECT mblnr " Number of Material Document
          FROM mseg  " Document Segment: Material
          UP TO 1 ROWS
          INTO fp_lv_mat_number
          WHERE mblnr = lst_objkey-objkey+0(10).
        ENDSELECT.
        IF sy-subrc EQ 0.
* No action
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0 AND lst_objkey-objkey IS NOT INITIAL
    ENDIF. " IF sy-subrc EQ 0 AND lst_idocrel-role_b IS NOT INITIAL
  ENDIF. " IF sy-subrc EQ 0 AND lst_service_roles-roleid IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_RECORDS_ALV
*&---------------------------------------------------------------------*
*      Display ALV
*----------------------------------------------------------------------*
*      -->P_I_ALV  text
*----------------------------------------------------------------------*
FORM f_display_records_alv.

  DATA: lst_layout   TYPE slis_layout_alv.

  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.

  PERFORM f_popul_field_catalog.
*Begin of change RBTIRUMALA for RITM0079465 on 15.02.2019 ED1K909620
  DELETE ADJACENT DUPLICATES FROM i_alv COMPARING  msg_id  " Message Class
                                                   msg_no  " Message Number
                                                   idoc_no " Reference Document Number
                                                   zadjtyp " Adjustment Type
                                                   werks   " Delivering Plant (Own or External)
                                                   ebeln   " Purchasing Document Number
                                                   ebelp   " Item Number of Purchasing Document
                                                   mblnr   " Number of Material Document
                                                   zsource " Source File Name
                                                   message. " Message Text
*End of change RBTIRUMALA for RITM0079465 on 15.02.2019 ED1K909343
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = lst_layout
      it_fieldcat        = i_fcat
      i_save             = abap_true
    TABLES
      t_outtab           = i_alv
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
  ENDIF. " IF sy-subrc <> 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CATALOG
*&---------------------------------------------------------------------*
*       Populate Field Catalog
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM f_popul_field_catalog .

*   Populate the field catalog
  DATA : lv_col_pos TYPE sycucol. " Col_pos of type Integers

*Constant for hold for alv tablename
  CONSTANTS: lc_tabname     TYPE slis_tabname VALUE 'I_ALV', "Tablename for Alv Display
* Constent for hold the alv field catelog
             lc_fld_light   TYPE slis_fieldname VALUE 'LIGHT',
             lc_fld_id      TYPE slis_fieldname VALUE 'MSG_ID',
             lc_fld_number  TYPE slis_fieldname VALUE 'MSG_NO',
             lc_fld_xblnr   TYPE slis_fieldname VALUE 'IDOC_NO',
             lc_fld_zadjtyp TYPE slis_fieldname VALUE 'ZADJTYP',
             lc_fld_matnr   TYPE slis_fieldname VALUE 'MATNR',
             lc_fld_werks   TYPE slis_fieldname VALUE 'WERKS',
             lc_fld_ebeln   TYPE slis_fieldname VALUE 'EBELN',
             lc_fld_ebelp   TYPE slis_fieldname VALUE 'EBELP',
             lc_fld_mblnr   TYPE slis_fieldname VALUE 'MBLNR',
             lc_fld_zsource TYPE slis_fieldname VALUE 'ZSOURCE',
             lc_fld_message TYPE slis_fieldname VALUE 'MESSAGE'.

* Populate field catalog

* Status Icon
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_light  lc_tabname   lv_col_pos  'Status Icon'(001)
                       CHANGING i_fcat.

* message Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_id  lc_tabname   lv_col_pos  'MSG ID'(007)
                       CHANGING i_fcat.

* Message Id
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_number  lc_tabname   lv_col_pos 'MSG NO'(006)
                       CHANGING i_fcat.

* Idoc No
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_xblnr  lc_tabname   lv_col_pos  'IDOC NO'(008)
                     CHANGING i_fcat.

* Adj type
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zadjtyp  lc_tabname   lv_col_pos  'ADJ Typ'(009)
                     CHANGING i_fcat.

* Material No
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_matnr  lc_tabname   lv_col_pos  'Material No'(010)
                     CHANGING i_fcat.

* Plant
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_werks  lc_tabname   lv_col_pos  'Plant'(011)
                     CHANGING i_fcat.

* PO Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_ebeln  lc_tabname   lv_col_pos  'PO NO'(012)
                     CHANGING i_fcat.

* Item No
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_ebelp  lc_tabname   lv_col_pos  'Item  No'(013)
                     CHANGING i_fcat.

* Material DOC NO (GR/GI)
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_mblnr  lc_tabname   lv_col_pos  'Material DOC NO (GR/GI)'(014)
                     CHANGING i_fcat.

* Source File
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zsource  lc_tabname   lv_col_pos  'Source File'(015)
                     CHANGING i_fcat.

* Message
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_message lc_tabname   lv_col_pos  'Message'(016)
                     CHANGING i_fcat.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*       Build Field catalog
*----------------------------------------------------------------------*
*                   USING      fp_field        " Field Name
*                              fp_tabname      " Table Name
*                              fp_col_pos      " Col_pos of type Integers
*                              fp_text         " Text of type CHAR50
*                     CHANGING fp_i_fcat       " Build field catalog
*----------------------------------------------------------------------*
FORM f_build_fcat  USING      fp_field         TYPE slis_fieldname
                              fp_tabname       TYPE slis_tabname
                              fp_col_pos       TYPE sycucol " Col_pos of type Integers
                              fp_text          TYPE char50  " Text of type CHAR50
                     CHANGING fp_i_fcat       TYPE slis_t_fieldcat_alv.

  DATA: lst_fcat   TYPE slis_fieldcat_alv.

  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '40'. " Output Length

  lst_fcat-lowercase   = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-seltext_m   = fp_text.

  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.

ENDFORM. " SUB_BUILD_FCAT
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_POSTING_DATE_PERIOD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_INVEN_TMP_ZDATE  text
*      <--P_LV_OUT_RANGE  text
*----------------------------------------------------------------------*
FORM f_check_posting_date_period
*                                 USING    fp_date TYPE syst_datum " ABAP System Field: Current Date of Application Server
                                  CHANGING fp_lir_date_range TYPE fieu_t_date_range.
  DATA : lv_monthn     TYPE numc2,             " Two digit number
         lv_yearn      TYPE numc4,             " Count parameters
         lv_last_date  TYPE syst_datum,        " ABAP System Field: Current Date of Application Server
         lv_first_date TYPE syst_datum,        " ABAP System Field: Current Date of Application Server
         lst_posting   TYPE fieu_s_date_range. " Struture for date range table

  DATA: lc_i  TYPE char1 VALUE 'I',  " I of type CHAR1
        lc_12 TYPE numc2 VALUE '12', " Two digit number
        lc_bt TYPE char2 VALUE 'BT'. " Eq of type CHAR2

* Get the last date of current Month
  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = sy-datum
    IMPORTING
      last_day_of_month = lv_last_date
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.
  IF sy-subrc <> 0.
* Do nothing .
  ENDIF. " IF sy-subrc <> 0

* * Find current month and year
  MOVE sy-datum+4(2) TO lv_monthn.
  MOVE sy-datum+0(4) TO lv_yearn.

* If current month > 1 subtract 1 from then month
  IF lv_monthn > 1.
    lv_monthn = lv_monthn - 1.
  ELSE. " ELSE -> IF lv_monthn > 1
    lv_monthn = lc_12.
    lv_yearn = lv_yearn - 1.
  ENDIF. " IF lv_monthn > 1

* First date of month
  CONCATENATE lv_yearn lv_monthn '01' INTO lv_first_date.

  lst_posting-sign   = lc_i.
  lst_posting-option = lc_bt.
  lst_posting-low  = lv_first_date.
  lst_posting-high = lv_last_date.
  APPEND lst_posting TO fp_lir_date_range.
  CLEAR lst_posting.
*
*  IF fp_date NOT IN lir_date_range.
*    fp_lv_out_range = abap_true.
*  ENDIF. " IF fp_date NOT IN lir_date_range

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOCK_ZQTC_INVEN_RECON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_lock_zqtc_inven_recon .

  CONSTANTS: lc_red    TYPE char4      VALUE '@0A@', " Red of type CHAR4
             lc_msg_id TYPE symsgid VALUE 'ZQTC_R2', " Message Class
             lc_msg_no TYPE symsgno VALUE '184'.     " Message Number


  DATA:     lst_alv TYPE ty_alv.

  CALL FUNCTION 'ENQUEUE_E_TABLE'
    EXPORTING
      tabname        = c_inven_recon
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.

  IF sy-subrc NE 0.
    lst_alv-light = lc_red. "red traffic light
    lst_alv-zadjtyp = p_adjtyp.
    lst_alv-msg_id   = lc_msg_id.
    lst_alv-msg_no  = lc_msg_no.

    MESSAGE ID lc_msg_id " Table & is locked.
    TYPE        'E'
    NUMBER     lc_msg_no
    INTO       lst_alv-message
    WITH        c_inven_recon.

    v_lock = abap_true.
    APPEND lst_alv TO i_alv.
    CLEAR lst_alv.
*    MESSAGE s184(zqtc_r2) WITH c_inven_recon DISPLAY LIKE 'E'. " Table & is locked.
*    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc NE 0


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UNLOCK_ZQTC_INVEN_RECON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_unlock_zqtc_inven_recon .

  CALL FUNCTION 'DEQUEUE_E_TABLE'
    EXPORTING
      tabname = 'ZQTC_INVEN_RECON'.

ENDFORM.
