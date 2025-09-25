*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_IPS_INV_POPULATE_GL
* PROGRAM DESCRIPTION: Include program for populating
*                      1. Tax code and Tax jurisdiction code in PO and
*                         GL accouting line item
*                      2. Populate the GL line items from custom accouting
*                         segment
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-26
* OBJECT ID:E095 (CR# ERP-6594)
* TRANSPORT NUMBER(S): ED2K912233
*-------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO: ED2K912997
* REFERENCE NO: CR#- ERP6594
* DEVELOPER: Niraj Gadre (NGADRE)
* DATE: 2018-08-10
* DESCRIPTION: Logic for determination of jurisdiction code and Tax code
* for country US and CA has been added along with Multiple Tax code scenario.
*-------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO: ED2K913096
* REFERENCE NO: CR#- ERP6594
* DEVELOPER: Niraj Gadre (NGADRE)
* DATE: 2018-08-16
* DESCRIPTION: Logic for population of tax code in case of No Tax amount
* is corrected.
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO: ED2K913096
* REFERENCE NO: CR# 6594
* DEVELOPER: Niraj Gadre (NGADRE)
* DATE: 08-22-2018
* DESCRIPTION: 1. Logic has been added to check the duplicate Invoice
*                 document
*              2. Logic added to determine the tax code for US and CA
*                 company codes
*-------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO: ED2K913205
* REFERENCE NO: CR# 6594
* DEVELOPER: Niraj Gadre (NGADRE)
* DATE: 08-24-2018
* DESCRIPTION: restrict the population of Tax jurisdiction code for
* company code US and CA only
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO: ED2K914688
* REFERENCE NO: EIP-69
* DEVELOPER: AGUDURKHAD
* DATE: 03-13-2019
* DESCRIPTION: Default the population of Tax jurisdiction code for
* company code US and CA only
*-------------------------------------------------------------------*

**Local type declarations
TYPES : BEGIN OF lty_ekkn_data,
          kokrs   TYPE kokrs,      " Controlling Area
          prctr   TYPE prctr,      " Profit Center
          wbs_ele TYPE ps_psp_pnr, " Work Breakdown Structure Element (WBS Element)
          kostl   TYPE kostl,      " Cost Center
        END OF lty_ekkn_data,

*Begin of ADD:ERP-6594:NGADRE:08-AUG-2018:ED2K912997
        BEGIN OF lty_lfa1,
          lifnr TYPE lifnr,           " Vendor number
          land1 TYPE land1_gp,        " Country Key
          pstlz TYPE pstlz,           " Postal Code
          regio TYPE regio,           " Region
          adrnr TYPE adrnr,           " Address number
        END OF lty_lfa1,

        BEGIN OF lty_adrc,
          addrnumber TYPE ad_addrnum, " Address number
          post_code1 TYPE ad_pstcd1,  " Post code
          country    TYPE land1,      " Country
          region     TYPE regio,      " Region
        END OF lty_adrc,

        BEGIN OF lty_vendor_tax,
          lifnr TYPE lifnr,           " Account Number of Vendor or Creditor
          land1 TYPE land1_gp,        " Country Key
          pstlz TYPE pstlz,           " Postal Code
          regio TYPE regio,           " Region (State, Province, County)
          txjcd TYPE ad_txjcd,        " Tax Jurisdiction
          mwskz TYPE mwskz,           " Tax on sales/purchases code
        END OF lty_vendor_tax,

* Tax details
        BEGIN OF lty_tax_details,
          low        TYPE ad_pstcd2,         " PO Box Postal Code
          high       TYPE ad_pstcd2,         " PO Box Postal Code
          taxjurcode TYPE ad_txjcd,          " Tax Jurisdiction
        END OF lty_tax_details,

        BEGIN OF lty_constant,
          devid    TYPE zdevid,              " Development id
          param1   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
          param2   TYPE rvari_vnam,          " ABAP: Name of Variant Variable
          srno     TYPE tvarv_numb,          " Serial number
          sign     TYPE tvarv_sign,          " ABAP: ID: I/E (include/exclude values)
          opti     TYPE tvarv_opti,          " ABAP: Selection option (EQ/BT/CP/...)
          low      TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
          high     TYPE salv_de_selopt_high, " Upper Value of Selection Condition
          activate TYPE zconstactive,        " Activate
        END OF lty_constant,
*End of ADD:ERP-6594:NGADRE:08-AUG-2018:ED2K912997

*Begin of ADD:ERP-6594:NGADRE:22-AUG-2018:ED2K913096
        BEGIN OF lty_t076m,
          mwart TYPE edimwart, " External Name of Tax Type
          land1 TYPE land1,    " Country Key
          mwskz TYPE mwskz,    " Tax on sales/purchases code
        END OF lty_t076m.
*End of ADD:ERP-6594:NGADRE:22-AUG-2018:ED2K913096

*constant data declaration
CONSTANTS : lc_seg_z1qtc_itm_acc TYPE edilsegtyp VALUE 'Z1QTC_ITM_ACC_DATA_01', " Segment type
*Begin of ADD:ERP-6594:NGADRE:08-AUG-2018:ED2K912997
            lc_devid_i0353       TYPE zdevid VALUE 'I0353',            " Development ID
            lc_txjcd             TYPE  rvari_vnam VALUE 'TXJCD',       " ABAP: Name of Variant Variable
            lc_txjcd_ca          TYPE  rvari_vnam VALUE 'TXJCD_CA',    " ABAP: Name of Variant Variable
            lc_taxcd_us          TYPE  rvari_vnam VALUE 'TAXCD_US',    " ABAP: Name of Variant Variable
            lc_taxcd_noamt       TYPE  rvari_vnam VALUE 'TAXCD_NOAMT', " ABAP: Name of Variant Variable
            lc_taxcd_ca          TYPE  rvari_vnam VALUE 'TAXCD_CA',    " ABAP: Name of Variant Variable
            lc_land1_us          TYPE  land1      VALUE 'US',          " Country Key
            lc_land1_ca          TYPE  land1      VALUE 'CA',          " Country Key
            lc_logic_sys         TYPE edippartyp  VALUE 'LS',          " Partner Type
            lc_partner_sys       TYPE edipparnum  VALUE 'TIBCO',       " Partner number
            lc_txj_us            TYPE ad_txjcd VALUE 'NJ0000000',               " Tax Jurisdiction
            lc_txj_ca            TYPE ad_txjcd VALUE 'CAON'.               " Tax Jurisdiction
*End of ADD:ERP-6594:NGADRE:08-AUG-2018:ED2K912997



*data declarations
DATA: li_idoc_data      TYPE STANDARD TABLE OF edidd " Data record (IDoc)
                        INITIAL SIZE 0,
      lst_z1qtc_itm_acc TYPE z1qtc_itm_acc_data_01,  " I0353 - IPS Invoice Interface-Accounting data for line item
      lst_co_data       TYPE cobl_mrm,               " Account Assignment Fields for Invoice Verification
      lv_tax_code       TYPE mwskz,                  " Tax on sales/purchases code
      lv_txjcd          TYPE ad_txjcd,               " Tax Jurisdiction
      lv_vend_country   TYPE land1,                  " Country Key
      lv_ekorg          TYPE ekorg,                  " Purchasing Organization
      lst_frseg         TYPE mmcr_frseg,
      lst_rbtx          TYPE rbtx,                   " Taxes: Incoming Invoice
      lv_lines          TYPE i,                      " Lines of type Integers
      lst_ekkn          TYPE lty_ekkn_data,          " cost object data
*Begin of ADD:ERP-6594:NGADRE:08-AUG-2018:ED2K912997
      li_lfa1           TYPE STANDARD TABLE OF lty_lfa1 INITIAL SIZE 0,
      li_lfa1_tmp       TYPE STANDARD TABLE OF lty_lfa1 INITIAL SIZE 0,
      li_adrc           TYPE STANDARD TABLE OF lty_adrc INITIAL SIZE 0,
      li_tax_details    TYPE STANDARD TABLE OF lty_tax_details INITIAL SIZE 0,
      li_tax_ca         TYPE STANDARD TABLE OF zptp_tax_ca " Tax mapping for Jurisdiction Code Based on Province
                             INITIAL SIZE 0,               " Tax mapping for Jurisdiction Code Based on Province
* Vendor tax details
      li_vendor_tax     TYPE STANDARD TABLE OF lty_vendor_tax INITIAL SIZE 0,
      li_const_data     TYPE STANDARD TABLE OF lty_constant INITIAL SIZE 0,
      lst_const_data    TYPE    lty_constant,
      lst_lfa1          TYPE    lty_lfa1,
      lst_adrc          TYPE    lty_adrc,
      lst_tax_details   TYPE    lty_tax_details,
      lst_tax_ca        TYPE    zptp_tax_ca, " Tax mapping for Jurisdiction Code Based on Province
      lv_flag           TYPE    flag,        " General Flag
      lv_regio          TYPE    regio,       " Region (State, Province, County) "KBOSE 11/21/2015 ED1K902240 >> Ticket  INC_47271
      lv_pstlz          TYPE    ad_pstcd2,   " PO Box Postal Code
      lv_zipcode        TYPE    char5,       " Zipcode of type CHAR5
      lv_province       TYPE    regio,       " Region (State, Province, County)
      lst_vendor_tax    TYPE    lty_vendor_tax,
      lv_mwskz          TYPE    mwskz,       " Tax on sales/purchases code
      lv_txjcd_ca       TYPE    ad_txjcd,    " Tax Jurisdiction
      lv_tax_amt        TYPE    char01,      " Tax_amt of type CHAR01
      lv_taxcd_us       TYPE    mwskz,       " Tax on sales/purchases code
      lv_taxcd_noamt    TYPE    mwskz,       " Tax on sales/purchases code
      lv_taxcd_ca       TYPE    mwskz,       " Tax on sales/purchases code
*Begin of ADD:ERP-6594:NGADRE:22-AUG-2018:ED2K913096
      lv_belnr          TYPE    belnr_d, " Accounting Document Number
      lv_gjahr          TYPE    gjahr,   " Fiscal Year
      li_t076m          TYPE  STANDARD TABLE OF lty_t076m
                            INITIAL SIZE 0,
      lst_t076m         TYPE lty_t076m,
      lv_comp_land1     TYPE land1,      " Country Key
      lv_tax_code_temp  TYPE mwskz.      " Tax on sales/purchases code

**Check if document is already present in SAP in Parked or posted status.
SELECT belnr " Document Number of an Invoice Document
       gjahr " Fiscal Year
  FROM rbkp  " Generated Table for View
  INTO (lv_belnr , lv_gjahr )
  UP TO 1 ROWS
  WHERE xblnr = e_rbkpv-xblnr
    AND bukrs = e_rbkpv-bukrs
    AND lifnr = e_rbkpv-lifnr
    AND waers = e_rbkpv-waers
    AND rmwwr = e_rbkpv-rmwwr.
ENDSELECT.
IF sy-subrc EQ 0.

  MESSAGE e512(zqtc_r2) WITH lv_belnr lv_gjahr. " Invoice already entered as logistics inv. doc. number &1 &2.

ENDIF. " IF sy-subrc EQ 0


**get the company code country
SELECT SINGLE land1 " Country Key
  INTO lv_comp_land1
  FROM t001         " Company Codes
  WHERE bukrs = e_rbkpv-bukrs.
IF sy-subrc EQ 0.
*no action required.
ENDIF. " IF sy-subrc EQ 0

**select Tax codes from T076M
SELECT mwart " External Name of Tax Type
       land1 " Country Key
       mwskz " Tax on sales/purchases code
  FROM t076m " EDI: Conversion of External Tax Rate <-> Tax Code
  INTO TABLE li_t076m
  WHERE parart EQ lc_logic_sys
    AND konto  EQ lc_partner_sys.
IF sy-subrc EQ 0.

  SORT li_t076m BY mwart land1.

ENDIF. " IF sy-subrc EQ 0
*End of ADD:ERP-6594:NGADRE:22-AUG-2018:ED2K913096

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
   INTO TABLE li_const_data
   WHERE devid    = lc_devid_i0353
   AND   activate = abap_true. "Only active record

IF sy-subrc EQ 0.

  SORT li_const_data BY param1 low.

  READ TABLE li_const_data INTO lst_const_data
                        WITH KEY param1 = lc_txjcd
                        BINARY SEARCH.
  IF sy-subrc EQ 0.

    lv_txjcd  = lst_const_data-low.

  ENDIF. " IF sy-subrc EQ 0

  READ TABLE li_const_data INTO lst_const_data
                       WITH KEY param1 = lc_txjcd_ca
                       BINARY SEARCH.
  IF sy-subrc EQ 0.

    lv_txjcd_ca  = lst_const_data-low.

  ENDIF. " IF sy-subrc EQ 0

*Tax code for US - Tax amount present
  READ TABLE li_const_data INTO lst_const_data
                        WITH KEY param1 = lc_taxcd_us
                        BINARY SEARCH.
  IF sy-subrc EQ 0.

    lv_taxcd_us  = lst_const_data-low.

  ENDIF. " IF sy-subrc EQ 0

*Tax code for US - Tax amount not present
  READ TABLE li_const_data INTO lst_const_data
                        WITH KEY param1 = lc_taxcd_noamt
                        BINARY SEARCH.
  IF sy-subrc EQ 0.

    lv_taxcd_noamt  = lst_const_data-low.

  ENDIF. " IF sy-subrc EQ 0

**Tax code for Canada for no amount
  READ TABLE li_const_data INTO lst_const_data
                        WITH KEY param1 = lc_taxcd_ca
                        BINARY SEARCH.
  IF sy-subrc EQ 0.

    lv_taxcd_ca  = lst_const_data-low.

  ENDIF. " IF sy-subrc EQ 0


ENDIF. " IF sy-subrc EQ 0



CALL FUNCTION 'ZQTC_GET_IDOC_DATA_IPS_I0353'
  IMPORTING
    et_data_idoc = li_idoc_data.

*Begin of ADD:ERP-6594:NGADRE:16-AUG-2018:ED2K913096

**get the Tax lines from header level to populate the Tax codes.
DESCRIBE TABLE e_rbkpv-rbtx LINES lv_lines.

*check  if Tax amount is presnt at header level or not.
*if Tax amount is present then pass the X to LV_TAX_AMT flag
*clear the Calculate Tax indictor.
LOOP AT e_rbkpv-rbtx ASSIGNING FIELD-SYMBOL(<lst_rbtx_temp>).

**read the tax amount if amount present, clear the calculate Tax check box.
  IF <lst_rbtx_temp>-wmwst IS NOT INITIAL.
    lv_tax_amt = abap_true.
    CLEAR e_rbkpv-xmwst.
    EXIT.
  ENDIF. " IF <lst_rbtx_temp>-wmwst IS NOT INITIAL

ENDLOOP. " LOOP AT e_rbkpv-rbtx ASSIGNING FIELD-SYMBOL(<lst_rbtx_temp>)


*End of ADD:ERP-6594:NGADRE:16-AUG-2018:ED2K913096

*  Get the vendor data
SELECT lifnr     " Account Number of Vendor or Creditor
       land1     " Country Key
       pstlz     " Postal Code
       regio     " Region (State, Province, County)
       adrnr     " Address
       FROM lfa1 " Vendor Master (General Section)
       INTO TABLE li_lfa1
       WHERE lifnr = e_rbkpv-lifnr.

IF sy-subrc IS INITIAL.
  SORT li_lfa1 BY lifnr.
*Select post code from address table too in case value is not
*maintained in Vendor Master !!!!
  li_lfa1_tmp = li_lfa1.

  SORT li_lfa1_tmp BY adrnr.
  DELETE ADJACENT DUPLICATES FROM li_lfa1_tmp COMPARING adrnr.
  SELECT addrnumber " Address number
         post_code1 " City postal code
         country    " Country Key
         region     " Region (State, Province, County)
         FROM  adrc " Addresses (Business Address Services)
         INTO TABLE li_adrc
         FOR ALL ENTRIES IN li_lfa1_tmp
         WHERE addrnumber = li_lfa1_tmp-adrnr.

  IF sy-subrc IS INITIAL.
    SORT li_adrc BY addrnumber.
  ENDIF. " IF sy-subrc IS INITIAL
ENDIF. " IF sy-subrc IS INITIAL


* Retrieve Tax details for Vendor Zip code
SELECT low              "PO Box Postal Code
       high             "PO Box Postal Code
       taxjurcode       "Tax Jurisdiction
  FROM zptp_tax_details " Tax mapping for Jurisdiction Code Based on Pin Code
  INTO TABLE li_tax_details.
IF sy-subrc NE 0.
  REFRESH li_tax_details.
ELSE. " ELSE -> IF sy-subrc NE 0
  SORT li_tax_details BY taxjurcode.
ENDIF. " IF sy-subrc NE 0

* Get all possible values of Tax Jurisdiction Code Based on Province
SELECT *
FROM zptp_tax_ca " Tax mapping for Jurisdiction Code Based on Province
INTO TABLE li_tax_ca.

IF sy-subrc IS INITIAL.
  SORT li_tax_ca BY from_prov to_prov.
ENDIF. " IF sy-subrc IS INITIAL


*Populating Tax code and Tax Jurisdiction code
LOOP AT li_lfa1 INTO lst_lfa1.
  "In case of US Vendors
  IF lst_lfa1-land1 = lc_land1_us.
    IF lst_lfa1-pstlz IS INITIAL. "No Postal Code maintained
      CLEAR : lst_adrc.
      READ TABLE li_adrc INTO lst_adrc WITH KEY
                  addrnumber = lst_lfa1-adrnr
                  BINARY SEARCH. "Get Postal Code from ADDRESS table
      IF sy-subrc IS INITIAL.
        lv_pstlz = lst_adrc-post_code1.
      ENDIF. " IF sy-subrc IS INITIAL
    ELSE. " ELSE -> IF lst_lfa1-pstlz IS INITIAL
      lv_pstlz = lst_lfa1-pstlz.
    ENDIF. " IF lst_lfa1-pstlz IS INITIAL

    CLEAR lv_flag.
* Consider only first 5 digit of zip code for tax jurisdiction code
*  determination
    CONDENSE lv_pstlz.
    lv_zipcode = lv_pstlz+0(5).

* Go to tax details in order to get the range of zipcode for the Vendor Zipcode
* According to that Tax code and Tax Jurisdiction code needs to be populated as per maintained


    IF lv_tax_amt IS NOT INITIAL.

      lv_mwskz = lv_taxcd_us. "'I1'.

    ELSE. " ELSE -> IF lv_tax_amt IS NOT INITIAL

      lv_mwskz =  lv_taxcd_noamt. "'I0'.

    ENDIF. " IF lv_tax_amt IS NOT INITIAL


    LOOP AT li_tax_details INTO lst_tax_details.

      IF lv_zipcode GE lst_tax_details-low AND
         lv_zipcode LE lst_tax_details-high.

        CLEAR lst_vendor_tax.
        lst_vendor_tax-lifnr = lst_lfa1-lifnr.
        lst_vendor_tax-txjcd = lst_tax_details-taxjurcode.
        lst_vendor_tax-mwskz = lv_mwskz.

        APPEND lst_vendor_tax TO li_vendor_tax.

        lv_flag = abap_true.
        EXIT.
      ENDIF. " IF lv_zipcode GE lst_tax_details-low AND

      CLEAR : lst_tax_details.

    ENDLOOP. " LOOP AT li_tax_details INTO lst_tax_details

* Incase data is not found from above step , set the default value

    IF lv_flag IS INITIAL.
      CLEAR lst_vendor_tax.
      lst_vendor_tax-lifnr = lst_lfa1-lifnr.
      lst_vendor_tax-txjcd = lv_txjcd.
      lst_vendor_tax-mwskz = lv_taxcd_noamt. "I0
      APPEND lst_vendor_tax TO li_vendor_tax.

    ENDIF. " IF lv_flag IS INITIAL

    CLEAR : lv_pstlz , lv_zipcode.

* In case of CANADA
  ELSEIF lst_lfa1-land1 = lc_land1_ca.
    IF lst_lfa1-regio IS INITIAL.

      CLEAR : lst_adrc.
      READ TABLE li_adrc INTO lst_adrc WITH KEY
                  addrnumber = lst_lfa1-adrnr
                  BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        lv_regio = lst_adrc-region.
      ENDIF. " IF sy-subrc IS INITIAL

    ELSE. " ELSE -> IF lst_lfa1-regio IS INITIAL

      lv_regio = lst_lfa1-regio.
    ENDIF. " IF lst_lfa1-regio IS INITIAL

    CLEAR lv_flag.

* Consider only first 5 digit of zip code for tax jurisdiction code
*  determination
    CONDENSE lv_regio.
    LOOP AT li_tax_ca INTO lst_tax_ca.

      IF lv_regio GE lst_tax_ca-from_prov AND
         lv_regio LE lst_tax_ca-to_prov.

        CLEAR lst_vendor_tax.
        lst_vendor_tax-lifnr = lst_lfa1-lifnr.
        lst_vendor_tax-txjcd = lst_tax_ca-tax_jurisdiction.

        IF lv_tax_amt IS NOT INITIAL.
          lst_vendor_tax-mwskz = lst_tax_ca-tax_code.
          lv_mwskz = lst_tax_ca-tax_code.
        ELSE. " ELSE -> IF lv_tax_amt IS NOT INITIAL

          lv_mwskz = lv_taxcd_ca. "'0J'.
          lst_vendor_tax-mwskz = lst_tax_ca-tax_code.
        ENDIF. " IF lv_tax_amt IS NOT INITIAL

        APPEND lst_vendor_tax TO li_vendor_tax.

        lv_flag = abap_true.
        EXIT.
      ENDIF. " IF lv_regio GE lst_tax_ca-from_prov AND
    ENDLOOP. " LOOP AT li_tax_ca INTO lst_tax_ca
* Incase data is not found from above step , set the default value
    IF lv_flag IS INITIAL.
      CLEAR lst_vendor_tax.
      lst_vendor_tax-lifnr = lst_lfa1-lifnr.
      lst_vendor_tax-txjcd = lv_txjcd_ca.
      lst_vendor_tax-mwskz = lv_mwskz. " 0J
      APPEND lst_vendor_tax TO li_vendor_tax.
    ENDIF. " IF lv_flag IS INITIAL
    CLEAR : lv_regio ,
            lv_zipcode.

  ELSE. " ELSE -> IF lst_lfa1-land1 = lc_land1_us

    CLEAR lst_vendor_tax.
    lst_vendor_tax-lifnr = lst_lfa1-lifnr.
    lst_vendor_tax-mwskz = lv_mwskz.
    APPEND lst_vendor_tax TO li_vendor_tax.

  ENDIF. " IF lst_lfa1-land1 = lc_land1_us
ENDLOOP. " LOOP AT li_lfa1 INTO lst_lfa1

CLEAR lv_txjcd.
IF li_vendor_tax IS NOT INITIAL.

  CLEAR lst_vendor_tax.
  READ TABLE li_vendor_tax INTO lst_vendor_tax
                                  WITH KEY lifnr = e_rbkpv-lifnr.
  IF sy-subrc EQ 0.

*Begin of ADD:ERP-6594:NGADRE:24-AUG-2018:ED2K913205
**populate Tax jurisdiction code only os Company code US and CA.
    IF lv_comp_land1 EQ lc_land1_us
    OR lv_comp_land1 EQ lc_land1_ca.

      lv_txjcd = lst_vendor_tax-txjcd.

    ENDIF. " IF lv_comp_land1 EQ lc_land1_us
*End of ADD:ERP-6594:NGADRE:24-AUG-2018:ED2K913205

    lv_tax_code = lst_vendor_tax-mwskz.

  ENDIF. " IF sy-subrc EQ 0

ENDIF. " IF li_vendor_tax IS NOT INITIAL
*End of ADD:ERP-6594:NGADRE:08-AUG-2018:ED2K912997

*Begin of change ED2K914688 EIP-69
IF lv_txjcd EQ space.
  IF lv_comp_land1 EQ lc_land1_us.
    lv_txjcd = lc_txj_us.
  ENDIF. " IF lv_comp_land1 EQ lc_land1_us
  IF lv_comp_land1 EQ lc_land1_ca.
    lv_txjcd = lc_txj_ca.
  ENDIF.
ENDIF.
*End of change ED2K914688 EIP-69

IF e_rbkpv-rbtx[] IS NOT INITIAL.

**Update the Tax jurisdiction code into Tax code line items
** along with Tax number

  LOOP AT e_rbkpv-rbtx ASSIGNING FIELD-SYMBOL(<lst_rbtx>).

*Begin of ADD:ERP-6594:NGADRE:22-AUG-2018:ED2K913096
**poulate the Tax code for US and CA based on derived logic.
    IF lv_comp_land1 EQ lc_land1_us.

      IF <lst_rbtx_temp>-wmwst IS NOT INITIAL.

        <lst_rbtx_temp>-mwskz = lv_taxcd_us.

      ELSE. " ELSE -> IF <lst_rbtx_temp>-wmwst IS NOT INITIAL
        <lst_rbtx_temp>-mwskz = lv_taxcd_noamt.

      ENDIF. " IF <lst_rbtx_temp>-wmwst IS NOT INITIAL

    ELSEIF lv_comp_land1 = lc_land1_ca. " ELSE -> IF sy-subrc EQ 0

      IF <lst_rbtx_temp>-wmwst IS NOT INITIAL.

        <lst_rbtx>-mwskz = lv_tax_code.

      ELSE. " ELSE -> IF <lst_rbtx_temp>-wmwst IS NOT INITIAL
        <lst_rbtx>-mwskz = lc_taxcd_ca.

      ENDIF. " IF <lst_rbtx_temp>-wmwst IS NOT INITIAL

    ELSE. " ELSE -> IF lv_comp_land1 EQ lc_land1_us
      READ TABLE li_t076m INTO lst_t076m
                             WITH KEY mwart = <lst_rbtx>-mwskz
                                      land1 = lst_lfa1-land1
                             BINARY SEARCH.
      IF sy-subrc EQ 0.
        <lst_rbtx>-mwskz = lst_t076m-mwskz.
      ENDIF. " IF sy-subrc EQ 0

    ENDIF. " IF lv_comp_land1 EQ lc_land1_us
*End of ADD:ERP-6594:NGADRE:22-AUG-2018:ED2K913096

    <lst_rbtx>-txjcd = lv_txjcd.
    <lst_rbtx>-txjdp = lv_txjcd.
    <lst_rbtx>-buzei = '1'.

  ENDLOOP. " LOOP AT e_rbkpv-rbtx ASSIGNING FIELD-SYMBOL(<lst_rbtx>)

ENDIF. " IF e_rbkpv-rbtx[] IS NOT INITIAL

**check if payment term is present at header if not fetch the payment term from
**LFM1 table and populate the same.

READ TABLE t_frseg INTO lst_frseg INDEX 1.
IF sy-subrc EQ 0.

**get co object from line item and pass into GL lines.
  SELECT  kokrs      " Controlling Area
          prctr      " Profit Center
          ps_psp_pnr " Work Breakdown Structure Element (WBS Element)
          kostl      " Cost Center
     FROM ekkn       " Account Assignment in Purchasing Document
     UP TO 1 ROWS
     INTO lst_ekkn
     WHERE ebeln EQ lst_frseg-ebeln
       AND ebelp EQ lst_frseg-ebelp.
  ENDSELECT.
  IF sy-subrc NE 0.
* No action needed
  ENDIF. " IF sy-subrc NE 0

ENDIF. " IF sy-subrc EQ 0

IF e_rbkpv-zterm IS INITIAL.

  SELECT SINGLE ekorg " Purchasing Organization
    FROM ekko         " Purchasing Document Header
    INTO lv_ekorg
    WHERE ebeln EQ lst_frseg-ebeln.
  IF sy-subrc EQ 0.

    SELECT SINGLE zterm " Terms of Payment Key
      FROM lfm1         " Vendor master record purchasing organization data
      INTO e_rbkpv-zterm
      WHERE lifnr EQ e_rbkpv-lifnr.

    IF sy-subrc NE 0.
*No action required.
    ENDIF. " IF sy-subrc NE 0

  ENDIF. " IF sy-subrc EQ 0

ENDIF. " IF e_rbkpv-zterm IS INITIAL


LOOP AT t_frseg ASSIGNING FIELD-SYMBOL(<lfs_frseg>).
*Begin of ADD:ERP-6594:NGADRE:22-AUG-2018:ED2K913096
  IF lv_tax_code_temp IS NOT INITIAL.
    <lfs_frseg>-mwskz = lv_tax_code_temp.
  ELSE. " ELSE -> IF lv_tax_code_temp IS NOT INITIAL

    IF lv_comp_land1 EQ lc_land1_us.

      IF lv_tax_amt IS NOT INITIAL.
        <lfs_frseg>-mwskz = lv_taxcd_us. "'I1'.
      ELSE. " ELSE -> IF lv_tax_amt IS NOT INITIAL
        <lfs_frseg>-mwskz =  lv_taxcd_noamt. "'I0'.
      ENDIF. " IF lv_tax_amt IS NOT INITIAL


    ELSEIF lv_comp_land1 EQ lc_land1_ca.
      IF lv_tax_amt IS NOT INITIAL.
        <lfs_frseg>-mwskz = lv_tax_code.
      ELSE. " ELSE -> IF lv_tax_amt IS NOT INITIAL
        <lfs_frseg>-mwskz = lv_taxcd_ca.
      ENDIF. " IF lv_tax_amt IS NOT INITIAL

    ELSE. " ELSE -> IF lv_comp_land1 EQ lc_land1_us

      READ TABLE li_t076m INTO lst_t076m
                         WITH KEY mwart = <lfs_frseg>-mwskz
                                         land1 = lst_lfa1-land1
                                BINARY SEARCH.
      IF sy-subrc EQ 0.
        <lfs_frseg>-mwskz = lst_t076m-mwskz.
      ENDIF. " IF sy-subrc EQ 0

    ENDIF. " IF lv_comp_land1 EQ lc_land1_us

    lv_tax_code_temp = <lfs_frseg>-mwskz.
  ENDIF. " IF lv_tax_code_temp IS NOT INITIAL
*End of ADD:ERP-6594:NGADRE:22-AUG-2018:ED2K913096
  IF lv_txjcd IS NOT INITIAL.
    <lfs_frseg>-txjcd = lv_txjcd.
  ENDIF. " IF lv_txjcd IS NOT INITIAL


ENDLOOP. " LOOP AT t_frseg ASSIGNING FIELD-SYMBOL(<lfs_frseg>)

LOOP AT li_idoc_data ASSIGNING FIELD-SYMBOL(<lst_idoc_data>)
        WHERE segnam EQ lc_seg_z1qtc_itm_acc.

  lst_z1qtc_itm_acc = <lst_idoc_data>-sdata.

  IF lst_z1qtc_itm_acc IS NOT INITIAL.

    lst_co_data-wrbtr = lst_z1qtc_itm_acc-amount.
    lst_co_data-saknr = lst_z1qtc_itm_acc-hkont.
    lst_co_data-sgtxt = lst_z1qtc_itm_acc-ktext.
    lst_co_data-bukrs = e_rbkpv-bukrs.
    lst_co_data-shkzg = lst_z1qtc_itm_acc-shkzg.
    lst_co_data-txjcd = lv_txjcd.

*Begin of ADD:ERP-6594:NGADRE:22-AUG-2018:ED2K913096
    IF lv_comp_land1 = lc_land1_us.
      IF lst_z1qtc_itm_acc-mwsbt IS NOT INITIAL
     AND lst_z1qtc_itm_acc-mwsbt GT 0.
        lst_co_data-mwskz = lv_taxcd_us.
      ELSE. " ELSE -> IF lst_z1qtc_itm_acc-mwsbt IS NOT INITIAL
        lst_co_data-mwskz = lv_taxcd_noamt.
      ENDIF. " IF lst_z1qtc_itm_acc-mwsbt IS NOT INITIAL
    ELSEIF lv_comp_land1 = lc_land1_ca. " ELSE -> IF sy-subrc EQ 0

      IF lst_z1qtc_itm_acc-mwsbt IS NOT INITIAL
     AND lst_z1qtc_itm_acc-mwsbt GT 0.
        lst_co_data-mwskz = lv_tax_code.

      ELSE. " ELSE -> IF lst_z1qtc_itm_acc-mwsbt IS NOT INITIAL

        lst_co_data-mwskz = lv_taxcd_ca.

      ENDIF. " IF lst_z1qtc_itm_acc-mwsbt IS NOT INITIAL

    ELSE. " ELSE -> IF lv_comp_land1 = lc_land1_us
      lst_co_data-mwskz = lst_z1qtc_itm_acc-mwskz.

      READ TABLE li_t076m INTO lst_t076m
                                   WITH KEY mwart = lst_z1qtc_itm_acc-mwskz
                                            land1 = lst_lfa1-land1
                                   BINARY SEARCH.
      IF sy-subrc EQ 0.
        lst_z1qtc_itm_acc-mwskz = lst_t076m-mwskz.
      ENDIF. " IF sy-subrc EQ 0

    ENDIF. " IF lv_comp_land1 = lc_land1_us
*End of ADD:ERP-6594:NGADRE:22-AUG-2018:ED2K913096

    lst_co_data-kostl = lst_ekkn-kostl.
    lst_co_data-prctr = lst_ekkn-prctr.
    lst_co_data-kokrs = lst_ekkn-kokrs.
    IF lst_ekkn-wbs_ele IS NOT INITIAL.
      lst_co_data-ps_psp_pnr = lst_ekkn-wbs_ele.
    ENDIF. " IF lst_ekkn-wbs_ele IS NOT INITIAL

    APPEND lst_co_data TO t_co.

  ENDIF. " IF lst_z1qtc_itm_acc IS NOT INITIAL

  CLEAR: lst_co_data,
         lst_z1qtc_itm_acc.

ENDLOOP. " LOOP AT li_idoc_data ASSIGNING FIELD-SYMBOL(<lst_idoc_data>)

e_change = abap_true.
