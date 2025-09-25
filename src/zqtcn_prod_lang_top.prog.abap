*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_PRODUCT_LANG_REP_R089
* PROGRAM DESCRIPTION: This report used to display Product text from
*                      Material Master.
* DEVELOPER:           Nageswara
* CREATION DATE:       08/19/2019
* OBJECT ID:           R089
* TRANSPORT NUMBER(S): ED2K915908
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&  Include          ZQTCN_PROD_LANG_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS:slis.

*====================================================================*
* TYPES DECLARARTION
*====================================================================*
TYPES: BEGIN OF ty_material ,
         matnr    TYPE char70,                          " material
         ersda    TYPE ersda,
         mtart    TYPE mtart,
         ismtitle TYPE ismtitle,
         werks    TYPE werks_d,
         spras    TYPE spras,
         maktx    TYPE maktx,
       END OF ty_material,

       BEGIN OF ty_stxh ,
         tdobject TYPE tdobject,                          " TD Object
         tdname   TYPE tdobname,                          " TD Name
         tdid     TYPE tdid,
         tdspras  TYPE spras,
         tdtitle  TYPE tdtitle,
       END OF ty_stxh,

       BEGIN OF ty_text,
         matnr TYPE char70,
         werks TYPE werks_d,
         spras TYPE spras,
         text  TYPE char80,
       END OF ty_text.

*====================================================================*
* GLOBAL VARIABLES
*====================================================================*

DATA: v_matnr      TYPE matnr,                  " Material
      v_werks      TYPE werks_d,                " Plant
      v_erdat      TYPE erdat_rf,               " Date on which the Record Was Created
      i_material   TYPE TABLE OF ty_material,   " Internal Table for Materials data
      i_makt_txt   TYPE TABLE OF ty_material,   " Internal Table for Materials data
      i_stxh       TYPE TABLE OF ty_stxh,       " Internal Table for STXH data
      i_text       TYPE TABLE OF ty_text,       " Internal Table for Basic text
      v_stxh_lines TYPE i,
      v_total      TYPE i,                      " Total fields
      v_makt_lines TYPE i.

DATA: r_table   TYPE REF TO cl_salv_table,
      i_alvfc   TYPE slis_t_fieldcat_alv,
      st_alvfc  TYPE slis_fieldcat_alv,
      i_fldcat  TYPE lvc_t_fcat,
      v_fname   TYPE char20,
      v_columns TYPE i,
      st_fldcat TYPE lvc_s_fcat.

FIELD-SYMBOLS:<dyn_table> TYPE STANDARD TABLE,
              <dyn_wa>.


CONSTANTS : c_short_txt TYPE char6    VALUE 'ST_TXT',
            c_st_lan    TYPE char9   VALUE 'ST Lang', ##NO_TEXT
            c_st_txt    TYPE char24   VALUE 'Short Material Desc',  ##NO_TEXT
            c_basic_txt TYPE char6    VALUE 'BA_TXT',
            c_ba_lan    TYPE char16   VALUE 'Basic Data Lang ', ##NO_TEXT
            c_ba_txt    TYPE char24   VALUE 'Basic Data Material Desc ',    ##NO_TEXT
            c_st_lang   TYPE char7    VALUE 'ST_LANG',
            c_ba_lang   TYPE char7    VALUE 'BA_LANG',
            c_material  TYPE tdobject VALUE 'MATERIAL',
            c_grun      TYPE tdid     VALUE 'GRUN'.
