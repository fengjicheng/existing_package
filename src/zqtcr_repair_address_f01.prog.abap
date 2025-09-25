*----------------------------------------------------------------------*
* PROGRAM NAME:        ZQTCR_REPAIR_ADDRESS_F01
* PROGRAM DESCRIPTION: This report uses a sales document order as input.
*                      The incorrect addresses in the specified document
*                      will be set to the standard address coming from
*                      customer master data. It is possible to maintain/change
*                      such a document afterwards.
*                      This report has a testflag. Please test the report
*                      carefully with this flag before changing data.
*                      - per Note 2713240 (Z_REPAIR_ADRNR_1)
* DEVELOPER:           Nikhiesh Palla (NPALLA).
* CREATION DATE:       09/13/2019
* OBJECT ID:
* TRANSPORT NUMBER(S): ED1K910781
*----------------------------------------------------------------------*
* Revision History-----------------------------------------------------*
* Revision No:
* Reference No:
* Developer:
* Date:
* Description:
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select_data .

  DATA: li_vbpa_tmp TYPE STANDARD TABLE OF vbpa.

  SELECT * INTO TABLE i_vbpa FROM vbpa WHERE vbeln IN s_vbeln
                                   AND adrnr > c_adrnr. "9000000000
  IF sy-subrc NE 0.
    MESSAGE e174(zqtc_r2) DISPLAY LIKE 'S'.
  ELSE.
    li_vbpa_tmp[] = i_vbpa[].
    SORT li_vbpa_tmp BY adrnr.
    DELETE ADJACENT DUPLICATES FROM li_vbpa_tmp COMPARING adrnr.
    SELECT addrnumber
      INTO TABLE i_adrc
      FROM adrc
      FOR ALL ENTRIES IN li_vbpa_tmp
      WHERE addrnumber = li_vbpa_tmp-adrnr.

    li_vbpa_tmp[] = i_vbpa[].
    SORT li_vbpa_tmp BY kunnr.
    DELETE ADJACENT DUPLICATES FROM li_vbpa_tmp COMPARING kunnr.
    SELECT kunnr adrnr
      INTO TABLE i_kna1
      FROM kna1
      FOR ALL ENTRIES IN i_vbpa
      WHERE kunnr = i_vbpa-kunnr.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  UPDATE_ADDRESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM update_address .

* Update Address Details from KNA1 where the address does not exist.
  LOOP AT i_vbpa INTO st_vbpa.
    v_tabix = sy-tabix.
    READ TABLE i_adrc INTO st_adrc WITH KEY addrnumber = st_vbpa-adrnr.
    IF sy-subrc NE 0.
      READ TABLE i_kna1 INTO st_kna1 WITH KEY kunnr = st_vbpa-kunnr.
      IF sy-subrc = 0.
        MOVE st_kna1-adrnr TO st_vbpa-adrnr.
        MOVE 'D' TO st_vbpa-adrda.
        MODIFY i_vbpa FROM st_vbpa INDEX v_tabix.
      ENDIF.
    ELSE.
      DELETE i_vbpa INDEX v_tabix.
    ENDIF.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  OUTPUT_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM output_details .

  IF p_test IS INITIAL.
    UPDATE vbpa FROM TABLE i_vbpa.
    WRITE: / 'Address repaired'.
  ELSE.
    WRITE: / 'Test Mode - Address to repaired'.
  ENDIF.

  WRITE:/ 'List documents for new ADRNR'.
  WRITE:/ 'Document  ',  ' CustomerNumber  ',  ' Address', ' Function'.
  LOOP AT i_vbpa INTO st_vbpa.
    WRITE: / st_vbpa-vbeln, '  ',
             st_vbpa-kunnr, '  ',
             st_vbpa-adrnr, '  ',
             st_vbpa-parvw.
  ENDLOOP.

ENDFORM.
