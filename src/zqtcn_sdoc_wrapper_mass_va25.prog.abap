*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SDOC_WRAPPER_MASS_VA25 (Include Program)
* PROGRAM DESCRIPTION: Add new fields in VA25
* DEVELOPER: Mounika Nallapaneni (nmounika)
* CREATION DATE:   06/24/2017
* OBJECT ID: R054
* TRANSPORT NUMBER(S): ED2K906855
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907425
* REFERENCE NO:  ERP-3393
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-07-21
* DESCRIPTION: When there were no subsequent documents for the quote no
*              data is being displayed currently. Ideally it should display
*              quote details even if no subsequent reference document exists.
*              Input in this is only quote.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K917574
* REFERENCE NO:  ERPM-9418
* WRICEF ID: R054
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  02/17/2020
* DESCRIPTION: Add frieght forwarding agent for selection and report output
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K917702
* REFERENCE NO:  ERPM-9418/Defect - ERPM-13755
* WRICEF ID: R050
* DEVELOPER: Siva Guda (SGUDA)
* DATE:  03/02/2020
* DESCRIPTION: Add frieght forwarding agent for selection and report outpu
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:ED2K918259
* REFERENCE NO:  ERPM-14773
* WRICEF ID: R054
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  05/21/2020
* DESCRIPTION: Add new selection screen fields and output fields
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918842
* REFERENCE NO:  ERPM-21199
* WRICEF ID: R054
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  07/09/2020
* DESCRIPTION: Add new selection screen fields and output fields
* Please note : Add validity period selection and validity dates selection logic
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K919313/ED2K919317
* REFERENCE NO:  INC0308014
* WRICEF ID: R054
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  08/31/2020
* DESCRIPTION: Address the PRD issue for incident INC0308014
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO : ED2K924869
* REFERENCE NO: OTCM-54011
* WRICEF ID   : R054
* DEVELOPER   : VDPATABALL
* DATE        : 10/29/2021
* DESCRIPTION : Indian Agent Changes for Unrenewed Quotation list
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO : ED2K925479
* REFERENCE NO: OTCM-54011
* WRICEF ID   : R054
* DEVELOPER   : VDPATABALL
* DATE        : 01/10/2022
* DESCRIPTION : Indian Agent Changes for Unrenewed Quotation list. Add
*               Ship to Address Fields
*---------------------------------------------------------------------*
*&  Include           ZQTCN_SDOC_WRAPPER_MASS_VA25
*&---------------------------------------------------------------------*

* Local Type Declaration
**********************************************************************
TYPES: BEGIN OF lty_vbtyp_n,
         sign   TYPE char1,      " Sign of type CHAR1
         option TYPE char2,      " Option of type CHAR2
         low    TYPE vbtyp_n,    " Terms of Payment Key
         high   TYPE vbtyp_n,    " Terms of Payment Key
       END OF lty_vbtyp_n,
       BEGIN OF lty_vbeln,
         sign   TYPE char1,      " Sign of type CHAR1
         option TYPE char2,      " Option of type CHAR2
         low    TYPE vbeln_nach, " Terms of Payment Key
         high   TYPE vbeln_nach, " Terms of Payment Key
       END OF lty_vbeln.
**********************************************************************

* Begin of changes by Lahiru on 02/17/2020 with ED2K917574 *
TYPES: BEGIN OF ty_constant_va25,
         devid    TYPE zdevid,              "Development ID
         param1   TYPE rvari_vnam,          "Parameter1
         param2   TYPE rvari_vnam,          "Parameter2
         srno     TYPE tvarv_numb,          "Serial Number
         sign     TYPE tvarv_sign,          "Sign
         opti     TYPE tvarv_opti,          "Option
         low      TYPE salv_de_selopt_low,  "Low
         high     TYPE salv_de_selopt_high, "High
         activate TYPE zconstactive,        "Active/Inactive Indicator
       END OF ty_constant_va25.

TYPES : BEGIN OF ty_parvw_va25,    " for sold to customer nad partner function from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE parvw,         " Partner Function
          high TYPE parvw,         " Partner Function
        END OF ty_parvw_va25.

**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918842 ****
TYPES : BEGIN OF ty_veda_va25,
          vbeln   TYPE vbeln_va,
          vposn   TYPE posnr_va,
          vbegdat TYPE vbdat_veda,
          venddat TYPE vndat_veda,
        END OF ty_veda_va25.
*---BOC VDPATABALL 10/29/2021 ED2K924869 OTC-49605 Range Table
TYPES: BEGIN OF lty_bsark,
         sign   TYPE char1,      " Sign of type CHAR1
         option TYPE char2,      " Option of type CHAR2
         low    TYPE bsark,      " PO type
         high   TYPE bsark,      " PO type
       END OF lty_bsark.
DATA:lv_po_type_va25  TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA25)S_BSARK[]', " PO Type
     lv_unren_va25    TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA25)CH_UNREN',
     lv_unren_check   TYPE char1,
     lir_po_type_va25 TYPE STANDARD TABLE OF lty_bsark, " PO Type
     lst_po_type_va25 TYPE lty_bsark.                   " PO Type

*---EOC VDPATABALL 10/29/2021 ED2K924869 OTC-49605 Range Table
DATA : li_veda_va25 TYPE STANDARD TABLE OF ty_veda_va25.
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918842 ****

DATA : li_const_va25  TYPE STANDARD TABLE OF ty_constant_va25,
       lst_parvw_va25 TYPE ty_parvw_va25.

DATA : ir_parvw_va25 TYPE RANGE OF vbpa-parvw.  " Partner Function

FIELD-SYMBOLS : <gfs_constant_va25> TYPE ty_constant_va25.

CONSTANTS : c_devid_va25       TYPE zdevid   VALUE 'R054',    " WRICEF ID
            c_x_va25           TYPE char1    VALUE 'X',       " Active records
            lc_parvw_va25      TYPE rvari_vnam VALUE 'PARVW',  " Partner function
            lc_posnr_va25      TYPE posnr     VALUE '000000',
* End of changes by Lahiru on 02/17/2020 with ED2K917574 *

*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*
            lc_ship2p_va25     TYPE parvw      VALUE 'WE',         " Ship to party
            lc_forwarding_va25 TYPE parvw      VALUE 'SP',         " Forwarding agent
            lc_table_va25      TYPE rvari_vnam VALUE 'TABLE',      " Table name
            lc_field_va25      TYPE rvari_vnam VALUE 'FIELD',      " Field name
            lc_doc_cat_va25    TYPE rvari_vnam VALUE 'VBTYP_N',    " Document category
            lc_rg_va25         TYPE parvw      VALUE 'RG',         " Payer
            lc_solt2party_va25 TYPE parvw      VALUE 'AG'.         " Sold to party
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*

* Local Internal table Declaration
**********************************************************************
*  Range table
DATA: lir_vbtyp_n_va25  TYPE  STANDARD TABLE OF lty_vbtyp_n,
      lir_vbeln_va25    TYPE  STANDARD TABLE OF lty_vbeln,
      lst_vbty_n        TYPE lty_vbtyp_n,
      lst_vbeln         TYPE STANDARD TABLE OF lty_vbeln,
* Begin of Insert by PBANDLAPAL on 21-Jul-2017 for ERP-3393
      lv_sdoccat_f      TYPE vbtyp_n,         " Subsequent Document Category Flag
* End of Insert by PBANDLAPAL on 21-Jul-2017 for ERP-3393
      li_vbap_keys_va25 TYPE tdt_sw_vbap_key, "Keys - Sales Document Item (VBAP)

**********************************************************************
* Local Variable Declaration for fetching value from stack
**********************************************************************
      lv_sub_docs_va25  TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA25)s_vbty_n[]', "Sub document category
      lv_foll_doc_va25  TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA25)s_vbeln[]',  "Follow on document **********************************************************************

* Local Structure Declaration
**********************************************************************

      lst_vbap_key_va25 TYPE tds_sw_vbap_key, "Key Structure for VBAP

**********************************************************************
* Local Object declaration
**********************************************************************
      lo_dynamic_s_va25 TYPE REF TO data, "Data Reference (Structure)
      lo_dynamic_t_va25 TYPE REF TO data. "Data Reference (Table)

* Begin of changes by Lahiru on 17/02/2020 with  ED2K917574 *
DATA : lv_field_va25_1      TYPE char5  VALUE 'VBELN',    " Document Number
       lv_field_va25_2      TYPE char5  VALUE 'POSNR',    " Line item number
*----BOC VDPATABALL 10/29/2021 ED2K924869 OTC-49605
       lv_field_va25_3      TYPE char5  VALUE 'ERDAT', " Creation date
       lv_field_va25_4      TYPE char5  VALUE 'KUNNR', " Sold To
       lv_field_va25_5      TYPE char10 VALUE 'NAME_KUNAG', " Sold To Name
       lv_field_va25_6      TYPE char6  VALUE 'SHIPTO', "Ship To
       lv_field_va25_7      TYPE char12 VALUE 'SHIPTO_NAME1', " Ship To Name
       lv_field_va25_8      TYPE char5  VALUE 'BSTNK', " Purchase Order Number
       lv_field_va25_10     TYPE char5  VALUE 'NETWR', " Header Total Value
       lv_field_va25_12     TYPE char5  VALUE 'MATNR', " MAterial
       lv_field_va25_13     TYPE char5  VALUE 'ARKTX', " MAterial Description
       lv_field_va25_14     TYPE char6  VALUE 'KWMENG', " Quantity
       lv_field_va25_15     TYPE char10 VALUE 'VBAP_NETWR', " Price
       lv_field_va25_16     TYPE char10 VALUE 'VBAP_KZWI6', " Tax Line Item
       lv_field_va25_17     TYPE char10 VALUE 'VBAK_KZWI6', " Tax Header
       lv_field_va25_18     TYPE char10 VALUE 'VBKD_KDKG2', " Condition Grp2
       lv_field_va25_21     TYPE char10 VALUE 'KONV_KBETR', " Condition Type
       lv_field_va25_19     TYPE char7  VALUE 'VBEGDAT', " Start date
       lv_field_va25_20     TYPE char7  VALUE 'VENDDAT', " End date
*----EOC VDPATABALL 10/29/2021 ED2K924869 OTC-49605
*----BOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
       lv_field_va25_22     TYPE char10 VALUE 'SH_STREET', " Ship-to Street
       lv_field_va25_23     TYPE char10 VALUE 'SH_CITY', " Ship-to City
       lv_field_va25_24     TYPE char10 VALUE 'SH_REGION', " Ship-to Region
       lv_field_va25_25     TYPE char10 VALUE 'SH_COUNTRY', " Ship-to Country
       lv_field_va25_26     TYPE char10 VALUE 'SH_POSTAL', " Ship-to Postal Code
*----EOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
       lv_index_va25        TYPE sy-index,               " Index for ct_result table
       lv_lifnr_va25        TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA25)S_LIFNR[]',
       li_vbap_tmp_va25     TYPE tdt_sw_vbap_key,
       lir_lifnr_va25       TYPE fip_t_lifnr_range,
       lst_vbpa_vendor_va25 LIKE LINE OF li_vbpa_vendor.

* End of changes by Lahiru on 17/02/2020 with ED2K917574 *

*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*
DATA : lv_donot_bom_va25        TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA25)CB_BOM',
       lv_ship2p_va25           TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA25)S_SHIP2P[]',
       lir_ship2p_va25          TYPE kunnr_ran_itab,
       lv_bom_item_display_va25 TYPE char1,
       lv_ship2p_found_va25     TYPE char1,
       lv_forwarding_found_va25 TYPE char1,
       lv_payer_partner_va25    TYPE vbpa-parvw,
       lv_tablename_va25        TYPE char4,                  " Table Name
       lv_fieldname_va25        TYPE char5.                  " Field Name
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*

**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918842 ****
DATA : lv_validityperiod_va25 TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA25)SITEMVAL[]',
       lv_startdate_va25      TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA25)S_START[]',
       lv_enddate_va25        TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA25)S_END[]'.

DATA : lir_validityperiod_va25 TYPE fip_t_erdat_range,      " Validity Period
       lir_startdate_va25      TYPE fip_t_erdat_range,      " Validity start date
       lir_enddate_va25        TYPE fip_t_erdat_range.     " Validity End date
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918842 ****

**********************************************************************
* Local Field Symbo,l Declaration
**********************************************************************
FIELD-SYMBOLS:
  <lst_result_va25> TYPE any,            "Result (Structure)
  <li_rng_tab_va25> TYPE table,          "Range Table
  <li_results_va25> TYPE STANDARD TABLE, "Result (Internal Table)
*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*
  <lv_bom_va25>     TYPE char1.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*

CONSTANTS : c_sign_i   TYPE char1 VALUE 'I',  " Sign_i of type CHAR1
            c_opti_eq  TYPE char2 VALUE 'EQ', " Opti_eq of type CHAR2
            c_doccat_g TYPE vbtyp_n VALUE 'G', " Contract
            c_doccat_c TYPE vbtyp_n VALUE 'C'. " Order.

* Begin of changes by Lahiru on ERPM-9418 02/17/2020 with  ED2K917574 *
SELECT devid,                      " Development ID
       param1,                     " ABAP: Name of Variant Variable
       param2 ,                    " ABAP: Name of Variant Variable
       srno,                       " Current selection number
       sign,                       " ABAP: ID: I/E (include/exclude values)
       opti,                       " ABAP: Selection option (EQ/BT/CP/...)
       low ,                       " Lower Value of Selection Condition
       high,                       " Upper Value of Selection Condition
       activate                    " Activation indicator for constant
   FROM zcaconstant                " Wiley Application Constant Table
   INTO TABLE @li_const_va25
   WHERE devid    = @c_devid_va25    " WRICEF ID
   AND   activate = @c_x_va25.       " Only active record
IF sy-subrc IS INITIAL.
  SORT li_const_va25 BY param1.
  LOOP AT li_const_va25 ASSIGNING FIELD-SYMBOL(<lfs_const_va25>).
    CASE <lfs_const_va25>-param1.
      WHEN lc_parvw_va25.                                      " Check partner type
        lst_parvw_va25-sign   = <lfs_const_va25>-sign.
        lst_parvw_va25-opti   = <lfs_const_va25>-opti.
        lst_parvw_va25-low    = <lfs_const_va25>-low.
        lst_parvw_va25-high   = <lfs_const_va25>-high.
        IF <lfs_const_va25>-low = lc_rg_va25.         " If partner function is payer,assign to local variable
          lv_payer_partner_va25   = <lfs_const_va25>-low.
        ENDIF.
        APPEND lst_parvw_va25 TO ir_parvw_va25.
        CLEAR lst_parvw_va25.
    ENDCASE.
  ENDLOOP.
*---Begin of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918259---*
  " Get Table name
  READ TABLE li_const_va25 ASSIGNING <lfs_const_va25> WITH KEY param1 = lc_table_va25 BINARY SEARCH.
  IF sy-subrc = 0.
    lv_tablename_va25 = <lfs_const_va25>-low.      " Table name
  ENDIF.
  " Get Field name
  READ TABLE li_const_va25 ASSIGNING <lfs_const_va25> WITH KEY param1 = lc_field_va25 BINARY SEARCH.
  IF sy-subrc = 0.
    lv_fieldname_va25 = <lfs_const_va25>-low.      " field name
  ENDIF.
*---End of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918259---*
ENDIF.
* End of changes by Lahiru on ERPM-9418 02/17/2020 with ED2K917536 *


* Create Dynamic Table (Result)
CALL METHOD me->meth_create_dynamic_table
  EXPORTING
    im_ct_result = ct_result          "Current result table
  IMPORTING
    ex_dynamic_s = lo_dynamic_s_va25  "Data Reference (Structure)
    ex_dynamic_t = lo_dynamic_t_va25. "Data Reference (Table)
* Assignment of structure / internal table ref to the compatible field symbols
ASSIGN lo_dynamic_s_va25->* TO <lst_result_va25>.
ASSIGN lo_dynamic_t_va25->* TO <li_results_va25>.

* Subscription Document Category
ASSIGN (lv_sub_docs_va25) TO <li_rng_tab_va25>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab_va25> TO lir_vbtyp_n_va25.
ENDIF. " IF sy-subrc EQ 0

CLEAR lv_sdoccat_f." Insert by PBANDLAPAL on 21-Jul-2017 for ERP-3393

IF lir_vbtyp_n_va25[] IS INITIAL .
* As per the requirement we need only Contract(G) or Orders(C).
  lst_vbty_n-sign   = c_sign_i.
  lst_vbty_n-option = c_opti_eq.
  lst_vbty_n-low    = c_doccat_g.   " G (Contract)
  APPEND lst_vbty_n TO lir_vbtyp_n_va25.

  CLEAR lst_vbty_n.
  lst_vbty_n-sign   = c_sign_i.
  lst_vbty_n-option = c_opti_eq.
  lst_vbty_n-low    = c_doccat_c.   " C (Order)
  APPEND lst_vbty_n TO lir_vbtyp_n_va25.
  CLEAR lst_vbty_n.
* Begin of Insert by PBANDLAPAL on 21-Jul-2017 for ERP-3393
ELSE.
  lv_sdoccat_f = abap_true.
* End of Insert by PBANDLAPAL on 21-Jul-2017 for ERP-3393
ENDIF.

* Follow on Documents
ASSIGN (lv_foll_doc_va25) TO <li_rng_tab_va25>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab_va25> TO lir_vbeln_va25.
ENDIF. " IF sy-subrc EQ 0

* Begin of changes by Lahiru on ERPM-9418 02/17/2020 with ED2K917574 *
ASSIGN (lv_lifnr_va25) TO <li_rng_tab>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab> TO lir_lifnr_va25.
ENDIF.
* End of changes by Lahiru on ERPM-9418 02/17/2020 with ED2K917574 *

*---Begin of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918259---*
ASSIGN (lv_ship2p_va25) TO <li_rng_tab>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab> TO lir_ship2p_va25.
ENDIF.
ASSIGN (lv_donot_bom_va25) TO <lv_bom_va25>.
IF sy-subrc = 0.
  MOVE <lv_bom_va25> TO lv_bom_item_display_va25.
ENDIF.
*---End of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918259---*

**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
" Validity period
ASSIGN (lv_validityperiod_va25) TO <li_rng_tab_va25>.
IF sy-subrc = 0.
  MOVE <li_rng_tab_va25> TO lir_validityperiod_va25.
ENDIF.
" Contract start date
ASSIGN (lv_startdate_va25) TO <li_rng_tab_va25>.
IF sy-subrc = 0.
  MOVE <li_rng_tab_va25> TO lir_startdate_va25.
ENDIF.
" Contract end date
ASSIGN (lv_enddate_va25) TO <li_rng_tab_va25>.
IF sy-subrc = 0.
  MOVE <li_rng_tab_va25> TO lir_enddate_va25.
ENDIF.
*----BOC VDPATABALL 10/29/2021 ED2K924869 OTC-49605
FREE:lir_po_type_va25,lv_unren_check.
"Get the selection PO Type
ASSIGN (lv_po_type_va25) TO <li_rng_tab_va25>.
IF sy-subrc = 0.
  MOVE <li_rng_tab_va25> TO lir_po_type_va25.
ENDIF.
"Get the Un Renewed Quotations check
ASSIGN (lv_unren_va25) TO <lv_bom_va25>.
IF sy-subrc = 0.
  MOVE <lv_bom_va25> TO lv_unren_check.
ENDIF.
*----EOC VDPATABALL 10/29/2021 ED2K924869 OTC-49605

IF ct_result IS NOT INITIAL.
  " get validity period for separaete variable to fetch the data based on contract start date and contract end data
  LOOP AT lir_validityperiod_va25 ASSIGNING FIELD-SYMBOL(<lfs_validityperiod_va25>).
    DATA(lv_fromdate_va25) = <lfs_validityperiod_va25>-low.     " Contact start date
    DATA(lv_todate_va25) = <lfs_validityperiod_va25>-high.      " Contract end date
  ENDLOOP.

  REFRESH : li_vbap_tmp_va25 , li_veda_va25.
  MOVE-CORRESPONDING ct_result TO li_vbap_tmp_va25.                               " Assign result to temporary table
  SORT li_vbap_tmp_va25 BY vbeln posnr.                                           " Sort temp table
  DELETE ADJACENT DUPLICATES FROM li_vbap_tmp_va25 COMPARING vbeln posnr.         " Deleting duplicates

  " Check validity period is having the values
**** Begin of change by Lahiru on 08/31/2020 for INC0308014 with ED2K919313/ED2K919317 ****
  IF lir_validityperiod_va25 IS NOT INITIAL.
    " Fetch validity period related data
    IF lv_todate_va25 IS INITIAL.  " Fecth only validity low date only
      SELECT vbeln,vposn,vbegdat,venddat
        FROM veda INTO TABLE @li_veda_va25
        FOR ALL ENTRIES IN @li_vbap_tmp_va25
        WHERE vbeln = @li_vbap_tmp_va25-vbeln AND
             ( vposn = @li_vbap_tmp_va25-posnr OR vposn = @lc_posnr_va25 ) AND   " Fecth header and item data
              vbegdat LE @lv_fromdate_va25   AND
              venddat GE @lv_fromdate_va25.
    ELSE. " Receving both low and high dates
      SELECT vbeln,vposn,vbegdat,venddat
        FROM veda INTO TABLE @li_veda_va25
        FOR ALL ENTRIES IN @li_vbap_tmp_va25
        WHERE vbeln = @li_vbap_tmp_va25-vbeln AND
             ( vposn = @li_vbap_tmp_va25-posnr OR vposn = @lc_posnr_va25 ) AND
              vbegdat LE @lv_todate_va25   AND
              venddat GE @lv_fromdate_va25.
    ENDIF.
  ELSE. " Fetch data checking the line item validity period
    SELECT vbeln,vposn,vbegdat,venddat
      FROM veda INTO TABLE @li_veda_va25
      FOR ALL ENTRIES IN @li_vbap_tmp_va25
      WHERE vbeln = @li_vbap_tmp_va25-vbeln AND
            ( vposn = @li_vbap_tmp_va25-posnr OR vposn = @lc_posnr_va25 ).
  ENDIF.

  IF li_veda_va25 IS NOT INITIAL.    " Check whether contract data not null
    IF lir_startdate_va25 IS NOT INITIAL OR lir_enddate_va25 IS NOT INITIAL.  " Check whether Contract start/end date is null
      DATA(li_veda_tmp_va25) = li_veda_va25[].
      SORT li_veda_tmp_va25 BY vbeln vposn.
      DELETE ADJACENT DUPLICATES FROM li_veda_tmp_va25 COMPARING vbeln vposn.
      REFRESH li_veda_va25.

      SELECT vbeln,vposn,vbegdat,venddat      " Fetch contract validity dates based on validity period data
        FROM veda INTO TABLE @li_veda_va25
        FOR ALL ENTRIES IN @li_veda_tmp_va25
        WHERE vbeln = @li_veda_tmp_va25-vbeln  AND
              vposn = @li_veda_tmp_va25-vposn  AND
              vbegdat IN @lir_startdate_va25   AND
              venddat IN @lir_enddate_va25.
    ENDIF.

    SORT li_veda_va25 BY vbeln vposn.
    DELETE ADJACENT DUPLICATES FROM li_veda_va25 COMPARING vbeln vposn.

    CLEAR lv_index.
    LOOP AT ct_result ASSIGNING <lst_result_va25>.
      lv_index_va25 = sy-tabix.                                                    " Current index assign to local variable
      ASSIGN COMPONENT lv_field_va25_1 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_vbeln_veda_va25>).    " Sales Document
      ASSIGN COMPONENT lv_field_va25_2 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_vposn_veda_va25>).    " Line Item number
      " Select Contract validity period data from the line item level
      READ TABLE li_veda_va25 ASSIGNING FIELD-SYMBOL(<lfs_veda_va25>) WITH KEY vbeln = <lv_vbeln_veda_va25> vposn = <lv_vposn_veda_va25> BINARY SEARCH.
      IF sy-subrc EQ 0.
        CONTINUE.                         " Continue Without taking any action
      ELSE.   " select contract validity period data from the header level if line item level not maintained
        READ TABLE li_veda_va25 ASSIGNING <lfs_veda_va25> WITH KEY vbeln = <lv_vbeln_veda_va25> vposn = lc_posnr_va25 BINARY SEARCH.
        IF sy-subrc  = 0.
          CONTINUE.                       " Continue Without taking any action
        ELSE.
          DELETE ct_result INDEX lv_index_va25.  " Delete current line of the itab
        ENDIF.
      ENDIF.
    ENDLOOP.
  ELSE.
    REFRESH ct_result.
  ENDIF.
ENDIF.
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918842 ****
**** End of change by Lahiru on 08/31/2020 for INC0308014 with ED2K919313/ED2K919317 ****

*---Begin of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918259---*
IF ct_result IS NOT INITIAL.
  IF lv_bom_item_display_va25 = abap_true.
    REFRESH li_vbap_tmp_va25.
    MOVE-CORRESPONDING ct_result TO li_vbap_tmp_va25.                               " Assign result to temporary table
    SORT li_vbap_tmp_va25 BY vbeln posnr.                                           " Sort temp table
    DELETE ADJACENT DUPLICATES FROM li_vbap_tmp_va25 COMPARING vbeln posnr.         " Deleting duplicates

    SELECT vbeln,posnr,uepos                                            " Fetch BOM header level item
      FROM vbap INTO TABLE @DATA(li_bom_va25)
      FOR ALL ENTRIES IN @li_vbap_tmp_va25
      WHERE vbeln = @li_vbap_tmp_va25-vbeln
      AND   posnr = @li_vbap_tmp_va25-posnr
      AND   uepos = @space.
    IF sy-subrc = 0.
      SORT li_bom_va25 BY vbeln posnr.
      DELETE ADJACENT DUPLICATES FROM li_bom_va25 COMPARING vbeln posnr.

      CLEAR lv_index_va25.
      LOOP AT ct_result ASSIGNING <lst_result_va25>.
        lv_index_va25 = sy-tabix.                         " Current index assign to local variable
        ASSIGN COMPONENT lv_field_va25_1 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_vbeln_uepos_va25>).    " Sales Document
        ASSIGN COMPONENT lv_field_va25_2 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_posnr_uepos_va25>).    " Line Item number
        " Select only BOM header items
        READ TABLE li_bom_va25 ASSIGNING FIELD-SYMBOL(<lfs_bom_va25>) WITH KEY vbeln = <lv_vbeln_uepos_va25> posnr = <lv_posnr_uepos_va25> BINARY SEARCH.
        IF sy-subrc EQ 0.
          CONTINUE.                              " Continue Without taking any action
        ELSE.
          DELETE ct_result INDEX lv_index_va25.  " Delete current line of the itab
        ENDIF.
      ENDLOOP.
    ELSE.
      REFRESH ct_result.
    ENDIF.
  ENDIF.
ENDIF.
*---End of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918259---*



* Begin of changes by Lahiru on ERPM-9418 02/17/2020 with ED2K917574 *
*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*
IF ct_result IS NOT INITIAL.
  IF lir_lifnr_va25 IS NOT INITIAL OR lir_ship2p_va25 IS NOT INITIAL.  " Check selection screen Frieght forwarder/Ship to party is null.  " Check selection screen Frieght forwarder is null
    " lir_ship2p_va25 added with ED2K918259
    REFRESH li_vbap_tmp_va25.
    MOVE-CORRESPONDING ct_result TO li_vbap_tmp_va25.                               " Assign result to tempory table
    SORT li_vbap_tmp_va25 BY vbeln posnr.                                           " Sort temp table
    DELETE ADJACENT DUPLICATES FROM li_vbap_tmp_va25 COMPARING vbeln posnr.         " Deleting duplicates

*---Begin of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918259---*
    IF lir_lifnr_va25 IS NOT INITIAL.                                               " Selection screen field is empty
      " Fetch Forwarding agent partner details
      SELECT vbeln,posnr,parvw,kunnr,lifnr,adrnr
        FROM vbpa INTO TABLE @DATA(li_vbpa_vendor_temp_va25)
        FOR ALL ENTRIES IN @li_vbap_tmp_va25
        WHERE vbeln = @li_vbap_tmp_va25-vbeln
        AND ( posnr = @li_vbap_tmp_va25-posnr OR posnr = @lc_posnr_va25 )
        AND  parvw IN @ir_parvw_va25
        AND  lifnr IN @lir_lifnr_va25.
    ENDIF.

    IF lir_ship2p_va25 IS NOT INITIAL.                                                " Selection screen field is empty
      " Fetch Ship to Party partner details
      SELECT vbeln,posnr,parvw,kunnr,lifnr,adrnr
        FROM vbpa APPENDING TABLE @li_vbpa_vendor_temp_va25
        FOR ALL ENTRIES IN @li_vbap_tmp_va25
        WHERE vbeln = @li_vbap_tmp_va25-vbeln
        AND ( posnr = @li_vbap_tmp_va25-posnr OR posnr = @lc_posnr_va25 )
        AND  parvw IN @ir_parvw_va25
        AND  kunnr IN @lir_ship2p_va25.

      " Fecth orders related all the ship to parties
      SELECT vbeln,posnr,parvw,kunnr,lifnr,adrnr
        FROM vbpa INTO TABLE @DATA(li_temp_sales_doc_va25)
        FOR ALL ENTRIES IN @li_vbpa_vendor_temp_va25
        WHERE vbeln = @li_vbpa_vendor_temp_va25-vbeln
        AND   parvw IN @ir_parvw_va25.

    ENDIF.
*---End of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918259---*

    IF sy-subrc IS INITIAL.
      SORT li_vbpa_vendor_temp_va25 BY parvw.
      DELETE li_vbpa_vendor_temp_va25 WHERE parvw EQ lv_payer_partner_va25.                      " Delete the Payer partner function
      SORT li_vbpa_vendor_temp_va25 BY vbeln posnr parvw.                                        " PARVW added with ED2K918259
      DELETE ADJACENT DUPLICATES FROM li_vbpa_vendor_temp_va25 COMPARING vbeln posnr parvw.      " PARVW added with ED2K918259

**    " Separate the all line item entries from vbpa
      DATA(li_temp_sh_va25) = li_temp_sales_doc_va25[].
      SORT li_temp_sh_va25 BY posnr.
      DELETE li_temp_sh_va25 WHERE posnr EQ lc_posnr_va25.
      SORT li_temp_sh_va25 BY vbeln posnr parvw.

      CLEAR lv_index_va25.
      LOOP AT ct_result ASSIGNING <lst_result_va25>.

        CLEAR : lv_forwarding_found_va25 , lv_ship2p_found_va25 .
        lv_index_va25 = sy-tabix.                                       " Current index assign to local variable
        ASSIGN COMPONENT lv_field_va25_1 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_vbeln_va25>).    " Sales Document
        ASSIGN COMPONENT lv_field_va25_2 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_posnr_va25>).    " Line Item number
        IF lir_lifnr_va25 IS NOT INITIAL.            " Check only Forwarding agent is passing from selection screen
          " select only header level forwarding agent
          READ TABLE li_vbpa_vendor_temp_va25 ASSIGNING FIELD-SYMBOL(<lfs_forwarding_hdr_va25>) WITH KEY vbeln = <lv_vbeln_va25>
                                                                                                         posnr = lc_posnr_va25
                                                                                                         parvw = lc_forwarding_va25 BINARY SEARCH.
          IF sy-subrc EQ 0.                             " Check whether value found
            lv_forwarding_found_va25 = abap_true.
            IF lir_ship2p_va25 IS NOT INITIAL.
              " Select ship to party based on document item data
              READ TABLE li_vbpa_vendor_temp_va25 ASSIGNING FIELD-SYMBOL(<lfs_ship_item_va25_1>) WITH KEY vbeln = <lv_vbeln_va25>
                                                                                                          posnr = <lv_posnr_va25>
                                                                                                          parvw = lc_ship2p_va25 BINARY SEARCH.
              IF sy-subrc EQ 0.                         " Check whether value found
                lv_ship2p_found_va25 = abap_true.
              ELSE.
                " Select ship to party based on document header data
                READ TABLE li_vbpa_vendor_temp_va25 ASSIGNING FIELD-SYMBOL(<lfs_ship_hdr_va25_1>) WITH KEY vbeln = <lv_vbeln_va25>
                                                                                                           posnr = lc_posnr_va25
                                                                                                           parvw = lc_ship2p_va25 BINARY SEARCH.
                IF sy-subrc NE 0.                            " Check whether value found
                  DELETE ct_result INDEX lv_index_va25.      " Delete current index of CT_RESULT
                  CONTINUE.
                ENDIF.
              ENDIF.
            ENDIF.
          ELSE.
            " Select based on document and l/item data
            READ TABLE li_vbpa_vendor_temp_va25 ASSIGNING FIELD-SYMBOL(<lfs_forwarding_va25_itm>) WITH KEY vbeln = <lv_vbeln_va25>
                                                                                                           posnr = <lv_posnr_va25>
                                                                                                           parvw = lc_forwarding_va25 BINARY SEARCH.
            IF sy-subrc NE 0.                               " Check whether value found
              lv_forwarding_found_va25 = abap_false.
            ELSE.
              lv_forwarding_found_va25 = abap_true.
              " Select ship to party based on document l/item data
              IF lir_ship2p_va25 IS NOT INITIAL.
                READ TABLE li_vbpa_vendor_temp_va25 ASSIGNING FIELD-SYMBOL(<lfs_ship_item_va25_2>) WITH KEY vbeln = <lv_vbeln_va25>
                                                                                                            posnr = <lv_posnr_va25>
                                                                                                            parvw = lc_ship2p_va25 BINARY SEARCH.
                IF sy-subrc EQ 0.                           " Check whether value found
                  lv_ship2p_found_va25 = abap_true.
                ELSE.
                  " Select ship to party based on document header data
                  READ TABLE li_vbpa_vendor_temp_va25 ASSIGNING FIELD-SYMBOL(<lfs_ship_hdr_va25_2>) WITH KEY vbeln = <lv_vbeln_va25>
                                                                                                             posnr = lc_posnr_va25
                                                                                                             parvw = lc_ship2p_va25 BINARY SEARCH.
                  IF sy-subrc NE 0.                            " Check whether value found
                    DELETE ct_result INDEX lv_index_va25.      " Delete current index of CT_RESULT
                    CONTINUE.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSE.
          " lv_forwarding_found = abap_false.
        ENDIF.

        IF lir_ship2p_va25 IS NOT INITIAL.           " Check only Ship to party is passing from selection screen
          " Select ship to party based on document and l/item data
          READ TABLE li_vbpa_vendor_temp_va25 ASSIGNING FIELD-SYMBOL(<lfs_ship_va25_item>) WITH KEY vbeln = <lv_vbeln_va25>
                                                                                                    posnr = <lv_posnr_va25>
                                                                                                    parvw = lc_ship2p_va25 BINARY SEARCH.
          IF sy-subrc EQ 0.
            " Sales document not found for given forwarding agent
            IF lir_lifnr_va25 IS NOT INITIAL AND lv_forwarding_found_va25 = abap_false.
              lv_ship2p_found_va25 = abap_false.
            ELSE.
              lv_ship2p_found_va25 = abap_true.
            ENDIF.                        " Check whether value found
          ELSE.
            " Select based on document and header data
            READ TABLE li_vbpa_vendor_temp_va25 ASSIGNING FIELD-SYMBOL(<lfs_ship_hdr_va25>) WITH KEY vbeln = <lv_vbeln_va25>
                                                                                                     posnr = lc_posnr_va25
                                                                                                     parvw = lc_ship2p_va25 BINARY SEARCH.
            IF sy-subrc NE 0.                           " Check whether value found
              lv_ship2p_found_va25 = abap_false.
            ELSE.
              " Sales document not found for given forwarding agent
              IF lir_lifnr_va25 IS NOT INITIAL AND lv_forwarding_found_va25 = abap_false.
                lv_ship2p_found_va25 = abap_false.
              ELSE.
                " Read only line item data for all details for
                READ TABLE li_temp_sh_va25 ASSIGNING FIELD-SYMBOL(<lfs_temp_sh_va25>) WITH KEY vbeln = <lv_vbeln_va25>
                                                                                               posnr = <lv_posnr_va25>
                                                                                               parvw = lc_ship2p_va25 BINARY SEARCH.
                IF sy-subrc = 0.
                  " Header level Ship to party and Line item level ship to party
                  IF <lfs_temp_sh_va25>-kunnr = <lfs_ship_hdr_va25>-kunnr.
                    lv_ship2p_found_va25 = abap_true.
                  ELSE.
                    DELETE ct_result INDEX lv_index_va25.          " Delete current index of CT_RESULT
                    CONTINUE.
                  ENDIF.
                ELSE.
                  lv_ship2p_found_va25 = abap_true.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSE.

        ENDIF.
        " Delete current index of the CT_RESULT checking the status flag(Both Ship to party and forwarding agent sales document not found)
        IF lv_ship2p_found_va25 = abap_false AND lv_forwarding_found_va25 = abap_false.
          DELETE ct_result INDEX lv_index_va25.
        ENDIF.
      ENDLOOP.
*- Begin of changes by Lahiru on ERPM-9418/Defect - ERPM-13755 03/02/2020 with   ED2K917702 *
    ELSE.
      CLEAR ct_result[].
*- End of changes by Lahiru on ERPM-9418/Defect - ERPM-13755 03/02/2020 with   ED2K917702 *
    ENDIF.
  ENDIF.
ENDIF.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*
* End of changes by Lahiru on ERPM-9418 02/17/2020 with ED2K917574 *

* Identify Sales Document and Sales Document Item
MOVE-CORRESPONDING ct_result TO li_vbap_keys_va25.
IF li_vbap_keys_va25 IS NOT INITIAL.
  SORT li_vbap_keys_va25 BY vbeln posnr.
  DELETE ADJACENT DUPLICATES FROM li_vbap_keys_va25
            COMPARING vbeln posnr.

  SELECT vbfa~vbelv,   " Preceding sales and distribution document
         vbfa~posnv,   " Originating item
         vbfa~vbeln,   " Subsequent sales and distribution document
         vbfa~posnn,   " Subsequent item of an SD document
         vbfa~vbtyp_n, " Document category of subsequent document
         vbap~posnr    " Sales Document Item
    FROM vbfa INNER JOIN vbap
    ON vbfa~vbelv EQ vbap~vbeln
    AND vbfa~posnn EQ vbap~posnr
    INTO TABLE @DATA(li_inv_det_va25)
     FOR ALL ENTRIES IN @li_vbap_keys_va25
    WHERE vbfa~vbelv EQ @li_vbap_keys_va25-vbeln
    AND vbfa~posnv EQ @li_vbap_keys_va25-posnr
     AND vbfa~vbtyp_n IN @lir_vbtyp_n_va25
     AND vbfa~vbeln IN @lir_vbeln_va25.

  IF sy-subrc EQ 0.
*    SORT li_inv_det_va25 BY vbelv posnv.
    SORT li_inv_det_va25 BY vbelv posnv vbtyp_n vbeln posnn .
    DELETE ADJACENT DUPLICATES FROM li_inv_det_va25 COMPARING
                                                    vbelv posnv vbtyp_n.
  ENDIF. " IF sy-subrc EQ 0

* Begin of changes by Lahiru on ERPM-9418 02/17/2020 with ED2K917574 *
  " Fetching frieght forwarder related details
  SELECT vbeln,posnr,parvw,kunnr,lifnr,adrnr
    FROM vbpa INTO TABLE @DATA(li_vbpa_vendor_va25)
    FOR ALL ENTRIES IN @li_vbap_keys_va25
    WHERE vbeln = @li_vbap_keys_va25-vbeln
    AND ( posnr = @li_vbap_keys_va25-posnr OR posnr = @lc_posnr_va25 )
    AND  parvw IN @ir_parvw_va25.            " Partner function
  IF sy-subrc EQ 0.

*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*
    DATA(li_payer_va25) = li_vbpa_vendor_va25[].
    SORT li_vbpa_vendor_va25 BY parvw.
    DELETE li_vbpa_vendor_va25 WHERE parvw EQ lv_payer_partner_va25.                    " Delete the payer partner function
    SORT li_vbpa_vendor_va25 BY vbeln posnr parvw.                                      " Delete duplicate values
    DELETE ADJACENT DUPLICATES FROM li_vbpa_vendor_va25 COMPARING vbeln posnr parvw.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*

    " Fetching frieght forwader address detail
    SELECT addrnumber,name1,name2,name3,name4,street,city1,post_code1,country,
      region                                                "TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
      FROM adrc INTO TABLE @DATA(li_adrc_vendor_va25)
      FOR ALL ENTRIES IN @li_vbpa_vendor_va25
      WHERE addrnumber = @li_vbpa_vendor_va25-adrnr.
  ENDIF.
* End of changes by Lahiru on ERPM-9418 02/17/2020 with ED2K917574 *

*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*
  SORT li_payer_va25 BY parvw.
  DELETE li_payer_va25 WHERE parvw NE lv_payer_partner_va25.      " Delete the payer partner function not equal records
  IF li_payer_va25 IS NOT INITIAL.                                " Check whether Payer details not initial.
    SORT li_payer_va25 BY posnr.
    DELETE li_payer_va25 WHERE posnr NE lc_posnr.      " Delete line item records.
    SORT li_payer_va25 BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM li_payer_va25 COMPARING vbeln posnr.

    " fetch payers related credit limit Considering Header data
    SELECT a~partner,
           a~credit_limit,
           b~vbeln,
           b~kkber
        FROM ukmbp_cms_sgm AS a
        INNER JOIN vbak AS b
        ON a~credit_sgmnt EQ b~kkber
        INTO TABLE @DATA(li_creditlimit_va25)
        FOR ALL ENTRIES IN @li_payer_va25
        WHERE a~partner = @li_payer_va25-kunnr
        AND   b~vbeln = @li_payer_va25-vbeln.
    IF sy-subrc = 0.
      " Nothing to do
    ENDIF.
  ENDIF.

  "Fetch overall credit status and description
  SELECT a~vbeln,a~cmgst,b~bezei
    FROM vbuk AS a INNER JOIN tvbst AS b
    ON b~statu = a~cmgst
    INTO TABLE @DATA(li_tvbst_va25)
    FOR ALL ENTRIES IN @li_vbap_keys_va25
    WHERE a~vbeln = @li_vbap_keys_va25-vbeln    AND
          b~spras = @sy-langu              AND
          b~tbnam = @lv_tablename_va25     AND
          b~fdnam = @lv_fieldname_va25.
  IF sy-subrc = 0.
    " Nothing to do
  ENDIF.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*

ENDIF. " IF li_vbap_keys_va25 IS NOT INITIAL

IF li_inv_det_va25 IS NOT INITIAL.
  LOOP AT ct_result ASSIGNING <lst_result_va25>.
    MOVE-CORRESPONDING <lst_result_va25> TO lst_vbap_key_va25.
    READ TABLE li_inv_det_va25 TRANSPORTING NO FIELDS
    WITH KEY vbelv = lst_vbap_key_va25-vbeln
             posnv = lst_vbap_key_va25-posnr
       BINARY SEARCH.
    IF sy-subrc = 0.
      LOOP AT li_inv_det_va25 ASSIGNING FIELD-SYMBOL(<lst_inv_det_va25>) FROM sy-tabix.
        IF <lst_inv_det_va25>-vbelv NE lst_vbap_key_va25-vbeln OR
           <lst_inv_det_va25>-posnv NE lst_vbap_key_va25-posnr.
          EXIT.
        ENDIF. " IF <lst_inv_det_va25>-vbelv NE lst_vbap_key_va25-vbeln OR

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbfa_vbeln
            OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_fld_vbeln_va25>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_vbeln_va25> = <lst_inv_det_va25>-vbeln.
          UNASSIGN: <lv_fld_vbeln_va25>.
        ENDIF. " IF sy-subrc EQ 0

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbfa_vbtyp_n
            OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_fld_vbtyp_n_va25>). " Structure Description of Organizational Field
        IF sy-subrc EQ 0.
          <lv_fld_vbtyp_n_va25> = <lst_inv_det_va25>-vbtyp_n.
          UNASSIGN: <lv_fld_vbtyp_n_va25>.
        ENDIF. " IF sy-subrc EQ 0

        APPEND <lst_result_va25> TO <li_results_va25>.
      ENDLOOP. " LOOP AT li_inv_det_va25 ASSIGNING FIELD-SYMBOL(<lst_inv_det_va25>) FROM sy-tabix
    ELSE. " ELSE -> IF sy-subrc = 0
* Begin of Change by PBANDLAPAL on 21-Jul-2017 for ERP-3393
*      IF lir_vbtyp_n_va25[] IS  INITIAL AND
      IF lv_sdoccat_f = abap_false AND
* End of Change by PBANDLAPAL on 21-Jul-2017 for ERP-3393
         lir_vbeln_va25[]  IS INITIAL .

        APPEND <lst_result_va25> TO <li_results_va25>.

      ENDIF. " IF lir_vbtyp_n_va25[] IS INITIAL AND
    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT ct_result ASSIGNING <lst_result_va25>
  ct_result = <li_results_va25>.

ELSE. " ELSE -> IF li_inv_det_va25 IS NOT INITIAL
* Begin of Change by PBANDLAPAL on 21-Jul-2017 for ERP-3393
*  IF lir_vbtyp_n_va25[] IS NOT INITIAL OR
*     lir_vbeln_va25[]       IS NOT INITIAL .
  IF lv_sdoccat_f = abap_true OR
     lir_vbeln_va25[] IS NOT INITIAL .
* End of Change by PBANDLAPAL on 21-Jul-2017 for ERP-3393
    CLEAR: ct_result.
  ENDIF. " IF lir_vbtyp_n_va25[] IS NOT INITIAL OR
ENDIF. " IF li_inv_det_va25 IS NOT INITIAL

** Begin of Changes by Lahiru on ERPM-9418 02/17/2020 with ED2K917574 **
SORT : li_vbpa_vendor_va25 BY vbeln posnr parvw,
       li_adrc_vendor_va25 BY addrnumber,
*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*
       li_tvbst_va25 BY vbeln,
       li_creditlimit_va25 BY vbeln.

*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*

IF ct_result IS NOT INITIAL.
  LOOP AT ct_result ASSIGNING <lst_result_va25>.

    CLEAR : lst_vbpa_vendor_va25.
    ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_vbeln
               OF STRUCTURE <lst_result_va25> TO <lv_vbeln_va25>.
    IF sy-subrc EQ 0.
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_posnr
                OF STRUCTURE <lst_result_va25> TO <lv_posnr_va25>.
    ENDIF.

    " Read vendor data with line item
    READ TABLE li_vbpa_vendor_va25 INTO lst_vbpa_vendor_va25 WITH KEY vbeln = <lv_vbeln_va25>
                                                                      posnr = <lv_posnr_va25>
                                                                      parvw = lc_forwarding_va25        " lc_forwarding_va25 added with ED2K918259
                                                                      BINARY SEARCH.
    IF sy-subrc NE 0.
      " Read vendor data with only header
      READ TABLE li_vbpa_vendor_va25 INTO lst_vbpa_vendor_va25 WITH KEY vbeln = <lv_vbeln_va25>
                                                                        posnr = lc_posnr_va25
                                                                        parvw = lc_forwarding_va25        " lc_forwarding_va25 added with ED2K918259
                                                                        BINARY SEARCH.
    ENDIF.
    IF sy-subrc EQ 0.
      " Assign vendor code
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbpa_lifnr
                   OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_lifnr_va25>).
      IF sy-subrc EQ 0.
        <lv_lifnr_va25> = lst_vbpa_vendor_va25-lifnr.
        UNASSIGN: <lv_lifnr_va25>.
      ENDIF.
    ENDIF.
    " Read vendor address data based on address number
    READ TABLE li_adrc_vendor_va25 INTO DATA(lst_adrc3_va25) WITH KEY addrnumber = lst_vbpa_vendor_va25-adrnr
                                                                                   BINARY SEARCH.
    IF sy-subrc EQ 0.
      " Assign vendor name
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_name
                OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_name_fw_va25>).
      IF sy-subrc EQ 0.
        <lv_name_fw_va25> = lst_adrc3_va25-name1.
        UNASSIGN: <lv_name_fw_va25>.
      ENDIF.
      " Assign Street
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_street
                OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_street_fw_va25>).
      IF sy-subrc EQ 0.
        <lv_street_fw_va25> = lst_adrc3_va25-street.
        UNASSIGN: <lv_street_fw_va25>.
      ENDIF.
      " Assign City
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_ort01
                OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_ort01_fw_va25>).
      IF sy-subrc EQ 0.
        <lv_ort01_fw_va25> = lst_adrc3_va25-city1.
        UNASSIGN: <lv_ort01_fw_va25>.
      ENDIF.
      " Assign postal code
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_postal
                OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_postal_fw_va25>).
      IF sy-subrc EQ 0.
        <lv_postal_fw_va25> = lst_adrc3_va25-post_code1.
        UNASSIGN: <lv_postal_fw_va25>.
      ENDIF.
      " Assign country code
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_land1
                OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_land1_fw_va25>).
      IF sy-subrc EQ 0.
        <lv_land1_fw_va25> = lst_adrc3_va25-country.
        UNASSIGN: <lv_land1_fw_va25>.
      ENDIF.
    ENDIF.

*---Begin of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*
    " Read Credit status
    IF li_tvbst_va25 IS NOT INITIAL.
      READ TABLE li_tvbst_va25 ASSIGNING FIELD-SYMBOL(<lfs_tvbst_va25>) WITH KEY vbeln = <lv_vbeln_va25> BINARY SEARCH.
      IF sy-subrc = 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-credit_stat
                     OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_cmgst_va25>).
        IF sy-subrc EQ 0.
          <lv_cmgst_va25> = <lfs_tvbst_va25>-cmgst.           " credit status
          UNASSIGN: <lv_cmgst_va25>.
        ENDIF.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-credit_desc
                     OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_credes_va25>).
        IF sy-subrc EQ 0.
          <lv_credes_va25> = <lfs_tvbst_va25>-bezei.     " Credit status description
          UNASSIGN: <lv_credes_va25>.
        ENDIF.
      ENDIF.
    ENDIF.

    " Read Payer credit limit
    IF li_creditlimit_va25 IS NOT INITIAL.
      READ TABLE li_creditlimit_va25 ASSIGNING FIELD-SYMBOL(<lfs_creditlimit_va25>) WITH KEY vbeln = <lv_vbeln_va25> BINARY SEARCH.
      IF sy-subrc = 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-cr_limit
                  OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_crlimit_va25>).
        IF sy-subrc = 0.
          <lv_crlimit_va25> = <lfs_creditlimit_va25>-credit_limit.           " Credit limit
          UNASSIGN:<lv_crlimit_va25>.
        ENDIF.
      ENDIF.
    ENDIF.

    " Read Sold to party data with line item
    CLEAR lst_vbpa_vendor_va25.
    READ TABLE li_vbpa_vendor_va25 INTO lst_vbpa_vendor_va25 WITH KEY vbeln = <lv_vbeln_va25>
                                                                      posnr = <lv_posnr_va25>
                                                                      parvw = lc_solt2party_va25
                                                                      BINARY SEARCH.
    IF sy-subrc NE 0.
      " Read Sold to party with only header
      READ TABLE li_vbpa_vendor_va25 INTO lst_vbpa_vendor_va25 WITH KEY vbeln = <lv_vbeln_va25>
                                                                        posnr = lc_posnr_va25
                                                                        parvw = lc_solt2party_va25
                                                                        BINARY SEARCH.
    ENDIF.

    " Read Sold to party address data based on address number
    READ TABLE li_adrc_vendor_va25 INTO DATA(lst_adrc4_va25) WITH KEY addrnumber = lst_vbpa_vendor_va25-adrnr
                                                                                   BINARY SEARCH.
    IF sy-subrc EQ 0.
      " Assign Sold to party name2
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-slodto_name2
                OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_soldname2_va25>).
      IF sy-subrc EQ 0.
        CONCATENATE lst_adrc4_va25-name2 lst_adrc4_va25-name3 lst_adrc4_va25-name4 INTO <lv_soldname2_va25> SEPARATED BY space.
        UNASSIGN: <lv_soldname2_va25>.
      ENDIF.
    ENDIF.

    " Read Ship to party data with line item
    CLEAR lst_vbpa_vendor_va25.
    READ TABLE li_vbpa_vendor_va25 INTO lst_vbpa_vendor_va25 WITH KEY vbeln = <lv_vbeln_va25>
                                                                      posnr = <lv_posnr_va25>
                                                                      parvw = lc_ship2p_va25
                                                                      BINARY SEARCH.
    IF sy-subrc NE 0.
      " Read ship to party with only header
      READ TABLE li_vbpa_vendor_va25 INTO lst_vbpa_vendor_va25 WITH KEY vbeln = <lv_vbeln_va25>
                                                                        posnr = lc_posnr_va25
                                                                        parvw = lc_ship2p_va25
                                                                        BINARY SEARCH.
    ENDIF.
    IF sy-subrc EQ 0.
      " Assign ship to party code
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto
                   OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_ship_va25>).
      IF sy-subrc EQ 0.
        <lv_ship_va25> = lst_vbpa_vendor_va25-kunnr.
        UNASSIGN: <lv_ship_va25>.
      ENDIF.
    ENDIF.

    " Read Sold to party address data based on address number
    READ TABLE li_adrc_vendor_va25 INTO DATA(lst_adrc5_va25) WITH KEY addrnumber = lst_vbpa_vendor_va25-adrnr
                                                                                   BINARY SEARCH.
    IF sy-subrc EQ 0.
      " Assign ship to party name1
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto_name1
                OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_shipname1_va25>).
      IF sy-subrc EQ 0.
        <lv_shipname1_va25> = lst_adrc5_va25-name1.
        UNASSIGN: <lv_shipname1_va25>.
      ENDIF.

      " Assign ship to party name2
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto_name2
                OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_shipname2_va25>).
      IF sy-subrc EQ 0.
        CONCATENATE lst_adrc5_va25-name2 lst_adrc5_va25-name3 lst_adrc5_va25-name4 INTO <lv_shipname2_va25> SEPARATED BY space.
        UNASSIGN: <lv_shipname2_va25>.
      ENDIF.

    ENDIF.
*---End of change by Lahiru on 05/21/2020 ERPM-14773 with ED2K918259---*

  ENDLOOP.

ENDIF.
** End of Changes by Lahiru on ERPM-9418 02/17/2020 with ED2K917574 **


*----BOC VDPATABALL 10/29/2021 ED2K924869 OTC-49605
TYPES: BEGIN OF lty_vbap_kzwi6,
         vbeln TYPE vbeln_va,
         posnr TYPE vbap-posnr,
         kzwi6 TYPE vbap-kzwi6,
       END OF lty_vbap_kzwi6.

DATA:li_vbak_hdr TYPE STANDARD TABLE OF lty_vbap_kzwi6.
CONSTANTS:lc_zddp TYPE kschl VALUE 'ZDDP'.
FREE:li_vbak_hdr.
IF li_vbap_keys_va25 IS NOT INITIAL.
*----Condition Type Value

  SELECT vbeln,
         knumv
    INTO TABLE @DATA(li_knumv)
    FROM vbak
    FOR ALL ENTRIES IN @li_vbap_keys_va25
     WHERE vbeln = @li_vbap_keys_va25-vbeln.
  IF li_knumv IS NOT INITIAL.
    SELECT knumv,
           kschl,
           kbetr
      INTO TABLE @DATA(li_konv)
      FROM konv
      FOR ALL ENTRIES IN @li_knumv
      WHERE knumv = @li_knumv-knumv
        AND kschl = @lc_zddp.
  ENDIF.
*---Get Tax details at Line Item(s) and Header
  SELECT vbeln,
         posnr,
         kzwi6
      FROM vbap
      INTO TABLE @DATA(li_vbap_kzwi6)
      FOR ALL ENTRIES IN @li_vbap_keys_va25
      WHERE vbeln = @li_vbap_keys_va25-vbeln.
*---Header Tax preparing
  LOOP AT li_vbap_kzwi6 INTO DATA(lst_vbap_kzwi6).
    CLEAR lst_vbap_kzwi6-posnr.
    COLLECT lst_vbap_kzwi6 INTO li_vbak_hdr.
  ENDLOOP.
*--If unrenewed check is enable then we have identify the BOM items
*---If BOM head item is renewed then removing the BOM components otherwise populated
*---BOM components along with BOM header.
  IF lv_unren_check = abap_true.
*---get the Renewed list Quotations.
    SELECT vbelv,
           posnv,
           vbeln,
           posnn,
           vbtyp_n
      FROM vbfa
      INTO TABLE @DATA(li_vbfa)
      FOR ALL ENTRIES IN @li_vbap_keys_va25
      WHERE vbelv = @li_vbap_keys_va25-vbeln
        AND vbtyp_n = @c_doccat_g.
    IF li_vbfa IS NOT INITIAL.
      FREE:li_bom_va25.
      SELECT vbeln,posnr,uepos                                            " Fetch BOM header level item
       FROM vbap INTO TABLE @li_bom_va25
       FOR ALL ENTRIES IN @li_vbfa
       WHERE vbeln = @li_vbfa-vbelv
         AND uepos = @li_vbfa-posnv.
      SORT li_bom_va25 BY vbeln posnr.
    ENDIF.

    FREE:lv_index_va25.
    LOOP AT ct_result ASSIGNING <lst_result_va25>.
      lv_index_va25 = sy-tabix.
      ASSIGN COMPONENT lv_field_va25_1 OF STRUCTURE <lst_result_va25> TO <lv_vbeln_va25>.    " Sales Document
      ASSIGN COMPONENT lv_field_va25_2 OF STRUCTURE <lst_result_va25> TO <lv_posnr_va25>.    " Line Item number
      IF <lv_vbeln_va25> IS NOT INITIAL.
        " Select only BOM header items
        READ TABLE li_bom_va25 ASSIGNING <lfs_bom_va25> WITH KEY vbeln = <lv_vbeln_va25>
                                                                 posnr = <lv_posnr_va25> BINARY SEARCH.
        IF sy-subrc EQ 0.
          DELETE ct_result INDEX lv_index_va25.  " Delete current line of the itab
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDIF. "IF lv_unren_check = abap_true.

  SORT:li_vbap_kzwi6 BY vbeln posnr,
       li_vbak_hdr   BY vbeln posnr,
       li_vbfa       BY vbelv posnv,
       li_knumv      BY vbeln,
       li_konv       BY knumv.
  FREE:lv_index_va25.
  LOOP AT ct_result ASSIGNING <lst_result_va25>.
    lv_index_va25 = sy-tabix.
    ASSIGN COMPONENT lv_field_va25_1 OF STRUCTURE <lst_result_va25> TO <lv_vbeln_va25>.    " Sales Document
    ASSIGN COMPONENT lv_field_va25_2 OF STRUCTURE <lst_result_va25> TO <lv_posnr_va25>.    " Line Item number
    IF <lv_vbeln_va25> IS NOT INITIAL.

* Tax Line Item
      READ TABLE li_vbap_kzwi6 INTO lst_vbap_kzwi6 WITH KEY vbeln = <lv_vbeln_va25>
                                                            posnr = <lv_posnr_va25>
                                                            BINARY SEARCH.
      IF sy-subrc = 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_kzwi6
                  OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_vbap_kzwi6_va25>).
        <lv_vbap_kzwi6_va25> = lst_vbap_kzwi6-kzwi6.
      ENDIF.
* Tax Header
      READ TABLE li_vbak_hdr INTO DATA(lst_vbak_hdr)  WITH KEY vbeln = <lv_vbeln_va25>
                                                               posnr = lc_posnr_va25
                                                                BINARY SEARCH.
      IF sy-subrc = 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbak_kzwi6
                  OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_vbak_kzwi6_va25>).
        <lv_vbak_kzwi6_va25> = lst_vbak_hdr-kzwi6.
      ENDIF.
*Condition Type
      READ TABLE li_knumv INTO DATA(lst_knumh) WITH KEY vbeln = <lv_vbeln_va25> BINARY SEARCH.
      IF sy-subrc = 0.
        READ TABLE li_konv INTO DATA(lst_konv) WITH KEY knumv = lst_knumh-knumv BINARY SEARCH.
        IF sy-subrc = 0.
          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-konv_kbetr
                         OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_konv_kbetr_va25>).
          <lv_konv_kbetr_va25> = lst_konv-kbetr.
        ENDIF.
      ENDIF.
*----BOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
      CLEAR : lst_vbpa_vendor_va25.
      READ TABLE li_vbpa_vendor_va25 INTO lst_vbpa_vendor_va25 WITH KEY vbeln = <lv_vbeln_va25>
                                                       posnr = <lv_posnr_va25>
                                                       parvw = lc_ship2p_va25 "WE
                                                       BINARY SEARCH.
      IF sy-subrc NE 0.
        READ TABLE li_vbpa_vendor_va25 INTO lst_vbpa_vendor_va25 WITH KEY vbeln = <lv_vbeln_va25>
                                                       posnr = lc_posnr_va25  "000000
                                                       parvw = lc_ship2p_va25 "WE
                                                       BINARY SEARCH.
      ENDIF.
      IF sy-subrc EQ 0.
        CLEAR:lst_adrc3_va25.
        READ TABLE li_adrc_vendor_va25 INTO lst_adrc3_va25 WITH KEY addrnumber = lst_vbpa_vendor_va25-adrnr
                                                      BINARY SEARCH.
        IF sy-subrc EQ 0.
* Ship - To Street
          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_stras
                    OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_stras_sh_va25>).
          IF sy-subrc EQ 0.
            <lv_stras_sh_va25> = lst_adrc3_va25-street.
            UNASSIGN: <lv_stras_sh_va25>.
          ENDIF.

* Ship - to City
          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_ort01
           OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_city1_sh_va25>).
          IF sy-subrc EQ 0.
            <lv_city1_sh_va25> = lst_adrc3_va25-city1.
            UNASSIGN: <lv_city1_sh_va25>.
          ENDIF.

* Ship - to Region
          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_regio
                      OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_region_sh_va25>).
          IF sy-subrc EQ 0.
            <lv_region_sh_va25> = lst_adrc3_va25-region.
            UNASSIGN: <lv_region_sh_va25>.
          ENDIF.

* Ship - to Postal Code
          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_pstlz
            OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_post_code1_sh_va25>).
          IF sy-subrc EQ 0.
            <lv_post_code1_sh_va25> = lst_adrc3_va25-post_code1.
            UNASSIGN: <lv_post_code1_sh_va25>.
          ENDIF.

* Ship - to Country
          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_land1
                     OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_country_sh_va25>).
          IF sy-subrc EQ 0.
            <lv_country_sh_va25> = lst_adrc3_va25-country.
            UNASSIGN: <lv_country_sh_va25>.
          ENDIF.
        ENDIF.
      ENDIF.
*----EOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
*--If unrenewed check is enable then we have identify the Qutoation renewal item
*---then removing the Qutoation renewal item  otherwise populated
      IF lv_unren_check = abap_true.
        READ TABLE li_vbfa INTO DATA(lst_vbfa) WITH KEY  vbelv = <lv_vbeln_va25>
                                                         posnv = lc_posnr_va25
                                                         BINARY SEARCH.
        IF sy-subrc = 0 AND lv_index_va25 IS NOT INITIAL AND ct_result IS NOT INITIAL.
          DELETE ct_result INDEX lv_index_va25.  "removing the renewal Quotations based on Header
        ELSE.
          READ TABLE li_vbfa INTO lst_vbfa WITH KEY  vbelv = <lv_vbeln_va25>
                                                     posnv = <lv_posnr_va25>
                                                     BINARY SEARCH.
          IF sy-subrc = 0 AND lv_index_va25 IS NOT INITIAL AND ct_result IS NOT INITIAL.
            DELETE ct_result INDEX lv_index_va25."removing the renewal Quotations based on Item level
          ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.
    UNASSIGN <lv_vbeln_va25>.
    UNASSIGN <lv_posnr_va25>.
  ENDLOOP.
ENDIF. "IF li_vbap_keys_va25 IS NOT INITIAL.
*----file creation in Application Layer for India Agent
*----if the selection screen is unrenewal check is enable then only write the file in AL11.
IF lv_unren_check = abap_true AND sy-batch = abap_true.
  DATA:lv_path_out     TYPE filepath-pathintern VALUE 'Z_R054_UPLOAD_OUTPUT',
       lv_file         TYPE rlgrap-filename,
       lv_data         TYPE string,
       wa_kwmeng       TYPE char15,
       wa_netwr        TYPE char15,
       wa_kbetr        TYPE char15,
       wa_header_netwr TYPE char15,
       wa_vbap_kzwi6   TYPE char15,
       wa_vbak_kzwi6   TYPE char15,
       wa_vbegdat      TYPE char10,
       wa_venddat      TYPE char10,
       wa_erdat        TYPE char10,
       wa_kdkg2        TYPE char2,
*----BOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
       wa_sh_street(60) TYPE c,
       wa_sh_city1     TYPE char40,
       wa_sh_region    TYPE char3,
       wa_sh_land1     TYPE char3,
       wa_sh_pstlz     TYPE char10.
*----EOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
  CONSTANTS: lc_tab  TYPE c VALUE cl_bcs_convert=>gc_tab,
             lc_crlf TYPE c VALUE cl_bcs_convert=>gc_crlf.

  DATA :lv_filename   TYPE string.
*---File name
  CONCATENATE 'SPUR_OPENQUOTES_INDIANAGENTS_' sy-datum sy-uzeit INTO lv_file.

*--Get the Application Layer path dynamically
  CLEAR :lv_filename.
*--*Read file path from transaction FILE
  CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
    EXPORTING
      client                     = sy-mandt
      logical_path               = lv_path_out
      operating_system           = sy-opsys
      file_name                  = lv_file
      eleminate_blanks           = abap_true
    IMPORTING
      file_name_with_path        = lv_filename
    EXCEPTIONS
      path_not_found             = 1
      missing_parameter          = 2
      operating_system_not_found = 3
      file_system_not_found      = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
    MESSAGE 'Unable to check file'(023)  TYPE 'I'.
  ELSE.

    OPEN DATASET  lv_filename FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. " Output type
    IF sy-subrc NE 0.
      MESSAGE 'File does not transfer to Application server'(024) TYPE 'I'.
    ENDIF.

    LOOP AT ct_result ASSIGNING <lst_result_va25>.

      ASSIGN COMPONENT lv_field_va25_1 OF STRUCTURE <lst_result_va25> TO <lv_vbeln_va25>.    " Sales Document
      ASSIGN COMPONENT lv_field_va25_2 OF STRUCTURE <lst_result_va25> TO <lv_posnr_va25>.    " Line Item number
      ASSIGN COMPONENT lv_field_va25_3 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_erdat_va25>)." Creation Date
      ASSIGN COMPONENT lv_field_va25_4 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_kunnr_va25>)." Sold To
      ASSIGN COMPONENT lv_field_va25_5 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_name_kunag_va25>)." Sold to Name
      ASSIGN COMPONENT lv_field_va25_6 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_shipto_va25>). "Ship To
      ASSIGN COMPONENT lv_field_va25_7 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_shipto_name1_va25>)." Ship To Name
      ASSIGN COMPONENT lv_field_va25_8 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_bstnk_va25>)." Purchase Order Number
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_konda
                   OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_vbkd_konda_va25>).  " Price Group
      ASSIGN COMPONENT lv_field_va25_10 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_netwr_va25>)."Header total value
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbpa_lifnr
                   OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_lifnr1_va25>).  " Freight Forwarder
      ASSIGN COMPONENT lv_field_va25_12 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_matnr_va25>)." Material
      ASSIGN COMPONENT lv_field_va25_13 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_arktx_va25>)." Material Description
      ASSIGN COMPONENT lv_field_va25_14 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_kwmeng_va25>)."Quantity
      ASSIGN COMPONENT lv_field_va25_15 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_vbap_netwr_va25>)."Price
      ASSIGN COMPONENT lv_field_va25_16 OF STRUCTURE <lst_result_va25> TO  <lv_vbap_kzwi6_va25>."Tax Line Item
      ASSIGN COMPONENT lv_field_va25_17 OF STRUCTURE <lst_result_va25> TO <lv_vbak_kzwi6_va25>."Tax Header
      ASSIGN COMPONENT lv_field_va25_18 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_vbkd_kdkg2_va25>)." Condition Typee
      ASSIGN COMPONENT lv_field_va25_19 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_konv_vbegdat_va25>)." contract start date
      ASSIGN COMPONENT lv_field_va25_20 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_konv_venddat_va25>)." Contract end date
      ASSIGN COMPONENT lv_field_va25_21 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_konv_kbetr1_va25>)." conditi type
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_ihrez
                   OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_vbkd_ihrez_va25>).  " reference number
*----BOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
      ASSIGN COMPONENT lv_field_va25_22 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_sh_street_va25>)." Ship-to Street
      ASSIGN COMPONENT lv_field_va25_23 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_sh_city_va25>)." Ship-to City
      ASSIGN COMPONENT lv_field_va25_24 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_sh_regio_va25>)." Ship-to Region
      ASSIGN COMPONENT lv_field_va25_25 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_sh_land1_va25>)." Ship-to Country
      ASSIGN COMPONENT lv_field_va25_26 OF STRUCTURE <lst_result_va25> TO FIELD-SYMBOL(<lv_sh_pstlz_va25>)." Ship-to Postal Code
*----EOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
      CLEAR: wa_kwmeng,
             wa_netwr,
             wa_kbetr ,
             wa_header_netwr,
             wa_vbap_kzwi6,
             wa_vbak_kzwi6,
             wa_kdkg2,
*----BOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
             wa_sh_street,
             wa_sh_city1,
             wa_sh_region,
             wa_sh_land1,
             wa_sh_pstlz.
*----EOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
      MOVE : <lv_kwmeng_va25>     TO wa_kwmeng,
             <lv_vbap_netwr_va25> TO wa_netwr,
             <lv_netwr_va25>      TO wa_header_netwr,
             <lv_vbap_kzwi6_va25> TO wa_vbap_kzwi6,
             <lv_vbak_kzwi6_va25> TO wa_vbak_kzwi6,
             <lv_konv_kbetr1_va25> TO wa_kbetr,
             <lv_vbkd_kdkg2_va25> TO wa_kdkg2,
*----BOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
             <lv_sh_street_va25>  TO wa_sh_street,
             <lv_sh_city_va25>    TO wa_sh_city1,
             <lv_sh_regio_va25>   TO wa_sh_region,
             <lv_sh_land1_va25>   TO wa_sh_land1,
             <lv_sh_pstlz_va25>   TO wa_sh_pstlz.
*----EOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605

      CONDENSE: wa_kwmeng,
                wa_netwr,
                wa_kbetr,
                wa_header_netwr,
                wa_vbap_kzwi6,
                wa_vbak_kzwi6,
                wa_kdkg2,
*----BOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
                wa_sh_street,
                wa_sh_city1,
                wa_sh_region,
                wa_sh_land1,
                wa_sh_pstlz.
*----EOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = <lv_konv_vbegdat_va25>
        IMPORTING
          output = wa_vbegdat.

      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = <lv_konv_venddat_va25>
        IMPORTING
          output = wa_venddat.

      CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
        EXPORTING
          input  = <lv_erdat_va25>
        IMPORTING
          output = wa_erdat.

*---File Header Creation
      AT FIRST.
        CONCATENATE   'Quotation number'(001)     lc_tab
                      'Line item'(002)            lc_tab
                      'Creation Date'(003)        lc_tab
                      'Sold to'(004)              lc_tab
                      'Sold to name'(005)         lc_tab
                      'Ship to'(006)              lc_tab
                      'Ship to name'(007)         lc_tab
                      'Purchase order no'(008)    lc_tab
                      'Price Group'(009)          lc_tab
                      'Header total value'(010)   lc_tab
                      'Freght forwarder'(011)     lc_tab
                      'Material Number'(012)      lc_tab
                      'Material description'(013) lc_tab
                      'Qty'(014)                  lc_tab
                      'LineItem Price'(015)       lc_tab
                      'Tax line item'(016)        lc_tab
                      'Tax header'(017)           lc_tab
                      'Condition Type Value'(022) lc_tab
                      'Condition group2'(018)     lc_tab
                      'Contract start Date'(019)  lc_tab
                      'Contract End date'(020)    lc_tab
*----BOC TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
*                      'Sub reference number'(021) lc_crlf
*----EOC TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
*----BOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
                      'Sub reference number'(021) lc_tab
                      'Ship-To Street'(034)       lc_tab
                      'Ship-To City'(035)         lc_tab
                      'Ship-To State/Region'(036) lc_tab
                      'Ship-To Country'(038)      lc_tab
                      'Ship-To Postal Code'(037)  lc_crlf
*----EOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
                  INTO lv_data.
        TRANSFER lv_data TO lv_filename.

      ENDAT.
*----Data preparation
      CONCATENATE <lv_vbeln_va25>            lc_tab
                  <lv_posnr_va25>            lc_tab
                  wa_erdat                   lc_tab
                  <lv_kunnr_va25>            lc_tab
                  <lv_name_kunag_va25>       lc_tab
                  <lv_shipto_va25>           lc_tab
                  <lv_shipto_name1_va25>     lc_tab
                  <lv_bstnk_va25>            lc_tab
                  <lv_vbkd_konda_va25>       lc_tab
                  wa_header_netwr            lc_tab
                  <lv_lifnr1_va25>           lc_tab
                  <lv_matnr_va25>            lc_tab
                  <lv_arktx_va25>            lc_tab
                  wa_kwmeng                  lc_tab
                  wa_netwr                   lc_tab
                  wa_vbap_kzwi6              lc_tab
                  wa_vbak_kzwi6              lc_tab
                  wa_kbetr                   lc_tab
                  wa_kdkg2                   lc_tab
                  wa_vbegdat                 lc_tab
                  wa_venddat                 lc_tab
*----BOC TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
*                  <lv_vbkd_ihrez_va25>       lc_crlf
*----EOC TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
*----BOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
                  <lv_vbkd_ihrez_va25>       lc_tab
                  wa_sh_street               lc_tab
                  wa_sh_city1                lc_tab
                  wa_sh_region               lc_tab
                  wa_sh_land1                lc_tab
                  wa_sh_pstlz                lc_crlf
*----EOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
                  INTO lv_data.
      TRANSFER lv_data TO lv_filename.
      CLEAR: lv_data,
             wa_kwmeng,
             wa_netwr,
             wa_header_netwr,
             wa_vbap_kzwi6,
             wa_vbak_kzwi6,
             wa_kbetr,
             wa_kdkg2,
             wa_erdat,
             wa_vbegdat,
             wa_venddat,
*----BOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
             wa_sh_street,
             wa_sh_city1,
             wa_sh_city1,
             wa_sh_land1,
             wa_sh_pstlz.
*----EOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
      UNASSIGN: <lv_vbeln_va25>,
                <lv_posnr_va25>,
                <lv_erdat_va25>,
                <lv_kunnr_va25>,
                <lv_name_kunag_va25>,
                <lv_vbkd_kdkg2_va25>,
                <lv_shipto_va25>,
                <lv_shipto_name1_va25>,
                <lv_bstnk_va25>,
                <lv_vbkd_konda_va25>,
                <lv_lifnr1_va25>,
                <lv_matnr_va25>,
                <lv_arktx_va25>,
                <lv_vbkd_ihrez_va25>,
                <lv_vbkd_ihrez_va25>,
*----BOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
                <lv_sh_street_va25>,
                <lv_sh_city_va25>,
                <lv_sh_regio_va25>,
                <lv_sh_land1_va25>,
                <lv_sh_pstlz_va25>.
*----EOI TDIMANTHA 01/07/2022 ED2K925479 OTC-49605
    ENDLOOP.
    CLOSE DATASET  lv_filename.
  ENDIF.


ENDIF.

*----EOC VDPATABALL 10/29/2021 ED2K924869 OTC-49605
