*----------------------------------------------------------------------*
* PROGRAM NAME: LZQTC_RENEWF01 (Subscription Inbound Order)
* PROGRAM DESCRIPTION: Include for Subscription Inbound Order
* DEVELOPER: Manami Chaudhuri
* CREATION DATE:   30/01/2017
* OBJECT ID: I0338
* TRANSPORT NUMBER(S):  ED2K904103
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K907618
* REFERENCE NO: I0338 (ERP-3599)
* DEVELOPER: Writtick Roy
* DATE:  2017-07-29
* DESCRIPTION: Add logic for Customer Purchase Order Type
* Begin of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
* End   of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
* Begin of DEL:ERP-3599:WROY:29-JUL-2017:ED2K907618
* End   of DEL:ERP-3599:WROY:29-JUL-2017:ED2K907618
*----------------------------------------------------------------------*
* REVISION NO: ED2K906697
* REFERENCE NO: I0338 (ERP-3881)
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 10-Aug-2017
* DESCRIPTION: Corrected for an issue of Payer street and house number
*              address details.
*----------------------------------------------------------------------*
* REVISION NO: ED2K909052
* REFERENCE NO: I0338 (CR#696 / ERP-4665)
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 19-OCT-2017
* DESCRIPTION: Code has been enhanced to include the change of email address
*               for bill to and ship to Parters. In Idoc email address will
*               be in E1EDKA3 for Qualf 005.
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:  ED2K913381
* REFERENCE NO: I0338 (ERP-6326)
* DEVELOPER: WROY (Writtick Roy)
* DATE:  2018-09-18
* DESCRIPTION: Add logic for Postal Code and IDOC Status population
* Begin of ADD:ERP-6326:WROY:18-SEP-2018:ED2K913381
* End   of ADD:ERP-6326:WROY:18-SEP-2018:ED2K913381
* Begin of DEL:ERP-6326:WROY:18-SEP-2018:ED2K913381
* End   of DEL:ERP-6326:WROY:18-SEP-2018:ED2K913381
*----------------------------------------------------------------------*
*------------------------------------------------------------------- *
*&---------------------------------------------------------------------*
*&      Form  F_FILL_BAPI
*&---------------------------------------------------------------------*
*  Call BAPI to create Contract and update Card details
*----------------------------------------------------------------------*
*      -->FP_LV_BELNR      Document number
*      -->FP_LV_RENEW      Renew Order type
*      -->FP_LST_DOCNUM    Document number for IDOC
*----------------------------------------------------------------------*
FORM f_fill_bapi  USING  fp_lv_belnr TYPE vbeln_nach " Subsequent sales and distribution document
                         fp_lv_renew TYPE auart      " Sales Document Type
*                        Begin of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
                         fp_lv_cust_po_type TYPE bsark " Customer purchase order type
*                        End   of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
                         fp_lst_docnum  TYPE edi_docnum " IDoc number
  fp_lst_e1edk36 TYPE e1edk36.                          " IDOC: Doc.header payment cards

  DATA :
    lst_idoc_status TYPE bdidocstat. " Status record


  DATA :
    lv_salesdocument TYPE vbeln_va,                                  " Sales document number
    li_return_f      TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0. " Return table

* Create Contract with reference to QUOTATION .It copy price ,
* determine contract date & other details
  CALL FUNCTION 'BAPI_SALESDOCUMENT_COPY'
    EXPORTING
      salesdocument    = fp_lv_belnr " Reference document number
      documenttype     = fp_lv_renew " Document type 'ZREW'.
    IMPORTING
      salesdocument_ex = lv_salesdocument
    TABLES
      return           = li_return_f.

* If document number is generated then go further , Otherwise
* populate ERROR from BAPI return table
*
  IF lv_salesdocument IS NOT INITIAL.
    READ TABLE li_return_f INTO DATA(lst_return) WITH KEY type = c_error. " Return_f into da of type
    IF sy-subrc NE 0. " When No error available

* UPDATE database with new order
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

*    populate success message
      lst_idoc_status-docnum = fp_lst_docnum.
      lst_idoc_status-status = c_succ. "'53'.
      lst_idoc_status-msgty = c_type. " 'lst_return-type.
      lst_idoc_status-msgid = c_id. " lst_return-id.
      lst_idoc_status-msgno = c_msg_no . " lst_return-number.
      lst_idoc_status-msgv1 = text-001. "'Subscription Order'
      lst_idoc_status-msgv2 = lv_salesdocument . " lst_return-message_v2.
      lst_idoc_status-msgv3 = lst_return-message_v3.
      lst_idoc_status-msgv4 = lst_return-message_v4.
      APPEND lst_idoc_status TO  idoc_status.

* Update payment tab, Bill to and Ship to Email and payer address
      PERFORM f_payment_update USING fp_lst_e1edk36
                                     lv_salesdocument
*                                    Begin of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
                                     fp_lv_cust_po_type
*                                    End   of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
                                     fp_lst_docnum.

    ELSE. " ELSE -> IF sy-subrc NE 0
*    Populate Error message
      PERFORM f_fill_status USING fp_lst_docnum
                                  c_status " 51
                                  lst_return-type
                                  lst_return-id
                                  lst_return-number
                                  lst_return-message_v1
                                  lst_return-message_v2
                                  lst_return-message_v3
                                  lst_return-message_v4.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ENDIF. " IF sy-subrc NE 0
  ELSE. " ELSE -> IF lv_salesdocument IS NOT INITIAL

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

*    Populate Error message from BAPI return table
    CLEAR : lst_return.
    LOOP AT li_return_f INTO lst_return WHERE type = c_error OR " Return_f into lst_r of type
                                              type = c_error_a. "  of type

      PERFORM f_fill_status USING fp_lst_docnum
                            c_status " 51
                            lst_return-type
                            lst_return-id
                            lst_return-number
                            lst_return-message_v1
                            lst_return-message_v2
                            lst_return-message_v3
                            lst_return-message_v4.
      CLEAR : lst_return.

    ENDLOOP. " LOOP AT li_return_f INTO lst_return WHERE type = c_error OR

  ENDIF. " IF lv_salesdocument IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FILL_STATUS
*&---------------------------------------------------------------------*
* Populate message for IDOC status
*----------------------------------------------------------------------*
*      -->FP_LST_DOCNUM             idoc number
*      -->FP_LC_STATUS              status
*      -->FP_LST_RETURN_TYPE        type
*      -->FP_LST_RETURN_ID          id
*      -->FP_LST_RETURN_NUMBER      number
*      -->FP_LST_RETURN_MESSAGE_V1  message v1
*      -->FP_LST_RETURN_MESSAGE_V2  message v2
*      -->FP_LST_RETURN_MESSAGE_V3  message v3
*      -->FP_LST_RETURN_MESSAGE_V4  message v4
*      <--FP_IDOC_STATUS            idoc status
*----------------------------------------------------------------------*
FORM f_fill_status  USING    fp_lst_docnum TYPE edi_docnum         " IDoc number
                             fp_lc_status TYPE edi_status          " Status of IDoc
                             fp_lst_return_type TYPE sychar01
                             fp_lst_return_id TYPE symsgid         " Message Class
                             fp_lst_return_number TYPE symsgno     " Message Number
                             fp_lst_return_message_v1 TYPE symsgv  " Message Variable
                             fp_lst_return_message_v2 TYPE symsgv  " Message Variable
                             fp_lst_return_message_v3 TYPE symsgv  " Message Variable
                             fp_lst_return_message_v4 TYPE symsgv. " Message Variable

  DATA lst_idoc_status TYPE bdidocstat. " ALE IDoc status (subset of all IDoc status fields)

*    Populate Error message
  lst_idoc_status-docnum = fp_lst_docnum.
  lst_idoc_status-status = fp_lc_status . " '51'.
  lst_idoc_status-msgty = fp_lst_return_type.
  lst_idoc_status-msgid = fp_lst_return_id.
  lst_idoc_status-msgno = fp_lst_return_number.
  lst_idoc_status-msgv1 = fp_lst_return_message_v1.
  lst_idoc_status-msgv2 = fp_lst_return_message_v2.
  lst_idoc_status-msgv3 = fp_lst_return_message_v3.
  lst_idoc_status-msgv4 = fp_lst_return_message_v4.
  APPEND lst_idoc_status TO  idoc_status.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PAYMENT_UPDATE
*&---------------------------------------------------------------------*
*       Update payements and payer address
*----------------------------------------------------------------------*
*      -->P_LST_E1EDK36       E1EDK36
*      -->P_LV_SALESDOCUMENT  Sales document
*      -->P_LST_DOCNUM        IDOC number
*----------------------------------------------------------------------*
FORM f_payment_update  USING    fp_lst_e1edk36 TYPE e1edk36       " IDOC: Doc.header payment cards
                                fp_lv_salesdocument TYPE vbeln_va " Sales Document
*                               Begin of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
                                fp_lv_cust_po_type  TYPE bsark " Customer purchase order type
*                               End   of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
                                fp_lst_docnum  TYPE edi_docnum. " IDoc number

  DATA :
    lv_count      TYPE i,        " Count Defect 1632
    lv_date       TYPE string,   " Date length Defect 1632
    lv_today      TYPE sy-datum, " Current date Defect 1632
    lv_cal_date   TYPE sy-datum, " Calculated date Defect 1632
    lv_kunnr      TYPE kunnr,    " Customer Defect 1632
* Begin of Insert by PBANDLAPAL on 19-OCT-2017 for CR#696: ED2K909052
    li_adrc       TYPE TABLE OF szadr_addr1_complete,
    li_vbpa       TYPE TABLE OF ty_vbpa,
    lst_adrc      TYPE szadr_addr1_complete,
    lst_vbpa      TYPE ty_vbpa,                                    " VBPA line item
    li_vbpa_adr   TYPE TABLE OF ty_vbpa,
    lst_adr_comp  TYPE szadr_addr1_complete,
    li_bapi_addr  TYPE STANDARD TABLE OF bapiaddr1 INITIAL SIZE 0, " BAPI Address Details
    lst_bapi_addr TYPE bapiaddr1,                                  " BAPI Reference Structure for Addresses (Org./Company)
* End of Insert by PBANDLAPAL on 19-OCT-2017 for CR#696: ED2K909052
    lst_e1edka1   TYPE e1edka1, " E1EDKA1   " Defect 1632
*   Begin of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
    lst_sd_hdr    TYPE bapisdhd1, " Header
*   End   of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
    lst_hex       TYPE bapisdhd1x,                                  " Headerx
    lst_partner   TYPE bapiparnrc,                                  " Partner: WWW  Defect 1632
    lst_card      TYPE bapiccard,                                   " Card work area
    lst_sal_hed   TYPE bapisdhd,                                    " Hed ##NEEDED.
    lst_return    TYPE bapiret2,                                    " Return Parameter
    lst_parvw     TYPE efg_ranges,                                  " Line type of Range
    lir_parvw     TYPE efg_tab_ranges,                              " Range for Partners
    lst_partner_a TYPE bapiaddr1,                                   " BAPI address Defect 1632
    li_partner_c  TYPE STANDARD TABLE OF bapiparnrc INITIAL SIZE 0, " Partner: WWW  Defect 1632
    li_partner_a  TYPE STANDARD TABLE OF bapiaddr1 INITIAL SIZE 0,  " Partner WWW Defect 1632
    li_card       TYPE STANDARD TABLE OF bapiccard INITIAL SIZE 0,  " Card
    li_return_f   TYPE STANDARD TABLE OF bapiret2 INITIAL SIZE 0.   " Return table
* Constant declaration
  CONSTANTS :
    lc_update       TYPE updkz_d VALUE 'U',         " Update
    lc_e1edka1      TYPE char7 VALUE 'E1EDKA1',     " E1EDKA1   " Defect 1632
    lc_payer        TYPE char2 VALUE 'RG',          " Payer
    lc_new_adrnr    TYPE char10 VALUE 'RG  $00000', " New value
    lc_new_adrnr_bp TYPE char10 VALUE 'RE  $00000', " New address number for BP
    lc_new_adrnr_sh TYPE char10 VALUE 'WE  $00000'. " New address number for SH

* Begin of change for defect 1632
* OLR may send 3/4/6 digit date format in SAP system .
* So based on input ,last day of the month is calculated and
* send BAPI for further processing
  lv_date = fp_lst_e1edk36-exdatbi. " Date coming from IDOC
  lv_count = strlen( lv_date ). " Length of date
  lv_today = sy-datum. " Todays date to calculate year
  IF lv_count = 3.

    CONCATENATE lv_today+0(2)
                lv_date+1(2)
                '0'  " Zero added befor month
                lv_date+0(1)
                '01' " 1st day of month
                INTO lv_cal_date.

  ELSEIF lv_count = 4.

    CONCATENATE lv_today+0(2)
                lv_date+2(2)
                lv_date+0(2)
                '01' " 1st day of month
                INTO lv_cal_date.
  ELSEIF lv_count = 6.
    CONCATENATE lv_date+2(4)
                lv_date+0(2)
                '01' " 1st day of month
                INTO lv_cal_date.

  ENDIF. " IF lv_count = 3

  CLEAR lv_today.
  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = lv_cal_date
    IMPORTING
      last_day_of_month = lv_today
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
    CLEAR lv_cal_date.
  ELSE. " ELSE -> IF sy-subrc <> 0
    lst_card-cc_valid_t = lv_today. " Last day of the month and year
  ENDIF. " IF sy-subrc <> 0

* End of change for defect 1632

* Populate Card details
  lst_card-cc_type = fp_lst_e1edk36-ccins.
  lst_card-cc_number = fp_lst_e1edk36-ccnum.
*     lst_card-cc_valid_t = lst_e1edk36-exdatbi.   " Defect 1632
  lst_card-cc_name = fp_lst_e1edk36-ccname.
  APPEND lst_card TO li_card.

* Begin of Change by PBANDLAPAL on 19-OCT-2017 for CR#696: ED2K909052
** Begin of change for defect 1632
** Get Payer number
*  SELECT SINGLE vbeln,kunnr
*    FROM vbpa " Sales Document: Partner
*    INTO @DATA(lst_vbpa)
*    WHERE vbeln = @fp_lv_salesdocument
*    AND posnr = ''
*    AND parvw = @lc_payer.
** Read segment for E1EDKA1
*  READ TABLE idoc_data INTO DATA(lst_edidd_1) WITH KEY segnam = lc_e1edka1. " 'E1EDKA1'.
*  IF sy-subrc = 0.
*    lst_e1edka1 = lst_edidd_1-sdata.
*    lst_partner-partn_role = lst_e1edka1-parvw. " Partner type
*    lst_partner-document = lst_vbpa-vbeln.
*    lst_partner-itm_number = '000000'.
*    lst_partner-updateflag = lc_update. " 'U'.
*    lst_partner-p_numb_old = lst_vbpa-kunnr.
*    lv_kunnr = lst_vbpa-kunnr. " Partner number
*    lst_partner-address = lc_new_adrnr. " 'RG  $00000'.
*    lst_partner-addr_link = lc_new_adrnr. " 'RG  $00000'.
*
*    lst_partner-p_numb_new = lv_kunnr.
*
*    APPEND lst_partner TO li_partner_c.
*
*    lst_partner_a-addr_no = lc_new_adrnr. "'RG  $00000'.
*    lst_partner_a-name = lst_e1edka1-name1.
*    lst_partner_a-name_2 = lst_e1edka1-name2.
*    lst_partner_a-city = lst_e1edka1-ort01.
*    lst_partner_a-postl_cod1 = lst_e1edka1-pstlz.
*    lst_partner_a-street = lst_e1edka1-stras. " Street
*
** BOI: 10-Aug-2017 : PBANDLAPAL : ERP-3881: ED2K907886
**  lst_partner_a-street = lst_e1edka1-strs2. " Street
*    lst_partner_a-house_no = lst_e1edka1-strs2. " House Number1
** EOI: 10-Aug-2017 : PBANDLAPAL : ERP-3881: ED2K907886
*
*    lst_partner_a-country = lst_e1edka1-land1.
*    APPEND lst_partner_a TO li_partner_a.
*
*  ENDIF. " IF sy-subrc = 0
** End of change for defect 1632
  IF st_e1edka1_re IS NOT INITIAL.
    lst_parvw-sign   = c_sign_i.
    lst_parvw-option = c_opt_eq.
    lst_parvw-low    = st_e1edka1_re-parvw.
    APPEND lst_parvw TO lir_parvw.
  ENDIF. " IF st_e1edka1_re IS NOT INITIAL
  IF st_e1edka1_rg IS NOT INITIAL.
    lst_parvw-sign   = c_sign_i.
    lst_parvw-option = c_opt_eq.
    lst_parvw-low    = st_e1edka1_rg-parvw.
    APPEND lst_parvw TO lir_parvw.
  ENDIF. " IF st_e1edka1_rg IS NOT INITIAL
  IF st_e1edka1_we IS NOT INITIAL.
    lst_parvw-sign   = c_sign_i.
    lst_parvw-option = c_opt_eq.
    lst_parvw-low    = st_e1edka1_we-parvw.
    APPEND lst_parvw TO lir_parvw.
  ENDIF. " IF st_e1edka1_we IS NOT INITIAL

** Get partner and address number
  SELECT vbeln " Sales and Distribution Document Number
         parvw " Partner Function
         kunnr " Customer Number
         adrnr " Address
    FROM vbpa  " Sales Document: Partner
    INTO TABLE li_vbpa
    WHERE vbeln = fp_lv_salesdocument
    AND posnr = space
    AND parvw IN lir_parvw.
  IF sy-subrc EQ 0.
    li_vbpa_adr[] = li_vbpa[].
    SORT li_vbpa_adr BY adrnr.
    DELETE ADJACENT DUPLICATES FROM li_vbpa_adr COMPARING adrnr.

    LOOP AT li_vbpa_adr INTO lst_vbpa.
      CALL FUNCTION 'ADDR_GET_COMPLETE'
        EXPORTING
          addrnumber              = lst_vbpa-adrnr
*         ADDRHANDLE              =
*         ARCHIVE_HANDLE          =
          iv_current_comm_data    = abap_true
*         BLK_EXCPT               =
        IMPORTING
          addr1_complete          = lst_adr_comp
        EXCEPTIONS
          parameter_error         = 1
          address_not_exist       = 2
          internal_error          = 3
          wrong_access_to_archive = 4
          address_blocked         = 5
          OTHERS                  = 6.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'ADDR_CONVERT_TO_BAPIADDR1'
          EXPORTING
            addr1_complete      = lst_adr_comp
          IMPORTING
            addr1_complete_bapi = lst_bapi_addr.
        APPEND lst_bapi_addr TO li_bapi_addr.
        CLEAR: lst_vbpa,
               lst_bapi_addr,
               lst_adr_comp.
      ENDIF. " IF sy-subrc EQ 0
    ENDLOOP. " LOOP AT li_vbpa_adr INTO lst_vbpa

  ENDIF. " IF sy-subrc EQ 0
  IF st_e1edka1_rg IS NOT INITIAL.
    lst_partner-partn_role = st_e1edka1_rg-parvw. " Partner type
    READ TABLE li_vbpa INTO lst_vbpa WITH KEY parvw = c_parvw_rg.
    lst_partner-document = lst_vbpa-vbeln.
    lst_partner-itm_number = c_itmno_hdr.
    lst_partner-updateflag = lc_update. " 'U'.
    lst_partner-p_numb_old = lst_vbpa-kunnr.
    lv_kunnr = lst_vbpa-kunnr. " Partner number
    lst_partner-address = lc_new_adrnr. " 'RG  $00000'.
    lst_partner-addr_link = lc_new_adrnr. " 'RG  $00000'.
    lst_partner-p_numb_new = lv_kunnr.
    APPEND lst_partner TO li_partner_c.

    lst_partner_a-addr_no = lc_new_adrnr. "'RG  $00000'.
    lst_partner_a-name = st_e1edka1_rg-name1.
    lst_partner_a-name_2 = st_e1edka1_rg-name2.
    lst_partner_a-city = st_e1edka1_rg-ort01.
*   Begin of DEL:ERP-6326:WROY:18-SEP-2018:ED2K913381
*   lst_partner_a-postl_cod1 = st_e1edka1_rg-pstlz.
*   End   of DEL:ERP-6326:WROY:18-SEP-2018:ED2K913381
*   Begin of ADD:ERP-6326:WROY:18-SEP-2018:ED2K913381
*   Convert Postal Code
    DATA(lv_pstlz_flag) = abap_false.
    PERFORM idoc_move_pstlz IN PROGRAM saplveda IF FOUND
      USING st_e1edka1_rg-pstlz
            lst_partner_a-postl_cod1
            lv_pstlz_flag.
*   End   of ADD:ERP-6326:WROY:18-SEP-2018:ED2K913381
    lst_partner_a-street = st_e1edka1_rg-stras. " Street
    lst_partner_a-house_no = st_e1edka1_rg-strs2. " House Number1
    lst_partner_a-country = st_e1edka1_rg-land1.
    APPEND lst_partner_a TO li_partner_a.
  ENDIF. " IF st_e1edka1_rg IS NOT INITIAL

  IF st_e1edka1_re IS NOT INITIAL AND v_email_bp IS NOT INITIAL.
    CLEAR: lst_adrc,
           lst_vbpa,
           lst_partner,
           lst_bapi_addr,
           lst_partner_a.
    lst_partner-partn_role = st_e1edka1_re-parvw. " Partner type
    READ TABLE li_vbpa INTO lst_vbpa WITH KEY parvw = c_parvw_re.
    IF sy-subrc EQ 0.
      READ TABLE li_bapi_addr INTO lst_bapi_addr WITH KEY addr_no = lst_vbpa-adrnr.
      IF sy-subrc EQ 0.
        lst_partner-document = lst_vbpa-vbeln.
        lst_partner-itm_number = c_itmno_hdr.
        lst_partner-updateflag = lc_update. " 'U'.
        lst_partner-p_numb_old = lst_vbpa-kunnr.
        lst_partner-address = lc_new_adrnr_bp.
        lst_partner-addr_link = lc_new_adrnr_bp.
        lst_partner-p_numb_new = lst_vbpa-kunnr.
        APPEND lst_partner TO li_partner_c.

        lst_partner_a   = lst_bapi_addr.
        lst_partner_a-addr_no = lc_new_adrnr_bp.
        lst_partner_a-e_mail  = v_email_bp.
        APPEND lst_partner_a TO li_partner_a.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF st_e1edka1_re IS NOT INITIAL AND v_email_bp IS NOT INITIAL

  IF st_e1edka1_we IS NOT INITIAL AND v_email_sh IS NOT INITIAL.
    CLEAR: lst_vbpa,
           lst_partner,
           lst_partner_a,
           lst_bapi_addr.

    lst_partner-partn_role = st_e1edka1_we-parvw. " Partner type
    READ TABLE li_vbpa INTO lst_vbpa WITH KEY parvw = c_parvw_we.
    IF sy-subrc EQ 0.
      READ TABLE li_bapi_addr INTO lst_bapi_addr WITH KEY addr_no = lst_vbpa-adrnr.
      IF sy-subrc EQ 0.
        lst_partner-document = lst_vbpa-vbeln.
        lst_partner-itm_number = c_itmno_hdr.
        lst_partner-updateflag = lc_update. " 'U'.
        lst_partner-p_numb_old = lst_vbpa-kunnr.
        lst_partner-address = lc_new_adrnr_sh.
        lst_partner-addr_link = lc_new_adrnr_sh.
        lst_partner-p_numb_new = lst_vbpa-kunnr.
        APPEND lst_partner TO li_partner_c.

        lst_partner_a   = lst_bapi_addr.
        lst_partner_a-addr_no = lc_new_adrnr_sh.
        lst_partner_a-e_mail  = v_email_sh.
        APPEND lst_partner_a TO li_partner_a.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF st_e1edka1_we IS NOT INITIAL AND v_email_sh IS NOT INITIAL
* End of Change by PBANDLAPAL on 19-OCT-2017 for CR#696: ED2K909052

  lst_hex-updateflag = lc_update.
  lst_hex-payment_methods = abap_true.
* Begin of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
  IF fp_lv_cust_po_type IS NOT INITIAL. " Customer purchase order type
    lst_sd_hdr-po_method  = fp_lv_cust_po_type.
    lst_hex-po_method     = abap_true.
  ENDIF. " IF fp_lv_cust_po_type IS NOT INITIAL
* End   of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618

  CLEAR lst_sal_hed.
* Call BAPI to update Payment card details
  CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
    EXPORTING
      salesdocument     = fp_lv_salesdocument
*     Begin of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
      order_header_in   = lst_sd_hdr
*     End   of ADD:ERP-3599:WROY:29-JUL-2017:ED2K907618
      order_header_inx  = lst_hex
    IMPORTING
      sales_header_out  = lst_sal_hed
    TABLES
      return            = li_return_f
      partnerchanges    = li_partner_c " Defect 1632
      partneraddresses  = li_partner_a " Defect 1632
      sales_ccard       = li_card
    EXCEPTIONS
      incov_not_in_item = 1
      OTHERS            = 2.

  IF sy-subrc = 0.
* populate success message
    READ TABLE li_return_f INTO DATA(lst_part) WITH KEY type = c_error. " Return_f into da of type
    IF sy-subrc NE 0.
      CLEAR : lst_return.
      lst_return-message_v1 = text-002. "'Renewal Sub Order'(002).
      lst_return-message_v2 = fp_lv_salesdocument.
      lst_return-message_v3 = text-004.
      PERFORM f_fill_status USING fp_lst_docnum
                  c_succ " 53
                  c_type
                  c_id
                  c_msg_no
                  lst_return-message_v1
                  lst_return-message_v2
                  lst_return-message_v3
                  lst_return-message_v4.
    ELSE. " ELSE -> IF sy-subrc NE 0

*     Begin of DEL:ERP-6326:WROY:18-SEP-2018:ED2K913381
*     lst_part-message_v1 = lst_part-message.
*     End   of DEL:ERP-6326:WROY:18-SEP-2018:ED2K913381
*     Begin of ADD:ERP-6326:WROY:18-SEP-2018:ED2K913381
      READ TABLE idoc_status TRANSPORTING NO FIELDS
           WITH KEY docnum = fp_lst_docnum
                    status = c_succ.
      IF sy-subrc NE 0.
*     End   of ADD:ERP-6326:WROY:18-SEP-2018:ED2K913381
        PERFORM f_fill_status USING fp_lst_docnum
                c_status " 51
                lst_part-type
                lst_part-id
                lst_part-number
                lst_part-message_v1
                lst_part-message_v2
                lst_part-message_v3
                lst_part-message_v4.
*     Begin of ADD:ERP-6326:WROY:18-SEP-2018:ED2K913381
      ELSE. " ELSE -> IF sy-subrc NE 0
*       If the IDOC is in 53(Success) Status already, it can not be moved back to 51(Error) Status
        PERFORM f_fill_status USING fp_lst_docnum
                c_succ " 53
                c_type
                lst_part-id
                lst_part-number
                lst_part-message_v1
                lst_part-message_v2
                lst_part-message_v3
                lst_part-message_v4.
      ENDIF. " IF sy-subrc NE 0
*     End   of ADD:ERP-6326:WROY:18-SEP-2018:ED2K913381
    ENDIF. " IF sy-subrc NE 0
  ELSE. " ELSE -> IF sy-subrc = 0
*   Begin of ADD:ERP-6326:WROY:18-SEP-2018:ED2K913381
    READ TABLE idoc_status TRANSPORTING NO FIELDS
         WITH KEY docnum = fp_lst_docnum
                  status = c_succ.
    IF sy-subrc NE 0.
*   End   of ADD:ERP-6326:WROY:18-SEP-2018:ED2K913381
      PERFORM f_fill_status USING fp_lst_docnum
              c_status " 51
              sy-msgty
              sy-msgid
              sy-msgno
              sy-msgv1
              sy-msgv2
              sy-msgv3
              sy-msgv4.
*   Begin of ADD:ERP-6326:WROY:18-SEP-2018:ED2K913381
    ELSE. " ELSE -> IF sy-subrc NE 0
*     If the IDOC is in 53(Success) Status already, it can not be moved back to 51(Error) Status
      PERFORM f_fill_status USING fp_lst_docnum
              c_succ " 53
              c_type
              sy-msgid
              sy-msgno
              sy-msgv1
              sy-msgv2
              sy-msgv3
              sy-msgv4.
    ENDIF. " IF sy-subrc NE 0
*   End   of ADD:ERP-6326:WROY:18-SEP-2018:ED2K913381
  ENDIF. " IF sy-subrc = 0


ENDFORM.
