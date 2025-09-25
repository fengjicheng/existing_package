*---------------------------------------------------------------------*
*PROGRAM NAME :  ZQTCN_SEGMENT_FILL_I0229_8(Include Program)           *
*REVISION NO :   ED2K921759/ED2K921925                                           *
*REFERENCE NO:   OTCM-1375                                             *
*DEVELOPER  :    Lahiru Wathudura (LWATHUDURA)                          *
*WRICEF ID  :    I0229                                                *
*DATE       :    01/26/2021                                             *
*DESCRIPTION:    Acceptance Date interface *
*---------------------------------------------------------------------*

DATA : lir_auart           TYPE rjksd_auart_range_tab,        " Range Doc type
       lv_lines_i0229_8    TYPE i,
       lst_e1edp01_i0229_8 TYPE e1edp01,
       lst_e1edp02_i0229_8 TYPE e1edp02.

CONSTANTS : lc_devid           TYPE zdevid     VALUE 'I0229',    " WRICEF ID
            lc_auart           TYPE rvari_vnam VALUE 'AUART',    " Order type
            lc_e1edp02_i0229_8 TYPE char16     VALUE 'E1EDP02', " Z1qtc_e1edp01_01 of type CHAR16
            lc_qualf_i0229_8   TYPE edi_qualfr VALUE '044'.

" Fecth constant values
SELECT devid,                      " Development ID
       param1,                     " ABAP: Name of Variant Variable
       param2 ,                    " ABAP: Name of Variant Variable
       srno,                       " Current selection number
       sign,                       " ABAP: ID: I/E (include/exclude values)
       opti,                       " ABAP: Selection option (EQ/BT/CP/...)
       low ,                       " Lower Value of Selection Condition
       high,                       " Upper Value of Selection Condition
       activate                    " Activation indicator for constant
   FROM zcaconstant                " Wiley Application Constant Table
   INTO TABLE @DATA(li_constant)
   WHERE devid    = @lc_devid        " WRICEF ID
   AND   activate = @abap_true.     " Only active record
IF sy-subrc IS INITIAL.
  SORT li_constant BY param1.
  LOOP AT li_constant ASSIGNING FIELD-SYMBOL(<lfs_constant>).
    CASE <lfs_constant>-param1.
      WHEN lc_auart.                            " Check order type
        APPEND INITIAL LINE TO lir_auart ASSIGNING FIELD-SYMBOL(<lfs_auart>).
        <lfs_auart>-sign = <lfs_constant>-sign.
        <lfs_auart>-option = <lfs_constant>-opti.
        <lfs_auart>-low =  <lfs_constant>-low.
        <lfs_auart>-high = <lfs_constant>-high.
    ENDCASE.
  ENDLOOP.
ENDIF.

" This is only for the CSS order type only
IF dxvbak-auart IN lir_auart .
* Describing IDOC Data Table
  DESCRIBE TABLE int_edidd LINES lv_lines_i0229_8.
* Reading last record of IDOC Data Table
  READ TABLE int_edidd INTO lst_edidd INDEX lv_lines_i0229_8.
  IF sy-subrc = 0.
* Checking segments and implementing required logic
    CASE lst_edidd-segnam.
      WHEN lc_e1edp02_i0229_8.                   " For Item general Data
        IF dxvbkd-bstkd_e IS INITIAL.   " Check whether Shipto PO is null
          lst_e1edp02_i0229_8-qualf = lc_qualf_i0229_8.
          lst_e1edp02_i0229_8-belnr = dxvbkd-bstkd_e.
          lst_e1edp02_i0229_8-zeile = dxvbkd-posex_e.
          lst_e1edp02_i0229_8-datum = dxvbkd-bstdk_e.
          lst_e1edp02_i0229_8-bsark = dxvbkd-bsark_e.
          lst_e1edp02_i0229_8-ihrez = dxvbkd-ihrez_e.

          lst_edidd-segnam = lc_e1edp02_i0229_8.           " Adding new segment
          lst_edidd-sdata =  lst_e1edp02_i0229_8.
          APPEND lst_edidd TO int_edidd.
        ENDIF.
    ENDCASE.
  ENDIF.
ENDIF.
