class ZIDT_WILEY_SHIP_TO_VATREG_I230 definition
  public
  create public .

public section.

  interfaces /IDT/USER_EXIT_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZIDT_WILEY_SHIP_TO_VATREG_I230 IMPLEMENTATION.


  METHOD /idt/user_exit_interface~user_exit.

*&---------------------------------------------------------------------*
*&  CLASS           ZIDT_WILEY_SHIP_TO_VATREG_I230
*&---------------------------------------------------------------------*
* PROGRAM DESCRIPTION: Fetch VAT ID from VBPA to IDT logs and TAx calculation
* DEVELOPER: Kiran Chenna  <Kiran.Chenna@thomsonreuters.com>
* CREATION DATE:   16-June-2021
* OBJECT ID: I0230.2/OTCM-27280
* TRANSPORT NUMBER(S): ED2K916726
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K928801
* REFERENCE NO:  I0230.2/OTCM-27280
* DEVELOPER: Prabhu (PTUFARAM)
* DATE:  2022-11-17
* DESCRIPTION: EQ2 Order Creation Dump issue Fix, OneSource code implemnetd
*----------------------------------------------------------------------*

*    DATA : mt_partner_data TYPE /idt/journey=>ty_tab_sap_partners,
*           ms_partner_data TYPE /idt/journey=>ty_sap_partners,
*           mv_item_req     TYPE REF TO /idt/reference_utility.
*    DATA : lv_string TYPE string,
*           lv_type   TYPE string.
*    DATA : lv_stceg_we TYPE stceg,
*           lt_xvbpa    TYPE TABLE OF vbpavb.
*
*    FIELD-SYMBOLS <fs_data> TYPE data.
*    FIELD-SYMBOLS: <lt_partner> TYPE table.
*    DATA: lv_mem TYPE string VALUE '(SAPMV45A)XVBPA[]'.
*BOI OTCM-27280 TDIMANTHA 17-June-2021 ED2K923785
    CONSTANTS:
      lc_wricef_id TYPE zdevid VALUE 'I0230.2', " Development ID
      lc_ser_num   TYPE zsno   VALUE '006'.  " Serial Number

    DATA:
      lv_actv_flag TYPE zactive_flag.        " Active / Inactive Flag

    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id
        im_ser_num     = lc_ser_num
      IMPORTING
        ex_active_flag = lv_actv_flag.

    IF lv_actv_flag EQ abap_true.
*EOI OTCM-27280 TDIMANTHA 17-June-2021 ED2K923785
*      DATA(lo_ref) = cl_abap_typedescr=>describe_by_data_ref( i_ref_util_source_data->g_ref_data ).
*      SPLIT lo_ref->absolute_name AT 'TYPE=' INTO lv_string lv_type.
*      IF lv_type = '/IDT/SAP_ITEM'.
*** Read Item level Partner Tab
*        mv_item_req = i_ref_util_source_data->field( 'PARTNER_TAB' ).
*        ASSIGN mv_item_req->g_ref_data->* TO <fs_data>.
*        IF sy-subrc = 0.
*          mt_partner_data = <fs_data>.
*        ENDIF.
*        TRY.
*            lv_stceg_we = mt_partner_data[ parvw = 'WE' ]-vbpa-stceg.
*          CATCH cx_sy_itab_line_not_found.
*        ENDTRY.
*      ENDIF.
**Last Option Read partners from memory
*      IF lv_stceg_we IS INITIAL.
*        ASSIGN (lv_mem) TO <lt_partner>.
*        IF <lt_partner> IS ASSIGNED.
*          TRY.
**            lv_stceg_we = mt_partner_data[ parvw = 'WE' ]-vbpa-stceg.
*              "Commented above line and mapped XVBPA reference from memory
*              lt_xvbpa = <lt_partner>.
*              lv_stceg_we = lt_xvbpa[ parvw = 'WE' ]-stceg.
**              lv_stceg_we = lt_xvbpa[  posnr = '000000' parvw = 'WE' ]-stceg."(+) VAMILLAPA|10/07/2022
*            CATCH cx_sy_itab_line_not_found.
*          ENDTRY.
*        ENDIF.
*      ENDIF.
*      rv_value = lv_stceg_we.
*    ENDIF. "IF lv_actv_flag EQ abap_true. OTCM-27280 TDIMANTHA 17-June-2021 ED2K923785

      TYPES:
        BEGIN OF ty_sap_partners,
          posnr TYPE posnr,
          ebelp TYPE ebelp,
          parvw TYPE parvw,
          vbpa  TYPE vbpa,
          ekpa  TYPE ekpa,
          kna1  TYPE kna1,
          lfa1  TYPE lfa1,
        END OF ty_sap_partners .
      TYPES:
       ty_tab_sap_partners TYPE STANDARD TABLE OF ty_sap_partners .
      DATA : mt_partner_data TYPE ty_tab_sap_partners,
             ms_partner_data TYPE ty_sap_partners,
             mv_item_req     TYPE REF TO /idt/reference_utility.
      DATA : lv_string TYPE string,
             lv_type   TYPE string.
      DATA : lv_stceg_we TYPE stceg.

      FIELD-SYMBOLS <fs_data> TYPE data.
      FIELD-SYMBOLS: <lt_partner> TYPE table.
      DATA: lv_mem TYPE string VALUE '(SAPMV45A)XVBPA[]'.

      DATA(lo_ref) = cl_abap_typedescr=>describe_by_data_ref( i_ref_util_source_data->g_ref_data ).
      SPLIT lo_ref->absolute_name AT 'TYPE=' INTO lv_string lv_type.
      IF lv_type = '/IDT/SAP_ITEM'.
** Read Item level Partner Tab
        mv_item_req = i_ref_util_source_data->field( 'PARTNER_TAB' ).
        ASSIGN mv_item_req->g_ref_data->* TO <fs_data>.
        IF sy-subrc = 0.
          mt_partner_data = <fs_data>.
          DELETE ADJACENT DUPLICATES FROM mt_partner_data COMPARING posnr ebelp parvw.
        ENDIF.
        TRY.
            lv_stceg_we = mt_partner_data[ parvw = 'WE' ]-vbpa-stceg.
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.
      ENDIF.
*Last Option Read partners from memory
      IF lv_stceg_we IS INITIAL.
        ASSIGN (lv_mem) TO <lt_partner>.
        IF <lt_partner> IS ASSIGNED.
          TRY.
              lv_stceg_we = mt_partner_data[ parvw = 'WE' ]-vbpa-stceg.
            CATCH cx_sy_itab_line_not_found.
          ENDTRY.
        ENDIF.
      ENDIF.
      rv_value = lv_stceg_we.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
