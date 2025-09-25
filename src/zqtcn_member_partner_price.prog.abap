*&---------------------------------------------------------------------*
*&  Include           ZQTCN_MEMBER_PARTNER_PRICE
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_MEMBER_PARTNER_PRICE (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBAK(MV45AFZZ)"
* PROGRAM DESCRIPTION: This can be used to determine price group,
*                      ZA partner function & member type for
*                      particular order type
* DEVELOPER: Manami Chaudhuri
* CREATION DATE:   09/02/2017
* OBJECT ID: E106
* TRANSPORT NUMBER(S): ED2K904422
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K905724
* REFERENCE NO: E106/JIRA_ERP-2613
* DEVELOPER: Lucky Kodwani
* DATE:  2017-06-06
* DESCRIPTION: Changes has done inside below tags
* Begin of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
* End of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K906690
* REFERENCE NO: E106/JIRA_ERP-2718
* DEVELOPER: Writtick Roy
* DATE:  2017-06-13
* DESCRIPTION: Use the Original Relationship Category; it was getting
*              overwritten through CR#549 logic.
* Changes has done inside below tags
* Begin of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
* End   of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
*----------------------------------------------------------------------*
* REVISION NO:  ED2K906872
* REFERENCE NO: E106/JIRA_ERP-2852
* DEVELOPER: Writtick Roy
* DATE:  2017-06-23
* DESCRIPTION: Add XVBKD line, if doesn't exist
* Changes has done inside below tags
* Begin of ADD:ERP-2852:WROY:23-JUN-2017:ED2K906872
* End   of ADD:ERP-2852:WROY:23-JUN-2017:ED2K906872
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K906893
* REFERENCE NO: E106/JIRA_ERP-2994
* DEVELOPER: Lucky Kodwani(LKODWANI)
* DATE:  2017-07-03
* DESCRIPTION: Changes has done inside below tags
* Begin of CHANGE:ERP-2994:LKODWANI:03-July-2017:ED2K906893
* End of CHANGE:ERP-2994:LKODWANI:03-July-2017:ED2K906893
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908045/ED2K908043
* REFERENCE NO: E074 - CR#582
* DEVELOPER: Writtick Roy (WROY)
* DATE: 18-AUG-2017
* DESCRIPTION: Do not populate standard TKOMK fields, since those are
*              being used for Pricing calculations
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908326
* REFERENCE NO: ERP-4124
* DEVELOPER: Writtick Roy (WROY)
* DATE: 01-SEP-2017
* DESCRIPTION: Delete Duplicate Lines
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908326
* REFERENCE NO:  Defect 4250
* DEVELOPER: Anirban Saha
* DATE:  2017-09-07
* DESCRIPTION: Performance improvement: Avoid multiple selection
*              from table KNMT and BUT050
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K909897, ED2K909899
* REFERENCE NO: ERP-5167
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2017-12-14
* DESCRIPTION: Populating Material Group 5 for Society Materials
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910044
* REFERENCE NO: ERP-5621
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-01-23
* DESCRIPTION: Delete ZA Partner, if already exists, if Society Partner
*              is not determined.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910517, ED2K910519
* REFERENCE NO: ERP-6182
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-01-25
* DESCRIPTION: Skip Material Group 5 logic for Account Managed scenario
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910630
* REFERENCE NO: ERP-6178
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-01-31
* DESCRIPTION: Do not remove Material Group 5 if ZA Partner (Society)
*              is not determined
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910808
* REFERENCE NO: ERP-5621
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-02-09
* DESCRIPTION: Repopulate Price Group if Pricing Date or SD Document
*              Currency is changed.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911018
* REFERENCE NO: ERP-6582
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-02-22
* DESCRIPTION: Populate Price Group in Communication Header for Pricing
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911018
* REFERENCE NO: ERP-6899
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-03-08
* DESCRIPTION: Populate Material Group 5 for Offline scenario
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911374
* REFERENCE NO: ERP-7046
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-03-15
* DESCRIPTION: Additional Logic to populate Material Group 5
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911406
* REFERENCE NO: ERP-7055
* DEVELOPER: Writtick Roy (WROY)
* DATE:  2018-03-15
* DESCRIPTION: Do not populate Customer description (KNREF) field
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO: Incident # SCTASK002560
* DEVELOPER: Siva Guda (SGUDA)
* DATE:  2018-06-01
* DESCRIPTION: Populating Partner Price type (VBKD-PLTYP), if ship-to has
*              been changed from Order item level. Needs to check partner
*              relationship and populate the Price type
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K914086
* REFERENCE NO: ERP-7752
* DEVELOPER:    Himanshu Patel (HIPATEL)
* DATE:         2019-04-09
* DESCRIPTION:  Institutional 'Free order' feeding ALM as institutional
*               rather than comp
*        Soln : If Order Type = ZCOP, PO Type = 0230 or 0104,
*               Net Price  = 00 and Item Cat = ZFRE, needs to populate
*               Price Group = "01" - Complimentary - C
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K915123
* REFERENCE NO: ERP-7626
* DEVELOPER:    Prabhu (PTUFARAM)
* DATE:         2019-05-28
* DESCRIPTION:  Program Error - Billing plan issue -
*               User unable to view/change the Contract due to billing plan number issue
*        Soln : When header is getting copied into Item, billing plan number should
*               be blank as SAP generates a new billing plan number for the item
*               *--SAP has suggested the solution--*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915227
* REFERENCE NO: DM-1901 E106
* DEVELOPER:Murali(MIMMADISET)
* DATE: 2019-06-07
* DESCRIPTION:DM-1901 Price Group in WOL Orders can not be overridden from customer default
*----------------------------------------------------------------------
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K918427
* REFERENCE NO: ERPM-17190 & ERPM-4390
* DEVELOPER:    Prabhu (PTUFARAM)
* DATE:         2020-06-09
* DESCRIPTION:  Offline single issue order Material group5 and
*               Price group update
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------
* Local types / data declaration
TYPES :
  BEGIN OF lty_kunnr,
    kunnr TYPE kunnr_v,             " Customer
  END OF lty_kunnr,

*Begin of Add-Anirban-09.07.2017-ED2K908326-Defect 4250
  BEGIN OF lty_kunnr_t,
    vkorg TYPE vkorg,
    vtweg TYPE vtweg,
    kunnr TYPE kunnr_v,             " Customer
    matnr TYPE matnr,
*   Begin of ADD:ERP-5167:WROY:14-Dec-2017:ED2K909897
    sortl TYPE sortl,               " Sort field
*   End   of ADD:ERP-5167:WROY:14-Dec-2017:ED2K909897
  END OF lty_kunnr_t,

  BEGIN OF lty_reltyp_t,
    partner1 TYPE bu_partner,
    partner2 TYPE bu_partner,
    reltyp   TYPE bu_reltyp,          " Relation type
  END OF lty_reltyp_t,

*End of Add-Anirban-09.07.2017-ED2K908326-Defect 4250

  BEGIN OF lty_reltyp,
    reltyp TYPE bu_reltyp,          " Relation type
  END OF lty_reltyp,

  BEGIN OF lty_constant,
    devid  TYPE zdevid,             " Development ID
    param1 TYPE rvari_vnam,         " ABAP: Name of Variant Variable
    param2 TYPE rvari_vnam,         " ABAP: Name of Variant Variable
    srno   TYPE tvarv_numb,         " ABAP: Current selection number
    sign   TYPE tvarv_sign,         " ABAP: ID: I/E (include/exclude values)
    opti   TYPE tvarv_opti,         " ABAP: Selection option (EQ/BT/CP/...)
    low    TYPE salv_de_selopt_low, " Lower Value of Selection Condition
    high   TYPE salv_de_selopt_high, " Upper Value of Selection Condition
  END OF lty_constant,

  BEGIN OF lty_konda,
    sign   TYPE tvarv_sign,         " Sign
    option TYPE tvarv_opti,         " Option
    low    TYPE konda,              " Konda
    high   TYPE konda,              " Konda
  END OF lty_konda,

* Begin of ADD:ERP-5167:WROY:14-Dec-2017:ED2K909897
  BEGIN OF lty_mvgr5,
    sign   TYPE tvarv_sign,         " Sign
    option TYPE tvarv_opti,         " Option
    low    TYPE mvgr5,              " Material Group 5
    high   TYPE mvgr5,              " Material Group 5
  END OF lty_mvgr5,
* Begin of CHANGE:CR#DM-1901:MIMMADISET:07-June-2019:ED2K915227
  BEGIN OF ty_reltyp,
    partner1 TYPE bu_partner,
    reltyp   TYPE bu_reltyp,
    credat   TYPE dats,
    docnum   TYPE edi_docnum,
  END OF ty_reltyp,
* End of CHANGE:CR#DM-1901:MIMMADISET:07-June-2019:ED2K915227
  ltt_mvgr5     TYPE STANDARD TABLE OF lty_mvgr5 INITIAL SIZE 0,
* End   of ADD:ERP-5167:WROY:14-Dec-2017:ED2K909897

* Begin of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
  ltt_prc_grp_a TYPE fip_t_auart_range,     " Sales Document Type
  ltt_prc_grp_p TYPE rjksd_pstyv_range_tab, " Sales Document Item Category
* End of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724

  ltt_konda     TYPE STANDARD TABLE OF lty_konda INITIAL SIZE 0.


DATA :
* Begin of DEL:ERP-5621:WROY:23-Jan-2018:ED2K910044
* li_constant     TYPE STANDARD TABLE OF lty_constant INITIAL SIZE 0, " Constant tab
* End   of DEL:ERP-5621:WROY:23-Jan-2018:ED2K910044
  li_kunnr              TYPE STANDARD TABLE OF lty_kunnr INITIAL SIZE 0,    " Society
  li_reltyp             TYPE STANDARD TABLE OF lty_reltyp INITIAL SIZE 0,   " Rel type
  lr_kdgrp_v            TYPE ltt_konda,                                     " Cust grp
  lr_kdgrp              TYPE ltt_konda,                                     " Cust grp
* Begin of ADD:ERP-5167:WROY:14-Dec-2017:ED2K909897
  lr_mvgr5_soc          TYPE ltt_mvgr5,                                     " Mat Grp 5
* End   of ADD:ERP-5167:WROY:14-Dec-2017:ED2K909897
  lst_kdgrp             LIKE LINE OF lr_kdgrp,                              " Cust grp
  lst_rel               TYPE zqtc_relationcat,                              " Rel type
  lst_xvbpa             TYPE vbpavb,                                        " Partner taable
  lst_xvbkd             TYPE vbkdvb,                                        " Price grp
  lst_kna1              TYPE kna1,                                          " General Data in Customer Master
  lv_konda_v            TYPE konda,                                         " Price grp
  lv_konda              TYPE konda,                                         " Price grp
  lv_flag               TYPE char1,                                         " Flag
* Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
  lv_pr_e106            TYPE zzpartner2,                                    " Business Partner 2 or Society number
  lv_rt_e106            TYPE bu_reltyp,                                     " Business Partner Relationship Category
* End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
* Begin of ADD:ERP-4124:WROY:01-SEP-2017:ED2K908326
  lv_count_e106         TYPE i,
  lv_index_e106         TYPE syindex,
  li_dl_indx_e106       TYPE /sapcnd/syindex_t,
* End   of ADD:ERP-4124:WROY:01-SEP-2017:ED2K908326
* Begin of ADD:ERP-6182:WROY:25-Jan-2018:ED2K910517
  lir_po_type_am        TYPE tdt_rg_bsark,
  lir_sls_offc_am       TYPE rjksd_vkbur_range_tab,
* End   of ADD:ERP-6182:WROY:25-Jan-2018:ED2K910517
* Begin of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
  lir_prc_grp_p         TYPE ltt_prc_grp_p,
  lst_prc_grp_p         TYPE LINE OF ltt_prc_grp_p,
* End of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
*Start of ADD:ERP-7752:HIPATEL:ED2K914086: 09-Apr-2019
  lir_itm_cat_cop       TYPE ltt_prc_grp_p,   "Item Category
*End of ADD:ERP-7752:HIPATEL:ED2K914086: 09-Apr-2019
* Begin of CHANGE:CR#599:WROY:25-July-2017:ED2K907347
  lir_bsark_am          TYPE tdt_rg_bsark,
* End   of CHANGE:CR#599:WROY:25-July-2017:ED2K907347
* Begin of CHANGE:CR DM-1901:mimmadiset:07-june-2019:ED2K915227
  lir_bsark_wol         TYPE tdt_rg_bsark,
* End of change:CR DM-1901:mimmadiset:07-june-2019:ED2K915227
* Begin of CHANGE:ERP-2994:LKODWANI:03-July-2017:ED2K906893
  lir_prc_grp_cop       TYPE ltt_prc_grp_a,
  lst_prc_grp_cop       TYPE LINE OF ltt_prc_grp_a,
  lir_prc_grp_sub       TYPE ltt_prc_grp_a,
  lst_prc_grp_sub       TYPE LINE OF ltt_prc_grp_a,
* End of CHANGE:ERP-2994:LKODWANI:03-July-2017:ED2K906893
  lir_order_type_off    TYPE TABLE OF rjksd_auart_range,
  lir_order_type_single TYPE TABLE OF rjksd_auart_range,
  lir_itm_cat_off       TYPE  rjksd_pstyv_range_tab,
  lir_itm_cat_single    TYPE  rjksd_pstyv_range_tab,
*  lir_itm_cat_off_zsiq TYPE ltt_prc_grp_p,
*  lir_prc_grp_off_zor  TYPE ltt_prc_grp_p,
  lir_prc_grp_off       TYPE ltt_prc_grp_p,
  lv_media_prod         TYPE ismrefmdprod,
  lv_mvgr5              TYPE mvgr5,
  lv_price_grp_ref      TYPE rvari_vnam.
*Begin of Add-Anirban-09.07.2017-ED2K908326-Defect 4250
STATICS: li_kunnr_t  TYPE STANDARD TABLE OF lty_kunnr_t INITIAL SIZE 0,
         li_reltyp_t TYPE STANDARD TABLE OF lty_reltyp_t INITIAL SIZE 0,
*         Begin of ADD:ERP-5621:WROY:23-Jan-2018:ED2K910044
         li_constant TYPE STANDARD TABLE OF lty_constant INITIAL SIZE 0, " Constant tab
*         End   of ADD:ERP-5621:WROY:23-Jan-2018:ED2K910044
* Begin of CHANGE:CR#DM-1901:MIMMADISET:07-June-2019:ED2K915227
         lst_reltyp  TYPE ty_reltyp.
* eoc of CHANGE:CR#DM-1901:MIMMADISET:07-June-2019:ED2K915227
DATA : lst_kunnr             TYPE lty_kunnr,
       lst_kunnr_t           TYPE lty_kunnr_t,
       lst_reltyp_t          TYPE lty_reltyp_t,
* Begin of CHANGE:CR#DM-1901:MIMMADISET:07-June-2019:ED2K915227
       lv1_actv_flag_e106    TYPE zactive_flag, " Active / Inactive Flag
       lv_mem_name           TYPE char30,
       lv_mem_name_h         TYPE char30,  "Header Memory
* End of CHANGE:CR#DM-1901:MIMMADISET:07-June-2019:ED2K915227
*End of Add-Anirban-09.07.2017-ED2K908326-Defect 4250
       lv_actv_flag_e106_off TYPE zactive_flag. " Active / Inactive Fl


CONSTANTS :
  lc_indicator       TYPE updkz_d    VALUE 'I',       " Insert
  lc_objectid        TYPE zdevid     VALUE 'E106',    " Object id
  lc_konda           TYPE rvari_vnam VALUE 'KONDA',   " Price grp
  lc_konda_v         TYPE rvari_vnam VALUE 'KONDA_V', " Price grp
  lc_kdgrp           TYPE rvari_vnam VALUE 'KDGRP',   " Customer grp
  lc_kdgrp_v         TYPE rvari_vnam VALUE 'KDGRP_V', " Customer grp
* Begin of CHANGE:CR#599:WROY:25-July-2017:ED2K907347
  lc_bsark_am        TYPE rvari_vnam VALUE 'BSARK_AM',  " ABAP: Name of Variant Variable
* End   of CHANGE:CR#599:WROY:25-July-2017:ED2K907347
* Begin of CHANGE:CR#DM-1901:MIMMADISET:07-June-2019:ED2K915227
  lc_ser_num_4_e106  TYPE zsno       VALUE '004',  " Serial Number
  lc_rel_h           TYPE char15     VALUE '_REL_TYPE_H', "Relation ship type header and item
  lc_bsark_wol       TYPE rvari_vnam VALUE 'BSARK_WOL',  " ABAP: Name of Variant Variable
* End   of CHANGE:CR#DM-1901:MIMMADISET:07-June-2019:ED2K915227
* Begin of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
  lc_price_grp       TYPE rvari_vnam VALUE 'PRICE_GRP', " ABAP: Name of Variant Variable
  lc_prc_grp_sub     TYPE rvari_vnam VALUE 'AUART_SUB', " ABAP: Name of Variant Variable
  lc_prc_grp_cop     TYPE rvari_vnam VALUE 'AUART_COP', " ABAP: Name of Variant Variable
  lc_prc_grp_p       TYPE rvari_vnam VALUE 'PSTYV',     " ABAP: Name of Variant Variable
* End of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
*Start of ADD:ERP-7752:HIPATEL:ED2K914086: 09-Apr-2019
  lc_itm_cat_cop     TYPE rvari_vnam VALUE 'PSTYV_COP',  " ABAP: Name of Variant Variable
*End of ADD:ERP-7752:HIPATEL:ED2K914086: 09-Apr-2019
* Begin of ADD:ERP-5167:WROY:14-Dec-2017:ED2K909897
  lc_mat_grp_5       TYPE rvari_vnam VALUE 'MAT_GRP_5', " ABAP: Name of Variant Variable
  lc_society         TYPE rvari_vnam VALUE 'SOCIETY',   " ABAP: Name of Variant Variable
* End   of ADD:ERP-5167:WROY:14-Dec-2017:ED2K909897
* Begin of ADD:ERP-6182:WROY:25-Jan-2018:ED2K910517
  lc_acc_managed     TYPE rvari_vnam VALUE 'ACC_MANAGED',  " ABAP: Name of Variant Variable
  lc_cust_po_typ     TYPE rvari_vnam VALUE 'CUST_PO_TYPE', " ABAP: Name of Variant Variable
  lc_sales_offc      TYPE rvari_vnam VALUE 'SALES_OFFICE', " ABAP: Name of Variant Variable
* End   of ADD:ERP-6182:WROY:25-Jan-2018:ED2K910517
  lc_partner         TYPE parvw      VALUE 'ZA', " Partner
  lc_p_type_ku       TYPE nrart      VALUE 'KU', " Type of partner number
  lc_incmp_07        TYPE fehgr      VALUE '07', " Incompletion procedure for sales document
  lc_adr_ind_d       TYPE adrda      VALUE 'D',  " Address Indicator
*   Begin of ADD:Incident # SCTASK002560:SGUDA:01-June-2018:
  lc_rel_type        TYPE bu_reltyp  VALUE 'ZIR',
  lc_ser_num_5_e106  TYPE zsno       VALUE '005',  " Serial Number.
  lc_item_cat_off    TYPE rvari_vnam VALUE 'ITEM_CAT_OFFLINE_SINGLE',
  lc_item_cat_single TYPE rvari_vnam VALUE 'ITEM_CAT_SINGLE_ISSUE',
  lc_zor_off         TYPE rvari_vnam VALUE 'ZOR',
  lc_zsiq_off        TYPE rvari_vnam VALUE 'ZSIQ',
  lc_order_type_off  TYPE rvari_vnam VALUE 'ORDER_TYPE',
  lc_price_grp_off   TYPE rvari_vnam VALUE 'PRICE_GRP_OFFLINE_SINGLE',
  lc_offline_single  TYPE rvari_vnam VALUE 'OFFLINE_SINGLE',
  lc_single_issue    TYPE rvari_vnam VALUE 'SINGLE_ISSUE'.
***Field symbol declaration***
*FIELD-SYMBOLS: <lst_xvbkd_cr> TYPE vbkdvb.
*   End of ADD:Incident # SCTASK002560:SGUDA:01-June-2018:

* FM determines current document type ( VBAK-AUART )
* is maintain in constant table or not.Basically
* this code will trigger for particular subscription
* order type
CALL FUNCTION 'ZQTC_ORDER_TYPE_DETERMINE'
  EXPORTING
    im_auart       = vbak-auart
  IMPORTING
    ex_active_flag = lv_flag.

* If document type matches then go further
IF lv_flag = abap_true.
* if relationship category and partner already derived by
* E075 then just pass value to custom table and get price grp
* Otherwise JOIN BUT050 & KNMT table and then get value from Z table

* Begin of ADD:ERP-5167:WROY:14-Dec-2017:ED2K909897
  IF li_kunnr_t IS INITIAL.
    SELECT vkorg vtweg kunnr matnr sortl
      FROM knmt
      INTO TABLE li_kunnr_t
      WHERE vkorg = tkomk-vkorg
      AND   vtweg = tkomk-vtweg.
    IF sy-subrc = 0.
      SORT li_kunnr_t BY matnr kunnr.
    ENDIF.
  ENDIF.
* End   of ADD:ERP-5167:WROY:14-Dec-2017:ED2K909897
  IF tkomk-zzpartner2 IS INITIAL "Business Partner 2 or Society number
  AND tkomk-zzreltyp IS INITIAL. "Business Partner Relationship Category

*Begin of Add-Anirban-09.07.2017-ED2K908326-Defect 4250
*   Begin of DEL:ERP-5167:WROY:14-Dec-2017:ED2K909897
*   IF li_kunnr_t IS INITIAL.
*     SELECT vkorg vtweg kunnr matnr
*       FROM knmt
*       INTO TABLE li_kunnr_t
*       WHERE vkorg = tkomk-vkorg
*       AND   vtweg = tkomk-vtweg.
*     IF sy-subrc = 0.
*       SORT li_kunnr_t BY matnr.
*     ENDIF.
*   ENDIF.
*   End   of DEL:ERP-5167:WROY:14-Dec-2017:ED2K909897

    READ TABLE li_reltyp_t INTO lst_reltyp_t WITH KEY partner1 = kuwev-kunnr.
    IF sy-subrc NE 0.
      SELECT partner1 partner2 reltyp
        FROM but050 APPENDING TABLE li_reltyp_t
        WHERE partner1 = kuwev-kunnr
        AND date_to   GE sy-datum
        AND date_from LE sy-datum.
      IF sy-subrc = 0.
        SORT li_reltyp_t BY partner1 partner2.
      ELSE.
        CLEAR: lst_reltyp_t.
        lst_reltyp_t-partner1 = kuwev-kunnr.
        APPEND lst_reltyp_t TO li_reltyp_t.
        SORT li_reltyp_t BY partner1 partner2.
      ENDIF.
    ENDIF.

    READ TABLE li_kunnr_t TRANSPORTING NO FIELDS
         WITH KEY matnr = vbap-matnr
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      LOOP AT li_kunnr_t INTO lst_kunnr_t FROM sy-tabix.
        IF lst_kunnr_t-matnr NE vbap-matnr.
          EXIT.
        ENDIF.
        READ TABLE li_reltyp_t INTO lst_reltyp_t
             WITH KEY partner1 = kuwev-kunnr
                      partner2 = lst_kunnr_t-kunnr
             BINARY SEARCH.
        IF sy-subrc = 0.
          lv_pr_e106 = lst_reltyp_t-partner2.
          lv_rt_e106 = lst_reltyp_t-reltyp.
          lv_rt_orgn = lst_reltyp_t-reltyp.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
*End of Add-Anirban-09.07.2017-ED2K908326-Defect 4250
*Begin of Del-Anirban-09.07.2017-ED2K908326-Defect 4250
* Get Society number from Customer-Material Info Record table
*    SELECT kunnr          " Customer number
*      FROM knmt           " Customer-Material Info Record Data Table
*      INTO TABLE li_kunnr " Society no.
*      WHERE vkorg = tkomk-vkorg
*      AND vtweg = tkomk-vtweg
*      AND matnr = vbap-matnr.
*
*
** Get Relationship category from BP relationships/role TABLE
*    IF li_kunnr IS NOT INITIAL.
*
*      SELECT reltyp                   " Business Partner Relationship Category
*        FROM but050                   " BP relationships/role definitions: General data
*        INTO TABLE li_reltyp          " Rel type
*        FOR ALL ENTRIES IN li_kunnr
*        WHERE partner1 = kuwev-kunnr  " BP partner
*        AND partner2 = li_kunnr-kunnr " Society no.
*        AND date_to   GE sy-datum
*        AND date_from LE sy-datum.
*      IF sy-subrc = 0.
*
*** As per communication , there will be only single value
*** maintain for one member
*        READ TABLE  li_reltyp INTO DATA(lst_reltyp) INDEX 1.
**       Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
*        lv_pr_e106       = li_kunnr[ lines( li_kunnr[] ) ]-kunnr . " society number
*        lv_rt_e106     = lst_reltyp-reltyp. " relationship type
**       End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
**       Begin of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
**       tkomk-zzpartner2 = li_kunnr[ lines( li_kunnr[] ) ]-kunnr . " society number
**       tkomk-zzreltyp = lst_reltyp-reltyp. " relationship type
**       End   of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
**       Begin of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
*        lv_rt_orgn     = lst_reltyp-reltyp. " relationship type
**       End   of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
*      ENDIF. " IF sy-subrc = 0
*
*    ENDIF. " IF li_kunnr IS NOT INITIAL
** Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045


*End of Del-Anirban-09.07.2017-ED2K908326-Defect 4250
  ELSE.
    lv_pr_e106 = tkomk-zzpartner2.                                 " Business Partner 2 or Society number
    lv_rt_e106 = tkomk-zzreltyp.                                   " Business Partner Relationship Category
* End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
  ENDIF. " IF tkomk-zzpartner2 IS INITIAL

*Begin of CHANGE:CR#DM-1901:MIMMADISET:07-June-2019:ED2K915227
*If the PO type is – 0300 / 0301,check the inbound Idoc  segment -E1EDKA1WE
*Object id E106 and Serial number 004 is calling in anothere include also
*zqtcn_insub_i0343(ZXVEDU03) To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e106
      im_ser_num     = lc_ser_num_4_e106
    IMPORTING
      ex_active_flag = lv1_actv_flag_e106.

  IF lv1_actv_flag_e106 EQ abap_true.
    IF idoc_number IS NOT INITIAL.
      IF li_constant[] IS INITIAL.
* fetch constant table entry for price grp and customer grp
        SELECT devid        " Development ID
               param1       " ABAP: Name of Variant Variable
               param2       " ABAP: Name of Variant Variable
               srno         " ABAP: Current selection number
               sign         " ABAP: ID: I/E (include/exclude values)
               opti         " ABAP: Selection option (EQ/BT/CP/...)
               low          " Lower Value of Selection Condition
               high         " Upper Value of Selection Condition
           FROM zcaconstant " Wiley Application Constant Table
           INTO TABLE li_constant
           WHERE devid    EQ lc_objectid
             AND activate EQ abap_true.
        IF sy-subrc EQ 0.
          SORT li_constant BY devid param1 param2 low.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF."IF li_constant[] IS INITIAL.
      LOOP AT li_constant INTO DATA(lst1_constant)
        WHERE param1 = lc_bsark_wol.
        CASE lst1_constant-param1.
          WHEN lc_bsark_wol.
            APPEND INITIAL LINE TO lir_bsark_wol
            ASSIGNING FIELD-SYMBOL(<lst_bsark_wol>).
            <lst_bsark_wol>-sign   = lst1_constant-sign.
            <lst_bsark_wol>-option = lst1_constant-opti.
            <lst_bsark_wol>-low    = lst1_constant-low.
            <lst_bsark_wol>-high   = lst1_constant-high.
        ENDCASE.
      ENDLOOP.
      IF vbak-bsark IN lir_bsark_wol AND lir_bsark_wol IS NOT INITIAL.
* Fetch the Relationship category passed from IDOC via ABAP shared memory from header and item level
* lst_reltyp-reltyp is exporting from include zqtcn_insub_i0343(ZXVEDU03)
        CONCATENATE rv45a-docnum lc_rel_h INTO lv_mem_name_h.
        IMPORT lst_reltyp FROM MEMORY ID lv_mem_name_h.
        IF sy-subrc = 0 AND lst_reltyp-reltyp IS NOT INITIAL.
          FREE MEMORY ID lv_mem_name_h. "Clear the header shared memory
        ENDIF."IF sy-subrc = 0 AND lst_reltyp-reltyp IS NOT INITIAL.
*if lst_reltyp_h-reltyp is initial existing code will mark for individual price group.
        IF lst_reltyp-reltyp IS NOT INITIAL.
          lv_rt_e106 = lst_reltyp-reltyp.
          lv_rt_orgn = lst_reltyp-reltyp.
        ENDIF."if lst_reltyp-docnum = rv45a-docnum.
      ENDIF. "vbak-bsark IN lir_bsark_wol and lir_bsark_wol is not INITIAL.
    ENDIF. "IF idoc_number IS NOT INITIAL.
  ENDIF.  "lv_actv_flag_e106 EQ abap_true.
* End of CHANGE:CR#DM-1901:MIMMADISET:07-June-2019:ED2K915227
* Begin of ADD:ERP-2852:WROY:23-JUN-2017:ED2K906872
  READ TABLE xvbkd INTO DATA(lst_xvbkd_e106)
  WITH KEY posnr = vbap-posnr
* Begin of ADD:ERP-4124:WROY:01-SEP-2017:ED2K908326
  BINARY SEARCH.
* End   of ADD:ERP-4124:WROY:01-SEP-2017:ED2K908326
  IF sy-subrc NE 0.
    READ TABLE xvbkd INTO lst_xvbkd_e106
    WITH KEY posnr = posnr_low
*   Begin of ADD:ERP-4124:WROY:01-SEP-2017:ED2K908326
    BINARY SEARCH.
*   End   of ADD:ERP-4124:WROY:01-SEP-2017:ED2K908326
    IF sy-subrc EQ 0.
      lst_xvbkd_e106-posnr = vbap-posnr.
      lst_xvbkd_e106-updkz = updkz_new.
*--*Begin of ADD:ERP-7626:PRABHU:28-May-2019:ED2K915123
      CLEAR : lst_xvbkd_e106-fplnr.
*--*End of ADD:ERP-7626:PRABHU:28-May-2019:ED2K915123
      APPEND lst_xvbkd_e106 TO xvbkd.
      CLEAR: lst_xvbkd_e106.
      SORT xvbkd BY vbeln posnr.
    ENDIF. " IF sy-subrc EQ 0
* Begin of ADD:ERP-4124:WROY:01-SEP-2017:ED2K908326
  ELSE.
*   Delete if there are Duplicate lines
    CLEAR: li_dl_indx_e106,
           lv_count_e106.
    LOOP AT xvbkd INTO lst_xvbkd_e106 FROM sy-tabix.
      IF lst_xvbkd_e106-posnr NE vbap-posnr.
        EXIT.
      ENDIF.
      lv_index_e106 = sy-tabix.
      lv_count_e106 = lv_count_e106 + 1.
      IF lv_count_e106 GT 1.
        INSERT lv_index_e106 INTO TABLE li_dl_indx_e106.
      ENDIF.
    ENDLOOP.
    IF li_dl_indx_e106[] IS NOT INITIAL.
      LOOP AT li_dl_indx_e106 INTO lv_index_e106.
        DELETE xvbkd INDEX lv_index_e106.
      ENDLOOP.
    ENDIF.
* End   of ADD:ERP-4124:WROY:01-SEP-2017:ED2K908326
  ENDIF. " IF sy-subrc NE 0
* End   of ADD:ERP-2852:WROY:23-JUN-2017:ED2K906872

* Begin of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
*  IF rv02p-weupd EQ abap_true. " Ship-to Party is changed
  IF rv02p-weupd EQ abap_true OR " Ship-to Party is changed
*    Begin of ADD:ERP-5621:WROY:09-Feb-2018:ED2K910808
     vbkd-prsdt  NE *vbkd-prsdt OR " Pricing Date
     vbak-waerk  NE *vbak-waerk OR " SD Document Currency
*    End   of ADD:ERP-5621:WROY:09-Feb-2018:ED2K910808
     vbap-pstyv  NE *vbap-pstyv. " Item Category is changed
* End of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
    READ TABLE xvbkd ASSIGNING FIELD-SYMBOL(<lst_xvbkd>)
    WITH KEY posnr = vbap-posnr.
    IF sy-subrc = 0.
      CLEAR: <lst_xvbkd>-konda.
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF rv02p-weupd EQ abap_true OR

* Get price group and partner details from zqtc_relationcat
* Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
  IF lv_rt_e106     IS NOT INITIAL. "Business Partner Relationship Category
* End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
* Begin of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
* IF tkomk-zzreltyp IS NOT INITIAL. "Business Partner Relationship Category
* End   of DL:CR#582:WROY:18-AUG-2017:ED2K908045
* All the fields are required to select
    SELECT SINGLE *
      INTO lst_rel
      FROM zqtc_relationcat " Relation b/t relationship category & Price group
*     Begin of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
      WHERE reltyp = lv_rt_orgn.
*     WHERE reltyp = tkomk-zzreltyp.
*     End   of ADD:ERP-2718:WROY:13-JUN-2017:ED2K906690
* Read XVBKD table for particular line item

    READ TABLE xvbkd ASSIGNING <lst_xvbkd>
    WITH KEY posnr = vbap-posnr.
    IF sy-subrc = 0.
      IF lst_rel IS NOT INITIAL.
        IF <lst_xvbkd>-konda IS INITIAL.
          <lst_xvbkd>-konda = lst_rel-konda. " Price grp
        ENDIF. " IF <lst_xvbkd>-konda IS INITIAL
        <lst_xvbkd>-kdkg2   = lst_rel-kdkg2. " Customer condition group 2
      ENDIF. " IF lst_rel IS NOT INITIAL
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF tkomk-zzreltyp IS NOT INITIAL
*   Begin of ADD:Incident # SCTASK002560:SGUDA:01-June-2018
  READ TABLE xvbkd ASSIGNING <lst_xvbkd>
  WITH KEY posnr = vbap-posnr.
  IF sy-subrc = 0.
    IF vbak-kunnr NE kuwev-kunnr.
      IF tkomk-zzreltyp IS NOT INITIAL.
        IF tkomk-vkorg = vbak-vkorg AND tkomk-zzreltyp CS lc_rel_type.
          <lst_xvbkd>-pltyp = kuagv-pltyp.
          vbkd-pltyp  = kuagv-pltyp.
        ENDIF.
      ELSE.
        READ TABLE li_reltyp_t INTO lst_reltyp_t WITH KEY partner1 = kuwev-kunnr.
        IF sy-subrc EQ 0 AND tkomk-vkorg = vbak-vkorg AND lst_reltyp_t-reltyp CS lc_rel_type..
          <lst_xvbkd>-pltyp = kuagv-pltyp.
          vbkd-pltyp  = kuagv-pltyp.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
*   End of ADD:Incident # SCTASK002560:SGUDA:01-June-2018
* If relation type is not maintain in Z table , hit constant table and
* populate the value based on condition
  READ TABLE xvbkd ASSIGNING <lst_xvbkd>
  WITH KEY posnr = vbap-posnr.
  IF sy-subrc = 0 .
* Begin of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
*if  <lst_xvbkd>-konda IS INITIAL.
* End of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
*   Begin of ADD:ERP-5621:WROY:23-Jan-2018:ED2K910044
    IF li_constant[] IS INITIAL.
*   End   of ADD:ERP-5621:WROY:23-Jan-2018:ED2K910044
* fetch constant table entry for price grp and customer grp
      SELECT devid        " Development ID
             param1       " ABAP: Name of Variant Variable
             param2       " ABAP: Name of Variant Variable
             srno         " ABAP: Current selection number
             sign         " ABAP: ID: I/E (include/exclude values)
             opti         " ABAP: Selection option (EQ/BT/CP/...)
             low          " Lower Value of Selection Condition
             high         " Upper Value of Selection Condition
         FROM zcaconstant " Wiley Application Constant Table
         INTO TABLE li_constant
         WHERE devid    EQ lc_objectid
           AND activate EQ abap_true.

      IF sy-subrc EQ 0.
        SORT li_constant BY devid param1 param2 low.
      ENDIF. " IF sy-subrc EQ 0
*   Begin of ADD:ERP-5621:WROY:23-Jan-2018:ED2K910044
    ENDIF.
*   End   of ADD:ERP-5621:WROY:23-Jan-2018:ED2K910044

    LOOP AT li_constant INTO DATA(lst_constant).

      CASE lst_constant-param1.

        WHEN lc_konda. " Customer price
          lv_konda = lst_constant-low.
        WHEN lc_kdgrp. " Customer group

          lst_kdgrp-sign = lst_constant-sign.
          lst_kdgrp-option = lst_constant-opti.
          lst_kdgrp-low = lst_constant-low .
          APPEND lst_kdgrp TO lr_kdgrp.
          CLEAR lst_kdgrp.

        WHEN lc_kdgrp_v. " Customer group

          lst_kdgrp-sign = lst_constant-sign.
          lst_kdgrp-option = lst_constant-opti.
          lst_kdgrp-low = lst_constant-low.
          APPEND lst_kdgrp TO lr_kdgrp_v.
          CLEAR lst_kdgrp.

        WHEN lc_konda_v. " Customer price
          lv_konda_v = lst_constant-low.
* Begin of CHANGE:CR#599:WROY:25-July-2017:ED2K907347
        WHEN lc_bsark_am.
          APPEND INITIAL LINE TO lir_bsark_am ASSIGNING FIELD-SYMBOL(<lst_bsark_am>).
          <lst_bsark_am>-sign   = lst_constant-sign.
          <lst_bsark_am>-option = lst_constant-opti.
          <lst_bsark_am>-low    = lst_constant-low.
          <lst_bsark_am>-high   = lst_constant-high.
* End   of CHANGE:CR#599:WROY:25-July-2017:ED2K907347
* Begin of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
        WHEN lc_price_grp.
          CASE lst_constant-param2.
            WHEN lc_prc_grp_sub.
              lst_prc_grp_sub-sign   = lst_constant-sign.
              lst_prc_grp_sub-option = lst_constant-opti.
              lst_prc_grp_sub-low    = lst_constant-low.
              lst_prc_grp_sub-high   = lst_constant-high.
              APPEND lst_prc_grp_sub TO lir_prc_grp_sub.
              CLEAR lst_prc_grp_sub.

            WHEN lc_prc_grp_cop.
              lst_prc_grp_cop-sign   = lst_constant-sign.
              lst_prc_grp_cop-option = lst_constant-opti.
              lst_prc_grp_cop-low    = lst_constant-low.
              lst_prc_grp_cop-high   = lst_constant-high.
              APPEND lst_prc_grp_cop TO lir_prc_grp_cop.
              CLEAR lst_prc_grp_cop.

            WHEN lc_prc_grp_p.
              lst_prc_grp_p-sign   = lst_constant-sign.
              lst_prc_grp_p-option = lst_constant-opti.
              lst_prc_grp_p-low    = lst_constant-low.
              lst_prc_grp_p-high   = lst_constant-high.
              APPEND lst_prc_grp_p TO lir_prc_grp_p.
              CLEAR lst_prc_grp_p.
*Start of ADD:ERP-7752:HIPATEL:ED2K914086: 09-Apr-2019
            WHEN lc_itm_cat_cop.
              lst_prc_grp_p-sign   = lst_constant-sign.
              lst_prc_grp_p-option = lst_constant-opti.
              lst_prc_grp_p-low    = lst_constant-low.
              lst_prc_grp_p-high   = lst_constant-high.
              APPEND lst_prc_grp_p TO lir_itm_cat_cop.
              CLEAR lst_prc_grp_p.
*End of ADD:ERP-7752:HIPATEL:ED2K914086: 09-Apr-2019
          ENDCASE. " IF lst_constant-param2 <> lc_konda
* End of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724

* Begin of ADD:ERP-5167:WROY:14-Dec-2017:ED2K909897
        WHEN lc_mat_grp_5.
          CASE lst_constant-param2.
            WHEN lc_society.
              APPEND INITIAL LINE TO lr_mvgr5_soc ASSIGNING FIELD-SYMBOL(<lst_mvgr5>).
              <lst_mvgr5>-sign   = lst_constant-sign.
              <lst_mvgr5>-option = lst_constant-opti.
              <lst_mvgr5>-low    = lst_constant-low.
              <lst_mvgr5>-high   = lst_constant-high.
            WHEN OTHERS.
          ENDCASE.
* End   of ADD:ERP-5167:WROY:14-Dec-2017:ED2K909897

* Begin of ADD:ERP-6182:WROY:25-Jan-2018:ED2K910517
        WHEN lc_acc_managed.
          CASE lst_constant-param2.
            WHEN lc_cust_po_typ.
              APPEND INITIAL LINE TO lir_po_type_am  ASSIGNING FIELD-SYMBOL(<lst_po_type_am>).
              <lst_po_type_am>-sign    = lst_constant-sign.
              <lst_po_type_am>-option  = lst_constant-opti.
              <lst_po_type_am>-low     = lst_constant-low.
              <lst_po_type_am>-high    = lst_constant-high.

            WHEN lc_sales_offc.
              APPEND INITIAL LINE TO lir_sls_offc_am ASSIGNING FIELD-SYMBOL(<lst_sls_offc_am>).
              <lst_sls_offc_am>-sign   = lst_constant-sign.
              <lst_sls_offc_am>-option = lst_constant-opti.
              <lst_sls_offc_am>-low    = lst_constant-low.
              <lst_sls_offc_am>-high   = lst_constant-high.

            WHEN OTHERS.
*             Nothing to Do
          ENDCASE.
* End   of ADD:ERP-6182:WROY:25-Jan-2018:ED2K910517
        WHEN OTHERS.
      ENDCASE.
      CLEAR lst_constant.
    ENDLOOP. " LOOP AT li_constant INTO DATA(lst_constant)
* Begin of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
* Begin of CHANGE:CR#599:WROY:25-July-2017:ED2K907347
*   IF <lst_xvbkd>-konda IS INITIAL.
    IF <lst_xvbkd>-konda IS INITIAL AND
       vbak-bsark NOT IN lir_bsark_am.
* End   of CHANGE:CR#599:WROY:25-July-2017:ED2K907347
* Begin of CHANGE:ERP-2994:LKODWANI:03-July-2017:ED2K906893
      IF ( vbak-auart IN lir_prc_grp_sub AND
           vbap-pstyv IN lir_prc_grp_p ) OR
         ( vbak-auart IN lir_prc_grp_cop ).
* End of CHANGE:ERP-2994:LKODWANI:03-July-2017:ED2K906893
        CLEAR lst_constant.
        READ TABLE li_constant INTO lst_constant WITH KEY param1 = lc_price_grp
                                                          param2 = lc_konda.
        IF sy-subrc EQ 0.
          <lst_xvbkd>-konda  = lst_constant-low.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF ( vbak-auart IN lir_prc_grp_sub AND
    ENDIF. " IF <lst_xvbkd>-konda IS INITIAL

    IF  <lst_xvbkd>-konda IS INITIAL.
* End of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
      lst_xvbkd = <lst_xvbkd>.
      IF lst_xvbkd-kdgrp IN lr_kdgrp_v. " '01'.
        <lst_xvbkd>-konda = lv_konda_v. " '04'.  " Price grp

      ELSEIF lst_xvbkd-kdgrp IN lr_kdgrp. "  02/03/04/05
        <lst_xvbkd>-konda = lv_konda. " '03'.  " Price grp
      ENDIF. " IF lst_xvbkd-kdgrp IN lr_kdgrp_v
    ENDIF. " IF <lst_xvbkd>-konda IS INITIAL

* Begin of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
  ENDIF. " IF sy-subrc = 0
* End   of CHANGE:ERP-2613:LKODWANI:06-June-2017:ED2K905724
* Add partner function with ZA
* Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
  IF lv_pr_e106       IS NOT INITIAL.  "Business Partner 2 or Society number
* End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
* Begin of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
* IF tkomk-zzpartner2 IS NOT INITIAL . "Business Partner 2 or Society number
* End   of DL:CR#582:WROY:18-AUG-2017:ED2K908045
* This read is added to avoid duplicate entry in XVBPA table
    READ TABLE xvbpa INTO DATA(lst_xvbpa_o) WITH KEY posnr = vbap-posnr
                                                     parvw = lc_partner
                                                     TRANSPORTING NO FIELDS.
    IF sy-subrc NE 0.
      CALL FUNCTION 'V_KNA1_SINGLE_READ'
        EXPORTING
*         Begin of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
          pi_kunnr         = lv_pr_e106
*         End   of ADD:CR#582:WROY:18-AUG-2017:ED2K908045
*         Begin of DEL:CR#582:WROY:18-AUG-2017:ED2K908045
*         pi_kunnr         = tkomk-zzpartner2
*         End   of DL:CR#582:WROY:18-AUG-2017:ED2K908045
        IMPORTING
          pe_kna1          = lst_kna1
        EXCEPTIONS
          no_records_found = 1
          OTHERS           = 2.
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING lst_kna1 TO lst_xvbpa.
        CLEAR: lst_xvbpa-stceg,
               lst_xvbpa-lifnr,
               lst_xvbpa-pernr,
               lst_xvbpa-parnr.
        lst_xvbpa-parvw = lc_partner. " 'ZA'.
        lst_xvbpa-adrda = lc_adr_ind_d. " 'D'.
        lst_xvbpa-nrart = lc_p_type_ku. " 'KU'.
        lst_xvbpa-fehgr = lc_incmp_07. " '07'.
        lst_xvbpa-vbeln = vbap-vbeln.
        lst_xvbpa-posnr = vbap-posnr.
*       Begin of DEL:ERP-7055:WROY:15-Mar-2018:ED2K911406
*       The field was populated to differentiate the Manual entry with
*       the entry added through E106 logic. But this is causing Billing
*       Split issue and it was decided that ZA partner will never be
*       added manually / through Interface
**      Begin of ADD:ERP-5621:WROY:23-Jan-2018:ED2K910044
*       lst_xvbpa-knref = lc_objectid.
**      End   of ADD:ERP-5621:WROY:23-Jan-2018:ED2K910044
*       End   of DEL:ERP-7055:WROY:15-Mar-2018:ED2K911406
        lst_xvbpa-updkz = lc_indicator. " Insert
        APPEND lst_xvbpa TO xvbpa.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc NE 0

*   Begin of ADD:ERP-5167:WROY:14-Dec-2017:ED2K909897
*   Begin of ADD:ERP-6182:WROY:25-Jan-2018:ED2K910517
    IF vbkd-bsark IN lir_po_type_am AND
       vbak-vkbur IN lir_sls_offc_am.
*     Nothing to Do - Material Group 5 will come from Master Data
    ELSE.
*   End   of ADD:ERP-6182:WROY:25-Jan-2018:ED2K910517
      IF vbap-mvgr5 IN lr_mvgr5_soc.
        CLEAR: lst_kunnr_t.
        READ TABLE li_kunnr_t INTO lst_kunnr_t
             WITH KEY matnr = vbap-matnr
                      kunnr = lv_pr_e106
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          vbap-mvgr5 = lst_kunnr_t-sortl.
*         Begin of ADD:ERP-7046:WROY:15-Mar-2018:ED2K911374
          IF svbap-tabix IS NOT INITIAL.
            xvbap-mvgr5 = lst_kunnr_t-sortl.
            MODIFY xvbap INDEX svbap-tabix TRANSPORTING mvgr5.
          ENDIF.
*         Begin of ADD:ERP-7046:WROY:15-Mar-2018:ED2K911374
        ENDIF.
      ENDIF.
*   Begin of ADD:ERP-6182:WROY:25-Jan-2018:ED2K910517
    ENDIF.
*   End   of ADD:ERP-6182:WROY:25-Jan-2018:ED2K910517
  ELSE.
*   Begin of DEL:ERP-6178:WROY:31-Jan-2018:ED2K910630
**  Begin of ADD:ERP-6182:WROY:25-Jan-2018:ED2K910517
*   IF vbkd-bsark IN lir_po_type_am AND
*      vbak-vkbur IN lir_sls_offc_am.
**    Nothing to Do - Material Group 5 will come from Master Data
*   ELSE.
**  End   of ADD:ERP-6182:WROY:25-Jan-2018:ED2K910517
*     IF vbap-mvgr5 IN lr_mvgr5_soc.
*       CLEAR: vbap-mvgr5.
*     ENDIF.
**  Begin of ADD:ERP-6182:WROY:25-Jan-2018:ED2K910517
*   ENDIF.
**  End   of ADD:ERP-6182:WROY:25-Jan-2018:ED2K910517
**  End   of ADD:ERP-5167:WROY:14-Dec-2017:ED2K909897
*   End   of DEL:ERP-6178:WROY:31-Jan-2018:ED2K910630
*   Begin of ADD:ERP-5621:WROY:23-Jan-2018:ED2K910044
*   Delete ZA Partner, if already exists
    READ TABLE xvbpa INTO lst_xvbpa_o WITH KEY posnr = vbap-posnr
                                               parvw = lc_partner.
*   Begin of ADD:ERP-7055:WROY:15-Mar-2018:ED2K911406
    IF sy-subrc EQ 0.
*   End   of ADD:ERP-7055:WROY:15-Mar-2018:ED2K911406
*   Begin of DEL:ERP-7055:WROY:15-Mar-2018:ED2K911406
*   IF sy-subrc EQ 0 AND
*      lst_xvbpa_o-knref EQ lc_objectid.
*   End   of DEL:ERP-7055:WROY:15-Mar-2018:ED2K911406
      DATA(lv_vbpa_tabix) = sy-tabix.
      CASE lst_xvbpa_o-updkz.
        WHEN updkz_new.
          DELETE xvbpa INDEX lv_vbpa_tabix.
        WHEN updkz_update.
          lst_xvbpa_o-updkz = updkz_delete.
          MODIFY xvbpa FROM lst_xvbpa_o INDEX lv_vbpa_tabix TRANSPORTING updkz.
        WHEN updkz_old.
*         Begin of ADD:RITM0028165:SAYANDAS:25-May-2018:ED1K907497
          DELETE xvbpa INDEX lv_vbpa_tabix.
          lst_xvbpa_o-updkz = updkz_delete.
*         End   of ADD:RITM0028165:SAYANDAS:25-May-2018:ED1K907497
          APPEND lst_xvbpa_o TO yvbpa.
*         Begin of DEL:RITM0028165:SAYANDAS:25-May-2018:ED1K907497
*         lst_xvbpa_o-updkz = updkz_delete.
*         MODIFY xvbpa FROM lst_xvbpa_o INDEX lv_vbpa_tabix TRANSPORTING updkz.
*         End   of DEL:RITM0028165:SAYANDAS:25-May-2018:ED1K907497
        WHEN OTHERS.
*         Nothing to do
      ENDCASE.
    ENDIF.
*   End   of ADD:ERP-5621:WROY:23-Jan-2018:ED2K910044
*   Begin of ADD:ERP-6899:WROY:08-Mar-2018:ED2K911018
*   Check for Header Level Partner (ZA)
    CLEAR: lst_xvbpa_o.
    READ TABLE xvbpa INTO lst_xvbpa_o WITH KEY posnr = posnr_low
                                               parvw = lc_partner.
    IF sy-subrc EQ 0.
      IF vbkd-bsark IN lir_po_type_am AND
         vbak-vkbur IN lir_sls_offc_am.
*       Nothing to Do - Material Group 5 will come from Master Data
      ELSE.
        IF vbap-mvgr5 IN lr_mvgr5_soc.
          CLEAR: lst_kunnr_t.
          READ TABLE li_kunnr_t INTO lst_kunnr_t
               WITH KEY matnr = vbap-matnr
                        kunnr = lst_xvbpa_o-kunnr
               BINARY SEARCH.
          IF sy-subrc EQ 0.
            vbap-mvgr5 = lst_kunnr_t-sortl.
*           Begin of ADD:ERP-7046:WROY:15-Mar-2018:ED2K911374
            IF svbap-tabix IS NOT INITIAL.
              xvbap-mvgr5 = lst_kunnr_t-sortl.
              MODIFY xvbap INDEX svbap-tabix TRANSPORTING mvgr5.
            ENDIF.
*           Begin of ADD:ERP-7046:WROY:15-Mar-2018:ED2K911374
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
*   End   of ADD:ERP-6899:WROY:08-Mar-2018:ED2K911018
  ENDIF. " IF tkomk-zzpartner2 IS NOT INITIAL
*Begin of ADD:ERP-7752:HIPATEL:ED2K914086: 09-Apr-2019
  IF <lst_xvbkd> IS ASSIGNED.
*Order Type = ZCOP, PO Type = 0230 or 0104, Net Price  = 00 and
*Item Cat = ZFRE, needs to populate Price Group = "01" - Complimentary - C
    IF vbak-auart IN lir_prc_grp_cop AND
       vbak-bsark IN lir_bsark_am    AND
       vbap-pstyv IN lir_itm_cat_cop AND
       vbap-netwr IS INITIAL.
      CLEAR lst_constant.
      READ TABLE li_constant INTO lst_constant WITH KEY param1 = lc_price_grp
                                                        param2 = lc_konda.
      IF sy-subrc EQ 0.
        <lst_xvbkd>-konda  = lst_constant-low.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF.
  ENDIF.  "IF <lst_xvbkd> IS ASSIGNED.
*End of ADD:ERP-7752:HIPATEL:ED2K914086: 09-Apr-2019
* Begin of ADD:ERP-6582:WROY:22-Feb-2018:ED2K911018
  IF <lst_xvbkd> IS ASSIGNED.
    READ TABLE tkomk ASSIGNING <lst_tkomk>
         WITH KEY tkomk-key_uc.
    IF sy-subrc EQ 0.
      <lst_tkomk>-konda = <lst_xvbkd>-konda.  "Price group (customer)
    ENDIF.

    tkomk-konda = <lst_xvbkd>-konda.          "Price group (customer)
  ENDIF.
* End   of ADD:ERP-6582:WROY:22-Feb-2018:ED2K911018
*-----------------------------------------------------------------*
*--*Begin of add  ERPM-17190 & ERPM-4390 ED2K918427 6/9/2020
*--*Check enhancement is active
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e106
      im_ser_num     = lc_ser_num_5_e106
    IMPORTING
      ex_active_flag = lv_actv_flag_e106_off.
*--*Get Constants
  IF lv_actv_flag_e106_off EQ abap_true.
    IF li_constant[] IS INITIAL..
      CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
        EXPORTING
          im_devid     = lc_objectid
        IMPORTING
          ex_constants = li_constant.
    ENDIF.
*--*Build constants
    LOOP AT li_constant INTO DATA(lst_constant_off).
      CASE lst_constant_off-param1.
*--*Order type
        WHEN lc_order_type_off.
          CASE lst_constant_off-param2.
            WHEN lc_offline_single.
              APPEND INITIAL LINE TO lir_order_type_off ASSIGNING FIELD-SYMBOL(<lst_ordertype>).
              <lst_ordertype>-sign   = lst_constant_off-sign.
              <lst_ordertype>-option = lst_constant_off-opti.
              <lst_ordertype>-low    = lst_constant_off-low.
              <lst_ordertype>-high   = lst_constant_off-high.
            WHEN lc_single_issue.
              APPEND INITIAL LINE TO lir_order_type_single ASSIGNING FIELD-SYMBOL(<lst_single>).
              <lst_single>-sign   = lst_constant_off-sign.
              <lst_single>-option = lst_constant_off-opti.
              <lst_single>-low    = lst_constant_off-low.
              <lst_single>-high   = lst_constant_off-high.
            WHEN OTHERS.
          ENDCASE.
*--*Item category
        WHEN lc_item_cat_off.
          IF lst_constant_off-param2 = vbak-auart AND lst_constant_off-param2 IS NOT INITIAL.
            APPEND INITIAL LINE TO lir_itm_cat_off ASSIGNING FIELD-SYMBOL(<lst_itemcat>).
            <lst_itemcat>-sign   = lst_constant_off-sign.
            <lst_itemcat>-option = lst_constant_off-opti.
            <lst_itemcat>-low    = lst_constant_off-low.
            <lst_itemcat>-high   = lst_constant_off-high.
          ENDIF.
        WHEN lc_item_cat_single.
          IF lst_constant_off-param2 = vbak-auart AND lst_constant_off-param2 IS NOT INITIAL.
            APPEND INITIAL LINE TO lir_itm_cat_single ASSIGNING FIELD-SYMBOL(<lst_itemcat_single>).
            <lst_itemcat_single>-sign   = lst_constant_off-sign.
            <lst_itemcat_single>-option = lst_constant_off-opti.
            <lst_itemcat_single>-low    = lst_constant_off-low.
            <lst_itemcat_single>-high   = lst_constant_off-high.
          ENDIF.
*--*Price group
        WHEN lc_price_grp_off.
          CLEAR : lv_price_grp_ref.
          CONCATENATE vbak-auart vbap-pstyv INTO lv_price_grp_ref SEPARATED BY '-'.
          IF lst_constant_off-param2 = lv_price_grp_ref AND lst_constant_off-param2 IS NOT INITIAL.
            APPEND INITIAL LINE TO lir_prc_grp_off ASSIGNING FIELD-SYMBOL(<lst_prcgrp>).
            <lst_prcgrp>-sign   = lst_constant_off-sign.
            <lst_prcgrp>-option = lst_constant_off-opti.
            <lst_prcgrp>-low    = lst_constant_off-low.
            <lst_prcgrp>-high   = lst_constant_off-high.
          ENDIF.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
*-------------------------------------------------------------------------*
*--*ERPM-4390 off line single issue Implementation - goes inside for VA01/02
*-------------------------------------------------------------------------*
*--*Check Constnat table entries
    IF vbak-auart IN lir_order_type_off AND vbap-pstyv IN lir_itm_cat_off.
*--*Get Media Product
      CLEAR: lv_media_prod.
      SELECT SINGLE ismrefmdprod FROM mara INTO lv_media_prod WHERE matnr = vbap-matnr.
      IF sy-subrc EQ 0.
*--*Read KNMT record
        READ TABLE li_kunnr_t INTO DATA(lst_knmt_off) WITH KEY vkorg = vbak-vkorg
                                                               vtweg = vbak-vtweg
                                                               kunnr = vbak-kunnr
                                                               matnr = lv_media_prod.
        IF sy-subrc EQ 0.
*--*Update material group 5 to XVBAP
          READ TABLE xvbap INTO DATA(lst_xvbap_off)
                                 WITH KEY posnr = vbap-posnr.
          IF sy-subrc = 0.
            lst_xvbap_off-mvgr5 = lst_knmt_off-sortl.
            MODIFY xvbap FROM lst_xvbap_off INDEX sy-tabix TRANSPORTING mvgr5.
            vbap-mvgr5 = lst_knmt_off-sortl.
          ENDIF.
*--*Get Price group from constant table entry
          READ TABLE lir_prc_grp_off INTO DATA(lst_price_grp_off) INDEX 1.
          IF sy-subrc EQ 0.
*--*Update Price group
            READ TABLE xvbkd INTO DATA(lst_xvbkd_off)
                                   WITH KEY posnr = vbap-posnr.
            IF sy-subrc = 0.
              lst_xvbkd_off-konda  = lst_price_grp_off-low.
              MODIFY xvbkd FROM lst_xvbkd_off INDEX sy-tabix TRANSPORTING konda.
              vbkd-konda = lst_price_grp_off-low.
            ENDIF. " IF sy-subrc = 0. Read tabl XVBKD
          ENDIF. "IF sy-subrc EQ 0. Read table lir_prc_grp_off

        ENDIF. " IF sy-subrc EQ 0. Read table li_kunnr_t
      ENDIF.
    ENDIF.
*-------------------------------------------------------------------------*
*--* ERPM-17190 Single quote Issue Implementation - Goes inside for VA21/22
*--------------------------------------------------------------------------*
    IF vbak-auart IN lir_order_type_single AND vbap-pstyv IN lir_itm_cat_single.
*--*Get Media Product
      CLEAR: lv_media_prod.
      SELECT SINGLE ismrefmdprod FROM mara INTO lv_media_prod WHERE matnr = vbap-matnr.
      IF sy-subrc EQ 0.
        CLEAR : lv_mvgr5.
        SELECT SINGLE mvgr5 FROM mvke INTO lv_mvgr5 WHERE matnr = lv_media_prod
                                               AND vkorg = vbak-vkorg
                                               AND vtweg = vbak-vtweg .
        IF sy-subrc EQ 0.
          READ TABLE xvbap INTO DATA(lst_xvbap_single)
                                 WITH KEY posnr = vbap-posnr.
          IF sy-subrc = 0.
            lst_xvbap_single-mvgr5 = lv_mvgr5.
            MODIFY xvbap FROM lst_xvbap_single INDEX sy-tabix TRANSPORTING mvgr5.
            vbap-mvgr5 = lv_mvgr5.
          ENDIF. " IF sy-subrc = 0.READ TABLE xvbap
        ENDIF." IF sy-subrc EQ 0.SELECT SINGLE mvgr5
      ENDIF." IF sy-subrc EQ 0. select sing Mara
    ENDIF."IF vbak-auart IN lir_order_type_off AND vbap-pstyv IN lir_itm_cat_off.
  ENDIF."IF lv_actv_flag_e106_off EQ abap_true.
**--*End of add  ERPM-17190 & ERPM-4390 ED2K918427 6/9/2020
ENDIF. " IF lv_flag = abap_true
