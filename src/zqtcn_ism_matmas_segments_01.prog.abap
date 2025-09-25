*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ISM_MATMAS_SEGMENTS_01
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K912668, ED2K912691
* REFERENCE NO: E158 - CR#6318
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI/KKR)
* DATE: 07/26/2018
* DESCRIPTION: Populating the Custom segment Z1QTC_E1MARAM_01
* with Purchase Order Number
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

* Local variables
* Begig of: CR#6318  KKR20180716  ED2K912668
DATA: lst_e1maram          TYPE e1maram,          " Structure for Segment: E1MARAM
      lv_matnr_e1maram     TYPE matnr,            " Material Number
      lst_idoc_data        TYPE edidd,            " Data record (IDoc)
      lst_z1qtc_e1maram_01 TYPE z1qtc_e1maram_01, " Structure for Segment: Z1QTC_E1MARAM_01
      lv_mattyp            TYPE mtart,            " Material Type
      lv_aa_cat            TYPE knttp,            " Account Assignment Category
      lv_pur_doctyp        TYPE esart,            " Purchasing Document Type
      lv_our_ref           TYPE unsez,            " Our Reference
      lir_aa_cat           TYPE RANGE OF knttp,   " Range: Account Assignment Category
      lir_pur_doctyp       TYPE RANGE OF esart,   " Range: Purchase Document Type
      lir_our_ref          TYPE RANGE OF unsez.   " Range: Our Reference
* End of: CR#6318  KKR20180716  ED2K912668

* Local constants
* Begig of: CR#6318  KKR20180716  ED2K912668
CONSTANTS:
  lc_e1maram            TYPE edilsegtyp VALUE 'E1MARAM',          " Segment Name (E1MARAM)
  lc_z1qtc_e1maram_01   TYPE edilsegtyp VALUE 'Z1QTC_E1MARAM_01', " Segment Name (Z1QTC_E1MARAM_01)
  lc_delind             TYPE eloek      VALUE 'X',                " Deletion Indicator in Purchasing Document
  lc_mattyp_p1_e158     TYPE rvari_vnam VALUE 'MATERIAL_TYPE',            " Param1: Material Type: Print Product (ZJIP)
  lc_aa_cat_p1_e158     TYPE rvari_vnam VALUE 'ACCT_ASS_CAT',     " Param1: Account Assignment Category: Project (P)
  lc_pur_doctyp_p1_e158 TYPE rvari_vnam VALUE 'PUR_DOC_TYP',      " Param1: Purchasing Document Type
  lc_our_ref_p1_e158    TYPE rvari_vnam VALUE 'OUR_REF',          " Param1: Our Reference
  lc_devid_e158         TYPE zdevid     VALUE 'E158',             " Development ID
  lc_mattyp_p2_e158     TYPE rvari_vnam VALUE 'MTART',    " Param2: Material Type
  lc_aa_cat_p2_e158     TYPE rvari_vnam VALUE 'KNTTP',            " Param2: Account Assignment Category
  lc_pur_doctyp_p2_e158 TYPE rvari_vnam VALUE 'BSART',            " Param2: Purchasing Document Type
  lc_our_ref_p2_e158    TYPE rvari_vnam VALUE 'UNSEZ'.            " Param2: Our Reference
* End of: CR#6318  KKR20180716  ED2K912668

* Begig of: CR#6318  KKR20180716  ED2K912668
* Below Logic is implemented to add a custom segment 'Z1QTC_E1MARAM_01'
* to IDOC Data table 't_idoc_data'
lst_e1maram = t_idoc_data[ segnam = lc_e1maram ]-sdata.
lv_matnr_e1maram = lst_e1maram-matnr.

IF lv_matnr_e1maram IS NOT INITIAL.
  SELECT devid, param1, param2, sign, opti, low, high
         FROM zcaconstant INTO TABLE @DATA(lit_constant)
         WHERE devid = @lc_devid_e158 AND
               activate = @abap_true.
  IF lit_constant[] IS NOT INITIAL.
    LOOP AT lit_constant  ASSIGNING FIELD-SYMBOL(<lif_constant>).
      CASE <lif_constant>-param1.
        WHEN lc_aa_cat_p1_e158.     " 'ACCT_ASS_CAT'.
          APPEND INITIAL LINE TO lir_aa_cat ASSIGNING FIELD-SYMBOL(<lif_aa_cat>).
          <lif_aa_cat>-sign   = <lif_constant>-sign.
          <lif_aa_cat>-option = <lif_constant>-opti.
          <lif_aa_cat>-low    = <lif_constant>-low.
          <lif_aa_cat>-high   = <lif_constant>-high.

        WHEN lc_pur_doctyp_p1_e158. " 'PUR_DOC_TYP'.
          APPEND INITIAL LINE TO lir_pur_doctyp ASSIGNING FIELD-SYMBOL(<lif_pur_doctyp>).
          <lif_pur_doctyp>-sign   = <lif_constant>-sign.
          <lif_pur_doctyp>-option = <lif_constant>-opti.
          <lif_pur_doctyp>-low    = <lif_constant>-low.
          <lif_pur_doctyp>-high   = <lif_constant>-high.

        WHEN lc_our_ref_p1_e158.    " 'OUR_REF'
          APPEND INITIAL LINE TO lir_our_ref ASSIGNING FIELD-SYMBOL(<lif_our_ref>).
          <lif_our_ref>-sign   = <lif_constant>-sign.
          <lif_our_ref>-option = <lif_constant>-opti.
          <lif_our_ref>-low    = <lif_constant>-low.
          <lif_our_ref>-high   = <lif_constant>-high.

        WHEN OTHERS.
          " Not required in this CASE
      ENDCASE.
    ENDLOOP. " LOOP AT i_constant ASSIGNING FIELD-SYMBOL(<fs_constant>)

*    lv_aa_cat = lit_constant[ param1 = lc_aa_cat_p1_e158 param2 = lc_aa_cat_p2_e158 ]-low.
*    lv_our_ref = lit_constant[ param1 = lc_our_ref_p1_e158 param2 = lc_our_ref_p2_e158 ]-low.
*    lv_pur_doctyp = lit_constant[ param1 = lc_pur_doctyp_p1_e158 param2 = lc_pur_doctyp_p2_e158 ]-low.
    lv_mattyp = lit_constant[ param1 = lc_mattyp_p1_e158 param2 = lc_mattyp_p2_e158 ]-low.
  ENDIF. " IF lit_constant[] IS NOT INITIAL.

  SELECT DISTINCT ekpo~ebeln FROM ekpo INNER JOIN ekko
                             ON ekpo~ebeln = ekko~ebeln
                             INTO TABLE @DATA(lit_ebeln)
                             WHERE ekpo~matnr = @lv_matnr_e1maram AND  " Material Number
                                   ekpo~knttp IN @lir_aa_cat AND       " Account Assignment Category: 'P'
                                   ekpo~mtart = @lv_mattyp AND         " Material Type: 'ZJIP'
                                   ekko~bsart IN @lir_pur_doctyp AND   " Purchasing Document Type 'NB'
                                   ekko~loekz = @space AND             " Deletion Indicator in Purchasing Document
                                   ekko~statu <> @space AND            " Status of Purchasing Document
                                   ekko~unsez IN @lir_our_ref.         " Our Reference 'FIRSTRUN'
  IF lit_ebeln[] IS NOT INITIAL.
    DATA(lis_ebeln) = lit_ebeln[ 1 ].
    lst_z1qtc_e1maram_01-ebeln = lis_ebeln-ebeln.
  ELSE.
    lst_z1qtc_e1maram_01-ebeln = ''.
  ENDIF. " IF lit_ebeln[] IS NOT INITIAL
  lst_idoc_data-segnam = lc_z1qtc_e1maram_01.
  lst_idoc_data-sdata = lst_z1qtc_e1maram_01.
  APPEND lst_idoc_data TO t_idoc_data.
  CLEAR: lst_idoc_data, lst_z1qtc_e1maram_01, lis_ebeln.

*  SELECT DISTINCT ebeln FROM ekpo INTO TABLE @DATA(lit_ebeln_ekpo)
*                        WHERE matnr = @lv_matnr_e1maram AND " Material Number
*                              knttp = @lc_aa_cat AND  " Account Assignment Category: 'P'
*                              mtart = @lc_mattyp.     " Material Type: 'ZJIP'
*  IF lit_ebeln_ekpo[] IS NOT INITIAL.
*    SELECT ebeln FROM ekko INTO TABLE @DATA(lit_ebeln_ekko)
*                 FOR ALL ENTRIES IN @lit_ebeln_ekpo
*                 WHERE ebeln = @lit_ebeln_ekpo-ebeln AND  " Purchasing Document Number
*                       bsart = @lc_doctype AND            " Purchasing Document Type
*                       loekz = @space AND                 " Deletion Indicator in Purchasing Document
*                       statu <> @space AND                " Status of Purchasing Document
*                       unsez = @lc_ref.                   " Our Reference
*    IF lit_ebeln_ekko[] IS NOT INITIAL.
*      DATA(lis_ebeln_ekko) = lit_ebeln_ekko[ 1 ].
*      lst_z1qtc_e1maram_01-ebeln = lis_ebeln_ekko-ebeln.
*      lst_idoc_data-segnam = lc_z1qtc_e1maram_01.
*      lst_idoc_data-sdata = lst_z1qtc_e1maram_01.
*      APPEND lst_idoc_data TO t_idoc_data.
*      CLEAR: lst_idoc_data, lst_z1qtc_e1maram_01.
*    ENDIF. " IF lit_ebeln_ekko[] IS NOT INITIAL
*  ENDIF. " IF lit_ebeln_ekpo[] IS NOT INITIAL

ENDIF. " IF lv_matnr_e1maram IS NOT INITIAL.
* End of: CR#6318  KKR20180716  ED2K912668

*  True Delta - Segments related to MARA table
PERFORM f_delta_segment_mara IN PROGRAM saplzqtc_ism_matmas_ob_cp IF FOUND
  USING mara
  CHANGING idoc_cimtype
           t_idoc_data[].
