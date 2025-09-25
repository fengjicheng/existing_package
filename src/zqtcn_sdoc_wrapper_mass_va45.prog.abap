*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SDOC_WRAPPER_MASS_VA45 (Include Program)
* PROGRAM DESCRIPTION: Add new fields in VA45
* DEVELOPER: Writtick Roy (WROY) / Sayantan Das (SAYANDAS)
* CREATION DATE:   05/30/2017
* OBJECT ID: R050
* TRANSPORT NUMBER(S): ED2K906227
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K913057
* REFERENCE NO: ERP-6311
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-08-14
* DESCRIPTION: Added new fields: Number of FTEs, Sold-to Party Email ID
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*                                                     *
* REVISION NO: ED1K909704
* REFERENCE NO: INC0232207
* DEVELOPER: Nikhilesh Palla (NPALLA)
* DATE:  27-Feb-2019
* DESCRIPTION: Added logic to get Price Group Details from VBRP if blank
*              then update from VBRK.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K914716
* REFERENCE NO: DM1748
* DEVELOPER: VDPATABALL
* DATE:  03/19/2019
* DESCRIPTION: added SALES TEXT DISPLAY in ZQTC_VA45 screen
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910257
* REFERENCE NO: INC0245900
* DEVELOPER: Prabhu
* DATE:  5/31/2019
* DESCRIPTION: Avoid duplicate entries for slect query to improve peroformance
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K910841 / ED2K916019
* REFERENCE NO: INC0248483
* DEVELOPER: Bharani
* DATE:  7/19/2019
* DESCRIPTION:  Report does not show all billing docs
*               Preceding document category field is added on the
*               selection screen and the details are fetched here and
*               populated to the select statement.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K917536
* REFERENCE NO:  ERPM-9418
* WRICEF ID: R050
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  02/13/2020
* DESCRIPTION: Add frieght forwarding agent for selection and report output
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K917696
* REFERENCE NO:  ERPM-9418/Defect - ERPM-13755
* WRICEF ID: R050
* DEVELOPER: Siva Guda (SGUDA)
* DATE:  03/02/2020
* DESCRIPTION: Add frieght forwarding agent for selection and report outpu
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918229
* REFERENCE NO:  ERPM-14773
* WRICEF ID: R050
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  05/15/2020
* DESCRIPTION: Add new selection screen fields and output fields
* Please note : Change the existing logic for Forwarding agent
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K918827
* REFERENCE NO:  ERPM-21199
* WRICEF ID: R050
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  07/09/2020
* DESCRIPTION: Add new selection screen fields and output fields
* Please note : Add validity period selection and validity dates selection logic
*---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K919588
* REFERENCE NO:  INC0311211
* WRICEF ID: R050
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  09/22/2020
* DESCRIPTION: Address the PRD issue for incident INC0311211
*---------------------------------------------------------------------*
* REVISION NO   : ED2K919999
* REFERENCE NO  : OTCM-27113/ E342
* DEVELOPER     : VDPATABALL
* DATE          : 11/02/2020
* DESCRIPTION   : This change will carry ‘Mass update of billing date using VA45
*---------------------------------------------------------------------*
* REVISION NO   : ED1K912364
* REFERENCE NO  : INC0317502/PRB0046805
* DEVELOPER     : ARGADEELA
* DATE          : 03/02/2021
* DESCRIPTION   : Fixed the Issue of ZQTC_VA45 is not returning the expected results
*                 with removed the statement to Check the particular order type(ZAC)
*                 to search the record only from header level, kept open for all the order types.
*                 Fixed the performance issue with removed the sort statements from inside loop.
*---------------------------------------------------------------------*
TYPES : BEGIN OF lty_ztermr,
          sign   TYPE tvarv_sign, "ABAP: ID: I/E (include/exclude values)
          option TYPE tvarv_opti, "ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE dzterm,     "Terms of Payment Key
          high   TYPE dzterm,     "Terms of Payment Key
        END OF lty_ztermr,
*---Begin of change VDPATABALL DM1748 03/19/2019
        BEGIN OF ty_textid,
          sign   TYPE tvarv_sign,
          option TYPE tvarv_opti,
          low    TYPE char10,
          high   TYPE char10,
        END OF  ty_textid.
*---End of change VDPATABALL DM1748 03/19/2019

* Begin of changes by Lahiru on 10/02/2020 with ED2K917536 *
TYPES: BEGIN OF ty_constant,
         devid    TYPE zdevid,              "Development ID
         param1   TYPE rvari_vnam,          "Parameter1
         param2   TYPE rvari_vnam,          "Parameter2
         srno     TYPE tvarv_numb,          "Serial Number
         sign     TYPE tvarv_sign,          "Sign
         opti     TYPE tvarv_opti,          "Option
         low      TYPE salv_de_selopt_low,  "Low
         high     TYPE salv_de_selopt_high, "High
         activate TYPE zconstactive,        "Active/Inactive Indicator
       END OF ty_constant.

TYPES : BEGIN OF ty_parvw,         " for sold to customer nad partner function from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE parvw,         " Partner Function
          high TYPE parvw,         " Partner Function
        END OF ty_parvw.
**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
TYPES : BEGIN OF ty_veda,
          vbeln   TYPE vbeln_va,
          vposn   TYPE posnr_va,
          vbegdat TYPE vbdat_veda,
          venddat TYPE vndat_veda,
        END OF ty_veda.
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****

**** Begin of change by Lahiru on 09/22/2020 with INC0311211 with ED2K919588 ****
TYPES : BEGIN OF ty_auart_va45,
          sign TYPE tvarv_sign,
          opti TYPE tvarv_opti,
          low  TYPE auart,
          high TYPE auart,
        END OF ty_auart_va45.

DATA : ir_auart  TYPE RANGE OF vbak-auart,  " Order type
       lst_auart TYPE ty_auart_va45.
**** End of change by Lahiru on 07/09/2020 with INC0311211 with ED2K919588 ****

DATA : li_const  TYPE STANDARD TABLE OF ty_constant,
       lst_parvw TYPE ty_parvw.

DATA : ir_parvw      TYPE RANGE OF vbpa-parvw,  " Partner Function
       ir_parvw_ship TYPE RANGE OF vbpa-parvw.
*---Begin of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
DATA:lir_fkdat TYPE tdt_rg_fkdat,
     lst_fkdat TYPE tds_rg_fkdat.
*---End of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45

**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
DATA : li_veda TYPE STANDARD TABLE OF ty_veda.
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****

FIELD-SYMBOLS : <gfs_constant> TYPE ty_constant.

CONSTANTS : c_devid       TYPE zdevid     VALUE 'R050',     "  WRICEF ID
            c_x           TYPE char1      VALUE 'X',        "  Active records
            lc_parvw      TYPE rvari_vnam VALUE 'PARVW',    "  Partner function
            lc_posnr      TYPE posnr      VALUE '000000',
*---Begin of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918229---*
            lc_ship2p     TYPE parvw      VALUE 'WE',       " Ship to party
            lc_forwarding TYPE parvw      VALUE 'SP',       " Forwarding agent
            lc_table_va45 TYPE rvari_vnam VALUE 'TABLE',    " Table name
            lc_field_va45 TYPE rvari_vnam VALUE 'FIELD',    " Field name
            lc_paid       TYPE string     VALUE 'Paid',
            lc_notpaid    TYPE string     VALUE 'Not Paid',
            lc_rg         TYPE parvw      VALUE 'RG',       " Payer
**** Begin of change by Lahiru on 09/22/2020 with INC0311211 with ED2K919588 ****
            lc_auart      TYPE rvari_vnam VALUE 'AUART'.    "  Order type
**** End of change by Lahiru on 09/22/2020 with INC0311211 with ED2K919588 ****
*---End of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918229---*
* End of changes by Lahiru on 10/02/2020 with ED2K917536 *


DATA:
  li_vbap_keys        TYPE tdt_sw_vbap_key, "Keys - Sales Document Item (VBAP)
  li_vbap_tmp         TYPE tdt_sw_vbap_key,
* Begin of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
  li_addr_nos         TYPE adrnr_t, "Address Numbers
* End   of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
  lir_docu_cat        TYPE saco_vbtyp_ranges_tab, "SD document category
  lir_bill_doc        TYPE fip_t_vbeln_range,     "Billing Document
  lir_bill_typ        TYPE j_3rs_so_invoice_sd,   "Billing Type
  lir_crtd_nam        TYPE fip_t_ernam_range,     "Name of Person who Created the Object
  lir_crtd_dat        TYPE fip_t_erdat_range,     "Date on Which Record Was Created
  lir_zterm           TYPE STANDARD TABLE OF lty_ztermr,
  lir_payer           TYPE oira_payer_ranges_tt,  "Payer
*--Begin of chnage VDPATABALL 03/19/2019 DM1748
  lir_matnr           TYPE /bev2/ed_rg_t_matnr,
  lst_matnr           TYPE /bev2/ed_rg_s_matnr,
  lir_lang            TYPE STANDARD TABLE OF ty_textid,
  lir_object          TYPE STANDARD TABLE OF ty_textid,
  lir_tdid            TYPE STANDARD TABLE OF ty_textid,
*--End of chnage VDPATABALL 03/19/2019 DM1748
* Begin of changes by Lahiru on 10/02/2020 with ED2K917536 *
  lir_lifnr           TYPE fip_t_lifnr_range,
  lv_field_1          TYPE char5 VALUE 'VBELN',     " Document Number
  lv_field_2          TYPE char5 VALUE 'POSNR',     " Line item number
  lv_field_3          TYPE char5 VALUE 'AUART',     " Order type
  lv_index            TYPE sy-index,                " Index for ct_result table
* End of changes by Lahiru on 10/02/2020 with ED2K917536 *

*---Begin of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918229---*
  lir_ship2p          TYPE kunnr_ran_itab,
  lv_bom_item_display TYPE char1,
  lv_ship2p_found     TYPE char1,
  lv_forwarding_found TYPE char1,
  lv_payer_partner    TYPE vbpa-parvw,
  lv_tablename_va45   TYPE char4,                       " Table Name
  lv_fieldname_va45   TYPE char5.                       " Field Name
*---End of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918229---*

DATA:
  lst_vbap_key TYPE tds_sw_vbap_key. "Key Structure for VBAP

DATA:
  lo_dynamic_s TYPE REF TO data, "Data Reference (Structure)
  lo_dynamic_t TYPE REF TO data. "Data Reference (Table)

DATA:
  lv_bill_docs TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_BLDOC[]', "Billing Document
  lv_bill_type TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_BLTYP[]', "Billing Type
  lv_crtd_name TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_ERNAM[]', "Name of Person who Created the Object
  lv_crtd_date TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_ERDAT[]', "Date on Which Record Was Created
  lv_payer     TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_KUNRG[]', "Payer
  lv_ztermr    TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_ZTRMR[]', "Terms of Payment Key
*--Begin of chnage VDPATABALL 03/19/2019 DM1748
  lv_lang      TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_LANG[]',
  lv_object    TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_OBJECT[]',
  lv_tdid      TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_TDID[]',
*--End of chnage VDPATABALL 03/19/2019 DM1748
* BOC - BTIRUVATHU - INC0248483- 2019/07/19 - ED1K910841
  lv_vbtyp     TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_VBTY_N[]',
* EOC - BTIRUVATHU - INC0248483- 2019/07/19 - ED1K910841

* Begin of changes by Lahiru on 10/02/2020 with  ED2K917536 *
  lv_lifnr     TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_LIFNR[]',
* End of changes by Lahiru on 10/02/2020 with  ED2K917536 *
*---Begin of change VDPATABALL 10/20/2020 OTCM-29460  Billing Date Button
  lv_fkdat     TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_FKDAT[]'.
*---End of change VDPATABALL 10/20/2020 OTCM-29460  Billing Date Button

*---Begin of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918229---*
DATA : lv_donot_bom TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)CB_BOM',
       lv_ship2p    TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_SHIP2P[]'.
*---End of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918229---*

**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
DATA : lv_validityperiod TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)SITEMVAL[]',
       lv_startdate      TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_START[]',
       lv_enddate        TYPE char50 VALUE '(SD_SALES_DOCUMENT_VA45)S_END[]'.

DATA : lir_validityperiod TYPE fip_t_erdat_range,      " Validity Period
       lir_startdate      TYPE fip_t_erdat_range,      " Validity start date
       lir_enddate        TYPE fip_t_erdat_range.     " Validity End date
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****

FIELD-SYMBOLS:
  <lst_result> TYPE any,            "Result (Structure)
  <li_rng_tab> TYPE table,          "Range Table
  <li_results> TYPE STANDARD TABLE, "Result (Internal Table)
*---Begin of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918229---*
  <lv_bom>     TYPE char1.
*---End of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918229---*

* Begin of changes by Lahiru on ERPM-9418 10/02/2020 with  ED2K917536 *
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
   INTO TABLE @li_const
   WHERE devid    = @c_devid    " WRICEF ID
   AND   activate = @c_x.       " Only active record
IF sy-subrc IS INITIAL.
  SORT li_const BY param1.
  LOOP AT li_const ASSIGNING FIELD-SYMBOL(<lfs_const>).
    CASE <lfs_const>-param1.
      WHEN lc_parvw.                                      " Check partner type
        lst_parvw-sign   = <lfs_const>-sign.
        lst_parvw-opti   = <lfs_const>-opti.
        lst_parvw-low    = <lfs_const>-low.
        lst_parvw-high   = <lfs_const>-high.
        IF <lfs_const>-low = lc_rg.         " If partner function is payer,assign to local variable
          lv_payer_partner   = <lfs_const>-low.
        ENDIF.
        APPEND lst_parvw TO ir_parvw.
        CLEAR lst_parvw.
      WHEN lc_auart.
        lst_auart-sign   = <lfs_const>-sign.
        lst_auart-opti   = <lfs_const>-opti.
        lst_auart-low    = <lfs_const>-low.
        lst_auart-high   = <lfs_const>-high.
        APPEND lst_auart TO ir_auart.
        CLEAR lst_auart.
    ENDCASE.
  ENDLOOP.
*---Begin of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918229---*
  " Get Table name
  READ TABLE li_const ASSIGNING <lfs_const> WITH KEY param1 = lc_table_va45 BINARY SEARCH.
  IF sy-subrc = 0.
    lv_tablename_va45 = <lfs_const>-low.      " Table name
  ENDIF.
  " Get Field name
  READ TABLE li_const ASSIGNING <lfs_const> WITH KEY param1 = lc_field_va45 BINARY SEARCH.
  IF sy-subrc = 0.
    lv_fieldname_va45 = <lfs_const>-low.      " field name
  ENDIF.
*---End of change by Lahiru on 05/18/2020 ERPM-14773 with ED2K918229---*
ENDIF.
* End of changes by Lahiru on ERPM-9418 10/02/2020 with  ED2K917536 *

* Create Dynamic Table (Result)
CALL METHOD me->meth_create_dynamic_table
  EXPORTING
    im_ct_result = ct_result     "Current result table
  IMPORTING
    ex_dynamic_s = lo_dynamic_s  "Data Reference (Structure)
    ex_dynamic_t = lo_dynamic_t. "Data Reference (Table)
* Assignment of structure / internal table ref to the compatible field symbols
ASSIGN lo_dynamic_s->* TO <lst_result>.
ASSIGN lo_dynamic_t->* TO <li_results>.

* Fetch Selection Screen Details from ABAP Stack
* Billing Document
ASSIGN (lv_bill_docs) TO <li_rng_tab>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab> TO lir_bill_doc.
ENDIF. " IF sy-subrc EQ 0
* Billing Type
ASSIGN (lv_bill_type) TO <li_rng_tab>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab> TO lir_bill_typ.
ENDIF. " IF sy-subrc EQ 0
* Name of Person who Created the Object
ASSIGN (lv_crtd_name) TO <li_rng_tab>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab> TO lir_crtd_nam.
ENDIF. " IF sy-subrc EQ 0
* Date on Which Record Was Created
ASSIGN (lv_crtd_date) TO <li_rng_tab>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab> TO lir_crtd_dat.
ENDIF. " IF sy-subrc EQ 0
* Payer
ASSIGN (lv_payer)     TO <li_rng_tab>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab> TO lir_payer.
ENDIF. " IF sy-subrc EQ 0
* Terms of Payment Key
ASSIGN (lv_ztermr)     TO <li_rng_tab>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab> TO lir_zterm.
ENDIF. " IF sy-subrc EQ 0
*--Begin of chnage VDPATABALL 03/19/2019 DM1748
ASSIGN (lv_lang) TO <li_rng_tab>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING  <li_rng_tab> TO lir_lang.
ENDIF.
ASSIGN (lv_object) TO <li_rng_tab>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab> TO lir_object.
ENDIF.
ASSIGN (lv_tdid) TO <li_rng_tab>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab> TO lir_tdid.
ENDIF.
*--End of chnage VDPATABALL 03/19/2019 DM1748
* BOC - BTIRUVATHU - INC0248483- 2019/07/19 - ED1K910841
ASSIGN (lv_vbtyp) TO <li_rng_tab>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab> TO lir_docu_cat.
ENDIF.
* EOC - BTIRUVATHU - INC0248483- 2019/07/19 - ED1K910841

* Begin of changes by Lahiru on ERPM-9418 10/02/2020 with  ED2K917536 *
ASSIGN (lv_lifnr) TO <li_rng_tab>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab> TO lir_lifnr.
ENDIF.
* End of changes by Lahiru on ERPM-9418 10/02/2020 with  ED2K917536 *
*---Begin of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229---*
ASSIGN (lv_ship2p) TO <li_rng_tab>.
IF sy-subrc EQ 0.
  MOVE-CORRESPONDING <li_rng_tab> TO lir_ship2p.
ENDIF.
ASSIGN (lv_donot_bom) TO <lv_bom>.
IF sy-subrc = 0.
  MOVE <lv_bom> TO lv_bom_item_display.
ENDIF.
*---End of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229---*
**** Begin of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****
" Validity period
ASSIGN (lv_validityperiod) TO <li_rng_tab>.
IF sy-subrc = 0.
  MOVE <li_rng_tab> TO lir_validityperiod.
ENDIF.
" Contract start date
ASSIGN (lv_startdate) TO <li_rng_tab>.
IF sy-subrc = 0.
  MOVE <li_rng_tab> TO lir_startdate.
ENDIF.
" Contract end date
ASSIGN (lv_enddate) TO <li_rng_tab>.
IF sy-subrc = 0.
  MOVE <li_rng_tab> TO lir_enddate.
ENDIF.
*---Begin of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45
DATA:lv_field_fkdat TYPE char5 VALUE 'FKDAT'.

IF sy-tcode = 'VA45'.
  ASSIGN (lv_fkdat) TO <li_rng_tab>.
  IF sy-subrc = 0.
    MOVE <li_rng_tab> TO lir_fkdat.
  ENDIF.
  IF ct_result IS NOT INITIAL.
    REFRESH : li_vbap_tmp , li_veda.
    MOVE-CORRESPONDING ct_result TO li_vbap_tmp.                               " Assign result to temporary table
    SORT li_vbap_tmp BY vbeln posnr.                                           " Sort temp table
    DELETE ADJACENT DUPLICATES FROM li_vbap_tmp COMPARING vbeln posnr.         " Deleting duplicates

    SELECT vbeln, posnr, fkdat
      FROM vbkd
      INTO TABLE @DATA(li_veda12)
      FOR ALL ENTRIES IN @li_vbap_tmp
      WHERE vbeln = @li_vbap_tmp-vbeln
        AND fkdat IN @lir_fkdat.
    LOOP AT ct_result ASSIGNING FIELD-SYMBOL(<fs>).
      ASSIGN COMPONENT lv_field_1 OF STRUCTURE <fs> TO FIELD-SYMBOL(<lv_vbeln_veda1>).    " Sales Document
      ASSIGN COMPONENT lv_field_2 OF STRUCTURE <fs> TO FIELD-SYMBOL(<lv_vposn_veda1>).    " Line Item number

      READ TABLE li_veda12 INTO DATA(lst_veda) WITH KEY vbeln = <lv_vbeln_veda1>
                                                        posnr = <lv_vposn_veda1>.
      IF sy-subrc = 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_fkdat
                        OF STRUCTURE <fs> TO FIELD-SYMBOL(<lv_text_msg1>).
        IF sy-subrc EQ 0.
          <lv_text_msg1> = lst_veda-fkdat.
          UNASSIGN: <lv_text_msg1>.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.
ELSE.
*---End of change VDPATABALL 11/02/2020 OTCM-27113/ E342 ED2K919999 Mass Billing Date update VA45

  IF ct_result IS NOT INITIAL.
    " get validity period for separaete variable to fetch the data based on contract start date and contract end data
    LOOP AT lir_validityperiod ASSIGNING FIELD-SYMBOL(<lfs_validityperiod>).
      DATA(lv_fromdate) = <lfs_validityperiod>-low.     " Contact start date
      DATA(lv_todate) = <lfs_validityperiod>-high.      " Contract end date
    ENDLOOP.

    REFRESH : li_vbap_tmp , li_veda.
    MOVE-CORRESPONDING ct_result TO li_vbap_tmp.                               " Assign result to temporary table
    SORT li_vbap_tmp BY vbeln posnr.                                           " Sort temp table
    DELETE ADJACENT DUPLICATES FROM li_vbap_tmp COMPARING vbeln posnr.         " Deleting duplicates

    " Fetch validity period related data
    IF lv_todate IS INITIAL.  " Fecth only validity low date only
      SELECT vbeln,vposn,vbegdat,venddat
        FROM veda INTO TABLE @li_veda
        FOR ALL ENTRIES IN @li_vbap_tmp
        WHERE vbeln = @li_vbap_tmp-vbeln AND
        ( vposn = @li_vbap_tmp-posnr OR vposn = @lc_posnr ) AND
              vbegdat LE @lv_fromdate   AND
              venddat GE @lv_fromdate.
    ELSE. " Receving both low and high dates
      SELECT vbeln,vposn,vbegdat,venddat
        FROM veda INTO TABLE @li_veda
        FOR ALL ENTRIES IN @li_vbap_tmp
        WHERE vbeln = @li_vbap_tmp-vbeln AND
             ( vposn = @li_vbap_tmp-posnr  OR vposn = @lc_posnr ) AND
              vbegdat LE @lv_todate   AND
              venddat GE @lv_fromdate.
    ENDIF.

    IF li_veda IS NOT INITIAL.    " Check whether contract data not null
      IF lir_startdate IS NOT INITIAL OR lir_enddate IS NOT INITIAL.  " Check whether Contract start/end date is null
        DATA(li_veda_tmp) = li_veda[].
        SORT li_veda_tmp BY vbeln vposn.
        DELETE ADJACENT DUPLICATES FROM li_veda_tmp COMPARING vbeln vposn.
        REFRESH li_veda.

        SELECT vbeln,vposn,vbegdat,venddat      " Fetch contract validity dates based on validity period data
          FROM veda INTO TABLE @li_veda
          FOR ALL ENTRIES IN @li_veda_tmp
          WHERE vbeln = @li_veda_tmp-vbeln  AND
                vposn = @li_veda_tmp-vposn  AND
                vbegdat IN @lir_startdate   AND
                venddat IN @lir_enddate.
      ENDIF.

      SORT li_veda BY vbeln vposn.
      DELETE ADJACENT DUPLICATES FROM li_veda COMPARING vbeln vposn.

      CLEAR lv_index.
      LOOP AT ct_result ASSIGNING <lst_result>.
        lv_index = sy-tabix.                                                    " Current index assign to local variable
        ASSIGN COMPONENT lv_field_1 OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_vbeln_veda>).    " Sales Document
        ASSIGN COMPONENT lv_field_2 OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_vposn_veda>).    " Line Item number
**** Begin of change by Lahiru on 09/22/2020 with INC0311211 with ED2K919588 ****
        ASSIGN COMPONENT lv_field_3 OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_auart>).         " Order type
**** End of change by Lahiru on 09/22/2020 with INC0311211 with ED2K919588 ****
        " Select Contract validity period data
        READ TABLE li_veda ASSIGNING FIELD-SYMBOL(<lfs_veda>) WITH KEY vbeln = <lv_vbeln_veda> vposn = <lv_vposn_veda> BINARY SEARCH.
        IF sy-subrc EQ 0.
          CONTINUE.                         " Continue Without taking any action
        ELSE.
**** Begin of change by Lahiru on 09/22/2020 with INC0311211 with ED2K919588 ****
**** Begin of comment by ARGADEELA on 03/02/2021 /INC0317502/PRB0046805 with ED1K912364
*          IF <lv_auart> IN ir_auart.        " Check the particular order type(ZAC) to search the record only from header level
**** End of comment by ARGADEELA on 03/02/2021 /INC0317502/PRB0046805 with ED1K912364
          READ TABLE li_veda ASSIGNING <lfs_veda> WITH KEY vbeln = <lv_vbeln_veda> vposn = lc_posnr BINARY SEARCH.
          IF sy-subrc = 0.
            CONTINUE.                         " Continue Without taking any action
          ELSE.
            DELETE ct_result INDEX lv_index.  " Delete current line of the itab
          ENDIF.
**** Begin of comment by ARGADEELA on 03/02/2021 /INC0317502/PRB0046805 with ED1K912364
*          ELSE.
*            DELETE ct_result INDEX lv_index.  " Delete current line of the itab
*          ENDIF.
**** End of comment by ARGADEELA on 03/02/2021 /INC0317502/PRB0046805 with ED1K912364
**** End of change by Lahiru on 09/22/2020 with INC0311211 with ED2K919588 ****
        ENDIF.
      ENDLOOP.
    ELSE.
      REFRESH ct_result.
    ENDIF.

  ENDIF.
**** End of change by Lahiru on 07/09/2020 with ERPM-21199 with ED2K918827 ****


*---Begin of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229---*

  IF ct_result IS NOT INITIAL.
    IF lv_bom_item_display = abap_true.
      REFRESH li_vbap_tmp.
      MOVE-CORRESPONDING ct_result TO li_vbap_tmp.                               " Assign result to temporary table
      SORT li_vbap_tmp BY vbeln posnr.                                           " Sort temp table
      DELETE ADJACENT DUPLICATES FROM li_vbap_tmp COMPARING vbeln posnr.         " Deleting duplicates

      SELECT vbeln,posnr,uepos                                                   " Fetch BOM header level item
        FROM vbap INTO TABLE @DATA(li_bom)
        FOR ALL ENTRIES IN @li_vbap_tmp
        WHERE vbeln = @li_vbap_tmp-vbeln
        AND   posnr = @li_vbap_tmp-posnr
        AND   uepos = @space.
      IF sy-subrc = 0.
        SORT li_bom BY vbeln posnr.
        DELETE ADJACENT DUPLICATES FROM li_bom COMPARING vbeln posnr.

        CLEAR lv_index.
        LOOP AT ct_result ASSIGNING <lst_result>.
          lv_index = sy-tabix.                                                    " Current index assign to local variable
          ASSIGN COMPONENT lv_field_1 OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_vbeln_uepos>).    " Sales Document
          ASSIGN COMPONENT lv_field_2 OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_posnr_uepos>).    " Line Item number
          " Select BOM Header data
          READ TABLE li_bom ASSIGNING FIELD-SYMBOL(<lfs_bom>) WITH KEY vbeln = <lv_vbeln_uepos> posnr = <lv_posnr_uepos> BINARY SEARCH.
          IF sy-subrc EQ 0.
            CONTINUE.                         " Continue Without taking any action
          ELSE.
            DELETE ct_result INDEX lv_index.  " Delete current line of the itab
          ENDIF.
        ENDLOOP.
      ELSE.
        REFRESH ct_result.
      ENDIF.
    ENDIF.
  ENDIF.

*---End of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229---*

* Begin of changes by Lahiru on ERPM-9418 10/02/2020 with  ED2K917536 *
*---Begin of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229---*
  IF ct_result IS NOT INITIAL.
    IF lir_lifnr IS NOT INITIAL OR lir_ship2p IS NOT INITIAL.                    " Check selection screen Frieght forwarder/Ship to party is null
      " lir_ship2p added with ED2K918229
      REFRESH li_vbap_tmp.
      MOVE-CORRESPONDING ct_result TO li_vbap_tmp.                               " Assign result to tempory table
      SORT li_vbap_tmp BY vbeln posnr.                                           " Sort temp table
      DELETE ADJACENT DUPLICATES FROM li_vbap_tmp COMPARING vbeln posnr.         " Deleting duplicates

*---Begin of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229---*
      IF lir_lifnr IS NOT INITIAL.                                               " Selection screen field is empty
        " Fetch Forwarding agent partner details
        SELECT vbeln,posnr,parvw,kunnr,lifnr,adrnr
          FROM vbpa INTO TABLE @DATA(li_vbpa_vendor_temp)
          FOR ALL ENTRIES IN @li_vbap_tmp
          WHERE vbeln = @li_vbap_tmp-vbeln
          AND ( posnr = @li_vbap_tmp-posnr OR posnr = @lc_posnr )
          AND  parvw IN @ir_parvw
          AND  lifnr IN @lir_lifnr.
      ENDIF.

      IF lir_ship2p IS NOT INITIAL.                                              " Selection screen field is empty

        " FETCH ship TO party related orders
        SELECT vbeln,posnr,parvw,kunnr,lifnr,adrnr
          FROM vbpa APPENDING TABLE @li_vbpa_vendor_temp
          FOR ALL ENTRIES IN @li_vbap_tmp
          WHERE vbeln = @li_vbap_tmp-vbeln
          AND ( posnr = @li_vbap_tmp-posnr OR posnr = @lc_posnr )
          AND  parvw IN @ir_parvw
          AND  kunnr IN @lir_ship2p.

        " Fecth orders related all the ship to parties
        SELECT vbeln,posnr,parvw,kunnr,lifnr,adrnr
          FROM vbpa INTO TABLE @DATA(li_temp_sales_doc)
          FOR ALL ENTRIES IN @li_vbpa_vendor_temp
          WHERE vbeln = @li_vbpa_vendor_temp-vbeln
          AND  parvw IN @ir_parvw.

      ENDIF.
*---End of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229---*

      IF sy-subrc IS INITIAL.
        SORT li_vbpa_vendor_temp BY parvw.
        DELETE li_vbpa_vendor_temp WHERE parvw EQ lv_payer_partner.                      " Delete the Payer partner function
        SORT li_vbpa_vendor_temp BY vbeln posnr parvw.                                   " PARVW added with ED2K918229
        DELETE ADJACENT DUPLICATES FROM li_vbpa_vendor_temp COMPARING vbeln posnr parvw. " PARVW added with ED2K918229

**    " Separate the all line item entries from vbpa
        DATA(li_temp_sh) = li_temp_sales_doc[].
        SORT li_temp_sh BY posnr.
        DELETE li_temp_sh WHERE posnr EQ lc_posnr.
        SORT li_temp_sh BY vbeln posnr parvw.

        CLEAR lv_index.
        LOOP AT ct_result ASSIGNING <lst_result>.

          CLEAR : lv_forwarding_found , lv_ship2p_found .
          lv_index = sy-tabix.                                                                      " Current index of CT_RESULT, assign to local variable
          ASSIGN COMPONENT lv_field_1 OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_vbeln_tmp>).    " Sales Document
          ASSIGN COMPONENT lv_field_2 OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_posnr_tmp>).    " Line Item number

          IF lir_lifnr IS NOT INITIAL.                          " Check only Forwarding agent is passing from selection screen
            " select only header level forwarding agent   " li_vbpa_vendor_temp
            READ TABLE li_vbpa_vendor_temp ASSIGNING FIELD-SYMBOL(<lfs_forwarding_hdr>) WITH KEY vbeln = <lv_vbeln_tmp>
                                                                                                posnr = lc_posnr
                                                                                                parvw = lc_forwarding BINARY SEARCH.
            IF sy-subrc EQ 0.                                   " Check whether value found
              lv_forwarding_found = abap_true.
              IF lir_ship2p IS NOT INITIAL.
                " Select ship to party based on document item data
                READ TABLE li_vbpa_vendor_temp ASSIGNING FIELD-SYMBOL(<lfs_ship_item_1>) WITH KEY vbeln = <lv_vbeln_tmp>
                                                                                                  posnr = <lv_posnr_tmp>
                                                                                                  parvw = lc_ship2p BINARY SEARCH.
                IF sy-subrc EQ 0.                               " Check whether value found
                  lv_ship2p_found = abap_true.
                ELSE.
                  " Select ship to party based on document header data
                  READ TABLE li_vbpa_vendor_temp ASSIGNING FIELD-SYMBOL(<lfs_ship_hdr_1>) WITH KEY vbeln = <lv_vbeln_tmp>
                                                                                                   posnr = lc_posnr
                                                                                                   parvw = lc_ship2p BINARY SEARCH.
                  IF sy-subrc NE 0.                             " Check whether value found
                    DELETE ct_result INDEX lv_index.            " Delete current index of CT_RESULT
                    CONTINUE.
                  ENDIF.
                ENDIF.
              ENDIF.
            ELSE.
              " Select based on document and l/item data    " li_vbpa_vendor_temp
              READ TABLE li_vbpa_vendor_temp  ASSIGNING FIELD-SYMBOL(<lfs_forwarding_itm>) WITH KEY vbeln = <lv_vbeln_tmp>
                                                                                                    posnr = <lv_posnr_tmp>
                                                                                                    parvw = lc_forwarding BINARY SEARCH.
              IF sy-subrc NE 0.                                 " Check whether value found
                lv_forwarding_found = abap_false.
              ELSE.
                lv_forwarding_found = abap_true.
                " Select ship to party based on document l/item data
                IF lir_ship2p IS NOT INITIAL.
                  READ TABLE li_vbpa_vendor_temp ASSIGNING FIELD-SYMBOL(<lfs_ship_item_2>) WITH KEY vbeln = <lv_vbeln_tmp>
                                                                                                    posnr = <lv_posnr_tmp>
                                                                                                    parvw = lc_ship2p BINARY SEARCH.
                  IF sy-subrc EQ 0.                             " Check whether value found
                    lv_ship2p_found = abap_true.
                  ELSE.
                    " Select ship to party based on document header data
                    READ TABLE li_vbpa_vendor_temp ASSIGNING FIELD-SYMBOL(<lfs_ship_hdr_2>) WITH KEY vbeln = <lv_vbeln_tmp>
                                                                                                     posnr = lc_posnr
                                                                                                     parvw = lc_ship2p BINARY SEARCH.
                    IF sy-subrc NE 0.                           " Check whether value found
                      DELETE ct_result INDEX lv_index.          " Delete current index of CT_RESULT
                      CONTINUE.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ELSE.
            " lv_forwarding_found = abap_false.
          ENDIF.

          IF lir_ship2p IS NOT INITIAL.                         " Check only Ship to party is passing from selection screen
            " Select ship to party based on document and l/item data
            READ TABLE li_vbpa_vendor_temp ASSIGNING FIELD-SYMBOL(<lfs_ship_item>) WITH KEY vbeln = <lv_vbeln_tmp>
                                                                                            posnr = <lv_posnr_tmp>
                                                                                            parvw = lc_ship2p BINARY SEARCH.
            IF sy-subrc EQ 0.
              " Sales document not found for given forwarding agent
              IF lir_lifnr IS NOT INITIAL AND lv_forwarding_found = abap_false.
                lv_ship2p_found = abap_false.
              ELSE.
                lv_ship2p_found = abap_true.
              ENDIF.                        " Check whether value found
            ELSE.
              " Select based on document and header data
              READ TABLE li_vbpa_vendor_temp ASSIGNING FIELD-SYMBOL(<lfs_ship_hdr>) WITH KEY vbeln = <lv_vbeln_tmp>
                                                                                             posnr = lc_posnr
                                                                                             parvw = lc_ship2p BINARY SEARCH.
              IF sy-subrc NE 0.                           " Check whether value found
                lv_ship2p_found = abap_false.
              ELSE.
                " Sales document not found for given forwarding agent
                IF lir_lifnr IS NOT INITIAL AND lv_forwarding_found = abap_false.
                  lv_ship2p_found = abap_false.
                ELSE.
                  " Read only line item data for all details for
                  READ TABLE li_temp_sh ASSIGNING FIELD-SYMBOL(<lfs_temp_sh>) WITH KEY vbeln = <lv_vbeln_tmp>
                                                                                       posnr = <lv_posnr_tmp>
                                                                                       parvw = lc_ship2p BINARY SEARCH.
                  IF sy-subrc = 0.
                    " Header level Ship to party and Line item level ship to party
                    IF <lfs_temp_sh>-kunnr = <lfs_ship_hdr>-kunnr.
                      lv_ship2p_found = abap_true.
                    ELSE.
                      DELETE ct_result INDEX lv_index.          " Delete current index of CT_RESULT
                      CONTINUE.
                    ENDIF.
                  ELSE.
                    lv_ship2p_found = abap_true.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ELSE.

          ENDIF.
          " Delete current index of the CT_RESULT checking the status flag(Both Ship to party and forwarding agent sales document not found)
          IF lv_ship2p_found = abap_false AND lv_forwarding_found = abap_false.
            DELETE ct_result INDEX lv_index.
          ENDIF.
        ENDLOOP.
*- Begin of changes by Lahiru on ERPM-9418/Defect - ERPM-13755 03/02/2020 with   ED2K917696 *
      ELSE.
        CLEAR ct_result[].
*- End of changes by Lahiru on ERPM-9418/Defect - ERPM-13755 03/02/2020 with   ED2K917696 *
      ENDIF.

    ENDIF.
  ENDIF.
*---End of change by Lahiru on 05/15/2020 ERPM-14773 with ED2K918229---*
* End of changes by Lahiru on ERPM-9418 10/02/2020 with  ED2K917536 *

* Identify Sales Document and Sales Document Item
  MOVE-CORRESPONDING ct_result TO li_vbap_keys.
  IF li_vbap_keys IS NOT INITIAL.
    SORT li_vbap_keys BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM li_vbap_keys
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
* Begin of Change INC0232207:NPALLA:27-Feb-2019:ED1K909704
           vbkd~ihrez,                         " Your Reference "VBKD_IHREZ_E
           vbkd~bsark,                         " Customer purchase order type "VBKD_BSARK
           vbkd~konda AS konda_kd,              " Price group (customer)
* End of Change INC0232207:NPALLA:27-Feb-2019:ED1K909704
*---Begin of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
           tvfkt~vtext,
           bsad~xblnr,
           vbkd~bstkd_e
*---End of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
      FROM vbfa INNER JOIN vbrk
        ON vbrk~vbeln EQ vbfa~vbeln
        INNER JOIN vbrp                        " Billing Document: Item Data
        ON vbfa~vbeln EQ vbrp~vbeln
       AND vbfa~posnn EQ vbrp~posnr
* Begin of Change INC0232207:NPALLA:27-Feb-2019:ED1K909704
        INNER JOIN vbkd
        ON vbkd~vbeln EQ vbfa~vbelv
       AND vbkd~posnr EQ vbfa~posnv
* End of Change INC0232207:NPALLA:27-Feb-2019:ED1K909704
*---Begin of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
      INNER JOIN tvfkt
       ON vbrk~fkart EQ tvfkt~fkart
       LEFT OUTER JOIN bsad
       ON vbfa~vbeln EQ bsad~xblnr
*---End of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
      INTO TABLE @DATA(li_inv_det)
       FOR ALL ENTRIES IN @li_vbap_keys
     WHERE vbfa~vbelv   EQ @li_vbap_keys-vbeln "Preceding sales and distribution document
       AND vbfa~posnv   EQ @li_vbap_keys-posnr "Preceding item of an SD document
       AND vbfa~vbtyp_n IN @lir_docu_cat       "Document category of subsequent document
       AND vbrk~vbeln   IN @lir_bill_doc       "Billing Document
       AND vbrk~fkart   IN @lir_bill_typ       "Billing Type
       AND vbrk~ernam   IN @lir_crtd_nam       "Name of Person who Created the Object
       AND vbrk~erdat   IN @lir_crtd_dat       "Date on Which Record Was Created
       AND vbrk~zterm   IN @lir_zterm          "Terms of Payment Key
       AND vbrk~kunrg   IN @lir_payer          "Payer
*---Begin of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
       AND tvfkt~spras  EQ @sy-langu.
*---End of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
    IF sy-subrc EQ 0.
      SORT li_inv_det BY vbelv posnv vbtyp_n stufe.
      DELETE ADJACENT DUPLICATES FROM li_inv_det
               COMPARING vbelv posnv vbtyp_n.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_vbap_keys IS NOT INITIAL
*---Begin of change ED2K914761 PRABHU DM1748 03/26/2019
  IF li_vbap_keys IS NOT INITIAL.
    SELECT vbeln,
           posnr,
           parvw,
           kunnr,
           adrnr
                FROM vbpa INTO TABLE @DATA(li_vbpa)
                  FOR ALL ENTRIES IN @li_vbap_keys
                  WHERE vbeln = @li_vbap_keys-vbeln
                    AND ( posnr = @li_vbap_keys-posnr OR posnr = '000000' )
                    AND ( parvw = 'AG' OR  parvw ='WE' ) .

    IF sy-subrc EQ 0.
      SELECT addrnumber,
             name1,
             name2,
             name3,
             name4,
             street,
             str_suppl1,
             city1,
             region,
             post_code1,
             country FROM adrc INTO TABLE @DATA(li_adrc)
                     FOR ALL ENTRIES IN @li_vbpa
                     WHERE addrnumber = @li_vbpa-adrnr.
      IF sy-subrc EQ 0 AND li_adrc IS NOT INITIAL.
        SELECT addrnumber, " Address number
            persnumber, " Person number
            date_from,  " Valid-from date
            consnumber, " Sequence Number
            smtp_addr   " E-Mail Address
       FROM adr6        " E-Mail Addresses (Business Address Services)
       INTO TABLE @DATA(li_email)
        FOR ALL ENTRIES IN @li_adrc
      WHERE addrnumber EQ @li_adrc-addrnumber
      ORDER BY PRIMARY KEY.
      ENDIF.

    ENDIF.
*---End of change PRABHU ED2K914761 DM1748 03/26/2019

* Begin of changes by Lahiru on ERPM-9418 10/02/2020 with  ED2K917536 *
    " Fetching frieght forwarder/ship to party/payer related details
    SELECT vbeln,posnr,parvw,kunnr,lifnr,adrnr
      FROM vbpa INTO TABLE @DATA(li_vbpa_vendor)
      FOR ALL ENTRIES IN @li_vbap_keys
      WHERE vbeln = @li_vbap_keys-vbeln
      AND ( posnr = @li_vbap_keys-posnr OR posnr = @lc_posnr )
      AND  parvw IN @ir_parvw.            " Partner function
    IF sy-subrc EQ 0.
*---Begin of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
      DATA(li_payer) = li_vbpa_vendor[].                          " Parner data copy to temp table
      SORT li_vbpa_vendor BY parvw.
      DELETE li_vbpa_vendor WHERE parvw EQ lv_payer_partner.      " Delete the payer partner function
      SORT li_vbpa_vendor BY vbeln posnr parvw.                   " Delete duplicate values
      DELETE ADJACENT DUPLICATES FROM li_vbpa_vendor COMPARING vbeln posnr parvw.
*---End of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*

      " Fetching frieght forwader address detail
      SELECT addrnumber,name1,street,city1,post_code1,country
        FROM adrc INTO TABLE @DATA(li_adrc_vendor)
        FOR ALL ENTRIES IN @li_vbpa_vendor
        WHERE addrnumber = @li_vbpa_vendor-adrnr.
    ENDIF.
* End of changes by Lahiru on ERPM-9418 10/02/2020 with  ED2K917536 *

*---Begin of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
    SORT li_payer BY parvw.
    DELETE li_payer WHERE parvw NE lv_payer_partner.      " Delete the payer partner function not equal records
    IF li_payer IS NOT INITIAL.                           " Check whether Payer details not initial.
      SORT li_payer BY posnr.
      DELETE li_payer WHERE posnr NE lc_posnr.            " Delete line item records.
      SORT li_payer BY vbeln posnr.
      DELETE ADJACENT DUPLICATES FROM li_payer COMPARING vbeln posnr.

      " fetch payers related credit limit Considering Header data
      SELECT a~partner,
             a~credit_limit,
             b~vbeln,
             b~kkber
          FROM ukmbp_cms_sgm AS a
          INNER JOIN vbak AS b
          ON a~credit_sgmnt EQ b~kkber
          INTO TABLE @DATA(li_creditlimit)
          FOR ALL ENTRIES IN @li_payer
          WHERE a~partner = @li_payer-kunnr
          AND   b~vbeln = @li_payer-vbeln.
      IF sy-subrc = 0.
        " Nothing to do
      ENDIF.
    ENDIF.
    "Fetch overall credit status and description
    SELECT a~vbeln,a~cmgst,b~bezei
      FROM vbuk AS a INNER JOIN tvbst AS b
      ON b~statu = a~cmgst
      INTO TABLE @DATA(li_tvbst_va45)
      FOR ALL ENTRIES IN @li_vbap_keys
      WHERE a~vbeln = @li_vbap_keys-vbeln    AND
            b~spras = @sy-langu              AND
            b~tbnam = @lv_tablename_va45     AND
            b~fdnam = @lv_fieldname_va45.
    IF sy-subrc = 0.
      " Nothing to do
    ENDIF.
*---End of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
  ENDIF.

* Begin of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
  LOOP AT ct_result ASSIGNING <lst_result>.
    ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_addrn
        OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_addr_no>). " Structure Description of Organizational Field
    IF sy-subrc EQ 0 AND
       <lv_addr_no> IS NOT INITIAL.
      APPEND <lv_addr_no> TO li_addr_nos.
    ENDIF. " IF sy-subrc EQ 0 AND
*---Begin of change PRABHU ED2K914761 DM1748 03/26/2019
*--*Build Material Itab
    ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-matnr
        OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_matnr>).

    IF sy-subrc EQ 0 AND
       <lv_matnr> IS NOT INITIAL.
      lst_matnr-low = <lv_matnr>.
      lst_matnr-sign = 'I'.
      lst_matnr-option = 'EQ'.
      APPEND lst_matnr TO lir_matnr.
      CLEAR : lst_matnr.
    ENDIF. " IF sy-subrc EQ 0 AND
  ENDLOOP. " LOOP AT ct_result ASSIGNING <lst_result>
  IF lir_matnr IS NOT INITIAL.
*--*Begin of change PRABHU 5/31/2019  ED1K910257
    SORT lir_matnr BY low.
    DELETE ADJACENT DUPLICATES FROM lir_matnr COMPARING low.
**End of change PRABHU 5/31/2019  ED1K910257
    SELECT mara~matnr,
               mara~ismmediatype,
               tjpmedtpt~bezeichnung FROM mara INNER JOIN tjpmedtpt
                                      ON mara~ismmediatype = tjpmedtpt~ismmediatype
                                      INTO TABLE @DATA(li_media)
                                      WHERE mara~matnr IN @lir_matnr
                                       AND tjpmedtpt~spras = @sy-langu.
    IF sy-subrc EQ 0.
      SORT li_media BY matnr.
    ENDIF.
  ENDIF.
*---End of change PRABHU ED2K914761 DM1748 03/26/2019
  IF li_addr_nos IS NOT INITIAL.
    SORT li_addr_nos.
    DELETE ADJACENT DUPLICATES FROM li_addr_nos COMPARING ALL FIELDS.
* Fetch E-Mail Addresses (Business Address Services)
    SELECT addrnumber, " Address number
           persnumber, " Person number
           date_from,  " Valid-from date
           consnumber, " Sequence Number
           smtp_addr   " E-Mail Address
      FROM adr6        " E-Mail Addresses (Business Address Services)
      INTO TABLE @DATA(li_email_ids)
       FOR ALL ENTRIES IN @li_addr_nos
     WHERE addrnumber EQ @li_addr_nos-table_line
     ORDER BY PRIMARY KEY.
    IF sy-subrc NE 0.
      CLEAR: li_email_ids.
    ENDIF. " IF sy-subrc NE 0
  ENDIF. " IF li_addr_nos IS NOT INITIAL
* End   of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057

  IF li_inv_det IS NOT INITIAL OR li_adrc IS NOT INITIAL.
    LOOP AT ct_result ASSIGNING <lst_result>.
*   Begin of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_addrn
          OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_addrn>). " Structure Description of Organizational Field
      IF sy-subrc EQ 0 AND
         <lv_fld_addrn> IS NOT INITIAL.
        READ TABLE li_email_ids ASSIGNING FIELD-SYMBOL(<lst_email_id>)
             WITH KEY addrnumber = <lv_fld_addrn>
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_email
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_email>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_email> = <lst_email_id>-smtp_addr.
            UNASSIGN: <lv_fld_email>.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF sy-subrc EQ 0
        UNASSIGN: <lv_fld_addrn>.
      ENDIF. " IF sy-subrc EQ 0 AND
*   End   of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057

      MOVE-CORRESPONDING <lst_result> TO lst_vbap_key.
      READ TABLE li_inv_det TRANSPORTING NO FIELDS
           WITH KEY vbelv = lst_vbap_key-vbeln
                    posnv = lst_vbap_key-posnr
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        LOOP AT li_inv_det ASSIGNING FIELD-SYMBOL(<lst_inv_det>) FROM sy-tabix.
          IF <lst_inv_det>-vbelv NE lst_vbap_key-vbeln OR
             <lst_inv_det>-posnv NE lst_vbap_key-posnr.
            EXIT.
          ENDIF. " IF <lst_inv_det>-vbelv NE lst_vbap_key-vbeln OR

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_vbeln
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_vbeln>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_vbeln> = <lst_inv_det>-vbeln.
            UNASSIGN: <lv_fld_vbeln>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_fkart
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_fkart>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_fkart> = <lst_inv_det>-fkart.
            UNASSIGN: <lv_fld_fkart>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_fktyp
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_fktyp>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_fktyp> = <lst_inv_det>-fktyp.
            UNASSIGN: <lv_fld_fktyp>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_fkdat
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_fkdat>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_fkdat> = <lst_inv_det>-fkdat.
            UNASSIGN: <lv_fld_fkdat>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_gjahr
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_gjahr>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_gjahr> = <lst_inv_det>-gjahr.
            UNASSIGN: <lv_fld_gjahr>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_poper
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_poper>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_poper> = <lst_inv_det>-poper.
            UNASSIGN: <lv_fld_poper>.
          ENDIF. " IF sy-subrc EQ 0

* Begin of Change INC0232207:NPALLA:27-Feb-2019:ED1K909704
*        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_konda
*            OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_konda>). " Structure Description of Organizational Field
*        IF sy-subrc EQ 0.
*          <lv_fld_konda> = <lst_inv_det>-konda.
*          UNASSIGN: <lv_fld_konda>.
*        ENDIF. " IF sy-subrc EQ 0
          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_konda
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_konda>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            IF <lst_inv_det>-konda_kd IS NOT INITIAL.
              <lv_fld_konda> = <lst_inv_det>-konda_kd.
            ELSE.
              <lv_fld_konda> = <lst_inv_det>-konda.
            ENDIF.
            UNASSIGN: <lv_fld_konda>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_ihrez_e
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_ihrez>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_ihrez> = <lst_inv_det>-ihrez.
            UNASSIGN: <lv_fld_ihrez>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_bstkd_e
                  OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_bstkd_e>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_bstkd_e> = <lst_inv_det>-bstkd_e.
            UNASSIGN: <lv_fld_bstkd_e>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbkd_bsark
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_bsark>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_bsark> = <lst_inv_det>-bsark.
            UNASSIGN: <lv_fld_bsark>.
          ENDIF. " IF sy-subrc EQ 0
* End of Change INC0232207:NPALLA:27-Feb-2019:ED1K909704

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_kdgrp
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_kdgrp>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_kdgrp> = <lst_inv_det>-kdgrp.
            UNASSIGN: <lv_fld_kdgrp>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_pltyp
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_pltyp>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_pltyp> = <lst_inv_det>-pltyp.
            UNASSIGN: <lv_fld_pltyp>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_inco1
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_inco1>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_inco1> = <lst_inv_det>-inco1.
            UNASSIGN: <lv_fld_inco1>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_zterm
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_zterm>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_zterm> = <lst_inv_det>-zterm.
            UNASSIGN: <lv_fld_zterm>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_zlsch
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_zlsch>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_zlsch> = <lst_inv_det>-zlsch.
            UNASSIGN: <lv_fld_zlsch>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_ktgrd
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_ktgrd>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_ktgrd> = <lst_inv_det>-ktgrd.
            UNASSIGN: <lv_fld_ktgrd>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_netwr
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_netwr>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_netwr> = <lst_inv_det>-netwr_h.
            UNASSIGN: <lv_fld_netwr>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_zukri
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_zukri>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_zukri> = <lst_inv_det>-zukri.
            UNASSIGN: <lv_fld_zukri>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_ernam
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_ernam>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_ernam> = <lst_inv_det>-ernam.
            UNASSIGN: <lv_fld_ernam>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_erzet
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_erzet>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_erzet> = <lst_inv_det>-erzet.
            UNASSIGN: <lv_fld_erzet>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_erdat
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_erdat>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_erdat> = <lst_inv_det>-erdat.
            UNASSIGN: <lv_fld_erdat>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_kunrg
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_kunrg>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_kunrg> = <lst_inv_det>-kunrg.
            UNASSIGN: <lv_fld_kunrg>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_stceg
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_stceg>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_stceg> = <lst_inv_det>-stceg.
            UNASSIGN: <lv_fld_stceg>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_sfakn
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_sfakn>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_sfakn> = <lst_inv_det>-sfakn.
            UNASSIGN: <lv_fld_sfakn>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_kurst
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_kurst>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_kurst> = <lst_inv_det>-kurst.
            UNASSIGN: <lv_fld_kurst>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_mschl
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_mschl>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_mschl> = <lst_inv_det>-mschl.
            UNASSIGN: <lv_fld_mschl>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_zuonr
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_zuonr>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_zuonr> = <lst_inv_det>-zuonr.
            UNASSIGN: <lv_fld_zuonr>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_mwsbk
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_mwsbk>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_mwsbk> = <lst_inv_det>-mwsbk.
            UNASSIGN: <lv_fld_mwsbk>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_kidno
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_kidno>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_kidno> = <lst_inv_det>-kidno.
            UNASSIGN: <lv_fld_kidno>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_vbeln
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_vbeln2>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_vbeln2> = <lst_inv_det>-vbeln.
            UNASSIGN: <lv_fld_vbeln2>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_posnr
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_posnr>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_posnr> = <lst_inv_det>-posnr.
            UNASSIGN: <lv_fld_posnr>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_uepos
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_uepos>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_uepos> = <lst_inv_det>-uepos.
            UNASSIGN: <lv_fld_uepos>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_netwr
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_netwr2>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_netwr2> = <lst_inv_det>-netwr_i.
            UNASSIGN: <lv_fld_netwr2>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi1
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_kzwi1>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_kzwi1> = <lst_inv_det>-kzwi1.
            UNASSIGN: <lv_fld_kzwi1>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi2
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_kzwi2>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_kzwi2> = <lst_inv_det>-kzwi2.
            UNASSIGN: <lv_fld_kzwi2>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi3
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_kzwi3>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_kzwi3> = <lst_inv_det>-kzwi3.
            UNASSIGN: <lv_fld_kzwi3>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi4
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_kzwi4>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_kzwi4> = <lst_inv_det>-kzwi4.
            UNASSIGN: <lv_fld_kzwi4>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi5
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_kzwi5>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_kzwi5> = <lst_inv_det>-kzwi5.
            UNASSIGN: <lv_fld_kzwi5>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_kzwi6
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_kzwi6>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_kzwi6> = <lst_inv_det>-kzwi6.
            UNASSIGN: <lv_fld_kzwi6>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_prctr
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_prctr>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_prctr> = <lst_inv_det>-prctr.
            UNASSIGN: <lv_fld_prctr>.
          ENDIF. " IF sy-subrc EQ 0

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrp_txjcd
              OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_fld_txjcd>). " Structure Description of Organizational Field
          IF sy-subrc EQ 0.
            <lv_fld_txjcd> = <lst_inv_det>-txjcd.
            UNASSIGN: <lv_fld_txjcd>.
          ENDIF. " IF sy-subrc EQ 0

          APPEND <lst_result> TO <li_results>.
        ENDLOOP. " LOOP AT li_inv_det ASSIGNING FIELD-SYMBOL(<lst_inv_det>) FROM sy-tabix
      ELSE. " ELSE -> IF sy-subrc EQ 0
*     Include record, if there is no Billing Doc level filter
        IF lir_bill_doc IS INITIAL AND
           lir_bill_typ IS INITIAL AND
           lir_crtd_nam IS INITIAL AND
           lir_crtd_dat IS INITIAL AND
           lir_zterm    IS INITIAL AND
           lir_payer    IS INITIAL.
          APPEND <lst_result> TO <li_results>.
        ENDIF. " IF lir_bill_doc IS INITIAL AND
      ENDIF. " IF sy-subrc EQ 0
    ENDLOOP. " LOOP AT ct_result ASSIGNING <lst_result>

    ct_result = <li_results>.
  ELSE. " ELSE -> IF li_inv_det IS NOT INITIAL
* Check for Billing Doc level filter
    IF lir_bill_doc IS NOT INITIAL OR
       lir_bill_typ IS NOT INITIAL OR
       lir_crtd_nam IS NOT INITIAL OR
       lir_crtd_dat IS NOT INITIAL OR
       lir_zterm    IS NOT INITIAL OR
       lir_payer    IS NOT INITIAL.
      CLEAR: ct_result.
* Begin of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
    ELSE. " ELSE -> IF lir_bill_doc IS NOT INITIAL OR
      IF li_email_ids IS NOT INITIAL.
        LOOP AT ct_result ASSIGNING <lst_result>.
          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_addrn
              OF STRUCTURE <lst_result> TO <lv_fld_addrn>.               " Structure Description of Organizational Field
          IF sy-subrc EQ 0 AND
             <lv_fld_addrn> IS NOT INITIAL.
            READ TABLE li_email_ids ASSIGNING <lst_email_id>
                 WITH KEY addrnumber = <lv_fld_addrn>
                 BINARY SEARCH.
            IF sy-subrc EQ 0.
              ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_email
                  OF STRUCTURE <lst_result> TO <lv_fld_email>.           " Structure Description of Organizational Field
              IF sy-subrc EQ 0.
                <lv_fld_email> = <lst_email_id>-smtp_addr.
                UNASSIGN: <lv_fld_email>.
              ENDIF. " IF sy-subrc EQ 0
            ENDIF. " IF sy-subrc EQ 0
            UNASSIGN: <lv_fld_addrn>.
          ENDIF. " IF sy-subrc EQ 0 AND
        ENDLOOP. " LOOP AT ct_result ASSIGNING <lst_result>
      ENDIF. " IF li_email_ids IS NOT INITIAL
* End   of ADD:ERP-6311:WROY:14-AUG-2018:ED2K913057
    ENDIF. " IF lir_bill_doc IS NOT INITIAL OR
  ENDIF. " IF li_inv_det IS NOT INITIAL
*--Begin of chnage VDPATABALL 03/19/2019 DM1748

  DATA: li_header       TYPE thead,
        lst_vbpa        LIKE LINE OF li_vbpa,
        li_read_text    TYPE TABLE OF tline,
        lst_read_text   TYPE tline,
** Begin of Changes by Lahiru on ERPM-9418 12/02/2020 with ED2K917536 **
        lst_vbpa_vendor LIKE LINE OF li_vbpa_vendor.
** End of Changes by Lahiru on ERPM-9418 12/02/2020 with ED2K917536 **

*---Begin of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
  SORT li_tvbst_va45 BY vbeln.
  SORT li_inv_det BY vbeln.
  SORT li_creditlimit BY vbeln.
*---End of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
**** Begin of Add by ARGADEELA on 03/02/2021 /INC0317502/PRB0046805 with ED1K912364
  SORT : li_vbpa BY vbeln posnr parvw, li_adrc BY addrnumber.
  SORT : li_vbpa_vendor BY vbeln posnr parvw, li_adrc_vendor BY addrnumber.
**** End of Add by ARGADEELA on 03/02/2021 /INC0317502/PRB0046805 with ED1K912364

  LOOP AT ct_result ASSIGNING <lst_result>.
    FREE:li_read_text,li_header.
    ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_vbeln
                  OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_vbeln>).
    IF sy-subrc EQ 0.
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_posnr
                OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_posnr>).
      CONCATENATE <lv_vbeln> <lv_posnr> INTO li_header-tdname.
*      UNASSIGN:<lv_vbeln>, <lv_posnr>.
    ENDIF.
*--*Populate Item text
    IF lir_lang   IS NOT INITIAL
       AND lir_object IS NOT INITIAL
       AND lir_tdid   IS NOT INITIAL.

      li_header-tdobject = lir_object[ 1 ]-low.
      li_header-tdid     = lir_tdid[ 1 ]-low.
      li_header-tdspras  = lir_lang[ 1 ]-low.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = li_header-tdid
          language                = li_header-tdspras
          name                    = li_header-tdname
          object                  = li_header-tdobject
        TABLES
          lines                   = li_read_text
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc = 0.
        READ TABLE li_read_text INTO lst_read_text INDEX 1.
        IF  sy-subrc = 0.
          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbap_text
                  OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_text_msg>).
          IF sy-subrc EQ 0.
            <lv_text_msg> = lst_read_text-tdline.
            UNASSIGN: <lv_text_msg>.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
**** Begin of comment by ARGADEELA on 03/02/2021 /INC0317502/PRB0046805 with ED1K912364
*    SORT : li_vbpa BY vbeln posnr parvw, li_adrc BY addrnumber.
**** End of comment by ARGADEELA on 03/02/2021 /INC0317502/PRB0046805 with ED1K912364
    CLEAR : lst_vbpa.
    READ TABLE li_vbpa INTO lst_vbpa WITH KEY vbeln = <lv_vbeln>
                                                    posnr = <lv_posnr>
                                                    parvw = 'AG'
                                                    BINARY SEARCH.
    IF sy-subrc NE 0.
      READ TABLE li_vbpa INTO lst_vbpa WITH KEY vbeln = <lv_vbeln>
                                                     posnr = '000000'
                                                     parvw = 'AG'
                                                     BINARY SEARCH.
    ENDIF.
    IF sy-subrc EQ 0.
      READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = lst_vbpa-adrnr
                                                       BINARY SEARCH.
      IF sy-subrc EQ 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_stras
                   OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_stras>).
        IF sy-subrc EQ 0.
          <lv_stras> = lst_adrc-street.
          UNASSIGN: <lv_stras>.
        ENDIF.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_street2
                   OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_strsupp>).
        IF sy-subrc EQ 0.
          <lv_strsupp> = lst_adrc-str_suppl1.
          UNASSIGN: <lv_strsupp>.
        ENDIF.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_ort01
                   OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_city1>).
        IF sy-subrc EQ 0.
          <lv_city1> = lst_adrc-city1.
          UNASSIGN: <lv_city1>.
        ENDIF.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_regio
                    OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_region>).
        IF sy-subrc EQ 0.
          <lv_region> = lst_adrc-region.
          UNASSIGN: <lv_region>.
        ENDIF.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_pstlz
                    OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_post_code1>).
        IF sy-subrc EQ 0.
          <lv_post_code1> = lst_adrc-post_code1.
          UNASSIGN: <lv_post_code1>.
        ENDIF.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sp_land1
                   OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_country>).
        IF sy-subrc EQ 0.
          <lv_country> = lst_adrc-country.
          UNASSIGN: <lv_country>.
        ENDIF.

*---Begin of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
        " Sold to party name2 concatenate with name2,name3,name4
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-slodto_name2
                    OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_so_name2>).
        IF sy-subrc EQ 0.
          CONCATENATE lst_adrc-name2 lst_adrc-name3 lst_adrc-name4 INTO <lv_so_name2> SEPARATED BY space.
          UNASSIGN: <lv_so_name2>.
        ENDIF.
*---End of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*

      ENDIF.
    ENDIF.

    CLEAR : lst_vbpa.
    READ TABLE li_vbpa INTO lst_vbpa WITH KEY vbeln = <lv_vbeln>
                                                     posnr = <lv_posnr>
                                                     parvw = 'WE'
                                                     BINARY SEARCH.
    IF sy-subrc NE 0.
      READ TABLE li_vbpa INTO lst_vbpa WITH KEY vbeln = <lv_vbeln>
                                                     posnr = '000000'
                                                     parvw = 'WE'
                                                     BINARY SEARCH.
    ENDIF.
    IF sy-subrc EQ 0.
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto
                   OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_shipto>).
      IF sy-subrc EQ 0.
        <lv_shipto> = lst_vbpa-kunnr.
        UNASSIGN: <lv_shipto>.
      ENDIF.
      READ TABLE li_adrc INTO DATA(lst_adrc2) WITH KEY addrnumber = lst_vbpa-adrnr
                                                      BINARY SEARCH.
      IF sy-subrc EQ 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_stras
                  OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_stras_sh>).
        IF sy-subrc EQ 0.
          <lv_stras_sh> = lst_adrc2-street.
          UNASSIGN: <lv_stras_sh>.
        ENDIF.

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto_name1         " shipto_name
                  OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_sh_name>).
        IF sy-subrc EQ 0.
*---Begin of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
          " remove the concatenate for ship to party name
          " CONCATENATE lst_adrc2-name1 lst_adrc2-name2 lst_adrc2-name3 lst_adrc2-name4 INTO <lv_sh_name> SEPARATED BY space.
          <lv_sh_name> = lst_adrc2-name1.
*---End of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
          UNASSIGN: <lv_sh_name>.
        ENDIF.

*---Begin of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
        " Ship to party name2 concatenate with name2,name3,name4
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-shipto_name2         " shipto_name
            OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_sh_name2>).
        IF sy-subrc EQ 0.
          CONCATENATE lst_adrc2-name2 lst_adrc2-name3 lst_adrc2-name4 INTO <lv_sh_name2> SEPARATED BY space.
          UNASSIGN: <lv_sh_name2>.
        ENDIF.
*---End of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*

        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_street2
                   OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_strsupp_sh>).
        IF sy-subrc EQ 0.
          <lv_strsupp_sh> = lst_adrc2-str_suppl1.
          UNASSIGN: <lv_strsupp_sh>.
        ENDIF.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_ort01
                   OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_city1_sh>).
        IF sy-subrc EQ 0.
          <lv_city1_sh> = lst_adrc2-city1.
          UNASSIGN: <lv_city1_sh>.
        ENDIF.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_regio
                    OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_region_sh>).
        IF sy-subrc EQ 0.
          <lv_region_sh> = lst_adrc2-region.
          UNASSIGN: <lv_region_sh>.
        ENDIF.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_pstlz
                    OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_post_code1_sh>).
        IF sy-subrc EQ 0.
          <lv_post_code1_sh> = lst_adrc2-post_code1.
          UNASSIGN: <lv_post_code1_sh>.
        ENDIF.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-sh_land1
                   OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_country_sh>).
        IF sy-subrc EQ 0.
          <lv_country_sh> = lst_adrc2-country.
          UNASSIGN: <lv_country_sh>.
        ENDIF.
        READ TABLE li_email INTO DATA(lst_email) WITH KEY addrnumber = lst_adrc-addrnumber
                                                                        BINARY SEARCH.
        IF sy-subrc EQ 0.
          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-ship_email
                      OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_sh_email>).
          IF sy-subrc EQ 0.
            <lv_sh_email> = lst_email-smtp_addr.
            UNASSIGN: <lv_sh_email>.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-matnr
                    OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_mat>).
    IF sy-subrc EQ 0.
      READ TABLE li_media INTO DATA(lst_media) WITH KEY matnr = <lv_mat>
                                                BINARY SEARCH .
      IF sy-subrc EQ 0 AND lst_media-bezeichnung IS NOT INITIAL.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-mediatype
                      OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_mediatype>).
        IF sy-subrc EQ 0.
          <lv_mediatype> = lst_media-bezeichnung.
          UNASSIGN <lv_mediatype>.
        ENDIF.
      ENDIF.
    ENDIF.
*--End of chnage VDPATABALL 03/19/2019 DM1748

** Begin of Changes by Lahiru on ERPM-9418 12/02/2020 with ED2K917536 **
**** Begin of comment by ARGADEELA on 03/02/2021 /INC0317502/PRB0046805 with ED1K912364
*    SORT : li_vbpa_vendor BY vbeln posnr parvw,
*           li_adrc_vendor BY addrnumber.
**** End of comment by ARGADEELA on 03/02/2021 /INC0317502/PRB0046805 with  ED1K912364
    CLEAR : lst_vbpa_vendor.
    " Read vendor data with line item
    READ TABLE li_vbpa_vendor INTO lst_vbpa_vendor WITH KEY vbeln = <lv_vbeln>
                                                     posnr = <lv_posnr>
                                                     parvw = lc_forwarding        " lc_forwarding added with ED2K918229
                                                     BINARY SEARCH.
    IF sy-subrc NE 0.
      " Read vendor data with only header
      READ TABLE li_vbpa_vendor INTO lst_vbpa_vendor WITH KEY vbeln = <lv_vbeln>
                                                     posnr = lc_posnr
                                                     parvw = lc_forwarding        " lc_forwarding added with ED2K918229
                                                     BINARY SEARCH.
    ENDIF.
    IF sy-subrc EQ 0.
      " Assign vendor code
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbpa_lifnr
                   OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_lifnr>).
      IF sy-subrc EQ 0.
        <lv_lifnr> = lst_vbpa_vendor-lifnr.
        UNASSIGN: <lv_lifnr>.
      ENDIF.
    ENDIF.
    " Read vendor address data based on address number
    READ TABLE li_adrc_vendor INTO DATA(lst_adrc3) WITH KEY addrnumber = lst_vbpa_vendor-adrnr
                                                      BINARY SEARCH.
    IF sy-subrc EQ 0.
      " Assign vendor name
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_name
                OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_name_fw>).
      IF sy-subrc EQ 0.
        <lv_name_fw> = lst_adrc3-name1.
        UNASSIGN: <lv_name_fw>.
      ENDIF.
      " Assign Street
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_street
                OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_street_fw>).
      IF sy-subrc EQ 0.
        <lv_street_fw> = lst_adrc3-street.
        UNASSIGN: <lv_street_fw>.
      ENDIF.
      " Assign City
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_ort01
                OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_ort01_fw>).
      IF sy-subrc EQ 0.
        <lv_ort01_fw> = lst_adrc3-city1.
        UNASSIGN: <lv_ort01_fw>.
      ENDIF.
      " Assign postal code
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_postal
                OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_postal_fw>).
      IF sy-subrc EQ 0.
        <lv_postal_fw> = lst_adrc3-post_code1.
        UNASSIGN: <lv_postal_fw>.
      ENDIF.
      " Assign country code
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-fw_land1
                OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_land1_fw>).
      IF sy-subrc EQ 0.
        <lv_land1_fw> = lst_adrc3-country.
        UNASSIGN: <lv_land1_fw>.
      ENDIF.
    ENDIF.
** End of Changes by Lahiru on ERPM-9418 12/02/2020 with ED2K917536 **

*---Begin of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
    " Read Credit status
    IF li_tvbst_va45 IS NOT INITIAL.
      READ TABLE li_tvbst_va45 ASSIGNING FIELD-SYMBOL(<lfs_tvbst_va45>) WITH KEY vbeln = <lv_vbeln> BINARY SEARCH.
      IF sy-subrc = 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-credit_stat
                     OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_cmgst_va45>).
        IF sy-subrc EQ 0.
          <lv_cmgst_va45> = <lfs_tvbst_va45>-cmgst.           " credit status
          UNASSIGN: <lv_cmgst_va45>.
        ENDIF.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-credit_desc
                     OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_credes_va45>).
        IF sy-subrc EQ 0.
          <lv_credes_va45> = <lfs_tvbst_va45>-bezei.     " Credit status description
          UNASSIGN: <lv_credes_va45>.
        ENDIF.
      ENDIF.

    ENDIF.

    " Read Invoice type description and Payement settle or not
    IF li_inv_det IS NOT INITIAL.
      ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-vbrk_vbeln
                    OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_billing>).
      IF sy-subrc = 0.
        READ TABLE li_inv_det ASSIGNING FIELD-SYMBOL(<lfs_inv_det>) WITH KEY vbeln = <lv_billing> BINARY SEARCH.
        IF sy-subrc = 0.
          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-bill_desc
                          OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_billdesc_va45>).
          IF sy-subrc EQ 0.
            <lv_billdesc_va45> = <lfs_inv_det>-vtext.           " Billing type description
            UNASSIGN: <lv_billdesc_va45>.
          ENDIF.

          ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-paid_status
                          OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_pstatus_va45>).
          IF sy-subrc EQ 0.
            IF <lfs_inv_det>-xblnr IS INITIAL.
              <lv_pstatus_va45> = lc_notpaid.        " Not Paid
            ELSE.
              <lv_pstatus_va45> = lc_paid.           " Paid
            ENDIF.
            UNASSIGN: <lv_pstatus_va45>.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    " Read Payer credit limit
    IF li_creditlimit IS NOT INITIAL.
      READ TABLE li_creditlimit ASSIGNING FIELD-SYMBOL(<lfs_creditlimit>) WITH KEY vbeln = <lv_vbeln> BINARY SEARCH.
      IF sy-subrc = 0.
        ASSIGN COMPONENT zclqtc_badi_sdoc_wrapper_mass=>c_table_field-cr_limit
                  OF STRUCTURE <lst_result> TO FIELD-SYMBOL(<lv_crlimit_va45>).
        IF sy-subrc = 0.
          <lv_crlimit_va45> = <lfs_creditlimit>-credit_limit.           " Credit limit
          UNASSIGN:<lv_crlimit_va45>.
        ENDIF.
      ENDIF.
    ENDIF.

*---End of change by Lahiru on 05/19/2020 ERPM-14773 with ED2K918229---*
  ENDLOOP.
ENDIF.
