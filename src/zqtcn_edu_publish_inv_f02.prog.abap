*&---------------------------------------------------------------------*
*&  Include           ZQTCN_EDU_PUBLISH_INV_F02
*&---------------------------------------------------------------------*
* PROGRAM NAME: ZQTCN_EDU_PUBLISH_INV_F049
* PROGRAM DESCRIPTION: This INCLUDE is implemented for WLS (Wiley
*                      Learning Solutions) Invoice form
* DEVELOPER: AMOHAMMED
* CREATION DATE: 06/09/2020
* OBJECT ID: F061
* TRANSPORT NUMBER(S): ED2K918223
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K919207
* REFERENCE NO: ERPM-25818
* DEVELOPER: mimmadiset
* DATE:  08/25/2020
* DESCRIPTION: Changes for displaying client number,ship to address details
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SET_CUSTOMER_SERVICE_USERID
*&---------------------------------------------------------------------*
FORM f_set_customer_service_userid .
**BOC MIMMADISET ERPM-25818
  CONSTANTS:lc_zwgpid       TYPE bu_id_type VALUE 'ZWGPID'.
* Customer Service Name is set in the hdr_gen internal table
  li_hdr_itm-hdr_gen-cust_srvc_usrid = st_ktext-ernam.
*****logic to read the client number
  SELECT SINGLE idnumber FROM but0id
    INTO @DATA(lv_idnumber)
    WHERE partner = @li_bil_invoice-hd_gen-sold_to_party AND
    type = @lc_zwgpid.
  IF sy-subrc = 0.
    li_hdr_itm-hdr_gen-client_numb = lv_idnumber.
  ENDIF.
**EOC MIMMADISET ERPM-25818
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_SHIPPING_METHOD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  fp_vsbed  text
*----------------------------------------------------------------------*
FORM f_set_shipping_method USING fp_vsbed TYPE vsbed.
* Store the shipping method text into hdr_gen internal table
  READ TABLE li_tvsbt INTO DATA(lst_tvsbt)
    WITH KEY vsbed = fp_vsbed BINARY SEARCH.
  IF sy-subrc EQ 0.
    li_hdr_itm-hdr_gen-ship_method = lst_tvsbt-vtext.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_SHIPPING_METHOD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_shipping_method .
*- Fetch the Shipping method text for English language
  SELECT vsbed vtext
    FROM tvsbt
    INTO TABLE li_tvsbt
    FOR ALL ENTRIES IN li_vbrk
    WHERE spras EQ c_e
      AND vsbed EQ li_vbrk-vsbed.
  IF sy-subrc EQ 0.
    SORT li_tvsbt BY vsbed.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_OLD_MATERIAL_NUM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_old_material_num .
*- Fetch the old material numbers
  SELECT matnr bismt meins
      FROM mara
      INTO TABLE li_mara
      FOR ALL ENTRIES IN li_bil_invoice-it_gen
      WHERE matnr EQ li_bil_invoice-it_gen-material.
  IF sy-subrc EQ 0.
    SORT li_mara BY matnr.
  ENDIF.
*--Fethc the Units of Measure for Material
**BOC MIMMADISET ERPM-25818
  SELECT matnr meinh umrez
    FROM marm
    INTO TABLE li_marm
     FOR ALL ENTRIES IN li_bil_invoice-it_gen
      WHERE matnr EQ li_bil_invoice-it_gen-material.
  IF sy-subrc EQ 0.
    SORT li_marm BY matnr.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_OLD_MATERIAL_NUM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_ITEM_GEN_MATERIAL  text
*----------------------------------------------------------------------*
FORM f_set_old_material_num USING p_lst_item_gen_material TYPE matnr.
  READ TABLE li_mara INTO DATA(lst_mara)
    WITH KEY matnr = p_lst_item_gen_material BINARY SEARCH.
  IF sy-subrc EQ 0.
    lst_count-bismt = lst_mara-bismt.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_FREIGHT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_set_freight .
  READ TABLE li_bil_invoice-it_gen INTO DATA(lst_it_gen)
    WITH KEY bil_number = li_bil_invoice-hd_gen-bil_number
             item_categ = c_pstyv.
  IF sy-subrc EQ 0.
    READ TABLE li_bil_invoice-it_price INTO DATA(lst_it_price)
      WITH KEY bil_number = lst_it_gen-bil_number
               itm_number = lst_it_gen-itm_number.
    IF sy-subrc EQ 0.
      li_hdr_itm-hdr_gen-freight = lst_it_price-netwr.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_SUB_TOTAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_set_sub_total .
* Sub total with Freight amount excluded
  li_hdr_itm-hdr_gen-sub_total = li_bil_invoice-hd_gen-bil_netwr - li_hdr_itm-hdr_gen-freight.
  IF v_flg_cr IS NOT INITIAL.
    li_hdr_itm-hdr_gen-sub_total = ( li_bil_invoice-hd_gen-bil_netwr - li_hdr_itm-hdr_gen-freight ) * ( -1 ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_AMOUNT_PAID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_amount_paid .
*- Get Current Fiscal Year
  CALL FUNCTION 'GET_CURRENT_YEAR'
    EXPORTING
      bukrs = li_bil_invoice-hd_org-comp_code
      date  = sy-datum
    IMPORTING
      curry = v_fiscal_yr.
*- Fetching Billing accounting document details
  SELECT bukrs belnr gjahr augbl koart                  "#EC CI_NOORDER
    FROM bseg
    INTO TABLE li_bseg
    FOR ALL ENTRIES IN li_vbrk
    WHERE bukrs EQ li_vbrk-bukrs
      AND belnr EQ li_vbrk-vbeln
      AND gjahr EQ v_fiscal_yr
      AND koart EQ c_d. " Account type : Customers
  IF sy-subrc EQ 0.
    SORT li_bseg BY bukrs belnr gjahr.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_AMOUNT_PAID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_set_amount_paid .
  SORT li_vbrk BY vbeln.
  READ TABLE li_vbrk ASSIGNING FIELD-SYMBOL(<lfs_vbrk>)
    WITH KEY vbeln = li_bil_invoice-hd_gen-bil_number
    BINARY SEARCH.
  IF sy-subrc EQ 0.
    READ TABLE li_bseg INTO DATA(lst_bseg)
      WITH KEY bukrs = <lfs_vbrk>-bukrs
               belnr = <lfs_vbrk>-vbeln
               gjahr = v_fiscal_yr BINARY SEARCH.
    IF sy-subrc EQ 0.
      IF lst_bseg-augbl NE space. " IF the document is cleared
        li_hdr_itm-hdr_gen-amount_paid = li_hdr_itm-hdr_gen-sub_total +
                                         li_hdr_itm-hdr_gen-freight +
                                         li_hdr_itm-hdr_gen-tax.
      ELSE. " IF the document is not cleared
        li_hdr_itm-hdr_gen-amount_paid = 0.
      ENDIF.
    ENDIF.
*If VBRK-FKART=ZWV THEN set the below logic.
**BOC MIMMADISET ERPM-25818
    IF <lfs_vbrk>-fkart = c_zwv.
      li_hdr_itm-hdr_gen-amount_paid = li_hdr_itm-hdr_gen-sub_total +
                                       li_hdr_itm-hdr_gen-freight +
                                       li_hdr_itm-hdr_gen-tax.
    ENDIF.
**EOC MIMMADISET ERPM-25818
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_TOTAL_DUE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_set_total_due .
*- Total due is set
  li_hdr_itm-hdr_gen-total_due = ( li_hdr_itm-hdr_gen-sub_total +
                                   li_hdr_itm-hdr_gen-freight +
                                   li_hdr_itm-hdr_gen-tax ) -
                                 ( li_hdr_itm-hdr_gen-amount_paid ).
*If VBrK-FKArT=ZWV then set total_due = 0
**BOC MIMMADISET ERPM-25818
  READ TABLE li_vbrk ASSIGNING FIELD-SYMBOL(<lfs_vbrk>)
     WITH KEY vbeln = li_bil_invoice-hd_gen-bil_number.
  IF sy-subrc = 0 AND <lfs_vbrk>-fkart = c_zwv.
    CLEAR:li_hdr_itm-hdr_gen-total_due.
  ENDIF.
**EOC MIMMADISET ERPM-25818
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SERIAL_NUMBERS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_VBFA_VBELV  text
*----------------------------------------------------------------------*
FORM f_serial_numbers USING p_lst_vbfa_vbelv TYPE vbeln_von.
  CONSTANTS : lc_object TYPE rstxt-tdobject VALUE 'MVKE', " Material texts, sales
              lc_id     TYPE rstxt-tdid     VALUE '0001'. " Material Sales Text
  DATA : lv_sal_mat_text    TYPE string,                  " Material Sales Text
         lv_name            TYPE thead-tdname,            " Name
         li_tline           TYPE TABLE OF tline,          " Material Sales Text
         lst_serial_numbers TYPE zstqtc_wls_srl_num_f061. " Work area
  " Fetch Delivery number of the order / contract
  SELECT SINGLE vbelv, vbeln, vbtyp_n, vbtyp_v
           FROM vbfa
           INTO @DATA(lst_delivery)
           WHERE vbelv = @p_lst_vbfa_vbelv
             AND vbtyp_n = @c_doc_type.
  IF sy-subrc EQ 0.
    " Fetch object list number based on delivery number
    SELECT obknr, lief_nr
      FROM ser01
      INTO TABLE @DATA(li_ser01)
      WHERE lief_nr EQ @lst_delivery-vbeln.
    IF sy-subrc EQ 0.
      SORT li_ser01 BY obknr.
      " Fetch serial number and material based on object lis number
      SELECT obknr, sernr, matnr
        FROM objk
        INTO TABLE @DATA(li_objk)
        FOR ALL ENTRIES IN @li_ser01
        WHERE obknr EQ @li_ser01-obknr.
      IF sy-subrc EQ 0.
        " material description
        SELECT matnr, maktx
          FROM makt
          INTO TABLE @DATA(li_makt_srl_no)
          FOR ALL ENTRIES IN @li_objk
          WHERE matnr = @li_objk-matnr.
        IF sy-subrc EQ 0.
          SORT li_makt_srl_no BY matnr.
        ENDIF.
        SORT li_objk BY obknr sernr matnr.
        LOOP AT li_objk INTO DATA(lst_objk).
          CLEAR lv_sal_mat_text.
*- Get Material master sales text
          CONCATENATE lst_objk-matnr
                      li_bil_invoice-hd_org-salesorg
                      li_bil_invoice-hd_org-distrb_channel
                 INTO lv_name.
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              id                      = lc_id
              language                = li_bil_invoice-hd_org-salesorg_spras
              name                    = lv_name
              object                  = lc_object
            TABLES
              lines                   = li_tline
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
          IF sy-subrc EQ 0 AND li_tline[] IS NOT INITIAL.
            CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
              EXPORTING
                it_tline       = li_tline
              IMPORTING
                ev_text_string = lv_sal_mat_text.
            IF lv_sal_mat_text IS NOT INITIAL.
              CONDENSE lv_sal_mat_text.
              lst_serial_numbers-sal_mat_text = lv_sal_mat_text.
              APPEND lst_serial_numbers TO li_hdr_itm-it_serial_numbers.
            ENDIF. " IF sy-subrc EQ 0
          ENDIF.
          " When no sales text is maintained display material description from makt
          IF lv_sal_mat_text IS INITIAL.
            READ TABLE li_makt_srl_no INTO DATA(lst_mat_srl_no)
              WITH KEY matnr = lst_objk-matnr BINARY SEARCH.
            IF sy-subrc EQ 0.
              lst_serial_numbers-sal_mat_text = lst_mat_srl_no-maktx.
              APPEND lst_serial_numbers TO li_hdr_itm-it_serial_numbers.
            ENDIF.
          ENDIF.
          lst_serial_numbers-sal_mat_text = lst_objk-sernr.
          APPEND lst_serial_numbers TO li_hdr_itm-it_serial_numbers.
          CLEAR lst_serial_numbers.
          " Maintain the gap between two serial numbers in the output
          APPEND lst_serial_numbers TO li_hdr_itm-it_serial_numbers.
        ENDLOOP. " LOOP AT li_objk INTO DATA(lst_objk).
      ENDIF. " IF sy-subrc EQ 0.
    ENDIF. " IF sy-subrc EQ 0.
  ENDIF. " IF sy-subrc EQ 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EMAIL_IDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LI_SEND_EMAIL  text
*----------------------------------------------------------------------*
FORM f_get_email_ids  CHANGING p_li_send_email TYPE tt_send_email.
*- Fetch the Number of contact person for the Business Partner
  SELECT SINGLE kunnr, vkorg, vtweg, spart, parvw, parza , parnr
    FROM knvp
    INTO @DATA(lst_knvp)
    WHERE kunnr EQ @li_bil_invoice-hd_gen-sold_to_party
      AND vkorg EQ @li_bil_invoice-hd_org-salesorg
      AND vtweg EQ @li_bil_invoice-hd_org-distrb_channel
      AND spart EQ @li_bil_invoice-hd_org-division
      AND parvw EQ @c_cp.
  IF sy-subrc EQ 0.
*- Fetch the Person number for the contact person number
    SELECT SINGLE parnr, prsnr
      FROM knvk
      INTO @DATA(lst_knvk)
      WHERE parnr EQ @lst_knvp-parnr.
    IF sy-subrc EQ 0.
*- Fetch the E-mail address for the person number
      SELECT smtp_addr                     " E-Mail Address
        FROM adr6                          " E-Mail Addresses (Business Address Services)
        INTO TABLE p_li_send_email
        WHERE persnumber EQ lst_knvk-prsnr.
      IF sy-subrc NE 0.
        syst-msgid = c_zqtc_r2.
        syst-msgno = c_msg_no.
        syst-msgty = c_e.
        syst-msgv1 = text-026.             " Email ID is not maintained for contact person
        CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
        PERFORM f_protocol_update.
        v_ent_retco = 4.
      ENDIF.
    ELSE.
      syst-msgid = c_zqtc_r2.
      syst-msgno = c_msg_no.
      syst-msgty = c_e.
      syst-msgv1 = text-027.               " Person number is not maintained
      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
      PERFORM f_protocol_update.
      v_ent_retco = 4.
    ENDIF.
  ELSE.
    syst-msgid = c_zqtc_r2.
    syst-msgno = c_msg_no.
    syst-msgty = c_e.
    syst-msgv1 = text-028.                 " CP partner function is not maintained
    CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
    PERFORM f_protocol_update.
    v_ent_retco = 4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_SALES_ORG_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_sales_org_details .
**BOC MIMMADISET ERPM-25818
  SELECT SINGLE vkorg, vtext
              FROM tvkot
              INTO @DATA(ls_tvkot)
              WHERE spras EQ @c_e
                AND vkorg EQ @li_bil_invoice-hd_org-salesorg.
  IF sy-subrc EQ 0.
    li_hdr_itm-hdr_gen-sales_org_name   = ls_tvkot-vtext.
    SELECT SINGLE vkorg, adrnr
         FROM tvko
         INTO @DATA(ls_tvko)
         WHERE vkorg EQ @li_bil_invoice-hd_org-salesorg.
    IF sy-subrc EQ 0.
      SELECT SINGLE addrnumber, city1, post_code1,
             street, house_num1, region, country
        FROM adrc
        INTO @DATA(ls_adrc)
        WHERE addrnumber = @ls_tvko-adrnr.
      IF sy-subrc EQ 0.
        li_hdr_itm-hdr_gen-sales_org_adrnr  = ls_adrc-addrnumber.
        li_hdr_itm-hdr_gen-sales_org_house1 = ls_adrc-house_num1.
        li_hdr_itm-hdr_gen-sales_org_street = ls_adrc-street.
        li_hdr_itm-hdr_gen-sales_org_city1  = ls_adrc-city1.
        li_hdr_itm-hdr_gen-sales_org_reg    = ls_adrc-region.
        li_hdr_itm-hdr_gen-sales_org_post1  = ls_adrc-post_code1.
        li_hdr_itm-hdr_gen-sales_org_ctry   = ls_adrc-country.
      ENDIF.
    ENDIF.
  ENDIF.
**EOC MIMMADISET ERPM-25818
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_SHIP_TO_ADDRESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_ship_to_address .
**BOC MIMMADISET ERPM-25818
  DATA: lv_name           TYPE thead-tdname,            " Name
        li_ship_to_addr   TYPE TABLE OF szadr_printform_table_line,
        lst_ship_to_addr  TYPE szadr_printform_table_line,
        lv_address_number TYPE adrc-addrnumber,
        lv_lines          TYPE tdline.
*- Ship-to Details
  REFRESH:li_hdr_itm-it_ship_to_addr,li_ship_to_addr.
  CLEAR: lv_address_number, lv_lines,li_hdr_itm-hdr_gen-ship_to_name.
  READ TABLE li_bil_invoice-hd_part_add INTO DATA(lst_part)
    WITH KEY bil_number = li_bil_invoice-hd_gen-bil_number
             partn_role = c_we.
  IF sy-subrc EQ 0.
    SELECT SINGLE adrnr FROM vbpa INTO @DATA(lv_ship_adrnr)
      WHERE vbeln = @li_bil_invoice-hd_gen-bil_number
      AND parvw = @c_we
      AND kunnr = @lst_part-partn_numb.
    IF sy-subrc = 0.
      SELECT SINGLE name1 FROM adrc INTO @DATA(lv_ship_name)
        WHERE addrnumber = @lv_ship_adrnr.
      IF sy-subrc EQ 0.
        li_hdr_itm-hdr_gen-ship_to_name = lv_ship_name.
        FREE:lv_address_number.
        lv_address_number = lv_ship_adrnr.
        IF  lv_address_number IS NOT INITIAL.
          CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
            EXPORTING
              address_type                   = '1'
              address_number                 = lv_address_number
              sender_country                 = 'US'
              number_of_lines                = '5'
            IMPORTING
              address_printform_table        = li_ship_to_addr
            EXCEPTIONS
              address_blocked                = 1
              person_blocked                 = 2
              contact_person_blocked         = 3
              addr_to_be_formated_is_blocked = 4
              OTHERS                         = 5.
          IF sy-subrc EQ 0.
            READ TABLE li_ship_to_addr ASSIGNING FIELD-SYMBOL(<lst_ship_to>)
              WITH KEY line_type = '5'. "C/o Namessss
            IF sy-subrc EQ 0.
              CONCATENATE text-006 <lst_ship_to>-address_line
                     INTO <lst_ship_to>-address_line SEPARATED BY space.
            ENDIF.
          ENDIF.

          IF li_ship_to_addr IS NOT INITIAL.
            LOOP AT li_ship_to_addr INTO lst_ship_to_addr.
              lv_lines = lst_ship_to_addr-address_line.
              APPEND lv_lines TO li_hdr_itm-it_ship_to_addr.
              CLEAR lv_lines.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
**EOC MIMMADISET ERPM-25818
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_SET_UOM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ENDIF  text
*----------------------------------------------------------------------*
FORM f_set_uom  USING   fp_lst_item_gen_material TYPE matnr
                        fp_vrkme TYPE vrkme.
**BOC MIMMADISET ERPM-25818
  DATA:lv_umrez TYPE char10.
  READ TABLE li_mara INTO DATA(lst_mara)
    WITH KEY matnr = fp_lst_item_gen_material BINARY SEARCH.
  IF sy-subrc EQ 0 AND fp_vrkme NE lst_mara-meins.
    READ TABLE li_marm INTO DATA(lst_marm)
    WITH KEY matnr = fp_lst_item_gen_material
             meinh = fp_vrkme.
    IF sy-subrc = 0.
      lv_umrez = lst_marm-umrez.
      CONDENSE lv_umrez NO-GAPS.
      CONCATENATE lst_marm-meinh lv_umrez INTO lst_count-vrkme.
      CONDENSE lst_count-vrkme NO-GAPS.
    ELSE.
      lst_count-vrkme = fp_vrkme.
    ENDIF.
  ELSE.
    lst_count-vrkme = fp_vrkme.
  ENDIF.
**EOC MIMMADISET ERPM-25818
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_read_form .
  DATA:lc_kschl TYPE rvari_vnam VALUE 'KSCHL'.
  SELECT  SINGLE devid,     " Development ID
           param1,    " ABAP: Name of Variant Variable
           param2,    " ABAP: Name of Variant Variable
           srno,      " ABAP: Current selection number
           sign,      " ABAP: ID: I/E (include/exclude values)
           opti,      " ABAP: Selection option (EQ/BT/CP/..)
           low,       " Lower Value of Selection Condition
           high,      " Upper Value of Selection Condition
           activate   " Activation indicator for constant
     INTO @DATA(ls_const)
     FROM zcaconstant " Wiley Application Constant Table
     WHERE devid EQ @c_devid_f061
       AND param1 EQ @lc_kschl
       AND param2 EQ @nast-kschl
       AND activate EQ @abap_true.
  IF sy-subrc = 0.
    v_formname = ls_const-low.
  ENDIF.
ENDFORM.
