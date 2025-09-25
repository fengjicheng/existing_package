*&---------------------------------------------------------------------*
*&  Include           ZQTCN_BP_VALIDATION_I0200
*&---------------------------------------------------------------------*
* INCLUDE NAME: ZQTCN_BP_VALIDATION_I0200
*               Called from BDT event FM: ZQTC_BUP0ID_EVENT_DCHCK_E165
* REVISION NO: ED2K921317
* REFERENCE NO: FMM406
* DEVELOPER:MIMMADISET
* DATE: 01/19/2021
* DESCRIPTION:Validation for KATR9 field
*----------------------------------------------------------------------*
CONSTANTS:lc_kna1       TYPE fsbp_table_name VALUE 'KNA1',
          lc_knb1       TYPE fsbp_table_name VALUE 'KNB1',
          lc_msgno1_064 TYPE syst_msgno VALUE '064',
          lc_msg1_id    TYPE sy-msgid   VALUE 'ZRTR_R1',                    " Message Class
          lc_msg1_typ_e TYPE sy-msgty   VALUE 'E'.                        " Message Type: E

DATA: lt_kna1 TYPE STANDARD TABLE OF kna1,
      lt_knb1 TYPE STANDARD TABLE OF knb1.

FREE:lt_kna1[],lt_knb1[].

cvi_bdt_adapter=>get_current_bp_data(
  EXPORTING
    i_table_name = lc_kna1
  IMPORTING
    e_data_table = lt_kna1[]
).

IF lt_kna1 IS NOT INITIAL.
  READ TABLE lt_kna1 INTO DATA(ls_kna1) INDEX 1.
  IF sy-subrc = 0 AND ls_kna1-katr9 IS NOT INITIAL.
    cvi_bdt_adapter=>get_current_bp_data(
     EXPORTING
       i_table_name = lc_knb1
     IMPORTING
       e_data_table = lt_knb1[]
     ).
    DESCRIBE TABLE lt_knb1 LINES DATA(lv_count).
    READ TABLE lt_knb1 INTO DATA(ls_knb1) INDEX lv_count.
    IF sy-subrc = 0 AND ls_knb1-bukrs IS NOT INITIAL.
      SELECT SINGLE * FROM zrtr_mko_crgrp
        INTO @DATA(ls_mko) WHERE bukrs = @ls_knb1-bukrs
        AND mko = @ls_kna1-katr9.
      IF sy-subrc NE 0.
        CALL FUNCTION 'BUS_MESSAGE_STORE'
          EXPORTING
            arbgb = lc_msg1_id
            msgty = lc_msg1_typ_e
            txtnr = lc_msgno1_064
            msgv1 = ls_kna1-katr9.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
