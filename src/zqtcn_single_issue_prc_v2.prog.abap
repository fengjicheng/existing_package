*&---------------------------------------------------------------------*
*&  Include           ZQTCN_SINGLE_ISSUE_PRC_V2
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_SINGLE_ISSUE_PRC_V2 (Include)
* PROGRAM DESCRIPTION: To Calculate the Single Issue Price is
* derived by dividing the Individual Print Price (Personal Rate)
* by the number of issues in a Subscription Offering
* DEVELOPER: Rajasekhar.T (RBTIRUMALA)
* CREATION DATE: 29-AUG-2018
* OBJECT ID: CR#7497
* TRANSPORT NUMBER(S):ED2K913392,ED2K913511
*----------------------------------------------------------------------*
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
    ltt_consts TYPE STANDARD TABLE OF lty_const INITIAL SIZE 0,

    BEGIN OF lty_cust_g,
      sign   TYPE tvarv_sign,                           "Sign
      option TYPE tvarv_opti,                           "Option
      low    TYPE kdgrp,                                "Low
      high   TYPE kdgrp,                                "High
    END OF lty_cust_g,
    ltt_cust_g TYPE STANDARD TABLE OF lty_cust_g INITIAL SIZE 0.

* Workarea Declaration
  DATA:
    lst_mara_3    TYPE mara,                               "General Material Data (L-3)
    lst_const     TYPE lty_const,

* Internal Table Declaration
    li_const      TYPE ltt_consts,                         "Internal table for Constant Table
    li_cn_e075    TYPE zcat_constants,                     "Wiley Application Constant Table
    lir_dc_inv    TYPE saco_vbtyp_ranges_tab,              "SD document category
    lir_jrnl_i    TYPE fip_t_mtart_range,                  "Range: Material Type
    lir_cust_g    TYPE ltt_cust_g,                         "Range: Customer group
    lir_cust_gp01 TYPE ltt_cust_g.                      "Range: Customer group

  DATA:
    lv_nrinyr     TYPE i,                                  "Issue Number (in Year Number)
    lv_prc_typ    TYPE salv_de_selopt_low,                 "Pricing Type
    lv_max_prc    TYPE kwert,                              "Maximum Price
    lv_vari_fact  TYPE kwert,                              "Variable Factor
    lv_vari_round TYPE kwert.                              "Rounded Value

* Constants Declaration
  CONSTANTS:
    lc_param_c TYPE rvari_vnam     VALUE 'CURRENCY',        "ABAP: Name of Variant Variable
    lc_param_m TYPE rvari_vnam     VALUE 'JRNL_ISSUE',      "ABAP: Name of Variant Variable
    lc_param_g TYPE rvari_vnam     VALUE 'CUST_GROUP',      "ABAP: Name of Variant Variable
    lc_param_p TYPE rvari_vnam     VALUE 'PRICING_TYPE',    "ABAP: Name of Variant Variable
    lc_param_d TYPE rvari_vnam     VALUE 'DOC_CATEGORY',    "ABAP: Name of Variant Variable
    lc_param_i TYPE rvari_vnam     VALUE 'INVOICE',         "ABAP: Name of Variant Variable
    lc_id_e075 TYPE zdevid         VALUE 'E075',            "Development ID
    lc_level_3 TYPE ismhierarchlvl VALUE '3',               "Hierarchy Level (Issue)
    lc_devid   TYPE zdevid         VALUE 'E087',            "Development ID
    lc_param_v TYPE rvari_vnam     VALUE 'VARIABLE_FACTOR', "ABAP: Name of Variant Variable
    lc_param_1 TYPE rvari_vnam     VALUE 'MULTIPLE_ISSUE'.  "ABAP: Name of Variant Variable

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

      WHEN lc_param_p.                                  "Pricing Type (PRICING_TYPE)
        lv_prc_typ = <lst_const>-low.

      WHEN OTHERS.
*     Nothing to do
    ENDCASE.
  ENDLOOP.

* For Billing Document, Copy the price from old / reference value
  IF preisfindungsart NA lv_prc_typ.

    IF xkwert IS INITIAL OR
       xkwert GT ywert.
      xkwert = ywert.
    ENDIF.
    RETURN.
  ENDIF.

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
          IF lst_const-param2 EQ space.                 "Field PARAM2 to Value is Blank
            APPEND INITIAL LINE TO lir_cust_gp01 ASSIGNING FIELD-SYMBOL(<lst_cust_gp01>).
            <lst_cust_gp01>-sign   = lst_const-sign.
            <lst_cust_gp01>-option = lst_const-opti.
            <lst_cust_gp01>-low    = lst_const-low.
            <lst_cust_gp01>-high   = lst_const-high.
          ENDIF.

* Based ZCACONSTANT table with Field PARAM2 value to Genarate Dynamic structure lir_cust_p
          IF lst_const-param2 EQ lc_param_1.     "Field PARAM2 to Value MULTIPLE_ISSUE
            APPEND INITIAL LINE TO lir_cust_g ASSIGNING FIELD-SYMBOL(<lst_cust_g>).
            <lst_cust_g>-sign   = lst_const-sign.
            <lst_cust_g>-option = lst_const-opti.
            <lst_cust_g>-low    = lst_const-low.
            <lst_cust_g>-high   = lst_const-high.
          ENDIF.

        WHEN OTHERS.
*       Nothing to do
      ENDCASE.

    ENDLOOP.
  ENDIF. " IF sy-subrc IS INITIAL

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

  IF sy-subrc EQ 0.

    IF komk-kdgrp IN lir_cust_g AND                     "Customer Group: 02,03,04 and 05
       lst_mara_3-ismhierarchlevl EQ lc_level_3 AND     "Check for Level-3
       lst_mara_3-mtart IN lir_jrnl_i.                  "Material type - Journal Issue


*   Fetch IS-M: Media Product Issue Sequence
      SELECT COUNT( * )                                 "Issue Number (in Year Number)
        FROM jptmg0
        INTO lv_nrinyr
       WHERE med_prod  EQ lst_mara_3-ismrefmdprod       "Product (Level-2)
         AND ismyearnr EQ lst_mara_3-ismyearnr.         "Media issue year number

      IF sy-subrc EQ 0 AND
         lv_nrinyr IS NOT INITIAL AND
         komk-kdgrp IN lir_cust_g.                      "Customer Group: 02,03,04 and 05


        xkwert = ( xkomv-kbetr / lv_nrinyr ).        "Total list price / No of issues (in Year)
        lv_vari_fact = xkwert * lst_const-low / 100. "Caliculate Variable Facotor % based on ZCACONSTANT Value
        xkwert = xkwert + lv_vari_fact.              "Condition Value

        CALL FUNCTION 'FIMA_NUMERICAL_VALUE_ROUND' "Round numeric value
          EXPORTING
            i_rtype     = space
            i_runit     = 1
            i_value     = xkwert
          IMPORTING
            e_value_rnd = lv_vari_round.

        xkwert = lv_vari_round.                      "Value pass to the Condition value Field

      ENDIF.

    ELSEIF komk-kdgrp IN lir_cust_gp01 AND                "Customer Group: 01
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

    ENDIF.

  ENDIF.
