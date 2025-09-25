*&---------------------------------------------------------------------*
*&  Include           ZQTCR_INDIRECT_SOC_TOP
*&---------------------------------------------------------------------*

TYPES : BEGIN OF ty_itab,
          zzpartner TYPE zzpartner2,      "
          name1          TYPE string,
          soccode       TYPE zzsociety_acrnym,      "
          matnr          TYPE matnr,      "
          maktx          TYPE maktx,
          memcode        TYPE bu_reltyp,
          memdescr       TYPE string,
          memprice       TYPE kbetr,
          memdisc        TYPE kbetr,
          amount         TYPE kbetr,
          netpr          TYPE kbetr,
          datab          TYPE kodatab,
          datbi          TYPE kodatbi,
          konwa          TYPE konwa,
          pltyp          TYPE pltyp,
          ptext          TYPE string,

        END OF ty_itab.


CONSTANTS:  c_msgty_i    TYPE msgty           VALUE 'I'.  " Information message.

* Internal Table Declaration.
DATA: i_output        TYPE TABLE OF ty_itab, "Output table.
* Alv Related Declaration.
      r_alv_table     TYPE REF TO cl_salv_table,         " Basis Class for Simple Tables
      r_alv_columns   TYPE REF TO cl_salv_columns_table, " Columns in Simple, Two-Dimensional Tables
      r_single_column TYPE REF TO cl_salv_column.        " Individual Column Object
DATA:wa_but000 TYPE but000,
     wa_a985   TYPE a985.
