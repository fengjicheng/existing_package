*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_IPS_INV_I0353TOP
* PROGRAM DESCRIPTION: This contains the global data declarations for
*                      function group
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-26
* OBJECT ID:E095 (CR# ERP-6594)
* TRANSPORT NUMBER(S): ED2K912233
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*-------------------------------------------------------------------*
FUNCTION-POOL zqtc_ips_inv_i0353. "MESSAGE-ID ..

* INCLUDE LZQTC_IPS_INV_I0353D...            " Local class definition


TYPES : BEGIN OF ty_ekpo_data,
          ebeln     TYPE ebeln,   " Purchasing Document Number
          ebelp     TYPE ebelp,   " Item Number of Purchasing Document
          menge     TYPE menge_d, " Quantity
          banfn     TYPE banfn,   " Purchase Requisition Number
          tol_menge TYPE menge_d, " tolerance Quantity
          wrbtr     TYPE wrbtr,   " Amount in Document Currency
        END OF ty_ekpo_data.

TYPES : tt_ekpo_data TYPE STANDARD TABLE OF ty_ekpo_data
            INITIAL SIZE 0.

DATA : v_mescod       TYPE edi_mescod,              " Logical Message Variant
       v_filename     TYPE char100,                 " File name
       v_tax_code     TYPE mwskz,                   " Tax on sales/purchases code
       v_txjcd        TYPE ad_txjcd,                " Tax Jurisdiction
       v_vend_country TYPE land1,                   " Country Key
       t_bin_content  TYPE STANDARD TABLE OF tdline " Text Line
                    INITIAL SIZE 0,
       t_data_idoc    TYPE STANDARD TABLE OF edidd  " Data record (IDoc)
                    INITIAL SIZE 0.
