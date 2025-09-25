class ZCL_IM_PDMBI_BDCP_VAL_CONT definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BDCP_BEFORE_WRITE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_PDMBI_BDCP_VAL_CONT IMPLEMENTATION.


  METHOD if_ex_bdcp_before_write~filter_bdcpv_before_write.
*----------------------------------------------------------------------*
* PROGRAM NAME:         FILTER_BDCPV_BEFORE_WRITE                      *
* PROGRAM DESCRIPTION:  BADi to determine whether the material is BOM  *
*                       or not. If material number is not a BOM, the   *
*                       clear the change pointer entry to restrict from*
*                       BDCP2 entry.
* DEVELOPER:            Paramita Bose (PBOSE)                          *
* CREATION DATE:        31/01/2017                                     *
* OBJECT ID:            I0206                                          *
* TRANSPORT NUMBER(S):  ED2K904011                                     *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
* Data Declaration
    DATA lv_matnr   TYPE matnr. " Material Number

* Constant Declaration
    CONSTANTS : lc_material TYPE cdobjectcl VALUE 'MATERIAL'. " Object class

*   Check if the material number is BOM or not. If not then
*   restrict it from making BDCP2 entry
    IF change_document_header-objectclas EQ lc_material.
*     Fetch material number from MAST table to find BOM material
      SELECT matnr " Material Number
      INTO lv_matnr
      FROM mast    " Material to BOM Link
      UP TO 1 ROWS
      WHERE matnr = change_document_header-objectid.
      ENDSELECT.
      IF sy-subrc NE 0.
        CLEAR change_pointers.
      ENDIF. " IF sy-subrc NE 0
    ENDIF. " IF change_document_header-objectclas EQ lc_material

  ENDMETHOD.
ENDCLASS.
