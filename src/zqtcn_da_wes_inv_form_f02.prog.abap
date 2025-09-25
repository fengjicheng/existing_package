*&---------------------------------------------------------------------*
*&  Include           ZQTCN_DA_WES_INV_FORM_F02
*&---------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K920368
* REFERENCE NO: OTCM-32214 (F046)
* DEVELOPER:MIMMADISET
* DATE:  11/18/2020
* DESCRIPTION:DA Invoice form changes
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K920979
* REFERENCE NO    : OTCM 30816(F046.2)
* DEVELOPER       : mimmadiset
* DATE            : 12/23/2020
* DESCRIPTION     : Mthree Invoice,Debit and Credit form changes.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO :  OTCM-42109
* REFERENCE NO:  ED2K921982
* DEVELOPER   :  MIMMADISET
* DATE        : 02/17/2021
* DESCRIPTION : Read the sales org address based on zcaconstant enry
*              for 1030 entities forms.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO     : ED2K925315
* REFERENCE NO    : OTCM-55093
* DEVELOPER       : mimmadiset
* DATE            : 12/20/2021
* DESCRIPTION     : Multiple email-id s functioanlity for all sales org in F046
*&---------------------------------------------------------------------*
FORM f_set_total_due .
*  Total of “Sub-Total ”+”Tax ”- “Amount Paid”
  li_hdr_itm-hdr_gen-total_due = li_bil_invoice-hd_gen-bil_netwr + li_bil_invoice-hd_gen-bil_tax
                                 - li_hdr_itm-hdr_gen-amount_paid.
  CONDENSE:li_hdr_itm-hdr_gen-amount_paid.
ENDFORM.
FORM f_set_amount_paid.
  DATA:lv_year TYPE gjahr.
  CONSTANTS:lc_zpay TYPE kschl VALUE 'ZPAY'.
**Local constants
  CONSTANTS:lc_cust    TYPE koart      VALUE 'D'.
  li_hdr_itm-hdr_gen-amt_paid_txt = 'Amount Paid'(024).
  li_hdr_itm-hdr_gen-paid_col     = ':'.
  li_hdr_itm-hdr_gen-paid_curr    = li_bil_invoice-hd_gen-bil_waerk.
  IF li_vbrk IS NOT INITIAL.
    SELECT knumv,
           kposn,
           kschl,
           kwert
      FROM konv
      INTO TABLE @DATA(li_konv)
      FOR ALL ENTRIES IN @li_vbrk
      WHERE knumv = @li_vbrk-knumv
        AND kschl = @lc_zpay.
    LOOP AT li_konv INTO DATA(lst_konv).
      READ TABLE li_vbrk INTO DATA(lst_vbrk) WITH KEY vbeln = li_bil_invoice-hd_gen-bil_number
                                                     knumv = lst_konv-knumv.
      IF sy-subrc = 0.
        li_hdr_itm-hdr_gen-amount_paid = li_hdr_itm-hdr_gen-amount_paid +  lst_konv-kwert .
      ENDIF.
    ENDLOOP.
    IF li_hdr_itm-hdr_gen-amount_paid IS INITIAL.
      CLEAR:li_hdr_itm-hdr_gen-amount_paid.
      li_hdr_itm-hdr_gen-amount_paid = '0.00'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_read_email .
  CONSTANTS:lc_header TYPE posnr VALUE '000000'.

  DATA: lv_person_numb TYPE prelp-pernr,                " Person Number
        lv_text        TYPE char255.                    " For text message
**BOC:mimmadiset OTCM-55093 ED2K925315 12/20/2021
  SELECT SINGLE vbeln
                parvw
                kunnr
                pernr
                adrnr
         FROM vbpa
         INTO st_vbpa
         WHERE vbeln = li_bil_invoice-hd_ref-order_numb
           AND posnr = lc_header
           AND  parvw = c_er. "ER - Employee responsible
  IF sy-subrc EQ 0.
    lv_person_numb = st_vbpa-pernr.
    CALL FUNCTION 'HR_READ_INFOTYPE'
      EXPORTING
        pernr           = lv_person_numb
        infty           = c_105
        begda           = c_start
        endda           = c_end
      TABLES
        infty_tab       = li_person_mail_id
      EXCEPTIONS
        infty_not_found = 1
        OTHERS          = 2.
    IF sy-subrc EQ 0.
* Implement suitable error handling here
      LOOP AT  li_person_mail_id INTO DATA(lst_person_mail_id) WHERE pernr =  lv_person_numb
                                                                  AND usrty = c_0010
                                                                  AND usrid_long IS NOT INITIAL.
        APPEND INITIAL LINE TO i_emailid ASSIGNING FIELD-SYMBOL(<ls_email>).
        <ls_email>-smtp_addr = lst_person_mail_id-usrid_long.
      ENDLOOP.
      IF i_emailid[] IS INITIAL.
        syst-msgid = c_zqtc_r2.
        syst-msgno = c_msg_no.
        syst-msgty = c_e.
        syst-msgv1 = text-016.
        CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
        PERFORM f_protocol_update.
        v_ent_retco = 4.
      ENDIF.
    ELSE.
      syst-msgid = c_zqtc_r2.
      syst-msgno = c_msg_no.
      syst-msgty = c_e.
      syst-msgv1 = text-016.
      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
      PERFORM f_protocol_update.
      v_ent_retco = 4.
    ENDIF.
  ELSE.
    SELECT SINGLE vbeln parvw kunnr pernr adrnr
      FROM vbpa INTO st_vbpa
      WHERE vbeln = li_bil_invoice-hd_ref-order_numb
      AND posnr = lc_header
      AND  parvw = c_re.  "
    IF sy-subrc EQ 0.
*   Fetch email ID from ADR6.
      PERFORM read_addr_from_adr6 USING st_vbpa-adrnr
                                  CHANGING i_emailid.
      IF i_emailid IS INITIAL .
        SELECT SINGLE prsnr "E-Mail Address
          FROM knvk      "E-Mail Addresses (Business Address Services)
          INTO v_persn_adrnr
          WHERE kunnr EQ st_vbpa-kunnr "st_hd_adr-partn_numb "bil_number
          AND   pafkt = c_z1 ##WARN_OK.
        IF sy-subrc EQ 0.
          SELECT smtp_addr "E-Mail Address
            FROM adr6      "E-Mail Addresses (Business Address Services)
            INTO TABLE i_emailid
            WHERE persnumber EQ v_persn_adrnr ##ECCI_NOFIRST ##WARN_OK.
          IF i_emailid IS INITIAL.
            syst-msgid = c_zqtc_r2.
            syst-msgno = c_msg_no.
            syst-msgty = c_e.
            syst-msgv1 = text-018.
            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
            PERFORM f_protocol_update.
            v_ent_retco = 4.
          ENDIF.
        ELSE.
          syst-msgid = c_zqtc_r2.
          syst-msgno = c_msg_no.
          syst-msgty = c_e.
          syst-msgv1 = text-018.
          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
          PERFORM f_protocol_update.
          v_ent_retco = 4.
        ENDIF.
      ENDIF.
    ELSE.
      syst-msgid = c_zqtc_r2.
      syst-msgno = c_msg_no.
      syst-msgty = c_e.
      syst-msgv1 = text-017.
      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
      PERFORM f_protocol_update.
      v_ent_retco = 4.
    ENDIF.
  ENDIF.
*  SELECT SINGLE vbeln
*                parvw
*                kunnr
*                pernr
*                adrnr
*         FROM vbpa
*         INTO st_vbpa
*         WHERE vbeln = li_bil_invoice-hd_ref-order_numb
*           AND posnr = lc_header
*           AND  parvw = c_er. "ER - Employee responsible
*  IF sy-subrc EQ 0.
*    lv_person_numb = st_vbpa-pernr.
*    CALL FUNCTION 'HR_READ_INFOTYPE'
*      EXPORTING
*        pernr           = lv_person_numb
*        infty           = c_105
*        begda           = c_start
*        endda           = c_end
*      TABLES
*        infty_tab       = li_person_mail_id
*      EXCEPTIONS
*        infty_not_found = 1
*        OTHERS          = 2.
*    IF sy-subrc EQ 0.
** Implement suitable error handling here
*      READ TABLE li_person_mail_id INTO DATA(lst_person_mail_id) WITH KEY pernr =  lv_person_numb
*                                                                          usrty = c_0010.
*      IF sy-subrc EQ 0 AND lst_person_mail_id-usrid_long IS NOT INITIAL.
*        v_send_email = lst_person_mail_id-usrid_long.
*      ELSE.
*        syst-msgid = c_zqtc_r2.
*        syst-msgno = c_msg_no.
*        syst-msgty = c_e.
*        syst-msgv1 = text-016.
*        CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*        PERFORM f_protocol_update.
*        v_ent_retco = 4.
*      ENDIF.
*    ELSE.
*      syst-msgid = c_zqtc_r2.
*      syst-msgno = c_msg_no.
*      syst-msgty = c_e.
*      syst-msgv1 = text-016.
*      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*      PERFORM f_protocol_update.
*      v_ent_retco = 4.
*    ENDIF.
*  ELSE.
*    SELECT SINGLE vbeln parvw kunnr pernr adrnr
*      FROM vbpa INTO st_vbpa
*      WHERE vbeln = li_bil_invoice-hd_ref-order_numb
*      AND posnr = lc_header
*      AND  parvw = c_re.  "
*    IF sy-subrc EQ 0.
*      SELECT  smtp_addr UP TO 1 ROWS "E-Mail Address
*       FROM adr6      "E-Mail Addresses (Business Address Services)
*       INTO v_send_email
*       WHERE addrnumber EQ st_vbpa-adrnr."st_hd_adr-addr_no ##WARN_OK.
*      ENDSELECT.
*      IF sy-subrc NE 0 AND v_send_email IS INITIAL .
*        SELECT SINGLE prsnr "E-Mail Address
*          FROM knvk      "E-Mail Addresses (Business Address Services)
*          INTO v_persn_adrnr
*          WHERE kunnr EQ st_vbpa-kunnr "st_hd_adr-partn_numb "bil_number
*          AND   pafkt = c_z1 ##WARN_OK.
*        IF sy-subrc EQ 0.
*          SELECT SINGLE smtp_addr "E-Mail Address
*            FROM adr6      "E-Mail Addresses (Business Address Services)
*            INTO v_send_email
*            WHERE persnumber EQ v_persn_adrnr ##ECCI_NOFIRST ##WARN_OK.
*          IF v_send_email IS INITIAL.
*            syst-msgid = c_zqtc_r2.
*            syst-msgno = c_msg_no.
*            syst-msgty = c_e.
*            syst-msgv1 = text-018.
*            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*            PERFORM f_protocol_update.
*            v_ent_retco = 4.
*          ENDIF.
*        ELSE.
*          syst-msgid = c_zqtc_r2.
*          syst-msgno = c_msg_no.
*          syst-msgty = c_e.
*          syst-msgv1 = text-018.
*          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*          PERFORM f_protocol_update.
*          v_ent_retco = 4.
*        ENDIF.
*      ENDIF.
*    ELSE.
*      syst-msgid = c_zqtc_r2.
*      syst-msgno = c_msg_no.
*      syst-msgty = c_e.
*      syst-msgv1 = text-017.
*      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*      PERFORM f_protocol_update.
*      v_ent_retco = 4.
*    ENDIF.
*  ENDIF.
**EOC:mimmadiset OTCM-55093 ED2K925315 12/20/2021
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_EMAIL_ZM3C
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_read_email_zm3c .
  DATA: lv_person_numb TYPE prelp-pernr.                " Person Numbe
**BOC:mimmadiset OTCM-55093 ED2K925315 12/20/2021
  IF nast-parvw = c_re AND ( v_output_typ = c_zm3c
                         OR v_output_typ = c_zxyi )."mimmadiset:OTCM-55113:12/06/2021: ED2K925092
    SELECT SINGLE vbeln parvw kunnr pernr adrnr
      FROM vbpa INTO st_vbpa
      WHERE vbeln = li_bil_invoice-hd_ref-order_numb
      AND  parvw = c_re.  "
    IF sy-subrc EQ 0.
*   Fetch email ID from ADR6.
      PERFORM read_addr_from_adr6 USING st_vbpa-adrnr
                                  CHANGING i_emailid.
      IF i_emailid IS INITIAL .
        SELECT SINGLE prsnr "E-Mail Address
          FROM knvk      "E-Mail Addresses (Business Address Services)
          INTO v_persn_adrnr
          WHERE kunnr EQ st_vbpa-kunnr "st_hd_adr-partn_numb "bil_number
          AND   pafkt = c_z1 ##WARN_OK.
        IF sy-subrc EQ 0.
          SELECT smtp_addr "E-Mail Address
            FROM adr6      "E-Mail Addresses (Business Address Services)
            INTO TABLE i_emailid
            WHERE persnumber EQ v_persn_adrnr ##ECCI_NOFIRST ##WARN_OK.
          IF i_emailid IS INITIAL.
            syst-msgid = c_zqtc_r2.
            syst-msgno = c_msg_no.
            syst-msgty = c_e.
            syst-msgv1 = text-018.
            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
            PERFORM f_protocol_update.
            v_ent_retco = 4.
          ENDIF.
        ELSE.
          syst-msgid = c_zqtc_r2.
          syst-msgno = c_msg_no.
          syst-msgty = c_e.
          syst-msgv1 = text-018.
          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
          PERFORM f_protocol_update.
          v_ent_retco = 4.
        ENDIF.
      ENDIF.
    ELSE.
      syst-msgid = c_zqtc_r2.
      syst-msgno = c_msg_no.
      syst-msgty = c_e.
      syst-msgv1 = text-017.
      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
      PERFORM f_protocol_update.
      v_ent_retco = 4.
    ENDIF.
  ELSE. "check for ER
    SELECT SINGLE vbeln parvw kunnr pernr adrnr FROM vbpa INTO st_vbpa WHERE vbeln = li_bil_invoice-hd_ref-order_numb
                                                                        AND  parvw = c_er. "ER - Employee responsible

    IF sy-subrc EQ 0.
*   Fetch email ID from ADR6.
      PERFORM read_addr_from_adr6 USING st_vbpa-adrnr
                                  CHANGING i_emailid.
      IF i_emailid IS INITIAL.
        lv_person_numb = st_vbpa-pernr.
        CALL FUNCTION 'HR_READ_INFOTYPE'
          EXPORTING
*           TCLAS           = 'A'
            pernr           = lv_person_numb
            infty           = c_105
            begda           = c_start
            endda           = c_end
          TABLES
            infty_tab       = li_person_mail_id
          EXCEPTIONS
            infty_not_found = 1
            OTHERS          = 2.
        IF sy-subrc EQ 0.
* Implement suitable error handling here
          LOOP AT  li_person_mail_id INTO DATA(lst_person_mail_id) WHERE pernr =  lv_person_numb
                                                                  AND usrty = c_0010
                                                                  AND usrid_long IS NOT INITIAL.
            APPEND INITIAL LINE TO i_emailid ASSIGNING FIELD-SYMBOL(<ls_email>).
            <ls_email>-smtp_addr = lst_person_mail_id-usrid_long.
          ENDLOOP.
          IF i_emailid[] IS INITIAL.
            syst-msgid = c_zqtc_r2.
            syst-msgno = c_msg_no.
            syst-msgty = c_e.
            syst-msgv1 = text-016.
            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
            PERFORM f_protocol_update.
            v_ent_retco = 4.
          ENDIF.
        ELSE.
          syst-msgid = c_zqtc_r2.
          syst-msgno = c_msg_no.
          syst-msgty = c_e.
          syst-msgv1 = text-016.
          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
          PERFORM f_protocol_update.
          v_ent_retco = 4.
        ENDIF.
      ENDIF. " IF sy-subrc NE 0
    ELSE.
      syst-msgid = c_zqtc_r2.
      syst-msgno = c_msg_no.
      syst-msgty = c_e.
      syst-msgv1 = text-015.
      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
      PERFORM f_protocol_update.
      v_ent_retco = 4.
    ENDIF.
  ENDIF.
*  IF nast-parvw = c_re AND ( v_output_typ = c_zm3c
*                       OR v_output_typ = c_zxyi )."mimmadiset:OTCM-55113:12/06/2021: ED2K925092
*    SELECT SINGLE vbeln parvw kunnr pernr adrnr
*      FROM vbpa INTO st_vbpa
*      WHERE vbeln = li_bil_invoice-hd_ref-order_numb
*      AND  parvw = c_re.  "
*    IF sy-subrc EQ 0.
*      SELECT  smtp_addr UP TO 1 ROWS "E-Mail Address
*       FROM adr6      "E-Mail Addresses (Business Address Services)
*       INTO v_send_email
*       WHERE addrnumber EQ st_vbpa-adrnr."st_hd_adr-addr_no ##WARN_OK.
*      ENDSELECT.
*      IF sy-subrc NE 0 AND v_send_email IS INITIAL .
*        SELECT SINGLE prsnr "E-Mail Address
*          FROM knvk      "E-Mail Addresses (Business Address Services)
*          INTO v_persn_adrnr
*          WHERE kunnr EQ st_vbpa-kunnr "st_hd_adr-partn_numb "bil_number
*          AND   pafkt = c_z1 ##WARN_OK.
*        IF sy-subrc EQ 0.
*          SELECT SINGLE smtp_addr "E-Mail Address
*            FROM adr6      "E-Mail Addresses (Business Address Services)
*            INTO v_send_email
*            WHERE persnumber EQ v_persn_adrnr ##ECCI_NOFIRST ##WARN_OK.
*          IF v_send_email IS INITIAL.
*            syst-msgid = c_zqtc_r2.
*            syst-msgno = c_msg_no.
*            syst-msgty = c_e.
*            syst-msgv1 = text-018.
*            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*            PERFORM f_protocol_update.
*            v_ent_retco = 4.
*          ENDIF.
*        ELSE.
*          syst-msgid = c_zqtc_r2.
*          syst-msgno = c_msg_no.
*          syst-msgty = c_e.
*          syst-msgv1 = text-018.
*          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*          PERFORM f_protocol_update.
*          v_ent_retco = 4.
*        ENDIF.
*      ENDIF.
*    ELSE.
*      syst-msgid = c_zqtc_r2.
*      syst-msgno = c_msg_no.
*      syst-msgty = c_e.
*      syst-msgv1 = text-017.
*      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*      PERFORM f_protocol_update.
*      v_ent_retco = 4.
*    ENDIF.
*
*
*
*  ELSE. "check for ER
*    SELECT SINGLE vbeln parvw kunnr pernr adrnr FROM vbpa INTO st_vbpa WHERE vbeln = li_bil_invoice-hd_ref-order_numb
*                                                                        AND  parvw = c_er. "ER - Employee responsible
*
*    IF sy-subrc EQ 0.
*      SELECT smtp_addr UP TO 1 ROWS "E-Mail Address
*        FROM adr6      "E-Mail Addresses (Business Address Services)
*        INTO v_send_email
*        WHERE addrnumber EQ st_vbpa-adrnr. ##WARN_OK.
*      ENDSELECT.
*      IF sy-subrc NE 0 AND v_send_email IS INITIAL.
*        lv_person_numb = st_vbpa-pernr.
*        CALL FUNCTION 'HR_READ_INFOTYPE'
*          EXPORTING
**           TCLAS           = 'A'
*            pernr           = lv_person_numb
*            infty           = c_105
*            begda           = c_start
*            endda           = c_end
*          TABLES
*            infty_tab       = li_person_mail_id
*          EXCEPTIONS
*            infty_not_found = 1
*            OTHERS          = 2.
*        IF sy-subrc EQ 0.
** Implement suitable error handling here
*          READ TABLE li_person_mail_id INTO DATA(lst_person_mail_id) WITH KEY pernr =  lv_person_numb
*                                                                              usrty = c_0010.
*          IF sy-subrc EQ 0 AND lst_person_mail_id-usrid_long IS NOT INITIAL.
*            v_send_email = lst_person_mail_id-usrid_long.
*          ELSE.
*            syst-msgid = c_zqtc_r2.
*            syst-msgno = c_msg_no.
*            syst-msgty = c_e.
*            syst-msgv1 = text-016.
*            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*            PERFORM f_protocol_update.
*            v_ent_retco = 4.
*          ENDIF.
*        ELSE.
*          syst-msgid = c_zqtc_r2.
*          syst-msgno = c_msg_no.
*          syst-msgty = c_e.
*          syst-msgv1 = text-016.
*          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*          PERFORM f_protocol_update.
*          v_ent_retco = 4.
*        ENDIF.
*      ENDIF. " IF sy-subrc NE 0
*    ELSE.
*      syst-msgid = c_zqtc_r2.
*      syst-msgno = c_msg_no.
*      syst-msgty = c_e.
*      syst-msgv1 = text-015.
*      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
*      PERFORM f_protocol_update.
*      v_ent_retco = 4.
*    ENDIF.
*  ENDIF.
**EOC:mimmadiset OTCM-55093 ED2K925315 12/20/2021
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
  SELECT SINGLE vkorg, vtext
              FROM tvkot
              INTO @DATA(ls_tvkot)
              WHERE spras EQ @c_e
                AND vkorg EQ @li_bil_invoice-hd_org-salesorg.
  IF sy-subrc EQ 0.
    SELECT SINGLE vkorg, adrnr
         FROM tvko
         INTO @DATA(ls_tvko)
         WHERE vkorg EQ @li_bil_invoice-hd_org-salesorg.
    IF sy-subrc EQ 0.
      SELECT SINGLE addrnumber, city1, post_code1,
             street, house_num1, region, country
        FROM adrc
        INTO @DATA(lst_adrc)
        WHERE addrnumber = @ls_tvko-adrnr.
      IF sy-subrc EQ 0.
        li_hdr_itm-hdr_gen-sales_org_name   = ls_tvkot-vtext.
        li_hdr_itm-hdr_gen-sales_org_adrnr  = lst_adrc-addrnumber.
        li_hdr_itm-hdr_gen-sales_org_house1 = lst_adrc-house_num1.
        li_hdr_itm-hdr_gen-sales_org_street = lst_adrc-street.
        li_hdr_itm-hdr_gen-sales_org_city1  = lst_adrc-city1.
        li_hdr_itm-hdr_gen-sales_org_reg    = lst_adrc-region.
        li_hdr_itm-hdr_gen-sales_org_post1  = lst_adrc-post_code1.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_READ_EMAIL_10
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_read_email_10 .
  DATA:lv_person_numb   TYPE prelp-pernr.                " Person Number
  IF nast-parvw = c_re.
    SELECT SINGLE vbeln parvw kunnr pernr adrnr
      FROM vbpa INTO st_vbpa
      WHERE vbeln = li_bil_invoice-hd_ref-order_numb
      AND  parvw = c_re.  "
    IF sy-subrc EQ 0.
*     *   Fetch email ID from ADR6.
      PERFORM read_addr_from_adr6 USING st_vbpa-adrnr
                                  CHANGING i_emailid.
      IF i_emailid IS INITIAL .
        SELECT SINGLE prsnr "E-Mail Address
          FROM knvk      "E-Mail Addresses (Business Address Services)
          INTO v_persn_adrnr
          WHERE kunnr EQ st_vbpa-kunnr "st_hd_adr-partn_numb "bil_number
          AND   pafkt = c_z1 ##WARN_OK.
        IF sy-subrc EQ 0.
          SELECT smtp_addr "E-Mail Address
            FROM adr6      "E-Mail Addresses (Business Address Services)
            INTO TABLE i_emailid
            WHERE persnumber EQ v_persn_adrnr ##ECCI_NOFIRST ##WARN_OK.
          IF i_emailid IS INITIAL.
            syst-msgid = c_zqtc_r2.
            syst-msgno = c_msg_no.
            syst-msgty = c_e.
            syst-msgv1 = text-018.
            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
            PERFORM f_protocol_update.
            v_ent_retco = 4.
          ENDIF.
        ELSE.
          syst-msgid = c_zqtc_r2.
          syst-msgno = c_msg_no.
          syst-msgty = c_e.
          syst-msgv1 = text-018.
          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
          PERFORM f_protocol_update.
          v_ent_retco = 4.
        ENDIF.
      ENDIF.
    ELSE.
      syst-msgid = c_zqtc_r2.
      syst-msgno = c_msg_no.
      syst-msgty = c_e.
      syst-msgv1 = text-017.
      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
      PERFORM f_protocol_update.
      v_ent_retco = 4.
    ENDIF.
  ELSE. "check for ER
    SELECT SINGLE vbeln parvw kunnr pernr adrnr FROM vbpa INTO st_vbpa WHERE vbeln = li_bil_invoice-hd_ref-order_numb
                                                                        AND  parvw = c_er. "ER - Employee responsible

    IF sy-subrc EQ 0.
*     *   Fetch email ID from ADR6.
      PERFORM read_addr_from_adr6 USING st_vbpa-adrnr
                                  CHANGING i_emailid.
      IF i_emailid IS INITIAL.
        lv_person_numb = st_vbpa-pernr.
        CALL FUNCTION 'HR_READ_INFOTYPE'
          EXPORTING
*           TCLAS           = 'A'
            pernr           = lv_person_numb
            infty           = c_105
            begda           = c_start
            endda           = c_end
          TABLES
            infty_tab       = li_person_mail_id
          EXCEPTIONS
            infty_not_found = 1
            OTHERS          = 2.
        IF sy-subrc EQ 0.
* Implement suitable error handling here
          LOOP AT  li_person_mail_id INTO DATA(lst_person_mail_id) WHERE pernr =  lv_person_numb
                                                                   AND usrty = c_0010
                                                                   AND usrid_long IS NOT INITIAL.
            APPEND INITIAL LINE TO i_emailid ASSIGNING FIELD-SYMBOL(<ls_email>).
            <ls_email>-smtp_addr = lst_person_mail_id-usrid_long.
          ENDLOOP.
          IF i_emailid[] IS INITIAL.
            syst-msgid = c_zqtc_r2.
            syst-msgno = c_msg_no.
            syst-msgty = c_e.
            syst-msgv1 = text-016.
            CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
            PERFORM f_protocol_update.
            v_ent_retco = 4.
          ENDIF.
        ELSE.
          syst-msgid = c_zqtc_r2.
          syst-msgno = c_msg_no.
          syst-msgty = c_e.
          syst-msgv1 = text-016.
          CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
          PERFORM f_protocol_update.
          v_ent_retco = 4.
        ENDIF.
      ENDIF. " IF sy-subrc NE 0
    ELSE.
      syst-msgid = c_zqtc_r2.
      syst-msgno = c_msg_no.
      syst-msgty = c_e.
      syst-msgv1 = text-015.
      CLEAR :syst-msgv2,syst-msgv3,syst-msgv4.
      PERFORM f_protocol_update.
      v_ent_retco = 4.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  READ_ADDR_FROM_ADR6
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ST_VBPA_ADRNR  text
*      <--P_I_EMAILID  text
*----------------------------------------------------------------------*
FORM read_addr_from_adr6  USING    fp_adrnr TYPE ad_addrnum
                          CHANGING fp_i_emailid    TYPE tt_emailid.
* Data Declaration
  DATA : li_email        TYPE STANDARD TABLE OF ty_email INITIAL SIZE 0,
         lst_email       TYPE ty_email,
         lv_current_date TYPE ad_valfrom. " Communication Data: Valid From (YYYYMMDDHHMMSS)
  REFRESH:li_email.
  CLEAR:lv_current_date,lst_email.
** Fetch the email id
  SELECT addrnumber " Address number
              persnumber " Person number
              smtp_addr  " E-Mail Address
              valid_from " Communication Data: Valid From (YYYYMMDDHHMMSS)
              valid_to   " Communication Data: Valid To (YYYYMMDDHHMMSS)
         FROM adr6       " E-Mail Addresses (Business Address Services)
         INTO TABLE li_email
        WHERE addrnumber EQ fp_adrnr "st_hd_adr-addr_no ##WARN_OK.
            and persnumber eq space.  " Read the partner related email id's only
  IF sy-subrc EQ 0.
    SORT li_email  BY addrnumber.
    lst_email-valid_from = c_validfrm.
    MODIFY li_email  FROM lst_email TRANSPORTING valid_from
     WHERE valid_from IS INITIAL.

    lst_email-valid_to   = c_validto.
    MODIFY li_email  FROM lst_email TRANSPORTING valid_to
     WHERE valid_to IS INITIAL.

    CONCATENATE sy-datum
                c_timstmp
           INTO lv_current_date.
    DELETE li_email  WHERE valid_from GT lv_current_date
                       OR valid_to   LT lv_current_date.
* Get email address in table
    LOOP AT li_email INTO lst_email.
      ls_emailid-smtp_addr = lst_email-smtp_addr.
      APPEND ls_emailid TO fp_i_emailid.
      CLEAR ls_emailid.
    ENDLOOP. " LOOP AT li_email INTO lst_email
  ENDIF. " IF sy-subrc EQ 0
ENDFORM.
