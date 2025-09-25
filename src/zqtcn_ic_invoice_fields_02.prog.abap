*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_IC_INVOICE_FIELDS_02 (Called from ZXF06U01)
* PROGRAM DESCRIPTION: IC Invoice Doc - Populate additional Fields
*                      Populate G/L Account and Company Code details
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   06/29/2017
* OBJECT ID: E163
* TRANSPORT NUMBER(S):  ED2K906862
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911464
* REFERENCE NO: ERP-7156
* DEVELOPER: Writtick Roy (WROY)
* DATE:  20-Mar-2018
* DESCRIPTION: Populate G/L Acc and Comp Code for Historical Credit Docs
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  YYYY-MM-DD
* DESCRIPTION:
*----------------------------------------------------------------------*
DATA:
  li_constnt TYPE zcat_constants.                               "Constant Values

STATICS:
  lr_bl_type TYPE j_3rs_so_invoice_sd.                          "Range: Billing Type

CONSTANTS:
  lc_dv_e160 TYPE zdevid     VALUE 'E160',                      "Development ID
  lc_p_bltyp TYPE rvari_vnam VALUE 'BILL_TYPE'.                 "Parameter: Billing Type

IF lr_bl_type[] IS INITIAL.
* Fetch Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_dv_e160                                 "Development ID
    IMPORTING
      ex_constants = li_constnt.                                "Constant Values
  LOOP AT li_constnt ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
      WHEN lc_p_bltyp.                                          "Parameter: Billing Type
*       Populate Range: Billing Type
        APPEND INITIAL LINE TO lr_bl_type ASSIGNING FIELD-SYMBOL(<lst_bl_type>).
        <lst_bl_type>-sign   = <lst_constant>-sign.
        <lst_bl_type>-option = <lst_constant>-opti.
        <lst_bl_type>-low    = <lst_constant>-low.
        <lst_bl_type>-high   = <lst_constant>-high.

      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.
ENDIF.

IF st_glbl_flds-bill_type NOT IN lr_bl_type.                    "Billing Type
  gl_account      = st_glbl_flds-gl_account.                    "G/L Account
  gl_company_code = st_glbl_flds-src_cmp_cd.                    "Source Company Code
ENDIF.
