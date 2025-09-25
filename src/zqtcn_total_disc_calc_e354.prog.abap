*&---------------------------------------------------------------------*
* REVISION NO: ED2K926303 & ED2K926784
* PROGRAM NAME: ZQTCN_TOTAL_DISC_CALC_E354
* REFRENCE NO  : ASOTC-226
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE : 03/25/2022
* OBJECT ID: E354
* DESCRIPTION: Calculate the total value of institutional discount(ZIDN)
* for ASOTC price simulation
*&---------------------------------------------------------------------*

DATA : li_constant_e354 TYPE zcat_constants.                    " Internal table for Constant Table

CONSTANTS: lc_devid_e354  TYPE zdevid VALUE 'E354'.                       " Development ID
CONSTANTS: lc_cust_disc   TYPE rvari_vnam VALUE 'CUSTOM_DISCOUNT'.        " Custom Discount

FIELD-SYMBOLS <lfs_komv> TYPE komv_index.                       " Field symbol for Xkomv structure

*Fetching Entries from Constant Table
REFRESH li_constant_e354[].

CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_devid_e354
  IMPORTING
    ex_constants = li_constant_e354.

IF li_constant_e354[] IS NOT INITIAL.

* BOC by Ramesh on 04/18/2022 for ASOTC-226(ASOTC-665 defect) with ED2K926784  *
  "Considering only institutional discounts for calculation and skipping other custom discounts
  DELETE li_constant_e354 WHERE param1 = lc_cust_disc.
* EOC by Ramesh on 04/18/2022 for ASOTC-226(ASOTC-665 defect) with ED2K926784  *

  LOOP AT li_constant_e354 ASSIGNING FIELD-SYMBOL(<lfs_constant_e354>).
    " Reda the XKMOV table and get the condition value based on constant Condition type(Institutional discounts)
    IF xkomv[] IS NOT INITIAL.
      READ TABLE xkomv ASSIGNING <lfs_komv> WITH KEY kschl = <lfs_constant_e354>-low .
      IF <lfs_komv> IS ASSIGNED.
        xkwert = xkwert +  <lfs_komv>-kwert.        " Add each cndition value to ZIDNcondition type and return the total
        UNASSIGN <lfs_komv>.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDIF.
