*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SDOC_WRAPPER_MASS_VA05 (Include Program)
* PROGRAM DESCRIPTION: Add new fields in VA05
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   06/16/2017
* OBJECT ID: R052
* TRANSPORT NUMBER(S): ED2K906705
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K917757 / ED2K917910
* REFERENCE NO:  ERPM-10485
* WRICEF ID: R052
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  03/10/2020  / 04/04/2020
* DESCRIPTION: Add frieght forwarding and JPAT order fields
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918275
* REFERENCE NO:  ERPM-14773
* WRICEF ID: R052
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  05/21/2020
* DESCRIPTION: Add new selection screen fields and output fields
*---------------------------------------------------------------------*
**********************************************************************
* Local Type Declaration
**********************************************************************
TYPES: BEGIN OF lty_zterm,
         sign   TYPE char1,  " Sign of type CHAR1
         option TYPE char2,  " Option of type CHAR2
         low    TYPE dzterm, " Terms of Payment Key
         high   TYPE dzterm, " Terms of Payment Key
       END OF lty_zterm.
**********************************************************************
* Local Internal table Declaration
**********************************************************************
DATA:
  li_vbap_keys_va05 TYPE tdt_sw_vbap_key,       "Keys - Sales Document Item (VBAP)
  lir_docu_cat_va05 TYPE saco_vbtyp_ranges_tab, "SD document category
  lir_bill_doc_va05 TYPE fip_t_vbeln_range,     "Billing Document
  lir_bill_typ_va05 TYPE j_3rs_so_invoice_sd,   "Billing Type
  lir_pay_term_va05 TYPE STANDARD TABLE OF lty_zterm,
  lir_crtd_nam_va05 TYPE fip_t_ernam_range,     "Name of Person who Created the Object
  lir_crtd_dat_va05 TYPE fip_t_erdat_range,     "Date on Which Record Was Created
  lir_payer_va05    TYPE oira_payer_ranges_tt,  "Payer
**********************************************************************
* Local Structure Declaration
**********************************************************************

  lst_vbap_key_va05 TYPE tds_sw_vbap_key, "Key Structure for VBAP

**********************************************************************
* Local Object declaration
**********************************************************************
  lo_dynamic_s_va05 TYPE REF TO data, "Data Reference (Structure)
  lo_dynamic_t_va05 TYPE REF TO data, "Data Reference (Table)

**********************************************************************
* Local Variable Declaration for fetching value from stack
**********************************************************************
  lv_bill_docs_va05 TYPE char50 VALUE '(SD_SALES_DOCUMENT_VIEW)S_BLDOC[]', "Billing Document
  lv_bill_type_va05 TYPE char50 VALUE '(SD_SALES_DOCUMENT_VIEW)S_BLTYP[]', "Billing Type
  lv_paym_key_va05  TYPE char50 VALUE '(SD_SALES_DOCUMENT_VIEW)S_ZTERM[]', " Paym_key1 of type CHAR50
  lv_crtd_name_va05 TYPE char50 VALUE '(SD_SALES_DOCUMENT_VIEW)S_ERNAM[]', "Name of Person who Created the Object
  lv_crtd_date_va05 TYPE char50 VALUE '(SD_SALES_DOCUMENT_VIEW)S_ERDAT[]', "Date on Which Record Was Created
  lv_payer_va05     TYPE char50 VALUE '(SD_SALES_DOCUMENT_VIEW)S_KUNRG[]', "Payer
*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275 ---*
  lv_lifnr_va05     TYPE char50 VALUE '(SD_SALES_DOCUMENT_VIEW)S_LIFNR[]',  " Forwarding agent
  lv_donot_bom_va05 TYPE char50 VALUE '(SD_SALES_DOCUMENT_VIEW)CB_BOM',     " BOM component do not display
  lv_ship2p_va05    TYPE char50 VALUE '(SD_SALES_DOCUMENT_VIEW)S_SHIP2P[]'. " Ship to party
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275 ---*
**********************************************************************
* Local Field Symbo,l Declaration
**********************************************************************
FIELD-SYMBOLS:
  <lst_result_va05> TYPE any,            "Result (Structure)
  <li_rng_tab_va05> TYPE table,          "Range Table
  <li_results_va05> TYPE STANDARD TABLE, "Result (Internal Table)
*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
  <lv_bom_va05>     TYPE char1.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*

* Begin of changes by Lahiru on 03/10/2020 ERPM-10485 with ED2K917757 *
TYPES : BEGIN OF ty_parvw_va05,         " for sold to customer nad partner function from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE parvw,         " Partner Function
          high TYPE parvw,         " Partner Function
        END OF ty_parvw_va05.

TYPES : BEGIN OF ty_vbtyp_n_va05,         " for document category from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE vbtyp_n,       " Document category
          high TYPE vbtyp_n,       " Document category
        END OF ty_vbtyp_n_va05.

TYPES : BEGIN OF ty_vbtyp_v_va05,         " " for document category from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE vbtyp_v,       " Document category
          high TYPE vbtyp_v,       " Document category
        END OF ty_vbtyp_v_va05.

DATA : li_const_va05    TYPE STANDARD TABLE OF ty_constant,
       lst_parvw_va05   TYPE ty_parvw_va05,
       lst_vbtyp_n_va05 TYPE ty_vbtyp_n_va05,
       lst_vbtyp_v_va05 TYPE ty_vbtyp_v_va05.

DATA : ir_parvw_va05   TYPE RANGE OF vbpa-parvw,      " Partner Function
       ir_vbtyp_n_va05 TYPE RANGE OF vbfa-vbtyp_n,    " Document category
       ir_vbtyp_v_va05 TYPE RANGE OF vbfa-vbtyp_v.    " Document category

DATA : li_vbap_tmp_va05   TYPE tdt_sw_vbap_key,
       li_doc_header_va05 TYPE tdt_sw_vbap_key.

DATA : lv_doctype_v             TYPE vbfa-vbtyp_n,                " purchasing document category
       lv_doctype_j             TYPE vbfa-vbtyp_n,                " Delivery document category
       lv_tablename             TYPE char4,                       " Table Name
       lv_fieldname             TYPE char5,                       " Field Name
*---Begin of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918275---*
       lir_lifnr_va05           TYPE fip_t_lifnr_range,     " forwading agent
       lir_ship2p_va05          TYPE kunnr_ran_itab,
       lv_bom_item_display_va05 TYPE char1,
       lv_ship2p_found_va05     TYPE char1,
       lv_forwarding_found_va05 TYPE char1,
       lv_payer_partner_va05    TYPE vbpa-parvw,
       lv_index_va05            TYPE sy-index,                " Index for ct_result table
       lv_field_va05_1          TYPE char5 VALUE 'VBELN',         " Document Number
       lv_field_va05_2          TYPE char5 VALUE 'POSNR'.         " Line item number
*---End of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918275---*

CONSTANTS : lc_devid_va05      TYPE zdevid     VALUE 'R052',       " WRICEF ID
            lc_parvw_va05      TYPE rvari_vnam VALUE 'PARVW',      " Partner function
            lc_posnr_va05      TYPE posnr      VALUE '000000',     " Line item
            lc_vbtyp_n_va05    TYPE rvari_vnam VALUE 'VBTYP_N',    " Document category
            lc_vbtyp_v_va05    TYPE rvari_vnam VALUE 'VBTYP_V',    " Document category
            lc_v               TYPE char1      VALUE 'V',          " Document category for purchasing
            lc_j               TYPE char1      VALUE 'J',          " Document category for Delivery
            lc_table           TYPE rvari_vnam VALUE 'TABLE',      " Table name
            lc_field           TYPE rvari_vnam VALUE 'FIELD',      " Field name
* End of changes by Lahiru on ERPM-10480 03/10/2020 ERPM-10485 with ED2K917757 *
*---Begin of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918275---*
            lc_ship2p_va05     TYPE parvw     VALUE 'WE',
            lc_forwarding_va05 TYPE parvw     VALUE 'SP',
            lc_paid_va05       TYPE string    VALUE 'Paid',
            lc_notpaid_va05    TYPE string    VALUE 'Not Paid',
            lc_rg_va05         TYPE parvw     VALUE 'RG',
            lc_solt2party_va05 TYPE parvw     VALUE 'AG'.
*---End of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918275---*

* Begin of changes by Lahiru on 10/02/2020 ERPM-10485 with ED2K917536 *
SELECT devid,
       param1,
       param2,
       srno,
       sign,
       opti,
       low ,
       high,
       activate
   FROM zcaconstant
   INTO TABLE @li_const_va05
   WHERE devid    = @lc_devid_va05    " WRICEF ID
   AND   activate = @abap_true.       " Only active record
IF sy-subrc IS INITIAL.
  SORT li_const_va05 BY param1.
  FREE : lv_doctype_v, lv_doctype_j, lv_tablename, lv_fieldname.
  LOOP AT li_const_va05 ASSIGNING FIELD-SYMBOL(<lfs_const_va05>).
    CASE <lfs_const_va05>-param1.
      WHEN lc_parvw_va05.                                      " Check partner type
        lst_parvw_va05-sign = <lfs_const_va05>-sign.
        lst_parvw_va05-opti = <lfs_const_va05>-opti.
        lst_parvw_va05-low  = <lfs_const_va05>-low.
        lst_parvw_va05-high = <lfs_const_va05>-high.
        IF <lfs_const_va05>-low = lc_rg_va05.                 " If partner function is payer,assign to local variable
          lv_payer_partner_va05   = <lfs_const_va05>-low.
        ENDIF.
        APPEND lst_parvw_va05 TO ir_parvw_va05.
      WHEN lc_vbtyp_n_va05.                                   " Check document category
        lst_vbtyp_n_va05-sign = <lfs_const_va05>-sign.
        lst_vbtyp_n_va05-opti = <lfs_const_va05>-opti.
        lst_vbtyp_n_va05-low  = <lfs_const_va05>-low.
        lst_vbtyp_n_va05-high = <lfs_const_va05>-high.
        APPEND lst_vbtyp_n_va05 TO ir_vbtyp_n_va05.
        IF  <lfs_const_va05>-low = lc_v.                      " Check PO document category and assign to local variable
          lv_doctype_v = <lfs_const_va05>-low.
        ELSEIF  <lfs_const_va05>-low = lc_j.                  " Check Outbound delivery document category and assign to local variable
          lv_doctype_j = <lfs_const_va05>-low.
        ENDIF.
      WHEN lc_vbtyp_v_va05.                                   " Check document category
        lst_vbtyp_v_va05-sign = <lfs_const_va05>-sign.
        lst_vbtyp_v_va05-opti = <lfs_const_va05>-opti.
        lst_vbtyp_v_va05-low  = <lfs_const_va05>-low.
        lst_vbtyp_v_va05-high = <lfs_const_va05>-high.
        APPEND lst_vbtyp_v_va05 TO ir_vbtyp_v_va05.
    ENDCASE.
    FREE : lst_parvw_va05 , lst_vbtyp_n_va05 , lst_vbtyp_v_va05.
  ENDLOOP.
  " Get Table name
  READ TABLE li_const_va05 ASSIGNING <lfs_const_va05> WITH KEY param1 = lc_table BINARY SEARCH.
  IF sy-subrc = 0.
    lv_tablename = <lfs_const_va05>-low.      " Table name
  ENDIF.
  " Get Field name
  READ TABLE li_const_va05 ASSIGNING <lfs_const_va05> WITH KEY param1 = lc_field BINARY SEARCH.
  IF sy-subrc = 0.
    lv_fieldname = <lfs_const_va05>-low.      " field name
  ENDIF.
ENDIF.
* End of changes by Lahiru on 10/02/2020 ERPM-10485 with ED2K917536 *

* Create Dynamic Table (Result)
CALL METHOD me->meth_create_dynamic_table
  EXPORTING
    im_ct_result = ct_result          "Current result table
  IMPORTING
    ex_dynamic_s = lo_dynamic_s_va05  "Data Reference (Structure)
    ex_dynamic_t = lo_dynamic_t_va05. "Data Reference (Table)
* Assignment of structure / internal table ref to the compatible field symbols
ASSIGN lo_dynamic_s_va05->* TO <lst_result_va05>.
ASSIGN lo_dynamic_t_va05->* TO <li_results_va05>.

* Fetch Selection Screen Details from ABAP Stack
* Billing Document
ASSIGN (lv_bill_docs_va05) TO <li_rng_tab_va05>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab_va05> TO lir_bill_doc_va05.
ENDIF. " IF sy-subrc EQ 0
* Billing Type
ASSIGN (lv_bill_type_va05) TO <li_rng_tab_va05>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab_va05> TO lir_bill_typ_va05.
ENDIF. " IF sy-subrc EQ 0
* Terms of Payment Key
ASSIGN (lv_paym_key_va05) TO <li_rng_tab_va05>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab_va05> TO lir_pay_term_va05.
ENDIF. " IF sy-subrc EQ 0
* Name of Person who Created the Object
ASSIGN (lv_crtd_name_va05) TO <li_rng_tab_va05>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab_va05> TO lir_crtd_nam_va05.
ENDIF. " IF sy-subrc EQ 0
* Date on Which Record Was Created
ASSIGN (lv_crtd_date_va05) TO <li_rng_tab_va05>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab_va05> TO lir_crtd_dat_va05.
ENDIF. " IF sy-subrc EQ 0
* Payer
ASSIGN (lv_payer_va05)     TO <li_rng_tab_va05>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab_va05> TO lir_payer_va05.
ENDIF. " IF sy-subrc EQ 0

*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
ASSIGN (lv_lifnr_va05) TO <li_rng_tab_va05>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab_va05> TO lir_lifnr_va05.
ENDIF.
ASSIGN (lv_ship2p_va05) TO <li_rng_tab_va05>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab_va05> TO lir_ship2p_va05.
ENDIF.
ASSIGN (lv_donot_bom_va05) TO <lv_bom_va05>.
IF sy-subrc = 0.
  MOVE <lv_bom_va05> TO lv_bom_item_display_va05.
ENDIF.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*


*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
IF ct_result IS NOT INITIAL.
  IF lv_bom_item_display_va05 = abap_true.
    REFRESH li_vbap_tmp_va05.
    MOVE-CORRESPONDING ct_result TO li_vbap_tmp_va05.                               " Assign result to temporary table
    SORT li_vbap_tmp_va05 BY vbeln posnr.                                           " Sort temp table
    DELETE ADJACENT DUPLICATES FROM li_vbap_tmp_va05 COMPARING vbeln posnr.         " Deleting duplicates

    SELECT vbeln,posnr,uepos                                  " Fetch BOM header level item
      FROM vbap INTO TABLE @DATA(li_bom_va05)
      FOR ALL ENTRIES IN @li_vbap_tmp_va05
      WHERE vbeln = @li_vbap_tmp_va05-vbeln
      AND   posnr = @li_vbap_tmp_va05-posnr
      AND   uepos = @space.
    IF sy-subrc = 0.
      SORT li_bom_va05 BY vbeln posnr.
      DELETE ADJACENT DUPLICATES FROM li_bom_va05 COMPARING vbeln posnr.

      CLEAR lv_index_va05.
      LOOP AT ct_result ASSIGNING <lst_result_va05>.
        lv_index_va05 = sy-tabix.                       " Current index assign to local variable
        ASSIGN COMPONENT lv_field_va05_1 OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_vbeln_uepos_va05>).    " Sales Document
        ASSIGN COMPONENT lv_field_va05_2 OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_posnr_uepos_va05>).    " Line Item number
        " Select only BOM header items
        READ TABLE li_bom_va05 ASSIGNING FIELD-SYMBOL(<lfs_bom_va05>) WITH KEY vbeln = <lv_vbeln_uepos_va05> posnr = <lv_posnr_uepos_va05> BINARY SEARCH.
        IF sy-subrc EQ 0.
          CONTINUE.                              " Continue Without taking any action
        ELSE.
          DELETE ct_result INDEX lv_index_va05.  " Delete current line of the itab
        ENDIF.
      ENDLOOP.
    ELSE.
      REFRESH ct_result.
    ENDIF.
  ENDIF.
ENDIF.

*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
IF ct_result IS NOT INITIAL.
  IF lir_lifnr_va05 IS NOT INITIAL OR lir_ship2p_va05 IS NOT INITIAL.  " Check selection screen Frieght forwarder/Ship to party is null
    " lir_ship2p added with ED2K918275
    REFRESH li_vbap_tmp_va05.
    MOVE-CORRESPONDING ct_result TO li_vbap_tmp_va05.                               " Assign result to tempory table
    SORT li_vbap_tmp_va05 BY vbeln posnr.                                           " Sort temp table
    DELETE ADJACENT DUPLICATES FROM li_vbap_tmp_va05 COMPARING vbeln posnr.         " Deleting duplicates

*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
    IF lir_lifnr_va05 IS NOT INITIAL.    " Selection screen field is empty
      " Fetch Forwarding agent/Ship to party/payer partner details
      SELECT vbeln,posnr,parvw,kunnr,lifnr,adrnr
        FROM vbpa INTO TABLE @DATA(li_vbpa_partner_va05)
        FOR ALL ENTRIES IN @li_vbap_tmp_va05
        WHERE vbeln = @li_vbap_tmp_va05-vbeln
        AND ( posnr = @li_vbap_tmp_va05-posnr OR posnr = @lc_posnr_va05 )
        AND  parvw IN @ir_parvw_va05
        AND  lifnr IN @lir_lifnr_va05.
    ENDIF.

    IF lir_ship2p_va05 IS NOT INITIAL.           " Selection screen field is empty
      " Fetch Ship to Party partner details
      SELECT vbeln,posnr,parvw,kunnr,lifnr,adrnr
        FROM vbpa APPENDING TABLE @li_vbpa_partner_va05
        FOR ALL ENTRIES IN @li_vbap_tmp_va05
        WHERE vbeln = @li_vbap_tmp_va05-vbeln
        AND ( posnr = @li_vbap_tmp_va05-posnr OR posnr = @lc_posnr_va05 )
        AND  parvw IN @ir_parvw_va05
        AND  kunnr IN @lir_ship2p_va05.

      " Fecth orders related all the ship to parties
      SELECT vbeln,posnr,parvw,kunnr,lifnr,adrnr
        FROM vbpa INTO TABLE @DATA(li_temp_sales_doc_va05)
        FOR ALL ENTRIES IN @li_vbpa_partner_va05
        WHERE vbeln = @li_vbpa_partner_va05-vbeln
        AND   parvw IN @ir_parvw_va05.

    ENDIF.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*

    IF sy-subrc IS INITIAL.
      SORT li_vbpa_partner_va05 BY parvw.
      DELETE li_vbpa_partner_va05 WHERE parvw EQ lv_payer_partner_va05.       " Delete the Payer partner function
      SORT li_vbpa_partner_va05 BY vbeln posnr parvw.
      DELETE ADJACENT DUPLICATES FROM li_vbpa_partner_va05 COMPARING vbeln posnr parvw.

**    " Separate the all line item entries from vbpa
      DATA(li_temp_sh_va05) = li_temp_sales_doc_va05[].
      SORT li_temp_sh_va05 BY posnr.
      DELETE li_temp_sh_va05 WHERE posnr EQ lc_posnr_va05.
      SORT li_temp_sh_va05 BY vbeln posnr parvw.

      CLEAR lv_index_va05.
      LOOP AT ct_result ASSIGNING <lst_result_va05>.

        CLEAR : lv_forwarding_found_va05 , lv_ship2p_found_va05 .
        lv_index_va05 = sy-tabix.                                                                           " Current index of CT_RESULT, assign to local variable
        ASSIGN COMPONENT lv_field_va05_1 OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_vbeln_tmp_va05>).    " Sales Document
        ASSIGN COMPONENT lv_field_va05_2 OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_posnr_tmp_va05>).    " Line Item number

        IF lir_lifnr_va05 IS NOT INITIAL.            " Check only Forwarding agent is passing from selection screen
          " select only header level forwarding agent
          READ TABLE li_vbpa_partner_va05 ASSIGNING FIELD-SYMBOL(<lfs_forwarding_hdr_va05>) WITH KEY vbeln = <lv_vbeln_tmp_va05>
                                                                                                     posnr = lc_posnr_va05
                                                                                                     parvw = lc_forwarding_va05 BINARY SEARCH.
          IF sy-subrc EQ 0.                         " Check whether value found
            lv_forwarding_found_va05 = abap_true.
            IF lir_ship2p_va05 IS NOT INITIAL.
              " Select ship to party based on document item data
              READ TABLE li_vbpa_partner_va05 ASSIGNING FIELD-SYMBOL(<lfs_ship_item_va05_1>) WITH KEY vbeln = <lv_vbeln_tmp_va05>
                                                                                                      posnr = <lv_posnr_tmp_va05>
                                                                                                      parvw = lc_ship2p_va05 BINARY SEARCH.
              IF sy-subrc EQ 0.                         " Check whether value found
                lv_ship2p_found_va05 = abap_true.
              ELSE.
                " Select ship to party based on document header data
                READ TABLE li_vbpa_partner_va05 ASSIGNING FIELD-SYMBOL(<lfs_ship_hdr_va05_1>) WITH KEY vbeln = <lv_vbeln_tmp_va05>
                                                                                                       posnr = lc_posnr_va05
                                                                                                       parvw = lc_ship2p_va05 BINARY SEARCH.
                IF sy-subrc NE 0.                            " Check whether value found
                  DELETE ct_result INDEX lv_index_va05.      " Delete current index of CT_RESULT
                  CONTINUE.
                ENDIF.
              ENDIF.
            ENDIF.
          ELSE.
            " Select based on document and l/item data
            READ TABLE li_vbpa_partner_va05 ASSIGNING FIELD-SYMBOL(<lfs_forwarding_itm_va05>) WITH KEY vbeln = <lv_vbeln_tmp_va05>
                                                                                                       posnr = <lv_posnr_tmp_va05>
                                                                                                       parvw = lc_forwarding_va05 BINARY SEARCH.
            IF sy-subrc NE 0.                       " Check whether value found
              lv_forwarding_found_va05 = abap_false.
            ELSE.
              lv_forwarding_found_va05 = abap_true.
              " Select ship to party based on document l/item data
              IF lir_ship2p IS NOT INITIAL.
                READ TABLE li_vbpa_partner_va05 ASSIGNING FIELD-SYMBOL(<lfs_ship_item_2_va05>) WITH KEY vbeln = <lv_vbeln_tmp_va05>
                                                                                                        posnr = <lv_posnr_tmp_va05>
                                                                                                        parvw = lc_ship2p_va05 BINARY SEARCH.
                IF sy-subrc EQ 0.                         " Check whether value found
                  lv_ship2p_found_va05 = abap_true.
                ELSE.
                  " Select ship to party based on document header data
                  READ TABLE li_vbpa_partner_va05 ASSIGNING FIELD-SYMBOL(<lfs_ship_hdr_2_va05>) WITH KEY vbeln = <lv_vbeln_tmp_va05>
                                                                                                         posnr = lc_posnr_va05
                                                                                                         parvw = lc_ship2p_va05 BINARY SEARCH.
                  IF sy-subrc NE 0.                            " Check whether value found
                    DELETE ct_result INDEX lv_index_va05.      " Delete current index of CT_RESULT
                    CONTINUE.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSE.
          " lv_forwarding_found = abap_false.
        ENDIF.

        IF lir_ship2p_va05 IS NOT INITIAL.           " Check only Ship to party is passing from selection screen
          " Select ship to party based on document and l/item data
          READ TABLE li_vbpa_partner_va05 ASSIGNING FIELD-SYMBOL(<lfs_ship_item_va05>) WITH KEY vbeln = <lv_vbeln_tmp_va05>
                                                                                                posnr = <lv_posnr_tmp_va05>
                                                                                                parvw = lc_ship2p_va05 BINARY SEARCH.
          IF sy-subrc EQ 0.
            " Sales document not found for given forwarding agent
            IF lir_lifnr_va05 IS NOT INITIAL AND lv_forwarding_found_va05 = abap_false.
              lv_ship2p_found_va05 = abap_false.
            ELSE.
              lv_ship2p_found_va05 = abap_true.
            ENDIF.                        " Check whether value found
          ELSE.
            " Select based on document and header data
            READ TABLE li_vbpa_partner_va05 ASSIGNING FIELD-SYMBOL(<lfs_ship_hdr_va05>) WITH KEY vbeln = <lv_vbeln_tmp_va05>
                                                                                                 posnr = lc_posnr_va05
                                                                                                 parvw = lc_ship2p_va05 BINARY SEARCH.
            IF sy-subrc NE 0.                           " Check whether value found
              lv_ship2p_found_va05 = abap_false.
            ELSE.
              " Sales document not found for given forwarding agent
              IF lir_lifnr_va05 IS NOT INITIAL AND lv_forwarding_found_va05 = abap_false.
                lv_ship2p_found_va05 = abap_false.
              ELSE.
                " Read only line item data for all details for
                READ TABLE li_temp_sh_va05 ASSIGNING FIELD-SYMBOL(<lfs_temp_sh_va05>) WITH KEY vbeln = <lv_vbeln_tmp_va05>
                                                                                               posnr = <lv_posnr_tmp_va05>
                                                                                               parvw = lc_ship2p_va05 BINARY SEARCH.
                IF sy-subrc = 0.
                  " Header level Ship to party and Line item level ship to party
                  IF <lfs_temp_sh_va05>-kunnr = <lfs_ship_hdr_va05>-kunnr.
                    lv_ship2p_found_va05 = abap_true.
                  ELSE.
                    DELETE ct_result INDEX lv_index_va05.          " Delete current index of CT_RESULT
                    CONTINUE.
                  ENDIF.
                ELSE.
                  lv_ship2p_found_va05 = abap_true.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSE.
          "
        ENDIF.
        " Delete current index of the CT_RESULT checking the status flag(Both Ship to party and forwarding agent sales document not found)
        IF lv_ship2p_found_va05 = abap_false AND lv_forwarding_found_va05 = abap_false.
          DELETE ct_result INDEX lv_index_va05.
        ENDIF.
      ENDLOOP.
*- Begin of changes by Lahiru on ERPM-9418/Defect - ERPM-13755 03/02/2020 with   ED2K917696 *
    ELSE.
      CLEAR ct_result[].
*- End of changes by Lahiru on ERPM-9418/Defect - ERPM-13755 03/02/2020 with   ED2K917696 *
    ENDIF.
  ENDIF.
ENDIF.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*


* Identify Sales Document and Sales Document Item
MOVE-CORRESPONDING ct_result TO li_vbap_keys_va05.
IF li_vbap_keys_va05 IS NOT INITIAL.
  SORT li_vbap_keys_va05 BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM li_vbap_keys_va05
            COMPARING vbeln posnr.
*** Select Data from VBRK and VBRP table
  SELECT vbfa~vbelv,
         vbfa~posnv,
         vbfa~vbeln,
         vbfa~posnn,
         vbfa~vbtyp_n,
         vbfa~stufe,
         vbrk~fkart,
         vbrk~fktyp,
         vbrk~fkdat,
         vbrk~gjahr,
         vbrk~poper,
         vbrk~konda,
         vbrk~kdgrp,
         vbrk~pltyp,
         vbrk~inco1,
         vbrk~zterm,
         vbrk~zlsch,
         vbrk~ktgrd,
         vbrk~netwr AS netwr_h,
         vbrk~zukri,
         vbrk~ernam,
         vbrk~erzet,
         vbrk~erdat,
         vbrk~kunrg,
         vbrk~stceg,
         vbrk~sfakn,
         vbrk~kurst,
         vbrk~mschl,
         vbrk~zuonr,
         vbrk~mwsbk,
         vbrk~kidno,
         vbrp~posnr,
         vbrp~uepos,
         vbrp~netwr AS netwr_i,
         vbrp~kzwi1,
         vbrp~kzwi2,
         vbrp~kzwi3,
         vbrp~kzwi4,
         vbrp~kzwi5,
         vbrp~kzwi6,
         vbrp~prctr,
         vbrp~txjcd,                         " Tax Jurisdiction
*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
         tvfkt~vtext,
         bsad~xblnr
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
    FROM vbfa INNER JOIN vbrk
    ON vbrk~vbeln EQ vbfa~vbeln
    INNER JOIN vbrp                         " Billing Document: Item Data
    ON vbfa~vbeln EQ vbrp~vbeln
    AND vbfa~posnn EQ vbrp~posnr
*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
    INNER JOIN tvfkt                       " Billing type description
     ON vbrk~fkart EQ tvfkt~fkart
     LEFT OUTER JOIN bsad                  "Customer payment cleared items
     ON vbfa~vbeln EQ bsad~xblnr
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
    INTO TABLE @DATA(li_inv_det_va05)
     FOR ALL ENTRIES IN @li_vbap_keys_va05
    WHERE vbfa~vbelv EQ @li_vbap_keys_va05-vbeln
    AND vbfa~posnv EQ @li_vbap_keys_va05-posnr
     AND vbfa~vbtyp_n IN @lir_docu_cat_va05 "Document category of subsequent document
     AND vbrk~vbeln   IN @lir_bill_doc_va05 "Billing Document
     AND vbrk~fkart   IN @lir_bill_typ_va05 "Billing Type
     AND vbrk~zterm   IN @lir_pay_term_va05
     AND vbrk~ernam   IN @lir_crtd_nam_va05 "Name of Person who Created the Object
     AND vbrk~erdat   IN @lir_crtd_dat_va05 "Date on Which Record Was Created
     AND vbrk~kunrg   IN @lir_payer_va05
*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
     AND tvfkt~spras  EQ @sy-langu.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
  IF sy-subrc EQ 0.
    SORT li_inv_det_va05 BY vbelv posnv vbtyp_n stufe.
    DELETE ADJACENT DUPLICATES FROM li_inv_det_va05
             COMPARING vbelv posnv vbtyp_n.
  ENDIF. " IF sy-subrc EQ 0
ENDIF. " IF li_vbap_keys_va05 IS NOT INITIAL

IF li_inv_det_va05 IS NOT INITIAL.
  LOOP AT ct_result ASSIGNING <lst_result_va05>.
    MOVE-CORRESPONDING <lst_result_va05> TO lst_vbap_key_va05.
    READ TABLE li_inv_det_va05 TRANSPORTING NO FIELDS
    WITH KEY vbelv = lst_vbap_key_va05-vbeln
             posnv = lst_vbap_key_va05-posnr
       BINARY SEARCH.
    IF sy-subrc = 0.
      LOOP AT li_inv_det_va05 ASSIGNING FIELD-SYMBOL(<lst_inv_det_va05>) FROM sy-tabix.
        IF <lst_inv_det_va05>-vbelv NE lst_vbap_key_va05-vbeln OR
           <lst_inv_det_va05>-posnv NE lst_vbap_key_va05-posnr.
          EXIT.
        ENDIF. " IF <lst_inv_det_va05>-vbelv NE lst_vbap_key_va05-vbeln OR


        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_vbeln
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_vbeln_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_vbeln_va05> = <lst_inv_det_va05>-vbeln.
          UNASSIGN: <lv_fld_vbeln_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_fkart
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_fkart_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_fkart_va05> = <lst_inv_det_va05>-fkart.
          UNASSIGN: <lv_fld_fkart_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_fktyp
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_fktyp_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_fktyp_va05> = <lst_inv_det_va05>-fktyp.
          UNASSIGN: <lv_fld_fktyp_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_fkdat
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_fkdat_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_fkdat_va05> = <lst_inv_det_va05>-fkdat.
          UNASSIGN: <lv_fld_fkdat_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_gjahr
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_gjahr_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_gjahr_va05> = <lst_inv_det_va05>-gjahr.
          UNASSIGN: <lv_fld_gjahr_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_poper
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_poper_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_poper_va05> = <lst_inv_det_va05>-poper.
          UNASSIGN: <lv_fld_poper_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_konda
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_konda_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_konda_va05> = <lst_inv_det_va05>-konda.
          UNASSIGN: <lv_fld_konda_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_kdgrp
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_kdgrp_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_kdgrp_va05> = <lst_inv_det_va05>-kdgrp.
          UNASSIGN: <lv_fld_kdgrp_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_pltyp
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_pltyp_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_pltyp_va05> = <lst_inv_det_va05>-pltyp.
          UNASSIGN: <lv_fld_pltyp_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_inco1
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_inco1_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_inco1_va05> = <lst_inv_det_va05>-inco1.
          UNASSIGN: <lv_fld_inco1_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_zterm
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_zterm_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_zterm_va05> = <lst_inv_det_va05>-zterm.
          UNASSIGN: <lv_fld_zterm_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_zlsch
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_zlsch_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_zlsch_va05> = <lst_inv_det_va05>-zlsch.
          UNASSIGN: <lv_fld_zlsch_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_ktgrd
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_ktgrd_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_ktgrd_va05> = <lst_inv_det_va05>-ktgrd.
          UNASSIGN: <lv_fld_ktgrd_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_netwr
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_netwr_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_netwr_va05> = <lst_inv_det_va05>-netwr_h.
          UNASSIGN: <lv_fld_netwr_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_zukri
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_zukri_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_zukri_va05> = <lst_inv_det_va05>-zukri.
          UNASSIGN: <lv_fld_zukri_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_ernam
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_ernam_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_ernam_va05> = <lst_inv_det_va05>-ernam.
          UNASSIGN: <lv_fld_ernam_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_erzet
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_erzet_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_erzet_va05> = <lst_inv_det_va05>-erzet.
          UNASSIGN: <lv_fld_erzet_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_erdat
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_erdat_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_erdat_va05> = <lst_inv_det_va05>-erdat.
          UNASSIGN: <lv_fld_erdat_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_kunrg
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_kunrg_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_kunrg_va05> = <lst_inv_det_va05>-kunrg.
          UNASSIGN: <lv_fld_kunrg_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_stceg
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_stceg_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_stceg_va05> = <lst_inv_det_va05>-stceg.
          UNASSIGN: <lv_fld_stceg_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_sfakn
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_sfakn_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_sfakn_va05> = <lst_inv_det_va05>-sfakn.
          UNASSIGN: <lv_fld_sfakn_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_kurst
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_kurst_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_kurst_va05> = <lst_inv_det_va05>-kurst.
          UNASSIGN: <lv_fld_kurst_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_mschl
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_mschl_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_mschl_va05> = <lst_inv_det_va05>-mschl.
          UNASSIGN: <lv_fld_mschl_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_zuonr
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_zuonr_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_zuonr_va05> = <lst_inv_det_va05>-zuonr.
          UNASSIGN: <lv_fld_zuonr_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_mwsbk
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_mwsbk_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_mwsbk_va05> = <lst_inv_det_va05>-mwsbk.
          UNASSIGN: <lv_fld_mwsbk_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_kidno
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_kidno_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_kidno_va05> = <lst_inv_det_va05>-kidno.
          UNASSIGN: <lv_fld_kidno_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_vbeln
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_vbeln2_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_vbeln2_va05> = <lst_inv_det_va05>-vbeln.
          UNASSIGN: <lv_fld_vbeln2_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_posnr
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_posnr_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_posnr_va05> = <lst_inv_det_va05>-posnr.
          UNASSIGN: <lv_fld_posnr_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_uepos
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_uepos_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_uepos_va05> = <lst_inv_det_va05>-uepos.
          UNASSIGN: <lv_fld_uepos_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_netwr
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_netwr2_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_netwr2_va05> = <lst_inv_det_va05>-netwr_i.
          UNASSIGN: <lv_fld_netwr2_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi1
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_kzwi1_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_kzwi1_va05> = <lst_inv_det_va05>-kzwi1.
          UNASSIGN: <lv_fld_kzwi1_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi2
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_kzwi2_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_kzwi2_va05> = <lst_inv_det_va05>-kzwi2.
          UNASSIGN: <lv_fld_kzwi2_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi3
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_kzwi3_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_kzwi3_va05> = <lst_inv_det_va05>-kzwi3.
          UNASSIGN: <lv_fld_kzwi3_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi4
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_kzwi4_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_kzwi4_va05> = <lst_inv_det_va05>-kzwi4.
          UNASSIGN: <lv_fld_kzwi4_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi5
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_kzwi5_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_kzwi5_va05> = <lst_inv_det_va05>-kzwi5.
          UNASSIGN: <lv_fld_kzwi5_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi6
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_kzwi6_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_kzwi6_va05> = <lst_inv_det_va05>-kzwi6.
          UNASSIGN: <lv_fld_kzwi6_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_prctr
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_prctr_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_prctr_va05> = <lst_inv_det_va05>-prctr.
          UNASSIGN: <lv_fld_prctr_va05>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_txjcd
            OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_fld_txjcd_va05>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_txjcd_va05> = <lst_inv_det_va05>-txjcd.
          UNASSIGN: <lv_fld_txjcd_va05>.
        ENDIF. " IF sy-subrc EQ 0


        APPEND <lst_result_va05> TO <li_results_va05>.
      ENDLOOP. " LOOP AT li_inv_det_va05 ASSIGNING FIELD-SYMBOL(<lst_inv_det_va05>) FROM sy-tabix
    ELSE. " ELSE -> IF sy-subrc = 0
*     Include record, if there is no Billing Doc level filter
      IF lir_docu_cat_va05[]   IS  INITIAL AND
         lir_bill_doc_va05[]   IS  INITIAL AND
         lir_bill_typ_va05[]   IS  INITIAL AND
         lir_crtd_nam_va05[]   IS  INITIAL AND
         lir_crtd_dat_va05[]   IS  INITIAL AND
         lir_payer_va05[]      IS  INITIAL.

        APPEND <lst_result_va05> TO <li_results_va05>.

      ENDIF. " IF lir_docu_cat_va05[] IS INITIAL AND

    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT ct_result ASSIGNING <lst_result_va05>

  ct_result = <li_results_va05>.
ELSE. " ELSE -> IF li_inv_det_va05 IS NOT INITIAL
* Check for Billing Doc level filter
  IF lir_docu_cat_va05 IS NOT INITIAL OR
     lir_bill_doc_va05 IS NOT INITIAL OR
     lir_bill_typ_va05 IS NOT INITIAL OR
     lir_crtd_nam_va05 IS NOT INITIAL OR
     lir_crtd_dat_va05 IS NOT INITIAL OR
     lir_payer_va05    IS NOT INITIAL.
    CLEAR: ct_result.
  ENDIF. " IF lir_docu_cat_va05 IS NOT INITIAL OR
ENDIF. " IF li_inv_det_va05 IS NOT INITIAL

** Begin of Changes by Lahiru on ERPM-10485 03/10/2020 with ED2K917757 **
IF ct_result IS NOT INITIAL.

  MOVE-CORRESPONDING ct_result TO li_vbap_tmp_va05.                             " Assign result to temporary table
  MOVE-CORRESPONDING ct_result TO li_doc_header_va05.                           " Assign result to temporary table to read header data
  SORT li_vbap_tmp_va05 BY vbeln posnr.                                         " Sort temporary table
  DELETE ADJACENT DUPLICATES FROM li_vbap_tmp_va05 COMPARING vbeln posnr.       " Deleting duplicates

** Begin of ERPM-10485 UAT Changes added with ED2K917910
* Previous query only ran for VBAP table.Joined ADRC table with VBPA to fetch the forwarding agent name
  " b~name1,b~name2,b~name3,b~name4,b~street, b~city1,b~post_code1,b~country with ED2K918275

  SELECT a~vbeln,a~posnr,a~parvw,a~kunnr,a~lifnr,a~adrnr,b~name1,b~name2,b~name3,b~name4,b~street,
         b~city1,b~post_code1,b~country        " Select vendor code /ship to party/ payer /sold to party
      FROM vbpa AS a INNER JOIN adrc AS b
      ON b~addrnumber = a~adrnr
      INTO TABLE @DATA(li_vbpa_vendor_temp_va05)
      FOR ALL ENTRIES IN @li_vbap_tmp_va05
      WHERE vbeln = @li_vbap_tmp_va05-vbeln   AND
            ( posnr = @li_vbap_tmp_va05-posnr OR posnr = @lc_posnr_va05 ) AND
            parvw IN @ir_parvw_va05.  " sold to party/ship to party/payer/forwading agent
  IF sy-subrc IS INITIAL.
*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
    DATA(li_payer_va05) = li_vbpa_vendor_temp_va05[].
    SORT li_vbpa_vendor_temp_va05 BY parvw.
    DELETE li_vbpa_vendor_temp_va05 WHERE parvw EQ lv_payer_partner_va05.                " Delete the payer partner function
    SORT li_vbpa_vendor_temp_va05 BY vbeln posnr parvw.                             " Delete duplicate values
    DELETE ADJACENT DUPLICATES FROM li_vbpa_vendor_temp_va05 COMPARING vbeln posnr parvw.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
  ENDIF.
** End of ERPM-10485 UAT Changes added with ED2K917910

  " Select document category V and J related data
  SELECT vbelv,posnv,vbeln,vbtyp_n
    FROM vbfa INTO TABLE @DATA(li_vbfa_vbtyp_n)
    FOR ALL ENTRIES IN @li_vbap_tmp_va05
    WHERE vbelv = @li_vbap_tmp_va05-vbeln   AND
          posnv = @li_vbap_tmp_va05-posnr   AND
          vbtyp_n IN @ir_vbtyp_n_va05.
  IF sy-subrc IS INITIAL.
    DATA(li_vbtyp_v) = li_vbfa_vbtyp_n.                     " Purchase order related data assign to temporary table
    SORT li_vbtyp_v BY vbtyp_n.
    DELETE li_vbtyp_v WHERE vbtyp_n NE lv_doctype_v.

    IF li_vbtyp_v IS NOT INITIAL.
      SORT li_vbtyp_v BY vbelv posnv.
      " Fetch purchase order header data.
      SELECT ebeln,bedat
        FROM ekko INTO TABLE @DATA(li_ekko)
        FOR ALL ENTRIES IN @li_vbtyp_v
        WHERE ebeln = @li_vbtyp_v-vbeln.
    ENDIF.

    DATA(li_vbtyp_j) = li_vbfa_vbtyp_n.                     " Outbound delivery related data
    SORT li_vbtyp_j BY vbtyp_n.
    DELETE li_vbtyp_j WHERE vbtyp_n NE lv_doctype_j.
    IF li_vbtyp_j IS NOT INITIAL.
      SORT li_vbtyp_j BY vbelv posnv.
      " Fetch outbound delivery header data.
      SELECT vbeln,bldat
        FROM likp INTO TABLE @DATA(li_likp)
        FOR ALL ENTRIES IN @li_vbtyp_j
        WHERE vbeln = @li_vbtyp_j-vbeln.
    ENDIF.
  ENDIF.

  " Delete duplicate to read the header data
  SORT li_doc_header_va05 BY vbeln.
  DELETE ADJACENT DUPLICATES FROM li_doc_header_va05 COMPARING vbeln.

  " Fetch Shipping condition
  SELECT a~vbeln,a~vsbed,b~vtext
    FROM vbak AS a INNER JOIN tvsbt AS b
    ON b~vsbed = a~vsbed
    INTO TABLE @DATA(li_tvsbt)
    FOR ALL ENTRIES IN @li_doc_header_va05
    WHERE a~vbeln = @li_doc_header_va05-vbeln   AND
          b~spras = @sy-langu.

  " Fetch release order related 1st level contract data
  SELECT a~vbelv,a~vbeln,b~auart
    FROM vbfa AS a INNER JOIN vbak AS b
    ON b~vbeln = a~vbelv
    INTO TABLE @DATA(li_vbak)
    FOR ALL ENTRIES IN @li_doc_header_va05
    WHERE a~vbeln = @li_doc_header_va05-vbeln  AND
          a~vbtyp_v IN @ir_vbtyp_v_va05        AND
          a~stufe = @space." Level is blank

  "Fetch overall credit status and description
  SELECT a~vbeln,a~cmgst,b~bezei
    FROM vbuk AS a INNER JOIN tvbst AS b
    ON b~statu = a~cmgst
    INTO TABLE @DATA(li_tvbst)
    FOR ALL ENTRIES IN @li_doc_header_va05
    WHERE a~vbeln = @li_doc_header_va05-vbeln    AND
          b~spras = @sy-langu                    AND
          b~tbnam = @lv_tablename                AND
          b~fdnam = @lv_fieldname.

*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
  SORT li_payer_va05 BY parvw.
  DELETE li_payer_va05 WHERE parvw NE lv_payer_partner_va05.      " Delete the payer partner function not equal records
  IF li_payer_va05 IS NOT INITIAL.                                " Check whether Payer details not initial.
    SORT li_payer_va05 BY posnr.
    DELETE li_payer_va05 WHERE posnr NE lc_posnr_va05.            " Delete line item records.
    SORT li_payer_va05 BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM li_payer_va05 COMPARING vbeln posnr.

    " fetch payers related credit limit Considering Header data
    SELECT a~partner,
           a~credit_limit,
           b~vbeln,
           b~kkber
        FROM ukmbp_cms_sgm AS a
        INNER JOIN vbak AS b
        ON a~credit_sgmnt EQ b~kkber
        INTO TABLE @DATA(li_creditlimit_va05)
        FOR ALL ENTRIES IN @li_payer_va05
        WHERE a~partner = @li_payer_va05-kunnr
        AND   b~vbeln = @li_payer_va05-vbeln.
    IF sy-subrc = 0.
      " Nothing to do
    ENDIF.
  ENDIF.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*


  " Sort Itab for data reading
  SORT li_vbfa_vbtyp_n BY vbelv posnv vbtyp_n.
  SORT li_ekko BY ebeln.
  SORT li_likp BY vbeln.
  SORT li_tvsbt BY vbeln.
  SORT li_vbak BY vbeln.
  SORT li_tvbst BY vbeln.
*---Begin of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918275---*
  SORT li_inv_det_va05 BY vbeln.
  SORT li_creditlimit_va05 BY vbeln.
*---End of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918275---*

  LOOP AT ct_result ASSIGNING <lst_result_va05>.

    ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_vbeln
                  OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_vbeln_va05>).  " Document number

    ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_posnr
              OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_posnr_va05>).      " Document line number

*************** Begin of ERPM-10485 UAT Changes added with ED2K917910
    "Forwarding agent details
    IF li_vbpa_vendor_temp_va05 IS NOT INITIAL.   " Checking partner fecth details is not initial
      " Read vendor data with line item
      READ TABLE li_vbpa_vendor_temp_va05 ASSIGNING FIELD-SYMBOL(<lfs_vbpa_vendor_va05>) WITH KEY vbeln = <lv_vbeln_va05>
                                                                                                  posnr = <lv_posnr_va05>
                                                                                                  parvw = lc_forwarding_va05
                                                                                                  BINARY SEARCH.
      IF sy-subrc NE 0.
        " Read vendor data with only header
        READ TABLE li_vbpa_vendor_temp_va05 ASSIGNING <lfs_vbpa_vendor_va05> WITH KEY vbeln = <lv_vbeln_va05>
                                                                                      posnr = lc_posnr_va05
                                                                                      parvw = lc_forwarding_va05
                                                                                      BINARY SEARCH.
      ENDIF.
      IF sy-subrc EQ 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbpa_lifnr
                     OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_lifnr_va05>).
        IF sy-subrc EQ 0.
          <lv_lifnr_va05> = <lfs_vbpa_vendor_va05>-lifnr.       " Forwarding agent code
          UNASSIGN: <lv_lifnr_va05>.
        ENDIF.

        " Assign Forwarding agent name
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_name
                  OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_name_fw_va05>).
        IF sy-subrc EQ 0.
          <lv_name_fw_va05> = <lfs_vbpa_vendor_va05>-name1.
          UNASSIGN: <lv_name_fw_va05>.
        ENDIF.
*************** End of ERPM-10485 UAT Changes added with ED2K917910

*---Begin of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918275---*
        " Assign Street
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_street
                  OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_street_fw_va05>).
        IF sy-subrc EQ 0.
          <lv_street_fw_va05> = <lfs_vbpa_vendor_va05>-street.
          UNASSIGN: <lv_street_fw_va05>.
        ENDIF.
        " Assign City
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_ort01
                  OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_ort01_fw_va05>).
        IF sy-subrc EQ 0.
          <lv_ort01_fw_va05> = <lfs_vbpa_vendor_va05>-city1.
          UNASSIGN: <lv_ort01_fw_va05>.
        ENDIF.
        " Assign postal code
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_postal
                  OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_postal_fw_va05>).
        IF sy-subrc EQ 0.
          <lv_postal_fw_va05> = <lfs_vbpa_vendor_va05>-post_code1.
          UNASSIGN: <lv_postal_fw_va05>.
        ENDIF.
        " Assign country code
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_land1
                  OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_land1_fw_va05>).
        IF sy-subrc EQ 0.
          <lv_land1_fw_va05> = <lfs_vbpa_vendor_va05>-country.
          UNASSIGN: <lv_land1_fw_va05>.
        ENDIF.
      ENDIF.

      " Read shipto party data with line item
      READ TABLE li_vbpa_vendor_temp_va05 ASSIGNING FIELD-SYMBOL(<lfs_vbpa_vendor_va05_sh>) WITH KEY vbeln = <lv_vbeln_va05>
                                                                                                     posnr = <lv_posnr_va05>
                                                                                                     parvw = lc_ship2p_va05
                                                                                                     BINARY SEARCH.
      IF sy-subrc NE 0.
        " Read shipto party data with only header
        READ TABLE li_vbpa_vendor_temp_va05 ASSIGNING <lfs_vbpa_vendor_va05_sh> WITH KEY vbeln = <lv_vbeln_va05>
                                                                                         posnr = lc_posnr_va05
                                                                                         parvw = lc_ship2p_va05
                                                                                         BINARY SEARCH.
      ENDIF.
      IF sy-subrc EQ 0.
        " ship to party code
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto
                     OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_ship_va05>).
        IF sy-subrc EQ 0.
          <lv_ship_va05> = <lfs_vbpa_vendor_va05_sh>-kunnr.
          UNASSIGN: <lv_ship_va05>.
        ENDIF.

        " Assign ship to party name1
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto_name1
                  OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_shipname1_va05>).
        IF sy-subrc EQ 0.
          <lv_shipname1_va05> = <lfs_vbpa_vendor_va05_sh>-name1.
          UNASSIGN: <lv_shipname1_va05>.
        ENDIF.

        " Assign ship to party name2
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto_name2
                  OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_shipname2_va05>).
        IF sy-subrc EQ 0.
          CONCATENATE <lfs_vbpa_vendor_va05_sh>-name2 <lfs_vbpa_vendor_va05_sh>-name3 <lfs_vbpa_vendor_va05_sh>-name4 INTO <lv_shipname2_va05> SEPARATED BY space.
          UNASSIGN: <lv_shipname2_va05>.
        ENDIF.

      ENDIF.

      " Read shipto party data with line item
      READ TABLE li_vbpa_vendor_temp_va05 ASSIGNING FIELD-SYMBOL(<lfs_vbpa_vendor_va05_sold>) WITH KEY vbeln = <lv_vbeln_va05>
                                                                                                       posnr = <lv_posnr_va05>
                                                                                                       parvw = lc_ship2p_va05
                                                                                                       BINARY SEARCH.
      IF sy-subrc NE 0.
        " Read shipto party data with only header
        READ TABLE li_vbpa_vendor_temp_va05 ASSIGNING <lfs_vbpa_vendor_va05_sold> WITH KEY vbeln = <lv_vbeln_va05>
                                                                                           posnr = lc_posnr_va05
                                                                                           parvw = lc_solt2party_va05
                                                                                           BINARY SEARCH.
      ENDIF.
      IF sy-subrc EQ 0.
        " Assign sold to party name2
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-slodto_name2
                  OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_soldname2_va05>).
        IF sy-subrc EQ 0.
          CONCATENATE <lfs_vbpa_vendor_va05_sold>-name2 <lfs_vbpa_vendor_va05_sold>-name3 <lfs_vbpa_vendor_va05_sold>-name4 INTO <lv_soldname2_va05> SEPARATED BY space.
          UNASSIGN: <lv_soldname2_va05>.
        ENDIF.

      ENDIF.
*---End of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918275---*
    ENDIF.

    "Purchasing document
    IF li_vbfa_vbtyp_n IS NOT INITIAL.
      READ TABLE li_vbfa_vbtyp_n ASSIGNING FIELD-SYMBOL(<lfs_vbfa_vbtyp_n>) WITH KEY vbelv = <lv_vbeln_va05> posnv = <lv_posnr_va05> vbtyp_n = lv_doctype_v BINARY SEARCH.
      IF sy-subrc = 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-ekko_ebeln
                     OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_ebeln_va05>).
        IF sy-subrc EQ 0.
          <lv_ebeln_va05> = <lfs_vbfa_vbtyp_n>-vbeln.       " Purchasing document number
          UNASSIGN: <lv_ebeln_va05>.
        ENDIF.
        "Purchasing document date
        IF li_ekko IS NOT INITIAL.
          READ TABLE li_ekko ASSIGNING FIELD-SYMBOL(<lfs_ekko>) WITH KEY ebeln = <lfs_vbfa_vbtyp_n>-vbeln BINARY SEARCH.
          IF sy-subrc = 0.
            ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-po_date
                         OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_podate_va05>).
            IF sy-subrc EQ 0.
              <lv_podate_va05> = <lfs_ekko>-bedat.          " Purchasing document date
              UNASSIGN: <lv_podate_va05>.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    "Outbound delivery document
    IF li_vbfa_vbtyp_n IS NOT INITIAL.
      READ TABLE li_vbfa_vbtyp_n  ASSIGNING FIELD-SYMBOL(<lfs_vbfa_vbtyp_n_del>) WITH KEY vbelv = <lv_vbeln_va05> posnv = <lv_posnr_va05> vbtyp_n = lv_doctype_j BINARY SEARCH.
      IF sy-subrc = 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-likp_vbeln
                     OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_del_vbeln_va05>).
        IF sy-subrc EQ 0.
          <lv_del_vbeln_va05> = <lfs_vbfa_vbtyp_n_del>-vbeln.       " Outbound delivery number
          UNASSIGN: <lv_del_vbeln_va05>.
        ENDIF.
        "Delivery date
        IF li_likp IS NOT INITIAL.
          READ TABLE li_likp ASSIGNING FIELD-SYMBOL(<lfs_likp>) WITH KEY vbeln = <lfs_vbfa_vbtyp_n_del>-vbeln BINARY SEARCH.
          IF sy-subrc = 0.
            ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-del_date
                         OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_deldate_va05>).
            IF sy-subrc EQ 0.
              <lv_deldate_va05> = <lfs_likp>-bldat.       " outbound delivery date
              UNASSIGN: <lv_deldate_va05>.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    "Shipping condition
    IF li_tvsbt IS NOT INITIAL.
      READ TABLE li_tvsbt  ASSIGNING FIELD-SYMBOL(<lfs_tvsbt>) WITH KEY vbeln = <lv_vbeln_va05> BINARY SEARCH.
      IF sy-subrc = 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-ship_cond
                     OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_shpcond_va05>).
        IF sy-subrc EQ 0.
          <lv_shpcond_va05> = <lfs_tvsbt>-vtext.          " Shipping condition text
          UNASSIGN: <lv_shpcond_va05>.
        ENDIF.
      ENDIF.
    ENDIF.

    "Subscription Order type
    IF li_vbak IS NOT INITIAL.
      READ TABLE li_vbak ASSIGNING FIELD-SYMBOL(<lfs_vbak>) WITH KEY vbeln = <lv_vbeln_va05> BINARY SEARCH.
      IF sy-subrc = 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-order_type
                     OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_auart_va05>).
        IF sy-subrc EQ 0.
          <lv_auart_va05> = <lfs_vbak>-auart.       " Subscription order type
          UNASSIGN: <lv_auart_va05>.
        ENDIF.
      ENDIF.
    ENDIF.

    "Credit status and description
    IF li_tvbst IS NOT INITIAL.
      READ TABLE li_tvbst ASSIGNING FIELD-SYMBOL(<lfs_tvbst>) WITH KEY vbeln = <lv_vbeln_va05> BINARY SEARCH.
      IF sy-subrc = 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-credit_stat
                     OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_cmgst_va05>).
        IF sy-subrc EQ 0.
          <lv_cmgst_va05> = <lfs_tvbst>-cmgst.           " credit status
          UNASSIGN: <lv_cmgst_va05>.
        ENDIF.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-credit_desc
                     OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_credes_va05>).
        IF sy-subrc EQ 0.
          <lv_credes_va05> = <lfs_tvbst>-bezei.     " Credit status description
          UNASSIGN: <lv_credes_va05>.
        ENDIF.
      ENDIF.
    ENDIF.

*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
    " Read Payer credit limit
    IF li_creditlimit_va05 IS NOT INITIAL.
      READ TABLE li_creditlimit_va05 ASSIGNING FIELD-SYMBOL(<lfs_creditlimit_va05>) WITH KEY vbeln = <lv_vbeln_va05> BINARY SEARCH.
      IF sy-subrc = 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-cr_limit
                  OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_crlimit_va05>).
        IF sy-subrc = 0.
          <lv_crlimit_va05> = <lfs_creditlimit_va05>-credit_limit.           " Credit limit
          UNASSIGN:<lv_crlimit_va05>.
        ENDIF.
      ENDIF.
    ENDIF.

    " Read Invoice type description and Payement settle or not
    IF li_inv_det_va05 IS NOT INITIAL.
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_vbeln
                    OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_billing_va05>).
      IF sy-subrc = 0.
        READ TABLE li_inv_det_va05 ASSIGNING FIELD-SYMBOL(<lfs_inv_det_va05>) WITH KEY vbeln = <lv_billing_va05> BINARY SEARCH.
        IF sy-subrc = 0.
          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-bill_desc
                          OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_billdesc_va05>).
          IF sy-subrc EQ 0.
            <lv_billdesc_va05> = <lfs_inv_det_va05>-vtext.           " Billing type description
            UNASSIGN: <lv_billdesc_va05>.
          ENDIF.

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-paid_status
                          OF STRUCTURE <lst_result_va05> TO FIELD-SYMBOL(<lv_pstatus_va05>).
          IF sy-subrc EQ 0.
            IF <lfs_inv_det_va05>-xblnr IS INITIAL.
              <lv_pstatus_va05> = lc_notpaid_va05.        " Not Paid
            ELSE.
              <lv_pstatus_va05> = lc_paid_va05.           " Paid
            ENDIF.
            UNASSIGN: <lv_pstatus_va05>.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918275---*
  ENDLOOP.

ENDIF.
** End of Changes by Lahiru on ERPM-10485 03/10/2020 with ED2K917757 **
