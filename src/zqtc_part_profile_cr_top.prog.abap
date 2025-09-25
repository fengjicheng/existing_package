*&---------------------------------------------------------------------*
*&  Include           ZQTC_PART_PROFILE_CR_TOP
*&---------------------------------------------------------------------*
TABLES:   sscrfields. "Screenfields
TYPE-POOLS: slis.
INCLUDE ole2incl.
* handles for OLE objects
DATA: v_excel TYPE ole2_object,        " Excel object
      v_mapl  TYPE ole2_object,         " list of workbooks
      v_map   TYPE ole2_object,          " workbook
      v_zl    TYPE ole2_object,           " cell
      v_f     TYPE ole2_object.
DATA  v_h TYPE i.
DATA: v_column TYPE ole2_object.

DATA:lt_fields TYPE STANDARD TABLE OF dfies,
     ls_fields TYPE dfies.
DATA:lv_table TYPE ddobjname.

DATA:lt_edpp1 TYPE STANDARD TABLE OF edpp1,
     lt_edp12 TYPE STANDARD TABLE OF edp12,
     lt_edp13 TYPE STANDARD TABLE OF edp13.

FIELD-SYMBOLS: <t_itab> TYPE STANDARD TABLE,
               <fs_fld> TYPE any,
               <fs_wa>  TYPE any.
