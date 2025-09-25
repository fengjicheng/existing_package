*&---------------------------------------------------------------------*
*&  Include           ZRARR_SUBSCR_TOP
*&---------------------------------------------------------------------*

TABLES: vbak, vbap.

CONSTANTS: lc_raic_02        TYPE farr_raic      VALUE 'SD02',
           lc_wricef_id_e228 TYPE zdevid         VALUE 'E228',
           lc_prm_doc_type   TYPE rvari_vnam     VALUE 'DOCUMENT_TYPE',
           lc_prm_hkont      TYPE rvari_vnam     VALUE 'HKONT',
           lc_prm_gjahr      TYPE rvari_vnam     VALUE 'GJAHR',
           lc_prm_poper      TYPE rvari_vnam     VALUE 'POPER'.

DATA: lr_salv_table     TYPE REF TO cl_salv_table,
      lr_salv_table_h   TYPE REF TO cl_salv_table,
      lr_salv_table_it  TYPE REF TO cl_salv_table,
      lr_salv_table_cr  TYPE REF TO cl_salv_table,
      lr_salv_table_log TYPE REF TO cl_salv_table,
      lr_salv_toolbar   TYPE REF TO cl_salv_functions_list,
      lr_salv_aggrs     TYPE REF TO cl_salv_aggregations,
      lr_salv_sorts     TYPE REF TO cl_salv_sorts,
      lr_salv_cols      TYPE REF TO cl_salv_columns_table,
      lr_selections     TYPE REF TO cl_salv_selections,
      lr_events         TYPE REF TO cl_salv_events_table,
      lr_functions      TYPE REF TO cl_salv_functions_list,
      lv_pob_type       TYPE farr_pob_type,
      lv_vbeln          TYPE vbeln_va.

DATA: gt_customizing TYPE TABLE OF zcaconstant.

TYPES: BEGIN OF ty_output,
         vbeln_ord    TYPE vbeln,
         posnr_ord    TYPE posnr,
         pstyv_ord    TYPE pstyv,
         mat_ord      TYPE matnr,
         prctr_ord    TYPE prctr,
         bukrs_ord    TYPE bukrs,
         werks_ord    TYPE werks_ext,
         vbeln_rel    TYPE vbeln,
         posnr_rel    TYPE posnr,
         mat_rel      TYPE matnr,
         prctr_rel    TYPE prctr,
         bukrs_rel    TYPE bukrs,
         werks_rel    TYPE werks_ext,
         kwmeng_rel   TYPE kwmeng,
         reclas_amt   TYPE farr_original_price,
         reclas_cur   TYPE waers,
         kwmeng_rar   TYPE farr_quantity,
         alloc_rar    TYPE farr_alloc_amt,
         alloc_cur    TYPE waers,
         status_pob   TYPE string,
         status_pob_c TYPE farr_recon_key_status,
         status_gl    TYPE char15,
         status_gl_c  TYPE farr_recon_key_status,
         status_rec   TYPE string,
         created_rel  TYPE datum,
         recon_key    TYPE farr_recon_key,
         pob_id       TYPE farr_pob_id,
       END OF ty_output.

TYPES: BEGIN OF ty_output_r,
         vbeln_ord  TYPE vbeln,
         posnr_ord  TYPE posnr,
         pstyv_ord  TYPE pstyv,
         mat_ord    TYPE matnr,
         prctr_ord  TYPE prctr,
         bukrs_ord  TYPE bukrs,
         werks_ord  TYPE werks_ext,
         vbeln_rel  TYPE vbeln,
         posnr_rel  TYPE posnr,
         mat_rel    TYPE matnr,
         prctr_rel  TYPE prctr,
         bukrs_rel  TYPE bukrs,
         werks_rel  TYPE werks_ext,
         kwmeng_rel TYPE kwmeng,
         reclas_amt TYPE farr_original_price,
         reclas_cur TYPE waers,
         accdoc_c1  TYPE belnr_d,
         accdoc_c2  TYPE belnr_d,
         result     TYPE string,
       END OF ty_output_r.

TYPES: BEGIN OF ty_result,
         vbeln_ord  TYPE vbeln,
         posnr_ord  TYPE posnr,
         pstyv_ord  TYPE pstyv,
         mat_ord    TYPE matnr,
         prctr_ord  TYPE prctr,
         bukrs_ord  TYPE bukrs,
         werks_ord  TYPE werks_ext,
         vbeln_rel  TYPE vbeln,
         posnr_rel  TYPE posnr,
         mat_rel    TYPE matnr,
         prctr_rel  TYPE prctr,
         bukrs_rel  TYPE bukrs,
         werks_rel  TYPE werks_ext,
         kwmeng_rel TYPE kwmeng,
         reclas_amt TYPE farr_original_price,
         reclas_cur TYPE waers,
       END OF ty_result.

DATA: lv_objtype TYPE awtyp,
      lv_awref   TYPE awkey,
      lv_sysid   TYPE awsys.

DATA: ls_header      TYPE bapiache09,
      ls_accountgl   TYPE bapiacgl09,
      ls_receivable  TYPE bapiacar09,
      ls_payable     TYPE bapiacap09,
      ls_currencyamt TYPE bapiaccr09,
      ls_criteria    TYPE bapiackec9,
      ls_valuefield  TYPE bapiackev9.

DATA: lt_return      TYPE TABLE OF bapiret2,
      lt_accountgl   TYPE TABLE OF bapiacgl09,
      lt_receivable  TYPE TABLE OF bapiacar09,
      lt_payable     TYPE TABLE OF bapiacap09,
      lt_currencyamt TYPE TABLE OF bapiaccr09,
      lt_criteria    TYPE TABLE OF bapiackec9,
      lt_valuefield  TYPE TABLE OF bapiackev9.

CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function.
ENDCLASS.

CLASS lcl_handle_events IMPLEMENTATION.
  METHOD on_user_command.
    PERFORM handle_user_command USING e_salv_function.
  ENDMETHOD.                    "on_user_command
ENDCLASS.

DATA: lt_output     TYPE TABLE OF ty_output,
      lt_output_tmp TYPE TABLE OF ty_output,
      lt_result     TYPE TABLE OF ty_output_r.

DATA: lt_posting_new TYPE farr_tt_ac_document.

DATA: lt_acchd TYPE acchd_t,
      lt_accit TYPE accit_t,
      lt_acccr TYPE acccr_t.

DATA: ls_acchd TYPE acchd,
      ls_accit TYPE accit,
      ls_acccr TYPE acccr.

DATA: ls_output  TYPE ty_output,
      ls_result  TYPE ty_output_r,
      ls_message TYPE farric_s_check_mess.

DATA: lv_msg TYPE string.

DATA: gr_events TYPE REF TO lcl_handle_events.

DATA: gt_messages TYPE farric_tt_check_mess,
      gt_result   TYPE TABLE OF ty_result.
