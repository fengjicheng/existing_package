*---------------------------------------------------------------------*
*PROGRAM NAME :  ZQTCN_SEGMENT_FILL_I0229_7(Include Program)          *
*REVISION NO :   ED2K921536 /ED2K921925                                          *
*REFERENCE NO:   OTCM-28269                                           *
*DEVELOPER  :    Lahiru Wathudura (LWATHUDURA)                        *
*WRICEF ID  :    I0229                                                *
*DATE       :    01/27/2021                                           *
*DESCRIPTION:    change for release order cancellation                *
*---------------------------------------------------------------------*

DATA : lst_e1edp01_i0229_7          TYPE e1edp01,           " IDoc: Document Item General Data
       lst_z1qtc_e1edp01_01_i0229_7 TYPE z1qtc_e1edp01_01,  " IDOC item extention
       lst_ztmp_e1edp01_01_i0229_7  TYPE z1qtc_e1edp01_01,
       lv_line_i0229_7              TYPE i,
       lv_tmp_index_i0229_7         TYPE i.

CONSTANTS : lc_z1qtc_e1edp01_01_i0229_7 TYPE char16 VALUE 'Z1QTC_E1EDP01_01'.

DESCRIBE TABLE int_edidd LINES lv_line_i0229_7.
*** Reading last record of IDOC Data Table
READ TABLE int_edidd INTO lst_edidd INDEX lv_line_i0229_7.
IF sy-subrc = 0.

* Checking segments and implementing required logic
  CLEAR : lst_z1qtc_e1edp01_01_i0229_7,
          lst_ztmp_e1edp01_01_i0229_7.
  CASE lst_edidd-segnam.
    WHEN 'Z1QTC_E1EDP01_01'. " Line item extention data
      lst_z1qtc_e1edp01_01_i0229_7 = lst_edidd-sdata.
      lst_ztmp_e1edp01_01_i0229_7  = lst_edidd-sdata.

* Fecth data from VEDA
      SELECT SINGLE vbeln,   " Sales Document
                    vposn,   " Sales Document Item
                    vkuesch, " Assignment cancellation procedure/cancellation rule
                    veindat, " Date on which cancellation request was received
                    vwundat  " Requested cancellation date
        FROM veda
        INTO @DATA(lst_veda_i0229_7)
        WHERE vbeln = @dxvbap-vbeln
        AND vposn = @dxvbap-posnr.
      IF sy-subrc = 0.
        lst_z1qtc_e1edp01_01_i0229_7-vkuesch = lst_veda_i0229_7-vkuesch.    " Cancellation Procedure
        lst_z1qtc_e1edp01_01_i0229_7-veindat = lst_veda_i0229_7-veindat.    " Receipt of canc.
        lst_z1qtc_e1edp01_01_i0229_7-vwundat = lst_veda_i0229_7-vwundat.    " Requested cancellation date

        lst_edidd-sdata  = lst_z1qtc_e1edp01_01_i0229_7.

        CLEAR lv_tmp_index_i0229_7.
        READ TABLE int_edidd TRANSPORTING NO FIELDS WITH KEY segnam = lc_z1qtc_e1edp01_01_i0229_7
                                                             sdata  = lst_ztmp_e1edp01_01_i0229_7.
        IF sy-subrc = 0.
          lv_tmp_index_i0229_7 = sy-tabix.
          MODIFY int_edidd FROM lst_edidd INDEX lv_tmp_index_i0229_7 TRANSPORTING sdata.
        ENDIF.
      ENDIF.
  ENDCASE.
ENDIF.
