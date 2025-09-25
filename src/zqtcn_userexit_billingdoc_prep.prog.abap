*&---------------------------------------------------------------------*
*&  Include     ZQTCN_USEREXIT_BILLINGDOC_PREP
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_USEREXIT_BILLINGDOC_PREP(Include)
*               Called from "userexit_save_document_prepare(RV60AFZZ)"
* DEVELOPER      : Prabhu
* CREATION DATE  : 08/03/2018
* OBJECT ID      : E174 / CR6082
* TRANSPORT NUMBER(S):  ED2K913018
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:E164 /CR7804
* DEVELOPER: Kiran Jagana
* DATE:12/20/2018
* DESCRIPTION:Restrict mulitple proforma invoice creation.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:E213 /ERPM-934
* DEVELOPER: Prabhu
* DATE:08/22/2019
* DESCRIPTION:Invoice Cancellation Default Billing Date
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: E203/ERPM-24413
* REFERENCE NO:E203/ERPM-24413
* DEVELOPER: AMOHAMMED
* DATE:09/10/2020
* DESCRIPTION:Validation for output types for correct scenarios
*----------------------------------------------------------------------*

TYPES : BEGIN OF lty_constants,
          devid  TYPE zdevid,                                        "Devid
          param1 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
          param2 TYPE rvari_vnam,                                   "ABAP: Name of Variant Variable
          srno   TYPE tvarv_numb,                                   "Current selection number
          sign   TYPE tvarv_sign,                                   "ABAP: ID: I/E (include/exclude values)
          opti   TYPE tvarv_opti,                                   "ABAP: Selection option (EQ/BT/CP/...)
          low    TYPE salv_de_selopt_low,                           "Lower Value of Selection Condition
          high   TYPE salv_de_selopt_high,                          "higher Value of Selection Condition
        END OF lty_constants.
DATA : lv_activ_flag_e174   TYPE zactive_flag,              "Active / Inactive flag.
       lv_activ_flag_e174_8 TYPE zactive_flag,             "Active / Inactive flag.
       lv_activ_flag_e213   TYPE zactive_flag.              "Active / Inactive flag.

STATICS:
  lis_constants  TYPE STANDARD TABLE OF lty_constants,           "Itab for constants
  lis_const_e213 TYPE STANDARD TABLE OF lty_constants,           "Itab for constants
  lrs_sales_offc TYPE rjksd_vkbur_range_tab,                     "Range: Sales Office
  lrs_potype     TYPE STANDARD TABLE OF tds_rg_bsark,            "Range : PO type
  lrs_doctype    TYPE STANDARD TABLE OF range_fkart,             "Range billing type
  lrs_doc_cat    TYPE rjksd_vbtyp_range_tab.                     "Range sales doc category

CONSTANTS: lc_ser_num_e174_3 TYPE zsno   VALUE '003',        "Serial Number (002)
           lc_ser_num_e174_8 TYPE zsno   VALUE '008',        "Serial Number (002)
           lc_wricef_id_e174 TYPE zdevid VALUE 'E174',       "Constant value for WRICEF (E174),
           lc_ser_num_e213_1 TYPE zsno   VALUE '001',
           lc_wricef_id_e213 TYPE zdevid VALUE 'E213'.

*---------------------------------------------------------------------*
* * Custom Logic    * Check if enhancement needs to be triggered*
*---------------------------------------------------------------------*
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e174               "Constant value for WRICEF (E070)
    im_ser_num     = lc_ser_num_e174_3               "Serial Number (003)
  IMPORTING
    ex_active_flag = lv_activ_flag_e174.              "Active / Inactive flag
IF lv_activ_flag_e174 = abap_true.
  INCLUDE zqtcn_delete_additional_item IF FOUND.
ENDIF.
*---------------------------------------------------------------------*
* * Custom Logic    * Check if enhancement needs to be triggered*
*---------------------------------------------------------------------*
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e174                "Constant value for WRICEF (E070)
    im_ser_num     = lc_ser_num_e174_8                "Serial Number (008)
  IMPORTING
    ex_active_flag = lv_activ_flag_e174_8.            "Active / Inactive flag
IF lv_activ_flag_e174_8 = abap_true.
  INCLUDE zqtcn_restrict_proforma_comp IF FOUND.
ENDIF.
*---------------------------------------------------------------------*
* * Custom Logic    * Check if enhancement needs to be triggered*
*---------------------------------------------------------------------*
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e213                "Constant value for WRICEF (E213)
    im_ser_num     = lc_ser_num_e213_1                "Serial Number (001)
  IMPORTING
    ex_active_flag = lv_activ_flag_e213.            "Active / Inactive flag
IF lv_activ_flag_e213 = abap_true.
  INCLUDE zqtcn_default_billing_date IF FOUND.
ENDIF.

* Begin by AMOHAMMED on 09/10/2020 TR# ED2K919448
*--local constants
CONSTANTS:
  lc_wricef_id_e203 TYPE zdevid VALUE 'E203',     " Constant value for WRICEF (E203)
  lc_ser_num_e203_2 TYPE zsno   VALUE '002'.      " Serial Number (002)
*--local variables
DATA:
  lv_actv_flag_e203 TYPE zactive_flag.            " Active / Inactive flag
*-- Check if enhancement needs to be triggered
CALL FUNCTION 'ZCA_ENH_CONTROL'
  EXPORTING
    im_wricef_id   = lc_wricef_id_e203             " Constant value for WRICEF (E203)
    im_ser_num     = lc_ser_num_e203_2             " Serial Number (002)
  IMPORTING
    ex_active_flag = lv_actv_flag_e203.            " Active / Inactive flag
IF lv_actv_flag_e203 = abap_true.
  INCLUDE zqtcn_validate_output_e203 IF FOUND.
ENDIF.
* End by AMOHAMMED on 09/10/2020 TR# ED2K919448
