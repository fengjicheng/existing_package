FUNCTION-POOL zqtc_loistd.                  "MESSAGE-ID ..

* INCLUDE LZQTC_LOISTDD...                   " Local class definition

TYPES:BEGIN OF ty_matnr,
        matnr TYPE matnr,
      END OF ty_matnr.

DATA:ir_object    TYPE RANGE OF cdobjectcl WITH HEADER LINE,
     iv_date      TYPE sy-datum,
     iv_date_last TYPE sy-datum,
     iv_time_last TYPE sy-uzeit,
     iv_time      TYPE sy-uzeit,
     iv_target    TYPE edipparnum,
     iv_msgtyp    TYPE edi_mestyp,
     ir_table     TYPE RANGE OF tabname WITH HEADER LINE,
     ir_fname     TYPE RANGE OF fieldname WITH HEADER LINE,
     ir_mtart     TYPE RANGE OF mtart     WITH HEADER LINE,
     i_cdhdr      TYPE STANDARD TABLE OF cdhdr,
     i_cdpos      TYPE STANDARD TABLE OF cdpos,
     i_matnr      TYPE STANDARD TABLE OF ty_matnr,
     ir_werks     TYPE fip_t_werks_range,
     st_werks     TYPE fip_s_werks_range,
     lst_const_dt TYPE zcaconstant,
     lst_const_tm TYPE zcaconstant,
     ir_matnr     TYPE RANGE OF matnr WITH HEADER LINE,
     st_interface TYPE zcainterface.

CONSTANTS:c_object TYPE rvari_vnam VALUE 'OBJECT',
          c_date   TYPE rvari_vnam VALUE 'DATE',
          c_time   TYPE rvari_vnam VALUE 'TIME',
          c_table  TYPE rvari_vnam VALUE 'TABLE',
          c_fname  TYPE rvari_vnam VALUE 'FNAME',
          c_werks  TYPE rvari_vnam VALUE 'WERKS',
          c_target TYPE rvari_vnam VALUE 'TARGET',
          c_mtart  TYPE rvari_vnam VALUE 'MTART',
          c_devid  TYPE zdevid     VALUE 'I0382',
          c_i      TYPE char1      VALUE 'I',
          c_eq     TYPE ddoption   VALUE 'EQ',
          c_b1     TYPE char2      VALUE 'B1',
          c_038    TYPE char3      VALUE '038',
          c_039    TYPE char3      VALUE '039'.
