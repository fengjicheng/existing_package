*&---------------------------------------------------------------------*
* PROGRAM NAME       : ZRTRN_RESTRICT_OUTPUT_E263 (Include)
* PROGRAM DESCRIPTION: ZACD and ZACS outputs for Invoices (ZF2 doc type)
*                    : must be stopped if the reference sales document is ZCOP.
* DEVELOPER          : Siva Guda (SGUDA)
* CREATION DATE      : 02/05/2021
* OBJECT ID          : E263 (ERP-30892)
* TRANSPORT NUMBER(S): ED2K921723
* PURPOSE            : To restrict the output determinataion based on the
*                      document types in ZCACONSTANT table
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :
* REFERENCE NO:
* DEVELOPER   :
* DATE        :
* DESCRIPTION :
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZRTRN_RESTRICT_OUTPUT_E263
*&---------------------------------------------------------------------*

**-- Calling below routine to handle statics and validations
*PERFORM get_constant_validate_E263.
