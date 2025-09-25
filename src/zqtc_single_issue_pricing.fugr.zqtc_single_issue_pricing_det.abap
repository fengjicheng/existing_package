*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_SINGLE_ISSUE_PRICING_DET(Function Module)
* PROGRAM DESCRIPTION: Identify scenario for Single Issue Pricing
* DEVELOPER: Lucky Kodwani (LKODWANI)
* CREATION DATE:   05/11/2017
* OBJECT ID: E087
* TRANSPORT NUMBER(S): ED2K906020
*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTC_SINGLE_ISSUE_PRICING_DET(Function Module)
* PROGRAM DESCRIPTION: Added condition to populate
*                      customer group values from table ZCACONSTNAT
* DEVELOPER: Rajasekhar.T (RBTIRUMALA)
* CREATION DATE: 30/11/2018
* OBJECT ID: INC0219360
* TRANSPORT NUMBER(S): ED1K909055
*----------------------------------------------------------------------*
FUNCTION zqtc_single_issue_pricing_det.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_ST_KOMK) TYPE  KOMK
*"     REFERENCE(IM_ST_KOMP) TYPE  KOMP
*"  EXPORTING
*"     REFERENCE(EX_V_FLG_SIP) TYPE  FLAG
*"----------------------------------------------------------------------

* Type declaration
  TYPES:
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
    lst_const  TYPE ty_const.

* Internal Table Declaration
  DATA:
    lir_jrnl_i TYPE fip_t_mtart_range,                     "Range: Material Type
    lir_cust_g TYPE ltt_cust_g.                            "Range: Customer group

* Constants Declaration
  CONSTANTS:
    lc_param_m TYPE rvari_vnam     VALUE 'JRNL_ISSUE',     "ABAP: Name of Variant Variable
    lc_param_g TYPE rvari_vnam     VALUE 'CUST_GROUP',     "ABAP: Name of Variant Variable
    lc_level_3 TYPE ismhierarchlvl VALUE '3',              "Hierarchy Level (Issue)
    lc_devid   TYPE zdevid         VALUE 'E087'.           "Development ID

  IF i_consts IS INITIAL.
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
      INTO TABLE i_consts
     WHERE devid    EQ lc_devid
       AND activate EQ abap_true.                          "Only active record
    IF sy-subrc IS INITIAL.
      SORT i_consts BY devid param1 param2.
    ENDIF. " IF sy-subrc IS INITIAL
  ENDIF.

  LOOP AT i_consts INTO lst_const.
    CASE lst_const-param1.
      WHEN lc_param_m.                                     "Material Type
        APPEND INITIAL LINE TO lir_jrnl_i ASSIGNING FIELD-SYMBOL(<lst_jrnl_i>).
        <lst_jrnl_i>-sign   = lst_const-sign.
        <lst_jrnl_i>-option = lst_const-opti.
        <lst_jrnl_i>-low    = lst_const-low.
        <lst_jrnl_i>-high   = lst_const-high.

      WHEN lc_param_g.                                     "Customer Group
* Begin of ADD:INC0219360:RBTIRUMALA:30-Nov-2018:ED1K909055
        IF lst_const-param2 EQ space.                      "Field PARAM2 to Value is Blank
* End of ADD:INC0219360:RBTIRUMALA:30-Nov-2018:ED1K909055
          APPEND INITIAL LINE TO lir_cust_g ASSIGNING FIELD-SYMBOL(<lst_cust_g>).
          <lst_cust_g>-sign   = lst_const-sign.
          <lst_cust_g>-option = lst_const-opti.
          <lst_cust_g>-low    = lst_const-low.
          <lst_cust_g>-high   = lst_const-high.
* Begin of ADD:INC0219360:RBTIRUMALA:30-Nov-2018:ED1K909055
        ENDIF.
* End of ADD:INC0219360:RBTIRUMALA:30-Nov-2018:ED1K909055
      WHEN OTHERS.
*       Nothing to do
    ENDCASE.
  ENDLOOP.

  IF im_st_komk-kdgrp IN lir_cust_g.                       "Customer Group: 01-Individual
*   Check if the Material is an Issue (Level-3)
    CALL FUNCTION 'MARA_SINGLE_READ'
      EXPORTING
        matnr             = im_st_komp-rep_matnr           "Issue (Level-3)
      IMPORTING
        wmara             = lst_mara_3                     "General Material Data (L-3)
      EXCEPTIONS
        lock_on_material  = 1
        lock_system_error = 2
        wrong_call        = 3
        not_found         = 4
        OTHERS            = 5.
    IF sy-subrc EQ 0 AND
       lst_mara_3-ismhierarchlevl EQ lc_level_3 AND        "Check for Level-3
       lst_mara_3-mtart IN lir_jrnl_i.                     "Material type - Journal Issue
      ex_v_flg_sip = abap_true.                            "Flag: Single Issue Pricing
    ENDIF.
  ENDIF.

ENDFUNCTION.
