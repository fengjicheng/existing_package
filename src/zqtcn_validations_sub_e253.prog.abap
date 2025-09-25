*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_VALIDATIONS_SUB_E253 (Include Program)
* PROGRAM DESCRIPTION: Validate the processing data based on search term
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   07/15/2020
* WRICEF ID: E253
* TRANSPORT NUMBER(S): ED2K918906
* REFERENCE NO: ERPM-20026
*----------------------------------------------------------------------*

DATA : lir_mvgr5  TYPE RANGE OF mvgr5 INITIAL SIZE 0,      " Range table for Restricted search terms
       lv_blank   TYPE char1,                              " Identify the blank values
       lv_wrong   TYPE char1,                              " Identyfy the wrong value
       lv_messege TYPE string.

CONSTANTS : lc_devid           TYPE zdevid     VALUE 'E253',      " WRICEF ID
            lc_matgrp5         TYPE rvari_vnam VALUE 'MVGR5',     " Search term
            lc_separator       TYPE char01    VALUE '/',          " Search term separator
            lc_opening_bracket TYPE char01 VALUE '(',       " Opening Bracket
            lc_closing_bracket TYPE char01 VALUE ')',       " Closing bracket
            lc_msgtype_w       TYPE char01 VALUE 'W'.

FREE : lv_wrong , lv_messege , lv_blank , lir_mvgr5.
IF xknmt[] IS NOT INITIAL.      " Check whether data processing table is null

  SELECT devid,                           " Development ID
         param1,                          " ABAP: Name of Variant Variable
         param2,                          " ABAP: Name of Variant Variable
         srno,                            " Current selection number
         sign,                            " ABAP: ID: I/E (include/exclude values)
         opti,                            " ABAP: Selection option (EQ/BT/CP/...)
         low,                             " Lower Value of Selection Condition
         high,                            " Upper Value of Selection Condition
         activate                         " Activation indicator for constant
         FROM zcaconstant                 " Wiley Application Constant Table
         INTO TABLE @DATA(li_constant)
         WHERE devid    = @lc_devid
         AND   activate = @abap_true.      " Only active record
  IF sy-subrc IS INITIAL.
    SORT li_constant BY param1.
    LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>).
      CASE <lfs_constant>-param1.
          " Check search term field
        WHEN lc_matgrp5.
          APPEND INITIAL LINE TO lir_mvgr5 ASSIGNING FIELD-SYMBOL(<lfs_mvgr5>).
          <lfs_mvgr5>-sign = <lfs_constant>-sign.
          <lfs_mvgr5>-option = <lfs_constant>-opti.
          <lfs_mvgr5>-low  = <lfs_constant>-low.
          <lfs_mvgr5>-high = <lfs_constant>-high.
      ENDCASE.
    ENDLOOP.
  ENDIF.

  " Fetch Society models from the material group 5 config table
  SELECT a~mvgr5 AS sortl,b~bezei
    FROM tvm5 AS a INNER JOIN
         tvm5t AS b ON b~mvgr5 = a~mvgr5
    INTO TABLE @DATA(li_data)
    WHERE b~spras EQ @sy-langu.
  IF sy-subrc IS INITIAL.
    SORT li_data BY sortl.
    DELETE li_data WHERE sortl IN lir_mvgr5.

    " Combine the values to genarate the messege
    LOOP AT li_data ASSIGNING FIELD-SYMBOL(<lfs_data>).
      IF lv_messege IS INITIAL.
        CONCATENATE lc_opening_bracket <lfs_data>-sortl INTO lv_messege.         " Begin of prepare the messege with open bracket
      ELSE.
        CONCATENATE lv_messege lc_separator <lfs_data>-sortl INTO lv_messege.    " Concatenate the required values for messege popup
      ENDIF.
    ENDLOOP.
    CONCATENATE lv_messege lc_closing_bracket INTO lv_messege.                    " End Prepare final messege with closing the bracket
  ENDIF.

  DATA(li_knmt_tmp) = xknmt[].      " KNMT processing data assign to temporary table for validation

  LOOP AT li_knmt_tmp ASSIGNING FIELD-SYMBOL(<lfs_knmt_tmp>).
    CONDENSE <lfs_knmt_tmp>-sortl NO-GAPS.      " remove all spaces
    " Check blank value
    IF <lfs_knmt_tmp>-sortl IS INITIAL.
      IF lv_blank IS INITIAL.
        lv_blank = abap_true.             " Enable the blank flag
        CONTINUE.
      ELSE.                               " Blank flag is already filled
        CONTINUE.
      ENDIF.
    ENDIF.
    " Check material group 5 config table is null
    IF li_data IS NOT INITIAL.
      READ TABLE li_data ASSIGNING <lfs_data> WITH KEY sortl = <lfs_knmt_tmp>-sortl BINARY SEARCH.
      IF sy-subrc NE 0.
        lv_wrong = abap_true.           " Enable the error flag
        EXIT.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF lv_wrong = abap_true.              " For Non relevant search terms blocked the precess and return the messege.
    MESSAGE e570(zqtc_r2) WITH lv_messege DISPLAY LIKE lc_msgtype_w.
  ENDIF.
  IF lv_blank = abap_true.              " Search term is blanked
    MESSAGE w569(zqtc_r2) WITH lv_messege.
  ENDIF.

ENDIF.
