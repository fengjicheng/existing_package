*----------------------------------------------------------------------*
***INCLUDE LZQTC_SUB_MEMBRSHP_CHCKF01.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME:          LZQTC_SUB_MEMBRSHP_CHCKF01
* PROGRAM DESCRIPTION:   Include for subroutines
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
*  Payment Status ,Cancellation Code addition
*----------------------------------------------------------------------*
* REVISION HISTORY-----------------------------------------------------*
* REVISION NO: ED2K906236
* REFERENCE NO: CR# 524
* DEVELOPER: Monalisa Dutta
* DATE:  2017-05-22
* DESCRIPTION: Addition of ZMJE in ZCACONSTANT and adding including media
* type during filteration of records
*----------------------------------------------------------------------*
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
*-----------------------------------------------------------------------*
* REVISION NO: ED2K911038
* REFERENCE NO: ERP-6750
* DEVELOPER: Dinakar T(DTIRUKOOVA)
* DATE:  2018-02-22
* DESCRIPTION: Wrong Data being retreived when executed with Refernece(IHREZ)
*              and email IDs, considering document and item number when
*              fetching address data w.r.t email ids.
*-----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_GET_DATA
*&---------------------------------------------------------------------*
*       To get details from ZQTC_JGC_SOCIETY table
*----------------------------------------------------------------------*
*      -->FP_LI_SOCIETY  Society from import parameter IM_SSCODE
*      <--FP_LI_JGC_SOCIETY  Internal table for ZQTC_JGC_SOCIETY
*----------------------------------------------------------------------*

FORM f_get_data  USING    fp_li_society TYPE tt_society
                          fp_li_email TYPE tt_email
* BOC by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
*                          fp_li_vbeln TYPE tt_vbeln
                          fp_li_subs_ref  TYPE tt_ihrez
* EOC by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
                          fp_im_cntrctdat TYPE vbdat_veda
                          fp_im_pymnt_sts TYPE zqtc_pymnt_sts
                          fp_im_doublebilling TYPE zqtc_double_bill
                          fp_li_payment TYPE tt_payment
                          fp_im_cncl_code TYPE kuegru
                          fp_li_subtyp TYPE tt_subtyp
                          fp_li_constant TYPE tt_constant
                          fp_im_media_type TYPE zqtc_media_type "Added by MODUTTA for CR#403
*--BOC by GKAMMILI on 09-10-2020 for OTCM 13923
*                          fp_li_quote  TYPE tt_quote
*                          fp_li_postal TYPE tt_postal
*--EOC by GKAMMILI on 09-10-2020 for OTCM 13929
                 CHANGING fp_li_bapiret TYPE bapiret2_t
                          fp_li_final TYPE ztqtc_membership_check.

* Local type declaration
  TYPES: BEGIN OF lty_range,
           sign   TYPE ddsign,     "sign
           option TYPE ddoption,   "option
           low    TYPE rvari_vnam, "low
           high   TYPE rvari_vnam, "high
         END OF lty_range,

         BEGIN OF lty_payment_range,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE konda,
           high   TYPE konda,
         END OF lty_payment_range,

         BEGIN OF lty_payment_rng,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE char1,
           high   TYPE char1,
         END OF lty_payment_rng,

* Begin of Change by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
         BEGIN OF lty_lgcy_sref,
           ihrez_e TYPE ihrez_e,
         END OF lty_lgcy_sref,
* End of Change by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
         BEGIN OF lty_vbeln_new,
           vbeln_new TYPE ihrez_e, " Sales Order
         END OF lty_vbeln_new,

         BEGIN OF lty_order,
           vbeln TYPE vbeln, "Sales Order
           posnr TYPE posnr, "Item Number
         END OF lty_order,

         BEGIN OF lty_society,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE zzpartner2,
           high   TYPE zzpartner2,
         END OF lty_society,

         BEGIN OF lty_subtyp,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE char4,
           high   TYPE char4,
         END OF lty_subtyp,

         BEGIN OF lty_jrnl_code,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE zzjrnl_grp_code,
           high   TYPE zzjrnl_grp_code,
         END OF lty_jrnl_code,

         BEGIN OF lty_email,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE ad_smtpadr,
           high   TYPE ad_smtpadr,
         END OF lty_email,

         BEGIN OF lty_email_s,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE ad_smtpad2,
           high   TYPE ad_smtpad2,
         END OF lty_email_s,

         "Added by MODUTTA for CR#4524
         BEGIN OF lty_media,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE ismmediatype,
           high   TYPE ismmediatype,
         END OF lty_media,

         BEGIN OF lty_mara,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE matnr,
           high   TYPE matnr,
         END OF lty_mara.
**--BOC by GKAMMILI on 09-10-2020 for OTCM 13923
*           BEGIN OF lty_quote,
*            sign   TYPE ddsign,
*            option TYPE ddoption,
*            low    TYPE vbeln,
*            high   TYPE vbeln,
*          END OF lty_quote,
*           BEGIN OF lty_postal,
*            sign   TYPE ddsign,
*            option TYPE ddoption,
*            low    TYPE ad_pstcd2,
*            high   TYPE ad_pstcd2,
*          END OF lty_postal.
**--BOC by GKAMMILI on 09-10-2020 for OTCM 13923

* Local constant declaration
  CONSTANTS: lc_auart        TYPE rvari_vnam VALUE 'AUART',
             lc_pstyv        TYPE rvari_vnam VALUE 'PSTYV',
             lc_journal_code TYPE rvari_vnam VALUE 'JOURNAL_CODE',
             lc_mvgr5_1      TYPE rvari_vnam VALUE 'MVGR5_1',
             lc_mvgr5_2      TYPE rvari_vnam VALUE 'MVGR5_2',
             lc_sign         TYPE ddsign VALUE 'I',
* BOI by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
             lc_spras        TYPE rvari_vnam  VALUE 'SPRAS',
* EOI by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
             lc_option       TYPE ddoption VALUE 'EQ',
             lc_option_cp    TYPE ddoption VALUE 'CP',
             lc_yes          TYPE char1 VALUE 'Y',
             lc_no           TYPE char1 VALUE 'N',
             lc_parvw        TYPE parvw VALUE 'WE', "Ship to party
             lc_parvw_ag     TYPE parvw VALUE 'AG', "Sold to Party
             lc_payment_c    TYPE char1 VALUE 'C',
             lc_payment_m    TYPE char1 VALUE 'M',
             lc_payment_f    TYPE char1 VALUE 'F',
             lc_payment_p    TYPE char1 VALUE 'P',
             lc_konda_01     TYPE konda VALUE '01',
             lc_konda_02     TYPE konda VALUE '02',
             lc_konda_03     TYPE konda VALUE '03',
             lc_konda_04     TYPE konda VALUE '04',
             lc_bsark        TYPE bsark VALUE '0230',
             lc_payment_e    TYPE konda VALUE 'E',
             lc_paid         TYPE augbl VALUE 'P',
             lc_star         TYPE char1 VALUE '*',
             lc_posnr        TYPE posnr_va VALUE '000000', "Added by MODUTTA for CR# 410
             lc_paymnt_sts   TYPE rvari_vnam VALUE 'PAYMNT_STS', "Added by PBANDLAPAL for ERP-5596
             lc_pstyv_p      TYPE rvari_vnam VALUE 'PSTYV_P', "Added by MODUTTA for CR#403
             lc_cmgst        TYPE cmgst VALUE 'B', "Added by MODUTTA for CR# 410
             lc_media_p      TYPE ismmediatype VALUE 'PH', "Added by MODUTTA for CR 524
             lc_media_d      TYPE ismmediatype VALUE 'DI'. "Added by MODUTTA for CR 524

* Local data declaration
  DATA: lir_auart           TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0,
        lir_pstyv_d         TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0,
        lir_pstyv           TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0,
        lst_pstyv           TYPE lty_range,
        lir_code            TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0,
        lv_strt_date        TYPE sy-datum,    " change for defect 1754
        lv_end_date         TYPE sy-datum,    " change for defect 1754
        li_vbeln_new        TYPE STANDARD TABLE OF lty_vbeln_new INITIAL SIZE 0,
        li_order_detail     TYPE STANDARD TABLE OF lty_order INITIAL SIZE 0,
* BOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
        lv_tabix            TYPE sy-tabix,
        lv_paymnt_sts       TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
        li_ord_dtl_tmp      TYPE STANDARD TABLE OF lty_order INITIAL SIZE 0,
        lst_ord_dtl_tmp     TYPE lty_order,
* EOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
        lir_order_range     TYPE fip_t_vbeln_range,
        lst_order_range     LIKE LINE OF lir_order_range,
        lir_email_range     TYPE STANDARD TABLE OF lty_email,
        lir_email_s_range   TYPE STANDARD TABLE OF lty_email_s,
        lst_email_range     TYPE lty_email,
        lst_email_s_range   TYPE lty_email_s,
**--BOC by GKAMMILI on 09-10-2020 for OTCM 13923
*        lir_quote           TYPE STANDARD TABLE OF lty_quote,
*        lst_quote           TYPE lty_quote,
*        lir_postal_range    TYPE STANDARD TABLE OF lty_postal,
*        lir_postal_s_range  TYPE STANDARD TABLE OF lty_postal,
*        lst_postal_range    TYPE lty_postal,
*        lst_postal_s_range  TYPE lty_postal,
**--EOC by GKAMMILI on 09-10-2020 for OTCM 13923
        li_vbeln1           TYPE tt_vbeln,
        li_order            TYPE mds_sales_key_tab,
        lv_leng             TYPE i,
        lv_jcode(4)         TYPE n,
        lv_order            TYPE sales_key,
        lst_auart           TYPE lty_range,
        lst_code            TYPE lty_range,
        lst_mvgr5_1         TYPE lty_range,
        lst_mvgr5_2         TYPE lty_range,
        lst_bapiret         TYPE bapiret2,
        lst_order_detail    TYPE lty_order,
        lst_view            TYPE order_view,
        lst_society_range   TYPE lty_society,
        lst_payment_range   TYPE lty_payment_range,
        lir_society_range   TYPE STANDARD TABLE OF lty_society,
        lir_subtyp          TYPE STANDARD TABLE OF lty_subtyp INITIAL SIZE 0, "this is not removed since w emay be need it after testing to add new logic
        lst_subtyp          TYPE lty_subtyp,
        lst_subtyp_rng      TYPE lty_payment_rng,
        lir_subtyp_rng      TYPE STANDARD TABLE OF lty_payment_rng,
        lir_society         TYPE STANDARD TABLE OF lty_society INITIAL SIZE 0,
        lir_jrnl_code       TYPE STANDARD TABLE OF lty_jrnl_code INITIAL SIZE 0,
        lst_jrnl_code       TYPE lty_jrnl_code,
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*        li_header           TYPE STANDARD TABLE OF bapisdhd INITIAL SIZE 0,
*        li_item             TYPE STANDARD TABLE OF bapisdit INITIAL SIZE 0,
*        li_vbkd             TYPE STANDARD TABLE OF bapisdbusi INITIAL SIZE 0,
*        li_vbep             TYPE STANDARD TABLE OF bapisdhedu INITIAL SIZE 0,
*        li_vbpa             TYPE STANDARD TABLE OF bapisdpart INITIAL SIZE 0,
*        li_adrc             TYPE STANDARD TABLE OF bapisdcoad INITIAL SIZE 0,
*        li_vbuk             TYPE STANDARD TABLE OF bapisdhdst INITIAL SIZE 0,
*        li_vbfa             TYPE STANDARD TABLE OF bapisdflow INITIAL SIZE 0,
*        li_veda             TYPE STANDARD TABLE OF bapisdcntr INITIAL SIZE 0,
        lr_parvw            TYPE wtysc_parvw_ranges_tab,
        lst_parvw           TYPE wtysc_wwb_s_parvw,
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
        lv_idcode           TYPE ismidentcode,
        lv_jgrp_code        TYPE ismidentcode,
        lv_flag             TYPE xfeld,
* BOI by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
        lv_dflt_langu       TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
* EOI by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
* Begin of Change by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
        li_ihrez            TYPE tt_ihrez,
        li_lgcy_sref        TYPE TABLE OF lty_lgcy_sref,
        li_sub_order        TYPE STANDARD TABLE OF lty_order INITIAL SIZE 0,
        li_sub_order_c      TYPE STANDARD TABLE OF lty_order INITIAL SIZE 0,   " Consolidated orders for Legacy and SAP Subs Ref
        li_sub_order_ls     TYPE STANDARD TABLE OF lty_order INITIAL SIZE 0,  " With reference to Legacy Subs Ref
        li_sub_order_ss     TYPE STANDARD TABLE OF lty_order INITIAL SIZE 0,  " With reference to SAP Subs Ref
* End of Change by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
        lir_identcode       TYPE rjksd_identcode_range_tab,
        lst_identcode_range LIKE LINE OF lir_identcode,
        lir_payment_rng     TYPE STANDARD TABLE OF lty_payment_rng,
        lst_payment_rng     TYPE lty_payment_rng,
        lir_payment         TYPE STANDARD TABLE OF lty_payment_range INITIAL SIZE 0, "This is not removed since we may need it later after testing
        lir_mvgr5_1         TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0,
        lir_mvgr5_2         TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0,
        lst_final           TYPE zstqtc_membership_check,
        li_jkseinterrupt    TYPE tt_jkseinterrupt, "Added by MODUTTA for CR#410
        lir_pstyv_p         TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0, "Added by MODUTTA for CR#403
        lir_media           TYPE STANDARD TABLE OF lty_media INITIAL SIZE 0, "Added by MODUTTA for CR#524
        lst_media           TYPE lty_media, "Added by MODUTTA for CR#524
        lir_mara            TYPE STANDARD TABLE OF lty_mara,
        lst_mara_rng        TYPE lty_mara.

* Get the constants from ZCACONSTANT table
  LOOP AT fp_li_constant INTO DATA(lst_constant).
    CASE lst_constant-param1. "Variable Name
      WHEN lc_auart. "AUART
        lst_auart-sign = lc_sign.
        lst_auart-option = lc_option.
        lst_auart-low = lst_constant-low.
        APPEND lst_auart TO lir_auart.
        CLEAR lst_auart.
      WHEN lc_pstyv. "PSTYV
        lst_pstyv-sign = lc_sign.
        lst_pstyv-option = lc_option.
        lst_pstyv-low = lst_constant-low.
        APPEND lst_pstyv TO lir_pstyv_d.
        CLEAR lst_pstyv.
      WHEN lc_journal_code. "JOURNAL_CODE
        lst_code-sign = lc_sign.
        lst_code-option = lc_option.
        lst_code-low = lst_constant-low.
        APPEND lst_code TO lir_code.
        CLEAR lst_code.
      WHEN lc_mvgr5_1.
        lst_mvgr5_1-sign = lc_sign.
        lst_mvgr5_1-option = lc_option.
        lst_mvgr5_1-low = lst_constant-low.
        APPEND lst_mvgr5_1 TO lir_mvgr5_1.
      WHEN lc_mvgr5_2.
        lst_mvgr5_2-sign = lc_sign.
        lst_mvgr5_2-option = lc_option.
        lst_mvgr5_2-low = lst_constant-low.
        APPEND lst_mvgr5_2 TO lir_mvgr5_2.
      WHEN lc_pstyv_p.
        lst_pstyv-sign = lc_sign.
        lst_pstyv-option = lc_option.
        lst_pstyv-low = lst_constant-low.
        APPEND lst_pstyv TO lir_pstyv_p.
        CLEAR lst_pstyv.
* BOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
      WHEN lc_paymnt_sts.
        lv_paymnt_sts    = lst_constant-low.
* EOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
* BOI by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
      WHEN lc_spras.
        lv_dflt_langu   = lst_constant-low.
* EOI by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
      WHEN OTHERS.
        "No Action
    ENDCASE.
  ENDLOOP.

  IF fp_li_payment IS NOT INITIAL.
    LOOP AT fp_li_payment INTO DATA(lst_payment).
      lst_payment_range-sign = lst_payment_rng-sign = lc_sign.
      lst_payment_range-option = lst_payment_rng-option = lc_option.
      lst_payment_rng-low = lst_payment-payment_rate.
      APPEND lst_payment_rng TO lir_payment_rng.
      IF lst_payment-payment_rate = lc_payment_c.
        lst_payment_range-low = lc_konda_01.
      ELSEIF lst_payment-payment_rate = lc_payment_m.
        lst_payment_range-low = lc_konda_02.
      ELSEIF lst_payment-payment_rate = lc_payment_f.
        lst_payment_range-low = lc_konda_03.
      ELSEIF lst_payment-payment_rate = lc_payment_p.
        lst_payment_range-low = lc_konda_04.
      ENDIF.
      APPEND lst_payment_range TO lir_payment.
      CLEAR: lst_payment_range,lst_payment_rng.
    ENDLOOP.
  ENDIF.

  LOOP AT fp_li_subtyp INTO DATA(lst_subtyp_range).
    lst_subtyp-sign = lst_subtyp_rng-sign = lc_sign.
    lst_subtyp-option = lst_subtyp_rng-option = lc_option.
    lst_subtyp_rng-low = lst_subtyp_range-subtyp.
    APPEND lst_subtyp_rng TO lir_subtyp_rng.
    IF lst_subtyp_range-subtyp = lc_payment_c.
      lst_subtyp-low = lc_konda_01.
    ELSEIF lst_subtyp_range-subtyp = lc_payment_m.
      lst_subtyp-low = lc_konda_02.
    ELSEIF lst_subtyp_range-subtyp = lc_payment_f.
      lst_subtyp-low = lc_konda_03.
    ENDIF.
    APPEND lst_subtyp TO lir_subtyp.
    CLEAR: lst_subtyp,lst_subtyp_rng.
  ENDLOOP.

* BOC by MODUTTA for CR# 403
  IF fp_im_media_type = c_media_default. "if media type is D
    lir_pstyv[] = lir_pstyv_d[].
* BOC by MODUTTA for CR# 524
    lst_media-sign = lc_sign.
    lst_media-option = lc_option.
    lst_media-low = lc_media_d.
    APPEND lst_media TO lir_media.
    CLEAR lst_media.
* EOC by MODUTTA for CR# 524
  ELSEIF fp_im_media_type = lc_payment_p. "if media type is P
    lir_pstyv[] = lir_pstyv_p[].
* BOC by MODUTTA for CR# 524
    lst_media-sign = lc_sign.
    lst_media-option = lc_option.
    lst_media-low = lc_media_p.
    APPEND lst_media TO lir_media.
    CLEAR lst_media.
* EOC by MODUTTA for CR# 524
  ELSEIF fp_im_media_type = lc_payment_c. "if media type is C
    APPEND LINES OF lir_pstyv_d TO lir_pstyv.
    APPEND LINES OF lir_pstyv_p TO lir_pstyv.
* BOC by MODUTTA for CR# 524
*    Populate media type DI
    lst_media-sign = lc_sign.
    lst_media-option = lc_option.
    lst_media-low = lc_media_d.
    APPEND lst_media TO lir_media.
    CLEAR lst_media.
*    Populate media type PH
    lst_media-sign = lc_sign.
    lst_media-option = lc_option.
    lst_media-low = lc_media_p.
    APPEND lst_media TO lir_media.
    CLEAR lst_media.
* EOC by MODUTTA for CR# 524
  ENDIF.
* EOC by MODUTTA for CR# 403

* Begin of Change by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439
*  If input im_vbeln is not initial
*  IF fp_li_vbeln IS NOT INITIAL.
*    LOOP AT fp_li_vbeln INTO DATA(lst_vbeln).
*      SHIFT lst_vbeln-vbeln LEFT DELETING LEADING '0'.
*      DATA(lv_len) = strlen( lst_vbeln-vbeln ).
*      IF lv_len = 7.
*        APPEND lst_vbeln TO li_vbeln_new.
*      ELSE.
*        APPEND lst_vbeln TO li_vbeln1.
*      ENDIF.
*      CLEAR lst_vbeln.
*    ENDLOOP.
*
**    If the length of im_vbeln is 7 then get subscription order from VBKD
*    IF li_vbeln_new IS NOT INITIAL.
*      SELECT
*        a~vbeln,
*        a~posnr
*        FROM vbkd AS a
*        INTO TABLE @DATA(li_sub_order)
*        FOR ALL ENTRIES IN @li_vbeln_new
*        WHERE a~ihrez_e = @li_vbeln_new-vbeln_new.
*      IF sy-subrc NE 0.
**        MESSAGE e122(zqtc_r2) WITH 'Subscription Id with length 7'(004) INTO lst_bapiret-message.
*        MESSAGE e122(zqtc_r2) WITH 'Legacy Id'(004) INTO lst_bapiret-message.
**     No Subscription Order found for input Subscription Id with length 7
**      To update return table with messages
*        PERFORM f_update_return CHANGING lst_bapiret
*                                        fp_li_bapiret.
*        RETURN.
*      ENDIF.
*    ENDIF.
**  Length of im_vbeln is not 7 get subscription order from VIVEDA
*    IF li_vbeln1 IS NOT INITIAL.
*      SELECT
*        v~vbeln,      " Sales order
*        v~posnr       " Item Number
*        FROM viveda AS v
*        INTO TABLE @li_sub_order
*        FOR ALL ENTRIES IN @li_vbeln1
*        WHERE v~vbeln = @li_vbeln1-vbeln
*        AND   v~auart IN @lir_auart
*        AND   v~pstyv IN @lir_pstyv.
*      IF sy-subrc NE 0.
*        MESSAGE e122(zqtc_r2) WITH 'Subscription Id'(003) INTO lst_bapiret-message.
**      No Subscription Order found for input Subscription Id
**      To update return table with messages
*        PERFORM f_update_return CHANGING lst_bapiret
*                                 fp_li_bapiret.
*        RETURN.
*      ENDIF.
*    ENDIF.

  IF fp_li_subs_ref IS NOT INITIAL.
    SELECT
      vbeln,
      posnr
    FROM vbkd
    INTO TABLE @li_sub_order_ss
    FOR ALL ENTRIES IN @fp_li_subs_ref
    WHERE ihrez = @fp_li_subs_ref-ihrez.
    IF sy-subrc NE 0.
      SELECT
        vbeln,
        posnr
    FROM vbkd
    INTO TABLE @li_sub_order_ls
    FOR ALL ENTRIES IN @fp_li_subs_ref
    WHERE ihrez_e = @fp_li_subs_ref-ihrez.
      IF sy-subrc NE 0.
        MESSAGE e122(zqtc_r2) WITH 'Reference Number'(003) INTO lst_bapiret-message.
*      No Subscription Order found for input Subscription Id
*      To update return table with messages
        PERFORM f_update_return CHANGING lst_bapiret
                                 fp_li_bapiret.
        RETURN.
      ELSE.
        APPEND LINES OF li_sub_order_ls TO li_sub_order_c.
      ENDIF.
    ELSE.
      APPEND LINES OF li_sub_order_ss TO li_sub_order_c.
    ENDIF.

* To filter the sales document type and item category maintained
* in ZCACONSTANT.
    IF li_sub_order_c IS NOT INITIAL.
      SORT li_sub_order_c BY vbeln posnr.
      DELETE ADJACENT DUPLICATES FROM li_sub_order_c COMPARING vbeln posnr.
      SELECT
          vbeln,      " Sales order
          posnr       " Item Number
        FROM viveda
        INTO TABLE @li_sub_order
        FOR ALL ENTRIES IN @li_sub_order_c
        WHERE vbeln = @li_sub_order_c-vbeln
        AND   posnr = @li_sub_order_c-posnr
        AND   auart IN @lir_auart
        AND   pstyv IN @lir_pstyv.
      IF sy-subrc NE 0.
        MESSAGE e237(zqtc_r2) INTO lst_bapiret-message.
*      No valid subscriptions found for input Subscription Id
*      To update return table with messages
        PERFORM f_update_return CHANGING lst_bapiret
                                 fp_li_bapiret.
        RETURN.
      ENDIF.
    ENDIF.
  ENDIF.
* End of Change by PBANDLAPAL on 06-Sep-2017 CR#645 ED2K908439

*      Populate Subscription Order
  IF li_sub_order IS NOT INITIAL.
* BOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
    SORT li_sub_order BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM li_sub_order COMPARING vbeln posnr.
* EOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
    LOOP AT li_sub_order INTO DATA(lst_sub_order).
      lst_order_detail-vbeln = lst_sub_order-vbeln.
      lst_order_detail-posnr = lst_sub_order-posnr.
      APPEND lst_order_detail TO li_order_detail.
      lv_order = lst_sub_order-vbeln.
      APPEND lv_order TO li_order.
      lst_order_range-sign = lc_sign.
      lst_order_range-option = lc_option.
      lst_order_range-low = lv_order.
      APPEND lst_order_range TO lir_order_range.
      CLEAR: lst_order_detail,lst_sub_order,lv_order,lst_order_range.
    ENDLOOP.
  ENDIF.

******Select data from ZQTC_JGC_SOCIETY .
  IF fp_li_society IS NOT INITIAL.
    LOOP AT fp_li_society INTO DATA(lst_society_data).
      CLEAR lst_society_range.
      lst_society_range-sign = lc_sign.
      lst_society_range-option = lc_option.
      lst_society_range-low = lst_society_data-society.
      APPEND lst_society_range TO lir_society_range.
      CLEAR: lst_society_range,lst_society_range.
    ENDLOOP.

    SELECT                                              "#EC CI_NOFIELD
      jrnl_grp_code,         " Journal Group Code
      reltyp,                " Business Partner Relationship Category
      society,               " Business Partner 2 or Society number
      society_acrnym ,       " Society Acronym
      society_name           " Society Nam
      FROM  zqtc_jgc_society
      INTO TABLE @DATA(li_zqtc_society)
      FOR ALL ENTRIES IN @fp_li_society
      WHERE society_acrnym  = @fp_li_society-society
        AND digital_relevant  = @abap_true.
    IF sy-subrc EQ 0.
      LOOP AT li_zqtc_society INTO DATA(lst_zqtc_society).
        IF lst_zqtc_society IS NOT INITIAL.
*        Adding a star in Journal group code
*          CONCATENATE lst_zqtc_society-jrnl_grp_code lc_star INTO lst_zqtc_society-jrnl_grp_code.
          lst_jrnl_code-sign = lc_sign.
          lst_jrnl_code-option = lc_option_cp.
          CLEAR lv_leng.

          lv_leng = strlen( lst_zqtc_society-jrnl_grp_code ).
* this is done to pass pad leading zeros for the first four characters.
          IF lv_leng LT 4.
            SHIFT lst_zqtc_society-jrnl_grp_code+0(4) RIGHT DELETING TRAILING space.
            TRANSLATE lst_zqtc_society-jrnl_grp_code+0(4) USING ' 0'.
            CONCATENATE lst_zqtc_society-jrnl_grp_code+0(4) lc_star INTO lst_jrnl_code-low.
          ELSE.
            CONCATENATE lst_zqtc_society-jrnl_grp_code+0(4) lc_star INTO lst_jrnl_code-low.
          ENDIF.
*          lst_jrnl_code-low = lst_zqtc_society-jrnl_grp_code.
          APPEND lst_jrnl_code TO lir_jrnl_code.
          CLEAR lst_jrnl_code.
        ENDIF.
      ENDLOOP.

      SELECT
        j~matnr,                 " Material
        v~vbeln,                 " Subscription Order
        v~posnr                  " Line Item
        FROM jptidcdassign AS j
        INNER JOIN viveda AS v ON j~matnr = v~matnrx
        INTO TABLE @DATA(li_society_info)
        WHERE j~identcode IN @lir_jrnl_code
         AND  j~idcodetype IN @lir_code
         AND  v~auart IN @lir_auart
         AND  v~pstyv IN @lir_pstyv.
      IF sy-subrc NE 0.
        MESSAGE e122(zqtc_r2) WITH 'Society Code'(001) INTO lst_bapiret-message.
        "No Subscription Order found based on Society Code
*      To update return table with messages
        PERFORM f_update_return CHANGING lst_bapiret
                                         fp_li_bapiret.
        RETURN.
      ELSE.
* BOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
        SORT li_society_info BY vbeln posnr.
        DELETE ADJACENT DUPLICATES FROM li_society_info COMPARING vbeln posnr.
* EOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
*      Populate subscription order table
        IF li_order_detail IS NOT INITIAL
         AND li_order IS NOT INITIAL
          AND lir_order_range IS NOT INITIAL.
          CLEAR: li_order_detail[], li_order[].

          LOOP AT li_society_info INTO DATA(lst_society).
            IF lst_society-vbeln IN lir_order_range.
              lst_order_detail-vbeln = lst_society-vbeln.
              lst_order_detail-posnr = lst_society-posnr.
              lv_order = lst_society-vbeln.
              APPEND lv_order TO li_order.
              APPEND lst_order_detail TO li_order_detail.
            ENDIF.
          ENDLOOP.
        ELSE.
          LOOP AT li_society_info INTO lst_society.
            lst_order_detail-vbeln = lst_society-vbeln.
            lst_order_detail-posnr = lst_society-posnr.
            lv_order = lst_society-vbeln.
            APPEND lv_order TO li_order.
            APPEND lst_order_detail TO li_order_detail.

*         Populate Order range table
            lst_order_range-sign = lc_sign.
            lst_order_range-option = lc_option.
            lst_order_range-low = lv_order.
            APPEND lst_order_range TO lir_order_range.
            CLEAR: lst_order_detail,lst_society,lv_order,lst_order_range.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

* BOI by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
  IF lir_payment IS NOT INITIAL.
* To Filter out the records in advance so that orders count will decrease.
* Also as per the current process payment rate will be entered along with others
* like Sub ref or soceity code.
    IF li_order_detail IS NOT INITIAL.
      SORT li_order_detail BY vbeln posnr.
      DELETE ADJACENT DUPLICATES FROM li_order_detail COMPARING vbeln posnr.
      SELECT vbeln,
             posnr,
             konda
             FROM vbkd
             INTO TABLE @DATA(li_konda)
             FOR ALL ENTRIES IN @li_order_detail
             WHERE vbeln = @li_order_detail-vbeln AND
               ( posnr = @li_order_detail-posnr OR
                 posnr = @lc_posnr ) .
      IF sy-subrc EQ 0.
        SORT li_konda BY vbeln posnr.
        DATA(li_order_tmp) = li_order_detail[].
        CLEAR: li_order[],
               lir_order_range[],
               li_order_detail[].

        LOOP AT li_order_tmp INTO DATA(lst_order_tmp).
          READ TABLE li_konda INTO DATA(lst_konda) WITH KEY vbeln = lst_order_tmp-vbeln
                                                            posnr = lst_order_tmp-posnr
                                                            BINARY SEARCH.
          IF sy-subrc EQ 0.
            IF lst_konda-konda IN lir_payment.
              lst_order_detail-vbeln = lv_order = lst_konda-vbeln.
              lst_order_detail-posnr = lst_konda-posnr.
              APPEND lv_order TO li_order.
              APPEND lst_order_detail TO li_order_detail.

*         Populate Order range table
              lst_order_range-sign = lc_sign.
              lst_order_range-option = lc_option.
              lst_order_range-low = lst_konda-vbeln.
              APPEND lst_order_range TO lir_order_range.
              CLEAR: lst_order_detail, lst_konda, lv_order, lst_order_range.
            ENDIF.
          ELSE.
            READ TABLE li_konda INTO lst_konda WITH KEY vbeln = lst_order_tmp-vbeln
                                                        posnr = lc_posnr
                                                        BINARY SEARCH.
            IF sy-subrc EQ 0.
              IF lst_konda-konda IN lir_payment.
                lst_order_detail-vbeln = lv_order = lst_konda-vbeln.
                lst_order_detail-posnr = lst_order_tmp-posnr.
                APPEND lv_order TO li_order.
                APPEND lst_order_detail TO li_order_detail.

*         Populate Order range table
                lst_order_range-sign = lc_sign.
                lst_order_range-option = lc_option.
                lst_order_range-low = lst_konda-vbeln.
                APPEND lst_order_range TO lir_order_range.
                CLEAR: lst_order_detail, lst_konda, lv_order, lst_order_range.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
* EOI by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383

*If im_smtp_adr is not initial
  IF fp_li_email IS NOT INITIAL.
    LOOP AT fp_li_email INTO DATA(lst_email_data).
      IF lst_email_data IS NOT INITIAL.
        lst_email_range-sign = lst_email_s_range-sign = lc_sign.
        lst_email_range-option = lst_email_s_range-option = lc_option.
        lst_email_range-low   = lst_email_data-email.
        lst_email_s_range-low = lst_email_data-email.

        TRANSLATE lst_email_range-low TO UPPER CASE.
        APPEND lst_email_range TO lir_email_range.
        CLEAR lst_email_range.

        TRANSLATE lst_email_s_range-low TO UPPER CASE.
        APPEND lst_email_s_range TO lir_email_s_range.
        CLEAR lst_email_s_range.
      ENDIF.
    ENDLOOP.

    IF lir_email_s_range IS NOT INITIAL.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* check if order data w.r.t Reference(IHREZ) exists or not
      IF li_order_detail IS INITIAL.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
        SELECT
         a~addrnumber,       " Address Number
         a~smtp_addr,        " Email ID
         v~vbeln,            " Subscription Order
         v~posnr             " Item Number
         FROM adr6 AS a
         INNER JOIN vbpa AS b ON a~addrnumber = b~adrnr
         INNER JOIN viveda AS v ON b~vbeln = v~vbeln
         INTO TABLE @DATA(li_email_info)
         WHERE a~smtp_srch IN @lir_email_s_range
         AND   b~parvw = @lc_parvw
         AND   v~auart IN @lir_auart
         AND   v~pstyv IN @lir_pstyv.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
      ELSE.
* Fetch customer address data
        SORT li_order_detail BY vbeln posnr.

        SELECT
          a~addrnumber,       " Address Number
          a~smtp_addr,        " Email ID
          v~vbeln,            " Subscription Order
          v~posnr             " Item Number
        FROM adr6 AS a
        INNER JOIN vbpa AS b ON a~addrnumber = b~adrnr
        INNER JOIN viveda AS v ON b~vbeln = v~vbeln
        INTO TABLE @li_email_info
        FOR ALL ENTRIES IN @li_order_detail
        WHERE a~smtp_srch IN @lir_email_s_range
        AND   b~parvw = @lc_parvw
        AND   v~vbeln = @li_order_detail-vbeln
        AND   v~posnr = @li_order_detail-posnr
        AND   v~auart IN @lir_auart
        AND   v~pstyv IN @lir_pstyv.

      ENDIF.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
      IF sy-subrc NE 0.
        MESSAGE e122(zqtc_r2) WITH 'Email Id'(002) INTO lst_bapiret-message.
*     No Subscription Order found for input Email Id
*      To update return table with messages
        PERFORM f_update_return CHANGING lst_bapiret
                                 fp_li_bapiret.
        RETURN.
      ELSE.
        LOOP AT li_email_info ASSIGNING FIELD-SYMBOL(<lst_email_info>).
          TRANSLATE <lst_email_info>-smtp_addr TO UPPER CASE.
        ENDLOOP.
        DELETE li_email_info WHERE smtp_addr NOT IN lir_email_range.
*      Populate Subscription Order
        IF li_order_detail IS NOT INITIAL
         AND li_order IS NOT INITIAL
          AND lir_order_range IS NOT INITIAL.
          CLEAR: li_order_detail[], li_order[].

          LOOP AT li_email_info INTO DATA(lst_email).
            IF lst_email-vbeln IN lir_order_range.
              lst_order_detail-vbeln = lst_email-vbeln.
              lst_order_detail-posnr = lst_email-posnr.
              lv_order = lst_email-vbeln.
              APPEND lv_order TO li_order.
              APPEND lst_order_detail TO li_order_detail.
            ENDIF.
          ENDLOOP.
        ELSE.
*        If this is the only import parameter
          LOOP AT li_email_info INTO lst_email.
            lst_order_detail-vbeln = lst_email-vbeln.
            lst_order_detail-posnr = lst_email-posnr.
            lv_order = lst_email-vbeln.
            APPEND lv_order TO li_order.
            APPEND lst_order_detail TO li_order_detail.
            lst_order_range-sign = lc_sign.
            lst_order_range-option = lc_option.
            lst_order_range-low = lv_order.
            APPEND lst_order_range TO lir_order_range.
            CLEAR: lst_order_detail,lst_email,lv_order,lst_order_range, lst_email.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.

* BOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
    SORT li_order_detail BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM li_order_detail COMPARING vbeln posnr.
    SORT lir_order_range BY sign option low.
    DELETE ADJACENT DUPLICATES FROM lir_order_range
                               COMPARING sign option low.
    SORT li_order BY vbeln.
    DELETE ADJACENT DUPLICATES FROM li_order COMPARING vbeln.
* EOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
  ENDIF.
***--BOC by GKAMMILI on 09-10-2020 for OTCM 13923
*  IF fp_li_quote IS NOT INITIAL.
*    SELECT
*          vbeln,      " Sales order
*          posnr       " Item Number
*        FROM viveda
*        INTO TABLE @DATA(li_quote_info)
*        FOR ALL ENTRIES IN @fp_li_quote
*        WHERE vbeln = @fp_li_quote-vbeln
*        AND   auart IN @lir_auart
*        AND   pstyv IN @lir_pstyv.
*    IF sy-subrc NE 0.
*        MESSAGE e122(zqtc_r2) WITH 'Quotation'(002) INTO lst_bapiret-message.
**     No Subscription Order found for input Email Id
**      To update return table with messages
*        PERFORM f_update_return CHANGING lst_bapiret
*                                 fp_li_bapiret.
*        RETURN.
*    ELSE.
**      Populate Subscription Order
*        IF li_order_detail IS NOT INITIAL
*         AND li_order IS NOT INITIAL
*          AND lir_order_range IS NOT INITIAL.
*          CLEAR: li_order_detail[], li_order[].
*
*          LOOP AT li_quote_info INTO DATA(lst_quotes).
*            IF lst_quotes-vbeln IN lir_order_range.
*              lst_order_detail-vbeln = lst_quotes-vbeln.
*              lst_order_detail-posnr = lst_quotes-posnr.
*              lv_order = lst_quotes-vbeln.
*              APPEND lv_order TO li_order.
*              APPEND lst_order_detail TO li_order_detail.
*            ENDIF.
*          ENDLOOP.
*        ELSE.
**        If this is the only import parameter
*          LOOP AT li_quote_info INTO lst_quotes.
*            lst_order_detail-vbeln = lst_quotes-vbeln.
*            lst_order_detail-posnr = lst_quotes-posnr.
*            lv_order = lst_quotes-vbeln.
*            APPEND lv_order TO li_order.
*            APPEND lst_order_detail TO li_order_detail.
*            lst_order_range-sign = lc_sign.
*            lst_order_range-option = lc_option.
*            lst_order_range-low = lv_order.
*            APPEND lst_order_range TO lir_order_range.
*            CLEAR: lst_order_detail,lst_quotes,lv_order,lst_order_range.
*          ENDLOOP.
*        ENDIF.
*    ENDIF.
*  ENDIF.
*  IF fp_li_postal IS NOT INITIAL." AND fp_im_sccode = 'CWS'.
*    LOOP AT fp_li_postal INTO DATA(lst_postal_data).
*      IF lst_postal_data IS NOT INITIAL.
*        lst_postal_range-sign   = lst_postal_s_range-sign = lc_sign.
*        lst_postal_range-option = lst_postal_s_range-option = lc_option.
*        lst_postal_range-low    = lst_postal_data-pcode.
*        lst_postal_s_range-low  = lst_postal_data-pcode.
*
**        TRANSLATE lst_postal_range-low TO UPPER CASE.
*        APPEND lst_postal_range TO lir_postal_range.
*        CLEAR lst_postal_range.
*
**        TRANSLATE lst_postal_s_range-low TO UPPER CASE.
*        APPEND lst_postal_s_range TO lir_postal_s_range.
*        CLEAR lst_postal_s_range.
*      ENDIF.
*    ENDLOOP.
*
*    IF lir_postal_s_range IS NOT INITIAL.
** check if order data w.r.t Reference(IHREZ) exists or not
*      IF li_order_detail IS INITIAL.
*        SELECT
*         a~addrnumber,       " Address Number
*         a~post_code1,        " Postal code
*         v~vbeln,            " Subscription Order
*         v~posnr             " Item Number
*         FROM adrc AS a
*         INNER JOIN vbpa AS b ON a~addrnumber = b~adrnr
*         INNER JOIN viveda AS v ON b~vbeln = v~vbeln
*         INTO TABLE @DATA(li_postal_info)
*         WHERE a~post_code1 IN @lir_postal_s_range
*         AND   b~parvw = @lc_parvw
*         AND   v~auart IN @lir_auart
*         AND   v~pstyv IN @lir_pstyv.
*      ELSE.
** Fetch customer address data
*        SORT li_order_detail BY vbeln posnr.
*
*        SELECT
*          a~addrnumber,       " Address Number
*          a~post_code1,        " Email ID
*          v~vbeln,            " Subscription Order
*          v~posnr             " Item Number
*        FROM adrc AS a
*        INNER JOIN vbpa AS b ON a~addrnumber = b~adrnr
*        INNER JOIN viveda AS v ON b~vbeln = v~vbeln
*        INTO TABLE @li_postal_info
*        FOR ALL ENTRIES IN @li_order_detail
*        WHERE a~post_code1 IN @lir_postal_s_range
*        AND   b~parvw = @lc_parvw
*        AND   v~vbeln = @li_order_detail-vbeln
*        AND   v~posnr = @li_order_detail-posnr
*        AND   v~auart IN @lir_auart
*        AND   v~pstyv IN @lir_pstyv.
*
*      ENDIF.
*      IF sy-subrc NE 0.
*        MESSAGE e122(zqtc_r2) WITH 'Postal Code'(002) INTO lst_bapiret-message.
**     No Subscription Order found for input Email Id
**      To update return table with messages
*        PERFORM f_update_return CHANGING lst_bapiret
*                                 fp_li_bapiret.
*        RETURN.
*      ELSE.
**        LOOP AT li_postal_info ASSIGNING FIELD-SYMBOL(<lst_postal_info>).
***          TRANSLATE <lst_postal_info>-smtp_addr TO UPPER CASE.
**        ENDLOOP.
*        DELETE li_postal_info WHERE post_code1 NOT IN lir_postal_range.
**      Populate Subscription Order
*        IF li_order_detail IS NOT INITIAL
*         AND li_order IS NOT INITIAL
*          AND lir_order_range IS NOT INITIAL.
*          CLEAR: li_order_detail[], li_order[].
*
*          LOOP AT li_postal_info INTO DATA(lst_postal).
*            IF lst_postal-vbeln IN lir_order_range.
*              lst_order_detail-vbeln = lst_postal-vbeln.
*              lst_order_detail-posnr = lst_postal-posnr.
*              lv_order = lst_postal-vbeln.
*              APPEND lv_order TO li_order.
*              APPEND lst_order_detail TO li_order_detail.
*            ENDIF.
*          ENDLOOP.
*        ELSE.
**        If this is the only import parameter
*          LOOP AT li_postal_info INTO lst_postal.
*            lst_order_detail-vbeln = lst_postal-vbeln.
*            lst_order_detail-posnr = lst_postal-posnr.
*            lv_order = lst_postal-vbeln.
*            APPEND lv_order TO li_order.
*            APPEND lst_order_detail TO li_order_detail.
*            lst_order_range-sign = lc_sign.
*            lst_order_range-option = lc_option.
*            lst_order_range-low = lv_order.
*            APPEND lst_order_range TO lir_order_range.
*            CLEAR: lst_order_detail,lst_postal,lv_order,lst_order_range, lst_postal.
*          ENDLOOP.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
*    SORT li_order_detail BY vbeln posnr.
*    DELETE ADJACENT DUPLICATES FROM li_order_detail COMPARING vbeln posnr.
*    SORT lir_order_range BY sign option low.
*    DELETE ADJACENT DUPLICATES FROM lir_order_range
*                               COMPARING sign option low.
*    SORT li_order BY vbeln.
*    DELETE ADJACENT DUPLICATES FROM li_order COMPARING vbeln.
*
*  ENDIF.
**--EOC by GKAMMILI on 09-10-2020 for OTCM 13923
* If contract date is not initial
  IF fp_im_cntrctdat IS NOT INITIAL
    AND fp_li_society IS NOT INITIAL.
* Begin of Code change for defect 1754
    CONCATENATE fp_im_cntrctdat+0(4) c_lstdayyr   INTO lv_strt_date.
    CONCATENATE fp_im_cntrctdat+0(4) c_frstdayyr  INTO lv_end_date.
* End of Code change for defect 1754
* BOC by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
*    SELECT
*       j~matnr,                 " Material
*       b~vbeln,
*       b~posnr,
*       v~vbeln AS order
*       FROM jptidcdassign AS j
*       INNER JOIN viveda AS b ON b~matnrx = j~matnr
*       INNER JOIN veda AS v ON v~vbeln = b~vbeln
*       INTO TABLE @DATA(li_societydate_info)
*       WHERE j~idcodetype IN @lir_code
*       AND   j~identcode IN @lir_jrnl_code
*       AND   b~auart IN @lir_auart
*       AND   b~pstyv IN @lir_pstyv
** Begin of Code change for defect 1754
**       AND   v~vbegdat <= @fp_im_cntrctdat
**       AND   v~venddat >= @fp_im_cntrctdat.
*       AND   v~vbegdat <= @lv_strt_date
*       AND   v~venddat >= @lv_end_date.
** End of Code change for defect 1754
    IF NOT li_order_detail[] IS INITIAL.
      SELECT vbeln,
             vposn,
             vbegdat,
             venddat
             INTO TABLE @DATA(li_societydate_info)
             FROM veda
             FOR ALL ENTRIES IN @li_order_detail
             WHERE vbeln = @li_order_detail-vbeln
               AND ( vposn = @li_order_detail-posnr
                OR vposn = @lc_posnr ).
* BOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
* This is commented out because there are scenarios where VEDA will have dates in
* header if line items are same so need to ensure that if the line item is present
* then we need to first validate line item if its in the range or not if not we can
* exclude line item directly else need to check the header dates and exclude.
* So this filteration will be done in the loop for each line item.
*               AND vbegdat <= @lv_strt_date
*               AND venddat >= @lv_end_date.
* EOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
* EOC by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
      IF sy-subrc NE 0.
        MESSAGE e122(zqtc_r2) WITH 'Contract Date and Society Code'(005) INTO lst_bapiret-message.
*      No Subscription Order found for input Contract Date and Society Code
*      To update return table with messages
        PERFORM f_update_return CHANGING lst_bapiret
                                         fp_li_bapiret.
        RETURN.
      ELSE.
*      Populate Subscription Order
        IF li_order_detail IS NOT INITIAL
          AND li_order IS NOT INITIAL.
* BOC by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
*        CLEAR: li_order_detail[], li_order[].
*
*        LOOP AT li_societydate_info INTO DATA(lst_date).
*          IF lst_date-vbeln IN lir_order_range.
*            lst_order_detail-vbeln = lst_date-vbeln.
*            lst_order_detail-posnr = lst_date-posnr.
*            APPEND lst_order_detail TO li_order_detail.
*            lv_order = lst_date-vbeln.
*            APPEND lv_order TO li_order.
*          ENDIF.
*        ENDLOOP.
          li_ord_dtl_tmp[] = li_order_detail[].
          SORT li_societydate_info BY vbeln vposn.
          CLEAR: li_order_detail[], li_order[].
* As VEDA will populate the item number only if the dates are different
* from the header else it will be with header record.
* BOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
* I have done code cleaning as the old code is not useful if needed please check in
* version management.
          LOOP AT li_ord_dtl_tmp INTO lst_ord_dtl_tmp.
*
            READ TABLE li_societydate_info INTO DATA(lst_date) WITH KEY vbeln = lst_ord_dtl_tmp-vbeln
                                                                        vposn = lst_ord_dtl_tmp-posnr
                                                                        BINARY SEARCH.
            IF sy-subrc EQ 0.
              IF lst_date-vbegdat <= lv_strt_date AND lst_date-venddat >= lv_end_date.
                lst_order_detail-vbeln = lst_date-vbeln.
                lst_order_detail-posnr = lst_date-vposn.
                APPEND lst_order_detail TO li_order_detail.
                lv_order = lst_date-vbeln.
                APPEND lv_order TO li_order.
              ENDIF.
            ELSE.
              READ TABLE li_societydate_info INTO lst_date WITH KEY vbeln = lst_ord_dtl_tmp-vbeln
                                                                    vposn = lc_posnr BINARY SEARCH.
              IF sy-subrc EQ 0.
                IF lst_date-vbegdat <= lv_strt_date AND lst_date-venddat >= lv_end_date.
                  lst_order_detail-vbeln = lst_date-vbeln.
                  lst_order_detail-posnr = lst_ord_dtl_tmp-posnr.
                  APPEND lst_order_detail TO li_order_detail.
                  lv_order = lst_date-vbeln.
                  APPEND lv_order TO li_order.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.
* EOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
* EOC by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
        ENDIF.
* BOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
        SORT li_order_detail BY vbeln posnr.
        DELETE ADJACENT DUPLICATES FROM li_order_detail COMPARING vbeln posnr.
        SORT li_order BY vbeln.
        DELETE ADJACENT DUPLICATES FROM li_order COMPARING vbeln.
* EOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
        CLEAR: lst_order_detail,lst_date,lv_order,lst_order_range.
      ENDIF.
    ENDIF.         " PBANDLAPAL ERP-5530
  ENDIF.

  IF li_order IS NOT INITIAL. "li_order contains only the subscription order number and not the line item
*    BOC by MODUTTA for CR#410
    SELECT
        vbeln,
        posnr,
        valid_from,
        valid_to,
        reason
        FROM jkseinterrupt
        INTO TABLE @li_jkseinterrupt
        FOR ALL ENTRIES IN @li_order
        WHERE vbeln = @li_order-vbeln.
    IF sy-subrc EQ 0.
      SORT li_jkseinterrupt BY vbeln posnr.
    ENDIF.
**   EOC by MODUTTA for CR#410
*
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
**    Populating BAPI_VIEW
*    lst_view-header = abap_true.
*    lst_view-item = abap_true.
*    lst_view-sdschedule = abap_true.
*    lst_view-business = abap_true.
*    lst_view-partner = abap_true.
*    lst_view-address = abap_true.
*    lst_view-status_h = abap_true.
*    lst_view-contract = abap_true.
** BOC by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
** As per the latest changes we don't need any document flow logic.
**    lst_view-flow = abap_true.
** EOC by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
**  BAPI to get details of sales order
*    CALL FUNCTION 'BAPISDORDER_GETDETAILEDLIST'
*      EXPORTING
*        i_bapi_view             = lst_view
** BOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
**       i_memory_read           = abap_true
** EOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
*      TABLES
*        sales_documents         = li_order
*        order_headers_out       = li_header
*        order_items_out         = li_item
*        order_schedules_out     = li_vbep
*        order_business_out      = li_vbkd
*        order_partners_out      = li_vbpa
*        order_address_out       = li_adrc
*        order_statusheaders_out = li_vbuk
** BOC by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
**       order_flows_out         = li_vbfa
** BOC by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
*        order_contracts_out     = li_veda.
*  ENDIF.
*BOC for CR# 410 by MODUTTA
*  IF li_vbuk IS NOT INITIAL.
*    SORT li_vbuk BY sd_doc.
*  ENDIF.
*
*  IF li_vbep IS NOT INITIAL.
*    SORT li_vbep BY doc_number itm_number.
*  ENDIF.
**EOC by MODUTTA for CR# 410
*
*  IF li_header IS NOT INITIAL.
*    SORT li_header BY doc_number.
*  ENDIF.
*
*  IF li_vbkd IS NOT INITIAL.
*    IF fp_li_payment IS NOT INITIAL.
*      SORT li_vbkd BY price_grp.
*      DELETE li_vbkd WHERE price_grp NOT IN lir_payment.
*    ENDIF.
*    IF fp_li_subtyp IS NOT INITIAL.
*      DELETE li_vbkd WHERE price_grp NOT IN lir_subtyp.
*    ENDIF.
*  ENDIF.
    SELECT a~vbeln,
           a~lifsk,
           b~cmgst
           INTO TABLE @DATA(li_vbuk_vbak)
           FROM vbak AS a
           INNER JOIN vbuk AS b ON a~vbeln = b~vbeln
           FOR ALL ENTRIES IN @li_order
           WHERE a~vbeln = @li_order-vbeln.
    IF sy-subrc EQ 0.
      SORT li_vbuk_vbak BY vbeln.
    ENDIF.
  ENDIF.
  IF li_order_detail IS NOT INITIAL.
    SELECT vbeln,
           posnr,
           lifsp
           INTO TABLE @DATA(li_vbep)
           FROM vbep
           FOR ALL ENTRIES IN @li_order_detail
           WHERE vbeln = @li_order_detail-vbeln AND
                 posnr = @li_order_detail-posnr.
    IF sy-subrc EQ 0.
      SORT li_vbep BY vbeln posnr.
    ENDIF.
    SELECT vbeln,
           posnr,
           konda,
           bsark,
           ihrez,
           ihrez_e
           INTO TABLE @DATA(li_vbkd)
           FROM vbkd
           FOR ALL ENTRIES IN @li_order_detail
           WHERE vbeln = @li_order_detail-vbeln AND
               ( posnr = @li_order_detail-posnr OR
                 posnr = @lc_posnr ) .
    IF sy-subrc EQ 0.
      IF fp_li_payment IS NOT INITIAL.
        SORT li_vbkd BY konda.
        DELETE li_vbkd WHERE konda NOT IN lir_payment.
      ENDIF.
      IF fp_li_subtyp IS NOT INITIAL.
        DELETE li_vbkd WHERE konda NOT IN lir_subtyp.
      ENDIF.
    ENDIF.
*
    SELECT vbeln,
           vposn,
           vbegdat,
           venddat
           INTO TABLE @DATA(li_veda)
           FROM veda
           FOR ALL ENTRIES IN @li_order_detail
           WHERE vbeln = @li_order_detail-vbeln AND
               ( vposn = @li_order_detail-posnr OR
                 vposn = @lc_posnr ) .
    IF sy-subrc EQ 0.
      SORT li_veda BY vbeln vposn.
    ENDIF.

*
    SELECT vbeln,
           posnr,
           matnr,
           arktx,
           uepos,
           abgru,
           mvgr5
          INTO TABLE @DATA(li_item)
           FROM vbap
           FOR ALL ENTRIES IN @li_order_detail
           WHERE vbeln = @li_order_detail-vbeln AND
                 posnr = @li_order_detail-posnr.
    IF sy-subrc EQ 0.
      SORT li_item BY vbeln posnr.
    ENDIF.
*
    lst_parvw-sign   =  lc_sign.
    lst_parvw-option =  lc_option.
    lst_parvw-low    = lc_parvw.
    APPEND lst_parvw TO lr_parvw.

    lst_parvw-low    = lc_parvw_ag.
    APPEND lst_parvw TO lr_parvw.
    CLEAR lst_parvw.

    SELECT vbeln,
           posnr,
           parvw,
           kunnr,
           adrnr
           FROM vbpa
           INTO TABLE @DATA(li_vbpa)
           FOR ALL ENTRIES IN @li_order_detail
             WHERE vbeln = @li_order_detail-vbeln AND
                 ( posnr = @li_order_detail-posnr OR
                   posnr = @lc_posnr )             AND
                   parvw IN @lr_parvw.
    IF sy-subrc EQ 0.
      SORT li_vbpa BY vbeln posnr.
    ENDIF.
  ENDIF.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329


*  To get society code of a subscription number
  DATA(li_item_temp) = li_item[].
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*  SORT li_item_temp BY doc_number itm_number material .
*  DELETE ADJACENT DUPLICATES FROM li_item_temp COMPARING doc_number itm_number material.
  SORT li_item_temp BY vbeln posnr matnr.
  DELETE ADJACENT DUPLICATES FROM li_item_temp COMPARING vbeln posnr matnr.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
  IF li_item_temp IS NOT INITIAL.
    SELECT
      j~matnr,
      j~identcode
      FROM jptidcdassign AS j
      INTO TABLE @DATA(li_identcode)
      FOR ALL ENTRIES IN @li_item_temp
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*      WHERE matnr = @li_item_temp-material
      WHERE matnr = @li_item_temp-matnr
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
       AND  idcodetype IN @lir_code.
    IF sy-subrc EQ 0.
      LOOP AT li_identcode INTO DATA(lst_identcode).
        lst_identcode_range-sign = lc_sign.
        lst_identcode_range-option = lc_option_cp.
        CLEAR lv_idcode.
        lv_idcode = lst_identcode-identcode.
        SHIFT lv_idcode+0(4) LEFT DELETING LEADING '0'.

        lst_identcode_range-low  = lv_idcode+0(4).
        APPEND lst_identcode_range TO lir_identcode.
        CLEAR lst_identcode.
      ENDLOOP.
    ENDIF.
    IF lir_identcode IS NOT INITIAL.
      SELECT
         jrnl_grp_code,
         society,
         society_acrnym
         FROM zqtc_jgc_society
         INTO TABLE @DATA(li_jgc_society)
         WHERE jrnl_grp_code IN @lir_identcode
           AND digital_relevant = @abap_true.
      IF sy-subrc EQ 0.
        SORT li_jgc_society BY jrnl_grp_code.
        CLEAR lst_society_data.
        LOOP AT li_jgc_society INTO DATA(lst_society_knr).
*        Populate society
          lst_society_range-sign = lc_sign.
          lst_society_range-option = lc_option.
          lst_society_range-low = lst_society_knr-society.
          APPEND lst_society_range TO lir_society.
          CLEAR: lst_society_range,lst_society_knr.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.

*  Fetch membership category from TBZ9A
  IF li_vbpa IS NOT INITIAL.
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*    SORT li_vbpa BY partn_role.
*    DELETE li_vbpa WHERE partn_role <> lc_parvw
*                     AND  partn_role <> lc_parvw_ag.
*    DATA(li_vbpa_tmp) = li_vbpa.
*    DELETE li_vbpa_tmp WHERE partn_role <> lc_parvw.
*    SORT li_vbpa_tmp BY customer.
*    DELETE ADJACENT DUPLICATES FROM li_vbpa_tmp COMPARING customer.
    DATA(li_vbpa_tmp) = li_vbpa.
    SORT li_vbpa_tmp BY kunnr.
    DELETE ADJACENT DUPLICATES FROM li_vbpa_tmp COMPARING kunnr.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
    IF li_vbpa_tmp IS NOT INITIAL.
      SELECT
        b~partner1, "partner1
        t~spras,    " Language   "Insert by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
        t~rtitl    " Title
        FROM but050 AS b
        INNER JOIN tbz9a AS t ON b~reltyp = t~reltyp
        INTO TABLE @DATA(li_membercat)
        FOR ALL ENTRIES IN @li_vbpa_tmp
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*        WHERE b~partner1 = @li_vbpa_tmp-customer
        WHERE b~partner1 = @li_vbpa_tmp-kunnr
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
        AND   b~partner2 IN @lir_society.
* BOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
*        AND   t~spras = @sy-langu.
* EOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
      IF sy-subrc EQ 0.
* BOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
*        SORT li_membercat BY partner1.
        SORT li_membercat BY partner1 spras.
* EOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
      ENDIF.
* BOI by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
* To get the customer language based on that all the texts are displayed in
* customer language.
      SELECT kunnr,
             spras
             FROM kna1
             INTO TABLE @DATA(li_kna1)
             FOR ALL ENTRIES IN @li_vbpa_tmp
             WHERE kunnr = @li_vbpa_tmp-kunnr.
      IF sy-subrc EQ 0.
        SORT li_kna1 BY kunnr.
      ENDIF.
* EOI by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
    ENDIF.

* To use the table for delete adjacent and use in for all entries
    CLEAR li_vbpa_tmp.
    li_vbpa_tmp[] = li_vbpa[].
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*    SORT li_vbpa_tmp BY address.
*    DELETE ADJACENT DUPLICATES FROM li_vbpa_tmp COMPARING address.
    SORT li_vbpa_tmp BY adrnr.
    DELETE ADJACENT DUPLICATES FROM li_vbpa_tmp COMPARING adrnr.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
    IF li_vbpa_tmp IS NOT INITIAL.
* BOI by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
      SELECT addrnumber,
             title,
             name1,
             name2,
             street,
             city1,
             country,
             langu,
             post_code1,
             tel_number,
             fax_number
             INTO TABLE @DATA(li_adrc)
             FROM adrc " as a INNER JOIN kna1 as b On a~adrnr = b~adrnr
             FOR ALL ENTRIES IN @li_vbpa_tmp
             WHERE addrnumber = @li_vbpa_tmp-adrnr.
      IF sy-subrc EQ 0.
        SORT li_adrc BY addrnumber.
      ENDIF.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329

      SELECT
        a~addrnumber,       " Address number
        a~smtp_addr,         " Email
        a~smtp_srch
        FROM adr6 AS a
        INTO TABLE @DATA(li_adr6)
        FOR ALL ENTRIES IN @li_vbpa_tmp
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*        WHERE a~addrnumber = @li_vbpa_tmp-address.
        WHERE a~addrnumber = @li_vbpa_tmp-adrnr.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
      IF sy-subrc EQ 0 AND lir_email_s_range IS NOT INITIAL.
        DELETE li_adr6 WHERE smtp_srch NOT IN lir_email_s_range.
      ENDIF.
    ENDIF.

    IF li_adrc IS NOT INITIAL.
      SORT li_adrc BY country.
      SELECT
        t~spras,
        t~land1,
        t~landx50      " Country Name
        FROM t005t AS t
        INTO TABLE @DATA(li_t005t)
        FOR ALL ENTRIES IN @li_adrc
        WHERE land1 = @li_adrc-country.
*        AND   t~spras = @sy-langu. " comment by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
      IF sy-subrc EQ 0.
        SORT li_t005t BY spras land1.
      ENDIF.
    ENDIF.
* BOI by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
    DATA(li_adrc_title) = li_adrc[].
    DELETE li_adrc_title WHERE title IS INITIAL.
    SORT li_adrc_title BY title.
    DELETE ADJACENT DUPLICATES FROM li_adrc_title COMPARING title.
    IF li_adrc_title IS NOT INITIAL.
      SELECT langu,      "Insert by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
             title,
             title_medi
             FROM tsad3t
             INTO TABLE @DATA(li_tsad3t)
             FOR ALL ENTRIES IN @li_adrc_title
             WHERE title = @li_adrc_title-title.
      IF sy-subrc EQ 0.
* BOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
*        SORT li_tsad3t BY title.
        SORT li_tsad3t BY langu title.
* EOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
      ENDIF.

    ENDIF.
* EOI by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
  ENDIF.

* BOC by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
* As per the CR#388 this code is not needed any more as there is no logic
* to check on VBFA and BSID.
*  IF li_vbfa IS NOT INITIAL.
**    To use the internal table in for all entries we have to sort and delete adjacent duplicate
*    DATA(li_vbfa_tmp) = li_vbfa[].
*    SORT li_vbfa_tmp BY sd_doc.
*    DELETE ADJACENT DUPLICATES FROM li_vbfa_tmp COMPARING sd_doc.
*    SELECT
*      v~belnr,
*      b~augbl
*      FROM vbrk AS v
*      INNER JOIN bsid AS b ON v~belnr = b~belnr
*      INTO TABLE @DATA(li_vbrk_bsid)
*      FOR ALL ENTRIES IN @li_vbfa_tmp
*      WHERE v~vbeln = @li_vbfa_tmp-sd_doc.
*    IF sy-subrc EQ 0
*     AND fp_im_pymnt_sts IS NOT INITIAL.
*      SORT li_vbrk_bsid BY augbl.
*      DELETE li_vbrk_bsid WHERE augbl <> fp_im_pymnt_sts.
*    ENDIF.
*  ENDIF.
* EOC by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942

*  Population of final output table
  CLEAR lst_order_detail.
  IF li_order_detail IS NOT INITIAL.
    SORT li_order_detail BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM li_order_detail COMPARING vbeln posnr.
*<<<<<<<<<<<<<BOC by MODUTTA on 25/05/2017 for CR# 524>>>>>>>>>>>>>>>>>>>>>>>>>>
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*    DATA(li_item_tmp) = li_item[].
*    SORT li_item_tmp BY material.
*    DELETE ADJACENT DUPLICATES FROM li_item_tmp COMPARING material.
    DATA(li_item_tmp) = li_item[].
    SORT li_item_tmp BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_item_tmp COMPARING matnr.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329

    IF lir_media IS NOT INITIAL.
      SELECT matnr,
             ismmediatype
        FROM mara
        INTO TABLE @DATA(li_mara)
        FOR ALL ENTRIES IN @li_item_tmp
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*        WHERE matnr = @li_item_tmp-material
        WHERE matnr = @li_item_tmp-matnr
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
        AND   ismmediatype IN @lir_media.
      IF sy-subrc EQ 0.
        SORT li_mara BY matnr.
        LOOP AT li_mara INTO DATA(lst_mara).
          lst_mara_rng-sign = lc_sign.
          lst_mara_rng-option = lc_option.
          lst_mara_rng-low = lst_mara-matnr.
          APPEND lst_mara_rng TO lir_mara.
          CLEAR lst_mara_rng.
        ENDLOOP.
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*        DELETE li_item WHERE material NOT IN lir_mara.
        DELETE li_item WHERE matnr NOT IN lir_mara.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Get Media type description
        DATA(li_mara_tmp) = li_mara.
        SORT li_mara_tmp BY ismmediatype.
        DELETE ADJACENT DUPLICATES FROM li_mara_tmp COMPARING ismmediatype.
        DELETE li_mara_tmp WHERE ismmediatype IS INITIAL.
        IF li_mara_tmp IS NOT INITIAL.
          SELECT ismmediatype,
                 bezeichnung
            FROM tjpmedtpt
            INTO TABLE @DATA(li_mediatyp)
            FOR ALL ENTRIES IN @li_mara_tmp
            WHERE ismmediatype = @li_mara_tmp-ismmediatype
              AND spras = @lv_dflt_langu.
          IF sy-subrc EQ 0.
            SORT li_mediatyp BY ismmediatype.
          ENDIF.
        ENDIF.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
      ENDIF.
    ENDIF.
*<<<<<<<<<<<<<EOC by MODUTTA on 25/05/2017 for CR# 524>>>>>>>>>>>>>>>>>>>>>>>>>>
*    Sorting all the internal table
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*    SORT li_veda BY doc_number itm_number.
*    SORT li_vbkd BY sd_doc itm_number.
*    SORT li_adrc BY address langu.
*    SORT li_adr6 BY addrnumber.
*    SORT li_adrc BY address langu.
*    SORT li_vbpa BY sd_doc itm_number partn_role.
*    SORT li_jgc_society BY jrnl_grp_code.
*    SORT li_item BY doc_number itm_number.
    SORT li_vbkd BY vbeln posnr.
    SORT li_adrc BY addrnumber. "Change by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
    SORT li_adr6 BY addrnumber.
    SORT li_vbpa BY vbeln posnr parvw.
    SORT li_jgc_society BY jrnl_grp_code.
    SORT li_item BY vbeln posnr.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
    SORT li_identcode BY matnr.

    LOOP AT li_order_detail INTO lst_order_detail.
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*      READ TABLE li_header INTO DATA(lst_header) WITH KEY doc_number = lst_order_detail-vbeln
*                                                          BINARY SEARCH.
*      IF sy-subrc EQ 0.
**     Subscription Number (VBELN)
*        lst_final-vbeln = lst_header-doc_number.
*      ENDIF.

*      READ TABLE li_item INTO DATA(lst_item) WITH KEY doc_number = lst_order_detail-vbeln
*                                                      itm_number = lst_order_detail-posnr
*                                                       BINARY SEARCH.
*      IF sy-subrc EQ 0.
*        CLEAR lst_identcode.
*
*        READ TABLE li_identcode INTO lst_identcode WITH KEY matnr = lst_item-material BINARY SEARCH.
*     Subscription Number (VBELN)
      lst_final-vbeln = lst_order_detail-vbeln.
      READ TABLE li_item INTO DATA(lst_item) WITH KEY vbeln = lst_order_detail-vbeln
                                                      posnr = lst_order_detail-posnr
                                                     BINARY SEARCH.
      IF sy-subrc EQ 0.
        CLEAR lst_identcode.

        READ TABLE li_identcode INTO lst_identcode WITH KEY matnr = lst_item-matnr BINARY SEARCH.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
        IF sy-subrc EQ 0.
          CLEAR lv_jgrp_code.
          lv_jgrp_code = lst_identcode-identcode.
          SHIFT lv_jgrp_code+0(4) LEFT DELETING LEADING '0'.
*          READ TABLE li_jgc_society INTO DATA(lst_jgc_society) WITH KEY jrnl_grp_code = lst_identcode-identcode+0(4) BINARY SEARCH.
          READ TABLE li_jgc_society INTO DATA(lst_jgc_society) WITH KEY jrnl_grp_code = lv_jgrp_code+0(4) BINARY SEARCH.
          IF sy-subrc EQ 0.
            lst_final-sccode = lst_jgc_society-society_acrnym.
          ENDIF.
        ENDIF.
*     Deal Description(ARKTX)
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*        IF lst_item-hg_lv_item > 0.
*          READ TABLE li_item INTO DATA(lst_item1) WITH KEY doc_number = lst_order_detail-vbeln
*                                                           itm_number = lst_item-hg_lv_item
*                                                           BINARY SEARCH.
*          IF sy-subrc EQ 0.
*            lst_final-arktx = lst_item1-short_text.
*          ENDIF.
*        ENDIF.

        IF lst_item-uepos > 0.
          READ TABLE li_item INTO DATA(lst_item1) WITH KEY vbeln = lst_order_detail-vbeln
                                                           posnr = lst_item-uepos
                                                           BINARY SEARCH.
          IF sy-subrc EQ 0.
            lst_final-arktx = lst_item1-arktx.
          ENDIF.
        ENDIF.

*       Double Billing
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*        IF lst_item-prc_group5 IN lir_mvgr5_1.
*          lst_final-double_bill = lc_yes.
*        ELSEIF  lst_item-prc_group5 IN lir_mvgr5_2.
*          lst_final-double_bill = lc_no.
*        ENDIF.
*       Double Billing
        IF lst_item-mvgr5 IN lir_mvgr5_1.
          lst_final-double_bill = lc_yes.
        ELSEIF  lst_item-mvgr5 IN lir_mvgr5_2.
          lst_final-double_bill = lc_no.
        ENDIF.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329

        CLEAR lv_flag.
*    Think Cust Id
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*        READ TABLE li_vbpa INTO DATA(lst_vbpa) WITH KEY sd_doc = lst_item-doc_number
*                                                        itm_number = lst_item-itm_number
*                                                        partn_role = lc_parvw
        READ TABLE li_vbpa INTO DATA(lst_vbpa) WITH KEY vbeln = lst_item-vbeln
                                                        posnr = lst_item-posnr
                                                        parvw = lc_parvw
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
                                                        BINARY SEARCH.
        IF sy-subrc EQ 0.
          lv_flag = abap_true.
        ELSE.
          CLEAR lst_vbpa.
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*          READ TABLE li_vbpa INTO lst_vbpa WITH KEY sd_doc = lst_item-doc_number
*                                                    itm_number = lc_posnr
*                                                    partn_role = lc_parvw
*                                                    BINARY SEARCH.
          READ TABLE li_vbpa INTO lst_vbpa   WITH KEY vbeln = lst_item-vbeln
                                                      posnr = lc_posnr
                                                      parvw = lc_parvw
                                                      BINARY SEARCH.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
          IF sy-subrc EQ 0.
            lv_flag = abap_true.
          ENDIF.
        ENDIF.

        IF lv_flag IS NOT INITIAL.
*        Cust Id
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*          lst_final-kunnr = lst_vbpa-customer.
**        Membership Category population(RTITL)
*          READ TABLE li_membercat INTO DATA(lst_membercat) WITH KEY partner1 = lst_vbpa-customer
*        Cust Id
          lst_final-kunnr = lst_vbpa-kunnr.
          READ TABLE li_kna1 INTO DATA(lst_kna1) WITH KEY kunnr = lst_vbpa-kunnr BINARY SEARCH.
*        Membership Category population(RTITL)
          READ TABLE li_membercat INTO DATA(lst_membercat) WITH KEY partner1 = lst_vbpa-kunnr
                                                                    spras    = lst_kna1-spras
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
                                                                    BINARY SEARCH.
          IF sy-subrc EQ 0.
*          Membership Category
            lst_final-rtitl = lst_membercat-rtitl.
* BOI by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
          ELSE.
            READ TABLE li_membercat INTO lst_membercat WITH KEY partner1 = lst_vbpa-kunnr
                                                                spras    = lv_dflt_langu
                                                                BINARY SEARCH.
            IF sy-subrc EQ 0.
*          Membership Category
              lst_final-rtitl = lst_membercat-rtitl.
            ENDIF.
* EOI by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
          ENDIF.

*        Address Population
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
**ADDRNUMBER
*          READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY address = lst_vbpa-address
*                                                          langu = sy-langu
*                                                          BINARY SEARCH.
*
*          IF sy-subrc EQ 0.
**            Address1
*            CONCATENATE lst_adrc-formofaddr lst_adrc-name INTO DATA(lv_string) SEPARATED BY space.
*            lst_final-title_medi = lv_string.
*
**            BOC for CR#388 by MODUTTA
**            Title Text
*            lst_final-title_text = lst_adrc-formofaddr.
*
**            First Name
*            lst_final-first_name = lst_adrc-name.
*
**            Last Name
*            lst_final-last_name = lst_adrc-name_2.
**            EOC for CR#388 by MODUTTA
*
**          Address4
*            lst_final-street = lst_adrc-street.
**          Address5
*            lst_final-city1 = lst_adrc-city.
**          Country
*            lst_final-country = lst_adrc-country.
**          Postal Code
*            lst_final-post_code1 = lst_adrc-postl_code.
**          Telephone
*            lst_final-tel_number = lst_adrc-telephone.
**          Fax Number
*            lst_final-fax_number = lst_adrc-fax_number.
          READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = lst_vbpa-adrnr
*                                                          langu = sy-langu  "Comment by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
                                                          BINARY SEARCH.

          IF sy-subrc EQ 0.
*            Address1
* BOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
*            READ TABLE li_tsad3t INTO DATA(lst_tsad3t) WITH KEY title = lst_adrc-title
            READ TABLE li_tsad3t INTO DATA(lst_tsad3t) WITH KEY langu = lst_kna1-spras
                                                                title = lst_adrc-title
* EOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
                                                       BINARY SEARCH.
            IF sy-subrc EQ 0.
*            Title Text
              lst_final-title_text = lst_tsad3t-title_medi.
              CONCATENATE lst_tsad3t-title_medi lst_adrc-name1 INTO DATA(lv_string) SEPARATED BY space.
              lst_final-title_medi = lv_string.
            ELSE.
* BOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
              READ TABLE li_tsad3t INTO lst_tsad3t WITH KEY langu = lv_dflt_langu
                                                            title = lst_adrc-title
                                                            BINARY SEARCH.
              IF sy-subrc EQ 0.
*            Title Text
                lst_final-title_text = lst_tsad3t-title_medi.
                CLEAR lv_string.
                CONCATENATE lst_tsad3t-title_medi lst_adrc-name1 INTO lv_string SEPARATED BY space.
                lst_final-title_medi = lv_string.
              ELSE.
* EOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
                lst_final-title_medi = lst_adrc-name1.
              ENDIF.
            ENDIF.                " Insert by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
*            First Name
            lst_final-first_name = lst_adrc-name1.

*            Last Name
            lst_final-last_name = lst_adrc-name2.

*          Address4
            lst_final-street = lst_adrc-street.
*          Address5
            lst_final-city1 = lst_adrc-city1.
*          Country
            lst_final-country = lst_adrc-country.
*          Postal Code
            lst_final-post_code1 = lst_adrc-post_code1.
*          Telephone
            lst_final-tel_number = lst_adrc-tel_number.
*          Fax Number
            lst_final-fax_number = lst_adrc-fax_number.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329

*          Country
* BOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
*            READ TABLE li_t005t INTO DATA(lst_t005t) WITH KEY spras = sy-langu
            READ TABLE li_t005t INTO DATA(lst_t005t) WITH KEY spras = lst_kna1-spras
* EOC by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
                                                              land1 = lst_adrc-country
                                                              BINARY SEARCH.
            IF sy-subrc EQ 0.
              lst_final-landx50 = lst_t005t-landx50.
* BOI by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
            ELSE.
** Binary Search is not used as we want to take any first language that is existing for that country.
              READ TABLE li_t005t INTO lst_t005t  WITH KEY  spras = lv_dflt_langu
                                                            land1 = lst_adrc-country.
              IF sy-subrc EQ 0.
                lst_final-landx50 = lst_t005t-landx50.
              ENDIF.
* EOI by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
            ENDIF.
          ENDIF.
*        Email Address
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*          READ TABLE li_adr6 INTO DATA(lst_adr6) WITH KEY addrnumber = lst_vbpa-address BINARY SEARCH.
          READ TABLE li_adr6 INTO DATA(lst_adr6) WITH KEY addrnumber = lst_vbpa-adrnr BINARY SEARCH.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
          IF sy-subrc EQ 0.
*          Email
            lst_final-smtp_addr = lst_adr6-smtp_addr.
          ENDIF.
        ENDIF.

*      Department & Company Population
        CLEAR:lv_flag, lst_vbpa.
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*        READ TABLE li_vbpa INTO lst_vbpa WITH KEY sd_doc = lst_item-doc_number
*                                                  itm_number = lst_item-itm_number
*                                                  partn_role = lc_parvw_ag
*                                                  BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          lv_flag = abap_true.
*        ELSE.
*          READ TABLE li_vbpa INTO lst_vbpa WITH KEY sd_doc = lst_item-doc_number
*                                                    itm_number = lc_posnr
*                                                    partn_role = lc_parvw_ag
        READ TABLE li_vbpa INTO lst_vbpa WITH KEY vbeln = lst_item-vbeln
                                                  posnr = lst_item-posnr
                                                  parvw = lc_parvw_ag
                                                  BINARY SEARCH.
        IF sy-subrc EQ 0.
          lv_flag = abap_true.
        ELSE.
          READ TABLE li_vbpa INTO lst_vbpa WITH KEY vbeln = lst_item-vbeln
                                                    posnr = lc_posnr
                                                    parvw = lc_parvw_ag
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
                                                  BINARY SEARCH.
          IF sy-subrc EQ 0.
            lv_flag = abap_true.
          ENDIF.
        ENDIF.
        IF lv_flag IS NOT INITIAL.
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*          IF lst_vbpa-customer <> lst_final-kunnr.
*            CLEAR lst_adrc.
*            READ TABLE li_adrc INTO lst_adrc WITH KEY
*                                        address = lst_vbpa-address
*                                        langu = sy-langu
*                                        BINARY SEARCH.
*            IF sy-subrc EQ 0.
**            Department(NAME1)
*              lst_final-name1 = lst_adrc-name.
**            Company(Name2)
*              lst_final-name2 = lst_adrc-name_2.
**            Address2
*              lst_final-name11 = lst_adrc-name.
**            Address3
*              lst_final-name21 = lst_adrc-name_2.
*            ENDIF.
*          ENDIF.
          IF lst_vbpa-kunnr <> lst_final-kunnr.
            CLEAR lst_adrc.
            READ TABLE li_adrc INTO lst_adrc WITH KEY
                                        addrnumber = lst_vbpa-adrnr
*                                        langu = sy-langu    "Comment by PBANDLAPAL on 19-Jan-2018 for ERP-5596: ED2K910383
                                        BINARY SEARCH.
            IF sy-subrc EQ 0.
*            Department(NAME1)
              lst_final-name1 = lst_adrc-name1.
*            Company(Name2)
              lst_final-name2 = lst_adrc-name2.
*            Address2
              lst_final-name11 = lst_adrc-name1.
*            Address3
              lst_final-name21 = lst_adrc-name2.
            ENDIF.
          ENDIF.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
        ENDIF.

        CLEAR lv_flag.
*      Payment Rate
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*        READ TABLE li_vbkd INTO DATA(lst_vbkd) WITH KEY sd_doc = lst_item-doc_number
*                                                        itm_number = lst_item-itm_number
*                                                        BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          lv_flag = abap_true.
*        ELSE.
*          READ TABLE li_vbkd INTO lst_vbkd WITH KEY sd_doc = lst_item-doc_number
*                                                    itm_number = lc_posnr
        READ TABLE li_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_item-vbeln
                                                        posnr = lst_item-posnr
                                                        BINARY SEARCH.
        IF sy-subrc EQ 0.
          lv_flag = abap_true.
        ELSE.
          READ TABLE li_vbkd INTO lst_vbkd WITH KEY vbeln = lst_item-vbeln
                                                    posnr = lc_posnr
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
                                                    BINARY SEARCH.
          IF sy-subrc EQ 0.
            lv_flag = abap_true.
          ENDIF.
        ENDIF.

        IF lv_flag IS NOT INITIAL.
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
**        Membership Deal
*          lst_final-ihrez = lst_vbkd-ref_1.
*
**          Your reference
*          lst_final-ihrez_e = lst_vbkd-ref_1_s. "Added by MODUTTA for CR# 338
*
**        Payment rate
**        IF lir_payment IS NOT INITIAL.
*          IF lst_vbkd-price_grp = lc_konda_01.
*            lst_final-payment_rate = lc_payment_c.
*          ELSEIF lst_vbkd-price_grp = lc_konda_02.
*            lst_final-payment_rate = lc_payment_m.
*          ELSEIF lst_vbkd-price_grp = lc_konda_03.
*            lst_final-payment_rate = lc_payment_f.
*          ELSEIF lst_vbkd-price_grp = lc_konda_04.
*            lst_final-payment_rate = lc_payment_p.
*          ENDIF.
**        ENDIF.
*          IF lst_vbkd-po_method = lc_bsark.
**         Subscription type
*            lst_final-subtype_code = lc_payment_e.
*          ELSE.
*            IF lst_vbkd-price_grp = lc_konda_01.
*              lst_final-subtype_code = lc_payment_c.
*            ELSEIF lst_vbkd-price_grp = lc_konda_02.
*              lst_final-subtype_code = lc_payment_m.
*            ELSEIF lst_vbkd-price_grp = lc_konda_03.
*              lst_final-subtype_code = lc_payment_f.
*            ENDIF.
*          ENDIF.
*        Membership Deal
          lst_final-ihrez = lst_vbkd-ihrez.

*          Your reference
          lst_final-ihrez_e = lst_vbkd-ihrez_e.

*        Payment rate
          IF lst_vbkd-konda = lc_konda_01.
            lst_final-payment_rate = lc_payment_c.
          ELSEIF lst_vbkd-konda = lc_konda_02.
            lst_final-payment_rate = lc_payment_m.
          ELSEIF lst_vbkd-konda = lc_konda_03.
            lst_final-payment_rate = lc_payment_f.
          ELSEIF lst_vbkd-konda = lc_konda_04.
            lst_final-payment_rate = lc_payment_p.
          ENDIF.
*        ENDIF.
          IF lst_vbkd-bsark = lc_bsark.
*         Subscription type
            lst_final-subtype_code = lc_payment_e.
          ELSE.
            IF lst_vbkd-konda = lc_konda_01.
              lst_final-subtype_code = lc_payment_c.
            ELSEIF lst_vbkd-konda = lc_konda_02.
              lst_final-subtype_code = lc_payment_m.
            ELSEIF lst_vbkd-konda = lc_konda_03.
              lst_final-subtype_code = lc_payment_f.
            ENDIF.
          ENDIF.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
        ENDIF.

**      Contract Details
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*        READ TABLE li_veda INTO DATA(lst_veda) WITH KEY doc_number = lst_item-doc_number
*                                                        itm_number = lst_item-itm_number
*                                                        BINARY SEARCH.
*        IF sy-subrc EQ 0.
**        Contract Start date
*          lst_final-vbegdat = lst_veda-contstadat.
**        Contract End Date
*          lst_final-venddat = lst_veda-contenddat.
*        ELSE.
*          READ TABLE li_veda INTO DATA(lst_veda1) WITH KEY doc_number = lst_item-doc_number
*                                                           itm_number = ''
*                                                           BINARY SEARCH.
*          IF sy-subrc EQ 0.
**        Contract Start date
*            lst_final-vbegdat = lst_veda1-contstadat.
**        Contract End Date
*            lst_final-venddat = lst_veda1-contenddat.
*          ENDIF.
*        ENDIF.
        READ TABLE li_veda INTO DATA(lst_veda) WITH KEY vbeln = lst_item-vbeln
                                                        vposn = lst_item-posnr
                                                        BINARY SEARCH.
        IF sy-subrc EQ 0.
*        Contract Start date
          lst_final-vbegdat = lst_veda-vbegdat.
*        Contract End Date
          lst_final-venddat = lst_veda-venddat.
        ELSE.
          READ TABLE li_veda INTO DATA(lst_veda1) WITH KEY vbeln = lst_item-vbeln
                                                           vposn = lc_posnr
                                                           BINARY SEARCH.
          IF sy-subrc EQ 0.
*        Contract Start date
            lst_final-vbegdat = lst_veda1-vbegdat.
*        Contract End Date
            lst_final-venddat = lst_veda1-venddat.
          ENDIF.
        ENDIF.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329

*      Payment Status
* BOC by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
* As per CR#388 it has been decided to always pass the value as P as legacy system needs.
* No filteration is been done on this later.
*        lst_final-pymnt_sts = lc_paid. "Added by MODUTTA for CR# 338
        lst_final-pymnt_sts = lv_paymnt_sts.
* EOC by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942

******************************************************************************************
*Commented by MODUTTA for CR# 338
*        SORT li_vbfa BY precsddoc preditdoc doccategor.
*        READ TABLE li_vbfa INTO DATA(lst_vbfa) WITH KEY precsddoc = lst_item-doc_number
*                                                        preditdoc = lst_item-itm_number
*                                                        doccategor = lc_doc_m
*                                                        BINARY SEARCH.
*        IF sy-subrc EQ 0.
*          READ TABLE li_vbrk_bsid INTO DATA(lst_vbrk_bsid) WITH KEY belnr = lst_vbfa-sd_doc.
*          IF sy-subrc EQ 0.
*            IF lst_vbrk_bsid-augbl IS NOT INITIAL.
*              lst_final-pymnt_sts = lc_paid.
*            ELSE.
*              lst_final-pymnt_sts = lc_open.
*            ENDIF.
*          ELSE.
*            lst_final-pymnt_sts = lc_open.
*          ENDIF.
*        ELSE.
*          lst_final-pymnt_sts = lc_open.
*        ENDIF.
********************************************************************************************
*     Update date
        lst_final-update_date = sy-datum.

*      Cancellation Code
*  Commented by MODUTTA for CR#410
*        lst_final-vkuegru = lst_item-rea_for_re.
*  END of Comment
*        BOC by MODUTTA for CR# 410

* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*        READ TABLE li_vbuk INTO DATA(lst_vbuk) WITH KEY sd_doc = lst_item-doc_number
*                                                        BINARY SEARCH.
*        IF sy-subrc EQ 0
*          AND lst_vbuk-totstatcch = lc_cmgst.
        READ TABLE li_vbuk_vbak INTO DATA(lst_vbuk_vbak) WITH KEY vbeln = lst_item-vbeln
                                                        BINARY SEARCH.
        IF sy-subrc EQ 0
          AND lst_vbuk_vbak-cmgst = lc_cmgst.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
          lst_final-vkuegru = lc_yes.
        ELSE.
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*          IF lst_item-rea_for_re IS NOT INITIAL.
*            lst_final-vkuegru = lc_yes.
*          ELSE.
*            READ TABLE li_jkseinterrupt INTO DATA(lst_jkseinterrupt) WITH KEY vbeln = lst_item-doc_number
*                                                                              posnr = lst_item-itm_number
          IF lst_item-abgru IS NOT INITIAL.
            lst_final-vkuegru = lc_yes.
          ELSE.
            READ TABLE li_jkseinterrupt INTO DATA(lst_jkseinterrupt) WITH KEY vbeln = lst_item-vbeln
                                                                              posnr = lst_item-posnr
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
                                                                              BINARY SEARCH.
            IF sy-subrc EQ 0 AND
              sy-datum >= lst_jkseinterrupt-valid_from AND
                sy-datum <= lst_jkseinterrupt-valid_to
                AND lst_jkseinterrupt-reason IS NOT INITIAL.
              lst_final-vkuegru = lc_yes.
            ELSE.
              CLEAR lst_veda.
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*              READ TABLE li_veda INTO lst_veda WITH KEY doc_number = lst_item-doc_number
*                                                        itm_number = lst_item-itm_number
*                                                        BINARY SEARCH.
*              IF sy-subrc EQ 0
*                AND sy-datum > lst_veda-contenddat.
*                lst_final-vkuegru = lc_yes.
*              ELSE.
*                READ TABLE li_veda INTO lst_veda WITH KEY doc_number = lst_item-doc_number
*                                                        itm_number = lc_posnr
*                                                        BINARY SEARCH.
*                IF sy-subrc EQ 0
*                  AND sy-datum > lst_veda-contenddat.
*                  lst_final-vkuegru = lc_yes.
*                ELSE.
*                  READ TABLE li_vbep INTO DATA(lst_vbep) WITH KEY doc_number = lst_item-doc_number
*                                                                  itm_number = lst_item-itm_number
*                                                                  BINARY SEARCH.
*                  IF sy-subrc EQ 0
*                    AND lst_vbep-req_dlv_bl IS NOT INITIAL.
*                    lst_final-vkuegru = lc_yes.
*                  ELSE.
*                    CLEAR lst_header.
*                    READ TABLE li_header INTO lst_header WITH KEY doc_number = lst_item-doc_number
*                                                                  BINARY SEARCH.
*                    IF sy-subrc EQ 0
*                      AND lst_header-dlv_block IS NOT INITIAL.
*                      lst_final-vkuegru = lc_yes.
*                    ELSE.
*                      lst_final-vkuegru = lc_no.
*                    ENDIF. "Read li_header
*                  ENDIF. "Read li_vbep
*                ENDIF. "Read li_veda
*              ENDIF. "Read li_veda
              READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_item-vbeln
                                                        vposn = lst_item-posnr
                                                        BINARY SEARCH.
              IF sy-subrc EQ 0
                AND sy-datum > lst_veda-venddat.
                lst_final-vkuegru = lc_yes.
              ELSE.
                READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_item-vbeln
                                                          vposn = lc_posnr
                                                        BINARY SEARCH.
                IF sy-subrc EQ 0
                  AND sy-datum > lst_veda-venddat.
                  lst_final-vkuegru = lc_yes.
                ELSE.
                  READ TABLE li_vbep INTO DATA(lst_vbep) WITH KEY vbeln = lst_item-vbeln
                                                                  posnr = lst_item-posnr
                                                                  BINARY SEARCH.
                  IF sy-subrc EQ 0
                    AND lst_vbep-lifsp IS NOT INITIAL.
                    lst_final-vkuegru = lc_yes.
                  ELSE.
                    CLEAR lst_vbuk_vbak.
                    READ TABLE li_vbuk_vbak INTO lst_vbuk_vbak WITH KEY vbeln = lst_item-vbeln
                                                                  BINARY SEARCH.
                    IF sy-subrc EQ 0
                      AND lst_vbuk_vbak-lifsk IS NOT INITIAL.
                      lst_final-vkuegru = lc_yes.
                    ELSE.
                      lst_final-vkuegru = lc_no.
                    ENDIF. "Read li_header
                  ENDIF. "Read li_vbep
                ENDIF. "Read li_veda
              ENDIF. "Read li_veda
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
            ENDIF. "Read li_jkseinterrupt
          ENDIF. "lst_item-reason for rejection
        ENDIF. "Read li_vbuk
*    EOC by MODUTTA for CR# 410
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
* Update Material and Media type
        CLEAR : lst_mara.
        READ TABLE li_mara INTO lst_mara WITH KEY matnr = lst_item-matnr
                                         BINARY SEARCH.
        IF sy-subrc EQ 0.
*  Read media type description
          READ TABLE li_mediatyp INTO DATA(lst_mediatyp) WITH KEY ismmediatype = lst_mara-ismmediatype
                                                         BINARY SEARCH.
          IF sy-subrc EQ 0.
            lst_final-media_type = lst_mediatyp-bezeichnung.
          ENDIF.
          lst_final-matnr      = lst_mara-matnr.
        ENDIF.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
        APPEND lst_final TO fp_li_final.
      ENDIF. "li_item read
* BOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
*      CLEAR: lst_final,lv_flag,lst_vbuk,lst_item,lst_vbkd.
      CLEAR: lst_final, lv_flag, lst_vbuk_vbak, lst_item, lst_vbkd, lst_veda, lst_tsad3t.
* EOC by PBANDLAPAL on 15-Jan-2018 for ERP-5596: ED2K910329
    ENDLOOP.
  ENDIF.

*Filtering final output table by importing parameter
  IF fp_li_society IS NOT INITIAL.
    SORT fp_li_final BY sccode.
    DELETE fp_li_final WHERE sccode NOT IN lir_society_range.
  ENDIF.

  IF fp_li_email IS NOT INITIAL.
    SORT fp_li_final BY smtp_addr.
    DELETE fp_li_final WHERE smtp_addr IS INITIAL.
  ENDIF.

  IF fp_li_payment IS NOT INITIAL.
    SORT fp_li_final BY payment_rate.
    DELETE fp_li_final WHERE payment_rate NOT IN lir_payment_rng.
  ENDIF.

  IF fp_li_subtyp IS NOT INITIAL.
    SORT fp_li_final BY subtype_code.
    DELETE fp_li_final WHERE subtype_code NOT IN lir_subtyp_rng.
  ENDIF.

* BOC by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942
* This is not needed as part of CR#388 no filteration needed as its being decided
* to pass only the values as P.
*  IF fp_im_pymnt_sts IS NOT INITIAL.
*    SORT fp_li_final BY pymnt_sts.
*    DELETE fp_li_final WHERE pymnt_sts <> fp_im_pymnt_sts.
*  ENDIF.
* EOC by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909942

  IF fp_im_cncl_code IS NOT INITIAL.
    SORT fp_li_final BY vkuegru.
    DELETE fp_li_final WHERE vkuegru <> fp_im_cncl_code.
  ENDIF.

  IF fp_im_doublebilling IS NOT INITIAL.
    SORT fp_li_final BY double_bill.
    DELETE fp_li_final WHERE double_bill <> fp_im_doublebilling.
  ENDIF.

  IF fp_li_final IS INITIAL.
    MESSAGE e123(zqtc_r2) INTO lst_bapiret-message.
*      To update return table with messages
    PERFORM f_update_return CHANGING lst_bapiret
                                    fp_li_bapiret.
  ENDIF.

* Sort is done based on the contract end date as end systems need it.
  IF fp_li_final IS NOT INITIAL.
    SORT fp_li_final BY venddat DESCENDING.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_CONSTANT
*&---------------------------------------------------------------------*
*       Get data from ZCACONSTANT
*----------------------------------------------------------------------*
*      <--FP_LI_CONSTANT  constant records
*----------------------------------------------------------------------*
FORM f_get_constant  CHANGING fp_li_constant TYPE tt_constant.
*  Local constant declaration
  CONSTANTS:  lc_devid  TYPE zdevid VALUE 'I0317'.     " Development ID

*Fetch data from ZCACONSTANT
  SELECT  devid,      " Development ID
          param1,     " ABAP: Name of Variant Variable
          param2,     " ABAP: Name of Variant Variable
          srno,       " ABAP: Current selection number
          sign,       " ABAP: ID: I/E (include/exclude values)
          opti,       " ABAP: Selection option (EQ/BT/CP/...)
          low,        " Lower Value of Selection Condition
          high,       " Upper Value of Selection Condition
          activate    "
  FROM zcaconstant " Wiley Application Constant Table
    INTO TABLE @fp_li_constant
    WHERE devid = @lc_devid
    AND   activate = @abap_true.
  IF sy-subrc EQ 0.
    SORT fp_li_constant BY param1.
  ENDIF. " IF sy-subrc IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_RETURN
*&---------------------------------------------------------------------*
*       Subroutine for updating return tablef
*----------------------------------------------------------------------*
*      -->FP_LST_RETURN  Workarea for return
*      <--FP_LI_RETURN  Table for error & success messages
*----------------------------------------------------------------------*
FORM f_update_return  CHANGING    fp_lst_bapiret TYPE bapiret2
                                  fp_fp_li_bapiret TYPE bapiret2_t.
  CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
    EXPORTING
      syst     = sy
    CHANGING
      bapiret2 = fp_lst_bapiret.
  APPEND fp_lst_bapiret TO fp_fp_li_bapiret.
  CLEAR fp_lst_bapiret.
ENDFORM.
* BOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038
*&---------------------------------------------------------------------*
*&      Form  F_CREATE_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_create_log USING fp_li_constant TYPE tt_constant..

  DATA : li_log  TYPE bal_s_log, " Application Log: Log header data
         lv_date TYPE aldate_del.
* Get Expiry date
  READ TABLE fp_li_constant INTO DATA(lst_constant)
                         WITH KEY param1 = c_expiry
                                  param2 = c_appl.
  IF sy-subrc EQ 0.
    gv_days = lst_constant-low.
    lv_date = sy-datum + gv_days.
  ENDIF.

* define some header data of this log
  li_log-extnumber  = sy-datum.
  li_log-object     = c_object.
  li_log-subobject  = c_subobj.
  li_log-aldate     = sy-datum.
  li_log-altime     = sy-uzeit.
  li_log-aluser     = sy-uname.
  li_log-alprog     = sy-repid.
  li_log-aldate_del = lv_date.
  li_log-del_before = abap_true.

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = li_log
    IMPORTING
      e_log_handle            = gv_log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_MAINTAIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_FVAL  text
*----------------------------------------------------------------------*
FORM f_log_maintain  USING fp_lv_fval TYPE char200.

  DATA : lv_msg       TYPE bal_s_msg, " Application Log: Message Data
         lv_fval      TYPE int4,      " Natural Number
         lv_mesg(200) TYPE c,
         lv_chars     TYPE i,
         lv_index     TYPE i,
         lv_cnt       TYPE i.

  lv_msg-msgty     = 'I'.
  lv_msg-msgid     = 'ZQTC_R2'.
  lv_msg-msgno  = '000'.

  lv_fval = strlen( fp_lv_fval ).

  IF lv_fval LE 50.
    lv_msg-msgv1 = fp_lv_fval.
  ELSEIF lv_fval  GT 50 AND lv_fval LE 100.
    lv_msg-msgv1 = fp_lv_fval+0(50).
    lv_msg-msgv2 = fp_lv_fval+50(50).
  ELSEIF lv_fval  GT 100 AND lv_fval LE 150.
    lv_msg-msgv1 = fp_lv_fval+0(50).
    lv_msg-msgv2 = fp_lv_fval+50(50).
    lv_msg-msgv3 = fp_lv_fval+100(50).
  ELSE. " ELSE -> IF lv_fval LE 50
    lv_msg-msgv1 = fp_lv_fval+0(50).
    lv_msg-msgv2 = fp_lv_fval+50(50).
    lv_msg-msgv3 = fp_lv_fval+100(50).
    lv_msg-msgv4 = fp_lv_fval+150(50).

  ENDIF. " IF lv_fval LE 50


  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = gv_log_handle
      i_s_msg          = lv_msg
    EXCEPTIONS
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF. " IF sy-subrc <> 0


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_SAVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_log_save .

*Save logs in the database
  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_save_all       = abap_true
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.

  IF sy-subrc <> 0.

  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_LOG_MESSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_CHAR  text
*      <--P_LV_FVAL  text
*      <--P_LV_TEXT  text
*      <--P_LV_LENGTH  text
*----------------------------------------------------------------------*
FORM f_log_message  USING    fp_lv_char    TYPE char200
                    CHANGING fp_lv_fval    TYPE char200
                             fp_lv_text    TYPE char200
                             fp_lv_length  TYPE i.

  DATA : lv_length1 TYPE i,
         lv_length2 TYPE i.

  lv_length1 = strlen( fp_lv_fval ).
  lv_length2 = strlen( fp_lv_char ).
  IF lv_length1 GE 200 OR
     fp_lv_length GE 200..
    PERFORM f_log_maintain  USING fp_lv_fval.
    CLEAR : fp_lv_fval.
    fp_lv_fval = fp_lv_text.
    CLEAR: fp_lv_text,
            fp_lv_length.
    CONCATENATE fp_lv_fval fp_lv_char INTO fp_lv_fval SEPARATED BY space.
  ELSE.
    fp_lv_length = lv_length1 + lv_length2.
    IF fp_lv_length > 200.
      fp_lv_text = fp_lv_char.
    ELSE.

      CONCATENATE fp_lv_fval fp_lv_char INTO fp_lv_fval SEPARATED BY space.
    ENDIF.
  ENDIF.

ENDFORM.
* EOC by DTIRUKOOVA on 22-Feb-2018 for ERP-6750: ED2K911038

*--BOC by GKAMMILI on 09-10-2020 for OTCM 13923
FORM f_get_data_cws  USING    fp_li_society TYPE tt_society
                          fp_li_email TYPE tt_email
                          fp_li_subs_ref  TYPE tt_ihrez
                          fp_im_cntrctdat TYPE vbdat_veda
                          fp_im_pymnt_sts TYPE zqtc_pymnt_sts      ##NEEDED
                          fp_im_doublebilling TYPE zqtc_double_bill
                          fp_li_payment TYPE tt_payment
                          fp_im_cncl_code TYPE kuegru
                          fp_li_subtyp TYPE tt_subtyp
                          fp_li_constant TYPE tt_constant
                          fp_im_media_type TYPE zqtc_media_type
                          fp_li_postal TYPE tt_postal
                          fp_li_country TYPE tt_country
                 CHANGING fp_li_bapiret TYPE bapiret2_t
                          fp_li_final TYPE ztqtc_membership_check.

* Local type declaration
  TYPES: BEGIN OF lty_range,
           sign   TYPE ddsign,     "sign
           option TYPE ddoption,   "option
           low    TYPE rvari_vnam, "low
           high   TYPE rvari_vnam, "high
         END OF lty_range,

         BEGIN OF lty_payment_range,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE konda,
           high   TYPE konda,
         END OF lty_payment_range,

         BEGIN OF lty_payment_rng,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE char1,
           high   TYPE char1,
         END OF lty_payment_rng,

         BEGIN OF lty_order,
           vbeln TYPE vbeln, "Sales Order
           posnr TYPE posnr, "Item Number
           vbtyp TYPE vbtyp_n,
           auart TYPE auart,
           pstyv TYPE pstyv,
           erdat TYPE erdat,
           vgbel TYPE vgbel,
           vgpos TYPE vgpos,
         END OF lty_order,

         BEGIN OF lty_society,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE zzpartner2,
           high   TYPE zzpartner2,
         END OF lty_society,

         BEGIN OF lty_subtyp,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE char4,
           high   TYPE char4,
         END OF lty_subtyp,

         BEGIN OF lty_jrnl_code,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE zzjrnl_grp_code,
           high   TYPE zzjrnl_grp_code,
         END OF lty_jrnl_code,

         BEGIN OF lty_email,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE ad_smtpadr,
           high   TYPE ad_smtpadr,
         END OF lty_email,

         BEGIN OF lty_email_s,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE ad_smtpad2,
           high   TYPE ad_smtpad2,
         END OF lty_email_s,
         BEGIN OF lty_media,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE ismmediatype,
           high   TYPE ismmediatype,
         END OF lty_media,

         BEGIN OF lty_mara,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE matnr,
           high   TYPE matnr,
         END OF lty_mara,
         BEGIN OF lty_postal,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE ad_pstcd2,
           high   TYPE ad_pstcd2,
         END OF lty_postal,
         BEGIN OF lty_country,
           sign   TYPE ddsign,
           option TYPE ddoption,
           low    TYPE land1,
           high   TYPE land1,
         END OF lty_country,
         BEGIN OF lty_vbfa,
           vbelv TYPE vbfa-vbelv,
           vbeln TYPE vbfa-vbeln,
         END OF lty_vbfa,
         BEGIN OF lty_but000,
           partner    TYPE but000-partner,
           type       TYPE but000-type,
           name_org1  TYPE but000-name_org1,
           name_org2  TYPE but000-name_org2,
           name_last  TYPE but000-name_last,
           name_first TYPE but000-name_first,
         END OF lty_but000,
         BEGIN OF lty_vbak,
           vbeln TYPE vbak-vbeln,
           audat TYPE vbak-audat,
         END OF lty_vbak.


* Local constant declaration
  CONSTANTS: lc_auart        TYPE rvari_vnam VALUE 'AUART',
             lc_pstyv        TYPE rvari_vnam VALUE 'PSTYV',
             lc_journal_code TYPE rvari_vnam VALUE 'JOURNAL_CODE',
             lc_mvgr5_1      TYPE rvari_vnam VALUE 'MVGR5_1',
             lc_mvgr5_2      TYPE rvari_vnam VALUE 'MVGR5_2',
             lc_sign         TYPE ddsign VALUE 'I',
             lc_spras        TYPE rvari_vnam  VALUE 'SPRAS',

             lc_option       TYPE ddoption VALUE 'EQ',
             lc_option_cp    TYPE ddoption VALUE 'CP',
             lc_yes          TYPE char1 VALUE 'Y',
             lc_no           TYPE char1 VALUE 'N',
             lc_parvw        TYPE parvw VALUE 'WE', "Ship to party
             lc_parvw_ag     TYPE parvw VALUE 'AG', "Sold to Party
             lc_parvw_za     TYPE parvw VALUE 'ZA', "Socity partner
             lc_payment_c    TYPE char1 VALUE 'C',
             lc_payment_m    TYPE char1 VALUE 'M',
             lc_payment_f    TYPE char1 VALUE 'F',
             lc_payment_p    TYPE char1 VALUE 'P',
             lc_konda_01     TYPE konda VALUE '01',
             lc_konda_02     TYPE konda VALUE '02',
             lc_konda_03     TYPE konda VALUE '03',
             lc_konda_04     TYPE konda VALUE '04',
             lc_bsark        TYPE bsark VALUE '0230',
             lc_payment_e    TYPE konda VALUE 'E',
             lc_star         TYPE char1 VALUE '*',
             lc_posnr        TYPE posnr_va VALUE '000000',
             lc_posnr_10     TYPE posnr_va VALUE '000010',
             lc_paymnt_sts   TYPE rvari_vnam VALUE 'PAYMNT_STS',
             lc_pstyv_p      TYPE rvari_vnam VALUE 'PSTYV_P',
             lc_cmgst        TYPE cmgst VALUE 'B',
             lc_media_p      TYPE ismmediatype VALUE 'PH',
             lc_media_m      TYPE ismmediatype VALUE 'MM',  "Added by GKAMMILI for OTCM-13923
             lc_media_d      TYPE ismmediatype VALUE 'DI',
             lc_type         TYPE bu_type VALUE '1',
             lc_us           TYPE land1   VALUE 'US'.

* Local data declaration
  DATA: lir_auart           TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0,
        lir_pstyv_d         TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0,
        lir_pstyv           TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0,
        lst_pstyv           TYPE lty_range,
        lir_code            TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0,
        lv_strt_date        TYPE sy-datum,
        lv_end_date         TYPE sy-datum,
        li_order_detail     TYPE STANDARD TABLE OF lty_order INITIAL SIZE 0,
        lv_paymnt_sts       TYPE salv_de_selopt_low,  " Lower Value of Selection Condition
        lv_netwr            TYPE vbap-netwr,
        lv_mwsbp            TYPE vbap-mwsbp,
        lv_vbeln            TYPE vbap-vbeln,
        lv_index            TYPE sy-tabix,
        li_ord_dtl_tmp      TYPE STANDARD TABLE OF lty_order INITIAL SIZE 0,
        lst_ord_dtl_tmp     TYPE lty_order,
        lir_order_range     TYPE fip_t_vbeln_range,
        lst_order_range     LIKE LINE OF lir_order_range,
        lir_email_range     TYPE STANDARD TABLE OF lty_email,
        lir_email_s_range   TYPE STANDARD TABLE OF lty_email_s,
        lst_email_range     TYPE lty_email,
        lst_email_s_range   TYPE lty_email_s,
        lir_postal_range    TYPE STANDARD TABLE OF lty_postal,
        lir_postal_s_range  TYPE STANDARD TABLE OF lty_postal,
        lst_postal_range    TYPE lty_postal,
        lst_postal_s_range  TYPE lty_postal,
        lir_country_range   TYPE STANDARD TABLE OF lty_country,
        lir_country_s_range TYPE STANDARD TABLE OF lty_country,
        lst_country_range   TYPE lty_country,
        lst_country_s_range TYPE lty_country,
        li_order            TYPE mds_sales_key_tab,
        lv_leng             TYPE i,
        lv_order            TYPE sales_key,
        lst_auart           TYPE lty_range,
        lst_code            TYPE lty_range,
        lst_mvgr5_1         TYPE lty_range,
        lst_mvgr5_2         TYPE lty_range,
        lst_bapiret         TYPE bapiret2,
        lst_order_detail    TYPE lty_order,
        lst_society_range   TYPE lty_society,
        lst_payment_range   TYPE lty_payment_range,
        lir_society_range   TYPE STANDARD TABLE OF lty_society,
        lir_subtyp          TYPE STANDARD TABLE OF lty_subtyp INITIAL SIZE 0, "this is not removed since w emay be need it after testing to add new logic
        lst_subtyp          TYPE lty_subtyp,
        lst_subtyp_rng      TYPE lty_payment_rng,
        lir_subtyp_rng      TYPE STANDARD TABLE OF lty_payment_rng,
        lir_society         TYPE STANDARD TABLE OF lty_society INITIAL SIZE 0,
        lir_jrnl_code       TYPE STANDARD TABLE OF lty_jrnl_code INITIAL SIZE 0,
        lst_jrnl_code       TYPE lty_jrnl_code,
        lr_parvw            TYPE wtysc_parvw_ranges_tab,
        lst_parvw           TYPE wtysc_wwb_s_parvw,
        lv_idcode           TYPE ismidentcode,
        lv_jgrp_code        TYPE ismidentcode,
        lv_flag             TYPE xfeld,
        lv_dflt_langu       TYPE spras, "salv_de_selopt_low,  " Lower Value of Selection Condition
        lv_flg(1)           TYPE c,     "Flag
        li_sub_order        TYPE STANDARD TABLE OF lty_order INITIAL SIZE 0,
        li_sub_order_c      TYPE STANDARD TABLE OF lty_order INITIAL SIZE 0,   " Consolidated orders for Legacy and SAP Subs Ref
        li_sub_order_ls     TYPE STANDARD TABLE OF lty_order INITIAL SIZE 0,  " With reference to Legacy Subs Ref
        li_sub_order_ss     TYPE STANDARD TABLE OF lty_order INITIAL SIZE 0,  " With reference to SAP Subs Ref
        li_sub_order_qt     TYPE STANDARD TABLE OF lty_order INITIAL SIZE 0,  " With reference to SAP Subs Ref
        lir_identcode       TYPE rjksd_identcode_range_tab,
        lst_identcode_range LIKE LINE OF lir_identcode,
        lir_payment_rng     TYPE STANDARD TABLE OF lty_payment_rng,
        lst_payment_rng     TYPE lty_payment_rng,
        lir_payment         TYPE STANDARD TABLE OF lty_payment_range INITIAL SIZE 0, "This is not removed since we may need it later after testing
        lir_mvgr5_1         TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0,
        lir_mvgr5_2         TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0,
        lst_final           TYPE zstqtc_membership_check,
        li_jkseinterrupt    TYPE tt_jkseinterrupt,
        lir_pstyv_p         TYPE STANDARD TABLE OF lty_range INITIAL SIZE 0,
        lir_media           TYPE STANDARD TABLE OF lty_media INITIAL SIZE 0,
        lst_media           TYPE lty_media,
        lir_mara            TYPE STANDARD TABLE OF lty_mara,
        lst_mara_rng        TYPE lty_mara,
        li_vbfa_p           TYPE STANDARD TABLE OF lty_vbfa,
        lst_vbfa_p          TYPE lty_vbfa,
        li_vbfa_s           TYPE STANDARD TABLE OF lty_vbfa,
        lst_vbfa_s          TYPE lty_vbfa,
        li_vbak             TYPE STANDARD TABLE OF lty_vbak,
        lst_vbak            TYPE lty_vbak,
        li_vbak_t           TYPE STANDARD TABLE OF lty_vbak,
        li_but000           TYPE STANDARD TABLE OF lty_but000,
        lst_but000          TYPE lty_but000,
        lir_matnr           TYPE TABLE OF curto_matnr_range,
        lst_matnr           TYPE curto_matnr_range,
        lir_vkorg           TYPE TABLE OF saco_s_vkorg,
        lst_vkorg           TYPE saco_s_vkorg.

* Get the constants from ZCACONSTANT table
  LOOP AT fp_li_constant INTO DATA(lst_constant).
    CASE lst_constant-param1. "Variable Name
      WHEN lc_auart. "AUART
        CASE  lst_constant-param2.
          WHEN 'CWS'.
            lst_auart-sign = lc_sign.
            lst_auart-option = lc_option.
            lst_auart-low = lst_constant-low.
            APPEND lst_auart TO lir_auart.
            CLEAR lst_auart.
        ENDCASE.
      WHEN lc_pstyv. "PSTYV
        CASE  lst_constant-param2.
          WHEN 'CWS'.
            lst_pstyv-sign = lc_sign.
            lst_pstyv-option = lc_option.
            lst_pstyv-low = lst_constant-low.
            APPEND lst_pstyv TO lir_pstyv_d.
            CLEAR lst_pstyv.
        ENDCASE.


      WHEN lc_journal_code. "JOURNAL_CODE
        CASE  lst_constant-param2.
          WHEN 'CWS'.
            lst_code-sign = lc_sign.
            lst_code-option = lc_option.
            lst_code-low = lst_constant-low.
            APPEND lst_code TO lir_code.
            CLEAR lst_code.
        ENDCASE.
      WHEN lc_mvgr5_1.
        lst_mvgr5_1-sign = lc_sign.
        lst_mvgr5_1-option = lc_option.
        lst_mvgr5_1-low = lst_constant-low.
        APPEND lst_mvgr5_1 TO lir_mvgr5_1.
      WHEN lc_mvgr5_2.
        lst_mvgr5_2-sign = lc_sign.
        lst_mvgr5_2-option = lc_option.
        lst_mvgr5_2-low = lst_constant-low.
        APPEND lst_mvgr5_2 TO lir_mvgr5_2.
      WHEN lc_pstyv_p.
        lst_pstyv-sign = lc_sign.
        lst_pstyv-option = lc_option.
        lst_pstyv-low = lst_constant-low.
        APPEND lst_pstyv TO lir_pstyv_p.
        CLEAR lst_pstyv.
      WHEN lc_paymnt_sts.
        lv_paymnt_sts    = lst_constant-low.
      WHEN lc_spras.
        lv_dflt_langu   = lst_constant-low.
      WHEN OTHERS.
        "No Action
    ENDCASE.
  ENDLOOP.

  LOOP AT fp_li_subtyp INTO DATA(lst_subtyp_range).
    lst_subtyp-sign = lst_subtyp_rng-sign = lc_sign.
    lst_subtyp-option = lst_subtyp_rng-option = lc_option.
    lst_subtyp_rng-low = lst_subtyp_range-subtyp.
    APPEND lst_subtyp_rng TO lir_subtyp_rng.
    IF lst_subtyp_range-subtyp = lc_payment_c.
      lst_subtyp-low = lc_konda_01.
    ELSEIF lst_subtyp_range-subtyp = lc_payment_m.
      lst_subtyp-low = lc_konda_02.
    ELSEIF lst_subtyp_range-subtyp = lc_payment_f.
      lst_subtyp-low = lc_konda_03.
    ENDIF.
    APPEND lst_subtyp TO lir_subtyp.
    CLEAR: lst_subtyp,lst_subtyp_rng.
  ENDLOOP.

  IF fp_im_media_type = c_media_default. "if media type is D
    lir_pstyv[] = lir_pstyv_d[].
    lst_media-sign = lc_sign.
    lst_media-option = lc_option.
    lst_media-low = lc_media_d.
    APPEND lst_media TO lir_media.
    CLEAR lst_media.

  ELSEIF fp_im_media_type = lc_payment_p. "if media type is P
    lir_pstyv[] = lir_pstyv_p[].

    lst_media-sign = lc_sign.
    lst_media-option = lc_option.
    lst_media-low = lc_media_p.
    APPEND lst_media TO lir_media.
    CLEAR lst_media.
  ELSEIF fp_im_media_type = lc_payment_m. "if media type is M
    lir_pstyv[] = lir_pstyv_p[].

    lst_media-sign = lc_sign.
    lst_media-option = lc_option.
    lst_media-low = lc_media_m.
    APPEND lst_media TO lir_media.
    CLEAR lst_media.

  ELSEIF fp_im_media_type = lc_payment_c. "if media type is C
    APPEND LINES OF lir_pstyv_d TO lir_pstyv.
    APPEND LINES OF lir_pstyv_p TO lir_pstyv.
*    Populate media type DI
    lst_media-sign = lc_sign.
    lst_media-option = lc_option.
    lst_media-low = lc_media_d.
    APPEND lst_media TO lir_media.
    CLEAR lst_media.
*    Populate media type PH
    lst_media-sign = lc_sign.
    lst_media-option = lc_option.
    lst_media-low = lc_media_p.
    APPEND lst_media TO lir_media.
    CLEAR lst_media.
  ENDIF.

  IF fp_li_subs_ref IS NOT INITIAL.
    SELECT vbeln,
           posnr,
           vgbel,
           vgpos
           FROM vbap
           INTO TABLE @li_sub_order_qt            ##TOO_MANY_ITAB_FIELDS
           FOR ALL ENTRIES IN @fp_li_subs_ref
           WHERE vbeln = @fp_li_subs_ref-ihrez+0(10)
           AND abgru EQ @space.

    IF sy-subrc NE 0.
      SELECT vbeln,
             posnr
             FROM vbkd
             INTO TABLE @li_sub_order_ss           ##TOO_MANY_ITAB_FIELDS
             FOR ALL ENTRIES IN @fp_li_subs_ref
             WHERE ihrez = @fp_li_subs_ref-ihrez.
      IF sy-subrc NE 0.
        SELECT vbeln,
               posnr
               FROM vbkd
               INTO TABLE @li_sub_order_ls            ##TOO_MANY_ITAB_FIELDS
               FOR ALL ENTRIES IN @fp_li_subs_ref
               WHERE ihrez_e = @fp_li_subs_ref-ihrez.
        IF sy-subrc NE 0.
          MESSAGE e583(zqtc_r2) INTO lst_bapiret-message.
*      No Valid Quote based on Reference ID
*      To update return table with messages
          PERFORM f_update_return CHANGING lst_bapiret
                                   fp_li_bapiret.
          RETURN.
        ELSE.
          APPEND LINES OF li_sub_order_ls TO li_sub_order_c.
        ENDIF.
      ELSE.
        APPEND LINES OF li_sub_order_ss TO li_sub_order_c.
      ENDIF.
    ELSE.
      APPEND LINES OF li_sub_order_qt TO li_sub_order_c.

    ENDIF.
* To filter the sales document type and item category maintained
* in ZCACONSTANT.
    IF li_sub_order_c IS NOT INITIAL.
      SORT li_sub_order_c BY vbeln posnr.
      DELETE ADJACENT DUPLICATES FROM li_sub_order_c COMPARING vbeln posnr.
      SELECT a~vbeln,
                 b~posnr,
                 a~vbtyp,
                 a~auart,b~pstyv,
                 a~erdat,b~vgbel,b~vgpos
                 INTO TABLE @li_sub_order
                 FROM vbak AS a
                 INNER JOIN vbap AS b ON a~vbeln = b~vbeln
                 FOR ALL ENTRIES IN @li_sub_order_c
                 WHERE a~vbeln = @li_sub_order_c-vbeln
                 AND   a~bnddt GE @sy-datum
                 AND   b~abgru = @space.
      IF sy-subrc EQ 0.
        SORT li_sub_order BY vbeln.
      ENDIF.

      IF sy-subrc NE 0.
        MESSAGE e583(zqtc_r2)  INTO lst_bapiret-message.
*      No valid Quote found for input Reference ID
*      To update return table with messages
        PERFORM f_update_return CHANGING lst_bapiret
                                 fp_li_bapiret.
        RETURN.
      ENDIF.
    ENDIF.
  ENDIF.

*      Populate Subscription Order
  IF li_sub_order IS NOT INITIAL.
    SORT li_sub_order BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM li_sub_order COMPARING vbeln posnr.
    DATA(li_sub_order2) = li_sub_order[].
*    DELETE li_sub_order[] WHERE auart IN lir_auart.
    DELETE li_sub_order[] WHERE auart NOT IN lir_auart.
    DELETE li_sub_order2[] WHERE auart NOT IN lir_auart.

*    DELETE li_sub_order WHERE vgbel IS INITIAL.    "Commented
    LOOP AT li_sub_order INTO DATA(lst_sub_order).
      lst_order_detail-vbeln = lst_sub_order-vbeln.
      lst_order_detail-posnr = lst_sub_order-posnr.
      lst_order_detail-vgbel = lst_sub_order-vgbel.
      lst_order_detail-vgpos = lst_sub_order-vgpos.
      APPEND lst_order_detail TO li_order_detail.
      lv_order = lst_sub_order-vbeln.
      APPEND lv_order TO li_order.

      lst_order_range-sign = lc_sign.
      lst_order_range-option = lc_option.
      lst_order_range-low = lv_order.
      APPEND lst_order_range TO lir_order_range.

      lv_order = lst_sub_order-vgbel.
      APPEND lv_order TO li_order.
      lst_order_range-low = lv_order.
      APPEND lst_order_range TO lir_order_range.

      CLEAR: lst_order_detail,lst_sub_order,lv_order,lst_order_range.
    ENDLOOP.
  ENDIF.
  IF li_order_detail[] IS INITIAL.
    MESSAGE e583(zqtc_r2)  INTO lst_bapiret-message.
*      No valid Quote found for input Reference ID
*      To update return table with messages
    PERFORM f_update_return CHANGING lst_bapiret
                             fp_li_bapiret.
    RETURN.
  ENDIF.

*If im_smtp_adr is not initial
  IF fp_li_email IS NOT INITIAL.
    LOOP AT fp_li_email INTO DATA(lst_email_data).
      IF lst_email_data IS NOT INITIAL.
        lst_email_range-sign = lst_email_s_range-sign = lc_sign.
        lst_email_range-option = lst_email_s_range-option = lc_option.
        lst_email_range-low   = lst_email_data-email.
        lst_email_s_range-low = lst_email_data-email.

        TRANSLATE lst_email_range-low TO UPPER CASE.
        APPEND lst_email_range TO lir_email_range.
        CLEAR lst_email_range.

        TRANSLATE lst_email_s_range-low TO UPPER CASE.
        APPEND lst_email_s_range TO lir_email_s_range.
        CLEAR lst_email_s_range.
      ENDIF.
    ENDLOOP.

    IF lir_email_s_range IS NOT INITIAL.

* check if order data w.r.t Reference(IHREZ) exists or not
      IF li_order_detail IS INITIAL.
        SELECT
         a~addrnumber,       " Address Number
         a~smtp_addr,        " Email ID
         v~vbeln,            " Subscription Order
         v~posnr,             " Item Number
         v~vgbel,
          v~vgpos
         FROM adr6 AS a
         INNER JOIN vbpa AS b ON a~addrnumber = b~adrnr
         INNER JOIN viveda AS v ON b~vbeln = v~vbeln
         INTO TABLE @DATA(li_email_info)
         WHERE a~smtp_srch IN @lir_email_s_range
         AND   b~parvw = @lc_parvw
         AND   v~auart IN @lir_auart.
*         AND   v~pstyv IN @lir_pstyv.
      ELSE.
* Fetch customer address data
        SORT li_order_detail BY vbeln posnr.

        SELECT
          a~addrnumber,       " Address Number
          a~smtp_addr,        " Email ID
          v~vbeln,            " Subscription Order
          v~posnr,             " Item Number
          v~vgbel,
          v~vgpos
        FROM adr6 AS a
        INNER JOIN vbpa AS b ON a~addrnumber = b~adrnr
        INNER JOIN viveda AS v ON b~vbeln = v~vbeln
        INTO TABLE @li_email_info
        FOR ALL ENTRIES IN @li_order_detail
        WHERE a~smtp_srch IN @lir_email_s_range
        AND   b~parvw = @lc_parvw
        AND   v~vbeln = @li_order_detail-vbeln
        AND   v~posnr = @li_order_detail-posnr
        AND   v~auart IN @lir_auart.
*        AND   v~pstyv IN @lir_pstyv.
      ENDIF.
      IF sy-subrc NE 0.
        IF fp_li_postal IS INITIAL.
          MESSAGE e583(zqtc_r2) INTO lst_bapiret-message.
*     No Subscription Order found for input Email Id
*      To update return table with messages
          PERFORM f_update_return CHANGING lst_bapiret
                                   fp_li_bapiret.
          RETURN.
        ELSE.
          REFRESH lir_email_s_range.
          lv_flg = abap_true.
        ENDIF.
      ELSE.
        LOOP AT li_email_info ASSIGNING FIELD-SYMBOL(<lst_email_info>).
          TRANSLATE <lst_email_info>-smtp_addr TO UPPER CASE.
        ENDLOOP.
        DELETE li_email_info WHERE smtp_addr NOT IN lir_email_range.
        IF li_email_info[] IS NOT INITIAL.


*      Populate Subscription Order
          IF li_order_detail IS NOT INITIAL
           AND li_order IS NOT INITIAL
            AND lir_order_range IS NOT INITIAL.
            CLEAR: li_order_detail[], li_order[].

            LOOP AT li_email_info INTO DATA(lst_email).
              IF lst_email-vbeln IN lir_order_range.
                lst_order_detail-vbeln = lst_email-vbeln.
                lst_order_detail-posnr = lst_email-posnr.
                lv_order = lst_email-vbeln.
                APPEND lv_order TO li_order.
                APPEND lst_order_detail TO li_order_detail.
              ENDIF.
            ENDLOOP.
          ELSE.
*        If this is the only import parameter
            LOOP AT li_email_info INTO lst_email.
              lst_order_detail-vbeln = lst_email-vbeln.
              lst_order_detail-posnr = lst_email-posnr.
              lv_order = lst_email-vbeln.
              APPEND lv_order TO li_order.
              APPEND lst_order_detail TO li_order_detail.
              lst_order_range-sign = lc_sign.
              lst_order_range-option = lc_option.
              lst_order_range-low = lst_email-vbeln.
              APPEND lst_order_range TO lir_order_range.
              lst_order_range-low = lst_email-vgbel.
              APPEND lst_order_range TO lir_order_range.

              CLEAR: lst_order_detail,lst_email,lv_order,lst_order_range, lst_email.
            ENDLOOP.
          ENDIF.
        ELSE.
          REFRESH lir_email_s_range.
          lv_flg = abap_true.
        ENDIF.
      ENDIF.
*      ENDIF.
    ENDIF.

    DELETE li_order WHERE vbeln IS INITIAL.
    DELETE li_order_detail WHERE vbeln IS INITIAL.
    SORT li_order_detail BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM li_order_detail COMPARING vbeln posnr.
    SORT lir_order_range BY sign option low.
    DELETE ADJACENT DUPLICATES FROM lir_order_range
                               COMPARING sign option low.
    SORT li_order BY vbeln.
    DELETE ADJACENT DUPLICATES FROM li_order COMPARING vbeln.
  ENDIF.
*If im_postal is not initial
  IF fp_li_postal IS NOT INITIAL AND lv_flg IS NOT INITIAL.
    LOOP AT fp_li_postal INTO DATA(lst_postal_data).
      IF lst_postal_data IS NOT INITIAL.
        lst_postal_range-sign   = lst_postal_s_range-sign = lc_sign.
        lst_postal_range-option = lst_postal_s_range-option = lc_option.
        lst_postal_range-low    = lst_postal_data-pcode.
        lst_postal_s_range-low  = lst_postal_data-pcode.

*        TRANSLATE lst_postal_range-low TO UPPER CASE.
        APPEND lst_postal_range TO lir_postal_range.
        CLEAR lst_postal_range.

*        TRANSLATE lst_postal_s_range-low TO UPPER CASE.
        APPEND lst_postal_s_range TO lir_postal_s_range.
        CLEAR lst_postal_s_range.
      ENDIF.
    ENDLOOP.

    IF lir_postal_s_range IS NOT INITIAL.
* check if order data w.r.t Reference(IHREZ) exists or not
      IF li_order_detail IS INITIAL.
        SELECT
         a~addrnumber,       " Address Number
         a~post_code1,        " Postal code
         v~vbeln,            " Subscription Order
         v~posnr             " Item Number
         FROM adrc AS a
         INNER JOIN vbpa AS b ON a~addrnumber = b~adrnr
         INNER JOIN viveda AS v ON b~vbeln = v~vbeln
         INTO TABLE @DATA(li_postal_info)
         WHERE a~post_code1 IN @lir_postal_s_range
         AND   b~parvw = @lc_parvw
         AND   v~auart IN @lir_auart.
*         AND   v~pstyv IN @lir_pstyv.
      ELSE.
* Fetch customer address data
        SORT li_order_detail BY vbeln posnr.

        SELECT
          a~addrnumber,       " Address Number
          a~post_code1,        " Email ID
          v~vbeln,            " Subscription Order
          v~posnr             " Item Number
        FROM adrc AS a
        INNER JOIN vbpa AS b ON a~addrnumber = b~adrnr
        INNER JOIN viveda AS v ON b~vbeln = v~vbeln
        INTO TABLE @li_postal_info
        FOR ALL ENTRIES IN @li_order_detail
        WHERE a~post_code1 IN @lir_postal_s_range
        AND   b~parvw = @lc_parvw
        AND   v~vbeln = @li_order_detail-vbeln
        AND   v~posnr = @li_order_detail-posnr
        AND   v~auart IN @lir_auart.
*        AND   v~pstyv IN @lir_pstyv.

      ENDIF.
      IF sy-subrc NE 0.
        READ TABLE fp_li_country INTO DATA(lst_country) INDEX 1.
        IF sy-subrc = 0 AND lst_country = lc_us."'US'.
          SORT li_order_detail BY vbeln posnr.

          SELECT
            a~addrnumber,       " Address Number
            a~post_code1,        " Email ID
            v~vbeln,            " Subscription Order
            v~posnr             " Item Number
          FROM adrc AS a
          INNER JOIN vbpa AS b ON a~addrnumber = b~adrnr
          INNER JOIN viveda AS v ON b~vbeln = v~vbeln
          INTO TABLE @li_postal_info
          FOR ALL ENTRIES IN @li_order_detail
          WHERE b~parvw = @lc_parvw
          AND   v~vbeln = @li_order_detail-vbeln
          AND   v~posnr = @li_order_detail-posnr
          AND   v~auart IN @lir_auart.
          IF sy-subrc  = 0.
            DELETE li_postal_info WHERE post_code1+0(5) NOT IN lir_postal_s_range.
          ENDIF.
        ENDIF.
      ELSE.
        DELETE li_postal_info WHERE post_code1 NOT IN lir_postal_range.
      ENDIF.
      IF li_postal_info IS INITIAL.
        MESSAGE e583(zqtc_r2) INTO lst_bapiret-message.
*      To update return table with messages
        PERFORM f_update_return CHANGING lst_bapiret
                                 fp_li_bapiret.
        RETURN.
      ELSE.
*      Populate Subscription Order
        IF li_order_detail IS NOT INITIAL
         AND li_order IS NOT INITIAL
          AND lir_order_range IS NOT INITIAL.
          CLEAR: li_order_detail[], li_order[].

          LOOP AT li_postal_info INTO DATA(lst_postal).
            IF lst_postal-vbeln IN lir_order_range.
              lst_order_detail-vbeln = lst_postal-vbeln.
              lst_order_detail-posnr = lst_postal-posnr.
              lv_order = lst_postal-vbeln.
              APPEND lv_order TO li_order.
              APPEND lst_order_detail TO li_order_detail.
            ENDIF.
          ENDLOOP.
        ELSE.
*        If this is the only import parameter
          LOOP AT li_postal_info INTO lst_postal.
            lst_order_detail-vbeln = lst_postal-vbeln.
            lst_order_detail-posnr = lst_postal-posnr.
            lv_order = lst_postal-vbeln.
            APPEND lv_order TO li_order.
            APPEND lst_order_detail TO li_order_detail.
            lst_order_range-sign = lc_sign.
            lst_order_range-option = lc_option.
            lst_order_range-low = lv_order.
            APPEND lst_order_range TO lir_order_range.
            CLEAR: lst_order_detail,lst_postal,lv_order,lst_order_range, lst_postal.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.

    SORT li_order_detail BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM li_order_detail COMPARING vbeln posnr.
    SORT lir_order_range BY sign option low.
    DELETE ADJACENT DUPLICATES FROM lir_order_range
                               COMPARING sign option low.
    SORT li_order BY vbeln.
    DELETE ADJACENT DUPLICATES FROM li_order COMPARING vbeln.

  ENDIF.

  IF li_order IS NOT INITIAL. "li_order contains only the subscription order number and not the line item
    SELECT
        vbeln,
        posnr,
        valid_from,
        valid_to,
        reason
        FROM jkseinterrupt
        INTO TABLE @li_jkseinterrupt
        FOR ALL ENTRIES IN @li_order
        WHERE vbeln = @li_order-vbeln.
    IF sy-subrc EQ 0.
      SORT li_jkseinterrupt BY vbeln posnr.
    ENDIF.
*
    SELECT a~vbeln,
           a~lifsk,
           b~cmgst
           INTO TABLE @DATA(li_vbuk_vbak)
           FROM vbak AS a
           INNER JOIN vbuk AS b ON a~vbeln = b~vbeln
           FOR ALL ENTRIES IN @li_order
           WHERE a~vbeln = @li_order-vbeln.
    IF sy-subrc EQ 0.
      SORT li_vbuk_vbak BY vbeln.
    ENDIF.
  ENDIF.
  IF li_order_detail IS NOT INITIAL.
    SELECT vbeln,
           posnr,
           lifsp
           INTO TABLE @DATA(li_vbep)
           FROM vbep
           FOR ALL ENTRIES IN @li_order_detail
           WHERE vbeln = @li_order_detail-vbeln AND
                 posnr = @li_order_detail-posnr.
    IF sy-subrc EQ 0.
      SORT li_vbep BY vbeln posnr.
    ENDIF.
    SELECT vbeln,
           posnr,
           konda,
           bsark,
           ihrez,
           ihrez_e,pltyp,kdgrp
           INTO TABLE @DATA(li_vbkd)
           FROM vbkd
           FOR ALL ENTRIES IN @li_order_detail
           WHERE vbeln = @li_order_detail-vbeln AND
               ( posnr = @li_order_detail-posnr OR
                 posnr = @lc_posnr ) .
    IF sy-subrc EQ 0.
      IF fp_li_payment IS NOT INITIAL.
        SORT li_vbkd BY konda.
        DELETE li_vbkd WHERE konda NOT IN lir_payment.
      ENDIF.
      IF fp_li_subtyp IS NOT INITIAL.
        DELETE li_vbkd WHERE konda NOT IN lir_subtyp.
      ENDIF.
    ENDIF.
*
    SELECT vbeln,
           vposn,
           vbegdat,
           venddat
           INTO TABLE @DATA(li_veda)
           FROM veda
           FOR ALL ENTRIES IN @li_order_detail
           WHERE vbeln = @li_order_detail-vbeln AND
               ( vposn = @li_order_detail-posnr OR
                 vposn = @lc_posnr ) .
    IF sy-subrc EQ 0.
      SORT li_veda BY vbeln vposn.
    ENDIF.

*
    SELECT vbeln,
           posnr,
           matnr,
           arktx,
           uepos,
           abgru,
           mvgr5,netwr,kzwi5,mwsbp,waerk
          INTO TABLE @DATA(li_item)
           FROM vbap
           FOR ALL ENTRIES IN @li_order_detail
           WHERE vbeln = @li_order_detail-vbeln AND
                 posnr = @li_order_detail-posnr.
    IF sy-subrc EQ 0.
      SORT li_item BY vbeln uepos.
      LOOP AT li_item INTO DATA(lst_items).
        lst_matnr-sign  = lc_sign.
        lst_matnr-option = lc_option.
        lst_matnr-low    = lst_items-matnr.
        APPEND lst_matnr TO lir_matnr.
        IF lst_items-uepos NE 0.
          lv_netwr   = lv_netwr + lst_items-netwr.
          lv_mwsbp   = lv_mwsbp + lst_items-mwsbp.
          lv_vbeln   = lst_items-vbeln.
        ENDIF.
        AT END OF vbeln.
          READ TABLE li_item INTO lst_items WITH KEY vbeln = lv_vbeln
                                                     uepos = 0
                                                     BINARY SEARCH.
          IF sy-subrc = 0.
            lv_index  = sy-tabix.
            lst_items-netwr = lv_netwr.
            lst_items-mwsbp = lv_mwsbp.
            MODIFY li_item FROM lst_items INDEX lv_index.
          ENDIF.
        ENDAT.
      ENDLOOP.

      SORT li_item BY vbeln posnr.
    ENDIF.
*
    lst_parvw-sign   =  lc_sign.
    lst_parvw-option =  lc_option.
    lst_parvw-low    = lc_parvw.
    APPEND lst_parvw TO lr_parvw.

    lst_parvw-low    = lc_parvw_ag.
    APPEND lst_parvw TO lr_parvw.
    CLEAR lst_parvw.
    SELECT vbeln,
           auart,
           vkorg,
           vtweg,
           spart,
           bukrs_vf
           FROM vbak
           INTO TABLE @DATA(li_vbak_c)
           FOR ALL ENTRIES IN @li_order_detail
           WHERE vbeln = @li_order_detail-vbeln.

    SELECT vbeln,
           posnr,
           parvw,
           kunnr,
           adrnr
           FROM vbpa
           INTO TABLE @DATA(li_vbpa)
           FOR ALL ENTRIES IN @li_order_detail
             WHERE vbeln = @li_order_detail-vbeln AND
                 ( posnr = @li_order_detail-posnr OR
                   posnr = @lc_posnr )             AND
                   parvw IN @lr_parvw.
    IF sy-subrc EQ 0.
      SORT li_vbpa BY vbeln posnr.

      SELECT partnr,stceg FROM bp1020
        INTO TABLE @DATA(li_bp1020)
        FOR ALL ENTRIES IN @li_vbpa
        WHERE partnr = @li_vbpa-kunnr.
      IF sy-subrc EQ 0.
        SORT li_bp1020 BY partnr.
      ENDIF.
    ENDIF.
    SELECT vbeln,
           posnr,
           parvw,
           kunnr,
           adrnr
           FROM vbpa
           INTO TABLE @DATA(li_vbpa_s)
           FOR ALL ENTRIES IN @li_order_detail
             WHERE vbeln = @li_order_detail-vbeln AND
                   posnr = @lc_posnr_10            AND
                   parvw = @lc_parvw_za.
    IF sy-subrc NE 0.
      SELECT vbeln,
           posnr,
           parvw,
           kunnr,
           adrnr
           FROM vbpa
           INTO TABLE @li_vbpa_s
           FOR ALL ENTRIES IN @li_order_detail
             WHERE vbeln = @li_order_detail-vbeln AND
                   posnr = @lc_posnr              AND
                   parvw = @lc_parvw_za.
    ENDIF.
    IF li_vbpa_s[] IS NOT INITIAL.
      LOOP AT li_vbpa_s INTO DATA(lst_vbpa_s).
        lst_society_range-sign   = lc_sign.
        lst_society_range-option = lc_option.
        lst_society_range-low    = lst_vbpa_s-kunnr.
        APPEND lst_society_range TO lir_society.
        CLEAR lst_society_range.
      ENDLOOP.
    ENDIF.
  ENDIF.
*  To get society code of a subscription number
  DATA(li_item_temp) = li_item[].

  SORT li_item_temp BY vbeln posnr matnr.
  DELETE ADJACENT DUPLICATES FROM li_item_temp COMPARING vbeln posnr matnr.

  IF li_item_temp IS NOT INITIAL.
    SELECT
      j~matnr,j~idcodetype,
      j~identcode
      FROM jptidcdassign AS j
      INTO TABLE @DATA(li_identcode)
      FOR ALL ENTRIES IN @li_item_temp
*      WHERE matnr = @li_item_temp-material
      WHERE matnr = @li_item_temp-matnr
       AND  idcodetype IN @lir_code.
    IF sy-subrc EQ 0.
      LOOP AT li_identcode INTO DATA(lst_identcode).
        lst_identcode_range-sign = lc_sign.
        lst_identcode_range-option = lc_option_cp.
        CLEAR lv_idcode.
        lv_idcode = lst_identcode-identcode.
        SHIFT lv_idcode+0(4) LEFT DELETING LEADING '0'.

        lst_identcode_range-low  = lv_idcode+0(4).
        APPEND lst_identcode_range TO lir_identcode.
        CLEAR lst_identcode.
      ENDLOOP.
    ENDIF.
    IF lir_identcode IS NOT INITIAL.
      SELECT
         jrnl_grp_code,
         society,
         society_acrnym
         FROM zqtc_jgc_society
         INTO TABLE @DATA(li_jgc_society)
         WHERE jrnl_grp_code IN @lir_identcode
           AND digital_relevant = @abap_true.
      IF sy-subrc EQ 0.
        SORT li_jgc_society BY jrnl_grp_code.
*        CLEAR lst_society_data.
*        LOOP AT li_jgc_society INTO DATA(lst_society_knr).
**        Populate society
*          lst_society_range-sign = lc_sign.
*          lst_society_range-option = lc_option.
*          lst_society_range-low = lst_society_knr-society.
*          APPEND lst_society_range TO lir_society.
*          CLEAR: lst_society_range,lst_society_knr.
*        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.

*  Fetch membership category from TBZ9A
  IF li_vbpa IS NOT INITIAL.
*
    DATA(li_vbpa_tmp) = li_vbpa.
    SORT li_vbpa_tmp BY kunnr.
    DELETE ADJACENT DUPLICATES FROM li_vbpa_tmp COMPARING kunnr.
* Checking for BP releationships
    IF lir_society[] IS NOT INITIAL.
      SELECT relnr,
           partner1,
           partner2,
           date_to,
           date_from
           FROM but050
           INTO TABLE @DATA(li_but050)
           FOR ALL ENTRIES IN @li_vbpa_tmp
           WHERE partner1 = @li_vbpa_tmp-kunnr
           AND   partner2 IN @lir_society
           AND   date_to  GE @sy-datum
           AND   date_from LE @sy-datum.
      IF sy-subrc = 0.
        DESCRIBE TABLE li_but050 LINES DATA(lv_lines).
        IF lv_lines GT 1.
* If more than one BP relationship found the through error
          READ TABLE li_vbpa_tmp INTO DATA(lst_vbpa_tmp) WITH KEY parvw = lc_parvw.
          MESSAGE e585(zqtc_r2) WITH lst_vbpa_tmp-kunnr INTO lst_bapiret-message.
*      To update return table with messages
          PERFORM f_update_return CHANGING lst_bapiret
                                   fp_li_bapiret.
          RETURN.
        ENDIF.
      ELSE.
* If more than one BP relationship found the through error
        READ TABLE li_vbpa_tmp INTO lst_vbpa_tmp WITH KEY parvw = lc_parvw.
        MESSAGE e585(zqtc_r2) WITH lst_vbpa_tmp-kunnr INTO lst_bapiret-message.
*      To update return table with messages
        PERFORM f_update_return CHANGING lst_bapiret
                                 fp_li_bapiret.
        RETURN.
      ENDIF.
    ENDIF.
    IF li_vbpa_tmp IS NOT INITIAL.
      SELECT
        b~partner1, "partner1
        t~spras,    " Language
        t~rtitl    " Title
        FROM but050 AS b
        INNER JOIN tbz9a AS t ON b~reltyp = t~reltyp   "#EC CI_BUFFJOIN
        INTO TABLE @DATA(li_membercat)
        FOR ALL ENTRIES IN @li_vbpa_tmp
*        WHERE b~partner1 = @li_vbpa_tmp-customer
        WHERE b~partner1 = @li_vbpa_tmp-kunnr
        AND   b~partner2 IN @lir_society
        AND   b~date_to  GE @sy-datum
        AND   b~date_from LE @sy-datum.
*
      IF sy-subrc EQ 0.
*        SORT li_membercat BY partner1.
        SORT li_membercat BY partner1 spras.
      ENDIF.
* To get the customer language based on that all the texts are displayed in
* customer language.
      SELECT kunnr,
             spras
             FROM kna1
             INTO TABLE @DATA(li_kna1)
             FOR ALL ENTRIES IN @li_vbpa_tmp
             WHERE kunnr = @li_vbpa_tmp-kunnr.
      IF sy-subrc EQ 0.
        SORT li_kna1 BY kunnr.
      ENDIF.
      SELECT partner
             type
             name_org1
             name_org2
             name_last
             name_first
             FROM but000
             INTO TABLE li_but000
             FOR ALL ENTRIES IN li_vbpa_tmp
             WHERE partner = li_vbpa_tmp-kunnr.
      IF sy-subrc = 0.
        SORT li_but000 BY partner.
      ENDIF.
    ENDIF.

* To use the table for delete adjacent and use in for all entries
    CLEAR li_vbpa_tmp.
    li_vbpa_tmp[] = li_vbpa[].
*    SORT li_vbpa_tmp BY address.
*    DELETE ADJACENT DUPLICATES FROM li_vbpa_tmp COMPARING address.
    SORT li_vbpa_tmp BY adrnr.
    DELETE ADJACENT DUPLICATES FROM li_vbpa_tmp COMPARING adrnr.
    IF li_vbpa_tmp IS NOT INITIAL.
      SELECT addrnumber,
             title,
             name1,
             name2,
             street,
             city1,
             country,
             langu,
             post_code1,
             tel_number,
             fax_number,region
             INTO TABLE @DATA(li_adrc)
             FROM adrc " as a INNER JOIN kna1 as b On a~adrnr = b~adrnr
             FOR ALL ENTRIES IN @li_vbpa_tmp
             WHERE addrnumber = @li_vbpa_tmp-adrnr.
      IF sy-subrc EQ 0.
        SORT li_adrc BY addrnumber.
      ENDIF.

      SELECT
        a~addrnumber,       " Address number
        a~smtp_addr,         " Email
        a~smtp_srch
        FROM adr6 AS a
        INTO TABLE @DATA(li_adr6)
        FOR ALL ENTRIES IN @li_vbpa_tmp
*        WHERE a~addrnumber = @li_vbpa_tmp-address.
        WHERE a~addrnumber = @li_vbpa_tmp-adrnr.
      IF sy-subrc EQ 0 AND lir_email_s_range IS NOT INITIAL.
        DELETE li_adr6 WHERE smtp_srch NOT IN lir_email_s_range.
      ENDIF.
    ENDIF.

    IF li_adrc IS NOT INITIAL.
      SORT li_adrc BY country.
      SELECT
        t~spras,
        t~land1,
        t~landx50      " Country Name
        FROM t005t AS t                                 "#EC CI_GENBUFF
        INTO TABLE @DATA(li_t005t)
        FOR ALL ENTRIES IN @li_adrc
        WHERE land1 = @li_adrc-country.
*        AND   t~spras = @sy-langu.
      IF sy-subrc EQ 0.
        SORT li_t005t BY spras land1.
      ENDIF.
    ENDIF.
    DATA(li_adrc_title) = li_adrc[].
    DELETE li_adrc_title WHERE title IS INITIAL.
    SORT li_adrc_title BY title.
    DELETE ADJACENT DUPLICATES FROM li_adrc_title COMPARING title.
    IF li_adrc_title IS NOT INITIAL.
      SELECT langu,
             title,
             title_medi
             FROM tsad3t
             INTO TABLE @DATA(li_tsad3t)
             FOR ALL ENTRIES IN @li_adrc_title
             WHERE title = @li_adrc_title-title.
      IF sy-subrc EQ 0.
*        SORT li_tsad3t BY title.
        SORT li_tsad3t BY langu title.
      ENDIF.

    ENDIF.
  ENDIF.

*  Population of final output table
  CLEAR lst_order_detail.
  IF li_order_detail IS NOT INITIAL.
    SORT li_order_detail BY vbeln posnr.
    DELETE ADJACENT DUPLICATES FROM li_order_detail COMPARING vbeln posnr.

    DATA(li_item_tmp) = li_item[].
    SORT li_item_tmp BY matnr.
    DELETE ADJACENT DUPLICATES FROM li_item_tmp COMPARING matnr.

    IF lir_media IS NOT INITIAL.
      SELECT matnr,
             ismmediatype
        FROM mara
        INTO TABLE @DATA(li_mara)
        FOR ALL ENTRIES IN @li_item_tmp
        WHERE matnr = @li_item_tmp-matnr.
*        AND   ismmediatype IN @lir_media.
      IF sy-subrc EQ 0.
        SORT li_mara BY matnr.
        LOOP AT li_mara INTO DATA(lst_mara).
          lst_mara_rng-sign = lc_sign.
          lst_mara_rng-option = lc_option.
          lst_mara_rng-low = lst_mara-matnr.
          APPEND lst_mara_rng TO lir_mara.
          CLEAR lst_mara_rng.
        ENDLOOP.
*        DELETE li_item WHERE material NOT IN lir_mara.
        DELETE li_item WHERE matnr NOT IN lir_mara.

* Get Media type description
        DATA(li_mara_tmp) = li_mara.
        SORT li_mara_tmp BY ismmediatype.
        DELETE ADJACENT DUPLICATES FROM li_mara_tmp COMPARING ismmediatype.
        DELETE li_mara_tmp WHERE ismmediatype IS INITIAL.
        IF li_mara_tmp IS NOT INITIAL.
          SELECT ismmediatype,
                 bezeichnung
            FROM tjpmedtpt
            INTO TABLE @DATA(li_mediatyp)
            FOR ALL ENTRIES IN @li_mara_tmp
            WHERE ismmediatype = @li_mara_tmp-ismmediatype
              AND spras = @lv_dflt_langu.
          IF sy-subrc EQ 0.
            SORT li_mediatyp BY ismmediatype.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    IF li_mara[] IS NOT INITIAL.
      SELECT matnr,maktx FROM makt INTO TABLE @DATA(li_makt)
        FOR ALL ENTRIES IN @li_mara
        WHERE matnr = @li_mara-matnr.
      IF sy-subrc EQ 0.
        SORT li_makt[] BY matnr.
      ENDIF.
    ENDIF.
    IF li_order_detail[] IS NOT INITIAL.
      SELECT vbelv vbeln FROM vbfa
                         INTO TABLE li_vbfa_p
                         FOR ALL ENTRIES IN li_order_detail
                         WHERE vbeln = li_order_detail-vbeln
                         AND   posnn = space
                         AND   vbtyp_n = 'B'.      "#EC CI_NO_TRANSFORM
      IF sy-subrc = 0 AND  li_vbfa_p[] IS NOT INITIAL.
        SELECT vbeln audat FROM vbak                      "#EC CI_SUBRC
                           INTO TABLE li_vbak
                           FOR ALL ENTRIES IN li_vbfa_p
                           WHERE vbeln = li_vbfa_p-vbelv. "#EC CI_NO_TRANSFORM

      ENDIF.
      SELECT vbelv vbeln FROM vbfa
                         INTO TABLE li_vbfa_s
                         FOR ALL ENTRIES IN li_order_detail
                         WHERE vbelv = li_order_detail-vbeln
                         AND   posnn = space
                         AND   vbtyp_n = 'G'.
      IF sy-subrc = 0.
        LOOP AT li_vbfa_s INTO lst_vbfa_s.
          DELETE li_order_detail WHERE vbeln = lst_vbfa_s-vbelv.

        ENDLOOP.
        IF li_order_detail[] IS INITIAL.
          MESSAGE e584(zqtc_r2) INTO lst_bapiret-message.
*          MESSAGE e000(zqtc_r2) WITH text-023 INTO lst_bapiret-message.
          PERFORM f_update_return CHANGING lst_bapiret
                                         fp_li_bapiret.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
    SORT li_vbkd BY vbeln posnr.
    SORT li_adrc BY addrnumber.
    SORT li_adr6 BY addrnumber.
    SORT li_vbpa BY vbeln posnr parvw.
    SORT li_vbak_c BY vbeln.
    SORT li_jgc_society BY jrnl_grp_code.
    SORT li_item BY vbeln posnr.
    SORT: li_vbfa_p BY vbeln,
          li_vbak   BY vbeln.
    SORT li_identcode BY matnr idcodetype.

* Main Output Loop for CWS
    DELETE li_item WHERE uepos NE 0.
    LOOP AT li_order_detail INTO lst_order_detail.
      READ TABLE li_vbfa_p INTO lst_vbfa_p WITH KEY vbeln = lst_order_detail-vbeln BINARY SEARCH.
      IF sy-subrc = 0.
        li_vbak_t[] = li_vbak[].
        DELETE li_vbak_t WHERE vbeln NE lst_vbfa_p-vbelv.
        SORT li_vbak_t BY vbeln DESCENDING audat.      "#EC CI_SORTLOOP
        READ TABLE li_vbak_t INTO lst_vbak INDEX 1.
        IF sy-subrc = 0.
          lst_final-vbeln = lst_vbak-vbeln.
        ENDIF.
      ENDIF.
*
*     Subscription Number (VBELN)
*      lst_final-vbeln = lst_order_detail-vbeln.
      lst_final-quote_id = lst_order_detail-vbeln.
      READ TABLE li_vbak_c INTO DATA(lst_vbak_c) WITH KEY vbeln = lst_order_detail-vbeln
                                                 BINARY SEARCH.
      IF sy-subrc = 0.
        lst_final-bukrs_vf = lst_vbak_c-bukrs_vf.
      ENDIF.
      READ TABLE li_item INTO DATA(lst_item) WITH KEY vbeln = lst_order_detail-vbeln
                                                      posnr = lst_order_detail-posnr
                                                     BINARY SEARCH.
      IF sy-subrc EQ 0.
        CLEAR lst_identcode.
        READ TABLE li_identcode INTO lst_identcode WITH KEY matnr = lst_item-matnr idcodetype = 'JRNL' BINARY SEARCH.
        IF sy-subrc EQ 0.
          lst_final-jrnl_issn = lst_identcode-identcode.
        ENDIF.

        CLEAR lst_identcode.
        READ TABLE li_identcode INTO lst_identcode WITH KEY matnr = lst_item-matnr idcodetype = 'ZSSN' BINARY SEARCH.
        IF sy-subrc EQ 0.
          lst_final-sapissn = lst_identcode-identcode.
        ENDIF.

        CLEAR lst_identcode.
        READ TABLE li_identcode INTO lst_identcode WITH KEY matnr = lst_item-matnr BINARY SEARCH.
        IF sy-subrc EQ 0.
          CLEAR lv_jgrp_code.
          lv_jgrp_code = lst_identcode-identcode.
          lst_final-jrnl_issn = lv_jgrp_code.
          SHIFT lv_jgrp_code+0(4) LEFT DELETING LEADING '0'.
*          READ TABLE li_jgc_society INTO DATA(lst_jgc_society) WITH KEY jrnl_grp_code = lst_identcode-identcode+0(4) BINARY SEARCH.
          READ TABLE li_jgc_society INTO DATA(lst_jgc_society) WITH KEY jrnl_grp_code = lv_jgrp_code+0(4) BINARY SEARCH.
          IF sy-subrc EQ 0.
            lst_final-sccode = lst_jgc_society-society_acrnym.
          ENDIF.
        ENDIF.
        IF lst_final-sccode IS INITIAL.
*          lst_final-sccode = gv_sccode.
        ENDIF.
*

* Price Fields
        lst_final-waerk = lst_item-waerk.
        lst_final-list_price = lst_item-netwr.
        lst_final-tax_amt = lst_item-mwsbp.
        lst_final-total_price = lst_item-netwr + lst_item-mwsbp.
        IF lst_item-kzwi5 NE 0.
          lst_final-disc_ind = abap_true.
        ENDIF.


        IF lst_item-uepos > 0.
          READ TABLE li_item INTO DATA(lst_item1) WITH KEY vbeln = lst_order_detail-vbeln
                                                           posnr = lst_item-uepos
                                                           BINARY SEARCH.
          IF sy-subrc EQ 0.
            lst_final-arktx = lst_item1-arktx.
          ENDIF.
        ENDIF.

*
*       Double Billing
        IF lst_item-mvgr5 IN lir_mvgr5_1.
          lst_final-double_bill = lc_yes.
        ELSEIF  lst_item-mvgr5 IN lir_mvgr5_2.
          lst_final-double_bill = lc_no.
        ENDIF.

        CLEAR lv_flag.
*
        READ TABLE li_vbpa INTO DATA(lst_vbpa) WITH KEY vbeln = lst_item-vbeln
                                                        posnr = lst_item-posnr
                                                        parvw = lc_parvw
                                                        BINARY SEARCH.
        IF sy-subrc EQ 0.
          lv_flag = abap_true.
          lst_final-bp_shipto = lst_vbpa-kunnr.      " BP ID Ship-to (WE)
          READ TABLE li_bp1020 INTO DATA(lst_bp1020) WITH KEY partnr = lst_vbpa-kunnr BINARY SEARCH.
          IF sy-subrc EQ 0.
            lst_final-stceg = lst_bp1020-stceg.
          ENDIF.
        ELSE.
          CLEAR lst_vbpa.
*
          READ TABLE li_vbpa INTO lst_vbpa   WITH KEY vbeln = lst_item-vbeln
                                                      posnr = lc_posnr
                                                      parvw = lc_parvw
                                                      BINARY SEARCH.
          IF sy-subrc EQ 0.
            lv_flag = abap_true.
            lst_final-bp_shipto = lst_vbpa-kunnr.      " BP ID Ship-to (WE)

            READ TABLE li_bp1020 INTO DATA(lst_bp1020_1) WITH KEY partnr = lst_vbpa-kunnr BINARY SEARCH.
            IF sy-subrc EQ 0.
              lst_final-stceg = lst_bp1020_1-stceg.
            ENDIF.
          ENDIF.
        ENDIF.

        IF lv_flag IS NOT INITIAL.
*
*        Cust Id
          lst_final-kunnr = lst_vbpa-kunnr.
          READ TABLE li_kna1 INTO DATA(lst_kna1) WITH KEY kunnr = lst_vbpa-kunnr BINARY SEARCH.
*        Membership Category population(RTITL)
          READ TABLE li_membercat INTO DATA(lst_membercat) WITH KEY partner1 = lst_vbpa-kunnr
                                                                    spras    = lst_kna1-spras
                                                                    BINARY SEARCH.
          IF sy-subrc EQ 0.
*          Membership Category
            lst_final-rtitl = lst_membercat-rtitl.
          ELSE.
            READ TABLE li_membercat INTO lst_membercat WITH KEY partner1 = lst_vbpa-kunnr
                                                                spras    = lv_dflt_langu
                                                                BINARY SEARCH.
            IF sy-subrc EQ 0.
*          Membership Category
              lst_final-rtitl = lst_membercat-rtitl.
            ENDIF.
          ENDIF.

*
          READ TABLE li_adrc INTO DATA(lst_adrc) WITH KEY addrnumber = lst_vbpa-adrnr
*                                                          langu = sy-langu
                                                          BINARY SEARCH.

          IF sy-subrc EQ 0.
*            Address1
            READ TABLE li_tsad3t INTO DATA(lst_tsad3t) WITH KEY langu = lst_kna1-spras
                                                                title = lst_adrc-title
                                                       BINARY SEARCH.
            IF sy-subrc EQ 0.
*            Title Text
              lst_final-title_text = lst_tsad3t-title_medi.
              CONCATENATE lst_tsad3t-title_medi lst_adrc-name1 INTO DATA(lv_string) SEPARATED BY space.
              lst_final-title_medi = lv_string.
            ELSE.
              READ TABLE li_tsad3t INTO lst_tsad3t WITH KEY langu = lv_dflt_langu
                                                            title = lst_adrc-title
                                                            BINARY SEARCH.
              IF sy-subrc EQ 0.
*            Title Text
                lst_final-title_text = lst_tsad3t-title_medi.
                CLEAR lv_string.
                CONCATENATE lst_tsad3t-title_medi lst_adrc-name1 INTO lv_string SEPARATED BY space.
                lst_final-title_medi = lv_string.
              ELSE.
                lst_final-title_medi = lst_adrc-name1.
              ENDIF.
            ENDIF.
            READ TABLE li_but000 INTO lst_but000 WITH KEY partner = lst_vbpa-kunnr
                                                 BINARY SEARCH.
            IF sy-subrc = 0.
              IF lst_but000-type = lc_type.
*            First Name
                lst_final-first_name = lst_but000-name_first.
*            Last Name
                lst_final-last_name = lst_but000-name_last.
              ELSE.
*            First Name
                lst_final-first_name = lst_but000-name_org1.
*            Last Name
                lst_final-last_name  = lst_but000-name_org2.
              ENDIF.


            ENDIF.


*          Address4
            lst_final-street = lst_adrc-street.
*          Address5
            lst_final-city1 = lst_adrc-city1.
*          Country
            lst_final-country = lst_adrc-country.
*          Postal Code
            lst_final-post_code1 = lst_adrc-post_code1.
*          Telephone
            lst_final-tel_number = lst_adrc-tel_number.
*          Fax Number
            lst_final-fax_number = lst_adrc-fax_number.
            lst_final-region = lst_adrc-region.
*            READ TABLE li_t005t INTO DATA(lst_t005t) WITH KEY spras = sy-langu
            READ TABLE li_t005t INTO DATA(lst_t005t) WITH KEY spras = lst_kna1-spras

                                                              land1 = lst_adrc-country
                                                              BINARY SEARCH.
            IF sy-subrc EQ 0.
              lst_final-landx50 = lst_t005t-landx50.
            ELSE.
** Binary Search is not used as we want to take any first language that is existing for that country.
              READ TABLE li_t005t INTO lst_t005t  WITH KEY  spras = lv_dflt_langu
                                                            land1 = lst_adrc-country.
              IF sy-subrc EQ 0.
                lst_final-landx50 = lst_t005t-landx50.
              ENDIF.
            ENDIF.
          ENDIF.
*        Email Address
*          READ TABLE li_adr6 INTO DATA(lst_adr6) WITH KEY addrnumber = lst_vbpa-address BINARY SEARCH.
          READ TABLE li_adr6 INTO DATA(lst_adr6) WITH KEY addrnumber = lst_vbpa-adrnr BINARY SEARCH.
          IF sy-subrc EQ 0.
*          Email
            lst_final-smtp_addr = lst_adr6-smtp_addr.
          ENDIF.
        ENDIF.

*      Department & Company Population
        CLEAR:lv_flag, lst_vbpa.
        READ TABLE li_vbpa INTO lst_vbpa WITH KEY vbeln = lst_item-vbeln
                                                  posnr = lst_item-posnr
                                                  parvw = lc_parvw_ag
                                                  BINARY SEARCH.
        IF sy-subrc EQ 0.
          lv_flag = abap_true.
        ELSE.
          READ TABLE li_vbpa INTO lst_vbpa WITH KEY vbeln = lst_item-vbeln
                                                    posnr = lc_posnr
                                                    parvw = lc_parvw_ag
                                                  BINARY SEARCH.
          IF sy-subrc EQ 0.
            lv_flag = abap_true.
          ENDIF.
        ENDIF.
        IF lv_flag IS NOT INITIAL.
*
          IF lst_vbpa-kunnr <> lst_final-kunnr.
            CLEAR lst_adrc.
            READ TABLE li_adrc INTO lst_adrc WITH KEY
                                        addrnumber = lst_vbpa-adrnr
*                                        langu = sy-langu
                                        BINARY SEARCH.
            IF sy-subrc EQ 0.
*            Department(NAME1)
              lst_final-name1 = lst_adrc-name1.
*            Company(Name2)
              lst_final-name2 = lst_adrc-name2.
*            Address2
              lst_final-name11 = lst_adrc-name1.
*            Address3
              lst_final-name21 = lst_adrc-name2.


            ENDIF.
          ENDIF.
        ENDIF.

        CLEAR lv_flag.
*
        READ TABLE li_vbkd INTO DATA(lst_vbkd) WITH KEY vbeln = lst_item-vbeln
                                                        posnr = lst_item-posnr
                                                        BINARY SEARCH.
        IF sy-subrc EQ 0.
          lv_flag = abap_true.
          lst_final-pltyp = lst_vbkd-pltyp.              " Price List/priceregion
          lst_final-konda = lst_vbkd-konda.              " Price Group
          lst_final-kvgr1 = lst_vbkd-kdgrp.              " Customer Group
        ELSE.
          READ TABLE li_vbkd INTO lst_vbkd WITH KEY vbeln = lst_item-vbeln
                                                    posnr = lc_posnr
                                                    BINARY SEARCH.
          IF sy-subrc EQ 0.
            lv_flag = abap_true.
            lst_final-pltyp = lst_vbkd-pltyp.
            lst_final-konda = lst_vbkd-konda.              " Price Group
            lst_final-kvgr1 = lst_vbkd-kdgrp.              " Customer Group
          ENDIF.
        ENDIF.

        IF lv_flag IS NOT INITIAL.
*
*        Membership Deal
          lst_final-ihrez = lst_vbkd-ihrez.

*          Your reference
          lst_final-ihrez_e = lst_vbkd-ihrez_e.

*        Payment rate
          IF lst_vbkd-konda = lc_konda_01.
            lst_final-payment_rate = lc_payment_c.
          ELSEIF lst_vbkd-konda = lc_konda_02.
            lst_final-payment_rate = lc_payment_m.
          ELSEIF lst_vbkd-konda = lc_konda_03.
            lst_final-payment_rate = lc_payment_f.
          ELSEIF lst_vbkd-konda = lc_konda_04.
            lst_final-payment_rate = lc_payment_p.
          ENDIF.
*        ENDIF.
          IF lst_vbkd-bsark = lc_bsark.
*         Subscription type
            lst_final-subtype_code = lc_payment_e.
          ELSE.
            IF lst_vbkd-konda = lc_konda_01.
              lst_final-subtype_code = lc_payment_c.
            ELSEIF lst_vbkd-konda = lc_konda_02.
              lst_final-subtype_code = lc_payment_m.
            ELSEIF lst_vbkd-konda = lc_konda_03.
              lst_final-subtype_code = lc_payment_f.
            ENDIF.
          ENDIF.
        ENDIF.

        READ TABLE li_veda INTO DATA(lst_veda) WITH KEY vbeln = lst_item-vbeln
                                                        vposn = lst_item-posnr
                                                        BINARY SEARCH.
        IF sy-subrc EQ 0.
*        Contract Start date
          lst_final-vbegdat = lst_veda-vbegdat.
*        Contract End Date
          lst_final-venddat = lst_veda-venddat.
        ELSE.
          READ TABLE li_veda INTO DATA(lst_veda1) WITH KEY vbeln = lst_item-vbeln
                                                           vposn = lc_posnr
                                                           BINARY SEARCH.
          IF sy-subrc EQ 0.
*        Contract Start date
            lst_final-vbegdat = lst_veda1-vbegdat.
*        Contract End Date
            lst_final-venddat = lst_veda1-venddat.
          ENDIF.
        ENDIF.

        lst_final-pymnt_sts = lv_paymnt_sts.
*
********************************************************************************************
*     Update date
        lst_final-update_date = sy-datum.

*      Cancellation Code
        READ TABLE li_vbuk_vbak INTO DATA(lst_vbuk_vbak) WITH KEY vbeln = lst_item-vbeln
                                                        BINARY SEARCH.
        IF sy-subrc EQ 0
          AND lst_vbuk_vbak-cmgst = lc_cmgst.
          lst_final-vkuegru = lc_yes.
        ELSE.
*
          IF lst_item-abgru IS NOT INITIAL.
            lst_final-vkuegru = lc_yes.
          ELSE.
            READ TABLE li_jkseinterrupt INTO DATA(lst_jkseinterrupt) WITH KEY vbeln = lst_item-vbeln
                                                                              posnr = lst_item-posnr
                                                                              BINARY SEARCH.
            IF sy-subrc EQ 0 AND
              sy-datum >= lst_jkseinterrupt-valid_from AND
                sy-datum <= lst_jkseinterrupt-valid_to
                AND lst_jkseinterrupt-reason IS NOT INITIAL.
              lst_final-vkuegru = lc_yes.
            ELSE.
              CLEAR lst_veda.
*
              READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_item-vbeln
                                                        vposn = lst_item-posnr
                                                        BINARY SEARCH.
              IF sy-subrc EQ 0
                AND sy-datum > lst_veda-venddat.
                lst_final-vkuegru = lc_yes.
              ELSE.
                READ TABLE li_veda INTO lst_veda WITH KEY vbeln = lst_item-vbeln
                                                          vposn = lc_posnr
                                                        BINARY SEARCH.
                IF sy-subrc EQ 0
                  AND sy-datum > lst_veda-venddat.
                  lst_final-vkuegru = lc_yes.
                ELSE.
                  READ TABLE li_vbep INTO DATA(lst_vbep) WITH KEY vbeln = lst_item-vbeln
                                                                  posnr = lst_item-posnr
                                                                  BINARY SEARCH.
                  IF sy-subrc EQ 0
                    AND lst_vbep-lifsp IS NOT INITIAL.
                    lst_final-vkuegru = lc_yes.
                  ELSE.
                    CLEAR lst_vbuk_vbak.
                    READ TABLE li_vbuk_vbak INTO lst_vbuk_vbak WITH KEY vbeln = lst_item-vbeln
                                                                  BINARY SEARCH.
                    IF sy-subrc EQ 0
                      AND lst_vbuk_vbak-lifsk IS NOT INITIAL.
                      lst_final-vkuegru = lc_yes.
                    ELSE.
                      lst_final-vkuegru = lc_no.
                    ENDIF. "Read li_header
                  ENDIF. "Read li_vbep
                ENDIF. "Read li_veda
              ENDIF. "Read li_veda
            ENDIF. "Read li_jkseinterrupt
          ENDIF. "lst_item-reason for rejection
        ENDIF. "Read li_vbuk
* Update Material and Media type
        CLEAR : lst_mara.
        READ TABLE li_mara INTO lst_mara WITH KEY matnr = lst_item-matnr
                                         BINARY SEARCH.
        IF sy-subrc EQ 0.
*  Read media type description
          READ TABLE li_mediatyp INTO DATA(lst_mediatyp) WITH KEY ismmediatype = lst_mara-ismmediatype
                                                         BINARY SEARCH.
          IF sy-subrc EQ 0.
            lst_final-media_type = lst_mediatyp-bezeichnung.
          ENDIF.
          lst_final-matnr      = lst_mara-matnr.

          READ TABLE li_makt INTO DATA(lst_makt) WITH KEY matnr = lst_mara-matnr BINARY SEARCH.
          IF sy-subrc EQ 0.
            lst_final-maktx = lst_makt-maktx.
          ENDIF.
        ENDIF.
        APPEND lst_final TO fp_li_final.
      ENDIF. "li_item read
*      CLEAR: lst_final,lv_flag,lst_vbuk,lst_item,lst_vbkd.
      CLEAR: lst_final, lv_flag, lst_vbuk_vbak, lst_item, lst_vbkd, lst_veda, lst_tsad3t.
    ENDLOOP.
  ENDIF.

*Filtering final output table by importing parameter
  IF fp_li_society IS NOT INITIAL.
    SORT fp_li_final BY sccode.
*    DELETE fp_li_final WHERE sccode NOT IN lir_society_range.
  ENDIF.

  IF fp_li_email IS NOT INITIAL AND lir_email_s_range IS NOT INITIAL.
    SORT fp_li_final BY smtp_addr.
    DELETE fp_li_final WHERE smtp_addr IS INITIAL.
  ENDIF.

  IF fp_li_payment IS NOT INITIAL.
    SORT fp_li_final BY payment_rate.
    DELETE fp_li_final WHERE payment_rate NOT IN lir_payment_rng.
  ENDIF.

  IF fp_li_subtyp IS NOT INITIAL.
    SORT fp_li_final BY subtype_code.
    DELETE fp_li_final WHERE subtype_code NOT IN lir_subtyp_rng.
  ENDIF.

  IF fp_im_cncl_code IS NOT INITIAL.
    SORT fp_li_final BY vkuegru.
    DELETE fp_li_final WHERE vkuegru <> fp_im_cncl_code.
  ENDIF.

  IF fp_im_doublebilling IS NOT INITIAL.
    SORT fp_li_final BY double_bill.
    DELETE fp_li_final WHERE double_bill <> fp_im_doublebilling.
  ENDIF.

  IF fp_li_final IS INITIAL.
    MESSAGE e123(zqtc_r2) INTO lst_bapiret-message.
*      To update return table with messages
    PERFORM f_update_return CHANGING lst_bapiret
                                    fp_li_bapiret.
  ENDIF.

* Sort is done based on the contract end date as end systems need it.
  IF fp_li_final IS NOT INITIAL.
    SORT fp_li_final BY venddat DESCENDING.
  ENDIF.

ENDFORM.   " GET_DATA_CWS
*--EOC by GKAMMILI on 09-10-2020 for OTCM 13923
