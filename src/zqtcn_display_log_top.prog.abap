*&---------------------------------------------------------------------*
*&  Include           ZQTCN_DISPLAY_LOG_TOP
*&---------------------------------------------------------------------*

*-----------------Declaration-----------------------------------------
TYPES:BEGIN OF ty_final,
        trkorr  TYPE trkorr,
        trtype  TYPE char10,
        as4text TYPE as4text,
        as4user TYPE tr_as4user,
        ed1     TYPE icon_d,
        ed1date TYPE as4date,
        ed1time TYPE as4time,
        ed2     TYPE icon_d,
        ed2date TYPE as4date,
        ed2time TYPE as4time,
        eq1     TYPE icon_d,
        eq1date TYPE as4date,
        eq1time TYPE as4time,
        eq2     TYPE icon_d,
        eq2date TYPE as4date,
        eq2time TYPE as4time,
        ep1     TYPE icon_d,
        ep1date TYPE as4date,
        ep1time TYPE as4time,
        eq3     TYPE icon_d,
        eq3date TYPE as4date,
        eq3time TYPE as4time,
        es1     TYPE icon_d,
        es1date TYPE as4date,
        es1time TYPE as4time,
      END OF ty_final.

DATA: i_final       TYPE STANDARD TABLE OF ty_final.

DATA: i_attachment  TYPE STANDARD TABLE OF solisti1 INITIAL SIZE 0.

INCLUDE ole2incl.
* handles for OLE objects
DATA: v_excel    TYPE ole2_object,        " Excel object
      v_map1     TYPE ole2_object,        " list of workbooks
      v_map      TYPE ole2_object,        " workbook
      v_workbook TYPE ole2_object,
      v_zl       TYPE ole2_object,        " cell
      v_f        TYPE ole2_object.        " font
DATA  v_h TYPE i.

DATA: v_column TYPE ole2_object.


CONSTANTS:c_ed1         TYPE trtarsys   VALUE 'ED1',
          c_ed2         TYPE trtarsys   VALUE 'ED2',
          c_eq1         TYPE trtarsys   VALUE 'EQ1',
          c_eq2         TYPE trtarsys   VALUE 'EQ2',
          c_eq3         TYPE trtarsys   VALUE 'EQ3',
          c_ep1         TYPE trtarsys   VALUE 'EP1',
          c_es1         TYPE trtarsys   VALUE 'ES1',
          c_zero        TYPE strw_int4  VALUE '0',
          c_four        TYPE strw_int4  VALUE '4',
          c_green       TYPE icon_d     VALUE '@08@',   " Green Symbol for Successful to Import
          c_red         TYPE icon_d     VALUE '@0A@',   " Red Symbol for Fail to import
          c_yellow      TYPE icon_d     VALUE '@09@',   " Yellow Symbol for open to import
          c_e           TYPE char1      VALUE 'E',
          c_inf         TYPE char1      VALUE 'I',
          c_export      TYPE trbatfunc  VALUE 'E', "E	Create Versions After Export
          c_version     TYPE trbatfunc  VALUE 'V', "V  Version Management: Set I Flags at Import
          c_genrat      TYPE trbatfunc  VALUE 'G', "G  Generation of ABAPs and Screens
          c_y           TYPE trbatfunc  VALUE 'Y', "Y	Conversion Program Call for Matchcode Generation
          c_o           TYPE trbatfunc  VALUE 'O', "O	Conversion Program Call in Background (SE14 TBATG)
          c_a           TYPE trbatfunc  VALUE 'A', "A	Activation of ABAP Dictionary objects
          c_x           TYPE trbatfunc  VALUE 'X', "X	Export Application-Defined Objects
          c_d           TYPE trbatfunc  VALUE 'D', "D Import Application-Defined Objects
          c_r           TYPE trbatfunc  VALUE 'R', "R	Perform Actions after Activation
          c_b           TYPE trbatfunc  VALUE 'B', "B	Activation with TACOB
          c_n           TYPE trbatfunc  VALUE 'N', "N	Conversion with TBATG (Upgrade or Transport)
          c_q           TYPE trbatfunc  VALUE 'Q', "Q	Perform Actions Before Activation
          c_u           TYPE trbatfunc  VALUE 'U', "U	Evaluation of Conversion Logs
          c_s           TYPE trbatfunc  VALUE 'S', "S	Distributor (Compare Program for Inactive Nametabs)
          c_j           TYPE trbatfunc  VALUE 'J', "J	Activation of Dictionary Obj. with Inact. Nametab w/o Conv.
          c_m           TYPE trbatfunc  VALUE 'M', "M	Activation of ENQU/D, MCOB/ID/OF/OD
          c_f           TYPE trbatfunc  VALUE 'F', "F	Create Versions After Import
          c_w           TYPE trbatfunc  VALUE 'W', "W	Create Backup Versions before Import
          c_p           TYPE trbatfunc  VALUE 'P', "P	Activation of Nametab Entries
          c_ext_t       TYPE trbatfunc  VALUE 'T', "T	External Deployment Objects
          c_t           TYPE trbatfunc  VALUE 't', "t	Check Deploy Status
          c_c           TYPE trbatfunc  VALUE 'C', "C	HANA deployment for HOTA, HOTO, and HOTP objects
          c_7           TYPE trbatfunc  VALUE '7', "7	Execute method (follow-up actions)
          c_i           TYPE trbatfunc  VALUE 'I', "Set I Flags at Import
          c_custom      TYPE trfunction VALUE 'W', "Customization Request
          c_workbench   TYPE trfunction VALUE 'K', "Workbench  Request
          c_exclamation TYPE trfunction VALUE '!',
          c_graterthan  TYPE trfunction VALUE '>',
          c_lessthan    TYPE trfunction VALUE '<',
          c_ed1rfc      TYPE char15 VALUE 'ED1CLNT130T'.
TYPE-POOLS:   ixml.  " XML Library Types

TYPES: BEGIN OF ty_xml_line,  " Structure for xml line
         data(255) TYPE x,
       END OF ty_xml_line.
DATA:obj_ixml          TYPE REF TO   if_ixml,
     obj_streamfactory TYPE REF TO   if_ixml_stream_factory,
     obj_ostream       TYPE REF TO   if_ixml_ostream,
     obj_renderer      TYPE REF TO   if_ixml_renderer,
     obj_document      TYPE REF TO   if_ixml_document,
     obj_element_root  TYPE REF TO   if_ixml_element,
     obj_ns_attribute  TYPE REF TO   if_ixml_attribute,
     obj_element_pro   TYPE REF TO   if_ixml_element,
     obj_worksheet     TYPE REF TO   if_ixml_element,
     obj_table         TYPE REF TO   if_ixml_element,
     obj_column        TYPE REF TO   if_ixml_element,
     obj_row           TYPE REF TO   if_ixml_element,
     obj_cell          TYPE REF TO   if_ixml_element,
     obj_data          TYPE REF TO   if_ixml_element,
     v_value           TYPE          string,
     obj_styles        TYPE REF TO   if_ixml_element,
     obj_style         TYPE REF TO   if_ixml_element,
     obj_style1        TYPE REF TO   if_ixml_element,
     obj_style2        TYPE REF TO   if_ixml_element,
     obj_format        TYPE REF TO   if_ixml_element,
     obj_border        TYPE REF TO   if_ixml_element,
     i_xml_table       TYPE TABLE OF ty_xml_line,
     st_xml            TYPE          ty_xml_line,
     gt_fcat           TYPE          lvc_t_fcat,
     gr_credat         TYPE          fkk_rt_chdate.


DATA:gt_tr  TYPE TABLE OF rsdsselopt,
     gst_tr TYPE rsdsselopt,
     gt_opt TYPE TABLE OF zqtcr_tr_log_opt_str,
     gs_opt TYPE zqtcr_tr_log_opt_str.

##CLASS_FINAL
CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_user_command FOR EVENT added_function OF cl_salv_events  "User Interaction
        IMPORTING e_salv_function,
      on_link_click FOR EVENT link_click OF cl_salv_events_table  " On CLick event
        IMPORTING row column.


ENDCLASS.

CLASS lcl_handle_events IMPLEMENTATION.
  METHOD on_user_command.
    PERFORM f_handle_user_command USING e_salv_function.
  ENDMETHOD.                    "on_user_command
  "on_single_click
  METHOD on_link_click.
    PERFORM show_cell_info USING row column.
  ENDMETHOD.
ENDCLASS.
DATA: gr_events     TYPE REF TO lcl_handle_events,
      gr_table      TYPE REF TO cl_salv_table,
      gr_selections TYPE REF TO cl_salv_selections.
