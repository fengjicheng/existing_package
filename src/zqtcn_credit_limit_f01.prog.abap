*----------------------------------------------------------------------*
* PROGRAM NAME: ZQTCR_CREDIT_LIMIT_REP_R091
* PROGRAM DESCRIPTION: Customer Credit Limits Report.
* DEVELOPER:           Nageswara
* CREATION DATE:       09/03/2019
* OBJECT ID:           R091
* TRANSPORT NUMBER(S): ED2K916008
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO: <DER OR TPR OR SCR>
* DEVELOPER:
* DATE: MM/DD/YYYY
* DESCRIPTION:
*&---------------------------------------------------------------------*
*&  Include          ZQTCN_CREDIT_LIMIT_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_CREDIT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_credit_data .
  DATA: lv_query TYPE string,
        lv_input TYPE string,
        lv_block TYPE char1.

* Build dynamic where clause for Parameters
  CLEAR:lv_query.

* Creedit Management block
  IF p_block IS NOT INITIAL.
    CLEAR:lv_input.
    IF p_block EQ c_y.
      lv_block = abap_true.
    ELSE.
      CLEAR:lv_block.
    ENDIF.

    CONCATENATE text-q01 lv_block text-q01 INTO lv_input IN CHARACTER MODE.
    CONDENSE lv_input NO-GAPS.
    IF lv_query IS NOT INITIAL.
      CONCATENATE lv_query 'AND XBLOCKED = ' lv_input INTO lv_query
                         SEPARATED BY space IN CHARACTER MODE.
    ELSE.
      CONCATENATE 'XBLOCKED = ' lv_input INTO lv_query
                            SEPARATED BY space IN CHARACTER MODE.
    ENDIF.
  ENDIF.

* Fetch Credit data from database using CDS view
  FREE:i_ccl_001[].
  IF lv_query IS NOT INITIAL.
* Pulling all fields as most of the fields used in Report from CDS view
    SELECT mandt bp name1 name  name2 regio
           ort01  pstlz land1 stras bukrs zterm vtext zwels
           text2  vbeln auart erdat abstk order_rejection_status_desc vbtyp payer
           payer_name  payer_name1 payer_name2 payer_address payer_state payer_city  payer_country
           payer_postal_code  order_payment_terms order_payment_terms_desc
           order_payment_method  order_payment_method_desc customer_price_group  customer_group
           customer_condition_group  contract_start_date contract_end_date vkuegru bezei vbedkue
           xblocked  credit_limit  credit_sgmnt  waerk currency
      FROM zcds_ccl_001
      INTO TABLE i_ccl_001
      WHERE bukrs IN s_bukrs
        AND bp IN s_kunnr
        AND land1 IN s_land1
        AND auart IN s_auart
        AND vbedkue IN s_cldate
        AND vkuegru IN s_cancel
        AND abstk IN s_reject
        AND credit_sgmnt IN s_segmnt
        AND (lv_query).
    IF sy-subrc EQ 0.
      SORT:i_ccl_001[] BY bp.
    ENDIF.
  ELSE.

    SELECT mandt bp name1 name  name2 regio
           ort01  pstlz land1 stras bukrs zterm vtext zwels
           text2  vbeln auart erdat abstk order_rejection_status_desc vbtyp payer
           payer_name  payer_name1 payer_name2 payer_address payer_state payer_city  payer_country
           payer_postal_code  order_payment_terms order_payment_terms_desc
           order_payment_method  order_payment_method_desc customer_price_group  customer_group
           customer_condition_group  contract_start_date contract_end_date vkuegru bezei vbedkue
           xblocked  credit_limit  credit_sgmnt  waerk currency
      FROM zcds_ccl_001
    INTO TABLE i_ccl_001
    WHERE bukrs IN s_bukrs
      AND bp IN s_kunnr
      AND land1 IN s_land1
      AND auart IN s_auart
      AND vbedkue IN s_cldate
        AND vkuegru IN s_cancel
        AND abstk IN s_reject
      AND credit_sgmnt IN s_segmnt.
    IF sy-subrc EQ 0.
      SORT:i_ccl_001[] BY bp.
    ENDIF.
  ENDIF.


ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  F_BUILD_REPORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_report .
  DATA:lv_post_city TYPE char50,
       lv_amt       TYPE ukm_sgm_amount,
       lv_len       TYPE i,
       lv_ind       TYPE i,
       lv_sta       TYPE char1,
       lv_status    TYPE string,
       lv_expo      TYPE ukm_comm_total.

  IF i_ccl_001[] IS NOT INITIAL.
    SELECT land1, zlsch,text1
      FROM t042z
      INTO TABLE @DATA(li_t042z)
      FOR ALL ENTRIES IN @i_ccl_001
      WHERE land1 = @i_ccl_001-land1.
    IF sy-subrc EQ 0.
      SORT li_t042z BY land1 zlsch.
    ENDIF.
  ENDIF.

*  Prepare final output
  FREE:i_output[].
  LOOP AT i_ccl_001 ASSIGNING FIELD-SYMBOL(<lfs_ccl1>).

    APPEND INITIAL LINE TO i_output ASSIGNING FIELD-SYMBOL(<lfs_out>).

* Concatenate to display multiple status
    CLEAR:lv_len,lv_status.
    IF <lfs_ccl1>-zwels IS NOT INITIAL.
      lv_len = strlen( <lfs_ccl1>-zwels ).
      IF lv_len > 1.
        DO lv_len TIMES.
          CLEAR :lv_sta,lv_ind.
          lv_ind = sy-index - 1.
          lv_sta = <lfs_ccl1>-zwels+lv_ind(1).
          READ TABLE li_t042z ASSIGNING FIELD-SYMBOL(<lfs_t42z>) WITH KEY land1 = <lfs_ccl1>-land1
                                                                          zlsch = lv_sta BINARY SEARCH.
          IF sy-subrc EQ 0.
            IF lv_ind EQ 0.
              lv_status = <lfs_t42z>-text1.
            ELSE.
              CONCATENATE lv_status <lfs_t42z>-text1 INTO lv_status SEPARATED BY text-c01 IN CHARACTER MODE.
            ENDIF.
          ENDIF.
        ENDDO.
      ENDIF.                     "lv_len > 1.
    ENDIF.                       "if <lfs_out>-zwels is NOT INITIAL.
    CONCATENATE <lfs_ccl1>-pstlz <lfs_ccl1>-ort01 INTO <lfs_out>-city_post SEPARATED BY space
                                IN CHARACTER MODE.

    IF <lfs_ccl1>-credit_sgmnt IS NOT INITIAL.
* Call FM to fetch Credit Exposure for Customer and Credit Segment
      CALL FUNCTION 'UKM_COMMTS_BUPA_DISPLAY' ##FM_SUBRC_OK
        EXPORTING
          i_partner            = <lfs_ccl1>-bp
          i_segment            = <lfs_ccl1>-credit_sgmnt
*         I_DATE               =
          i_refresh            = abap_true
        IMPORTING
          e_commitments_amount = lv_expo
          e_amount_l           = lv_amt.
      ##FM_SUBRC_OK IF sy-subrc EQ 0.
        <lfs_out>-crexpo = lv_expo.
      ENDIF.
    ENDIF.


    <lfs_out>-kunnr     =  <lfs_ccl1>-bp.
    <lfs_out>-name1     =  <lfs_ccl1>-name1.
    <lfs_out>-land1     =  <lfs_ccl1>-land1.
    <lfs_out>-bukrs     =  <lfs_ccl1>-bukrs.
    <lfs_out>-zterm     =  <lfs_ccl1>-zterm.
    <lfs_out>-zwels     =  <lfs_ccl1>-zwels.
    <lfs_out>-crlimit   =  <lfs_ccl1>-credit_limit.
    <lfs_out>-cr_curr   =  <lfs_ccl1>-currency.
    <lfs_out>-vtext     =  <lfs_ccl1>-vtext.
    IF lv_len < 2.
      <lfs_out>-text2     =  <lfs_ccl1>-text2.
    ELSE.
      <lfs_out>-text2   = lv_status.
    ENDIF.
    <lfs_out>-xblocked  =  <lfs_ccl1>-xblocked.
    <lfs_out>-abstk     =  <lfs_ccl1>-abstk.
    IF <lfs_ccl1>-abstk = 'A'.
      <lfs_out>-abstk_t   = 'Nothing Rejected'(045).
    ELSEIF <lfs_ccl1>-abstk = 'B'.
      <lfs_out>-abstk_t   = 'Partially Rejected'(046).
    ELSEIF <lfs_ccl1>-abstk = 'C'.
      <lfs_out>-abstk_t   = 'Completely Rejected'(047).
    ENDIF.
*    <lfs_out>-abstk_t   =  <lfs_ccl1>-order_rejection_status_desc.
    <lfs_out>-vkuegru   =  <lfs_ccl1>-vkuegru.
    <lfs_out>-cancel_t  =  <lfs_ccl1>-bezei.
    <lfs_out>-vbedkue   =  <lfs_ccl1>-vbedkue.
    <lfs_out>-vbeln     =  <lfs_ccl1>-vbeln.
    <lfs_out>-auart     =  <lfs_ccl1>-auart.
    <lfs_out>-waerk     =  <lfs_ccl1>-waerk.
    <lfs_out>-ozterm    =  <lfs_ccl1>-order_payment_terms.
    <lfs_out>-ozterm_t  =  <lfs_ccl1>-order_payment_terms_desc.
    <lfs_out>-zlsch     =  <lfs_ccl1>-order_payment_method.
    <lfs_out>-ozlsch_t  =  <lfs_ccl1>-order_payment_method_desc.
    <lfs_out>-crseg     =  <lfs_ccl1>-credit_sgmnt.

    <lfs_out>-cravail = <lfs_ccl1>-credit_limit - <lfs_out>-crexpo.

  ENDLOOP.
  SORT i_output[] BY kunnr crseg vbeln.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_display_alv .
  DATA:lv_string   TYPE string,
       lv_fname    TYPE string,
       lv_fullpath TYPE localfile,
       lv_limit    TYPE char20,
       lst_layout  TYPE slis_layout_alv,
       lv_repid    TYPE sy-repid,
       lv_expos    TYPE char20,
       lv_avail    TYPE char20,
       lv_date     TYPE char8,
       lv_cnt      TYPE i.
  DATA : lv_path         TYPE filepath-pathintern .
  FIELD-SYMBOLS: <lfs>.

  CONSTANTS: lc_r091       TYPE zdevid VALUE 'R091',     " Dev ID
             lc_logic      TYPE rvari_vnam VALUE 'LOGICAL_PATH',  " Logical Path
             lc_underscore TYPE char1 VALUE '_',
             lc_comma      TYPE char1 VALUE ',',
             lc_slash      TYPE char1 VALUE '/',    " Slash of type CHAR1
             lc_extn       TYPE char4 VALUE '.XLS'. " Extn of type CHAR4

  FREE:i_alvfc[].
  CLEAR:st_alvfc.
  IF i_output[] IS INITIAL.
    MESSAGE 'No data found for given inputs!'(031)  TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSE.
* Fill ALV field catelog from table creation field catalog
    PERFORM f_build_fieldcatalog.

* Check Run mode
    IF sy-batch IS INITIAL .
      lst_layout-zebra = abap_true.
      lv_repid = sy-repid.
      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
        EXPORTING
          i_callback_program     = lv_repid
          i_callback_top_of_page = 'TOP_OF_PAGE'
          is_layout              = lst_layout
          it_fieldcat            = i_alvfc
        TABLES
          t_outtab               = i_output
        EXCEPTIONS
          program_error          = 1
          OTHERS                 = 2.
      IF sy-subrc = 0.
*
      ENDIF.
    ELSEIF sy-batch IS NOT INITIAL.
* Get Logical Path name
      SELECT SINGLE low FROM zcaconstant INTO @DATA(lv_logical)
         WHERE devid = @lc_r091
           AND param1 = @lc_logic
           AND activate = @abap_true.
      IF sy-subrc EQ 0.
* Generate File name in AL11
        CONCATENATE 'Credit_Limit_Rep'
                  lc_underscore
                  sy-datum
                  lc_underscore
                  sy-uzeit
                  lc_extn
                  INTO
                  lv_fname.

        lv_path = lv_logical.
*--*Read file path from transaction FILE and create complete file path
        CALL FUNCTION 'FILE_GET_NAME_USING_PATH'
          EXPORTING
            client                     = sy-mandt
            logical_path               = lv_path
            operating_system           = sy-opsys
            file_name                  = lv_fname
            eleminate_blanks           = abap_true
          IMPORTING
            file_name_with_path        = lv_fullpath
          EXCEPTIONS
            path_not_found             = 1
            missing_parameter          = 2
            operating_system_not_found = 3
            file_system_not_found      = 4
            OTHERS                     = 5.
        IF sy-subrc EQ 0.
* Place file in App server
          OPEN DATASET lv_fullpath FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
          IF sy-subrc EQ 0.

* Move Column names to AL11 file
            CONCATENATE text-011 text-012 text-013 text-014 text-015
                        text-016 text-035 text-017 text-034 text-018
                        text-020 text-019 text-042 text-021 text-022 text-023
                        text-024 text-025 text-038 text-026 text-039 text-027 text-028
                        text-037 text-029 text-030 text-036
                        INTO lv_string
              SEPARATED BY cl_abap_char_utilities=>horizontal_tab IN CHARACTER MODE.

            TRANSFER lv_string TO lv_fullpath.   " Column Names to AL11

* Move Credit limit data to AL11 file
            LOOP AT i_output INTO st_output.
              CLEAR:lv_string,lv_expos,lv_limit,lv_avail,lv_date.
              IF st_output-vbedkue IS NOT INITIAL.
                lv_date = st_output-vbedkue.
              ENDIF.
              lv_expos = st_output-crexpo.
              lv_limit = st_output-crlimit.
              lv_avail = st_output-cravail.
              CONCATENATE st_output-kunnr st_output-name1 st_output-city_post st_output-land1 st_output-bukrs
                          st_output-zterm st_output-vtext st_output-zwels st_output-text2 lv_limit lv_expos lv_avail st_output-cr_curr
                          st_output-crseg st_output-xblocked st_output-vbeln st_output-auart st_output-ozterm st_output-ozterm_t
                          st_output-zlsch st_output-ozlsch_t st_output-waerk st_output-vkuegru  st_output-cancel_t
                          lv_date st_output-abstk st_output-abstk_t
                  INTO lv_string

              SEPARATED BY cl_abap_char_utilities=>horizontal_tab IN CHARACTER MODE.
              TRANSFER lv_string TO lv_fullpath.
              CLEAR:st_output,lv_string.
            ENDLOOP.
            CLOSE DATASET lv_fullpath.
            CLEAR lv_string .
            CONCATENATE 'File processed at'(009) lv_fullpath 'successfully'(010) INTO lv_string SEPARATED BY space IN CHARACTER MODE.
            MESSAGE  lv_string TYPE 'S'.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_build_fieldcatalog .
  DATA:lv_cnt  TYPE i,
       lv_time TYPE char8.

  FREE:i_alvfc[].
  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'KUNNR'.
  st_alvfc-seltext_l = 'Customer'(011).
  st_alvfc-outputlen = 10.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'NAME1'.
  st_alvfc-seltext_l = 'Name'(012).
  st_alvfc-outputlen = 40.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'CITY_POST'.
  st_alvfc-seltext_l = 'Postal Code and City'(013).
  st_alvfc-outputlen = 23.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'LAND1'.
  st_alvfc-seltext_l = 'Country key'(014).
  st_alvfc-outputlen = 8.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'BUKRS'.
  st_alvfc-seltext_l = 'Company Code'(015).
  st_alvfc-outputlen = 12.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'ZTERM'.
  st_alvfc-seltext_l = 'Payment Terms(BP)'(016).
  st_alvfc-outputlen = 16.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'VTEXT'.
  st_alvfc-seltext_l = 'Payment Terms Desc(BP)'(035).
  st_alvfc-outputlen = 16.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'ZWELS'.
  st_alvfc-seltext_l = 'Payment Method(BP)'(017).
  st_alvfc-outputlen = 18.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'TEXT2'.
  st_alvfc-seltext_l = 'Payment Method Desc(BP)'(034).
  st_alvfc-outputlen = 20.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'CRLIMIT'.
  st_alvfc-seltext_l = 'Credit Limit'(018).
  st_alvfc-outputlen = 20.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'CREXPO'.
  st_alvfc-seltext_l = 'Credit Exposure'(020).
  st_alvfc-outputlen = 20.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'CRAVAIL'.
  st_alvfc-seltext_l = 'Available Credit Limit'(019).
  st_alvfc-outputlen = 25.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'CR_CURR'.
  st_alvfc-seltext_l = 'Cr Limit Curr'(042).
  st_alvfc-outputlen = 12.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'CRSEG'.
  st_alvfc-seltext_l = 'Credit Segment'(021).
  st_alvfc-outputlen = 20.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'XBLOCKED'.
  st_alvfc-seltext_l = 'Blocked in credit management'(022).
  st_alvfc-outputlen = 25.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'VBELN'.
  st_alvfc-seltext_l = 'Subscription/Contract ID'(023).
  st_alvfc-outputlen = 25.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'AUART'.
  st_alvfc-seltext_l = 'Order/Contract Type'(024).
  st_alvfc-outputlen = 20.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'OZTERM'.
  st_alvfc-seltext_l = 'Terms of Payment(order)'(025).
  st_alvfc-outputlen = 25.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'OZTERM_T'.
  st_alvfc-seltext_l = 'Terms of Payment(order) Desc'(038).
  st_alvfc-outputlen = 25.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'ZLSCH'.
  st_alvfc-seltext_l = 'Payment method(Order)'(026).
  st_alvfc-outputlen = 23.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'OZLSCH_T'.
  st_alvfc-seltext_l = 'Payment method(Order) Desc'(039).
  st_alvfc-outputlen = 23.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'WAERK'.
  st_alvfc-seltext_l = 'Document Currency'(027).
  st_alvfc-outputlen = 15.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'VKUEGRU'.
  st_alvfc-seltext_l = 'Reason for cancellation'(028).
  st_alvfc-outputlen = 23.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'CANCEL_T'.
  st_alvfc-seltext_l = 'Reason for Cancl. Desc'(037).
  st_alvfc-outputlen = 30.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'VBEDKUE'.
  st_alvfc-seltext_l = 'Date of cancellation'(029).
  st_alvfc-outputlen = 20.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'ABSTK'.
  st_alvfc-seltext_l = 'Rejection status'(030).
  st_alvfc-outputlen = 15.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

  lv_cnt = lv_cnt + 1.
  st_alvfc-fieldname = 'ABSTK_T'.
  st_alvfc-seltext_l = 'Rejection status Desc'(036).
  st_alvfc-outputlen = 20.
  APPEND st_alvfc TO i_alvfc.
  CLEAR:st_alvfc.

* Top-of-page event dat

*  Type H is used to display headers i.e. big font
  st_listheader-typ  = 'H'.
  st_listheader-info ='Customer Credit Limit/Exposure Report'(043).
  APPEND st_listheader TO i_listheader.
  CLEAR st_listheader.

*  Type S is used to display key and value pairs
  st_listheader-typ = 'S'.
  st_listheader-key = 'Date & Time :'(044) .
  CONCATENATE  sy-datum+6(2)
               sy-datum+4(2)
               sy-datum(4)
               INTO st_listheader-info
               SEPARATED BY '/'.
  CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) sy-uzeit+4(2) INTO lv_time SEPARATED BY ':' IN CHARACTER MODE.
  CONCATENATE st_listheader-info lv_time INTO st_listheader-info SEPARATED BY space IN CHARACTER MODE.
  APPEND st_listheader TO i_listheader.
  CLEAR st_listheader.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_COMPCODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_compcode .
  IF s_bukrs IS NOT INITIAL.
    SELECT SINGLE bukrs
      INTO @DATA(lv_bukrs)
      FROM t001
      WHERE bukrs IN @s_bukrs.
    IF sy-subrc NE 0.
      MESSAGE 'Invalid Company code!'(040) TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_CUSTOMER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_customer .
  IF s_kunnr IS NOT INITIAL.
    SELECT SINGLE kunnr
      INTO @DATA(lv_bp)
      FROM knb1
      WHERE kunnr IN @s_kunnr.
    IF sy-subrc NE 0.
      MESSAGE 'Invalid Business Partner!'(041) TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  top_of_page
*&---------------------------------------------------------------------*
FORM top_of_page.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = i_listheader.

ENDFORM.                    "top_of_page
