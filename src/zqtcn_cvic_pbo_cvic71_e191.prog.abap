*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CVIC_PBO_CVIC71_E191
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K920531
* REFERENCE NO: OTCM-29502
* DEVELOPER:MIMMADISET
* DATE: 11/27/2020
* DESCRIPTION:Set the defalts values for Distribution Channel and division
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

CONSTANTS:lc_division TYPE vtweg VALUE '00',
          lc_dist     TYPE spart VALUE '00'.

DATA:lv_defalt    TYPE char50 VALUE '(SAPLCVI_FS_UI_CUSTOMER_SALES)RF02D'.

FIELD-SYMBOLS:<ls_sales_area>  TYPE rf02d. " wa: Sales Areas
* step 1: receive data from xo
IF cvi_bdt_adapter=>get_current_sales_area( ) IS INITIAL.
  ASSIGN (lv_defalt) TO <ls_sales_area>.
  IF sy-subrc = 0 AND <ls_sales_area> IS ASSIGNED.
    IF <ls_sales_area>-vtweg IS INITIAL AND <ls_sales_area>-spart IS INITIAL.
      <ls_sales_area>-vtweg = lc_division.
      <ls_sales_area>-spart = lc_dist.
    ENDIF.
  ENDIF.
ENDIF.
