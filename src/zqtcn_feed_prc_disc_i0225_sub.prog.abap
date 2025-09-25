*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCN_FEED_PRC_DISC_I0225_SUB (Subroutines)
* PROGRAM DESCRIPTION: Feed Price and Discount Data from SAP
* DEVELOPER(S):        Writtick Roy
* CREATION DATE:       04/12/2017
* OBJECT ID:           I0225
* TRANSPORT NUMBER(S): ED2K904244
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904908
* REFERENCE NO:  CR# 490
* DEVELOPER: Writtick Roy
* DATE:  05/25/2017
* DESCRIPTION: 1. Update calculation logic for Librarian XLSX file to
* reflect list and net price (after ZSD1 discount/surcharge applied).
*              2. List Price should come from specific Condition table
* (A911 or A913) depending on Relationship Category from ZSD1
*              3. Populate 2 additional IDOC fields for Soceity Number
* and Relationship Category
*              4. Retrieve Material Text
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904908
* REFERENCE NO:  CR# 523
* DEVELOPER: Writtick Roy
* DATE:  06/22/2017
* DESCRIPTION: 1. Add All ISSNs in the XML / IDOC data (Print ISSN,
* Online ISSN, Print+Online ISSN)
*              2. Add Indicator for Multi-Journal Products
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904908, ED2K907257
* REFERENCE NO:  CR# 565
* DEVELOPER: Writtick Roy
* DATE:  07/08/2017
* DESCRIPTION: 1. Additional Exclusion Criteria - "Pricing Only" and
* "Pricing and Products".
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907393
* REFERENCE NO:  ERP-3367
* DEVELOPER: Writtick Roy
* DATE:  07/20/2017
* DESCRIPTION: 1. If a material is a component of a Multi Journal BOM,
* XML tag should say MJP = "true"
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907749
* REFERENCE NO:  CR# 627
* DEVELOPER: Writtick Roy
* DATE:  08/04/2017
* DESCRIPTION: 1. Populated Print and Online ISSNs for Multi-Media BOMs
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908248
* REFERENCE NO:  ERP-4096
* DEVELOPER: Writtick Roy
* DATE:  08/28/2017
* DESCRIPTION: 1. Use "&" as the separator between Journal components
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908472
* REFERENCE NO:  ERP-4385
* DEVELOPER: Writtick Roy
* DATE:  09/11/2017
* DESCRIPTION: 1. COLUMN02/03/04/05 of Z1PDM_COLHEAD should always be
* populated
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908487
* REFERENCE NO:  CR#652
* DEVELOPER: Writtick Roy
* DATE:  09/13/2017
* DESCRIPTION: 1. Introduce new Condition Table A974 (it will have
* similar functionality as with A913, but Customer Group will be
* defaulted to 01-Individual)
*              2. For records from A974, List Price will not be
* displayed; only Net Price (after Discounts) will be considered
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910638
* REFERENCE NO: ERP-5943
* DEVELOPER: Writtick Roy
* DATE:  02/01/2018
* DESCRIPTION: Fetch External Material Group for the BOM Components
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K910638
* REFERENCE NO: ERP-5943
* DEVELOPER: Writtick Roy
* DATE:  02/01/2018
* DESCRIPTION: Fetch External Material Group for the BOM Components
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED1K907103
* REFERENCE NO: INC0196170
* DEVELOPER: Sayantan Das (SAYANDAS)
* DATE:  05/24/2018
* DESCRIPTION: Incorrect MJP flag fix
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912264
* REFERENCE NO: ERP-6792
* DEVELOPER: Writtick Roy
* DATE:  06/11/2018
* DESCRIPTION: Membership Dues Table: Replace External Material Group
*              with Material Number
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912278
* REFERENCE NO:  CR#6341
* DEVELOPER: Rahul Tripathi
* DATE:  06/14/2018
* DESCRIPTION: Fetch Discounts from A950 and A951 Tables for cond type
*              ZMYS
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912466, ED2K912786
* REFERENCE NO:  ERP-6324
* DEVELOPER: Writtick Roy
* DATE:  06/28/2018
* DESCRIPTION: Librarian File - Include Components of Multi-Journal BOM
*              even when the Price is not maintained for the Component
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED1K908211
* REFERENCE NO: INC0207303
* DEVELOPER:    Himanshu Patel
* DATE:         08/16/2018
* DESCRIPTION:  JPS - XML - File: Society Name appears truncated.
*               All title fields should be used to populate BP Title.
*               NAME2 field added with NAME1, NAME3 for Society Name.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912794
* REFERENCE NO: CR-6735
* DEVELOPER: HIPATEL (Himanshu Patel)
* DATE:  07/26/2018
* DESCRIPTION: Librarian File -
*              1. Journal group code to be replaced by material number.
*              2. Sorting order change based on the material descriptio
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K912991
* REFERENCE NO: INC0207296
* DEVELOPER:    Siva Guda
* DATE:         08/21/2018
* DESCRIPTION:  Personal / Member JPS XML
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:   ED1K910672
* REFERENCE NO:  INC0252071
* DEVELOPER: Bharani (BTIRUVATHU)
* DATE:  15-July-2019
* DESCRIPTION: The excel Price Lists show the Volume and Issues for the
*              selected year.  It also shows whether there is an
*              increase or decrease in the number of issues.
*              The logic is counting Supplements as an issue
*              which results in providing incorrect number of issues
*              but also the text informing of Increase or Decrease
*              in the number of issues is misleading.
*              The Supplements should NOT be included in the count.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_PROCESS_DETAILS
*&---------------------------------------------------------------------*
*       Fetch required details
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_process_details .

  DATA:
    li_list_prc TYPE tt_list_prc,
    li_1d_scale TYPE tt_1d_scale,
    li_idcdasgn TYPE tt_idcdasgn,
    li_memb_due TYPE tt_memb_due,
    li_soc_name TYPE tt_soc_name,
    li_rel_catg TYPE tt_rel_catg,
    li_discount TYPE tt_discount,
    li_val_text TYPE tt_val_text, "CR6341 RTR20180614 ED2K912278
    li_m_rs_wm1 TYPE tt_mn_rs_wm,
    li_m_rc_sn1 TYPE tt_mn_rc_sn,
    li_m_sn_pt1 TYPE tt_mn_sn_pt,
    li_m_rltyp1 TYPE tt_mn_rltyp,
    li_m_prtyp1 TYPE tt_mn_prtyp,
    li_m_rs_wm2 TYPE tt_mn_rs_wm,
    li_m_rc_sn2 TYPE tt_mn_rc_sn,
    li_m_sn_pt2 TYPE tt_mn_sn_pt,
    li_m_rltyp2 TYPE tt_mn_rltyp,
    li_m_prtyp2 TYPE tt_mn_prtyp.
*   End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908

* Fetch Application Constants
  PERFORM f_fetch_constants  CHANGING i_constants.

* Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
* Read File Records
  PERFORM f_read_file_recs   CHANGING li_m_rs_wm1
                                      li_m_rc_sn1
                                      li_m_sn_pt1
                                      li_m_rltyp1
                                      li_m_prtyp1
                                      li_m_rs_wm2
                                      li_m_rc_sn2
                                      li_m_sn_pt2
                                      li_m_rltyp2
                                      li_m_prtyp2.
* End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908

* Fetch List Prices
  PERFORM f_fetch_list_price CHANGING li_list_prc
                                      li_1d_scale
                                      li_idcdasgn
* Begin of ADD:CR#627:WROY:04-AUG-2017:ED2K907749
                                      i_multi_med
* End   of ADD:CR#627:WROY:04-AUG-2017:ED2K907749
                                      i_bom_detls
                                      li_memb_due.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
*There should be no discounting on the Librarian excel.
  IF rb_jps_x EQ abap_true.
*   Fetch Discounts
    PERFORM f_fetch_discounts  CHANGING li_discount
                                        li_val_text. "CR6341 RTR20180614 ED2K912278
  ENDIF.
*EOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>

* Fetch Society Name
  PERFORM f_society_name     USING    li_list_prc
                                      li_discount
                             CHANGING li_soc_name
                                      li_rel_catg.

* Calculate Net Price
  PERFORM f_calculate_price  USING    li_list_prc
                                      li_1d_scale
                                      li_discount
                                      li_val_text "CR6341 RTR20180614 ED2K912278
                                      li_idcdasgn
                                      i_bom_detls
                                      li_soc_name
                                      li_rel_catg
                                      li_memb_due
* Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                                      li_m_rs_wm1
                                      li_m_rc_sn1
                                      li_m_sn_pt1
                                      li_m_rltyp1
                                      li_m_prtyp1
                                      li_m_rs_wm2
                                      li_m_rc_sn2
                                      li_m_sn_pt2
                                      li_m_rltyp2
                                      li_m_prtyp2
* End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                             CHANGING i_rep_lout.

* Begin by amohammed on 04/07/2020 - ERPM-6898 -  ED2K917960
* When XML radio button is choosen, delete the records with
* customer group equal to '01' and FTE is greater than '1'
  IF rb_jps_x IS NOT INITIAL.
    DELETE i_rep_lout WHERE kdgrp EQ '01' AND kstbm > '1'.
  ENDIF.
* End by amohammed on 04/07/2020 - ERPM-6898 -  ED2K917960

* Display Report
  PERFORM f_display_report   USING    i_rep_lout.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_LIST_PRICE
*&---------------------------------------------------------------------*
*       Fetch List Prices
*----------------------------------------------------------------------*
*      <--FP_LI_LIST_PRC  List Price
*      <--FP_LI_1D_SCALE  Scales
*      <--FP_LI_IDCDASGN  Assignment of ID Codes to Material
*      <--FP_LI_BOM_DETL  BOM Details
*----------------------------------------------------------------------*
FORM f_fetch_list_price  CHANGING fp_li_list_prc TYPE tt_list_prc
                                  fp_li_1d_scale TYPE tt_1d_scale
                                  fp_li_idcdasgn TYPE tt_idcdasgn
* Begin of ADD:CR#627:WROY:04-AUG-2017:ED2K907749
                                  fp_i_multi_med TYPE tt_mult_med
* End   of ADD:CR#627:WROY:04-AUG-2017:ED2K907749
                                  fp_li_bom_detl TYPE tt_bom_detl
                                  fp_li_memb_due TYPE tt_memb_due.

  DATA:
    li_list_prc TYPE tt_list_prc.

* Price list/Cust.group/RelCat/Soc Number/Material
  SELECT a~kappl        AS kappl,     "Application
         a~kschl        AS kschl,     "Condition type
         a~pltyp        AS pltyp,     "Price list type
         a~kdgrp        AS kdgrp,     "Customer group
         a~matnr        AS matnr,     "Material Number
         m~extwg        AS extwg,     "External Material Group
         m~mtart        AS mtart,     "Material Type
         m~mstae        AS mstae,     "Cross-Plant Material Status
         m~ismtitle     AS title,     "Title
         m~ismmediatype	AS mediatype, "Media Type
         k~maktx        AS maktx,     "Material Description (Short Text)
         a~kfrst        AS kfrst,     "Release status
         a~datbi        AS kodatbi,   "Validity end date of the condition record
         a~datab        AS kodatab,   "Validity start date of the condition record
         a~knumh        AS knumh,     "Condition record number
         p~kopos        AS kopos,     "Sequential number of the condition
         p~kbetr        AS kbetr,     "Rate (condition amount or percentage) where no scale exists
         p~konwa        AS konwa,     "Rate unit (currency or percentage)
*        Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*        p~knuma_ag     AS knuma_ag,                            "Sales deal
*        End   of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
         m~ismpubltype  AS publtype, "Publication Type
*        Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
         h~kosrt        AS kosrt, "Search term for conditions
         @c_wt_relat    AS kotab, "Condition table (A911)
*        End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
         a~zzreltyp     AS rltyp,    "Business Partner Relationship Category
         a~zzpartner2   AS soc_numbr "Business Partner 2 or Society number
    FROM a911 AS a          INNER JOIN
*        Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
         konh AS h
      ON h~knumh EQ a~knumh INNER JOIN
*        End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
         konp AS p
      ON p~knumh EQ a~knumh INNER JOIN
         mara AS m
      ON m~matnr EQ a~matnr INNER JOIN
         makt AS k
      ON k~matnr EQ a~matnr
      APPENDING TABLE @fp_li_list_prc
   WHERE a~kdgrp      IN @s_kdgrp  "Customer Group
     AND a~kschl      IN @s_kschlp "Condition Type (List Price)
     AND a~zzreltyp   IN @s_rltyp  "Relationship Category
     AND a~zzpartner2 IN @s_sc_no  "Society Number
     AND m~mstae      IN @s_mstae  "Material Status
     AND m~mtart      IN @s_mtarta "Material Type
     AND m~matnr      IN @s_matnr  "Material Number
     AND k~spras      EQ @sy-langu "Material Descriptions
     AND a~datbi      GE @p_prsdt  "Validity end date of the condition record
     AND a~datab      LE @p_prsdt. "Validity start date of the condition record
  IF sy-subrc NE 0.
*   Nothing to do
  ENDIF. " IF sy-subrc NE 0

* Price list/Cust.group/Material
  SELECT a~kappl        AS kappl,     "Application
         a~kschl        AS kschl,     "Condition type
         a~pltyp        AS pltyp,     "Price list type
         a~kdgrp        AS kdgrp,     "Customer group
         a~matnr        AS matnr,     "Material Number
         m~extwg        AS extwg,     "External Material Group
         m~mtart        AS mtart,     "Material Type
         m~mstae        AS mstae,     "Cross-Plant Material Status
         m~ismtitle     AS title,     "Title
         m~ismmediatype	AS mediatype, "Media Type
         k~maktx        AS maktx,     "Material Description (Short Text)
         a~kfrst        AS kfrst,     "Release status
         a~datbi        AS kodatbi,   "Validity end date of the condition record
         a~datab        AS kodatab,   "Validity start date of the condition record
         a~knumh        AS knumh,     "Condition record number
         p~kopos        AS kopos,     "Sequential number of the condition
         p~kbetr        AS kbetr,     "Rate (condition amount or percentage) where no scale exists
         p~konwa        AS konwa,     "Rate unit (currency or percentage)
*        Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*        p~knuma_ag     AS knuma_ag,                            "Sales deal
*        End   of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
         m~ismpubltype  AS publtype, "Publication Type
*        Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
         h~kosrt        AS kosrt, "Search term for conditions
         @c_wo_relat    AS kotab  "Condition table (A913)
*        End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    FROM a913 AS a          INNER JOIN
*        Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
         konh AS h
      ON h~knumh EQ a~knumh INNER JOIN
*        End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
         konp AS p
      ON p~knumh EQ a~knumh INNER JOIN
         mara AS m
      ON m~matnr EQ a~matnr INNER JOIN
         makt AS k
      ON k~matnr EQ a~matnr
     APPENDING TABLE @fp_li_list_prc
   WHERE a~kdgrp      IN @s_kdgrp  "Customer Group
     AND a~kschl      IN @s_kschlp "Condition Type (List Price)
     AND m~mstae      IN @s_mstae  "Material Status
     AND m~mtart      IN @s_mtarta "Material Type
     AND m~matnr      IN @s_matnr  "Material Number
     AND k~spras      EQ @sy-langu "Material Descriptions
     AND a~datbi      GE @p_prsdt  "Validity end date of the condition record
     AND a~datab      LE @p_prsdt. "Validity start date of the condition record
  IF sy-subrc NE 0.
*   Nothing to do
  ENDIF. " IF sy-subrc NE 0

* Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
* Price list/Material
  SELECT a~kappl        AS kappl,     "Application
         a~kschl        AS kschl,     "Condition type
         a~pltyp        AS pltyp,     "Price list type
         @c_kdgrp_ind   AS kdgrp,     "Customer group
         a~matnr        AS matnr,     "Material Number
         m~extwg        AS extwg,     "External Material Group
         m~mtart        AS mtart,     "Material Type
         m~mstae        AS mstae,     "Cross-Plant Material Status
         m~ismtitle     AS title,     "Title
         m~ismmediatype	AS mediatype, "Media Type
         k~maktx        AS maktx,     "Material Description (Short Text)
         a~kfrst        AS kfrst,     "Release status
         a~datbi        AS kodatbi,   "Validity end date of the condition record
         a~datab        AS kodatab,   "Validity start date of the condition record
         a~knumh        AS knumh,     "Condition record number
         p~kopos        AS kopos,     "Sequential number of the condition
         p~kbetr        AS kbetr,     "Rate (condition amount or percentage) where no scale exists
         p~konwa        AS konwa,     "Rate unit (currency or percentage)
         m~ismpubltype  AS publtype,  "Publication Type
         h~kosrt        AS kosrt,     "Search term for conditions
         @c_wo_no_lp    AS kotab      "Condition table (A974)
    FROM a974 AS a          INNER JOIN
         konh AS h
      ON h~knumh EQ a~knumh INNER JOIN
         konp AS p
      ON p~knumh EQ a~knumh INNER JOIN
         mara AS m
      ON m~matnr EQ a~matnr INNER JOIN
         makt AS k
      ON k~matnr EQ a~matnr
      INTO TABLE @li_list_prc
   WHERE a~kschl      IN @s_kschlp    "Condition Type (List Price)
     AND m~mstae      IN @s_mstae     "Material Status
     AND m~mtart      IN @s_mtarta    "Material Type
     AND m~matnr      IN @s_matnr     "Material Number
     AND k~spras      EQ @sy-langu    "Material Descriptions
     AND a~datbi      GE @p_prsdt     "Validity end date of the condition record
     AND a~datab      LE @p_prsdt.    "Validity start date of the condition record
  IF sy-subrc EQ 0.
    SORT fp_li_list_prc BY kappl kschl pltyp kdgrp matnr kotab.
*   Do not consider the Record, if already exists in table A913
    LOOP AT li_list_prc ASSIGNING FIELD-SYMBOL(<lst_list_prc>).
      READ TABLE fp_li_list_prc TRANSPORTING NO FIELDS
           WITH KEY kappl = <lst_list_prc>-kappl
                    kschl = <lst_list_prc>-kschl
                    pltyp = <lst_list_prc>-pltyp
                    kdgrp = <lst_list_prc>-kdgrp
                    matnr = <lst_list_prc>-matnr
                    kotab = c_wo_relat
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        CLEAR: <lst_list_prc>-kotab.
      ENDIF. " IF sy-subrc EQ 0
    ENDLOOP. " LOOP AT li_list_prc ASSIGNING FIELD-SYMBOL(<lst_list_prc>)
    DELETE li_list_prc WHERE kotab IS INITIAL.
    APPEND LINES OF li_list_prc TO fp_li_list_prc.
  ENDIF. " IF sy-subrc EQ 0
* End   of ADD:CR#652:WROY:13-SEP-2017:ED2K908487

* Begin of ADD:ERP-6324:WROY:28-JUN-2018:ED2K912466
  IF fp_li_list_prc IS NOT INITIAL.
    li_list_prc[] = fp_li_list_prc[].
    SORT li_list_prc BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_list_prc COMPARING matnr.
*   BOM details (Based on BOM Components)
    SELECT p~idnrk "BOM component
           t~stlnr "Bill of material
           t~matnr "Material Number
           m~extwg "External Material Group
           m~mtart "Material type
      FROM stpo AS p          INNER JOIN
           stas AS s
        ON s~stlty EQ p~stlty
       AND s~stlnr EQ p~stlnr
       AND s~stlkn EQ p~stlkn INNER JOIN
           mast AS t
        ON t~stlnr EQ s~stlnr
       AND t~stlal EQ s~stlal INNER JOIN
           mara AS m
        ON m~matnr EQ t~matnr
      INTO TABLE fp_li_bom_detl
       FOR ALL ENTRIES IN li_list_prc
     WHERE p~idnrk EQ li_list_prc-matnr
       AND t~stlan EQ c_bom_us_sd
       AND m~mtart IN s_mtartb.
    IF sy-subrc EQ 0.
      DELETE fp_li_bom_detl WHERE extwg IS INITIAL.
      SORT fp_li_bom_detl BY stlnr matnr_hdr idnrk.
    ENDIF. " IF sy-subrc EQ 0

*   BOM details (Based on BOM Header)
    SELECT p~idnrk "BOM component
           t~stlnr "Bill of material
           t~matnr "Material Number
           m~extwg "External Material Group
           m~mtart "Material type
      FROM mast AS t          INNER JOIN
           stas AS s
        ON s~stlnr EQ t~stlnr
       AND s~stlal EQ t~stlal INNER JOIN
           stpo AS p
        ON p~stlty EQ s~stlty
       AND p~stlnr EQ s~stlnr
       AND p~stlkn EQ s~stlkn INNER JOIN
           mara AS m
        ON m~matnr EQ t~matnr
  APPENDING TABLE fp_li_bom_detl
       FOR ALL ENTRIES IN li_list_prc
     WHERE t~matnr EQ li_list_prc-matnr
       AND t~stlan EQ c_bom_us_sd
       AND m~mtart IN s_mtartb.
    IF sy-subrc EQ 0.
      DELETE fp_li_bom_detl WHERE extwg IS INITIAL.
      SORT fp_li_bom_detl BY stlnr matnr_hdr idnrk.
    ENDIF. " IF sy-subrc EQ 0

    DELETE ADJACENT DUPLICATES FROM fp_li_bom_detl
                   COMPARING stlnr matnr_hdr idnrk.
    DATA(li_bom_detl) = fp_li_bom_detl.
    SORT li_bom_detl BY idnrk.
    DELETE ADJACENT DUPLICATES FROM li_bom_detl COMPARING idnrk.
*   Fetch External Material Group for the BOM Components
    SELECT matnr,                       "Material Number
           extwg,                       "External Material Group
           mtart,                       "Material Type
           mstae,                       "Cross-Plant Material Status
           ismtitle,                    "Title
           ismmediatype,                "Media Type
           ismpubltype                  "Publication Type
      FROM mara                         "General Material Data
      INTO TABLE @DATA(li_extwg_cmp)
       FOR ALL ENTRIES IN @li_bom_detl
     WHERE matnr EQ @li_bom_detl-idnrk. "BOM component
    IF sy-subrc EQ 0.
      SORT li_extwg_cmp BY matnr.
    ENDIF. " IF sy-subrc EQ 0
    LOOP AT fp_li_bom_detl ASSIGNING FIELD-SYMBOL(<lst_bom_detl>).
      READ TABLE li_extwg_cmp ASSIGNING FIELD-SYMBOL(<lst_extwg_cmp>)
           WITH KEY matnr = <lst_bom_detl>-idnrk
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        <lst_bom_detl>-extwg_cmp = <lst_extwg_cmp>-extwg.
      ENDIF. " IF sy-subrc EQ 0
    ENDLOOP. " LOOP AT fp_li_bom_detl ASSIGNING FIELD-SYMBOL(<lst_bom_detl>)
    SORT fp_li_bom_detl BY extwg_cmp extwg.
  ENDIF. " IF fp_li_list_prc IS NOT INITIAL

* Only applicable for Librarian XLSX
  IF rb_lib_e IS NOT INITIAL.
    li_bom_detl = fp_li_bom_detl.
    DELETE li_bom_detl WHERE mtart NOT IN s_mtartc. "Consider Multi-Journal BOMs only

    IF li_bom_detl IS NOT INITIAL.
*     Get the unique BOM Components
      SORT li_bom_detl BY idnrk.
      DELETE ADJACENT DUPLICATES FROM li_bom_detl
                COMPARING idnrk.

      LOOP AT li_bom_detl ASSIGNING <lst_bom_detl>.
*       Check if BOM Component has price maintained
        READ TABLE li_list_prc TRANSPORTING NO FIELDS
             WITH KEY matnr = <lst_bom_detl>-idnrk
             BINARY SEARCH.
        IF sy-subrc NE 0. "Price not maintained
*         Add an entry for the BOM Component with 0(Zero) Price
          APPEND INITIAL LINE TO fp_li_list_prc ASSIGNING <lst_list_prc>.
          <lst_list_prc>-kappl       = c_appl_sls. "Application (Sales/Distribution)
          <lst_list_prc>-kschl       = s_kschlp-low. "Condition type
          <lst_list_prc>-pltyp       = s_pltyp1-low. "Price list type
          <lst_list_prc>-kdgrp       = s_kdgrpi-low. "Customer group
          <lst_list_prc>-matnr       = <lst_bom_detl>-idnrk. "Material Number
          <lst_list_prc>-extwg       = <lst_bom_detl>-extwg_cmp. "External Material Group
          READ TABLE li_extwg_cmp ASSIGNING <lst_extwg_cmp>
               WITH KEY matnr = <lst_bom_detl>-idnrk
               BINARY SEARCH.
          IF sy-subrc EQ 0.
            <lst_list_prc>-mtart     = <lst_extwg_cmp>-mtart. "Material Type
            <lst_list_prc>-mstae     = <lst_extwg_cmp>-mstae. "Cross-Plant Material Status
            <lst_list_prc>-title     = <lst_extwg_cmp>-ismtitle. "Title
            <lst_list_prc>-mediatype = <lst_extwg_cmp>-ismmediatype. "Media Type
            <lst_list_prc>-publtype  = <lst_extwg_cmp>-ismpubltype. "Publication Type
          ENDIF. " IF sy-subrc EQ 0
          <lst_list_prc>-datbi = <lst_list_prc>-datab = p_prsdt. "Validity Dates
          <lst_list_prc>-datbi+4(4)  = '1231'. "Validity end date (Last Day of the Year)
          <lst_list_prc>-datab+4(4)  = '0101'. "Validity start date (First Day of the Year)
          <lst_list_prc>-konwa       = c_curr_usd. "Currency (USD)
          <lst_list_prc>-kosrt       = c_inst_rate. "Search term for conditions (Sales deal: Institutional)
          <lst_list_prc>-kotab       = c_wo_relat. "Condition Table (A913)
          <lst_list_prc>-excld_prc   = abap_true. "Exclude Pricing
          <lst_list_prc>-price_nm    = abap_true. "Price Not Maintained
        ENDIF. " IF sy-subrc NE 0
      ENDLOOP. " LOOP AT li_bom_detl ASSIGNING <lst_bom_detl>
    ENDIF. " IF li_bom_detl IS NOT INITIAL
  ENDIF. " IF rb_lib_e IS NOT INITIAL
* End   of ADD:ERP-6324:WROY:28-JUN-2018:ED2K912466

  LOOP AT fp_li_list_prc ASSIGNING <lst_list_prc>.
    CONCATENATE <lst_list_prc>-rltyp
                <lst_list_prc>-soc_numbr
           INTO <lst_list_prc>-reltyp_sn
      SEPARATED BY c_f_slash.

    IF <lst_list_prc>-mediatype IN s_mtypoo.
      <lst_list_prc>-level    = c_flg_srt_1.
      <lst_list_prc>-issn_lvl = c_flg_srt_2.
    ENDIF. " IF <lst_list_prc>-mediatype IN s_mtypoo
    IF <lst_list_prc>-mediatype IN s_mtypop.
      <lst_list_prc>-level    = c_flg_srt_2.
      <lst_list_prc>-issn_lvl = c_flg_srt_3.
    ENDIF. " IF <lst_list_prc>-mediatype IN s_mtypop
    IF <lst_list_prc>-mediatype IN s_mtyppo.
      <lst_list_prc>-level    = c_flg_srt_3.
      <lst_list_prc>-issn_lvl = c_flg_srt_1.
    ENDIF. " IF <lst_list_prc>-mediatype IN s_mtyppo
  ENDLOOP. " LOOP AT fp_li_list_prc ASSIGNING <lst_list_prc>
  DELETE fp_li_list_prc WHERE reltyp_sn NOT IN s_rc_sn.

  IF fp_li_list_prc IS NOT INITIAL.
    li_list_prc[] = fp_li_list_prc[].
    SORT li_list_prc BY knumh.
    DELETE ADJACENT DUPLICATES FROM li_list_prc COMPARING knumh.
*   Conditions (1-Dimensional Quantity Scale)
    SELECT knumh "Condition record number
           kopos "Sequential number of the condition
           klfn1 "Current number of the line scale
           kstbm "Condition scale quantity
           kbetr "Rate (condition amount or percentage)
      FROM konm  " Conditions (1-Dimensional Quantity Scale)
      INTO TABLE fp_li_1d_scale
       FOR ALL ENTRIES IN li_list_prc
     WHERE knumh EQ li_list_prc-knumh.
    IF sy-subrc EQ 0.
      IF rb_jps_x IS NOT INITIAL.
*       Sequence: LARGE --> MEDIUM --> SMALL
        SORT fp_li_1d_scale BY knumh ASCENDING
                               kstbm DESCENDING.
      ENDIF. " IF rb_jps_x IS NOT INITIAL
      IF rb_lib_e IS NOT INITIAL.
*       Sequence: SMALL --> MEDIUM --> LARGE
        SORT fp_li_1d_scale BY knumh ASCENDING
                               kstbm ASCENDING.
      ENDIF. " IF rb_lib_e IS NOT INITIAL
    ENDIF. " IF sy-subrc EQ 0

    li_list_prc[] = fp_li_list_prc[].
    SORT li_list_prc BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_list_prc COMPARING matnr.
*   IS-M: Assignment of ID Codes to Material
    SELECT matnr         "Material Number
           idcodetype    "Type of Identification Code
           identcode     "Identification Code
      FROM jptidcdassign " IS-M: Assignment of ID Codes to Material
      INTO TABLE fp_li_idcdasgn
       FOR ALL ENTRIES IN li_list_prc
     WHERE matnr      EQ li_list_prc-matnr
       AND idcodetype EQ p_idcdty
     ORDER BY PRIMARY KEY.
    IF sy-subrc NE 0.
*     Nothing to do
    ENDIF. " IF sy-subrc NE 0

*   Begin of DEL:ERP-6324:WROY:28-JUN-2018:ED2K912466
**  BOM details (Based on BOM Components)
*   SELECT p~idnrk "BOM component
*          t~stlnr "Bill of material
*          t~matnr "Material Number
*          m~extwg "External Material Group
*          m~mtart "Material type
*     FROM stpo AS p          INNER JOIN
*          stas AS s
*       ON s~stlty EQ p~stlty
*      AND s~stlnr EQ p~stlnr
*      AND s~stlkn EQ p~stlkn INNER JOIN
*          mast AS t
*       ON t~stlnr EQ s~stlnr
*      AND t~stlal EQ s~stlal INNER JOIN
*          mara AS m
*       ON m~matnr EQ t~matnr
*     INTO TABLE fp_li_bom_detl
*      FOR ALL ENTRIES IN li_list_prc
*    WHERE p~idnrk EQ li_list_prc-matnr
*      AND t~stlan EQ c_bom_us_sd
*      AND m~mtart IN s_mtartb.
*   IF sy-subrc EQ 0.
*     DELETE fp_li_bom_detl WHERE extwg IS INITIAL.
*     SORT fp_li_bom_detl BY stlnr matnr_hdr idnrk.
*   ENDIF. " IF sy-subrc EQ 0
*
**  BOM details (Based on BOM Header)
*   SELECT p~idnrk "BOM component
*          t~stlnr "Bill of material
*          t~matnr "Material Number
*          m~extwg "External Material Group
*          m~mtart "Material type
*     FROM mast AS t          INNER JOIN
*          stas AS s
*       ON s~stlnr EQ t~stlnr
*      AND s~stlal EQ t~stlal INNER JOIN
*          stpo AS p
*       ON p~stlty EQ s~stlty
*      AND p~stlnr EQ s~stlnr
*      AND p~stlkn EQ s~stlkn INNER JOIN
*          mara AS m
*       ON m~matnr EQ t~matnr
*APPENDING TABLE fp_li_bom_detl
*      FOR ALL ENTRIES IN li_list_prc
*    WHERE t~matnr EQ li_list_prc-matnr
*      AND t~stlan EQ c_bom_us_sd
*      AND m~mtart IN s_mtartb.
*   IF sy-subrc EQ 0.
*     DELETE fp_li_bom_detl WHERE extwg IS INITIAL.
*     SORT fp_li_bom_detl BY stlnr matnr_hdr idnrk.
*   ENDIF. " IF sy-subrc EQ 0
*
*   DELETE ADJACENT DUPLICATES FROM fp_li_bom_detl
*                  COMPARING stlnr matnr_hdr idnrk.
**  Begin of ADD:ERP-5943:WROY:01-Feb-2018:ED2K910638
*   DATA(li_bom_detl) = fp_li_bom_detl.
*   SORT li_bom_detl BY idnrk.
*   DELETE ADJACENT DUPLICATES FROM li_bom_detl COMPARING idnrk.
**  Fetch External Material Group for the BOM Components
*   SELECT matnr,                       "Material Number
*          extwg                        "External Material Group
*     FROM mara                         " General Material Data
*     INTO TABLE @DATA(li_extwg_cmp)
*      FOR ALL ENTRIES IN @li_bom_detl
*    WHERE matnr EQ @li_bom_detl-idnrk. "BOM component
*   IF sy-subrc EQ 0.
*     SORT li_extwg_cmp BY matnr.
*   ENDIF. " IF sy-subrc EQ 0
**  End   of ADD:ERP-5943:WROY:01-Feb-2018:ED2K910638
*   LOOP AT fp_li_bom_detl ASSIGNING FIELD-SYMBOL(<lst_bom_detl>).
**    Begin of DEL:ERP-5943:WROY:01-Feb-2018:ED2K910638
**    READ TABLE li_list_prc ASSIGNING <lst_list_prc>
**         WITH KEY matnr = <lst_bom_detl>-idnrk
**         BINARY SEARCH.
**    IF sy-subrc EQ 0.
**      <lst_bom_detl>-extwg_cmp = <lst_list_prc>-extwg.
**    ENDIF.
**    End   of DEL:ERP-5943:WROY:01-Feb-2018:ED2K910638
**    Begin of ADD:ERP-5943:WROY:01-Feb-2018:ED2K910638
*     READ TABLE li_extwg_cmp ASSIGNING FIELD-SYMBOL(<lst_extwg_cmp>)
*          WITH KEY matnr = <lst_bom_detl>-idnrk
*          BINARY SEARCH.
*     IF sy-subrc EQ 0.
*       <lst_bom_detl>-extwg_cmp = <lst_extwg_cmp>-extwg.
*     ENDIF. " IF sy-subrc EQ 0
**    End   of ADD:ERP-5943:WROY:01-Feb-2018:ED2K910638
*   ENDLOOP. " LOOP AT fp_li_bom_detl ASSIGNING FIELD-SYMBOL(<lst_bom_detl>)
*   SORT fp_li_bom_detl BY extwg_cmp extwg.
*   End   of DEL:ERP-6324:WROY:28-JUN-2018:ED2K912466

    li_list_prc[] = fp_li_list_prc[].
    SORT li_list_prc BY extwg.
    DELETE ADJACENT DUPLICATES FROM li_list_prc COMPARING extwg.
*  Memberships Dues
    SELECT extwg         "External Material Group
      FROM zqtc_memb_due " I0225: Memberships Dues
      INTO TABLE fp_li_memb_due
       FOR ALL ENTRIES IN li_list_prc
     WHERE extwg EQ li_list_prc-extwg
     ORDER BY PRIMARY KEY.
    IF sy-subrc NE 0.
*     Nothing to do
    ENDIF. " IF sy-subrc NE 0

*   Begin of ADD:CR#627:WROY:04-AUG-2017:ED2K907749
*   Fetch details for Multi-Media BOMs
    li_list_prc[] = fp_li_list_prc[].
    DELETE li_list_prc WHERE mtart NOT IN s_mtartb
                          OR mtart     IN s_mtartc.
    IF li_list_prc IS NOT INITIAL.
      SORT li_list_prc BY extwg.
      DELETE ADJACENT DUPLICATES FROM li_list_prc COMPARING extwg.
      SELECT m~matnr        AS matnr,     "Material Number
             m~extwg        AS extwg,     "External Material Group
             m~ismmediatype	AS mediatype, "Media Type
             i~idcodetype   AS idcodetyp, "Type of Identification Code
             i~identcode    AS identcode  "Identification Code
        FROM mara           AS m INNER JOIN
             jptidcdassign  AS i
          ON m~matnr EQ i~matnr
        INTO TABLE @fp_i_multi_med
         FOR ALL ENTRIES IN @li_list_prc
       WHERE m~extwg      EQ @li_list_prc-extwg
         AND i~idcodetype EQ @p_idcdty.
      IF sy-subrc EQ 0.
        LOOP AT fp_i_multi_med ASSIGNING FIELD-SYMBOL(<lst_mult_med>).
          IF <lst_mult_med>-mediatype IN s_mtypoo.
            <lst_mult_med>-issn_lvl = c_flg_srt_2.
          ENDIF. " IF <lst_mult_med>-mediatype IN s_mtypoo
          IF <lst_mult_med>-mediatype IN s_mtypop.
            <lst_mult_med>-issn_lvl = c_flg_srt_3.
          ENDIF. " IF <lst_mult_med>-mediatype IN s_mtypop
          IF <lst_mult_med>-mediatype IN s_mtyppo.
            <lst_mult_med>-issn_lvl = c_flg_srt_1.
          ENDIF. " IF <lst_mult_med>-mediatype IN s_mtyppo
        ENDLOOP. " LOOP AT fp_i_multi_med ASSIGNING FIELD-SYMBOL(<lst_mult_med>)
        SORT fp_i_multi_med BY extwg issn_lvl.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF li_list_prc IS NOT INITIAL
*   End   of ADD:CR#627:WROY:04-AUG-2017:ED2K907749
  ENDIF. " IF fp_li_list_prc IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DISCOUNTS
*&---------------------------------------------------------------------*
*       Fetch Discounts
*----------------------------------------------------------------------*
*      <--FP_LI_DISCOUNT  Discounts
*      <--FP_LI_VAL_TEXT  Validity period category text
*----------------------------------------------------------------------*
FORM f_fetch_discounts  CHANGING fp_li_discount TYPE tt_discount
                                 fp_li_val_text TYPE tt_val_text. "CR6341 RTR20180614 ED2K912278

* Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
* IF rb_lib_e IS NOT INITIAL.
*   RETURN.
* ENDIF.
* End   of DEL:CR#490:WROY:25-MAY-2017:ED2K904908

* Cust.group/RelCat/Soc Number/Material
  SELECT a~kappl          AS kappl,   "Application
         a~kschl          AS kschl,   "Condition type
         a~kdgrp          AS kdgrp,   "Customer group
         m~extwg          AS extwg,   "External Material Group
         a~kfrst          AS kfrst,   "Release status
         a~datbi          AS kodatbi, "Validity end date of the condition record
         a~datab          AS kodatab, "Validity start date of the condition record
         a~knumh          AS knumh,   "Condition record number
         p~kopos          AS kopos,   "Sequential number of the condition
         p~kbetr          AS kbetr,   "Rate (condition amount or percentage) where no scale exists
         p~konwa          AS konwa,   "Rate unit (currency or percentage)
*        Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*        p~knuma_ag       AS knuma_ag,                          "Sales deal
*        End   of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*        Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
         h~kosrt          AS kosrt, "Search term for conditions
*        End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908

         a~zzreltyp_sd1   AS rltyp,     "Business Partner Relationship Category
         a~zzpartner2_sd1 AS soc_numbr, "Business Partner 2 or Society number
         a~matnr          AS matnr      "Material Number
    FROM a937 AS a          INNER JOIN
*        Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
         konh AS h
      ON h~knumh EQ a~knumh INNER JOIN
*        End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
         konp AS p
      ON a~knumh EQ p~knumh INNER JOIN
         mara AS m
      ON a~matnr EQ m~matnr
      APPENDING TABLE @fp_li_discount
   WHERE a~kdgrp          IN @s_kdgrp  "Customer Group
     AND a~kschl          IN @s_kschld "Condition Type (Discount)
     AND a~zzreltyp_sd1   IN @s_rltyp  "Relationship Category
     AND a~zzpartner2_sd1 IN @s_sc_no  "Society Number
     AND m~mstae          IN @s_mstae  "Material Status
     AND m~mtart          IN @s_mtarta "Material Type
     AND a~datbi          GE @p_prsdt  "Validity end date of the condition record
     AND a~datab          LE @p_prsdt. "Validity start date of the condition record
  IF sy-subrc NE 0.
*   Nothing to do
  ENDIF. " IF sy-subrc NE 0

* Cust.group/RelCat/Soc Number/ExtMatlGrp
  SELECT a~kappl          AS kappl,   "Application
         a~kschl          AS kschl,   "Condition type
         a~kdgrp          AS kdgrp,   "Customer group
         a~extwg          AS extwg,   "External Material Group
         a~kfrst          AS kfrst,   "Release status
         a~datbi          AS kodatbi, "Validity end date of the condition record
         a~datab          AS kodatab, "Validity start date of the condition record
         a~knumh          AS knumh,   "Condition record number
         p~kopos          AS kopos,   "Sequential number of the condition
         p~kbetr          AS kbetr,   "Rate (condition amount or percentage) where no scale exists
         p~konwa          AS konwa,   "Rate unit (currency or percentage)
*        Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*        p~knuma_ag       AS knuma_ag,                          "Sales deal
*        End   of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*        Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
         h~kosrt          AS kosrt, "Search term for conditions
*        End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
         a~zzreltyp_sd1   AS rltyp,    "Business Partner Relationship Category
         a~zzpartner2_sd1 AS soc_numbr "Business Partner 2 or Society number
    FROM a923 AS a          INNER JOIN
*        Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
         konh AS h
      ON h~knumh EQ a~knumh INNER JOIN
*        End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
         konp AS p
      ON a~knumh EQ p~knumh
      APPENDING TABLE @fp_li_discount
   WHERE a~kdgrp          IN @s_kdgrp  "Customer Group
     AND a~kschl          IN @s_kschld "Condition Type (Discount)
     AND a~zzreltyp_sd1   IN @s_rltyp  "Relationship Category
     AND a~zzpartner2_sd1 IN @s_sc_no  "Society Number
     AND a~datbi          GE @p_prsdt  "Validity end date of the condition record
     AND a~datab          LE @p_prsdt. "Validity start date of the condition record
  IF sy-subrc NE 0.
*   Nothing to do
  ENDIF. " IF sy-subrc NE 0
**Begin of ADD:#CR6341 RTR20180614  ED2K912278
* Cust.group/RelCat/Soc Number/Val.categ./Material
  SELECT a~kappl          AS kappl,     "Application
         a~kschl          AS kschl,     "Condition type
         a~kdgrp          AS kdgrp,     "Customer group
         m~extwg          AS extwg,     "External Material Group
         a~kfrst          AS kfrst,     "Release Status
         a~datbi          AS kodatbi,   "Validity end date of the condition record
         a~datab          AS kodatab,   "Validity start date of the condition record
         a~knumh          AS knumh,     "Condition record number
         p~kopos          AS kopos,     "Sequential number of the condition
         p~kbetr          AS kbetr,     "Rate (condition amount or percentage) where no scale exists
         p~konwa          AS konwa,     "Rate unit (currency or percentage)
         h~kosrt          AS kosrt,     "Search term for conditions
         a~zzreltyp_mys   AS rltyp,     "Business Partner Relationship Category
         a~zzpartner2_mys AS soc_numbr, "Business Partner 2 or Society number
         a~matnr          AS matnr,     " Material
         a~zzvlaufk       AS vlauk_veda "Validity period category of contract
    FROM a950 AS a          INNER JOIN
         konh AS h
      ON h~knumh EQ a~knumh INNER JOIN
         konp AS p
      ON a~knumh EQ p~knumh INNER JOIN
         mara AS m
      ON a~matnr EQ m~matnr
      APPENDING TABLE @fp_li_discount
   WHERE a~kdgrp          IN @s_kdgrp   "Customer Group
     AND a~kschl          IN @s_kschld  "Condition Type (Discount)
     AND a~zzreltyp_mys   IN @s_rltyp   "Relationship Category
     AND a~zzpartner2_mys IN @s_sc_no   "Society Number
     AND a~datbi          GE @p_prsdt   "Validity end date of the condition record
     AND a~datab          LE @p_prsdt.
**END of ADD:CR#6341 RTR20180614  ED2K912278
  IF fp_li_discount IS NOT INITIAL.
*   Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*   SORT fp_li_discount BY kappl kdgrp extwg matnr.
*   Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
    LOOP AT fp_li_discount ASSIGNING FIELD-SYMBOL(<lst_discount>).
      CONCATENATE <lst_discount>-rltyp
                  <lst_discount>-soc_numbr
             INTO <lst_discount>-reltyp_sn
        SEPARATED BY c_f_slash.
*     Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
*     Check Condition Table from Application Constant table
*     WHEN ZSD1 = ZPR003, ZPR004, ZPR005, ZPR006, ZPR008 or ZPR010, ZLPR comes from A911 (WT_RELAT)
*     WHEN ZSD1 = ZPR001, ZPR002, ZPR007 or ZPR009, ZLPR comes from A913 (WO_RELAT)
      READ TABLE i_constants ASSIGNING FIELD-SYMBOL(<lst_constant>)
           WITH KEY param1 = c_param_cnt
                    param2 = <lst_discount>-rltyp
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        <lst_discount>-kotab = <lst_constant>-low.
      ENDIF. " IF sy-subrc EQ 0
*     End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    ENDLOOP. " LOOP AT fp_li_discount ASSIGNING FIELD-SYMBOL(<lst_discount>)
    DELETE fp_li_discount WHERE reltyp_sn NOT IN s_rc_sn.
*   Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    DELETE fp_li_discount WHERE kotab IS INITIAL.
    SORT fp_li_discount BY kotab kappl kdgrp extwg matnr soc_numbr rltyp.
*   End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
** Begin of ADD:CR#6341 RTR20180614 ED2K912278

    SELECT  a~kappl          AS kappl,    "Application
            a~kschl          AS kschl,    "Condition type
            a~kdgrp          AS kdgrp,    "Customer group
            m~extwg          AS extwg,    "External Material Group
            a~kfrst          AS kfrst,    "Release Status
            a~datbi,                      "Validity end date of the condition record
            a~datab,                      "Validity start date of the condition record
            a~knumh          AS knumh,    "Condition record number
            p~kopos          AS kopos,    "Sequential number of the condition
            p~kbetr          AS kbetr,    "Rate (condition amount or percentage) where no scale exists
            p~konwa          AS konwa,    "Rate unit (currency or percentage)
            h~kosrt          AS kosrt,    "Search term for conditions
            a~zzvlaufk       AS laufk,    "Validity period category of contract
            a~matnr          AS matnr     " Material
       FROM a951 AS a          INNER JOIN
            konh AS h
         ON h~knumh EQ a~knumh INNER JOIN
            konp AS p
         ON a~knumh EQ p~knumh INNER JOIN
            mara AS m
         ON a~matnr EQ m~matnr
         APPENDING CORRESPONDING FIELDS OF TABLE @fp_li_discount
      WHERE a~kdgrp          IN @s_kdgrp  "Customer Group
        AND a~kschl          IN @s_kschld "Condition Type (Discount)
        AND a~datbi          GE @p_prsdt  "Validity end date of the condition record
        AND a~datab          LE @p_prsdt.

    LOOP AT fp_li_discount ASSIGNING <lst_discount> WHERE rltyp IS INITIAL.
      <lst_discount>-kotab = c_wo_relat.
    ENDLOOP. " LOOP AT fp_li_discount ASSIGNING <lst_discount> WHERE rltyp IS INITIAL
** Fetch Validity desciption text for all valdity period
    SELECT spras  " Language Key
           vlaufk " Validity period category of contract
           bezei  " Description
       FROM tvlzt " Validity Period Category: Texts
       INTO TABLE fp_li_val_text
       FOR ALL ENTRIES IN fp_li_discount
       WHERE spras = sy-langu
         AND vlaufk = fp_li_discount-laufk.
** END of ADD:CR#6341 RTR20180614  ED2K912278
    SORT fp_li_discount BY kotab kappl kdgrp extwg matnr soc_numbr rltyp.

  ENDIF. " IF fp_li_discount IS NOT INITIAL




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALCULATE_PRICE
*&---------------------------------------------------------------------*
*       Calculate Net Price
*----------------------------------------------------------------------*
*      -->FP_LI_M_RC_SN1  Rel Cat/Soc No (With Material)
*      -->FP_LI_M_SN_PT1  Soc No/Prc Typ (With Material)
*      -->FP_LI_M_RLTYP1  Rel Category (With Material)
*      -->FP_LI_M_PRTYP1  Price Type (With Material)
*      -->FP_LI_M_RC_SN2  Rel Cat/Soc No (With Material)
*      -->FP_LI_M_SN_PT2  Soc No/Prc Typ (With Material)
*      -->FP_LI_M_RLTYP2  Rel Category (With Material)
*      -->FP_LI_M_PRTYP2  Price Type (With Material)
*      <--FP_LI_REP_LOUT  Report Layout
*----------------------------------------------------------------------*
FORM f_calculate_price USING    fp_li_list_prc TYPE tt_list_prc
                                fp_li_1d_scale TYPE tt_1d_scale
                                fp_li_discount TYPE tt_discount
                                fp_li_val_text TYPE tt_val_text "CR6341 RTR20180614 ED2K912278
                                fp_li_idcdasgn TYPE tt_idcdasgn
                                fp_li_bom_detl TYPE tt_bom_detl
                                fp_li_soc_name TYPE tt_soc_name
                                fp_li_rel_catg TYPE tt_rel_catg
                                fp_li_memb_due TYPE tt_memb_due
*                               Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                                fp_li_m_rs_wm1 TYPE tt_mn_rs_wm
                                fp_li_m_rc_sn1 TYPE tt_mn_rc_sn
                                fp_li_m_sn_pt1 TYPE tt_mn_sn_pt
                                fp_li_m_rltyp1 TYPE tt_mn_rltyp
                                fp_li_m_prtyp1 TYPE tt_mn_prtyp
                                fp_li_m_rs_wm2 TYPE tt_mn_rs_wm
                                fp_li_m_rc_sn2 TYPE tt_mn_rc_sn
                                fp_li_m_sn_pt2 TYPE tt_mn_sn_pt
                                fp_li_m_rltyp2 TYPE tt_mn_rltyp
                                fp_li_m_prtyp2 TYPE tt_mn_prtyp
*                               End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                       CHANGING fp_li_rep_lout TYPE tt_rep_lout.

  DATA:
    lst_1d_scale TYPE ty_1d_scale.

  DATA:
    li_bom_headr TYPE tt_bom_detl,
    li_bom_comp  TYPE tt_bom_detl.

  DATA:
    lv_line_scal TYPE klfn1. "Current number of the line scale

  li_bom_headr[] = fp_li_bom_detl[].
  li_bom_comp[]  = fp_li_bom_detl[].
  SORT: li_bom_headr BY matnr_hdr idnrk,
        li_bom_comp  BY idnrk matnr_hdr.
  DELETE ADJACENT DUPLICATES FROM:
        li_bom_headr COMPARING matnr_hdr idnrk,
        li_bom_comp  COMPARING idnrk matnr_hdr.

  LOOP AT fp_li_list_prc ASSIGNING FIELD-SYMBOL(<lst_list_prc>).
    CLEAR: lst_1d_scale,
           lv_line_scal.
    READ TABLE fp_li_1d_scale TRANSPORTING NO FIELDS
         WITH KEY knumh = <lst_list_prc>-knumh
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      LOOP AT fp_li_1d_scale INTO lst_1d_scale FROM sy-tabix.
        IF lst_1d_scale-knumh NE <lst_list_prc>-knumh.
          EXIT.
        ENDIF. " IF lst_1d_scale-knumh NE <lst_list_prc>-knumh
        lv_line_scal = lv_line_scal + 1.
        lst_1d_scale-line_scal = lv_line_scal.
*       Calculate Net Price
        PERFORM f_calc_net_price USING    <lst_list_prc>
                                          lst_1d_scale
                                          fp_li_discount
                                          fp_li_val_text "CR6341 RTR20180614 ED2K912278
                                          fp_li_idcdasgn
                                          li_bom_headr
                                          li_bom_comp
                                          fp_li_soc_name
                                          fp_li_rel_catg
                                          fp_li_memb_due
*                                         Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                                          fp_li_m_rs_wm1
                                          fp_li_m_rc_sn1
                                          fp_li_m_sn_pt1
                                          fp_li_m_rltyp1
                                          fp_li_m_prtyp1
                                          fp_li_m_rs_wm2
                                          fp_li_m_rc_sn2
                                          fp_li_m_sn_pt2
                                          fp_li_m_rltyp2
                                          fp_li_m_prtyp2
*                                         End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                                 CHANGING fp_li_rep_lout.
      ENDLOOP. " LOOP AT fp_li_1d_scale INTO lst_1d_scale FROM sy-tabix
    ELSE. " ELSE -> IF sy-subrc EQ 0
*     Calculate Net Price
      PERFORM f_calc_net_price USING    <lst_list_prc>
                                        lst_1d_scale
                                        fp_li_discount
                                        fp_li_val_text "CR6341 RTR20180614 ED2K912278
                                        fp_li_idcdasgn
                                        li_bom_headr
                                        li_bom_comp
                                        fp_li_soc_name
                                        fp_li_rel_catg
                                        fp_li_memb_due
*                                       Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                                        fp_li_m_rs_wm1
                                        fp_li_m_rc_sn1
                                        fp_li_m_sn_pt1
                                        fp_li_m_rltyp1
                                        fp_li_m_prtyp1
                                        fp_li_m_rs_wm2
                                        fp_li_m_rc_sn2
                                        fp_li_m_sn_pt2
                                        fp_li_m_rltyp2
                                        fp_li_m_prtyp2
*                                       End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                               CHANGING fp_li_rep_lout.
    ENDIF. " IF sy-subrc EQ 0
  ENDLOOP. " LOOP AT fp_li_list_prc ASSIGNING FIELD-SYMBOL(<lst_list_prc>)

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CALC_NET_PRICE
*&---------------------------------------------------------------------*
*       Calculate Net Price
*----------------------------------------------------------------------*
*      -->FP_LST_LIST_PRC  List Price
*      -->FP_LST_1D_SCALE  Scales
*      -->FP_LI_DISCOUNT   Discount
*      -->FP_LI_IDCDASGN   Assignment of ID Codes to Material
*      -->FP_LI_M_RC_SN1   Rel Cat/Soc No (With Material)
*      -->FP_LI_M_SN_PT1   Soc No/Prc Typ (With Material)
*      -->FP_LI_M_RLTYP1   Rel Category (With Material)
*      -->FP_LI_M_PRTYP1   Price Type (With Material)
*      -->FP_LI_M_RC_SN2   Rel Cat/Soc No (With Material)
*      -->FP_LI_M_SN_PT2   Soc No/Prc Typ (With Material)
*      -->FP_LI_M_RLTYP2   Rel Category (With Material)
*      -->FP_LI_M_PRTYP2   Price Type (With Material)
*      <--FP_LI_REP_LOUT   Report Layout
*----------------------------------------------------------------------*
FORM f_calc_net_price  USING    fp_lst_list_prc TYPE ty_list_prc
                                fp_lst_1d_scale TYPE ty_1d_scale
                                fp_li_discount  TYPE tt_discount
                                fp_li_val_text TYPE tt_val_text "CR6341 RTR20180614 ED2K912278
                                fp_li_idcdasgn  TYPE tt_idcdasgn
                                fp_li_bom_head  TYPE tt_bom_detl
                                fp_li_bom_comp  TYPE tt_bom_detl
                                fp_li_soc_name  TYPE tt_soc_name
                                fp_li_rel_catg  TYPE tt_rel_catg
                                fp_li_memb_due  TYPE tt_memb_due
*                               Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                                fp_li_m_rs_wm1  TYPE tt_mn_rs_wm
                                fp_li_m_rc_sn1  TYPE tt_mn_rc_sn
                                fp_li_m_sn_pt1  TYPE tt_mn_sn_pt
                                fp_li_m_rltyp1  TYPE tt_mn_rltyp
                                fp_li_m_prtyp1  TYPE tt_mn_prtyp
                                fp_li_m_rs_wm2  TYPE tt_mn_rs_wm
                                fp_li_m_rc_sn2  TYPE tt_mn_rc_sn
                                fp_li_m_sn_pt2  TYPE tt_mn_sn_pt
                                fp_li_m_rltyp2  TYPE tt_mn_rltyp
                                fp_li_m_prtyp2  TYPE tt_mn_prtyp
*                               End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                       CHANGING fp_li_rep_lout  TYPE tt_rep_lout.

* Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
  DATA:
    lv_kotab     TYPE kotab. "Condition table
* End   of ADD:CR#652:WROY:13-SEP-2017:ED2K908487

  DATA:
    lst_discount TYPE ty_discount,
    lst_val_text TYPE ty_val_text. "CR6341 RTR20180614 ED2K912278
* Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
  lv_kotab = fp_lst_list_prc-kotab.

  IF lv_kotab NE c_wo_no_lp.
* End   of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
*   Populate Report Layout (Without Discount)
    PERFORM f_populate_rep_lout USING    fp_lst_list_prc
                                         fp_lst_1d_scale
                                         lst_discount
                                         lst_val_text "CR6341 RTR20180614 ED2K912278
                                         fp_li_idcdasgn
                                         fp_li_bom_head
                                         fp_li_bom_comp
                                         fp_li_soc_name
                                         fp_li_rel_catg
                                         fp_li_memb_due
*                                        Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                                         fp_li_m_rs_wm1
                                         fp_li_m_rc_sn1
                                         fp_li_m_sn_pt1
                                         fp_li_m_rltyp1
                                         fp_li_m_prtyp1
                                         fp_li_m_rs_wm2
                                         fp_li_m_rc_sn2
                                         fp_li_m_sn_pt2
                                         fp_li_m_rltyp2
                                         fp_li_m_prtyp2
*                                        End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                                CHANGING fp_li_rep_lout.
* Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
  ELSE. " ELSE -> IF lv_kotab NE c_wo_no_lp
    lv_kotab = c_wo_relat.
  ENDIF. " IF lv_kotab NE c_wo_no_lp
* End   of ADD:CR#652:WROY:13-SEP-2017:ED2K908487

* Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*  IF rb_lib_e IS INITIAL.
**   Check for available Discount
*    READ TABLE fp_li_discount TRANSPORTING NO FIELDS
*         WITH KEY kappl = fp_lst_list_prc-kappl
*                  kdgrp = fp_lst_list_prc-kdgrp
*                  extwg = fp_lst_list_prc-extwg
*                  matnr = fp_lst_list_prc-matnr
*         BINARY SEARCH.
*    IF sy-subrc NE 0.
*      READ TABLE fp_li_discount TRANSPORTING NO FIELDS
*           WITH KEY kappl = fp_lst_list_prc-kappl
*                    kdgrp = fp_lst_list_prc-kdgrp
*                    extwg = fp_lst_list_prc-extwg
*                    matnr = space
*           BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        DATA(lv_jrnl_grp_code) = abap_true.
*      ENDIF.
*    ENDIF.
*    IF sy-subrc EQ 0.
*      LOOP AT fp_li_discount INTO lst_discount FROM sy-tabix.
*        IF lv_jrnl_grp_code IS INITIAL.
*          IF lst_discount-kappl NE fp_lst_list_prc-kappl OR
*             lst_discount-kdgrp NE fp_lst_list_prc-kdgrp OR
*             lst_discount-extwg NE fp_lst_list_prc-extwg OR
*             lst_discount-matnr NE fp_lst_list_prc-matnr.
*            EXIT.
*          ENDIF.
*        ELSE.
*          IF lst_discount-kappl NE fp_lst_list_prc-kappl OR
*             lst_discount-kdgrp NE fp_lst_list_prc-kdgrp OR
*             lst_discount-extwg NE fp_lst_list_prc-extwg OR
*             lst_discount-matnr NE space.
*            EXIT.
*          ENDIF.
*        ENDIF.
*  *     Populate Report Layout
*        PERFORM f_populate_rep_lout USING    fp_lst_list_prc
*                                             fp_lst_1d_scale
*                                             lst_discount
*                                             fp_li_idcdasgn
*                                             fp_li_bom_head
*                                             fp_li_bom_comp
*                                             fp_li_soc_name
*                                             fp_li_rel_catg
*                                             fp_li_memb_due
*                                    CHANGING fp_li_rep_lout.
*      ENDLOOP.
*    ENDIF.
*  ENDIF.
* End   of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
* Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
* Determine Discount using specific Material

* Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
* CASE fp_lst_list_prc-kotab.
  CASE lv_kotab.
* End   of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
    WHEN c_wo_relat.
*     Check for available Discount
      READ TABLE fp_li_discount TRANSPORTING NO FIELDS
*          Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
*          WITH KEY kotab     = fp_lst_list_prc-kotab
           WITH KEY kotab     = lv_kotab
*          Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
                    kappl     = fp_lst_list_prc-kappl
                    kdgrp     = fp_lst_list_prc-kdgrp
                    extwg     = fp_lst_list_prc-extwg
                    matnr     = fp_lst_list_prc-matnr
           BINARY SEARCH.
    WHEN c_wt_relat.
*     Check for available Discount
      READ TABLE fp_li_discount TRANSPORTING NO FIELDS
*          Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
*          WITH KEY kotab     = fp_lst_list_prc-kotab
           WITH KEY kotab     = lv_kotab
*          Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
                    kappl     = fp_lst_list_prc-kappl
                    kdgrp     = fp_lst_list_prc-kdgrp
                    extwg     = fp_lst_list_prc-extwg
                    matnr     = fp_lst_list_prc-matnr
                    soc_numbr = fp_lst_list_prc-soc_numbr
           BINARY SEARCH.
  ENDCASE.
  IF sy-subrc EQ 0.
    LOOP AT fp_li_discount INTO lst_discount FROM sy-tabix.
*     Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
*     CASE fp_lst_list_prc-kotab.
      CASE lv_kotab.
*     End   of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
        WHEN c_wo_relat.
*         Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
*         IF lst_discount-kotab     NE fp_lst_list_prc-kotab OR
          IF lst_discount-kotab     NE lv_kotab OR
*         End   of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
             lst_discount-kappl     NE fp_lst_list_prc-kappl OR
             lst_discount-kdgrp     NE fp_lst_list_prc-kdgrp OR
             lst_discount-extwg     NE fp_lst_list_prc-extwg OR
             lst_discount-matnr     NE fp_lst_list_prc-matnr.
            EXIT.
          ENDIF. " IF lst_discount-kotab NE lv_kotab OR
        WHEN c_wt_relat.
*         Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
*         IF lst_discount-kotab     NE fp_lst_list_prc-kotab OR
          IF lst_discount-kotab     NE lv_kotab OR
*         End   of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
             lst_discount-kappl     NE fp_lst_list_prc-kappl OR
             lst_discount-kdgrp     NE fp_lst_list_prc-kdgrp OR
             lst_discount-extwg     NE fp_lst_list_prc-extwg OR
             lst_discount-matnr     NE fp_lst_list_prc-matnr OR
             lst_discount-soc_numbr NE fp_lst_list_prc-soc_numbr.
            EXIT.
          ENDIF. " IF lst_discount-kotab NE lv_kotab OR
      ENDCASE.
*  Begin OF Add:CR#6341 RTR20180614  ED2K912278
      SORT fp_li_val_text BY  spras vlaufk.
      READ TABLE fp_li_val_text INTO lst_val_text
           WITH KEY spras = sy-langu
             vlaufk = lst_discount-laufk BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR lst_val_text.
      ENDIF. " IF sy-subrc NE 0
*   END of ADD:CR#6341 RTR20180614  ED2K912278
*     Populate report layout
      PERFORM f_populate_rep_lout USING    fp_lst_list_prc
                                           fp_lst_1d_scale
                                           lst_discount
                                           lst_val_text "CR6341 RTR20180614 ED2K912278
                                           fp_li_idcdasgn
                                           fp_li_bom_head
                                           fp_li_bom_comp
                                           fp_li_soc_name
                                           fp_li_rel_catg
                                           fp_li_memb_due
*                                          Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                                           fp_li_m_rs_wm1
                                           fp_li_m_rc_sn1
                                           fp_li_m_sn_pt1
                                           fp_li_m_rltyp1
                                           fp_li_m_prtyp1
                                           fp_li_m_rs_wm2
                                           fp_li_m_rc_sn2
                                           fp_li_m_sn_pt2
                                           fp_li_m_rltyp2
                                           fp_li_m_prtyp2
*                                          End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                                  CHANGING fp_li_rep_lout.
    ENDLOOP. " LOOP AT fp_li_discount INTO lst_discount FROM sy-tabix
  ENDIF. " IF sy-subrc EQ 0

* Determine Discount using External Material Group
* Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
* CASE fp_lst_list_prc-kotab.
  CASE lv_kotab.
* End   of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
    WHEN c_wo_relat.
*     Check for available Discount
      READ TABLE fp_li_discount TRANSPORTING NO FIELDS
*          Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
*          WITH KEY kotab     = fp_lst_list_prc-kotab
           WITH KEY kotab     = lv_kotab
*          Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
                    kappl     = fp_lst_list_prc-kappl
                    kdgrp     = fp_lst_list_prc-kdgrp
                    extwg     = fp_lst_list_prc-extwg
                    matnr     = space
           BINARY SEARCH.
    WHEN c_wt_relat.
*     Check for available Discount
      READ TABLE fp_li_discount TRANSPORTING NO FIELDS
*          Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
*          WITH KEY kotab     = fp_lst_list_prc-kotab
           WITH KEY kotab     = lv_kotab
*          Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
                    kappl     = fp_lst_list_prc-kappl
                    kdgrp     = fp_lst_list_prc-kdgrp
                    extwg     = fp_lst_list_prc-extwg
                    matnr     = space
                    soc_numbr = fp_lst_list_prc-soc_numbr
           BINARY SEARCH.
  ENDCASE.
  IF sy-subrc EQ 0.
    LOOP AT fp_li_discount INTO lst_discount FROM sy-tabix.
*     Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
*     CASE fp_lst_list_prc-kotab.
      CASE lv_kotab.
*     End   of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
        WHEN c_wo_relat.
*         Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
*         IF lst_discount-kotab     NE fp_lst_list_prc-kotab OR
          IF lst_discount-kotab     NE lv_kotab OR
*         End   of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
             lst_discount-kappl     NE fp_lst_list_prc-kappl OR
             lst_discount-kdgrp     NE fp_lst_list_prc-kdgrp OR
             lst_discount-extwg     NE fp_lst_list_prc-extwg OR
             lst_discount-matnr     NE space.
            EXIT.
          ENDIF. " IF lst_discount-kotab NE lv_kotab OR
        WHEN c_wt_relat.
*         Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
*         IF lst_discount-kotab     NE fp_lst_list_prc-kotab OR
          IF lst_discount-kotab     NE lv_kotab OR
*         End   of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
             lst_discount-kappl     NE fp_lst_list_prc-kappl OR
             lst_discount-kdgrp     NE fp_lst_list_prc-kdgrp OR
             lst_discount-extwg     NE fp_lst_list_prc-extwg OR
             lst_discount-matnr     NE space                 OR
             lst_discount-soc_numbr NE fp_lst_list_prc-soc_numbr.
            EXIT.
          ENDIF. " IF lst_discount-kotab NE lv_kotab OR
      ENDCASE.
*     Check if Discount with specific Material was already applied
      READ TABLE fp_li_discount TRANSPORTING NO FIELDS
*          Begin of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
*          WITH KEY kotab     = fp_lst_list_prc-kotab
           WITH KEY kotab     = lv_kotab
*          End   of ADD:CR#652:WROY:13-SEP-2017:ED2K908487
                    kappl     = fp_lst_list_prc-kappl
                    kdgrp     = fp_lst_list_prc-kdgrp
                    extwg     = fp_lst_list_prc-extwg
                    matnr     = fp_lst_list_prc-matnr
                    soc_numbr = lst_discount-soc_numbr
                    rltyp     = lst_discount-rltyp
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        CONTINUE.
      ENDIF. " IF sy-subrc EQ 0
*     Populate report layout
      PERFORM f_populate_rep_lout USING    fp_lst_list_prc
                                           fp_lst_1d_scale
                                           lst_discount
                                           lst_val_text "CR6341 RTR20180614 ED2K912278
                                           fp_li_idcdasgn
                                           fp_li_bom_head
                                           fp_li_bom_comp
                                           fp_li_soc_name
                                           fp_li_rel_catg
                                           fp_li_memb_due
*                                          Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                                           fp_li_m_rs_wm1
                                           fp_li_m_rc_sn1
                                           fp_li_m_sn_pt1
                                           fp_li_m_rltyp1
                                           fp_li_m_prtyp1
                                           fp_li_m_rs_wm2
                                           fp_li_m_rc_sn2
                                           fp_li_m_sn_pt2
                                           fp_li_m_rltyp2
                                           fp_li_m_prtyp2
*                                          End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                                  CHANGING fp_li_rep_lout.
    ENDLOOP. " LOOP AT fp_li_discount INTO lst_discount FROM sy-tabix
  ENDIF. " IF sy-subrc EQ 0
* End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_IDOC_JPS
*&---------------------------------------------------------------------*
*       Create IDOC (XML) for JPS
*----------------------------------------------------------------------*
*      -->FP_LI_REP_LOUT  text
*----------------------------------------------------------------------*
FORM f_create_idoc_jps  USING    fp_li_rep_lout TYPE tt_rep_lout
                                 fp_li_bom_detl TYPE tt_bom_detl.

  DATA:
    li_edidd    TYPE edidd_tt,
    li_idoc_cnt TYPE edidc_tt.

  DATA:
    lst_edidc   TYPE edidc,         " Control record (IDoc)
    lst_jps_hdr TYPE z1pdm_jps_hdr, " I0225: Header (JPS)
    lst_journal TYPE z1pdm_journal, " I0225: Journal Product Master
    lst_colhead TYPE z1pdm_colhead, " I0225: Column Headings
    lst_price   TYPE z1pdm_price.   " I0225: Price Details

  DATA:
    lv_c_segnum TYPE idocdsgnum, " Number of SAP segment
    lv_p_segn_h TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
    lv_p_segn_j TYPE edi_psgnum, " Number of the hierarchically higher SAP segment
    lv_p_segn_c TYPE edi_psgnum. " Number of the hierarchically higher SAP segment

  IF rb_jps_x IS INITIAL.
    RETURN.
  ENDIF. " IF rb_jps_x IS INITIAL

* Populate IDOC Control Record
  PERFORM f_idoc_cntrl_rec USING    c_m_typ_j
                                    c_i_typ_j
                           CHANGING lst_edidc.

  DATA(li_rep_lout_s) = fp_li_rep_lout[].
*  BEGIN OF DEL:CR#6341 RTR20180614  ED2K912278
*  SORT li_rep_lout_s BY alpha_sep extwg member ipm_ind rltyp soc_numbr line_scal level pltyp.
*  END OF DEL:CR#6341 RTR20180614  ED2K912278
  SORT li_rep_lout_s BY alpha_sep extwg member ipm_ind rltyp soc_numbr line_scal vlaufk level pltyp. "CR6341 RTR20180614 ED2K912278
  DATA(li_rep_lout) = fp_li_rep_lout[].
  SORT li_rep_lout BY extwg pltyp.
  DELETE ADJACENT DUPLICATES FROM li_rep_lout COMPARING extwg pltyp.

  DATA(li_bom_detl_c) = fp_li_bom_detl[].
  DELETE li_bom_detl_c WHERE mtart NOT IN s_mtartc.
  SORT li_bom_detl_c BY extwg_cmp extwg.
  DELETE ADJACENT DUPLICATES FROM li_bom_detl_c COMPARING extwg_cmp extwg.
* Begin of ADD:INC0196170:SAYANDAS:24-MAY-2018:ED1K907103
  LOOP AT li_bom_detl_c ASSIGNING FIELD-SYMBOL(<lst_bom_detl_c>).
    READ TABLE li_rep_lout TRANSPORTING NO FIELDS
         WITH KEY extwg = <lst_bom_detl_c>-extwg
         BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR: <lst_bom_detl_c>-extwg,
             <lst_bom_detl_c>-extwg_cmp.
    ENDIF. " IF sy-subrc NE 0
  ENDLOOP. " LOOP AT li_bom_detl_c ASSIGNING FIELD-SYMBOL(<lst_bom_detl_c>)
  DELETE li_bom_detl_c WHERE extwg     IS INITIAL
                         AND extwg_cmp IS INITIAL.
* End   of ADD:INC0196170:SAYANDAS:24-MAY-2018:ED1K907103

  DATA(li_bom_detl_h) = fp_li_bom_detl[].
  DELETE li_bom_detl_h WHERE mtart NOT IN s_mtartc.
  SORT li_bom_detl_h BY extwg extwg_cmp.
  DELETE ADJACENT DUPLICATES FROM li_bom_detl_h COMPARING extwg extwg_cmp.

  DATA(li_rep_lout_i) = fp_li_rep_lout[].
  SORT li_rep_lout_i BY extwg issn_lvl.
* Begin of ADD:CR#523:WROY:22-JUN-2017:ED2K904908
  DELETE ADJACENT DUPLICATES FROM li_rep_lout_i COMPARING extwg issn_lvl.
* End   of ADD:CR#523:WROY:22-JUN-2017:ED2K904908
* Begin of DEL:CR#523:WROY:22-JUN-2017:ED2K904908
* DELETE ADJACENT DUPLICATES FROM li_rep_lout_i COMPARING extwg.
* End   of DEL:CR#523:WROY:22-JUN-2017:ED2K904908

  LOOP AT li_rep_lout_s ASSIGNING FIELD-SYMBOL(<lst_rep_lout>).
    AT FIRST.
*     Populate Segment: Z1PDM_JPS_HDR
      CLEAR: lst_jps_hdr.
      lst_jps_hdr-prc_lst_4_yr = p_prsdt(4).

      lv_c_segnum = lv_c_segnum + 1.
      APPEND INITIAL LINE TO li_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd>).
      <lst_edidd>-segnum = lv_c_segnum.
      <lst_edidd>-segnam = c_seg_hdr.
      <lst_edidd>-hlevel = 1.
      <lst_edidd>-sdata  = lst_jps_hdr.
      lv_p_segn_h        = lv_c_segnum.
    ENDAT.

    AT NEW member.
*     Populate Segment: Z1PDM_JOURNAL
      CLEAR: lst_journal.
*     Begin of DEL:CR#523:WROY:22-JUN-2017:ED2K904908
*     READ TABLE li_rep_lout_i ASSIGNING FIELD-SYMBOL(<lst_rep_lout_i>)
*          WITH KEY extwg = <lst_rep_lout>-extwg
*          BINARY SEARCH.
*     IF sy-subrc EQ 0.
*       lst_journal-issn       = <lst_rep_lout_i>-identcode.
*     ENDIF.
*     End   of DEL:CR#523:WROY:22-JUN-2017:ED2K904908
*     Begin of ADD:CR#523:WROY:22-JUN-2017:ED2K904908
*     ISSN - Print
      READ TABLE li_rep_lout_i ASSIGNING FIELD-SYMBOL(<lst_rep_lout_i>)
           WITH KEY extwg    = <lst_rep_lout>-extwg
                    issn_lvl = c_flg_srt_1
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_journal-issn_print        = <lst_rep_lout_i>-identcode.
      ENDIF. " IF sy-subrc EQ 0
*     ISSN - Online
      READ TABLE li_rep_lout_i ASSIGNING <lst_rep_lout_i>
           WITH KEY extwg    = <lst_rep_lout>-extwg
                    issn_lvl = c_flg_srt_2
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_journal-issn_online       = <lst_rep_lout_i>-identcode.
      ENDIF. " IF sy-subrc EQ 0
*     ISSN - Print + Online
      READ TABLE li_rep_lout_i ASSIGNING <lst_rep_lout_i>
           WITH KEY extwg    = <lst_rep_lout>-extwg
                    issn_lvl = c_flg_srt_3
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_journal-issn_print_online = <lst_rep_lout_i>-identcode.
      ENDIF. " IF sy-subrc EQ 0
*     Indicator: Multi-Journal Product
      IF <lst_rep_lout>-mtart IN s_mtartc.
        lst_journal-mjp_ind = 'true'(h02).
      ELSE. " ELSE -> IF <lst_rep_lout>-mtart IN s_mtartc
        lst_journal-mjp_ind = 'false'(h03).
*       Begin of ADD:ERP-3367:WROY:20-JUL-2017:ED2K907393
        READ TABLE li_bom_detl_c TRANSPORTING NO FIELDS
             WITH KEY extwg_cmp = <lst_rep_lout>-extwg
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          lst_journal-mjp_ind = 'true'(h02).
        ENDIF. " IF sy-subrc EQ 0
*       End   of ADD:ERP-3367:WROY:20-JUL-2017:ED2K907393
      ENDIF. " IF <lst_rep_lout>-mtart IN s_mtartc
*     End   of ADD:CR#523:WROY:22-JUN-2017:ED2K904908
*     Begin of ADD:CR#627:WROY:04-AUG-2017:ED2K907749
      IF <lst_rep_lout>-mtart IN     s_mtartb AND
         <lst_rep_lout>-mtart NOT IN s_mtartc.
*       ISSN - Print
        IF lst_journal-issn_print IS INITIAL.
          READ TABLE i_multi_med ASSIGNING FIELD-SYMBOL(<lst_mult_med>)
               WITH KEY extwg    = <lst_rep_lout>-extwg
                        issn_lvl = c_flg_srt_1
               BINARY SEARCH.
          IF sy-subrc EQ 0.
            lst_journal-issn_print  = <lst_mult_med>-identcode.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF lst_journal-issn_print IS INITIAL
*       ISSN - Online
        IF lst_journal-issn_online IS INITIAL.
          READ TABLE i_multi_med ASSIGNING <lst_mult_med>
               WITH KEY extwg    = <lst_rep_lout>-extwg
                        issn_lvl = c_flg_srt_2
               BINARY SEARCH.
          IF sy-subrc EQ 0.
            lst_journal-issn_online = <lst_mult_med>-identcode.
          ENDIF. " IF sy-subrc EQ 0
        ENDIF. " IF lst_journal-issn_online IS INITIAL
      ENDIF. " IF <lst_rep_lout>-mtart IN s_mtartb AND
*     End   of ADD:CR#627:WROY:04-AUG-2017:ED2K907749

      lst_journal-acronynm     = <lst_rep_lout>-extwg.
      lst_journal-title        = <lst_rep_lout>-maktx.
      lst_journal-created_by   = 'SAP'(h01).
      lst_journal-created_date = sy-datum.
      CASE <lst_rep_lout>-member.
        WHEN c_flg_srt_1.
          lst_journal-membership = 'false'(h03).
        WHEN c_flg_srt_2.
          lst_journal-membership = 'true'(h02).
      ENDCASE.

      lv_c_segnum = lv_c_segnum + 1.
      APPEND INITIAL LINE TO li_edidd ASSIGNING <lst_edidd>.
      <lst_edidd>-segnum = lv_c_segnum.
      <lst_edidd>-psgnum = lv_p_segn_h.
      <lst_edidd>-segnam = c_seg_jrn.
      <lst_edidd>-hlevel = 2.
      <lst_edidd>-sdata  = lst_journal.
      lv_p_segn_j        = lv_c_segnum.

*     Populate Segment: Z1PDM_COLHEAD
      CLEAR: lst_colhead.
      IF <lst_rep_lout>-publtype IN s_opt_in. "Opt-in Subscription
        lst_colhead-column01 = 'Opt-in Subscription'(m03).
      ELSE. " ELSE -> IF <lst_rep_lout>-publtype IN s_opt_in
        CASE <lst_rep_lout>-member.
          WHEN c_flg_srt_1.
            lst_colhead-column01 = 'Annual Subscription'(m02).
          WHEN c_flg_srt_2.
            lst_colhead-column01 = 'Membership Subscription'(m01).
        ENDCASE.
      ENDIF. " IF <lst_rep_lout>-publtype IN s_opt_in

*     Populate Column Heading Segment
      PERFORM f_segment_colhead USING    <lst_rep_lout>
                                         lv_p_segn_j
                                         li_rep_lout
                                CHANGING lst_colhead
                                         lv_c_segnum
                                         lv_p_segn_c
                                         li_edidd.
    ENDAT.

    IF <lst_rep_lout>-publtype NOT IN s_opt_in. "Not an Opt-in Subscription
*     Populate Price Value
      PERFORM f_populate_price USING    <lst_rep_lout>
                               CHANGING lst_price.
    ENDIF. " IF <lst_rep_lout>-publtype NOT IN s_opt_in

    AT END OF level.
      IF <lst_rep_lout>-publtype NOT IN s_opt_in. "Not an Opt-in Subscription
*       Populate Price Segment
        PERFORM f_segment_price USING    <lst_rep_lout>
                                         lv_p_segn_c
                                CHANGING lst_price
                                         lv_c_segnum
                                         li_edidd.
      ENDIF. " IF <lst_rep_lout>-publtype NOT IN s_opt_in
    ENDAT.

    AT END OF member.
      IF <lst_rep_lout>-member EQ c_flg_srt_1 AND
         <lst_rep_lout>-publtype NOT IN s_opt_in. "Not an Opt-in Subscription
        READ TABLE li_bom_detl_c TRANSPORTING NO FIELDS
             WITH KEY extwg_cmp = <lst_rep_lout>-extwg
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          LOOP AT li_bom_detl_c ASSIGNING FIELD-SYMBOL(<lst_bom_detl>) FROM sy-tabix.
            IF <lst_bom_detl>-extwg_cmp NE <lst_rep_lout>-extwg.
              EXIT.
            ENDIF. " IF <lst_bom_detl>-extwg_cmp NE <lst_rep_lout>-extwg
*           Populate BOM Segments
            PERFORM f_add_bom_segments USING    li_rep_lout_s
                                                <lst_bom_detl>
                                                li_rep_lout
                                                lv_p_segn_j
                                                li_bom_detl_h
                                       CHANGING lv_c_segnum
                                                li_edidd.
          ENDLOOP. " LOOP AT li_bom_detl_c ASSIGNING FIELD-SYMBOL(<lst_bom_detl>) FROM sy-tabix
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF <lst_rep_lout>-member EQ c_flg_srt_1 AND
    ENDAT.
  ENDLOOP. " LOOP AT li_rep_lout_s ASSIGNING FIELD-SYMBOL(<lst_rep_lout>)

* Call functipon module to send idoc
  CALL FUNCTION 'MASTER_IDOC_DISTRIBUTE'
    EXPORTING
      master_idoc_control            = lst_edidc   "IDOC Control Record
    TABLES
      communication_idoc_control     = li_idoc_cnt "IDOC Control Record (Comm)
      master_idoc_data               = li_edidd    "IDOC Data Record
    EXCEPTIONS
      error_in_idoc_control          = 1
      error_writing_idoc_status      = 2
      error_in_idoc_data             = 3
      sending_logical_system_unknown = 4
      OTHERS                         = 5.
  IF sy-subrc EQ 0.
    COMMIT WORK.
    READ TABLE li_idoc_cnt ASSIGNING FIELD-SYMBOL(<lst_idoc_cnt>) INDEX 1.
    IF sy-subrc EQ 0.
*     IDOC &1 was created
      MESSAGE i171(/spe/id_handling) WITH <lst_idoc_cnt>-docnum. " IDOC &1 was created
    ENDIF. " IF sy-subrc EQ 0
  ELSE. " ELSE -> IF sy-subrc EQ 0
    MESSAGE ID sy-msgid
          TYPE c_msgty_i
        NUMBER sy-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4.
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_REP_LOUT
*&---------------------------------------------------------------------*
*       Populate Report Layout
*----------------------------------------------------------------------*
*      -->FP_LST_LIST_PRC  text
*      -->FP_LST_1D_SCALE  text
*      -->FP_LST_DISCOUNT  text
*      -->FP_LI_M_RC_SN1   Rel Cat/Soc No (With Material)
*      -->FP_LI_M_SN_PT1   Soc No/Prc Typ (With Material)
*      -->FP_LI_M_RLTYP1   Rel Category (With Material)
*      -->FP_LI_M_PRTYP1   Price Type (With Material)
*      -->FP_LI_M_RC_SN2   Rel Cat/Soc No (With Material)
*      -->FP_LI_M_SN_PT2   Soc No/Prc Typ (With Material)
*      -->FP_LI_M_RLTYP2   Rel Category (With Material)
*      -->FP_LI_M_PRTYP2   Price Type (With Material)
*      <--FP_LI_REP_LOUT   Report Layout
*----------------------------------------------------------------------*
FORM f_populate_rep_lout  USING    fp_lst_list_prc TYPE ty_list_prc
                                   fp_lst_1d_scale TYPE ty_1d_scale
                                   fp_lst_discount TYPE ty_discount
                                   fp_lst_val_text TYPE ty_val_text "CR6341 RTR20180614 ED2K912278
                                   fp_li_idcdasgn  TYPE tt_idcdasgn
                                   fp_li_bom_head  TYPE tt_bom_detl
                                   fp_li_bom_comp  TYPE tt_bom_detl
                                   fp_li_soc_name  TYPE tt_soc_name
                                   fp_li_rel_catg  TYPE tt_rel_catg
                                   fp_li_memb_due  TYPE tt_memb_due
*                                  Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                                   fp_li_m_rs_wm1  TYPE tt_mn_rs_wm
                                   fp_li_m_rc_sn1  TYPE tt_mn_rc_sn
                                   fp_li_m_sn_pt1  TYPE tt_mn_sn_pt
                                   fp_li_m_rltyp1  TYPE tt_mn_rltyp
                                   fp_li_m_prtyp1  TYPE tt_mn_prtyp
                                   fp_li_m_rs_wm2  TYPE tt_mn_rs_wm
                                   fp_li_m_rc_sn2  TYPE tt_mn_rc_sn
                                   fp_li_m_sn_pt2  TYPE tt_mn_sn_pt
                                   fp_li_m_rltyp2  TYPE tt_mn_rltyp
                                   fp_li_m_prtyp2  TYPE tt_mn_prtyp
*                                  End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
                          CHANGING fp_li_rep_lout  TYPE tt_rep_lout.

  DATA:
    lst_rep_lout TYPE ty_rep_lout.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
  DATA: lv_alpha1 TYPE string,
        lv_alpha2 TYPE string.
*EOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>

* Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
  DATA:
    li_txt_lines TYPE idmx_di_t_tline. "SAPscript: Text Lines

  DATA:
*   Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
    lv_filter    TYPE flag, "Flag: To filter records
*   End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
    lv_prc_int   TYPE i,        "Price (Whole Number)
    lv_text_name TYPE tdobname, "Text Name
    lv_txt_strng TYPE string.   "Text String
* End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908

*BOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
*Only Librarian file should alpha by the “Description” Name,
  IF rb_jps_x EQ abap_true.
*EOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
    lst_rep_lout-alpha_sep   = fp_lst_list_prc-extwg(1). "Alphabetical letter separator
*BOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
  ENDIF.
*EOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
  lst_rep_lout-extwg       = fp_lst_list_prc-extwg. "External Material Group
  lst_rep_lout-level       = fp_lst_list_prc-level. "Online Only(1)/Online + Print Only(2)/Print Only(3)
  lst_rep_lout-issn_lvl    = fp_lst_list_prc-issn_lvl. "Print Only(1)/Online Only(2)/Online + Print Only(3)
  lst_rep_lout-matnr       = fp_lst_list_prc-matnr. "Material Number
  lst_rep_lout-objek       = fp_lst_list_prc-matnr. "Key of object to be classified
  lst_rep_lout-mstae       = fp_lst_list_prc-mstae. "Cross-Plant Material Status
  lst_rep_lout-mtart       = fp_lst_list_prc-mtart. "Material Type
  lst_rep_lout-publtype    = fp_lst_list_prc-publtype. "Publication Type


* Check for BOM Component or Header
  lst_rep_lout-bom_info    = c_flag_n. "Not a BOM Component or Header
  READ TABLE fp_li_bom_comp TRANSPORTING NO FIELDS
       WITH KEY idnrk = lst_rep_lout-matnr
       BINARY SEARCH.
  IF sy-subrc EQ 0.
    CLEAR: lst_rep_lout-hdr_comp.
    LOOP AT fp_li_bom_comp ASSIGNING FIELD-SYMBOL(<lst_bom_comp>) FROM sy-tabix.
      IF <lst_bom_comp>-idnrk NE lst_rep_lout-matnr.
        EXIT.
      ENDIF. " IF <lst_bom_comp>-idnrk NE lst_rep_lout-matnr
      IF lst_rep_lout-hdr_comp IS INITIAL.
        lst_rep_lout-hdr_comp = <lst_bom_comp>-matnr_hdr.
      ELSE. " ELSE -> IF lst_rep_lout-hdr_comp IS INITIAL
        CONCATENATE lst_rep_lout-hdr_comp
                    <lst_bom_comp>-matnr_hdr
               INTO lst_rep_lout-hdr_comp
          SEPARATED BY c_comma.
      ENDIF. " IF lst_rep_lout-hdr_comp IS INITIAL
    ENDLOOP. " LOOP AT fp_li_bom_comp ASSIGNING FIELD-SYMBOL(<lst_bom_comp>) FROM sy-tabix
    lst_rep_lout-bom_info  = c_flag_c. "BOM Component
  ENDIF. " IF sy-subrc EQ 0
  READ TABLE fp_li_bom_head TRANSPORTING NO FIELDS
       WITH KEY matnr_hdr = lst_rep_lout-matnr
       BINARY SEARCH.
  IF sy-subrc EQ 0.
    CLEAR: lst_rep_lout-hdr_comp.
    LOOP AT fp_li_bom_head ASSIGNING FIELD-SYMBOL(<lst_bom_head>) FROM sy-tabix.
      IF <lst_bom_head>-matnr_hdr NE lst_rep_lout-matnr.
        EXIT.
      ENDIF. " IF <lst_bom_head>-matnr_hdr NE lst_rep_lout-matnr
      IF lst_rep_lout-hdr_comp IS INITIAL.
        lst_rep_lout-hdr_comp = <lst_bom_head>-idnrk.
      ELSE. " ELSE -> IF lst_rep_lout-hdr_comp IS INITIAL
        CONCATENATE lst_rep_lout-hdr_comp
                    <lst_bom_head>-idnrk
               INTO lst_rep_lout-hdr_comp
          SEPARATED BY c_comma.
      ENDIF. " IF lst_rep_lout-hdr_comp IS INITIAL
    ENDLOOP. " LOOP AT fp_li_bom_head ASSIGNING FIELD-SYMBOL(<lst_bom_head>) FROM sy-tabix
    lst_rep_lout-bom_info  = c_flag_h. "BOM Header
  ENDIF. " IF sy-subrc EQ 0

  lst_rep_lout-title       = fp_lst_list_prc-title. "Title
* Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
* lst_rep_lout-maktx       = fp_lst_list_prc-maktx.             "Material Description (Short Text)
* End   of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
* Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
  CLEAR: li_txt_lines.
  lv_text_name = lst_rep_lout-matnr. "Name of text to be read
* Read Material text
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id                      = c_tdid_grun  "Text ID of text to be read (GRUN)
      language                = sy-langu     "Language of text to be read
      name                    = lv_text_name "Name of text to be read
      object                  = c_tdobj_mat  "Object of text to be read (MATERIAL)
    TABLES
      lines                   = li_txt_lines "Lines of text read
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc EQ 0.
*   Convert ITF text into a string
    CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
      EXPORTING
        it_tline       = li_txt_lines  "Lines of text read
      IMPORTING
        ev_text_string = lv_txt_strng. "Text String
    lst_rep_lout-maktx     = lv_txt_strng. "Material Description
  ENDIF. " IF sy-subrc EQ 0
* End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908

*BOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
  IF rb_lib_e EQ abap_true.
*Journal Alpha sections should being with the first Journal Description with that letter and end with the last.
*Journals should be alpha by the “Description” Name, the logic should ignore “The” when alphabetizing
    SPLIT lst_rep_lout-maktx AT space INTO lv_alpha1 lv_alpha2.

    READ TABLE i_constants ASSIGNING FIELD-SYMBOL(<lst_constant>)
       WITH KEY param1 = c_param_alp
                low    = lv_alpha1.
    IF sy-subrc NE 0.
      TRANSLATE lv_alpha1 TO UPPER CASE.
      READ TABLE i_constants ASSIGNING <lst_constant>
         WITH KEY param1 = c_param_alp
                  low    = lv_alpha1.
    ENDIF. " IF sy-subrc EQ 0
    IF sy-subrc = 0.
      TRANSLATE lv_alpha2 TO UPPER CASE.
      CONDENSE lv_alpha2.
      lst_rep_lout-alpha_sep   = lv_alpha2(1). "Alphabetical letter separator
      lst_rep_lout-maktx_xls   = lv_alpha2.    "Material Description for Sort
    ELSE.
      lst_rep_lout-alpha_sep   = lst_rep_lout-maktx(1). "Alphabetical letter separator
      TRANSLATE lst_rep_lout-alpha_sep TO UPPER CASE.
      lst_rep_lout-maktx_xls   = lst_rep_lout-maktx.    "Material Description for Sort
      TRANSLATE lst_rep_lout-maktx_xls TO UPPER CASE.
    ENDIF.
  ENDIF.
*EOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>

  lst_rep_lout-mediatype   = fp_lst_list_prc-mediatype. "Media Type
* Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
* lst_rep_lout-knuma_ag    = fp_lst_list_prc-knuma_ag.          "Price Type
* End   of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
* Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
  lst_rep_lout-knuma_ag    = fp_lst_list_prc-kosrt. "Price Type
* End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908

  lst_rep_lout-pltyp       = fp_lst_list_prc-pltyp. "Price list type
  lst_rep_lout-kdgrp       = fp_lst_list_prc-kdgrp. "Customer group

  IF lst_rep_lout-publtype IN s_opt_in. "Opt-in Subscription
    lst_rep_lout-member    = c_flg_srt_1. "Flag for Sorting: 1
    lst_rep_lout-memb_due  = c_flag_n. "Indicator: Membership Due (NO)
  ELSE. " ELSE -> IF lst_rep_lout-publtype IN s_opt_in
    READ TABLE fp_li_memb_due TRANSPORTING NO FIELDS
         WITH KEY extwg = lst_rep_lout-extwg
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      IF lst_rep_lout-knuma_ag EQ c_memb_rate AND "Member Rate
         rb_jps_x IS NOT INITIAL.                 "JPS XML
        lst_rep_lout-member = c_flg_srt_2. "Flag for Sorting: 2
      ELSE. " ELSE -> IF lst_rep_lout-knuma_ag EQ c_memb_rate AND
        lst_rep_lout-member = c_flg_srt_1. "Flag for Sorting: 1
      ENDIF. " IF lst_rep_lout-knuma_ag EQ c_memb_rate AND
      lst_rep_lout-memb_due = c_flag_y. "Indicator: Membership Due (YES)
    ELSE. " ELSE -> IF sy-subrc EQ 0
      lst_rep_lout-member   = c_flg_srt_1. "Flag for Sorting: 1
      lst_rep_lout-memb_due = c_flag_n. "Indicator: Membership Due (NO)
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF lst_rep_lout-publtype IN s_opt_in

  IF fp_lst_discount-rltyp     IS NOT INITIAL AND
     fp_lst_discount-soc_numbr IS NOT INITIAL.
    lst_rep_lout-rltyp     = fp_lst_discount-rltyp. "Business Partner Relationship Category
    lst_rep_lout-soc_numbr = fp_lst_discount-soc_numbr. "Business Partner 2 or Society number
  ELSE. " ELSE -> IF fp_lst_discount-rltyp IS NOT INITIAL AND
    lst_rep_lout-rltyp     = fp_lst_list_prc-rltyp. "Business Partner Relationship Category
    lst_rep_lout-soc_numbr = fp_lst_list_prc-soc_numbr. "Business Partner 2 or Society number
  ENDIF. " IF fp_lst_discount-rltyp IS NOT INITIAL AND
* Society Name
  READ TABLE fp_li_soc_name ASSIGNING FIELD-SYMBOL(<lst_soc_name>)
       WITH KEY kunnr = lst_rep_lout-soc_numbr
       BINARY SEARCH.
  IF sy-subrc EQ 0.
*BOC <HIPATEL> <INC0207303> <ED1K908211> <08/16/2018>
*All title fields should be used to populate BP Title for JPS XML
    IF rb_jps_x EQ abap_true.
      CONCATENATE <lst_soc_name>-name1     "Name 1
                  <lst_soc_name>-name2     "Name 2
                  <lst_soc_name>-name3     "Name 3
       INTO <lst_soc_name>-name_text "Full Name
       SEPARATED BY space.
    ELSE.
*EOC <HIPATEL> <INC0207303> <ED1K908211> <08/16/2018>
      CONCATENATE <lst_soc_name>-name1     "Name 1
                  <lst_soc_name>-name3     "Name 3
             INTO <lst_soc_name>-name_text "Full Name
        SEPARATED BY space.
    ENDIF.    "IF rb_jps_x eq abap_true.  "+<HIPATEL> <INC0207303> <ED1K908211>
    lst_rep_lout-soc_name  = <lst_soc_name>-name_text. "Spciety Name
  ENDIF. " IF sy-subrc EQ 0
* Relationship Category: Text
  READ TABLE fp_li_rel_catg ASSIGNING FIELD-SYMBOL(<lst_rel_catg>)
       WITH KEY reltyp = lst_rep_lout-rltyp
       BINARY SEARCH.
  IF sy-subrc EQ 0.
    lst_rep_lout-rlc_text  = <lst_rel_catg>-rtitl. "Relationship Category: Text
  ENDIF. " IF sy-subrc EQ 0

  lst_rep_lout-kstbm       = fp_lst_1d_scale-kstbm. "Condition scale quantity
  lst_rep_lout-konwa       = fp_lst_list_prc-konwa. "Rate unit (currency or percentage)

  IF fp_lst_1d_scale-kbetr IS NOT INITIAL.
    lst_rep_lout-list_prc  = fp_lst_1d_scale-kbetr. "List Price (Scales)
  ELSE. " ELSE -> IF fp_lst_1d_scale-kbetr IS NOT INITIAL
    lst_rep_lout-list_prc  = fp_lst_list_prc-kbetr. "List Price
  ENDIF. " IF fp_lst_1d_scale-kbetr IS NOT INITIAL

*     lst_rep_lout-net_prc_a   = kbetr,                         "NET Price for Agent Discount
*     lst_rep_lout-net_prc_d   = kbetr,                         "NET Price Agent Discount and DDP

  lst_rep_lout-net_prc_s   = lst_rep_lout-list_prc + "NET Price for Standard Discount
  ( lst_rep_lout-list_prc * fp_lst_discount-kbetr / 1000 ).
*Begin of ADD:CR#6341 RTR20180614  ED2K912278
  IF fp_lst_val_text IS NOT INITIAL  AND fp_lst_discount-kschl = c_zmys
    AND fp_lst_discount-rltyp IS NOT INITIAL.
    CONCATENATE fp_lst_discount-kschl c_a950
      INTO lst_rep_lout-bezei SEPARATED BY '/'.
    MOVE fp_lst_val_text-bezei TO lst_rep_lout-bezei1. " Move Validity text to output table for IDOC
    MOVE fp_lst_val_text-vlaufk TO lst_rep_lout-vlaufk.
  ELSEIF fp_lst_val_text IS NOT INITIAL  AND fp_lst_discount-kschl = c_zmys
  AND fp_lst_discount-rltyp IS  INITIAL.
    CONCATENATE fp_lst_discount-kschl c_a951
    INTO lst_rep_lout-bezei SEPARATED BY '/'.
    MOVE fp_lst_val_text-bezei TO lst_rep_lout-bezei1. " Move Validity text to output table for IDOC
    MOVE fp_lst_val_text-vlaufk TO lst_rep_lout-vlaufk.

  ELSEIF fp_lst_discount-kschl  =  c_ct_zsd1 AND fp_lst_discount-matnr IS NOT INITIAL.
    CONCATENATE fp_lst_discount-kschl c_a937 INTO lst_rep_lout-bezei SEPARATED BY '/'.
  ELSEIF fp_lst_discount-kschl  =  c_ct_zsd1 AND fp_lst_discount-matnr IS  INITIAL.
    CONCATENATE fp_lst_discount-kschl c_a923 INTO lst_rep_lout-bezei SEPARATED BY '/'.
  ENDIF. " IF fp_lst_val_text IS NOT INITIAL AND fp_lst_discount-kschl = c_zmys
  IF fp_lst_discount-kschl IS NOT INITIAL.
    MOVE fp_lst_discount-kschl TO lst_rep_lout-kschl.
  ENDIF. " IF fp_lst_discount-kschl IS NOT INITIAL
*END of ADD:CR#6341 RTR20180614  ED2K912278

* Convert to Whole value (List Price)
  lv_prc_int               = lst_rep_lout-list_prc.
  lst_rep_lout-list_prc    = lv_prc_int. "List Price
* Convert to Whole value (NET Price)
  lv_prc_int               = lst_rep_lout-net_prc_s.
  lst_rep_lout-net_prc_s   = lv_prc_int. "NET Price

  IF fp_lst_discount-kbetr IS NOT INITIAL AND
     rb_lib_e              IS NOT INITIAL.
    lst_rep_lout-np_ind    = abap_true. "Flag: Net Price
  ENDIF. " IF fp_lst_discount-kbetr IS NOT INITIAL AND
* End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908

  lst_rep_lout-datbi       = fp_lst_list_prc-datbi. "Validity end date of the condition record
  lst_rep_lout-datab       = fp_lst_list_prc-datab. "Validity start date of the condition record
  lst_rep_lout-line_scal   = fp_lst_1d_scale-line_scal. "Current number of the line scale

  READ TABLE fp_li_idcdasgn ASSIGNING FIELD-SYMBOL(<lst_idcdasgn>)
       WITH KEY matnr = lst_rep_lout-matnr
       BINARY SEARCH.
  IF sy-subrc EQ 0.
    lst_rep_lout-identcode = <lst_idcdasgn>-identcode. "Identification Code
  ENDIF. " IF sy-subrc EQ 0

  IF lst_rep_lout-rltyp     IS NOT INITIAL AND
     lst_rep_lout-soc_numbr IS NOT INITIAL.
    CONCATENATE lst_rep_lout-rltyp
                lst_rep_lout-soc_numbr
           INTO lst_rep_lout-reltyp_sn "Rel Category and Society number
    SEPARATED BY c_f_slash.
  ENDIF. " IF lst_rep_lout-rltyp IS NOT INITIAL AND

  IF lst_rep_lout-knuma_ag EQ c_inst_rate. "Institutional Rate
    lst_rep_lout-ipm_ind = c_flg_srt_1.
  ENDIF. " IF lst_rep_lout-knuma_ag EQ c_inst_rate
  IF lst_rep_lout-knuma_ag EQ c_pers_rate. "Personal Rate
    lst_rep_lout-ipm_ind = c_flg_srt_2.
  ENDIF. " IF lst_rep_lout-knuma_ag EQ c_pers_rate
  IF lst_rep_lout-knuma_ag EQ c_memb_rate. "Member Rate
    lst_rep_lout-ipm_ind = c_flg_srt_3.
  ENDIF. " IF lst_rep_lout-knuma_ag EQ c_memb_rate

* Validate Selection Criteria
  IF lst_rep_lout-matnr     IN s_matnr AND "Material Number
     lst_rep_lout-mstae     IN s_mstae AND "X-Plant Material Status
     lst_rep_lout-rltyp     IN s_rltyp AND "Relationship Category
     lst_rep_lout-soc_numbr IN s_sc_no AND "Society Number
     lst_rep_lout-kdgrp     IN s_kdgrp AND "Customer Group
     lst_rep_lout-reltyp_sn IN s_rc_sn.    "Rel Category and Society number

*   Exclude Pricing Only
    IF ( lst_rep_lout-matnr     IN s_matnr1 AND s_matnr1 IS NOT INITIAL ) OR
       ( lst_rep_lout-mstae     IN s_mstae1 AND s_mstae1 IS NOT INITIAL ) OR
       ( lst_rep_lout-mtart     IN s_mtart1 AND s_mtart1 IS NOT INITIAL ) OR
       ( lst_rep_lout-mediatype IN s_mdtyp1 AND s_mdtyp1 IS NOT INITIAL ) OR
       ( lst_rep_lout-kdgrp     IN s_kdgrp1 AND s_kdgrp1 IS NOT INITIAL ) OR
*      Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
       ( lst_rep_lout-soc_numbr IN s_sc_no1 AND s_sc_no1 IS NOT INITIAL ).
*      End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
*      Begin of DEL:CR#565:WROY:08-JUL-2017:ED2K904908
*      ( lst_rep_lout-reltyp_sn IN s_rc_sn1 AND s_rc_sn1 IS NOT INITIAL ).
*      End   of DEL:CR#565:WROY:08-JUL-2017:ED2K904908
      CLEAR: lst_rep_lout-list_prc,
             lst_rep_lout-net_prc_s.
      lst_rep_lout-excld_prc = abap_true. "Exclude Pricing
    ENDIF. " IF ( lst_rep_lout-matnr IN s_matnr1 AND s_matnr1 IS NOT INITIAL ) OR
*   Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
    CLEAR: lv_filter.
*   Exclude Pricing Only - File Records
    PERFORM f_excld_pricing USING    fp_li_m_rs_wm1
                                     fp_li_m_rc_sn1
                                     fp_li_m_sn_pt1
                                     fp_li_m_rltyp1
                                     fp_li_m_prtyp1
                                     lst_rep_lout
                            CHANGING lv_filter.
    IF lv_filter EQ abap_true.
      CLEAR: lst_rep_lout-list_prc,
             lst_rep_lout-net_prc_s.
      lst_rep_lout-excld_prc = abap_true. "Exclude Pricing
    ENDIF. " IF lv_filter EQ abap_true
*   End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
*   Begin of ADD:ERP-6324:WROY:28-JUN-2018:ED2K912466
    IF fp_lst_list_prc-excld_prc EQ abap_true.
      CLEAR: lst_rep_lout-list_prc,
             lst_rep_lout-net_prc_s.
      lst_rep_lout-excld_prc = abap_true. "Exclude Pricing
    ENDIF. " IF fp_lst_list_prc-excld_prc EQ abap_true
    lst_rep_lout-price_nm = fp_lst_list_prc-price_nm. "Price Not Maintained
*   End   of ADD:ERP-6324:WROY:28-JUN-2018:ED2K912466

*   Exclude Pricing and Products
    IF ( lst_rep_lout-matnr     IN s_matnr2 AND s_matnr2 IS NOT INITIAL ) OR
       ( lst_rep_lout-mstae     IN s_mstae2 AND s_mstae2 IS NOT INITIAL ) OR
       ( lst_rep_lout-mtart     IN s_mtart2 AND s_mtart2 IS NOT INITIAL ) OR
       ( lst_rep_lout-mediatype IN s_mdtyp2 AND s_mdtyp2 IS NOT INITIAL ) OR
       ( lst_rep_lout-kdgrp     IN s_kdgrp2 AND s_kdgrp2 IS NOT INITIAL ) OR
*      Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
       ( lst_rep_lout-soc_numbr IN s_sc_no2 AND s_sc_no2 IS NOT INITIAL ).
*      End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
*      Begin of DEL:CR#565:WROY:08-JUL-2017:ED2K904908
*      ( lst_rep_lout-reltyp_sn IN s_rc_sn2 AND s_rc_sn2 IS NOT INITIAL ).
*      End   of DEL:CR#565:WROY:08-JUL-2017:ED2K904908
    ELSE. " ELSE -> IF ( lst_rep_lout-matnr IN s_matnr2 AND s_matnr2 IS NOT INITIAL ) OR
*     Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
      CLEAR: lv_filter.
*     Exclude Pricing and Products - File Records
      PERFORM f_excld_prc_n_prd USING  fp_li_m_rs_wm2
                                       fp_li_m_rc_sn2
                                       fp_li_m_sn_pt2
                                       fp_li_m_rltyp2
                                       fp_li_m_prtyp2
                                       lst_rep_lout
                              CHANGING lv_filter.
      IF lv_filter IS INITIAL.
*     End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
        APPEND lst_rep_lout TO fp_li_rep_lout.
*     Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
      ENDIF. " IF lv_filter IS INITIAL
*     End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
    ENDIF. " IF ( lst_rep_lout-matnr IN s_matnr2 AND s_matnr2 IS NOT INITIAL ) OR

  ENDIF. " IF lst_rep_lout-matnr IN s_matnr AND

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_IDOC_CNTRL_REC
*&---------------------------------------------------------------------*
*       Populate IDOC Control Record
*----------------------------------------------------------------------*
*      -->FP_M_TYPE  text
*      -->FP_I_TYPE  text
*      <--FP_LST_EDIDC  text
*----------------------------------------------------------------------*
FORM f_idoc_cntrl_rec  USING    fp_m_type    TYPE edi_mestyp
                                fp_i_type    TYPE edi_idoctp
                       CHANGING fp_lst_edidc TYPE edidc. " Control record (IDoc)

* Populate EDIDC Data
  fp_lst_edidc-direct = c_dir_out. "Direction for IDoc-Outbound(1)
  fp_lst_edidc-mestyp = fp_m_type. "Message Type-'ZPDM_PRICE_FEED'
  fp_lst_edidc-idoctp = fp_i_type. "IDOC Type-'ZPDMB_PRICE_FEED01'

* Fetch details from Partner Profile: Outbound (technical parameters)
  SELECT rcvprn                  "Partner Number of Receiver
         rcvprt                  "Partner Type of Receiver
         rcvpor                  "Receiver port
    FROM edp13                   "Partner Profile: Outbound (technical parameters)
   UP TO 1 ROWS
    INTO ( fp_lst_edidc-rcvprn,  "Partner Number of Receiver
           fp_lst_edidc-rcvprt,  "Partner Type of Receiver
           fp_lst_edidc-rcvpor ) "Receiver port
   WHERE mestyp EQ fp_m_type.
  ENDSELECT.
  IF sy-subrc NE 0.
    CLEAR: fp_lst_edidc-rcvprn, "Partner Number of Receiver
           fp_lst_edidc-rcvprt, "Partner Type of Receiver
           fp_lst_edidc-rcvpor. "Receiver port
  ENDIF. " IF sy-subrc NE 0

  CONCATENATE c_sys_sap
              sy-sysid
              INTO fp_lst_edidc-sndpor. "Sender port
  CONDENSE fp_lst_edidc-sndpor.

  fp_lst_edidc-sndprt = c_p_typ_l. "Partner Type: Logical Syatem (LS).

* Get sender information (Current System)
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system             = fp_lst_edidc-sndprn "Partner Number of Sender
    EXCEPTIONS
      own_logical_system_not_defined = 1
      OTHERS                         = 2.
* If not found , pass blank entry
  IF sy-subrc IS NOT INITIAL.
    CLEAR fp_lst_edidc-sndprn.
  ENDIF. " IF sy-subrc IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_REPORT
*&---------------------------------------------------------------------*
*       Display Report
*----------------------------------------------------------------------*
*      -->fP_LI_REP_LOUT  text
*----------------------------------------------------------------------*
FORM f_display_report  USING    fp_li_rep_lout TYPE tt_rep_lout.

  DATA:
    lv_col_pos   TYPE i. "Column Position

  DATA:
    li_fieldcat  TYPE slis_t_fieldcat_alv, "Field catalog with field descriptions
    li_sort_flds TYPE slis_t_sortinfo_alv. "Sort criteria for first list display

  DATA:
    lst_layout   TYPE slis_layout_alv. "List layout specifications

  CONSTANTS:
    lc_fld_matnr  TYPE slis_fieldname VALUE 'MATNR',     "Field: Material Number
    lc_fld_mstae  TYPE slis_fieldname VALUE 'MSTAE',     "Field: Material Status
    lc_fld_mtart  TYPE slis_fieldname VALUE 'MTART',     "Field: Material Type
    lc_fld_bom_i  TYPE slis_fieldname VALUE 'BOM_INFO',  "Field: BOM Info
    lc_fld_hd_cm  TYPE slis_fieldname VALUE 'HDR_COMP',  "Field: BOM Component / Header
    lc_fld_extwg  TYPE slis_fieldname VALUE 'EXTWG',     "Field: Journal Group code
    lc_fld_maktx  TYPE slis_fieldname VALUE 'MAKTX',     "Field: Full Title
    lc_fld_mtype  TYPE slis_fieldname VALUE 'MEDIATYPE', "Field: Media Type
    lc_fld_prtyp  TYPE slis_fieldname VALUE 'KNUMA_AG',  "Field: Price Type
    lc_fld_pltyp  TYPE slis_fieldname VALUE 'PLTYP',     "Field: Price List Type
    lc_fld_kdgrp  TYPE slis_fieldname VALUE 'KDGRP',     "Field: Customer Group
    lc_fld_pbtyp  TYPE slis_fieldname VALUE 'PUBLTYPE',  "Field: Publication Type
    lc_fld_rcatg  TYPE slis_fieldname VALUE 'RLTYP',     "Field: Relationship Category
    lc_fld_scnum  TYPE slis_fieldname VALUE 'SOC_NUMBR', "Field: Society Number
    lc_fld_kstbm  TYPE slis_fieldname VALUE 'KSTBM',     "Field: FTE Range From
    lc_fld_konwa  TYPE slis_fieldname VALUE 'KONWA',     "Field: Currency
    lc_fld_lstpr  TYPE slis_fieldname VALUE 'LIST_PRC',  "Field: List Price
    lc_fld_nprsd  TYPE slis_fieldname VALUE 'NET_PRC_S', "Field: NET Price for Standard Discount
    lc_fld_datab  TYPE slis_fieldname VALUE 'DATBI',     "Field: Validity Date - From
    lc_fld_datbi  TYPE slis_fieldname VALUE 'DATAB',     "Field: Validity Date - to
    lc_fld_m_due  TYPE slis_fieldname VALUE 'MEMB_DUE',  "Field: Membership Due
    lc_fld_level  TYPE slis_fieldname VALUE 'LEVEL',     "Field: Print Only(1)/Online Only(2)/Print + Online(3)
* Begin of ADD:CR#6341 RTR20180614 ED2K912278
    lc_fld_bezei  TYPE slis_fieldname VALUE 'BEZEI',
    lc_fld_bezei1 TYPE slis_fieldname VALUE 'BEZEI1',
    lc_fld_kschl  TYPE slis_fieldname VALUE 'KSCHL',
* END of ADD:CR#6341 RTR20180614  ED2K912278
    lc_em_alpha   TYPE slis_edit_mask VALUE '==ALPHA',
    lc_em_matn1   TYPE slis_edit_mask VALUE '==MATN1',

    lc_form_pfs   TYPE slis_formname  VALUE 'F_SET_PF_STATUS',
    lc_form_usc   TYPE slis_formname  VALUE 'F_SET_USR_COMND'.

* List layout specifications
  lst_layout-zebra             = abap_true. "Striped pattern
  lst_layout-colwidth_optimize = abap_true. "Column Width Optimization

  CLEAR: lv_col_pos.
* Populate Field catalog with field descriptions
  PERFORM f_populate_field_cat:
    USING lc_fld_extwg 'Journal Group code'(a05) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_matnr 'Material Number'(a01) lc_em_matn1 space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_mstae 'Material Status'(a02) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_mtart 'Material Type'(a03) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_bom_i 'BOM Info'(a04) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_maktx 'Full Title'(a06) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_mtype 'Media Type'(a07) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_prtyp 'Price Type'(a08) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_kdgrp 'Customer Group'(a10) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_pbtyp 'Publication Type'(a21) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_rcatg 'Relationship Category'(a11) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_scnum 'Society Number'(a12) lc_em_alpha space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_pltyp 'Price List Type'(a09) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_kstbm 'FTE Range From'(a13) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_konwa 'Currency'(a14) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_lstpr 'List Price'(a15) space lc_fld_konwa
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_nprsd 'NET Price for Standard Discount'(a16) space lc_fld_konwa " ID for the standard view
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_datbi 'Validity Date - From'(a17) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_datab 'Validity Date - to'(a18) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_hd_cm 'BOM Header/Components'(a19) space space
 CHANGING lv_col_pos li_fieldcat,
    USING lc_fld_m_due 'Membership Due'(a20) space space
 CHANGING lv_col_pos li_fieldcat,
* Begin of ADD:CR#6341 RTR20180614 ED2K912278
    USING lc_fld_bezei 'Discount Text'(a22) space space
 CHANGING lv_col_pos li_fieldcat,
   USING lc_fld_bezei1 'Validity Period'(a23) space space
 CHANGING lv_col_pos li_fieldcat.
* END of ADD:CR#6341 RTR20180614  ED2K912278
*  SORT fp_li_rep_lout BY alpha_sep extwg kdgrp member ipm_ind rltyp soc_numbr level pltyp line_scal. "BEGIN OF DEL :CR#6341 RTR20180614  ED2K912278
  SORT fp_li_rep_lout BY alpha_sep extwg kdgrp member ipm_ind rltyp soc_numbr level pltyp line_scal vlaufk. "BEGIN OF DEL :CR#6341 RTR20180614  ED2K912278
*  CLEAR: lv_col_pos.
** Populate Sort criteria for first list display
*  PERFORM f_populate_sort_field:
*    USING lc_fld_extwg CHANGING lv_col_pos li_sort_flds,
*    USING lc_fld_matnr CHANGING lv_col_pos li_sort_flds,
*    USING lc_fld_kdgrp CHANGING lv_col_pos li_sort_flds,
*    USING lc_fld_rcatg CHANGING lv_col_pos li_sort_flds,
*    USING lc_fld_scnum CHANGING lv_col_pos li_sort_flds,
*    USING lc_fld_pltyp CHANGING lv_col_pos li_sort_flds,
*    USING lc_fld_level CHANGING lv_col_pos li_sort_flds.

* Display ALV Grid
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid       "Name of the calling program
      is_layout                = lst_layout     "List layout specifications
      it_fieldcat              = li_fieldcat    "Field catalog with field descriptions
      it_sort                  = li_sort_flds   "Sort criteria for first list display
      i_callback_pf_status_set = lc_form_pfs
      i_callback_user_command  = lc_form_usc
    TABLES
      t_outtab                 = fp_li_rep_lout "Table with data to be displayed
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc NE 0.
*   Error Message
    MESSAGE ID sy-msgid  "Message Class
          TYPE c_msgty_i "Message Type: Information
        NUMBER sy-msgno  "Message Number
          WITH sy-msgv1  "Message Variable-1
               sy-msgv2  "Message Variable-2
               sy-msgv3  "Message Variable-3
               sy-msgv4. "Message Variable-4
  ENDIF. " IF sy-subrc NE 0

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_FIELD_CAT
*&---------------------------------------------------------------------*
*       Populate Field Catalog (ALV)
*----------------------------------------------------------------------*
*      -->FP_FIELD_NAME   Field Name
*      -->FP_FIELD_DESC   Field Description
*      -->FP_EDIT_MASK    Edit Mask
*      -->FP_CFIELDNAME   Currency Field Name
*      <--FP_LV_COL_POS   Column Position
*      <--FP_LI_FIELDCAT  Field Catalog
*----------------------------------------------------------------------*
FORM f_populate_field_cat  USING    fp_field_name  TYPE slis_fieldname
                                    fp_field_desc  TYPE any
                                    fp_edit_mask   TYPE slis_edit_mask
                                    fp_cfieldname  TYPE slis_fieldname
                           CHANGING fp_lv_col_pos  TYPE i " Lv_col_pos of type Integers
                                    fp_li_fieldcat TYPE slis_t_fieldcat_alv.

  fp_lv_col_pos = fp_lv_col_pos + 1. "Calculate Column Position
  APPEND INITIAL LINE TO fp_li_fieldcat ASSIGNING FIELD-SYMBOL(<lst_fieldcat>).
  <lst_fieldcat>-col_pos    = fp_lv_col_pos. "Column Position
  <lst_fieldcat>-fieldname  = fp_field_name. "Field Name
  <lst_fieldcat>-seltext_l  = fp_field_desc. "Field Description
  <lst_fieldcat>-seltext_m  = fp_field_desc. "Field Description
  <lst_fieldcat>-seltext_s  = fp_field_desc. "Field Description
  <lst_fieldcat>-edit_mask  = fp_edit_mask. "Edit Mask
  <lst_fieldcat>-cfieldname = fp_cfieldname. "Currency Field Name

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_SORT_FIELD
*&---------------------------------------------------------------------*
*       Populate Sort criteria for first list display
*----------------------------------------------------------------------*
*      -->FP_FIELD_NAME   Field Name
*      <--FP_LV_COL_POS   Column Position
*      <--FP_LI_SORT_FLDS Sort Fields
*----------------------------------------------------------------------*
FORM f_populate_sort_field  USING    fp_field_name   TYPE slis_fieldname
                            CHANGING fp_lv_col_pos   TYPE i " Lv_col_pos of type Integers
                                     fp_li_sort_flds TYPE slis_t_sortinfo_alv.

  fp_lv_col_pos = fp_lv_col_pos + 1. "Calculate Column Position
  APPEND INITIAL LINE TO fp_li_sort_flds ASSIGNING FIELD-SYMBOL(<lst_sort_fld>).
  <lst_sort_fld>-spos       = fp_lv_col_pos. "Column Position
  <lst_sort_fld>-fieldname  = fp_field_name. "Field Name

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DEFAULT_VALUES
*&---------------------------------------------------------------------*
*       Populate Default values of Selection Screen fields
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_default_values .

* Material Type: ZSBE - Journal Media Product
  APPEND INITIAL LINE TO s_mtarta ASSIGNING FIELD-SYMBOL(<lst_mtart>).
  <lst_mtart>-sign   = c_sign_i.
  <lst_mtart>-option = c_opti_eq.
  <lst_mtart>-low    = c_mt_zsbe.
* Material Type: ZWOL - WOL database & collection
  APPEND INITIAL LINE TO s_mtarta ASSIGNING <lst_mtart>.
  <lst_mtart>-sign   = c_sign_i.
  <lst_mtart>-option = c_opti_eq.
  <lst_mtart>-low    = c_mt_zwol.
* Material Type: ZMJL - Multi Journal Package
  APPEND INITIAL LINE TO s_mtarta ASSIGNING <lst_mtart>.
  <lst_mtart>-sign   = c_sign_i.
  <lst_mtart>-option = c_opti_eq.
  <lst_mtart>-low    = c_mt_zmjl.
* Material Type: ZMMJ - Multi Media
  APPEND INITIAL LINE TO s_mtarta ASSIGNING <lst_mtart>.
  <lst_mtart>-sign   = c_sign_i.
  <lst_mtart>-option = c_opti_eq.
  <lst_mtart>-low    = c_mt_zmmj.

* Material Type: ZMJL - Multi Journal Package
  APPEND INITIAL LINE TO s_mtartb ASSIGNING <lst_mtart>.
  <lst_mtart>-sign   = c_sign_i.
  <lst_mtart>-option = c_opti_eq.
  <lst_mtart>-low    = c_mt_zmjl.
* Material Type: ZMMJ - Multi Media
  APPEND INITIAL LINE TO s_mtartb ASSIGNING <lst_mtart>.
  <lst_mtart>-sign   = c_sign_i.
  <lst_mtart>-option = c_opti_eq.
  <lst_mtart>-low    = c_mt_zmmj.

* Condition Type: ZLPR - List Price
  APPEND INITIAL LINE TO s_kschlp ASSIGNING FIELD-SYMBOL(<lst_kschl>).
  <lst_kschl>-sign   = c_sign_i.
  <lst_kschl>-option = c_opti_eq.
  <lst_kschl>-low    = c_ct_zlpr.

* Condition Type: ZSD1 - Std Disc Product  %
  APPEND INITIAL LINE TO s_kschld ASSIGNING <lst_kschl>.
  <lst_kschl>-sign   = c_sign_i.
  <lst_kschl>-option = c_opti_eq.
  <lst_kschl>-low    = c_ct_zsd1.
* Condition Type: ZAJD - Agent Std.Discount %
  APPEND INITIAL LINE TO s_kschld ASSIGNING <lst_kschl>.
  <lst_kschl>-sign   = c_sign_i.
  <lst_kschl>-option = c_opti_eq.
  <lst_kschl>-low    = c_ct_zajd.
* Condition Type: ZDDP - Deep Discounting %
  APPEND INITIAL LINE TO s_kschld ASSIGNING <lst_kschl>.
  <lst_kschl>-sign   = c_sign_i.
  <lst_kschl>-option = c_opti_eq.
  <lst_kschl>-low    = c_ct_zddp.
*Begin Of Add:CR6341 RTR20180614 ED2K912278
* Condition Type: ZMYS - Discounting %
  APPEND INITIAL LINE TO s_kschld ASSIGNING <lst_kschl>.
  <lst_kschl>-sign   = c_sign_i.
  <lst_kschl>-option = c_opti_eq.
  <lst_kschl>-low    = c_ct_zmys.
*End Of Add:CR6341 RTR20180614 ED2K912278
* Characteristic (New Start Title) - JPSNT
  CALL FUNCTION 'CONVERSION_EXIT_ATINN_INPUT'
    EXPORTING
      input  = c_ch_jpsnt
    IMPORTING
      output = p_ns_ttl.
* Characteristic (Merged With)  - JPSMW
  CALL FUNCTION 'CONVERSION_EXIT_ATINN_INPUT'
    EXPORTING
      input  = c_ch_jpsmw
    IMPORTING
      output = p_megd_w.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SOCIETY_NAME
*&---------------------------------------------------------------------*
*       Fetch Society Name
*----------------------------------------------------------------------*
*      -->FP_LI_LIST_PRC  text
*      -->FP_LI_DISCOUNT  text
*      <--FP_LI_SOC_NAME  text
*      <--FP_LI_REL_CATG  text
*----------------------------------------------------------------------*
FORM f_society_name  USING    fp_li_list_prc TYPE tt_list_prc
                              fp_li_discount TYPE tt_discount
                     CHANGING fp_li_soc_name TYPE tt_soc_name
                              fp_li_rel_catg TYPE tt_rel_catg.

  DATA:
    li_list_prc TYPE tt_list_prc.

  li_list_prc[] = fp_li_list_prc[].
  LOOP AT fp_li_discount ASSIGNING FIELD-SYMBOL(<lst_discount>).
    APPEND INITIAL LINE TO li_list_prc ASSIGNING FIELD-SYMBOL(<lst_list_prc>).
    <lst_list_prc>-soc_numbr = <lst_discount>-soc_numbr.
  ENDLOOP. " LOOP AT fp_li_discount ASSIGNING FIELD-SYMBOL(<lst_discount>)
  DELETE li_list_prc WHERE soc_numbr IS INITIAL.

  IF li_list_prc IS NOT INITIAL.
    SORT li_list_prc BY soc_numbr.
    DELETE ADJACENT DUPLICATES FROM li_list_prc COMPARING soc_numbr.

*   Fetch BP: General data
    SELECT kunnr "Customer Number
           name1 "Name 1
           name2 "Name 2  "+ <HIPATEL> <INC0207303> <ED1K908211>
           name3 "Name 3
      FROM kna1  " General Data in Customer Master
      INTO TABLE fp_li_soc_name
       FOR ALL ENTRIES IN li_list_prc
     WHERE kunnr EQ li_list_prc-soc_numbr
      ORDER BY PRIMARY KEY.
    IF sy-subrc NE 0.
      CLEAR: fp_li_soc_name.
    ENDIF. " IF sy-subrc NE 0
  ENDIF. " IF li_list_prc IS NOT INITIAL

  li_list_prc[] = fp_li_list_prc[].
  LOOP AT fp_li_discount ASSIGNING <lst_discount>.
    APPEND INITIAL LINE TO li_list_prc ASSIGNING <lst_list_prc>.
    <lst_list_prc>-rltyp = <lst_discount>-rltyp.
  ENDLOOP. " LOOP AT fp_li_discount ASSIGNING <lst_discount>
  DELETE li_list_prc WHERE rltyp IS INITIAL.

  IF li_list_prc IS NOT INITIAL.
    SORT li_list_prc BY rltyp.
    DELETE ADJACENT DUPLICATES FROM li_list_prc COMPARING rltyp.

*   Fetch BP Relationship Categories: Texts
    SELECT reltyp "Business Partner Relationship Category
           xrf    "Business partner role definition instead of BP relationship
           rtitl  "Title of Object Part
      FROM tbz9a  " BP Relationship Categories: Texts
      INTO TABLE fp_li_rel_catg
       FOR ALL ENTRIES IN li_list_prc
     WHERE reltyp EQ li_list_prc-rltyp
       AND spras  EQ sy-langu.
    IF sy-subrc EQ 0.
      SORT fp_li_rel_catg BY reltyp.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_list_prc IS NOT INITIAL

ENDFORM.
FORM f_set_pf_status USING fp_lt_extab TYPE slis_t_extab..

  CASE abap_true.
    WHEN rb_jps_x.
      v_bt_txt = 'JPS XML'(bt1).
    WHEN rb_lib_e.
      v_bt_txt = 'Librarian XLSX'(bt2).
  ENDCASE.

  SET PF-STATUS 'STANDARD_ALV'.

ENDFORM.

FORM f_set_usr_comnd USING fp_v_ucomm     TYPE syucomm " Function Code
                           fp_st_selfield TYPE slis_selfield.

  CASE fp_v_ucomm.
    WHEN 'PROC'.
      CASE abap_true.
        WHEN rb_jps_x.
*         Create IDOC (XML) for JPS
          PERFORM f_create_idoc_jps USING i_rep_lout
                                          i_bom_detls.
        WHEN rb_lib_e.
*         Create Excel file for Librarians
          PERFORM f_create_xcel_lib USING i_rep_lout
                                          i_bom_detls.
      ENDCASE.

    WHEN OTHERS.
*     Do Nothing
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEGMENT_PRICE
*&---------------------------------------------------------------------*
*       Populate Price Segment
*----------------------------------------------------------------------*
*      -->FP_LST_REP_LOUT  text
*      -->FP_LV_P_SEGN_C  text
*      <--FP_LST_PRICE  text
*      <--FP_LV_C_SEGNUM  text
*      <--FP_LI_EDIDD  text
*----------------------------------------------------------------------*
FORM f_segment_price  USING    fp_lst_rep_lout TYPE ty_rep_lout
                               fp_lv_p_segn_c  TYPE edi_psgnum  " Number of the hierarchically higher SAP segment
                      CHANGING fp_lst_price    TYPE z1pdm_price " I0225: Price Details
                               fp_lv_c_segnum  TYPE idocdsgnum  " Number of SAP segment
                               fp_li_edidd     TYPE edidd_tt.

  DATA:
    lv_rlc_text TYPE bu_rtitl. " Title of Object Part

  IF fp_lst_rep_lout-kdgrp IN s_kdgrpi  .
    IF fp_lst_rep_lout-vlaufk IS NOT INITIAL. "CR#6341 RTR20180614  ED2K912278
      CONCATENATE 'Institutional'(kg1)  fp_lst_rep_lout-bezei1
        INTO fp_lst_price-column01  SEPARATED BY space. "CR#6341 RTR20180614  ED2K912278
    ELSE. " ELSE -> IF fp_lst_rep_lout-vlaufk IS NOT INITIAL
      fp_lst_price-column01 = 'Institutional'(kg1).
    ENDIF. " IF fp_lst_rep_lout-vlaufk IS NOT INITIAL
* Begin of ADD:INC0207296:SGUDA:21-August-2018:ED2K912991
*  ELSE. " ELSE -> IF fp_lst_rep_lout-kdgrp IN s_kdgrpi
*    IF  fp_lst_rep_lout-vlaufk IS NOT INITIAL. "CR#6341 RTR20180614  ED2K912278
*      CONCATENATE 'Institutional'(kg1)  fp_lst_rep_lout-bezei1
*      INTO fp_lst_price-column01 SEPARATED BY space . "CR#6341 RTR20180614  ED2K912278
*    ELSE. " ELSE -> IF fp_lst_rep_lout-vlaufk IS NOT INITIAL
*      fp_lst_price-column01 = 'Institutional'(kg1).
*    ENDIF. " IF fp_lst_rep_lout-vlaufk IS NOT INITIAL
* End of ADD:INC0207296:SGUDA:21-August-2018:ED2K912991
  ENDIF. " IF fp_lst_rep_lout-kdgrp IN s_kdgrpi
  IF fp_lst_rep_lout-kdgrp IN s_kdgrpp . "CR#6341 RTR20180614  ED2K912278
    IF  fp_lst_rep_lout-vlaufk IS NOT INITIAL.
      CONCATENATE 'Personal'(kg2)  fp_lst_rep_lout-bezei1
        INTO fp_lst_price-column01 SEPARATED BY space .
    ELSE. " ELSE -> IF fp_lst_rep_lout-vlaufk IS NOT INITIAL
      fp_lst_price-column01 = 'Personal'(kg2).
    ENDIF. " IF fp_lst_rep_lout-vlaufk IS NOT INITIAL
* Begin of ADD:INC0207296:SGUDA:21-August-2018:ED2K912991
*  ELSE. " ELSE -> IF fp_lst_rep_lout-kdgrp IN s_kdgrpp
*    IF  fp_lst_rep_lout-vlaufk IS NOT INITIAL. "CR#6341 RTR20180614  ED2K912278
*      CONCATENATE 'Personal'(kg2)  fp_lst_rep_lout-bezei1
*       INTO fp_lst_price-column01 SEPARATED BY space .
*    ELSE. " ELSE -> IF fp_lst_rep_lout-vlaufk IS NOT INITIAL
*      fp_lst_price-column01 = 'Personal'(kg2).
*    ENDIF. " IF fp_lst_rep_lout-vlaufk IS NOT INITIAL
* End of ADD:INC0207296:SGUDA:21-August-2018:ED2K912991
  ENDIF. " IF fp_lst_rep_lout-kdgrp IN s_kdgrpp

  IF fp_lst_rep_lout-reltyp_sn IS NOT INITIAL.
*   Check exceptions from Application Constant table
    READ TABLE i_constants ASSIGNING FIELD-SYMBOL(<lst_constant>)
         WITH KEY param1 = c_param_rcd
                  param2 = fp_lst_rep_lout-rltyp
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      lv_rlc_text = <lst_constant>-low. "Relationship Category: Text
      IF <lst_constant>-high IS INITIAL. "Only Relationship Category: Text
*        "BEGIN OF ADD:CR#6341 RTR20180614  ED2K912278
        IF fp_lst_rep_lout-vlaufk IS NOT INITIAL.
          CONCATENATE lv_rlc_text fp_lst_rep_lout-bezei1
            INTO lv_rlc_text SEPARATED BY space.
          fp_lst_price-column01 = lv_rlc_text. "END OF ADD:CR#6341 RTR20180614  ED2K912278
        ELSE. " ELSE -> IF fp_lst_rep_lout-vlaufk IS NOT INITIAL
          fp_lst_price-column01 = lv_rlc_text.
        ENDIF. " IF fp_lst_rep_lout-vlaufk IS NOT INITIAL
      ELSE. " ELSE -> IF <lst_constant>-high IS INITIAL
        "BEGIN OF ADD:CR#6341 RTR20180614  ED2K912278
        IF fp_lst_rep_lout-vlaufk IS NOT INITIAL.
          CONCATENATE fp_lst_rep_lout-soc_name "Society Name
                      lv_rlc_text              "Relationship Category: Text
                      fp_lst_rep_lout-bezei1
                 INTO fp_lst_price-column01
            SEPARATED BY space.
        ELSE. " ELSE -> IF fp_lst_rep_lout-vlaufk IS NOT INITIAL
          CONCATENATE fp_lst_rep_lout-soc_name "Society Name
                      lv_rlc_text              "Relationship Category: Text
                 INTO fp_lst_price-column01
            SEPARATED BY space.
        ENDIF. " IF fp_lst_rep_lout-vlaufk IS NOT INITIAL
      ENDIF. " IF <lst_constant>-high IS INITIAL
    ELSE. " ELSE -> IF sy-subrc EQ 0
*     Relationship Category: Text
      IF fp_lst_rep_lout-rlc_text IS NOT INITIAL.
        lv_rlc_text = fp_lst_rep_lout-rlc_text.
      ELSE. " ELSE -> IF fp_lst_rep_lout-rlc_text IS NOT INITIAL
        lv_rlc_text = 'Member'(kg3).
      ENDIF. " IF fp_lst_rep_lout-rlc_text IS NOT INITIAL
*     Begin of ADD:CR#6341 RTR20180614  ED2K912278
      IF fp_lst_rep_lout-vlaufk IS NOT INITIAL.
        CONCATENATE fp_lst_rep_lout-soc_name "Society Name
                    lv_rlc_text              "Relationship Category: Text
                    fp_lst_rep_lout-bezei1   " Validity Description
                INTO fp_lst_price-column01
           SEPARATED BY space.
      ELSE. " ELSE -> IF fp_lst_rep_lout-vlaufk IS NOT INITIAL
*   END of ADD:CR#6341 RTR20180614  ED2K912278
*     Society Name
        CONCATENATE fp_lst_rep_lout-soc_name "Society Name
                    lv_rlc_text              "Relationship Category: Text
               INTO fp_lst_price-column01
          SEPARATED BY space.
      ENDIF. " IF fp_lst_rep_lout-vlaufk IS NOT INITIAL
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_lst_rep_lout-reltyp_sn IS NOT INITIAL
*   END OF ADD:CR#6341 RTR20180614  ED2K912278
  CASE fp_lst_rep_lout-line_scal.
    WHEN 1.
      CONCATENATE fp_lst_price-column01 'FTE - Large'(sc3)
             INTO fp_lst_price-column01
        SEPARATED BY space.
    WHEN 2.
      CONCATENATE fp_lst_price-column01 'FTE - Medium'(sc2)
             INTO fp_lst_price-column01
        SEPARATED BY space.
    WHEN 3.
*--*Begin of Change by Prabhu ERPM-6898 5/22/2020  ED2K918283
      IF fp_lst_rep_lout-kdgrp NOT IN s_kdgrpp.
      CONCATENATE fp_lst_price-column01 'FTE - Small'(sc1)
             INTO fp_lst_price-column01
        SEPARATED BY space.
      ENDIF.
*--*End of Change by Prabhu ERPM-6898 5/22/2020  ED2K918283
  ENDCASE.

  CONCATENATE fp_lst_price-column01 c_colon
         INTO fp_lst_price-column01.

  IF fp_lst_rep_lout-mediatype IN s_mtypoo.
    CONCATENATE fp_lst_price-column01 'Online Only'(mt1)
           INTO fp_lst_price-column01
      SEPARATED BY space.
  ENDIF. " IF fp_lst_rep_lout-mediatype IN s_mtypoo
  IF fp_lst_rep_lout-mediatype IN s_mtypop.
    CONCATENATE fp_lst_price-column01 'Print + Online'(mt2)
           INTO fp_lst_price-column01
      SEPARATED BY space.
  ENDIF. " IF fp_lst_rep_lout-mediatype IN s_mtypop
  IF fp_lst_rep_lout-mediatype IN s_mtyppo.
    CONCATENATE fp_lst_price-column01 'Print Only'(mt3)
           INTO fp_lst_price-column01
      SEPARATED BY space.
  ENDIF. " IF fp_lst_rep_lout-mediatype IN s_mtyppo
* Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
  fp_lst_price-bp_id   = fp_lst_rep_lout-soc_numbr. "Soceity Number
  fp_lst_price-rel_cat = fp_lst_rep_lout-rltyp. "Relationship Category
* End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908

  fp_lv_c_segnum = fp_lv_c_segnum + 1.
  APPEND INITIAL LINE TO fp_li_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd>).
  <lst_edidd>-segnum = fp_lv_c_segnum.
  <lst_edidd>-segnam = c_seg_prc.
  <lst_edidd>-psgnum = fp_lv_p_segn_c.
  <lst_edidd>-hlevel = 4.
  <lst_edidd>-sdata  = fp_lst_price.
  CLEAR: fp_lst_price.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEGMENT_COLHEAD
*&---------------------------------------------------------------------*
*       Populate Column Heading Segment
*----------------------------------------------------------------------*
*      -->FP_LST_REP_LOUT  text
*      -->FP_LV_P_SEGN_J  text
*      <--FP_LST_COLHEAD  text
*      <--FP_LV_C_SEGNUM  text
*      <--FP_LV_P_SEGN_C  text
*      <--FP_LI_EDIDD  text
*----------------------------------------------------------------------*
FORM f_segment_colhead  USING    fp_lst_rep_lout TYPE ty_rep_lout
                                 fp_lv_p_segn_j  TYPE edi_psgnum    " Number of the hierarchically higher SAP segment
                                 fp_li_rep_lout  TYPE tt_rep_lout
                        CHANGING fp_lst_colhead  TYPE z1pdm_colhead " I0225: Column Headings
                                 fp_lv_c_segnum  TYPE idocdsgnum    " Number of SAP segment
                                 fp_lv_p_segn_c  TYPE edi_psgnum    " Number of the hierarchically higher SAP segment
                                 fp_li_edidd     TYPE edidd_tt.

  READ TABLE fp_li_rep_lout TRANSPORTING NO FIELDS
             WITH KEY extwg = fp_lst_rep_lout-extwg
             BINARY SEARCH.
  IF sy-subrc EQ 0.
    IF fp_lst_rep_lout-publtype NOT IN s_opt_in. "Not an Opt-in Subscription
*     Begin of DEL:ERP-4385:WROY:11-SEP-2017:ED2K908472
*     DATA(lv_tabix_p) = sy-tabix.
*     LOOP AT fp_li_rep_lout ASSIGNING FIELD-SYMBOL(<lst_rep_lout_p>) FROM lv_tabix_p.
*       IF <lst_rep_lout_p>-extwg NE fp_lst_rep_lout-extwg.
*         EXIT.
*       ENDIF.
*       IF <lst_rep_lout_p>-pltyp IN s_pltyp1.
*         fp_lst_colhead-column02 = 'The Americas'(pl1).
*       ENDIF.
*       IF <lst_rep_lout_p>-pltyp IN s_pltyp2.
*         fp_lst_colhead-column03 = 'UK'(pl2).
*       ENDIF.
*       IF <lst_rep_lout_p>-pltyp IN s_pltyp3.
*         fp_lst_colhead-column04 = 'Europe'(pl3).
*       ENDIF.
*       IF <lst_rep_lout_p>-pltyp IN s_pltyp4.
*         fp_lst_colhead-column05 = 'ROW'(pl4).
*       ENDIF.
*     ENDLOOP.
*     End   of DEL:ERP-4385:WROY:11-SEP-2017:ED2K908472
*     Begin of ADD:ERP-4385:WROY:11-SEP-2017:ED2K908472
      fp_lst_colhead-column02 = 'The Americas'(pl1).
      fp_lst_colhead-column03 = 'UK'(pl2).
      fp_lst_colhead-column04 = 'Europe'(pl3).
      fp_lst_colhead-column05 = 'ROW'(pl4).
*     End   of DEL:ERP-4385:WROY:11-SEP-2017:ED2K908472
    ENDIF. " IF fp_lst_rep_lout-publtype NOT IN s_opt_in

    fp_lv_c_segnum = fp_lv_c_segnum + 1.
    APPEND INITIAL LINE TO fp_li_edidd ASSIGNING FIELD-SYMBOL(<lst_edidd>).
    <lst_edidd>-segnum = fp_lv_c_segnum.
    <lst_edidd>-segnam = c_seg_clh.
    <lst_edidd>-psgnum = fp_lv_p_segn_j.
    <lst_edidd>-hlevel = 3.
    <lst_edidd>-sdata  = fp_lst_colhead.
    fp_lv_p_segn_c     = fp_lv_c_segnum.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADD_BOM_SEGMENTS
*&---------------------------------------------------------------------*
*       Populate BOM Segments
*----------------------------------------------------------------------*
*      -->FP_LI_REP_LOUT  text
*      -->FP_LST_BOM_DETL  text
*      -->FP_LI_REP_LOUT_E  text
*      -->FP_LV_P_SEGN_J  text
*      <--FP_LV_C_SEGNUM  text
*      <--FP_LI_EDIDD  text
*----------------------------------------------------------------------*
FORM f_add_bom_segments  USING    fp_li_rep_lout   TYPE tt_rep_lout
                                  fp_lst_bom_detl  TYPE ty_bom_detl
                                  fp_li_rep_lout_e TYPE tt_rep_lout
                                  fp_lv_p_segn_j   TYPE edi_psgnum " Number of the hierarchically higher SAP segment
                                  fp_li_bom_detl_h TYPE tt_bom_detl
                         CHANGING fp_lv_c_segnum   TYPE idocdsgnum " Number of SAP segment
                                  fp_li_edidd      TYPE edidd_tt.

  DATA:
    li_rep_lout  TYPE tt_rep_lout.

  DATA:
    lst_colhead TYPE z1pdm_colhead, " I0225: Column Headings
    lst_price   TYPE z1pdm_price.   " I0225: Price Details

  DATA:
    lv_tabix_b  TYPE sytabix,    " Row Index of Internal Tables
    lv_p_segn_c TYPE edi_psgnum. " Number of the hierarchically higher SAP segment

  li_rep_lout[] = fp_li_rep_lout[].
  DELETE li_rep_lout WHERE extwg NE fp_lst_bom_detl-extwg.

  LOOP AT li_rep_lout ASSIGNING FIELD-SYMBOL(<lst_rep_lout>).
    AT NEW extwg.
      CLEAR: lst_colhead.
      lst_colhead-column01 = 'Combined Subscription with'(bm1).

      READ TABLE fp_li_bom_detl_h TRANSPORTING NO FIELDS
           WITH KEY extwg = <lst_rep_lout>-extwg
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lv_tabix_b = sy-tabix.
        LOOP AT fp_li_bom_detl_h ASSIGNING FIELD-SYMBOL(<lst_bom_detl_h>) FROM lv_tabix_b.
          IF <lst_bom_detl_h>-extwg NE <lst_rep_lout>-extwg.
            EXIT.
          ENDIF. " IF <lst_bom_detl_h>-extwg NE <lst_rep_lout>-extwg
          IF <lst_bom_detl_h>-extwg_cmp NE fp_lst_bom_detl-extwg_cmp.
            READ TABLE fp_li_rep_lout ASSIGNING FIELD-SYMBOL(<lst_rep_lout_c>)
                 WITH KEY extwg = <lst_bom_detl_h>-extwg_cmp
                 BINARY SEARCH.
            IF sy-subrc EQ 0.
              CONCATENATE lst_colhead-column01
                          <lst_rep_lout_c>-maktx
                     INTO lst_colhead-column01
                SEPARATED BY space.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF. " IF <lst_bom_detl_h>-extwg_cmp NE fp_lst_bom_detl-extwg_cmp
        ENDLOOP. " LOOP AT fp_li_bom_detl_h ASSIGNING FIELD-SYMBOL(<lst_bom_detl_h>) FROM lv_tabix_b
      ENDIF. " IF sy-subrc EQ 0

*     Populate Column Heading Segment
      PERFORM f_segment_colhead USING    <lst_rep_lout>
                                         fp_lv_p_segn_j
                                         fp_li_rep_lout_e
                                CHANGING lst_colhead
                                         fp_lv_c_segnum
                                         lv_p_segn_c
                                         fp_li_edidd.
    ENDAT.

*   Populate Price Value
    PERFORM f_populate_price USING    <lst_rep_lout>
                             CHANGING lst_price.

    AT END OF level.
*     Populate Price Segment
      PERFORM f_segment_price USING    <lst_rep_lout>
                                       lv_p_segn_c
                              CHANGING lst_price
                                       fp_lv_c_segnum
                                       fp_li_edidd.
    ENDAT.
  ENDLOOP. " LOOP AT li_rep_lout ASSIGNING FIELD-SYMBOL(<lst_rep_lout>)

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_PRICE
*&---------------------------------------------------------------------*
*       Populate Price Value
*----------------------------------------------------------------------*
*      -->FP_LST_REP_LOUT  text
*      <--FP_LST_PRICE  text
*----------------------------------------------------------------------*
FORM f_populate_price  USING    fp_lst_rep_lout TYPE ty_rep_lout
                       CHANGING fp_lst_price    TYPE z1pdm_price. " I0225: Price Details

  DATA:
    lv_prc_int TYPE i,      " Prc_int of type Integers
    lv_price   TYPE char17. " Price of type CHAR17

* Convert to whole value
  lv_prc_int = fp_lst_rep_lout-net_prc_s.
  IF lv_prc_int IS INITIAL.
    RETURN.
  ENDIF. " IF lv_prc_int IS INITIAL

  lv_price   = lv_prc_int.
  IF fp_lst_rep_lout-pltyp IN s_pltyp1.
*   Add Currency Sign
    PERFORM f_add_currency_sign USING    fp_lst_rep_lout-konwa
                                         lv_price
                                CHANGING fp_lst_price-column02.
  ENDIF. " IF fp_lst_rep_lout-pltyp IN s_pltyp1
  IF fp_lst_rep_lout-pltyp IN s_pltyp2.
*   Add Currency Sign
    PERFORM f_add_currency_sign USING    fp_lst_rep_lout-konwa
                                         lv_price
                                CHANGING fp_lst_price-column03.

  ENDIF. " IF fp_lst_rep_lout-pltyp IN s_pltyp2
  IF fp_lst_rep_lout-pltyp IN s_pltyp3.
*   Add Currency Sign
    PERFORM f_add_currency_sign USING    fp_lst_rep_lout-konwa
                                         lv_price
                                CHANGING fp_lst_price-column04.
  ENDIF. " IF fp_lst_rep_lout-pltyp IN s_pltyp3
  IF fp_lst_rep_lout-pltyp IN s_pltyp4.
*   Add Currency Sign
    PERFORM f_add_currency_sign USING    fp_lst_rep_lout-konwa
                                         lv_price
                                CHANGING fp_lst_price-column05.
  ENDIF. " IF fp_lst_rep_lout-pltyp IN s_pltyp4

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_XCEL_LIB
*&---------------------------------------------------------------------*
*       Create Excel file for Librarians
*----------------------------------------------------------------------*
*      -->FP_I_REP_LOUT  text
*      -->FP_I_BOM_DETLS  text
*----------------------------------------------------------------------*
FORM f_create_xcel_lib  USING    fp_i_rep_lout TYPE tt_rep_lout
                                 fp_i_bom_detl TYPE tt_bom_detl.

  DATA:
    li_xcel_lib TYPE tt_xcel_lib,
    li_xcel_cl1 TYPE tt_xcel_lib,
    li_xcel_val TYPE tt_xcel_lib,
    li_xcel_v1  TYPE tt_xcel_v1, "+ <HIPATEL> <CR-6735/7607> <ED2K912991>
    li_issue_sq TYPE tt_issue_sq,
    li_char_dtl TYPE tt_char_dtl,
    li_mat_plnt TYPE tt_mat_plnt.

  DATA:
    lv_prc_int  TYPE i,           " Prc_int of type Integers
    lv_price    TYPE char17,      " Price of type CHAR17
    lv_curr_yr  TYPE ismjahrgang, " Media issue year number
    lv_prev_yr  TYPE ismjahrgang, " Media issue year number
    lv_xcel_rec TYPE string,
    lv_xcel_att TYPE string,
    lv_bom_detl TYPE string,
    lv_opt_in_b TYPE string,
    lv_volume   TYPE string,
    lv_issues   TYPE string.

  IF rb_lib_e IS INITIAL.
    RETURN.
  ENDIF. " IF rb_lib_e IS INITIAL

  IF s_email IS INITIAL.
*   E-mail recipient missing
    MESSAGE i042(edocument). " E-mail recipient missing
    RETURN.
  ENDIF. " IF s_email IS INITIAL

* Fetch Media Product Issue Sequence
  PERFORM f_fetch_issue_seq USING    fp_i_rep_lout
                            CHANGING li_issue_sq.
  lv_curr_yr   = p_prsdt(4).
  IF lv_curr_yr IS INITIAL.
    lv_curr_yr = sy-datum(4).
  ENDIF. " IF lv_curr_yr IS INITIAL
  lv_prev_yr = lv_curr_yr - 1.

* Fetch Characteristic Details
  PERFORM f_fetch_charc_dtl USING    fp_i_rep_lout
                            CHANGING li_char_dtl.

* Fetch Plant Data for Material
  PERFORM f_fetch_mat_plant USING    fp_i_rep_lout
                            CHANGING li_mat_plnt.

  DATA(li_bom_detl_h) = fp_i_bom_detl[].
  DELETE li_bom_detl_h WHERE mtart NOT IN s_mtartc.
  SORT li_bom_detl_h BY extwg extwg_cmp.
  DELETE ADJACENT DUPLICATES FROM li_bom_detl_h COMPARING extwg extwg_cmp.

  DATA(li_bom_detl_c) = fp_i_bom_detl[].
  DELETE li_bom_detl_c WHERE mtart NOT IN s_mtartc.

  SORT li_bom_detl_c BY extwg_cmp extwg.
  DELETE ADJACENT DUPLICATES FROM li_bom_detl_c COMPARING extwg_cmp extwg.

  DATA(li_rep_lout_i) = fp_i_rep_lout[].
  SORT li_rep_lout_i BY extwg issn_lvl.
  DELETE ADJACENT DUPLICATES FROM li_rep_lout_i COMPARING extwg.

* First Row
  APPEND INITIAL LINE TO li_xcel_lib ASSIGNING FIELD-SYMBOL(<lst_xcel_lib>).
  CONCATENATE 'WOL'(l01)
              p_prsdt(4)
         INTO <lst_xcel_lib>-column_01.
  <lst_xcel_lib>-column_02 = 'http://media.wiley.com/assets/7331/09/Wiley_Price_list_Journal_changes_document.xls'.
* Second Row
  APPEND INITIAL LINE TO li_xcel_lib ASSIGNING <lst_xcel_lib>.
  CONCATENATE 'WILEY'(l02)
              p_prsdt(4)
              'JOURNAL PRICE LIST'(l03)
         INTO <lst_xcel_lib>-column_02
    SEPARATED BY space.
* Third Row
  APPEND INITIAL LINE TO li_xcel_lib ASSIGNING <lst_xcel_lib>.

* Begin by amohammed on 04/07/2020 - ERPM-6898 -  ED2K917960
*  <lst_xcel_lib>-column_01 = 'Journal TitleAcronymPrint ISSNOnline ISSNVol & issues'(l04).
  <lst_xcel_lib>-column_01 = 'Journal TitleAcronymPrint ISSNOnline ISSNTitle StatusVol & issues'(l04).
* End by amohammed on 04/07/2020 - ERPM-6898 -  ED2K917960

  <lst_xcel_lib>-column_02 = 'Material Number'(l05).  "Material Number + <HIPATEL> <CR-6735> <ED2K912794>
  <lst_xcel_lib>-column_03 = 'Media'(l06).
  <lst_xcel_lib>-column_04 = 'The Americas'(l07).
  <lst_xcel_lib>-column_05 = 'UK'(l08).
  <lst_xcel_lib>-column_06 = 'Europe'(l09).
  <lst_xcel_lib>-column_07 = 'Rest of World'(l10).

  DATA(li_rep_lout_s) = fp_i_rep_lout.
* Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
* SORT li_rep_lout_s BY alpha_sep extwg member ipm_ind rltyp soc_numbr line_scal level pltyp.
* End   of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
* Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
*Begin Of Del <HIPATEL> <CR-6735> <ED2K912794> <07/26/2018>
*  SORT li_rep_lout_s BY alpha_sep extwg np_ind member ipm_ind rltyp soc_numbr line_scal level pltyp.
*End Of Del <HIPATEL> <CR-6735> <ED2K912794> <07/26/2018>
* End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
*BOC <HIPATEL> <CR-6735> <ED2K912794> <07/26/2018>
*Sorting order change based on the material description for librarian report
  SORT li_rep_lout_s BY alpha_sep maktx_xls extwg np_ind member ipm_ind rltyp soc_numbr line_scal level pltyp.
  SORT fp_i_rep_lout BY extwg.
*EOC <HIPATEL> <CR-6735> <ED2K912794> <07/26/2018>

  LOOP AT li_rep_lout_s ASSIGNING FIELD-SYMBOL(<lst_rep_lout>).
    AT NEW alpha_sep.
*     Alphabetical Letter Separator
      APPEND INITIAL LINE TO li_xcel_lib ASSIGNING <lst_xcel_lib>.
      <lst_xcel_lib>-column_05 = <lst_rep_lout>-alpha_sep.
    ENDAT.

    AT NEW extwg.
*     First Row
      APPEND INITIAL LINE TO li_xcel_lib ASSIGNING <lst_xcel_lib>.
      <lst_xcel_lib>-column_01 = <lst_rep_lout>-maktx.
*     Second Row
      APPEND INITIAL LINE TO li_xcel_lib ASSIGNING <lst_xcel_lib>.
      <lst_xcel_lib>-column_01 = <lst_rep_lout>-extwg.
    ENDAT.

*   Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    AT NEW np_ind.
      IF <lst_rep_lout>-np_ind IS NOT INITIAL. "Indicator for Net Price
*       Blank Row
*BOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
*        APPEND INITIAL LINE TO li_xcel_val ASSIGNING <lst_xcel_lib>.
        APPEND INITIAL LINE TO li_xcel_v1 ASSIGNING FIELD-SYMBOL(<lst_xcel_v1>).
*EOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
      ENDIF. " IF <lst_rep_lout>-np_ind IS NOT INITIAL
    ENDAT.
*   End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908

    AT NEW level.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
*      APPEND INITIAL LINE TO li_xcel_val ASSIGNING <lst_xcel_lib>.
      APPEND INITIAL LINE TO li_xcel_v1 ASSIGNING <lst_xcel_v1>.
*EOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
*     Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
      IF <lst_rep_lout>-reltyp_sn IS NOT INITIAL AND
         <lst_rep_lout>-np_ind    IS NOT INITIAL.
*       Check exceptions from Application Constant table
        READ TABLE i_constants ASSIGNING FIELD-SYMBOL(<lst_constant>)
             WITH KEY param1 = c_param_rcd
                      param2 = <lst_rep_lout>-rltyp
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          DATA(lv_rlc_text) = <lst_constant>-low. "Relationship Category: Text
          IF <lst_constant>-high IS INITIAL. "Only Relationship Category: Text
*            <lst_xcel_lib>-column_01 = lv_rlc_text.  "- <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
            <lst_xcel_v1>-column_01 = lv_rlc_text.   "+ <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
          ELSE. " ELSE -> IF <lst_constant>-high IS INITIAL
            CONCATENATE <lst_rep_lout>-soc_name "Society Name
                        lv_rlc_text             "Relationship Category: Text
*                   INTO <lst_xcel_lib>-column_01     "- <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
                    INTO <lst_xcel_v1>-column_01     "+ <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
              SEPARATED BY space.
          ENDIF. " IF <lst_constant>-high IS INITIAL
        ELSE. " ELSE -> IF sy-subrc EQ 0
*         Relationship Category: Text
          IF <lst_rep_lout>-rlc_text IS NOT INITIAL.
            lv_rlc_text = <lst_rep_lout>-rlc_text.
          ELSE. " ELSE -> IF <lst_rep_lout>-rlc_text IS NOT INITIAL
            lv_rlc_text = 'Member'(kg3).
          ENDIF. " IF <lst_rep_lout>-rlc_text IS NOT INITIAL
*         Society Name
          CONCATENATE <lst_rep_lout>-soc_name "Society Name
                      lv_rlc_text             "Relationship Category: Text
*                 INTO <lst_xcel_lib>-column_01   "- <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
                  INTO <lst_xcel_v1>-column_01   "+ <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
            SEPARATED BY space.
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF <lst_rep_lout>-reltyp_sn IS NOT INITIAL AND
*     End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
*     Begin of ADD:ERP-6324:WROY:28-JUN-2018:ED2K912466
      IF <lst_rep_lout>-price_nm NE abap_true. "Price Not Maintained
*     End   of ADD:ERP-6324:WROY:28-JUN-2018:ED2K912466
        IF <lst_rep_lout>-mediatype IN s_mtyppo.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE <lst_rep_lout>-extwg
*                       'P'(l11)
*                 INTO <lst_xcel_lib>-column_02
*            SEPARATED BY c_f_slash.
          CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
            EXPORTING
              input  = <lst_rep_lout>-matnr
            IMPORTING
              output = <lst_xcel_v1>-column_02.

          <lst_xcel_v1>-print_lvl = c_flg_srt_3.  "+ <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*          <lst_xcel_lib>-column_03 = 'Print'(l17). "- <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
          <lst_xcel_v1>-column_03 = 'Print'(l17).   "+ <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
        ENDIF. " IF <lst_rep_lout>-mediatype IN s_mtyppo
        IF <lst_rep_lout>-mediatype IN s_mtypoo.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE <lst_rep_lout>-extwg
*                       'E'(l12)
*                 INTO <lst_xcel_lib>-column_02
*            SEPARATED BY c_f_slash.
          CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
            EXPORTING
              input  = <lst_rep_lout>-matnr
            IMPORTING
              output = <lst_xcel_v1>-column_02.

          <lst_xcel_v1>-print_lvl = c_flg_srt_2.  "+ <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*          <lst_xcel_lib>-column_03 = 'Online'(l18).  "- <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
          <lst_xcel_v1>-column_03 = 'Online'(l18).   "+ <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
        ENDIF. " IF <lst_rep_lout>-mediatype IN s_mtypoo
        IF <lst_rep_lout>-mediatype IN s_mtypop.
*BOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*Journal group code to be replaced by material number.
*          CONCATENATE <lst_rep_lout>-extwg
*                       'C'(l13)
*                 INTO <lst_xcel_lib>-column_02
*            SEPARATED BY c_f_slash.
          CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
            EXPORTING
              input  = <lst_rep_lout>-matnr
            IMPORTING
              output = <lst_xcel_v1>-column_02.

          <lst_xcel_v1>-print_lvl = c_flg_srt_1.  "+ <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
*EOC <HIPATEL> <CR-6735/7607> <ED2K912794/ED2K912899> <07/26/2018>
*          <lst_xcel_lib>-column_03 = 'Print & Online'(l19).  "- <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
          <lst_xcel_v1>-column_03 = 'Print & Online'(l19).    "+ <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
        ENDIF. " IF <lst_rep_lout>-mediatype IN s_mtypop

*BOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
*        CASE <lst_rep_lout>-line_scal.
*          WHEN 1.
*            CONCATENATE <lst_xcel_lib>-column_02 '(SMALL)'(l14)
*                   INTO <lst_xcel_lib>-column_02
*              SEPARATED BY space.
*          WHEN 2.
*            CONCATENATE <lst_xcel_lib>-column_02 '(MEDIUM)'(l15)
*                   INTO <lst_xcel_lib>-column_02
*              SEPARATED BY space.
*          WHEN 3.
*            CONCATENATE <lst_xcel_lib>-column_02 '(LARGE)'(l16)
*                   INTO <lst_xcel_lib>-column_02
*              SEPARATED BY space.
*        ENDCASE.

        CASE <lst_rep_lout>-line_scal.
          WHEN 1.
            CONCATENATE <lst_xcel_v1>-column_02 '(SMALL)'(l14)
                   INTO <lst_xcel_v1>-column_02
              SEPARATED BY space.
            <lst_xcel_v1>-media_lvl = c_flg_srt_1.
          WHEN 2.
            CONCATENATE <lst_xcel_v1>-column_02 '(MEDIUM)'(l15)
                   INTO <lst_xcel_v1>-column_02
              SEPARATED BY space.
            <lst_xcel_v1>-media_lvl = c_flg_srt_2.
          WHEN 3.
            CONCATENATE <lst_xcel_v1>-column_02 '(LARGE)'(l16)
                   INTO <lst_xcel_v1>-column_02
              SEPARATED BY space.
            <lst_xcel_v1>-media_lvl = c_flg_srt_3.
        ENDCASE.
*EOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
*     Begin of ADD:ERP-6324:WROY:28-JUN-2018:ED2K912466
      ENDIF. " IF <lst_rep_lout>-price_nm EQ abap_true
*     End   of ADD:ERP-6324:WROY:28-JUN-2018:ED2K912466
    ENDAT.

*   Convert to whole value
    lv_prc_int = <lst_rep_lout>-net_prc_s.
    IF <lst_rep_lout>-excld_prc NE abap_true AND "Exclude Pricing
       lv_prc_int IS NOT INITIAL.
      lv_price = lv_prc_int.
      IF <lst_rep_lout>-pltyp IN s_pltyp1.
*       Add Currency Sign
        PERFORM f_add_currency_sign USING    <lst_rep_lout>-konwa
                                             lv_price
*                                    CHANGING <lst_xcel_lib>-column_04. "- <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
                                    CHANGING <lst_xcel_v1>-column_04.  "+ <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
      ENDIF. " IF <lst_rep_lout>-pltyp IN s_pltyp1
      IF <lst_rep_lout>-pltyp IN s_pltyp2.
*       Add Currency Sign
        PERFORM f_add_currency_sign USING    <lst_rep_lout>-konwa
                                             lv_price
*                                    CHANGING <lst_xcel_lib>-column_05. "- <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
                                    CHANGING <lst_xcel_v1>-column_05.  "+ <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
      ENDIF. " IF <lst_rep_lout>-pltyp IN s_pltyp2
      IF <lst_rep_lout>-pltyp IN s_pltyp3.
*       Add Currency Sign
        PERFORM f_add_currency_sign USING    <lst_rep_lout>-konwa
                                             lv_price
*                                    CHANGING <lst_xcel_lib>-column_06.  "- <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
                                    CHANGING <lst_xcel_v1>-column_06.   "+ <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
      ENDIF. " IF <lst_rep_lout>-pltyp IN s_pltyp3
      IF <lst_rep_lout>-pltyp IN s_pltyp4.
*       Add Currency Sign
        PERFORM f_add_currency_sign USING    <lst_rep_lout>-konwa
                                             lv_price
*                                    CHANGING <lst_xcel_lib>-column_07.  "- <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
                                    CHANGING <lst_xcel_v1>-column_07.   "+ <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
      ENDIF. " IF <lst_rep_lout>-pltyp IN s_pltyp4
    ENDIF. " IF <lst_rep_lout>-excld_prc NE abap_true AND

****BOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
***      MOVE-CORRESPONDING <lst_xcel_lib> TO <lst_xcel_lib_f>.
****EOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>

    AT END OF extwg.
*     Add ISSN
      APPEND INITIAL LINE TO li_xcel_cl1 ASSIGNING <lst_xcel_lib>.
      READ TABLE li_rep_lout_i ASSIGNING FIELD-SYMBOL(<lst_rep_lout_i>)
           WITH KEY extwg = <lst_rep_lout>-extwg
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        <lst_xcel_lib>-column_01 = <lst_rep_lout_i>-identcode.
      ENDIF. " IF sy-subrc EQ 0
*     Add Volume and Issue Details
      READ TABLE li_issue_sq ASSIGNING FIELD-SYMBOL(<lst_issue_sq>)
           WITH KEY med_prod  = <lst_rep_lout>-matnr
                    ismyearnr = lv_curr_yr
           BINARY SEARCH.
*     Begin of ADD:ERP-6616:WROY:26-Feb-2018:ED2K911084
      IF sy-subrc NE 0.
        READ TABLE li_issue_sq ASSIGNING <lst_issue_sq>
             WITH KEY med_prod  = <lst_rep_lout_i>-matnr
                      ismyearnr = lv_curr_yr
             BINARY SEARCH.
      ENDIF. " IF sy-subrc NE 0
*     End   of ADD:ERP-6616:WROY:26-Feb-2018:ED2K911084
      IF sy-subrc EQ 0.
        APPEND INITIAL LINE TO li_xcel_cl1 ASSIGNING <lst_xcel_lib>.
        CONCATENATE 'Vol'(l20)
                    <lst_issue_sq>-volume
               INTO lv_volume
          SEPARATED BY space.
        CONCATENATE <lst_issue_sq>-issues
                    'Issues'(l21)
               INTO lv_issues
          SEPARATED BY space.
* Begin by amohammed on 04/07/2020 - ERPM-6898 -  ED2K917960
* If number of issues are greater than 12 OR
* If the pricing condition records valid from & Valid to dates
*  are different from 01/01/XXXX & 12/31/XXXX
* Then classify the title as rolling

*        IF <lst_issue_sq>-issues > 12.
*          CONCATENATE 'Rolling title'(l35)
*                      lv_volume
*                      lv_issues
*                 INTO <lst_xcel_lib>-column_01
*            SEPARATED BY c_comma.
*        ELSE.
          IF ( ( <lst_rep_lout>-datab+4(2) NE c_jan_one OR
                 <lst_rep_lout>-datab+6(2) NE c_jan_one ) OR
               ( <lst_rep_lout>-datbi+4(2) NE c_dec OR
                 <lst_rep_lout>-datbi+6(2) NE c_month_end ) ).
            CONCATENATE 'Rolling title'(l35)
                        lv_volume
                        lv_issues
                   INTO <lst_xcel_lib>-column_01
              SEPARATED BY c_comma.
          ELSE.
* End by amohammed on 04/07/2020 - ERPM-6898 -  ED2K917960
            CONCATENATE lv_volume
                        lv_issues
                   INTO <lst_xcel_lib>-column_01
              SEPARATED BY c_comma.
* Begin by amohammed on 04/07/2020 - ERPM-6898 -  ED2K917960
          ENDIF.
*        ENDIF. " IF <lst_issue_sq>-issues > 12.
* End by amohammed on 04/07/2020 - ERPM-6898 -  ED2K917960
      ENDIF. " IF sy-subrc EQ 0
*BOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
      SORT li_xcel_v1 BY media_lvl print_lvl.
      MOVE-CORRESPONDING li_xcel_v1[] TO li_xcel_val[].
*EOC <HIPATEL> <CR-6735/7607> <ED2K912991> <07/26/2018>
      LOOP AT li_xcel_cl1 ASSIGNING FIELD-SYMBOL(<lst_xcel_cl1>).
        DATA(lv_tabix_cl1) = sy-tabix.

        READ TABLE li_xcel_val ASSIGNING FIELD-SYMBOL(<lst_xcel_val>) INDEX lv_tabix_cl1.
        IF sy-subrc EQ 0.
          <lst_xcel_val>-column_01 = <lst_xcel_cl1>-column_01.
        ELSE. " ELSE -> IF sy-subrc EQ 0
          APPEND INITIAL LINE TO li_xcel_val ASSIGNING <lst_xcel_val>.
          <lst_xcel_val>-column_01 = <lst_xcel_cl1>-column_01.
        ENDIF. " IF sy-subrc EQ 0
      ENDLOOP. " LOOP AT li_xcel_cl1 ASSIGNING FIELD-SYMBOL(<lst_xcel_cl1>)
      APPEND LINES OF li_xcel_val TO li_xcel_lib.
      CLEAR: li_xcel_val, li_xcel_cl1, li_xcel_v1.

      CASE <lst_rep_lout>-bom_info.
        WHEN c_flag_c.
          CLEAR: lv_bom_detl.
          READ TABLE li_bom_detl_c TRANSPORTING NO FIELDS
               WITH KEY extwg_cmp = <lst_rep_lout>-extwg
               BINARY SEARCH.
          IF sy-subrc EQ 0.
            LOOP AT li_bom_detl_c ASSIGNING FIELD-SYMBOL(<lst_bom_detl>) FROM sy-tabix.
              IF <lst_bom_detl>-extwg_cmp NE <lst_rep_lout>-extwg.
                EXIT.
              ENDIF. " IF <lst_bom_detl>-extwg_cmp NE <lst_rep_lout>-extwg

              READ TABLE fp_i_rep_lout ASSIGNING FIELD-SYMBOL(<lst_rep_lout_b>)
                   WITH KEY extwg = <lst_bom_detl>-extwg
                   BINARY SEARCH.
              IF sy-subrc EQ 0.
                IF lv_bom_detl IS INITIAL.
                  lv_bom_detl = <lst_rep_lout_b>-maktx.
                ELSE. " ELSE -> IF lv_bom_detl IS INITIAL
                  CONCATENATE lv_bom_detl
                              c_ampersand
                              <lst_rep_lout_b>-maktx
                         INTO lv_bom_detl
                    SEPARATED BY space.
                ENDIF. " IF lv_bom_detl IS INITIAL
              ENDIF. " IF sy-subrc EQ 0
            ENDLOOP. " LOOP AT li_bom_detl_c ASSIGNING FIELD-SYMBOL(<lst_bom_detl>) FROM sy-tabix
*           Begin of DEL:ERP-4706:WROY:29-SEP-2017:ED2K908728
            IF lv_bom_detl IS NOT INITIAL.
*           End   of DEL:ERP-4706:WROY:29-SEP-2017:ED2K908728
              APPEND INITIAL LINE TO li_xcel_lib ASSIGNING <lst_xcel_lib>.
              IF <lst_rep_lout>-excld_prc IS INITIAL.
                CONCATENATE 'Also available in'(l22)
                            lv_bom_detl
*                           Begin of DEL:ERP-4706:WROY:29-SEP-2017:ED2K908728
*                           'Package'(l23)
*                           End   of DEL:ERP-4706:WROY:29-SEP-2017:ED2K908728
                       INTO <lst_xcel_lib>-column_01
                  SEPARATED BY space.
              ELSE. " ELSE -> IF <lst_rep_lout>-excld_prc IS INITIAL
                CONCATENATE 'See'(l29)
                            lv_bom_detl
                       INTO <lst_xcel_lib>-column_01
                  SEPARATED BY space.
              ENDIF. " IF <lst_rep_lout>-excld_prc IS INITIAL
*           Begin of DEL:ERP-4706:WROY:29-SEP-2017:ED2K908728
            ENDIF. " IF lv_bom_detl IS NOT INITIAL
*           End   of DEL:ERP-4706:WROY:29-SEP-2017:ED2K908728
          ENDIF. " IF sy-subrc EQ 0

        WHEN c_flag_h.
          CLEAR: lv_bom_detl,
                 lv_opt_in_b.
          READ TABLE li_bom_detl_h TRANSPORTING NO FIELDS
               WITH KEY extwg = <lst_rep_lout>-extwg
               BINARY SEARCH.
          IF sy-subrc EQ 0.
            LOOP AT li_bom_detl_h ASSIGNING <lst_bom_detl> FROM sy-tabix.
              IF <lst_bom_detl>-extwg NE <lst_rep_lout>-extwg.
                EXIT.
              ENDIF. " IF <lst_bom_detl>-extwg NE <lst_rep_lout>-extwg

              READ TABLE fp_i_rep_lout ASSIGNING <lst_rep_lout_b>
                   WITH KEY extwg = <lst_bom_detl>-extwg_cmp
                   BINARY SEARCH.
              IF sy-subrc EQ 0.
                IF <lst_rep_lout_b>-publtype NOT IN s_opt_in. "Not an Opt-in Subscription
                  IF lv_bom_detl IS INITIAL.
                    lv_bom_detl = <lst_rep_lout_b>-maktx.
                  ELSE. " ELSE -> IF lv_bom_detl IS INITIAL
                    CONCATENATE lv_bom_detl
                                c_ampersand
                                <lst_rep_lout_b>-maktx
                           INTO lv_bom_detl
                      SEPARATED BY space.
                  ENDIF. " IF lv_bom_detl IS INITIAL
                ELSE. " ELSE -> IF <lst_rep_lout_b>-publtype NOT IN s_opt_in
                  IF lv_opt_in_b IS INITIAL.
                    lv_opt_in_b = <lst_rep_lout_b>-maktx.
                  ELSE. " ELSE -> IF lv_opt_in_b IS INITIAL
                    CONCATENATE lv_opt_in_b
                                c_ampersand
                                <lst_rep_lout_b>-maktx
                           INTO lv_opt_in_b
                      SEPARATED BY space.
                  ENDIF. " IF lv_opt_in_b IS INITIAL
                ENDIF. " IF <lst_rep_lout_b>-publtype NOT IN s_opt_in
              ENDIF. " IF sy-subrc EQ 0
            ENDLOOP. " LOOP AT li_bom_detl_h ASSIGNING <lst_bom_detl> FROM sy-tabix
            APPEND INITIAL LINE TO li_xcel_lib ASSIGNING <lst_xcel_lib>.
            IF lv_bom_detl IS NOT INITIAL.
              CONCATENATE 'Includes'(l24)
                          lv_bom_detl
                     INTO <lst_xcel_lib>-column_01
                SEPARATED BY space.
            ENDIF. " IF lv_bom_detl IS NOT INITIAL
            IF lv_opt_in_b IS NOT INITIAL.
              IF <lst_xcel_lib>-column_01 IS INITIAL.
                CONCATENATE 'Includes Opt-in title'(l33)
                            lv_opt_in_b
                       INTO <lst_xcel_lib>-column_01
                  SEPARATED BY space.
              ELSE. " ELSE -> IF <lst_xcel_lib>-column_01 IS INITIAL
                CONCATENATE <lst_xcel_lib>-column_01
                            c_period
                       INTO <lst_xcel_lib>-column_01.
                CONCATENATE <lst_xcel_lib>-column_01
                            'Includes Opt-in title'(l33)
                            lv_opt_in_b
                       INTO <lst_xcel_lib>-column_01
                  SEPARATED BY space.
              ENDIF. " IF <lst_xcel_lib>-column_01 IS INITIAL
            ENDIF. " IF lv_opt_in_b IS NOT INITIAL
          ENDIF. " IF sy-subrc EQ 0
      ENDCASE.

*     Increasing / Decreasing Issues
      IF <lst_issue_sq> IS ASSIGNED.
        READ TABLE li_issue_sq ASSIGNING FIELD-SYMBOL(<lst_issue_sq_p>)
             WITH KEY med_prod  = <lst_rep_lout>-matnr
                      ismyearnr = lv_prev_yr
             BINARY SEARCH.
        IF sy-subrc EQ 0.
          APPEND INITIAL LINE TO li_xcel_lib ASSIGNING <lst_xcel_lib>.
          IF <lst_issue_sq_p>-issues LT <lst_issue_sq>-issues.
            CONCATENATE 'Increasing from'(l25)
                        <lst_issue_sq_p>-issues
                        'to'(l27)
                        <lst_issue_sq>-issues
                        'issues'(l28)
                   INTO <lst_xcel_lib>-column_01
              SEPARATED BY space.
          ENDIF. " IF <lst_issue_sq_p>-issues LT <lst_issue_sq>-issues
          IF <lst_issue_sq_p>-issues GT <lst_issue_sq>-issues.
            CONCATENATE 'Decreasing from'(l26)
                        <lst_issue_sq_p>-issues
                        'to'(l27)
                        <lst_issue_sq>-issues
                        'issues'(l28)
                   INTO <lst_xcel_lib>-column_01
              SEPARATED BY space.
          ENDIF. " IF <lst_issue_sq_p>-issues GT <lst_issue_sq>-issues
        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF <lst_issue_sq> IS ASSIGNED

*     Includes the new start title
      READ TABLE li_char_dtl ASSIGNING FIELD-SYMBOL(<lst_char_dtl>)
           WITH KEY objek = <lst_rep_lout>-objek
                    atinn = p_ns_ttl
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        APPEND INITIAL LINE TO li_xcel_lib ASSIGNING <lst_xcel_lib>.
        CONCATENATE 'Includes the new start title'(l30)
                    <lst_char_dtl>-atwrt
               INTO <lst_xcel_lib>-column_01
            SEPARATED BY space.
      ENDIF. " IF sy-subrc EQ 0

*     Merged with
      READ TABLE li_char_dtl ASSIGNING <lst_char_dtl>
           WITH KEY objek = <lst_rep_lout>-objek
                    atinn = p_megd_w
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        APPEND INITIAL LINE TO li_xcel_lib ASSIGNING <lst_xcel_lib>.
        CONCATENATE 'Merged with'(l31)
                    <lst_char_dtl>-atwrt
               INTO <lst_xcel_lib>-column_01
            SEPARATED BY space.
      ENDIF. " IF sy-subrc EQ 0

      IF <lst_rep_lout>-publtype IN s_opt_in. "Opt-in Subscription
        APPEND INITIAL LINE TO li_xcel_lib ASSIGNING <lst_xcel_lib>.
        <lst_xcel_lib>-column_01 = 'OPT-IN TITLE'(l32).
      ENDIF. " IF <lst_rep_lout>-publtype IN s_opt_in

*     VCH Title
      READ TABLE li_mat_plnt TRANSPORTING NO FIELDS
           WITH KEY matnr = <lst_rep_lout>-matnr
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        APPEND INITIAL LINE TO li_xcel_lib ASSIGNING <lst_xcel_lib>.
        <lst_xcel_lib>-column_01 = 'VCH Title'(l34).
      ENDIF. " IF sy-subrc EQ 0

*     Blank Row
      APPEND INITIAL LINE TO li_xcel_lib ASSIGNING <lst_xcel_lib>.
    ENDAT.
  ENDLOOP. " LOOP AT li_rep_lout_s ASSIGNING FIELD-SYMBOL(<lst_rep_lout>)

  LOOP AT li_xcel_lib ASSIGNING <lst_xcel_lib>.
    CLEAR: lv_xcel_rec.
    CONCATENATE <lst_xcel_lib>-column_01
                <lst_xcel_lib>-column_02
                <lst_xcel_lib>-column_03
                <lst_xcel_lib>-column_04
                <lst_xcel_lib>-column_05
                <lst_xcel_lib>-column_06
                <lst_xcel_lib>-column_07
           INTO lv_xcel_rec
      SEPARATED BY cl_bcs_convert=>gc_tab.
    CONCATENATE lv_xcel_rec
                cl_bcs_convert=>gc_crlf
           INTO lv_xcel_rec.
    IF lv_xcel_att IS INITIAL.
      lv_xcel_att = lv_xcel_rec.
    ELSE. " ELSE -> IF lv_xcel_att IS INITIAL
      CONCATENATE lv_xcel_att
                  lv_xcel_rec
             INTO lv_xcel_att.
    ENDIF. " IF lv_xcel_att IS INITIAL
  ENDLOOP. " LOOP AT li_xcel_lib ASSIGNING <lst_xcel_lib>

  PERFORM f_send_email USING lv_xcel_att.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL
*&---------------------------------------------------------------------*
*       Send Email
*----------------------------------------------------------------------*
*      -->FP_LV_XCEL_ATT  text
*----------------------------------------------------------------------*
FORM f_send_email  USING    fp_lv_xcel_att TYPE string.

  DATA:
    lo_send_request TYPE REF TO cl_bcs,           " Business Communication Service
    lo_document     TYPE REF TO cl_document_bcs,  " Wrapper Class for Office Documents
    lo_sender       TYPE REF TO if_sender_bcs,    " Interface of Sender Object in BCS
    lo_recipient    TYPE REF TO if_recipient_bcs, " Interface of Recipient Object in BCS
    lx_document_bcs TYPE REF TO cx_document_bcs.  " BCS: Document Exceptions

  DATA:
    li_message_body TYPE bcsy_text,
    li_xcel_att     TYPE solix_tab.

  DATA:
    lv_file_size   TYPE so_obj_len, " Size of Document Content
    lv_sent_to_all TYPE os_boolean. " Boolean

* Create send request
  lo_send_request = cl_bcs=>create_persistent( ).

* Put your text into the document
  lo_document = cl_document_bcs=>create_document(
                   i_type = 'RAW'
                   i_text = li_message_body
                   i_subject = 'Librarian' ).

  TRY.
      cl_bcs_convert=>string_to_solix(
        EXPORTING
          iv_string = fp_lv_xcel_att
          iv_codepage = '4103' "suitable for MS Excel, leave empty
          iv_add_bom = 'X'     "for other doc types
        IMPORTING
          et_solix = li_xcel_att
          ev_size = lv_file_size ).
    CATCH cx_bcs.
      MESSAGE e445(so). " Error when transfering document contents
  ENDTRY.

  TRY.
      lo_document->add_attachment(
        EXPORTING
          i_attachment_type = 'XLS'
          i_attachment_subject = 'Librarian'
          i_attachment_size = lv_file_size
          i_att_content_hex = li_xcel_att ).

    CATCH cx_document_bcs INTO lx_document_bcs.
  ENDTRY.

* Pass the document to send request
  lo_send_request->set_document( lo_document ).

  LOOP AT s_email ASSIGNING FIELD-SYMBOL(<lst_email>).
*   Create recipient
    lo_recipient = cl_cam_address_bcs=>create_internet_address( <lst_email>-low ).
*   Set recipient
    lo_send_request->add_recipient(
         EXPORTING
           i_recipient = lo_recipient ).
  ENDLOOP. " LOOP AT s_email ASSIGNING FIELD-SYMBOL(<lst_email>)

* Send email
  lo_send_request->send(
    EXPORTING
      i_with_error_screen = 'X'
    RECEIVING
      result = lv_sent_to_all ).

  COMMIT WORK.

* Message: Email sent successfully!
  MESSAGE i013(zrtr_r2). " Email sent successfully!

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_ISSUE_SEQ
*&---------------------------------------------------------------------*
*       Fetch Media Product Issue Sequence
*----------------------------------------------------------------------*
*      -->P_FP_I_REP_LOUT  text
*      <--P_LI_ISSUE_SQ  text
*----------------------------------------------------------------------*
FORM f_fetch_issue_seq  USING    fp_i_rep_lout  TYPE tt_rep_lout
                        CHANGING fp_li_issue_sq TYPE tt_issue_sq.

* BOC - BTIRUVATHU - INC0252071- 2019/07/15 - ED1K910672
  TYPES:
    BEGIN OF ty_issue,
      med_prod  TYPE ismrefmdprod,                                "Higher-Level Media Product
      ismyearnr TYPE ismjahrgang,                                 "Media issue year number
      matnr     TYPE ismmatnr_issue,                              "Media Issue
      copynr    TYPE ismheftnummer,                               "Copy Number of Media Issue
      nrinyear  TYPE ismnrimjahr,                                 "Issue Number (in Year Number)
      mpg_lfdnr TYPE mpg_lfdnr,                                   "Sequence number of media issue within issue sequence
    END OF ty_issue,
    tt_issue TYPE STANDARD TABLE OF ty_issue INITIAL SIZE 0.
* EOC - BTIRUVATHU - INC0252071- 2019/07/15 - ED1K910672

  DATA:
    lv_curr_year TYPE ismjahrgang, " Media issue year number
    lv_prev_year TYPE ismjahrgang, " Media issue year number
*   Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    lv_volume    TYPE string, "Volume
*   End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
    lv_issues    TYPE ismnrimjahr, "Issues
    li_issue     TYPE tt_issue,                             "ED1K910672
    lw_issue_sq  TYPE LINE OF tt_issue_sq.                  "ED1K910672

  IF fp_i_rep_lout IS INITIAL.
    RETURN.
  ENDIF. " IF fp_i_rep_lout IS INITIAL

  DATA(li_rep_lout) = fp_i_rep_lout.
  SORT li_rep_lout BY matnr.
  DELETE ADJACENT DUPLICATES FROM li_rep_lout COMPARING matnr.

  lv_curr_year   = p_prsdt(4).
  IF lv_curr_year IS INITIAL.
    lv_curr_year = sy-datum(4).
  ENDIF. " IF lv_curr_year IS INITIAL
  lv_prev_year = lv_curr_year - 1.

* IS-M: Media Product Issue Sequence
  SELECT med_prod    "Higher-Level Media Product
         ismyearnr   "Media issue year number
         matnr       "Media Issue                      "ED1K910672
         ismcopynr   "Copy Number of Media Issue
         ismnrinyear "Issue Number (in Year Number)
         mpg_lfdnr   "Sequence number of media issue within issue sequence
    FROM jptmg0      " IS-M: Media Product Issue Sequence
*    INTO TABLE fp_li_issue_sq                         "ED1K910672
    INTO TABLE li_issue                                     "ED1K910672
     FOR ALL ENTRIES IN li_rep_lout
   WHERE med_prod    EQ li_rep_lout-matnr
     AND ( ismyearnr EQ lv_curr_year
      OR   ismyearnr EQ lv_prev_year ).
  IF sy-subrc EQ 0.
* BOC - BTIRUVATHU - INC0252071- 2019/07/15 - ED1K910672
* Issue Number (ISMNRINYEAR) may contain blank for the Supplement
* and also some contain leading zeros which may result in wrong
* calculation of the issues.. hence making them consistant before
* Sorting.
    LOOP AT li_issue ASSIGNING FIELD-SYMBOL(<lst_sq>).
      IF <lst_sq>-matnr+8(1) NE 'S'.
        IF <lst_sq>-nrinyear IS ASSIGNED.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = <lst_sq>-nrinyear
            IMPORTING
              output = <lst_sq>-nrinyear.
        ENDIF.
        MOVE-CORRESPONDING <lst_sq> TO lw_issue_sq.
        APPEND lw_issue_sq TO fp_li_issue_sq.
      ENDIF.
    ENDLOOP.
*    SORT fp_li_issue_sq BY med_prod ismyearnr copynr.          "ED1K910672
    SORT fp_li_issue_sq BY med_prod ismyearnr copynr nrinyear. "ED1K910672

    LOOP AT fp_li_issue_sq ASSIGNING FIELD-SYMBOL(<lst_issue_sq>).
*      lv_issues = lv_issues + 1.                               "ED1K910672

*     Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
      AT END OF copynr.
        IF lv_volume IS INITIAL.
          lv_volume = <lst_issue_sq>-copynr.
        ELSE. " ELSE -> IF lv_volume IS INITIAL
          CONCATENATE lv_volume
                      <lst_issue_sq>-copynr
                 INTO lv_volume
            SEPARATED BY c_hyphen.
        ENDIF. " IF lv_volume IS INITIAL
      ENDAT.
*     End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
      AT END OF ismyearnr.
        MOVE <lst_issue_sq>-nrinyear TO lv_issues.          "ED1K910672
        SHIFT lv_issues LEFT DELETING LEADING '0'.          "ED1K910672
        <lst_issue_sq>-issues = lv_issues.
*       Begin of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*       <lst_issue_sq>-volume = <lst_issue_sq>-copynr.
*       End   of DEL:CR#490:WROY:25-MAY-2017:ED2K904908
*       Begin of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
        <lst_issue_sq>-volume = lv_volume.
        CLEAR: lv_volume.
*       End   of ADD:CR#490:WROY:25-MAY-2017:ED2K904908
        CLEAR: lv_issues.
      ENDAT.
    ENDLOOP. " LOOP AT fp_li_issue_sq ASSIGNING FIELD-SYMBOL(<lst_issue_sq>)
    DELETE fp_li_issue_sq WHERE issues IS INITIAL AND
                                volume IS INITIAL.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ADD_CURRENCY_SIGN
*&---------------------------------------------------------------------*
*       Add Currency Sign
*----------------------------------------------------------------------*
*      -->FP_LV_KONWA  text
*      -->FP_LV_PRICE  text
*      <--FP_V_COLUMN  text
*----------------------------------------------------------------------*
FORM f_add_currency_sign  USING    fp_lv_konwa TYPE konwa  " Rate unit (currency or percentage)
                                   fp_lv_price TYPE char17 " Lv_price of type CHAR17
                          CHANGING fp_v_column TYPE any.

  CASE fp_lv_konwa.
    WHEN 'USD'.
      CONCATENATE '$' fp_lv_price
             INTO fp_v_column.
      CONDENSE fp_v_column.
    WHEN 'GBP'.
      CONCATENATE '£' fp_lv_price
             INTO fp_v_column.
      CONDENSE fp_v_column.
    WHEN 'EUR'.
      CONCATENATE '€' fp_lv_price
             INTO fp_v_column.
      CONDENSE fp_v_column.
    WHEN OTHERS.
      CONCATENATE '$' fp_lv_price
             INTO fp_v_column.
      CONDENSE fp_v_column.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_CONSTANTS
*&---------------------------------------------------------------------*
*       Fetch Application Constants
*----------------------------------------------------------------------*
*      <--FP_I_CONSTANTS  text
*----------------------------------------------------------------------*
FORM f_fetch_constants  CHANGING fp_i_constants TYPE tt_constant.

* Wiley Application Constant Table
  SELECT param1      "ABAP: Name of variant variable
         param2      "ABAP: Name of variant variable
         srno        "ABAP: Current selection number
         sign        "ABAP: ID: I/E (include/exclude values)
         opti        "ABAP: Selection option (EQ/BT/CP/...)
         low         "Lower Value of Selection Condition
         high        "Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE fp_i_constants
   WHERE devid    EQ c_dev_i0225
     AND activate EQ abap_true
    ORDER BY PRIMARY KEY.
  IF sy-subrc NE 0.
    CLEAR: fp_i_constants.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_CHARC_DTL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_I_REP_LOUT  text
*      <--P_LI_CHAR_DTL  text
*----------------------------------------------------------------------*
FORM f_fetch_charc_dtl  USING    fp_i_rep_lout  TYPE tt_rep_lout
                        CHANGING fp_li_char_dtl TYPE tt_char_dtl.

  DATA(li_rep_lout) = fp_i_rep_lout.
  SORT li_rep_lout BY objek.
  DELETE ADJACENT DUPLICATES FROM li_rep_lout COMPARING objek.

  SELECT objek                      "Key of object to be classified
         atinn                      "Internal characteristic
         atzhl                      "Characteristic value counter
         mafid                      "Indicator: Object/Class
         klart                      "Class Type
         adzhl                      "Internal counter for archiving objects via engin. chg. mgmt
         atwrt                      "Characteristic Value
    FROM ausp                       " Characteristic Values
    INTO TABLE fp_li_char_dtl
     FOR ALL ENTRIES IN li_rep_lout
   WHERE objek EQ li_rep_lout-objek "Key of object to be classified
     AND ( atinn EQ p_ns_ttl        "Characteristic (New Start Title)
      OR   atinn EQ p_megd_w )      "Characteristic (Merged With)
   ORDER BY PRIMARY KEY.
  IF sy-subrc NE 0.
    CLEAR: fp_li_char_dtl.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_MAT_PLANT
*&---------------------------------------------------------------------*
*       Fetch Plant Data for Material
*----------------------------------------------------------------------*
*      -->FP_I_REP_LOUT  text
*      <--FP_LI_MAT_PLNT  text
*----------------------------------------------------------------------*
FORM f_fetch_mat_plant  USING    fp_i_rep_lout  TYPE tt_rep_lout
                        CHANGING fp_li_mat_plnt TYPE tt_mat_plnt.

  DATA(li_rep_lout) = fp_i_rep_lout.
  SORT li_rep_lout BY matnr.
  DELETE ADJACENT DUPLICATES FROM li_rep_lout COMPARING matnr.

  SELECT matnr                      "Material Number
         werks                      "Plant
         herkl                      "Country of origin of the material
    FROM marc                       " Plant Data for Material
    INTO TABLE fp_li_mat_plnt
     FOR ALL ENTRIES IN li_rep_lout
   WHERE matnr EQ li_rep_lout-matnr "Material Number
     AND herkl IN s_land_v          "Country of origin of the material
   ORDER BY PRIMARY KEY.
  IF sy-subrc NE 0.
    CLEAR: fp_li_mat_plnt.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
* Begin of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_FILEPATH
*&---------------------------------------------------------------------*
*       Validate File Path
*----------------------------------------------------------------------*
*      -->FP_FPATH  File Path
*----------------------------------------------------------------------*
FORM f_validate_filepath  USING fp_fpath TYPE text1024. " Case-Sensitive Length 1024

  DATA:
    lv_fpath TYPE string,    "File Path
    lv_reslt TYPE abap_bool. "Result

  IF fp_fpath IS INITIAL.
    RETURN.
  ENDIF. " IF fp_fpath IS INITIAL

  lv_fpath = fp_fpath. "File Path
* Checks if the File Exists
  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file                 = lv_fpath "File to Check
    RECEIVING
      result               = lv_reslt "Result
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      wrong_parameter      = 3
      not_supported_by_gui = 4
      OTHERS               = 5.
  IF sy-subrc NE 0 OR
     lv_reslt EQ abap_false.
*   Message: Invalid File Path or Name
    MESSAGE e186(/virsa/zvir). " Invalid File Path or Name
  ENDIF. " IF sy-subrc NE 0 OR

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_F4_HELP_FILEPATH
*&---------------------------------------------------------------------*
*       Search Help for File Path
*----------------------------------------------------------------------*
*      <--FP_FPATH  File Path
*----------------------------------------------------------------------*
FORM f_f4_help_filepath  CHANGING fp_fpath TYPE text1024. " Case-Sensitive Length 1024

  DATA:
    li_files TYPE filetable. "Table Holding Selected Files

  DATA:
    lv_retcd TYPE i,                    "Return Code, Number of Files or -1 If Error Occurred
    lv_filtr TYPE string VALUE '*.CSV'. "File Extension Filter String

* Display the File Open Dialog
  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      file_filter             = lv_filtr "File Extension Filter String
    CHANGING
      file_table              = li_files "Table Holding Selected Files
      rc                      = lv_retcd "Return Code, Number of Files or -1 If Error Occurred
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.
  IF sy-subrc EQ 0 AND
     lv_retcd GT 0.
    READ TABLE li_files ASSIGNING FIELD-SYMBOL(<lst_file>) INDEX 1.
    IF sy-subrc EQ 0.
      fp_fpath = <lst_file>-filename. "File Path
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF sy-subrc EQ 0 AND

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FILE_RECS
*&---------------------------------------------------------------------*
*       Read File Records
*----------------------------------------------------------------------*
*      <--FP_LI_M_RC_SN1  Rel Cat/Soc No (With Material)
*      <--FP_LI_M_SN_PT1  Soc No/Prc Typ (With Material)
*      <--FP_LI_M_RLTYP1  Rel Category (With Material)
*      <--FP_LI_M_PRTYP1  Price Type (With Material)
*      <--FP_LI_M_RC_SN2  Rel Cat/Soc No (With Material)
*      <--FP_LI_M_SN_PT2  Soc No/Prc Typ (With Material)
*      <--FP_LI_M_RLTYP2  Rel Category (With Material)
*      <--FP_LI_M_PRTYP2  Price Type (With Material)
*----------------------------------------------------------------------*
FORM f_read_file_recs  CHANGING fp_li_m_rs_wm1 TYPE tt_mn_rs_wm
                                fp_li_m_rc_sn1 TYPE tt_mn_rc_sn
                                fp_li_m_sn_pt1 TYPE tt_mn_sn_pt
                                fp_li_m_rltyp1 TYPE tt_mn_rltyp
                                fp_li_m_prtyp1 TYPE tt_mn_prtyp
                                fp_li_m_rs_wm2 TYPE tt_mn_rs_wm
                                fp_li_m_rc_sn2 TYPE tt_mn_rc_sn
                                fp_li_m_sn_pt2 TYPE tt_mn_sn_pt
                                fp_li_m_rltyp2 TYPE tt_mn_rltyp
                                fp_li_m_prtyp2 TYPE tt_mn_prtyp.

  DATA:
    li_file_recs TYPE isjp_t_string.

* Rel Cat/Soc No (Without Material) - Exclude Pricing Only
  IF p_rs_wm1 IS NOT INITIAL.
*   Read complete File Records (String)
    PERFORM f_read_complete_recs USING    p_rs_wm1
                                 CHANGING li_file_recs.
    LOOP AT li_file_recs ASSIGNING FIELD-SYMBOL(<lv_file_rec>).
      APPEND INITIAL LINE TO fp_li_m_rs_wm1 ASSIGNING FIELD-SYMBOL(<lst_m_rs_wm1>).
      SPLIT <lv_file_rec> AT c_comma
       INTO <lst_m_rs_wm1>-rltyp      "Business Partner Relationship Category
            <lst_m_rs_wm1>-soc_numbr. "Business Partner 2 or Society number
*     Convert from External to Internal format (add leading zeros) - Business Partner
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <lst_m_rs_wm1>-soc_numbr  "Business Partner 2 or Society number (External Format)
        IMPORTING
          output = <lst_m_rs_wm1>-soc_numbr. "Business Partner 2 or Society number (Internal Format)
    ENDLOOP. " LOOP AT li_file_recs ASSIGNING FIELD-SYMBOL(<lv_file_rec>)
    SORT fp_li_m_rs_wm1 BY rltyp soc_numbr.
  ENDIF. " IF p_rs_wm1 IS NOT INITIAL
* Rel Cat/Soc No (Without Material) - Exclude Pricing and Products
  IF p_rs_wm2 IS NOT INITIAL.
*   Read complete File Records (String)
    PERFORM f_read_complete_recs USING    p_rs_wm2
                                 CHANGING li_file_recs.
    LOOP AT li_file_recs ASSIGNING <lv_file_rec>.
      APPEND INITIAL LINE TO fp_li_m_rs_wm2 ASSIGNING FIELD-SYMBOL(<lst_m_rs_wm2>).
      SPLIT <lv_file_rec> AT c_comma
       INTO <lst_m_rs_wm2>-rltyp      "Business Partner Relationship Category
            <lst_m_rs_wm2>-soc_numbr. "Business Partner 2 or Society number
*     Convert from External to Internal format (add leading zeros) - Business Partner
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <lst_m_rs_wm2>-soc_numbr  "Business Partner 2 or Society number (External Format)
        IMPORTING
          output = <lst_m_rs_wm2>-soc_numbr. "Business Partner 2 or Society number (Internal Format)
    ENDLOOP. " LOOP AT li_file_recs ASSIGNING <lv_file_rec>
    SORT fp_li_m_rs_wm2 BY rltyp soc_numbr.
  ENDIF. " IF p_rs_wm2 IS NOT INITIAL
* Rel Cat/Soc No (With Material) - Exclude Pricing Only
  IF p_rc_sn1 IS NOT INITIAL.
*   Read complete File Records (String)
    PERFORM f_read_complete_recs USING    p_rc_sn1
                                 CHANGING li_file_recs.
    LOOP AT li_file_recs ASSIGNING <lv_file_rec>.
      APPEND INITIAL LINE TO fp_li_m_rc_sn1 ASSIGNING FIELD-SYMBOL(<lst_m_rc_sn1>).
      SPLIT <lv_file_rec> AT c_comma
       INTO <lst_m_rc_sn1>-matnr      "Material Number
            <lst_m_rc_sn1>-rltyp      "Business Partner Relationship Category
            <lst_m_rc_sn1>-soc_numbr. "Business Partner 2 or Society number

*     Convert from External to Internal format (add leading zeros) - Material Number
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = <lst_m_rc_sn1>-matnr "Material Number
        IMPORTING
          output       = <lst_m_rc_sn1>-matnr "Material Number
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.
      IF sy-subrc NE 0.
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
*     Convert from External to Internal format (add leading zeros) - Business Partner
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <lst_m_rc_sn1>-soc_numbr  "Business Partner 2 or Society number (External Format)
        IMPORTING
          output = <lst_m_rc_sn1>-soc_numbr. "Business Partner 2 or Society number (Internal Format)
    ENDLOOP. " LOOP AT li_file_recs ASSIGNING <lv_file_rec>
    SORT fp_li_m_rc_sn1 BY matnr rltyp soc_numbr.
  ENDIF. " IF p_rc_sn1 IS NOT INITIAL
* Rel Cat/Soc No (With Material) - Exclude Pricing and Products
  IF p_rc_sn2 IS NOT INITIAL.
*   Read complete File Records (String)
    PERFORM f_read_complete_recs USING    p_rc_sn2
                                 CHANGING li_file_recs.
    LOOP AT li_file_recs ASSIGNING <lv_file_rec>.
      APPEND INITIAL LINE TO fp_li_m_rc_sn2 ASSIGNING FIELD-SYMBOL(<lst_m_rc_sn2>).
      SPLIT <lv_file_rec> AT c_comma
       INTO <lst_m_rc_sn2>-matnr      "Material Number
            <lst_m_rc_sn2>-rltyp      "Business Partner Relationship Category
            <lst_m_rc_sn2>-soc_numbr. "Business Partner 2 or Society number

*     Convert from External to Internal format (add leading zeros) - Material Number
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = <lst_m_rc_sn2>-matnr "Material Number
        IMPORTING
          output       = <lst_m_rc_sn2>-matnr "Material Number
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.
      IF sy-subrc NE 0.
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
*     Convert from External to Internal format (add leading zeros) - Business Partner
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <lst_m_rc_sn2>-soc_numbr  "Business Partner 2 or Society number (External Format)
        IMPORTING
          output = <lst_m_rc_sn2>-soc_numbr. "Business Partner 2 or Society number (Internal Format)
    ENDLOOP. " LOOP AT li_file_recs ASSIGNING <lv_file_rec>
    SORT fp_li_m_rc_sn2 BY matnr rltyp soc_numbr.
  ENDIF. " IF p_rc_sn2 IS NOT INITIAL

* Soc No/Prc Typ (With Material) - Exclude Pricing Only
  IF p_sn_pt1 IS NOT INITIAL.
*   Read complete File Records (String)
    PERFORM f_read_complete_recs USING    p_sn_pt1
                                 CHANGING li_file_recs.
    LOOP AT li_file_recs ASSIGNING <lv_file_rec>.
      APPEND INITIAL LINE TO fp_li_m_sn_pt1 ASSIGNING FIELD-SYMBOL(<lst_m_sn_pt1>).
      SPLIT <lv_file_rec> AT c_comma
       INTO <lst_m_sn_pt1>-matnr      "Material Number
            <lst_m_sn_pt1>-soc_numbr  "Business Partner 2 or Society number
            <lst_m_sn_pt1>-price_typ. "Price Type

*     Convert from External to Internal format (add leading zeros) - Material Number
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = <lst_m_sn_pt1>-matnr "Material Number
        IMPORTING
          output       = <lst_m_sn_pt1>-matnr "Material Number
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.
      IF sy-subrc NE 0.
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
*     Convert from External to Internal format (add leading zeros) - Business Partner
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <lst_m_sn_pt1>-soc_numbr  "Business Partner 2 or Society number (External Format)
        IMPORTING
          output = <lst_m_sn_pt1>-soc_numbr. "Business Partner 2 or Society number (Internal Format)
    ENDLOOP. " LOOP AT li_file_recs ASSIGNING <lv_file_rec>
    SORT fp_li_m_sn_pt1 BY matnr soc_numbr price_typ.
  ENDIF. " IF p_sn_pt1 IS NOT INITIAL
* Soc No/Prc Typ (With Material) - Exclude Pricing and Products
  IF p_sn_pt2 IS NOT INITIAL.
*   Read complete File Records (String)
    PERFORM f_read_complete_recs USING    p_sn_pt2
                                 CHANGING li_file_recs.
    LOOP AT li_file_recs ASSIGNING <lv_file_rec>.
      APPEND INITIAL LINE TO fp_li_m_sn_pt2 ASSIGNING FIELD-SYMBOL(<lst_m_sn_pt2>).
      SPLIT <lv_file_rec> AT c_comma
       INTO <lst_m_sn_pt2>-matnr      "Material Number
            <lst_m_sn_pt2>-soc_numbr  "Business Partner 2 or Society number
            <lst_m_sn_pt2>-price_typ. "Price Type

*     Convert from External to Internal format (add leading zeros) - Material Number
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = <lst_m_sn_pt2>-matnr "Material Number
        IMPORTING
          output       = <lst_m_sn_pt2>-matnr "Material Number
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.
      IF sy-subrc NE 0.
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
*     Convert from External to Internal format (add leading zeros) - Business Partner
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <lst_m_sn_pt2>-soc_numbr  "Business Partner 2 or Society number (External Format)
        IMPORTING
          output = <lst_m_sn_pt2>-soc_numbr. "Business Partner 2 or Society number (Internal Format)
    ENDLOOP. " LOOP AT li_file_recs ASSIGNING <lv_file_rec>
    SORT fp_li_m_sn_pt2 BY matnr soc_numbr price_typ.
  ENDIF. " IF p_sn_pt2 IS NOT INITIAL

* Rel Category (With Material) - Exclude Pricing Only
  IF p_rltyp1 IS NOT INITIAL.
*   Read complete File Records (String)
    PERFORM f_read_complete_recs USING    p_rltyp1
                                 CHANGING li_file_recs.
    LOOP AT li_file_recs ASSIGNING <lv_file_rec>.
      APPEND INITIAL LINE TO fp_li_m_rltyp1 ASSIGNING FIELD-SYMBOL(<lst_m_rltyp1>).
      SPLIT <lv_file_rec> AT c_comma
       INTO <lst_m_rltyp1>-matnr      "Material Number
            <lst_m_rltyp1>-rel_ctgry. "Business Partner Relationship Category

*     Convert from External to Internal format (add leading zeros) - Material Number
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = <lst_m_rltyp1>-matnr "Material Number
        IMPORTING
          output       = <lst_m_rltyp1>-matnr "Material Number
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.
      IF sy-subrc NE 0.
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
    ENDLOOP. " LOOP AT li_file_recs ASSIGNING <lv_file_rec>
    SORT fp_li_m_rltyp1 BY matnr rel_ctgry.
  ENDIF. " IF p_rltyp1 IS NOT INITIAL
* Rel Category (With Material) - Exclude Pricing and Products
  IF p_rltyp2 IS NOT INITIAL.
*   Read complete File Records (String)
    PERFORM f_read_complete_recs USING    p_rltyp2
                                 CHANGING li_file_recs.
    LOOP AT li_file_recs ASSIGNING <lv_file_rec>.
      APPEND INITIAL LINE TO fp_li_m_rltyp2 ASSIGNING FIELD-SYMBOL(<lst_m_rltyp2>).
      SPLIT <lv_file_rec> AT c_comma
       INTO <lst_m_rltyp2>-matnr      "Material Number
            <lst_m_rltyp2>-rel_ctgry. "Business Partner Relationship Category

*     Convert from External to Internal format (add leading zeros) - Material Number
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = <lst_m_rltyp2>-matnr "Material Number
        IMPORTING
          output       = <lst_m_rltyp2>-matnr "Material Number
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.
      IF sy-subrc NE 0.
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
    ENDLOOP. " LOOP AT li_file_recs ASSIGNING <lv_file_rec>
    SORT fp_li_m_rltyp2 BY matnr rel_ctgry.
  ENDIF. " IF p_rltyp2 IS NOT INITIAL

* Price Type (With Material) - Exclude Pricing Only
  IF p_prtyp1 IS NOT INITIAL.
*   Read complete File Records (String)
    PERFORM f_read_complete_recs USING    p_prtyp1
                                 CHANGING li_file_recs.
    LOOP AT li_file_recs ASSIGNING <lv_file_rec>.
      APPEND INITIAL LINE TO fp_li_m_prtyp1 ASSIGNING FIELD-SYMBOL(<lst_m_prtyp1>).
      SPLIT <lv_file_rec> AT c_comma
       INTO <lst_m_prtyp1>-matnr      "Material Number
            <lst_m_prtyp1>-price_typ. "Price Type

*     Convert from External to Internal format (add leading zeros) - Material Number
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = <lst_m_prtyp1>-matnr "Material Number
        IMPORTING
          output       = <lst_m_prtyp1>-matnr "Material Number
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.
      IF sy-subrc NE 0.
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
    ENDLOOP. " LOOP AT li_file_recs ASSIGNING <lv_file_rec>
    SORT fp_li_m_prtyp1 BY matnr price_typ.
  ENDIF. " IF p_prtyp1 IS NOT INITIAL
* Price Type (With Material) - Exclude Pricing and Products
  IF p_prtyp2 IS NOT INITIAL.
*   Read complete File Records (String)
    PERFORM f_read_complete_recs USING    p_prtyp2
                                 CHANGING li_file_recs.
    LOOP AT li_file_recs ASSIGNING <lv_file_rec>.
      APPEND INITIAL LINE TO fp_li_m_prtyp2 ASSIGNING FIELD-SYMBOL(<lst_m_prtyp2>).
      SPLIT <lv_file_rec> AT c_comma
       INTO <lst_m_prtyp2>-matnr      "Material Number
            <lst_m_prtyp2>-price_typ. "Price Type

*     Convert from External to Internal format (add leading zeros) - Material Number
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = <lst_m_prtyp2>-matnr "Material Number
        IMPORTING
          output       = <lst_m_prtyp2>-matnr "Material Number
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.
      IF sy-subrc NE 0.
*       Nothing to do
      ENDIF. " IF sy-subrc NE 0
    ENDLOOP. " LOOP AT li_file_recs ASSIGNING <lv_file_rec>
    SORT fp_li_m_prtyp2 BY matnr price_typ.
  ENDIF. " IF p_prtyp2 IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_COMPLETE_RECS
*&---------------------------------------------------------------------*
*       Read complete File Records (String)
*----------------------------------------------------------------------*
*      -->FP_FPATH         File Path
*      <--FP_LI_FILE_RECS  File Records (String)
*----------------------------------------------------------------------*
FORM f_read_complete_recs  USING    fp_fpath        TYPE text1024 " Case-Sensitive Length 1024
                           CHANGING fp_li_file_recs TYPE isjp_t_string.

  DATA:
    lv_fpath TYPE string. "File Path

  lv_fpath = fp_fpath. "File Path
  CLEAR: fp_li_file_recs.
* Upload Data from Client PC
  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename                = lv_fpath        "File Path
    CHANGING
      data_tab                = fp_li_file_recs "Transfer table for file contents
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      not_supported_by_gui    = 17
      error_no_gui            = 18
      OTHERS                  = 19.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid
          TYPE c_msgty_i
        NUMBER sy-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4.
  ELSE. " ELSE -> IF sy-subrc NE 0
*   Very first line will be the Column headings
    DELETE fp_li_file_recs INDEX 1.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_EXCLD_PRICING
*&---------------------------------------------------------------------*
*       Exclude Pricing Only - File Records
*----------------------------------------------------------------------*
*      -->FP_LI_M_RC_SN1  Rel Cat/Soc No (With Material)
*      -->FP_LI_M_SN_PT1  Soc No/Prc Typ (With Material)
*      -->FP_LI_M_RLTYP1  Rel Category (With Material)
*      -->FP_LI_M_PRTYP1  Price Type (With Material)
*      -->FP_LST_REP_LOUT Report Layout
*      <--PP_LV_FILTER    Flag: To Filter Records
*----------------------------------------------------------------------*
FORM f_excld_pricing  USING    fp_li_m_rs_wm1  TYPE tt_mn_rs_wm
                               fp_li_m_rc_sn1  TYPE tt_mn_rc_sn
                               fp_li_m_sn_pt1  TYPE tt_mn_sn_pt
                               fp_li_m_rltyp1  TYPE tt_mn_rltyp
                               fp_li_m_prtyp1  TYPE tt_mn_prtyp
                               fp_lst_rep_lout TYPE ty_rep_lout
                      CHANGING fp_lv_filter    TYPE flag. " General Flag

* Rel Cat/Soc No (Without Material)
  IF fp_lv_filter IS INITIAL.
    READ TABLE fp_li_m_rs_wm1 TRANSPORTING NO FIELDS
         WITH KEY rltyp     = fp_lst_rep_lout-rltyp
                  soc_numbr = fp_lst_rep_lout-soc_numbr
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      fp_lv_filter = abap_true.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_lv_filter IS INITIAL
* Rel Cat/Soc No (With Material)
  IF fp_lv_filter IS INITIAL.
    READ TABLE fp_li_m_rc_sn1 TRANSPORTING NO FIELDS
         WITH KEY matnr     = fp_lst_rep_lout-matnr
                  rltyp     = fp_lst_rep_lout-rltyp
                  soc_numbr = fp_lst_rep_lout-soc_numbr
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      fp_lv_filter = abap_true.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_lv_filter IS INITIAL
* Soc No/Prc Typ (With Material)
  IF fp_lv_filter IS INITIAL.
    READ TABLE fp_li_m_sn_pt1 TRANSPORTING NO FIELDS
         WITH KEY matnr     = fp_lst_rep_lout-matnr
                  soc_numbr = fp_lst_rep_lout-soc_numbr
                  price_typ = fp_lst_rep_lout-knuma_ag
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      fp_lv_filter = abap_true.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_lv_filter IS INITIAL
* Relationship Category (With Material)
  IF fp_lv_filter IS INITIAL.
    READ TABLE fp_li_m_rltyp1 TRANSPORTING NO FIELDS
         WITH KEY matnr     = fp_lst_rep_lout-matnr
                  rel_ctgry = fp_lst_rep_lout-rltyp
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      fp_lv_filter = abap_true.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_lv_filter IS INITIAL
* Price Type (With Material)
  IF fp_lv_filter IS INITIAL.
    READ TABLE fp_li_m_prtyp1 TRANSPORTING NO FIELDS
         WITH KEY matnr     = fp_lst_rep_lout-matnr
                  price_typ = fp_lst_rep_lout-knuma_ag
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      fp_lv_filter = abap_true.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_lv_filter IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_EXCLD_PRC_N_PRD
*&---------------------------------------------------------------------*
*       Exclude Pricing and Products - File Records
*----------------------------------------------------------------------*
*      -->FP_LI_M_RC_SN2  Rel Cat/Soc No (With Material)
*      -->FP_LI_M_SN_PT2  Soc No/Prc Typ (With Material)
*      -->FP_LI_M_RLTYP2  Rel Category (With Material)
*      -->FP_LI_M_PRTYP2  Price Type (With Material)
*      -->FP_LST_REP_LOUT Report Layout
*      <--FP_LV_FILTER    Flag: To Filter Records
*----------------------------------------------------------------------*
FORM f_excld_prc_n_prd  USING    fp_li_m_rs_wm2  TYPE tt_mn_rs_wm
                                 fp_li_m_rc_sn2  TYPE tt_mn_rc_sn
                                 fp_li_m_sn_pt2  TYPE tt_mn_sn_pt
                                 fp_li_m_rltyp2  TYPE tt_mn_rltyp
                                 fp_li_m_prtyp2  TYPE tt_mn_prtyp
                                 fp_lst_rep_lout TYPE ty_rep_lout
                        CHANGING fp_lv_filter    TYPE flag. " General Flag

* Rel Cat/Soc No (Without Material)
  IF fp_lv_filter IS INITIAL.
    READ TABLE fp_li_m_rs_wm2 TRANSPORTING NO FIELDS
         WITH KEY rltyp     = fp_lst_rep_lout-rltyp
                  soc_numbr = fp_lst_rep_lout-soc_numbr
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      fp_lv_filter = abap_true.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_lv_filter IS INITIAL
* Rel Cat/Soc No (With Material)
  IF fp_lv_filter IS INITIAL.
    READ TABLE fp_li_m_rc_sn2 TRANSPORTING NO FIELDS
         WITH KEY matnr     = fp_lst_rep_lout-matnr
                  rltyp     = fp_lst_rep_lout-rltyp
                  soc_numbr = fp_lst_rep_lout-soc_numbr
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      fp_lv_filter = abap_true.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_lv_filter IS INITIAL
* Soc No/Prc Typ (With Material)
  IF fp_lv_filter IS INITIAL.
    READ TABLE fp_li_m_sn_pt2 TRANSPORTING NO FIELDS
         WITH KEY matnr     = fp_lst_rep_lout-matnr
                  soc_numbr = fp_lst_rep_lout-soc_numbr
                  price_typ = fp_lst_rep_lout-knuma_ag
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      fp_lv_filter = abap_true.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_lv_filter IS INITIAL
* Relationship Category (With Material)
  IF fp_lv_filter IS INITIAL.
    READ TABLE fp_li_m_rltyp2 TRANSPORTING NO FIELDS
         WITH KEY matnr     = fp_lst_rep_lout-matnr
                  rel_ctgry = fp_lst_rep_lout-rltyp
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      fp_lv_filter = abap_true.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_lv_filter IS INITIAL
* Price Type (With Material)
  IF fp_lv_filter IS INITIAL.
    READ TABLE fp_li_m_prtyp2 TRANSPORTING NO FIELDS
         WITH KEY matnr     = fp_lst_rep_lout-matnr
                  price_typ = fp_lst_rep_lout-knuma_ag
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      fp_lv_filter = abap_true.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_lv_filter IS INITIAL

ENDFORM.
* End   of ADD:CR#565:WROY:08-JUL-2017:ED2K904908
