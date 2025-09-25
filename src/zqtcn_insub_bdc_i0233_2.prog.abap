*----------------------------------------------------------------------*
* PROGRAM NAME: ZXVDBU02 (Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for populating BDC DATA
*
* DEVELOPER: Sayantan Das ( )
* CREATION DATE:   24/10/2016
* OBJECT ID: I0233.2
* TRANSPORT NUMBER(S):  ED2K905726
*----------------------------------------------------------------------*
CONSTANTS:
  lc_z1qtc_e1edp01_01_m TYPE edilsegtyp VALUE 'Z1QTC_E1EDP01_01',
  lc_e1edka3_m          TYPE edilsegtyp VALUE 'E1EDKA3'.

* Chane Of Address Process
READ TABLE didoc_data TRANSPORTING NO FIELDS
     WITH KEY segnam = lc_e1edka3_m.
IF sy-subrc EQ 0.
  INCLUDE zqtcn_insub_bdc_i0233_2_addr IF FOUND.
ENDIF.

* Cancellation Process
READ TABLE didoc_data TRANSPORTING NO FIELDS
     WITH KEY segnam = lc_z1qtc_e1edp01_01_m.
IF sy-subrc EQ 0.
  INCLUDE zqtcn_insub_bdc_i0233_2_reason IF FOUND.
ENDIF.
