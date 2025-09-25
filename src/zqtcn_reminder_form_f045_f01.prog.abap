*----------------------------------------------------------------------*
* PROGRAM NAME:          ZQTCN_REMINDER_FORM_F045_F01
* PROGRAM DESCRIPTION:   Program to send advance proforma reminders
* DEVELOPER:             GKINTALI
* CREATION DATE:         25/10/2018
* OBJECT ID:             F045 (ERP-7668)
* TRANSPORT NUMBER(S):   ED2K913677
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REFERENCE NO:  OTCM-51284/FMM-5645
* DEVELOPER   :  SGUDA
* DATE        :  12/NOV/2021
* DESCRIPTION :  Remit to details changes for CC1001
* 1) If Company Code 1001', Document Currency 'USD' and
* Sales Office is 0050  EAL OR 0030 CSS  OR  0110 Knewton – Enterprise
* 0120  Knewton - B2B OR 0400-  J&J Sales Office OR 0080-Non-EAL
* Then Change Check and Wire Details
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: <TRANSPORT NO>
* REFERENCE NO:  <DER OR TPR OR SCR>
* DEVELOPER:
* DATE:  MM/DD/YYYY
* DESCRIPTION:
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       Get the required proformas based on the given conditions
*----------------------------------------------------------------------*
FORM f_get_data.
  DATA: lst_return TYPE bapiret2, " Return Parameter
        lv_string  TYPE string.   " Variable to store the return message text

* Get the proformas from VBRK in the specified date range
  SELECT vbeln    " Billing Document
         fkart    " Billing Type
         waerk    " SD Document Currency
         vkorg    " Sales Organization
         fkdat    " Billing date for billing index and printout
         netwr    " Net Value in Document Currency
         kunrg    " Payer
         bstnk_vf " Customer purchase order number
    FROM vbrk     " Billing Document: Header Data
    INTO TABLE gt_vbrk_sub
    WHERE vbeln IN s_vbeln
***    AND   fkart =  p_fkart
***    AND   vkorg =  p_vkorg
    AND   fkart IN s_fkart
    AND   vkorg IN s_vkorg
    AND   fkdat IN s_fkdat
    AND   kunrg IN s_kunrg.

  IF sy-subrc = 0.
* Get the related documents of each proforma from VBFA
    SELECT vbelv     " Preceding sales and distribution document
           posnv     " Preceding item of an SD document
           vbeln     " Subsequent sales and distribution document
           posnn     " Subsequent item of an SD document
           vbtyp_n   " Document category of subsequent document
      FROM vbfa      " Sales Document Flow
      INTO TABLE gt_vbfa_sub
      FOR ALL ENTRIES IN gt_vbrk_sub
      WHERE vbeln  = gt_vbrk_sub-vbeln.

    IF sy-subrc = 0.
      SORT gt_vbfa_sub BY vbelv vbeln.
      DELETE ADJACENT DUPLICATES FROM gt_vbfa_sub COMPARING vbelv vbeln.
      SORT gt_vbfa_sub BY vbeln.

* Get the contracts from VBAK
      SELECT vbeln   " Sales Document
             auart   " Sales Document Type
             netwr   " Net Value of the Sales Order in Document Currency
             waerk   " SD Document Currency
             vkbur   " OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
        FROM vbak    " Sales Document: Header Data
        INTO TABLE gt_vbak_sub
        FOR ALL ENTRIES IN gt_vbfa_sub
        WHERE vbeln EQ gt_vbfa_sub-vbelv.
      IF sy-subrc = 0.
        SORT gt_vbak_sub BY vbeln.
      ENDIF.
    ENDIF.

*Check if Subsequent document created for the contract
    IF gt_vbak_sub IS NOT INITIAL.
      SELECT vbelv    " Preceding sales and distribution document
             posnv    " Preceding item of an SD document
             vbeln    " Subsequent sales and distribution document
             posnn    " Subsequent item of an SD document
             vbtyp_n  " Document category of subsequent document
        FROM vbfa     " Sales Document Flow
        INTO TABLE gt_vbfa_zf2
        FOR ALL ENTRIES IN gt_vbak_sub
        WHERE vbelv  = gt_vbak_sub-vbeln.
      IF sy-subrc = 0.
        SORT gt_vbfa_zf2 BY vbelv vbeln.
        DELETE ADJACENT DUPLICATES FROM gt_vbfa_zf2 COMPARING vbelv vbeln.
        SORT gt_vbfa_zf2 BY vbelv vbtyp_n.

*Get Invoice type
        SELECT vbeln   " Billing Document
               fkart   " Billing Type
               waerk   " SD Document Currency
               vkorg   " Sales Organization
               fkdat   " Billing date for billing index and printout
          FROM vbrk    " Billing Document: Header Data
          INTO TABLE gt_vbrk_zf2
          FOR ALL ENTRIES IN gt_vbfa_zf2
          WHERE vbeln = gt_vbfa_zf2-vbeln.
        IF sy-subrc EQ 0.
          SORT gt_vbrk_zf2 BY vbeln.
        ENDIF.    "IF sy-subrc eq 0.
      ENDIF.    "IF sy-subrc = 0.
    ENDIF.  " IF gt_vbak_sub IS NOT INITIAL.
  ELSE.
*    IF sy-batch <> abap_true.
*      MESSAGE i000 WITH 'No Data available for the Selection Criteria'(002) DISPLAY LIKE 'E'.
*    ELSE.
    lst_return-type    = gc_err. " '' /'E'
    lst_return-id      = gc_msg_cls. " Message class = ZQTC_R2
    lst_return-number  = gc_msgno. "000

    CLEAR lv_string.
* Call FM to form message to display while updation is successful or errorneous.
    CALL FUNCTION 'FORMAT_MESSAGE'
      EXPORTING
        id        = lst_return-id     " Message ID
        lang      = sy-langu          " System Language
        no        = lst_return-number " Message Number
*       v1        = sy-msgv1
*       v2        = sy-msgv2
*       v3        = sy-msgv3
*       v4        = sy-msgv4
      IMPORTING
        msg       = lv_string         " Output Variable
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
    IF sy-subrc IS NOT INITIAL.
      CLEAR lv_string.
* Implement suitable error handling here

    ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
      CONCATENATE lv_string
                  'No Data available for the Selection Criteria'(002)
             INTO lv_string SEPARATED BY space.
      lst_return-message = lv_string.
    ENDIF. " IF sy-subrc IS NOT INITIAL

    APPEND lst_return TO gt_return.
    CLEAR lst_return.
* If there is no data found for further processing, send an email notification.
    IF s_email[] IS NOT INITIAL.
* Email id is determined, so send the reminder notification with file path details.
      PERFORM f_send_email_notification USING gc_crep
                                              gt_remlog.
    ENDIF.  " IF lt_cntrct_email IS INITIAL.
*    ENDIF.  " IF sy-batch <> abap_true.
  ENDIF.  " IF sy-subrc = 0.
ENDFORM.               " F_GET_DATA
*&---------------------------------------------------------------------*
*&      Form F_PROCESS_DATA
*&---------------------------------------------------------------------*
*   Process the data and output processing
*----------------------------------------------------------------------*
FORM f_process_data.

  DATA:
    lst_vbrk_sub TYPE ty_vbrk_sub,
    lst_vbrk     TYPE ty_vbrk_fin,
    lst_vbrk_zf2 TYPE ty_vbrk_sub,
    lst_vbrk_zf5 TYPE ty_vbrk_sub,
    lst_vbfa_sub TYPE ty_vbfa_sub,
    lst_vbfa_zf2 TYPE ty_vbfa_sub,
    lst_vbak_sub TYPE ty_vbak_sub,
    lv_zf2_found TYPE flag,       " General Flag
    lv_tot       TYPE netwr,      " Net Value in Document Currency
    lt_vbrk      TYPE STANDARD TABLE OF vbrk,  " Internal Table for Billing Document: Header Data
    lst_vbrk_tmp TYPE vbrk,       " Structure for Billing Document: Header Data
    lst_t001s    TYPE t001s,      " Accounting Clerks
    lst_fsabe    TYPE fsabe,      " Accounting Clerk Address Data
    lv_date      TYPE datum,      " Date
    lst_address  TYPE string,     " Formatted address (maximum 10 lines)
    lv_amount    TYPE char20,     " Amount of type CHAR20
    lv_lock      TYPE flag,       " General Flag
    lt_vbeln     TYPE STANDARD TABLE OF vbeln,  " Internal Table for Sales Documents
    lv_vbeln     TYPE vbeln,      " Sales Document
    lst_return   TYPE bapiret2, " Return Parameter
    lv_string    TYPE string,
    lt_receivers TYPE bcsy_smtpa,
    lt_remlog    TYPE tt_remlog,
***    lv_deflt_comm TYPE ad_comm,
    lv_flg_bp    TYPE char3, " Flag in case BP email ID is found
    lv_flg_zs    TYPE char3, " Flag if ZS partners to be used
    lv_flg_crep  TYPE char3. " Flag if the credit reps from Selection screen to be used

***    CONSTANTS:
***      lc_deflt_comm_int   TYPE ad_comm  VALUE 'INT'.

  CLEAR gt_remlog[].

  lv_date = sy-datum - 30.  " Going back to past 30 days

  SORT gt_vbrk_sub BY fkdat kunrg.
  LOOP AT gt_vbrk_sub INTO lst_vbrk_sub.

    CLEAR lst_vbfa_sub.
* Read the contract from VBFA
    READ TABLE gt_vbfa_sub INTO lst_vbfa_sub WITH KEY vbeln  = lst_vbrk_sub-vbeln BINARY SEARCH.
    IF sy-subrc  = 0.
      CLEAR lst_vbak_sub.
      READ TABLE gt_vbak_sub INTO lst_vbak_sub WITH KEY vbeln = lst_vbfa_sub-vbelv BINARY SEARCH.
      IF sy-subrc = 0.
* If the contract found in VBAK, proceed to check the subsequent ZF2 document
        CLEAR: lst_vbfa_zf2.
        LOOP AT gt_vbfa_zf2 INTO lst_vbfa_zf2 WHERE  vbelv   = lst_vbak_sub-vbeln
                                              AND    vbtyp_n = 'M' .  " Category - Invoice
          CLEAR: lst_vbrk_zf2.
          READ TABLE gt_vbrk_zf2 INTO lst_vbrk_zf2 WITH KEY vbeln = lst_vbfa_zf2-vbeln BINARY SEARCH.
          IF sy-subrc = 0 AND lst_vbrk_zf2-fkart EQ gc_zf2.
* ZF2 document found for the contract. So ignore the proforma
            lv_zf2_found = 'X'.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF lv_zf2_found = 'X'.
* The proforma is alreay ZF2 invoiced, so ignore it. Proceed to the next record.
          CLEAR lv_zf2_found.
          CONTINUE.
        ENDIF.
      ENDIF.   " IF sy-subrc = 0. - Check on VBAK read statement
      IF lst_vbrk_sub-fkdat LE lv_date.
* Include the proforma which is not ZF2 invoiced only if it falls under 30days past criteria
        MOVE-CORRESPONDING lst_vbrk_sub TO lst_vbrk.
        APPEND lst_vbrk TO gt_vbrk.
        CLEAR lst_vbrk.
      ELSE.
* Check if the customer is already included for the reminder, then include the proforma
* though its not falling under 30 days past criteria.
        READ TABLE gt_vbrk WITH KEY kunrg = lst_vbrk_sub-kunrg TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING lst_vbrk_sub TO lst_vbrk.
          APPEND lst_vbrk TO gt_vbrk.
          CLEAR lst_vbrk.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.  " LOOP AT gt_vbrk_sub INTO lst_vbrk_sub.

  IF gt_vbrk IS NOT INITIAL.
    CLEAR lst_vbrk.
    SORT gt_vbrk BY waerk vkorg kunrg.
    gt_vbrk_tmp = gt_vbrk.
    SORT gt_vbrk_tmp BY kunrg vkorg.
    DELETE ADJACENT DUPLICATES FROM gt_vbrk_tmp COMPARING kunrg vkorg.

* Fetch customer data for Address Number, Accounting Clerk Data
    SELECT a~kunnr,   " Customer Number
           a~land1,   " Country Key
           a~adrnr,   " Address
           a~spras,   " Language Key
           b~bukrs,   " Company Code
           b~busab    " Accounting clerk
      FROM kna1 AS a  " General Data in Customer Master
      JOIN knb1 AS b  " Customer Master (Company Code)
      ON a~kunnr = b~kunnr
      INTO TABLE @DATA(lt_kna1)
      FOR ALL ENTRIES IN @gt_vbrk_tmp
      WHERE a~kunnr    = @gt_vbrk_tmp-kunrg
      AND   b~bukrs    = @gt_vbrk_tmp-vkorg.
    IF sy-subrc <> 0.
      " Do nothing here
    ELSE.
      SORT lt_kna1 BY kunnr bukrs.
    ENDIF.

    CLEAR: gt_vbrk_tmp, lst_vbrk_tmp.
* For same Payor, Break the proforma reminders if company code of Sales Org is different.
* For Same Payor, Break the proforma reminders by document currency of the proforma.
* Separate reminder needs to be generated if for the same Payor different proformas exist in different document currency.
    LOOP AT gt_vbrk INTO lst_vbrk.

      MOVE-CORRESPONDING lst_vbrk TO lst_vbrk_tmp.
      APPEND lst_vbrk_tmp TO lt_vbrk.

* Stroing the proformas in a temporary internal table to store in the custom table later.
      lv_vbeln = lst_vbrk-vbeln.
      APPEND lv_vbeln TO lt_vbeln.

      lv_tot = lv_tot + lst_vbrk-netwr.

* At the end of customer event here - triggers when there is a change in Currency / Sales Org / Customer.
      AT END OF kunrg.

* Lock on the customer - exclusive lock - if lock fails - terminate the process.
        CALL FUNCTION 'ENQUEUE_EXKNA1'
          EXPORTING
            mode_kna1      = 'X'
            mandt          = sy-mandt
            kunnr          = lst_vbrk-kunrg
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.
        IF sy-subrc <> 0. " If the foregin lock
          lst_return-type    = gc_err.     " 'E'
          lst_return-id      = gc_msg_cls. " Message class = ZQTC_R2
          lst_return-number  = gc_msgno.   " 000

          CLEAR lv_string.
* Call FM to form message to display while updation is successful or errorneous.
          CALL FUNCTION 'FORMAT_MESSAGE'
            EXPORTING
              id        = lst_return-id     " Message ID
              lang      = sy-langu          " System Language
              no        = lst_return-number " Message Number
*             v1        = sy-msgv1
*             v2        = sy-msgv2
*             v3        = sy-msgv3
*             v4        = sy-msgv4
            IMPORTING
              msg       = lv_string         " Output Variable
            EXCEPTIONS
              not_found = 1
              OTHERS    = 2.
          IF sy-subrc IS NOT INITIAL.
            CLEAR lv_string.
* Implement suitable error handling here

          ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
            CONCATENATE lv_string
                        'Customer'(004)
                        lst_vbrk-kunrg
                        ' can not be locked.'(015)
                   INTO lv_string SEPARATED BY space.
            lst_return-message = lv_string.
          ENDIF. " IF sy-subrc IS NOT INITIAL

          APPEND lst_return TO gt_return.
          CLEAR: lst_return, lt_vbrk, lt_vbeln, lv_tot.
          CONTINUE.
        ELSE.
* Flag - to be used during deque process
          lv_lock = abap_true.
        ENDIF.

        READ TABLE lt_kna1 INTO DATA(lst_kna1) WITH KEY kunnr = lst_vbrk-kunrg
                                                        bukrs = lst_vbrk-vkorg BINARY SEARCH.
        IF sy-subrc <> 0.
          " Do nothing here
        ENDIF.

* Get the customer address in printable format based on the country
        PERFORM f_customer_address USING    lst_kna1-land1
                                            lst_kna1-adrnr
                                   CHANGING lst_address.

* Get the Accounting clerk's /Credit Dept contact Data
        PERFORM f_get_crdt_dept_cont USING    lst_vbrk-vkorg
                                              lst_kna1-busab
                                     CHANGING lst_t001s
                                              lst_fsabe.

* Populate the global fields required for the form
        v_land1      = lst_kna1-land1.  " Country Key
        v_bukrs      = lst_vbrk-vkorg.  " Slaes Org / Company Code
        v_curr       = lst_vbrk-waerk.  " Currency
        v_notif_dat  = sy-datum.        " Notification Date
        v_kunrg      = lst_vbrk-kunrg.  " Account Number
        v_sname      = lst_t001s-sname. " Credit Department Account
        v_ph_no      = lst_fsabe-telf1. " Addresses: telephone no.
        v_email_addr = lst_fsabe-intad. " Internet address of partner company clerk
        v_langu      = lst_kna1-spras.  " Language Key
        WRITE sy-datum MM/DD/YYYY TO v_date.

*Perform to populate standard text
        PERFORM f_pop_std_txt USING     v_land1
                                        v_bukrs
                                        v_curr
                                        gt_const
                              CHANGING  v_body
                                        v_footer1
                                        v_remit_to
                                        v_crop_duns.

* Perform to determine the recepients of the email - Updated on 12/12/2018
* 1. If email Id is maintained for BP, then the advance payment reminder should be attached to BP via an email
* 2. IF the email is not maintaiined for the BP, determine the credit representative i.e., ZS partner of the BP
*    and send a notification only - no attachment
* 3. If no email on BP, no credit representative, then send email notification for the recepients on the selection screen.
************************************************
***        SELECT deflt_comm         "Communication Method (Key) (Business Address Services)
***          FROM adrc
***          INTO lv_deflt_comm           "businees address
***         UP TO 1 ROWS
***         WHERE addrnumber = lst_kna1-adrnr.  "address number
***        ENDSELECT.
***        IF sy-subrc IS INITIAL.
**** If the partner's default communication is email in BP, then consider the email ID of BP itself
***          IF lv_deflt_comm EQ lc_deflt_comm_int.  "'INT' = Email Mode
****     Mail ID extraction based on Address Number
***            SELECT addrnumber,                              "Address number
***                   persnumber,                              "Person number
***                   smtp_addr                                "E-Mail Address
***              FROM adr6
***              INTO TABLE @DATA(li_adr6)
***             WHERE addrnumber =  @lst_kna1-adrnr                   "Address Number
***               AND persnumber EQ @space                     "Person number "+ <HIPATEL> <ERP-7219>
***               AND flgdefault =  @abap_true.                 "Flag: this address is the default address
***            IF sy-subrc NE 0.
***              CLEAR: li_adr6.
***            ELSE.
**** Read the first email ID of BP if found
***              READ TABLE li_adr6 ASSIGNING FIELD-SYMBOL(<lv_email>) INDEX 1.
***              IF sy-subrc EQ 0.
***                v_email_id = <lv_email>-smtp_addr.  " Email ID
***                lv_flg_bp  = gc_bp.
***              ENDIF.
***            ENDIF.
***          ENDIF.  " IF lv_deflt_comm EQ lc_deflt_comm_int.  "'INT'.
***        ENDIF.  " IF sy-subrc IS INITIAL.
***        IF lv_deflt_comm NE lc_deflt_comm_int.  "'INT' = Email Mode
        PERFORM f_determine_receivers USING lst_vbrk-kunrg
                                            lst_vbrk-vkorg
                                            lst_kna1-adrnr
                                   CHANGING gt_receivers
                                            lv_flg_zs.
***        ENDIF.  " IF lv_deflt_comm NE lc_deflt_comm_int.
***        IF lv_flg_bp = gc_bp AND lv_flg_zs = gc_zs.
***          lv_flg_crep = gc_crep.
***        ENDIF.
************************************************
* Perform has been used to generate the pdf form without preview
        PERFORM f_generate_adobe_form USING    lst_vbrk-kunrg
                                               lst_vbrk-vkorg
                                               lt_vbrk
                                               lv_tot
                                               lst_address
                                      CHANGING v_retcode.
        IF v_retcode <> 0.
          lst_return-type    = gc_err.     " 'E'
          lst_return-id      = gc_msg_cls. " Message class = ZQTC_R2
          lst_return-number  = gc_msgno.   " 000

          CLEAR lv_string.
* Call FM to form message to display while updation is successful or errorneous.
          CALL FUNCTION 'FORMAT_MESSAGE'
            EXPORTING
              id        = lst_return-id     " Message ID
              lang      = sy-langu          " System Language
              no        = lst_return-number " Message Number
*             v1        = sy-msgv1
*             v2        = sy-msgv2
*             v3        = sy-msgv3
*             v4        = sy-msgv4
            IMPORTING
              msg       = lv_string         " Output Variable
            EXCEPTIONS
              not_found = 1
              OTHERS    = 2.
          IF sy-subrc IS NOT INITIAL.
            CLEAR lv_string.
* Implement suitable error handling here

          ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
            CONCATENATE lv_string
                        'Error in generating the form.'(009)
                   INTO lv_string SEPARATED BY space.
            lst_return-message = lv_string.
          ENDIF. " IF sy-subrc IS NOT INITIAL

          APPEND lst_return TO gt_return.
          CLEAR lst_return.
        ELSE.
** Perform is used to convert PDF in to Binary
          PERFORM f_convert_pdf_binary USING st_formoutput-pdf.

* Popuate the internal table for updating the custom table
          PERFORM f_populate_log_tbl_data USING lst_vbrk-kunrg
                                                lst_vbrk-vkorg
                                                lt_vbeln
                                                lt_remlog
                                                lv_flg_zs.

** Archive the pdf and get the link to store in the custom table
          PERFORM f_archive_form USING lst_vbrk-kunrg
                                       lst_vbrk-vkorg
                                       lst_vbrk-waerk
                                       st_formoutput-pdf.

** Perform to send the email reminder to either to BP / Credit representative
***          IF lv_flg_bp = gc_bp.
***            PERFORM f_send_email_notification USING lv_flg_bp.
***          ENDIF.
          IF lv_flg_zs = gc_zs.  " ZS partner found
            PERFORM f_send_email_notification USING lv_flg_zs
                                                    lt_remlog.
          ENDIF.

*** Save the pdf on application server for the respective Sales Organization
**          PERFORM f_save_pdf_on_app_server USING lst_vbrk-vkorg.

        ENDIF.  " IF v_retcode <> 0.
        IF lv_lock = abap_true.
* Dequeue the customer -releasing lock
          CALL FUNCTION 'DEQUEUE_EXKNA1'
            EXPORTING
              mode_kna1 = 'X'
              mandt     = sy-mandt
              kunnr     = lst_vbrk-kunrg.
        ENDIF.
        CLEAR: lv_tot,       lst_kna1,      lst_fsabe,    v_curr,
               lt_vbrk,      lst_vbrk_tmp,  lst_address,  lv_lock,      v_kunrg,      lt_vbeln, lv_flg_bp,
               v_remit_to,   v_footer1,     v_body,       v_langu,      v_sname,      v_ph_no,  lv_flg_zs,
               v_email_addr, v_crop_duns,   v_bukrs,      v_land1,      v_notif_dat,  lt_vbrk, v_email_id,
               gt_receivers, lt_remlog.
      ENDAT.
      CLEAR: lst_vbrk_tmp, lv_vbeln.
    ENDLOOP.

* Update the custom table for logging purpsoe
    IF gt_remlog IS NOT INITIAL.
      MODIFY zqtc_remlog_f045 FROM TABLE gt_remlog.
    ENDIF.  " IF gt_remlog IS NOT INITIAL.
    IF s_email[] IS NOT INITIAL.
      IF gt_remlog IS NOT INITIAL OR gt_return IS NOT INITIAL.
* Email id is determined, so send the reminder notification with file path details.
        PERFORM f_send_email_notification USING gc_crep
                                                gt_remlog.
      ENDIF.  " IF gt_remlog IS NOT INITIAL OR gt_return IS NOT INITIAL.
    ENDIF. " IF s_email[] IS NOT INITIAL.
    CLEAR gt_remlog.
  ENDIF.
ENDFORM.               " F_PROCESS_DATA
*&---------------------------------------------------------------------*
*&      Form  F_GENERATE_ADOBE_FORM
*&---------------------------------------------------------------------*
*    Generate the pdf form
*----------------------------------------------------------------------*
FORM f_generate_adobe_form USING     fp_lv_kunrg        TYPE kunnr       " Customer Number
                                     fp_lv_vkorg        TYPE vkorg       " Sales Organization
                                     fp_lt_vbrk         TYPE vbrk_tty    " Table type for VBRK
                                     fp_lv_tot          TYPE netwr       " Net Value in Document Currency
                                     fp_st_address      TYPE string      " Address String
                                     fp_lv_retcode      TYPE syst_subrc. " ABAP System Field: Return Code of ABAP Statements

* ****Local data declaration
  DATA: lst_sfpoutputparams TYPE sfpoutputparams,             " Form Processing Output Parameter
        lst_sfpdocparams    TYPE sfpdocparams,                " Form Parameters for Form Processing
        lv_funcname         TYPE funcname,                    " Function name
        lr_err_usg          TYPE REF TO cx_fp_api_usage,      " Exception API (Use)
        lr_err_rep          TYPE REF TO cx_fp_api_repository, " Exception API (Repository)
        lr_err_int          TYPE REF TO cx_fp_api_internal,   " Exception API (Internal)
        lr_text             TYPE string,
        lv_date             TYPE char2,        " Date of type CHAR2
        lv_mnth_c2          TYPE char2,        " Mnthc2 of type CHAR2
        lv_mnth_c3          TYPE char3,        " Mnthc3 of type CHAR3
        lv_month            TYPE t247-ltx,     " Month long text
        lv_year             TYPE char4.        " Year of type CHAR4

  CLEAR: st_formoutput.

**** For direct print without the dialog box
  lst_sfpoutputparams-device   = gc_printer.
  lst_sfpoutputparams-nodialog = abap_true.
  lst_sfpoutputparams-getpdf   = abap_true.

* For Archiving
  APPEND toa_dara TO lst_sfpdocparams-daratab.

****  Change Date format to DD-MMM-YYYY
  CALL FUNCTION 'HR_IN_GET_DATE_COMPONENTS'
    EXPORTING
      idate                         = sy-datum
    IMPORTING
      day                           = lv_date
      month                         = lv_mnth_c2
      year                          = lv_year
      ltext                         = lv_month
    EXCEPTIONS
      input_date_is_initial         = 1
      text_for_month_not_maintained = 2
      OTHERS                        = 3.
  IF sy-subrc EQ 0.
    lv_mnth_c3 = lv_month(3).
    CONCATENATE lv_date
                lv_mnth_c3
                lv_year
           INTO v_datum
    SEPARATED BY '-'.
  ENDIF.

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lst_sfpoutputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc <> 0.
    fp_lv_retcode = 900.
    MESSAGE  e000 WITH 'Error in form display'(006).
    LEAVE LIST-PROCESSING.
  ELSE.
    TRY .
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = gc_frm_name
          IMPORTING
            e_funcname = lv_funcname.

      CATCH cx_fp_api_usage INTO lr_err_usg.
        lr_text = lr_err_usg->get_text( ).
        MESSAGE i006 WITH lr_text.  " An exception occurred  ##MG_MISSING
        LEAVE LIST-PROCESSING.
      CATCH cx_fp_api_repository INTO lr_err_rep.
        lr_text = lr_err_rep->get_text( ).
        MESSAGE i006 WITH lr_text.  " An exception occurred
        LEAVE LIST-PROCESSING.
      CATCH cx_fp_api_internal INTO lr_err_int.
        lr_text = lr_err_int->get_text( ).
        MESSAGE i006 WITH lr_text. " An exception occurred
        LEAVE LIST-PROCESSING.
    ENDTRY.

    IF v_langu IS INITIAL.
* Passing the logon language, if customer language is not determined.
      v_langu = sy-langu.
    ENDIF.

    CALL FUNCTION lv_funcname " '/1BCDWB/SM00000073'
      EXPORTING
        /1bcdwb/docparams  = lst_sfpdocparams
        im_footer1         = v_footer1
        im_body            = v_body
        im_datum           = v_datum
        im_acc_w           = fp_lv_kunrg
        im_remit_to        = v_remit_to
        im_email           = v_email_addr
        im_ph_no           = v_ph_no
        im_sname           = v_sname
        im_corp_duns       = v_crop_duns
        im_tot             = fp_lv_tot
        im_address         = fp_st_address
        im_langu           = v_langu
        im_vbrk            = fp_lt_vbrk
      IMPORTING
        /1bcdwb/formoutput = st_formoutput
      EXCEPTIONS
        usage_error        = 1
        system_error       = 2
        internal_error     = 3
        OTHERS             = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
      fp_lv_retcode = 900.
      MESSAGE  e000 WITH 'Error in form display'(006).
      LEAVE LIST-PROCESSING.
    ELSE.
      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
        fp_lv_retcode = 900.
        MESSAGE  e000 WITH 'Error in form display'(006).
        LEAVE LIST-PROCESSING.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POP_STD_TXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_pop_std_txt  USING   fp_v_land1      TYPE land1
                            fp_v_bukrs      TYPE bukrs
                            fp_v_curr       TYPE waers
                            fp_li_const     TYPE tt_const
                   CHANGING fp_v_body       TYPE thead-tdname
                            fp_v_footer1    TYPE thead-tdname
                            fp_v_remit_to   TYPE thead-tdname
                            fp_v_crop_duns  TYPE thead-tdname.

*******Local Constant declaration
  CONSTANTS: lc_hypen          TYPE char1       VALUE '_',          " Underscore
             lc_footer         TYPE char10      VALUE 'FOOTER_',    " Txtname_part2 of type CHAR6
             lc_body           TYPE char9       VALUE 'FORM_BODY',
             lc_txtname_f045   TYPE char10      VALUE 'ZQTC_F045_', " Txtname_part1 of type CHAR20
             lc_remit_to       TYPE char10      VALUE 'REMIT_TO_',  " Txtname_part2 of type CHAR6
             lc_remit          TYPE char10      VALUE 'REMIT_TO',   " Txtname_part2 of type CHAR6
             lc_tax_vat        TYPE char8       VALUE 'TAX_VAT_',    " Tax_vat of type CHAR8
             lc_remit_pay_inst TYPE char10      VALUE 'PAY_INST', " Remit_pay_inst of type CHAR8
             lc_bank1          TYPE thead-tdname   VALUE 'ZQTC_F045_BANK_DETAILS_1001_USD', "ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
             lc_remit1         TYPE thead-tdname   VALUE 'ZQTC_F045_CHECK_DETAILS_1001_USD'. "ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
* Remit To Address
  READ TABLE fp_li_const WITH KEY devid  = gc_devid
                                  param1 = lc_remit
                                  param2 = lc_remit_pay_inst
                                  low    = fp_v_land1
                                  TRANSPORTING NO FIELDS.
  IF sy-subrc EQ 0.
* Sanctioned Countries Only. Specific remittance for Customers located in:
* Cuba ,Iran, Syria, North Korea, Sudan, Ukraine - common Standard text: ZRTR_F045_REMIT_TO_PAY_INST
    CONCATENATE lc_txtname_f045
                lc_remit_to
                lc_remit_pay_inst
           INTO fp_v_remit_to.
  ELSE. " ELSE -> IF sy-subrc EQ 0
    CONCATENATE lc_txtname_f045
                lc_remit_to
                fp_v_bukrs
                lc_hypen
                fp_v_curr
           INTO fp_v_remit_to.

****  Making TAX id and Crop duns text name dynamic
    CONCATENATE  lc_txtname_f045
                 lc_tax_vat
                 fp_v_bukrs
            INTO fp_v_crop_duns.

  ENDIF. " IF sy-subrc EQ 0
* Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
  READ TABLE gt_vbak_sub INTO DATA(lst_vbak_sub) INDEX 1.
  IF fp_v_bukrs IN r_comp_code AND fp_v_curr IN  r_docu_currency  AND lst_vbak_sub-vkbur IN r_sales_office.
    CLEAR fp_v_remit_to.
    fp_v_remit_to  = lc_bank1.
    CONDENSE fp_v_remit_to NO-GAPS.
  ENDIF.
* End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
***Populate Footer
  CONCATENATE lc_txtname_f045
              lc_footer
              fp_v_bukrs
         INTO fp_v_footer1.

***Populate Form Body
  CONCATENATE lc_txtname_f045
              lc_body
         INTO fp_v_body.

ENDFORM.               " F_POP_STD_TXT
*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANT
*&---------------------------------------------------------------------*
*       Wiley Constants
*----------------------------------------------------------------------*
FORM f_get_constant USING    fp_lc_devid    TYPE char10
                    CHANGING fp_li_constant TYPE tt_const.
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
  CONSTANTS: lc_comp_code     TYPE rvari_vnam VALUE 'COMPANY_CODE',
             lc_docu_currency TYPE rvari_vnam VALUE 'DOCU_CURRENCY',
             lc_sales_office  TYPE rvari_vnam VALUE 'SALES_OFFICE'.
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
  SELECT  devid      " Development ID
          param1     " ABAP: Name of Variant Variable
          param2     " ABAP: Name of Variant Variable
          srno       " ABAP: Current selection number
          sign       " ABAP: ID: I/E (include/exclude values)
          opti       " ABAP: Selection option (EQ/BT/CP/...)
          low        " Lower Value of Selection Condition
          high       " Upper Value of Selection Condition
    FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE fp_li_constant
    WHERE devid = fp_lc_devid
    AND   activate = abap_true.
  IF sy-subrc EQ 0.
    SORT fp_li_constant BY devid param1.
*- Begin of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K913785
    LOOP AT fp_li_constant INTO DATA(lst_constant).
      IF lst_constant-param1 EQ lc_comp_code.
        APPEND INITIAL LINE TO r_comp_code ASSIGNING FIELD-SYMBOL(<lst_comp_code>).
        <lst_comp_code>-sign   = lst_constant-sign.
        <lst_comp_code>-option = lst_constant-opti.
        <lst_comp_code>-low    = lst_constant-low.
        <lst_comp_code>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_docu_currency.
        APPEND INITIAL LINE TO r_docu_currency ASSIGNING FIELD-SYMBOL(<lst_docu_currency>).
        <lst_docu_currency>-sign   = lst_constant-sign.
        <lst_docu_currency>-option = lst_constant-opti.
        <lst_docu_currency>-low    = lst_constant-low.
        <lst_docu_currency>-high   = lst_constant-high.
      ENDIF.
      IF lst_constant-param1 EQ lc_sales_office.
        APPEND INITIAL LINE TO r_sales_office ASSIGNING FIELD-SYMBOL(<lst_sales_office>).
        <lst_sales_office>-sign   = lst_constant-sign.
        <lst_sales_office>-option = lst_constant-opti.
        <lst_sales_office>-low    = lst_constant-low.
        <lst_sales_office>-high   = lst_constant-high.
      ENDIF.
    ENDLOOP.
*- End of ADD:OTCM-51284/FMM-5645:SGUDA:12-Nov-2021:ED1K91378
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.               " F_GET_CONSTANT
*&---------------------------------------------------------------------*
*&      Form  F_CONVERT_PDF_BINARY
*&---------------------------------------------------------------------*
*     Convert the pdf into Binary format
*----------------------------------------------------------------------*
FORM f_convert_pdf_binary  USING pv_formoutput_pdf TYPE fpcontent.

*******CONVERT_PDF_BINARY
  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer     = pv_formoutput_pdf
    TABLES
      binary_tab = st_content_hex.

ENDFORM.               " F_CONVERT_PDF_BINARY
*&---------------------------------------------------------------------*
*&      Form  F_CUSTOMER_ADDRESS
*&---------------------------------------------------------------------*
*      Get the customer address
*----------------------------------------------------------------------*
FORM f_customer_address  USING    pv_kna1_land1 TYPE land1
                                  pv_kna1_adrnr TYPE adrnr
                         CHANGING pv_st_address TYPE string.

  DATA: lt_printform_table TYPE STANDARD TABLE OF szadr_printform_table_line INITIAL SIZE 0,
        lv_line            TYPE string.   " Address line

  CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
    EXPORTING
      address_type            = '1'
      address_number          = pv_kna1_adrnr
      sender_country          = pv_kna1_land1
    IMPORTING
      address_printform_table = lt_printform_table
    EXCEPTIONS
      OTHERS                  = 1.
  IF sy-subrc = 0.
    CLEAR: lv_line.
    LOOP AT lt_printform_table INTO DATA(lst_printform).
      IF lst_printform-address_line IS NOT INITIAL.
        IF lv_line IS INITIAL.
          lv_line = lst_printform-address_line.
        ELSE. " IF lv_line IS INITIAL.
          CONCATENATE lv_line cl_abap_char_utilities=>cr_lf
                      lst_printform-address_line
                 INTO lv_line.
        ENDIF. " IF lv_line IS INITIAL.
      ENDIF. " IF lst_printform-address_line IS NOT INITIAL
    ENDLOOP. " LOOP AT i_printform_table INTO DATA(lst_printform)
    pv_st_address = lv_line.
  ENDIF. " IF sy-subrc = 0

ENDFORM.               " F_CUSTOMER_ADDRESS
*&---------------------------------------------------------------------*
*&      Form  F_GET_CRDT_DEPT_CONT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PV_VBRK_VKORG  text
*      -->PV_KNA1_BUSAB  text
*      <--PV_ST_T001S    text
*      <--PV_ST_FSABE    text
*----------------------------------------------------------------------*
FORM f_get_crdt_dept_cont  USING    pv_vbrk_vkorg TYPE vkorg
                                    pv_kna1_busab TYPE busab
                           CHANGING pv_st_t001s   TYPE t001s
                                    pv_st_fsabe   TYPE fsabe.

  CALL FUNCTION 'CORRESPONDENCE_DATA_BUSAB'
    EXPORTING
      i_bukrs         = pv_vbrk_vkorg
      i_busab         = pv_kna1_busab
      i_langu         = sy-langu
    IMPORTING
      e_t001s         = pv_st_t001s    " Accounting Clerks
      e_fsabe         = pv_st_fsabe    " Accounting Clerk Address Data
    EXCEPTIONS
      busab_not_found = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.               " F_GET_CRDT_DEPT_CONT
*&---------------------------------------------------------------------*
*&      Form  F_SEND_EMAIL_NOTIFICATION
*&---------------------------------------------------------------------*
*     Send email notification to the recepients on the selection screen
*----------------------------------------------------------------------*
FORM f_send_email_notification USING pv_flag   TYPE char3
                                     pt_remlog TYPE tt_remlog.

  CLASS cl_bcs DEFINITION LOAD.
  DATA: lr_send_request   TYPE REF TO cl_bcs VALUE IS INITIAL,
        lx_document_bcs   TYPE REF TO cx_document_bcs VALUE IS INITIAL,
        li_message_body   TYPE STANDARD TABLE OF soli INITIAL SIZE 0,  " "  Message body and subject
        lst_message_body  TYPE soli,
        lr_document       TYPE REF TO cl_document_bcs VALUE IS INITIAL,
        lv_sent_to_all(1) TYPE c VALUE IS INITIAL,
        lr_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL,
        lr_sender         TYPE REF TO if_sender_bcs VALUE IS INITIAL,  "Interface of Sender Object in BCS
        li_lines          TYPE STANDARD TABLE OF tline,                "Lines of text read
        lst_lines         TYPE tline,
        t_hex             TYPE solix_tab,
        lv_times          TYPE sy-tabix,
        lv_bcs_exception  TYPE REF TO cx_bcs,
        lv_msg_text       TYPE string,
        lv_name           TYPE thead-tdname, "  VALUE 'ZRTR_MAIL_BODY_F0XX',   "Name of text to be read
        lv_lin            TYPE sy-index,
        lst_return        TYPE bapiret2, " Return Parameter
        lv_string         TYPE string,   " Variable to store the return message text
        lst_remlog        TYPE zqtc_remlog_f045.

* Local Constant
  CONSTANTS: lc_mail_body TYPE rvari_vnam VALUE 'MAIL_BODY'.    "Parameter1

  TRY.
      lr_send_request = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs.
      "Exception handling not required
  ENDTRY.

*  IF gt_remlog[] IS NOT INITIAL. " Form is generated
  IF pt_remlog[] IS NOT INITIAL. " Form is generated
* Then populate the mail body from the standard text.
* Read constants table for the mail body for F045
    READ TABLE gt_const INTO DATA(lst_const) WITH KEY devid  = gc_devid
                                                      param1 = lc_mail_body.
    IF sy-subrc = 0.
      lv_name = lst_const-low.
    ENDIF.
********FM is used to SAPscript: Read text
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = gc_st
        language                = gc_langu " 'E' OR Customer Language ??
        name                    = lv_name
        object                  = gc_object
      TABLES
        lines                   = li_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc EQ 0.
      LOOP AT li_lines INTO lst_lines.
        REPLACE '&V_DATE&' IN lst_lines-tdline WITH v_date.
        lst_message_body-line = lst_lines-tdline.
        APPEND lst_message_body-line TO li_message_body.
        CLEAR lst_message_body.
      ENDLOOP.
* To append an empty line
      APPEND lst_message_body-line TO li_message_body.
      CLEAR lst_message_body.

      LOOP AT pt_remlog INTO lst_remlog.
        AT NEW zzsorg.

          CONCATENATE 'Sales Org - '(012)
                      ` `
                      lst_remlog-zzsorg
                 INTO lst_message_body-line.
          APPEND lst_message_body-line TO li_message_body.
          CLEAR lst_message_body.

          CONCATENATE 'Business Partners:'(016)
                      ` `
                 INTO lst_message_body-line.
          APPEND lst_message_body-line TO li_message_body.
          CLEAR lst_message_body.
        ENDAT.
        AT END OF zzpayor.
          CONCATENATE lst_message_body-line
                      lst_remlog-zzpayor
                 INTO lst_message_body-line.
          APPEND lst_message_body-line TO li_message_body.
          CLEAR lst_message_body.

        ENDAT.
        AT END OF zzsorg.
* To append an empty line
          APPEND lst_message_body-line TO li_message_body.
          CLEAR lst_message_body.
        ENDAT.
      ENDLOOP.
    ENDIF.
  ENDIF.  " IF pt_remlog[] IS NOT INITIAL.
*
  IF s_email IS NOT INITIAL AND gt_return IS NOT INITIAL.
    IF pv_flag <> gc_zs.
* To append an empty line
      APPEND lst_message_body-line TO li_message_body.
      CLEAR lst_message_body.
* Error messages captured. Then populate the error messages in the email body.
      lst_return-message = 'Errors occurred during processing:'(011).
      lst_message_body-line = lst_return-message.
      APPEND lst_message_body-line TO li_message_body.
      CLEAR lst_message_body.

      LOOP AT gt_return INTO lst_return.
        lst_message_body-line = lst_return-message.
        APPEND lst_message_body-line TO li_message_body.
        CLEAR lst_message_body.
      ENDLOOP.
    ENDIF.
  ENDIF.  " IF gt_return[] IS NOT INITIAL. " Error messages populated
  TRY.
      lr_document = cl_document_bcs=>create_document(
      i_type = gc_raw "lc_raw "'RAW'
      i_text = li_message_body
      i_hex  = t_hex
      i_subject = 'Proforma Reminder Notification'(003) ).
    CATCH cx_document_bcs.
    CATCH cx_send_req_bcs.
      "Exception handling not required
  ENDTRY.

  TRY.
      CALL METHOD lr_send_request->set_document( lr_document ).
    CATCH cx_send_req_bcs.
      "Exception handling not required
  ENDTRY.

***  IF v_email_id IS NOT INITIAL.
**** -------------Attachment------------------------------------*
***    TRY.
***        lr_document->add_attachment(
***        EXPORTING
***        i_attachment_type    = gc_pdf "'PDF'
***        i_attachment_subject = 'Advance Payment Reminder'(010)
***        i_att_content_hex    = st_content_hex ).
***      CATCH cx_document_bcs INTO lx_document_bcs.
***        "Exception handling not required
***    ENDTRY.
***  ENDIF.
* Pass the document to send request
  TRY.
      lr_send_request->set_document( lr_document ).
* Create sender
      lr_sender = cl_sapuser_bcs=>create( sy-uname ).
* Set sender
      lr_send_request->set_sender(
      EXPORTING
      i_sender = lr_sender ).
    CATCH cx_address_bcs.
    CATCH cx_send_req_bcs.
      "Exception handling not required
  ENDTRY.

  FIELD-SYMBOLS: <lv_email> TYPE any.
  FIELD-SYMBOLS: <fld> TYPE any.
***  IF pv_flag = gc_bp AND v_email_id IS NOT INITIAL.
***    TRY.
***        lr_recipient = cl_cam_address_bcs=>create_internet_address( v_email_id ). "Here Recipient is email input s_email
*****Catch exception here
***      CATCH cx_address_bcs  INTO lv_bcs_exception.
***        lv_msg_text = lv_bcs_exception->get_text( ).
***        MESSAGE lv_msg_text TYPE 'I'.
***    ENDTRY.
***
***    TRY.
***        lr_send_request->add_recipient(
***        EXPORTING
***        i_recipient = lr_recipient
***        i_express = 'X' ).
*****Catch exception here
***      CATCH cx_send_req_bcs INTO lv_bcs_exception.
***        lv_msg_text = lv_bcs_exception->get_text( ).
***        MESSAGE lv_msg_text TYPE 'I'.
***    ENDTRY.
***    ENDIF.
  IF pv_flag = gc_zs AND gt_receivers IS NOT INITIAL.
    CLEAR lv_times.
** Create recipient(s)
    DESCRIBE TABLE gt_receivers LINES lv_times.
    IF lv_times > 0.

      DO lv_times TIMES.
        READ TABLE gt_receivers INDEX sy-index ASSIGNING <lv_email>  .
**        IF <lv_email> IS ASSIGNED.
**          ASSIGN COMPONENT 'LOW' OF STRUCTURE <lv_email> TO <fld>.
**        ENDIF.
        TRY.
            lr_recipient = cl_cam_address_bcs=>create_internet_address( <lv_email> ). "Here Recipient is email input s_email
**Catch exception here
          CATCH cx_address_bcs  INTO lv_bcs_exception.
            lv_msg_text = lv_bcs_exception->get_text( ).
            MESSAGE lv_msg_text TYPE 'I'.
        ENDTRY.

        TRY.
            lr_send_request->add_recipient(
            EXPORTING
            i_recipient = lr_recipient
            i_express = 'X' ).
**Catch exception here
          CATCH cx_send_req_bcs INTO lv_bcs_exception.
            lv_msg_text = lv_bcs_exception->get_text( ).
            MESSAGE lv_msg_text TYPE 'I'.
        ENDTRY.
      ENDDO.
    ENDIF.  " IF lv_times > 0.
*  ENDIF.
  ELSE.
* The email should go to the users on selection screen if it is maintained and different from ZS partner
    CLEAR lv_times.
** Create recipient(s)
    DESCRIBE TABLE s_email LINES lv_times.
    IF lv_times > 0.

      DO lv_times TIMES.
        READ TABLE s_email INDEX sy-index ASSIGNING <lv_email>  .
        IF <lv_email> IS ASSIGNED.
          ASSIGN COMPONENT 'LOW' OF STRUCTURE <lv_email> TO <fld>.
        ENDIF.
        TRY.
            lr_recipient = cl_cam_address_bcs=>create_internet_address( <fld> ). "Here Recipient is email input s_email
**Catch exception here
          CATCH cx_address_bcs  INTO lv_bcs_exception.
            lv_msg_text = lv_bcs_exception->get_text( ).
            MESSAGE lv_msg_text TYPE 'I'.
        ENDTRY.

        TRY.
            lr_send_request->add_recipient(
            EXPORTING
            i_recipient = lr_recipient
            i_express = 'X' ).
**Catch exception here
          CATCH cx_send_req_bcs INTO lv_bcs_exception.
            lv_msg_text = lv_bcs_exception->get_text( ).
            MESSAGE lv_msg_text TYPE 'I'.
        ENDTRY.
      ENDDO.
    ELSE.
*    lst_return-type    = gc_suc. " 'S'
*    lst_return-id      = gc_msg_cls. " Message class = ZQTC_R2
*    lst_return-number  = gc_msgno. "000
*
*    CLEAR lv_string.
** Call FM to form message to display while updation is successful or errorneous.
*    CALL FUNCTION 'FORMAT_MESSAGE'
*      EXPORTING
*        id        = lst_return-id     " Message ID
*        lang      = sy-langu          " System Language
*        no        = lst_return-number " Message Number
*      IMPORTING
*        msg       = lv_string         " Output Variable
*      EXCEPTIONS
*        not_found = 1
*        OTHERS    = 2.
*    IF sy-subrc IS NOT INITIAL.
*      CLEAR lv_string.
** Implement suitable error handling here
*
*    ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
*      CONCATENATE lv_string
*                  'Notification is not sent successfully.'(007)
*             INTO lv_string SEPARATED BY space.
*      lst_return-message = lv_string.
*    ENDIF. " IF sy-subrc IS NOT INITIAL
*
*    APPEND lst_return TO gt_return.
*    CLEAR lst_return.
    ENDIF.
  ENDIF.
* Send email
  TRY.
      lr_send_request->send(
      EXPORTING
      i_with_error_screen = abap_true
      RECEIVING
      result = lv_sent_to_all ).
      COMMIT WORK.
      MESSAGE s000 WITH 'Notification sent successfully.'(008).
    CATCH cx_send_req_bcs INTO lv_bcs_exception.
      lv_msg_text = lv_bcs_exception->get_text( ).
      MESSAGE lv_msg_text TYPE 'I'.
  ENDTRY.

ENDFORM.               " F_SEND_EMAIL_NOTIFICATION
****&---------------------------------------------------------------------*
****&      Form  F_SAVE_PDF_ON_APP_SERVER
****&---------------------------------------------------------------------*
****      Storing the binary pdf file on application server
****----------------------------------------------------------------------*
***FORM f_save_pdf_on_app_server USING pv_vkorg TYPE vkorg.
*******  Local Data declarations
***  DATA:
***    lv_pdf       TYPE xstring,
***    lv_filename  TYPE char128,      " Filename of type CHAR50
***    lv_directory TYPE string,
***    lst_const    TYPE ty_const,
***    lv_subrc     TYPE syst_subrc,
*****    lv_filename_1  TYPE  file_name,
*****    lv_path_1      TYPE  pathextern,
***    lv_pattern   TYPE  char20,
*****    lv_zipfilename TYPE  string,
***    lst_return   TYPE bapiret2, " Return Parameter
***    lv_string    TYPE string.   " Variable to store the return message text
***
*******    Local Contants declaration
***  CONSTANTS: lc_slash           TYPE char1  VALUE '/',        " Slash of type CHAR1
***             lc_underscr        TYPE char1  VALUE '_',        " Underscr of type CHAR1
***             lc_pdf             TYPE char4  VALUE '.pdf',     " Pdf of type CHAR4
***             lc_fpath           TYPE char8  VALUE 'FILEPATH', " File Path on application server
***             lc_reminder        TYPE char8  VALUE 'REMINDER', " Renew of type CHAR7
***             lc_form_identifier TYPE char10 VALUE 'F045'.
***
***  lv_pdf = st_formoutput-pdf.  " PDF Binary string
***
**** Read the file path from the constants table for F045
***  READ TABLE gt_const INTO lst_const WITH KEY devid   = lc_form_identifier
***                                              param1  = lc_fpath
***                                              param2 =  pv_vkorg.
***  IF sy-subrc = 0.
***    lv_directory = lst_const-low.
***  ENDIF.
***
*******  Populate Filenames as per naming convention
***  IF lv_pdf IS NOT INITIAL.
***
***    CLEAR: lv_filename.
***
***    CONCATENATE lc_reminder
***                v_kunrg
***                sy-datum
***                sy-uzeit
***                v_bukrs
***                v_curr
***          INTO lv_filename
***          SEPARATED BY lc_underscr.
***
***    IF lv_filename IS NOT INITIAL.
***      CONCATENATE  lv_directory
***                   lc_slash
***                   lv_filename
***                   lc_pdf
***              INTO v_filepath.
***
******* Open Folder and save Files in Application server
***      IF v_filepath IS NOT INITIAL.
***        OPEN DATASET v_filepath FOR OUTPUT IN BINARY MODE. " Set as Ready for Input
***        IF sy-subrc NE 0.
***          lst_return-type    = gc_err. " 'E'
***          lst_return-id      = gc_msg_cls. " Message class = ZQTC_R2
***          lst_return-number  = gc_msgno. "000
***
***          CLEAR lv_string.
**** Call FM to form message to display while updation is successful or errorneous.
***          CALL FUNCTION 'FORMAT_MESSAGE'
***            EXPORTING
***              id        = lst_return-id     " Message ID
***              lang      = sy-langu          " System Language
***              no        = lst_return-number " Message Number
****             v1        = sy-msgv1
****             v2        = sy-msgv2
****             v3        = sy-msgv3
****             v4        = sy-msgv4
***            IMPORTING
***              msg       = lv_string         " Output Variable
***            EXCEPTIONS
***              not_found = 1
***              OTHERS    = 2.
***          IF sy-subrc IS NOT INITIAL.
***            CLEAR lv_string.
**** Implement suitable error handling here
***
***          ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
***            CONCATENATE lv_string
***                        'Unable to open file.'(005)
***                   INTO lv_string SEPARATED BY space.
***            lst_return-message = lv_string.
***          ENDIF. " IF sy-subrc IS NOT INITIAL
***
***          APPEND lst_return TO gt_return.
***          CLEAR lst_return.
***        ELSE. " ELSE -> IF sy-subrc NE 0
***          TRANSFER lv_pdf TO v_filepath. "im_fpformoutput-pdf
***          CLOSE DATASET v_filepath.
***        ENDIF. " IF sy-subrc NE 0
***      ENDIF. " IF lv_filepath IS NOT INITIAL
***    ENDIF. " IF lv_filename IS NOT INITIAL
***  ENDIF. " IF lv_pdf IS NOT INITIAL
***ENDFORM.              " F_SAVE_PDF_ON_APP_SERVER
*&---------------------------------------------------------------------*
*&      Form  F_ARCHIVE_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FP_LV_KUNRG  text
*      -->FP_FORM_PDF  text
*----------------------------------------------------------------------*
FORM f_archive_form  USING fp_lv_kunrg TYPE kunnr
                           fp_lv_vkorg TYPE vkorg
                           fp_lv_curr  TYPE waers
                           fp_form_pdf TYPE fpcontent.

* Local Work area & variable declaration
  DATA : lst_return TYPE bapiret2, " Return Parameter
         lv_string  TYPE string.   " Variable to store the return message text

  CALL FUNCTION 'ZQTCR_REMINDER_ARCHIVE'
    EXPORTING
      iv_partner               = fp_lv_kunrg
      iv_document              = fp_form_pdf
      iv_commit                = abap_true  " lv_comt_flg
    EXCEPTIONS
      error_archiv             = 1
      error_communicationtable = 2
      error_connectiontable    = 3
      error_kernel             = 4
      error_parameter          = 5
      error_format             = 6
      blocked_by_policy        = 7
      bp_not_found             = 8
      not_valid_document       = 9
      OTHERS                   = 10.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN 8.
        lst_return-type    = gc_err.     " 'E'
        lst_return-id      = gc_msg_cls. " Message class = ZQTC_R2
        lst_return-number  = gc_msgno.   " 000

        CLEAR lv_string.
* Call FM to form message to display while updation is successful or errorneous.
        CALL FUNCTION 'FORMAT_MESSAGE'
          EXPORTING
            id        = lst_return-id     " Message ID
            lang      = sy-langu          " System Language
            no        = lst_return-number " Message Number
          IMPORTING
            msg       = lv_string         " Output Variable
          EXCEPTIONS
            not_found = 1
            OTHERS    = 2.
        IF sy-subrc IS NOT INITIAL.
          CLEAR lv_string.
        ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
          CONCATENATE lv_string
                      fp_lv_kunrg
                      '/'
                      fp_lv_vkorg
                      '/'
                      fp_lv_curr
                      ':'
                      ` `
                      'BP_NOT_FOUND'(018)
                 INTO lst_return-message.
        ENDIF. " IF sy-subrc IS NOT INITIAL

        APPEND lst_return TO gt_return.
        CLEAR lst_return.
      WHEN 9.
        lst_return-type    = gc_err.     " 'E'
        lst_return-id      = gc_msg_cls. " Message class = ZQTC_R2
        lst_return-number  = gc_msgno.   " 000

        CLEAR lv_string.
* Call FM to form message to display while updation is successful or errorneous.
        CALL FUNCTION 'FORMAT_MESSAGE'
          EXPORTING
            id        = lst_return-id     " Message ID
            lang      = sy-langu          " System Language
            no        = lst_return-number " Message Number
          IMPORTING
            msg       = lv_string         " Output Variable
          EXCEPTIONS
            not_found = 1
            OTHERS    = 2.
        IF sy-subrc IS NOT INITIAL.
          CLEAR lv_string.
        ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL
          CONCATENATE lv_string
                      fp_lv_kunrg
                      '/'
                      fp_lv_vkorg
                      '/'
                      fp_lv_curr
                      ':'
                      ` `
                      'NOT_VALID_DOCUMENT'(017)
                 INTO lst_return-message.
        ENDIF. " IF sy-subrc IS NOT INITIAL

        APPEND lst_return TO gt_return.
        CLEAR lst_return.
      WHEN OTHERS.
    ENDCASE.

  ENDIF.
ENDFORM.               " F_ARCHIVE_FORM
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_LOG_TBL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PV_KUNRG  text
*      -->PV_VBELN  text
*----------------------------------------------------------------------*
FORM f_populate_log_tbl_data  USING pv_kunrg  TYPE kunnr
                                    pv_vkorg  TYPE vkorg
                                    pt_vbeln  TYPE tt_vbeln
                                    pt_remlog TYPE tt_remlog
                                    pv_flag   TYPE char3.

  DATA: lst_remlog TYPE zqtc_remlog_f045,
        lv_vbeln   TYPE vbeln.

  IF pv_flag = gc_zs.
    LOOP AT pt_vbeln INTO lv_vbeln.
      lst_remlog-zzsorg     = pv_vkorg.
      lst_remlog-zzpayor    = pv_kunrg.
      lst_remlog-zzproforma = lv_vbeln.
      lst_remlog-zzrun_date = sy-datum.
      lst_remlog-zzrun_time = sy-uzeit.
      lst_remlog-zzrun_by   = sy-uname.
      lst_remlog-zzrun_date = sy-datum.
      APPEND lst_remlog TO pt_remlog.
      CLEAR lst_remlog.
    ENDLOOP.
    SORT pt_remlog BY zzsorg zzpayor.
  ENDIF.

  LOOP AT pt_vbeln INTO lv_vbeln.
    lst_remlog-zzsorg     = pv_vkorg.
    lst_remlog-zzpayor    = pv_kunrg.
    lst_remlog-zzproforma = lv_vbeln.
    lst_remlog-zzrun_date = sy-datum.
    lst_remlog-zzrun_time = sy-uzeit.
    lst_remlog-zzrun_by   = sy-uname.
    lst_remlog-zzrun_date = sy-datum.
    APPEND lst_remlog TO gt_remlog.
    CLEAR lst_remlog.
  ENDLOOP.
  SORT gt_remlog BY zzsorg zzpayor.
*  ENDIF.
ENDFORM.               " F_POPULATE_LOG_TBL_DATA
*&---------------------------------------------------------------------*
*&      Form  F_VAL_FKDAT
*&---------------------------------------------------------------------*
*   Validate Billing Date range
*----------------------------------------------------------------------*
FORM f_val_fkdat.
  DATA: " lr_fkdat  TYPE    tdt_rg_fkdat,
    lst_fkdat TYPE    tds_rg_fkdat,
    lv_date   TYPE    fkdat.

  IF sy-batch = abap_false.

  ELSE.
* For background job run - determine the date range dynamically
    CLEAR s_fkdat[]. " The date range should be populated dynamically

* Calculate the date range to pick the profromas in this range
    lst_fkdat-sign   = gc_sign_i.
    lst_fkdat-option = gc_opti_bt.   " 'BT'.

    lv_date = sy-datum - 30.
    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = sy-datum
        days      = gc_days     " 00
        months    = gc_month    " 00
        years     = gc_year     " 01
        signum    = gc_signum   " '-'
      IMPORTING
        calc_date = lst_fkdat-low.

    lst_fkdat-high    = sy-datum.
    APPEND lst_fkdat TO s_fkdat.
  ENDIF.  " IF sy-batch = abap_false.
ENDFORM.               " F_VAL_FKDAT
*&---------------------------------------------------------------------*
*&      Form  F_VAL_KUNRG
*&---------------------------------------------------------------------*
*   Add validation logic for Payee number(KUNRG) in Selection screen.
*----------------------------------------------------------------------*
FORM f_val_kunrg.
  DATA: lv_kunnr TYPE kunnr.

* Validating Payer Number.
  IF NOT s_kunrg[] IS INITIAL.
    SELECT kunnr " Customer Number
           UP TO 1 ROWS FROM kna1
           INTO lv_kunnr
           WHERE kunnr IN s_kunrg[].
    ENDSELECT.
    IF sy-subrc <> 0.
      MESSAGE e011(zqtc_r2). " Invalid Payer Number!
    ENDIF.
  ENDIF.
ENDFORM.               " F_VAL_KUNRG
*&---------------------------------------------------------------------*
*&      Form  F_VAL_DOCTYPE
*&---------------------------------------------------------------------*
*       Validate Billing Type
*----------------------------------------------------------------------*
FORM f_val_doctype .
  IF s_fkart IS NOT INITIAL.
    SELECT fkart
      INTO @DATA(lv_fkart)
      FROM tvfk    " Billing: Document Types
      UP TO 1 ROWS
      WHERE fkart IN @s_fkart.
    ENDSELECT.
    IF sy-subrc NE 0.
      MESSAGE e009(zqtc_r2). " Invalid Billing Type!
    ENDIF.
  ENDIF.
ENDFORM.               " F_VAL_DOCTYPE
*&---------------------------------------------------------------------*
*&      Form  F_VAL_PROFORMA
*&---------------------------------------------------------------------*
*  Add validation logic for Billing Document Number(VBELN) in Selection
*  screen.
*----------------------------------------------------------------------*
FORM f_val_proforma .
  DATA: v_vbeln    TYPE vbrk-vbeln.                  "Variable for Proforma
  IF s_vbeln[] IS NOT INITIAL.
    SELECT SINGLE vbeln
      FROM  vbrk       " Billing Document: Header Data
      INTO  v_vbeln
      WHERE vbeln IN s_vbeln.
    IF sy-subrc NE 0.
      MESSAGE e008(zqtc_r2). " Invalid Billing Document number!
    ENDIF.  " IF sy-subrc NE 0.
  ENDIF.
ENDFORM.               " F_VAL_PROFORMA
*&---------------------------------------------------------------------*
*&      Form  F_VAL_SALESORG
*&---------------------------------------------------------------------*
*       Validate Sales Org
*----------------------------------------------------------------------*
FORM f_val_salesorg .

  IF s_vkorg IS INITIAL.
    RETURN.
  ENDIF. " IF s_vkorg[] IS INITIAL

* Organizational Unit: Sales Organizations
  SELECT vkorg " Sales Organization
    FROM tvko  " Organizational Unit: Sales Organizations
    INTO @DATA(lv_vkorg)
   WHERE vkorg IN @s_vkorg.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e012(zqtc_r2). " Invalid Sales Organization Number!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.               " F_VAL_SALESORG
*&---------------------------------------------------------------------*
*&      Form  F_DETERMINE_RECEIVERS
*&---------------------------------------------------------------------*
*     Determine the receivers list for the email notification
*----------------------------------------------------------------------*
FORM f_determine_receivers  USING    pv_kunrg     TYPE kunrg
                                     pv_vkorg     TYPE vkorg
                                     pv_adrnr     TYPE ad_addrnum
                            CHANGING pt_receivers TYPE bcsy_smtpa
                                     pv_flg_zs    TYPE char3.

  DATA: lv_email_id TYPE ad_smtpadr,   " E-Mail Address
        lv_emails   TYPE string.

  IF pt_receivers IS INITIAL.
* If the email ID of BP is not found or if the mode of BP communication is not ' Email', then go for ZS partner.
    CALL FUNCTION 'ZRTR_DET_CUSTOMER_EMAILS'
      EXPORTING
        im_v_kunnr             = pv_kunrg  " Business Partner
        im_v_bukrs             = pv_vkorg  " Company Code
        im_v_adrnr             = pv_adrnr  " Address Number
*        im_v_deflt             = abap_true
      IMPORTING
        ex_t_emails            = pt_receivers
      EXCEPTIONS
        exc_address_no_missing = 1
        OTHERS                 = 2.
    IF sy-subrc = 0 AND pt_receivers IS NOT INITIAL.
      pv_flg_zs  = gc_zs.
    ELSE.
* Implement suitable error handling here
    ENDIF.
  ENDIF.  " IF pt_receivers IS INITIAL.

ENDFORM.
