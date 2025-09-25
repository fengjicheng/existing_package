*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_DELIV_OUT_I0381
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZXTRKU02 (Enhancement Implementation)
* PROGRAM DESCRIPTION : Include for segment population Outbound IDOC for delivery
* DEVELOPER           : VDPATABALL
* CREATION DATE       : 05/14/2020
* OBJECT ID           : I0381
* TRANSPORT NUMBER(S) : ED2K918194
*----------------------------------------------------------------------*
* PROGRAM NAME        : ZXTRKU02 (Enhancement Implementation)
* PROGRAM DESCRIPTION : Adding two email IDs from Contact person and repeat the
*                       shipto Segment two times only
* DEVELOPER           : VDPATABALL
* CREATION DATE       : 08/25/2020
* OBJECT ID           : I0381/OTCM-26131
* TRANSPORT NUMBER(S) : ED2K919274
*----------------------------------------------------------------------*
DATA:lst_z1qtc_e1edl21_01 TYPE z1qtc_e1edl21_01,
     lst_e1adrm1          TYPE e1adrm1,
     lst_e1edl20          TYPE e1edl20,
     lst_e1adrm1_ag       TYPE e1adrm1,
     lst_idoc_data        TYPE edidd.
STATICS:lv_count TYPE i,
        lv_flag  TYPE char1.

CONSTANTS:lc_h04              TYPE edi_hlevel VALUE '04',               "Hierarchy level
          lc_e1edl20          TYPE edilsegtyp VALUE 'E1EDL20', "Segment type
          lc_z1qtc_e1edl21_01 TYPE edilsegtyp VALUE 'Z1QTC_E1EDL21_01', "Segment type
          lc_e1edl21          TYPE edilsegtyp VALUE 'E1EDL21',           "Segment type
          lc_e1adrm1          TYPE edilsegtyp VALUE 'E1ADRM1',           "Segment type
          lc_we               TYPE parvw      VALUE 'WE'.

READ TABLE idoc_data[] INTO DATA(lst_idocdata) WITH KEY segnam = lc_z1qtc_e1edl21_01.
IF sy-subrc NE 0.
  READ TABLE idoc_data[] INTO lst_idocdata WITH KEY segnam = lc_e1edl21.
  IF sy-subrc = 0.
*----Passing the CO_name to Custom segement for delivery
    READ TABLE idoc_data[] INTO lst_idocdata WITH KEY segnam = lc_e1edl20.
    IF sy-subrc = 0.
      lst_e1edl20 = lst_idocdata-sdata.
    ENDIF.
    IF lst_e1edl20-vbeln IS NOT INITIAL.
      SELECT SINGLE adrnr FROM vbpa INTO @DATA(lv_adrnr) WHERE vbeln = @lst_e1edl20-vbeln AND parvw = @lc_we.
      IF lv_adrnr IS NOT INITIAL.
        SELECT SINGLE name_co FROM adrc INTO @DATA(lv_co_name) WHERE addrnumber = @lv_adrnr.
      ENDIF.
      CLEAR :lst_z1qtc_e1edl21_01,lst_idoc_data .
      lst_z1qtc_e1edl21_01-c_o_name = lv_co_name.
      IF lst_z1qtc_e1edl21_01 IS NOT INITIAL.
        lst_idoc_data-hlevel = lc_h04.
        lst_idoc_data-segnam = lc_z1qtc_e1edl21_01.
        lst_idoc_data-sdata = lst_z1qtc_e1edl21_01.
        APPEND lst_idoc_data TO idoc_data[].
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.

*---Begin of change VDPATABALL 08/25/2020 I0381 ED2K919274 OTCM-26131
*----Pass the Contact Email to Ship to and Repaeat same segment to other email ID.
IF lv_flag = abap_false.

  LOOP AT idoc_data[] INTO lst_idocdata WHERE segnam = lc_e1adrm1.
    lst_e1adrm1 = lst_idocdata-sdata.
    IF lst_e1adrm1-partner_q = lc_we AND lv_count = 0.
      DATA(lv_tabix) = sy-tabix.
      READ TABLE idoc_data[] INTO lst_idoc_data WITH KEY segnam = lc_e1adrm1.
      IF sy-subrc = 0.
        lst_e1adrm1_ag = lst_idoc_data-sdata.
      ENDIF.
      SELECT SINGLE prsnr FROM knvk INTO @DATA(lv_prsnr) WHERE kunnr = @lst_e1adrm1_ag-partner_id.
      IF sy-subrc = 0.
        SELECT smtp_addr FROM adr6 INTO TABLE @DATA(li_adr6) WHERE persnumber = @lv_prsnr.
        IF sy-subrc = 0.
          FREE:lv_count.
          LOOP AT li_adr6 INTO DATA(lst_adr6).
            lv_count = lv_count + 1.
            IF lv_count = 1.
              lst_e1adrm1-e_mail = lst_adr6-smtp_addr.
              lst_idocdata-sdata = lst_e1adrm1.
              MODIFY  idoc_data[] FROM lst_idocdata INDEX lv_tabix.
            ENDIF.
            IF lv_count = 2.
              lv_tabix = lv_tabix + 1.
              lst_e1adrm1-e_mail = lst_adr6-smtp_addr.
              lst_idocdata-sdata = lst_e1adrm1.
              INSERT lst_idocdata INTO idoc_data[] INDEX lv_tabix.
            ENDIF.
          ENDLOOP.
          lv_flag = abap_true.
        ENDIF.
      ELSE.
        lv_flag = abap_true.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDIF.
*---End of change VDPATABALL 08/25/2020 I0381 ED2K919274 OTCM-26131
