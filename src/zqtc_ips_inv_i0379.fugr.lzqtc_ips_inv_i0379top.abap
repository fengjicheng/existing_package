*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_IPS_INV_I0379TOP
* PROGRAM DESCRIPTION: This contains the global data declarations for
*                      function group
* DEVELOPER: Murali (mimmadiset)
* CREATION DATE:   2020-02-08
* OBJECT ID:I0379 (ERPM-11517)
* TRANSPORT NUMBER(S): ED2K917673
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*
FUNCTION-POOL zqtc_ips_inv_i0379. "MESSAGE-ID ..

TYPES : BEGIN OF ty_ekpo_data,
          ebeln     TYPE ebeln,   " Purchasing Document Number
          ebelp     TYPE ebelp,   " Item Number of Purchasing Document
          matnr     TYPE matnr,   " Materila Number,
          menge     TYPE menge_d, " Quantity
          banfn     TYPE banfn,   " Purchase Requisition Number
          tol_menge TYPE menge_d, " tolerance Quantity
          wrbtr     TYPE wrbtr,   " Amount in Document Currency
          bismt     TYPE bismt,   "Old material number
        END OF ty_ekpo_data.

TYPES:BEGIN OF ty_e1edp01_data,
        ebeln_idoc    TYPE ebeln,         " Purchase order number
        matnr_idoc    TYPE matnr,         " Material number.
        wrbtr_idoc    TYPE wrbtr,         " Amount in Document Currency
        menge_idoc    TYPE menge_d,       " Quantity
        uom_idoc      TYPE meins,         " Base Unit of Measure
        segp01        TYPE idocdsgnum,    " Number of SAP segment
        segp02        TYPE idocdsgnum,    " Number of SAP segment
        segp26        TYPE idocdsgnum,    " Number of SAP segment
        tolerance_amt TYPE wrbtr,     " Amount in Document Currency tolerance
      END OF ty_e1edp01_data,
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
TYPES tt1_e1edp01_data TYPE STANDARD TABLE OF ty_e1edp01_data
            INITIAL SIZE 0.
TYPES tt1_ekpo_data TYPE STANDARD TABLE OF ty_ekpo_data
            INITIAL SIZE 0.

DATA : v1_mescod       TYPE edi_mescod,              " Logical Message Variant
       v1_filename     TYPE char100,                 " File name
       v1_tax_code     TYPE mwskz,                   " Tax on sales/purchases code
       v1_txjcd        TYPE ad_txjcd,                " Tax Jurisdiction
       v1_vend_country TYPE land1,                   " Country Key
       t1_bin_content  TYPE STANDARD TABLE OF tdline " Text Line
                    INITIAL SIZE 0,
       t1_data_idoc    TYPE STANDARD TABLE OF edidd  " Data record (IDoc)
                    INITIAL SIZE 0.
