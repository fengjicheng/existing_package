*----------------------------------------------------------------------*
* PROGRAM NAME: ZRTRN_COMPLETE_DELIVERY_FLAG (Include)
* PROGRAM DESCRIPTION: Ship Order Complete
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   09/22/2016
* OBJECT ID: E133
* TRANSPORT NUMBER(S): ED2K902982
*----------------------------------------------------------------------*
  DATA:
    lv_nfcnf   TYPE flag.                                  "Flag: Not Fully Confirmed

  FIELD-SYMBOLS:
    <lst_vbap> TYPE vbapvb.                                "Sales Document: Item Data

* Loop through all the Sales Documents
  LOOP AT cx_sd_order-vbak ASSIGNING <ls_vbak>.
    IF <ls_vbak>-autlf IS NOT INITIAL.                     "Flag: Complete delivery defined for each sales order?
      CLEAR: lv_nfcnf.
*     Loop through all the Items of a Sales Document
      READ TABLE cx_sd_order-vbap TRANSPORTING NO FIELDS
           WITH KEY vbeln = <ls_vbak>-vbeln                "Sales Document
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        LOOP AT cx_sd_order-vbap ASSIGNING <lst_vbap> FROM sy-tabix.
          IF <lst_vbap>-vbeln NE <ls_vbak>-vbeln.
            EXIT.
          ENDIF.
*         Check if the Sales Document Item Quantity is not fully confirmed
*         Cumulative Order Quantity in Sales Unit <> Cumulative Confirmed Quantity in Sales Unit
          IF <lst_vbap>-kwmeng NE <lst_vbap>-kbmeng.
            lv_nfcnf = abap_true.                          "Flag: Not Fully Confirmed
          ENDIF.
        ENDLOOP.
*       All Sales Document Item Quantities are fully confirmed
        IF lv_nfcnf IS INITIAL.
          CLEAR: <ls_vbak>-autlf.                          "Remove Flag: Complete delivery defined for each sales order?
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.
