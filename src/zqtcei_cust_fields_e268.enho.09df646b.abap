"Name: \PR:SAPLMEREP\TY:LCL_REPORTING_CNT_GENERAL\ME:HANDLE_USER_COMMAND\SE:END\EI
ENHANCEMENT 0 ZQTCEI_CUST_FIELDS_E268.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K923663
* REFERENCE NO: E268
* DEVELOPER: Thilina Dimantha
* DATE: 03-June-2021
* DESCRIPTION: Add PO History related fields to ME2N ME2M Output
*-----------------------------------------------------------------------*

  CONSTANTS:
      lc_wricef_id_e268 TYPE zdevid VALUE 'E268',      "Constant value for WRICEF (E268)
      lc_ser_num_e268 TYPE zsno   VALUE '001',         "Name of Variant Variable: Sales Office.
      lc_p1_tcode TYPE rvari_vnam  VALUE 'TCODE'.      "Name of Variant Variable: Sales Office.

    DATA:
      lv_var_key_e268   TYPE zvar_key,                 "Variable Key
*      lv_actv_flag_e268 TYPE zactive_flag, "Active / Inactive flag "-ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
      lv_alv_flag       TYPE c,
*      li_constants      TYPE zcat_constants, "-ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
*      lr_tcode_i        TYPE RANGE OF syst-tcode, "-ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
      lv_mblnr          TYPE mblnr.

*   Check if enhancement needs to be triggered
  IF v_actv_flag_e268_001 IS INITIAL. "+ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e268              "Constant value for WRICEF (E268)
        im_ser_num     = lc_ser_num_e268                "Serial Number (001)
        im_var_key     = lv_var_key_e268                "Variable Key (Credit Segment)
      IMPORTING
        ex_active_flag = v_actv_flag_e268_001. "lv_actv_flag_e268. "Active / Inactive flag
   ENDIF.

*IF lv_actv_flag_e268 = abap_true. "-ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
IF v_actv_flag_e268_001 = abap_true. "+ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
*Get Constants
  IF i_constants_e268 IS INITIAL.
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_wricef_id_e268   "Development ID
    IMPORTING
      ex_constants = i_constants_e268. "li_constants. "Constant Values
  ENDIF.

* fill the respective entries which are maintain in zcaconstant.
  IF ir_tcode_e268 IS INITIAL. "+ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
*  LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_cnst>). "-ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
    LOOP AT i_constants_e268 ASSIGNING FIELD-SYMBOL(<lst_cnst>). "+ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
      CASE <lst_cnst>-param1.
        WHEN lc_p1_tcode.
*          APPEND INITIAL LINE TO lr_tcode_i ASSIGNING FIELD-SYMBOL(<lst_tcode_i>). "-ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
         APPEND INITIAL LINE TO ir_tcode_e268 ASSIGNING FIELD-SYMBOL(<lst_tcode_i>). "+ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
          <lst_tcode_i>-sign   = <lst_cnst>-sign.
          <lst_tcode_i>-option = <lst_cnst>-opti.
          <lst_tcode_i>-low    = <lst_cnst>-low.
          <lst_tcode_i>-high   = <lst_cnst>-high.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDIF.

*  IF  sy-tcode IN lr_tcode_i. "-ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
  IF  sy-tcode IN ir_tcode_e268. "+ED2K924078 TDIMANTHA OTCM-49256 13-July-2021
    IF ch_ucomm EQ '&IC1' OR
           ch_ucomm EQ lif_constants=>gc_ucomm_detail.
          IF ch_selfield-sumindex IS INITIAL.
            IF ch_selfield-fieldname = 'IR_NUMBER' OR ch_selfield-fieldname = 'GR_NUMBER'.
              IF ch_selfield-value IS NOT INITIAL.
*              ASSIGN COMPONENT 'EBELN' OF STRUCTURE <ls_line> TO FIELD-SYMBOL(<lf_ebeln>).
*              ASSIGN COMPONENT 'EBELP' OF STRUCTURE <ls_line> TO FIELD-SYMBOL(<lf_ebelp>).
*              IF <lf_ebeln> IS ASSIGNED AND <lf_ebelp> IS ASSIGNED.
              SELECT SINGLE gjahr
                INTO @DATA(lv_gjahr)
                FROM ekbe
                WHERE "ebeln = @<lf_ebeln>
*                AND ebelp = @<lf_ebelp>
                belnr = @ch_selfield-value.
*               UNASSIGN: <lf_ebeln>, <lf_ebelp>.
*              ENDIF.
              IF ch_selfield-fieldname = 'IR_NUMBER'.
                SET PARAMETER ID 'RBN'  FIELD ch_selfield-value.
                SET PARAMETER ID 'GJR'  FIELD lv_gjahr.
                CALL TRANSACTION 'MIR4' AND SKIP FIRST SCREEN.
              ELSEIF ch_selfield-fieldname = 'GR_NUMBER'.
                lv_mblnr = ch_selfield-value.
                CALL FUNCTION 'MIGO_DIALOG'
                 EXPORTING
*                   I_ACTION                  = 'A04'
*                   I_REFDOC                  = 'R02'
*                   I_NOTREE                  = 'X'
*                   I_NO_AUTH_CHECK           =
*                   I_SKIP_FIRST_SCREEN       = 'X'
*                   I_DEADEND                 = 'X'
*                   I_OKCODE                  = 'OK_GO'
*                   I_LEAVE_AFTER_POST        =
*                   I_NEW_ROLLAREA            = 'X'
*                   I_SYTCODE                 =
*                   I_EBELN                   =
*                   I_EBELP                   =
                   I_MBLNR                   = lv_mblnr
                   I_MJAHR                   = lv_gjahr
*                   I_ZEILE                   =
                 EXCEPTIONS
                   ILLEGAL_COMBINATION       = 1
                   OTHERS                    = 2
                          .
                IF sy-subrc <> 0.
                ENDIF.

              ENDIF.
              ENDIF.
            ENDIF.
          ELSE.
            MESSAGE s201(me).
          ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
ENDENHANCEMENT.
