*&---------------------------------------------------------------------*
*&  Include           ZQTCN_INBOUND_BDC_I0230_1
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_INBOUND_BDC_I0230_1(Enhancement Implementation)
* PROGRAM DESCRIPTION: Include for ZACO order creation BDC
* DEVELOPER: NPOLINA ( Nageswara )
* CREATION DATE:   25/09/2019
* OBJECT ID: I0230.1
* TRANSPORT NUMBER(S):ED2K916260
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K916699
* REFERENCE NO: ERPM5261
* DEVELOPER:NPOLINA
* DATE:  06/Nov/2019
* DESCRIPTION: EMail to passing to ZACO Order Partners
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K920376
* REFERENCE NO: OTCM-37417
* DEVELOPER:VDPATABALL
* DATE:  20/Nov/2020
* DESCRIPTION: Updating the Payment method in Header level
*------------------------------------------------------------------- *
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K922583
* REFERENCE NO: OTCM-43095 (EPCI - 178)
* DEVELOPER:mimmadiset
* DATE:  03/16/2021
* DESCRIPTION: If hybris sends POSEX as 1, then VBAP-POSNR needs to be 10,
*if hybris sends POSEX as 2, then VBAP-POSNR needs to be 20, etc.
*------------------------------------------------------------------- *
DATA: BEGIN OF bdcdata2 OCCURS 500.
        INCLUDE STRUCTURE bdcdata.
      DATA: END OF bdcdata2.

DATA: lst_bdcdata_230_1       LIKE LINE OF  bdcdata, " Batch input: New table field structure
      li_dxbdcdata            TYPE STANDARD TABLE OF bdcdata, " Batch input: New table field structure
      lst_z1qtc_e1edk01_230_1 TYPE z1qtc_e1edk01_01, " Header General Data Entension
      lv_vbegdat230_1         TYPE dats,             " Field of type DATS
      lv_venddat230_1         TYPE dats,             " Field of type DATS
      lv_posex230_1           TYPE posnr_va,         " Sales Document Item
      lst_edidd_230_1         TYPE edidd,
      lv_tabx                 TYPE sy-tabix,
      lst_ze1edk01            TYPE z1qtc_e1edk01_01,
      lst_e1edk14_1           TYPE e1edk14,
      lst_e1edka1_1           TYPE e1edka1,
      lst_e1edpa1_1           TYPE e1edpa1,
      lst_ze1edp01            TYPE z1qtc_e1edp01_01,
      lst_e1edk02             TYPE e1edk02,
      lv_begdt                TYPE char10,   " Stdt9 of type CHAR10
      lv_enddt                TYPE char10,   " Eddt9 of type CHAR10
      lv_demdt                TYPE char10,   " Eddt9 of type CHAR10 Dismatle date
      lv_email1               TYPE ad_smtpadr.
STATICS:lv_flag     TYPE char1,
        lv_line2    TYPE char1,
        lv_pcard    TYPE char1,
        lv_dist     TYPE char1,
        lv_posnr    TYPE posnr,
        lv_posval   TYPE char6,
        lv_docnum_t TYPE edi_docnum.

CONSTANTS:lc_ze1edk01 TYPE edilsegtyp VALUE 'Z1QTC_E1EDK01_01',
          lc_e1edk01  TYPE edilsegtyp VALUE 'E1EDK01',
          lc_e1edk02  TYPE edilsegtyp VALUE 'E1EDK02',
          lc_ze1edp01 TYPE edilsegtyp VALUE 'Z1QTC_E1EDP01_01'.
CONSTANTS:lc1_e1edka1_8        TYPE char7 VALUE 'E1EDKA1',           " E1edka1_8 of type CHAR7
          lc1_z1qtc_e1edka1_01 TYPE char16     VALUE 'Z1QTC_E1EDKA1_01',
          lc_idoc_pa           TYPE char30     VALUE '(SAPLVEDA)XVBPA[]'.

FIELD-SYMBOLS : <li_xvbpa> TYPE tt_vbpavb .

DATA:
  lv_pos21              TYPE char3,                     " Pos of type CHAR3
  lv_val21              TYPE char6,                     " Val of type CHAR6
  lv_selkz21            TYPE char19,                    " Selkz of type CHAR19
  lst1_z1qtc_e1edka1_01 TYPE z1qtc_e1edka1_01,
  lv_loop               TYPE sy-tabix,
  lv_row(2)             TYPE n,
  lv_rowsel(80)         TYPE c,           " Row selection
  lv_street4            TYPE ad_strspp3.

*---Static Variable clearing based on DOCNUM field (IDOC Number).
CLEAR lst_edidd_230_1.
READ TABLE didoc_data INTO lst_edidd_230_1 INDEX 1.
IF sy-subrc = 0.
  IF lv_docnum_t NE lst_edidd_230_1-docnum.
    FREE:lv_flag,
         lv_line2,
         lv_pcard,
         lv_dist,
         lv_posnr,
         lv_posval,
         lv_docnum_t.
    lv_docnum_t  = lst_edidd_230_1-docnum.
  ENDIF.
ENDIF.
* Include Sales District
FREE:li_dxbdcdata[].
DESCRIBE TABLE dxbdcdata LINES lv_tabx.
READ TABLE dxbdcdata INTO lst_bdcdata_230_1  WITH KEY fnam = 'VBAK-WAERK'.
IF  sy-subrc EQ 0 AND sy-tabix NE lv_tabx AND lv_dist IS INITIAL.
  lv_tabx = sy-tabix + 1.
  lv_dist = abap_true.

* Read Custom Header segment for Sales District value
  READ TABLE didoc_data INTO lst_edidd_230_1 WITH KEY segnam = lc_ze1edk01.
  IF sy-subrc EQ 0.
* Include BDC navigation for Sales District Screen
    lst_ze1edk01 = lst_edidd_230_1-sdata.
    CLEAR lst_bdcdata_230_1.
    IF lst_ze1edk01-bzirk IS NOT INITIAL.
      lst_bdcdata_230_1-fnam = 'VBKD-BZIRK'.
      lst_bdcdata_230_1-fval = lst_ze1edk01-bzirk.
      APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " Appending Contract Start Date
      INSERT LINES OF li_dxbdcdata INTO  dxbdcdata INDEX lv_tabx.
      FREE:li_dxbdcdata.
    ENDIF. " IF lst_ze1edk01-bzirk IS NOT INITIAL.

  ENDIF.
ENDIF.

* Header Payment Cards
FREE:li_dxbdcdata[].
DESCRIBE TABLE dxbdcdata LINES lv_tabx.
READ TABLE dxbdcdata INTO lst_bdcdata_230_1  WITH KEY fnam+0(14) = 'CCDATE-EXDATBI'.
IF  sy-subrc EQ 0 AND sy-tabix NE lv_tabx AND lv_pcard IS INITIAL.
  lv_tabx = sy-tabix.
  lv_pcard = abap_true.
  CLEAR:lst_edidd_230_1.
* Read Custom Header Segment for Payment cards Authorized information
  READ TABLE didoc_data INTO lst_edidd_230_1 WITH KEY segnam = lc_ze1edk01.
  IF sy-subrc EQ 0.

    lst_ze1edk01 = lst_edidd_230_1-sdata.

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-program = 'SAPLV60F'.
    lst_bdcdata_230_1-dynpro = '4001'.
    lst_bdcdata_230_1-dynbegin = 'X'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " appending program and screen

    CLEAR lst_bdcdata_230_1. " Clearing work area for BDC data
    lst_bdcdata_230_1-fnam = lc_bok.
    lst_bdcdata_230_1-fval = '/00'.
    APPEND  lst_bdcdata_230_1 TO li_dxbdcdata. "appending OKCODE

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-program = 'SAPLV60F'.
    lst_bdcdata_230_1-dynpro = '4001'.
    lst_bdcdata_230_1-dynbegin = 'X'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " appending program and screen

    CLEAR lst_bdcdata_230_1. " Clearing work area for BDC data
    lst_bdcdata_230_1-fnam = lc_bok.
    lst_bdcdata_230_1-fval = '=CCMA'.
    APPEND  lst_bdcdata_230_1 TO li_dxbdcdata. "appending OKCODE

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-program = 'SAPLV60F'.
    lst_bdcdata_230_1-dynpro = '0200'.
    lst_bdcdata_230_1-dynbegin = 'X'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " appending program and screen

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-fnam = 'FPLTC-AUNUM'.
    lst_bdcdata_230_1-fval = lst_ze1edk01-aunum.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " AUth num

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-fnam = 'FPLTC-AUTRA'.
    lst_bdcdata_230_1-fval = lst_ze1edk01-autra.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. "

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-fnam = 'FPLTC-AUTWR'.
    lst_bdcdata_230_1-fval = lst_ze1edk01-autwr.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " AUth Amount

    CLEAR lst_bdcdata_230_1. " Clearing work area for BDC data
    lst_bdcdata_230_1-fnam = lc_bok.
    lst_bdcdata_230_1-fval = '=BACK'.
    APPEND  lst_bdcdata_230_1 TO li_dxbdcdata. "appending OKCODE

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-program = 'SAPLV60F'.
    lst_bdcdata_230_1-dynpro = '4001'.
    lst_bdcdata_230_1-dynbegin = 'X'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " appending program and screen

    lv_tabx = lv_tabx + 1.
    INSERT LINES OF li_dxbdcdata INTO  dxbdcdata INDEX lv_tabx.
    FREE:li_dxbdcdata.
  ENDIF.
ENDIF.

* Update PO type
CLEAR:lst_bdcdata_230_1.
READ TABLE dxbdcdata ASSIGNING FIELD-SYMBOL(<lfs_230_1>)  WITH KEY fnam = 'VBKD-BSARK'.
IF sy-subrc EQ 0.
  READ TABLE didoc_data INTO lst_edidd_230_1 WITH KEY segnam = lc_e1edk14
                                                     sdata+0(3) = '013'.
  IF sy-subrc EQ 0.
    lst_e1edk14_1 = lst_edidd_230_1-sdata.
    <lfs_230_1>-fval = lst_e1edk14_1-orgid.
  ENDIF.
ENDIF.

*----Begin of change vdpataball 11/19/2020 ED2K920376 OTCM-37417 payment method mapping to header
READ TABLE dxbdcdata ASSIGNING <lfs_230_1>  WITH KEY fnam = 'VBKD-BSARK'.
IF sy-subrc = 0.

  CLEAR :lst_bdcdata,lst_edidd_230_1.
  READ TABLE dxbdcdata[] INTO lst_bdcdata WITH KEY fnam = 'VBKD-ZLSCH'.
  IF sy-subrc NE 0.
    READ TABLE didoc_data INTO lst_edidd_230_1 WITH KEY segnam = lc_ze1edk01.
    IF sy-subrc EQ 0.
* Include BDC navigation for Sales District Screen
      lst_ze1edk01 = lst_edidd_230_1-sdata.
    ENDIF.
    IF lst_ze1edk01-zlsch IS NOT INITIAL.
      CLEAR lst_bdcdata_230_1.
      lst_bdcdata_230_1-program = 'SAPMV45A'.
      lst_bdcdata_230_1-dynpro = '4002'.
      lst_bdcdata_230_1-dynbegin = 'X'.
      APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " appending program and screen

      CLEAR lst_bdcdata_230_1.
      lst_bdcdata_230_1-fnam = 'BDC_OKCODE'.
      lst_bdcdata_230_1-fval = '=T\06'.
      APPEND lst_bdcdata_230_1 TO li_dxbdcdata.

      CLEAR lst_bdcdata_230_1.
      lst_bdcdata_230_1-program = 'SAPMV45A'.
      lst_bdcdata_230_1-dynpro = '4002'.
      lst_bdcdata_230_1-dynbegin = 'X'.
      APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " appending program and screen
      CLEAR lst_bdcdata_230_1.

      lst_bdcdata_230_1-fnam = 'VBKD-ZLSCH'.
      lst_bdcdata_230_1-fval = lst_ze1edk01-zlsch.
      APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " Appending Assignment
      APPEND LINES OF li_dxbdcdata TO  dxbdcdata ."INDEX lv_tabix_1.
      FREE:li_dxbdcdata.
    ENDIF.
  ENDIF.
ENDIF.
*----End of change VDPATABALL 11/19/2020 ED2K920376 OTCM-37417 Payment method mapping to header

* Include Header Contract Dates
FREE:li_dxbdcdata[].
DESCRIBE TABLE dxbdcdata LINES lv_tabx.
CLEAR:lst_bdcdata_230_1.
READ TABLE dxbdcdata INTO lst_bdcdata_230_1  WITH KEY fnam = 'BDC_OKCODE' fval = 'SICH'.
IF  sy-subrc EQ 0  AND lv_flag IS INITIAL .
  lv_tabx = sy-tabix.
  lv_flag = abap_true.

*   Get Header data from Idoc Structure ------------>>
  READ TABLE didoc_data INTO lst_edidd_230_1 WITH KEY segnam = lc_ze1edk01.
  IF sy-subrc EQ 0.

    lst_ze1edk01 = lst_edidd_230_1-sdata.
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

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-program = 'SAPMV45A'.
    lst_bdcdata_230_1-dynpro = '4001'.
    lst_bdcdata_230_1-dynbegin = 'X'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " appending program and screen

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-fnam = 'BDC_OKCODE'.
    lst_bdcdata_230_1-fval = 'HEAD'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata.

    CLEAR lst_bdcdata_230_1.
*BOC by RBRAHMADI on 01/15/2020 for ITS-1157 SIT issue
*    lst_bdcdata_230_1-program = 'SAPLV60F'.
*    lst_bdcdata_230_1-dynpro = '4001'.
*EOC by RBRAHMADI on 01/15/2020 for ITS-1157 SIT issue
*Start of code by RBRAHMADI on 01/15/2020 for ITS-1157 SIT issue
    READ TABLE dxbdcdata INTO lst_bdcdata_230_1  WITH KEY fnam+0(14) = 'CCDATE-EXDATBI'.
    IF sy-subrc = 0.
      CLEAR lst_bdcdata_230_1.
      lst_bdcdata_230_1-program = 'SAPLV60F'.
      lst_bdcdata_230_1-dynpro = '4001'.
    ELSE.
      CLEAR lst_bdcdata_230_1.
      lst_bdcdata_230_1-program = 'SAPMV45A'.
      lst_bdcdata_230_1-dynpro = '5002'.
    ENDIF.
*End of Code by RBRAHMADI on 01/15/2020 for ITS-1157 SIT issue
    lst_bdcdata_230_1-dynbegin = 'X'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " appending program and screen

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-fnam = 'BDC_OKCODE'.
    lst_bdcdata_230_1-fval = 'T\02'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata.

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-program = 'SAPLV45W'.
    lst_bdcdata_230_1-dynpro = '4001'.
    lst_bdcdata_230_1-dynbegin = 'X'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " appending program and screen

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-fnam = 'VEDA-VBEGDAT'.
    lst_bdcdata_230_1-fval = lv_begdt.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " Appending Contract Start Date

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-fnam = 'VEDA-VENDDAT'.
    lst_bdcdata_230_1-fval = lv_enddt.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " Appending Contract End Date

* SOC by NPOLINA ERPM5261 ED2K916699
* Update Header Partner Email IDS
    ASSIGN (lc_idoc_pa) TO <li_xvbpa>.

    IF <li_xvbpa> IS ASSIGNED .
      LOOP AT didoc_data INTO lst_edidd_230_1 WHERE segnam = lc1_e1edka1_8.
        CLEAR:lv_loop,lv_email1,lv_row,lv_street4.
        lv_loop = sy-tabix.
        lv_loop = lv_loop + 1.
        CLEAR:lst1_z1qtc_e1edka1_01,lst_e1edka1_1.
        lst_e1edka1_1 = lst_edidd_230_1-sdata.
        READ TABLE didoc_data ASSIGNING FIELD-SYMBOL(<lfs_zka1>) WITH KEY segnam = lc1_z1qtc_e1edka1_01
                                                                          sdata+60(2) = lst_e1edka1_1-parvw.
        IF sy-subrc EQ 0.
          READ TABLE <li_xvbpa> ASSIGNING FIELD-SYMBOL(<lfs_pa1>) WITH KEY parvw = lst_e1edka1_1-parvw.
          IF sy-subrc EQ 0.
            lv_row = sy-tabix.
            lst1_z1qtc_e1edka1_01 = <lfs_zka1>-sdata.
            lv_email1 = lst1_z1qtc_e1edka1_01-smtp_addr.
            lv_street4 = lst1_z1qtc_e1edka1_01-str_suppl3.
            CLEAR:lv_rowsel.
            CONCATENATE 'GVS_TC_DATA-SELKZ(' lv_row ')' INTO lv_rowsel.
            CONDENSE lv_rowsel NO-GAPS.
          ENDIF.
        ELSE.
          CONTINUE.
        ENDIF.

        IF lv_email1 IS NOT INITIAL OR
          lv_street4 IS NOT INITIAL.
          CLEAR lst_bdcdata_230_1.
          lst_bdcdata_230_1-fnam = 'BDC_OKCODE'.
          lst_bdcdata_230_1-fval = 'T\09'.
          APPEND lst_bdcdata_230_1 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_1.
          lst_bdcdata_230_1-program = 'SAPMV45A'.
          lst_bdcdata_230_1-dynpro = '4002'.
          lst_bdcdata_230_1-dynbegin = 'X'.
          APPEND lst_bdcdata_230_1 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_1.
          lst_bdcdata_230_1-fnam = lv_rowsel.
          lst_bdcdata_230_1-fval = 'X'.
          APPEND lst_bdcdata_230_1 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_1.
          lst_bdcdata_230_1-fnam = 'BDC_OKCODE'.
          lst_bdcdata_230_1-fval = 'PSDE'.
          APPEND lst_bdcdata_230_1 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_1.
          lst_bdcdata_230_1-program = 'SAPLV09C'.
          lst_bdcdata_230_1-dynpro = '5000'.
          lst_bdcdata_230_1-dynbegin = 'X'.
          APPEND lst_bdcdata_230_1 TO li_dxbdcdata.
*-----street4 field
          IF lv_street4 IS NOT INITIAL.
            CLEAR lst_bdcdata_230_1.
            lst_bdcdata_230_1-fnam = 'ADDR1_DATA-STR_SUPPL3'.
            lst_bdcdata_230_1-fval = lv_street4.
            APPEND lst_bdcdata_230_1 TO li_dxbdcdata.
          ENDIF.
          IF lv_email1 IS NOT INITIAL.
            CLEAR lst_bdcdata_230_1.
            lst_bdcdata_230_1-fnam = 'SZA1_D0100-SMTP_ADDR'.
            lst_bdcdata_230_1-fval = lv_email1.
            APPEND lst_bdcdata_230_1 TO li_dxbdcdata.

            CLEAR lst_bdcdata_230_1.
            lst_bdcdata_230_1-fnam = 'ADDR1_DATA-DEFLT_COMM'.
            lst_bdcdata_230_1-fval = 'INT'.
            APPEND lst_bdcdata_230_1 TO li_dxbdcdata.
          ENDIF.
          CLEAR lst_bdcdata_230_1.
          lst_bdcdata_230_1-fnam = 'BDC_OKCODE'.
          lst_bdcdata_230_1-fval = 'ENT1'.
          APPEND lst_bdcdata_230_1 TO li_dxbdcdata.

          CLEAR lst_bdcdata_230_1.
          lst_bdcdata_230_1-program = 'SAPMV45A'.
          lst_bdcdata_230_1-dynpro = '4002'.
          lst_bdcdata_230_1-dynbegin = 'X'.
          APPEND lst_bdcdata_230_1 TO li_dxbdcdata.
        ENDIF.                    " if lv_email1 is not initial
      ENDLOOP.
    ENDIF.
* EOC by NPOLINA ERPM5261 ED2K916699

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-fnam = 'BDC_OKCODE'.
    lst_bdcdata_230_1-fval = 'S\BACK'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata.

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-program = 'SAPMV45A'.
    lst_bdcdata_230_1-dynpro = '4001'.
    lst_bdcdata_230_1-dynbegin = 'X'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata.

    lv_tabx = lv_tabx ."- 1.
    INSERT LINES OF li_dxbdcdata INTO  dxbdcdata INDEX lv_tabx.
    FREE:li_dxbdcdata.
  ENDIF.
ENDIF.

* Include ITEM Contract Dates
CLEAR:lst_bdcdata_230_1.

LOOP AT dxbdcdata INTO lst_bdcdata_230_1  WHERE fnam+0(10) = 'VBAP-POSEX'.
  lv_tabx = sy-tabix.
  CLEAR:lst_edidd_230_1,lv_posval.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = lst_bdcdata_230_1-fval
    IMPORTING
      output = lv_posval.

* Read Custom Item Segment for each Item for Contract Dates
  READ TABLE didoc_data INTO lst_edidd_230_1 WITH KEY segnam = lc_ze1edp01
                                                      sdata+0(6) = lv_posval.
  IF sy-subrc EQ 0 AND lv_posnr NE lv_posval AND lv_posval GT lv_posnr  .

    lst_ze1edp01 = lst_edidd_230_1-sdata.
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

    CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
      EXPORTING
        input  = lst_ze1edp01-vdemdat
      IMPORTING
        output = lv_demdt.

    lv_pos1 = lst_bdcdata_230_1-fnam+10(3).
    lv_val1 = lst_bdcdata_230_1-fval.
* BOC by MIMMADISET OTCM-43095 ED2K922583
    lst_bdcdata_230_1-program = lst_bdcdata_230_1-program.
    lst_bdcdata_230_1-dynpro = lst_bdcdata_230_1-dynpro.
    lst_bdcdata_230_1-dynbegin = lst_bdcdata_230_1-dynbegin.
    lst_bdcdata_230_1-fnam = 'VBAP-POSNR' && lv_pos1.
    lst_bdcdata_230_1-fval = lv_posnr * 10.
    CONDENSE lst_bdcdata_230_1-fval.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " appending program and screen
* EOC by MIMMADISET OTCM-43095 ED2K922583
    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-program = 'SAPMV45A'.
    lst_bdcdata_230_1-dynpro = '4001'.
    lst_bdcdata_230_1-dynbegin = 'X'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " appending program and screen

    CONCATENATE 'RV45A-VBAP_SELKZ' lv_pos1 INTO lv_selkz1.

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-fnam = lv_selkz1.
    lst_bdcdata_230_1-fval = 'X'.
    APPEND  lst_bdcdata_230_1 TO li_dxbdcdata. "appending OKCODE

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-fnam = 'BDC_OKCODE'.
    lst_bdcdata_230_1-fval = '=PVER'.
    APPEND  lst_bdcdata_230_1 TO li_dxbdcdata. "appending OKCODE

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-program = 'SAPLV45W'.
    lst_bdcdata_230_1-dynpro = '4001'.
    lst_bdcdata_230_1-dynbegin = 'X'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata. " Appending Screen

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-fnam = 'VEDA-VBEGDAT'.
    lst_bdcdata_230_1-fval = lv_begdt.
    APPEND  lst_bdcdata_230_1 TO li_dxbdcdata. " Appending Contract Start Date

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-fnam = 'VEDA-VENDDAT'.
    lst_bdcdata_230_1-fval = lv_enddt.
    APPEND  lst_bdcdata_230_1 TO li_dxbdcdata. " Appending Contract End Date

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-fnam = 'VEDA-VDEMDAT'.
    lst_bdcdata_230_1-fval = lv_demdt.
    APPEND  lst_bdcdata_230_1 TO li_dxbdcdata. " Appending Contract End Date

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-fnam = 'BDC_OKCODE'.
    lst_bdcdata_230_1-fval = '/EBACK'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata.

    CLEAR lst_bdcdata_230_1.
    lst_bdcdata_230_1-program = 'SAPMV45A'.
    lst_bdcdata_230_1-dynpro = '4001'.
    lst_bdcdata_230_1-dynbegin = 'X'.
    APPEND lst_bdcdata_230_1 TO li_dxbdcdata.

    lv_tabx = lv_tabx + 1.
    INSERT LINES OF li_dxbdcdata INTO  dxbdcdata INDEX lv_tabx.
    lv_line2 = abap_true.
    FREE:li_dxbdcdata.
  ENDIF.
ENDLOOP.
