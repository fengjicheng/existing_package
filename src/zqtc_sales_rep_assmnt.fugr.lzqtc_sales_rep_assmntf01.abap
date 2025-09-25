*----------------------------------------------------------------------*
***INCLUDE LZQTC_SALES_REP_ASSMNTF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_FILTER_PRODUCT
*&---------------------------------------------------------------------*
*       Filter records based on Product Details
*----------------------------------------------------------------------*
*      -->FP_IM_SREP_DET  Sales Rep Determination Details
*      -->FP_I_REPDET_IP  Sales Rep Records - I/P
*      <--FP_I_REPDET_IP  Sales Rep Records - O/P
*----------------------------------------------------------------------*
FORM f_filter_product  USING    fp_st_srep_det TYPE zstqtc_salesrep
                                fp_i_repdet_ip TYPE tt_zqtc_repdet
                       CHANGING fp_i_repdet_op TYPE tt_zqtc_repdet.

  DATA:
    li_repdet_ip TYPE tt_zqtc_repdet.

* Filter based on Product
  IF fp_i_repdet_op IS INITIAL AND
     fp_st_srep_det-matnr IS NOT INITIAL.
    li_repdet_ip[] = fp_i_repdet_ip[].
    DELETE li_repdet_ip WHERE matnr NE fp_st_srep_det-matnr.
    IF li_repdet_ip[] IS NOT INITIAL.
*     Filter records based on Industry Details
      PERFORM f_filter_industry USING    fp_st_srep_det
                                         li_repdet_ip
                                CHANGING fp_i_repdet_op.
    ENDIF.
  ENDIF.

* Filter based on Profit Center
  IF fp_i_repdet_op IS INITIAL AND
     fp_st_srep_det-prctr IS NOT INITIAL.
    li_repdet_ip[] = fp_i_repdet_ip[].
    DELETE li_repdet_ip WHERE prctr NE fp_st_srep_det-prctr.
    IF li_repdet_ip[] IS NOT INITIAL.
*     Filter records based on Industry Details
      PERFORM f_filter_industry USING    fp_st_srep_det
                                         li_repdet_ip
                                CHANGING fp_i_repdet_op.
    ENDIF.
  ENDIF.

* Filter based on Default
  IF fp_i_repdet_op IS INITIAL.
    li_repdet_ip[] = fp_i_repdet_ip[].
    DELETE li_repdet_ip WHERE matnr NE space
                           OR prctr NE space.
    IF li_repdet_ip[] IS NOT INITIAL.
*     Filter records based on Industry Details
      PERFORM f_filter_industry USING    fp_st_srep_det
                                         li_repdet_ip
                                CHANGING fp_i_repdet_op.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILTER_INDUSTRY
*&---------------------------------------------------------------------*
*       Filter records based on Industry Details
*----------------------------------------------------------------------*
*      -->FP_IM_SREP_DET  Sales Rep Determination Details
*      -->FP_I_REPDET_IP  Sales Rep Records - I/P
*      <--FP_I_REPDET_IP  Sales Rep Records - O/P
*----------------------------------------------------------------------*
FORM f_filter_industry  USING    fp_st_srep_det TYPE zstqtc_salesrep
                                 fp_i_repdet_ip TYPE tt_zqtc_repdet
                        CHANGING fp_i_repdet_op TYPE tt_zqtc_repdet.

  DATA:
    li_repdet_ip TYPE tt_zqtc_repdet.

* Filter based on Sold-to BPID
  IF fp_i_repdet_op IS INITIAL AND
     fp_st_srep_det-kunnr IS NOT INITIAL.
    li_repdet_ip[] = fp_i_repdet_ip[].
    DELETE li_repdet_ip WHERE kunnr NE fp_st_srep_det-kunnr.
    IF li_repdet_ip[] IS NOT INITIAL.
*     Filter records based on Geography Details
      PERFORM f_filter_geography USING    fp_st_srep_det
                                          li_repdet_ip
                                          abap_true
                                 CHANGING fp_i_repdet_op.
    ENDIF.
  ENDIF.

* Filter based on Customer Group (Full-3 Chars)
  IF fp_i_repdet_op IS INITIAL AND
     fp_st_srep_det-kvgr1 IS NOT INITIAL.
    li_repdet_ip[] = fp_i_repdet_ip[].
    DELETE li_repdet_ip WHERE kvgr1 NE fp_st_srep_det-kvgr1.
    IF li_repdet_ip[] IS NOT INITIAL.
*     Filter records based on Geography Details
      PERFORM f_filter_geography USING    fp_st_srep_det
                                          li_repdet_ip
                                          abap_false
                                 CHANGING fp_i_repdet_op.
    ENDIF.
  ENDIF.

* Filter based on Customer Group (First 2 Chars)
  IF fp_i_repdet_op IS INITIAL AND
     fp_st_srep_det-kvgr1 IS NOT INITIAL.
    li_repdet_ip[] = fp_i_repdet_ip[].
    DELETE li_repdet_ip WHERE kvgr1 NE fp_st_srep_det-kvgr1(2).
    IF li_repdet_ip[] IS NOT INITIAL.
*     Filter records based on Geography Details
      PERFORM f_filter_geography USING    fp_st_srep_det
                                          li_repdet_ip
                                          abap_false
                                 CHANGING fp_i_repdet_op.
    ENDIF.
  ENDIF.

* Filter based on Customer Group (First 1 Char)
  IF fp_i_repdet_op IS INITIAL AND
     fp_st_srep_det-kvgr1 IS NOT INITIAL.
    li_repdet_ip[] = fp_i_repdet_ip[].
    DELETE li_repdet_ip WHERE kvgr1 NE fp_st_srep_det-kvgr1(1).
    IF li_repdet_ip[] IS NOT INITIAL.
*     Filter records based on Geography Details
      PERFORM f_filter_geography USING    fp_st_srep_det
                                          li_repdet_ip
                                          abap_false
                                 CHANGING fp_i_repdet_op.
    ENDIF.
  ENDIF.

* Filter based on Default
  IF fp_i_repdet_op IS INITIAL.
    li_repdet_ip[] = fp_i_repdet_ip[].
    DELETE li_repdet_ip WHERE kunnr NE space
                           OR kvgr1 NE space.
    IF li_repdet_ip[] IS NOT INITIAL.
*     Filter records based on Geography Details
      PERFORM f_filter_geography USING    fp_st_srep_det
                                          li_repdet_ip
                                          abap_false
                                 CHANGING fp_i_repdet_op.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILTER_GEOGRAPHY
*&---------------------------------------------------------------------*
*       Filter records based on Geography Details
*----------------------------------------------------------------------*
*      -->FP_IM_SREP_DET  Sales Rep Determination Details
*      -->FP_I_REPDET_IP  Sales Rep Records - I/P
*      -->FP_NOT_APPLCBL  Flag: Geography - N/A
*      <--FP_I_REPDET_IP  Sales Rep Records - O/P
*----------------------------------------------------------------------*
FORM f_filter_geography  USING    fp_st_srep_det TYPE zstqtc_salesrep
                                  fp_i_repdet_ip TYPE tt_zqtc_repdet
                                  fp_not_applcbl TYPE flag
                         CHANGING fp_i_repdet_op TYPE tt_zqtc_repdet.

  DATA:
    lst_addr_sel TYPE addr1_sel,                           "Address selection parameter
    lst_addr_val TYPE addr1_val.                           "Address return structure

* When Geography is N/A (for Sold-to BPID)
  IF fp_not_applcbl IS NOT INITIAL.
    fp_i_repdet_op[] = fp_i_repdet_ip[].
    DELETE fp_i_repdet_op WHERE pstlz_f NE space
                             OR pstlz_t NE space
                             OR regio   NE space
                             OR land1   NE space.
    RETURN.
  ENDIF.

* Determine Address selection parameter
  IF fp_st_srep_det-adrnr CA '$'.                          "Temporary Address
    lst_addr_sel-addrhandle = fp_st_srep_det-adrnr.
  ELSE.
    lst_addr_sel-addrnumber = fp_st_srep_det-adrnr.
  ENDIF.
* Read an address without dialog
  CALL FUNCTION 'ADDR_GET'
    EXPORTING
      address_selection = lst_addr_sel                     "Address selection parameter
    IMPORTING
      address_value     = lst_addr_val                     "Address return structure
    EXCEPTIONS
      parameter_error   = 1
      address_not_exist = 2
      version_not_exist = 3
      internal_error    = 4
      address_blocked   = 5
      OTHERS            = 6.
  IF sy-subrc NE 0.
    CLEAR: lst_addr_val.
  ENDIF.

* Filter based on Postal Code (Individual)
  IF fp_i_repdet_op IS INITIAL AND
     lst_addr_val-post_code1 IS NOT INITIAL.
    fp_i_repdet_op[] = fp_i_repdet_ip[].
    DELETE fp_i_repdet_op WHERE pstlz_f NE lst_addr_val-post_code1
                             OR land1   NE lst_addr_val-country.
  ENDIF.

* Filter based on Postal Code (Range)
  IF fp_i_repdet_op IS INITIAL AND
     lst_addr_val-post_code1 IS NOT INITIAL.
    fp_i_repdet_op[] = fp_i_repdet_ip[].
    DELETE fp_i_repdet_op WHERE pstlz_f GT lst_addr_val-post_code1
                             OR pstlz_t LT lst_addr_val-post_code1
                             OR land1   NE lst_addr_val-country.
  ENDIF.

* Filter based on Region
  IF fp_i_repdet_op IS INITIAL AND
     lst_addr_val-region IS NOT INITIAL.
    fp_i_repdet_op[] = fp_i_repdet_ip[].
    DELETE fp_i_repdet_op WHERE regio   NE lst_addr_val-region
                             OR land1   NE lst_addr_val-country.
  ENDIF.

* Filter based on Country
  IF fp_i_repdet_op IS INITIAL AND
     lst_addr_val-country IS NOT INITIAL.
    fp_i_repdet_op[] = fp_i_repdet_ip[].
    DELETE fp_i_repdet_op WHERE pstlz_f NE space
                             OR pstlz_t NE space
                             OR regio   NE space
                             OR land1   NE lst_addr_val-country.
  ENDIF.

* Filter based on Default
  IF fp_i_repdet_op IS INITIAL.
    fp_i_repdet_op[] = fp_i_repdet_ip[].
    DELETE fp_i_repdet_op WHERE pstlz_f NE space
                             OR pstlz_t NE space
                             OR regio   NE space
                             OR land1   NE space.
  ENDIF.

ENDFORM.
