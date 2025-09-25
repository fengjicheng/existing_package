*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_OFFLINE_REL_ORD_01 (Include)
*               Called from "USEREXIT_SAVE_DOCUMENT(MV45AFZZ)"
* PROGRAM DESCRIPTION: Create Fulfillment Items in RAR for Offline
* Release Orders / Contacts
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 02/15/2018
* OBJECT ID: E141
* TRANSPORT NUMBER(S): ED2K910582
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
  CONSTANTS:
    lc_prm_ofl_relord TYPE rvari_vnam     VALUE 'OFFLINE_REL_ORD',        "ABAP: Name of Variant Variable
    lc_prm_order_type TYPE rvari_vnam     VALUE 'ORDER_TYPE',             "ABAP: Name of Variant Variable
    lc_devid_e141     TYPE zdevid         VALUE 'E141'.                   "Development ID

  DATA:
    li_constants      TYPE zcat_constants.                                "Constant Values

  STATICS:
    lir_auart_offline TYPE fip_t_auart_range.                             "Range: Sales Document Types

  IF lir_auart_offline[] IS INITIAL.
*   Fetch Constant Values
    CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
      EXPORTING
        im_devid     = lc_devid_e141                                      "Development ID: E141
      IMPORTING
        ex_constants = li_constants.                                      "Constant Values
    LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>).
      CASE <lst_constant>-param1.
        WHEN lc_prm_order_type.                                           "Order Type
          CASE <lst_constant>-param2.
            WHEN lc_prm_ofl_relord.                                       "Offline Release Order
              APPEND INITIAL LINE TO lir_auart_offline ASSIGNING FIELD-SYMBOL(<lst_auart_offline>).
              <lst_auart_offline>-sign   = <lst_constant>-sign.
              <lst_auart_offline>-option = <lst_constant>-opti.
              <lst_auart_offline>-low    = <lst_constant>-low.
              <lst_auart_offline>-high   = <lst_constant>-high.

            WHEN OTHERS.
*             Nothing to do
          ENDCASE.

        WHEN OTHERS.
*         Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF.

  IF vbak-auart IN lir_auart_offline.
    CALL FUNCTION 'ZRAR_CREATE_PGI_FOR_OFFLINE' IN UPDATE TASK
      EXPORTING
        im_s_xvbak = vbak
        im_t_xvbap = xvbap[].
  ENDIF.
