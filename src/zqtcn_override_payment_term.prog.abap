*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_OVERRIDE_PAYMENT_TERM (Include)
*               Called from "USEREXIT_MOVE_FIELD_TO_VBKD(MV45AFZZ)"
* PROGRAM DESCRIPTION: Override the Payment terms if payment method found
* DEVELOPER: Yajuvendrasinh Raulji (Yraulji)
* CREATION DATE: 11/23/2017
* OBJECT ID: E0168
* TRANSPORT NUMBER(S): ED2K909533
*----------------------------------------------------------------------*
CONSTANTS:
  lc_dev_e168   TYPE zdevid     VALUE 'E168',       "Development ID
  lc_p_pay_meth TYPE rvari_vnam VALUE 'PAY_METHOD', "Parameter: Billing Type
  lc_p_pay_term TYPE rvari_vnam VALUE 'PAY_TERM'.   "Parameter: Item Number

* Declare static : So value can be store till last call.
STATICS:
  lr_pay_method TYPE RANGE OF vbkd-zlsch,           "Payment Method
  lv_pay_term   TYPE vbkd-zterm.                    "Terms of Payment Key

* Check the table and varable is empty or not.
IF lr_pay_method IS INITIAL AND
   lv_pay_term   IS INITIAL.

* Fetch Constant Values
  CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
    EXPORTING
      im_devid     = lc_dev_e168   "Development ID
    IMPORTING
      ex_constants = li_constants. "Constant Values
* fill the respective entries which are maintain in zcaconstant.
  LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>).
    CASE <lst_constant>-param1.
      WHEN lc_p_pay_meth.
        APPEND INITIAL LINE TO lr_pay_method ASSIGNING FIELD-SYMBOL(<lst_pay_method>).
        <lst_pay_method>-sign   = <lst_constant>-sign.
        <lst_pay_method>-option = <lst_constant>-opti.
        <lst_pay_method>-low    = <lst_constant>-low.
        <lst_pay_method>-high   = <lst_constant>-high.
      WHEN lc_p_pay_term.
        lv_pay_term = <lst_constant>-low.
      WHEN OTHERS.
*       Do nothing.
    ENDCASE.
  ENDLOOP. " LOOP AT li_constants ASSIGNING FIELD-SYMBOL(<lst_constant>)
ENDIF. " IF lr_pay_method IS INITIAL

* Check payment method : vbkd-zlsch as (1,2,A,C,T,D)
IF vbkd-zlsch IN lr_pay_method.
  vbkd-zterm = lv_pay_term. " Pass the payment term as (ZD00)
ENDIF. " IF vbkd-zlsch IN lr_pay_method
