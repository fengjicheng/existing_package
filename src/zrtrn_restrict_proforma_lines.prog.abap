*&---------------------------------------------------------------------*
*&  Include           ZRTRN_RESTRICT_PROFORMA_LINES
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:        ZRTRN_RESTRICT_PROFORMA_LINES (Include)
*                      [Copying Requirement Billing Doc Routine - 903]
* PROGRAM DESCRIPTION: Restrict ZF2 During Proforma Creation
* DEVELOPER:           Kiran Kumar Kumar
* CREATION DATE:       08/15/2018
* OBJECT ID:           E174
* TRANSPORT NUMBER(S): ED2K913060
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*

* Local data declarations
DATA:
    lv_restrict_zf2 TYPE char1 VALUE abap_true.
CONSTANTS:
  lc_devid_e174 TYPE zdevid      VALUE 'E174',                  "Development ID: E174
  lc_p1_sls_ofc TYPE rvari_vnam  VALUE 'SALES_OFFICE',          "Name of Variant Variable: Sales Office
  lc_p1_potype  TYPE rvari_vnam  VALUE 'PO_TYPE',               "Name of Variant PO type
  lc_p2_eal     TYPE rvari_vnam  VALUE 'EAL'.                   "Name of Variant Variable: EAL

IF lis_constants IS INITIAL.
* Get Cnonstant values
  SELECT devid,                                                  "Devid
         param1,                                                  "ABAP: Name of Variant Variable
         param2,                                                  "ABAP: Name of Variant Variable
         srno,                                                    "Current selection number
         sign,                                                    "ABAP: ID: I/E (include/exclude values)
         opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
         low,                                                     "Lower Value of Selection Condition
         high                                                     "Upper Value of Selection Condition
    FROM zcaconstant
    INTO TABLE @lis_constants
   WHERE devid    EQ @lc_devid_e174                               "Development ID
     AND activate EQ @abap_true.                                  "Only active record
  IF sy-subrc IS INITIAL.
    LOOP AT lis_constants ASSIGNING FIELD-SYMBOL(<lst_const_value>).
      CASE <lst_const_value>-param1.
        WHEN lc_p1_sls_ofc.                                       "Sales Office (SALES_OFFICE)
          CASE <lst_const_value>-param2.
            WHEN lc_p2_eal.                                       "EAL Only
              APPEND INITIAL LINE TO lrs_sales_offc ASSIGNING FIELD-SYMBOL(<lst_sales_offc>).
              <lst_sales_offc>-sign   = <lst_const_value>-sign.
              <lst_sales_offc>-option = <lst_const_value>-opti.
              <lst_sales_offc>-low    = <lst_const_value>-low.
              <lst_sales_offc>-high   = <lst_const_value>-high.
            WHEN OTHERS.
*           Nothing to do
          ENDCASE.
        WHEN lc_p1_potype.
          APPEND INITIAL LINE TO lrs_potype ASSIGNING FIELD-SYMBOL(<lst_potype>).
          <lst_potype>-sign   = <lst_const_value>-sign.
          <lst_potype>-option = <lst_const_value>-opti.
          <lst_potype>-low    = <lst_const_value>-low.
          <lst_potype>-high   = <lst_const_value>-high.
        WHEN OTHERS.
*       Nothing to do
      ENDCASE.
    ENDLOOP.
  ENDIF. " IF sy-subrc IS INITIAL
ENDIF.

IF vbak-vkbur IN lrs_sales_offc         "Sales office check
   AND vbak-bsark IN lrs_potype.        "PO type check
* IF Bill Plan items of current item has ZF5, then
* carry forward them to Proforma. ELSE restrict them(ZF2) to Proforma
  LOOP AT xfplt INTO DATA(lst_xfplt_current) WHERE fplnr = fplt-fplnr.
    CASE lst_xfplt_current-fareg.
      WHEN '4'.                          " Billing rule 4: down payment(Proforma-ZF5)
        lv_restrict_zf2 = abap_false.
      WHEN '5'.                          " Billing rule 5: down payment
        lv_restrict_zf2 = abap_false.
      WHEN OTHERS.
        " No need of others in this case
    ENDCASE.
    CLEAR lst_xfplt_current.
  ENDLOOP.

  IF lv_restrict_zf2 = abap_true.
    sy-subrc = 4.   " Restrict the item
  ENDIF.
ENDIF.
