class ZCL_IDT_ORIGIN_INVOICE_DATE definition
  public
  final
  create public .

public section.
  interfaces /IDT/USER_EXIT_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IDT_ORIGIN_INVOICE_DATE IMPLEMENTATION.


METHOD /idt/user_exit_interface~user_exit.

  CONSTANTS: lc_wricef_id_e246 TYPE zdevid VALUE 'E246', "Development ID
             lc_ser_num_003    TYPE zsno   VALUE '003',
             lc_varkey         type ZVAR_KEY VALUE 'INV_DATE_LOG'.  "Serial Number

  FIELD-SYMBOLS: <ls_vbrk> TYPE vbrk.
  DATA:lv_prsdt     TYPE prsdt,
       lv_actv_flag TYPE zactive_flag. "Active / Inactive Flagw
  DATA(lo_vbrk) = i_ref_util_source_data->field( 'VBRK' ).


* To check enhancement is active or not
  CALL FUNCTION 'ZCA_ENH_CONTROL'
    EXPORTING
      im_wricef_id   = lc_wricef_id_e246
      im_ser_num     = lc_ser_num_003
      IM_VAR_KEY     = lc_varkey
    IMPORTING
      ex_active_flag = lv_actv_flag.

  IF  lv_actv_flag = abap_true.
    ASSIGN lo_vbrk->g_ref_data->* TO <ls_vbrk>.
    IF <ls_vbrk> IS ASSIGNED.
      IF <ls_vbrk>-vbtyp = 'N'.
        DATA(lv_vbeln) = CONV vbeln_vf( <ls_vbrk>-sfakn ). "Original document number for cancellation
        SELECT prsdt UP TO 1 ROWS INTO lv_prsdt FROM vbrp WHERE vbeln = lv_vbeln .
        ENDSELECT.
        IF sy-subrc = 0.
          rv_value = CONV #( lv_prsdt ).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.
ENDCLASS.
