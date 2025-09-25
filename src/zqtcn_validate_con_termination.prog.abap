*&---------------------------------------------------------------------*
*&  Include           ZQTCN_VALIDATE_CON_TERMINATION
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_VALIDATE_CON_TERMINATION(Include)
*               Called from VA01 subscreen 4201 Include LV45WF0K"
* PROGRAM DESCRIPTION: Validate the fields "Date on which cancellation request was received",
*                      "Requested cancellation date" and
*                      "Reason for Cancellation of Contract".
* DEVELOPER: Prabhu(PTUFARAM)
* CREATION DATE:     :  01/16/2019
* OBJECT ID:         :  E186/ERP7515
* TRANSPORT NUMBER(S):  ED2K914194
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
CONSTANTS:
  lc_id_e186 TYPE zdevid     VALUE 'E186',                      "Development ID
  lc_ord_typ TYPE rvari_vnam VALUE 'AUART'.                     "ABAP: Name of Variant Variable
DATA: lv_name_xvbak(30)  VALUE   '(SAPMV45A)VBAK'.
FIELD-SYMBOLS: <fs_vbak> TYPE  vbak.

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
 WHERE devid    EQ lc_id_e186
   AND activate EQ abap_true.
IF sy-subrc EQ 0.
  LOOP AT li_const_v ASSIGNING FIELD-SYMBOL(<lst_const>).
    CASE <lst_const>-param1.
      WHEN lc_ord_typ.
*           Get the Order Types from Constant Table
        APPEND INITIAL LINE TO lir_ordtyp ASSIGNING FIELD-SYMBOL(<lst_ordtyp>).
        <lst_ordtyp>-sign   = <lst_const>-sign.
        <lst_ordtyp>-option = <lst_const>-opti.
        <lst_ordtyp>-low    = <lst_const>-low.
        <lst_ordtyp>-high   = <lst_const>-high.
      WHEN OTHERS.
*           Nothing to do
    ENDCASE.
  ENDLOOP. " LOOP AT li_zcaconstant INTO lst_zcaconstant
ENDIF. " IF sy-subrc EQ 0
IF lir_ordtyp IS NOT INITIAL.
* Retrieve Sales order details from abap stack
  ASSIGN (lv_name_xvbak) TO <fs_vbak>.
  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

  IF <fs_vbak>-auart IN lir_ordtyp.
*&---------------------------------------------------------------------*
*----Validation at header---------------------------------*
*----------------------------------------------------------------------*
    IF veda-vposn IS INITIAL.
      IF veda-vkuesch NE '0001'.
        MESSAGE e530(zqtc_r2).
      ENDIF.
      IF veda-veindat IS NOT INITIAL.
        MESSAGE e533(zqtc_r2).
      ENDIF.
      IF veda-vwundat IS NOT INITIAL..
        MESSAGE e534(zqtc_r2).
      ENDIF.
      IF veda-vkuegru IS NOT INITIAL..
        MESSAGE i532(zqtc_r2) DISPLAY LIKE 'E'.
        fcode = 'ENT1'.
      ENDIF.
    ELSE.
*&---------------------------------------------------------------------*
*----Validation at Item---------------------------------*
*----------------------------------------------------------------------*
      IF veda-vkuesch = '0001'.
        IF veda-veindat IS NOT INITIAL.
          MESSAGE e517(zqtc_r2) WITH veda-vposn .
        ENDIF.
        IF veda-vwundat IS NOT INITIAL..
          MESSAGE e519(zqtc_r2) WITH veda-vposn.
        ENDIF.
        IF veda-vkuegru IS NOT INITIAL.
          CLEAR : veda-vkuegru.
          MESSAGE i515(zqtc_r2) WITH veda-vposn DISPLAY LIKE 'E'.
          fcode = 'ENT1'.
        ENDIF.
      ELSE.
        IF veda-veindat IS INITIAL.
          MESSAGE e518(zqtc_r2) WITH veda-vposn.
        ENDIF.
        IF veda-vwundat IS INITIAL..
          MESSAGE e520(zqtc_r2) WITH veda-vposn.
        ENDIF.
        IF veda-vkuegru IS INITIAL.
          MESSAGE i516(zqtc_r2) WITH veda-vposn DISPLAY LIKE 'E'.
          fcode = 'ENT1'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
