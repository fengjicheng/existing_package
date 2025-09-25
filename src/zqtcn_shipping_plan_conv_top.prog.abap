*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SHIPPING_PLAN_CONV_TOP(Include Program)
* PROGRAM DESCRIPTION: Shipping Plan Conversion
* DEVELOPER: Sayantan Das (SAYANDAS)
* CREATION DATE:   01/02/2017
* OBJECT ID:  C075
* TRANSPORT NUMBER(S): ED2K903953
*----------------------------------------------------------------------*
*** Global Types Declaration
*** Type for input data
TYPES: BEGIN OF ty_input,
         matnr TYPE string,
         nod   TYPE string,
       END OF ty_input.
**** Type for File data
TYPES: BEGIN OF ty_fdata,
         matnr TYPE matnr, " Material Number
         nod   TYPE i,     " Nod of type Integers
       END OF ty_fdata.
*** Type for display data
TYPES: BEGIN OF ty_disp,
         matnr  TYPE matnr, " Material Number
         nod    TYPE i,     " Nod of type Integers
         status TYPE char1, " Add field to hold traffic light value
       END OF ty_disp.
*** Type for final internal table
TYPES: BEGIN OF ty_final,
         matnr  TYPE matnr,           " Material Number
         nod    TYPE i,               " Nod of type Integers
         medp   TYPE ismrefmdprod,    " Higher-Level Media Product
         cald   TYPE jgen_start_date, " IS-M: Start Date for Order Generation
         status TYPE char4,           " Status of type CHAR4
         ermsg  TYPE string,
       END OF ty_final.


*** Global internal table and work area Declaration
DATA: i_input    TYPE STANDARD TABLE OF ty_input,
      i_valmat   TYPE STANDARD TABLE OF ty_fdata,
      i_fieldcat TYPE slis_t_fieldcat_alv,
      i_final    TYPE STANDARD TABLE OF ty_final,
      st_layout  TYPE slis_layout_alv,
      i_fdata    TYPE STANDARD TABLE OF ty_fdata.
*** Global variable Declaration
DATA : v_pr_ph  TYPE string,
       v_erflag TYPE char1 VALUE abap_false, " Erflag of type CHAR1
       v_ap_ph  TYPE string.
*** Global Constant declaration
CONSTANTS: c_tab   TYPE c VALUE cl_abap_char_utilities=>horizontal_tab. " Tab of type Character
