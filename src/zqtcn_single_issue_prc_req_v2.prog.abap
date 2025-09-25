*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SINGLE_ISSUE_PRC_REQ_V2
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:  ZQTCN_SINGLE_ISSUE_PRC_REQ_V2(Include)
* PROGRAM DESCRIPTION: Ignore Discounts for Single Issue Pricing
* DEVELOPER: Rajasekhar.T (RBTIRUMALA)
* CREATION DATE: 20/09/2018
* OBJECT ID: CR#7497
* TRANSPORT NUMBER(S): ED2K913392
*----------------------------------------------------------------------*
DATA:
  lv_flg_sip TYPE flag.                               "Flag: Single Issue Pricing

* Type declaration
TYPES:
  BEGIN OF lty_const,
    devid    TYPE zdevid,                             "Development ID
    param1   TYPE rvari_vnam,                         "Parameter1
    param2   TYPE rvari_vnam,                         "Parameter2
    srno     TYPE tvarv_numb,                         "Serial Number
    sign     TYPE tvarv_sign,                         "Sign
    opti     TYPE tvarv_opti,                         "Option
    low      TYPE salv_de_selopt_low,                 "Low
    high     TYPE salv_de_selopt_high,                "High
    activate TYPE zconstactive,                       "Active/Inactive Indicator
  END OF lty_const,
  ltt_consts TYPE STANDARD TABLE OF lty_const  INITIAL SIZE 0,

  BEGIN OF lty_cust_g,
    sign   TYPE tvarv_sign,                              "Sign
    option TYPE tvarv_opti,                              "Option
    low    TYPE kdgrp,                                   "Low
    high   TYPE kdgrp,                                   "High
  END OF lty_cust_g,
  ltt_cust_g TYPE STANDARD TABLE OF lty_cust_g INITIAL SIZE 0.

* Workarea Declaration
DATA:
  lst_mara_3 TYPE mara,                                  "General Material Data (L-3)
  lst_const  TYPE lty_const.

* Internal Table Declaration
DATA:
  li_consts     TYPE ltt_consts,
  lir_jrnl_i    TYPE fip_t_mtart_range,                     "Range: Material Type
  lir_cust_g    TYPE ltt_cust_g.                            "Range: Customer group

* Constants Declaration
CONSTANTS:
  lc_param_m TYPE rvari_vnam     VALUE 'JRNL_ISSUE',     "ABAP: Name of Variant Variable
  lc_param_g TYPE rvari_vnam     VALUE 'CUST_GROUP',     "ABAP: Name of Variant Variable
  lc_level_3 TYPE ismhierarchlvl VALUE '3',              "Hierarchy Level (Issue)
  lc_devid   TYPE zdevid         VALUE 'E087'.           "Development ID

IF li_consts IS INITIAL.
*   Get data from constant table
  SELECT devid                                           "Development ID
         param1                                          "ABAP: Name of Variant Variable
         param2                                          "ABAP: Name of Variant Variable
         srno                                            "Current selection number
         sign                                            "ABAP: ID: I/E (include/exclude values)
         opti                                            "ABAP: Selection option (EQ/BT/CP/...)
         low                                             "Lower Value of Selection Condition
         high                                            "Upper Value of Selection Condition
         activate                                        "Activation indicator for constant
    FROM zcaconstant                                     "Wiley Application Constant Table
    INTO TABLE li_consts
   WHERE devid    EQ lc_devid
     AND activate EQ abap_true.                          "Only active record

  IF sy-subrc IS INITIAL.
    SORT li_consts BY devid param1 param2.
  ENDIF. " IF sy-subrc IS INITIAL

ENDIF.

LOOP AT li_consts INTO lst_const.
  CASE lst_const-param1.
    WHEN lc_param_m.                                     "Material Type
      APPEND INITIAL LINE TO lir_jrnl_i ASSIGNING FIELD-SYMBOL(<lst_jrnl_i>).
      <lst_jrnl_i>-sign   = lst_const-sign.
      <lst_jrnl_i>-option = lst_const-opti.
      <lst_jrnl_i>-low    = lst_const-low.
      <lst_jrnl_i>-high   = lst_const-high.

    WHEN lc_param_g.                                 "Customer Group
        APPEND INITIAL LINE TO lir_cust_g ASSIGNING FIELD-SYMBOL(<lst_cust_g>).
        <lst_cust_g>-sign   = lst_const-sign.
        <lst_cust_g>-option = lst_const-opti.
        <lst_cust_g>-low    = lst_const-low.
        <lst_cust_g>-high   = lst_const-high.

    WHEN OTHERS.
*       Nothing to do
  ENDCASE.
ENDLOOP.

* Check if the Material is an Issue (Level-3)
  CALL FUNCTION 'MARA_SINGLE_READ'
    EXPORTING
      matnr             = komp-rep_matnr               "Issue (Level-3)
    IMPORTING
      wmara             = lst_mara_3                   "General Material Data (L-3)
    EXCEPTIONS
      lock_on_material  = 1
      lock_system_error = 2
      wrong_call        = 3
      not_found         = 4
      OTHERS            = 5.

  IF sy-subrc EQ 0 AND
     lst_mara_3-ismhierarchlevl EQ lc_level_3 AND        "Check for Level-3
     lst_mara_3-mtart IN lir_jrnl_i AND                  "Material type - Journal Issue
     komk-kdgrp IN lir_cust_g.                           "Customer Group 02,03,04 and 05

    sy-subrc = 0.

  ELSE.

    sy-subrc = 4.

    RETURN.
  ENDIF.
