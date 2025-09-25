*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_IPS_INV_GET_TXCOD_TXJCD
* PROGRAM DESCRIPTION: Include program for User Exit to change determine
*                      Tax code code and Tax jurisdiction for Invoice
* DEVELOPER: Niraj Gadre (NGADRE)
* CREATION DATE:   2018-06-26
* OBJECT ID:E095 (CR# ERP-6594)
* TRANSPORT NUMBER(S): ED2K912233
*-------------------------------------------------------------------*
*-------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------*
* REVISION NO: ED2K912997
* REFERENCE NO: CR#- ERP6594
* DEVELOPER: Niraj Gadre (NGADRE)
* DATE: 2018-08-10
* DESCRIPTION: Logic for determination of jurisdiction code and Tax code
* for country US and CA has been rmeoved.
*-------------------------------------------------------------------*

    e_mwskz = i_mwskz.
    e_change = abap_true.
