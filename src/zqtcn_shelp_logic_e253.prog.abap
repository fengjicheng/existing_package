*----------------------------------------------------------------------
* PROGRAM NAME: ZQTCN_SHELP_LOGIC_E253 (Include Program)
* PROGRAM DESCRIPTION: Build additional logic for Search help displayed data
* DEVELOPER: Lahiru Wathudura
* CREATION DATE:   07/15/2020
* WRICEF ID: E253
* TRANSPORT NUMBER(S): ED2K918906
* REFERENCE NO: ERPM-20026
*----------------------------------------------------------------------*

DATA : lir_mvgr5 TYPE RANGE OF mvgr5 INITIAL SIZE 0.      " Range table for Restricted search terms

CONSTANTS : lc_devid   TYPE zdevid     VALUE 'E253',      " WRICEF ID
            lc_matgrp5 TYPE rvari_vnam VALUE 'MVGR5'.     " Search term

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

SORT li_data BY sortl.
DELETE li_data WHERE sortl IN lir_mvgr5.                                  " Delete restricted search term from the itab

APPEND INITIAL LINE TO li_data ASSIGNING FIELD-SYMBOL(<lfs_data>).        " Add blank row for the result set
