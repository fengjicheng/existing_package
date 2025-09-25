*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_BILL_PLAN_BILLING_DATE (Include)
*               Called from "EXIT_SAPLV60F_001 (ZX60FU01)"
* PROGRAM DESCRIPTION: Update the Billing Date in Billing Plan
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   05/19/2017
* OBJECT ID: E107
* TRANSPORT NUMBER(S): ED2K906169
*----------------------------------------------------------------------*
DATA:
  lv_strc_tkomk TYPE char40 VALUE '(SAPLV60F)TKOMK'.            "Communication Header for Pricing

FIELD-SYMBOLS:
  <lst_s_tkomk> TYPE komk.                                      "Communication Header for Pricing

DATA:
  lr_sofc_eal   TYPE rjksd_vkbur_range_tab,                     "Range: Sales Office (EAL)
  lr_sofc_n_eal TYPE rjksd_vkbur_range_tab.                     "Range: Sales Office (Non-EAL)

CONSTANTS:
  lc_devid_e164 TYPE zdevid      VALUE 'E164',                  "Development ID: E164
  lc_p1_sls_ofc TYPE rvari_vnam  VALUE 'SALES_OFFICE',          "Name of Variant Variable: Sales Office
  lc_p2_eal     TYPE rvari_vnam  VALUE 'EAL',                   "Name of Variant Variable: EAL
  lc_p2_non_eal TYPE rvari_vnam  VALUE 'NON_EAL'.               "Name of Variant Variable: NON_EAL

* Get Cnonstant values
SELECT param1,                                                  "ABAP: Name of Variant Variable
       param2,                                                  "ABAP: Name of Variant Variable
       srno,                                                    "Current selection number
       sign,                                                    "ABAP: ID: I/E (include/exclude values)
       opti,                                                    "ABAP: Selection option (EQ/BT/CP/...)
       low,                                                     "Lower Value of Selection Condition
       high                                                     "Upper Value of Selection Condition
  FROM zcaconstant
  INTO TABLE @DATA(li_const_values)
 WHERE devid    EQ @lc_devid_e164                               "Development ID
   AND activate EQ @abap_true.                                  "Only active record
IF sy-subrc IS INITIAL.
  LOOP AT li_const_values ASSIGNING FIELD-SYMBOL(<lst_const_value>).
    CASE <lst_const_value>-param1.
      WHEN lc_p1_sls_ofc.                                       "Sales Office (SALES_OFFICE)
        CASE <lst_const_value>-param2.
          WHEN lc_p2_eal.                                       "EAL Only
            APPEND INITIAL LINE TO lr_sofc_eal ASSIGNING FIELD-SYMBOL(<lst_sales_offc>).
            <lst_sales_offc>-sign   = <lst_const_value>-sign.
            <lst_sales_offc>-option = <lst_const_value>-opti.
            <lst_sales_offc>-low    = <lst_const_value>-low.
            <lst_sales_offc>-high   = <lst_const_value>-high.

          WHEN lc_p2_non_eal.                                   "Non-EAL Only
            APPEND INITIAL LINE TO lr_sofc_n_eal ASSIGNING <lst_sales_offc>.
            <lst_sales_offc>-sign   = <lst_const_value>-sign.
            <lst_sales_offc>-option = <lst_const_value>-opti.
            <lst_sales_offc>-low    = <lst_const_value>-low.
            <lst_sales_offc>-high   = <lst_const_value>-high.
          WHEN OTHERS.
*           Nothing to do
        ENDCASE.

      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF. " IF sy-subrc IS INITIAL

* Retrieve Communication Header for Pricing
ASSIGN (lv_strc_tkomk) TO <lst_s_tkomk>.
IF sy-subrc EQ 0.
* For all Non-EAL Orders, Billing Plan - Billing date will be Billing
* date for billing index and printout
  IF <lst_s_tkomk>-vkbur IN lr_sofc_n_eal.
    c_afdat = <lst_s_tkomk>-fkdat.                              "Billing date for billing index and printout
  ENDIF.

* For EAL Orders, Billing Plan – Billing Date will be Current date of
* Order Creation if the Date is in the Past
  IF <lst_s_tkomk>-vkbur IN lr_sofc_eal.
    IF c_afdat LT <lst_s_tkomk>-erdat.                          "Check for Past date
      c_afdat = <lst_s_tkomk>-erdat.                            "Date on Which Record Was Created
    ENDIF.
  ENDIF.

  e_afdat = c_afdat.                                            "Billing date for billing index and printout
ENDIF.
