"Name: \PR:SAPLMEREP\TY:LCL_REPORTING_CNT_GENERAL\ME:GET_WORKING_AREA\SE:BEGIN\EI
ENHANCEMENT 0 ZQTCEI_CUST_FIELDS_E268.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K924078
* REFERENCE NO: E268 / OTCM-49256
* DEVELOPER: Thilina Dimantha
* DATE: 12-July-2021
* DESCRIPTION: PO History show incorrect data ME2N ME2M Output
*-----------------------------------------------------------------------*

  CONSTANTS:
      lc_wricef_id_e268 TYPE zdevid VALUE 'E268',      "Constant value for WRICEF (E268)
      lc_ser_num_e268 TYPE zsno   VALUE '001',         "Name of Variant Variable: Sales Office.
      lc_p1_tcode TYPE rvari_vnam  VALUE 'TCODE'.      "Name of Variant Variable: Sales Office.

    DATA: lv_var_key_e268   TYPE zvar_key,             "Variable Key
          lv_alv_flag  TYPE c.

    FIELD-SYMBOLS:
          <table_dis>  TYPE STANDARD TABLE,
          <ls_line1>   TYPE any,
          <ls_target1> TYPE any.

*   Check if enhancement needs to be triggered
  IF v_actv_flag_e268_001 IS INITIAL.
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e268              "Constant value for WRICEF (E268)
        im_ser_num     = lc_ser_num_e268                "Serial Number (001)
        im_var_key     = lv_var_key_e268                "Variable Key (Credit Segment)
      IMPORTING
        ex_active_flag = v_actv_flag_e268_001.          "Active / Inactive flag
   ENDIF.

IF v_actv_flag_e268_001 = abap_true.

*Get Constants
  IF i_constants_e268 IS INITIAL.
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_wricef_id_e268   "Development ID
      IMPORTING
        ex_constants = i_constants_e268. "Constant Values
  ENDIF.

* fill the respective entries which are maintain in zcaconstant.
  IF ir_tcode_e268 IS INITIAL.
    LOOP AT i_constants_e268 ASSIGNING FIELD-SYMBOL(<lst_cnst>).
      CASE <lst_cnst>-param1.
        WHEN lc_p1_tcode.
          APPEND INITIAL LINE TO ir_tcode_e268 ASSIGNING FIELD-SYMBOL(<lst_tcode_i>).
          <lst_tcode_i>-sign   = <lst_cnst>-sign.
          <lst_tcode_i>-option = <lst_cnst>-opti.
          <lst_tcode_i>-low    = <lst_cnst>-low.
          <lst_tcode_i>-high   = <lst_cnst>-high.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDIF.

  IF  sy-tcode IN ir_tcode_e268.
    lv_alv_flag = abap_true.

    CLEAR: ex_wa.
    IF im_index GT 0.
      IF <table_cust> IS ASSIGNED.
       READ TABLE <table_cust> ASSIGNING <ls_line1> INDEX im_index.
         IF sy-subrc IS INITIAL.
           CREATE DATA ex_wa LIKE <ls_line1>.
             IF ex_wa IS BOUND.
               ASSIGN ex_wa->* TO <ls_target1>.
               <ls_target1> = <ls_line1>.
             ENDIF.
         ENDIF.
      ENDIF.
    ELSEIF im_index EQ 0 AND sy-ucomm EQ 'ME54N'.
      MESSAGE w198(me).
    ENDIF.

    IF ex_wa IS INITIAL.
      CREATE DATA ex_wa TYPE c.
    ENDIF.

  ENDIF.
 ENDIF.
 CHECK lv_alv_flag = abap_false.
ENDENHANCEMENT.
