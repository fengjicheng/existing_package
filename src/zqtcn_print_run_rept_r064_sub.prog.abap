*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_PRINT_RUN_REPT_R064
* PROGRAM DESCRIPTION: Print Run Report
* The Purpose of this Report is to show number of current
* open subscriptions, the estimated number of offline subscriptions
* un-renewed quantity of a perticular issue.
* DEVELOPER: Lucky Kodwani
* CREATION DATE:   2017-06-15
* OBJECT ID: R064
* TRANSPORT NUMBER(S): ED2K906725
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO:  ED2K907692
* REFERENCE NO:  ERP-3749
* DEVELOPER:  Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-08-04
* DESCRIPTION: To add the Distributot Purchase order number in the output
*              of the report and to fix selection screen validation errors.
*-------------------------------------------------------------------
* REVISION NO:  ED2K908417
* REFERENCE NO: ERP-4058
* DEVELOPER:  Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-09-06
* DESCRIPTION: Publication date check for Printer Quantity has been
* corrected. It was taking for less than todays date where as ideally
* it should have been for greter than todays date.
*-------------------------------------------------------------------
* REVISION NO:  ED2K908621
* REFERENCE NO: ERP-4619
* DEVELOPER:  Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-09-20
* DESCRIPTION: Deleted items check should be done at EKPO level instead
*              of EKKO.
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION NO:  ED1K909114
* REFERENCE NO: RITM0091088
* DEVELOPER:  Nikhilesh Palla (NPALLA)
* DATE:  11-Dec-2018
* DESCRIPTION: - Fix Conference Quantities displayed incorrectly.
*              - Fix Corrected Delition Indicator on select of EBAN.
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION NO:  ED1K912507
* REFERENCE NO: INC0327304
* DEVELOPER:    Nikhilesh Palla (NPALLA)
* DATE:         15-Dec-2020
* DESCRIPTION: - Updated logic for Sales Document Type ZCSS/ZOR
*-------------------------------------------------------------------

*&---------------------------------------------------------------------*
*&  Include           ZQTCN_PRINT_RUN_REPT_R064_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_GLOBAL_VARIABLES
*&---------------------------------------------------------------------*
*       Clear all the global variables
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM f_clear_global_variables .

  CLEAR:  i_constant[],
          i_final[],
          i_fcat[].
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_N_PROCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_n_process .

  DATA: li_mara           TYPE tt_mara,
        li_vbap           TYPE tt_vbap,
        li_mseg           TYPE tt_mseg,
        li_ekpo           TYPE tt_ekpo,
        li_eban           TYPE tt_eban,
        li_inven_recon    TYPE tt_inven_recon,
        li_cosp           TYPE tt_cosp,
        li_ref_mat        TYPE ztqtc_ref_material,
        li_vbap_sub       TYPE tt_vbap_sub,
        li_veda_sub       TYPE tt_veda_sub,
        li_jksesched      TYPE tt_jksesched,
        li_prntqty_golive TYPE tt_prnt_golive.

* Fetch Records being Created/Changed in Mara
  CLEAR li_mara[].
  PERFORM f_fetch_records_mara  CHANGING li_mara.


* Fetch the reference material
  IF p_month IS NOT INITIAL.
    PERFORM f_get_ref_material USING li_mara
                               CHANGING li_ref_mat
                                        li_prntqty_golive.
  ENDIF. " IF p_month IS NOT INITIAL

  CLEAR li_cosp[].
* Fetch the data from COSP table
  PERFORM f_fetch_records_cosp  USING li_mara
                                CHANGING li_cosp.

  CLEAR li_vbap[].
* Fetch the data from VBAP table
  PERFORM f_fetch_records_vbap_jks USING li_mara
                                        li_ref_mat
                               CHANGING li_vbap
                                        li_jksesched
                                        li_vbap_sub
                                        li_veda_sub.

  CLEAR li_mseg[].
* Fetch the data from MSEG table
  PERFORM f_fetch_records_mseg USING li_mara
                               CHANGING li_mseg.

  CLEAR li_inven_recon[].
* Fetch records from ZQTC_INVEN_RECON table
  PERFORM f_fetch_records_inven_recon USING li_mara
                                      CHANGING li_inven_recon.


  CLEAR li_ekpo[].
* Fetch records from EKPO table
  PERFORM f_fetch_records_ekpo USING li_mara
                               CHANGING li_ekpo.

  CLEAR li_eban[].
* Fetch records from EBAN Table
  PERFORM f_fetch_records_eban USING    li_mara
                               CHANGING li_eban.

* Populate final Table
  PERFORM f_populate_final USING li_mara
                                 li_cosp
                                 li_mseg
                                 li_inven_recon
                                 li_ekpo
                                 li_eban
                                 li_ref_mat
                                 li_jksesched
                                 li_vbap_sub
                                 li_veda_sub
                                 li_prntqty_golive
                        CHANGING li_vbap
                                 i_final.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_RECORDS_MARA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LI_MARA  text
*----------------------------------------------------------------------*
FORM f_fetch_records_mara  CHANGING fp_li_mara TYPE tt_mara.


  SELECT  mara~matnr               " Material number
          mara~mtart               "Material type
          mara~ismhierarchlevl     " Hierarchy Level
          mara~ismrefmdprod        " Higher-Level Media Product
          mara~ismmediatype        " Media Type
          mara~ismpubldate         " Publication Date
          mara~ismyearnr           " Media issue year number
          mara~isminitshipdate     " Shipping Date
          jptidcdassign~idcodetype " Type of Identification Code
          jptidcdassign~identcode  " Identification Code
          prps~pspnr               " WBS Element
          prps~posid               " Work Breakdown Structure Element (WBS Element)
          prps~objnr               " Object number
          prps~pkokr               " Controlling area for WBS element
          prps~kostl               " Cost center to which costs are actually posted
    FROM mara INNER JOIN      jptidcdassign ON mara~matnr EQ jptidcdassign~matnr
              LEFT OUTER JOIN prps          ON mara~matnr EQ prps~zzmpm
    INTO TABLE fp_li_mara
    WHERE ( mara~matnr IN s_matnr
     AND mara~matnr NOT LIKE '%_TEMP%' )
    AND mara~mtart   = p_mtart
    AND mara~ismrefmdprod IN s_medprd
    AND mara~ismpubldate  IN s_publdt
    AND mara~ismyearnr    IN s_pubyr
    AND jptidcdassign~idcodetype = p_itype.
  IF sy-subrc NE 0.
    MESSAGE  s204(zqtc_r2) DISPLAY LIKE 'I'. " Data not found.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
**&---------------------------------------------------------------------*
**&      Form  F_FETCH_RECORDS_COSP
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->P_LI_MARA  text
**      <--P_LI_COSP  text
**----------------------------------------------------------------------*
FORM f_fetch_records_cosp  USING    fp_li_mara TYPE tt_mara
                           CHANGING fp_li_cosp TYPE tt_cosp.

* TYPE DECLARATION
  TYPES : ltt_cost_elem TYPE RANGE OF kstar. " Cost Element

  DATA: li_mara       TYPE STANDARD TABLE OF ty_mara INITIAL SIZE 0,
        lir_cost_elem TYPE ltt_cost_elem,
        lst_cost_elem TYPE LINE OF ltt_cost_elem.

  CONSTANTS: lc_cost_elem TYPE rvari_vnam VALUE 'COST_ELEM'. " ABAP: Name of Variant Variable

  LOOP AT i_constant INTO DATA(lst_const).

    CASE lst_const-param1.

      WHEN lc_cost_elem.
        lst_cost_elem-sign    = lst_const-sign.
        lst_cost_elem-option  = lst_const-opti.
        lst_cost_elem-low     = lst_const-low.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lst_cost_elem-low
          IMPORTING
            output = lst_cost_elem-low.

        APPEND lst_cost_elem TO lir_cost_elem.
        CLEAR lst_cost_elem.
    ENDCASE.

  ENDLOOP. " LOOP AT i_constant INTO DATA(lst_const)

  li_mara[] = fp_li_mara[].
  SORT li_mara BY objnr.
  DELETE ADJACENT DUPLICATES FROM li_mara COMPARING objnr.

  IF li_mara IS NOT INITIAL.
    SELECT lednr  " Ledger for Controlling objects
           objnr  " Object number
           gjahr  " Fiscal Year
           wrttp  " Value Type
           versn  " Version
           kstar  " Cost Element
           hrkft  " CO key subnumber
           vrgng  " CO Business Transaction
           vbund  " Company ID of Trading Partner
           pargb  " Trading Partner's Business Area
           beknz  " Debit/credit indicator
           twaer  " Transaction Currency
           perbl  " Period block
           wtg001 " Total Value in Transaction Currency
           wtg002 " Total Value in Transaction Currency
           wtg003 " Total Value in Transaction Currency
           wtg004 " Total Value in Transaction Currency
           wtg005 " Total Value in Transaction Currency
           wtg006 " Total Value in Transaction Currency
           wtg007 " Total Value in Transaction Currency
           wtg008 " Total Value in Transaction Currency
           wtg009 " Total Value in Transaction Currency
           wtg010 " Total Value in Transaction Currency
           wtg011 " Total Value in Transaction Currency
           wtg012 " Total Value in Transaction Currency
           wtg013 " Total Value in Transaction Currency
           wtg014 " Total Value in Transaction Currency
           wtg015 " Total Value in Transaction Currency
           wtg016 " Total Value in Transaction Currency
      FROM cosp   " CO Object: Cost Totals for External Postings
      INTO TABLE fp_li_cosp
      FOR ALL ENTRIES IN li_mara
      WHERE objnr EQ li_mara-objnr
      AND   wrttp = p_wrttp
      AND   kstar IN lir_cost_elem.
    IF sy-subrc EQ 0.
      SORT fp_li_cosp BY objnr ASCENDING versn DESCENDING.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_mara IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_RECORDS_VBAP_JKS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_MARA  text
*      <--P_LI_VBAP  text
*----------------------------------------------------------------------*
FORM f_fetch_records_vbap_jks  USING    fp_li_mara      TYPE tt_mara
                                        fp_li_ref_mat   TYPE ztqtc_ref_material
                               CHANGING fp_li_vbap      TYPE tt_vbap
                                        fp_li_jksesched TYPE tt_jksesched
                                        fp_li_vbap_sub  TYPE tt_vbap_sub
                                        fp_li_veda_sub  TYPE tt_veda_sub.
  DATA: li_mara_temp TYPE tt_mara,
        li_vbap_temp TYPE tt_vbap.

  li_mara_temp[] = fp_li_mara[].

  LOOP AT fp_li_ref_mat INTO DATA(lst_ref_mat).
    APPEND INITIAL LINE TO li_mara_temp ASSIGNING FIELD-SYMBOL(<lst_mara>).
    <lst_mara>-matnr = lst_ref_mat-ref_material.
  ENDLOOP. " LOOP AT fp_li_ref_mat INTO DATA(lst_ref_mat)

  IF li_mara_temp IS NOT INITIAL.

    SELECT vbap~vbeln,  " Sales Document
           vbap~posnr,  " Sales Document Item
           vbap~matnr,  " Material Number
           vbap~pstyv,
           vbap~abgru,  " Reason for rejection of quotations and sales orders
           vbap~kwmeng, " Cumulative Order Quantity in Sales Units
           vbap~vgbel,
           vbap~vgpos,
           vbak~auart   " Sales Document Type
           FROM vbap INNER JOIN vbak   ON  vbap~vbeln = vbak~vbeln
           INTO TABLE @fp_li_vbap
           FOR ALL ENTRIES IN @li_mara_temp
           WHERE ( vbap~matnr  = @li_mara_temp-ismrefmdprod
                OR vbap~matnr = @li_mara_temp-matnr )
             AND vbtyp IN (@c_vbtyp_i, @c_vbtyp_c).
    IF sy-subrc EQ 0.
* SORT is done later.
    ENDIF. " IF sy-subrc EQ 0
    SELECT  a~vbeln                                                  " Sales and Distribution Document Number
            a~posnr                                                  " Item number of the SD document
            issue                                                    " Media Issue
            product                                                  " Media Product
            sequence                                                 " IS-M: Sequence
            quantity                                                 " Target quantity in sales units
      FROM jksesched AS a INNER JOIN vbak AS b ON  a~vbeln = b~vbeln " IS-M: Media Schedule Lines
      INTO TABLE fp_li_jksesched
      FOR ALL ENTRIES IN li_mara_temp
      WHERE a~issue = li_mara_temp-matnr
        AND b~vbtyp = c_vbtyp_g
        AND b~auart IN s_contyp.
    IF sy-subrc EQ 0.
      SORT fp_li_jksesched BY issue.

      SELECT vbeln    " Sales Document
             posnr    " Sales Document Item
             abgru    " Reason for rejection of quotations and sales orders
            INTO TABLE fp_li_vbap_sub
            FROM vbap " Sales Document: Item Data
         FOR ALL ENTRIES IN fp_li_jksesched
        WHERE vbeln = fp_li_jksesched-vbeln
          AND posnr = fp_li_jksesched-posnr
          AND abgru = space.
      IF sy-subrc EQ 0.
        SORT fp_li_vbap_sub BY vbeln posnr.
      ENDIF. " IF sy-subrc EQ 0
      SELECT vbeln   " Sales Document
             vposn   " Sales Document Item
             vkuegru " Reason for Cancellation of Contract
          INTO TABLE fp_li_veda_sub
          FROM veda  " Contract Data
       FOR ALL ENTRIES IN fp_li_jksesched
      WHERE vbeln = fp_li_jksesched-vbeln.
      IF sy-subrc EQ 0.
        SORT fp_li_veda_sub BY vbeln vposn.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_mara_temp IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_RECORDS_MSEG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_MARA  text
*      <--P_LI_MSEG  text
*----------------------------------------------------------------------*
FORM f_fetch_records_mseg  USING    fp_li_mara TYPE tt_mara
                           CHANGING fp_li_mseg TYPE tt_mseg.

  IF fp_li_mara[] IS NOT INITIAL.
    SELECT mblnr " Material Doc Number
           mjahr " Material Doc. Year
           zeile " Material Doc.Item
           bwart " Movement Type (Inventory Management)
           matnr " Material Number
           shkzg " Debit/Credit Indicator
           menge " Quantity
      FROM mseg  " Document Segment: Material
      INTO TABLE fp_li_mseg
      FOR ALL ENTRIES IN fp_li_mara
      WHERE bwart IN s_bwart
      AND matnr = fp_li_mara-matnr.
    IF sy-subrc EQ 0.
      SORT fp_li_mseg BY matnr.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_li_mara IS NOT INITIAL


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_RECORDS_INVEN_RECON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_MARA  text
*      <--P_LI_INVEN_RECON  text
*----------------------------------------------------------------------*
FORM f_fetch_records_inven_recon  USING    fp_li_mara TYPE tt_mara
                                  CHANGING fp_li_inven_recon TYPE tt_inven_recon.

  SELECT  zadjtyp                  " Adjustment Type
          matnr                    " Material Number
          zevent                   " Event
          zdate                    " Transactional date
          zseqno                   " Sequence Num
          zoffline                 " Offline Member Qty
          ismrefmdprod             " Higher-Level Media Product
          zfgrdat                  " First GR date
          zlgrdat                  " Last GR Date
    FROM  zqtc_inven_recon         " Table for Inventory Reconciliation Data
    INTO TABLE fp_li_inven_recon
    FOR ALL ENTRIES IN fp_li_mara
    WHERE zadjtyp      EQ p_adjtyp "c_adjtyp_jdr
      AND ismrefmdprod EQ fp_li_mara-ismrefmdprod.
  IF sy-subrc EQ 0.
    SORT fp_li_inven_recon BY ismrefmdprod zlgrdat DESCENDING zfgrdat DESCENDING matnr DESCENDING.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DEFAULTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_S_BWART[]  text
*----------------------------------------------------------------------*
FORM f_populate_defaults  CHANGING fp_s_bwart TYPE bwart_t_range. " Range for Movement Type

  APPEND INITIAL LINE TO fp_s_bwart ASSIGNING FIELD-SYMBOL(<lst_bwart>).
  <lst_bwart>-sign   = c_sign_incld.
  <lst_bwart>-option = c_opti_equal.
  <lst_bwart>-low    = c_movtyp_251.
  <lst_bwart>-high    = space.

  APPEND INITIAL LINE TO fp_s_bwart ASSIGNING <lst_bwart>.
  <lst_bwart>-sign   = c_sign_incld.
  <lst_bwart>-option = c_opti_equal.
  <lst_bwart>-low    = c_movtyp_252.
  <lst_bwart>-high    = space.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_RECORDS_EKPO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_MARA  text
*      <--P_LI_EKPO  text
*----------------------------------------------------------------------*
FORM f_fetch_records_ekpo  USING    fp_li_mara TYPE tt_mara
                           CHANGING fp_li_ekpo TYPE tt_ekpo.

  IF fp_li_mara IS NOT INITIAL.

    SELECT ekpo~ebeln                " Purchasing Document Number
           ekpo~ebelp                " Item Number of Purchasing Document
           ekpo~matnr                " Material Number
           ekpo~bednr                " Requirement Tracking Number
           ekpo~menge                " Purchase Order Quantity
           ekpo~pstyp                " Item Category in Purchasing Document
           ekpo~knttp                " Account Assignment Category
           ekpo~banfn                " Purchase Requisition Number
           ekpo~bnfpo                " Item Number of Purchase Requisition
           ekko~bsart                " Purchasing Document Type
      FROM ekpo INNER JOIN ekko ON ( ekpo~ebeln = ekko~ebeln )
      INTO TABLE fp_li_ekpo
      FOR ALL ENTRIES IN fp_li_mara
      WHERE ekpo~matnr = fp_li_mara-matnr
      AND ( ekpo~knttp = c_knttp_p  OR ekpo~knttp = c_knttp_x )
      AND ( ekko~bsart = c_bsart_nb OR ekko~bsart = c_bsart_znb )
* Begin of Change on 20-Sep-2017 by PBANDLAPAL for ERP-4619 : ED2K908621
*      AND ekko~loekz NE c_loekz_del. "L - Deletion Ind.
      AND ekpo~loekz NE c_loekz_del. "L - Deletion Ind.
* End of Change on 20-Sep-2017 by PBANDLAPAL for ERP-4619 : ED2K908621
    IF sy-subrc EQ 0.
      SORT fp_li_ekpo BY matnr knttp bsart pstyp.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_li_mara IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_screen.

* BOI: 04-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
  IF sy-ucomm = c_ucomm_onli OR sy-ucomm = c_ucomm_prin OR
     sy-ucomm = c_ucomm_sjob.
* EOI: 04-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
  IF  s_matnr AND s_medprd IS INITIAL.
    MESSAGE e181(zqtc_r2). " Please provide media issue or media product value.
  ELSEIF s_medprd IS NOT INITIAL.
    IF  s_pubyr IS INITIAL.
      MESSAGE e182(zqtc_r2). " Please provide publication year.
    ENDIF. " IF s_pubyr IS INITIAL
  ENDIF.
ENDIF.    "  BOI: 04-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_CONSTANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_constant.

* Get the constant values from ZCACONSTANT value.
  SELECT devid        "Development ID
         param1       "ABAP: Name of Variant Variable
         param2       "ABAP: Name of Variant Variable
         srno         "Current selection number
         sign         "ABAP: ID: I/E (include/exclude values)
         opti         "ABAP: Selection option (EQ/BT/CP/...)
         low          "Lower Value of Selection Condition
         high         "Upper Value of Selection Condition
     FROM zcaconstant "Wiley Application Constant Table
     INTO TABLE i_constant
     WHERE devid    = c_devid
     AND   activate = abap_true
    ORDER BY param1 param2.
  IF sy-subrc IS INITIAL.
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_FINAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_MARA  text
*      -->P_LI_COSP  text
*      -->P_LI_VBAP  text
*      -->P_LI_MSEG  text
*      -->P_LI_INVEN_RECON  text
*      -->P_LI_EKPO  text
*      <--P_I_FINAL  text
*----------------------------------------------------------------------*
FORM f_populate_final  USING    fp_li_mara        TYPE tt_mara
                                fp_li_cosp        TYPE tt_cosp
                                fp_li_mseg        TYPE tt_mseg
                                fp_li_inven_recon TYPE tt_inven_recon
                                fp_li_ekpo        TYPE tt_ekpo
                                fp_li_eban        TYPE tt_eban
                                fp_li_ref_mat     TYPE ztqtc_ref_material
                                fp_li_jksesched   TYPE tt_jksesched
                                fp_li_vbap_sub    TYPE tt_vbap_sub
                                fp_li_veda_sub    TYPE tt_veda_sub
                                fp_li_prntqty_golive TYPE tt_prnt_golive
                       CHANGING   fp_li_vbap      TYPE tt_vbap
                                 fp_i_final       TYPE tt_final.

* Local Internal Table Declaration
  DATA: li_vbap_sales      TYPE STANDARD TABLE OF ty_vbap INITIAL SIZE 0,
        li_ekpo_print      TYPE STANDARD TABLE OF ty_ekpo INITIAL SIZE 0,
* BOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
        li_ekpo_print_dis  TYPE STANDARD TABLE OF ty_ekpo INITIAL SIZE 0,
* EOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
        lv_wtg_amt         TYPE wertv8,
        lv_cosp_tabix      TYPE syst_tabix,
        lv_tot_budget      TYPE wertv8,
        lst_inv_recon      TYPE ty_inven_recon,
        li_inv_recon_tmp   TYPE tt_inven_recon,
        lst_jksesched      TYPE ty_jksesched,
        lst_vbap_sub       TYPE ty_vbap_sub,
        lst_veda_sub       TYPE ty_veda_sub,
        lst_prntqty_golive TYPE ty_prnt_golive.

* Local Constant Declaration
  CONSTANTS : lc_shkzg_s    TYPE shkzg      VALUE 'S',           " Debit/Credit Indicator
              lc_shkzg_h    TYPE shkzg      VALUE 'H',           " Debit/Credit Indicator
              lc_auart_zcss TYPE auart      VALUE 'ZCSS',        " Sales Document Type
              lc_auart_zor  TYPE auart      VALUE 'ZOR',         " Sales Document Type  "+INC0327304/ED1K912507
              lc_pr1_auart  TYPE rvari_vnam VALUE 'AUART_PSTYV', " ABAP: Name of Variant Variable
              lc_pr2_zcss   TYPE rvari_vnam VALUE 'ZCSS',        " ABAP: Name of Variant Variable
              lc_pr2_zor    TYPE rvari_vnam VALUE 'ZOR'.         " ABAP: Name of Variant Variable "+INC0327304/ED1K912507
* BOC: 15-Dec-2020 : NPALLA : INC0327304 : ED1K912507
  TYPES: ltt_pstvy     TYPE RANGE OF pstyv.
  DATA: lir_pstvy_zcss TYPE ltt_pstvy,
        lir_pstvy_zor  TYPE ltt_pstvy,
        lst_pstvy_zcss TYPE LINE OF ltt_pstvy,
        lst_pstvy_zor  TYPE LINE OF ltt_pstvy.

  LOOP AT i_constant INTO DATA(lst_const) WHERE param1 = lc_pr1_auart.
    CASE lst_const-param2.
      WHEN lc_auart_zcss.
        lst_pstvy_zcss-sign    = lst_const-sign.
        lst_pstvy_zcss-option  = lst_const-opti.
        lst_pstvy_zcss-low     = lst_const-low.
        lst_pstvy_zcss-high    = lst_const-high.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lst_pstvy_zcss-low
          IMPORTING
            output = lst_pstvy_zcss-low.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lst_pstvy_zcss-high
          IMPORTING
            output = lst_pstvy_zcss-high.
        APPEND lst_pstvy_zcss TO lir_pstvy_zcss.
        CLEAR lst_pstvy_zcss.
      WHEN lc_auart_zor.
        lst_pstvy_zor-sign    = lst_const-sign.
        lst_pstvy_zor-option  = lst_const-opti.
        lst_pstvy_zor-low     = lst_const-low.
        lst_pstvy_zor-high    = lst_const-high.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lst_pstvy_zor-low
          IMPORTING
            output = lst_pstvy_zor-low.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lst_pstvy_zor-high
          IMPORTING
            output = lst_pstvy_zor-high.
        APPEND lst_pstvy_zor TO lir_pstvy_zor.
        CLEAR lst_pstvy_zor.
    ENDCASE.
  ENDLOOP. " LOOP AT i_constant INTO DATA(lst_const)
* EOC: 15-Dec-2020 : NPALLA : INC0327304 : ED1K912507

  SORT fp_li_vbap_sub BY vbeln posnr.
  SORT fp_li_veda_sub BY vbeln vposn.

  li_vbap_sales[] = fp_li_vbap[].
* Exclude the orders types which has been entered on selection screen
  DELETE li_vbap_sales WHERE auart IN s_doctyp.

* Cancelled / Rejected Contract should be ignored
  DELETE li_vbap_sales WHERE abgru IS NOT INITIAL.

  SORT li_vbap_sales BY matnr.

* Cancelled / Rejected Contract should be ignored
  DELETE fp_li_vbap WHERE abgru IS NOT INITIAL.

* Get only those records where BANFN(Purchase Requ)
  li_ekpo_print[] = fp_li_ekpo[].
  DELETE li_ekpo_print WHERE banfn IS INITIAL.

* BOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
  li_ekpo_print_dis[] = li_ekpo_print[].
  DELETE li_ekpo_print_dis WHERE knttp NE c_knttp_p OR
                                 bsart NE c_bsart_nb.
  SORT li_ekpo_print_dis by matnr ebeln DESCENDING.
* EOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692

  li_inv_recon_tmp[] =   fp_li_inven_recon[].
  SORT li_inv_recon_tmp BY matnr.

  LOOP AT fp_li_mara INTO DATA(lst_mara).

    APPEND INITIAL LINE TO fp_i_final ASSIGNING FIELD-SYMBOL(<lst_final>).
* Media Issue
    <lst_final>-matnr       = lst_mara-matnr.

*	Journal Group Code
    <lst_final>-identcode  = lst_mara-identcode.

* Publication Date
    <lst_final>-ismpubldate = lst_mara-ismpubldate.

* Initial Shipping Date
    <lst_final>-isminitshipdate  = lst_mara-isminitshipdate.

* Budget Value
    READ TABLE fp_li_cosp TRANSPORTING NO FIELDS WITH KEY objnr = lst_mara-objnr
                                                           BINARY SEARCH.
    IF sy-subrc EQ 0.
      lv_cosp_tabix = sy-tabix.
      LOOP AT fp_li_cosp INTO DATA(lst_cosp) FROM lv_cosp_tabix.
        IF lst_cosp-objnr NE lst_mara-objnr.
          EXIT.
        ENDIF.
        lv_wtg_amt  = lst_cosp-wtg001 + lst_cosp-wtg002 + lst_cosp-wtg003 + lst_cosp-wtg004
                            + lst_cosp-wtg005 + lst_cosp-wtg006 + lst_cosp-wtg007 + lst_cosp-wtg008
                            + lst_cosp-wtg009 + lst_cosp-wtg010 + lst_cosp-wtg011 + lst_cosp-wtg012
                            + lst_cosp-wtg013 + lst_cosp-wtg014 + lst_cosp-wtg015 + lst_cosp-wtg016.
        lv_tot_budget = lv_wtg_amt + lv_tot_budget.
* Budget Currency
        <lst_final>-bud_curr = lst_cosp-twaer.
        CLEAR lv_wtg_amt.
      ENDLOOP.
      <lst_final>-budget = lv_tot_budget.
      CLEAR:  lv_tot_budget,
              lv_cosp_tabix.
    ENDIF. " IF sy-subrc EQ 0

* Subscription Qty
* Sum all the quantity for one media issue from table jksesched~quantity
    READ TABLE fp_li_jksesched TRANSPORTING NO FIELDS WITH KEY issue = lst_mara-matnr
                                                      BINARY SEARCH.
    IF sy-subrc EQ 0.
      DATA(lv_jks_index) = sy-tabix.
      LOOP AT fp_li_jksesched INTO lst_jksesched FROM lv_jks_index.
        IF lst_jksesched-issue <> lst_mara-matnr.
          EXIT.
        ENDIF. " IF lst_jksesched-issue <> lst_mara-matnr
        CLEAR lst_vbap_sub.
        READ TABLE fp_li_vbap_sub INTO lst_vbap_sub WITH KEY vbeln = lst_jksesched-vbeln
                                                             posnr = lst_jksesched-posnr.
        IF sy-subrc EQ 0. "AND lst_vbap_sub-abgru IS NOT INITIAL.
          CLEAR lst_veda_sub.
          READ TABLE fp_li_veda_sub INTO lst_veda_sub WITH KEY vbeln = lst_jksesched-vbeln
                                                               vposn = lst_jksesched-posnr.
          IF sy-subrc EQ 0 AND lst_veda_sub-vkuegru IS NOT INITIAL.
            CONTINUE.
          ELSE. " ELSE -> IF sy-subrc EQ 0 AND lst_veda_sub-vkuegru IS NOT INITIAL
            CLEAR lst_veda_sub.
            READ TABLE fp_li_veda_sub INTO lst_veda_sub WITH KEY vbeln   = lst_jksesched-vbeln
                                                                 vposn   = space.
            IF sy-subrc EQ 0 AND lst_veda_sub-vkuegru IS NOT INITIAL.
              CONTINUE.
            ENDIF. " IF sy-subrc EQ 0 AND lst_veda_sub-vkuegru IS NOT INITIAL
          ENDIF. " IF sy-subrc EQ 0 AND lst_veda_sub-vkuegru IS NOT INITIAL
        ELSE. " ELSE -> IF sy-subrc EQ 0
          CONTINUE.
        ENDIF. " IF sy-subrc EQ 0
        <lst_final>-sub_qty  = <lst_final>-sub_qty + lst_jksesched-quantity.
      ENDLOOP. " LOOP AT fp_li_jksesched INTO lst_jksesched FROM lv_jks_index
    ENDIF. " IF sy-subrc EQ 0

* Sales Order Quantity
    READ TABLE li_vbap_sales TRANSPORTING NO FIELDS WITH KEY matnr = lst_mara-matnr
                                                      BINARY SEARCH.
    IF sy-subrc EQ 0.
      DATA(lv_sales_index) = sy-tabix.
      LOOP AT li_vbap_sales INTO DATA(lst_vbap_sales) FROM lv_sales_index.
        IF lst_vbap_sales-matnr <> lst_mara-matnr.
          EXIT.
        ENDIF. " IF lst_vbap_sales-matnr <> lst_mara-matnr
        IF lst_vbap_sales-auart = lc_auart_zcss.
* BOC: 15-Dec-2020 : NPALLA : INC0327304 : ED1K912507
*          READ TABLE i_constant INTO DATA(lst_constant) WITH KEY  param1 = lc_pr1_auart  "'AUART_PSTYV'
*                                                                  param2 = lc_pr2_zcss . "'ZCSS' .
*          IF sy-subrc EQ 0.
*            IF lst_vbap_sales-pstyv     = lst_constant-low.
*              <lst_final>-sal_qty   = <lst_final>-sal_qty  + lst_vbap_sales-kwmeng.
*            ENDIF. " IF lst_vbap_sales-pstyv = lst_constant-low
*          ENDIF. " IF sy-subrc EQ 0
          IF lst_vbap_sales-pstyv IN lir_pstvy_zcss[].
            <lst_final>-sal_qty   = <lst_final>-sal_qty  + lst_vbap_sales-kwmeng.
          ENDIF. " IF lst_vbap_sales-pstyv IN lir_pstvy_zcss[].
        ELSEIF lst_vbap_sales-auart = lc_auart_zor.
          IF lst_vbap_sales-pstyv IN lir_pstvy_zor[].
            <lst_final>-sal_qty   = <lst_final>-sal_qty  + lst_vbap_sales-kwmeng.
          ENDIF. " IF lst_vbap_sales-pstyv IN lir_pstvy_zor[].
* EOC: 15-Dec-2020 : NPALLA : INC0327304 : ED1K912507
        ELSE. " ELSE -> IF lst_vbap_sales-auart = lc_auart_zcss
          <lst_final>-sal_qty   = <lst_final>-sal_qty  + lst_vbap_sales-kwmeng.
        ENDIF. " IF lst_vbap_sales-auart = lc_auart_zcss
      ENDLOOP. " LOOP AT li_vbap_sales INTO DATA(lst_vbap_sales) FROM lv_sales_index
    ENDIF. " IF sy-subrc EQ 0

* Offline Quantity
    IF lst_mara-isminitshipdate LT sy-datum.
      READ TABLE fp_li_mseg TRANSPORTING NO FIELDS WITH KEY matnr = lst_mara-matnr
                                                           BINARY SEARCH.
      IF sy-subrc EQ 0.
        DATA(lv_index_mseg) = sy-tabix.
        LOOP AT fp_li_mseg INTO DATA(lst_mseg) FROM lv_index_mseg.
          IF lst_mseg-matnr <>  lst_mara-matnr.
            EXIT.
          ENDIF. " IF lst_mseg-matnr <> lst_mara-matnr
          IF lst_mseg-shkzg = lc_shkzg_s.
            <lst_final>-off_qty = <lst_final>-off_qty - lst_mseg-menge.
          ELSEIF lst_mseg-shkzg = lc_shkzg_h.
            <lst_final>-off_qty = <lst_final>-off_qty + lst_mseg-menge.
          ENDIF. " IF lst_mseg-shkzg = lc_shkzg_s
        ENDLOOP. " LOOP AT fp_li_mseg INTO DATA(lst_mseg) FROM lv_index_mseg
      ENDIF. " ELSE -> IF sy-subrc EQ 0
    ELSE.
      READ TABLE fp_li_inven_recon INTO lst_inv_recon WITH KEY ismrefmdprod = lst_mara-ismrefmdprod
                                                                   BINARY SEARCH .
      IF sy-subrc EQ 0.
        DATA(lv_recon_index) = sy-tabix.
        READ TABLE li_inv_recon_tmp TRANSPORTING NO FIELDS WITH KEY matnr = lst_inv_recon-matnr.
        IF sy-subrc EQ 0.
          LOOP AT fp_li_inven_recon INTO DATA(lst_recon) FROM lv_recon_index
                                             WHERE matnr = lst_inv_recon-matnr.
            <lst_final>-off_qty = <lst_final>-off_qty + lst_recon-zoffline.
          ENDLOOP. " LOOP AT fp_li_inven_recon INTO DATA(lst_recon) FROM lv_recon_index
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0

* Reference Material and Previous Year Subscription Qty.
    READ TABLE fp_li_prntqty_golive INTO lst_prntqty_golive
                                      WITH KEY media_prd = lst_mara-ismrefmdprod.
    IF sy-subrc EQ 0.
      <lst_final>-ref_mat   = lst_prntqty_golive-media_prd.
      <lst_final>-preyr_qty =  lst_prntqty_golive-menge.
    ELSE.
      READ TABLE fp_li_ref_mat INTO DATA(lst_ref_mat) WITH KEY matnr = lst_mara-matnr
                                                     BINARY SEARCH.
      IF sy-subrc EQ 0.
        <lst_final>-ref_mat = lst_ref_mat-ref_material.

* Previous Year subscription * Sum all the quantity for one media issue from table jksesched~quantity
        READ TABLE fp_li_jksesched TRANSPORTING NO FIELDS WITH KEY issue = lst_ref_mat-ref_material
                                                             BINARY SEARCH.
        IF sy-subrc EQ 0.
          DATA(lv_jks_refmat_index) = sy-tabix.
          LOOP AT fp_li_jksesched INTO lst_jksesched FROM lv_jks_refmat_index.
            IF lst_jksesched-issue <> lst_ref_mat-ref_material.
              EXIT.
            ENDIF. " IF lst_jksesched-issue <> lst_ref_mat-ref_material
            CLEAR lst_vbap_sub.
            READ TABLE fp_li_vbap_sub INTO lst_vbap_sub WITH KEY vbeln = lst_jksesched-vbeln
                                                                 posnr = lst_jksesched-posnr.
            IF sy-subrc EQ 0. "AND lst_vbap_sub-abgru IS NOT INITIAL.
              CLEAR lst_veda_sub.
              READ TABLE fp_li_veda_sub INTO lst_veda_sub WITH KEY vbeln = lst_jksesched-vbeln
                                                                   vposn = lst_jksesched-posnr.
              IF sy-subrc EQ 0 AND lst_veda_sub-vkuegru IS NOT INITIAL.
                CONTINUE.
              ELSE. " ELSE -> IF sy-subrc EQ 0 AND lst_veda_sub-vkuegru IS NOT INITIAL
                CLEAR lst_veda_sub.
                READ TABLE fp_li_veda_sub INTO lst_veda_sub WITH KEY vbeln   = lst_jksesched-vbeln
                                                                     vposn   = space.
                IF sy-subrc EQ 0 AND lst_veda_sub-vkuegru IS NOT INITIAL.
                  CONTINUE.
                ENDIF. " IF sy-subrc EQ 0 AND lst_veda_sub-vkuegru IS NOT INITIAL
              ENDIF. " IF sy-subrc EQ 0 AND lst_veda_sub-vkuegru IS NOT INITIAL
            ELSE. " ELSE -> IF sy-subrc EQ 0
              CONTINUE.
            ENDIF. " IF sy-subrc EQ 0
            <lst_final>-preyr_qty  = <lst_final>-preyr_qty + lst_jksesched-quantity.
          ENDLOOP. " LOOP AT fp_li_jksesched INTO lst_jksesched FROM lv_jks_refmat_index
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0

* Unrenewed Qty ( Previous Year qty - Subscription qty)
    <lst_final>-unrenew_qty = <lst_final>-preyr_qty - <lst_final>-sub_qty.

* If the quantity is negative then we want to display as zero.
    IF <lst_final>-unrenew_qty LT 0.
      <lst_final>-unrenew_qty = 0.
    ENDIF. " IF <lst_final>-unrenew_qty LT 0

* Printer Quantity

* BOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
*    IF lst_mara-ismpubldate LT sy-datum.
* EOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
      READ TABLE li_ekpo_print TRANSPORTING NO FIELDS WITH KEY matnr = lst_mara-matnr
                                                               knttp = c_knttp_p
                                                               bsart = c_bsart_nb "'NB'
                                                               BINARY SEARCH.
      IF sy-subrc EQ 0.
*	Published Media issue
        DATA(lv_index_print) = sy-tabix.

        LOOP AT li_ekpo_print INTO DATA(lst_ekpo) FROM lv_index_print.
          IF lst_ekpo-matnr EQ lst_mara-matnr
            AND lst_ekpo-knttp EQ c_knttp_p   "'P'
            AND lst_ekpo-bsart EQ c_bsart_nb. "'NB'.
            <lst_final>-print_qty  =   <lst_final>-print_qty + lst_ekpo-menge.
          ELSE. " ELSE -> IF lst_ekpo-matnr EQ lst_mara-matnr
            CONTINUE.
          ENDIF. " IF lst_ekpo-matnr EQ lst_mara-matnr

        ENDLOOP. " LOOP AT li_ekpo_print INTO DATA(lst_ekpo) FROM lv_index_print
        CLEAR lst_ekpo.
"BOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
         READ TABLE li_ekpo_print_dis INTO lst_ekpo WITH KEY matnr = lst_mara-matnr.
         IF sy-subrc EQ 0.
           <lst_final>-ebeln = lst_ekpo-ebeln.
         ENDIF.
*      ENDIF. " IF sy-subrc EQ 0
"EOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
    ELSE. " ELSE -> IF lst_mara-ismpubldate LT sy-datum

* Unpublished Media issue
* For new media issue, system will pick the printer quantity using following logic
*= Sum of Open Subscriptions + Open Sales Orders + Unrenewed + Offline
* BOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
* BOC: 06-Sep-2017 : PBANDLAPAL : ERP-4058 : ED2K908417
*    IF lst_mara-ismpubldate LT sy-datum.
    IF lst_mara-ismpubldate GT sy-datum.
* EOC: 06-Sep-2017 : PBANDLAPAL : ERP-4058 : ED2K908417
* EOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
      <lst_final>-print_qty = <lst_final>-sub_qty + <lst_final>-sal_qty +
                              <lst_final>-unrenew_qty + <lst_final>-off_qty.
    ENDIF. " IF lst_mara-ismpubldate LT sy-datum
ENDIF.  " BOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692

* Conference Quantity
    READ TABLE fp_li_eban TRANSPORTING NO FIELDS WITH KEY matnr = lst_mara-matnr
                                                       BINARY SEARCH.
    IF sy-subrc EQ 0.
      DATA(lv_index_eban) = sy-tabix.
* BOC: Commented 11-Dec-2018 : NPALLA : RITM0091088 : ED1K909114
*    ENDIF. " IF sy-subrc EQ 0    "--
* EOC: Commented 11-Dec-2018 : NPALLA : RITM0091088 : ED1K909114
    LOOP AT fp_li_eban INTO DATA(lst_eban) FROM lv_index_eban.
      IF lst_eban-matnr <> lst_mara-matnr.
        EXIT.
      ENDIF. " IF lst_eban-matnr <> lst_mara-matnr
      <lst_final>-conf_qty  =   <lst_final>-conf_qty + lst_eban-menge.
    ENDLOOP. " LOOP AT fp_li_eban INTO DATA(lst_eban) FROM lv_index_eban
* BOC: 11-Dec-2018 : NPALLA : RITM0091088 : ED1K909114
    ENDIF. " IF sy-subrc EQ 0     "++
* EOC: 11-Dec-2018 : NPALLA : RITM0091088 : ED1K909114

* Distributor Quantity
    READ TABLE fp_li_ekpo TRANSPORTING NO FIELDS WITH KEY   matnr = lst_mara-matnr
                                                            knttp = c_knttp_x   "'X'
                                                            bsart = c_bsart_znb "'ZNB'
                                                            pstyp = c_pstyp_5   "'5'
                                                            BINARY SEARCH .
    IF sy-subrc EQ 0.
      DATA(lv_index_dis) = sy-tabix.
      LOOP AT fp_li_ekpo INTO lst_ekpo FROM lv_index_dis.
        IF lst_ekpo-matnr <> lst_mara-matnr
          OR lst_ekpo-knttp <> c_knttp_x    "'X'
          OR lst_ekpo-bsart <> c_bsart_znb  "'ZNB'
          OR  lst_ekpo-pstyp <> c_pstyp_5 . "'5'.
          EXIT.
        ENDIF. " IF lst_ekpo-matnr <> lst_mara-matnr
        <lst_final>-distr_qty  = <lst_final>-distr_qty + lst_ekpo-menge.
      ENDLOOP. " LOOP AT fp_li_ekpo INTO lst_ekpo FROM lv_index_dis

    ENDIF. " IF sy-subrc EQ 0

  ENDLOOP. " LOOP AT fp_li_mara INTO DATA(lst_mara)

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_RECORDS_EBAN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_MARA  text
*      <--P_LI_EBAN  text
*----------------------------------------------------------------------*
FORM f_fetch_records_eban  USING    fp_li_mara TYPE tt_mara
                           CHANGING fp_li_eban TYPE tt_eban.
* BOC: 11-Dec-2018 : NPALLA : RITM0091088 : ED1K909114
  CONSTANTS: lc_loekz_del TYPE eloek VALUE 'X'.  "++
* EOC: 11-Dec-2018 : NPALLA : RITM0091088 : ED1K909114

  IF fp_li_mara IS NOT INITIAL.
    SELECT  banfn " Purchase Requisition Number
            bnfpo " Item Number of Purchase Requisition
            bsart " Purchase Requisition Document Type
            matnr " Material Number
            menge " Purchase Requisition Quantity
            meins " Purchase Requisition Unit of Measure
      FROM  eban  " Purchase Requisition
      INTO TABLE fp_li_eban
      FOR ALL ENTRIES IN fp_li_mara
      WHERE bsart = c_bsart_zcf
      AND matnr = fp_li_mara-matnr
* BOC: 11-Dec-2018 : NPALLA : RITM0091088 : ED1K909114
*      AND loekz NE c_loekz_del.  "--
      AND loekz NE lc_loekz_del.  "++
* EOC: 11-Dec-2018 : NPALLA : RITM0091088 : ED1K909114
    IF sy-subrc EQ 0.
* BOC: 11-Dec-2018 : NPALLA : RITM0091088 : ED1K909114
      SORT fp_li_eban BY matnr.   "++
* EOC: 11-Dec-2018 : NPALLA : RITM0091088 : ED1K909114
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_li_mara IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_alv .

  DATA: lst_layout   TYPE slis_layout_alv.

  CONSTANTS : lc_top_of_page TYPE slis_formname  VALUE 'F_TOP_OF_PAGE'.

  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.

  PERFORM f_popul_field_cat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = lc_top_of_page
      is_layout              = lst_layout
      it_fieldcat            = i_fcat
      i_save                 = abap_true
      i_default              = space
    TABLES
      t_outtab               = i_final
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_popul_field_cat .

  PERFORM f_append_field_cat USING:
  '1' 'I_FINAL'(T01)  'MATNR'       'Media Issue'(D01)            'MARA'     'MATNR',
  '2' 'I_FINAL'(T01)  'IDENTCODE'   'Journal Group'(D02)          ' ' ' ',
  '3' 'I_FINAL'(T01)  'ISMPUBLDATE' 'Publication Date'(D03)       ' ' ' ',
  '4' 'I_FINAL'(T01)  'ISMINITSHIPDATE' 'Initial Shipping Date'(D15)       ' ' ' ',
  '5' 'I_FINAL'(T01)  'BUDGET'      'Budget'(D04)                 ' ' ' ',
  '6' 'I_FINAL'(T01)  'BUD_CURR'    'Currency'(D05)               ' ' ' ',
  '7' 'I_FINAL'(T01)  'SUB_QTY'     'Subs Qty.'(D06)              ' ' ' ',
  '8' 'I_FINAL'(T01)  'SAL_QTY'     'Sales Qty'(D07)             ' ' ' ',
  '9' 'I_FINAL'(T01)  'OFF_QTY'     'offline Qty'(D08)            ' ' ' ',
  '10' 'I_FINAL'(T01)  'PREYR_QTY'   'Previous Year Qty'(D09)         ' ' ' ',
  '11' 'I_FINAL'(T01) 'PRINT_QTY'   'Printer Qty'(D10)        ' ' ' ',
  '1' 'I_FINAL'(T01) 'CONF_QTY'    'Conference Qty'(D11)        ' ' ' ',
  '13' 'I_FINAL'(T01) 'DISTR_QTY'   'Distributor Qty'(D12) ' ' ' ',
  '13' 'I_FINAL'(T01) 'UNRENEW_QTY' 'Unrenewed Qty'(D14) ' ' ' ',
* BOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
  '14' 'I_FINAL'(T01) 'EBELN'     'Purchase Order Number'(D16)   ' ' ' ',
* EOC: 02-Aug-2017 : PBANDLAPAL : ERP-3749 : ED2K907692
  '15' 'I_FINAL'(T01) 'REF_MAT'     'Ref Material'(D13)             ' ' ' '.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_APPEND_FIELD_CAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1350   text
*      -->P_1351   text
*      -->P_1352   text
*      -->P_1353   text
*      -->P_1354   text
*      -->P_1355   text
*----------------------------------------------------------------------*
FORM f_append_field_cat  USING    fp_col_pos
                                  fp_tabname
                                  fp_fieldname
                                  fp_reptext_ddic
                                  fp_ref_tabname
                                  fp_ref_fieldname.
  DATA: lst_fld TYPE slis_fieldcat_alv.

  CLEAR lst_fld.
  lst_fld-col_pos       = fp_col_pos.
  lst_fld-tabname       = fp_tabname.
  lst_fld-fieldname     = fp_fieldname.
  lst_fld-reptext_ddic  = fp_reptext_ddic.
  lst_fld-ref_tabname   = fp_ref_tabname.
  lst_fld-ref_fieldname = fp_ref_fieldname.

  APPEND lst_fld TO i_fcat.
  CLEAR : lst_fld.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_MONTH_YEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_month_year .

  CALL FUNCTION 'POPUP_TO_SELECT_MONTH'
    EXPORTING
      actual_month               = sy-datum+0(6)
    IMPORTING
      selected_month             = p_month
    EXCEPTIONS
      factory_calendar_not_found = 1
      holiday_calendar_not_found = 2
      month_not_found            = 3
      OTHERS                     = 4.
  IF sy-subrc <> 0.
* Do nothing
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_REF_MATERIAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_MARA  text
*      <--P_LI_REF_MAT  text
*----------------------------------------------------------------------*
FORM f_get_ref_material  USING    fp_li_mara    TYPE tt_mara
                         CHANGING fp_li_ref_mat TYPE ztqtc_ref_material
                                  fp_li_prntqty_golive TYPE tt_prnt_golive.

  DATA:  li_matnr TYPE dmf_t_matnr,
         lv_date  TYPE syst-datum. " ABAP System Field: Current Date of Application Server

  CONSTANTS: lc_first_date TYPE char2 VALUE '01'. " First_date of type CHAR2


  SELECT zperiod
         media_prd
         menge
         INTO TABLE fp_li_prntqty_golive
         FROM zqtc_prnt_golive
     WHERE zperiod = p_month.
  IF sy-subrc EQ 0.
    SORT fp_li_prntqty_golive BY zperiod media_prd.
  ELSE.
    CONCATENATE p_month
                lc_first_date
             INTO lv_date .

    MOVE-CORRESPONDING fp_li_mara TO li_matnr.

    CALL FUNCTION 'ZQTC_GET_REF_MATERIAL'
      EXPORTING
        im_t_material          = li_matnr
        im_v_in_date           = lv_date
        im_v_next_months       = 02
        im_v_back_months       = 03
      IMPORTING
        ex_t_ref_mat           = fp_li_ref_mat
      EXCEPTIONS
        invalid_material       = 1
        invalid_media_product  = 2
        no_media_product_found = 3
        no_data_found          = 4
        OTHERS                 = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF. " IF sy-subrc <> 0
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_top_of_page.
*ALV Header declarations

  DATA: li_header     TYPE slis_t_listheader,
        lst_header    TYPE slis_listheader,
        lv_line       TYPE slis_entry,
        lv_line_count TYPE i,      " Lines of type Integers
        lv_linesc     TYPE char10. " Linesc(10) of type Character

* Constant
  CONSTANTS :     lc_typ_h TYPE char1 VALUE 'H', " Typ_h of type CHAR1
                  lc_typ_s TYPE char1 VALUE 'S', " Typ_s of type CHAR1
                  lc_typ_a TYPE char1 VALUE 'A'. " Typ_a of type CHAR1
* TITLE
  lst_header-typ = lc_typ_h . "'H'
  lst_header-info = 'Print Run Report'(006).
  APPEND lst_header TO li_header.
  CLEAR lst_header.

* DATE
  lst_header-typ = lc_typ_s . "'S'
  lst_header-key = 'Date: '(004).
  WRITE sy-datum TO lst_header-info.
  APPEND lst_header TO li_header.
  CLEAR: lst_header.

* TOTAL NO. OF RECORDS SELECTED
  DESCRIBE TABLE i_final LINES lv_line_count.
  lv_linesc = lv_line_count.
  CONCATENATE 'Total No. of Records Selected: '(005) lv_linesc
  INTO lv_line SEPARATED BY space.
  lst_header-typ = lc_typ_a . "'A'
  lst_header-info = lv_line.
  APPEND lst_header TO li_header.
  CLEAR: lst_header, lv_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_header.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MATNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_MATNR[]  text
*----------------------------------------------------------------------*
FORM f_validate_matnr.

  SELECT matnr " Material Number
   FROM mara   " General Material Data
    UP TO 1 ROWS
    INTO @DATA(lv_matnr)
    WHERE matnr IN @s_matnr.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e176(zqtc_r2). " Invalid Material Number!
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MATTYP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_MTART  text
*----------------------------------------------------------------------*
FORM f_validate_mattyp  USING    fp_p_mtart TYPE mtart. " Structure for Range Table for Data Element MTART

  SELECT SINGLE mtart " Material Type
    FROM t134         " Material Types
    INTO @DATA(lv_mtart)
    WHERE mtart = @fp_p_mtart.
  IF  sy-subrc NE 0.
    MESSAGE e103(zqtc_r2). " Invalid Material Type!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PUBL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_publ.

  DATA : lv_valid TYPE flag . " General Flag
  LOOP AT s_pubyr .
    CALL FUNCTION 'VALIDATE_YEAR'
      EXPORTING
        i_year     = s_pubyr-low
      IMPORTING
        e_valid    = lv_valid
      EXCEPTIONS
        incomplete = 1
        OTHERS     = 2.
    IF sy-subrc <> 0.
* Do nothing
    ENDIF. " IF sy-subrc <> 0

    IF lv_valid IS INITIAL.
      MESSAGE e180(zqtc_r2). " Invalid Publication Year.
    ENDIF. " IF lv_valid IS INITIAL
  ENDLOOP. " LOOP AT s_pubyr
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_AUART
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_DOCTYP  text
*----------------------------------------------------------------------*
FORM f_validate_auart  USING    fp_s_doctyp TYPE fip_t_auart_range.

  SELECT auart " Sales Document Type
    FROM tvak  " Sales Document Types
    UP TO 1 ROWS
    INTO @DATA(lv_auart)
    WHERE auart IN @fp_s_doctyp.
  ENDSELECT.
  IF sy-subrc <> 0.
    MESSAGE e211(zqtc_r2). " Invalid Document Type!
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_ID_TYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_id_type .

  SELECT SINGLE ismidcodetype " Type of Identification Code
    FROM tjpidctyp            " Identification Code Types
    INTO @DATA(lv_id_type)
    WHERE ismidcodetype =  @p_itype.
  IF sy-subrc <> 0.
    MESSAGE e112(zqtc_r2). " Invalid Type of Identification Code!
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PERIOD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_period.
  SELECT zperiod INTO @DATA(lv_zperiod)
        FROM zqtc_prnt_golive UP TO 1 ROWS
        WHERE zperiod GT @p_month.
  ENDSELECT.
  IF sy-subrc EQ 0.
    p_month = lv_zperiod.
    MESSAGE i000(zqtc_r2) WITH 'Minimum period should be go-live'(T02).
  ENDIF.
ENDFORM.
