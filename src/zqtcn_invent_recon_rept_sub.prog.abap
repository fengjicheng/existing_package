*-------------------------------------------------------------------
* PROGRAM NAME: ZQTCR_INVENT_RECO
* PROGRAM DESCRIPTION: Inventory Reconcilliation
* The Purpose of this Report is to enable JRR Report(Printer Reconcillia
* tion) and JDR Report (Distributor Reconcilliation).
* This report will provide summarized as well as detailed report
* Inside this include all the subroutine has been defined.
* DEVELOPER: Lucky Kodwani/Mounika Nallapaneni/Alankruta Patnaik
* CREATION DATE:   2017-03-01
* OBJECT ID: R040
* TRANSPORT NUMBER(S): ED2K905109
*-------------------------------------------------------------------
*-------------------------------------------------------------------
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED2K907465
* REFERENCE NO: ERP-3413
* DEVELOPER: PBANDLAPAL(Pavan Bandlapalli)
* DATE: 26-Jul-2017
* DESCRIPTION: Screen Valdiation errors has been corrected.
*-----------------------------------------------------------------------*
* REVISION HISTORY--------------------------------------------------
* REVISION NO: ED1K909828
* REFERENCE NO: RITM0096792
* DEVELOPER: NPALLA(Nikhilesh Palla)
* DATE: 18-Mar-2018
* DESCRIPTION: To avoid runtime error for Negative Qty (less than 999-)
*-----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZQTCR_INVENT_RECON_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_data .

* Begin of Insert by PBANDLAPAL on 26-Jul-2017 for ERP-3413.
  IF sy-ucomm = c_ucomm_onli OR sy-ucomm = c_ucomm_prin OR
     sy-ucomm = c_ucomm_sjob.
* End of Insert by PBANDLAPAL on 26-Jul-2017 for ERP-3413.
    IF rb_prin  IS NOT INITIAL
     OR rb_distr IS NOT INITIAL.
      IF s_plant IS INITIAL.
        MESSAGE e185(zqtc_r2). " Please provide plant.
      ENDIF. " IF s_plant IS INITIAL
      IF  s_matnr AND s_medprd IS INITIAL.
        MESSAGE e181(zqtc_r2). " Please provide media issue or media product value.
      ELSEIF s_medprd IS NOT INITIAL.
        IF  p_publ IS INITIAL.
          MESSAGE e182(zqtc_r2). " Please provide publication year.
        ENDIF. " IF p_publ IS INITIAL
      ENDIF. " IF s_matnr AND s_medprd IS INITIAL
    ENDIF. " IF rb_prin IS NOT INITIAL
  ENDIF. " Insert by PBANDLAPAL on 26-Jul-2017 for ERP-3413.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MARA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_mara.

  SELECT matnr     " Material Number
         labor     " Laboratory/design office
         ismyearnr " Media issue year number
     FROM mara     " General Material Data
     INTO TABLE i_mara
    WHERE matnr  IN s_matnr
    AND  mtart IN s_mattyp
    AND  labor IN s_matofc
    AND  ismrefmdprod IN s_medprd.
  IF sy-subrc EQ 0.
    IF p_publ IS NOT INITIAL.
      DELETE i_mara WHERE ismyearnr NE p_publ.
    ENDIF. " IF p_publ IS NOT INITIAL
    SORT i_mara BY matnr.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EKPO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_ekpo .

  CONSTANTS : lc_l TYPE eloek VALUE 'L'. " Deletion Indicator in Purchasing Document

  IF i_marc IS NOT INITIAL.
    SELECT a~ebeln   " Purchasing Document Number
           a~ebelp   " Item Number of Purchasing Document
           a~loekz   " Deletion Indicator in Purchasing Document
           a~matnr   " Material Number
           a~werks   " Plant
           a~bednr   " Requirement Tracking Number
           a~menge   " Purchase Order Quantity
           a~meins   " Purchase Order Unit of Measure
           a~netwr   " Net Order Value in PO Currency
           a~pstyp   " Item Category in Purchasing Document
           a~knttp   " Account Assignment Category
           a~emlif   "Vendor to be supplied/who is to receive delivery
           a~elikz   " "Delivery Completed" Indicator
           a~banfn   " Purchase Requisition Number
           a~bnfpo   " Item Number of Purchase Requisition
           b~bsart   " Purchasing Document Type
           b~lifnr   " Vendor Account Number
           b~waers   " Currency Key
      INTO TABLE i_ekpo
      FROM ekpo AS a " Purchasing Document Item
      INNER JOIN  ekko AS b
      ON  a~ebeln = b~ebeln
      FOR ALL ENTRIES IN i_marc
      WHERE a~matnr = i_marc-matnr
      AND   a~werks = i_marc-werks
      AND   a~loekz NE lc_l.
    IF sy-subrc EQ 0.
      SORT  i_ekpo BY matnr werks.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF i_marc IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EKBE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_ekbe.

  IF i_ekpo IS NOT INITIAL.
    SELECT  ebeln                 " Purchasing Document Number
            ebelp                 " Item Number of Purchasing Document
            zekkn                 " Sequential Number of Account Assignment
            vgabe                 " Transaction/event type, purchase order history
            gjahr                 " Material Document Year
            belnr                 " Number of Material Document
            buzei                 " Item in Material Document
            bewtp                 " Purchase Order History Category
            bwart                 " Movement Type (Inventory Management)
            menge                 " Quantity
            dmbtr                 " Amount in Local Currency
            waers                 " Currency Key
            shkzg                 " Debit/Credit indicator
            matnr                 " Material Number
            werks                 " Plant
      FROM ekbe                   " History per Purchasing Document
      INTO TABLE i_ekbe
      FOR ALL ENTRIES IN i_ekpo
      WHERE ebeln = i_ekpo-ebeln
       AND ebelp = i_ekpo-ebelp
      AND ( bewtp = c_bewtp_e
          OR bewtp = c_bewtp_q ). " GR Quantity Only
    IF sy-subrc EQ 0.
* No Action
    ENDIF. " IF sy-subrc EQ 0

  ENDIF. " IF i_ekpo IS NOT INITIAL
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_GET_ZQTC_INVEN_RECON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_zqtc_inven_recon .

  IF i_marc[] IS NOT INITIAL.
    SELECT
      matnr               " Material Number
      werks               " Delivering Plant (Own or External)
      zadjtyp             " Adjustment Type
      zevent              " Event
      zdate               " Transactional date
      zseqno              " Sequence Num
      zsupplm             " Supplement
      zmaildt             " Mail Date
      zsohqty             " Stock On Hand
      zadjqty             " Adjustment Qty
      zprntrn             " Ordered Print Run
      zrcpt               " Receipt Qty
      zmainlbl            " Main Label Qty
      zoffline            " Offline Member Qty
      zconqty             " Contributor Qty
      zebo                " EBO Qty
      zsource             " Source file Name
      zsysdate            " System Date
      ismrefmdprod        " Higher-Level Media Product
      ismyearnr           " Media issue year number
      zfgrdat             " First GR date
      zlgrdat             " Last GR date
      ebeln               " Purchasing Document Number
      mblnr               " Number of Material Document
      xblnr               " Reference Document Number
    FROM zqtc_inven_recon " Table for Inventory Reconciliation Data
    INTO TABLE  i_inven_recon
    FOR ALL ENTRIES IN i_marc
    WHERE matnr = i_marc-matnr
      AND werks = i_marc-werks.
    IF sy-subrc = 0.
      SORT i_inven_recon BY zadjtyp
                            matnr  " Material
                            werks. " plant

    ENDIF. " IF sy-subrc = 0
  ELSE. " ELSE -> IF i_marc[] IS NOT INITIAL
    MESSAGE s123(zqtc_r2) " No records found for the given input parameters
    DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF. " IF i_marc[] IS NOT INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_LFA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_lfa1 .

  IF i_ekpo IS NOT INITIAL.
    SELECT lifnr " Account Number of Vendor or Creditor
          name1  " Name 1
          name2  " Name 2
      FROM lfa1 INTO TABLE  i_lfa1
      FOR ALL ENTRIES IN i_ekpo
     WHERE lifnr = i_ekpo-emlif
      OR   lifnr = i_ekpo-lifnr.
    IF sy-subrc = 0.
      SORT i_lfa1 BY lifnr.
    ENDIF. " IF sy-subrc = 0
  ENDIF. " IF i_ekpo IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MARC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_marc.

  IF i_mara IS NOT INITIAL.
    SELECT matnr " Material Number
           werks " Plant
           dispo " MRP Controller (Materials Planner)
      FROM marc  " Plant Data for Material
      INTO TABLE i_marc
      FOR ALL ENTRIES IN i_mara
      WHERE matnr = i_mara-matnr
      AND   werks IN s_plant
      AND   dispo IN s_medcon.
    IF sy-subrc EQ 0.
      SORT i_marc BY matnr werks.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF i_mara IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ALV_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_alv_output_jrr.


  DATA: lst_layout   TYPE slis_layout_alv.

  CONSTANTS : lc_pf_status   TYPE slis_formname  VALUE 'F_SET_PF_STATUS',
              lc_user_comm   TYPE slis_formname  VALUE 'F_USER_COMMAND_JRR',
              lc_top_of_page TYPE slis_formname  VALUE 'F_TOP_OF_PAGE_JRR_SUMM'.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Displaying Results'(003).

  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.

  PERFORM f_popul_field_cat_jrr_summ.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = lc_pf_status
      i_callback_user_command  = lc_user_comm
      i_callback_top_of_page   = lc_top_of_page
      is_layout                = lst_layout
      it_fieldcat              = i_fcat
      i_save                   = abap_true
      i_default                = space
    TABLES
      t_outtab                 = i_final
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_FINAL
*&---------------------------------------------------------------------*
*   To populate the final table
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM f_populate_final.

  DATA: lv_menge       TYPE bstmg,   " Purchase Order Quantity
        lv_open_gr_qty TYPE bstmg,   " Purchase Order Quantity
        lv_open_po_qty TYPE bstmg,   " Purchase Order Quantity
        lv_netwr       TYPE netwr,   " Net Value in Document Currency
        lv_menge_gr    TYPE bstmg,   " Purchase Order Quantity
        lv_menge_gr_d  TYPE bstmg,   " Purchase Order Quantity
        lv_menge_in    TYPE bstmg,   " Purchase Order Quantity
        lv_dmbtr_in    TYPE dmbtr,   " Invoice amount
        lv_confirmed   TYPE zrcpt,   " Receipt Qty
        lv_sl_no_s     TYPE sytabix, " Row Index of Internal Tables
        lv_po_sub_itm  TYPE sytabix, " Row Index of Internal Tables
        lv_fail_gr     TYPE flag,    " General Flag
        lv_pending_gr  TYPE flag,    " General Flag
        lv_failgr_qty  TYPE zrcpt,   " Quantity
        lv_delv_com    TYPE flag,    " General Flag
        lv_tabix       TYPE sytabix, " ABAP System Field: Row Index of Internal Tables
        lv_tabix_1     TYPE sytabix. " ABAP System Field: Row Index of Internal Tables

  DATA: lst_custom TYPE ty_zqtc_inven_recon, " Table for Inventory Reconciliation Data
*        lst_custom_dummy TYPE ty_zqtc_inven_recon, " Table for Inventory Reconciliation Data
        lst_mara   TYPE ty_mara,
        lst_ekpo   TYPE ty_ekpo,
        lst_ekbe   TYPE ty_ekbe,
        lst_marc   TYPE ty_marc,
        lst_lfa1   TYPE ty_lfa1,
        lst_final  TYPE ty_final,
        lst_final1 TYPE ty_final1.

* Local internal table declaration
  DATA: li_inven_recon TYPE STANDARD TABLE OF ty_zqtc_inven_recon
                       INITIAL SIZE 0,
        li_ekpo        TYPE STANDARD TABLE OF ty_ekpo INITIAL SIZE 0,
        li_ekpo_tmp    TYPE STANDARD TABLE OF ty_ekpo INITIAL SIZE 0.


*----->> Logic of sorting the tables.
* Sort EKPO table based on Material and Plant. Our report will be
* displayed based on material plant combination. So PO quantity will be
* derived from ekpo table based on material and plant. So we are sorting
* EKPO table by material and plant. Also GR or invoice quantity will be
* derived from ekbe table based on PO number and item. So we are sorting
* EKBE table based on EBELN, EBELP. Our program starting point is custom
* table. So we are sorting the custom table also by MATNR and WERKS.
  li_ekpo[] = i_ekpo[].
  DELETE li_ekpo WHERE bsart NE c_nb.

  IF s_print IS NOT INITIAL .
    DELETE li_ekpo WHERE lifnr NOT IN s_print.
  ELSE. " ELSE -> IF s_print IS NOT INITIAL
    DELETE li_ekpo WHERE lifnr IS INITIAL.
  ENDIF. " IF s_print IS NOT INITIAL

  IF s_distr IS NOT INITIAL.
    DELETE li_ekpo WHERE emlif NOT IN s_distr.
  ELSE. " ELSE -> IF s_distr IS NOT INITIAL
    DELETE li_ekpo WHERE emlif IS INITIAL.
  ENDIF. " IF s_distr IS NOT INITIAL

  SORT li_ekpo BY matnr
                 werks.
  li_ekpo_tmp[] = li_ekpo[].
  DELETE ADJACENT DUPLICATES FROM li_ekpo_tmp
  COMPARING matnr
            werks.

  SORT i_ekbe BY ebeln ASCENDING
                 ebelp ASCENDING
                 shkzg DESCENDING
                 belnr ASCENDING.
  li_inven_recon[] = i_inven_recon[].

  SORT li_inven_recon BY matnr
                        werks.
* This portion will only works for adjustment type 'JRR'
* So we are deleting all entries where adjustment type is not JRR.
  DELETE li_inven_recon WHERE zadjtyp NE c_jrr. "'JRR'.


  LOOP AT li_ekpo_tmp INTO lst_ekpo.
    READ TABLE li_inven_recon TRANSPORTING NO FIELDS
    WITH KEY matnr = lst_ekpo-matnr
             werks = lst_ekpo-werks.
    IF sy-subrc IS NOT INITIAL.
      lst_custom-matnr = lst_ekpo-matnr.
      lst_custom-werks = lst_ekpo-werks.
      APPEND lst_custom TO li_inven_recon.
    ENDIF. " IF sy-subrc IS NOT INITIAL
    CLEAR: lst_custom, lst_ekpo.
  ENDLOOP. " LOOP AT li_ekpo_tmp INTO lst_ekpo

*----->> Logic how to populate JRR summery and detail report
* Loop on custom table and populate summery and detail both internal table.
* First two fields of custom table are MATNR and WERKS.
* LI_FINAL  -->> Summery Report
* LI_FINAL1 -->> Detail Report

  DATA(li_ekbe) = i_ekbe[].
  SORT li_ekbe BY matnr werks belnr.
  DELETE ADJACENT DUPLICATES FROM li_ekbe COMPARING matnr werks belnr.

  LOOP AT li_ekbe INTO lst_ekbe.
    DATA(lv_idx) = sy-tabix.
    READ TABLE li_ekpo TRANSPORTING NO FIELDS
    WITH KEY ebeln = lst_ekbe-ebeln
             ebelp = lst_ekbe-ebelp.
    IF sy-subrc IS NOT INITIAL.
      DELETE li_ekbe INDEX lv_idx.
    ENDIF. " IF sy-subrc IS NOT INITIAL
  ENDLOOP. " LOOP AT li_ekbe INTO lst_ekbe

  DATA(li_ekbe_detl) = i_ekbe[].
  SORT li_ekbe_detl BY ebeln ebelp belnr.
  DELETE ADJACENT DUPLICATES FROM li_ekbe_detl COMPARING ebeln ebelp belnr.

  LOOP AT li_inven_recon INTO lst_custom.

    lv_confirmed = lv_confirmed + lst_custom-zrcpt.

    IF lst_custom-xblnr IS NOT INITIAL
      AND lst_custom-mblnr IS INITIAL.
      lv_fail_gr = abap_true.
      lv_failgr_qty = lv_failgr_qty + lst_custom-zrcpt.
    ENDIF. " IF lst_custom-xblnr IS NOT INITIAL

    IF lst_custom-zrcpt IS NOT INITIAL
      AND lst_custom-xblnr IS INITIAL
      AND lst_custom-mblnr IS INITIAL.
      lv_pending_gr = abap_true.
    ENDIF. " IF lst_custom-zrcpt IS NOT INITIAL


    AT END OF werks. " Works based on Material Plant Combination
      DATA(lv_confirmed_d) = lv_confirmed.
      lv_sl_no_s = lv_sl_no_s + 1. " Counter for summery serial number
      lst_final-sl_no =  lv_sl_no_s.

*     Populate MAterial master information
      READ TABLE i_mara INTO lst_mara
      WITH KEY matnr = lst_custom-matnr
      BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        lst_final-matnr =  lst_mara-matnr.
        lst_final-labor =  lst_mara-labor.
      ENDIF. " IF sy-subrc IS INITIAL

*     Populate Material Plant related information
      READ TABLE i_marc INTO lst_marc
      WITH KEY matnr = lst_custom-matnr " Material
               werks = lst_custom-werks " Plant
      BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        lst_final-dispo = lst_marc-dispo.
      ENDIF. " IF sy-subrc IS INITIAL

      lst_final-werks = lst_custom-werks. " Plant

*   ------->> Get PO quantity
      READ TABLE li_ekpo TRANSPORTING NO FIELDS
      WITH KEY matnr = lst_custom-matnr
               werks = lst_custom-werks
      BINARY SEARCH.
      IF  sy-subrc = 0.
        lv_tabix = sy-tabix.

        LOOP AT li_ekpo INTO lst_ekpo FROM lv_tabix.
          IF lst_ekpo-matnr NE lst_custom-matnr
            OR lst_ekpo-werks NE lst_custom-werks.
            EXIT.
          ELSE. " ELSE -> IF lst_ekpo-matnr NE lst_custom-matnr
*         Populate PO related information
            IF lst_ekpo-elikz IS NOT INITIAL.
              lv_delv_com = abap_true.
            ENDIF. " IF lst_ekpo-elikz IS NOT INITIAL

            lst_final-meins = lst_ekpo-meins. " PO Order Unit
            lst_final-lifnr = lst_ekpo-lifnr. " Printer (EKKO-LIFNR)
            lst_final-emlif = lst_ekpo-emlif. " Distributor (EKPO-EMLIF)
            lst_final-waers_po = lst_ekpo-waers. " PO Currency
            lst_final-i0315_uom = lst_ekpo-meins.
            lst_final-mat_uom = lst_ekpo-meins. "material unit
            lst_final-inv_uom = lst_ekpo-meins. "Invoice Unit

*         Read table to get printer Name1
            READ TABLE i_lfa1 INTO lst_lfa1 WITH KEY lifnr = lst_ekpo-lifnr.
            IF sy-subrc IS INITIAL.
              lst_final-name1 = lst_lfa1-name1. " Printer Name
            ENDIF. " IF sy-subrc IS INITIAL

*         Read table to get the Distributor Name2
            READ TABLE i_lfa1 INTO lst_lfa1 WITH KEY lifnr = lst_ekpo-emlif.
            IF  sy-subrc = 0.
              lst_final-name2 = lst_lfa1-name1. " Distributor Name
            ENDIF. " IF sy-subrc = 0

*         Po Qty
            lv_menge = lv_menge + lst_ekpo-menge. " Summing Po Quantity

            IF lst_ekpo-elikz IS INITIAL.
              lv_open_po_qty = lv_open_po_qty + lst_ekpo-menge.
            ENDIF. " IF lst_ekpo-elikz IS INITIAL

            lv_netwr = lv_netwr + lst_ekpo-netwr. " Sum PO Value
            DATA(lv_ekpo_menge) = lst_ekpo-menge.
*           To populate PO history QTY
            READ TABLE i_ekbe TRANSPORTING NO FIELDS
            WITH KEY ebeln = lst_ekpo-ebeln
                     ebelp = lst_ekpo-ebelp
            BINARY SEARCH.
            IF sy-subrc = 0.
              lv_tabix_1 = sy-tabix.
              LOOP AT i_ekbe INTO lst_ekbe FROM lv_tabix_1.
                IF lst_ekbe-ebeln NE lst_ekpo-ebeln
                  OR lst_ekbe-ebelp NE lst_ekpo-ebelp.
                  EXIT.
                ELSE . " ELSE -> IF lst_ekbe-ebeln NE lst_ekpo-ebeln
                  lv_po_sub_itm = lv_po_sub_itm + 1.
                  lst_final1-po_sub_itm = lv_po_sub_itm.
*               ------>> Calculate GR Quantity
                  IF lst_ekbe-bewtp = c_bewtp_e AND
                    lst_ekbe-shkzg = c_shkzg_s . "'S'.
*                 Population of MAT Qty
                    lv_menge_gr = lv_menge_gr + lst_ekbe-menge.

                    IF lst_ekpo-elikz IS INITIAL.
                      lv_open_gr_qty = lv_open_gr_qty + lst_ekbe-menge.
                    ENDIF. " IF lst_ekpo-elikz IS INITIAL

                  ELSEIF lst_ekbe-bewtp = c_bewtp_e AND
                    lst_ekbe-shkzg = c_shkzg_h . "'H'. " ELSE -> IF lst_ekbe-bwart ='102'
                    lv_menge_gr = lv_menge_gr - lst_ekbe-menge.
                    IF lst_ekpo-elikz IS INITIAL.
                      lv_open_gr_qty = lv_open_gr_qty - lst_ekbe-menge.
                    ENDIF. " IF lst_ekpo-elikz IS INITIAL
                  ENDIF. " IF lst_ekbe-bewtp = c_bewtp_e AND

*               ------->> Calculate Invoice Quantity/Invoice Amount
                  IF lst_ekbe-bewtp = c_bewtp_q AND
                    lst_ekbe-shkzg = c_shkzg_s.
                    lv_menge_in = lv_menge_in + lst_ekbe-menge.
                    lv_dmbtr_in = lv_dmbtr_in + lst_ekbe-dmbtr.
                  ELSEIF lst_ekbe-bewtp = c_bewtp_q AND
                    lst_ekbe-shkzg = c_shkzg_h.
                    lv_menge_in = lv_menge_in - lst_ekbe-menge.
                    lv_dmbtr_in = lv_dmbtr_in - lst_ekbe-dmbtr.
                  ENDIF. " IF lst_ekbe-bewtp = c_bewtp_q AND

                  lst_final-waers_inv = lst_ekbe-waers. " Invoice Currency

                  MOVE-CORRESPONDING lst_final TO lst_final1.
                  lst_final1-ebeln = lst_ekbe-ebeln.
                  lst_final1-ebelp = lst_ekbe-ebelp.
                  lst_final1-buzei = lst_ekbe-buzei.

                  IF lst_ekbe-bewtp = c_bewtp_e.

                    IF lst_ekbe-shkzg = c_shkzg_s.
                      IF lst_ekpo-menge > lst_ekbe-menge.
                        lst_final1-menge_gr = lst_ekbe-menge.
                        lst_final1-dmbtr = lst_ekbe-dmbtr.
                        lst_final1-menge = lst_ekbe-menge. "lst_ekpo-menge.
                        lst_final1-netwr = lst_ekbe-dmbtr. " lst_ekpo-netwr.
                        lst_final1-confirmed = lst_ekbe-menge.

                        lst_ekpo-menge = lst_ekpo-menge - lst_ekbe-menge.
                        lst_ekpo-netwr = lst_ekpo-netwr - lst_ekbe-dmbtr.
                        lv_confirmed_d = lv_confirmed_d - lst_ekbe-menge.
                        lst_final1-derived = lst_final1-confirmed - lst_final1-menge_gr.
                      ELSE. " ELSE -> IF lst_ekpo-menge > lst_ekbe-menge
                        lst_final1-menge_gr = lst_ekbe-menge.
                        lst_final1-dmbtr = lst_ekbe-dmbtr.
                        lst_final1-menge = lst_ekpo-menge. "lst_ekpo-menge.
                        lst_final1-netwr = lst_ekpo-netwr. " lst_ekpo-netwr.
                        lst_final1-confirmed = lst_ekbe-menge.

*                        lv_menge_gr_d = lv_menge_gr_d + ( lst_ekbe-menge - lst_ekpo-menge ).
                        lv_confirmed_d = lv_confirmed_d - lst_ekbe-menge.
                        CLEAR: lst_ekpo-menge,
                               lst_ekpo-netwr.
                        lst_final1-derived = lst_final1-confirmed - lst_final1-menge_gr.
                      ENDIF. " IF lst_ekpo-menge > lst_ekbe-menge

                    ELSEIF lst_ekbe-shkzg = c_shkzg_h.
                      lst_final1-menge_gr = ( lst_ekbe-menge * -1 ).

                      lst_final1-derived = lst_final1-confirmed - lst_final1-menge_gr.
                      lst_final1-message = 'Reversal Entry'(001).
                    ENDIF. " IF lst_ekbe-shkzg = c_shkzg_s

                  ELSEIF lst_ekbe-bewtp = c_bewtp_q.
                    lst_final1-menge_in = lst_ekbe-menge.
                  ENDIF. " IF lst_ekbe-bewtp = c_bewtp_e

                  lst_final1-belnr = lst_ekbe-belnr.
                  lst_final1-bwart = lst_ekbe-bwart.

                ENDIF. " IF lst_ekbe-ebeln NE lst_ekpo-ebeln

                IF lst_ekbe-bewtp NE c_bewtp_q.
                  PERFORM f_get_exception_detail USING lv_fail_gr
                                                       lv_failgr_qty
                                                       lst_final1
                                                       lv_delv_com
                                                       li_ekbe_detl.
                  APPEND lst_final1 TO i_final1.
                ENDIF. " IF lst_ekbe-bewtp NE c_bewtp_q
                CLEAR :lst_final1.
              ENDLOOP. " LOOP AT i_ekbe INTO lst_ekbe FROM lv_tabix_1
            ENDIF. " IF sy-subrc = 0

*         Populating PO open quantity ------------>>
*         Case 1. PO Item has no entry in EKBE table
*         Case 2. PO item has GR entry but there is still some open quantity
            IF lst_ekpo-menge IS NOT INITIAL.
*              OR lv_menge_gr_d IS NOT INITIAL.
              MOVE-CORRESPONDING lst_final TO lst_final1.
              lst_final1-ebeln = lst_ekpo-ebeln.
              lst_final1-ebelp = lst_ekpo-ebelp.
              lst_final1-po_sub_itm = lv_po_sub_itm + 1.
              lst_final1-menge = lst_ekpo-menge.
              lst_final1-netwr = lst_ekpo-netwr.
              PERFORM f_get_exception_detail USING lv_fail_gr
                                                   lv_failgr_qty
                                                   lst_final1
                                                   lv_delv_com
                                                   li_ekbe_detl.

              APPEND lst_final1 TO i_final1.
              CLEAR :lst_final1, lv_menge_gr_d.
            ENDIF. " IF lst_ekpo-menge IS NOT INITIAL
            CLEAR: lv_po_sub_itm.
*         <<------------------------

          ENDIF. " IF lst_ekpo-matnr NE lst_custom-matnr
          CLEAR : lv_delv_com.
        ENDLOOP. " LOOP AT li_ekpo INTO lst_ekpo FROM lv_tabix
      ENDIF. " IF sy-subrc = 0

      IF lv_confirmed_d IS NOT INITIAL.
        MOVE-CORRESPONDING lst_final TO lst_final1.
        lst_final1-confirmed = lv_confirmed_d.
        lst_final1-derived = lv_confirmed_d.
        PERFORM f_get_exception_detail USING lv_fail_gr
                                              lv_failgr_qty
                                              lst_final1
                                              lv_delv_com
                                              li_ekbe_detl.
        APPEND lst_final1 TO i_final1.
        CLEAR :lst_final1,lv_confirmed_d.
      ENDIF. " IF lv_confirmed_d IS NOT INITIAL

      lst_final-menge = lv_menge. "PO Qty
      lst_final-confirmed = lv_confirmed.
      lst_final-netwr = lv_netwr.
      lst_final-menge_gr = lv_menge_gr. "Mat Qty
      lst_final-dmbtr  = lv_dmbtr_in.
      lst_final-menge_in = lv_menge_in.
      lst_final-derived = lv_confirmed - lv_menge_gr.

      PERFORM f_update_exception    CHANGING lv_fail_gr
                                             lv_failgr_qty
                                             lv_pending_gr
                                             lv_open_po_qty
                                             lv_open_gr_qty
                                             lst_final
                                             li_ekbe.


      CLEAR: lv_menge_gr,
             lv_open_po_qty,
             lv_open_gr_qty,
             lv_dmbtr_in,
             lv_menge_in,
             lv_menge,
             lv_confirmed,
             lv_netwr,
             lv_fail_gr,
             lv_pending_gr,
             lv_delv_com,
             lv_failgr_qty.
      APPEND  lst_final TO i_final.
      CLEAR:lst_final.
    ENDAT.
  ENDLOOP. " LOOP AT li_inven_recon INTO lst_custom

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MATNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_MATNR  text
*----------------------------------------------------------------------*
FORM f_validate_matnr  USING    fp_s_matnr TYPE fip_t_matnr_range .

  SELECT matnr " Material Number
   FROM mara   " General Material Data
    UP TO 1 ROWS
    INTO @DATA(lv_matnr)
    WHERE matnr IN @fp_s_matnr.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e176(zqtc_r2). " Invalid Material Number!
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_JDR_FINAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_EKPO  text
*      -->P_I_EKBE  text
*      -->P_I_INVEN_RECON  text
*      -->P_I_FINAL  text
*      <--P_I_JDR_SUMM  text
*      <--P_I_JDR_DETL  text
*----------------------------------------------------------------------*
FORM f_populate_jdr_final  USING    fp_i_mara  TYPE tt_mara
                                    fp_i_ekpo  TYPE tt_ekpo
                                    fp_i_ekbe  TYPE tt_ekbe
                                    fp_i_inven_recon TYPE tt_inven_recon
                                    fp_i_final  TYPE tt_final.

* Local Constants
  CONSTANTS : lc_printer    TYPE zevent VALUE 'PRINTER',      " Event
              lc_dropship   TYPE zevent VALUE 'DROPSHIP',     " Event
              lc_whstk      TYPE zevent VALUE 'WHSTK',        " Event
              lc_offline    TYPE zevent VALUE 'OFFLINE',      " Event
              lc_conf       TYPE zevent VALUE 'CONF',         " Event
              lc_pstyp      TYPE rvari_vnam  VALUE 'PSTYP',   " Item Category in Purchasing Document
              lc_jdr        TYPE zadjtyp     VALUE 'JDR',     " Adjustment Type
*              lc_adj_whstk  TYPE zadjtyp     VALUE 'WHSTK',   " Adjustment Type
              lc_adj_soh    TYPE zadjtyp     VALUE 'SOH',
              lc_knttp      TYPE rvari_vnam  VALUE 'KNTTP',   " Account Assignment Category
              lc_bednr      TYPE rvari_vnam  VALUE 'BEDNR',   " ABAP: Name of Variant Variable
              lc_bd_offline TYPE rvari_vnam  VALUE 'OFFLINE', " Requirement Tracking Number
              lc_bd_whstk   TYPE rvari_vnam  VALUE 'WHSTK',   " Requirement Tracking Number
              lc_bd_conf    TYPE rvari_vnam  VALUE 'CONF'.    " Requirement Tracking Number


* Local Work Area Declaration
  DATA : lst_mara      TYPE ty_mara,
         lst_marc      TYPE ty_marc,
         lst_jdr_summ  TYPE ty_jdr_summ,
         lst_jdr_drop  TYPE ty_jdr_summ,
         lst_jdr_whstk TYPE ty_jdr_summ,
         lst_jdr_off   TYPE ty_jdr_summ,
         lst_jdr_conf  TYPE ty_jdr_summ,
         lst_constant  TYPE ty_constant.

* Local Variable Declaration
  DATA :  lv_count         TYPE i ,      " Count of type Integers
          lv_cout_detl     TYPE i,       " Count_detl of type Integers
          lv_alpha         TYPE i,       " Alpha of type Integers
          lv_message       TYPE char50,  " Message of type CHAR50
          lv_qty           TYPE char17,  " Qty of type CHAR17
          lv_pstyp         TYPE pstyp,   " Item Category in Purchasing Document
          lv_knttp         TYPE knttp,   " Account Assignment Category
          lv_mat_qty_print TYPE menge_d, " Quantity
          lv_bd_offline    TYPE bednr  , " Requirement Tracking Number
          lv_bd_whstk      TYPE bednr ,  " Requirement Tracking Number
          lv_bd_conf       TYPE bednr.   " Requirement Tracking Number

* Local Internal Table
  DATA : li_ekpo_drp    TYPE STANDARD TABLE OF ty_ekpo INITIAL SIZE 0,
         li_inven_recon TYPE tt_inven_recon,
         li_ekbe        TYPE STANDARD TABLE OF ty_ekbe INITIAL SIZE 0,
         li_ekbe_mat    TYPE STANDARD TABLE OF ty_ekbe INITIAL SIZE 0,
         li_ekbe_tmp    TYPE STANDARD TABLE OF ty_ekbe INITIAL SIZE 0,
         li_ekpo_off    TYPE STANDARD TABLE OF ty_ekpo INITIAL SIZE 0,
         li_ekpo_whstk  TYPE STANDARD TABLE OF ty_ekpo INITIAL SIZE 0,
         li_ekpo_conf   TYPE STANDARD TABLE OF ty_ekpo INITIAL SIZE 0.


  li_inven_recon[] = fp_i_inven_recon[].
  SORT li_inven_recon BY zadjtyp matnr werks ebeln mblnr.
* Only consider PO those GR has done .
  li_ekbe[] = fp_i_ekbe[].
  DELETE li_ekbe WHERE bewtp <> c_bewtp_e.
  SORT li_ekbe BY ebeln ebelp bwart.

  li_ekbe_mat[] = fp_i_ekbe[].
  SORT li_ekbe_mat BY matnr werks belnr.
  DELETE ADJACENT DUPLICATES FROM li_ekbe_mat COMPARING matnr werks belnr.

* For finding multiple GR
  li_ekbe_tmp[] = li_ekbe[].
  SORT li_ekbe_tmp BY ebeln ebelp belnr.
  DELETE ADJACENT DUPLICATES FROM li_ekbe_tmp COMPARING ebeln ebelp belnr.

* Filter Data by distributor
  DATA(li_ekpo_tmp) = fp_i_ekpo[].
  IF s_distr IS NOT INITIAL.
    DELETE  li_ekpo_tmp WHERE lifnr NOT IN s_distr.
  ENDIF. " IF s_distr IS NOT INITIAL

* Dropship only having document type ZNB
  li_ekpo_drp[]  = li_ekpo_tmp.
  DELETE li_ekpo_drp WHERE  bsart <> c_znb.

  SORT li_ekpo_drp BY matnr werks pstyp knttp.

  li_ekpo_off[] = li_ekpo_drp[].
  li_ekpo_whstk[] = li_ekpo_drp[].

* Conference PO document type NB
  li_ekpo_conf[] = li_ekpo_tmp.
  DELETE li_ekpo_conf WHERE bsart <> c_nb.

  CLEAR lst_constant.
  READ TABLE i_constant INTO lst_constant WITH KEY param1 =  lc_pstyp .
  IF sy-subrc EQ 0.
    lv_pstyp = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

  CLEAR lst_constant.
  READ TABLE i_constant INTO lst_constant WITH KEY param1 =  lc_knttp .
  IF sy-subrc EQ 0.
    lv_knttp = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

  CLEAR lst_constant.
  READ TABLE i_constant INTO lst_constant WITH KEY param1 =  lc_bednr
                                                   param2 =  lc_bd_offline.
  IF sy-subrc EQ 0.
    lv_bd_offline = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

  CLEAR lst_constant.
  READ TABLE i_constant INTO lst_constant WITH KEY param1 =  lc_bednr
                                                   param2 =  lc_bd_whstk.
  IF sy-subrc EQ 0.
    lv_bd_whstk = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0
  CLEAR lst_constant.

  READ TABLE i_constant INTO lst_constant WITH KEY param1 =  lc_bednr
                                                   param2 =  lc_bd_conf.
  IF sy-subrc EQ 0.
    lv_bd_conf = lst_constant-low.
  ENDIF. " IF sy-subrc EQ 0

  DELETE li_ekpo_drp WHERE ( bednr = lc_bd_offline
                           OR bednr = lc_bd_whstk )
                           AND pstyp <> lv_pstyp
                           AND knttp <> lv_knttp.

  DELETE li_ekpo_off    WHERE bednr <> lv_bd_offline.
  DELETE li_ekpo_whstk  WHERE bednr <> lv_bd_whstk.
  DELETE li_ekpo_conf   WHERE bednr <> lv_bd_conf.

  SORT li_ekpo_off   BY matnr werks.
  SORT li_ekpo_whstk BY matnr werks.
  SORT li_ekpo_conf  BY matnr werks banfn bnfpo.

  LOOP AT i_marc INTO lst_marc.
    READ TABLE fp_i_ekpo INTO DATA(lst_ekpo) WITH KEY matnr = lst_marc-matnr
                                                      werks = lst_marc-werks
                                                      BINARY SEARCH.
    IF  sy-subrc = 0.
* Popolate first Row from JRR(Printer report)
***********************************************************************************
      READ TABLE fp_i_final INTO DATA(lst_final) WITH KEY matnr = lst_marc-matnr
                                                          werks = lst_marc-werks
                                                         BINARY SEARCH.
      IF sy-subrc EQ 0.
        lv_count = lv_count + 1.
        MOVE-CORRESPONDING lst_final TO lst_jdr_summ.
        lst_jdr_summ-sl_no = lv_count .
        lst_jdr_summ-po_qty = lst_final-menge.
        lst_jdr_summ-po_uom = lst_final-meins.
        lst_jdr_summ-mat_qty = lst_final-menge_gr.
        lv_mat_qty_print = lst_final-menge_gr.
        lst_jdr_summ-jfds_qty = lst_final-confirmed.
        lst_jdr_summ-jfds_uom = lst_final-i0315_uom.
        lst_jdr_summ-variance = lst_final-derived.
        lst_jdr_summ-zevent = lc_printer.
        APPEND lst_jdr_summ TO i_jdr_summ.
        CLEAR lst_jdr_summ.
      ENDIF. " IF sy-subrc EQ 0

* Populate Secound Row
**********************************************************************************

* Populate Material
      lst_jdr_summ-matnr =  lst_marc-matnr.

      READ TABLE fp_i_mara INTO lst_mara WITH KEY matnr = lst_marc-matnr " Material
                                                      BINARY SEARCH.
      IF sy-subrc IS INITIAL.
* Populate Media Office
        lst_jdr_summ-labor =  lst_mara-labor.
      ENDIF. " IF sy-subrc IS INITIAL

* Populate Media Issue Planner
      lst_jdr_summ-dispo = lst_marc-dispo.

*  Populate Plant
      lst_jdr_summ-werks = lst_marc-werks.


* Populate Dropship for Distributor
****************************************************************************************
** PO Quantity for dropship

      PERFORM f_populate_jdr_summ USING lst_marc
                                        lv_alpha
                                        li_ekpo_drp
                                        lc_jdr
                                        lc_dropship
                                        li_ekbe
                                        li_ekbe_tmp
                                        li_ekbe_mat
                                        lst_jdr_summ
                                        li_inven_recon
                              CHANGING
                                        lv_cout_detl
                                        lst_jdr_drop.



* Populate WHSTK quantities .
******************************************************************************************
      lv_alpha = lv_alpha + 1.
      PERFORM f_populate_jdr_summ USING  lst_marc
                                         lv_alpha
                                         li_ekpo_whstk
*                                         lc_adj_whstk
                                         lc_adj_soh
                                         lc_whstk
                                         li_ekbe
                                         li_ekbe_tmp
                                         li_ekbe_mat
                                         lst_jdr_summ
                                         li_inven_recon
                               CHANGING
                                         lv_cout_detl
                                         lst_jdr_whstk.

* Populate Offline quantity
**************************************************************************************
      lv_alpha = lv_alpha + 1.
      PERFORM f_populate_jdr_summ USING  lst_marc
                                         lv_alpha
                                         li_ekpo_off
                                         lc_jdr
                                         lc_offline
                                         li_ekbe
                                         li_ekbe_tmp
                                         li_ekbe_mat
                                         lst_jdr_summ
                                         li_inven_recon
                               CHANGING
                                         lv_cout_detl
                                         lst_jdr_off.

* Populate Conference Quantity
************************************************************************************
      lv_alpha = lv_alpha + 1.
      PERFORM f_populate_jdr_summ USING  lst_marc
                                         lv_alpha
                                         li_ekpo_conf
                                         lc_jdr
                                         lc_conf
                                         li_ekbe
                                         li_ekbe_tmp
                                         li_ekbe_mat
                                         lst_jdr_summ
                                         li_inven_recon
                               CHANGING
                                         lv_cout_detl
                                         lst_jdr_conf.
* Populate summary record

* Populate Printer
      lst_jdr_summ-lifnr = lst_final-lifnr.

** Populate Printer Name
      lst_jdr_summ-name1 = lst_final-name1.

* Populate distributor
      lst_jdr_summ-emlif = lst_final-emlif.
      lst_jdr_summ-name2 = lst_final-name2.

      IF lst_jdr_summ-emlif IS INITIAL.
        lst_jdr_summ-emlif = lst_jdr_summ-lifnr.
        lst_jdr_summ-name2 = lst_jdr_summ-name1.
        CLEAR: lst_jdr_summ-lifnr,
               lst_jdr_summ-name1.
      ENDIF. " IF lst_jdr_summ-emlif IS INITIAL

      lv_count = lv_count + 1.
      lst_jdr_summ-sl_no    = lv_count.
      lst_jdr_summ-po_uom   = lst_final-meins.
      lst_jdr_summ-po_qty   = lst_jdr_drop-po_qty + lst_jdr_whstk-po_qty + lst_jdr_off-po_qty + lst_jdr_conf-po_qty.
      lst_jdr_summ-mat_qty  = lst_jdr_drop-mat_qty + lst_jdr_whstk-mat_qty + lst_jdr_off-mat_qty + lst_jdr_conf-mat_qty.
      lst_jdr_summ-mat_uom  = lst_final-meins.
      lst_jdr_summ-jfds_qty = lst_jdr_drop-jfds_qty + lst_jdr_whstk-jfds_qty + lst_jdr_off-jfds_qty + lst_jdr_conf-jfds_qty.
      lst_jdr_summ-jfds_uom = lst_final-meins.
      IF lst_final IS NOT INITIAL .
        lst_jdr_summ-variance = lv_mat_qty_print - lst_jdr_summ-mat_qty.
      ELSE. " ELSE -> IF lst_final IS NOT INITIAL
        lst_jdr_summ-variance = lst_jdr_summ-po_qty - lst_jdr_summ-mat_qty.
      ENDIF. " IF lst_final IS NOT INITIAL

      IF lst_jdr_summ-variance GT 0.
        CLEAR: lv_message,
                 lv_qty.
        lv_qty = lst_jdr_summ-variance.
        CONCATENATE lv_qty
                   'Open Quantity'(002)
                   INTO lv_message SEPARATED BY space.
      ENDIF. " IF lst_jdr_summ-variance GT 0

      IF lst_jdr_summ IS NOT INITIAL .
        APPEND lst_jdr_summ  TO i_jdr_summ.
      ENDIF. " IF lst_jdr_summ IS NOT INITIAL

      IF lst_jdr_drop IS NOT INITIAL.
        APPEND lst_jdr_drop  TO i_jdr_summ.
      ENDIF. " IF lst_jdr_drop IS NOT INITIAL

      IF lst_jdr_whstk IS NOT INITIAL.
        APPEND lst_jdr_whstk TO i_jdr_summ.
      ENDIF. " IF lst_jdr_whstk IS NOT INITIAL

      IF lst_jdr_off IS NOT INITIAL.
        APPEND lst_jdr_off   TO i_jdr_summ.
      ENDIF. " IF lst_jdr_off IS NOT INITIAL

      IF lst_jdr_conf IS NOT INITIAL.
        APPEND lst_jdr_conf  TO i_jdr_summ.
      ENDIF. " IF lst_jdr_conf IS NOT INITIAL

      CLEAR: lst_jdr_summ,
             lst_jdr_drop,
             lst_jdr_whstk,
             lst_jdr_off,
             lst_jdr_conf,
             lv_alpha,
             lst_final,
             lv_mat_qty_print.

*
    ENDIF. " IF sy-subrc = 0
  ENDLOOP. " LOOP AT i_marc INTO lst_marc
  CLEAR : lv_count,
          lv_cout_detl.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ALV_OUTPUT_JDR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_JDR_SUMM  text
*      -->P_I_JDR_DETL  text
*----------------------------------------------------------------------*
FORM f_alv_output_jdr  USING    fp_i_jdr_summ TYPE tt_jdr_summ.


  DATA: lst_layout TYPE slis_layout_alv,
        li_sort    TYPE slis_t_sortinfo_alv.

  CONSTANTS : lc_pf_status   TYPE slis_formname  VALUE 'F_SET_PF_STATUS',
              lc_user_comm   TYPE slis_formname  VALUE 'F_USER_COMMAND',
              lc_top_of_page TYPE slis_formname  VALUE 'F_TOP_OF_PAGE_SUMM'.


  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Displaying Results'(003).

  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.

  PERFORM f_popul_field_cat_jdr_summ.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = lc_pf_status
      i_callback_user_command  = lc_user_comm
      i_callback_top_of_page   = lc_top_of_page
      is_layout                = lst_layout
      it_fieldcat              = i_fcat
      it_sort                  = li_sort
      i_save                   = abap_true
      i_default                = space
    TABLES
      t_outtab                 = fp_i_jdr_summ
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CAT_JDR_SUMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_popul_field_cat_jdr_summ .

*   Populate the field catalog
  DATA : lv_col_pos TYPE sycucol. " Col_pos of type Integers

*Constant for hold for alv tablename
  CONSTANTS: lc_tabname      TYPE slis_tabname VALUE 'I_JDR_SUMM', "Tablename for Alv Display
* Constent for hold the alv field catelog
             lc_fld_sl_no    TYPE slis_fieldname VALUE 'SL_NO ',
             lc_fld_matnr    TYPE slis_fieldname VALUE 'MATNR',
             lc_fld_labor    TYPE slis_fieldname VALUE 'LABOR',
             lc_fld_dispo    TYPE slis_fieldname VALUE 'DISPO',
             lc_fld_werks    TYPE slis_fieldname VALUE 'WERKS',
             lc_fld_lifnr    TYPE slis_fieldname VALUE 'LIFNR',
             lc_fld_name1    TYPE slis_fieldname VALUE 'NAME1',
             lc_fld_emlif    TYPE slis_fieldname VALUE 'EMLIF',
             lc_fld_name2    TYPE slis_fieldname VALUE 'NAME2',
             lc_fld_po_qty   TYPE slis_fieldname VALUE 'PO_QTY',
             lc_fld_po_uom   TYPE slis_fieldname VALUE 'PO_UOM',
             lc_fld_mat_qty  TYPE slis_fieldname VALUE 'MAT_QTY',
             lc_fld_mat_uom  TYPE slis_fieldname VALUE 'MAT_UOM',
             lc_fld_jfds_qty TYPE slis_fieldname VALUE 'JFDS_QTY',
             lc_fld_jfds_uom TYPE slis_fieldname VALUE 'JFDS_UOM',
             lc_fld_zevent   TYPE slis_fieldname VALUE 'ZEVENT',
             lc_fld_variance TYPE slis_fieldname VALUE 'VARIANCE',
             lc_fld_message  TYPE slis_fieldname VALUE 'MESSAGE'.


  lv_col_pos         = 0 .
* Populate field catalog

* Serial Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_sl_no  lc_tabname   lv_col_pos  'SL'(004)
                     CHANGING i_fcat.

* Media Issue
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_matnr  lc_tabname   lv_col_pos  'Media Issue'(005)
                       CHANGING i_fcat.

* Media Office
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_labor  lc_tabname   lv_col_pos  'Media Office'(006)
                       CHANGING i_fcat.

* Media Issue Planner
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_dispo  lc_tabname   lv_col_pos  'Media Issue Planner'(007)
                     CHANGING i_fcat.

* Plant
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_werks  lc_tabname   lv_col_pos  'Plant'(008)
                     CHANGING i_fcat.

* Printer
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_lifnr  lc_tabname   lv_col_pos  'Printer'(009)
                   CHANGING i_fcat.

* Description
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_name1  lc_tabname   lv_col_pos  'Description'(010)
                 CHANGING i_fcat.

* Distributor
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_emlif  lc_tabname   lv_col_pos  'Distributor'(011)
                  CHANGING i_fcat.

* Description
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_name2  lc_tabname   lv_col_pos  'Description'(010)
                  CHANGING i_fcat.

* PO Qty
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total USING lc_fld_po_qty  lc_tabname   lv_col_pos  'PO Qty'(012)
                     CHANGING i_fcat.

* PO Order UOM
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_po_uom  lc_tabname   lv_col_pos  'PO Order UOM'(013)
                     CHANGING i_fcat.

* Mat quantity
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total USING lc_fld_mat_qty  lc_tabname   lv_col_pos  'Mat quantity'(014)
                   CHANGING i_fcat.

* Material UOM
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_mat_uom  lc_tabname   lv_col_pos  'Material UOM'(015)
                 CHANGING i_fcat.

* JFDS Confirmed
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total USING lc_fld_jfds_qty  lc_tabname   lv_col_pos  'JFDS Confirmed'(016)
                  CHANGING i_fcat.

* JFDS UOM
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_jfds_uom  lc_tabname   lv_col_pos  'JFDS UOM'(018)
                  CHANGING i_fcat.

* Event
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zevent  lc_tabname   lv_col_pos  'Event'(017)
                 CHANGING i_fcat.

* Production vs Dis Variance
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_variance  lc_tabname   lv_col_pos  'Production vs Dis Variance'(019)
                  CHANGING i_fcat.

* Exception
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_message  lc_tabname   lv_col_pos  'Exception'(020)
                  CHANGING i_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*       Build Field Catalog
*----------------------------------------------------------------------*

FORM f_build_fcat  USING      fp_field         TYPE slis_fieldname
                              fp_tabname       TYPE slis_tabname
                              fp_col_pos       TYPE sycucol " Col_pos of type Integers
                              fp_text          TYPE char70  " Text of type CHAR50
                     CHANGING fp_i_fcat       TYPE slis_t_fieldcat_alv.

  DATA: lst_fcat   TYPE slis_fieldcat_alv.

  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '60'. " Output Length

  lst_fcat-lowercase   = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-seltext_m   = fp_text.

  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.

ENDFORM. " SUB_BUILD_FCAT

*&---------------------------------------------------------------------*
*&      Form  F_BUILD_FCAT
*&---------------------------------------------------------------------*
*       Build Field Catalog
*----------------------------------------------------------------------*

FORM f_build_fcat_total  USING      fp_field         TYPE slis_fieldname
                              fp_tabname       TYPE slis_tabname
                              fp_col_pos       TYPE sycucol " Col_pos of type Integers
                              fp_text          TYPE char70  " Text of type CHAR50
                     CHANGING fp_i_fcat       TYPE slis_t_fieldcat_alv.

  DATA: lst_fcat   TYPE slis_fieldcat_alv.

  CONSTANTS : lc_outputlen TYPE outputlen  VALUE '60'. " Output Length

  lst_fcat-lowercase   = abap_true.
  lst_fcat-do_sum   = abap_true.
  lst_fcat-outputlen   = lc_outputlen.
  lst_fcat-fieldname   = fp_field.
  lst_fcat-tabname     = fp_tabname.
  lst_fcat-col_pos     = fp_col_pos.
  lst_fcat-seltext_m   = fp_text.

  APPEND lst_fcat TO fp_i_fcat.
  CLEAR lst_fcat.

ENDFORM. " SUB_BUILD_FCAT

*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_top_of_page_summ.
*ALV Header declarations
  DATA: li_header  TYPE slis_t_listheader,
        lst_header TYPE slis_listheader.

* Constant
  CONSTANTS :     lc_typ_h TYPE char1 VALUE 'H'. " Typ_h of type CHAR1

* TITLE
  lst_header-typ = lc_typ_h . "'H'
  lst_header-info = 'JDR Summary report'(021).
  APPEND lst_header TO li_header.
  CLEAR lst_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_header.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_top_of_page_jrr_summ.
*ALV Header declarations
  DATA: li_header  TYPE slis_t_listheader,
        lst_header TYPE slis_listheader.

* Constant
  CONSTANTS :     lc_typ_h TYPE char1 VALUE 'H'. " Typ_h of type CHAR1

* TITLE
  lst_header-typ = lc_typ_h . "'H'
  lst_header-info = 'JRR Summary report'(022).
  APPEND lst_header TO li_header.
  CLEAR lst_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_header.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_top_of_page_jrr_detl.
*ALV Header declarations
  DATA: li_header  TYPE slis_t_listheader,
        lst_header TYPE slis_listheader.

* Constant
  CONSTANTS :     lc_typ_h TYPE char1 VALUE 'H'. " Typ_h of type CHAR1

* TITLE
  lst_header-typ = lc_typ_h . "'H'
  lst_header-info = 'JRR Detail report'(023).
  APPEND lst_header TO li_header.
  CLEAR lst_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_header.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  f_set_pf_status
*&---------------------------------------------------------------------*
*       Set the PF Status for ALV
*----------------------------------------------------------------------*
FORM f_set_pf_status USING li_extab TYPE slis_t_extab.      "#EC CALLED

  DESCRIBE TABLE li_extab. "Avoid Extended Check Warning
  SET PF-STATUS 'ZINVEN_RECON'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form F_USER_COMMAND
*&---------------------------------------------------------------------*
*      USING fp_ucomm          " ABAP System Field: PAI-Triggering Function Code
*            fp_lst_selfield   .
*----------------------------------------------------------------------*
FORM f_user_command USING fp_ucomm        TYPE syst_ucomm " ABAP System Field: PAI-Triggering Function Code
                          fp_lst_selfield TYPE slis_selfield.

  CONSTANTS : lc_detail           TYPE syst_ucomm     VALUE '&DETAIL', " ABAP System Field: PAI-Triggering Function
              lc_back             TYPE syst_ucomm     VALUE '&F03',    " ABAP System Field: PAI-Triggering Function
              lc_pf_status        TYPE slis_formname  VALUE 'F_SET_PF_STATUS',
              lc_top_of_page_detl TYPE slis_formname  VALUE 'F_TOP_OF_PAGE_DETL',
              lc_fld_zevent       TYPE slis_fieldname VALUE 'ZEVENT'.

  DATA : lst_layout TYPE slis_layout_alv,
         lst_sort   TYPE slis_sortinfo_alv,
         li_sort    TYPE slis_t_sortinfo_alv.

  CASE fp_ucomm.

    WHEN lc_detail.
* User double clicks any Material number detail report called from ALV.
      READ TABLE i_jdr_summ INTO DATA(lst_jdr_summ) INDEX fp_lst_selfield-tabindex .
      lst_sort-spos      = 1.
      lst_sort-fieldname = lc_fld_zevent.
      lst_sort-subtot    = abap_true.
      APPEND lst_sort TO li_sort.

      lst_layout-colwidth_optimize  = abap_true.
      lst_layout-zebra              = abap_true.
      lst_layout-totals_before_items = abap_true.

      CLEAR i_fcat[].
      PERFORM f_popul_field_cat_jdr_detl.

      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
        EXPORTING
          i_callback_program       = sy-repid
          i_callback_pf_status_set = lc_pf_status
          i_callback_top_of_page   = lc_top_of_page_detl
          is_layout                = lst_layout
          it_fieldcat              = i_fcat
          it_sort                  = li_sort
          i_save                   = abap_true
          i_default                = space
        TABLES
          t_outtab                 = i_jdr_detl
        EXCEPTIONS
          program_error            = 1
          OTHERS                   = 2.
      IF sy-subrc <> 0.
        MESSAGE i066(zqtc_r2). " ALV display of table failed
        LEAVE LIST-PROCESSING.
      ENDIF. " IF sy-subrc <> 0
    WHEN lc_back.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form F_USER_COMMAND
*&---------------------------------------------------------------------*
*      USING fp_ucomm          " ABAP System Field: PAI-Triggering Function Code
*            fp_lst_selfield   .
*----------------------------------------------------------------------*
FORM f_user_command_jrr USING fp_ucomm        TYPE syst_ucomm " ABAP System Field: PAI-Triggering Function Code
                             fp_lst_selfield TYPE slis_selfield.

  CONSTANTS : lc_detail           TYPE syst_ucomm     VALUE '&DETAIL', " ABAP System Field: PAI-Triggering Function
              lc_back             TYPE syst_ucomm     VALUE '&F03',    " ABAP System Field: PAI-Triggering Function
              lc_pf_status        TYPE slis_formname  VALUE 'F_SET_PF_STATUS',
              lc_top_of_page_detl TYPE slis_formname  VALUE 'F_TOP_OF_PAGE_JRR_DETL'.

  DATA : lst_layout    TYPE slis_layout_alv.

  CASE fp_ucomm.

    WHEN lc_detail.

      lst_layout-colwidth_optimize  = abap_true.
      lst_layout-zebra              = abap_true.

      CLEAR i_fcat[].
      PERFORM f_popul_field_cat_jrr_detl.

      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
        EXPORTING
          i_callback_program       = sy-repid
          i_callback_pf_status_set = lc_pf_status
          i_callback_top_of_page   = lc_top_of_page_detl
          is_layout                = lst_layout
          it_fieldcat              = i_fcat
          i_save                   = abap_true
          i_default                = space
        TABLES
          t_outtab                 = i_final1
        EXCEPTIONS
          program_error            = 1
          OTHERS                   = 2.
      IF sy-subrc <> 0.
        MESSAGE i066(zqtc_r2). " ALV display of table failed
        LEAVE LIST-PROCESSING.
      ENDIF. " IF sy-subrc <> 0
    WHEN lc_back.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CAT_JDR_SUMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_popul_field_cat_jdr_detl .

*   Populate the field catalog
  DATA : lv_col_pos TYPE sycucol. " Col_pos of type Integers

*Constant for hold for alv tablename
  CONSTANTS: lc_tabname      TYPE slis_tabname VALUE 'I_JDR_DETL', "Tablename for Alv Display
* Constent for hold the alv field catelog
             lc_fld_sl_no    TYPE slis_fieldname VALUE 'SL_NO ',
             lc_fld_matnr    TYPE slis_fieldname VALUE 'MATNR',
             lc_fld_labor    TYPE slis_fieldname VALUE 'LABOR',
             lc_fld_dispo    TYPE slis_fieldname VALUE 'DISPO',
             lc_fld_werks    TYPE slis_fieldname VALUE 'WERKS',
             lc_fld_lifnr    TYPE slis_fieldname VALUE 'LIFNR',
             lc_fld_name1    TYPE slis_fieldname VALUE 'NAME1',
             lc_fld_emlif    TYPE slis_fieldname VALUE 'EMLIF',
             lc_fld_name2    TYPE slis_fieldname VALUE 'NAME2',
             lc_fld_ebeln    TYPE slis_fieldname VALUE 'EBELN',
             lc_fld_ebelp    TYPE slis_fieldname VALUE 'EBELP',
             lc_fld_sub_item TYPE slis_fieldname VALUE 'SUB_ITEM',
             lc_fld_po_qty   TYPE slis_fieldname VALUE 'PO_QTY',
             lc_fld_po_uom   TYPE slis_fieldname VALUE 'PO_UOM',
             lc_fld_bwart    TYPE slis_fieldname VALUE 'BWART',
             lc_fld_belnr    TYPE slis_fieldname VALUE 'BELNR',
             lc_fld_buzei    TYPE slis_fieldname VALUE 'BUZEI',
             lc_fld_mat_qty  TYPE slis_fieldname VALUE 'MAT_QTY',
             lc_fld_mat_uom  TYPE slis_fieldname VALUE 'MAT_UOM',
             lc_fld_jfds_qty TYPE slis_fieldname VALUE 'JFDS_QTY',
             lc_fld_jfds_uom TYPE slis_fieldname VALUE 'JFDS_UOM',
             lc_fld_zevent   TYPE slis_fieldname VALUE 'ZEVENT',
             lc_fld_variance TYPE slis_fieldname VALUE 'VARIANCE',
             lc_fld_message  TYPE slis_fieldname VALUE 'MESSAGE'.


  lv_col_pos         = 0 .
* Populate field catalog

* Serial Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_sl_no  lc_tabname   lv_col_pos  'SL'(004)
                     CHANGING i_fcat.

* Media Issue
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_matnr  lc_tabname   lv_col_pos  'Media Issue'(005)
                       CHANGING i_fcat.

* Media Office
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_labor  lc_tabname   lv_col_pos  'Media Office'(006)
                       CHANGING i_fcat.

* Media Issue Planner
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_dispo  lc_tabname   lv_col_pos  'Media Issue Planner'(007)
                     CHANGING i_fcat.

* Plant
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_werks  lc_tabname   lv_col_pos  'Plant'(008)
                     CHANGING i_fcat.

* Printer
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_lifnr  lc_tabname   lv_col_pos  'Printer'(009)
                   CHANGING i_fcat.

* Description
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_name1  lc_tabname   lv_col_pos  'Description'(010)
                 CHANGING i_fcat.

* Distributor
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_emlif  lc_tabname   lv_col_pos  'Distributor'(011)
                  CHANGING i_fcat.

* Description
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_name2  lc_tabname   lv_col_pos  'Description'(010)
                  CHANGING i_fcat.

* PO Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_ebeln  lc_tabname   lv_col_pos  'PO Number'(024)
                 CHANGING i_fcat.

* PO Item Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_ebelp  lc_tabname   lv_col_pos  'PO Item Number'(025)
                  CHANGING i_fcat.

* PO Sub Item Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_sub_item  lc_tabname   lv_col_pos  'PO Sub Item Number'(026)
                  CHANGING i_fcat.

* PO Qty
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total USING lc_fld_po_qty  lc_tabname   lv_col_pos  'PO Qty'(012)
                     CHANGING i_fcat.

* PO Order UOM
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_po_uom  lc_tabname   lv_col_pos  'PO Order UOM'(013)
                     CHANGING i_fcat.

* Movement Type
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_bwart  lc_tabname   lv_col_pos  'Movement Type'(027)
                     CHANGING i_fcat.

* Material Document number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_belnr  lc_tabname   lv_col_pos  'Material Document number'(028)
                     CHANGING i_fcat.

* Material document line number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_buzei  lc_tabname   lv_col_pos  'Material document line number'(029)
                     CHANGING i_fcat.

* Mat quantity
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total USING lc_fld_mat_qty  lc_tabname   lv_col_pos  'Mat quantity'(014)
                   CHANGING i_fcat.

* Material UOM
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_mat_uom  lc_tabname   lv_col_pos  'Material UOM'(015)
                 CHANGING i_fcat.

* JFDS Confirmed
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total USING lc_fld_jfds_qty  lc_tabname   lv_col_pos  'JFDS Confirmed'(016)
                  CHANGING i_fcat.

* JFDS UOM
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_jfds_uom  lc_tabname   lv_col_pos  'JFDS UOM'(018)
                  CHANGING i_fcat.

* Event
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zevent  lc_tabname   lv_col_pos  'Event'(017)
                 CHANGING i_fcat.

* Production vs Dis Variance
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total USING lc_fld_variance  lc_tabname   lv_col_pos  'Production vs Dis Variance'(019)
                  CHANGING i_fcat.

* Exception
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_message  lc_tabname   lv_col_pos  'Exception'(020)
                  CHANGING i_fcat.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form f_top_of_page
*&---------------------------------------------------------------------*
*       Set the top of page of ALV
*----------------------------------------------------------------------*
FORM f_top_of_page_detl.
*ALV Header declarations
  DATA: li_header  TYPE slis_t_listheader,
        lst_header TYPE slis_listheader.

* Constant
  CONSTANTS : lc_typ_h TYPE char1 VALUE 'H'. " Typ_h of type CHAR1

* TITLE
  lst_header-typ = lc_typ_h . "'H'
  lst_header-info = 'JDR Detail Report'(030).
  APPEND lst_header TO li_header.
  CLEAR lst_header.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = li_header.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CAT_JRR_SUMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_popul_field_cat_jrr_summ .
*   populate the field catalog
  DATA : lv_col_pos TYPE sycucol. " Col_pos of type Integers

*Constant for hold for alv tablename
  CONSTANTS: lc_tabname       TYPE slis_tabname VALUE 'I_JDR_SUMM', "Tablename for Alv Display
* Constent for hold the alv field catelog
             lc_fld_sl_no     TYPE slis_fieldname VALUE 'SL_NO ',
             lc_fld_matnr     TYPE slis_fieldname VALUE 'MATNR',
             lc_fld_labor     TYPE slis_fieldname VALUE 'LABOR',
             lc_fld_dispo     TYPE slis_fieldname VALUE 'DISPO',
             lc_fld_werks     TYPE slis_fieldname VALUE 'WERKS',
             lc_fld_lifnr     TYPE slis_fieldname VALUE 'LIFNR',
             lc_fld_name1     TYPE slis_fieldname VALUE 'NAME1',
             lc_fld_emlif     TYPE slis_fieldname VALUE 'EMLIF',
             lc_fld_name2     TYPE slis_fieldname VALUE 'NAME2',
             lc_fld_menge     TYPE slis_fieldname VALUE 'MENGE',
             lc_fld_meins     TYPE slis_fieldname VALUE 'MEINS',
             lc_fld_netwr     TYPE slis_fieldname VALUE 'NETWR',
             lc_fld_waers_po  TYPE slis_fieldname VALUE 'WAERS_PO',
             lc_fld_menge_gr  TYPE slis_fieldname VALUE 'MENGE_GR',
             lc_fld_mat_uom   TYPE slis_fieldname VALUE 'MAT_UOM',
             lc_fld_menge_in  TYPE slis_fieldname VALUE 'MENGE_IN',
             lc_fld_inv_uom   TYPE slis_fieldname VALUE 'INV_UOM',
             lc_fld_dmbtr     TYPE slis_fieldname VALUE 'DMBTR',
             lc_fld_waers_inv TYPE slis_fieldname VALUE 'WAERS_INV',
             lc_fld_confirmed TYPE slis_fieldname VALUE 'CONFIRMED',
             lc_fld_i0315_uom TYPE slis_fieldname VALUE 'I0315_UOM',
             lc_fld_derived   TYPE slis_fieldname VALUE 'DERIVED',
             lc_fld_message   TYPE slis_fieldname VALUE 'MESSAGE'.


  lv_col_pos         = 0 .
* Populate field catalog

* Serial Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_sl_no  lc_tabname   lv_col_pos  'SL'(004)
                     CHANGING i_fcat.

* Media Issue
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_matnr  lc_tabname   lv_col_pos  'Media Issue'(005)
                       CHANGING i_fcat.

* Media Office
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_labor  lc_tabname   lv_col_pos  'Media Office'(006)
                       CHANGING i_fcat.

* Media Issue Planner
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_dispo  lc_tabname   lv_col_pos  'Media Issue Planner'(007)
                     CHANGING i_fcat.

* Plant
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_werks  lc_tabname   lv_col_pos  'Plant'(008)
                     CHANGING i_fcat.

* Printer
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_lifnr  lc_tabname   lv_col_pos  'Printer'(009)
                   CHANGING i_fcat.

* Description
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_name1  lc_tabname   lv_col_pos  'Description'(010)
                 CHANGING i_fcat.

* Distributor
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_emlif  lc_tabname   lv_col_pos  'Distributor'(011)
                  CHANGING i_fcat.

* Description
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_name2  lc_tabname   lv_col_pos  'Description'(010)
                  CHANGING i_fcat.

* PO Qty
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_menge  lc_tabname   lv_col_pos  'PO Qty'(012)
                     CHANGING i_fcat.

* PO Order UOM
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_meins  lc_tabname   lv_col_pos  'PO Order UOM'(013)
                     CHANGING i_fcat.
* PO value
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_netwr  lc_tabname   lv_col_pos  'PO Value'(031)
                     CHANGING i_fcat.
* PO  Currency
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_waers_po  lc_tabname   lv_col_pos  'PO Currency'(032)
                     CHANGING i_fcat.
* Mat Quantity
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_menge_gr  lc_tabname   lv_col_pos  'Mat Quantity'(033)
                     CHANGING i_fcat.
* Mat UOM
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_mat_uom  lc_tabname   lv_col_pos  'Material UOM'(015)
                     CHANGING i_fcat.
* Inv Quantity
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_menge_in  lc_tabname   lv_col_pos  'Inv Quantity'(034)
                     CHANGING i_fcat.
* Inv_UOM
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_inv_uom  lc_tabname   lv_col_pos  'Inv UOM'(035)
                     CHANGING i_fcat.
* Invoice amount
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_dmbtr  lc_tabname   lv_col_pos  'Invoice Amount'(036)
                     CHANGING i_fcat.
* invoice Curr
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_waers_inv  lc_tabname   lv_col_pos  'Invoice Curr'(037)
                     CHANGING i_fcat.
* Confirmed
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_confirmed  lc_tabname   lv_col_pos  'Confirmed'(038)
                     CHANGING i_fcat.


* I0315_uom
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_i0315_uom  lc_tabname   lv_col_pos  'I0315_uom'(039)
                 CHANGING i_fcat.

* Derived
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_derived  lc_tabname   lv_col_pos  'SAP Receipt Vs JFDS Report'(040)
                  CHANGING i_fcat.

* Exception
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_message  lc_tabname   lv_col_pos  'Exception'(020)
                  CHANGING i_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CAT_JRR_DETL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_popul_field_cat_jrr_detl .

*   populate the field catalog
  DATA : lv_col_pos TYPE sycucol. " Col_pos of type Integers

*Constant for hold for alv tablename
  CONSTANTS: lc_tabname        TYPE slis_tabname VALUE 'I_FINAL1', "Tablename for Alv Display
* Constent for hold the alv field catelog
             lc_fld_sl_no      TYPE slis_fieldname VALUE 'SL_NO ',
             lc_fld_matnr      TYPE slis_fieldname VALUE 'MATNR',
             lc_fld_labor      TYPE slis_fieldname VALUE 'LABOR',
             lc_fld_dispo      TYPE slis_fieldname VALUE 'DISPO',
             lc_fld_werks      TYPE slis_fieldname VALUE 'WERKS',
             lc_fld_lifnr      TYPE slis_fieldname VALUE 'LIFNR',
             lc_fld_name1      TYPE slis_fieldname VALUE 'NAME1',
             lc_fld_emlif      TYPE slis_fieldname VALUE 'EMLIF',
             lc_fld_name2      TYPE slis_fieldname VALUE 'NAME2',
             lc_fld_ebeln      TYPE slis_fieldname VALUE 'EBELN',
             lc_fld_ebelp      TYPE slis_fieldname VALUE 'EBELP',
             lc_fld_po_sub_itm TYPE slis_fieldname VALUE 'PO_SUB_ITM',
             lc_fld_menge      TYPE slis_fieldname VALUE 'MENGE',
             lc_fld_meins      TYPE slis_fieldname VALUE 'MEINS',
             lc_fld_netwr      TYPE slis_fieldname VALUE 'NETWR',
             lc_fld_waers_po   TYPE slis_fieldname VALUE 'WAERS_PO',
             lc_fld_bwart      TYPE slis_fieldname VALUE 'BWART',
             lc_fld_belnr      TYPE slis_fieldname VALUE 'BELNR',
             lc_fld_buzei      TYPE slis_fieldname VALUE 'BUZEI',
             lc_fld_menge_gr   TYPE slis_fieldname VALUE 'MENGE_GR',
             lc_fld_mat_uom    TYPE slis_fieldname VALUE 'MAT_UOM',
             lc_fld_confirmed  TYPE slis_fieldname VALUE 'CONFIRMED',
             lc_fld_i0315_uom  TYPE slis_fieldname VALUE 'I0315_UOM',
             lc_fld_derived    TYPE slis_fieldname VALUE 'DERIVED',
             lc_fld_message    TYPE slis_fieldname VALUE 'MESSAGE'.


  lv_col_pos         = 0 .
* Populate field catalog

* Serial Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_sl_no  lc_tabname   lv_col_pos  'SL'(004)
                     CHANGING i_fcat.

* Media Issue
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_matnr  lc_tabname   lv_col_pos  'Media Issue'(005)
                       CHANGING i_fcat.

* Media Office
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_labor  lc_tabname   lv_col_pos  'Media Office'(006)
                       CHANGING i_fcat.

* Media Issue Planner
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_dispo  lc_tabname   lv_col_pos  'Media Issue Planner'(007)
                     CHANGING i_fcat.

* Plant
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_werks  lc_tabname   lv_col_pos  'Plant'(008)
                     CHANGING i_fcat.

* Printer
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_lifnr  lc_tabname   lv_col_pos  'Printer'(009)
                   CHANGING i_fcat.

* Description
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_name1  lc_tabname   lv_col_pos  'Description'(010)
                 CHANGING i_fcat.

* Distributor
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_emlif  lc_tabname   lv_col_pos  'Distributor'(011)
                  CHANGING i_fcat.

* Description
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_name2  lc_tabname   lv_col_pos  'Description'(010)
                  CHANGING i_fcat.

* PO Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_ebeln  lc_tabname   lv_col_pos  'PO Number'(024)
                 CHANGING i_fcat.

* PO Item Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_ebelp  lc_tabname   lv_col_pos  'PO Item Number'(025)
                  CHANGING i_fcat.

* PO Sub Item Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_po_sub_itm  lc_tabname   lv_col_pos  ' PO Sub Item Number'(041)
                  CHANGING i_fcat.

* PO Qty
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_menge  lc_tabname   lv_col_pos  'PO Qty'(012)
                     CHANGING i_fcat.

* PO Order UOM
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_meins  lc_tabname   lv_col_pos  'PO Order UOM'(013)
                     CHANGING i_fcat.
* PO value
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_netwr  lc_tabname   lv_col_pos  'PO Value'(031)
                     CHANGING i_fcat.
* PO  Currency
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_waers_po  lc_tabname   lv_col_pos  'PO Currency'(032)
                     CHANGING i_fcat.
* Movement Type
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_bwart  lc_tabname   lv_col_pos  'Movement Type'(027)
                     CHANGING i_fcat.

* Material Document number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_belnr  lc_tabname   lv_col_pos  'Material Document number'(028)
                     CHANGING i_fcat.

* Material document line number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_buzei  lc_tabname   lv_col_pos  'Material document line number'(029)
                     CHANGING i_fcat.
* Mat Quantity
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_menge_gr  lc_tabname   lv_col_pos  'Mat Quantity'(033)
                     CHANGING i_fcat.
* Mat UOM
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_mat_uom  lc_tabname   lv_col_pos  'Material UOM'(015)
                     CHANGING i_fcat.
* Confirmed
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_confirmed  lc_tabname   lv_col_pos  'Confirmed'(038)
                     CHANGING i_fcat.


* I0315_uom
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_i0315_uom  lc_tabname   lv_col_pos  'I0315_uom'(039)
                 CHANGING i_fcat.

* Derived
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_derived  lc_tabname   lv_col_pos  'SAP Receipt Vs JFDS Report'(040)
                  CHANGING i_fcat.

* Exception
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_message  lc_tabname   lv_col_pos  'Exception'(020)
                  CHANGING i_fcat.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PUBL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_PUBL[]  text
*----------------------------------------------------------------------*
FORM f_validate_publ  USING    p_publ TYPE gjahr. " Fiscal Year

  DATA : lv_valid TYPE flag . " General Flag
  CALL FUNCTION 'VALIDATE_YEAR'
    EXPORTING
      i_year     = p_publ
    IMPORTING
      e_valid    = lv_valid
    EXCEPTIONS
      incomplete = 1
      OTHERS     = 2.
  IF sy-subrc <> 0.
* Do nothing
  ENDIF. " IF sy-subrc <> 0

  IF lv_valid IS INITIAL.
    MESSAGE e180(zqtc_r2). " Invalid Publication Year.
  ENDIF. " IF lv_valid IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_PLANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_PLANT[]  text
*----------------------------------------------------------------------*
FORM f_validate_plant  USING    fp_s_plant TYPE fip_t_werks_range. " Plant

  SELECT SINGLE werks " Plant
        FROM t001w    " Plants/Branches
    INTO @DATA(lv_werks)
    WHERE werks IN @fp_s_plant.
  IF sy-subrc NE 0.
    MESSAGE e186(zqtc_r2). " Invalid plant, please re-enter.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MATTYP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_MATTYP[]  text
*----------------------------------------------------------------------*
FORM f_validate_mattyp  USING    fp_s_mattyp TYPE cfb_t_mtart_range. " Structure for Range Table for Data Element MTART

  SELECT mtart " Material Type
    FROM t134 UP TO 1 ROWS
    INTO @DATA(lv_mtart)
    WHERE mtart IN @fp_s_mattyp.
  ENDSELECT.
  IF  sy-subrc NE 0.
    MESSAGE e103(zqtc_r2). " Invalid Material Type!
  ENDIF. " IF sy-subrc NE 0
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MATOFC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_MATOFC  text
*----------------------------------------------------------------------*
FORM f_validate_matofc  USING    fp_s_matofc TYPE tt_labor.

  SELECT labor " Laboratory/design office
    FROM t024l " Laboratory/office for material
    UP TO 1 ROWS
    INTO @DATA(lv_labor)
    WHERE  labor IN @fp_s_matofc.
  ENDSELECT.
  IF  sy-subrc NE 0.
    MESSAGE e178(zqtc_r2). " Invalid media issue office.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE_MEDCON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_validate_medcon USING fp_s_medcon TYPE tt_dispo.

  SELECT dispo " MRP Controller (Materials Planner)
    FROM t024d " MRP controllers
    UP TO 1 ROWS
    INTO @DATA(lv_dispo)
    WHERE dispo IN @fp_s_medcon.
  ENDSELECT.
  IF  sy-subrc NE 0.
    MESSAGE e179(zqtc_r2). " Invalid MRP controller.
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VALIDATE-VEND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_VEND  text
*----------------------------------------------------------------------*
FORM f_validate_vend  USING    fp_s_vend TYPE fip_t_lifnr_range.

  SELECT lifnr " Account Number of Vendor or Creditor
    FROM lfa1  " Vendor Master (General Section)
    UP TO 1 ROWS
    INTO @DATA(lv_lifnr)
    WHERE lifnr IN @fp_s_vend.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE e095(zqtc_r2). " Invalid Vendor ID!
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_CLEAR_GLOBAL_VARIABLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_clear_global_variables .

  CLEAR : i_mara[],
      i_ekpo[],
      i_ekbe[],
      i_inven_recon[],
      i_marc[],
      i_lfa1[],
      i_lifnr[],
      i_final[],
      i_final1[],
      i_jdr_summ[],
      i_jdr_detl[],
      i_fcat[],
      i_fcat_detl[].

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MODIFY_SELECTN_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_modify_selectn_screen .

  LOOP AT SCREEN.
    IF rb_distr = abap_true.
      IF screen-group1 = c_scrgroup1.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = c_scrgroup1

    ELSEIF rb_repro = abap_true.
      IF screen-group1 = c_scrgroup2
        OR screen-group1 = c_scrgroup1.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF. " IF screen-group1 = c_scrgroup2
    ENDIF. " IF rb_distr = abap_true
  ENDLOOP. " LOOP AT SCREEN

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_eord .

  DATA : li_ekpo TYPE STANDARD TABLE OF ty_ekpo INITIAL SIZE 0.
  li_ekpo[] = i_ekpo[].
  SORT li_ekpo BY matnr werks.
  DELETE ADJACENT DUPLICATES FROM li_ekpo COMPARING matnr werks.

  IF li_ekpo IS NOT INITIAL.
    SELECT matnr " Material Number
           werks " Plant
           lifnr " Vendor Account Number
           flifn " Indicator: Fixed vendor
           autet " Source List Usage in Materials Planning
      FROM eord  " Purchasing Source List
      INTO TABLE i_eord
      FOR ALL ENTRIES IN i_ekpo
      WHERE matnr = i_ekpo-matnr
      AND  werks  = i_ekpo-werks
      AND vdatu LE sy-datum
      AND bdatu GE sy-datum.
    IF sy-subrc EQ 0.
      SORT i_eord BY matnr werks lifnr.
      i_eord_print[] = i_eord[].
      DELETE i_eord       WHERE flifn IS INITIAL.
      DELETE i_eord_print WHERE autet NE '1'.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF li_ekpo IS NOT INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_ZCACONSTANT
*&---------------------------------------------------------------------*
*      Get the constant from ZCACONSTANT table
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM f_get_zcaconstant .

  DATA : lc_devid       TYPE zdevid      VALUE 'R040'. " Development ID

* Get the constant values from ZCACONSTANT value.
  SELECT devid                   "Development ID
         param1                  "ABAP: Name of Variant Variable
         param2                  "ABAP: Name of Variant Variable
         srno                    "Current selection number
         sign                    "ABAP: ID: I/E (include/exclude values)
         opti                    "ABAP: Selection option (EQ/BT/CP/...)
         low                     "Lower Value of Selection Condition
         high                    "Upper Value of Selection Condition
     FROM zcaconstant            "Wiley Application Constant Table
     INTO TABLE i_constant
     WHERE devid    = lc_devid
     AND   activate = abap_true. "Only active record
  IF sy-subrc IS INITIAL.
* DO nothing
  ENDIF. " IF sy-subrc IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUALTE_DETAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_EKBE  text
*      -->P_LI_EKBE_TMP  text
*      -->P_I_CONSTANT  text
*      <--P_I_JDR_DETL  text
*----------------------------------------------------------------------*
FORM f_popualte_detail  USING    fp_lst_ekpo     TYPE ty_ekpo
                                 fp_li_ekbe      TYPE tt_ekbe
                                 fp_li_ekbe_tmp  TYPE tt_ekbe
                                 fp_lc_adj_type  TYPE zadjtyp
                                 fp_li_inven_recon    TYPE tt_inven_recon
                    CHANGING     fp_lst_jdr_summ      TYPE ty_jdr_summ
                                 fp_lv_mat_qty        TYPE menge_d " Quantity
                                 fp_lv_open_mat_qty   TYPE menge_d " Quantity
                                 fp_lv_cout_detl      TYPE i       " Lv_cout_detl of type Integers
                                 fp_i_jdr_detl        TYPE tt_jdr_detl.

  CONSTANTS : lc_conf     TYPE zevent VALUE 'CONF',     " Event
              lc_dropship TYPE zevent VALUE 'DROPSHIP', " Event
              lc_whstk    TYPE zevent VALUE 'WHSTK',    " Event
              lc_offline  TYPE zevent VALUE 'OFFLINE',  " Event
              lc_shkzg_s  TYPE shkzg VALUE 'S',         " Debit/Credit Indicator
              lc_shkzg_h  TYPE shkzg VALUE 'H'.         " Debit/Credit Indicator

  DATA : lv_ekbe_index    TYPE syst_tabix, " ABAP System Field: Row Index of Internal Tables
         lv_open_detl_mat TYPE menge_d,    " Quantity
         lv_sub_itm       TYPE i,          " Sub_itm of type Integers
         lv_message       TYPE char50,     " Message of type CHAR50
         lv_qty           TYPE char17.     " Qty of type CHAR17

  DATA : lst_jdr_detl TYPE ty_jdr_detl.

* Populate Printer
  fp_lst_jdr_summ-lifnr = fp_lst_ekpo-lifnr.

* Populate Printer Name
  READ TABLE i_lfa1 INTO DATA(lst_lfa1) WITH KEY lifnr =  fp_lst_jdr_summ-lifnr
                                        BINARY SEARCH.
  IF sy-subrc EQ 0.
    fp_lst_jdr_summ-name1 = lst_lfa1-name1.
  ENDIF. " IF sy-subrc EQ 0

* Populate distributor
  fp_lst_jdr_summ-emlif =  fp_lst_ekpo-emlif.

  IF fp_lst_jdr_summ-emlif IS INITIAL.
    fp_lst_jdr_summ-emlif = fp_lst_jdr_summ-lifnr.
    fp_lst_jdr_summ-name2 = fp_lst_jdr_summ-name1.
    CLEAR: fp_lst_jdr_summ-lifnr,
           fp_lst_jdr_summ-name1.
  ELSE. " ELSE -> IF fp_lst_jdr_summ-emlif IS INITIAL
* Populate Distributor Name
    CLEAR lst_lfa1.
    READ TABLE i_lfa1 INTO lst_lfa1 WITH KEY lifnr = fp_lst_jdr_summ-emlif
                                             BINARY SEARCH.
    IF sy-subrc  EQ 0.
      fp_lst_jdr_summ-name2 = lst_lfa1-name1.
    ENDIF. " IF sy-subrc EQ 0
  ENDIF. " IF fp_lst_jdr_summ-emlif IS INITIAL

  READ TABLE fp_li_ekbe TRANSPORTING NO FIELDS WITH KEY   ebeln = fp_lst_ekpo-ebeln
                                                          ebelp = fp_lst_ekpo-ebelp
                                                         BINARY SEARCH.
  IF sy-subrc EQ 0.
    lv_ekbe_index = sy-tabix.

    LOOP AT fp_li_ekbe INTO DATA(lst_ekbe) FROM lv_ekbe_index.
      IF lst_ekbe-ebeln <> fp_lst_ekpo-ebeln
        OR lst_ekbe-ebelp <> fp_lst_ekpo-ebelp.
        EXIT.
      ENDIF. " IF lst_ekbe-ebeln <> fp_lst_ekpo-ebeln
      MOVE-CORRESPONDING fp_lst_jdr_summ TO lst_jdr_detl.

*      ------>> Calculate GR Quantity
      IF  lst_ekbe-shkzg = lc_shkzg_s.
*                 Population of MAT Qty
        fp_lv_mat_qty = fp_lv_mat_qty + lst_ekbe-menge.
        IF fp_lst_ekpo-elikz IS INITIAL .
          fp_lv_open_mat_qty = fp_lv_open_mat_qty + lst_ekbe-menge.
          lv_open_detl_mat = lv_open_detl_mat + lst_ekbe-menge.
        ENDIF. " IF fp_lst_ekpo-elikz IS INITIAL
      ELSEIF  lst_ekbe-shkzg = lc_shkzg_h. " ELSE -> IF lst_ekbe-bwart ='102'

        fp_lv_mat_qty = fp_lv_mat_qty - lst_ekbe-menge.
        IF fp_lst_ekpo-elikz IS INITIAL.
          fp_lv_open_mat_qty = fp_lv_open_mat_qty - lst_ekbe-menge.
          lv_open_detl_mat = lv_open_detl_mat - lst_ekbe-menge.
        ENDIF. " IF fp_lst_ekpo-elikz IS INITIAL
        lst_ekbe-menge = ( -1 ) * lst_ekbe-menge.
        lst_jdr_detl-message = 'Reversal Entry'(001).
      ENDIF. " IF lst_ekbe-shkzg = lc_shkzg_s

      fp_lv_cout_detl        = fp_lv_cout_detl + 1.
      lst_jdr_detl-sl_no  = fp_lv_cout_detl.
      lst_jdr_detl-ebeln  = lst_ekbe-ebeln.
      lst_jdr_detl-ebelp  = lst_ekbe-ebelp.
      lst_jdr_detl-po_qty  = lst_ekbe-menge.
      lst_jdr_detl-bwart   = lst_ekbe-bwart.
      lv_sub_itm = lv_sub_itm + 1.
      lst_jdr_detl-sub_item = lv_sub_itm.
      lst_jdr_detl-belnr   = lst_ekbe-belnr.
      lst_jdr_detl-buzei    = lst_ekbe-buzei.
      lst_jdr_detl-mat_qty  = lst_ekbe-menge.

      IF lst_jdr_detl-zevent = lc_conf
      OR  lst_jdr_detl-zevent = lc_dropship.
        lst_jdr_detl-jfds_qty  = lst_ekbe-menge.
      ELSEIF lst_jdr_detl-zevent = lc_offline
      OR  lst_jdr_detl-zevent = lc_whstk.
        READ TABLE fp_li_inven_recon INTO DATA(lst_inven_recon) WITH KEY zadjtyp = fp_lc_adj_type
                                                                         matnr   = lst_jdr_detl-matnr
                                                                         werks = lst_jdr_detl-werks
                                                                         ebeln = lst_jdr_detl-ebeln
                                                                         mblnr = lst_jdr_detl-belnr
                                                                         BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF lst_jdr_detl-zevent = lc_offline.
            lst_jdr_detl-jfds_qty  = lst_inven_recon-zoffline.
          ENDIF. " IF lst_jdr_detl-zevent = lc_offline
          IF lst_jdr_detl-zevent = lc_whstk.
            lst_jdr_detl-jfds_qty  = lst_inven_recon-zsohqty.
          ENDIF. " IF lst_jdr_detl-zevent = lc_whstk

        ENDIF. " IF sy-subrc EQ 0
      ENDIF. " IF lst_jdr_detl-zevent = lc_conf

      lst_jdr_detl-variance  = lst_jdr_detl-jfds_qty - lst_jdr_detl-mat_qty.

* Update exception for JDR Detail report
      PERFORM f_get_exception_jdr_detail USING
                                                 fp_li_ekbe_tmp
                                        CHANGING lst_jdr_detl.


      APPEND lst_jdr_detl TO fp_i_jdr_detl.
      CLEAR lst_jdr_detl.

    ENDLOOP. " LOOP AT fp_li_ekbe INTO DATA(lst_ekbe) FROM lv_ekbe_index
  ELSE. " ELSE -> IF sy-subrc EQ 0
    MOVE-CORRESPONDING fp_lst_jdr_summ TO lst_jdr_detl.
    fp_lv_cout_detl = fp_lv_cout_detl + 1.
    lst_jdr_detl-sl_no = fp_lv_cout_detl.
    lst_jdr_detl-ebeln = fp_lst_ekpo-ebeln.
    lst_jdr_detl-ebelp = fp_lst_ekpo-ebelp.
    lv_sub_itm = lv_sub_itm + 1.
    lst_jdr_detl-sub_item = lv_sub_itm.
    lst_jdr_detl-po_qty = fp_lst_ekpo-menge.
    CLEAR: lv_message,
             lv_qty.
    lv_qty = fp_lst_ekpo-menge.
    IF fp_lst_ekpo-elikz IS INITIAL.
      CONCATENATE  lv_qty
                  'Open Quantity'(002)
                   INTO lv_message SEPARATED BY space.
      lst_jdr_detl-message    = lv_message.
    ENDIF. " IF fp_lst_ekpo-elikz IS INITIAL
    APPEND lst_jdr_detl TO fp_i_jdr_detl.
    CLEAR lst_jdr_detl.
  ENDIF. " IF sy-subrc EQ 0
  CLEAR: lv_ekbe_index.

*         Populating PO open quantity ------------>>
*         Case 1. PO Item has no entry in EKBE table
*         Case 2. PO item has GR entry but there is still some open quantity
  IF lv_open_detl_mat IS NOT INITIAL.
    IF  lv_open_detl_mat LT fp_lst_ekpo-menge. "AND lv_failgr IS INITIAL.

      MOVE-CORRESPONDING fp_lst_jdr_summ TO lst_jdr_detl.
      fp_lv_cout_detl = fp_lv_cout_detl + 1.
      lst_jdr_detl-sl_no = fp_lv_cout_detl.
      lst_jdr_detl-ebeln = fp_lst_ekpo-ebeln.
      lst_jdr_detl-ebelp = fp_lst_ekpo-ebelp.
      lv_sub_itm = lv_sub_itm + 1.
      lst_jdr_detl-sub_item = lv_sub_itm.
      lst_jdr_detl-po_qty = fp_lst_ekpo-menge - lv_open_detl_mat.

      CLEAR: lv_message,
             lv_qty.
      lv_qty = lst_jdr_detl-po_qty.
      IF fp_lst_ekpo-elikz IS INITIAL.
        CONCATENATE  lv_qty
                    'Open Quantity'(002)
                     INTO lv_message SEPARATED BY space.
        lst_jdr_detl-message    = lv_message.
      ENDIF. " IF fp_lst_ekpo-elikz IS INITIAL
      APPEND lst_jdr_detl TO fp_i_jdr_detl.
      CLEAR :lst_jdr_detl.
    ENDIF. " IF lv_open_detl_mat LT fp_lst_ekpo-menge
  ENDIF. " IF lv_open_detl_mat IS NOT INITIAL

  CLEAR : lv_open_detl_mat.


ENDFORM.



*&---------------------------------------------------------------------*
*&      Form  F_UPDATE_EXCEPTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_update_exception  CHANGING fp_lv_fail_gr TYPE flag      " General Flag
                                  fp_lv_failgr_qty TYPE zrcpt  " Receipt Qty
                                  fp_lv_pending_gr TYPE flag   " General Flag
                                  fp_lv_open_po_qty TYPE bstmg " Purchase Order Quantity
                                  fp_lv_open_gr_qty TYPE bstmg " Purchase Order Quantity
                                  fp_lst_final TYPE ty_final
                                  fp_li_ekbe   TYPE tt_ekbe.

  DATA : lv_message TYPE char50, " Message of type CHAR50
         lv_qty     TYPE char17, " Qty of type CHAR17
         lv_line    TYPE i.      " Line of type Integers

  IF fp_lst_final-message IS INITIAL.
    IF fp_lv_fail_gr IS NOT INITIAL.
      CLEAR lv_qty.
      lv_qty = fp_lv_failgr_qty.
      CONCATENATE lv_qty
                   'Failed GR'(043)
                   INTO fp_lst_final-message
                   SEPARATED BY space.
    ENDIF. " IF fp_lv_fail_gr IS NOT INITIAL
  ENDIF. " IF fp_lst_final-message IS INITIAL
*
  IF fp_lst_final-message IS INITIAL.
    IF fp_lv_pending_gr IS NOT INITIAL.
      fp_lst_final-message = 'Pending GR'(044).
    ENDIF. " IF fp_lv_pending_gr IS NOT INITIAL
  ENDIF. " IF fp_lst_final-message IS INITIAL

*2nd
  IF fp_lst_final-message IS INITIAL.

    IF fp_lv_open_po_qty NE fp_lv_open_gr_qty.
      DATA(lv_menge_diff) = fp_lv_open_po_qty - fp_lv_open_gr_qty.
      WRITE lv_menge_diff TO  lv_qty.
      IF lv_menge_diff GT 0.
        CONCATENATE lv_qty
                    'Open Quantity'(002)
                    INTO lv_message
                    SEPARATED BY space.
        fp_lst_final-message = lv_message.
      ENDIF. " IF lv_menge_diff GT 0
    ENDIF. " IF fp_lv_open_po_qty NE fp_lv_open_gr_qty

  ENDIF. " IF fp_lst_final-message IS INITIAL
*3rd
  IF fp_lst_final-message IS INITIAL .
    IF fp_lst_final-menge NE fp_lst_final-menge_gr.
      DATA(lv_menge_dif) = fp_lst_final-menge - fp_lst_final-menge_gr.
      WRITE lv_menge_dif TO  lv_qty.
      IF lv_menge_dif LT 0.
* Begin of Change by NPALLA on 18-Mar-2018 for RITM0096792 - ED1K909828.
*        lv_qty = lv_qty * ( -1 ).
        lv_menge_dif = lv_menge_dif * ( -1 ).
        WRITE lv_menge_dif TO  lv_qty.
* End of Change by NPALLA on 18-Mar-2018 for RITM0096792 - ED1K909828.
        CONCATENATE lv_qty
                   'Excess Receipt'(042)
                    INTO lv_message
                    SEPARATED BY space.
        fp_lst_final-message = lv_message.
      ENDIF. " IF lv_menge_dif LT 0
    ENDIF. " IF fp_lst_final-menge NE fp_lst_final-menge_gr
  ENDIF. " IF fp_lst_final-message IS INITIAL

  IF fp_lst_final-message IS INITIAL.
    DATA(li_ekbe_tmp) = fp_li_ekbe[].
    DELETE li_ekbe_tmp WHERE matnr <> fp_lst_final-matnr
                         OR werks <> fp_lst_final-werks.
    DESCRIBE TABLE li_ekbe_tmp LINES lv_line.
    IF lv_line > 1.
      fp_lst_final-message = 'Multiple GR'(045).
    ENDIF. " IF lv_line > 1
  ENDIF. " IF fp_lst_final-message IS INITIAL

* 4th
  IF fp_lst_final-message IS INITIAL.
* Check printer validation
    READ TABLE i_eord_print TRANSPORTING NO FIELDS
    WITH KEY matnr = fp_lst_final-matnr
             werks = fp_lst_final-werks
             lifnr = fp_lst_final-lifnr
    BINARY SEARCH.
    IF sy-subrc NE 0.
      fp_lst_final-message = 'Printer no longer Valid'(046).
    ENDIF. " IF sy-subrc NE 0
  ENDIF. " IF fp_lst_final-message IS INITIAL

* 5th
  IF fp_lst_final-message IS INITIAL.
* Check distributor validation
    READ TABLE i_eord TRANSPORTING NO FIELDS
    WITH KEY matnr = fp_lst_final-matnr
             werks = fp_lst_final-werks
             lifnr = fp_lst_final-emlif
    BINARY SEARCH.
    IF sy-subrc NE 0.
      fp_lst_final-message = 'Distributor no longer Valid'(047).
    ENDIF. " IF sy-subrc NE 0
  ENDIF. " IF fp_lst_final-message IS INITIAL

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ALV_OUTPUT_REPRO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_alv_output_repro .

  DATA: lst_layout   TYPE slis_layout_alv.

  CONSTANTS : lc_pf_status TYPE slis_formname  VALUE 'F_SET_PF_STATUS'.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Displaying Results'(003).

  lst_layout-colwidth_optimize  = abap_true.
  lst_layout-zebra              = abap_true.

  PERFORM f_popul_field_cat_repro.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = lc_pf_status
      is_layout                = lst_layout
      it_fieldcat              = i_fcat_repro
      i_save                   = abap_true
      i_default                = space
    TABLES
      t_outtab                 = i_repro
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE i066(zqtc_r2). " ALV display of table failed
    LEAVE LIST-PROCESSING.
  ENDIF. " IF sy-subrc <> 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPUL_FIELD_CAT_REPRO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_popul_field_cat_repro .

*   populate the field catalog
  DATA : lv_col_pos TYPE sycucol. " Col_pos of type Integers

*Constant for hold for alv tablename
  CONSTANTS: lc_tabname          TYPE slis_tabname VALUE 'I_REPRO', "Tablename for Alv Display

* Constent for hold the alv field catelog
             lc_fld_sl_no        TYPE slis_fieldname VALUE 'SL_NO ',
             lc_fld_matnr        TYPE slis_fieldname VALUE 'MATNR',
             lc_fld_werks        TYPE slis_fieldname VALUE 'WERKS',
             lc_fld_zadjtyp      TYPE slis_fieldname VALUE 'ZADJTYP',
             lc_fld_zevent       TYPE slis_fieldname VALUE 'ZEVENT',
             lc_fld_zdate        TYPE slis_fieldname VALUE 'ZDATE',
             lc_fld_zseqno       TYPE slis_fieldname VALUE 'ZSEQNO',
             lc_fld_zsupplm      TYPE slis_fieldname VALUE 'ZSUPPLM',
             lc_fld_zmaildt      TYPE slis_fieldname VALUE 'ZMAILDT',
             lc_fld_zsohqty      TYPE slis_fieldname VALUE 'ZSOHQTY',
             lc_fld_zadjqty      TYPE slis_fieldname VALUE 'ZADJQTY',
             lc_fld_zprntrn      TYPE slis_fieldname VALUE 'ZPRNTRN ',
             lc_fld_zrcpt        TYPE slis_fieldname VALUE 'ZRCPT',
             lc_fld_zmainlbl     TYPE slis_fieldname VALUE 'ZMAINLBL',
             lc_fld_zoffline     TYPE slis_fieldname VALUE 'ZOFFLINE',
             lc_fld_zconqty      TYPE slis_fieldname VALUE 'ZCONQTY',
             lc_fld_zebo         TYPE slis_fieldname VALUE 'ZEBO ',
             lc_fld_zsource      TYPE slis_fieldname VALUE 'ZSOURCE',
             lc_fld_zsysdate     TYPE slis_fieldname VALUE 'ZSYSDATE',
             lc_fld_ismrefmdprod TYPE slis_fieldname VALUE 'ISMREFMDPROD',
             lc_fld_ismyearnr    TYPE slis_fieldname VALUE 'ISMYEARNR',
             lc_fld_zfgrdat      TYPE slis_fieldname VALUE 'ZFGRDAT',
             lc_fld_zlgrdat      TYPE slis_fieldname VALUE 'ZLGRDAT',
             lc_fld_ebeln        TYPE slis_fieldname VALUE 'EBELN',
             lc_fld_mblnr        TYPE slis_fieldname VALUE 'MBLNR',
             lc_fld_xblnr        TYPE slis_fieldname VALUE 'XBLNR',
             lc_fld_message      TYPE slis_fieldname VALUE 'MESSAGE',
* BOI on 16-oct-2017 by PBANDLAPAL for CR#590: ED2K909595
             lc_fld_zgi_docnum   TYPE slis_fieldname VALUE 'ZGI_DOCNUM',
             lc_fld_zgi_mblnr    TYPE slis_fieldname VALUE 'ZGI_MBLNR',
             lc_fld_message_gi   TYPE slis_fieldname VALUE 'MESSAGE_GI'.
* EOI on 16-oct-2017 by PBANDLAPAL for CR#590: ED2K909595
  lv_col_pos         = 0 .
* Populate field catalog

* Serial Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_sl_no  lc_tabname   lv_col_pos  'SL'(004)
                     CHANGING i_fcat_repro.

* Media Issue
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_matnr  lc_tabname   lv_col_pos  'Media Issue'(005)
                       CHANGING i_fcat_repro.

* Plant
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_werks  lc_tabname   lv_col_pos  'Plant'(008)
                     CHANGING i_fcat_repro.

* Adjustment Type
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zadjtyp  lc_tabname   lv_col_pos  'Adjustment Type'(048)
                   CHANGING i_fcat_repro.

* Event
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zevent     lc_tabname   lv_col_pos  'Event'(017)
                 CHANGING i_fcat_repro.

* Transactional Date
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zdate  lc_tabname   lv_col_pos  'Transactional Date'(049)
                   CHANGING i_fcat_repro.

* Sequence Num
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zseqno     lc_tabname   lv_col_pos  'Sequence Num'(050)
                 CHANGING i_fcat_repro.

* Supplement
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zsupplm  lc_tabname   lv_col_pos  'Supplement'(051)
                  CHANGING i_fcat_repro.

* Mail Date
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_zmaildt  lc_tabname   lv_col_pos  'Mail Date'(052)
                  CHANGING i_fcat_repro.

* Stock On Hand
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total USING lc_fld_zsohqty  lc_tabname   lv_col_pos  'Stock On Hand Qy'(053)
                     CHANGING i_fcat_repro.

* Adjustment Qty
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total USING lc_fld_zadjqty     lc_tabname   lv_col_pos  'Adjustment Qty'(054)
                     CHANGING i_fcat_repro.

* Ordered Print Run
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total USING lc_fld_zprntrn  lc_tabname   lv_col_pos  'Ordered Print Run'(055)
                   CHANGING i_fcat_repro.

* Receipt Qty
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total USING lc_fld_zrcpt  lc_tabname   lv_col_pos  'Receipt Qty'(056)
                 CHANGING i_fcat_repro.

* Main Label Qty
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total USING lc_fld_zmainlbl  lc_tabname   lv_col_pos  'Main Label Qty'(057)
                  CHANGING i_fcat_repro.

* Offline Member Qty
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total    USING  lc_fld_zoffline   lc_tabname   lv_col_pos  'Offline Member Qty'(058)
                  CHANGING i_fcat_repro.

* Contributor Qty
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total USING lc_fld_zconqty  lc_tabname   lv_col_pos  'Contributor Qty'(059)
                     CHANGING i_fcat_repro.

* EBO Qty
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat_total USING lc_fld_zebo    lc_tabname   lv_col_pos  'EBO Qty'(060)
                     CHANGING i_fcat_repro.

* Source file Name
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zsource  lc_tabname   lv_col_pos  'Source file Name'(061)
                     CHANGING i_fcat_repro.

* System Date
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zsysdate  lc_tabname   lv_col_pos  'System Date'(062)
                     CHANGING i_fcat_repro.


* Media Product
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_ismrefmdprod  lc_tabname   lv_col_pos  'Media Product'(063)
                     CHANGING i_fcat_repro.

* Publication Year
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_ismyearnr  lc_tabname   lv_col_pos  'Publication Year'(064)
                     CHANGING i_fcat_repro.

* First GR date
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zfgrdat	 lc_tabname   lv_col_pos  'First GR date'(065)
                     CHANGING i_fcat_repro.

* Last GR date
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zlgrdat  lc_tabname   lv_col_pos  'Last GR Date'(066)
                     CHANGING i_fcat_repro.

* Purchasing Document
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_ebeln  lc_tabname   lv_col_pos  'Purchasing Document'(067)
                     CHANGING i_fcat_repro.

* Material Document
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_mblnr  lc_tabname   lv_col_pos  'GR Material Document'(068)
                 CHANGING i_fcat_repro.

* Derived
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_xblnr  lc_tabname   lv_col_pos  'GR Idoc Number'(069)
                  CHANGING i_fcat_repro.

* Exception
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_message  lc_tabname   lv_col_pos  'GR Message'(070)
                  CHANGING i_fcat_repro.

* BOI on 16-oct-2017 by PBANDLAPAL for CR#590: ED2K909595
* GI Material Document
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zgi_mblnr  lc_tabname   lv_col_pos  'GI Material Document'(075)
                 CHANGING i_fcat_repro.

* GI Idoc Number
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat USING lc_fld_zgi_docnum  lc_tabname   lv_col_pos  'GI Idoc Number'(073)
                  CHANGING i_fcat_repro.

* GI Message
  lv_col_pos = lv_col_pos + 1.
  PERFORM f_build_fcat    USING  lc_fld_message_gi  lc_tabname   lv_col_pos  'GI Message'(074)
                  CHANGING i_fcat_repro.

* EOI on 16-oct-2017 by PBANDLAPAL for CR#590: ED2K909595

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_REPRO_INVEN_RECON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_get_repro_inven_recon .

  SELECT matnr            " Material Number
         werks            " Delivering Plant (Own or External)
         zadjtyp          " Adjustment Type
         zevent           " Event
         zdate            " Transactional date
         zseqno           " Sequence Num
         zsupplm          " Supplement
         zmaildt          " Mail Date
         zsohqty          " Stock On Hand
         zadjqty          " Adjustment Qty
         zprntrn          " Ordered Print Run
         zrcpt            " Receipt Qty
         zmainlbl         " Main Label Qty
         zoffline         " Offline Member Qty
         zconqty          " Contributor Qty
         zebo             " EBO Qty
         zsource          " Source file Name
         zsysdate         " System Date
         ismrefmdprod     " Higher-Level Media Product
         ismyearnr        " Media issue year number
         zfgrdat          " First GR date
         zlgrdat          " Last GR date
         ebeln            " Purchasing Document Number
         mblnr            " Number of Material Document
         xblnr            " Reference Document Number
* BOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909595
         zgi_docnum       " Goods Issue Idoc Number
         zgi_mblnr        " Goods Issue Material Document Number
* EOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909595
    FROM zqtc_inven_recon " Table for Inventory Reconciliation Data
    INTO TABLE  i_inven_recon
    WHERE matnr IN s_matnr
      AND werks IN s_plant
      AND ismrefmdprod IN s_medprd
* BOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909595
*      AND mblnr = space
*      AND xblnr NE space.
      AND ( mblnr = space
         AND xblnr NE space )
       OR ( zgi_docnum NE space
            AND zgi_mblnr = space ).
* EOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909595
  IF sy-subrc NE 0.
    MESSAGE s123(zqtc_r2) " No records found for the given input parameters
    DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSE. " ELSE -> IF sy-subrc NE 0
    IF p_publ IS NOT INITIAL .
      DELETE i_inven_recon WHERE ismyearnr <> p_publ.
    ENDIF. " IF p_publ IS NOT INITIAL
  ENDIF. " IF sy-subrc NE 0

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_REPRO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_populate_repro.

  DATA : lst_repro TYPE ty_repro,
         lst_idoc  TYPE ty_idoc.

  IF i_inven_recon IS NOT INITIAL.
    LOOP AT i_inven_recon INTO DATA(lst_inven).
      IF lst_inven-xblnr IS NOT INITIAL.    " Insert by PBANDLAPAL for CR#590
        lst_idoc-idoc_no = lst_inven-xblnr.
        APPEND lst_idoc TO i_idoc.
        CLEAR lst_idoc .
* BOI on 16-oct-2017 by PBANDLAPAL for CR#590: ED2K909595
      ENDIF.
      IF lst_inven-zgi_docnum IS NOT INITIAL.
        lst_idoc-idoc_no = lst_inven-zgi_docnum.
        APPEND lst_idoc TO i_idoc.
        CLEAR lst_idoc .
      ENDIF.
* EOI on 16-oct-2017 by PBANDLAPAL for CR#590: ED2K909595
    ENDLOOP. " LOOP AT i_inven_recon INTO DATA(lst_inven)

    IF i_idoc IS NOT INITIAL.
      SELECT docnum, " IDoc number
             logdat, " Date of status information
             logtim, " Time of status information
             countr, " IDoc status counter
             status, " Status of IDoc
             statxt, " Text for status code
             stapa1, " Parameter 1
             stapa2, " Parameter 1
             stapa3, " Parameter 1
             stapa4, " Parameter 1
             statyp, " Type of message(A,W,E,S,I)
             stamid, " Status message ID
             stamno  " Status message number
        FROM edids   " Status Record (IDoc)
        INTO TABLE @DATA(li_edids)
        FOR ALL ENTRIES IN @i_idoc
        WHERE docnum = @i_idoc-idoc_no.
      IF sy-subrc EQ 0.
        SORT li_edids BY docnum countr DESCENDING.
      ENDIF. " IF sy-subrc EQ 0
    ENDIF. " IF i_idoc IS NOT INITIAL
  ENDIF. " IF i_inven_recon IS NOT INITIAL

  LOOP AT i_inven_recon INTO lst_inven.
    MOVE-CORRESPONDING lst_inven TO lst_repro.
    lst_repro-sl_no = sy-tabix.
* BOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909595
    IF lst_repro-mblnr IS INITIAL.
* EOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909595
    READ TABLE li_edids INTO DATA(lst_edids) WITH KEY docnum = lst_inven-xblnr
                                                      BINARY SEARCH.
    IF sy-subrc EQ 0.
      MESSAGE ID lst_edids-stamid
       TYPE       lst_edids-statyp
       NUMBER     lst_edids-stamno
       INTO       lst_repro-message
       WITH       lst_edids-stapa1
                  lst_edids-stapa2
                  lst_edids-stapa3
                  lst_edids-stapa4.
    ENDIF. " IF sy-subrc EQ 0
* BOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909595
    ELSE.
      lst_repro-mblnr = space.
      lst_repro-xblnr = space.
    ENDIF.
* EOI by PBANDLAPAL on 18-Dec-2017 for ERP-5596: ED2K909595
* BOI on 16-oct-2017 by PBANDLAPAL for CR#590: ED2K909595
    IF lst_repro-zgi_mblnr IS INITIAL.
    CLEAR lst_edids.
    READ TABLE li_edids INTO lst_edids WITH KEY docnum = lst_inven-zgi_docnum
                                                        BINARY SEARCH.
    IF sy-subrc EQ 0.
      MESSAGE ID lst_edids-stamid
       TYPE       lst_edids-statyp
       NUMBER     lst_edids-stamno
       INTO       lst_repro-message_gi
       WITH       lst_edids-stapa1
                  lst_edids-stapa2
                  lst_edids-stapa3
                  lst_edids-stapa4.
    ENDIF. " IF sy-subrc EQ 0
    ELSE.
      lst_repro-zgi_mblnr = space.
      lst_repro-zgi_docnum = space.
    ENDIF.
* EOI on 16-oct-2017 by PBANDLAPAL for CR#590: ED2K909595
    APPEND lst_repro TO i_repro.
    CLEAR lst_repro.
  ENDLOOP. " LOOP AT i_inven_recon INTO lst_inven

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EXCEPTION_DETAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_FINAL1  text
*      -->P_LI_EKBE  text
*----------------------------------------------------------------------*
FORM f_get_exception_detail  USING    fp_lv_fail_gr    TYPE flag  " General Flag
                                      fp_lv_failgr_qty TYPE zrcpt " Receipt Qty
                                      fp_lst_final     TYPE ty_final1
                                      fp_lv_delv_com   TYPE flag  " General Flag
                                      fp_li_ekbe       TYPE tt_ekbe.

  DATA : lv_message TYPE char50, " Message of type CHAR50
         lv_qty     TYPE char17, " Qty of type CHAR17
         lv_line    TYPE i.      " Line of type Integers

*** 1st
  IF fp_lst_final-message IS INITIAL.
    IF fp_lv_fail_gr IS NOT INITIAL.
      CLEAR lv_qty.
      lv_qty = fp_lv_failgr_qty.
      CONCATENATE lv_qty
                   'Failed GR'(043)
                   INTO fp_lst_final-message
                   SEPARATED BY space.
    ENDIF. " IF fp_lv_fail_gr IS NOT INITIAL

  ENDIF. " IF fp_lst_final-message IS INITIAL

*2nd
  IF fp_lst_final-message IS INITIAL.
    IF fp_lst_final-menge_gr IS INITIAL
      AND fp_lst_final-confirmed IS NOT INITIAL
      AND fp_lst_final-menge IS INITIAL.
      fp_lst_final-message = 'Pending GR'(044).
    ENDIF. " IF fp_lst_final-menge_gr IS INITIAL
  ENDIF. " IF fp_lst_final-message IS INITIAL

  IF fp_lst_final-message IS INITIAL.
    IF fp_lv_delv_com IS INITIAL.
      IF fp_lst_final-menge NE fp_lst_final-menge_gr.
        DATA(lv_menge_diff) = fp_lst_final-menge - fp_lst_final-menge_gr.
        WRITE lv_menge_diff TO  lv_qty.
        IF lv_menge_diff GT 0.
          CONCATENATE lv_qty
                      'Open Qty'(072)
                      INTO lv_message
                      SEPARATED BY space.
          fp_lst_final-message = lv_message.
        ENDIF. " IF lv_menge_diff GT 0
      ENDIF. " IF fp_lst_final-menge NE fp_lst_final-menge_gr
    ENDIF. " IF fp_lv_delv_com IS INITIAL
  ENDIF. " IF fp_lst_final-message IS INITIAL

  IF fp_lst_final-message IS INITIAL .
    IF fp_lst_final-menge NE fp_lst_final-menge_gr.
      DATA(lv_menge_dif) = fp_lst_final-menge - fp_lst_final-menge_gr.
      WRITE lv_menge_dif TO  lv_qty.
      IF lv_menge_dif LT 0.
* Begin of Change by NPALLA on 18-Mar-2018 for RITM0096792 - ED1K909828.
*        lv_qty = lv_qty * ( -1 ).
        lv_menge_dif = lv_menge_dif * ( -1 ).
        WRITE lv_menge_dif TO  lv_qty.
* End of Change by NPALLA on 18-Mar-2018 for RITM0096792 - ED1K909828.
        CONCATENATE lv_qty
                   'Excess Receipt'(042)
                    INTO lv_message
                    SEPARATED BY space.
        fp_lst_final-message = lv_message.
      ENDIF. " IF lv_menge_dif LT 0
    ENDIF. " IF fp_lst_final-menge NE fp_lst_final-menge_gr
  ENDIF. " IF fp_lst_final-message IS INITIAL

**3rd
  IF fp_lst_final-message IS INITIAL.
    DATA(li_ekbe_tmp) = fp_li_ekbe[].
    DELETE li_ekbe_tmp WHERE ebeln <> fp_lst_final-ebeln
                         OR  ebelp <> fp_lst_final-ebelp.
    DESCRIBE TABLE li_ekbe_tmp LINES lv_line.
    IF lv_line > 1.
      fp_lst_final-message = 'Multiple GR'(045).
    ENDIF. " IF lv_line > 1
  ENDIF. " IF fp_lst_final-message IS INITIAL

* 4th
  IF fp_lst_final-message IS INITIAL.
* Check printer validation
    READ TABLE i_eord_print TRANSPORTING NO FIELDS
    WITH KEY matnr = fp_lst_final-matnr
             werks = fp_lst_final-werks
             lifnr = fp_lst_final-lifnr
    BINARY SEARCH.
    IF sy-subrc NE 0.
      fp_lst_final-message = 'Printer no longer Valid'(046).
    ENDIF. " IF sy-subrc NE 0
  ENDIF. " IF fp_lst_final-message IS INITIAL

* 5th
  IF fp_lst_final-message IS INITIAL.
* Check distributor validation
    READ TABLE i_eord TRANSPORTING NO FIELDS
    WITH KEY matnr = fp_lst_final-matnr
             werks = fp_lst_final-werks
             lifnr = fp_lst_final-emlif
    BINARY SEARCH.
    IF sy-subrc NE 0.
      fp_lst_final-message = 'Distributor no longer Valid'(047).
    ENDIF. " IF sy-subrc NE 0
  ENDIF. " IF fp_lst_final-message IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EXCEPTION_JDR_DETAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FP_LST_JDR_SUMM  text
*----------------------------------------------------------------------*
FORM f_get_exception_jdr_detail  USING
                                           fp_li_ekbe_tmp  TYPE tt_ekbe
                                CHANGING   fp_lst_jdr_detl TYPE ty_jdr_detl.

  DATA :  lv_line      TYPE i. " Line of type Integers

  IF fp_lst_jdr_detl-message IS INITIAL.
    DATA(li_ekbe_tmp) = fp_li_ekbe_tmp[].
    DELETE li_ekbe_tmp WHERE ebeln <> fp_lst_jdr_detl-ebeln
                         OR  ebelp <> fp_lst_jdr_detl-ebelp.
    DESCRIBE TABLE li_ekbe_tmp LINES lv_line.
    IF lv_line > 1.
      fp_lst_jdr_detl-message = 'Multiple GR'(045).
    ENDIF. " IF lv_line > 1
  ENDIF. " IF fp_lst_jdr_detl-message IS INITIAL

  IF fp_lst_jdr_detl-message IS INITIAL.
*Check distributor validation
    READ TABLE i_eord TRANSPORTING NO FIELDS WITH KEY matnr = fp_lst_jdr_detl-matnr
                                                      werks = fp_lst_jdr_detl-werks
                                                      lifnr = fp_lst_jdr_detl-emlif
                                                      BINARY SEARCH.
    IF sy-subrc NE 0.
      fp_lst_jdr_detl-message = 'Distributor no longer Valid'(047).
    ENDIF. " IF sy-subrc NE 0

  ENDIF. " IF fp_lst_jdr_detl-message IS INITIAL
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_EXCEPTION_JDR_SUMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LST_INVENT_RECON_REPT  text
*      <--P_LST_JDR_OFF  text
*----------------------------------------------------------------------*
FORM f_get_exception_jdr_summ  USING   fp_lc_event         TYPE zevent  " Event
                                       fp_lv_fail_gr       TYPE flag    " General Flag
                                       fp_lv_failgr_qty    TYPE menge_d " Quantity
                                       fp_lv_open_po_qty TYPE menge_d   " Quantity
                                       fp_lv_open_mat_qty TYPE menge_d  " Quantity
                                       fp_li_ekbe_mat   TYPE tt_ekbe
                               CHANGING fp_lst_jdr_summ    TYPE ty_jdr_summ.

  DATA : lv_qty     TYPE char17, " Qty of type CHAR17
         lv_message TYPE char50, " Message of type CHAR50
         lv_line    TYPE i.      " Line of type Integers

  CONSTANTS : lc_conf     TYPE zevent VALUE 'CONF'. " Event


  IF fp_lst_jdr_summ-message IS INITIAL.
    IF fp_lc_event = lc_conf.
*      IF fp_lst_jdr_summ-po_qty IS NOT INITIAL
*        AND fp_lst_jdr_summ-mat_qty IS INITIAL.
*        lv_qty = fp_lst_jdr_summ-po_qty.
*        CONCATENATE lv_qty
*                   'Failed GR'(043) INTO
*                   fp_lst_jdr_summ-message
*                   SEPARATED BY space.
*      ENDIF. " IF fp_lst_jdr_summ-po_qty IS NOT INITIAL

    ELSE. " ELSE -> IF fp_lc_event = lc_conf
      IF fp_lv_fail_gr IS NOT INITIAL.
        lv_qty = fp_lv_failgr_qty.
        CONCATENATE lv_qty
                    'Failed GR'(043) INTO
                    fp_lst_jdr_summ-message
                    SEPARATED BY space.
      ENDIF. " IF fp_lv_fail_gr IS NOT INITIAL

    ENDIF. " IF fp_lc_event = lc_conf
  ENDIF. " IF fp_lst_jdr_summ-message IS INITIAL

  IF fp_lst_jdr_summ-message IS INITIAL.
    IF fp_lv_open_po_qty NE fp_lv_open_mat_qty.
      DATA(lv_menge_diff) = fp_lv_open_po_qty - fp_lv_open_mat_qty.
      WRITE lv_menge_diff TO  lv_qty.
      IF lv_menge_diff GT 0.
        CONCATENATE lv_qty
                    'Open Qty'(072)
                    INTO lv_message
                    SEPARATED BY space.
        fp_lst_jdr_summ-message = lv_message.
      ENDIF. " IF lv_menge_diff GT 0
    ENDIF. " IF fp_lv_open_po_qty NE fp_lv_open_mat_qty
  ENDIF. " IF fp_lst_jdr_summ-message IS INITIAL

  IF fp_lst_jdr_summ-message IS INITIAL .
    IF fp_lst_jdr_summ-po_qty NE fp_lst_jdr_summ-mat_qty.
      DATA(lv_menge_dif) = fp_lst_jdr_summ-po_qty - fp_lst_jdr_summ-mat_qty.
      WRITE lv_menge_dif TO  lv_qty.
      IF lv_menge_dif LT 0.
* Begin of Change by NPALLA on 18-Mar-2018 for RITM0096792 - ED1K909828.
*        lv_qty = lv_qty * ( -1 ).
        lv_menge_dif = lv_menge_dif * ( -1 ).
        WRITE lv_menge_dif TO  lv_qty.
* End of Change by NPALLA on 18-Mar-2018 for RITM0096792 - ED1K909828.
        CONCATENATE lv_qty
                  'Excess Receipt'(042)
                    INTO lv_message
                    SEPARATED BY space.
        fp_lst_jdr_summ-message = lv_message.
      ENDIF. " IF lv_menge_dif LT 0
    ENDIF. " IF fp_lst_jdr_summ-po_qty NE fp_lst_jdr_summ-mat_qty
  ENDIF. " IF fp_lst_jdr_summ-message IS INITIAL


  IF fp_lst_jdr_summ-message IS INITIAL.
    DATA(li_ekbe_tmp) = fp_li_ekbe_mat[].
    DELETE li_ekbe_tmp WHERE matnr <> fp_lst_jdr_summ-matnr
                         OR werks <> fp_lst_jdr_summ-werks.
    DESCRIBE TABLE li_ekbe_tmp LINES lv_line.
    IF lv_line > 1.
      fp_lst_jdr_summ-message = 'Multiple GR'(045).
    ENDIF. " IF lv_line > 1
  ENDIF. " IF fp_lst_jdr_summ-message IS INITIAL

  IF fp_lst_jdr_summ-message IS INITIAL.
* Check distributor validation
    READ TABLE i_eord TRANSPORTING NO FIELDS
    WITH KEY matnr = fp_lst_jdr_summ-matnr
             werks = fp_lst_jdr_summ-werks
             lifnr = fp_lst_jdr_summ-emlif
    BINARY SEARCH.
    IF sy-subrc NE 0.
      fp_lst_jdr_summ-message = 'Distributor no longer Valid'(047).
    ENDIF. " IF sy-subrc NE 0
  ENDIF. " IF fp_lst_jdr_summ-message IS INITIAL


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_POPULATE_JDR_SUMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LI_EKPO_DROP  text
*      -->P_LC_JDR  text
*      -->P_LC_DROPSHIP  text
*      -->P_LI_EKBE  text
*      -->P_LI_EKBE_TMP  text
*      <--P_I_JDR_DETL  text
*      <--P_LST_JDR_DROP  text
*----------------------------------------------------------------------*
FORM f_populate_jdr_summ  USING    fp_lst_marc    TYPE ty_marc
                                   fp_lv_alpha    TYPE i      " Lv_alpha of type Integers
                                   fp_li_ekpo     TYPE tt_ekpo
                                   fp_lc_adj_type TYPE zadjtyp
                                   fp_lc_event    TYPE zevent " Event
                                   fp_li_ekbe     TYPE tt_ekbe
                                   fp_li_ekbe_tmp TYPE tt_ekbe
                                   fp_li_ekbe_mat TYPE tt_ekbe
                                   fp_lst_jdr_summ TYPE ty_jdr_summ
                                   fp_li_inven_recon TYPE tt_inven_recon
                          CHANGING fp_lv_cout_detl    TYPE i  " Lv_cout_detl of type Integers
                                   fp_lst_summ_event  TYPE ty_jdr_summ.

  CONSTANTS : lc_dropship TYPE zevent VALUE 'DROPSHIP', " Event
              lc_whstk    TYPE zevent VALUE 'WHSTK',    " Event
              lc_offline  TYPE zevent VALUE 'OFFLINE',  " Event
              lc_conf     TYPE zevent VALUE 'CONF'.     " Event

  DATA :  lv_zinven_qty   TYPE menge_d, " Quantity
          lv_po_qty       TYPE menge_d, " Quantity
          lv_open_po_qty  TYPE menge_d, " Quantity
          lv_mat_qty      TYPE menge_d, " Quantity
          lv_open_mat_qty TYPE menge_d, " Quantity
          lv_fail_gr      TYPE flag,    " General Flag
          lv_failgr_qty   TYPE menge_d. " Quantity

  DATA: lst_inven_recon TYPE ty_zqtc_inven_recon.

  IF  fp_lc_event EQ lc_conf.
    READ TABLE fp_li_ekpo TRANSPORTING NO FIELDS WITH KEY matnr = fp_lst_marc-matnr
                                                                werks = fp_lst_marc-werks
                                                                banfn = space
                                                                bnfpo = space
                                                                BINARY SEARCH.

  ELSE. " ELSE -> IF fp_lc_event EQ lc_conf
    READ TABLE fp_li_ekpo TRANSPORTING NO FIELDS WITH KEY
                                      matnr = fp_lst_marc-matnr
                                      werks = fp_lst_marc-werks
                                      BINARY SEARCH.
  ENDIF. " IF fp_lc_event EQ lc_conf

  IF sy-subrc EQ 0.
    DATA(lv_index) = sy-tabix.
    MOVE-CORRESPONDING fp_lst_jdr_summ TO fp_lst_summ_event.

* Populate Serial number
    fp_lst_summ_event-sl_no = sy-abcde+fp_lv_alpha(1).
    TRANSLATE fp_lst_summ_event-sl_no TO LOWER CASE.

    LOOP AT fp_li_ekpo INTO DATA(lst_ekpo) FROM lv_index.
      IF   lst_ekpo-matnr <> fp_lst_marc-matnr
        OR lst_ekpo-werks <> fp_lst_marc-werks.
        EXIT.
      ENDIF. " IF lst_ekpo-matnr <> fp_lst_marc-matnr
      lv_po_qty = lv_po_qty + lst_ekpo-menge.
      IF lst_ekpo-elikz IS INITIAL.
        lv_open_po_qty = lv_open_po_qty + lst_ekpo-menge.
      ENDIF. " IF lst_ekpo-elikz IS INITIAL
      fp_lst_summ_event-po_uom   = lst_ekpo-meins.
      fp_lst_summ_event-mat_uom  = lst_ekpo-meins.
      fp_lst_summ_event-jfds_uom = lst_ekpo-meins.
      fp_lst_summ_event-zevent   = fp_lc_event.

      PERFORM f_popualte_detail  USING lst_ekpo
                                       fp_li_ekbe
                                       fp_li_ekbe_tmp
                                       fp_lc_adj_type
                                       fp_li_inven_recon
                             CHANGING  fp_lst_summ_event
                                       lv_mat_qty
                                       lv_open_mat_qty
                                       fp_lv_cout_detl
                                       i_jdr_detl.

    ENDLOOP. " LOOP AT fp_li_ekpo INTO DATA(lst_ekpo) FROM lv_index

* this is not applicable for event conference
    IF  fp_lc_event NE lc_conf.
      CLEAR : lst_inven_recon.
      READ TABLE i_inven_recon TRANSPORTING NO FIELDS WITH KEY  zadjtyp = fp_lc_adj_type
                                                                matnr = fp_lst_marc-matnr
                                                                werks = fp_lst_marc-werks
                                                                BINARY SEARCH.
      IF sy-subrc EQ 0.
        DATA(lv_inven_index) = sy-tabix.
        LOOP AT i_inven_recon INTO lst_inven_recon FROM lv_inven_index.
          IF lst_inven_recon-zadjtyp <> fp_lc_adj_type
            OR lst_inven_recon-matnr <> fp_lst_marc-matnr
            OR lst_inven_recon-werks <> fp_lst_marc-werks.
            EXIT.
          ENDIF. " IF lst_inven_recon-zadjtyp <> fp_lc_adj_type

          IF fp_lc_event = lc_dropship.
            lv_zinven_qty = lv_zinven_qty +  lst_inven_recon-zmainlbl.
            IF lst_inven_recon-mblnr IS INITIAL
                AND lst_inven_recon-xblnr IS NOT INITIAL.
              lv_fail_gr = abap_true.
              lv_failgr_qty = lv_failgr_qty + lst_inven_recon-zmainlbl.
            ENDIF. " IF lst_inven_recon-mblnr IS INITIAL

          ELSEIF fp_lc_event = lc_whstk.
            lv_zinven_qty = lv_zinven_qty +  lst_inven_recon-zsohqty.
            IF lst_inven_recon-mblnr IS INITIAL
              AND lst_inven_recon-xblnr IS NOT INITIAL.
              lv_fail_gr = abap_true.
              lv_failgr_qty = lv_failgr_qty + lst_inven_recon-zsohqty.
            ENDIF. " IF lst_inven_recon-mblnr IS INITIAL

          ELSEIF  fp_lc_event = lc_offline.
            lv_zinven_qty = lv_zinven_qty +  lst_inven_recon-zoffline.
            IF lst_inven_recon-mblnr IS INITIAL
              AND lst_inven_recon-xblnr IS NOT INITIAL.
              lv_fail_gr = abap_true.
              lv_failgr_qty = lv_failgr_qty + lst_inven_recon-zoffline.
            ENDIF. " IF lst_inven_recon-mblnr IS INITIAL

          ENDIF. " IF fp_lc_event = lc_dropship
        ENDLOOP. " LOOP AT i_inven_recon INTO lst_inven_recon FROM lv_inven_index
      ENDIF. " IF sy-subrc EQ 0
      fp_lst_summ_event-jfds_qty = lv_zinven_qty.
      CLEAR lv_zinven_qty.
    ELSE. " ELSE -> IF fp_lc_event NE lc_conf
      fp_lst_summ_event-jfds_qty = lv_mat_qty.
    ENDIF. " IF fp_lc_event NE lc_conf

    fp_lst_summ_event-po_qty   = lv_po_qty.
    fp_lst_summ_event-mat_qty  = lv_mat_qty.

    IF fp_lc_event = lc_dropship.
      IF fp_lst_summ_event-mat_qty NE fp_lst_summ_event-jfds_qty.
        fp_lst_summ_event-message = 'Main label Variance'(071).
      ENDIF. " IF fp_lst_summ_event-mat_qty NE fp_lst_summ_event-jfds_qty
    ENDIF. " IF fp_lc_event = lc_dropship

    PERFORM f_get_exception_jdr_summ    USING  fp_lc_event
                                               lv_fail_gr
                                               lv_failgr_qty
                                               lv_open_po_qty
                                               lv_open_mat_qty
                                               fp_li_ekbe_mat
                                     CHANGING fp_lst_summ_event.

    CLEAR : lv_po_qty,
            lv_mat_qty,
            lv_open_po_qty,
            lv_open_mat_qty.
  ENDIF. " IF sy-subrc EQ 0

ENDFORM.
