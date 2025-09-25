*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CVIC_PBO_CVIC91_E191
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K920531
* REFERENCE NO: OTCM-29502
* DEVELOPER:MIMMADISET
* DATE: 11/27/2020
* DESCRIPTION:Set the defalts values for Distribution Channel and division
* as ZERO in sales tab in BP tcode
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
* Local Types
TYPES:tt_cvis_sales_area TYPE TABLE OF cvis_sales_area_dynpro.

CONSTANTS:lc_division TYPE vtweg VALUE '00',
          lc_div_dflt TYPE char15 VALUE 'DIV_DFLT',
          lc_dist     TYPE spart VALUE '00'.

DATA:lv_sales_areas TYPE char50 VALUE '(SAPLCVI_FS_UI_CUSTOMER_SALES)GT_SALES_AREAS',
     lt_sales       TYPE TABLE OF cvis_sales_area_info,
     ls_sales_i     LIKE LINE OF lt_sales,
     ls_sales       TYPE cvis_sales_area_dynpro.

FIELD-SYMBOLS: <li_sales_area>  TYPE tt_cvis_sales_area. " Itab: Sales Areas

* Fetch Application constant entries
IF i_constants[] IS INITIAL.
  SELECT param1, param2, srno, sign, opti, low, high
         FROM zcaconstant                    " Wiley Application Constant Table
         INTO TABLE @i_constants
         WHERE devid = @lc_devid_e191 AND
               activate = @abap_true.
ENDIF.
* *** when the Customer/BP extends to sales areas at this time below code willt trigger
" Get the customer Sales Areas from ABAP Stack
ASSIGN (lv_sales_areas) TO <li_sales_area>.
IF sy-subrc = 0 AND <li_sales_area> IS ASSIGNED.
  DATA(lv_length) = lines( <li_sales_area> ).
  READ TABLE <li_sales_area> ASSIGNING FIELD-SYMBOL(<fs_area>)
  INDEX lv_length.
  IF sy-subrc = 0 AND <fs_area> IS ASSIGNED.
    IF <fs_area>-sales_org IS NOT INITIAL
      AND <fs_area>-dist_channel = space
      AND <fs_area>-division = space.
      IF line_exists( i_constants[ param1 = lc_div_dflt
                                    param2 = <fs_area>-sales_org  ] ).
        <fs_area>-dist_channel = lc_division.
        <fs_area>-division = lc_dist.
        lt_sales = cvi_bdt_adapter=>get_sales_areas( ).
        READ TABLE lt_sales INTO ls_sales_i
        WITH KEY sales_org = <fs_area>-sales_org
        dist_channel = <fs_area>-dist_channel
        division = <fs_area>-division.
        IF sy-subrc NE 0.
          ls_sales_i-sales_org = <fs_area>-sales_org.
          ls_sales_i-dist_channel = <fs_area>-dist_channel.
          ls_sales_i-division = <fs_area>-division.
          ls_sales_i-is_new = <fs_area>-new_sa.
          APPEND ls_sales_i TO lt_sales.
          cvi_bdt_adapter=>set_sales_areas( lt_sales[] ).
        ENDIF.
      ENDIF.
    ENDIF."IF <fs_area>-sales_org IS NOT INITIAL.
  ENDIF."IF sy-subrc = 0 AND <fs_area> IS ASSIGNED.
ENDIF."IF sy-subrc = 0 AND <li_sales_area> IS ASSIGNED.
