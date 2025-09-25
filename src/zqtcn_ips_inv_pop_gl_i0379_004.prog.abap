*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_IPS_INV_POP_GL_I0379_004
* PROGRAM DESCRIPTION: Include program for populating
*                      1. Tax code and Tax jurisdiction code in PO and
*                         GL accouting line item
*                      2. Populate the GL line items from custom accouting
*                         segment
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE:   2020-03-01
* OBJECT ID:I0379 (ERPM-11517)
* TRANSPORT NUMBER(S): ED2K917673
*-------------------------------------------------------------------*
**Local type declarations
TYPES : BEGIN OF lty1_ekkn_data,
          kokrs   TYPE kokrs,      " Controlling Area
          prctr   TYPE prctr,      " Profit Center
          wbs_ele TYPE ps_psp_pnr, " Work Breakdown Structure Element (WBS Element)
          kostl   TYPE kostl,      " Cost Center
        END OF lty1_ekkn_data,
        BEGIN OF lty1_constant,
          devid    TYPE zdevid,              " Development id
          param1   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
          param2   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
          srno     TYPE tvarv_numb,          " Serial number
          sign     TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
          opti     TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
          low      TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
          high     TYPE salv_de_selopt_high, " Upper Value of Selection Condition
          activate TYPE zconstactive,        " Activate
        END OF lty1_constant.
*constant data declaration
CONSTANTS : lc1_seg_z1qtc_itm_acc TYPE edilsegtyp VALUE 'Z1QTC_ITM_ACC_DATA_01', " Segment type
            lc1_devid_i0379       TYPE zdevid VALUE 'I0379',            " Development ID
            lc1_kostl             TYPE rvari_vnam VALUE 'KOSTL',        " ABAP:Name of Variant Variable
            lc1_txjcd             TYPE  rvari_vnam VALUE 'TXJCD',       " ABAP: Name of Variant Variable
            lc1_hkont             TYPE rvari_vnam VALUE 'HKONT',        " ABAP: Name of Variant Variable
            lc1_taxcd_noamt       TYPE  rvari_vnam VALUE 'TAXCD_NOAMT'. " ABAP: Name of Variant Variable

*data declarations
DATA: li1_idoc_data      TYPE STANDARD TABLE OF edidd " Data record (IDoc)
                        INITIAL SIZE 0,
      lst1_z1qtc_itm_acc TYPE z1qtc_itm_acc_data_01,  " I0379 - IPS Invoice Interface-Accounting data for line item
      lv1_txjcd          TYPE ad_txjcd,               " Tax Jurisdiction
      lv1_hkont          TYPE hkont,                  " GL account
      lst1_co_data       TYPE cobl_mrm,               " Account Assignment Fields for Invoice Verification
      lv1_ekorg          TYPE ekorg,                  " Purchasing Organization
      lst1_frseg         TYPE mmcr_frseg,
      lst1_ekkn          TYPE lty1_ekkn_data,          " cost object data
      li1_const_data     TYPE STANDARD TABLE OF lty1_constant INITIAL SIZE 0,
      lst1_const_data    TYPE    lty1_constant,
      lv1_taxcd_noamt    TYPE    mwskz,       " Tax on sales/purchases code
      lv1_kostl          TYPE    kostl,       " Cost center
      lv1_belnr          TYPE    belnr_d, " Accounting Document Number
      lv1_gjahr          TYPE    gjahr.   " Fiscal Year
FREE:li1_idoc_data,li1_const_data.
CLEAR:lv1_txjcd,lst1_co_data,lv1_ekorg,lst1_frseg,lst1_ekkn,lst1_const_data,
lv1_taxcd_noamt,lv1_kostl,lv1_belnr,lv1_gjahr.
**Check if document is already present in SAP in Parked or posted status.
SELECT belnr " Document Number of an Invoice Document
       gjahr " Fiscal Year
  FROM rbkp  " Generated Table for View
  INTO (lv1_belnr , lv1_gjahr )
  UP TO 1 ROWS
  WHERE xblnr = e_rbkpv-xblnr
    AND bukrs = e_rbkpv-bukrs
    AND lifnr = e_rbkpv-lifnr
    AND waers = e_rbkpv-waers
    AND rmwwr = e_rbkpv-rmwwr.
ENDSELECT.
IF sy-subrc EQ 0.
  SELECT SINGLE ebeln FROM rseg
        INTO @DATA(lv_ebeln)
        WHERE belnr = @lv1_belnr AND gjahr = @lv1_gjahr.
  IF sy-subrc = 0.
    READ TABLE t_frseg INTO lst1_frseg WITH KEY ebeln = lv_ebeln.
    IF sy-subrc = 0.
*•  If the Reference + Vendor + Currency + Purchase Order + Amount already exist as Posted document.
      MESSAGE e512(zqtc_r2) WITH lv1_belnr lv1_gjahr. " Invoice already entered as logistics inv. doc. number &1 &2.
    ENDIF.
  ENDIF.
ENDIF. " IF sy-subrc EQ 0
* Get data from constant table
SELECT devid                   "Development ID
       param1                  "ABAP: Name of Variant Variable
       param2                  "ABAP: Name of Variant Variable
       srno                    "Current selection number
       sign                    "ABAP: ID: I/E (include/exclude values)
       opti                    "ABAP: Selection option (EQ/BT/CP/...)
       low                     "Lower Value of Selection Condition
       high                    "Upper Value of Selection Condition
       activate                "Activation indicator for constant
   FROM zcaconstant            " Wiley Application Constant Table
   INTO TABLE li1_const_data
   WHERE devid    = lc1_devid_i0379
   AND   activate = abap_true. "Only active record

IF sy-subrc EQ 0.

  SORT li1_const_data BY param1 low.

  READ TABLE li1_const_data INTO lst1_const_data
                        WITH KEY param1 = lc1_txjcd
                        BINARY SEARCH.
  IF sy-subrc EQ 0.

    lv1_txjcd  = lst1_const_data-low.

  ENDIF. " IF sy-subrc EQ 0


*Tax code for US - Tax amount not present
  READ TABLE li1_const_data INTO lst1_const_data
                        WITH KEY param1 = lc1_taxcd_noamt
                        BINARY SEARCH.
  IF sy-subrc EQ 0.

    lv1_taxcd_noamt  = lst1_const_data-low.

  ENDIF. " IF sy-subrc EQ 0
*Cost center
  READ TABLE li1_const_data INTO lst1_const_data
                        WITH KEY param1 = lc1_kostl
                        BINARY SEARCH.
  IF sy-subrc EQ 0.

    lv1_kostl  = lst1_const_data-low.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv1_kostl
      IMPORTING
        output = lv1_kostl.

  ENDIF. " IF sy-subrc EQ 0
  READ TABLE li1_const_data INTO lst1_const_data
                      WITH KEY param1 = lc1_hkont
                      BINARY SEARCH.
  IF sy-subrc EQ 0.

    lv1_hkont  = lst1_const_data-low.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv1_hkont
      IMPORTING
        output = lv1_hkont.

  ENDIF. " IF sy-subrc EQ 0


ENDIF. " IF sy-subrc EQ 0

CALL FUNCTION 'ZQTC_GET_IDOC_DATA_IPS_I0379'
  IMPORTING
    et_data_idoc = li1_idoc_data.

*get the Tax lines from header level to populate the Tax codes.
*  Get the vendor data
IF e_rbkpv-rbtx[] IS NOT INITIAL.
**Update the Tax jurisdiction code into Tax code line items
** along with Tax number
  LOOP AT e_rbkpv-rbtx ASSIGNING FIELD-SYMBOL(<lst1_rbtx>).
    <lst1_rbtx>-mwskz = lv1_taxcd_noamt.
    <lst1_rbtx>-txjcd = lv1_txjcd.
    <lst1_rbtx>-txjdp = lv1_txjcd.
    <lst1_rbtx>-buzei = '1'.
  ENDLOOP. " LOOP AT e_rbkpv-rbtx ASSIGNING FIELD-SYMBOL(<lst1_rbtx>)
ENDIF. " IF e_rbkpv-rbtx[] IS NOT INITIAL

LOOP AT t_frseg ASSIGNING FIELD-SYMBOL(<lfs1_frseg>).
  <lfs1_frseg>-mwskz =  lv1_taxcd_noamt. "'I0'.
  <lfs1_frseg>-txjcd = lv1_txjcd.
ENDLOOP. " LOOP AT t_frseg ASSIGNING FIELD-SYMBOL(<lfs1_frseg>)
** Logic for shipping/fright charges, adding a GL tab with Freight
LOOP AT li1_idoc_data ASSIGNING FIELD-SYMBOL(<lst1_idoc_data>)
        WHERE segnam EQ lc1_seg_z1qtc_itm_acc.
  lst1_z1qtc_itm_acc = <lst1_idoc_data>-sdata.
  IF lst1_z1qtc_itm_acc IS NOT INITIAL.
    lst1_co_data-wrbtr = lst1_z1qtc_itm_acc-amount.
    IF lv1_hkont IS NOT INITIAL.
      lst1_co_data-saknr = lv1_hkont.
    ENDIF.
    lst1_co_data-sgtxt = lst1_z1qtc_itm_acc-ktext.
    lst1_co_data-bukrs = e_rbkpv-bukrs.
    lst1_co_data-shkzg = lst1_z1qtc_itm_acc-shkzg.
    lst1_co_data-txjcd = lv1_txjcd.                         "NJ000000
    lst1_co_data-mwskz = lv1_taxcd_noamt.  "I0
    IF lv1_kostl IS NOT INITIAL.
      lst1_co_data-kostl = lv1_kostl."lst1_ekkn-kostl.
    ENDIF.
    APPEND lst1_co_data TO t_co.
  ENDIF. " IF lst1_z1qtc_itm_acc IS NOT INITIAL
  CLEAR: lst1_co_data,lst1_z1qtc_itm_acc.
ENDLOOP. " LOOP AT li1_idoc_data ASSIGNING FIELD-SYMBOL(<lst1_idoc_data>)

e_change = abap_true.
