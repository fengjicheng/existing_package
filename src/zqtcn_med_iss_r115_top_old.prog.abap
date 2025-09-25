*&---------------------------------------------------------------------*
*&  Include        ZQTCN_MED_ISS_OPT_R115_TOP_NEW
*&---------------------------------------------------------------------*
TABLES: zcds_mi_r115_rpt, vbak, vbrk, vbap, mara, marc, jksesched, lfa1, jkseflow, jksenip.

*&---------------------------------------------------------------------*
* ALV Declarations
*----------------------------------------------------------------------*
* Types Pools
TYPE-POOLS:
   slis.
* Types
TYPES:
  t_fieldcat TYPE slis_fieldcat_alv,
  t_layout   TYPE slis_layout_alv.

*Field Symbols
FIELD-SYMBOLS:
  <fs_view> TYPE zcds_mi_r115_rpt.

*DATA BEGIN OF it_sel_opt OCCURS 0.
*        INCLUDE STRUCTURE rsparams.
*DATA END   OF it_sel_opt.

* Workareas
DATA:
  w_fieldcat TYPE t_fieldcat,
  w_layout   TYPE t_layout,
  w_view     TYPE zcds_mi_r115_rpt.

* Internal Tables
DATA:
  i_fieldcat TYPE STANDARD TABLE OF t_fieldcat,
  i_view     TYPE STANDARD TABLE OF zcds_mi_r115_rpt,
  i_tline    TYPE STANDARD TABLE OF tline.


*DATA: v_month    TYPE fcmnr,
*      v_year     TYPE gjahr,
*      v_date     TYPE sy-datum,
*      v_fdate    TYPE sy-datum,
*      v_tdate    TYPE sy-datum,
*      v_tax      TYPE zcds_stax_final-tax_amount,
*      v_othertax TYPE zcds_stax_final-other_taxes.

* Variables
DATA:
  v_count(10) TYPE n,
  v_vbeln     TYPE vbak-vbeln.

TYPES: BEGIN OF ty_status,
         status TYPE zcds_mi_r115_rpt-bill_block_flag,
       END OF ty_status.
*--------------------------------------------------------------*
*Data Declaration
*--------------------------------------------------------------*
DATA: wa_stat TYPE ty_status,
      it_stat TYPE TABLE OF ty_status.
DATA: it_return TYPE TABLE OF ddshretval,
      wa_return TYPE ddshretval.

CONSTANTS:
  lc_msg1 TYPE string VALUE 'Media Product or Media Issue or ',
*  lc_msg2 TYPE string VALUE 'Media Issue or ',
  lc_msg3 TYPE string VALUE 'Publishing Date or ',
  lc_msg4 TYPE string VALUE 'Initial Shipping Date or ',
  lc_msg5 TYPE string VALUE 'Delivery Date (JKSENIP)'.
*  lc_spr  TYPE thead-tdspras VALUE 'E',
*  lc_obj  TYPE thead-tdobject VALUE 'VBBP',
*  lc_ced  TYPE sy-datum VALUE '99991231',
*  lc_id2  TYPE thead-tdid VALUE '0001',
*  lc_obj2 TYPE thead-tdobject VALUE 'MVKE',
*  lc_dist TYPE vtweg VALUE '00'.
