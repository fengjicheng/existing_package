class ZCL_IM_ISM_CIC_BP_SEARCH definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ISM_CIC_BP_SEARCH .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_ISM_CIC_BP_SEARCH IMPLEMENTATION.


  METHOD if_ex_ism_cic_bp_search~bp_search_with_docnr.
* DESCRIPTION:         Pass PO Number and fetch BP Number for CIC0 t-code
* DEVELOPER:           AMOHAMMED
* CREATION DATE:       01/17/2020
* REFERENCE NO:        ERPM-7157 - E229
* TRANSPORT NUMBER(S): ED2K917340
* ------------------------------------------------------------------------
* Local Constant Declaration
    CONSTANTS: lc_sno_e229_003   TYPE zsno    VALUE '003',   " Serial Number
               lc_wricef_id_e229 TYPE zdevid  VALUE 'E229'.  " Development ID
* Local Data Declaration
    DATA: lv_actv_flag_e229 TYPE zactive_flag,               " Active / Inactive Flag
          ls_ism_gpnr_str   TYPE ism_gpnr_str.
* To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e229                   " Development ID (E201)
        im_ser_num     = lc_sno_e229_003                     " Serial Number (001)
      IMPORTING
        ex_active_flag = lv_actv_flag_e229.                  " Active / Inactive Flag
    IF lv_actv_flag_e229 EQ abap_true.                       " Check for Active Flag
      SELECT kunnr                                           " Pass PO Number and fetch BP Number
        FROM vbak
        INTO TABLE @DATA(lt_vbak)
        WHERE bstnk EQ @i_docnr.
      IF sy-subrc EQ 0.
        SORT lt_vbak BY kunnr.
        DELETE ADJACENT DUPLICATES FROM lt_vbak COMPARING kunnr.
        LOOP AT lt_vbak ASSIGNING FIELD-SYMBOL(<ls_vbak>).
          ls_ism_gpnr_str-gpnr = <ls_vbak>-kunnr.
          APPEND ls_ism_gpnr_str TO r_bptab.
          CLEAR ls_ism_gpnr_str.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD if_ex_ism_cic_bp_search~business_partner_search.
    DATA: lv_error TYPE char1 VALUE IS INITIAL. " Error of type CHAR1

      CALL FUNCTION 'ZQTC_CIC_BP_SEARCH'
        EXPORTING
          im_ps_rjycic_search = ps_rjycic_search
        IMPORTING
          ex_ps_rjycic_search = ps_new_search_data
          ex_partner_error    = lv_error.

      IF lv_error EQ abap_true.
        MESSAGE e001(jycic) DISPLAY LIKE 'S'. " The system was unable to find any addresses
      ENDIF. " IF lv_error EQ abap_true

  ENDMETHOD.


  method IF_EX_ISM_CIC_BP_SEARCH~CONVERT_DOCNR_TO_ORDERNR.
  endmethod.


  METHOD if_ex_ism_cic_bp_search~document_types_modify.
* DESCRIPTION:         Display "PO Number" text in the dropdown list for
*                      search based on PO number for CIC0 T-code
* DEVELOPER:           AMOHAMMED
* CREATION DATE:       01/17/2020
* REFERENCE NO:        ERPM-7157 - E229
* TRANSPORT NUMBER(S): ED2K917340
* -----------------------------------------------------------------------
* Local Data Declaration
    DATA: lv_actv_flag_e229 TYPE zactive_flag, "Active / Inactive Flag
          ls_listboxtab     LIKE LINE OF p_listboxtab.

* Local Constant Declaration
    CONSTANTS: lc_sno_e229_003   TYPE zsno    VALUE '003',   "Serial Number
               lc_wricef_id_e229 TYPE zdevid  VALUE 'E229',  "Development ID
               lc_po_text        LIKE ls_listboxtab-text VALUE 'PO Number'.

* To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e229  "Development ID (E201)
        im_ser_num     = lc_sno_e229_003    "Serial Number (001)
      IMPORTING
        ex_active_flag = lv_actv_flag_e229. "Active / Inactive Flag
    IF lv_actv_flag_e229 EQ abap_true.      "Check for Active Flag
      ls_listboxtab-key = 9.
      CONDENSE ls_listboxtab-key.
      ls_listboxtab-text = lc_po_text.
      APPEND ls_listboxtab TO p_listboxtab.
    ENDIF.
  ENDMETHOD.


  method IF_EX_ISM_CIC_BP_SEARCH~FILTER_SEARCH_RESULT.
    IF sy-subrc eq 0.

    ENDIF.
  endmethod.


  method IF_EX_ISM_CIC_BP_SEARCH~HITLIST_PREPARE_FOR_WORKSPACE.
  endmethod.


  method IF_EX_ISM_CIC_BP_SEARCH~PRELIMINARY_BUSINESS_PRTN_SRCH.
     DATA : lst_bp TYPE zqtc_claims_bp.
     DATA : lst_block TYPE zqtc_block_order.
    IF ps_data_for_search-gpnr IS NOT INITIAL.

      lst_bp-bp     = ps_data_for_search-gpnr.
      lst_bp-created_user = sy-uname.
      lst_bp-creted_date = sy-datum.
      lst_bp-time = sy-uzeit.

      MODIFY zqtc_claims_bp FROM lst_bp.
      CLEAR : lst_bp.
    ENDIF.

*
*    IF ps_data_for_search-gpnr IS NOT INITIAL AND 1 = 2.
*
*      lst_block-bp     = ps_data_for_search-gpnr.
*      lst_block-bname = sy-uname.
*      lst_block-erdat = sy-datum.
*      lst_block-ertim = sy-uzeit.
*
*      MODIFY zqtc_block_order FROM lst_block.
*      CLEAR : lst_block.
*    ENDIF.
  endmethod.
ENDCLASS.
