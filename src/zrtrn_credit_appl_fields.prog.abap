*----------------------------------------------------------------------*
* PROGRAM NAME: ZRTRN_CREDIT_APPL_FIELDS (INCLUDE Program)
* PROGRAM DESCRIPTION: Credit Application Letter - Populate additional
*                      field values from Customer Master
* DEVELOPER: Writtick Roy (WROY)
* CREATION DATE:   01/06/2017
* OBJECT ID: F014
* TRANSPORT NUMBER(S):  ED2K904034
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K911727
* REFERENCE NO:  ERP-7219
* DEVELOPER: Himanshu Patel (HIPATEL)
* DATE:  03/24/2018
* DESCRIPTION: Customer Email to be picked up if the Partner data is not
*              available. Passing the export parameter im_v_deflt as 'X
*              in ZRTR_DET_CUSTOMER_EMAILS to read Email of the Customer
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO:
* REFERENCE NO:
* DEVELOPER:
* DATE:
* DESCRIPTION:
*----------------------------------------------------------------------*
    DATA:
      lv_srmadid_f014 TYPE srmadid,                                  "Attribute Description - ID
      lv_bus_partner  TYPE bu_partner,                               "Business Partner Number
      lv_credit_sgmnt TYPE ukm_credit_sgmnt,                         "Credit Segment
      lv_company_code TYPE bukrs,                                    "Company Code
      lv_name1        TYPE ad_name1,                                 "Name 1
      lv_name2        TYPE ad_name2,                                 "Name 2
      lv_email_id     TYPE ad_smtpadr,                               "E-Mail Address
      lv_tel_number   TYPE ad_tlnmbr1,                               "First telephone no.: dialling code+number
      lv_smtp_addr    TYPE ad_smtpadr,                               "E-Mail Address
      lv_fld_val_f014 TYPE string.                                   "Field Value (STRING)

    DATA:
      li_cntrct_email TYPE bcsy_smtpa.

    CONSTANTS:
      lc_bus_partner  TYPE fieldname VALUE 'FCR_PARTNER',            "Attribute: Business Partner Number
      lc_credit_sgmnt TYPE fieldname VALUE 'FCR_SEGMENT',            "Attribute: Credit Segment
      lc_first_name   TYPE fieldname VALUE 'ZZFIRST_NAME',           "Attribute: First name of business partner
      lc_last_name    TYPE fieldname VALUE 'ZZLAST_NAME',            "Attribute: Last name of business partner
      lc_email_id     TYPE fieldname VALUE 'ZZEMAIL_ID',             "Attribute: E-Mail Address
      lc_telephone_no TYPE fieldname VALUE 'ZZTELEPHONE'.            "Attribute: Telephone no.: dialling code+number

*   Get Business Partner Number
    TRY.
        lv_srmadid_f014 = lc_bus_partner.                            "Attribute: FCR_PARTNER
        lv_bus_partner = im_case->get_single_attribute_value( im_srmadid = lv_srmadid_f014 ).
      CATCH cx_scmg_case_attribute .
      CATCH cx_srm_framework .
    ENDTRY.

*   Get Credit Segment
    TRY.
        lv_srmadid_f014 = lc_credit_sgmnt.                           "Attribute: FCR_SEGMENT
        lv_credit_sgmnt = im_case->get_single_attribute_value( im_srmadid = lv_srmadid_f014 ).
      CATCH cx_scmg_case_attribute .
      CATCH cx_srm_framework .
    ENDTRY.

*   Get the Credit Control Area from Credit Segment (Assumption 1:1 rel)
    SELECT kkber                                                     "Credit Control Area
      FROM ukm_kkber2sgm
      INTO @DATA(lv_crd_cntrl_ar)
     UP TO 1 ROWS
     WHERE credit_sgmnt EQ @lv_credit_sgmnt.                         "Credit Segment
    ENDSELECT.
    IF sy-subrc EQ 0.
*     Get the Company Code from Credit Control Area (Assumption 1:1 rel)
      SELECT bukrs                                                   "Company Code
        FROM t001
        INTO lv_company_code
       UP TO 1 ROWS
       WHERE kkber EQ lv_crd_cntrl_ar.                               "Credit Control Area
      ENDSELECT.
      IF sy-subrc NE 0.
        CLEAR: lv_company_code.
      ENDIF.
    ENDIF.

    IF lv_bus_partner  IS NOT INITIAL AND
       lv_company_code IS NOT INITIAL.
*     Fetch Address number from Customer Master General Data
      SELECT SINGLE adrnr                                            "Address Number
        FROM kna1
        INTO @DATA(lv_adrnr)
       WHERE kunnr EQ @lv_bus_partner.                               "Business Partner / Customer Number
      IF sy-subrc EQ 0.
*       Fetch Address Details
        SELECT name1,                                                "Name 1
               name2,                                                "Name 2
               tel_number                                            "First telephone no.: dialling code+number
          FROM adrc
          INTO @DATA(lst_adrc)
         UP TO 1 ROWS
         WHERE addrnumber EQ @lv_adrnr                               "Address Number
           AND date_from  LE @sy-datum                               "Valid-from Date
           AND date_to    GE @sy-datum.                              "Valid-to Date
        ENDSELECT.
        IF sy-subrc NE 0.
          CLEAR: lst_adrc.
        ENDIF.

*       Fetch E-Mail Address
        CALL FUNCTION 'ZRTR_DET_CUSTOMER_EMAILS'
          EXPORTING
            im_v_kunnr             = lv_bus_partner                  "Business Partner
            im_v_bukrs             = lv_company_code                 "Company Code
            im_v_adrnr             = lv_adrnr                        "Address Number
            im_v_deflt             = abap_true                       "<ERP-7219> <ED2K911727>
          IMPORTING
            ex_t_emails            = li_cntrct_email                 "Customer / Contract Emails
          EXCEPTIONS
            exc_address_no_missing = 1
            OTHERS                 = 2.
        IF sy-subrc EQ 0.
          READ TABLE li_cntrct_email ASSIGNING FIELD-SYMBOL(<lv_email>) INDEX 1.
          IF sy-subrc EQ 0.
            lv_email_id = <lv_email>.                                "Email ID
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

*   Get First name of business partner
    TRY.
        lv_srmadid_f014 = lc_first_name.                             "Attribute: ZZFIRST_NAME
        lv_name1 = im_case->get_single_attribute_value( im_srmadid = lv_srmadid_f014 ).
      CATCH cx_scmg_case_attribute .
      CATCH cx_srm_framework .
    ENDTRY.
    IF lst_adrc-name1 IS NOT INITIAL AND                             "Name 1
       lv_name1       IS INITIAL.
*     Set First name of business partner
      TRY.
          lv_srmadid_f014 = lc_first_name.                           "Attribute: ZZFIRST_NAME
          lv_fld_val_f014 = lst_adrc-name1.                          "First name of business partner
          CALL METHOD im_case->set_single_attribute_value
            EXPORTING
              im_value   = lv_fld_val_f014                           "Field Value
              im_srmadid = lv_srmadid_f014.                          "Attribute Description - ID
        CATCH cx_scmg_case_attribute .
        CATCH cx_srm_framework .
      ENDTRY.
    ENDIF.

*   Get Last name of business partner
    TRY.
        lv_srmadid_f014 = lc_last_name.                             "Attribute: ZZLAST_NAME
        lv_name2 = im_case->get_single_attribute_value( im_srmadid = lv_srmadid_f014 ).
      CATCH cx_scmg_case_attribute .
      CATCH cx_srm_framework .
    ENDTRY.
    IF lst_adrc-name2 IS NOT INITIAL AND                             "Name 2
       lv_name2       IS INITIAL.
*     Set Last name of business partner
      TRY.
          lv_srmadid_f014 = lc_last_name.                            "Attribute: ZZLAST_NAME
          lv_fld_val_f014 = lst_adrc-name2.                          "Last name of business partner
          CALL METHOD im_case->set_single_attribute_value
            EXPORTING
              im_value   = lv_fld_val_f014                           "Field Value
              im_srmadid = lv_srmadid_f014.                          "Attribute Description - ID
        CATCH cx_scmg_case_attribute .
        CATCH cx_srm_framework .
      ENDTRY.
    ENDIF.

*   Get First telephone no.: dialling code+number
    TRY.
        lv_srmadid_f014 = lc_telephone_no.                           "Attribute: ZZTELEPHONE
        lv_tel_number = im_case->get_single_attribute_value( im_srmadid = lv_srmadid_f014 ).
      CATCH cx_scmg_case_attribute .
      CATCH cx_srm_framework .
    ENDTRY.
    IF lst_adrc-tel_number IS NOT INITIAL AND                        "First telephone no.: dialling code+number
       lv_tel_number       IS INITIAL.
*     Set First telephone no.: dialling code+number
      TRY.
          lv_srmadid_f014 = lc_telephone_no.                         "Attribute: ZZTELEPHONE
          lv_fld_val_f014 = lst_adrc-tel_number.                     "First telephone no.: dialling code+number
          CALL METHOD im_case->set_single_attribute_value
            EXPORTING
              im_value   = lv_fld_val_f014                           "Field Value
              im_srmadid = lv_srmadid_f014.                          "Attribute Description - ID
        CATCH cx_scmg_case_attribute .
        CATCH cx_srm_framework .
      ENDTRY.
    ENDIF.

*   Get E-Mail Address
    TRY.
        lv_srmadid_f014 = lc_email_id.                               "Attribute: ZZEMAIL_ID
        lv_smtp_addr = im_case->get_single_attribute_value( im_srmadid = lv_srmadid_f014 ).
      CATCH cx_scmg_case_attribute .
      CATCH cx_srm_framework .
    ENDTRY.
    IF lv_email_id  IS NOT INITIAL AND                               "E-Mail Address
       lv_smtp_addr IS INITIAL.
*     Set E-Mail Address
      TRY.
          lv_srmadid_f014 = lc_email_id.                             "Attribute: ZZEMAIL_ID
          lv_fld_val_f014 = lv_email_id.                             "E-Mail Address
          CALL METHOD im_case->set_single_attribute_value
            EXPORTING
              im_value   = lv_fld_val_f014                           "Field Value
              im_srmadid = lv_srmadid_f014.                          "Attribute Description - ID
        CATCH cx_scmg_case_attribute .
        CATCH cx_srm_framework .
      ENDTRY.
    ENDIF.
