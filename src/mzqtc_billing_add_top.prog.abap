*----------------------------------------------------------------------*
* PROGRAM NAME:MZQTC_MZQTC_BILLING_ADD_TOP
* PROGRAM DESCRIPTION:TOP include .
* DEVELOPER: Kamalendu Chakraborty(KCHAKRABOR )
* CREATION DATE:   2016-10-02
* OBJECT ID:E070
* TRANSPORT NUMBER(S):ED2K903028
*-------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
PROGRAM sapmzqtc_billing_add_field.
*& Data Declaration
TABLES vbrp. " VBRP table
CONSTANTS: c_vf01 TYPE tcode VALUE 'VF01', " Transaction Code
           c_vf02 TYPE tcode VALUE 'VF02', " Transaction Code
           c_vf03 TYPE tcode VALUE 'VF03'. " Transaction Code
