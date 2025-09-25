class ZQTCCL_ORDERS_CREATE definition
  public
  final
  create public .

public section.

  class-data:
    I_E506_STAGE type TABLE OF ZQTC_STAGNG_E506 .

  class-methods CREATE_REGULAR_ORDERS
    exporting
      !EX_REG_ORD_OUT type ZQTCTT_REG_ORD_OUT
    changing
      !CH_REG_ORDERS type ZQTCTT_REG_ORD .
  class-methods CREATE_CR_DR_MEMO
    exporting
      !EX_CR_DR_MEMO_OUT type ZQTCTT_CR_DR_MEMO_OUT
    changing
      !CH_CR_DR_MEMO type ZQTCTT_CR_DR_MEMO .
protected section.
private section.

  methods GET_BOM
    importing
      !IM_MATNR type MATNR
      !IM_DWERK type DWERK
      !IM_KWMENG type KWMENG
      !IM_INDEX type SY-TABIX
      !IM_INCPO type INCPO
    changing
      !CH_REG_ORDERS type ZQTCTT_REG_ORD .
  methods UPDATE_LOG_STAGING
    importing
      !IM_LOG_HANDLE type BALLOGHNDL
      !IM_VBELN type VBELN
      !IM_RETURN type BAPIRET2_T
    changing
      !CH_LOGNO type BALOGNR .
ENDCLASS.



CLASS ZQTCCL_ORDERS_CREATE IMPLEMENTATION.


  METHOD create_cr_dr_memo.
*-----------------------------------------------------------------------------------
*METHOD NAME: CREATE_CR_DR_MEMO
*METHOD DESCRIPTION: Creates Mass Credit/Debit Memos
*REFERENCE NO: EAM-1155
*DEVELOPER: Vishnuvardhan Reddy(VCHITTIBAL)
*CREATION DATE: 27/04/2022
*OBJECT ID : E506
* TRANSPORT NUMBER(S):ED2K926870
*-----------------------------------------------------------------------------------

    TYPES: BEGIN OF lty_mvke,
             matnr TYPE  matnr,    " Material Number
             vkorg TYPE  vkorg,    " Sales Organization
             vtweg TYPE vtweg,     " Distribution Channel
             dwerk TYPE dwerk_ext, " Delivering Plant (Own or External)
           END OF lty_mvke.
*====================================================================*
*     L O C A L  I N T E R N A L  T A B L E
*====================================================================*
    DATA: li_sales_itm           TYPE STANDARD TABLE OF bapisditm,  " Communication Fields: Sales and Distribution Document Item
          li_sales_partn         TYPE STANDARD TABLE OF bapiparnr,  " Communications Fields: SD Document Partner: WWW
          li_mvke                TYPE STANDARD TABLE OF lty_mvke
                         INITIAL SIZE 0,
          li_sales_itmx          TYPE STANDARD TABLE OF bapisditmx, " Communication Fields: Sales and Distribution Document Item
          li_sales_text          TYPE STANDARD TABLE OF bapisdtext, " Communication fields: SD texts
          li_sales_schedules_in  TYPE STANDARD TABLE OF bapischdl,
          li_sales_schedules_inx TYPE STANDARD TABLE OF bapischdlx,
          li_return              TYPE STANDARD TABLE OF bapiret2. " Return Parameter
*====================================================================*
*     L O C A L  W O R K A R E A
*====================================================================*
    DATA: lst_sales_hdr_in        TYPE bapisdhd1,  " Communication Fields: Sales and Distribution Document Header
          lst_sales_hdr_inx       TYPE bapisdhd1x, " Checkbox Fields for Sales and Distribution Document Header
          lst_sales_itm           TYPE bapisditm,  " Communication Fields: Sales and Distribution Document Item
          lst_sales_partn         TYPE bapiparnr,  " Communications Fields: SD Document Partner: WWW
          lst_cr_dr_memo_dummy    TYPE zstqtc_cr_dr_memo,
          lst_cr_dr_memo_out      TYPE zstqtc_cr_dr_memo_out,
          lst_sales_itmx          TYPE bapisditmx, " Communication Fields: Sales and Distribution Document Item
          lst_sales_text          TYPE bapisdtext, " Communication fields: SD texts
          lst_sales_schedules_in  TYPE bapischdl,
          lst_sales_schedules_inx TYPE bapischdlx.
*====================================================================*
*     L O C A L  V A R I A B L E
*====================================================================*
    DATA: lv_cr_dr_memo TYPE bapivbeln-vbeln, " Sales Document
          lv_index      TYPE sy-tabix,
          lo_obj        TYPE REF TO zqtccl_orders_create.
*====================================================================*
*     L O C A L  C O N S T A N T S
*====================================================================*
    CONSTANTS: lc_posnr  TYPE posnr VALUE '000000', " Item number of the SD document
               lc_i      TYPE char1    VALUE 'I',       "Information
               lc_ag     TYPE parvw    VALUE 'AG',       "Sold to party
               lc_we     TYPE parvw    VALUE 'WE',       "Ship to party
               lc_re     TYPE parvw    VALUE 'RE',       "Bill to party
               lc_rg     TYPE parvw    VALUE 'RG',       "Payer
               lc_cr     TYPE parvw    VALUE 'CR',       "Forwarding Agent
               lc_ve     TYPE parvw    VALUE 'VE',       "Sales Rep
               lc_format TYPE tdformat  VALUE '*',       " Tag column
               lc_zadm   TYPE auart VALUE 'ZADM',        "Sales Document Type
               lc_zacm   TYPE auart VALUE 'ZACM'.        "Sales Document Type

    REFRESH ex_cr_dr_memo_out[].

    DATA(li_cr_dr_memo) = ch_cr_dr_memo.

* Sort by Order Type
    SORT li_cr_dr_memo BY auart.

    DELETE li_cr_dr_memo WHERE auart IS INITIAL.         "#EC CI_STDSEQ
    DELETE ADJACENT DUPLICATES FROM li_cr_dr_memo COMPARING auart.

    IF li_cr_dr_memo[] IS NOT INITIAL.
      SELECT auart,	 " Sales Document Type
             incpo   " Increment of item number in the SD document
        FROM tvak    " Sales Document Types
        INTO TABLE @DATA(li_tvak)
        FOR ALL ENTRIES IN @li_cr_dr_memo
        WHERE auart EQ @li_cr_dr_memo-auart.
      IF sy-subrc IS INITIAL.
        SORT li_tvak BY auart.
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF.

    CLEAR li_cr_dr_memo[].
    li_cr_dr_memo[] = ch_cr_dr_memo.

    SORT li_cr_dr_memo BY matnr vkorg vtweg.
    DELETE ADJACENT DUPLICATES FROM li_cr_dr_memo COMPARING matnr
                                                        vkorg
                                                        vtweg.
    IF li_cr_dr_memo IS NOT INITIAL.
      SELECT matnr, " Material Number
             vkorg, " Sales Organization
             vtweg, " Distribution Channel
             dwerk  " Plant
        FROM mvke   " Sales Data for Material
        INTO TABLE @li_mvke
        FOR ALL ENTRIES IN @li_cr_dr_memo
        WHERE matnr = @li_cr_dr_memo-matnr
        AND   vkorg = @li_cr_dr_memo-vkorg
        AND   vtweg = @li_cr_dr_memo-vtweg.

      IF sy-subrc IS INITIAL.
        SORT li_mvke BY matnr vkorg vtweg.
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF li_cr_dr_memo IS NOT INITIAL

** Get Details from Staging Table
    IF ch_cr_dr_memo[] IS NOT INITIAL.
      SELECT * FROM zqtc_stagng_e506 INTO TABLE @i_e506_stage
        FOR ALL ENTRIES IN @ch_cr_dr_memo
        WHERE zuid_upld EQ @ch_cr_dr_memo-zoid
          AND zoid EQ @ch_cr_dr_memo-identifier AND
          zlogno EQ @ch_cr_dr_memo-zlogno.
      IF sy-subrc EQ 0.
        SORT i_e506_stage.
      ENDIF.
    ENDIF.

** Create Local Object
    CREATE OBJECT lo_obj.

    SORT:"ch_cr_dr_memo[] BY identifier,
         li_mvke BY matnr vkorg vtweg.

    LOOP AT ch_cr_dr_memo INTO DATA(lst_cr_dr_memo).
      lv_index = sy-tabix.
      lst_cr_dr_memo_dummy = lst_cr_dr_memo.

*   Whenever we see new header entry, we refresh the tables
      AT NEW identifier.
** Copy details to output structure.
        MOVE-CORRESPONDING lst_cr_dr_memo_dummy TO lst_cr_dr_memo_out.

        CLEAR: lst_sales_hdr_in,
               lst_sales_hdr_inx,
               lv_cr_dr_memo,
               li_return,
               li_sales_itm,
               li_sales_itmx,
               li_sales_partn,
               li_sales_text,
               li_sales_schedules_in,
               li_sales_schedules_inx.
      ENDAT.

*  Populate the Header records
      IF lst_cr_dr_memo_dummy-posnr IS INITIAL.

        IF lst_sales_hdr_in IS INITIAL.

          lst_sales_hdr_in-doc_type    = lst_cr_dr_memo_dummy-auart.
          lst_sales_hdr_inx-updateflag = lc_i.

          IF lst_sales_hdr_in-doc_type IS NOT INITIAL.
            lst_sales_hdr_inx-doc_type = abap_true.
          ELSE. " ELSE -> IF lst_sales_hdr_in-doc_type IS NOT INITIAL
            lst_sales_hdr_inx-doc_type = abap_false.
          ENDIF. " IF lst_sales_hdr_in-doc_type IS NOT INITIAL

          lst_sales_hdr_in-sales_org  = lst_cr_dr_memo_dummy-vkorg.
          IF lst_sales_hdr_in-sales_org IS NOT INITIAL.
            lst_sales_hdr_inx-sales_org = abap_true.
          ELSE. " ELSE -> IF lst_sales_hdr_in-sales_org IS NOT INITIAL
            lst_sales_hdr_inx-sales_org = abap_false.
          ENDIF. " IF lst_sales_hdr_in-sales_org IS NOT INITIAL

          lst_sales_hdr_in-distr_chan = lst_cr_dr_memo_dummy-vtweg.
          lst_sales_hdr_inx-distr_chan = abap_true.  " NPOLINA ERP7763 ED2K914078
          IF lst_sales_hdr_inx-distr_chan IS NOT INITIAL.
            lst_sales_hdr_inx-distr_chan = abap_true.
          ELSE. " ELSE -> IF lst_sales_hdr_inx-distr_chan IS NOT INITIAL
            lst_sales_hdr_inx-distr_chan = abap_false.
          ENDIF. " IF lst_sales_hdr_inx-distr_chan IS NOT INITIAL

          lst_sales_hdr_in-division   = lst_cr_dr_memo_dummy-spart.
          IF lst_sales_hdr_in-division IS NOT INITIAL.
            lst_sales_hdr_inx-division = abap_true.
          ELSE. " ELSE -> IF lst_sales_hdr_in-division IS NOT INITIAL
            lst_sales_hdr_inx-division = abap_false.
          ENDIF. " IF lst_sales_hdr_in-division IS NOT INITIAL

          lst_sales_hdr_in-ord_reason  = lst_cr_dr_memo_dummy-augru.
          IF lst_sales_hdr_in IS NOT INITIAL.
            lst_sales_hdr_inx-ord_reason = abap_true.
          ENDIF. " IF lst_sales_hdr_in IS NOT INITIAL

          lst_sales_hdr_in-purch_no_c = lst_cr_dr_memo_dummy-bstnk.
          IF lst_sales_hdr_in-purch_no_c IS NOT INITIAL.
            lst_sales_hdr_inx-purch_no_c = abap_true.
          ENDIF. " IF lst_sales_hdr_in-purch_no_c IS NOT INITIAL

          lst_sales_hdr_in-po_method = lst_cr_dr_memo_dummy-bsark.
          IF lst_sales_hdr_in-po_method IS NOT INITIAL.
            lst_sales_hdr_inx-po_method = abap_true.
          ENDIF. " IF lst_sales_hdr_in-po_method IS NOT INITIAL
*====================================================================*
*  Header Partner Details
*====================================================================*
** Sold To Party
          IF lst_cr_dr_memo_dummy-ag_kunnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_ag.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-ag_kunnr.
            lst_sales_partn-itm_number = lc_posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Ship To Party
          IF lst_cr_dr_memo_dummy-we_kunnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_we.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-we_kunnr.
            lst_sales_partn-itm_number = lc_posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Bill To Party
          IF lst_cr_dr_memo_dummy-re_kunnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_re.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-re_kunnr.
            lst_sales_partn-itm_number = lc_posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Payer
          IF lst_cr_dr_memo_dummy-rg_kunnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_rg.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-rg_kunnr.
            lst_sales_partn-itm_number = lc_posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Forwarding Agent
          IF lst_cr_dr_memo_dummy-cr_lifnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_cr.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-cr_lifnr.
            lst_sales_partn-itm_number = lc_posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Sales rep
          IF lst_cr_dr_memo_dummy-ve_pernr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_ve.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-ve_pernr.
            lst_sales_partn-itm_number = lc_posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.
*====================================================================*
*      BAPI TEXT
*====================================================================*
          IF lst_cr_dr_memo_dummy-hd1_stxh IS NOT INITIAL.
            lst_sales_text-itm_number = lc_posnr.
            lst_sales_text-text_id    = '0004'.
            lst_sales_text-langu      = sy-langu.
            lst_sales_text-format_col = lc_format.
            lst_sales_text-text_line  = lst_cr_dr_memo_dummy-hd1_stxh.

            APPEND lst_sales_text TO li_sales_text.
            CLEAR  lst_sales_text.
          ENDIF.

          IF lst_cr_dr_memo_dummy-hd2_stxh IS NOT INITIAL.
            lst_sales_text-itm_number = lc_posnr.
            lst_sales_text-text_id    = '0007'.
            lst_sales_text-langu      = sy-langu.
            lst_sales_text-format_col = lc_format.
            lst_sales_text-text_line  = lst_cr_dr_memo_dummy-hd2_stxh.

            APPEND lst_sales_text TO li_sales_text.
            CLEAR  lst_sales_text.
          ENDIF.

*     Get Increment of item number in the SD document
          IF lst_cr_dr_memo_dummy-auart IS NOT INITIAL.
            DATA(lst_tvak) = li_tvak[ auart = lst_cr_dr_memo_dummy-auart ] . "#EC CI_STDSEQ
          ENDIF. " IF lst_cr_dr_memo_dummy-auart IS NOT INITIAL

        ELSE. " ELSE -> IF lst_sales_hdr_in IS INITIAL
*====================================================================*
*  Header Partner Details
*====================================================================*
** Sold to party
          IF lst_cr_dr_memo_dummy-ag_kunnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_ag.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-ag_kunnr.
            lst_sales_partn-itm_number = lc_posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Ship To Party
          IF lst_cr_dr_memo_dummy-we_kunnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_we.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-we_kunnr.
            lst_sales_partn-itm_number = lc_posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Bill To Party
          IF lst_cr_dr_memo_dummy-re_kunnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_re.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-re_kunnr.
            lst_sales_partn-itm_number = lc_posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Payer
          IF lst_cr_dr_memo_dummy-rg_kunnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_rg.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-rg_kunnr.
            lst_sales_partn-itm_number = lc_posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Forwarding Agent
          IF lst_cr_dr_memo_dummy-cr_lifnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_cr.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-cr_lifnr.
            lst_sales_partn-itm_number = lc_posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Sales rep
          IF lst_cr_dr_memo_dummy-ve_pernr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_ve.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-ve_pernr.
            lst_sales_partn-itm_number = lc_posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.
        ENDIF. " IF lst_sales_hdr_in IS INITIAL

      ELSE. " ELSE -> IF lst_cr_dr_memo_dummy-posnr IS INITIAL

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lst_cr_dr_memo_dummy-posnr
          IMPORTING
            output = lst_sales_itm-itm_number.

        READ TABLE li_sales_itm WITH KEY itm_number =
        lst_sales_itm-itm_number TRANSPORTING NO FIELDS. "#EC CI_STDSEQ

        IF sy-subrc IS NOT INITIAL.

*====================================================================*
*    Check BOM to determine line item numbers
*====================================================================*

          READ TABLE li_mvke ASSIGNING FIELD-SYMBOL(<lfs_mvke>)
          WITH KEY matnr = lst_cr_dr_memo_dummy-matnr   " Material Number
                   vkorg = lst_sales_hdr_in-sales_org  " Sales Organization
                   vtweg = lst_sales_hdr_in-distr_chan " Distribution Channel
                   BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            IF <lfs_mvke>-dwerk IS NOT INITIAL.

              CALL METHOD lo_obj->get_bom
                EXPORTING
                  im_matnr      = lst_cr_dr_memo_dummy-matnr
                  im_dwerk      = <lfs_mvke>-dwerk
                  im_kwmeng     = lst_cr_dr_memo_dummy-kwmeng
                  im_index      = lv_index
                  im_incpo      = lst_tvak-incpo
                CHANGING
                  ch_reg_orders = ch_cr_dr_memo. "#EC ENH_OK

            ENDIF. " IF <lfs_mvke>-dwerk IS NOT INITIAL
          ENDIF. " IF sy-subrc IS INITIAL

*====================================================================*
* Sales item level
*====================================================================*

          IF lst_sales_hdr_inx-updateflag EQ lc_i.
            lst_sales_itmx-updateflag = abap_true.
          ENDIF. " IF lst_sales_hdr_inx-updateflag EQ c_i


          lst_sales_itm-material   = lst_cr_dr_memo_dummy-matnr.
          IF lst_sales_itm-material IS NOT INITIAL.
            lst_sales_itmx-material = abap_true.
          ELSE. " ELSE -> IF lst_sales_itm-material IS NOT INITIAL
            lst_sales_itmx-material = abap_false.
          ENDIF. " IF lst_sales_itm-material IS NOT INITIAL

          lst_sales_itm-hg_lv_item = lc_posnr.
          IF  lst_sales_itm-hg_lv_item IS NOT INITIAL.
            lst_sales_itmx-hg_lv_item = abap_true.
          ELSE. " ELSE -> IF lst_sales_itm-hg_lv_item IS NOT INITIAL
            lst_sales_itmx-hg_lv_item = abap_false.
          ENDIF. " IF lst_sales_itm-hg_lv_item IS NOT INITIAL


          lst_sales_itm-target_qty = lst_cr_dr_memo_dummy-kwmeng.
          IF lst_sales_itm-target_qty IS NOT INITIAL.
            lst_sales_itmx-target_qty = abap_true.
          ELSE. " ELSE -> IF lst_sales_itm-target_qty IS NOT INITIAL
            lst_sales_itmx-target_qty = abap_false.
          ENDIF. " IF lst_sales_itm-target_qty IS NOT INITIAL


          IF lst_cr_dr_memo_dummy-pstyv IS NOT INITIAL.
            lst_sales_itm-item_categ = lst_cr_dr_memo_dummy-pstyv.
            lst_sales_itmx-item_categ = abap_true.
          ENDIF. " IF lst_cr_dr_memo_dummy-pstyv IS NOT INITIAL

          APPEND lst_sales_itm TO li_sales_itm.
          CLEAR lst_sales_itm.

          APPEND lst_sales_itmx TO li_sales_itmx.
          CLEAR lst_sales_itmx.

** Scheduling Lines
          IF lst_sales_hdr_in-doc_type EQ lc_zadm OR lst_sales_hdr_in-doc_type EQ lc_zacm.
            lst_sales_schedules_in-itm_number  = lst_cr_dr_memo_dummy-posnr.
            lst_sales_schedules_inx-itm_number = abap_true.
            lst_sales_schedules_in-req_qty     = lst_cr_dr_memo_dummy-kwmeng.
            lst_sales_schedules_inx-req_qty    = abap_true.

            APPEND lst_sales_schedules_in TO li_sales_schedules_in.
            CLEAR lst_sales_schedules_in.

            APPEND lst_sales_schedules_inx TO li_sales_schedules_inx.
            CLEAR lst_sales_schedules_inx.
          ENDIF.

*====================================================================*
*  BAPI TEXT
*====================================================================*

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_cr_dr_memo_dummy-posnr
            IMPORTING
              output = lst_sales_text-itm_number.

          IF lst_cr_dr_memo_dummy-it1_stxh IS NOT INITIAL.
            lst_sales_text-itm_number = lst_cr_dr_memo_dummy-posnr.
            lst_sales_text-text_id    = '0004'.
            lst_sales_text-langu      = sy-langu.
            lst_sales_text-format_col = lc_format.
            lst_sales_text-text_line  = lst_cr_dr_memo_dummy-it1_stxh.

            APPEND lst_sales_text TO li_sales_text.
            CLEAR  lst_sales_text.
          ENDIF.

          IF lst_cr_dr_memo_dummy-it2_stxh IS NOT INITIAL.
            lst_sales_text-itm_number = lst_cr_dr_memo_dummy-posnr.
            lst_sales_text-text_id    = '0010'.
            lst_sales_text-langu      = sy-langu.
            lst_sales_text-format_col = lc_format.
            lst_sales_text-text_line  = lst_cr_dr_memo_dummy-it2_stxh.

            APPEND lst_sales_text TO li_sales_text.
            CLEAR  lst_sales_text.
          ENDIF.

*====================================================================*
* Sales partner
*====================================================================*

** Sold to party
          IF lst_cr_dr_memo_dummy-ag_kunnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_ag.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-ag_kunnr.
            lst_sales_partn-itm_number = lst_cr_dr_memo_dummy-posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Ship To Party
          IF lst_cr_dr_memo_dummy-we_kunnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_we.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-we_kunnr.
            lst_sales_partn-itm_number = lst_cr_dr_memo_dummy-posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Bill To Party
          IF lst_cr_dr_memo_dummy-re_kunnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_re.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-re_kunnr.
            lst_sales_partn-itm_number = lst_cr_dr_memo_dummy-posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Payer
          IF lst_cr_dr_memo_dummy-rg_kunnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_rg.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-rg_kunnr.
            lst_sales_partn-itm_number = lst_cr_dr_memo_dummy-posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Forwarding Agent
          IF lst_cr_dr_memo_dummy-cr_lifnr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_cr.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-cr_lifnr.
            lst_sales_partn-itm_number = lst_cr_dr_memo_dummy-posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

** Sales rep
          IF lst_cr_dr_memo_dummy-ve_pernr IS NOT INITIAL.
            lst_sales_partn-partn_role = lc_ve.
            lst_sales_partn-partn_numb = lst_cr_dr_memo_dummy-ve_pernr.
            lst_sales_partn-itm_number = lst_cr_dr_memo_dummy-posnr.
            APPEND lst_sales_partn TO li_sales_partn.
            CLEAR lst_sales_partn.
          ENDIF.

        ELSE. " ELSE -> IF sy-subrc IS NOT INITIAL

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_cr_dr_memo_dummy-posnr
            IMPORTING
              output = lst_sales_partn-itm_number.


          APPEND lst_sales_partn TO li_sales_partn.
          CLEAR lst_sales_partn.
        ENDIF. " IF sy-subrc IS NOT INITIAL

      ENDIF. " IF lst_cr_dr_memo_dummy-posnr IS INITIAL

*   Before a new header record/ last entry - Create contract
      AT END OF identifier.
*     Bapi call
        CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
          EXPORTING
            sales_header_in     = lst_sales_hdr_in
            sales_header_inx    = lst_sales_hdr_inx
          IMPORTING
            salesdocument_ex    = lv_cr_dr_memo
          TABLES
            return              = li_return
            sales_items_in      = li_sales_itm
            sales_items_inx     = li_sales_itmx
            sales_partners      = li_sales_partn
            sales_schedules_in  = li_sales_schedules_in
            sales_schedules_inx = li_sales_schedules_inx
            sales_text          = li_sales_text.

        IF NOT li_return IS INITIAL.
          CALL METHOD lo_obj->update_log_staging
            EXPORTING
              im_log_handle = lst_cr_dr_memo_dummy-log_handle
              im_vbeln      = lv_cr_dr_memo
              im_return     = li_return
            CHANGING
              ch_logno      = lst_cr_dr_memo_dummy-zlogno.

          READ TABLE li_return INTO DATA(lst_return) WITH KEY type = 'E' . "#EC CI_STDSEQ
          IF sy-subrc IS INITIAL.
*            MOVE-CORRESPONDING lst_cr_dr_memo_dummy TO lst_cr_dr_memo_out.

            lst_cr_dr_memo_out-status     = text-001.               "Error
            lst_cr_dr_memo_out-message    = lst_return-message.
            APPEND lst_cr_dr_memo_out TO ex_cr_dr_memo_out.
            CLEAR: lst_return,
                   lst_cr_dr_memo_out.
          ELSE. " ELSE -> IF sy-subrc IS INITIAL

            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' .

            READ TABLE li_return INTO lst_return WITH KEY type = 'S'
                                                           id  = 'V1'
                                                        number = '311'. "#EC CI_STDSEQ
            IF sy-subrc IS INITIAL.
*              MOVE-CORRESPONDING lst_cr_dr_memo_dummy TO lst_cr_dr_memo_out.
              lst_cr_dr_memo_out-status     = text-002.               "Success
              lst_cr_dr_memo_out-vbeln      = lv_cr_dr_memo.
              lst_cr_dr_memo_out-message    = lst_return-message.
              APPEND lst_cr_dr_memo_out TO ex_cr_dr_memo_out.
              CLEAR: lst_return,
                     lst_cr_dr_memo_out.
            ENDIF. " IF sy-subrc IS INITIAL
          ENDIF. " IF sy-subrc IS INITIAL
        ENDIF. " IF NOT li_return IS INITIAL

        CLEAR: lst_sales_hdr_in,
               lv_cr_dr_memo,
               li_return,
               li_sales_itm,
               li_sales_partn.
      ENDAT.
    ENDLOOP. " LOOP AT ch_cr_dr_memo INTO DATA(lst_cr_dr_memo)

  ENDMETHOD.


  METHOD create_regular_orders.
*-----------------------------------------------------------------------------------
*METHOD NAME: CREATE_REGULAR_ORDERS
*METHOD DESCRIPTION: Creates Mass Regular Orders
*REFERENCE NO: EAM-1155
*DEVELOPER: Vishnuvardhan Reddy(VCHITTIBAL)
*CREATION DATE: 27/04/2022
*OBJECT ID : E506
* TRANSPORT NUMBER(S):ED2K926870
*-----------------------------------------------------------------------------------


*====================================================================*
*       Local Internal Table
*====================================================================*
    DATA: li_return             TYPE STANDARD TABLE OF bapiret2,   " Return messages
          li_itm                TYPE STANDARD TABLE OF bapisditm,  " Item data
          li_ord_sch            TYPE STANDARD TABLE OF bapischdl,  " Communication Fields for Maintaining SD Doc. Schedule Lines
          li_partn              TYPE STANDARD TABLE OF bapiparnr,  " Contract partner
          li_cond               TYPE STANDARD TABLE OF bapicond,   " Contract conditions
          li_extensionin        TYPE STANDARD TABLE OF bapiparex,  " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
          li_text               TYPE STANDARD TABLE OF bapisdtext, " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
*====================================================================*
*       Local Work-area
*====================================================================*
          lst_hdrin             TYPE bapisdhd1,  " Header data
          lst_text              TYPE bapisdtext, " Communication fields: SD texts
          lst_hrdinx            TYPE bapisdhd1x, " Header data extended for promo code
          lst_ord_sch           TYPE bapischdl,  " Communication Fields for Maintaining SD Doc. Schedule Lines
          lst_itm               TYPE bapisditm,  " Item data
          lst_bape_vbak         TYPE bape_vbak,  " BAPI Interface for Customer Enhancements to Table VBAK
          lst_bape_vbakx        TYPE bape_vbakx, " BAPI Interface for Customer Enhancements to Table VBAK
          lst_bape_vbap         TYPE bape_vbap,  " BAPI Interface for Customer Enhancements to Table VBAK
          lst_bape_vbapx        TYPE bape_vbapx, " BAPI Interface for Customer Enhancements to Table VBAK
          lst_extensionin       TYPE bapiparex,  " Ref. structure for BAPI parameter ExtensionIn/ExtensionOut
          lst_partn             TYPE bapiparnr,  " Contract partner
          lst_regular_ord_dummy TYPE zstqtc_reg_ord,
          lst_reg_ord_out       TYPE zstqtc_reg_ord_out,
*====================================================================*
*       Local Variable
*====================================================================*
          lv_salesdocin         TYPE bapivbeln-vbeln, "for export field
          lv_index              TYPE sy-tabix,
          lo_obj                TYPE REF TO zqtccl_orders_create.
*====================================================================*
*       Local Constants
*====================================================================*
    CONSTANTS:lc_bape_vbak  TYPE char9  VALUE 'BAPE_VBAK',  " Bape_vbak of type CHAR9
              lc_bape_vbap  TYPE char9  VALUE 'BAPE_VBAP',  " Bape_vbak of type CHAR9
              lc_posnr      TYPE posnr  VALUE '000000',     " Item number of the SD document
              lc_bape_vbakx TYPE char10 VALUE 'BAPE_VBAKX', " Bape_vbak of type CHAR9
              lc_bape_vbapx TYPE char10 VALUE 'BAPE_VBAPX', " Bape_vbak of type CHAR9
              lc_ag         TYPE parvw    VALUE 'AG',       "Sold to party
              lc_we         TYPE parvw    VALUE 'WE',       "Ship to party
              lc_re         TYPE parvw    VALUE 'RE',       "Bill to party
              lc_rg         TYPE parvw    VALUE 'RG',       "Payer
              lc_cr         TYPE parvw    VALUE 'CR',       "Forwarding Agent
              lc_ve         TYPE parvw    VALUE 'VE',       "Sales Rep
              lc_format     TYPE tdformat  VALUE '*'.       " Tag column

    REFRESH ex_reg_ord_out[].
* Get Increment of item number in the SD document
    DATA(li_order) = ch_reg_orders.

* Sort by Order Type
    SORT li_order BY auart.

    DELETE li_order WHERE auart IS INITIAL.              "#EC CI_STDSEQ
    DELETE ADJACENT DUPLICATES FROM li_order COMPARING auart.

    IF li_order[] IS NOT INITIAL.
      SELECT auart,	 " Sales Document Type
             incpo   " Increment of item number in the SD document
        FROM tvak    " Sales Document Types
        INTO TABLE @DATA(li_tvak)
        FOR ALL ENTRIES IN @li_order
        WHERE auart EQ @li_order-auart.
      IF sy-subrc IS INITIAL.
        SORT li_tvak BY auart.
      ENDIF. " IF sy-subrc IS INITIAL
    ENDIF. " IF li_order[] IS NOT INITIAL

**  Select Material Sales Area details from MVKE
    CLEAR li_order[].
    li_order = ch_reg_orders.
    SORT li_order BY matnr vkorg vtweg auart.
    DELETE ADJACENT DUPLICATES FROM li_order COMPARING matnr vkorg vtweg.
    IF li_order[] IS NOT INITIAL.
      SELECT matnr,
             vkorg,
             vtweg,
             dwerk
        INTO TABLE @DATA(li_mvke)
        FROM mvke
        FOR ALL ENTRIES IN @li_order
        WHERE matnr = @li_order-matnr
          AND vkorg = @li_order-vkorg
          AND vtweg = @li_order-vtweg.
      IF sy-subrc IS NOT INITIAL.
        CLEAR li_order[].
      ENDIF.
    ENDIF.

** Get details from Staging Table
    IF ch_reg_orders[] IS NOT INITIAL.
      SELECT * FROM zqtc_stagng_e506 INTO TABLE @i_e506_stage
        FOR ALL ENTRIES IN @ch_reg_orders
        WHERE      zuid_upld EQ @ch_reg_orders-zoid
          AND zoid EQ @ch_reg_orders-identifier AND
          zlogno EQ @ch_reg_orders-zlogno.
      IF sy-subrc EQ 0.
        SORT i_e506_stage.
      ENDIF.
    ENDIF.

** Create Object
    CREATE OBJECT lo_obj.

    SORT: "ch_reg_orders[] BY identifier,
          li_mvke BY matnr vkorg vtweg.

    LOOP AT ch_reg_orders INTO DATA(lst_regular_ord).
      lv_index = sy-tabix.
      CLEAR lst_regular_ord_dummy.
      lst_regular_ord_dummy = lst_regular_ord.
**   Whenever we see new header entry, we refresh the tables
      AT NEW identifier.
** Copy details to the output structure.
        MOVE-CORRESPONDING lst_regular_ord_dummy TO lst_reg_ord_out.
        CLEAR: lst_regular_ord,
               li_itm,
               li_partn,
               li_cond,
               lst_hdrin,
               lst_hrdinx,
               li_ord_sch,
               lv_salesdocin,
               li_return,
               li_text,
               li_extensionin.
      ENDAT.

*  Populate the Header records
      IF lst_regular_ord_dummy-posnr IS INITIAL.
*
**====================================================================*
** Populate Header structure
**====================================================================*
        IF lst_hdrin IS INITIAL.

          lst_hdrin-doc_type   = lst_regular_ord_dummy-auart.
          lst_hdrin-sales_org  = lst_regular_ord_dummy-vkorg.
          lst_hdrin-distr_chan = lst_regular_ord_dummy-vtweg.
          lst_hdrin-division   = lst_regular_ord_dummy-spart.
          lst_hdrin-purch_no_c = lst_regular_ord_dummy-bstnk.
          lst_hdrin-ord_reason = lst_regular_ord_dummy-augru.
          lst_hdrin-purch_no_s = lst_regular_ord_dummy-bstkd_e.

*        " Convert to internal format
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_regular_ord_dummy-bsark
            IMPORTING
              output = lst_hdrin-po_method.

*====================================================================*
*     Add ZZPROMO to Extension structure of BAPI
*====================================================================*
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_regular_ord_dummy-zzpromo
            IMPORTING
              output = lst_regular_ord_dummy-zzpromo.

*        lst_bape_vbak-vbeln       = lst_regular_ord_dummy-vbeln.
          lst_bape_vbak-zzpromo     = lst_regular_ord_dummy-zzpromo.
          lst_extensionin-structure = lc_bape_vbak .
          lst_extensionin+30(960)   = lst_bape_vbak.
          APPEND lst_extensionin TO li_extensionin.
          CLEAR  lst_extensionin.

*        lst_bape_vbakx-vbeln      = lst_regular_ord_dummy-vbeln.
          lst_bape_vbakx-zzpromo    = abap_true.
          lst_extensionin-structure = lc_bape_vbakx.
          lst_extensionin+30(960)   = lst_bape_vbakx.
          APPEND lst_extensionin TO li_extensionin.
          CLEAR  lst_extensionin.

*====================================================================*
*     Header INX structure population for Header
*====================================================================*
          CLEAR lst_hrdinx.

          IF lst_hdrin-doc_type  IS NOT INITIAL.
            lst_hrdinx-doc_type = abap_true.
          ELSE. " ELSE -> IF lst_hdrin-doc_type IS NOT INITIAL
            lst_hrdinx-doc_type = abap_false.
          ENDIF. " IF lst_hdrin-doc_type IS NOT INITIAL

          IF lst_hdrin-sales_org IS NOT INITIAL.
            lst_hrdinx-sales_org = abap_true.
          ELSE. " ELSE -> IF lst_hdrin-sales_org IS NOT INITIAL
            lst_hrdinx-sales_org = abap_false.
          ENDIF. " IF lst_hdrin-sales_org IS NOT INITIAL

          IF lst_hdrin-distr_chan IS NOT INITIAL.
            lst_hrdinx-distr_chan = abap_true.
          ELSE. " ELSE -> IF lst_hdrin-distr_chan IS NOT INITIAL
            lst_hrdinx-distr_chan = abap_false.
          ENDIF. " IF lst_hdrin-distr_chan IS NOT INITIAL

          IF lst_hdrin-division  IS NOT INITIAL.
            lst_hrdinx-division = abap_true.
          ELSE. " ELSE -> IF lst_hdrin-division IS NOT INITIAL
            lst_hrdinx-division = abap_false.
          ENDIF. " IF lst_hdrin-division IS NOT INITIAL

          IF lst_hdrin-purch_no_c IS NOT INITIAL.
            lst_hrdinx-purch_no_c = abap_true.
          ELSE. " ELSE -> IF lst_hdrin-purch_no_c IS NOT INITIAL
            lst_hrdinx-purch_no_c = abap_false.
          ENDIF. " IF lst_hdrin-purch_no_c IS NOT INITIAL

          IF lst_hdrin-purch_no_s IS NOT INITIAL.
            lst_hrdinx-purch_no_s = abap_true.
          ELSE. " ELSE -> IF lst_hdrin-purch_no_s IS NOT INITIAL
            lst_hrdinx-purch_no_s = abap_false.
          ENDIF. " IF lst_hdrin-purch_no_s IS NOT INITIAL

          IF lst_hdrin-po_method IS NOT INITIAL.
            lst_hrdinx-po_method = abap_true.
          ELSE. " ELSE -> IF lst_hdrin-ct_valid_f IS NOT INITIAL
            lst_hrdinx-po_method = abap_false.
          ENDIF.

*====================================================================*
*     Populating Partner Table
*====================================================================*
** Sold To Party
          IF lst_regular_ord_dummy-ag_kunnr IS  NOT INITIAL.
            lst_partn-itm_number = lc_posnr.
            lst_partn-partn_role = lc_ag.
            lst_partn-partn_numb = lst_regular_ord_dummy-ag_kunnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Ship To Party
          IF lst_regular_ord_dummy-we_kunnr IS  NOT INITIAL.
            lst_partn-itm_number = lc_posnr.
            lst_partn-partn_role = lc_we.
            lst_partn-partn_numb = lst_regular_ord_dummy-we_kunnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Bill To Party
          IF lst_regular_ord_dummy-re_kunnr IS  NOT INITIAL.
            lst_partn-itm_number = lc_posnr.
            lst_partn-partn_role = lc_re.
            lst_partn-partn_numb = lst_regular_ord_dummy-re_kunnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Payer
          IF lst_regular_ord_dummy-rg_kunnr IS  NOT INITIAL.
            lst_partn-itm_number = lc_posnr.
            lst_partn-partn_role = lc_rg.
            lst_partn-partn_numb = lst_regular_ord_dummy-rg_kunnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Forwarding Agent
          IF lst_regular_ord_dummy-cr_lifnr IS  NOT INITIAL.
            lst_partn-itm_number = lc_posnr.
            lst_partn-partn_role = lc_cr.
            lst_partn-partn_numb = lst_regular_ord_dummy-cr_lifnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Sales Rep
          IF lst_regular_ord_dummy-ve_pernr IS  NOT INITIAL.
            lst_partn-itm_number = lc_posnr.
            lst_partn-partn_role = lc_ve.
            lst_partn-partn_numb = lst_regular_ord_dummy-ve_pernr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.
**====================================================================*
**      BAPI TEXT
**====================================================================*
          IF lst_regular_ord_dummy-hd1_stxh IS NOT INITIAL.
            lst_text-itm_number = lc_posnr.
            lst_text-text_id    = '0004'.
            lst_text-langu      = sy-langu.
            lst_text-format_col = lc_format.
            lst_text-text_line  = lst_regular_ord_dummy-hd1_stxh.

            APPEND lst_text TO li_text.
            CLEAR  lst_text.
          ENDIF.

          IF lst_regular_ord_dummy-hd2_stxh IS NOT INITIAL.
            lst_text-itm_number = lc_posnr.
            lst_text-text_id    = '0007'.
            lst_text-langu      = sy-langu.
            lst_text-format_col = lc_format.
            lst_text-text_line  = lst_regular_ord_dummy-hd2_stxh.

            APPEND lst_text TO li_text.
            CLEAR  lst_text.
          ENDIF.

*     Get Increment of item number in the SD document
          IF lst_regular_ord-auart IS NOT INITIAL.
            DATA(lst_tvak) = li_tvak[ auart = lst_regular_ord_dummy-auart ]. "#EC CI_STDSEQ
          ENDIF. " IF lst_regulat_ord-auart IS NOT INITIAL

        ELSE. " ELSE -> IF lst_hdrin IS INITIAL
**====================================================================*
**     Populating Partner Table
**====================================================================*
** Sold To Party
          IF lst_regular_ord_dummy-ag_kunnr IS  NOT INITIAL.
            lst_partn-itm_number = lc_posnr.
            lst_partn-partn_role = lc_ag.
            lst_partn-partn_numb = lst_regular_ord_dummy-ag_kunnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Ship To Party
          IF lst_regular_ord_dummy-we_kunnr IS  NOT INITIAL.
            lst_partn-itm_number = lc_posnr.
            lst_partn-partn_role = lc_we.
            lst_partn-partn_numb = lst_regular_ord_dummy-we_kunnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Bill To Party
          IF lst_regular_ord_dummy-re_kunnr IS  NOT INITIAL.
            lst_partn-itm_number = lc_posnr.
            lst_partn-partn_role = lc_re.
            lst_partn-partn_numb = lst_regular_ord_dummy-re_kunnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Payer
          IF lst_regular_ord_dummy-rg_kunnr IS  NOT INITIAL.
            lst_partn-itm_number = lc_posnr.
            lst_partn-partn_role = lc_rg.
            lst_partn-partn_numb = lst_regular_ord_dummy-rg_kunnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Forwarding Agent
          IF lst_regular_ord_dummy-cr_lifnr IS  NOT INITIAL.
            lst_partn-itm_number = lc_posnr.
            lst_partn-partn_role = lc_cr.
            lst_partn-partn_numb = lst_regular_ord_dummy-cr_lifnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Sales Rep
          IF lst_regular_ord_dummy-ve_pernr IS  NOT INITIAL.
            lst_partn-itm_number = lst_regular_ord_dummy-posnr.
            lst_partn-partn_role = lc_ve.
            lst_partn-partn_numb = lst_regular_ord_dummy-ve_pernr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

        ENDIF. " IF lst_hdrin IS INITIAL
*
      ELSE. " ELSE -> IF lst_regular_ord_dummy-posnr IS INITIAL

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lst_regular_ord_dummy-posnr
          IMPORTING
            output = lst_regular_ord_dummy-posnr.

        READ TABLE li_itm WITH KEY itm_number =
        lst_regular_ord_dummy-posnr TRANSPORTING NO FIELDS. "#EC CI_STDSEQ
        IF sy-subrc IS NOT INITIAL.

*====================================================================*
*    Check BOM to determine line item numbers
*====================================================================*

          READ TABLE li_mvke ASSIGNING FIELD-SYMBOL(<lfs_mvke>)
          WITH KEY matnr = lst_regular_ord_dummy-matnr " Material Number
                   vkorg = lst_hdrin-sales_org     " Sales Organization
                   vtweg = lst_hdrin-distr_chan    " Distribution Channel
                   BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            IF <lfs_mvke>-dwerk IS NOT INITIAL.

              CALL METHOD lo_obj->get_bom
                EXPORTING
                  im_matnr      = lst_regular_ord_dummy-matnr
                  im_dwerk      = <lfs_mvke>-dwerk
                  im_kwmeng     = lst_regular_ord_dummy-kwmeng
                  im_index      = lv_index
                  im_incpo      = lst_tvak-incpo
                CHANGING
                  ch_reg_orders = ch_reg_orders.

            ENDIF. " IF <lfs_mvke>-dwerk IS NOT INITIAL
          ENDIF. " IF sy-subrc IS INITIAL
**====================================================================*
** First populate item table
**====================================================================*
          lst_itm-itm_number     =  lst_regular_ord_dummy-posnr.
          lst_itm-material       =  lst_regular_ord_dummy-matnr.
*          lst_itm-target_qty     =  lst_regular_ord_dummy-kwmeng.
          lst_itm-item_categ     =  lst_regular_ord_dummy-pstyv.
          lst_itm-hg_lv_item     =  lc_posnr.

*        " Convert to internal format
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = lst_regular_ord_dummy-bsark
            IMPORTING
              output = lst_itm-po_method.

          APPEND lst_itm TO li_itm.
          CLEAR lst_itm.

          lst_ord_sch-itm_number = lst_regular_ord_dummy-posnr.
          lst_ord_sch-req_qty    = lst_regular_ord_dummy-kwmeng.

          APPEND lst_ord_sch TO li_ord_sch.
          CLEAR  lst_ord_sch.
**====================================================================*
**      BAPI TEXT
**====================================================================*
          IF lst_regular_ord_dummy-it1_stxh IS NOT INITIAL.
            lst_text-itm_number = lst_regular_ord_dummy-posnr.
            lst_text-text_id    = '0004'.
            lst_text-langu      = sy-langu.
            lst_text-format_col = lc_format.
            lst_text-text_line  = lst_regular_ord_dummy-it1_stxh.

            APPEND lst_text TO li_text.
            CLEAR  lst_text.
          ENDIF.

          IF lst_regular_ord_dummy-it2_stxh IS NOT INITIAL.
            lst_text-itm_number = lst_regular_ord_dummy-posnr.
            lst_text-text_id    = '0010'.
            lst_text-langu      = sy-langu.
            lst_text-format_col = lc_format.
            lst_text-text_line  = lst_regular_ord_dummy-it2_stxh.

            APPEND lst_text TO li_text.
            CLEAR  lst_text.
          ENDIF.
**====================================================================*
** Populate the Extensionin table
**====================================================================*
*        lst_bape_vbap-vbeln       = lst_regular_ord_dummy-vbeln.
          lst_bape_vbap-posnr       = lst_regular_ord_dummy-posnr.
          lst_bape_vbap-zzpromo     = lst_regular_ord_dummy-zzpromo.
          lst_extensionin-structure = lc_bape_vbap.
          lst_extensionin+30(960)   = lst_bape_vbap.
          APPEND lst_extensionin TO li_extensionin.
          CLEAR lst_extensionin.

          CLEAR lst_bape_vbapx.
*        lst_bape_vbapx-vbeln      = lst_regular_ord_dummy-vbeln.
          lst_bape_vbapx-posnr      = lst_regular_ord_dummy-posnr.
          lst_bape_vbapx-zzpromo    = abap_true.
          lst_extensionin-structure = lc_bape_vbapx.
          lst_extensionin+30(960)   = lst_bape_vbapx.
          APPEND lst_extensionin TO li_extensionin.
          CLEAR  lst_extensionin.
**====================================================================*
**     Populate partner details
**====================================================================*
          IF lst_regular_ord_dummy-ag_kunnr IS  NOT INITIAL.
            lst_partn-itm_number = lst_regular_ord_dummy-posnr.
            lst_partn-partn_role = lc_ag.
            lst_partn-partn_numb = lst_regular_ord_dummy-ag_kunnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Ship To Party
          IF lst_regular_ord_dummy-we_kunnr IS  NOT INITIAL.
            lst_partn-itm_number = lst_regular_ord_dummy-posnr.
            lst_partn-partn_role = lc_we.
            lst_partn-partn_numb = lst_regular_ord_dummy-we_kunnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Bill To Party
          IF lst_regular_ord_dummy-re_kunnr IS  NOT INITIAL.
            lst_partn-itm_number = lst_regular_ord_dummy-posnr.
            lst_partn-partn_role = lc_re.
            lst_partn-partn_numb = lst_regular_ord_dummy-re_kunnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Payer
          IF lst_regular_ord_dummy-rg_kunnr IS  NOT INITIAL.
            lst_partn-itm_number = lst_regular_ord_dummy-posnr.
            lst_partn-partn_role = lc_rg.
            lst_partn-partn_numb = lst_regular_ord_dummy-rg_kunnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Forwarding Agent
          IF lst_regular_ord_dummy-cr_lifnr IS  NOT INITIAL.
            lst_partn-itm_number = lst_regular_ord_dummy-posnr.
            lst_partn-partn_role = lc_cr.
            lst_partn-partn_numb = lst_regular_ord_dummy-cr_lifnr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.

** Sales Rep
          IF lst_regular_ord_dummy-ve_pernr IS  NOT INITIAL.
            lst_partn-itm_number = lst_regular_ord_dummy-posnr.
            lst_partn-partn_role = lc_ve.
            lst_partn-partn_numb = lst_regular_ord_dummy-ve_pernr.

            APPEND lst_partn TO li_partn.
            CLEAR lst_partn.
          ENDIF.
        ENDIF. " IF sy-subrc IS NOT INITIAL
      ENDIF. " IF lst_regular_ord_dummy-posnr IS INITIAL

      AT END OF identifier.
**====================================================================*
**     Call Bapi
**====================================================================*
        CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
          EXPORTING
            order_header_in    = lst_hdrin
            order_header_inx   = lst_hrdinx
          IMPORTING
            salesdocument      = lv_salesdocin
          TABLES
            return             = li_return
            order_items_in     = li_itm
            order_schedules_in = li_ord_sch
            order_partners     = li_partn
*           order_conditions_in = li_cond
            order_text         = li_text
            extensionin        = li_extensionin.
        IF NOT li_return IS INITIAL.
          CALL METHOD lo_obj->update_log_staging
            EXPORTING
              im_log_handle = lst_regular_ord_dummy-log_handle
              im_vbeln      = lv_salesdocin
              im_return     = li_return
            CHANGING
              ch_logno      = lst_regular_ord_dummy-zlogno.

          READ TABLE li_return INTO DATA(lst_return) WITH KEY type = 'E'. "#EC CI_STDSEQ
          IF sy-subrc IS INITIAL.
*            MOVE-CORRESPONDING lst_regular_ord_dummy TO lst_reg_ord_out.

            lst_reg_ord_out-status     = text-001.               "Error
            lst_reg_ord_out-message    = lst_return-message.
            APPEND lst_reg_ord_out TO ex_reg_ord_out.
            CLEAR: lst_return,
                   lst_reg_ord_out.
          ELSE. " ELSE -> IF sy-subrc IS INITIAL

            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' .

            READ TABLE li_return INTO lst_return WITH KEY type = 'S'
                                                           id  = 'V1'
                                                        number = '311'. "#EC CI_STDSEQ
            IF sy-subrc IS INITIAL.
*              MOVE-CORRESPONDING lst_regular_ord_dummy TO lst_reg_ord_out.
              lst_reg_ord_out-status     = text-002.               "Success
              lst_reg_ord_out-vbeln      = lv_salesdocin.
              lst_reg_ord_out-message    = lst_return-message.
              APPEND lst_reg_ord_out TO ex_reg_ord_out.
              CLEAR: lst_return,
                     lst_reg_ord_out.
            ENDIF. " IF sy-subrc IS INITIAL
          ENDIF. " IF sy-subrc IS INITIAL
        ENDIF. " IF NOT li_return IS INITIAL
      ENDAT.
    ENDLOOP  . " LOOP AT c_reg_ord_out INTO DATA(lst_regular_ord)


  ENDMETHOD.


  METHOD get_bom.
*-----------------------------------------------------------------------------------
*METHOD NAME: GET_BOM
*METHOD DESCRIPTION: Fetches BOM details based on material & Plant
*REFERENCE NO: EAM-1155
*DEVELOPER: Vishnuvardhan Reddy(VCHITTIBAL)
*CREATION DATE: 27/04/2022
*OBJECT ID : E506
* TRANSPORT NUMBER(S):ED2K926870
*-----------------------------------------------------------------------------------


* local internal table for bom
  data : li_bom      type standard table of stpox initial size 0, " BOM Items (Extended for List Displays)
* Local Work Area for BOM Explosions
         lst_topmat  type cstmat, " Start Material Display for BOM Explosions
* Local Variable for target Quantity
         lv_quantity type basmn. " Base quantity

* Move character format to quantity format
    lv_quantity = im_kwmeng.

    CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
      EXPORTING
        capid                 = 'SD01'      " Application ID
        datuv                 = sy-datum    " Date
        emeng                 = lv_quantity " Quantity
        salww                 = abap_true
        mtnrv                 = im_matnr    " Material
        rndkz                 = '2'         " Round off: ' '=always, '1'=never, '2'=only levels > 1
        werks                 = im_dwerk    " Plant
      IMPORTING
        topmat                = lst_topmat
      TABLES
        stb                   = li_bom
      EXCEPTIONS
        alt_not_found         = 1
        call_invalid          = 2
        material_not_found    = 3
        missing_authorization = 4
        no_bom_found          = 5
        no_plant_data         = 6
        no_suitable_bom_found = 7
        conversion_error      = 8
        OTHERS                = 9.
    IF sy-subrc IS INITIAL.
* Delete items which are not Sales Relevant
      DELETE li_bom WHERE rvrel IS INITIAL.  "#EC CI_STDSEQ

      IF li_bom IS NOT INITIAL.

*  Get total number of BOM item
        DATA(lv_bom_lines) = lines( li_bom ).

        LOOP AT ch_reg_orders ASSIGNING FIELD-SYMBOL(<lfs_output>)
                                      FROM  im_index.
          IF <lfs_output>-posnr IS INITIAL.
            EXIT.
          ENDIF. " IF <lfs_output>-posnr is initial

*    No need to change the first line item
          IF sy-tabix NE im_index.
            <lfs_output>-posnr = <lfs_output>-posnr + ( lv_bom_lines * im_incpo ).
          ENDIF. " IF sy-tabix NE fp_index

        ENDLOOP. " LOOP AT fp_i_output ASSIGNING FIELD-SYMBOL(<lfs_output>)
        CLEAR lst_topmat.
      ENDIF. " IF li_bom IS NOT INITIAL
    ENDIF. " IF sy-subrc IS INITIAL

  ENDMETHOD.


  METHOD update_log_staging.
*-----------------------------------------------------------------------------------
*METHOD NAME: UPDATE_LOG_STAGING
*METHOD DESCRIPTION: Updates Satging table ans SLG1 Logs
*REFERENCE NO: EAM-1155
*DEVELOPER: Vishnuvardhan Reddy(VCHITTIBAL)
*CREATION DATE: 27/04/2022
*OBJECT ID : E506
*TRANSPORT NUMBER(S):ED2K926870
*-----------------------------------------------------------------------------------

    DATA:lim_log_handle  TYPE bal_t_logh,
         lst_log_handle TYPE balloghndl,
         lst_msg        TYPE bal_s_msg,
         li_lognum      TYPE bal_t_lgnm.

    CONSTANTS: lc_e  TYPE char1 VALUE 'E',        "Error
               lc_a  TYPE char1 VALUE 'A',        "Error
               lc_d1 TYPE char2 VALUE 'D1',       "Processing Status "Completed
               lc_e2 TYPE char2 VALUE 'E2'.       "Processing Status "File Order Error

    REFRESH: lim_log_handle[].

    READ TABLE im_return TRANSPORTING NO FIELDS WITH KEY type = lc_e. "#EC CI_STDSEQ
    IF sy-subrc EQ 0.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ELSE.
      READ TABLE im_return TRANSPORTING NO FIELDS WITH KEY type = lc_a. "#EC CI_STDSEQ
      IF sy-subrc EQ 0.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
      ENDIF.
    ENDIF.

* Convert Log Number to Internal Format to update Logs Correctly
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ch_logno
      IMPORTING
        output = ch_logno.
    DATA(lim_return) = im_return.
    DELETE ADJACENT DUPLICATES FROM lim_return COMPARING type id number.
    LOOP AT lim_return ASSIGNING FIELD-SYMBOL(<lfs_ret>).
      CLEAR:lst_msg.
      lst_msg-msgid = 'ZQTC_R2'.
      lst_msg-msgno = '000'.
      lst_msg-msgty = <lfs_ret>-type.
      lst_msg-msgv1 = <lfs_ret>-message+0(50).
      lst_msg-msgv2 = <lfs_ret>-message+50(50).
      lst_msg-msgv3 = <lfs_ret>-message+100(50).

      APPEND im_log_handle TO lim_log_handle.
      CALL FUNCTION 'BAL_DB_LOAD'
        EXPORTING
          i_t_log_handle     = lim_log_handle
        EXCEPTIONS
          no_logs_specified  = 1
          log_not_found      = 2
          log_already_loaded = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
        CLEAR lim_log_handle.
      ENDIF.

      lst_log_handle = im_log_handle.
      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle     = lst_log_handle
          i_s_msg          = lst_msg
        EXCEPTIONS
          log_not_found    = 1
          msg_inconsistent = 2
          log_is_full      = 3
          OTHERS           = 4.

      IF sy-subrc EQ 0.
        APPEND lst_log_handle TO lim_log_handle.
        CALL FUNCTION 'BAL_DB_SAVE'
          EXPORTING
            i_client         = sy-mandt
*           i_in_update_task = ' '
            i_save_all       = abap_true
            i_t_log_handle   = lim_log_handle
          IMPORTING
            e_new_lognumbers = li_lognum
          EXCEPTIONS
            log_not_found    = 1
            save_not_allowed = 2
            numbering_error  = 3
            OTHERS           = 4.
        IF sy-subrc EQ 0.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
        ENDIF.
      ENDIF.
    ENDLOOP.


** Update Staging Table
    IF im_vbeln IS NOT INITIAL.
      LOOP AT i_e506_stage ASSIGNING FIELD-SYMBOL(<lfs_stage>) WHERE zlogno = ch_logno. "#EC CI_STDSEQ
        <lfs_stage>-vbeln = im_vbeln.
        <lfs_stage>-zprcstat = lc_d1.
      ENDLOOP.
      MODIFY zqtc_stagng_e506 FROM TABLE i_e506_stage.
    ELSE.
      LOOP AT i_e506_stage ASSIGNING FIELD-SYMBOL(<lfs_stage2>) WHERE zlogno = ch_logno. "#EC CI_STDSEQ
        <lfs_stage2>-vbeln = im_vbeln.
        <lfs_stage2>-zprcstat = lc_e2.
      ENDLOOP.
      MODIFY zqtc_stagng_e506 FROM TABLE i_e506_stage.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
