*&---------------------------------------------------------------------*
*&  Include           ZQTCN_WLS_SERIAL_E248_TOP
*&---------------------------------------------------------------------*
TYPES:BEGIN OF ty_output,
        sales        TYPE vbeln_va,
        deliv        TYPE vbeln_vl,
        invoice      TYPE vbeln_vf,
        kschl        TYPE sna_kschl,
        medium(30)   TYPE c,
        parvw        TYPE parvw,
        parnr        TYPE na_parnr241,
        spras(2)     TYPE c,
        vsztp        TYPE na_vsztp,
        message(200) TYPE c,
        FLAG_NAST    TYPE C,
        objky        TYPE na_objkey,
      END OF ty_output.
CONSTANTS:c_devid TYPE zdevid      VALUE 'E248',
          c_error TYPE char1       VALUE 'E', "Error message
          c_info  TYPE char1       VALUE 'I'. "Information message
DATA:i_fieldcatalog TYPE slis_t_fieldcat_alv, "fieldcatalog table
     lst_output     TYPE ty_output,
     gv_kschl       TYPE sna_kschl, " Messag type
     i_output       TYPE STANDARD TABLE OF ty_output.
