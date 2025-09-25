*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USAGE_IND_MAT_GRP4 (Include)
*               Called from "USEREXIT_CHECK_VBAP(MV45AFZB)"
* PROGRAM DESCRIPTION: Map Material Group 4 from Usage Indicator for
*                      CSS Orders
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   04/16/2017
* OBJECT ID: E038
* TRANSPORT NUMBER(S): ED2K905420
*----------------------------------------------------------------------*
* Type Declaration
TYPES:
  BEGIN OF lty_zcaconstant,
    devid    TYPE zdevid,                                       "Development ID
    param1   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
    param2   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
    srno     TYPE tvarv_numb,                                   "ABAP: Current selection number
    sign     TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
    opti     TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
    low      TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
    high     TYPE salv_de_selopt_high,                          "Upper Value of Selection Condition
    activate TYPE zconstactive,                                 "Activation indicator for constant
  END OF lty_zcaconstant.

* local Internal Table Declaration
DATA:
  li_const_v TYPE STANDARD TABLE OF lty_zcaconstant INITIAL SIZE 0,
  lir_ordtyp TYPE fip_t_auart_range.

DATA:
  lv_mat_gr4 TYPE mvgr4.

CONSTANTS:
  lc_id_e038 TYPE zdevid     VALUE 'E038',                      "Development ID
  lc_ord_typ TYPE rvari_vnam VALUE 'AUART',                     "ABAP: Name of Variant Variable
  lc_css_ord TYPE rvari_vnam VALUE 'CSS'.                       "ABAP: Name of Variant Variable

IF vbap-vkaus NE *vbap-vkaus.                                   "Usage Indicator is changed
  SELECT devid                                                  "Development ID
         param1	                                                "ABAP: Name of Variant Variable
         param2	                                                "ABAP: Name of Variant Variable
         srno	                                                  "ABAP: Current selection number
         sign	                                                  "ABAP: ID: I/E (include/exclude values)
         opti	                                                  "ABAP: Selection option (EQ/BT/CP/...)
         low                                                    "Lower Value of Selection Condition
         high	                                                  "Upper Value of Selection Condition
         activate                                               "Activation indicator for constant
    FROM zcaconstant                                            "Wiley Application Constant Table
    INTO TABLE li_const_v
   WHERE devid    EQ lc_id_e038
     AND activate EQ abap_true.
  IF sy-subrc EQ 0.
    LOOP AT li_const_v ASSIGNING FIELD-SYMBOL(<lst_const>).
      CASE <lst_const>-param1.
        WHEN lc_ord_typ.
          CASE <lst_const>-param2.
            WHEN lc_css_ord.
*           Get the Order Types from Constant Table
              APPEND INITIAL LINE TO lir_ordtyp ASSIGNING FIELD-SYMBOL(<lst_ordtyp>).
              <lst_ordtyp>-sign   = <lst_const>-sign.
              <lst_ordtyp>-option = <lst_const>-opti.
              <lst_ordtyp>-low    = <lst_const>-low.
              <lst_ordtyp>-high   = <lst_const>-high.
            WHEN OTHERS.
*           Nothing to do
          ENDCASE.
        WHEN OTHERS.
*       Nothing to do
      ENDCASE.
    ENDLOOP. " LOOP AT li_zcaconstant INTO lst_zcaconstant
  ENDIF. " IF sy-subrc EQ 0

  IF vbak-auart IN lir_ordtyp.
* Usage Indicator to Material Group 4 Mapping
    SELECT SINGLE mvgr4                                         "Material group 4
      FROM zqtc_usage_mgr4
      INTO lv_mat_gr4
     WHERE vkaus EQ vbap-vkaus.                                 "Usage Indicator
    IF sy-subrc EQ 0.
      vbap-mvgr4 = lv_mat_gr4.                                  "Material group 4
    ENDIF.
  ENDIF.
ENDIF.
