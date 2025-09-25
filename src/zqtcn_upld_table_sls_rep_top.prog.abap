*&---------------------------------------------------------------------*
*&  Include           ZQTCN_UPLD_TABLE_SLS_REP_TOP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_UPLD_TABLE_SLS_REP_SEL (Data Declarations)
* PROGRAM DESCRIPTION: Maintain Sales Rep PIGS Table Lookup
* DEVELOPER: Mintu Naskar (MNASKAR)
* CREATION DATE:   11/04/2016
* OBJECT ID:  E129
* TRANSPORT NUMBER(S):  ED2K903251
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K913679
* REFERENCE NO: ERP-7764
* DEVELOPER: Kiran Kumar Ravuri (KKRAVURI)
* DATE: 08-JAN-2019
* DESCRIPTION: Additon of new fields: 'Po Type', 'Ship-to party'
*----------------------------------------------------------------------*

TYPES: BEGIN OF ty_final,
         vkorg    TYPE vkorg,              "Sales Organization
         vtweg    TYPE vtweg,              "Distribution Channel
         spart    TYPE spart,              "Division
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
         bsark    TYPE bsark,              "Customer purchase order type
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
         matnr    TYPE matnr,              "Material / Product
         prctr    TYPE prctr,              "Profit Center
         kunnr    TYPE kunnr,              "Customer
         kvgr1    TYPE kvgr1,              "Customer Group
         pstlz_f  TYPE zzpstlz_f,          "Postal Code (From)
         pstlz_t  TYPE zzpstlz_t,          "Postal Code (To)
         regio    TYPE regio,              "Region
         land1    TYPE land1,              "Country
         datab    TYPE datab,              "Valid-From Date
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
         zship_to TYPE zship_to,           "Ship-to party
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
         datbi    TYPE datbi,              "Valid To Date
         srep1    TYPE zzsrep1,            "Sales Rep-1
         srep2    TYPE zzsrep2,            "Sales Rep-2
         aenam    TYPE aenam,              "Name of Person Who Changed Object
         aedat    TYPE aedat,              "Changed On
         aezet    TYPE aezet,              "Time last change was made
       END OF ty_final.

TYPES: BEGIN OF ty_excel,
         vkorg    TYPE vkorg,              "Sales Organization
         vtweg    TYPE vtweg,              "Distribution Channel
         spart    TYPE spart,              "Division
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
         bsark    TYPE bsark,              "Customer purchase order type
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
         datab    TYPE datab,              "Valid-From Date
         datbi    TYPE datbi,              "Valid To Date
         matnr    TYPE matnr,              "Material / Product
         prctr    TYPE prctr,              "Profit Center
         kunnr    TYPE kunnr,              "Customer
         kvgr1    TYPE kvgr1,              "Customer Group
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
         zship_to TYPE zship_to,           "Ship-to party
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
         pstlz_f  TYPE zzpstlz_f,          "Postal Code (From)
         pstlz_t  TYPE zzpstlz_t,          "Postal Code (To)
         regio    TYPE regio,              "Region
         land1    TYPE land1,              "Country
         srep1    TYPE zzsrep1,            "Sales Rep-1
         srep2    TYPE zzsrep2,            "Sales Rep-2
         aenam    TYPE aenam,              "Name of Person Who Changed Object
         aedat    TYPE aedat,              "Changed On
         aezet    TYPE aezet,              "Time last change was made
         delete   TYPE char1,              "Delete
       END OF ty_excel.

TYPES:BEGIN OF ty_tvko,
        vkorg TYPE vkorg,                    " Sales Organization
      END OF ty_tvko.

TYPES:BEGIN OF ty_tvtw,
        vtweg TYPE vtweg,                    " Distribution Channel
      END OF ty_tvtw.

TYPES:BEGIN OF ty_tspa,
        spart TYPE spart,                    " Division
      END OF ty_tspa.

TYPES:BEGIN OF ty_mvke,
        matnr TYPE matnr,                    " Material Number
        vkorg	TYPE vkorg,                    " Sales Organization
        vtweg	TYPE vtweg,                    " Distribution Channel
      END OF ty_mvke.

TYPES:BEGIN OF ty_cepc,
        prctr TYPE prctr,                    " Profit Center
        datbi TYPE datbi,                    " Valid To Date
        datab TYPE datab,                    " Valid-From Date
      END OF ty_cepc.

TYPES:BEGIN OF ty_kna1,
        kunnr TYPE kunnr,                    " Customer
        land1	TYPE land1_gp,                 " Country Key
      END OF ty_kna1.

TYPES:BEGIN OF ty_knvv,
        kunnr TYPE kunnr,                    " Customer
        vkorg TYPE vkorg,                    " Sales Organization
        vtweg TYPE vtweg,                    " Distribution Channel
        spart TYPE spart,                    " Division
      END OF ty_knvv.

TYPES:BEGIN OF ty_tvv1,
        kvgr1   TYPE kvgr1,                  " Customer group 1 (3 Chars)
        kvgr1_2 TYPE kvgr1,                  " Customer group 1 (2 Chars)
        kvgr1_1 TYPE kvgr1,                  " Customer group 1 (1 Chars)
      END OF ty_tvv1.

TYPES:BEGIN OF ty_t005s,
        land1	TYPE land1,                    "Country
        bland	TYPE regio,                    "Region
      END OF ty_t005s.

TYPES:BEGIN OF ty_t005,
        land1 TYPE land1,                    " Country
      END OF ty_t005.

TYPES:BEGIN OF ty_pa0003,
        pernr TYPE persno,                   " Sales Rep
      END OF ty_pa0003,
* BOC: CR#7764 KKRAVURI20190128  ED2K914344
      BEGIN OF ty_potype,
        bsark TYPE salv_de_selopt_low,
      END OF ty_potype,
      BEGIN OF ty_potype_t176,
        bsark TYPE bsark,
      END OF ty_potype_t176.
* EOC: CR#7764 KKRAVURI20190128  ED2K914344

TYPES: BEGIN OF ty_output_x,
         vkorg    TYPE vkorg,              "Sales Organization
         vtweg    TYPE vtweg,              "Distribution Channel
         spart    TYPE spart,              "Division
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
         bsark    TYPE bsark,              "Customer purchase order type
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
         datab    TYPE datab,              "Valid-From Date
         datbi    TYPE datbi,              "Valid To Date
         matnr    TYPE matnr,              "Material / Product
         prctr    TYPE prctr,              "Profit Center
         kunnr    TYPE kunnr,              "Customer
         kvgr1    TYPE kvgr1,              "Customer Group
* BOC: CR#7764 KKRAVURI20190108  ED2K913679
         zship_to TYPE zship_to,           "Ship-to party
* EOC: CR#7764 KKRAVURI20190108  ED2K913679
         pstlz_f  TYPE zzpstlz_f,          "Postal Code (From)
         pstlz_t  TYPE zzpstlz_t,          "Postal Code (To)
         regio    TYPE regio,              "Region
         land1    TYPE land1,              "Country
         srep1    TYPE zzsrep1,            "Sales Rep-1
         srep2    TYPE zzsrep2,            "Sales Rep-2
         aenam    TYPE aenam,              "Name of Person Who Changed Object
         aedat    TYPE aedat,              "Changed On
         aezet    TYPE aezet,              "Time last change was made
         delete   TYPE char1,              "Delete
         flag     TYPE num4,               "Success/Unsuccessful.
         message  TYPE char200,            "Message
       END OF ty_output_x.

TYPES: tt_excel       TYPE STANDARD TABLE OF ty_excel,
       tt_output_x    TYPE STANDARD TABLE OF ty_output_x,
       tt_final       TYPE STANDARD TABLE OF ty_final,
* BOC: CR#7764 KKRAVURI20190128  ED2K914344
       tt_potype      TYPE STANDARD TABLE OF ty_potype,
       tt_potype_t176 TYPE STANDARD TABLE OF ty_potype_t176.
* EOC: CR#7764 KKRAVURI20190128  ED2K914344

DATA: i_final       TYPE STANDARD TABLE OF ty_excel,
      i_display     TYPE STANDARD TABLE OF ty_final,
      st_display    TYPE ty_final,
      i_output_x    TYPE tt_output_x,
      st_output_x   TYPE ty_output_x,
      st_final_x    TYPE ty_excel,
*** BOC: CR#7764  KKRAVURI20190128  ED2K914344
      i_expiry      TYPE STANDARD TABLE OF zqtc_repdet INITIAL SIZE 0,
      i_potype      TYPE tt_potype,
      i_potype_t176 TYPE tt_potype_t176.
*** BOC: CR#7764  KKRAVURI20190128  ED2K914344

DATA: i_tvko        TYPE STANDARD TABLE OF ty_tvko,
      st_tvko       TYPE ty_tvko,
      i_tvtw        TYPE STANDARD TABLE OF ty_tvtw,
      st_tvtw       TYPE ty_tvtw,
      i_tspa        TYPE STANDARD TABLE OF ty_tspa,
      st_tspa       TYPE ty_tspa,
      i_mvke        TYPE STANDARD TABLE OF ty_mvke,
      st_mvke       TYPE ty_mvke,
      i_cepc        TYPE STANDARD TABLE OF ty_cepc,
      st_cepc       TYPE ty_cepc,
      i_kna1        TYPE STANDARD TABLE OF ty_kna1,
      st_kna1       TYPE ty_kna1,
      i_knvv        TYPE STANDARD TABLE OF ty_knvv,
      i_shipto      TYPE STANDARD TABLE OF ty_knvv, " ADD: CR#7764  KKR20190127  ED2K914321
      st_knvv       TYPE ty_knvv,
      i_tvv1        TYPE STANDARD TABLE OF ty_tvv1,
      st_tvv1       TYPE ty_tvv1,
      i_t005s       TYPE STANDARD TABLE OF ty_t005s,
      st_t005s      TYPE ty_t005s,
      i_t005        TYPE STANDARD TABLE OF ty_t005,
      st_t005       TYPE ty_t005,
      i_pa0003      TYPE STANDARD TABLE OF ty_pa0003,
      i_zqtc_repdet TYPE TABLE OF ty_final.

DATA: st_fcat_out TYPE slis_fieldcat_alv,
      i_fcat_out  TYPE slis_t_fieldcat_alv,
      st_layout   TYPE slis_layout_alv.

DATA: v_reason TYPE char50.


CONSTANTS : c_x         TYPE char1   VALUE 'X',
            c_lock_md_e TYPE enqmode VALUE 'E',                   "Lock indicator
            c_z1        TYPE char2   VALUE 'Z1',
            c_1         TYPE char1   VALUE '1',
            c_2         TYPE char1   VALUE '2',
            c_3         TYPE char1   VALUE '3',
            c_4         TYPE char1   VALUE '4',
            c_asc       TYPE char10  VALUE 'ASC',
            c_i         TYPE char1   VALUE '|',
            c_00        TYPE i VALUE '00',
            c_col_1     TYPE i VALUE '1',
            c_row_2     TYPE i VALUE '2',
            c_col_18    TYPE i VALUE '18',
            c_row_9999  TYPE i VALUE '1000',
            c_000000    TYPE char6 VALUE '000000',
* BOC: CR#7764 KKRAVURI20190128  ED2K914344
            c_param1    TYPE rvari_vnam VALUE 'PO_TYPE',
            c_param2    TYPE rvari_vnam VALUE 'BSARK',
            c_devid     TYPE zdevid     VALUE 'E129'.
* EOC: CR#7764 KKRAVURI20190128  ED2K914344
