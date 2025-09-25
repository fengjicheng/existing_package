class ZCL_QTC_SET_ADDRESS_FF definition
  public
  final
  create public .

public section.

  interfaces /IDT/IF_BUILD_ADDRESS .
protected section.
private section.
ENDCLASS.



CLASS ZCL_QTC_SET_ADDRESS_FF IMPLEMENTATION.


  METHOD /IDT/IF_BUILD_ADDRESS~SET_ADDRESS_HDR_BILLING.
*   Copyright 2015 Thomson Reuters/ONESOURCE. All Rights Reserved.
*
*    DATA: ms_kna1        TYPE kna1,
*          ms_sap_address TYPE /idt/journey_addresses=>ty_sap_address.
*
*    DATA: m_ref_source_data TYPE REF TO data.
*
*    ms_kna1 = /idt/information_desk=>singleton->get_customer_data( cs_hdr_addr-komk-kunnr ).
*
*    IF ms_kna1-adrnr IS NOT INITIAL.
*
*      cs_hdr_addr-adrc = /idt/factory=>get_information_desk( )->get_address_for_key( ms_kna1-adrnr ).
*
*      GET REFERENCE OF cs_hdr_addr INTO m_ref_source_data.
*
*      ms_sap_address = /idt/factory=>get_information_desk( )->perform_dynamic_addr_mapping( iv_address_source = 'CUSTOMER'
*                                                                                            i_ref_source_data = m_ref_source_data
*                                                                                            iv_source_type = '/IDT/HDR_ADDR'
*                                                                                            i_ref_shuttle = i_ref_shuttle
*                                                                                            iv_source_structure = 'SET_ADDRESS_HDR_BILLING'
*                                                                                            iv_komk = cs_hdr_addr-komk ).
*      ms_sap_address-source_key-address_source = 'CUSTOMER'.
*      ms_sap_address-initial_data-identifier   = ms_kna1-kunnr.
*      es_sap_address = ms_sap_address.

*    ENDIF.

  ENDMETHOD.


  method /IDT/IF_BUILD_ADDRESS~SET_ADDRESS_HDR_DELIVERY.
*   Copyright 2015 Thomson Reuters/ONESOURCE. All Rights Reserved.
  endmethod.


  METHOD /IDT/IF_BUILD_ADDRESS~SET_ADDRESS_HDR_FI.
*   Copyright 2018 Thomson Reuters/ONESOURCE. All Rights Reserved.
*
*    DATA: ms_kna1        TYPE kna1,
*          ms_sap_address TYPE /idt/journey_addresses=>ty_sap_address,
*          mv_kunnr       TYPE kunnr.
*
*    DATA: m_ref_source_data TYPE REF TO data.
*
*    IF cs_hdr_addr-komk-kunnr IS NOT INITIAL.
*      mv_kunnr = cs_hdr_addr-komk-kunnr.
*    ELSE.
*      mv_kunnr = cs_hdr_addr-primary_partner_data-kunnr.
*    ENDIF.
*
*    ms_kna1 = /idt/information_desk=>singleton->get_customer_data( mv_kunnr ).
*
*    IF ms_kna1-adrnr IS NOT INITIAL.
*
*      cs_hdr_addr-adrc = /idt/factory=>get_information_desk( )->get_address_for_key( ms_kna1-adrnr ).
*
*      GET REFERENCE OF cs_hdr_addr INTO m_ref_source_data.
*
*      ms_sap_address = /idt/factory=>get_information_desk( )->perform_dynamic_addr_mapping( iv_address_source = 'CUSTOMER'
*                                                                                            i_ref_source_data = m_ref_source_data
*                                                                                            iv_source_type = '/IDT/HDR_ADDR'
*                                                                                            i_ref_shuttle = i_ref_shuttle
*                                                                                            iv_source_structure = 'SET_ADDRESS_HDR_FI'
*                                                                                            iv_komk = cs_hdr_addr-komk ).
*      ms_sap_address-source_key-address_source = 'CUSTOMER'.
*      ms_sap_address-initial_data-identifier   = ms_kna1-kunnr.
*      es_sap_address = ms_sap_address.
*
*    ENDIF.

  ENDMETHOD.


  METHOD /IDT/IF_BUILD_ADDRESS~SET_ADDRESS_HDR_LIV.
*   Copyright 2015 Thomson Reuters/ONESOURCE. All Rights Reserved.
  ENDMETHOD.


  method /IDT/IF_BUILD_ADDRESS~SET_ADDRESS_HDR_PURCHASING.
*   Copyright 2015 Thomson Reuters/ONESOURCE. All Rights Reserved.
  endmethod.


  METHOD /IDT/IF_BUILD_ADDRESS~SET_ADDRESS_HDR_SALES.
*   Copyright 2018 Thomson Reuters/ONESOURCE. All Rights Reserved.

*    DATA: ms_kna1        TYPE kna1,
*          ms_sap_address TYPE /idt/journey_addresses=>ty_sap_address.
*
*    DATA: m_ref_source_data TYPE REF TO data.
*
*    ms_kna1 = /idt/information_desk=>singleton->get_customer_data( cs_hdr_addr-vbak-kunnr ).
*
*    IF ms_kna1-adrnr IS NOT INITIAL.
*
*      cs_hdr_addr-adrc = /idt/factory=>get_information_desk( )->get_address_for_key( ms_kna1-adrnr ).
*
*      GET REFERENCE OF cs_hdr_addr INTO m_ref_source_data.
*
*      ms_sap_address = /idt/factory=>get_information_desk( )->perform_dynamic_addr_mapping( iv_address_source = 'CUSTOMER'
*                                                                                            i_ref_source_data = m_ref_source_data
*                                                                                            iv_source_type = '/IDT/HDR_ADDR'
*                                                                                            i_ref_shuttle = i_ref_shuttle
*                                                                                            iv_source_structure = 'SET_ADDRESS_HDR_SALES'
*                                                                                            iv_komk = cs_hdr_addr-komk ).
*      ms_sap_address-source_key-address_source = 'CUSTOMER'.
*      ms_sap_address-initial_data-identifier   = ms_kna1-kunnr.
*      es_sap_address = ms_sap_address.
*
*    ENDIF.

  ENDMETHOD.


  method /IDT/IF_BUILD_ADDRESS~SET_ADDRESS_HDR_SES.
*   Copyright 2015 Thomson Reuters/ONESOURCE. All Rights Reserved.
  endmethod.


  METHOD /idt/if_build_address~set_address_itm_billing.
*   Copyright 2015 Thomson Reuters/ONESOURCE. All Rights Reserved.
*----------------------------------------------------------------------*
* CLASS NAME: ZCL_QTC_SET_ADDRESS
* DESCRIPTION: Send the freight forward address number to one source for
*              tax caluculation when there is freight forward on line item
* DEVELOPER: Nagireddy Modugu
* CREATION DATE: 06/24/2020
* OBJECT ID: E246  & ERPM-7147
* TRANSPORT NUMBER(S): ED2K918605,ED2K919084
*----------------------------------------------------------------------*
CONSTANTS: lc_wricef_id_e246 TYPE zdevid VALUE 'E246', "Development
           lc_ser_num_001    TYPE zsno   VALUE '001',  "Serial Number
           lc_sp             TYPE vbpa-parvw   VALUE 'SP'.

    DATA:li_xvbpa TYPE TABLE OF vbpavb.

    DATA:ms_sap_address TYPE /idt/journey_addresses=>ty_sap_address.
    DATA:lv_actv_flag TYPE zactive_flag. "Active / Inactive Flag


** To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e246
        im_ser_num     = lc_ser_num_001
      IMPORTING
        ex_active_flag = lv_actv_flag.

    IF lv_actv_flag = abap_true.

* Validate and fetch freight forward data
        CALL FUNCTION 'ZQTC_FF_DETERMINE'
          EXPORTING
            im_vbak = is_vbak
            im_vbap = is_vbap
            im_flag = abap_true
          CHANGING
            ch_vbpa = li_xvbpa.
* Validate freight forward on line item level
        READ TABLE li_xvbpa INTO data(lst_vbpa) INDEX 1.
        IF sy-subrc = 0.
          DATA(lv_adrnr) = lst_vbpa-adrnr.
        ENDIF.

      IF lv_adrnr IS NOT INITIAL.
* Send freight forward address to one source for tax calcualtion
        ms_sap_address-address = /idt/address=>build_address_from_key( lv_adrnr ).
        ms_sap_address-initial_data-address_key = lst_vbpa-adrnr.
        ms_sap_address-initial_data-identifier = lst_vbpa-kunnr.
        ms_sap_address-source_key-address_source  = 'ZQTC_FF_ADDRESS'.
        es_sap_address = ms_sap_address.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  method /IDT/IF_BUILD_ADDRESS~SET_ADDRESS_ITM_DELIVERY.
*   Copyright 2015 Thomson Reuters/ONESOURCE. All Rights Reserved.
  endmethod.


  METHOD /IDT/IF_BUILD_ADDRESS~SET_ADDRESS_ITM_FI.
*   Copyright 2018 Thomson Reuters/ONESOURCE. All Rights Reserved.

* item level identifier required to populate registration number going fwd
*    DATA: ms_kna1        TYPE kna1,
*          ms_sap_address TYPE /idt/journey_addresses=>ty_sap_address,
*          mv_kunnr       TYPE kunnr.
*
*    DATA: m_ref_source_data TYPE REF TO data.
*
*    IF cs_item_addr-komk-kunnr IS NOT INITIAL.
*      mv_kunnr = cs_item_addr-komk-kunnr.
*    ELSE.
*      mv_kunnr = cs_item_addr-primary_partner_data-kunnr.
*    ENDIF.
*
*    ms_kna1 = /idt/information_desk=>singleton->get_customer_data( mv_kunnr ).
*
*    cs_item_addr-adrc = /idt/factory=>get_information_desk( )->get_address_for_key( ms_kna1-adrnr ).
*
*    GET REFERENCE OF cs_item_addr INTO m_ref_source_data.
*
*    ms_sap_address = /idt/factory=>get_information_desk( )->perform_dynamic_addr_mapping( iv_address_source = 'CUSTOMER'
*                                                                                          i_ref_source_data = m_ref_source_data
*                                                                                          iv_source_type = '/IDT/ITEM_ADDR'
*                                                                                          i_ref_shuttle = i_ref_shuttle
*                                                                                          iv_source_structure = 'SET_ADDRESS_ITM_FI'
*                                                                                          iv_komk = cs_item_addr-komk ).
*    ms_sap_address-source_key-address_source = 'CUSTOMER'.
*    ms_sap_address-initial_data-identifier   = ms_kna1-kunnr.
*    es_sap_address = ms_sap_address.

  ENDMETHOD.


  method /IDT/IF_BUILD_ADDRESS~SET_ADDRESS_ITM_LIV.
*   Copyright 2015 Thomson Reuters/ONESOURCE. All Rights Reserved.

  endmethod.


  method /IDT/IF_BUILD_ADDRESS~SET_ADDRESS_ITM_PURCHASING.
*   Copyright 2015 Thomson Reuters/ONESOURCE. All Rights Reserved.
  endmethod.


  METHOD /idt/if_build_address~set_address_itm_sales.
*   Copyright 2015 Thomson Reuters/ONESOURCE. All Rights Reserved.
*----------------------------------------------------------------------*
* Class NAME: ZCL_QTC_SET_ADDRESS
* PROGRAM DESCRIPTION: Send the freight forward address number to one source for
*                      tax caluculation when there is freight forward on line item
* DEVELOPER: Nagireddy Modugu
* CREATION DATE: 06/24/2020
* OBJECT ID: E246  & ERPM-7147
* TRANSPORT NUMBER(S): ED2K918605,ED2K919084
*                      ED2K919360  - Addition of SLG Log by Prabhu
*----------------------------------------------------------------------*
*
    CONSTANTS: lc_xvbpa          TYPE char40 VALUE '(SAPMV45A)XVBPA[]',
               lc_wricef_id_e246 TYPE zdevid VALUE 'E246', "Development ID
               lc_ser_num_001    TYPE zsno   VALUE '001',  "Serial Number
               lc_ser_num_002    TYPE zsno   VALUE '002',  "Serial Number
               lc_sp             TYPE vbpa-parvw   VALUE 'SP',
               lc_i              TYPE tvarv_sign VALUE 'I',
               lc_devid          TYPE zdevid VALUE 'E246',
               lc_param1         TYPE rvari_vnam VALUE 'USER_ID'.

    FIELD-SYMBOLS:<li_xvbpa> TYPE any.
    DATA:li_xvbpa TYPE TABLE OF vbpavb.
    DATA:lv_actv_flag  TYPE zactive_flag, "Active / Inactive Flagw
         lv_actv_flag2 TYPE zactive_flag. "Active / Inactive Flagw
    DATA:ms_sap_address TYPE /idt/journey_addresses=>ty_sap_address.

    DATA : st_log        TYPE bal_s_log,
           st_log_handle TYPE balloghndl,
           st_loghandle  TYPE bal_t_logh,
           st_msg        TYPE bal_s_msg,
           i_lognum      TYPE bal_t_lgnm,
           st_lognum     TYPE bal_s_lgnm,
           lst_xvbpa     TYPE vbpavb,
           lv_posnr      TYPE posnr,
           li_constants  TYPE zcat_constants,
           lir_user      TYPE RANGE OF salv_de_selopt_low.

* To check enhancement is active or not
    CALL FUNCTION 'ZCA_ENH_CONTROL'
      EXPORTING
        im_wricef_id   = lc_wricef_id_e246
        im_ser_num     = lc_ser_num_001
      IMPORTING
        ex_active_flag = lv_actv_flag.

    IF  lv_actv_flag = abap_true.

      ASSIGN (lc_xvbpa) TO <li_xvbpa>.
      IF <li_xvbpa> IS ASSIGNED.
        li_xvbpa = <li_xvbpa>.
      ENDIF.
*----------------------------------------------------------------------*
* SLG Log Create
*----------------------------------------------------------------------*
* To check enhancement is active or not
      CALL FUNCTION 'ZCA_ENH_CONTROL'
        EXPORTING
          im_wricef_id   = lc_wricef_id_e246
          im_ser_num     = lc_ser_num_002
        IMPORTING
          ex_active_flag = lv_actv_flag2.

      IF  lv_actv_flag2 = abap_true.
        CALL FUNCTION 'ZQTC_MANAGE_DISC_CONSTANTS'
          EXPORTING
            im_devid     = lc_devid
          IMPORTING
            ex_constants = li_constants.

        IF li_constants IS NOT INITIAL AND st_log IS INITIAL.
          LOOP AT li_constants INTO DATA(lst_constant)
                             WHERE param1 = lc_param1.
*        CASE lst_constant-param1.
*          WHEN lc_param1.
            APPEND INITIAL LINE TO lir_user
            ASSIGNING FIELD-SYMBOL(<lst_user>).
            <lst_user>-sign   = lst_constant-sign.
            <lst_user>-option = lst_constant-opti.
            <lst_user>-low    = lst_constant-low.
            <lst_user>-high   = lst_constant-high.
*        ENDCASE.
          ENDLOOP.
          IF sy-uname IN lir_user.
            st_log-object     = 'ZQTC'.
            st_log-subobject  = 'ZIDT_LOG'.
            CONCATENATE is_vbap-vbeln is_vbap-posnr INTO st_log-extnumber SEPARATED BY space.
            st_log-aldate     = sy-datum.
            st_log-altime     = sy-uzeit.
            st_log-aluser     = sy-uname.
            st_log-alprog     = sy-repid.
            CALL FUNCTION 'BAL_LOG_CREATE'
              EXPORTING
                i_s_log                 = st_log
              IMPORTING
                e_log_handle            = st_log_handle
              EXCEPTIONS
                log_header_inconsistent = 1
                OTHERS                  = 2.

            IF st_log_handle IS NOT INITIAL.

              READ TABLE li_xvbpa INTO lst_xvbpa WITH KEY posnr = is_vbap-posnr.
              IF sy-subrc NE 0.
                lv_posnr = '000000'.
              ELSE.
                lv_posnr = is_vbap-posnr.
              ENDIF.
              LOOP AT li_xvbpa INTO lst_xvbpa WHERE posnr = lv_posnr.
                CASE sy-tabix.
                  WHEN 1.
                    CONCATENATE lst_xvbpa-vbeln lst_xvbpa-posnr lst_xvbpa-parvw lst_xvbpa-kunnr lst_xvbpa-lifnr lst_xvbpa-adrnr
                                                    INTO st_msg-msgv1 SEPARATED BY space.
                  WHEN 2.
                    CONCATENATE ',' lst_xvbpa-parvw lst_xvbpa-kunnr lst_xvbpa-lifnr lst_xvbpa-adrnr INTO st_msg-msgv2 SEPARATED BY space.
                  WHEN 3.
                    CONCATENATE ',' lst_xvbpa-parvw lst_xvbpa-kunnr lst_xvbpa-lifnr lst_xvbpa-adrnr INTO st_msg-msgv3 SEPARATED BY space.
                  WHEN 4.
                    CONCATENATE ',' lst_xvbpa-parvw lst_xvbpa-kunnr lst_xvbpa-lifnr lst_xvbpa-adrnr INTO st_msg-msgv4 SEPARATED BY space.
                  WHEN OTHERS.
                ENDCASE.
              ENDLOOP.
              IF st_msg IS NOT INITIAL.
                st_msg-msgid = 'ZQTC_R2'.
                st_msg-msgno = '000'.
                CALL FUNCTION 'BAL_LOG_MSG_ADD'
                  EXPORTING
                    i_log_handle     = st_log_handle
                    i_s_msg          = st_msg
                  EXCEPTIONS
                    log_not_found    = 1
                    msg_inconsistent = 2
                    log_is_full      = 3
                    OTHERS           = 4.
*  st_log_handle = st_log_handle.
                APPEND st_log_handle TO st_loghandle.
*        CLEAR : st_log_handle.
                CLEAR : lst_xvbpa, st_msg.
              ENDIF.
              LOOP AT li_xvbpa INTO lst_xvbpa WHERE posnr = lv_posnr.
                CASE sy-tabix.
                  WHEN 5.
                    CONCATENATE 'Item' lst_xvbpa-posnr lst_xvbpa-parvw lst_xvbpa-kunnr lst_xvbpa-lifnr lst_xvbpa-adrnr
                                                    INTO st_msg-msgv1 SEPARATED BY space.
                  WHEN 6.
                    CONCATENATE ',' 'Item' lst_xvbpa-posnr lst_xvbpa-parvw lst_xvbpa-kunnr lst_xvbpa-lifnr lst_xvbpa-adrnr
                                                    INTO st_msg-msgv2 SEPARATED BY space.
                  WHEN 7.
                    CONCATENATE ',' 'Item' lst_xvbpa-posnr lst_xvbpa-parvw lst_xvbpa-kunnr lst_xvbpa-lifnr lst_xvbpa-adrnr
                                                   INTO st_msg-msgv3 SEPARATED BY space.
                  WHEN 8.
                    CONCATENATE ',' 'Item' lst_xvbpa-posnr lst_xvbpa-parvw lst_xvbpa-kunnr lst_xvbpa-lifnr lst_xvbpa-adrnr
                                   INTO st_msg-msgv4 SEPARATED BY space.
                  WHEN OTHERS.
                ENDCASE.
              ENDLOOP.
              IF st_msg IS NOT INITIAL.
                st_msg-msgid = 'ZQTC_R2'.
                st_msg-msgno = '000'.
                CALL FUNCTION 'BAL_LOG_MSG_ADD'
                  EXPORTING
                    i_log_handle     = st_log_handle
                    i_s_msg          = st_msg
                  EXCEPTIONS
                    log_not_found    = 1
                    msg_inconsistent = 2
                    log_is_full      = 3
                    OTHERS           = 4.
*  st_log_handle = st_log_handle.
                APPEND st_log_handle TO st_loghandle.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*----------------------------------------------------------------------*
* FF Determination
*----------------------------------------------------------------------*
* Validate and fetch freight forward data
      CALL FUNCTION 'ZQTC_FF_DETERMINE'
        EXPORTING
          im_vbak = is_vbak
          im_vbap = is_vbap
          im_flag = abap_true
        CHANGING
          ch_vbpa = li_xvbpa.
* Read freight forward address number for each line item
      READ TABLE li_xvbpa INTO DATA(ls_vbpa) INDEX 1.
      IF sy-subrc = 0.
        DATA(lv_adrnr) = ls_vbpa-adrnr.
      ENDIF.
    ENDIF.

    IF lv_adrnr IS NOT INITIAL.
* Send freight forward address to one source for tax calcualtion
      ms_sap_address-address = /idt/address=>build_address_from_key( lv_adrnr ).
      ms_sap_address-source_key-address_source  = 'ZQTC_FF_ADDRESS'.
      es_sap_address = ms_sap_address.
    ENDIF.
*----------------------------------------------------------------------*
* SLG Log Update
*----------------------------------------------------------------------*
    IF  lv_actv_flag2 = abap_true AND st_log_handle IS NOT INITIAL AND li_constants IS NOT INITIAL.
      IF sy-uname IN lir_user.
        CLEAR st_msg.
        st_msg-msgid = 'ZQTC_R2'.
        st_msg-msgno = '000'.
        st_msg-msgv1 = 'After Enhancement-'.
        IF lv_adrnr IS NOT INITIAL.
          CONCATENATE 'Address Num' lv_adrnr is_vbap-vbeln 'Item' is_vbap-posnr INTO st_msg-msgv2 SEPARATED BY space.
        ELSE.
          CONCATENATE  'no address/no FF found' is_vbak-vbeln 'Item' is_vbap-posnr INTO st_msg-msgv2 SEPARATED BY space.
        ENDIF.
        CALL FUNCTION 'BAL_LOG_MSG_ADD'
          EXPORTING
            i_log_handle     = st_log_handle
            i_s_msg          = st_msg
          EXCEPTIONS
            log_not_found    = 1
            msg_inconsistent = 2
            log_is_full      = 3
            OTHERS           = 4.
*  st_log_handle = st_log_handle.
        APPEND st_log_handle TO st_loghandle.
        IF st_loghandle IS NOT INITIAL.
          CALL FUNCTION 'BAL_DB_SAVE'
            EXPORTING
              i_client         = sy-mandt
              i_save_all       = abap_true
              i_t_log_handle   = st_loghandle
            IMPORTING
              e_new_lognumbers = i_lognum
            EXCEPTIONS
              log_not_found    = 1
              save_not_allowed = 2
              numbering_error  = 3
              OTHERS           = 4.
          IF sy-subrc EQ 0.
            "Do nothing
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  method /IDT/IF_BUILD_ADDRESS~SET_ADDRESS_ITM_SES.
*   Copyright 2015 Thomson Reuters/ONESOURCE. All Rights Reserved.
  endmethod.
ENDCLASS.
