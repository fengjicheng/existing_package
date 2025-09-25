"Name: \FU:SD_PARTNER_ADDR_DIALOG_INTERN\SE:BEGIN\EI
ENHANCEMENT 0 ZQTCEI_ENABLE_PAYER_VAT_REG.
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:  I0230.2/OTCM-27280
* DEVELOPER: Prabhuu(PTUUFARAM)
* DATE:  12-April-2021
* DESCRIPTION: Make VAT Reg Num field Visible at Payer Address for ZPPV Orders
*----------------------------------------------------------------------*
*DATA: lv_actv_flag_i0230 TYPE zactive_flag, "Active / Inactive flag
*      lir_r_order_type   TYPE RANGE OF salv_de_selopt_low,
*      lir_r_partner_func TYPE RANGE OF salv_de_selopt_low,
*      li_zcaconst        TYPE zcat_constants,
*      lst_zcaconst       TYPE zcast_constant, " Wiley Application Constant Table
*      lv_ppv_vatid_skip  TYPE char1.

*  Field Symbols Declarations
*FIELD-SYMBOLS:
*  <lv_auart> TYPE any.
*CONSTANTS:lc_devid             TYPE zdevid     VALUE 'I0230.2',
*          lc_ser_num_i0230_2_5 TYPE zsno       VALUE '005', "Serial Number (004)
*          lc_order_type        TYPE rvari_vnam VALUE 'AUART_PARTNER_ADDRESS',
*          lc_partner_func      TYPE rvari_vnam VALUE 'PARVW_PARTNER_ADDRESS',
*          lc_auart             TYPE char30 VALUE '(SAPMV45A)VBAK-AUART'.
**--*Check Enhancement active
*CALL FUNCTION 'ZCA_ENH_CONTROL'
*  EXPORTING
*    im_wricef_id   = lc_devid               "Constant value for WRICEF (I0230.2)
*    im_ser_num     = lc_ser_num_i0230_2_5   "Serial Number (005)
*  IMPORTING
*    ex_active_flag = lv_actv_flag_i0230. "Active / Inactive flag
*IF lv_actv_flag_i0230 = abap_true.
** To get ZCACONSTANT entries .
*  CALL FUNCTION 'ZQTC_GET_ZCACONSTANT_ENT'
*    EXPORTING
*      im_devid         = lc_devid
*    IMPORTING
*      ex_t_zcacons_ent = li_zcaconst.
*
*  LOOP AT li_zcaconst INTO lst_zcaconst.
*    CASE lst_zcaconst-param1 .
*      WHEN lc_order_type.
*        APPEND INITIAL LINE TO  lir_r_order_type ASSIGNING FIELD-SYMBOL(<lst_order_type>).
*        <lst_order_type>-sign   = lst_zcaconst-sign.
*        <lst_order_type>-option = lst_zcaconst-opti.
*        <lst_order_type>-low    = lst_zcaconst-low.
*        <lst_order_type>-high   = lst_zcaconst-high.
*      WHEN lc_partner_func.
*        APPEND INITIAL LINE TO  lir_r_partner_func  ASSIGNING FIELD-SYMBOL(<lst_part_fun>).
*        <lst_part_fun>-sign   = lst_zcaconst-sign.
*        <lst_part_fun>-option = lst_zcaconst-opti.
*        <lst_part_fun>-low    = lst_zcaconst-low.
*        <lst_part_fun>-high   = lst_zcaconst-high.
*      WHEN OTHERS.
*    ENDCASE.
*  ENDLOOP.

*  ASSIGN (lc_auart) TO <lv_auart>.
*--*Check Order type and Partner function
*  IF <lv_auart> IS ASSIGNED AND <lv_auart> IN lir_r_order_type AND
*       fif_title_parvw IN lir_r_partner_func.
*    fif_attributes_shown-stceg = abap_true. "Make VAT Reg Num Visible
*    fif_display_only = abap_true. "Make it disabled
*    LOOP AT SCREEN.
*      IF screen-name = 'GDF_STCEG'.
*       screen-input = 0.
*       MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
*ENDIF.
ENDENHANCEMENT.
