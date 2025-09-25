*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_DEFAULT_PAYMENT_TERM_CSS (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBKD(MV45AFZZ)"
* PROGRAM DESCRIPTION: Defaault the Payment terms for ZCSS orders for
*                      US advertising agency
* DEVELOPER: GKAMMILI
* CREATION DATE: 11/23/2020
* OBJECT ID: E260
* TRANSPORT NUMBER(S): ED2K920422
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_DEFAULT_PAYMENT_TERM_CSS (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBKD(MV45AFZZ)"
* PROGRAM DESCRIPTION: Defaault the Payment terms for ZCSS orders for
*                      US advertising agency for sales organizatons maintained
*                      constant table
* DEVELOPER: GKAMMILI
* CREATION DATE: 02/02/2021
* OBJECT ID: E260
* TRANSPORT NUMBER(S): ED2K921608
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
CONSTANTS:
  lc_dev_e260   TYPE zdevid     VALUE 'E260',       "Development ID
  lc_p_usage_i  TYPE rvari_vnam VALUE 'VKAUS', "Parameter: Uasge Indicator
  lc_p_zterm    TYPE rvari_vnam VALUE 'ZTERM',   "Parameter: Payment term
  lc_p_ord_type TYPE rvari_vnam VALUE 'AUART',   "Parameter: Order Type
  lc_p_sales_org TYPE rvari_vnam VALUE 'VKORG',   "Parameter: Sales Organization
  lc_p_cust_grp TYPE rvari_vnam VALUE 'KVGR1'.   "Parameter: Customer group

* Declare static : So value can be store till last call.
STATICS:
  lr_usage_i    TYPE RANGE OF vbak-abrvw,           "Payment Method
  lr_ord_type   TYPE RANGE OF vbak-auart,           "Order Type
  lr_sales_org  TYPE RANGE OF vbak-vkorg,           "Sales Organization
  lr_cust_grp   TYPE RANGE OF knvv-kvgr1,           "Customer Group
  lv_zterms      TYPE vbkd-zterm.                    "Terms of Payment Key

* Check the table and varable is empty or not.
IF lr_usage_i   IS INITIAL AND
   lr_ord_type  IS INITIAL AND
   lr_sales_org IS INITIAL AND
   lr_cust_grp  IS INITIAL AND
   lv_zterms   IS INITIAL.

* Fetch Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_dev_e260   "Development ID
    IMPORTING
      ex_constants = li_constants. "Constant Values
* fill the respective entries which are maintain in zcaconstant.
  LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constants>).
    CASE <lst_constants>-param1.
      WHEN lc_p_usage_i.
        APPEND INITIAL LINE TO lr_usage_i ASSIGNING FIELD-SYMBOL(<lst_usage_i>).
        <lst_usage_i>-sign   = <lst_constants>-sign.
        <lst_usage_i>-option = <lst_constants>-opti.
        <lst_usage_i>-low    = <lst_constants>-low.
        <lst_usage_i>-high   = <lst_constants>-high.
      WHEN lc_p_ord_type.
        APPEND INITIAL LINE TO lr_ord_type ASSIGNING FIELD-SYMBOL(<lst_ord_type>).
        <lst_ord_type>-sign   = <lst_constants>-sign.
        <lst_ord_type>-option = <lst_constants>-opti.
        <lst_ord_type>-low    = <lst_constants>-low.
        <lst_ord_type>-high   = <lst_constants>-high.
      WHEN lc_p_sales_org.
        APPEND INITIAL LINE TO lr_sales_org ASSIGNING FIELD-SYMBOL(<lst_sales_org>).
        <lst_sales_org>-sign   = <lst_constants>-sign.
        <lst_sales_org>-option = <lst_constants>-opti.
        <lst_sales_org>-low    = <lst_constants>-low.
        <lst_sales_org>-high   = <lst_constants>-high.
      WHEN lc_p_cust_grp.
        APPEND INITIAL LINE TO lr_cust_grp ASSIGNING FIELD-SYMBOL(<lst_cust_grp>).
        <lst_cust_grp>-sign   = <lst_constants>-sign.
        <lst_cust_grp>-option = <lst_constants>-opti.
        <lst_cust_grp>-low    = <lst_constants>-low.
        <lst_cust_grp>-high   = <lst_constants>-high.
      WHEN lc_p_zterm.
        lv_zterms = <lst_constants>-low.
      WHEN OTHERS.
*       Do nothing.
    ENDCASE.
  ENDLOOP. " LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constants>)
ENDIF. " IF lr_usage_i IS INITIAL
* Checking Usage Indicator, document type,sales organization and customer group
IF "( vbap-vkaus IN lr_usage_i  OR xvbap-vkaus IN lr_usage_i ) AND  "Commented by GKAMMILI for OTCM-36910 ED2K921608
   vbak-auart IN lr_ord_type  AND
   vbak-vkorg IN lr_sales_org AND
   vbak-kvgr1 IN lr_cust_grp.
  vbkd-zterm = lv_zterms. " Pass the payment term as (ZD09)
ENDIF. " IF vbap-vkaus IN lr_usage_i
