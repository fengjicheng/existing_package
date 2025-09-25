*&---------------------------------------------------------------------*
*& Report  ZQTC_ALV_POC
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zqtc_alv_poc.
TYPE-POOLS: slis.
TABLES: zqtc_contr_sub.

DATA: li_tab  TYPE STANDARD TABLE OF zqtc_contr_sub,
      lst_tab TYPE zqtc_contr_sub.

DATA: it_sort   TYPE slis_t_sortinfo_alv,
      wa_sort   LIKE LINE OF it_sort,
      it_fcat   TYPE slis_t_fieldcat_alv,
      wa_fcat   LIKE LINE OF it_fcat,
      ws_layout TYPE slis_layout_alv.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_vbeln FOR zqtc_contr_sub-vbeln.
SELECT-OPTIONS: s_kunnr FOR zqtc_contr_sub-kunnr.
SELECTION-SCREEN: END OF BLOCK b1.

INCLUDE zqtc_alv_poc_sub.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM fieldcat.
  PERFORM sort_data.

END-OF-SELECTION.
*  ws_layout-colwidth_optimize = 'X'.
  PERFORM display_data.
