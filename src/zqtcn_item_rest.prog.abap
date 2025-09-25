*&---------------------------------------------------------------------*
*&  Include           ZQTCN_ITEM_REST
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ITEM_REST (Include)
*               Called from "USEREXIT_CHECK_VBAP(MV45AFZB)"
* PROGRAM DESCRIPTION: To trigger a down payment request or proforma
*                      for CSS, a CSR must change the item category
*                      on the order
* DEVELOPER: Alankruta Patnaik (APATNAIK)
* CREATION DATE:   06/14/2017
* OBJECT ID: E060
* TRANSPORT NUMBER(S): ED2K906687
*----------------------------------------------------------------------*
* Type Declaration
TYPES:
  BEGIN OF lty_zcaconst,
    devid    TYPE zdevid,                                       "Development ID
    param1   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
    param2   TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
    srno     TYPE tvarv_numb,                                   "ABAP: Current selection number
    sign     TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
    opti     TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
    low      TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
    high     TYPE salv_de_selopt_high,                          "Upper Value of Selection Condition
    activate TYPE zconstactive,                                 "Activation indicator for constant
  END OF lty_zcaconst,

  BEGIN OF lty_item,
    zitem_cat1 TYPE pstyv,
    zitem_cat2 TYPE pstyv,
  END OF lty_item.
* local Internal Table Declaration
DATA:
  li_const TYPE STANDARD TABLE OF lty_zcaconst INITIAL SIZE 0,
  li_item  TYPE STANDARD TABLE OF lty_item     INITIAL SIZE 0,
  lir_ord  TYPE fip_t_auart_range,
  lv_item  TYPE char50,
  lv_valid TYPE flag.

CONSTANTS:
  lc_id_e060 TYPE zdevid     VALUE 'E060',                      "Development ID
  lc_otype   TYPE rvari_vnam VALUE 'AUART',                     "ABAP: Name of Variant Variable
  lc_ord     TYPE rvari_vnam VALUE 'ORDER',                       "ABAP: Name of Variant Variable
  lc_comma   TYPE char1      VALUE ','.

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
    INTO TABLE li_const
   WHERE devid    EQ lc_id_e060
     AND activate EQ abap_true.
IF sy-subrc EQ 0.
  LOOP AT li_const INTO DATA(lst_const).
    CASE lst_const-param1.
      WHEN lc_otype.
        CASE lst_const-param2.
          WHEN lc_ord.
*           Get the Order Types from Constant Table
            APPEND INITIAL LINE TO lir_ordtyp ASSIGNING FIELD-SYMBOL(<lst_otyp>).
            <lst_otyp>-sign   = lst_const-sign.
            <lst_otyp>-option = lst_const-opti.
            <lst_otyp>-low    = lst_const-low.
            <lst_otyp>-high   = lst_const-high.
          WHEN OTHERS.
*           Do nothing
        ENDCASE.
      WHEN OTHERS.
*       Do nothing
    ENDCASE.
  ENDLOOP. " LOOP AT li_const INTO lst_const
ENDIF. " IF sy-subrc EQ 0

IF vbak-auart IN lir_ordtyp AND                                 "Check for Order type
   t180-trtyp EQ charv.                                         "Only in Change Mode
  IF vbap-pstyv <> *vbap-pstyv.
    SELECT zitem_cat1
           zitem_cat2
      FROM zqtc_item_cat
      INTO TABLE li_item
      WHERE zitem_cat1 EQ *vbap-pstyv
      OR    zitem_cat2 EQ *vbap-pstyv.
    IF sy-subrc EQ 0.
      CLEAR: lv_item,
             lv_valid.
      LOOP AT li_item INTO DATA(lst_con).
        IF lst_con-zitem_cat1 = *vbap-pstyv.
          IF lv_item IS INITIAL.
            lv_item = lst_con-zitem_cat2.
          ELSE.
            CONCATENATE lv_item
                        lst_con-zitem_cat2
                        INTO lv_item
                        SEPARATED BY lc_comma.
          ENDIF.  "if lv_con_cat IS INITIAL.
          IF lst_con-zitem_cat2 EQ vbap-pstyv.
            lv_valid = abap_true.
          ENDIF.
        ELSE.
          IF lv_item IS INITIAL.
            lv_item = lst_con-zitem_cat1.
          ELSE.
            CONCATENATE lv_item
                        lst_con-zitem_cat1
                        INTO lv_item
                        SEPARATED BY lc_comma.
          ENDIF.  "if lv_con_cat IS INITIAL.
          IF lst_con-zitem_cat1 EQ vbap-pstyv.
            lv_valid = abap_true.
          ENDIF.
        ENDIF.    "IF lst_con-zitem_cat1 = *vbap-pstyv.
      ENDLOOP.
*     Check if the Item Category combination is a valid one
      IF lv_valid IS INITIAL.
        MESSAGE e208(zqtc_r2) WITH lv_item *vbap-pstyv.
      ENDIF. "IF sy-subrc EQ 0.
    ENDIF. " IF sy-subrc EQ 0.
  ENDIF.  "IF vbap-pstyv <> *vbap-pstyv.
ENDIF.  "IF vbak-auart IN lir_ordtyp.
