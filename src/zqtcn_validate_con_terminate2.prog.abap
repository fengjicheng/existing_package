*&---------------------------------------------------------------------*
*&  Include  ZQTCN_VALIDATE_CON_TERMINATE2
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_VALIDATE_CON_TERMINATE2(Include)
*               Called from MV45AFZZ SAVE_DOCUMENT_PREPARE routine"
* PROGRAM DESCRIPTION: Validate the fields "Reason for Cancellation of Contract".
*                   In contract tab of VA41/VA42 and VA43
* DEVELOPER: Prabhu(PTUFARAM)
* CREATION DATE:     :  01/16/2019
* OBJECT ID:         :  E186/ERP7515
* TRANSPORT NUMBER(S):  ED2K914194
*----------------------------------------------------------------------*
DATA : lst_vbap LIKE LINE OF xvbap,
       lst_veda TYPE vedavb.
* Type Declaration
TYPES:
  BEGIN OF ty_zcaconstant,
    devid    TYPE zdevid,                                       "Development ID
    param1   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
    param2   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
    srno     TYPE tvarv_numb,                                   "ABAP: Current selection number
    sign     TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
    opti     TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
    low      TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
    high     TYPE salv_de_selopt_high,                          "Upper Value of Selection Condition
    activate TYPE zconstactive,                                 "Activation indicator for constant
  END OF ty_zcaconstant.
* local Internal Table Declaration
DATA:
  li_const_v TYPE STANDARD TABLE OF ty_zcaconstant INITIAL SIZE 0,
  lir_ordtyp TYPE fip_t_auart_range.
CONSTANTS:
  lc_id_e186 TYPE zdevid     VALUE 'E186',                      "Development ID
  lc_ord_typ TYPE rvari_vnam VALUE 'AUART'.                     "ABAP: Name of Variant Variable

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
IF vbak-auart IN lir_ordtyp.
*--*Validation at header
  CLEAR : lst_vbap-posnr.
  CALL FUNCTION 'SD_VEDA_SELECT'
    EXPORTING
      i_document_number = vbak-vbeln
      i_item_number     = lst_vbap-posnr
      i_trtyp           = t180-trtyp
    IMPORTING
      e_vedavb          = lst_veda.
  IF lst_veda-vkuegru IS NOT INITIAL.
    MESSAGE e531(zqtc_r2) WITH lst_vbap-posnr.
  ENDIF.
*--*Validation at Item
  LOOP AT xvbap INTO lst_vbap.
    CALL FUNCTION 'SD_VEDA_SELECT'
      EXPORTING
        i_document_number = lst_vbap-vbeln
        i_item_number     = lst_vbap-posnr
        i_trtyp           = t180-trtyp
      IMPORTING
        e_vedavb          = lst_veda.
    IF lst_veda-vkuesch = '0001'.
      IF lst_veda-vkuegru IS NOT INITIAL.
        MESSAGE e521(zqtc_r2) WITH lst_vbap-posnr.
      ENDIF.
    ELSE.
      IF lst_veda-vkuegru IS INITIAL.
        MESSAGE e522(zqtc_r2) WITH lst_vbap-posnr." DISPLAY LIKE 'I'.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDIF.
