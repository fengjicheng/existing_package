*----------------------------------------------------------------------*
* PROGRAM NAME: ZRTRN_POP_FIELD_VALUES_GLB (Global Constants)
* PROGRAM DESCRIPTION: Prepopulate field values while processing IDOCs
*                      of Message Type "DEBMAS"
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   11/23/2016
* OBJECT ID: C067
* TRANSPORT NUMBER(S): ED2K902649
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K902649
* REFERENCE NO: Rel-2 (C067)
* DEVELOPER: Writtick Roy (WROY)
* DATE:  11/23/2016
* DESCRIPTION: Customer Master - Partner Functions
*----------------------------------------------------------------------*
TYPES:
  BEGIN OF ty_pfunc,
    kunnr       TYPE kunnr,                           "Customer Number
    vkorg       TYPE vkorg,                           "Sales Organization
    vtweg       TYPE vtweg,                           "Distribution Channel
    spart       TYPE spart,                           "Division
    prtnrs      TYPE lcm_knvp_t,                      "Customer Master Partner Functions
    docnum      TYPE edi_docnum,                      "IDoc number
    segnum      TYPE idocdsgnum,                      "Number of SAP segment
    segnam      TYPE edilsegtyp,                      "Segment type
    psgnum      TYPE edi_psgnum,                      "Number of the hierarchically higher SAP segment
    hlevel      TYPE edi_hlevel,                      "Hierarchy level
    sgmnt_tabix TYPE sytabix,                         "Segment Position
  END OF ty_pfunc,
  tt_pfunc TYPE STANDARD TABLE OF ty_pfunc INITIAL SIZE 0.

DATA:
  i_pfuncs      TYPE tt_pfunc.
