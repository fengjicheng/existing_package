*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_DATA_DEC_TOP_R112 (Include Program)
* PROGRAM DESCRIPTION: data declaration for additional fields
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   05/30/2020
* WRICEF ID: R112
* TRANSPORT NUMBER(S):  ED2K918376
* REFERENCE NO: ERPM-17101
*----------------------------------------------------------------------*


TYPES : netwr       TYPE netwr_ap,        " Potential value of release orders
        waerk       TYPE waerk,           " Currency
        matnr       TYPE matnr,           " Media Product
        identcode   TYPE ismidentcode,    " Identity code
        country     TYPE landx,           " Country
        postal_code TYPE pstlz,           " Postal code
        vendor      TYPE lifnr,           " Distributor
        plant       TYPE dwerk_ext,       " Plant
        ship_method TYPE vsbed_bez.       " Ship Methos
