*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_TRANSFER_MISSING_STRUCS
* PROGRAM DESCRIPTION : Creating and Updating issues from JANIS
* Standard logic is not considering MPOP (table MVOP) values ,
* We have implemented additional logic to consider these, since those
* field values are part of our Conversion / Interface requirement.
* DEVELOPER           : Writtick Roy(WROY)
* CREATION DATE       : 01/11/2017
* OBJECT ID           : I0344
* TRANSPORT NUMBER(S) : ED2K903907
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_TRANSFER_MISSING_STRUCS
*&---------------------------------------------------------------------*
*IF ampop_ueb[] IS INITIAL.
** Receive details from the missing structures
*  CALL FUNCTION 'ZQTC_TRANSFER_MISSING_STRUCS'
*    IMPORTING
*      ex_mpop_tab = ampop_ueb[].
*  SORT ampop_ueb BY mandt tranc.
*ENDIF.
