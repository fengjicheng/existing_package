*----------------------------------------------------------------------*
* FUNCTION MODULE NAME: ZQTC_SALES_REP_ASSIGNMENT
* PROGRAM DESCRIPTION:Function Module for Subscription Order Status
* DEVELOPER: Sarada Mukherjee (SARMUKHERJ)
* CREATION DATE:   16/11/2016
* OBJECT ID: E130
* TRANSPORT NUMBER(S):   ED2K903282
*----------------------------------------------------------------------*
FUNCTION zqtc_sales_rep_assignment_det.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_SREP_DET) TYPE  ZSTQTC_SALESREP
*"  EXPORTING
*"     REFERENCE(EX_SREP1) TYPE  ZZSREP1
*"     REFERENCE(EX_SREP2) TYPE  ZZSREP2
*"----------------------------------------------------------------------
  DATA:
    li_repdet_op TYPE tt_zqtc_repdet.

  FIELD-SYMBOLS
    <lst_repdet> TYPE ty_zqtc_repdet.

  IF i_repdet_int[] IS INITIAL.
*   Selecting header data from ZQTC_REPDET table
    SELECT vkorg                                      "Sales Organization
           vtweg                                      "Distribution Channel
           spart                                      "Division
           datab                                      "Valid-From Date
           datbi                                      "Valid To Date
           matnr                                      "Material Number
           prctr                                      "Profit Center
           kunnr                                      "Customer Number
           kvgr1                                      "Customer group 1
           pstlz_f                                    "Postal Code (From)
           pstlz_t                                    "Postal Code (To)
           regio                                      "Region (State, Province, County)
           land1                                      "Country Key
           srep1                                      "Sales Rep-1
           srep2                                      "Sales Rep-2
      FROM zqtc_repdet
      INTO TABLE i_repdet_int
     WHERE vkorg EQ im_srep_det-vkorg                 "Sales Organization
       AND vtweg EQ im_srep_det-vtweg                 "Distribution Channel
       AND spart EQ im_srep_det-spart                 "Division
       AND datab LE im_srep_det-erdat                 "Valid-From Date
       AND datbi GE im_srep_det-erdat.                "Valid-To Date
    IF sy-subrc EQ 0.
*     Nothing to do
    ENDIF.
  ENDIF.

  IF i_repdet_int[] IS NOT INITIAL.
*   Filter records based on Product Details
    PERFORM f_filter_product USING    im_srep_det
                                      i_repdet_int
                             CHANGING li_repdet_op.

*   Populating sales representative value in export parameter
    LOOP AT li_repdet_op ASSIGNING <lst_repdet>.
      IF <lst_repdet>-srep1 IS NOT INITIAL.
        ex_srep1 = <lst_repdet>-srep1.                "Sales Representative 1
      ENDIF.
      IF <lst_repdet>-srep2 IS NOT INITIAL.
        ex_srep2 = <lst_repdet>-srep2.                "Sales Representative 2
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFUNCTION.
