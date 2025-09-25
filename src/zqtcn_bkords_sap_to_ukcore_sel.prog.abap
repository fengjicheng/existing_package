*----------------------------------------------------------------------*
* PROGRAM NAME:ZQTCN_BKORDS_SAP_TO_UKCORE_SEL (Include Program)        *
* PROGRAM DESCRIPTION:To send Back Orders to UK Core                   *
* DEVELOPER:Sivarami Reddy (SISIREDDY)                                 *
* CREATION DATE:   01/05/2022                                          *
* OBJECT ID:  I0516                                                    *
* TRANSPORT NUMBER(S): ED2K903953                                      *
*----------------------------------------------------------------------*
************************************************************************
*    Selection Criteria                                                *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b4.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-000.
SELECT-OPTIONS : s_werks FOR v_werks OBLIGATORY DEFAULT c_werks_default NO INTERVALS.
SELECT-OPTIONS : s_mtart FOR v_mtart OBLIGATORY DEFAULT c_mtart_default NO INTERVALS.
SELECT-OPTIONS : s_matnr FOR v_matnr.
SELECT-OPTIONS : s_erdat FOR v_erdat OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-001.
PARAMETERS:ch_pos AS CHECKBOX DEFAULT abap_true.
SELECT-OPTIONS : s_bsart FOR v_bsart DEFAULT c_bsart_default NO INTERVALS.
SELECT-OPTIONS : s_bukrs FOR v_bukrs DEFAULT c_bukrs_default NO INTERVALS.
SELECT-OPTIONS : s_ekorg FOR v_ekorg DEFAULT c_ekorg_default NO INTERVALS.
SELECT-OPTIONS : s_ekgrp FOR v_ekgrp DEFAULT c_ekgrp_default NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-002.
PARAMETERS:ch_sos AS CHECKBOX DEFAULT abap_true.
SELECT-OPTIONS : s_auart FOR v_auart DEFAULT c_auart_default NO INTERVALS.
SELECT-OPTIONS : s_vkorg FOR v_vkorg DEFAULT c_vkorg_default NO INTERVALS.
SELECT-OPTIONS : s_vtweg FOR v_vtweg NO INTERVALS.
SELECT-OPTIONS : s_spart FOR v_spart NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b3.
SELECTION-SCREEN END OF BLOCK b4.

CLASS lcl_sel DEFINITION FINAL .
  PUBLIC SECTION .
    TYPES:ty_matnr TYPE RANGE OF matnr,
          ty_werks TYPE RANGE OF ewerk,
          ty_mtart TYPE RANGE OF mtart,
          ty_erdat TYPE RANGE OF erdat,
          ty_bsart TYPE RANGE OF bsart,
          ty_bukrs TYPE RANGE OF bukrs,
          ty_ekorg TYPE RANGE OF ekorg,
          ty_ekgrp TYPE RANGE OF ekgrp,
          ty_auart TYPE RANGE OF auart,
          ty_vkorg TYPE RANGE OF vkorg,
          ty_vtweg TYPE RANGE OF vtweg,
          ty_spart TYPE RANGE OF spart.

    DATA :s_werks TYPE ty_werks,
          s_matnr TYPE ty_matnr,
          s_mtart TYPE ty_mtart,
          s_erdat TYPE ty_erdat,
          s_bsart TYPE ty_bsart,
          s_bukrs TYPE ty_bukrs,
          s_ekorg TYPE ty_ekorg,
          s_ekgrp TYPE ty_ekgrp,
          s_auart TYPE ty_auart,
          s_vkorg TYPE ty_vkorg,
          s_vtweg TYPE ty_vtweg,
          s_spart TYPE ty_spart,
          ch_pos  TYPE char1,
          ch_sos  TYPE char1.

    METHODS : check_werks IMPORTING s_werks TYPE ty_werks.
    METHODS : check_mtart IMPORTING s_mtart TYPE ty_mtart.
    METHODS : check_matnr IMPORTING s_matnr TYPE ty_matnr.
    METHODS : check_erdat IMPORTING s_erdat TYPE ty_erdat.
    METHODS : check_docs  IMPORTING ch_pos TYPE char1 ch_sos  TYPE char1.
    METHODS : check_bukrs IMPORTING ch_pos TYPE char1 s_bukrs TYPE ty_bukrs.
    METHODS : check_ekorg IMPORTING ch_pos TYPE char1 s_ekorg TYPE ty_ekorg.
    METHODS : check_ekgrp IMPORTING ch_pos TYPE char1 s_ekgrp TYPE ty_ekgrp.
    METHODS : check_bsart IMPORTING ch_pos TYPE char1 s_bsart TYPE ty_bsart.
    METHODS : check_auart IMPORTING ch_sos TYPE char1 s_auart TYPE ty_auart.
    METHODS : check_vkorg IMPORTING ch_sos TYPE char1 s_vkorg TYPE ty_vkorg.
    METHODS : check_vtweg IMPORTING ch_sos TYPE char1 s_vtweg TYPE ty_vtweg.
    METHODS : check_spart IMPORTING ch_sos TYPE char1 s_spart TYPE ty_spart.

ENDCLASS .
*&---------------------------------------------------------------------*
*&       CLASS (IMPLEMENTATION)  SEL
*&---------------------------------------------------------------------*
*        TEXT
*----------------------------------------------------------------------*
CLASS lcl_sel IMPLEMENTATION.
  METHOD check_docs.
    IF  ch_pos IS INITIAL AND ch_sos IS INITIAL.
      MESSAGE 'Please select Sales Documents or Stock Transfer Docs'(031) TYPE c_e.
    ENDIF.
  ENDMETHOD.
  METHOD check_werks .
    IF s_werks[] IS NOT INITIAL .
      SELECT werks
       FROM t001w
       INTO TABLE @DATA(li_t001w)
       WHERE werks IN @s_werks.
      IF sy-subrc NE 0.
        MESSAGE 'Please enter valid Plant'(006) TYPE c_e.
      ENDIF.
    ENDIF .
  ENDMETHOD.
  METHOD check_mtart.
    IF s_mtart[] IS NOT INITIAL .
      SELECT mtart
       FROM t134
       INTO TABLE @DATA(li_t134)
       WHERE mtart IN @s_mtart.
      IF sy-subrc NE 0.
        MESSAGE 'Please enter valid Material Type'(009) TYPE c_e.
      ENDIF.
    ENDIF .
  ENDMETHOD.
  METHOD check_matnr.
    IF s_matnr[] IS NOT INITIAL .
      SELECT matnr
       FROM mara
       INTO TABLE @DATA(li_mara)
       WHERE matnr IN @s_matnr.
      IF sy-subrc NE 0.
        MESSAGE 'Please enter valid Material'(010) TYPE c_e.
      ENDIF.
    ENDIF .
  ENDMETHOD.
  METHOD check_erdat .
    IF s_erdat[] IS NOT INITIAL.
      READ TABLE s_erdat INTO DATA(ls_erdat) INDEX 1.
      DATA(lv_days) = ls_erdat-high - ls_erdat-low.
      IF lv_days GT 60.
        MESSAGE 'Creation Date range should not be more than 60 days'(018) TYPE c_e.
      ENDIF.
    ENDIF.
  ENDMETHOD.
  METHOD check_bukrs .
    IF s_bukrs[] IS INITIAL AND ch_pos IS NOT INITIAL.
      MESSAGE 'Company Code is mandatory to enter.'(020) TYPE c_e.
    ELSEIF s_bukrs IS NOT INITIAL AND ch_pos IS NOT INITIAL. .
      SELECT bukrs
       FROM  t001
       INTO TABLE @DATA(li_t001)
       WHERE bukrs IN @s_bukrs.
      IF sy-subrc NE 0.
        MESSAGE 'Please enter valid Company Code'(005) TYPE c_e.
      ENDIF.
    ENDIF .
  ENDMETHOD.
  METHOD check_ekorg.
    IF s_ekorg[] IS INITIAL AND ch_pos IS NOT INITIAL.
      MESSAGE 'Purchasing Org. is mandatory to enter.'(021) TYPE c_e.
    ELSEIF s_ekorg[] IS NOT INITIAL AND ch_pos IS NOT INITIAL. .
      SELECT ekorg
       FROM t024e
      INTO TABLE @DATA(li_t024e)
      WHERE ekorg IN @s_ekorg.
      IF sy-subrc NE 0.
        MESSAGE 'Please enter valid Purchasing Organization'(008) TYPE c_e.
      ENDIF.
    ENDIF .
  ENDMETHOD.
  METHOD check_ekgrp.
    IF s_ekgrp[] IS INITIAL AND ch_pos IS NOT INITIAL.
      MESSAGE 'Purchasing Group is mandatory to enter.'(022) TYPE c_e.
    ELSEIF s_ekgrp[] IS NOT INITIAL AND ch_pos IS NOT INITIAL. .
      SELECT ekgrp
       FROM t024
      INTO TABLE @DATA(li_t024)
      WHERE ekgrp IN @s_ekgrp.
      IF sy-subrc NE 0.
        MESSAGE 'Please enter valid Purchasing Group'(007) TYPE c_e.
      ENDIF.
    ENDIF .
  ENDMETHOD.
  METHOD check_bsart.
    IF s_bsart[] IS INITIAL AND ch_pos IS NOT INITIAL.
      MESSAGE 'Stock Transport Orders Type is mandatory to enter.'(023) TYPE c_e.
    ELSEIF s_bsart[] IS NOT INITIAL AND ch_pos IS NOT INITIAL. .
      SELECT bsart
       FROM t161
      INTO TABLE @DATA(li_t161)
      WHERE bsart IN @s_bsart.
      IF sy-subrc NE 0.
        MESSAGE 'Please enter valid Stock Transport Orders Type'(012) TYPE c_e.
      ENDIF.
    ENDIF .
  ENDMETHOD.
  METHOD check_auart.
    IF s_auart[] IS INITIAL AND ch_sos IS NOT INITIAL.
      MESSAGE 'Sales Document Type is mandatory to enter.'(024) TYPE c_e.
    ELSEIF s_auart[] IS NOT INITIAL AND ch_sos IS NOT INITIAL. .
      SELECT auart
       FROM tvak
      INTO TABLE @DATA(li_tvak)
      WHERE auart IN @s_auart.
      IF sy-subrc NE 0.
        MESSAGE 'Please enter valid Sales Document Type'(013) TYPE c_e.
      ENDIF.
    ENDIF .
  ENDMETHOD.
  METHOD check_vkorg.
    IF s_vkorg[] IS INITIAL AND ch_sos IS NOT INITIAL.
      MESSAGE 'Sales Org. is mandatory to enter.'(025) TYPE c_e.
    ELSEIF s_vkorg[] IS NOT INITIAL AND ch_sos IS NOT INITIAL. .
      SELECT vkorg
       FROM tvko
      INTO TABLE @DATA(li_tvko)
      WHERE vkorg IN @s_vkorg.
      IF sy-subrc NE 0.
        MESSAGE 'Please enter valid Sales Organization'(014) TYPE c_e.
      ENDIF.
    ENDIF .

  ENDMETHOD.
  METHOD check_vtweg.
    IF s_vtweg[] IS NOT INITIAL AND ch_sos IS NOT INITIAL. .
      SELECT vtweg
       FROM tvtw
      INTO TABLE @DATA(li_tvtw)
      WHERE vtweg IN @s_vtweg.
      IF sy-subrc NE 0.
        MESSAGE 'Please enter valid Distribution Channel'(015) TYPE c_e.
      ENDIF.
    ENDIF .
  ENDMETHOD.
  METHOD check_spart.
    IF s_spart[] IS NOT INITIAL AND ch_sos IS NOT INITIAL. .
      SELECT spart
       FROM tspa
      INTO TABLE @DATA(li_tspa)
      WHERE spart IN @s_spart.
      IF sy-subrc NE 0.
        MESSAGE 'Please enter valid Division'(016) TYPE c_e.
      ENDIF.
    ENDIF .
  ENDMETHOD.
ENDCLASS.               "SEL
