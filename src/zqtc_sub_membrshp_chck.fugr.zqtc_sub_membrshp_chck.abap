FUNCTION zqtc_sub_membrshp_chck.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IM_SCCODE) TYPE  ZTQTC_SOCIETY_CODE OPTIONAL
*"     VALUE(IM_SUBS_REF) TYPE  ZTQTC_SUBS_REF OPTIONAL
*"     VALUE(IM_SMTP_ADDR) TYPE  ZTQTC_SMTPADR OPTIONAL
*"     VALUE(IM_PAYMENT_RATE) TYPE  ZTQTC_PAYMRATE OPTIONAL
*"     VALUE(IM_CNTRCTDAT) TYPE  VBDAT_VEDA OPTIONAL
*"     VALUE(IM_PYMNT_STS) TYPE  ZQTC_PYMNT_STS OPTIONAL
*"     VALUE(IM_DOUBLEBILLING) TYPE  ZQTC_DOUBLE_BILL OPTIONAL
*"     VALUE(IM_CNCL_CODE) TYPE  KUEGRU OPTIONAL
*"     VALUE(IM_SUBTYPE_CODE) TYPE  ZTQTC_SUBSTYP_CD OPTIONAL
*"     VALUE(IM_MEDIA_TYPE) TYPE  ZQTC_MEDIA_TYPE OPTIONAL
*"     VALUE(IM_POSTCODE) TYPE  ZQTC_POSTCODE OPTIONAL
*"     VALUE(IM_COUNTRY_CODE) TYPE  ZTQTC_CCODE OPTIONAL
*"  EXPORTING
*"     VALUE(EX_FINAL) TYPE  ZTQTC_MEMBERSHIP_CHECK
*"     VALUE(EX_RETURN_MSG) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
* PROGRAM NAME:           ZQTC_SUB_MEMBRSHP_CHCK
* PROGRAM DESCRIPTION:    SAP will hold the subscription data for Springboard, CWS and EHS
*                        systems. The systems will perform ad-hoc, nightly and weekly queries of
*                        SAP data for membership entitlement and reporting purposes.
*                        Based on the import parameter the RFC will return the records of Society
*                        Websites i.e. Springboard, CWS as well as EHS system.
* DEVELOPER:             Monalisa Dutta(MODUTTA)
* CREATION DATE:         19-Jan-2017
* OBJECT ID:             I0317
* TRANSPORT NUMBER(S):   ED2K904076
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K904076
* REFERENCE NO: CR# 388, CR#410, CR#403
* DEVELOPER: Monalisa Dutta
* DATE:  2017-03-16
* DESCRIPTION: Media Type, Title text, Firt Name, Last Name,
* Payment Status ,Cancellation Code addition
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906236
* REFERENCE NO: CR# 524
* DEVELOPER: Monalisa Dutta
* DATE:  2017-05-22
* DESCRIPTION: Addition of ZMJE in ZCACONSTANT and adding including media
* type during filteration of records
*-----------------------------------------------------------------------*
* REVISION NO: ED2K908439
* REFERENCE NO: CR# 645
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-09-06
* DESCRIPTION: Subscription order(IM_VBELN) has been updated with Subscription
* reference(IM_SUBS_REF)and this will contain both IHREZ and IHREZ_E values.
* Also we interchanged the positions of VBELN and IHREZ_E in the output structure.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K909942
* REFERENCE NO: ERP-5596
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2017-12-18
* DESCRIPTION: program has been optimized as currently its getting timed out
*              due to huge number of records being selected for society and date.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K910329
* REFERENCE NO: ERP-5596
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2018-01-15
* DESCRIPTION: BAPI has been removed as it was taking a lot of time and used
*              individual selects to get the data for performance optimization.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K910383
* REFERENCE NO: ERP-5596
* DEVELOPER: Pavan Bandlapalli(PBANDLAPAL)
* DATE:  2018-01-19
* DESCRIPTION: Contract Date issue has been fixed. It was considering the
*              contract dates from header though the line items weren't
*              in  the range given in the input selection.
*-----------------------------------------------------------------------*
* REVISION NO: ED2K911038
* REFERENCE NO: ERP-6750
* DEVELOPER: Dinakar T(DTIRUKOOVA)
* DATE:  2018-02-22
* DESCRIPTION: Bug fix while fetching data w.r.t email ID and reference(IHREZ)
*              and adding logic for application log
*-----------------------------------------------------------------------*
* REVISION NO: ED2K919802
* REFERENCE NO: ERPM-13923
* DEVELOPER: GKAMMILI
* DATE:  10-09-2020
* DESCRIPTION: WOL Validation for CWS of Web orders to avoid Sub/Quote mismatches
*-----------------------------------------------------------------------*
**
*FUNCTION ZQTC_SUB_MEMBRSHP_CHCK.

* Local data declaration
  DATA: lr_society  TYPE REF TO zzsociety_acrnym, "Class
        lr_email    TYPE REF TO ad_smtpadr, "Email
* BOC by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
*          lr_vbeln    TYPE REF TO vbeln,
        lr_subs_ref TYPE REF TO ihrez,
* EOC by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
        lr_payment  TYPE REF TO zqtc_paymrate,
        lr_subtyp   TYPE REF TO zqtc_subsc_cd,
*BOC by GKAMMILI on 10/09/2020 for OTCM 13923
        lr_quote    TYPE REF TO vbeln,
        lr_postal   TYPE REF TO ad_pstcd2,
        lr_country  TYPE REF TO land1,
*EOC by GKAMMILI on 10/09/2020 for OTCM 13923
        li_payment  TYPE tt_payment,
        li_subtyp   TYPE tt_subtyp,
        li_society  TYPE tt_society,
* BOC by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
*          li_vbeln    TYPE tt_vbeln,
        li_subs_ref TYPE tt_ihrez,
* EOC by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
        li_email    TYPE tt_email,
*BOC by GKAMMILI on 10/09/2020 for OTCM 13923
        li_quote    TYPE tt_quote,
        li_postal   TYPE tt_postal,
        li_country  TYPE tt_country,
*EOC by GKAMMILI on 10/09/2020 for OTCM 13923
        li_constant TYPE tt_constant,
        li_bapiret  TYPE bapiret2_t,
        li_final    TYPE ztqtc_membership_check.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
  DATA : lv_fval(200) TYPE c,
         lv_char(200) TYPE c,
         lv_text(200) TYPE c,
         lv_length    TYPE i,
         lv_length1   TYPE i,
         lv_length2   TYPE i,
         lv_lines     TYPE i.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
*Fetch CONSTANTS from ZCONSTANT table
  PERFORM f_get_constant CHANGING li_constant.

* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Create Application log
  PERFORM f_create_log USING li_constant.
* update application log
  lv_fval = text-006.
  PERFORM f_log_maintain  USING lv_fval.

  CLEAR: lv_fval.
  lv_fval = text-001.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038

  IF im_sccode IS NOT INITIAL.
    LOOP AT im_sccode REFERENCE INTO lr_society.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* add all the society from input paramter to message log
      lv_char = lr_society->*.
      IF gv_sccode IS INITIAL AND lv_char IS NOT INITIAL.   "ERPM-13923
        gv_sccode = lv_char.
      ENDIF.
      PERFORM f_log_message USING lv_char
                            CHANGING  lv_fval lv_text lv_length.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
      APPEND lr_society->*  TO li_society.
      CLEAR lr_society->*.

    ENDLOOP. " LOOP AT im_sccode REFERENCE INTO lr_society
    DELETE ADJACENT DUPLICATES FROM li_society COMPARING society.

* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Add message to Appl Log
    IF lv_fval IS NOT INITIAL.
      CONCATENATE lv_fval lv_text INTO lv_fval SEPARATED BY space.
      PERFORM f_log_maintain  USING lv_fval.
      CLEAR : lv_fval.
    ENDIF.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
  ENDIF. " IF im_sccode IS NOT INITIAL

* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Add message Heading
  CLEAR : lv_fval.
  lv_fval = text-010.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038

  IF im_smtp_addr IS NOT INITIAL.
    LOOP AT im_smtp_addr REFERENCE INTO lr_email.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Add all the emails from Input parameter
      lv_char = lr_email->*.
      PERFORM f_log_message USING lv_char
                            CHANGING  lv_fval lv_text lv_length.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
*      TRANSLATE lr_email->* TO LOWER CASE.
      APPEND lr_email->* TO li_email.
      CLEAR lr_email->*.
    ENDLOOP.
    DELETE ADJACENT DUPLICATES FROM li_email COMPARING email.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Add message to Appl Log
    IF lv_fval IS NOT INITIAL.
      CONCATENATE lv_fval lv_text INTO lv_fval SEPARATED BY space.
      PERFORM f_log_maintain  USING lv_fval.
      CLEAR : lv_fval.
    ENDIF.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
  ENDIF.

* BOC by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
*  IF im_vbeln IS NOT INITIAL.
*    LOOP AT im_vbeln REFERENCE INTO lr_vbeln.
*      APPEND lr_vbeln->* TO li_vbeln.
*      CLEAR lr_vbeln->*.
*    ENDLOOP.
*    DELETE ADJACENT DUPLICATES FROM li_vbeln COMPARING vbeln.
*  ENDIF.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Add heading to Message log
  CLEAR : lv_fval.
  lv_fval = text-009.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
  IF im_subs_ref IS NOT INITIAL.
    LOOP AT im_subs_ref REFERENCE INTO lr_subs_ref.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Add all the subscription reference from input paramter to message
      lv_char = lr_subs_ref->*.
      PERFORM f_log_message USING lv_char
                            CHANGING  lv_fval lv_text lv_length.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
      APPEND lr_subs_ref->* TO li_subs_ref.
      CLEAR lr_subs_ref->*.
    ENDLOOP.
    DELETE ADJACENT DUPLICATES FROM li_subs_ref COMPARING ihrez.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Add message to Appl Log
    IF lv_fval IS NOT INITIAL.
      CONCATENATE lv_fval lv_text INTO lv_fval SEPARATED BY space.
      PERFORM f_log_maintain  USING lv_fval.
      CLEAR : lv_fval.
    ENDIF.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
  ENDIF.
* EOC by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Add heading to Message log
  CLEAR : lv_fval.
  lv_fval = text-011.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
  IF im_payment_rate IS NOT INITIAL.
    LOOP AT im_payment_rate REFERENCE INTO lr_payment.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Add Payment values from import parameter to Message log
      lv_char = lr_payment->*.
      PERFORM f_log_message USING lv_char
                            CHANGING  lv_fval lv_text lv_length.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
      APPEND lr_payment->* TO li_payment.
      CLEAR lr_payment->*.
    ENDLOOP.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Add message to Appl Log
    IF lv_fval IS NOT INITIAL.
      CONCATENATE lv_fval lv_text INTO lv_fval SEPARATED BY space.
      PERFORM f_log_maintain  USING lv_fval.
      CLEAR : lv_fval.
    ENDIF.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
  ENDIF.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Add heading to message log
  CLEAR : lv_fval.
  lv_fval = text-016.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
  IF im_subtype_code IS NOT INITIAL.
    LOOP AT im_subtype_code REFERENCE INTO lr_subtyp.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Adding Subtype codes from imprt parameters to message log
      lv_char = lr_subtyp->*.
      PERFORM f_log_message USING lv_char
                            CHANGING  lv_fval lv_text lv_length.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
      APPEND lr_subtyp->* TO li_subtyp.
      CLEAR lr_subtyp->*.
    ENDLOOP.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Add message to Appl Log
    IF lv_fval IS NOT INITIAL.
      CONCATENATE lv_fval lv_text INTO lv_fval SEPARATED BY space.
      PERFORM f_log_maintain  USING lv_fval.
      CLEAR : lv_fval.
    ENDIF.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
  ENDIF.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Adding contract date to message log
  IF im_cntrctdat IS NOT INITIAL.
    CLEAR : lv_fval.
    lv_fval = im_cntrctdat.
    CONCATENATE text-012 lv_fval INTO lv_fval SEPARATED BY  space.
    PERFORM f_log_maintain  USING lv_fval.
  ENDIF.
* Adding payment status to message log
  IF im_pymnt_sts IS NOT INITIAL.
    CLEAR : lv_fval.
    lv_fval = im_pymnt_sts.
    CONCATENATE text-013 lv_fval INTO lv_fval SEPARATED BY  space.
    PERFORM f_log_maintain  USING lv_fval.
  ENDIF.
* Adding doublebilling to message log.
  IF im_doublebilling IS NOT INITIAL.
    CLEAR : lv_fval.
    lv_fval = im_doublebilling.
    CONCATENATE text-014 lv_fval INTO lv_fval SEPARATED BY  space.
    PERFORM f_log_maintain  USING lv_fval.
  ENDIF.
* Adding Cancellation code to message log
  IF im_cncl_code IS NOT INITIAL.
    CLEAR : lv_fval.
    lv_fval = im_cncl_code.
    CONCATENATE text-015 lv_fval INTO lv_fval SEPARATED BY  space.
    PERFORM f_log_maintain  USING lv_fval.
  ENDIF.
* Adding media type to message log
  IF im_media_type IS NOT INITIAL.
    CLEAR : lv_fval.
    lv_fval = im_media_type.
    CONCATENATE text-017 lv_fval INTO lv_fval SEPARATED BY  space.
    PERFORM f_log_maintain  USING lv_fval.
  ENDIF.
  CLEAR : lv_fval.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
*<<<<<<<<<<BOC by MODUTTA on 16/03/2017 for CR# 403>>>>>>>>>>>
  IF im_media_type IS INITIAL.
    im_media_type = c_media_default.
  ENDIF.
*<<<<<<<<<<EOC by MODUTTA on 16/03/2017 for CR# 403>>>>>>>>>>>
*--BOC by GKAMMILI on 09-10-2020 for OTCM 13923
*  IF im_quote IS NOT INITIAL.
*    LOOP AT im_quote REFERENCE INTO lr_quote.
** Add Quotation values from import parameter to Message log
*      lv_char = lr_quote->*.
*      PERFORM f_log_message USING lv_char
*                            CHANGING  lv_fval lv_text lv_length.
*      APPEND lr_quote->* TO li_quote.
*      CLEAR lr_quote->*.
*    ENDLOOP.
** Add message to Appl Log
*    IF lv_fval IS NOT INITIAL.
*      CONCATENATE lv_fval lv_text INTO lv_fval SEPARATED BY space.
*      PERFORM f_log_maintain  USING lv_fval.
*      CLEAR : lv_fval.
*    ENDIF.
*  ENDIF.

  IF im_postcode IS NOT INITIAL.
    LOOP AT im_postcode REFERENCE INTO lr_postal.
* Add postal code values from import parameter to Message log
      lv_char = lr_postal->*.
      PERFORM f_log_message USING lv_char
                            CHANGING  lv_fval lv_text lv_length.
      APPEND lr_postal->* TO li_postal.
      CLEAR lr_postal->*.
    ENDLOOP.
* Add message to Appl Log
    IF lv_fval IS NOT INITIAL.
      CONCATENATE lv_fval lv_text INTO lv_fval SEPARATED BY space.
      PERFORM f_log_maintain  USING lv_fval.
      CLEAR : lv_fval.
    ENDIF.
  ENDIF.
  IF im_country_code IS NOT INITIAL.
    LOOP AT im_country_code REFERENCE INTO lr_country.
* Add Country code values from import parameter to Message log
      lv_char = lr_country->*.
      PERFORM f_log_message USING lv_char
                            CHANGING  lv_fval lv_text lv_length.
      APPEND lr_country->* TO li_country.
      CLEAR lr_country->*.
    ENDLOOP.
* Add message to Appl Log
    IF lv_fval IS NOT INITIAL.
      CONCATENATE lv_fval lv_text INTO lv_fval SEPARATED BY space.
      PERFORM f_log_maintain  USING lv_fval.
      CLEAR : lv_fval.
    ENDIF.
  ENDIF.

*--EOC by GKAMMILI on 09-1--2020 for OTCM 13923
*  Subroutine to get Subscription no from society details
  CASE gv_sccode.
*BOC by GKAMMILI on 10/09/2020 for OTCM 13923
    WHEN 'WOL-CWS'.
      im_media_type = c_media_type_m.
      PERFORM f_get_data_cws USING  li_society
                                      li_email
                                      li_subs_ref
                                      im_cntrctdat
                                      im_pymnt_sts
                                      im_doublebilling
                                      li_payment
                                      im_cncl_code
                                      li_subtyp
                                      li_constant
                                      im_media_type
                                      li_postal
                                      li_country
                              CHANGING li_bapiret
                                       li_final.
*EOC by GKAMMILI on 10/09/2020 for OTCM 13923
    WHEN OTHERS.
* Existing Functionality
      PERFORM f_get_data USING  li_society
                                li_email
* BOC by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
*                            li_vbeln
                                li_subs_ref
* EOC by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
                                im_cntrctdat
                                im_pymnt_sts
                                im_doublebilling
                                li_payment
                                im_cncl_code
                                li_subtyp
                                li_constant
                                im_media_type "Added by MODUTTA for CR#403
                        CHANGING li_bapiret
                                 li_final.
  ENDCASE.

* Population of final table
  IF li_final IS NOT INITIAL.
    ex_final[] = li_final[].
  ENDIF.

* Population of error table
  IF li_bapiret IS NOT INITIAL.
    ex_return_msg[] = li_bapiret[].
  ENDIF.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* update application log - Number of Subscriptions
  CLEAR : lv_fval,
          lv_lines.
  DESCRIBE TABLE ex_final[] LINES lv_lines.
  lv_fval = lv_lines.
  CONDENSE lv_fval.
  CONCATENATE text-008 lv_fval INTO lv_fval SEPARATED BY space.
  PERFORM f_log_maintain  USING lv_fval.
  CLEAR : lv_fval.
  lv_fval = text-007.
  PERFORM f_log_maintain  USING lv_fval.

* Save the log
  PERFORM f_log_save.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
ENDFUNCTION.
