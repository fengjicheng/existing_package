*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SINGLE_ISSUE_PRC(Include)
* PROGRAM DESCRIPTION: Calculate prize of a single issue,
* the Single Issue Price is derived by dividing the Individual Print
* Price (Personal Rate) by the number of issues in a Subscription Offering
* DEVELOPER: Lucky Kodwani (LKODWANI)
* CREATION DATE:   11/16/2016
* OBJECT ID: E087
* TRANSPORT NUMBER(S): ED2K903256
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906547
* REFERENCE NO: CR#549
* DEVELOPER: Writtick Roy (WROY)
* DATE:  06-JUN-2017
* DESCRIPTION: For Billing Doc, Copy the price from old / ref value
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K907469
* REFERENCE NO: ERP-3496
* DEVELOPER: Writtick Roy (WROY)
* DATE:  24-JUL-2017
* DESCRIPTION: Check if the Document is being created wrt another one
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SINGLE_ISSUE_PRC
*&---------------------------------------------------------------------*

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
    sign   TYPE tvarv_sign,                           "Sign
    option TYPE tvarv_opti,                           "Option
    low    TYPE kdgrp,                                "Low
    high   TYPE kdgrp,                                "High
  END OF lty_cust_g,
  ltt_cust_g TYPE STANDARD TABLE OF lty_cust_g INITIAL SIZE 0.

* Workarea Declaration
DATA:
  lst_mara_3 TYPE mara,                               "General Material Data (L-3)
  lst_const  TYPE lty_const,

* Internal Table Declaration
  li_const   TYPE ltt_consts,                         "Internal table for Constant Table
* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
  li_cn_e075 TYPE zcat_constants,                     "Wiley Application Constant Table
  lir_dc_inv TYPE saco_vbtyp_ranges_tab,              "SD document category
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
  lir_jrnl_i TYPE fip_t_mtart_range,                  "Range: Material Type
  lir_cust_g TYPE ltt_cust_g.                         "Range: Customer group

DATA:
  lv_nrinyr  TYPE i,                                  "Issue Number (in Year Number)
* Begin of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
  lv_prc_typ TYPE salv_de_selopt_low,                 "Pricing Type
* End   of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
  lv_max_prc TYPE kwert.                              "Maximum Price

* Constants Declaration
CONSTANTS:
  lc_param_c TYPE rvari_vnam     VALUE 'CURRENCY',    "ABAP: Name of Variant Variable
  lc_param_m TYPE rvari_vnam     VALUE 'JRNL_ISSUE',  "ABAP: Name of Variant Variable
  lc_param_g TYPE rvari_vnam     VALUE 'CUST_GROUP',  "ABAP: Name of Variant Variable
* Begin of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
  lc_param_p TYPE rvari_vnam     VALUE 'PRICING_TYPE', "ABAP: Name of Variant Variable
* End   of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
  lc_param_d TYPE rvari_vnam     VALUE 'DOC_CATEGORY', "ABAP: Name of Variant Variable
  lc_param_i TYPE rvari_vnam     VALUE 'INVOICE',     "ABAP: Name of Variant Variable
  lc_id_e075 TYPE zdevid         VALUE 'E075',        "Development ID
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
  lc_level_3 TYPE ismhierarchlvl VALUE '3',           "Hierarchy Level (Issue)
  lc_devid   TYPE zdevid         VALUE 'E087'.        "Development ID

* Begin of ADD:CR#549:WROY:05-JUN-2017:ED2K906514
CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
  EXPORTING
    im_devid     = lc_id_e075
  IMPORTING
    ex_constants = li_cn_e075.
LOOP AT li_cn_e075 ASSIGNING FIELD-SYMBOL(<lst_const>).
  CASE <lst_const>-param1.
    WHEN lc_param_d.                                  "SD document category (DOC_CATEGORY)
      CASE <lst_const>-param2.
        WHEN lc_param_i.                              "Invoice (INVOICE)
          APPEND INITIAL LINE TO lir_dc_inv ASSIGNING FIELD-SYMBOL(<lst_dc_inv>).
          <lst_dc_inv>-sign   = <lst_const>-sign.
          <lst_dc_inv>-option = <lst_const>-opti.
          <lst_dc_inv>-low    = <lst_const>-low.
          <lst_dc_inv>-high   = <lst_const>-high.

        WHEN OTHERS.
*         Nothing to do
      ENDCASE.

*   Begin of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
    WHEN lc_param_p.                                  "Pricing Type (PRICING_TYPE)
      lv_prc_typ = <lst_const>-low.
*   End   of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469

    WHEN OTHERS.
*     Nothing to do
  ENDCASE.
ENDLOOP.
* For Billing Document, Copy the price from old / reference value
* Begin of DEL:ERP-3496:WROY:24-JUL-2017:ED2K907469
*IF komk-vbtyp IN lir_dc_inv.
* End   of DEL:ERP-3496:WROY:24-JUL-2017:ED2K907469
* Begin of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
IF preisfindungsart NA lv_prc_typ.
* End   of ADD:ERP-3496:WROY:24-JUL-2017:ED2K907469
* Begin of DEL:ERP-2435:WROY:27-JUN-2017:ED2K906957
* xkwert = ywert.
* End   of DEL:ERP-2435:WROY:27-JUN-2017:ED2K906957
* Begin of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
  IF xkwert IS INITIAL OR
     xkwert GT ywert.
    xkwert = ywert.
  ENDIF.
* End   of ADD:CR#564:WROY:06-JUL-2017:ED2K907135
  RETURN.
ENDIF.
* End   of ADD:CR#549:WROY:05-JUN-2017:ED2K906514

* Get data from constant table
SELECT devid                                          "Development ID
       param1                                         "ABAP: Name of Variant Variable
       param2                                         "ABAP: Name of Variant Variable
       srno                                           "Current selection number
       sign                                           "ABAP: ID: I/E (include/exclude values)
       opti                                           "ABAP: Selection option (EQ/BT/CP/...)
       low                                            "Lower Value of Selection Condition
       high                                           "Upper Value of Selection Condition
       activate                                       "Activation indicator for constant
  FROM zcaconstant                                    "Wiley Application Constant Table
  INTO TABLE li_const
 WHERE devid    EQ lc_devid
   AND activate EQ abap_true.                         "Only active record
IF sy-subrc IS INITIAL.
  SORT li_const BY devid param1 param2.

  LOOP AT li_const INTO lst_const.
    CASE lst_const-param1.
      WHEN lc_param_m.                                "Material Type
        APPEND INITIAL LINE TO lir_jrnl_i ASSIGNING FIELD-SYMBOL(<lst_jrnl_i>).
        <lst_jrnl_i>-sign   = lst_const-sign.
        <lst_jrnl_i>-option = lst_const-opti.
        <lst_jrnl_i>-low    = lst_const-low.
        <lst_jrnl_i>-high   = lst_const-high.

      WHEN lc_param_g.                                "Customer Group
        APPEND INITIAL LINE TO lir_cust_g ASSIGNING FIELD-SYMBOL(<lst_cust_g>).
        <lst_cust_g>-sign   = lst_const-sign.
        <lst_cust_g>-option = lst_const-opti.
        <lst_cust_g>-low    = lst_const-low.
        <lst_cust_g>-high   = lst_const-high.

      WHEN OTHERS.
*       Nothing to do
    ENDCASE.

  ENDLOOP.
ENDIF. " IF sy-subrc IS INITIAL

IF komk-kdgrp IN lir_cust_g.                          "Customer Group: 01-Individual
* Check if the Material is an Issue (Level-3)
  CALL FUNCTION 'MARA_SINGLE_READ'
    EXPORTING
      matnr             = komp-rep_matnr              "Issue (Level-3)
    IMPORTING
      wmara             = lst_mara_3                  "General Material Data (L-3)
    EXCEPTIONS
      lock_on_material  = 1
      lock_system_error = 2
      wrong_call        = 3
      not_found         = 4
      OTHERS            = 5.
  IF sy-subrc EQ 0 AND
     lst_mara_3-ismhierarchlevl EQ lc_level_3 AND     "Check for Level-3
     lst_mara_3-mtart IN lir_jrnl_i.                  "Material type - Journal Issue
*   Fetch IS-M: Media Product Issue Sequence
    SELECT COUNT( * )                                 "Issue Number (in Year Number)
      FROM jptmg0
      INTO lv_nrinyr
     WHERE med_prod  EQ lst_mara_3-ismrefmdprod       "Product (Level-2)
       AND ismyearnr EQ lst_mara_3-ismyearnr.         "Media issue year number
    IF sy-subrc EQ 0 AND
       lv_nrinyr IS NOT INITIAL.
*     Calculate Single Issue Price
      xkwert = xkwert / lv_nrinyr.                    "Price / Issue Number (in Year Number)
    ENDIF.

    IF xkwert IS NOT INITIAL .
      CLEAR: lst_const.
      READ TABLE li_const INTO lst_const
           WITH KEY devid  = lc_devid
                    param1 = lc_param_c
                    param2 = komk-waerk
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        lv_max_prc = lst_const-low.
*       Multiply with Quantity
        lv_max_prc = lv_max_prc * komp-mglme / 1000.

*       Check for Max price
        IF xkwert GT lv_max_prc.
          xkwert = lv_max_prc.
        ENDIF. " IF xkwert GT lst_const-low
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF xkwert IS NOT INITIAL
  ENDIF. " IF sy-subrc EQ 0 AND
ENDIF.
