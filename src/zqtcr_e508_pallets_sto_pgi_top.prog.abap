*&---------------------------------------------------------------------*
*&  Include           ZPALLETTEST_TOP
*&---------------------------------------------------------------------*
TABLES: lips.
"Constants
*CONSTANTS :
*            gc_domname   TYPE char30     VALUE 'STATV',
*            gc_item_cat  TYPE pstyv      VALUE 'ZRGD'.
*            lc_bukrs     TYPE ekko-bukrs VALUE '5501', "comp code
*            lc_bsart     TYPE ekko-bsart VALUE 'ZAUB', " doc type
*            lc_reswk     TYPE ekko-reswk VALUE '5512', " suppl planr
*            lc_delivery  TYPE char1      VALUE 'J', "
*            lc_pgi       TYPE char1      VALUE 'R',
*            lc_status    TYPE  char10    VALUE 'CLOSED',
*            lc_purch_grp TYPE char10     VALUE 'PB1',
*            lc_purch_org TYPE char10     VALUE 'JWPO',
*            lc_werks     TYPE werks_d    VALUE '5534', " plant
*            lc_lgort     TYPE lgort_d    VALUE 'B001'. " STO storage loc
*            lc_not_processed TYPE char30     VALUE 'NOT PROCESSED'.

" Types Declaration
TYPES : BEGIN OF ty_final,
          pallet_no               TYPE char12,
          pallet_status           TYPE char10,
          return_order            TYPE vbeln_va,
          return_delv             TYPE vbeln_vl,
          return_delv_status      TYPE string,
          return_delv_lineitem    TYPE posnr_vl,
          material                TYPE matnr,
          isbn                    TYPE ean11,
          qty                     TYPE lips-lfimg,
          uom                     TYPE lips-vrkme,
          sto                     TYPE vbeln,
          sto_create_date         TYPE datum,
          replenishment_delv      TYPE vbeln,
          replenisment_date       TYPE datum,
          replenisment_pgi_status TYPE string,
        END OF ty_final,
        tt_final TYPE STANDARD TABLE OF ty_final.
TYPES : BEGIN OF ty_sto,
          sto   TYPE ekko-ebeln,                   "STO Number
          aedat TYPE ekko-aedat,                   "STO Creation Date
        END OF ty_sto,

        BEGIN OF ty_pallet_id,
          pallet_no TYPE ekko-ihrez,
        END OF ty_pallet_id,

        BEGIN OF ty_replen_del,
          vbeln TYPE likp-vbeln,                   "Replen Delivery Number
          erdat TYPE likp-erdat,                   "Replen Del Creation Date
        END OF ty_replen_del,

        BEGIN OF ty_sto_del,
          sto_del     TYPE lips-vbeln,             "Delivery Number
          sto_del_itm TYPE lips-posnr,             "Delivery Line Item
          sto         TYPE lips-vgbel,             "STO Number
          sto_itm     TYPE lips-vgpos,             "STO Line Item
          matnr       TYPE lips-matnr,             "Article Number
          lfimg       TYPE lips-lfimg,             "Quantity
          vrkme       TYPE lips-vrkme,             "Sales Unit
          ean11       TYPE lips-ean11,             "ISBN
        END OF ty_sto_del,

        BEGIN OF ty_ret_del,
          ret_del     TYPE lips-vbeln,             "Delivery Number
          ret_del_itm TYPE lips-posnr,             "Delivery Line Item
          item_cat    TYPE lips-pstyv,             "Item Categorys
          matnr       TYPE lips-matnr,             "Article Number
          ean11       TYPE lips-ean11,             "ISBN
          lfimg       TYPE lips-lfimg,             "Quantity
          vrkme       TYPE lips-vrkme,             "Sales Unit
        END OF ty_ret_del,

        BEGIN OF ty_vbuk,
          vbeln TYPE vbuk-vbeln,                   "Delivery Number
          wbstk TYPE vbuk-wbstk,                   "Overall Goods Movement Status
        END OF ty_vbuk,

        BEGIN OF ty_log,
          pallete_id       TYPE ekko-ihrez,          "Pallete ID
          pallete_status   TYPE string,              "Pallete Status
          ret_ord          TYPE ekko-ebeln,          "Return Order
          ret_del          TYPE lips-vbeln,          "Return Delivery
          ret_del_pgi_stat TYPE string,              "Return Delivery PGI Status
          ret_del_lin_item TYPE lips-posnr,          "Return Delivery Line item
          item_cat         TYPE lips-pstyv,          "Return Delivery Item Category
          matnr            TYPE lips-matnr,          "Material
          isbn             TYPE lips-ean11,          "ISBN
          quantity         TYPE lips-lfimg,          "Quantity
          uom              TYPE lips-vrkme,          "Sales Unit
          sto              TYPE lips-vgbel,          "STO
          sto_cred_date    TYPE ekko-aedat,          "STO Creation Date
          replen_del       TYPE lips-vbeln,          "Replenishment Delivery
          replen_del_date  TYPE lips-erdat,          "Replenishment Delivery Creation Date
          pgi_stat         TYPE string,              "Replenishment Delivery PGI
          message          TYPE string,              "Message
        END OF ty_log,

        BEGIN OF ty_matnr_sum,
          pallet_no TYPE ekko-ihrez, "zpallet_no,
          matnr     TYPE matnr,
          lfimg     TYPE lfimg,
        END OF ty_matnr_sum,
        tt_matnr_sum TYPE STANDARD TABLE OF ty_matnr_sum,

        BEGIN OF ty_sto_final,
          pallet_no            TYPE ekko-ihrez,
          pallet_status        TYPE char20,
          return_order         TYPE vbeln_va,
          return_delv          TYPE vbeln_vl,
          return_delv_lineitem TYPE posnr_vl,
          item_cat             TYPE pstyv,
          material             TYPE matnr,
          isbn                 TYPE ean11,
          qty                  TYPE lips-lfimg,
          uom                  TYPE lips-vrkme,
          plant                TYPE werks_d,
          stge_loc             TYPE lgort_d,
          sto                  TYPE vbeln,
          sto_status           TYPE char30,
          sto_create_date      TYPE datum,
          po_unit              TYPE vrkme,
          not_process          TYPE flag,
          message              TYPE char50,

        END OF ty_sto_final,
        tt_sto_final TYPE STANDARD TABLE OF ty_sto_final,

*Structure to hold constant table
        BEGIN OF ty_const,
          devid    TYPE zdevid,              "Development ID
          param1   TYPE rvari_vnam,          "Parameter1
          param2   TYPE rvari_vnam,          "Parameter2
          srno     TYPE tvarv_numb,          "Serial Number
          sign     TYPE tvarv_sign,          "Sign
          opti     TYPE tvarv_opti,          "Option
          low      TYPE salv_de_selopt_low,  "Low
          high     TYPE salv_de_selopt_high, "High
          activate TYPE zconstactive,        "Active/Inactive Indicator
        END OF ty_const.



"Global Types
DATA : i_const            TYPE STANDARD TABLE OF ty_const,
       i_final            TYPE tt_final,
       lv_pallet          TYPE char10,
       i_sto_final        TYPE tt_sto_final,
       i_sto_final_temp   TYPE tt_sto_final,
       is_sto_final_temp  TYPE ty_sto_final,
       is_pal_header      TYPE zpal_header,
       i_pal_header       TYPE STANDARD TABLE OF zpal_header,
       i_pallet_rejected  TYPE STANDARD TABLE OF zpal_header,
       ls_pallet_rejected TYPE zpal_header,
       i_pallet_item      TYPE STANDARD TABLE OF zpal_item.
* Table for catalog of the fields to be displayed

DATA: i_fieldcat  TYPE  slis_t_fieldcat_alv,
      i_fieldcat1 TYPE  slis_t_fieldcat_alv.

* Internal table to mention the sort sequence
DATA : i_sort TYPE slis_t_sortinfo_alv.

DATA : i_pallet     TYPE STANDARD TABLE OF zpal_header,
       i_return_ord TYPE STANDARD TABLE OF zpal_item.

DATA : i_pallete_header TYPE STANDARD TABLE OF zpal_header,
       i_pallete_item   TYPE STANDARD TABLE OF zpal_item,
       i_pallet_id      TYPE TABLE OF ty_pallet_id,
       i_sto            TYPE TABLE OF ty_sto,
       i_sto_del        TYPE TABLE OF ty_sto_del,
       i_ret_del        TYPE TABLE OF ty_ret_del,
       i_replen_del     TYPE TABLE OF ty_replen_del,
       i_ret_del_stat   TYPE TABLE OF ty_vbuk,
       i_sto_del_stat   TYPE TABLE OF ty_vbuk,
       i_log            TYPE TABLE OF ty_log,
       i_log_head       TYPE TABLE OF ty_log,
       i_vbpok          TYPE TABLE OF vbpok,
       i_pgi_statdesc   TYPE TABLE OF dd07v,
       lst_fieldcat     LIKE LINE OF i_fieldcat,
       st_pallet        TYPE ty_pallet_id,
       st_log           TYPE ty_log,
       st_vbkok         LIKE vbkok,
       st_vbpok         TYPE vbpok.

DATA : i_pallet_header  TYPE STANDARD TABLE OF zpal_header.


DATA : v_pallete        TYPE ekko-ihrez,
       v_e508_lgort     TYPE lgort_d,
       v_e508_vbtyp_n   TYPE vbtyp_n,
       v_e508_vbtyp_pgi TYPE vbtyp_n,
       v_e508_vbtyp_v   TYPE vbtyp_v,
       v_e508_werks_1   TYPE werks_d,
       v_e508_werks_2   TYPE werks_d,
       v_e508_bsart     TYPE bsart,
       v_e508_bukrs     TYPE bukrs,
       v_e508_ekorg     TYPE ekorg,
       v_e508_ekgrp     TYPE ekgrp,
       v_e508_vstel     TYPE vstel,
       v_e508_pstyv     TYPE pstyv.


CONSTANTS :
  c_wbstk     TYPE char1      VALUE 'A',
  c_domname   TYPE domname    VALUE 'STATV',
  c_devid     TYPE zdevid     VALUE 'E508',
  c_lgort_1   TYPE rvari_vnam VALUE 'LGORT',
  c_vbtyp_n   TYPE rvari_vnam VALUE 'VBTYP_N',
  c_vbtyp_pgi TYPE rvari_vnam VALUE 'VBTYP_PGI',
  c_vbtyp_v   TYPE rvari_vnam VALUE 'VBTYP_V',
  c_werks_1   TYPE rvari_vnam VALUE 'WERKS_1',
  c_werks_2   TYPE rvari_vnam VALUE 'WERKS_2',
  c_bsart     TYPE rvari_vnam VALUE 'BSART',
  c_bukrs     TYPE rvari_vnam VALUE 'BUKRS',
  c_ekgrp     TYPE rvari_vnam VALUE 'EKGRP',
  c_ekorg     TYPE rvari_vnam VALUE 'EKORG',
  c_vstel     TYPE rvari_vnam VALUE 'VSTEL',
  c_pstyv     TYPE rvari_vnam VALUE 'PSTYV'.
