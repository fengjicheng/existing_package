*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ORD_RES_BY_DOC_TYP_01 (Include)
*               Called from "USEREXIT_FIELD_MODIFICATION(MV45AFZZ)"
* PROGRAM DESCRIPTION: Order Reasons by Document Type
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   06/23/2017
* OBJECT ID: E161
* TRANSPORT NUMBER(S): ED2K906642
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_ORD_RES_BY_DOC_TYP_01 (Include)
*               Called from "USEREXIT_FIELD_MODIFICATION(MV45AFZZ)"
* PROGRAM DESCRIPTION: Order Reasons by Document Type
* DEVELOPER: Yajuvendrasinh RAulji (YRAULJI)
* CREATION DATE:   03/12/2018
* OBJECT ID: VA45_Performance Testing
* TRANSPORT NUMBER(S): ED2K910057
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*

TYPES:
  BEGIN OF lty_ord_res,
    ord_res     TYPE augru,                                          "Order reason
    ord_res_txt TYPE bezei40,                                        "Description
    auart       TYPE auart,                                          "Sales Document Type
  END OF lty_ord_res,
  ltt_ord_res TYPE STANDARD TABLE OF lty_ord_res INITIAL SIZE 0.

DATA:
  li_vrm_values TYPE vrm_values.                                     "Value table

STATICS:
  li_ord_reason TYPE ltt_ord_res.                                    "Order Reasons

CONSTANTS:
  lc_vbak_augru TYPE vrm_id       VALUE 'VBAK-AUGRU'.                "Name of Value Set

IF vbak-auart IS NOT INITIAL.                                        "Document Type
* Value Request Manager: Get Values for Valueset
  CALL FUNCTION 'VRM_GET_VALUES'
    EXPORTING
      id           = lc_vbak_augru                                   "Name of Value Set
    IMPORTING
      values       = li_vrm_values                                   "Value table
    EXCEPTIONS
      id_not_found = 1
      OTHERS       = 2.
  IF sy-subrc EQ 0 AND
     li_vrm_values IS INITIAL.
    READ TABLE li_ord_reason TRANSPORTING NO FIELDS
         WITH KEY auart = vbak-auart
         BINARY SEARCH.
    IF sy-subrc NE 0.
*     Fetch Order Reasons by Document Type
      SELECT tvaut~augru                                             "Order reason
      tvaut~bezei                                                    "Description
      zqtc_ord_reasons~auart                                         "Sales Document Type
      FROM zqtc_ord_reasons INNER JOIN tvaut
      ON tvaut~augru EQ zqtc_ord_reasons~augru
      AND tvaut~spras EQ sy-langu
      INTO TABLE li_ord_reason
      WHERE auart EQ vbak-auart.                                     "Document Type
      IF sy-subrc EQ 0.
        SORT li_ord_reason BY auart ord_res.
      ENDIF.
    ENDIF.

    IF li_ord_reason[] IS NOT INITIAL.
      LOOP AT li_ord_reason ASSIGNING FIELD-SYMBOL(<lst_ord_reason>).
        APPEND INITIAL LINE TO li_vrm_values ASSIGNING FIELD-SYMBOL(<lst_vrm_value>).
        <lst_vrm_value>-key  = <lst_ord_reason>-ord_res.             "Order reason
        <lst_vrm_value>-text = <lst_ord_reason>-ord_res_txt.         "Description
      ENDLOOP.
*     Value Request Manager: Set new Values for Valueset
      CALL FUNCTION 'VRM_SET_VALUES'
        EXPORTING
          id              = lc_vbak_augru                            "Name of Value Set
          values          = li_vrm_values                            "Value table
        EXCEPTIONS
          id_illegal_name = 1
          OTHERS          = 2.
      IF sy-subrc EQ 0.
*       Nothing to do
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
