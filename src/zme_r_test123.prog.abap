*&---------------------------------------------------------------------*
*& Report  ZME_R_TEST123
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zme_r_test123.

INCLUDE zme_test123.

SELECT * FROM mara INTO TABLE i_mara UP TO 1 ROWS.
*SELECT * FROM mara INTO TABLE i_mara UP TO 10 ROWS.


PARAMETERS: p_tabnam TYPE tabname,
            p_selfl1 TYPE edpline,
            p_value  TYPE edpline,
            p_where1 TYPE edpline.

DATA: lt_where    TYPE TABLE OF edpline,
      lt_sel_list TYPE TABLE OF edpline,
      l_wa_name   TYPE string,
      ls_where    TYPE edpline,
      l_having    TYPE string,
      dref        TYPE REF TO data,
      itab_type   TYPE REF TO cl_abap_tabledescr,
      struct_type TYPE REF TO cl_abap_structdescr,
      elem_type   TYPE REF TO cl_abap_elemdescr,
      comp_tab    TYPE cl_abap_structdescr=>component_table,
      comp_fld    TYPE cl_abap_structdescr=>component.

TYPES: f_count TYPE i.

FIELD-SYMBOLS : <lt_outtab> TYPE ANY TABLE,
*                <ls_outtab> TYPE ANY,
                <l_fld>     TYPE any.

struct_type ?= cl_abap_typedescr=>describe_by_name( p_tabnam ).
elem_type   ?= cl_abap_elemdescr=>describe_by_name( 'F_COUNT' ).
comp_tab = struct_type->get_components( ).


comp_fld-name = 'F_COUNT'.
comp_fld-type = elem_type.
APPEND comp_fld TO comp_tab.

struct_type = cl_abap_structdescr=>create( comp_tab ).
itab_type   = cl_abap_tabledescr=>create( struct_type ).

l_wa_name = 'l_WA'.
CREATE DATA dref TYPE HANDLE itab_type.
ASSIGN dref->* TO <lt_outtab>.
*CREATE DATA dref TYPE HANDLE struct_type.
*ASSIGN dref->* TO <ls_outtab>.

* Creation of the selection fields
APPEND p_selfl1 TO lt_sel_list.
APPEND 'COUNT(*) AS F_COUNT' TO lt_sel_list.

** Creation of the "where" clause
*CONCATENATE p_selfl1 '= '' p_value ''.'
*            INTO ls_where
*            SEPARATED BY space.
*APPEND ls_where TO lt_where.
**lt_where = '& = ''&'' '.
*REPLACE '&' WITH field_name INTO lt_where.
*REPLACE '&' WITH field_value INTO lt_where.
* Creation of the "where" clause
*CONCATENATE 'DATAB EQ '20191030'' INTO
*lt_where.

* Creation of the "having" clause
*l_having = 'count(*) >= 1'.

* THE dynamic select
SELECT       *"   (lt_sel_list)
       FROM     (p_tabnam)
*       INTO CORRESPONDING FIELDS OF TABLE <lt_outtab>.
       INTO  TABLE <lt_outtab>.
*       WHERE    (lt_where).
  IF sy-subrc = 0.

  ENDIF.
