*&--------------------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_DELIV_OUT_I0508                                   *
*&--------------------------------------------------------------------------------*
*---------------------------------------------------------------------------------*
* PROGRAM NAME        : ZXTRKU02 (Enhancement Implementation)                     *
* PROGRAM DESCRIPTION :Doc Currency field and  will be mapped to custom segment   *
*                      No of Delivery items mapped to E1EDI24-POSEX when sending  *
*                      Outbound Deliveries to EDC(WMS)                            *
* DEVELOPER           : SISIREDDY                                                 *
* CREATION DATE       : 04/13/2022                                                *
* OBJECT ID           : I0508/EAM-7071                                            *
* TRANSPORT NUMBER(S) :  ED2K926343                                               *
*---------------------------------------------------------------------------------*
*Structures and Internal Tables
DATA:lst_z1qtc_e1edl21_01_i0508 TYPE z1qtc_e1edl21_01,
     lst_e1edl20_i0508          TYPE e1edl20,
     lst_e1edl24_i0508          TYPE e1edl24,
     lis_data_control           TYPE bapidlvbuffercontrol,
     lir_vbeln_i0508            TYPE RANGE OF bapidlv_range_vbeln,
     lis_vbeln_i0508            TYPE bapidlv_range_vbeln,
     lv_vbeln_i0508             TYPE vbeln,
     li_delivery_item           TYPE STANDARD TABLE OF  bapidlvitem INITIAL SIZE 0.
STATICS:lv_no_lines             TYPE i.
*Constants
CONSTANTS:lc_h04_i0508              TYPE edi_hlevel VALUE '04',                 "Hierarchy level
          lc_e1edl20_i0508          TYPE edilsegtyp VALUE 'E1EDL20',            "Segment type
          lc_e1edl24_i0508          TYPE edilsegtyp VALUE 'E1EDL24',            "Segment type
          lc_z1qtc_e1edl21_01_i0508 TYPE edilsegtyp VALUE 'Z1QTC_E1EDL21_01',   "Segment type
          lc_e1edl21_i0508          TYPE edilsegtyp VALUE 'E1EDL21',            "Segment type
          lc_vbtyp_j                TYPE vbtyp_n    VALUE 'J',                  "Document category of subsequent document
          lc_vbtyp_c                TYPE vbtyp_v    VALUE 'C',                  "Document category of preceding SD document
          lc_constant_i_i0508       TYPE char1      VALUE 'I',                  " Sign
          lc_constant_eq_i0508      TYPE char2      VALUE 'EQ'.                 " Option
*Read the custom segment
READ TABLE idoc_data[] INTO DATA(lst_idocdata_i0508) WITH KEY segnam =  lc_z1qtc_e1edl21_01_i0508.
IF sy-subrc EQ 0.
  DATA(lv_tabix_i0508) = sy-tabix.
  lst_z1qtc_e1edl21_01_i0508 = lst_idocdata_i0508-sdata.
  IF lst_z1qtc_e1edl21_01_i0508-waerk IS INITIAL.
    READ TABLE idoc_data[] INTO lst_idocdata_i0508 WITH KEY segnam =  lc_e1edl21_i0508.
    IF sy-subrc = 0.
*----Passing the EDI Invoice number to Custom segement for delivery
      READ TABLE idoc_data[] INTO lst_idocdata_i0508 WITH KEY segnam = lc_e1edl20_i0508.
      IF sy-subrc = 0.
        lst_e1edl20_i0508 = lst_idocdata_i0508-sdata.
      ENDIF.
* Passing th Sales Document Currency to custom segment field Z1QTC_E1EDL21_01_i0508-WAERK
      IF lst_e1edl20_i0508-vbeln IS NOT INITIAL.
        SELECT SINGLE waerk
        INTO @DATA(lv_waerk_i0508)
        FROM likp
        WHERE vbeln   = @lst_e1edl20_i0508-vbeln.
        IF sy-subrc EQ 0.
          lst_z1qtc_e1edl21_01_i0508-waerk = lv_waerk_i0508.
        ENDIF.
        CLEAR :lst_idoc_data .
        IF  lst_z1qtc_e1edl21_01_i0508 IS NOT INITIAL.
          lst_idoc_data-hlevel =  lc_h04_i0508.
          lst_idoc_data-segnam =  lc_z1qtc_e1edl21_01_i0508.
          lst_idoc_data-sdata  =  lst_z1qtc_e1edl21_01_i0508.
          MODIFY idoc_data[] FROM lst_idoc_data INDEX lv_tabix_i0508.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ELSE.
  READ TABLE idoc_data[] INTO lst_idocdata_i0508 WITH KEY segnam = lc_e1edl21_i0508.
  IF sy-subrc = 0.
*Read the Delivery header Segment
    READ TABLE idoc_data[] INTO lst_idocdata_i0508 WITH KEY segnam = lc_e1edl20_i0508.
    IF sy-subrc = 0.
      lst_e1edl20_i0508 = lst_idocdata_i0508-sdata.
    ENDIF.
    IF lst_e1edl20_i0508-vbeln IS NOT INITIAL.
      CLEAR :lst_z1qtc_e1edl21_01_i0508,
             lst_idoc_data.
      SELECT SINGLE waerk
       INTO @lv_waerk_i0508
       FROM likp
       WHERE vbeln   = @lst_e1edl20_i0508-vbeln.
      IF sy-subrc EQ 0.
        lst_z1qtc_e1edl21_01_i0508-waerk = lv_waerk_i0508.
      ENDIF.
      IF lst_z1qtc_e1edl21_01_i0508 IS NOT INITIAL.
        lst_idoc_data-hlevel = lc_h04_i0508.
        lst_idoc_data-segnam = lc_z1qtc_e1edl21_01_i0508.
        lst_idoc_data-sdata  = lst_z1qtc_e1edl21_01_i0508.
        APPEND lst_idoc_data TO idoc_data[].
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
LOOP AT idoc_data[] INTO lst_idocdata_i0508 WHERE segnam =  lc_e1edl24_i0508.
  lv_tabix_i0508 = sy-tabix.
  lst_e1edl24_i0508 = lst_idocdata_i0508-sdata.
* Passing the EDI Invoice number to Custom segement for delivery
  READ TABLE idoc_data[] INTO DATA(lst_idocdata_i0508_20) WITH KEY segnam = lc_e1edl20_i0508.
  IF sy-subrc = 0.
    DATA(lv_htabix_i0508) = sy-tabix.
    lst_e1edl20_i0508 = lst_idocdata_i0508_20-sdata.
  ENDIF.
  IF lst_e1edl20_i0508-vbeln IS NOT INITIAL.
    lv_vbeln_i0508 = lst_e1edl20_i0508-vbeln.
*Remove the Leading zeros for Delivery number when Sending to EDC(WMS)
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = lst_e1edl20_i0508-vbeln
      IMPORTING
        output = lst_e1edl20_i0508-vbeln.
    lst_idocdata_i0508_20-sdata  =  lst_e1edl20_i0508.
    MODIFY idoc_data[] FROM lst_idocdata_i0508_20 INDEX lv_htabix_i0508.
    lis_data_control-item             = abap_true.
    lis_vbeln_i0508-sign              = lc_constant_i_i0508.
    lis_vbeln_i0508-option            = lc_constant_eq_i0508.
    lis_vbeln_i0508-deliv_numb_low    = lv_vbeln_i0508.
    APPEND lis_vbeln_i0508 TO lir_vbeln_i0508.
    CLEAR:lis_vbeln_i0508.
    IF lv_no_lines IS  INITIAL.
*No of Delivery Items should be updated to IDOC field E1EDL24-POSEX at Item leavel
      CALL FUNCTION 'BAPI_DELIVERY_GETLIST'
        EXPORTING
          is_dlv_data_control = lis_data_control
        TABLES
          it_vbeln            = lir_vbeln_i0508
          et_delivery_item    = li_delivery_item.
      IF sy-subrc EQ 0.
        DESCRIBE TABLE li_delivery_item LINES DATA(lv_lines).
        lst_e1edl24_i0508-posex  = lv_lines.
        lv_no_lines              = lv_lines.
      ENDIF.
    ELSE.
      lst_e1edl24_i0508-posex  = lv_no_lines.
    ENDIF.
    CONDENSE lst_e1edl24_i0508-posex.
    lst_idocdata_i0508-sdata = lst_e1edl24_i0508.
    MODIFY idoc_data[] FROM lst_idocdata_i0508 INDEX lv_tabix_i0508.
  ENDIF.
ENDLOOP.
