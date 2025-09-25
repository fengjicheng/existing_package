FUNCTION-POOL zqtc_price_as.                "MESSAGE-ID ..

*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_AS_PRICE_SIMULATION_I0419                         *
* PROGRAM DESCRIPTION: This RFC will receive the request from AS       *
*                      through TIBCO, Once the request received in SAP *
*                      it will validate the data for price simulation  *
*                      and send the overall response.                  *
* DEVELOPER      : Ramesh N (RNARAYANAS)                               *
* CREATION DATE  : 24/03/2022                                          *
* OBJECT ID      : I0419                                               *
* TRANSPORT NUMBER(S):  ED2K926086, ED2K926565, ED2K927020,ED2K927355  *
*----------------------------------------------------------------------*


TYPES : BEGIN OF ty_s_as_desc,
          kschl TYPE kschl,
          desc  TYPE v_text,
        END OF ty_s_as_desc.


"Constants Declarations
CONSTANTS: c_00             TYPE vbak-vtweg    VALUE '00',
           c_000010         TYPE vbap-posnr    VALUE '000010',
           c_object         TYPE balobj_d      VALUE 'ZQTC',
           c_subobj         TYPE balsubobj     VALUE 'ZASOTC',
           c_msgtyp         TYPE symsgty       VALUE 'I',
           c_msgtyp_e       TYPE symsgty       VALUE 'E',
           c_msgid          TYPE symsgid       VALUE 'ZQTC_R2',
           c_msgno          TYPE symsgno       VALUE '000',
           c_slglogdays     TYPE rvari_vnam    VALUE 'SLGLOGSDAYS',
           c_customer       TYPE rvari_vnam    VALUE 'CUSTOMER',
           c_item_no        TYPE rvari_vnam    VALUE 'ITEM_NO',
           c_quantity       TYPE rvari_vnam    VALUE 'QUANTITY',
           c_sales_doc      TYPE rvari_vnam    VALUE 'SALES_DOC',
           c_uom            TYPE rvari_vnam    VALUE 'UOM',
           c_document_type  TYPE rvari_vnam    VALUE 'DOCUMENT_TYPE',
           c_manu_cond_type TYPE rvari_vnam    VALUE 'MANU_COND_TYPE',
           c_cond_type      TYPE rvari_vnam    VALUE 'COND_TYPE',
           c_as_desc        TYPE rvari_vnam    VALUE 'AS_DESC',
           c_zidn           TYPE kschl         VALUE 'ZIDN',
           c_zip1           TYPE kschl         VALUE 'ZIP1',
           c_zip2           TYPE kschl         VALUE 'ZIP2',
           c_ziv1           TYPE kschl         VALUE 'ZIV1',
           c_ziv2           TYPE kschl         VALUE 'ZIV2',
           c_std            TYPE piq_caller_id VALUE 'STD',
           c_devid          TYPE zdevid        VALUE 'I0419.1',
           c_i              TYPE selopt-sign   VALUE 'I',
           c_e              TYPE selopt-sign   VALUE 'E',
           c_eq             TYPE selopt-option VALUE 'EQ',
* BOC by Ramesh on 04/26/2022 for ASOTC-226(SIT defect) with ED2K927020  *
           c_digital        TYPE mara-ismmediatype VALUE 'DI'.
* EOC by Ramesh on 04/26/2022 for ASOTC-226(SIT defect) with ED2K927020  *

"Internal table declaration
DATA: i_itemdetails      TYPE zqtc_tt_price_itm,
      i_priceout         TYPE zqtc_tt_price_out,
      i_hdr              TYPE piqt_calculate_head,
      i_itm              TYPE piqt_calculate_item,
      i_result           TYPE piqt_calculate_result,
      i_caller_data_head TYPE piqt_name_value,
      i_caller_data_item TYPE piqt_name_value,
      i_varcond          TYPE piqt_calculate_item_varcond,
      i_message          TYPE bapirettab,
      i_constant         TYPE STANDARD TABLE OF zcaconstant,
      i_as_desc          TYPE TABLE OF ty_s_as_desc.

"Field structure declaration
DATA: st_itemdetails TYPE zqtc_st_price_itm,
      st_global      TYPE piqs_calculate_global,
      st_control     TYPE piqs_calculate_control_basic,
      st_caller_data TYPE piqs_name_value,
      st_priceout    TYPE zqtc_st_price_out,
      st_log_handle  TYPE balloghndl, " Application Log: Log Handle
      st_log         TYPE bal_s_log, " Application Log: Log header
      st_msg         TYPE bal_s_msg, " Application Log: Message
      st_hdrdet      TYPE zqtc_st_price_hdr,
      st_as_desc     TYPE ty_s_as_desc.

"Range declaration
DATA: ir_cond_type TYPE farr_tt_range_cond,
      ir_manu_type TYPE farr_tt_range_cond.

"Variable declaration
DATA: v_matnr      TYPE mara-matnr,
      v_date       TYPE aldate_del,
      v_days       TYPE i,
      v_flg_exec   TYPE c,
      v_slglogdays TYPE char3,
      v_kunnr      TYPE vbak-kunnr,
      v_vbeln      TYPE vbak-vbeln,
      v_qty        TYPE vbap-zmeng,
      v_posnr      TYPE vbap-posnr,
      v_uom        TYPE vbap-kmein,
      v_doc_type   TYPE vbak-auart,
      v_status     TYPE char10.

DATA: i_partner        TYPE STANDARD TABLE OF bapipartnr,
      i_conditions_ex  TYPE STANDARD TABLE OF  bapicond,
      i_items_in       TYPE STANDARD TABLE OF bapiitemin,
      st_header_in     TYPE bapisdhead,
      st_items_in      TYPE bapiitemin,
      st_conditions_ex TYPE bapicond,
      st_partner       TYPE bapipartnr,
      st_return        TYPE bapireturn,
      st_sold          TYPE bapisoldto,
      st_ship          TYPE bapishipto,
      st_bill          TYPE bapipayer.

"Instance creation
DATA io_err TYPE REF TO cx_root.
