*&---------------------------------------------------------------------*
*&  Include           ZQTCN_KNV_OUTINV_I0507
*&---------------------------------------------------------------------*
* REVISION NO : ED2K926776
* REFERENCE NO: EAM-1773/I0507
* DEVELOPER   : Vamsi Mamillapalli(VMAMILLAPA)
* DATE        : 04/12/2022
* DESCRIPTION : Custom segments population for INVOICE IDOC for APL
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*Local Variables
*----------------------------------------------------------------------*
DATA: lst_e1edkt1     TYPE e1edkt1,
      lst_e1edkt2     TYPE e1edkt2,
      lst_e1edk14_507 TYPE e1edk14,
      lst_e1edka1_507 TYPE e1edka1,
      lst_e1edpt1     TYPE e1edpt1,
      lst_e1edpt2     TYPE e1edpt2,
      lst_edidd_507   TYPE edidd,
      lst_e1edp01_507 TYPE e1edp01,
      lir_kschl       TYPE farr_tt_cond_type_range,
      lst_r_kschl     TYPE farr_s_cond_type_range,
      lv_kbetr_item   TYPE kbetr,
      lv_kbetr_h      TYPE kbetr,
      lv_kbetr_h1     TYPE kbetr,
      lv_kbetr_h2     TYPE kbetr,
      lv_kwert_item   TYPE kwert,
      lv_kwert_h      TYPE kwert,
      lv_kwert_h1     TYPE kwert,
      lv_kwert_h2     TYPE kwert,
      lv_kawrt_item   TYPE kawrt,
      lv_kawrt_h      TYPE kawrt,
      lv_kawrt_h1     TYPE kawrt,
      lv_kawrt_h2     TYPE kawrt.

*----------------------------------------------------------------------*
*Local Constants
*----------------------------------------------------------------------*
CONSTANTS: lc_e1edk14              TYPE edilsegtyp VALUE 'E1EDK14',
           lc_e1edkt1              TYPE edilsegtyp VALUE 'E1EDKT1',
           lc_e1edpt1              TYPE edilsegtyp VALUE 'E1EDPT1',
           lc_e1edkt2              TYPE edilsegtyp VALUE 'E1EDKT2',
           lc_e1edpt2              TYPE edilsegtyp VALUE 'E1EDPT2',
           lc_e1eds01              TYPE edilsegtyp VALUE 'E1EDS01',
           lc_e1edka1_507          TYPE edilsegtyp VALUE 'E1EDKA1',
           lc_soldto               TYPE char2      VALUE 'AG',
           lc_devid_i0507          TYPE zdevid     VALUE 'I0507',
           lc_sign                 TYPE ddsign     VALUE 'I',
           lc_option               TYPE ddoption   VALUE 'EQ',
           lc_kschl                TYPE rvari_vnam VALUE 'KSCHL',
           lc_kschl_vat            TYPE rvari_vnam VALUE 'KSCHL_VAT',
           lc_kschl_freight        TYPE rvari_vnam VALUE 'KSCHL_FREIGHT',
           lc_pub_typ              TYPE rvari_vnam VALUE 'ISMPUBLTYPE',  "Publication type
           lc_item_cat             TYPE rvari_vnam VALUE 'PSTYV',        "Sales document item category
           lc_create_date          TYPE rvari_vnam VALUE 'CREATE_DATE',        "Creation Date
           lc_create_time          TYPE rvari_vnam VALUE 'CREATE_TIME',        "Creation Time
           lc_sap_int              TYPE rvari_vnam VALUE 'SAP_INT_CONST',
           lc_l2                   TYPE edi_hlevel VALUE 2,
           lc_l3                   TYPE edi_hlevel VALUE 3,
           lc_l4                   TYPE edi_hlevel VALUE 4,
           lc_h_posnr              TYPE kposn      VALUE '000000',
*          Header Text ids
           lc_sp_bag_no            TYPE rvari_vnam VALUE 'SP_BAG_NO',           "KAG2
           lc_vat_h                TYPE rvari_vnam VALUE 'VAT_H',               "KVAT
           lc_tot_amount           TYPE rvari_vnam VALUE 'TOT_AMOUNT',          "KY08
           lc_vat_prct_redc        TYPE rvari_vnam VALUE 'VAT_PRCT_REDC',       "KY09
           lc_tax_amnt_vat_rrate   TYPE rvari_vnam VALUE 'TAX_AMNT_VAT_RRATE',  "KY10
           lc_vat_amnt_rrate       TYPE rvari_vnam VALUE 'VAT_AMNT_RRATE',      "KY11
           lc_vat_prct_f1          TYPE rvari_vnam VALUE 'VAT_PRCT_F1',         "KY12
           lc_vat_prct_f2          TYPE rvari_vnam VALUE 'VAT_PRCT_F2',         "KY13
           lc_vat_amnt_frate       TYPE rvari_vnam VALUE 'VAT_AMNT_FRATE',      "KY14
           lc_tot_i_amnt_ded_frt_0 TYPE rvari_vnam VALUE 'TOT_I_AMNT_DED_FRT_0',  "KY15
           lc_tot_i_amnt_ded_frt_r TYPE rvari_vnam VALUE 'TOT_I_AMNT_DED_FRT_R',  "KY16
           lc_tot_i_amnt_ded_frt_f TYPE rvari_vnam VALUE 'TOT_I_AMNT_DED_FRT_F',  "KY17
*           Item Text ids
           lc_surch_prct           TYPE rvari_vnam VALUE 'SURCH_PRCT',          "KP01
           lc_surch_amnt           TYPE rvari_vnam VALUE 'SURCH_AMNT',          "KP02
           lc_add_ded              TYPE rvari_vnam VALUE 'ADD_DED',             "KP03
           lc_vat_i_red            TYPE rvari_vnam VALUE 'VAT_I_RED',           "KP04
           lc_netval_i_rvat        TYPE rvari_vnam VALUE 'NETVAL_I_RVAT',       "KP05
           lc_vat_i_full           TYPE rvari_vnam VALUE 'VAT_I_FULL',          "KP06
           lc_netval_i_fvat        TYPE rvari_vnam VALUE 'NETVAL_I_FVAT',       "KP07
           lc_add_quan_dlv         TYPE rvari_vnam VALUE 'ADD_QUAN_DLV'.        "KP08

* fetch constant values
zca_utilities=>get_integ_constants( EXPORTING im_devid = lc_devid_i0507
                                              im_param2 = lc_sap_int
                                     IMPORTING et_constants = DATA(li_constants)
                                    ).
* Append discount conditions to range table
lst_r_kschl-sign = lc_sign.
lst_r_kschl-option = lc_option.
LOOP AT li_constants INTO DATA(lst_const) WHERE param1 = lc_kschl.
  lst_r_kschl-low = lst_const-sap_value.
  APPEND lst_r_kschl TO lir_kschl.
  CLEAR:lst_r_kschl-low.
ENDLOOP.
CLEAR:lst_r_kschl.

*Header Texts should be added before E1EDK14 segment
IF int_edidd-segnam = lc_e1edk14.
* This exit triggers multiple times,Check if the text already added
  IF line_exists( li_constants[ param1 = lc_sp_bag_no ] ).
    "Get Identifier from ZCAINTEG-MAPPING
    IF NOT line_exists( int_edidd[ segnam = lc_e1edkt1 sdata+0(4) =  li_constants[ param1 = lc_sp_bag_no ]-sap_value ] ).
      DATA(lv_app_htext) = abap_true.

    ENDIF." IF NOT line_exists( int_edidd[ segnam = lc_e1edkt1 sdata+0(4) = lv_sp_bag_no ] ).
  ENDIF.
ENDIF.
*Item Texts should be added before E1EDS01 segment
IF int_edidd-segnam = lc_e1eds01 .
*This exit triggers multiple times,Check if the text already added
  IF line_exists( li_constants[ param1 = lc_surch_prct ] ).
*  "Get Identifier from ZCAINTEG-MAPPING
    IF NOT  line_exists( int_edidd[ segnam = lc_e1edpt1 sdata+0(4) = li_constants[ param1 = lc_surch_prct ]-sap_value ] ) .
      DATA(lv_app_itext) = abap_true.

    ENDIF."IF NOT  line_exists( int_edidd[ segnam = lc_e1edpt1 sdata+0(4) = lv_surch_prct ] ) .
  ENDIF.
ENDIF.

IF lv_app_htext IS NOT INITIAL OR lv_app_itext IS NOT INITIAL.
  SELECT
    knumv,  "Number of the document condition
    kposn,  "Condition item number
    stunr,  "Step number
    zaehk,  "Condition counter
    kschl,  "Condition type
    kawrt,  "Condition base value
    kbetr,  "Rate (condition amount or percentage)
    kwert	  "Condition value
FROM konv   "Conditions (Transaction Data)
INTO TABLE @DATA(li_konv_507)
WHERE knumv = @dvbdkr-knumv
ORDER BY knumv,kposn,stunr.
  IF sy-subrc IS INITIAL.
    "VAT conditions
    IF line_exists( li_constants[ param1 = lc_kschl_vat ] ).
      DATA(lv_vat_kschl) = li_constants[ param1 = lc_kschl_vat ]-sap_value.
      DATA(li_konv_vat) = li_konv_507.
      SORT li_konv_vat BY kschl kbetr.
      DELETE li_konv_vat WHERE kschl NE lv_vat_kschl.
    ENDIF.
  ENDIF."IF sy-subrc IS INITIAL.
  IF line_exists( li_constants[ param1 = lc_pub_typ ] ).
    DATA(lv_pub_typ) = li_constants[ param1 = lc_pub_typ ]-sap_value.
  ENDIF.
  DATA(li_vbdpr) = xtvbdpr[].
  SORT li_vbdpr BY matnr.
  DELETE ADJACENT DUPLICATES FROM li_vbdpr COMPARING matnr.
*  Fetch Publication type from MARA
  IF li_vbdpr IS NOT INITIAL.
    SELECT matnr,
           ismpubltype
      FROM mara
      INTO TABLE @DATA(li_mara_507)
      FOR ALL ENTRIES IN @li_vbdpr
      WHERE matnr = @li_vbdpr-matnr.
    IF sy-subrc IS INITIAL.
      SORT li_mara_507 BY matnr ismpubltype.
    ENDIF.
  ENDIF.
ENDIF.
*-------------------------------------------------------
* Header texts
*-------------------------------------------------------
IF lv_app_htext IS NOT INITIAL.

  SELECT SINGLE erdat,
                erzet
    FROM vbrk INTO (@DATA(lv_erdat_507),@DATA(lv_erzet_507) )
    WHERE vbeln = @xvbdkr-vbeln.
    IF sy-subrc IS INITIAL.

    ENDIF.
*  * Read the index for inserting texts
  IF line_exists( int_edidd[ segnam = lc_e1edk14 ] ).
    DATA(lv_text_pos) = line_index( int_edidd[ segnam = lc_e1edk14 ] ).
  ENDIF.
*---------------------------
*  Creation Date
*---------------------------
  IF line_exists( li_constants[ param1 = lc_create_date ] ).
     CLEAR:lst_edidd.
* Populate Text header to E1EDKT1 segment
      lst_e1edkt1-tdid = li_constants[ param1 = lc_create_date ]-sap_value.
      lst_e1edkt1-tsspras = sy-langu.
      lst_edidd-hlevel = lc_l2.
      lst_edidd-segnam = lc_e1edkt1.
      lst_edidd-sdata =  lst_e1edkt1.
* Insert Text Header
      INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
      lv_text_pos = lv_text_pos + 1.
* Populate Text Value to E1EDKT2 segment
      CLEAR: lst_e1edkt1, lst_edidd.
      lst_e1edkt2-tdline = lv_erdat_507.
      lst_edidd-segnam = lc_e1edkt2.
      lst_edidd-sdata =  lst_e1edkt2.
      lst_edidd-hlevel = lc_l3.
* Insert Text Value
      INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
      lv_text_pos = lv_text_pos + 1.
      CLEAR: lst_e1edkt2, lst_edidd.

  ENDIF.
*---------------------------
*  Creation Time
*---------------------------
  IF line_exists( li_constants[ param1 = lc_create_time ] ).
     CLEAR:lst_edidd.
* Populate Text header to E1EDKT1 segment
      lst_e1edkt1-tdid = li_constants[ param1 = lc_create_time ]-sap_value.
      lst_e1edkt1-tsspras = sy-langu.
      lst_edidd-hlevel = lc_l2.
      lst_edidd-segnam = lc_e1edkt1.
      lst_edidd-sdata =  lst_e1edkt1.
* Insert Text Header
      INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
      lv_text_pos = lv_text_pos + 1.
* Populate Text Value to E1EDKT2 segment
      CLEAR: lst_e1edkt1, lst_edidd.
      lst_e1edkt2-tdline = lv_erzet_507.
      lst_edidd-segnam = lc_e1edkt2.
      lst_edidd-sdata =  lst_e1edkt2.
      lst_edidd-hlevel = lc_l3.
* Insert Text Value
      INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
      lv_text_pos = lv_text_pos + 1.
      CLEAR: lst_e1edkt2, lst_edidd.
  ENDIF.
*---------------------------
*  Freight
*---------------------------
  IF line_exists( li_constants[ param1 = lc_kschl_freight ] ).
    DATA(lv_kschl_freight) = li_constants[ param1 = lc_kschl_freight ]-sap_value.
    IF line_exists( li_konv_507[ kposn = lc_h_posnr kschl = lv_kschl_freight ] ).
      DATA(lv_freight) = li_konv_507[ kposn = lc_h_posnr kschl = lv_kschl_freight ]-kbetr.
    ENDIF.
  ENDIF.
*  -------------------------
*  Sold to Party Bag Number-KAG2
*  -------------------------
*    * Use Customer as Sold to party number
  IF line_exists( int_edidd[ segnam = lc_e1edka1_507 sdata+0(2) = lc_soldto ] ).
    lst_edidd_507 = int_edidd[ segnam = lc_e1edka1_507 sdata+0(2) = lc_soldto ] .
    CLEAR:lst_e1edka1_507.
    lst_e1edka1_507 = lst_edidd_507-sdata.
* Fetch EIKTO from KNB1
    SELECT SINGLE eikto "Our account number at customer
    FROM knb1 "Customer Master (Company Code)
    INTO @DATA(lv_eikto)
    WHERE kunnr = @lst_e1edka1_507-partn
    AND bukrs = @xvbdkr-bukrs.
    IF sy-subrc IS INITIAL.

      CLEAR:lst_edidd.
* Populate Text header to E1EDKT1 segment
      lst_e1edkt1-tdid = li_constants[ param1 = lc_sp_bag_no ]-sap_value.
      lst_e1edkt1-tsspras = sy-langu.
      lst_edidd-hlevel = lc_l2.
      lst_edidd-segnam = lc_e1edkt1.
      lst_edidd-sdata =  lst_e1edkt1.
* Insert Text Header
      INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
      lv_text_pos = lv_text_pos + 1.
* Populate Text Value to E1EDKT2 segment
      CLEAR: lst_e1edkt1, lst_edidd.
      lst_e1edkt2-tdline = lv_eikto.
      lst_edidd-segnam = lc_e1edkt2.
      lst_edidd-sdata =  lst_e1edkt2.
      lst_edidd-hlevel = lc_l3.
* Insert Text Value
      INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
      lv_text_pos = lv_text_pos + 1.
      CLEAR: lst_e1edkt2, lst_edidd.
*      ENDIF." IF line_exists( int_edidd[ segnam = lc_e1edk14 ] ).

    ENDIF."IF sy-subrc IS INITIAL.
  ENDIF."IF line_exists( int_edidd[ segnam = lc_e1edka1_507 sdata+0(2) = lc_soldto ] ).
*---------------------
*VAT% always 7%-KVAT
*---------------------
  IF  line_exists( li_constants[ param1 = lc_vat_h ] ).
*  (EXCLUDE KOMV-KBETR=0%) for the respective line items need to get the unique % value from KONV-KBETR
    LOOP AT li_konv_vat INTO DATA(lst_hkonv) WHERE kbetr IS NOT INITIAL.
      lv_kbetr_h = lst_hkonv-kbetr.
      EXIT.
    ENDLOOP.
    lv_kbetr_h = lv_kbetr_h / 10.
    CLEAR:lst_edidd.
    lst_e1edkt1-tdid = li_constants[ param1 = lc_vat_h ]-sap_value ."'KVAT'.
    lst_e1edkt1-tsspras = sy-langu.
    lst_edidd-hlevel = 2.
    lst_edidd-segnam = lc_e1edkt1.
    lst_edidd-sdata =  lst_e1edkt1.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.

    CLEAR: lst_e1edkt1, lst_edidd.
    lst_e1edkt2-tdline = lv_kbetr_h.
    lst_e1edkt2-tdline = shift_left( lst_e1edkt2-tdline ).
    lst_edidd-hlevel = 3.
    lst_edidd-segnam = lc_e1edkt2.
    lst_edidd-sdata =  lst_e1edkt2.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt2, lst_edidd."lv_kbetr_h.
  ENDIF.
*-------------------------------
*    Total amount VAT Free-KPY08
*-------------------------------
  CLEAR:lst_hkonv,lv_kawrt_h.
  LOOP AT li_konv_vat INTO lst_hkonv WHERE kbetr IS  INITIAL.
    lv_kawrt_h = lv_kawrt_h + lst_hkonv-kawrt. "0% amount
  ENDLOOP.
  IF  line_exists( li_constants[ param1 = lc_tot_amount ] ).

    CLEAR:lst_edidd.
    lst_e1edkt1-tdid =  li_constants[ param1 = lc_tot_amount ]-sap_value."'KP08'.
    lst_e1edkt1-tsspras = sy-langu.
    lst_edidd-hlevel = 2.
    lst_edidd-segnam = lc_e1edkt1.
    lst_edidd-sdata =  lst_e1edkt1.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.

    CLEAR: lst_e1edkt1, lst_edidd.
    lst_e1edkt2-tdline = lv_kawrt_h.
    lst_e1edkt2-tdline = shift_left( lst_e1edkt2-tdline ).
    lst_edidd-hlevel = 3.
    lst_edidd-segnam = lc_e1edkt2.
    lst_edidd-sdata =  lst_e1edkt2.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt2, lst_edidd."lv_kawrt_h.
  ENDIF.
  IF  line_exists( li_constants[ param1 = lc_pub_typ ] ).
    CLEAR:lst_hkonv.
    CLEAR:lv_kawrt_h1,lv_kawrt_h2,lv_kbetr_h1,lv_kbetr_h2.
*   Pass VBRP-MATNR into MARA table and get PUBTYPE, determine the VAT percentage based on PUBTYPE
*   PUBTYPE <>"OP" (EXCLUDE KOMV-KBETR=0% ) => 7%VAT ( Reduced VAT )
*   PUBTYPE = "OP" (EXCLUDE KOMV-KBETR=0% ) => 19%VAT( Full VAT)
    LOOP AT li_konv_vat INTO lst_hkonv WHERE kbetr IS NOT INITIAL.
      IF line_exists( xtvbdpr[ posnr = lst_hkonv-kposn ] ) AND line_exists( li_mara_507[ matnr = xtvbdpr[ posnr = lst_hkonv-kposn ]-matnr ] ) .
        IF li_mara_507[ matnr = xtvbdpr[ posnr = lst_hkonv-kposn ]-matnr ]-ismpubltype NE li_constants[ param1 = lc_pub_typ ]-sap_value.
          lv_kawrt_h1 = lv_kawrt_h1 + lst_hkonv-kawrt." Reduced amount
          lv_kwert_h1 = lv_kwert_h1 + lst_hkonv-kwert." Reduced amount
          IF lv_kbetr_h1 IS INITIAL.
            lv_kbetr_h1 =  lst_hkonv-kbetr." Reduced amount
          ENDIF.
        ELSE.
          lv_kawrt_h2 = lv_kawrt_h2 + lst_hkonv-kawrt." Full amount
          lv_kwert_h2 = lv_kwert_h2 + lst_hkonv-kwert." Reduced amount
          IF lv_kbetr_h2 IS INITIAL.
            lv_kbetr_h2 =  lst_hkonv-kbetr." Reduced amount
          ENDIF.
        ENDIF.
      ENDIF.

    ENDLOOP.
  ENDIF.
  lv_kbetr_h1 = lv_kbetr_h1 / 10.
  lv_kbetr_h2 = lv_kbetr_h2 / 10.
*-------------------------------
*    Reduced VAT Rate-KP09
*-------------------------------
  IF  line_exists( li_constants[ param1 = lc_vat_prct_redc ] ).
    CLEAR:lst_edidd.
    lst_e1edkt1-tdid = li_constants[ param1 = lc_vat_prct_redc ]-sap_value."'KP09'.
    lst_e1edkt1-tsspras = sy-langu.
    lst_edidd-hlevel = 2.
    lst_edidd-segnam = lc_e1edkt1.
    lst_edidd-sdata =  lst_e1edkt1.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt1, lst_edidd.
    lst_e1edkt2-tdline = lv_kbetr_h1.
    lst_e1edkt2-tdline = shift_left( lst_e1edkt2-tdline ).
    lst_edidd-hlevel = 3.
    lst_edidd-segnam = lc_e1edkt2.
    lst_edidd-sdata =  lst_e1edkt2.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt2, lst_edidd.
  ENDIF.
*-------------------------------
*    Total amount VAT Reduced amount-KPY10
*-------------------------------
  IF  line_exists( li_constants[ param1 = lc_tax_amnt_vat_rrate ] ).
    CLEAR:lst_edidd.
    lst_e1edkt1-tdid = li_constants[ param1 = lc_tax_amnt_vat_rrate ]-sap_value."'KP10'.
    lst_e1edkt1-tsspras = sy-langu.
    lst_edidd-hlevel = 2.
    lst_edidd-segnam = lc_e1edkt1.
    lst_edidd-sdata =  lst_e1edkt1.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt1, lst_edidd.
    lst_e1edkt2-tdline = lv_kawrt_h1.
    lst_e1edkt2-tdline = shift_left( lst_e1edkt2-tdline ).
    lst_edidd-hlevel = 3.
    lst_edidd-segnam = lc_e1edkt2.
    lst_edidd-sdata =  lst_e1edkt2.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt2, lst_edidd.
  ENDIF.
*-------------------------------
*    Reduced VAT Rate-KP11
*-------------------------------

  IF  line_exists( li_constants[ param1 = lc_vat_amnt_rrate ] ).
    CLEAR:lst_edidd.
    lst_e1edkt1-tdid = li_constants[ param1 = lc_vat_amnt_rrate ]-sap_value."'KP11'.
    lst_e1edkt1-tsspras = sy-langu.
    lst_edidd-hlevel = 2.
    lst_edidd-segnam = lc_e1edkt1.
    lst_edidd-sdata =  lst_e1edkt1.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt1, lst_edidd.
    lst_e1edkt2-tdline = lv_kwert_h1.
    lst_e1edkt2-tdline = shift_left( lst_e1edkt2-tdline ).
    lst_edidd-hlevel = 3.
    lst_edidd-segnam = lc_e1edkt2.
    lst_edidd-sdata =  lst_e1edkt2.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt2, lst_edidd.
  ENDIF.
*-------------------------------
*   Full VAT Rate-KP12
*-------------------------------
  IF  line_exists( li_constants[ param1 = lc_vat_prct_f1 ] ).

    CLEAR:lst_edidd.
    lst_e1edkt1-tdid = li_constants[ param1 = lc_vat_prct_f1 ]-sap_value."'KP12'.
    lst_e1edkt1-tsspras = sy-langu.
    lst_edidd-hlevel = 2.
    lst_edidd-segnam = lc_e1edkt1.
    lst_edidd-sdata =  lst_e1edkt1.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt1, lst_edidd.
    lst_e1edkt2-tdline = lv_kbetr_h2.
    lst_e1edkt2-tdline = shift_left( lst_e1edkt2-tdline ).
    lst_edidd-hlevel = 3.
    lst_edidd-segnam = lc_e1edkt2.
    lst_edidd-sdata =  lst_e1edkt2.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt2, lst_edidd.
  ENDIF.
*-------------------------------
*    Total amount VAT Full amount-KPY13
*-------------------------------
  IF  line_exists( li_constants[ param1 = lc_vat_prct_f2 ] ).
    CLEAR:lst_edidd.
    lst_e1edkt1-tdid = li_constants[ param1 = lc_vat_prct_f2 ]-sap_value."'KP13'.
    lst_e1edkt1-tsspras = sy-langu.
    lst_edidd-hlevel = 2.
    lst_edidd-segnam = lc_e1edkt1.
    lst_edidd-sdata =  lst_e1edkt1.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt1, lst_edidd.
    lst_e1edkt2-tdline = lv_kawrt_h2.
    lst_e1edkt2-tdline = shift_left( lst_e1edkt2-tdline ).
    lst_edidd-hlevel = 3.
    lst_edidd-segnam = lc_e1edkt2.
    lst_edidd-sdata =  lst_e1edkt2.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt2, lst_edidd.
  ENDIF.
*-------------------------------
*    VAT AMount full rate-KP14
*-------------------------------
  IF  line_exists( li_constants[ param1 = lc_vat_amnt_frate ] ).
    CLEAR:lst_edidd.
    lst_e1edkt1-tdid = li_constants[ param1 = lc_vat_amnt_frate ]-sap_value."'KP14'.
    lst_e1edkt1-tsspras = sy-langu.
    lst_edidd-hlevel = 2.
    lst_edidd-segnam = lc_e1edkt1.
    lst_edidd-sdata =  lst_e1edkt1.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt1, lst_edidd.
    lst_e1edkt2-tdline = lv_kwert_h2.
    lst_e1edkt2-tdline = shift_left( lst_e1edkt2-tdline ).
    lst_edidd-hlevel = 3.
    lst_edidd-segnam = lc_e1edkt2.
    lst_edidd-sdata =  lst_e1edkt2.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt2, lst_edidd.
  ENDIF.
*-------------------------------
*   0% total amount subtracting freight KP15
*-------------------------------
  IF  line_exists( li_constants[ param1 = lc_tot_i_amnt_ded_frt_0 ] ).
    CLEAR:lst_edidd.
    lst_e1edkt1-tdid = li_constants[ param1 = lc_tot_i_amnt_ded_frt_0 ]-sap_value."'KP15'.
    lst_e1edkt1-tsspras = sy-langu.
    lst_edidd-hlevel = 2.
    lst_edidd-segnam = lc_e1edkt1.
    lst_edidd-sdata =  lst_e1edkt1.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt1, lst_edidd.
    lst_e1edkt2-tdline = lv_kawrt_h - lv_freight.
    lst_e1edkt2-tdline = shift_left( lst_e1edkt2-tdline ).
    lst_edidd-hlevel = 3.
    lst_edidd-segnam = lc_e1edkt2.
    lst_edidd-sdata =  lst_e1edkt2.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt2, lst_edidd.
  ENDIF.
*-------------------------------
*   7% total amount subtracting freight KP16
*-------------------------------
  IF  line_exists( li_constants[ param1 = lc_tot_i_amnt_ded_frt_r ] ).
    CLEAR:lst_edidd.
    lst_e1edkt1-tdid = li_constants[ param1 = lc_tot_i_amnt_ded_frt_r ]-sap_value."'KP16'.
    lst_e1edkt1-tsspras = sy-langu.
    lst_edidd-hlevel = 2.
    lst_edidd-segnam = lc_e1edkt1.
    lst_edidd-sdata =  lst_e1edkt1.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt1, lst_edidd.
    lst_e1edkt2-tdline = lv_kwert_h1 - lv_freight.
    lst_e1edkt2-tdline = shift_left( lst_e1edkt2-tdline ).
    lst_edidd-hlevel = 3.
    lst_edidd-segnam = lc_e1edkt2.
    lst_edidd-sdata =  lst_e1edkt2.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt2, lst_edidd.
  ENDIF.
*-------------------------------
*   19% total amount subtracting freight KP17
*-------------------------------
  IF  line_exists( li_constants[ param1 = lc_tot_i_amnt_ded_frt_f ] ).
    CLEAR:lst_edidd.
    lst_e1edkt1-tdid = li_constants[ param1 = lc_tot_i_amnt_ded_frt_f ]-sap_value."'KP17'.
    lst_e1edkt1-tsspras = sy-langu.
    lst_edidd-hlevel = 2.
    lst_edidd-segnam = lc_e1edkt1.
    lst_edidd-sdata =  lst_e1edkt1.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt1, lst_edidd.
    lst_e1edkt2-tdline = lv_kwert_h2 - lv_freight.
    lst_e1edkt2-tdline = shift_left( lst_e1edkt2-tdline ).
    lst_edidd-hlevel = 3.
    lst_edidd-segnam = lc_e1edkt2.
    lst_edidd-sdata =  lst_e1edkt2.
    INSERT lst_edidd INTO int_edidd INDEX lv_text_pos.
    lv_text_pos = lv_text_pos + 1.
    CLEAR: lst_e1edkt2, lst_edidd.
  ENDIF.
ENDIF.
CLEAR:lv_app_htext.
CLEAR:lv_text_pos.
*-------------------------------------------------------
* Item texts
*-------------------------------------------------------
IF lv_app_itext IS NOT INITIAL.

*    Get the line item index
  LOOP AT int_edidd INTO DATA(lst_edidd_504) WHERE segnam = lc_e1edp01.
    lst_e1edp01_507 = lst_edidd_504-sdata.
    DATA(lv_index1_504) = sy-tabix. " Current item index
    lv_index1_504 = lv_index1_504 + 1. " next segement index
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = lst_e1edp01_507-matnr
      IMPORTING
        output       = lst_e1edp01_507-matnr
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    IF lir_kschl IS NOT INITIAL." Discount conditions
      CLEAR: lv_kbetr_item, lv_kwert_item.
      LOOP AT li_konv_507 INTO DATA(lst_konv) WHERE kposn = lst_e1edp01_507-posex AND kschl IN lir_kschl.
        lv_kbetr_item = lv_kbetr_item + lst_konv-kbetr."discount percent
        lv_kwert_item = lv_kwert_item + lst_konv-kwert." discount amount
      ENDLOOP.
    ENDIF.
    lv_kbetr_item = lv_kbetr_item / 10.
    lv_kbetr_item = lv_kbetr_item * -1.
*    Read the next line item starting position for E1EDP01 segment
    LOOP AT int_edidd INTO DATA(lst_edidd_504_2) FROM lv_index1_504 WHERE segnam = lc_e1edp01 .
      DATA(lv_index2_504) = sy-tabix.
      EXIT.
    ENDLOOP.
    IF sy-subrc IS NOT INITIAL.
*   If there is no next item get the summary segment E1EDS01 index
      READ TABLE int_edidd WITH KEY segnam = lc_e1eds01 TRANSPORTING NO FIELDS.
      IF sy-subrc IS INITIAL.
        lv_index2_504 = sy-tabix.
      ENDIF.
    ENDIF.
*    Append Item texts
*  ------------------------------------------------------------------------------------------------
*  Surcharge or discount in percent. In sub-items (bundles) no information here, otherwise mandatory.-KP01
*  ------------------------------------------------------------------------------------------------
    IF lv_index2_504 IS NOT INITIAL.
      CLEAR:lst_edidd.
      IF line_exists( li_constants[ param1 = lc_surch_prct ] )."KP01
        lst_e1edpt1-tdid = li_constants[ param1 = lc_surch_prct ]-sap_value."Get Identifier from ZCAINTEG-MAPPING.
        lst_e1edpt1-tsspras = sy-langu.
        lst_edidd-hlevel = lc_l3.
        lst_edidd-segnam = lc_e1edpt1.
        lst_edidd-sdata =  lst_e1edpt1.
        INSERT lst_edidd INTO int_edidd INDEX lv_index2_504 .

        CLEAR: lst_e1edpt1, lst_edidd.
        lst_e1edpt2-tdline = lv_kbetr_item.
        lst_e1edpt2-tdline = shift_left( lst_e1edpt2-tdline ).
        lst_edidd-hlevel = lc_l4.
        lst_edidd-segnam = lc_e1edpt2.
        lst_edidd-sdata =  lst_e1edpt2.
        lv_index2_504 = lv_index2_504 + 1.
        INSERT lst_edidd INTO int_edidd INDEX lv_index2_504 .
        CLEAR: lst_e1edpt2, lst_edidd.
      ENDIF.
*  --------------------------------
*  Addition or deduction VAT free-KP03
*  ---------------------------------
      IF line_exists( li_constants[ param1 = lc_add_ded ] ).
        IF line_exists( li_konv_507[ kposn = lst_e1edp01_507-posex kschl = lv_vat_kschl ] ).
          CLEAR:lst_konv,lv_kawrt_item.
*               Get (KONV-KAWRT) where (KONV-KBETR) =0% for the respective line items (KONV-KPOSN).
          LOOP AT li_konv_vat INTO lst_konv WHERE kposn = lst_e1edp01_507-posex AND kbetr IS INITIAL.
            lv_kawrt_item = lv_kawrt_item + lst_konv-kawrt.
          ENDLOOP.
          CLEAR:lst_edidd.
          lst_e1edpt1-tdid = li_constants[ param1 = lc_add_ded ]-sap_value."Get Identifier from ZCAINTEG-MAPPING."KP02
          lst_e1edpt1-tsspras = sy-langu.
          lst_edidd-hlevel = lc_l3.
          lst_edidd-segnam = lc_e1edpt1.
          lst_edidd-sdata =  lst_e1edpt1.
          lv_index2_504 = lv_index2_504 + 1.
          INSERT lst_edidd INTO int_edidd INDEX lv_index2_504 .
          CLEAR: lst_e1edpt1, lst_edidd.

          lst_e1edpt2-tdline = lv_kawrt_item .
          lst_e1edpt2-tdline = shift_left( lst_e1edpt2-tdline ).
          lst_edidd-hlevel = lc_l4.
          lst_edidd-segnam = lc_e1edpt2.
          lst_edidd-sdata =  lst_e1edpt2.
          lv_index2_504 = lv_index2_504 + 1.
          INSERT lst_edidd INTO int_edidd INDEX lv_index2_504 .
          CLEAR: lst_e1edpt2, lst_edidd.
        ENDIF.
      ENDIF.
*---------------------------------------------------------------------
*    Additional or deduction amount including VAT reduced tax rate.-KP04
*---------------------------------------------------------------------
      IF line_exists( li_constants[ param1 = lc_vat_i_red ] ) AND line_exists( li_mara_507[ matnr =  lst_e1edp01_507-matnr ] ).
        IF li_mara_507[ matnr =  lst_e1edp01_507-matnr ] NE lv_pub_typ.
          CLEAR:lv_kbetr_item,lst_konv.
*          (EXCLUDE KOMV-KBETR=0%) for the respective line items need to get the unique % value from KONV-KBETR
          LOOP AT li_konv_vat INTO lst_konv WHERE kposn = lst_e1edp01_507-posex AND kbetr IS NOT INITIAL.
            lv_kbetr_item = lst_konv-kbetr.
            EXIT.
          ENDLOOP.
          lv_kbetr_item = lv_kbetr_item / 10.
          CLEAR:lst_edidd.
          lst_e1edpt1-tdid = li_constants[ param1 = lc_vat_i_red ]-sap_value."Get Identifier from ZCAINTEG-MAPPING."KP02
          lst_e1edpt1-tsspras = sy-langu.
          lst_edidd-hlevel = lc_l3.
          lst_edidd-segnam = lc_e1edpt1.
          lst_edidd-sdata =  lst_e1edpt1.
          lv_index2_504 = lv_index2_504 + 1.
          INSERT lst_edidd INTO int_edidd INDEX lv_index2_504 .
          CLEAR: lst_e1edpt1, lst_edidd.

          lst_e1edpt2-tdline = lv_kbetr_item .
          lst_e1edpt2-tdline = shift_left( lst_e1edpt2-tdline ).
          lst_edidd-hlevel = lc_l4.
          lst_edidd-segnam = lc_e1edpt2.
          lst_edidd-sdata =  lst_e1edpt2.
          lv_index2_504 = lv_index2_504 + 1.
          INSERT lst_edidd INTO int_edidd INDEX lv_index2_504 .

          CLEAR: lst_e1edpt2, lst_edidd.
        ENDIF.
      ENDIF." IF line_exists( li_constants[ param1 = lc_vat_i_Red ] ).

*---------------------------------------------------------------------
* Net Value with 7% KP05
*---------------------------------------------------------------------
      IF line_exists( li_constants[ param1 = lc_netval_i_rvat  ] ).
        IF line_exists( li_mara_507[ matnr =  lst_e1edp01_507-matnr ] ) AND li_mara_507[ matnr =  lst_e1edp01_507-matnr ] NE lv_pub_typ.
          CLEAR:lv_kawrt_item,lst_konv.
*          (EXCLUDE KOMV-KBETR=0%) for the respective line items need to get the unique % value from KONV-KBETR
          LOOP AT li_konv_vat INTO lst_konv WHERE kposn = lst_e1edp01_507-posex AND kbetr IS NOT INITIAL.
            lv_kawrt_item = lv_kawrt_item + lst_konv-kawrt.
          ENDLOOP.
          CLEAR:lst_edidd.
          lst_e1edpt1-tdid = li_constants[ param1 = lc_netval_i_rvat ]-sap_value. "'KP05'."li_constants[ param1 = lc_add_ded_rvat ]-sap_value."Get Identifier from ZCAINTEG-MAPPING."KP02
          lst_e1edpt1-tsspras = sy-langu.
          lst_edidd-hlevel = lc_l3.
          lst_edidd-segnam = lc_e1edpt1.
          lst_edidd-sdata =  lst_e1edpt1.
          lv_index2_504 = lv_index2_504 + 1.
          INSERT lst_edidd INTO int_edidd INDEX lv_index2_504 .
          CLEAR: lst_e1edpt1, lst_edidd.

          lst_e1edpt2-tdline = lv_kawrt_item .
          lst_e1edpt2-tdline = shift_left( lst_e1edpt2-tdline ).
          lst_edidd-hlevel = lc_l4.
          lst_edidd-segnam = lc_e1edpt2.
          lst_edidd-sdata =  lst_e1edpt2.
          lv_index2_504 = lv_index2_504 + 1.
          INSERT lst_edidd INTO int_edidd INDEX lv_index2_504 .

          CLEAR: lst_e1edpt2, lst_edidd.
        ENDIF.
      ENDIF." IF line_exists( li_constants[ param1 = lc_NETVAL_I_RVAT] ).
*---------------------------------------------------------------------
*VAT 19% KP06
*---------------------------------------------------------------------
      IF line_exists( li_constants[ param1 = lc_vat_i_full ] ).
        IF line_exists( li_mara_507[ matnr =  lst_e1edp01_507-matnr ] ) AND li_mara_507[ matnr =  lst_e1edp01_507-matnr ] EQ lv_pub_typ.
          CLEAR:lv_kbetr_item,lst_konv.
*          (EXCLUDE KOMV-KBETR=0%) for the respective line items need to get the unique % value from KONV-KBETR
          CLEAR:lv_kbetr_item.
          LOOP AT li_konv_vat INTO lst_konv WHERE kposn = lst_e1edp01_507-posex AND kbetr IS NOT INITIAL.
            lv_kbetr_item = lst_konv-kbetr.
            EXIT.
          ENDLOOP.
          lv_kbetr_item = lv_kbetr_item / 10.
          CLEAR:lst_edidd.
          lst_e1edpt1-tdid = li_constants[ param1 = lc_vat_i_full ]-sap_value."Get Identifier from ZCAINTEG-MAPPING."KP06
          lst_e1edpt1-tsspras = sy-langu.
          lst_edidd-hlevel = lc_l3.
          lst_edidd-segnam = lc_e1edpt1.
          lst_edidd-sdata =  lst_e1edpt1.
          lv_index2_504 = lv_index2_504 + 1.
          INSERT lst_edidd INTO int_edidd INDEX lv_index2_504 .
          CLEAR: lst_e1edpt1, lst_edidd.

          lst_e1edpt2-tdline = lv_kbetr_item .
          lst_e1edpt2-tdline = shift_left( lst_e1edpt2-tdline ).
          lst_edidd-hlevel = lc_l4.
          lst_edidd-segnam = lc_e1edpt2.
          lst_edidd-sdata =  lst_e1edpt2.
          lv_index2_504 = lv_index2_504 + 1.
          INSERT lst_edidd INTO int_edidd INDEX lv_index2_504 .

          CLEAR: lst_e1edpt2, lst_edidd.
        ENDIF.
      ENDIF." IF line_exists( li_constants[ param1 = lc_VAT_I_FULL] ).
*---------------------------------------------------------------------
*    Additional or deduction amount including VAT Full tax rate.-KP07
*---------------------------------------------------------------------
      IF line_exists( li_constants[ param1 = lc_netval_i_fvat ] ).
        IF line_exists( li_mara_507[ matnr =  lst_e1edp01_507-matnr ] ) AND li_mara_507[ matnr =  lst_e1edp01_507-matnr ] EQ lv_pub_typ.
          CLEAR:lv_kbetr_item,lst_konv.
*          SUM all (KONV-KAWRT) where PUBTYPE="OP" for the respective line item (KONV-KPOSN).
          LOOP AT li_konv_vat INTO lst_konv WHERE kposn = lst_e1edp01_507-posex AND kbetr IS NOT INITIAL.
            lv_kawrt_item = lv_kawrt_item + lst_konv-kawrt.
          ENDLOOP.
          CLEAR:lst_edidd.
          lst_e1edpt1-tdid = li_constants[ param1 = lc_netval_i_fvat  ]-sap_value."Get Identifier from ZCAINTEG-MAPPING."KP07
          lst_e1edpt1-tsspras = sy-langu.
          lst_edidd-hlevel = lc_l3.
          lst_edidd-segnam = lc_e1edpt1.
          lst_edidd-sdata =  lst_e1edpt1.
          lv_index2_504 = lv_index2_504 + 1.
          INSERT lst_edidd INTO int_edidd INDEX lv_index2_504 .
          CLEAR: lst_e1edpt1, lst_edidd.

          lst_e1edpt2-tdline = lv_kawrt_item .
          lst_e1edpt2-tdline = shift_left( lst_e1edpt2-tdline ).
          lst_edidd-hlevel = lc_l4.
          lst_edidd-segnam = lc_e1edpt2.
          lst_edidd-sdata =  lst_e1edpt2.
          lv_index2_504 = lv_index2_504 + 1.
          INSERT lst_edidd INTO int_edidd INDEX lv_index2_504 .

          CLEAR: lst_e1edpt2, lst_edidd.
        ENDIF.
      ENDIF." IF line_exists( li_constants[ param1 = lc_add_ded_rvat ] ).
*---------------------------------------------------------------------
*Additional Quantity delivered-KP08
*---------------------------------------------------------------------
      IF line_exists( li_constants[ param1 = lc_add_quan_dlv ] ) AND line_exists(  li_constants[ param1 = lc_item_cat ] ).
        IF line_exists( xtvbdpr[ posnr = lst_e1edp01_507-posex ] ).
          IF  xtvbdpr[ posnr = lst_e1edp01_507-posex ]-pstyv =  li_constants[ param1 = lc_item_cat ]-sap_value.
            TRY.
                DATA(lv_fkimg) = xtvbdpr[ posnr = lst_e1edp01_507-posex ]-fkimg +" Main item quantity
                                 xtvbdpr[ posnr = xtvbdpr[ posnr = lst_e1edp01_507-posex ]-uepos ]-fkimg." Free item quantity

              CATCH cx_sy_itab_line_not_found.
            ENDTRY.
          ENDIF.
        ENDIF.
        CLEAR:lst_edidd.
        lst_e1edpt1-tdid = li_constants[ param1 = lc_add_quan_dlv ]-sap_value."Get Identifier from ZCAINTEG-MAPPING."KP02
        lst_e1edpt1-tsspras = sy-langu.
        lst_edidd-hlevel = lc_l3.
        lst_edidd-segnam = lc_e1edpt1.
        lst_edidd-sdata =  lst_e1edpt1.
        lv_index2_504 = lv_index2_504 + 1.
        INSERT lst_edidd INTO int_edidd INDEX lv_index2_504 .
        CLEAR: lst_e1edpt1, lst_edidd.

        lst_e1edpt2-tdline = lv_fkimg .
        lst_e1edpt2-tdline = shift_left( lst_e1edpt2-tdline ).
        lst_edidd-hlevel = lc_l4.
        lst_edidd-segnam = lc_e1edpt2.
        lst_edidd-sdata =  lst_e1edpt2.
        lv_index2_504 = lv_index2_504 + 1.
        INSERT lst_edidd INTO int_edidd INDEX lv_index2_504 .

        CLEAR: lst_e1edpt2, lst_edidd,lv_fkimg.
      ENDIF.

    ENDIF."IF lv_index2_504 IS NOT INITIAL.

    CLEAR:lv_index2_504.
  ENDLOOP.
ENDIF.
CLEAR:lv_app_itext.
