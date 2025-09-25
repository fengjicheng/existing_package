*&---------------------------------------------------------------------*
*&  Include           ZQTCN_VALIDATE_OUTPUT_E203
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_VALIDATE_OUTPUT_E203 (Include Program)
* PROGRAM DESCRIPTION: Validation for output types for correct scenarios
* DEVELOPER: AMOHAMMED
* CREATION DATE: 09/10/2020
* OBJECT ID: E203/ERPM-24413
* TRANSPORT NUMBER(S):ED2K919454
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
*----------------------    Types Declarations     ---------------------*
TYPES: BEGIN OF lty_const,"
         devid    TYPE zdevid,              " Development id
         param1   TYPE rvari_vnam,          " Parameter
         param2   TYPE rvari_vnam,          " Parameter
         srno     TYPE tvarv_numb,          " Serial number
         sign     TYPE tvarv_sign,          " Sign
         opti     TYPE tvarv_opti,          " Option
         low      TYPE salv_de_selopt_low,  " Low value
         high     TYPE salv_de_selopt_high, " High Value
         activate TYPE zconstactive,        " Activate
       END OF lty_const,
       ltt_const TYPE STANDARD TABLE OF lty_const INITIAL SIZE 0.
*--------- Declaration of local Workareas and Internal Tables ---------*
DATA : lv_kschl          TYPE sna_kschl,
       li_const          TYPE ltt_const,             " Internal table for Constant
       lst_const         TYPE lty_const,             " Workarea for Constant
       lv_vbtyp          TYPE vbtyp,            " SD document category
       lrs_pymt_mthd     TYPE trty_zlsch_range,      " Range table for Payment Method
       lrs_mgrp5_zsoc    TYPE STANDARD TABLE OF zstqtc_mvgr5_range, " Range table for Material Group 5
       lrs_mgrp5_ztbt    TYPE STANDARD TABLE OF zstqtc_mvgr5_range, " Range table for Material Group 5
       lv_flag_zsoc      TYPE c,
       lv_flag_ztbt      TYPE c,
       lv_flag_zsoc_ztbt TYPE c.
*-------------    Declaration of local Constants    -------------------*
CONSTANTS:
  lc_devid_203 TYPE zdevid     VALUE 'E203',  " Development ID: 203
  lc_vbtyp     TYPE rvari_vnam VALUE 'VBTYP', " SD document category
  lc_zlsch     TYPE rvari_vnam VALUE 'ZLSCH', " Payment Method
  lc_mvgr5     TYPE rvari_vnam VALUE 'MVGR5', " Material group 5
  lc_zsoc      TYPE rvari_vnam VALUE 'ZSOC',  " Material group 5
  lc_ztbt      TYPE rvari_vnam VALUE 'ZTBT',  " Material group 5
  lc_ca4       TYPE rvari_vnam VALUE 'CS4',
  lc_er        TYPE c VALUE 'E', " Error message
  lc_d         TYPE c VALUE 'D'. " Deleted

CONSTANTS : lc_prg_str TYPE char40 VALUE '(SAPLV61B)VNAST[]'.
FIELD-SYMBOLS: <li_nast> TYPE tdt_vnast.
DATA :    li_nast TYPE tdt_vnast.
REFRESH : li_nast, li_const, lrs_mgrp5_zsoc,
          lrs_mgrp5_ztbt, lrs_pymt_mthd.
CLEAR : lv_vbtyp, lv_flag_zsoc, lv_flag_ztbt.

" Works only in the forgrouond
IF sy-batch IS INITIAL AND sy-binpt IS INITIAL.
  ASSIGN (lc_prg_str) TO <li_nast>.
  IF sy-subrc EQ 0.
    li_nast = <li_nast>.
    " Remove the deleted output types
    DELETE li_nast WHERE updat EQ lc_d.
*-- Get data from constant table: ZCACONSTANT
    IF li_const[] IS INITIAL.
      SELECT devid            " Development ID
             param1           " ABAP: Name of Variant Variable
             param2           " ABAP: Name of Variant Variable
             srno             " Current selection number
             sign             " ABAP: ID: I/E (include/exclude values)
             opti             " ABAP: Selection option (EQ/BT/CP/...)
             low              " Lower Value of Selection Condition
             high             " Upper Value of Selection Condition
             activate         " Activation indicator for constant
             FROM zcaconstant " Wiley Application Constant Table
             INTO TABLE li_const
             WHERE devid    = lc_devid_203
             AND   activate = abap_true. " Only active record
      IF sy-subrc EQ 0.
        SORT li_const BY devid param1 param2.
        DELETE li_const WHERE param1 NE lc_mvgr5 AND
                              param1 NE lc_vbtyp AND
                              param1 NE lc_zlsch.
        DELETE li_const WHERE param2 EQ lc_ca4.
        LOOP AT li_const ASSIGNING FIELD-SYMBOL(<lst_const>).
          CASE <lst_const>-param1.
            WHEN lc_mvgr5.
              CASE <lst_const>-param2.
                WHEN lc_zsoc.
                  APPEND INITIAL LINE TO lrs_mgrp5_zsoc ASSIGNING FIELD-SYMBOL(<lst_mgrp5_zsoc>).
                  <lst_mgrp5_zsoc>-sign   = <lst_const>-sign.
                  <lst_mgrp5_zsoc>-option = <lst_const>-opti.
                  <lst_mgrp5_zsoc>-low    = <lst_const>-low.
                  <lst_mgrp5_zsoc>-high   = <lst_const>-high.
                WHEN lc_ztbt.
                  APPEND INITIAL LINE TO lrs_mgrp5_ztbt ASSIGNING FIELD-SYMBOL(<lst_mgrp5_ztbt>).
                  <lst_mgrp5_ztbt>-sign   = <lst_const>-sign.
                  <lst_mgrp5_ztbt>-option = <lst_const>-opti.
                  <lst_mgrp5_ztbt>-low    = <lst_const>-low.
                  <lst_mgrp5_ztbt>-high   = <lst_const>-high.
              ENDCASE.
            WHEN lc_vbtyp.
              lv_vbtyp = <lst_const>-low.
            WHEN lc_zlsch.
              APPEND INITIAL LINE TO lrs_pymt_mthd ASSIGNING FIELD-SYMBOL(<lst_pymt_mthd>).
              <lst_pymt_mthd>-sign   = <lst_const>-sign.
              <lst_pymt_mthd>-option = <lst_const>-opti.
              <lst_pymt_mthd>-low    = <lst_const>-low.
              <lst_pymt_mthd>-high   = <lst_const>-high.
          ENDCASE.
        ENDLOOP.
        " When document category is 'M', Payment Method is 'U'/'J'
        IF vbrk-vbtyp EQ lv_vbtyp AND vbrk-zlsch IN lrs_pymt_mthd.
          " When Material Group 5 is 'DI'/'IN'/'MA'/'OF'
          LOOP AT xvbrp WHERE mvgr5 IN lrs_mgrp5_zsoc.
            " Set the zsoc flag
            lv_flag_zsoc = abap_true.
            EXIT.
          ENDLOOP. " LOOP AT xvbrp WHERE mvgr5 IN lrs_mgrp5_zsoc.
          " When the zsoc flag is set
          IF lv_flag_zsoc IS NOT INITIAL.
            " ZTBT output type should not be allowed.
            LOOP AT li_nast TRANSPORTING NO FIELDS WHERE kschl EQ lc_ztbt.
              " Display the message "Please maintain output type ZSOC"
              MESSAGE e571(zqtc_r2) WITH lc_zsoc DISPLAY LIKE lc_er.
              EXIT.
            ENDLOOP.
          ENDIF. " IF lv_flag_zsoc IS NOT INITIAL.

          " When Material Group 5 is 'SO'/'WP'
          LOOP AT xvbrp WHERE mvgr5 IN lrs_mgrp5_ztbt.
            " Set the ztbt flag
            lv_flag_ztbt = abap_true.
            EXIT.
          ENDLOOP. " LOOP AT xvbrp WHERE mvgr5 IN lrs_mgrp5_ztbt.
          " When the ztbt flag is set
          IF lv_flag_ztbt IS NOT INITIAL.
            " ZSOC output type should not be allowed.
            LOOP AT li_nast TRANSPORTING NO FIELDS WHERE kschl EQ lc_zsoc.
              " Display the message "Please maintain output type ZTBT"
              MESSAGE e571(zqtc_r2) WITH lc_ztbt DISPLAY LIKE lc_er.
              EXIT.
            ENDLOOP.
          ENDIF. " IF lv_flag_ztbt IS NOT INITIAL.
        ENDIF. " IF vbrk-vbtyp EQ lv_vbtyp AND vbrk-zlsch IN lrs_pymt_mthd.
        FREE : li_const, lrs_mgrp5_zsoc, lrs_mgrp5_ztbt, lv_vbtyp,
               lrs_pymt_mthd, lv_flag_zsoc, lv_flag_ztbt.
      ENDIF. " IF sy-subrc EQ 0.
    ENDIF. " IF li_const[] IS INITIAL.
    FREE : <li_nast>, li_nast.
  ENDIF. " IF sy-subrc EQ 0.
ENDIF. " IF sy-batch IS INITIAL AND sy-binpt IS INITIAL AND call_bapi IS INITIAL.
