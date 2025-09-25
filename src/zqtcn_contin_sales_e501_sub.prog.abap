*&---------------------------------------------------------------------*
*&  Include           ZQTCN_CONTIN_SALES_E501_SUB
*&---------------------------------------------------------------------*
* PROGRAM NAME        : ZQTCR_CONTINUATION_SALES_E501                  *
* PROGRAM DESCRIPTION : Creating Child(Continuous)Sales Order Automatically
* DEVELOPER           : SRAMASUBRA (Sankarram R)                       *
* CREATION DATE       : 2022-04-07                                     *
* OBJECT ID           : E501/EAM-8355                                  *
* TRANSPORT NUMBER(S) : ED2K926637                                     *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR
*&---------------------------------------------------------------------*
*       Clear all Global Variables
*----------------------------------------------------------------------*
FORM f_clear .

  CLEAR:
    v_vkorg,
    v_auart,
    v_vtweg,
    v_email,
    v_isbn_cd_typ,
    v_pur_ord_typ
    .

  REFRESH:
    i_const_val,
    i_contract,
    i_matrl_code,
    i_vbpa_patnrs,
    i_matrl_mast,
    i_message,
    i_attach_total,
    i_packing_list,
    i_receivers,
    i_attachment,
    i_output
    .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANTS
*&---------------------------------------------------------------------*
*       Get Constant Values
*----------------------------------------------------------------------*
FORM f_get_constants .

* Fetch the constants
  SELECT
      devid,                                "Development ID
      param1,                               "ABAP: Name of Variant Variable
      param2,                               "ABAP: Name of Variant Variable
      srno,                                 "ABAP: Current selection number
      sign,                                 "ABAP: ID: I/E (include/exclude values)
      opti,                                 "ABAP: Selection option (EQ/BT/CP/...)
      low,                                  "Lower Value of Selection Condition
      high,                                 "Upper Value of Selection Condition
      activate                              "Activation indicator for constant
    FROM zcaconstant                        "Wiley Application Constant Table
    INTO TABLE @i_const_val
    WHERE devid    EQ @c_devid_e501
     AND  activate EQ @abap_true.
  IF sy-subrc <> 0.
    REFRESH i_const_val.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SCREEN_DYN
*&---------------------------------------------------------------------*
*       Screen Dynamic Values Change
*----------------------------------------------------------------------*
FORM f_screen_dyn .

* Local Constants Declarations
  CONSTANTS:
    lc_mstae TYPE rvari_vnam VALUE 'MSTAE',         " ABAP: Name of Variant Variable
    lc_auart TYPE rvari_vnam VALUE 'AUART',         " ABAP: Name of Variant Variable
    lc_vtweg TYPE rvari_vnam VALUE 'VTWEG',         " ABAP: Name of Variant Variable
    lc_vkorg TYPE rvari_vnam VALUE 'VKORG',         " ABAP: Name of Variant Variable
    lc_email TYPE rvari_vnam VALUE 'EMAIL',         " ABAP: Name of Variant Variable
    lc_isbnc TYPE rvari_vnam VALUE 'ISBNIDTYP',     " ABAP: Name of Variant Variable
    lc_bsark TYPE rvari_vnam VALUE 'BSARK',         " ABAP: Name of Variant Variable
    lc_eq    TYPE char2      VALUE 'EQ'             " For options
    .

  LOOP AT i_const_val ASSIGNING FIELD-SYMBOL(<lfst_const>).
    CASE <lfst_const>-param1.
      WHEN lc_mstae.
        s_status-sign   = sy-abcde+8(1).
        s_status-option = lc_eq.
        s_status-low    = <lfst_const>-low.
        s_status-high   = <lfst_const>-high.
        APPEND s_status.
      WHEN lc_vkorg.
        v_vkorg = <lfst_const>-low.
      WHEN lc_vtweg.
        v_vtweg = <lfst_const>-low.
      WHEN lc_auart.
        v_auart = <lfst_const>-low.
      WHEN lc_email.
        v_email = <lfst_const>-low.
      WHEN lc_isbnc.
        v_isbn_cd_typ = <lfst_const>-low.
      WHEN lc_bsark.
        v_pur_ord_typ = <lfst_const>-low.
    ENDCASE.
  ENDLOOP.

  DATA(lv_def_pdate) = sy-datum + 1.
  p_pdate = lv_def_pdate.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CHECK_PARAMS
*&---------------------------------------------------------------------*
*       Validation on Input Params
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_check_params .

  "Order Type Validation
  IF s_sotyp IS NOT INITIAL.
    SELECT SINGLE
        auart
      FROM tvak
      INTO @DATA(lv_auart)
      WHERE auart IN @s_sotyp.
    IF sy-subrc <> 0.
      MESSAGE text-004 TYPE c_err.
    ENDIF.
  ENDIF.

  "Serial No Validation
  IF s_sercd IS NOT INITIAL.
*BOC VMAMILLAPA
*    SELECT SINGLE
*        matnr
*      FROM mara
*      INTO @DATA(lv_matnr)
*      WHERE matnr IN @s_sercd.
*    IF sy-subrc <> 0.
*      MESSAGE text-005 TYPE c_err.
*    ENDIF.
    IF line_exists( i_const_val[ param1 = c_idcodetype ] ).
      DATA(lv_idcodetype) = CONV ismidcodetype( i_const_val[ param1 = c_idcodetype ]-low ).
      SELECT SINGLE identcode
        FROM jptidcdassign
        INTO @DATA(lv_identcode)
        WHERE idcodetype = @lv_idcodetype
        AND identcode IN @s_sercd.
      IF sy-subrc <> 0.
        MESSAGE text-005 TYPE c_err.
      ENDIF.
    ENDIF.
*EOC VMAMILLAPA
  ENDIF.

  "Customer No
  IF s_kunnr IS NOT INITIAL.
    SELECT SINGLE
        kunnr
     FROM kna1
     INTO @DATA(lv_kunnr)
     WHERE kunnr IN @s_kunnr.
    IF sy-subrc <> 0.
      MESSAGE text-006 TYPE c_err.
    ENDIF.
  ENDIF.

  "Mandatory Param Date Check
  IF p_pdate IS INITIAL.
    "Error: Mandatory to input Date
    MESSAGE text-007 TYPE c_err.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ENABLE_PARAMS
*&---------------------------------------------------------------------*
*       Enable/Disable Sel. Screen Params
*----------------------------------------------------------------------*
FORM f_enable_params .

  IF rb_pre_y IS NOT INITIAL.
    IF s_vbeln IS INITIAL.
      "Error: Mandatory to input Contract No
      SET CURSOR FIELD 'S_VBELN'.
      MESSAGE text-008 TYPE c_err.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_DATA
*&---------------------------------------------------------------------*
*       Fetch Data
*----------------------------------------------------------------------*
FORM f_fetch_data .
  "Get Contract Info
  PERFORM f_contract_data.
  "Get Mateial Code Assignment
  PERFORM f_matrl_assign.
* Material Master Data info
  PERFORM f_get_matrl.
* Contract Partners Info
  PERFORM f_get_partners.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CONTRACT_DATA
*&---------------------------------------------------------------------*
*       Get Contract Details
*----------------------------------------------------------------------*
FORM f_contract_data .
  IF line_exists( i_const_val[ param1 = c_idcodetype ] ).
    DATA(lv_idcodetype) = CONV ismidcodetype( i_const_val[ param1 = c_idcodetype ]-low ).
    SELECT
        vbak~vbeln, "Contract No
        vbap~posnr, "Cont. Line Item
        vbak~auart, "Doc. Type
        vbak~vkorg, "Sales Org.
        vbak~vtweg, "Dist. Channel
        vbak~spart, "Division
        vbak~kunnr, "Customer
        vbak~guebg, "From DAte
        vbak~gueen, "To Date
        vbak~lifsk, "Del. Block
        vbap~matnr, "Material No
        vbap~abgru, "Rej. Reason
        vbap~zmeng, "Qunatity
        vbap~kwmeng, "SO Order Qty.
        jptidcdassign~identcode
      INTO TABLE @i_contract
      FROM vbak
      INNER JOIN vbap
        ON  vbak~vbeln = vbap~vbeln
      INNER JOIN jptidcdassign
        ON vbap~matnr = jptidcdassign~matnr
      WHERE vbak~vbeln IN @s_vbeln
      AND   vbak~auart IN @s_sotyp
      AND   vbak~vkorg = @v_vkorg
      AND   vbak~kunnr IN @s_kunnr
      AND   vbak~guebg <= @p_pdate
      AND   vbak~gueen >= @p_pdate
      AND   jptidcdassign~idcodetype = @lv_idcodetype
      AND   jptidcdassign~identcode IN @s_sercd
      AND   vbap~abgru = @space
      .
    IF sy-subrc = 0.
      SORT i_contract BY vbeln ASCENDING
                         posnr ASCENDING.
    ELSE.
      MESSAGE s174(zqtc_r2) DISPLAY LIKE c_err.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MATRL_ASSIGN
*&---------------------------------------------------------------------*
*       Get Material Code Assignment
*----------------------------------------------------------------------*
FORM f_matrl_assign .

  IF i_contract IS NOT INITIAL.
    SELECT
        matnr,
        idcodetype,
        identcode,
        idcodearea
      FROM jptidcdassign
      INTO TABLE @i_matrl_code
      FOR ALL ENTRIES IN @i_contract
      WHERE identcode = @i_contract-identcode.
    IF sy-subrc = 0.
      SORT i_matrl_code BY matnr idcodetype identcode.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MATRL
*&---------------------------------------------------------------------*
*       Get Material Master DAta
*----------------------------------------------------------------------*
FORM f_get_matrl .

  IF i_matrl_code IS NOT INITIAL.
    SELECT
        matnr,
        bismt,
        mstae,
        ismpubldate
      FROM mara
      INTO TABLE @i_matrl_mast
      FOR ALL ENTRIES IN @i_matrl_code
      WHERE matnr =  @i_matrl_code-matnr
      AND   mstae IN @s_status
      AND   ismpubldate <= @p_pdate
      AND   ismpubldate >= @p_pdate.
    IF sy-subrc = 0.
      SORT i_matrl_mast BY matnr.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_PARTNERS
*&---------------------------------------------------------------------*
*       Get Patrners details
*----------------------------------------------------------------------*
FORM f_get_partners .
  "Local Data Decl.,
  DATA:
    lst_selopt TYPE selopt,
    li_parvw   TYPE STANDARD TABLE OF selopt.

  "Local Constant
  CONSTANTS:
    lc_ieq         TYPE char3  VALUE 'IEQ'.

  lst_selopt      = lc_ieq.
  lst_selopt-low  = c_shp_to.

  APPEND lst_selopt TO li_parvw.
  CLEAR: lst_selopt.

  lst_selopt      = lc_ieq.
  lst_selopt-low  = c_sld_to.

  APPEND lst_selopt TO li_parvw.
  CLEAR: lst_selopt.

  IF i_contract IS NOT INITIAL.
    SELECT
        vbeln,
        posnr,
        parvw,
        kunnr
      FROM vbpa
      INTO TABLE @i_vbpa_patnrs
      FOR ALL ENTRIES IN @i_contract
      WHERE vbeln = @i_contract-vbeln
      AND   parvw IN @li_parvw.
    IF sy-subrc = 0.
      SORT i_vbpa_patnrs BY vbeln parvw.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DATA_PROCESSING
*&---------------------------------------------------------------------*
*       Data Processing & SO Creation
*----------------------------------------------------------------------*
FORM f_data_processing .

* Local Data Declaration
  DATA:
    li_return     TYPE STANDARD TABLE OF bapiret2,   " Return messages
    li_itm        TYPE STANDARD TABLE OF bapisditm,  " Item data
    li_itmx       TYPE STANDARD TABLE OF bapisditmx, " Item data
    li_partn      TYPE STANDARD TABLE OF bapiparnr,  " Contract partner

    lst_hdrin     TYPE bapisdhd1,  " Header data
    lst_hrdinx    TYPE bapisdhd1x, " Header data extended for promo code
    lst_itm       TYPE bapisditm,  " Item data
    lst_itmx      TYPE bapisditmx, " Item data
    lst_partn     TYPE bapiparnr,  " Contract partner
    lst_return    TYPE bapiret2,   " For status of contract creation
    lst_output    TYPE ty_output,   " For status of contract creation

    lv_salesdocin TYPE bapivbeln-vbeln,  "for export field
    lv_posnr      TYPE posnr   VALUE '000010',
    lv_itm_no     TYPE posnr
    .

* Local Constants
  CONSTANTS:
    lc_suc_msgno  TYPE symsgno       VALUE '311'   "Add SO No Msg Alone to O/P
    .

  DATA(li_vbpa) = i_vbpa_patnrs.
  SORT li_vbpa BY vbeln posnr parvw.

* Get ISBN Linked Materials
  IF i_matrl_code IS NOT INITIAL.
    SELECT
        matnr,
        idcodetype,
        identcode
      FROM jptidcdassign
      INTO TABLE @DATA(li_isbn_mtrl)
      FOR ALL ENTRIES IN @i_matrl_code
      WHERE matnr       = @i_matrl_code-matnr
      AND   idcodetype  = @v_isbn_cd_typ.
    IF sy-subrc = 0.
      SORT li_isbn_mtrl BY matnr.
    ENDIF.
  ENDIF.

  DATA(lv_idcodetype) = CONV ismidcodetype( i_const_val[ param1 = c_idcodetype ]-low ).

  LOOP AT i_contract ASSIGNING FIELD-SYMBOL(<lfst_cntrt>).

*   Header Info
    lst_hdrin-doc_type   = v_auart.
    lst_hdrin-sales_org  = v_vkorg.
    lst_hdrin-distr_chan = v_vtweg.
    lst_hdrin-division   = <lfst_cntrt>-spart.
    lst_hdrin-ref_doc    = <lfst_cntrt>-vbeln.
    lst_hdrin-po_method  = v_pur_ord_typ.
    lst_hdrin-refdoc_cat = sy-abcde+6(1).

    lst_hrdinx-doc_type   = abap_on.
    lst_hrdinx-sales_org  = abap_on.
    lst_hrdinx-distr_chan = abap_on.
    lst_hrdinx-division   = abap_on.
    lst_hrdinx-ref_doc    = abap_on.
    lst_hrdinx-refdoc_cat = abap_on.
    lst_hrdinx-po_method  = abap_on.
    lst_hrdinx-updateflag = sy-abcde+8(1).

*  Partners Info - Sold To
    READ TABLE i_vbpa_patnrs INTO DATA(lst_sld)
      WITH KEY vbeln = <lfst_cntrt>-vbeln
               parvw = c_sld_to
      BINARY SEARCH.
    IF sy-subrc = 0.
      lst_partn-partn_role = lst_sld-parvw.
      lst_partn-partn_numb = lst_sld-kunnr.
      lst_partn-itm_number = lst_sld-posnr.

      APPEND lst_partn TO li_partn.
      CLEAR: lst_sld, lst_partn.
    ENDIF.

*   Partners Info - Shop To
    READ TABLE li_vbpa INTO DATA(lst_shp)
      WITH KEY vbeln = <lfst_cntrt>-vbeln
               posnr = <lfst_cntrt>-posnr
               parvw = c_shp_to
      BINARY SEARCH.
    IF sy-subrc <> 0.
      READ TABLE i_vbpa_patnrs INTO lst_shp
        WITH KEY vbeln = <lfst_cntrt>-vbeln
                 parvw = c_shp_to
      BINARY SEARCH.
      IF sy-subrc = 0.
        lst_partn-partn_role = lst_shp-parvw.
        lst_partn-partn_numb = lst_shp-kunnr.
        lst_partn-itm_number = lst_shp-posnr.

        APPEND lst_partn TO li_partn.
        CLEAR: lst_shp, lst_partn.
      ENDIF.
    ENDIF.

    LOOP AT i_matrl_code INTO DATA(lst_mtrl_cd)
      WHERE identcode  = <lfst_cntrt>-identcode
      AND   idcodetype = lv_idcodetype.

      IF lst_mtrl_cd-matnr <> <lfst_cntrt>-matnr.
        READ TABLE li_isbn_mtrl INTO DATA(lst_mat_assgn)
          WITH KEY matnr = lst_mtrl_cd-matnr
          BINARY SEARCH.
        IF sy-subrc = 0.
          READ TABLE i_matrl_mast INTO DATA(lst_mtrl_mst)
            WITH KEY matnr = lst_mat_assgn-matnr
            BINARY SEARCH.
          IF sy-subrc <> 0.
            CLEAR: lst_mtrl_mst.
            EXIT.
          ENDIF.
        ENDIF.
      ELSE.
        EXIT.
      ENDIF.

*     Item Info
      IF lv_itm_no IS INITIAL.
        lv_itm_no = lv_posnr.
        lst_itm-itm_number     =  lv_itm_no.
      ELSE.
        lv_itm_no = lv_itm_no + 10.
        lst_itm-itm_number     =  lv_itm_no.
      ENDIF.
      lst_itm-material       =  lst_mtrl_mst-matnr.
      lst_itm-target_qty     =  <lfst_cntrt>-zmeng.
      lst_itm-reason_rej     =  <lfst_cntrt>-abgru.
      lst_itm-ref_doc        =  <lfst_cntrt>-vbeln.
      lst_itm-ref_doc_it     =  <lfst_cntrt>-posnr.
      lst_itm-ref_doc_ca     =  sy-abcde+6(1).

      APPEND lst_itm TO li_itm.
      CLEAR lst_itm.

      lst_itmx-itm_number     =  lv_itm_no. "abap_on.
      lst_itmx-material       =  abap_on.
      lst_itmx-target_qty     =  abap_on.
      lst_itmx-reason_rej     =  abap_on.
      lst_itmx-ref_doc        =  abap_on.
      lst_itmx-ref_doc_it     =  abap_on.
      lst_itmx-ref_doc_ca     =  abap_on.

      APPEND lst_itmx TO li_itmx.
      CLEAR  lst_itmx.

      CLEAR: lst_mtrl_cd, lst_mat_assgn, lst_mtrl_mst.
    ENDLOOP.
    CHECK li_itm IS NOT INITIAL.
*====================================================================*
*     Call BAPI
*====================================================================*
    CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
      EXPORTING
        order_header_in  = lst_hdrin
        order_header_inx = lst_hrdinx
      IMPORTING
        salesdocument    = lv_salesdocin
      TABLES
        return           = li_return
        order_items_in   = li_itm
        order_items_inx  = li_itmx
        order_partners   = li_partn.
    IF NOT li_return IS INITIAL.
      READ TABLE li_return TRANSPORTING NO FIELDS
        WITH KEY type = sy-abcde+4(1).
      IF sy-subrc = 0.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ELSE.
        READ TABLE li_return TRANSPORTING NO FIELDS
          WITH KEY type = sy-abcde+0(1).
        IF sy-subrc = 0.
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        ELSE.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_on.
        ENDIF.
      ENDIF.
      DATA(li_ret_tmp) = li_return.
      SORT li_ret_tmp BY type.
      DELETE li_ret_tmp WHERE type NE sy-abcde+4(1).
      IF li_ret_tmp[] IS NOT INITIAL.
        LOOP AT li_return INTO lst_return
          WHERE type = sy-abcde+4(1).

          lst_output-ser_code    = <lfst_cntrt>-identcode.    " Series Code Number
          lst_output-contrct_no = <lfst_cntrt>-vbeln.
          lst_output-item_no    = <lfst_cntrt>-posnr.
          lst_output-customer   = <lfst_cntrt>-kunnr.
          lst_output-so_no      = lv_salesdocin.
          lst_output-matrl_no   = lst_mtrl_mst-matnr.
          lst_output-isbn_mat   = lst_mtrl_mst-bismt.
          lst_output-qty        = <lfst_cntrt>-kwmeng.
          lst_output-remarks    = lst_return-message.
          lst_output-status     = text-030.            "FAil

          APPEND lst_output TO i_output.
          CLEAR: lst_output.

        ENDLOOP.
      ELSE.
        READ TABLE li_return INTO lst_return
          WITH KEY type   = sy-abcde+18(1)
                   number = lc_suc_msgno.
        IF sy-subrc = 0.
          LOOP AT i_matrl_code INTO lst_mtrl_cd
            WHERE identcode  = <lfst_cntrt>-identcode
            AND   idcodetype = lv_idcodetype.
            IF lst_mtrl_cd-matnr <> <lfst_cntrt>-matnr.
              READ TABLE li_isbn_mtrl INTO lst_mat_assgn
                WITH KEY matnr = lst_mtrl_cd-matnr
                BINARY SEARCH.
              IF sy-subrc = 0.
                READ TABLE i_matrl_mast INTO lst_mtrl_mst
                  WITH KEY matnr = lst_mat_assgn-matnr
                  BINARY SEARCH.
                IF sy-subrc = 0.
                  lst_output-ser_code   = <lfst_cntrt>-identcode.    " Series Code Number
                  lst_output-contrct_no = <lfst_cntrt>-vbeln.
                  lst_output-item_no    = <lfst_cntrt>-posnr.
                  lst_output-customer   = <lfst_cntrt>-kunnr.
                  lst_output-so_no      = lv_salesdocin.
                  lst_output-matrl_no   = lst_mtrl_mst-matnr.
                  lst_output-isbn_mat   = lst_mtrl_mst-bismt.
                  lst_output-qty        = <lfst_cntrt>-kwmeng.

                  IF lst_return-message IS INITIAL.
                    lst_output-remarks    = text-018.
                  ELSE.
                    lst_output-remarks    = lst_return-message.
                  ENDIF.
                  lst_output-status     = text-031.            "Success

                  APPEND lst_output TO i_output.
                  CLEAR: lst_output.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.
    CLEAR: lv_itm_no, lst_hdrin, lst_hrdinx, lst_itm, lst_itmx, lst_output.
    REFRESH: li_itm, li_itmx, li_partn, li_return.
  ENDLOOP.

  IF sy-batch EQ abap_on.
    "Send the processing log as Email
    PERFORM f_send_log_email.
  ELSE.
    IF i_output IS NOT INITIAL.
      "Display ALV Output
      PERFORM f_display_output.
    ELSE.
      MESSAGE s015(zqtc_r2) DISPLAY LIKE c_err.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_OUTPUT
*&---------------------------------------------------------------------*
*       Display ALV Output
*----------------------------------------------------------------------*
FORM f_display_output .

  TYPE-POOLS : slis.

* Loacl Data Decl.,
  DATA :
    li_fcat    TYPE slis_t_fieldcat_alv,
    lst_fcat   TYPE slis_fieldcat_alv,
    lst_layout TYPE slis_layout_alv,
    lv_val     TYPE i VALUE 1.

* Local Constants
  CONSTANTS:
    lc_ser_code   TYPE slis_fieldname VALUE 'SER_CODE',
    lc_contrct_no TYPE slis_fieldname VALUE 'CONTRCT_NO',
    lc_contrct_it TYPE slis_fieldname VALUE 'ITEM_NO',
    lc_customer   TYPE slis_fieldname VALUE 'CUSTOMER',
    lc_so_no      TYPE slis_fieldname VALUE 'SO_NO',
    lc_matrl_no   TYPE slis_fieldname VALUE 'MATRL_NO',
    lc_old_mat_no TYPE slis_fieldname VALUE 'ISBN_MAT',
    lc_qty        TYPE slis_fieldname VALUE 'QTY',
    lc_status     TYPE slis_fieldname VALUE 'STATUS',
    lc_remarks    TYPE slis_fieldname VALUE 'REMARKS',

    lc_tab_name   TYPE slis_tabname   VALUE 'I_OUTPUT'.


  lst_layout-colwidth_optimize = abap_on.
  lst_layout-zebra = abap_on.

  CLEAR: lv_val.
  lst_fcat-fieldname      = lc_ser_code.
  lst_fcat-tabname        = lc_tab_name.
  lst_fcat-seltext_m      = text-010. "Series Code
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname      = lc_contrct_no.
  lst_fcat-tabname        = lc_tab_name.
  lst_fcat-seltext_m      = text-011. "Contract No
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname      = lc_contrct_it.
  lst_fcat-tabname        = lc_tab_name.
  lst_fcat-seltext_m      = text-032. "Contract Line Item
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname      = lc_customer.
  lst_fcat-tabname        = lc_tab_name.
  lst_fcat-seltext_m      = text-012. "Customer
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname      = lc_so_no.
  lst_fcat-tabname        = lc_tab_name.
  lst_fcat-seltext_m      = text-013. "Sales Document
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname      = lc_matrl_no.
  lst_fcat-tabname        = lc_tab_name.
  lst_fcat-seltext_m      = text-014. "Material No
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname      = lc_old_mat_no.
  lst_fcat-tabname        = lc_tab_name.
  lst_fcat-seltext_m      = text-033. "Material No
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname      = lc_qty.
  lst_fcat-tabname        = lc_tab_name.
  lst_fcat-seltext_m      = text-015. "Quantity
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname      = lc_status.
  lst_fcat-tabname        = lc_tab_name.
  lst_fcat-seltext_m      = text-016. "Status
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.
  ADD 1 TO lv_val.

  CLEAR: lv_val.
  lst_fcat-fieldname      = lc_remarks.
  lst_fcat-tabname        = lc_tab_name.
  lst_fcat-seltext_m      = text-017. "Remarks
  lst_fcat-col_pos        = lv_val.
  APPEND lst_fcat TO li_fcat.
  CLEAR  lst_fcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_grid_title       = text-019 "
      it_fieldcat        = li_fcat
      is_layout          = lst_layout
    TABLES
      t_outtab           = i_output
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    " Nothing to do here
    REFRESH : li_fcat,
              i_output.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_LOG_EMAIL
*&---------------------------------------------------------------------*
*       Send ALV as Log in Mail
*----------------------------------------------------------------------*
FORM f_send_log_email .

* Local Data Decl.,
  DATA:
    lst_imessage  TYPE solisti1
    .

  "Populate table with details to be entered into .xls file
  PERFORM f_build_batch_log_data.

* Populate Message Body Text
  CLEAR  : lst_imessage.
  REFRESH: i_message.

  lst_imessage  = text-020. "Dear Team,
  APPEND lst_imessage TO i_message.
  CLEAR lst_imessage.

  APPEND lst_imessage TO i_message.
  CLEAR lst_imessage.

* Please find the attached file with Processing Status of Continuous Orders created from the last run
  lst_imessage  = text-021.
  APPEND lst_imessage TO i_message.
  CLEAR lst_imessage.

  APPEND lst_imessage TO i_message.
  CLEAR lst_imessage.

  IF i_contract IS NOT INITIAL.
    lst_imessage  = text-022.
    APPEND lst_imessage TO i_message.
    CLEAR lst_imessage.

    APPEND lst_imessage TO i_message.
    CLEAR lst_imessage.
  ELSE.
    lst_imessage  = text-023.
    APPEND lst_imessage TO i_message.
    CLEAR lst_imessage.

    APPEND lst_imessage TO i_message.
    CLEAR lst_imessage.
  ENDIF.

  lst_imessage  = text-024.
  APPEND lst_imessage TO i_message.
  CLEAR lst_imessage.

  APPEND lst_imessage TO i_message.
  CLEAR lst_imessage.

* Send Mail with Table Data as .xls file as attachment
  PERFORM f_send_csv_xls_log.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_BATCH_LOG_DATA
*&---------------------------------------------------------------------*
*       Populate table with details to be entered into .xls file
*----------------------------------------------------------------------*
FORM f_build_batch_log_data .

* Local Data Decl.,
  DATA:
    lv_qty    TYPE  char17,
    lst_attch TYPE  solisti1.

  LOOP AT i_output INTO DATA(lst_output).
*- For Final Records
    IF i_attach_total[] IS INITIAL.
      CONCATENATE text-010 text-011 text-032 text-012 text-013 text-014
                  text-033 text-015 text-016 text-017
        INTO lst_attch SEPARATED BY c_tab.
      CONCATENATE c_clrf lst_attch INTO lst_attch.

      APPEND lst_attch TO i_attach_total.
      CLEAR: lst_attch.
    ENDIF.
** Moving quantities to local character varaibles for concatenation
    MOVE :
      lst_output-qty TO lv_qty.

    CONCATENATE
        lst_output-ser_code
        lst_output-contrct_no
        lst_output-item_no
        lst_output-customer
        lst_output-so_no
        lst_output-matrl_no
        lst_output-isbn_mat
        lv_qty
        lst_output-status
        lst_output-remarks
      INTO lst_attch SEPARATED BY c_tab.
    CONCATENATE c_clrf lst_attch INTO lst_attch.

    APPEND lst_attch TO i_attach_total.
    CLEAR: lv_qty, lst_attch.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SEND_CSV_XLS_LOG
*&---------------------------------------------------------------------*
*       Send Mail with attachment
*----------------------------------------------------------------------*
FORM f_send_csv_xls_log .

* Local DAta
  DATA:
    lst_xdocdata       TYPE sodocchgi1,
    lv_lines_total(15) TYPE n,
    lst_pack_list      TYPE sopcklsti1,
    lst_rcvrs          TYPE somlreci1,
    lv_lines_tmp(15)   TYPE c.

* Local Constants
  CONSTANTS:
    lc_u      TYPE char1   VALUE 'U',      " U of Type CHAR1
    lc_int    TYPE char3   VALUE 'INT',
    lc_raw    TYPE char3   VALUE 'RAW',
    lc_usc    TYPE char1   VALUE '_',
    lc_xls    TYPE so_obj_tp
                                     VALUE  'XLS',
    lc_saprpt TYPE char6   VALUE 'SAPRPT'.


  DESCRIBE TABLE i_attach_total LINES DATA(lv_total).

*- Fill the document data and get size of attachment
  CLEAR lst_xdocdata.
  READ TABLE i_attach_total INTO DATA(lst_attch) INDEX lv_total.
  lst_xdocdata-doc_size = ( lv_total - 1 ) * 255 + strlen( lst_attch ).

*- Populate the subject/generic message attributes
  lst_xdocdata-obj_langu  = sy-langu.
  lst_xdocdata-obj_name   = lc_saprpt.
  lst_xdocdata-obj_descr  = text-025. "Continuous Order Processing Status

  CLEAR i_attachment.
  REFRESH i_attachment.
  i_attachment[] = i_attach_total[].

*- Describe the body of the message
  REFRESH: i_packing_list.
  lst_pack_list-transf_bin = space.
  lst_pack_list-head_start = 1.
  lst_pack_list-head_num   = 0.
  lst_pack_list-body_start = 1.

  DESCRIBE TABLE i_message LINES lst_pack_list-body_num.
  lst_pack_list-doc_type = lc_raw. " RAW

  APPEND lst_pack_list TO i_packing_list.
  CLEAR: lst_pack_list.

  IF i_contract IS NOT INITIAL.
    CLEAR: lv_lines_total,lv_lines_tmp.

    DESCRIBE TABLE i_attach_total LINES lv_lines_total.
    lv_lines_tmp = lv_lines_total - 1.
    CONDENSE lv_lines_tmp.
* First Line is Header; If more than one record, some data exists for the attachment
    IF lv_lines_tmp GE 1.
*- Create attachment notification
      lst_pack_list-transf_bin = abap_on.
      lst_pack_list-head_start = 1.
      lst_pack_list-head_num   = 1.
      lst_pack_list-body_start = 1.

      CONCATENATE text-026 sy-datum sy-uzeit
        INTO lst_pack_list-obj_descr
        SEPARATED BY lc_usc. "

      lst_pack_list-doc_type   =  lc_xls.
      lst_pack_list-obj_name   =  text-027.
      lst_pack_list-body_num   =  lv_lines_total.
      lst_pack_list-doc_size   =  lv_lines_total * 255.
      APPEND lst_pack_list TO i_packing_list.
    ENDIF.
  ENDIF.

  IF v_email IS NOT INITIAL.
    lst_rcvrs-receiver   = v_email.
    lst_rcvrs-rec_type   = lc_u.
    lst_rcvrs-com_type   = lc_int. " INT
    lst_rcvrs-notif_del  = abap_on.
    lst_rcvrs-notif_ndel = abap_on.

    APPEND lst_rcvrs TO i_receivers.
    CLEAR lst_rcvrs.
  ENDIF.

  CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = lst_xdocdata
      put_in_outbox              = abap_on
      commit_work                = abap_on
    TABLES
      packing_list               = i_packing_list
      contents_bin               = i_attachment
      contents_txt               = i_message
      receivers                  = i_receivers
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7
      OTHERS                     = 8.
  IF sy-subrc NE 0.
    MESSAGE text-028 TYPE c_err.  "Error in sending Email
  ELSE.
    MESSAGE text-029 TYPE c_succ. "Email sent with Success log file
  ENDIF.

ENDFORM.
