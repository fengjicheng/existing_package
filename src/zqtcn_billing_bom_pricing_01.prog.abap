*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BILLING_BOM_PRICING_01 (Include)
*               Called from "Routine 902 (RV64A902)"
* PROGRAM DESCRIPTION: Calculate Condition Value for BOM Components
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* CREATION DATE: 19-DEC-2018
* OBJECT ID: E075
* TRANSPORT NUMBER(S): ED2K913994
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K915756
* REFERENCE NO:  ERP7626
* DEVELOPER:     Nageswar (NPOLINA)
* DATE:          07/24/2019
* DESCRIPTION:   ZMPR pricing issue from VF04 Collective process
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED2K917170
* REFERENCE NO:  ERP7626/ERPM-9191
* DEVELOPER:     Nageswar (NPOLINA)
* DATE:          12/31/2019
* DESCRIPTION:   BOM Heaer pricing split issue  with last BOM Component
*----------------------------------------------------------------------*

TYPES:
  BEGIN OF lty_pltyp,
    pltyp    TYPE pltyp,                                        " Price List Type
    matnr    TYPE matnr,                                        " Material Number
    inst_prc TYPE kbetr_kond,                                   " Rate (condition amount or percentage) where no scale exists
  END OF lty_pltyp,
  ltt_pltyp TYPE STANDARD TABLE OF lty_pltyp INITIAL SIZE 0,

  BEGIN OF lty_mat_det,
    matnr    TYPE matnr,                                        " Material Number
    publtype TYPE ismpubltype,                                  " Publication Type
  END OF lty_mat_det,
  ltt_mat_det TYPE STANDARD TABLE OF lty_mat_det INITIAL SIZE 0,

  BEGIN OF lty_price_det,
    vbeln    TYPE vbeln,                                        " Document number  ADD:CR7816  KKRAVURI20181211
    hl_items TYPE uepos,                                        " Higher-level item in bill of material structures
    itm_prc  TYPE kbetr,                                        " Total Item Price
    prc_eli  TYPE kzwi3,                                        " Price Excluding Last BOM Item
    last_bi  TYPE posnr_va,                                     " Last BOM Item
    no_comp  TYPE i,                                            " Number of BOM Components
    no_prc   TYPE flag,                                         " Flag: No Price Maintained
    last_cmp TYPE sdstpox,                                      " Last BOM Component
    bom_h_pr TYPE kzwi3,                                        " BOM Header Price
  END OF lty_price_det,
  ltt_bom_items TYPE STANDARD TABLE OF sdstpox INITIAL SIZE 0.

DATA:
  lv_prc_type  TYPE salv_de_selopt_low,                         " Pricing Type
  lv_xvbrp_f   TYPE char40 VALUE '(SAPMV60A)XVBRP[]',           " Billing Document: Item Data
  lv_xvbrp     TYPE char40 VALUE '(SAPMV60A)XVBRP',
  lv_xkomv_f_b TYPE char40 VALUE '(SAPMV60A)XKOMV[]'.           " Pricing Communications-Condition Record
* SOC by NPOLINA 24/July/2019 ED2K915756
DATA:
  lv_xvbrp_vf4  TYPE char40 VALUE '(SAPLV60A)XVBRP[]',           " Billing Document: Item Data
  lv_xvbrp_vf04 TYPE char40 VALUE '(SAPLV60A)XVBRP',
  lv_xkomv_vf04 TYPE char40 VALUE '(SAPLV60A)XKOMV[]'.           " Pricing Communications-Condition Record
* EOC by NPOLINA 24/July/2019 ED2K915756
DATA:
  li_constant    TYPE zcat_constants,                            " Internal table for Constant Table
  lir_dc_invoic  TYPE saco_vbtyp_ranges_tab,                     " SD document category
  lir_pb_type    TYPE rjksd_publtype_range_tab,                  " Range Table for Publication Type
  lir_itm_cat    TYPE rjksd_pstyv_range_tab,                     " Range Table for Item Category
  li_pric_sel    TYPE ltt_pltyp,                                 " Institutional Price
  li_mat_sele    TYPE ltt_mat_det,                               " Material Details
*  li_bom_itm    TYPE ltt_bom_items,
  li_komp        TYPE  va_komp_t,                                " Communication Item for Pricing
*  li_xvbap_f    TYPE va_vbapvb_t,                                " Sales Document: Item Data
*  li_xvbap_b    TYPE va_vbapvb_t,                                " Sales Document: Item Data (BOM)
  li_komv_f      TYPE va_komv_t,                                 " Pricing Communications-Condition Record
  li_vbrp_f      TYPE vbrpvb_t,                                  " Billing Item Data
  li_vbrp_b      TYPE vbrpvb_t,                                  " Billing Item Data (BOM)
  lst_vbrp       TYPE vbrpvb,
  li_bom_item    TYPE STANDARD TABLE OF stpox INITIAL SIZE 0,    " BOM Items (Extended for List Displays)
  lst_cstmat     TYPE cstmat,                                    " Start Material Display for BOM Explosions
  lv_matnr       TYPE matnr,
  lv_plant       TYPE werks_d,
  lst_price_det  TYPE lty_price_det,
  lst_stpo       TYPE rmxms_stpo_tkey,                           " Technical Key Fields - BOM Item
  lst_stpo_det   TYPE stpo,                                      " BOM Item
  lv_itm_pric    TYPE kbetr,                                     " Total Item Price
  lv_cnd_type    TYPE kschl,                                     " Condition Type
  lv_cust_grp    TYPE kdgrp,                                     " Customer Group
  lv_no_pric     TYPE flag,                                      " Flag: No Price Maintained
  lv_last_bomitm TYPE posnr_va,                                  " Last BOM Item
  lv_no_comps    TYPE i,                                         " Number of BOM Components
  lv_pric_eli    TYPE kzwi3,                                     " Price Excluding Last BOM Item
  lv_pric_prv    TYPE kzwi3,                                     " Price of the Previous Item
  lv_bom_hpri    TYPE kzwi3,                                     " BOM Header Price
  lv_zalloc      TYPE rai_percentage_kk,                         " Percentage Allocation
  lv_last_cmp    TYPE flag,                                      " Indicator: Last BOM Component
  lv_last_idx    TYPE i,                                         " Index of last Line
  lv_alloc_rat   TYPE p DECIMALS 6,                              " Allocated Ratio
  lv_quantity    TYPE basmn,
* SOC by NPOLINA 24/July/2019 ED2K915756
  lv_individual  TYPE sy-tcode,
  lv_collective  TYPE sy-tcode.
* EOC by NPOLINA 24/July/2019 ED2K915756

STATICS:
  li_pltyp      TYPE ltt_pltyp,                                     " Institutional Price
  li_mat_detail TYPE ltt_mat_det,                                   " Material Details
  i_prices      TYPE STANDARD TABLE OF lty_price_det INITIAL SIZE 0,
  i_vbap        TYPE STANDARD TABLE OF vbap INITIAL SIZE 0,
  v_vgbel       TYPE vbeln,
  v_slsorg      TYPE vkorg,
  v_distchnl    TYPE vtweg,
  lv_cum_pri_bom TYPE kzwi3.     " NPOLINA  ED2K917170

CONSTANTS:
  lc_param_bom  TYPE rvari_vnam  VALUE 'BOM_ITEMS',                " ABAP: Name of Variant Variable
  lc_param_cond TYPE rvari_vnam  VALUE 'COND_TYPE',                " ABAP: Name of Variant Variable
  lc_param_doc  TYPE rvari_vnam  VALUE 'DOC_CATEGORY',             " ABAP: Name of Variant Variable
  lc_param_typ  TYPE rvari_vnam  VALUE 'PUBLICATION_TYPE',         " ABAP: Name of Variant Variable
  lc_param_inv  TYPE rvari_vnam  VALUE 'INVOICE',                  " ABAP: Name of Variant Variable
  lc_param_pric TYPE rvari_vnam  VALUE 'PRICING_TYPE',             " ABAP: Name of Variant Variable
  lc_param_hdr  TYPE rvari_vnam  VALUE 'DB_BOM_HDR_ITM_CAT',       " ABAP: Name of Variant Variable
  lc_param_grp  TYPE rvari_vnam  VALUE 'CUST_GROUP',               " ABAP: Name of Variant Variable
  lc_del_indi   TYPE updkz       VALUE 'D',                        " Update Indicator: Delete
  lc_dev_id     TYPE zdevid      VALUE 'E075'.                     " Development ID

* SOC by NPOLINA 24/July/2019 ED2K915756
CONSTANTS:
  lc_param_ind  TYPE rvari_vnam  VALUE 'INDIVIDUAL',
  lc_param_coll TYPE rvari_vnam  VALUE 'COLLECTIVE'.
* EOC by NPOLINA 24/July/2019 ED2K915756

* Get constant table data
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_dev_id
  IMPORTING
    ex_constants = li_constant.
IF li_constant[] IS NOT INITIAL.
  LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
      WHEN lc_param_bom.                                           " ABAP: Name of Variant Variable (BOM_ITEMS)
        CASE <lst_constant>-param2.
          WHEN lc_param_cond.                                      " Condition Type: List Price (COND_TYPE)
            lv_cnd_type = <lst_constant>-low.

          WHEN lc_param_hdr.                                       " Item Category: Database BOM
            APPEND INITIAL LINE TO lir_itm_cat ASSIGNING FIELD-SYMBOL(<lst_itm_cat>).
            <lst_itm_cat>-sign   = <lst_constant>-sign.
            <lst_itm_cat>-option = <lst_constant>-opti.
            <lst_itm_cat>-low    = <lst_constant>-low.
            <lst_itm_cat>-high   = <lst_constant>-high.

          WHEN lc_param_grp.                                        " Customer Group (CUST_GROUP)
            lv_cust_grp = <lst_constant>-low.

          WHEN lc_param_typ.                                        " Publication Type (PUBLICATION_TYPE)
            APPEND INITIAL LINE TO lir_pb_type ASSIGNING FIELD-SYMBOL(<lst_pb_type>).
            <lst_pb_type>-sign   = <lst_constant>-sign.
            <lst_pb_type>-option = <lst_constant>-opti.
            <lst_pb_type>-low    = <lst_constant>-low.
            <lst_pb_type>-high   = <lst_constant>-high.
          WHEN OTHERS.
*           Nothing to do
        ENDCASE.

      WHEN lc_param_doc.                                          " SD document category (DOC_CATEGORY)
        CASE <lst_constant>-param2.
          WHEN lc_param_inv.                                      " Invoice (INVOICE)
            APPEND INITIAL LINE TO lir_dc_invoic ASSIGNING FIELD-SYMBOL(<lst_dc_invoic>).
            <lst_dc_invoic>-sign   = <lst_constant>-sign.
            <lst_dc_invoic>-option = <lst_constant>-opti.
            <lst_dc_invoic>-low    = <lst_constant>-low.
            <lst_dc_invoic>-high   = <lst_constant>-high.

          WHEN OTHERS.
*           Nothing to do
        ENDCASE.

      WHEN lc_param_pric.                                          " Pricing Type (PRICING_TYPE)
        lv_prc_type = <lst_constant>-low.

* SOC by NPOLINA 24/July/2019 ED2K915756
          WHEN lc_param_coll.
            lv_collective = <lst_constant>-low.
* EOC by NPOLINA 24/July/2019 ED2K915756

      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF. " IF sy-subrc IS INITIAL


* For Billing Document, Copy the price from old / reference value
IF preisfindungsart NA lv_prc_type.
  IF xkwert IS INITIAL.
    xkwert = ywert.
  ENDIF.
  RETURN.
ENDIF.

IF sy-tcode NE lv_collective. "NPOLINA 24/July/2019 ED2K915756
* Billing Document: Item Data (Structure)
  ASSIGN (lv_xvbrp) TO FIELD-SYMBOL(<ls_xvbrp>).
  IF sy-subrc = 0.
    lst_vbrp = <ls_xvbrp>.
  ENDIF.

* SOC by NPOLINA 24/July/2019 ED2K915756
* If triggers from VF04 Collective Processing
ELSE.
* Billing Document: Item Data (Structure)
  ASSIGN (lv_xvbrp_vf04) TO FIELD-SYMBOL(<ls_xvbrp_col>).
  IF sy-subrc = 0.
    lst_vbrp = <ls_xvbrp_col>.
  ENDIF.
ENDIF.
* EOC by NPOLINA 24/July/2019 ED2K915756

IF sy-tcode NE lv_collective. "NPOLINA 24/July/2019 ED2K915756
* Billing Document: Item Data (Table)
  ASSIGN (lv_xvbrp_f) TO FIELD-SYMBOL(<li_xvbrp>).
  IF sy-subrc EQ 0.
    li_vbrp_f = <li_xvbrp>.
    DELETE li_vbrp_f WHERE updkz EQ lc_del_indi.
    SORT li_vbrp_f BY vbeln posnr.
    READ TABLE li_vbrp_f INTO DATA(lis_xvbrp) INDEX 1.
    IF sy-subrc = 0.
      IF i_vbap[] IS INITIAL.
        v_vgbel = lis_xvbrp-vgbel.
        SELECT * FROM vbap INTO TABLE i_vbap WHERE vbeln = lis_xvbrp-vgbel.
        SORT i_vbap BY posnr matnr.
      ENDIF.
    ENDIF.
  ENDIF.
* SOC by NPOLINA 24/July/2019 ED2K915756
ELSE.
* Billing Document: Item Data (Table)
  ASSIGN (lv_xvbrp_vf4) TO FIELD-SYMBOL(<li_xvbrp_vf4>).
  IF sy-subrc EQ 0.
    li_vbrp_f = <li_xvbrp_vf4>.
    DELETE li_vbrp_f WHERE updkz EQ lc_del_indi.
    SORT li_vbrp_f BY vbeln posnr.
    READ TABLE li_vbrp_f INTO DATA(lis_xvbrp_vf4) INDEX 1.
    IF sy-subrc = 0.
      IF i_vbap[] IS INITIAL.
        v_vgbel = lis_xvbrp_vf4-vgbel.
        SELECT * FROM vbap INTO TABLE i_vbap WHERE vbeln = lis_xvbrp_vf4-vgbel.
        SORT i_vbap BY posnr matnr.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
* EOC by NPOLINA 24/July/2019 ED2K915756
* Pricing Communications-Condition Record
IF sy-tcode NE lv_collective. "NPOLINA 24/July/2019 ED2K915756
  ASSIGN (lv_xkomv_f_b) TO FIELD-SYMBOL(<li_xkomv_b>).
  IF sy-subrc EQ 0.
    li_komv_f = <li_xkomv_b>.
  ENDIF.
* SOC by NPOLINA 24/July/2019 ED2K915756
ELSE.
  ASSIGN (lv_xkomv_vf04) TO FIELD-SYMBOL(<li_xkomv_coll>).
  IF sy-subrc EQ 0.
    li_komv_f = <li_xkomv_coll>.
  ENDIF.
ENDIF.
* EOC by NPOLINA 24/July/2019 ED2K915756
IF li_vbrp_f IS NOT INITIAL AND                                " Sales Document: Item Data
   li_komv_f IS NOT INITIAL.                                   " Pricing Communications-Condition Record
* Get Sales Document: Item Data details
  READ TABLE li_vbrp_f ASSIGNING FIELD-SYMBOL(<lst_xvbrp_l>)
       WITH KEY vbeln = sdprothead-vbeln posnr = xkomv-kposn
       BINARY SEARCH.
  IF sy-subrc <> 0.
    READ TABLE li_vbrp_f ASSIGNING <lst_xvbrp_l>
         WITH KEY vbeln = lst_vbrp-vbeln posnr = lst_vbrp-uepos
         BINARY SEARCH.
    IF sy-subrc = 0.
      IF <lst_xvbrp_l> IS ASSIGNED.
        UNASSIGN <lst_xvbrp_l>.
      ENDIF.
      ASSIGN lst_vbrp TO <lst_xvbrp_l>.
    ENDIF.
  ENDIF.
  IF sy-subrc = 0 AND
     <lst_xvbrp_l>-uepos IS NOT INITIAL. " Check for BOM Line Item (Component)

    READ TABLE i_vbap ASSIGNING FIELD-SYMBOL(<lst_xvbap_l1>) WITH KEY
                      posnr = <lst_xvbrp_l>-posnr matnr = <lst_xvbrp_l>-matnr
                      BINARY SEARCH.
    IF sy-subrc = 0.
      lv_quantity = <lst_xvbap_l1>-zmeng.
    ENDIF.

    READ TABLE li_vbrp_f ASSIGNING FIELD-SYMBOL(<lst_xvbrp_l1>)
         WITH KEY vbeln = <lst_xvbrp_l>-vbeln posnr = <lst_xvbrp_l>-uepos
         BINARY SEARCH.
    IF sy-subrc = 0.
      lv_matnr = <lst_xvbrp_l1>-matnr.
      lv_plant = <lst_xvbrp_l1>-werks.
    ENDIF.

*   Retrieve Global Attributes during Complete Pricing
*   [The Internal Table TKOMP will be populated from Fumc Module PRICING_COMPLETE]
    CALL FUNCTION 'ZQTC_PRICING_COMPLETE_GET'
      EXPORTING
        im_refresh = abap_true                                  "Refresh / Clear Global Attributes
      IMPORTING
        ex_tkomp   = li_komp.                                  "Communication Item for Pricing
*   Determine BOM Header Price
    CLEAR: lv_bom_hpri.
    IF li_komp IS NOT INITIAL.
      READ TABLE li_komp ASSIGNING FIELD-SYMBOL(<lst_tkomp_h1>)
           WITH KEY kposn = <lst_xvbrp_l>-uepos.
      IF sy-subrc EQ 0.
        lv_bom_hpri = <lst_tkomp_h1>-kzwi3.
      ENDIF.
    ELSE.
      READ TABLE li_vbrp_f ASSIGNING FIELD-SYMBOL(<lst_xvbrp_h>)
           WITH KEY vbeln = <lst_xvbrp_l>-vbeln posnr = <lst_xvbrp_l>-uepos
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lv_bom_hpri = <lst_xvbrp_h>-kzwi3.
      ENDIF.
    ENDIF.
*   Begin of ADD:Performance
    IF lst_price_det-hl_items IS INITIAL.
      lst_price_det-vbeln = <lst_xvbrp_l>-vbeln.
      lst_price_det-hl_items = <lst_xvbrp_l>-uepos.
      lst_price_det-bom_h_pr = lv_bom_hpri.

    ELSEIF lst_price_det-hl_items NE <lst_xvbrp_l>-uepos.
      CLEAR: lst_price_det.
      lst_price_det-vbeln = <lst_xvbrp_l>-vbeln.
      lst_price_det-hl_items = <lst_xvbrp_l>-uepos.
      lst_price_det-bom_h_pr = lv_bom_hpri.

    ELSEIF lst_price_det-bom_h_pr NE lv_bom_hpri.
      CLEAR: lst_price_det.
      lst_price_det-vbeln = <lst_xvbrp_l>-vbeln.
      lst_price_det-hl_items = <lst_xvbrp_l>-uepos.
      lst_price_det-bom_h_pr = lv_bom_hpri.
    ENDIF.

    IF lv_plant IS INITIAL.
* Fetch Sales Org., Distribution Channel
      IF v_slsorg IS INITIAL AND v_distchnl IS INITIAL.
        SELECT SINGLE vkorg vtweg FROM vbak INTO ( v_slsorg, v_distchnl )
                                  WHERE vbeln = v_vgbel.
      ENDIF.
* Fetch Plant from table: MVKE (Sales Data for Material)
      SELECT SINGLE dwerk FROM mvke INTO lv_plant
                          WHERE matnr = lv_matnr AND
                                vkorg = v_slsorg AND
                                vtweg = v_distchnl.
    ENDIF.
* Fetch BOM Component Details
    CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
      EXPORTING
        capid                 = 'SD01'        " Application ID
        datuv                 = sy-datum      " Date
        emeng                 = lv_quantity   " Quantity
        salww                 = abap_true
        mtnrv                 = lv_matnr      " Material
        rndkz                 = '2'           " Round off: ' '=always, '1'=never, '2'=only levels > 1
        werks                 = lv_plant      " Plant
      IMPORTING
        topmat                = lst_cstmat
      TABLES
        stb                   = li_bom_item
      EXCEPTIONS
        alt_not_found         = 1
        call_invalid          = 2
        material_not_found    = 3
        missing_authorization = 4
        no_bom_found          = 5
        no_plant_data         = 6
        no_suitable_bom_found = 7
        conversion_error      = 8
        OTHERS                = 9.
    IF sy-subrc EQ 0.
*     Identify the details of last BOM Component
      lv_last_idx = lines( li_bom_item ).
      READ TABLE li_bom_item INTO DATA(list_last_bom_cmp) INDEX lv_last_idx.
      IF sy-subrc EQ 0.
        IF list_last_bom_cmp-stlty EQ <lst_xvbap_l1>-stlty AND    "BOM category
           list_last_bom_cmp-stlnr EQ <lst_xvbap_l1>-stlnr AND    "Bill of material
           list_last_bom_cmp-stlkn EQ <lst_xvbap_l1>-stlkn AND    "BOM item node number
           list_last_bom_cmp-stpoz EQ <lst_xvbap_l1>-stpoz.       "Internal counter
*         Determine the Last BOM Item: In order to avoid the Rounding issue,
*         the Amount of the very last BOM Item has to be adjusted
          lv_last_cmp = abap_true.
        ENDIF.
      ENDIF.
    ENDIF.
*   End   of ADD:Performance

*   Get the details of the BOM Header
    READ TABLE li_vbrp_f ASSIGNING <lst_xvbrp_h>
         WITH KEY vbeln = <lst_xvbrp_l>-vbeln posnr = <lst_xvbrp_l>-uepos
         BINARY SEARCH.
    IF sy-subrc EQ 0 AND
       <lst_xvbrp_h>-pstyv IN lir_itm_cat.                       " Sales Document Item Category
*     Begin of ADD:Performance
      READ TABLE li_bom_item ASSIGNING FIELD-SYMBOL(<lst_bom_itm1>)
           WITH KEY stlty = <lst_xvbap_l1>-stlty                 " BOM category
                    stlnr = <lst_xvbap_l1>-stlnr                 " Bill of material
                    stlkn = <lst_xvbap_l1>-stlkn                 " BOM item node number
                    stpoz = <lst_xvbap_l1>-stpoz.                " Internal counter
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING <lst_bom_itm1> TO lst_stpo_det.
      ELSE.
*     End   of ADD:Performance
        MOVE-CORRESPONDING <lst_xvbap_l1> TO lst_stpo.           " Technical Key Fields - BOM Item
*       Fetch BOM Item Details
        CALL FUNCTION 'ZQTC_STPO_SINGLE_READ'
          EXPORTING
            im_st_stpo_key    = lst_stpo                         " Technical Key Fields - BOM Item
          IMPORTING
            ex_st_stpo_det    = lst_stpo_det                     " BOM Item Details
*           Begin of ADD:Performance
            ex_last_bom_comp  = lv_last_cmp                      " Indicator: Last BOM Component
*           End   of ADD:Performance
          EXCEPTIONS
            exc_invalid_input = 1
            OTHERS            = 2.
        IF sy-subrc EQ 0.
*     Begin of ADD:Performance
*         Nothing to do
        ENDIF.
      ENDIF.
      IF lst_stpo_det IS NOT INITIAL.
        IF lv_last_cmp IS INITIAL.                               " Indicator: Last BOM Component
*     End   of ADD:Performance
          TRY.
              lv_zalloc = lst_stpo_det-zzalloc.                  " Percentage Allocation
            CATCH cx_root.
              CLEAR: lv_zalloc.
          ENDTRY.
*         Calculate Allocated Amount
          CALL FUNCTION 'ZQTC_ARITHMETIC_OPERATIONS'
            EXPORTING
              im_v_operand1  = lst_price_det-bom_h_pr            " BOM Header Price
              im_v_operand2  = lv_zalloc                         " Percentage Allocation
              im_v_operation = c_opr_prc                         " Operand: Percentage
            IMPORTING
              ex_v_result    = xkwert.                           " Current Line Item Value
*       Begin of ADD:Performance
          lst_price_det-prc_eli = lst_price_det-prc_eli + xkwert.     " Price Excluding Last BOM Item
          lv_cum_pri_bom = lv_cum_pri_bom + xkwert.      " NPOLINA  ED2K917170 ERPM-9191
          APPEND lst_price_det TO i_prices.
          CLEAR lst_price_det.
        ELSE.
          READ TABLE i_prices INTO lst_price_det WITH KEY
                              vbeln = <lst_xvbrp_l>-vbeln hl_items = <lst_xvbrp_l>-uepos.
          IF sy-subrc = 0.
            lv_pric_eli = lst_price_det-prc_eli.                      " Total Price Excluding Last Item
*           Current Line Item Value = BOM Header Price - Total Price Excluding Last Item
            IF lv_cum_pri_bom IS NOT INITIAL.  " NPOLINA  ED2K917170 ERPM-9191
              lv_pric_eli = lv_cum_pri_bom.    " NPOLINA  ED2K917170 ERPM-9191
              CLEAR lv_cum_pri_bom.            " NPOLINA  ED2K917170 ERPM-9191
            ENDIF.                             " NPOLINA  ED2K917170 ERPM-9191
            xkwert = lst_price_det-bom_h_pr - lv_pric_eli.            " Current Line Item Value
          ENDIF.
          CLEAR lst_price_det.
        ENDIF.
*       End   of ADD:Performance
      ENDIF.
      RETURN.
    ENDIF.

*   Get the Price of the BOM Component
    IF li_vbrp_f[] IS NOT INITIAL.
      IF lst_price_det-itm_prc IS INITIAL.                         " Total Item Price
        IF li_bom_item[] IS INITIAL.
*         Identify the BOM Line Items (Components) using Higher-level item in BOM structure
          li_vbrp_b[] = li_vbrp_f[].
          DELETE li_vbrp_b WHERE uepos NE <lst_xvbrp_l>-uepos.

          LOOP AT li_vbrp_b ASSIGNING FIELD-SYMBOL(<lst_xvbrp_s>).
            READ TABLE li_pltyp TRANSPORTING NO FIELDS
                 WITH KEY pltyp = komk-pltyp
                          matnr = <lst_xvbrp_s>-matnr
                 BINARY SEARCH.
            IF sy-subrc NE 0.
              APPEND INITIAL LINE TO li_pric_sel ASSIGNING FIELD-SYMBOL(<lst_prc_sel1>).
              <lst_prc_sel1>-pltyp = komk-pltyp.
              <lst_prc_sel1>-matnr = <lst_xvbrp_s>-matnr.
            ENDIF.

            READ TABLE li_mat_detail TRANSPORTING NO FIELDS
                 WITH KEY matnr = <lst_xvbrp_s>-matnr
                 BINARY SEARCH.
            IF sy-subrc NE 0.
              APPEND INITIAL LINE TO li_mat_sele ASSIGNING FIELD-SYMBOL(<lst_mat_sel1>).
              <lst_mat_sel1>-matnr = <lst_xvbrp_s>-matnr.
            ENDIF.
          ENDLOOP.
*     Begin of ADD:Performance
        ELSE.
          LOOP AT li_bom_item ASSIGNING <lst_bom_itm1>.
            READ TABLE li_pltyp TRANSPORTING NO FIELDS
                 WITH KEY pltyp = komk-pltyp
                          matnr = <lst_bom_itm1>-idnrk
                 BINARY SEARCH.
            IF sy-subrc NE 0.
              APPEND INITIAL LINE TO li_pric_sel ASSIGNING <lst_prc_sel1>.
              <lst_prc_sel1>-pltyp = komk-pltyp.
              <lst_prc_sel1>-matnr = <lst_bom_itm1>-idnrk.
            ENDIF.

            READ TABLE li_mat_detail TRANSPORTING NO FIELDS
                 WITH KEY matnr = <lst_bom_itm1>-idnrk
                 BINARY SEARCH.
            IF sy-subrc NE 0.
              APPEND INITIAL LINE TO li_mat_sele ASSIGNING <lst_mat_sel1>.
              <lst_mat_sel1>-matnr = <lst_bom_itm1>-idnrk.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
*     End   of ADD:Performance

      IF li_pric_sel IS NOT INITIAL.
        SELECT a~pltyp                                          " Price List Type
               a~matnr                                          " Material Number
               k~kbetr                                          " Rate (condition amount or percentage) where no scale exists
          FROM a913 AS a INNER JOIN
               konp AS k
            ON a~knumh EQ k~knumh
     APPENDING TABLE li_pltyp
           FOR ALL ENTRIES IN li_pric_sel
         WHERE a~kappl EQ kappl_vertrieb
           AND a~kschl EQ lv_cnd_type
           AND a~pltyp EQ li_pric_sel-pltyp
           AND a~kdgrp EQ lv_cust_grp
           AND a~matnr EQ li_pric_sel-matnr
           AND a~kfrst EQ space
           AND a~datbi GE komk-prsdt
           AND a~datab LE komk-prsdt.
        IF sy-subrc EQ 0.
          SORT li_pltyp BY pltyp matnr.
        ENDIF.
      ENDIF.

      IF li_mat_sele IS NOT INITIAL.
        SELECT matnr                                            " Material Number
               ismpubltype                                      " Publication Type
          FROM mara
     APPENDING TABLE li_mat_detail
           FOR ALL ENTRIES IN li_mat_sele
         WHERE matnr EQ li_mat_sele-matnr.
        IF sy-subrc EQ 0.
          SORT li_mat_detail BY matnr.
        ENDIF.
      ENDIF.

      CLEAR: lv_itm_pric, lv_no_pric, lv_last_bomitm, lv_pric_eli, lv_pric_prv.
*     Go through all BOM Line Items (Components)
*     Begin of ADD:Performance
      IF lst_price_det-itm_prc IS INITIAL.                         " Total Item Price
        IF li_bom_item[] IS INITIAL.
*     End   of ADD:Performance
          LOOP AT li_vbrp_b ASSIGNING FIELD-SYMBOL(<lst_xvbrp_b>).
*           Exclude Publication Types: Opt-In (OI), Controlled Circulation (CC)
            READ TABLE li_mat_detail ASSIGNING FIELD-SYMBOL(<lst_mat_det1>)
                 WITH KEY matnr = <lst_xvbrp_b>-matnr
                 BINARY SEARCH.
            IF sy-subrc EQ 0 AND
               <lst_mat_det1>-publtype NOT IN lir_pb_type.
              CONTINUE.
            ENDIF.

*           In case of missing Price, the BOM Header Price has to be pro-rated
*           equally
            lv_no_comps = lv_no_comps + 1.                        " Number of BOM Components
*           Determine the Last BOM Item: In order to avoid the Rounding issue,
*           the Amount of the very last BOM Item has to be adjusted
            lv_last_bomitm = <lst_xvbrp_b>-posnr.                   " Last BOM Item
            lv_pric_eli = lv_pric_eli + lv_pric_prv.                " Total Price Excluding Last Item
            lv_pric_prv = <lst_xvbrp_b>-kzwi3.                      " Previous Item Price

*           Identify Condition Type value of the BOM Line Item (Component)
            READ TABLE li_pltyp ASSIGNING FIELD-SYMBOL(<lst_inst_p1>)
                 WITH KEY pltyp = komk-pltyp
                          matnr = <lst_xvbrp_b>-matnr
                 BINARY SEARCH.
            IF sy-subrc EQ 0 AND
               <lst_inst_p1>-inst_prc IS NOT INITIAL.
*             Sum up Condition Type values of all the BOM Line Items (Components)
              lv_itm_pric = lv_itm_pric + <lst_inst_p1>-inst_prc.
            ELSE.
*             In case of missing Price, the BOM Header Price has to be
*             pro-rated equally
              lv_no_pric  = abap_true.                           " Flag: No Price Maintained
            ENDIF.
          ENDLOOP.
*     Begin of ADD:Performance
          lst_price_det-last_bi = lv_last_bomitm.
        ELSE.
          LOOP AT li_bom_item ASSIGNING <lst_bom_itm1>.
*           Exclude Publication Types: Opt-In (OI), Controlled Circulation (CC)
            READ TABLE li_mat_detail ASSIGNING <lst_mat_det1>
                 WITH KEY matnr = <lst_bom_itm1>-idnrk
                 BINARY SEARCH.
            IF sy-subrc EQ 0 AND
               <lst_mat_det1>-publtype NOT IN lir_pb_type.
              CONTINUE.
            ENDIF.

*           Determine the Last BOM Item: In order to avoid the Rounding issue,
*           the Amount of the very last BOM Item has to be adjusted
            MOVE-CORRESPONDING <lst_bom_itm1> TO list_last_bom_cmp.
*           End   of ADD:ERP-7056:WROY:20-Mar-2018:ED2K911494
*           In case of missing Price, the BOM Header Price has to be pro-rated
*           equally
            lv_no_comps = lv_no_comps + 1.                        " Number of BOM Components

*           Identify Condition Type value of the BOM Line Item (Component)
            READ TABLE li_pltyp ASSIGNING <lst_inst_p1>
                 WITH KEY pltyp = komk-pltyp
                          matnr = <lst_bom_itm1>-idnrk
                 BINARY SEARCH.
            IF sy-subrc EQ 0 AND
               <lst_inst_p1>-inst_prc IS NOT INITIAL.
*             Sum up Condition Type values of all the BOM Line Items (Components)
              lv_itm_pric = lv_itm_pric + <lst_inst_p1>-inst_prc.
            ELSE.
*             In case of missing Price, the BOM Header Price has to be
*             pro-rated equally
              lv_no_pric  = abap_true.                           " Flag: No Price Maintained
            ENDIF.
          ENDLOOP.
          MOVE-CORRESPONDING list_last_bom_cmp TO lst_price_det-last_cmp.
        ENDIF.
*       Transfer Values from LOCAL variables to STATIC variables
        lst_price_det-itm_prc = lv_itm_pric.                     " Total Item Price
        lst_price_det-no_comp = lv_no_comps.                     " Number of BOM Components
        lst_price_det-no_prc  = lv_no_pric.                      " Flag: No Price Maintained
      ENDIF.

*     Transfer Values from STATIC variables to LOCAL variables
      IF lv_last_cmp IS INITIAL AND
         <lst_xvbrp_l>-posnr EQ lst_price_det-last_bi.
        lv_last_cmp = abap_true.                                 " Indicator: Last BOM Component
      ENDIF.

      IF lv_last_cmp IS INITIAL AND
         <lst_xvbap_l1>-stlty EQ lst_price_det-last_cmp-stlty AND
         <lst_xvbap_l1>-stlnr EQ lst_price_det-last_cmp-stlnr AND
         <lst_xvbap_l1>-stlkn EQ lst_price_det-last_cmp-stlkn AND
         <lst_xvbap_l1>-stpoz EQ lst_price_det-last_cmp-stpoz.
        lv_last_cmp = abap_true.                                 " Indicator: Last BOM Component
      ENDIF.

      lv_itm_pric = lst_price_det-itm_prc.                       " Total Item Price
      lv_no_comps = lst_price_det-no_comp.                       " Number of BOM Components
      lv_no_pric  = lst_price_det-no_prc.                        " Flag: No Price Maintained
*     End   of ADD:Performance

*     Exclude Publication Types: Opt-In (OI), Controlled Circulation (CC)
      READ TABLE li_mat_detail ASSIGNING <lst_mat_det1>
           WITH KEY matnr = <lst_xvbrp_l>-matnr
           BINARY SEARCH.
      IF sy-subrc EQ 0 AND
         <lst_mat_det1>-publtype NOT IN lir_pb_type.
        xkwert = 0.
      ELSE.
        IF lv_itm_pric IS NOT INITIAL OR                         " Total Item Price
           lv_no_pric  IS NOT INITIAL.                           " Flag: No Price Maintained
          READ TABLE li_pltyp ASSIGNING <lst_inst_p1>
               WITH KEY pltyp = komk-pltyp
                        matnr = <lst_xvbrp_l>-matnr
               BINARY SEARCH.
          IF sy-subrc EQ 0.
            DATA(liv_inst_prc) = <lst_inst_p1>-inst_prc.
          ENDIF.

          IF lv_no_pric  IS INITIAL.                             " Flag: No Price Maintained
*           Calculate Allocated Ratio
            CALL FUNCTION 'ZQTC_ARITHMETIC_OPERATIONS'
              EXPORTING
                im_v_operand1  = liv_inst_prc                    " Current Line Item Price
                im_v_operand2  = lv_itm_pric                     " Total Item Price
                im_v_operation = c_opr_div                       " Operand: Division
              IMPORTING
                ex_v_result    = lv_alloc_rat.                   " Allocated Ratio
          ENDIF.
        ENDIF.
*       Get the Price of the BOM Header
        READ TABLE li_vbrp_f ASSIGNING <lst_xvbrp_h>
             WITH KEY vbeln = <lst_xvbrp_l>-vbeln posnr = <lst_xvbrp_l>-uepos
             BINARY SEARCH.
        IF sy-subrc EQ 0.
*         Begin of ADD:Performance
          IF lv_last_cmp IS INITIAL.
*         End   of ADD:Performance
            IF lv_no_pric  IS INITIAL.                           " Flag: No Price Maintained
*             Calculate Allocated Amount
              CALL FUNCTION 'ZQTC_ARITHMETIC_OPERATIONS'
                EXPORTING
                  im_v_operand1  = lst_price_det-bom_h_pr        " BOM Header Price
                  im_v_operand2  = lv_alloc_rat                  " Allocated Ratio
                  im_v_operation = c_opr_mul                     " Operand: Multiplication
                IMPORTING
                  ex_v_result    = xkwert.                       " Current Line Item Value
            ELSE.
*             Calculate Allocated Amount
              CALL FUNCTION 'ZQTC_ARITHMETIC_OPERATIONS'
                EXPORTING
                  im_v_operand1  = lst_price_det-bom_h_pr        " BOM Header Price
                  im_v_operand2  = lv_no_comps                   " Number of Components
                  im_v_operation = c_opr_div                     " Operand: Division
                IMPORTING
                  ex_v_result    = xkwert.                       " Current Line Item Value
            ENDIF.
*           Begin of ADD:Performance
            lst_price_det-prc_eli = lst_price_det-prc_eli + xkwert.   " Price Excluding Last BOM Item
*           End   of ADD:Performance
            lv_cum_pri_bom = lv_cum_pri_bom + xkwert.      " NPOLINA  ED2K917170 ERPM-9191
            APPEND lst_price_det TO i_prices.
            CLEAR lst_price_det.
          ELSE.
            READ TABLE i_prices INTO lst_price_det WITH KEY
                                vbeln = <lst_xvbrp_l>-vbeln hl_items = <lst_xvbrp_l>-uepos.
            IF sy-subrc = 0.
*           Begin of ADD:Performance
              lv_pric_eli = lst_price_det-prc_eli.                    " Total Price Excluding Last Item
*           End   of ADD:Performance
*           Current Line Item Value = BOM Header Price - Total Price Excluding Last Item
              IF lv_cum_pri_bom IS NOT INITIAL. " NPOLINA  ED2K917170 ERPM-9191
               lv_pric_eli = lv_cum_pri_bom.    " NPOLINA  ED2K917170 ERPM-9191
               CLEAR lv_cum_pri_bom.            " NPOLINA  ED2K917170 ERPM-9191
              ENDIF.                            " NPOLINA  ED2K917170 ERPM-9191
              xkwert = lst_price_det-bom_h_pr - lv_pric_eli.          " Current Line Item Value
            ENDIF.
            CLEAR lst_price_det.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ELSE.
    " Nothing to do
  ENDIF.

  CLEAR: li_bom_item[].
ENDIF.
