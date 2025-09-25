*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCN_TRANSFER_MISSING_STRUCS
* PROGRAM DESCRIPTION : Creating and Updating issues from JANIS
* Update Classification data for media issue
* DEVELOPER           : Writtick Roy(WROY)
* CREATION DATE       : 01/11/2017
* OBJECT ID           : I0344
* TRANSPORT NUMBER(S) : ED2K903907
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CLASSIFICATION_DATA
*&---------------------------------------------------------------------*
CALL FUNCTION 'ZQTC_UPDATE_CLASSIF_DATA'
  IMPORTING
    ex_active    = e_active
  CHANGING
    ch_t_allkssk = t_allkssk[].
