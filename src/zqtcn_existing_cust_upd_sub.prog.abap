*&---------------------------------------------------------------------*
*&  Include           ZQTCN_EXISTING_CUST_UPD_SUB
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:       ZQTCC_EXISTING_CUST_UPDATE
* PROGRAM DESCRIPTION:Report for customer update
* DEVELOPER:          WROY(Writtick Roy)
* CREATION DATE:      12/16/2016
* OBJECT ID:          C076
* TRANSPORT NUMBER(S):ED2K903796
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906076
* REFERENCE NO: CR# 471/472
* DEVELOPER: Writtick Roy
* DATE:  2017-05-15
* DESCRIPTION: 1. Address Line Design Change,
*              2. Communication Method Update
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906630
* REFERENCE NO: ERP-2723
* DEVELOPER: Writtick Roy
* DATE:  2017-06-09
* DESCRIPTION: 1. Handle situation when Remark is not maintained
*              2. Don't populate Name Fields
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K908333
* REFERENCE NO: ERP-3938
* DEVELOPER: Writtick Roy
* DATE:  2017-09-02
* DESCRIPTION: 1. Populate Attribute 10 if the Customer is being
*                 updated, so that its not being picked subsequently
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_DEFAULTS
*&---------------------------------------------------------------------*
*       Populate Selection Screen Default Values
*----------------------------------------------------------------------*
*      <--FP_S_ERDAT  Creation Date
*      <--FP_S_KTOKD  Customer Account Group
*      <--FP_P_AKONT  Reconciliation Account in General Ledger
*      <--FP_P_VTWEG  Distribution Channel
*      <--FP_P_SPART  Division
*      <--FP_P_LIFSD  Delivery Block
*      <--FP_P_FAKSD  Billing Block
*      <--FP_S_IDTYP  Identification Type
*----------------------------------------------------------------------*
FORM f_populate_defaults  CHANGING fp_s_erdat TYPE fip_t_erdat_range
                                   fp_s_ktokd TYPE tt_ktokd_rng
                                   fp_p_akont TYPE akont
                                   fp_p_vtweg TYPE vtweg
                                   fp_p_spart TYPE spart
                                   fp_p_lifsd TYPE lifsd_v
                                   fp_p_faksd TYPE faksd_v
                                   fp_s_idtyp TYPE tt_idtyp_rng.

* Material Type (Media Issue)
  APPEND INITIAL LINE TO fp_s_erdat ASSIGNING FIELD-SYMBOL(<lst_erdat>).
  <lst_erdat>-sign   = c_sign_incld.                            "Sign: (I)nclude
  <lst_erdat>-option = c_opti_ls_eq.                            "Option: (L)ess or (E)qual
  <lst_erdat>-low    = sy-datum - 7.                            "Material Type: ZJIP
* Customer Account Group
  APPEND INITIAL LINE TO fp_s_ktokd ASSIGNING FIELD-SYMBOL(<lst_ktokd>).
  <lst_ktokd>-sign   = c_sign_incld.                            "Sign: (I)nclude
  <lst_ktokd>-option = c_opti_equal.                            "Option: (EQ)ual
  <lst_ktokd>-low    = c_acc_grp_1.                             "Cust Acc Group: 0001 (Sold-to Party).

  fp_p_akont = c_recon_acc.                                     "Reconciliation Account in General Ledger
  fp_p_vtweg = c_dist_ch_00.                                    "Distribution Channel: 00
  fp_p_spart = c_divsn_00.                                      "Division: 00
  fp_p_lifsd = c_del_blk_r1.                                    "Delivery Block: R1
  fp_p_faksd = c_bil_blk_r1.                                    "Billing Block: R1

* Identification Type
  APPEND INITIAL LINE TO fp_s_idtyp ASSIGNING FIELD-SYMBOL(<lst_idtyp>).
  <lst_idtyp>-sign   = c_sign_incld.                            "Sign: (I)nclude
  <lst_idtyp>-option = c_opti_equal.                            "Option: (EQ)ual
  <lst_idtyp>-low    = c_idtyp_jc.                              "Identification Type: JCORE
  APPEND INITIAL LINE TO fp_s_idtyp ASSIGNING <lst_idtyp>.
  <lst_idtyp>-sign   = c_sign_incld.                            "Sign: (I)nclude
  <lst_idtyp>-option = c_opti_equal.                            "Option: (EQ)ual
  <lst_idtyp>-low    = c_idtyp_ec.                              "Identification Type: ECORE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_FETCH_N_PROCESS
*&---------------------------------------------------------------------*
*       Fetch and Process Records
*----------------------------------------------------------------------*
*      -->FP_S_LAND1  Countries
*      -->FP_P_WAERS  Currency Key
*      -->FP_P_BUKRS  Company Code
*      -->FP_S_ERDAT  Creation Date
*      -->FP_S_KTOKD  Customer Account Group
*      -->FP_S_KUNNR  Customer Numbers
*      -->FP_P_AKONT  Reconciliation Account in General Ledger
*      -->FP_P_VTWEG  Distribution Channel
*      -->FP_P_SPART  Division
*      -->FP_P_LIFSD  Delivery Block
*      -->FP_P_FAKSD  Billing Block
*      -->FP_S_IDTYP  Identification Type
*----------------------------------------------------------------------*
FORM f_fetch_n_process  USING    fp_s_land1 TYPE shp_land1_range_t
                                 fp_p_waers TYPE waers
                                 fp_p_bukrs TYPE bukrs
                                 fp_s_erdat TYPE fip_t_erdat_range
                                 fp_s_ktokd TYPE tt_ktokd_rng
                                 fp_s_kunnr TYPE farr_rt_rai_kunnr
                                 fp_p_akont TYPE akont
                                 fp_p_vtweg TYPE vtweg
                                 fp_p_spart TYPE spart
                                 fp_p_lifsd TYPE lifsd_v
                                 fp_p_faksd TYPE faksd_v
                                 fp_s_idtyp TYPE tt_idtyp_rng.

  DATA:
    lst_addr_uns TYPE sx_address.                               "SAPconnect general address

* Fetch General Data in Customer Master
  SELECT kunnr,                                                 "Customer Number
         land1,                                                 "Country Key
         adrnr,                                                 "Address Number
         ktokd                                                  "Customer Account Group
    FROM kna1
    INTO TABLE @DATA(li_kna1)
   WHERE kunnr IN @fp_s_kunnr
     AND erdat IN @fp_s_erdat
     AND ktokd IN @fp_s_ktokd
     AND land1 IN @fp_s_land1
*    Begin of ADD:ERP-3938:WROY:02-SEP-2017:ED2K908333
     AND katr10 EQ @space.
*    End   of ADD:ERP-3938:WROY:02-SEP-2017:ED2K908333
  IF sy-subrc EQ 0.
    SORT  li_kna1 BY kunnr.
  ELSE.
*   Message: No data records found for the specified selection criteria
    MESSAGE i004(wrf_at_generate).
    LEAVE LIST-PROCESSING.
  ENDIF.

* BP: General data
  SELECT partner,                                               "Business Partner Number
         type,                                                  "Business partner category
         name_org1,                                             "Name 1 of organization
         name_org2,                                             "Name 2 of organization
         name_last,                                             "Last name of business partner (person)
         name_first                                             "First name of business partner (person)
    FROM but000
    INTO TABLE @DATA(li_but000)
     FOR ALL ENTRIES IN @li_kna1
   WHERE partner EQ @li_kna1-kunnr.
  IF sy-subrc EQ 0.
    SORT li_but000 BY partner.
  ENDIF.

* Fetch Customer Master (Company Code)
  SELECT kunnr,                                                 "Customer Number
         bukrs                                                  "Company Code
    FROM knb1
    INTO TABLE @DATA(li_knb1)
     FOR ALL ENTRIES IN @li_kna1
   WHERE kunnr EQ @li_kna1-kunnr
     AND bukrs EQ @fp_p_bukrs.
  IF sy-subrc EQ 0.
    SORT li_knb1 BY kunnr.
  ENDIF.

* Fetch Customer Master (Company Code)
  SELECT kunnr,                                                 "Customer Number
         vkorg,                                                 "Sales Organization
         vtweg,                                                 "Distribution Channel
         spart                                                  "Division
    FROM knvv
    INTO TABLE @DATA(li_knvv)
     FOR ALL ENTRIES IN @li_kna1
   WHERE kunnr EQ @li_kna1-kunnr
     AND vkorg EQ @fp_p_bukrs
     AND vtweg EQ @fp_p_vtweg
     AND spart EQ @fp_p_spart.
  IF sy-subrc EQ 0.
    SORT li_knvv BY kunnr.
  ENDIF.

* Fetch Addresses (Business Address Services)
* Begin of DEL:CR#471/472:WROY:15-MAY-2017:ED2K906076
* SELECT addrnumber,                                            "Address number
*        name1,                                                 "Name 1
*        name2,                                                 "Name 2
*        post_code1                                             "City postal code
*   FROM adrc
*   INTO TABLE @DATA(li_adrc)
*    FOR ALL ENTRIES IN @li_kna1
*  WHERE addrnumber EQ @li_kna1-adrnr
*    AND date_from  LE @sy-datum
*    AND date_to    GE @sy-datum.
* End   of DEL:CR#471/472:WROY:15-MAY-2017:ED2K906076
* Begin of ADD:CR#471/472:WROY:15-MAY-2017:ED2K906076
  SELECT adrc~addrnumber,                                       "Address number
         adrc~name1,                                            "Name 1
         adrc~name2,                                            "Name 2
         adrc~post_code1,                                       "City postal code
         adrc~street,                                           "Street
         adrc~str_suppl1,                                       "Street 2
         adrc~str_suppl2,                                       "Street 3
         adrc~str_suppl3,                                       "Street 4
         adrc~location,                                         "Street 5
         adrct~remark                                           "Address notes
* Begin of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630
    FROM adrc LEFT OUTER JOIN adrct
* End   of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630
* Begin of DEL:ERP-2723:WROY:09-JUN-2017:ED2K906630
*   FROM adrc INNER JOIN adrct
* End   of DEL:ERP-2723:WROY:09-JUN-2017:ED2K906630
      ON adrct~addrnumber EQ adrc~addrnumber
     AND adrct~date_from  EQ adrc~date_from
     AND adrct~nation     EQ adrc~nation
* Begin of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630
     AND adrct~langu      EQ @sy-langu
* End   of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630
    INTO TABLE @DATA(li_adrc)
     FOR ALL ENTRIES IN @li_kna1
   WHERE adrc~addrnumber EQ @li_kna1-adrnr
     AND adrc~date_from  LE @sy-datum
     AND adrc~date_to    GE @sy-datum.
* Begin of DEL:ERP-2723:WROY:09-JUN-2017:ED2K906630
*    AND adrct~langu     EQ @sy-langu.
* End   of DEL:ERP-2723:WROY:09-JUN-2017:ED2K906630
* End   of ADD:CR#471/472:WROY:15-MAY-2017:ED2K906076
  IF sy-subrc EQ 0.
    SORT li_adrc BY addrnumber.
  ENDIF.

* Begin of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630
  SELECT addrnumber,                                            "Address number
         persnumber,                                            "Person number
         date_from,                                             "Valid-from date - in current Release only 00010101 possible
         consnumber,                                            "Sequence Number
         smtp_addr                                              "E-Mail Address
    FROM adr6
    INTO TABLE @DATA(li_email_ids)
     FOR ALL ENTRIES IN @li_kna1
   WHERE addrnumber EQ @li_kna1-adrnr
     AND date_from  LE @sy-datum.
  IF sy-subrc EQ 0.
    DELETE li_email_ids WHERE smtp_addr IS INITIAL.
    SORT li_email_ids BY addrnumber.
  ENDIF.
* End   of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630

* Fetch BP: ID Numbers
  SELECT partner                                                "Business Partner Number
    FROM but0id
    INTO TABLE @DATA(li_but0id)
     FOR ALL ENTRIES IN @li_kna1
   WHERE partner EQ @li_kna1-kunnr
     AND type    IN @fp_s_idtyp.
  IF sy-subrc EQ 0.
    SORT li_but0id BY partner.
  ENDIF.

  LOOP AT li_kna1 ASSIGNING FIELD-SYMBOL(<lst_kna1>).
    APPEND INITIAL LINE TO i_report_op ASSIGNING FIELD-SYMBOL(<lst_rep_op>).
    <lst_rep_op>-kunnr = <lst_kna1>-kunnr.                      "Customer Number
    <lst_rep_op>-land1 = <lst_kna1>-land1.                      "Country Key
    <lst_rep_op>-ktokd = <lst_kna1>-ktokd.                      "Customer Account Group

    READ TABLE li_but000 ASSIGNING FIELD-SYMBOL(<lst_but000>)
         WITH KEY partner = <lst_kna1>-kunnr
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      CASE <lst_but000>-type.
        WHEN c_category_p.                                      "Business partner category: Person
*         Begin of DEL:ERP-2723:WROY:09-JUN-2017:ED2K906630
*         <lst_rep_op>-name1 = <lst_but000>-name_first.         "Name 1 (First name of business partner)
*         <lst_rep_op>-name2 = <lst_but000>-name_last.          "Name 2 (Last name of business partner)
*         <lst_rep_op>-sort1 = <lst_rep_op>-name2.              "Search Term 1
*         End   of DEL:ERP-2723:WROY:09-JUN-2017:ED2K906630
*         Begin of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630
          <lst_rep_op>-sort1 = <lst_but000>-name_last.          "Search Term 1
*         End   of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630
        WHEN c_category_o.                                      "Business partner category: Organization
*         Begin of DEL:ERP-2723:WROY:09-JUN-2017:ED2K906630
*         <lst_rep_op>-name1 = <lst_but000>-name_org1.          "Name 1 (Name 1 of organization)
*         <lst_rep_op>-name2 = <lst_but000>-name_org2.          "Name 2 (Name 1 of organization)
*         <lst_rep_op>-sort1 = <lst_rep_op>-name1.              "Search Term 1
*         End   of DEL:ERP-2723:WROY:09-JUN-2017:ED2K906630
*         Begin of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630
          <lst_rep_op>-sort1 = <lst_but000>-name_org1.          "Search Term 1
*         End   of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630
        WHEN OTHERS.
*         Nothing to do
      ENDCASE.
    ENDIF.

*   Get Address Details
    READ TABLE li_adrc ASSIGNING FIELD-SYMBOL(<lst_adrc>)
         WITH KEY addrnumber = <lst_kna1>-adrnr
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      IF <lst_rep_op>-sort1 IS INITIAL.
        <lst_rep_op>-sort1 = <lst_adrc>-name2.                  "Search Term 1
      ENDIF.
      <lst_rep_op>-sort2   = <lst_adrc>-post_code1.             "Search Term 2

*     Begin of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630
*     If Email ID is maintained, default Standard Comm Method to INT (E-mail)
      READ TABLE li_email_ids TRANSPORTING NO FIELDS
           WITH KEY addrnumber = <lst_kna1>-adrnr
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        <lst_rep_op>-deflt_comm  = c_comm_int.                  "Communication Method (Key) (Business Address Services)
      ELSE.
*     End   of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630
*       Begin of ADD:CR#471/472:WROY:15-MAY-2017:ED2K906076
        IF <lst_adrc>-remark IS NOT INITIAL.
          lst_addr_uns-type    = c_comm_int.                    "SAPconnect: Address type
          lst_addr_uns-address = <lst_adrc>-remark.             "External address
*         Validate Email ID
          CALL FUNCTION 'SX_INTERNET_ADDRESS_TO_NORMAL'
            EXPORTING
              address_unstruct    = lst_addr_uns                "SAPconnect general address
            EXCEPTIONS
              error_address_type  = 1
              error_address       = 2
              error_group_address = 3
              OTHERS              = 4.
          IF sy-subrc EQ 0.
            <lst_rep_op>-smtp_addr   = <lst_adrc>-remark.       "Address notes --> E-mail
            <lst_rep_op>-deflt_comm  = c_comm_int.              "Communication Method (Key) (Business Address Services)
          ELSE.
            <lst_rep_op>-remark      = <lst_adrc>-remark.       "Address notes
            <lst_rep_op>-deflt_comm  = c_comm_let.              "Communication Method (Key) (Business Address Services)
          ENDIF.
*       Begin of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630
*       If Email ID is blank and Comment is also blank, default Standard Comm Method to LET (Post/Letter)
        ELSE.
          <lst_rep_op>-deflt_comm  = c_comm_let.                "Communication Method (Key) (Business Address Services)
*       End   of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630
        ENDIF.
*     Begin of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630
      ENDIF.
*     End   of ADD:ERP-2723:WROY:09-JUN-2017:ED2K906630

      <lst_rep_op>-street     = <lst_adrc>-str_suppl1.          "Street 2 --> Street
      <lst_rep_op>-str_suppl3 = <lst_adrc>-str_suppl2.          "Street 3 --> Street 4
      <lst_rep_op>-location   = <lst_adrc>-street.              "Street   --> Street 5
      IF <lst_adrc>-str_suppl3 IS NOT INITIAL OR
         <lst_adrc>-location   IS NOT INITIAL.
        IF <lst_rep_op>-remark IS INITIAL.
          <lst_rep_op>-remark = 'VALIDATE'(v01).
        ELSE.
          CONCATENATE <lst_rep_op>-remark
                      'VALIDATE'(v01)
                 INTO <lst_rep_op>-remark
            SEPARATED BY space.
        ENDIF.
      ENDIF.
*   End   of ADD:CR#471/472:WROY:15-MAY-2017:ED2K906076
    ENDIF.

*   Check if Company Code Ext is needed
    READ TABLE li_knb1 TRANSPORTING NO FIELDS
         WITH KEY kunnr = <lst_kna1>-kunnr
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      <lst_rep_op>-cc_ext = abap_false.                         "Flag: Company Code Extension
    ELSE.
      <lst_rep_op>-cc_ext = abap_true.                          "Flag: Company Code Extension
    ENDIF.

*   Identify ECORE / JCORE Customers
    READ TABLE li_but0id TRANSPORTING NO FIELDS
         WITH KEY partner = <lst_kna1>-kunnr
         BINARY SEARCH.
    IF sy-subrc EQ 0.
      <lst_rep_op>-jecore = abap_true.                          "Flag: ECORE / JCORE Cust
    ELSE.
      <lst_rep_op>-jecore = abap_false.                         "Flag: ECORE / JCORE Cust

*     Check if Sales Area Ext is needed
      READ TABLE li_knvv TRANSPORTING NO FIELDS
           WITH KEY kunnr = <lst_kna1>-kunnr
           BINARY SEARCH.
      IF sy-subrc EQ 0.
        <lst_rep_op>-sa_ext = abap_false.                      "Flag: Sales Area Extension
      ELSE.
        <lst_rep_op>-sa_ext = abap_true.                       "Flag: Sales Area Extension
      ENDIF.
    ENDIF.

*   Update Customer Information
    PERFORM f_update_customer USING    fp_p_waers
                                       fp_p_bukrs
                                       fp_p_akont
                                       fp_p_vtweg
                                       fp_p_spart
                                       fp_p_lifsd
                                       fp_p_faksd
                              CHANGING <lst_rep_op>.
    UNASSIGN: <lst_rep_op>.
  ENDLOOP.

* Display Process Log (ALV)
  CALL SCREEN 9000.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_CUSTOMER
*&---------------------------------------------------------------------*
*       Update Customer Information
*----------------------------------------------------------------------*
*      -->FP_P_WAERS     Currency Key
*      -->FP_P_BUKRS     Company Code
*      -->FP_P_AKONT     Reconciliation Account in General Ledger
*      -->FP_P_VTWEG     Distribution Channel
*      -->FP_P_SPART     Division
*      -->FP_P_LIFSD     Delivery Block
*      -->FP_P_FAKSD     Billing Block
*      <--FP_LST_REP_OP  Report Output
*----------------------------------------------------------------------*
FORM f_update_customer  USING    fp_p_waers    TYPE waers
                                 fp_p_bukrs    TYPE bukrs
                                 fp_p_akont    TYPE akont
                                 fp_p_vtweg    TYPE vtweg
                                 fp_p_spart    TYPE spart
                                 fp_p_lifsd    TYPE lifsd_v
                                 fp_p_faksd    TYPE faksd_v
                        CHANGING fp_lst_rep_op TYPE ty_report_op.

  DATA:
    li_prtnr_func TYPE cmds_parvw_t.

  DATA:
    lst_cust_data TYPE cmds_ei_main,                            "Ext. Interface: Total Customer Data
    lst_error_res TYPE cvis_message.                            "Error Indicator and System Messages

* Complex External Interface for Customers
  APPEND INITIAL LINE TO lst_cust_data-customers
         ASSIGNING FIELD-SYMBOL(<lst_customers>).
* Ext. Interface: Header for Customer Data
  <lst_customers>-header-object_instance-kunnr            = fp_lst_rep_op-kunnr.
  <lst_customers>-header-object_task                      = c_update.

* Begin of ADD:ERP-3938:WROY:02-SEP-2017:ED2K908333
* Ext. Interface: Central Customer Data
  <lst_customers>-central_data-central-data-katr10        = abap_true.
  <lst_customers>-central_data-central-datax-katr10       = abap_true.
* End   of ADD:ERP-3938:WROY:02-SEP-2017:ED2K908333

* Ext. Interface: Address of Organization
  <lst_customers>-central_data-address-task               = c_update.
* Ext. Interface: Address Type 1
* Begin of DEL:ERP-2723:WROY:09-JUN-2017:ED2K906630
* <lst_customers>-central_data-address-postal-data-name    = fp_lst_rep_op-name1.
* <lst_customers>-central_data-address-postal-data-name_2	 = fp_lst_rep_op-name2.
* End   of DEL:ERP-2723:WROY:09-JUN-2017:ED2K906630
  <lst_customers>-central_data-address-postal-data-sort1   = fp_lst_rep_op-sort1.
  <lst_customers>-central_data-address-postal-data-sort2   = fp_lst_rep_op-sort2.
* Begin of DEL:ERP-2723:WROY:09-JUN-2017:ED2K906630
* <lst_customers>-central_data-address-postal-datax-name   = abap_true.
* <lst_customers>-central_data-address-postal-datax-name_2 = abap_true.
* End   of DEL:ERP-2723:WROY:09-JUN-2017:ED2K906630
  <lst_customers>-central_data-address-postal-datax-sort1  = abap_true.
  <lst_customers>-central_data-address-postal-datax-sort2  = abap_true.
* Begin of ADD:CR#471/472:WROY:15-MAY-2017:ED2K906076
  <lst_customers>-central_data-address-postal-data-street      = fp_lst_rep_op-street.        "Street
  <lst_customers>-central_data-address-postal-data-str_suppl1  = fp_lst_rep_op-str_suppl1.    "Street 2
  <lst_customers>-central_data-address-postal-data-str_suppl2  = fp_lst_rep_op-str_suppl2.    "Street 3
  <lst_customers>-central_data-address-postal-data-str_suppl3  = fp_lst_rep_op-str_suppl3.    "Street 4
  <lst_customers>-central_data-address-postal-data-location    = fp_lst_rep_op-location.      "Street 5
  <lst_customers>-central_data-address-postal-data-comm_type   = fp_lst_rep_op-deflt_comm.    "Communication Method (Key) (Business Address Services)
  <lst_customers>-central_data-address-postal-datax-street     = abap_true.                   "Street
  <lst_customers>-central_data-address-postal-datax-str_suppl1 = abap_true.                   "Street 2
  <lst_customers>-central_data-address-postal-datax-str_suppl2 = abap_true.                   "Street 3
  <lst_customers>-central_data-address-postal-datax-str_suppl3 = abap_true.                   "Street 4
  <lst_customers>-central_data-address-postal-datax-location   = abap_true.                   "Street 5
  <lst_customers>-central_data-address-postal-datax-comm_type  = abap_true.                   "Communication Method (Key) (Business Address Services)

* Ext. Interface: Comments on Address
  APPEND INITIAL LINE TO <lst_customers>-central_data-address-remark-remarks
         ASSIGNING FIELD-SYMBOL(<lst_remarks>).
  <lst_remarks>-task                                           = c_update.                    "External Interface: Change Indicator Comments
  <lst_remarks>-data-langu                                     = sy-langu.                    "Language Key
  <lst_remarks>-data-adr_notes                                 = fp_lst_rep_op-remark.        "Address notes
  <lst_remarks>-datax-langu                                    = abap_true.                   "Language Key
  <lst_remarks>-datax-adr_notes                                = abap_true.                   "Address notes

* Ext. Interface: E-Mail Addresses
  APPEND INITIAL LINE TO <lst_customers>-central_data-address-communication-smtp-smtp
         ASSIGNING FIELD-SYMBOL(<lst_smtp>).
  <lst_smtp>-contact-task                                      = c_update.                    "External Interface: Change Indicator Comments
  <lst_smtp>-contact-data-e_mail                               = fp_lst_rep_op-smtp_addr.     "E-Mail Address
  <lst_smtp>-contact-datax-e_mail                              = abap_true.                   "E-Mail Address
* End   of ADD:CR#471/472:WROY:15-MAY-2017:ED2K906076

* If Company Code Extension needed
  IF fp_lst_rep_op-cc_ext EQ abap_true.
*   Ext. Interface: Company Code Data
    APPEND INITIAL LINE TO <lst_customers>-company_data-company
           ASSIGNING FIELD-SYMBOL(<lst_company>).
*   Ext. Interface: Company Code Data
    <lst_company>-task                                    = c_insert.
*   Ext. Interface: Company Code Data / Key Fields (Company Code)
    <lst_company>-data_key-bukrs                          = fp_p_bukrs.

*   Ext. Interface: Company Code Data / Data Fields
    <lst_company>-data-akont                              = fp_p_akont.
    <lst_company>-datax-akont                             = abap_true.

    UNASSIGN: <lst_company>.
  ENDIF.

* If Sales Area Extension needed
  IF fp_lst_rep_op-sa_ext EQ abap_true.
*   Ext. Interface: Sales Data
    APPEND INITIAL LINE TO <lst_customers>-sales_data-sales
           ASSIGNING FIELD-SYMBOL(<lst_sales>).
*   Ext. Interface: Sales Data
    <lst_sales>-task                                      = c_insert.
*   Ext. Interface: Sales Data / Key Fields (Sales Area)
    <lst_sales>-data_key-vkorg                            = fp_p_bukrs.
    <lst_sales>-data_key-vtweg                            = fp_p_vtweg.
    <lst_sales>-data_key-spart                            = fp_p_spart.

*   Ext. Interface: Sales Data / Data Fields
    <lst_sales>-data-waers                                = fp_p_waers.
    <lst_sales>-data-lifsd                                = fp_p_lifsd.
    <lst_sales>-data-faksd                                = fp_p_faksd.
    <lst_sales>-datax-waers                               = abap_true.
    <lst_sales>-datax-lifsd                               = abap_true.
    <lst_sales>-datax-faksd                               = abap_true.

*   Get all mandatory partner functions
    CALL METHOD cmd_ei_api_check=>get_mand_partner_functions
      EXPORTING
        iv_ktokd = fp_lst_rep_op-ktokd
      IMPORTING
        et_parvw = li_prtnr_func.

*   Ext. Interface: Partner Roles
    LOOP AT li_prtnr_func ASSIGNING FIELD-SYMBOL(<lst_prtnr_func>).
      APPEND INITIAL LINE TO <lst_sales>-functions-functions
             ASSIGNING FIELD-SYMBOL(<lst_functions>).
      <lst_functions>-task                                = c_insert.
      <lst_functions>-data_key-parvw                      = <lst_prtnr_func>-parvw.
      <lst_functions>-data-partner                        = fp_lst_rep_op-kunnr.
      <lst_functions>-datax-partner                       = abap_true.

      UNASSIGN: <lst_functions>.
    ENDLOOP.

    UNASSIGN: <lst_sales>.
  ENDIF.

* Manage Customer Master Data
  cmd_ei_api=>maintain(
    EXPORTING
      is_master_data = lst_cust_data
    IMPORTING
      es_error       = lst_error_res
         ).
  IF lst_error_res-is_error EQ abap_false.                      "No Error
*   COMMIT to database
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ELSE.                                                         "Error
*   ROLLBACK processed data
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ENDIF.

* Get the status messages
  DELETE lst_error_res-messages WHERE type EQ c_msgty_w.        "Remove Warning Message
  LOOP AT lst_error_res-messages ASSIGNING FIELD-SYMBOL(<lst_message>).
    IF fp_lst_rep_op-status_txt IS INITIAL.
      fp_lst_rep_op-status_txt = <lst_message>-message.
    ELSE.
      CONCATENATE fp_lst_rep_op-status_txt
                  <lst_message>-message
             INTO fp_lst_rep_op-status_txt
        SEPARATED BY c_semi_colon.
    ENDIF.
  ENDLOOP.
  IF fp_lst_rep_op-status_txt IS INITIAL.
    IF lst_error_res-is_error EQ abap_false.                      "No Error
*     Message: Business partner processed successfully
      MESSAGE s011(jksdeuwvcal)
         WITH fp_lst_rep_op-kunnr
         INTO fp_lst_rep_op-status_txt.
    ELSE.                                                         "Error
*     Message: Error in updating data for business partner &1
      MESSAGE e002(gho_msg_db_cuvd_bp)
         WITH fp_lst_rep_op-kunnr
         INTO fp_lst_rep_op-status_txt.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_DISPLAY_PROCESS_LOG
*&---------------------------------------------------------------------*
*       Display Process Log (ALV)
*----------------------------------------------------------------------*
*      -->P_LI_REPORT_OP  Report Output
*----------------------------------------------------------------------*
FORM f_display_process_log  USING    fp_li_report_op TYPE tt_report_op.

* Check whether the program is run in batch or foreground
  IF cl_gui_alv_grid=>offline( ) IS INITIAL.             "Run in foreground
*   create controls
    CREATE OBJECT r_alv_cont
      EXPORTING
        container_name = 'ALV_CONT'.

    CREATE OBJECT r_alv_grid
      EXPORTING
        i_parent = r_alv_cont.
  ELSE.                                                  "Run in background
    CREATE OBJECT r_alv_grid
      EXPORTING
        i_parent = r_dck_cont.
  ENDIF.

*  Populate Field Catalog

  CLEAR: i_fieldcat.
  PERFORM f_get_fieldcatalog USING:
                'CUSTOMER NUMBER'(m01)        c_kunnr  c_tab c_16  CHANGING i_fieldcat,
                'COUNTRY KEY'(m02)            c_land1  c_tab c_05  CHANGING i_fieldcat,
                'SEARCH TERM 1'(m03)          c_sort1  c_tab c_20  CHANGING i_fieldcat,
                'SEARCH TERM 2'(m04)          c_sort2  c_tab c_20  CHANGING i_fieldcat,
                'ECORE/JCORE'(m05)            c_jecore c_tab c_02  CHANGING i_fieldcat,
                'COMPANY CODE EXTENSION'(m06) c_cc_ext c_tab c_02  CHANGING i_fieldcat,
                'SALES AREA EXTENSION'(m07)   c_sa_ext c_tab c_01  CHANGING i_fieldcat,
                'STATUS MESSAGE'(m08)         c_st_txt c_tab c_50  CHANGING i_fieldcat.

  CALL METHOD r_alv_grid->set_table_for_first_display
    EXPORTING
      i_save          = abap_true
    CHANGING
      it_outtab       = fp_li_report_op[]
      it_fieldcatalog = i_fieldcat[].


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_data .

  DATA:  lv_land1 TYPE land1_gp,          "Country Key
         lv_waers TYPE waers_v02d,        "Currency
         lv_bukrs TYPE bukrs,             "Company Code
         lv_ktokd TYPE ktokd,             "Customer Account Group
         lv_kunnr TYPE kunnr,             "Customer Number
         lv_akont TYPE akont,             "Reconciliation Account
         lv_vtweg TYPE vtweg,             "Distribution Channel
         lv_lifsd TYPE lifsd_v,           "Delivery block for sales area
         lv_faksd TYPE faksd_v,           "Billing block for sales area
         lv_typ   TYPE bu_id_type.        "Identification Code
  CONSTANTS: lc_e TYPE char1 VALUE 'E'.   "error type

*Validation of Country key
  IF s_land1 IS  NOT INITIAL.
    SELECT SINGLE land1   " Country Key
        FROM t005
        INTO (lv_land1)
        WHERE land1 IN s_land1.

    IF sy-subrc <> 0.
      MESSAGE s030 DISPLAY LIKE lc_e.
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF s_land1 IS NOT INITIAL


*Validation of Currency
  IF p_waers IS  NOT INITIAL.
    SELECT SINGLE waers    " Currency
        FROM tcurc
        INTO (lv_waers)
        WHERE waers EQ p_waers.

    IF sy-subrc <> 0.
      MESSAGE s000 WITH text-001 DISPLAY LIKE lc_e.
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF p_waers IS NOT INITIAL


*validation of Company Code

  IF p_bukrs IS  NOT INITIAL.
    SELECT SINGLE bukrs   " Company Code
        FROM t001
        INTO (lv_bukrs)
        WHERE bukrs EQ p_bukrs.

    IF sy-subrc <> 0.
      MESSAGE s041 DISPLAY LIKE lc_e.
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF p_bukrs IS NOT INITIAL

*validation of Customer account group
  IF s_ktokd IS  NOT INITIAL.
    SELECT SINGLE ktokd   " Customer account group
        FROM t077d
        INTO (lv_ktokd)
        WHERE ktokd IN s_ktokd.

    IF sy-subrc <> 0.
      MESSAGE s000 WITH text-002 DISPLAY LIKE lc_e.
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF p_ktokd IS NOT INITIAL

*validation of Customer Number
  IF s_kunnr IS  NOT INITIAL.
    SELECT SINGLE kunnr   " Customer Number
        FROM kna1
        INTO (lv_kunnr)
        WHERE kunnr IN s_kunnr.

    IF sy-subrc <> 0.
      MESSAGE s010 DISPLAY LIKE lc_e.
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF s_kunnr IS NOT INITIAL

*validation of Reconciliation Account
  IF p_akont IS  NOT INITIAL.
    SELECT SINGLE saknr   " Reconciliation Account
        FROM ska1
        INTO (lv_akont)
        WHERE saknr EQ p_akont.

    IF sy-subrc <> 0.
      MESSAGE s000 WITH text-003 DISPLAY LIKE lc_e.
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF p_akont IS NOT INITIAL

*validation of Distribution Channel
  IF p_vtweg IS  NOT INITIAL.
    SELECT SINGLE vtweg   " Distribution Channel
        FROM tvtw
        INTO (lv_vtweg)
        WHERE vtweg EQ p_vtweg.

    IF sy-subrc <> 0.
      MESSAGE s013 DISPLAY LIKE lc_e.
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF p_vtweg IS NOT INITIAL

*validation of Division
  IF p_spart IS  NOT INITIAL.
    SELECT SINGLE spart   " Division
        FROM tspa
        INTO (lv_vtweg)
        WHERE spart EQ p_spart.

    IF sy-subrc <> 0.
      MESSAGE s021 DISPLAY LIKE lc_e.
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF p_spart IS NOT INITIAL

*validation of delivery block for sales area
  IF p_lifsd IS  NOT INITIAL.
    SELECT SINGLE lifsp   " delivery block
        FROM tvls
        INTO (lv_lifsd)
        WHERE lifsp EQ p_lifsd.

    IF sy-subrc <> 0.
      MESSAGE s000 WITH text-004 DISPLAY LIKE lc_e.
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF p_lifsd IS NOT INITIAL

*validation of billing block for sales area
  IF p_faksd IS  NOT INITIAL.
    SELECT SINGLE faksp   " billing block
        FROM tvfs
        INTO (lv_faksd)
        WHERE faksp EQ p_faksd.

    IF sy-subrc <> 0.
      MESSAGE s000 WITH text-005 DISPLAY LIKE lc_e.
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF p_vtweg IS NOT INITIAL

*validation of identification code
  IF s_idtyp IS  NOT INITIAL.
    SELECT SINGLE type   " identification code
        FROM tb039a
        INTO (lv_typ)
        WHERE type IN s_idtyp.

    IF sy-subrc <> 0.
      MESSAGE s000 WITH text-006 DISPLAY LIKE lc_e.
      LEAVE LIST-PROCESSING.
    ENDIF. " IF sy-subrc <> 0

  ENDIF. " IF s_idtyp IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_fieldcatalog  USING   fp_reptext TYPE reptext
                                 fp_fname   TYPE lvc_fname
                                 fp_tab     TYPE lvc_tname
                                 fp_outlen  TYPE lvc_outlen
                        CHANGING fp_i_fcat  TYPE lvc_t_fcat.

  DATA: lst_fcat TYPE lvc_s_fcat.

  CLEAR: lst_fcat.
  lst_fcat-reptext    = fp_reptext."'CUSTOMER NUMBER'(m01).
  lst_fcat-fieldname  = fp_fname."c_kunnr.
  lst_fcat-ref_table  = fp_tab."c_tab.
  lst_fcat-outputlen  = fp_outlen."16.
  APPEND lst_fcat TO fp_i_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  SET PF-STATUS c_mod_st.
  SET TITLEBAR  c_mod_st.
  PERFORM f_display_process_log USING i_report_op.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9000 INPUT.
  CASE sy-ucomm.

    WHEN c_back OR c_canc OR c_exit.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  F_ALV_REPORT_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_alv_report_layout .
  i_layout-cwidth_opt = abap_true.

  i_layout-zebra = abap_true.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_all .
  CLEAR: i_report_op,
         r_alv_cont,
         r_alv_grid,
         i_fieldcat,
         i_layout.
ENDFORM.
