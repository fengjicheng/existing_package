*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_RENEWALS_BILLING_DATE (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBKD(MV45AFZZ)"
* PROGRAM DESCRIPTION: Update Billing Date of Non-EAL Renewal Contracts
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE: 11/17/2017
* OBJECT ID: E164
* TRANSPORT NUMBER(S): ED2K909495
*----------------------------------------------------------------------*
DATA:
  li_constants  TYPE zcat_constants,                            "Wiley Application Constant Table
  lr_sofc_n_eal TYPE rjksd_vkbur_range_tab.                     "Range: Sales Office (Non-EAL)

CONSTANTS:
  lc_devid_e164 TYPE zdevid      VALUE 'E164',                  "Development ID: E164
  lc_p1_sls_ofc TYPE rvari_vnam  VALUE 'SALES_OFFICE',          "Name of Variant Variable: Sales Office
  lc_p2_non_eal TYPE rvari_vnam  VALUE 'NON_EAL'.               "Name of Variant Variable: NON_EAL

IF t180-trtyp EQ charh.                                         "Create
* Get Cnonstant values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_devid_e164                              "Development ID: E164
    IMPORTING
      ex_constants = li_constants.                              "Constant Values
  LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_const_value>).
    CASE <lst_const_value>-param1.
      WHEN lc_p1_sls_ofc.                                       "Sales Office (SALES_OFFICE)
        CASE <lst_const_value>-param2.
          WHEN lc_p2_non_eal.                                   "Non-EAL Only
            APPEND INITIAL LINE TO lr_sofc_n_eal ASSIGNING FIELD-SYMBOL(<lst_sales_offc>).
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

* For all Non-EAL Orders, Billing date will be Current date of Order Creation
  IF vbak-vkbur IN lr_sofc_n_eal.
    vbkd-fkdat = vbak-erdat.                                    "Billing date
  ENDIF.
ENDIF.
