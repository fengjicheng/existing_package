*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_JPAT_REPORT_EXTEND_TOP (Data Declaration)
* PROGRAM DESCRIPTION: All the global data declarations
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* CREATION DATE:   09/12/2019
* WRICEF ID:       R090
* TRANSPORT NUMBER(S):  ED2K916156

* REVISION HISTORY-----------------------------------------------------*
* Transport NO: ED2K916403
* REFERENCE NO: ERPM-1825
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  10/08/2019
* DESCRIPTION:
*
* Transport NO: ED2K916608
* REFERENCE NO: ERPM-5295
* DEVELOPER: Lahiru Wathudura (LWATHUDURA)
* DATE:  11/20/2019
* DESCRIPTION:
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
TYPE-POOLS: sscr.

TABLES : mara,
         vbak,
         vbap,
         zcds_jpat_marcm,
         t54c6,
         tfacs.

INCLUDE <cl_alv_control>.
INCLUDE <icon>.

*********** Begin of Detailed report data declaration *******

TYPES: BEGIN OF ty_constant,
         devid    TYPE zdevid,              "Development ID
         param1   TYPE rvari_vnam,          "Parameter1
         param2   TYPE rvari_vnam,          "Parameter2
         srno     TYPE tvarv_numb,          "Serial Number
         sign     TYPE tvarv_sign,          "Sign
         opti     TYPE tvarv_opti,          "Option
         low      TYPE salv_de_selopt_low,  "Low
         high     TYPE salv_de_selopt_high, "High
         activate TYPE zconstactive,        "Active/Inactive Indicator
       END OF ty_constant.

TYPES : BEGIN OF ty_view,
          media_issue TYPE zcds_jpat_marcm-media_issue,
        END OF ty_view.

TYPES: BEGIN OF ty_const,
         param1 TYPE zqtc_mnt_r090-param1,     " Parameter1
         param2 TYPE zqtc_mnt_r090-param2,     " Parameter2
         srno   TYPE zqtc_mnt_r090-srno,       " Serial Number
         sign   TYPE zqtc_mnt_r090-sign,       " Sign
         opti   TYPE zqtc_mnt_r090-opti,       " Option
         low    TYPE zqtc_mnt_r090-low,        " Low
         high   TYPE zqtc_mnt_r090-high,       " High
         flag   TYPE zqtc_mnt_r090-flag,       " Flag
       END OF ty_const.

TYPES : BEGIN OF ty_auart,         " for sold to customer nad partner function from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE auart,         " Partner Function
          high TYPE auart,         " Partner Function
        END OF ty_auart.

TYPES : BEGIN OF ty_vkaus,         " for sold to customer nad partner function from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE vkaus,         " Partner Function
          high TYPE vkaus,         " Partner Function
        END OF ty_vkaus.

TYPES : BEGIN OF ty_biosdetail,
          media_issue          TYPE zcds_jpat_bios-media_issue,
          adustment_type       TYPE zcds_jpat_bios-adustment_type,
          bios_quantity        TYPE zcds_jpat_bios-bios_quantity,
          act_publication_date TYPE zcds_jpat_bios-act_publication_date,
        END OF ty_biosdetail.

TYPES : BEGIN OF ty_jdrdetail,
          media_issue          TYPE zcds_jpat_jdr-media_issue,
          jdr_quantity         TYPE zcds_jpat_jdr-jdr_quantity,
          act_publication_date TYPE zcds_jpat_jdr-act_publication_date,
          adustment_type       TYPE zcds_jpat_jdr-adustment_type,          " New Adding with TR :ED2K916403
        END OF ty_jdrdetail.

TYPES : BEGIN OF ty_podetail,
          material             TYPE zcds_jpat_po_dt-material,
          act_publication_date TYPE zcds_jpat_po_dt-act_publication_date,
          po_type              TYPE zcds_jpat_po_dt-po_type,
          tracking_no          TYPE zcds_jpat_po_dt-tracking_no,
          po_qty               TYPE zcds_jpat_po_dt-po_qty,
          po_number            TYPE zcds_jpat_po_dt-po_number,
          item                 TYPE zcds_jpat_po_dt-item,
          company_code         TYPE zcds_jpat_po_dt-company_code,
          created_date         TYPE zcds_jpat_po_dt-created_date,
          document_date        TYPE zcds_jpat_po_dt-document_date,
          vendor               TYPE zcds_jpat_po_dt-vendor,
          plant                TYPE zcds_jpat_po_dt-plant,
          account_assignment   TYPE zcds_jpat_po_dt-account_assignment,
          created_by           TYPE zcds_jpat_po_dt-created_by,
          deletion_indicator   TYPE zcds_jpat_po_dt-deletion_indicator,
        END OF ty_podetail.

TYPES : BEGIN OF ty_salesdetail,
          media_issue             TYPE zcds_jpat_saldt-media_issue,
          document_type           TYPE zcds_jpat_saldt-document_type,
          document_type_desc      TYPE zcds_jpat_saldt-document_type_desc,
          item_category           TYPE zcds_jpat_saldt-item_category,
          target_qty              TYPE zcds_jpat_saldt-target_qty,
          document_number         TYPE zcds_jpat_saldt-document_number,
          act_pub_date            TYPE zcds_jpat_saldt-act_pub_date,
          item                    TYPE zcds_jpat_saldt-item,
          su                      TYPE zcds_jpat_saldt-su,
          reference_document      TYPE zcds_jpat_saldt-reference_document,
          reference_document_type TYPE zcds_jpat_saldt-reference_document_type,
          subs_sales_order        TYPE zcds_jpat_saldt-subs_sales_order,
          refitm                  TYPE zcds_jpat_saldt-refitm,
          condition_group_4       TYPE zcds_jpat_saldt-condition_group_4,
          free_not_free           TYPE zcds_jpat_saldt-free_not_free,  " ZFREE_NOT_FREE
          created_date            TYPE zcds_jpat_saldt-created_date,
          created_by              TYPE zcds_jpat_saldt-created_by,
          sales_organization      TYPE zcds_jpat_saldt-sales_organization,
          material_grp_5          TYPE zcds_jpat_saldt-material_grp_5,
          rejection_reason        TYPE zcds_jpat_saldt-rejection_reason,
          schedule_line_type      TYPE zcds_jpat_saldt-schedule_line_type,
        END OF ty_salesdetail.

TYPES : BEGIN OF ty_sohdetail,
          media_issue          TYPE zcds_jpat_soh-media_issue,
          soh_qty              TYPE zcds_jpat_soh-soh_qty,
          act_publication_date TYPE zcds_jpat_soh-act_publication_date,
        END OF ty_sohdetail.

TYPES : BEGIN OF ty_potype,         " for sold to customer nad partner function from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE bsart,         " Doc type
          high TYPE bsart,         " Doc type
        END OF ty_potype.

TYPES : BEGIN OF ty_acccat,         " for sold to customer nad partner function from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE knttp,         " account ass.cat
          high TYPE knttp,         " account ass.cat
        END OF ty_acccat.

TYPES : BEGIN OF ty_bstyp,         " for sold to customer nad partner function from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE bstyp,         " doc category
          high TYPE bstyp,         " doc category
        END OF ty_bstyp.

** Begin of changes for ED2K916403.
TYPES : BEGIN OF ty_isohdetail,
          media_issue          TYPE zcds_jpat_isoh-media_issue,
          inital_soh_quantity  TYPE zcds_jpat_isoh-inital_soh_quantity,
          act_publication_date TYPE zcds_jpat_isoh-act_publication_date,
        END OF ty_isohdetail.

TYPES : BEGIN OF ty_jrrdetail,
          media_issue          TYPE zcds_jpat_jrr-media_issue,
          adustment_type       TYPE zcds_jpat_jrr-adustment_type,
          jrr_quantity         TYPE zcds_jpat_jrr-jrr_quantity,
          act_publication_date TYPE zcds_jpat_jrr-act_publication_date,
          ordered_print_run    TYPE zcds_jpat_jrr-ordered_print_run,
        END OF ty_jrrdetail.
** End of Changes for ED2K916403.

** Begin of changes for ED2K916608 ***.
TYPES : BEGIN OF ty_month,         " for sold to customer nad partner function from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE month,         " Month
          high TYPE month,         " Month
        END OF ty_month.

TYPES : BEGIN OF ty_year,         " for sold to customer nad partner function from VBPA
          sign TYPE tvarv_sign,    " ABAP: ID: I/E (include/exclude values)
          opti TYPE tvarv_opti,    " ABAP: Selection option (EQ/BT/CP/...)
          low  TYPE kjahr,         " Year
          high TYPE kjahr,         " year
        END OF ty_year.

TYPES  : BEGIN OF ty_printerdis,
           media_issue  TYPE zcds_po_jrr_dt-media_issue,
           act_pub_date TYPE zcds_po_jrr_dt-act_pub_date,
           po_qty       TYPE zcds_po_jrr_dt-po_qty,
           jrr_qty      TYPE zcds_po_jrr_dt-jrr_qty,
           po_dispatch  TYPE zcds_po_jrr_dt-po_dispatch,
         END OF ty_printerdis.
*** End of changes for ED2K916608 ***.


DATA : i_constant TYPE STANDARD TABLE OF ty_constant.
FIELD-SYMBOLS : <gfs_constant> TYPE ty_constant.

DATA : i_view TYPE STANDARD TABLE OF ty_view.                           " Itab for custom material routine

DATA : i_view_podetail    TYPE STANDARD TABLE OF ty_podetail INITIAL SIZE 0,           " Itab for PO detail data
       i_view_biosdetail  TYPE STANDARD TABLE OF ty_biosdetail INITIAL SIZE 0,         " Itab for BIOS detail data.
       i_view_jdrdetail   TYPE STANDARD TABLE OF ty_jdrdetail INITIAL SIZE 0,          " Itab for JDR Detail
       i_view_salesdetail TYPE STANDARD TABLE OF ty_salesdetail INITIAL SIZE 0,        " Itab for Sales Detail
       i_view_sohdetail   TYPE STANDARD TABLE OF ty_sohdetail INITIAL SIZE 0,          " Itab for SOH data
** Begin of changes for ED2K916403.
       i_view_isohdetail  TYPE STANDARD TABLE OF ty_isohdetail INITIAL SIZE 0,        " Itab for Initial SOH data
       i_view_jrrdetail   TYPE STANDARD TABLE OF ty_jrrdetail INITIAL SIZE 0,         " Itab for JRR detail data
       i_view_printedis   TYPE STANDARD TABLE OF ty_printerdis INITIAL SIZE 0.
** End of changes for ED2K916403.

*** Begin of changes for ED2K916608 ***.
DATA : i_sel_month TYPE STANDARD TABLE OF ty_month INITIAL SIZE 0,             " Itab for selection screen month
       i_sel_year  TYPE STANDARD TABLE OF ty_year  INITIAL SIZE 0.             " Itab for selection screen Year
*** End of changes for ED2K916608 ***.


FIELD-SYMBOLS : <gfs_podetail>    TYPE ty_podetail,                     " Field symbols for PO detail data
                <gfs_biosdetail>  TYPE ty_biosdetail,                   " Field symbols for BIOS detail data
                <gfs_jdrdetail>   TYPE ty_jdrdetail,                    " Field symbols for JDR detail data
                <gfs_salesdetail> TYPE ty_salesdetail,                  " Field symbols for sales detail data
                <gfs_sohdetail>   TYPE ty_sohdetail,                    " Field symbols for SOH detail data
** Begin of changes for ED2K916403 ***
                <gfs_isohdetail>  TYPE ty_isohdetail,                   " Field symbols for Intial SOH detail data
                <gfs_jrrdetail>   TYPE ty_jrrdetail,                    " Field symbols for JRR detail data
                <gfs_prdisdetail> TYPE ty_printerdis.
** End of changes for ED2K916403 ***

DATA : i_const           TYPE STANDARD TABLE OF ty_const,                         " Itab for constant table
       v_year(4)         TYPE n,
       v_month           TYPE month,
       v_selection_month TYPE month,
       v_selection_year  TYPE kjahr.

DATA : ok_code TYPE sy-ucomm.
CONTROLS tabcontrol TYPE TABSTRIP.

DATA: st_layout  TYPE lvc_s_layo.

DATA: i_fieldcat_podetail     TYPE STANDARD TABLE OF lvc_s_fcat,        " Fieldcat for Podetail
      st_fieldcat_podetail    TYPE lvc_s_fcat,
      i_fieldcat_biosdetail   TYPE STANDARD TABLE OF lvc_s_fcat,        " Fieldcat for biosdetail
      st_fieldcat_biosdetail  TYPE lvc_s_fcat,
      i_fieldcat_jdrdetail    TYPE STANDARD TABLE OF lvc_s_fcat,        " Fieldcat for jdrdetail
      st_fieldcat_jdrdetail   TYPE lvc_s_fcat,
      i_fieldcat_salesdetail  TYPE STANDARD TABLE OF lvc_s_fcat,        " Fieldcat for salesdetail
      st_fieldcat_salesdetail TYPE lvc_s_fcat,
      i_fieldcat_sohdetail    TYPE STANDARD TABLE OF lvc_s_fcat,        " Fieldcat for SOH detail
      st_fieldcat_sohdetail   TYPE lvc_s_fcat,
*** Begin of changes for  ED2K916403 ***
      i_fieldcat_isohdetail   TYPE STANDARD TABLE OF lvc_s_fcat,        " Fieldcat for Initial SOH detail
      st_fieldcat_isohdetail  TYPE lvc_s_fcat,
      i_fieldcat_jrrdetail    TYPE STANDARD TABLE OF lvc_s_fcat,        " Fieldcat for JRR detail
      st_fieldcat_jrrdetail   TYPE lvc_s_fcat,
      i_fieldcat_prdisdetail  TYPE STANDARD TABLE OF lvc_s_fcat,        " Fieldcat for Printer Dispatch detail
      st_fieldcat_prdisdetail TYPE lvc_s_fcat.
*** End of changes for  ED2K916403 ***

" Custom Container mapping
DATA: v_detail_con_podetail    TYPE scrfname VALUE 'CC_PODETAIL',
      v_detail_con_biosdetail  TYPE scrfname VALUE 'CC_BIOSDETAIL',
      v_detail_con_jdrdetail   TYPE scrfname VALUE 'CC_JDRDETAIL',
      v_detail_con_salesdetail TYPE scrfname VALUE 'CC_SALESDETAIL',
      v_detail_con_sohdetail   TYPE scrfname VALUE 'CC_SOHDETAIL',
*** Begin of changes for  ED2K916403 ***
      v_detail_con_isohdetail  TYPE scrfname VALUE 'CC_ISOHDETAIL',
      v_detail_con_jrrdetail   TYPE scrfname VALUE 'CC_JRRDETAIL',
      v_detail_con_prdispatch  TYPE scrfname VALUE 'CC_PRDISDETAIL'.
*** End of changes for  ED2K916403 ***


" Custom container declaration
DATA: v_detail_cc_podetail    TYPE REF TO cl_gui_custom_container,
      v_detail_cc_biosdetail  TYPE REF TO cl_gui_custom_container,
      v_detail_cc_jdrdetail   TYPE REF TO cl_gui_custom_container,
      v_detail_cc_salesdetail TYPE REF TO cl_gui_custom_container,
      v_detail_cc_sohdetail   TYPE REF TO cl_gui_custom_container,
*** Begin of changes for  ED2K916403 ***
      v_detail_cc_isohdetail  TYPE REF TO cl_gui_custom_container,
      v_detail_cc_jrrdetail   TYPE REF TO cl_gui_custom_container,
      v_detail_cc_prdispatch  TYPE REF TO cl_gui_custom_container.
*** End of changes for  ED2K916403 ***

DATA : v_detail_grid     TYPE REF TO cl_gui_alv_grid.                        " Declaration for ALV grid

CONSTANTS : c_pubdate TYPE zcds_jpat_marcm-act_pub_date VALUE '00000000',    " Actual publication date = blank
            c_active  TYPE char1    VALUE 'X'.                               " Constant table active flag

DATA: v_excel       TYPE ole2_object,
      v_wbooklist   TYPE ole2_object,
      v_application TYPE ole2_object,
      v_wbook       TYPE ole2_object,
      v_activesheet TYPE ole2_object,
      v_cell1       TYPE ole2_object,
      v_cell2       TYPE ole2_object,
      v_cells       TYPE ole2_object,
      v_f           TYPE ole2_object, " font
      v_interior    TYPE ole2_object,
      v_borders     TYPE ole2_object,
      v_range       TYPE ole2_object,
      v_sheets      TYPE ole2_object,
      v_worksheet   TYPE ole2_object.

DATA: v_rowindx TYPE i,
      v_colindx TYPE i.

*********** Data declaration forExcel download with clipboard copy option ***********

*TYPES: tt_convertdata(1500) TYPE c,
*       ty_convertdata       TYPE TABLE OF tt_convertdata.
*
*DATA: i_podetail_excel    TYPE ty_convertdata WITH HEADER LINE,
*      i_biosdetail_excel  TYPE ty_convertdata WITH HEADER LINE,
*      i_jdrdetail_excel   TYPE ty_convertdata WITH HEADER LINE,
*      i_salesdetail_excel TYPE ty_convertdata WITH HEADER LINE,
*      i_sohdetail_excel   TYPE ty_convertdata WITH HEADER LINE.

TYPES : BEGIN OF ty_convertdata,
          convertdata(1500) TYPE c,
        END OF ty_convertdata.

DATA : i_podetail_excel    TYPE TABLE OF ty_convertdata,
       i_biosdetail_excel  TYPE TABLE OF ty_convertdata,
       i_jdrdetail_excel   TYPE TABLE OF ty_convertdata,
       i_salesdetail_excel TYPE TABLE OF ty_convertdata,
       i_sohdetail_excel   TYPE TABLE OF ty_convertdata,
*** Begin of changes for ED2K916403 ***
       i_isohdetail_excel  TYPE TABLE OF ty_convertdata,
       i_jrrdetail_excel   TYPE TABLE OF ty_convertdata,
       i_prnterdis_excel   TYPE TABLE OF ty_convertdata.
*** End of changes for ED2K916403 ***

DATA : stconvertdata_excel TYPE ty_convertdata.

DATA : v_index  TYPE i,
       v_row    TYPE string,
       v_first  TYPE string,
       v_second TYPE string,
       v_third  TYPE string,
       v_fourth TYPE string,
       v_deli   TYPE char1.

v_deli = cl_abap_char_utilities=>horizontal_tab.

DATA : v_rc TYPE i.

*********** End of Summary report data declaration *******

*********** Begin of Summary report data declaration *******

TYPES : BEGIN OF ty_salsum,                                                 " Sales summary data type
          act_pub_year       TYPE zcds_jpat_salsum-act_pub_year,
          act_pub_month      TYPE zcds_jpat_salsum-act_pub_month,
          document_type_desc TYPE zcds_jpat_salsum-document_type_desc,
          subs_sales_order   TYPE zcds_jpat_salsum-subs_sales_order,
          back_main_orders   TYPE zcds_jpat_salsum-back_main_orders,
          free_not_free      TYPE zcds_jpat_salsum-free_not_free,
          document_type      TYPE zcds_jpat_salsum-document_type,
          item_category      TYPE zcds_jpat_salsum-item_category,
          usage_type         TYPE zcds_jpat_salsum-usage_type,
          target_qty         TYPE zcds_jpat_salsum-target_qty,
        END OF ty_salsum.

TYPES : BEGIN OF ty_posum,                                                  " PO summary data type
          publication_year      TYPE zcds_jpat_po_sum-publication_year,
          publication_month     TYPE zcds_jpat_po_sum-publication_month,
          printer_po_conference TYPE zcds_jpat_po_sum-printer_po_conference,
        END OF ty_posum.

TYPES : BEGIN OF ty_sales_total,                                             " Subscription total
          act_pub_year  TYPE zcds_jpat_salsum-act_pub_year,
          act_pub_month TYPE zcds_jpat_salsum-act_pub_month,
          target_qty    TYPE  zcds_jpat_salsum-target_qty,
        END OF ty_sales_total,
        tt_sales TYPE STANDARD TABLE OF ty_salsum.

TYPES : BEGIN OF ty_nbpodetail,
          po_qty            TYPE zcds_jpat_po_dt-po_qty,
          publication_year  TYPE zcds_jpat_po_dt-publication_year,
          publication_month TYPE zcds_jpat_po_dt-publication_month,
        END OF ty_nbpodetail.

TYPES : BEGIN OF ty_nbposum,
          publication_year  TYPE zcds_jpat_po_dt-publication_year,
          publication_month TYPE zcds_jpat_po_dt-publication_month,
          po_qty            TYPE zcds_jpat_po_dt-po_qty,
        END OF ty_nbposum.

*** Begin of changes for ED2K916403 ***
TYPES : BEGIN OF ty_jrrsum,
          publication_year  TYPE zcds_jpat_jrrsm-publication_year,
          publication_month TYPE zcds_jpat_jrrsm-publication_month,
          jrr_quantity      TYPE zcds_jpat_jrrsm-jrr_quantity,
        END OF ty_jrrsum.


TYPES : BEGIN OF ty_jdr_total,                                             " For JDR data summarization
          publication_year  TYPE zcds_jpat_jdrsum-publication_year,
          publication_month TYPE zcds_jpat_jdrsum-publication_month,
          jdr_quantity      TYPE zcds_jpat_jdrsum-jdr_quantity,
        END OF ty_jdr_total.

TYPES : BEGIN OF ty_bios_total,                                             " For BIOS data summarization
          publication_year  TYPE zcds_jpat_biossm-publication_year,
          publication_month TYPE zcds_jpat_biossm-publication_month,
          bios_quantity     TYPE zcds_jpat_biossm-bios_quantity,
        END OF ty_bios_total.

TYPES : BEGIN OF ty_po_total,                                                  " PO summary data type
          publication_year      TYPE zcds_jpat_po_sum-publication_year,
          publication_month     TYPE zcds_jpat_po_sum-publication_month,
          printer_po_conference TYPE zcds_jpat_po_sum-printer_po_conference,
        END OF ty_po_total.

TYPES : BEGIN OF ty_isoh_total,                                                  " Initial SOH summary data type
          publication_year    TYPE zcds_jpat_isohsm-publication_year,
          publication_month   TYPE zcds_jpat_isohsm-publication_month,
          inital_soh_quantity TYPE zcds_jpat_isohsm-inital_soh_quantity,
        END OF ty_isoh_total.

TYPES : BEGIN OF ty_soh_total,                                                  " SOH summary data type
          publication_year  TYPE zcds_jpat_sohsum-publication_year,
          publication_month TYPE zcds_jpat_sohsum-publication_month,
          soh_qty           TYPE zcds_jpat_sohsum-soh_qty,
        END OF ty_soh_total.

TYPES : BEGIN OF ty_jrr_total,
          publication_year  TYPE zcds_jpat_jrrsm-publication_year,
          publication_month TYPE zcds_jpat_jrrsm-publication_month,
          jrr_quantity      TYPE zcds_jpat_jrrsm-jrr_quantity,
        END OF ty_jrr_total.
*** End of changes for ED2K916403 ***

*** Begin of changes for ED2K916608 ***
TYPES : BEGIN OF ty_prdissum,
          publication_month TYPE zcds_po_jrr_lf-publication_month,
          publication_year  TYPE zcds_po_jrr_lf-publication_year,
          po_dispatch       TYPE zcds_po_jrr_lf-po_dispatch,
        END OF ty_prdissum.

TYPES : BEGIN OF ty_pdis_total,
          publication_year  TYPE zcds_po_jrr_lf-publication_year,
          publication_month TYPE zcds_po_jrr_lf-publication_month,
          po_dispatch       TYPE zcds_po_jrr_lf-po_dispatch,
        END OF ty_pdis_total.
*** End of changes for ED2K916608 ***

DATA : i_view_salsum   TYPE STANDARD TABLE OF ty_salsum INITIAL SIZE 0,
       i_view_jdrsum   TYPE STANDARD TABLE OF zcds_jpat_jdrsum INITIAL SIZE 0,
       i_view_biossum  TYPE STANDARD TABLE OF zcds_jpat_biossm INITIAL SIZE 0,
       i_view_posum    TYPE STANDARD TABLE OF ty_posum INITIAL SIZE 0,
       i_view_isohsm   TYPE STANDARD TABLE OF zcds_jpat_isohsm INITIAL SIZE 0,
       i_view_sohsum   TYPE STANDARD TABLE OF zcds_jpat_sohsum INITIAL SIZE 0,
       i_nbpodetail    TYPE STANDARD TABLE OF ty_nbpodetail INITIAL SIZE 0,
       i_view_jrrsum   TYPE STANDARD TABLE OF ty_jrrsum INITIAL SIZE 0,          " New adding with ED2K916403
       i_view_prdissum TYPE STANDARD TABLE OF ty_prdissum INITIAL SIZE 0.        " New adding with ED2K916608

*** Itab Declare for sales summary sub category orders
DATA  : is_subs_total         TYPE SORTED TABLE OF ty_sales_total WITH UNIQUE KEY act_pub_year act_pub_month INITIAL SIZE 0,
        is_author_copies_main TYPE SORTED TABLE OF ty_sales_total WITH UNIQUE KEY act_pub_year act_pub_month INITIAL SIZE 0,
        is_author_copies_back TYPE SORTED TABLE OF ty_sales_total WITH UNIQUE KEY act_pub_year act_pub_month INITIAL SIZE 0,
        is_bulk_orders_main   TYPE SORTED TABLE OF ty_sales_total WITH UNIQUE KEY act_pub_year act_pub_month INITIAL SIZE 0,
        is_bulk_orders_back   TYPE SORTED TABLE OF ty_sales_total WITH UNIQUE KEY act_pub_year act_pub_month INITIAL SIZE 0,
        is_back_orders        TYPE SORTED TABLE OF ty_sales_total WITH UNIQUE KEY act_pub_year act_pub_month INITIAL SIZE 0,
        is_nbposumary         TYPE SORTED TABLE OF ty_nbposum     WITH UNIQUE KEY publication_year publication_month INITIAL SIZE 0,
*** Begin of changes for ED2K916403 ***
        is_jdrsum             TYPE SORTED TABLE OF ty_jdr_total   WITH UNIQUE KEY publication_year publication_month INITIAL SIZE 0,
        is_biossum            TYPE SORTED TABLE OF ty_bios_total  WITH UNIQUE KEY publication_year publication_month INITIAL SIZE 0,
        is_posum              TYPE SORTED TABLE OF ty_po_total    WITH UNIQUE KEY publication_year publication_month INITIAL SIZE 0,
        is_ishosum            TYPE SORTED TABLE OF ty_isoh_total  WITH UNIQUE KEY publication_year publication_month INITIAL SIZE 0,
        is_shosum             TYPE SORTED TABLE OF ty_soh_total   WITH UNIQUE KEY publication_year publication_month INITIAL SIZE 0,
        is_jrrsum             TYPE SORTED TABLE OF ty_jrr_total   WITH UNIQUE KEY publication_year publication_month INITIAL SIZE 0,
*** End of changes for ED2K916403 ***
*** Begin  of changes for ED2K916608 ***
        is_pdissum            TYPE SORTED TABLE OF ty_pdis_total  WITH UNIQUE KEY publication_year publication_month INITIAL SIZE 0.
*** End of changes for ED2K916608 ***

TYPES : r_year TYPE char4.

" Range variable declaration
DATA : ir_year   TYPE RANGE OF r_year,      " Publication Year
       ir_potype TYPE RANGE OF ekko-bsart,  " PO Doc type
       ir_acccat TYPE RANGE OF ekpo-knttp,  " Account asignment category
       ir_bstyp  TYPE RANGE OF ekko-bstyp.  " Doc category

DATA : v_previousyear(4) TYPE n.

TYPES: BEGIN OF ty_summary_data,
         field01(10),
         field02(61),
         field03(61),
         field04(61),
         field05(61),
         field06(61),
         field07(61),
         field08(61),
         field09(61),
         field10(61),
         field11(61),
         field12(61),
         field13(61),
         field14(61),
         field15(61),
         field16(61),
         field17(61),
         field18(61),
         field19(61),
         field20(61),
         field21(61),
         field22(61),
         field23(61),
         field24(61),
         field25(61),
         field26(61),
         field27(61),
         field28(61),
         field29(61),
         field30(61),
         field31(61),
         field32(61),
*** Begin of Change for  ED2K916403 ***
         field33(61),
         field34(61),
         field35(61),
         field36(61),
         field37(61),
         field38(61),
         field39(61),
*** End of Change for  ED2K916403 ***
       END OF ty_summary_data.

DATA : i_summary_data  TYPE STANDARD TABLE OF ty_summary_data.
FIELD-SYMBOLS :  <gfs_summary_data> TYPE ty_summary_data.

DATA : i_fieldcatalog  TYPE lvc_t_fcat,
       st_fieldcatalog TYPE lvc_t_fcat,
       st_cat          TYPE lvc_s_fcat.

DATA : v_summary_alv_grid TYPE REF TO zcl_gui_alv_grid_merge,        " Custom Class for ALV grid merge
       v_summary_grid     TYPE REF TO cl_gui_alv_grid.               " ALV grid class for data display

CLASS cl_gui_cfw DEFINITION LOAD.

DATA  : v_save     TYPE char01,                           " For Parameter I_SAVE
        st_variant TYPE disvariant,       " For parameter IS_VARIANT
        st_style   TYPE lvc_s_styl.

DATA : i_merge  TYPE lvc_t_co01,
       st_merge TYPE lvc_s_co01.

DATA : i_year  TYPE STANDARD TABLE OF ty_summary_data INITIAL SIZE 0,
       st_year TYPE ty_summary_data.

DATA: i_summary_excel  TYPE TABLE OF ty_convertdata.

DATA : v_headername TYPE char61,         " PO print header name Pass header name to excel file
       v_recname    TYPE bapibname-bapibname.

CONSTANTS : c_devid   TYPE zdevid   VALUE 'R090',
            c_x       TYPE char1    VALUE 'X',        "Active records
            c_errtype TYPE char1    VALUE 'E'.        "Error messege
*********** End of Summary report data declaration *******

*** Begin of Data declaration for Select option restriction ***

DATA: v_opt_list TYPE sscr_opt_list,
      v_restrict TYPE sscr_restrict,
      v_ass      TYPE sscr_ass.
*** End of Data declaration for Select option restriction ***
