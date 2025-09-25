*----------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCR_IF_PRICING_OB_ERPM1642
* PROGRAM DESCRIPTION : IDOC Interface for LH pricing
* DEVELOPER           : VDPATABALL
* CREATION DATE       : 09/12/2019
* OBJECT ID           : ERPM1642 - I0373
* TRANSPORT NUMBER(S) : ED2K916136,ED2K916665
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
REPORT zqtcr_if_pricing_ob_i0373 NO STANDARD PAGE HEADING.

TYPES: BEGIN OF ty_s_clause,
         line(72) TYPE c,
       END OF ty_s_clause.
*---Global Internal Tables--------------------------
DATA:i_condition    TYPE STANDARD TABLE OF vkkacondit,
     i_idoc_control TYPE STANDARD TABLE OF edidc,
     i_konh         TYPE STANDARD TABLE OF konh,
     lst_condition  TYPE vkkacondit,
     v_mestyp       TYPE tbdme-mestyp,
     v_logsys       TYPE tbdls-logsys,
     i_fld_list     TYPE ddfields,
     i_cond         TYPE STANDARD TABLE OF hrcond,
     i_where_clause TYPE STANDARD TABLE OF ty_s_clause WITH DEFAULT KEY,
     i_constants    TYPE STANDARD TABLE OF zcaconstant.

*---Global Constants--------------------------
CONSTANTS:c_e     TYPE char1  VALUE 'E',
          c_i     TYPE char1  VALUE 'I',
          c_x     TYPE char1  VALUE 'X',
          c_eq    TYPE char2  VALUE 'EQ',
          c_devid TYPE zdevid VALUE 'I0373',
          c_msgfn TYPE char3  VALUE '004',
          c_kschl TYPE fieldname VALUE 'KSCHL',
          c_vkorg TYPE fieldname VALUE 'VKORG',
          c_matnr TYPE fieldname VALUE 'MATNR',
          c_spart TYPE fieldname VALUE 'SPART',
          c_datab TYPE fieldname VALUE 'DATAB',
          c_datbi TYPE fieldname VALUE 'DATBI'.

FIELD-SYMBOLS : <fs_tdata> TYPE ANY TABLE.

*--------------------------------------------------------------------*
*---Selection screen--------------------------
TABLES:a653.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETERS: p_tname TYPE tabname  DEFAULT 'A653' OBLIGATORY.
SELECT-OPTIONS:s_kschl FOR a653-kschl DEFAULT 'ZPRG' NO INTERVALS NO-EXTENSION OBLIGATORY,
               s_vkorg FOR a653-vkorg DEFAULT '1030' NO INTERVALS NO-EXTENSION OBLIGATORY,
               s_spart FOR a653-spart DEFAULT '30'   NO INTERVALS NO-EXTENSION OBLIGATORY,
               s_matnr FOR a653-matnr NO-EXTENSION,
               s_datab FOR a653-datab NO-EXTENSION DEFAULT sy-datum ,
               s_datbi FOR a653-datbi NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK b2 .
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
PARAMETERS:p_del RADIOBUTTON GROUP abc USER-COMMAND ucm DEFAULT 'X',
           p_ful RADIOBUTTON GROUP abc.
SELECTION-SCREEN END OF BLOCK b3 .
SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-005.
PARAMETERS:p_msgtyp TYPE edi_stdmes DEFAULT 'COND_A' OBLIGATORY,
           p_logsys TYPE logsys     DEFAULT 'TIBCO'.
SELECTION-SCREEN END OF BLOCK b4 .
SELECTION-SCREEN END OF BLOCK b1 .

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    IF p_ful IS NOT INITIAL.
      IF screen-name = 'S_DATAB-LOW'.
        FREE:s_datab.
      ENDIF.
    ELSEIF p_del IS NOT INITIAL.
      IF screen-name = 'S_DATAB-LOW'.
        CLEAR s_datab.
        s_datab-sign   = c_i.
        s_datab-option = c_eq.
        s_datab-low    = sy-datum.
        APPEND s_datab TO s_datab.
        CLEAR s_datab.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.


START-OF-SELECTION.
*---free the gloabl tables
  PERFORM f_free_gloabl_tables.
*--Fetch the dynamic table
  PERFORM f_fetch_dynamic_table.
*---Fetch the contstant table data
  PERFORM f_fetch_constants.
*---arrange the condition records for where clause
  PERFORM f_dynamic_sel_condition.
*---call the FM and get the where clause
  PERFORM f_dynamic_where_clause.
*---get the data values from the dyamic table
  PERFORM f_dynamic_select_query.
*--- genetate the IDOC below for full load and delta load
  IF <fs_tdata>  IS NOT INITIAL.
*--Data record filling
    PERFORM f_create_data_record.
*---creating idoc number
    PERFORM f_genarte_idoc.
  ELSE.
    MESSAGE text-004 TYPE c_i.
  ENDIF.

***-------------------------------------------------------------------*
***-------------------------------------------------------------------*
****--------------------------Form Rutines--------------------------***
***-------------------------------------------------------------------*
***-------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  F_CREATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_data_record.
  DATA:li_cond TYPE char20.
  FIELD-SYMBOLS:<datab> TYPE any,
                <datbi> TYPE any,
                <knumh> TYPE any.

  LOOP AT <fs_tdata>  ASSIGNING FIELD-SYMBOL(<fs_lst_tdata>).
    MOVE-CORRESPONDING <fs_lst_tdata> TO lst_condition.
    ASSIGN COMPONENT 'DATAB' OF STRUCTURE <fs_lst_tdata> TO <datab>.    "now you can read it
    ASSIGN COMPONENT 'DATBI' OF STRUCTURE <fs_lst_tdata> TO <datbi>.    "now you can read it
    ASSIGN COMPONENT 'KNUMH' OF STRUCTURE <fs_lst_tdata> TO <knumh>.    "now you can read it
    lst_condition-a_datbi = <datbi>.
    lst_condition-a_datab = <datab>.
    READ TABLE i_konh INTO DATA(lst_konh) WITH KEY knumh = <knumh>.
    IF sy-subrc = 0.
      lst_condition-kvewe   = lst_konh-kvewe.
      lst_condition-kotabnr = lst_konh-kotabnr.
      lst_condition-erdat   = lst_konh-erdat.
      lst_condition-ernam   = lst_konh-ernam.
      lst_condition-vakey   = lst_konh-vakey.
      lst_condition-datab   = lst_konh-datab.
      lst_condition-datbi   = lst_konh-datbi.
      APPEND lst_condition TO i_condition.
      CLEAR: lst_condition,lst_konh,<fs_lst_tdata>.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GENARTE_IDOC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_genarte_idoc .
  v_mestyp  = p_msgtyp.
  v_logsys  = p_logsys.
  CALL FUNCTION 'MASTERIDOC_CREATE_COND_A'
    EXPORTING
      pi_mestyp                 = v_mestyp
      pi_logsys                 = v_logsys
      pi_direkt                 = c_x
      pi_protocoll              = c_x
    TABLES
      pit_conditions            = i_condition
      te_idoc_control           = i_idoc_control
    EXCEPTIONS
      idoc_could_not_be_created = 1
      OTHERS                    = 2.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DYNAMIC_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_dynamic_table .

*Objects Declaration
  DATA: lr_dynamic_s TYPE REF TO data,
        lr_dynamic_t TYPE REF TO data.

* Data Declaration
  DATA: lr_struc_desc TYPE REF TO cl_abap_structdescr, "Describe a Structure
        li_components TYPE abap_component_tab.

  DATA:lo_struc_type TYPE REF TO cl_abap_structdescr, " Runtime Type Services
       lo_table_type TYPE REF TO cl_abap_tabledescr.  " Runtime Type Services

* Get Description of data object type (Table)
  lr_struc_desc ?= cl_abap_typedescr=>describe_by_name( p_tname ).
*  list of dictionary descriptions for all components
  CALL METHOD lr_struc_desc->get_ddic_field_list
    EXPORTING
      p_langu                  = sy-langu       "Language Key
      p_including_substructres = abap_true      "List Also for Substructures
    RECEIVING
      p_field_list             = i_fld_list     "List of Dictionary Descriptions for the Components
    EXCEPTIONS
      not_found                = 1
      no_ddic_type             = 2
      OTHERS                   = 3.
  IF sy-subrc EQ 0.
*   Keep only the required Key fields
    DELETE i_fld_list WHERE fieldname EQ 'MANDT'.  "Field: Client
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DYNAMIC_WHERE_CLAUSE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_dynamic_sel_condition.
  DATA:lst_cond   TYPE  hrcond.
  IF i_fld_list IS NOT INITIAL.
    FREE:lst_cond,i_cond.
    LOOP AT i_fld_list INTO DATA(lst_fld_list).
      READ TABLE i_constants INTO DATA(lst_constants) WITH KEY param1 = lst_fld_list-fieldname.
      IF sy-subrc = 0.
        CLEAR lst_cond.
        lst_cond-field = lst_constants-low.
        lst_cond-opera = lst_constants-opti.
        CASE lst_constants-low.
          WHEN c_kschl.
            lst_cond-low   = s_kschl-low.
            APPEND lst_cond TO i_cond.
            CLEAR lst_cond.
          WHEN c_matnr.
            IF s_matnr-low IS NOT INITIAL.
              lst_cond-low   = s_matnr-low.
              IF  s_matnr-high IS INITIAL.
                lst_cond-opera = c_eq.
              ENDIF.
            ENDIF.
            IF  s_matnr-high IS NOT INITIAL.
              lst_cond-high  = s_matnr-high.
            ENDIF.
            IF lst_cond-low IS NOT INITIAL.
              APPEND lst_cond TO i_cond.
              CLEAR lst_cond.
            ENDIF.
          WHEN c_datbi.
            IF  s_datbi-low IS NOT INITIAL.
              lst_cond-low   = s_datbi-low.
              IF  s_datbi-high IS INITIAL.
                lst_cond-opera = c_eq.
              ENDIF.
            ENDIF.
            IF  s_datbi-high IS NOT INITIAL.
              lst_cond-high  = s_datbi-high.
            ENDIF.
            IF  lst_cond-low IS NOT INITIAL.
              APPEND lst_cond TO i_cond.
              CLEAR lst_cond.
            ENDIF.
          WHEN c_datab.
            IF  s_datab-low IS NOT INITIAL.
              lst_cond-low   = s_datab-low.
              IF  s_datab-high IS INITIAL.
                lst_cond-opera = c_eq.
              ENDIF.
            ENDIF.
            IF  s_datab-high IS NOT INITIAL.
              lst_cond-high  = s_datab-high.
            ENDIF.
            IF  lst_cond-low IS NOT INITIAL.
              APPEND lst_cond TO i_cond.
              CLEAR lst_cond.
            ENDIF.
          WHEN c_spart.
            lst_cond-low   = s_spart-low.
            APPEND lst_cond TO i_cond.
            CLEAR lst_cond.
          WHEN c_vkorg.
            lst_cond-low   = s_vkorg-low.
            APPEND lst_cond TO i_cond.
            CLEAR lst_cond.
        ENDCASE.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_CONSTANTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_fetch_constants .
  FREE: i_constants.
  SELECT *
     FROM zcaconstant
     INTO TABLE i_constants
     WHERE devid = c_devid
       AND activate = c_x.
  IF sy-subrc EQ 0.
    SORT i_constants BY param1.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DYNAMIC_WHERE_CLAUSE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_dynamic_where_clause .
  DATA:li_table TYPE dfies-tabname.
  FREE:li_table,i_where_clause.
  li_table = p_tname.
  CALL FUNCTION 'RH_DYNAMIC_WHERE_BUILD'
    EXPORTING
      dbtable         = li_table
    TABLES
      condtab         = i_cond
      where_clause    = i_where_clause
    EXCEPTIONS
      empty_condtab   = 1
      no_db_field     = 2
      unknown_db      = 3
      wrong_condition = 4
      OTHERS          = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DYNAMIC_SELECT_QUERY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_dynamic_select_query .
  DATA:dref        TYPE REF TO data,
       itab_type   TYPE REF TO cl_abap_tabledescr,
       struct_type TYPE REF TO cl_abap_structdescr.
  DATA:li_where TYPE  string.
  struct_type ?= cl_abap_typedescr=>describe_by_name( p_tname ).
  itab_type   = cl_abap_tabledescr=>create( struct_type ).

  CREATE DATA dref TYPE HANDLE itab_type.
  ASSIGN dref->* TO <fs_tdata>.
  IF i_where_clause IS NOT INITIAL.
    CONDENSE p_tname.
    SELECT *
      FROM (p_tname)
      INTO  TABLE <fs_tdata>
      WHERE (i_where_clause).
  ENDIF.

  IF <fs_tdata> IS NOT INITIAL.
    FREE:li_where.
    CONCATENATE 'KNUMH' '=' '<FS_TDATA>-KNUMH' INTO li_where SEPARATED BY space.
    SELECT *
      FROM konh
      INTO TABLE i_konh
      FOR ALL ENTRIES IN  <fs_tdata>
      WHERE (li_where).
    IF sy-subrc = 0.
      SORT i_konh BY knumh.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FREE_GLOABL_TABLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_free_gloabl_tables .
  FREE:i_condition,
       i_idoc_control,
       i_konh,
       lst_condition,
       v_mestyp,
       v_logsys,
       i_fld_list,
       i_cond,
       i_where_clause,
       i_constants .
ENDFORM.
