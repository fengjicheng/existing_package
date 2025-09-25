*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INBOUND_BDC_I0233_5
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INBOUND_BDC_I0233_5(Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for ZACO order creation BDC
* DEVELOPER: NPOLINA ( Nageswara )
* CREATION DATE:   25/09/2019
* OBJECT ID: I0233.5
* TRANSPORT NUMBER(S):ED2K916260
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*------------------------------------------------------------------- *
DATA: BEGIN OF bdcdata2 OCCURS 500.
        INCLUDE STRUCTURE bdcdata.
      DATA: END OF bdcdata2.

DATA: lst_bdcdata_233_5       LIKE LINE OF  bdcdata, " Batch input: New table field structure
      li_dxbdcdata            TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
      lst_z1qtc_e1edk01_233_5 TYPE z1qtc_e1edk01_01, " Header General Data Entension
      lv_vbegdat233_5         TYPE dats,             " Field of type DATS
      lv_venddat233_5         TYPE dats,             " Field of type DATS
      lv_posex233_5           TYPE posnr_va,         " Sales Document Item
      lst_edidd_233_5         TYPE edidd,
      lv_tabx                 TYPE sy-tabix,
      lst_ze1edk01            TYPE z1qtc_e1edk01_01,
      lst_e1edk14_1           TYPE e1edk14,
      lst_ze1edp01            TYPE z1qtc_e1edp01_01,
      lv_begdt                TYPE char10,   " Stdt9 of type CHAR10
      lv_enddt                TYPE char10.   " Eddt9 of type CHAR10
STATICS:lv_flag   TYPE char1,
        lv_line2  TYPE char1,
        lv_pcard  TYPE char1,
        lv_dist   TYPE char1,
        lv_posnr  TYPE posnr,
        lv_posval TYPE char6.

DATA:
  lv_pos21   TYPE char3,                     " Pos of type CHAR3
  lv_val21   TYPE char6,                     " Val of type CHAR6
  lv_selkz21 TYPE char19.                    " Selkz of type CHAR19

* Include Sales District
FREE:li_dxbdcdata[].
DESCRIBE TABLE dxbdcdata LINES lv_tabx.
READ TABLE dxbdcdata INTO lst_bdcdata_233_5  WITH KEY fnam = 'VBAK-WAERK'.
IF  sy-subrc EQ 0 AND sy-tabix NE lv_tabx AND lv_dist IS INITIAL.
  lv_tabx = sy-tabix + 1.
  lv_dist = abap_true.

* Read Custom Header segment for Sales District value
  READ TABLE didoc_data INTO lst_edidd_233_5 WITH KEY segnam = 'Z1QTC_E1EDK01_01'.
  IF sy-subrc EQ 0.
* Include BDC navigation for Sales District Screen
    lst_ze1edk01 = lst_edidd_233_5-sdata.
    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-fnam = 'VBKD-BZIRK'.
    lst_bdcdata_233_5-fval = lst_ze1edk01-bzirk.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata. " Appending Contract Start Date
    INSERT LINES OF li_dxbdcdata INTO  dxbdcdata INDEX lv_tabx.
    FREE:li_dxbdcdata.
  ENDIF.
ENDIF.

* Header Payment Cards
FREE:li_dxbdcdata[].
DESCRIBE TABLE dxbdcdata LINES lv_tabx.
READ TABLE dxbdcdata INTO lst_bdcdata_233_5  WITH KEY fnam+0(14) = 'CCDATE-EXDATBI'.
IF  sy-subrc EQ 0 AND sy-tabix NE lv_tabx AND lv_pcard IS INITIAL.
  lv_tabx = sy-tabix.
  lv_pcard = abap_true.
  CLEAR:lst_edidd_233_5.
* Read Custom Header Segment for Payment cards Authorized information
  READ TABLE didoc_data INTO lst_edidd_233_5 WITH KEY segnam = 'Z1QTC_E1EDK01_01'.
  IF sy-subrc EQ 0.

    lst_ze1edk01 = lst_edidd_233_5-sdata.

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-program = 'SAPLV60F'.
    lst_bdcdata_233_5-dynpro = '4001'.
    lst_bdcdata_233_5-dynbegin = 'X'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata. " appending program and screen

    CLEAR lst_bdcdata_233_5. " Clearing work area for BDC data
    lst_bdcdata_233_5-fnam = lc_bok.
    lst_bdcdata_233_5-fval = '/00'.
    APPEND  lst_bdcdata_233_5 TO li_dxbdcdata. "appending OKCODE

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-program = 'SAPLV60F'.
    lst_bdcdata_233_5-dynpro = '4001'.
    lst_bdcdata_233_5-dynbegin = 'X'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata. " appending program and screen

    CLEAR lst_bdcdata_233_5. " Clearing work area for BDC data
    lst_bdcdata_233_5-fnam = lc_bok.
    lst_bdcdata_233_5-fval = '=CCMA'.
    APPEND  lst_bdcdata_233_5 TO li_dxbdcdata. "appending OKCODE

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-program = 'SAPLV60F'.
    lst_bdcdata_233_5-dynpro = '0200'.
    lst_bdcdata_233_5-dynbegin = 'X'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata. " appending program and screen

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-fnam = 'FPLTC-AUNUM'.
    lst_bdcdata_233_5-fval = lst_ze1edk01-aunum.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata. " Appending Contract Start Date

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-fnam = 'FPLTC-AUTWR'.
    lst_bdcdata_233_5-fval = lst_ze1edk01-autwr.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata. " Appending Contract Start Date

    CLEAR lst_bdcdata_233_5. " Clearing work area for BDC data
    lst_bdcdata_233_5-fnam = lc_bok.
    lst_bdcdata_233_5-fval = '=BACK'.
    APPEND  lst_bdcdata_233_5 TO li_dxbdcdata. "appending OKCODE

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-program = 'SAPLV60F'.
    lst_bdcdata_233_5-dynpro = '4001'.
    lst_bdcdata_233_5-dynbegin = 'X'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata. " appending program and screen

    lv_tabx = lv_tabx + 1.
    INSERT LINES OF li_dxbdcdata INTO  dxbdcdata INDEX lv_tabx.
    FREE:li_dxbdcdata.
  ENDIF.
ENDIF.

* Update PO type
CLEAR:lst_bdcdata_233_5.
READ TABLE dxbdcdata ASSIGNING FIELD-SYMBOL(<lfs_233_5>)  WITH KEY fnam = 'VBKD-BSARK'.
IF sy-subrc EQ 0.
  READ TABLE didoc_data INTO lst_edidd_233_5 WITH KEY segnam = 'E1EDK14'
                                                     sdata+0(3) = '013'.
  IF sy-subrc EQ 0.
    lst_e1edk14_1 = lst_edidd_233_5-sdata.
    <lfs_233_5>-fval = lst_e1edk14_1-orgid.
  ENDIF.
ENDIF.


* Include Header Contract Dates
FREE:li_dxbdcdata[].
DESCRIBE TABLE dxbdcdata LINES lv_tabx.
CLEAR:lst_bdcdata_233_5.
READ TABLE dxbdcdata INTO lst_bdcdata_233_5  WITH KEY fnam = 'BDC_OKCODE' fval = 'SICH'.
IF  sy-subrc EQ 0  AND lv_flag IS INITIAL .
  lv_tabx = sy-tabix.
  lv_flag = abap_true.

*   Get Header data from Idoc Structure ------------>>
  READ TABLE didoc_data INTO lst_edidd_233_5 WITH KEY segnam = 'Z1QTC_E1EDK01_01'.
  IF sy-subrc EQ 0.

    lst_ze1edk01 = lst_edidd_233_5-sdata.
    CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
      EXPORTING
        input  = lst_ze1edk01-vbegdat
      IMPORTING
        output = lv_begdt.

    CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
      EXPORTING
        input  = lst_ze1edk01-venddat
      IMPORTING
        output = lv_enddt.

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-program = 'SAPMV45A'.
    lst_bdcdata_233_5-dynpro = '4001'.
    lst_bdcdata_233_5-dynbegin = 'X'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata. " appending program and screen

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-fnam = 'BDC_OKCODE'.
    lst_bdcdata_233_5-fval = 'HEAD'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata.

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-program = 'SAPLV60F'.
    lst_bdcdata_233_5-dynpro = '4001'.
    lst_bdcdata_233_5-dynbegin = 'X'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata. " appending program and screen

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-fnam = 'BDC_OKCODE'.
    lst_bdcdata_233_5-fval = 'T\02'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata.

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-program = 'SAPLV45W'.
    lst_bdcdata_233_5-dynpro = '4001'.
    lst_bdcdata_233_5-dynbegin = 'X'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata. " appending program and screen

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-fnam = 'VEDA-VBEGDAT'.
    lst_bdcdata_233_5-fval = lv_begdt.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata. " Appending Contract Start Date

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-fnam = 'VEDA-VENDDAT'.
    lst_bdcdata_233_5-fval = lv_enddt.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata. " Appending Contract End Date

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-fnam = 'BDC_OKCODE'.
    lst_bdcdata_233_5-fval = 'S\BACK'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata.

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-program = 'SAPMV45A'.
    lst_bdcdata_233_5-dynpro = '4001'.
    lst_bdcdata_233_5-dynbegin = 'X'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata.

    lv_tabx = lv_tabx ."- 1.
    INSERT LINES OF li_dxbdcdata INTO  dxbdcdata INDEX lv_tabx.
    FREE:li_dxbdcdata.
  ENDIF.
ENDIF.

* Include ITEM Contract Dates
CLEAR:lst_bdcdata_233_5.

LOOP AT dxbdcdata INTO lst_bdcdata_233_5  WHERE fnam+0(10) = 'VBAP-POSEX'.
  lv_tabx = sy-tabix.
  CLEAR:lst_edidd_233_5,lv_posval.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = lst_bdcdata_233_5-fval
    IMPORTING
      output = lv_posval.

* Read Custom Item Segment for each Item for Contract Dates
  READ TABLE didoc_data INTO lst_edidd_233_5 WITH KEY segnam = 'Z1QTC_E1EDP01_01'
                                                      sdata+0(6) = lv_posval.
  IF sy-subrc EQ 0 AND lv_posnr NE lv_posval AND lv_posval GT lv_posnr  .

    lst_ze1edp01 = lst_edidd_233_5-sdata.
    lv_posnr = lv_posval.

    CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
      EXPORTING
        input  = lst_ze1edp01-vbegdat
      IMPORTING
        output = lv_begdt.

    CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
      EXPORTING
        input  = lst_ze1edp01-venddat
      IMPORTING
        output = lv_enddt.

    lv_pos1 = lst_bdcdata_233_5-fnam+10(3).
    lv_val1 = lst_bdcdata_233_5-fval.

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-program = 'SAPMV45A'.
    lst_bdcdata_233_5-dynpro = '4001'.
    lst_bdcdata_233_5-dynbegin = 'X'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata. " appending program and screen

    CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos1 INTO lv_selkz1.

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-fnam = lv_selkz1.
    lst_bdcdata_233_5-fval = 'X'.
    APPEND  lst_bdcdata_233_5 TO li_dxbdcdata. "appending OKCODE

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-fnam = 'BDC_OKCODE'.
    lst_bdcdata_233_5-fval = '=PVER'.
    APPEND  lst_bdcdata_233_5 TO li_dxbdcdata. "appending OKCODE

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-program = 'SAPLV45W'.
    lst_bdcdata_233_5-dynpro = '4001'.
    lst_bdcdata_233_5-dynbegin = 'X'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata. " Appending Screen

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-fnam = 'VEDA-VBEGDAT'.
    lst_bdcdata_233_5-fval = lv_begdt.
    APPEND  lst_bdcdata_233_5 TO li_dxbdcdata. " Appending Contract Start Date

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-fnam = 'VEDA-VENDDAT'.
    lst_bdcdata_233_5-fval = lv_enddt.
    APPEND  lst_bdcdata_233_5 TO li_dxbdcdata. " Appending Contract End Date

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-fnam = 'BDC_OKCODE'.
    lst_bdcdata_233_5-fval = '/EBACK'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata.

    CLEAR lst_bdcdata_233_5.
    lst_bdcdata_233_5-program = 'SAPMV45A'.
    lst_bdcdata_233_5-dynpro = '4001'.
    lst_bdcdata_233_5-dynbegin = 'X'.
    APPEND lst_bdcdata_233_5 TO li_dxbdcdata.

    lv_tabx = lv_tabx + 1.
    INSERT LINES OF li_dxbdcdata INTO  dxbdcdata INDEX lv_tabx.
    lv_line2 = abap_true.
    FREE:li_dxbdcdata.
  ENDIF.
ENDLOOP.
