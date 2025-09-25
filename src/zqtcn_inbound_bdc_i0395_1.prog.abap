*---------------------------------------------------------------------*
*PROGRAM NAME : ZQTCN_INBOUND_BDC_I0395_1 (Include Program)           *
*REVISION NO :  ED2K919818/ED2K922737                                 *
*REFERENCE NO: OTCM-28269                                             *
*DEVELOPER  :  Lahiru Wathudura (LWATHUDURA)                          *
*WRICEF ID  :  I0395.1                                                *
*DATE       :  01/14/2021                                             *
*DESCRIPTION:  Change Order cancellation Process                      *
*---------------------------------------------------------------------*


DATA: lst_bdcdata_z27_i0395_1   LIKE LINE OF  dxbdcdata,
      li_dxbdcdata_z27_i0395_1  TYPE STANDARD TABLE OF bdcdata,
      lst_dxbdcdata_z27_i0395_1 TYPE bdcdata,
      lv_tabx_z27_i0395_1       TYPE sy-tabix,
      lst_e1edp01_z27_i0395_1   TYPE e1edp01,
      lst_ze1edp01_z27_i0395_1  TYPE z1qtc_e1edp01_01,
      lst_edid4_z27_i0395_1     TYPE edidd,
      lst_cdata_z27_i0395_1     TYPE char30 VALUE '(SAPLVEDB)IDOC_CONTRL',
      lst_e1edk01_z27_i0395_1   TYPE e1edk01.

FIELD-SYMBOLS : <lfs_cdata_z27_i0395_1> TYPE edidc.

STATICS: lv_flag_z27_i0395_1   TYPE char1,
         lv_docnum_z27_i0395_1 TYPE edi_docnum.

DATA : lv_vkuesch_i0395_1    TYPE vkues_veda,   " Cancellatinon procedure
       lv_vkuegru_i0395_1    TYPE vkgru_veda,   " cancellation reason
       lv_itmno_z27_i0395_1  TYPE uepos,        " Item number position
       lv_selkz6_z27_i0395_1 TYPE char22,       " Selection line
       lv_pos_z27_i0395_1    TYPE char3,        " Position
       lv_vwundat            TYPE char10,       " Req.cancellat.date
       lv_vbedkue            TYPE char10,       " Date of canc.doc.
       lv_veindat            TYPE char10,       " Receipt of canc.
       lv_vbeln_z27_i0395_1  TYPE vbeln_va.     " Sales document number

DATA : lv_mbnlr_z27_i0395_1 TYPE char22.       " Selection line
DATA : lv_count             TYPE char3,
       lv_cancellation_date TYPE char10,
       lv_tmp_index         TYPE i.

CONSTANTS : lc_devid   TYPE zdevid     VALUE 'I0395.1',    " WRICEF ID
            lc_vkuesch TYPE rvari_vnam VALUE 'VKUESCH',    " Cancellation Procedure
            lc_vkuegru TYPE rvari_vnam VALUE 'VKUEGRU'.    " REason for Cancellation

*---Static Variable clearing based on DOCNUM field (IDOC Number).
READ TABLE didoc_data ASSIGNING FIELD-SYMBOL(<lfs_edidd_i0395_1>) INDEX 1.
IF sy-subrc = 0.
  IF lv_docnum_z27_i0395_1 NE <lfs_edidd_i0395_1>-docnum.
    FREE : lv_flag_z27_i0395_1, lv_docnum_z27_i0395_1.
    lv_docnum_z27_i0395_1  = <lfs_edidd_i0395_1>-docnum.
  ENDIF.
ENDIF.

FREE : li_dxbdcdata_z27_i0395_1[].
DESCRIBE TABLE dxbdcdata LINES lv_tabx_z27_i0395_1.

* Read IDoc Control data.
ASSIGN (lst_cdata_z27_i0395_1) TO <lfs_cdata_z27_i0395_1>.

* Read Idoc creation date as a cancellatino date.
CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
  EXPORTING
    input  = <lfs_cdata_z27_i0395_1>-credat
  IMPORTING
    output = lv_cancellation_date.

* Add BDC part before SAVE
READ TABLE dxbdcdata INTO lst_dxbdcdata_z27_i0395_1  WITH KEY fnam = 'BDC_OKCODE' fval = 'SICH'.
IF  sy-subrc EQ 0  AND lv_flag_z27_i0395_1 IS INITIAL .

  lv_tabx_z27_i0395_1 = sy-tabix.
  CLEAR:lst_edid4_z27_i0395_1.

  DATA(li_idoc_data_tmp) = didoc_data[].
* Build BDC for line Item wise in IDOC
  CLEAR:lst_edid4_z27_i0395_1 , lv_count.
  LOOP AT didoc_data INTO lst_edid4_z27_i0395_1 WHERE segnam = 'E1EDP01'.
    CLEAR:lst_e1edp01_z27_i0395_1 , lv_tmp_index.
    lst_e1edp01_z27_i0395_1 = lst_edid4_z27_i0395_1-sdata.

    " Read Custom segment for addtional fields
    READ TABLE li_idoc_data_tmp ASSIGNING FIELD-SYMBOL(<lfs_zp01_z27_i0395_1>) WITH KEY segnam = 'Z1QTC_E1EDP01_01'.
    IF sy-subrc EQ 0.
      lv_tmp_index = sy-tabix.      " Assign current index od Idoc data table
      lst_ze1edp01_z27_i0395_1  = <lfs_zp01_z27_i0395_1>-sdata.

      DELETE li_idoc_data_tmp INDEX lv_tmp_index.     " delete the current index

      IF lst_ze1edp01_z27_i0395_1-vkuesch IS NOT INITIAL.    " Cancellation procedure
        lv_vkuesch_i0395_1 = lst_ze1edp01_z27_i0395_1-vkuesch.
      ENDIF.
      IF lst_ze1edp01_z27_i0395_1-vkuegru IS NOT INITIAL.    " Reason for Cancellation
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lst_ze1edp01_z27_i0395_1-vkuegru
          IMPORTING
            output = lv_vkuegru_i0395_1.
      ENDIF.
      IF lst_ze1edp01_z27_i0395_1-vwundat IS NOT INITIAL.    " Requested cancellation date
        CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
          EXPORTING
            input  = lst_ze1edp01_z27_i0395_1-vwundat
          IMPORTING
            output = lv_vwundat.
      ENDIF.
      IF lst_ze1edp01_z27_i0395_1-veindat IS NOT INITIAL..   " Receipt of Cancellation
        CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
          EXPORTING
            input  = lst_ze1edp01_z27_i0395_1-veindat
          IMPORTING
            output = lv_veindat.
      ENDIF.
    ENDIF.

    lv_itmno_z27_i0395_1 = lst_e1edp01_z27_i0395_1-posex.    " " Line item
    lv_pos_z27_i0395_1 = '1'.
    CONDENSE lv_pos_z27_i0395_1.

* Go to ITEM position in Item screen
    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-program = 'SAPMV45A'.
    lst_bdcdata_z27_i0395_1-dynpro = '4001'.
    lst_bdcdata_z27_i0395_1-dynbegin = 'X'.
    APPEND lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-fnam = 'BDC_OKCODE'.
    lst_bdcdata_z27_i0395_1-fval = 'POPO'.
    APPEND lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-program = 'SAPMV45A'.
    lst_bdcdata_z27_i0395_1-dynpro = '0251'.
    lst_bdcdata_z27_i0395_1-dynbegin = 'X'.
    APPEND lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CONCATENATE 'RV45A-VBAP_SELKZ(' lv_pos_z27_i0395_1 ')' INTO lv_selkz6_z27_i0395_1.
    CONDENSE lv_selkz6_z27_i0395_1 NO-GAPS.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-fnam = 'RV45A-POSNR'.
    lst_bdcdata_z27_i0395_1-fval = lv_itmno_z27_i0395_1.    " line item
    APPEND  lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-fnam = 'BDC_OKCODE'.
    lst_bdcdata_z27_i0395_1-fval = 'POSI'.
    APPEND  lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-program = 'SAPMV45A'.
    lst_bdcdata_z27_i0395_1-dynpro = '4001'.
    lst_bdcdata_z27_i0395_1-dynbegin = 'X'.
    APPEND lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-fnam = lv_selkz6_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-fval = 'X'.
    APPEND  lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    " prepare selection row
    lv_count = lv_count + 1.
    CONDENSE lv_count.

    CONCATENATE 'RV45A-MABNR(' lv_count ')' INTO lv_mbnlr_z27_i0395_1.
    CONDENSE lv_mbnlr_z27_i0395_1 NO-GAPS.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-fnam = 'BDC_CURSOR'.
    lst_bdcdata_z27_i0395_1-fval = lv_mbnlr_z27_i0395_1.
    APPEND  lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-fnam = 'BDC_OKCODE'.
    lst_bdcdata_z27_i0395_1-fval = 'ITEM'.
    APPEND  lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-program = 'SAPMV45A'.
    lst_bdcdata_z27_i0395_1-dynpro = '4003'.
    lst_bdcdata_z27_i0395_1-dynbegin = 'X'.
    APPEND lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-fnam = 'BDC_OKCODE'.
    lst_bdcdata_z27_i0395_1-fval = 'T\03'.
    APPEND  lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-program = 'SAPLV45W'.
    lst_bdcdata_z27_i0395_1-dynpro = '4001'.
    lst_bdcdata_z27_i0395_1-dynbegin = 'X'.
    APPEND lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.                          " Cancellation proced
    lst_bdcdata_z27_i0395_1-fnam = 'VEDA-VKUESCH'.
    lst_bdcdata_z27_i0395_1-fval = lv_vkuesch_i0395_1.
    APPEND  lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-fnam = 'VEDA-VKUEGRU'.          " Reason for Cancellation
    lst_bdcdata_z27_i0395_1-fval = lv_vkuegru_i0395_1.
    APPEND  lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.


    CLEAR lst_bdcdata_z27_i0395_1.                            " Receipt of Cancellation
    lst_bdcdata_z27_i0395_1-fnam = 'VEDA-VEINDAT'.
    lst_bdcdata_z27_i0395_1-fval = lv_veindat.
    APPEND  lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.                            " Requested cancellation date
    lst_bdcdata_z27_i0395_1-fnam = 'VEDA-VWUNDAT'.
    lst_bdcdata_z27_i0395_1-fval = lv_vwundat.
    APPEND  lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-fnam = 'VEDA-VBEDKUE'.            " Date of cancellation doc
    lst_bdcdata_z27_i0395_1-fval = lv_cancellation_date.
    APPEND  lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-fnam = 'BDC_OKCODE'.
    lst_bdcdata_z27_i0395_1-fval = 'T\01'.
    APPEND lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-program = 'SAPMV45A'.
    lst_bdcdata_z27_i0395_1-dynpro = '4003'.
    lst_bdcdata_z27_i0395_1-dynbegin = 'X'.
    APPEND lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-fnam = 'BDC_OKCODE'.
    lst_bdcdata_z27_i0395_1-fval = '/EBACK'.
    APPEND lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

    CLEAR lst_bdcdata_z27_i0395_1.
    lst_bdcdata_z27_i0395_1-program = 'SAPMV45A'.
    lst_bdcdata_z27_i0395_1-dynpro = '4001'.
    lst_bdcdata_z27_i0395_1-dynbegin = 'X'.
    APPEND lst_bdcdata_z27_i0395_1 TO li_dxbdcdata_z27_i0395_1.

  ENDLOOP.

  lv_tabx_z27_i0395_1 = lv_tabx_z27_i0395_1.
  INSERT LINES OF li_dxbdcdata_z27_i0395_1 INTO  dxbdcdata INDEX lv_tabx_z27_i0395_1.
  FREE:li_dxbdcdata_z27_i0395_1.

  lv_flag_z27_i0395_1 = abap_true.

ENDIF.
