FUNCTION zqtc_transfer_missing_strucs.
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTC_TRANSFER_MISSING_STRUCS
* PROGRAM DESCRIPTION : Creating and Updating issues from JANIS
* Standard logic is not considering MPOP (table MVOP) values ,
* We have implemented additional logic to consider these, since those
* field values are part of our Conversion / Interface requirement.
* DEVELOPER           : Writtick Roy(WROY)
* CREATION DATE       : 01/11/2017
* OBJECT ID           : I0344
* TRANSPORT NUMBER(S) : ED2K903907
*----------------------------------------------------------------------*
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EX_MPOP_TAB) TYPE  MPOP_UEB_TT
*"----------------------------------------------------------------------

  ex_mpop_tab[] = i_mpop_tab[].                                 "Forecast Parameters

ENDFUNCTION.
