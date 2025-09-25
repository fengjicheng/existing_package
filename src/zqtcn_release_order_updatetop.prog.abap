*&---------------------------------------------------------------------*
*&  Include           ZQTCR_RELEASE_ORDER_UPDATETOP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_RELEASE_ORDER_UPDATE                             *
* PROGRAM DESCRIPTION: This program will update the Reject Reason      *
*                      for release orders of Credit Memo for which     *
*                      reason for rejection is updated                 *
* DEVELOPER      : Rajkumar Madavoina (MRAJKUMAR)                      *
* CREATION DATE  : 04/05/2021                                          *
* OBJECT ID      : E267                                                *
* TRANSPORT NUMBER(S): ED2K923233                                      *
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Tables Declaration.
* ---------------------------------------------------------------------*

TABLES: vbak, vbfa, vbap,veda.

*----------------------------------------------------------------------*
* TYPES DECLARATIONS
* ---------------------------------------------------------------------*
TYPES: BEGIN OF ty_vbak,
         vbeln          TYPE  vbak-vbeln,
         posnr          TYPE  vbap-posnr,
         auart          TYPE  vbak-auart,
         contract_id    TYPE  vbfa-vbelv,
         contract_item  TYPE  vbfa-posnv,
         release_order  TYPE  vbfa-vbeln,
         rel_ord_item   TYPE  vbfa-posnn,
         rel_ord_typ    TYPE  vbak-auart,
         aedat          TYPE  vbap-aedat,
         pstyv          TYPE  vbap-pstyv,
         abgru          TYPE  vbap-abgru,
         augru          TYPE  vbak-augru,
       END OF ty_vbak,

       BEGIN OF ty_display,
         contract TYPE vbap-vbeln,
         vbeln   TYPE vbap-vbeln,
         posnr   TYPE vbap-posnr,
         status  TYPE char10,
         message TYPE char250_d,
       END OF ty_display.
*----------------------------------------------------------------------*
* Internal Table Declarations
* ---------------------------------------------------------------------*
DATA: i_orders  TYPE STANDARD TABLE OF ty_vbak,
      i_orders2 TYPE STANDARD TABLE OF ty_vbak,
      i_display TYPE STANDARD TABLE OF ty_display.
*----------------------------------------------------------------------*
* Data Declarations
* ---------------------------------------------------------------------*
* Data declaration
DATA : i_return      TYPE STANDARD TABLE OF bapiret2,                                  " Return table
*       i_return      TYPE bapiret2_t,                                  " Return table
       i_bapisditmx  TYPE STANDARD TABLE OF bapisditmx INITIAL SIZE 0, " Communication Fields: Sales and Distribution Document Item
       i_bapisditm   TYPE STANDARD TABLE OF bapisditm  INITIAL SIZE 0, " Communication Fields: Sales and Distribution Document Item
       i_sales_contract_in   TYPE STANDARD TABLE OF bapictr ,   " Internal  table for cond
       i_item_all    TYPE  STANDARD TABLE OF bapisdit INITIAL SIZE 0,
       i_bdcdata     TYPE STANDARD TABLE OF bdcdata,
       i_messtab     TYPE STANDARD TABLE OF bdcmsgcoll,
       gv_messtab    TYPE bdcmsgcoll,
       gv_sales_contract_in  TYPE REF TO  bapictr ,             " contract data
       i_sales_contract_inx TYPE  STANDARD TABLE OF bapictrx , " Communication fields: SD Contract Data Checkbox
       gv_sales_contract_inx  TYPE REF TO  bapictrx ,            " Communication fields: SD Contract Data Checkbox
*       gv_bapisdh1x  TYPE bapisdh1x,                                   " Checkbox List: SD Order Header
       gv_bapisdh1x  TYPE bapisdhd1x,                                   " Checkbox List: SD Order Header
       gv_header     TYPE bapisdhead1,
       gv_header_inx TYPE bapisdhead1x,
       gv_bapisditm  TYPE bapisditm,                                   " Communication Fields: Sales and Distribution Document Item
       gv_bapisditmx TYPE bapisditmx,                                  " Communication Fields: Sales and Distribution Document Item
       gv_display    TYPE ty_display,
       gv_alv        TYPE REF TO cl_salv_table,
       gv_func       TYPE REF TO cl_salv_functions,
       gr_pstyv      TYPE TABLE OF rjksd_pstyv_range,
       gv_pstyv      TYPE rjksd_pstyv_range,
       gr_augru      TYPE TABLE OF rjksd_augru_range,
       gv_augru      TYPE rjksd_augru_range,
       gv_abgru      TYPE vbap-abgru,
       gr_auart      TYPE TABLE OF edm_auart_range,
       gr_rel_ord_typ  TYPE TABLE OF edm_auart_range,
       gr_bwart        TYPE TABLE OF bwart_range,
       gv_bwart        TYPE bwart_range,
       gv_rel_ord_typ TYPE edm_auart_range,
       gv_auart      TYPE edm_auart_range,
       gv_zcainterface TYPE zcainterface,
       gv_vkuesch      TYPE veda-vkuesch,
       gv_vkuegru      TYPE veda-vkuegru,
       gv_order        TYPE mds_sales_key_tab,
       gv_view         TYPE order_view,
       gv_bdcdata      TYPE bdcdata,
       gv_date         TYPE char10,
       gv_bdclogic     TYPE flag,
       gv_contract     TYPE vbak-vbeln.

*----------------------------------------------------------------------*
* Constants
* ---------------------------------------------------------------------*

CONSTANTS: gc_g       TYPE c LENGTH 1 VALUE 'G',
           gc_c       TYPE c LENGTH 1 VALUE 'C',
           gc_e       TYPE c LENGTH 1 VALUE 'E',
           gc_eq      TYPE c LENGTH 2 VALUE 'EQ',
           gc_bt      TYPE c LENGTH 2 VALUE 'BT',
           gc_i       TYPE c LENGTH 1 VALUE 'I',
           gc_z4      TYPE c LENGTH 2 VALUE 'Z4',
           gc_update  TYPE updkz_d    VALUE 'U',    " Update indicator
           gc_success TYPE c LENGTH 7 VALUE 'SUCCESS',
           gc_devid   TYPE zdevid     VALUE 'E267',
           gc_error   TYPE c LENGTH 7 VALUE 'ERROR',
           gc_pstyv   TYPE c LENGTH 5 VALUE 'PSTYV',
           gc_abgru   TYPE c LENGTH 5 VALUE 'ABGRU',
           gc_augru   TYPE c LENGTH 5 VALUE 'AUGRU',
           gc_auart   TYPE c LENGTH 5 VALUE 'AUART',
           gc_vkuegru TYPE c LENGTH 7 VALUE 'VKUEGRU',
           gc_vkuesch TYPE c LENGTH 7 VALUE 'VKUESCH',
           gc_runtime TYPE rvari_vnam VALUE 'LAST RUNDATE',
           gc_bdclogic TYPE c LENGTH 9 VALUE 'BDC LOGIC',
           gc_bwart    TYPE c LENGTH 5 VALUE 'BWART',
           gc_rel_ord_typ TYPE c LENGTH 11 VALUE 'REL_ORD_TYP'.
